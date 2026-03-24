import argparse
import asyncio
import hashlib
import importlib
import inspect
import json
import os
import re as _re
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable, Dict, Iterable, List, Optional, Tuple, Union

from autoplanbench_utils import ensure_domain_json, get_apb_root, sha256_file as _sha256_file
from translator_settings import (
  get_domain_setup_llm,
  get_domain_setup_subprocess_snapshot,
  get_nl2pddl_subprocess_snapshot,
  get_pddl2nl_timeout_seconds,
  reload_translator_config,
)
from dataset_contracts import (
  derive_section_key as _shared_derive_section_key,
  extract_sample_coords as _shared_extract_sample_coords,
  iter_dataset_samples as _shared_iter_dataset_samples,
  normalize_dataset_dir as _shared_normalize_dataset_dir,
  parse_example_id as _shared_parse_example_id,
  resolve_dataset_relative_path as _shared_resolve_dataset_relative_path,
)
from pipeline_usage import merge_pipeline_usage_into_run_data
from translators.pddl2pddl import (
  PDDL2PDDL_METRICS_TRANSLATOR_SPEC,
  PDDL2PDDL_PROMPT_TRANSLATOR_SPEC,
  is_pddl2pddl_translator_spec,
)

# Режим отладки: при --debug выводятся подробные сообщения о каждом этапе.
DEBUG = False


def _debug(msg: str) -> None:
  if DEBUG:
    ts = time.strftime("%H:%M:%S")
    print(f"[sembenchrunning][DEBUG] {ts} {msg}", flush=True)


def _resolve_ensure_domain_llm(ensure_domain_json_opts: Optional[Dict[str, Any]]) -> str:
  """
  Модель для run_domain_setup: из ensure_opts или translator_config.yaml / env
  (согласовано с вызовом ensure_domain_json).
  """
  if not ensure_domain_json_opts:
    return get_domain_setup_llm()
  raw = ensure_domain_json_opts.get("llm")
  if raw is None or str(raw).strip() == "":
    return get_domain_setup_llm()
  return str(raw)


def _nl2pddl_subprocess_settings() -> Dict[str, Any]:
  """Эффективные настройки вызова run_translate_nl2pddl (translator_config.yaml + env)."""
  return get_nl2pddl_subprocess_snapshot()


def _build_sembench_translator_meta_planning(
  *,
  translate_workers: int,
  prompt_translator_spec: str,
  translator_spec: Optional[str],
  domain_setup_seed: int,
  autoplanbench_llm: str,
  prompt_translator_signature: Optional[Dict[str, Any]] = None,
  run_snapshot: Optional[Dict[str, Any]] = None,
  benchmark_mode: Optional[str] = None,
) -> Dict[str, Any]:
  """Метаинфа для run JSON: этап планирования + снимок настроек NL2PDDL (env) + параметры прогона."""
  meta: Dict[str, Any] = {
    "version": 1,
    "translate_workers": int(translate_workers),
    "prompt_translator": prompt_translator_spec,
    "translator": translator_spec,
    "domain_setup_seed": int(domain_setup_seed),
    "autoplanbench_llm": autoplanbench_llm,
    "autoplanbench_root": os.environ.get("AUTOPLANBENCH_ROOT"),
    "domain_setup_subprocess": get_domain_setup_subprocess_snapshot(
      override_llm=autoplanbench_llm,
    ),
    "nl2pddl_subprocess": _nl2pddl_subprocess_settings(),
    "pddl2nl_sample": {"timeout_seconds": get_pddl2nl_timeout_seconds()},
  }
  if benchmark_mode:
    meta["benchmark_mode"] = str(benchmark_mode)
  if prompt_translator_signature:
    meta["prompt_translator_signature"] = dict(prompt_translator_signature)
  if run_snapshot:
    meta["run"] = dict(run_snapshot)
  return meta


# Вложенные dict в sembench_translator_meta сливаются, а не перезаписываются целиком.
_SEMBENCH_META_DICT_MERGE_KEYS = frozenset({
  "nl2pddl_subprocess",
  "domain_setup_subprocess",
  "pddl2nl_sample",
})


def _merge_sembench_translator_meta(payload: Dict[str, Any], patch: Dict[str, Any]) -> None:
  """Обновляет payload[\"sembench_translator_meta\"], не затирая известные поля."""
  cur = payload.get("sembench_translator_meta")
  if not isinstance(cur, dict):
    cur = {}
  merged = dict(cur)
  for k, v in patch.items():
    if v is None and k != "nl2pddl_subprocess":
      continue
    if k in _SEMBENCH_META_DICT_MERGE_KEYS and isinstance(v, dict):
      prev = merged.get(k)
      if isinstance(prev, dict):
        merged[k] = {**prev, **v}
      else:
        merged[k] = dict(v)
    elif v is not None:
      merged[k] = v
  payload["sembench_translator_meta"] = merged


def _write_run_json(
  path: Path,
  payload: Dict[str, Any],
  *,
  with_nl2pddl_debug: bool = False,
  dataset_dir: Optional[Path] = None,
  domain_setup_seed: int = 0,
) -> None:
  """
  Пишет run JSON и обновляет pipeline_usage.
  nl2pddl из *__nl2pddl_debug.json подмешивается только если with_nl2pddl_debug=True
  (после перевода или в фазе метрик), иначе при перезаписи планирования не подтянется старый debug.
  dataset_dir и domain_setup_seed нужны для чтения domain_llm_usage_seedN.json.
  """
  merge_pipeline_usage_into_run_data(
    path,
    payload,
    include_nl2pddl_from_debug=with_nl2pddl_debug,
    dataset_dir=dataset_dir,
    domain_setup_seed=domain_setup_seed,
  )
  path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


from openrouter_client import (
  InsufficientBalanceError,
  OpenRouterAPIError,
  OpenRouterClient,
  extract_openrouter_usage_from_error_body,
  get_model_config,
  load_config,
  load_openrouter_settings,
  openrouter_request_snapshot_from_model_cfg,
)


def _attach_recovered_openrouter_usage(payload: Dict[str, Any], error_body: Any) -> None:
  u = extract_openrouter_usage_from_error_body(error_body)
  if u:
    payload["openrouter_usage_recovered"] = u


@dataclass
class PromptItem:
  """Один запрос в бенчмарке."""

  id: str
  prompt: str


def _refresh_stored_run_json_meta_and_usage(
  out_path: Path,
  *,
  item: PromptItem,
  model_name: str,
  model_cfg: Dict[str, Any],
  dataset_dir: Optional[Path],
  domain_setup_seed: int,
  sembench_meta_planning: Optional[Dict[str, Any]],
) -> None:
  """
  Обновляет sembench_translator_meta, openrouter_request и pipeline_usage в существующем run JSON
  без повторного вызова LLM (resume / skip).
  """
  if not out_path.is_file():
    return
  try:
    prev = json.loads(out_path.read_text(encoding="utf-8"))
  except Exception:
    return
  if not isinstance(prev, dict):
    return
  prev["id"] = item.id
  prev["model_name"] = model_name
  prev["model"] = model_cfg.get("model")
  prev["openrouter_request"] = dict(openrouter_request_snapshot_from_model_cfg(model_cfg))
  if sembench_meta_planning:
    _merge_sembench_translator_meta(prev, sembench_meta_planning)
  dbg = out_path.with_name(out_path.stem + "__nl2pddl_debug.json")
  _write_run_json(
    out_path,
    prev,
    with_nl2pddl_debug=dbg.is_file(),
    dataset_dir=dataset_dir,
    domain_setup_seed=domain_setup_seed,
  )


def _normalize_dataset_dir(dataset_dir: Path) -> Path:
  return _shared_normalize_dataset_dir(dataset_dir)


def _iter_dataset_samples(dataset_dir: Path) -> Iterable[Path]:
  """Итерирует пути ко всем sample.json в датасете (data/<section>/<subsection>/<N>/sample.json)."""
  yield from _shared_iter_dataset_samples(dataset_dir)


def _refresh_pddl2nl_cache(dataset_dir: Path) -> int:
  """Удаляет все domain_and_problem_nl.txt в датасете. Возвращает число удалённых файлов."""
  cache_name = "domain_and_problem_nl.txt"
  removed = 0
  for sample_path in _iter_dataset_samples(dataset_dir):
    cache_file = sample_path.parent / cache_name
    if cache_file.is_file():
      try:
        cache_file.unlink()
        removed += 1
      except OSError:
        pass
  return removed


def _refresh_pddl2pddl_body_cache(dataset_dir: Path) -> int:
  """Удаляет кэш тел промпта PDDL→PDDL (planning_prompt_pddl_body.txt + .meta.json)."""
  names = ("planning_prompt_pddl_body.txt", "planning_prompt_pddl_body.meta.json")
  removed = 0
  for sample_path in _iter_dataset_samples(dataset_dir):
    for name in names:
      p = sample_path.parent / name
      if p.is_file():
        try:
          p.unlink()
          removed += 1
        except OSError:
          pass
  return removed


def _refresh_nl2pddl_cache(output_dir: Path) -> int:
  """Удаляет ключ plan_pred_pddl из всех run JSON в output_dir. Возвращает число обновлённых файлов."""
  run_files = [
    f for f in output_dir.rglob("*__*.json")
    if f.is_file() and not f.name.endswith("__nl2pddl_debug.json")
  ]
  updated = 0
  for path in run_files:
    try:
      data = json.loads(path.read_text(encoding="utf-8"))
      if "plan_pred_pddl" not in data:
        continue
      del data["plan_pred_pddl"]
      path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
      updated += 1
    except Exception:
      pass
  return updated


def _load_prompt_translator(spec: str) -> Callable[..., str]:
  """Загружает callable из строки module:function для PDDL->NL (построение промпта)."""
  mod_name, func_name = spec.split(":", 1)
  module = importlib.import_module(mod_name)
  return getattr(module, func_name)


_PACKAGE_PROMPT_DATA = Path(__file__).resolve().parent / "data"


def _load_prompt_template(
  dataset_dir: Path,
  *,
  max_depth: int = 10,
  pddl2pddl: bool = False,
) -> str:
  """
  Читает шаблон промпта из prompt_template.txt (или prompt_template_pddl2pddl.txt)
  в корне датасета или одном из родителей. Для PDDL→PDDL при отсутствии файла в датасете
  подставляется встроенный data/prompt_template_pddl2pddl.txt из пакета.
  """
  cur = dataset_dir.resolve()
  checked: List[Path] = []
  filename = "prompt_template_pddl2pddl.txt" if pddl2pddl else "prompt_template.txt"
  for _ in range(max_depth):
    path = cur / filename
    checked.append(path)
    if path.exists():
      return path.read_text(encoding="utf-8").strip()
    if cur.parent == cur:
      break
    cur = cur.parent
  if pddl2pddl:
    bundled = _PACKAGE_PROMPT_DATA / "prompt_template_pddl2pddl.txt"
    if bundled.is_file():
      print(
        f"[sembenchrunning] Using bundled PDDL→PDDL prompt template: {bundled}",
        flush=True,
      )
      return bundled.read_text(encoding="utf-8").strip()
  checked_str = ", ".join(str(p) for p in checked[:4])
  raise FileNotFoundError(
    "Шаблон промпта не найден. Проверены пути: "
    f"{checked_str}"
  )


def _sha256_text(value: str) -> str:
  return hashlib.sha256(value.encode("utf-8")).hexdigest()



def _prompt_translator_signature(
  prompt_translator: Callable[..., str],
  prompt_translator_spec: str,
) -> Dict[str, Any]:
  sig: Dict[str, Any] = {
    "spec": prompt_translator_spec,
    "module": getattr(prompt_translator, "__module__", None),
    "qualname": getattr(prompt_translator, "__qualname__", None),
  }
  try:
    src = inspect.getsourcefile(prompt_translator)
  except (TypeError, OSError):
    src = None
  if src:
    src_path = Path(src)
    sig["source_file"] = str(src_path.resolve())
    try:
      stat = src_path.stat()
      sig["source_mtime_ns"] = stat.st_mtime_ns
      sig["source_size"] = stat.st_size
    except OSError:
      pass
  return sig


def _build_pddl2nl_cache_signature(
  *,
  domain_pddl: str,
  problem_pddl: str,
  domain_nl_path: Optional[Path],
  translator_sig: Dict[str, Any],
) -> Dict[str, Any]:
  return {
    "version": 1,
    "domain_sha256": _sha256_text(domain_pddl),
    "problem_sha256": _sha256_text(problem_pddl),
    "domain_nl_sha256": _sha256_file(domain_nl_path),
    "translator": translator_sig,
  }


def _build_pddl2pddl_body_cache_signature(
  *,
  domain_pddl: str,
  problem_pddl: str,
  prompt_template: str,
  translator_sig: Dict[str, Any],
) -> Dict[str, Any]:
  return {
    "version": 1,
    "mode": "pddl2pddl",
    "domain_sha256": _sha256_text(domain_pddl),
    "problem_sha256": _sha256_text(problem_pddl),
    "prompt_template_sha256": _sha256_text(prompt_template),
    "translator": translator_sig,
  }


def _resolve_dataset_relative_path(dataset_dir: Path, raw_path: Optional[Union[str, Path]]) -> Optional[Path]:
  """Резолвит путь из sample.json относительно dataset root, с fallback по suffix match."""
  return _shared_resolve_dataset_relative_path(dataset_dir, raw_path)


def _extract_sample_coords(
  sample: Dict[str, Any],
  example_id: str,
) -> Tuple[str, str, Optional[Union[int, str]]]:
  return _shared_extract_sample_coords(sample, example_id)


def _derive_section_key(
  sample: Dict[str, Any],
  *,
  section: str,
  subsection: str,
  sample_index: Optional[Union[int, str]],
) -> str:
  return _shared_derive_section_key(
    sample,
    section=section,
    subsection=subsection,
    sample_index=sample_index,
  )


def _resolve_sample_dir(
  dataset_dir: Path,
  section: str,
  subsection: str,
  sample_index: Optional[Union[int, str]] = None,
  *,
  example_id: Optional[str] = None,
) -> Optional[Path]:
  direct_candidates: List[Path] = []
  base = dataset_dir / section / subsection
  if sample_index is not None:
    direct_candidates.append(base / str(sample_index))
  else:
    direct_candidates.append(base)
  for candidate in direct_candidates:
    if (candidate / "sample.json").exists():
      return candidate

  for sample_path in _iter_dataset_samples(dataset_dir):
    try:
      sample = json.loads(sample_path.read_text(encoding="utf-8"))
    except Exception:
      continue
    if example_id and str(sample.get("id") or "") == example_id:
      return sample_path.parent
    sample_section, sample_subsection, sample_idx = _extract_sample_coords(
      sample,
      str(sample.get("id") or ""),
    )
    if sample_section != section or sample_subsection != subsection:
      continue
    if sample_index is None:
      if sample_idx is None:
        return sample_path.parent
      continue
    if str(sample_idx) == str(sample_index):
      return sample_path.parent
  return None


def _provider_error_from_response(response_json: Dict[str, Any]) -> Optional[Dict[str, Any]]:
  try:
    choices = response_json.get("choices")
    if not isinstance(choices, list) or not choices:
      return None
    choice0 = choices[0]
    err = choice0.get("error")
    return err if isinstance(err, dict) and err else None
  except (AttributeError, IndexError, TypeError):
    return None


def _callable_accepts_param(func: Callable, name: str) -> bool:
  """Check if *func* accepts a keyword argument *name* (or **kwargs)."""
  try:
    sig = inspect.signature(func)
  except (ValueError, TypeError):
    return False
  for p in sig.parameters.values():
    if p.name == name:
      return True
    if p.kind == inspect.Parameter.VAR_KEYWORD:
      return True
  return False


def _get_domain_problem_nl(
  prompt_translator: Callable[..., str],
  domain_pddl: str,
  problem_pddl: str,
  sample: Dict[str, Any],
  domain_path: Optional[Path] = None,
  problem_path: Optional[Path] = None,
  domain_nl_path: Optional[Path] = None,
) -> str:
  """Возвращает только NL-перевод домена/задачи (без шаблона промпта)."""
  kwargs: Dict[str, Optional[str]] = {}
  if domain_path is not None and _callable_accepts_param(prompt_translator, "domain_path"):
    kwargs["domain_path"] = str(domain_path)
  if problem_path is not None and _callable_accepts_param(prompt_translator, "problem_path"):
    kwargs["problem_path"] = str(problem_path)
  if domain_nl_path is not None and _callable_accepts_param(prompt_translator, "domain_nl_path"):
    kwargs["domain_nl_path"] = str(domain_nl_path)
  if kwargs:
    return str(prompt_translator(domain_pddl, problem_pddl, **kwargs))
  if _callable_accepts_param(prompt_translator, "sample"):
    return str(prompt_translator(domain_pddl, problem_pddl, sample))
  return str(prompt_translator(domain_pddl, problem_pddl))


def _build_prompt_from_sample(
  prompt_template: str,
  prompt_translator: Callable[..., str],
  sample: Dict[str, Any],
  domain_pddl: str,
  problem_pddl: str,
  domain_path: Optional[Path] = None,
  problem_path: Optional[Path] = None,
  domain_nl_path: Optional[Path] = None,
) -> str:
  """
  Строит промпт: шаблон (из prompt_template.txt) + NL-перевод домена/задачи.
  """
  translated = _get_domain_problem_nl(
    prompt_translator, domain_pddl, problem_pddl, sample,
    domain_path=domain_path, problem_path=problem_path, domain_nl_path=domain_nl_path,
  )
  return f"{prompt_template}\n\n{translated}".strip()


def _build_all_prompts(
  dataset_dir: Path,
  prompt_template: str,
  prompt_translator: Callable[..., str],
  prompt_translator_spec: str,
  ensure_domain_json_opts: Optional[Dict[str, Any]],
  limit: Optional[int],
  translate_workers: int,
  *,
  pddl_direct: bool = False,
) -> Tuple[List[Tuple[str, str]], int]:
  """
  Собирает все промпты: при pddl_direct — только тело из PDDL (кэш planning_prompt_pddl_body.*),
  без domain setup и без APB. Иначе: domain setup по section_key, затем PDDL→NL параллельно (ThreadPool).
  Возвращает ([(example_id, prompt), ...], число пропущенных).
  """
  from dataclasses import dataclass as _dc

  @_dc
  class _WorkItem:
    example_id: str
    sample_path: Path
    sample: Dict[str, Any]
    sample_dir: Path
    domain_file: Path
    problem_file: Path
    domain_pddl: str
    problem_pddl: str
    cached_nl: Path
    rel: Any
    section: str
    subsection: str
    section_key: str
    domain_nl_path_val: Optional[Path]
    cache_meta: Path
    cache_signature: Dict[str, Any]
    cache_is_valid: bool

  work_items: List[_WorkItem] = []
  failed_section_keys: set = set()
  skipped_count = 0
  translator_sig = _prompt_translator_signature(prompt_translator, prompt_translator_spec)

  _debug("Scanning dataset for sample.json files...")
  for sample_path in _iter_dataset_samples(dataset_dir):
    sample_dir = sample_path.parent
    try:
      sample = json.loads(sample_path.read_text(encoding="utf-8"))
    except Exception:
      skipped_count += 1
      continue
    example_id = str(sample.get("id") or "")
    if not example_id:
      skipped_count += 1
      continue
    rel = sample_path.relative_to(dataset_dir)
    section, subsection, sample_index = _extract_sample_coords(sample, example_id)
    domain_path = sample.get("domain_path")
    problem_path = sample.get("problem_path")
    if not domain_path or not problem_path:
      skipped_count += 1
      continue
    domain_file = sample_dir / str(domain_path)
    problem_file = sample_dir / str(problem_path)
    if not domain_file.exists() or not problem_file.exists():
      skipped_count += 1
      continue
    domain_pddl = domain_file.read_text(encoding="utf-8")
    problem_pddl = problem_file.read_text(encoding="utf-8")
    if pddl_direct:
      cached_nl = sample_dir / "planning_prompt_pddl_body.txt"
      cache_meta = sample_dir / "planning_prompt_pddl_body.meta.json"
      domain_nl_path_val = None
      domain_nl_path_existing = None
      cache_signature = _build_pddl2pddl_body_cache_signature(
        domain_pddl=domain_pddl,
        problem_pddl=problem_pddl,
        prompt_template=prompt_template,
        translator_sig=translator_sig,
      )
    else:
      cached_nl = sample_dir / "domain_and_problem_nl.txt"
      cache_meta = sample_dir / "domain_and_problem_nl.meta.json"
      domain_nl_path_val = _resolve_dataset_relative_path(dataset_dir, sample.get("domain_nl_path"))
      domain_nl_path_existing = domain_nl_path_val if domain_nl_path_val and domain_nl_path_val.exists() else None
      cache_signature = _build_pddl2nl_cache_signature(
        domain_pddl=domain_pddl,
        problem_pddl=problem_pddl,
        domain_nl_path=domain_nl_path_existing,
        translator_sig=translator_sig,
      )
    cache_is_valid = False
    if cached_nl.exists() and cache_meta.exists():
      try:
        cache_raw = json.loads(cache_meta.read_text(encoding="utf-8"))
        cache_is_valid = isinstance(cache_raw, dict) and cache_raw == cache_signature
      except Exception:
        cache_is_valid = False
    section_key = _derive_section_key(
      sample,
      section=section,
      subsection=subsection,
      sample_index=sample_index,
    )
    work_items.append(_WorkItem(
      example_id=example_id, sample_path=sample_path, sample=sample, sample_dir=sample_dir,
      domain_file=domain_file, problem_file=problem_file, domain_pddl=domain_pddl, problem_pddl=problem_pddl,
      cached_nl=cached_nl, rel=rel, section=section, subsection=subsection, section_key=section_key,
      domain_nl_path_val=domain_nl_path_existing,
      cache_meta=cache_meta,
      cache_signature=cache_signature,
      cache_is_valid=cache_is_valid,
    ))

  _debug(
    f"Dataset scan: {len(work_items)} valid samples (domain+problem); "
    f"skipped during scan: {skipped_count}",
  )

  if limit is not None and limit > 0:
    allowed_ids = _example_ids_limit_per_section(dataset_dir, limit)
    work_items = [w for w in work_items if w.example_id in allowed_ids]
    work_items.sort(key=lambda w: str(w.sample_path.resolve()))
    _debug(f"--limit {limit} per section -> {len(work_items)} samples to process")
    for w in work_items:
      _debug(f"  sample: {w.example_id} at {w.sample_path.relative_to(dataset_dir)}")

  need_setup: Dict[str, Path] = {}
  if not pddl_direct:
    for w in work_items:
      if (
        (w.domain_nl_path_val is None or not w.domain_nl_path_val.exists())
        and w.section_key
        and w.section_key not in failed_section_keys
      ):
        need_setup[w.section_key] = w.domain_file

  if ensure_domain_json_opts and need_setup:
    apb_root = ensure_domain_json_opts.get("apb_root")
    if apb_root and apb_root.is_dir():
      seed = int(ensure_domain_json_opts.get("seed", 0))
      llm = _resolve_ensure_domain_llm(ensure_domain_json_opts)
      _debug(f"Domain setup: {len(need_setup)} sections need domain_description_seed{seed}.json")
      for section_key in sorted(need_setup.keys()):
        if section_key in failed_section_keys:
          continue
        domain_file = need_setup[section_key]
        problem_file = next((w.problem_file for w in work_items if w.section_key == section_key), None)
        if not problem_file:
          continue
        _debug(f"  ensure_domain_json section={section_key!r} llm={llm} ...")
        try:
          ensure_domain_json(
            dataset_dir, section_key, domain_file, problem_file,
            apb_root, llm, seed, log_prefix="[sembenchrunning]",
          )
          rel_json = f"{section_key}/domain_description_seed{seed}.json"
          domain_nl_path_new = dataset_dir / rel_json
          for w in work_items:
            if w.section_key == section_key and (w.sample.get("domain_nl_path") or "") != rel_json:
              w.sample["domain_nl_path"] = rel_json
              w.sample_path.write_text(json.dumps(w.sample, ensure_ascii=False, indent=2), encoding="utf-8")
            if w.section_key == section_key:
              w.domain_nl_path_val = domain_nl_path_new
        except Exception as e:
          failed_section_keys.add(section_key)
          print(f"[sembenchrunning] Section {section_key!r}: domain setup failed, skipping section ({e})", flush=True)
        else:
          _debug(f"  domain_description created for {section_key!r}")

  work_items = [w for w in work_items if w.section_key not in failed_section_keys]
  _debug(f"Work items after setup: {len(work_items)} (limit={limit})")

  for w in work_items:
    if pddl_direct:
      w.cache_signature = _build_pddl2pddl_body_cache_signature(
        domain_pddl=w.domain_pddl,
        problem_pddl=w.problem_pddl,
        prompt_template=prompt_template,
        translator_sig=translator_sig,
      )
    else:
      domain_nl_path_existing = w.domain_nl_path_val if w.domain_nl_path_val and w.domain_nl_path_val.exists() else None
      w.cache_signature = _build_pddl2nl_cache_signature(
        domain_pddl=w.domain_pddl,
        problem_pddl=w.problem_pddl,
        domain_nl_path=domain_nl_path_existing,
        translator_sig=translator_sig,
      )
    if w.cached_nl.exists() and w.cache_meta.exists():
      try:
        cache_raw = json.loads(w.cache_meta.read_text(encoding="utf-8"))
        w.cache_is_valid = isinstance(cache_raw, dict) and cache_raw == w.cache_signature
      except Exception:
        w.cache_is_valid = False
    else:
      w.cache_is_valid = False

  need_translate = [w for w in work_items if not w.cached_nl.exists() or not w.cache_is_valid]
  from_cache = [w for w in work_items if w.cached_nl.exists() and w.cache_is_valid]
  phase_label = "PDDL→PDDL body" if pddl_direct else "PDDL→NL"
  _debug(f"{phase_label}: {len(need_translate)} to build, {len(from_cache)} from cache")

  def _translate_and_cache(w: _WorkItem) -> Tuple[str, str]:
    """Строит тело промпта (NL или сырой PDDL-блок) и кеширует. Возвращает (example_id, text)."""
    _debug(f"  {phase_label} building {w.example_id} ...")
    t = _get_domain_problem_nl(
      prompt_translator, w.domain_pddl, w.problem_pddl, w.sample,
      domain_path=w.domain_file.resolve(),
      problem_path=w.problem_file.resolve(),
      domain_nl_path=w.domain_nl_path_val.resolve() if w.domain_nl_path_val else None,
    )
    try:
      w.cached_nl.write_text(t, encoding="utf-8")
      w.cache_meta.write_text(json.dumps(w.cache_signature, ensure_ascii=False, indent=2), encoding="utf-8")
    except OSError:
      pass
    _debug(f"  {phase_label} done {w.example_id}")
    return (w.example_id, t)

  results: Dict[str, str] = {}
  if need_translate and translate_workers > 0:
    print(f"[sembenchrunning] {phase_label}: {len(need_translate)} samples in parallel (workers={translate_workers})...", flush=True)
    with ThreadPoolExecutor(max_workers=translate_workers) as ex:
      futures = {ex.submit(_translate_and_cache, w): w for w in need_translate}
      for fut in as_completed(futures):
        try:
          eid, translated = fut.result()
          if translated:
            results[eid] = translated
          else:
            skipped_count += 1
        except Exception as e:
          w = futures[fut]
          print(f"[sembenchrunning] Skip {w.example_id}: prompt builder error ({e})", flush=True)
          skipped_count += 1
  else:
    for w in need_translate:
      try:
        eid, translated = _translate_and_cache(w)
        if translated:
          results[eid] = translated
        else:
          skipped_count += 1
      except Exception as e:
        print(f"[sembenchrunning] Skip {w.example_id}: prompt builder error ({e})", flush=True)
        skipped_count += 1

  out: List[Tuple[str, str]] = []
  _debug(f"Building prompt list: {len(from_cache)} from cache, {len(results)} from build")
  for w in from_cache:
    try:
      _debug(f"  load cache {w.example_id} from {w.cached_nl.name}")
      translated = w.cached_nl.read_text(encoding="utf-8").strip()
      out.append((w.example_id, f"{prompt_template}\n\n{translated}".strip()))
    except OSError:
      skipped_count += 1
  for eid in results:
    if results[eid]:
      out.append((eid, f"{prompt_template}\n\n{results[eid]}".strip()))
    else:
      skipped_count += 1
  return (out, skipped_count)


async def run_for_model_from_dataset(
  cfg: Dict[str, Any],
  model_name: str,
  dataset_dir: Path,
  prompt_translator_spec: str,
  output_dir: Path,
  max_concurrent: int | None = None,
  batch_size: int | None = None,
  limit: int | None = None,
  ensure_domain_json_opts: Optional[Dict[str, Any]] = None,
  translate_workers: int = 2,
  translator_spec: Optional[str] = None,
  rerun_truncated: bool = False,
  rerun_all: bool = False,
  domain_setup_seed: int = 0,
  models_config_path: Optional[Path] = None,
  pddl2pddl: bool = False,
) -> None:
  """
  Запускает все сэмплы из датасета для указанной модели.
  Сначала собирает промпты (PDDL→NL или PDDL→PDDL body при pddl2pddl), затем шлёт батчи в LLM.
  """
  settings = load_openrouter_settings(cfg)
  model_cfg = get_model_config(cfg, model_name)

  if max_concurrent is not None and max_concurrent > 0:
    settings.max_concurrent_requests = max_concurrent

  effective_batch_size = batch_size if batch_size and batch_size > 0 else 1000
  output_dir.mkdir(parents=True, exist_ok=True)
  semaphore = asyncio.Semaphore(settings.max_concurrent_requests)

  mcfg_path_str: Optional[str] = None
  if models_config_path is not None:
    try:
      mcfg_path_str = str(Path(models_config_path).resolve())
    except OSError:
      mcfg_path_str = str(models_config_path)

  run_snapshot: Dict[str, Any] = {
    "phase": "planning",
    "model_name_key": model_name,
    "openrouter_model_id": model_cfg.get("model"),
    "output_dir": str(output_dir.resolve()),
    "dataset_dir": str(Path(dataset_dir).resolve()),
    "batch_size": int(effective_batch_size),
    "max_concurrent_requests": int(settings.max_concurrent_requests),
    "limit": limit,
    "rerun_all": bool(rerun_all),
    "rerun_truncated": bool(rerun_truncated),
    "models_config_path": mcfg_path_str,
  }

  prompt_translator = _load_prompt_translator(prompt_translator_spec)
  prompt_template = _load_prompt_template(dataset_dir, pddl2pddl=pddl2pddl)
  prompt_translator_sig = _prompt_translator_signature(prompt_translator, prompt_translator_spec)
  sembench_meta_planning = _build_sembench_translator_meta_planning(
    translate_workers=translate_workers,
    prompt_translator_spec=prompt_translator_spec,
    translator_spec=translator_spec,
    domain_setup_seed=int(domain_setup_seed),
    autoplanbench_llm=_resolve_ensure_domain_llm(ensure_domain_json_opts),
    prompt_translator_signature=prompt_translator_sig,
    run_snapshot=run_snapshot,
    benchmark_mode="pddl2pddl" if pddl2pddl else None,
  )

  print(
    f"[sembenchrunning] Run start (dataset): model='{model_name}', "
    f"dataset_dir='{dataset_dir}', output_dir='{output_dir}', "
    f"batch_size={effective_batch_size}, "
    f"max_concurrent={settings.max_concurrent_requests}, "
    f"translate_workers={translate_workers}, "
    f"limit={limit if limit is not None else 'all'}, "
    f"rerun_all={rerun_all}, rerun_truncated={rerun_truncated}",
    flush=True,
  )

  prompt_list, skipped_count = _build_all_prompts(
    dataset_dir, prompt_template, prompt_translator,
    prompt_translator_spec, ensure_domain_json_opts, limit, translate_workers,
    pddl_direct=pddl2pddl,
  )
  if skipped_count:
    print(f"[sembenchrunning] Prompt build skipped {skipped_count} samples.", flush=True)
  _debug(f"Run phase: {len(prompt_list)} prompts to send to OpenRouter (batch_size={effective_batch_size})")
  current_batch: List[PromptItem] = []
  processed_count = 0
  batch_index = 0

  async with OpenRouterClient(settings) as client:
    for example_id, prompt in prompt_list:
      current_batch.append(PromptItem(id=example_id, prompt=prompt))
      processed_count += 1
      _debug(f"  queued id={example_id} prompt_len={len(prompt)}")

      if len(current_batch) >= effective_batch_size:
        batch_index += 1
        _debug(f"Batch #{batch_index}: sending {len(current_batch)} requests (ids: {[x.id for x in current_batch]})")
        print(
          f"[sembenchrunning] Model '{model_name}': starting batch #{batch_index} "
          f"({len(current_batch)} samples, total built={processed_count})",
          flush=True,
        )
        await _process_batch(
          client=client,
          model_name=model_name,
          model_cfg=model_cfg,
          batch=current_batch,
          output_dir=output_dir,
          semaphore=semaphore,
          rerun_truncated=rerun_truncated,
          rerun_all=rerun_all,
          dataset_dir=dataset_dir,
          domain_setup_seed=int(domain_setup_seed),
          sembench_meta_planning=sembench_meta_planning,
        )
        print(
          f"[sembenchrunning] Model '{model_name}': batch #{batch_index} completed.",
          flush=True,
        )
        current_batch = []

    if current_batch:
      batch_index += 1
      print(
        f"[sembenchrunning] Model '{model_name}': starting final batch "
        f"#{batch_index} ({len(current_batch)} samples, total built={processed_count})",
        flush=True,
      )
      await _process_batch(
        client=client,
        model_name=model_name,
        model_cfg=model_cfg,
        batch=current_batch,
        output_dir=output_dir,
        semaphore=semaphore,
        rerun_truncated=rerun_truncated,
        rerun_all=rerun_all,
        dataset_dir=dataset_dir,
        domain_setup_seed=int(domain_setup_seed),
        sembench_meta_planning=sembench_meta_planning,
      )
      print(
        f"[sembenchrunning] Model '{model_name}': final batch #{batch_index} completed.",
        flush=True,
      )

  if processed_count == 0:
    raise SystemExit("Не найдено ни одного сэмпла в датасете (sample.json).")
  print(
    f"[sembenchrunning] Run finished: model='{model_name}', processed_samples={processed_count}, batches={batch_index}",
    flush=True,
  )


async def _process_batch(
  client: OpenRouterClient,
  model_name: str,
  model_cfg: Dict[str, Any],
  batch: List[PromptItem],
  output_dir: Path,
  semaphore: asyncio.Semaphore,
  rerun_truncated: bool = False,
  rerun_all: bool = False,
  dataset_dir: Optional[Path] = None,
  domain_setup_seed: int = 0,
  sembench_meta_planning: Optional[Dict[str, Any]] = None,
) -> None:
  """Запускает один батч промптов параллельно."""
  _debug(f"_process_batch: {len(batch)} items, creating asyncio tasks")
  print(
    f"[sembenchrunning] Model '{model_name}': launching {len(batch)} tasks in batch...",
    flush=True,
  )
  tasks: List[asyncio.Task[None]] = []
  for item in batch:
    _debug(f"  submit task id={item.id}")
    tasks.append(
      asyncio.create_task(
        _run_single_prompt(
          client=client,
          model_name=model_name,
          model_cfg=model_cfg,
          item=item,
          output_dir=output_dir,
          semaphore=semaphore,
          rerun_truncated=rerun_truncated,
          rerun_all=rerun_all,
          dataset_dir=dataset_dir,
          domain_setup_seed=domain_setup_seed,
          sembench_meta_planning=sembench_meta_planning,
        )
      )
    )
  await asyncio.gather(*tasks)


async def _run_single_prompt(
  client: OpenRouterClient,
  model_name: str,
  model_cfg: Dict[str, Any],
  item: PromptItem,
  output_dir: Path,
  semaphore: asyncio.Semaphore,
  rerun_truncated: bool = False,
  rerun_all: bool = False,
  dataset_dir: Optional[Path] = None,
  domain_setup_seed: int = 0,
  sembench_meta_planning: Optional[Dict[str, Any]] = None,
) -> None:
  """Отправляет один промпт в OpenRouter и сохраняет JSON‑лог."""
  # Один файл на (id, модель). id в промптах — через подчёркивание; в модели '/' заменяем на '_'.
  safe_model_name = model_name.replace("/", "_")
  if "__" in safe_model_name:
    raise ValueError(
      f"Model name {model_name!r} produces safe name {safe_model_name!r} containing '__', "
      f"which conflicts with filename parsing convention."
    )
  out_path = output_dir / f"{item.id}__{safe_model_name}.json"
  openrouter_req_snap = openrouter_request_snapshot_from_model_cfg(model_cfg)

  # Примитивный "resume": если файл есть — пропускаем (если не --rerun и не --rerun-truncated для обрезанных).
  if out_path.exists() and not rerun_all:
    if not rerun_truncated:
      _debug(f"  skip id={item.id}: existing {out_path.name} (use --rerun to regenerate)")
      _refresh_stored_run_json_meta_and_usage(
        out_path,
        item=item,
        model_name=model_name,
        model_cfg=model_cfg,
        dataset_dir=dataset_dir,
        domain_setup_seed=domain_setup_seed,
        sembench_meta_planning=sembench_meta_planning,
      )
      return
    try:
      prev = json.loads(out_path.read_text(encoding="utf-8"))
      if isinstance(prev, dict) and "error" in prev:
        _debug(f"  rerun id={item.id}: previous run had error")
        pass
      else:
        resp = prev.get("openrouter_response", {}) if isinstance(prev, dict) else {}
        if isinstance(resp, dict) and _provider_error_from_response(resp) is not None:
          _debug(f"  rerun id={item.id}: provider error in choices[0].error")
          pass
        else:
          choice0 = (resp.get("choices") or [{}])[0] if isinstance(resp.get("choices"), list) else {}
          finish_reason = choice0.get("finish_reason") or choice0.get("native_finish_reason")
          if finish_reason not in ("length", "max_output_tokens"):
            _debug(f"  skip id={item.id}: finish_reason={finish_reason!r} (not truncated)")
            _refresh_stored_run_json_meta_and_usage(
              out_path,
              item=item,
              model_name=model_name,
              model_cfg=model_cfg,
              dataset_dir=dataset_dir,
              domain_setup_seed=domain_setup_seed,
              sembench_meta_planning=sembench_meta_planning,
            )
            return
          _debug(f"  rerun id={item.id}: finish_reason={finish_reason!r}")
    except Exception:
      pass

  _debug(f"  sending request id={item.id} -> {out_path.name} ...")
  t0 = time.time()
  async with semaphore:
    try:
      response_json = await client.generate_plan(model_cfg=model_cfg, prompt=item.prompt)
      _debug(f"  response received id={item.id} in {time.time() - t0:.1f}s")
      payload: Dict[str, Any] = {
        "id": item.id,
        "model_name": model_name,
        "model": model_cfg["model"],
        "openrouter_request": dict(openrouter_req_snap),
        # Полный промпт не дублируем для экономии места, но сохраняем хэш и
        # короткий превью для отладки и воспроизводимости (позволяет понять,
        # изменился ли промпт между прогонами).
        "prompt_sha256": _sha256_text(item.prompt),
        "prompt_preview": item.prompt[:300],
        "openrouter_response": response_json,
      }
      if sembench_meta_planning:
        _merge_sembench_translator_meta(payload, sembench_meta_planning)
      provider_error = _provider_error_from_response(response_json)
      if provider_error is not None:
        payload["error"] = {
          "type": "ProviderResponseError",
          "message": str(provider_error.get("message") or provider_error),
          "provider_error": provider_error,
        }
        _write_run_json(out_path, payload, dataset_dir=dataset_dir, domain_setup_seed=domain_setup_seed)
        return
    except InsufficientBalanceError as exc:
      # Логируем, что именно произошло, и пробрасываем дальше, чтобы остановить скрипт.
      print(
        f"[sembenchrunning] Model '{model_name}': insufficient credits error on request id='{item.id}': {exc}",
        flush=True,
      )
      payload = {
        "id": item.id,
        "model_name": model_name,
        "model": model_cfg["model"],
        "openrouter_request": dict(openrouter_req_snap),
        "error": {
          "type": type(exc).__name__,
          "message": str(exc),
          "status_code": getattr(exc, "status_code", None),
          "openrouter_error": getattr(exc, "error_body", None),
        },
      }
      if sembench_meta_planning:
        _merge_sembench_translator_meta(payload, sembench_meta_planning)
      _attach_recovered_openrouter_usage(payload, getattr(exc, "error_body", None))
      _write_run_json(out_path, payload, dataset_dir=dataset_dir, domain_setup_seed=domain_setup_seed)
      raise
    except OpenRouterAPIError as exc:
      # Структурированное логирование API‑ошибки OpenRouter.
      print(
        f"[sembenchrunning] Model '{model_name}': OpenRouterAPIError on request id='{item.id}': {exc}",
        flush=True,
      )
      payload = {
        "id": item.id,
        "model_name": model_name,
        "model": model_cfg["model"],
        "openrouter_request": dict(openrouter_req_snap),
        "error": {
          "type": type(exc).__name__,
          "message": str(exc),
          "status_code": getattr(exc, "status_code", None),
          "openrouter_error": getattr(exc, "error_body", None),
        },
      }
      if sembench_meta_planning:
        _merge_sembench_translator_meta(payload, sembench_meta_planning)
      _attach_recovered_openrouter_usage(payload, getattr(exc, "error_body", None))
      _write_run_json(out_path, payload, dataset_dir=dataset_dir, domain_setup_seed=domain_setup_seed)
      return
    except Exception as exc:
      # Любая другая ошибка (сети, сериализация и т.п.)
      print(
        f"[sembenchrunning] Model '{model_name}': unexpected error on request id='{item.id}': {exc}",
        flush=True,
      )
      payload = {
        "id": item.id,
        "model_name": model_name,
        "model": model_cfg["model"],
        "openrouter_request": dict(openrouter_req_snap),
        "error": {
          "type": type(exc).__name__,
          "message": str(exc),
        },
      }
      if sembench_meta_planning:
        _merge_sembench_translator_meta(payload, sembench_meta_planning)
      _write_run_json(out_path, payload, dataset_dir=dataset_dir, domain_setup_seed=domain_setup_seed)
      return

  _debug(f"  write id={item.id} -> {out_path.name} ({len(str(payload))} chars)")
  _write_run_json(out_path, payload, dataset_dir=dataset_dir, domain_setup_seed=domain_setup_seed)


def _load_translator(spec: str) -> Callable[..., str]:
  """Загружает callable из строки module:function (NL->PDDL, опционально с путями domain/problem/domain_nl)."""
  mod_name, func_name = spec.split(":", 1)
  module = importlib.import_module(mod_name)
  return getattr(module, func_name)


def _call_translator(
  translator: Callable[..., str],
  nl_plan: str,
  domain_path: Optional[Path] = None,
  problem_path: Optional[Path] = None,
  domain_nl_path: Optional[Path] = None,
  debug_path: Optional[Path] = None,
) -> str:
  """
  Вызывает переводчик NL->PDDL. Поддерживает:
  - f(nl_plan) -> str (старый контракт);
  - f(nl_plan, domain_path=..., problem_path=..., domain_nl_path=...) -> str (для AutoPlanBench и др.).
  """
  kwargs: Dict[str, Optional[str]] = {}
  if domain_path is not None and _callable_accepts_param(translator, "domain_path"):
    kwargs["domain_path"] = str(domain_path)
  if problem_path is not None and _callable_accepts_param(translator, "problem_path"):
    kwargs["problem_path"] = str(problem_path)
  if domain_nl_path is not None and _callable_accepts_param(translator, "domain_nl_path"):
    kwargs["domain_nl_path"] = str(domain_nl_path)
  if debug_path is not None and _callable_accepts_param(translator, "debug_path"):
    kwargs["debug_path"] = str(debug_path)
  if kwargs:
    return str(translator(nl_plan, **kwargs))
  return str(translator(nl_plan))


# Paired XML-style tags: open/close must use the same tag name (avoid cross-matching).
_THINKING_PAIRED_RES = tuple(
  _re.compile(
    rf"<\s*{tag}\s*>.*?</\s*{tag}\s*>",
    _re.DOTALL | _re.IGNORECASE,
  )
  for tag in ("think", "thinking", "reasoning")
)
# Markdown / fenced blocks often used for chain-of-thought.
_FENCED_REASONING_RE = _re.compile(
    r"```\s*(?:reasoning|think|thinking|chain[-_]?of[-_]?thought|cot)\s*\r?\n.*?```",
    _re.DOTALL | _re.IGNORECASE,
)


def _strip_model_reasoning(text: str) -> str:
  """Strip common model reasoning/thinking blocks from plan text."""
  s = text
  for rx in _THINKING_PAIRED_RES:
    s = rx.sub("", s)
  s = _FENCED_REASONING_RE.sub("", s)
  # Unclosed opening tag: drop from first `<think` / `<thinking` / `<reasoning` to end of string.
  for tag in ("think", "thinking", "reasoning"):
    opener = _re.search(rf"<\s*{tag}\s*>", s, _re.IGNORECASE)
    if opener:
      closer = _re.search(rf"</\s*{tag}\s*>", s[opener.end() :], _re.IGNORECASE)
      if not closer:
        s = s[: opener.start()]
        break
  return s.strip()


def _get_nl_plan_from_run(
  data: Dict[str, Any],
  *,
  allow_reasoning_fallback: bool = False,
) -> Optional[str]:
  """Достаёт текст плана (NL) из ответа OpenRouter: content; опционально reasoning."""
  try:
    if "error" in data:
      return None
    response = data.get("openrouter_response", {})
    if not isinstance(response, dict):
      return None
    if _provider_error_from_response(response) is not None:
      return None
    msg = response.get("choices", [{}])[0].get("message", {})
    content = (msg.get("content") or "").strip()
    if content:
      return _strip_model_reasoning(content)
    if allow_reasoning_fallback:
      reasoning = (msg.get("reasoning") or "").strip()
      if reasoning:
        return _strip_model_reasoning(reasoning)
    return None
  except (IndexError, KeyError, TypeError):
    return None


def _parse_example_id_parts(example_id: str) -> Optional[Tuple[str, str, Optional[Union[int, str]]]]:
  """
  Из id вида section__subsection, section__subsection__N или section__subsection__name возвращает
  (section, subsection, sample_index). sample_index — номер сэмпла (int), имя папки сэмпла (str)
  или None для одного сэмпла на подраздел.
  """
  return _shared_parse_example_id(example_id)


def _load_sample_pddl(
  dataset_dir: Path,
  section: str,
  subsection: str,
  sample_index: Optional[Union[int, str]] = None,
  *,
  example_id: Optional[str] = None,
) -> Optional[Dict[str, Any]]:
  """
  Загружает сэмпл: папка на сэмпл — data/<section>/<subsection>/<N>/ или
  data/<section>/<subsection>/<sample_name>/ (N — число, sample_name — имя папки).
  В sample.json — id, domain_path, problem_path, plan_ref_path или plan_ref (имя файла плана).
  Возвращает dict с domain_pddl, problem_pddl, plan_ref_pddl (тексты из файлов).
  """
  sample_dir = _resolve_sample_dir(
    dataset_dir,
    section,
    subsection,
    sample_index,
    example_id=example_id,
  )
  if sample_dir is None:
    return None
  json_path = sample_dir / "sample.json"
  if not json_path.exists():
    return None
  data = json.loads(json_path.read_text(encoding="utf-8"))
  domain_path = data.get("domain_path")
  problem_path = data.get("problem_path")
  plan_ref_path = data.get("plan_ref_path") or data.get("plan_ref")
  if not domain_path or not problem_path:
    return None
  domain_file = sample_dir / domain_path
  problem_file = sample_dir / problem_path
  if not domain_file.exists() or not problem_file.exists():
    return None
  data["domain_pddl"] = domain_file.read_text(encoding="utf-8")
  data["problem_pddl"] = problem_file.read_text(encoding="utf-8")
  if plan_ref_path:
    plan_file = sample_dir / plan_ref_path
    if plan_file.exists():
      data["plan_ref_pddl"] = plan_file.read_text(encoding="utf-8")
  data["_sample_dir"] = str(sample_dir)
  return data


def _get_pddl_from_sample(sample: Dict[str, Any]) -> tuple[Optional[str], Optional[str], Optional[str]]:
  """Возвращает (domain_pddl, problem_pddl, plan_ref_pddl). Только PDDL-источники."""
  domain = sample.get("domain_pddl") or sample.get("domain")
  problem = sample.get("problem_pddl") or sample.get("problem")
  ref = sample.get("plan_ref_pddl") or sample.get("plan_ref")
  if isinstance(ref, list):
    ref = "\n".join(str(x) for x in ref)
  return (domain, problem, ref)


def _example_ids_limit_per_section(dataset_dir: Path, n: int) -> set[str]:
  """
  Для каждой области (section) — не более n сэмплов с валидными domain/problem.
  Порядок внутри section: как в sorted обходе sample.json по датасету (iter_dataset_samples).
  Согласовано с фильтром в _build_all_prompts при --limit.
  """
  from collections import defaultdict

  buckets: Dict[str, List[str]] = defaultdict(list)
  for sample_path in _iter_dataset_samples(dataset_dir):
    try:
      sample = json.loads(sample_path.read_text(encoding="utf-8"))
    except Exception:
      continue
    example_id = str(sample.get("id") or "")
    if not example_id:
      continue
    domain_path = sample.get("domain_path")
    problem_path = sample.get("problem_path")
    if not domain_path or not problem_path:
      continue
    sample_dir = sample_path.parent
    domain_file = sample_dir / str(domain_path)
    problem_file = sample_dir / str(problem_path)
    if not domain_file.exists() or not problem_file.exists():
      continue
    section, _, _ = _extract_sample_coords(sample, example_id)
    sec_key = section if section else "__no_section__"
    buckets[sec_key].append(example_id)

  allowed: set[str] = set()
  for sec in sorted(buckets.keys()):
    for eid in buckets[sec][:n]:
      allowed.add(eid)
  return allowed


def compute_metrics_phase(
  output_dir: Path,
  dataset_dir: Path,
  translator_spec: Optional[str],
  val_binary: str,
  val_timeout_seconds: int = 30,
  nl2pddl_workers: int = 2,
  run_id: str = "run_1",
  limit: Optional[int] = None,
  domain_setup_seed: int = 0,
  allow_reasoning_fallback: bool = False,
  models_config_path: Optional[Path] = None,
  val_log_dir: Optional[Path] = None,
) -> None:
  """По run JSON в output_dir и датасету считает метрики и пишет metrics.jsonl.
  Если задан limit>0, обрабатываются run только для сэмплов из множества
  «первые limit сэмплов в каждой section» (как при --limit в run)."""
  from metrics import compute_metrics, aggregate_runs, RunRecord

  safe_stem_to_config_key: Dict[str, str] = {}
  if models_config_path is not None:
    mp = Path(models_config_path)
    if mp.is_file():
      try:
        mcfg = load_config(str(mp))
        for k in (mcfg.get("models") or {}):
          safe_stem_to_config_key[str(k).replace("/", "_")] = str(k)
      except Exception:
        pass

  def _model_display_key(run_data: Optional[Dict[str, Any]], parts: List[str]) -> str:
    if isinstance(run_data, dict):
      mn = run_data.get("model_name")
      if isinstance(mn, str) and mn.strip():
        return mn
    safe = parts[-1]
    mapped = safe_stem_to_config_key.get(safe)
    if mapped is not None:
      return mapped
    if isinstance(run_data, dict):
      mod = run_data.get("model")
      if isinstance(mod, str) and mod.strip():
        return mod
    return safe

  def _run_file_rel(p: Path) -> str:
    try:
      return str(p.relative_to(output_dir))
    except ValueError:
      return str(p)

  translator: Optional[Callable[[str], str]] = None
  if translator_spec:
    translator = _load_translator(translator_spec)
  pddl_direct_metrics = is_pddl2pddl_translator_spec(translator_spec)
  # Подписи в логах фазы «текст ответа → plan_pred_pddl» (не APB NL2PDDL при pddl_direct_metrics).
  plan_extract_log = "PDDL from model" if pddl_direct_metrics else "NL2PDDL"

  # Run files: {id}__{safe_model_name}.json; exclude debug logs (*__nl2pddl_debug.json).
  run_files = [
    f for f in output_dir.rglob("*__*.json")
    if f.is_file() and not f.name.endswith("__nl2pddl_debug.json")
  ]
  if limit is not None and limit > 0 and dataset_dir.exists():
    allowed_ids = _example_ids_limit_per_section(dataset_dir, limit)

    def _example_id_from_run_file(f: Path) -> Optional[str]:
      try:
        data = json.loads(f.read_text(encoding="utf-8"))
        eid = data.get("id")
        if eid:
          return str(eid)
      except Exception:
        pass
      parts = f.stem.split("__")
      return "__".join(parts[:-1]) if len(parts) >= 2 else None

    run_files = [f for f in run_files if _example_id_from_run_file(f) in allowed_ids]
    _debug(f"Metrics phase: limit={limit} -> {len(allowed_ids)} example ids, {len(run_files)} run files")
  else:
    _debug(f"Metrics phase: found {len(run_files)} run files in {output_dir}")
  records: List[RunRecord] = []
  metrics_rows: List[Dict[str, Any]] = []
  translation_errors: Dict[Path, str] = {}

  mcfg_resolved: Optional[str] = None
  if models_config_path is not None:
    mp = Path(models_config_path)
    if mp.is_file():
      mcfg_resolved = str(mp.resolve())

  metrics_phase_payload: Dict[str, Any] = {
    "val_binary": val_binary,
    "val_timeout_seconds": int(val_timeout_seconds),
    "run_id": run_id,
    "limit": limit,
    "domain_setup_seed": int(domain_setup_seed),
    "allow_reasoning_fallback": bool(allow_reasoning_fallback),
    "models_config_path": mcfg_resolved,
    "nl2pddl_workers": int(nl2pddl_workers),
    "translator_spec": translator_spec,
    "pddl2pddl_metrics": pddl_direct_metrics,
  }
  metrics_meta_patch: Dict[str, Any] = {"metrics_phase": dict(metrics_phase_payload)}

  # Stage 1: NL->PDDL translation (parallel) for runs missing cached plan_pred_pddl.
  # Cache result back into the run JSON (plan_pred_pddl) so reruns don't call the translator again.
  plan_pred_by_path: Dict[Path, str] = {}
  if translator:
    translate_jobs: List[Tuple[Path, str, Path, Path, Optional[Path]]] = []
    for path in sorted(run_files):
      try:
        data = json.loads(path.read_text(encoding="utf-8"))
      except Exception as e:
        _debug(f"  skip {path.name}: read error {e}")
        continue
      if "error" in data:
        _debug(f"  skip {path.name}: has error")
        continue
      resp = data.get("openrouter_response")
      if isinstance(resp, dict) and _provider_error_from_response(resp) is not None:
        _debug(f"  skip {path.name}: provider error inside response")
        continue
      if data.get("plan_pred_pddl"):
        plan_pred_by_path[path] = str(data["plan_pred_pddl"])
        _debug(f"  {path.name}: use cached plan_pred_pddl")
        continue
      example_id = data.get("id", path.stem)
      parsed = _parse_example_id_parts(example_id)
      if not parsed:
        continue
      section, subsection, sample_index = parsed
      sample = _load_sample_pddl(dataset_dir, section, subsection, sample_index, example_id=example_id)
      if sample is None:
        _debug(f"  skip {path.name}: sample not found")
        continue
      nl_plan = _get_nl_plan_from_run(
        data,
        allow_reasoning_fallback=allow_reasoning_fallback,
      )
      if not nl_plan:
        _debug(
          f"  skip {path.name}: no {'PDDL plan text' if pddl_direct_metrics else 'NL plan'} in content/reasoning",
        )
        continue
      sample_dir = Path(str(sample.get("_sample_dir", "")))
      domain_path = (sample_dir / sample.get("domain_path", "")).resolve()
      problem_path = (sample_dir / sample.get("problem_path", "")).resolve()
      domain_nl_path = _resolve_dataset_relative_path(dataset_dir, sample.get("domain_nl_path"))
      translate_jobs.append(
        (path, nl_plan, domain_path, problem_path, domain_nl_path)
      )
      _debug(f"  queue {plan_extract_log} job {path.name} text_len={len(nl_plan)}")

    nl2pddl_meta_patch: Dict[str, Any] = {
      "version": 1,
      "nl2pddl_workers": int(nl2pddl_workers) if nl2pddl_workers is not None else 2,
      "nl2pddl_subprocess": _nl2pddl_subprocess_settings(),
      "metrics_phase": dict(metrics_phase_payload),
    }
    if translator_spec:
      nl2pddl_meta_patch["translator"] = translator_spec

    if translate_jobs:
      workers = max(1, int(nl2pddl_workers)) if nl2pddl_workers is not None else 1
      metrics_label = "PDDL plan (from model)" if pddl_direct_metrics else "NL2PDDL"
      _debug(f"{metrics_label}: {len(translate_jobs)} jobs, workers={workers}")
      print(
        f"[sembenchrunning] {metrics_label}: processing {len(translate_jobs)} runs with {workers} workers...",
        flush=True,
      )

      def _translate_one(job: Tuple[Path, str, Path, Path, Optional[Path]]) -> Tuple[Path, str]:
        p, nl_plan, domain_path, problem_path, domain_nl_path = job
        _debug(f"  {plan_extract_log} start {p.name} ...")
        dbg = p.with_name(p.stem + "__nl2pddl_debug.json")
        plan_pddl = _call_translator(
          translator,
          nl_plan,
          domain_path=domain_path if domain_path.exists() else None,
          problem_path=problem_path if problem_path.exists() else None,
          domain_nl_path=domain_nl_path if domain_nl_path and domain_nl_path.exists() else None,
          debug_path=dbg,
        )
        _debug(f"  {plan_extract_log} done {p.name} plan_len={len(plan_pddl)}")
        return (p, plan_pddl)

      with ThreadPoolExecutor(max_workers=workers) as ex:
        futs = {ex.submit(_translate_one, j): j[0] for j in translate_jobs}
        for fut in as_completed(futs):
          p = futs[fut]
          try:
            path_res, plan_res = fut.result()
          except Exception as e:
            translation_errors[p] = str(e)
            print(f"[sembenchrunning] Translator error for {p.name}: {e}", flush=True)
            try:
              d = json.loads(p.read_text(encoding="utf-8"))
              d["nl2pddl_status"] = "error"
              d["nl2pddl_error"] = {
                "type": type(e).__name__,
                "message": str(e),
              }
              _merge_sembench_translator_meta(d, nl2pddl_meta_patch)
              _write_run_json(p, d, with_nl2pddl_debug=True, dataset_dir=dataset_dir, domain_setup_seed=domain_setup_seed)
            except Exception:
              pass
            continue
          plan_pred_by_path[path_res] = plan_res
          _debug(f"  cached plan_pred_pddl for {path_res.name}")
          # Persist cache into run JSON.
          try:
            d = json.loads(path_res.read_text(encoding="utf-8"))
            d["plan_pred_pddl"] = plan_res
            d["nl2pddl_status"] = "ok"
            d.pop("nl2pddl_error", None)
            _merge_sembench_translator_meta(d, nl2pddl_meta_patch)
            _write_run_json(path_res, d, with_nl2pddl_debug=True, dataset_dir=dataset_dir, domain_setup_seed=domain_setup_seed)
          except Exception as e:
            print(f"[sembenchrunning] Warning: failed to cache plan_pred_pddl into {path_res.name}: {e}", flush=True)

  _debug("Stage 2: VAL + metrics per run file")

  def _append_metric_row(
    *,
    example_id: str,
    model_name: str,
    section: Optional[str],
    subsection: Optional[str],
    executability: bool,
    reachability: bool,
    optimality_ratio: float,
    first_val_failure_step: int,
    first_ref_deviation_step: int,
    status: str,
    failure_reason: Optional[str],
    run_id_value: str = run_id,
    path: Optional[Path] = None,
    run_data: Optional[Dict[str, Any]] = None,
  ) -> None:
    row: Dict[str, Any] = {
      "example_id": example_id,
      "model": model_name,
      "run_id": run_id_value,
      "section": section,
      "subsection": subsection,
      "status": status,
      "failure_reason": failure_reason,
      "executability": executability,
      "reachability": reachability,
      "optimality_ratio": optimality_ratio,
      "first_val_failure_step": first_val_failure_step,
      "first_ref_deviation_step": first_ref_deviation_step,
    }
    if path is not None:
      row["run_file"] = _run_file_rel(path)
    if isinstance(run_data, dict):
      om = run_data.get("model")
      if isinstance(om, str) and om.strip():
        row["openrouter_model"] = om
      if isinstance(run_data.get("openrouter_request"), dict):
        row["openrouter_request"] = run_data["openrouter_request"]
      if isinstance(run_data.get("sembench_translator_meta"), dict):
        row["sembench_translator_meta"] = run_data["sembench_translator_meta"]
    metrics_rows.append(row)
    records.append(
      RunRecord(
        run_id=run_id_value,
        example_id=example_id,
        model=model_name,
        executability=float(executability),
        reachability=float(reachability),
        optimality_ratio=optimality_ratio,
        first_val_failure_step=first_val_failure_step,
        first_ref_deviation_step=first_ref_deviation_step,
        section=section,
        subsection=subsection,
        status=status,
      )
    )

  def _on_val_failure_cb(val_result):
    step = getattr(val_result, "first_failing_step", None)
    ec = getattr(val_result, "exit_code", None)
    out = (getattr(val_result, "stdout", None) or "").strip()
    err = (getattr(val_result, "stderr", None) or "").strip()
    _debug(f"    VAL failed exit_code={ec} step={step} exec={getattr(val_result, 'executable', None)} goal={getattr(val_result, 'goal_reached', None)}")
    if out:
      _debug(f"    VAL stdout (trunc 1500): {out[:1500]!r}")
    if err:
      _debug(f"    VAL stderr (trunc 1500): {err[:1500]!r}")
    if not out and not err:
      _debug(
        "    VAL: пустой stdout/stderr — часто validate пишет в stdout; проверьте бинарник, "
        "или SEMBENCH_DEBUG и ниже, или DEBUG_VAL=1 при отладке metrics/val_runner.",
      )

  for path in sorted(run_files):
    stem = path.stem
    if "__" not in stem:
      continue
    # id can be section__subsection or section__subsection__N; model is last segment
    parts = stem.split("__")
    if len(parts) < 2:
      continue
    safe_id = "__".join(parts[:-1])
    _debug(f"  process {path.name} ...")
    try:
      data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as e:
      print(f"[sembenchrunning] Skip {path.name}: cannot read JSON ({e})", flush=True)
      _append_metric_row(
        example_id=safe_id,
        model_name=_model_display_key(None, parts),
        section=None,
        subsection=None,
        executability=False,
        reachability=False,
        optimality_ratio=-1.0,
        first_val_failure_step=-1,
        first_ref_deviation_step=-1,
        status="pipeline_failed",
        failure_reason="unreadable_run_json",
        path=path,
        run_data=None,
      )
      continue
    model_name = _model_display_key(data, parts)
    _merge_sembench_translator_meta(data, metrics_meta_patch)
    dbg_path = path.with_name(path.stem + "__nl2pddl_debug.json")
    try:
      _write_run_json(
        path,
        data,
        with_nl2pddl_debug=dbg_path.is_file(),
        dataset_dir=dataset_dir,
        domain_setup_seed=int(domain_setup_seed),
      )
    except OSError as e:
      print(f"[sembenchrunning] Warning: could not refresh run file {path.name}: {e}", flush=True)
    example_id = data.get("id", safe_id)
    parsed = _parse_example_id_parts(example_id)
    if not parsed:
      print(f"[sembenchrunning] Skip {path.name}: id must be section__subsection or section__subsection__N, got {example_id!r}", flush=True)
      _append_metric_row(
        example_id=str(example_id),
        model_name=model_name,
        section=None,
        subsection=None,
        executability=False,
        reachability=False,
        optimality_ratio=-1.0,
        first_val_failure_step=-1,
        first_ref_deviation_step=-1,
        status="pipeline_failed",
        failure_reason="invalid_example_id",
        path=path,
        run_data=data,
      )
      continue
    section, subsection, sample_index = parsed

    if "error" in data:
      _debug(f"    mark failure: error in run")
      err = data.get("error")
      err_type = err.get("type") if isinstance(err, dict) else None
      failure_reason = f"run_error:{err_type}" if err_type else "run_error"
      _append_metric_row(
        example_id=str(example_id),
        model_name=model_name,
        section=section,
        subsection=subsection,
        executability=False,
        reachability=False,
        optimality_ratio=-1.0,
        first_val_failure_step=-1,
        first_ref_deviation_step=-1,
        status="pipeline_failed",
        failure_reason=failure_reason,
        path=path,
        run_data=data,
      )
      continue
    resp = data.get("openrouter_response")
    provider_error = _provider_error_from_response(resp) if isinstance(resp, dict) else None
    if provider_error is not None:
      _debug(f"    mark failure: provider error in response")
      _append_metric_row(
        example_id=str(example_id),
        model_name=model_name,
        section=section,
        subsection=subsection,
        executability=False,
        reachability=False,
        optimality_ratio=-1.0,
        first_val_failure_step=-1,
        first_ref_deviation_step=-1,
        status="pipeline_failed",
        failure_reason="provider_response_error",
        path=path,
        run_data=data,
      )
      continue

    sample = _load_sample_pddl(dataset_dir, section, subsection, sample_index, example_id=example_id)
    if sample is None:
      print(f"[sembenchrunning] Skip {path.name}: sample not found in dataset for id {example_id!r}", flush=True)
      _append_metric_row(
        example_id=str(example_id),
        model_name=model_name,
        section=section,
        subsection=subsection,
        executability=False,
        reachability=False,
        optimality_ratio=-1.0,
        first_val_failure_step=-1,
        first_ref_deviation_step=-1,
        status="pipeline_failed",
        failure_reason="missing_sample",
        path=path,
        run_data=data,
      )
      continue

    # Treat empty string as valid cached plan (e.g. goal already satisfied); do not use `or`.
    plan_pred_pddl = data.get("plan_pred_pddl")
    if plan_pred_pddl is None:
      plan_pred_pddl = plan_pred_by_path.get(path)
    if plan_pred_pddl is None:
      _debug(f"    mark failure: no plan_pred_pddl")
      failure_reason = "missing_plan_pred_pddl"
      if path in translation_errors:
        failure_reason = "nl2pddl_error"
      elif data.get("nl2pddl_status") == "error":
        failure_reason = "nl2pddl_error"
      elif translator and not _get_nl_plan_from_run(
        data,
        allow_reasoning_fallback=allow_reasoning_fallback,
      ):
        failure_reason = "missing_model_plan_text" if pddl_direct_metrics else "missing_nl_plan"
      _append_metric_row(
        example_id=str(example_id),
        model_name=model_name,
        section=section,
        subsection=subsection,
        executability=False,
        reachability=False,
        optimality_ratio=-1.0,
        first_val_failure_step=-1,
        first_ref_deviation_step=-1,
        status="pipeline_failed",
        failure_reason=failure_reason,
        path=path,
        run_data=data,
      )
      continue

    domain_pddl, problem_pddl, plan_ref_pddl = _get_pddl_from_sample(sample)
    if not domain_pddl or not problem_pddl:
      print(f"[sembenchrunning] Skip {path.name}: missing domain/problem in sample", flush=True)
      _append_metric_row(
        example_id=str(example_id),
        model_name=model_name,
        section=section,
        subsection=subsection,
        executability=False,
        reachability=False,
        optimality_ratio=-1.0,
        first_val_failure_step=-1,
        first_ref_deviation_step=-1,
        status="pipeline_failed",
        failure_reason="missing_domain_or_problem",
        path=path,
        run_data=data,
      )
      continue
    _debug(f"    run VAL + compute_metrics ...")

    val_log_file: Optional[Path] = None
    if val_log_dir is not None:
      val_log_dir.mkdir(parents=True, exist_ok=True)
      val_log_file = val_log_dir / f"{path.stem}.val.txt"

    try:
      m = compute_metrics(
        domain_pddl=domain_pddl,
        problem_pddl=problem_pddl,
        plan_pred_pddl=plan_pred_pddl,
        plan_ref_pddl=plan_ref_pddl,  # может быть None
        val_binary=val_binary,
        val_timeout_seconds=int(val_timeout_seconds),
        on_val_failure=_on_val_failure_cb if DEBUG else None,
        val_log_file=val_log_file,
      )
    except Exception as e:
      print(f"[sembenchrunning] VAL/metrics error for {path.name}: {e}", flush=True)
      _append_metric_row(
        example_id=str(example_id),
        model_name=model_name,
        section=section,
        subsection=subsection,
        executability=False,
        reachability=False,
        optimality_ratio=-1.0,
        first_val_failure_step=-1,
        first_ref_deviation_step=-1,
        status="pipeline_failed",
        failure_reason="val_or_metrics_error",
        path=path,
        run_data=data,
      )
      continue
    _debug(f"    metrics: exec={m.executability} reach={m.reachability} opt_ratio={m.optimality_ratio} val_fail={m.first_val_failure_step} ref_dev={m.first_ref_deviation_step}")

    _append_metric_row(
      example_id=str(example_id),
      model_name=model_name,
      section=section,
      subsection=subsection,
      executability=bool(m.executability),
      reachability=bool(m.reachability),
      optimality_ratio=m.optimality_ratio,
      first_val_failure_step=m.first_val_failure_step,
      first_ref_deviation_step=m.first_ref_deviation_step,
      status="metrics_computed",
      failure_reason=None,
      path=path,
      run_data=data,
    )

  if not metrics_rows:
    print(
      "[sembenchrunning] No metric rows produced. Проверьте наличие run JSON в output_dir.",
      flush=True,
    )
    return
  out_metrics = output_dir / "metrics.jsonl"
  new_keys = {(row["example_id"], row["model"], row.get("run_id")) for row in metrics_rows}
  preserved: List[Dict[str, Any]] = []
  if out_metrics.exists():
    try:
      for line in out_metrics.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line:
          continue
        try:
          existing = json.loads(line)
          key = (existing.get("example_id"), existing.get("model"), existing.get("run_id"))
          if key not in new_keys:
            preserved.append(existing)
        except json.JSONDecodeError:
          pass
    except OSError:
      pass
  merged = preserved + metrics_rows
  with out_metrics.open("w", encoding="utf-8") as f:
    for row in merged:
      f.write(json.dumps(row, ensure_ascii=False) + "\n")
  print(
    f"[sembenchrunning] Wrote {len(metrics_rows)} new + {len(preserved)} preserved "
    f"= {len(merged)} total metric rows to {out_metrics}",
    flush=True,
  )

  coverage_by_model: Dict[str, Dict[str, int]] = {}
  for row in metrics_rows:
    model = str(row.get("model") or "unknown")
    bucket = coverage_by_model.setdefault(model, {"total": 0, "computed": 0, "pipeline_failed": 0})
    bucket["total"] += 1
    if row.get("status") == "metrics_computed":
      bucket["computed"] += 1
    else:
      bucket["pipeline_failed"] += 1
  print("[sembenchrunning] Coverage by model:", flush=True)
  for model, stats_cov in coverage_by_model.items():
    print(
      f"  {model}: total={stats_cov['total']} computed={stats_cov['computed']} "
      f"pipeline_failed={stats_cov['pipeline_failed']}",
      flush=True,
    )

  computed_records = [r for r in records if r.status == "metrics_computed"]
  failed_count = len(records) - len(computed_records)
  if failed_count:
    print(
      f"[sembenchrunning] Note: {failed_count} pipeline-failed runs excluded from aggregation "
      f"({len(computed_records)} computed records used).",
      flush=True,
    )

  by_model = aggregate_runs(computed_records, group_by="model")
  print("[sembenchrunning] Aggregate by model:", flush=True)
  for model, stats in by_model.items():
    print(f"  {model}:", flush=True)
    for metric, agg in stats.items():
      ci = f" [{agg.ci_low:.3f}, {agg.ci_high:.3f}]" if agg.ci_low is not None else ""
      print(f"    {metric}: mean={agg.mean:.4f} std={agg.std:.4f} n={agg.count}{ci}", flush=True)
  if any(r.section for r in computed_records):
    by_section = aggregate_runs(computed_records, group_by="section")
    print("[sembenchrunning] Aggregate by section:", flush=True)
    for section, stats in by_section.items():
      if not section:
        continue
      print(f"  {section}:", flush=True)
      for metric, agg in stats.items():
        ci = f" [{agg.ci_low:.3f}, {agg.ci_high:.3f}]" if agg.ci_low is not None else ""
        print(f"    {metric}: mean={agg.mean:.4f} std={agg.std:.4f} n={agg.count}{ci}", flush=True)
  if any(r.subsection for r in computed_records):
    by_subsection = aggregate_runs(computed_records, group_by="subsection")
    print("[sembenchrunning] Aggregate by subsection:", flush=True)
    for subsection, stats in by_subsection.items():
      if not subsection:
        continue
      print(f"  {subsection}:", flush=True)
      for metric, agg in stats.items():
        ci = f" [{agg.ci_low:.3f}, {agg.ci_high:.3f}]" if agg.ci_low is not None else ""
        print(f"    {metric}: mean={agg.mean:.4f} std={agg.std:.4f} n={agg.count}{ci}", flush=True)


def parse_args() -> argparse.Namespace:
  parser = argparse.ArgumentParser(
    description=(
      "Прогон датасета (PDDL): режим NL (PDDL→NL → LLM → NL→PDDL) или PDDL→PDDL (--pddl2pddl); "
      "метрики по run. Промпты строятся из датасета, ответы логируются в JSON."
    )
  )
  parser.add_argument(
    "--config",
    type=Path,
    default=Path("models_config.yaml"),
    help="Путь к YAML-конфигу моделей и настроек OpenRouter.",
  )
  parser.add_argument(
    "--translator-config",
    type=Path,
    default=None,
    help=(
      "YAML с параметрами переводчика AutoPlanBench (см. translator_config.yaml). "
      "Альтернатива: переменная SEMBENCH_TRANSLATOR_CONFIG."
    ),
  )
  parser.add_argument(
    "--model",
    type=str,
    action="append",
    dest="models",
    metavar="MODEL_ID",
    help=(
      "ID модели из секции 'models' в конфиге (OpenRouter id). "
      "Можно указать несколько раз для прогона всех перечисленных моделей."
    ),
  )
  parser.add_argument(
    "--output-dir",
    type=Path,
    default=Path("runs") / "latest",
    help="Каталог, куда сохранять JSON-логи ответов.",
  )
  parser.add_argument(
    "--limit",
    type=int,
    default=None,
    help=(
      "Опционально: в каждой области (section) обработать только первые N валидных сэмплов "
      "(порядок — sorted sample.json по датасету). Метрики с тем же --limit используют то же множество id."
    ),
  )
  parser.add_argument(
    "--max-concurrent",
    type=int,
    default=None,
    help=(
      "Переопределить openrouter.max_concurrent_requests из конфига "
      "(максимальное число параллельных запросов)."
    ),
  )
  parser.add_argument(
    "--batch-size",
    type=int,
    default=None,
    help=(
      "Размер батча: сколько промптов обрабатывать за одну \"волну\". "
      "Остальные батчи пойдут последовательно."
    ),
  )
  parser.add_argument(
    "--translate-workers",
    type=int,
    default=2,
    help=(
      "Число параллельных воркеров для PDDL->NL (run_save_descriptions). "
      "0 = последовательно. По умолчанию 2."
    ),
  )
  parser.add_argument(
    "--nl2pddl-workers",
    type=int,
    default=2,
    help=(
      "Число параллельных воркеров для NL->PDDL в фазе метрик (translator). "
      "0 = последовательно. По умолчанию 2."
    ),
  )
  parser.add_argument(
    "--nl2pddl-parallel",
    type=int,
    default=None,
    metavar="N",
    help=(
      "Параллель HTTP внутри AutoPlanBench run_translate_nl2pddl.py (--parallel). "
      "Переопределяет AUTOPLANBENCH_NL2PDDL_PARALLEL для этого процесса. "
      "В APB параллель только при N>1; N<=0 в env трактуется как 80; для последовательного перевода строк укажите 1."
    ),
  )
  parser.add_argument(
    "--domain-setup-parallel",
    type=int,
    default=None,
    metavar="N",
    help=(
      "Параллель HTTP внутри AutoPlanBench run_domain_setup.py (--parallel, PDDL→NL домена). "
      "Переопределяет AUTOPLANBENCH_DOMAIN_SETUP_PARALLEL (по умолчанию 80). "
      "Раньше sembench не передавал --parallel → в APB было 1 и запросы шли последовательно."
    ),
  )
  parser.add_argument(
    "--dataset-dir",
    type=Path,
    default=None,
    help=(
      "Каталог датасета: рекурсивно ищутся все sample.json. Структура: <section>/<subsection>/<N или name>/ с "
      "domain_path, problem_path, plan_ref или plan_ref_path в sample.json. "
      "id: section__subsection__N или section__subsection__name. "
      "Можно указать подпапку (напр. data/batch_samples), чтобы гнать только один сет. "
      "Если задан, после прогона считаются метрики."
    ),
  )
  parser.add_argument(
    "--pddl2pddl",
    action="store_true",
    help=(
      "Режим PDDL→PDDL: промпт = шаблон prompt_template_pddl2pddl.txt + сырой domain/problem PDDL; "
      "метрики: ответ модели как PDDL-план (translators.pddl2pddl:response_as_plan_pddl), без APB NL2PDDL. "
      "Подставляет --prompt-translator и --translator, если не заданы; отключает ensure_domain_json для прогона."
    ),
  )
  parser.add_argument(
    "--prompt-translator",
    type=str,
    default=None,
    help=(
      "Модуль:функция для построения тела промпта из PDDL (domain, problem): NL или сырой PDDL. "
      "Пример NL (AutoPlanBench): translators.autoplanbench_pddl2nl:pddl_to_nl_prompt. "
      "PDDL→PDDL: translators.pddl2pddl:pddl_prompt_body (см. --pddl2pddl). "
      "Сигнатура: f(domain_pddl, problem_pddl) -> str или f(..., domain_path=..., problem_path=..., domain_nl_path=...). "
      "domain_nl_path в sample.json - путь к domain_description_seedN.json (файл создаётся после PDDL->NL для домена, run_domain_setup.py в AutoPlanBench)."
    ),
  )
  parser.add_argument(
    "--translator",
    type=str,
    default=None,
    help=(
      "Модуль:функция для получения PDDL-плана для метрик: NL→PDDL (напр. translators.autoplanbench_nl2pddl:nl_to_pddl) "
      "или извлечение из ответа модели (translators.pddl2pddl:response_as_plan_pddl при --pddl2pddl). "
      "Функция может принимать (text) или (text, domain_path=..., problem_path=..., domain_nl_path=..., debug_path=...). "
      "Либо в run JSON уже есть plan_pred_pddl."
    ),
  )
  parser.add_argument(
    "--autoplanbench-root",
    type=Path,
    default=None,
    help=(
      "Корень AutoPlanBench (или переменная AUTOPLANBENCH_ROOT). "
      "Если задан и нужен domain_description JSON для промпта - он создаётся автоматически (run_domain_setup.py)."
    ),
  )
  parser.add_argument(
    "--autoplanbench-llm",
    type=str,
    default=None,
    help=(
      "Модель для автоматической генерации domain_description (PDDL->NL домена). "
      "Если не задано: domain_setup.llm из translator_config.yaml."
    ),
  )
  parser.add_argument(
    "--autoplanbench-seed",
    type=int,
    default=0,
    help="Seed для имени domain_description_seedN.json при авто-генерации.",
  )
  parser.add_argument(
    "--val-binary",
    type=str,
    default="validate",
    help=(
      "Путь к бинарнику VAL (validate / validate.exe) для подсчёта метрик. "
      "Можно указать полный путь, например D:\\VAL\\validate.exe или /usr/local/bin/validate, "
      "либо имя validate, если он в PATH."
    ),
  )
  parser.add_argument(
    "--val-timeout-seconds",
    type=int,
    default=30,
    help="Таймаут одного запуска VAL в секундах.",
  )
  parser.add_argument(
    "--no-val-log",
    action="store_true",
    help="Не сохранять полные логи VAL (*.val.txt: домен, проблема, план, stdout/stderr).",
  )
  parser.add_argument(
    "--val-log-dir",
    nargs="?",
    const="",
    default=None,
    type=str,
    metavar="DIR",
    help=(
      "Каталог для полных логов VAL (по умолчанию без этого флага — тот же, что --output-dir, рядом с *.json). "
      "Указать DIR — писать *.val.txt только туда. Флаг без пути — явно <output-dir>. "
      "Отключить запись: --no-val-log."
    ),
  )
  parser.add_argument(
    "--skip-metrics",
    action="store_true",
    help="Не считать метрики даже при заданном --dataset-dir.",
  )
  parser.add_argument(
    "--metrics-only",
    action="store_true",
    help="Только посчитать метрики по уже существующим run в output_dir (нужны --output-dir и --dataset-dir).",
  )
  parser.add_argument(
    "--rerun-truncated",
    action="store_true",
    help=(
      "В run фазе перезаписывать уже существующие run-файлы, если прошлый ответ был обрезан "
      "(finish_reason=length / native_finish_reason=max_output_tokens)."
    ),
  )
  parser.add_argument(
    "--rerun",
    action="store_true",
    help="Игнорировать закешированные run-файлы и генерировать новые ответы для всех сэмплов.",
  )
  parser.add_argument(
    "--debug",
    action="store_true",
    help=(
      "Подробный лог sembenchrunning. В NL-режиме дополнительно: stdout/stderr скриптов AutoPlanBench "
      "(run_domain_setup, run_save_descriptions, run_translate_nl2pddl) в консоль; "
      "при --pddl2pddl эти субпроцессы не запускаются. "
      "То же без флага: SEMBENCH_DEBUG=1."
    ),
  )
  parser.add_argument(
    "--run-id",
    type=str,
    default="run_1",
    help=(
      "Идентификатор прогона в metrics.jsonl. Используйте разные значения при повторных прогонах "
      "одной и той же модели с другими параметрами, чтобы результаты не перезаписывали друг друга."
    ),
  )
  parser.add_argument(
    "--allow-reasoning-fallback",
    action="store_true",
    help=(
      "Разрешить брать NL-план из message.reasoning, если message.content пустой. "
      "По умолчанию выключено для более строгой оценки."
    ),
  )
  parser.add_argument(
    "--refresh-pddl2nl-cache",
    action="store_true",
    help=(
      "Только направление PDDL->NL для промпта сэмпла: удалить domain_and_problem_nl.txt в --dataset-dir. "
      "Нужен --dataset-dir. NL->PDDL этим не трогается - см. --refresh-nl2pddl-cache или --refresh-translation-caches."
    ),
  )
  parser.add_argument(
    "--refresh-pddl2pddl-cache",
    action="store_true",
    help=(
      "Удалить кэш тел промпта PDDL→PDDL: planning_prompt_pddl_body.txt и .meta.json в каждом сэмпле --dataset-dir."
    ),
  )
  parser.add_argument(
    "--refresh-nl2pddl-cache",
    action="store_true",
    help=(
      "Только направление NL->PDDL: удалить plan_pred_pddl из run JSON в --output-dir (перевод заново в фазе метрик). "
      "Нужен --output-dir. PDDL->NL этим не трогается - см. --refresh-pddl2nl-cache или --refresh-translation-caches."
    ),
  )
  parser.add_argument(
    "--refresh-translation-caches",
    action="store_true",
    help=(
      "Кэши перевода: PDDL->NL (domain_and_problem_nl.*) + PDDL→PDDL body (planning_prompt_pddl_body.*) в --dataset-dir "
      "и NL->PDDL (plan_pred_pddl в run JSON в --output-dir). "
      "Нужны --dataset-dir и --output-dir. Без --model скрипт завершится после очистки."
    ),
  )
  return parser.parse_args()


def _check_val_binary(val_binary: str) -> None:
  """Проверяет доступность бинарника VAL и завершает скрипт с понятным сообщением, если не найден."""
  import shutil
  if shutil.which(val_binary) is None and not Path(val_binary).is_file():
    raise SystemExit(
      f"VAL binary not found: '{val_binary}'. "
      "Install VAL (https://github.com/KCL-Planning/VAL) or specify the correct path via --val-binary."
    )


def _resolve_val_log_dir(args: argparse.Namespace) -> Optional[Path]:
  """По умолчанию — output_dir (*.val.txt рядом с run JSON); None только при --no-val-log."""
  if getattr(args, "no_val_log", False):
    return None
  raw = getattr(args, "val_log_dir", None)
  trimmed = (raw or "").strip()
  if trimmed:
    return Path(trimmed).expanduser()
  out = getattr(args, "output_dir", None)
  if out is None:
    return None
  return Path(out).expanduser().resolve()


def _bootstrap_translator_from_cli(args: argparse.Namespace) -> None:
  """Путь к YAML переводчика и дефолт --autoplanbench-llm из конфига."""
  tc = getattr(args, "translator_config", None)
  if tc is not None:
    p = Path(tc).expanduser()
    if not p.is_file():
      raise SystemExit(f"--translator-config must be an existing file: {p}")
    os.environ["SEMBENCH_TRANSLATOR_CONFIG"] = str(p.resolve())
    reload_translator_config()
  llm = getattr(args, "autoplanbench_llm", None)
  if not llm:
    args.autoplanbench_llm = get_domain_setup_llm()


def main() -> None:
  global DEBUG
  args = parse_args()
  _bootstrap_translator_from_cli(args)
  if getattr(args, "pddl2pddl", False):
    if not args.prompt_translator:
      args.prompt_translator = PDDL2PDDL_PROMPT_TRANSLATOR_SPEC
    if not args.translator:
      args.translator = PDDL2PDDL_METRICS_TRANSLATOR_SPEC
  DEBUG = getattr(args, "debug", False)
  pddl2pddl = bool(getattr(args, "pddl2pddl", False))
  if DEBUG:
    os.environ["SEMBENCH_DEBUG"] = "1"
    if pddl2pddl:
      print(
        "[sembenchrunning] Debug mode: verbose sembenchrunning log "
        "(PDDL→PDDL: AutoPlanBench subprocesses are not used).",
        flush=True,
      )
    else:
      print(
        "[sembenchrunning] Debug mode: verbose logging + AutoPlanBench subprocess stdout/stderr to console.",
        flush=True,
      )

  nl2p_par = getattr(args, "nl2pddl_parallel", None)
  if nl2p_par is not None:
    os.environ["AUTOPLANBENCH_NL2PDDL_PARALLEL"] = str(nl2p_par)

  dom_par = getattr(args, "domain_setup_parallel", None)
  if dom_par is not None:
    os.environ["AUTOPLANBENCH_DOMAIN_SETUP_PARALLEL"] = str(dom_par)

  if DEBUG and not pddl2pddl:
    try:
      from translator_settings import effective_domain_setup_parallel, effective_nl2pddl_parallel

      print(
        f"[sembenchrunning] AutoPlanBench HTTP parallelism: "
        f"domain_setup --parallel {effective_domain_setup_parallel()}, "
        f"nl2pddl --parallel {effective_nl2pddl_parallel()}",
        flush=True,
      )
    except Exception:
      pass

  refresh_both = getattr(args, "refresh_translation_caches", False)
  if refresh_both:
    if not args.dataset_dir or not args.dataset_dir.exists():
      raise SystemExit("--refresh-translation-caches requires existing --dataset-dir.")
    if not args.output_dir:
      raise SystemExit("--refresh-translation-caches requires --output-dir.")
    args.output_dir.mkdir(parents=True, exist_ok=True)
    n_p2n = _refresh_pddl2nl_cache(args.dataset_dir)
    print(f"[sembenchrunning] PDDL->NL cache refreshed: removed {n_p2n} domain_and_problem_nl.txt", flush=True)
    n_p2p_body = _refresh_pddl2pddl_body_cache(args.dataset_dir)
    print(f"[sembenchrunning] PDDL→PDDL body cache refreshed: removed {n_p2p_body} files", flush=True)
    n_n2p = _refresh_nl2pddl_cache(args.output_dir)
    print(f"[sembenchrunning] NL->PDDL cache refreshed: cleared plan_pred_pddl in {n_n2p} run files", flush=True)

  if getattr(args, "refresh_pddl2nl_cache", False) and not refresh_both:
    if not args.dataset_dir or not args.dataset_dir.exists():
      raise SystemExit("--refresh-pddl2nl-cache requires existing --dataset-dir.")
    n = _refresh_pddl2nl_cache(args.dataset_dir)
    print(f"[sembenchrunning] PDDL->NL cache refreshed: removed {n} domain_and_problem_nl.txt", flush=True)

  if getattr(args, "refresh_pddl2pddl_cache", False) and not refresh_both:
    if not args.dataset_dir or not args.dataset_dir.exists():
      raise SystemExit("--refresh-pddl2pddl-cache requires existing --dataset-dir.")
    n = _refresh_pddl2pddl_body_cache(args.dataset_dir)
    print(f"[sembenchrunning] PDDL→PDDL body cache refreshed: removed {n} files", flush=True)

  if getattr(args, "refresh_nl2pddl_cache", False) and not refresh_both:
    if not args.output_dir:
      raise SystemExit("--refresh-nl2pddl-cache requires --output-dir.")
    args.output_dir.mkdir(parents=True, exist_ok=True)
    n = _refresh_nl2pddl_cache(args.output_dir)
    print(f"[sembenchrunning] NL->PDDL cache refreshed: cleared plan_pred_pddl in {n} run files", flush=True)

  if args.metrics_only:
    if not args.output_dir or not args.dataset_dir or not args.dataset_dir.exists():
      raise SystemExit("--metrics-only requires --output-dir and existing --dataset-dir.")
    _check_val_binary(args.val_binary)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    print("[sembenchrunning] Metrics-only mode.", flush=True)
    dataset_dir = _normalize_dataset_dir(args.dataset_dir.resolve())
    if dataset_dir != args.dataset_dir.resolve():
      print(f"[sembenchrunning] Using normalized dataset root: {dataset_dir}", flush=True)
    # Для AutoPlanBench переводчика (NL->PDDL) нужен AUTOPLANBENCH_ROOT.
    apb_root = get_apb_root(args.autoplanbench_root)
    if apb_root is not None:
      os.environ["AUTOPLANBENCH_ROOT"] = str(apb_root.resolve())
    compute_metrics_phase(
      output_dir=args.output_dir,
      dataset_dir=dataset_dir,
      translator_spec=args.translator,
      val_binary=args.val_binary,
      val_timeout_seconds=args.val_timeout_seconds,
      nl2pddl_workers=args.nl2pddl_workers,
      run_id=args.run_id,
      limit=args.limit,
      domain_setup_seed=int(getattr(args, "autoplanbench_seed", 0) or 0),
      allow_reasoning_fallback=bool(getattr(args, "allow_reasoning_fallback", False)),
      models_config_path=args.config.resolve(),
      val_log_dir=_resolve_val_log_dir(args),
    )
    return

  models = getattr(args, "models", None) or []
  if not models:
    # Только --refresh-* без полного прогона: выходим после очистки кэша.
    if (
      getattr(args, "refresh_translation_caches", False)
      or getattr(args, "refresh_pddl2nl_cache", False)
      or getattr(args, "refresh_pddl2pddl_cache", False)
      or getattr(args, "refresh_nl2pddl_cache", False)
    ):
      return
    raise SystemExit("Need хотя бы один --model для прогона (omit for --metrics-only).")
  if not args.dataset_dir or not args.dataset_dir.exists():
    raise SystemExit("Need existing --dataset-dir for run phase.")
  if not args.prompt_translator:
    raise SystemExit("Need --prompt-translator (PDDL->NL prompt builder) for run phase.")
  dataset_dir = _normalize_dataset_dir(args.dataset_dir.resolve())
  if dataset_dir != args.dataset_dir.resolve():
    print(f"[sembenchrunning] Using normalized dataset root: {dataset_dir}", flush=True)

  cfg = load_config(str(args.config))
  args.output_dir.mkdir(parents=True, exist_ok=True)

  apb_root = get_apb_root(args.autoplanbench_root)
  if apb_root is not None:
    os.environ["AUTOPLANBENCH_ROOT"] = str(apb_root.resolve())
  ensure_opts = None
  if apb_root is not None and not getattr(args, "pddl2pddl", False):
    ensure_opts = {
      "apb_root": apb_root,
      "llm": args.autoplanbench_llm,
      "seed": getattr(args, "autoplanbench_seed", 0),
    }

  balance_failed_models: List[str] = []
  for model_name in models:
    try:
      asyncio.run(
        run_for_model_from_dataset(
          cfg=cfg,
          model_name=model_name,
          dataset_dir=dataset_dir,
          prompt_translator_spec=args.prompt_translator,
          output_dir=args.output_dir,
          max_concurrent=args.max_concurrent,
          batch_size=args.batch_size,
          limit=args.limit,
          ensure_domain_json_opts=ensure_opts,
          translate_workers=args.translate_workers,
          translator_spec=args.translator,
          rerun_truncated=args.rerun_truncated,
          rerun_all=args.rerun,
          domain_setup_seed=int(getattr(args, "autoplanbench_seed", 0) or 0),
          models_config_path=args.config.resolve(),
          pddl2pddl=bool(getattr(args, "pddl2pddl", False)),
        )
      )
    except InsufficientBalanceError as exc:
      balance_failed_models.append(model_name)
      print(
        f"[sembenchrunning] Модель {model_name!r}: недостаточно кредитов в OpenRouter ({exc}). "
        f"Пропускаю, продолжаю с остальными моделями.",
        flush=True,
      )
  if balance_failed_models:
    print(
      f"[sembenchrunning] Модели с ошибкой баланса: {balance_failed_models}",
      flush=True,
    )

  if args.dataset_dir and args.dataset_dir.exists() and not args.skip_metrics:
    _check_val_binary(args.val_binary)
    print("[sembenchrunning] Computing metrics...", flush=True)
    compute_metrics_phase(
      output_dir=args.output_dir,
      dataset_dir=dataset_dir,
      translator_spec=args.translator,
      val_binary=args.val_binary,
      val_timeout_seconds=args.val_timeout_seconds,
      nl2pddl_workers=args.nl2pddl_workers,
      run_id=args.run_id,
      limit=args.limit,
      domain_setup_seed=int(getattr(args, "autoplanbench_seed", 0) or 0),
      allow_reasoning_fallback=bool(getattr(args, "allow_reasoning_fallback", False)),
      models_config_path=args.config.resolve(),
      val_log_dir=_resolve_val_log_dir(args),
    )


if __name__ == "__main__":
  main()


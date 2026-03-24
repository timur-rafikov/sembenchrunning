"""
Сводка токенов/стоимости по этапам пайплайна в один объект pipeline_usage (в run JSON).

Этапы:
  planning       — openrouter_response.usage (запрос плана); при ошибке без ответа —
                   опционально openrouter_usage_recovered из тела ошибки.
  pddl2nl_prompt — у AutoPlanBench pddl_to_nl_prompt нет LLM на шаге промпта сэмпла
                   (run_save_descriptions --type full); tracked=false, не входит в totals как «LLM».
  nl2pddl        — openrouter_usage в *__nl2pddl_debug.json.
  domain_setup   — domain_llm_usage_seedN.json рядом с domain_description_seedN.json
                   (пишет autoplanbench после PDDL→NL домена в run_domain_setup).
                   В run JSON: tracked=false, included_in_per_run_totals=false (цифры справочные).

Поле totals (per-run):
  Суммирует только planning + pddl2nl_prompt + nl2pddl с tracked=true.
  domain_setup в totals НЕ входит: один файл domain_llm_usage часто относится ко многим сэмплам;
  агрегировать domain отдельно с дедупом по пути (collect_pipeline_token_usage.py).
"""
from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any, Dict, Optional, Tuple

from dataset_contracts import domain_setup_subdir_relative, parse_example_id


PDDL2NL_NOTE = (
  "autoplanbench_pddl2nl: run_save_descriptions.py --type full — шаблоны/JSON, без вызова LLM "
  "на построение промпта для сэмпла."
)

DOMAIN_SETUP_NO_FILE_NOTE = (
  "Файл domain_llm_usage_seedN.json не найден для section/subsection этого id "
  "(старый autoplanbench или домен не пересобирали). После run_domain_setup с обновлённым "
  "autoplanbench файл появится рядом с domain_description_seedN.json."
)

DOMAIN_SETUP_USAGE_FILE_NOTE = (
  "Данные из domain_llm_usage_seedN.json; tracked=false — этап не суммируется в pipeline_usage.totals "
  "(общая стоимость на много сэмплов, см. collect_pipeline_token_usage / дедуп по пути)."
)

NL2PDDL_USAGE_UNKNOWN_NOTE = (
  "В nl2pddl debug нет надёжных счётчиков токенов/cost. Значения totals не должны "
  "интерпретироваться как фактический нулевой расход."
)

# Подстроки лога AutoPlanBench/OpenRouter, по которым считаем что были HTTP-запросы.
# Можно расширить: NL2PDDL_API_LOG_MARKERS=marker1,marker2
_DEFAULT_NL2PDDL_API_MARKERS = ("[OpenRouter] Sending request", "OpenRouter API request")


def domain_setup_usage_path(dataset_dir: Path, example_id: str, seed: int) -> Optional[Path]:
  rel = domain_setup_subdir_relative(example_id)
  candidates = []
  if rel is not None:
    candidates.append((dataset_dir / rel / f"domain_llm_usage_seed{seed}.json").resolve())
  parsed = parse_example_id(example_id)
  if parsed is not None:
    section, subsection, sample_index = parsed
    # Backward compatibility for legacy layouts that stored usage at section/subsection
    # even when id had numeric sample index.
    if sample_index is not None:
      candidates.append((dataset_dir / section / subsection / f"domain_llm_usage_seed{seed}.json").resolve())
  for p in candidates:
    if p.is_file():
      return p
  return None


def load_domain_setup_usage_file(path: Path) -> Optional[Dict[str, Any]]:
  try:
    raw = json.loads(path.read_text(encoding="utf-8"))
  except Exception:
    return None
  if not isinstance(raw, dict):
    return None
  return raw


def normalize_openrouter_usage_counts(u: Optional[Dict[str, Any]]) -> Dict[str, Any]:
  """Нормализованные prompt/completion/total/cost (алиасы input_tokens/output_tokens, исправление total=0)."""
  return _num_tokens_slice(u)


def _num_tokens_slice(u: Optional[Dict[str, Any]]) -> Dict[str, Any]:
  if not u or not isinstance(u, dict):
    return {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0, "cost": 0.0}
  out: Dict[str, Any] = {
    "prompt_tokens": 0,
    "completion_tokens": 0,
    "total_tokens": 0,
    "cost": 0.0,
  }
  for k in ("prompt_tokens", "completion_tokens", "total_tokens"):
    if k in u and u[k] is not None:
      try:
        out[k] = int(u[k])
      except (TypeError, ValueError):
        pass
  if out["prompt_tokens"] == 0 and u.get("input_tokens") is not None:
    try:
      out["prompt_tokens"] = int(u["input_tokens"])
    except (TypeError, ValueError):
      pass
  if out["completion_tokens"] == 0 and u.get("output_tokens") is not None:
    try:
      out["completion_tokens"] = int(u["output_tokens"])
    except (TypeError, ValueError):
      pass
  c = u.get("cost")
  if c is not None:
    try:
      out["cost"] = float(c)
    except (TypeError, ValueError):
      pass
  # Некоторые провайдеры отдают total_tokens=0 при ненулевых prompt/completion.
  pt, ct, tt = out["prompt_tokens"], out["completion_tokens"], out["total_tokens"]
  if tt <= 0 and pt + ct > 0:
    out["total_tokens"] = pt + ct
  return out


def _is_tracked_stage(u: Optional[Dict[str, Any]]) -> bool:
  return bool(isinstance(u, dict) and u.get("tracked") is True)


def _with_tracked_flag(u: Optional[Dict[str, Any]], *, tracked: bool, note: Optional[str] = None) -> Dict[str, Any]:
  base = dict(u) if isinstance(u, dict) else {}
  base["tracked"] = tracked
  if note and "note" not in base:
    base["note"] = note
  base.update(_num_tokens_slice(u))
  return base


def _add_slices(a: Dict[str, Any], b: Dict[str, Any]) -> Dict[str, Any]:
  return {
    "prompt_tokens": int(a.get("prompt_tokens", 0) or 0) + int(b.get("prompt_tokens", 0) or 0),
    "completion_tokens": int(a.get("completion_tokens", 0) or 0) + int(b.get("completion_tokens", 0) or 0),
    "total_tokens": int(a.get("total_tokens", 0) or 0) + int(b.get("total_tokens", 0) or 0),
    "cost": float(a.get("cost", 0) or 0) + float(b.get("cost", 0) or 0),
  }


def planning_usage_from_run_data(data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
  u: Optional[Dict[str, Any]] = None
  resp = data.get("openrouter_response")
  if isinstance(resp, dict):
    raw = resp.get("usage")
    if isinstance(raw, dict) and raw:
      u = raw
  if u is None:
    rec = data.get("openrouter_usage_recovered")
    if isinstance(rec, dict) and rec:
      u = rec
  if not isinstance(u, dict) or not u:
    return None
  out: Dict[str, Any] = {k: v for k, v in u.items() if not str(k).startswith("_")}
  if not out:
    return None
  out["tracked"] = True
  if data.get("error") is not None:
    out["billing_context_note"] = (
      "В run есть top-level error; usage всё же сохранён (провайдер мог списать токены) "
      "или восстановлен из тела ошибки (openrouter_usage_recovered)."
    )
  out.update(_num_tokens_slice(out))
  return out


def _nl2pddl_api_log_markers() -> Tuple[str, ...]:
  env = os.environ.get("NL2PDDL_API_LOG_MARKERS", "").strip()
  if env:
    return tuple(s.strip() for s in env.split(",") if s.strip())
  return _DEFAULT_NL2PDDL_API_MARKERS


def annotate_nl2pddl_openrouter_usage(
  ou: Dict[str, Any],
  *,
  stdout_text: str = "",
  stderr_text: str = "",
) -> Dict[str, Any]:
  """
  Копия openrouter_usage с полями tracked / note по тем же правилам, что merge в pipeline_usage.
  Используется в collect_pipeline_token_usage для согласованных сумм с pipeline_usage.totals.
  """
  out = dict(ou)
  combined = f"{stdout_text or ''}\n{stderr_text or ''}"
  markers = _nl2pddl_api_log_markers()
  has_api_requests = any(m in combined for m in markers)
  nums = _num_tokens_slice(ou)
  all_zero = (
    int(nums.get("prompt_tokens", 0) or 0) == 0
    and int(nums.get("completion_tokens", 0) or 0) == 0
    and int(nums.get("total_tokens", 0) or 0) == 0
    and float(nums.get("cost", 0.0) or 0.0) == 0.0
  )
  tracked = True
  note: Optional[str] = None
  if has_api_requests and all_zero:
    tracked = False
    note = NL2PDDL_USAGE_UNKNOWN_NOTE
  elif not any(
    k in ou
    for k in (
      "prompt_tokens",
      "completion_tokens",
      "total_tokens",
      "cost",
      "input_tokens",
      "output_tokens",
    )
  ):
    tracked = False
    note = NL2PDDL_USAGE_UNKNOWN_NOTE
  out["tracked"] = tracked
  if note:
    out["note"] = note
  out.update(_num_tokens_slice(out))
  return out


def nl2pddl_usage_from_debug_file(debug_path: Path) -> Optional[Dict[str, Any]]:
  if not debug_path.is_file():
    return None
  try:
    dbg = json.loads(debug_path.read_text(encoding="utf-8"))
  except Exception:
    return None
  if not isinstance(dbg, dict):
    return None
  ou = dbg.get("openrouter_usage")
  if not isinstance(ou, dict) or not ou:
    return None
  stdout = dbg.get("stdout")
  stdout_text = stdout if isinstance(stdout, str) else ""
  stderr = dbg.get("stderr")
  stderr_text = stderr if isinstance(stderr, str) else ""
  return annotate_nl2pddl_openrouter_usage(ou, stdout_text=stdout_text, stderr_text=stderr_text)


def default_pddl2nl_block() -> Dict[str, Any]:
  return {
    "stage": "pddl2nl_prompt",
    "tracked": False,
    "note": PDDL2NL_NOTE,
    **_num_tokens_slice({}),
  }


def default_domain_setup_block() -> Dict[str, Any]:
  return {
    "tracked": False,
    "included_in_per_run_totals": False,
    "usage_file_loaded": False,
    "note": DOMAIN_SETUP_NO_FILE_NOTE,
    **_num_tokens_slice({}),
  }


def build_pipeline_usage(
  *,
  planning: Optional[Dict[str, Any]],
  nl2pddl: Optional[Dict[str, Any]],
  pddl2nl: Optional[Dict[str, Any]] = None,
  domain_setup: Optional[Dict[str, Any]] = None,
) -> Dict[str, Any]:
  p2n = pddl2nl if pddl2nl is not None else default_pddl2nl_block()
  ds = domain_setup if domain_setup is not None else default_domain_setup_block()
  plan = _with_tracked_flag(planning, tracked=True) if planning is not None else None
  n2p = nl2pddl if nl2pddl is not None else None
  if n2p is not None and "tracked" not in n2p:
    n2p = _with_tracked_flag(n2p, tracked=True)
  if "tracked" not in p2n:
    p2n = _with_tracked_flag(p2n, tracked=False, note=PDDL2NL_NOTE)
  if "tracked" not in ds:
    ds = _with_tracked_flag(ds, tracked=False, note=DOMAIN_SETUP_NO_FILE_NOTE)
  tot = _num_tokens_slice({})
  if _is_tracked_stage(plan):
    tot = _add_slices(tot, _num_tokens_slice(plan))
  if _is_tracked_stage(p2n):
    tot = _add_slices(tot, _num_tokens_slice(p2n))
  if _is_tracked_stage(n2p):
    tot = _add_slices(tot, _num_tokens_slice(n2p))
  # domain_setup намеренно не суммируем: см. module docstring (shared cost across samples).
  totals_scope_note = (
    "Per-run totals = planning + pddl2nl_prompt + nl2pddl (только tracked=true). "
    "domain_setup всегда вне totals (included_in_per_run_totals=false); цифры в блоке — для справки, "
    "агрегировать отдельно: domain_llm_usage_seed*.json + дедуп в collect_pipeline_token_usage.py."
  )
  return {
    "planning": plan,
    "pddl2nl_prompt": p2n,
    "nl2pddl": n2p,
    "domain_setup": ds,
    "totals": tot,
    "totals_scope_note": totals_scope_note,
  }


def merge_pipeline_usage_into_run_data(
  path: Path,
  data: Dict[str, Any],
  *,
  include_nl2pddl_from_debug: bool = True,
  dataset_dir: Optional[Path] = None,
  domain_setup_seed: int = 0,
) -> Tuple[Dict[str, Any], bool]:
  """
  Дополняет data['pipeline_usage'].
  domain_setup читается из domain_llm_usage_seed{seed}.json по id сэмпла и dataset_dir.
  """
  changed = False
  planning = planning_usage_from_run_data(data)
  prev = data.get("pipeline_usage")
  prev_p2n = None
  prev_nl2pddl = None
  prev_ds = None
  if isinstance(prev, dict):
    prev_p2n = prev.get("pddl2nl_prompt")
    prev_nl2pddl = prev.get("nl2pddl")
    prev_ds = prev.get("domain_setup")

  nl2pddl: Optional[Dict[str, Any]]
  if include_nl2pddl_from_debug:
    dbg = path.with_name(path.stem + "__nl2pddl_debug.json")
    nl2pddl = nl2pddl_usage_from_debug_file(dbg)
  else:
    nl2pddl = prev_nl2pddl if isinstance(prev_nl2pddl, dict) else None

  domain_setup: Optional[Dict[str, Any]] = None
  ex_id = data.get("id")
  if dataset_dir is not None and ex_id:
    p = domain_setup_usage_path(Path(dataset_dir), str(ex_id), int(domain_setup_seed))
    if p is not None:
      loaded = load_domain_setup_usage_file(p)
      if loaded:
        domain_setup = dict(loaded)
        domain_setup["tracked"] = False
        domain_setup["included_in_per_run_totals"] = False
        domain_setup["usage_file_loaded"] = True
        domain_setup["usage_source_path"] = str(p.as_posix())
        domain_setup["note"] = DOMAIN_SETUP_USAGE_FILE_NOTE
    if domain_setup is None:
      domain_setup = prev_ds if isinstance(prev_ds, dict) else default_domain_setup_block()
  else:
    domain_setup = prev_ds if isinstance(prev_ds, dict) else default_domain_setup_block()

  p2n = prev_p2n if isinstance(prev_p2n, dict) else default_pddl2nl_block()
  new_usage = build_pipeline_usage(
    planning=planning,
    nl2pddl=nl2pddl,
    pddl2nl=p2n,
    domain_setup=domain_setup,
  )

  if prev != new_usage:
    data["pipeline_usage"] = new_usage
    changed = True
  return data, changed

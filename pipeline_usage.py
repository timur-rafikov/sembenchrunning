"""
Сводка токенов/стоимости по этапам пайплайна в один объект pipeline_usage (в run JSON).

Этапы:
  planning       — openrouter_response.usage (запрос плана).
  pddl2nl_prompt — у AutoPlanBench pddl_to_nl_prompt нет LLM на шаге промпта сэмпла
                   (run_save_descriptions --type full).
  nl2pddl        — openrouter_usage в *__nl2pddl_debug.json.
  domain_setup   — domain_llm_usage_seedN.json рядом с domain_description_seedN.json
                   (пишет autoplanbench после PDDL→NL домена в run_domain_setup).
"""
from __future__ import annotations

import json
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

NL2PDDL_USAGE_UNKNOWN_NOTE = (
  "В nl2pddl debug нет надёжных счётчиков токенов/cost. Значения totals не должны "
  "интерпретироваться как фактический нулевой расход."
)


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
  c = u.get("cost")
  if c is not None:
    try:
      out["cost"] = float(c)
    except (TypeError, ValueError):
      pass
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
  resp = data.get("openrouter_response")
  if not isinstance(resp, dict):
    return None
  u = resp.get("usage")
  if not isinstance(u, dict):
    return None
  out: Dict[str, Any] = {}
  for k in (
    "prompt_tokens",
    "completion_tokens",
    "total_tokens",
    "cost",
    "is_byok",
    "prompt_tokens_details",
    "completion_tokens_details",
    "cost_details",
  ):
    if k in u:
      out[k] = u[k]
  if not out:
    return None
  out["tracked"] = True
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
  out = dict(ou)
  stdout = dbg.get("stdout")
  stdout_text = stdout if isinstance(stdout, str) else ""
  has_api_requests = "[OpenRouter] Sending request" in stdout_text
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
  elif not any(k in ou for k in ("prompt_tokens", "completion_tokens", "total_tokens", "cost")):
    tracked = False
    note = NL2PDDL_USAGE_UNKNOWN_NOTE
  out["tracked"] = tracked
  if note:
    out["note"] = note
  return out


def default_pddl2nl_block() -> Dict[str, Any]:
  return {
    "stage": "pddl2nl_prompt",
    "tracked": True,
    "note": PDDL2NL_NOTE,
    **_num_tokens_slice({}),
  }


def default_domain_setup_block() -> Dict[str, Any]:
  return {
    "tracked": False,
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
    p2n = _with_tracked_flag(p2n, tracked=True, note=PDDL2NL_NOTE)
  if "tracked" not in ds:
    ds = _with_tracked_flag(ds, tracked=False, note=DOMAIN_SETUP_NO_FILE_NOTE)
  tot = _num_tokens_slice({})
  if _is_tracked_stage(plan):
    tot = _add_slices(tot, _num_tokens_slice(plan))
  if _is_tracked_stage(p2n):
    tot = _add_slices(tot, _num_tokens_slice(p2n))
  if _is_tracked_stage(n2p):
    tot = _add_slices(tot, _num_tokens_slice(n2p))
  if _is_tracked_stage(ds):
    tot = _add_slices(tot, _num_tokens_slice(ds))
  return {
    "planning": plan,
    "pddl2nl_prompt": p2n,
    "nl2pddl": n2p,
    "domain_setup": ds,
    "totals": tot,
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
        domain_setup["tracked"] = True
        domain_setup["usage_source_path"] = str(p.as_posix())
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

#!/usr/bin/env python3
"""
Сбор статистики по токенам и стоимости там, где они записаны в логах sembenchrunning.

Этапы пайплайна:
  1) Планирование (один запрос OpenRouter на сэмпл) — openrouter_response.usage; плюс в run JSON
     может быть pipeline_usage.totals (сумма этапов: планирование + nl2pddl + нули для pddl2nl_prompt).
  2) PDDL->NL промпт сэмпла (autoplanbench_pddl2nl): run_save_descriptions --type full — без LLM
     на этом шаге. Отдельно domain setup (run_domain_setup): токены в domain_llm_usage_seedN.json
     и в pipeline_usage.domain_setup в run JSON (если прогон обновлял pipeline_usage).
  3) NL->PDDL: фактические токены только из ответа API — поле openrouter_usage в *__nl2pddl_debug.json
     (дублируется в pipeline_usage.nl2pddl в run JSON после merge). Если в debug нет openrouter_usage,
     по артефактам восстановить расход нельзя (нужен перезапуск перевода с логированием или биллинг OpenRouter).

  Дополнительно: блок «последний прогон» — самый свежий по mtime run JSON с полем id;
  к нему подбирается пара *__nl2pddl_debug.json (переводчик) и кратко печатается planning.usage.

Использование:
  python scripts/collect_pipeline_token_usage.py
  python scripts/collect_pipeline_token_usage.py --output-dir runs/batch_samples
  python scripts/collect_pipeline_token_usage.py --output-dir runs/batch_samples --dataset-dir data/batch_samples
  python scripts/collect_pipeline_token_usage.py --output-dir runs/batch_samples --json-out runs/usage_summary.json
"""

from __future__ import annotations

import argparse
import json
import re
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple


def _usage_from_run(data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
  resp = data.get("openrouter_response")
  if not isinstance(resp, dict):
    return None
  u = resp.get("usage")
  return u if isinstance(u, dict) else None


def _nl2pddl_requests_from_debug(data: Dict[str, Any]) -> Optional[Tuple[int, int, int]]:
  """Parse 'Parallel HTTP translation done: 82 requests (40 from cache, 42 from API)'."""
  stdout = (data.get("stdout") or "") if isinstance(data.get("stdout"), str) else ""
  m = re.search(
    r"(\d+)\s+requests\s*\(\s*(\d+)\s+from cache,\s*(\d+)\s+from API\s*\)",
    stdout,
    re.I,
  )
  if m:
    return int(m.group(1)), int(m.group(2)), int(m.group(3))
  return None


def _nl2pddl_openrouter_usage_numbers(usage: Any) -> Tuple[float, float, float, float]:
  """Returns (prompt_tokens, completion_tokens, total_tokens, cost) from openrouter_usage dict."""
  if not isinstance(usage, dict):
    return 0.0, 0.0, 0.0, 0.0
  try:
    pt = float(usage.get("prompt_tokens") or 0)
    ct = float(usage.get("completion_tokens") or 0)
    tt = float(usage.get("total_tokens") or 0)
  except (TypeError, ValueError):
    return 0.0, 0.0, 0.0, 0.0
  cost_raw = usage.get("cost")
  try:
    cost_f = float(cost_raw) if cost_raw is not None else 0.0
  except (TypeError, ValueError):
    cost_f = 0.0
  return pt, ct, tt, cost_f


def _mtime_utc_iso(path: Path) -> str:
  return datetime.fromtimestamp(path.stat().st_mtime, tz=timezone.utc).isoformat()


def find_last_run_json_path(output_dir: Path) -> Optional[Path]:
  """Самый свежий по mtime run JSON (не nl2pddl_debug), с полем id как у batch-сэмплов."""
  best_mtime: float = -1.0
  best_path: Optional[Path] = None
  for path in output_dir.rglob("*.json"):
    if not path.is_file():
      continue
    if path.name.endswith("__nl2pddl_debug.json"):
      continue
    try:
      data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
      continue
    if not isinstance(data, dict) or "id" not in data:
      continue
    mtime = path.stat().st_mtime
    if mtime > best_mtime:
      best_mtime = mtime
      best_path = path
  return best_path


def collect_last_run_translator(output_dir: Path) -> Dict[str, Any]:
  """
  Информация о последнем прогоне: планирование (usage) + переводчик NL->PDDL из пары *__nl2pddl_debug.json.
  """
  run_path = find_last_run_json_path(output_dir)
  if not run_path:
    return {
      "found": False,
      "note": "no run JSON with field id under output_dir",
    }

  rel_run = str(run_path.relative_to(output_dir))
  out: Dict[str, Any] = {
    "found": True,
    "run_file": rel_run,
    "mtime_utc": _mtime_utc_iso(run_path),
  }

  try:
    run_data = json.loads(run_path.read_text(encoding="utf-8"))
  except Exception as e:
    out["run_parse_error"] = str(e)
    return out

  if isinstance(run_data, dict):
    out["example_id"] = run_data.get("id")
    out["model"] = run_data.get("model_name") or run_data.get("model")
    if run_data.get("error"):
      out["planning"] = {"has_usage": False, "note": "top-level error payload"}
    else:
      u = _usage_from_run(run_data)
      if u:
        pt = float(u.get("prompt_tokens") or 0)
        ct = float(u.get("completion_tokens") or 0)
        tt = float(u.get("total_tokens") or (pt + ct))
        cost = u.get("cost")
        out["planning"] = {
          "has_usage": True,
          "prompt_tokens": pt,
          "completion_tokens": ct,
          "total_tokens": tt,
          "cost": float(cost) if cost is not None else None,
        }
      else:
        out["planning"] = {"has_usage": False, "note": "no openrouter_response.usage"}
    pu = run_data.get("pipeline_usage")
    if isinstance(pu, dict):
      out["pipeline_usage"] = pu

  debug_path = run_path.parent / f"{run_path.stem}__nl2pddl_debug.json"
  rel_debug = str(debug_path.relative_to(output_dir)) if debug_path.is_file() else None
  out["nl2pddl_debug_file"] = rel_debug

  if not debug_path.is_file():
    out["translator"] = None
    out["translator_note"] = f"missing paired file: {run_path.stem}__nl2pddl_debug.json"
    return out

  try:
    dbg = json.loads(debug_path.read_text(encoding="utf-8"))
  except Exception as e:
    out["translator"] = None
    out["translator_parse_error"] = str(e)
    return out

  if not isinstance(dbg, dict):
    out["translator"] = None
    out["translator_note"] = "nl2pddl debug is not a JSON object"
    return out

  parsed = _nl2pddl_requests_from_debug(dbg)
  translator: Dict[str, Any] = {
    "tool": dbg.get("tool"),
    "model_path": dbg.get("model_path"),
    "parallel": dbg.get("parallel"),
    "timeout_s": dbg.get("timeout_s"),
    "elapsed_s": dbg.get("elapsed_s"),
    "returncode": dbg.get("returncode"),
    "prompt_file": dbg.get("prompt_file"),
  }
  if parsed:
    total, cache, api = parsed
    translator["translation_http_rounds"] = total
    translator["from_cache"] = cache
    translator["from_api"] = api
  else:
    translator["translation_http_rounds"] = None
    translator["from_cache"] = None
    translator["from_api"] = None
    translator["stdout_parse_note"] = "could not parse requests line in stdout"

  ou = dbg.get("openrouter_usage")
  if isinstance(ou, dict) and ou:
    translator["openrouter_usage"] = ou
    pt, ct, tt, cf = _nl2pddl_openrouter_usage_numbers(ou)
    translator["openrouter_usage_summary"] = {
      "prompt_tokens": int(pt),
      "completion_tokens": int(ct),
      "total_tokens": int(tt),
      "cost": cf,
    }

  out["translator"] = translator
  return out


def collect_runs(output_dir: Path) -> Tuple[List[Dict], Dict[str, Any]]:
  rows: List[Dict[str, Any]] = []
  by_model: Dict[str, Dict[str, float]] = defaultdict(
    lambda: {
      "files": 0,
      "with_usage": 0,
      "prompt_tokens": 0.0,
      "completion_tokens": 0.0,
      "total_tokens": 0.0,
      "cost": 0.0,
    }
  )
  totals: Dict[str, Any] = {
    "run_files": 0,
    "runs_with_usage": 0,
    "runs_errors_only": 0,
    "runs_usage_despite_top_level_error": 0,
    "prompt_tokens": 0.0,
    "completion_tokens": 0.0,
    "total_tokens": 0.0,
    "cost": 0.0,
  }

  for path in sorted(output_dir.rglob("*.json")):
    if not path.is_file():
      continue
    if path.name.endswith("__nl2pddl_debug.json"):
      continue
    if path.name in ("metrics.jsonl",) or "metrics" in path.name and path.suffix == ".jsonl":
      continue
    try:
      data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
      continue
    if not isinstance(data, dict):
      continue
    totals["run_files"] += 1
    model = str(data.get("model_name") or data.get("model") or "unknown")
    by_model[model]["files"] += 1

    u = _usage_from_run(data)
    top_err = bool(data.get("error"))

    if not u:
      if top_err:
        totals["runs_errors_only"] += 1
        rows.append(
          {
            "file": str(path.relative_to(output_dir)),
            "model": model,
            "stage": "planning",
            "has_usage": False,
            "note": "error payload, no openrouter_response.usage",
          }
        )
      else:
        rows.append(
          {
            "file": str(path.relative_to(output_dir)),
            "model": model,
            "stage": "planning",
            "has_usage": False,
            "note": "no usage in openrouter_response",
          }
        )
      continue

    by_model[model]["with_usage"] += 1
    totals["runs_with_usage"] += 1
    if top_err:
      totals["runs_usage_despite_top_level_error"] += 1
    pt = float(u.get("prompt_tokens") or 0)
    ct = float(u.get("completion_tokens") or 0)
    tt = float(u.get("total_tokens") or (pt + ct))
    cost = u.get("cost")
    cost_f = float(cost) if cost is not None else 0.0

    by_model[model]["prompt_tokens"] += pt
    by_model[model]["completion_tokens"] += ct
    by_model[model]["total_tokens"] += tt
    by_model[model]["cost"] += cost_f

    totals["prompt_tokens"] += pt
    totals["completion_tokens"] += ct
    totals["total_tokens"] += tt
    totals["cost"] += cost_f

    row: Dict[str, Any] = {
      "file": str(path.relative_to(output_dir)),
      "model": model,
      "stage": "planning",
      "has_usage": True,
      "prompt_tokens": pt,
      "completion_tokens": ct,
      "total_tokens": tt,
      "cost": cost_f,
    }
    if top_err:
      row["note"] = "openrouter_response.usage present despite top-level error key"
    rows.append(row)

  return rows, {"totals": totals, "by_model": dict(by_model)}


def collect_pipeline_usage_from_run_jsons(output_dir: Path) -> Dict[str, Any]:
  """Суммы по полю pipeline_usage.totals в run JSON (после прогона run_benchmark + метрик)."""
  acc = {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0, "cost": 0.0}
  runs_with = 0
  for path in sorted(output_dir.rglob("*.json")):
    if not path.is_file():
      continue
    if path.name.endswith("__nl2pddl_debug.json"):
      continue
    try:
      data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
      continue
    if not isinstance(data, dict) or "id" not in data:
      continue
    pu = data.get("pipeline_usage")
    if not isinstance(pu, dict):
      continue
    t = pu.get("totals")
    if not isinstance(t, dict):
      continue
    runs_with += 1
    acc["prompt_tokens"] += int(t.get("prompt_tokens") or 0)
    acc["completion_tokens"] += int(t.get("completion_tokens") or 0)
    acc["total_tokens"] += int(t.get("total_tokens") or 0)
    try:
      acc["cost"] += float(t.get("cost") or 0)
    except (TypeError, ValueError):
      pass
  return {
    "runs_with_pipeline_usage": runs_with,
    "totals": acc,
    "note": "totals = planning + pddl2nl_prompt (0 LLM) + nl2pddl + domain_setup (domain_llm_usage_seedN.json)",
  }


def collect_nl2pddl_from_pipeline_usage_in_runs(output_dir: Path) -> Dict[str, Any]:
  """Факт NL2PDDL из pipeline_usage.nl2pddl в run JSON (те же цифры, что из debug после merge)."""
  acc = {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0, "cost": 0.0}
  runs_with_nl2pddl = 0
  runs_with_untracked_nl2pddl = 0
  for path in sorted(output_dir.rglob("*.json")):
    if not path.is_file():
      continue
    if path.name.endswith("__nl2pddl_debug.json"):
      continue
    try:
      data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
      continue
    if not isinstance(data, dict) or "id" not in data:
      continue
    pu = data.get("pipeline_usage")
    if not isinstance(pu, dict):
      continue
    nl = pu.get("nl2pddl")
    if not isinstance(nl, dict) or not nl:
      continue
    if nl.get("tracked") is not True:
      runs_with_untracked_nl2pddl += 1
      continue
    runs_with_nl2pddl += 1
    pt, ct, tt, cf = _nl2pddl_openrouter_usage_numbers(nl)
    acc["prompt_tokens"] += int(pt)
    acc["completion_tokens"] += int(ct)
    acc["total_tokens"] += int(tt)
    acc["cost"] += float(cf)
  return {
    "runs_with_nl2pddl_usage_in_pipeline": runs_with_nl2pddl,
    "runs_with_untracked_nl2pddl_usage_in_pipeline": runs_with_untracked_nl2pddl,
    "totals": acc,
    "note": "сумма по run JSON, где pipeline_usage.nl2pddl помечен tracked=true (источник — openrouter_usage из debug при merge)",
  }


def collect_nl2pddl_debug(output_dir: Path) -> Dict[str, Any]:
  """HTTP rounds из stdout debug + суммы openrouter_usage (токены/cost перевода NL->PDDL)."""
  per_file: List[Dict[str, Any]] = []
  sum_total = sum_cache = sum_api = 0
  sum_pt = sum_ct = sum_tt = sum_cost = 0.0
  files_with_usage = 0
  sum_api_rounds_with_usage_log = 0
  sum_api_rounds_without_usage_log = 0
  debug_files_without_openrouter_usage = 0
  for path in sorted(output_dir.rglob("*__nl2pddl_debug.json")):
    if not path.is_file():
      continue
    try:
      data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
      continue
    if not isinstance(data, dict):
      continue
    rel = str(path.relative_to(output_dir))
    entry: Dict[str, Any] = {"file": rel}
    parsed = _nl2pddl_requests_from_debug(data)
    if parsed:
      total, cache, api = parsed
      sum_total += total
      sum_cache += cache
      sum_api += api
      entry["parsed_rounds"] = True
      entry["translation_http_rounds"] = total
      entry["from_cache"] = cache
      entry["from_api"] = api
    else:
      entry["parsed_rounds"] = False

    ou = data.get("openrouter_usage")
    api_n = int(entry.get("from_api") or 0)
    if isinstance(ou, dict) and ou:
      pt, ct, tt, cf = _nl2pddl_openrouter_usage_numbers(ou)
      if pt or ct or tt or cf:
        files_with_usage += 1
      sum_pt += pt
      sum_ct += ct
      sum_tt += tt
      sum_cost += cf
      entry["openrouter_usage"] = ou
      sum_api_rounds_with_usage_log += api_n
    else:
      entry["openrouter_usage"] = None
      sum_api_rounds_without_usage_log += api_n
      debug_files_without_openrouter_usage += 1

    per_file.append(entry)

  return {
    "stage": "nl2pddl",
    "note": (
      "translation_http_rounds from AutoPlanBench stdout; "
      "openrouter_usage from autoplanbench stdout line (AUTOPLANBENCH_NL2PDDL_USAGE) stored by sembenchrunning"
    ),
    "sum_translation_rounds": sum_total,
    "sum_from_cache": sum_cache,
    "sum_from_api": sum_api,
    "sum_openrouter_prompt_tokens": int(sum_pt),
    "sum_openrouter_completion_tokens": int(sum_ct),
    "sum_openrouter_total_tokens": int(sum_tt),
    "sum_openrouter_cost": sum_cost,
    "debug_files_with_openrouter_usage": files_with_usage,
    "debug_files_without_openrouter_usage": debug_files_without_openrouter_usage,
    "sum_api_rounds_with_usage_log": sum_api_rounds_with_usage_log,
    "sum_api_rounds_without_usage_log": sum_api_rounds_without_usage_log,
    "debug_files_total": len(per_file),
    "files": per_file,
  }


def collect_domain_llm_usage(dataset_dir: Path) -> Dict[str, Any]:
  """Сумма по уникальным domain_llm_usage_seed*.json в датасете (один файл на section/subsection)."""
  if not dataset_dir.is_dir():
    return {
      "dataset_dir": str(dataset_dir),
      "unique_files": 0,
      "totals": {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0, "cost": 0.0},
      "note": "dataset_dir not found",
    }
  seen: set[Path] = set()
  tot = {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0, "cost": 0.0}
  n = 0
  for path in sorted(dataset_dir.rglob("domain_llm_usage_seed*.json")):
    if not path.is_file():
      continue
    rp = path.resolve()
    if rp in seen:
      continue
    seen.add(rp)
    try:
      raw = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
      continue
    if not isinstance(raw, dict):
      continue
    tot["prompt_tokens"] += int(raw.get("prompt_tokens") or 0)
    tot["completion_tokens"] += int(raw.get("completion_tokens") or 0)
    tot["total_tokens"] += int(raw.get("total_tokens") or 0)
    try:
      tot["cost"] += float(raw.get("cost") or 0)
    except (TypeError, ValueError):
      pass
    n += 1
  return {
    "dataset_dir": str(dataset_dir.resolve()),
    "unique_files": n,
    "totals": tot,
    "note": "дедуп по пути; domain setup один на подраздел датасета",
  }


def main() -> None:
  root = Path(__file__).resolve().parents[1]
  parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
  parser.add_argument(
    "--output-dir",
    type=Path,
    default=root / "runs" / "batch_samples",
    help="Каталог с run JSON и nl2pddl debug (по умолчанию runs/batch_samples)",
  )
  parser.add_argument(
    "--json-out",
    type=Path,
    default=None,
    help="Сохранить полный отчёт в JSON",
  )
  _def_ds = root / "data" / "batch_samples"
  parser.add_argument(
    "--dataset-dir",
    type=Path,
    default=_def_ds if _def_ds.is_dir() else root / "data",
    help="Каталог датасета с domain_llm_usage_seed*.json (по умолчанию data/batch_samples или data)",
  )
  args = parser.parse_args()
  out = args.output_dir.resolve()
  if not out.is_dir():
    raise SystemExit(f"Not a directory: {out}")
  dataset_dir = args.dataset_dir.resolve()

  rows, agg = collect_runs(out)
  pipeline_usage_runs = collect_pipeline_usage_from_run_jsons(out)
  nl2pddl = collect_nl2pddl_debug(out)
  nl2pddl_in_pipeline = collect_nl2pddl_from_pipeline_usage_in_runs(out)
  domain_llm = collect_domain_llm_usage(dataset_dir)
  last_run = collect_last_run_translator(out)

  print("=" * 60)
  print("Этап: ПЛАНИРОВАНИЕ (OpenRouter, поле openrouter_response.usage в run JSON)")
  print("=" * 60)
  t = agg["totals"]
  print(f"  Run-файлов (без nl2pddl_debug):     {t['run_files']}")
  print(f"  С полем usage:                      {t['runs_with_usage']}")
  print(f"  Только error (без успешного usage): {t['runs_errors_only']}")
  print(f"  Usage при top-level error:          {t.get('runs_usage_despite_top_level_error', 0)}")
  print(f"  Сумма prompt_tokens:                 {int(t['prompt_tokens'])}")
  print(f"  Сумма completion_tokens:             {int(t['completion_tokens'])}")
  print(f"  Сумма total_tokens:                  {int(t['total_tokens'])}")
  if t["cost"] > 0:
    print(f"  Сумма cost (если есть в ответе):     {t['cost']:.6f}")

  print("\n  По моделям:")
  for model, s in sorted(agg["by_model"].items()):
    print(
      f"    {model}: files={s['files']}, with_usage={int(s['with_usage'])}, "
      f"prompt={int(s['prompt_tokens'])}, completion={int(s['completion_tokens'])}, "
      f"total={int(s['total_tokens'])}, cost={s['cost']:.6f}"
    )

  print("\n" + "=" * 60)
  print("Сводка pipeline_usage в run JSON (планирование + NL2PDDL + ...)")
  print("=" * 60)
  pw = pipeline_usage_runs
  print(f"  {pw.get('note', '')}")
  print(f"  Run-файлов с pipeline_usage.totals: {pw['runs_with_pipeline_usage']}")
  if pw["runs_with_pipeline_usage"]:
    pt = pw["totals"]
    print(f"  Сумма totals prompt_tokens:     {int(pt['prompt_tokens'])}")
    print(f"  Сумма totals completion_tokens: {int(pt['completion_tokens'])}")
    print(f"  Сумма totals total_tokens:      {int(pt['total_tokens'])}")
    if pt["cost"] > 0:
      print(f"  Сумма totals cost:              {pt['cost']:.6f}")

  print("\n" + "=" * 60)
  print("Последний прогон: планирование + переводчик NL->PDDL (по mtime run JSON)")
  print("=" * 60)
  if not last_run.get("found"):
    print(f"  {last_run.get('note', 'not found')}")
  else:
    print(f"  run JSON:        {last_run.get('run_file')}")
    print(f"  mtime (UTC):     {last_run.get('mtime_utc')}")
    print(f"  example_id:      {last_run.get('example_id')}")
    print(f"  model:           {last_run.get('model')}")
    pl = last_run.get("planning")
    if isinstance(pl, dict):
      if pl.get("has_usage"):
        print(
          f"  planning usage:  prompt={int(pl['prompt_tokens'])}, "
          f"completion={int(pl['completion_tokens'])}, total={int(pl['total_tokens'])}"
        )
        if pl.get("cost") is not None:
          print(f"                   cost={float(pl['cost']):.6f}")
      else:
        print(f"  planning usage:  (нет) — {pl.get('note', 'n/a')}")
    pu = last_run.get("pipeline_usage")
    if isinstance(pu, dict):
      tot = pu.get("totals")
      if isinstance(tot, dict):
        print(
          f"  pipeline totals: prompt={int(tot.get('prompt_tokens', 0))}, "
          f"completion={int(tot.get('completion_tokens', 0))}, total={int(tot.get('total_tokens', 0))}"
        )
        tc = tot.get("cost")
        if tc is not None and float(tc) > 0:
          print(f"                   cost={float(tc):.6f}")
    dbg_f = last_run.get("nl2pddl_debug_file")
    tr = last_run.get("translator")
    if dbg_f:
      print(f"  nl2pddl debug:   {dbg_f}")
    else:
      print(f"  nl2pddl debug:   {last_run.get('translator_note', 'missing')}")
    if isinstance(tr, dict):
      print(
        f"  translator:      parallel={tr.get('parallel')}, elapsed_s={tr.get('elapsed_s')}, "
        f"returncode={tr.get('returncode')}, model_path={tr.get('model_path')}"
      )
      if tr.get("translation_http_rounds") is not None:
        print(
          f"                   HTTP rounds: total={tr['translation_http_rounds']}, "
          f"cache={tr['from_cache']}, api={tr['from_api']}"
        )
      elif tr.get("stdout_parse_note"):
        print(f"                   {tr['stdout_parse_note']}")
      summ = tr.get("openrouter_usage_summary")
      if isinstance(summ, dict):
        print(
          f"                   NL2PDDL usage: prompt={summ['prompt_tokens']}, "
          f"completion={summ['completion_tokens']}, total={summ['total_tokens']}"
        )
        c = summ.get("cost")
        if c is not None and float(c) > 0:
          print(f"                   NL2PDDL cost: {float(c):.6f}")
    elif last_run.get("translator_parse_error"):
      print(f"  translator:      (ошибка чтения debug) {last_run['translator_parse_error']}")

  print("\n" + "=" * 60)
  print("Этап: NL->PDDL (факт = openrouter_usage из ответа API, см. debug и pipeline_usage.nl2pddl)")
  print("=" * 60)
  print(f"  {nl2pddl['note']}")
  print(f"  Debug-файлов всего:     {nl2pddl['debug_files_total']}")
  print(f"  С полем openrouter_usage (факт по API): {nl2pddl['debug_files_with_openrouter_usage']}")
  print(f"  Сумма «rounds» (всего):  {nl2pddl['sum_translation_rounds']}")
  print(f"  Сумма из кэша:          {nl2pddl['sum_from_cache']}")
  print(f"  Сумма реальных API:     {nl2pddl['sum_from_api']}")
  print("  --- суммы токенов только там, где usage записан (остальное в отчёте = 0, не «ноль расхода») ---")
  print(f"  Сумма NL2PDDL prompt_tokens:     {nl2pddl['sum_openrouter_prompt_tokens']}")
  print(f"  Сумма NL2PDDL completion_tokens:   {nl2pddl['sum_openrouter_completion_tokens']}")
  print(f"  Сумма NL2PDDL total_tokens:      {nl2pddl['sum_openrouter_total_tokens']}")
  if nl2pddl["sum_openrouter_cost"] > 0:
    print(f"  Сумма NL2PDDL cost (OpenRouter): {nl2pddl['sum_openrouter_cost']:.6f}")
  print(f"  Debug без openrouter_usage (факт по ним из логов неизвестен): {nl2pddl.get('debug_files_without_openrouter_usage', 0)}")
  if int(nl2pddl.get("sum_api_rounds_without_usage_log") or 0) > 0:
    print(
      f"  API-раундов в debug без записанного usage: {nl2pddl['sum_api_rounds_without_usage_log']} "
      "(полный факт по ним — биллинг провайдера или перезапуск NL2PDDL с сохранением openrouter_usage)"
    )
  nip = nl2pddl_in_pipeline["totals"]
  print(
    f"  Сверка pipeline_usage.nl2pddl в run JSON: run-файлов с непустым блоком "
    f"{nl2pddl_in_pipeline['runs_with_nl2pddl_usage_in_pipeline']}, "
    f"сумма total_tokens {int(nip['total_tokens'])} "
    "(должна совпадать с суммой по debug при том же merge)"
  )

  print("\n" + "=" * 60)
  print("Этап: DOMAIN SETUP (domain_llm_usage_seed*.json в датасете)")
  print("=" * 60)
  print(f"  {domain_llm.get('note', '')}")
  print(f"  dataset_dir: {domain_llm.get('dataset_dir', '')}")
  print(f"  Уникальных файлов: {domain_llm['unique_files']}")
  dt = domain_llm["totals"]
  print(f"  Сумма prompt_tokens:     {int(dt['prompt_tokens'])}")
  print(f"  Сумма completion_tokens: {int(dt['completion_tokens'])}")
  print(f"  Сумма total_tokens:      {int(dt['total_tokens'])}")
  if float(dt.get("cost") or 0) > 0:
    print(f"  Сумма cost:              {float(dt['cost']):.6f}")

  print("\n" + "=" * 60)
  print("ИТОГО по артефактам (планирование + NL->PDDL с записанным usage + domain; неполный, если NL2PDDL без логов)")
  print("=" * 60)
  g_pt = int(t["prompt_tokens"]) + int(nl2pddl["sum_openrouter_prompt_tokens"]) + int(dt["prompt_tokens"])
  g_ct = int(t["completion_tokens"]) + int(nl2pddl["sum_openrouter_completion_tokens"]) + int(dt["completion_tokens"])
  g_tt = int(t["total_tokens"]) + int(nl2pddl["sum_openrouter_total_tokens"]) + int(dt["total_tokens"])
  g_cost = float(t["cost"]) + float(nl2pddl["sum_openrouter_cost"]) + float(dt.get("cost") or 0)
  print(f"  prompt_tokens:     {g_pt}")
  print(f"  completion_tokens: {g_ct}")
  print(f"  total_tokens:      {g_tt}")
  if g_cost > 0:
    print(f"  cost (сумма где известна): {g_cost:.6f}")
  if int(nl2pddl.get("debug_files_without_openrouter_usage") or 0) > 0:
    print("  Внимание: часть прогонов NL2PDDL без openrouter_usage — итог не равен полному фактическому расходу батча.")

  print("\n" + "=" * 60)
  print("Справка: что уже в отчёте и что может отсутствовать")
  print("=" * 60)
  print("  УЖЕ учтено выше (если в артефактах есть данные):")
  print("    • Планирование — сумма по openrouter_response.usage (блок «ПЛАНИРОВАНИЕ»).")
  print("    • NL->PDDL — токены из openrouter_usage в *__nl2pddl_debug.json (блок «NL->PDDL»).")
  print("    • Сводка по этапам в одном run — pipeline_usage.totals (блок «pipeline_usage в run JSON»).")
  print("  Может НЕ попасть в суммы или попасть неполно:")
  print("    • Run без записанного pipeline_usage — в «Сводка pipeline_usage» не входят (см. число файлов).")
  print("    • NL->PDDL: debug без поля openrouter_usage (старый autoplanbench) — только rounds, токены=0.")
  print("    • Domain setup: отдельный блок по data/**/domain_llm_usage_seed*.json; в pipeline_usage.totals — только после merge в run.")
  print("    • Промпт сэмпла (pddl2nl для одного run): LLM на этом шаге не вызывается (шаблоны).")

  if args.json_out:
    payload = {
      "output_dir": str(out),
      "dataset_dir": str(dataset_dir),
      "planning": agg,
      "planning_per_file": rows,
      "pipeline_usage_in_runs": pipeline_usage_runs,
      "nl2pddl_http_rounds": nl2pddl,
      "nl2pddl_from_pipeline_usage_in_runs": nl2pddl_in_pipeline,
      "domain_llm_usage": domain_llm,
      "grand_totals": {
        "prompt_tokens": g_pt,
        "completion_tokens": g_ct,
        "total_tokens": g_tt,
        "cost": g_cost,
        "note": (
          "факт только из записанных usage: planning + NL2PDDL (где есть openrouter_usage) + domain_llm; "
          "при дырах в NL2PDDL полный расход — из биллинга OpenRouter"
        ),
      },
      "last_run": last_run,
    }
    args.json_out.parent.mkdir(parents=True, exist_ok=True)
    args.json_out.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"\nJSON сохранён: {args.json_out.resolve()}")


if __name__ == "__main__":
  main()

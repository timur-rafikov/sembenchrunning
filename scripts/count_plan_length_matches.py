#!/usr/bin/env python3
"""
Считает, в скольких run JSON предсказанный план имеет ту же длину (число шагов),
что и эталонный план в датасете.

Длина — как в sembenchrunning metrics: metrics.plan_utils.pddl_plan_to_steps (только
строки, похожие на PDDL-действия).

Пример:
  python scripts/count_plan_length_matches.py \\
    --output-dir runs/finalset_full_1 --dataset-dir data/finalset
"""

from __future__ import annotations

import argparse
import json
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any, Dict

_ROOT = Path(__file__).resolve().parents[1]
if str(_ROOT) not in sys.path:
    sys.path.insert(0, str(_ROOT))

from metrics.plan_utils import pddl_plan_to_steps
from run_benchmark import (
    _get_nl_plan_from_run,
    _get_pddl_from_sample,
    _load_sample_pddl,
    _parse_example_id_parts,
)
from translators.pddl2pddl import response_as_plan_pddl


def _pred_plan_text(data: Dict[str, Any], allow_reasoning_fallback: bool) -> str:
    cached = data.get("plan_pred_pddl")
    if isinstance(cached, str) and cached.strip():
        return cached
    raw = _get_nl_plan_from_run(data, allow_reasoning_fallback=allow_reasoning_fallback)
    if not raw:
        return ""
    return response_as_plan_pddl(raw)


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Сколько раз предсказанный план по числу шагов равен эталонному (как в метриках)."
        )
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path("runs/finalset_full_1"),
        help="Каталог с run *.json.",
    )
    parser.add_argument(
        "--dataset-dir",
        type=Path,
        required=True,
        help="Корень датасета (section/subsection/.../sample.json).",
    )
    parser.add_argument(
        "--allow-reasoning-fallback",
        action="store_true",
        help="Брать текст из message.reasoning, если content пустой.",
    )
    parser.add_argument(
        "--list-matches",
        action="store_true",
        help="Печатать id сэмплов с совпадением длины.",
    )
    args = parser.parse_args()
    out = args.output_dir.resolve()
    ds = args.dataset_dir.resolve()
    if not ds.is_dir():
        raise SystemExit(f"dataset-dir not a directory: {ds}")
    if not out.is_dir():
        raise SystemExit(f"output-dir not a directory: {out}")

    run_files = sorted(
        f
        for f in out.rglob("*__*.json")
        if f.is_file() and not f.name.endswith("__nl2pddl_debug.json")
    )

    matched = 0
    compared = 0
    skipped: Dict[str, int] = defaultdict(int)
    match_ids: list[str] = []

    for path in run_files:
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except Exception:
            skipped["unreadable_json"] += 1
            continue
        if "error" in data:
            skipped["error_in_run"] += 1
            continue
        eid = data.get("id")
        if not eid:
            skipped["no_example_id"] += 1
            continue
        eid = str(eid)
        parsed = _parse_example_id_parts(eid)
        if not parsed:
            skipped["bad_id"] += 1
            continue
        section, subsection, sample_index = parsed
        sample = _load_sample_pddl(ds, section, subsection, sample_index, example_id=eid)
        if sample is None:
            skipped["no_sample"] += 1
            continue
        _, _, ref_pddl = _get_pddl_from_sample(sample)
        if not ref_pddl or not str(ref_pddl).strip():
            skipped["no_ref_plan"] += 1
            continue
        ref_n = len(pddl_plan_to_steps(ref_pddl))
        pred_raw = _pred_plan_text(data, args.allow_reasoning_fallback)
        if not pred_raw.strip():
            skipped["empty_pred"] += 1
            continue
        pred_n = len(pddl_plan_to_steps(pred_raw))
        compared += 1
        if pred_n == ref_n:
            matched += 1
            if args.list_matches:
                match_ids.append(eid)

    print(f"output_dir: {out}")
    print(f"dataset_dir: {ds}")
    print(f"run_files: {len(run_files)}")
    print(f"compared (ref plan + non-empty pred steps): {compared}")
    print(f"same_length_as_reference: {matched}")
    if compared:
        print(f"fraction: {matched / compared:.6f}")
    if skipped:
        print("skipped:", dict(sorted(skipped.items())))
    if args.list_matches and match_ids:
        print("matching example ids:")
        for x in sorted(match_ids):
            print(x)


if __name__ == "__main__":
    main()

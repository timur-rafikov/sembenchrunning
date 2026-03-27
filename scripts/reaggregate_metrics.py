#!/usr/bin/env python3
"""
Пересчёт агрегатов (mean, std, доверительный интервал по t-распределению) из metrics.jsonl.

Не вызывает LLM и не запускает VAL: использует уже посчитанные построчные метрики.
Тот же формат вывода, что и у run_benchmark после фазы метрик (удобно сохранить в metricstext).

Пример:
  python scripts/reaggregate_metrics.py \\
    --metrics-jsonl results_grok_pddl2pddl/finalset_full_1/metrics.jsonl \\
    --confidence 0.99

  python scripts/reaggregate_metrics.py --output-dir results_grok_pddl2pddl/finalset_full_1 --confidence 0.99
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional

_ROOT = Path(__file__).resolve().parents[1]
if str(_ROOT) not in sys.path:
    sys.path.insert(0, str(_ROOT))

from metrics import RunRecord, aggregate_runs


def _load_records(
    metrics_path: Path,
    run_id: Optional[str],
) -> List[RunRecord]:
    records: List[RunRecord] = []
    text = metrics_path.read_text(encoding="utf-8")
    for line in text.splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            row: Dict[str, Any] = json.loads(line)
        except json.JSONDecodeError:
            continue
        if row.get("status") != "metrics_computed":
            continue
        if run_id is not None and row.get("run_id") != run_id:
            continue
        ex = row.get("example_id")
        if not ex:
            continue
        records.append(
            RunRecord(
                run_id=str(row.get("run_id") or "run_1"),
                example_id=str(ex),
                model=str(row.get("model") or "unknown"),
                domain_conformance=float(bool(row.get("domain_conformance"))),
                executability=float(bool(row.get("executability"))),
                reachability=float(bool(row.get("reachability"))),
                optimality_ratio=float(row.get("optimality_ratio", -1.0)),
                first_val_failure_step=int(row.get("first_val_failure_step", -1)),
                first_ref_deviation_step=int(row.get("first_ref_deviation_step", -1)),
                section=row.get("section"),
                subsection=row.get("subsection"),
                status="metrics_computed",
            )
        )
    return records


def _print_coverage(metrics_rows: List[Dict[str, Any]]) -> None:
    coverage_by_model: Dict[str, Dict[str, int]] = {}
    for row in metrics_rows:
        model = str(row.get("model") or "unknown")
        bucket = coverage_by_model.setdefault(
            model, {"total": 0, "computed": 0, "pipeline_failed": 0}
        )
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


def _print_aggregates(computed_records: List[RunRecord], confidence: float) -> None:
    if not computed_records:
        print("[sembenchrunning] No metrics_computed rows to aggregate.", flush=True)
        return

    by_model = aggregate_runs(computed_records, group_by="model", confidence=confidence)
    print("[sembenchrunning] Aggregate by model:", flush=True)
    for model, stats in by_model.items():
        print(f"  {model}:", flush=True)
        for metric, agg in stats.items():
            ci = f" [{agg.ci_low:.3f}, {agg.ci_high:.3f}]" if agg.ci_low is not None else ""
            print(
                f"    {metric}: mean={agg.mean:.4f} std={agg.std:.4f} n={agg.count}{ci}",
                flush=True,
            )

    if any(r.section for r in computed_records):
        by_section = aggregate_runs(computed_records, group_by="section", confidence=confidence)
        print("[sembenchrunning] Aggregate by section:", flush=True)
        for section, stats in by_section.items():
            if not section:
                continue
            print(f"  {section}:", flush=True)
            for metric, agg in stats.items():
                ci = f" [{agg.ci_low:.3f}, {agg.ci_high:.3f}]" if agg.ci_low is not None else ""
                print(
                    f"    {metric}: mean={agg.mean:.4f} std={agg.std:.4f} n={agg.count}{ci}",
                    flush=True,
                )

    if any(r.subsection for r in computed_records):
        by_subsection = aggregate_runs(
            computed_records, group_by="subsection", confidence=confidence
        )
        print("[sembenchrunning] Aggregate by subsection:", flush=True)
        for subsection, stats in by_subsection.items():
            if not subsection:
                continue
            print(f"  {subsection}:", flush=True)
            for metric, agg in stats.items():
                ci = f" [{agg.ci_low:.3f}, {agg.ci_high:.3f}]" if agg.ci_low is not None else ""
                print(
                    f"    {metric}: mean={agg.mean:.4f} std={agg.std:.4f} n={agg.count}{ci}",
                    flush=True,
                )


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument(
        "--metrics-jsonl",
        type=Path,
        default=None,
        help="Путь к metrics.jsonl (если не задан — берётся <output-dir>/metrics.jsonl).",
    )
    p.add_argument(
        "--output-dir",
        type=Path,
        default=None,
        help="Каталог с metrics.jsonl (используется, если не указан --metrics-jsonl).",
    )
    p.add_argument(
        "--run-id",
        type=str,
        default=None,
        help="Оставить только строки с этим run_id (если не задано — все metrics_computed).",
    )
    p.add_argument(
        "--confidence",
        type=float,
        default=0.95,
        help="Уровень доверия для t-интервала (как в aggregate_runs), по умолчанию 0.95.",
    )
    p.add_argument(
        "--coverage",
        action="store_true",
        help="Также напечатать блок Coverage by model (по всем строкам файла, не только по фильтру run-id).",
    )
    args = p.parse_args()

    if args.metrics_jsonl is not None:
        mpath = args.metrics_jsonl
    elif args.output_dir is not None:
        mpath = args.output_dir / "metrics.jsonl"
    else:
        p.error("Нужен --metrics-jsonl или --output-dir")

    if not mpath.is_file():
        raise SystemExit(f"Файл не найден: {mpath}")

    if not (0.0 < args.confidence < 1.0):
        raise SystemExit("--confidence должен быть строго между 0 и 1")

    if args.coverage:
        rows: List[Dict[str, Any]] = []
        for line in mpath.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line:
                continue
            try:
                row = json.loads(line)
            except json.JSONDecodeError:
                continue
            if args.run_id is not None and row.get("run_id") != args.run_id:
                continue
            rows.append(row)
        _print_coverage(rows)

    records = _load_records(mpath, run_id=args.run_id)
    if args.run_id:
        print(
            f"[sembenchrunning] Loaded {len(records)} metrics_computed rows "
            f"(run_id={args.run_id!r}), confidence={args.confidence}",
            flush=True,
        )
    else:
        print(
            f"[sembenchrunning] Loaded {len(records)} metrics_computed rows (all run_id), "
            f"confidence={args.confidence}",
            flush=True,
        )

    _print_aggregates(records, confidence=args.confidence)


if __name__ == "__main__":
    main()

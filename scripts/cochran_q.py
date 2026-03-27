#!/usr/bin/env python3
"""Compute Cochran's Q test from one or more metrics.jsonl files."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence

_ROOT = Path(__file__).resolve().parents[1]
if str(_ROOT) not in sys.path:
    sys.path.insert(0, str(_ROOT))

from dataset_contracts import extract_sample_coords, iter_dataset_samples, normalize_dataset_dir
from metrics import (
    RunRecord,
    cochran_q_test,
    cochran_q_test_by_section,
    cochran_q_test_by_subsection,
)

_BINARY_METRICS = ("domain_conformance", "executability", "reachability")


def _iter_metrics_paths(inputs: Sequence[Path]) -> List[Path]:
    paths: List[Path] = []
    for item in inputs:
        if item.is_file():
            paths.append(item)
            continue
        candidate = item / "metrics.jsonl"
        if candidate.is_file():
            paths.append(candidate)
            continue
        raise SystemExit(f"metrics.jsonl not found: {item}")
    return paths


def _load_records(
    paths: Sequence[Path],
    run_id: Optional[str],
    filter_models: Optional[Sequence[str]],
) -> List[RunRecord]:
    records: List[RunRecord] = []
    allowed_models = set(filter_models or [])
    use_source_tag = len(paths) > 1 and run_id is None
    for source_index, path in enumerate(paths, start=1):
        text = path.read_text(encoding="utf-8")
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
            example_id = row.get("example_id")
            model = row.get("model")
            if not example_id or not model:
                continue
            if allowed_models and str(model) not in allowed_models:
                continue
            original_run_id = str(row.get("run_id") or "run_1")
            effective_run_id = (
                f"{original_run_id}#src{source_index}" if use_source_tag else original_run_id
            )
            records.append(
                RunRecord(
                    run_id=effective_run_id,
                    example_id=str(example_id),
                    model=str(model),
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


def _build_example_order(dataset_dir: Path, order_by: str) -> Dict[str, int]:
    normalized = normalize_dataset_dir(dataset_dir.resolve())
    example_order: Dict[str, int] = {}
    counts_by_group: Dict[str, int] = {}
    for sample_path in iter_dataset_samples(normalized):
        try:
            sample = json.loads(sample_path.read_text(encoding="utf-8"))
        except Exception:
            continue
        example_id = str(sample.get("id") or "").strip()
        if not example_id:
            continue
        section, subsection, _ = extract_sample_coords(sample, example_id)
        if order_by == "section":
            group_key = section
        elif order_by == "subsection":
            group_key = subsection
        else:
            raise SystemExit(f"Unsupported order grouping: {order_by}")
        if not group_key:
            continue
        counts_by_group[group_key] = counts_by_group.get(group_key, 0) + 1
        example_order[example_id] = counts_by_group[group_key]
    return example_order


def _print_result(result_name: str, labels_name: str, labels: Sequence[str], result: Any) -> None:
    print(f"[sembenchrunning] {result_name} for {result.metric}:", flush=True)
    print(f"  {labels_name}: {', '.join(labels)}", flush=True)
    print(
        f"  Q={result.statistic:.6f} df={result.degrees_of_freedom} "
        f"p={result.p_value:.6g} significant={result.significant}",
        flush=True,
    )
    print(
        f"  usable_blocks={result.usable_blocks} "
        f"dropped_incomplete_blocks={result.dropped_incomplete_blocks}",
        flush=True,
    )
    print(f"  test_used={result.test_used}", flush=True)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "inputs",
        nargs="+",
        type=Path,
        help="Paths to metrics.jsonl files or directories that contain metrics.jsonl.",
    )
    parser.add_argument(
        "--group-by",
        choices=("model", "section", "subsection"),
        default="model",
        help="Compare models on matched examples, sections on matched ordinal positions, or subsections on matched ordinal positions.",
    )
    parser.add_argument(
        "--metric",
        choices=_BINARY_METRICS,
        default="reachability",
        help="Binary metric for Cochran's Q.",
    )
    parser.add_argument(
        "--all-binary",
        action="store_true",
        help="Run the test for all binary metrics: domain_conformance, executability, reachability.",
    )
    parser.add_argument(
        "--model",
        dest="models",
        action="append",
        default=None,
        help="When --group-by model: compare these models. When --group-by section: only keep these models in data.",
    )
    parser.add_argument(
        "--section",
        dest="sections",
        action="append",
        default=None,
        help="When --group-by section: compare these sections.",
    )
    parser.add_argument(
        "--dataset-dir",
        type=Path,
        default=None,
        help="Dataset root; required for --group-by section/subsection to recover ordinal positions.",
    )
    parser.add_argument(
        "--subsection",
        dest="subsections",
        action="append",
        default=None,
        help="When --group-by subsection: compare these subsections.",
    )
    parser.add_argument(
        "--run-id",
        type=str,
        default=None,
        help="Use only rows with this run_id.",
    )
    parser.add_argument(
        "--alpha",
        type=float,
        default=0.05,
        help="Significance level, default 0.05.",
    )
    args = parser.parse_args()

    if not (0.0 < args.alpha < 1.0):
        raise SystemExit("--alpha must be strictly between 0 and 1.")

    metrics_paths = _iter_metrics_paths(args.inputs)
    filter_models = args.models if args.group_by == "section" else None
    records = _load_records(metrics_paths, run_id=args.run_id, filter_models=filter_models)
    if not records:
        raise SystemExit("No metrics_computed rows found in the provided inputs.")

    loaded_models = sorted({r.model for r in records})
    loaded_sections = sorted({str(r.section or "") for r in records if r.section})
    print(
        f"[sembenchrunning] Loaded {len(records)} metrics_computed rows from "
        f"{len(metrics_paths)} file(s); models={loaded_models}; sections={loaded_sections}",
        flush=True,
    )
    if len(metrics_paths) > 1 and args.run_id is None:
        print(
            "[sembenchrunning] Multiple input files detected; source-specific tags were "
            "appended to run_id to keep repeated runs separate.",
            flush=True,
        )

    metrics = list(_BINARY_METRICS) if args.all_binary else [args.metric]
    for index, metric in enumerate(metrics):
        if index:
            print("", flush=True)
        if args.group_by == "model":
            result = cochran_q_test(records, models=args.models, metric=metric, alpha=args.alpha)
            _print_result("Cochran's Q by model", "models", result.models, result)
            continue

        if args.dataset_dir is None:
            raise SystemExit("--dataset-dir is required for --group-by section/subsection.")
        if args.group_by == "section":
            example_order = _build_example_order(args.dataset_dir, order_by="section")
            result = cochran_q_test_by_section(
                records,
                example_order=example_order,
                sections=args.sections,
                metric=metric,
                alpha=args.alpha,
            )
            _print_result("Cochran's Q by section", "sections", result.models, result)
            continue

        example_order = _build_example_order(args.dataset_dir, order_by="subsection")
        result = cochran_q_test_by_subsection(
            records,
            example_order=example_order,
            subsections=args.subsections,
            metric=metric,
            alpha=args.alpha,
        )
        _print_result("Cochran's Q by subsection", "subsections", result.models, result)


if __name__ == "__main__":
    main()

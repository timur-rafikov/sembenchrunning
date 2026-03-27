#!/usr/bin/env python3
"""
Усредняет метрики из нескольких текстовых отчётов sembenchrunning (как в metricstext/run1 … runK).

Формат входных файлов — вывод Coverage / Aggregate by model|section|subsection со строками вида:
  executability: mean=… std=… n=… [low, high]

Для каждой тройки (блок, сущность, метрика) усредняются mean, std, нижняя и верхняя границы CI;
n усредняется и округляется (если прогоны с разным числом записей).

Пример:
  python scripts/aggregate_metricstext_runs.py \\
    --input-dir results_grok_pddl2pddl/metricstext --output results_grok_pddl2pddl/metricstext/run_avg.txt
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any, DefaultDict, Dict, List, Optional, Tuple

_ROOT = Path(__file__).resolve().parents[1]
if str(_ROOT) not in sys.path:
    sys.path.insert(0, str(_ROOT))

# 4 пробела перед метрикой (как в логе run_benchmark).
_METRIC_RE = re.compile(
    r"^    (domain_conformance|executability|reachability|optimality_ratio):\s+"
    r"mean=([\d.]+)\s+std=([\d.]+)\s+n=(\d+)\s+\[([\d.]+),\s*([\d.]+)\]\s*$"
)
_COVERAGE_RE = re.compile(
    r"^  (.+):\s+total=(\d+)\s+computed=(\d+)\s+pipeline_failed=(\d+)\s*$"
)
# Строка сущности: ровно два пробела, имя, двоеточие, конец (без mean=).
_ENTITY_RE = re.compile(r"^  ([^:]+):\s*$")


def _parse_float(x: str) -> float:
    return float(x)


def parse_metricstext(text: str) -> Tuple[Dict[str, Dict[str, Dict[str, Tuple[float, float, int, float, float]]]], Dict[str, Tuple[int, int, int]]]:
    """
    Returns:
      metrics[block][entity][metric] -> (mean, std, n, ci_lo, ci_hi)
      coverage[model] -> (total, computed, pipeline_failed)
    """
    metrics: Dict[str, Dict[str, Dict[str, Tuple[float, float, int, float, float]]]] = {}
    coverage: Dict[str, Tuple[int, int, int]] = {}

    block: Optional[str] = None
    entity: Optional[str] = None

    for line in text.splitlines():
        if line.startswith("[sembenchrunning]"):
            if "Coverage by model" in line:
                block = "coverage"
            elif "Aggregate by model" in line:
                block = "model"
            elif "Aggregate by section" in line:
                block = "section"
            elif "Aggregate by subsection" in line:
                block = "subsection"
            else:
                block = None
            entity = None
            continue

        if not line.strip():
            continue
        stripped = line.strip()
        if stripped.startswith("Note:"):
            continue

        cm = _COVERAGE_RE.match(line)
        if cm and block == "coverage":
            model = cm.group(1).strip()
            coverage[model] = (int(cm.group(2)), int(cm.group(3)), int(cm.group(4)))
            continue

        em = _ENTITY_RE.match(line)
        if em and block in ("model", "section", "subsection"):
            entity = em.group(1).strip()
            if block not in metrics:
                metrics[block] = {}
            if entity not in metrics[block]:
                metrics[block][entity] = {}
            continue

        mm = _METRIC_RE.match(line)
        if mm and block in ("model", "section", "subsection") and entity:
            mname = mm.group(1)
            metrics[block][entity][mname] = (
                _parse_float(mm.group(2)),
                _parse_float(mm.group(3)),
                int(mm.group(4)),
                _parse_float(mm.group(5)),
                _parse_float(mm.group(6)),
            )

    return metrics, coverage


def _avg(xs: List[float]) -> float:
    return sum(xs) / len(xs) if xs else 0.0


def aggregate_metrics(
    parsed_list: List[Dict[str, Dict[str, Dict[str, Tuple[float, float, int, float, float]]]]],
) -> Dict[str, Dict[str, Dict[str, Tuple[float, float, int, float, float]]]]:
    """Усреднение по одинаковым ключам; прогон без ключа пропускается для этой ячейки."""
    # Collect all (block, entity, metric) keys
    keys: List[Tuple[str, str, str]] = []
    for p in parsed_list:
        for b, entities in p.items():
            for e, mdict in entities.items():
                for m in mdict:
                    keys.append((b, e, m))
    uniq = sorted(set(keys))

    out: Dict[str, Dict[str, Dict[str, Tuple[float, float, int, float, float]]]] = defaultdict(
        lambda: defaultdict(dict)
    )
    for b, e, m in uniq:
        means, stds, ns, los, his = [], [], [], [], []
        for p in parsed_list:
            try:
                t = p[b][e][m]
            except KeyError:
                continue
            means.append(t[0])
            stds.append(t[1])
            ns.append(t[2])
            los.append(t[3])
            his.append(t[4])
        if not means:
            continue
        out[b][e][m] = (
            _avg(means),
            _avg(stds),
            int(round(_avg([float(x) for x in ns]))),
            _avg(los),
            _avg(his),
        )
    return {k: dict(v) for k, v in out.items()}


def aggregate_coverage(
    coverage_list: List[Dict[str, Tuple[int, int, int]]],
) -> Dict[str, Tuple[int, int, int]]:
    if not coverage_list:
        return {}
    models = set()
    for c in coverage_list:
        models.update(c.keys())
    out: Dict[str, Tuple[int, int, int]] = {}
    for model in sorted(models):
        totals, comps, fails = [], [], []
        for c in coverage_list:
            if model not in c:
                continue
            t, co, f = c[model]
            totals.append(t)
            comps.append(co)
            fails.append(f)
        if not totals:
            continue
        out[model] = (
            int(round(_avg([float(x) for x in totals]))),
            int(round(_avg([float(x) for x in comps]))),
            int(round(_avg([float(x) for x in fails]))),
        )
    return out


def _fmt_metric(
    name: str,
    mean: float,
    std: float,
    n: int,
    lo: float,
    hi: float,
) -> str:
    return (
        f"    {name}: mean={mean:.4f} std={std:.4f} n={n} "
        f"[{lo:.3f}, {hi:.3f}]"
    )


def render(
    cov: Dict[str, Tuple[int, int, int]],
    agg: Dict[str, Dict[str, Dict[str, Tuple[float, float, int, float, float]]]],
    *,
    n_sources: int,
) -> str:
    lines: List[str] = []
    lines.append(
        f"[sembenchrunning] Aggregated metricstext over {n_sources} run file(s) "
        "(mean/std/CI bounds averaged per cell; n rounded mean)."
    )
    lines.append("[sembenchrunning] Coverage by model:")
    for model in sorted(cov.keys()):
        t, c, f = cov[model]
        lines.append(f"  {model}: total={t} computed={c} pipeline_failed={f}")

    order_blocks = [("model", "Aggregate by model:"), ("section", "Aggregate by section:"), ("subsection", "Aggregate by subsection:")]
    metric_order = ("domain_conformance", "executability", "reachability", "optimality_ratio")

    for block_key, header in order_blocks:
        if block_key not in agg or not agg[block_key]:
            continue
        lines.append(f"[sembenchrunning] {header}")
        for entity in sorted(agg[block_key].keys()):
            lines.append(f"  {entity}:")
            mdict = agg[block_key][entity]
            for mname in metric_order:
                if mname not in mdict:
                    continue
                mean, std, n, lo, hi = mdict[mname]
                lines.append(_fmt_metric(mname, mean, std, n, lo, hi))
    return "\n".join(lines) + "\n"


def main() -> None:
    ap = argparse.ArgumentParser(description="Усреднить metricstext run1…runK в один отчёт.")
    ap.add_argument(
        "--input-dir",
        type=Path,
        default=_ROOT / "results_grok_pddl2pddl" / "metricstext",
        help="Каталог с файлами run1, run2, …",
    )
    ap.add_argument(
        "--runs",
        type=int,
        nargs="*",
        default=[1, 2, 3, 4, 5],
        help="Номера файлов runK (без расширения), по умолчанию 1 2 3 4 5.",
    )
    ap.add_argument(
        "--output",
        "-o",
        type=Path,
        default=None,
        help="Куда записать результат (по умолчанию: <input-dir>/run_avg.txt).",
    )
    args = ap.parse_args()
    in_dir: Path = args.input_dir.resolve()
    if not in_dir.is_dir():
        raise SystemExit(f"input-dir is not a directory: {in_dir}")

    paths: List[Path] = []
    for k in args.runs:
        for name in (f"run{k}", f"run{k}.txt"):
            p = in_dir / name
            if p.is_file():
                paths.append(p)
                break
        else:
            raise SystemExit(f"Missing run{k} or run{k}.txt under {in_dir}")

    parsed_metrics: List[Any] = []
    parsed_cov: List[Any] = []
    for p in paths:
        text = p.read_text(encoding="utf-8")
        m, c = parse_metricstext(text)
        parsed_metrics.append(m)
        parsed_cov.append(c)

    agg_m = aggregate_metrics(parsed_metrics)
    agg_c = aggregate_coverage(parsed_cov)
    out_text = render(agg_c, agg_m, n_sources=len(paths))

    out_path = args.output
    if out_path is None:
        out_path = in_dir / "run_avg.txt"
    else:
        out_path = out_path.resolve()
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(out_text, encoding="utf-8")
    print(f"Wrote {out_path} ({len(paths)} sources)")


if __name__ == "__main__":
    main()

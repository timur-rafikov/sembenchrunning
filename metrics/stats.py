"""Aggregate primary benchmark metrics over multiple runs and compute statistical significance."""

from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Union

import numpy as np
from scipy import stats as scipy_stats


@dataclass
class RunRecord:
    """Single run: one model on one example, with primary metrics and optional diagnostics."""

    run_id: str
    example_id: str
    model: str
    executability: float
    reachability: float
    optimality_ratio: float
    first_error_step: int
    first_val_failure_step: int = -1
    first_ref_deviation_step: int = -1
    section: Optional[str] = None   # e.g. "blocks_world", "logistics"
    subsection: Optional[str] = None  # e.g. "clean", "problem_01"


@dataclass
class AggregateStats:
    """Aggregated statistics for a metric (over runs and/or examples)."""

    mean: float
    std: float
    count: int
    ci_low: Optional[float] = None  # 95% CI
    ci_high: Optional[float] = None


def _group_key(r: RunRecord, group_by: str) -> str | tuple:
    if group_by == "model":
        return r.model
    if group_by == "example":
        return r.example_id
    if group_by == "section":
        return r.section or ""
    if group_by == "subsection":
        return r.subsection or ""
    if group_by == "section_subsection":
        return (r.section or "", r.subsection or "")
    return getattr(r, group_by, "")


def aggregate_runs(
    records: List[RunRecord],
    group_by: str = "model",
    confidence: float = 0.95,
) -> Dict[Union[str, tuple], Dict[str, AggregateStats]]:
    """
    Aggregate primary metrics over runs.

    Args:
        records: List of RunRecord.
        group_by: 'model' | 'example' | 'section' | 'subsection' | 'section_subsection'.
                  For section/subsection, RunRecord must have section/subsection set.
        confidence: Confidence level for CI (e.g. 0.95).

    Returns:
        Dict[group_key, Dict[metric_name, AggregateStats]]. Keys are str or (section, subsection).
    """
    if not records:
        return {}

    metric_names = ["executability", "reachability", "optimality_ratio"]
    out: Dict[Union[str, tuple], Dict[str, AggregateStats]] = {}
    groups: Dict[Union[str, tuple], List[RunRecord]] = {}
    for r in records:
        k = _group_key(r, group_by)
        groups.setdefault(k, []).append(r)

    for k, group in groups.items():
        out[k] = {}
        for name in metric_names:
            values = [getattr(r, name) for r in group]
            arr = np.array(values, dtype=float)
            # For optimality_ratio, exclude invalid sentinel -1 from mean so section mean is not skewed
            if name == "optimality_ratio":
                valid = arr[arr >= 0]
                if len(valid) == 0:
                    mean, std, n = float("nan"), 0.0, 0
                else:
                    mean = float(np.mean(valid))
                    std = float(np.std(valid, ddof=1)) if len(valid) > 1 else 0.0
                    n = len(valid)
            else:
                mean = float(np.mean(arr))
                std = float(np.std(arr, ddof=1)) if len(arr) > 1 else 0.0
                n = len(arr)
            ci_low = ci_high = None
            if n >= 2:
                se = std / np.sqrt(n)
                t = scipy_stats.t.ppf((1 + confidence) / 2, n - 1)
                ci_low = mean - t * se
                ci_high = mean + t * se
            out[k][name] = AggregateStats(
                mean=mean, std=std, count=n, ci_low=ci_low, ci_high=ci_high
            )
    return out


@dataclass
class ComparisonResult:
    """Result of comparing two groups on a metric."""

    metric: str
    mean_diff: float  # group_b - group_a
    mean_a: float
    mean_b: float
    p_value: float
    significant: bool
    test_used: str


def compare_models(
    records: List[RunRecord],
    model_a: str,
    model_b: str,
    alpha: float = 0.05,
    use_wilcoxon: bool = True,
) -> List[ComparisonResult]:
    """
    Compare two models with paired statistical tests. Pairs are (example_id, run_id):
    for each (example_id, run_id) we need one record for model_a and one for model_b.
    If multiple runs per (example, model), we pair by (example_id, run_id).

    Args:
        records: All RunRecords (must include both model_a and model_b).
        model_a: First model name.
        model_b: Second model name.
        alpha: Significance level.
        use_wilcoxon: If True, use Wilcoxon signed-rank (non-parametric); else paired t-test.

    Returns:
        List of ComparisonResult per metric.
    """
    by_pair: Dict[tuple, Dict[str, RunRecord]] = {}
    for r in records:
        if r.model not in (model_a, model_b):
            continue
        key = (r.example_id, r.run_id)
        by_pair.setdefault(key, {})[r.model] = r

    # Only keep pairs that have both models
    pairs: List[tuple] = [k for k, v in by_pair.items() if model_a in v and model_b in v]
    if not pairs:
        return []

    metric_names = ["executability", "reachability", "optimality_ratio"]
    results: List[ComparisonResult] = []

    for name in metric_names:
        vals_a = [by_pair[p][model_a] for p in pairs]
        vals_b = [by_pair[p][model_b] for p in pairs]
        arr_a = np.array([getattr(r, name) for r in vals_a], dtype=float)
        arr_b = np.array([getattr(r, name) for r in vals_b], dtype=float)
        if name == "optimality_ratio":
            valid_mask = (arr_a >= 0) & (arr_b >= 0)
            arr_a = arr_a[valid_mask]
            arr_b = arr_b[valid_mask]
        if len(arr_a) == 0 or len(arr_b) == 0:
            continue
        mean_a = float(np.mean(arr_a))
        mean_b = float(np.mean(arr_b))
        mean_diff = mean_b - mean_a

        if use_wilcoxon:
            try:
                stat, p_val = scipy_stats.wilcoxon(arr_a, arr_b, alternative="two-sided")
            except Exception:
                p_val = 1.0
            test_used = "wilcoxon"
        else:
            try:
                stat, p_val = scipy_stats.ttest_rel(arr_a, arr_b)
            except Exception:
                p_val = 1.0
            test_used = "paired_ttest"

        results.append(
            ComparisonResult(
                metric=name,
                mean_diff=mean_diff,
                mean_a=mean_a,
                mean_b=mean_b,
                p_value=float(p_val),
                significant=p_val < alpha,
                test_used=test_used,
            )
        )
    return results


def compare_groups(
    records: List[RunRecord],
    group_by: str,
    group_a: Union[str, tuple],
    group_b: Union[str, tuple],
    alpha: float = 0.05,
    use_mannwhitney: bool = True,
) -> List[ComparisonResult]:
    """
    Compare two groups (e.g. two sections or two subsections) with two-sample tests.
    Use when groups contain different examples (unpaired). For same-example comparison
    (e.g. two models on same set), use compare_models.

    Args:
        records: All RunRecords; must have section/subsection set if group_by uses them.
        group_by: 'section' | 'subsection' | 'section_subsection' | 'model' | 'example'.
        group_a: Key of first group (e.g. section name or (section, subsection)).
        group_b: Key of second group.
        alpha: Significance level.
        use_mannwhitney: If True, use Mann-Whitney U (non-parametric); else Welch t-test.

    Returns:
        List of ComparisonResult per metric.
    """
    list_a = [r for r in records if _group_key(r, group_by) == group_a]
    list_b = [r for r in records if _group_key(r, group_by) == group_b]
    if not list_a or not list_b:
        return []

    metric_names = ["executability", "reachability", "optimality_ratio"]
    results: List[ComparisonResult] = []

    for name in metric_names:
        arr_a = np.array([getattr(r, name) for r in list_a], dtype=float)
        arr_b = np.array([getattr(r, name) for r in list_b], dtype=float)
        if name == "optimality_ratio":
            arr_a = arr_a[arr_a >= 0]
            arr_b = arr_b[arr_b >= 0]
        if len(arr_a) == 0 or len(arr_b) == 0:
            continue
        mean_a = float(np.mean(arr_a))
        mean_b = float(np.mean(arr_b))
        mean_diff = mean_b - mean_a

        if use_mannwhitney:
            try:
                stat, p_val = scipy_stats.mannwhitneyu(arr_a, arr_b, alternative="two-sided")
            except Exception:
                p_val = 1.0
            test_used = "mannwhitneyu"
        else:
            try:
                stat, p_val = scipy_stats.ttest_ind(arr_a, arr_b, equal_var=False)
            except Exception:
                p_val = 1.0
            test_used = "welch_ttest"

        results.append(
            ComparisonResult(
                metric=name,
                mean_diff=mean_diff,
                mean_a=mean_a,
                mean_b=mean_b,
                p_value=float(p_val),
                significant=p_val < alpha,
                test_used=test_used,
            )
        )
    return results

"""Aggregate primary benchmark metrics over multiple runs and compute statistical significance."""

import warnings
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Sequence, Union

import numpy as np
from scipy import stats as scipy_stats


@dataclass
class RunRecord:
    """Single run: one model on one example, with primary metrics and optional diagnostics."""

    run_id: str
    example_id: str
    model: str
    domain_conformance: float
    executability: float
    reachability: float
    optimality_ratio: float  # opt_len / pred_len when goal reached; -1.0 otherwise
    first_val_failure_step: int = -1
    first_ref_deviation_step: int = -1
    section: Optional[str] = None   # e.g. "blocks_world", "logistics"
    subsection: Optional[str] = None  # e.g. "clean", "problem_01"
    status: str = "metrics_computed"


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

    metric_names = [
        "domain_conformance",
        "executability",
        "reachability",
        "optimality_ratio",
        "first_val_failure_step",
    ]
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
            if name in ("optimality_ratio", "first_val_failure_step"):
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
                if name in ("domain_conformance", "executability", "reachability"):
                    ci_low = max(0.0, ci_low)
                    ci_high = min(1.0, ci_high)
                elif name == "optimality_ratio":
                    # Ratio is non-negative when defined; t-interval can dip below 0 on small n.
                    ci_low = max(0.0, ci_low)
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


@dataclass
class CochranQResult:
    """Result of Cochran's Q test for matched binary outcomes across 3+ models."""

    metric: str
    models: List[str]
    statistic: float
    p_value: float
    degrees_of_freedom: int
    significant: bool
    n_models: int
    usable_blocks: int
    dropped_incomplete_blocks: int
    test_used: str


def _cochran_q_from_blocks(
    blocks: List[Dict[str, RunRecord]],
    labels: Sequence[str],
    metric: str,
    alpha: float,
) -> CochranQResult:
    usable_blocks = len(blocks)
    if usable_blocks == 0:
        raise ValueError("No complete matched blocks found for Cochran's Q test.")

    matrix = np.array(
        [[float(getattr(block[label], metric)) for label in labels] for block in blocks],
        dtype=float,
    )
    if not np.all(np.isin(matrix, [0.0, 1.0])):
        raise ValueError(
            f"Metric {metric!r} must be binary (0/1) for Cochran's Q; got non-binary values."
        )

    row_sums = np.sum(matrix, axis=1)
    col_sums = np.sum(matrix, axis=0)
    k = len(labels)
    numerator = (k - 1) * (k * float(np.sum(col_sums ** 2)) - float(np.sum(col_sums) ** 2))
    denominator = k * float(np.sum(row_sums)) - float(np.sum(row_sums ** 2))

    if np.isclose(denominator, 0.0):
        statistic = 0.0
        p_value = 1.0
        test_used = "cochran_q_degenerate"
    else:
        statistic = numerator / denominator
        p_value = float(scipy_stats.chi2.sf(statistic, df=k - 1))
        test_used = "cochran_q"

    return CochranQResult(
        metric=metric,
        models=list(labels),
        statistic=float(statistic),
        p_value=p_value,
        degrees_of_freedom=k - 1,
        significant=p_value < alpha,
        n_models=k,
        usable_blocks=usable_blocks,
        dropped_incomplete_blocks=0,
        test_used=test_used,
    )


def _build_paired_model_blocks(
    records: List[RunRecord],
    models: Sequence[str],
) -> Dict[tuple, Dict[str, RunRecord]]:
    """Collect one record per selected model for each matched (example_id, run_id) block."""
    by_block: Dict[tuple, Dict[str, RunRecord]] = {}
    model_set = set(models)
    for r in records:
        if r.model not in model_set:
            continue
        key = (r.example_id, r.run_id)
        bucket = by_block.setdefault(key, {})
        if r.model in bucket:
            warnings.warn(
                f"duplicate record for model={r.model!r} example_id={r.example_id!r} "
                f"run_id={r.run_id!r}; keeping the last occurrence.",
                RuntimeWarning,
                stacklevel=2,
            )
        bucket[r.model] = r
    return by_block


def cochran_q_test(
    records: List[RunRecord],
    models: Optional[Sequence[str]] = None,
    metric: str = "reachability",
    alpha: float = 0.05,
) -> CochranQResult:
    """
    Run Cochran's Q test for a binary metric across 3+ matched models.

    Matching blocks are keyed by (example_id, run_id). Only complete blocks that contain
    all selected models are used.
    """
    binary_metrics = {"domain_conformance", "executability", "reachability"}
    if metric not in binary_metrics:
        raise ValueError(
            f"Cochran's Q supports only binary metrics {sorted(binary_metrics)}, got {metric!r}."
        )
    if not records:
        raise ValueError("No records provided for Cochran's Q test.")

    selected_models = list(models) if models is not None else sorted({r.model for r in records})
    if len(selected_models) < 3:
        raise ValueError("Cochran's Q requires at least 3 models.")

    by_block = _build_paired_model_blocks(records, selected_models)
    complete_blocks = [
        block for block in by_block.values() if all(model in block for model in selected_models)
    ]
    usable_blocks = len(complete_blocks)
    dropped_blocks = len(by_block) - usable_blocks
    if usable_blocks == 0:
        raise ValueError(
            "No complete matched blocks found. Need the same (example_id, run_id) "
            "for every selected model."
        )

    result = _cochran_q_from_blocks(
        complete_blocks,
        labels=selected_models,
        metric=metric,
        alpha=alpha,
    )
    result.dropped_incomplete_blocks = dropped_blocks
    return result


def cochran_q_test_by_section(
    records: List[RunRecord],
    example_order: Dict[str, int],
    sections: Optional[Sequence[str]] = None,
    metric: str = "reachability",
    alpha: float = 0.05,
) -> CochranQResult:
    """
    Run Cochran's Q test across sections using matched ordinal positions within each section.

    Matching blocks are keyed by (model, run_id, ordinal_within_section). The caller must
    provide example_order mapping example_id -> ordinal position within its section.
    """
    binary_metrics = {"domain_conformance", "executability", "reachability"}
    if metric not in binary_metrics:
        raise ValueError(
            f"Cochran's Q supports only binary metrics {sorted(binary_metrics)}, got {metric!r}."
        )
    if not records:
        raise ValueError("No records provided for Cochran's Q test.")

    selected_sections = list(sections) if sections is not None else sorted(
        {str(r.section or "") for r in records if r.section}
    )
    if len(selected_sections) < 3:
        raise ValueError("Cochran's Q requires at least 3 sections.")

    by_block: Dict[tuple, Dict[str, RunRecord]] = {}
    selected_set = set(selected_sections)
    for r in records:
        section = str(r.section or "")
        if section not in selected_set:
            continue
        ordinal = example_order.get(r.example_id)
        if ordinal is None:
            continue
        key = (r.model, r.run_id, ordinal)
        bucket = by_block.setdefault(key, {})
        if section in bucket:
            warnings.warn(
                f"duplicate record for section={section!r} model={r.model!r} "
                f"run_id={r.run_id!r} ordinal={ordinal!r}; keeping the last occurrence.",
                RuntimeWarning,
                stacklevel=2,
            )
        bucket[section] = r

    complete_blocks = [
        block for block in by_block.values() if all(section in block for section in selected_sections)
    ]
    usable_blocks = len(complete_blocks)
    dropped_blocks = len(by_block) - usable_blocks
    if usable_blocks == 0:
        raise ValueError(
            "No complete matched blocks found across sections. "
            "Check dataset ordering and section coverage."
        )

    result = _cochran_q_from_blocks(
        complete_blocks,
        labels=selected_sections,
        metric=metric,
        alpha=alpha,
    )
    result.dropped_incomplete_blocks = dropped_blocks
    return result


def cochran_q_test_by_subsection(
    records: List[RunRecord],
    example_order: Dict[str, int],
    subsections: Optional[Sequence[str]] = None,
    metric: str = "reachability",
    alpha: float = 0.05,
) -> CochranQResult:
    """
    Run Cochran's Q test across subsections using matched ordinal positions within each subsection.

    Matching blocks are keyed by (model, run_id, ordinal_within_subsection). The caller must
    provide example_order mapping example_id -> ordinal position within its subsection.
    """
    binary_metrics = {"domain_conformance", "executability", "reachability"}
    if metric not in binary_metrics:
        raise ValueError(
            f"Cochran's Q supports only binary metrics {sorted(binary_metrics)}, got {metric!r}."
        )
    if not records:
        raise ValueError("No records provided for Cochran's Q test.")

    selected_subsections = list(subsections) if subsections is not None else sorted(
        {str(r.subsection or "") for r in records if r.subsection}
    )
    if len(selected_subsections) < 3:
        raise ValueError("Cochran's Q requires at least 3 subsections.")

    by_block: Dict[tuple, Dict[str, RunRecord]] = {}
    selected_set = set(selected_subsections)
    for r in records:
        subsection = str(r.subsection or "")
        if subsection not in selected_set:
            continue
        ordinal = example_order.get(r.example_id)
        if ordinal is None:
            continue
        key = (r.model, r.run_id, ordinal)
        bucket = by_block.setdefault(key, {})
        if subsection in bucket:
            warnings.warn(
                f"duplicate record for subsection={subsection!r} model={r.model!r} "
                f"run_id={r.run_id!r} ordinal={ordinal!r}; keeping the last occurrence.",
                RuntimeWarning,
                stacklevel=2,
            )
        bucket[subsection] = r

    complete_blocks = [
        block
        for block in by_block.values()
        if all(subsection in block for subsection in selected_subsections)
    ]
    usable_blocks = len(complete_blocks)
    dropped_blocks = len(by_block) - usable_blocks
    if usable_blocks == 0:
        raise ValueError(
            "No complete matched blocks found across subsections. "
            "Check dataset ordering and subsection coverage."
        )

    result = _cochran_q_from_blocks(
        complete_blocks,
        labels=selected_subsections,
        metric=metric,
        alpha=alpha,
    )
    result.dropped_incomplete_blocks = dropped_blocks
    return result


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
        bucket = by_pair.setdefault(key, {})
        if r.model in bucket:
            warnings.warn(
                f"compare_models: duplicate record for model={r.model!r} "
                f"example_id={r.example_id!r} run_id={r.run_id!r}; keeping the last occurrence.",
                RuntimeWarning,
                stacklevel=2,
            )
        bucket[r.model] = r

    # Only keep pairs that have both models
    pairs: List[tuple] = [k for k, v in by_pair.items() if model_a in v and model_b in v]
    if not pairs:
        return []

    metric_names = ["domain_conformance", "executability", "reachability", "optimality_ratio"]
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
            diff = arr_a - arr_b
            if np.allclose(diff, 0.0):
                p_val = 1.0
                test_used = "wilcoxon_skipped_identical"
            else:
                try:
                    stat, p_val = scipy_stats.wilcoxon(arr_a, arr_b, alternative="two-sided")
                    test_used = "wilcoxon"
                except Exception:
                    p_val = 1.0
                    test_used = "wilcoxon_failed"
        else:
            diff = arr_a - arr_b
            if np.allclose(diff, 0.0):
                p_val = 1.0
                test_used = "paired_ttest_skipped_identical"
            else:
                try:
                    stat, p_val = scipy_stats.ttest_rel(arr_a, arr_b)
                    test_used = "paired_ttest"
                except Exception:
                    p_val = 1.0
                    test_used = "paired_ttest_failed"

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

    metric_names = ["domain_conformance", "executability", "reachability", "optimality_ratio"]
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

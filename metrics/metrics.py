"""
Compute planning metrics from PDDL only.

Inputs: domain and problem PDDL (from dataset), predicted plan PDDL (from translator),
reference plan PDDL (from dataset). VAL is used for executability/reachability;
optimality is reported only for goal-reaching plans; diagnostics distinguish
VAL failure from deviation relative to the reference plan.
"""

from dataclasses import dataclass
from typing import Callable, List, Optional, Union

from metrics.plan_utils import pddl_plan_to_steps, first_deviation_step
from metrics.val_runner import run_val, ValResult


@dataclass
class PlanningMetrics:
    """Metrics for a single plan prediction (all inputs in PDDL)."""

    executability: bool
    reachability: bool
    optimality_ratio: float
    first_error_step: int
    first_val_failure_step: int
    first_ref_deviation_step: int


def compute_metrics(
    domain_pddl: str,
    problem_pddl: str,
    plan_pred_pddl: Union[str, List[str]],
    plan_ref_pddl: Union[str, List[str], None] = None,
    val_binary: str = "validate",
    val_timeout_seconds: int = 30,
    on_val_failure: Optional[Callable[[ValResult], None]] = None,
) -> PlanningMetrics:
    """
    Compute planning metrics. All plan inputs are already in PDDL format
    (from translator and dataset).

    Args:
        domain_pddl: PDDL domain string (from dataset).
        problem_pddl: PDDL problem string (from dataset).
        plan_pred_pddl: Predicted plan in PDDL (from translator); string or list of step strings.
        plan_ref_pddl: Reference optimal plan in PDDL (from dataset); string or list.
                       If None/empty, optimality/deviation diagnostics will be -1.
        val_binary: VAL validate binary name or path.

    Returns:
        PlanningMetrics with:
        - executability/reachability from VAL
        - optimality_ratio only for goal-reaching plans
        - first_val_failure_step and first_ref_deviation_step as diagnostics
    """
    pred_steps = pddl_plan_to_steps(plan_pred_pddl)
    ref_steps = pddl_plan_to_steps(plan_ref_pddl) if plan_ref_pddl else []

    val_result = run_val(
        domain_pddl,
        problem_pddl,
        pred_steps,
        val_binary=val_binary,
        timeout_seconds=val_timeout_seconds,
    )
    if not val_result.executable and on_val_failure is not None:
        on_val_failure(val_result)

    first_val_failure_step = (
        int(val_result.first_failing_step)
        if isinstance(val_result.first_failing_step, int)
        else -1
    )
    first_ref_deviation_step = -1
    optimality_ratio = -1.0

    # Optimality is only meaningful for goal-reaching plans; otherwise we only report failure.
    if ref_steps and val_result.goal_reached:
        first_ref_deviation_step = first_deviation_step(pred_steps, ref_steps)
        opt_len = len(ref_steps)
        pred_len = len(pred_steps)
        # If translator returned non-PDDL (e.g. NL text), pred_steps is empty; mark as invalid
        had_pred_content = bool(
            plan_pred_pddl and isinstance(plan_pred_pddl, str) and plan_pred_pddl.strip()
        )
        if pred_len == 0 and had_pred_content:
            optimality_ratio = -1.0
        else:
            optimality_ratio = pred_len / opt_len if opt_len > 0 else -1.0

    first_error_step = first_val_failure_step if first_val_failure_step > 0 else first_ref_deviation_step

    return PlanningMetrics(
        executability=val_result.executable,
        reachability=val_result.goal_reached,
        optimality_ratio=round(optimality_ratio, 4) if optimality_ratio >= 0 else -1.0,
        first_error_step=first_error_step,
        first_val_failure_step=first_val_failure_step,
        first_ref_deviation_step=first_ref_deviation_step,
    )

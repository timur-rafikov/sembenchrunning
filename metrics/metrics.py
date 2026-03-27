"""
Compute planning metrics from PDDL only.

Inputs: domain and problem PDDL (from dataset), predicted plan PDDL (from translator),
reference plan PDDL (from dataset). VAL is used for executability/reachability;
optimality is reported only for goal-reaching plans; diagnostics distinguish
VAL failure from deviation relative to the reference plan.
"""

from dataclasses import dataclass
from pathlib import Path
from typing import Callable, List, Optional, Union

from metrics.plan_utils import pddl_plan_to_steps, first_deviation_step
from metrics.val_runner import run_val, ValResult


@dataclass
class PlanningMetrics:
    """Metrics for a single plan prediction (all inputs in PDDL)."""

    domain_conformance: bool
    executability: bool
    reachability: bool
    optimality_ratio: float  # opt_len / pred_len when goal reached; -1.0 otherwise
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
    val_log_file: Optional[Union[Path, str]] = None,
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
        val_log_file: If set, full VAL stdout/stderr and exit metadata are written here.

    Returns:
        PlanningMetrics with:
        - domain_conformance: predicted plan parses/typechecks against the domain/problem in VAL
        - executability/reachability from VAL
        - optimality_ratio only when a reference exists and the goal is reached
          (len(pred)/len(ref); empty pred with non-empty ref is 0.0)
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
        val_log_file=val_log_file,
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

    # Reference deviation vs optimal plan: whenever a reference exists (for diagnostics).
    if ref_steps:
        first_ref_deviation_step = first_deviation_step(pred_steps, ref_steps)

    # Optimality ratio only when goal is reached.
    # opt_len / pred_len: 1.0 = matches reference, < 1.0 = suboptimal (longer plan),
    # > 1.0 = shorter than reference (super-optimal or different path).
    if ref_steps and val_result.goal_reached:
        opt_len = len(ref_steps)
        pred_len = len(pred_steps)
        if opt_len == 0:
            optimality_ratio = 1.0 if pred_len == 0 else -1.0
        elif pred_len == 0:
            optimality_ratio = 0.0
        else:
            optimality_ratio = opt_len / pred_len

    return PlanningMetrics(
        domain_conformance=val_result.domain_conformant,
        executability=val_result.executable,
        reachability=val_result.goal_reached,
        optimality_ratio=round(optimality_ratio, 4) if optimality_ratio >= 0 else -1.0,
        first_val_failure_step=first_val_failure_step,
        first_ref_deviation_step=first_ref_deviation_step,
    )

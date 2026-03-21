"""Run VAL (plan validator) via subprocess and parse results."""

import os
import re
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Union


@dataclass
class ValResult:
    """Result of VAL validation for a single plan."""

    executable: bool  # All actions applicable in sequence
    goal_reached: bool  # Goal holds after executing the plan
    exit_code: int
    stdout: str
    stderr: str
    first_failing_step: Optional[int]  # 1-based step index, or None if valid


def run_val(
    domain_pddl: str,
    problem_pddl: str,
    plan_steps: List[str],
    val_binary: str = "validate",
    timeout_seconds: int = 30,
    output_dir: Optional[Union[Path, str]] = None,
) -> ValResult:
    """
    Run VAL on the given domain, problem, and plan (list of action strings).
    If output_dir is set, writes domain.pddl, problem.pddl, plan.pddl there and
    passes those paths to VAL (so VAL reads exactly these files).
    Otherwise uses a temporary directory (deleted after run).
    Returns ValResult with executable, goal_reached, and first_failing_step.
    """
    use_temp = output_dir is None

    def _run_in_dir(tmp: Path) -> ValResult:
        domain_path = tmp / "domain.pddl"
        problem_path = tmp / "problem.pddl"
        plan_path = tmp / "plan.pddl"

        domain_path.write_text(domain_pddl, encoding="utf-8")
        problem_path.write_text(problem_pddl, encoding="utf-8")
        plan_content = "\n".join(plan_steps) + "\n"
        plan_path.write_text(plan_content, encoding="utf-8")

        debug_val = os.environ.get("DEBUG_VAL", "")
        if debug_val:
            print(f"[VAL DEBUG] Plan steps ({len(plan_steps)}): {plan_steps[:3]}...")

        result: Optional[subprocess.CompletedProcess[str]] = None
        run_error: Optional[BaseException] = None
        try:
            result = subprocess.run(
                [val_binary, str(domain_path), str(problem_path), str(plan_path)],
                capture_output=True,
                text=True,
                timeout=max(1, int(timeout_seconds)),
                cwd=os.getcwd(),
            )
        except BaseException as exc:
            run_error = exc
        return _parse_val_output(result, run_error, timeout_seconds)

    if use_temp:
        with tempfile.TemporaryDirectory(prefix="val_") as tmp_name:
            return _run_in_dir(Path(tmp_name))
    else:
        out = Path(output_dir)
        out.mkdir(parents=True, exist_ok=True)
        return _run_in_dir(out)


def _parse_val_output(
    result: Optional[subprocess.CompletedProcess],
    run_error: Optional[BaseException],
    timeout_seconds: int,
) -> ValResult:
    """Parse subprocess result from VAL into a ValResult."""
    if result is None:
        if isinstance(run_error, subprocess.TimeoutExpired):
            stdout = (run_error.stdout or "") if isinstance(run_error.stdout, str) else ""
            stderr = (run_error.stderr or "") if isinstance(run_error.stderr, str) else ""
            stderr = (stderr + f"\nVAL timed out after {max(1, int(timeout_seconds))} seconds.").strip()
            exit_code = -2
        else:
            stdout = ""
            stderr = f"VAL execution failed: {run_error}" if run_error is not None else "VAL execution failed."
            exit_code = -1
        return ValResult(
            executable=False,
            goal_reached=False,
            exit_code=exit_code,
            stdout=stdout,
            stderr=stderr,
            first_failing_step=None,
        )
    stdout = result.stdout or ""
    stderr = result.stderr or ""

    executable = goal_reached = False
    first_failing_step: Optional[int] = None

    combined = f"{stdout}\n{stderr}".lower()

    _GOAL_FAILURE_TOKENS = (
        "goal not satisfied",
        "goal not reached",
        "goal not",
        "goal unsatisfied",
        "unsatisfied goal",
    )

    if result.returncode == 0:
        executable = True
        goal_reached = not any(token in combined for token in _GOAL_FAILURE_TOKENS)
    else:
        if any(t in combined for t in _GOAL_FAILURE_TOKENS):
            executable = True
            goal_reached = False
        else:
            executable = False
            goal_reached = False
            time_matches = re.findall(r"happening\s*\(\s*time\s+(\d+)\s*\)", combined)
            if time_matches:
                first_failing_step = int(time_matches[-1])
            else:
                step_match = re.search(
                    r"at\s+time\s+(\d+)"
                    r"|(?:action|step)\s*[:#]?\s*(\d+)"
                    r"|executing\s+(\d+)"
                    r"|failed\s+at\s+(\d+)",
                    stdout + stderr,
                    re.I,
                )
                if step_match:
                    first_failing_step = int(next(g for g in step_match.groups() if g))

    debug_val = os.environ.get("DEBUG_VAL", "")
    if debug_val:
        print(f"[VAL DEBUG] exit={result.returncode} exec={executable} goal={goal_reached}")
        print(f"[VAL DEBUG] stdout: {stdout[:500] if stdout else '(empty)'}")
        print(f"[VAL DEBUG] stderr: {stderr[:500] if stderr else '(empty)'}")

    return ValResult(
        executable=executable,
        goal_reached=goal_reached,
        exit_code=result.returncode,
        stdout=stdout,
        stderr=stderr,
        first_failing_step=first_failing_step,
    )

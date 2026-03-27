"""Run VAL (plan validator) via subprocess and parse results."""

import os
import re
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Union


def write_val_full_log(
    log_path: Union[Path, str],
    result: "ValResult",
    *,
    domain_pddl: Optional[str] = None,
    problem_pddl: Optional[str] = None,
    plan_pddl: Optional[str] = None,
) -> None:
    """Write inputs passed to VAL (domain/problem/plan) and full subprocess outcome."""
    p = Path(log_path)
    p.parent.mkdir(parents=True, exist_ok=True)
    parts: List[str] = []
    if domain_pddl is not None:
        parts.extend(["--- domain.pddl (as passed to VAL) ---", domain_pddl.rstrip("\n"), ""])
    if problem_pddl is not None:
        parts.extend(["--- problem.pddl (as passed to VAL) ---", problem_pddl.rstrip("\n"), ""])
    if plan_pddl is not None:
        parts.extend(["--- plan.pddl (as passed to VAL) ---", plan_pddl.rstrip("\n"), ""])
    parts.extend(
        [
            "--- VAL parsed / exit ---",
            f"exit_code: {result.exit_code}",
            f"domain_conformant: {result.domain_conformant}",
            f"executable: {result.executable}",
            f"goal_reached: {result.goal_reached}",
            f"first_failing_step: {result.first_failing_step}",
            "",
            "--- stdout ---",
            result.stdout or "",
            "",
            "--- stderr ---",
            result.stderr or "",
            "",
        ]
    )
    p.write_text("\n".join(parts), encoding="utf-8")


@dataclass
class ValResult:
    """Result of VAL validation for a single plan."""

    domain_conformant: bool  # Plan parses/typechecks against the domain/problem
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
    val_log_file: Optional[Union[Path, str]] = None,
) -> ValResult:
    """
    Run VAL on the given domain, problem, and plan (list of action strings).
    If output_dir is set, writes domain.pddl, problem.pddl, plan.pddl there and
    passes those paths to VAL (so VAL reads exactly these files).
    Otherwise uses a temporary directory (deleted after run).
    If val_log_file is set, writes domain/problem/plan as passed to VAL plus stdout/stderr and metadata.
    Returns ValResult with executable, goal_reached, and first_failing_step.
    """
    use_temp = output_dir is None
    plan_content = "\n".join(plan_steps) + "\n"

    def _run_in_dir(tmp: Path) -> ValResult:
        domain_path = tmp / "domain.pddl"
        problem_path = tmp / "problem.pddl"
        plan_path = tmp / "plan.pddl"

        domain_path.write_text(domain_pddl, encoding="utf-8")
        problem_path.write_text(problem_pddl, encoding="utf-8")
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
        except Exception as exc:
            # Do not catch BaseException (KeyboardInterrupt, SystemExit) so the user can interrupt.
            run_error = exc
        return _parse_val_output(result, run_error, timeout_seconds)

    if use_temp:
        with tempfile.TemporaryDirectory(prefix="val_") as tmp_name:
            res = _run_in_dir(Path(tmp_name))
    else:
        out = Path(output_dir)
        out.mkdir(parents=True, exist_ok=True)
        res = _run_in_dir(out)
    if val_log_file:
        write_val_full_log(
            val_log_file,
            res,
            domain_pddl=domain_pddl,
            problem_pddl=problem_pddl,
            plan_pddl=plan_content,
        )
    return res


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
        elif isinstance(run_error, FileNotFoundError):
            stdout = ""
            stderr = (
                f"VAL binary not found: '{run_error.filename or 'validate'}'. "
                f"Install VAL or provide the correct path via --val-binary."
            )
            import warnings
            warnings.warn(stderr, RuntimeWarning, stacklevel=4)
            exit_code = -1
        else:
            stdout = ""
            stderr = f"VAL execution failed: {run_error}" if run_error is not None else "VAL execution failed."
            exit_code = -1
        return ValResult(
            domain_conformant=False,
            executable=False,
            goal_reached=False,
            exit_code=exit_code,
            stdout=stdout,
            stderr=stderr,
            first_failing_step=None,
        )
    stdout = result.stdout or ""
    stderr = result.stderr or ""
    if result.returncode != 0 and not str(stdout).strip() and not str(stderr).strip():
        stderr = (
            f"VAL exited with code {result.returncode} and produced no stdout/stderr "
            "(check --val-binary, working directory, and that the binary is Linux ELF under WSL)."
        )

    domain_conformant = executable = goal_reached = False
    first_failing_step: Optional[int] = None

    combined = f"{stdout}\n{stderr}".lower()

    # Validate may exit 0 while only reporting parse/read errors on stdout (e.g. bad plan syntax).
    _PLAN_READ_OR_SYNTAX_FAILURE_TOKENS = (
        "bad plan description",
        "bad plan file",
    )

    _GOAL_FAILURE_TOKENS = (
        "goal not satisfied",
        "goal not reached",
        "goal unsatisfied",
        "unsatisfied goal",
    )

    _ACTION_FAILURE_TOKENS = (
        "plan repair advice",
        "unsatisfied precondition",
        "is not applicable",
        "has an unsatisfied",
        "action at time",
    )

    if result.returncode == 0:
        if any(t in combined for t in _PLAN_READ_OR_SYNTAX_FAILURE_TOKENS):
            domain_conformant = False
            executable = False
            goal_reached = False
        else:
            domain_conformant = True
            executable = True
            goal_reached = not any(token in combined for token in _GOAL_FAILURE_TOKENS)
    else:
        has_plan_read_failure = any(t in combined for t in _PLAN_READ_OR_SYNTAX_FAILURE_TOKENS)
        has_goal_failure = any(t in combined for t in _GOAL_FAILURE_TOKENS)
        has_action_failure = any(t in combined for t in _ACTION_FAILURE_TOKENS)
        if has_plan_read_failure:
            domain_conformant = False
            executable = False
            goal_reached = False
        elif has_goal_failure and not has_action_failure:
            domain_conformant = True
            executable = True
            goal_reached = False
        else:
            domain_conformant = True
            executable = False
            goal_reached = False
            time_matches = re.findall(r"happening\s*\(\s*time\s+(\d+)\s*\)", combined)
            if time_matches:
                first_failing_step = int(time_matches[0])
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
        print(
            f"[VAL DEBUG] exit={result.returncode} domain_ok={domain_conformant} "
            f"exec={executable} goal={goal_reached}"
        )
        print(f"[VAL DEBUG] stdout: {stdout[:500] if stdout else '(empty)'}")
        print(f"[VAL DEBUG] stderr: {stderr[:500] if stderr else '(empty)'}")

    return ValResult(
        domain_conformant=domain_conformant,
        executable=executable,
        goal_reached=goal_reached,
        exit_code=result.returncode,
        stdout=stdout,
        stderr=stderr,
        first_failing_step=first_failing_step,
    )

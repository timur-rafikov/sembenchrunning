"""Convert PDDL plan to list of steps; compare with reference for first deviation."""

import re
from typing import List, Union

_PDDL_ACTION_RE = re.compile(r"^\(\s*[\w][\w-]*(\s+[\w][\w-]*)*\s*\)$")


def _normalize_pddl_step(step: str) -> str:
    """
    Normalize a PDDL action string for comparison.
    PDDL is case-insensitive; collapse internal whitespace too so that
    "(Pick-Up A  B)" and "(pick-up a b)" are treated as equal.
    """
    return " ".join(step.lower().split())


def first_deviation_step(pred_steps: List[str], ref_steps: List[str]) -> int:
    """
    Index (1-based) of the first step where predicted plan deviates from reference.
    Comparison is case-insensitive and whitespace-normalized (PDDL is case-insensitive).
    Returns 0 if plans match. If lengths differ, first deviation is at min(len)+1.
    """
    for i in range(min(len(pred_steps), len(ref_steps))):
        if _normalize_pddl_step(pred_steps[i]) != _normalize_pddl_step(ref_steps[i]):
            return i + 1
    if len(pred_steps) != len(ref_steps):
        return min(len(pred_steps), len(ref_steps)) + 1
    return 0


def _looks_like_pddl_action(line: str) -> bool:
    """True if line looks like a PDDL action, e.g. (action-name arg1 arg2)."""
    s = line.strip()
    if not s or not s.startswith("("):
        return False
    return bool(_PDDL_ACTION_RE.match(s))


def pddl_plan_to_steps(plan_pddl: Union[str, List[str]]) -> List[str]:
    """
    Normalize PDDL plan to list of steps (one action per line).
    Input is either a string (newline-separated) or already a list of step strings.
    Empty lines and lines starting with ';' are skipped.
    Only lines that look like PDDL actions (e.g. (name ...)) are kept, so that
    translator failure output (NL text) is not counted as steps.
    """
    if isinstance(plan_pddl, list):
        raw = [
            str(s).strip()
            for s in plan_pddl
            if s is not None and str(s).strip() and not str(s).strip().startswith(";")
        ]
    elif plan_pddl and isinstance(plan_pddl, str):
        raw = [
            line.strip()
            for line in plan_pddl.strip().splitlines()
            if line.strip() and not line.strip().startswith(";")
        ]
    else:
        return []
    return [line for line in raw if _looks_like_pddl_action(line)]

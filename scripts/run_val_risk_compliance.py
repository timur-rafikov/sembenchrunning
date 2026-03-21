#!/usr/bin/env python3
"""Run VAL on risk_compliance_controls. Plans are loaded only from run JSON (minimax responses),
written to val_debug, and VAL is invoked with paths to those files (no temp dir).
Usage: python run_val_risk_compliance.py [VAL_BINARY]."""

import json
import os
import sys
from pathlib import Path

# Add project root and metrics (avoid metrics/__init__.py to skip numpy)
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(ROOT / "metrics"))

from plan_utils import pddl_plan_to_steps
from val_runner import run_val

DATASET = ROOT / "data" / "batch_samples" / "finance" / "risk_compliance_controls"
RUNS = ROOT / "runs" / "batch_samples"
# Plans from run JSON are written here and VAL reads from here (no temp)
VAL_DEBUG_DIR = ROOT / "runs" / "val_debug"


def main():
    val_binary = sys.argv[1] if len(sys.argv) > 1 else "validate"
    print(f"VAL binary: {val_binary}", flush=True)
    print(f"Plans: from run JSON (minimax) -> {VAL_DEBUG_DIR} -> VAL", flush=True)

    for sample_dir in sorted(DATASET.iterdir()):
        if not sample_dir.is_dir():
            continue
        sample_json = sample_dir / "sample.json"
        if not sample_json.exists():
            continue
        data = json.loads(sample_json.read_text(encoding="utf-8"))
        domain_path = data.get("domain_path")
        problem_path = data.get("problem_path")
        if not domain_path or not problem_path:
            continue
        domain_file = sample_dir / domain_path
        problem_file = sample_dir / problem_path
        if not domain_file.exists() or not problem_file.exists():
            continue

        # Find run file for minimax
        example_id = data.get("id", sample_dir.name)
        run_name = f"{example_id}__minimax_minimax-m2.5.json"
        run_file = RUNS / run_name
        if not run_file.exists():
            print(f"\n[{sample_dir.name}] No run file {run_name}, skip")
            continue

        run_data = json.loads(run_file.read_text(encoding="utf-8"))
        plan_pred = run_data.get("plan_pred_pddl")
        if not plan_pred:
            print(f"\n[{sample_dir.name}] No plan_pred_pddl in run JSON, skip")
            continue

        # Plan only from run JSON (minimax response)
        domain_pddl = domain_file.read_text(encoding="utf-8")
        problem_pddl = problem_file.read_text(encoding="utf-8")
        steps = pddl_plan_to_steps(plan_pred)

        debug_dir = VAL_DEBUG_DIR / example_id.replace("__", os.sep)
        debug_dir.mkdir(parents=True, exist_ok=True)
        # Write from JSON/dataset so VAL reads these files (no temp)
        (debug_dir / "plan.pddl").write_text("\n".join(steps) + "\n", encoding="utf-8")
        (debug_dir / "domain.pddl").write_text(domain_pddl, encoding="utf-8")
        (debug_dir / "problem.pddl").write_text(problem_pddl, encoding="utf-8")
        print(f"\n[{sample_dir.name}] plan from run JSON, steps: {len(steps)}  -> {debug_dir}/", flush=True)
        print(f"  First 3: {steps[:3]}", flush=True)
        try:
            res = run_val(domain_pddl, problem_pddl, steps, val_binary=val_binary, output_dir=debug_dir)
            print(f"  executable={res.executable} goal_reached={res.goal_reached} first_failing_step={res.first_failing_step} exit_code={res.exit_code}")
            if not res.executable and res.stderr:
                print(f"  VAL stderr:\n{res.stderr[:1500]}")
            if res.stdout and not res.executable:
                print(f"  VAL stdout:\n{res.stdout[:800]}")
        except FileNotFoundError as e:
            print(f"  ERROR: {e}")
            print("  Tip: run in WSL with: python scripts/run_val_risk_compliance.py /mnt/d/work/VAL/build/bin/Validate")
            sys.exit(1)
        except Exception as e:
            print(f"  ERROR: {e}")
            raise

    print("\nDone.")
    print(f"Inspect: cat {VAL_DEBUG_DIR}/finance/risk_compliance_controls/<sample>/plan.pddl")


if __name__ == "__main__":
    main()

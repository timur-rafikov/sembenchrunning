#!/usr/bin/env python3
"""
Generate plans from abstract PDDL using Fast Downward and translate them to themed domain.

This script:
1. Finds all sample directories with input_domain.pddl + input_problem.pddl
2. Runs Fast Downward to generate plans
3. Applies final_mapping.json to translate abstract actions/objects to themed names
4. Saves translated plans to the benchmark dataset
"""

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Optional


def find_sample_dirs(source_dir: Path) -> list[Path]:
    """Find all directories containing input_domain.pddl and input_problem.pddl."""
    sample_dirs = []
    for root, _, files in os.walk(source_dir):
        if "input_domain.pddl" in files and "input_problem.pddl" in files:
            sample_dirs.append(Path(root))
    return sample_dirs


def run_fast_downward(
    fd_path: str,
    domain_path: Path,
    problem_path: Path,
    timeout: int = 120,
) -> Optional[str]:
    """Run Fast Downward and return the generated plan, or None if failed."""
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_domain = Path(tmpdir) / "domain.pddl"
        tmp_problem = Path(tmpdir) / "problem.pddl"
        plan_file = Path(tmpdir) / "sas_plan"
        
        shutil.copy(domain_path, tmp_domain)
        shutil.copy(problem_path, tmp_problem)
        
        cmd = [
            sys.executable,
            f"{fd_path}/fast-downward.py",
            "--plan-file", str(plan_file),
            str(tmp_domain),
            str(tmp_problem),
            "--search", "lazy_greedy([ff()])",
        ]
        
        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=timeout,
                cwd=tmpdir,
            )
            
            if plan_file.exists():
                return plan_file.read_text()
            else:
                print(f"  No plan generated. Exit code: {result.returncode}")
                if result.stderr:
                    print(f"  stderr: {result.stderr[:500]}")
                return None
                
        except subprocess.TimeoutExpired:
            print(f"  Timeout ({timeout}s) expired")
            return None
        except Exception as e:
            print(f"  Error running FD: {e}")
            return None


def parse_plan(plan_text: str) -> list[tuple[str, list[str]]]:
    """Parse plan text into list of (action, [args])."""
    actions = []
    for line in plan_text.strip().split("\n"):
        line = line.strip()
        if not line or line.startswith(";"):
            continue
        match = re.match(r"\(([^\s]+)\s*(.*)\)", line)
        if match:
            action = match.group(1).lower()
            args_str = match.group(2).strip()
            args = args_str.split() if args_str else []
            actions.append((action, args))
    return actions


def translate_plan(
    plan_actions: list[tuple[str, list[str]]],
    mapping: dict,
) -> list[str]:
    """Translate abstract plan to themed domain using mapping."""
    action_map = {k.lower(): v["name"] for k, v in mapping.get("actions", {}).items()}
    object_map = {k.lower(): v for k, v in mapping.get("objects", {}).items()}
    
    translated = []
    for action, args in plan_actions:
        themed_action = action_map.get(action, action)
        themed_args = [object_map.get(arg.lower(), arg) for arg in args]
        translated.append(f"({themed_action} {' '.join(themed_args)})")
    
    return translated


def get_sample_path_info(sample_dir: Path, source_root: Path) -> dict:
    """Extract topic/subtopic/domain_name from sample directory structure."""
    rel_path = sample_dir.relative_to(source_root)
    parts = rel_path.parts
    
    if len(parts) >= 4:
        return {
            "index": parts[0],
            "topic": parts[1],
            "subtopic": parts[2],
            "domain_name": parts[3],
        }
    return {
        "index": str(sample_dir.name),
        "topic": "unknown",
        "subtopic": "unknown",
        "domain_name": sample_dir.name,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--source-dir",
        type=str,
        required=True,
        help="Source directory with abstract PDDL samples",
    )
    parser.add_argument(
        "--dest-dir",
        type=str,
        required=True,
        help="Destination benchmark data directory",
    )
    parser.add_argument(
        "--fd-path",
        type=str,
        default="/mnt/d/fd/fast-downward-22.12",
        help="Path to Fast Downward installation",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=120,
        help="Timeout for each FD run in seconds",
    )
    parser.add_argument(
        "--include-failed",
        action="store_true",
        help="Include samples that failed validation",
    )
    args = parser.parse_args()
    
    source_dir = Path(args.source_dir)
    dest_dir = Path(args.dest_dir)
    
    sample_dirs = find_sample_dirs(source_dir)
    print(f"Found {len(sample_dirs)} sample directories")
    
    success_count = 0
    fail_count = 0
    skip_count = 0
    
    for sample_dir in sample_dirs:
        print(f"\nProcessing: {sample_dir}")
        
        validation_report = sample_dir / "validation_report.json"
        if validation_report.exists():
            with open(validation_report, encoding="utf-8") as f:
                report = json.load(f)
            status = report.get("status", "unknown")
            if status != "passed" and not args.include_failed:
                print(f"  Skipping (status={status})")
                skip_count += 1
                continue
        
        mapping_file = sample_dir / "final_mapping.json"
        if not mapping_file.exists():
            print(f"  Skipping: no final_mapping.json")
            skip_count += 1
            continue
        
        with open(mapping_file, encoding="utf-8") as f:
            mapping = json.load(f)
        
        domain_path = sample_dir / "input_domain.pddl"
        problem_path = sample_dir / "input_problem.pddl"
        
        print(f"  Running Fast Downward...")
        plan_text = run_fast_downward(
            args.fd_path,
            domain_path,
            problem_path,
            timeout=args.timeout,
        )
        
        if not plan_text:
            print(f"  Failed to generate plan")
            fail_count += 1
            continue
        
        plan_actions = parse_plan(plan_text)
        print(f"  Generated plan with {len(plan_actions)} actions")
        
        translated_plan = translate_plan(plan_actions, mapping)
        
        path_info = get_sample_path_info(sample_dir, source_dir)
        topic = path_info["topic"]
        subtopic = path_info["subtopic"]
        domain_name = path_info["domain_name"]
        
        sample_dest = dest_dir / topic / subtopic / domain_name
        sample_dest.mkdir(parents=True, exist_ok=True)
        
        plan_filename = f"{domain_name}_plan.pddl"
        plan_path = sample_dest / plan_filename
        plan_path.write_text("\n".join(translated_plan) + "\n")
        print(f"  Wrote plan to: {plan_path}")
        
        sample_json_path = sample_dest / "sample.json"
        if sample_json_path.exists():
            with open(sample_json_path, encoding="utf-8") as f:
                sample_json = json.load(f)
        else:
            sample_json = {
                "section": topic,
                "subsection": subtopic,
                "id": f"{topic}__{subtopic}__{domain_name}",
            }
        
        sample_json["plan_ref"] = plan_filename
        sample_json["plan_length"] = len(translated_plan)
        
        with open(sample_json_path, "w", encoding="utf-8") as f:
            json.dump(sample_json, f, ensure_ascii=False, indent=2)
        
        success_count += 1
    
    print(f"\n=== Summary ===")
    print(f"Success: {success_count}")
    print(f"Failed:  {fail_count}")
    print(f"Skipped: {skip_count}")


if __name__ == "__main__":
    main()

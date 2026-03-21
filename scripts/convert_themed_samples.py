#!/usr/bin/env python3
"""
Конвертирует сэмплы из sashasamples/finalfortokens/examples_new3_90_ex
в формат бенчмарка sembenchrunning.

Использование:
  python scripts/convert_themed_samples.py \
    --source D:/work/sashasamples/finalfortokens/examples_new3_90_ex \
    --dest data/themed_pddl \
    --section themed_pddl \
    [--planner /path/to/fast-downward/fast-downward.py]

Структура исходных данных:
  <source>/<N>/themed_domain.pddl
  <source>/<N>/themed_problem.pddl

Структура результата:
  <dest>/<N>/themed_pddl_<N>_domain.pddl
  <dest>/<N>/themed_pddl_<N>_problem.pddl
  <dest>/<N>/themed_pddl_<N>_plan.pddl  (если задан --planner)
  <dest>/<N>/sample.json
"""

import argparse
import json
import os
import shutil
import subprocess
import tempfile
from pathlib import Path


def generate_plan_with_fd(domain_path: Path, problem_path: Path, fd_path: str) -> str | None:
    """Генерирует план с помощью Fast Downward."""
    with tempfile.TemporaryDirectory() as tmpdir:
        plan_file = Path(tmpdir) / "sas_plan"
        cmd = [
            "python", fd_path,
            "--plan-file", str(plan_file),
            str(domain_path),
            str(problem_path),
            "--search", "astar(lmcut())"
        ]
        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=300,
                cwd=tmpdir,
            )
            if plan_file.exists():
                plan_content = plan_file.read_text(encoding="utf-8")
                lines = [
                    l.strip() for l in plan_content.splitlines()
                    if l.strip() and not l.strip().startswith(";")
                ]
                return "\n".join(lines)
        except Exception as e:
            print(f"  Planner error: {e}")
    return None


def convert_samples(
    source_dir: Path,
    dest_dir: Path,
    section: str,
    planner_path: str | None = None,
):
    """Конвертирует все сэмплы."""
    dest_dir.mkdir(parents=True, exist_ok=True)

    sample_dirs = sorted(
        [d for d in source_dir.iterdir() if d.is_dir() and d.name.isdigit()],
        key=lambda d: int(d.name)
    )

    print(f"Found {len(sample_dirs)} samples in {source_dir}")

    for sample_dir in sample_dirs:
        sample_num = sample_dir.name
        domain_src = sample_dir / "themed_domain.pddl"
        problem_src = sample_dir / "themed_problem.pddl"

        if not domain_src.exists() or not problem_src.exists():
            print(f"  Skip {sample_num}: missing domain or problem")
            continue

        out_dir = dest_dir / sample_num
        out_dir.mkdir(parents=True, exist_ok=True)

        prefix = f"{section}_{sample_num}"
        domain_dst = out_dir / f"{prefix}_domain.pddl"
        problem_dst = out_dir / f"{prefix}_problem.pddl"
        plan_dst = out_dir / f"{prefix}_plan.pddl"

        shutil.copy2(domain_src, domain_dst)
        shutil.copy2(problem_src, problem_dst)

        plan_generated = False
        if planner_path:
            print(f"  {sample_num}: generating plan...", end=" ", flush=True)
            plan_content = generate_plan_with_fd(domain_dst, problem_dst, planner_path)
            if plan_content:
                plan_dst.write_text(plan_content, encoding="utf-8")
                plan_generated = True
                print("OK")
            else:
                print("FAILED (no solution or timeout)")

        sample_json = {
            "id": f"{section}__{sample_num}",
            "section": section,
            "subsection": sample_num,
            "domain_path": domain_dst.name,
            "problem_path": problem_dst.name,
        }
        if plan_generated:
            sample_json["plan_ref_path"] = plan_dst.name

        (out_dir / "sample.json").write_text(
            json.dumps(sample_json, indent=2, ensure_ascii=False),
            encoding="utf-8"
        )

        if not planner_path:
            print(f"  {sample_num}: converted (no plan)")

    print(f"\nDone. Output in {dest_dir}")
    if not planner_path:
        print("Note: No reference plans generated. Use --planner to generate them.")
        print("Without plans, only executability and reachability metrics will be computed.")


def main():
    parser = argparse.ArgumentParser(description="Convert themed samples to benchmark format")
    parser.add_argument(
        "--source",
        type=Path,
        required=True,
        help="Source directory with numbered sample folders"
    )
    parser.add_argument(
        "--dest",
        type=Path,
        required=True,
        help="Destination directory (e.g., data/themed_pddl)"
    )
    parser.add_argument(
        "--section",
        type=str,
        default="themed_pddl",
        help="Section name for sample IDs (default: themed_pddl)"
    )
    parser.add_argument(
        "--planner",
        type=str,
        default=None,
        help="Path to Fast Downward (fast-downward.py) to generate reference plans"
    )
    args = parser.parse_args()

    convert_samples(
        source_dir=args.source,
        dest_dir=args.dest,
        section=args.section,
        planner_path=args.planner,
    )


if __name__ == "__main__":
    main()

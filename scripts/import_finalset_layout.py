#!/usr/bin/env python3
"""
Создаёт sample.json в каждой папке сэмпла для датасета вида:
  <dataset_root>/<section>/<subsection>/<sample_slug>/
    themed_domain.pddl
    themed_problem.pddl
    themed_plan.txt   (опционально, эталонный план)

Использование после копирования final-set/final -> data/finalset:
  python scripts/import_finalset_layout.py --dataset-dir data/finalset
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any, Dict, List


def iter_sample_dirs(root: Path) -> List[Path]:
  """Папки, где лежат themed_domain.pddl и themed_problem.pddl."""
  out: List[Path] = []
  for domain in sorted(root.rglob("themed_domain.pddl")):
    d = domain.parent
    if (d / "themed_problem.pddl").is_file():
      out.append(d)
  return out


def build_sample_record(sample_dir: Path, dataset_root: Path) -> Dict[str, Any]:
  rel = sample_dir.resolve().relative_to(dataset_root.resolve())
  parts = rel.parts
  if len(parts) < 3:
    raise ValueError(f"Need section/subsection/sample_slug, got {rel}")
  section, subsection = parts[0], parts[1]
  sample_slug = parts[2] if len(parts) == 3 else str(Path(*parts[2:]))

  example_id = f"{section}__{subsection}__{sample_slug}"
  rec: Dict[str, Any] = {
    "id": example_id,
    "section": section,
    "subsection": subsection,
    "domain_path": "themed_domain.pddl",
    "problem_path": "themed_problem.pddl",
  }
  plan = sample_dir / "themed_plan.txt"
  if plan.is_file():
    rec["plan_ref_path"] = "themed_plan.txt"
  return rec


def main() -> None:
  parser = argparse.ArgumentParser(description="Generate sample.json for finalset-style themed layout")
  parser.add_argument(
    "--dataset-dir",
    type=Path,
    required=True,
    help="Корень датасета (например data/finalset)",
  )
  parser.add_argument(
    "--dry-run",
    action="store_true",
    help="Только печать, без записи",
  )
  args = parser.parse_args()
  root = args.dataset_dir.resolve()
  if not root.is_dir():
    raise SystemExit(f"Not a directory: {root}")

  dirs = iter_sample_dirs(root)
  print(f"Found {len(dirs)} samples under {root}")
  written = 0
  for d in dirs:
    try:
      rec = build_sample_record(d, root)
    except ValueError as e:
      print(f"  SKIP {d}: {e}")
      continue
    path = d / "sample.json"
    if args.dry_run:
      print(f"  would write {path.relative_to(root)} -> id={rec['id']}")
    else:
      path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
      written += 1
  if not args.dry_run:
    print(f"Wrote {written} sample.json files.")


if __name__ == "__main__":
  main()

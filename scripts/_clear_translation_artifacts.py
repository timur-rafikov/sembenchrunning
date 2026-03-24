"""Remove translation / domain-setup caches for a full re-run (PDDL→NL sample, domain JSON, NL2PDDL, APB diskcache).

Run: python scripts/_clear_translation_artifacts.py
Paths: AUTOPLANBENCH_ROOT (default d:\\work\\autoplanbench) for llm_caches; sembench repo = parent of scripts/.
"""
from __future__ import annotations

import json
import os
import shutil
import sys
from pathlib import Path


def main() -> None:
    sem = Path(__file__).resolve().parent.parent
    data = sem / "data"
    runs = sem / "runs"
    apb_root = os.environ.get("AUTOPLANBENCH_ROOT", "").strip()
    apb = Path(apb_root) if apb_root else Path(r"d:\work\autoplanbench")
    llm_caches = apb / "llm_caches"
    bak = Path(r"d:\work\finalset_5s_translations_backup")

    removed_files = 0
    removed_dirs = 0

    def unlink_many(root: Path, patterns: tuple[str, ...]) -> None:
        nonlocal removed_files
        if not root.is_dir():
            return
        for pat in patterns:
            for p in root.rglob(pat):
                if not p.is_file():
                    continue
                try:
                    p.unlink()
                    removed_files += 1
                    print("del", p)
                except OSError as e:
                    print("err", p, e, file=sys.stderr)

    # Per-sample / per-section: NL prompt cache, domain JSON, usage, manifest
    if data.is_dir():
        unlink_many(
            data,
            (
                "domain_and_problem_nl.txt",
                "domain_and_problem_nl.meta.json",
                "domain_description_seed*.json",
                "domain_description_seed*.manifest.json",
                "domain_llm_usage_seed*.json",
            ),
        )
        for d in list(data.rglob("_apb_setup")):
            if d.is_dir():
                try:
                    shutil.rmtree(d)
                    removed_dirs += 1
                    print("rmtree", d)
                except OSError as e:
                    print("err rmtree", d, e, file=sys.stderr)

    # Run JSON: NL2PDDL cache
    if runs.is_dir():
        for p in runs.rglob("*__nl2pddl_debug.json"):
            try:
                p.unlink()
                removed_files += 1
                print("del", p)
            except OSError as e:
                print("err", p, e, file=sys.stderr)
        for p in runs.rglob("*.json"):
            if "__nl2pddl_debug" in p.name:
                continue
            try:
                raw = json.loads(p.read_text(encoding="utf-8"))
            except (OSError, json.JSONDecodeError):
                continue
            if not isinstance(raw, dict) or "plan_pred_pddl" not in raw:
                continue
            del raw["plan_pred_pddl"]
            p.write_text(json.dumps(raw, ensure_ascii=False, indent=2), encoding="utf-8")
            print("cleared plan_pred_pddl", p)

    # Backup tree (same layout)
    if bak.is_dir():
        for p in bak.glob("dataset/**/domain_and_problem_nl.txt"):
            p.unlink(missing_ok=True)
            removed_files += 1
            print("del", p)
        for p in bak.glob("dataset/**/domain_and_problem_nl.meta.json"):
            p.unlink(missing_ok=True)
            removed_files += 1
            print("del", p)
        br = bak / "runs"
        if br.is_dir():
            for p in br.glob("*__nl2pddl_debug.json"):
                p.unlink(missing_ok=True)
                removed_files += 1
                print("del", p)
            for p in br.glob("*.json"):
                if "__nl2pddl_debug" in p.name:
                    continue
                try:
                    raw = json.loads(p.read_text(encoding="utf-8"))
                except (OSError, json.JSONDecodeError):
                    continue
                if isinstance(raw, dict) and "plan_pred_pddl" in raw:
                    del raw["plan_pred_pddl"]
                    p.write_text(json.dumps(raw, ensure_ascii=False, indent=2), encoding="utf-8")
                    print("cleared plan_pred_pddl", p)

    # AutoPlanBench HTTP/diskcache for translators (full)
    if llm_caches.is_dir():
        try:
            shutil.rmtree(llm_caches)
            removed_dirs += 1
            print("rmtree", llm_caches)
        except OSError as e:
            print("err rmtree", llm_caches, e, file=sys.stderr)

    print(f"done: files removed={removed_files}, dirs removed={removed_dirs}")


if __name__ == "__main__":
    main()

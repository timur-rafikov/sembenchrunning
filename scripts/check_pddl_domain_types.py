#!/usr/bin/env python3
"""
Проверка (:types ...) в themed_domain.pddl / *_domain.pddl: родители без объявления (как у Tarski UndefinedSort).

Использует ту же логику, что fix_pddl_parent_types.py. Код выхода 1, если есть проблемы.
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT_PKG = Path(__file__).resolve().parent.parent


def parse_types_and_find_missing_parents(types_body: str) -> set:
    """Синхронно с scripts/fix_pddl_parent_types.py."""
    rest = types_body.strip().rstrip(")")
    parts = rest.split(" - ")
    declared: set = set()
    used_parents: set = set()
    for i, p in enumerate(parts):
        p = p.strip().rstrip(")")
        tokens = p.split()
        if not tokens:
            continue
        if i == 0:
            declared.add(tokens[0])
            continue
        used_parents.add(tokens[0])
        if len(tokens) > 1:
            declared.add(tokens[-1])
    return used_parents - declared - {"object"}


# DOTALL: редкий многострочный (:types ...); .+? до первой закрывающей скобки блока
TYPES_LINE = re.compile(r"^(\s*\(:types\s+)(.+?)(\))\s*$", re.MULTILINE | re.DOTALL)


def check_file(path: Path) -> tuple[str, list]:
    """
    Returns ("ok", []) or ("no_types_line", []) or ("missing", [sorted missing parents]).
    """
    text = path.read_text(encoding="utf-8")
    m = TYPES_LINE.search(text)
    if not m:
        return ("no_types_line", [])
    body = m.group(2).strip()
    missing = sorted(parse_types_and_find_missing_parents(body))
    if missing:
        return ("missing", missing)
    return ("ok", [])


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "roots",
        nargs="*",
        help="Корни (по умолчанию data/finalset)",
    )
    args = parser.parse_args()
    data = ROOT_PKG / "data"
    if args.roots:
        roots = [Path(p).resolve() for p in args.roots]
    else:
        roots = [data / "finalset"] if (data / "finalset").is_dir() else []

    if not roots:
        print("No roots to scan.")
        return 0

    paths: list[Path] = []
    for r in roots:
        if not r.is_dir():
            print(f"Skip missing dir: {r}")
            continue
        paths.extend(r.rglob("themed_domain.pddl"))
        paths.extend(r.rglob("*_domain.pddl"))
    paths = sorted({p for p in paths if "_apb_setup" not in str(p)})

    no_line: list[Path] = []
    missing_list: list[tuple[Path, list]] = []

    for p in paths:
        status, extra = check_file(p)
        if status == "no_types_line":
            no_line.append(p)
        elif status == "missing":
            missing_list.append((p, extra))

    def _rel(p: Path) -> str:
        try:
            return str(p.relative_to(ROOT_PKG))
        except ValueError:
            return str(p)

    print(f"Scanned {len(paths)} domain files under {len(roots)} root(s).")
    if no_line:
        print(f"\nNO single-line (:types ...) match ({len(no_line)} files):")
        for p in no_line[:50]:
            print(f"  {_rel(p)}")
        if len(no_line) > 50:
            print(f"  ... and {len(no_line) - 50} more")
    if missing_list:
        print(f"\nMISSING parent types ({len(missing_list)} files):")
        for p, miss in missing_list[:80]:
            print(f"  {_rel(p)} -> {miss}")
        if len(missing_list) > 80:
            print(f"  ... and {len(missing_list) - 80} more")

    if not no_line and not missing_list:
        print("OK: no missing type parents and all (:types) lines match the expected pattern.")
        return 0
    return 1


if __name__ == "__main__":
    raise SystemExit(main())

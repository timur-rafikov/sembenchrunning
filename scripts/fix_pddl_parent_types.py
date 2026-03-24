#!/usr/bin/env python3
"""
Добавляет недостающие родительские типы в PDDL домены для Tarski/AutoPlanBench.

Типы вроде 'foo - entity' требуют объявления 'entity - object' в том же блоке :types.
Скрипт парсит строку (:types ...), находит родителей, которые используются, но не объявлены,
и добавляет "parent - object" в начало списка типов.

По умолчанию обходит data/batch_samples и data/finalset (если есть), файлы *_domain.pddl
и themed_domain.pddl (копии в _apb_setup пропускаются).
"""
import argparse
import re
from pathlib import Path


def parse_types_and_find_missing_parents(types_body: str) -> set:
    """
    Парсит строку (:types A - B C - B ...) и возвращает множество родительских
    типов, которые используются, но не объявлены (не считая object).
    """
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


def fix_domain_file(path: Path) -> bool:
    text = path.read_text(encoding="utf-8")
    changed = False
    # Строка вида "  (:types type1 - parent type2 - parent ...)"
    types_pattern = re.compile(r"^(\s*\(:types\s+)(.+?)(\))\s*$", re.MULTILINE)

    def repl(m):
        nonlocal changed
        prefix, types_body, suffix = m.group(1), m.group(2), m.group(3)
        rest = types_body.strip()
        missing = parse_types_and_find_missing_parents(rest)
        if not missing:
            return m.group(0)
        changed = True
        to_prepend = " ".join(f"{p} - object" for p in sorted(missing)) + " "
        return f"{prefix}{to_prepend}{rest}{suffix}\n"

    new_text = types_pattern.sub(repl, text)
    if changed:
        path.write_text(new_text, encoding="utf-8")
    return changed


def iter_domain_files_under(root: Path) -> list:
    out: list = []
    if not root.is_dir():
        return out
    for pattern in ("*_domain.pddl", "themed_domain.pddl"):
        out.extend(root.rglob(pattern))
    return [f for f in out if "_apb_setup" not in str(f)]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "roots",
        nargs="*",
        help="Корни датасета для обхода (по умолчанию: data/batch_samples и data/finalset)",
    )
    args = parser.parse_args()
    base = Path(__file__).resolve().parent.parent / "data"
    if args.roots:
        roots = [Path(p).resolve() for p in args.roots]
    else:
        roots = []
        for name in ("batch_samples", "finalset"):
            p = base / name
            if p.is_dir():
                roots.append(p)

    if not roots:
        print("No data roots found. Pass paths explicitly, e.g. scripts/fix_pddl_parent_types.py data/finalset")
        return

    domain_files: list = []
    for r in roots:
        domain_files.extend(iter_domain_files_under(r))
    domain_files = sorted(set(domain_files))

    fixed = 0
    for path in domain_files:
        try:
            if fix_domain_file(path):
                print(f"Fixed: {path}")
                fixed += 1
        except OSError as e:
            print(f"Skip {path}: {e}")
    print(f"Done. Fixed {fixed} of {len(domain_files)} domain files.")


if __name__ == "__main__":
    main()

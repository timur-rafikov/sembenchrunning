#!/usr/bin/env python3
"""
Добавляет недостающие родительские типы в PDDL домены для Tarski/AutoPlanBench.

Типы вроде 'ach_batch - entity' требуют объявления 'entity - object'.
Скрипт находит все *_domain.pddl в data/batch_samples, парсит блок :types,
и добавляет "parent - object" для любого родителя, который используется, но не объявлен.
"""
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


def main():
    data_dir = Path(__file__).resolve().parent.parent / "data" / "batch_samples"
    if not data_dir.is_dir():
        print(f"Directory not found: {data_dir}")
        return
    domain_files = list(data_dir.rglob("*_domain.pddl"))
    # исключаем копии в _apb_setup
    domain_files = [f for f in domain_files if "_apb_setup" not in str(f)]
    fixed = 0
    for path in sorted(domain_files):
        if fix_domain_file(path):
            print(f"Fixed: {path.relative_to(data_dir)}")
            fixed += 1
    print(f"Done. Fixed {fixed} of {len(domain_files)} domain files.")


if __name__ == "__main__":
    main()

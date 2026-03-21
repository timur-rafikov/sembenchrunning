#!/usr/bin/env python3
"""
Конвертирует сэмплы из batch_* папок в формат бенчмарка.

Структура исходных данных:
  <source>/3/<topic>/<subtopic>/<domain_name>/
    - themed_domain.pddl
    - themed_problem.pddl  
    - validation_report.json (статус passed/failed)
    - theme.json (метаданные темы)

Структура результата:
  <dest>/<topic>/<subtopic>/<domain_name>/
    - <domain_name>_domain.pddl
    - <domain_name>_problem.pddl
    - sample.json

Использование:
  python scripts/convert_batch_samples.py \
    --source D:/work/sashasamples/finalfortokens/batch_20260311T092814Z_d1e87f0d \
    --dest data/batch_samples \
    [--include-failed]  # по умолчанию failed пропускаются
"""

import argparse
import json
import shutil
from pathlib import Path


def find_sample_dirs(source_dir: Path) -> list[Path]:
    """Находит все папки с themed_domain.pddl и themed_problem.pddl."""
    samples = []
    for domain_file in source_dir.rglob("themed_domain.pddl"):
        sample_dir = domain_file.parent
        problem_file = sample_dir / "themed_problem.pddl"
        if problem_file.exists():
            samples.append(sample_dir)
    return sorted(samples)


def get_sample_status(sample_dir: Path) -> tuple[str, dict]:
    """Возвращает (status, metadata) из validation_report.json."""
    report_file = sample_dir / "validation_report.json"
    if report_file.exists():
        try:
            data = json.loads(report_file.read_text(encoding="utf-8"))
            return data.get("status", "unknown"), data
        except:
            pass
    return "unknown", {}


def get_theme_info(sample_dir: Path) -> dict:
    """Возвращает информацию из theme.json."""
    theme_file = sample_dir / "theme.json"
    if theme_file.exists():
        try:
            return json.loads(theme_file.read_text(encoding="utf-8"))
        except:
            pass
    return {}


def convert_samples(
    source_dir: Path,
    dest_dir: Path,
    include_failed: bool = False,
):
    """Конвертирует все сэмплы."""
    dest_dir.mkdir(parents=True, exist_ok=True)

    samples = find_sample_dirs(source_dir)
    print(f"Found {len(samples)} samples in {source_dir}")

    stats = {"passed": 0, "failed": 0, "skipped": 0, "converted": 0}

    for sample_dir in samples:
        rel_path = sample_dir.relative_to(source_dir)
        parts = rel_path.parts

        # Структура: 3/<topic>/<subtopic>/<domain_name>
        if len(parts) < 4:
            print(f"  Skip {sample_dir}: unexpected structure {parts}")
            stats["skipped"] += 1
            continue

        topic = parts[1]  # finance, healthcare, programming
        subtopic = parts[2]  # payments_settlement, etc.
        domain_name = parts[3]  # ach_batch_window_orchestration, etc.

        # Проверяем статус
        status, report_data = get_sample_status(sample_dir)
        if status == "failed":
            stats["failed"] += 1
            if not include_failed:
                print(f"  Skip {topic}/{subtopic}/{domain_name}: FAILED")
                continue
        elif status == "passed":
            stats["passed"] += 1

        # Получаем метаданные темы
        theme_info = get_theme_info(sample_dir)

        # Создаём выходную структуру
        out_dir = dest_dir / topic / subtopic / domain_name
        out_dir.mkdir(parents=True, exist_ok=True)

        # Копируем файлы с коротким именем
        domain_src = sample_dir / "themed_domain.pddl"
        problem_src = sample_dir / "themed_problem.pddl"

        domain_dst = out_dir / f"{domain_name}_domain.pddl"
        problem_dst = out_dir / f"{domain_name}_problem.pddl"

        shutil.copy2(domain_src, domain_dst)
        shutil.copy2(problem_src, problem_dst)

        # Создаём sample.json
        sample_json = {
            "id": f"{topic}__{subtopic}__{domain_name}",
            "section": topic,
            "subsection": subtopic,
            "domain_path": domain_dst.name,
            "problem_path": problem_dst.name,
        }

        # Добавляем метаданные если есть
        if theme_info.get("title"):
            sample_json["title"] = theme_info["title"]
        if theme_info.get("description"):
            sample_json["description"] = theme_info["description"]
        if report_data.get("assumptions"):
            sample_json["assumptions"] = report_data["assumptions"]
        if report_data.get("risks"):
            sample_json["risks"] = report_data["risks"]

        (out_dir / "sample.json").write_text(
            json.dumps(sample_json, indent=2, ensure_ascii=False),
            encoding="utf-8"
        )

        stats["converted"] += 1
        print(f"  {topic}/{subtopic}/{domain_name}: OK")

    print(f"\n=== Summary ===")
    print(f"Total found: {len(samples)}")
    print(f"Passed: {stats['passed']}")
    print(f"Failed: {stats['failed']}")
    print(f"Converted: {stats['converted']}")
    print(f"Output: {dest_dir}")


def main():
    parser = argparse.ArgumentParser(description="Convert batch samples to benchmark format")
    parser.add_argument(
        "--source",
        type=Path,
        required=True,
        help="Source batch directory (e.g., batch_20260311T092814Z_d1e87f0d)"
    )
    parser.add_argument(
        "--dest",
        type=Path,
        required=True,
        help="Destination directory (e.g., data/batch_samples)"
    )
    parser.add_argument(
        "--include-failed",
        action="store_true",
        help="Include failed samples (default: skip them)"
    )
    args = parser.parse_args()

    convert_samples(
        source_dir=args.source,
        dest_dir=args.dest,
        include_failed=args.include_failed,
    )


if __name__ == "__main__":
    main()

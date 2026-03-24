#!/usr/bin/env python3
"""
Подготавливает данные AutoPlanBench в папке датасета системы прогонов:
1) Генерирует domain_description_seedN.json (PDDL->NL для домена) через run_domain_setup.py
   по каждому section_key из sample id / domain_nl_path: сохраняет в
   data/<section>/<subsection>/.../domain_description_seedN.json и прописывает
   domain_nl_path в sample.json соответствующих сэмплов.
2) Для каждого сэмпла генерирует domain_and_problem_nl.txt (run_save_descriptions --type full)
   рядом с sample.json.

Все файлы создаются только в каталоге датасета (--dataset-dir), не в папках autoplanbench.

Требуется: AUTOPLANBENCH_ROOT, OPENROUTER_API_KEY или OPENAI_API_KEY.
"""
import argparse
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))
from autoplanbench_utils import (  # noqa: E402
  apb_debug_inherit_stdio,
  apb_subprocess_stdio_kwargs,
  ensure_domain_json,
)
from translator_settings import (  # noqa: E402
  get_domain_setup_llm,
  get_pddl2nl_timeout_seconds,
  reload_translator_config,
)
from dataset_contracts import (  # noqa: E402
  derive_section_key,
  extract_sample_coords,
  iter_dataset_samples,
  normalize_dataset_dir,
)


def iter_sections_and_samples(dataset_dir: Path):
  """Сканирует датасет: (section_key, sample_dir, sample_dict)."""
  for sample_path in iter_dataset_samples(dataset_dir):
    sample_dir = sample_path.parent
    try:
      data = json.loads(sample_path.read_text(encoding="utf-8"))
    except Exception:
      continue
    example_id = str(data.get("id") or "")
    section, subsection, sample_index = extract_sample_coords(data, example_id)
    section_key = derive_section_key(
      data,
      section=section,
      subsection=subsection,
      sample_index=sample_index,
    )
    yield section_key, sample_dir, data


def write_domain_and_problem_nl(sample_dir: Path, domain_nl_json: Path, domain_pddl: Path, problem_pddl: Path,
                                apb_root: Path, out_file: Path, timeout_seconds: int) -> None:
  """Вызывает run_save_descriptions.py --type full и сохраняет результат в out_file."""
  script = apb_root / "utils" / "run_save_descriptions.py"
  if not script.exists():
    raise FileNotFoundError(script)
  cmd = [
    sys.executable, str(script),
    "--type", "full",
    "--d-nl", str(domain_nl_json),
    "-d", str(domain_pddl),
    "--prob", str(problem_pddl),
    "--out", str(out_file),
  ]
  result = subprocess.run(
    cmd,
    cwd=str(apb_root),
    timeout=max(1, int(timeout_seconds)),
    **apb_subprocess_stdio_kwargs(),
  )
  if result.returncode != 0:
    tail = (
      "(вывод в консоли; SEMBENCH_DEBUG)"
      if apb_debug_inherit_stdio()
      else (result.stderr or result.stdout or "")
    )
    raise RuntimeError(f"run_save_descriptions failed: {tail}")


def main():
  parser = argparse.ArgumentParser(description=__doc__)
  parser.add_argument("--dataset-dir", type=Path, default=ROOT / "data",
                      help="Корень датасета (все файлы сохраняются здесь)")
  parser.add_argument("--autoplanbench-root", type=Path, default=None,
                      help="Корень autoplanbench (по умолчанию AUTOPLANBENCH_ROOT)")
  parser.add_argument(
    "--translator-config",
    type=Path,
    default=None,
    help="YAML параметров переводчика (см. translator_config.yaml / SEMBENCH_TRANSLATOR_CONFIG).",
  )
  parser.add_argument(
    "--llm",
    type=str,
    default=None,
    help=(
      "Модель для PDDL->NL домена (run_domain_setup). "
      "Если не задано: domain_setup.llm из translator_config.yaml."
    ),
  )
  parser.add_argument("--seed", type=int, default=0, help="Seed для domain_description_seedN.json")
  parser.add_argument("--skip-nl-files", action="store_true",
                      help="Только domain_description JSON, не генерировать domain_and_problem_nl.txt по сэмплам")
  parser.add_argument(
    "--pddl2nl-timeout-seconds",
    type=int,
    default=None,
    help=(
      "Таймаут run_save_descriptions.py на один сэмпл (секунды). "
      "Если не задано: pddl2nl_sample.timeout_seconds из translator_config.yaml."
    ),
  )
  args = parser.parse_args()

  if args.translator_config is not None:
    p = Path(args.translator_config).expanduser()
    if not p.is_file():
      raise SystemExit(f"--translator-config must be an existing file: {p}")
    os.environ["SEMBENCH_TRANSLATOR_CONFIG"] = str(p.resolve())
    reload_translator_config()

  llm = args.llm or get_domain_setup_llm()
  pddl2nl_timeout = (
    args.pddl2nl_timeout_seconds
    if args.pddl2nl_timeout_seconds is not None
    else get_pddl2nl_timeout_seconds()
  )

  apb_root = args.autoplanbench_root or Path(os.environ.get("AUTOPLANBENCH_ROOT", ""))
  if not apb_root.is_dir():
    raise SystemExit("AUTOPLANBENCH_ROOT or --autoplanbench-root must point to autoplanbench repo")

  dataset_dir = normalize_dataset_dir(args.dataset_dir.resolve())
  if not dataset_dir.is_dir():
    raise SystemExit(f"Dataset dir not found: {dataset_dir}")
  if dataset_dir != args.dataset_dir.resolve():
    print(f"[prepare] Using normalized dataset root: {dataset_dir}", flush=True)

  by_section_key = {}
  for section_key, sample_dir, sample in iter_sections_and_samples(dataset_dir):
    if not section_key:
      continue
    by_section_key.setdefault(section_key, []).append((sample_dir, sample))

  for section_key, items in by_section_key.items():
    if not items:
      continue
    first_dir, first_sample = items[0]
    domain_path = first_sample.get("domain_path")
    problem_path = first_sample.get("problem_path")
    if not domain_path or not problem_path:
      continue
    domain_pddl = first_dir / domain_path
    problem_pddl = first_dir / problem_path
    if not domain_pddl.exists() or not problem_pddl.exists():
      continue

    json_path = dataset_dir / section_key / f"domain_description_seed{args.seed}.json"
    if not json_path.exists():
      ensure_domain_json(
        dataset_dir, section_key, domain_pddl, problem_pddl,
        apb_root, llm, args.seed,
      )
    rel_json = json_path.relative_to(dataset_dir).as_posix()
    for sp_dir, _ in items:
      sp_path = sp_dir / "sample.json"
      if not sp_path.exists():
        continue
      data = json.loads(sp_path.read_text(encoding="utf-8"))
      if data.get("domain_nl_path") != rel_json:
        data["domain_nl_path"] = rel_json
        sp_path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")

    if not args.skip_nl_files:
      for sample_dir, sample in items:
        dp, pp = sample.get("domain_path"), sample.get("problem_path")
        if not dp or not pp:
          continue
        d_pddl = sample_dir / dp
        p_pddl = sample_dir / pp
        if not d_pddl.exists() or not p_pddl.exists():
          continue
        nl_file = sample_dir / "domain_and_problem_nl.txt"
        if nl_file.exists():
          continue
        print(f"[prepare] NL for {section_key}/{sample_dir.name}...", flush=True)
        try:
          write_domain_and_problem_nl(
            sample_dir,
            json_path,
            d_pddl,
            p_pddl,
            apb_root,
            nl_file,
            pddl2nl_timeout,
          )
        except Exception as e:
          print(f"[prepare] Skip {sample_dir}: {e}", flush=True)

  print("[prepare] Done.", flush=True)


if __name__ == "__main__":
  main()

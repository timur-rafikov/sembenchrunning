"""
Обёртка для вызова AutoPlanBench run_save_descriptions.py (PDDL->NL) из системы прогона.
Использование: --prompt-translator translators.autoplanbench_pddl2nl:pddl_to_nl_prompt

Происхождение domain_nl_path:
  Файл domain_description_seedN.json — результат шага PDDL->NL для домена в AutoPlanBench
  (run_domain_setup.py). Его можно получить двумя способами:
  1) Заранее: scripts/prepare_autoplanbench_data.py — генерирует JSON по разделам и
     проставляет domain_nl_path в sample.json.
  2) При прогоне: если задан AUTOPLANBENCH_ROOT (или --autoplanbench-root), run_benchmark
     при отсутствии domain_nl_path или файла автоматически вызывает run_domain_setup.py
     и обновляет sample.json.

Требования:
- AUTOPLANBENCH_ROOT — путь к корню autoplanbench (для вызова run_save_descriptions.py).
- В sample.json должен быть domain_nl_path (путь к domain_description_seedN.json относительно
  корня датасета) или он будет создан автоматически (prepare или run_benchmark с --autoplanbench-root).
"""
import os
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Optional


def pddl_to_nl_prompt(
  domain_pddl: str,  # NOTE: content is intentionally unused — run_save_descriptions reads from domain_path
  problem_pddl: str,  # NOTE: content is intentionally unused — run_save_descriptions reads from problem_path
  *,
  domain_path: Optional[str] = None,
  problem_path: Optional[str] = None,
  domain_nl_path: Optional[str] = None,
  sample: Optional[dict] = None,
) -> str:
  """
  Переводит домен и задачу (PDDL) в NL, вызывая utils/run_save_descriptions.py --type full.
  Пути domain_path, problem_path, domain_nl_path передаёт система прогона (из датасета).

  ВНИМАНИЕ: аргументы domain_pddl и problem_pddl принимаются для совместимости с контрактом
  prompt_translator, но НЕ используются — скрипт AutoPlanBench читает содержимое файлов по
  переданным путям. Если содержимое файлов расходится со строками в domain_pddl/problem_pddl,
  используется версия из файлов на диске.
  """
  root = os.environ.get("AUTOPLANBENCH_ROOT")
  if not root:
    raise RuntimeError(
      "AUTOPLANBENCH_ROOT не задан. Укажите путь к корню репозитория autoplanbench."
    )
  if not domain_path or not problem_path or not domain_nl_path:
    raise ValueError(
      "Для AutoPlanBench PDDL->NL нужны domain_path, problem_path и domain_nl_path "
      "(в sample.json задайте domain_nl_path — путь к domain_description_seedN.json)."
    )

  # Validate that all referenced files actually exist before spawning the subprocess.
  for label, fpath in (
    ("domain_path", domain_path),
    ("problem_path", problem_path),
    ("domain_nl_path", domain_nl_path),
  ):
    if not Path(fpath).exists():
      raise FileNotFoundError(
        f"pddl_to_nl_prompt: файл не найден ({label}={fpath!r}). "
        "Убедитесь, что domain_nl_path в sample.json указывает на существующий "
        "domain_description_seedN.json."
      )

  script = Path(root) / "utils" / "run_save_descriptions.py"
  if not script.exists():
    raise FileNotFoundError(f"Скрипт не найден: {script}")

  timeout_s = int(os.environ.get("AUTOPLANBENCH_PDDL2NL_TIMEOUT", "600"))

  with tempfile.NamedTemporaryFile(
    mode="w", suffix=".txt", delete=False, encoding="utf-8"
  ) as f_out:
    out_file = f_out.name
  try:
    cmd = [
      sys.executable,
      str(script),
      "--type", "full",
      "--d-nl", str(domain_nl_path),
      "-d", str(domain_path),
      "--prob", str(problem_path),
      "--out", out_file,
    ]
    result = subprocess.run(
      cmd,
      cwd=root,
      capture_output=True,
      text=True,
      timeout=timeout_s,
      encoding="utf-8",
    )
    if result.returncode != 0:
      raise RuntimeError(
        f"run_save_descriptions.py завершился с кодом {result.returncode}: {result.stderr or result.stdout}"
      )
    return Path(out_file).read_text(encoding="utf-8").strip()
  finally:
    Path(out_file).unlink(missing_ok=True)

"""
Обёртка для вызова AutoPlanBench run_translate_nl2pddl.py из системы прогона метрик.
Использование: --translator translators.autoplanbench_nl2pddl:nl_to_pddl

Происхождение domain_nl_path:
  domain_description_seedN.json появляется после перевода PDDL->NL для домена (run_domain_setup.py
  в AutoPlanBench). Сначала выполняется domain setup, получается этот JSON; затем он используется
  и для построения промптов (PDDL->NL), и для перевода NL-плана в PDDL.

Требования:
- AUTOPLANBENCH_ROOT — путь к корню autoplanbench.
- В sample.json задать domain_nl_path (путь к domain_description_seedN.json). Файл получают
  запуском run_domain_setup.py (шаг PDDL->NL по домену).
- Опционально: AUTOPLANBENCH_PROMPT_FILE, AUTOPLANBENCH_EXAMPLES_FILE, OPENROUTER_API_KEY.
- Базовые значения модели/токенов/parallel/timeout: translator_config.yaml (см. translator_settings.py);
  переменные окружения переопределяют YAML.
- Логи APB в консоль: SEMBENCH_DEBUG=1 или run_benchmark --debug (stdout/stderr субпроцесса не перехватываются).
"""
import os
import json
import time
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Any, Dict, Optional

from autoplanbench_utils import apb_debug_inherit_stdio, apb_subprocess_stdio_kwargs
from translator_settings import (
  DEFAULT_NL2PDDL_MAX_TOKENS,
  DEFAULT_NL2PDDL_MODEL,
  DEFAULT_NL2PDDL_TIMEOUT_S,
  effective_nl2pddl_parallel,
  get_nl2pddl_examples_file_override,
  get_nl2pddl_max_tokens,
  get_nl2pddl_model_path,
  get_nl2pddl_openrouter_parallel_timeout_seconds,
  get_nl2pddl_prompt_file_override,
  get_nl2pddl_timeout_seconds,
)

# Emitted by autoplanbench utils/run_translate_nl2pddl.py as a single stdout line.
_NL2PDDL_USAGE_PREFIX = "AUTOPLANBENCH_NL2PDDL_USAGE:"

# Обратная совместимость импортов из этого модуля
_DEFAULT_NL2PDDL_MODEL = DEFAULT_NL2PDDL_MODEL
_DEFAULT_NL2PDDL_MAX_TOKENS = DEFAULT_NL2PDDL_MAX_TOKENS
_DEFAULT_NL2PDDL_TIMEOUT_S = DEFAULT_NL2PDDL_TIMEOUT_S


def _parse_nl2pddl_usage_from_stdout(stdout: str) -> Optional[Dict[str, Any]]:
  if not stdout:
    return None
  for raw in stdout.splitlines():
    line = raw.strip()
    if line.startswith(_NL2PDDL_USAGE_PREFIX):
      try:
        return json.loads(line[len(_NL2PDDL_USAGE_PREFIX) :])
      except json.JSONDecodeError:
        continue
  return None


def nl_to_pddl(
  nl_plan: str,
  *,
  domain_path: Optional[str] = None,
  problem_path: Optional[str] = None,
  domain_nl_path: Optional[str] = None,
  debug_path: Optional[str] = None,
) -> str:
  """
  Переводит NL-план в PDDL, вызывая utils/run_translate_nl2pddl.py из AutoPlanBench.
  Пути domain_path, problem_path, domain_nl_path передаёт система прогона (из датасета).
  """
  root = os.environ.get("AUTOPLANBENCH_ROOT")
  if not root:
    raise RuntimeError(
      "AUTOPLANBENCH_ROOT не задан. Укажите путь к корню репозитория autoplanbench."
    )
  if not domain_path or not problem_path or not domain_nl_path:
    raise ValueError(
      "Для AutoPlanBench нужны domain_path, problem_path и domain_nl_path "
      "(в sample.json задайте domain_nl_path — путь к domain_description_seedN.json)."
    )

  script = Path(root) / "utils" / "run_translate_nl2pddl.py"
  if not script.exists():
    raise FileNotFoundError(f"Скрипт не найден: {script}")

  root_path = Path(root)
  default_prompt = root_path / "llm_planning" / "prompt_templates" / "translation_template.txt"
  prompt_override = get_nl2pddl_prompt_file_override()
  prompt_file_path = prompt_override if prompt_override else str(default_prompt)
  if not Path(prompt_file_path).exists():
    raise FileNotFoundError(f"Шаблон перевода не найден: {prompt_file_path}")
  model_path = get_nl2pddl_model_path()
  max_tokens = get_nl2pddl_max_tokens()
  timeout_s = get_nl2pddl_timeout_seconds()
  parallel_n = effective_nl2pddl_parallel()

  with tempfile.NamedTemporaryFile(
    mode="w", suffix=".txt", delete=False, encoding="utf-8"
  ) as f_plan:
    f_plan.write(nl_plan)
    plan_file = f_plan.name
  try:
    with tempfile.NamedTemporaryFile(
      mode="w", suffix=".txt", delete=False, encoding="utf-8"
    ) as f_out:
      out_file = f_out.name
    try:
      cmd = [
        sys.executable,
        str(script),
        "--domain-nl", str(domain_nl_path),
        "--domain", str(domain_path),
        "--instance", str(problem_path),
        "--plan-file", plan_file,
        "--out", out_file,
        "--model-path", model_path,
        "--max-tokens", str(max_tokens),
        "--prompt-file", str(prompt_file_path),
        "--parallel",
        str(parallel_n),
      ]
      examples_file = get_nl2pddl_examples_file_override()
      if examples_file:
        cmd.extend(["--examples-file", examples_file])
      if apb_debug_inherit_stdio() or os.environ.get("SEMBENCH_LOG_NL2PDDL_CMD", "").strip().lower() in (
        "1",
        "true",
        "yes",
      ):
        print(
          f"[sembenchrunning] NL2PDDL subprocess parallel={parallel_n} (APB parallel HTTP if parallel>1): "
          f"{' '.join(cmd[2:])}",
          flush=True,
        )
      started = time.time()
      result = None
      err: Optional[BaseException] = None
      try:
        stdio_kw = apb_subprocess_stdio_kwargs()
        sub_env = os.environ.copy()
        sub_env["OPENROUTER_PARALLEL_HTTP_TIMEOUT_S"] = str(
          get_nl2pddl_openrouter_parallel_timeout_seconds()
        )
        result = subprocess.run(
          cmd,
          cwd=root,
          timeout=timeout_s,
          env=sub_env,
          **stdio_kw,
        )
        if result.returncode != 0:
          tail = (
            "(вывод AutoPlanBench в консоли; SEMBENCH_DEBUG)"
            if apb_debug_inherit_stdio()
            else (result.stderr or result.stdout or "")
          )
          raise RuntimeError(
            f"run_translate_nl2pddl.py завершился с кодом {result.returncode}: {tail}"
          )
        out_text = Path(out_file).read_text(encoding="utf-8").strip()
        return out_text
      except BaseException as e:
        err = e
        raise
      finally:
        if debug_path:
          try:
            raw_out = getattr(result, "stdout", None)
            out_stdout = (raw_out or "") if raw_out is not None else ""
            usage_parsed = _parse_nl2pddl_usage_from_stdout(out_stdout)
            raw_err = getattr(result, "stderr", None)
            err_tail = (raw_err or "") if raw_err is not None else ""
            payload = {
              "tool": "autoplanbench_nl2pddl",
              "cwd": str(root),
              "timeout_s": timeout_s,
              "parallel": parallel_n,
              "elapsed_s": round(time.time() - started, 3),
              "cmd": cmd,
              "model_path": model_path,
              "max_tokens": max_tokens,
              "prompt_file": str(prompt_file_path),
              "examples_file": examples_file,
              "returncode": getattr(result, "returncode", None),
              "stdio_inherited": bool(apb_debug_inherit_stdio()),
              "stdout": out_stdout[:20000],
              "stderr": err_tail[:20000],
              "openrouter_usage": usage_parsed,
              "exception": None if err is None else {
                "type": type(err).__name__,
                "message": str(err),
              },
            }
            Path(debug_path).write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
          except Exception:
            pass
    finally:
      Path(out_file).unlink(missing_ok=True)
  finally:
    Path(plan_file).unlink(missing_ok=True)

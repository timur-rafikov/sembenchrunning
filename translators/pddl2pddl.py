"""
Режим PDDL→PDDL: промпт строится из сырого domain/problem PDDL, ответ модели трактуется как PDDL-план.

Использование (через run_benchmark --pddl2pddl или вручную):
  --prompt-translator translators.pddl2pddl:pddl_prompt_body
  --translator translators.pddl2pddl:response_as_plan_pddl

AutoPlanBench и domain_nl_path для этого режима не нужны.
"""
from __future__ import annotations

import re
from typing import Any, Optional

# Строки для argparse / метаданных (единый источник правды с run_benchmark).
PDDL2PDDL_PROMPT_TRANSLATOR_SPEC = "translators.pddl2pddl:pddl_prompt_body"
PDDL2PDDL_METRICS_TRANSLATOR_SPEC = "translators.pddl2pddl:response_as_plan_pddl"


def is_pddl2pddl_prompt_spec(spec: str) -> bool:
  return (spec or "").strip() == PDDL2PDDL_PROMPT_TRANSLATOR_SPEC


def is_pddl2pddl_translator_spec(spec: Optional[str]) -> bool:
  return (spec or "").strip() == PDDL2PDDL_METRICS_TRANSLATOR_SPEC


def pddl_prompt_body(
  domain_pddl: str,
  problem_pddl: str,
  *,
  domain_path: Optional[str] = None,
  problem_path: Optional[str] = None,
  domain_nl_path: Optional[str] = None,
  sample: Optional[dict] = None,
  **kwargs: Any,
) -> str:
  """
  Тело промпта без NL: два блока PDDL с явными заголовками (как контекст для LLM).
  Лишние аргументы игнорируются — совместимость с вызовом _get_domain_problem_nl.
  """
  _ = (domain_path, problem_path, domain_nl_path, sample, kwargs)
  d = (domain_pddl or "").strip()
  p = (problem_pddl or "").strip()
  return (
    "## Planning domain (PDDL)\n\n"
    f"{d}\n\n"
    "## Planning problem (PDDL)\n\n"
    f"{p}\n"
  )


_FENCE_PDDL = re.compile(
  r"```\s*pddl\s*\r?\n(.*?)```",
  re.DOTALL | re.IGNORECASE,
)
_FENCE_GENERIC = re.compile(
  r"```(?:[^\n`]*)\r?\n(.*?)```",
  re.DOTALL,
)
# Matches at least one PDDL-style action line: opening paren + identifier.
_PDDL_ACTION_LINE_RE = re.compile(r"^\s*\(\s*[A-Za-z_][\w-]*", re.MULTILINE)


def response_as_plan_pddl(
  model_output: str,
  *,
  domain_path: Optional[str] = None,
  problem_path: Optional[str] = None,
  domain_nl_path: Optional[str] = None,
  debug_path: Optional[str] = None,
  **kwargs: Any,
) -> str:
  """
  «Переводчик» для метрик: ответ модели уже должен быть планом в PDDL.
  Снимает типичные markdown-обёртки; без вызовов AutoPlanBench.

  Приоритет извлечения:
  1. Первый ```pddl ... ``` блок.
  2. Первый generic-fence, чьё содержимое выглядит как PDDL (содержит строки вида «(action …)»).
  3. Полный текст ответа как есть (VAL разберётся с нестандартным форматом).
  """
  _ = (domain_path, problem_path, domain_nl_path, debug_path, kwargs)
  if model_output is None:
    return ""
  s = str(model_output).strip()
  if not s:
    return ""

  m = _FENCE_PDDL.search(s)
  if m:
    return m.group(1).strip()

  # Try each generic fence in order; only accept one that looks like a PDDL plan.
  for m in _FENCE_GENERIC.finditer(s):
    inner = m.group(1).strip()
    if inner and _PDDL_ACTION_LINE_RE.search(inner):
      return inner

  return s.strip()

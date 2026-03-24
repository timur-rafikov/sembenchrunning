"""
Параметры переводчика AutoPlanBench: translator_config.yaml + переменные окружения.

Приоритет значений: os.environ (если задано непустое) > YAML > константы DEFAULT_* ниже.

Переменные окружения (как раньше):
  domain_setup:  AUTOPLANBENCH_DOMAIN_SETUP_TIMEOUT, AUTOPLANBENCH_DOMAIN_SETUP_PARALLEL,
                 AUTOPLANBENCH_DOMAIN_SETUP_OPENROUTER_HTTP_TIMEOUT_S
  nl2pddl:       AUTOPLANBENCH_NL2PDDL_MODEL, AUTOPLANBENCH_NL2PDDL_MAX_TOKENS,
                 AUTOPLANBENCH_NL2PDDL_PARALLEL, AUTOPLANBENCH_NL2PDDL_TIMEOUT,
                 AUTOPLANBENCH_NL2PDDL_OPENROUTER_HTTP_TIMEOUT_S,
                 AUTOPLANBENCH_PROMPT_FILE, AUTOPLANBENCH_EXAMPLES_FILE
  pddl2nl_sample: AUTOPLANBENCH_PDDL2NL_TIMEOUT

Путь к YAML: SEMBENCH_TRANSLATOR_CONFIG или translator_config.yaml рядом с этим модулем.
"""
from __future__ import annotations

import os
from pathlib import Path
from typing import Any, Dict, Optional, Tuple

try:
  import yaml
except ImportError:  # pragma: no cover
  yaml = None

ENV_TRANSLATOR_CONFIG_PATH = "SEMBENCH_TRANSLATOR_CONFIG"

# Встроенные дефолты (если нет ни env, ни ключа в YAML)
DEFAULT_DOMAIN_SETUP_LLM = "openai/gpt-5-mini"
DEFAULT_DOMAIN_SETUP_MAX_TOKENS = 10000
DEFAULT_DOMAIN_SETUP_PARALLEL = 80
DEFAULT_DOMAIN_SETUP_TIMEOUT_S = 600

DEFAULT_NL2PDDL_MODEL = "openai/gpt-5-mini"
DEFAULT_NL2PDDL_MAX_TOKENS = 10000
DEFAULT_NL2PDDL_PARALLEL = 80
DEFAULT_NL2PDDL_TIMEOUT_S = 1200

DEFAULT_PDDL2NL_TIMEOUT_S = 1200

# Таймаут чтения одного HTTP-ответа OpenRouter в APB parallel_http_openrouter (секунды).
DEFAULT_OPENROUTER_PARALLEL_HTTP_TIMEOUT_S = 120

_CACHED_RAW: Optional[Dict[str, Any]] = None
_CACHED_RESOLVED_PATH: Optional[Path] = None
# (mtime_ns, size) при последней загрузке — надёжнее одного mtime на Windows/быстрых записях
_CACHED_FILE_STAT_KEY: Optional[Tuple[int, int]] = None


def default_translator_config_path() -> Path:
  return Path(__file__).resolve().parent / "translator_config.yaml"


def translator_config_path() -> Path:
  env = os.environ.get(ENV_TRANSLATOR_CONFIG_PATH, "").strip()
  if env:
    return Path(env).expanduser()
  return default_translator_config_path()


def reload_translator_config() -> None:
  """Сброс кэша YAML (после смены SEMBENCH_TRANSLATOR_CONFIG или файла на диске)."""
  global _CACHED_RAW, _CACHED_RESOLVED_PATH, _CACHED_FILE_STAT_KEY
  _CACHED_RAW = None
  _CACHED_RESOLVED_PATH = None
  _CACHED_FILE_STAT_KEY = None


def _load_yaml_dict(path: Path) -> Dict[str, Any]:
  if yaml is None:
    raise RuntimeError("PyYAML is required to read translator_config.yaml")
  if not path.is_file():
    return {}
  with path.open(encoding="utf-8") as f:
    data = yaml.safe_load(f)
  return data if isinstance(data, dict) else {}


def _config_file_stat_key(path: Path) -> Tuple[int, int]:
  """
  Ключ инвалидации кэша: (mtime_ns, size).
  Размер учитываем: на части ФС mtime не меняется между двумя быстрыми записями.
  """
  if not path.is_file():
    return (-1, -1)
  try:
    st = path.stat()
    return (int(st.st_mtime_ns), int(st.st_size))
  except OSError:
    return (-2, -2)


def _file_config() -> Dict[str, Any]:
  global _CACHED_RAW, _CACHED_RESOLVED_PATH, _CACHED_FILE_STAT_KEY
  path = translator_config_path()
  stat_key = _config_file_stat_key(path)
  if (
    _CACHED_RAW is not None
    and _CACHED_RESOLVED_PATH == path
    and _CACHED_FILE_STAT_KEY == stat_key
  ):
    return _CACHED_RAW
  _CACHED_RAW = _load_yaml_dict(path)
  _CACHED_RESOLVED_PATH = path
  _CACHED_FILE_STAT_KEY = stat_key
  return _CACHED_RAW


def _deep_get(cfg: Dict[str, Any], *keys: str) -> Any:
  cur: Any = cfg
  for k in keys:
    if not isinstance(cur, dict):
      return None
    cur = cur.get(k)
  return cur


def _is_yaml_null(v: Any) -> bool:
  if v is None:
    return True
  if isinstance(v, str) and v.strip().lower() in ("", "null", "none", "~"):
    return True
  return False


def _env_or_file_int(
  env_key: str,
  yaml_section: Tuple[str, ...],
  yaml_field: str,
  default: int,
) -> int:
  raw_env = os.environ.get(env_key)
  if raw_env is not None and str(raw_env).strip() != "":
    try:
      return int(raw_env)
    except ValueError:
      pass
  cfg = _file_config()
  v = _deep_get(cfg, *(yaml_section + (yaml_field,)))
  if v is not None and not _is_yaml_null(v):
    try:
      return int(v)
    except (TypeError, ValueError):
      pass
  return default


def _env_or_file_str(
  env_key: str,
  yaml_section: Tuple[str, ...],
  yaml_field: str,
  default: str,
) -> str:
  raw_env = os.environ.get(env_key)
  if raw_env is not None and str(raw_env).strip() != "":
    return str(raw_env)
  cfg = _file_config()
  v = _deep_get(cfg, *(yaml_section + (yaml_field,)))
  if v is not None and not _is_yaml_null(v):
    return str(v)
  return default


def get_domain_setup_llm() -> str:
  """Модель для run_domain_setup.py --llm (OpenRouter id)."""
  return _env_or_file_str(
    "AUTOPLANBENCH_DOMAIN_SETUP_LLM",
    ("domain_setup",),
    "llm",
    DEFAULT_DOMAIN_SETUP_LLM,
  )


def get_domain_setup_max_tokens() -> int:
  return _env_or_file_int(
    "AUTOPLANBENCH_DOMAIN_SETUP_MAX_TOKENS",
    ("domain_setup",),
    "max_tokens",
    DEFAULT_DOMAIN_SETUP_MAX_TOKENS,
  )


def effective_domain_setup_parallel() -> int:
  """
  Значение для run_domain_setup.py --parallel.
  Env: AUTOPLANBENCH_DOMAIN_SETUP_PARALLEL; YAML: domain_setup.parallel.
  """
  n = _env_or_file_int(
    "AUTOPLANBENCH_DOMAIN_SETUP_PARALLEL",
    ("domain_setup",),
    "parallel",
    DEFAULT_DOMAIN_SETUP_PARALLEL,
  )
  if n <= 0:
    n = DEFAULT_DOMAIN_SETUP_PARALLEL
  return n


def get_domain_setup_timeout_seconds() -> int:
  return max(
    1,
    _env_or_file_int(
      "AUTOPLANBENCH_DOMAIN_SETUP_TIMEOUT",
      ("domain_setup",),
      "timeout_seconds",
      DEFAULT_DOMAIN_SETUP_TIMEOUT_S,
    ),
  )


def get_domain_setup_openrouter_parallel_timeout_seconds() -> int:
  """
  Таймаут urllib при параллельных запросах к OpenRouter в run_domain_setup (APB).
  Пробрасывается в субпроцесс как OPENROUTER_PARALLEL_HTTP_TIMEOUT_S.
  """
  return max(
    30,
    _env_or_file_int(
      "AUTOPLANBENCH_DOMAIN_SETUP_OPENROUTER_HTTP_TIMEOUT_S",
      ("domain_setup",),
      "openrouter_parallel_timeout_seconds",
      DEFAULT_OPENROUTER_PARALLEL_HTTP_TIMEOUT_S,
    ),
  )


def get_nl2pddl_model_path() -> str:
  return _env_or_file_str(
    "AUTOPLANBENCH_NL2PDDL_MODEL",
    ("nl2pddl",),
    "model_path",
    DEFAULT_NL2PDDL_MODEL,
  )


def get_nl2pddl_max_tokens() -> int:
  return _env_or_file_int(
    "AUTOPLANBENCH_NL2PDDL_MAX_TOKENS",
    ("nl2pddl",),
    "max_tokens",
    DEFAULT_NL2PDDL_MAX_TOKENS,
  )


def effective_nl2pddl_parallel() -> int:
  """
  Значение для run_translate_nl2pddl.py --parallel.
  Env: AUTOPLANBENCH_NL2PDDL_PARALLEL; YAML: nl2pddl.parallel.
  """
  n = _env_or_file_int(
    "AUTOPLANBENCH_NL2PDDL_PARALLEL",
    ("nl2pddl",),
    "parallel",
    DEFAULT_NL2PDDL_PARALLEL,
  )
  if n <= 0:
    n = DEFAULT_NL2PDDL_PARALLEL
  return n


def get_nl2pddl_timeout_seconds() -> int:
  return max(
    1,
    _env_or_file_int(
      "AUTOPLANBENCH_NL2PDDL_TIMEOUT",
      ("nl2pddl",),
      "timeout_seconds",
      DEFAULT_NL2PDDL_TIMEOUT_S,
    ),
  )


def get_nl2pddl_openrouter_parallel_timeout_seconds() -> int:
  """
  То же для run_translate_nl2pddl.py при параллельных HTTP в APB.
  Пробрасывается в субпроцесс как OPENROUTER_PARALLEL_HTTP_TIMEOUT_S.
  """
  return max(
    30,
    _env_or_file_int(
      "AUTOPLANBENCH_NL2PDDL_OPENROUTER_HTTP_TIMEOUT_S",
      ("nl2pddl",),
      "openrouter_parallel_timeout_seconds",
      DEFAULT_OPENROUTER_PARALLEL_HTTP_TIMEOUT_S,
    ),
  )


def get_nl2pddl_prompt_file_override() -> Optional[str]:
  """
  Явный путь к translation_template (или None = дефолт внутри APB).
  Env: AUTOPLANBENCH_PROMPT_FILE; YAML: nl2pddl.prompt_file.
  """
  env_v = os.environ.get("AUTOPLANBENCH_PROMPT_FILE")
  if env_v is not None and str(env_v).strip() != "":
    return str(env_v)
  cfg = _file_config()
  v = _deep_get(cfg, "nl2pddl", "prompt_file")
  if _is_yaml_null(v):
    return None
  return str(v)


def get_nl2pddl_examples_file_override() -> Optional[str]:
  env_v = os.environ.get("AUTOPLANBENCH_EXAMPLES_FILE")
  if env_v is not None and str(env_v).strip() != "":
    return str(env_v)
  cfg = _file_config()
  v = _deep_get(cfg, "nl2pddl", "examples_file")
  if _is_yaml_null(v):
    return None
  return str(v)


def get_pddl2nl_timeout_seconds() -> int:
  return max(
    1,
    _env_or_file_int(
      "AUTOPLANBENCH_PDDL2NL_TIMEOUT",
      ("pddl2nl_sample",),
      "timeout_seconds",
      DEFAULT_PDDL2NL_TIMEOUT_S,
    ),
  )


def get_nl2pddl_subprocess_snapshot() -> Dict[str, Any]:
  """Снимок настроек для sembench_translator_meta / отладки (согласован с nl_to_pddl)."""
  snap: Dict[str, Any] = {
    "model_path": get_nl2pddl_model_path(),
    "max_tokens": get_nl2pddl_max_tokens(),
    "parallel": effective_nl2pddl_parallel(),
    "timeout_s": get_nl2pddl_timeout_seconds(),
    "openrouter_parallel_timeout_seconds": get_nl2pddl_openrouter_parallel_timeout_seconds(),
    "translator_config_path": str(translator_config_path()),
  }
  pf = get_nl2pddl_prompt_file_override()
  ef = get_nl2pddl_examples_file_override()
  if pf:
    snap["prompt_file_override"] = pf
  if ef:
    snap["examples_file_override"] = ef
  return snap


def get_domain_setup_subprocess_snapshot(
  *,
  override_llm: Optional[str] = None,
) -> Dict[str, Any]:
  """Снимок для манифеста / метаданных (что уходит в run_domain_setup)."""
  llm = (override_llm or "").strip() or get_domain_setup_llm()
  return {
    "llm": llm,
    "max_tokens": get_domain_setup_max_tokens(),
    "parallel": effective_domain_setup_parallel(),
    "timeout_seconds": get_domain_setup_timeout_seconds(),
    "openrouter_parallel_timeout_seconds": get_domain_setup_openrouter_parallel_timeout_seconds(),
    "translator_config_path": str(translator_config_path()),
  }


def list_translator_env_keys() -> Dict[str, str]:
  """Документация: какая переменная к какому параметру относится."""
  return {
    "SEMBENCH_TRANSLATOR_CONFIG": "Путь к YAML (опционально)",
    "AUTOPLANBENCH_DOMAIN_SETUP_LLM": "domain_setup.llm (опционально; иначе YAML/default)",
    "AUTOPLANBENCH_DOMAIN_SETUP_MAX_TOKENS": "domain_setup.max_tokens",
    "AUTOPLANBENCH_DOMAIN_SETUP_PARALLEL": "domain_setup.parallel",
    "AUTOPLANBENCH_DOMAIN_SETUP_TIMEOUT": "domain_setup.timeout_seconds",
    "AUTOPLANBENCH_DOMAIN_SETUP_OPENROUTER_HTTP_TIMEOUT_S": "domain_setup.openrouter_parallel_timeout_seconds",
    "AUTOPLANBENCH_NL2PDDL_MODEL": "nl2pddl.model_path",
    "AUTOPLANBENCH_NL2PDDL_MAX_TOKENS": "nl2pddl.max_tokens",
    "AUTOPLANBENCH_NL2PDDL_PARALLEL": "nl2pddl.parallel",
    "AUTOPLANBENCH_NL2PDDL_TIMEOUT": "nl2pddl.timeout_seconds",
    "AUTOPLANBENCH_NL2PDDL_OPENROUTER_HTTP_TIMEOUT_S": "nl2pddl.openrouter_parallel_timeout_seconds",
    "AUTOPLANBENCH_PROMPT_FILE": "nl2pddl.prompt_file",
    "AUTOPLANBENCH_EXAMPLES_FILE": "nl2pddl.examples_file",
    "AUTOPLANBENCH_PDDL2NL_TIMEOUT": "pddl2nl_sample.timeout_seconds",
  }

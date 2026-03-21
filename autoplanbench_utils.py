"""
Общие хелперы для интеграции с AutoPlanBench.
Используются prepare_autoplanbench_data.py и run_benchmark.py.
"""
import hashlib
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, Optional


def get_apb_root(apb_root: Optional[Path] = None) -> Optional[Path]:
  """Возвращает путь к корню autoplanbench: apb_root или AUTOPLANBENCH_ROOT."""
  if apb_root is not None and apb_root.is_dir():
    return Path(apb_root)
  env = os.environ.get("AUTOPLANBENCH_ROOT", "")
  if env:
    p = Path(env)
    if p.is_dir():
      return p
  return None


def _sha256_file(path: Path) -> str:
  h = hashlib.sha256()
  with path.open("rb") as f:
    while True:
      chunk = f.read(1024 * 1024)
      if not chunk:
        break
      h.update(chunk)
  return h.hexdigest()


def _domain_setup_manifest_path(section_dir: Path, seed: int) -> Path:
  return section_dir / f"domain_description_seed{seed}.manifest.json"


def _build_domain_setup_manifest(
  *,
  first_domain_pddl: Path,
  first_problem_pddl: Path,
  apb_root: Path,
  llm: str,
  seed: int,
) -> Dict[str, Any]:
  script_path = apb_root / "run_domain_setup.py"
  return {
    "version": 1,
    "seed": int(seed),
    "llm": llm,
    "domain_sha256": _sha256_file(first_domain_pddl),
    "problem_sha256": _sha256_file(first_problem_pddl),
    "apb_root": str(apb_root.resolve()),
    "run_domain_setup_mtime_ns": script_path.stat().st_mtime_ns if script_path.exists() else None,
  }


def _load_domain_setup_manifest(path: Path) -> Optional[Dict[str, Any]]:
  if not path.is_file():
    return None
  try:
    raw = json.loads(path.read_text(encoding="utf-8"))
  except Exception:
    return None
  return raw if isinstance(raw, dict) else None


def ensure_domain_json(
  dataset_dir: Path,
  section: str,
  first_domain_pddl: Path,
  first_problem_pddl: Path,
  apb_root: Path,
  llm: str,
  seed: int,
  log_prefix: str = "[prepare]",
) -> Path:
  """
  Создаёт data/<section>/domain_description_seedN.json, вызывая run_domain_setup.py.
  Использует временную папку _apb_setup внутри section. Если файл уже есть — возвращает путь,
  но пересобирает его при изменении входного домена/задачи, seed, llm или run_domain_setup.py.
  """
  section_dir = dataset_dir / section
  out_json = section_dir / f"domain_description_seed{seed}.json"
  manifest_path = _domain_setup_manifest_path(section_dir, seed)
  desired_manifest = _build_domain_setup_manifest(
    first_domain_pddl=first_domain_pddl,
    first_problem_pddl=first_problem_pddl,
    apb_root=apb_root,
    llm=llm,
    seed=seed,
  )
  current_manifest = _load_domain_setup_manifest(manifest_path)
  usage_path = section_dir / f"domain_llm_usage_seed{seed}.json"
  if out_json.exists() and usage_path.exists() and current_manifest == desired_manifest:
    return out_json

  setup_dir = section_dir / "_apb_setup"
  setup_dir.mkdir(parents=True, exist_ok=True)
  orig_dir = setup_dir / "orig_problems"
  orig_dir.mkdir(exist_ok=True)
  domain_dest = setup_dir / "domain.pddl"
  shutil.copy2(first_domain_pddl, domain_dest)
  shutil.copy2(first_problem_pddl, orig_dir / "problem_1.pddl")

  cmd = [
    sys.executable,
    str(apb_root / "run_domain_setup.py"),
    "-o", str(setup_dir.resolve()),
    "-d", str(domain_dest.resolve()),
    "-i", str(orig_dir.resolve()),
    "--llm", llm,
    "--seed", str(seed),
    "-n", "0",
  ]
  print(f"{log_prefix} Running domain setup for section {section!r}...", flush=True)
  result = subprocess.run(cmd, cwd=str(apb_root), capture_output=True, text=True, timeout=600, encoding="utf-8")
  if result.returncode != 0:
    print(f"{log_prefix} run_domain_setup failed: {result.stderr or result.stdout}", flush=True)
    raise RuntimeError(f"run_domain_setup.py exited with {result.returncode}")

  generated = setup_dir / f"domain_description_seed{seed}.json"
  if not generated.exists():
    raise FileNotFoundError(f"Expected {generated} after domain setup")
  shutil.copy2(generated, out_json)
  usage_name = f"domain_llm_usage_seed{seed}.json"
  usage_src = setup_dir / usage_name
  usage_dst = section_dir / usage_name
  if usage_src.is_file():
    shutil.copy2(usage_src, usage_dst)
    print(f"{log_prefix} Wrote {usage_dst}", flush=True)
  manifest_path.write_text(json.dumps(desired_manifest, ensure_ascii=False, indent=2), encoding="utf-8")
  print(f"{log_prefix} Wrote {out_json}", flush=True)
  return out_json

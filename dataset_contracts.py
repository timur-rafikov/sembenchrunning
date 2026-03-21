"""Shared dataset/id/path contracts for sembenchrunning."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Tuple, Union


def iter_dataset_samples(dataset_dir: Path) -> Iterable[Path]:
  """Yield all sample.json paths in deterministic order."""
  for path in sorted(dataset_dir.rglob("sample.json")):
    if path.is_file():
      yield path


def parse_example_id(example_id: str) -> Optional[Tuple[str, str, Optional[Union[int, str]]]]:
  """
  Parse ids like:
  - section__subsection
  - section__subsection__42
  - section__subsection__sample_name
  - section__sub__section__42          (subsection itself contains __)
  - section__sub__section__sample_name (same, non-numeric sample index)

  Convention: first part is always section, last part is sample_index when there are 3+
  parts, middle parts joined with '__' form the subsection.
  """
  if "__" not in example_id:
    return None
  parts = example_id.split("__")
  if len(parts) == 2:
    section, subsection = parts[0], parts[1]
    return (section, subsection, None) if section and subsection else None
  if len(parts) >= 3:
    section = parts[0]
    sample_index_str = parts[-1]
    subsection = "__".join(parts[1:-1])
    if not section or not subsection:
      return None
    if sample_index_str.isdigit():
      return (section, subsection, int(sample_index_str))
    return (section, subsection, sample_index_str)
  return None


def normalize_dataset_dir(dataset_dir: Path) -> Path:
  """
  Normalize dataset root so relative paths look like:
  <section>/<subsection>/.../sample.json
  """
  try:
    first_sample = next(iter_dataset_samples(dataset_dir))
  except StopIteration:
    return dataset_dir
  try:
    sample = json.loads(first_sample.read_text(encoding="utf-8"))
  except Exception:
    return dataset_dir
  parsed = parse_example_id(str(sample.get("id") or ""))
  section = str(sample.get("section") or (parsed[0] if parsed else "")).strip()
  subsection = str(sample.get("subsection") or (parsed[1] if parsed else "")).strip()
  if not section or not subsection:
    return dataset_dir
  sample_dir = first_sample.parent.resolve()
  dataset_dir = dataset_dir.resolve()
  candidates: List[Path] = []
  cur = sample_dir
  while True:
    try:
      cur.relative_to(dataset_dir)
      candidates.append(cur)
    except ValueError:
      break
    if cur == dataset_dir:
      break
    cur = cur.parent
  for candidate in reversed(candidates):
    try:
      rel_parts = sample_dir.relative_to(candidate).parts
    except ValueError:
      continue
    if len(rel_parts) >= 2 and rel_parts[0] == section and rel_parts[1] == subsection:
      return candidate
  return dataset_dir


def resolve_dataset_relative_path(dataset_dir: Path, raw_path: Optional[Union[str, Path]]) -> Optional[Path]:
  """Resolve a path from sample.json relative to dataset root, with suffix-match fallback."""
  if not raw_path:
    return None
  path = Path(str(raw_path))
  if path.is_absolute():
    return path if path.exists() else None
  direct = (dataset_dir / path).resolve()
  if direct.exists():
    return direct
  wanted = path.parts
  for candidate in dataset_dir.rglob(path.name):
    try:
      rel = candidate.relative_to(dataset_dir).parts
    except ValueError:
      continue
    if len(rel) >= len(wanted) and tuple(rel[-len(wanted):]) == wanted:
      return candidate.resolve()
  return None


def extract_sample_coords(sample: Dict[str, Any], example_id: str) -> Tuple[str, str, Optional[Union[int, str]]]:
  parsed = parse_example_id(example_id)
  section = str(sample.get("section") or (parsed[0] if parsed else "")).strip()
  subsection = str(sample.get("subsection") or (parsed[1] if parsed else "")).strip()
  sample_index = parsed[2] if parsed else None
  return section, subsection, sample_index


def derive_section_key(
  sample: Dict[str, Any],
  *,
  section: str,
  subsection: str,
  sample_index: Optional[Union[int, str]],
) -> str:
  rel_domain_nl = sample.get("domain_nl_path")
  if rel_domain_nl:
    parent = Path(str(rel_domain_nl)).parent
    if parent.parts:
      return parent.as_posix()
  if section and subsection and sample_index is not None:
    return f"{section}/{subsection}/{sample_index}"
  return f"{section}/{subsection}" if section and subsection else ""


def domain_setup_subdir_relative(example_id: str) -> Optional[Path]:
  """Dataset directory where domain_description_seed*.json is expected."""
  parsed = parse_example_id(example_id)
  if parsed is None:
    return None
  section, subsection, sample_index = parsed
  if sample_index is None:
    return Path(section) / subsection
  return Path(section) / subsection / str(sample_index)

import argparse
import asyncio
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List

from openrouter_client import (
  InsufficientBalanceError,
  OpenRouterAPIError,
  OpenRouterClient,
  get_model_config,
  load_config,
  load_openrouter_settings,
)


@dataclass
class PromptItem:
  """Один запрос в бенчмарке."""

  id: str
  prompt: str


async def run_for_model(
  cfg: Dict[str, Any],
  model_name: str,
  prompts_path: Path,
  output_dir: Path,
  max_concurrent: int | None = None,
  batch_size: int | None = None,
  limit: int | None = None,
) -> None:
  """
  Запускает все промпты для указанной модели, читая JSONL построчно.

  В памяти в каждый момент времени находится только текущий батч промптов.
  """
  settings = load_openrouter_settings(cfg)
  model_cfg = get_model_config(cfg, model_name)

  if max_concurrent is not None and max_concurrent > 0:
    settings.max_concurrent_requests = max_concurrent

  # Если пользователь не задал batch_size, используем разумное значение по умолчанию.
  # Это всё равно ограничивает память и не держит весь датасет в RAM.
  effective_batch_size = batch_size if batch_size and batch_size > 0 else 1000

  output_dir.mkdir(parents=True, exist_ok=True)

  semaphore = asyncio.Semaphore(settings.max_concurrent_requests)

  processed_count = 0

  async with OpenRouterClient(settings) as client:
    current_batch: List[PromptItem] = []

    with prompts_path.open("r", encoding="utf-8") as f:
      for line in f:
        line = line.strip()
        if not line:
          continue

        obj = json.loads(line)
        pid = str(obj["id"])
        prompt = str(obj["prompt"])
        current_batch.append(PromptItem(id=pid, prompt=prompt))
        processed_count += 1

        if limit is not None and processed_count >= limit:
          break

        if len(current_batch) >= effective_batch_size:
          await _process_batch(
            client=client,
            model_name=model_name,
            model_cfg=model_cfg,
            batch=current_batch,
            output_dir=output_dir,
            semaphore=semaphore,
          )
          current_batch = []

    if current_batch:
      await _process_batch(
        client=client,
        model_name=model_name,
        model_cfg=model_cfg,
        batch=current_batch,
        output_dir=output_dir,
        semaphore=semaphore,
      )

  if processed_count == 0:
    raise SystemExit("Не найдено ни одного промпта в файле.")


async def _process_batch(
  client: OpenRouterClient,
  model_name: str,
  model_cfg: Dict[str, Any],
  batch: List[PromptItem],
  output_dir: Path,
  semaphore: asyncio.Semaphore,
) -> None:
  """Запускает один батч промптов параллельно."""
  tasks: List[asyncio.Task[None]] = []
  for item in batch:
    tasks.append(
      asyncio.create_task(
        _run_single_prompt(
          client=client,
          model_name=model_name,
          model_cfg=model_cfg,
          item=item,
          output_dir=output_dir,
          semaphore=semaphore,
        )
      )
    )
  await asyncio.gather(*tasks)


async def _run_single_prompt(
  client: OpenRouterClient,
  model_name: str,
  model_cfg: Dict[str, Any],
  item: PromptItem,
  output_dir: Path,
  semaphore: asyncio.Semaphore,
) -> None:
  """Отправляет один промпт в OpenRouter и сохраняет JSON‑лог."""
  # Один файл на (модель, id промпта)
  out_path = output_dir / f"{item.id}__{model_name}.json"

  # Примитивный "resume": если файл есть — пропускаем.
  if out_path.exists():
    return

  async with semaphore:
    try:
      response_json = await client.generate_plan(model_cfg=model_cfg, prompt=item.prompt)
      payload: Dict[str, Any] = {
        "id": item.id,
        "model_name": model_name,
        "model": model_cfg["model"],
        # В целях экономии места полный промпт не дублируем,
        # он остаётся в исходном файле с промптами.
        "openrouter_response": response_json,
      }
    except InsufficientBalanceError as exc:
      # Логируем, что именно произошло, и пробрасываем дальше, чтобы остановить скрипт.
      payload = {
        "id": item.id,
        "model_name": model_name,
        "model": model_cfg["model"],
        "error": {
          "type": type(exc).__name__,
          "message": str(exc),
          "status_code": getattr(exc, "status_code", None),
          "openrouter_error": getattr(exc, "error_body", None),
        },
      }
      out_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
      raise
    except OpenRouterAPIError as exc:
      # Структурированное логирование API‑ошибки OpenRouter.
      payload = {
        "id": item.id,
        "model_name": model_name,
        "model": model_cfg["model"],
        "error": {
          "type": type(exc).__name__,
          "message": str(exc),
          "status_code": getattr(exc, "status_code", None),
          "openrouter_error": getattr(exc, "error_body", None),
        },
      }
      out_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
      return
    except Exception as exc:
      # Любая другая ошибка (сети, сериализация и т.п.)
      payload = {
        "id": item.id,
        "model_name": model_name,
        "model": model_cfg["model"],
        "error": {
          "type": type(exc).__name__,
          "message": str(exc),
        },
      }
      out_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
      return

    out_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def parse_args() -> argparse.Namespace:
  parser = argparse.ArgumentParser(
    description=(
      "Запуск батча промптов для планирующего LLM через OpenRouter. "
      "Промпты отправляются параллельно, JSON‑ответы логируются в файлы."
    )
  )
  parser.add_argument(
    "--prompts",
    type=Path,
    required=True,
    help="Путь к JSONL‑файлу с промптами (id + prompt).",
  )
  parser.add_argument(
    "--config",
    type=Path,
    default=Path("models_config.yaml"),
    help="Путь к YAML‑конфигу моделей и настроек OpenRouter.",
  )
  parser.add_argument(
    "--model",
    type=str,
    required=True,
    help="Имя модели из секции 'models' в конфиге (например, gpt5_mini).",
  )
  parser.add_argument(
    "--output-dir",
    type=Path,
    default=Path("runs") / "latest",
    help="Каталог, куда сохранять JSON‑логи ответов.",
  )
  parser.add_argument(
    "--limit",
    type=int,
    default=None,
    help="Опционально: ограничить количество промптов для тестового прогона.",
  )
  parser.add_argument(
    "--max-concurrent",
    type=int,
    default=None,
    help=(
      "Переопределить openrouter.max_concurrent_requests из конфига "
      "(максимальное число параллельных запросов)."
    ),
  )
  parser.add_argument(
    "--batch-size",
    type=int,
    default=None,
    help=(
      "Размер батча: сколько промптов обрабатывать за одну \"волну\". "
      "Остальные батчи пойдут последовательно."
    ),
  )
  return parser.parse_args()


def main() -> None:
  args = parse_args()

  cfg = load_config(str(args.config))

  args.output_dir.mkdir(parents=True, exist_ok=True)

  try:
    asyncio.run(
      run_for_model(
        cfg=cfg,
        model_name=args.model,
        prompts_path=args.prompts,
        output_dir=args.output_dir,
        max_concurrent=args.max_concurrent,
        batch_size=args.batch_size,
        limit=args.limit,
      )
    )
  except InsufficientBalanceError as exc:
    # Явно останавливаем скрипт, если на счёте OpenRouter закончились деньги.
    raise SystemExit(
      f"Остановка прогона: недостаточно кредитов в OpenRouter: {exc}"
    ) from exc


if __name__ == "__main__":
  main()


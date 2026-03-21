### sembenchrunning

Система прогона LLM‑моделей для бенчмарка по планированию (через OpenRouter).

### Основная идея

- **Вход**: датасет в PDDL (domain + problem + reference plan) в виде файлов.
- **Система**:
  - для каждого сэмпла строит **NL‑промпт** через переводчик PDDL→NL,
  - параллельно отправляет промпты в OpenRouter,
  - сохраняет **полный JSON‑ответ** OpenRouter для каждого сэмпла как лог,
  - опционально переводит NL‑план в PDDL и считает метрики.

### Файлы

- **`requirements.txt`**: зависимости (`httpx`, `PyYAML`).
- **`models_config.yaml`**: все характеристики моделей и настройки OpenRouter:
  - какие модели (**ключи в секции `models` — те же, что идентификаторы моделей в OpenRouter**),
  - лимиты токенов (`max_output_tokens`),
  - температура, `reasoning` и любые дополнительные параметры.
- **`openrouter_client.py`**:
  - загрузка конфига,
  - инициализация клиента OpenRouter,
  - одна функция `generate_plan(...)` для отправки одного промпта.
- **`run_benchmark.py`**:
  - CLI для запуска большого количества промптов,
  - параллельные HTTP‑запросы в OpenRouter,
  - сохранение JSON‑логов в каталог `runs/...`.

### Формат входных данных (датасет)

Ожидается структура **одна папка на сэмпл**:

```
data/<section>/<subsection>/<N>/
  sample.json
  <section>_<subsection>_domain.pddl
  <section>_<subsection>_problem.pddl
  <section>_<subsection>_plan.pddl
```

В `sample.json` хранятся пути к файлам (относительно папки сэмпла) и метаданные, например:

```json
{
  "id": "blocks_world__easy__1",
  "section": "blocks_world",
  "subsection": "easy",
  "domain_path": "blocks_world_easy_domain.pddl",
  "problem_path": "blocks_world_easy_problem.pddl",
  "plan_ref_path": "blocks_world_easy_plan.pddl"
}
```

### Настройка моделей (`models_config.yaml`)

- Секция **`openrouter`**:
  - `api_base`: URL эндпоинта (по умолчанию `https://openrouter.ai/api/v1/chat/completions`),
  - `api_key_env`: имя переменной окружения с API‑ключом (по умолчанию `OPENROUTER_API_KEY`),
  - `timeout_seconds`: таймаут HTTP‑запроса,
  - `max_concurrent_requests`: максимальное число параллельных запросов,
  - `max_retries`, `retry_backoff_seconds`: политика ретраев.
- Секция **`models`**:
  - ключ — короткое имя модели (например, `gpt4_1_mini`),
  - `model` — идентификатор модели в OpenRouter,
  - `max_output_tokens`, `temperature`, `reasoning` — характеристики модели.

Пример уже есть в `models_config.yaml`, можно добавлять/редактировать модели по аналогии.

### Требования для запуска

- **OpenRouter**: переменная окружения `OPENROUTER_API_KEY` (ключ с [openrouter.ai](https://openrouter.ai)).
- **VAL** (plan validator): бинарник `validate` для подсчёта метрик (executability, reachability, optimality). Скачать: [VAL](https://github.com/KCL-Planning/VAL). Укажите путь к нему через `--val-binary` (полный путь, например `D:\VAL\validate.exe` или `/usr/local/bin/validate`, либо просто `validate`, если он в PATH).
- При использовании **AutoPlanBench** (PDDL↔NL): репозиторий AutoPlanBench и переменная `AUTOPLANBENCH_ROOT` или флаг `--autoplanbench-root`.

### Запуск бенчмарка

1. **Установить зависимости**:

```bash
pip install -r requirements.txt
```

2. **Задать API‑ключ OpenRouter**:

```bash
# Windows (cmd)
set OPENROUTER_API_KEY=your_api_key_here

# Windows (PowerShell) / Linux / WSL
export OPENROUTER_API_KEY="your_api_key_here"
```

3. **Полный бенчмарк (перевод PDDL→NL → LLM → NL→PDDL + метрики)** — одна команда:

Перед запуском проверьте:
- задана переменная `OPENROUTER_API_KEY`;
- датасет лежит в `data/batch_samples/` (или укажите этот каталог через `--dataset-dir`; родительский `data/` тоже допустим, runner нормализует путь автоматически);
- путь к VAL и к AutoPlanBench подставлены под вашу систему.

```bash
python run_benchmark.py ^
  --dataset-dir data/batch_samples ^
  --model openai/gpt-5-mini ^
  --prompt-translator translators.autoplanbench_pddl2nl:pddl_to_nl_prompt ^
  --translator translators.autoplanbench_nl2pddl:nl_to_pddl ^
  --val-binary "D:\VAL\validate.exe" ^
  --autoplanbench-root D:\work\autoplanbench ^
  --output-dir runs/latest
```

Что делает эта команда: для каждого сэмпла строит NL‑промпт (PDDL→NL через AutoPlanBench), отправляет его в выбранную модель, переводит ответ в PDDL (NL→PDDL), после прогона по всем сэмплам запускает VAL и пишет метрики в `runs/latest/metrics.jsonl`.

- **`--val-binary`** — путь к бинарнику VAL (`validate` или `validate.exe`). Без него метрики не посчитаются.
- **`--val-timeout-seconds`** — таймаут одного запуска VAL (по умолчанию 30 секунд).
- **`--autoplanbench-root`** — путь к корню AutoPlanBench (для PDDL↔NL). Можно заменить на переменную окружения `AUTOPLANBENCH_ROOT`.
- Несколько моделей: добавьте несколько раз `--model ...` (например `--model openai/gpt-5-mini --model meta-llama/llama-3.3-70b-instruct`).
- Тестовый прогон на 5 сэмплах: добавьте `--limit 5`.

Дополнительно:

- **`--config`**: путь к другому `models_config.yaml`;
- **`--limit N`**: обработать только первые N сэмплов (тестовый прогон);
- **`--max-concurrent`**: переопределить число параллельных запросов;
- **`--batch-size`**: размер батча;
- **`--nl2pddl-workers 0`**: выполнять NL→PDDL последовательно;
- **`--skip-metrics`**: не считать метрики после прогона;
- **`--metrics-only`**: только пересчитать метрики по уже сохранённым run (`--output-dir` и `--dataset-dir` обязательны).
- **`--allow-reasoning-fallback`**: разрешить использовать `message.reasoning` как NL-план, если `message.content` пустой (по умолчанию выключено для строгой оценки).

### Логирование результатов

- Для каждого промпта создаётся **отдельный JSON‑файл** в указанном `--output-dir`:
  - имя файла: `id__model_name.json` (например, `problem_1__openai_gpt-5-mini.json`),
  - содержимое включает:
    - `id`, `model_name`, `model`,
    - `openrouter_response` — полный JSON‑ответ OpenRouter **или** `error` в случае ошибки,
    - при фазе метрик также могут появиться `plan_pred_pddl`, `nl2pddl_status`, `nl2pddl_error`,
    - `pipeline_usage` — сводка известных usage-данных по этапам; если для этапа нет надёжных данных, он помечается как `tracked: false`.
- **Промпт не дублируется** в логе (чтобы не раздувать объём) — он строится на лету из датасета.
- `domain_description_seedN.json` для AutoPlanBench теперь пересобирается автоматически, если изменились входные `domain/problem`, `seed`, `llm` или сам `run_domain_setup.py`.
- Кэш `domain_and_problem_nl.txt` теперь сопровождается `domain_and_problem_nl.meta.json`; при изменении входных PDDL, `domain_nl_path` или переводчика кэш автоматически инвалидируется.

### Параллелизм и масштабирование

- Параллельность управляется через:
  - `openrouter.max_concurrent_requests` в `models_config.yaml`,
  - асинхронный клиент (`httpx.AsyncClient`) + семафор.
- Можно безопасно гонять **>1000 промптов**:
  - батч просто задаётся объёмом входного файла,
  - скрипт сам дозирует параллельные запросы, чтобы не упреться в лимиты.

### Метрики и покрытие

- `metrics.jsonl` теперь пишется **для всех run JSON**, а не только для полностью успешных прогонов.
- Для каждой строки есть:
  - `status`: `metrics_computed` или `pipeline_failed`,
  - `failure_reason`: причина сбоя пайплайна (`run_error`, `provider_response_error`, `missing_nl_plan`, `nl2pddl_error`, и т.д.).
- Primary metrics:
  - `executability` — план исполним по VAL;
  - `reachability` — цель достигнута по VAL;
  - `optimality_ratio` — считается только для планов, достигших цели; иначе `-1`.
- Diagnostic fields:
  - `first_val_failure_step` — первый шаг, на котором VAL зафиксировал проблему;
  - `first_ref_deviation_step` — первое расхождение с reference plan, если план достиг цели и reference есть;
  - `first_error_step` — совместимое поле: сначала `first_val_failure_step`, иначе `first_ref_deviation_step`.


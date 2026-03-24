### sembenchrunning

Система прогона LLM‑моделей для бенчмарка по планированию (через OpenRouter).

### Основная идея

- **Вход**: датасет в PDDL (domain + problem + reference plan) в виде файлов.
- **Система**:
  - для каждого сэмпла строит промпт: **NL** (PDDL→NL) или **PDDL→PDDL** (шаблон + сырой domain/problem без APB),
  - параллельно отправляет промпты в OpenRouter,
  - сохраняет **полный JSON‑ответ** OpenRouter для каждого сэмпла как лог,
  - для метрик получает **PDDL‑план**: либо NL→PDDL (AutoPlanBench), либо нормализация ответа модели (`translators.pddl2pddl:response_as_plan_pddl`).

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

**Режим PDDL→PDDL** (без переводов в натуральный язык и без APB NL2PDDL): флаг **`--pddl2pddl`** подставляет `--prompt-translator translators.pddl2pddl:pddl_prompt_body` и **`--translator translators.pddl2pddl:response_as_plan_pddl`**, грузит шаблон **`prompt_template_pddl2pddl.txt`** из датасета (или встроенный из `data/prompt_template_pddl2pddl.txt`), кэширует тело промпта в `planning_prompt_pddl_body.txt`, **не** вызывает `ensure_domain_json`. Кэш тел: **`--refresh-pddl2pddl-cache`**; общая очистка **`--refresh-translation-caches`** теперь сбрасывает и этот кэш. Пример:

```bash
python run_benchmark.py ^
  --dataset-dir data/batch_samples ^
  --model openai/gpt-5-mini ^
  --pddl2pddl ^
  --val-binary "D:\VAL\validate.exe" ^
  --output-dir runs/pddl2pddl_latest
```

Для **`--metrics-only`** на прогонах в этом режиме укажите тот же **`--translator`** (или снова **`--pddl2pddl`**).

- **`--val-binary`** — путь к бинарнику VAL (`validate` или `validate.exe`). Без него метрики не посчитаются.
- **`--val-timeout-seconds`** — таймаут одного запуска VAL (по умолчанию 30 секунд).
- **`--autoplanbench-root`** — путь к корню AutoPlanBench (для PDDL↔NL). Можно заменить на переменную окружения `AUTOPLANBENCH_ROOT`.
- **`translator_config.yaml`** (в корне `sembenchrunning`) — единый файл настроек переводчика AutoPlanBench: **`domain_setup`** (`run_domain_setup.py`: `llm`, `max_tokens`, `parallel`, `timeout_seconds`, **`openrouter_parallel_timeout_seconds`** — таймаут чтения одного HTTP-ответа в параллельном OpenRouter внутри APB), **`nl2pddl`** (в т.ч. **`openrouter_parallel_timeout_seconds`** для `run_translate_nl2pddl`), **`pddl2nl_sample`** (`run_save_descriptions.py`). Переопределить путь: **`SEMBENCH_TRANSLATOR_CONFIG`** или флаг **`--translator-config`**. Приоритет: **переменная окружения > YAML > встроенные дефолты** (см. `translator_settings.py`).
- **`--autoplanbench-llm`** — модель для авто-`run_domain_setup` (PDDL→NL **домена**). Если флаг не задан, берётся **`domain_setup.llm`** из `translator_config.yaml`.
- Таймаут **одного** вызова `run_domain_setup.py`: в YAML **`domain_setup.timeout_seconds`** или переменная **`AUTOPLANBENCH_DOMAIN_SETUP_TIMEOUT`** (по умолчанию **600**).
- Параллель HTTP в **`run_domain_setup.py`**: **`domain_setup.parallel`** в YAML, или **`AUTOPLANBENCH_DOMAIN_SETUP_PARALLEL`**, или **`--domain-setup-parallel N`**.
- Таймаут **`run_save_descriptions.py`**: **`pddl2nl_sample.timeout_seconds`** или **`AUTOPLANBENCH_PDDL2NL_TIMEOUT`**. Таймаут **`run_translate_nl2pddl.py`**: **`nl2pddl.timeout_seconds`** или **`AUTOPLANBENCH_NL2PDDL_TIMEOUT`**.
- **`--debug`** (или **`SEMBENCH_DEBUG=1`**) — подробный лог runner’а и **вывод скриптов AutoPlanBench в консоль** (иначе stdout/stderr субпроцессов перехватываются). В режиме debug строка **`AUTOPLANBENCH_NL2PDDL_USAGE:`** в `*__nl2pddl_debug.json` может быть пустой (stdout не сохраняется).
- Несколько моделей: добавьте несколько раз `--model ...` (например `--model openai/gpt-5-mini --model meta-llama/llama-3.3-70b-instruct`).
- Тестовый прогон: `--limit 5` — в **каждой** section берётся не более **5** первых валидных сэмплов (порядок как у sorted `sample.json` по датасету), а не 5 сэмплов на весь датасет.

Дополнительно:

- **`--config`**: путь к другому `models_config.yaml`;
- **`--limit N`**: в каждой **section** (области) — не более первых **N** валидных сэмплов; тот же смысл при **`--metrics-only`**;
- **`--max-concurrent`**: переопределить число параллельных запросов;
- **`--batch-size`**: размер батча;
- **`--translate-workers`**, **`--nl2pddl-workers`**: параллельность по сэмплам (PDDL→NL промпт и NL→PDDL в метриках); по умолчанию **2**, **`0`** — последовательно;
- **`--nl2pddl-parallel N`**: параллель HTTP **внутри** `run_translate_nl2pddl.py` (строки плана); то же, что env **`AUTOPLANBENCH_NL2PDDL_PARALLEL`** (по умолчанию **80**). В AutoPlanBench параллель только при **N>1**; **`N=1`** — последовательный перевод строк.
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
    - `pipeline_usage` — сводка известных usage-данных по этапам; если для этапа нет надёжных данных, он помечается как `tracked: false`. Сумма `totals` по run не включает `domain_setup` (у блока `included_in_per_run_totals: false`, агрегировать domain отдельно).
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


# AutoPlanBench: статья vs репозиторий и изменения в sembenchrunning

Сравнение по статье (arXiv 2311.09830), репозиторию autoplanbench и интеграции в sembenchrunning.

---

## 1. Что описывает статья

- **Цель:** автоматически переводить бенчмарки планирования из PDDL в текстовые описания и оценивать LLM-планировщиков без ручной конвертации.
- **Цепочка:** PDDL → (APB-LLM) → NL-шаблоны предикатов/действий → правило-based сборка NL домена и задачи → P-LLM генерирует NL-план → T-LLM переводит NL→PDDL → валидация плана (VAL).
- **Два режима:** неинтерактивный (Basic, CoT: один запрос с few-shot) и интерактивный (Act, ReAct: пошаговые действия + domain engine с VAL, наблюдения возвращаются в P-LLM).
- **Domain engine:** после каждого действия проверка применимости и цели через VAL; при невыполнимости — сообщение вроде «I cannot drive truck … because truck_0 is not at location_0».
- **Метрики:** Acc (цель достигнута), Acc0 (план полностью исполним без ошибок), LF (длина плана / оптимальная длина); бейзлайны BFS и случайные действия.
- **Данные:** 12 доменов (Blocksworld, Logistics, Depot + 9 из PDDL-generators), по 21 задаче на домен, один few-shot пример на домен, золотые планы — Fast Downward.

---

## 2. Что есть в репозитории autoplanbench

- **run_domain_setup.py** — генерация `domain_description_seedN.json` (PDDL→NL для домена): предикаты и действия через APB-LLM, одна задача из `orig_problems/` для полного NL задачи.
- **utils/run_save_descriptions.py** — по `domain_description_seedN.json` и PDDL домена/задачи: полное NL описание домена и задачи (`--type full`), используется для промпта P-LLM.
- **utils/run_translate_nl2pddl.py** — T-LLM: перевод NL-плана в PDDL по домену и примерам перевода (шаблон + few-shot из domain NL).
- **run_planning.py** — запуск планирования по конфигу (Basic/CoT/Act/ReAct), few-shot id, seed; вызывает соответствующий game class (например ReAct с domain engine).
- **run_autoplanbench.py** — оркестрация: domain setup → выбор few-shot → run_setup_exp_files → run_planning для каждого подхода.
- **Domain engine** — в `llm_planning/game_classes/` (pddl_game_env, raw_pddl_env): загрузка домена/задачи (Tarski), применение действия через VAL, наблюдения для интерактивных режимов.
- **Данные в репо:** структура по доменам (`data_dir/domain_name/`, `orig_inst/`, `instance_dir/`, конфиги по подходам).

В репозитории есть доработки относительно статьи: OpenRouter (base_url, api_key), опции `--seed`, `--max-tokens`, `--parallel` для PDDL→NL, совместимость с Python 3.13 (typing.io).

---

## 3. Что модифицировано / добавлено в sembenchrunning

### 3.1 Разделение «план — перевод»

- **В статье/репо:** один пайплайн: P-LLM (GPT-4) + T-LLM внутри AutoPlanBench, четыре подхода (Basic, CoT, Act, ReAct).
- **В sembenchrunning:** этап планирования вынесен наружу. Любая модель (minimax, openai, и т.д.) вызывается через `run_benchmark.py`, даёт один ответ (NL-план в `content`/`reasoning`). Затем **только** шаг NL→PDDL делается через AutoPlanBench: вызов `utils/run_translate_nl2pddl.py` из обёртки `translators/autoplanbench_nl2pddl.py`. То есть AutoPlanBench используется как **только T-LLM и PDDL→NL для промпта**, без своих P-LLM и без интерактивного движка.

### 3.2 Структура датасета

- **В репо:** домен = папка с именем домена, внутри `orig_inst/`, instance dir, gold plans, конфиги.
- **В sembenchrunning:** датасет по разделам и подразделам: `data/batch_samples/<section>/<subsection>/<sample_name>/` с `sample.json` (id, domain_path, problem_path, plan_ref_path, при необходимости domain_nl_path). Один сэмпл = одна задача; домен может быть общий на подраздел (один `domain_description_seedN.json` на subsection или section).

### 3.3 Domain setup

- **В репо:** `run_domain_setup.py -d domain.pddl -i orig_inst_dir -o domain_data_path` для каждого домена.
- **В sembenchrunning:** `autoplanbench_utils.ensure_domain_json()` создаёт временную папку `_apb_setup` в разделе, копирует один domain.pddl и одну задачу, вызывает `run_domain_setup.py`, копирует полученный `domain_description_seedN.json` в `data/<section>/domain_description_seedN.json` (или аналог для subsection). В `run_benchmark` при необходимости тот же шаг вызывается автоматически; в `prepare_autoplanbench_data.py` — пакетная подготовка по датасету.

### 3.4 PDDL→NL (промпт для модели)

- **В репо:** вызывается при настройке экспериментов и внутри run_planning (полное NL домена и задачи).
- **В sembenchrunning:** обёртка `translators/autoplanbench_pddl2nl.py` вызывает `utils/run_save_descriptions.py --type full -d domain_path --prob problem_path --d-nl domain_nl_path --out out_file`. Результат — текст промпта, который уходит во внешнюю модель. Вызов идёт по одному сэмплу из run_benchmark, не из скриптов AutoPlanBench.

### 3.5 NL→PDDL (перевод плана)

- **В репо:** T-LLM вызывается из game class после каждого шага (ReAct/Act) или один раз по полному плану (Basic/CoT); конфиг и примеры из папок домена.
- **В sembenchrunning:** после получения ответа модели NL-план извлекается из run JSON (`content`/`reasoning`), передаётся в `autoplanbench_nl2pddl.nl_to_pddl()` → subprocess `run_translate_nl2pddl.py` с `--domain-nl`, `--domain`, `--instance`, `--plan-file`, `--out`, `--model-path`, `--prompt-file`. Добавлено: таймаут (AUTOPLANBENCH_NL2PDDL_TIMEOUT), опциональный параллелизм (AUTOPLANBENCH_NL2PDDL_PARALLEL), запись отладочного JSON (`*__nl2pddl_debug.json`, в т.ч. при успехе) с полем **`openrouter_usage`** — агрегированные токены/cost перевода из строки stdout `AUTOPLANBENCH_NL2PDDL_USAGE:` (пишет autoplanbench после прогона).
- **Сводка по этапам в одном файле:** в каждом run JSON заполняется **`pipeline_usage`**: `planning`, `pddl2nl_prompt` (без LLM на шаге промпта сэмпла), `nl2pddl`, **`domain_setup`** (из `domain_llm_usage_seedN.json` рядом с `domain_description_seedN.json` в каталоге section/subsection датасета — пишет autoplanbench после PDDL→NL в `run_domain_setup`, копирует `ensure_domain_json`), **`totals`** — сумма всех LLM-этапов (включая domain setup). Сид домена — `--autoplanbench-seed` / `domain_description_seedN`. Обновляется при записи run и в фазе метрик (`run_benchmark.py`, `pipeline_usage.py`).

### 3.6 Отсутствие интерактивного режима и domain engine

- В sembenchrunning **нет** пошагового выполнения, domain engine и обратной связи «наблюдение → следующий шаг». Есть только: один запрос к модели → один NL-план → один вызов NL→PDDL → одна проверка плана в VAL. Соответственно не используются Basic/CoT/Act/ReAct из репо, только их «идея» T-LLM и полного NL описания.

### 3.7 Метрики

- **В статье:** Acc (цель достигнута), Acc0 (план полностью исполним), LF (длина исполнимой части / оптимальная длина).
- **В sembenchrunning:**  
  - **executability** — все действия применимы по VAL;  
  - **reachability** — цель достигнута по VAL;  
  - **optimality_ratio** — длина предсказанного плана / длина эталонного (если 0 PDDL-шагов при непустом плане → -1 и исключение из среднего);  
  - **first_error_step** — первый шаг, в котором предсказанный план расходится с эталонным.  
  Бейзлайны BFS/random в sembenchrunning не считаются.

### 3.8 Скрипты и утилиты

- **prepare_autoplanbench_data.py** — обход датасета по section/subsection, вызов `ensure_domain_json` по подразделам, опционально генерация `domain_and_problem_nl.txt` по каждому сэмплу через `run_save_descriptions.py`. Нет аналога в репо (там данные под свою структуру).
- **autoplanbench_utils.py** — `get_apb_root()`, `ensure_domain_json()` для интеграции с run_benchmark и prepare.
- **scripts/run_val_risk_compliance.py** — локальный прогон VAL по подобласти risk_compliance_controls, планы из run JSON, запись в `runs/val_debug/` и вызов VAL с `output_dir` (без временной папки).

### 3.9 VAL

- В `metrics/val_runner.py` добавлен параметр **output_dir**: при задании VAL читает domain/problem/plan из этой папки (файлы туда пишутся из run JSON в скрипте run_val_risk_compliance). В основном бенчмарке по-прежнему можно использовать временную папку (output_dir не передаётся).
- При `executable=False` в run_benchmark с `--debug` вызывается callback с ValResult и в лог пишется stderr VAL.

### 3.10 Документация и отладка

- **docs/autoplanbench_logistics_analysis.md** — разбор падения domain setup для logistics (типы в задаче vs бестиповой домен, Tarski), не описан в статье.
- В коде явно зафиксировано: планы для VAL берутся из run JSON (ответы модели), при необходимости сохраняются в `val_debug` и оттуда подаются в VAL.

---

## 4. Краткая сводка

| Аспект | Статья / репо AutoPlanBench | sembenchrunning |
|--------|----------------------------|------------------|
| Кто генерирует NL-план | P-LLM внутри (GPT-4, Basic/CoT/Act/ReAct) | Внешняя модель по выбору пользователя (minimax, openai, …) |
| Использование AutoPlanBench | Полный пайплайн (domain setup + P-LLM + T-LLM + оценка) | Только PDDL→NL (промпт) и NL→PDDL (run_translate_nl2pddl), плюс domain setup для domain_description |
| Интерактив / domain engine | Есть (ReAct, Act) | Нет |
| Структура данных | По доменам (domain_name, orig_inst, instances) | section / subsection / sample_name, sample.json с путями |
| Метрики | Acc, Acc0, LF; BFS/random | executability, reachability, optimality_ratio, first_error_step |
| Подготовка данных | Скрипты репо под 12 доменов | prepare_autoplanbench_data.py под свой датасет, ensure_domain_json в run |
| VAL | Внутри domain engine и при финальной проверке | Отдельный шаг после NL2PDDL; опционально output_dir и debug stderr |

Итог: в sembenchrunning AutoPlanBench используется как **модуль перевода PDDL↔NL и доменного описания**, а не как готовый бенчмарк с четырьмя подходами и интерактивным движком; планирование и выбор модели вынесены в свой контур прогона и метрик.

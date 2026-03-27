# Анализ пайплайна: задуманный vs текущая реализация

## Задуманный пайплайн

```
DATA (PDDL: domain + problem + reference plan)
    → PDDL→NL (domain setup + run_save_descriptions)
    → Natural Language TEXT (prompt_template + domain + problem)
    → LLM (OpenRouter)
    → Natural Language TEXT (план модели)
    → NL→PDDL (run_translate_nl2pddl)
    → VAL (валидация PDDL-плана)
    → Метрики (domain_conformance, executability, reachability, optimality_ratio)
```

## Текущая реализация по шагам

### 1. DATA (PDDL domain + problem) ✅

- Датасет: `data/<section>/<subsection>/<N>/` с файлами `*_domain.pddl`, `*_problem.pddl`, `*_plan.pddl` и `sample.json`.
- В фазе метрик домен и задача подгружаются через `_load_sample_pddl` → `_get_pddl_from_sample` и передаются в `compute_metrics`.

### 2. PDDL→NL (построение промпта) ✅

- Реализовано в `_build_all_prompts` через `--prompt-translator`.
- Поддерживается кэш (`domain_and_problem_nl.txt` + `.meta.json`) с инвалидацией по SHA256 входных файлов.
- При отсутствии `domain_description_seedN.json` автоматически вызывается `ensure_domain_json` (через `--autoplanbench-root`).
- Параллельная трансляция через `ThreadPoolExecutor` (`--translate-workers`).

### 3. Prompt → LLM ✅

- `prompt_template.txt` + NL-перевод домена/задачи → OpenRouter API.
- Async-клиент с семафором, ретраями, обработкой 402/429/500+.
- Ответы сохраняются в `{example_id}__{safe_model_name}.json`.

### 4. NL plan → PDDL plan ✅

- Реализовано в фазе метрик (`compute_metrics_phase`).
- Из run JSON извлекается NL-план (`_get_nl_plan_from_run`), затем вызывается `--translator` (NL→PDDL).
- Результат кэшируется в `plan_pred_pddl` в run JSON.
- Отладочная информация в `*__nl2pddl_debug.json`.

### 5. VAL + Метрики ✅

- Вход: PDDL domain, problem (из датасета), plan_pred (из транслятора), plan_ref (из датасета).
- `compute_metrics` запускает VAL через subprocess, парсит stdout/stderr.
- Метрики: domain_conformance, executability, reachability, optimality_ratio, first_error_step, first_val/ref_deviation_step.
- Результаты в `metrics.jsonl` с merge-логикой (новые строки обновляют старые по ключу example_id+model).

---

## Сводка

| Шаг | Задуманный пайплайн | В коде | Статус |
|-----|---------------------|--------|--------|
| DATA | PDDL domain + problem + ref plan | Датасет с .pddl и sample.json | ✅ |
| PDDL→NL | Domain setup + NL описание | `--prompt-translator` + кэш + auto domain setup | ✅ |
| Prompt → LLM | NL prompt → OpenRouter | Async client, batching, retry | ✅ |
| LLM → NL plan | Ответ модели | Сохраняется в run JSON | ✅ |
| NL → PDDL plan | `--translator` | В фазе метрик, с кэшем | ✅ |
| Метрики | VAL + optimality | `compute_metrics` + aggregate | ✅ |

Все шаги задуманного пайплайна реализованы в текущей версии `run_benchmark.py`.

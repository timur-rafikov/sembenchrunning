# finalset (themed PDDL)

Импорт из `work/finalset/final-set/final/` в `data/finalset/` с генерацией `sample.json`.

## PDDL → Tarski / `run_domain_setup`

После копирования доменов из исходника проверь иерархию `(:types …)` (иначе `UndefinedSort` в AutoPlanBench):

```bash
python scripts/check_pddl_domain_types.py
python scripts/fix_pddl_parent_types.py data/finalset   # при необходимости
```

Проверка произвольного дерева: `python scripts/check_pddl_domain_types.py путь/к/доменам`.

## Формат папки сэмпла

- `themed_domain.pddl`, `themed_problem.pddl`, `themed_plan.txt` (эталон)
- `sample.json` — создаётся скриптом `scripts/import_finalset_layout.py`

## Повторная генерация `sample.json`

```bash
python scripts/import_finalset_layout.py --dataset-dir data/finalset
```

## Прогон бенчмарка

Шаблон промпта подхватывается из `data/prompt_template.txt` (родительский каталог).

Пример (подставьте пути к VAL и AutoPlanBench):

```bash
python run_benchmark.py ^
  --dataset-dir data/finalset ^
  --output-dir runs/finalset ^
  --model openai/gpt-5-mini ^
  --prompt-translator translators.autoplanbench_pddl2nl:pddl_to_nl_prompt ^
  --translator translators.autoplanbench_nl2pddl:nl_to_pddl ^
  --val-binary validate ^
  --autoplanbench-root D:\work\autoplanbench ^
  --limit 5
```

На полном сете **800** сэмплов — без `--limit` будет долго и дорого по API.

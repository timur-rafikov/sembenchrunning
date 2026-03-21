# Почему падает domain setup для logistics в AutoPlanBench

## Что происходит

При запуске `run_domain_setup.py` для секции `logistics/easy` AutoPlanBench вызывает цепочку:

1. **setup_domain.py** → генерирует `domain_description_seed0.json` (PDDL→NL домена), затем для каждого problem-файла вызывает **create_full_nl_description()**.
2. **create_full_nl_description()** в `utils/run_save_descriptions.py` вызывает **get_problem_nl_text(problem_file, domain_nl_file, domain_pddl_file)**.
3. **get_problem_nl_text()** создаёт **PDDLWorldEnvironment(domain_nl=..., instance_file=problem_file, domain_file=domain_pddl_file)**.
4. **PDDLWorldEnvironment** наследует **RawPDDLEnvironment** и в **__init__** вызывает **super().__init__(instance_file=..., domain_file=...)**.
5. **RawPDDLEnvironment.create_lowercase_problem()** переводит domain и problem в нижний регистр и вызывает **get_problem(lower_case_instance_file, lowercase_domain_file)**.
6. **get_problem()** использует **Tarski PDDLReader**: `reader.parse_domain(domain)` затем `reader.parse_instance(instance)`.
7. При разборе задачи Tarski в **visitObject_declaration** для каждого объекта запрашивает тип (sort). Ошибка: **`tarski.errors.UndefinedElement: Undefined element "city"`** — в языке домена нет типа (сорта) `city`.

## Причина

**Несовпадение домена и задачи по типам.**

- **Домен** `logistics_easy_domain.pddl` в датасете — **бестиповой STRIPS**:
  - нет блока `:requirements :typing`;
  - нет блока `:types`;
  - типы нигде не объявлены, используются только предикаты `(city ?c)`, `(loc ?l)`, `(truck ?t)`, `(package ?p)`.

- **Задача** `logistics_easy_problem.pddl` — **типовая**:
  - в `(:objects ...)` указаны типы: `c1 - city`, `l1 l2 - loc`, `t1 - truck`, `p1 - package`.

По стандарту PDDL типы объектов в задаче должны быть объявлены в домене (через `:types` и при необходимости `:requirements :typing`). Tarski при разборе задачи требует, чтобы каждый тип из `(:objects ...)` существовал в языке домена как сорт. В домене нет ни `:types`, ни сорта `city`, поэтому при разборе объекта `c1 - city` парсер и выдаёт «Undefined element "city"».

Итого: падает не из‑за бага в AutoPlanBench, а из‑за того, что **ваш logistics-домен не объявляет типы, а logistics-задачи их используют**. С blocks_world такого нет (там либо оба файла типованы, либо оба бестиповые), поэтому blocks_world проходит.

## Что сделать

### Вариант 1 (рекомендуется): добавить типы в домен

В начале домена добавить `:typing` и блок `:types`:

```pddl
(define (domain logistics)
  (:requirements :strips :typing)
  (:types city loc truck package - object)
  (:predicates (truck ?t) (city ?c) (loc ?l) ...)
  ...
)
```

Типы `city`, `loc`, `truck`, `package` должны совпадать с теми, что используются в `(:objects ...)` в задачах. После этого Tarski и AutoPlanBench будут корректно обрабатывать logistics.

### Вариант 2: убрать типы из задач

Во всех logistics problem-файлах заменить объявления объектов на бестиповые, например:

- Было: `(:objects c1 - city l1 l2 - loc t1 - truck p1 - package)`
- Стало: `(:objects c1 l1 l2 t1 p1)`

Тогда парсеру не нужны сорта в домене. Минус — теряется явная типизация в задачах.

### Вариант 3: не трогать AutoPlanBench

Оставить как есть: для logistics секция помечается как failed, сэмплы logistics пропускаются (как уже сделано в run_benchmark через кэш неудачных секций). Остальные домены (например, blocks_world) продолжают работать.

## Где именно в коде

| Файл | Что происходит |
|------|----------------|
| `run_domain_setup.py` | Вызов `setup_pddl_domain()` с domain + одна задача из `orig_problems/`. |
| `pddl_processing/setup_domain.py` | После генерации domain NL для каждой problem вызывается `create_full_nl_description(..., problem_file=prob_path, ...)`. |
| `utils/run_save_descriptions.py` | `get_problem_nl_text()` создаёт `PDDLWorldEnvironment(instance_file=problem_file, domain_file=domain_pddl_file)`. |
| `llm_planning/game_classes/pddl_game_env.py` | `PDDLWorldEnvironment.__init__` вызывает `RawPDDLEnvironment.__init__(instance_file, domain_file)`. |
| `llm_planning/raw_pddl_input/raw_pddl_env.py` | `RawPDDLEnvironment.create_lowercase_problem()` → `get_problem(instance, domain)` → Tarski `parse_domain` + `parse_instance`. Ошибка в `parse_instance` при разборе `(:objects ...)` из-за отсутствия сорта `city` в языке домена. |

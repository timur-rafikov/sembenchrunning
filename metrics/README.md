# Planning metrics

Inputs are **only PDDL**: domain and problem from the dataset, predicted plan from the **translator** (NL→PDDL), reference plan from the dataset. No parsing of prompts or model output.

Four metrics (VAL + length):

1. **Executability** — VAL: plan is executable (0/1).
2. **Reachability** — VAL: goal reached (0/1).
3. **Optimality ratio** — `len(plan_pred) / len(plan_ref)`.
4. **First error step** — 1-based step where the plan first fails; 0 if valid and optimal.

## Dependencies

- **VAL** on `PATH` as `validate` (or pass `val_binary`).
- Python: `numpy`, `scipy` (for aggregation and significance).

## Usage

```python
from metrics import compute_metrics, aggregate_runs, compare_models, RunRecord

# PDDL from dataset + translator
m = compute_metrics(
    domain_pddl=domain_pddl,      # from dataset
    problem_pddl=problem_pddl,   # from dataset
    plan_pred_pddl=plan_from_translator,  # PDDL string or list of step strings
    plan_ref_pddl=reference_plan_pddl,   # from dataset (section/subsection)
)
# m.executability, m.reachability, m.optimality_ratio, m.first_error_step

# Multiple runs: set section/subsection for per-domain analysis
records = [
    RunRecord(run_id, example_id, model, 1.0, 1.0, 1.0, 0,
              section="blocks_world", subsection="clean"),
    ...
]
by_model = aggregate_runs(records, group_by="model")
by_section = aggregate_runs(records, group_by="section")
by_subsection = aggregate_runs(records, group_by="subsection")
by_section_subsection = aggregate_runs(records, group_by="section_subsection")

# Compare two models (paired: same examples)
compare_models(records, model_a="gpt-5-mini", model_b="claude-sonnet")

# Compare two sections or two subsections (unpaired: different examples)
compare_groups(records, group_by="section", group_a="blocks_world", group_b="logistics")
compare_groups(records, group_by="subsection", group_a="clean", group_b="paraphrased")
```

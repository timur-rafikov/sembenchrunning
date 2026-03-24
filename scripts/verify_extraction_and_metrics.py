"""Проверка: извлечение NL-плана из run JSON и diagnostic-сравнение с reference plan."""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from metrics.plan_utils import pddl_plan_to_steps, first_deviation_step


def main():
    base = ROOT
    run_path = base / "runs/batch_samples/finance__payments_settlement__card_dispute_payout_resolution__minimax_minimax-m2.5.json"
    data = json.loads(run_path.read_text(encoding="utf-8"))

    # 1) Как _get_nl_plan_from_run
    msg = data.get("openrouter_response", {}).get("choices", [{}])[0].get("message", {})
    if msg is None:
        msg = {}
    content = (msg.get("content") or "").strip()
    reasoning = (msg.get("reasoning") or "").strip()
    nl_plan = content if content else reasoning
    print("1) NL plan: source =", "content" if content else "reasoning", ", len =", len(nl_plan))
    print("   First line:", repr((nl_plan.split("\n")[0] if nl_plan else "")[:80]))
    assert nl_plan, "NL plan must be non-empty"

    # 2) plan_pred_pddl
    plan_pred = data.get("plan_pred_pddl") or ""
    pred_steps = pddl_plan_to_steps(plan_pred)
    print("2) plan_pred_pddl: steps =", len(pred_steps))
    print("   First step:", repr(pred_steps[0]) if pred_steps else "N/A")

    # 3) Reference from dataset
    sample_dir = base / "data/batch_samples/finance/payments_settlement/card_dispute_payout_resolution"
    sample = json.loads((sample_dir / "sample.json").read_text(encoding="utf-8"))
    plan_ref_path = sample.get("plan_ref_path") or sample.get("plan_ref")
    ref_text = (sample_dir / plan_ref_path).read_text(encoding="utf-8")
    ref_steps = pddl_plan_to_steps(ref_text)
    print("3) plan_ref: steps =", len(ref_steps), ", file =", plan_ref_path)

    # 4) Ratio and first deviation relative to the reference plan
    # optimality_ratio = opt_len / pred_len: 1.0 = matches reference, < 1.0 = suboptimal.
    opt_ratio = len(ref_steps) / len(pred_steps) if (ref_steps and pred_steps) else -1
    first_dev = first_deviation_step(pred_steps, ref_steps)
    print("4) optimality_ratio =", round(opt_ratio, 4), ", first_ref_deviation_step =", first_dev)
    assert abs(opt_ratio - (1.0 / 1.125)) < 0.01, f"Expected opt_ratio ~{1.0/1.125:.4f} got {opt_ratio}"
    assert first_dev == 2, f"Expected first_ref_deviation_step=2 got {first_dev}"
    print("OK: extraction and metrics consistent.")


if __name__ == "__main__":
    main()

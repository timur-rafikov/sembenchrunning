"""Ad-hoc diagnostic: inspect goal-reaching optimality ratio on a few saved examples."""
import json
import sys
from pathlib import Path

# Add project root
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from metrics.plan_utils import pddl_plan_to_steps

def main():
    base = Path(__file__).resolve().parent.parent
    run_path = base / "runs/batch_samples/finance__payments_settlement__rtp_fallback_channel_switching__minimax_minimax-m2.5.json"
    with open(run_path, encoding="utf-8") as f:
        d = json.load(f)
    pred = d.get("plan_pred_pddl") or ""
    pred_steps = pddl_plan_to_steps(pred)
    ref_path = base / "data/batch_samples/finance/payments_settlement/rtp_fallback_channel_switching/rtp_fallback_channel_switching_plan.pddl"
    ref_steps = pddl_plan_to_steps(ref_path.read_text(encoding="utf-8"))
    print("rtp_fallback_channel_switching:")
    print("  ref_steps:", len(ref_steps))
    print("  pred_steps:", len(pred_steps))
    print("  ratio (pred/ref):", round(len(pred_steps) / len(ref_steps), 4) if ref_steps else "N/A")
    if pred_steps:
        print("  pred first line len:", len(pred_steps[0]), "sample:", repr(pred_steps[0][:80]))

    # sev1_incident: ref 64, pred ~60 -> ratio ~0.94
    run_path2 = base / "runs/batch_samples/programming__incident_change_response__sev1_incident_command_orchestration__minimax_minimax-m2.5.json"
    if run_path2.exists():
        with open(run_path2, encoding="utf-8") as f:
            d2 = json.load(f)
        pred2 = d2.get("plan_pred_pddl") or ""
        ref_path2 = base / "data/batch_samples/programming/incident_change_response/sev1_incident_command_orchestration/sev1_incident_command_orchestration_plan.pddl"
        ref_steps2 = pddl_plan_to_steps(ref_path2.read_text(encoding="utf-8"))
        pred_steps2 = pddl_plan_to_steps(pred2)
        print("\nsev1_incident_command_orchestration:")
        print("  ref_steps:", len(ref_steps2))
        print("  pred_steps:", len(pred_steps2))
        print("  ratio (pred/ref):", round(len(pred_steps2) / len(ref_steps2), 4) if ref_steps2 else "N/A")

if __name__ == "__main__":
    main()

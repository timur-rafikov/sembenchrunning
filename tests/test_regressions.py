import json
import sys
import unittest
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from autoplanbench_utils import ensure_domain_json
from dataset_contracts import domain_setup_subdir_relative, normalize_dataset_dir, parse_example_id
from metrics.metrics import compute_metrics
from metrics.val_runner import ValResult
from openrouter_client import (
  _extract_choice_error_info,
  _is_transient_error_info,
  chat_completion_body_model_fields,
  extract_openrouter_usage_from_error_body,
)
from pipeline_usage import (
    annotate_nl2pddl_openrouter_usage,
    build_pipeline_usage,
    normalize_openrouter_usage_counts,
    planning_usage_from_run_data,
)


class RegressionTests(unittest.TestCase):
    def test_choice_error_helpers_detect_transient_provider_failures(self) -> None:
        response = {
            "choices": [
                {
                    "error": {
                        "code": 502,
                        "message": "Network connection lost.",
                        "metadata": {"error_type": "provider_unavailable"},
                    }
                }
            ]
        }
        error_info = _extract_choice_error_info(response)
        self.assertIsNotNone(error_info)
        assert error_info is not None
        self.assertTrue(_is_transient_error_info(error_info))

    def test_build_pipeline_usage_ignores_untracked_usage_in_totals(self) -> None:
        usage = build_pipeline_usage(
            planning={"prompt_tokens": 10, "completion_tokens": 5, "total_tokens": 15, "cost": 0.5, "tracked": True},
            pddl2nl={"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0, "cost": 0.0, "tracked": False},
            nl2pddl={"prompt_tokens": 999, "completion_tokens": 999, "total_tokens": 1998, "cost": 9.99, "tracked": False},
            domain_setup={
                "prompt_tokens": 7,
                "completion_tokens": 3,
                "total_tokens": 10,
                "cost": 0.2,
                "tracked": False,
                "included_in_per_run_totals": False,
            },
        )
        # domain_setup не входит в per-run totals; nl2pddl untracked и p2n untracked исключены
        self.assertEqual(usage["totals"]["prompt_tokens"], 10)
        self.assertEqual(usage["totals"]["completion_tokens"], 5)
        self.assertEqual(usage["totals"]["total_tokens"], 15)
        self.assertAlmostEqual(usage["totals"]["cost"], 0.5)
        self.assertIn("totals_scope_note", usage)

    def test_extract_usage_from_error_body_nested(self) -> None:
        body = {"error": {"message": "fail"}, "usage": {"prompt_tokens": 3, "completion_tokens": 1, "total_tokens": 4}}
        u = extract_openrouter_usage_from_error_body(body)
        self.assertIsNotNone(u)
        assert u is not None
        self.assertEqual(u.get("prompt_tokens"), 3)

    def test_planning_usage_from_recovered_and_error_note(self) -> None:
        data = {
            "error": {"type": "OpenRouterAPIError"},
            "openrouter_usage_recovered": {"prompt_tokens": 2, "completion_tokens": 1, "total_tokens": 3, "cost": 0.01},
        }
        p = planning_usage_from_run_data(data)
        self.assertIsNotNone(p)
        assert p is not None
        self.assertEqual(p.get("prompt_tokens"), 2)
        self.assertIn("billing_context_note", p)

    def test_planning_usage_normalizes_zero_total_tokens(self) -> None:
        data = {
            "openrouter_response": {
                "usage": {"prompt_tokens": 10, "completion_tokens": 5, "total_tokens": 0},
            }
        }
        p = planning_usage_from_run_data(data)
        self.assertIsNotNone(p)
        assert p is not None
        self.assertEqual(p.get("total_tokens"), 15)

    def test_normalize_openrouter_usage_counts_input_output_aliases(self) -> None:
        n = normalize_openrouter_usage_counts({"input_tokens": 7, "output_tokens": 3, "total_tokens": 10})
        self.assertEqual(n["prompt_tokens"], 7)
        self.assertEqual(n["completion_tokens"], 3)
        self.assertEqual(n["total_tokens"], 10)

    def test_annotate_nl2pddl_marks_untracked_when_api_log_and_zero_usage(self) -> None:
        ou = {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0, "cost": 0.0}
        ann = annotate_nl2pddl_openrouter_usage(ou, stdout_text="[OpenRouter] Sending request\n")
        self.assertFalse(ann.get("tracked"))

    def test_annotate_nl2pddl_tracked_when_only_input_output_aliases(self) -> None:
        ou = {"input_tokens": 40, "output_tokens": 12}
        ann = annotate_nl2pddl_openrouter_usage(ou, stdout_text="")
        self.assertTrue(ann.get("tracked"))
        self.assertEqual(ann.get("prompt_tokens"), 40)
        self.assertEqual(ann.get("completion_tokens"), 12)

    def test_chat_completion_body_matches_openrouter_snapshot(self) -> None:
        cfg = {
            "model": "openai/gpt-5-mini",
            "max_output_tokens": 100,
            "temperature": 0.2,
            "reasoning": "high",
        }
        body = chat_completion_body_model_fields(cfg)
        self.assertEqual(body["model"], "openai/gpt-5-mini")
        self.assertEqual(body["max_tokens"], 100)
        self.assertEqual(body["max_output_tokens"], 100)
        self.assertEqual(body["temperature"], 0.2)
        self.assertEqual(body["reasoning"], {"effort": "high"})

    def test_optimality_ratio_requires_goal_reached(self) -> None:
        with patch(
            "metrics.metrics.run_val",
            return_value=ValResult(
                executable=True,
                goal_reached=False,
                exit_code=0,
                stdout="",
                stderr="",
                first_failing_step=None,
            ),
        ):
            metrics = compute_metrics(
                domain_pddl="(define (domain d))",
                problem_pddl="(define (problem p))",
                plan_pred_pddl="(a)\n(b)\n",
                plan_ref_pddl="(a)\n(b)\n(c)\n",
            )
        self.assertEqual(metrics.optimality_ratio, -1.0)
        # Pred (a)(b) vs ref (a)(b)(c): first deviation at step 3 (length mismatch).
        self.assertEqual(metrics.first_ref_deviation_step, 3)
        self.assertEqual(metrics.first_val_failure_step, -1)

    def test_empty_pred_goal_reached_reports_zero_optimality_ratio(self) -> None:
        with patch(
            "metrics.metrics.run_val",
            return_value=ValResult(
                executable=True,
                goal_reached=True,
                exit_code=0,
                stdout="",
                stderr="",
                first_failing_step=None,
            ),
        ):
            metrics = compute_metrics(
                domain_pddl="(define (domain d))",
                problem_pddl="(define (problem p))",
                plan_pred_pddl="",
                plan_ref_pddl="(a)\n(b)\n",
            )
        self.assertEqual(metrics.optimality_ratio, 0.0)
        self.assertEqual(metrics.first_ref_deviation_step, 1)

    def test_goal_reached_plan_reports_ref_deviation(self) -> None:
        with patch(
            "metrics.metrics.run_val",
            return_value=ValResult(
                executable=True,
                goal_reached=True,
                exit_code=0,
                stdout="",
                stderr="",
                first_failing_step=None,
            ),
        ):
            metrics = compute_metrics(
                domain_pddl="(define (domain d))",
                problem_pddl="(define (problem p))",
                plan_pred_pddl="(a)\n(c)\n",
                plan_ref_pddl="(a)\n(b)\n",
            )
        self.assertEqual(metrics.optimality_ratio, 1.0)
        self.assertEqual(metrics.first_ref_deviation_step, 2)

    def test_dataset_contracts_parse_and_domain_setup_dir(self) -> None:
        self.assertEqual(parse_example_id("finance__ops"), ("finance", "ops", None))
        self.assertEqual(parse_example_id("finance__ops__42"), ("finance", "ops", 42))
        self.assertEqual(
            parse_example_id("finance__ops__sample_a"),
            ("finance", "ops", "sample_a"),
        )
        self.assertEqual(
            domain_setup_subdir_relative("finance__ops__sample_a"),
            Path("finance") / "ops" / "sample_a",
        )
        self.assertEqual(
            domain_setup_subdir_relative("finance__ops__42"),
            Path("finance") / "ops" / "42",
        )

    def test_normalize_dataset_dir_finds_batch_root(self) -> None:
        with TemporaryDirectory() as tmp:
            root = Path(tmp)
            dataset_root = root / "data" / "batch_samples"
            sample_dir = dataset_root / "finance" / "ops" / "sample_a"
            sample_dir.mkdir(parents=True)
            (sample_dir / "sample.json").write_text(
                json.dumps(
                    {
                        "id": "finance__ops__sample_a",
                        "section": "finance",
                        "subsection": "ops",
                    }
                ),
                encoding="utf-8",
            )
            self.assertEqual(normalize_dataset_dir(root / "data").resolve(), dataset_root.resolve())

    def test_ensure_domain_json_rebuilds_when_input_changes(self) -> None:
        with TemporaryDirectory() as tmp:
            root = Path(tmp)
            dataset_dir = root / "dataset"
            apb_root = root / "apb"
            section_dir = dataset_dir / "finance" / "ops"
            section_dir.mkdir(parents=True)
            apb_root.mkdir(parents=True)
            (apb_root / "run_domain_setup.py").write_text("# stub\n", encoding="utf-8")

            domain_path = root / "domain.pddl"
            problem_path = root / "problem.pddl"
            domain_path.write_text("(define (domain a))", encoding="utf-8")
            problem_path.write_text("(define (problem a))", encoding="utf-8")

            call_count = {"n": 0}

            def fake_run(cmd, cwd=None, timeout=None, **kwargs):
                call_count["n"] += 1
                out_dir = Path(cmd[cmd.index("-o") + 1])
                seed = cmd[cmd.index("--seed") + 1]
                (out_dir / f"domain_description_seed{seed}.json").write_text(
                    json.dumps({"call": call_count["n"]}),
                    encoding="utf-8",
                )
                (out_dir / f"domain_llm_usage_seed{seed}.json").write_text(
                    json.dumps({"prompt_tokens": 1, "completion_tokens": 2, "total_tokens": 3, "cost": 0.1}),
                    encoding="utf-8",
                )

                class Result:
                    returncode = 0
                    stdout = ""
                    stderr = ""

                return Result()

            with patch("autoplanbench_utils.subprocess.run", side_effect=fake_run):
                first = ensure_domain_json(
                    dataset_dir=dataset_dir,
                    section="finance/ops",
                    first_domain_pddl=domain_path,
                    first_problem_pddl=problem_path,
                    apb_root=apb_root,
                    llm="model-a",
                    seed=0,
                )
                second = ensure_domain_json(
                    dataset_dir=dataset_dir,
                    section="finance/ops",
                    first_domain_pddl=domain_path,
                    first_problem_pddl=problem_path,
                    apb_root=apb_root,
                    llm="model-a",
                    seed=0,
                )
                self.assertEqual(first, second)
                self.assertEqual(call_count["n"], 1)

                domain_path.write_text("(define (domain changed))", encoding="utf-8")
                ensure_domain_json(
                    dataset_dir=dataset_dir,
                    section="finance/ops",
                    first_domain_pddl=domain_path,
                    first_problem_pddl=problem_path,
                    apb_root=apb_root,
                    llm="model-a",
                    seed=0,
                )
                self.assertEqual(call_count["n"], 2)


if __name__ == "__main__":
    unittest.main()

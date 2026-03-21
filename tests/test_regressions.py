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
from openrouter_client import _extract_choice_error_info, _is_transient_error_info
from pipeline_usage import build_pipeline_usage


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
            pddl2nl={"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0, "cost": 0.0, "tracked": True},
            nl2pddl={"prompt_tokens": 999, "completion_tokens": 999, "total_tokens": 1998, "cost": 9.99, "tracked": False},
            domain_setup={"prompt_tokens": 7, "completion_tokens": 3, "total_tokens": 10, "cost": 0.2, "tracked": True},
        )
        self.assertEqual(usage["totals"]["prompt_tokens"], 17)
        self.assertEqual(usage["totals"]["completion_tokens"], 8)
        self.assertEqual(usage["totals"]["total_tokens"], 25)
        self.assertAlmostEqual(usage["totals"]["cost"], 0.7)

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
        self.assertEqual(metrics.first_ref_deviation_step, -1)
        self.assertEqual(metrics.first_val_failure_step, -1)

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
        self.assertEqual(metrics.first_error_step, 2)

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

            def fake_run(cmd, cwd, capture_output, text, timeout, encoding):
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

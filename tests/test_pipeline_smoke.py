import asyncio
import json
import sys
import unittest
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import run_benchmark
from metrics.val_runner import ValResult


class _FakeOpenRouterClient:
    def __init__(self, settings):
        self.settings = settings

    async def __aenter__(self):
        return self

    async def __aexit__(self, exc_type, exc, tb):
        return None

    async def generate_plan(self, model_cfg, prompt):
        return {
            "id": "fake-response",
            "choices": [
                {
                    "message": {
                        "role": "assistant",
                        "content": "do step a\ndo step b",
                    },
                    "finish_reason": "stop",
                    "native_finish_reason": "stop",
                }
            ],
            "usage": {
                "prompt_tokens": 12,
                "completion_tokens": 4,
                "total_tokens": 16,
                "cost": 0.01,
            },
        }


class PipelineSmokeTests(unittest.TestCase):
    def test_run_and_metrics_pipeline_without_network(self) -> None:
        with TemporaryDirectory() as tmp:
            root = Path(tmp)
            dataset_dir = root / "data" / "batch_samples"
            sample_dir = dataset_dir / "finance" / "ops" / "sample_a"
            sample_dir.mkdir(parents=True)

            (dataset_dir / "prompt_template.txt").write_text("Solve the planning task.", encoding="utf-8")
            (sample_dir / "sample_a_domain.pddl").write_text("(define (domain smoke))", encoding="utf-8")
            (sample_dir / "sample_a_problem.pddl").write_text("(define (problem smoke-problem))", encoding="utf-8")
            (sample_dir / "sample_a_plan.pddl").write_text("(step-a)\n(step-b)\n", encoding="utf-8")
            (sample_dir / "sample.json").write_text(
                json.dumps(
                    {
                        "id": "finance__ops__sample_a",
                        "section": "finance",
                        "subsection": "ops",
                        "domain_path": "sample_a_domain.pddl",
                        "problem_path": "sample_a_problem.pddl",
                        "plan_ref_path": "sample_a_plan.pddl",
                    }
                ),
                encoding="utf-8",
            )

            output_dir = root / "runs" / "latest"
            cfg = {
                "openrouter": {
                    "api_key_env": "OPENROUTER_API_KEY",
                    "max_concurrent_requests": 1,
                    "timeout_seconds": 10,
                    "max_retries": 0,
                    "retry_backoff_seconds": 0.0,
                },
                "models": {
                    "fake/model": {
                        "model": "fake/model",
                        "max_output_tokens": 128,
                    }
                },
            }

            def fake_prompt_translator(domain_pddl, problem_pddl, **kwargs):
                return f"DOMAIN\n{domain_pddl}\nPROBLEM\n{problem_pddl}"

            def fake_nl2pddl(nl_plan, **kwargs):
                return "(step-a)\n(step-b)\n"

            with patch.dict("os.environ", {"OPENROUTER_API_KEY": "test-key"}, clear=False):
                with patch("run_benchmark._load_prompt_translator", return_value=fake_prompt_translator), patch(
                    "run_benchmark.OpenRouterClient", _FakeOpenRouterClient
                ):
                    asyncio.run(
                        run_benchmark.run_for_model_from_dataset(
                            cfg=cfg,
                            model_name="fake/model",
                            dataset_dir=dataset_dir,
                            prompt_translator_spec="fake:prompt",
                            output_dir=output_dir,
                            max_concurrent=1,
                            batch_size=1,
                            limit=None,
                            ensure_domain_json_opts=None,
                            translate_workers=0,
                        )
                    )

                with patch("run_benchmark._load_translator", return_value=fake_nl2pddl), patch(
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
                    run_benchmark.compute_metrics_phase(
                        output_dir=output_dir,
                        dataset_dir=dataset_dir,
                        translator_spec="fake:nl2pddl",
                        val_binary="validate",
                        nl2pddl_workers=0,
                    )

            run_files = list(output_dir.glob("*__*.json"))
            self.assertTrue(run_files)
            run_payload = json.loads(run_files[0].read_text(encoding="utf-8"))
            self.assertEqual(run_payload["id"], "finance__ops__sample_a")
            self.assertEqual(run_payload["nl2pddl_status"], "ok")
            self.assertIn("plan_pred_pddl", run_payload)
            self.assertIn("openrouter_request", run_payload)
            self.assertEqual(run_payload["openrouter_request"].get("model"), "fake/model")
            self.assertEqual(run_payload["openrouter_request"].get("max_output_tokens"), 128)
            self.assertEqual(run_payload["openrouter_request"].get("max_tokens"), 128)
            self.assertIn("prompt_translator_signature", run_payload.get("sembench_translator_meta", {}))

            metrics_path = output_dir / "metrics.jsonl"
            self.assertTrue(metrics_path.exists())
            rows = [json.loads(line) for line in metrics_path.read_text(encoding="utf-8").splitlines() if line.strip()]
            self.assertEqual(len(rows), 1)
            self.assertEqual(rows[0]["status"], "metrics_computed")
            self.assertTrue(rows[0]["executability"])
            self.assertTrue(rows[0]["reachability"])
            self.assertIn("run_file", rows[0])
            self.assertIn("sembench_translator_meta", rows[0])


if __name__ == "__main__":
    unittest.main()

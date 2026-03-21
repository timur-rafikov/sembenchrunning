#!/usr/bin/env python3
"""
Generate a demo dataset: 2 sections, 3 subsections each, 5 samples per subsection.
Section blocks_world has more errors (wrong plans); section logistics has fewer.
Also writes fake run JSONs with plan_pred_pddl so metrics can be computed.

Формат данных: одна папка на сэмпл — data/<section>/<subsection>/<N>/
  - <section>_<subsection>_domain.pddl  — домен PDDL
  - <section>_<subsection>_problem.pddl — задача PDDL
  - sample.json — id, section, subsection, domain_path, problem_path, plan_ref_path (и при необходимости метаданные)
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
# Сэмплы в data/<section>/<subsection>/sample_<N>.json (без уровня demo)
DATA_DIR = ROOT / "data"
RUNS_DIR = ROOT / "runs" / "demo"
MODEL_NAME = "openai_gpt-5-mini"

BLOCKS_DOMAIN = """(define (domain blocks)
  (:predicates (on ?x ?y) (ontable ?x) (clear ?x) (handempty) (holding ?x))
  (:action pick-up
    :parameters (?x)
    :precondition (and (clear ?x) (ontable ?x) (handempty))
    :effect (and (not (ontable ?x)) (not (clear ?x)) (not (handempty)) (holding ?x)))
  (:action put-down
    :parameters (?x)
    :precondition (holding ?x)
    :effect (and (ontable ?x) (clear ?x) (handempty) (not (holding ?x))))
  (:action stack
    :parameters (?x ?y)
    :precondition (and (holding ?x) (clear ?y))
    :effect (and (on ?x ?y) (clear ?x) (handempty) (not (holding ?x)) (not (clear ?y))))
  (:action unstack
    :parameters (?x ?y)
    :precondition (and (on ?x ?y) (clear ?x) (handempty))
    :effect (and (holding ?x) (clear ?y) (not (on ?x ?y)) (not (clear ?x)) (not (handempty))))))
"""

LOGISTICS_DOMAIN = """(define (domain logistics)
  (:predicates (truck ?t) (city ?c) (loc ?l) (in-city ?l ?c) (at-truck ?t ?l) (package ?p) (at ?p ?l) (in ?p ?t))
  (:action drive :parameters (?t ?from ?to ?c)
    :precondition (and (truck ?t) (loc ?from) (loc ?to) (city ?c) (in-city ?from ?c) (in-city ?to ?c) (at-truck ?t ?from))
    :effect (and (at-truck ?t ?to) (not (at-truck ?t ?from))))
  (:action load :parameters (?p ?t ?l)
    :precondition (and (package ?p) (truck ?t) (loc ?l) (at ?p ?l) (at-truck ?t ?l))
    :effect (and (in ?p ?t) (not (at ?p ?l))))
  (:action unload :parameters (?p ?t ?l)
    :precondition (and (package ?p) (truck ?t) (loc ?l) (in ?p ?t) (at-truck ?t ?l))
    :effect (and (at ?p ?l) (not (in ?p ?t)))))
"""


def main():
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    RUNS_DIR.mkdir(parents=True, exist_ok=True)

    # Section 1: blocks_world — more errors (wrong/inapplicable/suboptimal)
    # sub1 easy: 1 wrong; sub2 medium: 4 wrong; sub3 hard: 3 wrong
    blocks_problems = [
        # (problem_pddl, plan_ref, plan_pred_correct?)
        (
            "(define (problem p1) (:domain blocks) (:objects A B C) (:init (ontable A) (ontable B) (ontable C) (clear A) (clear B) (clear C) (handempty)) (:goal (and (on A B) (on B C))))",
            "(pick-up A)\n(stack A B)\n(pick-up B)\n(stack B C)",
            True,
        ),
        (
            "(define (problem p2) (:domain blocks) (:objects A B C) (:init (on A B) (on B C) (ontable C) (clear A) (handempty)) (:goal (and (ontable A) (ontable B) (ontable C))))",
            "(unstack A B)\n(put-down A)\n(unstack B C)\n(put-down B)\n(put-down C)",
            True,
        ),
        (
            "(define (problem p3) (:domain blocks) (:objects A B) (:init (ontable A) (ontable B) (clear A) (clear B) (handempty)) (:goal (on A B)))",
            "(pick-up A)\n(stack A B)",
            True,
        ),
        (
            "(define (problem p4) (:domain blocks) (:objects A B C) (:init (ontable A) (ontable B) (ontable C) (clear A) (clear B) (clear C) (handempty)) (:goal (on C A)))",
            "(pick-up C)\n(put-down C)\n(pick-up A)\n(stack A B)\n(pick-up C)\n(stack C A)",
            True,
        ),
        (
            "(define (problem p5) (:domain blocks) (:objects A B) (:init (on A B) (ontable B) (clear A) (handempty)) (:goal (ontable A)))",
            "(unstack A B)\n(put-down A)",
            True,
        ),
    ]

    def wrong_plan(ref: str, domain: str) -> str:
        """Return an invalid or suboptimal plan so VAL/metrics show errors."""
        steps = [s.strip() for s in ref.strip().split("\n") if s.strip()]
        if "blocks" in domain:
            # Inapplicable first step: pick-up B when B is under A
            if len(steps) > 1:
                return "(pick-up B)\n" + "\n".join(steps[1:])
            return "(stack A B)"
        # Logistics: wrong order (unload before load) => invalid
        if len(steps) >= 2:
            return "\n".join(reversed(steps))
        return ref

    # Logistics problems (simple): goal at p1 l2 from l1 => load, drive, unload
    log_problems = [
        ("(define (problem l1) (:domain logistics) (:objects c1 - city l1 l2 - loc t1 - truck p1 - package) (:init (city c1) (loc l1) (loc l2) (in-city l1 c1) (in-city l2 c1) (truck t1) (package p1) (at-truck t1 l1) (at p1 l1)) (:goal (at p1 l2)))", "(load p1 t1 l1)\n(drive t1 l1 l2 c1)\n(unload p1 t1 l2)"),
        ("(define (problem l2) (:domain logistics) (:objects c1 - city l1 l2 - loc t1 - truck p1 - package) (:init (city c1) (loc l1) (loc l2) (in-city l1 c1) (in-city l2 c1) (truck t1) (package p1) (at-truck t1 l2) (at p1 l1)) (:goal (at p1 l2)))", "(drive t1 l2 l1 c1)\n(load p1 t1 l1)\n(drive t1 l1 l2 c1)\n(unload p1 t1 l2)"),
        ("(define (problem l3) (:domain logistics) (:objects c1 - city l1 l2 - loc t1 - truck p1 - package) (:init (city c1) (loc l1) (loc l2) (in-city l1 c1) (in-city l2 c1) (truck t1) (package p1) (at-truck t1 l1) (at p1 l1)) (:goal (at p1 l2)))", "(load p1 t1 l1)\n(drive t1 l1 l2 c1)\n(unload p1 t1 l2)"),
        ("(define (problem l4) (:domain logistics) (:objects c1 - city l1 l2 - loc t1 - truck p1 - package) (:init (city c1) (loc l1) (loc l2) (in-city l1 c1) (in-city l2 c1) (truck t1) (package p1) (at-truck t1 l1) (at p1 l1)) (:goal (in p1 t1)))", "(load p1 t1 l1)"),
        ("(define (problem l5) (:domain logistics) (:objects c1 - city l1 l2 - loc t1 - truck p1 - package) (:init (city c1) (loc l1) (loc l2) (in-city l1 c1) (in-city l2 c1) (truck t1) (package p1) (at-truck t1 l2) (at p1 l2)) (:goal (at p1 l1)))", "(load p1 t1 l2)\n(drive t1 l2 l1 c1)\n(unload p1 t1 l1)"),
    ]

    for section, subsection, triples in [
        ("blocks_world", "easy", [(blocks_problems[i][0], blocks_problems[i][1], blocks_problems[i][2] if i != 2 else False) for i in range(5)]),
        ("blocks_world", "medium", [(blocks_problems[i][0], blocks_problems[i][1], i >= 4) for i in range(5)]),
        ("blocks_world", "hard", [(blocks_problems[i][0], blocks_problems[i][1], i >= 2) for i in range(5)]),
        ("logistics", "easy", [(log_problems[i][0], log_problems[i][1], True) for i in range(5)]),
        ("logistics", "medium", [(log_problems[i][0], log_problems[i][1], i != 2) for i in range(5)]),
        ("logistics", "hard", [(log_problems[i][0], log_problems[i][1], True) for i in range(5)]),
    ]:
        domain = BLOCKS_DOMAIN if section == "blocks_world" else LOGISTICS_DOMAIN
        subdir = DATA_DIR / section / subsection
        subdir.mkdir(parents=True, exist_ok=True)

        domain_fname = f"{section}_{subsection}_domain.pddl"
        problem_fname = f"{section}_{subsection}_problem.pddl"
        plan_fname = f"{section}_{subsection}_plan.pddl"

        for idx, (problem_pddl, plan_ref, correct) in enumerate(triples, start=1):
            example_id = f"{section}__{subsection}__{idx}"
            if plan_ref is None:
                continue
            plan_pred = plan_ref if correct else wrong_plan(plan_ref, domain)

            # Одна папка на сэмпл: data/<section>/<subsection>/<idx>/
            sample_dir = subdir / str(idx)
            sample_dir.mkdir(parents=True, exist_ok=True)
            (sample_dir / domain_fname).write_text(domain, encoding="utf-8")
            (sample_dir / problem_fname).write_text(problem_pddl, encoding="utf-8")
            (sample_dir / plan_fname).write_text(plan_ref, encoding="utf-8")

            sample = {
                "id": example_id,
                "section": section,
                "subsection": subsection,
                "domain_path": domain_fname,
                "problem_path": problem_fname,
                "plan_ref_path": plan_fname,
            }
            sample_path = sample_dir / "sample.json"
            sample_path.write_text(json.dumps(sample, ensure_ascii=False, indent=2), encoding="utf-8")

            run_payload = {
                "id": example_id,
                "model_name": "openai/gpt-5-mini",
                "model": "openai/gpt-5-mini",
                "plan_pred_pddl": plan_pred,
            }
            run_subdir = RUNS_DIR / section / subsection
            run_subdir.mkdir(parents=True, exist_ok=True)
            run_path = run_subdir / f"{example_id.replace('/', '_')}__{MODEL_NAME}.json"
            run_path.write_text(json.dumps(run_payload, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"Generated: {DATA_DIR} ({sum(1 for _ in DATA_DIR.rglob('sample.json'))} samples)")
    print(f"Fake runs: {RUNS_DIR} ({len(list(RUNS_DIR.rglob('*__*.json')))} files)")


if __name__ == "__main__":
    main()

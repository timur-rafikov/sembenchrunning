(define (domain programming_release_rollout_control)
  (:requirements :strips :typing :negative-preconditions)
  (:types release - object customer_tier - object deployment_target - object dependency_service - object canary_policy - object infrastructure_constraint - object cohort - object approver - object build_artifact - object automation_job - object integration_test_suite - object rollback_plan - object verification_artifact - object smoke_suite - verification_artifact observability_check - verification_artifact rollout_unit - release control_unit - release)
  (:predicates
    (release_registered ?release - release)
    (release_assigned_tier ?release - release ?customer_tier - customer_tier)
    (release_tier_reserved ?release - release)
    (release_cohort_enabled ?release - release)
    (release_cohort_validated ?release - release)
    (release_canary_bound ?release - release ?canary_policy - canary_policy)
    (release_dependency_bound ?release - release ?dependency_service - dependency_service)
    (release_infra_bound ?release - release ?infrastructure_constraint - infrastructure_constraint)
    (release_rollback_attached ?release - release ?rollback_plan - rollback_plan)
    (release_deployed_to_target ?release - release ?deployment_target - deployment_target)
    (release_deployment_confirmed ?release - release)
    (release_validation_gate_passed ?release - release)
    (release_build_selection_confirmed ?release - release)
    (release_finalized ?release - release)
    (release_pending_signoff ?release - release)
    (release_promoted ?release - release)
    (control_unit_build_compatible ?release - release ?build_artifact - build_artifact)
    (control_unit_build_bound ?release - release ?build_artifact - build_artifact)
    (automation_validation_passed ?release - release)
    (tier_available ?customer_tier - customer_tier)
    (target_available ?deployment_target - deployment_target)
    (canary_policy_available ?canary_policy - canary_policy)
    (dependency_service_available ?dependency_service - dependency_service)
    (infra_constraint_available ?infrastructure_constraint - infrastructure_constraint)
    (cohort_available ?cohort - cohort)
    (approver_available ?operator_approval - approver)
    (build_artifact_available ?build_artifact - build_artifact)
    (automation_job_available ?automation_job - automation_job)
    (integration_test_suite_available ?integration_test_suite - integration_test_suite)
    (rollback_plan_available ?rollback_plan - rollback_plan)
    (release_tier_compatible ?release - release ?customer_tier - customer_tier)
    (release_target_compatible ?release - release ?deployment_target - deployment_target)
    (release_canary_compatible ?release - release ?canary_policy - canary_policy)
    (release_dependency_compatible ?release - release ?dependency_service - dependency_service)
    (release_infra_compatible ?release - release ?infrastructure_constraint - infrastructure_constraint)
    (release_integration_test_compatible ?release - release ?integration_test_suite - integration_test_suite)
    (release_rollback_compatible ?release - release ?rollback_plan - rollback_plan)
    (release_verification_artifact_compatible ?release - release ?verification_artifact - verification_artifact)
    (rollout_unit_build_compatible ?release - release ?build_artifact - build_artifact)
    (primary_unit_flag ?release - release)
    (control_unit_flag ?release - release)
    (release_cohort_reserved ?release - release ?cohort - cohort)
    (release_requires_additional_review ?release - release)
    (rollout_unit_build_slot_binding ?release - release ?build_artifact - build_artifact)
  )
  (:action initialize_release
    :parameters (?release - release)
    :precondition
      (and
        (not
          (release_registered ?release)
        )
        (not
          (release_finalized ?release)
        )
      )
    :effect
      (and
        (release_registered ?release)
      )
  )
  (:action assign_release_to_tier
    :parameters (?release - release ?customer_tier - customer_tier)
    :precondition
      (and
        (release_registered ?release)
        (tier_available ?customer_tier)
        (release_tier_compatible ?release ?customer_tier)
        (not
          (release_tier_reserved ?release)
        )
      )
    :effect
      (and
        (release_assigned_tier ?release ?customer_tier)
        (release_tier_reserved ?release)
        (not
          (tier_available ?customer_tier)
        )
      )
  )
  (:action unassign_release_from_tier
    :parameters (?release - release ?customer_tier - customer_tier)
    :precondition
      (and
        (release_assigned_tier ?release ?customer_tier)
        (not
          (release_deployment_confirmed ?release)
        )
        (not
          (release_validation_gate_passed ?release)
        )
      )
    :effect
      (and
        (not
          (release_assigned_tier ?release ?customer_tier)
        )
        (not
          (release_tier_reserved ?release)
        )
        (not
          (release_cohort_enabled ?release)
        )
        (not
          (release_cohort_validated ?release)
        )
        (not
          (release_pending_signoff ?release)
        )
        (not
          (release_promoted ?release)
        )
        (not
          (release_requires_additional_review ?release)
        )
        (tier_available ?customer_tier)
      )
  )
  (:action reserve_cohort_for_release
    :parameters (?release - release ?cohort - cohort)
    :precondition
      (and
        (release_registered ?release)
        (cohort_available ?cohort)
      )
    :effect
      (and
        (release_cohort_reserved ?release ?cohort)
        (not
          (cohort_available ?cohort)
        )
      )
  )
  (:action release_cohort_reservation
    :parameters (?release - release ?cohort - cohort)
    :precondition
      (and
        (release_cohort_reserved ?release ?cohort)
      )
    :effect
      (and
        (cohort_available ?cohort)
        (not
          (release_cohort_reserved ?release ?cohort)
        )
      )
  )
  (:action enable_cohort_for_release
    :parameters (?release - release ?cohort - cohort)
    :precondition
      (and
        (release_registered ?release)
        (release_tier_reserved ?release)
        (release_cohort_reserved ?release ?cohort)
        (not
          (release_cohort_enabled ?release)
        )
      )
    :effect
      (and
        (release_cohort_enabled ?release)
      )
  )
  (:action enable_cohort_with_approver
    :parameters (?release - release ?operator_approval - approver)
    :precondition
      (and
        (release_registered ?release)
        (release_tier_reserved ?release)
        (approver_available ?operator_approval)
        (not
          (release_cohort_enabled ?release)
        )
      )
    :effect
      (and
        (release_cohort_enabled ?release)
        (release_pending_signoff ?release)
        (not
          (approver_available ?operator_approval)
        )
      )
  )
  (:action validate_cohort_with_automation
    :parameters (?release - release ?cohort - cohort ?automation_job - automation_job)
    :precondition
      (and
        (release_cohort_enabled ?release)
        (release_tier_reserved ?release)
        (release_cohort_reserved ?release ?cohort)
        (automation_job_available ?automation_job)
        (not
          (release_cohort_validated ?release)
        )
      )
    :effect
      (and
        (release_cohort_validated ?release)
        (not
          (release_pending_signoff ?release)
        )
      )
  )
  (:action validate_cohort_with_build
    :parameters (?release - release ?build_artifact - build_artifact)
    :precondition
      (and
        (release_tier_reserved ?release)
        (control_unit_build_bound ?release ?build_artifact)
        (not
          (release_cohort_validated ?release)
        )
      )
    :effect
      (and
        (release_cohort_validated ?release)
        (not
          (release_pending_signoff ?release)
        )
      )
  )
  (:action bind_canary_policy
    :parameters (?release - release ?canary_policy - canary_policy)
    :precondition
      (and
        (release_registered ?release)
        (canary_policy_available ?canary_policy)
        (release_canary_compatible ?release ?canary_policy)
      )
    :effect
      (and
        (release_canary_bound ?release ?canary_policy)
        (not
          (canary_policy_available ?canary_policy)
        )
      )
  )
  (:action unbind_canary_policy
    :parameters (?release - release ?canary_policy - canary_policy)
    :precondition
      (and
        (release_canary_bound ?release ?canary_policy)
      )
    :effect
      (and
        (canary_policy_available ?canary_policy)
        (not
          (release_canary_bound ?release ?canary_policy)
        )
      )
  )
  (:action bind_dependency_service
    :parameters (?release - release ?dependency_service - dependency_service)
    :precondition
      (and
        (release_registered ?release)
        (dependency_service_available ?dependency_service)
        (release_dependency_compatible ?release ?dependency_service)
      )
    :effect
      (and
        (release_dependency_bound ?release ?dependency_service)
        (not
          (dependency_service_available ?dependency_service)
        )
      )
  )
  (:action unbind_dependency_service
    :parameters (?release - release ?dependency_service - dependency_service)
    :precondition
      (and
        (release_dependency_bound ?release ?dependency_service)
      )
    :effect
      (and
        (dependency_service_available ?dependency_service)
        (not
          (release_dependency_bound ?release ?dependency_service)
        )
      )
  )
  (:action bind_infrastructure_constraint
    :parameters (?release - release ?infrastructure_constraint - infrastructure_constraint)
    :precondition
      (and
        (release_registered ?release)
        (infra_constraint_available ?infrastructure_constraint)
        (release_infra_compatible ?release ?infrastructure_constraint)
      )
    :effect
      (and
        (release_infra_bound ?release ?infrastructure_constraint)
        (not
          (infra_constraint_available ?infrastructure_constraint)
        )
      )
  )
  (:action unbind_infrastructure_constraint
    :parameters (?release - release ?infrastructure_constraint - infrastructure_constraint)
    :precondition
      (and
        (release_infra_bound ?release ?infrastructure_constraint)
      )
    :effect
      (and
        (infra_constraint_available ?infrastructure_constraint)
        (not
          (release_infra_bound ?release ?infrastructure_constraint)
        )
      )
  )
  (:action attach_rollback_plan
    :parameters (?release - release ?rollback_plan - rollback_plan)
    :precondition
      (and
        (release_registered ?release)
        (rollback_plan_available ?rollback_plan)
        (release_rollback_compatible ?release ?rollback_plan)
      )
    :effect
      (and
        (release_rollback_attached ?release ?rollback_plan)
        (not
          (rollback_plan_available ?rollback_plan)
        )
      )
  )
  (:action detach_rollback_plan
    :parameters (?release - release ?rollback_plan - rollback_plan)
    :precondition
      (and
        (release_rollback_attached ?release ?rollback_plan)
      )
    :effect
      (and
        (rollback_plan_available ?rollback_plan)
        (not
          (release_rollback_attached ?release ?rollback_plan)
        )
      )
  )
  (:action deploy_to_target_with_bindings
    :parameters (?release - release ?deployment_target - deployment_target ?canary_policy - canary_policy ?dependency_service - dependency_service)
    :precondition
      (and
        (release_tier_reserved ?release)
        (release_canary_bound ?release ?canary_policy)
        (release_dependency_bound ?release ?dependency_service)
        (target_available ?deployment_target)
        (release_target_compatible ?release ?deployment_target)
        (not
          (release_deployment_confirmed ?release)
        )
      )
    :effect
      (and
        (release_deployed_to_target ?release ?deployment_target)
        (release_deployment_confirmed ?release)
        (not
          (target_available ?deployment_target)
        )
      )
  )
  (:action deploy_to_target_with_infra_and_tests
    :parameters (?release - release ?deployment_target - deployment_target ?infrastructure_constraint - infrastructure_constraint ?integration_test_suite - integration_test_suite)
    :precondition
      (and
        (release_tier_reserved ?release)
        (release_infra_bound ?release ?infrastructure_constraint)
        (integration_test_suite_available ?integration_test_suite)
        (target_available ?deployment_target)
        (release_target_compatible ?release ?deployment_target)
        (release_integration_test_compatible ?release ?integration_test_suite)
        (not
          (release_deployment_confirmed ?release)
        )
      )
    :effect
      (and
        (release_deployed_to_target ?release ?deployment_target)
        (release_deployment_confirmed ?release)
        (release_requires_additional_review ?release)
        (release_pending_signoff ?release)
        (not
          (target_available ?deployment_target)
        )
        (not
          (integration_test_suite_available ?integration_test_suite)
        )
      )
  )
  (:action clear_review_flag_after_validation
    :parameters (?release - release ?canary_policy - canary_policy ?dependency_service - dependency_service)
    :precondition
      (and
        (release_deployment_confirmed ?release)
        (release_requires_additional_review ?release)
        (release_canary_bound ?release ?canary_policy)
        (release_dependency_bound ?release ?dependency_service)
      )
    :effect
      (and
        (not
          (release_requires_additional_review ?release)
        )
        (not
          (release_pending_signoff ?release)
        )
      )
  )
  (:action mark_validation_gate_passed
    :parameters (?release - release ?canary_policy - canary_policy ?dependency_service - dependency_service ?smoke_suite - smoke_suite)
    :precondition
      (and
        (release_cohort_validated ?release)
        (release_deployment_confirmed ?release)
        (release_canary_bound ?release ?canary_policy)
        (release_dependency_bound ?release ?dependency_service)
        (release_verification_artifact_compatible ?release ?smoke_suite)
        (not
          (release_pending_signoff ?release)
        )
        (not
          (release_validation_gate_passed ?release)
        )
      )
    :effect
      (and
        (release_validation_gate_passed ?release)
      )
  )
  (:action mark_validation_gate_with_rollback
    :parameters (?release - release ?infrastructure_constraint - infrastructure_constraint ?rollback_plan - rollback_plan ?observability_check - observability_check)
    :precondition
      (and
        (release_cohort_validated ?release)
        (release_deployment_confirmed ?release)
        (release_infra_bound ?release ?infrastructure_constraint)
        (release_rollback_attached ?release ?rollback_plan)
        (release_verification_artifact_compatible ?release ?observability_check)
        (not
          (release_validation_gate_passed ?release)
        )
      )
    :effect
      (and
        (release_validation_gate_passed ?release)
        (release_pending_signoff ?release)
      )
  )
  (:action promote_release_wave
    :parameters (?release - release ?canary_policy - canary_policy ?dependency_service - dependency_service)
    :precondition
      (and
        (release_validation_gate_passed ?release)
        (release_pending_signoff ?release)
        (release_canary_bound ?release ?canary_policy)
        (release_dependency_bound ?release ?dependency_service)
      )
    :effect
      (and
        (release_promoted ?release)
        (not
          (release_pending_signoff ?release)
        )
        (not
          (release_cohort_validated ?release)
        )
        (not
          (release_requires_additional_review ?release)
        )
      )
  )
  (:action revalidate_after_promotion
    :parameters (?release - release ?cohort - cohort ?automation_job - automation_job)
    :precondition
      (and
        (release_promoted ?release)
        (release_validation_gate_passed ?release)
        (release_tier_reserved ?release)
        (release_cohort_reserved ?release ?cohort)
        (automation_job_available ?automation_job)
        (not
          (release_cohort_validated ?release)
        )
      )
    :effect
      (and
        (release_cohort_validated ?release)
      )
  )
  (:action select_cohort_for_build_association
    :parameters (?release - release ?cohort - cohort)
    :precondition
      (and
        (release_validation_gate_passed ?release)
        (release_cohort_validated ?release)
        (not
          (release_pending_signoff ?release)
        )
        (release_cohort_reserved ?release ?cohort)
        (not
          (release_build_selection_confirmed ?release)
        )
      )
    :effect
      (and
        (release_build_selection_confirmed ?release)
      )
  )
  (:action select_cohort_for_approver_build_association
    :parameters (?release - release ?operator_approval - approver)
    :precondition
      (and
        (release_validation_gate_passed ?release)
        (release_cohort_validated ?release)
        (not
          (release_pending_signoff ?release)
        )
        (approver_available ?operator_approval)
        (not
          (release_build_selection_confirmed ?release)
        )
      )
    :effect
      (and
        (release_build_selection_confirmed ?release)
        (not
          (approver_available ?operator_approval)
        )
      )
  )
  (:action associate_build_with_release
    :parameters (?release - release ?build_artifact - build_artifact)
    :precondition
      (and
        (release_build_selection_confirmed ?release)
        (build_artifact_available ?build_artifact)
        (rollout_unit_build_slot_binding ?release ?build_artifact)
      )
    :effect
      (and
        (rollout_unit_build_compatible ?release ?build_artifact)
        (not
          (build_artifact_available ?build_artifact)
        )
      )
  )
  (:action associate_build_with_control_and_rollout_unit
    :parameters (?control_unit - control_unit ?rollout_unit - rollout_unit ?build_artifact - build_artifact)
    :precondition
      (and
        (release_registered ?control_unit)
        (control_unit_flag ?control_unit)
        (control_unit_build_compatible ?control_unit ?build_artifact)
        (rollout_unit_build_compatible ?rollout_unit ?build_artifact)
        (not
          (control_unit_build_bound ?control_unit ?build_artifact)
        )
      )
    :effect
      (and
        (control_unit_build_bound ?control_unit ?build_artifact)
      )
  )
  (:action mark_automation_validation
    :parameters (?release - release ?cohort - cohort ?automation_job - automation_job)
    :precondition
      (and
        (release_registered ?release)
        (control_unit_flag ?release)
        (release_cohort_validated ?release)
        (release_build_selection_confirmed ?release)
        (release_cohort_reserved ?release ?cohort)
        (automation_job_available ?automation_job)
        (not
          (automation_validation_passed ?release)
        )
      )
    :effect
      (and
        (automation_validation_passed ?release)
      )
  )
  (:action finalize_release_for_unit_type_primary
    :parameters (?release - release)
    :precondition
      (and
        (primary_unit_flag ?release)
        (release_registered ?release)
        (release_tier_reserved ?release)
        (release_deployment_confirmed ?release)
        (release_validation_gate_passed ?release)
        (release_build_selection_confirmed ?release)
        (release_cohort_validated ?release)
        (not
          (release_finalized ?release)
        )
      )
    :effect
      (and
        (release_finalized ?release)
      )
  )
  (:action finalize_release_for_unit_with_build
    :parameters (?release - release ?build_artifact - build_artifact)
    :precondition
      (and
        (control_unit_flag ?release)
        (release_registered ?release)
        (release_tier_reserved ?release)
        (release_deployment_confirmed ?release)
        (release_validation_gate_passed ?release)
        (release_build_selection_confirmed ?release)
        (release_cohort_validated ?release)
        (control_unit_build_bound ?release ?build_artifact)
        (not
          (release_finalized ?release)
        )
      )
    :effect
      (and
        (release_finalized ?release)
      )
  )
  (:action finalize_release_for_unit_with_automation_validation
    :parameters (?release - release)
    :precondition
      (and
        (control_unit_flag ?release)
        (release_registered ?release)
        (release_tier_reserved ?release)
        (release_deployment_confirmed ?release)
        (release_validation_gate_passed ?release)
        (release_build_selection_confirmed ?release)
        (release_cohort_validated ?release)
        (automation_validation_passed ?release)
        (not
          (release_finalized ?release)
        )
      )
    :effect
      (and
        (release_finalized ?release)
      )
  )
)

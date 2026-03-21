(define (domain compatibility_matrix_release_gate_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types release - object deployment_wave - object target_environment - object dependent_service - object service_component - object feature_toggle - object deployment_group - object validation_artifact - object approval_policy - object validation_suite - object migration_job - object integration_bundle - object infrastructure_profile - object operator_role - infrastructure_profile stakeholder_role - infrastructure_profile release_variant - release release_anchor - release)
  (:predicates
    (release_registered ?release - release)
    (release_assigned_wave ?release - release ?deployment_wave - deployment_wave)
    (release_wave_enrolled ?release - release)
    (release_stage_prepared ?release - release)
    (release_validated ?release - release)
    (release_bound_component ?release - release ?service_component - service_component)
    (release_bound_service ?release - release ?dependent_service - dependent_service)
    (release_bound_toggle ?release - release ?feature_toggle - feature_toggle)
    (release_bound_integration ?release - release ?integration_bundle - integration_bundle)
    (release_targeted_environment ?release - release ?target_environment - target_environment)
    (release_promotable ?release - release)
    (release_approved ?release - release)
    (release_policy_eligible ?release - release)
    (release_finalized ?release - release)
    (release_migration_required ?release - release)
    (release_promoted ?release - release)
    (release_policy_anchor_binding ?release - release ?approval_policy - approval_policy)
    (release_policy_applied ?release - release ?approval_policy - approval_policy)
    (release_stage_ready ?release - release)
    (deployment_wave_available ?deployment_wave - deployment_wave)
    (environment_available ?target_environment - target_environment)
    (component_available ?service_component - service_component)
    (service_available ?dependent_service - dependent_service)
    (toggle_available ?feature_toggle - feature_toggle)
    (deployment_group_available ?deployment_group - deployment_group)
    (validation_artifact_available ?validation_artifact - validation_artifact)
    (approval_policy_available ?approval_policy - approval_policy)
    (validation_suite_available ?validation_suite - validation_suite)
    (migration_job_available ?migration_job - migration_job)
    (integration_bundle_available ?integration_bundle - integration_bundle)
    (release_compatible_with_wave ?release - release ?deployment_wave - deployment_wave)
    (release_compatible_with_environment ?release - release ?target_environment - target_environment)
    (release_compatible_with_component ?release - release ?service_component - service_component)
    (release_compatible_with_service ?release - release ?dependent_service - dependent_service)
    (release_compatible_with_toggle ?release - release ?feature_toggle - feature_toggle)
    (release_compatible_with_migration ?release - release ?migration_job - migration_job)
    (release_compatible_with_integration ?release - release ?integration_bundle - integration_bundle)
    (release_applicable_to_infra_profile ?release - release ?infrastructure_profile - infrastructure_profile)
    (variant_linked_approval_policy ?release - release ?approval_policy - approval_policy)
    (variant_selected ?release - release)
    (release_anchor_registered ?release - release)
    (release_bound_group ?release - release ?deployment_group - deployment_group)
    (release_pending_checks ?release - release)
    (policy_applicable_to_release ?release - release ?approval_policy - approval_policy)
  )
  (:action register_release
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
  (:action assign_release_to_wave
    :parameters (?release - release ?deployment_wave - deployment_wave)
    :precondition
      (and
        (release_registered ?release)
        (deployment_wave_available ?deployment_wave)
        (release_compatible_with_wave ?release ?deployment_wave)
        (not
          (release_wave_enrolled ?release)
        )
      )
    :effect
      (and
        (release_assigned_wave ?release ?deployment_wave)
        (release_wave_enrolled ?release)
        (not
          (deployment_wave_available ?deployment_wave)
        )
      )
  )
  (:action revoke_release_from_wave
    :parameters (?release - release ?deployment_wave - deployment_wave)
    :precondition
      (and
        (release_assigned_wave ?release ?deployment_wave)
        (not
          (release_promotable ?release)
        )
        (not
          (release_approved ?release)
        )
      )
    :effect
      (and
        (not
          (release_assigned_wave ?release ?deployment_wave)
        )
        (not
          (release_wave_enrolled ?release)
        )
        (not
          (release_stage_prepared ?release)
        )
        (not
          (release_validated ?release)
        )
        (not
          (release_migration_required ?release)
        )
        (not
          (release_promoted ?release)
        )
        (not
          (release_pending_checks ?release)
        )
        (deployment_wave_available ?deployment_wave)
      )
  )
  (:action bind_release_to_deployment_group
    :parameters (?release - release ?deployment_group - deployment_group)
    :precondition
      (and
        (release_registered ?release)
        (deployment_group_available ?deployment_group)
      )
    :effect
      (and
        (release_bound_group ?release ?deployment_group)
        (not
          (deployment_group_available ?deployment_group)
        )
      )
  )
  (:action unbind_release_from_deployment_group
    :parameters (?release - release ?deployment_group - deployment_group)
    :precondition
      (and
        (release_bound_group ?release ?deployment_group)
      )
    :effect
      (and
        (deployment_group_available ?deployment_group)
        (not
          (release_bound_group ?release ?deployment_group)
        )
      )
  )
  (:action prepare_stage_for_group
    :parameters (?release - release ?deployment_group - deployment_group)
    :precondition
      (and
        (release_registered ?release)
        (release_wave_enrolled ?release)
        (release_bound_group ?release ?deployment_group)
        (not
          (release_stage_prepared ?release)
        )
      )
    :effect
      (and
        (release_stage_prepared ?release)
      )
  )
  (:action prepare_stage_with_validation_artifact
    :parameters (?release - release ?validation_artifact - validation_artifact)
    :precondition
      (and
        (release_registered ?release)
        (release_wave_enrolled ?release)
        (validation_artifact_available ?validation_artifact)
        (not
          (release_stage_prepared ?release)
        )
      )
    :effect
      (and
        (release_stage_prepared ?release)
        (release_migration_required ?release)
        (not
          (validation_artifact_available ?validation_artifact)
        )
      )
  )
  (:action run_validation_suite_for_group
    :parameters (?release - release ?deployment_group - deployment_group ?validation_suite - validation_suite)
    :precondition
      (and
        (release_stage_prepared ?release)
        (release_wave_enrolled ?release)
        (release_bound_group ?release ?deployment_group)
        (validation_suite_available ?validation_suite)
        (not
          (release_validated ?release)
        )
      )
    :effect
      (and
        (release_validated ?release)
        (not
          (release_migration_required ?release)
        )
      )
  )
  (:action run_validation_by_policy
    :parameters (?release - release ?approval_policy - approval_policy)
    :precondition
      (and
        (release_wave_enrolled ?release)
        (release_policy_applied ?release ?approval_policy)
        (not
          (release_validated ?release)
        )
      )
    :effect
      (and
        (release_validated ?release)
        (not
          (release_migration_required ?release)
        )
      )
  )
  (:action enroll_component_dependency
    :parameters (?release - release ?service_component - service_component)
    :precondition
      (and
        (release_registered ?release)
        (component_available ?service_component)
        (release_compatible_with_component ?release ?service_component)
      )
    :effect
      (and
        (release_bound_component ?release ?service_component)
        (not
          (component_available ?service_component)
        )
      )
  )
  (:action unenroll_component_dependency
    :parameters (?release - release ?service_component - service_component)
    :precondition
      (and
        (release_bound_component ?release ?service_component)
      )
    :effect
      (and
        (component_available ?service_component)
        (not
          (release_bound_component ?release ?service_component)
        )
      )
  )
  (:action enroll_service_dependency
    :parameters (?release - release ?dependent_service - dependent_service)
    :precondition
      (and
        (release_registered ?release)
        (service_available ?dependent_service)
        (release_compatible_with_service ?release ?dependent_service)
      )
    :effect
      (and
        (release_bound_service ?release ?dependent_service)
        (not
          (service_available ?dependent_service)
        )
      )
  )
  (:action unenroll_service_dependency
    :parameters (?release - release ?dependent_service - dependent_service)
    :precondition
      (and
        (release_bound_service ?release ?dependent_service)
      )
    :effect
      (and
        (service_available ?dependent_service)
        (not
          (release_bound_service ?release ?dependent_service)
        )
      )
  )
  (:action enroll_toggle_dependency
    :parameters (?release - release ?feature_toggle - feature_toggle)
    :precondition
      (and
        (release_registered ?release)
        (toggle_available ?feature_toggle)
        (release_compatible_with_toggle ?release ?feature_toggle)
      )
    :effect
      (and
        (release_bound_toggle ?release ?feature_toggle)
        (not
          (toggle_available ?feature_toggle)
        )
      )
  )
  (:action unenroll_toggle_dependency
    :parameters (?release - release ?feature_toggle - feature_toggle)
    :precondition
      (and
        (release_bound_toggle ?release ?feature_toggle)
      )
    :effect
      (and
        (toggle_available ?feature_toggle)
        (not
          (release_bound_toggle ?release ?feature_toggle)
        )
      )
  )
  (:action enroll_integration_dependency
    :parameters (?release - release ?integration_bundle - integration_bundle)
    :precondition
      (and
        (release_registered ?release)
        (integration_bundle_available ?integration_bundle)
        (release_compatible_with_integration ?release ?integration_bundle)
      )
    :effect
      (and
        (release_bound_integration ?release ?integration_bundle)
        (not
          (integration_bundle_available ?integration_bundle)
        )
      )
  )
  (:action unenroll_integration_dependency
    :parameters (?release - release ?integration_bundle - integration_bundle)
    :precondition
      (and
        (release_bound_integration ?release ?integration_bundle)
      )
    :effect
      (and
        (integration_bundle_available ?integration_bundle)
        (not
          (release_bound_integration ?release ?integration_bundle)
        )
      )
  )
  (:action execute_integration_validation
    :parameters (?release - release ?target_environment - target_environment ?service_component - service_component ?dependent_service - dependent_service)
    :precondition
      (and
        (release_wave_enrolled ?release)
        (release_bound_component ?release ?service_component)
        (release_bound_service ?release ?dependent_service)
        (environment_available ?target_environment)
        (release_compatible_with_environment ?release ?target_environment)
        (not
          (release_promotable ?release)
        )
      )
    :effect
      (and
        (release_targeted_environment ?release ?target_environment)
        (release_promotable ?release)
        (not
          (environment_available ?target_environment)
        )
      )
  )
  (:action execute_integration_with_migration
    :parameters (?release - release ?target_environment - target_environment ?feature_toggle - feature_toggle ?migration_job - migration_job)
    :precondition
      (and
        (release_wave_enrolled ?release)
        (release_bound_toggle ?release ?feature_toggle)
        (migration_job_available ?migration_job)
        (environment_available ?target_environment)
        (release_compatible_with_environment ?release ?target_environment)
        (release_compatible_with_migration ?release ?migration_job)
        (not
          (release_promotable ?release)
        )
      )
    :effect
      (and
        (release_targeted_environment ?release ?target_environment)
        (release_promotable ?release)
        (release_pending_checks ?release)
        (release_migration_required ?release)
        (not
          (environment_available ?target_environment)
        )
        (not
          (migration_job_available ?migration_job)
        )
      )
  )
  (:action clear_pending_checks
    :parameters (?release - release ?service_component - service_component ?dependent_service - dependent_service)
    :precondition
      (and
        (release_promotable ?release)
        (release_pending_checks ?release)
        (release_bound_component ?release ?service_component)
        (release_bound_service ?release ?dependent_service)
      )
    :effect
      (and
        (not
          (release_pending_checks ?release)
        )
        (not
          (release_migration_required ?release)
        )
      )
  )
  (:action mark_release_approved_by_operator
    :parameters (?release - release ?service_component - service_component ?dependent_service - dependent_service ?operator_role - operator_role)
    :precondition
      (and
        (release_validated ?release)
        (release_promotable ?release)
        (release_bound_component ?release ?service_component)
        (release_bound_service ?release ?dependent_service)
        (release_applicable_to_infra_profile ?release ?operator_role)
        (not
          (release_migration_required ?release)
        )
        (not
          (release_approved ?release)
        )
      )
    :effect
      (and
        (release_approved ?release)
      )
  )
  (:action mark_release_approved_by_stakeholder
    :parameters (?release - release ?feature_toggle - feature_toggle ?integration_bundle - integration_bundle ?stakeholder_role - stakeholder_role)
    :precondition
      (and
        (release_validated ?release)
        (release_promotable ?release)
        (release_bound_toggle ?release ?feature_toggle)
        (release_bound_integration ?release ?integration_bundle)
        (release_applicable_to_infra_profile ?release ?stakeholder_role)
        (not
          (release_approved ?release)
        )
      )
    :effect
      (and
        (release_approved ?release)
        (release_migration_required ?release)
      )
  )
  (:action promote_release_after_approval
    :parameters (?release - release ?service_component - service_component ?dependent_service - dependent_service)
    :precondition
      (and
        (release_approved ?release)
        (release_migration_required ?release)
        (release_bound_component ?release ?service_component)
        (release_bound_service ?release ?dependent_service)
      )
    :effect
      (and
        (release_promoted ?release)
        (not
          (release_migration_required ?release)
        )
        (not
          (release_validated ?release)
        )
        (not
          (release_pending_checks ?release)
        )
      )
  )
  (:action revalidate_group_after_promotion
    :parameters (?release - release ?deployment_group - deployment_group ?validation_suite - validation_suite)
    :precondition
      (and
        (release_promoted ?release)
        (release_approved ?release)
        (release_wave_enrolled ?release)
        (release_bound_group ?release ?deployment_group)
        (validation_suite_available ?validation_suite)
        (not
          (release_validated ?release)
        )
      )
    :effect
      (and
        (release_validated ?release)
      )
  )
  (:action prepare_policy_eligibility_for_group
    :parameters (?release - release ?deployment_group - deployment_group)
    :precondition
      (and
        (release_approved ?release)
        (release_validated ?release)
        (not
          (release_migration_required ?release)
        )
        (release_bound_group ?release ?deployment_group)
        (not
          (release_policy_eligible ?release)
        )
      )
    :effect
      (and
        (release_policy_eligible ?release)
      )
  )
  (:action prepare_policy_eligibility_with_artifact
    :parameters (?release - release ?validation_artifact - validation_artifact)
    :precondition
      (and
        (release_approved ?release)
        (release_validated ?release)
        (not
          (release_migration_required ?release)
        )
        (validation_artifact_available ?validation_artifact)
        (not
          (release_policy_eligible ?release)
        )
      )
    :effect
      (and
        (release_policy_eligible ?release)
        (not
          (validation_artifact_available ?validation_artifact)
        )
      )
  )
  (:action bind_policy_to_variant
    :parameters (?release - release ?approval_policy - approval_policy)
    :precondition
      (and
        (release_policy_eligible ?release)
        (approval_policy_available ?approval_policy)
        (policy_applicable_to_release ?release ?approval_policy)
      )
    :effect
      (and
        (variant_linked_approval_policy ?release ?approval_policy)
        (not
          (approval_policy_available ?approval_policy)
        )
      )
  )
  (:action apply_policy_to_anchor_linkage
    :parameters (?release_anchor - release_anchor ?release_variant - release_variant ?approval_policy - approval_policy)
    :precondition
      (and
        (release_registered ?release_anchor)
        (release_anchor_registered ?release_anchor)
        (release_policy_anchor_binding ?release_anchor ?approval_policy)
        (variant_linked_approval_policy ?release_variant ?approval_policy)
        (not
          (release_policy_applied ?release_anchor ?approval_policy)
        )
      )
    :effect
      (and
        (release_policy_applied ?release_anchor ?approval_policy)
      )
  )
  (:action mark_release_ready_for_rollout
    :parameters (?release - release ?deployment_group - deployment_group ?validation_suite - validation_suite)
    :precondition
      (and
        (release_registered ?release)
        (release_anchor_registered ?release)
        (release_validated ?release)
        (release_policy_eligible ?release)
        (release_bound_group ?release ?deployment_group)
        (validation_suite_available ?validation_suite)
        (not
          (release_stage_ready ?release)
        )
      )
    :effect
      (and
        (release_stage_ready ?release)
      )
  )
  (:action finalize_release_without_policy
    :parameters (?release - release)
    :precondition
      (and
        (variant_selected ?release)
        (release_registered ?release)
        (release_wave_enrolled ?release)
        (release_promotable ?release)
        (release_approved ?release)
        (release_policy_eligible ?release)
        (release_validated ?release)
        (not
          (release_finalized ?release)
        )
      )
    :effect
      (and
        (release_finalized ?release)
      )
  )
  (:action finalize_release_with_policy
    :parameters (?release - release ?approval_policy - approval_policy)
    :precondition
      (and
        (release_anchor_registered ?release)
        (release_registered ?release)
        (release_wave_enrolled ?release)
        (release_promotable ?release)
        (release_approved ?release)
        (release_policy_eligible ?release)
        (release_validated ?release)
        (release_policy_applied ?release ?approval_policy)
        (not
          (release_finalized ?release)
        )
      )
    :effect
      (and
        (release_finalized ?release)
      )
  )
  (:action finalize_release_with_variant_ready
    :parameters (?release - release)
    :precondition
      (and
        (release_anchor_registered ?release)
        (release_registered ?release)
        (release_wave_enrolled ?release)
        (release_promotable ?release)
        (release_approved ?release)
        (release_policy_eligible ?release)
        (release_validated ?release)
        (release_stage_ready ?release)
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

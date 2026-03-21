(define (domain canary_wave_progression_governance)
  (:requirements :strips :typing :negative-preconditions)
  (:types release - object promotion_wave - object environment - object dependency_service - object canary_group - object observability_metric - object deployment_target_group - object approval_token - object rollout_strategy - object orchestration_job - object rollback_plan - object configuration_set - object policy - object policy_variant_a - policy policy_variant_b - policy release_profile_a - release release_profile_b - release)
  (:predicates
    (release_initialized ?release - release)
    (release_assigned_to_promotion_wave ?release - release ?promotion_wave - promotion_wave)
    (release_assigned ?release - release)
    (target_ready ?release - release)
    (validation_passed ?release - release)
    (canary_group_attached ?release - release ?canary_group - canary_group)
    (dependency_service_attached ?release - release ?dependency_service - dependency_service)
    (metric_attached ?release - release ?observability_metric - observability_metric)
    (configuration_attached ?release - release ?configuration_set - configuration_set)
    (environment_validated_for_release ?release - release ?environment - environment)
    (primary_validation_passed ?release - release)
    (composite_validation_passed ?release - release)
    (target_approval_granted ?release - release)
    (release_finalized ?release - release)
    (approval_recorded ?release - release)
    (promotion_permitted ?release - release)
    (profile_b_strategy_link ?release - release ?rollout_strategy - rollout_strategy)
    (rollout_strategy_activated ?release - release ?rollout_strategy - rollout_strategy)
    (finalization_ready ?release - release)
    (wave_available ?promotion_wave - promotion_wave)
    (environment_available ?environment - environment)
    (canary_group_available ?canary_group - canary_group)
    (dependency_service_available ?dependency_service - dependency_service)
    (metric_available ?observability_metric - observability_metric)
    (target_group_available ?deployment_target_group - deployment_target_group)
    (approval_token_available ?approval_token - approval_token)
    (rollout_strategy_available ?rollout_strategy - rollout_strategy)
    (orchestration_job_available ?orchestration_job - orchestration_job)
    (rollback_plan_available ?rollback_plan - rollback_plan)
    (configuration_set_available ?configuration_set - configuration_set)
    (release_allowed_wave ?release - release ?promotion_wave - promotion_wave)
    (release_allowed_environment ?release - release ?environment - environment)
    (release_allowed_canary_group ?release - release ?canary_group - canary_group)
    (release_allowed_dependency ?release - release ?dependency_service - dependency_service)
    (release_allowed_metric ?release - release ?observability_metric - observability_metric)
    (release_allowed_rollback_plan ?release - release ?rollback_plan - rollback_plan)
    (release_allowed_configuration ?release - release ?configuration_set - configuration_set)
    (release_policy_binding ?release - release ?policy - policy)
    (release_strategy_engaged ?release - release ?rollout_strategy - rollout_strategy)
    (is_profile_a ?release - release)
    (is_profile_b ?release - release)
    (release_target_group_binding ?release - release ?deployment_target_group - deployment_target_group)
    (has_additional_checks ?release - release)
    (profile_a_strategy_link ?release - release ?rollout_strategy - rollout_strategy)
  )
  (:action initialize_release
    :parameters (?release - release)
    :precondition
      (and
        (not
          (release_initialized ?release)
        )
        (not
          (release_finalized ?release)
        )
      )
    :effect
      (and
        (release_initialized ?release)
      )
  )
  (:action assign_release_to_wave
    :parameters (?release - release ?promotion_wave - promotion_wave)
    :precondition
      (and
        (release_initialized ?release)
        (wave_available ?promotion_wave)
        (release_allowed_wave ?release ?promotion_wave)
        (not
          (release_assigned ?release)
        )
      )
    :effect
      (and
        (release_assigned_to_promotion_wave ?release ?promotion_wave)
        (release_assigned ?release)
        (not
          (wave_available ?promotion_wave)
        )
      )
  )
  (:action unassign_release_from_wave
    :parameters (?release - release ?promotion_wave - promotion_wave)
    :precondition
      (and
        (release_assigned_to_promotion_wave ?release ?promotion_wave)
        (not
          (primary_validation_passed ?release)
        )
        (not
          (composite_validation_passed ?release)
        )
      )
    :effect
      (and
        (not
          (release_assigned_to_promotion_wave ?release ?promotion_wave)
        )
        (not
          (release_assigned ?release)
        )
        (not
          (target_ready ?release)
        )
        (not
          (validation_passed ?release)
        )
        (not
          (approval_recorded ?release)
        )
        (not
          (promotion_permitted ?release)
        )
        (not
          (has_additional_checks ?release)
        )
        (wave_available ?promotion_wave)
      )
  )
  (:action bind_release_to_target_group
    :parameters (?release - release ?deployment_target_group - deployment_target_group)
    :precondition
      (and
        (release_initialized ?release)
        (target_group_available ?deployment_target_group)
      )
    :effect
      (and
        (release_target_group_binding ?release ?deployment_target_group)
        (not
          (target_group_available ?deployment_target_group)
        )
      )
  )
  (:action unbind_release_from_target_group
    :parameters (?release - release ?deployment_target_group - deployment_target_group)
    :precondition
      (and
        (release_target_group_binding ?release ?deployment_target_group)
      )
    :effect
      (and
        (target_group_available ?deployment_target_group)
        (not
          (release_target_group_binding ?release ?deployment_target_group)
        )
      )
  )
  (:action mark_target_ready
    :parameters (?release - release ?deployment_target_group - deployment_target_group)
    :precondition
      (and
        (release_initialized ?release)
        (release_assigned ?release)
        (release_target_group_binding ?release ?deployment_target_group)
        (not
          (target_ready ?release)
        )
      )
    :effect
      (and
        (target_ready ?release)
      )
  )
  (:action record_approval_and_mark_target
    :parameters (?release - release ?approval_token - approval_token)
    :precondition
      (and
        (release_initialized ?release)
        (release_assigned ?release)
        (approval_token_available ?approval_token)
        (not
          (target_ready ?release)
        )
      )
    :effect
      (and
        (target_ready ?release)
        (approval_recorded ?release)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action run_orchestration_validation_on_target
    :parameters (?release - release ?deployment_target_group - deployment_target_group ?orchestration_job - orchestration_job)
    :precondition
      (and
        (target_ready ?release)
        (release_assigned ?release)
        (release_target_group_binding ?release ?deployment_target_group)
        (orchestration_job_available ?orchestration_job)
        (not
          (validation_passed ?release)
        )
      )
    :effect
      (and
        (validation_passed ?release)
        (not
          (approval_recorded ?release)
        )
      )
  )
  (:action run_strategy_validation
    :parameters (?release - release ?rollout_strategy - rollout_strategy)
    :precondition
      (and
        (release_assigned ?release)
        (rollout_strategy_activated ?release ?rollout_strategy)
        (not
          (validation_passed ?release)
        )
      )
    :effect
      (and
        (validation_passed ?release)
        (not
          (approval_recorded ?release)
        )
      )
  )
  (:action attach_canary_group
    :parameters (?release - release ?canary_group - canary_group)
    :precondition
      (and
        (release_initialized ?release)
        (canary_group_available ?canary_group)
        (release_allowed_canary_group ?release ?canary_group)
      )
    :effect
      (and
        (canary_group_attached ?release ?canary_group)
        (not
          (canary_group_available ?canary_group)
        )
      )
  )
  (:action detach_canary_group
    :parameters (?release - release ?canary_group - canary_group)
    :precondition
      (and
        (canary_group_attached ?release ?canary_group)
      )
    :effect
      (and
        (canary_group_available ?canary_group)
        (not
          (canary_group_attached ?release ?canary_group)
        )
      )
  )
  (:action attach_dependency_service
    :parameters (?release - release ?dependency_service - dependency_service)
    :precondition
      (and
        (release_initialized ?release)
        (dependency_service_available ?dependency_service)
        (release_allowed_dependency ?release ?dependency_service)
      )
    :effect
      (and
        (dependency_service_attached ?release ?dependency_service)
        (not
          (dependency_service_available ?dependency_service)
        )
      )
  )
  (:action detach_dependency_service
    :parameters (?release - release ?dependency_service - dependency_service)
    :precondition
      (and
        (dependency_service_attached ?release ?dependency_service)
      )
    :effect
      (and
        (dependency_service_available ?dependency_service)
        (not
          (dependency_service_attached ?release ?dependency_service)
        )
      )
  )
  (:action attach_observability_metric
    :parameters (?release - release ?observability_metric - observability_metric)
    :precondition
      (and
        (release_initialized ?release)
        (metric_available ?observability_metric)
        (release_allowed_metric ?release ?observability_metric)
      )
    :effect
      (and
        (metric_attached ?release ?observability_metric)
        (not
          (metric_available ?observability_metric)
        )
      )
  )
  (:action detach_observability_metric
    :parameters (?release - release ?observability_metric - observability_metric)
    :precondition
      (and
        (metric_attached ?release ?observability_metric)
      )
    :effect
      (and
        (metric_available ?observability_metric)
        (not
          (metric_attached ?release ?observability_metric)
        )
      )
  )
  (:action attach_configuration_set
    :parameters (?release - release ?configuration_set - configuration_set)
    :precondition
      (and
        (release_initialized ?release)
        (configuration_set_available ?configuration_set)
        (release_allowed_configuration ?release ?configuration_set)
      )
    :effect
      (and
        (configuration_attached ?release ?configuration_set)
        (not
          (configuration_set_available ?configuration_set)
        )
      )
  )
  (:action detach_configuration_set
    :parameters (?release - release ?configuration_set - configuration_set)
    :precondition
      (and
        (configuration_attached ?release ?configuration_set)
      )
    :effect
      (and
        (configuration_set_available ?configuration_set)
        (not
          (configuration_attached ?release ?configuration_set)
        )
      )
  )
  (:action validate_environment_integration
    :parameters (?release - release ?environment - environment ?canary_group - canary_group ?dependency_service - dependency_service)
    :precondition
      (and
        (release_assigned ?release)
        (canary_group_attached ?release ?canary_group)
        (dependency_service_attached ?release ?dependency_service)
        (environment_available ?environment)
        (release_allowed_environment ?release ?environment)
        (not
          (primary_validation_passed ?release)
        )
      )
    :effect
      (and
        (environment_validated_for_release ?release ?environment)
        (primary_validation_passed ?release)
        (not
          (environment_available ?environment)
        )
      )
  )
  (:action validate_environment_with_metrics_and_rollback
    :parameters (?release - release ?environment - environment ?observability_metric - observability_metric ?rollback_plan - rollback_plan)
    :precondition
      (and
        (release_assigned ?release)
        (metric_attached ?release ?observability_metric)
        (rollback_plan_available ?rollback_plan)
        (environment_available ?environment)
        (release_allowed_environment ?release ?environment)
        (release_allowed_rollback_plan ?release ?rollback_plan)
        (not
          (primary_validation_passed ?release)
        )
      )
    :effect
      (and
        (environment_validated_for_release ?release ?environment)
        (primary_validation_passed ?release)
        (has_additional_checks ?release)
        (approval_recorded ?release)
        (not
          (environment_available ?environment)
        )
        (not
          (rollback_plan_available ?rollback_plan)
        )
      )
  )
  (:action clear_additional_checks
    :parameters (?release - release ?canary_group - canary_group ?dependency_service - dependency_service)
    :precondition
      (and
        (primary_validation_passed ?release)
        (has_additional_checks ?release)
        (canary_group_attached ?release ?canary_group)
        (dependency_service_attached ?release ?dependency_service)
      )
    :effect
      (and
        (not
          (has_additional_checks ?release)
        )
        (not
          (approval_recorded ?release)
        )
      )
  )
  (:action approve_promotion_via_policy_variant_a
    :parameters (?release - release ?canary_group - canary_group ?dependency_service - dependency_service ?policy_variant_a - policy_variant_a)
    :precondition
      (and
        (validation_passed ?release)
        (primary_validation_passed ?release)
        (canary_group_attached ?release ?canary_group)
        (dependency_service_attached ?release ?dependency_service)
        (release_policy_binding ?release ?policy_variant_a)
        (not
          (approval_recorded ?release)
        )
        (not
          (composite_validation_passed ?release)
        )
      )
    :effect
      (and
        (composite_validation_passed ?release)
      )
  )
  (:action approve_promotion_via_policy_variant_b
    :parameters (?release - release ?observability_metric - observability_metric ?configuration_set - configuration_set ?policy_variant_b - policy_variant_b)
    :precondition
      (and
        (validation_passed ?release)
        (primary_validation_passed ?release)
        (metric_attached ?release ?observability_metric)
        (configuration_attached ?release ?configuration_set)
        (release_policy_binding ?release ?policy_variant_b)
        (not
          (composite_validation_passed ?release)
        )
      )
    :effect
      (and
        (composite_validation_passed ?release)
        (approval_recorded ?release)
      )
  )
  (:action record_promotion_permission
    :parameters (?release - release ?canary_group - canary_group ?dependency_service - dependency_service)
    :precondition
      (and
        (composite_validation_passed ?release)
        (approval_recorded ?release)
        (canary_group_attached ?release ?canary_group)
        (dependency_service_attached ?release ?dependency_service)
      )
    :effect
      (and
        (promotion_permitted ?release)
        (not
          (approval_recorded ?release)
        )
        (not
          (validation_passed ?release)
        )
        (not
          (has_additional_checks ?release)
        )
      )
  )
  (:action revalidate_target_after_permission
    :parameters (?release - release ?deployment_target_group - deployment_target_group ?orchestration_job - orchestration_job)
    :precondition
      (and
        (promotion_permitted ?release)
        (composite_validation_passed ?release)
        (release_assigned ?release)
        (release_target_group_binding ?release ?deployment_target_group)
        (orchestration_job_available ?orchestration_job)
        (not
          (validation_passed ?release)
        )
      )
    :effect
      (and
        (validation_passed ?release)
      )
  )
  (:action confirm_target_approval_binding
    :parameters (?release - release ?deployment_target_group - deployment_target_group)
    :precondition
      (and
        (composite_validation_passed ?release)
        (validation_passed ?release)
        (not
          (approval_recorded ?release)
        )
        (release_target_group_binding ?release ?deployment_target_group)
        (not
          (target_approval_granted ?release)
        )
      )
    :effect
      (and
        (target_approval_granted ?release)
      )
  )
  (:action consume_approval_token_for_target
    :parameters (?release - release ?approval_token - approval_token)
    :precondition
      (and
        (composite_validation_passed ?release)
        (validation_passed ?release)
        (not
          (approval_recorded ?release)
        )
        (approval_token_available ?approval_token)
        (not
          (target_approval_granted ?release)
        )
      )
    :effect
      (and
        (target_approval_granted ?release)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action engage_rollout_strategy_for_release
    :parameters (?release - release ?rollout_strategy - rollout_strategy)
    :precondition
      (and
        (target_approval_granted ?release)
        (rollout_strategy_available ?rollout_strategy)
        (profile_a_strategy_link ?release ?rollout_strategy)
      )
    :effect
      (and
        (release_strategy_engaged ?release ?rollout_strategy)
        (not
          (rollout_strategy_available ?rollout_strategy)
        )
      )
  )
  (:action activate_strategy_for_profile_b_from_profile_a
    :parameters (?release_profile_b - release_profile_b ?release_profile_a - release_profile_a ?rollout_strategy - rollout_strategy)
    :precondition
      (and
        (release_initialized ?release_profile_b)
        (is_profile_b ?release_profile_b)
        (profile_b_strategy_link ?release_profile_b ?rollout_strategy)
        (release_strategy_engaged ?release_profile_a ?rollout_strategy)
        (not
          (rollout_strategy_activated ?release_profile_b ?rollout_strategy)
        )
      )
    :effect
      (and
        (rollout_strategy_activated ?release_profile_b ?rollout_strategy)
      )
  )
  (:action mark_release_ready_for_finalization
    :parameters (?release - release ?deployment_target_group - deployment_target_group ?orchestration_job - orchestration_job)
    :precondition
      (and
        (release_initialized ?release)
        (is_profile_b ?release)
        (validation_passed ?release)
        (target_approval_granted ?release)
        (release_target_group_binding ?release ?deployment_target_group)
        (orchestration_job_available ?orchestration_job)
        (not
          (finalization_ready ?release)
        )
      )
    :effect
      (and
        (finalization_ready ?release)
      )
  )
  (:action finalize_release
    :parameters (?release - release)
    :precondition
      (and
        (is_profile_a ?release)
        (release_initialized ?release)
        (release_assigned ?release)
        (primary_validation_passed ?release)
        (composite_validation_passed ?release)
        (target_approval_granted ?release)
        (validation_passed ?release)
        (not
          (release_finalized ?release)
        )
      )
    :effect
      (and
        (release_finalized ?release)
      )
  )
  (:action finalize_release_with_strategy
    :parameters (?release - release ?rollout_strategy - rollout_strategy)
    :precondition
      (and
        (is_profile_b ?release)
        (release_initialized ?release)
        (release_assigned ?release)
        (primary_validation_passed ?release)
        (composite_validation_passed ?release)
        (target_approval_granted ?release)
        (validation_passed ?release)
        (rollout_strategy_activated ?release ?rollout_strategy)
        (not
          (release_finalized ?release)
        )
      )
    :effect
      (and
        (release_finalized ?release)
      )
  )
  (:action finalize_release_with_profile_signal
    :parameters (?release - release)
    :precondition
      (and
        (is_profile_b ?release)
        (release_initialized ?release)
        (release_assigned ?release)
        (primary_validation_passed ?release)
        (composite_validation_passed ?release)
        (target_approval_granted ?release)
        (validation_passed ?release)
        (finalization_ready ?release)
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

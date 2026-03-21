(define (domain hotfix_train_rollout_control)
  (:requirements :strips :typing :negative-preconditions)
  (:types deployment_actor - object promotion_wave - object deployment_environment - object service - object artifact - object infrastructure_component - object deployment_target - object approval_token - object release_component - object runbook_check - object maintenance_window - object hotfix_patch - object stakeholder_group - object canary_segment - stakeholder_group compliance_constraint - stakeholder_group release_train_engineer_role - deployment_actor release_train_automation_agent - deployment_actor)
  (:predicates
    (approval_token_available ?approval_token - approval_token)
    (service_bound_to_actor ?release_train - deployment_actor ?service - service)
    (canary_stage_enabled ?release_train - deployment_actor)
    (actor_has_wave ?release_train - deployment_actor ?promotion_wave - promotion_wave)
    (actor_has_stakeholder_group ?release_train - deployment_actor ?stakeholder_group - stakeholder_group)
    (infrastructure_available ?infrastructure_component - infrastructure_component)
    (service_available ?service - service)
    (patch_permitted_for_actor ?release_train - deployment_actor ?hotfix_patch - hotfix_patch)
    (actor_finalized ?release_train - deployment_actor)
    (actor_bootstrapped ?release_train - deployment_actor)
    (wave_permitted_for_actor ?release_train - deployment_actor ?promotion_wave - promotion_wave)
    (environment_available ?deployment_environment - deployment_environment)
    (maintenance_window_available ?maintenance_window - maintenance_window)
    (target_available ?deployment_target - deployment_target)
    (promotion_in_progress ?release_train - deployment_actor)
    (service_permitted_for_actor ?release_train - deployment_actor ?service - service)
    (patch_bound_to_actor ?release_train - deployment_actor ?hotfix_patch - hotfix_patch)
    (actor_promoted_to_environment ?release_train - deployment_actor ?deployment_environment - deployment_environment)
    (promotion_authorized ?release_train - deployment_actor)
    (infra_permitted_for_actor ?release_train - deployment_actor ?infrastructure_component - infrastructure_component)
    (hotfix_patch_available ?hotfix_patch - hotfix_patch)
    (automation_agent_available ?release_train - deployment_actor)
    (pre_release_checks_completed ?release_train - deployment_actor)
    (artifact_permitted_for_actor ?release_train - deployment_actor ?artifact - artifact)
    (artifact_bound_to_actor ?release_train - deployment_actor ?artifact - artifact)
    (rollback_prepared ?release_train - deployment_actor)
    (target_reserved_for_actor ?release_train - deployment_actor ?deployment_target - deployment_target)
    (deployment_ready ?release_train - deployment_actor)
    (maintenance_window_permitted_for_actor ?release_train - deployment_actor ?maintenance_window - maintenance_window)
    (actor_registered ?release_train - deployment_actor)
    (wave_available ?promotion_wave - promotion_wave)
    (actor_has_assigned_wave ?release_train - deployment_actor)
    (runbook_check_available ?runbook_check - runbook_check)
    (component_available ?release_component - release_component)
    (infra_bound_to_actor ?release_train - deployment_actor ?infrastructure_component - infrastructure_component)
    (component_assigned_to_role ?release_train - deployment_actor ?release_component - release_component)
    (validation_passed ?release_train - deployment_actor)
    (targets_committed ?release_train - deployment_actor)
    (component_permitted_for_actor ?release_train - deployment_actor ?release_component - release_component)
    (artifact_available ?artifact - artifact)
    (entity_assigned_component ?release_train - deployment_actor ?release_component - release_component)
    (environment_permitted_for_actor ?release_train - deployment_actor ?deployment_environment - deployment_environment)
    (approval_recorded ?release_train - deployment_actor)
    (component_verified_for_actor ?release_train - deployment_actor ?release_component - release_component)
  )
  (:action release_patch_binding
    :parameters (?release_train - deployment_actor ?hotfix_patch - hotfix_patch)
    :precondition
      (and
        (patch_bound_to_actor ?release_train ?hotfix_patch)
      )
    :effect
      (and
        (hotfix_patch_available ?hotfix_patch)
        (not
          (patch_bound_to_actor ?release_train ?hotfix_patch)
        )
      )
  )
  (:action authorize_promotion_with_compliance
    :parameters (?release_train - deployment_actor ?infrastructure_component - infrastructure_component ?hotfix_patch - hotfix_patch ?compliance_constraint - compliance_constraint)
    :precondition
      (and
        (not
          (promotion_authorized ?release_train)
        )
        (promotion_in_progress ?release_train)
        (pre_release_checks_completed ?release_train)
        (patch_bound_to_actor ?release_train ?hotfix_patch)
        (actor_has_stakeholder_group ?release_train ?compliance_constraint)
        (infra_bound_to_actor ?release_train ?infrastructure_component)
      )
    :effect
      (and
        (approval_recorded ?release_train)
        (promotion_authorized ?release_train)
      )
  )
  (:action finalize_actor_registration
    :parameters (?release_train - deployment_actor)
    :precondition
      (and
        (pre_release_checks_completed ?release_train)
        (actor_has_assigned_wave ?release_train)
        (promotion_in_progress ?release_train)
        (actor_registered ?release_train)
        (targets_committed ?release_train)
        (not
          (actor_finalized ?release_train)
        )
        (actor_bootstrapped ?release_train)
        (promotion_authorized ?release_train)
      )
    :effect
      (and
        (actor_finalized ?release_train)
      )
  )
  (:action clear_rollback_preparation
    :parameters (?release_train - deployment_actor ?artifact - artifact ?service - service)
    :precondition
      (and
        (promotion_in_progress ?release_train)
        (rollback_prepared ?release_train)
        (artifact_bound_to_actor ?release_train ?artifact)
        (service_bound_to_actor ?release_train ?service)
      )
    :effect
      (and
        (not
          (rollback_prepared ?release_train)
        )
        (not
          (approval_recorded ?release_train)
        )
      )
  )
  (:action reserve_deployment_target
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target)
    :precondition
      (and
        (target_available ?deployment_target)
        (actor_registered ?release_train)
      )
    :effect
      (and
        (not
          (target_available ?deployment_target)
        )
        (target_reserved_for_actor ?release_train ?deployment_target)
      )
  )
  (:action authorize_promotion_by_stakeholders
    :parameters (?release_train - deployment_actor ?artifact - artifact ?service - service ?canary_segment - canary_segment)
    :precondition
      (and
        (actor_has_stakeholder_group ?release_train ?canary_segment)
        (pre_release_checks_completed ?release_train)
        (not
          (approval_recorded ?release_train)
        )
        (artifact_bound_to_actor ?release_train ?artifact)
        (promotion_in_progress ?release_train)
        (service_bound_to_actor ?release_train ?service)
        (not
          (promotion_authorized ?release_train)
        )
      )
    :effect
      (and
        (promotion_authorized ?release_train)
      )
  )
  (:action verify_component_for_actor
    :parameters (?release_train - deployment_actor ?release_component - release_component)
    :precondition
      (and
        (actor_has_assigned_wave ?release_train)
        (component_verified_for_actor ?release_train ?release_component)
        (not
          (pre_release_checks_completed ?release_train)
        )
      )
    :effect
      (and
        (pre_release_checks_completed ?release_train)
        (not
          (approval_recorded ?release_train)
        )
      )
  )
  (:action reserve_and_bind_infrastructure
    :parameters (?release_train - deployment_actor ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (infra_permitted_for_actor ?release_train ?infrastructure_component)
        (actor_registered ?release_train)
        (infrastructure_available ?infrastructure_component)
      )
    :effect
      (and
        (infra_bound_to_actor ?release_train ?infrastructure_component)
        (not
          (infrastructure_available ?infrastructure_component)
        )
      )
  )
  (:action reserve_and_bind_artifact
    :parameters (?release_train - deployment_actor ?artifact - artifact)
    :precondition
      (and
        (actor_registered ?release_train)
        (artifact_available ?artifact)
        (artifact_permitted_for_actor ?release_train ?artifact)
      )
    :effect
      (and
        (not
          (artifact_available ?artifact)
        )
        (artifact_bound_to_actor ?release_train ?artifact)
      )
  )
  (:action release_infrastructure_binding
    :parameters (?release_train - deployment_actor ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (infra_bound_to_actor ?release_train ?infrastructure_component)
      )
    :effect
      (and
        (infrastructure_available ?infrastructure_component)
        (not
          (infra_bound_to_actor ?release_train ?infrastructure_component)
        )
      )
  )
  (:action release_service_binding
    :parameters (?release_train - deployment_actor ?service - service)
    :precondition
      (and
        (service_bound_to_actor ?release_train ?service)
      )
    :effect
      (and
        (service_available ?service)
        (not
          (service_bound_to_actor ?release_train ?service)
        )
      )
  )
  (:action assign_component_affiliation
    :parameters (?release_train - deployment_actor ?release_component - release_component)
    :precondition
      (and
        (targets_committed ?release_train)
        (component_available ?release_component)
        (component_permitted_for_actor ?release_train ?release_component)
      )
    :effect
      (and
        (component_assigned_to_role ?release_train ?release_component)
        (not
          (component_available ?release_component)
        )
      )
  )
  (:action reserve_and_bind_service
    :parameters (?release_train - deployment_actor ?service - service)
    :precondition
      (and
        (actor_registered ?release_train)
        (service_available ?service)
        (service_permitted_for_actor ?release_train ?service)
      )
    :effect
      (and
        (service_bound_to_actor ?release_train ?service)
        (not
          (service_available ?service)
        )
      )
  )
  (:action execute_promotion_step
    :parameters (?release_train - deployment_actor ?deployment_environment - deployment_environment ?artifact - artifact ?service - service)
    :precondition
      (and
        (actor_has_assigned_wave ?release_train)
        (environment_available ?deployment_environment)
        (environment_permitted_for_actor ?release_train ?deployment_environment)
        (not
          (promotion_in_progress ?release_train)
        )
        (service_bound_to_actor ?release_train ?service)
        (artifact_bound_to_actor ?release_train ?artifact)
      )
    :effect
      (and
        (actor_promoted_to_environment ?release_train ?deployment_environment)
        (not
          (environment_available ?deployment_environment)
        )
        (promotion_in_progress ?release_train)
      )
  )
  (:action initiate_rollout_phase
    :parameters (?release_train - deployment_actor ?artifact - artifact ?service - service)
    :precondition
      (and
        (artifact_bound_to_actor ?release_train ?artifact)
        (promotion_authorized ?release_train)
        (service_bound_to_actor ?release_train ?service)
        (approval_recorded ?release_train)
      )
    :effect
      (and
        (not
          (rollback_prepared ?release_train)
        )
        (not
          (approval_recorded ?release_train)
        )
        (not
          (pre_release_checks_completed ?release_train)
        )
        (canary_stage_enabled ?release_train)
      )
  )
  (:action release_deployment_target
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target)
    :precondition
      (and
        (target_reserved_for_actor ?release_train ?deployment_target)
      )
    :effect
      (and
        (target_available ?deployment_target)
        (not
          (target_reserved_for_actor ?release_train ?deployment_target)
        )
      )
  )
  (:action complete_runbook_check
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target ?runbook_check - runbook_check)
    :precondition
      (and
        (not
          (pre_release_checks_completed ?release_train)
        )
        (actor_has_assigned_wave ?release_train)
        (runbook_check_available ?runbook_check)
        (target_reserved_for_actor ?release_train ?deployment_target)
        (validation_passed ?release_train)
      )
    :effect
      (and
        (not
          (approval_recorded ?release_train)
        )
        (pre_release_checks_completed ?release_train)
      )
  )
  (:action finalize_actor_with_deployment_ready
    :parameters (?release_train - deployment_actor)
    :precondition
      (and
        (actor_registered ?release_train)
        (automation_agent_available ?release_train)
        (deployment_ready ?release_train)
        (actor_has_assigned_wave ?release_train)
        (pre_release_checks_completed ?release_train)
        (not
          (actor_finalized ?release_train)
        )
        (targets_committed ?release_train)
        (promotion_in_progress ?release_train)
        (promotion_authorized ?release_train)
      )
    :effect
      (and
        (actor_finalized ?release_train)
      )
  )
  (:action mark_deployment_ready
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target ?runbook_check - runbook_check)
    :precondition
      (and
        (pre_release_checks_completed ?release_train)
        (runbook_check_available ?runbook_check)
        (not
          (deployment_ready ?release_train)
        )
        (targets_committed ?release_train)
        (actor_registered ?release_train)
        (automation_agent_available ?release_train)
        (target_reserved_for_actor ?release_train ?deployment_target)
      )
    :effect
      (and
        (deployment_ready ?release_train)
      )
  )
  (:action release_artifact_binding
    :parameters (?release_train - deployment_actor ?artifact - artifact)
    :precondition
      (and
        (artifact_bound_to_actor ?release_train ?artifact)
      )
    :effect
      (and
        (artifact_available ?artifact)
        (not
          (artifact_bound_to_actor ?release_train ?artifact)
        )
      )
  )
  (:action reserve_and_bind_patch
    :parameters (?release_train - deployment_actor ?hotfix_patch - hotfix_patch)
    :precondition
      (and
        (hotfix_patch_available ?hotfix_patch)
        (actor_registered ?release_train)
        (patch_permitted_for_actor ?release_train ?hotfix_patch)
      )
    :effect
      (and
        (patch_bound_to_actor ?release_train ?hotfix_patch)
        (not
          (hotfix_patch_available ?hotfix_patch)
        )
      )
  )
  (:action register_release_actor
    :parameters (?release_train - deployment_actor)
    :precondition
      (and
        (not
          (actor_registered ?release_train)
        )
        (not
          (actor_finalized ?release_train)
        )
      )
    :effect
      (and
        (actor_registered ?release_train)
      )
  )
  (:action consume_approval_token
    :parameters (?release_train - deployment_actor ?approval_token - approval_token)
    :precondition
      (and
        (not
          (validation_passed ?release_train)
        )
        (actor_registered ?release_train)
        (approval_token_available ?approval_token)
        (actor_has_assigned_wave ?release_train)
      )
    :effect
      (and
        (approval_recorded ?release_train)
        (not
          (approval_token_available ?approval_token)
        )
        (validation_passed ?release_train)
      )
  )
  (:action execute_promotion_with_maintenance
    :parameters (?release_train - deployment_actor ?deployment_environment - deployment_environment ?infrastructure_component - infrastructure_component ?maintenance_window - maintenance_window)
    :precondition
      (and
        (maintenance_window_available ?maintenance_window)
        (maintenance_window_permitted_for_actor ?release_train ?maintenance_window)
        (not
          (promotion_in_progress ?release_train)
        )
        (actor_has_assigned_wave ?release_train)
        (environment_available ?deployment_environment)
        (environment_permitted_for_actor ?release_train ?deployment_environment)
        (infra_bound_to_actor ?release_train ?infrastructure_component)
      )
    :effect
      (and
        (actor_promoted_to_environment ?release_train ?deployment_environment)
        (not
          (maintenance_window_available ?maintenance_window)
        )
        (rollback_prepared ?release_train)
        (not
          (environment_available ?deployment_environment)
        )
        (approval_recorded ?release_train)
        (promotion_in_progress ?release_train)
      )
  )
  (:action commit_approval_for_promotion
    :parameters (?release_train - deployment_actor ?approval_token - approval_token)
    :precondition
      (and
        (approval_token_available ?approval_token)
        (not
          (approval_recorded ?release_train)
        )
        (pre_release_checks_completed ?release_train)
        (promotion_authorized ?release_train)
        (not
          (targets_committed ?release_train)
        )
      )
    :effect
      (and
        (targets_committed ?release_train)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action remove_promotion_wave
    :parameters (?release_train - deployment_actor ?promotion_wave - promotion_wave)
    :precondition
      (and
        (actor_has_wave ?release_train ?promotion_wave)
        (not
          (promotion_authorized ?release_train)
        )
        (not
          (promotion_in_progress ?release_train)
        )
      )
    :effect
      (and
        (not
          (actor_has_wave ?release_train ?promotion_wave)
        )
        (wave_available ?promotion_wave)
        (not
          (actor_has_assigned_wave ?release_train)
        )
        (not
          (validation_passed ?release_train)
        )
        (not
          (canary_stage_enabled ?release_train)
        )
        (not
          (pre_release_checks_completed ?release_train)
        )
        (not
          (rollback_prepared ?release_train)
        )
        (not
          (approval_recorded ?release_train)
        )
      )
  )
  (:action commit_targets_for_promotion
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target)
    :precondition
      (and
        (not
          (targets_committed ?release_train)
        )
        (target_reserved_for_actor ?release_train ?deployment_target)
        (pre_release_checks_completed ?release_train)
        (promotion_authorized ?release_train)
        (not
          (approval_recorded ?release_train)
        )
      )
    :effect
      (and
        (targets_committed ?release_train)
      )
  )
  (:action finalize_actor_with_component_validation
    :parameters (?release_train - deployment_actor ?release_component - release_component)
    :precondition
      (and
        (targets_committed ?release_train)
        (promotion_authorized ?release_train)
        (promotion_in_progress ?release_train)
        (component_verified_for_actor ?release_train ?release_component)
        (pre_release_checks_completed ?release_train)
        (actor_has_assigned_wave ?release_train)
        (actor_registered ?release_train)
        (not
          (actor_finalized ?release_train)
        )
        (automation_agent_available ?release_train)
      )
    :effect
      (and
        (actor_finalized ?release_train)
      )
  )
  (:action validate_reserved_target
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target)
    :precondition
      (and
        (actor_registered ?release_train)
        (actor_has_assigned_wave ?release_train)
        (not
          (validation_passed ?release_train)
        )
        (target_reserved_for_actor ?release_train ?deployment_target)
      )
    :effect
      (and
        (validation_passed ?release_train)
      )
  )
  (:action assign_promotion_wave
    :parameters (?release_train - deployment_actor ?promotion_wave - promotion_wave)
    :precondition
      (and
        (not
          (actor_has_assigned_wave ?release_train)
        )
        (actor_registered ?release_train)
        (wave_available ?promotion_wave)
        (wave_permitted_for_actor ?release_train ?promotion_wave)
      )
    :effect
      (and
        (actor_has_assigned_wave ?release_train)
        (not
          (wave_available ?promotion_wave)
        )
        (actor_has_wave ?release_train ?promotion_wave)
      )
  )
  (:action revalidate_target_after_canary
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target ?runbook_check - runbook_check)
    :precondition
      (and
        (actor_has_assigned_wave ?release_train)
        (not
          (pre_release_checks_completed ?release_train)
        )
        (target_reserved_for_actor ?release_train ?deployment_target)
        (promotion_authorized ?release_train)
        (runbook_check_available ?runbook_check)
        (canary_stage_enabled ?release_train)
      )
    :effect
      (and
        (pre_release_checks_completed ?release_train)
      )
  )
  (:action associate_component_with_agent_or_role
    :parameters (?automation_agent - release_train_automation_agent ?engineer_role - release_train_engineer_role ?release_component - release_component)
    :precondition
      (and
        (actor_registered ?automation_agent)
        (component_assigned_to_role ?engineer_role ?release_component)
        (automation_agent_available ?automation_agent)
        (not
          (component_verified_for_actor ?automation_agent ?release_component)
        )
        (entity_assigned_component ?automation_agent ?release_component)
      )
    :effect
      (and
        (component_verified_for_actor ?automation_agent ?release_component)
      )
  )
)

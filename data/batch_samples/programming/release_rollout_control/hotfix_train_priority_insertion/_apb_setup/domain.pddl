(define (domain hotfix_train_rollout_control)
  (:requirements :strips :typing :negative-preconditions)
  (:types deployment_actor - object promotion_wave - object deployment_environment - object service - object artifact - object infrastructure_component - object deployment_target - object approval_token - object release_component - object runbook_check - object maintenance_window - object hotfix_patch - object stakeholder_group - object canary_segment - stakeholder_group compliance_constraint - stakeholder_group release_train_engineer_role - deployment_actor release_train_automation_agent - deployment_actor)
  (:predicates
    (actor_registered ?release_train - deployment_actor)
    (actor_has_wave ?release_train - deployment_actor ?promotion_wave - promotion_wave)
    (actor_has_assigned_wave ?release_train - deployment_actor)
    (validation_passed ?release_train - deployment_actor)
    (pre_release_checks_completed ?release_train - deployment_actor)
    (artifact_bound_to_actor ?release_train - deployment_actor ?artifact - artifact)
    (service_bound_to_actor ?release_train - deployment_actor ?service - service)
    (infra_bound_to_actor ?release_train - deployment_actor ?infrastructure_component - infrastructure_component)
    (patch_bound_to_actor ?release_train - deployment_actor ?hotfix_patch - hotfix_patch)
    (actor_promoted_to_environment ?release_train - deployment_actor ?deployment_environment - deployment_environment)
    (promotion_in_progress ?release_train - deployment_actor)
    (promotion_authorized ?release_train - deployment_actor)
    (targets_committed ?release_train - deployment_actor)
    (actor_finalized ?release_train - deployment_actor)
    (approval_recorded ?release_train - deployment_actor)
    (canary_stage_enabled ?release_train - deployment_actor)
    (entity_assigned_component ?release_train - deployment_actor ?release_component - release_component)
    (component_verified_for_actor ?release_train - deployment_actor ?release_component - release_component)
    (deployment_ready ?release_train - deployment_actor)
    (wave_available ?promotion_wave - promotion_wave)
    (environment_available ?deployment_environment - deployment_environment)
    (artifact_available ?artifact - artifact)
    (service_available ?service - service)
    (infrastructure_available ?infrastructure_component - infrastructure_component)
    (target_available ?deployment_target - deployment_target)
    (approval_token_available ?approval_token - approval_token)
    (component_available ?release_component - release_component)
    (runbook_check_available ?runbook_check - runbook_check)
    (maintenance_window_available ?maintenance_window - maintenance_window)
    (hotfix_patch_available ?hotfix_patch - hotfix_patch)
    (wave_permitted_for_actor ?release_train - deployment_actor ?promotion_wave - promotion_wave)
    (environment_permitted_for_actor ?release_train - deployment_actor ?deployment_environment - deployment_environment)
    (artifact_permitted_for_actor ?release_train - deployment_actor ?artifact - artifact)
    (service_permitted_for_actor ?release_train - deployment_actor ?service - service)
    (infra_permitted_for_actor ?release_train - deployment_actor ?infrastructure_component - infrastructure_component)
    (maintenance_window_permitted_for_actor ?release_train - deployment_actor ?maintenance_window - maintenance_window)
    (patch_permitted_for_actor ?release_train - deployment_actor ?hotfix_patch - hotfix_patch)
    (actor_has_stakeholder_group ?release_train - deployment_actor ?stakeholder_group - stakeholder_group)
    (component_assigned_to_role ?release_train - deployment_actor ?release_component - release_component)
    (actor_bootstrapped ?release_train - deployment_actor)
    (automation_agent_available ?release_train - deployment_actor)
    (target_reserved_for_actor ?release_train - deployment_actor ?deployment_target - deployment_target)
    (rollback_prepared ?release_train - deployment_actor)
    (component_permitted_for_actor ?release_train - deployment_actor ?release_component - release_component)
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
  (:action assign_promotion_wave
    :parameters (?release_train - deployment_actor ?promotion_wave - promotion_wave)
    :precondition
      (and
        (actor_registered ?release_train)
        (wave_available ?promotion_wave)
        (wave_permitted_for_actor ?release_train ?promotion_wave)
        (not
          (actor_has_assigned_wave ?release_train)
        )
      )
    :effect
      (and
        (actor_has_wave ?release_train ?promotion_wave)
        (actor_has_assigned_wave ?release_train)
        (not
          (wave_available ?promotion_wave)
        )
      )
  )
  (:action remove_promotion_wave
    :parameters (?release_train - deployment_actor ?promotion_wave - promotion_wave)
    :precondition
      (and
        (actor_has_wave ?release_train ?promotion_wave)
        (not
          (promotion_in_progress ?release_train)
        )
        (not
          (promotion_authorized ?release_train)
        )
      )
    :effect
      (and
        (not
          (actor_has_wave ?release_train ?promotion_wave)
        )
        (not
          (actor_has_assigned_wave ?release_train)
        )
        (not
          (validation_passed ?release_train)
        )
        (not
          (pre_release_checks_completed ?release_train)
        )
        (not
          (approval_recorded ?release_train)
        )
        (not
          (canary_stage_enabled ?release_train)
        )
        (not
          (rollback_prepared ?release_train)
        )
        (wave_available ?promotion_wave)
      )
  )
  (:action reserve_deployment_target
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target)
    :precondition
      (and
        (actor_registered ?release_train)
        (target_available ?deployment_target)
      )
    :effect
      (and
        (target_reserved_for_actor ?release_train ?deployment_target)
        (not
          (target_available ?deployment_target)
        )
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
  (:action validate_reserved_target
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target)
    :precondition
      (and
        (actor_registered ?release_train)
        (actor_has_assigned_wave ?release_train)
        (target_reserved_for_actor ?release_train ?deployment_target)
        (not
          (validation_passed ?release_train)
        )
      )
    :effect
      (and
        (validation_passed ?release_train)
      )
  )
  (:action consume_approval_token
    :parameters (?release_train - deployment_actor ?approval_token - approval_token)
    :precondition
      (and
        (actor_registered ?release_train)
        (actor_has_assigned_wave ?release_train)
        (approval_token_available ?approval_token)
        (not
          (validation_passed ?release_train)
        )
      )
    :effect
      (and
        (validation_passed ?release_train)
        (approval_recorded ?release_train)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action complete_runbook_check
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target ?runbook_check - runbook_check)
    :precondition
      (and
        (validation_passed ?release_train)
        (actor_has_assigned_wave ?release_train)
        (target_reserved_for_actor ?release_train ?deployment_target)
        (runbook_check_available ?runbook_check)
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
        (artifact_bound_to_actor ?release_train ?artifact)
        (not
          (artifact_available ?artifact)
        )
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
  (:action reserve_and_bind_infrastructure
    :parameters (?release_train - deployment_actor ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (actor_registered ?release_train)
        (infrastructure_available ?infrastructure_component)
        (infra_permitted_for_actor ?release_train ?infrastructure_component)
      )
    :effect
      (and
        (infra_bound_to_actor ?release_train ?infrastructure_component)
        (not
          (infrastructure_available ?infrastructure_component)
        )
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
  (:action reserve_and_bind_patch
    :parameters (?release_train - deployment_actor ?hotfix_patch - hotfix_patch)
    :precondition
      (and
        (actor_registered ?release_train)
        (hotfix_patch_available ?hotfix_patch)
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
  (:action execute_promotion_step
    :parameters (?release_train - deployment_actor ?deployment_environment - deployment_environment ?artifact - artifact ?service - service)
    :precondition
      (and
        (actor_has_assigned_wave ?release_train)
        (artifact_bound_to_actor ?release_train ?artifact)
        (service_bound_to_actor ?release_train ?service)
        (environment_available ?deployment_environment)
        (environment_permitted_for_actor ?release_train ?deployment_environment)
        (not
          (promotion_in_progress ?release_train)
        )
      )
    :effect
      (and
        (actor_promoted_to_environment ?release_train ?deployment_environment)
        (promotion_in_progress ?release_train)
        (not
          (environment_available ?deployment_environment)
        )
      )
  )
  (:action execute_promotion_with_maintenance
    :parameters (?release_train - deployment_actor ?deployment_environment - deployment_environment ?infrastructure_component - infrastructure_component ?maintenance_window - maintenance_window)
    :precondition
      (and
        (actor_has_assigned_wave ?release_train)
        (infra_bound_to_actor ?release_train ?infrastructure_component)
        (maintenance_window_available ?maintenance_window)
        (environment_available ?deployment_environment)
        (environment_permitted_for_actor ?release_train ?deployment_environment)
        (maintenance_window_permitted_for_actor ?release_train ?maintenance_window)
        (not
          (promotion_in_progress ?release_train)
        )
      )
    :effect
      (and
        (actor_promoted_to_environment ?release_train ?deployment_environment)
        (promotion_in_progress ?release_train)
        (rollback_prepared ?release_train)
        (approval_recorded ?release_train)
        (not
          (environment_available ?deployment_environment)
        )
        (not
          (maintenance_window_available ?maintenance_window)
        )
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
  (:action authorize_promotion_by_stakeholders
    :parameters (?release_train - deployment_actor ?artifact - artifact ?service - service ?canary_segment - canary_segment)
    :precondition
      (and
        (pre_release_checks_completed ?release_train)
        (promotion_in_progress ?release_train)
        (artifact_bound_to_actor ?release_train ?artifact)
        (service_bound_to_actor ?release_train ?service)
        (actor_has_stakeholder_group ?release_train ?canary_segment)
        (not
          (approval_recorded ?release_train)
        )
        (not
          (promotion_authorized ?release_train)
        )
      )
    :effect
      (and
        (promotion_authorized ?release_train)
      )
  )
  (:action authorize_promotion_with_compliance
    :parameters (?release_train - deployment_actor ?infrastructure_component - infrastructure_component ?hotfix_patch - hotfix_patch ?compliance_constraint - compliance_constraint)
    :precondition
      (and
        (pre_release_checks_completed ?release_train)
        (promotion_in_progress ?release_train)
        (infra_bound_to_actor ?release_train ?infrastructure_component)
        (patch_bound_to_actor ?release_train ?hotfix_patch)
        (actor_has_stakeholder_group ?release_train ?compliance_constraint)
        (not
          (promotion_authorized ?release_train)
        )
      )
    :effect
      (and
        (promotion_authorized ?release_train)
        (approval_recorded ?release_train)
      )
  )
  (:action initiate_rollout_phase
    :parameters (?release_train - deployment_actor ?artifact - artifact ?service - service)
    :precondition
      (and
        (promotion_authorized ?release_train)
        (approval_recorded ?release_train)
        (artifact_bound_to_actor ?release_train ?artifact)
        (service_bound_to_actor ?release_train ?service)
      )
    :effect
      (and
        (canary_stage_enabled ?release_train)
        (not
          (approval_recorded ?release_train)
        )
        (not
          (pre_release_checks_completed ?release_train)
        )
        (not
          (rollback_prepared ?release_train)
        )
      )
  )
  (:action revalidate_target_after_canary
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target ?runbook_check - runbook_check)
    :precondition
      (and
        (canary_stage_enabled ?release_train)
        (promotion_authorized ?release_train)
        (actor_has_assigned_wave ?release_train)
        (target_reserved_for_actor ?release_train ?deployment_target)
        (runbook_check_available ?runbook_check)
        (not
          (pre_release_checks_completed ?release_train)
        )
      )
    :effect
      (and
        (pre_release_checks_completed ?release_train)
      )
  )
  (:action commit_targets_for_promotion
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target)
    :precondition
      (and
        (promotion_authorized ?release_train)
        (pre_release_checks_completed ?release_train)
        (not
          (approval_recorded ?release_train)
        )
        (target_reserved_for_actor ?release_train ?deployment_target)
        (not
          (targets_committed ?release_train)
        )
      )
    :effect
      (and
        (targets_committed ?release_train)
      )
  )
  (:action commit_approval_for_promotion
    :parameters (?release_train - deployment_actor ?approval_token - approval_token)
    :precondition
      (and
        (promotion_authorized ?release_train)
        (pre_release_checks_completed ?release_train)
        (not
          (approval_recorded ?release_train)
        )
        (approval_token_available ?approval_token)
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
  (:action associate_component_with_agent_or_role
    :parameters (?automation_agent - release_train_automation_agent ?engineer_role - release_train_engineer_role ?release_component - release_component)
    :precondition
      (and
        (actor_registered ?automation_agent)
        (automation_agent_available ?automation_agent)
        (entity_assigned_component ?automation_agent ?release_component)
        (component_assigned_to_role ?engineer_role ?release_component)
        (not
          (component_verified_for_actor ?automation_agent ?release_component)
        )
      )
    :effect
      (and
        (component_verified_for_actor ?automation_agent ?release_component)
      )
  )
  (:action mark_deployment_ready
    :parameters (?release_train - deployment_actor ?deployment_target - deployment_target ?runbook_check - runbook_check)
    :precondition
      (and
        (actor_registered ?release_train)
        (automation_agent_available ?release_train)
        (pre_release_checks_completed ?release_train)
        (targets_committed ?release_train)
        (target_reserved_for_actor ?release_train ?deployment_target)
        (runbook_check_available ?runbook_check)
        (not
          (deployment_ready ?release_train)
        )
      )
    :effect
      (and
        (deployment_ready ?release_train)
      )
  )
  (:action finalize_actor_registration
    :parameters (?release_train - deployment_actor)
    :precondition
      (and
        (actor_bootstrapped ?release_train)
        (actor_registered ?release_train)
        (actor_has_assigned_wave ?release_train)
        (promotion_in_progress ?release_train)
        (promotion_authorized ?release_train)
        (targets_committed ?release_train)
        (pre_release_checks_completed ?release_train)
        (not
          (actor_finalized ?release_train)
        )
      )
    :effect
      (and
        (actor_finalized ?release_train)
      )
  )
  (:action finalize_actor_with_component_validation
    :parameters (?release_train - deployment_actor ?release_component - release_component)
    :precondition
      (and
        (automation_agent_available ?release_train)
        (actor_registered ?release_train)
        (actor_has_assigned_wave ?release_train)
        (promotion_in_progress ?release_train)
        (promotion_authorized ?release_train)
        (targets_committed ?release_train)
        (pre_release_checks_completed ?release_train)
        (component_verified_for_actor ?release_train ?release_component)
        (not
          (actor_finalized ?release_train)
        )
      )
    :effect
      (and
        (actor_finalized ?release_train)
      )
  )
  (:action finalize_actor_with_deployment_ready
    :parameters (?release_train - deployment_actor)
    :precondition
      (and
        (automation_agent_available ?release_train)
        (actor_registered ?release_train)
        (actor_has_assigned_wave ?release_train)
        (promotion_in_progress ?release_train)
        (promotion_authorized ?release_train)
        (targets_committed ?release_train)
        (pre_release_checks_completed ?release_train)
        (deployment_ready ?release_train)
        (not
          (actor_finalized ?release_train)
        )
      )
    :effect
      (and
        (actor_finalized ?release_train)
      )
  )
)

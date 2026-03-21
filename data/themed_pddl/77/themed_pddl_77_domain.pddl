(define (domain release_rollout_control)
  (:requirements :strips :typing :negative-preconditions)
  (:types release_instance - entity rollout_wave - entity deployment_target - entity service_dependency - entity component - entity infrastructure_component - entity runbook - entity approver - entity rollback_template - entity operator - entity infrastructure_resource - entity configuration_snapshot - entity stakeholder_group - entity dev_team - stakeholder_group ops_team - stakeholder_group canary_release_variant - release_instance full_release_variant - release_instance)
  (:predicates
    (approver_available ?approver - approver)
    (dependency_reserved ?release_instance - release_instance ?service_dependency - service_dependency)
    (finalization_ready ?release_instance - release_instance)
    (release_assigned_to_wave ?release_instance - release_instance ?rollout_wave - rollout_wave)
    (release_stakeholder_association ?release_instance - release_instance ?stakeholder_group - stakeholder_group)
    (infrastructure_component_available ?infrastructure_component - infrastructure_component)
    (dependency_available ?service_dependency - service_dependency)
    (release_configuration_snapshot_binding ?release_instance - release_instance ?configuration_snapshot - configuration_snapshot)
    (release_finalized ?release_instance - release_instance)
    (is_canary_variant ?release_instance - release_instance)
    (release_allowed_in_wave ?release_instance - release_instance ?rollout_wave - rollout_wave)
    (target_available ?deployment_target - deployment_target)
    (infrastructure_resource_available ?infrastructure_resource - infrastructure_resource)
    (runbook_available ?runbook - runbook)
    (deployment_completed ?release_instance - release_instance)
    (release_dependency_binding ?release_instance - release_instance ?service_dependency - service_dependency)
    (configuration_snapshot_reserved ?release_instance - release_instance ?configuration_snapshot - configuration_snapshot)
    (deployed_to_target ?release_instance - release_instance ?deployment_target - deployment_target)
    (promotion_approved ?release_instance - release_instance)
    (release_infra_component_binding ?release_instance - release_instance ?infrastructure_component - infrastructure_component)
    (configuration_snapshot_available ?configuration_snapshot - configuration_snapshot)
    (is_full_variant ?release_instance - release_instance)
    (operator_checks_completed ?release_instance - release_instance)
    (release_component_binding ?release_instance - release_instance ?component - component)
    (component_reserved ?release_instance - release_instance ?component - component)
    (verification_pending ?release_instance - release_instance)
    (release_bound_runbook ?release_instance - release_instance ?runbook - runbook)
    (monitoring_started ?release_instance - release_instance)
    (release_infra_resource_binding ?release_instance - release_instance ?infrastructure_resource - infrastructure_resource)
    (release_registered ?release_instance - release_instance)
    (wave_available ?rollout_wave - rollout_wave)
    (release_assigned ?release_instance - release_instance)
    (operator_available ?operator - operator)
    (rollback_template_available ?rollback_template - rollback_template)
    (infrastructure_component_reserved ?release_instance - release_instance ?infrastructure_component - infrastructure_component)
    (rollback_template_committed ?release_instance - release_instance ?rollback_template - rollback_template)
    (release_readiness_validated ?release_instance - release_instance)
    (monitoring_linked ?release_instance - release_instance)
    (variant_has_rollback_template_link ?release_instance - release_instance ?rollback_template - rollback_template)
    (component_available ?component - component)
    (has_rollback_template ?release_instance - release_instance ?rollback_template - rollback_template)
    (release_target_binding ?release_instance - release_instance ?deployment_target - deployment_target)
    (approval_recorded ?release_instance - release_instance)
    (rollback_template_authorized ?release_instance - release_instance ?rollback_template - rollback_template)
  )
  (:action release_configuration_snapshot_reservation
    :parameters (?release_instance - release_instance ?configuration_snapshot - configuration_snapshot)
    :precondition
      (and
        (configuration_snapshot_reserved ?release_instance ?configuration_snapshot)
      )
    :effect
      (and
        (configuration_snapshot_available ?configuration_snapshot)
        (not
          (configuration_snapshot_reserved ?release_instance ?configuration_snapshot)
        )
      )
  )
  (:action ops_approve_promotion
    :parameters (?release_instance - release_instance ?infrastructure_component - infrastructure_component ?configuration_snapshot - configuration_snapshot ?ops_team - ops_team)
    :precondition
      (and
        (not
          (promotion_approved ?release_instance)
        )
        (deployment_completed ?release_instance)
        (operator_checks_completed ?release_instance)
        (configuration_snapshot_reserved ?release_instance ?configuration_snapshot)
        (release_stakeholder_association ?release_instance ?ops_team)
        (infrastructure_component_reserved ?release_instance ?infrastructure_component)
      )
    :effect
      (and
        (approval_recorded ?release_instance)
        (promotion_approved ?release_instance)
      )
  )
  (:action finalize_canary_release
    :parameters (?release_instance - release_instance)
    :precondition
      (and
        (operator_checks_completed ?release_instance)
        (release_assigned ?release_instance)
        (deployment_completed ?release_instance)
        (release_registered ?release_instance)
        (monitoring_linked ?release_instance)
        (not
          (release_finalized ?release_instance)
        )
        (is_canary_variant ?release_instance)
        (promotion_approved ?release_instance)
      )
    :effect
      (and
        (release_finalized ?release_instance)
      )
  )
  (:action clear_post_deploy_verification
    :parameters (?release_instance - release_instance ?component - component ?service_dependency - service_dependency)
    :precondition
      (and
        (deployment_completed ?release_instance)
        (verification_pending ?release_instance)
        (component_reserved ?release_instance ?component)
        (dependency_reserved ?release_instance ?service_dependency)
      )
    :effect
      (and
        (not
          (verification_pending ?release_instance)
        )
        (not
          (approval_recorded ?release_instance)
        )
      )
  )
  (:action bind_runbook_to_release
    :parameters (?release_instance - release_instance ?runbook - runbook)
    :precondition
      (and
        (runbook_available ?runbook)
        (release_registered ?release_instance)
      )
    :effect
      (and
        (not
          (runbook_available ?runbook)
        )
        (release_bound_runbook ?release_instance ?runbook)
      )
  )
  (:action approve_promotion
    :parameters (?release_instance - release_instance ?component - component ?service_dependency - service_dependency ?dev_team - dev_team)
    :precondition
      (and
        (release_stakeholder_association ?release_instance ?dev_team)
        (operator_checks_completed ?release_instance)
        (not
          (approval_recorded ?release_instance)
        )
        (component_reserved ?release_instance ?component)
        (deployment_completed ?release_instance)
        (dependency_reserved ?release_instance ?service_dependency)
        (not
          (promotion_approved ?release_instance)
        )
      )
    :effect
      (and
        (promotion_approved ?release_instance)
      )
  )
  (:action assert_rollback_template_available
    :parameters (?release_instance - release_instance ?rollback_template - rollback_template)
    :precondition
      (and
        (release_assigned ?release_instance)
        (rollback_template_authorized ?release_instance ?rollback_template)
        (not
          (operator_checks_completed ?release_instance)
        )
      )
    :effect
      (and
        (operator_checks_completed ?release_instance)
        (not
          (approval_recorded ?release_instance)
        )
      )
  )
  (:action reserve_infra_component_for_release
    :parameters (?release_instance - release_instance ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (release_infra_component_binding ?release_instance ?infrastructure_component)
        (release_registered ?release_instance)
        (infrastructure_component_available ?infrastructure_component)
      )
    :effect
      (and
        (infrastructure_component_reserved ?release_instance ?infrastructure_component)
        (not
          (infrastructure_component_available ?infrastructure_component)
        )
      )
  )
  (:action reserve_component_for_release
    :parameters (?release_instance - release_instance ?component - component)
    :precondition
      (and
        (release_registered ?release_instance)
        (component_available ?component)
        (release_component_binding ?release_instance ?component)
      )
    :effect
      (and
        (not
          (component_available ?component)
        )
        (component_reserved ?release_instance ?component)
      )
  )
  (:action release_infrastructure_component_reservation
    :parameters (?release_instance - release_instance ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (infrastructure_component_reserved ?release_instance ?infrastructure_component)
      )
    :effect
      (and
        (infrastructure_component_available ?infrastructure_component)
        (not
          (infrastructure_component_reserved ?release_instance ?infrastructure_component)
        )
      )
  )
  (:action release_dependency_reservation
    :parameters (?release_instance - release_instance ?service_dependency - service_dependency)
    :precondition
      (and
        (dependency_reserved ?release_instance ?service_dependency)
      )
    :effect
      (and
        (dependency_available ?service_dependency)
        (not
          (dependency_reserved ?release_instance ?service_dependency)
        )
      )
  )
  (:action bind_rollback_template_to_release
    :parameters (?release_instance - release_instance ?rollback_template - rollback_template)
    :precondition
      (and
        (monitoring_linked ?release_instance)
        (rollback_template_available ?rollback_template)
        (variant_has_rollback_template_link ?release_instance ?rollback_template)
      )
    :effect
      (and
        (rollback_template_committed ?release_instance ?rollback_template)
        (not
          (rollback_template_available ?rollback_template)
        )
      )
  )
  (:action reserve_dependency_for_release
    :parameters (?release_instance - release_instance ?service_dependency - service_dependency)
    :precondition
      (and
        (release_registered ?release_instance)
        (dependency_available ?service_dependency)
        (release_dependency_binding ?release_instance ?service_dependency)
      )
    :effect
      (and
        (dependency_reserved ?release_instance ?service_dependency)
        (not
          (dependency_available ?service_dependency)
        )
      )
  )
  (:action execute_deployment_to_target
    :parameters (?release_instance - release_instance ?deployment_target - deployment_target ?component - component ?service_dependency - service_dependency)
    :precondition
      (and
        (release_assigned ?release_instance)
        (target_available ?deployment_target)
        (release_target_binding ?release_instance ?deployment_target)
        (not
          (deployment_completed ?release_instance)
        )
        (dependency_reserved ?release_instance ?service_dependency)
        (component_reserved ?release_instance ?component)
      )
    :effect
      (and
        (deployed_to_target ?release_instance ?deployment_target)
        (not
          (target_available ?deployment_target)
        )
        (deployment_completed ?release_instance)
      )
  )
  (:action finalize_promotion_stage
    :parameters (?release_instance - release_instance ?component - component ?service_dependency - service_dependency)
    :precondition
      (and
        (component_reserved ?release_instance ?component)
        (promotion_approved ?release_instance)
        (dependency_reserved ?release_instance ?service_dependency)
        (approval_recorded ?release_instance)
      )
    :effect
      (and
        (not
          (verification_pending ?release_instance)
        )
        (not
          (approval_recorded ?release_instance)
        )
        (not
          (operator_checks_completed ?release_instance)
        )
        (finalization_ready ?release_instance)
      )
  )
  (:action unbind_runbook_from_release
    :parameters (?release_instance - release_instance ?runbook - runbook)
    :precondition
      (and
        (release_bound_runbook ?release_instance ?runbook)
      )
    :effect
      (and
        (runbook_available ?runbook)
        (not
          (release_bound_runbook ?release_instance ?runbook)
        )
      )
  )
  (:action operator_precheck_with_runbook
    :parameters (?release_instance - release_instance ?runbook - runbook ?operator - operator)
    :precondition
      (and
        (not
          (operator_checks_completed ?release_instance)
        )
        (release_assigned ?release_instance)
        (operator_available ?operator)
        (release_bound_runbook ?release_instance ?runbook)
        (release_readiness_validated ?release_instance)
      )
    :effect
      (and
        (not
          (approval_recorded ?release_instance)
        )
        (operator_checks_completed ?release_instance)
      )
  )
  (:action finalize_release_after_monitoring
    :parameters (?release_instance - release_instance)
    :precondition
      (and
        (release_registered ?release_instance)
        (is_full_variant ?release_instance)
        (monitoring_started ?release_instance)
        (release_assigned ?release_instance)
        (operator_checks_completed ?release_instance)
        (not
          (release_finalized ?release_instance)
        )
        (monitoring_linked ?release_instance)
        (deployment_completed ?release_instance)
        (promotion_approved ?release_instance)
      )
    :effect
      (and
        (release_finalized ?release_instance)
      )
  )
  (:action start_post_deployment_monitoring
    :parameters (?release_instance - release_instance ?runbook - runbook ?operator - operator)
    :precondition
      (and
        (operator_checks_completed ?release_instance)
        (operator_available ?operator)
        (not
          (monitoring_started ?release_instance)
        )
        (monitoring_linked ?release_instance)
        (release_registered ?release_instance)
        (is_full_variant ?release_instance)
        (release_bound_runbook ?release_instance ?runbook)
      )
    :effect
      (and
        (monitoring_started ?release_instance)
      )
  )
  (:action release_component_reservation
    :parameters (?release_instance - release_instance ?component - component)
    :precondition
      (and
        (component_reserved ?release_instance ?component)
      )
    :effect
      (and
        (component_available ?component)
        (not
          (component_reserved ?release_instance ?component)
        )
      )
  )
  (:action reserve_configuration_snapshot_for_release
    :parameters (?release_instance - release_instance ?configuration_snapshot - configuration_snapshot)
    :precondition
      (and
        (configuration_snapshot_available ?configuration_snapshot)
        (release_registered ?release_instance)
        (release_configuration_snapshot_binding ?release_instance ?configuration_snapshot)
      )
    :effect
      (and
        (configuration_snapshot_reserved ?release_instance ?configuration_snapshot)
        (not
          (configuration_snapshot_available ?configuration_snapshot)
        )
      )
  )
  (:action initialize_release
    :parameters (?release_instance - release_instance)
    :precondition
      (and
        (not
          (release_registered ?release_instance)
        )
        (not
          (release_finalized ?release_instance)
        )
      )
    :effect
      (and
        (release_registered ?release_instance)
      )
  )
  (:action apply_approval_for_release
    :parameters (?release_instance - release_instance ?approver - approver)
    :precondition
      (and
        (not
          (release_readiness_validated ?release_instance)
        )
        (release_registered ?release_instance)
        (approver_available ?approver)
        (release_assigned ?release_instance)
      )
    :effect
      (and
        (approval_recorded ?release_instance)
        (not
          (approver_available ?approver)
        )
        (release_readiness_validated ?release_instance)
      )
  )
  (:action execute_deployment_with_infra_resources
    :parameters (?release_instance - release_instance ?deployment_target - deployment_target ?infrastructure_component - infrastructure_component ?infrastructure_resource - infrastructure_resource)
    :precondition
      (and
        (infrastructure_resource_available ?infrastructure_resource)
        (release_infra_resource_binding ?release_instance ?infrastructure_resource)
        (not
          (deployment_completed ?release_instance)
        )
        (release_assigned ?release_instance)
        (target_available ?deployment_target)
        (release_target_binding ?release_instance ?deployment_target)
        (infrastructure_component_reserved ?release_instance ?infrastructure_component)
      )
    :effect
      (and
        (deployed_to_target ?release_instance ?deployment_target)
        (not
          (infrastructure_resource_available ?infrastructure_resource)
        )
        (verification_pending ?release_instance)
        (not
          (target_available ?deployment_target)
        )
        (approval_recorded ?release_instance)
        (deployment_completed ?release_instance)
      )
  )
  (:action mark_approver_linked_for_monitoring
    :parameters (?release_instance - release_instance ?approver - approver)
    :precondition
      (and
        (approver_available ?approver)
        (not
          (approval_recorded ?release_instance)
        )
        (operator_checks_completed ?release_instance)
        (promotion_approved ?release_instance)
        (not
          (monitoring_linked ?release_instance)
        )
      )
    :effect
      (and
        (monitoring_linked ?release_instance)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action unschedule_release_from_wave
    :parameters (?release_instance - release_instance ?rollout_wave - rollout_wave)
    :precondition
      (and
        (release_assigned_to_wave ?release_instance ?rollout_wave)
        (not
          (promotion_approved ?release_instance)
        )
        (not
          (deployment_completed ?release_instance)
        )
      )
    :effect
      (and
        (not
          (release_assigned_to_wave ?release_instance ?rollout_wave)
        )
        (wave_available ?rollout_wave)
        (not
          (release_assigned ?release_instance)
        )
        (not
          (release_readiness_validated ?release_instance)
        )
        (not
          (finalization_ready ?release_instance)
        )
        (not
          (operator_checks_completed ?release_instance)
        )
        (not
          (verification_pending ?release_instance)
        )
        (not
          (approval_recorded ?release_instance)
        )
      )
  )
  (:action mark_runbook_linked_for_monitoring
    :parameters (?release_instance - release_instance ?runbook - runbook)
    :precondition
      (and
        (not
          (monitoring_linked ?release_instance)
        )
        (release_bound_runbook ?release_instance ?runbook)
        (operator_checks_completed ?release_instance)
        (promotion_approved ?release_instance)
        (not
          (approval_recorded ?release_instance)
        )
      )
    :effect
      (and
        (monitoring_linked ?release_instance)
      )
  )
  (:action finalize_full_release_with_template
    :parameters (?release_instance - release_instance ?rollback_template - rollback_template)
    :precondition
      (and
        (monitoring_linked ?release_instance)
        (promotion_approved ?release_instance)
        (deployment_completed ?release_instance)
        (rollback_template_authorized ?release_instance ?rollback_template)
        (operator_checks_completed ?release_instance)
        (release_assigned ?release_instance)
        (release_registered ?release_instance)
        (not
          (release_finalized ?release_instance)
        )
        (is_full_variant ?release_instance)
      )
    :effect
      (and
        (release_finalized ?release_instance)
      )
  )
  (:action validate_runbook_readiness
    :parameters (?release_instance - release_instance ?runbook - runbook)
    :precondition
      (and
        (release_registered ?release_instance)
        (release_assigned ?release_instance)
        (not
          (release_readiness_validated ?release_instance)
        )
        (release_bound_runbook ?release_instance ?runbook)
      )
    :effect
      (and
        (release_readiness_validated ?release_instance)
      )
  )
  (:action assign_release_to_wave
    :parameters (?release_instance - release_instance ?rollout_wave - rollout_wave)
    :precondition
      (and
        (not
          (release_assigned ?release_instance)
        )
        (release_registered ?release_instance)
        (wave_available ?rollout_wave)
        (release_allowed_in_wave ?release_instance ?rollout_wave)
      )
    :effect
      (and
        (release_assigned ?release_instance)
        (not
          (wave_available ?rollout_wave)
        )
        (release_assigned_to_wave ?release_instance ?rollout_wave)
      )
  )
  (:action reenable_operator_checks
    :parameters (?release_instance - release_instance ?runbook - runbook ?operator - operator)
    :precondition
      (and
        (release_assigned ?release_instance)
        (not
          (operator_checks_completed ?release_instance)
        )
        (release_bound_runbook ?release_instance ?runbook)
        (promotion_approved ?release_instance)
        (operator_available ?operator)
        (finalization_ready ?release_instance)
      )
    :effect
      (and
        (operator_checks_completed ?release_instance)
      )
  )
  (:action authorize_cross_variant_rollback
    :parameters (?full_release_variant - full_release_variant ?canary_release_variant - canary_release_variant ?rollback_template - rollback_template)
    :precondition
      (and
        (release_registered ?full_release_variant)
        (rollback_template_committed ?canary_release_variant ?rollback_template)
        (is_full_variant ?full_release_variant)
        (not
          (rollback_template_authorized ?full_release_variant ?rollback_template)
        )
        (has_rollback_template ?full_release_variant ?rollback_template)
      )
    :effect
      (and
        (rollback_template_authorized ?full_release_variant ?rollback_template)
      )
  )
)

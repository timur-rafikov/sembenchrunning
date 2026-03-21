(define (domain release_rollout_control)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object release_instance - entity rollout_wave - entity deployment_target - entity service_dependency - entity component - entity infrastructure_component - entity runbook - entity approver - entity rollback_template - entity operator - entity infrastructure_resource - entity configuration_snapshot - entity stakeholder_group - entity dev_team - stakeholder_group ops_team - stakeholder_group canary_release_variant - release_instance full_release_variant - release_instance)

  (:predicates
    (release_registered ?release_instance - release_instance)
    (release_assigned_to_wave ?release_instance - release_instance ?rollout_wave - rollout_wave)
    (release_assigned ?release_instance - release_instance)
    (release_readiness_validated ?release_instance - release_instance)
    (operator_checks_completed ?release_instance - release_instance)
    (component_reserved ?release_instance - release_instance ?component - component)
    (dependency_reserved ?release_instance - release_instance ?service_dependency - service_dependency)
    (infrastructure_component_reserved ?release_instance - release_instance ?infrastructure_component - infrastructure_component)
    (configuration_snapshot_reserved ?release_instance - release_instance ?configuration_snapshot - configuration_snapshot)
    (deployed_to_target ?release_instance - release_instance ?deployment_target - deployment_target)
    (deployment_completed ?release_instance - release_instance)
    (promotion_approved ?release_instance - release_instance)
    (monitoring_linked ?release_instance - release_instance)
    (release_finalized ?release_instance - release_instance)
    (approval_recorded ?release_instance - release_instance)
    (finalization_ready ?release_instance - release_instance)
    (has_rollback_template ?release_instance - release_instance ?rollback_template - rollback_template)
    (rollback_template_authorized ?release_instance - release_instance ?rollback_template - rollback_template)
    (monitoring_started ?release_instance - release_instance)
    (wave_available ?rollout_wave - rollout_wave)
    (target_available ?deployment_target - deployment_target)
    (component_available ?component - component)
    (dependency_available ?service_dependency - service_dependency)
    (infrastructure_component_available ?infrastructure_component - infrastructure_component)
    (runbook_available ?runbook - runbook)
    (approver_available ?approver - approver)
    (rollback_template_available ?rollback_template - rollback_template)
    (operator_available ?operator - operator)
    (infrastructure_resource_available ?infrastructure_resource - infrastructure_resource)
    (configuration_snapshot_available ?configuration_snapshot - configuration_snapshot)
    (release_allowed_in_wave ?release_instance - release_instance ?rollout_wave - rollout_wave)
    (release_target_binding ?release_instance - release_instance ?deployment_target - deployment_target)
    (release_component_binding ?release_instance - release_instance ?component - component)
    (release_dependency_binding ?release_instance - release_instance ?service_dependency - service_dependency)
    (release_infra_component_binding ?release_instance - release_instance ?infrastructure_component - infrastructure_component)
    (release_infra_resource_binding ?release_instance - release_instance ?infrastructure_resource - infrastructure_resource)
    (release_configuration_snapshot_binding ?release_instance - release_instance ?configuration_snapshot - configuration_snapshot)
    (release_stakeholder_association ?release_instance - release_instance ?stakeholder_group - stakeholder_group)
    (rollback_template_committed ?release_instance - release_instance ?rollback_template - rollback_template)
    (is_canary_variant ?release_instance - release_instance)
    (is_full_variant ?release_instance - release_instance)
    (release_bound_runbook ?release_instance - release_instance ?runbook - runbook)
    (verification_pending ?release_instance - release_instance)
    (variant_has_rollback_template_link ?release_instance - release_instance ?rollback_template - rollback_template)
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
  (:action assign_release_to_wave
    :parameters (?release_instance - release_instance ?rollout_wave - rollout_wave)
    :precondition
      (and
        (release_registered ?release_instance)
        (wave_available ?rollout_wave)
        (release_allowed_in_wave ?release_instance ?rollout_wave)
        (not
          (release_assigned ?release_instance)
        )
      )
    :effect
      (and
        (release_assigned_to_wave ?release_instance ?rollout_wave)
        (release_assigned ?release_instance)
        (not
          (wave_available ?rollout_wave)
        )
      )
  )
  (:action unschedule_release_from_wave
    :parameters (?release_instance - release_instance ?rollout_wave - rollout_wave)
    :precondition
      (and
        (release_assigned_to_wave ?release_instance ?rollout_wave)
        (not
          (deployment_completed ?release_instance)
        )
        (not
          (promotion_approved ?release_instance)
        )
      )
    :effect
      (and
        (not
          (release_assigned_to_wave ?release_instance ?rollout_wave)
        )
        (not
          (release_assigned ?release_instance)
        )
        (not
          (release_readiness_validated ?release_instance)
        )
        (not
          (operator_checks_completed ?release_instance)
        )
        (not
          (approval_recorded ?release_instance)
        )
        (not
          (finalization_ready ?release_instance)
        )
        (not
          (verification_pending ?release_instance)
        )
        (wave_available ?rollout_wave)
      )
  )
  (:action bind_runbook_to_release
    :parameters (?release_instance - release_instance ?runbook - runbook)
    :precondition
      (and
        (release_registered ?release_instance)
        (runbook_available ?runbook)
      )
    :effect
      (and
        (release_bound_runbook ?release_instance ?runbook)
        (not
          (runbook_available ?runbook)
        )
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
  (:action validate_runbook_readiness
    :parameters (?release_instance - release_instance ?runbook - runbook)
    :precondition
      (and
        (release_registered ?release_instance)
        (release_assigned ?release_instance)
        (release_bound_runbook ?release_instance ?runbook)
        (not
          (release_readiness_validated ?release_instance)
        )
      )
    :effect
      (and
        (release_readiness_validated ?release_instance)
      )
  )
  (:action apply_approval_for_release
    :parameters (?release_instance - release_instance ?approver - approver)
    :precondition
      (and
        (release_registered ?release_instance)
        (release_assigned ?release_instance)
        (approver_available ?approver)
        (not
          (release_readiness_validated ?release_instance)
        )
      )
    :effect
      (and
        (release_readiness_validated ?release_instance)
        (approval_recorded ?release_instance)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action operator_precheck_with_runbook
    :parameters (?release_instance - release_instance ?runbook - runbook ?operator - operator)
    :precondition
      (and
        (release_readiness_validated ?release_instance)
        (release_assigned ?release_instance)
        (release_bound_runbook ?release_instance ?runbook)
        (operator_available ?operator)
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
        (component_reserved ?release_instance ?component)
        (not
          (component_available ?component)
        )
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
  (:action reserve_infra_component_for_release
    :parameters (?release_instance - release_instance ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (release_registered ?release_instance)
        (infrastructure_component_available ?infrastructure_component)
        (release_infra_component_binding ?release_instance ?infrastructure_component)
      )
    :effect
      (and
        (infrastructure_component_reserved ?release_instance ?infrastructure_component)
        (not
          (infrastructure_component_available ?infrastructure_component)
        )
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
  (:action reserve_configuration_snapshot_for_release
    :parameters (?release_instance - release_instance ?configuration_snapshot - configuration_snapshot)
    :precondition
      (and
        (release_registered ?release_instance)
        (configuration_snapshot_available ?configuration_snapshot)
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
  (:action execute_deployment_to_target
    :parameters (?release_instance - release_instance ?deployment_target - deployment_target ?component - component ?service_dependency - service_dependency)
    :precondition
      (and
        (release_assigned ?release_instance)
        (component_reserved ?release_instance ?component)
        (dependency_reserved ?release_instance ?service_dependency)
        (target_available ?deployment_target)
        (release_target_binding ?release_instance ?deployment_target)
        (not
          (deployment_completed ?release_instance)
        )
      )
    :effect
      (and
        (deployed_to_target ?release_instance ?deployment_target)
        (deployment_completed ?release_instance)
        (not
          (target_available ?deployment_target)
        )
      )
  )
  (:action execute_deployment_with_infra_resources
    :parameters (?release_instance - release_instance ?deployment_target - deployment_target ?infrastructure_component - infrastructure_component ?infrastructure_resource - infrastructure_resource)
    :precondition
      (and
        (release_assigned ?release_instance)
        (infrastructure_component_reserved ?release_instance ?infrastructure_component)
        (infrastructure_resource_available ?infrastructure_resource)
        (target_available ?deployment_target)
        (release_target_binding ?release_instance ?deployment_target)
        (release_infra_resource_binding ?release_instance ?infrastructure_resource)
        (not
          (deployment_completed ?release_instance)
        )
      )
    :effect
      (and
        (deployed_to_target ?release_instance ?deployment_target)
        (deployment_completed ?release_instance)
        (verification_pending ?release_instance)
        (approval_recorded ?release_instance)
        (not
          (target_available ?deployment_target)
        )
        (not
          (infrastructure_resource_available ?infrastructure_resource)
        )
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
  (:action approve_promotion
    :parameters (?release_instance - release_instance ?component - component ?service_dependency - service_dependency ?dev_team - dev_team)
    :precondition
      (and
        (operator_checks_completed ?release_instance)
        (deployment_completed ?release_instance)
        (component_reserved ?release_instance ?component)
        (dependency_reserved ?release_instance ?service_dependency)
        (release_stakeholder_association ?release_instance ?dev_team)
        (not
          (approval_recorded ?release_instance)
        )
        (not
          (promotion_approved ?release_instance)
        )
      )
    :effect
      (and
        (promotion_approved ?release_instance)
      )
  )
  (:action ops_approve_promotion
    :parameters (?release_instance - release_instance ?infrastructure_component - infrastructure_component ?configuration_snapshot - configuration_snapshot ?ops_team - ops_team)
    :precondition
      (and
        (operator_checks_completed ?release_instance)
        (deployment_completed ?release_instance)
        (infrastructure_component_reserved ?release_instance ?infrastructure_component)
        (configuration_snapshot_reserved ?release_instance ?configuration_snapshot)
        (release_stakeholder_association ?release_instance ?ops_team)
        (not
          (promotion_approved ?release_instance)
        )
      )
    :effect
      (and
        (promotion_approved ?release_instance)
        (approval_recorded ?release_instance)
      )
  )
  (:action finalize_promotion_stage
    :parameters (?release_instance - release_instance ?component - component ?service_dependency - service_dependency)
    :precondition
      (and
        (promotion_approved ?release_instance)
        (approval_recorded ?release_instance)
        (component_reserved ?release_instance ?component)
        (dependency_reserved ?release_instance ?service_dependency)
      )
    :effect
      (and
        (finalization_ready ?release_instance)
        (not
          (approval_recorded ?release_instance)
        )
        (not
          (operator_checks_completed ?release_instance)
        )
        (not
          (verification_pending ?release_instance)
        )
      )
  )
  (:action reenable_operator_checks
    :parameters (?release_instance - release_instance ?runbook - runbook ?operator - operator)
    :precondition
      (and
        (finalization_ready ?release_instance)
        (promotion_approved ?release_instance)
        (release_assigned ?release_instance)
        (release_bound_runbook ?release_instance ?runbook)
        (operator_available ?operator)
        (not
          (operator_checks_completed ?release_instance)
        )
      )
    :effect
      (and
        (operator_checks_completed ?release_instance)
      )
  )
  (:action mark_runbook_linked_for_monitoring
    :parameters (?release_instance - release_instance ?runbook - runbook)
    :precondition
      (and
        (promotion_approved ?release_instance)
        (operator_checks_completed ?release_instance)
        (not
          (approval_recorded ?release_instance)
        )
        (release_bound_runbook ?release_instance ?runbook)
        (not
          (monitoring_linked ?release_instance)
        )
      )
    :effect
      (and
        (monitoring_linked ?release_instance)
      )
  )
  (:action mark_approver_linked_for_monitoring
    :parameters (?release_instance - release_instance ?approver - approver)
    :precondition
      (and
        (promotion_approved ?release_instance)
        (operator_checks_completed ?release_instance)
        (not
          (approval_recorded ?release_instance)
        )
        (approver_available ?approver)
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
  (:action authorize_cross_variant_rollback
    :parameters (?full_release_variant - full_release_variant ?canary_release_variant - canary_release_variant ?rollback_template - rollback_template)
    :precondition
      (and
        (release_registered ?full_release_variant)
        (is_full_variant ?full_release_variant)
        (has_rollback_template ?full_release_variant ?rollback_template)
        (rollback_template_committed ?canary_release_variant ?rollback_template)
        (not
          (rollback_template_authorized ?full_release_variant ?rollback_template)
        )
      )
    :effect
      (and
        (rollback_template_authorized ?full_release_variant ?rollback_template)
      )
  )
  (:action start_post_deployment_monitoring
    :parameters (?release_instance - release_instance ?runbook - runbook ?operator - operator)
    :precondition
      (and
        (release_registered ?release_instance)
        (is_full_variant ?release_instance)
        (operator_checks_completed ?release_instance)
        (monitoring_linked ?release_instance)
        (release_bound_runbook ?release_instance ?runbook)
        (operator_available ?operator)
        (not
          (monitoring_started ?release_instance)
        )
      )
    :effect
      (and
        (monitoring_started ?release_instance)
      )
  )
  (:action finalize_canary_release
    :parameters (?release_instance - release_instance)
    :precondition
      (and
        (is_canary_variant ?release_instance)
        (release_registered ?release_instance)
        (release_assigned ?release_instance)
        (deployment_completed ?release_instance)
        (promotion_approved ?release_instance)
        (monitoring_linked ?release_instance)
        (operator_checks_completed ?release_instance)
        (not
          (release_finalized ?release_instance)
        )
      )
    :effect
      (and
        (release_finalized ?release_instance)
      )
  )
  (:action finalize_full_release_with_template
    :parameters (?release_instance - release_instance ?rollback_template - rollback_template)
    :precondition
      (and
        (is_full_variant ?release_instance)
        (release_registered ?release_instance)
        (release_assigned ?release_instance)
        (deployment_completed ?release_instance)
        (promotion_approved ?release_instance)
        (monitoring_linked ?release_instance)
        (operator_checks_completed ?release_instance)
        (rollback_template_authorized ?release_instance ?rollback_template)
        (not
          (release_finalized ?release_instance)
        )
      )
    :effect
      (and
        (release_finalized ?release_instance)
      )
  )
  (:action finalize_release_after_monitoring
    :parameters (?release_instance - release_instance)
    :precondition
      (and
        (is_full_variant ?release_instance)
        (release_registered ?release_instance)
        (release_assigned ?release_instance)
        (deployment_completed ?release_instance)
        (promotion_approved ?release_instance)
        (monitoring_linked ?release_instance)
        (operator_checks_completed ?release_instance)
        (monitoring_started ?release_instance)
        (not
          (release_finalized ?release_instance)
        )
      )
    :effect
      (and
        (release_finalized ?release_instance)
      )
  )
)

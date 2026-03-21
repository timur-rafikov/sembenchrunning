(define (domain sev1_incident_command_orchestration)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object incident_case - entity oncall_responder - entity change_plan - entity approver - entity infrastructure_component - entity external_dependency - entity reservation_token - entity approval_token - entity execution_window - entity runbook - entity rollback_plan - entity change_item - entity stakeholder_group - entity response_team - stakeholder_group escalation_channel - stakeholder_group incident_variant_case - incident_case incident_variant_context - incident_case)

  (:predicates
    (incident_declared ?incident_case - incident_case)
    (assigned_responder ?incident_case - incident_case ?oncall_responder - oncall_responder)
    (case_has_assignment ?incident_case - incident_case)
    (resources_locked ?incident_case - incident_case)
    (runbook_verified ?incident_case - incident_case)
    (targets_component ?incident_case - incident_case ?infrastructure_component - infrastructure_component)
    (approver_engaged ?incident_case - incident_case ?approver - approver)
    (external_dependency_engaged ?incident_case - incident_case ?external_dependency - external_dependency)
    (change_item_linked ?incident_case - incident_case ?change_item - change_item)
    (scheduled_change ?incident_case - incident_case ?change_plan - change_plan)
    (execution_ready ?incident_case - incident_case)
    (final_approvals_obtained ?incident_case - incident_case)
    (reservation_confirmed ?incident_case - incident_case)
    (incident_closed ?incident_case - incident_case)
    (provisional_approval ?incident_case - incident_case)
    (change_executed ?incident_case - incident_case)
    (variant_window_assigned ?incident_case - incident_case ?execution_window - execution_window)
    (window_allocated_for_case ?incident_case - incident_case ?execution_window - execution_window)
    (pre_execution_verified ?incident_case - incident_case)
    (responder_available ?oncall_responder - oncall_responder)
    (change_plan_valid ?change_plan - change_plan)
    (component_available ?infrastructure_component - infrastructure_component)
    (approver_available ?approver - approver)
    (external_dependency_available ?external_dependency - external_dependency)
    (reservation_available ?reservation_token - reservation_token)
    (approval_token_available ?approval_token - approval_token)
    (window_available ?execution_window - execution_window)
    (runbook_available ?runbook - runbook)
    (rollback_available ?rollback_plan - rollback_plan)
    (change_item_available ?change_item - change_item)
    (responder_assignment_possible ?incident_case - incident_case ?oncall_responder - oncall_responder)
    (change_plan_affinity ?incident_case - incident_case ?change_plan - change_plan)
    (component_affinity ?incident_case - incident_case ?infrastructure_component - infrastructure_component)
    (approver_affinity ?incident_case - incident_case ?approver - approver)
    (external_dependency_affinity ?incident_case - incident_case ?external_dependency - external_dependency)
    (rollback_affinity ?incident_case - incident_case ?rollback_plan - rollback_plan)
    (change_item_affinity ?incident_case - incident_case ?change_item - change_item)
    (stakeholder_group_affinity ?incident_case - incident_case ?stakeholder_group - stakeholder_group)
    (case_window_reserved ?incident_case - incident_case ?execution_window - execution_window)
    (initial_triage_needed ?incident_case - incident_case)
    (variant_context_active ?incident_case - incident_case)
    (reservation_linked ?incident_case - incident_case ?reservation_token - reservation_token)
    (provisional_checks_flag ?incident_case - incident_case)
    (change_item_window_affinity ?incident_case - incident_case ?execution_window - execution_window)
  )
  (:action declare_incident
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (not
          (incident_declared ?incident_case)
        )
        (not
          (incident_closed ?incident_case)
        )
      )
    :effect
      (and
        (incident_declared ?incident_case)
      )
  )
  (:action assign_responder_to_incident
    :parameters (?incident_case - incident_case ?oncall_responder - oncall_responder)
    :precondition
      (and
        (incident_declared ?incident_case)
        (responder_available ?oncall_responder)
        (responder_assignment_possible ?incident_case ?oncall_responder)
        (not
          (case_has_assignment ?incident_case)
        )
      )
    :effect
      (and
        (assigned_responder ?incident_case ?oncall_responder)
        (case_has_assignment ?incident_case)
        (not
          (responder_available ?oncall_responder)
        )
      )
  )
  (:action revoke_responder_assignment
    :parameters (?incident_case - incident_case ?oncall_responder - oncall_responder)
    :precondition
      (and
        (assigned_responder ?incident_case ?oncall_responder)
        (not
          (execution_ready ?incident_case)
        )
        (not
          (final_approvals_obtained ?incident_case)
        )
      )
    :effect
      (and
        (not
          (assigned_responder ?incident_case ?oncall_responder)
        )
        (not
          (case_has_assignment ?incident_case)
        )
        (not
          (resources_locked ?incident_case)
        )
        (not
          (runbook_verified ?incident_case)
        )
        (not
          (provisional_approval ?incident_case)
        )
        (not
          (change_executed ?incident_case)
        )
        (not
          (provisional_checks_flag ?incident_case)
        )
        (responder_available ?oncall_responder)
      )
  )
  (:action reserve_resource_token
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token)
    :precondition
      (and
        (incident_declared ?incident_case)
        (reservation_available ?reservation_token)
      )
    :effect
      (and
        (reservation_linked ?incident_case ?reservation_token)
        (not
          (reservation_available ?reservation_token)
        )
      )
  )
  (:action release_resource_token
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token)
    :precondition
      (and
        (reservation_linked ?incident_case ?reservation_token)
      )
    :effect
      (and
        (reservation_available ?reservation_token)
        (not
          (reservation_linked ?incident_case ?reservation_token)
        )
      )
  )
  (:action confirm_reservation_lock
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token)
    :precondition
      (and
        (incident_declared ?incident_case)
        (case_has_assignment ?incident_case)
        (reservation_linked ?incident_case ?reservation_token)
        (not
          (resources_locked ?incident_case)
        )
      )
    :effect
      (and
        (resources_locked ?incident_case)
      )
  )
  (:action apply_preliminary_approval
    :parameters (?incident_case - incident_case ?approval_token - approval_token)
    :precondition
      (and
        (incident_declared ?incident_case)
        (case_has_assignment ?incident_case)
        (approval_token_available ?approval_token)
        (not
          (resources_locked ?incident_case)
        )
      )
    :effect
      (and
        (resources_locked ?incident_case)
        (provisional_approval ?incident_case)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action validate_runbook_with_reservation
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token ?runbook - runbook)
    :precondition
      (and
        (resources_locked ?incident_case)
        (case_has_assignment ?incident_case)
        (reservation_linked ?incident_case ?reservation_token)
        (runbook_available ?runbook)
        (not
          (runbook_verified ?incident_case)
        )
      )
    :effect
      (and
        (runbook_verified ?incident_case)
        (not
          (provisional_approval ?incident_case)
        )
      )
  )
  (:action validate_runbook_with_window
    :parameters (?incident_case - incident_case ?execution_window - execution_window)
    :precondition
      (and
        (case_has_assignment ?incident_case)
        (window_allocated_for_case ?incident_case ?execution_window)
        (not
          (runbook_verified ?incident_case)
        )
      )
    :effect
      (and
        (runbook_verified ?incident_case)
        (not
          (provisional_approval ?incident_case)
        )
      )
  )
  (:action request_component_approval
    :parameters (?incident_case - incident_case ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (incident_declared ?incident_case)
        (component_available ?infrastructure_component)
        (component_affinity ?incident_case ?infrastructure_component)
      )
    :effect
      (and
        (targets_component ?incident_case ?infrastructure_component)
        (not
          (component_available ?infrastructure_component)
        )
      )
  )
  (:action revoke_component_approval
    :parameters (?incident_case - incident_case ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (targets_component ?incident_case ?infrastructure_component)
      )
    :effect
      (and
        (component_available ?infrastructure_component)
        (not
          (targets_component ?incident_case ?infrastructure_component)
        )
      )
  )
  (:action request_approver_engagement
    :parameters (?incident_case - incident_case ?approver - approver)
    :precondition
      (and
        (incident_declared ?incident_case)
        (approver_available ?approver)
        (approver_affinity ?incident_case ?approver)
      )
    :effect
      (and
        (approver_engaged ?incident_case ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action revoke_approver_engagement
    :parameters (?incident_case - incident_case ?approver - approver)
    :precondition
      (and
        (approver_engaged ?incident_case ?approver)
      )
    :effect
      (and
        (approver_available ?approver)
        (not
          (approver_engaged ?incident_case ?approver)
        )
      )
  )
  (:action request_external_dependency_engagement
    :parameters (?incident_case - incident_case ?external_dependency - external_dependency)
    :precondition
      (and
        (incident_declared ?incident_case)
        (external_dependency_available ?external_dependency)
        (external_dependency_affinity ?incident_case ?external_dependency)
      )
    :effect
      (and
        (external_dependency_engaged ?incident_case ?external_dependency)
        (not
          (external_dependency_available ?external_dependency)
        )
      )
  )
  (:action revoke_external_dependency_engagement
    :parameters (?incident_case - incident_case ?external_dependency - external_dependency)
    :precondition
      (and
        (external_dependency_engaged ?incident_case ?external_dependency)
      )
    :effect
      (and
        (external_dependency_available ?external_dependency)
        (not
          (external_dependency_engaged ?incident_case ?external_dependency)
        )
      )
  )
  (:action request_change_item_link
    :parameters (?incident_case - incident_case ?change_item - change_item)
    :precondition
      (and
        (incident_declared ?incident_case)
        (change_item_available ?change_item)
        (change_item_affinity ?incident_case ?change_item)
      )
    :effect
      (and
        (change_item_linked ?incident_case ?change_item)
        (not
          (change_item_available ?change_item)
        )
      )
  )
  (:action revoke_change_item_link
    :parameters (?incident_case - incident_case ?change_item - change_item)
    :precondition
      (and
        (change_item_linked ?incident_case ?change_item)
      )
    :effect
      (and
        (change_item_available ?change_item)
        (not
          (change_item_linked ?incident_case ?change_item)
        )
      )
  )
  (:action schedule_change_plan
    :parameters (?incident_case - incident_case ?change_plan - change_plan ?infrastructure_component - infrastructure_component ?approver - approver)
    :precondition
      (and
        (case_has_assignment ?incident_case)
        (targets_component ?incident_case ?infrastructure_component)
        (approver_engaged ?incident_case ?approver)
        (change_plan_valid ?change_plan)
        (change_plan_affinity ?incident_case ?change_plan)
        (not
          (execution_ready ?incident_case)
        )
      )
    :effect
      (and
        (scheduled_change ?incident_case ?change_plan)
        (execution_ready ?incident_case)
        (not
          (change_plan_valid ?change_plan)
        )
      )
  )
  (:action schedule_change_with_dependency_and_rollback
    :parameters (?incident_case - incident_case ?change_plan - change_plan ?external_dependency - external_dependency ?rollback_plan - rollback_plan)
    :precondition
      (and
        (case_has_assignment ?incident_case)
        (external_dependency_engaged ?incident_case ?external_dependency)
        (rollback_available ?rollback_plan)
        (change_plan_valid ?change_plan)
        (change_plan_affinity ?incident_case ?change_plan)
        (rollback_affinity ?incident_case ?rollback_plan)
        (not
          (execution_ready ?incident_case)
        )
      )
    :effect
      (and
        (scheduled_change ?incident_case ?change_plan)
        (execution_ready ?incident_case)
        (provisional_checks_flag ?incident_case)
        (provisional_approval ?incident_case)
        (not
          (change_plan_valid ?change_plan)
        )
        (not
          (rollback_available ?rollback_plan)
        )
      )
  )
  (:action prepare_remediation_plan_validation
    :parameters (?incident_case - incident_case ?infrastructure_component - infrastructure_component ?approver - approver)
    :precondition
      (and
        (execution_ready ?incident_case)
        (provisional_checks_flag ?incident_case)
        (targets_component ?incident_case ?infrastructure_component)
        (approver_engaged ?incident_case ?approver)
      )
    :effect
      (and
        (not
          (provisional_checks_flag ?incident_case)
        )
        (not
          (provisional_approval ?incident_case)
        )
      )
  )
  (:action collect_final_approvals
    :parameters (?incident_case - incident_case ?infrastructure_component - infrastructure_component ?approver - approver ?response_team - response_team)
    :precondition
      (and
        (runbook_verified ?incident_case)
        (execution_ready ?incident_case)
        (targets_component ?incident_case ?infrastructure_component)
        (approver_engaged ?incident_case ?approver)
        (stakeholder_group_affinity ?incident_case ?response_team)
        (not
          (provisional_approval ?incident_case)
        )
        (not
          (final_approvals_obtained ?incident_case)
        )
      )
    :effect
      (and
        (final_approvals_obtained ?incident_case)
      )
  )
  (:action collect_cross_team_approvals
    :parameters (?incident_case - incident_case ?external_dependency - external_dependency ?change_item - change_item ?escalation_channel - escalation_channel)
    :precondition
      (and
        (runbook_verified ?incident_case)
        (execution_ready ?incident_case)
        (external_dependency_engaged ?incident_case ?external_dependency)
        (change_item_linked ?incident_case ?change_item)
        (stakeholder_group_affinity ?incident_case ?escalation_channel)
        (not
          (final_approvals_obtained ?incident_case)
        )
      )
    :effect
      (and
        (final_approvals_obtained ?incident_case)
        (provisional_approval ?incident_case)
      )
  )
  (:action authorize_execution
    :parameters (?incident_case - incident_case ?infrastructure_component - infrastructure_component ?approver - approver)
    :precondition
      (and
        (final_approvals_obtained ?incident_case)
        (provisional_approval ?incident_case)
        (targets_component ?incident_case ?infrastructure_component)
        (approver_engaged ?incident_case ?approver)
      )
    :effect
      (and
        (change_executed ?incident_case)
        (not
          (provisional_approval ?incident_case)
        )
        (not
          (runbook_verified ?incident_case)
        )
        (not
          (provisional_checks_flag ?incident_case)
        )
      )
  )
  (:action perform_post_authorization_runbook_validation
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token ?runbook - runbook)
    :precondition
      (and
        (change_executed ?incident_case)
        (final_approvals_obtained ?incident_case)
        (case_has_assignment ?incident_case)
        (reservation_linked ?incident_case ?reservation_token)
        (runbook_available ?runbook)
        (not
          (runbook_verified ?incident_case)
        )
      )
    :effect
      (and
        (runbook_verified ?incident_case)
      )
  )
  (:action mark_runbook_checkpoint
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token)
    :precondition
      (and
        (final_approvals_obtained ?incident_case)
        (runbook_verified ?incident_case)
        (not
          (provisional_approval ?incident_case)
        )
        (reservation_linked ?incident_case ?reservation_token)
        (not
          (reservation_confirmed ?incident_case)
        )
      )
    :effect
      (and
        (reservation_confirmed ?incident_case)
      )
  )
  (:action consume_approval_token_for_checkpoint
    :parameters (?incident_case - incident_case ?approval_token - approval_token)
    :precondition
      (and
        (final_approvals_obtained ?incident_case)
        (runbook_verified ?incident_case)
        (not
          (provisional_approval ?incident_case)
        )
        (approval_token_available ?approval_token)
        (not
          (reservation_confirmed ?incident_case)
        )
      )
    :effect
      (and
        (reservation_confirmed ?incident_case)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action reserve_execution_window_for_change_item
    :parameters (?incident_case - incident_case ?execution_window - execution_window)
    :precondition
      (and
        (reservation_confirmed ?incident_case)
        (window_available ?execution_window)
        (change_item_window_affinity ?incident_case ?execution_window)
      )
    :effect
      (and
        (case_window_reserved ?incident_case ?execution_window)
        (not
          (window_available ?execution_window)
        )
      )
  )
  (:action confirm_window_for_variant
    :parameters (?incident_variant_context - incident_variant_context ?incident_variant_commander - incident_variant_case ?execution_window - execution_window)
    :precondition
      (and
        (incident_declared ?incident_variant_context)
        (variant_context_active ?incident_variant_context)
        (variant_window_assigned ?incident_variant_context ?execution_window)
        (case_window_reserved ?incident_variant_commander ?execution_window)
        (not
          (window_allocated_for_case ?incident_variant_context ?execution_window)
        )
      )
    :effect
      (and
        (window_allocated_for_case ?incident_variant_context ?execution_window)
      )
  )
  (:action initiate_external_coordination
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token ?runbook - runbook)
    :precondition
      (and
        (incident_declared ?incident_case)
        (variant_context_active ?incident_case)
        (runbook_verified ?incident_case)
        (reservation_confirmed ?incident_case)
        (reservation_linked ?incident_case ?reservation_token)
        (runbook_available ?runbook)
        (not
          (pre_execution_verified ?incident_case)
        )
      )
    :effect
      (and
        (pre_execution_verified ?incident_case)
      )
  )
  (:action close_incident_after_validation
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (initial_triage_needed ?incident_case)
        (incident_declared ?incident_case)
        (case_has_assignment ?incident_case)
        (execution_ready ?incident_case)
        (final_approvals_obtained ?incident_case)
        (reservation_confirmed ?incident_case)
        (runbook_verified ?incident_case)
        (not
          (incident_closed ?incident_case)
        )
      )
    :effect
      (and
        (incident_closed ?incident_case)
      )
  )
  (:action close_incident_with_window_validation
    :parameters (?incident_case - incident_case ?execution_window - execution_window)
    :precondition
      (and
        (variant_context_active ?incident_case)
        (incident_declared ?incident_case)
        (case_has_assignment ?incident_case)
        (execution_ready ?incident_case)
        (final_approvals_obtained ?incident_case)
        (reservation_confirmed ?incident_case)
        (runbook_verified ?incident_case)
        (window_allocated_for_case ?incident_case ?execution_window)
        (not
          (incident_closed ?incident_case)
        )
      )
    :effect
      (and
        (incident_closed ?incident_case)
      )
  )
  (:action close_incident_with_variant_validation
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (variant_context_active ?incident_case)
        (incident_declared ?incident_case)
        (case_has_assignment ?incident_case)
        (execution_ready ?incident_case)
        (final_approvals_obtained ?incident_case)
        (reservation_confirmed ?incident_case)
        (runbook_verified ?incident_case)
        (pre_execution_verified ?incident_case)
        (not
          (incident_closed ?incident_case)
        )
      )
    :effect
      (and
        (incident_closed ?incident_case)
      )
  )
)

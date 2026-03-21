(define (domain sev1_incident_command_orchestration)
  (:requirements :strips :typing :negative-preconditions)
  (:types incident_case - entity oncall_responder - entity change_plan - entity approver - entity infrastructure_component - entity external_dependency - entity reservation_token - entity approval_token - entity execution_window - entity runbook - entity rollback_plan - entity change_item - entity stakeholder_group - entity response_team - stakeholder_group escalation_channel - stakeholder_group incident_variant_case - incident_case incident_variant_context - incident_case)
  (:predicates
    (approval_token_available ?approval_token - approval_token)
    (approver_engaged ?incident_case - incident_case ?approver - approver)
    (change_executed ?incident_case - incident_case)
    (assigned_responder ?incident_case - incident_case ?oncall_responder - oncall_responder)
    (stakeholder_group_affinity ?incident_case - incident_case ?stakeholder_group - stakeholder_group)
    (external_dependency_available ?external_dependency - external_dependency)
    (approver_available ?approver - approver)
    (change_item_affinity ?incident_case - incident_case ?change_item - change_item)
    (incident_closed ?incident_case - incident_case)
    (initial_triage_needed ?incident_case - incident_case)
    (responder_assignment_possible ?incident_case - incident_case ?oncall_responder - oncall_responder)
    (change_plan_valid ?change_plan - change_plan)
    (rollback_available ?rollback_plan - rollback_plan)
    (reservation_available ?reservation_token - reservation_token)
    (execution_ready ?incident_case - incident_case)
    (approver_affinity ?incident_case - incident_case ?approver - approver)
    (change_item_linked ?incident_case - incident_case ?change_item - change_item)
    (scheduled_change ?incident_case - incident_case ?change_plan - change_plan)
    (final_approvals_obtained ?incident_case - incident_case)
    (external_dependency_affinity ?incident_case - incident_case ?external_dependency - external_dependency)
    (change_item_available ?change_item - change_item)
    (variant_context_active ?incident_case - incident_case)
    (runbook_verified ?incident_case - incident_case)
    (component_affinity ?incident_case - incident_case ?infrastructure_component - infrastructure_component)
    (targets_component ?incident_case - incident_case ?infrastructure_component - infrastructure_component)
    (provisional_checks_flag ?incident_case - incident_case)
    (reservation_linked ?incident_case - incident_case ?reservation_token - reservation_token)
    (pre_execution_verified ?incident_case - incident_case)
    (rollback_affinity ?incident_case - incident_case ?rollback_plan - rollback_plan)
    (incident_declared ?incident_case - incident_case)
    (responder_available ?oncall_responder - oncall_responder)
    (case_has_assignment ?incident_case - incident_case)
    (runbook_available ?runbook - runbook)
    (window_available ?execution_window - execution_window)
    (external_dependency_engaged ?incident_case - incident_case ?external_dependency - external_dependency)
    (case_window_reserved ?incident_case - incident_case ?execution_window - execution_window)
    (resources_locked ?incident_case - incident_case)
    (reservation_confirmed ?incident_case - incident_case)
    (change_item_window_affinity ?incident_case - incident_case ?execution_window - execution_window)
    (component_available ?infrastructure_component - infrastructure_component)
    (variant_window_assigned ?incident_case - incident_case ?execution_window - execution_window)
    (change_plan_affinity ?incident_case - incident_case ?change_plan - change_plan)
    (provisional_approval ?incident_case - incident_case)
    (window_allocated_for_case ?incident_case - incident_case ?execution_window - execution_window)
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
  (:action collect_cross_team_approvals
    :parameters (?incident_case - incident_case ?external_dependency - external_dependency ?change_item - change_item ?escalation_channel - escalation_channel)
    :precondition
      (and
        (not
          (final_approvals_obtained ?incident_case)
        )
        (execution_ready ?incident_case)
        (runbook_verified ?incident_case)
        (change_item_linked ?incident_case ?change_item)
        (stakeholder_group_affinity ?incident_case ?escalation_channel)
        (external_dependency_engaged ?incident_case ?external_dependency)
      )
    :effect
      (and
        (provisional_approval ?incident_case)
        (final_approvals_obtained ?incident_case)
      )
  )
  (:action close_incident_after_validation
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (runbook_verified ?incident_case)
        (case_has_assignment ?incident_case)
        (execution_ready ?incident_case)
        (incident_declared ?incident_case)
        (reservation_confirmed ?incident_case)
        (not
          (incident_closed ?incident_case)
        )
        (initial_triage_needed ?incident_case)
        (final_approvals_obtained ?incident_case)
      )
    :effect
      (and
        (incident_closed ?incident_case)
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
  (:action reserve_resource_token
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token)
    :precondition
      (and
        (reservation_available ?reservation_token)
        (incident_declared ?incident_case)
      )
    :effect
      (and
        (not
          (reservation_available ?reservation_token)
        )
        (reservation_linked ?incident_case ?reservation_token)
      )
  )
  (:action collect_final_approvals
    :parameters (?incident_case - incident_case ?infrastructure_component - infrastructure_component ?approver - approver ?response_team - response_team)
    :precondition
      (and
        (stakeholder_group_affinity ?incident_case ?response_team)
        (runbook_verified ?incident_case)
        (not
          (provisional_approval ?incident_case)
        )
        (targets_component ?incident_case ?infrastructure_component)
        (execution_ready ?incident_case)
        (approver_engaged ?incident_case ?approver)
        (not
          (final_approvals_obtained ?incident_case)
        )
      )
    :effect
      (and
        (final_approvals_obtained ?incident_case)
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
  (:action request_external_dependency_engagement
    :parameters (?incident_case - incident_case ?external_dependency - external_dependency)
    :precondition
      (and
        (external_dependency_affinity ?incident_case ?external_dependency)
        (incident_declared ?incident_case)
        (external_dependency_available ?external_dependency)
      )
    :effect
      (and
        (external_dependency_engaged ?incident_case ?external_dependency)
        (not
          (external_dependency_available ?external_dependency)
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
        (not
          (component_available ?infrastructure_component)
        )
        (targets_component ?incident_case ?infrastructure_component)
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
  (:action schedule_change_plan
    :parameters (?incident_case - incident_case ?change_plan - change_plan ?infrastructure_component - infrastructure_component ?approver - approver)
    :precondition
      (and
        (case_has_assignment ?incident_case)
        (change_plan_valid ?change_plan)
        (change_plan_affinity ?incident_case ?change_plan)
        (not
          (execution_ready ?incident_case)
        )
        (approver_engaged ?incident_case ?approver)
        (targets_component ?incident_case ?infrastructure_component)
      )
    :effect
      (and
        (scheduled_change ?incident_case ?change_plan)
        (not
          (change_plan_valid ?change_plan)
        )
        (execution_ready ?incident_case)
      )
  )
  (:action authorize_execution
    :parameters (?incident_case - incident_case ?infrastructure_component - infrastructure_component ?approver - approver)
    :precondition
      (and
        (targets_component ?incident_case ?infrastructure_component)
        (final_approvals_obtained ?incident_case)
        (approver_engaged ?incident_case ?approver)
        (provisional_approval ?incident_case)
      )
    :effect
      (and
        (not
          (provisional_checks_flag ?incident_case)
        )
        (not
          (provisional_approval ?incident_case)
        )
        (not
          (runbook_verified ?incident_case)
        )
        (change_executed ?incident_case)
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
  (:action validate_runbook_with_reservation
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token ?runbook - runbook)
    :precondition
      (and
        (not
          (runbook_verified ?incident_case)
        )
        (case_has_assignment ?incident_case)
        (runbook_available ?runbook)
        (reservation_linked ?incident_case ?reservation_token)
        (resources_locked ?incident_case)
      )
    :effect
      (and
        (not
          (provisional_approval ?incident_case)
        )
        (runbook_verified ?incident_case)
      )
  )
  (:action close_incident_with_variant_validation
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (incident_declared ?incident_case)
        (variant_context_active ?incident_case)
        (pre_execution_verified ?incident_case)
        (case_has_assignment ?incident_case)
        (runbook_verified ?incident_case)
        (not
          (incident_closed ?incident_case)
        )
        (reservation_confirmed ?incident_case)
        (execution_ready ?incident_case)
        (final_approvals_obtained ?incident_case)
      )
    :effect
      (and
        (incident_closed ?incident_case)
      )
  )
  (:action initiate_external_coordination
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token ?runbook - runbook)
    :precondition
      (and
        (runbook_verified ?incident_case)
        (runbook_available ?runbook)
        (not
          (pre_execution_verified ?incident_case)
        )
        (reservation_confirmed ?incident_case)
        (incident_declared ?incident_case)
        (variant_context_active ?incident_case)
        (reservation_linked ?incident_case ?reservation_token)
      )
    :effect
      (and
        (pre_execution_verified ?incident_case)
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
  (:action request_change_item_link
    :parameters (?incident_case - incident_case ?change_item - change_item)
    :precondition
      (and
        (change_item_available ?change_item)
        (incident_declared ?incident_case)
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
  (:action apply_preliminary_approval
    :parameters (?incident_case - incident_case ?approval_token - approval_token)
    :precondition
      (and
        (not
          (resources_locked ?incident_case)
        )
        (incident_declared ?incident_case)
        (approval_token_available ?approval_token)
        (case_has_assignment ?incident_case)
      )
    :effect
      (and
        (provisional_approval ?incident_case)
        (not
          (approval_token_available ?approval_token)
        )
        (resources_locked ?incident_case)
      )
  )
  (:action schedule_change_with_dependency_and_rollback
    :parameters (?incident_case - incident_case ?change_plan - change_plan ?external_dependency - external_dependency ?rollback_plan - rollback_plan)
    :precondition
      (and
        (rollback_available ?rollback_plan)
        (rollback_affinity ?incident_case ?rollback_plan)
        (not
          (execution_ready ?incident_case)
        )
        (case_has_assignment ?incident_case)
        (change_plan_valid ?change_plan)
        (change_plan_affinity ?incident_case ?change_plan)
        (external_dependency_engaged ?incident_case ?external_dependency)
      )
    :effect
      (and
        (scheduled_change ?incident_case ?change_plan)
        (not
          (rollback_available ?rollback_plan)
        )
        (provisional_checks_flag ?incident_case)
        (not
          (change_plan_valid ?change_plan)
        )
        (provisional_approval ?incident_case)
        (execution_ready ?incident_case)
      )
  )
  (:action consume_approval_token_for_checkpoint
    :parameters (?incident_case - incident_case ?approval_token - approval_token)
    :precondition
      (and
        (approval_token_available ?approval_token)
        (not
          (provisional_approval ?incident_case)
        )
        (runbook_verified ?incident_case)
        (final_approvals_obtained ?incident_case)
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
  (:action revoke_responder_assignment
    :parameters (?incident_case - incident_case ?oncall_responder - oncall_responder)
    :precondition
      (and
        (assigned_responder ?incident_case ?oncall_responder)
        (not
          (final_approvals_obtained ?incident_case)
        )
        (not
          (execution_ready ?incident_case)
        )
      )
    :effect
      (and
        (not
          (assigned_responder ?incident_case ?oncall_responder)
        )
        (responder_available ?oncall_responder)
        (not
          (case_has_assignment ?incident_case)
        )
        (not
          (resources_locked ?incident_case)
        )
        (not
          (change_executed ?incident_case)
        )
        (not
          (runbook_verified ?incident_case)
        )
        (not
          (provisional_checks_flag ?incident_case)
        )
        (not
          (provisional_approval ?incident_case)
        )
      )
  )
  (:action mark_runbook_checkpoint
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token)
    :precondition
      (and
        (not
          (reservation_confirmed ?incident_case)
        )
        (reservation_linked ?incident_case ?reservation_token)
        (runbook_verified ?incident_case)
        (final_approvals_obtained ?incident_case)
        (not
          (provisional_approval ?incident_case)
        )
      )
    :effect
      (and
        (reservation_confirmed ?incident_case)
      )
  )
  (:action close_incident_with_window_validation
    :parameters (?incident_case - incident_case ?execution_window - execution_window)
    :precondition
      (and
        (reservation_confirmed ?incident_case)
        (final_approvals_obtained ?incident_case)
        (execution_ready ?incident_case)
        (window_allocated_for_case ?incident_case ?execution_window)
        (runbook_verified ?incident_case)
        (case_has_assignment ?incident_case)
        (incident_declared ?incident_case)
        (not
          (incident_closed ?incident_case)
        )
        (variant_context_active ?incident_case)
      )
    :effect
      (and
        (incident_closed ?incident_case)
      )
  )
  (:action confirm_reservation_lock
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token)
    :precondition
      (and
        (incident_declared ?incident_case)
        (case_has_assignment ?incident_case)
        (not
          (resources_locked ?incident_case)
        )
        (reservation_linked ?incident_case ?reservation_token)
      )
    :effect
      (and
        (resources_locked ?incident_case)
      )
  )
  (:action assign_responder_to_incident
    :parameters (?incident_case - incident_case ?oncall_responder - oncall_responder)
    :precondition
      (and
        (not
          (case_has_assignment ?incident_case)
        )
        (incident_declared ?incident_case)
        (responder_available ?oncall_responder)
        (responder_assignment_possible ?incident_case ?oncall_responder)
      )
    :effect
      (and
        (case_has_assignment ?incident_case)
        (not
          (responder_available ?oncall_responder)
        )
        (assigned_responder ?incident_case ?oncall_responder)
      )
  )
  (:action perform_post_authorization_runbook_validation
    :parameters (?incident_case - incident_case ?reservation_token - reservation_token ?runbook - runbook)
    :precondition
      (and
        (case_has_assignment ?incident_case)
        (not
          (runbook_verified ?incident_case)
        )
        (reservation_linked ?incident_case ?reservation_token)
        (final_approvals_obtained ?incident_case)
        (runbook_available ?runbook)
        (change_executed ?incident_case)
      )
    :effect
      (and
        (runbook_verified ?incident_case)
      )
  )
  (:action confirm_window_for_variant
    :parameters (?incident_variant_context - incident_variant_context ?incident_variant_commander - incident_variant_case ?execution_window - execution_window)
    :precondition
      (and
        (incident_declared ?incident_variant_context)
        (case_window_reserved ?incident_variant_commander ?execution_window)
        (variant_context_active ?incident_variant_context)
        (not
          (window_allocated_for_case ?incident_variant_context ?execution_window)
        )
        (variant_window_assigned ?incident_variant_context ?execution_window)
      )
    :effect
      (and
        (window_allocated_for_case ?incident_variant_context ?execution_window)
      )
  )
)

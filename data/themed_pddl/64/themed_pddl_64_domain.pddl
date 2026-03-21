(define (domain mitigation_vs_fix_decision_flow_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types change_incident_case - object oncall_engineer - object deployment_window - object system_component - object workaround_mitigation - object operational_action - object runbook - object approver_person - object fix_artifact - object executor_operator - object test_environment - object rollback_artifact - object stakeholder_group - object approval_channel - stakeholder_group escalation_channel - stakeholder_group case_alias_primary - change_incident_case case_alias_secondary - change_incident_case)
  (:predicates
    (approver_available ?approver_person - approver_person)
    (component_reserved ?change_incident_case - change_incident_case ?system_component - system_component)
    (execution_order_finalized ?change_incident_case - change_incident_case)
    (assigned_responder ?change_incident_case - change_incident_case ?oncall_engineer - oncall_engineer)
    (case_has_stakeholder_channel ?change_incident_case - change_incident_case ?stakeholder_group - stakeholder_group)
    (operational_action_available ?operational_action - operational_action)
    (component_available ?system_component - system_component)
    (rollback_applicable_to_case ?change_incident_case - change_incident_case ?rollback_artifact - rollback_artifact)
    (case_closed ?change_incident_case - change_incident_case)
    (requires_dual_authorization ?change_incident_case - change_incident_case)
    (engineer_eligible_for_case ?change_incident_case - change_incident_case ?oncall_engineer - oncall_engineer)
    (window_available ?deployment_window - deployment_window)
    (test_env_available ?test_environment - test_environment)
    (runbook_available ?runbook - runbook)
    (fix_ready ?change_incident_case - change_incident_case)
    (component_applicable_to_case ?change_incident_case - change_incident_case ?system_component - system_component)
    (rollback_reserved ?change_incident_case - change_incident_case ?rollback_artifact - rollback_artifact)
    (fix_scheduled ?change_incident_case - change_incident_case ?deployment_window - deployment_window)
    (approval_granted ?change_incident_case - change_incident_case)
    (operational_action_applicable_to_case ?change_incident_case - change_incident_case ?operational_action - operational_action)
    (rollback_available ?rollback_artifact - rollback_artifact)
    (requires_cross_case_authorization ?change_incident_case - change_incident_case)
    (remediation_applied ?change_incident_case - change_incident_case)
    (mitigation_applicable_to_case ?change_incident_case - change_incident_case ?workaround_mitigation - workaround_mitigation)
    (mitigation_selected ?change_incident_case - change_incident_case ?workaround_mitigation - workaround_mitigation)
    (requires_additional_review ?change_incident_case - change_incident_case)
    (runbook_bound_to_case ?change_incident_case - change_incident_case ?runbook - runbook)
    (validation_completed ?change_incident_case - change_incident_case)
    (testenv_applicable_to_case ?change_incident_case - change_incident_case ?test_environment - test_environment)
    (case_active ?change_incident_case - change_incident_case)
    (engineer_available ?oncall_engineer - oncall_engineer)
    (responder_allocated ?change_incident_case - change_incident_case)
    (executor_available ?executor_operator - executor_operator)
    (fix_available ?fix_artifact - fix_artifact)
    (operational_action_reserved ?change_incident_case - change_incident_case ?operational_action - operational_action)
    (fix_bound_to_case ?change_incident_case - change_incident_case ?fix_artifact - fix_artifact)
    (mitigation_authorized ?change_incident_case - change_incident_case)
    (fix_authorized ?change_incident_case - change_incident_case)
    (case_alias_secondary_for_fix ?change_incident_case - change_incident_case ?fix_artifact - fix_artifact)
    (mitigation_available ?workaround_mitigation - workaround_mitigation)
    (case_alias_primary_for_fix ?change_incident_case - change_incident_case ?fix_artifact - fix_artifact)
    (window_eligible_for_case ?change_incident_case - change_incident_case ?deployment_window - deployment_window)
    (escalation_required ?change_incident_case - change_incident_case)
    (fix_cross_case_authorized ?change_incident_case - change_incident_case ?fix_artifact - fix_artifact)
  )
  (:action release_rollback_artifact
    :parameters (?change_incident_case - change_incident_case ?rollback_artifact - rollback_artifact)
    :precondition
      (and
        (rollback_reserved ?change_incident_case ?rollback_artifact)
      )
    :effect
      (and
        (rollback_available ?rollback_artifact)
        (not
          (rollback_reserved ?change_incident_case ?rollback_artifact)
        )
      )
  )
  (:action grant_escalated_approval
    :parameters (?change_incident_case - change_incident_case ?operational_action - operational_action ?rollback_artifact - rollback_artifact ?escalation_channel - escalation_channel)
    :precondition
      (and
        (not
          (approval_granted ?change_incident_case)
        )
        (fix_ready ?change_incident_case)
        (remediation_applied ?change_incident_case)
        (rollback_reserved ?change_incident_case ?rollback_artifact)
        (case_has_stakeholder_channel ?change_incident_case ?escalation_channel)
        (operational_action_reserved ?change_incident_case ?operational_action)
      )
    :effect
      (and
        (escalation_required ?change_incident_case)
        (approval_granted ?change_incident_case)
      )
  )
  (:action close_case_with_dual_auth
    :parameters (?change_incident_case - change_incident_case)
    :precondition
      (and
        (remediation_applied ?change_incident_case)
        (responder_allocated ?change_incident_case)
        (fix_ready ?change_incident_case)
        (case_active ?change_incident_case)
        (fix_authorized ?change_incident_case)
        (not
          (case_closed ?change_incident_case)
        )
        (requires_dual_authorization ?change_incident_case)
        (approval_granted ?change_incident_case)
      )
    :effect
      (and
        (case_closed ?change_incident_case)
      )
  )
  (:action clear_risk_and_escalation
    :parameters (?change_incident_case - change_incident_case ?workaround_mitigation - workaround_mitigation ?system_component - system_component)
    :precondition
      (and
        (fix_ready ?change_incident_case)
        (requires_additional_review ?change_incident_case)
        (mitigation_selected ?change_incident_case ?workaround_mitigation)
        (component_reserved ?change_incident_case ?system_component)
      )
    :effect
      (and
        (not
          (requires_additional_review ?change_incident_case)
        )
        (not
          (escalation_required ?change_incident_case)
        )
      )
  )
  (:action bind_runbook_to_case
    :parameters (?change_incident_case - change_incident_case ?runbook - runbook)
    :precondition
      (and
        (runbook_available ?runbook)
        (case_active ?change_incident_case)
      )
    :effect
      (and
        (not
          (runbook_available ?runbook)
        )
        (runbook_bound_to_case ?change_incident_case ?runbook)
      )
  )
  (:action grant_approval_channel
    :parameters (?change_incident_case - change_incident_case ?workaround_mitigation - workaround_mitigation ?system_component - system_component ?approval_channel - approval_channel)
    :precondition
      (and
        (case_has_stakeholder_channel ?change_incident_case ?approval_channel)
        (remediation_applied ?change_incident_case)
        (not
          (escalation_required ?change_incident_case)
        )
        (mitigation_selected ?change_incident_case ?workaround_mitigation)
        (fix_ready ?change_incident_case)
        (component_reserved ?change_incident_case ?system_component)
        (not
          (approval_granted ?change_incident_case)
        )
      )
    :effect
      (and
        (approval_granted ?change_incident_case)
      )
  )
  (:action apply_fix_artifact
    :parameters (?change_incident_case - change_incident_case ?fix_artifact - fix_artifact)
    :precondition
      (and
        (responder_allocated ?change_incident_case)
        (fix_cross_case_authorized ?change_incident_case ?fix_artifact)
        (not
          (remediation_applied ?change_incident_case)
        )
      )
    :effect
      (and
        (remediation_applied ?change_incident_case)
        (not
          (escalation_required ?change_incident_case)
        )
      )
  )
  (:action reserve_operational_action
    :parameters (?change_incident_case - change_incident_case ?operational_action - operational_action)
    :precondition
      (and
        (operational_action_applicable_to_case ?change_incident_case ?operational_action)
        (case_active ?change_incident_case)
        (operational_action_available ?operational_action)
      )
    :effect
      (and
        (operational_action_reserved ?change_incident_case ?operational_action)
        (not
          (operational_action_available ?operational_action)
        )
      )
  )
  (:action select_mitigation
    :parameters (?change_incident_case - change_incident_case ?workaround_mitigation - workaround_mitigation)
    :precondition
      (and
        (case_active ?change_incident_case)
        (mitigation_available ?workaround_mitigation)
        (mitigation_applicable_to_case ?change_incident_case ?workaround_mitigation)
      )
    :effect
      (and
        (not
          (mitigation_available ?workaround_mitigation)
        )
        (mitigation_selected ?change_incident_case ?workaround_mitigation)
      )
  )
  (:action release_operational_action
    :parameters (?change_incident_case - change_incident_case ?operational_action - operational_action)
    :precondition
      (and
        (operational_action_reserved ?change_incident_case ?operational_action)
      )
    :effect
      (and
        (operational_action_available ?operational_action)
        (not
          (operational_action_reserved ?change_incident_case ?operational_action)
        )
      )
  )
  (:action release_component_reservation
    :parameters (?change_incident_case - change_incident_case ?system_component - system_component)
    :precondition
      (and
        (component_reserved ?change_incident_case ?system_component)
      )
    :effect
      (and
        (component_available ?system_component)
        (not
          (component_reserved ?change_incident_case ?system_component)
        )
      )
  )
  (:action bind_fix_to_case
    :parameters (?change_incident_case - change_incident_case ?fix_artifact - fix_artifact)
    :precondition
      (and
        (fix_authorized ?change_incident_case)
        (fix_available ?fix_artifact)
        (case_alias_secondary_for_fix ?change_incident_case ?fix_artifact)
      )
    :effect
      (and
        (fix_bound_to_case ?change_incident_case ?fix_artifact)
        (not
          (fix_available ?fix_artifact)
        )
      )
  )
  (:action reserve_component
    :parameters (?change_incident_case - change_incident_case ?system_component - system_component)
    :precondition
      (and
        (case_active ?change_incident_case)
        (component_available ?system_component)
        (component_applicable_to_case ?change_incident_case ?system_component)
      )
    :effect
      (and
        (component_reserved ?change_incident_case ?system_component)
        (not
          (component_available ?system_component)
        )
      )
  )
  (:action propose_and_schedule_fix
    :parameters (?change_incident_case - change_incident_case ?deployment_window - deployment_window ?workaround_mitigation - workaround_mitigation ?system_component - system_component)
    :precondition
      (and
        (responder_allocated ?change_incident_case)
        (window_available ?deployment_window)
        (window_eligible_for_case ?change_incident_case ?deployment_window)
        (not
          (fix_ready ?change_incident_case)
        )
        (component_reserved ?change_incident_case ?system_component)
        (mitigation_selected ?change_incident_case ?workaround_mitigation)
      )
    :effect
      (and
        (fix_scheduled ?change_incident_case ?deployment_window)
        (not
          (window_available ?deployment_window)
        )
        (fix_ready ?change_incident_case)
      )
  )
  (:action finalize_execution_sequence
    :parameters (?change_incident_case - change_incident_case ?workaround_mitigation - workaround_mitigation ?system_component - system_component)
    :precondition
      (and
        (mitigation_selected ?change_incident_case ?workaround_mitigation)
        (approval_granted ?change_incident_case)
        (component_reserved ?change_incident_case ?system_component)
        (escalation_required ?change_incident_case)
      )
    :effect
      (and
        (not
          (requires_additional_review ?change_incident_case)
        )
        (not
          (escalation_required ?change_incident_case)
        )
        (not
          (remediation_applied ?change_incident_case)
        )
        (execution_order_finalized ?change_incident_case)
      )
  )
  (:action unbind_runbook_from_case
    :parameters (?change_incident_case - change_incident_case ?runbook - runbook)
    :precondition
      (and
        (runbook_bound_to_case ?change_incident_case ?runbook)
      )
    :effect
      (and
        (runbook_available ?runbook)
        (not
          (runbook_bound_to_case ?change_incident_case ?runbook)
        )
      )
  )
  (:action execute_runbook
    :parameters (?change_incident_case - change_incident_case ?runbook - runbook ?executor_operator - executor_operator)
    :precondition
      (and
        (not
          (remediation_applied ?change_incident_case)
        )
        (responder_allocated ?change_incident_case)
        (executor_available ?executor_operator)
        (runbook_bound_to_case ?change_incident_case ?runbook)
        (mitigation_authorized ?change_incident_case)
      )
    :effect
      (and
        (not
          (escalation_required ?change_incident_case)
        )
        (remediation_applied ?change_incident_case)
      )
  )
  (:action close_case_after_validation
    :parameters (?change_incident_case - change_incident_case)
    :precondition
      (and
        (case_active ?change_incident_case)
        (requires_cross_case_authorization ?change_incident_case)
        (validation_completed ?change_incident_case)
        (responder_allocated ?change_incident_case)
        (remediation_applied ?change_incident_case)
        (not
          (case_closed ?change_incident_case)
        )
        (fix_authorized ?change_incident_case)
        (fix_ready ?change_incident_case)
        (approval_granted ?change_incident_case)
      )
    :effect
      (and
        (case_closed ?change_incident_case)
      )
  )
  (:action record_validation_completion
    :parameters (?change_incident_case - change_incident_case ?runbook - runbook ?executor_operator - executor_operator)
    :precondition
      (and
        (remediation_applied ?change_incident_case)
        (executor_available ?executor_operator)
        (not
          (validation_completed ?change_incident_case)
        )
        (fix_authorized ?change_incident_case)
        (case_active ?change_incident_case)
        (requires_cross_case_authorization ?change_incident_case)
        (runbook_bound_to_case ?change_incident_case ?runbook)
      )
    :effect
      (and
        (validation_completed ?change_incident_case)
      )
  )
  (:action deselect_mitigation
    :parameters (?change_incident_case - change_incident_case ?workaround_mitigation - workaround_mitigation)
    :precondition
      (and
        (mitigation_selected ?change_incident_case ?workaround_mitigation)
      )
    :effect
      (and
        (mitigation_available ?workaround_mitigation)
        (not
          (mitigation_selected ?change_incident_case ?workaround_mitigation)
        )
      )
  )
  (:action reserve_rollback_artifact
    :parameters (?change_incident_case - change_incident_case ?rollback_artifact - rollback_artifact)
    :precondition
      (and
        (rollback_available ?rollback_artifact)
        (case_active ?change_incident_case)
        (rollback_applicable_to_case ?change_incident_case ?rollback_artifact)
      )
    :effect
      (and
        (rollback_reserved ?change_incident_case ?rollback_artifact)
        (not
          (rollback_available ?rollback_artifact)
        )
      )
  )
  (:action open_case
    :parameters (?change_incident_case - change_incident_case)
    :precondition
      (and
        (not
          (case_active ?change_incident_case)
        )
        (not
          (case_closed ?change_incident_case)
        )
      )
    :effect
      (and
        (case_active ?change_incident_case)
      )
  )
  (:action approve_mitigation
    :parameters (?change_incident_case - change_incident_case ?approver_person - approver_person)
    :precondition
      (and
        (not
          (mitigation_authorized ?change_incident_case)
        )
        (case_active ?change_incident_case)
        (approver_available ?approver_person)
        (responder_allocated ?change_incident_case)
      )
    :effect
      (and
        (escalation_required ?change_incident_case)
        (not
          (approver_available ?approver_person)
        )
        (mitigation_authorized ?change_incident_case)
      )
  )
  (:action propose_fix_with_operational_validation
    :parameters (?change_incident_case - change_incident_case ?deployment_window - deployment_window ?operational_action - operational_action ?test_environment - test_environment)
    :precondition
      (and
        (test_env_available ?test_environment)
        (testenv_applicable_to_case ?change_incident_case ?test_environment)
        (not
          (fix_ready ?change_incident_case)
        )
        (responder_allocated ?change_incident_case)
        (window_available ?deployment_window)
        (window_eligible_for_case ?change_incident_case ?deployment_window)
        (operational_action_reserved ?change_incident_case ?operational_action)
      )
    :effect
      (and
        (fix_scheduled ?change_incident_case ?deployment_window)
        (not
          (test_env_available ?test_environment)
        )
        (requires_additional_review ?change_incident_case)
        (not
          (window_available ?deployment_window)
        )
        (escalation_required ?change_incident_case)
        (fix_ready ?change_incident_case)
      )
  )
  (:action authorize_via_personal_approver
    :parameters (?change_incident_case - change_incident_case ?approver_person - approver_person)
    :precondition
      (and
        (approver_available ?approver_person)
        (not
          (escalation_required ?change_incident_case)
        )
        (remediation_applied ?change_incident_case)
        (approval_granted ?change_incident_case)
        (not
          (fix_authorized ?change_incident_case)
        )
      )
    :effect
      (and
        (fix_authorized ?change_incident_case)
        (not
          (approver_available ?approver_person)
        )
      )
  )
  (:action unassign_oncall_engineer
    :parameters (?change_incident_case - change_incident_case ?oncall_engineer - oncall_engineer)
    :precondition
      (and
        (assigned_responder ?change_incident_case ?oncall_engineer)
        (not
          (approval_granted ?change_incident_case)
        )
        (not
          (fix_ready ?change_incident_case)
        )
      )
    :effect
      (and
        (not
          (assigned_responder ?change_incident_case ?oncall_engineer)
        )
        (engineer_available ?oncall_engineer)
        (not
          (responder_allocated ?change_incident_case)
        )
        (not
          (mitigation_authorized ?change_incident_case)
        )
        (not
          (execution_order_finalized ?change_incident_case)
        )
        (not
          (remediation_applied ?change_incident_case)
        )
        (not
          (requires_additional_review ?change_incident_case)
        )
        (not
          (escalation_required ?change_incident_case)
        )
      )
  )
  (:action authorize_fix_via_runbook
    :parameters (?change_incident_case - change_incident_case ?runbook - runbook)
    :precondition
      (and
        (not
          (fix_authorized ?change_incident_case)
        )
        (runbook_bound_to_case ?change_incident_case ?runbook)
        (remediation_applied ?change_incident_case)
        (approval_granted ?change_incident_case)
        (not
          (escalation_required ?change_incident_case)
        )
      )
    :effect
      (and
        (fix_authorized ?change_incident_case)
      )
  )
  (:action close_case_with_cross_auth
    :parameters (?change_incident_case - change_incident_case ?fix_artifact - fix_artifact)
    :precondition
      (and
        (fix_authorized ?change_incident_case)
        (approval_granted ?change_incident_case)
        (fix_ready ?change_incident_case)
        (fix_cross_case_authorized ?change_incident_case ?fix_artifact)
        (remediation_applied ?change_incident_case)
        (responder_allocated ?change_incident_case)
        (case_active ?change_incident_case)
        (not
          (case_closed ?change_incident_case)
        )
        (requires_cross_case_authorization ?change_incident_case)
      )
    :effect
      (and
        (case_closed ?change_incident_case)
      )
  )
  (:action authorize_runbook_execution
    :parameters (?change_incident_case - change_incident_case ?runbook - runbook)
    :precondition
      (and
        (case_active ?change_incident_case)
        (responder_allocated ?change_incident_case)
        (not
          (mitigation_authorized ?change_incident_case)
        )
        (runbook_bound_to_case ?change_incident_case ?runbook)
      )
    :effect
      (and
        (mitigation_authorized ?change_incident_case)
      )
  )
  (:action assign_oncall_engineer
    :parameters (?change_incident_case - change_incident_case ?oncall_engineer - oncall_engineer)
    :precondition
      (and
        (not
          (responder_allocated ?change_incident_case)
        )
        (case_active ?change_incident_case)
        (engineer_available ?oncall_engineer)
        (engineer_eligible_for_case ?change_incident_case ?oncall_engineer)
      )
    :effect
      (and
        (responder_allocated ?change_incident_case)
        (not
          (engineer_available ?oncall_engineer)
        )
        (assigned_responder ?change_incident_case ?oncall_engineer)
      )
  )
  (:action execute_runbook_post_sequence
    :parameters (?change_incident_case - change_incident_case ?runbook - runbook ?executor_operator - executor_operator)
    :precondition
      (and
        (responder_allocated ?change_incident_case)
        (not
          (remediation_applied ?change_incident_case)
        )
        (runbook_bound_to_case ?change_incident_case ?runbook)
        (approval_granted ?change_incident_case)
        (executor_available ?executor_operator)
        (execution_order_finalized ?change_incident_case)
      )
    :effect
      (and
        (remediation_applied ?change_incident_case)
      )
  )
  (:action perform_cross_case_authorization
    :parameters (?case_alias_secondary - case_alias_secondary ?case_alias_primary - case_alias_primary ?fix_artifact - fix_artifact)
    :precondition
      (and
        (case_active ?case_alias_secondary)
        (fix_bound_to_case ?case_alias_primary ?fix_artifact)
        (requires_cross_case_authorization ?case_alias_secondary)
        (not
          (fix_cross_case_authorized ?case_alias_secondary ?fix_artifact)
        )
        (case_alias_primary_for_fix ?case_alias_secondary ?fix_artifact)
      )
    :effect
      (and
        (fix_cross_case_authorized ?case_alias_secondary ?fix_artifact)
      )
  )
)

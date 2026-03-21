(define (domain oncall_handoff_continuity_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types session_slot - object oncall_engineer - object change_request - object approver - object mitigation_plan - object diagnostic_check - object checklist_item - object external_ack - object service - object runbook - object test_environment - object change_package - object stakeholder_role - object primary_stakeholder - stakeholder_role secondary_stakeholder - stakeholder_role incoming_session - session_slot outgoing_session - session_slot)
  (:predicates
    (session_initialized ?handoff_session - session_slot)
    (session_assigned_engineer ?handoff_session - session_slot ?oncall_engineer - oncall_engineer)
    (session_engineer_confirmed ?handoff_session - session_slot)
    (checklist_verified ?handoff_session - session_slot)
    (runbook_executed ?handoff_session - session_slot)
    (session_has_mitigation ?handoff_session - session_slot ?mitigation_plan - mitigation_plan)
    (session_has_approver ?handoff_session - session_slot ?approver - approver)
    (session_has_diagnostic ?handoff_session - session_slot ?diagnostic_check - diagnostic_check)
    (session_has_change_package ?handoff_session - session_slot ?change_package - change_package)
    (session_change_request_ready ?handoff_session - session_slot ?change_request - change_request)
    (change_request_locked ?handoff_session - session_slot)
    (session_authorization_granted ?handoff_session - session_slot)
    (checklist_finalized ?handoff_session - session_slot)
    (session_finalized ?handoff_session - session_slot)
    (session_preexecution_flag ?handoff_session - session_slot)
    (session_execution_enabled ?handoff_session - session_slot)
    (participant_outgoing_service_binding ?handoff_session - session_slot ?service - service)
    (session_service_verified ?handoff_session - session_slot ?service - service)
    (session_participant_transferred ?handoff_session - session_slot)
    (engineer_available ?oncall_engineer - oncall_engineer)
    (change_request_valid ?change_request - change_request)
    (mitigation_available ?mitigation_plan - mitigation_plan)
    (approver_available ?approver - approver)
    (diagnostic_available ?diagnostic_check - diagnostic_check)
    (checklist_item_available ?checklist_item - checklist_item)
    (external_ack_available ?external_ack - external_ack)
    (service_execution_token_available ?service - service)
    (runbook_available ?runbook - runbook)
    (test_environment_available ?test_environment - test_environment)
    (change_package_available ?change_package - change_package)
    (session_engineer_eligibility ?handoff_session - session_slot ?oncall_engineer - oncall_engineer)
    (session_change_request_link ?handoff_session - session_slot ?change_request - change_request)
    (session_mitigation_assignment ?handoff_session - session_slot ?mitigation_plan - mitigation_plan)
    (session_has_approver_binding ?handoff_session - session_slot ?approver - approver)
    (session_has_diagnostic_binding ?handoff_session - session_slot ?diagnostic_check - diagnostic_check)
    (session_test_environment_binding ?handoff_session - session_slot ?test_environment - test_environment)
    (session_change_package_binding ?handoff_session - session_slot ?change_package - change_package)
    (session_stakeholder_required ?handoff_session - session_slot ?stakeholder_role - stakeholder_role)
    (session_service_execution_token ?handoff_session - session_slot ?service - service)
    (incoming_slot_present ?handoff_session - session_slot)
    (outgoing_slot_present ?handoff_session - session_slot)
    (session_checklist_bound_item ?handoff_session - session_slot ?checklist_item - checklist_item)
    (session_requires_additional_validation ?handoff_session - session_slot)
    (participant_service_bind ?handoff_session - session_slot ?service - service)
  )
  (:action initialize_handoff_session
    :parameters (?handoff_session - session_slot)
    :precondition
      (and
        (not
          (session_initialized ?handoff_session)
        )
        (not
          (session_finalized ?handoff_session)
        )
      )
    :effect
      (and
        (session_initialized ?handoff_session)
      )
  )
  (:action assign_engineer_to_session
    :parameters (?handoff_session - session_slot ?oncall_engineer - oncall_engineer)
    :precondition
      (and
        (session_initialized ?handoff_session)
        (engineer_available ?oncall_engineer)
        (session_engineer_eligibility ?handoff_session ?oncall_engineer)
        (not
          (session_engineer_confirmed ?handoff_session)
        )
      )
    :effect
      (and
        (session_assigned_engineer ?handoff_session ?oncall_engineer)
        (session_engineer_confirmed ?handoff_session)
        (not
          (engineer_available ?oncall_engineer)
        )
      )
  )
  (:action release_engineer_from_session
    :parameters (?handoff_session - session_slot ?oncall_engineer - oncall_engineer)
    :precondition
      (and
        (session_assigned_engineer ?handoff_session ?oncall_engineer)
        (not
          (change_request_locked ?handoff_session)
        )
        (not
          (session_authorization_granted ?handoff_session)
        )
      )
    :effect
      (and
        (not
          (session_assigned_engineer ?handoff_session ?oncall_engineer)
        )
        (not
          (session_engineer_confirmed ?handoff_session)
        )
        (not
          (checklist_verified ?handoff_session)
        )
        (not
          (runbook_executed ?handoff_session)
        )
        (not
          (session_preexecution_flag ?handoff_session)
        )
        (not
          (session_execution_enabled ?handoff_session)
        )
        (not
          (session_requires_additional_validation ?handoff_session)
        )
        (engineer_available ?oncall_engineer)
      )
  )
  (:action bind_checklist_item
    :parameters (?handoff_session - session_slot ?checklist_item - checklist_item)
    :precondition
      (and
        (session_initialized ?handoff_session)
        (checklist_item_available ?checklist_item)
      )
    :effect
      (and
        (session_checklist_bound_item ?handoff_session ?checklist_item)
        (not
          (checklist_item_available ?checklist_item)
        )
      )
  )
  (:action unbind_checklist_item
    :parameters (?handoff_session - session_slot ?checklist_item - checklist_item)
    :precondition
      (and
        (session_checklist_bound_item ?handoff_session ?checklist_item)
      )
    :effect
      (and
        (checklist_item_available ?checklist_item)
        (not
          (session_checklist_bound_item ?handoff_session ?checklist_item)
        )
      )
  )
  (:action verify_checklist_item
    :parameters (?handoff_session - session_slot ?checklist_item - checklist_item)
    :precondition
      (and
        (session_initialized ?handoff_session)
        (session_engineer_confirmed ?handoff_session)
        (session_checklist_bound_item ?handoff_session ?checklist_item)
        (not
          (checklist_verified ?handoff_session)
        )
      )
    :effect
      (and
        (checklist_verified ?handoff_session)
      )
  )
  (:action record_external_ack_and_verify
    :parameters (?handoff_session - session_slot ?external_ack - external_ack)
    :precondition
      (and
        (session_initialized ?handoff_session)
        (session_engineer_confirmed ?handoff_session)
        (external_ack_available ?external_ack)
        (not
          (checklist_verified ?handoff_session)
        )
      )
    :effect
      (and
        (checklist_verified ?handoff_session)
        (session_preexecution_flag ?handoff_session)
        (not
          (external_ack_available ?external_ack)
        )
      )
  )
  (:action attach_runbook_and_mark
    :parameters (?handoff_session - session_slot ?checklist_item - checklist_item ?runbook - runbook)
    :precondition
      (and
        (checklist_verified ?handoff_session)
        (session_engineer_confirmed ?handoff_session)
        (session_checklist_bound_item ?handoff_session ?checklist_item)
        (runbook_available ?runbook)
        (not
          (runbook_executed ?handoff_session)
        )
      )
    :effect
      (and
        (runbook_executed ?handoff_session)
        (not
          (session_preexecution_flag ?handoff_session)
        )
      )
  )
  (:action mark_runbook_for_service
    :parameters (?handoff_session - session_slot ?service - service)
    :precondition
      (and
        (session_engineer_confirmed ?handoff_session)
        (session_service_verified ?handoff_session ?service)
        (not
          (runbook_executed ?handoff_session)
        )
      )
    :effect
      (and
        (runbook_executed ?handoff_session)
        (not
          (session_preexecution_flag ?handoff_session)
        )
      )
  )
  (:action reserve_mitigation_plan
    :parameters (?handoff_session - session_slot ?mitigation_plan - mitigation_plan)
    :precondition
      (and
        (session_initialized ?handoff_session)
        (mitigation_available ?mitigation_plan)
        (session_mitigation_assignment ?handoff_session ?mitigation_plan)
      )
    :effect
      (and
        (session_has_mitigation ?handoff_session ?mitigation_plan)
        (not
          (mitigation_available ?mitigation_plan)
        )
      )
  )
  (:action release_mitigation_plan
    :parameters (?handoff_session - session_slot ?mitigation_plan - mitigation_plan)
    :precondition
      (and
        (session_has_mitigation ?handoff_session ?mitigation_plan)
      )
    :effect
      (and
        (mitigation_available ?mitigation_plan)
        (not
          (session_has_mitigation ?handoff_session ?mitigation_plan)
        )
      )
  )
  (:action reserve_approver
    :parameters (?handoff_session - session_slot ?approver - approver)
    :precondition
      (and
        (session_initialized ?handoff_session)
        (approver_available ?approver)
        (session_has_approver_binding ?handoff_session ?approver)
      )
    :effect
      (and
        (session_has_approver ?handoff_session ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action release_approver
    :parameters (?handoff_session - session_slot ?approver - approver)
    :precondition
      (and
        (session_has_approver ?handoff_session ?approver)
      )
    :effect
      (and
        (approver_available ?approver)
        (not
          (session_has_approver ?handoff_session ?approver)
        )
      )
  )
  (:action reserve_diagnostic_check
    :parameters (?handoff_session - session_slot ?diagnostic_check - diagnostic_check)
    :precondition
      (and
        (session_initialized ?handoff_session)
        (diagnostic_available ?diagnostic_check)
        (session_has_diagnostic_binding ?handoff_session ?diagnostic_check)
      )
    :effect
      (and
        (session_has_diagnostic ?handoff_session ?diagnostic_check)
        (not
          (diagnostic_available ?diagnostic_check)
        )
      )
  )
  (:action release_diagnostic_check
    :parameters (?handoff_session - session_slot ?diagnostic_check - diagnostic_check)
    :precondition
      (and
        (session_has_diagnostic ?handoff_session ?diagnostic_check)
      )
    :effect
      (and
        (diagnostic_available ?diagnostic_check)
        (not
          (session_has_diagnostic ?handoff_session ?diagnostic_check)
        )
      )
  )
  (:action reserve_change_package
    :parameters (?handoff_session - session_slot ?change_package - change_package)
    :precondition
      (and
        (session_initialized ?handoff_session)
        (change_package_available ?change_package)
        (session_change_package_binding ?handoff_session ?change_package)
      )
    :effect
      (and
        (session_has_change_package ?handoff_session ?change_package)
        (not
          (change_package_available ?change_package)
        )
      )
  )
  (:action release_change_package
    :parameters (?handoff_session - session_slot ?change_package - change_package)
    :precondition
      (and
        (session_has_change_package ?handoff_session ?change_package)
      )
    :effect
      (and
        (change_package_available ?change_package)
        (not
          (session_has_change_package ?handoff_session ?change_package)
        )
      )
  )
  (:action bind_change_request_with_required_artifacts
    :parameters (?handoff_session - session_slot ?change_request - change_request ?mitigation_plan - mitigation_plan ?approver - approver)
    :precondition
      (and
        (session_engineer_confirmed ?handoff_session)
        (session_has_mitigation ?handoff_session ?mitigation_plan)
        (session_has_approver ?handoff_session ?approver)
        (change_request_valid ?change_request)
        (session_change_request_link ?handoff_session ?change_request)
        (not
          (change_request_locked ?handoff_session)
        )
      )
    :effect
      (and
        (session_change_request_ready ?handoff_session ?change_request)
        (change_request_locked ?handoff_session)
        (not
          (change_request_valid ?change_request)
        )
      )
  )
  (:action bind_change_request_with_diagnostic_and_testenv
    :parameters (?handoff_session - session_slot ?change_request - change_request ?diagnostic_check - diagnostic_check ?test_environment - test_environment)
    :precondition
      (and
        (session_engineer_confirmed ?handoff_session)
        (session_has_diagnostic ?handoff_session ?diagnostic_check)
        (test_environment_available ?test_environment)
        (change_request_valid ?change_request)
        (session_change_request_link ?handoff_session ?change_request)
        (session_test_environment_binding ?handoff_session ?test_environment)
        (not
          (change_request_locked ?handoff_session)
        )
      )
    :effect
      (and
        (session_change_request_ready ?handoff_session ?change_request)
        (change_request_locked ?handoff_session)
        (session_requires_additional_validation ?handoff_session)
        (session_preexecution_flag ?handoff_session)
        (not
          (change_request_valid ?change_request)
        )
        (not
          (test_environment_available ?test_environment)
        )
      )
  )
  (:action consume_approvals_before_execution
    :parameters (?handoff_session - session_slot ?mitigation_plan - mitigation_plan ?approver - approver)
    :precondition
      (and
        (change_request_locked ?handoff_session)
        (session_requires_additional_validation ?handoff_session)
        (session_has_mitigation ?handoff_session ?mitigation_plan)
        (session_has_approver ?handoff_session ?approver)
      )
    :effect
      (and
        (not
          (session_requires_additional_validation ?handoff_session)
        )
        (not
          (session_preexecution_flag ?handoff_session)
        )
      )
  )
  (:action record_multi_party_authorization
    :parameters (?handoff_session - session_slot ?mitigation_plan - mitigation_plan ?approver - approver ?primary_stakeholder - primary_stakeholder)
    :precondition
      (and
        (runbook_executed ?handoff_session)
        (change_request_locked ?handoff_session)
        (session_has_mitigation ?handoff_session ?mitigation_plan)
        (session_has_approver ?handoff_session ?approver)
        (session_stakeholder_required ?handoff_session ?primary_stakeholder)
        (not
          (session_preexecution_flag ?handoff_session)
        )
        (not
          (session_authorization_granted ?handoff_session)
        )
      )
    :effect
      (and
        (session_authorization_granted ?handoff_session)
      )
  )
  (:action record_multi_party_authorization_with_secondary
    :parameters (?handoff_session - session_slot ?diagnostic_check - diagnostic_check ?change_package - change_package ?secondary_stakeholder - secondary_stakeholder)
    :precondition
      (and
        (runbook_executed ?handoff_session)
        (change_request_locked ?handoff_session)
        (session_has_diagnostic ?handoff_session ?diagnostic_check)
        (session_has_change_package ?handoff_session ?change_package)
        (session_stakeholder_required ?handoff_session ?secondary_stakeholder)
        (not
          (session_authorization_granted ?handoff_session)
        )
      )
    :effect
      (and
        (session_authorization_granted ?handoff_session)
        (session_preexecution_flag ?handoff_session)
      )
  )
  (:action finalize_authorization_and_prepare_execution
    :parameters (?handoff_session - session_slot ?mitigation_plan - mitigation_plan ?approver - approver)
    :precondition
      (and
        (session_authorization_granted ?handoff_session)
        (session_preexecution_flag ?handoff_session)
        (session_has_mitigation ?handoff_session ?mitigation_plan)
        (session_has_approver ?handoff_session ?approver)
      )
    :effect
      (and
        (session_execution_enabled ?handoff_session)
        (not
          (session_preexecution_flag ?handoff_session)
        )
        (not
          (runbook_executed ?handoff_session)
        )
        (not
          (session_requires_additional_validation ?handoff_session)
        )
      )
  )
  (:action perform_checklist_step_with_runbook
    :parameters (?handoff_session - session_slot ?checklist_item - checklist_item ?runbook - runbook)
    :precondition
      (and
        (session_execution_enabled ?handoff_session)
        (session_authorization_granted ?handoff_session)
        (session_engineer_confirmed ?handoff_session)
        (session_checklist_bound_item ?handoff_session ?checklist_item)
        (runbook_available ?runbook)
        (not
          (runbook_executed ?handoff_session)
        )
      )
    :effect
      (and
        (runbook_executed ?handoff_session)
      )
  )
  (:action finalize_checklist_item
    :parameters (?handoff_session - session_slot ?checklist_item - checklist_item)
    :precondition
      (and
        (session_authorization_granted ?handoff_session)
        (runbook_executed ?handoff_session)
        (not
          (session_preexecution_flag ?handoff_session)
        )
        (session_checklist_bound_item ?handoff_session ?checklist_item)
        (not
          (checklist_finalized ?handoff_session)
        )
      )
    :effect
      (and
        (checklist_finalized ?handoff_session)
      )
  )
  (:action finalize_with_external_ack
    :parameters (?handoff_session - session_slot ?external_ack - external_ack)
    :precondition
      (and
        (session_authorization_granted ?handoff_session)
        (runbook_executed ?handoff_session)
        (not
          (session_preexecution_flag ?handoff_session)
        )
        (external_ack_available ?external_ack)
        (not
          (checklist_finalized ?handoff_session)
        )
      )
    :effect
      (and
        (checklist_finalized ?handoff_session)
        (not
          (external_ack_available ?external_ack)
        )
      )
  )
  (:action bind_service_execution_token
    :parameters (?handoff_session - session_slot ?service - service)
    :precondition
      (and
        (checklist_finalized ?handoff_session)
        (service_execution_token_available ?service)
        (participant_service_bind ?handoff_session ?service)
      )
    :effect
      (and
        (session_service_execution_token ?handoff_session ?service)
        (not
          (service_execution_token_available ?service)
        )
      )
  )
  (:action record_participant_transfer_confirmation
    :parameters (?outgoing_participant - outgoing_session ?incoming_participant - incoming_session ?service - service)
    :precondition
      (and
        (session_initialized ?outgoing_participant)
        (outgoing_slot_present ?outgoing_participant)
        (participant_outgoing_service_binding ?outgoing_participant ?service)
        (session_service_execution_token ?incoming_participant ?service)
        (not
          (session_service_verified ?outgoing_participant ?service)
        )
      )
    :effect
      (and
        (session_service_verified ?outgoing_participant ?service)
      )
  )
  (:action record_post_transfer_check_completion
    :parameters (?handoff_session - session_slot ?checklist_item - checklist_item ?runbook - runbook)
    :precondition
      (and
        (session_initialized ?handoff_session)
        (outgoing_slot_present ?handoff_session)
        (runbook_executed ?handoff_session)
        (checklist_finalized ?handoff_session)
        (session_checklist_bound_item ?handoff_session ?checklist_item)
        (runbook_available ?runbook)
        (not
          (session_participant_transferred ?handoff_session)
        )
      )
    :effect
      (and
        (session_participant_transferred ?handoff_session)
      )
  )
  (:action set_finalization_flag
    :parameters (?handoff_session - session_slot)
    :precondition
      (and
        (incoming_slot_present ?handoff_session)
        (session_initialized ?handoff_session)
        (session_engineer_confirmed ?handoff_session)
        (change_request_locked ?handoff_session)
        (session_authorization_granted ?handoff_session)
        (checklist_finalized ?handoff_session)
        (runbook_executed ?handoff_session)
        (not
          (session_finalized ?handoff_session)
        )
      )
    :effect
      (and
        (session_finalized ?handoff_session)
      )
  )
  (:action set_finalization_flag_with_service_verification
    :parameters (?handoff_session - session_slot ?service - service)
    :precondition
      (and
        (outgoing_slot_present ?handoff_session)
        (session_initialized ?handoff_session)
        (session_engineer_confirmed ?handoff_session)
        (change_request_locked ?handoff_session)
        (session_authorization_granted ?handoff_session)
        (checklist_finalized ?handoff_session)
        (runbook_executed ?handoff_session)
        (session_service_verified ?handoff_session ?service)
        (not
          (session_finalized ?handoff_session)
        )
      )
    :effect
      (and
        (session_finalized ?handoff_session)
      )
  )
  (:action set_finalization_flag_with_transfer
    :parameters (?handoff_session - session_slot)
    :precondition
      (and
        (outgoing_slot_present ?handoff_session)
        (session_initialized ?handoff_session)
        (session_engineer_confirmed ?handoff_session)
        (change_request_locked ?handoff_session)
        (session_authorization_granted ?handoff_session)
        (checklist_finalized ?handoff_session)
        (runbook_executed ?handoff_session)
        (session_participant_transferred ?handoff_session)
        (not
          (session_finalized ?handoff_session)
        )
      )
    :effect
      (and
        (session_finalized ?handoff_session)
      )
  )
)

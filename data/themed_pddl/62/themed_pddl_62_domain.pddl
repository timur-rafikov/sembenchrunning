(define (domain emergency_change_window_management_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types change_window - object approver - object time_slot - object affected_component - object engineer - object oncall_contact - object communication_channel - object escalation_contact - object execution_step - object runbook_document - object environment - object risk_assessment - object stakeholder - object technical_stakeholder - stakeholder business_stakeholder - stakeholder window_variant_a - change_window window_variant_b - change_window)
  (:predicates
    (escalation_contact_available ?escalation_contact - escalation_contact)
    (component_allocated ?change_window - change_window ?affected_component - affected_component)
    (execution_started ?change_window - change_window)
    (assigned_approver ?change_window - change_window ?approver - approver)
    (window_stakeholder_mapping ?change_window - change_window ?stakeholder - stakeholder)
    (oncall_available ?oncall_contact - oncall_contact)
    (component_available ?affected_component - affected_component)
    (window_risk_mapping ?change_window - change_window ?risk_assessment - risk_assessment)
    (window_closed ?change_window - change_window)
    (auto_finalization_eligible ?change_window - change_window)
    (eligible_approver_for_window ?change_window - change_window ?approver - approver)
    (timeslot_available ?time_slot - time_slot)
    (environment_reserved ?environment - environment)
    (channel_available ?communication_channel - communication_channel)
    (schedule_locked ?change_window - change_window)
    (window_component_mapping ?change_window - change_window ?affected_component - affected_component)
    (risk_linked ?change_window - change_window ?risk_assessment - risk_assessment)
    (scheduled_for_slot ?change_window - change_window ?time_slot - time_slot)
    (pre_execution_checks_passed ?change_window - change_window)
    (window_oncall_mapping ?change_window - change_window ?oncall_contact - oncall_contact)
    (risk_assessment_available ?risk_assessment - risk_assessment)
    (requires_cross_variant_coordination ?change_window - change_window)
    (runbook_validated ?change_window - change_window)
    (window_engineer_mapping ?change_window - change_window ?engineer - engineer)
    (engineer_allocated ?change_window - change_window ?engineer - engineer)
    (special_execution_marker ?change_window - change_window)
    (channel_reserved_for_window ?change_window - change_window ?communication_channel - communication_channel)
    (operational_readiness_flag ?change_window - change_window)
    (window_environment_mapping ?change_window - change_window ?environment - environment)
    (change_window_exists ?change_window - change_window)
    (approver_available ?approver - approver)
    (has_assignment_state ?change_window - change_window)
    (runbook_present ?runbook_document - runbook_document)
    (execution_step_open ?execution_step - execution_step)
    (oncall_allocated ?change_window - change_window ?oncall_contact - oncall_contact)
    (variant_step_relation ?change_window - change_window ?execution_step - execution_step)
    (channel_confirmed ?change_window - change_window)
    (channel_verified ?change_window - change_window)
    (initial_variant_mapping ?change_window - change_window ?execution_step - execution_step)
    (engineer_available ?engineer - engineer)
    (variant_execution_authority ?change_window - change_window ?execution_step - execution_step)
    (window_time_slot_mapping ?change_window - change_window ?time_slot - time_slot)
    (escalation_used ?change_window - change_window)
    (execution_step_authorized ?change_window - change_window ?execution_step - execution_step)
  )
  (:action unlink_risk_assessment
    :parameters (?change_window - change_window ?risk_assessment - risk_assessment)
    :precondition
      (and
        (risk_linked ?change_window ?risk_assessment)
      )
    :effect
      (and
        (risk_assessment_available ?risk_assessment)
        (not
          (risk_linked ?change_window ?risk_assessment)
        )
      )
  )
  (:action perform_cross_domain_checks
    :parameters (?change_window - change_window ?oncall_contact - oncall_contact ?risk_assessment - risk_assessment ?business_stakeholder - business_stakeholder)
    :precondition
      (and
        (not
          (pre_execution_checks_passed ?change_window)
        )
        (schedule_locked ?change_window)
        (runbook_validated ?change_window)
        (risk_linked ?change_window ?risk_assessment)
        (window_stakeholder_mapping ?change_window ?business_stakeholder)
        (oncall_allocated ?change_window ?oncall_contact)
      )
    :effect
      (and
        (escalation_used ?change_window)
        (pre_execution_checks_passed ?change_window)
      )
  )
  (:action auto_finalize_window
    :parameters (?change_window - change_window)
    :precondition
      (and
        (runbook_validated ?change_window)
        (has_assignment_state ?change_window)
        (schedule_locked ?change_window)
        (change_window_exists ?change_window)
        (channel_verified ?change_window)
        (not
          (window_closed ?change_window)
        )
        (auto_finalization_eligible ?change_window)
        (pre_execution_checks_passed ?change_window)
      )
    :effect
      (and
        (window_closed ?change_window)
      )
  )
  (:action clear_special_execution_marker
    :parameters (?change_window - change_window ?engineer - engineer ?affected_component - affected_component)
    :precondition
      (and
        (schedule_locked ?change_window)
        (special_execution_marker ?change_window)
        (engineer_allocated ?change_window ?engineer)
        (component_allocated ?change_window ?affected_component)
      )
    :effect
      (and
        (not
          (special_execution_marker ?change_window)
        )
        (not
          (escalation_used ?change_window)
        )
      )
  )
  (:action reserve_channel
    :parameters (?change_window - change_window ?communication_channel - communication_channel)
    :precondition
      (and
        (channel_available ?communication_channel)
        (change_window_exists ?change_window)
      )
    :effect
      (and
        (not
          (channel_available ?communication_channel)
        )
        (channel_reserved_for_window ?change_window ?communication_channel)
      )
  )
  (:action perform_pre_execution_checks
    :parameters (?change_window - change_window ?engineer - engineer ?affected_component - affected_component ?technical_stakeholder - technical_stakeholder)
    :precondition
      (and
        (window_stakeholder_mapping ?change_window ?technical_stakeholder)
        (runbook_validated ?change_window)
        (not
          (escalation_used ?change_window)
        )
        (engineer_allocated ?change_window ?engineer)
        (schedule_locked ?change_window)
        (component_allocated ?change_window ?affected_component)
        (not
          (pre_execution_checks_passed ?change_window)
        )
      )
    :effect
      (and
        (pre_execution_checks_passed ?change_window)
      )
  )
  (:action authorize_execution_step_runbook
    :parameters (?change_window - change_window ?execution_step - execution_step)
    :precondition
      (and
        (has_assignment_state ?change_window)
        (execution_step_authorized ?change_window ?execution_step)
        (not
          (runbook_validated ?change_window)
        )
      )
    :effect
      (and
        (runbook_validated ?change_window)
        (not
          (escalation_used ?change_window)
        )
      )
  )
  (:action allocate_oncall
    :parameters (?change_window - change_window ?oncall_contact - oncall_contact)
    :precondition
      (and
        (window_oncall_mapping ?change_window ?oncall_contact)
        (change_window_exists ?change_window)
        (oncall_available ?oncall_contact)
      )
    :effect
      (and
        (oncall_allocated ?change_window ?oncall_contact)
        (not
          (oncall_available ?oncall_contact)
        )
      )
  )
  (:action allocate_engineer
    :parameters (?change_window - change_window ?engineer - engineer)
    :precondition
      (and
        (change_window_exists ?change_window)
        (engineer_available ?engineer)
        (window_engineer_mapping ?change_window ?engineer)
      )
    :effect
      (and
        (not
          (engineer_available ?engineer)
        )
        (engineer_allocated ?change_window ?engineer)
      )
  )
  (:action release_oncall
    :parameters (?change_window - change_window ?oncall_contact - oncall_contact)
    :precondition
      (and
        (oncall_allocated ?change_window ?oncall_contact)
      )
    :effect
      (and
        (oncall_available ?oncall_contact)
        (not
          (oncall_allocated ?change_window ?oncall_contact)
        )
      )
  )
  (:action release_component
    :parameters (?change_window - change_window ?affected_component - affected_component)
    :precondition
      (and
        (component_allocated ?change_window ?affected_component)
      )
    :effect
      (and
        (component_available ?affected_component)
        (not
          (component_allocated ?change_window ?affected_component)
        )
      )
  )
  (:action bind_step_to_variant
    :parameters (?change_window - change_window ?execution_step - execution_step)
    :precondition
      (and
        (channel_verified ?change_window)
        (execution_step_open ?execution_step)
        (initial_variant_mapping ?change_window ?execution_step)
      )
    :effect
      (and
        (variant_step_relation ?change_window ?execution_step)
        (not
          (execution_step_open ?execution_step)
        )
      )
  )
  (:action allocate_component
    :parameters (?change_window - change_window ?affected_component - affected_component)
    :precondition
      (and
        (change_window_exists ?change_window)
        (component_available ?affected_component)
        (window_component_mapping ?change_window ?affected_component)
      )
    :effect
      (and
        (component_allocated ?change_window ?affected_component)
        (not
          (component_available ?affected_component)
        )
      )
  )
  (:action schedule_window_slot
    :parameters (?change_window - change_window ?time_slot - time_slot ?engineer - engineer ?affected_component - affected_component)
    :precondition
      (and
        (has_assignment_state ?change_window)
        (timeslot_available ?time_slot)
        (window_time_slot_mapping ?change_window ?time_slot)
        (not
          (schedule_locked ?change_window)
        )
        (component_allocated ?change_window ?affected_component)
        (engineer_allocated ?change_window ?engineer)
      )
    :effect
      (and
        (scheduled_for_slot ?change_window ?time_slot)
        (not
          (timeslot_available ?time_slot)
        )
        (schedule_locked ?change_window)
      )
  )
  (:action mark_execution_started
    :parameters (?change_window - change_window ?engineer - engineer ?affected_component - affected_component)
    :precondition
      (and
        (engineer_allocated ?change_window ?engineer)
        (pre_execution_checks_passed ?change_window)
        (component_allocated ?change_window ?affected_component)
        (escalation_used ?change_window)
      )
    :effect
      (and
        (not
          (special_execution_marker ?change_window)
        )
        (not
          (escalation_used ?change_window)
        )
        (not
          (runbook_validated ?change_window)
        )
        (execution_started ?change_window)
      )
  )
  (:action release_channel
    :parameters (?change_window - change_window ?communication_channel - communication_channel)
    :precondition
      (and
        (channel_reserved_for_window ?change_window ?communication_channel)
      )
    :effect
      (and
        (channel_available ?communication_channel)
        (not
          (channel_reserved_for_window ?change_window ?communication_channel)
        )
      )
  )
  (:action validate_runbook
    :parameters (?change_window - change_window ?communication_channel - communication_channel ?runbook_document - runbook_document)
    :precondition
      (and
        (not
          (runbook_validated ?change_window)
        )
        (has_assignment_state ?change_window)
        (runbook_present ?runbook_document)
        (channel_reserved_for_window ?change_window ?communication_channel)
        (channel_confirmed ?change_window)
      )
    :effect
      (and
        (not
          (escalation_used ?change_window)
        )
        (runbook_validated ?change_window)
      )
  )
  (:action finalize_window_after_operational_readiness
    :parameters (?change_window - change_window)
    :precondition
      (and
        (change_window_exists ?change_window)
        (requires_cross_variant_coordination ?change_window)
        (operational_readiness_flag ?change_window)
        (has_assignment_state ?change_window)
        (runbook_validated ?change_window)
        (not
          (window_closed ?change_window)
        )
        (channel_verified ?change_window)
        (schedule_locked ?change_window)
        (pre_execution_checks_passed ?change_window)
      )
    :effect
      (and
        (window_closed ?change_window)
      )
  )
  (:action mark_operational_readiness
    :parameters (?change_window - change_window ?communication_channel - communication_channel ?runbook_document - runbook_document)
    :precondition
      (and
        (runbook_validated ?change_window)
        (runbook_present ?runbook_document)
        (not
          (operational_readiness_flag ?change_window)
        )
        (channel_verified ?change_window)
        (change_window_exists ?change_window)
        (requires_cross_variant_coordination ?change_window)
        (channel_reserved_for_window ?change_window ?communication_channel)
      )
    :effect
      (and
        (operational_readiness_flag ?change_window)
      )
  )
  (:action release_engineer
    :parameters (?change_window - change_window ?engineer - engineer)
    :precondition
      (and
        (engineer_allocated ?change_window ?engineer)
      )
    :effect
      (and
        (engineer_available ?engineer)
        (not
          (engineer_allocated ?change_window ?engineer)
        )
      )
  )
  (:action link_risk_assessment
    :parameters (?change_window - change_window ?risk_assessment - risk_assessment)
    :precondition
      (and
        (risk_assessment_available ?risk_assessment)
        (change_window_exists ?change_window)
        (window_risk_mapping ?change_window ?risk_assessment)
      )
    :effect
      (and
        (risk_linked ?change_window ?risk_assessment)
        (not
          (risk_assessment_available ?risk_assessment)
        )
      )
  )
  (:action create_change_window
    :parameters (?change_window - change_window)
    :precondition
      (and
        (not
          (change_window_exists ?change_window)
        )
        (not
          (window_closed ?change_window)
        )
      )
    :effect
      (and
        (change_window_exists ?change_window)
      )
  )
  (:action escalate_for_approval
    :parameters (?change_window - change_window ?escalation_contact - escalation_contact)
    :precondition
      (and
        (not
          (channel_confirmed ?change_window)
        )
        (change_window_exists ?change_window)
        (escalation_contact_available ?escalation_contact)
        (has_assignment_state ?change_window)
      )
    :effect
      (and
        (escalation_used ?change_window)
        (not
          (escalation_contact_available ?escalation_contact)
        )
        (channel_confirmed ?change_window)
      )
  )
  (:action schedule_window_with_oncall_env
    :parameters (?change_window - change_window ?time_slot - time_slot ?oncall_contact - oncall_contact ?environment - environment)
    :precondition
      (and
        (environment_reserved ?environment)
        (window_environment_mapping ?change_window ?environment)
        (not
          (schedule_locked ?change_window)
        )
        (has_assignment_state ?change_window)
        (timeslot_available ?time_slot)
        (window_time_slot_mapping ?change_window ?time_slot)
        (oncall_allocated ?change_window ?oncall_contact)
      )
    :effect
      (and
        (scheduled_for_slot ?change_window ?time_slot)
        (not
          (environment_reserved ?environment)
        )
        (special_execution_marker ?change_window)
        (not
          (timeslot_available ?time_slot)
        )
        (escalation_used ?change_window)
        (schedule_locked ?change_window)
      )
  )
  (:action verify_channel_with_escalation
    :parameters (?change_window - change_window ?escalation_contact - escalation_contact)
    :precondition
      (and
        (escalation_contact_available ?escalation_contact)
        (not
          (escalation_used ?change_window)
        )
        (runbook_validated ?change_window)
        (pre_execution_checks_passed ?change_window)
        (not
          (channel_verified ?change_window)
        )
      )
    :effect
      (and
        (channel_verified ?change_window)
        (not
          (escalation_contact_available ?escalation_contact)
        )
      )
  )
  (:action revoke_approver
    :parameters (?change_window - change_window ?approver - approver)
    :precondition
      (and
        (assigned_approver ?change_window ?approver)
        (not
          (pre_execution_checks_passed ?change_window)
        )
        (not
          (schedule_locked ?change_window)
        )
      )
    :effect
      (and
        (not
          (assigned_approver ?change_window ?approver)
        )
        (approver_available ?approver)
        (not
          (has_assignment_state ?change_window)
        )
        (not
          (channel_confirmed ?change_window)
        )
        (not
          (execution_started ?change_window)
        )
        (not
          (runbook_validated ?change_window)
        )
        (not
          (special_execution_marker ?change_window)
        )
        (not
          (escalation_used ?change_window)
        )
      )
  )
  (:action verify_channel
    :parameters (?change_window - change_window ?communication_channel - communication_channel)
    :precondition
      (and
        (not
          (channel_verified ?change_window)
        )
        (channel_reserved_for_window ?change_window ?communication_channel)
        (runbook_validated ?change_window)
        (pre_execution_checks_passed ?change_window)
        (not
          (escalation_used ?change_window)
        )
      )
    :effect
      (and
        (channel_verified ?change_window)
      )
  )
  (:action finalize_window_with_step_authorization
    :parameters (?change_window - change_window ?execution_step - execution_step)
    :precondition
      (and
        (channel_verified ?change_window)
        (pre_execution_checks_passed ?change_window)
        (schedule_locked ?change_window)
        (execution_step_authorized ?change_window ?execution_step)
        (runbook_validated ?change_window)
        (has_assignment_state ?change_window)
        (change_window_exists ?change_window)
        (not
          (window_closed ?change_window)
        )
        (requires_cross_variant_coordination ?change_window)
      )
    :effect
      (and
        (window_closed ?change_window)
      )
  )
  (:action confirm_channel
    :parameters (?change_window - change_window ?communication_channel - communication_channel)
    :precondition
      (and
        (change_window_exists ?change_window)
        (has_assignment_state ?change_window)
        (not
          (channel_confirmed ?change_window)
        )
        (channel_reserved_for_window ?change_window ?communication_channel)
      )
    :effect
      (and
        (channel_confirmed ?change_window)
      )
  )
  (:action assign_approver
    :parameters (?change_window - change_window ?approver - approver)
    :precondition
      (and
        (not
          (has_assignment_state ?change_window)
        )
        (change_window_exists ?change_window)
        (approver_available ?approver)
        (eligible_approver_for_window ?change_window ?approver)
      )
    :effect
      (and
        (has_assignment_state ?change_window)
        (not
          (approver_available ?approver)
        )
        (assigned_approver ?change_window ?approver)
      )
  )
  (:action validate_runbook_during_execution
    :parameters (?change_window - change_window ?communication_channel - communication_channel ?runbook_document - runbook_document)
    :precondition
      (and
        (has_assignment_state ?change_window)
        (not
          (runbook_validated ?change_window)
        )
        (channel_reserved_for_window ?change_window ?communication_channel)
        (pre_execution_checks_passed ?change_window)
        (runbook_present ?runbook_document)
        (execution_started ?change_window)
      )
    :effect
      (and
        (runbook_validated ?change_window)
      )
  )
  (:action authorize_step_across_variants
    :parameters (?window_variant_b - window_variant_b ?window_variant_a - window_variant_a ?execution_step - execution_step)
    :precondition
      (and
        (change_window_exists ?window_variant_b)
        (variant_step_relation ?window_variant_a ?execution_step)
        (requires_cross_variant_coordination ?window_variant_b)
        (not
          (execution_step_authorized ?window_variant_b ?execution_step)
        )
        (variant_execution_authority ?window_variant_b ?execution_step)
      )
    :effect
      (and
        (execution_step_authorized ?window_variant_b ?execution_step)
      )
  )
)

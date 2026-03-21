(define (domain recurring_alert_noise_reduction_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types incident_case - object responder - object mitigation_runbook - object configuration_change - object alert_rule - object suppression_rule - object alert_signature - object approver - object change_ticket - object automation_playbook - object rollback_plan - object tag - object execution_context - object human_team - execution_context automation_identity - execution_context incident_variant - incident_case incident_origin - incident_case)
  (:predicates
    (approver_available ?approver - approver)
    (linked_configuration_change ?incident_case - incident_case ?configuration_change - configuration_change)
    (implementation_in_progress ?incident_case - incident_case)
    (responder_assigned ?incident_case - incident_case ?responder - responder)
    (execution_context_bound ?incident_case - incident_case ?execution_context - execution_context)
    (suppression_rule_available ?suppression_rule - suppression_rule)
    (configuration_change_available ?configuration_change - configuration_change)
    (tag_applicable ?incident_case - incident_case ?tag - tag)
    (incident_resolved ?incident_case - incident_case)
    (auto_close_allowed ?incident_case - incident_case)
    (responder_eligible ?incident_case - incident_case ?responder - responder)
    (runbook_available ?mitigation_runbook - mitigation_runbook)
    (rollback_plan_available ?rollback_plan - rollback_plan)
    (alert_signature_available ?alert_signature - alert_signature)
    (runbook_scheduled ?incident_case - incident_case)
    (configuration_change_applicable ?incident_case - incident_case ?configuration_change - configuration_change)
    (linked_tag ?incident_case - incident_case ?tag - tag)
    (linked_mitigation_runbook ?incident_case - incident_case ?mitigation_runbook - mitigation_runbook)
    (change_prepared ?incident_case - incident_case)
    (suppression_rule_applicable ?incident_case - incident_case ?suppression_rule - suppression_rule)
    (tag_available ?tag - tag)
    (origin_verified ?incident_case - incident_case)
    (remediation_ready ?incident_case - incident_case)
    (alert_rule_applicable ?incident_case - incident_case ?alert_rule - alert_rule)
    (linked_alert_rule ?incident_case - incident_case ?alert_rule - alert_rule)
    (change_requested ?incident_case - incident_case)
    (signature_bound_to_incident ?incident_case - incident_case ?alert_signature - alert_signature)
    (implementation_observed ?incident_case - incident_case)
    (rollback_applicable ?incident_case - incident_case ?rollback_plan - rollback_plan)
    (incident_open ?incident_case - incident_case)
    (responder_available ?responder - responder)
    (incident_has_owner ?incident_case - incident_case)
    (playbook_available ?automation_playbook - automation_playbook)
    (change_ticket_available ?change_ticket - change_ticket)
    (linked_suppression_rule ?incident_case - incident_case ?suppression_rule - suppression_rule)
    (change_ticket_bound ?incident_case - incident_case ?change_ticket - change_ticket)
    (signature_escalated ?incident_case - incident_case)
    (incident_ticket_pending ?incident_case - incident_case)
    (ticket_applicable_to_incident ?incident_case - incident_case ?change_ticket - change_ticket)
    (alert_rule_available ?alert_rule - alert_rule)
    (origin_ticket_link ?incident_case - incident_case ?change_ticket - change_ticket)
    (runbook_applicable ?incident_case - incident_case ?mitigation_runbook - mitigation_runbook)
    (awaiting_approval ?incident_case - incident_case)
    (ticket_scheduled ?incident_case - incident_case ?change_ticket - change_ticket)
  )
  (:action unlink_tag_from_incident
    :parameters (?incident_case - incident_case ?tag - tag)
    :precondition
      (and
        (linked_tag ?incident_case ?tag)
      )
    :effect
      (and
        (tag_available ?tag)
        (not
          (linked_tag ?incident_case ?tag)
        )
      )
  )
  (:action record_change_approval_with_automation_identity
    :parameters (?incident_case - incident_case ?suppression_rule - suppression_rule ?tag - tag ?automation_identity - automation_identity)
    :precondition
      (and
        (not
          (change_prepared ?incident_case)
        )
        (runbook_scheduled ?incident_case)
        (remediation_ready ?incident_case)
        (linked_tag ?incident_case ?tag)
        (execution_context_bound ?incident_case ?automation_identity)
        (linked_suppression_rule ?incident_case ?suppression_rule)
      )
    :effect
      (and
        (awaiting_approval ?incident_case)
        (change_prepared ?incident_case)
      )
  )
  (:action close_incident_standard
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (remediation_ready ?incident_case)
        (incident_has_owner ?incident_case)
        (runbook_scheduled ?incident_case)
        (incident_open ?incident_case)
        (incident_ticket_pending ?incident_case)
        (not
          (incident_resolved ?incident_case)
        )
        (auto_close_allowed ?incident_case)
        (change_prepared ?incident_case)
      )
    :effect
      (and
        (incident_resolved ?incident_case)
      )
  )
  (:action validate_change_prerequisites
    :parameters (?incident_case - incident_case ?alert_rule - alert_rule ?configuration_change - configuration_change)
    :precondition
      (and
        (runbook_scheduled ?incident_case)
        (change_requested ?incident_case)
        (linked_alert_rule ?incident_case ?alert_rule)
        (linked_configuration_change ?incident_case ?configuration_change)
      )
    :effect
      (and
        (not
          (change_requested ?incident_case)
        )
        (not
          (awaiting_approval ?incident_case)
        )
      )
  )
  (:action bind_alert_signature
    :parameters (?incident_case - incident_case ?alert_signature - alert_signature)
    :precondition
      (and
        (alert_signature_available ?alert_signature)
        (incident_open ?incident_case)
      )
    :effect
      (and
        (not
          (alert_signature_available ?alert_signature)
        )
        (signature_bound_to_incident ?incident_case ?alert_signature)
      )
  )
  (:action record_change_approval
    :parameters (?incident_case - incident_case ?alert_rule - alert_rule ?configuration_change - configuration_change ?human_team - human_team)
    :precondition
      (and
        (execution_context_bound ?incident_case ?human_team)
        (remediation_ready ?incident_case)
        (not
          (awaiting_approval ?incident_case)
        )
        (linked_alert_rule ?incident_case ?alert_rule)
        (runbook_scheduled ?incident_case)
        (linked_configuration_change ?incident_case ?configuration_change)
        (not
          (change_prepared ?incident_case)
        )
      )
    :effect
      (and
        (change_prepared ?incident_case)
      )
  )
  (:action prepare_automation_from_change_ticket
    :parameters (?incident_case - incident_case ?change_ticket - change_ticket)
    :precondition
      (and
        (incident_has_owner ?incident_case)
        (ticket_scheduled ?incident_case ?change_ticket)
        (not
          (remediation_ready ?incident_case)
        )
      )
    :effect
      (and
        (remediation_ready ?incident_case)
        (not
          (awaiting_approval ?incident_case)
        )
      )
  )
  (:action link_suppression_rule_to_incident
    :parameters (?incident_case - incident_case ?suppression_rule - suppression_rule)
    :precondition
      (and
        (suppression_rule_applicable ?incident_case ?suppression_rule)
        (incident_open ?incident_case)
        (suppression_rule_available ?suppression_rule)
      )
    :effect
      (and
        (linked_suppression_rule ?incident_case ?suppression_rule)
        (not
          (suppression_rule_available ?suppression_rule)
        )
      )
  )
  (:action link_alert_rule_to_incident
    :parameters (?incident_case - incident_case ?alert_rule - alert_rule)
    :precondition
      (and
        (incident_open ?incident_case)
        (alert_rule_available ?alert_rule)
        (alert_rule_applicable ?incident_case ?alert_rule)
      )
    :effect
      (and
        (not
          (alert_rule_available ?alert_rule)
        )
        (linked_alert_rule ?incident_case ?alert_rule)
      )
  )
  (:action unlink_suppression_rule_from_incident
    :parameters (?incident_case - incident_case ?suppression_rule - suppression_rule)
    :precondition
      (and
        (linked_suppression_rule ?incident_case ?suppression_rule)
      )
    :effect
      (and
        (suppression_rule_available ?suppression_rule)
        (not
          (linked_suppression_rule ?incident_case ?suppression_rule)
        )
      )
  )
  (:action unlink_configuration_change_from_incident
    :parameters (?incident_case - incident_case ?configuration_change - configuration_change)
    :precondition
      (and
        (linked_configuration_change ?incident_case ?configuration_change)
      )
    :effect
      (and
        (configuration_change_available ?configuration_change)
        (not
          (linked_configuration_change ?incident_case ?configuration_change)
        )
      )
  )
  (:action bind_change_ticket_to_incident
    :parameters (?incident_case - incident_case ?change_ticket - change_ticket)
    :precondition
      (and
        (incident_ticket_pending ?incident_case)
        (change_ticket_available ?change_ticket)
        (ticket_applicable_to_incident ?incident_case ?change_ticket)
      )
    :effect
      (and
        (change_ticket_bound ?incident_case ?change_ticket)
        (not
          (change_ticket_available ?change_ticket)
        )
      )
  )
  (:action link_configuration_change_to_incident
    :parameters (?incident_case - incident_case ?configuration_change - configuration_change)
    :precondition
      (and
        (incident_open ?incident_case)
        (configuration_change_available ?configuration_change)
        (configuration_change_applicable ?incident_case ?configuration_change)
      )
    :effect
      (and
        (linked_configuration_change ?incident_case ?configuration_change)
        (not
          (configuration_change_available ?configuration_change)
        )
      )
  )
  (:action generate_mitigation_plan
    :parameters (?incident_case - incident_case ?mitigation_runbook - mitigation_runbook ?alert_rule - alert_rule ?configuration_change - configuration_change)
    :precondition
      (and
        (incident_has_owner ?incident_case)
        (runbook_available ?mitigation_runbook)
        (runbook_applicable ?incident_case ?mitigation_runbook)
        (not
          (runbook_scheduled ?incident_case)
        )
        (linked_configuration_change ?incident_case ?configuration_change)
        (linked_alert_rule ?incident_case ?alert_rule)
      )
    :effect
      (and
        (linked_mitigation_runbook ?incident_case ?mitigation_runbook)
        (not
          (runbook_available ?mitigation_runbook)
        )
        (runbook_scheduled ?incident_case)
      )
  )
  (:action start_implementation
    :parameters (?incident_case - incident_case ?alert_rule - alert_rule ?configuration_change - configuration_change)
    :precondition
      (and
        (linked_alert_rule ?incident_case ?alert_rule)
        (change_prepared ?incident_case)
        (linked_configuration_change ?incident_case ?configuration_change)
        (awaiting_approval ?incident_case)
      )
    :effect
      (and
        (not
          (change_requested ?incident_case)
        )
        (not
          (awaiting_approval ?incident_case)
        )
        (not
          (remediation_ready ?incident_case)
        )
        (implementation_in_progress ?incident_case)
      )
  )
  (:action unbind_alert_signature
    :parameters (?incident_case - incident_case ?alert_signature - alert_signature)
    :precondition
      (and
        (signature_bound_to_incident ?incident_case ?alert_signature)
      )
    :effect
      (and
        (alert_signature_available ?alert_signature)
        (not
          (signature_bound_to_incident ?incident_case ?alert_signature)
        )
      )
  )
  (:action prepare_automation_playbook
    :parameters (?incident_case - incident_case ?alert_signature - alert_signature ?automation_playbook - automation_playbook)
    :precondition
      (and
        (not
          (remediation_ready ?incident_case)
        )
        (incident_has_owner ?incident_case)
        (playbook_available ?automation_playbook)
        (signature_bound_to_incident ?incident_case ?alert_signature)
        (signature_escalated ?incident_case)
      )
    :effect
      (and
        (not
          (awaiting_approval ?incident_case)
        )
        (remediation_ready ?incident_case)
      )
  )
  (:action close_incident_post_execution
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (incident_open ?incident_case)
        (origin_verified ?incident_case)
        (implementation_observed ?incident_case)
        (incident_has_owner ?incident_case)
        (remediation_ready ?incident_case)
        (not
          (incident_resolved ?incident_case)
        )
        (incident_ticket_pending ?incident_case)
        (runbook_scheduled ?incident_case)
        (change_prepared ?incident_case)
      )
    :effect
      (and
        (incident_resolved ?incident_case)
      )
  )
  (:action record_execution_observation
    :parameters (?incident_case - incident_case ?alert_signature - alert_signature ?automation_playbook - automation_playbook)
    :precondition
      (and
        (remediation_ready ?incident_case)
        (playbook_available ?automation_playbook)
        (not
          (implementation_observed ?incident_case)
        )
        (incident_ticket_pending ?incident_case)
        (incident_open ?incident_case)
        (origin_verified ?incident_case)
        (signature_bound_to_incident ?incident_case ?alert_signature)
      )
    :effect
      (and
        (implementation_observed ?incident_case)
      )
  )
  (:action unlink_alert_rule_from_incident
    :parameters (?incident_case - incident_case ?alert_rule - alert_rule)
    :precondition
      (and
        (linked_alert_rule ?incident_case ?alert_rule)
      )
    :effect
      (and
        (alert_rule_available ?alert_rule)
        (not
          (linked_alert_rule ?incident_case ?alert_rule)
        )
      )
  )
  (:action link_tag_to_incident
    :parameters (?incident_case - incident_case ?tag - tag)
    :precondition
      (and
        (tag_available ?tag)
        (incident_open ?incident_case)
        (tag_applicable ?incident_case ?tag)
      )
    :effect
      (and
        (linked_tag ?incident_case ?tag)
        (not
          (tag_available ?tag)
        )
      )
  )
  (:action open_incident_case
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (not
          (incident_open ?incident_case)
        )
        (not
          (incident_resolved ?incident_case)
        )
      )
    :effect
      (and
        (incident_open ?incident_case)
      )
  )
  (:action escalate_to_approver
    :parameters (?incident_case - incident_case ?approver - approver)
    :precondition
      (and
        (not
          (signature_escalated ?incident_case)
        )
        (incident_open ?incident_case)
        (approver_available ?approver)
        (incident_has_owner ?incident_case)
      )
    :effect
      (and
        (awaiting_approval ?incident_case)
        (not
          (approver_available ?approver)
        )
        (signature_escalated ?incident_case)
      )
  )
  (:action generate_mitigation_with_rollback
    :parameters (?incident_case - incident_case ?mitigation_runbook - mitigation_runbook ?suppression_rule - suppression_rule ?rollback_plan - rollback_plan)
    :precondition
      (and
        (rollback_plan_available ?rollback_plan)
        (rollback_applicable ?incident_case ?rollback_plan)
        (not
          (runbook_scheduled ?incident_case)
        )
        (incident_has_owner ?incident_case)
        (runbook_available ?mitigation_runbook)
        (runbook_applicable ?incident_case ?mitigation_runbook)
        (linked_suppression_rule ?incident_case ?suppression_rule)
      )
    :effect
      (and
        (linked_mitigation_runbook ?incident_case ?mitigation_runbook)
        (not
          (rollback_plan_available ?rollback_plan)
        )
        (change_requested ?incident_case)
        (not
          (runbook_available ?mitigation_runbook)
        )
        (awaiting_approval ?incident_case)
        (runbook_scheduled ?incident_case)
      )
  )
  (:action mark_ticket_pending_with_approver
    :parameters (?incident_case - incident_case ?approver - approver)
    :precondition
      (and
        (approver_available ?approver)
        (not
          (awaiting_approval ?incident_case)
        )
        (remediation_ready ?incident_case)
        (change_prepared ?incident_case)
        (not
          (incident_ticket_pending ?incident_case)
        )
      )
    :effect
      (and
        (incident_ticket_pending ?incident_case)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action unassign_responder
    :parameters (?incident_case - incident_case ?responder - responder)
    :precondition
      (and
        (responder_assigned ?incident_case ?responder)
        (not
          (change_prepared ?incident_case)
        )
        (not
          (runbook_scheduled ?incident_case)
        )
      )
    :effect
      (and
        (not
          (responder_assigned ?incident_case ?responder)
        )
        (responder_available ?responder)
        (not
          (incident_has_owner ?incident_case)
        )
        (not
          (signature_escalated ?incident_case)
        )
        (not
          (implementation_in_progress ?incident_case)
        )
        (not
          (remediation_ready ?incident_case)
        )
        (not
          (change_requested ?incident_case)
        )
        (not
          (awaiting_approval ?incident_case)
        )
      )
  )
  (:action mark_ticket_pending
    :parameters (?incident_case - incident_case ?alert_signature - alert_signature)
    :precondition
      (and
        (not
          (incident_ticket_pending ?incident_case)
        )
        (signature_bound_to_incident ?incident_case ?alert_signature)
        (remediation_ready ?incident_case)
        (change_prepared ?incident_case)
        (not
          (awaiting_approval ?incident_case)
        )
      )
    :effect
      (and
        (incident_ticket_pending ?incident_case)
      )
  )
  (:action close_incident_with_ticket
    :parameters (?incident_case - incident_case ?change_ticket - change_ticket)
    :precondition
      (and
        (incident_ticket_pending ?incident_case)
        (change_prepared ?incident_case)
        (runbook_scheduled ?incident_case)
        (ticket_scheduled ?incident_case ?change_ticket)
        (remediation_ready ?incident_case)
        (incident_has_owner ?incident_case)
        (incident_open ?incident_case)
        (not
          (incident_resolved ?incident_case)
        )
        (origin_verified ?incident_case)
      )
    :effect
      (and
        (incident_resolved ?incident_case)
      )
  )
  (:action escalate_signature
    :parameters (?incident_case - incident_case ?alert_signature - alert_signature)
    :precondition
      (and
        (incident_open ?incident_case)
        (incident_has_owner ?incident_case)
        (not
          (signature_escalated ?incident_case)
        )
        (signature_bound_to_incident ?incident_case ?alert_signature)
      )
    :effect
      (and
        (signature_escalated ?incident_case)
      )
  )
  (:action assign_responder
    :parameters (?incident_case - incident_case ?responder - responder)
    :precondition
      (and
        (not
          (incident_has_owner ?incident_case)
        )
        (incident_open ?incident_case)
        (responder_available ?responder)
        (responder_eligible ?incident_case ?responder)
      )
    :effect
      (and
        (incident_has_owner ?incident_case)
        (not
          (responder_available ?responder)
        )
        (responder_assigned ?incident_case ?responder)
      )
  )
  (:action execute_automation_playbook
    :parameters (?incident_case - incident_case ?alert_signature - alert_signature ?automation_playbook - automation_playbook)
    :precondition
      (and
        (incident_has_owner ?incident_case)
        (not
          (remediation_ready ?incident_case)
        )
        (signature_bound_to_incident ?incident_case ?alert_signature)
        (change_prepared ?incident_case)
        (playbook_available ?automation_playbook)
        (implementation_in_progress ?incident_case)
      )
    :effect
      (and
        (remediation_ready ?incident_case)
      )
  )
  (:action schedule_change_ticket
    :parameters (?incident_origin - incident_origin ?incident_variant - incident_variant ?change_ticket - change_ticket)
    :precondition
      (and
        (incident_open ?incident_origin)
        (change_ticket_bound ?incident_variant ?change_ticket)
        (origin_verified ?incident_origin)
        (not
          (ticket_scheduled ?incident_origin ?change_ticket)
        )
        (origin_ticket_link ?incident_origin ?change_ticket)
      )
    :effect
      (and
        (ticket_scheduled ?incident_origin ?change_ticket)
      )
  )
)

(define (domain suspense_account_clearance_routing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types reconciliation_case - object ledger_account - object clearance_instruction - object source_system - object remediation_activity - object escalation_option - object suspense_bucket - object communication_reference - object supporting_document - object authorized_verifier - object audit_ticket - object exception_reason_code - object organizational_unit - object resolver_unit - organizational_unit approver_unit - organizational_unit client_initiated_case - reconciliation_case system_initiated_case - reconciliation_case)
  (:predicates
    (case_registered ?reconciliation_case - reconciliation_case)
    (case_linked_ledger_account ?reconciliation_case - reconciliation_case ?ledger_account - ledger_account)
    (case_account_claimed ?reconciliation_case - reconciliation_case)
    (case_initial_validation_passed ?reconciliation_case - reconciliation_case)
    (case_evidence_verified ?reconciliation_case - reconciliation_case)
    (case_assigned_remediation ?reconciliation_case - reconciliation_case ?remediation_activity - remediation_activity)
    (case_assigned_source_system ?reconciliation_case - reconciliation_case ?source_system - source_system)
    (case_assigned_escalation_option ?reconciliation_case - reconciliation_case ?escalation_option - escalation_option)
    (case_assigned_exception_code ?reconciliation_case - reconciliation_case ?exception_reason_code - exception_reason_code)
    (case_applied_clearance_instruction ?reconciliation_case - reconciliation_case ?clearance_instruction - clearance_instruction)
    (case_clearance_executed_flag ?reconciliation_case - reconciliation_case)
    (case_approval_recorded ?reconciliation_case - reconciliation_case)
    (case_has_supporting_evidence ?reconciliation_case - reconciliation_case)
    (case_closed ?reconciliation_case - reconciliation_case)
    (case_requires_approval ?reconciliation_case - reconciliation_case)
    (case_resolution_committed ?reconciliation_case - reconciliation_case)
    (case_document_association_candidate ?reconciliation_case - reconciliation_case ?supporting_document - supporting_document)
    (case_supporting_document_linked ?reconciliation_case - reconciliation_case ?supporting_document - supporting_document)
    (case_documentation_confirmed ?reconciliation_case - reconciliation_case)
    (ledger_account_available ?ledger_account - ledger_account)
    (clearance_instruction_available ?clearance_instruction - clearance_instruction)
    (remediation_activity_available ?remediation_activity - remediation_activity)
    (source_system_available ?source_system - source_system)
    (escalation_option_available ?escalation_option - escalation_option)
    (suspense_bucket_available ?suspense_bucket - suspense_bucket)
    (communication_reference_available ?communication_reference - communication_reference)
    (supporting_document_available ?supporting_document - supporting_document)
    (authorized_verifier_available ?authorized_verifier - authorized_verifier)
    (audit_ticket_available ?audit_ticket - audit_ticket)
    (exception_reason_code_available ?exception_reason_code - exception_reason_code)
    (case_account_candidate ?reconciliation_case - reconciliation_case ?ledger_account - ledger_account)
    (case_instruction_candidate ?reconciliation_case - reconciliation_case ?clearance_instruction - clearance_instruction)
    (case_remediation_candidate ?reconciliation_case - reconciliation_case ?remediation_activity - remediation_activity)
    (case_source_candidate ?reconciliation_case - reconciliation_case ?source_system - source_system)
    (case_escalation_candidate ?reconciliation_case - reconciliation_case ?escalation_option - escalation_option)
    (case_audit_ticket_candidate ?reconciliation_case - reconciliation_case ?audit_ticket - audit_ticket)
    (case_exception_code_candidate ?reconciliation_case - reconciliation_case ?exception_reason_code - exception_reason_code)
    (case_organizational_unit_candidate ?reconciliation_case - reconciliation_case ?organizational_unit - organizational_unit)
    (case_supporting_document_candidate ?reconciliation_case - reconciliation_case ?supporting_document - supporting_document)
    (case_client_origin ?reconciliation_case - reconciliation_case)
    (case_system_origin ?reconciliation_case - reconciliation_case)
    (case_assigned_suspense_bucket ?reconciliation_case - reconciliation_case ?suspense_bucket - suspense_bucket)
    (case_requires_followup ?reconciliation_case - reconciliation_case)
    (case_document_reference ?reconciliation_case - reconciliation_case ?supporting_document - supporting_document)
  )
  (:action open_case
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (not
          (case_registered ?reconciliation_case)
        )
        (not
          (case_closed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_registered ?reconciliation_case)
      )
  )
  (:action assign_ledger_account_to_case
    :parameters (?reconciliation_case - reconciliation_case ?ledger_account - ledger_account)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (ledger_account_available ?ledger_account)
        (case_account_candidate ?reconciliation_case ?ledger_account)
        (not
          (case_account_claimed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_linked_ledger_account ?reconciliation_case ?ledger_account)
        (case_account_claimed ?reconciliation_case)
        (not
          (ledger_account_available ?ledger_account)
        )
      )
  )
  (:action unassign_ledger_account_from_case
    :parameters (?reconciliation_case - reconciliation_case ?ledger_account - ledger_account)
    :precondition
      (and
        (case_linked_ledger_account ?reconciliation_case ?ledger_account)
        (not
          (case_clearance_executed_flag ?reconciliation_case)
        )
        (not
          (case_approval_recorded ?reconciliation_case)
        )
      )
    :effect
      (and
        (not
          (case_linked_ledger_account ?reconciliation_case ?ledger_account)
        )
        (not
          (case_account_claimed ?reconciliation_case)
        )
        (not
          (case_initial_validation_passed ?reconciliation_case)
        )
        (not
          (case_evidence_verified ?reconciliation_case)
        )
        (not
          (case_requires_approval ?reconciliation_case)
        )
        (not
          (case_resolution_committed ?reconciliation_case)
        )
        (not
          (case_requires_followup ?reconciliation_case)
        )
        (ledger_account_available ?ledger_account)
      )
  )
  (:action assign_case_to_suspense_bucket
    :parameters (?reconciliation_case - reconciliation_case ?suspense_bucket - suspense_bucket)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (suspense_bucket_available ?suspense_bucket)
      )
    :effect
      (and
        (case_assigned_suspense_bucket ?reconciliation_case ?suspense_bucket)
        (not
          (suspense_bucket_available ?suspense_bucket)
        )
      )
  )
  (:action release_case_from_suspense_bucket
    :parameters (?reconciliation_case - reconciliation_case ?suspense_bucket - suspense_bucket)
    :precondition
      (and
        (case_assigned_suspense_bucket ?reconciliation_case ?suspense_bucket)
      )
    :effect
      (and
        (suspense_bucket_available ?suspense_bucket)
        (not
          (case_assigned_suspense_bucket ?reconciliation_case ?suspense_bucket)
        )
      )
  )
  (:action confirm_initial_validation
    :parameters (?reconciliation_case - reconciliation_case ?suspense_bucket - suspense_bucket)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (case_account_claimed ?reconciliation_case)
        (case_assigned_suspense_bucket ?reconciliation_case ?suspense_bucket)
        (not
          (case_initial_validation_passed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_initial_validation_passed ?reconciliation_case)
      )
  )
  (:action record_communication_verification
    :parameters (?reconciliation_case - reconciliation_case ?communication_reference - communication_reference)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (case_account_claimed ?reconciliation_case)
        (communication_reference_available ?communication_reference)
        (not
          (case_initial_validation_passed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_initial_validation_passed ?reconciliation_case)
        (case_requires_approval ?reconciliation_case)
        (not
          (communication_reference_available ?communication_reference)
        )
      )
  )
  (:action verify_evidence_by_authorized_verifier
    :parameters (?reconciliation_case - reconciliation_case ?suspense_bucket - suspense_bucket ?authorized_verifier - authorized_verifier)
    :precondition
      (and
        (case_initial_validation_passed ?reconciliation_case)
        (case_account_claimed ?reconciliation_case)
        (case_assigned_suspense_bucket ?reconciliation_case ?suspense_bucket)
        (authorized_verifier_available ?authorized_verifier)
        (not
          (case_evidence_verified ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_evidence_verified ?reconciliation_case)
        (not
          (case_requires_approval ?reconciliation_case)
        )
      )
  )
  (:action verify_evidence_with_document
    :parameters (?reconciliation_case - reconciliation_case ?supporting_document - supporting_document)
    :precondition
      (and
        (case_account_claimed ?reconciliation_case)
        (case_supporting_document_linked ?reconciliation_case ?supporting_document)
        (not
          (case_evidence_verified ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_evidence_verified ?reconciliation_case)
        (not
          (case_requires_approval ?reconciliation_case)
        )
      )
  )
  (:action assign_remediation_activity_to_case
    :parameters (?reconciliation_case - reconciliation_case ?remediation_activity - remediation_activity)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (remediation_activity_available ?remediation_activity)
        (case_remediation_candidate ?reconciliation_case ?remediation_activity)
      )
    :effect
      (and
        (case_assigned_remediation ?reconciliation_case ?remediation_activity)
        (not
          (remediation_activity_available ?remediation_activity)
        )
      )
  )
  (:action release_remediation_activity_from_case
    :parameters (?reconciliation_case - reconciliation_case ?remediation_activity - remediation_activity)
    :precondition
      (and
        (case_assigned_remediation ?reconciliation_case ?remediation_activity)
      )
    :effect
      (and
        (remediation_activity_available ?remediation_activity)
        (not
          (case_assigned_remediation ?reconciliation_case ?remediation_activity)
        )
      )
  )
  (:action assign_source_system_to_case
    :parameters (?reconciliation_case - reconciliation_case ?source_system - source_system)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (source_system_available ?source_system)
        (case_source_candidate ?reconciliation_case ?source_system)
      )
    :effect
      (and
        (case_assigned_source_system ?reconciliation_case ?source_system)
        (not
          (source_system_available ?source_system)
        )
      )
  )
  (:action release_source_system_from_case
    :parameters (?reconciliation_case - reconciliation_case ?source_system - source_system)
    :precondition
      (and
        (case_assigned_source_system ?reconciliation_case ?source_system)
      )
    :effect
      (and
        (source_system_available ?source_system)
        (not
          (case_assigned_source_system ?reconciliation_case ?source_system)
        )
      )
  )
  (:action assign_escalation_option_to_case
    :parameters (?reconciliation_case - reconciliation_case ?escalation_option - escalation_option)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (escalation_option_available ?escalation_option)
        (case_escalation_candidate ?reconciliation_case ?escalation_option)
      )
    :effect
      (and
        (case_assigned_escalation_option ?reconciliation_case ?escalation_option)
        (not
          (escalation_option_available ?escalation_option)
        )
      )
  )
  (:action release_escalation_option_from_case
    :parameters (?reconciliation_case - reconciliation_case ?escalation_option - escalation_option)
    :precondition
      (and
        (case_assigned_escalation_option ?reconciliation_case ?escalation_option)
      )
    :effect
      (and
        (escalation_option_available ?escalation_option)
        (not
          (case_assigned_escalation_option ?reconciliation_case ?escalation_option)
        )
      )
  )
  (:action assign_exception_reason_to_case
    :parameters (?reconciliation_case - reconciliation_case ?exception_reason_code - exception_reason_code)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (exception_reason_code_available ?exception_reason_code)
        (case_exception_code_candidate ?reconciliation_case ?exception_reason_code)
      )
    :effect
      (and
        (case_assigned_exception_code ?reconciliation_case ?exception_reason_code)
        (not
          (exception_reason_code_available ?exception_reason_code)
        )
      )
  )
  (:action release_exception_reason_from_case
    :parameters (?reconciliation_case - reconciliation_case ?exception_reason_code - exception_reason_code)
    :precondition
      (and
        (case_assigned_exception_code ?reconciliation_case ?exception_reason_code)
      )
    :effect
      (and
        (exception_reason_code_available ?exception_reason_code)
        (not
          (case_assigned_exception_code ?reconciliation_case ?exception_reason_code)
        )
      )
  )
  (:action apply_clearance_instruction
    :parameters (?reconciliation_case - reconciliation_case ?clearance_instruction - clearance_instruction ?remediation_activity - remediation_activity ?source_system - source_system)
    :precondition
      (and
        (case_account_claimed ?reconciliation_case)
        (case_assigned_remediation ?reconciliation_case ?remediation_activity)
        (case_assigned_source_system ?reconciliation_case ?source_system)
        (clearance_instruction_available ?clearance_instruction)
        (case_instruction_candidate ?reconciliation_case ?clearance_instruction)
        (not
          (case_clearance_executed_flag ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_applied_clearance_instruction ?reconciliation_case ?clearance_instruction)
        (case_clearance_executed_flag ?reconciliation_case)
        (not
          (clearance_instruction_available ?clearance_instruction)
        )
      )
  )
  (:action execute_clearance_with_escalation_and_audit_ticket
    :parameters (?reconciliation_case - reconciliation_case ?clearance_instruction - clearance_instruction ?escalation_option - escalation_option ?audit_ticket - audit_ticket)
    :precondition
      (and
        (case_account_claimed ?reconciliation_case)
        (case_assigned_escalation_option ?reconciliation_case ?escalation_option)
        (audit_ticket_available ?audit_ticket)
        (clearance_instruction_available ?clearance_instruction)
        (case_instruction_candidate ?reconciliation_case ?clearance_instruction)
        (case_audit_ticket_candidate ?reconciliation_case ?audit_ticket)
        (not
          (case_clearance_executed_flag ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_applied_clearance_instruction ?reconciliation_case ?clearance_instruction)
        (case_clearance_executed_flag ?reconciliation_case)
        (case_requires_followup ?reconciliation_case)
        (case_requires_approval ?reconciliation_case)
        (not
          (clearance_instruction_available ?clearance_instruction)
        )
        (not
          (audit_ticket_available ?audit_ticket)
        )
      )
  )
  (:action finalize_posting_and_release_followup
    :parameters (?reconciliation_case - reconciliation_case ?remediation_activity - remediation_activity ?source_system - source_system)
    :precondition
      (and
        (case_clearance_executed_flag ?reconciliation_case)
        (case_requires_followup ?reconciliation_case)
        (case_assigned_remediation ?reconciliation_case ?remediation_activity)
        (case_assigned_source_system ?reconciliation_case ?source_system)
      )
    :effect
      (and
        (not
          (case_requires_followup ?reconciliation_case)
        )
        (not
          (case_requires_approval ?reconciliation_case)
        )
      )
  )
  (:action record_approval
    :parameters (?reconciliation_case - reconciliation_case ?remediation_activity - remediation_activity ?source_system - source_system ?resolver_unit - resolver_unit)
    :precondition
      (and
        (case_evidence_verified ?reconciliation_case)
        (case_clearance_executed_flag ?reconciliation_case)
        (case_assigned_remediation ?reconciliation_case ?remediation_activity)
        (case_assigned_source_system ?reconciliation_case ?source_system)
        (case_organizational_unit_candidate ?reconciliation_case ?resolver_unit)
        (not
          (case_requires_approval ?reconciliation_case)
        )
        (not
          (case_approval_recorded ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_approval_recorded ?reconciliation_case)
      )
  )
  (:action record_escalated_approval
    :parameters (?reconciliation_case - reconciliation_case ?escalation_option - escalation_option ?exception_reason_code - exception_reason_code ?approver_unit - approver_unit)
    :precondition
      (and
        (case_evidence_verified ?reconciliation_case)
        (case_clearance_executed_flag ?reconciliation_case)
        (case_assigned_escalation_option ?reconciliation_case ?escalation_option)
        (case_assigned_exception_code ?reconciliation_case ?exception_reason_code)
        (case_organizational_unit_candidate ?reconciliation_case ?approver_unit)
        (not
          (case_approval_recorded ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_approval_recorded ?reconciliation_case)
        (case_requires_approval ?reconciliation_case)
      )
  )
  (:action commit_resolution_and_clear_flags
    :parameters (?reconciliation_case - reconciliation_case ?remediation_activity - remediation_activity ?source_system - source_system)
    :precondition
      (and
        (case_approval_recorded ?reconciliation_case)
        (case_requires_approval ?reconciliation_case)
        (case_assigned_remediation ?reconciliation_case ?remediation_activity)
        (case_assigned_source_system ?reconciliation_case ?source_system)
      )
    :effect
      (and
        (case_resolution_committed ?reconciliation_case)
        (not
          (case_requires_approval ?reconciliation_case)
        )
        (not
          (case_evidence_verified ?reconciliation_case)
        )
        (not
          (case_requires_followup ?reconciliation_case)
        )
      )
  )
  (:action reverify_after_commit
    :parameters (?reconciliation_case - reconciliation_case ?suspense_bucket - suspense_bucket ?authorized_verifier - authorized_verifier)
    :precondition
      (and
        (case_resolution_committed ?reconciliation_case)
        (case_approval_recorded ?reconciliation_case)
        (case_account_claimed ?reconciliation_case)
        (case_assigned_suspense_bucket ?reconciliation_case ?suspense_bucket)
        (authorized_verifier_available ?authorized_verifier)
        (not
          (case_evidence_verified ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_evidence_verified ?reconciliation_case)
      )
  )
  (:action flag_supporting_document_required
    :parameters (?reconciliation_case - reconciliation_case ?suspense_bucket - suspense_bucket)
    :precondition
      (and
        (case_approval_recorded ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (not
          (case_requires_approval ?reconciliation_case)
        )
        (case_assigned_suspense_bucket ?reconciliation_case ?suspense_bucket)
        (not
          (case_has_supporting_evidence ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_has_supporting_evidence ?reconciliation_case)
      )
  )
  (:action link_communication_reference
    :parameters (?reconciliation_case - reconciliation_case ?communication_reference - communication_reference)
    :precondition
      (and
        (case_approval_recorded ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (not
          (case_requires_approval ?reconciliation_case)
        )
        (communication_reference_available ?communication_reference)
        (not
          (case_has_supporting_evidence ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_has_supporting_evidence ?reconciliation_case)
        (not
          (communication_reference_available ?communication_reference)
        )
      )
  )
  (:action assign_supporting_document_to_case
    :parameters (?reconciliation_case - reconciliation_case ?supporting_document - supporting_document)
    :precondition
      (and
        (case_has_supporting_evidence ?reconciliation_case)
        (supporting_document_available ?supporting_document)
        (case_document_reference ?reconciliation_case ?supporting_document)
      )
    :effect
      (and
        (case_supporting_document_candidate ?reconciliation_case ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action link_supporting_document_across_cases
    :parameters (?system_initiated_case - system_initiated_case ?client_initiated_case - client_initiated_case ?supporting_document - supporting_document)
    :precondition
      (and
        (case_registered ?system_initiated_case)
        (case_system_origin ?system_initiated_case)
        (case_document_association_candidate ?system_initiated_case ?supporting_document)
        (case_supporting_document_candidate ?client_initiated_case ?supporting_document)
        (not
          (case_supporting_document_linked ?system_initiated_case ?supporting_document)
        )
      )
    :effect
      (and
        (case_supporting_document_linked ?system_initiated_case ?supporting_document)
      )
  )
  (:action synchronize_supporting_documents_between_cases
    :parameters (?reconciliation_case - reconciliation_case ?suspense_bucket - suspense_bucket ?authorized_verifier - authorized_verifier)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (case_system_origin ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (case_has_supporting_evidence ?reconciliation_case)
        (case_assigned_suspense_bucket ?reconciliation_case ?suspense_bucket)
        (authorized_verifier_available ?authorized_verifier)
        (not
          (case_documentation_confirmed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_documentation_confirmed ?reconciliation_case)
      )
  )
  (:action close_case_with_standard_checks
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_client_origin ?reconciliation_case)
        (case_registered ?reconciliation_case)
        (case_account_claimed ?reconciliation_case)
        (case_clearance_executed_flag ?reconciliation_case)
        (case_approval_recorded ?reconciliation_case)
        (case_has_supporting_evidence ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action close_case_after_documented_clearance
    :parameters (?reconciliation_case - reconciliation_case ?clearance_instruction - supporting_document)
    :precondition
      (and
        (case_system_origin ?reconciliation_case)
        (case_registered ?reconciliation_case)
        (case_account_claimed ?reconciliation_case)
        (case_clearance_executed_flag ?reconciliation_case)
        (case_approval_recorded ?reconciliation_case)
        (case_has_supporting_evidence ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (case_supporting_document_linked ?reconciliation_case ?clearance_instruction)
        (not
          (case_closed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action close_case_after_evidence_synchronization
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_system_origin ?reconciliation_case)
        (case_registered ?reconciliation_case)
        (case_account_claimed ?reconciliation_case)
        (case_clearance_executed_flag ?reconciliation_case)
        (case_approval_recorded ?reconciliation_case)
        (case_has_supporting_evidence ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (case_documentation_confirmed ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
)

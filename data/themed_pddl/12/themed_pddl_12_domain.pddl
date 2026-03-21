(define (domain finance_reconciliation_failed_settlement_repair_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types repair_ticket - object reconciliation_analyst - object reconciliation_scope - object counterparty_account - object general_ledger_account - object payment_instrument - object system_reference - object counterparty_response - object settlement_batch - object supporting_document - object escalation_case - object proposed_correction - object aux_object - object business_unit - aux_object escalation_owner - aux_object client_initiated_ticket - repair_ticket system_generated_ticket - repair_ticket)
  (:predicates
    (counterparty_response_available ?counterparty_response - counterparty_response)
    (ticket_linked_counterparty_account ?repair_ticket - repair_ticket ?counterparty_account - counterparty_account)
    (ticket_approval_granted ?repair_ticket - repair_ticket)
    (ticket_assigned_to_analyst ?repair_ticket - repair_ticket ?reconciliation_analyst - reconciliation_analyst)
    (ticket_tagged_with ?repair_ticket - repair_ticket ?aux_object - aux_object)
    (payment_instrument_available ?payment_instrument - payment_instrument)
    (counterparty_account_available ?counterparty_account - counterparty_account)
    (ticket_can_link_proposed_correction ?repair_ticket - repair_ticket ?proposed_correction - proposed_correction)
    (ticket_closed ?repair_ticket - repair_ticket)
    (ticket_precheck_flag ?repair_ticket - repair_ticket)
    (ticket_candidate_analyst ?repair_ticket - repair_ticket ?reconciliation_analyst - reconciliation_analyst)
    (reconciliation_scope_available ?reconciliation_scope - reconciliation_scope)
    (escalation_case_open ?escalation_case - escalation_case)
    (system_reference_available ?system_reference - system_reference)
    (ticket_validation_passed_flag ?repair_ticket - repair_ticket)
    (ticket_can_link_counterparty_account ?repair_ticket - repair_ticket ?counterparty_account - counterparty_account)
    (ticket_linked_proposed_correction ?repair_ticket - repair_ticket ?proposed_correction - proposed_correction)
    (ticket_validated_against_scope ?repair_ticket - repair_ticket ?reconciliation_scope - reconciliation_scope)
    (ticket_approval_requested ?repair_ticket - repair_ticket)
    (ticket_can_link_payment_instrument ?repair_ticket - repair_ticket ?payment_instrument - payment_instrument)
    (proposed_correction_available ?proposed_correction - proposed_correction)
    (ticket_system_origin_flag ?repair_ticket - repair_ticket)
    (ticket_ready_for_proposal ?repair_ticket - repair_ticket)
    (ticket_can_link_general_ledger_account ?repair_ticket - repair_ticket ?general_ledger_account - general_ledger_account)
    (ticket_linked_general_ledger_account ?repair_ticket - repair_ticket ?general_ledger_account - general_ledger_account)
    (ticket_requires_additional_evidence ?repair_ticket - repair_ticket)
    (ticket_linked_system_reference ?repair_ticket - repair_ticket ?system_reference - system_reference)
    (ticket_evidence_indexed ?repair_ticket - repair_ticket)
    (ticket_linked_escalation_case ?repair_ticket - repair_ticket ?escalation_case - escalation_case)
    (ticket_registered ?repair_ticket - repair_ticket)
    (analyst_available ?reconciliation_analyst - reconciliation_analyst)
    (ticket_assignment_flag ?repair_ticket - repair_ticket)
    (supporting_document_available ?supporting_document - supporting_document)
    (settlement_batch_available ?settlement_batch - settlement_batch)
    (ticket_linked_payment_instrument ?repair_ticket - repair_ticket ?payment_instrument - payment_instrument)
    (ticket_linked_settlement_batch ?repair_ticket - repair_ticket ?settlement_batch - settlement_batch)
    (ticket_validated_by_reference ?repair_ticket - repair_ticket)
    (ticket_supporting_document_attached_flag ?repair_ticket - repair_ticket)
    (ticket_batch_candidate_reference ?repair_ticket - repair_ticket ?settlement_batch - settlement_batch)
    (general_ledger_account_available ?general_ledger_account - general_ledger_account)
    (ticket_batch_link_candidate ?repair_ticket - repair_ticket ?settlement_batch - settlement_batch)
    (ticket_scope_link ?repair_ticket - repair_ticket ?reconciliation_scope - reconciliation_scope)
    (ticket_escalated_flag ?repair_ticket - repair_ticket)
    (ticket_batch_link_confirmed ?repair_ticket - repair_ticket ?settlement_batch - settlement_batch)
  )
  (:action unlink_proposed_correction_from_ticket
    :parameters (?repair_ticket - repair_ticket ?proposed_correction - proposed_correction)
    :precondition
      (and
        (ticket_linked_proposed_correction ?repair_ticket ?proposed_correction)
      )
    :effect
      (and
        (proposed_correction_available ?proposed_correction)
        (not
          (ticket_linked_proposed_correction ?repair_ticket ?proposed_correction)
        )
      )
  )
  (:action request_approval_and_escalate
    :parameters (?repair_ticket - repair_ticket ?payment_instrument - payment_instrument ?proposed_correction - proposed_correction ?escalation_owner - escalation_owner)
    :precondition
      (and
        (not
          (ticket_approval_requested ?repair_ticket)
        )
        (ticket_validation_passed_flag ?repair_ticket)
        (ticket_ready_for_proposal ?repair_ticket)
        (ticket_linked_proposed_correction ?repair_ticket ?proposed_correction)
        (ticket_tagged_with ?repair_ticket ?escalation_owner)
        (ticket_linked_payment_instrument ?repair_ticket ?payment_instrument)
      )
    :effect
      (and
        (ticket_escalated_flag ?repair_ticket)
        (ticket_approval_requested ?repair_ticket)
      )
  )
  (:action mark_ticket_precheck_for_closure
    :parameters (?repair_ticket - repair_ticket)
    :precondition
      (and
        (ticket_ready_for_proposal ?repair_ticket)
        (ticket_assignment_flag ?repair_ticket)
        (ticket_validation_passed_flag ?repair_ticket)
        (ticket_registered ?repair_ticket)
        (ticket_supporting_document_attached_flag ?repair_ticket)
        (not
          (ticket_closed ?repair_ticket)
        )
        (ticket_precheck_flag ?repair_ticket)
        (ticket_approval_requested ?repair_ticket)
      )
    :effect
      (and
        (ticket_closed ?repair_ticket)
      )
  )
  (:action clear_additional_evidence_flag
    :parameters (?repair_ticket - repair_ticket ?general_ledger_account - general_ledger_account ?counterparty_account - counterparty_account)
    :precondition
      (and
        (ticket_validation_passed_flag ?repair_ticket)
        (ticket_requires_additional_evidence ?repair_ticket)
        (ticket_linked_general_ledger_account ?repair_ticket ?general_ledger_account)
        (ticket_linked_counterparty_account ?repair_ticket ?counterparty_account)
      )
    :effect
      (and
        (not
          (ticket_requires_additional_evidence ?repair_ticket)
        )
        (not
          (ticket_escalated_flag ?repair_ticket)
        )
      )
  )
  (:action link_system_reference_to_ticket
    :parameters (?repair_ticket - repair_ticket ?system_reference - system_reference)
    :precondition
      (and
        (system_reference_available ?system_reference)
        (ticket_registered ?repair_ticket)
      )
    :effect
      (and
        (not
          (system_reference_available ?system_reference)
        )
        (ticket_linked_system_reference ?repair_ticket ?system_reference)
      )
  )
  (:action request_approval_on_proposal
    :parameters (?repair_ticket - repair_ticket ?general_ledger_account - general_ledger_account ?counterparty_account - counterparty_account ?business_unit - business_unit)
    :precondition
      (and
        (ticket_tagged_with ?repair_ticket ?business_unit)
        (ticket_ready_for_proposal ?repair_ticket)
        (not
          (ticket_escalated_flag ?repair_ticket)
        )
        (ticket_linked_general_ledger_account ?repair_ticket ?general_ledger_account)
        (ticket_validation_passed_flag ?repair_ticket)
        (ticket_linked_counterparty_account ?repair_ticket ?counterparty_account)
        (not
          (ticket_approval_requested ?repair_ticket)
        )
      )
    :effect
      (and
        (ticket_approval_requested ?repair_ticket)
      )
  )
  (:action attach_proposed_correction_via_batch_confirm
    :parameters (?repair_ticket - repair_ticket ?settlement_batch - settlement_batch)
    :precondition
      (and
        (ticket_assignment_flag ?repair_ticket)
        (ticket_batch_link_confirmed ?repair_ticket ?settlement_batch)
        (not
          (ticket_ready_for_proposal ?repair_ticket)
        )
      )
    :effect
      (and
        (ticket_ready_for_proposal ?repair_ticket)
        (not
          (ticket_escalated_flag ?repair_ticket)
        )
      )
  )
  (:action link_payment_instrument_to_ticket
    :parameters (?repair_ticket - repair_ticket ?payment_instrument - payment_instrument)
    :precondition
      (and
        (ticket_can_link_payment_instrument ?repair_ticket ?payment_instrument)
        (ticket_registered ?repair_ticket)
        (payment_instrument_available ?payment_instrument)
      )
    :effect
      (and
        (ticket_linked_payment_instrument ?repair_ticket ?payment_instrument)
        (not
          (payment_instrument_available ?payment_instrument)
        )
      )
  )
  (:action link_general_ledger_account_to_ticket
    :parameters (?repair_ticket - repair_ticket ?general_ledger_account - general_ledger_account)
    :precondition
      (and
        (ticket_registered ?repair_ticket)
        (general_ledger_account_available ?general_ledger_account)
        (ticket_can_link_general_ledger_account ?repair_ticket ?general_ledger_account)
      )
    :effect
      (and
        (not
          (general_ledger_account_available ?general_ledger_account)
        )
        (ticket_linked_general_ledger_account ?repair_ticket ?general_ledger_account)
      )
  )
  (:action unlink_payment_instrument_from_ticket
    :parameters (?repair_ticket - repair_ticket ?payment_instrument - payment_instrument)
    :precondition
      (and
        (ticket_linked_payment_instrument ?repair_ticket ?payment_instrument)
      )
    :effect
      (and
        (payment_instrument_available ?payment_instrument)
        (not
          (ticket_linked_payment_instrument ?repair_ticket ?payment_instrument)
        )
      )
  )
  (:action unlink_counterparty_account_from_ticket
    :parameters (?repair_ticket - repair_ticket ?counterparty_account - counterparty_account)
    :precondition
      (and
        (ticket_linked_counterparty_account ?repair_ticket ?counterparty_account)
      )
    :effect
      (and
        (counterparty_account_available ?counterparty_account)
        (not
          (ticket_linked_counterparty_account ?repair_ticket ?counterparty_account)
        )
      )
  )
  (:action link_ticket_to_settlement_batch_via_proposal
    :parameters (?repair_ticket - repair_ticket ?settlement_batch - settlement_batch)
    :precondition
      (and
        (ticket_supporting_document_attached_flag ?repair_ticket)
        (settlement_batch_available ?settlement_batch)
        (ticket_batch_candidate_reference ?repair_ticket ?settlement_batch)
      )
    :effect
      (and
        (ticket_linked_settlement_batch ?repair_ticket ?settlement_batch)
        (not
          (settlement_batch_available ?settlement_batch)
        )
      )
  )
  (:action link_counterparty_account_to_ticket
    :parameters (?repair_ticket - repair_ticket ?counterparty_account - counterparty_account)
    :precondition
      (and
        (ticket_registered ?repair_ticket)
        (counterparty_account_available ?counterparty_account)
        (ticket_can_link_counterparty_account ?repair_ticket ?counterparty_account)
      )
    :effect
      (and
        (ticket_linked_counterparty_account ?repair_ticket ?counterparty_account)
        (not
          (counterparty_account_available ?counterparty_account)
        )
      )
  )
  (:action validate_ticket_with_scope_and_create_proposal
    :parameters (?repair_ticket - repair_ticket ?reconciliation_scope - reconciliation_scope ?general_ledger_account - general_ledger_account ?counterparty_account - counterparty_account)
    :precondition
      (and
        (ticket_assignment_flag ?repair_ticket)
        (reconciliation_scope_available ?reconciliation_scope)
        (ticket_scope_link ?repair_ticket ?reconciliation_scope)
        (not
          (ticket_validation_passed_flag ?repair_ticket)
        )
        (ticket_linked_counterparty_account ?repair_ticket ?counterparty_account)
        (ticket_linked_general_ledger_account ?repair_ticket ?general_ledger_account)
      )
    :effect
      (and
        (ticket_validated_against_scope ?repair_ticket ?reconciliation_scope)
        (not
          (reconciliation_scope_available ?reconciliation_scope)
        )
        (ticket_validation_passed_flag ?repair_ticket)
      )
  )
  (:action apply_approval_and_mark_for_execution
    :parameters (?repair_ticket - repair_ticket ?general_ledger_account - general_ledger_account ?counterparty_account - counterparty_account)
    :precondition
      (and
        (ticket_linked_general_ledger_account ?repair_ticket ?general_ledger_account)
        (ticket_approval_requested ?repair_ticket)
        (ticket_linked_counterparty_account ?repair_ticket ?counterparty_account)
        (ticket_escalated_flag ?repair_ticket)
      )
    :effect
      (and
        (not
          (ticket_requires_additional_evidence ?repair_ticket)
        )
        (not
          (ticket_escalated_flag ?repair_ticket)
        )
        (not
          (ticket_ready_for_proposal ?repair_ticket)
        )
        (ticket_approval_granted ?repair_ticket)
      )
  )
  (:action unlink_system_reference_from_ticket
    :parameters (?repair_ticket - repair_ticket ?system_reference - system_reference)
    :precondition
      (and
        (ticket_linked_system_reference ?repair_ticket ?system_reference)
      )
    :effect
      (and
        (system_reference_available ?system_reference)
        (not
          (ticket_linked_system_reference ?repair_ticket ?system_reference)
        )
      )
  )
  (:action attach_supporting_document_and_mark_ready
    :parameters (?repair_ticket - repair_ticket ?system_reference - system_reference ?supporting_document - supporting_document)
    :precondition
      (and
        (not
          (ticket_ready_for_proposal ?repair_ticket)
        )
        (ticket_assignment_flag ?repair_ticket)
        (supporting_document_available ?supporting_document)
        (ticket_linked_system_reference ?repair_ticket ?system_reference)
        (ticket_validated_by_reference ?repair_ticket)
      )
    :effect
      (and
        (not
          (ticket_escalated_flag ?repair_ticket)
        )
        (ticket_ready_for_proposal ?repair_ticket)
      )
  )
  (:action finalize_ticket_resolution_with_indexed_evidence
    :parameters (?repair_ticket - repair_ticket)
    :precondition
      (and
        (ticket_registered ?repair_ticket)
        (ticket_system_origin_flag ?repair_ticket)
        (ticket_evidence_indexed ?repair_ticket)
        (ticket_assignment_flag ?repair_ticket)
        (ticket_ready_for_proposal ?repair_ticket)
        (not
          (ticket_closed ?repair_ticket)
        )
        (ticket_supporting_document_attached_flag ?repair_ticket)
        (ticket_validation_passed_flag ?repair_ticket)
        (ticket_approval_requested ?repair_ticket)
      )
    :effect
      (and
        (ticket_closed ?repair_ticket)
      )
  )
  (:action index_supporting_document_for_closure
    :parameters (?repair_ticket - repair_ticket ?system_reference - system_reference ?supporting_document - supporting_document)
    :precondition
      (and
        (ticket_ready_for_proposal ?repair_ticket)
        (supporting_document_available ?supporting_document)
        (not
          (ticket_evidence_indexed ?repair_ticket)
        )
        (ticket_supporting_document_attached_flag ?repair_ticket)
        (ticket_registered ?repair_ticket)
        (ticket_system_origin_flag ?repair_ticket)
        (ticket_linked_system_reference ?repair_ticket ?system_reference)
      )
    :effect
      (and
        (ticket_evidence_indexed ?repair_ticket)
      )
  )
  (:action unlink_general_ledger_account_from_ticket
    :parameters (?repair_ticket - repair_ticket ?general_ledger_account - general_ledger_account)
    :precondition
      (and
        (ticket_linked_general_ledger_account ?repair_ticket ?general_ledger_account)
      )
    :effect
      (and
        (general_ledger_account_available ?general_ledger_account)
        (not
          (ticket_linked_general_ledger_account ?repair_ticket ?general_ledger_account)
        )
      )
  )
  (:action link_proposed_correction_to_ticket
    :parameters (?repair_ticket - repair_ticket ?proposed_correction - proposed_correction)
    :precondition
      (and
        (proposed_correction_available ?proposed_correction)
        (ticket_registered ?repair_ticket)
        (ticket_can_link_proposed_correction ?repair_ticket ?proposed_correction)
      )
    :effect
      (and
        (ticket_linked_proposed_correction ?repair_ticket ?proposed_correction)
        (not
          (proposed_correction_available ?proposed_correction)
        )
      )
  )
  (:action register_repair_ticket
    :parameters (?repair_ticket - repair_ticket)
    :precondition
      (and
        (not
          (ticket_registered ?repair_ticket)
        )
        (not
          (ticket_closed ?repair_ticket)
        )
      )
    :effect
      (and
        (ticket_registered ?repair_ticket)
      )
  )
  (:action validate_ticket_with_counterparty_response
    :parameters (?repair_ticket - repair_ticket ?counterparty_response - counterparty_response)
    :precondition
      (and
        (not
          (ticket_validated_by_reference ?repair_ticket)
        )
        (ticket_registered ?repair_ticket)
        (counterparty_response_available ?counterparty_response)
        (ticket_assignment_flag ?repair_ticket)
      )
    :effect
      (and
        (ticket_escalated_flag ?repair_ticket)
        (not
          (counterparty_response_available ?counterparty_response)
        )
        (ticket_validated_by_reference ?repair_ticket)
      )
  )
  (:action validate_ticket_with_payment_and_escalation
    :parameters (?repair_ticket - repair_ticket ?reconciliation_scope - reconciliation_scope ?payment_instrument - payment_instrument ?escalation_case - escalation_case)
    :precondition
      (and
        (escalation_case_open ?escalation_case)
        (ticket_linked_escalation_case ?repair_ticket ?escalation_case)
        (not
          (ticket_validation_passed_flag ?repair_ticket)
        )
        (ticket_assignment_flag ?repair_ticket)
        (reconciliation_scope_available ?reconciliation_scope)
        (ticket_scope_link ?repair_ticket ?reconciliation_scope)
        (ticket_linked_payment_instrument ?repair_ticket ?payment_instrument)
      )
    :effect
      (and
        (ticket_validated_against_scope ?repair_ticket ?reconciliation_scope)
        (not
          (escalation_case_open ?escalation_case)
        )
        (ticket_requires_additional_evidence ?repair_ticket)
        (not
          (reconciliation_scope_available ?reconciliation_scope)
        )
        (ticket_escalated_flag ?repair_ticket)
        (ticket_validation_passed_flag ?repair_ticket)
      )
  )
  (:action attach_counterparty_response_and_flag
    :parameters (?repair_ticket - repair_ticket ?counterparty_response - counterparty_response)
    :precondition
      (and
        (counterparty_response_available ?counterparty_response)
        (not
          (ticket_escalated_flag ?repair_ticket)
        )
        (ticket_ready_for_proposal ?repair_ticket)
        (ticket_approval_requested ?repair_ticket)
        (not
          (ticket_supporting_document_attached_flag ?repair_ticket)
        )
      )
    :effect
      (and
        (ticket_supporting_document_attached_flag ?repair_ticket)
        (not
          (counterparty_response_available ?counterparty_response)
        )
      )
  )
  (:action release_analyst_from_ticket
    :parameters (?repair_ticket - repair_ticket ?reconciliation_analyst - reconciliation_analyst)
    :precondition
      (and
        (ticket_assigned_to_analyst ?repair_ticket ?reconciliation_analyst)
        (not
          (ticket_approval_requested ?repair_ticket)
        )
        (not
          (ticket_validation_passed_flag ?repair_ticket)
        )
      )
    :effect
      (and
        (not
          (ticket_assigned_to_analyst ?repair_ticket ?reconciliation_analyst)
        )
        (analyst_available ?reconciliation_analyst)
        (not
          (ticket_assignment_flag ?repair_ticket)
        )
        (not
          (ticket_validated_by_reference ?repair_ticket)
        )
        (not
          (ticket_approval_granted ?repair_ticket)
        )
        (not
          (ticket_ready_for_proposal ?repair_ticket)
        )
        (not
          (ticket_requires_additional_evidence ?repair_ticket)
        )
        (not
          (ticket_escalated_flag ?repair_ticket)
        )
      )
  )
  (:action attach_system_reference_document_flag
    :parameters (?repair_ticket - repair_ticket ?system_reference - system_reference)
    :precondition
      (and
        (not
          (ticket_supporting_document_attached_flag ?repair_ticket)
        )
        (ticket_linked_system_reference ?repair_ticket ?system_reference)
        (ticket_ready_for_proposal ?repair_ticket)
        (ticket_approval_requested ?repair_ticket)
        (not
          (ticket_escalated_flag ?repair_ticket)
        )
      )
    :effect
      (and
        (ticket_supporting_document_attached_flag ?repair_ticket)
      )
  )
  (:action finalize_ticket_resolution_with_batch
    :parameters (?repair_ticket - repair_ticket ?settlement_batch - settlement_batch)
    :precondition
      (and
        (ticket_supporting_document_attached_flag ?repair_ticket)
        (ticket_approval_requested ?repair_ticket)
        (ticket_validation_passed_flag ?repair_ticket)
        (ticket_batch_link_confirmed ?repair_ticket ?settlement_batch)
        (ticket_ready_for_proposal ?repair_ticket)
        (ticket_assignment_flag ?repair_ticket)
        (ticket_registered ?repair_ticket)
        (not
          (ticket_closed ?repair_ticket)
        )
        (ticket_system_origin_flag ?repair_ticket)
      )
    :effect
      (and
        (ticket_closed ?repair_ticket)
      )
  )
  (:action validate_ticket_with_system_reference
    :parameters (?repair_ticket - repair_ticket ?system_reference - system_reference)
    :precondition
      (and
        (ticket_registered ?repair_ticket)
        (ticket_assignment_flag ?repair_ticket)
        (not
          (ticket_validated_by_reference ?repair_ticket)
        )
        (ticket_linked_system_reference ?repair_ticket ?system_reference)
      )
    :effect
      (and
        (ticket_validated_by_reference ?repair_ticket)
      )
  )
  (:action assign_analyst_to_ticket
    :parameters (?repair_ticket - repair_ticket ?reconciliation_analyst - reconciliation_analyst)
    :precondition
      (and
        (not
          (ticket_assignment_flag ?repair_ticket)
        )
        (ticket_registered ?repair_ticket)
        (analyst_available ?reconciliation_analyst)
        (ticket_candidate_analyst ?repair_ticket ?reconciliation_analyst)
      )
    :effect
      (and
        (ticket_assignment_flag ?repair_ticket)
        (not
          (analyst_available ?reconciliation_analyst)
        )
        (ticket_assigned_to_analyst ?repair_ticket ?reconciliation_analyst)
      )
  )
  (:action reopen_ticket_for_additional_evidence
    :parameters (?repair_ticket - repair_ticket ?system_reference - system_reference ?supporting_document - supporting_document)
    :precondition
      (and
        (ticket_assignment_flag ?repair_ticket)
        (not
          (ticket_ready_for_proposal ?repair_ticket)
        )
        (ticket_linked_system_reference ?repair_ticket ?system_reference)
        (ticket_approval_requested ?repair_ticket)
        (supporting_document_available ?supporting_document)
        (ticket_approval_granted ?repair_ticket)
      )
    :effect
      (and
        (ticket_ready_for_proposal ?repair_ticket)
      )
  )
  (:action confirm_batch_link_for_system_ticket
    :parameters (?system_generated_ticket - system_generated_ticket ?client_initiated_ticket - client_initiated_ticket ?settlement_batch - settlement_batch)
    :precondition
      (and
        (ticket_registered ?system_generated_ticket)
        (ticket_linked_settlement_batch ?client_initiated_ticket ?settlement_batch)
        (ticket_system_origin_flag ?system_generated_ticket)
        (not
          (ticket_batch_link_confirmed ?system_generated_ticket ?settlement_batch)
        )
        (ticket_batch_link_candidate ?system_generated_ticket ?settlement_batch)
      )
    :effect
      (and
        (ticket_batch_link_confirmed ?system_generated_ticket ?settlement_batch)
      )
  )
)

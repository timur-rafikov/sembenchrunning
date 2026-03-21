(define (domain reconciliation_backoffice_nostro_vostro)
  (:requirements :strips :typing :negative-preconditions)
  (:types reconciliation_case - object external_transaction - object ledger_entry - object account - object payment_message - object fee_entry - object instruction_reference - object evidence_document - object settlement_event - object operator - object system_ticket - object counterparty_record - object resolution_group - object resolver_team - resolution_group escalation_group - resolution_group nostro_case - reconciliation_case vostro_case - reconciliation_case)
  (:predicates
    (evidence_available ?evidence_document - evidence_document)
    (case_linked_account ?break_case - reconciliation_case ?account - account)
    (remediation_processed ?break_case - reconciliation_case)
    (case_linked_transaction ?break_case - reconciliation_case ?external_transaction - external_transaction)
    (case_resolution_queue_assignment ?break_case - reconciliation_case ?resolution_queue - resolution_group)
    (fee_entry_available ?fee_entry - fee_entry)
    (account_available ?account - account)
    (case_counterparty_candidate ?break_case - reconciliation_case ?counterparty_record - counterparty_record)
    (case_closed ?break_case - reconciliation_case)
    (is_nostro_view ?break_case - reconciliation_case)
    (case_transaction_candidate ?break_case - reconciliation_case ?external_transaction - external_transaction)
    (ledger_entry_available ?ledger_entry - ledger_entry)
    (system_ticket_open ?system_ticket - system_ticket)
    (instruction_reference_available ?instruction_reference - instruction_reference)
    (case_accounting_aligned ?break_case - reconciliation_case)
    (case_account_candidate ?break_case - reconciliation_case ?account - account)
    (case_linked_counterparty ?break_case - reconciliation_case ?counterparty_record - counterparty_record)
    (case_linked_ledger_entry ?break_case - reconciliation_case ?ledger_entry - ledger_entry)
    (remediation_ticket_created ?break_case - reconciliation_case)
    (case_fee_candidate ?break_case - reconciliation_case ?fee_entry - fee_entry)
    (counterparty_record_available ?counterparty_record - counterparty_record)
    (is_vostro_view ?break_case - reconciliation_case)
    (evidence_attached ?break_case - reconciliation_case)
    (case_payment_message_candidate ?break_case - reconciliation_case ?payment_message - payment_message)
    (case_linked_payment_message ?break_case - reconciliation_case ?payment_message - payment_message)
    (requires_manager_approval ?break_case - reconciliation_case)
    (case_instruction_reference_candidate ?break_case - reconciliation_case ?instruction_reference - instruction_reference)
    (operator_review_completed ?break_case - reconciliation_case)
    (case_system_ticket_candidate ?break_case - reconciliation_case ?system_ticket - system_ticket)
    (case_registered ?break_case - reconciliation_case)
    (external_transaction_available ?external_transaction - external_transaction)
    (case_transaction_linked ?break_case - reconciliation_case)
    (operator_available ?operator - operator)
    (settlement_event_available ?settlement_event - settlement_event)
    (case_linked_fee ?break_case - reconciliation_case ?fee_entry - fee_entry)
    (case_settlement_confirmed ?break_case - reconciliation_case ?settlement_event - settlement_event)
    (instruction_validated ?break_case - reconciliation_case)
    (ready_for_settlement_matching ?break_case - reconciliation_case)
    (case_settlement_candidate_from_nostro ?break_case - reconciliation_case ?settlement_event - settlement_event)
    (payment_message_available ?payment_message - payment_message)
    (case_settlement_candidate_from_vostro ?break_case - reconciliation_case ?settlement_event - settlement_event)
    (case_ledger_entry_candidate ?break_case - reconciliation_case ?ledger_entry - ledger_entry)
    (pending_remediation ?break_case - reconciliation_case)
    (case_settlement_linked ?break_case - reconciliation_case ?settlement_event - settlement_event)
  )
  (:action unlink_counterparty_from_case
    :parameters (?break_case - reconciliation_case ?counterparty_record - counterparty_record)
    :precondition
      (and
        (case_linked_counterparty ?break_case ?counterparty_record)
      )
    :effect
      (and
        (counterparty_record_available ?counterparty_record)
        (not
          (case_linked_counterparty ?break_case ?counterparty_record)
        )
      )
  )
  (:action escalate_and_create_remediation_ticket
    :parameters (?break_case - reconciliation_case ?fee_entry - fee_entry ?counterparty_record - counterparty_record ?escalation_group - escalation_group)
    :precondition
      (and
        (not
          (remediation_ticket_created ?break_case)
        )
        (case_accounting_aligned ?break_case)
        (evidence_attached ?break_case)
        (case_linked_counterparty ?break_case ?counterparty_record)
        (case_resolution_queue_assignment ?break_case ?escalation_group)
        (case_linked_fee ?break_case ?fee_entry)
      )
    :effect
      (and
        (pending_remediation ?break_case)
        (remediation_ticket_created ?break_case)
      )
  )
  (:action close_case_with_nostro_signoff
    :parameters (?break_case - reconciliation_case)
    :precondition
      (and
        (evidence_attached ?break_case)
        (case_transaction_linked ?break_case)
        (case_accounting_aligned ?break_case)
        (case_registered ?break_case)
        (ready_for_settlement_matching ?break_case)
        (not
          (case_closed ?break_case)
        )
        (is_nostro_view ?break_case)
        (remediation_ticket_created ?break_case)
      )
    :effect
      (and
        (case_closed ?break_case)
      )
  )
  (:action approve_accounting_alignment
    :parameters (?break_case - reconciliation_case ?payment_message - payment_message ?account - account)
    :precondition
      (and
        (case_accounting_aligned ?break_case)
        (requires_manager_approval ?break_case)
        (case_linked_payment_message ?break_case ?payment_message)
        (case_linked_account ?break_case ?account)
      )
    :effect
      (and
        (not
          (requires_manager_approval ?break_case)
        )
        (not
          (pending_remediation ?break_case)
        )
      )
  )
  (:action attach_instruction_reference
    :parameters (?break_case - reconciliation_case ?instruction_reference - instruction_reference)
    :precondition
      (and
        (instruction_reference_available ?instruction_reference)
        (case_registered ?break_case)
      )
    :effect
      (and
        (not
          (instruction_reference_available ?instruction_reference)
        )
        (case_instruction_reference_candidate ?break_case ?instruction_reference)
      )
  )
  (:action create_remediation_ticket
    :parameters (?break_case - reconciliation_case ?payment_message - payment_message ?account - account ?resolver_team - resolver_team)
    :precondition
      (and
        (case_resolution_queue_assignment ?break_case ?resolver_team)
        (evidence_attached ?break_case)
        (not
          (pending_remediation ?break_case)
        )
        (case_linked_payment_message ?break_case ?payment_message)
        (case_accounting_aligned ?break_case)
        (case_linked_account ?break_case ?account)
        (not
          (remediation_ticket_created ?break_case)
        )
      )
    :effect
      (and
        (remediation_ticket_created ?break_case)
      )
  )
  (:action attach_settlement_event_to_case
    :parameters (?break_case - reconciliation_case ?settlement_event - settlement_event)
    :precondition
      (and
        (case_transaction_linked ?break_case)
        (case_settlement_linked ?break_case ?settlement_event)
        (not
          (evidence_attached ?break_case)
        )
      )
    :effect
      (and
        (evidence_attached ?break_case)
        (not
          (pending_remediation ?break_case)
        )
      )
  )
  (:action link_fee_to_case
    :parameters (?break_case - reconciliation_case ?fee_entry - fee_entry)
    :precondition
      (and
        (case_fee_candidate ?break_case ?fee_entry)
        (case_registered ?break_case)
        (fee_entry_available ?fee_entry)
      )
    :effect
      (and
        (case_linked_fee ?break_case ?fee_entry)
        (not
          (fee_entry_available ?fee_entry)
        )
      )
  )
  (:action link_payment_message_to_case
    :parameters (?break_case - reconciliation_case ?payment_message - payment_message)
    :precondition
      (and
        (case_registered ?break_case)
        (payment_message_available ?payment_message)
        (case_payment_message_candidate ?break_case ?payment_message)
      )
    :effect
      (and
        (not
          (payment_message_available ?payment_message)
        )
        (case_linked_payment_message ?break_case ?payment_message)
      )
  )
  (:action unlink_fee_from_case
    :parameters (?break_case - reconciliation_case ?fee_entry - fee_entry)
    :precondition
      (and
        (case_linked_fee ?break_case ?fee_entry)
      )
    :effect
      (and
        (fee_entry_available ?fee_entry)
        (not
          (case_linked_fee ?break_case ?fee_entry)
        )
      )
  )
  (:action unlink_account_from_case
    :parameters (?break_case - reconciliation_case ?account - account)
    :precondition
      (and
        (case_linked_account ?break_case ?account)
      )
    :effect
      (and
        (account_available ?account)
        (not
          (case_linked_account ?break_case ?account)
        )
      )
  )
  (:action confirm_settlement_association
    :parameters (?break_case - reconciliation_case ?settlement_event - settlement_event)
    :precondition
      (and
        (ready_for_settlement_matching ?break_case)
        (settlement_event_available ?settlement_event)
        (case_settlement_candidate_from_nostro ?break_case ?settlement_event)
      )
    :effect
      (and
        (case_settlement_confirmed ?break_case ?settlement_event)
        (not
          (settlement_event_available ?settlement_event)
        )
      )
  )
  (:action link_account_to_case
    :parameters (?break_case - reconciliation_case ?account - account)
    :precondition
      (and
        (case_registered ?break_case)
        (account_available ?account)
        (case_account_candidate ?break_case ?account)
      )
    :effect
      (and
        (case_linked_account ?break_case ?account)
        (not
          (account_available ?account)
        )
      )
  )
  (:action create_accounting_alignment_candidate
    :parameters (?break_case - reconciliation_case ?ledger_entry - ledger_entry ?payment_message - payment_message ?account - account)
    :precondition
      (and
        (case_transaction_linked ?break_case)
        (ledger_entry_available ?ledger_entry)
        (case_ledger_entry_candidate ?break_case ?ledger_entry)
        (not
          (case_accounting_aligned ?break_case)
        )
        (case_linked_account ?break_case ?account)
        (case_linked_payment_message ?break_case ?payment_message)
      )
    :effect
      (and
        (case_linked_ledger_entry ?break_case ?ledger_entry)
        (not
          (ledger_entry_available ?ledger_entry)
        )
        (case_accounting_aligned ?break_case)
      )
  )
  (:action apply_remediation_and_mark_processed
    :parameters (?break_case - reconciliation_case ?payment_message - payment_message ?account - account)
    :precondition
      (and
        (case_linked_payment_message ?break_case ?payment_message)
        (remediation_ticket_created ?break_case)
        (case_linked_account ?break_case ?account)
        (pending_remediation ?break_case)
      )
    :effect
      (and
        (not
          (requires_manager_approval ?break_case)
        )
        (not
          (pending_remediation ?break_case)
        )
        (not
          (evidence_attached ?break_case)
        )
        (remediation_processed ?break_case)
      )
  )
  (:action detach_instruction_reference
    :parameters (?break_case - reconciliation_case ?instruction_reference - instruction_reference)
    :precondition
      (and
        (case_instruction_reference_candidate ?break_case ?instruction_reference)
      )
    :effect
      (and
        (instruction_reference_available ?instruction_reference)
        (not
          (case_instruction_reference_candidate ?break_case ?instruction_reference)
        )
      )
  )
  (:action submit_evidence_for_review
    :parameters (?break_case - reconciliation_case ?instruction_reference - instruction_reference ?operator - operator)
    :precondition
      (and
        (not
          (evidence_attached ?break_case)
        )
        (case_transaction_linked ?break_case)
        (operator_available ?operator)
        (case_instruction_reference_candidate ?break_case ?instruction_reference)
        (instruction_validated ?break_case)
      )
    :effect
      (and
        (not
          (pending_remediation ?break_case)
        )
        (evidence_attached ?break_case)
      )
  )
  (:action close_case_with_operator_acknowledgement
    :parameters (?break_case - reconciliation_case)
    :precondition
      (and
        (case_registered ?break_case)
        (is_vostro_view ?break_case)
        (operator_review_completed ?break_case)
        (case_transaction_linked ?break_case)
        (evidence_attached ?break_case)
        (not
          (case_closed ?break_case)
        )
        (ready_for_settlement_matching ?break_case)
        (case_accounting_aligned ?break_case)
        (remediation_ticket_created ?break_case)
      )
    :effect
      (and
        (case_closed ?break_case)
      )
  )
  (:action mark_evidence_review_complete
    :parameters (?break_case - reconciliation_case ?instruction_reference - instruction_reference ?operator - operator)
    :precondition
      (and
        (evidence_attached ?break_case)
        (operator_available ?operator)
        (not
          (operator_review_completed ?break_case)
        )
        (ready_for_settlement_matching ?break_case)
        (case_registered ?break_case)
        (is_vostro_view ?break_case)
        (case_instruction_reference_candidate ?break_case ?instruction_reference)
      )
    :effect
      (and
        (operator_review_completed ?break_case)
      )
  )
  (:action unlink_payment_message_from_case
    :parameters (?break_case - reconciliation_case ?payment_message - payment_message)
    :precondition
      (and
        (case_linked_payment_message ?break_case ?payment_message)
      )
    :effect
      (and
        (payment_message_available ?payment_message)
        (not
          (case_linked_payment_message ?break_case ?payment_message)
        )
      )
  )
  (:action link_counterparty_to_case
    :parameters (?break_case - reconciliation_case ?counterparty_record - counterparty_record)
    :precondition
      (and
        (counterparty_record_available ?counterparty_record)
        (case_registered ?break_case)
        (case_counterparty_candidate ?break_case ?counterparty_record)
      )
    :effect
      (and
        (case_linked_counterparty ?break_case ?counterparty_record)
        (not
          (counterparty_record_available ?counterparty_record)
        )
      )
  )
  (:action create_case
    :parameters (?break_case - reconciliation_case)
    :precondition
      (and
        (not
          (case_registered ?break_case)
        )
        (not
          (case_closed ?break_case)
        )
      )
    :effect
      (and
        (case_registered ?break_case)
      )
  )
  (:action attach_evidence_and_validate_instruction
    :parameters (?break_case - reconciliation_case ?evidence_document - evidence_document)
    :precondition
      (and
        (not
          (instruction_validated ?break_case)
        )
        (case_registered ?break_case)
        (evidence_available ?evidence_document)
        (case_transaction_linked ?break_case)
      )
    :effect
      (and
        (pending_remediation ?break_case)
        (not
          (evidence_available ?evidence_document)
        )
        (instruction_validated ?break_case)
      )
  )
  (:action create_complex_accounting_alignment
    :parameters (?break_case - reconciliation_case ?ledger_entry - ledger_entry ?fee_entry - fee_entry ?system_ticket - system_ticket)
    :precondition
      (and
        (system_ticket_open ?system_ticket)
        (case_system_ticket_candidate ?break_case ?system_ticket)
        (not
          (case_accounting_aligned ?break_case)
        )
        (case_transaction_linked ?break_case)
        (ledger_entry_available ?ledger_entry)
        (case_ledger_entry_candidate ?break_case ?ledger_entry)
        (case_linked_fee ?break_case ?fee_entry)
      )
    :effect
      (and
        (case_linked_ledger_entry ?break_case ?ledger_entry)
        (not
          (system_ticket_open ?system_ticket)
        )
        (requires_manager_approval ?break_case)
        (not
          (ledger_entry_available ?ledger_entry)
        )
        (pending_remediation ?break_case)
        (case_accounting_aligned ?break_case)
      )
  )
  (:action verify_evidence_document_for_settlement_matching
    :parameters (?break_case - reconciliation_case ?evidence_document - evidence_document)
    :precondition
      (and
        (evidence_available ?evidence_document)
        (not
          (pending_remediation ?break_case)
        )
        (evidence_attached ?break_case)
        (remediation_ticket_created ?break_case)
        (not
          (ready_for_settlement_matching ?break_case)
        )
      )
    :effect
      (and
        (ready_for_settlement_matching ?break_case)
        (not
          (evidence_available ?evidence_document)
        )
      )
  )
  (:action unlink_transaction_from_case
    :parameters (?break_case - reconciliation_case ?external_transaction - external_transaction)
    :precondition
      (and
        (case_linked_transaction ?break_case ?external_transaction)
        (not
          (remediation_ticket_created ?break_case)
        )
        (not
          (case_accounting_aligned ?break_case)
        )
      )
    :effect
      (and
        (not
          (case_linked_transaction ?break_case ?external_transaction)
        )
        (external_transaction_available ?external_transaction)
        (not
          (case_transaction_linked ?break_case)
        )
        (not
          (instruction_validated ?break_case)
        )
        (not
          (remediation_processed ?break_case)
        )
        (not
          (evidence_attached ?break_case)
        )
        (not
          (requires_manager_approval ?break_case)
        )
        (not
          (pending_remediation ?break_case)
        )
      )
  )
  (:action verify_instruction_reference_for_settlement_matching
    :parameters (?break_case - reconciliation_case ?instruction_reference - instruction_reference)
    :precondition
      (and
        (not
          (ready_for_settlement_matching ?break_case)
        )
        (case_instruction_reference_candidate ?break_case ?instruction_reference)
        (evidence_attached ?break_case)
        (remediation_ticket_created ?break_case)
        (not
          (pending_remediation ?break_case)
        )
      )
    :effect
      (and
        (ready_for_settlement_matching ?break_case)
      )
  )
  (:action close_case_with_settlement_event
    :parameters (?break_case - reconciliation_case ?settlement_event - settlement_event)
    :precondition
      (and
        (ready_for_settlement_matching ?break_case)
        (remediation_ticket_created ?break_case)
        (case_accounting_aligned ?break_case)
        (case_settlement_linked ?break_case ?settlement_event)
        (evidence_attached ?break_case)
        (case_transaction_linked ?break_case)
        (case_registered ?break_case)
        (not
          (case_closed ?break_case)
        )
        (is_vostro_view ?break_case)
      )
    :effect
      (and
        (case_closed ?break_case)
      )
  )
  (:action validate_instruction_reference
    :parameters (?break_case - reconciliation_case ?instruction_reference - instruction_reference)
    :precondition
      (and
        (case_registered ?break_case)
        (case_transaction_linked ?break_case)
        (not
          (instruction_validated ?break_case)
        )
        (case_instruction_reference_candidate ?break_case ?instruction_reference)
      )
    :effect
      (and
        (instruction_validated ?break_case)
      )
  )
  (:action link_transaction_to_case
    :parameters (?break_case - reconciliation_case ?external_transaction - external_transaction)
    :precondition
      (and
        (not
          (case_transaction_linked ?break_case)
        )
        (case_registered ?break_case)
        (external_transaction_available ?external_transaction)
        (case_transaction_candidate ?break_case ?external_transaction)
      )
    :effect
      (and
        (case_transaction_linked ?break_case)
        (not
          (external_transaction_available ?external_transaction)
        )
        (case_linked_transaction ?break_case ?external_transaction)
      )
  )
  (:action reapply_evidence_after_remediation
    :parameters (?break_case - reconciliation_case ?instruction_reference - instruction_reference ?operator - operator)
    :precondition
      (and
        (case_transaction_linked ?break_case)
        (not
          (evidence_attached ?break_case)
        )
        (case_instruction_reference_candidate ?break_case ?instruction_reference)
        (remediation_ticket_created ?break_case)
        (operator_available ?operator)
        (remediation_processed ?break_case)
      )
    :effect
      (and
        (evidence_attached ?break_case)
      )
  )
  (:action link_cross_ledger_settlement_event
    :parameters (?vostro_account_view - vostro_case ?nostro_account_view - nostro_case ?settlement_event - settlement_event)
    :precondition
      (and
        (case_registered ?vostro_account_view)
        (case_settlement_confirmed ?nostro_account_view ?settlement_event)
        (is_vostro_view ?vostro_account_view)
        (not
          (case_settlement_linked ?vostro_account_view ?settlement_event)
        )
        (case_settlement_candidate_from_vostro ?vostro_account_view ?settlement_event)
      )
    :effect
      (and
        (case_settlement_linked ?vostro_account_view ?settlement_event)
      )
  )
)

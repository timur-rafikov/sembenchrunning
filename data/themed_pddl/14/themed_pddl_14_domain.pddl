(define (domain intraday_ledger_reconciliation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types reconciliation_case - object ledger_transaction - object settlement_instruction - object counterparty_account - object matching_key - object payment_instruction - object source_file - object reconciliation_operator - object validation_profile - object document_reference - object counterparty_confirmation - object control_identifier - object escalation_category - object escalation_level - escalation_category escalation_matrix - escalation_category originating_case_variant - reconciliation_case counterparty_case_variant - reconciliation_case)
  (:predicates
    (operator_available ?reconciliation_operator - reconciliation_operator)
    (case_linked_counterparty_account ?reconciliation_case - reconciliation_case ?counterparty_account - counterparty_account)
    (escalation_approved ?reconciliation_case - reconciliation_case)
    (case_linked_transaction ?reconciliation_case - reconciliation_case ?ledger_transaction - ledger_transaction)
    (case_escalation_option_link ?reconciliation_case - reconciliation_case ?escalation_category - escalation_category)
    (payment_instruction_available ?payment_instruction - payment_instruction)
    (counterparty_account_available ?counterparty_account - counterparty_account)
    (case_control_identifier_candidate ?reconciliation_case - reconciliation_case ?control_identifier - control_identifier)
    (case_closed ?reconciliation_case - reconciliation_case)
    (closure_candidate ?reconciliation_case - reconciliation_case)
    (case_transaction_candidate ?reconciliation_case - reconciliation_case ?ledger_transaction - ledger_transaction)
    (settlement_instruction_available ?settlement_instruction - settlement_instruction)
    (counterparty_confirmation_available ?counterparty_confirmation - counterparty_confirmation)
    (source_file_available ?source_file - source_file)
    (accounting_verified ?reconciliation_case - reconciliation_case)
    (case_counterparty_account_candidate ?reconciliation_case - reconciliation_case ?counterparty_account - counterparty_account)
    (case_linked_control_identifier ?reconciliation_case - reconciliation_case ?control_identifier - control_identifier)
    (case_linked_settlement_instruction ?reconciliation_case - reconciliation_case ?settlement_instruction - settlement_instruction)
    (escalation_requested ?reconciliation_case - reconciliation_case)
    (case_payment_instruction_candidate ?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction)
    (control_identifier_available ?control_identifier - control_identifier)
    (case_variant_present ?reconciliation_case - reconciliation_case)
    (validation_complete ?reconciliation_case - reconciliation_case)
    (case_matching_key_candidate ?reconciliation_case - reconciliation_case ?matching_key - matching_key)
    (case_linked_matching_key ?reconciliation_case - reconciliation_case ?matching_key - matching_key)
    (manual_review_required ?reconciliation_case - reconciliation_case)
    (case_attached_source_file ?reconciliation_case - reconciliation_case ?source_file - source_file)
    (evidence_marked_present ?reconciliation_case - reconciliation_case)
    (case_counterparty_confirmation_candidate ?reconciliation_case - reconciliation_case ?counterparty_confirmation - counterparty_confirmation)
    (case_registered ?reconciliation_case - reconciliation_case)
    (transaction_available ?ledger_transaction - ledger_transaction)
    (case_has_matches ?reconciliation_case - reconciliation_case)
    (document_reference_available ?document_reference - document_reference)
    (validation_profile_available ?validation_profile - validation_profile)
    (case_linked_payment_instruction ?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction)
    (case_variant_profile_link ?reconciliation_case - reconciliation_case ?validation_profile - validation_profile)
    (investigation_started ?reconciliation_case - reconciliation_case)
    (documents_verified ?reconciliation_case - reconciliation_case)
    (case_profile_default_mapping ?reconciliation_case - reconciliation_case ?validation_profile - validation_profile)
    (matching_key_available ?matching_key - matching_key)
    (case_profile_candidate ?reconciliation_case - reconciliation_case ?validation_profile - validation_profile)
    (case_settlement_candidate ?reconciliation_case - reconciliation_case ?settlement_instruction - settlement_instruction)
    (escalation_pending ?reconciliation_case - reconciliation_case)
    (profile_applied_to_case ?reconciliation_case - reconciliation_case ?validation_profile - validation_profile)
  )
  (:action unlink_control_identifier
    :parameters (?reconciliation_case - reconciliation_case ?control_identifier - control_identifier)
    :precondition
      (and
        (case_linked_control_identifier ?reconciliation_case ?control_identifier)
      )
    :effect
      (and
        (control_identifier_available ?control_identifier)
        (not
          (case_linked_control_identifier ?reconciliation_case ?control_identifier)
        )
      )
  )
  (:action process_escalation_with_matrix
    :parameters (?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction ?control_identifier - control_identifier ?escalation_matrix - escalation_matrix)
    :precondition
      (and
        (not
          (escalation_requested ?reconciliation_case)
        )
        (accounting_verified ?reconciliation_case)
        (validation_complete ?reconciliation_case)
        (case_linked_control_identifier ?reconciliation_case ?control_identifier)
        (case_escalation_option_link ?reconciliation_case ?escalation_matrix)
        (case_linked_payment_instruction ?reconciliation_case ?payment_instruction)
      )
    :effect
      (and
        (escalation_pending ?reconciliation_case)
        (escalation_requested ?reconciliation_case)
      )
  )
  (:action close_case
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (validation_complete ?reconciliation_case)
        (case_has_matches ?reconciliation_case)
        (accounting_verified ?reconciliation_case)
        (case_registered ?reconciliation_case)
        (documents_verified ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
        (closure_candidate ?reconciliation_case)
        (escalation_requested ?reconciliation_case)
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action clear_manual_review_flag
    :parameters (?reconciliation_case - reconciliation_case ?matching_key - matching_key ?counterparty_account - counterparty_account)
    :precondition
      (and
        (accounting_verified ?reconciliation_case)
        (manual_review_required ?reconciliation_case)
        (case_linked_matching_key ?reconciliation_case ?matching_key)
        (case_linked_counterparty_account ?reconciliation_case ?counterparty_account)
      )
    :effect
      (and
        (not
          (manual_review_required ?reconciliation_case)
        )
        (not
          (escalation_pending ?reconciliation_case)
        )
      )
  )
  (:action attach_source_file
    :parameters (?reconciliation_case - reconciliation_case ?source_file - source_file)
    :precondition
      (and
        (source_file_available ?source_file)
        (case_registered ?reconciliation_case)
      )
    :effect
      (and
        (not
          (source_file_available ?source_file)
        )
        (case_attached_source_file ?reconciliation_case ?source_file)
      )
  )
  (:action initiate_escalation_request
    :parameters (?reconciliation_case - reconciliation_case ?matching_key - matching_key ?counterparty_account - counterparty_account ?escalation_level - escalation_level)
    :precondition
      (and
        (case_escalation_option_link ?reconciliation_case ?escalation_level)
        (validation_complete ?reconciliation_case)
        (not
          (escalation_pending ?reconciliation_case)
        )
        (case_linked_matching_key ?reconciliation_case ?matching_key)
        (accounting_verified ?reconciliation_case)
        (case_linked_counterparty_account ?reconciliation_case ?counterparty_account)
        (not
          (escalation_requested ?reconciliation_case)
        )
      )
    :effect
      (and
        (escalation_requested ?reconciliation_case)
      )
  )
  (:action apply_validation_profile
    :parameters (?reconciliation_case - reconciliation_case ?validation_profile - validation_profile)
    :precondition
      (and
        (case_has_matches ?reconciliation_case)
        (profile_applied_to_case ?reconciliation_case ?validation_profile)
        (not
          (validation_complete ?reconciliation_case)
        )
      )
    :effect
      (and
        (validation_complete ?reconciliation_case)
        (not
          (escalation_pending ?reconciliation_case)
        )
      )
  )
  (:action link_payment_instruction
    :parameters (?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction)
    :precondition
      (and
        (case_payment_instruction_candidate ?reconciliation_case ?payment_instruction)
        (case_registered ?reconciliation_case)
        (payment_instruction_available ?payment_instruction)
      )
    :effect
      (and
        (case_linked_payment_instruction ?reconciliation_case ?payment_instruction)
        (not
          (payment_instruction_available ?payment_instruction)
        )
      )
  )
  (:action link_matching_key
    :parameters (?reconciliation_case - reconciliation_case ?matching_key - matching_key)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (matching_key_available ?matching_key)
        (case_matching_key_candidate ?reconciliation_case ?matching_key)
      )
    :effect
      (and
        (not
          (matching_key_available ?matching_key)
        )
        (case_linked_matching_key ?reconciliation_case ?matching_key)
      )
  )
  (:action unlink_payment_instruction
    :parameters (?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction)
    :precondition
      (and
        (case_linked_payment_instruction ?reconciliation_case ?payment_instruction)
      )
    :effect
      (and
        (payment_instruction_available ?payment_instruction)
        (not
          (case_linked_payment_instruction ?reconciliation_case ?payment_instruction)
        )
      )
  )
  (:action unlink_counterparty_account
    :parameters (?reconciliation_case - reconciliation_case ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_linked_counterparty_account ?reconciliation_case ?counterparty_account)
      )
    :effect
      (and
        (counterparty_account_available ?counterparty_account)
        (not
          (case_linked_counterparty_account ?reconciliation_case ?counterparty_account)
        )
      )
  )
  (:action assign_validation_profile
    :parameters (?reconciliation_case - reconciliation_case ?validation_profile - validation_profile)
    :precondition
      (and
        (documents_verified ?reconciliation_case)
        (validation_profile_available ?validation_profile)
        (case_profile_default_mapping ?reconciliation_case ?validation_profile)
      )
    :effect
      (and
        (case_variant_profile_link ?reconciliation_case ?validation_profile)
        (not
          (validation_profile_available ?validation_profile)
        )
      )
  )
  (:action link_counterparty_account
    :parameters (?reconciliation_case - reconciliation_case ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (counterparty_account_available ?counterparty_account)
        (case_counterparty_account_candidate ?reconciliation_case ?counterparty_account)
      )
    :effect
      (and
        (case_linked_counterparty_account ?reconciliation_case ?counterparty_account)
        (not
          (counterparty_account_available ?counterparty_account)
        )
      )
  )
  (:action run_accounting_alignment_check
    :parameters (?reconciliation_case - reconciliation_case ?settlement_instruction - settlement_instruction ?matching_key - matching_key ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_has_matches ?reconciliation_case)
        (settlement_instruction_available ?settlement_instruction)
        (case_settlement_candidate ?reconciliation_case ?settlement_instruction)
        (not
          (accounting_verified ?reconciliation_case)
        )
        (case_linked_counterparty_account ?reconciliation_case ?counterparty_account)
        (case_linked_matching_key ?reconciliation_case ?matching_key)
      )
    :effect
      (and
        (case_linked_settlement_instruction ?reconciliation_case ?settlement_instruction)
        (not
          (settlement_instruction_available ?settlement_instruction)
        )
        (accounting_verified ?reconciliation_case)
      )
  )
  (:action finalize_escalation
    :parameters (?reconciliation_case - reconciliation_case ?matching_key - matching_key ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_linked_matching_key ?reconciliation_case ?matching_key)
        (escalation_requested ?reconciliation_case)
        (case_linked_counterparty_account ?reconciliation_case ?counterparty_account)
        (escalation_pending ?reconciliation_case)
      )
    :effect
      (and
        (not
          (manual_review_required ?reconciliation_case)
        )
        (not
          (escalation_pending ?reconciliation_case)
        )
        (not
          (validation_complete ?reconciliation_case)
        )
        (escalation_approved ?reconciliation_case)
      )
  )
  (:action detach_source_file
    :parameters (?reconciliation_case - reconciliation_case ?source_file - source_file)
    :precondition
      (and
        (case_attached_source_file ?reconciliation_case ?source_file)
      )
    :effect
      (and
        (source_file_available ?source_file)
        (not
          (case_attached_source_file ?reconciliation_case ?source_file)
        )
      )
  )
  (:action ingest_document_reference
    :parameters (?reconciliation_case - reconciliation_case ?source_file - source_file ?document_reference - document_reference)
    :precondition
      (and
        (not
          (validation_complete ?reconciliation_case)
        )
        (case_has_matches ?reconciliation_case)
        (document_reference_available ?document_reference)
        (case_attached_source_file ?reconciliation_case ?source_file)
        (investigation_started ?reconciliation_case)
      )
    :effect
      (and
        (not
          (escalation_pending ?reconciliation_case)
        )
        (validation_complete ?reconciliation_case)
      )
  )
  (:action close_case_with_evidence
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (case_variant_present ?reconciliation_case)
        (evidence_marked_present ?reconciliation_case)
        (case_has_matches ?reconciliation_case)
        (validation_complete ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
        (documents_verified ?reconciliation_case)
        (accounting_verified ?reconciliation_case)
        (escalation_requested ?reconciliation_case)
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action record_evidence_presence
    :parameters (?reconciliation_case - reconciliation_case ?source_file - source_file ?document_reference - document_reference)
    :precondition
      (and
        (validation_complete ?reconciliation_case)
        (document_reference_available ?document_reference)
        (not
          (evidence_marked_present ?reconciliation_case)
        )
        (documents_verified ?reconciliation_case)
        (case_registered ?reconciliation_case)
        (case_variant_present ?reconciliation_case)
        (case_attached_source_file ?reconciliation_case ?source_file)
      )
    :effect
      (and
        (evidence_marked_present ?reconciliation_case)
      )
  )
  (:action unlink_matching_key
    :parameters (?reconciliation_case - reconciliation_case ?matching_key - matching_key)
    :precondition
      (and
        (case_linked_matching_key ?reconciliation_case ?matching_key)
      )
    :effect
      (and
        (matching_key_available ?matching_key)
        (not
          (case_linked_matching_key ?reconciliation_case ?matching_key)
        )
      )
  )
  (:action link_control_identifier
    :parameters (?reconciliation_case - reconciliation_case ?control_identifier - control_identifier)
    :precondition
      (and
        (control_identifier_available ?control_identifier)
        (case_registered ?reconciliation_case)
        (case_control_identifier_candidate ?reconciliation_case ?control_identifier)
      )
    :effect
      (and
        (case_linked_control_identifier ?reconciliation_case ?control_identifier)
        (not
          (control_identifier_available ?control_identifier)
        )
      )
  )
  (:action register_reconciliation_case
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
  (:action assign_reconciliation_operator
    :parameters (?reconciliation_case - reconciliation_case ?reconciliation_operator - reconciliation_operator)
    :precondition
      (and
        (not
          (investigation_started ?reconciliation_case)
        )
        (case_registered ?reconciliation_case)
        (operator_available ?reconciliation_operator)
        (case_has_matches ?reconciliation_case)
      )
    :effect
      (and
        (escalation_pending ?reconciliation_case)
        (not
          (operator_available ?reconciliation_operator)
        )
        (investigation_started ?reconciliation_case)
      )
  )
  (:action run_settlement_reconciliation_with_confirmation
    :parameters (?reconciliation_case - reconciliation_case ?settlement_instruction - settlement_instruction ?payment_instruction - payment_instruction ?counterparty_confirmation - counterparty_confirmation)
    :precondition
      (and
        (counterparty_confirmation_available ?counterparty_confirmation)
        (case_counterparty_confirmation_candidate ?reconciliation_case ?counterparty_confirmation)
        (not
          (accounting_verified ?reconciliation_case)
        )
        (case_has_matches ?reconciliation_case)
        (settlement_instruction_available ?settlement_instruction)
        (case_settlement_candidate ?reconciliation_case ?settlement_instruction)
        (case_linked_payment_instruction ?reconciliation_case ?payment_instruction)
      )
    :effect
      (and
        (case_linked_settlement_instruction ?reconciliation_case ?settlement_instruction)
        (not
          (counterparty_confirmation_available ?counterparty_confirmation)
        )
        (manual_review_required ?reconciliation_case)
        (not
          (settlement_instruction_available ?settlement_instruction)
        )
        (escalation_pending ?reconciliation_case)
        (accounting_verified ?reconciliation_case)
      )
  )
  (:action verify_document_by_operator
    :parameters (?reconciliation_case - reconciliation_case ?reconciliation_operator - reconciliation_operator)
    :precondition
      (and
        (operator_available ?reconciliation_operator)
        (not
          (escalation_pending ?reconciliation_case)
        )
        (validation_complete ?reconciliation_case)
        (escalation_requested ?reconciliation_case)
        (not
          (documents_verified ?reconciliation_case)
        )
      )
    :effect
      (and
        (documents_verified ?reconciliation_case)
        (not
          (operator_available ?reconciliation_operator)
        )
      )
  )
  (:action unlink_transaction_from_case
    :parameters (?reconciliation_case - reconciliation_case ?ledger_transaction - ledger_transaction)
    :precondition
      (and
        (case_linked_transaction ?reconciliation_case ?ledger_transaction)
        (not
          (escalation_requested ?reconciliation_case)
        )
        (not
          (accounting_verified ?reconciliation_case)
        )
      )
    :effect
      (and
        (not
          (case_linked_transaction ?reconciliation_case ?ledger_transaction)
        )
        (transaction_available ?ledger_transaction)
        (not
          (case_has_matches ?reconciliation_case)
        )
        (not
          (investigation_started ?reconciliation_case)
        )
        (not
          (escalation_approved ?reconciliation_case)
        )
        (not
          (validation_complete ?reconciliation_case)
        )
        (not
          (manual_review_required ?reconciliation_case)
        )
        (not
          (escalation_pending ?reconciliation_case)
        )
      )
  )
  (:action mark_documents_verified
    :parameters (?reconciliation_case - reconciliation_case ?source_file - source_file)
    :precondition
      (and
        (not
          (documents_verified ?reconciliation_case)
        )
        (case_attached_source_file ?reconciliation_case ?source_file)
        (validation_complete ?reconciliation_case)
        (escalation_requested ?reconciliation_case)
        (not
          (escalation_pending ?reconciliation_case)
        )
      )
    :effect
      (and
        (documents_verified ?reconciliation_case)
      )
  )
  (:action close_case_with_profile
    :parameters (?reconciliation_case - reconciliation_case ?validation_profile - validation_profile)
    :precondition
      (and
        (documents_verified ?reconciliation_case)
        (escalation_requested ?reconciliation_case)
        (accounting_verified ?reconciliation_case)
        (profile_applied_to_case ?reconciliation_case ?validation_profile)
        (validation_complete ?reconciliation_case)
        (case_has_matches ?reconciliation_case)
        (case_registered ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
        (case_variant_present ?reconciliation_case)
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action initiate_investigation
    :parameters (?reconciliation_case - reconciliation_case ?source_file - source_file)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (case_has_matches ?reconciliation_case)
        (not
          (investigation_started ?reconciliation_case)
        )
        (case_attached_source_file ?reconciliation_case ?source_file)
      )
    :effect
      (and
        (investigation_started ?reconciliation_case)
      )
  )
  (:action link_transaction_to_case
    :parameters (?reconciliation_case - reconciliation_case ?ledger_transaction - ledger_transaction)
    :precondition
      (and
        (not
          (case_has_matches ?reconciliation_case)
        )
        (case_registered ?reconciliation_case)
        (transaction_available ?ledger_transaction)
        (case_transaction_candidate ?reconciliation_case ?ledger_transaction)
      )
    :effect
      (and
        (case_has_matches ?reconciliation_case)
        (not
          (transaction_available ?ledger_transaction)
        )
        (case_linked_transaction ?reconciliation_case ?ledger_transaction)
      )
  )
  (:action ingest_document_for_escalation
    :parameters (?reconciliation_case - reconciliation_case ?source_file - source_file ?document_reference - document_reference)
    :precondition
      (and
        (case_has_matches ?reconciliation_case)
        (not
          (validation_complete ?reconciliation_case)
        )
        (case_attached_source_file ?reconciliation_case ?source_file)
        (escalation_requested ?reconciliation_case)
        (document_reference_available ?document_reference)
        (escalation_approved ?reconciliation_case)
      )
    :effect
      (and
        (validation_complete ?reconciliation_case)
      )
  )
  (:action apply_variant_validation_profile
    :parameters (?counterparty_case_variant - counterparty_case_variant ?originating_case_variant - originating_case_variant ?validation_profile - validation_profile)
    :precondition
      (and
        (case_registered ?counterparty_case_variant)
        (case_variant_profile_link ?originating_case_variant ?validation_profile)
        (case_variant_present ?counterparty_case_variant)
        (not
          (profile_applied_to_case ?counterparty_case_variant ?validation_profile)
        )
        (case_profile_candidate ?counterparty_case_variant ?validation_profile)
      )
    :effect
      (and
        (profile_applied_to_case ?counterparty_case_variant ?validation_profile)
      )
  )
)

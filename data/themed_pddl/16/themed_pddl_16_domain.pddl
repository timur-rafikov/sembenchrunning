(define (domain period_end_close_payment_cutoff_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types reconciliation_case - base_object payment_batch - base_object ledger_account - base_object counterparty_account - base_object payment_instruction - base_object bank_statement_entry - base_object suspense_tag - base_object automation_rule - base_object confirmation_document - base_object supporting_attachment - base_object bank_reference_file - base_object exception_reason_code - base_object operator_role - base_object resolver_role - operator_role approver_role - operator_role processing_node - reconciliation_case source_system - reconciliation_case)
  (:predicates
    (automation_rule_available ?automation_rule - automation_rule)
    (case_has_counterparty_account ?reconciliation_case - reconciliation_case ?counterparty_account - counterparty_account)
    (case_resolution_complete ?reconciliation_case - reconciliation_case)
    (case_assigned_batch ?reconciliation_case - reconciliation_case ?payment_batch - payment_batch)
    (case_assigned_role ?reconciliation_case - reconciliation_case ?operator_role - operator_role)
    (bank_entry_available ?bank_statement_entry - bank_statement_entry)
    (counterparty_account_available ?counterparty_account - counterparty_account)
    (case_exception_code_candidate ?reconciliation_case - reconciliation_case ?exception_reason_code - exception_reason_code)
    (case_closed ?reconciliation_case - reconciliation_case)
    (processing_node_in_cutoff_scope ?reconciliation_case - reconciliation_case)
    (case_batch_candidate ?reconciliation_case - reconciliation_case ?payment_batch - payment_batch)
    (ledger_account_available ?ledger_account - ledger_account)
    (bank_reference_file_available ?bank_reference_file - bank_reference_file)
    (suspense_tag_available ?suspense_tag - suspense_tag)
    (case_ledger_validated ?reconciliation_case - reconciliation_case)
    (case_counterparty_candidate ?reconciliation_case - reconciliation_case ?counterparty_account - counterparty_account)
    (case_exception_code ?reconciliation_case - reconciliation_case ?exception_reason_code - exception_reason_code)
    (case_ledger_candidate ?reconciliation_case - reconciliation_case ?ledger_account - ledger_account)
    (case_resolution_in_progress ?reconciliation_case - reconciliation_case)
    (case_bank_entry_candidate ?reconciliation_case - reconciliation_case ?bank_statement_entry - bank_statement_entry)
    (exception_reason_code_available ?exception_reason_code - exception_reason_code)
    (source_system_active ?reconciliation_case - reconciliation_case)
    (case_adjudicated ?reconciliation_case - reconciliation_case)
    (case_payment_instruction_candidate ?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction)
    (case_has_payment_instruction ?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction)
    (case_accounting_review_flag ?reconciliation_case - reconciliation_case)
    (case_has_suspense_tag ?reconciliation_case - reconciliation_case ?suspense_tag - suspense_tag)
    (case_ready_for_close ?reconciliation_case - reconciliation_case)
    (case_bank_reference_candidate ?reconciliation_case - reconciliation_case ?bank_reference_file - bank_reference_file)
    (case_registered ?reconciliation_case - reconciliation_case)
    (payment_batch_available ?payment_batch - payment_batch)
    (case_batch_assigned ?reconciliation_case - reconciliation_case)
    (supporting_attachment_available ?supporting_attachment - supporting_attachment)
    (confirmation_document_available ?confirmation_document - confirmation_document)
    (case_has_bank_entry ?reconciliation_case - reconciliation_case ?bank_statement_entry - bank_statement_entry)
    (processing_node_confirmation_link ?reconciliation_case - reconciliation_case ?confirmation_document - confirmation_document)
    (case_on_hold ?reconciliation_case - reconciliation_case)
    (case_confirmation_pending ?reconciliation_case - reconciliation_case)
    (case_expected_confirmation ?reconciliation_case - reconciliation_case ?confirmation_document - confirmation_document)
    (payment_instruction_available ?payment_instruction - payment_instruction)
    (confirmation_available_from_source ?reconciliation_case - reconciliation_case ?confirmation_document - confirmation_document)
    (case_ledger_candidate_relation ?reconciliation_case - reconciliation_case ?ledger_account - ledger_account)
    (case_requires_approval ?reconciliation_case - reconciliation_case)
    (case_confirmation_recorded_from_source ?reconciliation_case - reconciliation_case ?confirmation_document - confirmation_document)
  )
  (:action unlink_exception_code_from_case
    :parameters (?reconciliation_case - reconciliation_case ?exception_reason_code - exception_reason_code)
    :precondition
      (and
        (case_exception_code ?reconciliation_case ?exception_reason_code)
      )
    :effect
      (and
        (exception_reason_code_available ?exception_reason_code)
        (not
          (case_exception_code ?reconciliation_case ?exception_reason_code)
        )
      )
  )
  (:action start_case_resolution_with_approver_escalation
    :parameters (?reconciliation_case - reconciliation_case ?bank_statement_entry - bank_statement_entry ?exception_reason_code - exception_reason_code ?approver_role - approver_role)
    :precondition
      (and
        (not
          (case_resolution_in_progress ?reconciliation_case)
        )
        (case_ledger_validated ?reconciliation_case)
        (case_adjudicated ?reconciliation_case)
        (case_exception_code ?reconciliation_case ?exception_reason_code)
        (case_assigned_role ?reconciliation_case ?approver_role)
        (case_has_bank_entry ?reconciliation_case ?bank_statement_entry)
      )
    :effect
      (and
        (case_requires_approval ?reconciliation_case)
        (case_resolution_in_progress ?reconciliation_case)
      )
  )
  (:action perform_final_close
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_adjudicated ?reconciliation_case)
        (case_batch_assigned ?reconciliation_case)
        (case_ledger_validated ?reconciliation_case)
        (case_registered ?reconciliation_case)
        (case_confirmation_pending ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
        (processing_node_in_cutoff_scope ?reconciliation_case)
        (case_resolution_in_progress ?reconciliation_case)
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action clear_interim_validation_flags
    :parameters (?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_ledger_validated ?reconciliation_case)
        (case_accounting_review_flag ?reconciliation_case)
        (case_has_payment_instruction ?reconciliation_case ?payment_instruction)
        (case_has_counterparty_account ?reconciliation_case ?counterparty_account)
      )
    :effect
      (and
        (not
          (case_accounting_review_flag ?reconciliation_case)
        )
        (not
          (case_requires_approval ?reconciliation_case)
        )
      )
  )
  (:action apply_suspense_tag_to_case
    :parameters (?reconciliation_case - reconciliation_case ?suspense_tag - suspense_tag)
    :precondition
      (and
        (suspense_tag_available ?suspense_tag)
        (case_registered ?reconciliation_case)
      )
    :effect
      (and
        (not
          (suspense_tag_available ?suspense_tag)
        )
        (case_has_suspense_tag ?reconciliation_case ?suspense_tag)
      )
  )
  (:action start_case_resolution_by_resolver
    :parameters (?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction ?counterparty_account - counterparty_account ?resolver_role - resolver_role)
    :precondition
      (and
        (case_assigned_role ?reconciliation_case ?resolver_role)
        (case_adjudicated ?reconciliation_case)
        (not
          (case_requires_approval ?reconciliation_case)
        )
        (case_has_payment_instruction ?reconciliation_case ?payment_instruction)
        (case_ledger_validated ?reconciliation_case)
        (case_has_counterparty_account ?reconciliation_case ?counterparty_account)
        (not
          (case_resolution_in_progress ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_resolution_in_progress ?reconciliation_case)
      )
  )
  (:action adjudicate_case_with_confirmation
    :parameters (?reconciliation_case - reconciliation_case ?confirmation_document - confirmation_document)
    :precondition
      (and
        (case_batch_assigned ?reconciliation_case)
        (case_confirmation_recorded_from_source ?reconciliation_case ?confirmation_document)
        (not
          (case_adjudicated ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_adjudicated ?reconciliation_case)
        (not
          (case_requires_approval ?reconciliation_case)
        )
      )
  )
  (:action link_bank_entry_to_case
    :parameters (?reconciliation_case - reconciliation_case ?bank_statement_entry - bank_statement_entry)
    :precondition
      (and
        (case_bank_entry_candidate ?reconciliation_case ?bank_statement_entry)
        (case_registered ?reconciliation_case)
        (bank_entry_available ?bank_statement_entry)
      )
    :effect
      (and
        (case_has_bank_entry ?reconciliation_case ?bank_statement_entry)
        (not
          (bank_entry_available ?bank_statement_entry)
        )
      )
  )
  (:action link_payment_instruction_to_case
    :parameters (?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (payment_instruction_available ?payment_instruction)
        (case_payment_instruction_candidate ?reconciliation_case ?payment_instruction)
      )
    :effect
      (and
        (not
          (payment_instruction_available ?payment_instruction)
        )
        (case_has_payment_instruction ?reconciliation_case ?payment_instruction)
      )
  )
  (:action unlink_bank_entry_from_case
    :parameters (?reconciliation_case - reconciliation_case ?bank_statement_entry - bank_statement_entry)
    :precondition
      (and
        (case_has_bank_entry ?reconciliation_case ?bank_statement_entry)
      )
    :effect
      (and
        (bank_entry_available ?bank_statement_entry)
        (not
          (case_has_bank_entry ?reconciliation_case ?bank_statement_entry)
        )
      )
  )
  (:action unlink_counterparty_account_from_case
    :parameters (?reconciliation_case - reconciliation_case ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_has_counterparty_account ?reconciliation_case ?counterparty_account)
      )
    :effect
      (and
        (counterparty_account_available ?counterparty_account)
        (not
          (case_has_counterparty_account ?reconciliation_case ?counterparty_account)
        )
      )
  )
  (:action ingest_confirmation_document_to_case
    :parameters (?reconciliation_case - reconciliation_case ?confirmation_document - confirmation_document)
    :precondition
      (and
        (case_confirmation_pending ?reconciliation_case)
        (confirmation_document_available ?confirmation_document)
        (case_expected_confirmation ?reconciliation_case ?confirmation_document)
      )
    :effect
      (and
        (processing_node_confirmation_link ?reconciliation_case ?confirmation_document)
        (not
          (confirmation_document_available ?confirmation_document)
        )
      )
  )
  (:action link_counterparty_account_to_case
    :parameters (?reconciliation_case - reconciliation_case ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (counterparty_account_available ?counterparty_account)
        (case_counterparty_candidate ?reconciliation_case ?counterparty_account)
      )
    :effect
      (and
        (case_has_counterparty_account ?reconciliation_case ?counterparty_account)
        (not
          (counterparty_account_available ?counterparty_account)
        )
      )
  )
  (:action create_ledger_posting_candidate
    :parameters (?reconciliation_case - reconciliation_case ?ledger_account - ledger_account ?payment_instruction - payment_instruction ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_batch_assigned ?reconciliation_case)
        (ledger_account_available ?ledger_account)
        (case_ledger_candidate_relation ?reconciliation_case ?ledger_account)
        (not
          (case_ledger_validated ?reconciliation_case)
        )
        (case_has_counterparty_account ?reconciliation_case ?counterparty_account)
        (case_has_payment_instruction ?reconciliation_case ?payment_instruction)
      )
    :effect
      (and
        (case_ledger_candidate ?reconciliation_case ?ledger_account)
        (not
          (ledger_account_available ?ledger_account)
        )
        (case_ledger_validated ?reconciliation_case)
      )
  )
  (:action finalize_case_resolution
    :parameters (?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_has_payment_instruction ?reconciliation_case ?payment_instruction)
        (case_resolution_in_progress ?reconciliation_case)
        (case_has_counterparty_account ?reconciliation_case ?counterparty_account)
        (case_requires_approval ?reconciliation_case)
      )
    :effect
      (and
        (not
          (case_accounting_review_flag ?reconciliation_case)
        )
        (not
          (case_requires_approval ?reconciliation_case)
        )
        (not
          (case_adjudicated ?reconciliation_case)
        )
        (case_resolution_complete ?reconciliation_case)
      )
  )
  (:action remove_suspense_tag_from_case
    :parameters (?reconciliation_case - reconciliation_case ?suspense_tag - suspense_tag)
    :precondition
      (and
        (case_has_suspense_tag ?reconciliation_case ?suspense_tag)
      )
    :effect
      (and
        (suspense_tag_available ?suspense_tag)
        (not
          (case_has_suspense_tag ?reconciliation_case ?suspense_tag)
        )
      )
  )
  (:action adjudicate_case_with_attachment
    :parameters (?reconciliation_case - reconciliation_case ?suspense_tag - suspense_tag ?supporting_attachment - supporting_attachment)
    :precondition
      (and
        (not
          (case_adjudicated ?reconciliation_case)
        )
        (case_batch_assigned ?reconciliation_case)
        (supporting_attachment_available ?supporting_attachment)
        (case_has_suspense_tag ?reconciliation_case ?suspense_tag)
        (case_on_hold ?reconciliation_case)
      )
    :effect
      (and
        (not
          (case_requires_approval ?reconciliation_case)
        )
        (case_adjudicated ?reconciliation_case)
      )
  )
  (:action perform_final_close_after_readiness
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (source_system_active ?reconciliation_case)
        (case_ready_for_close ?reconciliation_case)
        (case_batch_assigned ?reconciliation_case)
        (case_adjudicated ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
        (case_confirmation_pending ?reconciliation_case)
        (case_ledger_validated ?reconciliation_case)
        (case_resolution_in_progress ?reconciliation_case)
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action mark_case_ready_for_close
    :parameters (?reconciliation_case - reconciliation_case ?suspense_tag - suspense_tag ?supporting_attachment - supporting_attachment)
    :precondition
      (and
        (case_adjudicated ?reconciliation_case)
        (supporting_attachment_available ?supporting_attachment)
        (not
          (case_ready_for_close ?reconciliation_case)
        )
        (case_confirmation_pending ?reconciliation_case)
        (case_registered ?reconciliation_case)
        (source_system_active ?reconciliation_case)
        (case_has_suspense_tag ?reconciliation_case ?suspense_tag)
      )
    :effect
      (and
        (case_ready_for_close ?reconciliation_case)
      )
  )
  (:action unlink_payment_instruction_from_case
    :parameters (?reconciliation_case - reconciliation_case ?payment_instruction - payment_instruction)
    :precondition
      (and
        (case_has_payment_instruction ?reconciliation_case ?payment_instruction)
      )
    :effect
      (and
        (payment_instruction_available ?payment_instruction)
        (not
          (case_has_payment_instruction ?reconciliation_case ?payment_instruction)
        )
      )
  )
  (:action link_exception_code_to_case
    :parameters (?reconciliation_case - reconciliation_case ?exception_reason_code - exception_reason_code)
    :precondition
      (and
        (exception_reason_code_available ?exception_reason_code)
        (case_registered ?reconciliation_case)
        (case_exception_code_candidate ?reconciliation_case ?exception_reason_code)
      )
    :effect
      (and
        (case_exception_code ?reconciliation_case ?exception_reason_code)
        (not
          (exception_reason_code_available ?exception_reason_code)
        )
      )
  )
  (:action open_reconciliation_case
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
  (:action apply_automated_hold_and_flag_approval
    :parameters (?reconciliation_case - reconciliation_case ?automation_rule - automation_rule)
    :precondition
      (and
        (not
          (case_on_hold ?reconciliation_case)
        )
        (case_registered ?reconciliation_case)
        (automation_rule_available ?automation_rule)
        (case_batch_assigned ?reconciliation_case)
      )
    :effect
      (and
        (case_requires_approval ?reconciliation_case)
        (not
          (automation_rule_available ?automation_rule)
        )
        (case_on_hold ?reconciliation_case)
      )
  )
  (:action validate_and_create_ledger_candidate_with_bank_reference
    :parameters (?reconciliation_case - reconciliation_case ?ledger_account - ledger_account ?bank_statement_entry - bank_statement_entry ?bank_reference_file - bank_reference_file)
    :precondition
      (and
        (bank_reference_file_available ?bank_reference_file)
        (case_bank_reference_candidate ?reconciliation_case ?bank_reference_file)
        (not
          (case_ledger_validated ?reconciliation_case)
        )
        (case_batch_assigned ?reconciliation_case)
        (ledger_account_available ?ledger_account)
        (case_ledger_candidate_relation ?reconciliation_case ?ledger_account)
        (case_has_bank_entry ?reconciliation_case ?bank_statement_entry)
      )
    :effect
      (and
        (case_ledger_candidate ?reconciliation_case ?ledger_account)
        (not
          (bank_reference_file_available ?bank_reference_file)
        )
        (case_accounting_review_flag ?reconciliation_case)
        (not
          (ledger_account_available ?ledger_account)
        )
        (case_requires_approval ?reconciliation_case)
        (case_ledger_validated ?reconciliation_case)
      )
  )
  (:action mark_case_confirmation_pending_by_automation_rule
    :parameters (?reconciliation_case - reconciliation_case ?automation_rule - automation_rule)
    :precondition
      (and
        (automation_rule_available ?automation_rule)
        (not
          (case_requires_approval ?reconciliation_case)
        )
        (case_adjudicated ?reconciliation_case)
        (case_resolution_in_progress ?reconciliation_case)
        (not
          (case_confirmation_pending ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_confirmation_pending ?reconciliation_case)
        (not
          (automation_rule_available ?automation_rule)
        )
      )
  )
  (:action unassign_payment_batch_from_case
    :parameters (?reconciliation_case - reconciliation_case ?payment_batch - payment_batch)
    :precondition
      (and
        (case_assigned_batch ?reconciliation_case ?payment_batch)
        (not
          (case_resolution_in_progress ?reconciliation_case)
        )
        (not
          (case_ledger_validated ?reconciliation_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned_batch ?reconciliation_case ?payment_batch)
        )
        (payment_batch_available ?payment_batch)
        (not
          (case_batch_assigned ?reconciliation_case)
        )
        (not
          (case_on_hold ?reconciliation_case)
        )
        (not
          (case_resolution_complete ?reconciliation_case)
        )
        (not
          (case_adjudicated ?reconciliation_case)
        )
        (not
          (case_accounting_review_flag ?reconciliation_case)
        )
        (not
          (case_requires_approval ?reconciliation_case)
        )
      )
  )
  (:action mark_case_confirmation_pending_for_suspense_tag
    :parameters (?reconciliation_case - reconciliation_case ?suspense_tag - suspense_tag)
    :precondition
      (and
        (not
          (case_confirmation_pending ?reconciliation_case)
        )
        (case_has_suspense_tag ?reconciliation_case ?suspense_tag)
        (case_adjudicated ?reconciliation_case)
        (case_resolution_in_progress ?reconciliation_case)
        (not
          (case_requires_approval ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_confirmation_pending ?reconciliation_case)
      )
  )
  (:action perform_final_close_with_confirmation
    :parameters (?reconciliation_case - reconciliation_case ?confirmation_document - confirmation_document)
    :precondition
      (and
        (case_confirmation_pending ?reconciliation_case)
        (case_resolution_in_progress ?reconciliation_case)
        (case_ledger_validated ?reconciliation_case)
        (case_confirmation_recorded_from_source ?reconciliation_case ?confirmation_document)
        (case_adjudicated ?reconciliation_case)
        (case_batch_assigned ?reconciliation_case)
        (case_registered ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
        (source_system_active ?reconciliation_case)
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action apply_hold_from_suspense_tag
    :parameters (?reconciliation_case - reconciliation_case ?suspense_tag - suspense_tag)
    :precondition
      (and
        (case_registered ?reconciliation_case)
        (case_batch_assigned ?reconciliation_case)
        (not
          (case_on_hold ?reconciliation_case)
        )
        (case_has_suspense_tag ?reconciliation_case ?suspense_tag)
      )
    :effect
      (and
        (case_on_hold ?reconciliation_case)
      )
  )
  (:action assign_payment_batch_to_case
    :parameters (?reconciliation_case - reconciliation_case ?payment_batch - payment_batch)
    :precondition
      (and
        (not
          (case_batch_assigned ?reconciliation_case)
        )
        (case_registered ?reconciliation_case)
        (payment_batch_available ?payment_batch)
        (case_batch_candidate ?reconciliation_case ?payment_batch)
      )
    :effect
      (and
        (case_batch_assigned ?reconciliation_case)
        (not
          (payment_batch_available ?payment_batch)
        )
        (case_assigned_batch ?reconciliation_case ?payment_batch)
      )
  )
  (:action adjudicate_resolved_case_with_attachment
    :parameters (?reconciliation_case - reconciliation_case ?suspense_tag - suspense_tag ?supporting_attachment - supporting_attachment)
    :precondition
      (and
        (case_batch_assigned ?reconciliation_case)
        (not
          (case_adjudicated ?reconciliation_case)
        )
        (case_has_suspense_tag ?reconciliation_case ?suspense_tag)
        (case_resolution_in_progress ?reconciliation_case)
        (supporting_attachment_available ?supporting_attachment)
        (case_resolution_complete ?reconciliation_case)
      )
    :effect
      (and
        (case_adjudicated ?reconciliation_case)
      )
  )
  (:action record_external_confirmation_from_source
    :parameters (?source_system - source_system ?processing_node - processing_node ?confirmation_document - confirmation_document)
    :precondition
      (and
        (case_registered ?source_system)
        (processing_node_confirmation_link ?processing_node ?confirmation_document)
        (source_system_active ?source_system)
        (not
          (case_confirmation_recorded_from_source ?source_system ?confirmation_document)
        )
        (confirmation_available_from_source ?source_system ?confirmation_document)
      )
    :effect
      (and
        (case_confirmation_recorded_from_source ?source_system ?confirmation_document)
      )
  )
)

(define (domain finance_reconciliation_backoffice_audit_trail_exception_backfill)
  (:requirements :strips :typing :negative-preconditions)
  (:types audit_exception_case - generic_object ledger_account - generic_object recon_batch - generic_object counterparty_record - generic_object ledger_entry - generic_object source_file - generic_object statement_feed - generic_object approver - generic_object audit_check - generic_object analyst - generic_object reference_document - generic_object account_mapping - generic_object control_queue - generic_object processing_queue - control_queue escalation_queue - control_queue case_reference - audit_exception_case external_case_reference - audit_exception_case)
  (:predicates
    (approver_available ?approver - approver)
    (case_reserved_counterparty ?audit_exception_case - audit_exception_case ?counterparty_record - counterparty_record)
    (case_finalized ?audit_exception_case - audit_exception_case)
    (case_reserved_ledger_account ?audit_exception_case - audit_exception_case ?ledger_account - ledger_account)
    (case_assigned_to_queue ?audit_exception_case - audit_exception_case ?processing_queue - control_queue)
    (source_file_available ?source_file - source_file)
    (counterparty_available ?counterparty_record - counterparty_record)
    (case_has_account_mapping_association ?audit_exception_case - audit_exception_case ?account_mapping - account_mapping)
    (case_closed ?audit_exception_case - audit_exception_case)
    (case_triage_complete ?audit_exception_case - audit_exception_case)
    (eligible_ledger_for_case ?audit_exception_case - audit_exception_case ?ledger_account - ledger_account)
    (recon_batch_available ?recon_batch - recon_batch)
    (reference_document_available ?reference_document - reference_document)
    (statement_feed_available ?statement_feed - statement_feed)
    (case_validation_passed ?audit_exception_case - audit_exception_case)
    (eligible_counterparty_for_case ?audit_exception_case - audit_exception_case ?counterparty_record - counterparty_record)
    (case_reserved_account_mapping ?audit_exception_case - audit_exception_case ?account_mapping - account_mapping)
    (case_assigned_recon_batch ?audit_exception_case - audit_exception_case ?recon_batch - recon_batch)
    (case_ready_for_posting ?audit_exception_case - audit_exception_case)
    (eligible_source_file_for_case ?audit_exception_case - audit_exception_case ?source_file - source_file)
    (account_mapping_available ?account_mapping - account_mapping)
    (case_has_external_reference ?audit_exception_case - audit_exception_case)
    (case_reconciled ?audit_exception_case - audit_exception_case)
    (eligible_ledger_entry_for_case ?audit_exception_case - audit_exception_case ?ledger_entry - ledger_entry)
    (case_reserved_ledger_entry ?audit_exception_case - audit_exception_case ?ledger_entry - ledger_entry)
    (case_marked_for_manual_review ?audit_exception_case - audit_exception_case)
    (case_attached_statement_feed ?audit_exception_case - audit_exception_case ?statement_feed - statement_feed)
    (case_evidence_attached ?audit_exception_case - audit_exception_case)
    (case_has_reference_document_association ?audit_exception_case - audit_exception_case ?reference_document - reference_document)
    (case_registered ?audit_exception_case - audit_exception_case)
    (ledger_account_available ?ledger_account - ledger_account)
    (case_has_account_link ?audit_exception_case - audit_exception_case)
    (analyst_available ?analyst - analyst)
    (audit_check_available ?audit_check - audit_check)
    (case_reserved_source_file ?audit_exception_case - audit_exception_case ?source_file - source_file)
    (case_has_audit_check_link ?audit_exception_case - audit_exception_case ?audit_check - audit_check)
    (case_feed_validated ?audit_exception_case - audit_exception_case)
    (case_feed_confirmed ?audit_exception_case - audit_exception_case)
    (case_reference_links_to_audit_check ?audit_exception_case - audit_exception_case ?audit_check - audit_check)
    (ledger_entry_available ?ledger_entry - ledger_entry)
    (external_case_associated_audit_check ?audit_exception_case - audit_exception_case ?audit_check - audit_check)
    (eligible_recon_batch_for_case ?audit_exception_case - audit_exception_case ?recon_batch - recon_batch)
    (case_escalation_required ?audit_exception_case - audit_exception_case)
    (case_passed_audit_check ?audit_exception_case - audit_exception_case ?audit_check - audit_check)
  )
  (:action release_account_mapping_from_case
    :parameters (?audit_exception_case - audit_exception_case ?account_mapping - account_mapping)
    :precondition
      (and
        (case_reserved_account_mapping ?audit_exception_case ?account_mapping)
      )
    :effect
      (and
        (account_mapping_available ?account_mapping)
        (not
          (case_reserved_account_mapping ?audit_exception_case ?account_mapping)
        )
      )
  )
  (:action route_case_to_escalation_queue
    :parameters (?audit_exception_case - audit_exception_case ?source_file - source_file ?account_mapping - account_mapping ?escalation_queue - escalation_queue)
    :precondition
      (and
        (not
          (case_ready_for_posting ?audit_exception_case)
        )
        (case_validation_passed ?audit_exception_case)
        (case_reconciled ?audit_exception_case)
        (case_reserved_account_mapping ?audit_exception_case ?account_mapping)
        (case_assigned_to_queue ?audit_exception_case ?escalation_queue)
        (case_reserved_source_file ?audit_exception_case ?source_file)
      )
    :effect
      (and
        (case_escalation_required ?audit_exception_case)
        (case_ready_for_posting ?audit_exception_case)
      )
  )
  (:action close_case_if_validated
    :parameters (?audit_exception_case - audit_exception_case)
    :precondition
      (and
        (case_reconciled ?audit_exception_case)
        (case_has_account_link ?audit_exception_case)
        (case_validation_passed ?audit_exception_case)
        (case_registered ?audit_exception_case)
        (case_feed_confirmed ?audit_exception_case)
        (not
          (case_closed ?audit_exception_case)
        )
        (case_triage_complete ?audit_exception_case)
        (case_ready_for_posting ?audit_exception_case)
      )
    :effect
      (and
        (case_closed ?audit_exception_case)
      )
  )
  (:action clear_manual_review_and_escalation
    :parameters (?audit_exception_case - audit_exception_case ?ledger_entry - ledger_entry ?counterparty_record - counterparty_record)
    :precondition
      (and
        (case_validation_passed ?audit_exception_case)
        (case_marked_for_manual_review ?audit_exception_case)
        (case_reserved_ledger_entry ?audit_exception_case ?ledger_entry)
        (case_reserved_counterparty ?audit_exception_case ?counterparty_record)
      )
    :effect
      (and
        (not
          (case_marked_for_manual_review ?audit_exception_case)
        )
        (not
          (case_escalation_required ?audit_exception_case)
        )
      )
  )
  (:action attach_statement_feed_to_case
    :parameters (?audit_exception_case - audit_exception_case ?statement_feed - statement_feed)
    :precondition
      (and
        (statement_feed_available ?statement_feed)
        (case_registered ?audit_exception_case)
      )
    :effect
      (and
        (not
          (statement_feed_available ?statement_feed)
        )
        (case_attached_statement_feed ?audit_exception_case ?statement_feed)
      )
  )
  (:action route_case_to_processing_queue
    :parameters (?audit_exception_case - audit_exception_case ?ledger_entry - ledger_entry ?counterparty_record - counterparty_record ?processing_queue - processing_queue)
    :precondition
      (and
        (case_assigned_to_queue ?audit_exception_case ?processing_queue)
        (case_reconciled ?audit_exception_case)
        (not
          (case_escalation_required ?audit_exception_case)
        )
        (case_reserved_ledger_entry ?audit_exception_case ?ledger_entry)
        (case_validation_passed ?audit_exception_case)
        (case_reserved_counterparty ?audit_exception_case ?counterparty_record)
        (not
          (case_ready_for_posting ?audit_exception_case)
        )
      )
    :effect
      (and
        (case_ready_for_posting ?audit_exception_case)
      )
  )
  (:action apply_audit_check_for_case
    :parameters (?audit_exception_case - audit_exception_case ?audit_check - audit_check)
    :precondition
      (and
        (case_has_account_link ?audit_exception_case)
        (case_passed_audit_check ?audit_exception_case ?audit_check)
        (not
          (case_reconciled ?audit_exception_case)
        )
      )
    :effect
      (and
        (case_reconciled ?audit_exception_case)
        (not
          (case_escalation_required ?audit_exception_case)
        )
      )
  )
  (:action reserve_source_file_for_case
    :parameters (?audit_exception_case - audit_exception_case ?source_file - source_file)
    :precondition
      (and
        (eligible_source_file_for_case ?audit_exception_case ?source_file)
        (case_registered ?audit_exception_case)
        (source_file_available ?source_file)
      )
    :effect
      (and
        (case_reserved_source_file ?audit_exception_case ?source_file)
        (not
          (source_file_available ?source_file)
        )
      )
  )
  (:action reserve_ledger_entry_for_case
    :parameters (?audit_exception_case - audit_exception_case ?ledger_entry - ledger_entry)
    :precondition
      (and
        (case_registered ?audit_exception_case)
        (ledger_entry_available ?ledger_entry)
        (eligible_ledger_entry_for_case ?audit_exception_case ?ledger_entry)
      )
    :effect
      (and
        (not
          (ledger_entry_available ?ledger_entry)
        )
        (case_reserved_ledger_entry ?audit_exception_case ?ledger_entry)
      )
  )
  (:action release_source_file_from_case
    :parameters (?audit_exception_case - audit_exception_case ?source_file - source_file)
    :precondition
      (and
        (case_reserved_source_file ?audit_exception_case ?source_file)
      )
    :effect
      (and
        (source_file_available ?source_file)
        (not
          (case_reserved_source_file ?audit_exception_case ?source_file)
        )
      )
  )
  (:action release_counterparty_from_case
    :parameters (?audit_exception_case - audit_exception_case ?counterparty_record - counterparty_record)
    :precondition
      (and
        (case_reserved_counterparty ?audit_exception_case ?counterparty_record)
      )
    :effect
      (and
        (counterparty_available ?counterparty_record)
        (not
          (case_reserved_counterparty ?audit_exception_case ?counterparty_record)
        )
      )
  )
  (:action associate_case_with_audit_check
    :parameters (?audit_exception_case - audit_exception_case ?audit_check - audit_check)
    :precondition
      (and
        (case_feed_confirmed ?audit_exception_case)
        (audit_check_available ?audit_check)
        (case_reference_links_to_audit_check ?audit_exception_case ?audit_check)
      )
    :effect
      (and
        (case_has_audit_check_link ?audit_exception_case ?audit_check)
        (not
          (audit_check_available ?audit_check)
        )
      )
  )
  (:action reserve_counterparty_for_case
    :parameters (?audit_exception_case - audit_exception_case ?counterparty_record - counterparty_record)
    :precondition
      (and
        (case_registered ?audit_exception_case)
        (counterparty_available ?counterparty_record)
        (eligible_counterparty_for_case ?audit_exception_case ?counterparty_record)
      )
    :effect
      (and
        (case_reserved_counterparty ?audit_exception_case ?counterparty_record)
        (not
          (counterparty_available ?counterparty_record)
        )
      )
  )
  (:action assemble_reconciliation_batch
    :parameters (?audit_exception_case - audit_exception_case ?recon_batch - recon_batch ?ledger_entry - ledger_entry ?counterparty_record - counterparty_record)
    :precondition
      (and
        (case_has_account_link ?audit_exception_case)
        (recon_batch_available ?recon_batch)
        (eligible_recon_batch_for_case ?audit_exception_case ?recon_batch)
        (not
          (case_validation_passed ?audit_exception_case)
        )
        (case_reserved_counterparty ?audit_exception_case ?counterparty_record)
        (case_reserved_ledger_entry ?audit_exception_case ?ledger_entry)
      )
    :effect
      (and
        (case_assigned_recon_batch ?audit_exception_case ?recon_batch)
        (not
          (recon_batch_available ?recon_batch)
        )
        (case_validation_passed ?audit_exception_case)
      )
  )
  (:action post_case_and_finalize
    :parameters (?audit_exception_case - audit_exception_case ?ledger_entry - ledger_entry ?counterparty_record - counterparty_record)
    :precondition
      (and
        (case_reserved_ledger_entry ?audit_exception_case ?ledger_entry)
        (case_ready_for_posting ?audit_exception_case)
        (case_reserved_counterparty ?audit_exception_case ?counterparty_record)
        (case_escalation_required ?audit_exception_case)
      )
    :effect
      (and
        (not
          (case_marked_for_manual_review ?audit_exception_case)
        )
        (not
          (case_escalation_required ?audit_exception_case)
        )
        (not
          (case_reconciled ?audit_exception_case)
        )
        (case_finalized ?audit_exception_case)
      )
  )
  (:action detach_statement_feed_from_case
    :parameters (?audit_exception_case - audit_exception_case ?statement_feed - statement_feed)
    :precondition
      (and
        (case_attached_statement_feed ?audit_exception_case ?statement_feed)
      )
    :effect
      (and
        (statement_feed_available ?statement_feed)
        (not
          (case_attached_statement_feed ?audit_exception_case ?statement_feed)
        )
      )
  )
  (:action attach_analyst_evidence
    :parameters (?audit_exception_case - audit_exception_case ?statement_feed - statement_feed ?analyst - analyst)
    :precondition
      (and
        (not
          (case_reconciled ?audit_exception_case)
        )
        (case_has_account_link ?audit_exception_case)
        (analyst_available ?analyst)
        (case_attached_statement_feed ?audit_exception_case ?statement_feed)
        (case_feed_validated ?audit_exception_case)
      )
    :effect
      (and
        (not
          (case_escalation_required ?audit_exception_case)
        )
        (case_reconciled ?audit_exception_case)
      )
  )
  (:action close_case_with_evidence
    :parameters (?audit_exception_case - audit_exception_case)
    :precondition
      (and
        (case_registered ?audit_exception_case)
        (case_has_external_reference ?audit_exception_case)
        (case_evidence_attached ?audit_exception_case)
        (case_has_account_link ?audit_exception_case)
        (case_reconciled ?audit_exception_case)
        (not
          (case_closed ?audit_exception_case)
        )
        (case_feed_confirmed ?audit_exception_case)
        (case_validation_passed ?audit_exception_case)
        (case_ready_for_posting ?audit_exception_case)
      )
    :effect
      (and
        (case_closed ?audit_exception_case)
      )
  )
  (:action attach_analyst_evidence_and_mark
    :parameters (?audit_exception_case - audit_exception_case ?statement_feed - statement_feed ?analyst - analyst)
    :precondition
      (and
        (case_reconciled ?audit_exception_case)
        (analyst_available ?analyst)
        (not
          (case_evidence_attached ?audit_exception_case)
        )
        (case_feed_confirmed ?audit_exception_case)
        (case_registered ?audit_exception_case)
        (case_has_external_reference ?audit_exception_case)
        (case_attached_statement_feed ?audit_exception_case ?statement_feed)
      )
    :effect
      (and
        (case_evidence_attached ?audit_exception_case)
      )
  )
  (:action release_ledger_entry_from_case
    :parameters (?audit_exception_case - audit_exception_case ?ledger_entry - ledger_entry)
    :precondition
      (and
        (case_reserved_ledger_entry ?audit_exception_case ?ledger_entry)
      )
    :effect
      (and
        (ledger_entry_available ?ledger_entry)
        (not
          (case_reserved_ledger_entry ?audit_exception_case ?ledger_entry)
        )
      )
  )
  (:action reserve_account_mapping_for_case
    :parameters (?audit_exception_case - audit_exception_case ?account_mapping - account_mapping)
    :precondition
      (and
        (account_mapping_available ?account_mapping)
        (case_registered ?audit_exception_case)
        (case_has_account_mapping_association ?audit_exception_case ?account_mapping)
      )
    :effect
      (and
        (case_reserved_account_mapping ?audit_exception_case ?account_mapping)
        (not
          (account_mapping_available ?account_mapping)
        )
      )
  )
  (:action register_audit_exception_case
    :parameters (?audit_exception_case - audit_exception_case)
    :precondition
      (and
        (not
          (case_registered ?audit_exception_case)
        )
        (not
          (case_closed ?audit_exception_case)
        )
      )
    :effect
      (and
        (case_registered ?audit_exception_case)
      )
  )
  (:action approve_case
    :parameters (?audit_exception_case - audit_exception_case ?approver - approver)
    :precondition
      (and
        (not
          (case_feed_validated ?audit_exception_case)
        )
        (case_registered ?audit_exception_case)
        (approver_available ?approver)
        (case_has_account_link ?audit_exception_case)
      )
    :effect
      (and
        (case_escalation_required ?audit_exception_case)
        (not
          (approver_available ?approver)
        )
        (case_feed_validated ?audit_exception_case)
      )
  )
  (:action assemble_reconciliation_with_source_and_document
    :parameters (?audit_exception_case - audit_exception_case ?recon_batch - recon_batch ?source_file - source_file ?reference_document - reference_document)
    :precondition
      (and
        (reference_document_available ?reference_document)
        (case_has_reference_document_association ?audit_exception_case ?reference_document)
        (not
          (case_validation_passed ?audit_exception_case)
        )
        (case_has_account_link ?audit_exception_case)
        (recon_batch_available ?recon_batch)
        (eligible_recon_batch_for_case ?audit_exception_case ?recon_batch)
        (case_reserved_source_file ?audit_exception_case ?source_file)
      )
    :effect
      (and
        (case_assigned_recon_batch ?audit_exception_case ?recon_batch)
        (not
          (reference_document_available ?reference_document)
        )
        (case_marked_for_manual_review ?audit_exception_case)
        (not
          (recon_batch_available ?recon_batch)
        )
        (case_escalation_required ?audit_exception_case)
        (case_validation_passed ?audit_exception_case)
      )
  )
  (:action approver_confirm_feed_attachment
    :parameters (?audit_exception_case - audit_exception_case ?approver - approver)
    :precondition
      (and
        (approver_available ?approver)
        (not
          (case_escalation_required ?audit_exception_case)
        )
        (case_reconciled ?audit_exception_case)
        (case_ready_for_posting ?audit_exception_case)
        (not
          (case_feed_confirmed ?audit_exception_case)
        )
      )
    :effect
      (and
        (case_feed_confirmed ?audit_exception_case)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action unreserve_ledger_account_from_case
    :parameters (?audit_exception_case - audit_exception_case ?ledger_account - ledger_account)
    :precondition
      (and
        (case_reserved_ledger_account ?audit_exception_case ?ledger_account)
        (not
          (case_ready_for_posting ?audit_exception_case)
        )
        (not
          (case_validation_passed ?audit_exception_case)
        )
      )
    :effect
      (and
        (not
          (case_reserved_ledger_account ?audit_exception_case ?ledger_account)
        )
        (ledger_account_available ?ledger_account)
        (not
          (case_has_account_link ?audit_exception_case)
        )
        (not
          (case_feed_validated ?audit_exception_case)
        )
        (not
          (case_finalized ?audit_exception_case)
        )
        (not
          (case_reconciled ?audit_exception_case)
        )
        (not
          (case_marked_for_manual_review ?audit_exception_case)
        )
        (not
          (case_escalation_required ?audit_exception_case)
        )
      )
  )
  (:action confirm_statement_feed_attachment
    :parameters (?audit_exception_case - audit_exception_case ?statement_feed - statement_feed)
    :precondition
      (and
        (not
          (case_feed_confirmed ?audit_exception_case)
        )
        (case_attached_statement_feed ?audit_exception_case ?statement_feed)
        (case_reconciled ?audit_exception_case)
        (case_ready_for_posting ?audit_exception_case)
        (not
          (case_escalation_required ?audit_exception_case)
        )
      )
    :effect
      (and
        (case_feed_confirmed ?audit_exception_case)
      )
  )
  (:action close_case_with_audit_check
    :parameters (?audit_exception_case - audit_exception_case ?audit_check - audit_check)
    :precondition
      (and
        (case_feed_confirmed ?audit_exception_case)
        (case_ready_for_posting ?audit_exception_case)
        (case_validation_passed ?audit_exception_case)
        (case_passed_audit_check ?audit_exception_case ?audit_check)
        (case_reconciled ?audit_exception_case)
        (case_has_account_link ?audit_exception_case)
        (case_registered ?audit_exception_case)
        (not
          (case_closed ?audit_exception_case)
        )
        (case_has_external_reference ?audit_exception_case)
      )
    :effect
      (and
        (case_closed ?audit_exception_case)
      )
  )
  (:action validate_feed_for_case
    :parameters (?audit_exception_case - audit_exception_case ?statement_feed - statement_feed)
    :precondition
      (and
        (case_registered ?audit_exception_case)
        (case_has_account_link ?audit_exception_case)
        (not
          (case_feed_validated ?audit_exception_case)
        )
        (case_attached_statement_feed ?audit_exception_case ?statement_feed)
      )
    :effect
      (and
        (case_feed_validated ?audit_exception_case)
      )
  )
  (:action reserve_ledger_account_for_case
    :parameters (?audit_exception_case - audit_exception_case ?ledger_account - ledger_account)
    :precondition
      (and
        (not
          (case_has_account_link ?audit_exception_case)
        )
        (case_registered ?audit_exception_case)
        (ledger_account_available ?ledger_account)
        (eligible_ledger_for_case ?audit_exception_case ?ledger_account)
      )
    :effect
      (and
        (case_has_account_link ?audit_exception_case)
        (not
          (ledger_account_available ?ledger_account)
        )
        (case_reserved_ledger_account ?audit_exception_case ?ledger_account)
      )
  )
  (:action reattach_feed_and_revalidate_case
    :parameters (?audit_exception_case - audit_exception_case ?statement_feed - statement_feed ?analyst - analyst)
    :precondition
      (and
        (case_has_account_link ?audit_exception_case)
        (not
          (case_reconciled ?audit_exception_case)
        )
        (case_attached_statement_feed ?audit_exception_case ?statement_feed)
        (case_ready_for_posting ?audit_exception_case)
        (analyst_available ?analyst)
        (case_finalized ?audit_exception_case)
      )
    :effect
      (and
        (case_reconciled ?audit_exception_case)
      )
  )
  (:action register_external_case_reference_and_link_audit_check
    :parameters (?external_case_reference - external_case_reference ?case_reference - case_reference ?audit_check - audit_check)
    :precondition
      (and
        (case_registered ?external_case_reference)
        (case_has_audit_check_link ?case_reference ?audit_check)
        (case_has_external_reference ?external_case_reference)
        (not
          (case_passed_audit_check ?external_case_reference ?audit_check)
        )
        (external_case_associated_audit_check ?external_case_reference ?audit_check)
      )
    :effect
      (and
        (case_passed_audit_check ?external_case_reference ?audit_check)
      )
  )
)

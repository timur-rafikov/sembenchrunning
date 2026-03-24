(define (domain posting_period_cutoff_enforcement)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_supertype - object document_supertype - object artifact_supertype - object case_supertype - object closeable_item - case_supertype reviewer - resource_supertype cutoff_check_tool - resource_supertype approver - resource_supertype escalation_notice - resource_supertype compliance_seal - resource_supertype closure_certificate - resource_supertype management_approval - resource_supertype auditor_confirmation - resource_supertype adjustment_reason_code - document_supertype evidence_document - document_supertype audit_attachment - document_supertype cutoff_window - artifact_supertype variance_bucket - artifact_supertype submission_package - artifact_supertype account_supertype - closeable_item package_supertype - closeable_item ledger - account_supertype subledger - account_supertype close_case - package_supertype)
  (:predicates
    (cutoff_item_identified ?closeable_item - closeable_item)
    (validation_completed ?closeable_item - closeable_item)
    (under_review ?closeable_item - closeable_item)
    (period_closed ?closeable_item - closeable_item)
    (ready_for_closure ?closeable_item - closeable_item)
    (closure_certificate_attached ?closeable_item - closeable_item)
    (reviewer_available ?reviewer - reviewer)
    (assigned_reviewer ?closeable_item - closeable_item ?reviewer - reviewer)
    (cutoff_check_tool_available ?cutoff_check_tool - cutoff_check_tool)
    (assigned_check_tool ?closeable_item - closeable_item ?cutoff_check_tool - cutoff_check_tool)
    (approver_available ?approver - approver)
    (assigned_approver ?closeable_item - closeable_item ?approver - approver)
    (adjustment_reason_available ?adjustment_reason_code - adjustment_reason_code)
    (ledger_has_adjustment_reason ?ledger - ledger ?adjustment_reason_code - adjustment_reason_code)
    (subledger_has_adjustment_reason ?subledger - subledger ?adjustment_reason_code - adjustment_reason_code)
    (ledger_linked_cutoff_window ?ledger - ledger ?cutoff_window - cutoff_window)
    (cutoff_window_confirmed ?cutoff_window - cutoff_window)
    (cutoff_window_adjustment_flagged ?cutoff_window - cutoff_window)
    (ledger_adjustment_recorded ?ledger - ledger)
    (subledger_linked_variance_bucket ?subledger - subledger ?variance_bucket - variance_bucket)
    (variance_bucket_confirmed ?variance_bucket - variance_bucket)
    (variance_bucket_adjustment_flagged ?variance_bucket - variance_bucket)
    (subledger_adjustment_recorded ?subledger - subledger)
    (submission_package_available ?submission_package - submission_package)
    (submission_package_assembled ?submission_package - submission_package)
    (package_includes_cutoff_window ?submission_package - submission_package ?cutoff_window - cutoff_window)
    (package_includes_variance_bucket ?submission_package - submission_package ?variance_bucket - variance_bucket)
    (package_stage_ledger_confirmed ?submission_package - submission_package)
    (package_stage_subledger_confirmed ?submission_package - submission_package)
    (package_ready_for_evidence ?submission_package - submission_package)
    (close_case_linked_ledger ?close_case - close_case ?ledger - ledger)
    (close_case_linked_subledger ?close_case - close_case ?subledger - subledger)
    (close_case_includes_package ?close_case - close_case ?submission_package - submission_package)
    (evidence_document_available ?evidence_document - evidence_document)
    (close_case_has_evidence ?close_case - close_case ?evidence_document - evidence_document)
    (evidence_document_attached ?evidence_document - evidence_document)
    (evidence_attached_to_package ?evidence_document - evidence_document ?submission_package - submission_package)
    (case_documents_validated ?close_case - close_case)
    (management_signoff_recorded ?close_case - close_case)
    (case_ready_for_finalization ?close_case - close_case)
    (case_escalation_attached ?close_case - close_case)
    (case_escalation_processed ?close_case - close_case)
    (compliance_seal_required ?close_case - close_case)
    (case_controls_verified ?close_case - close_case)
    (audit_attachment_available ?audit_attachment - audit_attachment)
    (close_case_has_audit_attachment ?close_case - close_case ?audit_attachment - audit_attachment)
    (audit_attachment_processed ?close_case - close_case)
    (auditor_confirmation_requested ?close_case - close_case)
    (auditor_confirmation_received ?close_case - close_case)
    (escalation_notice_available ?escalation_notice - escalation_notice)
    (close_case_linked_escalation_notice ?close_case - close_case ?escalation_notice - escalation_notice)
    (compliance_seal_available ?compliance_seal - compliance_seal)
    (close_case_has_compliance_seal ?close_case - close_case ?compliance_seal - compliance_seal)
    (management_approval_available ?management_approval - management_approval)
    (case_has_management_approval ?close_case - close_case ?management_approval - management_approval)
    (auditor_confirmation_available ?auditor_confirmation - auditor_confirmation)
    (case_has_auditor_confirmation ?close_case - close_case ?auditor_confirmation - auditor_confirmation)
    (closure_certificate_available ?closure_certificate - closure_certificate)
    (closure_certificate_linked ?closeable_item - closeable_item ?closure_certificate - closure_certificate)
    (ledger_ready_for_submission ?ledger - ledger)
    (subledger_ready_for_submission ?subledger - subledger)
    (close_case_finalized ?close_case - close_case)
  )
  (:action identify_cutoff_item
    :parameters (?closeable_item - closeable_item)
    :precondition
      (and
        (not
          (cutoff_item_identified ?closeable_item)
        )
        (not
          (period_closed ?closeable_item)
        )
      )
    :effect (cutoff_item_identified ?closeable_item)
  )
  (:action assign_reviewer_to_item
    :parameters (?closeable_item - closeable_item ?reviewer - reviewer)
    :precondition
      (and
        (cutoff_item_identified ?closeable_item)
        (not
          (under_review ?closeable_item)
        )
        (reviewer_available ?reviewer)
      )
    :effect
      (and
        (under_review ?closeable_item)
        (assigned_reviewer ?closeable_item ?reviewer)
        (not
          (reviewer_available ?reviewer)
        )
      )
  )
  (:action assign_and_run_cutoff_check
    :parameters (?closeable_item - closeable_item ?cutoff_check_tool - cutoff_check_tool)
    :precondition
      (and
        (cutoff_item_identified ?closeable_item)
        (under_review ?closeable_item)
        (cutoff_check_tool_available ?cutoff_check_tool)
      )
    :effect
      (and
        (assigned_check_tool ?closeable_item ?cutoff_check_tool)
        (not
          (cutoff_check_tool_available ?cutoff_check_tool)
        )
      )
  )
  (:action finalize_cutoff_validation
    :parameters (?closeable_item - closeable_item ?cutoff_check_tool - cutoff_check_tool)
    :precondition
      (and
        (cutoff_item_identified ?closeable_item)
        (under_review ?closeable_item)
        (assigned_check_tool ?closeable_item ?cutoff_check_tool)
        (not
          (validation_completed ?closeable_item)
        )
      )
    :effect (validation_completed ?closeable_item)
  )
  (:action release_cutoff_check_tool
    :parameters (?closeable_item - closeable_item ?cutoff_check_tool - cutoff_check_tool)
    :precondition
      (and
        (assigned_check_tool ?closeable_item ?cutoff_check_tool)
      )
    :effect
      (and
        (cutoff_check_tool_available ?cutoff_check_tool)
        (not
          (assigned_check_tool ?closeable_item ?cutoff_check_tool)
        )
      )
  )
  (:action assign_approver_to_item
    :parameters (?closeable_item - closeable_item ?approver - approver)
    :precondition
      (and
        (validation_completed ?closeable_item)
        (approver_available ?approver)
      )
    :effect
      (and
        (assigned_approver ?closeable_item ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action release_approver_from_item
    :parameters (?closeable_item - closeable_item ?approver - approver)
    :precondition
      (and
        (assigned_approver ?closeable_item ?approver)
      )
    :effect
      (and
        (approver_available ?approver)
        (not
          (assigned_approver ?closeable_item ?approver)
        )
      )
  )
  (:action attach_management_approval_to_case
    :parameters (?close_case - close_case ?management_approval - management_approval)
    :precondition
      (and
        (validation_completed ?close_case)
        (management_approval_available ?management_approval)
      )
    :effect
      (and
        (case_has_management_approval ?close_case ?management_approval)
        (not
          (management_approval_available ?management_approval)
        )
      )
  )
  (:action detach_management_approval_from_case
    :parameters (?close_case - close_case ?management_approval - management_approval)
    :precondition
      (and
        (case_has_management_approval ?close_case ?management_approval)
      )
    :effect
      (and
        (management_approval_available ?management_approval)
        (not
          (case_has_management_approval ?close_case ?management_approval)
        )
      )
  )
  (:action attach_auditor_confirmation_to_case
    :parameters (?close_case - close_case ?auditor_confirmation - auditor_confirmation)
    :precondition
      (and
        (validation_completed ?close_case)
        (auditor_confirmation_available ?auditor_confirmation)
      )
    :effect
      (and
        (case_has_auditor_confirmation ?close_case ?auditor_confirmation)
        (not
          (auditor_confirmation_available ?auditor_confirmation)
        )
      )
  )
  (:action detach_auditor_confirmation_from_case
    :parameters (?close_case - close_case ?auditor_confirmation - auditor_confirmation)
    :precondition
      (and
        (case_has_auditor_confirmation ?close_case ?auditor_confirmation)
      )
    :effect
      (and
        (auditor_confirmation_available ?auditor_confirmation)
        (not
          (case_has_auditor_confirmation ?close_case ?auditor_confirmation)
        )
      )
  )
  (:action confirm_cutoff_window_for_ledger
    :parameters (?ledger - ledger ?cutoff_window - cutoff_window ?cutoff_check_tool - cutoff_check_tool)
    :precondition
      (and
        (validation_completed ?ledger)
        (assigned_check_tool ?ledger ?cutoff_check_tool)
        (ledger_linked_cutoff_window ?ledger ?cutoff_window)
        (not
          (cutoff_window_confirmed ?cutoff_window)
        )
        (not
          (cutoff_window_adjustment_flagged ?cutoff_window)
        )
      )
    :effect (cutoff_window_confirmed ?cutoff_window)
  )
  (:action approve_ledger_adjustment
    :parameters (?ledger - ledger ?cutoff_window - cutoff_window ?approver - approver)
    :precondition
      (and
        (validation_completed ?ledger)
        (assigned_approver ?ledger ?approver)
        (ledger_linked_cutoff_window ?ledger ?cutoff_window)
        (cutoff_window_confirmed ?cutoff_window)
        (not
          (ledger_ready_for_submission ?ledger)
        )
      )
    :effect
      (and
        (ledger_ready_for_submission ?ledger)
        (ledger_adjustment_recorded ?ledger)
      )
  )
  (:action apply_adjustment_reason_to_ledger
    :parameters (?ledger - ledger ?cutoff_window - cutoff_window ?adjustment_reason_code - adjustment_reason_code)
    :precondition
      (and
        (validation_completed ?ledger)
        (ledger_linked_cutoff_window ?ledger ?cutoff_window)
        (adjustment_reason_available ?adjustment_reason_code)
        (not
          (ledger_ready_for_submission ?ledger)
        )
      )
    :effect
      (and
        (cutoff_window_adjustment_flagged ?cutoff_window)
        (ledger_ready_for_submission ?ledger)
        (ledger_has_adjustment_reason ?ledger ?adjustment_reason_code)
        (not
          (adjustment_reason_available ?adjustment_reason_code)
        )
      )
  )
  (:action process_ledger_adjustment
    :parameters (?ledger - ledger ?cutoff_window - cutoff_window ?cutoff_check_tool - cutoff_check_tool ?adjustment_reason_code - adjustment_reason_code)
    :precondition
      (and
        (validation_completed ?ledger)
        (assigned_check_tool ?ledger ?cutoff_check_tool)
        (ledger_linked_cutoff_window ?ledger ?cutoff_window)
        (cutoff_window_adjustment_flagged ?cutoff_window)
        (ledger_has_adjustment_reason ?ledger ?adjustment_reason_code)
        (not
          (ledger_adjustment_recorded ?ledger)
        )
      )
    :effect
      (and
        (cutoff_window_confirmed ?cutoff_window)
        (ledger_adjustment_recorded ?ledger)
        (adjustment_reason_available ?adjustment_reason_code)
        (not
          (ledger_has_adjustment_reason ?ledger ?adjustment_reason_code)
        )
      )
  )
  (:action confirm_variance_bucket_for_subledger
    :parameters (?subledger - subledger ?variance_bucket - variance_bucket ?cutoff_check_tool - cutoff_check_tool)
    :precondition
      (and
        (validation_completed ?subledger)
        (assigned_check_tool ?subledger ?cutoff_check_tool)
        (subledger_linked_variance_bucket ?subledger ?variance_bucket)
        (not
          (variance_bucket_confirmed ?variance_bucket)
        )
        (not
          (variance_bucket_adjustment_flagged ?variance_bucket)
        )
      )
    :effect (variance_bucket_confirmed ?variance_bucket)
  )
  (:action approve_subledger_adjustment
    :parameters (?subledger - subledger ?variance_bucket - variance_bucket ?approver - approver)
    :precondition
      (and
        (validation_completed ?subledger)
        (assigned_approver ?subledger ?approver)
        (subledger_linked_variance_bucket ?subledger ?variance_bucket)
        (variance_bucket_confirmed ?variance_bucket)
        (not
          (subledger_ready_for_submission ?subledger)
        )
      )
    :effect
      (and
        (subledger_ready_for_submission ?subledger)
        (subledger_adjustment_recorded ?subledger)
      )
  )
  (:action apply_adjustment_reason_to_subledger
    :parameters (?subledger - subledger ?variance_bucket - variance_bucket ?adjustment_reason_code - adjustment_reason_code)
    :precondition
      (and
        (validation_completed ?subledger)
        (subledger_linked_variance_bucket ?subledger ?variance_bucket)
        (adjustment_reason_available ?adjustment_reason_code)
        (not
          (subledger_ready_for_submission ?subledger)
        )
      )
    :effect
      (and
        (variance_bucket_adjustment_flagged ?variance_bucket)
        (subledger_ready_for_submission ?subledger)
        (subledger_has_adjustment_reason ?subledger ?adjustment_reason_code)
        (not
          (adjustment_reason_available ?adjustment_reason_code)
        )
      )
  )
  (:action process_subledger_adjustment
    :parameters (?subledger - subledger ?variance_bucket - variance_bucket ?cutoff_check_tool - cutoff_check_tool ?adjustment_reason_code - adjustment_reason_code)
    :precondition
      (and
        (validation_completed ?subledger)
        (assigned_check_tool ?subledger ?cutoff_check_tool)
        (subledger_linked_variance_bucket ?subledger ?variance_bucket)
        (variance_bucket_adjustment_flagged ?variance_bucket)
        (subledger_has_adjustment_reason ?subledger ?adjustment_reason_code)
        (not
          (subledger_adjustment_recorded ?subledger)
        )
      )
    :effect
      (and
        (variance_bucket_confirmed ?variance_bucket)
        (subledger_adjustment_recorded ?subledger)
        (adjustment_reason_available ?adjustment_reason_code)
        (not
          (subledger_has_adjustment_reason ?subledger ?adjustment_reason_code)
        )
      )
  )
  (:action assemble_submission_package_basic
    :parameters (?ledger - ledger ?subledger - subledger ?cutoff_window - cutoff_window ?variance_bucket - variance_bucket ?submission_package - submission_package)
    :precondition
      (and
        (ledger_ready_for_submission ?ledger)
        (subledger_ready_for_submission ?subledger)
        (ledger_linked_cutoff_window ?ledger ?cutoff_window)
        (subledger_linked_variance_bucket ?subledger ?variance_bucket)
        (cutoff_window_confirmed ?cutoff_window)
        (variance_bucket_confirmed ?variance_bucket)
        (ledger_adjustment_recorded ?ledger)
        (subledger_adjustment_recorded ?subledger)
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_assembled ?submission_package)
        (package_includes_cutoff_window ?submission_package ?cutoff_window)
        (package_includes_variance_bucket ?submission_package ?variance_bucket)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_ledger_confirmed
    :parameters (?ledger - ledger ?subledger - subledger ?cutoff_window - cutoff_window ?variance_bucket - variance_bucket ?submission_package - submission_package)
    :precondition
      (and
        (ledger_ready_for_submission ?ledger)
        (subledger_ready_for_submission ?subledger)
        (ledger_linked_cutoff_window ?ledger ?cutoff_window)
        (subledger_linked_variance_bucket ?subledger ?variance_bucket)
        (cutoff_window_adjustment_flagged ?cutoff_window)
        (variance_bucket_confirmed ?variance_bucket)
        (not
          (ledger_adjustment_recorded ?ledger)
        )
        (subledger_adjustment_recorded ?subledger)
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_assembled ?submission_package)
        (package_includes_cutoff_window ?submission_package ?cutoff_window)
        (package_includes_variance_bucket ?submission_package ?variance_bucket)
        (package_stage_ledger_confirmed ?submission_package)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_subledger_confirmed
    :parameters (?ledger - ledger ?subledger - subledger ?cutoff_window - cutoff_window ?variance_bucket - variance_bucket ?submission_package - submission_package)
    :precondition
      (and
        (ledger_ready_for_submission ?ledger)
        (subledger_ready_for_submission ?subledger)
        (ledger_linked_cutoff_window ?ledger ?cutoff_window)
        (subledger_linked_variance_bucket ?subledger ?variance_bucket)
        (cutoff_window_confirmed ?cutoff_window)
        (variance_bucket_adjustment_flagged ?variance_bucket)
        (ledger_adjustment_recorded ?ledger)
        (not
          (subledger_adjustment_recorded ?subledger)
        )
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_assembled ?submission_package)
        (package_includes_cutoff_window ?submission_package ?cutoff_window)
        (package_includes_variance_bucket ?submission_package ?variance_bucket)
        (package_stage_subledger_confirmed ?submission_package)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_fully_confirmed
    :parameters (?ledger - ledger ?subledger - subledger ?cutoff_window - cutoff_window ?variance_bucket - variance_bucket ?submission_package - submission_package)
    :precondition
      (and
        (ledger_ready_for_submission ?ledger)
        (subledger_ready_for_submission ?subledger)
        (ledger_linked_cutoff_window ?ledger ?cutoff_window)
        (subledger_linked_variance_bucket ?subledger ?variance_bucket)
        (cutoff_window_adjustment_flagged ?cutoff_window)
        (variance_bucket_adjustment_flagged ?variance_bucket)
        (not
          (ledger_adjustment_recorded ?ledger)
        )
        (not
          (subledger_adjustment_recorded ?subledger)
        )
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_assembled ?submission_package)
        (package_includes_cutoff_window ?submission_package ?cutoff_window)
        (package_includes_variance_bucket ?submission_package ?variance_bucket)
        (package_stage_ledger_confirmed ?submission_package)
        (package_stage_subledger_confirmed ?submission_package)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action mark_package_ready_for_evidence_collection
    :parameters (?submission_package - submission_package ?ledger - ledger ?cutoff_check_tool - cutoff_check_tool)
    :precondition
      (and
        (submission_package_assembled ?submission_package)
        (ledger_ready_for_submission ?ledger)
        (assigned_check_tool ?ledger ?cutoff_check_tool)
        (not
          (package_ready_for_evidence ?submission_package)
        )
      )
    :effect (package_ready_for_evidence ?submission_package)
  )
  (:action ingest_evidence_document
    :parameters (?close_case - close_case ?evidence_document - evidence_document ?submission_package - submission_package)
    :precondition
      (and
        (validation_completed ?close_case)
        (close_case_includes_package ?close_case ?submission_package)
        (close_case_has_evidence ?close_case ?evidence_document)
        (evidence_document_available ?evidence_document)
        (submission_package_assembled ?submission_package)
        (package_ready_for_evidence ?submission_package)
        (not
          (evidence_document_attached ?evidence_document)
        )
      )
    :effect
      (and
        (evidence_document_attached ?evidence_document)
        (evidence_attached_to_package ?evidence_document ?submission_package)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action validate_case_documents
    :parameters (?close_case - close_case ?evidence_document - evidence_document ?submission_package - submission_package ?cutoff_check_tool - cutoff_check_tool)
    :precondition
      (and
        (validation_completed ?close_case)
        (close_case_has_evidence ?close_case ?evidence_document)
        (evidence_document_attached ?evidence_document)
        (evidence_attached_to_package ?evidence_document ?submission_package)
        (assigned_check_tool ?close_case ?cutoff_check_tool)
        (not
          (package_stage_ledger_confirmed ?submission_package)
        )
        (not
          (case_documents_validated ?close_case)
        )
      )
    :effect (case_documents_validated ?close_case)
  )
  (:action attach_escalation_notice_to_case
    :parameters (?close_case - close_case ?escalation_notice - escalation_notice)
    :precondition
      (and
        (validation_completed ?close_case)
        (escalation_notice_available ?escalation_notice)
        (not
          (case_escalation_attached ?close_case)
        )
      )
    :effect
      (and
        (case_escalation_attached ?close_case)
        (close_case_linked_escalation_notice ?close_case ?escalation_notice)
        (not
          (escalation_notice_available ?escalation_notice)
        )
      )
  )
  (:action process_escalation_notice_for_case
    :parameters (?close_case - close_case ?evidence_document - evidence_document ?submission_package - submission_package ?cutoff_check_tool - cutoff_check_tool ?escalation_notice - escalation_notice)
    :precondition
      (and
        (validation_completed ?close_case)
        (close_case_has_evidence ?close_case ?evidence_document)
        (evidence_document_attached ?evidence_document)
        (evidence_attached_to_package ?evidence_document ?submission_package)
        (assigned_check_tool ?close_case ?cutoff_check_tool)
        (package_stage_ledger_confirmed ?submission_package)
        (case_escalation_attached ?close_case)
        (close_case_linked_escalation_notice ?close_case ?escalation_notice)
        (not
          (case_documents_validated ?close_case)
        )
      )
    :effect
      (and
        (case_documents_validated ?close_case)
        (case_escalation_processed ?close_case)
      )
  )
  (:action record_management_signoff_unstaged
    :parameters (?close_case - close_case ?management_approval - management_approval ?approver - approver ?evidence_document - evidence_document ?submission_package - submission_package)
    :precondition
      (and
        (case_documents_validated ?close_case)
        (case_has_management_approval ?close_case ?management_approval)
        (assigned_approver ?close_case ?approver)
        (close_case_has_evidence ?close_case ?evidence_document)
        (evidence_attached_to_package ?evidence_document ?submission_package)
        (not
          (package_stage_subledger_confirmed ?submission_package)
        )
        (not
          (management_signoff_recorded ?close_case)
        )
      )
    :effect (management_signoff_recorded ?close_case)
  )
  (:action record_management_signoff_staged
    :parameters (?close_case - close_case ?management_approval - management_approval ?approver - approver ?evidence_document - evidence_document ?submission_package - submission_package)
    :precondition
      (and
        (case_documents_validated ?close_case)
        (case_has_management_approval ?close_case ?management_approval)
        (assigned_approver ?close_case ?approver)
        (close_case_has_evidence ?close_case ?evidence_document)
        (evidence_attached_to_package ?evidence_document ?submission_package)
        (package_stage_subledger_confirmed ?submission_package)
        (not
          (management_signoff_recorded ?close_case)
        )
      )
    :effect (management_signoff_recorded ?close_case)
  )
  (:action apply_auditor_confirmation_unstaged
    :parameters (?close_case - close_case ?auditor_confirmation - auditor_confirmation ?evidence_document - evidence_document ?submission_package - submission_package)
    :precondition
      (and
        (management_signoff_recorded ?close_case)
        (case_has_auditor_confirmation ?close_case ?auditor_confirmation)
        (close_case_has_evidence ?close_case ?evidence_document)
        (evidence_attached_to_package ?evidence_document ?submission_package)
        (not
          (package_stage_ledger_confirmed ?submission_package)
        )
        (not
          (package_stage_subledger_confirmed ?submission_package)
        )
        (not
          (case_ready_for_finalization ?close_case)
        )
      )
    :effect (case_ready_for_finalization ?close_case)
  )
  (:action apply_auditor_confirmation_with_ledger_stage
    :parameters (?close_case - close_case ?auditor_confirmation - auditor_confirmation ?evidence_document - evidence_document ?submission_package - submission_package)
    :precondition
      (and
        (management_signoff_recorded ?close_case)
        (case_has_auditor_confirmation ?close_case ?auditor_confirmation)
        (close_case_has_evidence ?close_case ?evidence_document)
        (evidence_attached_to_package ?evidence_document ?submission_package)
        (package_stage_ledger_confirmed ?submission_package)
        (not
          (package_stage_subledger_confirmed ?submission_package)
        )
        (not
          (case_ready_for_finalization ?close_case)
        )
      )
    :effect
      (and
        (case_ready_for_finalization ?close_case)
        (compliance_seal_required ?close_case)
      )
  )
  (:action apply_auditor_confirmation_with_subledger_stage
    :parameters (?close_case - close_case ?auditor_confirmation - auditor_confirmation ?evidence_document - evidence_document ?submission_package - submission_package)
    :precondition
      (and
        (management_signoff_recorded ?close_case)
        (case_has_auditor_confirmation ?close_case ?auditor_confirmation)
        (close_case_has_evidence ?close_case ?evidence_document)
        (evidence_attached_to_package ?evidence_document ?submission_package)
        (not
          (package_stage_ledger_confirmed ?submission_package)
        )
        (package_stage_subledger_confirmed ?submission_package)
        (not
          (case_ready_for_finalization ?close_case)
        )
      )
    :effect
      (and
        (case_ready_for_finalization ?close_case)
        (compliance_seal_required ?close_case)
      )
  )
  (:action apply_auditor_confirmation_with_both_stages
    :parameters (?close_case - close_case ?auditor_confirmation - auditor_confirmation ?evidence_document - evidence_document ?submission_package - submission_package)
    :precondition
      (and
        (management_signoff_recorded ?close_case)
        (case_has_auditor_confirmation ?close_case ?auditor_confirmation)
        (close_case_has_evidence ?close_case ?evidence_document)
        (evidence_attached_to_package ?evidence_document ?submission_package)
        (package_stage_ledger_confirmed ?submission_package)
        (package_stage_subledger_confirmed ?submission_package)
        (not
          (case_ready_for_finalization ?close_case)
        )
      )
    :effect
      (and
        (case_ready_for_finalization ?close_case)
        (compliance_seal_required ?close_case)
      )
  )
  (:action finalize_case_without_compliance_seal
    :parameters (?close_case - close_case)
    :precondition
      (and
        (case_ready_for_finalization ?close_case)
        (not
          (compliance_seal_required ?close_case)
        )
        (not
          (close_case_finalized ?close_case)
        )
      )
    :effect
      (and
        (close_case_finalized ?close_case)
        (ready_for_closure ?close_case)
      )
  )
  (:action apply_compliance_seal_to_case
    :parameters (?close_case - close_case ?compliance_seal - compliance_seal)
    :precondition
      (and
        (case_ready_for_finalization ?close_case)
        (compliance_seal_required ?close_case)
        (compliance_seal_available ?compliance_seal)
      )
    :effect
      (and
        (close_case_has_compliance_seal ?close_case ?compliance_seal)
        (not
          (compliance_seal_available ?compliance_seal)
        )
      )
  )
  (:action perform_control_checks_on_case
    :parameters (?close_case - close_case ?ledger - ledger ?subledger - subledger ?cutoff_check_tool - cutoff_check_tool ?compliance_seal - compliance_seal)
    :precondition
      (and
        (case_ready_for_finalization ?close_case)
        (compliance_seal_required ?close_case)
        (close_case_has_compliance_seal ?close_case ?compliance_seal)
        (close_case_linked_ledger ?close_case ?ledger)
        (close_case_linked_subledger ?close_case ?subledger)
        (ledger_adjustment_recorded ?ledger)
        (subledger_adjustment_recorded ?subledger)
        (assigned_check_tool ?close_case ?cutoff_check_tool)
        (not
          (case_controls_verified ?close_case)
        )
      )
    :effect (case_controls_verified ?close_case)
  )
  (:action finalize_case_after_controls
    :parameters (?close_case - close_case)
    :precondition
      (and
        (case_ready_for_finalization ?close_case)
        (case_controls_verified ?close_case)
        (not
          (close_case_finalized ?close_case)
        )
      )
    :effect
      (and
        (close_case_finalized ?close_case)
        (ready_for_closure ?close_case)
      )
  )
  (:action record_audit_attachment_processing
    :parameters (?close_case - close_case ?audit_attachment - audit_attachment ?cutoff_check_tool - cutoff_check_tool)
    :precondition
      (and
        (validation_completed ?close_case)
        (assigned_check_tool ?close_case ?cutoff_check_tool)
        (audit_attachment_available ?audit_attachment)
        (close_case_has_audit_attachment ?close_case ?audit_attachment)
        (not
          (audit_attachment_processed ?close_case)
        )
      )
    :effect
      (and
        (audit_attachment_processed ?close_case)
        (not
          (audit_attachment_available ?audit_attachment)
        )
      )
  )
  (:action request_auditor_confirmation_for_case
    :parameters (?close_case - close_case ?approver - approver)
    :precondition
      (and
        (audit_attachment_processed ?close_case)
        (assigned_approver ?close_case ?approver)
        (not
          (auditor_confirmation_requested ?close_case)
        )
      )
    :effect (auditor_confirmation_requested ?close_case)
  )
  (:action receive_auditor_confirmation
    :parameters (?close_case - close_case ?auditor_confirmation - auditor_confirmation)
    :precondition
      (and
        (auditor_confirmation_requested ?close_case)
        (case_has_auditor_confirmation ?close_case ?auditor_confirmation)
        (not
          (auditor_confirmation_received ?close_case)
        )
      )
    :effect (auditor_confirmation_received ?close_case)
  )
  (:action finalize_case_after_auditor_confirmation
    :parameters (?close_case - close_case)
    :precondition
      (and
        (auditor_confirmation_received ?close_case)
        (not
          (close_case_finalized ?close_case)
        )
      )
    :effect
      (and
        (close_case_finalized ?close_case)
        (ready_for_closure ?close_case)
      )
  )
  (:action mark_ledger_ready_for_closure
    :parameters (?ledger - ledger ?submission_package - submission_package)
    :precondition
      (and
        (ledger_ready_for_submission ?ledger)
        (ledger_adjustment_recorded ?ledger)
        (submission_package_assembled ?submission_package)
        (package_ready_for_evidence ?submission_package)
        (not
          (ready_for_closure ?ledger)
        )
      )
    :effect (ready_for_closure ?ledger)
  )
  (:action mark_subledger_ready_for_closure
    :parameters (?subledger - subledger ?submission_package - submission_package)
    :precondition
      (and
        (subledger_ready_for_submission ?subledger)
        (subledger_adjustment_recorded ?subledger)
        (submission_package_assembled ?submission_package)
        (package_ready_for_evidence ?submission_package)
        (not
          (ready_for_closure ?subledger)
        )
      )
    :effect (ready_for_closure ?subledger)
  )
  (:action attach_closure_certificate_to_item
    :parameters (?closeable_item - closeable_item ?closure_certificate - closure_certificate ?cutoff_check_tool - cutoff_check_tool)
    :precondition
      (and
        (ready_for_closure ?closeable_item)
        (assigned_check_tool ?closeable_item ?cutoff_check_tool)
        (closure_certificate_available ?closure_certificate)
        (not
          (closure_certificate_attached ?closeable_item)
        )
      )
    :effect
      (and
        (closure_certificate_attached ?closeable_item)
        (closure_certificate_linked ?closeable_item ?closure_certificate)
        (not
          (closure_certificate_available ?closure_certificate)
        )
      )
  )
  (:action enforce_ledger_closure
    :parameters (?ledger - ledger ?reviewer - reviewer ?closure_certificate - closure_certificate)
    :precondition
      (and
        (closure_certificate_attached ?ledger)
        (assigned_reviewer ?ledger ?reviewer)
        (closure_certificate_linked ?ledger ?closure_certificate)
        (not
          (period_closed ?ledger)
        )
      )
    :effect
      (and
        (period_closed ?ledger)
        (reviewer_available ?reviewer)
        (closure_certificate_available ?closure_certificate)
      )
  )
  (:action enforce_subledger_closure
    :parameters (?subledger - subledger ?reviewer - reviewer ?closure_certificate - closure_certificate)
    :precondition
      (and
        (closure_certificate_attached ?subledger)
        (assigned_reviewer ?subledger ?reviewer)
        (closure_certificate_linked ?subledger ?closure_certificate)
        (not
          (period_closed ?subledger)
        )
      )
    :effect
      (and
        (period_closed ?subledger)
        (reviewer_available ?reviewer)
        (closure_certificate_available ?closure_certificate)
      )
  )
  (:action enforce_case_closure
    :parameters (?close_case - close_case ?reviewer - reviewer ?closure_certificate - closure_certificate)
    :precondition
      (and
        (closure_certificate_attached ?close_case)
        (assigned_reviewer ?close_case ?reviewer)
        (closure_certificate_linked ?close_case ?closure_certificate)
        (not
          (period_closed ?close_case)
        )
      )
    :effect
      (and
        (period_closed ?close_case)
        (reviewer_available ?reviewer)
        (closure_certificate_available ?closure_certificate)
      )
  )
)

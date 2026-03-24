(define (domain finance_balance_sheet_variance_investigation)
  (:requirements :strips :typing :negative-preconditions)
  (:types human_or_document - object workpaper_type - object reconciliation_concept - object entity_group - object balance_sheet_item - entity_group analyst - human_or_document support_document - human_or_document reviewer - human_or_document accounting_policy_document - human_or_document control_checklist - human_or_document root_cause_code - human_or_document approval_document - human_or_document audit_attachment - human_or_document workpaper - workpaper_type supporting_workpaper_template - workpaper_type audit_note - workpaper_type reconciliation_line - reconciliation_concept statement_line - reconciliation_concept reconciliation_bundle - reconciliation_concept account_subtype_group - balance_sheet_item case_subtype_group - balance_sheet_item gl_account - account_subtype_group subledger_account - account_subtype_group investigation_case - case_subtype_group)
  (:predicates
    (investigation_opened_for_item ?balance_sheet_item - balance_sheet_item)
    (item_triaged ?balance_sheet_item - balance_sheet_item)
    (analyst_assigned ?balance_sheet_item - balance_sheet_item)
    (item_closed ?balance_sheet_item - balance_sheet_item)
    (adjustment_approved ?balance_sheet_item - balance_sheet_item)
    (adjustment_posted ?balance_sheet_item - balance_sheet_item)
    (analyst_available ?analyst - analyst)
    (assigned_to_analyst ?balance_sheet_item - balance_sheet_item ?analyst - analyst)
    (support_document_available ?support_document - support_document)
    (attached_support_document ?balance_sheet_item - balance_sheet_item ?support_document - support_document)
    (reviewer_available ?reviewer - reviewer)
    (assigned_reviewer ?balance_sheet_item - balance_sheet_item ?reviewer - reviewer)
    (workpaper_available ?workpaper - workpaper)
    (workpaper_linked_to_gl_account ?gl_account - gl_account ?workpaper - workpaper)
    (workpaper_linked_to_subledger_account ?subledger_account - subledger_account ?workpaper - workpaper)
    (gl_account_linked_reconciliation_line ?gl_account - gl_account ?reconciliation_line - reconciliation_line)
    (recon_line_gl_validated ?reconciliation_line - reconciliation_line)
    (recon_line_workpaper_linked ?reconciliation_line - reconciliation_line)
    (gl_account_validated ?gl_account - gl_account)
    (subledger_linked_statement_line ?subledger_account - subledger_account ?statement_line - statement_line)
    (statement_line_validated ?statement_line - statement_line)
    (statement_line_workpaper_linked ?statement_line - statement_line)
    (subledger_account_validated ?subledger_account - subledger_account)
    (reconciliation_bundle_available ?reconciliation_bundle - reconciliation_bundle)
    (reconciliation_bundle_assembled ?reconciliation_bundle - reconciliation_bundle)
    (bundle_includes_reconciliation_line ?reconciliation_bundle - reconciliation_bundle ?reconciliation_line - reconciliation_line)
    (bundle_includes_statement_line ?reconciliation_bundle - reconciliation_bundle ?statement_line - statement_line)
    (bundle_gl_validated ?reconciliation_bundle - reconciliation_bundle)
    (bundle_statement_validated ?reconciliation_bundle - reconciliation_bundle)
    (bundle_gl_evidence_confirmed ?reconciliation_bundle - reconciliation_bundle)
    (case_links_gl_account ?investigation_case - investigation_case ?gl_account - gl_account)
    (case_links_subledger_account ?investigation_case - investigation_case ?subledger_account - subledger_account)
    (case_links_reconciliation_bundle ?investigation_case - investigation_case ?reconciliation_bundle - reconciliation_bundle)
    (workpaper_template_available ?supporting_workpaper_template - supporting_workpaper_template)
    (case_links_supporting_template ?investigation_case - investigation_case ?supporting_workpaper_template - supporting_workpaper_template)
    (supporting_template_consumed ?supporting_workpaper_template - supporting_workpaper_template)
    (template_linked_to_bundle ?supporting_workpaper_template - supporting_workpaper_template ?reconciliation_bundle - reconciliation_bundle)
    (case_workpapers_generated ?investigation_case - investigation_case)
    (case_ready_for_senior_review ?investigation_case - investigation_case)
    (senior_review_completed ?investigation_case - investigation_case)
    (policy_attached_to_case ?investigation_case - investigation_case)
    (policy_review_completed ?investigation_case - investigation_case)
    (control_checklist_applied ?investigation_case - investigation_case)
    (case_validated ?investigation_case - investigation_case)
    (audit_note_available ?audit_note - audit_note)
    (case_linked_audit_note ?investigation_case - investigation_case ?audit_note - audit_note)
    (audit_note_documented ?investigation_case - investigation_case)
    (audit_response_started ?investigation_case - investigation_case)
    (audit_response_completed ?investigation_case - investigation_case)
    (policy_doc_available ?accounting_policy_document - accounting_policy_document)
    (case_linked_policy_doc ?investigation_case - investigation_case ?accounting_policy_document - accounting_policy_document)
    (control_checklist_available ?control_checklist - control_checklist)
    (case_linked_control_checklist ?investigation_case - investigation_case ?control_checklist - control_checklist)
    (approval_document_available ?approval_document - approval_document)
    (case_linked_approval_document ?investigation_case - investigation_case ?approval_document - approval_document)
    (audit_attachment_available ?audit_attachment - audit_attachment)
    (case_linked_audit_attachment ?investigation_case - investigation_case ?audit_attachment - audit_attachment)
    (root_cause_code_available ?root_cause_code - root_cause_code)
    (item_linked_root_cause ?balance_sheet_item - balance_sheet_item ?root_cause_code - root_cause_code)
    (gl_account_ready ?gl_account - gl_account)
    (subledger_account_ready ?subledger_account - subledger_account)
    (case_signoff_recorded ?investigation_case - investigation_case)
  )
  (:action open_investigation_for_item
    :parameters (?balance_sheet_item - balance_sheet_item)
    :precondition
      (and
        (not
          (investigation_opened_for_item ?balance_sheet_item)
        )
        (not
          (item_closed ?balance_sheet_item)
        )
      )
    :effect (investigation_opened_for_item ?balance_sheet_item)
  )
  (:action assign_analyst_to_investigation
    :parameters (?balance_sheet_item - balance_sheet_item ?analyst - analyst)
    :precondition
      (and
        (investigation_opened_for_item ?balance_sheet_item)
        (not
          (analyst_assigned ?balance_sheet_item)
        )
        (analyst_available ?analyst)
      )
    :effect
      (and
        (analyst_assigned ?balance_sheet_item)
        (assigned_to_analyst ?balance_sheet_item ?analyst)
        (not
          (analyst_available ?analyst)
        )
      )
  )
  (:action attach_support_document_to_investigation
    :parameters (?balance_sheet_item - balance_sheet_item ?support_document - support_document)
    :precondition
      (and
        (investigation_opened_for_item ?balance_sheet_item)
        (analyst_assigned ?balance_sheet_item)
        (support_document_available ?support_document)
      )
    :effect
      (and
        (attached_support_document ?balance_sheet_item ?support_document)
        (not
          (support_document_available ?support_document)
        )
      )
  )
  (:action complete_triage_for_item
    :parameters (?balance_sheet_item - balance_sheet_item ?support_document - support_document)
    :precondition
      (and
        (investigation_opened_for_item ?balance_sheet_item)
        (analyst_assigned ?balance_sheet_item)
        (attached_support_document ?balance_sheet_item ?support_document)
        (not
          (item_triaged ?balance_sheet_item)
        )
      )
    :effect (item_triaged ?balance_sheet_item)
  )
  (:action release_support_document
    :parameters (?balance_sheet_item - balance_sheet_item ?support_document - support_document)
    :precondition
      (and
        (attached_support_document ?balance_sheet_item ?support_document)
      )
    :effect
      (and
        (support_document_available ?support_document)
        (not
          (attached_support_document ?balance_sheet_item ?support_document)
        )
      )
  )
  (:action assign_reviewer_to_investigation
    :parameters (?balance_sheet_item - balance_sheet_item ?reviewer - reviewer)
    :precondition
      (and
        (item_triaged ?balance_sheet_item)
        (reviewer_available ?reviewer)
      )
    :effect
      (and
        (assigned_reviewer ?balance_sheet_item ?reviewer)
        (not
          (reviewer_available ?reviewer)
        )
      )
  )
  (:action release_reviewer_from_investigation
    :parameters (?balance_sheet_item - balance_sheet_item ?reviewer - reviewer)
    :precondition
      (and
        (assigned_reviewer ?balance_sheet_item ?reviewer)
      )
    :effect
      (and
        (reviewer_available ?reviewer)
        (not
          (assigned_reviewer ?balance_sheet_item ?reviewer)
        )
      )
  )
  (:action attach_approval_document_to_case
    :parameters (?investigation_case - investigation_case ?approval_document - approval_document)
    :precondition
      (and
        (item_triaged ?investigation_case)
        (approval_document_available ?approval_document)
      )
    :effect
      (and
        (case_linked_approval_document ?investigation_case ?approval_document)
        (not
          (approval_document_available ?approval_document)
        )
      )
  )
  (:action detach_approval_document_from_case
    :parameters (?investigation_case - investigation_case ?approval_document - approval_document)
    :precondition
      (and
        (case_linked_approval_document ?investigation_case ?approval_document)
      )
    :effect
      (and
        (approval_document_available ?approval_document)
        (not
          (case_linked_approval_document ?investigation_case ?approval_document)
        )
      )
  )
  (:action attach_audit_attachment_to_case
    :parameters (?investigation_case - investigation_case ?audit_attachment - audit_attachment)
    :precondition
      (and
        (item_triaged ?investigation_case)
        (audit_attachment_available ?audit_attachment)
      )
    :effect
      (and
        (case_linked_audit_attachment ?investigation_case ?audit_attachment)
        (not
          (audit_attachment_available ?audit_attachment)
        )
      )
  )
  (:action detach_audit_attachment_from_case
    :parameters (?investigation_case - investigation_case ?audit_attachment - audit_attachment)
    :precondition
      (and
        (case_linked_audit_attachment ?investigation_case ?audit_attachment)
      )
    :effect
      (and
        (audit_attachment_available ?audit_attachment)
        (not
          (case_linked_audit_attachment ?investigation_case ?audit_attachment)
        )
      )
  )
  (:action validate_reconciliation_line_gl_evidence
    :parameters (?gl_account - gl_account ?reconciliation_line - reconciliation_line ?support_document - support_document)
    :precondition
      (and
        (item_triaged ?gl_account)
        (attached_support_document ?gl_account ?support_document)
        (gl_account_linked_reconciliation_line ?gl_account ?reconciliation_line)
        (not
          (recon_line_gl_validated ?reconciliation_line)
        )
        (not
          (recon_line_workpaper_linked ?reconciliation_line)
        )
      )
    :effect (recon_line_gl_validated ?reconciliation_line)
  )
  (:action review_and_validate_gl_account_reconciliation
    :parameters (?gl_account - gl_account ?reconciliation_line - reconciliation_line ?reviewer - reviewer)
    :precondition
      (and
        (item_triaged ?gl_account)
        (assigned_reviewer ?gl_account ?reviewer)
        (gl_account_linked_reconciliation_line ?gl_account ?reconciliation_line)
        (recon_line_gl_validated ?reconciliation_line)
        (not
          (gl_account_ready ?gl_account)
        )
      )
    :effect
      (and
        (gl_account_ready ?gl_account)
        (gl_account_validated ?gl_account)
      )
  )
  (:action attach_workpaper_to_gl_reconciliation
    :parameters (?gl_account - gl_account ?reconciliation_line - reconciliation_line ?workpaper - workpaper)
    :precondition
      (and
        (item_triaged ?gl_account)
        (gl_account_linked_reconciliation_line ?gl_account ?reconciliation_line)
        (workpaper_available ?workpaper)
        (not
          (gl_account_ready ?gl_account)
        )
      )
    :effect
      (and
        (recon_line_workpaper_linked ?reconciliation_line)
        (gl_account_ready ?gl_account)
        (workpaper_linked_to_gl_account ?gl_account ?workpaper)
        (not
          (workpaper_available ?workpaper)
        )
      )
  )
  (:action revalidate_reconciliation_line_with_workpaper
    :parameters (?gl_account - gl_account ?reconciliation_line - reconciliation_line ?support_document - support_document ?workpaper - workpaper)
    :precondition
      (and
        (item_triaged ?gl_account)
        (attached_support_document ?gl_account ?support_document)
        (gl_account_linked_reconciliation_line ?gl_account ?reconciliation_line)
        (recon_line_workpaper_linked ?reconciliation_line)
        (workpaper_linked_to_gl_account ?gl_account ?workpaper)
        (not
          (gl_account_validated ?gl_account)
        )
      )
    :effect
      (and
        (recon_line_gl_validated ?reconciliation_line)
        (gl_account_validated ?gl_account)
        (workpaper_available ?workpaper)
        (not
          (workpaper_linked_to_gl_account ?gl_account ?workpaper)
        )
      )
  )
  (:action validate_statement_line_with_support
    :parameters (?subledger_account - subledger_account ?statement_line - statement_line ?support_document - support_document)
    :precondition
      (and
        (item_triaged ?subledger_account)
        (attached_support_document ?subledger_account ?support_document)
        (subledger_linked_statement_line ?subledger_account ?statement_line)
        (not
          (statement_line_validated ?statement_line)
        )
        (not
          (statement_line_workpaper_linked ?statement_line)
        )
      )
    :effect (statement_line_validated ?statement_line)
  )
  (:action review_and_validate_subledger_account_reconciliation
    :parameters (?subledger_account - subledger_account ?statement_line - statement_line ?reviewer - reviewer)
    :precondition
      (and
        (item_triaged ?subledger_account)
        (assigned_reviewer ?subledger_account ?reviewer)
        (subledger_linked_statement_line ?subledger_account ?statement_line)
        (statement_line_validated ?statement_line)
        (not
          (subledger_account_ready ?subledger_account)
        )
      )
    :effect
      (and
        (subledger_account_ready ?subledger_account)
        (subledger_account_validated ?subledger_account)
      )
  )
  (:action attach_workpaper_to_subledger_reconciliation
    :parameters (?subledger_account - subledger_account ?statement_line - statement_line ?workpaper - workpaper)
    :precondition
      (and
        (item_triaged ?subledger_account)
        (subledger_linked_statement_line ?subledger_account ?statement_line)
        (workpaper_available ?workpaper)
        (not
          (subledger_account_ready ?subledger_account)
        )
      )
    :effect
      (and
        (statement_line_workpaper_linked ?statement_line)
        (subledger_account_ready ?subledger_account)
        (workpaper_linked_to_subledger_account ?subledger_account ?workpaper)
        (not
          (workpaper_available ?workpaper)
        )
      )
  )
  (:action revalidate_statement_line_with_workpaper
    :parameters (?subledger_account - subledger_account ?statement_line - statement_line ?support_document - support_document ?workpaper - workpaper)
    :precondition
      (and
        (item_triaged ?subledger_account)
        (attached_support_document ?subledger_account ?support_document)
        (subledger_linked_statement_line ?subledger_account ?statement_line)
        (statement_line_workpaper_linked ?statement_line)
        (workpaper_linked_to_subledger_account ?subledger_account ?workpaper)
        (not
          (subledger_account_validated ?subledger_account)
        )
      )
    :effect
      (and
        (statement_line_validated ?statement_line)
        (subledger_account_validated ?subledger_account)
        (workpaper_available ?workpaper)
        (not
          (workpaper_linked_to_subledger_account ?subledger_account ?workpaper)
        )
      )
  )
  (:action assemble_reconciliation_bundle_basic
    :parameters (?gl_account - gl_account ?subledger_account - subledger_account ?reconciliation_line - reconciliation_line ?statement_line - statement_line ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (gl_account_ready ?gl_account)
        (subledger_account_ready ?subledger_account)
        (gl_account_linked_reconciliation_line ?gl_account ?reconciliation_line)
        (subledger_linked_statement_line ?subledger_account ?statement_line)
        (recon_line_gl_validated ?reconciliation_line)
        (statement_line_validated ?statement_line)
        (gl_account_validated ?gl_account)
        (subledger_account_validated ?subledger_account)
        (reconciliation_bundle_available ?reconciliation_bundle)
      )
    :effect
      (and
        (reconciliation_bundle_assembled ?reconciliation_bundle)
        (bundle_includes_reconciliation_line ?reconciliation_bundle ?reconciliation_line)
        (bundle_includes_statement_line ?reconciliation_bundle ?statement_line)
        (not
          (reconciliation_bundle_available ?reconciliation_bundle)
        )
      )
  )
  (:action assemble_reconciliation_bundle_gl_validated
    :parameters (?gl_account - gl_account ?subledger_account - subledger_account ?reconciliation_line - reconciliation_line ?statement_line - statement_line ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (gl_account_ready ?gl_account)
        (subledger_account_ready ?subledger_account)
        (gl_account_linked_reconciliation_line ?gl_account ?reconciliation_line)
        (subledger_linked_statement_line ?subledger_account ?statement_line)
        (recon_line_workpaper_linked ?reconciliation_line)
        (statement_line_validated ?statement_line)
        (not
          (gl_account_validated ?gl_account)
        )
        (subledger_account_validated ?subledger_account)
        (reconciliation_bundle_available ?reconciliation_bundle)
      )
    :effect
      (and
        (reconciliation_bundle_assembled ?reconciliation_bundle)
        (bundle_includes_reconciliation_line ?reconciliation_bundle ?reconciliation_line)
        (bundle_includes_statement_line ?reconciliation_bundle ?statement_line)
        (bundle_gl_validated ?reconciliation_bundle)
        (not
          (reconciliation_bundle_available ?reconciliation_bundle)
        )
      )
  )
  (:action assemble_reconciliation_bundle_statement_validated
    :parameters (?gl_account - gl_account ?subledger_account - subledger_account ?reconciliation_line - reconciliation_line ?statement_line - statement_line ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (gl_account_ready ?gl_account)
        (subledger_account_ready ?subledger_account)
        (gl_account_linked_reconciliation_line ?gl_account ?reconciliation_line)
        (subledger_linked_statement_line ?subledger_account ?statement_line)
        (recon_line_gl_validated ?reconciliation_line)
        (statement_line_workpaper_linked ?statement_line)
        (gl_account_validated ?gl_account)
        (not
          (subledger_account_validated ?subledger_account)
        )
        (reconciliation_bundle_available ?reconciliation_bundle)
      )
    :effect
      (and
        (reconciliation_bundle_assembled ?reconciliation_bundle)
        (bundle_includes_reconciliation_line ?reconciliation_bundle ?reconciliation_line)
        (bundle_includes_statement_line ?reconciliation_bundle ?statement_line)
        (bundle_statement_validated ?reconciliation_bundle)
        (not
          (reconciliation_bundle_available ?reconciliation_bundle)
        )
      )
  )
  (:action assemble_reconciliation_bundle_fully_validated
    :parameters (?gl_account - gl_account ?subledger_account - subledger_account ?reconciliation_line - reconciliation_line ?statement_line - statement_line ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (gl_account_ready ?gl_account)
        (subledger_account_ready ?subledger_account)
        (gl_account_linked_reconciliation_line ?gl_account ?reconciliation_line)
        (subledger_linked_statement_line ?subledger_account ?statement_line)
        (recon_line_workpaper_linked ?reconciliation_line)
        (statement_line_workpaper_linked ?statement_line)
        (not
          (gl_account_validated ?gl_account)
        )
        (not
          (subledger_account_validated ?subledger_account)
        )
        (reconciliation_bundle_available ?reconciliation_bundle)
      )
    :effect
      (and
        (reconciliation_bundle_assembled ?reconciliation_bundle)
        (bundle_includes_reconciliation_line ?reconciliation_bundle ?reconciliation_line)
        (bundle_includes_statement_line ?reconciliation_bundle ?statement_line)
        (bundle_gl_validated ?reconciliation_bundle)
        (bundle_statement_validated ?reconciliation_bundle)
        (not
          (reconciliation_bundle_available ?reconciliation_bundle)
        )
      )
  )
  (:action confirm_bundle_gl_support_integration
    :parameters (?reconciliation_bundle - reconciliation_bundle ?gl_account - gl_account ?support_document - support_document)
    :precondition
      (and
        (reconciliation_bundle_assembled ?reconciliation_bundle)
        (gl_account_ready ?gl_account)
        (attached_support_document ?gl_account ?support_document)
        (not
          (bundle_gl_evidence_confirmed ?reconciliation_bundle)
        )
      )
    :effect (bundle_gl_evidence_confirmed ?reconciliation_bundle)
  )
  (:action generate_supporting_workpaper_from_template
    :parameters (?investigation_case - investigation_case ?supporting_workpaper_template - supporting_workpaper_template ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (item_triaged ?investigation_case)
        (case_links_reconciliation_bundle ?investigation_case ?reconciliation_bundle)
        (case_links_supporting_template ?investigation_case ?supporting_workpaper_template)
        (workpaper_template_available ?supporting_workpaper_template)
        (reconciliation_bundle_assembled ?reconciliation_bundle)
        (bundle_gl_evidence_confirmed ?reconciliation_bundle)
        (not
          (supporting_template_consumed ?supporting_workpaper_template)
        )
      )
    :effect
      (and
        (supporting_template_consumed ?supporting_workpaper_template)
        (template_linked_to_bundle ?supporting_workpaper_template ?reconciliation_bundle)
        (not
          (workpaper_template_available ?supporting_workpaper_template)
        )
      )
  )
  (:action finalize_supporting_workpaper_generation
    :parameters (?investigation_case - investigation_case ?supporting_workpaper_template - supporting_workpaper_template ?reconciliation_bundle - reconciliation_bundle ?support_document - support_document)
    :precondition
      (and
        (item_triaged ?investigation_case)
        (case_links_supporting_template ?investigation_case ?supporting_workpaper_template)
        (supporting_template_consumed ?supporting_workpaper_template)
        (template_linked_to_bundle ?supporting_workpaper_template ?reconciliation_bundle)
        (attached_support_document ?investigation_case ?support_document)
        (not
          (bundle_gl_validated ?reconciliation_bundle)
        )
        (not
          (case_workpapers_generated ?investigation_case)
        )
      )
    :effect (case_workpapers_generated ?investigation_case)
  )
  (:action attach_policy_document_to_case
    :parameters (?investigation_case - investigation_case ?accounting_policy_document - accounting_policy_document)
    :precondition
      (and
        (item_triaged ?investigation_case)
        (policy_doc_available ?accounting_policy_document)
        (not
          (policy_attached_to_case ?investigation_case)
        )
      )
    :effect
      (and
        (policy_attached_to_case ?investigation_case)
        (case_linked_policy_doc ?investigation_case ?accounting_policy_document)
        (not
          (policy_doc_available ?accounting_policy_document)
        )
      )
  )
  (:action apply_template_and_record_policy_review
    :parameters (?investigation_case - investigation_case ?supporting_workpaper_template - supporting_workpaper_template ?reconciliation_bundle - reconciliation_bundle ?support_document - support_document ?accounting_policy_document - accounting_policy_document)
    :precondition
      (and
        (item_triaged ?investigation_case)
        (case_links_supporting_template ?investigation_case ?supporting_workpaper_template)
        (supporting_template_consumed ?supporting_workpaper_template)
        (template_linked_to_bundle ?supporting_workpaper_template ?reconciliation_bundle)
        (attached_support_document ?investigation_case ?support_document)
        (bundle_gl_validated ?reconciliation_bundle)
        (policy_attached_to_case ?investigation_case)
        (case_linked_policy_doc ?investigation_case ?accounting_policy_document)
        (not
          (case_workpapers_generated ?investigation_case)
        )
      )
    :effect
      (and
        (case_workpapers_generated ?investigation_case)
        (policy_review_completed ?investigation_case)
      )
  )
  (:action submit_case_for_senior_review
    :parameters (?investigation_case - investigation_case ?approval_document - approval_document ?reviewer - reviewer ?supporting_workpaper_template - supporting_workpaper_template ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (case_workpapers_generated ?investigation_case)
        (case_linked_approval_document ?investigation_case ?approval_document)
        (assigned_reviewer ?investigation_case ?reviewer)
        (case_links_supporting_template ?investigation_case ?supporting_workpaper_template)
        (template_linked_to_bundle ?supporting_workpaper_template ?reconciliation_bundle)
        (not
          (bundle_statement_validated ?reconciliation_bundle)
        )
        (not
          (case_ready_for_senior_review ?investigation_case)
        )
      )
    :effect (case_ready_for_senior_review ?investigation_case)
  )
  (:action submit_case_for_senior_review_with_statement_validation
    :parameters (?investigation_case - investigation_case ?approval_document - approval_document ?reviewer - reviewer ?supporting_workpaper_template - supporting_workpaper_template ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (case_workpapers_generated ?investigation_case)
        (case_linked_approval_document ?investigation_case ?approval_document)
        (assigned_reviewer ?investigation_case ?reviewer)
        (case_links_supporting_template ?investigation_case ?supporting_workpaper_template)
        (template_linked_to_bundle ?supporting_workpaper_template ?reconciliation_bundle)
        (bundle_statement_validated ?reconciliation_bundle)
        (not
          (case_ready_for_senior_review ?investigation_case)
        )
      )
    :effect (case_ready_for_senior_review ?investigation_case)
  )
  (:action complete_senior_review_basic
    :parameters (?investigation_case - investigation_case ?audit_attachment - audit_attachment ?supporting_workpaper_template - supporting_workpaper_template ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (case_ready_for_senior_review ?investigation_case)
        (case_linked_audit_attachment ?investigation_case ?audit_attachment)
        (case_links_supporting_template ?investigation_case ?supporting_workpaper_template)
        (template_linked_to_bundle ?supporting_workpaper_template ?reconciliation_bundle)
        (not
          (bundle_gl_validated ?reconciliation_bundle)
        )
        (not
          (bundle_statement_validated ?reconciliation_bundle)
        )
        (not
          (senior_review_completed ?investigation_case)
        )
      )
    :effect (senior_review_completed ?investigation_case)
  )
  (:action complete_senior_review_and_mark_checklist
    :parameters (?investigation_case - investigation_case ?audit_attachment - audit_attachment ?supporting_workpaper_template - supporting_workpaper_template ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (case_ready_for_senior_review ?investigation_case)
        (case_linked_audit_attachment ?investigation_case ?audit_attachment)
        (case_links_supporting_template ?investigation_case ?supporting_workpaper_template)
        (template_linked_to_bundle ?supporting_workpaper_template ?reconciliation_bundle)
        (bundle_gl_validated ?reconciliation_bundle)
        (not
          (bundle_statement_validated ?reconciliation_bundle)
        )
        (not
          (senior_review_completed ?investigation_case)
        )
      )
    :effect
      (and
        (senior_review_completed ?investigation_case)
        (control_checklist_applied ?investigation_case)
      )
  )
  (:action complete_senior_review_and_mark_checklist_alternative
    :parameters (?investigation_case - investigation_case ?audit_attachment - audit_attachment ?supporting_workpaper_template - supporting_workpaper_template ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (case_ready_for_senior_review ?investigation_case)
        (case_linked_audit_attachment ?investigation_case ?audit_attachment)
        (case_links_supporting_template ?investigation_case ?supporting_workpaper_template)
        (template_linked_to_bundle ?supporting_workpaper_template ?reconciliation_bundle)
        (not
          (bundle_gl_validated ?reconciliation_bundle)
        )
        (bundle_statement_validated ?reconciliation_bundle)
        (not
          (senior_review_completed ?investigation_case)
        )
      )
    :effect
      (and
        (senior_review_completed ?investigation_case)
        (control_checklist_applied ?investigation_case)
      )
  )
  (:action complete_senior_review_and_mark_checklist_full
    :parameters (?investigation_case - investigation_case ?audit_attachment - audit_attachment ?supporting_workpaper_template - supporting_workpaper_template ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (case_ready_for_senior_review ?investigation_case)
        (case_linked_audit_attachment ?investigation_case ?audit_attachment)
        (case_links_supporting_template ?investigation_case ?supporting_workpaper_template)
        (template_linked_to_bundle ?supporting_workpaper_template ?reconciliation_bundle)
        (bundle_gl_validated ?reconciliation_bundle)
        (bundle_statement_validated ?reconciliation_bundle)
        (not
          (senior_review_completed ?investigation_case)
        )
      )
    :effect
      (and
        (senior_review_completed ?investigation_case)
        (control_checklist_applied ?investigation_case)
      )
  )
  (:action record_case_signoff_without_checklist
    :parameters (?investigation_case - investigation_case)
    :precondition
      (and
        (senior_review_completed ?investigation_case)
        (not
          (control_checklist_applied ?investigation_case)
        )
        (not
          (case_signoff_recorded ?investigation_case)
        )
      )
    :effect
      (and
        (case_signoff_recorded ?investigation_case)
        (adjustment_approved ?investigation_case)
      )
  )
  (:action attach_control_checklist_to_case
    :parameters (?investigation_case - investigation_case ?control_checklist - control_checklist)
    :precondition
      (and
        (senior_review_completed ?investigation_case)
        (control_checklist_applied ?investigation_case)
        (control_checklist_available ?control_checklist)
      )
    :effect
      (and
        (case_linked_control_checklist ?investigation_case ?control_checklist)
        (not
          (control_checklist_available ?control_checklist)
        )
      )
  )
  (:action finalize_case_validation
    :parameters (?investigation_case - investigation_case ?gl_account - gl_account ?subledger_account - subledger_account ?support_document - support_document ?control_checklist - control_checklist)
    :precondition
      (and
        (senior_review_completed ?investigation_case)
        (control_checklist_applied ?investigation_case)
        (case_linked_control_checklist ?investigation_case ?control_checklist)
        (case_links_gl_account ?investigation_case ?gl_account)
        (case_links_subledger_account ?investigation_case ?subledger_account)
        (gl_account_validated ?gl_account)
        (subledger_account_validated ?subledger_account)
        (attached_support_document ?investigation_case ?support_document)
        (not
          (case_validated ?investigation_case)
        )
      )
    :effect (case_validated ?investigation_case)
  )
  (:action record_case_final_signoff
    :parameters (?investigation_case - investigation_case)
    :precondition
      (and
        (senior_review_completed ?investigation_case)
        (case_validated ?investigation_case)
        (not
          (case_signoff_recorded ?investigation_case)
        )
      )
    :effect
      (and
        (case_signoff_recorded ?investigation_case)
        (adjustment_approved ?investigation_case)
      )
  )
  (:action acknowledge_audit_note_on_case
    :parameters (?investigation_case - investigation_case ?audit_note - audit_note ?support_document - support_document)
    :precondition
      (and
        (item_triaged ?investigation_case)
        (attached_support_document ?investigation_case ?support_document)
        (audit_note_available ?audit_note)
        (case_linked_audit_note ?investigation_case ?audit_note)
        (not
          (audit_note_documented ?investigation_case)
        )
      )
    :effect
      (and
        (audit_note_documented ?investigation_case)
        (not
          (audit_note_available ?audit_note)
        )
      )
  )
  (:action begin_audit_response_by_reviewer
    :parameters (?investigation_case - investigation_case ?reviewer - reviewer)
    :precondition
      (and
        (audit_note_documented ?investigation_case)
        (assigned_reviewer ?investigation_case ?reviewer)
        (not
          (audit_response_started ?investigation_case)
        )
      )
    :effect (audit_response_started ?investigation_case)
  )
  (:action complete_audit_response_for_case
    :parameters (?investigation_case - investigation_case ?audit_attachment - audit_attachment)
    :precondition
      (and
        (audit_response_started ?investigation_case)
        (case_linked_audit_attachment ?investigation_case ?audit_attachment)
        (not
          (audit_response_completed ?investigation_case)
        )
      )
    :effect (audit_response_completed ?investigation_case)
  )
  (:action record_audit_response_signoff
    :parameters (?investigation_case - investigation_case)
    :precondition
      (and
        (audit_response_completed ?investigation_case)
        (not
          (case_signoff_recorded ?investigation_case)
        )
      )
    :effect
      (and
        (case_signoff_recorded ?investigation_case)
        (adjustment_approved ?investigation_case)
      )
  )
  (:action record_gl_account_signoff
    :parameters (?gl_account - gl_account ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (gl_account_ready ?gl_account)
        (gl_account_validated ?gl_account)
        (reconciliation_bundle_assembled ?reconciliation_bundle)
        (bundle_gl_evidence_confirmed ?reconciliation_bundle)
        (not
          (adjustment_approved ?gl_account)
        )
      )
    :effect (adjustment_approved ?gl_account)
  )
  (:action record_subledger_account_signoff
    :parameters (?subledger_account - subledger_account ?reconciliation_bundle - reconciliation_bundle)
    :precondition
      (and
        (subledger_account_ready ?subledger_account)
        (subledger_account_validated ?subledger_account)
        (reconciliation_bundle_assembled ?reconciliation_bundle)
        (bundle_gl_evidence_confirmed ?reconciliation_bundle)
        (not
          (adjustment_approved ?subledger_account)
        )
      )
    :effect (adjustment_approved ?subledger_account)
  )
  (:action post_adjustment_for_balance_sheet_item
    :parameters (?balance_sheet_item - balance_sheet_item ?root_cause_code - root_cause_code ?support_document - support_document)
    :precondition
      (and
        (adjustment_approved ?balance_sheet_item)
        (attached_support_document ?balance_sheet_item ?support_document)
        (root_cause_code_available ?root_cause_code)
        (not
          (adjustment_posted ?balance_sheet_item)
        )
      )
    :effect
      (and
        (adjustment_posted ?balance_sheet_item)
        (item_linked_root_cause ?balance_sheet_item ?root_cause_code)
        (not
          (root_cause_code_available ?root_cause_code)
        )
      )
  )
  (:action apply_adjustment_to_gl_account_and_release_analyst
    :parameters (?gl_account - gl_account ?analyst - analyst ?root_cause_code - root_cause_code)
    :precondition
      (and
        (adjustment_posted ?gl_account)
        (assigned_to_analyst ?gl_account ?analyst)
        (item_linked_root_cause ?gl_account ?root_cause_code)
        (not
          (item_closed ?gl_account)
        )
      )
    :effect
      (and
        (item_closed ?gl_account)
        (analyst_available ?analyst)
        (root_cause_code_available ?root_cause_code)
      )
  )
  (:action apply_adjustment_to_subledger_and_release_analyst
    :parameters (?subledger_account - subledger_account ?analyst - analyst ?root_cause_code - root_cause_code)
    :precondition
      (and
        (adjustment_posted ?subledger_account)
        (assigned_to_analyst ?subledger_account ?analyst)
        (item_linked_root_cause ?subledger_account ?root_cause_code)
        (not
          (item_closed ?subledger_account)
        )
      )
    :effect
      (and
        (item_closed ?subledger_account)
        (analyst_available ?analyst)
        (root_cause_code_available ?root_cause_code)
      )
  )
  (:action apply_adjustment_to_case_and_release_analyst
    :parameters (?investigation_case - investigation_case ?analyst - analyst ?root_cause_code - root_cause_code)
    :precondition
      (and
        (adjustment_posted ?investigation_case)
        (assigned_to_analyst ?investigation_case ?analyst)
        (item_linked_root_cause ?investigation_case ?root_cause_code)
        (not
          (item_closed ?investigation_case)
        )
      )
    :effect
      (and
        (item_closed ?investigation_case)
        (analyst_available ?analyst)
        (root_cause_code_available ?root_cause_code)
      )
  )
)

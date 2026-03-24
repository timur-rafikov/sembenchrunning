(define (domain disclosure_support_schedule_preparation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types system_asset - object document_asset - object task_asset - object disclosure_catalog - object disclosure_item - disclosure_catalog data_source_system - system_asset data_extract - system_asset control_owner_role - system_asset accounting_policy - system_asset manager_approval_record - system_asset audit_query - system_asset audit_evidence - system_asset audit_memo_document - system_asset supporting_document - document_asset workpaper - document_asset external_confirmation - document_asset reconciliation_task - task_asset investigation_task - task_asset worksheet_instance - task_asset disclosure_group - disclosure_item disclosure_subgroup - disclosure_item preparer_workstream - disclosure_group reviewer_workstream - disclosure_group disclosure_schedule - disclosure_subgroup)
  (:predicates
    (entity_registered ?disclosure_item - disclosure_item)
    (entity_validated ?disclosure_item - disclosure_item)
    (entity_source_assigned ?disclosure_item - disclosure_item)
    (posting_ready ?disclosure_item - disclosure_item)
    (entity_signed_off ?disclosure_item - disclosure_item)
    (entity_posting_lock ?disclosure_item - disclosure_item)
    (data_source_available ?data_source_system - data_source_system)
    (entity_linked_data_source ?disclosure_item - disclosure_item ?data_source_system - data_source_system)
    (data_extract_available ?data_extract - data_extract)
    (entity_linked_extract ?disclosure_item - disclosure_item ?data_extract - data_extract)
    (control_owner_available ?control_owner - control_owner_role)
    (entity_assigned_control_owner ?disclosure_item - disclosure_item ?control_owner - control_owner_role)
    (supporting_document_available ?supporting_document - supporting_document)
    (preparer_attached_document ?preparer_workstream - preparer_workstream ?supporting_document - supporting_document)
    (reviewer_attached_document ?reviewer_workstream - reviewer_workstream ?supporting_document - supporting_document)
    (workstream_has_reconciliation_task ?preparer_workstream - preparer_workstream ?reconciliation_task - reconciliation_task)
    (reconciliation_initiated ?reconciliation_task - reconciliation_task)
    (reconciliation_document_attached ?reconciliation_task - reconciliation_task)
    (preparer_reconciliation_completed ?preparer_workstream - preparer_workstream)
    (workstream_has_investigation_task ?reviewer_workstream - reviewer_workstream ?investigation_task - investigation_task)
    (investigation_initiated ?investigation_task - investigation_task)
    (investigation_document_attached ?investigation_task - investigation_task)
    (reviewer_investigation_completed ?reviewer_workstream - reviewer_workstream)
    (worksheet_instance_available ?worksheet_instance - worksheet_instance)
    (worksheet_allocated ?worksheet_instance - worksheet_instance)
    (worksheet_linked_reconciliation_task ?worksheet_instance - worksheet_instance ?reconciliation_task - reconciliation_task)
    (worksheet_linked_investigation_task ?worksheet_instance - worksheet_instance ?investigation_task - investigation_task)
    (worksheet_reconciliation_documented ?worksheet_instance - worksheet_instance)
    (worksheet_investigation_documented ?worksheet_instance - worksheet_instance)
    (worksheet_line_completed ?worksheet_instance - worksheet_instance)
    (schedule_has_preparer_workstream ?disclosure_schedule - disclosure_schedule ?preparer_workstream - preparer_workstream)
    (schedule_has_reviewer_workstream ?disclosure_schedule - disclosure_schedule ?reviewer_workstream - reviewer_workstream)
    (schedule_has_worksheet_instance ?disclosure_schedule - disclosure_schedule ?worksheet_instance - worksheet_instance)
    (workpaper_available ?workpaper - workpaper)
    (schedule_has_workpaper ?disclosure_schedule - disclosure_schedule ?workpaper - workpaper)
    (workpaper_bound ?workpaper - workpaper)
    (workpaper_bound_to_worksheet ?workpaper - workpaper ?worksheet_instance - worksheet_instance)
    (schedule_workpaper_bound ?disclosure_schedule - disclosure_schedule)
    (schedule_workpaper_validated ?disclosure_schedule - disclosure_schedule)
    (schedule_ready_for_final_review ?disclosure_schedule - disclosure_schedule)
    (schedule_policy_attached ?disclosure_schedule - disclosure_schedule)
    (schedule_policy_verified ?disclosure_schedule - disclosure_schedule)
    (approval_requested_on_schedule ?disclosure_schedule - disclosure_schedule)
    (schedule_consolidation_completed ?disclosure_schedule - disclosure_schedule)
    (external_confirmation_available ?external_confirmation - external_confirmation)
    (schedule_has_external_confirmation ?disclosure_schedule - disclosure_schedule ?external_confirmation - external_confirmation)
    (schedule_external_confirmation_attached ?disclosure_schedule - disclosure_schedule)
    (schedule_confirmation_validated_by_owner ?disclosure_schedule - disclosure_schedule)
    (schedule_memo_reviewed ?disclosure_schedule - disclosure_schedule)
    (policy_available ?accounting_policy - accounting_policy)
    (schedule_has_policy ?disclosure_schedule - disclosure_schedule ?accounting_policy - accounting_policy)
    (manager_approval_available ?manager_approval_record - manager_approval_record)
    (schedule_has_manager_approval ?disclosure_schedule - disclosure_schedule ?manager_approval_record - manager_approval_record)
    (audit_evidence_available ?audit_evidence - audit_evidence)
    (schedule_has_audit_evidence ?disclosure_schedule - disclosure_schedule ?audit_evidence - audit_evidence)
    (audit_memo_available ?audit_memo - audit_memo_document)
    (schedule_has_audit_memo ?disclosure_schedule - disclosure_schedule ?audit_memo - audit_memo_document)
    (audit_query_available ?audit_query - audit_query)
    (entity_has_audit_query ?disclosure_item - disclosure_item ?audit_query - audit_query)
    (preparer_checks_complete ?preparer_workstream - preparer_workstream)
    (reviewer_checks_complete ?reviewer_workstream - reviewer_workstream)
    (schedule_finalized ?disclosure_schedule - disclosure_schedule)
  )
  (:action register_disclosure_item
    :parameters (?disclosure_item - disclosure_item)
    :precondition
      (and
        (not
          (entity_registered ?disclosure_item)
        )
        (not
          (posting_ready ?disclosure_item)
        )
      )
    :effect (entity_registered ?disclosure_item)
  )
  (:action assign_data_source_to_disclosure_item
    :parameters (?disclosure_item - disclosure_item ?data_source_system - data_source_system)
    :precondition
      (and
        (entity_registered ?disclosure_item)
        (not
          (entity_source_assigned ?disclosure_item)
        )
        (data_source_available ?data_source_system)
      )
    :effect
      (and
        (entity_source_assigned ?disclosure_item)
        (entity_linked_data_source ?disclosure_item ?data_source_system)
        (not
          (data_source_available ?data_source_system)
        )
      )
  )
  (:action attach_data_extract_to_disclosure_item
    :parameters (?disclosure_item - disclosure_item ?data_extract - data_extract)
    :precondition
      (and
        (entity_registered ?disclosure_item)
        (entity_source_assigned ?disclosure_item)
        (data_extract_available ?data_extract)
      )
    :effect
      (and
        (entity_linked_extract ?disclosure_item ?data_extract)
        (not
          (data_extract_available ?data_extract)
        )
      )
  )
  (:action validate_disclosure_item_with_extract
    :parameters (?disclosure_item - disclosure_item ?data_extract - data_extract)
    :precondition
      (and
        (entity_registered ?disclosure_item)
        (entity_source_assigned ?disclosure_item)
        (entity_linked_extract ?disclosure_item ?data_extract)
        (not
          (entity_validated ?disclosure_item)
        )
      )
    :effect (entity_validated ?disclosure_item)
  )
  (:action detach_data_extract_from_disclosure_item
    :parameters (?disclosure_item - disclosure_item ?data_extract - data_extract)
    :precondition
      (and
        (entity_linked_extract ?disclosure_item ?data_extract)
      )
    :effect
      (and
        (data_extract_available ?data_extract)
        (not
          (entity_linked_extract ?disclosure_item ?data_extract)
        )
      )
  )
  (:action assign_control_owner_to_disclosure_item
    :parameters (?disclosure_item - disclosure_item ?control_owner - control_owner_role)
    :precondition
      (and
        (entity_validated ?disclosure_item)
        (control_owner_available ?control_owner)
      )
    :effect
      (and
        (entity_assigned_control_owner ?disclosure_item ?control_owner)
        (not
          (control_owner_available ?control_owner)
        )
      )
  )
  (:action release_control_owner_from_disclosure_item
    :parameters (?disclosure_item - disclosure_item ?control_owner - control_owner_role)
    :precondition
      (and
        (entity_assigned_control_owner ?disclosure_item ?control_owner)
      )
    :effect
      (and
        (control_owner_available ?control_owner)
        (not
          (entity_assigned_control_owner ?disclosure_item ?control_owner)
        )
      )
  )
  (:action assign_audit_evidence_to_schedule
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_evidence - audit_evidence)
    :precondition
      (and
        (entity_validated ?disclosure_schedule)
        (audit_evidence_available ?audit_evidence)
      )
    :effect
      (and
        (schedule_has_audit_evidence ?disclosure_schedule ?audit_evidence)
        (not
          (audit_evidence_available ?audit_evidence)
        )
      )
  )
  (:action unassign_audit_evidence_from_schedule
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_evidence - audit_evidence)
    :precondition
      (and
        (schedule_has_audit_evidence ?disclosure_schedule ?audit_evidence)
      )
    :effect
      (and
        (audit_evidence_available ?audit_evidence)
        (not
          (schedule_has_audit_evidence ?disclosure_schedule ?audit_evidence)
        )
      )
  )
  (:action attach_audit_memo_to_schedule
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_memo - audit_memo_document)
    :precondition
      (and
        (entity_validated ?disclosure_schedule)
        (audit_memo_available ?audit_memo)
      )
    :effect
      (and
        (schedule_has_audit_memo ?disclosure_schedule ?audit_memo)
        (not
          (audit_memo_available ?audit_memo)
        )
      )
  )
  (:action detach_audit_memo_from_schedule
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_memo - audit_memo_document)
    :precondition
      (and
        (schedule_has_audit_memo ?disclosure_schedule ?audit_memo)
      )
    :effect
      (and
        (audit_memo_available ?audit_memo)
        (not
          (schedule_has_audit_memo ?disclosure_schedule ?audit_memo)
        )
      )
  )
  (:action initiate_reconciliation_task
    :parameters (?preparer_workstream - preparer_workstream ?reconciliation_task - reconciliation_task ?data_extract - data_extract)
    :precondition
      (and
        (entity_validated ?preparer_workstream)
        (entity_linked_extract ?preparer_workstream ?data_extract)
        (workstream_has_reconciliation_task ?preparer_workstream ?reconciliation_task)
        (not
          (reconciliation_initiated ?reconciliation_task)
        )
        (not
          (reconciliation_document_attached ?reconciliation_task)
        )
      )
    :effect (reconciliation_initiated ?reconciliation_task)
  )
  (:action complete_reconciliation_with_control_owner
    :parameters (?preparer_workstream - preparer_workstream ?reconciliation_task - reconciliation_task ?control_owner - control_owner_role)
    :precondition
      (and
        (entity_validated ?preparer_workstream)
        (entity_assigned_control_owner ?preparer_workstream ?control_owner)
        (workstream_has_reconciliation_task ?preparer_workstream ?reconciliation_task)
        (reconciliation_initiated ?reconciliation_task)
        (not
          (preparer_checks_complete ?preparer_workstream)
        )
      )
    :effect
      (and
        (preparer_checks_complete ?preparer_workstream)
        (preparer_reconciliation_completed ?preparer_workstream)
      )
  )
  (:action attach_supporting_document_to_reconciliation
    :parameters (?preparer_workstream - preparer_workstream ?reconciliation_task - reconciliation_task ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?preparer_workstream)
        (workstream_has_reconciliation_task ?preparer_workstream ?reconciliation_task)
        (supporting_document_available ?supporting_document)
        (not
          (preparer_checks_complete ?preparer_workstream)
        )
      )
    :effect
      (and
        (reconciliation_document_attached ?reconciliation_task)
        (preparer_checks_complete ?preparer_workstream)
        (preparer_attached_document ?preparer_workstream ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_reconciliation
    :parameters (?preparer_workstream - preparer_workstream ?reconciliation_task - reconciliation_task ?data_extract - data_extract ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?preparer_workstream)
        (entity_linked_extract ?preparer_workstream ?data_extract)
        (workstream_has_reconciliation_task ?preparer_workstream ?reconciliation_task)
        (reconciliation_document_attached ?reconciliation_task)
        (preparer_attached_document ?preparer_workstream ?supporting_document)
        (not
          (preparer_reconciliation_completed ?preparer_workstream)
        )
      )
    :effect
      (and
        (reconciliation_initiated ?reconciliation_task)
        (preparer_reconciliation_completed ?preparer_workstream)
        (supporting_document_available ?supporting_document)
        (not
          (preparer_attached_document ?preparer_workstream ?supporting_document)
        )
      )
  )
  (:action initiate_investigation_task
    :parameters (?reviewer_workstream - reviewer_workstream ?investigation_task - investigation_task ?data_extract - data_extract)
    :precondition
      (and
        (entity_validated ?reviewer_workstream)
        (entity_linked_extract ?reviewer_workstream ?data_extract)
        (workstream_has_investigation_task ?reviewer_workstream ?investigation_task)
        (not
          (investigation_initiated ?investigation_task)
        )
        (not
          (investigation_document_attached ?investigation_task)
        )
      )
    :effect (investigation_initiated ?investigation_task)
  )
  (:action complete_investigation_with_control_owner
    :parameters (?reviewer_workstream - reviewer_workstream ?investigation_task - investigation_task ?control_owner - control_owner_role)
    :precondition
      (and
        (entity_validated ?reviewer_workstream)
        (entity_assigned_control_owner ?reviewer_workstream ?control_owner)
        (workstream_has_investigation_task ?reviewer_workstream ?investigation_task)
        (investigation_initiated ?investigation_task)
        (not
          (reviewer_checks_complete ?reviewer_workstream)
        )
      )
    :effect
      (and
        (reviewer_checks_complete ?reviewer_workstream)
        (reviewer_investigation_completed ?reviewer_workstream)
      )
  )
  (:action attach_supporting_document_to_investigation
    :parameters (?reviewer_workstream - reviewer_workstream ?investigation_task - investigation_task ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?reviewer_workstream)
        (workstream_has_investigation_task ?reviewer_workstream ?investigation_task)
        (supporting_document_available ?supporting_document)
        (not
          (reviewer_checks_complete ?reviewer_workstream)
        )
      )
    :effect
      (and
        (investigation_document_attached ?investigation_task)
        (reviewer_checks_complete ?reviewer_workstream)
        (reviewer_attached_document ?reviewer_workstream ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_investigation
    :parameters (?reviewer_workstream - reviewer_workstream ?investigation_task - investigation_task ?data_extract - data_extract ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?reviewer_workstream)
        (entity_linked_extract ?reviewer_workstream ?data_extract)
        (workstream_has_investigation_task ?reviewer_workstream ?investigation_task)
        (investigation_document_attached ?investigation_task)
        (reviewer_attached_document ?reviewer_workstream ?supporting_document)
        (not
          (reviewer_investigation_completed ?reviewer_workstream)
        )
      )
    :effect
      (and
        (investigation_initiated ?investigation_task)
        (reviewer_investigation_completed ?reviewer_workstream)
        (supporting_document_available ?supporting_document)
        (not
          (reviewer_attached_document ?reviewer_workstream ?supporting_document)
        )
      )
  )
  (:action assemble_worksheet_from_completed_tasks
    :parameters (?preparer_workstream - preparer_workstream ?reviewer_workstream - reviewer_workstream ?reconciliation_task - reconciliation_task ?investigation_task - investigation_task ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (preparer_checks_complete ?preparer_workstream)
        (reviewer_checks_complete ?reviewer_workstream)
        (workstream_has_reconciliation_task ?preparer_workstream ?reconciliation_task)
        (workstream_has_investigation_task ?reviewer_workstream ?investigation_task)
        (reconciliation_initiated ?reconciliation_task)
        (investigation_initiated ?investigation_task)
        (preparer_reconciliation_completed ?preparer_workstream)
        (reviewer_investigation_completed ?reviewer_workstream)
        (worksheet_instance_available ?worksheet_instance)
      )
    :effect
      (and
        (worksheet_allocated ?worksheet_instance)
        (worksheet_linked_reconciliation_task ?worksheet_instance ?reconciliation_task)
        (worksheet_linked_investigation_task ?worksheet_instance ?investigation_task)
        (not
          (worksheet_instance_available ?worksheet_instance)
        )
      )
  )
  (:action assemble_worksheet_from_documented_reconciliations
    :parameters (?preparer_workstream - preparer_workstream ?reviewer_workstream - reviewer_workstream ?reconciliation_task - reconciliation_task ?investigation_task - investigation_task ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (preparer_checks_complete ?preparer_workstream)
        (reviewer_checks_complete ?reviewer_workstream)
        (workstream_has_reconciliation_task ?preparer_workstream ?reconciliation_task)
        (workstream_has_investigation_task ?reviewer_workstream ?investigation_task)
        (reconciliation_document_attached ?reconciliation_task)
        (investigation_initiated ?investigation_task)
        (not
          (preparer_reconciliation_completed ?preparer_workstream)
        )
        (reviewer_investigation_completed ?reviewer_workstream)
        (worksheet_instance_available ?worksheet_instance)
      )
    :effect
      (and
        (worksheet_allocated ?worksheet_instance)
        (worksheet_linked_reconciliation_task ?worksheet_instance ?reconciliation_task)
        (worksheet_linked_investigation_task ?worksheet_instance ?investigation_task)
        (worksheet_reconciliation_documented ?worksheet_instance)
        (not
          (worksheet_instance_available ?worksheet_instance)
        )
      )
  )
  (:action assemble_worksheet_from_reconciliations_documented_investigations
    :parameters (?preparer_workstream - preparer_workstream ?reviewer_workstream - reviewer_workstream ?reconciliation_task - reconciliation_task ?investigation_task - investigation_task ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (preparer_checks_complete ?preparer_workstream)
        (reviewer_checks_complete ?reviewer_workstream)
        (workstream_has_reconciliation_task ?preparer_workstream ?reconciliation_task)
        (workstream_has_investigation_task ?reviewer_workstream ?investigation_task)
        (reconciliation_initiated ?reconciliation_task)
        (investigation_document_attached ?investigation_task)
        (preparer_reconciliation_completed ?preparer_workstream)
        (not
          (reviewer_investigation_completed ?reviewer_workstream)
        )
        (worksheet_instance_available ?worksheet_instance)
      )
    :effect
      (and
        (worksheet_allocated ?worksheet_instance)
        (worksheet_linked_reconciliation_task ?worksheet_instance ?reconciliation_task)
        (worksheet_linked_investigation_task ?worksheet_instance ?investigation_task)
        (worksheet_investigation_documented ?worksheet_instance)
        (not
          (worksheet_instance_available ?worksheet_instance)
        )
      )
  )
  (:action assemble_worksheet_with_full_documentation
    :parameters (?preparer_workstream - preparer_workstream ?reviewer_workstream - reviewer_workstream ?reconciliation_task - reconciliation_task ?investigation_task - investigation_task ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (preparer_checks_complete ?preparer_workstream)
        (reviewer_checks_complete ?reviewer_workstream)
        (workstream_has_reconciliation_task ?preparer_workstream ?reconciliation_task)
        (workstream_has_investigation_task ?reviewer_workstream ?investigation_task)
        (reconciliation_document_attached ?reconciliation_task)
        (investigation_document_attached ?investigation_task)
        (not
          (preparer_reconciliation_completed ?preparer_workstream)
        )
        (not
          (reviewer_investigation_completed ?reviewer_workstream)
        )
        (worksheet_instance_available ?worksheet_instance)
      )
    :effect
      (and
        (worksheet_allocated ?worksheet_instance)
        (worksheet_linked_reconciliation_task ?worksheet_instance ?reconciliation_task)
        (worksheet_linked_investigation_task ?worksheet_instance ?investigation_task)
        (worksheet_reconciliation_documented ?worksheet_instance)
        (worksheet_investigation_documented ?worksheet_instance)
        (not
          (worksheet_instance_available ?worksheet_instance)
        )
      )
  )
  (:action mark_worksheet_line_complete
    :parameters (?worksheet_instance - worksheet_instance ?preparer_workstream - preparer_workstream ?data_extract - data_extract)
    :precondition
      (and
        (worksheet_allocated ?worksheet_instance)
        (preparer_checks_complete ?preparer_workstream)
        (entity_linked_extract ?preparer_workstream ?data_extract)
        (not
          (worksheet_line_completed ?worksheet_instance)
        )
      )
    :effect (worksheet_line_completed ?worksheet_instance)
  )
  (:action bind_workpaper_to_schedule_and_worksheet
    :parameters (?disclosure_schedule - disclosure_schedule ?workpaper - workpaper ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (entity_validated ?disclosure_schedule)
        (schedule_has_worksheet_instance ?disclosure_schedule ?worksheet_instance)
        (schedule_has_workpaper ?disclosure_schedule ?workpaper)
        (workpaper_available ?workpaper)
        (worksheet_allocated ?worksheet_instance)
        (worksheet_line_completed ?worksheet_instance)
        (not
          (workpaper_bound ?workpaper)
        )
      )
    :effect
      (and
        (workpaper_bound ?workpaper)
        (workpaper_bound_to_worksheet ?workpaper ?worksheet_instance)
        (not
          (workpaper_available ?workpaper)
        )
      )
  )
  (:action validate_workpaper_binding
    :parameters (?disclosure_schedule - disclosure_schedule ?workpaper - workpaper ?worksheet_instance - worksheet_instance ?data_extract - data_extract)
    :precondition
      (and
        (entity_validated ?disclosure_schedule)
        (schedule_has_workpaper ?disclosure_schedule ?workpaper)
        (workpaper_bound ?workpaper)
        (workpaper_bound_to_worksheet ?workpaper ?worksheet_instance)
        (entity_linked_extract ?disclosure_schedule ?data_extract)
        (not
          (worksheet_reconciliation_documented ?worksheet_instance)
        )
        (not
          (schedule_workpaper_bound ?disclosure_schedule)
        )
      )
    :effect (schedule_workpaper_bound ?disclosure_schedule)
  )
  (:action attach_accounting_policy_to_schedule
    :parameters (?disclosure_schedule - disclosure_schedule ?accounting_policy - accounting_policy)
    :precondition
      (and
        (entity_validated ?disclosure_schedule)
        (policy_available ?accounting_policy)
        (not
          (schedule_policy_attached ?disclosure_schedule)
        )
      )
    :effect
      (and
        (schedule_policy_attached ?disclosure_schedule)
        (schedule_has_policy ?disclosure_schedule ?accounting_policy)
        (not
          (policy_available ?accounting_policy)
        )
      )
  )
  (:action attach_policy_and_bind_workpaper
    :parameters (?disclosure_schedule - disclosure_schedule ?workpaper - workpaper ?worksheet_instance - worksheet_instance ?data_extract - data_extract ?accounting_policy - accounting_policy)
    :precondition
      (and
        (entity_validated ?disclosure_schedule)
        (schedule_has_workpaper ?disclosure_schedule ?workpaper)
        (workpaper_bound ?workpaper)
        (workpaper_bound_to_worksheet ?workpaper ?worksheet_instance)
        (entity_linked_extract ?disclosure_schedule ?data_extract)
        (worksheet_reconciliation_documented ?worksheet_instance)
        (schedule_policy_attached ?disclosure_schedule)
        (schedule_has_policy ?disclosure_schedule ?accounting_policy)
        (not
          (schedule_workpaper_bound ?disclosure_schedule)
        )
      )
    :effect
      (and
        (schedule_workpaper_bound ?disclosure_schedule)
        (schedule_policy_verified ?disclosure_schedule)
      )
  )
  (:action initiate_workpaper_validation
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_evidence - audit_evidence ?control_owner - control_owner_role ?workpaper - workpaper ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (schedule_workpaper_bound ?disclosure_schedule)
        (schedule_has_audit_evidence ?disclosure_schedule ?audit_evidence)
        (entity_assigned_control_owner ?disclosure_schedule ?control_owner)
        (schedule_has_workpaper ?disclosure_schedule ?workpaper)
        (workpaper_bound_to_worksheet ?workpaper ?worksheet_instance)
        (not
          (worksheet_investigation_documented ?worksheet_instance)
        )
        (not
          (schedule_workpaper_validated ?disclosure_schedule)
        )
      )
    :effect (schedule_workpaper_validated ?disclosure_schedule)
  )
  (:action confirm_workpaper_validation
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_evidence - audit_evidence ?control_owner - control_owner_role ?workpaper - workpaper ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (schedule_workpaper_bound ?disclosure_schedule)
        (schedule_has_audit_evidence ?disclosure_schedule ?audit_evidence)
        (entity_assigned_control_owner ?disclosure_schedule ?control_owner)
        (schedule_has_workpaper ?disclosure_schedule ?workpaper)
        (workpaper_bound_to_worksheet ?workpaper ?worksheet_instance)
        (worksheet_investigation_documented ?worksheet_instance)
        (not
          (schedule_workpaper_validated ?disclosure_schedule)
        )
      )
    :effect (schedule_workpaper_validated ?disclosure_schedule)
  )
  (:action mark_schedule_ready_for_final_review
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_memo - audit_memo_document ?workpaper - workpaper ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (schedule_workpaper_validated ?disclosure_schedule)
        (schedule_has_audit_memo ?disclosure_schedule ?audit_memo)
        (schedule_has_workpaper ?disclosure_schedule ?workpaper)
        (workpaper_bound_to_worksheet ?workpaper ?worksheet_instance)
        (not
          (worksheet_reconciliation_documented ?worksheet_instance)
        )
        (not
          (worksheet_investigation_documented ?worksheet_instance)
        )
        (not
          (schedule_ready_for_final_review ?disclosure_schedule)
        )
      )
    :effect (schedule_ready_for_final_review ?disclosure_schedule)
  )
  (:action escalate_schedule_for_manager_approval
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_memo - audit_memo_document ?workpaper - workpaper ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (schedule_workpaper_validated ?disclosure_schedule)
        (schedule_has_audit_memo ?disclosure_schedule ?audit_memo)
        (schedule_has_workpaper ?disclosure_schedule ?workpaper)
        (workpaper_bound_to_worksheet ?workpaper ?worksheet_instance)
        (worksheet_reconciliation_documented ?worksheet_instance)
        (not
          (worksheet_investigation_documented ?worksheet_instance)
        )
        (not
          (schedule_ready_for_final_review ?disclosure_schedule)
        )
      )
    :effect
      (and
        (schedule_ready_for_final_review ?disclosure_schedule)
        (approval_requested_on_schedule ?disclosure_schedule)
      )
  )
  (:action escalate_schedule_for_approval_alternate
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_memo - audit_memo_document ?workpaper - workpaper ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (schedule_workpaper_validated ?disclosure_schedule)
        (schedule_has_audit_memo ?disclosure_schedule ?audit_memo)
        (schedule_has_workpaper ?disclosure_schedule ?workpaper)
        (workpaper_bound_to_worksheet ?workpaper ?worksheet_instance)
        (not
          (worksheet_reconciliation_documented ?worksheet_instance)
        )
        (worksheet_investigation_documented ?worksheet_instance)
        (not
          (schedule_ready_for_final_review ?disclosure_schedule)
        )
      )
    :effect
      (and
        (schedule_ready_for_final_review ?disclosure_schedule)
        (approval_requested_on_schedule ?disclosure_schedule)
      )
  )
  (:action escalate_schedule_for_approval_combined
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_memo - audit_memo_document ?workpaper - workpaper ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (schedule_workpaper_validated ?disclosure_schedule)
        (schedule_has_audit_memo ?disclosure_schedule ?audit_memo)
        (schedule_has_workpaper ?disclosure_schedule ?workpaper)
        (workpaper_bound_to_worksheet ?workpaper ?worksheet_instance)
        (worksheet_reconciliation_documented ?worksheet_instance)
        (worksheet_investigation_documented ?worksheet_instance)
        (not
          (schedule_ready_for_final_review ?disclosure_schedule)
        )
      )
    :effect
      (and
        (schedule_ready_for_final_review ?disclosure_schedule)
        (approval_requested_on_schedule ?disclosure_schedule)
      )
  )
  (:action finalize_and_signoff_schedule
    :parameters (?disclosure_schedule - disclosure_schedule)
    :precondition
      (and
        (schedule_ready_for_final_review ?disclosure_schedule)
        (not
          (approval_requested_on_schedule ?disclosure_schedule)
        )
        (not
          (schedule_finalized ?disclosure_schedule)
        )
      )
    :effect
      (and
        (schedule_finalized ?disclosure_schedule)
        (entity_signed_off ?disclosure_schedule)
      )
  )
  (:action apply_manager_approval_to_schedule
    :parameters (?disclosure_schedule - disclosure_schedule ?manager_approval_record - manager_approval_record)
    :precondition
      (and
        (schedule_ready_for_final_review ?disclosure_schedule)
        (approval_requested_on_schedule ?disclosure_schedule)
        (manager_approval_available ?manager_approval_record)
      )
    :effect
      (and
        (schedule_has_manager_approval ?disclosure_schedule ?manager_approval_record)
        (not
          (manager_approval_available ?manager_approval_record)
        )
      )
  )
  (:action perform_final_consolidation_and_signoff
    :parameters (?disclosure_schedule - disclosure_schedule ?preparer_workstream - preparer_workstream ?reviewer_workstream - reviewer_workstream ?data_extract - data_extract ?manager_approval_record - manager_approval_record)
    :precondition
      (and
        (schedule_ready_for_final_review ?disclosure_schedule)
        (approval_requested_on_schedule ?disclosure_schedule)
        (schedule_has_manager_approval ?disclosure_schedule ?manager_approval_record)
        (schedule_has_preparer_workstream ?disclosure_schedule ?preparer_workstream)
        (schedule_has_reviewer_workstream ?disclosure_schedule ?reviewer_workstream)
        (preparer_reconciliation_completed ?preparer_workstream)
        (reviewer_investigation_completed ?reviewer_workstream)
        (entity_linked_extract ?disclosure_schedule ?data_extract)
        (not
          (schedule_consolidation_completed ?disclosure_schedule)
        )
      )
    :effect (schedule_consolidation_completed ?disclosure_schedule)
  )
  (:action finalize_schedule_with_consolidation
    :parameters (?disclosure_schedule - disclosure_schedule)
    :precondition
      (and
        (schedule_ready_for_final_review ?disclosure_schedule)
        (schedule_consolidation_completed ?disclosure_schedule)
        (not
          (schedule_finalized ?disclosure_schedule)
        )
      )
    :effect
      (and
        (schedule_finalized ?disclosure_schedule)
        (entity_signed_off ?disclosure_schedule)
      )
  )
  (:action attach_external_confirmation_to_schedule
    :parameters (?disclosure_schedule - disclosure_schedule ?external_confirmation - external_confirmation ?data_extract - data_extract)
    :precondition
      (and
        (entity_validated ?disclosure_schedule)
        (entity_linked_extract ?disclosure_schedule ?data_extract)
        (external_confirmation_available ?external_confirmation)
        (schedule_has_external_confirmation ?disclosure_schedule ?external_confirmation)
        (not
          (schedule_external_confirmation_attached ?disclosure_schedule)
        )
      )
    :effect
      (and
        (schedule_external_confirmation_attached ?disclosure_schedule)
        (not
          (external_confirmation_available ?external_confirmation)
        )
      )
  )
  (:action validate_external_confirmation_by_owner
    :parameters (?disclosure_schedule - disclosure_schedule ?control_owner - control_owner_role)
    :precondition
      (and
        (schedule_external_confirmation_attached ?disclosure_schedule)
        (entity_assigned_control_owner ?disclosure_schedule ?control_owner)
        (not
          (schedule_confirmation_validated_by_owner ?disclosure_schedule)
        )
      )
    :effect (schedule_confirmation_validated_by_owner ?disclosure_schedule)
  )
  (:action link_audit_memo_and_mark_reviewed
    :parameters (?disclosure_schedule - disclosure_schedule ?audit_memo - audit_memo_document)
    :precondition
      (and
        (schedule_confirmation_validated_by_owner ?disclosure_schedule)
        (schedule_has_audit_memo ?disclosure_schedule ?audit_memo)
        (not
          (schedule_memo_reviewed ?disclosure_schedule)
        )
      )
    :effect (schedule_memo_reviewed ?disclosure_schedule)
  )
  (:action finalize_schedule_after_memo
    :parameters (?disclosure_schedule - disclosure_schedule)
    :precondition
      (and
        (schedule_memo_reviewed ?disclosure_schedule)
        (not
          (schedule_finalized ?disclosure_schedule)
        )
      )
    :effect
      (and
        (schedule_finalized ?disclosure_schedule)
        (entity_signed_off ?disclosure_schedule)
      )
  )
  (:action signoff_preparer_workstream
    :parameters (?preparer_workstream - preparer_workstream ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (preparer_checks_complete ?preparer_workstream)
        (preparer_reconciliation_completed ?preparer_workstream)
        (worksheet_allocated ?worksheet_instance)
        (worksheet_line_completed ?worksheet_instance)
        (not
          (entity_signed_off ?preparer_workstream)
        )
      )
    :effect (entity_signed_off ?preparer_workstream)
  )
  (:action signoff_reviewer_workstream
    :parameters (?reviewer_workstream - reviewer_workstream ?worksheet_instance - worksheet_instance)
    :precondition
      (and
        (reviewer_checks_complete ?reviewer_workstream)
        (reviewer_investigation_completed ?reviewer_workstream)
        (worksheet_allocated ?worksheet_instance)
        (worksheet_line_completed ?worksheet_instance)
        (not
          (entity_signed_off ?reviewer_workstream)
        )
      )
    :effect (entity_signed_off ?reviewer_workstream)
  )
  (:action apply_posting_lock_and_link_audit_query
    :parameters (?disclosure_item - disclosure_item ?audit_query - audit_query ?data_extract - data_extract)
    :precondition
      (and
        (entity_signed_off ?disclosure_item)
        (entity_linked_extract ?disclosure_item ?data_extract)
        (audit_query_available ?audit_query)
        (not
          (entity_posting_lock ?disclosure_item)
        )
      )
    :effect
      (and
        (entity_posting_lock ?disclosure_item)
        (entity_has_audit_query ?disclosure_item ?audit_query)
        (not
          (audit_query_available ?audit_query)
        )
      )
  )
  (:action propagate_posting_readiness_and_release_data_source_preparer
    :parameters (?preparer_workstream - preparer_workstream ?data_source_system - data_source_system ?audit_query - audit_query)
    :precondition
      (and
        (entity_posting_lock ?preparer_workstream)
        (entity_linked_data_source ?preparer_workstream ?data_source_system)
        (entity_has_audit_query ?preparer_workstream ?audit_query)
        (not
          (posting_ready ?preparer_workstream)
        )
      )
    :effect
      (and
        (posting_ready ?preparer_workstream)
        (data_source_available ?data_source_system)
        (audit_query_available ?audit_query)
      )
  )
  (:action propagate_posting_readiness_and_release_data_source_reviewer
    :parameters (?reviewer_workstream - reviewer_workstream ?data_source_system - data_source_system ?audit_query - audit_query)
    :precondition
      (and
        (entity_posting_lock ?reviewer_workstream)
        (entity_linked_data_source ?reviewer_workstream ?data_source_system)
        (entity_has_audit_query ?reviewer_workstream ?audit_query)
        (not
          (posting_ready ?reviewer_workstream)
        )
      )
    :effect
      (and
        (posting_ready ?reviewer_workstream)
        (data_source_available ?data_source_system)
        (audit_query_available ?audit_query)
      )
  )
  (:action propagate_posting_readiness_and_release_data_source_schedule
    :parameters (?disclosure_schedule - disclosure_schedule ?data_source_system - data_source_system ?audit_query - audit_query)
    :precondition
      (and
        (entity_posting_lock ?disclosure_schedule)
        (entity_linked_data_source ?disclosure_schedule ?data_source_system)
        (entity_has_audit_query ?disclosure_schedule ?audit_query)
        (not
          (posting_ready ?disclosure_schedule)
        )
      )
    :effect
      (and
        (posting_ready ?disclosure_schedule)
        (data_source_available ?data_source_system)
        (audit_query_available ?audit_query)
      )
  )
)

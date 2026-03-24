(define (domain finance_control_evidence_traceability)
  (:requirements :strips :typing :negative-preconditions)
  (:types evidence_asset_group - object document_asset_group - object traceability_item_group - object control_case - object accounting_entity - control_case evidence_resource - evidence_asset_group investigator - evidence_asset_group approver - evidence_asset_group policy_reference - evidence_asset_group control_template - evidence_asset_group audit_marker - evidence_asset_group system_extract - evidence_asset_group audit_annotation - evidence_asset_group supporting_document - document_asset_group workpaper_attachment - document_asset_group approver_signature - document_asset_group reconciliation_line - traceability_item_group subledger_line - traceability_item_group traceability_package - traceability_item_group reconciliation_container - accounting_entity workpaper_container - accounting_entity account_reconciliation - reconciliation_container subledger_reconciliation - reconciliation_container control_workpaper - workpaper_container)
  (:predicates
    (case_registered ?accounting_entity - accounting_entity)
    (entity_validated ?accounting_entity - accounting_entity)
    (evidence_allocated ?accounting_entity - accounting_entity)
    (traceability_finalized ?accounting_entity - accounting_entity)
    (entity_ready ?accounting_entity - accounting_entity)
    (finalization_requested ?accounting_entity - accounting_entity)
    (evidence_resource_available ?evidence_resource - evidence_resource)
    (evidence_assigned_to_case ?accounting_entity - accounting_entity ?evidence_resource - evidence_resource)
    (investigator_available ?investigator - investigator)
    (investigator_assigned ?accounting_entity - accounting_entity ?investigator - investigator)
    (approver_available ?approver - approver)
    (approver_assigned ?accounting_entity - accounting_entity ?approver - approver)
    (supporting_document_available ?supporting_document - supporting_document)
    (reconciliation_document_link ?account_reconciliation - account_reconciliation ?supporting_document - supporting_document)
    (subledger_document_link ?subledger_reconciliation - subledger_reconciliation ?supporting_document - supporting_document)
    (reconciliation_line_link ?account_reconciliation - account_reconciliation ?reconciliation_line - reconciliation_line)
    (reconciliation_line_ready ?reconciliation_line - reconciliation_line)
    (reconciliation_line_doc_attached ?reconciliation_line - reconciliation_line)
    (account_reconciliation_ready ?account_reconciliation - account_reconciliation)
    (subledger_line_link ?subledger_reconciliation - subledger_reconciliation ?subledger_line - subledger_line)
    (subledger_line_ready ?subledger_line - subledger_line)
    (subledger_line_doc_attached ?subledger_line - subledger_line)
    (subledger_reconciliation_ready ?subledger_reconciliation - subledger_reconciliation)
    (package_available ?traceability_package - traceability_package)
    (package_assembled ?traceability_package - traceability_package)
    (package_reconciliation_line_link ?traceability_package - traceability_package ?reconciliation_line - reconciliation_line)
    (package_subledger_line_link ?traceability_package - traceability_package ?subledger_line - subledger_line)
    (package_includes_reconciliation_documents ?traceability_package - traceability_package)
    (package_includes_subledger_documents ?traceability_package - traceability_package)
    (package_processed ?traceability_package - traceability_package)
    (workpaper_linked_reconciliation ?control_workpaper - control_workpaper ?account_reconciliation - account_reconciliation)
    (workpaper_linked_subledger_reconciliation ?control_workpaper - control_workpaper ?subledger_reconciliation - subledger_reconciliation)
    (workpaper_package_link ?control_workpaper - control_workpaper ?traceability_package - traceability_package)
    (attachment_available ?workpaper_attachment - workpaper_attachment)
    (workpaper_attachment_link ?control_workpaper - control_workpaper ?workpaper_attachment - workpaper_attachment)
    (attachment_consumed ?workpaper_attachment - workpaper_attachment)
    (attachment_linked_to_package ?workpaper_attachment - workpaper_attachment ?traceability_package - traceability_package)
    (workpaper_enrichment_started ?control_workpaper - control_workpaper)
    (workpaper_enriched ?control_workpaper - control_workpaper)
    (workpaper_enrichment_complete ?control_workpaper - control_workpaper)
    (policy_attached ?control_workpaper - control_workpaper)
    (policy_processed_on_workpaper ?control_workpaper - control_workpaper)
    (workpaper_template_ready ?control_workpaper - control_workpaper)
    (workpaper_consolidated ?control_workpaper - control_workpaper)
    (approver_signature_available ?approver_signature - approver_signature)
    (workpaper_signature_link ?control_workpaper - control_workpaper ?approver_signature - approver_signature)
    (signature_recorded ?control_workpaper - control_workpaper)
    (signature_verified ?control_workpaper - control_workpaper)
    (approval_completed ?control_workpaper - control_workpaper)
    (policy_reference_available ?policy_reference - policy_reference)
    (workpaper_policy_link ?control_workpaper - control_workpaper ?policy_reference - policy_reference)
    (control_template_available ?control_template - control_template)
    (workpaper_template_link ?control_workpaper - control_workpaper ?control_template - control_template)
    (system_extract_available ?system_extract - system_extract)
    (workpaper_system_extract_link ?control_workpaper - control_workpaper ?system_extract - system_extract)
    (audit_annotation_available ?audit_annotation - audit_annotation)
    (workpaper_annotation_link ?control_workpaper - control_workpaper ?audit_annotation - audit_annotation)
    (audit_marker_available ?audit_marker - audit_marker)
    (audit_marker_assigned ?accounting_entity - accounting_entity ?audit_marker - audit_marker)
    (account_reconciliation_triaged ?account_reconciliation - account_reconciliation)
    (subledger_reconciliation_triaged ?subledger_reconciliation - subledger_reconciliation)
    (workpaper_routed_for_approval ?control_workpaper - control_workpaper)
  )
  (:action register_control_case
    :parameters (?accounting_entity - accounting_entity)
    :precondition
      (and
        (not
          (case_registered ?accounting_entity)
        )
        (not
          (traceability_finalized ?accounting_entity)
        )
      )
    :effect (case_registered ?accounting_entity)
  )
  (:action allocate_evidence_resource_to_case
    :parameters (?accounting_entity - accounting_entity ?evidence_resource - evidence_resource)
    :precondition
      (and
        (case_registered ?accounting_entity)
        (not
          (evidence_allocated ?accounting_entity)
        )
        (evidence_resource_available ?evidence_resource)
      )
    :effect
      (and
        (evidence_allocated ?accounting_entity)
        (evidence_assigned_to_case ?accounting_entity ?evidence_resource)
        (not
          (evidence_resource_available ?evidence_resource)
        )
      )
  )
  (:action assign_investigator_to_case
    :parameters (?accounting_entity - accounting_entity ?investigator - investigator)
    :precondition
      (and
        (case_registered ?accounting_entity)
        (evidence_allocated ?accounting_entity)
        (investigator_available ?investigator)
      )
    :effect
      (and
        (investigator_assigned ?accounting_entity ?investigator)
        (not
          (investigator_available ?investigator)
        )
      )
  )
  (:action mark_case_validated
    :parameters (?accounting_entity - accounting_entity ?investigator - investigator)
    :precondition
      (and
        (case_registered ?accounting_entity)
        (evidence_allocated ?accounting_entity)
        (investigator_assigned ?accounting_entity ?investigator)
        (not
          (entity_validated ?accounting_entity)
        )
      )
    :effect (entity_validated ?accounting_entity)
  )
  (:action release_investigator_from_case
    :parameters (?accounting_entity - accounting_entity ?investigator - investigator)
    :precondition
      (and
        (investigator_assigned ?accounting_entity ?investigator)
      )
    :effect
      (and
        (investigator_available ?investigator)
        (not
          (investigator_assigned ?accounting_entity ?investigator)
        )
      )
  )
  (:action assign_approver_to_case
    :parameters (?accounting_entity - accounting_entity ?approver - approver)
    :precondition
      (and
        (entity_validated ?accounting_entity)
        (approver_available ?approver)
      )
    :effect
      (and
        (approver_assigned ?accounting_entity ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action release_approver_from_case
    :parameters (?accounting_entity - accounting_entity ?approver - approver)
    :precondition
      (and
        (approver_assigned ?accounting_entity ?approver)
      )
    :effect
      (and
        (approver_available ?approver)
        (not
          (approver_assigned ?accounting_entity ?approver)
        )
      )
  )
  (:action attach_system_extract_to_workpaper
    :parameters (?control_workpaper - control_workpaper ?system_extract - system_extract)
    :precondition
      (and
        (entity_validated ?control_workpaper)
        (system_extract_available ?system_extract)
      )
    :effect
      (and
        (workpaper_system_extract_link ?control_workpaper ?system_extract)
        (not
          (system_extract_available ?system_extract)
        )
      )
  )
  (:action detach_system_extract_from_workpaper
    :parameters (?control_workpaper - control_workpaper ?system_extract - system_extract)
    :precondition
      (and
        (workpaper_system_extract_link ?control_workpaper ?system_extract)
      )
    :effect
      (and
        (system_extract_available ?system_extract)
        (not
          (workpaper_system_extract_link ?control_workpaper ?system_extract)
        )
      )
  )
  (:action attach_audit_annotation_to_workpaper
    :parameters (?control_workpaper - control_workpaper ?audit_annotation - audit_annotation)
    :precondition
      (and
        (entity_validated ?control_workpaper)
        (audit_annotation_available ?audit_annotation)
      )
    :effect
      (and
        (workpaper_annotation_link ?control_workpaper ?audit_annotation)
        (not
          (audit_annotation_available ?audit_annotation)
        )
      )
  )
  (:action detach_audit_annotation_from_workpaper
    :parameters (?control_workpaper - control_workpaper ?audit_annotation - audit_annotation)
    :precondition
      (and
        (workpaper_annotation_link ?control_workpaper ?audit_annotation)
      )
    :effect
      (and
        (audit_annotation_available ?audit_annotation)
        (not
          (workpaper_annotation_link ?control_workpaper ?audit_annotation)
        )
      )
  )
  (:action flag_reconciliation_line_for_package
    :parameters (?account_reconciliation - account_reconciliation ?reconciliation_line - reconciliation_line ?investigator - investigator)
    :precondition
      (and
        (entity_validated ?account_reconciliation)
        (investigator_assigned ?account_reconciliation ?investigator)
        (reconciliation_line_link ?account_reconciliation ?reconciliation_line)
        (not
          (reconciliation_line_ready ?reconciliation_line)
        )
        (not
          (reconciliation_line_doc_attached ?reconciliation_line)
        )
      )
    :effect (reconciliation_line_ready ?reconciliation_line)
  )
  (:action approver_triage_reconciliation
    :parameters (?account_reconciliation - account_reconciliation ?reconciliation_line - reconciliation_line ?approver - approver)
    :precondition
      (and
        (entity_validated ?account_reconciliation)
        (approver_assigned ?account_reconciliation ?approver)
        (reconciliation_line_link ?account_reconciliation ?reconciliation_line)
        (reconciliation_line_ready ?reconciliation_line)
        (not
          (account_reconciliation_triaged ?account_reconciliation)
        )
      )
    :effect
      (and
        (account_reconciliation_triaged ?account_reconciliation)
        (account_reconciliation_ready ?account_reconciliation)
      )
  )
  (:action attach_supporting_document_to_reconciliation_line
    :parameters (?account_reconciliation - account_reconciliation ?reconciliation_line - reconciliation_line ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?account_reconciliation)
        (reconciliation_line_link ?account_reconciliation ?reconciliation_line)
        (supporting_document_available ?supporting_document)
        (not
          (account_reconciliation_triaged ?account_reconciliation)
        )
      )
    :effect
      (and
        (reconciliation_line_doc_attached ?reconciliation_line)
        (account_reconciliation_triaged ?account_reconciliation)
        (reconciliation_document_link ?account_reconciliation ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action resolve_reconciliation_line_with_supporting_document
    :parameters (?account_reconciliation - account_reconciliation ?reconciliation_line - reconciliation_line ?investigator - investigator ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?account_reconciliation)
        (investigator_assigned ?account_reconciliation ?investigator)
        (reconciliation_line_link ?account_reconciliation ?reconciliation_line)
        (reconciliation_line_doc_attached ?reconciliation_line)
        (reconciliation_document_link ?account_reconciliation ?supporting_document)
        (not
          (account_reconciliation_ready ?account_reconciliation)
        )
      )
    :effect
      (and
        (reconciliation_line_ready ?reconciliation_line)
        (account_reconciliation_ready ?account_reconciliation)
        (supporting_document_available ?supporting_document)
        (not
          (reconciliation_document_link ?account_reconciliation ?supporting_document)
        )
      )
  )
  (:action flag_subledger_line_for_package
    :parameters (?subledger_reconciliation - subledger_reconciliation ?subledger_line - subledger_line ?investigator - investigator)
    :precondition
      (and
        (entity_validated ?subledger_reconciliation)
        (investigator_assigned ?subledger_reconciliation ?investigator)
        (subledger_line_link ?subledger_reconciliation ?subledger_line)
        (not
          (subledger_line_ready ?subledger_line)
        )
        (not
          (subledger_line_doc_attached ?subledger_line)
        )
      )
    :effect (subledger_line_ready ?subledger_line)
  )
  (:action approver_triage_subledger_reconciliation
    :parameters (?subledger_reconciliation - subledger_reconciliation ?subledger_line - subledger_line ?approver - approver)
    :precondition
      (and
        (entity_validated ?subledger_reconciliation)
        (approver_assigned ?subledger_reconciliation ?approver)
        (subledger_line_link ?subledger_reconciliation ?subledger_line)
        (subledger_line_ready ?subledger_line)
        (not
          (subledger_reconciliation_triaged ?subledger_reconciliation)
        )
      )
    :effect
      (and
        (subledger_reconciliation_triaged ?subledger_reconciliation)
        (subledger_reconciliation_ready ?subledger_reconciliation)
      )
  )
  (:action attach_supporting_document_to_subledger_line
    :parameters (?subledger_reconciliation - subledger_reconciliation ?subledger_line - subledger_line ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?subledger_reconciliation)
        (subledger_line_link ?subledger_reconciliation ?subledger_line)
        (supporting_document_available ?supporting_document)
        (not
          (subledger_reconciliation_triaged ?subledger_reconciliation)
        )
      )
    :effect
      (and
        (subledger_line_doc_attached ?subledger_line)
        (subledger_reconciliation_triaged ?subledger_reconciliation)
        (subledger_document_link ?subledger_reconciliation ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action resolve_subledger_line_with_supporting_document
    :parameters (?subledger_reconciliation - subledger_reconciliation ?subledger_line - subledger_line ?investigator - investigator ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?subledger_reconciliation)
        (investigator_assigned ?subledger_reconciliation ?investigator)
        (subledger_line_link ?subledger_reconciliation ?subledger_line)
        (subledger_line_doc_attached ?subledger_line)
        (subledger_document_link ?subledger_reconciliation ?supporting_document)
        (not
          (subledger_reconciliation_ready ?subledger_reconciliation)
        )
      )
    :effect
      (and
        (subledger_line_ready ?subledger_line)
        (subledger_reconciliation_ready ?subledger_reconciliation)
        (supporting_document_available ?supporting_document)
        (not
          (subledger_document_link ?subledger_reconciliation ?supporting_document)
        )
      )
  )
  (:action assemble_traceability_package
    :parameters (?account_reconciliation - account_reconciliation ?subledger_reconciliation - subledger_reconciliation ?reconciliation_line - reconciliation_line ?subledger_line - subledger_line ?traceability_package - traceability_package)
    :precondition
      (and
        (account_reconciliation_triaged ?account_reconciliation)
        (subledger_reconciliation_triaged ?subledger_reconciliation)
        (reconciliation_line_link ?account_reconciliation ?reconciliation_line)
        (subledger_line_link ?subledger_reconciliation ?subledger_line)
        (reconciliation_line_ready ?reconciliation_line)
        (subledger_line_ready ?subledger_line)
        (account_reconciliation_ready ?account_reconciliation)
        (subledger_reconciliation_ready ?subledger_reconciliation)
        (package_available ?traceability_package)
      )
    :effect
      (and
        (package_assembled ?traceability_package)
        (package_reconciliation_line_link ?traceability_package ?reconciliation_line)
        (package_subledger_line_link ?traceability_package ?subledger_line)
        (not
          (package_available ?traceability_package)
        )
      )
  )
  (:action assemble_traceability_package_with_reconciliation_documents
    :parameters (?account_reconciliation - account_reconciliation ?subledger_reconciliation - subledger_reconciliation ?reconciliation_line - reconciliation_line ?subledger_line - subledger_line ?traceability_package - traceability_package)
    :precondition
      (and
        (account_reconciliation_triaged ?account_reconciliation)
        (subledger_reconciliation_triaged ?subledger_reconciliation)
        (reconciliation_line_link ?account_reconciliation ?reconciliation_line)
        (subledger_line_link ?subledger_reconciliation ?subledger_line)
        (reconciliation_line_doc_attached ?reconciliation_line)
        (subledger_line_ready ?subledger_line)
        (not
          (account_reconciliation_ready ?account_reconciliation)
        )
        (subledger_reconciliation_ready ?subledger_reconciliation)
        (package_available ?traceability_package)
      )
    :effect
      (and
        (package_assembled ?traceability_package)
        (package_reconciliation_line_link ?traceability_package ?reconciliation_line)
        (package_subledger_line_link ?traceability_package ?subledger_line)
        (package_includes_reconciliation_documents ?traceability_package)
        (not
          (package_available ?traceability_package)
        )
      )
  )
  (:action assemble_traceability_package_with_subledger_documents
    :parameters (?account_reconciliation - account_reconciliation ?subledger_reconciliation - subledger_reconciliation ?reconciliation_line - reconciliation_line ?subledger_line - subledger_line ?traceability_package - traceability_package)
    :precondition
      (and
        (account_reconciliation_triaged ?account_reconciliation)
        (subledger_reconciliation_triaged ?subledger_reconciliation)
        (reconciliation_line_link ?account_reconciliation ?reconciliation_line)
        (subledger_line_link ?subledger_reconciliation ?subledger_line)
        (reconciliation_line_ready ?reconciliation_line)
        (subledger_line_doc_attached ?subledger_line)
        (account_reconciliation_ready ?account_reconciliation)
        (not
          (subledger_reconciliation_ready ?subledger_reconciliation)
        )
        (package_available ?traceability_package)
      )
    :effect
      (and
        (package_assembled ?traceability_package)
        (package_reconciliation_line_link ?traceability_package ?reconciliation_line)
        (package_subledger_line_link ?traceability_package ?subledger_line)
        (package_includes_subledger_documents ?traceability_package)
        (not
          (package_available ?traceability_package)
        )
      )
  )
  (:action assemble_traceability_package_with_reconciliation_and_subledger_documents
    :parameters (?account_reconciliation - account_reconciliation ?subledger_reconciliation - subledger_reconciliation ?reconciliation_line - reconciliation_line ?subledger_line - subledger_line ?traceability_package - traceability_package)
    :precondition
      (and
        (account_reconciliation_triaged ?account_reconciliation)
        (subledger_reconciliation_triaged ?subledger_reconciliation)
        (reconciliation_line_link ?account_reconciliation ?reconciliation_line)
        (subledger_line_link ?subledger_reconciliation ?subledger_line)
        (reconciliation_line_doc_attached ?reconciliation_line)
        (subledger_line_doc_attached ?subledger_line)
        (not
          (account_reconciliation_ready ?account_reconciliation)
        )
        (not
          (subledger_reconciliation_ready ?subledger_reconciliation)
        )
        (package_available ?traceability_package)
      )
    :effect
      (and
        (package_assembled ?traceability_package)
        (package_reconciliation_line_link ?traceability_package ?reconciliation_line)
        (package_subledger_line_link ?traceability_package ?subledger_line)
        (package_includes_reconciliation_documents ?traceability_package)
        (package_includes_subledger_documents ?traceability_package)
        (not
          (package_available ?traceability_package)
        )
      )
  )
  (:action mark_package_processed_for_reconciliation
    :parameters (?traceability_package - traceability_package ?account_reconciliation - account_reconciliation ?investigator - investigator)
    :precondition
      (and
        (package_assembled ?traceability_package)
        (account_reconciliation_triaged ?account_reconciliation)
        (investigator_assigned ?account_reconciliation ?investigator)
        (not
          (package_processed ?traceability_package)
        )
      )
    :effect (package_processed ?traceability_package)
  )
  (:action attach_workpaper_attachment_to_package
    :parameters (?control_workpaper - control_workpaper ?workpaper_attachment - workpaper_attachment ?traceability_package - traceability_package)
    :precondition
      (and
        (entity_validated ?control_workpaper)
        (workpaper_package_link ?control_workpaper ?traceability_package)
        (workpaper_attachment_link ?control_workpaper ?workpaper_attachment)
        (attachment_available ?workpaper_attachment)
        (package_assembled ?traceability_package)
        (package_processed ?traceability_package)
        (not
          (attachment_consumed ?workpaper_attachment)
        )
      )
    :effect
      (and
        (attachment_consumed ?workpaper_attachment)
        (attachment_linked_to_package ?workpaper_attachment ?traceability_package)
        (not
          (attachment_available ?workpaper_attachment)
        )
      )
  )
  (:action process_attachment_and_enrich_workpaper
    :parameters (?control_workpaper - control_workpaper ?workpaper_attachment - workpaper_attachment ?traceability_package - traceability_package ?investigator - investigator)
    :precondition
      (and
        (entity_validated ?control_workpaper)
        (workpaper_attachment_link ?control_workpaper ?workpaper_attachment)
        (attachment_consumed ?workpaper_attachment)
        (attachment_linked_to_package ?workpaper_attachment ?traceability_package)
        (investigator_assigned ?control_workpaper ?investigator)
        (not
          (package_includes_reconciliation_documents ?traceability_package)
        )
        (not
          (workpaper_enrichment_started ?control_workpaper)
        )
      )
    :effect (workpaper_enrichment_started ?control_workpaper)
  )
  (:action attach_policy_reference_to_workpaper
    :parameters (?control_workpaper - control_workpaper ?policy_reference - policy_reference)
    :precondition
      (and
        (entity_validated ?control_workpaper)
        (policy_reference_available ?policy_reference)
        (not
          (policy_attached ?control_workpaper)
        )
      )
    :effect
      (and
        (policy_attached ?control_workpaper)
        (workpaper_policy_link ?control_workpaper ?policy_reference)
        (not
          (policy_reference_available ?policy_reference)
        )
      )
  )
  (:action apply_policy_and_start_workpaper_enrichment
    :parameters (?control_workpaper - control_workpaper ?workpaper_attachment - workpaper_attachment ?traceability_package - traceability_package ?investigator - investigator ?policy_reference - policy_reference)
    :precondition
      (and
        (entity_validated ?control_workpaper)
        (workpaper_attachment_link ?control_workpaper ?workpaper_attachment)
        (attachment_consumed ?workpaper_attachment)
        (attachment_linked_to_package ?workpaper_attachment ?traceability_package)
        (investigator_assigned ?control_workpaper ?investigator)
        (package_includes_reconciliation_documents ?traceability_package)
        (policy_attached ?control_workpaper)
        (workpaper_policy_link ?control_workpaper ?policy_reference)
        (not
          (workpaper_enrichment_started ?control_workpaper)
        )
      )
    :effect
      (and
        (workpaper_enrichment_started ?control_workpaper)
        (policy_processed_on_workpaper ?control_workpaper)
      )
  )
  (:action enrich_workpaper_with_extract_and_attachment
    :parameters (?control_workpaper - control_workpaper ?system_extract - system_extract ?approver - approver ?workpaper_attachment - workpaper_attachment ?traceability_package - traceability_package)
    :precondition
      (and
        (workpaper_enrichment_started ?control_workpaper)
        (workpaper_system_extract_link ?control_workpaper ?system_extract)
        (approver_assigned ?control_workpaper ?approver)
        (workpaper_attachment_link ?control_workpaper ?workpaper_attachment)
        (attachment_linked_to_package ?workpaper_attachment ?traceability_package)
        (not
          (package_includes_subledger_documents ?traceability_package)
        )
        (not
          (workpaper_enriched ?control_workpaper)
        )
      )
    :effect (workpaper_enriched ?control_workpaper)
  )
  (:action enrich_workpaper_with_extract_and_attachment_variant
    :parameters (?control_workpaper - control_workpaper ?system_extract - system_extract ?approver - approver ?workpaper_attachment - workpaper_attachment ?traceability_package - traceability_package)
    :precondition
      (and
        (workpaper_enrichment_started ?control_workpaper)
        (workpaper_system_extract_link ?control_workpaper ?system_extract)
        (approver_assigned ?control_workpaper ?approver)
        (workpaper_attachment_link ?control_workpaper ?workpaper_attachment)
        (attachment_linked_to_package ?workpaper_attachment ?traceability_package)
        (package_includes_subledger_documents ?traceability_package)
        (not
          (workpaper_enriched ?control_workpaper)
        )
      )
    :effect (workpaper_enriched ?control_workpaper)
  )
  (:action apply_annotation_and_mark_enrichment_complete
    :parameters (?control_workpaper - control_workpaper ?audit_annotation - audit_annotation ?workpaper_attachment - workpaper_attachment ?traceability_package - traceability_package)
    :precondition
      (and
        (workpaper_enriched ?control_workpaper)
        (workpaper_annotation_link ?control_workpaper ?audit_annotation)
        (workpaper_attachment_link ?control_workpaper ?workpaper_attachment)
        (attachment_linked_to_package ?workpaper_attachment ?traceability_package)
        (not
          (package_includes_reconciliation_documents ?traceability_package)
        )
        (not
          (package_includes_subledger_documents ?traceability_package)
        )
        (not
          (workpaper_enrichment_complete ?control_workpaper)
        )
      )
    :effect (workpaper_enrichment_complete ?control_workpaper)
  )
  (:action complete_enrichment_and_prepare_template
    :parameters (?control_workpaper - control_workpaper ?audit_annotation - audit_annotation ?workpaper_attachment - workpaper_attachment ?traceability_package - traceability_package)
    :precondition
      (and
        (workpaper_enriched ?control_workpaper)
        (workpaper_annotation_link ?control_workpaper ?audit_annotation)
        (workpaper_attachment_link ?control_workpaper ?workpaper_attachment)
        (attachment_linked_to_package ?workpaper_attachment ?traceability_package)
        (package_includes_reconciliation_documents ?traceability_package)
        (not
          (package_includes_subledger_documents ?traceability_package)
        )
        (not
          (workpaper_enrichment_complete ?control_workpaper)
        )
      )
    :effect
      (and
        (workpaper_enrichment_complete ?control_workpaper)
        (workpaper_template_ready ?control_workpaper)
      )
  )
  (:action complete_enrichment_and_prepare_template_variant_b
    :parameters (?control_workpaper - control_workpaper ?audit_annotation - audit_annotation ?workpaper_attachment - workpaper_attachment ?traceability_package - traceability_package)
    :precondition
      (and
        (workpaper_enriched ?control_workpaper)
        (workpaper_annotation_link ?control_workpaper ?audit_annotation)
        (workpaper_attachment_link ?control_workpaper ?workpaper_attachment)
        (attachment_linked_to_package ?workpaper_attachment ?traceability_package)
        (not
          (package_includes_reconciliation_documents ?traceability_package)
        )
        (package_includes_subledger_documents ?traceability_package)
        (not
          (workpaper_enrichment_complete ?control_workpaper)
        )
      )
    :effect
      (and
        (workpaper_enrichment_complete ?control_workpaper)
        (workpaper_template_ready ?control_workpaper)
      )
  )
  (:action complete_enrichment_and_prepare_template_variant_c
    :parameters (?control_workpaper - control_workpaper ?audit_annotation - audit_annotation ?workpaper_attachment - workpaper_attachment ?traceability_package - traceability_package)
    :precondition
      (and
        (workpaper_enriched ?control_workpaper)
        (workpaper_annotation_link ?control_workpaper ?audit_annotation)
        (workpaper_attachment_link ?control_workpaper ?workpaper_attachment)
        (attachment_linked_to_package ?workpaper_attachment ?traceability_package)
        (package_includes_reconciliation_documents ?traceability_package)
        (package_includes_subledger_documents ?traceability_package)
        (not
          (workpaper_enrichment_complete ?control_workpaper)
        )
      )
    :effect
      (and
        (workpaper_enrichment_complete ?control_workpaper)
        (workpaper_template_ready ?control_workpaper)
      )
  )
  (:action route_workpaper_for_approval
    :parameters (?control_workpaper - control_workpaper)
    :precondition
      (and
        (workpaper_enrichment_complete ?control_workpaper)
        (not
          (workpaper_template_ready ?control_workpaper)
        )
        (not
          (workpaper_routed_for_approval ?control_workpaper)
        )
      )
    :effect
      (and
        (workpaper_routed_for_approval ?control_workpaper)
        (entity_ready ?control_workpaper)
      )
  )
  (:action attach_control_template_to_workpaper
    :parameters (?control_workpaper - control_workpaper ?control_template - control_template)
    :precondition
      (and
        (workpaper_enrichment_complete ?control_workpaper)
        (workpaper_template_ready ?control_workpaper)
        (control_template_available ?control_template)
      )
    :effect
      (and
        (workpaper_template_link ?control_workpaper ?control_template)
        (not
          (control_template_available ?control_template)
        )
      )
  )
  (:action consolidate_workpaper
    :parameters (?control_workpaper - control_workpaper ?account_reconciliation - account_reconciliation ?subledger_reconciliation - subledger_reconciliation ?investigator - investigator ?control_template - control_template)
    :precondition
      (and
        (workpaper_enrichment_complete ?control_workpaper)
        (workpaper_template_ready ?control_workpaper)
        (workpaper_template_link ?control_workpaper ?control_template)
        (workpaper_linked_reconciliation ?control_workpaper ?account_reconciliation)
        (workpaper_linked_subledger_reconciliation ?control_workpaper ?subledger_reconciliation)
        (account_reconciliation_ready ?account_reconciliation)
        (subledger_reconciliation_ready ?subledger_reconciliation)
        (investigator_assigned ?control_workpaper ?investigator)
        (not
          (workpaper_consolidated ?control_workpaper)
        )
      )
    :effect (workpaper_consolidated ?control_workpaper)
  )
  (:action finalize_consolidated_workpaper
    :parameters (?control_workpaper - control_workpaper)
    :precondition
      (and
        (workpaper_enrichment_complete ?control_workpaper)
        (workpaper_consolidated ?control_workpaper)
        (not
          (workpaper_routed_for_approval ?control_workpaper)
        )
      )
    :effect
      (and
        (workpaper_routed_for_approval ?control_workpaper)
        (entity_ready ?control_workpaper)
      )
  )
  (:action record_approver_signature
    :parameters (?control_workpaper - control_workpaper ?approver_signature - approver_signature ?investigator - investigator)
    :precondition
      (and
        (entity_validated ?control_workpaper)
        (investigator_assigned ?control_workpaper ?investigator)
        (approver_signature_available ?approver_signature)
        (workpaper_signature_link ?control_workpaper ?approver_signature)
        (not
          (signature_recorded ?control_workpaper)
        )
      )
    :effect
      (and
        (signature_recorded ?control_workpaper)
        (not
          (approver_signature_available ?approver_signature)
        )
      )
  )
  (:action verify_approver_signature
    :parameters (?control_workpaper - control_workpaper ?approver - approver)
    :precondition
      (and
        (signature_recorded ?control_workpaper)
        (approver_assigned ?control_workpaper ?approver)
        (not
          (signature_verified ?control_workpaper)
        )
      )
    :effect (signature_verified ?control_workpaper)
  )
  (:action apply_audit_annotation
    :parameters (?control_workpaper - control_workpaper ?audit_annotation - audit_annotation)
    :precondition
      (and
        (signature_verified ?control_workpaper)
        (workpaper_annotation_link ?control_workpaper ?audit_annotation)
        (not
          (approval_completed ?control_workpaper)
        )
      )
    :effect (approval_completed ?control_workpaper)
  )
  (:action finalize_workpaper_after_approval
    :parameters (?control_workpaper - control_workpaper)
    :precondition
      (and
        (approval_completed ?control_workpaper)
        (not
          (workpaper_routed_for_approval ?control_workpaper)
        )
      )
    :effect
      (and
        (workpaper_routed_for_approval ?control_workpaper)
        (entity_ready ?control_workpaper)
      )
  )
  (:action flag_account_reconciliation_ready_for_routing
    :parameters (?account_reconciliation - account_reconciliation ?traceability_package - traceability_package)
    :precondition
      (and
        (account_reconciliation_triaged ?account_reconciliation)
        (account_reconciliation_ready ?account_reconciliation)
        (package_assembled ?traceability_package)
        (package_processed ?traceability_package)
        (not
          (entity_ready ?account_reconciliation)
        )
      )
    :effect (entity_ready ?account_reconciliation)
  )
  (:action flag_subledger_reconciliation_ready_for_routing
    :parameters (?subledger_reconciliation - subledger_reconciliation ?traceability_package - traceability_package)
    :precondition
      (and
        (subledger_reconciliation_triaged ?subledger_reconciliation)
        (subledger_reconciliation_ready ?subledger_reconciliation)
        (package_assembled ?traceability_package)
        (package_processed ?traceability_package)
        (not
          (entity_ready ?subledger_reconciliation)
        )
      )
    :effect (entity_ready ?subledger_reconciliation)
  )
  (:action assign_audit_marker_to_case
    :parameters (?accounting_entity - accounting_entity ?audit_marker - audit_marker ?investigator - investigator)
    :precondition
      (and
        (entity_ready ?accounting_entity)
        (investigator_assigned ?accounting_entity ?investigator)
        (audit_marker_available ?audit_marker)
        (not
          (finalization_requested ?accounting_entity)
        )
      )
    :effect
      (and
        (finalization_requested ?accounting_entity)
        (audit_marker_assigned ?accounting_entity ?audit_marker)
        (not
          (audit_marker_available ?audit_marker)
        )
      )
  )
  (:action finalize_account_reconciliation_traceability
    :parameters (?account_reconciliation - account_reconciliation ?evidence_resource - evidence_resource ?audit_marker - audit_marker)
    :precondition
      (and
        (finalization_requested ?account_reconciliation)
        (evidence_assigned_to_case ?account_reconciliation ?evidence_resource)
        (audit_marker_assigned ?account_reconciliation ?audit_marker)
        (not
          (traceability_finalized ?account_reconciliation)
        )
      )
    :effect
      (and
        (traceability_finalized ?account_reconciliation)
        (evidence_resource_available ?evidence_resource)
        (audit_marker_available ?audit_marker)
      )
  )
  (:action finalize_subledger_reconciliation_traceability
    :parameters (?subledger_reconciliation - subledger_reconciliation ?evidence_resource - evidence_resource ?audit_marker - audit_marker)
    :precondition
      (and
        (finalization_requested ?subledger_reconciliation)
        (evidence_assigned_to_case ?subledger_reconciliation ?evidence_resource)
        (audit_marker_assigned ?subledger_reconciliation ?audit_marker)
        (not
          (traceability_finalized ?subledger_reconciliation)
        )
      )
    :effect
      (and
        (traceability_finalized ?subledger_reconciliation)
        (evidence_resource_available ?evidence_resource)
        (audit_marker_available ?audit_marker)
      )
  )
  (:action finalize_workpaper_traceability
    :parameters (?control_workpaper - control_workpaper ?evidence_resource - evidence_resource ?audit_marker - audit_marker)
    :precondition
      (and
        (finalization_requested ?control_workpaper)
        (evidence_assigned_to_case ?control_workpaper ?evidence_resource)
        (audit_marker_assigned ?control_workpaper ?audit_marker)
        (not
          (traceability_finalized ?control_workpaper)
        )
      )
    :effect
      (and
        (traceability_finalized ?control_workpaper)
        (evidence_resource_available ?evidence_resource)
        (audit_marker_available ?audit_marker)
      )
  )
)

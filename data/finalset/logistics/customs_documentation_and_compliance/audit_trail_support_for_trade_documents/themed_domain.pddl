(define (domain audit_trail_support_for_trade_documents_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types party_or_resource - object document_resource_group - object regulatory_requirement_group - object trade_domain_root - object trade_document - trade_domain_root trade_agent - party_or_resource commodity_classification - party_or_resource authorized_representative - party_or_resource endorsement - party_or_resource inspection_report - party_or_resource audit_evidence - party_or_resource authority_approval - party_or_resource special_permit - party_or_resource supporting_document - document_resource_group compliance_evidence - document_resource_group regulatory_reference - document_resource_group export_regulatory_requirement - regulatory_requirement_group import_regulatory_requirement - regulatory_requirement_group submission_package - regulatory_requirement_group declaration_document_type - trade_document case_record_type - trade_document export_declaration - declaration_document_type import_declaration - declaration_document_type compliance_case - case_record_type)
  (:predicates
    (record_registered ?trade_document - trade_document)
    (record_validated ?trade_document - trade_document)
    (record_agent_assigned ?trade_document - trade_document)
    (clearance_confirmed ?trade_document - trade_document)
    (record_finalized ?trade_document - trade_document)
    (audit_evidence_linked_to_record ?trade_document - trade_document)
    (agent_available ?trade_agent - trade_agent)
    (record_assigned_to_agent ?trade_document - trade_document ?trade_agent - trade_agent)
    (classification_service_available ?commodity_classification - commodity_classification)
    (record_classified_with ?trade_document - trade_document ?commodity_classification - commodity_classification)
    (representative_available ?authorized_representative - authorized_representative)
    (representative_assigned_to_record ?trade_document - trade_document ?authorized_representative - authorized_representative)
    (supporting_document_available ?supporting_document - supporting_document)
    (export_declaration_has_supporting_document ?export_declaration - export_declaration ?supporting_document - supporting_document)
    (import_declaration_has_supporting_document ?import_declaration - import_declaration ?supporting_document - supporting_document)
    (export_declaration_has_requirement ?export_declaration - export_declaration ?export_regulatory_requirement - export_regulatory_requirement)
    (export_requirement_verified ?export_regulatory_requirement - export_regulatory_requirement)
    (export_requirement_document_attached ?export_regulatory_requirement - export_regulatory_requirement)
    (export_declaration_ready ?export_declaration - export_declaration)
    (import_declaration_has_requirement ?import_declaration - import_declaration ?import_regulatory_requirement - import_regulatory_requirement)
    (import_requirement_verified ?import_regulatory_requirement - import_regulatory_requirement)
    (import_requirement_document_attached ?import_regulatory_requirement - import_regulatory_requirement)
    (import_declaration_ready ?import_declaration - import_declaration)
    (submission_package_available ?submission_package - submission_package)
    (submission_package_ready ?submission_package - submission_package)
    (package_covers_export_requirement ?submission_package - submission_package ?export_regulatory_requirement - export_regulatory_requirement)
    (package_covers_import_requirement ?submission_package - submission_package ?import_regulatory_requirement - import_regulatory_requirement)
    (submission_requires_endorsement ?submission_package - submission_package)
    (submission_requires_authority_approval ?submission_package - submission_package)
    (submission_package_processed ?submission_package - submission_package)
    (case_references_export_declaration ?compliance_case - compliance_case ?export_declaration - export_declaration)
    (case_references_import_declaration ?compliance_case - compliance_case ?import_declaration - import_declaration)
    (case_includes_submission_package ?compliance_case - compliance_case ?submission_package - submission_package)
    (compliance_evidence_available ?compliance_evidence - compliance_evidence)
    (case_has_compliance_evidence ?compliance_case - compliance_case ?compliance_evidence - compliance_evidence)
    (compliance_evidence_bound ?compliance_evidence - compliance_evidence)
    (evidence_attached_to_package ?compliance_evidence - compliance_evidence ?submission_package - submission_package)
    (case_evidence_bound ?compliance_case - compliance_case)
    (case_approvals_bound ?compliance_case - compliance_case)
    (case_review_completed ?compliance_case - compliance_case)
    (endorsement_allocated_to_case ?compliance_case - compliance_case)
    (case_endorsement_applied ?compliance_case - compliance_case)
    (inspection_required ?compliance_case - compliance_case)
    (case_clearance_authorized ?compliance_case - compliance_case)
    (regulatory_reference_available ?regulatory_reference - regulatory_reference)
    (case_has_regulatory_reference ?compliance_case - compliance_case ?regulatory_reference - regulatory_reference)
    (regulatory_reference_applied ?compliance_case - compliance_case)
    (case_representative_verified ?compliance_case - compliance_case)
    (case_special_permit_attached ?compliance_case - compliance_case)
    (endorsement_available ?endorsement - endorsement)
    (case_has_endorsement ?compliance_case - compliance_case ?endorsement - endorsement)
    (inspection_report_available ?inspection_report - inspection_report)
    (case_has_inspection_report ?compliance_case - compliance_case ?inspection_report - inspection_report)
    (authority_approval_available ?authority_approval - authority_approval)
    (case_has_authority_approval ?compliance_case - compliance_case ?authority_approval - authority_approval)
    (special_permit_available ?special_permit - special_permit)
    (case_has_special_permit ?compliance_case - compliance_case ?special_permit - special_permit)
    (audit_evidence_available ?audit_evidence - audit_evidence)
    (record_has_audit_evidence ?trade_document - trade_document ?audit_evidence - audit_evidence)
    (export_declaration_assessed ?export_declaration - export_declaration)
    (import_declaration_assessed ?import_declaration - import_declaration)
    (case_audit_record_created ?compliance_case - compliance_case)
  )
  (:action register_trade_document
    :parameters (?trade_document - trade_document)
    :precondition
      (and
        (not
          (record_registered ?trade_document)
        )
        (not
          (clearance_confirmed ?trade_document)
        )
      )
    :effect (record_registered ?trade_document)
  )
  (:action assign_agent_to_document
    :parameters (?trade_document - trade_document ?trade_agent - trade_agent)
    :precondition
      (and
        (record_registered ?trade_document)
        (not
          (record_agent_assigned ?trade_document)
        )
        (agent_available ?trade_agent)
      )
    :effect
      (and
        (record_agent_assigned ?trade_document)
        (record_assigned_to_agent ?trade_document ?trade_agent)
        (not
          (agent_available ?trade_agent)
        )
      )
  )
  (:action perform_commodity_classification
    :parameters (?trade_document - trade_document ?commodity_classification - commodity_classification)
    :precondition
      (and
        (record_registered ?trade_document)
        (record_agent_assigned ?trade_document)
        (classification_service_available ?commodity_classification)
      )
    :effect
      (and
        (record_classified_with ?trade_document ?commodity_classification)
        (not
          (classification_service_available ?commodity_classification)
        )
      )
  )
  (:action finalize_document_validation
    :parameters (?trade_document - trade_document ?commodity_classification - commodity_classification)
    :precondition
      (and
        (record_registered ?trade_document)
        (record_agent_assigned ?trade_document)
        (record_classified_with ?trade_document ?commodity_classification)
        (not
          (record_validated ?trade_document)
        )
      )
    :effect (record_validated ?trade_document)
  )
  (:action release_classification_service
    :parameters (?trade_document - trade_document ?commodity_classification - commodity_classification)
    :precondition
      (and
        (record_classified_with ?trade_document ?commodity_classification)
      )
    :effect
      (and
        (classification_service_available ?commodity_classification)
        (not
          (record_classified_with ?trade_document ?commodity_classification)
        )
      )
  )
  (:action assign_authorized_representative
    :parameters (?trade_document - trade_document ?authorized_representative - authorized_representative)
    :precondition
      (and
        (record_validated ?trade_document)
        (representative_available ?authorized_representative)
      )
    :effect
      (and
        (representative_assigned_to_record ?trade_document ?authorized_representative)
        (not
          (representative_available ?authorized_representative)
        )
      )
  )
  (:action release_authorized_representative_assignment
    :parameters (?trade_document - trade_document ?authorized_representative - authorized_representative)
    :precondition
      (and
        (representative_assigned_to_record ?trade_document ?authorized_representative)
      )
    :effect
      (and
        (representative_available ?authorized_representative)
        (not
          (representative_assigned_to_record ?trade_document ?authorized_representative)
        )
      )
  )
  (:action attach_authority_approval_to_case
    :parameters (?compliance_case - compliance_case ?authority_approval - authority_approval)
    :precondition
      (and
        (record_validated ?compliance_case)
        (authority_approval_available ?authority_approval)
      )
    :effect
      (and
        (case_has_authority_approval ?compliance_case ?authority_approval)
        (not
          (authority_approval_available ?authority_approval)
        )
      )
  )
  (:action release_authority_approval_from_case
    :parameters (?compliance_case - compliance_case ?authority_approval - authority_approval)
    :precondition
      (and
        (case_has_authority_approval ?compliance_case ?authority_approval)
      )
    :effect
      (and
        (authority_approval_available ?authority_approval)
        (not
          (case_has_authority_approval ?compliance_case ?authority_approval)
        )
      )
  )
  (:action attach_special_permit_to_case
    :parameters (?compliance_case - compliance_case ?special_permit - special_permit)
    :precondition
      (and
        (record_validated ?compliance_case)
        (special_permit_available ?special_permit)
      )
    :effect
      (and
        (case_has_special_permit ?compliance_case ?special_permit)
        (not
          (special_permit_available ?special_permit)
        )
      )
  )
  (:action release_special_permit_from_case
    :parameters (?compliance_case - compliance_case ?special_permit - special_permit)
    :precondition
      (and
        (case_has_special_permit ?compliance_case ?special_permit)
      )
    :effect
      (and
        (special_permit_available ?special_permit)
        (not
          (case_has_special_permit ?compliance_case ?special_permit)
        )
      )
  )
  (:action evaluate_export_requirement
    :parameters (?export_declaration - export_declaration ?export_regulatory_requirement - export_regulatory_requirement ?commodity_classification - commodity_classification)
    :precondition
      (and
        (record_validated ?export_declaration)
        (record_classified_with ?export_declaration ?commodity_classification)
        (export_declaration_has_requirement ?export_declaration ?export_regulatory_requirement)
        (not
          (export_requirement_verified ?export_regulatory_requirement)
        )
        (not
          (export_requirement_document_attached ?export_regulatory_requirement)
        )
      )
    :effect (export_requirement_verified ?export_regulatory_requirement)
  )
  (:action assess_export_requirement_with_representative
    :parameters (?export_declaration - export_declaration ?export_regulatory_requirement - export_regulatory_requirement ?authorized_representative - authorized_representative)
    :precondition
      (and
        (record_validated ?export_declaration)
        (representative_assigned_to_record ?export_declaration ?authorized_representative)
        (export_declaration_has_requirement ?export_declaration ?export_regulatory_requirement)
        (export_requirement_verified ?export_regulatory_requirement)
        (not
          (export_declaration_assessed ?export_declaration)
        )
      )
    :effect
      (and
        (export_declaration_assessed ?export_declaration)
        (export_declaration_ready ?export_declaration)
      )
  )
  (:action attach_supporting_document_to_export_declaration
    :parameters (?export_declaration - export_declaration ?export_regulatory_requirement - export_regulatory_requirement ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?export_declaration)
        (export_declaration_has_requirement ?export_declaration ?export_regulatory_requirement)
        (supporting_document_available ?supporting_document)
        (not
          (export_declaration_assessed ?export_declaration)
        )
      )
    :effect
      (and
        (export_requirement_document_attached ?export_regulatory_requirement)
        (export_declaration_assessed ?export_declaration)
        (export_declaration_has_supporting_document ?export_declaration ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_export_requirement_with_supporting_document
    :parameters (?export_declaration - export_declaration ?export_regulatory_requirement - export_regulatory_requirement ?commodity_classification - commodity_classification ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?export_declaration)
        (record_classified_with ?export_declaration ?commodity_classification)
        (export_declaration_has_requirement ?export_declaration ?export_regulatory_requirement)
        (export_requirement_document_attached ?export_regulatory_requirement)
        (export_declaration_has_supporting_document ?export_declaration ?supporting_document)
        (not
          (export_declaration_ready ?export_declaration)
        )
      )
    :effect
      (and
        (export_requirement_verified ?export_regulatory_requirement)
        (export_declaration_ready ?export_declaration)
        (supporting_document_available ?supporting_document)
        (not
          (export_declaration_has_supporting_document ?export_declaration ?supporting_document)
        )
      )
  )
  (:action evaluate_import_requirement
    :parameters (?import_declaration - import_declaration ?import_regulatory_requirement - import_regulatory_requirement ?commodity_classification - commodity_classification)
    :precondition
      (and
        (record_validated ?import_declaration)
        (record_classified_with ?import_declaration ?commodity_classification)
        (import_declaration_has_requirement ?import_declaration ?import_regulatory_requirement)
        (not
          (import_requirement_verified ?import_regulatory_requirement)
        )
        (not
          (import_requirement_document_attached ?import_regulatory_requirement)
        )
      )
    :effect (import_requirement_verified ?import_regulatory_requirement)
  )
  (:action assess_import_requirement_with_representative
    :parameters (?import_declaration - import_declaration ?import_regulatory_requirement - import_regulatory_requirement ?authorized_representative - authorized_representative)
    :precondition
      (and
        (record_validated ?import_declaration)
        (representative_assigned_to_record ?import_declaration ?authorized_representative)
        (import_declaration_has_requirement ?import_declaration ?import_regulatory_requirement)
        (import_requirement_verified ?import_regulatory_requirement)
        (not
          (import_declaration_assessed ?import_declaration)
        )
      )
    :effect
      (and
        (import_declaration_assessed ?import_declaration)
        (import_declaration_ready ?import_declaration)
      )
  )
  (:action attach_supporting_document_to_import_declaration
    :parameters (?import_declaration - import_declaration ?import_regulatory_requirement - import_regulatory_requirement ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?import_declaration)
        (import_declaration_has_requirement ?import_declaration ?import_regulatory_requirement)
        (supporting_document_available ?supporting_document)
        (not
          (import_declaration_assessed ?import_declaration)
        )
      )
    :effect
      (and
        (import_requirement_document_attached ?import_regulatory_requirement)
        (import_declaration_assessed ?import_declaration)
        (import_declaration_has_supporting_document ?import_declaration ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_import_requirement_with_supporting_document
    :parameters (?import_declaration - import_declaration ?import_regulatory_requirement - import_regulatory_requirement ?commodity_classification - commodity_classification ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?import_declaration)
        (record_classified_with ?import_declaration ?commodity_classification)
        (import_declaration_has_requirement ?import_declaration ?import_regulatory_requirement)
        (import_requirement_document_attached ?import_regulatory_requirement)
        (import_declaration_has_supporting_document ?import_declaration ?supporting_document)
        (not
          (import_declaration_ready ?import_declaration)
        )
      )
    :effect
      (and
        (import_requirement_verified ?import_regulatory_requirement)
        (import_declaration_ready ?import_declaration)
        (supporting_document_available ?supporting_document)
        (not
          (import_declaration_has_supporting_document ?import_declaration ?supporting_document)
        )
      )
  )
  (:action assemble_submission_package_basic
    :parameters (?export_declaration - export_declaration ?import_declaration - import_declaration ?export_regulatory_requirement - export_regulatory_requirement ?import_regulatory_requirement - import_regulatory_requirement ?submission_package - submission_package)
    :precondition
      (and
        (export_declaration_assessed ?export_declaration)
        (import_declaration_assessed ?import_declaration)
        (export_declaration_has_requirement ?export_declaration ?export_regulatory_requirement)
        (import_declaration_has_requirement ?import_declaration ?import_regulatory_requirement)
        (export_requirement_verified ?export_regulatory_requirement)
        (import_requirement_verified ?import_regulatory_requirement)
        (export_declaration_ready ?export_declaration)
        (import_declaration_ready ?import_declaration)
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_ready ?submission_package)
        (package_covers_export_requirement ?submission_package ?export_regulatory_requirement)
        (package_covers_import_requirement ?submission_package ?import_regulatory_requirement)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_requires_endorsement
    :parameters (?export_declaration - export_declaration ?import_declaration - import_declaration ?export_regulatory_requirement - export_regulatory_requirement ?import_regulatory_requirement - import_regulatory_requirement ?submission_package - submission_package)
    :precondition
      (and
        (export_declaration_assessed ?export_declaration)
        (import_declaration_assessed ?import_declaration)
        (export_declaration_has_requirement ?export_declaration ?export_regulatory_requirement)
        (import_declaration_has_requirement ?import_declaration ?import_regulatory_requirement)
        (export_requirement_document_attached ?export_regulatory_requirement)
        (import_requirement_verified ?import_regulatory_requirement)
        (not
          (export_declaration_ready ?export_declaration)
        )
        (import_declaration_ready ?import_declaration)
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_ready ?submission_package)
        (package_covers_export_requirement ?submission_package ?export_regulatory_requirement)
        (package_covers_import_requirement ?submission_package ?import_regulatory_requirement)
        (submission_requires_endorsement ?submission_package)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_requires_authority_approval
    :parameters (?export_declaration - export_declaration ?import_declaration - import_declaration ?export_regulatory_requirement - export_regulatory_requirement ?import_regulatory_requirement - import_regulatory_requirement ?submission_package - submission_package)
    :precondition
      (and
        (export_declaration_assessed ?export_declaration)
        (import_declaration_assessed ?import_declaration)
        (export_declaration_has_requirement ?export_declaration ?export_regulatory_requirement)
        (import_declaration_has_requirement ?import_declaration ?import_regulatory_requirement)
        (export_requirement_verified ?export_regulatory_requirement)
        (import_requirement_document_attached ?import_regulatory_requirement)
        (export_declaration_ready ?export_declaration)
        (not
          (import_declaration_ready ?import_declaration)
        )
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_ready ?submission_package)
        (package_covers_export_requirement ?submission_package ?export_regulatory_requirement)
        (package_covers_import_requirement ?submission_package ?import_regulatory_requirement)
        (submission_requires_authority_approval ?submission_package)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_requires_endorsement_and_authority
    :parameters (?export_declaration - export_declaration ?import_declaration - import_declaration ?export_regulatory_requirement - export_regulatory_requirement ?import_regulatory_requirement - import_regulatory_requirement ?submission_package - submission_package)
    :precondition
      (and
        (export_declaration_assessed ?export_declaration)
        (import_declaration_assessed ?import_declaration)
        (export_declaration_has_requirement ?export_declaration ?export_regulatory_requirement)
        (import_declaration_has_requirement ?import_declaration ?import_regulatory_requirement)
        (export_requirement_document_attached ?export_regulatory_requirement)
        (import_requirement_document_attached ?import_regulatory_requirement)
        (not
          (export_declaration_ready ?export_declaration)
        )
        (not
          (import_declaration_ready ?import_declaration)
        )
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_ready ?submission_package)
        (package_covers_export_requirement ?submission_package ?export_regulatory_requirement)
        (package_covers_import_requirement ?submission_package ?import_regulatory_requirement)
        (submission_requires_endorsement ?submission_package)
        (submission_requires_authority_approval ?submission_package)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action mark_submission_package_verified
    :parameters (?submission_package - submission_package ?export_declaration - export_declaration ?commodity_classification - commodity_classification)
    :precondition
      (and
        (submission_package_ready ?submission_package)
        (export_declaration_assessed ?export_declaration)
        (record_classified_with ?export_declaration ?commodity_classification)
        (not
          (submission_package_processed ?submission_package)
        )
      )
    :effect (submission_package_processed ?submission_package)
  )
  (:action bind_evidence_to_case_and_package
    :parameters (?compliance_case - compliance_case ?compliance_evidence - compliance_evidence ?submission_package - submission_package)
    :precondition
      (and
        (record_validated ?compliance_case)
        (case_includes_submission_package ?compliance_case ?submission_package)
        (case_has_compliance_evidence ?compliance_case ?compliance_evidence)
        (compliance_evidence_available ?compliance_evidence)
        (submission_package_ready ?submission_package)
        (submission_package_processed ?submission_package)
        (not
          (compliance_evidence_bound ?compliance_evidence)
        )
      )
    :effect
      (and
        (compliance_evidence_bound ?compliance_evidence)
        (evidence_attached_to_package ?compliance_evidence ?submission_package)
        (not
          (compliance_evidence_available ?compliance_evidence)
        )
      )
  )
  (:action finalize_evidence_binding_on_case
    :parameters (?compliance_case - compliance_case ?compliance_evidence - compliance_evidence ?submission_package - submission_package ?commodity_classification - commodity_classification)
    :precondition
      (and
        (record_validated ?compliance_case)
        (case_has_compliance_evidence ?compliance_case ?compliance_evidence)
        (compliance_evidence_bound ?compliance_evidence)
        (evidence_attached_to_package ?compliance_evidence ?submission_package)
        (record_classified_with ?compliance_case ?commodity_classification)
        (not
          (submission_requires_endorsement ?submission_package)
        )
        (not
          (case_evidence_bound ?compliance_case)
        )
      )
    :effect (case_evidence_bound ?compliance_case)
  )
  (:action reserve_endorsement_for_case
    :parameters (?compliance_case - compliance_case ?endorsement - endorsement)
    :precondition
      (and
        (record_validated ?compliance_case)
        (endorsement_available ?endorsement)
        (not
          (endorsement_allocated_to_case ?compliance_case)
        )
      )
    :effect
      (and
        (endorsement_allocated_to_case ?compliance_case)
        (case_has_endorsement ?compliance_case ?endorsement)
        (not
          (endorsement_available ?endorsement)
        )
      )
  )
  (:action apply_endorsement_and_bind_case
    :parameters (?compliance_case - compliance_case ?compliance_evidence - compliance_evidence ?submission_package - submission_package ?commodity_classification - commodity_classification ?endorsement - endorsement)
    :precondition
      (and
        (record_validated ?compliance_case)
        (case_has_compliance_evidence ?compliance_case ?compliance_evidence)
        (compliance_evidence_bound ?compliance_evidence)
        (evidence_attached_to_package ?compliance_evidence ?submission_package)
        (record_classified_with ?compliance_case ?commodity_classification)
        (submission_requires_endorsement ?submission_package)
        (endorsement_allocated_to_case ?compliance_case)
        (case_has_endorsement ?compliance_case ?endorsement)
        (not
          (case_evidence_bound ?compliance_case)
        )
      )
    :effect
      (and
        (case_evidence_bound ?compliance_case)
        (case_endorsement_applied ?compliance_case)
      )
  )
  (:action advance_case_approval_with_authority
    :parameters (?compliance_case - compliance_case ?authority_approval - authority_approval ?authorized_representative - authorized_representative ?compliance_evidence - compliance_evidence ?submission_package - submission_package)
    :precondition
      (and
        (case_evidence_bound ?compliance_case)
        (case_has_authority_approval ?compliance_case ?authority_approval)
        (representative_assigned_to_record ?compliance_case ?authorized_representative)
        (case_has_compliance_evidence ?compliance_case ?compliance_evidence)
        (evidence_attached_to_package ?compliance_evidence ?submission_package)
        (not
          (submission_requires_authority_approval ?submission_package)
        )
        (not
          (case_approvals_bound ?compliance_case)
        )
      )
    :effect (case_approvals_bound ?compliance_case)
  )
  (:action advance_case_approval_with_package_authority
    :parameters (?compliance_case - compliance_case ?authority_approval - authority_approval ?authorized_representative - authorized_representative ?compliance_evidence - compliance_evidence ?submission_package - submission_package)
    :precondition
      (and
        (case_evidence_bound ?compliance_case)
        (case_has_authority_approval ?compliance_case ?authority_approval)
        (representative_assigned_to_record ?compliance_case ?authorized_representative)
        (case_has_compliance_evidence ?compliance_case ?compliance_evidence)
        (evidence_attached_to_package ?compliance_evidence ?submission_package)
        (submission_requires_authority_approval ?submission_package)
        (not
          (case_approvals_bound ?compliance_case)
        )
      )
    :effect (case_approvals_bound ?compliance_case)
  )
  (:action complete_case_review_standard
    :parameters (?compliance_case - compliance_case ?special_permit - special_permit ?compliance_evidence - compliance_evidence ?submission_package - submission_package)
    :precondition
      (and
        (case_approvals_bound ?compliance_case)
        (case_has_special_permit ?compliance_case ?special_permit)
        (case_has_compliance_evidence ?compliance_case ?compliance_evidence)
        (evidence_attached_to_package ?compliance_evidence ?submission_package)
        (not
          (submission_requires_endorsement ?submission_package)
        )
        (not
          (submission_requires_authority_approval ?submission_package)
        )
        (not
          (case_review_completed ?compliance_case)
        )
      )
    :effect (case_review_completed ?compliance_case)
  )
  (:action complete_case_review_endorsement_path_requires_inspection
    :parameters (?compliance_case - compliance_case ?special_permit - special_permit ?compliance_evidence - compliance_evidence ?submission_package - submission_package)
    :precondition
      (and
        (case_approvals_bound ?compliance_case)
        (case_has_special_permit ?compliance_case ?special_permit)
        (case_has_compliance_evidence ?compliance_case ?compliance_evidence)
        (evidence_attached_to_package ?compliance_evidence ?submission_package)
        (submission_requires_endorsement ?submission_package)
        (not
          (submission_requires_authority_approval ?submission_package)
        )
        (not
          (case_review_completed ?compliance_case)
        )
      )
    :effect
      (and
        (case_review_completed ?compliance_case)
        (inspection_required ?compliance_case)
      )
  )
  (:action complete_case_review_authority_path_requires_inspection
    :parameters (?compliance_case - compliance_case ?special_permit - special_permit ?compliance_evidence - compliance_evidence ?submission_package - submission_package)
    :precondition
      (and
        (case_approvals_bound ?compliance_case)
        (case_has_special_permit ?compliance_case ?special_permit)
        (case_has_compliance_evidence ?compliance_case ?compliance_evidence)
        (evidence_attached_to_package ?compliance_evidence ?submission_package)
        (not
          (submission_requires_endorsement ?submission_package)
        )
        (submission_requires_authority_approval ?submission_package)
        (not
          (case_review_completed ?compliance_case)
        )
      )
    :effect
      (and
        (case_review_completed ?compliance_case)
        (inspection_required ?compliance_case)
      )
  )
  (:action complete_case_review_endorsement_and_authority_requires_inspection
    :parameters (?compliance_case - compliance_case ?special_permit - special_permit ?compliance_evidence - compliance_evidence ?submission_package - submission_package)
    :precondition
      (and
        (case_approvals_bound ?compliance_case)
        (case_has_special_permit ?compliance_case ?special_permit)
        (case_has_compliance_evidence ?compliance_case ?compliance_evidence)
        (evidence_attached_to_package ?compliance_evidence ?submission_package)
        (submission_requires_endorsement ?submission_package)
        (submission_requires_authority_approval ?submission_package)
        (not
          (case_review_completed ?compliance_case)
        )
      )
    :effect
      (and
        (case_review_completed ?compliance_case)
        (inspection_required ?compliance_case)
      )
  )
  (:action finalize_case_for_audit_without_inspection
    :parameters (?compliance_case - compliance_case)
    :precondition
      (and
        (case_review_completed ?compliance_case)
        (not
          (inspection_required ?compliance_case)
        )
        (not
          (case_audit_record_created ?compliance_case)
        )
      )
    :effect
      (and
        (case_audit_record_created ?compliance_case)
        (record_finalized ?compliance_case)
      )
  )
  (:action attach_inspection_report_to_case
    :parameters (?compliance_case - compliance_case ?inspection_report - inspection_report)
    :precondition
      (and
        (case_review_completed ?compliance_case)
        (inspection_required ?compliance_case)
        (inspection_report_available ?inspection_report)
      )
    :effect
      (and
        (case_has_inspection_report ?compliance_case ?inspection_report)
        (not
          (inspection_report_available ?inspection_report)
        )
      )
  )
  (:action authorize_case_for_clearance
    :parameters (?compliance_case - compliance_case ?export_declaration - export_declaration ?import_declaration - import_declaration ?commodity_classification - commodity_classification ?inspection_report - inspection_report)
    :precondition
      (and
        (case_review_completed ?compliance_case)
        (inspection_required ?compliance_case)
        (case_has_inspection_report ?compliance_case ?inspection_report)
        (case_references_export_declaration ?compliance_case ?export_declaration)
        (case_references_import_declaration ?compliance_case ?import_declaration)
        (export_declaration_ready ?export_declaration)
        (import_declaration_ready ?import_declaration)
        (record_classified_with ?compliance_case ?commodity_classification)
        (not
          (case_clearance_authorized ?compliance_case)
        )
      )
    :effect (case_clearance_authorized ?compliance_case)
  )
  (:action finalize_case_for_audit_with_clearance
    :parameters (?compliance_case - compliance_case)
    :precondition
      (and
        (case_review_completed ?compliance_case)
        (case_clearance_authorized ?compliance_case)
        (not
          (case_audit_record_created ?compliance_case)
        )
      )
    :effect
      (and
        (case_audit_record_created ?compliance_case)
        (record_finalized ?compliance_case)
      )
  )
  (:action apply_regulatory_reference_to_case
    :parameters (?compliance_case - compliance_case ?regulatory_reference - regulatory_reference ?commodity_classification - commodity_classification)
    :precondition
      (and
        (record_validated ?compliance_case)
        (record_classified_with ?compliance_case ?commodity_classification)
        (regulatory_reference_available ?regulatory_reference)
        (case_has_regulatory_reference ?compliance_case ?regulatory_reference)
        (not
          (regulatory_reference_applied ?compliance_case)
        )
      )
    :effect
      (and
        (regulatory_reference_applied ?compliance_case)
        (not
          (regulatory_reference_available ?regulatory_reference)
        )
      )
  )
  (:action confirm_representative_for_regulatory_reference
    :parameters (?compliance_case - compliance_case ?authorized_representative - authorized_representative)
    :precondition
      (and
        (regulatory_reference_applied ?compliance_case)
        (representative_assigned_to_record ?compliance_case ?authorized_representative)
        (not
          (case_representative_verified ?compliance_case)
        )
      )
    :effect (case_representative_verified ?compliance_case)
  )
  (:action affirm_special_permit_for_case
    :parameters (?compliance_case - compliance_case ?special_permit - special_permit)
    :precondition
      (and
        (case_representative_verified ?compliance_case)
        (case_has_special_permit ?compliance_case ?special_permit)
        (not
          (case_special_permit_attached ?compliance_case)
        )
      )
    :effect (case_special_permit_attached ?compliance_case)
  )
  (:action finalize_case_after_reference
    :parameters (?compliance_case - compliance_case)
    :precondition
      (and
        (case_special_permit_attached ?compliance_case)
        (not
          (case_audit_record_created ?compliance_case)
        )
      )
    :effect
      (and
        (case_audit_record_created ?compliance_case)
        (record_finalized ?compliance_case)
      )
  )
  (:action propagate_case_finalization_to_export_declaration
    :parameters (?export_declaration - export_declaration ?submission_package - submission_package)
    :precondition
      (and
        (export_declaration_assessed ?export_declaration)
        (export_declaration_ready ?export_declaration)
        (submission_package_ready ?submission_package)
        (submission_package_processed ?submission_package)
        (not
          (record_finalized ?export_declaration)
        )
      )
    :effect (record_finalized ?export_declaration)
  )
  (:action propagate_case_finalization_to_import_declaration
    :parameters (?import_declaration - import_declaration ?submission_package - submission_package)
    :precondition
      (and
        (import_declaration_assessed ?import_declaration)
        (import_declaration_ready ?import_declaration)
        (submission_package_ready ?submission_package)
        (submission_package_processed ?submission_package)
        (not
          (record_finalized ?import_declaration)
        )
      )
    :effect (record_finalized ?import_declaration)
  )
  (:action record_audit_evidence_for_document
    :parameters (?trade_document - trade_document ?audit_evidence - audit_evidence ?commodity_classification - commodity_classification)
    :precondition
      (and
        (record_finalized ?trade_document)
        (record_classified_with ?trade_document ?commodity_classification)
        (audit_evidence_available ?audit_evidence)
        (not
          (audit_evidence_linked_to_record ?trade_document)
        )
      )
    :effect
      (and
        (audit_evidence_linked_to_record ?trade_document)
        (record_has_audit_evidence ?trade_document ?audit_evidence)
        (not
          (audit_evidence_available ?audit_evidence)
        )
      )
  )
  (:action confirm_export_declaration_clearance
    :parameters (?export_declaration - export_declaration ?trade_agent - trade_agent ?audit_evidence - audit_evidence)
    :precondition
      (and
        (audit_evidence_linked_to_record ?export_declaration)
        (record_assigned_to_agent ?export_declaration ?trade_agent)
        (record_has_audit_evidence ?export_declaration ?audit_evidence)
        (not
          (clearance_confirmed ?export_declaration)
        )
      )
    :effect
      (and
        (clearance_confirmed ?export_declaration)
        (agent_available ?trade_agent)
        (audit_evidence_available ?audit_evidence)
      )
  )
  (:action confirm_import_declaration_clearance
    :parameters (?import_declaration - import_declaration ?trade_agent - trade_agent ?audit_evidence - audit_evidence)
    :precondition
      (and
        (audit_evidence_linked_to_record ?import_declaration)
        (record_assigned_to_agent ?import_declaration ?trade_agent)
        (record_has_audit_evidence ?import_declaration ?audit_evidence)
        (not
          (clearance_confirmed ?import_declaration)
        )
      )
    :effect
      (and
        (clearance_confirmed ?import_declaration)
        (agent_available ?trade_agent)
        (audit_evidence_available ?audit_evidence)
      )
  )
  (:action confirm_case_clearance
    :parameters (?compliance_case - compliance_case ?trade_agent - trade_agent ?audit_evidence - audit_evidence)
    :precondition
      (and
        (audit_evidence_linked_to_record ?compliance_case)
        (record_assigned_to_agent ?compliance_case ?trade_agent)
        (record_has_audit_evidence ?compliance_case ?audit_evidence)
        (not
          (clearance_confirmed ?compliance_case)
        )
      )
    :effect
      (and
        (clearance_confirmed ?compliance_case)
        (agent_available ?trade_agent)
        (audit_evidence_available ?audit_evidence)
      )
  )
)

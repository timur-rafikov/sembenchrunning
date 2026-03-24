(define (domain export_license_requirement_assessment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object resource_pool_category - entity document_family - entity regulatory_family - entity subject_family - entity export_shipment - subject_family assessor_slot - resource_pool_category classification_tool - resource_pool_category reviewer - resource_pool_category regulatory_reference - resource_pool_category approver_profile - resource_pool_category license_type - resource_pool_category authority_checklist - resource_pool_category authority_response - resource_pool_category supporting_doc_template - document_family verification_document - document_family endorsement_token - document_family control_list_entry - regulatory_family regulatory_rule - regulatory_family submission_package - regulatory_family line_item_container - export_shipment case_container - export_shipment line_item - line_item_container goods_package - line_item_container compliance_case - case_container)

  (:predicates
    (assessment_registered_for_subject ?shipment - export_shipment)
    (classification_confirmed_for_subject ?shipment - export_shipment)
    (assessor_assigned_for_subject ?shipment - export_shipment)
    (license_requirement_recorded_for_subject ?shipment - export_shipment)
    (ready_for_adjudication_for_subject ?shipment - export_shipment)
    (license_requirement_determined_for_subject ?shipment - export_shipment)
    (assessor_slot_available ?assessor_slot - assessor_slot)
    (subject_assigned_assessor ?shipment - export_shipment ?assessor_slot - assessor_slot)
    (classification_tool_available ?classification_tool - classification_tool)
    (subject_classification_binding ?shipment - export_shipment ?classification_tool - classification_tool)
    (reviewer_available ?reviewer - reviewer)
    (subject_assigned_reviewer ?shipment - export_shipment ?reviewer - reviewer)
    (supporting_doc_template_available ?supporting_doc_template - supporting_doc_template)
    (line_item_linked_doc_template ?line_item - line_item ?supporting_doc_template - supporting_doc_template)
    (package_linked_doc_template ?goods_package - goods_package ?supporting_doc_template - supporting_doc_template)
    (line_item_control_list_match ?line_item - line_item ?control_list_entry - control_list_entry)
    (control_list_entry_flagged ?control_list_entry - control_list_entry)
    (control_list_entry_document_required ?control_list_entry - control_list_entry)
    (line_item_screening_completed_for_subject ?line_item - line_item)
    (package_regulatory_rule_match ?goods_package - goods_package ?regulatory_rule - regulatory_rule)
    (regulatory_rule_flagged ?regulatory_rule - regulatory_rule)
    (regulatory_rule_document_required ?regulatory_rule - regulatory_rule)
    (package_screening_completed_for_subject ?goods_package - goods_package)
    (submission_package_pending_for_subject ?submission_package - submission_package)
    (submission_package_prepared_for_subject ?submission_package - submission_package)
    (submission_package_linked_control_list_entry ?submission_package - submission_package ?control_list_entry - control_list_entry)
    (submission_package_linked_regulatory_rule ?submission_package - submission_package ?regulatory_rule - regulatory_rule)
    (submission_package_requires_checklist_for_subject ?submission_package - submission_package)
    (submission_package_requires_endorsement_for_subject ?submission_package - submission_package)
    (submission_package_validated_for_subject ?submission_package - submission_package)
    (case_contains_line_item ?compliance_case - compliance_case ?line_item - line_item)
    (case_contains_goods_package ?compliance_case - compliance_case ?goods_package - goods_package)
    (case_contains_submission_package ?compliance_case - compliance_case ?submission_package - submission_package)
    (verification_document_available ?verification_document - verification_document)
    (case_linked_verification_document ?compliance_case - compliance_case ?verification_document - verification_document)
    (verification_document_verified ?verification_document - verification_document)
    (verification_document_linked_submission_package ?verification_document - verification_document ?submission_package - submission_package)
    (case_documents_verified_for_subject ?compliance_case - compliance_case)
    (case_endorsement_prepared_for_subject ?compliance_case - compliance_case)
    (case_endorsement_submitted_for_subject ?compliance_case - compliance_case)
    (case_regulatory_reference_attached_for_subject ?compliance_case - compliance_case)
    (case_regulatory_reference_verified_for_subject ?compliance_case - compliance_case)
    (case_ready_for_approver_assignment_for_subject ?compliance_case - compliance_case)
    (case_ready_for_finalization_for_subject ?compliance_case - compliance_case)
    (endorsement_token_available ?endorsement_token - endorsement_token)
    (case_linked_endorsement_token ?compliance_case - compliance_case ?endorsement_token - endorsement_token)
    (case_endorsement_attached_for_subject ?compliance_case - compliance_case)
    (case_endorsement_verified_for_subject ?compliance_case - compliance_case)
    (case_endorsement_finalized_for_subject ?compliance_case - compliance_case)
    (regulatory_reference_available ?regulatory_reference - regulatory_reference)
    (case_linked_regulatory_reference ?compliance_case - compliance_case ?regulatory_reference - regulatory_reference)
    (approver_profile_available ?approver_profile - approver_profile)
    (case_assigned_approver ?compliance_case - compliance_case ?approver_profile - approver_profile)
    (authority_checklist_available ?authority_checklist - authority_checklist)
    (case_linked_authority_checklist ?compliance_case - compliance_case ?authority_checklist - authority_checklist)
    (authority_response_available ?authority_response - authority_response)
    (case_linked_authority_response ?compliance_case - compliance_case ?authority_response - authority_response)
    (license_type_available ?license_type - license_type)
    (subject_linked_license_type ?shipment - export_shipment ?license_type - license_type)
    (line_item_ready_for_submission_for_subject ?line_item - line_item)
    (goods_package_ready_for_submission_for_subject ?goods_package - goods_package)
    (case_finalized_for_adjudication ?compliance_case - compliance_case)
  )
  (:action register_shipment_for_assessment
    :parameters (?shipment - export_shipment)
    :precondition
      (and
        (not
          (assessment_registered_for_subject ?shipment)
        )
        (not
          (license_requirement_recorded_for_subject ?shipment)
        )
      )
    :effect (assessment_registered_for_subject ?shipment)
  )
  (:action assign_assessor_to_shipment
    :parameters (?shipment - export_shipment ?assessor_slot - assessor_slot)
    :precondition
      (and
        (assessment_registered_for_subject ?shipment)
        (not
          (assessor_assigned_for_subject ?shipment)
        )
        (assessor_slot_available ?assessor_slot)
      )
    :effect
      (and
        (assessor_assigned_for_subject ?shipment)
        (subject_assigned_assessor ?shipment ?assessor_slot)
        (not
          (assessor_slot_available ?assessor_slot)
        )
      )
  )
  (:action invoke_classification_tool_for_shipment
    :parameters (?shipment - export_shipment ?classification_tool - classification_tool)
    :precondition
      (and
        (assessment_registered_for_subject ?shipment)
        (assessor_assigned_for_subject ?shipment)
        (classification_tool_available ?classification_tool)
      )
    :effect
      (and
        (subject_classification_binding ?shipment ?classification_tool)
        (not
          (classification_tool_available ?classification_tool)
        )
      )
  )
  (:action confirm_shipment_classification
    :parameters (?shipment - export_shipment ?classification_tool - classification_tool)
    :precondition
      (and
        (assessment_registered_for_subject ?shipment)
        (assessor_assigned_for_subject ?shipment)
        (subject_classification_binding ?shipment ?classification_tool)
        (not
          (classification_confirmed_for_subject ?shipment)
        )
      )
    :effect (classification_confirmed_for_subject ?shipment)
  )
  (:action unbind_classification_tool_from_shipment
    :parameters (?shipment - export_shipment ?classification_tool - classification_tool)
    :precondition
      (and
        (subject_classification_binding ?shipment ?classification_tool)
      )
    :effect
      (and
        (classification_tool_available ?classification_tool)
        (not
          (subject_classification_binding ?shipment ?classification_tool)
        )
      )
  )
  (:action assign_reviewer_to_shipment
    :parameters (?shipment - export_shipment ?reviewer - reviewer)
    :precondition
      (and
        (classification_confirmed_for_subject ?shipment)
        (reviewer_available ?reviewer)
      )
    :effect
      (and
        (subject_assigned_reviewer ?shipment ?reviewer)
        (not
          (reviewer_available ?reviewer)
        )
      )
  )
  (:action release_reviewer_from_shipment
    :parameters (?shipment - export_shipment ?reviewer - reviewer)
    :precondition
      (and
        (subject_assigned_reviewer ?shipment ?reviewer)
      )
    :effect
      (and
        (reviewer_available ?reviewer)
        (not
          (subject_assigned_reviewer ?shipment ?reviewer)
        )
      )
  )
  (:action attach_authority_checklist_to_case
    :parameters (?compliance_case - compliance_case ?authority_checklist - authority_checklist)
    :precondition
      (and
        (classification_confirmed_for_subject ?compliance_case)
        (authority_checklist_available ?authority_checklist)
      )
    :effect
      (and
        (case_linked_authority_checklist ?compliance_case ?authority_checklist)
        (not
          (authority_checklist_available ?authority_checklist)
        )
      )
  )
  (:action detach_authority_checklist_from_case
    :parameters (?compliance_case - compliance_case ?authority_checklist - authority_checklist)
    :precondition
      (and
        (case_linked_authority_checklist ?compliance_case ?authority_checklist)
      )
    :effect
      (and
        (authority_checklist_available ?authority_checklist)
        (not
          (case_linked_authority_checklist ?compliance_case ?authority_checklist)
        )
      )
  )
  (:action attach_authority_response_to_case
    :parameters (?compliance_case - compliance_case ?authority_response - authority_response)
    :precondition
      (and
        (classification_confirmed_for_subject ?compliance_case)
        (authority_response_available ?authority_response)
      )
    :effect
      (and
        (case_linked_authority_response ?compliance_case ?authority_response)
        (not
          (authority_response_available ?authority_response)
        )
      )
  )
  (:action detach_authority_response_from_case
    :parameters (?compliance_case - compliance_case ?authority_response - authority_response)
    :precondition
      (and
        (case_linked_authority_response ?compliance_case ?authority_response)
      )
    :effect
      (and
        (authority_response_available ?authority_response)
        (not
          (case_linked_authority_response ?compliance_case ?authority_response)
        )
      )
  )
  (:action flag_control_list_entry_for_line_item
    :parameters (?line_item - line_item ?control_list_entry - control_list_entry ?classification_tool - classification_tool)
    :precondition
      (and
        (classification_confirmed_for_subject ?line_item)
        (subject_classification_binding ?line_item ?classification_tool)
        (line_item_control_list_match ?line_item ?control_list_entry)
        (not
          (control_list_entry_flagged ?control_list_entry)
        )
        (not
          (control_list_entry_document_required ?control_list_entry)
        )
      )
    :effect (control_list_entry_flagged ?control_list_entry)
  )
  (:action resolve_control_list_match_with_reviewer
    :parameters (?line_item - line_item ?control_list_entry - control_list_entry ?reviewer - reviewer)
    :precondition
      (and
        (classification_confirmed_for_subject ?line_item)
        (subject_assigned_reviewer ?line_item ?reviewer)
        (line_item_control_list_match ?line_item ?control_list_entry)
        (control_list_entry_flagged ?control_list_entry)
        (not
          (line_item_ready_for_submission_for_subject ?line_item)
        )
      )
    :effect
      (and
        (line_item_ready_for_submission_for_subject ?line_item)
        (line_item_screening_completed_for_subject ?line_item)
      )
  )
  (:action apply_doc_template_to_line_item_for_control_match
    :parameters (?line_item - line_item ?control_list_entry - control_list_entry ?supporting_doc_template - supporting_doc_template)
    :precondition
      (and
        (classification_confirmed_for_subject ?line_item)
        (line_item_control_list_match ?line_item ?control_list_entry)
        (supporting_doc_template_available ?supporting_doc_template)
        (not
          (line_item_ready_for_submission_for_subject ?line_item)
        )
      )
    :effect
      (and
        (control_list_entry_document_required ?control_list_entry)
        (line_item_ready_for_submission_for_subject ?line_item)
        (line_item_linked_doc_template ?line_item ?supporting_doc_template)
        (not
          (supporting_doc_template_available ?supporting_doc_template)
        )
      )
  )
  (:action process_line_item_documentation_for_control_list
    :parameters (?line_item - line_item ?control_list_entry - control_list_entry ?classification_tool - classification_tool ?supporting_doc_template - supporting_doc_template)
    :precondition
      (and
        (classification_confirmed_for_subject ?line_item)
        (subject_classification_binding ?line_item ?classification_tool)
        (line_item_control_list_match ?line_item ?control_list_entry)
        (control_list_entry_document_required ?control_list_entry)
        (line_item_linked_doc_template ?line_item ?supporting_doc_template)
        (not
          (line_item_screening_completed_for_subject ?line_item)
        )
      )
    :effect
      (and
        (control_list_entry_flagged ?control_list_entry)
        (line_item_screening_completed_for_subject ?line_item)
        (supporting_doc_template_available ?supporting_doc_template)
        (not
          (line_item_linked_doc_template ?line_item ?supporting_doc_template)
        )
      )
  )
  (:action flag_regulatory_rule_for_package
    :parameters (?goods_package - goods_package ?regulatory_rule - regulatory_rule ?classification_tool - classification_tool)
    :precondition
      (and
        (classification_confirmed_for_subject ?goods_package)
        (subject_classification_binding ?goods_package ?classification_tool)
        (package_regulatory_rule_match ?goods_package ?regulatory_rule)
        (not
          (regulatory_rule_flagged ?regulatory_rule)
        )
        (not
          (regulatory_rule_document_required ?regulatory_rule)
        )
      )
    :effect (regulatory_rule_flagged ?regulatory_rule)
  )
  (:action assign_reviewer_for_package_regulatory_match
    :parameters (?goods_package - goods_package ?regulatory_rule - regulatory_rule ?reviewer - reviewer)
    :precondition
      (and
        (classification_confirmed_for_subject ?goods_package)
        (subject_assigned_reviewer ?goods_package ?reviewer)
        (package_regulatory_rule_match ?goods_package ?regulatory_rule)
        (regulatory_rule_flagged ?regulatory_rule)
        (not
          (goods_package_ready_for_submission_for_subject ?goods_package)
        )
      )
    :effect
      (and
        (goods_package_ready_for_submission_for_subject ?goods_package)
        (package_screening_completed_for_subject ?goods_package)
      )
  )
  (:action apply_doc_template_to_package_for_regulatory_match
    :parameters (?goods_package - goods_package ?regulatory_rule - regulatory_rule ?supporting_doc_template - supporting_doc_template)
    :precondition
      (and
        (classification_confirmed_for_subject ?goods_package)
        (package_regulatory_rule_match ?goods_package ?regulatory_rule)
        (supporting_doc_template_available ?supporting_doc_template)
        (not
          (goods_package_ready_for_submission_for_subject ?goods_package)
        )
      )
    :effect
      (and
        (regulatory_rule_document_required ?regulatory_rule)
        (goods_package_ready_for_submission_for_subject ?goods_package)
        (package_linked_doc_template ?goods_package ?supporting_doc_template)
        (not
          (supporting_doc_template_available ?supporting_doc_template)
        )
      )
  )
  (:action process_package_documentation_for_regulatory_match
    :parameters (?goods_package - goods_package ?regulatory_rule - regulatory_rule ?classification_tool - classification_tool ?supporting_doc_template - supporting_doc_template)
    :precondition
      (and
        (classification_confirmed_for_subject ?goods_package)
        (subject_classification_binding ?goods_package ?classification_tool)
        (package_regulatory_rule_match ?goods_package ?regulatory_rule)
        (regulatory_rule_document_required ?regulatory_rule)
        (package_linked_doc_template ?goods_package ?supporting_doc_template)
        (not
          (package_screening_completed_for_subject ?goods_package)
        )
      )
    :effect
      (and
        (regulatory_rule_flagged ?regulatory_rule)
        (package_screening_completed_for_subject ?goods_package)
        (supporting_doc_template_available ?supporting_doc_template)
        (not
          (package_linked_doc_template ?goods_package ?supporting_doc_template)
        )
      )
  )
  (:action assemble_submission_package_from_findings
    :parameters (?line_item - line_item ?goods_package - goods_package ?control_list_entry - control_list_entry ?regulatory_rule - regulatory_rule ?submission_package - submission_package)
    :precondition
      (and
        (line_item_ready_for_submission_for_subject ?line_item)
        (goods_package_ready_for_submission_for_subject ?goods_package)
        (line_item_control_list_match ?line_item ?control_list_entry)
        (package_regulatory_rule_match ?goods_package ?regulatory_rule)
        (control_list_entry_flagged ?control_list_entry)
        (regulatory_rule_flagged ?regulatory_rule)
        (line_item_screening_completed_for_subject ?line_item)
        (package_screening_completed_for_subject ?goods_package)
        (submission_package_pending_for_subject ?submission_package)
      )
    :effect
      (and
        (submission_package_prepared_for_subject ?submission_package)
        (submission_package_linked_control_list_entry ?submission_package ?control_list_entry)
        (submission_package_linked_regulatory_rule ?submission_package ?regulatory_rule)
        (not
          (submission_package_pending_for_subject ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_with_document_requirements
    :parameters (?line_item - line_item ?goods_package - goods_package ?control_list_entry - control_list_entry ?regulatory_rule - regulatory_rule ?submission_package - submission_package)
    :precondition
      (and
        (line_item_ready_for_submission_for_subject ?line_item)
        (goods_package_ready_for_submission_for_subject ?goods_package)
        (line_item_control_list_match ?line_item ?control_list_entry)
        (package_regulatory_rule_match ?goods_package ?regulatory_rule)
        (control_list_entry_document_required ?control_list_entry)
        (regulatory_rule_flagged ?regulatory_rule)
        (not
          (line_item_screening_completed_for_subject ?line_item)
        )
        (package_screening_completed_for_subject ?goods_package)
        (submission_package_pending_for_subject ?submission_package)
      )
    :effect
      (and
        (submission_package_prepared_for_subject ?submission_package)
        (submission_package_linked_control_list_entry ?submission_package ?control_list_entry)
        (submission_package_linked_regulatory_rule ?submission_package ?regulatory_rule)
        (submission_package_requires_checklist_for_subject ?submission_package)
        (not
          (submission_package_pending_for_subject ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_with_endorsement_requirements
    :parameters (?line_item - line_item ?goods_package - goods_package ?control_list_entry - control_list_entry ?regulatory_rule - regulatory_rule ?submission_package - submission_package)
    :precondition
      (and
        (line_item_ready_for_submission_for_subject ?line_item)
        (goods_package_ready_for_submission_for_subject ?goods_package)
        (line_item_control_list_match ?line_item ?control_list_entry)
        (package_regulatory_rule_match ?goods_package ?regulatory_rule)
        (control_list_entry_flagged ?control_list_entry)
        (regulatory_rule_document_required ?regulatory_rule)
        (line_item_screening_completed_for_subject ?line_item)
        (not
          (package_screening_completed_for_subject ?goods_package)
        )
        (submission_package_pending_for_subject ?submission_package)
      )
    :effect
      (and
        (submission_package_prepared_for_subject ?submission_package)
        (submission_package_linked_control_list_entry ?submission_package ?control_list_entry)
        (submission_package_linked_regulatory_rule ?submission_package ?regulatory_rule)
        (submission_package_requires_endorsement_for_subject ?submission_package)
        (not
          (submission_package_pending_for_subject ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_full_requirements
    :parameters (?line_item - line_item ?goods_package - goods_package ?control_list_entry - control_list_entry ?regulatory_rule - regulatory_rule ?submission_package - submission_package)
    :precondition
      (and
        (line_item_ready_for_submission_for_subject ?line_item)
        (goods_package_ready_for_submission_for_subject ?goods_package)
        (line_item_control_list_match ?line_item ?control_list_entry)
        (package_regulatory_rule_match ?goods_package ?regulatory_rule)
        (control_list_entry_document_required ?control_list_entry)
        (regulatory_rule_document_required ?regulatory_rule)
        (not
          (line_item_screening_completed_for_subject ?line_item)
        )
        (not
          (package_screening_completed_for_subject ?goods_package)
        )
        (submission_package_pending_for_subject ?submission_package)
      )
    :effect
      (and
        (submission_package_prepared_for_subject ?submission_package)
        (submission_package_linked_control_list_entry ?submission_package ?control_list_entry)
        (submission_package_linked_regulatory_rule ?submission_package ?regulatory_rule)
        (submission_package_requires_checklist_for_subject ?submission_package)
        (submission_package_requires_endorsement_for_subject ?submission_package)
        (not
          (submission_package_pending_for_subject ?submission_package)
        )
      )
  )
  (:action validate_submission_package
    :parameters (?submission_package - submission_package ?line_item - line_item ?classification_tool - classification_tool)
    :precondition
      (and
        (submission_package_prepared_for_subject ?submission_package)
        (line_item_ready_for_submission_for_subject ?line_item)
        (subject_classification_binding ?line_item ?classification_tool)
        (not
          (submission_package_validated_for_subject ?submission_package)
        )
      )
    :effect (submission_package_validated_for_subject ?submission_package)
  )
  (:action verify_and_link_verification_document_to_submission
    :parameters (?compliance_case - compliance_case ?verification_document - verification_document ?submission_package - submission_package)
    :precondition
      (and
        (classification_confirmed_for_subject ?compliance_case)
        (case_contains_submission_package ?compliance_case ?submission_package)
        (case_linked_verification_document ?compliance_case ?verification_document)
        (verification_document_available ?verification_document)
        (submission_package_prepared_for_subject ?submission_package)
        (submission_package_validated_for_subject ?submission_package)
        (not
          (verification_document_verified ?verification_document)
        )
      )
    :effect
      (and
        (verification_document_verified ?verification_document)
        (verification_document_linked_submission_package ?verification_document ?submission_package)
        (not
          (verification_document_available ?verification_document)
        )
      )
  )
  (:action verify_compliance_case_documents
    :parameters (?compliance_case - compliance_case ?verification_document - verification_document ?submission_package - submission_package ?classification_tool - classification_tool)
    :precondition
      (and
        (classification_confirmed_for_subject ?compliance_case)
        (case_linked_verification_document ?compliance_case ?verification_document)
        (verification_document_verified ?verification_document)
        (verification_document_linked_submission_package ?verification_document ?submission_package)
        (subject_classification_binding ?compliance_case ?classification_tool)
        (not
          (submission_package_requires_checklist_for_subject ?submission_package)
        )
        (not
          (case_documents_verified_for_subject ?compliance_case)
        )
      )
    :effect (case_documents_verified_for_subject ?compliance_case)
  )
  (:action attach_regulatory_reference_to_case
    :parameters (?compliance_case - compliance_case ?regulatory_reference - regulatory_reference)
    :precondition
      (and
        (classification_confirmed_for_subject ?compliance_case)
        (regulatory_reference_available ?regulatory_reference)
        (not
          (case_regulatory_reference_attached_for_subject ?compliance_case)
        )
      )
    :effect
      (and
        (case_regulatory_reference_attached_for_subject ?compliance_case)
        (case_linked_regulatory_reference ?compliance_case ?regulatory_reference)
        (not
          (regulatory_reference_available ?regulatory_reference)
        )
      )
  )
  (:action enrich_case_with_reference_and_verification
    :parameters (?compliance_case - compliance_case ?verification_document - verification_document ?submission_package - submission_package ?classification_tool - classification_tool ?regulatory_reference - regulatory_reference)
    :precondition
      (and
        (classification_confirmed_for_subject ?compliance_case)
        (case_linked_verification_document ?compliance_case ?verification_document)
        (verification_document_verified ?verification_document)
        (verification_document_linked_submission_package ?verification_document ?submission_package)
        (subject_classification_binding ?compliance_case ?classification_tool)
        (submission_package_requires_checklist_for_subject ?submission_package)
        (case_regulatory_reference_attached_for_subject ?compliance_case)
        (case_linked_regulatory_reference ?compliance_case ?regulatory_reference)
        (not
          (case_documents_verified_for_subject ?compliance_case)
        )
      )
    :effect
      (and
        (case_documents_verified_for_subject ?compliance_case)
        (case_regulatory_reference_verified_for_subject ?compliance_case)
      )
  )
  (:action queue_case_for_authority_endorsement
    :parameters (?compliance_case - compliance_case ?authority_checklist - authority_checklist ?reviewer - reviewer ?verification_document - verification_document ?submission_package - submission_package)
    :precondition
      (and
        (case_documents_verified_for_subject ?compliance_case)
        (case_linked_authority_checklist ?compliance_case ?authority_checklist)
        (subject_assigned_reviewer ?compliance_case ?reviewer)
        (case_linked_verification_document ?compliance_case ?verification_document)
        (verification_document_linked_submission_package ?verification_document ?submission_package)
        (not
          (submission_package_requires_endorsement_for_subject ?submission_package)
        )
        (not
          (case_endorsement_prepared_for_subject ?compliance_case)
        )
      )
    :effect (case_endorsement_prepared_for_subject ?compliance_case)
  )
  (:action queue_case_for_authority_endorsement_alternate
    :parameters (?compliance_case - compliance_case ?authority_checklist - authority_checklist ?reviewer - reviewer ?verification_document - verification_document ?submission_package - submission_package)
    :precondition
      (and
        (case_documents_verified_for_subject ?compliance_case)
        (case_linked_authority_checklist ?compliance_case ?authority_checklist)
        (subject_assigned_reviewer ?compliance_case ?reviewer)
        (case_linked_verification_document ?compliance_case ?verification_document)
        (verification_document_linked_submission_package ?verification_document ?submission_package)
        (submission_package_requires_endorsement_for_subject ?submission_package)
        (not
          (case_endorsement_prepared_for_subject ?compliance_case)
        )
      )
    :effect (case_endorsement_prepared_for_subject ?compliance_case)
  )
  (:action submit_case_to_authority_for_response
    :parameters (?compliance_case - compliance_case ?authority_response - authority_response ?verification_document - verification_document ?submission_package - submission_package)
    :precondition
      (and
        (case_endorsement_prepared_for_subject ?compliance_case)
        (case_linked_authority_response ?compliance_case ?authority_response)
        (case_linked_verification_document ?compliance_case ?verification_document)
        (verification_document_linked_submission_package ?verification_document ?submission_package)
        (not
          (submission_package_requires_checklist_for_subject ?submission_package)
        )
        (not
          (submission_package_requires_endorsement_for_subject ?submission_package)
        )
        (not
          (case_endorsement_submitted_for_subject ?compliance_case)
        )
      )
    :effect (case_endorsement_submitted_for_subject ?compliance_case)
  )
  (:action submit_case_to_authority_with_approver_trigger
    :parameters (?compliance_case - compliance_case ?authority_response - authority_response ?verification_document - verification_document ?submission_package - submission_package)
    :precondition
      (and
        (case_endorsement_prepared_for_subject ?compliance_case)
        (case_linked_authority_response ?compliance_case ?authority_response)
        (case_linked_verification_document ?compliance_case ?verification_document)
        (verification_document_linked_submission_package ?verification_document ?submission_package)
        (submission_package_requires_checklist_for_subject ?submission_package)
        (not
          (submission_package_requires_endorsement_for_subject ?submission_package)
        )
        (not
          (case_endorsement_submitted_for_subject ?compliance_case)
        )
      )
    :effect
      (and
        (case_endorsement_submitted_for_subject ?compliance_case)
        (case_ready_for_approver_assignment_for_subject ?compliance_case)
      )
  )
  (:action submit_case_to_authority_with_approver_trigger_alternate
    :parameters (?compliance_case - compliance_case ?authority_response - authority_response ?verification_document - verification_document ?submission_package - submission_package)
    :precondition
      (and
        (case_endorsement_prepared_for_subject ?compliance_case)
        (case_linked_authority_response ?compliance_case ?authority_response)
        (case_linked_verification_document ?compliance_case ?verification_document)
        (verification_document_linked_submission_package ?verification_document ?submission_package)
        (not
          (submission_package_requires_checklist_for_subject ?submission_package)
        )
        (submission_package_requires_endorsement_for_subject ?submission_package)
        (not
          (case_endorsement_submitted_for_subject ?compliance_case)
        )
      )
    :effect
      (and
        (case_endorsement_submitted_for_subject ?compliance_case)
        (case_ready_for_approver_assignment_for_subject ?compliance_case)
      )
  )
  (:action submit_case_to_authority_with_full_preconditions
    :parameters (?compliance_case - compliance_case ?authority_response - authority_response ?verification_document - verification_document ?submission_package - submission_package)
    :precondition
      (and
        (case_endorsement_prepared_for_subject ?compliance_case)
        (case_linked_authority_response ?compliance_case ?authority_response)
        (case_linked_verification_document ?compliance_case ?verification_document)
        (verification_document_linked_submission_package ?verification_document ?submission_package)
        (submission_package_requires_checklist_for_subject ?submission_package)
        (submission_package_requires_endorsement_for_subject ?submission_package)
        (not
          (case_endorsement_submitted_for_subject ?compliance_case)
        )
      )
    :effect
      (and
        (case_endorsement_submitted_for_subject ?compliance_case)
        (case_ready_for_approver_assignment_for_subject ?compliance_case)
      )
  )
  (:action finalize_case_for_adjudication
    :parameters (?compliance_case - compliance_case)
    :precondition
      (and
        (case_endorsement_submitted_for_subject ?compliance_case)
        (not
          (case_ready_for_approver_assignment_for_subject ?compliance_case)
        )
        (not
          (case_finalized_for_adjudication ?compliance_case)
        )
      )
    :effect
      (and
        (case_finalized_for_adjudication ?compliance_case)
        (ready_for_adjudication_for_subject ?compliance_case)
      )
  )
  (:action attach_approver_profile_to_case
    :parameters (?compliance_case - compliance_case ?approver_profile - approver_profile)
    :precondition
      (and
        (case_endorsement_submitted_for_subject ?compliance_case)
        (case_ready_for_approver_assignment_for_subject ?compliance_case)
        (approver_profile_available ?approver_profile)
      )
    :effect
      (and
        (case_assigned_approver ?compliance_case ?approver_profile)
        (not
          (approver_profile_available ?approver_profile)
        )
      )
  )
  (:action authorize_case_for_finalization
    :parameters (?compliance_case - compliance_case ?line_item - line_item ?goods_package - goods_package ?classification_tool - classification_tool ?approver_profile - approver_profile)
    :precondition
      (and
        (case_endorsement_submitted_for_subject ?compliance_case)
        (case_ready_for_approver_assignment_for_subject ?compliance_case)
        (case_assigned_approver ?compliance_case ?approver_profile)
        (case_contains_line_item ?compliance_case ?line_item)
        (case_contains_goods_package ?compliance_case ?goods_package)
        (line_item_screening_completed_for_subject ?line_item)
        (package_screening_completed_for_subject ?goods_package)
        (subject_classification_binding ?compliance_case ?classification_tool)
        (not
          (case_ready_for_finalization_for_subject ?compliance_case)
        )
      )
    :effect (case_ready_for_finalization_for_subject ?compliance_case)
  )
  (:action complete_case_finalization
    :parameters (?compliance_case - compliance_case)
    :precondition
      (and
        (case_endorsement_submitted_for_subject ?compliance_case)
        (case_ready_for_finalization_for_subject ?compliance_case)
        (not
          (case_finalized_for_adjudication ?compliance_case)
        )
      )
    :effect
      (and
        (case_finalized_for_adjudication ?compliance_case)
        (ready_for_adjudication_for_subject ?compliance_case)
      )
  )
  (:action attach_endorsement_token_to_case
    :parameters (?compliance_case - compliance_case ?endorsement_token - endorsement_token ?classification_tool - classification_tool)
    :precondition
      (and
        (classification_confirmed_for_subject ?compliance_case)
        (subject_classification_binding ?compliance_case ?classification_tool)
        (endorsement_token_available ?endorsement_token)
        (case_linked_endorsement_token ?compliance_case ?endorsement_token)
        (not
          (case_endorsement_attached_for_subject ?compliance_case)
        )
      )
    :effect
      (and
        (case_endorsement_attached_for_subject ?compliance_case)
        (not
          (endorsement_token_available ?endorsement_token)
        )
      )
  )
  (:action verify_endorsement_with_reviewer
    :parameters (?compliance_case - compliance_case ?reviewer - reviewer)
    :precondition
      (and
        (case_endorsement_attached_for_subject ?compliance_case)
        (subject_assigned_reviewer ?compliance_case ?reviewer)
        (not
          (case_endorsement_verified_for_subject ?compliance_case)
        )
      )
    :effect (case_endorsement_verified_for_subject ?compliance_case)
  )
  (:action record_endorsement_and_request_authority_response
    :parameters (?compliance_case - compliance_case ?authority_response - authority_response)
    :precondition
      (and
        (case_endorsement_verified_for_subject ?compliance_case)
        (case_linked_authority_response ?compliance_case ?authority_response)
        (not
          (case_endorsement_finalized_for_subject ?compliance_case)
        )
      )
    :effect (case_endorsement_finalized_for_subject ?compliance_case)
  )
  (:action finalize_endorsement_and_mark_case_ready
    :parameters (?compliance_case - compliance_case)
    :precondition
      (and
        (case_endorsement_finalized_for_subject ?compliance_case)
        (not
          (case_finalized_for_adjudication ?compliance_case)
        )
      )
    :effect
      (and
        (case_finalized_for_adjudication ?compliance_case)
        (ready_for_adjudication_for_subject ?compliance_case)
      )
  )
  (:action mark_line_item_ready_for_adjudication
    :parameters (?line_item - line_item ?submission_package - submission_package)
    :precondition
      (and
        (line_item_ready_for_submission_for_subject ?line_item)
        (line_item_screening_completed_for_subject ?line_item)
        (submission_package_prepared_for_subject ?submission_package)
        (submission_package_validated_for_subject ?submission_package)
        (not
          (ready_for_adjudication_for_subject ?line_item)
        )
      )
    :effect (ready_for_adjudication_for_subject ?line_item)
  )
  (:action mark_package_ready_for_adjudication
    :parameters (?goods_package - goods_package ?submission_package - submission_package)
    :precondition
      (and
        (goods_package_ready_for_submission_for_subject ?goods_package)
        (package_screening_completed_for_subject ?goods_package)
        (submission_package_prepared_for_subject ?submission_package)
        (submission_package_validated_for_subject ?submission_package)
        (not
          (ready_for_adjudication_for_subject ?goods_package)
        )
      )
    :effect (ready_for_adjudication_for_subject ?goods_package)
  )
  (:action determine_license_requirement_for_shipment
    :parameters (?shipment - export_shipment ?license_type - license_type ?classification_tool - classification_tool)
    :precondition
      (and
        (ready_for_adjudication_for_subject ?shipment)
        (subject_classification_binding ?shipment ?classification_tool)
        (license_type_available ?license_type)
        (not
          (license_requirement_determined_for_subject ?shipment)
        )
      )
    :effect
      (and
        (license_requirement_determined_for_subject ?shipment)
        (subject_linked_license_type ?shipment ?license_type)
        (not
          (license_type_available ?license_type)
        )
      )
  )
  (:action propagate_license_decision_to_line_item
    :parameters (?line_item - line_item ?assessor_slot - assessor_slot ?license_type - license_type)
    :precondition
      (and
        (license_requirement_determined_for_subject ?line_item)
        (subject_assigned_assessor ?line_item ?assessor_slot)
        (subject_linked_license_type ?line_item ?license_type)
        (not
          (license_requirement_recorded_for_subject ?line_item)
        )
      )
    :effect
      (and
        (license_requirement_recorded_for_subject ?line_item)
        (assessor_slot_available ?assessor_slot)
        (license_type_available ?license_type)
      )
  )
  (:action propagate_license_decision_to_package
    :parameters (?goods_package - goods_package ?assessor_slot - assessor_slot ?license_type - license_type)
    :precondition
      (and
        (license_requirement_determined_for_subject ?goods_package)
        (subject_assigned_assessor ?goods_package ?assessor_slot)
        (subject_linked_license_type ?goods_package ?license_type)
        (not
          (license_requirement_recorded_for_subject ?goods_package)
        )
      )
    :effect
      (and
        (license_requirement_recorded_for_subject ?goods_package)
        (assessor_slot_available ?assessor_slot)
        (license_type_available ?license_type)
      )
  )
  (:action propagate_license_decision_to_case
    :parameters (?compliance_case - compliance_case ?assessor_slot - assessor_slot ?license_type - license_type)
    :precondition
      (and
        (license_requirement_determined_for_subject ?compliance_case)
        (subject_assigned_assessor ?compliance_case ?assessor_slot)
        (subject_linked_license_type ?compliance_case ?license_type)
        (not
          (license_requirement_recorded_for_subject ?compliance_case)
        )
      )
    :effect
      (and
        (license_requirement_recorded_for_subject ?compliance_case)
        (assessor_slot_available ?assessor_slot)
        (license_type_available ?license_type)
      )
  )
)

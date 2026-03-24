(define (domain pharmaceutics_regulatory_commitment_tracking)
  (:requirements :strips :typing :negative-preconditions)
  (:types case_resource - object supporting_entity - object context_entity - object commitment_base - object regulatory_commitment - commitment_base personnel_resource - case_resource evidence_item - case_resource functional_approver - case_resource attachment_category - case_resource approval_template - case_resource regulatory_reference - case_resource risk_assessment_document - case_resource validation_protocol - case_resource supporting_document - supporting_entity quality_document - supporting_entity external_stakeholder - supporting_entity impact_area - context_entity regulatory_region - context_entity submission_record - context_entity scoped_commitment - regulatory_commitment commitment_container - regulatory_commitment site_level_commitment - scoped_commitment product_level_commitment - scoped_commitment commitment_package - commitment_container)
  (:predicates
    (entity_created ?regulatory_commitment - regulatory_commitment)
    (entity_ready_for_approval ?regulatory_commitment - regulatory_commitment)
    (entity_assigned ?regulatory_commitment - regulatory_commitment)
    (entity_registered ?regulatory_commitment - regulatory_commitment)
    (entity_submission_prepared ?regulatory_commitment - regulatory_commitment)
    (entity_finalized ?regulatory_commitment - regulatory_commitment)
    (personnel_available ?personnel_resource - personnel_resource)
    (entity_assigned_to ?regulatory_commitment - regulatory_commitment ?personnel_resource - personnel_resource)
    (evidence_available ?evidence_item - evidence_item)
    (evidence_attached ?regulatory_commitment - regulatory_commitment ?evidence_item - evidence_item)
    (approver_available ?functional_approver - functional_approver)
    (entity_approver_assigned ?regulatory_commitment - regulatory_commitment ?functional_approver - functional_approver)
    (supporting_document_available ?supporting_document - supporting_document)
    (site_level_commitment_document_linked ?site_level_commitment - site_level_commitment ?supporting_document - supporting_document)
    (product_level_commitment_document_linked ?product_level_commitment - product_level_commitment ?supporting_document - supporting_document)
    (site_level_commitment_impacts ?site_level_commitment - site_level_commitment ?impact_area - impact_area)
    (impact_area_assessed ?impact_area - impact_area)
    (impact_area_documented ?impact_area - impact_area)
    (site_level_investigation_completed ?site_level_commitment - site_level_commitment)
    (product_level_commitment_in_region ?product_level_commitment - product_level_commitment ?regulatory_region - regulatory_region)
    (regulatory_region_assessed ?regulatory_region - regulatory_region)
    (regulatory_region_documented ?regulatory_region - regulatory_region)
    (product_level_investigation_completed ?product_level_commitment - product_level_commitment)
    (submission_draft ?submission_record - submission_record)
    (submission_package_created ?submission_record - submission_record)
    (submission_impacts ?submission_record - submission_record ?impact_area - impact_area)
    (submission_for_region ?submission_record - submission_record ?regulatory_region - regulatory_region)
    (submission_includes_validation_protocol ?submission_record - submission_record)
    (submission_includes_risk_assessment ?submission_record - submission_record)
    (submission_quality_checked ?submission_record - submission_record)
    (package_includes_site_level_commitment ?commitment_package - commitment_package ?site_level_commitment - site_level_commitment)
    (package_includes_product_level_commitment ?commitment_package - commitment_package ?product_level_commitment - product_level_commitment)
    (package_associated_with_submission ?commitment_package - commitment_package ?submission_record - submission_record)
    (quality_document_available ?quality_document - quality_document)
    (package_includes_quality_document ?commitment_package - commitment_package ?quality_document - quality_document)
    (quality_document_consumed ?quality_document - quality_document)
    (quality_document_linked_to_submission ?quality_document - quality_document ?submission_record - submission_record)
    (package_attachment_reviewed ?commitment_package - commitment_package)
    (package_has_quality_and_risk_documents ?commitment_package - commitment_package)
    (package_ready_for_final_review ?commitment_package - commitment_package)
    (package_attachment_assigned ?commitment_package - commitment_package)
    (package_attachment_validated ?commitment_package - commitment_package)
    (package_requires_sequenced_approvals ?commitment_package - commitment_package)
    (package_approvals_completed ?commitment_package - commitment_package)
    (external_stakeholder_available ?external_stakeholder - external_stakeholder)
    (package_external_stakeholder_associated ?commitment_package - commitment_package ?external_stakeholder - external_stakeholder)
    (package_stakeholder_consulted ?commitment_package - commitment_package)
    (package_approver_sequence_started ?commitment_package - commitment_package)
    (package_approver_sequence_completed ?commitment_package - commitment_package)
    (attachment_category_available ?attachment_category - attachment_category)
    (package_attachment_category_assigned ?commitment_package - commitment_package ?attachment_category - attachment_category)
    (approval_template_available ?approval_template - approval_template)
    (approval_template_instantiated ?commitment_package - commitment_package ?approval_template - approval_template)
    (risk_assessment_document_available ?risk_assessment_document - risk_assessment_document)
    (package_risk_assessment_assigned ?commitment_package - commitment_package ?risk_assessment_document - risk_assessment_document)
    (validation_protocol_available ?validation_protocol - validation_protocol)
    (package_validation_protocol_assigned ?commitment_package - commitment_package ?validation_protocol - validation_protocol)
    (regulatory_reference_available ?regulatory_reference - regulatory_reference)
    (entity_linked_to_regulatory_reference ?regulatory_commitment - regulatory_commitment ?regulatory_reference - regulatory_reference)
    (site_level_commitment_ready ?site_level_commitment - site_level_commitment)
    (product_level_commitment_ready ?product_level_commitment - product_level_commitment)
    (package_signoff_recorded ?commitment_package - commitment_package)
  )
  (:action create_regulatory_commitment
    :parameters (?regulatory_commitment - regulatory_commitment)
    :precondition
      (and
        (not
          (entity_created ?regulatory_commitment)
        )
        (not
          (entity_registered ?regulatory_commitment)
        )
      )
    :effect (entity_created ?regulatory_commitment)
  )
  (:action assign_personnel_to_commitment
    :parameters (?regulatory_commitment - regulatory_commitment ?personnel_resource - personnel_resource)
    :precondition
      (and
        (entity_created ?regulatory_commitment)
        (not
          (entity_assigned ?regulatory_commitment)
        )
        (personnel_available ?personnel_resource)
      )
    :effect
      (and
        (entity_assigned ?regulatory_commitment)
        (entity_assigned_to ?regulatory_commitment ?personnel_resource)
        (not
          (personnel_available ?personnel_resource)
        )
      )
  )
  (:action attach_evidence_to_commitment
    :parameters (?regulatory_commitment - regulatory_commitment ?evidence_item - evidence_item)
    :precondition
      (and
        (entity_created ?regulatory_commitment)
        (entity_assigned ?regulatory_commitment)
        (evidence_available ?evidence_item)
      )
    :effect
      (and
        (evidence_attached ?regulatory_commitment ?evidence_item)
        (not
          (evidence_available ?evidence_item)
        )
      )
  )
  (:action submit_commitment_for_approval
    :parameters (?regulatory_commitment - regulatory_commitment ?evidence_item - evidence_item)
    :precondition
      (and
        (entity_created ?regulatory_commitment)
        (entity_assigned ?regulatory_commitment)
        (evidence_attached ?regulatory_commitment ?evidence_item)
        (not
          (entity_ready_for_approval ?regulatory_commitment)
        )
      )
    :effect (entity_ready_for_approval ?regulatory_commitment)
  )
  (:action detach_evidence_from_commitment
    :parameters (?regulatory_commitment - regulatory_commitment ?evidence_item - evidence_item)
    :precondition
      (and
        (evidence_attached ?regulatory_commitment ?evidence_item)
      )
    :effect
      (and
        (evidence_available ?evidence_item)
        (not
          (evidence_attached ?regulatory_commitment ?evidence_item)
        )
      )
  )
  (:action assign_approver_to_commitment
    :parameters (?regulatory_commitment - regulatory_commitment ?functional_approver - functional_approver)
    :precondition
      (and
        (entity_ready_for_approval ?regulatory_commitment)
        (approver_available ?functional_approver)
      )
    :effect
      (and
        (entity_approver_assigned ?regulatory_commitment ?functional_approver)
        (not
          (approver_available ?functional_approver)
        )
      )
  )
  (:action unassign_approver_from_commitment
    :parameters (?regulatory_commitment - regulatory_commitment ?functional_approver - functional_approver)
    :precondition
      (and
        (entity_approver_assigned ?regulatory_commitment ?functional_approver)
      )
    :effect
      (and
        (approver_available ?functional_approver)
        (not
          (entity_approver_assigned ?regulatory_commitment ?functional_approver)
        )
      )
  )
  (:action assign_risk_assessment_to_package
    :parameters (?commitment_package - commitment_package ?risk_assessment_document - risk_assessment_document)
    :precondition
      (and
        (entity_ready_for_approval ?commitment_package)
        (risk_assessment_document_available ?risk_assessment_document)
      )
    :effect
      (and
        (package_risk_assessment_assigned ?commitment_package ?risk_assessment_document)
        (not
          (risk_assessment_document_available ?risk_assessment_document)
        )
      )
  )
  (:action unassign_risk_assessment_from_package
    :parameters (?commitment_package - commitment_package ?risk_assessment_document - risk_assessment_document)
    :precondition
      (and
        (package_risk_assessment_assigned ?commitment_package ?risk_assessment_document)
      )
    :effect
      (and
        (risk_assessment_document_available ?risk_assessment_document)
        (not
          (package_risk_assessment_assigned ?commitment_package ?risk_assessment_document)
        )
      )
  )
  (:action assign_validation_protocol_to_package
    :parameters (?commitment_package - commitment_package ?validation_protocol - validation_protocol)
    :precondition
      (and
        (entity_ready_for_approval ?commitment_package)
        (validation_protocol_available ?validation_protocol)
      )
    :effect
      (and
        (package_validation_protocol_assigned ?commitment_package ?validation_protocol)
        (not
          (validation_protocol_available ?validation_protocol)
        )
      )
  )
  (:action unassign_validation_protocol_from_package
    :parameters (?commitment_package - commitment_package ?validation_protocol - validation_protocol)
    :precondition
      (and
        (package_validation_protocol_assigned ?commitment_package ?validation_protocol)
      )
    :effect
      (and
        (validation_protocol_available ?validation_protocol)
        (not
          (package_validation_protocol_assigned ?commitment_package ?validation_protocol)
        )
      )
  )
  (:action initiate_site_impact_assessment
    :parameters (?site_level_commitment - site_level_commitment ?impact_area - impact_area ?evidence_item - evidence_item)
    :precondition
      (and
        (entity_ready_for_approval ?site_level_commitment)
        (evidence_attached ?site_level_commitment ?evidence_item)
        (site_level_commitment_impacts ?site_level_commitment ?impact_area)
        (not
          (impact_area_assessed ?impact_area)
        )
        (not
          (impact_area_documented ?impact_area)
        )
      )
    :effect (impact_area_assessed ?impact_area)
  )
  (:action complete_site_investigation_with_approver
    :parameters (?site_level_commitment - site_level_commitment ?impact_area - impact_area ?functional_approver - functional_approver)
    :precondition
      (and
        (entity_ready_for_approval ?site_level_commitment)
        (entity_approver_assigned ?site_level_commitment ?functional_approver)
        (site_level_commitment_impacts ?site_level_commitment ?impact_area)
        (impact_area_assessed ?impact_area)
        (not
          (site_level_commitment_ready ?site_level_commitment)
        )
      )
    :effect
      (and
        (site_level_commitment_ready ?site_level_commitment)
        (site_level_investigation_completed ?site_level_commitment)
      )
  )
  (:action attach_supporting_document_to_site_level_commitment
    :parameters (?site_level_commitment - site_level_commitment ?impact_area - impact_area ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_ready_for_approval ?site_level_commitment)
        (site_level_commitment_impacts ?site_level_commitment ?impact_area)
        (supporting_document_available ?supporting_document)
        (not
          (site_level_commitment_ready ?site_level_commitment)
        )
      )
    :effect
      (and
        (impact_area_documented ?impact_area)
        (site_level_commitment_ready ?site_level_commitment)
        (site_level_commitment_document_linked ?site_level_commitment ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_site_impact_assessment
    :parameters (?site_level_commitment - site_level_commitment ?impact_area - impact_area ?evidence_item - evidence_item ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_ready_for_approval ?site_level_commitment)
        (evidence_attached ?site_level_commitment ?evidence_item)
        (site_level_commitment_impacts ?site_level_commitment ?impact_area)
        (impact_area_documented ?impact_area)
        (site_level_commitment_document_linked ?site_level_commitment ?supporting_document)
        (not
          (site_level_investigation_completed ?site_level_commitment)
        )
      )
    :effect
      (and
        (impact_area_assessed ?impact_area)
        (site_level_investigation_completed ?site_level_commitment)
        (supporting_document_available ?supporting_document)
        (not
          (site_level_commitment_document_linked ?site_level_commitment ?supporting_document)
        )
      )
  )
  (:action initiate_product_impact_assessment
    :parameters (?product_level_commitment - product_level_commitment ?regulatory_region - regulatory_region ?evidence_item - evidence_item)
    :precondition
      (and
        (entity_ready_for_approval ?product_level_commitment)
        (evidence_attached ?product_level_commitment ?evidence_item)
        (product_level_commitment_in_region ?product_level_commitment ?regulatory_region)
        (not
          (regulatory_region_assessed ?regulatory_region)
        )
        (not
          (regulatory_region_documented ?regulatory_region)
        )
      )
    :effect (regulatory_region_assessed ?regulatory_region)
  )
  (:action complete_product_investigation_with_approver
    :parameters (?product_level_commitment - product_level_commitment ?regulatory_region - regulatory_region ?functional_approver - functional_approver)
    :precondition
      (and
        (entity_ready_for_approval ?product_level_commitment)
        (entity_approver_assigned ?product_level_commitment ?functional_approver)
        (product_level_commitment_in_region ?product_level_commitment ?regulatory_region)
        (regulatory_region_assessed ?regulatory_region)
        (not
          (product_level_commitment_ready ?product_level_commitment)
        )
      )
    :effect
      (and
        (product_level_commitment_ready ?product_level_commitment)
        (product_level_investigation_completed ?product_level_commitment)
      )
  )
  (:action attach_supporting_document_to_product_level_commitment
    :parameters (?product_level_commitment - product_level_commitment ?regulatory_region - regulatory_region ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_ready_for_approval ?product_level_commitment)
        (product_level_commitment_in_region ?product_level_commitment ?regulatory_region)
        (supporting_document_available ?supporting_document)
        (not
          (product_level_commitment_ready ?product_level_commitment)
        )
      )
    :effect
      (and
        (regulatory_region_documented ?regulatory_region)
        (product_level_commitment_ready ?product_level_commitment)
        (product_level_commitment_document_linked ?product_level_commitment ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_product_impact_assessment
    :parameters (?product_level_commitment - product_level_commitment ?regulatory_region - regulatory_region ?evidence_item - evidence_item ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_ready_for_approval ?product_level_commitment)
        (evidence_attached ?product_level_commitment ?evidence_item)
        (product_level_commitment_in_region ?product_level_commitment ?regulatory_region)
        (regulatory_region_documented ?regulatory_region)
        (product_level_commitment_document_linked ?product_level_commitment ?supporting_document)
        (not
          (product_level_investigation_completed ?product_level_commitment)
        )
      )
    :effect
      (and
        (regulatory_region_assessed ?regulatory_region)
        (product_level_investigation_completed ?product_level_commitment)
        (supporting_document_available ?supporting_document)
        (not
          (product_level_commitment_document_linked ?product_level_commitment ?supporting_document)
        )
      )
  )
  (:action assemble_submission_package
    :parameters (?site_level_commitment - site_level_commitment ?product_level_commitment - product_level_commitment ?impact_area - impact_area ?regulatory_region - regulatory_region ?submission_record - submission_record)
    :precondition
      (and
        (site_level_commitment_ready ?site_level_commitment)
        (product_level_commitment_ready ?product_level_commitment)
        (site_level_commitment_impacts ?site_level_commitment ?impact_area)
        (product_level_commitment_in_region ?product_level_commitment ?regulatory_region)
        (impact_area_assessed ?impact_area)
        (regulatory_region_assessed ?regulatory_region)
        (site_level_investigation_completed ?site_level_commitment)
        (product_level_investigation_completed ?product_level_commitment)
        (submission_draft ?submission_record)
      )
    :effect
      (and
        (submission_package_created ?submission_record)
        (submission_impacts ?submission_record ?impact_area)
        (submission_for_region ?submission_record ?regulatory_region)
        (not
          (submission_draft ?submission_record)
        )
      )
  )
  (:action assemble_submission_package_with_documented_impacts
    :parameters (?site_level_commitment - site_level_commitment ?product_level_commitment - product_level_commitment ?impact_area - impact_area ?regulatory_region - regulatory_region ?submission_record - submission_record)
    :precondition
      (and
        (site_level_commitment_ready ?site_level_commitment)
        (product_level_commitment_ready ?product_level_commitment)
        (site_level_commitment_impacts ?site_level_commitment ?impact_area)
        (product_level_commitment_in_region ?product_level_commitment ?regulatory_region)
        (impact_area_documented ?impact_area)
        (regulatory_region_assessed ?regulatory_region)
        (not
          (site_level_investigation_completed ?site_level_commitment)
        )
        (product_level_investigation_completed ?product_level_commitment)
        (submission_draft ?submission_record)
      )
    :effect
      (and
        (submission_package_created ?submission_record)
        (submission_impacts ?submission_record ?impact_area)
        (submission_for_region ?submission_record ?regulatory_region)
        (submission_includes_validation_protocol ?submission_record)
        (not
          (submission_draft ?submission_record)
        )
      )
  )
  (:action assemble_submission_package_with_region_documentation
    :parameters (?site_level_commitment - site_level_commitment ?product_level_commitment - product_level_commitment ?impact_area - impact_area ?regulatory_region - regulatory_region ?submission_record - submission_record)
    :precondition
      (and
        (site_level_commitment_ready ?site_level_commitment)
        (product_level_commitment_ready ?product_level_commitment)
        (site_level_commitment_impacts ?site_level_commitment ?impact_area)
        (product_level_commitment_in_region ?product_level_commitment ?regulatory_region)
        (impact_area_assessed ?impact_area)
        (regulatory_region_documented ?regulatory_region)
        (site_level_investigation_completed ?site_level_commitment)
        (not
          (product_level_investigation_completed ?product_level_commitment)
        )
        (submission_draft ?submission_record)
      )
    :effect
      (and
        (submission_package_created ?submission_record)
        (submission_impacts ?submission_record ?impact_area)
        (submission_for_region ?submission_record ?regulatory_region)
        (submission_includes_risk_assessment ?submission_record)
        (not
          (submission_draft ?submission_record)
        )
      )
  )
  (:action assemble_submission_package_with_full_checks
    :parameters (?site_level_commitment - site_level_commitment ?product_level_commitment - product_level_commitment ?impact_area - impact_area ?regulatory_region - regulatory_region ?submission_record - submission_record)
    :precondition
      (and
        (site_level_commitment_ready ?site_level_commitment)
        (product_level_commitment_ready ?product_level_commitment)
        (site_level_commitment_impacts ?site_level_commitment ?impact_area)
        (product_level_commitment_in_region ?product_level_commitment ?regulatory_region)
        (impact_area_documented ?impact_area)
        (regulatory_region_documented ?regulatory_region)
        (not
          (site_level_investigation_completed ?site_level_commitment)
        )
        (not
          (product_level_investigation_completed ?product_level_commitment)
        )
        (submission_draft ?submission_record)
      )
    :effect
      (and
        (submission_package_created ?submission_record)
        (submission_impacts ?submission_record ?impact_area)
        (submission_for_region ?submission_record ?regulatory_region)
        (submission_includes_validation_protocol ?submission_record)
        (submission_includes_risk_assessment ?submission_record)
        (not
          (submission_draft ?submission_record)
        )
      )
  )
  (:action perform_submission_quality_check
    :parameters (?submission_record - submission_record ?site_level_commitment - site_level_commitment ?evidence_item - evidence_item)
    :precondition
      (and
        (submission_package_created ?submission_record)
        (site_level_commitment_ready ?site_level_commitment)
        (evidence_attached ?site_level_commitment ?evidence_item)
        (not
          (submission_quality_checked ?submission_record)
        )
      )
    :effect (submission_quality_checked ?submission_record)
  )
  (:action assign_quality_document_to_submission
    :parameters (?commitment_package - commitment_package ?quality_document - quality_document ?submission_record - submission_record)
    :precondition
      (and
        (entity_ready_for_approval ?commitment_package)
        (package_associated_with_submission ?commitment_package ?submission_record)
        (package_includes_quality_document ?commitment_package ?quality_document)
        (quality_document_available ?quality_document)
        (submission_package_created ?submission_record)
        (submission_quality_checked ?submission_record)
        (not
          (quality_document_consumed ?quality_document)
        )
      )
    :effect
      (and
        (quality_document_consumed ?quality_document)
        (quality_document_linked_to_submission ?quality_document ?submission_record)
        (not
          (quality_document_available ?quality_document)
        )
      )
  )
  (:action perform_package_precheck
    :parameters (?commitment_package - commitment_package ?quality_document - quality_document ?submission_record - submission_record ?evidence_item - evidence_item)
    :precondition
      (and
        (entity_ready_for_approval ?commitment_package)
        (package_includes_quality_document ?commitment_package ?quality_document)
        (quality_document_consumed ?quality_document)
        (quality_document_linked_to_submission ?quality_document ?submission_record)
        (evidence_attached ?commitment_package ?evidence_item)
        (not
          (submission_includes_validation_protocol ?submission_record)
        )
        (not
          (package_attachment_reviewed ?commitment_package)
        )
      )
    :effect (package_attachment_reviewed ?commitment_package)
  )
  (:action assign_attachment_category_to_package
    :parameters (?commitment_package - commitment_package ?attachment_category - attachment_category)
    :precondition
      (and
        (entity_ready_for_approval ?commitment_package)
        (attachment_category_available ?attachment_category)
        (not
          (package_attachment_assigned ?commitment_package)
        )
      )
    :effect
      (and
        (package_attachment_assigned ?commitment_package)
        (package_attachment_category_assigned ?commitment_package ?attachment_category)
        (not
          (attachment_category_available ?attachment_category)
        )
      )
  )
  (:action validate_package_attachment
    :parameters (?commitment_package - commitment_package ?quality_document - quality_document ?submission_record - submission_record ?evidence_item - evidence_item ?attachment_category - attachment_category)
    :precondition
      (and
        (entity_ready_for_approval ?commitment_package)
        (package_includes_quality_document ?commitment_package ?quality_document)
        (quality_document_consumed ?quality_document)
        (quality_document_linked_to_submission ?quality_document ?submission_record)
        (evidence_attached ?commitment_package ?evidence_item)
        (submission_includes_validation_protocol ?submission_record)
        (package_attachment_assigned ?commitment_package)
        (package_attachment_category_assigned ?commitment_package ?attachment_category)
        (not
          (package_attachment_reviewed ?commitment_package)
        )
      )
    :effect
      (and
        (package_attachment_reviewed ?commitment_package)
        (package_attachment_validated ?commitment_package)
      )
  )
  (:action apply_risk_assessment_to_package
    :parameters (?commitment_package - commitment_package ?risk_assessment_document - risk_assessment_document ?functional_approver - functional_approver ?quality_document - quality_document ?submission_record - submission_record)
    :precondition
      (and
        (package_attachment_reviewed ?commitment_package)
        (package_risk_assessment_assigned ?commitment_package ?risk_assessment_document)
        (entity_approver_assigned ?commitment_package ?functional_approver)
        (package_includes_quality_document ?commitment_package ?quality_document)
        (quality_document_linked_to_submission ?quality_document ?submission_record)
        (not
          (submission_includes_risk_assessment ?submission_record)
        )
        (not
          (package_has_quality_and_risk_documents ?commitment_package)
        )
      )
    :effect (package_has_quality_and_risk_documents ?commitment_package)
  )
  (:action apply_risk_assessment_to_package_alternate
    :parameters (?commitment_package - commitment_package ?risk_assessment_document - risk_assessment_document ?functional_approver - functional_approver ?quality_document - quality_document ?submission_record - submission_record)
    :precondition
      (and
        (package_attachment_reviewed ?commitment_package)
        (package_risk_assessment_assigned ?commitment_package ?risk_assessment_document)
        (entity_approver_assigned ?commitment_package ?functional_approver)
        (package_includes_quality_document ?commitment_package ?quality_document)
        (quality_document_linked_to_submission ?quality_document ?submission_record)
        (submission_includes_risk_assessment ?submission_record)
        (not
          (package_has_quality_and_risk_documents ?commitment_package)
        )
      )
    :effect (package_has_quality_and_risk_documents ?commitment_package)
  )
  (:action start_detailed_review_without_validation_or_risk
    :parameters (?commitment_package - commitment_package ?validation_protocol - validation_protocol ?quality_document - quality_document ?submission_record - submission_record)
    :precondition
      (and
        (package_has_quality_and_risk_documents ?commitment_package)
        (package_validation_protocol_assigned ?commitment_package ?validation_protocol)
        (package_includes_quality_document ?commitment_package ?quality_document)
        (quality_document_linked_to_submission ?quality_document ?submission_record)
        (not
          (submission_includes_validation_protocol ?submission_record)
        )
        (not
          (submission_includes_risk_assessment ?submission_record)
        )
        (not
          (package_ready_for_final_review ?commitment_package)
        )
      )
    :effect (package_ready_for_final_review ?commitment_package)
  )
  (:action start_detailed_review_with_validation
    :parameters (?commitment_package - commitment_package ?validation_protocol - validation_protocol ?quality_document - quality_document ?submission_record - submission_record)
    :precondition
      (and
        (package_has_quality_and_risk_documents ?commitment_package)
        (package_validation_protocol_assigned ?commitment_package ?validation_protocol)
        (package_includes_quality_document ?commitment_package ?quality_document)
        (quality_document_linked_to_submission ?quality_document ?submission_record)
        (submission_includes_validation_protocol ?submission_record)
        (not
          (submission_includes_risk_assessment ?submission_record)
        )
        (not
          (package_ready_for_final_review ?commitment_package)
        )
      )
    :effect
      (and
        (package_ready_for_final_review ?commitment_package)
        (package_requires_sequenced_approvals ?commitment_package)
      )
  )
  (:action start_detailed_review_with_risk_assessment
    :parameters (?commitment_package - commitment_package ?validation_protocol - validation_protocol ?quality_document - quality_document ?submission_record - submission_record)
    :precondition
      (and
        (package_has_quality_and_risk_documents ?commitment_package)
        (package_validation_protocol_assigned ?commitment_package ?validation_protocol)
        (package_includes_quality_document ?commitment_package ?quality_document)
        (quality_document_linked_to_submission ?quality_document ?submission_record)
        (not
          (submission_includes_validation_protocol ?submission_record)
        )
        (submission_includes_risk_assessment ?submission_record)
        (not
          (package_ready_for_final_review ?commitment_package)
        )
      )
    :effect
      (and
        (package_ready_for_final_review ?commitment_package)
        (package_requires_sequenced_approvals ?commitment_package)
      )
  )
  (:action start_detailed_review_with_validation_and_risk_assessment
    :parameters (?commitment_package - commitment_package ?validation_protocol - validation_protocol ?quality_document - quality_document ?submission_record - submission_record)
    :precondition
      (and
        (package_has_quality_and_risk_documents ?commitment_package)
        (package_validation_protocol_assigned ?commitment_package ?validation_protocol)
        (package_includes_quality_document ?commitment_package ?quality_document)
        (quality_document_linked_to_submission ?quality_document ?submission_record)
        (submission_includes_validation_protocol ?submission_record)
        (submission_includes_risk_assessment ?submission_record)
        (not
          (package_ready_for_final_review ?commitment_package)
        )
      )
    :effect
      (and
        (package_ready_for_final_review ?commitment_package)
        (package_requires_sequenced_approvals ?commitment_package)
      )
  )
  (:action finalize_package_simple
    :parameters (?commitment_package - commitment_package)
    :precondition
      (and
        (package_ready_for_final_review ?commitment_package)
        (not
          (package_requires_sequenced_approvals ?commitment_package)
        )
        (not
          (package_signoff_recorded ?commitment_package)
        )
      )
    :effect
      (and
        (package_signoff_recorded ?commitment_package)
        (entity_submission_prepared ?commitment_package)
      )
  )
  (:action instantiate_approval_template_for_package
    :parameters (?commitment_package - commitment_package ?approval_template - approval_template)
    :precondition
      (and
        (package_ready_for_final_review ?commitment_package)
        (package_requires_sequenced_approvals ?commitment_package)
        (approval_template_available ?approval_template)
      )
    :effect
      (and
        (approval_template_instantiated ?commitment_package ?approval_template)
        (not
          (approval_template_available ?approval_template)
        )
      )
  )
  (:action execute_approval_workflow_for_package
    :parameters (?commitment_package - commitment_package ?site_level_commitment - site_level_commitment ?product_level_commitment - product_level_commitment ?evidence_item - evidence_item ?approval_template - approval_template)
    :precondition
      (and
        (package_ready_for_final_review ?commitment_package)
        (package_requires_sequenced_approvals ?commitment_package)
        (approval_template_instantiated ?commitment_package ?approval_template)
        (package_includes_site_level_commitment ?commitment_package ?site_level_commitment)
        (package_includes_product_level_commitment ?commitment_package ?product_level_commitment)
        (site_level_investigation_completed ?site_level_commitment)
        (product_level_investigation_completed ?product_level_commitment)
        (evidence_attached ?commitment_package ?evidence_item)
        (not
          (package_approvals_completed ?commitment_package)
        )
      )
    :effect (package_approvals_completed ?commitment_package)
  )
  (:action finalize_package_after_approvals
    :parameters (?commitment_package - commitment_package)
    :precondition
      (and
        (package_ready_for_final_review ?commitment_package)
        (package_approvals_completed ?commitment_package)
        (not
          (package_signoff_recorded ?commitment_package)
        )
      )
    :effect
      (and
        (package_signoff_recorded ?commitment_package)
        (entity_submission_prepared ?commitment_package)
      )
  )
  (:action consult_external_stakeholder_for_package
    :parameters (?commitment_package - commitment_package ?external_stakeholder - external_stakeholder ?evidence_item - evidence_item)
    :precondition
      (and
        (entity_ready_for_approval ?commitment_package)
        (evidence_attached ?commitment_package ?evidence_item)
        (external_stakeholder_available ?external_stakeholder)
        (package_external_stakeholder_associated ?commitment_package ?external_stakeholder)
        (not
          (package_stakeholder_consulted ?commitment_package)
        )
      )
    :effect
      (and
        (package_stakeholder_consulted ?commitment_package)
        (not
          (external_stakeholder_available ?external_stakeholder)
        )
      )
  )
  (:action start_approver_sequence_after_stakeholder_consultation
    :parameters (?commitment_package - commitment_package ?functional_approver - functional_approver)
    :precondition
      (and
        (package_stakeholder_consulted ?commitment_package)
        (entity_approver_assigned ?commitment_package ?functional_approver)
        (not
          (package_approver_sequence_started ?commitment_package)
        )
      )
    :effect (package_approver_sequence_started ?commitment_package)
  )
  (:action advance_approver_sequence_with_validation_protocol
    :parameters (?commitment_package - commitment_package ?validation_protocol - validation_protocol)
    :precondition
      (and
        (package_approver_sequence_started ?commitment_package)
        (package_validation_protocol_assigned ?commitment_package ?validation_protocol)
        (not
          (package_approver_sequence_completed ?commitment_package)
        )
      )
    :effect (package_approver_sequence_completed ?commitment_package)
  )
  (:action complete_approver_sequence_and_finalize_package
    :parameters (?commitment_package - commitment_package)
    :precondition
      (and
        (package_approver_sequence_completed ?commitment_package)
        (not
          (package_signoff_recorded ?commitment_package)
        )
      )
    :effect
      (and
        (package_signoff_recorded ?commitment_package)
        (entity_submission_prepared ?commitment_package)
      )
  )
  (:action register_site_commitment_from_package
    :parameters (?site_level_commitment - site_level_commitment ?submission_record - submission_record)
    :precondition
      (and
        (site_level_commitment_ready ?site_level_commitment)
        (site_level_investigation_completed ?site_level_commitment)
        (submission_package_created ?submission_record)
        (submission_quality_checked ?submission_record)
        (not
          (entity_submission_prepared ?site_level_commitment)
        )
      )
    :effect (entity_submission_prepared ?site_level_commitment)
  )
  (:action register_product_commitment_from_package
    :parameters (?product_level_commitment - product_level_commitment ?submission_record - submission_record)
    :precondition
      (and
        (product_level_commitment_ready ?product_level_commitment)
        (product_level_investigation_completed ?product_level_commitment)
        (submission_package_created ?submission_record)
        (submission_quality_checked ?submission_record)
        (not
          (entity_submission_prepared ?product_level_commitment)
        )
      )
    :effect (entity_submission_prepared ?product_level_commitment)
  )
  (:action finalize_commitment_and_link_regulatory_reference
    :parameters (?regulatory_commitment - regulatory_commitment ?regulatory_reference - regulatory_reference ?evidence_item - evidence_item)
    :precondition
      (and
        (entity_submission_prepared ?regulatory_commitment)
        (evidence_attached ?regulatory_commitment ?evidence_item)
        (regulatory_reference_available ?regulatory_reference)
        (not
          (entity_finalized ?regulatory_commitment)
        )
      )
    :effect
      (and
        (entity_finalized ?regulatory_commitment)
        (entity_linked_to_regulatory_reference ?regulatory_commitment ?regulatory_reference)
        (not
          (regulatory_reference_available ?regulatory_reference)
        )
      )
  )
  (:action close_site_commitment_and_release_resource
    :parameters (?site_level_commitment - site_level_commitment ?personnel_resource - personnel_resource ?regulatory_reference - regulatory_reference)
    :precondition
      (and
        (entity_finalized ?site_level_commitment)
        (entity_assigned_to ?site_level_commitment ?personnel_resource)
        (entity_linked_to_regulatory_reference ?site_level_commitment ?regulatory_reference)
        (not
          (entity_registered ?site_level_commitment)
        )
      )
    :effect
      (and
        (entity_registered ?site_level_commitment)
        (personnel_available ?personnel_resource)
        (regulatory_reference_available ?regulatory_reference)
      )
  )
  (:action close_product_commitment_and_release_resource
    :parameters (?product_level_commitment - product_level_commitment ?personnel_resource - personnel_resource ?regulatory_reference - regulatory_reference)
    :precondition
      (and
        (entity_finalized ?product_level_commitment)
        (entity_assigned_to ?product_level_commitment ?personnel_resource)
        (entity_linked_to_regulatory_reference ?product_level_commitment ?regulatory_reference)
        (not
          (entity_registered ?product_level_commitment)
        )
      )
    :effect
      (and
        (entity_registered ?product_level_commitment)
        (personnel_available ?personnel_resource)
        (regulatory_reference_available ?regulatory_reference)
      )
  )
  (:action close_package_and_release_resource
    :parameters (?commitment_package - commitment_package ?personnel_resource - personnel_resource ?regulatory_reference - regulatory_reference)
    :precondition
      (and
        (entity_finalized ?commitment_package)
        (entity_assigned_to ?commitment_package ?personnel_resource)
        (entity_linked_to_regulatory_reference ?commitment_package ?regulatory_reference)
        (not
          (entity_registered ?commitment_package)
        )
      )
    :effect
      (and
        (entity_registered ?commitment_package)
        (personnel_available ?personnel_resource)
        (regulatory_reference_available ?regulatory_reference)
      )
  )
)

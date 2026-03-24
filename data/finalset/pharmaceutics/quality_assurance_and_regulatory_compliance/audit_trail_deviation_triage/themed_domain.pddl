(define (domain audit_trail_deviation_triage_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types role_or_resource - object artifact_type - object impact_category_group - object case_root - object deviation_case - case_root triage_reviewer - role_or_resource subject_matter_expert - role_or_resource quality_approver - role_or_resource consultation_slot - role_or_resource departmental_approver - role_or_resource regulatory_evidence_package - role_or_resource capa_record - role_or_resource audit_lead - role_or_resource remediation_action_template - artifact_type supporting_document - artifact_type escalation_authority - artifact_type validation_impact_category - impact_category_group regulatory_impact_category - impact_category_group change_control_request - impact_category_group workstream_base - deviation_case user_entity - deviation_case site_workstream - workstream_base manufacturing_workstream - workstream_base qa_specialist - user_entity)
  (:predicates
    (case_registered ?deviation_case - deviation_case)
    (sme_review_recorded ?deviation_case - deviation_case)
    (triage_assigned ?deviation_case - deviation_case)
    (closure_propagated ?deviation_case - deviation_case)
    (final_acceptance_recorded ?deviation_case - deviation_case)
    (closure_initiated ?deviation_case - deviation_case)
    (triage_reviewer_available ?triage_reviewer - triage_reviewer)
    (assigned_triage_reviewer ?deviation_case - deviation_case ?triage_reviewer - triage_reviewer)
    (sme_available ?subject_matter_expert - subject_matter_expert)
    (assigned_sme ?deviation_case - deviation_case ?subject_matter_expert - subject_matter_expert)
    (quality_approver_available ?quality_approver - quality_approver)
    (assigned_quality_approver ?deviation_case - deviation_case ?quality_approver - quality_approver)
    (remediation_template_available ?remediation_action_template - remediation_action_template)
    (remediation_instantiated_site ?site_workstream - site_workstream ?remediation_action_template - remediation_action_template)
    (remediation_instantiated_manufacturing ?manufacturing_workstream - manufacturing_workstream ?remediation_action_template - remediation_action_template)
    (workstream_validation_impact ?site_workstream - site_workstream ?validation_impact_category - validation_impact_category)
    (validation_impact_reviewed ?validation_impact_category - validation_impact_category)
    (validation_impact_requires_remediation ?validation_impact_category - validation_impact_category)
    (workstream_ready_for_change_control ?site_workstream - site_workstream)
    (workstream_regulatory_impact ?manufacturing_workstream - manufacturing_workstream ?regulatory_impact_category - regulatory_impact_category)
    (regulatory_impact_reviewed ?regulatory_impact_category - regulatory_impact_category)
    (regulatory_impact_requires_remediation ?regulatory_impact_category - regulatory_impact_category)
    (manufacturing_workstream_ready_for_change_control ?manufacturing_workstream - manufacturing_workstream)
    (change_request_draft_available ?change_control_request - change_control_request)
    (change_request_populated ?change_control_request - change_control_request)
    (ccr_linked_validation_impact ?change_control_request - change_control_request ?validation_impact_category - validation_impact_category)
    (ccr_linked_regulatory_impact ?change_control_request - change_control_request ?regulatory_impact_category - regulatory_impact_category)
    (ccr_requires_validation_plan ?change_control_request - change_control_request)
    (ccr_requires_regulatory_action ?change_control_request - change_control_request)
    (ccr_finalized ?change_control_request - change_control_request)
    (qa_assigned_to_site_workstream ?qa_specialist - qa_specialist ?site_workstream - site_workstream)
    (qa_assigned_to_manufacturing_workstream ?qa_specialist - qa_specialist ?manufacturing_workstream - manufacturing_workstream)
    (qa_associated_with_change_request ?qa_specialist - qa_specialist ?change_control_request - change_control_request)
    (supporting_document_available ?supporting_document - supporting_document)
    (qa_has_staged_document ?qa_specialist - qa_specialist ?supporting_document - supporting_document)
    (document_staged_for_review ?supporting_document - supporting_document)
    (document_attached_to_ccr ?supporting_document - supporting_document ?change_control_request - change_control_request)
    (capa_preparation_ready ?qa_specialist - qa_specialist)
    (capa_linked_to_qa_specialist ?qa_specialist - qa_specialist)
    (capa_lead_assigned ?qa_specialist - qa_specialist)
    (consultation_scheduled_for_qa ?qa_specialist - qa_specialist)
    (consultation_recorded_for_qa ?qa_specialist - qa_specialist)
    (departmental_review_required_for_qa ?qa_specialist - qa_specialist)
    (qa_verification_complete ?qa_specialist - qa_specialist)
    (escalation_authority_available ?escalation_authority - escalation_authority)
    (escalation_authority_assigned_to_qa ?qa_specialist - qa_specialist ?escalation_authority - escalation_authority)
    (escalation_invoked_for_qa ?qa_specialist - qa_specialist)
    (escalation_routed_to_approver_for_qa ?qa_specialist - qa_specialist)
    (escalation_approval_recorded_for_qa ?qa_specialist - qa_specialist)
    (consultation_slot_available ?consultation_slot - consultation_slot)
    (qa_consultation_scheduled ?qa_specialist - qa_specialist ?consultation_slot - consultation_slot)
    (departmental_approver_available ?departmental_approver - departmental_approver)
    (qa_has_departmental_approval ?qa_specialist - qa_specialist ?departmental_approver - departmental_approver)
    (capa_record_available ?capa_record - capa_record)
    (qa_linked_to_capa_record ?qa_specialist - qa_specialist ?capa_record - capa_record)
    (audit_lead_available ?audit_lead - audit_lead)
    (qa_assigned_audit_lead ?qa_specialist - qa_specialist ?audit_lead - audit_lead)
    (regulatory_evidence_available ?regulatory_evidence_package - regulatory_evidence_package)
    (case_has_evidence_package ?deviation_case - deviation_case ?regulatory_evidence_package - regulatory_evidence_package)
    (site_workstream_investigation_started ?site_workstream - site_workstream)
    (manufacturing_workstream_investigation_started ?manufacturing_workstream - manufacturing_workstream)
    (qa_finalization_flag ?qa_specialist - qa_specialist)
  )
  (:action create_and_register_case
    :parameters (?deviation_case - deviation_case)
    :precondition
      (and
        (not
          (case_registered ?deviation_case)
        )
        (not
          (closure_propagated ?deviation_case)
        )
      )
    :effect (case_registered ?deviation_case)
  )
  (:action assign_triage_reviewer
    :parameters (?deviation_case - deviation_case ?triage_reviewer - triage_reviewer)
    :precondition
      (and
        (case_registered ?deviation_case)
        (not
          (triage_assigned ?deviation_case)
        )
        (triage_reviewer_available ?triage_reviewer)
      )
    :effect
      (and
        (triage_assigned ?deviation_case)
        (assigned_triage_reviewer ?deviation_case ?triage_reviewer)
        (not
          (triage_reviewer_available ?triage_reviewer)
        )
      )
  )
  (:action assign_sme_to_case
    :parameters (?deviation_case - deviation_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (case_registered ?deviation_case)
        (triage_assigned ?deviation_case)
        (sme_available ?subject_matter_expert)
      )
    :effect
      (and
        (assigned_sme ?deviation_case ?subject_matter_expert)
        (not
          (sme_available ?subject_matter_expert)
        )
      )
  )
  (:action record_sme_review
    :parameters (?deviation_case - deviation_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (case_registered ?deviation_case)
        (triage_assigned ?deviation_case)
        (assigned_sme ?deviation_case ?subject_matter_expert)
        (not
          (sme_review_recorded ?deviation_case)
        )
      )
    :effect (sme_review_recorded ?deviation_case)
  )
  (:action release_sme_from_case
    :parameters (?deviation_case - deviation_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (assigned_sme ?deviation_case ?subject_matter_expert)
      )
    :effect
      (and
        (sme_available ?subject_matter_expert)
        (not
          (assigned_sme ?deviation_case ?subject_matter_expert)
        )
      )
  )
  (:action assign_quality_approver_to_case
    :parameters (?deviation_case - deviation_case ?quality_approver - quality_approver)
    :precondition
      (and
        (sme_review_recorded ?deviation_case)
        (quality_approver_available ?quality_approver)
      )
    :effect
      (and
        (assigned_quality_approver ?deviation_case ?quality_approver)
        (not
          (quality_approver_available ?quality_approver)
        )
      )
  )
  (:action release_quality_approver_from_case
    :parameters (?deviation_case - deviation_case ?quality_approver - quality_approver)
    :precondition
      (and
        (assigned_quality_approver ?deviation_case ?quality_approver)
      )
    :effect
      (and
        (quality_approver_available ?quality_approver)
        (not
          (assigned_quality_approver ?deviation_case ?quality_approver)
        )
      )
  )
  (:action assign_capa_record_to_qa_specialist
    :parameters (?qa_specialist - qa_specialist ?capa_record - capa_record)
    :precondition
      (and
        (sme_review_recorded ?qa_specialist)
        (capa_record_available ?capa_record)
      )
    :effect
      (and
        (qa_linked_to_capa_record ?qa_specialist ?capa_record)
        (not
          (capa_record_available ?capa_record)
        )
      )
  )
  (:action release_capa_record_from_qa_specialist
    :parameters (?qa_specialist - qa_specialist ?capa_record - capa_record)
    :precondition
      (and
        (qa_linked_to_capa_record ?qa_specialist ?capa_record)
      )
    :effect
      (and
        (capa_record_available ?capa_record)
        (not
          (qa_linked_to_capa_record ?qa_specialist ?capa_record)
        )
      )
  )
  (:action assign_audit_lead_to_qa_specialist
    :parameters (?qa_specialist - qa_specialist ?audit_lead - audit_lead)
    :precondition
      (and
        (sme_review_recorded ?qa_specialist)
        (audit_lead_available ?audit_lead)
      )
    :effect
      (and
        (qa_assigned_audit_lead ?qa_specialist ?audit_lead)
        (not
          (audit_lead_available ?audit_lead)
        )
      )
  )
  (:action release_audit_lead_from_qa_specialist
    :parameters (?qa_specialist - qa_specialist ?audit_lead - audit_lead)
    :precondition
      (and
        (qa_assigned_audit_lead ?qa_specialist ?audit_lead)
      )
    :effect
      (and
        (audit_lead_available ?audit_lead)
        (not
          (qa_assigned_audit_lead ?qa_specialist ?audit_lead)
        )
      )
  )
  (:action initiate_validation_impact_review
    :parameters (?site_workstream - site_workstream ?validation_impact_category - validation_impact_category ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (sme_review_recorded ?site_workstream)
        (assigned_sme ?site_workstream ?subject_matter_expert)
        (workstream_validation_impact ?site_workstream ?validation_impact_category)
        (not
          (validation_impact_reviewed ?validation_impact_category)
        )
        (not
          (validation_impact_requires_remediation ?validation_impact_category)
        )
      )
    :effect (validation_impact_reviewed ?validation_impact_category)
  )
  (:action approve_and_initiate_site_workstream
    :parameters (?site_workstream - site_workstream ?validation_impact_category - validation_impact_category ?quality_approver - quality_approver)
    :precondition
      (and
        (sme_review_recorded ?site_workstream)
        (assigned_quality_approver ?site_workstream ?quality_approver)
        (workstream_validation_impact ?site_workstream ?validation_impact_category)
        (validation_impact_reviewed ?validation_impact_category)
        (not
          (site_workstream_investigation_started ?site_workstream)
        )
      )
    :effect
      (and
        (site_workstream_investigation_started ?site_workstream)
        (workstream_ready_for_change_control ?site_workstream)
      )
  )
  (:action instantiate_remediation_template_for_site_workstream
    :parameters (?site_workstream - site_workstream ?validation_impact_category - validation_impact_category ?remediation_action_template - remediation_action_template)
    :precondition
      (and
        (sme_review_recorded ?site_workstream)
        (workstream_validation_impact ?site_workstream ?validation_impact_category)
        (remediation_template_available ?remediation_action_template)
        (not
          (site_workstream_investigation_started ?site_workstream)
        )
      )
    :effect
      (and
        (validation_impact_requires_remediation ?validation_impact_category)
        (site_workstream_investigation_started ?site_workstream)
        (remediation_instantiated_site ?site_workstream ?remediation_action_template)
        (not
          (remediation_template_available ?remediation_action_template)
        )
      )
  )
  (:action complete_site_remediation_and_record
    :parameters (?site_workstream - site_workstream ?validation_impact_category - validation_impact_category ?subject_matter_expert - subject_matter_expert ?remediation_action_template - remediation_action_template)
    :precondition
      (and
        (sme_review_recorded ?site_workstream)
        (assigned_sme ?site_workstream ?subject_matter_expert)
        (workstream_validation_impact ?site_workstream ?validation_impact_category)
        (validation_impact_requires_remediation ?validation_impact_category)
        (remediation_instantiated_site ?site_workstream ?remediation_action_template)
        (not
          (workstream_ready_for_change_control ?site_workstream)
        )
      )
    :effect
      (and
        (validation_impact_reviewed ?validation_impact_category)
        (workstream_ready_for_change_control ?site_workstream)
        (remediation_template_available ?remediation_action_template)
        (not
          (remediation_instantiated_site ?site_workstream ?remediation_action_template)
        )
      )
  )
  (:action initiate_manufacturing_impact_review
    :parameters (?manufacturing_workstream - manufacturing_workstream ?regulatory_impact_category - regulatory_impact_category ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (sme_review_recorded ?manufacturing_workstream)
        (assigned_sme ?manufacturing_workstream ?subject_matter_expert)
        (workstream_regulatory_impact ?manufacturing_workstream ?regulatory_impact_category)
        (not
          (regulatory_impact_reviewed ?regulatory_impact_category)
        )
        (not
          (regulatory_impact_requires_remediation ?regulatory_impact_category)
        )
      )
    :effect (regulatory_impact_reviewed ?regulatory_impact_category)
  )
  (:action approve_and_initiate_manufacturing_workstream
    :parameters (?manufacturing_workstream - manufacturing_workstream ?regulatory_impact_category - regulatory_impact_category ?quality_approver - quality_approver)
    :precondition
      (and
        (sme_review_recorded ?manufacturing_workstream)
        (assigned_quality_approver ?manufacturing_workstream ?quality_approver)
        (workstream_regulatory_impact ?manufacturing_workstream ?regulatory_impact_category)
        (regulatory_impact_reviewed ?regulatory_impact_category)
        (not
          (manufacturing_workstream_investigation_started ?manufacturing_workstream)
        )
      )
    :effect
      (and
        (manufacturing_workstream_investigation_started ?manufacturing_workstream)
        (manufacturing_workstream_ready_for_change_control ?manufacturing_workstream)
      )
  )
  (:action instantiate_remediation_template_for_manufacturing_workstream
    :parameters (?manufacturing_workstream - manufacturing_workstream ?regulatory_impact_category - regulatory_impact_category ?remediation_action_template - remediation_action_template)
    :precondition
      (and
        (sme_review_recorded ?manufacturing_workstream)
        (workstream_regulatory_impact ?manufacturing_workstream ?regulatory_impact_category)
        (remediation_template_available ?remediation_action_template)
        (not
          (manufacturing_workstream_investigation_started ?manufacturing_workstream)
        )
      )
    :effect
      (and
        (regulatory_impact_requires_remediation ?regulatory_impact_category)
        (manufacturing_workstream_investigation_started ?manufacturing_workstream)
        (remediation_instantiated_manufacturing ?manufacturing_workstream ?remediation_action_template)
        (not
          (remediation_template_available ?remediation_action_template)
        )
      )
  )
  (:action complete_manufacturing_remediation_and_record
    :parameters (?manufacturing_workstream - manufacturing_workstream ?regulatory_impact_category - regulatory_impact_category ?subject_matter_expert - subject_matter_expert ?remediation_action_template - remediation_action_template)
    :precondition
      (and
        (sme_review_recorded ?manufacturing_workstream)
        (assigned_sme ?manufacturing_workstream ?subject_matter_expert)
        (workstream_regulatory_impact ?manufacturing_workstream ?regulatory_impact_category)
        (regulatory_impact_requires_remediation ?regulatory_impact_category)
        (remediation_instantiated_manufacturing ?manufacturing_workstream ?remediation_action_template)
        (not
          (manufacturing_workstream_ready_for_change_control ?manufacturing_workstream)
        )
      )
    :effect
      (and
        (regulatory_impact_reviewed ?regulatory_impact_category)
        (manufacturing_workstream_ready_for_change_control ?manufacturing_workstream)
        (remediation_template_available ?remediation_action_template)
        (not
          (remediation_instantiated_manufacturing ?manufacturing_workstream ?remediation_action_template)
        )
      )
  )
  (:action initiate_change_request
    :parameters (?site_workstream - site_workstream ?manufacturing_workstream - manufacturing_workstream ?validation_impact_category - validation_impact_category ?regulatory_impact_category - regulatory_impact_category ?change_control_request - change_control_request)
    :precondition
      (and
        (site_workstream_investigation_started ?site_workstream)
        (manufacturing_workstream_investigation_started ?manufacturing_workstream)
        (workstream_validation_impact ?site_workstream ?validation_impact_category)
        (workstream_regulatory_impact ?manufacturing_workstream ?regulatory_impact_category)
        (validation_impact_reviewed ?validation_impact_category)
        (regulatory_impact_reviewed ?regulatory_impact_category)
        (workstream_ready_for_change_control ?site_workstream)
        (manufacturing_workstream_ready_for_change_control ?manufacturing_workstream)
        (change_request_draft_available ?change_control_request)
      )
    :effect
      (and
        (change_request_populated ?change_control_request)
        (ccr_linked_validation_impact ?change_control_request ?validation_impact_category)
        (ccr_linked_regulatory_impact ?change_control_request ?regulatory_impact_category)
        (not
          (change_request_draft_available ?change_control_request)
        )
      )
  )
  (:action initiate_change_request_with_validation_plan
    :parameters (?site_workstream - site_workstream ?manufacturing_workstream - manufacturing_workstream ?validation_impact_category - validation_impact_category ?regulatory_impact_category - regulatory_impact_category ?change_control_request - change_control_request)
    :precondition
      (and
        (site_workstream_investigation_started ?site_workstream)
        (manufacturing_workstream_investigation_started ?manufacturing_workstream)
        (workstream_validation_impact ?site_workstream ?validation_impact_category)
        (workstream_regulatory_impact ?manufacturing_workstream ?regulatory_impact_category)
        (validation_impact_requires_remediation ?validation_impact_category)
        (regulatory_impact_reviewed ?regulatory_impact_category)
        (not
          (workstream_ready_for_change_control ?site_workstream)
        )
        (manufacturing_workstream_ready_for_change_control ?manufacturing_workstream)
        (change_request_draft_available ?change_control_request)
      )
    :effect
      (and
        (change_request_populated ?change_control_request)
        (ccr_linked_validation_impact ?change_control_request ?validation_impact_category)
        (ccr_linked_regulatory_impact ?change_control_request ?regulatory_impact_category)
        (ccr_requires_validation_plan ?change_control_request)
        (not
          (change_request_draft_available ?change_control_request)
        )
      )
  )
  (:action initiate_change_request_with_regulatory_plan
    :parameters (?site_workstream - site_workstream ?manufacturing_workstream - manufacturing_workstream ?validation_impact_category - validation_impact_category ?regulatory_impact_category - regulatory_impact_category ?change_control_request - change_control_request)
    :precondition
      (and
        (site_workstream_investigation_started ?site_workstream)
        (manufacturing_workstream_investigation_started ?manufacturing_workstream)
        (workstream_validation_impact ?site_workstream ?validation_impact_category)
        (workstream_regulatory_impact ?manufacturing_workstream ?regulatory_impact_category)
        (validation_impact_reviewed ?validation_impact_category)
        (regulatory_impact_requires_remediation ?regulatory_impact_category)
        (workstream_ready_for_change_control ?site_workstream)
        (not
          (manufacturing_workstream_ready_for_change_control ?manufacturing_workstream)
        )
        (change_request_draft_available ?change_control_request)
      )
    :effect
      (and
        (change_request_populated ?change_control_request)
        (ccr_linked_validation_impact ?change_control_request ?validation_impact_category)
        (ccr_linked_regulatory_impact ?change_control_request ?regulatory_impact_category)
        (ccr_requires_regulatory_action ?change_control_request)
        (not
          (change_request_draft_available ?change_control_request)
        )
      )
  )
  (:action initiate_change_request_with_validation_and_regulatory_plans
    :parameters (?site_workstream - site_workstream ?manufacturing_workstream - manufacturing_workstream ?validation_impact_category - validation_impact_category ?regulatory_impact_category - regulatory_impact_category ?change_control_request - change_control_request)
    :precondition
      (and
        (site_workstream_investigation_started ?site_workstream)
        (manufacturing_workstream_investigation_started ?manufacturing_workstream)
        (workstream_validation_impact ?site_workstream ?validation_impact_category)
        (workstream_regulatory_impact ?manufacturing_workstream ?regulatory_impact_category)
        (validation_impact_requires_remediation ?validation_impact_category)
        (regulatory_impact_requires_remediation ?regulatory_impact_category)
        (not
          (workstream_ready_for_change_control ?site_workstream)
        )
        (not
          (manufacturing_workstream_ready_for_change_control ?manufacturing_workstream)
        )
        (change_request_draft_available ?change_control_request)
      )
    :effect
      (and
        (change_request_populated ?change_control_request)
        (ccr_linked_validation_impact ?change_control_request ?validation_impact_category)
        (ccr_linked_regulatory_impact ?change_control_request ?regulatory_impact_category)
        (ccr_requires_validation_plan ?change_control_request)
        (ccr_requires_regulatory_action ?change_control_request)
        (not
          (change_request_draft_available ?change_control_request)
        )
      )
  )
  (:action finalize_change_request
    :parameters (?change_control_request - change_control_request ?site_workstream - site_workstream ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (change_request_populated ?change_control_request)
        (site_workstream_investigation_started ?site_workstream)
        (assigned_sme ?site_workstream ?subject_matter_expert)
        (not
          (ccr_finalized ?change_control_request)
        )
      )
    :effect (ccr_finalized ?change_control_request)
  )
  (:action attach_supporting_document_to_ccr_and_stage
    :parameters (?qa_specialist - qa_specialist ?supporting_document - supporting_document ?change_control_request - change_control_request)
    :precondition
      (and
        (sme_review_recorded ?qa_specialist)
        (qa_associated_with_change_request ?qa_specialist ?change_control_request)
        (qa_has_staged_document ?qa_specialist ?supporting_document)
        (supporting_document_available ?supporting_document)
        (change_request_populated ?change_control_request)
        (ccr_finalized ?change_control_request)
        (not
          (document_staged_for_review ?supporting_document)
        )
      )
    :effect
      (and
        (document_staged_for_review ?supporting_document)
        (document_attached_to_ccr ?supporting_document ?change_control_request)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_document_staging_and_mark_capa_ready
    :parameters (?qa_specialist - qa_specialist ?supporting_document - supporting_document ?change_control_request - change_control_request ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (sme_review_recorded ?qa_specialist)
        (qa_has_staged_document ?qa_specialist ?supporting_document)
        (document_staged_for_review ?supporting_document)
        (document_attached_to_ccr ?supporting_document ?change_control_request)
        (assigned_sme ?qa_specialist ?subject_matter_expert)
        (not
          (ccr_requires_validation_plan ?change_control_request)
        )
        (not
          (capa_preparation_ready ?qa_specialist)
        )
      )
    :effect (capa_preparation_ready ?qa_specialist)
  )
  (:action schedule_consultation_slot_for_qa_specialist
    :parameters (?qa_specialist - qa_specialist ?consultation_slot - consultation_slot)
    :precondition
      (and
        (sme_review_recorded ?qa_specialist)
        (consultation_slot_available ?consultation_slot)
        (not
          (consultation_scheduled_for_qa ?qa_specialist)
        )
      )
    :effect
      (and
        (consultation_scheduled_for_qa ?qa_specialist)
        (qa_consultation_scheduled ?qa_specialist ?consultation_slot)
        (not
          (consultation_slot_available ?consultation_slot)
        )
      )
  )
  (:action confirm_consultation_and_stage_document
    :parameters (?qa_specialist - qa_specialist ?supporting_document - supporting_document ?change_control_request - change_control_request ?subject_matter_expert - subject_matter_expert ?consultation_slot - consultation_slot)
    :precondition
      (and
        (sme_review_recorded ?qa_specialist)
        (qa_has_staged_document ?qa_specialist ?supporting_document)
        (document_staged_for_review ?supporting_document)
        (document_attached_to_ccr ?supporting_document ?change_control_request)
        (assigned_sme ?qa_specialist ?subject_matter_expert)
        (ccr_requires_validation_plan ?change_control_request)
        (consultation_scheduled_for_qa ?qa_specialist)
        (qa_consultation_scheduled ?qa_specialist ?consultation_slot)
        (not
          (capa_preparation_ready ?qa_specialist)
        )
      )
    :effect
      (and
        (capa_preparation_ready ?qa_specialist)
        (consultation_recorded_for_qa ?qa_specialist)
      )
  )
  (:action allocate_capa_to_qa_specialist
    :parameters (?qa_specialist - qa_specialist ?capa_record - capa_record ?quality_approver - quality_approver ?supporting_document - supporting_document ?change_control_request - change_control_request)
    :precondition
      (and
        (capa_preparation_ready ?qa_specialist)
        (qa_linked_to_capa_record ?qa_specialist ?capa_record)
        (assigned_quality_approver ?qa_specialist ?quality_approver)
        (qa_has_staged_document ?qa_specialist ?supporting_document)
        (document_attached_to_ccr ?supporting_document ?change_control_request)
        (not
          (ccr_requires_regulatory_action ?change_control_request)
        )
        (not
          (capa_linked_to_qa_specialist ?qa_specialist)
        )
      )
    :effect (capa_linked_to_qa_specialist ?qa_specialist)
  )
  (:action allocate_capa_to_qa_specialist_confirmed
    :parameters (?qa_specialist - qa_specialist ?capa_record - capa_record ?quality_approver - quality_approver ?supporting_document - supporting_document ?change_control_request - change_control_request)
    :precondition
      (and
        (capa_preparation_ready ?qa_specialist)
        (qa_linked_to_capa_record ?qa_specialist ?capa_record)
        (assigned_quality_approver ?qa_specialist ?quality_approver)
        (qa_has_staged_document ?qa_specialist ?supporting_document)
        (document_attached_to_ccr ?supporting_document ?change_control_request)
        (ccr_requires_regulatory_action ?change_control_request)
        (not
          (capa_linked_to_qa_specialist ?qa_specialist)
        )
      )
    :effect (capa_linked_to_qa_specialist ?qa_specialist)
  )
  (:action assign_audit_lead_for_capa
    :parameters (?qa_specialist - qa_specialist ?audit_lead - audit_lead ?supporting_document - supporting_document ?change_control_request - change_control_request)
    :precondition
      (and
        (capa_linked_to_qa_specialist ?qa_specialist)
        (qa_assigned_audit_lead ?qa_specialist ?audit_lead)
        (qa_has_staged_document ?qa_specialist ?supporting_document)
        (document_attached_to_ccr ?supporting_document ?change_control_request)
        (not
          (ccr_requires_validation_plan ?change_control_request)
        )
        (not
          (ccr_requires_regulatory_action ?change_control_request)
        )
        (not
          (capa_lead_assigned ?qa_specialist)
        )
      )
    :effect (capa_lead_assigned ?qa_specialist)
  )
  (:action assign_audit_lead_and_require_departmental_review
    :parameters (?qa_specialist - qa_specialist ?audit_lead - audit_lead ?supporting_document - supporting_document ?change_control_request - change_control_request)
    :precondition
      (and
        (capa_linked_to_qa_specialist ?qa_specialist)
        (qa_assigned_audit_lead ?qa_specialist ?audit_lead)
        (qa_has_staged_document ?qa_specialist ?supporting_document)
        (document_attached_to_ccr ?supporting_document ?change_control_request)
        (ccr_requires_validation_plan ?change_control_request)
        (not
          (ccr_requires_regulatory_action ?change_control_request)
        )
        (not
          (capa_lead_assigned ?qa_specialist)
        )
      )
    :effect
      (and
        (capa_lead_assigned ?qa_specialist)
        (departmental_review_required_for_qa ?qa_specialist)
      )
  )
  (:action assign_audit_lead_and_require_departmental_review_alt
    :parameters (?qa_specialist - qa_specialist ?audit_lead - audit_lead ?supporting_document - supporting_document ?change_control_request - change_control_request)
    :precondition
      (and
        (capa_linked_to_qa_specialist ?qa_specialist)
        (qa_assigned_audit_lead ?qa_specialist ?audit_lead)
        (qa_has_staged_document ?qa_specialist ?supporting_document)
        (document_attached_to_ccr ?supporting_document ?change_control_request)
        (not
          (ccr_requires_validation_plan ?change_control_request)
        )
        (ccr_requires_regulatory_action ?change_control_request)
        (not
          (capa_lead_assigned ?qa_specialist)
        )
      )
    :effect
      (and
        (capa_lead_assigned ?qa_specialist)
        (departmental_review_required_for_qa ?qa_specialist)
      )
  )
  (:action assign_audit_lead_and_require_departmental_review_final
    :parameters (?qa_specialist - qa_specialist ?audit_lead - audit_lead ?supporting_document - supporting_document ?change_control_request - change_control_request)
    :precondition
      (and
        (capa_linked_to_qa_specialist ?qa_specialist)
        (qa_assigned_audit_lead ?qa_specialist ?audit_lead)
        (qa_has_staged_document ?qa_specialist ?supporting_document)
        (document_attached_to_ccr ?supporting_document ?change_control_request)
        (ccr_requires_validation_plan ?change_control_request)
        (ccr_requires_regulatory_action ?change_control_request)
        (not
          (capa_lead_assigned ?qa_specialist)
        )
      )
    :effect
      (and
        (capa_lead_assigned ?qa_specialist)
        (departmental_review_required_for_qa ?qa_specialist)
      )
  )
  (:action record_qa_specialist_final_signoff
    :parameters (?qa_specialist - qa_specialist)
    :precondition
      (and
        (capa_lead_assigned ?qa_specialist)
        (not
          (departmental_review_required_for_qa ?qa_specialist)
        )
        (not
          (qa_finalization_flag ?qa_specialist)
        )
      )
    :effect
      (and
        (qa_finalization_flag ?qa_specialist)
        (final_acceptance_recorded ?qa_specialist)
      )
  )
  (:action link_qa_to_departmental_approver_for_review
    :parameters (?qa_specialist - qa_specialist ?departmental_approver - departmental_approver)
    :precondition
      (and
        (capa_lead_assigned ?qa_specialist)
        (departmental_review_required_for_qa ?qa_specialist)
        (departmental_approver_available ?departmental_approver)
      )
    :effect
      (and
        (qa_has_departmental_approval ?qa_specialist ?departmental_approver)
        (not
          (departmental_approver_available ?departmental_approver)
        )
      )
  )
  (:action perform_final_qa_verification
    :parameters (?qa_specialist - qa_specialist ?site_workstream - site_workstream ?manufacturing_workstream - manufacturing_workstream ?subject_matter_expert - subject_matter_expert ?departmental_approver - departmental_approver)
    :precondition
      (and
        (capa_lead_assigned ?qa_specialist)
        (departmental_review_required_for_qa ?qa_specialist)
        (qa_has_departmental_approval ?qa_specialist ?departmental_approver)
        (qa_assigned_to_site_workstream ?qa_specialist ?site_workstream)
        (qa_assigned_to_manufacturing_workstream ?qa_specialist ?manufacturing_workstream)
        (workstream_ready_for_change_control ?site_workstream)
        (manufacturing_workstream_ready_for_change_control ?manufacturing_workstream)
        (assigned_sme ?qa_specialist ?subject_matter_expert)
        (not
          (qa_verification_complete ?qa_specialist)
        )
      )
    :effect (qa_verification_complete ?qa_specialist)
  )
  (:action finalize_qa_and_record_acceptance
    :parameters (?qa_specialist - qa_specialist)
    :precondition
      (and
        (capa_lead_assigned ?qa_specialist)
        (qa_verification_complete ?qa_specialist)
        (not
          (qa_finalization_flag ?qa_specialist)
        )
      )
    :effect
      (and
        (qa_finalization_flag ?qa_specialist)
        (final_acceptance_recorded ?qa_specialist)
      )
  )
  (:action invoke_escalation_authority
    :parameters (?qa_specialist - qa_specialist ?escalation_authority - escalation_authority ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (sme_review_recorded ?qa_specialist)
        (assigned_sme ?qa_specialist ?subject_matter_expert)
        (escalation_authority_available ?escalation_authority)
        (escalation_authority_assigned_to_qa ?qa_specialist ?escalation_authority)
        (not
          (escalation_invoked_for_qa ?qa_specialist)
        )
      )
    :effect
      (and
        (escalation_invoked_for_qa ?qa_specialist)
        (not
          (escalation_authority_available ?escalation_authority)
        )
      )
  )
  (:action route_escalation_to_quality_approver
    :parameters (?qa_specialist - qa_specialist ?quality_approver - quality_approver)
    :precondition
      (and
        (escalation_invoked_for_qa ?qa_specialist)
        (assigned_quality_approver ?qa_specialist ?quality_approver)
        (not
          (escalation_routed_to_approver_for_qa ?qa_specialist)
        )
      )
    :effect (escalation_routed_to_approver_for_qa ?qa_specialist)
  )
  (:action record_escalation_approval
    :parameters (?qa_specialist - qa_specialist ?audit_lead - audit_lead)
    :precondition
      (and
        (escalation_routed_to_approver_for_qa ?qa_specialist)
        (qa_assigned_audit_lead ?qa_specialist ?audit_lead)
        (not
          (escalation_approval_recorded_for_qa ?qa_specialist)
        )
      )
    :effect (escalation_approval_recorded_for_qa ?qa_specialist)
  )
  (:action finalize_escalation_and_record_acceptance
    :parameters (?qa_specialist - qa_specialist)
    :precondition
      (and
        (escalation_approval_recorded_for_qa ?qa_specialist)
        (not
          (qa_finalization_flag ?qa_specialist)
        )
      )
    :effect
      (and
        (qa_finalization_flag ?qa_specialist)
        (final_acceptance_recorded ?qa_specialist)
      )
  )
  (:action mark_site_workstream_completed
    :parameters (?site_workstream - site_workstream ?change_control_request - change_control_request)
    :precondition
      (and
        (site_workstream_investigation_started ?site_workstream)
        (workstream_ready_for_change_control ?site_workstream)
        (change_request_populated ?change_control_request)
        (ccr_finalized ?change_control_request)
        (not
          (final_acceptance_recorded ?site_workstream)
        )
      )
    :effect (final_acceptance_recorded ?site_workstream)
  )
  (:action mark_manufacturing_workstream_completed
    :parameters (?manufacturing_workstream - manufacturing_workstream ?change_control_request - change_control_request)
    :precondition
      (and
        (manufacturing_workstream_investigation_started ?manufacturing_workstream)
        (manufacturing_workstream_ready_for_change_control ?manufacturing_workstream)
        (change_request_populated ?change_control_request)
        (ccr_finalized ?change_control_request)
        (not
          (final_acceptance_recorded ?manufacturing_workstream)
        )
      )
    :effect (final_acceptance_recorded ?manufacturing_workstream)
  )
  (:action attach_regulatory_evidence_and_initiate_case_closure
    :parameters (?deviation_case - deviation_case ?regulatory_evidence_package - regulatory_evidence_package ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (final_acceptance_recorded ?deviation_case)
        (assigned_sme ?deviation_case ?subject_matter_expert)
        (regulatory_evidence_available ?regulatory_evidence_package)
        (not
          (closure_initiated ?deviation_case)
        )
      )
    :effect
      (and
        (closure_initiated ?deviation_case)
        (case_has_evidence_package ?deviation_case ?regulatory_evidence_package)
        (not
          (regulatory_evidence_available ?regulatory_evidence_package)
        )
      )
  )
  (:action propagate_case_closure_to_site_workstream
    :parameters (?site_workstream - site_workstream ?triage_reviewer - triage_reviewer ?regulatory_evidence_package - regulatory_evidence_package)
    :precondition
      (and
        (closure_initiated ?site_workstream)
        (assigned_triage_reviewer ?site_workstream ?triage_reviewer)
        (case_has_evidence_package ?site_workstream ?regulatory_evidence_package)
        (not
          (closure_propagated ?site_workstream)
        )
      )
    :effect
      (and
        (closure_propagated ?site_workstream)
        (triage_reviewer_available ?triage_reviewer)
        (regulatory_evidence_available ?regulatory_evidence_package)
      )
  )
  (:action propagate_case_closure_to_manufacturing_workstream
    :parameters (?manufacturing_workstream - manufacturing_workstream ?triage_reviewer - triage_reviewer ?regulatory_evidence_package - regulatory_evidence_package)
    :precondition
      (and
        (closure_initiated ?manufacturing_workstream)
        (assigned_triage_reviewer ?manufacturing_workstream ?triage_reviewer)
        (case_has_evidence_package ?manufacturing_workstream ?regulatory_evidence_package)
        (not
          (closure_propagated ?manufacturing_workstream)
        )
      )
    :effect
      (and
        (closure_propagated ?manufacturing_workstream)
        (triage_reviewer_available ?triage_reviewer)
        (regulatory_evidence_available ?regulatory_evidence_package)
      )
  )
  (:action propagate_case_closure_to_qa_specialist
    :parameters (?qa_specialist - qa_specialist ?triage_reviewer - triage_reviewer ?regulatory_evidence_package - regulatory_evidence_package)
    :precondition
      (and
        (closure_initiated ?qa_specialist)
        (assigned_triage_reviewer ?qa_specialist ?triage_reviewer)
        (case_has_evidence_package ?qa_specialist ?regulatory_evidence_package)
        (not
          (closure_propagated ?qa_specialist)
        )
      )
    :effect
      (and
        (closure_propagated ?qa_specialist)
        (triage_reviewer_available ?triage_reviewer)
        (regulatory_evidence_available ?regulatory_evidence_package)
      )
  )
)

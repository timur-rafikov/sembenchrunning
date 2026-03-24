(define (domain pharmaceutics_data_integrity_review_routing)
  (:requirements :strips :typing :negative-preconditions)
  (:types organizational_resource - object artifact_group - object requirement_group - object case_workflow_group - object data_integrity_review_case - case_workflow_group quality_reviewer - organizational_resource subject_matter_expert - organizational_resource functional_approver - organizational_resource regulatory_checklist - organizational_resource domain_representative - organizational_resource regulatory_escalation_notice - organizational_resource validation_protocol - organizational_resource audit_finding - organizational_resource supporting_document - artifact_group evidence_document - artifact_group risk_assessment - artifact_group validation_check - requirement_group regulatory_check - requirement_group review_package - requirement_group departmental_workstream - data_integrity_review_case document_workstream - data_integrity_review_case originating_department - departmental_workstream reviewing_department - departmental_workstream controlled_document - document_workstream)
  (:predicates
    (triaged ?data_integrity_review_case - data_integrity_review_case)
    (subject_matter_expert_review_completed ?data_integrity_review_case - data_integrity_review_case)
    (quality_reviewer_engaged ?data_integrity_review_case - data_integrity_review_case)
    (finalized ?data_integrity_review_case - data_integrity_review_case)
    (release_authorized ?data_integrity_review_case - data_integrity_review_case)
    (escalated ?data_integrity_review_case - data_integrity_review_case)
    (quality_reviewer_available ?quality_reviewer - quality_reviewer)
    (quality_reviewer_assigned ?data_integrity_review_case - data_integrity_review_case ?quality_reviewer - quality_reviewer)
    (subject_matter_expert_available ?subject_matter_expert - subject_matter_expert)
    (subject_matter_expert_assigned ?data_integrity_review_case - data_integrity_review_case ?subject_matter_expert - subject_matter_expert)
    (approver_available ?functional_approver - functional_approver)
    (functional_approver_assigned ?data_integrity_review_case - data_integrity_review_case ?functional_approver - functional_approver)
    (supporting_document_available ?supporting_document - supporting_document)
    (originating_department_attached_evidence ?originating_department - originating_department ?supporting_document - supporting_document)
    (reviewing_department_attached_evidence ?reviewing_department - reviewing_department ?supporting_document - supporting_document)
    (originating_department_validation_assigned ?originating_department - originating_department ?validation_check - validation_check)
    (validation_check_completed ?validation_check - validation_check)
    (validation_evidence_attached ?validation_check - validation_check)
    (originating_department_ready ?originating_department - originating_department)
    (reviewing_department_regulatory_assigned ?reviewing_department - reviewing_department ?regulatory_check - regulatory_check)
    (regulatory_check_completed ?regulatory_check - regulatory_check)
    (regulatory_evidence_attached ?regulatory_check - regulatory_check)
    (reviewing_department_ready ?reviewing_department - reviewing_department)
    (review_package_draft ?review_package - review_package)
    (review_package_submitted ?review_package - review_package)
    (package_validation_linked ?review_package - review_package ?validation_check - validation_check)
    (package_regulatory_linked ?review_package - review_package ?regulatory_check - regulatory_check)
    (package_includes_validation_evidence ?review_package - review_package)
    (package_includes_regulatory_evidence ?review_package - review_package)
    (package_quality_gate_passed ?review_package - review_package)
    (document_originating_department_link ?controlled_document - controlled_document ?originating_department - originating_department)
    (document_reviewing_department_link ?controlled_document - controlled_document ?reviewing_department - reviewing_department)
    (document_in_review_package ?controlled_document - controlled_document ?review_package - review_package)
    (evidence_document_available ?evidence_document - evidence_document)
    (document_has_evidence_document ?controlled_document - controlled_document ?evidence_document - evidence_document)
    (evidence_document_integrated ?evidence_document - evidence_document)
    (evidence_document_linked_to_package ?evidence_document - evidence_document ?review_package - review_package)
    (document_evidence_integrated ?controlled_document - controlled_document)
    (document_approval_protocol_attached ?controlled_document - controlled_document)
    (document_ready_for_signoff ?controlled_document - controlled_document)
    (regulatory_checklist_attached ?controlled_document - controlled_document)
    (document_checklist_reviewed ?controlled_document - controlled_document)
    (document_domain_endorsement ?controlled_document - controlled_document)
    (document_crossfunctional_checks_complete ?controlled_document - controlled_document)
    (risk_assessment_available ?risk_assessment - risk_assessment)
    (document_has_risk_assessment ?controlled_document - controlled_document ?risk_assessment - risk_assessment)
    (document_risk_assessment_acknowledged ?controlled_document - controlled_document)
    (document_approval_initiated ?controlled_document - controlled_document)
    (document_approval_completed ?controlled_document - controlled_document)
    (regulatory_checklist_available ?regulatory_checklist - regulatory_checklist)
    (document_regulatory_checklist_bound ?controlled_document - controlled_document ?regulatory_checklist - regulatory_checklist)
    (domain_representative_available ?domain_representative - domain_representative)
    (document_domain_representative_assigned ?controlled_document - controlled_document ?domain_representative - domain_representative)
    (validation_protocol_available ?validation_protocol - validation_protocol)
    (document_validation_protocol_attached ?controlled_document - controlled_document ?validation_protocol - validation_protocol)
    (audit_finding_available ?audit_finding - audit_finding)
    (document_audit_finding_linked ?controlled_document - controlled_document ?audit_finding - audit_finding)
    (regulatory_escalation_notice_available ?regulatory_escalation_notice - regulatory_escalation_notice)
    (escalation_notice_linked ?data_integrity_review_case - data_integrity_review_case ?regulatory_escalation_notice - regulatory_escalation_notice)
    (originating_department_validation_performed ?originating_department - originating_department)
    (reviewing_department_validation_performed ?reviewing_department - reviewing_department)
    (document_final_signoff_recorded ?controlled_document - controlled_document)
  )
  (:action create_data_integrity_case
    :parameters (?data_integrity_review_case - data_integrity_review_case)
    :precondition
      (and
        (not
          (triaged ?data_integrity_review_case)
        )
        (not
          (finalized ?data_integrity_review_case)
        )
      )
    :effect (triaged ?data_integrity_review_case)
  )
  (:action assign_quality_reviewer_to_case
    :parameters (?data_integrity_review_case - data_integrity_review_case ?quality_reviewer - quality_reviewer)
    :precondition
      (and
        (triaged ?data_integrity_review_case)
        (not
          (quality_reviewer_engaged ?data_integrity_review_case)
        )
        (quality_reviewer_available ?quality_reviewer)
      )
    :effect
      (and
        (quality_reviewer_engaged ?data_integrity_review_case)
        (quality_reviewer_assigned ?data_integrity_review_case ?quality_reviewer)
        (not
          (quality_reviewer_available ?quality_reviewer)
        )
      )
  )
  (:action assign_sme_to_case
    :parameters (?data_integrity_review_case - data_integrity_review_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (triaged ?data_integrity_review_case)
        (quality_reviewer_engaged ?data_integrity_review_case)
        (subject_matter_expert_available ?subject_matter_expert)
      )
    :effect
      (and
        (subject_matter_expert_assigned ?data_integrity_review_case ?subject_matter_expert)
        (not
          (subject_matter_expert_available ?subject_matter_expert)
        )
      )
  )
  (:action confirm_sme_engagement
    :parameters (?data_integrity_review_case - data_integrity_review_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (triaged ?data_integrity_review_case)
        (quality_reviewer_engaged ?data_integrity_review_case)
        (subject_matter_expert_assigned ?data_integrity_review_case ?subject_matter_expert)
        (not
          (subject_matter_expert_review_completed ?data_integrity_review_case)
        )
      )
    :effect (subject_matter_expert_review_completed ?data_integrity_review_case)
  )
  (:action release_sme_from_case
    :parameters (?data_integrity_review_case - data_integrity_review_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (subject_matter_expert_assigned ?data_integrity_review_case ?subject_matter_expert)
      )
    :effect
      (and
        (subject_matter_expert_available ?subject_matter_expert)
        (not
          (subject_matter_expert_assigned ?data_integrity_review_case ?subject_matter_expert)
        )
      )
  )
  (:action assign_functional_approver_to_case
    :parameters (?data_integrity_review_case - data_integrity_review_case ?functional_approver - functional_approver)
    :precondition
      (and
        (subject_matter_expert_review_completed ?data_integrity_review_case)
        (approver_available ?functional_approver)
      )
    :effect
      (and
        (functional_approver_assigned ?data_integrity_review_case ?functional_approver)
        (not
          (approver_available ?functional_approver)
        )
      )
  )
  (:action release_functional_approver_from_case
    :parameters (?data_integrity_review_case - data_integrity_review_case ?functional_approver - functional_approver)
    :precondition
      (and
        (functional_approver_assigned ?data_integrity_review_case ?functional_approver)
      )
    :effect
      (and
        (approver_available ?functional_approver)
        (not
          (functional_approver_assigned ?data_integrity_review_case ?functional_approver)
        )
      )
  )
  (:action attach_validation_protocol_to_document
    :parameters (?controlled_document - controlled_document ?validation_protocol - validation_protocol)
    :precondition
      (and
        (subject_matter_expert_review_completed ?controlled_document)
        (validation_protocol_available ?validation_protocol)
      )
    :effect
      (and
        (document_validation_protocol_attached ?controlled_document ?validation_protocol)
        (not
          (validation_protocol_available ?validation_protocol)
        )
      )
  )
  (:action detach_validation_protocol_from_document
    :parameters (?controlled_document - controlled_document ?validation_protocol - validation_protocol)
    :precondition
      (and
        (document_validation_protocol_attached ?controlled_document ?validation_protocol)
      )
    :effect
      (and
        (validation_protocol_available ?validation_protocol)
        (not
          (document_validation_protocol_attached ?controlled_document ?validation_protocol)
        )
      )
  )
  (:action attach_audit_finding_to_document
    :parameters (?controlled_document - controlled_document ?audit_finding - audit_finding)
    :precondition
      (and
        (subject_matter_expert_review_completed ?controlled_document)
        (audit_finding_available ?audit_finding)
      )
    :effect
      (and
        (document_audit_finding_linked ?controlled_document ?audit_finding)
        (not
          (audit_finding_available ?audit_finding)
        )
      )
  )
  (:action detach_audit_finding_from_document
    :parameters (?controlled_document - controlled_document ?audit_finding - audit_finding)
    :precondition
      (and
        (document_audit_finding_linked ?controlled_document ?audit_finding)
      )
    :effect
      (and
        (audit_finding_available ?audit_finding)
        (not
          (document_audit_finding_linked ?controlled_document ?audit_finding)
        )
      )
  )
  (:action initiate_department_validation_check
    :parameters (?originating_department - originating_department ?validation_check - validation_check ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (subject_matter_expert_review_completed ?originating_department)
        (subject_matter_expert_assigned ?originating_department ?subject_matter_expert)
        (originating_department_validation_assigned ?originating_department ?validation_check)
        (not
          (validation_check_completed ?validation_check)
        )
        (not
          (validation_evidence_attached ?validation_check)
        )
      )
    :effect (validation_check_completed ?validation_check)
  )
  (:action record_department_validation_and_mark_ready
    :parameters (?originating_department - originating_department ?validation_check - validation_check ?functional_approver - functional_approver)
    :precondition
      (and
        (subject_matter_expert_review_completed ?originating_department)
        (functional_approver_assigned ?originating_department ?functional_approver)
        (originating_department_validation_assigned ?originating_department ?validation_check)
        (validation_check_completed ?validation_check)
        (not
          (originating_department_validation_performed ?originating_department)
        )
      )
    :effect
      (and
        (originating_department_validation_performed ?originating_department)
        (originating_department_ready ?originating_department)
      )
  )
  (:action attach_supporting_document_and_flag_validation
    :parameters (?originating_department - originating_department ?validation_check - validation_check ?supporting_document - supporting_document)
    :precondition
      (and
        (subject_matter_expert_review_completed ?originating_department)
        (originating_department_validation_assigned ?originating_department ?validation_check)
        (supporting_document_available ?supporting_document)
        (not
          (originating_department_validation_performed ?originating_department)
        )
      )
    :effect
      (and
        (validation_evidence_attached ?validation_check)
        (originating_department_validation_performed ?originating_department)
        (originating_department_attached_evidence ?originating_department ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_validation_and_release_evidence
    :parameters (?originating_department - originating_department ?validation_check - validation_check ?subject_matter_expert - subject_matter_expert ?supporting_document - supporting_document)
    :precondition
      (and
        (subject_matter_expert_review_completed ?originating_department)
        (subject_matter_expert_assigned ?originating_department ?subject_matter_expert)
        (originating_department_validation_assigned ?originating_department ?validation_check)
        (validation_evidence_attached ?validation_check)
        (originating_department_attached_evidence ?originating_department ?supporting_document)
        (not
          (originating_department_ready ?originating_department)
        )
      )
    :effect
      (and
        (validation_check_completed ?validation_check)
        (originating_department_ready ?originating_department)
        (supporting_document_available ?supporting_document)
        (not
          (originating_department_attached_evidence ?originating_department ?supporting_document)
        )
      )
  )
  (:action initiate_reviewing_department_validation_check
    :parameters (?reviewing_department - reviewing_department ?regulatory_check - regulatory_check ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (subject_matter_expert_review_completed ?reviewing_department)
        (subject_matter_expert_assigned ?reviewing_department ?subject_matter_expert)
        (reviewing_department_regulatory_assigned ?reviewing_department ?regulatory_check)
        (not
          (regulatory_check_completed ?regulatory_check)
        )
        (not
          (regulatory_evidence_attached ?regulatory_check)
        )
      )
    :effect (regulatory_check_completed ?regulatory_check)
  )
  (:action record_reviewing_department_validation_and_mark_ready
    :parameters (?reviewing_department - reviewing_department ?regulatory_check - regulatory_check ?functional_approver - functional_approver)
    :precondition
      (and
        (subject_matter_expert_review_completed ?reviewing_department)
        (functional_approver_assigned ?reviewing_department ?functional_approver)
        (reviewing_department_regulatory_assigned ?reviewing_department ?regulatory_check)
        (regulatory_check_completed ?regulatory_check)
        (not
          (reviewing_department_validation_performed ?reviewing_department)
        )
      )
    :effect
      (and
        (reviewing_department_validation_performed ?reviewing_department)
        (reviewing_department_ready ?reviewing_department)
      )
  )
  (:action attach_supporting_document_to_reviewing_department_validation
    :parameters (?reviewing_department - reviewing_department ?regulatory_check - regulatory_check ?supporting_document - supporting_document)
    :precondition
      (and
        (subject_matter_expert_review_completed ?reviewing_department)
        (reviewing_department_regulatory_assigned ?reviewing_department ?regulatory_check)
        (supporting_document_available ?supporting_document)
        (not
          (reviewing_department_validation_performed ?reviewing_department)
        )
      )
    :effect
      (and
        (regulatory_evidence_attached ?regulatory_check)
        (reviewing_department_validation_performed ?reviewing_department)
        (reviewing_department_attached_evidence ?reviewing_department ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_reviewing_department_validation_and_release_evidence
    :parameters (?reviewing_department - reviewing_department ?regulatory_check - regulatory_check ?subject_matter_expert - subject_matter_expert ?supporting_document - supporting_document)
    :precondition
      (and
        (subject_matter_expert_review_completed ?reviewing_department)
        (subject_matter_expert_assigned ?reviewing_department ?subject_matter_expert)
        (reviewing_department_regulatory_assigned ?reviewing_department ?regulatory_check)
        (regulatory_evidence_attached ?regulatory_check)
        (reviewing_department_attached_evidence ?reviewing_department ?supporting_document)
        (not
          (reviewing_department_ready ?reviewing_department)
        )
      )
    :effect
      (and
        (regulatory_check_completed ?regulatory_check)
        (reviewing_department_ready ?reviewing_department)
        (supporting_document_available ?supporting_document)
        (not
          (reviewing_department_attached_evidence ?reviewing_department ?supporting_document)
        )
      )
  )
  (:action assemble_review_package_standard
    :parameters (?originating_department - originating_department ?reviewing_department - reviewing_department ?validation_check - validation_check ?regulatory_check - regulatory_check ?review_package - review_package)
    :precondition
      (and
        (originating_department_validation_performed ?originating_department)
        (reviewing_department_validation_performed ?reviewing_department)
        (originating_department_validation_assigned ?originating_department ?validation_check)
        (reviewing_department_regulatory_assigned ?reviewing_department ?regulatory_check)
        (validation_check_completed ?validation_check)
        (regulatory_check_completed ?regulatory_check)
        (originating_department_ready ?originating_department)
        (reviewing_department_ready ?reviewing_department)
        (review_package_draft ?review_package)
      )
    :effect
      (and
        (review_package_submitted ?review_package)
        (package_validation_linked ?review_package ?validation_check)
        (package_regulatory_linked ?review_package ?regulatory_check)
        (not
          (review_package_draft ?review_package)
        )
      )
  )
  (:action assemble_review_package_with_validation_evidence
    :parameters (?originating_department - originating_department ?reviewing_department - reviewing_department ?validation_check - validation_check ?regulatory_check - regulatory_check ?review_package - review_package)
    :precondition
      (and
        (originating_department_validation_performed ?originating_department)
        (reviewing_department_validation_performed ?reviewing_department)
        (originating_department_validation_assigned ?originating_department ?validation_check)
        (reviewing_department_regulatory_assigned ?reviewing_department ?regulatory_check)
        (validation_evidence_attached ?validation_check)
        (regulatory_check_completed ?regulatory_check)
        (not
          (originating_department_ready ?originating_department)
        )
        (reviewing_department_ready ?reviewing_department)
        (review_package_draft ?review_package)
      )
    :effect
      (and
        (review_package_submitted ?review_package)
        (package_validation_linked ?review_package ?validation_check)
        (package_regulatory_linked ?review_package ?regulatory_check)
        (package_includes_validation_evidence ?review_package)
        (not
          (review_package_draft ?review_package)
        )
      )
  )
  (:action assemble_review_package_with_regulatory_evidence
    :parameters (?originating_department - originating_department ?reviewing_department - reviewing_department ?validation_check - validation_check ?regulatory_check - regulatory_check ?review_package - review_package)
    :precondition
      (and
        (originating_department_validation_performed ?originating_department)
        (reviewing_department_validation_performed ?reviewing_department)
        (originating_department_validation_assigned ?originating_department ?validation_check)
        (reviewing_department_regulatory_assigned ?reviewing_department ?regulatory_check)
        (validation_check_completed ?validation_check)
        (regulatory_evidence_attached ?regulatory_check)
        (originating_department_ready ?originating_department)
        (not
          (reviewing_department_ready ?reviewing_department)
        )
        (review_package_draft ?review_package)
      )
    :effect
      (and
        (review_package_submitted ?review_package)
        (package_validation_linked ?review_package ?validation_check)
        (package_regulatory_linked ?review_package ?regulatory_check)
        (package_includes_regulatory_evidence ?review_package)
        (not
          (review_package_draft ?review_package)
        )
      )
  )
  (:action assemble_review_package_with_both_evidence_types
    :parameters (?originating_department - originating_department ?reviewing_department - reviewing_department ?validation_check - validation_check ?regulatory_check - regulatory_check ?review_package - review_package)
    :precondition
      (and
        (originating_department_validation_performed ?originating_department)
        (reviewing_department_validation_performed ?reviewing_department)
        (originating_department_validation_assigned ?originating_department ?validation_check)
        (reviewing_department_regulatory_assigned ?reviewing_department ?regulatory_check)
        (validation_evidence_attached ?validation_check)
        (regulatory_evidence_attached ?regulatory_check)
        (not
          (originating_department_ready ?originating_department)
        )
        (not
          (reviewing_department_ready ?reviewing_department)
        )
        (review_package_draft ?review_package)
      )
    :effect
      (and
        (review_package_submitted ?review_package)
        (package_validation_linked ?review_package ?validation_check)
        (package_regulatory_linked ?review_package ?regulatory_check)
        (package_includes_validation_evidence ?review_package)
        (package_includes_regulatory_evidence ?review_package)
        (not
          (review_package_draft ?review_package)
        )
      )
  )
  (:action apply_package_quality_gate
    :parameters (?review_package - review_package ?originating_department - originating_department ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (review_package_submitted ?review_package)
        (originating_department_validation_performed ?originating_department)
        (subject_matter_expert_assigned ?originating_department ?subject_matter_expert)
        (not
          (package_quality_gate_passed ?review_package)
        )
      )
    :effect (package_quality_gate_passed ?review_package)
  )
  (:action integrate_evidence_into_document_and_link_to_package
    :parameters (?controlled_document - controlled_document ?evidence_document - evidence_document ?review_package - review_package)
    :precondition
      (and
        (subject_matter_expert_review_completed ?controlled_document)
        (document_in_review_package ?controlled_document ?review_package)
        (document_has_evidence_document ?controlled_document ?evidence_document)
        (evidence_document_available ?evidence_document)
        (review_package_submitted ?review_package)
        (package_quality_gate_passed ?review_package)
        (not
          (evidence_document_integrated ?evidence_document)
        )
      )
    :effect
      (and
        (evidence_document_integrated ?evidence_document)
        (evidence_document_linked_to_package ?evidence_document ?review_package)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action finalize_document_integration_and_mark_ready
    :parameters (?controlled_document - controlled_document ?evidence_document - evidence_document ?review_package - review_package ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (subject_matter_expert_review_completed ?controlled_document)
        (document_has_evidence_document ?controlled_document ?evidence_document)
        (evidence_document_integrated ?evidence_document)
        (evidence_document_linked_to_package ?evidence_document ?review_package)
        (subject_matter_expert_assigned ?controlled_document ?subject_matter_expert)
        (not
          (package_includes_validation_evidence ?review_package)
        )
        (not
          (document_evidence_integrated ?controlled_document)
        )
      )
    :effect (document_evidence_integrated ?controlled_document)
  )
  (:action bind_regulatory_checklist_to_document
    :parameters (?controlled_document - controlled_document ?regulatory_checklist - regulatory_checklist)
    :precondition
      (and
        (subject_matter_expert_review_completed ?controlled_document)
        (regulatory_checklist_available ?regulatory_checklist)
        (not
          (regulatory_checklist_attached ?controlled_document)
        )
      )
    :effect
      (and
        (regulatory_checklist_attached ?controlled_document)
        (document_regulatory_checklist_bound ?controlled_document ?regulatory_checklist)
        (not
          (regulatory_checklist_available ?regulatory_checklist)
        )
      )
  )
  (:action apply_checklist_and_prepare_document_for_domain_review
    :parameters (?controlled_document - controlled_document ?evidence_document - evidence_document ?review_package - review_package ?subject_matter_expert - subject_matter_expert ?regulatory_checklist - regulatory_checklist)
    :precondition
      (and
        (subject_matter_expert_review_completed ?controlled_document)
        (document_has_evidence_document ?controlled_document ?evidence_document)
        (evidence_document_integrated ?evidence_document)
        (evidence_document_linked_to_package ?evidence_document ?review_package)
        (subject_matter_expert_assigned ?controlled_document ?subject_matter_expert)
        (package_includes_validation_evidence ?review_package)
        (regulatory_checklist_attached ?controlled_document)
        (document_regulatory_checklist_bound ?controlled_document ?regulatory_checklist)
        (not
          (document_evidence_integrated ?controlled_document)
        )
      )
    :effect
      (and
        (document_evidence_integrated ?controlled_document)
        (document_checklist_reviewed ?controlled_document)
      )
  )
  (:action start_functional_approval_path_a
    :parameters (?controlled_document - controlled_document ?validation_protocol - validation_protocol ?functional_approver - functional_approver ?evidence_document - evidence_document ?review_package - review_package)
    :precondition
      (and
        (document_evidence_integrated ?controlled_document)
        (document_validation_protocol_attached ?controlled_document ?validation_protocol)
        (functional_approver_assigned ?controlled_document ?functional_approver)
        (document_has_evidence_document ?controlled_document ?evidence_document)
        (evidence_document_linked_to_package ?evidence_document ?review_package)
        (not
          (package_includes_regulatory_evidence ?review_package)
        )
        (not
          (document_approval_protocol_attached ?controlled_document)
        )
      )
    :effect (document_approval_protocol_attached ?controlled_document)
  )
  (:action start_functional_approval_path_b
    :parameters (?controlled_document - controlled_document ?validation_protocol - validation_protocol ?functional_approver - functional_approver ?evidence_document - evidence_document ?review_package - review_package)
    :precondition
      (and
        (document_evidence_integrated ?controlled_document)
        (document_validation_protocol_attached ?controlled_document ?validation_protocol)
        (functional_approver_assigned ?controlled_document ?functional_approver)
        (document_has_evidence_document ?controlled_document ?evidence_document)
        (evidence_document_linked_to_package ?evidence_document ?review_package)
        (package_includes_regulatory_evidence ?review_package)
        (not
          (document_approval_protocol_attached ?controlled_document)
        )
      )
    :effect (document_approval_protocol_attached ?controlled_document)
  )
  (:action record_prerequisite_checks_and_prepare_for_approval
    :parameters (?controlled_document - controlled_document ?audit_finding - audit_finding ?evidence_document - evidence_document ?review_package - review_package)
    :precondition
      (and
        (document_approval_protocol_attached ?controlled_document)
        (document_audit_finding_linked ?controlled_document ?audit_finding)
        (document_has_evidence_document ?controlled_document ?evidence_document)
        (evidence_document_linked_to_package ?evidence_document ?review_package)
        (not
          (package_includes_validation_evidence ?review_package)
        )
        (not
          (package_includes_regulatory_evidence ?review_package)
        )
        (not
          (document_ready_for_signoff ?controlled_document)
        )
      )
    :effect (document_ready_for_signoff ?controlled_document)
  )
  (:action record_prerequisite_checks_and_prepare_with_followup
    :parameters (?controlled_document - controlled_document ?audit_finding - audit_finding ?evidence_document - evidence_document ?review_package - review_package)
    :precondition
      (and
        (document_approval_protocol_attached ?controlled_document)
        (document_audit_finding_linked ?controlled_document ?audit_finding)
        (document_has_evidence_document ?controlled_document ?evidence_document)
        (evidence_document_linked_to_package ?evidence_document ?review_package)
        (package_includes_validation_evidence ?review_package)
        (not
          (package_includes_regulatory_evidence ?review_package)
        )
        (not
          (document_ready_for_signoff ?controlled_document)
        )
      )
    :effect
      (and
        (document_ready_for_signoff ?controlled_document)
        (document_domain_endorsement ?controlled_document)
      )
  )
  (:action finalize_prerequisite_checks_and_prepare_with_followup
    :parameters (?controlled_document - controlled_document ?audit_finding - audit_finding ?evidence_document - evidence_document ?review_package - review_package)
    :precondition
      (and
        (document_approval_protocol_attached ?controlled_document)
        (document_audit_finding_linked ?controlled_document ?audit_finding)
        (document_has_evidence_document ?controlled_document ?evidence_document)
        (evidence_document_linked_to_package ?evidence_document ?review_package)
        (not
          (package_includes_validation_evidence ?review_package)
        )
        (package_includes_regulatory_evidence ?review_package)
        (not
          (document_ready_for_signoff ?controlled_document)
        )
      )
    :effect
      (and
        (document_ready_for_signoff ?controlled_document)
        (document_domain_endorsement ?controlled_document)
      )
  )
  (:action finalize_prerequisite_checks_and_prepare_with_both
    :parameters (?controlled_document - controlled_document ?audit_finding - audit_finding ?evidence_document - evidence_document ?review_package - review_package)
    :precondition
      (and
        (document_approval_protocol_attached ?controlled_document)
        (document_audit_finding_linked ?controlled_document ?audit_finding)
        (document_has_evidence_document ?controlled_document ?evidence_document)
        (evidence_document_linked_to_package ?evidence_document ?review_package)
        (package_includes_validation_evidence ?review_package)
        (package_includes_regulatory_evidence ?review_package)
        (not
          (document_ready_for_signoff ?controlled_document)
        )
      )
    :effect
      (and
        (document_ready_for_signoff ?controlled_document)
        (document_domain_endorsement ?controlled_document)
      )
  )
  (:action finalize_document_preapproval_and_set_release_ready
    :parameters (?controlled_document - controlled_document)
    :precondition
      (and
        (document_ready_for_signoff ?controlled_document)
        (not
          (document_domain_endorsement ?controlled_document)
        )
        (not
          (document_final_signoff_recorded ?controlled_document)
        )
      )
    :effect
      (and
        (document_final_signoff_recorded ?controlled_document)
        (release_authorized ?controlled_document)
      )
  )
  (:action assign_domain_representative_to_document
    :parameters (?controlled_document - controlled_document ?domain_representative - domain_representative)
    :precondition
      (and
        (document_ready_for_signoff ?controlled_document)
        (document_domain_endorsement ?controlled_document)
        (domain_representative_available ?domain_representative)
      )
    :effect
      (and
        (document_domain_representative_assigned ?controlled_document ?domain_representative)
        (not
          (domain_representative_available ?domain_representative)
        )
      )
  )
  (:action execute_domain_endorsements_and_mark_document_ready
    :parameters (?controlled_document - controlled_document ?originating_department - originating_department ?reviewing_department - reviewing_department ?subject_matter_expert - subject_matter_expert ?domain_representative - domain_representative)
    :precondition
      (and
        (document_ready_for_signoff ?controlled_document)
        (document_domain_endorsement ?controlled_document)
        (document_domain_representative_assigned ?controlled_document ?domain_representative)
        (document_originating_department_link ?controlled_document ?originating_department)
        (document_reviewing_department_link ?controlled_document ?reviewing_department)
        (originating_department_ready ?originating_department)
        (reviewing_department_ready ?reviewing_department)
        (subject_matter_expert_assigned ?controlled_document ?subject_matter_expert)
        (not
          (document_crossfunctional_checks_complete ?controlled_document)
        )
      )
    :effect (document_crossfunctional_checks_complete ?controlled_document)
  )
  (:action complete_document_signoff_path_and_authorize_release
    :parameters (?controlled_document - controlled_document)
    :precondition
      (and
        (document_ready_for_signoff ?controlled_document)
        (document_crossfunctional_checks_complete ?controlled_document)
        (not
          (document_final_signoff_recorded ?controlled_document)
        )
      )
    :effect
      (and
        (document_final_signoff_recorded ?controlled_document)
        (release_authorized ?controlled_document)
      )
  )
  (:action acknowledge_risk_assessment_and_mark_document
    :parameters (?controlled_document - controlled_document ?risk_assessment - risk_assessment ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (subject_matter_expert_review_completed ?controlled_document)
        (subject_matter_expert_assigned ?controlled_document ?subject_matter_expert)
        (risk_assessment_available ?risk_assessment)
        (document_has_risk_assessment ?controlled_document ?risk_assessment)
        (not
          (document_risk_assessment_acknowledged ?controlled_document)
        )
      )
    :effect
      (and
        (document_risk_assessment_acknowledged ?controlled_document)
        (not
          (risk_assessment_available ?risk_assessment)
        )
      )
  )
  (:action initiate_document_approval
    :parameters (?controlled_document - controlled_document ?functional_approver - functional_approver)
    :precondition
      (and
        (document_risk_assessment_acknowledged ?controlled_document)
        (functional_approver_assigned ?controlled_document ?functional_approver)
        (not
          (document_approval_initiated ?controlled_document)
        )
      )
    :effect (document_approval_initiated ?controlled_document)
  )
  (:action record_document_approval_step
    :parameters (?controlled_document - controlled_document ?audit_finding - audit_finding)
    :precondition
      (and
        (document_approval_initiated ?controlled_document)
        (document_audit_finding_linked ?controlled_document ?audit_finding)
        (not
          (document_approval_completed ?controlled_document)
        )
      )
    :effect (document_approval_completed ?controlled_document)
  )
  (:action complete_document_approval_and_authorize_release
    :parameters (?controlled_document - controlled_document)
    :precondition
      (and
        (document_approval_completed ?controlled_document)
        (not
          (document_final_signoff_recorded ?controlled_document)
        )
      )
    :effect
      (and
        (document_final_signoff_recorded ?controlled_document)
        (release_authorized ?controlled_document)
      )
  )
  (:action authorize_release_for_originating_department_via_package
    :parameters (?originating_department - originating_department ?review_package - review_package)
    :precondition
      (and
        (originating_department_validation_performed ?originating_department)
        (originating_department_ready ?originating_department)
        (review_package_submitted ?review_package)
        (package_quality_gate_passed ?review_package)
        (not
          (release_authorized ?originating_department)
        )
      )
    :effect (release_authorized ?originating_department)
  )
  (:action authorize_release_for_reviewing_department_via_package
    :parameters (?reviewing_department - reviewing_department ?review_package - review_package)
    :precondition
      (and
        (reviewing_department_validation_performed ?reviewing_department)
        (reviewing_department_ready ?reviewing_department)
        (review_package_submitted ?review_package)
        (package_quality_gate_passed ?review_package)
        (not
          (release_authorized ?reviewing_department)
        )
      )
    :effect (release_authorized ?reviewing_department)
  )
  (:action escalate_case_and_record_notice
    :parameters (?data_integrity_review_case - data_integrity_review_case ?regulatory_escalation_notice - regulatory_escalation_notice ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (release_authorized ?data_integrity_review_case)
        (subject_matter_expert_assigned ?data_integrity_review_case ?subject_matter_expert)
        (regulatory_escalation_notice_available ?regulatory_escalation_notice)
        (not
          (escalated ?data_integrity_review_case)
        )
      )
    :effect
      (and
        (escalated ?data_integrity_review_case)
        (escalation_notice_linked ?data_integrity_review_case ?regulatory_escalation_notice)
        (not
          (regulatory_escalation_notice_available ?regulatory_escalation_notice)
        )
      )
  )
  (:action final_route_case_from_originating_department
    :parameters (?originating_department - originating_department ?quality_reviewer - quality_reviewer ?regulatory_escalation_notice - regulatory_escalation_notice)
    :precondition
      (and
        (escalated ?originating_department)
        (quality_reviewer_assigned ?originating_department ?quality_reviewer)
        (escalation_notice_linked ?originating_department ?regulatory_escalation_notice)
        (not
          (finalized ?originating_department)
        )
      )
    :effect
      (and
        (finalized ?originating_department)
        (quality_reviewer_available ?quality_reviewer)
        (regulatory_escalation_notice_available ?regulatory_escalation_notice)
      )
  )
  (:action final_route_case_from_reviewing_department
    :parameters (?reviewing_department - reviewing_department ?quality_reviewer - quality_reviewer ?regulatory_escalation_notice - regulatory_escalation_notice)
    :precondition
      (and
        (escalated ?reviewing_department)
        (quality_reviewer_assigned ?reviewing_department ?quality_reviewer)
        (escalation_notice_linked ?reviewing_department ?regulatory_escalation_notice)
        (not
          (finalized ?reviewing_department)
        )
      )
    :effect
      (and
        (finalized ?reviewing_department)
        (quality_reviewer_available ?quality_reviewer)
        (regulatory_escalation_notice_available ?regulatory_escalation_notice)
      )
  )
  (:action final_route_case_from_controlled_document
    :parameters (?controlled_document - controlled_document ?quality_reviewer - quality_reviewer ?regulatory_escalation_notice - regulatory_escalation_notice)
    :precondition
      (and
        (escalated ?controlled_document)
        (quality_reviewer_assigned ?controlled_document ?quality_reviewer)
        (escalation_notice_linked ?controlled_document ?regulatory_escalation_notice)
        (not
          (finalized ?controlled_document)
        )
      )
    :effect
      (and
        (finalized ?controlled_document)
        (quality_reviewer_available ?quality_reviewer)
        (regulatory_escalation_notice_available ?regulatory_escalation_notice)
      )
  )
)

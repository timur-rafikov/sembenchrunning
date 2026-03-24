(define (domain pharmaceutics_cleaning_validation)
  (:requirements :strips :typing :negative-preconditions)
  (:types validation_entity - object evidence_asset - object sampling_artifact - object validation_case_root - object cleaning_validation_case - validation_case_root reviewer - validation_entity laboratory_analyst - validation_entity quality_approver - validation_entity change_request - validation_entity technical_review - validation_entity regulatory_marker - validation_entity analytical_method - validation_entity compliance_attachment - validation_entity sample_result - evidence_asset sample_set - evidence_asset external_approval - evidence_asset equipment_sampling_site - sampling_artifact area_sampling_site - sampling_artifact evidence_package - sampling_artifact equipment_category - cleaning_validation_case protocol_category - cleaning_validation_case equipment_case - equipment_category area_case - equipment_category validation_protocol - protocol_category)
  (:predicates
    (validation_opened ?validation_case - cleaning_validation_case)
    (validation_entity_activated ?validation_case - cleaning_validation_case)
    (validation_reviewer_assigned ?validation_case - cleaning_validation_case)
    (validation_completed ?validation_case - cleaning_validation_case)
    (validation_entity_qa_approved ?validation_case - cleaning_validation_case)
    (regulatory_marker_linked ?validation_case - cleaning_validation_case)
    (reviewer_available ?reviewer - reviewer)
    (assigned_reviewer ?validation_case - cleaning_validation_case ?reviewer - reviewer)
    (analyst_available ?lab_analyst - laboratory_analyst)
    (assigned_analyst ?validation_case - cleaning_validation_case ?lab_analyst - laboratory_analyst)
    (approver_available ?qa_approver - quality_approver)
    (assigned_approver ?validation_case - cleaning_validation_case ?qa_approver - quality_approver)
    (sample_result_available ?sample_result - sample_result)
    (equipment_sample_attached ?equipment_case - equipment_case ?sample_result - sample_result)
    (area_sample_attached ?area_case - area_case ?sample_result - sample_result)
    (equipment_has_site ?equipment_case - equipment_case ?equipment_site - equipment_sampling_site)
    (site_ready ?equipment_site - equipment_sampling_site)
    (site_sample_collected ?equipment_site - equipment_sampling_site)
    (equipment_sampling_validated ?equipment_case - equipment_case)
    (area_has_site ?area_case - area_case ?area_site - area_sampling_site)
    (area_site_ready ?area_site - area_sampling_site)
    (area_site_sample_collected ?area_site - area_sampling_site)
    (area_sampling_validated ?area_case - area_case)
    (evidence_package_unassigned ?evidence_package - evidence_package)
    (evidence_package_ready ?evidence_package - evidence_package)
    (package_linked_equipment_site ?evidence_package - evidence_package ?equipment_site - equipment_sampling_site)
    (package_linked_area_site ?evidence_package - evidence_package ?area_site - area_sampling_site)
    (package_equipment_site_verified ?evidence_package - evidence_package)
    (package_area_site_verified ?evidence_package - evidence_package)
    (package_locked ?evidence_package - evidence_package)
    (protocol_for_equipment ?protocol - validation_protocol ?equipment_case - equipment_case)
    (protocol_for_area ?protocol - validation_protocol ?area_case - area_case)
    (protocol_evidence_linked ?protocol - validation_protocol ?evidence_package - evidence_package)
    (sample_set_available ?sample_set - sample_set)
    (protocol_sample_set_attached ?protocol - validation_protocol ?sample_set - sample_set)
    (sample_set_linked ?sample_set - sample_set)
    (sample_set_linked_to_package ?sample_set - sample_set ?evidence_package - evidence_package)
    (protocol_resources_allocated ?protocol - validation_protocol)
    (protocol_review_ready ?protocol - validation_protocol)
    (protocol_technical_review_complete ?protocol - validation_protocol)
    (protocol_change_attached ?protocol - validation_protocol)
    (protocol_change_reviewed ?protocol - validation_protocol)
    (protocol_review_signatures_collected ?protocol - validation_protocol)
    (protocol_documentation_finalized ?protocol - validation_protocol)
    (external_approval_available ?external_approval - external_approval)
    (protocol_external_approval_linked ?protocol - validation_protocol ?external_approval - external_approval)
    (protocol_external_approval_attached ?protocol - validation_protocol)
    (protocol_external_approval_verified ?protocol - validation_protocol)
    (protocol_external_approval_confirmed ?protocol - validation_protocol)
    (change_request_available ?change_request - change_request)
    (protocol_change_request_linked ?protocol - validation_protocol ?change_request - change_request)
    (technical_review_available ?technical_review - technical_review)
    (protocol_technical_review_attached ?protocol - validation_protocol ?technical_review - technical_review)
    (analytical_method_available ?analytical_method - analytical_method)
    (protocol_analytical_method_assigned ?protocol - validation_protocol ?analytical_method - analytical_method)
    (compliance_attachment_available ?compliance_attachment - compliance_attachment)
    (protocol_compliance_attachment_linked ?protocol - validation_protocol ?compliance_attachment - compliance_attachment)
    (regulatory_marker_available ?regulatory_marker - regulatory_marker)
    (validation_regulatory_marker_attached ?validation_case - cleaning_validation_case ?regulatory_marker - regulatory_marker)
    (equipment_samples_ready ?equipment_case - equipment_case)
    (area_samples_ready ?area_case - area_case)
    (protocol_finalized ?protocol - validation_protocol)
  )
  (:action create_cleaning_validation_case
    :parameters (?validation_case - cleaning_validation_case)
    :precondition
      (and
        (not
          (validation_opened ?validation_case)
        )
        (not
          (validation_completed ?validation_case)
        )
      )
    :effect (validation_opened ?validation_case)
  )
  (:action assign_reviewer_to_case
    :parameters (?validation_case - cleaning_validation_case ?reviewer - reviewer)
    :precondition
      (and
        (validation_opened ?validation_case)
        (not
          (validation_reviewer_assigned ?validation_case)
        )
        (reviewer_available ?reviewer)
      )
    :effect
      (and
        (validation_reviewer_assigned ?validation_case)
        (assigned_reviewer ?validation_case ?reviewer)
        (not
          (reviewer_available ?reviewer)
        )
      )
  )
  (:action assign_lab_analyst_to_case
    :parameters (?validation_case - cleaning_validation_case ?lab_analyst - laboratory_analyst)
    :precondition
      (and
        (validation_opened ?validation_case)
        (validation_reviewer_assigned ?validation_case)
        (analyst_available ?lab_analyst)
      )
    :effect
      (and
        (assigned_analyst ?validation_case ?lab_analyst)
        (not
          (analyst_available ?lab_analyst)
        )
      )
  )
  (:action activate_validation_case
    :parameters (?validation_case - cleaning_validation_case ?lab_analyst - laboratory_analyst)
    :precondition
      (and
        (validation_opened ?validation_case)
        (validation_reviewer_assigned ?validation_case)
        (assigned_analyst ?validation_case ?lab_analyst)
        (not
          (validation_entity_activated ?validation_case)
        )
      )
    :effect (validation_entity_activated ?validation_case)
  )
  (:action release_lab_analyst_from_case
    :parameters (?validation_case - cleaning_validation_case ?lab_analyst - laboratory_analyst)
    :precondition
      (and
        (assigned_analyst ?validation_case ?lab_analyst)
      )
    :effect
      (and
        (analyst_available ?lab_analyst)
        (not
          (assigned_analyst ?validation_case ?lab_analyst)
        )
      )
  )
  (:action assign_qa_approver_to_case
    :parameters (?validation_case - cleaning_validation_case ?qa_approver - quality_approver)
    :precondition
      (and
        (validation_entity_activated ?validation_case)
        (approver_available ?qa_approver)
      )
    :effect
      (and
        (assigned_approver ?validation_case ?qa_approver)
        (not
          (approver_available ?qa_approver)
        )
      )
  )
  (:action release_qa_approver_from_case
    :parameters (?validation_case - cleaning_validation_case ?qa_approver - quality_approver)
    :precondition
      (and
        (assigned_approver ?validation_case ?qa_approver)
      )
    :effect
      (and
        (approver_available ?qa_approver)
        (not
          (assigned_approver ?validation_case ?qa_approver)
        )
      )
  )
  (:action assign_analytical_method_to_protocol
    :parameters (?protocol - validation_protocol ?analytical_method - analytical_method)
    :precondition
      (and
        (validation_entity_activated ?protocol)
        (analytical_method_available ?analytical_method)
      )
    :effect
      (and
        (protocol_analytical_method_assigned ?protocol ?analytical_method)
        (not
          (analytical_method_available ?analytical_method)
        )
      )
  )
  (:action unassign_analytical_method_from_protocol
    :parameters (?protocol - validation_protocol ?analytical_method - analytical_method)
    :precondition
      (and
        (protocol_analytical_method_assigned ?protocol ?analytical_method)
      )
    :effect
      (and
        (analytical_method_available ?analytical_method)
        (not
          (protocol_analytical_method_assigned ?protocol ?analytical_method)
        )
      )
  )
  (:action attach_compliance_attachment_to_protocol
    :parameters (?protocol - validation_protocol ?compliance_attachment - compliance_attachment)
    :precondition
      (and
        (validation_entity_activated ?protocol)
        (compliance_attachment_available ?compliance_attachment)
      )
    :effect
      (and
        (protocol_compliance_attachment_linked ?protocol ?compliance_attachment)
        (not
          (compliance_attachment_available ?compliance_attachment)
        )
      )
  )
  (:action detach_compliance_attachment_from_protocol
    :parameters (?protocol - validation_protocol ?compliance_attachment - compliance_attachment)
    :precondition
      (and
        (protocol_compliance_attachment_linked ?protocol ?compliance_attachment)
      )
    :effect
      (and
        (compliance_attachment_available ?compliance_attachment)
        (not
          (protocol_compliance_attachment_linked ?protocol ?compliance_attachment)
        )
      )
  )
  (:action prepare_equipment_sampling_site
    :parameters (?equipment_case - equipment_case ?equipment_site - equipment_sampling_site ?lab_analyst - laboratory_analyst)
    :precondition
      (and
        (validation_entity_activated ?equipment_case)
        (assigned_analyst ?equipment_case ?lab_analyst)
        (equipment_has_site ?equipment_case ?equipment_site)
        (not
          (site_ready ?equipment_site)
        )
        (not
          (site_sample_collected ?equipment_site)
        )
      )
    :effect (site_ready ?equipment_site)
  )
  (:action verify_equipment_sampling_site
    :parameters (?equipment_case - equipment_case ?equipment_site - equipment_sampling_site ?qa_approver - quality_approver)
    :precondition
      (and
        (validation_entity_activated ?equipment_case)
        (assigned_approver ?equipment_case ?qa_approver)
        (equipment_has_site ?equipment_case ?equipment_site)
        (site_ready ?equipment_site)
        (not
          (equipment_samples_ready ?equipment_case)
        )
      )
    :effect
      (and
        (equipment_samples_ready ?equipment_case)
        (equipment_sampling_validated ?equipment_case)
      )
  )
  (:action collect_sample_for_equipment_site
    :parameters (?equipment_case - equipment_case ?equipment_site - equipment_sampling_site ?sample_result - sample_result)
    :precondition
      (and
        (validation_entity_activated ?equipment_case)
        (equipment_has_site ?equipment_case ?equipment_site)
        (sample_result_available ?sample_result)
        (not
          (equipment_samples_ready ?equipment_case)
        )
      )
    :effect
      (and
        (site_sample_collected ?equipment_site)
        (equipment_samples_ready ?equipment_case)
        (equipment_sample_attached ?equipment_case ?sample_result)
        (not
          (sample_result_available ?sample_result)
        )
      )
  )
  (:action process_equipment_sample_result
    :parameters (?equipment_case - equipment_case ?equipment_site - equipment_sampling_site ?lab_analyst - laboratory_analyst ?sample_result - sample_result)
    :precondition
      (and
        (validation_entity_activated ?equipment_case)
        (assigned_analyst ?equipment_case ?lab_analyst)
        (equipment_has_site ?equipment_case ?equipment_site)
        (site_sample_collected ?equipment_site)
        (equipment_sample_attached ?equipment_case ?sample_result)
        (not
          (equipment_sampling_validated ?equipment_case)
        )
      )
    :effect
      (and
        (site_ready ?equipment_site)
        (equipment_sampling_validated ?equipment_case)
        (sample_result_available ?sample_result)
        (not
          (equipment_sample_attached ?equipment_case ?sample_result)
        )
      )
  )
  (:action prepare_area_sampling_site
    :parameters (?area_case - area_case ?area_site - area_sampling_site ?lab_analyst - laboratory_analyst)
    :precondition
      (and
        (validation_entity_activated ?area_case)
        (assigned_analyst ?area_case ?lab_analyst)
        (area_has_site ?area_case ?area_site)
        (not
          (area_site_ready ?area_site)
        )
        (not
          (area_site_sample_collected ?area_site)
        )
      )
    :effect (area_site_ready ?area_site)
  )
  (:action verify_area_sampling_site
    :parameters (?area_case - area_case ?area_site - area_sampling_site ?qa_approver - quality_approver)
    :precondition
      (and
        (validation_entity_activated ?area_case)
        (assigned_approver ?area_case ?qa_approver)
        (area_has_site ?area_case ?area_site)
        (area_site_ready ?area_site)
        (not
          (area_samples_ready ?area_case)
        )
      )
    :effect
      (and
        (area_samples_ready ?area_case)
        (area_sampling_validated ?area_case)
      )
  )
  (:action collect_sample_for_area_site
    :parameters (?area_case - area_case ?area_site - area_sampling_site ?sample_result - sample_result)
    :precondition
      (and
        (validation_entity_activated ?area_case)
        (area_has_site ?area_case ?area_site)
        (sample_result_available ?sample_result)
        (not
          (area_samples_ready ?area_case)
        )
      )
    :effect
      (and
        (area_site_sample_collected ?area_site)
        (area_samples_ready ?area_case)
        (area_sample_attached ?area_case ?sample_result)
        (not
          (sample_result_available ?sample_result)
        )
      )
  )
  (:action process_area_sample_result
    :parameters (?area_case - area_case ?area_site - area_sampling_site ?lab_analyst - laboratory_analyst ?sample_result - sample_result)
    :precondition
      (and
        (validation_entity_activated ?area_case)
        (assigned_analyst ?area_case ?lab_analyst)
        (area_has_site ?area_case ?area_site)
        (area_site_sample_collected ?area_site)
        (area_sample_attached ?area_case ?sample_result)
        (not
          (area_sampling_validated ?area_case)
        )
      )
    :effect
      (and
        (area_site_ready ?area_site)
        (area_sampling_validated ?area_case)
        (sample_result_available ?sample_result)
        (not
          (area_sample_attached ?area_case ?sample_result)
        )
      )
  )
  (:action assemble_evidence_package
    :parameters (?equipment_case - equipment_case ?area_case - area_case ?equipment_site - equipment_sampling_site ?area_site - area_sampling_site ?evidence_package - evidence_package)
    :precondition
      (and
        (equipment_samples_ready ?equipment_case)
        (area_samples_ready ?area_case)
        (equipment_has_site ?equipment_case ?equipment_site)
        (area_has_site ?area_case ?area_site)
        (site_ready ?equipment_site)
        (area_site_ready ?area_site)
        (equipment_sampling_validated ?equipment_case)
        (area_sampling_validated ?area_case)
        (evidence_package_unassigned ?evidence_package)
      )
    :effect
      (and
        (evidence_package_ready ?evidence_package)
        (package_linked_equipment_site ?evidence_package ?equipment_site)
        (package_linked_area_site ?evidence_package ?area_site)
        (not
          (evidence_package_unassigned ?evidence_package)
        )
      )
  )
  (:action assemble_evidence_package_set_equipment_verified
    :parameters (?equipment_case - equipment_case ?area_case - area_case ?equipment_site - equipment_sampling_site ?area_site - area_sampling_site ?evidence_package - evidence_package)
    :precondition
      (and
        (equipment_samples_ready ?equipment_case)
        (area_samples_ready ?area_case)
        (equipment_has_site ?equipment_case ?equipment_site)
        (area_has_site ?area_case ?area_site)
        (site_sample_collected ?equipment_site)
        (area_site_ready ?area_site)
        (not
          (equipment_sampling_validated ?equipment_case)
        )
        (area_sampling_validated ?area_case)
        (evidence_package_unassigned ?evidence_package)
      )
    :effect
      (and
        (evidence_package_ready ?evidence_package)
        (package_linked_equipment_site ?evidence_package ?equipment_site)
        (package_linked_area_site ?evidence_package ?area_site)
        (package_equipment_site_verified ?evidence_package)
        (not
          (evidence_package_unassigned ?evidence_package)
        )
      )
  )
  (:action assemble_evidence_package_set_area_verified
    :parameters (?equipment_case - equipment_case ?area_case - area_case ?equipment_site - equipment_sampling_site ?area_site - area_sampling_site ?evidence_package - evidence_package)
    :precondition
      (and
        (equipment_samples_ready ?equipment_case)
        (area_samples_ready ?area_case)
        (equipment_has_site ?equipment_case ?equipment_site)
        (area_has_site ?area_case ?area_site)
        (site_ready ?equipment_site)
        (area_site_sample_collected ?area_site)
        (equipment_sampling_validated ?equipment_case)
        (not
          (area_sampling_validated ?area_case)
        )
        (evidence_package_unassigned ?evidence_package)
      )
    :effect
      (and
        (evidence_package_ready ?evidence_package)
        (package_linked_equipment_site ?evidence_package ?equipment_site)
        (package_linked_area_site ?evidence_package ?area_site)
        (package_area_site_verified ?evidence_package)
        (not
          (evidence_package_unassigned ?evidence_package)
        )
      )
  )
  (:action assemble_evidence_package_set_both_verified
    :parameters (?equipment_case - equipment_case ?area_case - area_case ?equipment_site - equipment_sampling_site ?area_site - area_sampling_site ?evidence_package - evidence_package)
    :precondition
      (and
        (equipment_samples_ready ?equipment_case)
        (area_samples_ready ?area_case)
        (equipment_has_site ?equipment_case ?equipment_site)
        (area_has_site ?area_case ?area_site)
        (site_sample_collected ?equipment_site)
        (area_site_sample_collected ?area_site)
        (not
          (equipment_sampling_validated ?equipment_case)
        )
        (not
          (area_sampling_validated ?area_case)
        )
        (evidence_package_unassigned ?evidence_package)
      )
    :effect
      (and
        (evidence_package_ready ?evidence_package)
        (package_linked_equipment_site ?evidence_package ?equipment_site)
        (package_linked_area_site ?evidence_package ?area_site)
        (package_equipment_site_verified ?evidence_package)
        (package_area_site_verified ?evidence_package)
        (not
          (evidence_package_unassigned ?evidence_package)
        )
      )
  )
  (:action lock_evidence_package_for_testing
    :parameters (?evidence_package - evidence_package ?equipment_case - equipment_case ?lab_analyst - laboratory_analyst)
    :precondition
      (and
        (evidence_package_ready ?evidence_package)
        (equipment_samples_ready ?equipment_case)
        (assigned_analyst ?equipment_case ?lab_analyst)
        (not
          (package_locked ?evidence_package)
        )
      )
    :effect (package_locked ?evidence_package)
  )
  (:action stage_sample_set_to_package
    :parameters (?protocol - validation_protocol ?sample_set - sample_set ?evidence_package - evidence_package)
    :precondition
      (and
        (validation_entity_activated ?protocol)
        (protocol_evidence_linked ?protocol ?evidence_package)
        (protocol_sample_set_attached ?protocol ?sample_set)
        (sample_set_available ?sample_set)
        (evidence_package_ready ?evidence_package)
        (package_locked ?evidence_package)
        (not
          (sample_set_linked ?sample_set)
        )
      )
    :effect
      (and
        (sample_set_linked ?sample_set)
        (sample_set_linked_to_package ?sample_set ?evidence_package)
        (not
          (sample_set_available ?sample_set)
        )
      )
  )
  (:action allocate_protocol_resources
    :parameters (?protocol - validation_protocol ?sample_set - sample_set ?evidence_package - evidence_package ?lab_analyst - laboratory_analyst)
    :precondition
      (and
        (validation_entity_activated ?protocol)
        (protocol_sample_set_attached ?protocol ?sample_set)
        (sample_set_linked ?sample_set)
        (sample_set_linked_to_package ?sample_set ?evidence_package)
        (assigned_analyst ?protocol ?lab_analyst)
        (not
          (package_equipment_site_verified ?evidence_package)
        )
        (not
          (protocol_resources_allocated ?protocol)
        )
      )
    :effect (protocol_resources_allocated ?protocol)
  )
  (:action attach_change_request_to_protocol
    :parameters (?protocol - validation_protocol ?change_request - change_request)
    :precondition
      (and
        (validation_entity_activated ?protocol)
        (change_request_available ?change_request)
        (not
          (protocol_change_attached ?protocol)
        )
      )
    :effect
      (and
        (protocol_change_attached ?protocol)
        (protocol_change_request_linked ?protocol ?change_request)
        (not
          (change_request_available ?change_request)
        )
      )
  )
  (:action apply_change_request_to_protocol
    :parameters (?protocol - validation_protocol ?sample_set - sample_set ?evidence_package - evidence_package ?lab_analyst - laboratory_analyst ?change_request - change_request)
    :precondition
      (and
        (validation_entity_activated ?protocol)
        (protocol_sample_set_attached ?protocol ?sample_set)
        (sample_set_linked ?sample_set)
        (sample_set_linked_to_package ?sample_set ?evidence_package)
        (assigned_analyst ?protocol ?lab_analyst)
        (package_equipment_site_verified ?evidence_package)
        (protocol_change_attached ?protocol)
        (protocol_change_request_linked ?protocol ?change_request)
        (not
          (protocol_resources_allocated ?protocol)
        )
      )
    :effect
      (and
        (protocol_resources_allocated ?protocol)
        (protocol_change_reviewed ?protocol)
      )
  )
  (:action submit_protocol_for_review_primary
    :parameters (?protocol - validation_protocol ?analytical_method - analytical_method ?qa_approver - quality_approver ?sample_set - sample_set ?evidence_package - evidence_package)
    :precondition
      (and
        (protocol_resources_allocated ?protocol)
        (protocol_analytical_method_assigned ?protocol ?analytical_method)
        (assigned_approver ?protocol ?qa_approver)
        (protocol_sample_set_attached ?protocol ?sample_set)
        (sample_set_linked_to_package ?sample_set ?evidence_package)
        (not
          (package_area_site_verified ?evidence_package)
        )
        (not
          (protocol_review_ready ?protocol)
        )
      )
    :effect (protocol_review_ready ?protocol)
  )
  (:action submit_protocol_for_review_secondary
    :parameters (?protocol - validation_protocol ?analytical_method - analytical_method ?qa_approver - quality_approver ?sample_set - sample_set ?evidence_package - evidence_package)
    :precondition
      (and
        (protocol_resources_allocated ?protocol)
        (protocol_analytical_method_assigned ?protocol ?analytical_method)
        (assigned_approver ?protocol ?qa_approver)
        (protocol_sample_set_attached ?protocol ?sample_set)
        (sample_set_linked_to_package ?sample_set ?evidence_package)
        (package_area_site_verified ?evidence_package)
        (not
          (protocol_review_ready ?protocol)
        )
      )
    :effect (protocol_review_ready ?protocol)
  )
  (:action complete_technical_review_basic
    :parameters (?protocol - validation_protocol ?compliance_attachment - compliance_attachment ?sample_set - sample_set ?evidence_package - evidence_package)
    :precondition
      (and
        (protocol_review_ready ?protocol)
        (protocol_compliance_attachment_linked ?protocol ?compliance_attachment)
        (protocol_sample_set_attached ?protocol ?sample_set)
        (sample_set_linked_to_package ?sample_set ?evidence_package)
        (not
          (package_equipment_site_verified ?evidence_package)
        )
        (not
          (package_area_site_verified ?evidence_package)
        )
        (not
          (protocol_technical_review_complete ?protocol)
        )
      )
    :effect (protocol_technical_review_complete ?protocol)
  )
  (:action complete_technical_review_with_equipment_flag
    :parameters (?protocol - validation_protocol ?compliance_attachment - compliance_attachment ?sample_set - sample_set ?evidence_package - evidence_package)
    :precondition
      (and
        (protocol_review_ready ?protocol)
        (protocol_compliance_attachment_linked ?protocol ?compliance_attachment)
        (protocol_sample_set_attached ?protocol ?sample_set)
        (sample_set_linked_to_package ?sample_set ?evidence_package)
        (package_equipment_site_verified ?evidence_package)
        (not
          (package_area_site_verified ?evidence_package)
        )
        (not
          (protocol_technical_review_complete ?protocol)
        )
      )
    :effect
      (and
        (protocol_technical_review_complete ?protocol)
        (protocol_review_signatures_collected ?protocol)
      )
  )
  (:action complete_technical_review_with_area_flag
    :parameters (?protocol - validation_protocol ?compliance_attachment - compliance_attachment ?sample_set - sample_set ?evidence_package - evidence_package)
    :precondition
      (and
        (protocol_review_ready ?protocol)
        (protocol_compliance_attachment_linked ?protocol ?compliance_attachment)
        (protocol_sample_set_attached ?protocol ?sample_set)
        (sample_set_linked_to_package ?sample_set ?evidence_package)
        (not
          (package_equipment_site_verified ?evidence_package)
        )
        (package_area_site_verified ?evidence_package)
        (not
          (protocol_technical_review_complete ?protocol)
        )
      )
    :effect
      (and
        (protocol_technical_review_complete ?protocol)
        (protocol_review_signatures_collected ?protocol)
      )
  )
  (:action complete_technical_review_with_both_flags
    :parameters (?protocol - validation_protocol ?compliance_attachment - compliance_attachment ?sample_set - sample_set ?evidence_package - evidence_package)
    :precondition
      (and
        (protocol_review_ready ?protocol)
        (protocol_compliance_attachment_linked ?protocol ?compliance_attachment)
        (protocol_sample_set_attached ?protocol ?sample_set)
        (sample_set_linked_to_package ?sample_set ?evidence_package)
        (package_equipment_site_verified ?evidence_package)
        (package_area_site_verified ?evidence_package)
        (not
          (protocol_technical_review_complete ?protocol)
        )
      )
    :effect
      (and
        (protocol_technical_review_complete ?protocol)
        (protocol_review_signatures_collected ?protocol)
      )
  )
  (:action finalize_protocol_qa_approval
    :parameters (?protocol - validation_protocol)
    :precondition
      (and
        (protocol_technical_review_complete ?protocol)
        (not
          (protocol_review_signatures_collected ?protocol)
        )
        (not
          (protocol_finalized ?protocol)
        )
      )
    :effect
      (and
        (protocol_finalized ?protocol)
        (validation_entity_qa_approved ?protocol)
      )
  )
  (:action attach_technical_review_to_protocol
    :parameters (?protocol - validation_protocol ?technical_review - technical_review)
    :precondition
      (and
        (protocol_technical_review_complete ?protocol)
        (protocol_review_signatures_collected ?protocol)
        (technical_review_available ?technical_review)
      )
    :effect
      (and
        (protocol_technical_review_attached ?protocol ?technical_review)
        (not
          (technical_review_available ?technical_review)
        )
      )
  )
  (:action finalize_protocol_documentation
    :parameters (?protocol - validation_protocol ?equipment_case - equipment_case ?area_case - area_case ?lab_analyst - laboratory_analyst ?technical_review - technical_review)
    :precondition
      (and
        (protocol_technical_review_complete ?protocol)
        (protocol_review_signatures_collected ?protocol)
        (protocol_technical_review_attached ?protocol ?technical_review)
        (protocol_for_equipment ?protocol ?equipment_case)
        (protocol_for_area ?protocol ?area_case)
        (equipment_sampling_validated ?equipment_case)
        (area_sampling_validated ?area_case)
        (assigned_analyst ?protocol ?lab_analyst)
        (not
          (protocol_documentation_finalized ?protocol)
        )
      )
    :effect (protocol_documentation_finalized ?protocol)
  )
  (:action finalize_protocol_and_apply_qa_approval
    :parameters (?protocol - validation_protocol)
    :precondition
      (and
        (protocol_technical_review_complete ?protocol)
        (protocol_documentation_finalized ?protocol)
        (not
          (protocol_finalized ?protocol)
        )
      )
    :effect
      (and
        (protocol_finalized ?protocol)
        (validation_entity_qa_approved ?protocol)
      )
  )
  (:action attach_external_approval_to_protocol
    :parameters (?protocol - validation_protocol ?external_approval - external_approval ?lab_analyst - laboratory_analyst)
    :precondition
      (and
        (validation_entity_activated ?protocol)
        (assigned_analyst ?protocol ?lab_analyst)
        (external_approval_available ?external_approval)
        (protocol_external_approval_linked ?protocol ?external_approval)
        (not
          (protocol_external_approval_attached ?protocol)
        )
      )
    :effect
      (and
        (protocol_external_approval_attached ?protocol)
        (not
          (external_approval_available ?external_approval)
        )
      )
  )
  (:action verify_external_approval
    :parameters (?protocol - validation_protocol ?qa_approver - quality_approver)
    :precondition
      (and
        (protocol_external_approval_attached ?protocol)
        (assigned_approver ?protocol ?qa_approver)
        (not
          (protocol_external_approval_verified ?protocol)
        )
      )
    :effect (protocol_external_approval_verified ?protocol)
  )
  (:action confirm_compliance_attachment
    :parameters (?protocol - validation_protocol ?compliance_attachment - compliance_attachment)
    :precondition
      (and
        (protocol_external_approval_verified ?protocol)
        (protocol_compliance_attachment_linked ?protocol ?compliance_attachment)
        (not
          (protocol_external_approval_confirmed ?protocol)
        )
      )
    :effect (protocol_external_approval_confirmed ?protocol)
  )
  (:action finalize_protocol_after_compliance
    :parameters (?protocol - validation_protocol)
    :precondition
      (and
        (protocol_external_approval_confirmed ?protocol)
        (not
          (protocol_finalized ?protocol)
        )
      )
    :effect
      (and
        (protocol_finalized ?protocol)
        (validation_entity_qa_approved ?protocol)
      )
  )
  (:action approve_equipment_case_for_release
    :parameters (?equipment_case - equipment_case ?evidence_package - evidence_package)
    :precondition
      (and
        (equipment_samples_ready ?equipment_case)
        (equipment_sampling_validated ?equipment_case)
        (evidence_package_ready ?evidence_package)
        (package_locked ?evidence_package)
        (not
          (validation_entity_qa_approved ?equipment_case)
        )
      )
    :effect (validation_entity_qa_approved ?equipment_case)
  )
  (:action approve_area_case_for_release
    :parameters (?area_case - area_case ?evidence_package - evidence_package)
    :precondition
      (and
        (area_samples_ready ?area_case)
        (area_sampling_validated ?area_case)
        (evidence_package_ready ?evidence_package)
        (package_locked ?evidence_package)
        (not
          (validation_entity_qa_approved ?area_case)
        )
      )
    :effect (validation_entity_qa_approved ?area_case)
  )
  (:action attach_regulatory_marker_to_validation_case
    :parameters (?validation_case - cleaning_validation_case ?regulatory_marker - regulatory_marker ?lab_analyst - laboratory_analyst)
    :precondition
      (and
        (validation_entity_qa_approved ?validation_case)
        (assigned_analyst ?validation_case ?lab_analyst)
        (regulatory_marker_available ?regulatory_marker)
        (not
          (regulatory_marker_linked ?validation_case)
        )
      )
    :effect
      (and
        (regulatory_marker_linked ?validation_case)
        (validation_regulatory_marker_attached ?validation_case ?regulatory_marker)
        (not
          (regulatory_marker_available ?regulatory_marker)
        )
      )
  )
  (:action finalize_equipment_case_release
    :parameters (?equipment_case - equipment_case ?reviewer - reviewer ?regulatory_marker - regulatory_marker)
    :precondition
      (and
        (regulatory_marker_linked ?equipment_case)
        (assigned_reviewer ?equipment_case ?reviewer)
        (validation_regulatory_marker_attached ?equipment_case ?regulatory_marker)
        (not
          (validation_completed ?equipment_case)
        )
      )
    :effect
      (and
        (validation_completed ?equipment_case)
        (reviewer_available ?reviewer)
        (regulatory_marker_available ?regulatory_marker)
      )
  )
  (:action finalize_area_case_release
    :parameters (?area_case - area_case ?reviewer - reviewer ?regulatory_marker - regulatory_marker)
    :precondition
      (and
        (regulatory_marker_linked ?area_case)
        (assigned_reviewer ?area_case ?reviewer)
        (validation_regulatory_marker_attached ?area_case ?regulatory_marker)
        (not
          (validation_completed ?area_case)
        )
      )
    :effect
      (and
        (validation_completed ?area_case)
        (reviewer_available ?reviewer)
        (regulatory_marker_available ?regulatory_marker)
      )
  )
  (:action finalize_protocol_release
    :parameters (?protocol - validation_protocol ?reviewer - reviewer ?regulatory_marker - regulatory_marker)
    :precondition
      (and
        (regulatory_marker_linked ?protocol)
        (assigned_reviewer ?protocol ?reviewer)
        (validation_regulatory_marker_attached ?protocol ?regulatory_marker)
        (not
          (validation_completed ?protocol)
        )
      )
    :effect
      (and
        (validation_completed ?protocol)
        (reviewer_available ?reviewer)
        (regulatory_marker_available ?regulatory_marker)
      )
  )
)

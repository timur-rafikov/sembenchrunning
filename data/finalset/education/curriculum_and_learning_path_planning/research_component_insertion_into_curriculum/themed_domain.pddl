(define (domain curriculum_research_insertion)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object role_or_artifact_category - entity artifact_resource_category - entity resource_category - entity curriculum_category - entity curriculum_element - curriculum_category supervisor_slot - role_or_artifact_category project_proposal - role_or_artifact_category faculty_reviewer - role_or_artifact_category external_partner - role_or_artifact_category assessment_instrument - role_or_artifact_category credit_unit - role_or_artifact_category funding_grant - role_or_artifact_category committee_member - role_or_artifact_category lab_resource - artifact_resource_category accreditation_document - artifact_resource_category student_proposal_record - artifact_resource_category topic_area_primary - resource_category topic_area_secondary - resource_category research_module - resource_category course_variant - curriculum_element stage_variant - curriculum_element core_course - course_variant elective_course - course_variant program_stage - stage_variant)

  (:predicates
    (candidate_for_research ?curriculum_element - curriculum_element)
    (integration_authorized ?curriculum_element - curriculum_element)
    (supervisor_reserved ?curriculum_element - curriculum_element)
    (research_component_integrated ?curriculum_element - curriculum_element)
    (eligible_for_final_integration ?curriculum_element - curriculum_element)
    (credits_allocated ?curriculum_element - curriculum_element)
    (supervisor_slot_available ?supervisor_slot - supervisor_slot)
    (assigned_supervisor_slot ?curriculum_element - curriculum_element ?supervisor_slot - supervisor_slot)
    (proposal_available ?project_proposal - project_proposal)
    (proposal_attached ?curriculum_element - curriculum_element ?project_proposal - project_proposal)
    (reviewer_available ?faculty_reviewer - faculty_reviewer)
    (reviewer_assigned ?curriculum_element - curriculum_element ?faculty_reviewer - faculty_reviewer)
    (lab_resource_available ?lab_resource - lab_resource)
    (resource_reserved_for_core_course ?core_course - core_course ?lab_resource - lab_resource)
    (resource_reserved_for_elective_course ?elective_course - elective_course ?lab_resource - lab_resource)
    (course_primary_topic ?core_course - core_course ?topic_area_primary - topic_area_primary)
    (primary_topic_confirmed ?topic_area_primary - topic_area_primary)
    (primary_topic_allocated ?topic_area_primary - topic_area_primary)
    (course_ready_for_synthesis ?core_course - core_course)
    (course_secondary_topic ?elective_course - elective_course ?topic_area_secondary - topic_area_secondary)
    (secondary_topic_confirmed ?topic_area_secondary - topic_area_secondary)
    (secondary_topic_allocated ?topic_area_secondary - topic_area_secondary)
    (elective_course_ready ?elective_course - elective_course)
    (research_module_template_available ?research_module - research_module)
    (research_module_prepared ?research_module - research_module)
    (research_module_primary_topic ?research_module - research_module ?topic_area_primary - topic_area_primary)
    (research_module_secondary_topic ?research_module - research_module ?topic_area_secondary - topic_area_secondary)
    (module_primary_component_present ?research_module - research_module)
    (module_secondary_component_present ?research_module - research_module)
    (module_schedule_confirmed ?research_module - research_module)
    (program_stage_includes_core_course ?program_stage - program_stage ?core_course - core_course)
    (program_stage_includes_elective_course ?program_stage - program_stage ?elective_course - elective_course)
    (program_stage_includes_research_module ?program_stage - program_stage ?research_module - research_module)
    (accreditation_document_available ?accreditation_document - accreditation_document)
    (program_stage_has_accreditation_document ?program_stage - program_stage ?accreditation_document - accreditation_document)
    (accreditation_document_finalized ?accreditation_document - accreditation_document)
    (accreditation_document_attached_to_module ?accreditation_document - accreditation_document ?research_module - research_module)
    (program_stage_accreditation_initiated ?program_stage - program_stage)
    (program_stage_partnership_and_funding_confirmed ?program_stage - program_stage)
    (committee_review_started ?program_stage - program_stage)
    (program_stage_partner_committed ?program_stage - program_stage)
    (program_stage_partner_document_recorded ?program_stage - program_stage)
    (committee_review_completed ?program_stage - program_stage)
    (assessment_validation_passed ?program_stage - program_stage)
    (student_proposal_record_available ?student_proposal_record - student_proposal_record)
    (program_stage_has_student_proposal_record ?program_stage - program_stage ?student_proposal_record - student_proposal_record)
    (student_proposal_attached ?program_stage - program_stage)
    (proposal_review_acknowledged ?program_stage - program_stage)
    (proposal_review_approved ?program_stage - program_stage)
    (external_partner_available ?external_partner - external_partner)
    (program_stage_has_external_partner ?program_stage - program_stage ?external_partner - external_partner)
    (assessment_instrument_available ?assessment_instrument - assessment_instrument)
    (program_stage_has_assessment_instrument ?program_stage - program_stage ?assessment_instrument - assessment_instrument)
    (funding_grant_available ?funding_grant - funding_grant)
    (program_stage_allocated_funding_grant ?program_stage - program_stage ?funding_grant - funding_grant)
    (committee_member_available ?committee_member - committee_member)
    (program_stage_assigned_committee_member ?program_stage - program_stage ?committee_member - committee_member)
    (credit_unit_available ?credit_unit - credit_unit)
    (credit_allocated_to_element ?curriculum_element - curriculum_element ?credit_unit - credit_unit)
    (core_course_prepared ?core_course - core_course)
    (elective_course_prepared ?elective_course - elective_course)
    (program_stage_accreditation_completed ?program_stage - program_stage)
  )
  (:action identify_research_candidate
    :parameters (?curriculum_element - curriculum_element)
    :precondition
      (and
        (not
          (candidate_for_research ?curriculum_element)
        )
        (not
          (research_component_integrated ?curriculum_element)
        )
      )
    :effect (candidate_for_research ?curriculum_element)
  )
  (:action reserve_supervisor_slot
    :parameters (?curriculum_element - curriculum_element ?supervisor_slot - supervisor_slot)
    :precondition
      (and
        (candidate_for_research ?curriculum_element)
        (not
          (supervisor_reserved ?curriculum_element)
        )
        (supervisor_slot_available ?supervisor_slot)
      )
    :effect
      (and
        (supervisor_reserved ?curriculum_element)
        (assigned_supervisor_slot ?curriculum_element ?supervisor_slot)
        (not
          (supervisor_slot_available ?supervisor_slot)
        )
      )
  )
  (:action attach_project_proposal
    :parameters (?curriculum_element - curriculum_element ?project_proposal - project_proposal)
    :precondition
      (and
        (candidate_for_research ?curriculum_element)
        (supervisor_reserved ?curriculum_element)
        (proposal_available ?project_proposal)
      )
    :effect
      (and
        (proposal_attached ?curriculum_element ?project_proposal)
        (not
          (proposal_available ?project_proposal)
        )
      )
  )
  (:action approve_project_proposal
    :parameters (?curriculum_element - curriculum_element ?project_proposal - project_proposal)
    :precondition
      (and
        (candidate_for_research ?curriculum_element)
        (supervisor_reserved ?curriculum_element)
        (proposal_attached ?curriculum_element ?project_proposal)
        (not
          (integration_authorized ?curriculum_element)
        )
      )
    :effect (integration_authorized ?curriculum_element)
  )
  (:action release_project_proposal
    :parameters (?curriculum_element - curriculum_element ?project_proposal - project_proposal)
    :precondition
      (and
        (proposal_attached ?curriculum_element ?project_proposal)
      )
    :effect
      (and
        (proposal_available ?project_proposal)
        (not
          (proposal_attached ?curriculum_element ?project_proposal)
        )
      )
  )
  (:action assign_faculty_reviewer_to_element
    :parameters (?curriculum_element - curriculum_element ?faculty_reviewer - faculty_reviewer)
    :precondition
      (and
        (integration_authorized ?curriculum_element)
        (reviewer_available ?faculty_reviewer)
      )
    :effect
      (and
        (reviewer_assigned ?curriculum_element ?faculty_reviewer)
        (not
          (reviewer_available ?faculty_reviewer)
        )
      )
  )
  (:action release_faculty_reviewer_from_element
    :parameters (?curriculum_element - curriculum_element ?faculty_reviewer - faculty_reviewer)
    :precondition
      (and
        (reviewer_assigned ?curriculum_element ?faculty_reviewer)
      )
    :effect
      (and
        (reviewer_available ?faculty_reviewer)
        (not
          (reviewer_assigned ?curriculum_element ?faculty_reviewer)
        )
      )
  )
  (:action allocate_funding_grant_to_program_stage
    :parameters (?program_stage - program_stage ?funding_grant - funding_grant)
    :precondition
      (and
        (integration_authorized ?program_stage)
        (funding_grant_available ?funding_grant)
      )
    :effect
      (and
        (program_stage_allocated_funding_grant ?program_stage ?funding_grant)
        (not
          (funding_grant_available ?funding_grant)
        )
      )
  )
  (:action release_funding_grant_from_program_stage
    :parameters (?program_stage - program_stage ?funding_grant - funding_grant)
    :precondition
      (and
        (program_stage_allocated_funding_grant ?program_stage ?funding_grant)
      )
    :effect
      (and
        (funding_grant_available ?funding_grant)
        (not
          (program_stage_allocated_funding_grant ?program_stage ?funding_grant)
        )
      )
  )
  (:action assign_committee_member_to_program_stage
    :parameters (?program_stage - program_stage ?committee_member - committee_member)
    :precondition
      (and
        (integration_authorized ?program_stage)
        (committee_member_available ?committee_member)
      )
    :effect
      (and
        (program_stage_assigned_committee_member ?program_stage ?committee_member)
        (not
          (committee_member_available ?committee_member)
        )
      )
  )
  (:action release_committee_member_from_program_stage
    :parameters (?program_stage - program_stage ?committee_member - committee_member)
    :precondition
      (and
        (program_stage_assigned_committee_member ?program_stage ?committee_member)
      )
    :effect
      (and
        (committee_member_available ?committee_member)
        (not
          (program_stage_assigned_committee_member ?program_stage ?committee_member)
        )
      )
  )
  (:action reserve_primary_topic_for_core_course
    :parameters (?core_course - core_course ?topic_area_primary - topic_area_primary ?project_proposal - project_proposal)
    :precondition
      (and
        (integration_authorized ?core_course)
        (proposal_attached ?core_course ?project_proposal)
        (course_primary_topic ?core_course ?topic_area_primary)
        (not
          (primary_topic_confirmed ?topic_area_primary)
        )
        (not
          (primary_topic_allocated ?topic_area_primary)
        )
      )
    :effect (primary_topic_confirmed ?topic_area_primary)
  )
  (:action confirm_core_course_preparation_with_reviewer
    :parameters (?core_course - core_course ?topic_area_primary - topic_area_primary ?faculty_reviewer - faculty_reviewer)
    :precondition
      (and
        (integration_authorized ?core_course)
        (reviewer_assigned ?core_course ?faculty_reviewer)
        (course_primary_topic ?core_course ?topic_area_primary)
        (primary_topic_confirmed ?topic_area_primary)
        (not
          (core_course_prepared ?core_course)
        )
      )
    :effect
      (and
        (core_course_prepared ?core_course)
        (course_ready_for_synthesis ?core_course)
      )
  )
  (:action reserve_lab_resource_for_core_course
    :parameters (?core_course - core_course ?topic_area_primary - topic_area_primary ?lab_resource - lab_resource)
    :precondition
      (and
        (integration_authorized ?core_course)
        (course_primary_topic ?core_course ?topic_area_primary)
        (lab_resource_available ?lab_resource)
        (not
          (core_course_prepared ?core_course)
        )
      )
    :effect
      (and
        (primary_topic_allocated ?topic_area_primary)
        (core_course_prepared ?core_course)
        (resource_reserved_for_core_course ?core_course ?lab_resource)
        (not
          (lab_resource_available ?lab_resource)
        )
      )
  )
  (:action finalize_core_course_primary_allocation
    :parameters (?core_course - core_course ?topic_area_primary - topic_area_primary ?project_proposal - project_proposal ?lab_resource - lab_resource)
    :precondition
      (and
        (integration_authorized ?core_course)
        (proposal_attached ?core_course ?project_proposal)
        (course_primary_topic ?core_course ?topic_area_primary)
        (primary_topic_allocated ?topic_area_primary)
        (resource_reserved_for_core_course ?core_course ?lab_resource)
        (not
          (course_ready_for_synthesis ?core_course)
        )
      )
    :effect
      (and
        (primary_topic_confirmed ?topic_area_primary)
        (course_ready_for_synthesis ?core_course)
        (lab_resource_available ?lab_resource)
        (not
          (resource_reserved_for_core_course ?core_course ?lab_resource)
        )
      )
  )
  (:action reserve_secondary_topic_for_elective_course
    :parameters (?elective_course - elective_course ?topic_area_secondary - topic_area_secondary ?project_proposal - project_proposal)
    :precondition
      (and
        (integration_authorized ?elective_course)
        (proposal_attached ?elective_course ?project_proposal)
        (course_secondary_topic ?elective_course ?topic_area_secondary)
        (not
          (secondary_topic_confirmed ?topic_area_secondary)
        )
        (not
          (secondary_topic_allocated ?topic_area_secondary)
        )
      )
    :effect (secondary_topic_confirmed ?topic_area_secondary)
  )
  (:action confirm_elective_course_preparation_with_reviewer
    :parameters (?elective_course - elective_course ?topic_area_secondary - topic_area_secondary ?faculty_reviewer - faculty_reviewer)
    :precondition
      (and
        (integration_authorized ?elective_course)
        (reviewer_assigned ?elective_course ?faculty_reviewer)
        (course_secondary_topic ?elective_course ?topic_area_secondary)
        (secondary_topic_confirmed ?topic_area_secondary)
        (not
          (elective_course_prepared ?elective_course)
        )
      )
    :effect
      (and
        (elective_course_prepared ?elective_course)
        (elective_course_ready ?elective_course)
      )
  )
  (:action reserve_lab_resource_for_elective_course
    :parameters (?elective_course - elective_course ?topic_area_secondary - topic_area_secondary ?lab_resource - lab_resource)
    :precondition
      (and
        (integration_authorized ?elective_course)
        (course_secondary_topic ?elective_course ?topic_area_secondary)
        (lab_resource_available ?lab_resource)
        (not
          (elective_course_prepared ?elective_course)
        )
      )
    :effect
      (and
        (secondary_topic_allocated ?topic_area_secondary)
        (elective_course_prepared ?elective_course)
        (resource_reserved_for_elective_course ?elective_course ?lab_resource)
        (not
          (lab_resource_available ?lab_resource)
        )
      )
  )
  (:action finalize_elective_course_secondary_allocation
    :parameters (?elective_course - elective_course ?topic_area_secondary - topic_area_secondary ?project_proposal - project_proposal ?lab_resource - lab_resource)
    :precondition
      (and
        (integration_authorized ?elective_course)
        (proposal_attached ?elective_course ?project_proposal)
        (course_secondary_topic ?elective_course ?topic_area_secondary)
        (secondary_topic_allocated ?topic_area_secondary)
        (resource_reserved_for_elective_course ?elective_course ?lab_resource)
        (not
          (elective_course_ready ?elective_course)
        )
      )
    :effect
      (and
        (secondary_topic_confirmed ?topic_area_secondary)
        (elective_course_ready ?elective_course)
        (lab_resource_available ?lab_resource)
        (not
          (resource_reserved_for_elective_course ?elective_course ?lab_resource)
        )
      )
  )
  (:action synthesize_research_module_standard
    :parameters (?core_course - core_course ?elective_course - elective_course ?topic_area_primary - topic_area_primary ?topic_area_secondary - topic_area_secondary ?research_module - research_module)
    :precondition
      (and
        (core_course_prepared ?core_course)
        (elective_course_prepared ?elective_course)
        (course_primary_topic ?core_course ?topic_area_primary)
        (course_secondary_topic ?elective_course ?topic_area_secondary)
        (primary_topic_confirmed ?topic_area_primary)
        (secondary_topic_confirmed ?topic_area_secondary)
        (course_ready_for_synthesis ?core_course)
        (elective_course_ready ?elective_course)
        (research_module_template_available ?research_module)
      )
    :effect
      (and
        (research_module_prepared ?research_module)
        (research_module_primary_topic ?research_module ?topic_area_primary)
        (research_module_secondary_topic ?research_module ?topic_area_secondary)
        (not
          (research_module_template_available ?research_module)
        )
      )
  )
  (:action synthesize_research_module_primary_variant
    :parameters (?core_course - core_course ?elective_course - elective_course ?topic_area_primary - topic_area_primary ?topic_area_secondary - topic_area_secondary ?research_module - research_module)
    :precondition
      (and
        (core_course_prepared ?core_course)
        (elective_course_prepared ?elective_course)
        (course_primary_topic ?core_course ?topic_area_primary)
        (course_secondary_topic ?elective_course ?topic_area_secondary)
        (primary_topic_allocated ?topic_area_primary)
        (secondary_topic_confirmed ?topic_area_secondary)
        (not
          (course_ready_for_synthesis ?core_course)
        )
        (elective_course_ready ?elective_course)
        (research_module_template_available ?research_module)
      )
    :effect
      (and
        (research_module_prepared ?research_module)
        (research_module_primary_topic ?research_module ?topic_area_primary)
        (research_module_secondary_topic ?research_module ?topic_area_secondary)
        (module_primary_component_present ?research_module)
        (not
          (research_module_template_available ?research_module)
        )
      )
  )
  (:action synthesize_research_module_secondary_variant
    :parameters (?core_course - core_course ?elective_course - elective_course ?topic_area_primary - topic_area_primary ?topic_area_secondary - topic_area_secondary ?research_module - research_module)
    :precondition
      (and
        (core_course_prepared ?core_course)
        (elective_course_prepared ?elective_course)
        (course_primary_topic ?core_course ?topic_area_primary)
        (course_secondary_topic ?elective_course ?topic_area_secondary)
        (primary_topic_confirmed ?topic_area_primary)
        (secondary_topic_allocated ?topic_area_secondary)
        (course_ready_for_synthesis ?core_course)
        (not
          (elective_course_ready ?elective_course)
        )
        (research_module_template_available ?research_module)
      )
    :effect
      (and
        (research_module_prepared ?research_module)
        (research_module_primary_topic ?research_module ?topic_area_primary)
        (research_module_secondary_topic ?research_module ?topic_area_secondary)
        (module_secondary_component_present ?research_module)
        (not
          (research_module_template_available ?research_module)
        )
      )
  )
  (:action synthesize_research_module_full_variant
    :parameters (?core_course - core_course ?elective_course - elective_course ?topic_area_primary - topic_area_primary ?topic_area_secondary - topic_area_secondary ?research_module - research_module)
    :precondition
      (and
        (core_course_prepared ?core_course)
        (elective_course_prepared ?elective_course)
        (course_primary_topic ?core_course ?topic_area_primary)
        (course_secondary_topic ?elective_course ?topic_area_secondary)
        (primary_topic_allocated ?topic_area_primary)
        (secondary_topic_allocated ?topic_area_secondary)
        (not
          (course_ready_for_synthesis ?core_course)
        )
        (not
          (elective_course_ready ?elective_course)
        )
        (research_module_template_available ?research_module)
      )
    :effect
      (and
        (research_module_prepared ?research_module)
        (research_module_primary_topic ?research_module ?topic_area_primary)
        (research_module_secondary_topic ?research_module ?topic_area_secondary)
        (module_primary_component_present ?research_module)
        (module_secondary_component_present ?research_module)
        (not
          (research_module_template_available ?research_module)
        )
      )
  )
  (:action lock_research_module_schedule
    :parameters (?research_module - research_module ?core_course - core_course ?project_proposal - project_proposal)
    :precondition
      (and
        (research_module_prepared ?research_module)
        (core_course_prepared ?core_course)
        (proposal_attached ?core_course ?project_proposal)
        (not
          (module_schedule_confirmed ?research_module)
        )
      )
    :effect (module_schedule_confirmed ?research_module)
  )
  (:action finalize_accreditation_document_and_attach_to_module
    :parameters (?program_stage - program_stage ?accreditation_document - accreditation_document ?research_module - research_module)
    :precondition
      (and
        (integration_authorized ?program_stage)
        (program_stage_includes_research_module ?program_stage ?research_module)
        (program_stage_has_accreditation_document ?program_stage ?accreditation_document)
        (accreditation_document_available ?accreditation_document)
        (research_module_prepared ?research_module)
        (module_schedule_confirmed ?research_module)
        (not
          (accreditation_document_finalized ?accreditation_document)
        )
      )
    :effect
      (and
        (accreditation_document_finalized ?accreditation_document)
        (accreditation_document_attached_to_module ?accreditation_document ?research_module)
        (not
          (accreditation_document_available ?accreditation_document)
        )
      )
  )
  (:action initiate_program_stage_accreditation_process
    :parameters (?program_stage - program_stage ?accreditation_document - accreditation_document ?research_module - research_module ?project_proposal - project_proposal)
    :precondition
      (and
        (integration_authorized ?program_stage)
        (program_stage_has_accreditation_document ?program_stage ?accreditation_document)
        (accreditation_document_finalized ?accreditation_document)
        (accreditation_document_attached_to_module ?accreditation_document ?research_module)
        (proposal_attached ?program_stage ?project_proposal)
        (not
          (module_primary_component_present ?research_module)
        )
        (not
          (program_stage_accreditation_initiated ?program_stage)
        )
      )
    :effect (program_stage_accreditation_initiated ?program_stage)
  )
  (:action commit_external_partner_to_program_stage
    :parameters (?program_stage - program_stage ?external_partner - external_partner)
    :precondition
      (and
        (integration_authorized ?program_stage)
        (external_partner_available ?external_partner)
        (not
          (program_stage_partner_committed ?program_stage)
        )
      )
    :effect
      (and
        (program_stage_partner_committed ?program_stage)
        (program_stage_has_external_partner ?program_stage ?external_partner)
        (not
          (external_partner_available ?external_partner)
        )
      )
  )
  (:action finalize_program_stage_partner_commitment
    :parameters (?program_stage - program_stage ?accreditation_document - accreditation_document ?research_module - research_module ?project_proposal - project_proposal ?external_partner - external_partner)
    :precondition
      (and
        (integration_authorized ?program_stage)
        (program_stage_has_accreditation_document ?program_stage ?accreditation_document)
        (accreditation_document_finalized ?accreditation_document)
        (accreditation_document_attached_to_module ?accreditation_document ?research_module)
        (proposal_attached ?program_stage ?project_proposal)
        (module_primary_component_present ?research_module)
        (program_stage_partner_committed ?program_stage)
        (program_stage_has_external_partner ?program_stage ?external_partner)
        (not
          (program_stage_accreditation_initiated ?program_stage)
        )
      )
    :effect
      (and
        (program_stage_accreditation_initiated ?program_stage)
        (program_stage_partner_document_recorded ?program_stage)
      )
  )
  (:action allocate_funding_and_resources_variant1
    :parameters (?program_stage - program_stage ?funding_grant - funding_grant ?faculty_reviewer - faculty_reviewer ?accreditation_document - accreditation_document ?research_module - research_module)
    :precondition
      (and
        (program_stage_accreditation_initiated ?program_stage)
        (program_stage_allocated_funding_grant ?program_stage ?funding_grant)
        (reviewer_assigned ?program_stage ?faculty_reviewer)
        (program_stage_has_accreditation_document ?program_stage ?accreditation_document)
        (accreditation_document_attached_to_module ?accreditation_document ?research_module)
        (not
          (module_secondary_component_present ?research_module)
        )
        (not
          (program_stage_partnership_and_funding_confirmed ?program_stage)
        )
      )
    :effect (program_stage_partnership_and_funding_confirmed ?program_stage)
  )
  (:action allocate_funding_and_resources_variant2
    :parameters (?program_stage - program_stage ?funding_grant - funding_grant ?faculty_reviewer - faculty_reviewer ?accreditation_document - accreditation_document ?research_module - research_module)
    :precondition
      (and
        (program_stage_accreditation_initiated ?program_stage)
        (program_stage_allocated_funding_grant ?program_stage ?funding_grant)
        (reviewer_assigned ?program_stage ?faculty_reviewer)
        (program_stage_has_accreditation_document ?program_stage ?accreditation_document)
        (accreditation_document_attached_to_module ?accreditation_document ?research_module)
        (module_secondary_component_present ?research_module)
        (not
          (program_stage_partnership_and_funding_confirmed ?program_stage)
        )
      )
    :effect (program_stage_partnership_and_funding_confirmed ?program_stage)
  )
  (:action start_committee_review
    :parameters (?program_stage - program_stage ?committee_member - committee_member ?accreditation_document - accreditation_document ?research_module - research_module)
    :precondition
      (and
        (program_stage_partnership_and_funding_confirmed ?program_stage)
        (program_stage_assigned_committee_member ?program_stage ?committee_member)
        (program_stage_has_accreditation_document ?program_stage ?accreditation_document)
        (accreditation_document_attached_to_module ?accreditation_document ?research_module)
        (not
          (module_primary_component_present ?research_module)
        )
        (not
          (module_secondary_component_present ?research_module)
        )
        (not
          (committee_review_started ?program_stage)
        )
      )
    :effect (committee_review_started ?program_stage)
  )
  (:action complete_committee_review_with_primary
    :parameters (?program_stage - program_stage ?committee_member - committee_member ?accreditation_document - accreditation_document ?research_module - research_module)
    :precondition
      (and
        (program_stage_partnership_and_funding_confirmed ?program_stage)
        (program_stage_assigned_committee_member ?program_stage ?committee_member)
        (program_stage_has_accreditation_document ?program_stage ?accreditation_document)
        (accreditation_document_attached_to_module ?accreditation_document ?research_module)
        (module_primary_component_present ?research_module)
        (not
          (module_secondary_component_present ?research_module)
        )
        (not
          (committee_review_started ?program_stage)
        )
      )
    :effect
      (and
        (committee_review_started ?program_stage)
        (committee_review_completed ?program_stage)
      )
  )
  (:action complete_committee_review_with_secondary
    :parameters (?program_stage - program_stage ?committee_member - committee_member ?accreditation_document - accreditation_document ?research_module - research_module)
    :precondition
      (and
        (program_stage_partnership_and_funding_confirmed ?program_stage)
        (program_stage_assigned_committee_member ?program_stage ?committee_member)
        (program_stage_has_accreditation_document ?program_stage ?accreditation_document)
        (accreditation_document_attached_to_module ?accreditation_document ?research_module)
        (not
          (module_primary_component_present ?research_module)
        )
        (module_secondary_component_present ?research_module)
        (not
          (committee_review_started ?program_stage)
        )
      )
    :effect
      (and
        (committee_review_started ?program_stage)
        (committee_review_completed ?program_stage)
      )
  )
  (:action complete_committee_review_with_both
    :parameters (?program_stage - program_stage ?committee_member - committee_member ?accreditation_document - accreditation_document ?research_module - research_module)
    :precondition
      (and
        (program_stage_partnership_and_funding_confirmed ?program_stage)
        (program_stage_assigned_committee_member ?program_stage ?committee_member)
        (program_stage_has_accreditation_document ?program_stage ?accreditation_document)
        (accreditation_document_attached_to_module ?accreditation_document ?research_module)
        (module_primary_component_present ?research_module)
        (module_secondary_component_present ?research_module)
        (not
          (committee_review_started ?program_stage)
        )
      )
    :effect
      (and
        (committee_review_started ?program_stage)
        (committee_review_completed ?program_stage)
      )
  )
  (:action complete_program_stage_accreditation_and_mark_ready
    :parameters (?program_stage - program_stage)
    :precondition
      (and
        (committee_review_started ?program_stage)
        (not
          (committee_review_completed ?program_stage)
        )
        (not
          (program_stage_accreditation_completed ?program_stage)
        )
      )
    :effect
      (and
        (program_stage_accreditation_completed ?program_stage)
        (eligible_for_final_integration ?program_stage)
      )
  )
  (:action attach_assessment_instrument_to_program_stage
    :parameters (?program_stage - program_stage ?assessment_instrument - assessment_instrument)
    :precondition
      (and
        (committee_review_started ?program_stage)
        (committee_review_completed ?program_stage)
        (assessment_instrument_available ?assessment_instrument)
      )
    :effect
      (and
        (program_stage_has_assessment_instrument ?program_stage ?assessment_instrument)
        (not
          (assessment_instrument_available ?assessment_instrument)
        )
      )
  )
  (:action validate_assessment_and_mark_program_stage_validated
    :parameters (?program_stage - program_stage ?core_course - core_course ?elective_course - elective_course ?project_proposal - project_proposal ?assessment_instrument - assessment_instrument)
    :precondition
      (and
        (committee_review_started ?program_stage)
        (committee_review_completed ?program_stage)
        (program_stage_has_assessment_instrument ?program_stage ?assessment_instrument)
        (program_stage_includes_core_course ?program_stage ?core_course)
        (program_stage_includes_elective_course ?program_stage ?elective_course)
        (course_ready_for_synthesis ?core_course)
        (elective_course_ready ?elective_course)
        (proposal_attached ?program_stage ?project_proposal)
        (not
          (assessment_validation_passed ?program_stage)
        )
      )
    :effect (assessment_validation_passed ?program_stage)
  )
  (:action finalize_program_stage_validation_and_mark_ready
    :parameters (?program_stage - program_stage)
    :precondition
      (and
        (committee_review_started ?program_stage)
        (assessment_validation_passed ?program_stage)
        (not
          (program_stage_accreditation_completed ?program_stage)
        )
      )
    :effect
      (and
        (program_stage_accreditation_completed ?program_stage)
        (eligible_for_final_integration ?program_stage)
      )
  )
  (:action attach_student_proposal_record_to_program_stage
    :parameters (?program_stage - program_stage ?student_proposal_record - student_proposal_record ?project_proposal - project_proposal)
    :precondition
      (and
        (integration_authorized ?program_stage)
        (proposal_attached ?program_stage ?project_proposal)
        (student_proposal_record_available ?student_proposal_record)
        (program_stage_has_student_proposal_record ?program_stage ?student_proposal_record)
        (not
          (student_proposal_attached ?program_stage)
        )
      )
    :effect
      (and
        (student_proposal_attached ?program_stage)
        (not
          (student_proposal_record_available ?student_proposal_record)
        )
      )
  )
  (:action acknowledge_student_proposal_review
    :parameters (?program_stage - program_stage ?faculty_reviewer - faculty_reviewer)
    :precondition
      (and
        (student_proposal_attached ?program_stage)
        (reviewer_assigned ?program_stage ?faculty_reviewer)
        (not
          (proposal_review_acknowledged ?program_stage)
        )
      )
    :effect (proposal_review_acknowledged ?program_stage)
  )
  (:action approve_student_proposal_by_committee_member
    :parameters (?program_stage - program_stage ?committee_member - committee_member)
    :precondition
      (and
        (proposal_review_acknowledged ?program_stage)
        (program_stage_assigned_committee_member ?program_stage ?committee_member)
        (not
          (proposal_review_approved ?program_stage)
        )
      )
    :effect (proposal_review_approved ?program_stage)
  )
  (:action finalize_student_proposal_approval_and_mark_program_stage_ready
    :parameters (?program_stage - program_stage)
    :precondition
      (and
        (proposal_review_approved ?program_stage)
        (not
          (program_stage_accreditation_completed ?program_stage)
        )
      )
    :effect
      (and
        (program_stage_accreditation_completed ?program_stage)
        (eligible_for_final_integration ?program_stage)
      )
  )
  (:action assign_final_credit_to_core_course
    :parameters (?core_course - core_course ?research_module - research_module)
    :precondition
      (and
        (core_course_prepared ?core_course)
        (course_ready_for_synthesis ?core_course)
        (research_module_prepared ?research_module)
        (module_schedule_confirmed ?research_module)
        (not
          (eligible_for_final_integration ?core_course)
        )
      )
    :effect (eligible_for_final_integration ?core_course)
  )
  (:action assign_final_credit_to_elective_course
    :parameters (?elective_course - elective_course ?research_module - research_module)
    :precondition
      (and
        (elective_course_prepared ?elective_course)
        (elective_course_ready ?elective_course)
        (research_module_prepared ?research_module)
        (module_schedule_confirmed ?research_module)
        (not
          (eligible_for_final_integration ?elective_course)
        )
      )
    :effect (eligible_for_final_integration ?elective_course)
  )
  (:action allocate_credits_to_curriculum_element
    :parameters (?curriculum_element - curriculum_element ?credit_unit - credit_unit ?project_proposal - project_proposal)
    :precondition
      (and
        (eligible_for_final_integration ?curriculum_element)
        (proposal_attached ?curriculum_element ?project_proposal)
        (credit_unit_available ?credit_unit)
        (not
          (credits_allocated ?curriculum_element)
        )
      )
    :effect
      (and
        (credits_allocated ?curriculum_element)
        (credit_allocated_to_element ?curriculum_element ?credit_unit)
        (not
          (credit_unit_available ?credit_unit)
        )
      )
  )
  (:action integrate_research_component_into_core_course
    :parameters (?core_course - core_course ?supervisor_slot - supervisor_slot ?credit_unit - credit_unit)
    :precondition
      (and
        (credits_allocated ?core_course)
        (assigned_supervisor_slot ?core_course ?supervisor_slot)
        (credit_allocated_to_element ?core_course ?credit_unit)
        (not
          (research_component_integrated ?core_course)
        )
      )
    :effect
      (and
        (research_component_integrated ?core_course)
        (supervisor_slot_available ?supervisor_slot)
        (credit_unit_available ?credit_unit)
      )
  )
  (:action integrate_research_component_into_elective_course
    :parameters (?elective_course - elective_course ?supervisor_slot - supervisor_slot ?credit_unit - credit_unit)
    :precondition
      (and
        (credits_allocated ?elective_course)
        (assigned_supervisor_slot ?elective_course ?supervisor_slot)
        (credit_allocated_to_element ?elective_course ?credit_unit)
        (not
          (research_component_integrated ?elective_course)
        )
      )
    :effect
      (and
        (research_component_integrated ?elective_course)
        (supervisor_slot_available ?supervisor_slot)
        (credit_unit_available ?credit_unit)
      )
  )
  (:action integrate_research_component_into_program_stage
    :parameters (?program_stage - program_stage ?supervisor_slot - supervisor_slot ?credit_unit - credit_unit)
    :precondition
      (and
        (credits_allocated ?program_stage)
        (assigned_supervisor_slot ?program_stage ?supervisor_slot)
        (credit_allocated_to_element ?program_stage ?credit_unit)
        (not
          (research_component_integrated ?program_stage)
        )
      )
    :effect
      (and
        (research_component_integrated ?program_stage)
        (supervisor_slot_available ?supervisor_slot)
        (credit_unit_available ?credit_unit)
      )
  )
)

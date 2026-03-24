(define (domain long_term_skill_gap_closure_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object resource_category - entity schedule_category - entity offering_category - entity institutional_entity - entity academic_entity - institutional_entity instructional_resource - resource_category assessment - resource_category instructor - resource_category accreditation_document - resource_category administrative_resource - resource_category mentorship_token - resource_category pedagogical_asset - resource_category external_evidence - resource_category optional_module - schedule_category learning_material - schedule_category industry_partner - schedule_category term_slot - offering_category delivery_session - offering_category course_offering - offering_category program_category - academic_entity curriculum_category - academic_entity academic_program - program_category academic_track - program_category course_template - curriculum_category)

  (:predicates
    (plan_initialized ?academic_entity - academic_entity)
    (eligibility_confirmed_for_academic_entity ?academic_entity - academic_entity)
    (resource_allocated ?academic_entity - academic_entity)
    (completion_awarded ?academic_entity - academic_entity)
    (eligible_for_certification ?academic_entity - academic_entity)
    (certification_issued ?academic_entity - academic_entity)
    (resource_available ?instructional_resource - instructional_resource)
    (assigned_instructional_resource ?academic_entity - academic_entity ?instructional_resource - instructional_resource)
    (assessment_available ?assessment - assessment)
    (assigned_assessment_to_entity ?academic_entity - academic_entity ?assessment - assessment)
    (instructor_available ?instructor - instructor)
    (assigned_instructor_to_entity ?academic_entity - academic_entity ?instructor - instructor)
    (optional_module_available ?optional_module - optional_module)
    (program_attached_optional_module ?academic_program - academic_program ?optional_module - optional_module)
    (track_attached_optional_module ?academic_track - academic_track ?optional_module - optional_module)
    (program_scheduled_in_term ?academic_program - academic_program ?term_slot - term_slot)
    (term_slot_reserved ?term_slot - term_slot)
    (term_slot_locked ?term_slot - term_slot)
    (program_ready_for_offering ?academic_program - academic_program)
    (track_assigned_to_session ?academic_track - academic_track ?delivery_session - delivery_session)
    (session_reserved ?delivery_session - delivery_session)
    (session_locked ?delivery_session - delivery_session)
    (track_ready_for_offering ?academic_track - academic_track)
    (offering_proposed ?course_offering - course_offering)
    (offering_prepared ?course_offering - course_offering)
    (offering_assigned_to_term_slot ?course_offering - course_offering ?term_slot - term_slot)
    (offering_assigned_to_session ?course_offering - course_offering ?delivery_session - delivery_session)
    (offering_requires_accreditation_review ?course_offering - course_offering)
    (offering_requires_partner_endorsement ?course_offering - course_offering)
    (offering_assessment_confirmed ?course_offering - course_offering)
    (template_required_by_program ?course_template - course_template ?academic_program - academic_program)
    (template_required_by_track ?course_template - course_template ?academic_track - academic_track)
    (template_has_offering ?course_template - course_template ?course_offering - course_offering)
    (learning_material_available ?learning_material - learning_material)
    (template_has_learning_material ?course_template - course_template ?learning_material - learning_material)
    (learning_material_in_use ?learning_material - learning_material)
    (learning_material_assigned_to_offering ?learning_material - learning_material ?course_offering - course_offering)
    (template_content_validated ?course_template - course_template)
    (template_assessment_verified ?course_template - course_template)
    (template_evidence_linked ?course_template - course_template)
    (template_has_accreditation_endorsement ?course_template - course_template)
    (template_accreditation_validated ?course_template - course_template)
    (template_ready_for_finalization ?course_template - course_template)
    (template_assembly_complete ?course_template - course_template)
    (industry_partner_available ?industry_partner - industry_partner)
    (template_has_industry_partner ?course_template - course_template ?industry_partner - industry_partner)
    (template_has_industry_endorsement ?course_template - course_template)
    (endorsement_validation_stage1 ?course_template - course_template)
    (endorsement_validation_stage2 ?course_template - course_template)
    (accreditation_document_available ?accreditation_document - accreditation_document)
    (template_attached_accreditation_document ?course_template - course_template ?accreditation_document - accreditation_document)
    (administrative_resource_available ?administrative_resource - administrative_resource)
    (template_has_administrative_resource ?course_template - course_template ?administrative_resource - administrative_resource)
    (pedagogical_asset_available ?pedagogical_asset - pedagogical_asset)
    (template_has_pedagogical_asset ?course_template - course_template ?pedagogical_asset - pedagogical_asset)
    (external_evidence_available ?external_evidence - external_evidence)
    (template_attached_external_evidence ?course_template - course_template ?external_evidence - external_evidence)
    (mentorship_token_available ?mentorship_token - mentorship_token)
    (entity_assigned_mentorship_token ?academic_entity - academic_entity ?mentorship_token - mentorship_token)
    (program_slot_and_instructor_confirmed ?academic_program - academic_program)
    (track_slot_and_instructor_confirmed ?academic_track - academic_track)
    (finalization_logged ?course_template - course_template)
  )
  (:action initialize_academic_plan
    :parameters (?academic_entity - academic_entity)
    :precondition
      (and
        (not
          (plan_initialized ?academic_entity)
        )
        (not
          (completion_awarded ?academic_entity)
        )
      )
    :effect (plan_initialized ?academic_entity)
  )
  (:action assign_instructional_resource
    :parameters (?academic_entity - academic_entity ?instructional_resource - instructional_resource)
    :precondition
      (and
        (plan_initialized ?academic_entity)
        (not
          (resource_allocated ?academic_entity)
        )
        (resource_available ?instructional_resource)
      )
    :effect
      (and
        (resource_allocated ?academic_entity)
        (assigned_instructional_resource ?academic_entity ?instructional_resource)
        (not
          (resource_available ?instructional_resource)
        )
      )
  )
  (:action allocate_assessment
    :parameters (?academic_entity - academic_entity ?assessment - assessment)
    :precondition
      (and
        (plan_initialized ?academic_entity)
        (resource_allocated ?academic_entity)
        (assessment_available ?assessment)
      )
    :effect
      (and
        (assigned_assessment_to_entity ?academic_entity ?assessment)
        (not
          (assessment_available ?assessment)
        )
      )
  )
  (:action verify_prerequisite_assessment
    :parameters (?academic_entity - academic_entity ?assessment - assessment)
    :precondition
      (and
        (plan_initialized ?academic_entity)
        (resource_allocated ?academic_entity)
        (assigned_assessment_to_entity ?academic_entity ?assessment)
        (not
          (eligibility_confirmed_for_academic_entity ?academic_entity)
        )
      )
    :effect (eligibility_confirmed_for_academic_entity ?academic_entity)
  )
  (:action release_assessment
    :parameters (?academic_entity - academic_entity ?assessment - assessment)
    :precondition
      (and
        (assigned_assessment_to_entity ?academic_entity ?assessment)
      )
    :effect
      (and
        (assessment_available ?assessment)
        (not
          (assigned_assessment_to_entity ?academic_entity ?assessment)
        )
      )
  )
  (:action assign_instructor
    :parameters (?academic_entity - academic_entity ?instructor - instructor)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?academic_entity)
        (instructor_available ?instructor)
      )
    :effect
      (and
        (assigned_instructor_to_entity ?academic_entity ?instructor)
        (not
          (instructor_available ?instructor)
        )
      )
  )
  (:action release_instructor
    :parameters (?academic_entity - academic_entity ?instructor - instructor)
    :precondition
      (and
        (assigned_instructor_to_entity ?academic_entity ?instructor)
      )
    :effect
      (and
        (instructor_available ?instructor)
        (not
          (assigned_instructor_to_entity ?academic_entity ?instructor)
        )
      )
  )
  (:action assign_pedagogical_asset_to_template
    :parameters (?course_template - course_template ?pedagogical_asset - pedagogical_asset)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?course_template)
        (pedagogical_asset_available ?pedagogical_asset)
      )
    :effect
      (and
        (template_has_pedagogical_asset ?course_template ?pedagogical_asset)
        (not
          (pedagogical_asset_available ?pedagogical_asset)
        )
      )
  )
  (:action release_pedagogical_asset_from_template
    :parameters (?course_template - course_template ?pedagogical_asset - pedagogical_asset)
    :precondition
      (and
        (template_has_pedagogical_asset ?course_template ?pedagogical_asset)
      )
    :effect
      (and
        (pedagogical_asset_available ?pedagogical_asset)
        (not
          (template_has_pedagogical_asset ?course_template ?pedagogical_asset)
        )
      )
  )
  (:action attach_external_evidence_to_template
    :parameters (?course_template - course_template ?external_evidence - external_evidence)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?course_template)
        (external_evidence_available ?external_evidence)
      )
    :effect
      (and
        (template_attached_external_evidence ?course_template ?external_evidence)
        (not
          (external_evidence_available ?external_evidence)
        )
      )
  )
  (:action detach_external_evidence_from_template
    :parameters (?course_template - course_template ?external_evidence - external_evidence)
    :precondition
      (and
        (template_attached_external_evidence ?course_template ?external_evidence)
      )
    :effect
      (and
        (external_evidence_available ?external_evidence)
        (not
          (template_attached_external_evidence ?course_template ?external_evidence)
        )
      )
  )
  (:action reserve_term_slot_for_program
    :parameters (?academic_program - academic_program ?term_slot - term_slot ?assessment - assessment)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?academic_program)
        (assigned_assessment_to_entity ?academic_program ?assessment)
        (program_scheduled_in_term ?academic_program ?term_slot)
        (not
          (term_slot_reserved ?term_slot)
        )
        (not
          (term_slot_locked ?term_slot)
        )
      )
    :effect (term_slot_reserved ?term_slot)
  )
  (:action confirm_program_instructor_and_prepare_slot
    :parameters (?academic_program - academic_program ?term_slot - term_slot ?instructor - instructor)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?academic_program)
        (assigned_instructor_to_entity ?academic_program ?instructor)
        (program_scheduled_in_term ?academic_program ?term_slot)
        (term_slot_reserved ?term_slot)
        (not
          (program_slot_and_instructor_confirmed ?academic_program)
        )
      )
    :effect
      (and
        (program_slot_and_instructor_confirmed ?academic_program)
        (program_ready_for_offering ?academic_program)
      )
  )
  (:action attach_optional_module_and_lock_slot
    :parameters (?academic_program - academic_program ?term_slot - term_slot ?optional_module - optional_module)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?academic_program)
        (program_scheduled_in_term ?academic_program ?term_slot)
        (optional_module_available ?optional_module)
        (not
          (program_slot_and_instructor_confirmed ?academic_program)
        )
      )
    :effect
      (and
        (term_slot_locked ?term_slot)
        (program_slot_and_instructor_confirmed ?academic_program)
        (program_attached_optional_module ?academic_program ?optional_module)
        (not
          (optional_module_available ?optional_module)
        )
      )
  )
  (:action integrate_optional_module_after_assessment
    :parameters (?academic_program - academic_program ?term_slot - term_slot ?assessment - assessment ?optional_module - optional_module)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?academic_program)
        (assigned_assessment_to_entity ?academic_program ?assessment)
        (program_scheduled_in_term ?academic_program ?term_slot)
        (term_slot_locked ?term_slot)
        (program_attached_optional_module ?academic_program ?optional_module)
        (not
          (program_ready_for_offering ?academic_program)
        )
      )
    :effect
      (and
        (term_slot_reserved ?term_slot)
        (program_ready_for_offering ?academic_program)
        (optional_module_available ?optional_module)
        (not
          (program_attached_optional_module ?academic_program ?optional_module)
        )
      )
  )
  (:action reserve_delivery_session_for_track
    :parameters (?academic_track - academic_track ?delivery_session - delivery_session ?assessment - assessment)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?academic_track)
        (assigned_assessment_to_entity ?academic_track ?assessment)
        (track_assigned_to_session ?academic_track ?delivery_session)
        (not
          (session_reserved ?delivery_session)
        )
        (not
          (session_locked ?delivery_session)
        )
      )
    :effect (session_reserved ?delivery_session)
  )
  (:action confirm_track_instructor_and_prepare_session
    :parameters (?academic_track - academic_track ?delivery_session - delivery_session ?instructor - instructor)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?academic_track)
        (assigned_instructor_to_entity ?academic_track ?instructor)
        (track_assigned_to_session ?academic_track ?delivery_session)
        (session_reserved ?delivery_session)
        (not
          (track_slot_and_instructor_confirmed ?academic_track)
        )
      )
    :effect
      (and
        (track_slot_and_instructor_confirmed ?academic_track)
        (track_ready_for_offering ?academic_track)
      )
  )
  (:action attach_optional_module_to_track_and_lock_session
    :parameters (?academic_track - academic_track ?delivery_session - delivery_session ?optional_module - optional_module)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?academic_track)
        (track_assigned_to_session ?academic_track ?delivery_session)
        (optional_module_available ?optional_module)
        (not
          (track_slot_and_instructor_confirmed ?academic_track)
        )
      )
    :effect
      (and
        (session_locked ?delivery_session)
        (track_slot_and_instructor_confirmed ?academic_track)
        (track_attached_optional_module ?academic_track ?optional_module)
        (not
          (optional_module_available ?optional_module)
        )
      )
  )
  (:action process_track_assessment_and_release_optional_module
    :parameters (?academic_track - academic_track ?delivery_session - delivery_session ?assessment - assessment ?optional_module - optional_module)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?academic_track)
        (assigned_assessment_to_entity ?academic_track ?assessment)
        (track_assigned_to_session ?academic_track ?delivery_session)
        (session_locked ?delivery_session)
        (track_attached_optional_module ?academic_track ?optional_module)
        (not
          (track_ready_for_offering ?academic_track)
        )
      )
    :effect
      (and
        (session_reserved ?delivery_session)
        (track_ready_for_offering ?academic_track)
        (optional_module_available ?optional_module)
        (not
          (track_attached_optional_module ?academic_track ?optional_module)
        )
      )
  )
  (:action orchestrate_course_offering
    :parameters (?academic_program - academic_program ?academic_track - academic_track ?term_slot - term_slot ?delivery_session - delivery_session ?course_offering - course_offering)
    :precondition
      (and
        (program_slot_and_instructor_confirmed ?academic_program)
        (track_slot_and_instructor_confirmed ?academic_track)
        (program_scheduled_in_term ?academic_program ?term_slot)
        (track_assigned_to_session ?academic_track ?delivery_session)
        (term_slot_reserved ?term_slot)
        (session_reserved ?delivery_session)
        (program_ready_for_offering ?academic_program)
        (track_ready_for_offering ?academic_track)
        (offering_proposed ?course_offering)
      )
    :effect
      (and
        (offering_prepared ?course_offering)
        (offering_assigned_to_term_slot ?course_offering ?term_slot)
        (offering_assigned_to_session ?course_offering ?delivery_session)
        (not
          (offering_proposed ?course_offering)
        )
      )
  )
  (:action orchestrate_course_offering_with_slot_block
    :parameters (?academic_program - academic_program ?academic_track - academic_track ?term_slot - term_slot ?delivery_session - delivery_session ?course_offering - course_offering)
    :precondition
      (and
        (program_slot_and_instructor_confirmed ?academic_program)
        (track_slot_and_instructor_confirmed ?academic_track)
        (program_scheduled_in_term ?academic_program ?term_slot)
        (track_assigned_to_session ?academic_track ?delivery_session)
        (term_slot_locked ?term_slot)
        (session_reserved ?delivery_session)
        (not
          (program_ready_for_offering ?academic_program)
        )
        (track_ready_for_offering ?academic_track)
        (offering_proposed ?course_offering)
      )
    :effect
      (and
        (offering_prepared ?course_offering)
        (offering_assigned_to_term_slot ?course_offering ?term_slot)
        (offering_assigned_to_session ?course_offering ?delivery_session)
        (offering_requires_accreditation_review ?course_offering)
        (not
          (offering_proposed ?course_offering)
        )
      )
  )
  (:action orchestrate_course_offering_with_session_lock
    :parameters (?academic_program - academic_program ?academic_track - academic_track ?term_slot - term_slot ?delivery_session - delivery_session ?course_offering - course_offering)
    :precondition
      (and
        (program_slot_and_instructor_confirmed ?academic_program)
        (track_slot_and_instructor_confirmed ?academic_track)
        (program_scheduled_in_term ?academic_program ?term_slot)
        (track_assigned_to_session ?academic_track ?delivery_session)
        (term_slot_reserved ?term_slot)
        (session_locked ?delivery_session)
        (program_ready_for_offering ?academic_program)
        (not
          (track_ready_for_offering ?academic_track)
        )
        (offering_proposed ?course_offering)
      )
    :effect
      (and
        (offering_prepared ?course_offering)
        (offering_assigned_to_term_slot ?course_offering ?term_slot)
        (offering_assigned_to_session ?course_offering ?delivery_session)
        (offering_requires_partner_endorsement ?course_offering)
        (not
          (offering_proposed ?course_offering)
        )
      )
  )
  (:action orchestrate_course_offering_with_slot_and_session_lock
    :parameters (?academic_program - academic_program ?academic_track - academic_track ?term_slot - term_slot ?delivery_session - delivery_session ?course_offering - course_offering)
    :precondition
      (and
        (program_slot_and_instructor_confirmed ?academic_program)
        (track_slot_and_instructor_confirmed ?academic_track)
        (program_scheduled_in_term ?academic_program ?term_slot)
        (track_assigned_to_session ?academic_track ?delivery_session)
        (term_slot_locked ?term_slot)
        (session_locked ?delivery_session)
        (not
          (program_ready_for_offering ?academic_program)
        )
        (not
          (track_ready_for_offering ?academic_track)
        )
        (offering_proposed ?course_offering)
      )
    :effect
      (and
        (offering_prepared ?course_offering)
        (offering_assigned_to_term_slot ?course_offering ?term_slot)
        (offering_assigned_to_session ?course_offering ?delivery_session)
        (offering_requires_accreditation_review ?course_offering)
        (offering_requires_partner_endorsement ?course_offering)
        (not
          (offering_proposed ?course_offering)
        )
      )
  )
  (:action confirm_offering_assessment_readiness
    :parameters (?course_offering - course_offering ?academic_program - academic_program ?assessment - assessment)
    :precondition
      (and
        (offering_prepared ?course_offering)
        (program_slot_and_instructor_confirmed ?academic_program)
        (assigned_assessment_to_entity ?academic_program ?assessment)
        (not
          (offering_assessment_confirmed ?course_offering)
        )
      )
    :effect (offering_assessment_confirmed ?course_offering)
  )
  (:action link_learning_material_to_offering
    :parameters (?course_template - course_template ?learning_material - learning_material ?course_offering - course_offering)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?course_template)
        (template_has_offering ?course_template ?course_offering)
        (template_has_learning_material ?course_template ?learning_material)
        (learning_material_available ?learning_material)
        (offering_prepared ?course_offering)
        (offering_assessment_confirmed ?course_offering)
        (not
          (learning_material_in_use ?learning_material)
        )
      )
    :effect
      (and
        (learning_material_in_use ?learning_material)
        (learning_material_assigned_to_offering ?learning_material ?course_offering)
        (not
          (learning_material_available ?learning_material)
        )
      )
  )
  (:action validate_course_template_for_offering
    :parameters (?course_template - course_template ?learning_material - learning_material ?course_offering - course_offering ?assessment - assessment)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?course_template)
        (template_has_learning_material ?course_template ?learning_material)
        (learning_material_in_use ?learning_material)
        (learning_material_assigned_to_offering ?learning_material ?course_offering)
        (assigned_assessment_to_entity ?course_template ?assessment)
        (not
          (offering_requires_accreditation_review ?course_offering)
        )
        (not
          (template_content_validated ?course_template)
        )
      )
    :effect (template_content_validated ?course_template)
  )
  (:action attach_accreditation_document_to_template
    :parameters (?course_template - course_template ?accreditation_document - accreditation_document)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?course_template)
        (accreditation_document_available ?accreditation_document)
        (not
          (template_has_accreditation_endorsement ?course_template)
        )
      )
    :effect
      (and
        (template_has_accreditation_endorsement ?course_template)
        (template_attached_accreditation_document ?course_template ?accreditation_document)
        (not
          (accreditation_document_available ?accreditation_document)
        )
      )
  )
  (:action validate_template_with_accreditation_and_mark_ready
    :parameters (?course_template - course_template ?learning_material - learning_material ?course_offering - course_offering ?assessment - assessment ?accreditation_document - accreditation_document)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?course_template)
        (template_has_learning_material ?course_template ?learning_material)
        (learning_material_in_use ?learning_material)
        (learning_material_assigned_to_offering ?learning_material ?course_offering)
        (assigned_assessment_to_entity ?course_template ?assessment)
        (offering_requires_accreditation_review ?course_offering)
        (template_has_accreditation_endorsement ?course_template)
        (template_attached_accreditation_document ?course_template ?accreditation_document)
        (not
          (template_content_validated ?course_template)
        )
      )
    :effect
      (and
        (template_content_validated ?course_template)
        (template_accreditation_validated ?course_template)
      )
  )
  (:action confirm_template_assessment_and_authorize
    :parameters (?course_template - course_template ?pedagogical_asset - pedagogical_asset ?instructor - instructor ?learning_material - learning_material ?course_offering - course_offering)
    :precondition
      (and
        (template_content_validated ?course_template)
        (template_has_pedagogical_asset ?course_template ?pedagogical_asset)
        (assigned_instructor_to_entity ?course_template ?instructor)
        (template_has_learning_material ?course_template ?learning_material)
        (learning_material_assigned_to_offering ?learning_material ?course_offering)
        (not
          (offering_requires_partner_endorsement ?course_offering)
        )
        (not
          (template_assessment_verified ?course_template)
        )
      )
    :effect (template_assessment_verified ?course_template)
  )
  (:action confirm_template_assessment_and_authorize_alternate
    :parameters (?course_template - course_template ?pedagogical_asset - pedagogical_asset ?instructor - instructor ?learning_material - learning_material ?course_offering - course_offering)
    :precondition
      (and
        (template_content_validated ?course_template)
        (template_has_pedagogical_asset ?course_template ?pedagogical_asset)
        (assigned_instructor_to_entity ?course_template ?instructor)
        (template_has_learning_material ?course_template ?learning_material)
        (learning_material_assigned_to_offering ?learning_material ?course_offering)
        (offering_requires_partner_endorsement ?course_offering)
        (not
          (template_assessment_verified ?course_template)
        )
      )
    :effect (template_assessment_verified ?course_template)
  )
  (:action apply_external_evidence_and_mark_template_stage
    :parameters (?course_template - course_template ?external_evidence - external_evidence ?learning_material - learning_material ?course_offering - course_offering)
    :precondition
      (and
        (template_assessment_verified ?course_template)
        (template_attached_external_evidence ?course_template ?external_evidence)
        (template_has_learning_material ?course_template ?learning_material)
        (learning_material_assigned_to_offering ?learning_material ?course_offering)
        (not
          (offering_requires_accreditation_review ?course_offering)
        )
        (not
          (offering_requires_partner_endorsement ?course_offering)
        )
        (not
          (template_evidence_linked ?course_template)
        )
      )
    :effect (template_evidence_linked ?course_template)
  )
  (:action apply_external_evidence_and_mark_template_ready
    :parameters (?course_template - course_template ?external_evidence - external_evidence ?learning_material - learning_material ?course_offering - course_offering)
    :precondition
      (and
        (template_assessment_verified ?course_template)
        (template_attached_external_evidence ?course_template ?external_evidence)
        (template_has_learning_material ?course_template ?learning_material)
        (learning_material_assigned_to_offering ?learning_material ?course_offering)
        (offering_requires_accreditation_review ?course_offering)
        (not
          (offering_requires_partner_endorsement ?course_offering)
        )
        (not
          (template_evidence_linked ?course_template)
        )
      )
    :effect
      (and
        (template_evidence_linked ?course_template)
        (template_ready_for_finalization ?course_template)
      )
  )
  (:action apply_external_evidence_and_mark_template_ready_variant
    :parameters (?course_template - course_template ?external_evidence - external_evidence ?learning_material - learning_material ?course_offering - course_offering)
    :precondition
      (and
        (template_assessment_verified ?course_template)
        (template_attached_external_evidence ?course_template ?external_evidence)
        (template_has_learning_material ?course_template ?learning_material)
        (learning_material_assigned_to_offering ?learning_material ?course_offering)
        (not
          (offering_requires_accreditation_review ?course_offering)
        )
        (offering_requires_partner_endorsement ?course_offering)
        (not
          (template_evidence_linked ?course_template)
        )
      )
    :effect
      (and
        (template_evidence_linked ?course_template)
        (template_ready_for_finalization ?course_template)
      )
  )
  (:action apply_external_evidence_and_mark_template_ready_complete
    :parameters (?course_template - course_template ?external_evidence - external_evidence ?learning_material - learning_material ?course_offering - course_offering)
    :precondition
      (and
        (template_assessment_verified ?course_template)
        (template_attached_external_evidence ?course_template ?external_evidence)
        (template_has_learning_material ?course_template ?learning_material)
        (learning_material_assigned_to_offering ?learning_material ?course_offering)
        (offering_requires_accreditation_review ?course_offering)
        (offering_requires_partner_endorsement ?course_offering)
        (not
          (template_evidence_linked ?course_template)
        )
      )
    :effect
      (and
        (template_evidence_linked ?course_template)
        (template_ready_for_finalization ?course_template)
      )
  )
  (:action finalize_course_template_for_certification
    :parameters (?course_template - course_template)
    :precondition
      (and
        (template_evidence_linked ?course_template)
        (not
          (template_ready_for_finalization ?course_template)
        )
        (not
          (finalization_logged ?course_template)
        )
      )
    :effect
      (and
        (finalization_logged ?course_template)
        (eligible_for_certification ?course_template)
      )
  )
  (:action assign_administrative_resource_to_template
    :parameters (?course_template - course_template ?administrative_resource - administrative_resource)
    :precondition
      (and
        (template_evidence_linked ?course_template)
        (template_ready_for_finalization ?course_template)
        (administrative_resource_available ?administrative_resource)
      )
    :effect
      (and
        (template_has_administrative_resource ?course_template ?administrative_resource)
        (not
          (administrative_resource_available ?administrative_resource)
        )
      )
  )
  (:action complete_template_content_assembly
    :parameters (?course_template - course_template ?academic_program - academic_program ?academic_track - academic_track ?assessment - assessment ?administrative_resource - administrative_resource)
    :precondition
      (and
        (template_evidence_linked ?course_template)
        (template_ready_for_finalization ?course_template)
        (template_has_administrative_resource ?course_template ?administrative_resource)
        (template_required_by_program ?course_template ?academic_program)
        (template_required_by_track ?course_template ?academic_track)
        (program_ready_for_offering ?academic_program)
        (track_ready_for_offering ?academic_track)
        (assigned_assessment_to_entity ?course_template ?assessment)
        (not
          (template_assembly_complete ?course_template)
        )
      )
    :effect (template_assembly_complete ?course_template)
  )
  (:action finalize_course_template_after_assembly
    :parameters (?course_template - course_template)
    :precondition
      (and
        (template_evidence_linked ?course_template)
        (template_assembly_complete ?course_template)
        (not
          (finalization_logged ?course_template)
        )
      )
    :effect
      (and
        (finalization_logged ?course_template)
        (eligible_for_certification ?course_template)
      )
  )
  (:action attach_industry_partner_endorsement
    :parameters (?course_template - course_template ?industry_partner - industry_partner ?assessment - assessment)
    :precondition
      (and
        (eligibility_confirmed_for_academic_entity ?course_template)
        (assigned_assessment_to_entity ?course_template ?assessment)
        (industry_partner_available ?industry_partner)
        (template_has_industry_partner ?course_template ?industry_partner)
        (not
          (template_has_industry_endorsement ?course_template)
        )
      )
    :effect
      (and
        (template_has_industry_endorsement ?course_template)
        (not
          (industry_partner_available ?industry_partner)
        )
      )
  )
  (:action apply_endorsement_validation_step
    :parameters (?course_template - course_template ?instructor - instructor)
    :precondition
      (and
        (template_has_industry_endorsement ?course_template)
        (assigned_instructor_to_entity ?course_template ?instructor)
        (not
          (endorsement_validation_stage1 ?course_template)
        )
      )
    :effect (endorsement_validation_stage1 ?course_template)
  )
  (:action finalize_endorsement_validation_with_evidence
    :parameters (?course_template - course_template ?external_evidence - external_evidence)
    :precondition
      (and
        (endorsement_validation_stage1 ?course_template)
        (template_attached_external_evidence ?course_template ?external_evidence)
        (not
          (endorsement_validation_stage2 ?course_template)
        )
      )
    :effect (endorsement_validation_stage2 ?course_template)
  )
  (:action finalize_template_after_endorsement
    :parameters (?course_template - course_template)
    :precondition
      (and
        (endorsement_validation_stage2 ?course_template)
        (not
          (finalization_logged ?course_template)
        )
      )
    :effect
      (and
        (finalization_logged ?course_template)
        (eligible_for_certification ?course_template)
      )
  )
  (:action award_program_finalization_marker
    :parameters (?academic_program - academic_program ?course_offering - course_offering)
    :precondition
      (and
        (program_slot_and_instructor_confirmed ?academic_program)
        (program_ready_for_offering ?academic_program)
        (offering_prepared ?course_offering)
        (offering_assessment_confirmed ?course_offering)
        (not
          (eligible_for_certification ?academic_program)
        )
      )
    :effect (eligible_for_certification ?academic_program)
  )
  (:action award_track_finalization_marker
    :parameters (?academic_track - academic_track ?course_offering - course_offering)
    :precondition
      (and
        (track_slot_and_instructor_confirmed ?academic_track)
        (track_ready_for_offering ?academic_track)
        (offering_prepared ?course_offering)
        (offering_assessment_confirmed ?course_offering)
        (not
          (eligible_for_certification ?academic_track)
        )
      )
    :effect (eligible_for_certification ?academic_track)
  )
  (:action issue_certification_and_assign_mentorship_token
    :parameters (?academic_entity - academic_entity ?mentorship_token - mentorship_token ?assessment - assessment)
    :precondition
      (and
        (eligible_for_certification ?academic_entity)
        (assigned_assessment_to_entity ?academic_entity ?assessment)
        (mentorship_token_available ?mentorship_token)
        (not
          (certification_issued ?academic_entity)
        )
      )
    :effect
      (and
        (certification_issued ?academic_entity)
        (entity_assigned_mentorship_token ?academic_entity ?mentorship_token)
        (not
          (mentorship_token_available ?mentorship_token)
        )
      )
  )
  (:action finalize_program_completion_and_release_resources
    :parameters (?academic_program - academic_program ?instructional_resource - instructional_resource ?mentorship_token - mentorship_token)
    :precondition
      (and
        (certification_issued ?academic_program)
        (assigned_instructional_resource ?academic_program ?instructional_resource)
        (entity_assigned_mentorship_token ?academic_program ?mentorship_token)
        (not
          (completion_awarded ?academic_program)
        )
      )
    :effect
      (and
        (completion_awarded ?academic_program)
        (resource_available ?instructional_resource)
        (mentorship_token_available ?mentorship_token)
      )
  )
  (:action finalize_track_completion_and_release_resources
    :parameters (?academic_track - academic_track ?instructional_resource - instructional_resource ?mentorship_token - mentorship_token)
    :precondition
      (and
        (certification_issued ?academic_track)
        (assigned_instructional_resource ?academic_track ?instructional_resource)
        (entity_assigned_mentorship_token ?academic_track ?mentorship_token)
        (not
          (completion_awarded ?academic_track)
        )
      )
    :effect
      (and
        (completion_awarded ?academic_track)
        (resource_available ?instructional_resource)
        (mentorship_token_available ?mentorship_token)
      )
  )
  (:action finalize_template_completion_and_release_resources
    :parameters (?course_template - course_template ?instructional_resource - instructional_resource ?mentorship_token - mentorship_token)
    :precondition
      (and
        (certification_issued ?course_template)
        (assigned_instructional_resource ?course_template ?instructional_resource)
        (entity_assigned_mentorship_token ?course_template ?mentorship_token)
        (not
          (completion_awarded ?course_template)
        )
      )
    :effect
      (and
        (completion_awarded ?course_template)
        (resource_available ?instructional_resource)
        (mentorship_token_available ?mentorship_token)
      )
  )
)

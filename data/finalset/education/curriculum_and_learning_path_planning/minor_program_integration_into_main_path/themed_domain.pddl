(define (domain minor_program_integration_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types academic_entity - object administrative_resource - object temporal_entity - object program_category - object student_record - program_category advisor_slot - academic_entity course_offering - academic_entity instructor_approval_token - academic_entity course_category - academic_entity elective_bundle - academic_entity credit_unit - academic_entity accreditation_unit - academic_entity compliance_document - academic_entity curriculum_resource - administrative_resource curriculum_artifact - administrative_resource credential - administrative_resource major_term - temporal_entity minor_term - temporal_entity integration_plan_document - temporal_entity program_container - student_record pathway_container - student_record major_program_instance - program_container minor_program_instance - program_container integration_case - pathway_container)
  (:predicates
    (student_declaration_recorded ?student_record - student_record)
    (integration_active ?student_record - student_record)
    (student_has_advisor ?student_record - student_record)
    (integration_finalized ?student_record - student_record)
    (integration_fully_approved ?student_record - student_record)
    (declaration_acknowledged ?student_record - student_record)
    (advisor_slot_available ?advisor_slot - advisor_slot)
    (advisor_assigned_to_entity ?student_record - student_record ?advisor_slot - advisor_slot)
    (course_seat_available ?course_offering - course_offering)
    (seat_reserved_for_entity ?student_record - student_record ?course_offering - course_offering)
    (approval_token_available ?instructor_approval_token - instructor_approval_token)
    (approval_assigned_to_entity ?student_record - student_record ?instructor_approval_token - instructor_approval_token)
    (curriculum_resource_available ?curriculum_resource - curriculum_resource)
    (program_resource_attached ?major_program_instance - major_program_instance ?curriculum_resource - curriculum_resource)
    (minor_resource_attached ?minor_program_instance - minor_program_instance ?curriculum_resource - curriculum_resource)
    (major_term_assigned ?major_program_instance - major_program_instance ?major_term - major_term)
    (major_term_confirmed ?major_term - major_term)
    (major_term_on_hold ?major_term - major_term)
    (major_program_ready ?major_program_instance - major_program_instance)
    (minor_term_assigned ?minor_program_instance - minor_program_instance ?minor_term - minor_term)
    (minor_term_confirmed ?minor_term - minor_term)
    (minor_term_on_hold ?minor_term - minor_term)
    (minor_program_ready ?minor_program_instance - minor_program_instance)
    (integration_plan_draft ?integration_plan_document - integration_plan_document)
    (integration_plan_active ?integration_plan_document - integration_plan_document)
    (plan_links_major_term ?integration_plan_document - integration_plan_document ?major_term - major_term)
    (plan_links_minor_term ?integration_plan_document - integration_plan_document ?minor_term - minor_term)
    (plan_has_major_confirmation ?integration_plan_document - integration_plan_document)
    (plan_has_minor_confirmation ?integration_plan_document - integration_plan_document)
    (plan_ready_for_artifacts ?integration_plan_document - integration_plan_document)
    (case_links_major_program ?integration_case - integration_case ?major_program_instance - major_program_instance)
    (case_links_minor_program ?integration_case - integration_case ?minor_program_instance - minor_program_instance)
    (case_links_integration_plan ?integration_case - integration_case ?integration_plan_document - integration_plan_document)
    (curriculum_artifact_available ?curriculum_artifact - curriculum_artifact)
    (case_has_curriculum_artifact ?integration_case - integration_case ?curriculum_artifact - curriculum_artifact)
    (curriculum_artifact_committed ?curriculum_artifact - curriculum_artifact)
    (artifact_linked_to_plan ?curriculum_artifact - curriculum_artifact ?integration_plan_document - integration_plan_document)
    (case_artifact_verified ?integration_case - integration_case)
    (case_accreditation_confirmed ?integration_case - integration_case)
    (case_alignment_verified ?integration_case - integration_case)
    (case_course_category_selected ?integration_case - integration_case)
    (case_course_category_confirmed ?integration_case - integration_case)
    (case_elective_bundle_attached ?integration_case - integration_case)
    (case_ready_for_final_review ?integration_case - integration_case)
    (credential_available ?credential - credential)
    (case_has_credential ?integration_case - integration_case ?credential - credential)
    (case_credential_reserved ?integration_case - integration_case)
    (case_credential_approved ?integration_case - integration_case)
    (case_credential_confirmed ?integration_case - integration_case)
    (course_category_available ?course_category - course_category)
    (case_course_category_linked ?integration_case - integration_case ?course_category - course_category)
    (elective_bundle_available ?elective_bundle - elective_bundle)
    (case_elective_bundle_linked ?integration_case - integration_case ?elective_bundle - elective_bundle)
    (accreditation_unit_available ?accreditation_unit - accreditation_unit)
    (case_accreditation_unit_linked ?integration_case - integration_case ?accreditation_unit - accreditation_unit)
    (compliance_document_available ?compliance_document - compliance_document)
    (case_compliance_document_linked ?integration_case - integration_case ?compliance_document - compliance_document)
    (credit_unit_available ?credit_unit - credit_unit)
    (credit_allocated ?student_record - student_record ?credit_unit - credit_unit)
    (program_schedule_confirmed ?major_program_instance - major_program_instance)
    (pathway_schedule_confirmed ?minor_program_instance - minor_program_instance)
    (integration_case_closed ?integration_case - integration_case)
  )
  (:action record_student_declaration
    :parameters (?student_record - student_record)
    :precondition
      (and
        (not
          (student_declaration_recorded ?student_record)
        )
        (not
          (integration_finalized ?student_record)
        )
      )
    :effect (student_declaration_recorded ?student_record)
  )
  (:action assign_advisor_to_student
    :parameters (?student_record - student_record ?advisor_slot - advisor_slot)
    :precondition
      (and
        (student_declaration_recorded ?student_record)
        (not
          (student_has_advisor ?student_record)
        )
        (advisor_slot_available ?advisor_slot)
      )
    :effect
      (and
        (student_has_advisor ?student_record)
        (advisor_assigned_to_entity ?student_record ?advisor_slot)
        (not
          (advisor_slot_available ?advisor_slot)
        )
      )
  )
  (:action request_course_reservation
    :parameters (?student_record - student_record ?course_offering - course_offering)
    :precondition
      (and
        (student_declaration_recorded ?student_record)
        (student_has_advisor ?student_record)
        (course_seat_available ?course_offering)
      )
    :effect
      (and
        (seat_reserved_for_entity ?student_record ?course_offering)
        (not
          (course_seat_available ?course_offering)
        )
      )
  )
  (:action instructor_approve_reservation
    :parameters (?student_record - student_record ?course_offering - course_offering)
    :precondition
      (and
        (student_declaration_recorded ?student_record)
        (student_has_advisor ?student_record)
        (seat_reserved_for_entity ?student_record ?course_offering)
        (not
          (integration_active ?student_record)
        )
      )
    :effect (integration_active ?student_record)
  )
  (:action release_course_reservation
    :parameters (?student_record - student_record ?course_offering - course_offering)
    :precondition
      (and
        (seat_reserved_for_entity ?student_record ?course_offering)
      )
    :effect
      (and
        (course_seat_available ?course_offering)
        (not
          (seat_reserved_for_entity ?student_record ?course_offering)
        )
      )
  )
  (:action assign_instructor_approval
    :parameters (?student_record - student_record ?instructor_approval_token - instructor_approval_token)
    :precondition
      (and
        (integration_active ?student_record)
        (approval_token_available ?instructor_approval_token)
      )
    :effect
      (and
        (approval_assigned_to_entity ?student_record ?instructor_approval_token)
        (not
          (approval_token_available ?instructor_approval_token)
        )
      )
  )
  (:action revoke_instructor_approval
    :parameters (?student_record - student_record ?instructor_approval_token - instructor_approval_token)
    :precondition
      (and
        (approval_assigned_to_entity ?student_record ?instructor_approval_token)
      )
    :effect
      (and
        (approval_token_available ?instructor_approval_token)
        (not
          (approval_assigned_to_entity ?student_record ?instructor_approval_token)
        )
      )
  )
  (:action attach_accreditation_unit
    :parameters (?integration_case - integration_case ?accreditation_unit - accreditation_unit)
    :precondition
      (and
        (integration_active ?integration_case)
        (accreditation_unit_available ?accreditation_unit)
      )
    :effect
      (and
        (case_accreditation_unit_linked ?integration_case ?accreditation_unit)
        (not
          (accreditation_unit_available ?accreditation_unit)
        )
      )
  )
  (:action detach_accreditation_unit
    :parameters (?integration_case - integration_case ?accreditation_unit - accreditation_unit)
    :precondition
      (and
        (case_accreditation_unit_linked ?integration_case ?accreditation_unit)
      )
    :effect
      (and
        (accreditation_unit_available ?accreditation_unit)
        (not
          (case_accreditation_unit_linked ?integration_case ?accreditation_unit)
        )
      )
  )
  (:action attach_compliance_document
    :parameters (?integration_case - integration_case ?compliance_document - compliance_document)
    :precondition
      (and
        (integration_active ?integration_case)
        (compliance_document_available ?compliance_document)
      )
    :effect
      (and
        (case_compliance_document_linked ?integration_case ?compliance_document)
        (not
          (compliance_document_available ?compliance_document)
        )
      )
  )
  (:action detach_compliance_document
    :parameters (?integration_case - integration_case ?compliance_document - compliance_document)
    :precondition
      (and
        (case_compliance_document_linked ?integration_case ?compliance_document)
      )
    :effect
      (and
        (compliance_document_available ?compliance_document)
        (not
          (case_compliance_document_linked ?integration_case ?compliance_document)
        )
      )
  )
  (:action confirm_major_term_allocation
    :parameters (?major_program_instance - major_program_instance ?major_term - major_term ?course_offering - course_offering)
    :precondition
      (and
        (integration_active ?major_program_instance)
        (seat_reserved_for_entity ?major_program_instance ?course_offering)
        (major_term_assigned ?major_program_instance ?major_term)
        (not
          (major_term_confirmed ?major_term)
        )
        (not
          (major_term_on_hold ?major_term)
        )
      )
    :effect (major_term_confirmed ?major_term)
  )
  (:action approve_major_term_with_instructor
    :parameters (?major_program_instance - major_program_instance ?major_term - major_term ?instructor_approval_token - instructor_approval_token)
    :precondition
      (and
        (integration_active ?major_program_instance)
        (approval_assigned_to_entity ?major_program_instance ?instructor_approval_token)
        (major_term_assigned ?major_program_instance ?major_term)
        (major_term_confirmed ?major_term)
        (not
          (program_schedule_confirmed ?major_program_instance)
        )
      )
    :effect
      (and
        (program_schedule_confirmed ?major_program_instance)
        (major_program_ready ?major_program_instance)
      )
  )
  (:action assign_curriculum_resource_to_major_term
    :parameters (?major_program_instance - major_program_instance ?major_term - major_term ?curriculum_resource - curriculum_resource)
    :precondition
      (and
        (integration_active ?major_program_instance)
        (major_term_assigned ?major_program_instance ?major_term)
        (curriculum_resource_available ?curriculum_resource)
        (not
          (program_schedule_confirmed ?major_program_instance)
        )
      )
    :effect
      (and
        (major_term_on_hold ?major_term)
        (program_schedule_confirmed ?major_program_instance)
        (program_resource_attached ?major_program_instance ?curriculum_resource)
        (not
          (curriculum_resource_available ?curriculum_resource)
        )
      )
  )
  (:action apply_major_resource_swap
    :parameters (?major_program_instance - major_program_instance ?major_term - major_term ?course_offering - course_offering ?curriculum_resource - curriculum_resource)
    :precondition
      (and
        (integration_active ?major_program_instance)
        (seat_reserved_for_entity ?major_program_instance ?course_offering)
        (major_term_assigned ?major_program_instance ?major_term)
        (major_term_on_hold ?major_term)
        (program_resource_attached ?major_program_instance ?curriculum_resource)
        (not
          (major_program_ready ?major_program_instance)
        )
      )
    :effect
      (and
        (major_term_confirmed ?major_term)
        (major_program_ready ?major_program_instance)
        (curriculum_resource_available ?curriculum_resource)
        (not
          (program_resource_attached ?major_program_instance ?curriculum_resource)
        )
      )
  )
  (:action confirm_minor_term_allocation
    :parameters (?minor_program_instance - minor_program_instance ?minor_term - minor_term ?course_offering - course_offering)
    :precondition
      (and
        (integration_active ?minor_program_instance)
        (seat_reserved_for_entity ?minor_program_instance ?course_offering)
        (minor_term_assigned ?minor_program_instance ?minor_term)
        (not
          (minor_term_confirmed ?minor_term)
        )
        (not
          (minor_term_on_hold ?minor_term)
        )
      )
    :effect (minor_term_confirmed ?minor_term)
  )
  (:action approve_minor_term_with_instructor
    :parameters (?minor_program_instance - minor_program_instance ?minor_term - minor_term ?instructor_approval_token - instructor_approval_token)
    :precondition
      (and
        (integration_active ?minor_program_instance)
        (approval_assigned_to_entity ?minor_program_instance ?instructor_approval_token)
        (minor_term_assigned ?minor_program_instance ?minor_term)
        (minor_term_confirmed ?minor_term)
        (not
          (pathway_schedule_confirmed ?minor_program_instance)
        )
      )
    :effect
      (and
        (pathway_schedule_confirmed ?minor_program_instance)
        (minor_program_ready ?minor_program_instance)
      )
  )
  (:action assign_curriculum_resource_to_minor_term
    :parameters (?minor_program_instance - minor_program_instance ?minor_term - minor_term ?curriculum_resource - curriculum_resource)
    :precondition
      (and
        (integration_active ?minor_program_instance)
        (minor_term_assigned ?minor_program_instance ?minor_term)
        (curriculum_resource_available ?curriculum_resource)
        (not
          (pathway_schedule_confirmed ?minor_program_instance)
        )
      )
    :effect
      (and
        (minor_term_on_hold ?minor_term)
        (pathway_schedule_confirmed ?minor_program_instance)
        (minor_resource_attached ?minor_program_instance ?curriculum_resource)
        (not
          (curriculum_resource_available ?curriculum_resource)
        )
      )
  )
  (:action apply_minor_resource_swap
    :parameters (?minor_program_instance - minor_program_instance ?minor_term - minor_term ?course_offering - course_offering ?curriculum_resource - curriculum_resource)
    :precondition
      (and
        (integration_active ?minor_program_instance)
        (seat_reserved_for_entity ?minor_program_instance ?course_offering)
        (minor_term_assigned ?minor_program_instance ?minor_term)
        (minor_term_on_hold ?minor_term)
        (minor_resource_attached ?minor_program_instance ?curriculum_resource)
        (not
          (minor_program_ready ?minor_program_instance)
        )
      )
    :effect
      (and
        (minor_term_confirmed ?minor_term)
        (minor_program_ready ?minor_program_instance)
        (curriculum_resource_available ?curriculum_resource)
        (not
          (minor_resource_attached ?minor_program_instance ?curriculum_resource)
        )
      )
  )
  (:action assemble_integration_plan
    :parameters (?major_program_instance - major_program_instance ?minor_program_instance - minor_program_instance ?major_term - major_term ?minor_term - minor_term ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (program_schedule_confirmed ?major_program_instance)
        (pathway_schedule_confirmed ?minor_program_instance)
        (major_term_assigned ?major_program_instance ?major_term)
        (minor_term_assigned ?minor_program_instance ?minor_term)
        (major_term_confirmed ?major_term)
        (minor_term_confirmed ?minor_term)
        (major_program_ready ?major_program_instance)
        (minor_program_ready ?minor_program_instance)
        (integration_plan_draft ?integration_plan_document)
      )
    :effect
      (and
        (integration_plan_active ?integration_plan_document)
        (plan_links_major_term ?integration_plan_document ?major_term)
        (plan_links_minor_term ?integration_plan_document ?minor_term)
        (not
          (integration_plan_draft ?integration_plan_document)
        )
      )
  )
  (:action assemble_integration_plan_with_major_confirmation
    :parameters (?major_program_instance - major_program_instance ?minor_program_instance - minor_program_instance ?major_term - major_term ?minor_term - minor_term ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (program_schedule_confirmed ?major_program_instance)
        (pathway_schedule_confirmed ?minor_program_instance)
        (major_term_assigned ?major_program_instance ?major_term)
        (minor_term_assigned ?minor_program_instance ?minor_term)
        (major_term_on_hold ?major_term)
        (minor_term_confirmed ?minor_term)
        (not
          (major_program_ready ?major_program_instance)
        )
        (minor_program_ready ?minor_program_instance)
        (integration_plan_draft ?integration_plan_document)
      )
    :effect
      (and
        (integration_plan_active ?integration_plan_document)
        (plan_links_major_term ?integration_plan_document ?major_term)
        (plan_links_minor_term ?integration_plan_document ?minor_term)
        (plan_has_major_confirmation ?integration_plan_document)
        (not
          (integration_plan_draft ?integration_plan_document)
        )
      )
  )
  (:action assemble_integration_plan_with_minor_confirmation
    :parameters (?major_program_instance - major_program_instance ?minor_program_instance - minor_program_instance ?major_term - major_term ?minor_term - minor_term ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (program_schedule_confirmed ?major_program_instance)
        (pathway_schedule_confirmed ?minor_program_instance)
        (major_term_assigned ?major_program_instance ?major_term)
        (minor_term_assigned ?minor_program_instance ?minor_term)
        (major_term_confirmed ?major_term)
        (minor_term_on_hold ?minor_term)
        (major_program_ready ?major_program_instance)
        (not
          (minor_program_ready ?minor_program_instance)
        )
        (integration_plan_draft ?integration_plan_document)
      )
    :effect
      (and
        (integration_plan_active ?integration_plan_document)
        (plan_links_major_term ?integration_plan_document ?major_term)
        (plan_links_minor_term ?integration_plan_document ?minor_term)
        (plan_has_minor_confirmation ?integration_plan_document)
        (not
          (integration_plan_draft ?integration_plan_document)
        )
      )
  )
  (:action assemble_integration_plan_fully_confirmed
    :parameters (?major_program_instance - major_program_instance ?minor_program_instance - minor_program_instance ?major_term - major_term ?minor_term - minor_term ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (program_schedule_confirmed ?major_program_instance)
        (pathway_schedule_confirmed ?minor_program_instance)
        (major_term_assigned ?major_program_instance ?major_term)
        (minor_term_assigned ?minor_program_instance ?minor_term)
        (major_term_on_hold ?major_term)
        (minor_term_on_hold ?minor_term)
        (not
          (major_program_ready ?major_program_instance)
        )
        (not
          (minor_program_ready ?minor_program_instance)
        )
        (integration_plan_draft ?integration_plan_document)
      )
    :effect
      (and
        (integration_plan_active ?integration_plan_document)
        (plan_links_major_term ?integration_plan_document ?major_term)
        (plan_links_minor_term ?integration_plan_document ?minor_term)
        (plan_has_major_confirmation ?integration_plan_document)
        (plan_has_minor_confirmation ?integration_plan_document)
        (not
          (integration_plan_draft ?integration_plan_document)
        )
      )
  )
  (:action mark_plan_ready_for_artifacts
    :parameters (?integration_plan_document - integration_plan_document ?major_program_instance - major_program_instance ?course_offering - course_offering)
    :precondition
      (and
        (integration_plan_active ?integration_plan_document)
        (program_schedule_confirmed ?major_program_instance)
        (seat_reserved_for_entity ?major_program_instance ?course_offering)
        (not
          (plan_ready_for_artifacts ?integration_plan_document)
        )
      )
    :effect (plan_ready_for_artifacts ?integration_plan_document)
  )
  (:action attach_curriculum_artifact_to_case
    :parameters (?integration_case - integration_case ?curriculum_artifact - curriculum_artifact ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (integration_active ?integration_case)
        (case_links_integration_plan ?integration_case ?integration_plan_document)
        (case_has_curriculum_artifact ?integration_case ?curriculum_artifact)
        (curriculum_artifact_available ?curriculum_artifact)
        (integration_plan_active ?integration_plan_document)
        (plan_ready_for_artifacts ?integration_plan_document)
        (not
          (curriculum_artifact_committed ?curriculum_artifact)
        )
      )
    :effect
      (and
        (curriculum_artifact_committed ?curriculum_artifact)
        (artifact_linked_to_plan ?curriculum_artifact ?integration_plan_document)
        (not
          (curriculum_artifact_available ?curriculum_artifact)
        )
      )
  )
  (:action verify_curriculum_artifact_and_progress_case
    :parameters (?integration_case - integration_case ?curriculum_artifact - curriculum_artifact ?integration_plan_document - integration_plan_document ?course_offering - course_offering)
    :precondition
      (and
        (integration_active ?integration_case)
        (case_has_curriculum_artifact ?integration_case ?curriculum_artifact)
        (curriculum_artifact_committed ?curriculum_artifact)
        (artifact_linked_to_plan ?curriculum_artifact ?integration_plan_document)
        (seat_reserved_for_entity ?integration_case ?course_offering)
        (not
          (plan_has_major_confirmation ?integration_plan_document)
        )
        (not
          (case_artifact_verified ?integration_case)
        )
      )
    :effect (case_artifact_verified ?integration_case)
  )
  (:action reserve_course_category_for_case
    :parameters (?integration_case - integration_case ?course_category - course_category)
    :precondition
      (and
        (integration_active ?integration_case)
        (course_category_available ?course_category)
        (not
          (case_course_category_selected ?integration_case)
        )
      )
    :effect
      (and
        (case_course_category_selected ?integration_case)
        (case_course_category_linked ?integration_case ?course_category)
        (not
          (course_category_available ?course_category)
        )
      )
  )
  (:action apply_course_category_and_artifact_to_case
    :parameters (?integration_case - integration_case ?curriculum_artifact - curriculum_artifact ?integration_plan_document - integration_plan_document ?course_offering - course_offering ?course_category - course_category)
    :precondition
      (and
        (integration_active ?integration_case)
        (case_has_curriculum_artifact ?integration_case ?curriculum_artifact)
        (curriculum_artifact_committed ?curriculum_artifact)
        (artifact_linked_to_plan ?curriculum_artifact ?integration_plan_document)
        (seat_reserved_for_entity ?integration_case ?course_offering)
        (plan_has_major_confirmation ?integration_plan_document)
        (case_course_category_selected ?integration_case)
        (case_course_category_linked ?integration_case ?course_category)
        (not
          (case_artifact_verified ?integration_case)
        )
      )
    :effect
      (and
        (case_artifact_verified ?integration_case)
        (case_course_category_confirmed ?integration_case)
      )
  )
  (:action confirm_accreditation_attachment_step1
    :parameters (?integration_case - integration_case ?accreditation_unit - accreditation_unit ?instructor_approval_token - instructor_approval_token ?curriculum_artifact - curriculum_artifact ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (case_artifact_verified ?integration_case)
        (case_accreditation_unit_linked ?integration_case ?accreditation_unit)
        (approval_assigned_to_entity ?integration_case ?instructor_approval_token)
        (case_has_curriculum_artifact ?integration_case ?curriculum_artifact)
        (artifact_linked_to_plan ?curriculum_artifact ?integration_plan_document)
        (not
          (plan_has_minor_confirmation ?integration_plan_document)
        )
        (not
          (case_accreditation_confirmed ?integration_case)
        )
      )
    :effect (case_accreditation_confirmed ?integration_case)
  )
  (:action confirm_accreditation_attachment_step2
    :parameters (?integration_case - integration_case ?accreditation_unit - accreditation_unit ?instructor_approval_token - instructor_approval_token ?curriculum_artifact - curriculum_artifact ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (case_artifact_verified ?integration_case)
        (case_accreditation_unit_linked ?integration_case ?accreditation_unit)
        (approval_assigned_to_entity ?integration_case ?instructor_approval_token)
        (case_has_curriculum_artifact ?integration_case ?curriculum_artifact)
        (artifact_linked_to_plan ?curriculum_artifact ?integration_plan_document)
        (plan_has_minor_confirmation ?integration_plan_document)
        (not
          (case_accreditation_confirmed ?integration_case)
        )
      )
    :effect (case_accreditation_confirmed ?integration_case)
  )
  (:action confirm_compliance_and_progress_case
    :parameters (?integration_case - integration_case ?compliance_document - compliance_document ?curriculum_artifact - curriculum_artifact ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (case_accreditation_confirmed ?integration_case)
        (case_compliance_document_linked ?integration_case ?compliance_document)
        (case_has_curriculum_artifact ?integration_case ?curriculum_artifact)
        (artifact_linked_to_plan ?curriculum_artifact ?integration_plan_document)
        (not
          (plan_has_major_confirmation ?integration_plan_document)
        )
        (not
          (plan_has_minor_confirmation ?integration_plan_document)
        )
        (not
          (case_alignment_verified ?integration_case)
        )
      )
    :effect (case_alignment_verified ?integration_case)
  )
  (:action confirm_compliance_and_attach_alignment
    :parameters (?integration_case - integration_case ?compliance_document - compliance_document ?curriculum_artifact - curriculum_artifact ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (case_accreditation_confirmed ?integration_case)
        (case_compliance_document_linked ?integration_case ?compliance_document)
        (case_has_curriculum_artifact ?integration_case ?curriculum_artifact)
        (artifact_linked_to_plan ?curriculum_artifact ?integration_plan_document)
        (plan_has_major_confirmation ?integration_plan_document)
        (not
          (plan_has_minor_confirmation ?integration_plan_document)
        )
        (not
          (case_alignment_verified ?integration_case)
        )
      )
    :effect
      (and
        (case_alignment_verified ?integration_case)
        (case_elective_bundle_attached ?integration_case)
      )
  )
  (:action confirm_compliance_and_attach_alignment_step2
    :parameters (?integration_case - integration_case ?compliance_document - compliance_document ?curriculum_artifact - curriculum_artifact ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (case_accreditation_confirmed ?integration_case)
        (case_compliance_document_linked ?integration_case ?compliance_document)
        (case_has_curriculum_artifact ?integration_case ?curriculum_artifact)
        (artifact_linked_to_plan ?curriculum_artifact ?integration_plan_document)
        (not
          (plan_has_major_confirmation ?integration_plan_document)
        )
        (plan_has_minor_confirmation ?integration_plan_document)
        (not
          (case_alignment_verified ?integration_case)
        )
      )
    :effect
      (and
        (case_alignment_verified ?integration_case)
        (case_elective_bundle_attached ?integration_case)
      )
  )
  (:action confirm_compliance_and_attach_alignment_final
    :parameters (?integration_case - integration_case ?compliance_document - compliance_document ?curriculum_artifact - curriculum_artifact ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (case_accreditation_confirmed ?integration_case)
        (case_compliance_document_linked ?integration_case ?compliance_document)
        (case_has_curriculum_artifact ?integration_case ?curriculum_artifact)
        (artifact_linked_to_plan ?curriculum_artifact ?integration_plan_document)
        (plan_has_major_confirmation ?integration_plan_document)
        (plan_has_minor_confirmation ?integration_plan_document)
        (not
          (case_alignment_verified ?integration_case)
        )
      )
    :effect
      (and
        (case_alignment_verified ?integration_case)
        (case_elective_bundle_attached ?integration_case)
      )
  )
  (:action promote_case_to_ready
    :parameters (?integration_case - integration_case)
    :precondition
      (and
        (case_alignment_verified ?integration_case)
        (not
          (case_elective_bundle_attached ?integration_case)
        )
        (not
          (integration_case_closed ?integration_case)
        )
      )
    :effect
      (and
        (integration_case_closed ?integration_case)
        (integration_fully_approved ?integration_case)
      )
  )
  (:action attach_elective_bundle_to_case
    :parameters (?integration_case - integration_case ?elective_bundle - elective_bundle)
    :precondition
      (and
        (case_alignment_verified ?integration_case)
        (case_elective_bundle_attached ?integration_case)
        (elective_bundle_available ?elective_bundle)
      )
    :effect
      (and
        (case_elective_bundle_linked ?integration_case ?elective_bundle)
        (not
          (elective_bundle_available ?elective_bundle)
        )
      )
  )
  (:action approve_case_for_integration
    :parameters (?integration_case - integration_case ?major_program_instance - major_program_instance ?minor_program_instance - minor_program_instance ?course_offering - course_offering ?elective_bundle - elective_bundle)
    :precondition
      (and
        (case_alignment_verified ?integration_case)
        (case_elective_bundle_attached ?integration_case)
        (case_elective_bundle_linked ?integration_case ?elective_bundle)
        (case_links_major_program ?integration_case ?major_program_instance)
        (case_links_minor_program ?integration_case ?minor_program_instance)
        (major_program_ready ?major_program_instance)
        (minor_program_ready ?minor_program_instance)
        (seat_reserved_for_entity ?integration_case ?course_offering)
        (not
          (case_ready_for_final_review ?integration_case)
        )
      )
    :effect (case_ready_for_final_review ?integration_case)
  )
  (:action finalize_case_after_approval
    :parameters (?integration_case - integration_case)
    :precondition
      (and
        (case_alignment_verified ?integration_case)
        (case_ready_for_final_review ?integration_case)
        (not
          (integration_case_closed ?integration_case)
        )
      )
    :effect
      (and
        (integration_case_closed ?integration_case)
        (integration_fully_approved ?integration_case)
      )
  )
  (:action reserve_credential_for_case
    :parameters (?integration_case - integration_case ?credential - credential ?course_offering - course_offering)
    :precondition
      (and
        (integration_active ?integration_case)
        (seat_reserved_for_entity ?integration_case ?course_offering)
        (credential_available ?credential)
        (case_has_credential ?integration_case ?credential)
        (not
          (case_credential_reserved ?integration_case)
        )
      )
    :effect
      (and
        (case_credential_reserved ?integration_case)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action assign_instructor_for_credential
    :parameters (?integration_case - integration_case ?instructor_approval_token - instructor_approval_token)
    :precondition
      (and
        (case_credential_reserved ?integration_case)
        (approval_assigned_to_entity ?integration_case ?instructor_approval_token)
        (not
          (case_credential_approved ?integration_case)
        )
      )
    :effect (case_credential_approved ?integration_case)
  )
  (:action submit_compliance_for_credential
    :parameters (?integration_case - integration_case ?compliance_document - compliance_document)
    :precondition
      (and
        (case_credential_approved ?integration_case)
        (case_compliance_document_linked ?integration_case ?compliance_document)
        (not
          (case_credential_confirmed ?integration_case)
        )
      )
    :effect (case_credential_confirmed ?integration_case)
  )
  (:action finalize_case_after_credential
    :parameters (?integration_case - integration_case)
    :precondition
      (and
        (case_credential_confirmed ?integration_case)
        (not
          (integration_case_closed ?integration_case)
        )
      )
    :effect
      (and
        (integration_case_closed ?integration_case)
        (integration_fully_approved ?integration_case)
      )
  )
  (:action finalize_major_program_from_plan
    :parameters (?major_program_instance - major_program_instance ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (program_schedule_confirmed ?major_program_instance)
        (major_program_ready ?major_program_instance)
        (integration_plan_active ?integration_plan_document)
        (plan_ready_for_artifacts ?integration_plan_document)
        (not
          (integration_fully_approved ?major_program_instance)
        )
      )
    :effect (integration_fully_approved ?major_program_instance)
  )
  (:action finalize_minor_program_from_plan
    :parameters (?minor_program_instance - minor_program_instance ?integration_plan_document - integration_plan_document)
    :precondition
      (and
        (pathway_schedule_confirmed ?minor_program_instance)
        (minor_program_ready ?minor_program_instance)
        (integration_plan_active ?integration_plan_document)
        (plan_ready_for_artifacts ?integration_plan_document)
        (not
          (integration_fully_approved ?minor_program_instance)
        )
      )
    :effect (integration_fully_approved ?minor_program_instance)
  )
  (:action record_milestone_and_allocate_credit
    :parameters (?student_record - student_record ?credit_unit - credit_unit ?course_offering - course_offering)
    :precondition
      (and
        (integration_fully_approved ?student_record)
        (seat_reserved_for_entity ?student_record ?course_offering)
        (credit_unit_available ?credit_unit)
        (not
          (declaration_acknowledged ?student_record)
        )
      )
    :effect
      (and
        (declaration_acknowledged ?student_record)
        (credit_allocated ?student_record ?credit_unit)
        (not
          (credit_unit_available ?credit_unit)
        )
      )
  )
  (:action apply_credit_transfer_to_major
    :parameters (?major_program_instance - major_program_instance ?advisor_slot - advisor_slot ?credit_unit - credit_unit)
    :precondition
      (and
        (declaration_acknowledged ?major_program_instance)
        (advisor_assigned_to_entity ?major_program_instance ?advisor_slot)
        (credit_allocated ?major_program_instance ?credit_unit)
        (not
          (integration_finalized ?major_program_instance)
        )
      )
    :effect
      (and
        (integration_finalized ?major_program_instance)
        (advisor_slot_available ?advisor_slot)
        (credit_unit_available ?credit_unit)
      )
  )
  (:action apply_credit_transfer_to_minor
    :parameters (?minor_program_instance - minor_program_instance ?advisor_slot - advisor_slot ?credit_unit - credit_unit)
    :precondition
      (and
        (declaration_acknowledged ?minor_program_instance)
        (advisor_assigned_to_entity ?minor_program_instance ?advisor_slot)
        (credit_allocated ?minor_program_instance ?credit_unit)
        (not
          (integration_finalized ?minor_program_instance)
        )
      )
    :effect
      (and
        (integration_finalized ?minor_program_instance)
        (advisor_slot_available ?advisor_slot)
        (credit_unit_available ?credit_unit)
      )
  )
  (:action apply_credit_transfer_to_case
    :parameters (?integration_case - integration_case ?advisor_slot - advisor_slot ?credit_unit - credit_unit)
    :precondition
      (and
        (declaration_acknowledged ?integration_case)
        (advisor_assigned_to_entity ?integration_case ?advisor_slot)
        (credit_allocated ?integration_case ?credit_unit)
        (not
          (integration_finalized ?integration_case)
        )
      )
    :effect
      (and
        (integration_finalized ?integration_case)
        (advisor_slot_available ?advisor_slot)
        (credit_unit_available ?credit_unit)
      )
  )
)

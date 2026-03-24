(define (domain specialization_track_choice_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types base_object - object academic_resource_root - base_object academic_artifact_root - base_object actor_resource_root - base_object planning_subject_root - base_object planning_subject - planning_subject_root specialization_slot - academic_resource_root course_offering - academic_resource_root advisor_slot - academic_resource_root elective_bundle - academic_resource_root assessment_option - academic_resource_root external_partner - academic_resource_root credential_requirement - academic_resource_root capstone_project - academic_resource_root elective_option - academic_artifact_root supporting_document - academic_artifact_root track_option - academic_artifact_root requirement_category - actor_resource_root milestone_checkpoint - actor_resource_root specialization_proposal - actor_resource_root person_or_cohort_category - planning_subject plan_container_category - planning_subject student_candidate - person_or_cohort_category cohort_candidate - person_or_cohort_category learning_plan - plan_container_category)

  (:predicates
    (participant_initialized ?subject - planning_subject)
    (participant_ready_for_proposal ?subject - planning_subject)
    (participant_slot_reserved ?subject - planning_subject)
    (participant_external_partner_binding_finalized ?subject - planning_subject)
    (specialization_committed ?subject - planning_subject)
    (participant_external_partner_assigned ?subject - planning_subject)
    (specialization_slot_available ?specialization_slot - specialization_slot)
    (participant_assigned_specialization_slot ?subject - planning_subject ?specialization_slot - specialization_slot)
    (course_offering_available ?course_offering - course_offering)
    (participant_enrolled_in_offering ?subject - planning_subject ?course_offering - course_offering)
    (advisor_slot_available ?advisor_slot - advisor_slot)
    (participant_assigned_advisor ?subject - planning_subject ?advisor_slot - advisor_slot)
    (elective_option_available ?elective_option - elective_option)
    (student_consumed_elective ?student - student_candidate ?elective_option - elective_option)
    (cohort_consumed_elective ?cohort - cohort_candidate ?elective_option - elective_option)
    (student_assigned_requirement ?student - student_candidate ?requirement_category - requirement_category)
    (requirement_evidence_recorded ?requirement_category - requirement_category)
    (requirement_fulfilled_by_elective ?requirement_category - requirement_category)
    (student_requirement_satisfied ?student - student_candidate)
    (cohort_assigned_milestone ?cohort - cohort_candidate ?milestone_checkpoint - milestone_checkpoint)
    (milestone_evidence_recorded ?milestone_checkpoint - milestone_checkpoint)
    (milestone_fulfilled_by_elective ?milestone_checkpoint - milestone_checkpoint)
    (cohort_milestone_confirmed ?cohort - cohort_candidate)
    (specialization_proposal_token_available ?specialization_proposal - specialization_proposal)
    (specialization_proposal_reserved ?specialization_proposal - specialization_proposal)
    (proposal_covers_requirement ?specialization_proposal - specialization_proposal ?requirement_category - requirement_category)
    (proposal_covers_milestone ?specialization_proposal - specialization_proposal ?milestone_checkpoint - milestone_checkpoint)
    (proposal_requirement_elective_flag ?specialization_proposal - specialization_proposal)
    (proposal_milestone_elective_flag ?specialization_proposal - specialization_proposal)
    (proposal_course_locked ?specialization_proposal - specialization_proposal)
    (plan_associated_student ?learning_plan - learning_plan ?student - student_candidate)
    (plan_associated_cohort ?learning_plan - learning_plan ?cohort - cohort_candidate)
    (plan_has_proposal ?learning_plan - learning_plan ?specialization_proposal - specialization_proposal)
    (supporting_document_available ?supporting_document - supporting_document)
    (plan_attached_document ?learning_plan - learning_plan ?supporting_document - supporting_document)
    (supporting_document_registered ?supporting_document - supporting_document)
    (supporting_document_linked_to_proposal ?supporting_document - supporting_document ?specialization_proposal - specialization_proposal)
    (plan_attribute_validated_stage1 ?learning_plan - learning_plan)
    (plan_credential_confirmed ?learning_plan - learning_plan)
    (plan_capstone_registered ?learning_plan - learning_plan)
    (plan_elective_bundle_flag ?learning_plan - learning_plan)
    (plan_attribute_validated_stage2 ?learning_plan - learning_plan)
    (plan_admin_package_attached ?learning_plan - learning_plan)
    (plan_final_checks_completed ?learning_plan - learning_plan)
    (track_option_available ?track_option - track_option)
    (plan_assigned_track_option ?learning_plan - learning_plan ?track_option - track_option)
    (plan_track_option_confirmed ?learning_plan - learning_plan)
    (plan_track_option_ready ?learning_plan - learning_plan)
    (plan_track_option_validated ?learning_plan - learning_plan)
    (elective_bundle_available ?elective_bundle - elective_bundle)
    (plan_assigned_elective_bundle ?learning_plan - learning_plan ?elective_bundle - elective_bundle)
    (assessment_option_available ?assessment_option - assessment_option)
    (plan_assigned_assessment_option ?learning_plan - learning_plan ?assessment_option - assessment_option)
    (credential_requirement_available ?credential_requirement - credential_requirement)
    (plan_assigned_credential_requirement ?learning_plan - learning_plan ?credential_requirement - credential_requirement)
    (capstone_project_available ?capstone_project - capstone_project)
    (plan_assigned_capstone_project ?learning_plan - learning_plan ?capstone_project - capstone_project)
    (external_partner_available ?external_partner - external_partner)
    (participant_bound_to_external_partner ?subject - planning_subject ?external_partner - external_partner)
    (student_ready_for_proposal ?student - student_candidate)
    (cohort_ready_for_proposal ?cohort - cohort_candidate)
    (plan_final_signoff ?learning_plan - learning_plan)
  )
  (:action initialize_planning_subject
    :parameters (?subject - planning_subject)
    :precondition
      (and
        (not
          (participant_initialized ?subject)
        )
        (not
          (participant_external_partner_binding_finalized ?subject)
        )
      )
    :effect (participant_initialized ?subject)
  )
  (:action reserve_specialization_slot_for_subject
    :parameters (?subject - planning_subject ?specialization_slot - specialization_slot)
    :precondition
      (and
        (participant_initialized ?subject)
        (not
          (participant_slot_reserved ?subject)
        )
        (specialization_slot_available ?specialization_slot)
      )
    :effect
      (and
        (participant_slot_reserved ?subject)
        (participant_assigned_specialization_slot ?subject ?specialization_slot)
        (not
          (specialization_slot_available ?specialization_slot)
        )
      )
  )
  (:action enroll_subject_in_offering
    :parameters (?subject - planning_subject ?course_offering - course_offering)
    :precondition
      (and
        (participant_initialized ?subject)
        (participant_slot_reserved ?subject)
        (course_offering_available ?course_offering)
      )
    :effect
      (and
        (participant_enrolled_in_offering ?subject ?course_offering)
        (not
          (course_offering_available ?course_offering)
        )
      )
  )
  (:action confirm_subject_enrollment
    :parameters (?subject - planning_subject ?course_offering - course_offering)
    :precondition
      (and
        (participant_initialized ?subject)
        (participant_slot_reserved ?subject)
        (participant_enrolled_in_offering ?subject ?course_offering)
        (not
          (participant_ready_for_proposal ?subject)
        )
      )
    :effect (participant_ready_for_proposal ?subject)
  )
  (:action withdraw_subject_from_offering
    :parameters (?subject - planning_subject ?course_offering - course_offering)
    :precondition
      (and
        (participant_enrolled_in_offering ?subject ?course_offering)
      )
    :effect
      (and
        (course_offering_available ?course_offering)
        (not
          (participant_enrolled_in_offering ?subject ?course_offering)
        )
      )
  )
  (:action reserve_advisor_for_subject
    :parameters (?subject - planning_subject ?advisor_slot - advisor_slot)
    :precondition
      (and
        (participant_ready_for_proposal ?subject)
        (advisor_slot_available ?advisor_slot)
      )
    :effect
      (and
        (participant_assigned_advisor ?subject ?advisor_slot)
        (not
          (advisor_slot_available ?advisor_slot)
        )
      )
  )
  (:action release_advisor_from_subject
    :parameters (?subject - planning_subject ?advisor_slot - advisor_slot)
    :precondition
      (and
        (participant_assigned_advisor ?subject ?advisor_slot)
      )
    :effect
      (and
        (advisor_slot_available ?advisor_slot)
        (not
          (participant_assigned_advisor ?subject ?advisor_slot)
        )
      )
  )
  (:action reserve_credential_requirement_for_plan
    :parameters (?learning_plan - learning_plan ?credential_requirement - credential_requirement)
    :precondition
      (and
        (participant_ready_for_proposal ?learning_plan)
        (credential_requirement_available ?credential_requirement)
      )
    :effect
      (and
        (plan_assigned_credential_requirement ?learning_plan ?credential_requirement)
        (not
          (credential_requirement_available ?credential_requirement)
        )
      )
  )
  (:action release_credential_requirement_from_plan
    :parameters (?learning_plan - learning_plan ?credential_requirement - credential_requirement)
    :precondition
      (and
        (plan_assigned_credential_requirement ?learning_plan ?credential_requirement)
      )
    :effect
      (and
        (credential_requirement_available ?credential_requirement)
        (not
          (plan_assigned_credential_requirement ?learning_plan ?credential_requirement)
        )
      )
  )
  (:action reserve_capstone_for_plan
    :parameters (?learning_plan - learning_plan ?capstone_project - capstone_project)
    :precondition
      (and
        (participant_ready_for_proposal ?learning_plan)
        (capstone_project_available ?capstone_project)
      )
    :effect
      (and
        (plan_assigned_capstone_project ?learning_plan ?capstone_project)
        (not
          (capstone_project_available ?capstone_project)
        )
      )
  )
  (:action release_capstone_from_plan
    :parameters (?learning_plan - learning_plan ?capstone_project - capstone_project)
    :precondition
      (and
        (plan_assigned_capstone_project ?learning_plan ?capstone_project)
      )
    :effect
      (and
        (capstone_project_available ?capstone_project)
        (not
          (plan_assigned_capstone_project ?learning_plan ?capstone_project)
        )
      )
  )
  (:action record_requirement_evidence_for_student
    :parameters (?student - student_candidate ?requirement_category - requirement_category ?course_offering - course_offering)
    :precondition
      (and
        (participant_ready_for_proposal ?student)
        (participant_enrolled_in_offering ?student ?course_offering)
        (student_assigned_requirement ?student ?requirement_category)
        (not
          (requirement_evidence_recorded ?requirement_category)
        )
        (not
          (requirement_fulfilled_by_elective ?requirement_category)
        )
      )
    :effect (requirement_evidence_recorded ?requirement_category)
  )
  (:action verify_student_requirement_with_advisor
    :parameters (?student - student_candidate ?requirement_category - requirement_category ?advisor_slot - advisor_slot)
    :precondition
      (and
        (participant_ready_for_proposal ?student)
        (participant_assigned_advisor ?student ?advisor_slot)
        (student_assigned_requirement ?student ?requirement_category)
        (requirement_evidence_recorded ?requirement_category)
        (not
          (student_ready_for_proposal ?student)
        )
      )
    :effect
      (and
        (student_ready_for_proposal ?student)
        (student_requirement_satisfied ?student)
      )
  )
  (:action apply_elective_for_student_requirement
    :parameters (?student - student_candidate ?requirement_category - requirement_category ?elective_option - elective_option)
    :precondition
      (and
        (participant_ready_for_proposal ?student)
        (student_assigned_requirement ?student ?requirement_category)
        (elective_option_available ?elective_option)
        (not
          (student_ready_for_proposal ?student)
        )
      )
    :effect
      (and
        (requirement_fulfilled_by_elective ?requirement_category)
        (student_ready_for_proposal ?student)
        (student_consumed_elective ?student ?elective_option)
        (not
          (elective_option_available ?elective_option)
        )
      )
  )
  (:action finalize_student_requirement_and_restore_elective
    :parameters (?student - student_candidate ?requirement_category - requirement_category ?course_offering - course_offering ?elective_option - elective_option)
    :precondition
      (and
        (participant_ready_for_proposal ?student)
        (participant_enrolled_in_offering ?student ?course_offering)
        (student_assigned_requirement ?student ?requirement_category)
        (requirement_fulfilled_by_elective ?requirement_category)
        (student_consumed_elective ?student ?elective_option)
        (not
          (student_requirement_satisfied ?student)
        )
      )
    :effect
      (and
        (requirement_evidence_recorded ?requirement_category)
        (student_requirement_satisfied ?student)
        (elective_option_available ?elective_option)
        (not
          (student_consumed_elective ?student ?elective_option)
        )
      )
  )
  (:action record_milestone_evidence_for_cohort
    :parameters (?cohort - cohort_candidate ?milestone_checkpoint - milestone_checkpoint ?course_offering - course_offering)
    :precondition
      (and
        (participant_ready_for_proposal ?cohort)
        (participant_enrolled_in_offering ?cohort ?course_offering)
        (cohort_assigned_milestone ?cohort ?milestone_checkpoint)
        (not
          (milestone_evidence_recorded ?milestone_checkpoint)
        )
        (not
          (milestone_fulfilled_by_elective ?milestone_checkpoint)
        )
      )
    :effect (milestone_evidence_recorded ?milestone_checkpoint)
  )
  (:action verify_cohort_milestone_with_advisor
    :parameters (?cohort - cohort_candidate ?milestone_checkpoint - milestone_checkpoint ?advisor_slot - advisor_slot)
    :precondition
      (and
        (participant_ready_for_proposal ?cohort)
        (participant_assigned_advisor ?cohort ?advisor_slot)
        (cohort_assigned_milestone ?cohort ?milestone_checkpoint)
        (milestone_evidence_recorded ?milestone_checkpoint)
        (not
          (cohort_ready_for_proposal ?cohort)
        )
      )
    :effect
      (and
        (cohort_ready_for_proposal ?cohort)
        (cohort_milestone_confirmed ?cohort)
      )
  )
  (:action apply_elective_for_cohort_milestone
    :parameters (?cohort - cohort_candidate ?milestone_checkpoint - milestone_checkpoint ?elective_option - elective_option)
    :precondition
      (and
        (participant_ready_for_proposal ?cohort)
        (cohort_assigned_milestone ?cohort ?milestone_checkpoint)
        (elective_option_available ?elective_option)
        (not
          (cohort_ready_for_proposal ?cohort)
        )
      )
    :effect
      (and
        (milestone_fulfilled_by_elective ?milestone_checkpoint)
        (cohort_ready_for_proposal ?cohort)
        (cohort_consumed_elective ?cohort ?elective_option)
        (not
          (elective_option_available ?elective_option)
        )
      )
  )
  (:action finalize_cohort_milestone_and_restore_elective
    :parameters (?cohort - cohort_candidate ?milestone_checkpoint - milestone_checkpoint ?course_offering - course_offering ?elective_option - elective_option)
    :precondition
      (and
        (participant_ready_for_proposal ?cohort)
        (participant_enrolled_in_offering ?cohort ?course_offering)
        (cohort_assigned_milestone ?cohort ?milestone_checkpoint)
        (milestone_fulfilled_by_elective ?milestone_checkpoint)
        (cohort_consumed_elective ?cohort ?elective_option)
        (not
          (cohort_milestone_confirmed ?cohort)
        )
      )
    :effect
      (and
        (milestone_evidence_recorded ?milestone_checkpoint)
        (cohort_milestone_confirmed ?cohort)
        (elective_option_available ?elective_option)
        (not
          (cohort_consumed_elective ?cohort ?elective_option)
        )
      )
  )
  (:action assemble_specialization_proposal
    :parameters (?student - student_candidate ?cohort - cohort_candidate ?requirement_category - requirement_category ?milestone_checkpoint - milestone_checkpoint ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (student_ready_for_proposal ?student)
        (cohort_ready_for_proposal ?cohort)
        (student_assigned_requirement ?student ?requirement_category)
        (cohort_assigned_milestone ?cohort ?milestone_checkpoint)
        (requirement_evidence_recorded ?requirement_category)
        (milestone_evidence_recorded ?milestone_checkpoint)
        (student_requirement_satisfied ?student)
        (cohort_milestone_confirmed ?cohort)
        (specialization_proposal_token_available ?specialization_proposal)
      )
    :effect
      (and
        (specialization_proposal_reserved ?specialization_proposal)
        (proposal_covers_requirement ?specialization_proposal ?requirement_category)
        (proposal_covers_milestone ?specialization_proposal ?milestone_checkpoint)
        (not
          (specialization_proposal_token_available ?specialization_proposal)
        )
      )
  )
  (:action assemble_specialization_proposal_with_requirement_elective
    :parameters (?student - student_candidate ?cohort - cohort_candidate ?requirement_category - requirement_category ?milestone_checkpoint - milestone_checkpoint ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (student_ready_for_proposal ?student)
        (cohort_ready_for_proposal ?cohort)
        (student_assigned_requirement ?student ?requirement_category)
        (cohort_assigned_milestone ?cohort ?milestone_checkpoint)
        (requirement_fulfilled_by_elective ?requirement_category)
        (milestone_evidence_recorded ?milestone_checkpoint)
        (not
          (student_requirement_satisfied ?student)
        )
        (cohort_milestone_confirmed ?cohort)
        (specialization_proposal_token_available ?specialization_proposal)
      )
    :effect
      (and
        (specialization_proposal_reserved ?specialization_proposal)
        (proposal_covers_requirement ?specialization_proposal ?requirement_category)
        (proposal_covers_milestone ?specialization_proposal ?milestone_checkpoint)
        (proposal_requirement_elective_flag ?specialization_proposal)
        (not
          (specialization_proposal_token_available ?specialization_proposal)
        )
      )
  )
  (:action assemble_specialization_proposal_with_milestone_elective
    :parameters (?student - student_candidate ?cohort - cohort_candidate ?requirement_category - requirement_category ?milestone_checkpoint - milestone_checkpoint ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (student_ready_for_proposal ?student)
        (cohort_ready_for_proposal ?cohort)
        (student_assigned_requirement ?student ?requirement_category)
        (cohort_assigned_milestone ?cohort ?milestone_checkpoint)
        (requirement_evidence_recorded ?requirement_category)
        (milestone_fulfilled_by_elective ?milestone_checkpoint)
        (student_requirement_satisfied ?student)
        (not
          (cohort_milestone_confirmed ?cohort)
        )
        (specialization_proposal_token_available ?specialization_proposal)
      )
    :effect
      (and
        (specialization_proposal_reserved ?specialization_proposal)
        (proposal_covers_requirement ?specialization_proposal ?requirement_category)
        (proposal_covers_milestone ?specialization_proposal ?milestone_checkpoint)
        (proposal_milestone_elective_flag ?specialization_proposal)
        (not
          (specialization_proposal_token_available ?specialization_proposal)
        )
      )
  )
  (:action assemble_specialization_proposal_with_both_electives
    :parameters (?student - student_candidate ?cohort - cohort_candidate ?requirement_category - requirement_category ?milestone_checkpoint - milestone_checkpoint ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (student_ready_for_proposal ?student)
        (cohort_ready_for_proposal ?cohort)
        (student_assigned_requirement ?student ?requirement_category)
        (cohort_assigned_milestone ?cohort ?milestone_checkpoint)
        (requirement_fulfilled_by_elective ?requirement_category)
        (milestone_fulfilled_by_elective ?milestone_checkpoint)
        (not
          (student_requirement_satisfied ?student)
        )
        (not
          (cohort_milestone_confirmed ?cohort)
        )
        (specialization_proposal_token_available ?specialization_proposal)
      )
    :effect
      (and
        (specialization_proposal_reserved ?specialization_proposal)
        (proposal_covers_requirement ?specialization_proposal ?requirement_category)
        (proposal_covers_milestone ?specialization_proposal ?milestone_checkpoint)
        (proposal_requirement_elective_flag ?specialization_proposal)
        (proposal_milestone_elective_flag ?specialization_proposal)
        (not
          (specialization_proposal_token_available ?specialization_proposal)
        )
      )
  )
  (:action lock_proposal_for_course_association
    :parameters (?specialization_proposal - specialization_proposal ?student - student_candidate ?course_offering - course_offering)
    :precondition
      (and
        (specialization_proposal_reserved ?specialization_proposal)
        (student_ready_for_proposal ?student)
        (participant_enrolled_in_offering ?student ?course_offering)
        (not
          (proposal_course_locked ?specialization_proposal)
        )
      )
    :effect (proposal_course_locked ?specialization_proposal)
  )
  (:action register_supporting_document_for_proposal
    :parameters (?learning_plan - learning_plan ?supporting_document - supporting_document ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (participant_ready_for_proposal ?learning_plan)
        (plan_has_proposal ?learning_plan ?specialization_proposal)
        (plan_attached_document ?learning_plan ?supporting_document)
        (supporting_document_available ?supporting_document)
        (specialization_proposal_reserved ?specialization_proposal)
        (proposal_course_locked ?specialization_proposal)
        (not
          (supporting_document_registered ?supporting_document)
        )
      )
    :effect
      (and
        (supporting_document_registered ?supporting_document)
        (supporting_document_linked_to_proposal ?supporting_document ?specialization_proposal)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action validate_document_and_mark_plan
    :parameters (?learning_plan - learning_plan ?supporting_document - supporting_document ?specialization_proposal - specialization_proposal ?course_offering - course_offering)
    :precondition
      (and
        (participant_ready_for_proposal ?learning_plan)
        (plan_attached_document ?learning_plan ?supporting_document)
        (supporting_document_registered ?supporting_document)
        (supporting_document_linked_to_proposal ?supporting_document ?specialization_proposal)
        (participant_enrolled_in_offering ?learning_plan ?course_offering)
        (not
          (proposal_requirement_elective_flag ?specialization_proposal)
        )
        (not
          (plan_attribute_validated_stage1 ?learning_plan)
        )
      )
    :effect (plan_attribute_validated_stage1 ?learning_plan)
  )
  (:action assign_elective_bundle_to_plan
    :parameters (?learning_plan - learning_plan ?elective_bundle - elective_bundle)
    :precondition
      (and
        (participant_ready_for_proposal ?learning_plan)
        (elective_bundle_available ?elective_bundle)
        (not
          (plan_elective_bundle_flag ?learning_plan)
        )
      )
    :effect
      (and
        (plan_elective_bundle_flag ?learning_plan)
        (plan_assigned_elective_bundle ?learning_plan ?elective_bundle)
        (not
          (elective_bundle_available ?elective_bundle)
        )
      )
  )
  (:action validate_plan_elective_bundle_and_documents
    :parameters (?learning_plan - learning_plan ?supporting_document - supporting_document ?specialization_proposal - specialization_proposal ?course_offering - course_offering ?elective_bundle - elective_bundle)
    :precondition
      (and
        (participant_ready_for_proposal ?learning_plan)
        (plan_attached_document ?learning_plan ?supporting_document)
        (supporting_document_registered ?supporting_document)
        (supporting_document_linked_to_proposal ?supporting_document ?specialization_proposal)
        (participant_enrolled_in_offering ?learning_plan ?course_offering)
        (proposal_requirement_elective_flag ?specialization_proposal)
        (plan_elective_bundle_flag ?learning_plan)
        (plan_assigned_elective_bundle ?learning_plan ?elective_bundle)
        (not
          (plan_attribute_validated_stage1 ?learning_plan)
        )
      )
    :effect
      (and
        (plan_attribute_validated_stage1 ?learning_plan)
        (plan_attribute_validated_stage2 ?learning_plan)
      )
  )
  (:action confirm_plan_credential_requirement
    :parameters (?learning_plan - learning_plan ?credential_requirement - credential_requirement ?advisor_slot - advisor_slot ?supporting_document - supporting_document ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (plan_attribute_validated_stage1 ?learning_plan)
        (plan_assigned_credential_requirement ?learning_plan ?credential_requirement)
        (participant_assigned_advisor ?learning_plan ?advisor_slot)
        (plan_attached_document ?learning_plan ?supporting_document)
        (supporting_document_linked_to_proposal ?supporting_document ?specialization_proposal)
        (not
          (proposal_milestone_elective_flag ?specialization_proposal)
        )
        (not
          (plan_credential_confirmed ?learning_plan)
        )
      )
    :effect (plan_credential_confirmed ?learning_plan)
  )
  (:action confirm_plan_credential_requirement_alternative
    :parameters (?learning_plan - learning_plan ?credential_requirement - credential_requirement ?advisor_slot - advisor_slot ?supporting_document - supporting_document ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (plan_attribute_validated_stage1 ?learning_plan)
        (plan_assigned_credential_requirement ?learning_plan ?credential_requirement)
        (participant_assigned_advisor ?learning_plan ?advisor_slot)
        (plan_attached_document ?learning_plan ?supporting_document)
        (supporting_document_linked_to_proposal ?supporting_document ?specialization_proposal)
        (proposal_milestone_elective_flag ?specialization_proposal)
        (not
          (plan_credential_confirmed ?learning_plan)
        )
      )
    :effect (plan_credential_confirmed ?learning_plan)
  )
  (:action register_capstone_for_plan
    :parameters (?learning_plan - learning_plan ?capstone_project - capstone_project ?supporting_document - supporting_document ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (plan_credential_confirmed ?learning_plan)
        (plan_assigned_capstone_project ?learning_plan ?capstone_project)
        (plan_attached_document ?learning_plan ?supporting_document)
        (supporting_document_linked_to_proposal ?supporting_document ?specialization_proposal)
        (not
          (proposal_requirement_elective_flag ?specialization_proposal)
        )
        (not
          (proposal_milestone_elective_flag ?specialization_proposal)
        )
        (not
          (plan_capstone_registered ?learning_plan)
        )
      )
    :effect (plan_capstone_registered ?learning_plan)
  )
  (:action register_capstone_and_attach_admin_package
    :parameters (?learning_plan - learning_plan ?capstone_project - capstone_project ?supporting_document - supporting_document ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (plan_credential_confirmed ?learning_plan)
        (plan_assigned_capstone_project ?learning_plan ?capstone_project)
        (plan_attached_document ?learning_plan ?supporting_document)
        (supporting_document_linked_to_proposal ?supporting_document ?specialization_proposal)
        (proposal_requirement_elective_flag ?specialization_proposal)
        (not
          (proposal_milestone_elective_flag ?specialization_proposal)
        )
        (not
          (plan_capstone_registered ?learning_plan)
        )
      )
    :effect
      (and
        (plan_capstone_registered ?learning_plan)
        (plan_admin_package_attached ?learning_plan)
      )
  )
  (:action register_capstone_and_attach_admin_package_alt
    :parameters (?learning_plan - learning_plan ?capstone_project - capstone_project ?supporting_document - supporting_document ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (plan_credential_confirmed ?learning_plan)
        (plan_assigned_capstone_project ?learning_plan ?capstone_project)
        (plan_attached_document ?learning_plan ?supporting_document)
        (supporting_document_linked_to_proposal ?supporting_document ?specialization_proposal)
        (not
          (proposal_requirement_elective_flag ?specialization_proposal)
        )
        (proposal_milestone_elective_flag ?specialization_proposal)
        (not
          (plan_capstone_registered ?learning_plan)
        )
      )
    :effect
      (and
        (plan_capstone_registered ?learning_plan)
        (plan_admin_package_attached ?learning_plan)
      )
  )
  (:action register_capstone_and_attach_admin_package_combined
    :parameters (?learning_plan - learning_plan ?capstone_project - capstone_project ?supporting_document - supporting_document ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (plan_credential_confirmed ?learning_plan)
        (plan_assigned_capstone_project ?learning_plan ?capstone_project)
        (plan_attached_document ?learning_plan ?supporting_document)
        (supporting_document_linked_to_proposal ?supporting_document ?specialization_proposal)
        (proposal_requirement_elective_flag ?specialization_proposal)
        (proposal_milestone_elective_flag ?specialization_proposal)
        (not
          (plan_capstone_registered ?learning_plan)
        )
      )
    :effect
      (and
        (plan_capstone_registered ?learning_plan)
        (plan_admin_package_attached ?learning_plan)
      )
  )
  (:action finalize_plan_signoff
    :parameters (?learning_plan - learning_plan)
    :precondition
      (and
        (plan_capstone_registered ?learning_plan)
        (not
          (plan_admin_package_attached ?learning_plan)
        )
        (not
          (plan_final_signoff ?learning_plan)
        )
      )
    :effect
      (and
        (plan_final_signoff ?learning_plan)
        (specialization_committed ?learning_plan)
      )
  )
  (:action attach_assessment_option_to_plan
    :parameters (?learning_plan - learning_plan ?assessment_option - assessment_option)
    :precondition
      (and
        (plan_capstone_registered ?learning_plan)
        (plan_admin_package_attached ?learning_plan)
        (assessment_option_available ?assessment_option)
      )
    :effect
      (and
        (plan_assigned_assessment_option ?learning_plan ?assessment_option)
        (not
          (assessment_option_available ?assessment_option)
        )
      )
  )
  (:action complete_plan_readiness_checks
    :parameters (?learning_plan - learning_plan ?student - student_candidate ?cohort - cohort_candidate ?course_offering - course_offering ?assessment_option - assessment_option)
    :precondition
      (and
        (plan_capstone_registered ?learning_plan)
        (plan_admin_package_attached ?learning_plan)
        (plan_assigned_assessment_option ?learning_plan ?assessment_option)
        (plan_associated_student ?learning_plan ?student)
        (plan_associated_cohort ?learning_plan ?cohort)
        (student_requirement_satisfied ?student)
        (cohort_milestone_confirmed ?cohort)
        (participant_enrolled_in_offering ?learning_plan ?course_offering)
        (not
          (plan_final_checks_completed ?learning_plan)
        )
      )
    :effect (plan_final_checks_completed ?learning_plan)
  )
  (:action finalize_plan_signoff_after_checks
    :parameters (?learning_plan - learning_plan)
    :precondition
      (and
        (plan_capstone_registered ?learning_plan)
        (plan_final_checks_completed ?learning_plan)
        (not
          (plan_final_signoff ?learning_plan)
        )
      )
    :effect
      (and
        (plan_final_signoff ?learning_plan)
        (specialization_committed ?learning_plan)
      )
  )
  (:action activate_plan_track_option
    :parameters (?learning_plan - learning_plan ?track_option - track_option ?course_offering - course_offering)
    :precondition
      (and
        (participant_ready_for_proposal ?learning_plan)
        (participant_enrolled_in_offering ?learning_plan ?course_offering)
        (track_option_available ?track_option)
        (plan_assigned_track_option ?learning_plan ?track_option)
        (not
          (plan_track_option_confirmed ?learning_plan)
        )
      )
    :effect
      (and
        (plan_track_option_confirmed ?learning_plan)
        (not
          (track_option_available ?track_option)
        )
      )
  )
  (:action prepare_plan_track_option_validation
    :parameters (?learning_plan - learning_plan ?advisor_slot - advisor_slot)
    :precondition
      (and
        (plan_track_option_confirmed ?learning_plan)
        (participant_assigned_advisor ?learning_plan ?advisor_slot)
        (not
          (plan_track_option_ready ?learning_plan)
        )
      )
    :effect (plan_track_option_ready ?learning_plan)
  )
  (:action validate_plan_track_option_with_capstone
    :parameters (?learning_plan - learning_plan ?capstone_project - capstone_project)
    :precondition
      (and
        (plan_track_option_ready ?learning_plan)
        (plan_assigned_capstone_project ?learning_plan ?capstone_project)
        (not
          (plan_track_option_validated ?learning_plan)
        )
      )
    :effect (plan_track_option_validated ?learning_plan)
  )
  (:action finalize_plan_track_option_and_signoff
    :parameters (?learning_plan - learning_plan)
    :precondition
      (and
        (plan_track_option_validated ?learning_plan)
        (not
          (plan_final_signoff ?learning_plan)
        )
      )
    :effect
      (and
        (plan_final_signoff ?learning_plan)
        (specialization_committed ?learning_plan)
      )
  )
  (:action commit_specialization_to_student
    :parameters (?student - student_candidate ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (student_ready_for_proposal ?student)
        (student_requirement_satisfied ?student)
        (specialization_proposal_reserved ?specialization_proposal)
        (proposal_course_locked ?specialization_proposal)
        (not
          (specialization_committed ?student)
        )
      )
    :effect (specialization_committed ?student)
  )
  (:action commit_specialization_to_cohort
    :parameters (?cohort - cohort_candidate ?specialization_proposal - specialization_proposal)
    :precondition
      (and
        (cohort_ready_for_proposal ?cohort)
        (cohort_milestone_confirmed ?cohort)
        (specialization_proposal_reserved ?specialization_proposal)
        (proposal_course_locked ?specialization_proposal)
        (not
          (specialization_committed ?cohort)
        )
      )
    :effect (specialization_committed ?cohort)
  )
  (:action assign_external_partner_to_subject
    :parameters (?subject - planning_subject ?external_partner - external_partner ?course_offering - course_offering)
    :precondition
      (and
        (specialization_committed ?subject)
        (participant_enrolled_in_offering ?subject ?course_offering)
        (external_partner_available ?external_partner)
        (not
          (participant_external_partner_assigned ?subject)
        )
      )
    :effect
      (and
        (participant_external_partner_assigned ?subject)
        (participant_bound_to_external_partner ?subject ?external_partner)
        (not
          (external_partner_available ?external_partner)
        )
      )
  )
  (:action bind_external_partner_and_release_slot_for_student
    :parameters (?student - student_candidate ?specialization_slot - specialization_slot ?external_partner - external_partner)
    :precondition
      (and
        (participant_external_partner_assigned ?student)
        (participant_assigned_specialization_slot ?student ?specialization_slot)
        (participant_bound_to_external_partner ?student ?external_partner)
        (not
          (participant_external_partner_binding_finalized ?student)
        )
      )
    :effect
      (and
        (participant_external_partner_binding_finalized ?student)
        (specialization_slot_available ?specialization_slot)
        (external_partner_available ?external_partner)
      )
  )
  (:action bind_external_partner_and_release_slot_for_cohort
    :parameters (?cohort - cohort_candidate ?specialization_slot - specialization_slot ?external_partner - external_partner)
    :precondition
      (and
        (participant_external_partner_assigned ?cohort)
        (participant_assigned_specialization_slot ?cohort ?specialization_slot)
        (participant_bound_to_external_partner ?cohort ?external_partner)
        (not
          (participant_external_partner_binding_finalized ?cohort)
        )
      )
    :effect
      (and
        (participant_external_partner_binding_finalized ?cohort)
        (specialization_slot_available ?specialization_slot)
        (external_partner_available ?external_partner)
      )
  )
  (:action bind_external_partner_and_release_slot_for_plan
    :parameters (?learning_plan - learning_plan ?specialization_slot - specialization_slot ?external_partner - external_partner)
    :precondition
      (and
        (participant_external_partner_assigned ?learning_plan)
        (participant_assigned_specialization_slot ?learning_plan ?specialization_slot)
        (participant_bound_to_external_partner ?learning_plan ?external_partner)
        (not
          (participant_external_partner_binding_finalized ?learning_plan)
        )
      )
    :effect
      (and
        (participant_external_partner_binding_finalized ?learning_plan)
        (specialization_slot_available ?specialization_slot)
        (external_partner_available ?external_partner)
      )
  )
)

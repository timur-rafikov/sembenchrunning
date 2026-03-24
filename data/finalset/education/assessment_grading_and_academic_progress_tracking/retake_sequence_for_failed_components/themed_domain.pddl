(define (domain retake_sequence_for_failed_components_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object actor_or_artifact - entity resource_category - entity offering_category - entity case_container - entity retake_subject - case_container retake_option - actor_or_artifact assessment_event - actor_or_artifact staff_member - actor_or_artifact approval_token - actor_or_artifact administrative_clearance - actor_or_artifact evidence_document - actor_or_artifact examiner_assignment - actor_or_artifact external_reviewer - actor_or_artifact support_resource - resource_category assessment_material - resource_category policy_document - resource_category component_slot - offering_category assessment_slot - offering_category retake_offer - offering_category student_category - retake_subject enrollment_category - retake_subject individual_student - student_category cohort_student - student_category course_component - enrollment_category)

  (:predicates
    (retake_case_registered ?case_subject - retake_subject)
    (retake_subject_validated ?case_subject - retake_subject)
    (retake_request_recorded ?case_subject - retake_subject)
    (academic_record_updated ?case_subject - retake_subject)
    (retake_subject_grading_checkpoint_passed ?case_subject - retake_subject)
    (final_grade_recorded ?case_subject - retake_subject)
    (retake_option_available ?retake_option - retake_option)
    (assigned_retake_option ?case_subject - retake_subject ?retake_option - retake_option)
    (assessment_event_available ?assessment_event - assessment_event)
    (retake_subject_scheduled_for_event ?case_subject - retake_subject ?assessment_event - assessment_event)
    (staff_available ?staff_member - staff_member)
    (retake_subject_assigned_staff ?case_subject - retake_subject ?staff_member - staff_member)
    (support_resource_available ?support_resource - support_resource)
    (allocated_support_resource ?individual_student - individual_student ?support_resource - support_resource)
    (cohort_allocated_support_resource ?cohort_student - cohort_student ?support_resource - support_resource)
    (student_assigned_component_slot ?individual_student - individual_student ?component_slot - component_slot)
    (component_slot_reserved ?component_slot - component_slot)
    (component_slot_support_attached ?component_slot - component_slot)
    (student_ready_for_retake ?individual_student - individual_student)
    (cohort_assigned_assessment_slot ?cohort_student - cohort_student ?assessment_slot - assessment_slot)
    (assessment_slot_reserved ?assessment_slot - assessment_slot)
    (assessment_slot_support_attached ?assessment_slot - assessment_slot)
    (cohort_ready_for_retake ?cohort_student - cohort_student)
    (retake_offer_available ?retake_offer - retake_offer)
    (retake_offer_created ?retake_offer - retake_offer)
    (offer_linked_component_slot ?retake_offer - retake_offer ?component_slot - component_slot)
    (offer_linked_assessment_slot ?retake_offer - retake_offer ?assessment_slot - assessment_slot)
    (retake_offer_manual_review_required ?retake_offer - retake_offer)
    (retake_offer_auto_review_required ?retake_offer - retake_offer)
    (retake_offer_materials_assigned ?retake_offer - retake_offer)
    (component_assigned_to_student ?course_component - course_component ?individual_student - individual_student)
    (component_assigned_to_cohort ?course_component - course_component ?cohort_student - cohort_student)
    (component_linked_retake_offer ?course_component - course_component ?retake_offer - retake_offer)
    (assessment_material_available ?assessment_material - assessment_material)
    (component_has_material ?course_component - course_component ?assessment_material - assessment_material)
    (assessment_material_assigned ?assessment_material - assessment_material)
    (assessment_material_bound_to_offer ?assessment_material - assessment_material ?retake_offer - retake_offer)
    (component_ready_for_examiner_assignment ?course_component - course_component)
    (component_examiner_assigned ?course_component - course_component)
    (component_grading_checkpoint_passed ?course_component - course_component)
    (component_approval_attached ?course_component - course_component)
    (component_approval_processed ?course_component - course_component)
    (component_ready_for_finalization ?course_component - course_component)
    (component_grading_confirmed ?course_component - course_component)
    (policy_document_available ?policy_document - policy_document)
    (component_linked_to_policy_document ?course_component - course_component ?policy_document - policy_document)
    (component_policy_exception_recorded ?course_component - course_component)
    (component_exception_approved ?course_component - course_component)
    (component_external_review_complete ?course_component - course_component)
    (approval_token_available ?approval_token - approval_token)
    (component_linked_approval_token ?course_component - course_component ?approval_token - approval_token)
    (administrative_clearance_available ?administrative_clearance - administrative_clearance)
    (component_has_administrative_clearance ?course_component - course_component ?administrative_clearance - administrative_clearance)
    (examiner_assignment_available ?examiner_assignment - examiner_assignment)
    (component_assigned_examiner ?course_component - course_component ?examiner_assignment - examiner_assignment)
    (external_reviewer_available ?external_reviewer - external_reviewer)
    (component_assigned_external_reviewer ?course_component - course_component ?external_reviewer - external_reviewer)
    (evidence_document_available ?evidence_document - evidence_document)
    (retake_subject_linked_evidence_document ?case_subject - retake_subject ?evidence_document - evidence_document)
    (student_preparation_confirmed ?individual_student - individual_student)
    (cohort_preparation_confirmed ?cohort_student - cohort_student)
    (component_academic_record_updated ?course_component - course_component)
  )
  (:action create_retake_case
    :parameters (?case_subject - retake_subject)
    :precondition
      (and
        (not
          (retake_case_registered ?case_subject)
        )
        (not
          (academic_record_updated ?case_subject)
        )
      )
    :effect (retake_case_registered ?case_subject)
  )
  (:action assign_retake_option_to_case
    :parameters (?case_subject - retake_subject ?retake_option - retake_option)
    :precondition
      (and
        (retake_case_registered ?case_subject)
        (not
          (retake_request_recorded ?case_subject)
        )
        (retake_option_available ?retake_option)
      )
    :effect
      (and
        (retake_request_recorded ?case_subject)
        (assigned_retake_option ?case_subject ?retake_option)
        (not
          (retake_option_available ?retake_option)
        )
      )
  )
  (:action reserve_assessment_event_for_case
    :parameters (?case_subject - retake_subject ?assessment_event - assessment_event)
    :precondition
      (and
        (retake_case_registered ?case_subject)
        (retake_request_recorded ?case_subject)
        (assessment_event_available ?assessment_event)
      )
    :effect
      (and
        (retake_subject_scheduled_for_event ?case_subject ?assessment_event)
        (not
          (assessment_event_available ?assessment_event)
        )
      )
  )
  (:action validate_retake_case
    :parameters (?case_subject - retake_subject ?assessment_event - assessment_event)
    :precondition
      (and
        (retake_case_registered ?case_subject)
        (retake_request_recorded ?case_subject)
        (retake_subject_scheduled_for_event ?case_subject ?assessment_event)
        (not
          (retake_subject_validated ?case_subject)
        )
      )
    :effect (retake_subject_validated ?case_subject)
  )
  (:action release_assessment_event_from_case
    :parameters (?case_subject - retake_subject ?assessment_event - assessment_event)
    :precondition
      (and
        (retake_subject_scheduled_for_event ?case_subject ?assessment_event)
      )
    :effect
      (and
        (assessment_event_available ?assessment_event)
        (not
          (retake_subject_scheduled_for_event ?case_subject ?assessment_event)
        )
      )
  )
  (:action assign_staff_to_case
    :parameters (?case_subject - retake_subject ?staff_member - staff_member)
    :precondition
      (and
        (retake_subject_validated ?case_subject)
        (staff_available ?staff_member)
      )
    :effect
      (and
        (retake_subject_assigned_staff ?case_subject ?staff_member)
        (not
          (staff_available ?staff_member)
        )
      )
  )
  (:action release_staff_from_case
    :parameters (?case_subject - retake_subject ?staff_member - staff_member)
    :precondition
      (and
        (retake_subject_assigned_staff ?case_subject ?staff_member)
      )
    :effect
      (and
        (staff_available ?staff_member)
        (not
          (retake_subject_assigned_staff ?case_subject ?staff_member)
        )
      )
  )
  (:action assign_examiner_to_component
    :parameters (?course_component - course_component ?examiner_assignment - examiner_assignment)
    :precondition
      (and
        (retake_subject_validated ?course_component)
        (examiner_assignment_available ?examiner_assignment)
      )
    :effect
      (and
        (component_assigned_examiner ?course_component ?examiner_assignment)
        (not
          (examiner_assignment_available ?examiner_assignment)
        )
      )
  )
  (:action unassign_examiner_from_component
    :parameters (?course_component - course_component ?examiner_assignment - examiner_assignment)
    :precondition
      (and
        (component_assigned_examiner ?course_component ?examiner_assignment)
      )
    :effect
      (and
        (examiner_assignment_available ?examiner_assignment)
        (not
          (component_assigned_examiner ?course_component ?examiner_assignment)
        )
      )
  )
  (:action assign_external_reviewer_to_component
    :parameters (?course_component - course_component ?external_reviewer - external_reviewer)
    :precondition
      (and
        (retake_subject_validated ?course_component)
        (external_reviewer_available ?external_reviewer)
      )
    :effect
      (and
        (component_assigned_external_reviewer ?course_component ?external_reviewer)
        (not
          (external_reviewer_available ?external_reviewer)
        )
      )
  )
  (:action unassign_external_reviewer_from_component
    :parameters (?course_component - course_component ?external_reviewer - external_reviewer)
    :precondition
      (and
        (component_assigned_external_reviewer ?course_component ?external_reviewer)
      )
    :effect
      (and
        (external_reviewer_available ?external_reviewer)
        (not
          (component_assigned_external_reviewer ?course_component ?external_reviewer)
        )
      )
  )
  (:action reserve_component_slot_for_student
    :parameters (?individual_student - individual_student ?component_slot - component_slot ?assessment_event - assessment_event)
    :precondition
      (and
        (retake_subject_validated ?individual_student)
        (retake_subject_scheduled_for_event ?individual_student ?assessment_event)
        (student_assigned_component_slot ?individual_student ?component_slot)
        (not
          (component_slot_reserved ?component_slot)
        )
        (not
          (component_slot_support_attached ?component_slot)
        )
      )
    :effect (component_slot_reserved ?component_slot)
  )
  (:action confirm_student_preparation_with_staff
    :parameters (?individual_student - individual_student ?component_slot - component_slot ?staff_member - staff_member)
    :precondition
      (and
        (retake_subject_validated ?individual_student)
        (retake_subject_assigned_staff ?individual_student ?staff_member)
        (student_assigned_component_slot ?individual_student ?component_slot)
        (component_slot_reserved ?component_slot)
        (not
          (student_preparation_confirmed ?individual_student)
        )
      )
    :effect
      (and
        (student_preparation_confirmed ?individual_student)
        (student_ready_for_retake ?individual_student)
      )
  )
  (:action allocate_support_resource_to_student
    :parameters (?individual_student - individual_student ?component_slot - component_slot ?support_resource - support_resource)
    :precondition
      (and
        (retake_subject_validated ?individual_student)
        (student_assigned_component_slot ?individual_student ?component_slot)
        (support_resource_available ?support_resource)
        (not
          (student_preparation_confirmed ?individual_student)
        )
      )
    :effect
      (and
        (component_slot_support_attached ?component_slot)
        (student_preparation_confirmed ?individual_student)
        (allocated_support_resource ?individual_student ?support_resource)
        (not
          (support_resource_available ?support_resource)
        )
      )
  )
  (:action finalize_student_preparation
    :parameters (?individual_student - individual_student ?component_slot - component_slot ?assessment_event - assessment_event ?support_resource - support_resource)
    :precondition
      (and
        (retake_subject_validated ?individual_student)
        (retake_subject_scheduled_for_event ?individual_student ?assessment_event)
        (student_assigned_component_slot ?individual_student ?component_slot)
        (component_slot_support_attached ?component_slot)
        (allocated_support_resource ?individual_student ?support_resource)
        (not
          (student_ready_for_retake ?individual_student)
        )
      )
    :effect
      (and
        (component_slot_reserved ?component_slot)
        (student_ready_for_retake ?individual_student)
        (support_resource_available ?support_resource)
        (not
          (allocated_support_resource ?individual_student ?support_resource)
        )
      )
  )
  (:action reserve_assessment_slot_for_cohort
    :parameters (?cohort_student - cohort_student ?assessment_slot - assessment_slot ?assessment_event - assessment_event)
    :precondition
      (and
        (retake_subject_validated ?cohort_student)
        (retake_subject_scheduled_for_event ?cohort_student ?assessment_event)
        (cohort_assigned_assessment_slot ?cohort_student ?assessment_slot)
        (not
          (assessment_slot_reserved ?assessment_slot)
        )
        (not
          (assessment_slot_support_attached ?assessment_slot)
        )
      )
    :effect (assessment_slot_reserved ?assessment_slot)
  )
  (:action confirm_cohort_preparation_with_staff
    :parameters (?cohort_student - cohort_student ?assessment_slot - assessment_slot ?staff_member - staff_member)
    :precondition
      (and
        (retake_subject_validated ?cohort_student)
        (retake_subject_assigned_staff ?cohort_student ?staff_member)
        (cohort_assigned_assessment_slot ?cohort_student ?assessment_slot)
        (assessment_slot_reserved ?assessment_slot)
        (not
          (cohort_preparation_confirmed ?cohort_student)
        )
      )
    :effect
      (and
        (cohort_preparation_confirmed ?cohort_student)
        (cohort_ready_for_retake ?cohort_student)
      )
  )
  (:action allocate_support_resource_to_cohort
    :parameters (?cohort_student - cohort_student ?assessment_slot - assessment_slot ?support_resource - support_resource)
    :precondition
      (and
        (retake_subject_validated ?cohort_student)
        (cohort_assigned_assessment_slot ?cohort_student ?assessment_slot)
        (support_resource_available ?support_resource)
        (not
          (cohort_preparation_confirmed ?cohort_student)
        )
      )
    :effect
      (and
        (assessment_slot_support_attached ?assessment_slot)
        (cohort_preparation_confirmed ?cohort_student)
        (cohort_allocated_support_resource ?cohort_student ?support_resource)
        (not
          (support_resource_available ?support_resource)
        )
      )
  )
  (:action finalize_cohort_preparation
    :parameters (?cohort_student - cohort_student ?assessment_slot - assessment_slot ?assessment_event - assessment_event ?support_resource - support_resource)
    :precondition
      (and
        (retake_subject_validated ?cohort_student)
        (retake_subject_scheduled_for_event ?cohort_student ?assessment_event)
        (cohort_assigned_assessment_slot ?cohort_student ?assessment_slot)
        (assessment_slot_support_attached ?assessment_slot)
        (cohort_allocated_support_resource ?cohort_student ?support_resource)
        (not
          (cohort_ready_for_retake ?cohort_student)
        )
      )
    :effect
      (and
        (assessment_slot_reserved ?assessment_slot)
        (cohort_ready_for_retake ?cohort_student)
        (support_resource_available ?support_resource)
        (not
          (cohort_allocated_support_resource ?cohort_student ?support_resource)
        )
      )
  )
  (:action assemble_retake_offer_variant_1
    :parameters (?individual_student - individual_student ?cohort_student - cohort_student ?component_slot - component_slot ?assessment_slot - assessment_slot ?retake_offer - retake_offer)
    :precondition
      (and
        (student_preparation_confirmed ?individual_student)
        (cohort_preparation_confirmed ?cohort_student)
        (student_assigned_component_slot ?individual_student ?component_slot)
        (cohort_assigned_assessment_slot ?cohort_student ?assessment_slot)
        (component_slot_reserved ?component_slot)
        (assessment_slot_reserved ?assessment_slot)
        (student_ready_for_retake ?individual_student)
        (cohort_ready_for_retake ?cohort_student)
        (retake_offer_available ?retake_offer)
      )
    :effect
      (and
        (retake_offer_created ?retake_offer)
        (offer_linked_component_slot ?retake_offer ?component_slot)
        (offer_linked_assessment_slot ?retake_offer ?assessment_slot)
        (not
          (retake_offer_available ?retake_offer)
        )
      )
  )
  (:action assemble_retake_offer_variant_2
    :parameters (?individual_student - individual_student ?cohort_student - cohort_student ?component_slot - component_slot ?assessment_slot - assessment_slot ?retake_offer - retake_offer)
    :precondition
      (and
        (student_preparation_confirmed ?individual_student)
        (cohort_preparation_confirmed ?cohort_student)
        (student_assigned_component_slot ?individual_student ?component_slot)
        (cohort_assigned_assessment_slot ?cohort_student ?assessment_slot)
        (component_slot_support_attached ?component_slot)
        (assessment_slot_reserved ?assessment_slot)
        (not
          (student_ready_for_retake ?individual_student)
        )
        (cohort_ready_for_retake ?cohort_student)
        (retake_offer_available ?retake_offer)
      )
    :effect
      (and
        (retake_offer_created ?retake_offer)
        (offer_linked_component_slot ?retake_offer ?component_slot)
        (offer_linked_assessment_slot ?retake_offer ?assessment_slot)
        (retake_offer_manual_review_required ?retake_offer)
        (not
          (retake_offer_available ?retake_offer)
        )
      )
  )
  (:action assemble_retake_offer_variant_3
    :parameters (?individual_student - individual_student ?cohort_student - cohort_student ?component_slot - component_slot ?assessment_slot - assessment_slot ?retake_offer - retake_offer)
    :precondition
      (and
        (student_preparation_confirmed ?individual_student)
        (cohort_preparation_confirmed ?cohort_student)
        (student_assigned_component_slot ?individual_student ?component_slot)
        (cohort_assigned_assessment_slot ?cohort_student ?assessment_slot)
        (component_slot_reserved ?component_slot)
        (assessment_slot_support_attached ?assessment_slot)
        (student_ready_for_retake ?individual_student)
        (not
          (cohort_ready_for_retake ?cohort_student)
        )
        (retake_offer_available ?retake_offer)
      )
    :effect
      (and
        (retake_offer_created ?retake_offer)
        (offer_linked_component_slot ?retake_offer ?component_slot)
        (offer_linked_assessment_slot ?retake_offer ?assessment_slot)
        (retake_offer_auto_review_required ?retake_offer)
        (not
          (retake_offer_available ?retake_offer)
        )
      )
  )
  (:action assemble_retake_offer_variant_4
    :parameters (?individual_student - individual_student ?cohort_student - cohort_student ?component_slot - component_slot ?assessment_slot - assessment_slot ?retake_offer - retake_offer)
    :precondition
      (and
        (student_preparation_confirmed ?individual_student)
        (cohort_preparation_confirmed ?cohort_student)
        (student_assigned_component_slot ?individual_student ?component_slot)
        (cohort_assigned_assessment_slot ?cohort_student ?assessment_slot)
        (component_slot_support_attached ?component_slot)
        (assessment_slot_support_attached ?assessment_slot)
        (not
          (student_ready_for_retake ?individual_student)
        )
        (not
          (cohort_ready_for_retake ?cohort_student)
        )
        (retake_offer_available ?retake_offer)
      )
    :effect
      (and
        (retake_offer_created ?retake_offer)
        (offer_linked_component_slot ?retake_offer ?component_slot)
        (offer_linked_assessment_slot ?retake_offer ?assessment_slot)
        (retake_offer_manual_review_required ?retake_offer)
        (retake_offer_auto_review_required ?retake_offer)
        (not
          (retake_offer_available ?retake_offer)
        )
      )
  )
  (:action confirm_retake_offer_materials
    :parameters (?retake_offer - retake_offer ?individual_student - individual_student ?assessment_event - assessment_event)
    :precondition
      (and
        (retake_offer_created ?retake_offer)
        (student_preparation_confirmed ?individual_student)
        (retake_subject_scheduled_for_event ?individual_student ?assessment_event)
        (not
          (retake_offer_materials_assigned ?retake_offer)
        )
      )
    :effect (retake_offer_materials_assigned ?retake_offer)
  )
  (:action bind_material_to_component_and_offer
    :parameters (?course_component - course_component ?assessment_material - assessment_material ?retake_offer - retake_offer)
    :precondition
      (and
        (retake_subject_validated ?course_component)
        (component_linked_retake_offer ?course_component ?retake_offer)
        (component_has_material ?course_component ?assessment_material)
        (assessment_material_available ?assessment_material)
        (retake_offer_created ?retake_offer)
        (retake_offer_materials_assigned ?retake_offer)
        (not
          (assessment_material_assigned ?assessment_material)
        )
      )
    :effect
      (and
        (assessment_material_assigned ?assessment_material)
        (assessment_material_bound_to_offer ?assessment_material ?retake_offer)
        (not
          (assessment_material_available ?assessment_material)
        )
      )
  )
  (:action prepare_component_for_examiner_assignment
    :parameters (?course_component - course_component ?assessment_material - assessment_material ?retake_offer - retake_offer ?assessment_event - assessment_event)
    :precondition
      (and
        (retake_subject_validated ?course_component)
        (component_has_material ?course_component ?assessment_material)
        (assessment_material_assigned ?assessment_material)
        (assessment_material_bound_to_offer ?assessment_material ?retake_offer)
        (retake_subject_scheduled_for_event ?course_component ?assessment_event)
        (not
          (retake_offer_manual_review_required ?retake_offer)
        )
        (not
          (component_ready_for_examiner_assignment ?course_component)
        )
      )
    :effect (component_ready_for_examiner_assignment ?course_component)
  )
  (:action attach_approval_token_to_component
    :parameters (?course_component - course_component ?approval_token - approval_token)
    :precondition
      (and
        (retake_subject_validated ?course_component)
        (approval_token_available ?approval_token)
        (not
          (component_approval_attached ?course_component)
        )
      )
    :effect
      (and
        (component_approval_attached ?course_component)
        (component_linked_approval_token ?course_component ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action process_component_approval_and_enable
    :parameters (?course_component - course_component ?assessment_material - assessment_material ?retake_offer - retake_offer ?assessment_event - assessment_event ?approval_token - approval_token)
    :precondition
      (and
        (retake_subject_validated ?course_component)
        (component_has_material ?course_component ?assessment_material)
        (assessment_material_assigned ?assessment_material)
        (assessment_material_bound_to_offer ?assessment_material ?retake_offer)
        (retake_subject_scheduled_for_event ?course_component ?assessment_event)
        (retake_offer_manual_review_required ?retake_offer)
        (component_approval_attached ?course_component)
        (component_linked_approval_token ?course_component ?approval_token)
        (not
          (component_ready_for_examiner_assignment ?course_component)
        )
      )
    :effect
      (and
        (component_ready_for_examiner_assignment ?course_component)
        (component_approval_processed ?course_component)
      )
  )
  (:action assign_examiner_and_mark_component_variant_1
    :parameters (?course_component - course_component ?examiner_assignment - examiner_assignment ?staff_member - staff_member ?assessment_material - assessment_material ?retake_offer - retake_offer)
    :precondition
      (and
        (component_ready_for_examiner_assignment ?course_component)
        (component_assigned_examiner ?course_component ?examiner_assignment)
        (retake_subject_assigned_staff ?course_component ?staff_member)
        (component_has_material ?course_component ?assessment_material)
        (assessment_material_bound_to_offer ?assessment_material ?retake_offer)
        (not
          (retake_offer_auto_review_required ?retake_offer)
        )
        (not
          (component_examiner_assigned ?course_component)
        )
      )
    :effect (component_examiner_assigned ?course_component)
  )
  (:action assign_examiner_and_mark_component_variant_2
    :parameters (?course_component - course_component ?examiner_assignment - examiner_assignment ?staff_member - staff_member ?assessment_material - assessment_material ?retake_offer - retake_offer)
    :precondition
      (and
        (component_ready_for_examiner_assignment ?course_component)
        (component_assigned_examiner ?course_component ?examiner_assignment)
        (retake_subject_assigned_staff ?course_component ?staff_member)
        (component_has_material ?course_component ?assessment_material)
        (assessment_material_bound_to_offer ?assessment_material ?retake_offer)
        (retake_offer_auto_review_required ?retake_offer)
        (not
          (component_examiner_assigned ?course_component)
        )
      )
    :effect (component_examiner_assigned ?course_component)
  )
  (:action record_external_reviewer_assignment_variant_1
    :parameters (?course_component - course_component ?external_reviewer - external_reviewer ?assessment_material - assessment_material ?retake_offer - retake_offer)
    :precondition
      (and
        (component_examiner_assigned ?course_component)
        (component_assigned_external_reviewer ?course_component ?external_reviewer)
        (component_has_material ?course_component ?assessment_material)
        (assessment_material_bound_to_offer ?assessment_material ?retake_offer)
        (not
          (retake_offer_manual_review_required ?retake_offer)
        )
        (not
          (retake_offer_auto_review_required ?retake_offer)
        )
        (not
          (component_grading_checkpoint_passed ?course_component)
        )
      )
    :effect (component_grading_checkpoint_passed ?course_component)
  )
  (:action record_external_reviewer_assignment_variant_2
    :parameters (?course_component - course_component ?external_reviewer - external_reviewer ?assessment_material - assessment_material ?retake_offer - retake_offer)
    :precondition
      (and
        (component_examiner_assigned ?course_component)
        (component_assigned_external_reviewer ?course_component ?external_reviewer)
        (component_has_material ?course_component ?assessment_material)
        (assessment_material_bound_to_offer ?assessment_material ?retake_offer)
        (retake_offer_manual_review_required ?retake_offer)
        (not
          (retake_offer_auto_review_required ?retake_offer)
        )
        (not
          (component_grading_checkpoint_passed ?course_component)
        )
      )
    :effect
      (and
        (component_grading_checkpoint_passed ?course_component)
        (component_ready_for_finalization ?course_component)
      )
  )
  (:action record_external_reviewer_assignment_variant_3
    :parameters (?course_component - course_component ?external_reviewer - external_reviewer ?assessment_material - assessment_material ?retake_offer - retake_offer)
    :precondition
      (and
        (component_examiner_assigned ?course_component)
        (component_assigned_external_reviewer ?course_component ?external_reviewer)
        (component_has_material ?course_component ?assessment_material)
        (assessment_material_bound_to_offer ?assessment_material ?retake_offer)
        (not
          (retake_offer_manual_review_required ?retake_offer)
        )
        (retake_offer_auto_review_required ?retake_offer)
        (not
          (component_grading_checkpoint_passed ?course_component)
        )
      )
    :effect
      (and
        (component_grading_checkpoint_passed ?course_component)
        (component_ready_for_finalization ?course_component)
      )
  )
  (:action record_external_reviewer_assignment_variant_4
    :parameters (?course_component - course_component ?external_reviewer - external_reviewer ?assessment_material - assessment_material ?retake_offer - retake_offer)
    :precondition
      (and
        (component_examiner_assigned ?course_component)
        (component_assigned_external_reviewer ?course_component ?external_reviewer)
        (component_has_material ?course_component ?assessment_material)
        (assessment_material_bound_to_offer ?assessment_material ?retake_offer)
        (retake_offer_manual_review_required ?retake_offer)
        (retake_offer_auto_review_required ?retake_offer)
        (not
          (component_grading_checkpoint_passed ?course_component)
        )
      )
    :effect
      (and
        (component_grading_checkpoint_passed ?course_component)
        (component_ready_for_finalization ?course_component)
      )
  )
  (:action provisionally_complete_component
    :parameters (?course_component - course_component)
    :precondition
      (and
        (component_grading_checkpoint_passed ?course_component)
        (not
          (component_ready_for_finalization ?course_component)
        )
        (not
          (component_academic_record_updated ?course_component)
        )
      )
    :effect
      (and
        (component_academic_record_updated ?course_component)
        (retake_subject_grading_checkpoint_passed ?course_component)
      )
  )
  (:action link_administrative_clearance_to_component
    :parameters (?course_component - course_component ?administrative_clearance - administrative_clearance)
    :precondition
      (and
        (component_grading_checkpoint_passed ?course_component)
        (component_ready_for_finalization ?course_component)
        (administrative_clearance_available ?administrative_clearance)
      )
    :effect
      (and
        (component_has_administrative_clearance ?course_component ?administrative_clearance)
        (not
          (administrative_clearance_available ?administrative_clearance)
        )
      )
  )
  (:action finalize_component_grading_checkpoint
    :parameters (?course_component - course_component ?individual_student - individual_student ?cohort_student - cohort_student ?assessment_event - assessment_event ?administrative_clearance - administrative_clearance)
    :precondition
      (and
        (component_grading_checkpoint_passed ?course_component)
        (component_ready_for_finalization ?course_component)
        (component_has_administrative_clearance ?course_component ?administrative_clearance)
        (component_assigned_to_student ?course_component ?individual_student)
        (component_assigned_to_cohort ?course_component ?cohort_student)
        (student_ready_for_retake ?individual_student)
        (cohort_ready_for_retake ?cohort_student)
        (retake_subject_scheduled_for_event ?course_component ?assessment_event)
        (not
          (component_grading_confirmed ?course_component)
        )
      )
    :effect (component_grading_confirmed ?course_component)
  )
  (:action finalize_component_and_update_record
    :parameters (?course_component - course_component)
    :precondition
      (and
        (component_grading_checkpoint_passed ?course_component)
        (component_grading_confirmed ?course_component)
        (not
          (component_academic_record_updated ?course_component)
        )
      )
    :effect
      (and
        (component_academic_record_updated ?course_component)
        (retake_subject_grading_checkpoint_passed ?course_component)
      )
  )
  (:action request_policy_exception_for_component
    :parameters (?course_component - course_component ?policy_document - policy_document ?assessment_event - assessment_event)
    :precondition
      (and
        (retake_subject_validated ?course_component)
        (retake_subject_scheduled_for_event ?course_component ?assessment_event)
        (policy_document_available ?policy_document)
        (component_linked_to_policy_document ?course_component ?policy_document)
        (not
          (component_policy_exception_recorded ?course_component)
        )
      )
    :effect
      (and
        (component_policy_exception_recorded ?course_component)
        (not
          (policy_document_available ?policy_document)
        )
      )
  )
  (:action approve_component_exception_with_staff
    :parameters (?course_component - course_component ?staff_member - staff_member)
    :precondition
      (and
        (component_policy_exception_recorded ?course_component)
        (retake_subject_assigned_staff ?course_component ?staff_member)
        (not
          (component_exception_approved ?course_component)
        )
      )
    :effect (component_exception_approved ?course_component)
  )
  (:action assign_external_reviewer_to_exception
    :parameters (?course_component - course_component ?external_reviewer - external_reviewer)
    :precondition
      (and
        (component_exception_approved ?course_component)
        (component_assigned_external_reviewer ?course_component ?external_reviewer)
        (not
          (component_external_review_complete ?course_component)
        )
      )
    :effect (component_external_review_complete ?course_component)
  )
  (:action finalize_exception_and_update_record
    :parameters (?course_component - course_component)
    :precondition
      (and
        (component_external_review_complete ?course_component)
        (not
          (component_academic_record_updated ?course_component)
        )
      )
    :effect
      (and
        (component_academic_record_updated ?course_component)
        (retake_subject_grading_checkpoint_passed ?course_component)
      )
  )
  (:action apply_student_record_update_from_offer
    :parameters (?individual_student - individual_student ?retake_offer - retake_offer)
    :precondition
      (and
        (student_preparation_confirmed ?individual_student)
        (student_ready_for_retake ?individual_student)
        (retake_offer_created ?retake_offer)
        (retake_offer_materials_assigned ?retake_offer)
        (not
          (retake_subject_grading_checkpoint_passed ?individual_student)
        )
      )
    :effect (retake_subject_grading_checkpoint_passed ?individual_student)
  )
  (:action apply_cohort_record_update_from_offer
    :parameters (?cohort_student - cohort_student ?retake_offer - retake_offer)
    :precondition
      (and
        (cohort_preparation_confirmed ?cohort_student)
        (cohort_ready_for_retake ?cohort_student)
        (retake_offer_created ?retake_offer)
        (retake_offer_materials_assigned ?retake_offer)
        (not
          (retake_subject_grading_checkpoint_passed ?cohort_student)
        )
      )
    :effect (retake_subject_grading_checkpoint_passed ?cohort_student)
  )
  (:action record_provisional_completion_for_case_subject
    :parameters (?case_subject - retake_subject ?evidence_document - evidence_document ?assessment_event - assessment_event)
    :precondition
      (and
        (retake_subject_grading_checkpoint_passed ?case_subject)
        (retake_subject_scheduled_for_event ?case_subject ?assessment_event)
        (evidence_document_available ?evidence_document)
        (not
          (final_grade_recorded ?case_subject)
        )
      )
    :effect
      (and
        (final_grade_recorded ?case_subject)
        (retake_subject_linked_evidence_document ?case_subject ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action finalize_student_record_and_release_option
    :parameters (?individual_student - individual_student ?retake_option - retake_option ?evidence_document - evidence_document)
    :precondition
      (and
        (final_grade_recorded ?individual_student)
        (assigned_retake_option ?individual_student ?retake_option)
        (retake_subject_linked_evidence_document ?individual_student ?evidence_document)
        (not
          (academic_record_updated ?individual_student)
        )
      )
    :effect
      (and
        (academic_record_updated ?individual_student)
        (retake_option_available ?retake_option)
        (evidence_document_available ?evidence_document)
      )
  )
  (:action finalize_cohort_member_record_and_release_option
    :parameters (?cohort_student - cohort_student ?retake_option - retake_option ?evidence_document - evidence_document)
    :precondition
      (and
        (final_grade_recorded ?cohort_student)
        (assigned_retake_option ?cohort_student ?retake_option)
        (retake_subject_linked_evidence_document ?cohort_student ?evidence_document)
        (not
          (academic_record_updated ?cohort_student)
        )
      )
    :effect
      (and
        (academic_record_updated ?cohort_student)
        (retake_option_available ?retake_option)
        (evidence_document_available ?evidence_document)
      )
  )
  (:action finalize_component_record_and_release_option
    :parameters (?course_component - course_component ?retake_option - retake_option ?evidence_document - evidence_document)
    :precondition
      (and
        (final_grade_recorded ?course_component)
        (assigned_retake_option ?course_component ?retake_option)
        (retake_subject_linked_evidence_document ?course_component ?evidence_document)
        (not
          (academic_record_updated ?course_component)
        )
      )
    :effect
      (and
        (academic_record_updated ?course_component)
        (retake_option_available ?retake_option)
        (evidence_document_available ?evidence_document)
      )
  )
)

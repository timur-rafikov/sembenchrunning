(define (domain education_grade_recovery_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_entity - object human_or_support_resource_group - domain_entity resource_item_group - domain_entity recovery_component_group - domain_entity root_entity_group - domain_entity student_enrollment_record - root_entity_group staff_resource - human_or_support_resource_group assessment_instance - human_or_support_resource_group proctor_or_grader - human_or_support_resource_group policy_document - human_or_support_resource_group resource_allocation_slot - human_or_support_resource_group eligibility_token - human_or_support_resource_group grade_adjustment_option - human_or_support_resource_group administrative_approval_document - human_or_support_resource_group support_service - resource_item_group submission_evidence - resource_item_group instructor_recommendation - resource_item_group remediation_path_a - recovery_component_group remediation_path_b - recovery_component_group recovery_assessment_session - recovery_component_group student_role_group - student_enrollment_record academic_unit_group - student_enrollment_record primary_student - student_role_group secondary_student - student_role_group course_section - academic_unit_group)

  (:predicates
    (recovery_candidate_identified ?student_enrollment_record - student_enrollment_record)
    (eligible_for_reassessment_subject ?student_enrollment_record - student_enrollment_record)
    (staff_assignment_recorded ?student_enrollment_record - student_enrollment_record)
    (grade_change_applied_to_entity ?student_enrollment_record - student_enrollment_record)
    (final_review_completed_for_entity ?student_enrollment_record - student_enrollment_record)
    (grade_change_authorized_for_entity ?student_enrollment_record - student_enrollment_record)
    (staff_resource_available ?staff_resource - staff_resource)
    (assigned_staff_for_subject ?student_enrollment_record - student_enrollment_record ?staff_resource - staff_resource)
    (assessment_instance_available ?assessment_instance - assessment_instance)
    (entity_reserved_assessment ?student_enrollment_record - student_enrollment_record ?assessment_instance - assessment_instance)
    (proctor_available ?proctor_or_grader - proctor_or_grader)
    (assigned_proctor_for_subject ?student_enrollment_record - student_enrollment_record ?proctor_or_grader - proctor_or_grader)
    (support_service_available ?support_service - support_service)
    (allocated_support_service_primary ?primary_student - primary_student ?support_service - support_service)
    (allocated_support_service_secondary ?secondary_student - secondary_student ?support_service - support_service)
    (enrolled_in_remediation_a ?primary_student - primary_student ?remediation_path_a - remediation_path_a)
    (remediation_path_a_prepared ?remediation_path_a - remediation_path_a)
    (remediation_path_a_support_engaged ?remediation_path_a - remediation_path_a)
    (primary_student_ready_for_session ?primary_student - primary_student)
    (enrolled_in_remediation_b ?secondary_student - secondary_student ?remediation_path_b - remediation_path_b)
    (remediation_path_b_prepared ?remediation_path_b - remediation_path_b)
    (remediation_path_b_support_engaged ?remediation_path_b - remediation_path_b)
    (secondary_student_ready_for_session ?secondary_student - secondary_student)
    (session_slot_available ?recovery_assessment_session - recovery_assessment_session)
    (session_registered ?recovery_assessment_session - recovery_assessment_session)
    (session_associated_with_remediation_a ?recovery_assessment_session - recovery_assessment_session ?remediation_path_a - remediation_path_a)
    (session_associated_with_remediation_b ?recovery_assessment_session - recovery_assessment_session ?remediation_path_b - remediation_path_b)
    (session_requires_additional_evidence ?recovery_assessment_session - recovery_assessment_session)
    (session_requires_instructor_recommendation ?recovery_assessment_session - recovery_assessment_session)
    (session_validation_completed ?recovery_assessment_session - recovery_assessment_session)
    (section_contains_primary_student ?course_section - course_section ?primary_student - primary_student)
    (section_contains_secondary_student ?course_section - course_section ?secondary_student - secondary_student)
    (section_associated_session ?course_section - course_section ?recovery_assessment_session - recovery_assessment_session)
    (submission_evidence_available ?submission_evidence - submission_evidence)
    (section_has_submission_evidence ?course_section - course_section ?submission_evidence - submission_evidence)
    (submission_evidence_reviewed ?submission_evidence - submission_evidence)
    (evidence_associated_with_session ?submission_evidence - submission_evidence ?recovery_assessment_session - recovery_assessment_session)
    (section_review_stage_one_complete ?course_section - course_section)
    (section_review_stage_two_complete ?course_section - course_section)
    (section_review_stage_three_complete ?course_section - course_section)
    (policy_assigned_to_section ?course_section - course_section)
    (section_policy_acknowledged ?course_section - course_section)
    (section_ready_for_finalization ?course_section - course_section)
    (section_review_finalized ?course_section - course_section)
    (instructor_recommendation_available ?instructor_recommendation - instructor_recommendation)
    (section_linked_instructor_recommendation ?course_section - course_section ?instructor_recommendation - instructor_recommendation)
    (instructor_recommendation_applied ?course_section - course_section)
    (section_instructor_recommendation_confirmed ?course_section - course_section)
    (section_administrative_approval_initiated ?course_section - course_section)
    (policy_document_available ?policy_document - policy_document)
    (section_linked_policy_document ?course_section - course_section ?policy_document - policy_document)
    (resource_allocation_slot_available ?resource_allocation_slot - resource_allocation_slot)
    (section_allocated_resource_slot ?course_section - course_section ?resource_allocation_slot - resource_allocation_slot)
    (grade_adjustment_option_available ?grade_adjustment_option - grade_adjustment_option)
    (section_has_grade_adjustment_option ?course_section - course_section ?grade_adjustment_option - grade_adjustment_option)
    (administrative_approval_available ?administrative_approval_document - administrative_approval_document)
    (section_has_administrative_approval ?course_section - course_section ?administrative_approval_document - administrative_approval_document)
    (eligibility_token_available ?eligibility_token - eligibility_token)
    (entity_linked_eligibility_token ?student_enrollment_record - student_enrollment_record ?eligibility_token - eligibility_token)
    (primary_student_preparation_flag ?primary_student - primary_student)
    (secondary_student_preparation_flag ?secondary_student - secondary_student)
    (section_finalized_flag ?course_section - course_section)
  )
  (:action identify_recovery_candidate
    :parameters (?student_enrollment_record - student_enrollment_record)
    :precondition
      (and
        (not
          (recovery_candidate_identified ?student_enrollment_record)
        )
        (not
          (grade_change_applied_to_entity ?student_enrollment_record)
        )
      )
    :effect (recovery_candidate_identified ?student_enrollment_record)
  )
  (:action assign_staff_to_candidate
    :parameters (?student_enrollment_record - student_enrollment_record ?staff_resource - staff_resource)
    :precondition
      (and
        (recovery_candidate_identified ?student_enrollment_record)
        (not
          (staff_assignment_recorded ?student_enrollment_record)
        )
        (staff_resource_available ?staff_resource)
      )
    :effect
      (and
        (staff_assignment_recorded ?student_enrollment_record)
        (assigned_staff_for_subject ?student_enrollment_record ?staff_resource)
        (not
          (staff_resource_available ?staff_resource)
        )
      )
  )
  (:action reserve_assessment_for_candidate
    :parameters (?student_enrollment_record - student_enrollment_record ?assessment_instance - assessment_instance)
    :precondition
      (and
        (recovery_candidate_identified ?student_enrollment_record)
        (staff_assignment_recorded ?student_enrollment_record)
        (assessment_instance_available ?assessment_instance)
      )
    :effect
      (and
        (entity_reserved_assessment ?student_enrollment_record ?assessment_instance)
        (not
          (assessment_instance_available ?assessment_instance)
        )
      )
  )
  (:action record_reassessment_eligibility
    :parameters (?student_enrollment_record - student_enrollment_record ?assessment_instance - assessment_instance)
    :precondition
      (and
        (recovery_candidate_identified ?student_enrollment_record)
        (staff_assignment_recorded ?student_enrollment_record)
        (entity_reserved_assessment ?student_enrollment_record ?assessment_instance)
        (not
          (eligible_for_reassessment_subject ?student_enrollment_record)
        )
      )
    :effect (eligible_for_reassessment_subject ?student_enrollment_record)
  )
  (:action release_assessment_reservation
    :parameters (?student_enrollment_record - student_enrollment_record ?assessment_instance - assessment_instance)
    :precondition
      (and
        (entity_reserved_assessment ?student_enrollment_record ?assessment_instance)
      )
    :effect
      (and
        (assessment_instance_available ?assessment_instance)
        (not
          (entity_reserved_assessment ?student_enrollment_record ?assessment_instance)
        )
      )
  )
  (:action assign_proctor_to_eligible_candidate
    :parameters (?student_enrollment_record - student_enrollment_record ?proctor_or_grader - proctor_or_grader)
    :precondition
      (and
        (eligible_for_reassessment_subject ?student_enrollment_record)
        (proctor_available ?proctor_or_grader)
      )
    :effect
      (and
        (assigned_proctor_for_subject ?student_enrollment_record ?proctor_or_grader)
        (not
          (proctor_available ?proctor_or_grader)
        )
      )
  )
  (:action release_proctor_assignment
    :parameters (?student_enrollment_record - student_enrollment_record ?proctor_or_grader - proctor_or_grader)
    :precondition
      (and
        (assigned_proctor_for_subject ?student_enrollment_record ?proctor_or_grader)
      )
    :effect
      (and
        (proctor_available ?proctor_or_grader)
        (not
          (assigned_proctor_for_subject ?student_enrollment_record ?proctor_or_grader)
        )
      )
  )
  (:action attach_grade_adjustment_option
    :parameters (?course_section - course_section ?grade_adjustment_option - grade_adjustment_option)
    :precondition
      (and
        (eligible_for_reassessment_subject ?course_section)
        (grade_adjustment_option_available ?grade_adjustment_option)
      )
    :effect
      (and
        (section_has_grade_adjustment_option ?course_section ?grade_adjustment_option)
        (not
          (grade_adjustment_option_available ?grade_adjustment_option)
        )
      )
  )
  (:action detach_grade_adjustment_option
    :parameters (?course_section - course_section ?grade_adjustment_option - grade_adjustment_option)
    :precondition
      (and
        (section_has_grade_adjustment_option ?course_section ?grade_adjustment_option)
      )
    :effect
      (and
        (grade_adjustment_option_available ?grade_adjustment_option)
        (not
          (section_has_grade_adjustment_option ?course_section ?grade_adjustment_option)
        )
      )
  )
  (:action attach_administrative_approval
    :parameters (?course_section - course_section ?administrative_approval_document - administrative_approval_document)
    :precondition
      (and
        (eligible_for_reassessment_subject ?course_section)
        (administrative_approval_available ?administrative_approval_document)
      )
    :effect
      (and
        (section_has_administrative_approval ?course_section ?administrative_approval_document)
        (not
          (administrative_approval_available ?administrative_approval_document)
        )
      )
  )
  (:action detach_administrative_approval
    :parameters (?course_section - course_section ?administrative_approval_document - administrative_approval_document)
    :precondition
      (and
        (section_has_administrative_approval ?course_section ?administrative_approval_document)
      )
    :effect
      (and
        (administrative_approval_available ?administrative_approval_document)
        (not
          (section_has_administrative_approval ?course_section ?administrative_approval_document)
        )
      )
  )
  (:action prepare_remediation_path_a_for_primary_student
    :parameters (?primary_student - primary_student ?remediation_path_a - remediation_path_a ?assessment_instance - assessment_instance)
    :precondition
      (and
        (eligible_for_reassessment_subject ?primary_student)
        (entity_reserved_assessment ?primary_student ?assessment_instance)
        (enrolled_in_remediation_a ?primary_student ?remediation_path_a)
        (not
          (remediation_path_a_prepared ?remediation_path_a)
        )
        (not
          (remediation_path_a_support_engaged ?remediation_path_a)
        )
      )
    :effect (remediation_path_a_prepared ?remediation_path_a)
  )
  (:action confirm_primary_student_readiness_with_proctor
    :parameters (?primary_student - primary_student ?remediation_path_a - remediation_path_a ?proctor_or_grader - proctor_or_grader)
    :precondition
      (and
        (eligible_for_reassessment_subject ?primary_student)
        (assigned_proctor_for_subject ?primary_student ?proctor_or_grader)
        (enrolled_in_remediation_a ?primary_student ?remediation_path_a)
        (remediation_path_a_prepared ?remediation_path_a)
        (not
          (primary_student_preparation_flag ?primary_student)
        )
      )
    :effect
      (and
        (primary_student_preparation_flag ?primary_student)
        (primary_student_ready_for_session ?primary_student)
      )
  )
  (:action allocate_support_service_to_primary_student
    :parameters (?primary_student - primary_student ?remediation_path_a - remediation_path_a ?support_service - support_service)
    :precondition
      (and
        (eligible_for_reassessment_subject ?primary_student)
        (enrolled_in_remediation_a ?primary_student ?remediation_path_a)
        (support_service_available ?support_service)
        (not
          (primary_student_preparation_flag ?primary_student)
        )
      )
    :effect
      (and
        (remediation_path_a_support_engaged ?remediation_path_a)
        (primary_student_preparation_flag ?primary_student)
        (allocated_support_service_primary ?primary_student ?support_service)
        (not
          (support_service_available ?support_service)
        )
      )
  )
  (:action finalize_primary_student_preparation
    :parameters (?primary_student - primary_student ?remediation_path_a - remediation_path_a ?assessment_instance - assessment_instance ?support_service - support_service)
    :precondition
      (and
        (eligible_for_reassessment_subject ?primary_student)
        (entity_reserved_assessment ?primary_student ?assessment_instance)
        (enrolled_in_remediation_a ?primary_student ?remediation_path_a)
        (remediation_path_a_support_engaged ?remediation_path_a)
        (allocated_support_service_primary ?primary_student ?support_service)
        (not
          (primary_student_ready_for_session ?primary_student)
        )
      )
    :effect
      (and
        (remediation_path_a_prepared ?remediation_path_a)
        (primary_student_ready_for_session ?primary_student)
        (support_service_available ?support_service)
        (not
          (allocated_support_service_primary ?primary_student ?support_service)
        )
      )
  )
  (:action prepare_remediation_path_b_for_secondary_student
    :parameters (?secondary_student - secondary_student ?remediation_path_b - remediation_path_b ?assessment_instance - assessment_instance)
    :precondition
      (and
        (eligible_for_reassessment_subject ?secondary_student)
        (entity_reserved_assessment ?secondary_student ?assessment_instance)
        (enrolled_in_remediation_b ?secondary_student ?remediation_path_b)
        (not
          (remediation_path_b_prepared ?remediation_path_b)
        )
        (not
          (remediation_path_b_support_engaged ?remediation_path_b)
        )
      )
    :effect (remediation_path_b_prepared ?remediation_path_b)
  )
  (:action confirm_secondary_student_readiness_with_proctor
    :parameters (?secondary_student - secondary_student ?remediation_path_b - remediation_path_b ?proctor_or_grader - proctor_or_grader)
    :precondition
      (and
        (eligible_for_reassessment_subject ?secondary_student)
        (assigned_proctor_for_subject ?secondary_student ?proctor_or_grader)
        (enrolled_in_remediation_b ?secondary_student ?remediation_path_b)
        (remediation_path_b_prepared ?remediation_path_b)
        (not
          (secondary_student_preparation_flag ?secondary_student)
        )
      )
    :effect
      (and
        (secondary_student_preparation_flag ?secondary_student)
        (secondary_student_ready_for_session ?secondary_student)
      )
  )
  (:action allocate_support_service_to_secondary_student
    :parameters (?secondary_student - secondary_student ?remediation_path_b - remediation_path_b ?support_service - support_service)
    :precondition
      (and
        (eligible_for_reassessment_subject ?secondary_student)
        (enrolled_in_remediation_b ?secondary_student ?remediation_path_b)
        (support_service_available ?support_service)
        (not
          (secondary_student_preparation_flag ?secondary_student)
        )
      )
    :effect
      (and
        (remediation_path_b_support_engaged ?remediation_path_b)
        (secondary_student_preparation_flag ?secondary_student)
        (allocated_support_service_secondary ?secondary_student ?support_service)
        (not
          (support_service_available ?support_service)
        )
      )
  )
  (:action finalize_secondary_student_preparation
    :parameters (?secondary_student - secondary_student ?remediation_path_b - remediation_path_b ?assessment_instance - assessment_instance ?support_service - support_service)
    :precondition
      (and
        (eligible_for_reassessment_subject ?secondary_student)
        (entity_reserved_assessment ?secondary_student ?assessment_instance)
        (enrolled_in_remediation_b ?secondary_student ?remediation_path_b)
        (remediation_path_b_support_engaged ?remediation_path_b)
        (allocated_support_service_secondary ?secondary_student ?support_service)
        (not
          (secondary_student_ready_for_session ?secondary_student)
        )
      )
    :effect
      (and
        (remediation_path_b_prepared ?remediation_path_b)
        (secondary_student_ready_for_session ?secondary_student)
        (support_service_available ?support_service)
        (not
          (allocated_support_service_secondary ?secondary_student ?support_service)
        )
      )
  )
  (:action schedule_recovery_assessment_session
    :parameters (?primary_student - primary_student ?secondary_student - secondary_student ?remediation_path_a - remediation_path_a ?remediation_path_b - remediation_path_b ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (primary_student_preparation_flag ?primary_student)
        (secondary_student_preparation_flag ?secondary_student)
        (enrolled_in_remediation_a ?primary_student ?remediation_path_a)
        (enrolled_in_remediation_b ?secondary_student ?remediation_path_b)
        (remediation_path_a_prepared ?remediation_path_a)
        (remediation_path_b_prepared ?remediation_path_b)
        (primary_student_ready_for_session ?primary_student)
        (secondary_student_ready_for_session ?secondary_student)
        (session_slot_available ?recovery_assessment_session)
      )
    :effect
      (and
        (session_registered ?recovery_assessment_session)
        (session_associated_with_remediation_a ?recovery_assessment_session ?remediation_path_a)
        (session_associated_with_remediation_b ?recovery_assessment_session ?remediation_path_b)
        (not
          (session_slot_available ?recovery_assessment_session)
        )
      )
  )
  (:action schedule_recovery_assessment_session_with_support_flag
    :parameters (?primary_student - primary_student ?secondary_student - secondary_student ?remediation_path_a - remediation_path_a ?remediation_path_b - remediation_path_b ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (primary_student_preparation_flag ?primary_student)
        (secondary_student_preparation_flag ?secondary_student)
        (enrolled_in_remediation_a ?primary_student ?remediation_path_a)
        (enrolled_in_remediation_b ?secondary_student ?remediation_path_b)
        (remediation_path_a_support_engaged ?remediation_path_a)
        (remediation_path_b_prepared ?remediation_path_b)
        (not
          (primary_student_ready_for_session ?primary_student)
        )
        (secondary_student_ready_for_session ?secondary_student)
        (session_slot_available ?recovery_assessment_session)
      )
    :effect
      (and
        (session_registered ?recovery_assessment_session)
        (session_associated_with_remediation_a ?recovery_assessment_session ?remediation_path_a)
        (session_associated_with_remediation_b ?recovery_assessment_session ?remediation_path_b)
        (session_requires_additional_evidence ?recovery_assessment_session)
        (not
          (session_slot_available ?recovery_assessment_session)
        )
      )
  )
  (:action schedule_recovery_assessment_session_variant_c
    :parameters (?primary_student - primary_student ?secondary_student - secondary_student ?remediation_path_a - remediation_path_a ?remediation_path_b - remediation_path_b ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (primary_student_preparation_flag ?primary_student)
        (secondary_student_preparation_flag ?secondary_student)
        (enrolled_in_remediation_a ?primary_student ?remediation_path_a)
        (enrolled_in_remediation_b ?secondary_student ?remediation_path_b)
        (remediation_path_a_prepared ?remediation_path_a)
        (remediation_path_b_support_engaged ?remediation_path_b)
        (primary_student_ready_for_session ?primary_student)
        (not
          (secondary_student_ready_for_session ?secondary_student)
        )
        (session_slot_available ?recovery_assessment_session)
      )
    :effect
      (and
        (session_registered ?recovery_assessment_session)
        (session_associated_with_remediation_a ?recovery_assessment_session ?remediation_path_a)
        (session_associated_with_remediation_b ?recovery_assessment_session ?remediation_path_b)
        (session_requires_instructor_recommendation ?recovery_assessment_session)
        (not
          (session_slot_available ?recovery_assessment_session)
        )
      )
  )
  (:action schedule_recovery_assessment_session_combined_flags
    :parameters (?primary_student - primary_student ?secondary_student - secondary_student ?remediation_path_a - remediation_path_a ?remediation_path_b - remediation_path_b ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (primary_student_preparation_flag ?primary_student)
        (secondary_student_preparation_flag ?secondary_student)
        (enrolled_in_remediation_a ?primary_student ?remediation_path_a)
        (enrolled_in_remediation_b ?secondary_student ?remediation_path_b)
        (remediation_path_a_support_engaged ?remediation_path_a)
        (remediation_path_b_support_engaged ?remediation_path_b)
        (not
          (primary_student_ready_for_session ?primary_student)
        )
        (not
          (secondary_student_ready_for_session ?secondary_student)
        )
        (session_slot_available ?recovery_assessment_session)
      )
    :effect
      (and
        (session_registered ?recovery_assessment_session)
        (session_associated_with_remediation_a ?recovery_assessment_session ?remediation_path_a)
        (session_associated_with_remediation_b ?recovery_assessment_session ?remediation_path_b)
        (session_requires_additional_evidence ?recovery_assessment_session)
        (session_requires_instructor_recommendation ?recovery_assessment_session)
        (not
          (session_slot_available ?recovery_assessment_session)
        )
      )
  )
  (:action confirm_session_for_student_attendance
    :parameters (?recovery_assessment_session - recovery_assessment_session ?primary_student - primary_student ?assessment_instance - assessment_instance)
    :precondition
      (and
        (session_registered ?recovery_assessment_session)
        (primary_student_preparation_flag ?primary_student)
        (entity_reserved_assessment ?primary_student ?assessment_instance)
        (not
          (session_validation_completed ?recovery_assessment_session)
        )
      )
    :effect (session_validation_completed ?recovery_assessment_session)
  )
  (:action intake_submission_evidence_for_section_session
    :parameters (?course_section - course_section ?submission_evidence - submission_evidence ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (eligible_for_reassessment_subject ?course_section)
        (section_associated_session ?course_section ?recovery_assessment_session)
        (section_has_submission_evidence ?course_section ?submission_evidence)
        (submission_evidence_available ?submission_evidence)
        (session_registered ?recovery_assessment_session)
        (session_validation_completed ?recovery_assessment_session)
        (not
          (submission_evidence_reviewed ?submission_evidence)
        )
      )
    :effect
      (and
        (submission_evidence_reviewed ?submission_evidence)
        (evidence_associated_with_session ?submission_evidence ?recovery_assessment_session)
        (not
          (submission_evidence_available ?submission_evidence)
        )
      )
  )
  (:action advance_submission_review_stage_one
    :parameters (?course_section - course_section ?submission_evidence - submission_evidence ?recovery_assessment_session - recovery_assessment_session ?assessment_instance - assessment_instance)
    :precondition
      (and
        (eligible_for_reassessment_subject ?course_section)
        (section_has_submission_evidence ?course_section ?submission_evidence)
        (submission_evidence_reviewed ?submission_evidence)
        (evidence_associated_with_session ?submission_evidence ?recovery_assessment_session)
        (entity_reserved_assessment ?course_section ?assessment_instance)
        (not
          (session_requires_additional_evidence ?recovery_assessment_session)
        )
        (not
          (section_review_stage_one_complete ?course_section)
        )
      )
    :effect (section_review_stage_one_complete ?course_section)
  )
  (:action assign_policy_document_to_section
    :parameters (?course_section - course_section ?policy_document - policy_document)
    :precondition
      (and
        (eligible_for_reassessment_subject ?course_section)
        (policy_document_available ?policy_document)
        (not
          (policy_assigned_to_section ?course_section)
        )
      )
    :effect
      (and
        (policy_assigned_to_section ?course_section)
        (section_linked_policy_document ?course_section ?policy_document)
        (not
          (policy_document_available ?policy_document)
        )
      )
  )
  (:action apply_policy_and_advance_section_review
    :parameters (?course_section - course_section ?submission_evidence - submission_evidence ?recovery_assessment_session - recovery_assessment_session ?assessment_instance - assessment_instance ?policy_document - policy_document)
    :precondition
      (and
        (eligible_for_reassessment_subject ?course_section)
        (section_has_submission_evidence ?course_section ?submission_evidence)
        (submission_evidence_reviewed ?submission_evidence)
        (evidence_associated_with_session ?submission_evidence ?recovery_assessment_session)
        (entity_reserved_assessment ?course_section ?assessment_instance)
        (session_requires_additional_evidence ?recovery_assessment_session)
        (policy_assigned_to_section ?course_section)
        (section_linked_policy_document ?course_section ?policy_document)
        (not
          (section_review_stage_one_complete ?course_section)
        )
      )
    :effect
      (and
        (section_review_stage_one_complete ?course_section)
        (section_policy_acknowledged ?course_section)
      )
  )
  (:action apply_grade_adjustment_option_with_proctor
    :parameters (?course_section - course_section ?grade_adjustment_option - grade_adjustment_option ?proctor_or_grader - proctor_or_grader ?submission_evidence - submission_evidence ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (section_review_stage_one_complete ?course_section)
        (section_has_grade_adjustment_option ?course_section ?grade_adjustment_option)
        (assigned_proctor_for_subject ?course_section ?proctor_or_grader)
        (section_has_submission_evidence ?course_section ?submission_evidence)
        (evidence_associated_with_session ?submission_evidence ?recovery_assessment_session)
        (not
          (session_requires_instructor_recommendation ?recovery_assessment_session)
        )
        (not
          (section_review_stage_two_complete ?course_section)
        )
      )
    :effect (section_review_stage_two_complete ?course_section)
  )
  (:action confirm_grade_adjustment_option_with_proctor_after_flag
    :parameters (?course_section - course_section ?grade_adjustment_option - grade_adjustment_option ?proctor_or_grader - proctor_or_grader ?submission_evidence - submission_evidence ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (section_review_stage_one_complete ?course_section)
        (section_has_grade_adjustment_option ?course_section ?grade_adjustment_option)
        (assigned_proctor_for_subject ?course_section ?proctor_or_grader)
        (section_has_submission_evidence ?course_section ?submission_evidence)
        (evidence_associated_with_session ?submission_evidence ?recovery_assessment_session)
        (session_requires_instructor_recommendation ?recovery_assessment_session)
        (not
          (section_review_stage_two_complete ?course_section)
        )
      )
    :effect (section_review_stage_two_complete ?course_section)
  )
  (:action process_administrative_approval_stage_one
    :parameters (?course_section - course_section ?administrative_approval_document - administrative_approval_document ?submission_evidence - submission_evidence ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (section_review_stage_two_complete ?course_section)
        (section_has_administrative_approval ?course_section ?administrative_approval_document)
        (section_has_submission_evidence ?course_section ?submission_evidence)
        (evidence_associated_with_session ?submission_evidence ?recovery_assessment_session)
        (not
          (session_requires_additional_evidence ?recovery_assessment_session)
        )
        (not
          (session_requires_instructor_recommendation ?recovery_assessment_session)
        )
        (not
          (section_review_stage_three_complete ?course_section)
        )
      )
    :effect (section_review_stage_three_complete ?course_section)
  )
  (:action process_administrative_approval_and_register_final_approval
    :parameters (?course_section - course_section ?administrative_approval_document - administrative_approval_document ?submission_evidence - submission_evidence ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (section_review_stage_two_complete ?course_section)
        (section_has_administrative_approval ?course_section ?administrative_approval_document)
        (section_has_submission_evidence ?course_section ?submission_evidence)
        (evidence_associated_with_session ?submission_evidence ?recovery_assessment_session)
        (session_requires_additional_evidence ?recovery_assessment_session)
        (not
          (session_requires_instructor_recommendation ?recovery_assessment_session)
        )
        (not
          (section_review_stage_three_complete ?course_section)
        )
      )
    :effect
      (and
        (section_review_stage_three_complete ?course_section)
        (section_ready_for_finalization ?course_section)
      )
  )
  (:action process_administrative_approval_variant_b
    :parameters (?course_section - course_section ?administrative_approval_document - administrative_approval_document ?submission_evidence - submission_evidence ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (section_review_stage_two_complete ?course_section)
        (section_has_administrative_approval ?course_section ?administrative_approval_document)
        (section_has_submission_evidence ?course_section ?submission_evidence)
        (evidence_associated_with_session ?submission_evidence ?recovery_assessment_session)
        (not
          (session_requires_additional_evidence ?recovery_assessment_session)
        )
        (session_requires_instructor_recommendation ?recovery_assessment_session)
        (not
          (section_review_stage_three_complete ?course_section)
        )
      )
    :effect
      (and
        (section_review_stage_three_complete ?course_section)
        (section_ready_for_finalization ?course_section)
      )
  )
  (:action process_administrative_approval_variant_c
    :parameters (?course_section - course_section ?administrative_approval_document - administrative_approval_document ?submission_evidence - submission_evidence ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (section_review_stage_two_complete ?course_section)
        (section_has_administrative_approval ?course_section ?administrative_approval_document)
        (section_has_submission_evidence ?course_section ?submission_evidence)
        (evidence_associated_with_session ?submission_evidence ?recovery_assessment_session)
        (session_requires_additional_evidence ?recovery_assessment_session)
        (session_requires_instructor_recommendation ?recovery_assessment_session)
        (not
          (section_review_stage_three_complete ?course_section)
        )
      )
    :effect
      (and
        (section_review_stage_three_complete ?course_section)
        (section_ready_for_finalization ?course_section)
      )
  )
  (:action finalize_evidence_review_for_section
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_review_stage_three_complete ?course_section)
        (not
          (section_ready_for_finalization ?course_section)
        )
        (not
          (section_finalized_flag ?course_section)
        )
      )
    :effect
      (and
        (section_finalized_flag ?course_section)
        (final_review_completed_for_entity ?course_section)
      )
  )
  (:action attach_resource_allocation_slot_to_section
    :parameters (?course_section - course_section ?resource_allocation_slot - resource_allocation_slot)
    :precondition
      (and
        (section_review_stage_three_complete ?course_section)
        (section_ready_for_finalization ?course_section)
        (resource_allocation_slot_available ?resource_allocation_slot)
      )
    :effect
      (and
        (section_allocated_resource_slot ?course_section ?resource_allocation_slot)
        (not
          (resource_allocation_slot_available ?resource_allocation_slot)
        )
      )
  )
  (:action apply_final_preconditions_for_section_grading
    :parameters (?course_section - course_section ?primary_student - primary_student ?secondary_student - secondary_student ?assessment_instance - assessment_instance ?resource_allocation_slot - resource_allocation_slot)
    :precondition
      (and
        (section_review_stage_three_complete ?course_section)
        (section_ready_for_finalization ?course_section)
        (section_allocated_resource_slot ?course_section ?resource_allocation_slot)
        (section_contains_primary_student ?course_section ?primary_student)
        (section_contains_secondary_student ?course_section ?secondary_student)
        (primary_student_ready_for_session ?primary_student)
        (secondary_student_ready_for_session ?secondary_student)
        (entity_reserved_assessment ?course_section ?assessment_instance)
        (not
          (section_review_finalized ?course_section)
        )
      )
    :effect (section_review_finalized ?course_section)
  )
  (:action finalize_section_review_after_adjustments
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_review_stage_three_complete ?course_section)
        (section_review_finalized ?course_section)
        (not
          (section_finalized_flag ?course_section)
        )
      )
    :effect
      (and
        (section_finalized_flag ?course_section)
        (final_review_completed_for_entity ?course_section)
      )
  )
  (:action apply_instructor_recommendation_to_section
    :parameters (?course_section - course_section ?instructor_recommendation - instructor_recommendation ?assessment_instance - assessment_instance)
    :precondition
      (and
        (eligible_for_reassessment_subject ?course_section)
        (entity_reserved_assessment ?course_section ?assessment_instance)
        (instructor_recommendation_available ?instructor_recommendation)
        (section_linked_instructor_recommendation ?course_section ?instructor_recommendation)
        (not
          (instructor_recommendation_applied ?course_section)
        )
      )
    :effect
      (and
        (instructor_recommendation_applied ?course_section)
        (not
          (instructor_recommendation_available ?instructor_recommendation)
        )
      )
  )
  (:action acknowledge_instructor_recommendation_with_proctor
    :parameters (?course_section - course_section ?proctor_or_grader - proctor_or_grader)
    :precondition
      (and
        (instructor_recommendation_applied ?course_section)
        (assigned_proctor_for_subject ?course_section ?proctor_or_grader)
        (not
          (section_instructor_recommendation_confirmed ?course_section)
        )
      )
    :effect (section_instructor_recommendation_confirmed ?course_section)
  )
  (:action initiate_administrative_approval_for_section
    :parameters (?course_section - course_section ?administrative_approval_document - administrative_approval_document)
    :precondition
      (and
        (section_instructor_recommendation_confirmed ?course_section)
        (section_has_administrative_approval ?course_section ?administrative_approval_document)
        (not
          (section_administrative_approval_initiated ?course_section)
        )
      )
    :effect (section_administrative_approval_initiated ?course_section)
  )
  (:action complete_admin_approval_and_finalize_section
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_administrative_approval_initiated ?course_section)
        (not
          (section_finalized_flag ?course_section)
        )
      )
    :effect
      (and
        (section_finalized_flag ?course_section)
        (final_review_completed_for_entity ?course_section)
      )
  )
  (:action finalize_primary_student_review
    :parameters (?primary_student - primary_student ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (primary_student_preparation_flag ?primary_student)
        (primary_student_ready_for_session ?primary_student)
        (session_registered ?recovery_assessment_session)
        (session_validation_completed ?recovery_assessment_session)
        (not
          (final_review_completed_for_entity ?primary_student)
        )
      )
    :effect (final_review_completed_for_entity ?primary_student)
  )
  (:action finalize_secondary_student_review
    :parameters (?secondary_student - secondary_student ?recovery_assessment_session - recovery_assessment_session)
    :precondition
      (and
        (secondary_student_preparation_flag ?secondary_student)
        (secondary_student_ready_for_session ?secondary_student)
        (session_registered ?recovery_assessment_session)
        (session_validation_completed ?recovery_assessment_session)
        (not
          (final_review_completed_for_entity ?secondary_student)
        )
      )
    :effect (final_review_completed_for_entity ?secondary_student)
  )
  (:action authorize_grade_change_for_enrollment
    :parameters (?student_enrollment_record - student_enrollment_record ?eligibility_token - eligibility_token ?assessment_instance - assessment_instance)
    :precondition
      (and
        (final_review_completed_for_entity ?student_enrollment_record)
        (entity_reserved_assessment ?student_enrollment_record ?assessment_instance)
        (eligibility_token_available ?eligibility_token)
        (not
          (grade_change_authorized_for_entity ?student_enrollment_record)
        )
      )
    :effect
      (and
        (grade_change_authorized_for_entity ?student_enrollment_record)
        (entity_linked_eligibility_token ?student_enrollment_record ?eligibility_token)
        (not
          (eligibility_token_available ?eligibility_token)
        )
      )
  )
  (:action apply_grade_change_and_release_resources_primary
    :parameters (?primary_student - primary_student ?staff_resource - staff_resource ?eligibility_token - eligibility_token)
    :precondition
      (and
        (grade_change_authorized_for_entity ?primary_student)
        (assigned_staff_for_subject ?primary_student ?staff_resource)
        (entity_linked_eligibility_token ?primary_student ?eligibility_token)
        (not
          (grade_change_applied_to_entity ?primary_student)
        )
      )
    :effect
      (and
        (grade_change_applied_to_entity ?primary_student)
        (staff_resource_available ?staff_resource)
        (eligibility_token_available ?eligibility_token)
      )
  )
  (:action apply_grade_change_and_release_resources_secondary
    :parameters (?secondary_student - secondary_student ?staff_resource - staff_resource ?eligibility_token - eligibility_token)
    :precondition
      (and
        (grade_change_authorized_for_entity ?secondary_student)
        (assigned_staff_for_subject ?secondary_student ?staff_resource)
        (entity_linked_eligibility_token ?secondary_student ?eligibility_token)
        (not
          (grade_change_applied_to_entity ?secondary_student)
        )
      )
    :effect
      (and
        (grade_change_applied_to_entity ?secondary_student)
        (staff_resource_available ?staff_resource)
        (eligibility_token_available ?eligibility_token)
      )
  )
  (:action apply_grade_change_and_release_resources_for_section
    :parameters (?course_section - course_section ?staff_resource - staff_resource ?eligibility_token - eligibility_token)
    :precondition
      (and
        (grade_change_authorized_for_entity ?course_section)
        (assigned_staff_for_subject ?course_section ?staff_resource)
        (entity_linked_eligibility_token ?course_section ?eligibility_token)
        (not
          (grade_change_applied_to_entity ?course_section)
        )
      )
    :effect
      (and
        (grade_change_applied_to_entity ?course_section)
        (staff_resource_available ?staff_resource)
        (eligibility_token_available ?eligibility_token)
      )
  )
)

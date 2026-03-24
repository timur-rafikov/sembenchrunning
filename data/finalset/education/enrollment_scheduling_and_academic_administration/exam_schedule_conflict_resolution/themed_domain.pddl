(define (domain exam_schedule_conflict_resolution)
  (:requirements :strips :typing :negative-preconditions)
  (:types person_or_resource - object entity_type - object physical_resource_category - object case_root - object exam_case - case_root coordinator - person_or_resource course_exam_component - person_or_resource instructor_approver - person_or_resource room_feature - person_or_resource evaluation_mode - person_or_resource evidence_document - person_or_resource proctor - person_or_resource board_approval_token - person_or_resource accommodation_request - entity_type student - entity_type external_stakeholder - entity_type time_slot - physical_resource_category room - physical_resource_category exam_instance - physical_resource_category exam_case_subtype - exam_case exam_record_subtype - exam_case course_offering - exam_case_subtype student_cohort - exam_case_subtype exam_record - exam_record_subtype)
  (:predicates
    (record_opened ?exam_case - exam_case)
    (record_verified ?exam_case - exam_case)
    (coordinator_assigned ?exam_case - exam_case)
    (record_resolved ?exam_case - exam_case)
    (record_ready_for_finalization ?exam_case - exam_case)
    (record_finalized ?exam_case - exam_case)
    (coordinator_available ?coordinator - coordinator)
    (record_assigned_to_coordinator ?exam_case - exam_case ?coordinator - coordinator)
    (exam_component_available ?course_exam_component - course_exam_component)
    (record_exam_component_linked ?exam_case - exam_case ?course_exam_component - course_exam_component)
    (approver_available ?instructor_approver - instructor_approver)
    (record_approver_assigned ?exam_case - exam_case ?instructor_approver - instructor_approver)
    (accommodation_available ?accommodation_request - accommodation_request)
    (course_offering_accommodation_linked ?course_offering - course_offering ?accommodation_request - accommodation_request)
    (student_cohort_accommodation_linked ?student_cohort - student_cohort ?accommodation_request - accommodation_request)
    (course_offering_timeslot_linked ?course_offering - course_offering ?time_slot - time_slot)
    (timeslot_reserved ?time_slot - time_slot)
    (timeslot_tentatively_blocked ?time_slot - time_slot)
    (course_offering_allocation_confirmed ?course_offering - course_offering)
    (student_cohort_room_linked ?student_cohort - student_cohort ?room - room)
    (room_reserved ?room - room)
    (room_tentatively_blocked ?room - room)
    (student_cohort_allocation_confirmed ?student_cohort - student_cohort)
    (exam_instance_available ?exam_instance - exam_instance)
    (exam_instance_prepared ?exam_instance - exam_instance)
    (exam_instance_assigned_timeslot ?exam_instance - exam_instance ?time_slot - time_slot)
    (exam_instance_assigned_room ?exam_instance - exam_instance ?room - room)
    (instance_requires_check_a ?exam_instance - exam_instance)
    (instance_requires_check_b ?exam_instance - exam_instance)
    (instance_final_ready ?exam_instance - exam_instance)
    (exam_record_requires_course_offering ?exam_record - exam_record ?course_offering - course_offering)
    (exam_record_requires_student_cohort ?exam_record - exam_record ?student_cohort - student_cohort)
    (exam_record_requires_instance ?exam_record - exam_record ?exam_instance - exam_instance)
    (student_unallocated ?student - student)
    (exam_record_has_student ?exam_record - exam_record ?student - student)
    (student_allocated ?student - student)
    (student_allocated_to_instance ?student - student ?exam_instance - exam_instance)
    (record_staff_assignment_completed ?exam_record - exam_record)
    (record_proctor_assignment_completed ?exam_record - exam_record)
    (record_ready_for_review ?exam_record - exam_record)
    (room_feature_reserved ?exam_record - exam_record)
    (room_feature_confirmation_recorded ?exam_record - exam_record)
    (quality_checks_passed ?exam_record - exam_record)
    (record_validated_for_finalization ?exam_record - exam_record)
    (external_stakeholder_available ?external_stakeholder - external_stakeholder)
    (record_linked_to_external_stakeholder ?exam_record - exam_record ?external_stakeholder - external_stakeholder)
    (stakeholder_engaged ?exam_record - exam_record)
    (stakeholder_approval_pending ?exam_record - exam_record)
    (stakeholder_approved ?exam_record - exam_record)
    (room_feature_available ?room_feature - room_feature)
    (record_linked_to_room_feature ?exam_record - exam_record ?room_feature - room_feature)
    (evaluation_mode_available ?evaluation_mode - evaluation_mode)
    (record_linked_to_evaluation_mode ?exam_record - exam_record ?evaluation_mode - evaluation_mode)
    (proctor_available ?proctor - proctor)
    (record_assigned_proctor ?exam_record - exam_record ?proctor - proctor)
    (board_approval_token_available ?board_approval_token - board_approval_token)
    (record_linked_to_board_approval_token ?exam_record - exam_record ?board_approval_token - board_approval_token)
    (evidence_document_available ?evidence_document - evidence_document)
    (record_linked_to_evidence_document ?exam_case - exam_case ?evidence_document - evidence_document)
    (course_offering_locked_for_allocation ?course_offering - course_offering)
    (student_cohort_locked_for_allocation ?student_cohort - student_cohort)
    (record_marked_complete ?exam_record - exam_record)
  )
  (:action open_conflict_record
    :parameters (?exam_case - exam_case)
    :precondition
      (and
        (not
          (record_opened ?exam_case)
        )
        (not
          (record_resolved ?exam_case)
        )
      )
    :effect (record_opened ?exam_case)
  )
  (:action assign_coordinator_to_record
    :parameters (?exam_case - exam_case ?coordinator - coordinator)
    :precondition
      (and
        (record_opened ?exam_case)
        (not
          (coordinator_assigned ?exam_case)
        )
        (coordinator_available ?coordinator)
      )
    :effect
      (and
        (coordinator_assigned ?exam_case)
        (record_assigned_to_coordinator ?exam_case ?coordinator)
        (not
          (coordinator_available ?coordinator)
        )
      )
  )
  (:action attach_exam_component_to_record
    :parameters (?exam_case - exam_case ?course_exam_component - course_exam_component)
    :precondition
      (and
        (record_opened ?exam_case)
        (coordinator_assigned ?exam_case)
        (exam_component_available ?course_exam_component)
      )
    :effect
      (and
        (record_exam_component_linked ?exam_case ?course_exam_component)
        (not
          (exam_component_available ?course_exam_component)
        )
      )
  )
  (:action verify_record
    :parameters (?exam_case - exam_case ?course_exam_component - course_exam_component)
    :precondition
      (and
        (record_opened ?exam_case)
        (coordinator_assigned ?exam_case)
        (record_exam_component_linked ?exam_case ?course_exam_component)
        (not
          (record_verified ?exam_case)
        )
      )
    :effect (record_verified ?exam_case)
  )
  (:action unlink_exam_component_from_record
    :parameters (?exam_case - exam_case ?course_exam_component - course_exam_component)
    :precondition
      (and
        (record_exam_component_linked ?exam_case ?course_exam_component)
      )
    :effect
      (and
        (exam_component_available ?course_exam_component)
        (not
          (record_exam_component_linked ?exam_case ?course_exam_component)
        )
      )
  )
  (:action assign_approver_to_record
    :parameters (?exam_case - exam_case ?instructor_approver - instructor_approver)
    :precondition
      (and
        (record_verified ?exam_case)
        (approver_available ?instructor_approver)
      )
    :effect
      (and
        (record_approver_assigned ?exam_case ?instructor_approver)
        (not
          (approver_available ?instructor_approver)
        )
      )
  )
  (:action release_approver_from_record
    :parameters (?exam_case - exam_case ?instructor_approver - instructor_approver)
    :precondition
      (and
        (record_approver_assigned ?exam_case ?instructor_approver)
      )
    :effect
      (and
        (approver_available ?instructor_approver)
        (not
          (record_approver_assigned ?exam_case ?instructor_approver)
        )
      )
  )
  (:action assign_proctor_to_record
    :parameters (?exam_record - exam_record ?proctor - proctor)
    :precondition
      (and
        (record_verified ?exam_record)
        (proctor_available ?proctor)
      )
    :effect
      (and
        (record_assigned_proctor ?exam_record ?proctor)
        (not
          (proctor_available ?proctor)
        )
      )
  )
  (:action release_proctor_from_record
    :parameters (?exam_record - exam_record ?proctor - proctor)
    :precondition
      (and
        (record_assigned_proctor ?exam_record ?proctor)
      )
    :effect
      (and
        (proctor_available ?proctor)
        (not
          (record_assigned_proctor ?exam_record ?proctor)
        )
      )
  )
  (:action attach_board_approval_token_to_record
    :parameters (?exam_record - exam_record ?board_approval_token - board_approval_token)
    :precondition
      (and
        (record_verified ?exam_record)
        (board_approval_token_available ?board_approval_token)
      )
    :effect
      (and
        (record_linked_to_board_approval_token ?exam_record ?board_approval_token)
        (not
          (board_approval_token_available ?board_approval_token)
        )
      )
  )
  (:action detach_board_approval_token_from_record
    :parameters (?exam_record - exam_record ?board_approval_token - board_approval_token)
    :precondition
      (and
        (record_linked_to_board_approval_token ?exam_record ?board_approval_token)
      )
    :effect
      (and
        (board_approval_token_available ?board_approval_token)
        (not
          (record_linked_to_board_approval_token ?exam_record ?board_approval_token)
        )
      )
  )
  (:action reserve_timeslot_for_course_offering
    :parameters (?course_offering - course_offering ?time_slot - time_slot ?course_exam_component - course_exam_component)
    :precondition
      (and
        (record_verified ?course_offering)
        (record_exam_component_linked ?course_offering ?course_exam_component)
        (course_offering_timeslot_linked ?course_offering ?time_slot)
        (not
          (timeslot_reserved ?time_slot)
        )
        (not
          (timeslot_tentatively_blocked ?time_slot)
        )
      )
    :effect (timeslot_reserved ?time_slot)
  )
  (:action confirm_course_offering_allocation
    :parameters (?course_offering - course_offering ?time_slot - time_slot ?instructor_approver - instructor_approver)
    :precondition
      (and
        (record_verified ?course_offering)
        (record_approver_assigned ?course_offering ?instructor_approver)
        (course_offering_timeslot_linked ?course_offering ?time_slot)
        (timeslot_reserved ?time_slot)
        (not
          (course_offering_locked_for_allocation ?course_offering)
        )
      )
    :effect
      (and
        (course_offering_locked_for_allocation ?course_offering)
        (course_offering_allocation_confirmed ?course_offering)
      )
  )
  (:action apply_accommodation_to_course_offering
    :parameters (?course_offering - course_offering ?time_slot - time_slot ?accommodation_request - accommodation_request)
    :precondition
      (and
        (record_verified ?course_offering)
        (course_offering_timeslot_linked ?course_offering ?time_slot)
        (accommodation_available ?accommodation_request)
        (not
          (course_offering_locked_for_allocation ?course_offering)
        )
      )
    :effect
      (and
        (timeslot_tentatively_blocked ?time_slot)
        (course_offering_locked_for_allocation ?course_offering)
        (course_offering_accommodation_linked ?course_offering ?accommodation_request)
        (not
          (accommodation_available ?accommodation_request)
        )
      )
  )
  (:action confirm_accommodation_allocation_for_course_offering
    :parameters (?course_offering - course_offering ?time_slot - time_slot ?course_exam_component - course_exam_component ?accommodation_request - accommodation_request)
    :precondition
      (and
        (record_verified ?course_offering)
        (record_exam_component_linked ?course_offering ?course_exam_component)
        (course_offering_timeslot_linked ?course_offering ?time_slot)
        (timeslot_tentatively_blocked ?time_slot)
        (course_offering_accommodation_linked ?course_offering ?accommodation_request)
        (not
          (course_offering_allocation_confirmed ?course_offering)
        )
      )
    :effect
      (and
        (timeslot_reserved ?time_slot)
        (course_offering_allocation_confirmed ?course_offering)
        (accommodation_available ?accommodation_request)
        (not
          (course_offering_accommodation_linked ?course_offering ?accommodation_request)
        )
      )
  )
  (:action reserve_room_for_student_cohort
    :parameters (?student_cohort - student_cohort ?room - room ?course_exam_component - course_exam_component)
    :precondition
      (and
        (record_verified ?student_cohort)
        (record_exam_component_linked ?student_cohort ?course_exam_component)
        (student_cohort_room_linked ?student_cohort ?room)
        (not
          (room_reserved ?room)
        )
        (not
          (room_tentatively_blocked ?room)
        )
      )
    :effect (room_reserved ?room)
  )
  (:action confirm_student_cohort_allocation
    :parameters (?student_cohort - student_cohort ?room - room ?instructor_approver - instructor_approver)
    :precondition
      (and
        (record_verified ?student_cohort)
        (record_approver_assigned ?student_cohort ?instructor_approver)
        (student_cohort_room_linked ?student_cohort ?room)
        (room_reserved ?room)
        (not
          (student_cohort_locked_for_allocation ?student_cohort)
        )
      )
    :effect
      (and
        (student_cohort_locked_for_allocation ?student_cohort)
        (student_cohort_allocation_confirmed ?student_cohort)
      )
  )
  (:action apply_accommodation_to_student_cohort
    :parameters (?student_cohort - student_cohort ?room - room ?accommodation_request - accommodation_request)
    :precondition
      (and
        (record_verified ?student_cohort)
        (student_cohort_room_linked ?student_cohort ?room)
        (accommodation_available ?accommodation_request)
        (not
          (student_cohort_locked_for_allocation ?student_cohort)
        )
      )
    :effect
      (and
        (room_tentatively_blocked ?room)
        (student_cohort_locked_for_allocation ?student_cohort)
        (student_cohort_accommodation_linked ?student_cohort ?accommodation_request)
        (not
          (accommodation_available ?accommodation_request)
        )
      )
  )
  (:action confirm_accommodation_allocation_for_student_cohort
    :parameters (?student_cohort - student_cohort ?room - room ?course_exam_component - course_exam_component ?accommodation_request - accommodation_request)
    :precondition
      (and
        (record_verified ?student_cohort)
        (record_exam_component_linked ?student_cohort ?course_exam_component)
        (student_cohort_room_linked ?student_cohort ?room)
        (room_tentatively_blocked ?room)
        (student_cohort_accommodation_linked ?student_cohort ?accommodation_request)
        (not
          (student_cohort_allocation_confirmed ?student_cohort)
        )
      )
    :effect
      (and
        (room_reserved ?room)
        (student_cohort_allocation_confirmed ?student_cohort)
        (accommodation_available ?accommodation_request)
        (not
          (student_cohort_accommodation_linked ?student_cohort ?accommodation_request)
        )
      )
  )
  (:action create_provisional_exam_instance
    :parameters (?course_offering - course_offering ?student_cohort - student_cohort ?time_slot - time_slot ?room - room ?exam_instance - exam_instance)
    :precondition
      (and
        (course_offering_locked_for_allocation ?course_offering)
        (student_cohort_locked_for_allocation ?student_cohort)
        (course_offering_timeslot_linked ?course_offering ?time_slot)
        (student_cohort_room_linked ?student_cohort ?room)
        (timeslot_reserved ?time_slot)
        (room_reserved ?room)
        (course_offering_allocation_confirmed ?course_offering)
        (student_cohort_allocation_confirmed ?student_cohort)
        (exam_instance_available ?exam_instance)
      )
    :effect
      (and
        (exam_instance_prepared ?exam_instance)
        (exam_instance_assigned_timeslot ?exam_instance ?time_slot)
        (exam_instance_assigned_room ?exam_instance ?room)
        (not
          (exam_instance_available ?exam_instance)
        )
      )
  )
  (:action create_provisional_exam_instance_with_check_a
    :parameters (?course_offering - course_offering ?student_cohort - student_cohort ?time_slot - time_slot ?room - room ?exam_instance - exam_instance)
    :precondition
      (and
        (course_offering_locked_for_allocation ?course_offering)
        (student_cohort_locked_for_allocation ?student_cohort)
        (course_offering_timeslot_linked ?course_offering ?time_slot)
        (student_cohort_room_linked ?student_cohort ?room)
        (timeslot_tentatively_blocked ?time_slot)
        (room_reserved ?room)
        (not
          (course_offering_allocation_confirmed ?course_offering)
        )
        (student_cohort_allocation_confirmed ?student_cohort)
        (exam_instance_available ?exam_instance)
      )
    :effect
      (and
        (exam_instance_prepared ?exam_instance)
        (exam_instance_assigned_timeslot ?exam_instance ?time_slot)
        (exam_instance_assigned_room ?exam_instance ?room)
        (instance_requires_check_a ?exam_instance)
        (not
          (exam_instance_available ?exam_instance)
        )
      )
  )
  (:action create_provisional_exam_instance_with_check_b
    :parameters (?course_offering - course_offering ?student_cohort - student_cohort ?time_slot - time_slot ?room - room ?exam_instance - exam_instance)
    :precondition
      (and
        (course_offering_locked_for_allocation ?course_offering)
        (student_cohort_locked_for_allocation ?student_cohort)
        (course_offering_timeslot_linked ?course_offering ?time_slot)
        (student_cohort_room_linked ?student_cohort ?room)
        (timeslot_reserved ?time_slot)
        (room_tentatively_blocked ?room)
        (course_offering_allocation_confirmed ?course_offering)
        (not
          (student_cohort_allocation_confirmed ?student_cohort)
        )
        (exam_instance_available ?exam_instance)
      )
    :effect
      (and
        (exam_instance_prepared ?exam_instance)
        (exam_instance_assigned_timeslot ?exam_instance ?time_slot)
        (exam_instance_assigned_room ?exam_instance ?room)
        (instance_requires_check_b ?exam_instance)
        (not
          (exam_instance_available ?exam_instance)
        )
      )
  )
  (:action create_provisional_exam_instance_with_checks_a_and_b
    :parameters (?course_offering - course_offering ?student_cohort - student_cohort ?time_slot - time_slot ?room - room ?exam_instance - exam_instance)
    :precondition
      (and
        (course_offering_locked_for_allocation ?course_offering)
        (student_cohort_locked_for_allocation ?student_cohort)
        (course_offering_timeslot_linked ?course_offering ?time_slot)
        (student_cohort_room_linked ?student_cohort ?room)
        (timeslot_tentatively_blocked ?time_slot)
        (room_tentatively_blocked ?room)
        (not
          (course_offering_allocation_confirmed ?course_offering)
        )
        (not
          (student_cohort_allocation_confirmed ?student_cohort)
        )
        (exam_instance_available ?exam_instance)
      )
    :effect
      (and
        (exam_instance_prepared ?exam_instance)
        (exam_instance_assigned_timeslot ?exam_instance ?time_slot)
        (exam_instance_assigned_room ?exam_instance ?room)
        (instance_requires_check_a ?exam_instance)
        (instance_requires_check_b ?exam_instance)
        (not
          (exam_instance_available ?exam_instance)
        )
      )
  )
  (:action finalize_exam_instance_readiness
    :parameters (?exam_instance - exam_instance ?course_offering - course_offering ?course_exam_component - course_exam_component)
    :precondition
      (and
        (exam_instance_prepared ?exam_instance)
        (course_offering_locked_for_allocation ?course_offering)
        (record_exam_component_linked ?course_offering ?course_exam_component)
        (not
          (instance_final_ready ?exam_instance)
        )
      )
    :effect (instance_final_ready ?exam_instance)
  )
  (:action allocate_student_to_exam_instance
    :parameters (?exam_record - exam_record ?student - student ?exam_instance - exam_instance)
    :precondition
      (and
        (record_verified ?exam_record)
        (exam_record_requires_instance ?exam_record ?exam_instance)
        (exam_record_has_student ?exam_record ?student)
        (student_unallocated ?student)
        (exam_instance_prepared ?exam_instance)
        (instance_final_ready ?exam_instance)
        (not
          (student_allocated ?student)
        )
      )
    :effect
      (and
        (student_allocated ?student)
        (student_allocated_to_instance ?student ?exam_instance)
        (not
          (student_unallocated ?student)
        )
      )
  )
  (:action complete_staff_assignment_for_record
    :parameters (?exam_record - exam_record ?student - student ?exam_instance - exam_instance ?course_exam_component - course_exam_component)
    :precondition
      (and
        (record_verified ?exam_record)
        (exam_record_has_student ?exam_record ?student)
        (student_allocated ?student)
        (student_allocated_to_instance ?student ?exam_instance)
        (record_exam_component_linked ?exam_record ?course_exam_component)
        (not
          (instance_requires_check_a ?exam_instance)
        )
        (not
          (record_staff_assignment_completed ?exam_record)
        )
      )
    :effect (record_staff_assignment_completed ?exam_record)
  )
  (:action reserve_room_feature_for_record
    :parameters (?exam_record - exam_record ?room_feature - room_feature)
    :precondition
      (and
        (record_verified ?exam_record)
        (room_feature_available ?room_feature)
        (not
          (room_feature_reserved ?exam_record)
        )
      )
    :effect
      (and
        (room_feature_reserved ?exam_record)
        (record_linked_to_room_feature ?exam_record ?room_feature)
        (not
          (room_feature_available ?room_feature)
        )
      )
  )
  (:action confirm_room_feature_and_complete_staff_assignment
    :parameters (?exam_record - exam_record ?student - student ?exam_instance - exam_instance ?course_exam_component - course_exam_component ?room_feature - room_feature)
    :precondition
      (and
        (record_verified ?exam_record)
        (exam_record_has_student ?exam_record ?student)
        (student_allocated ?student)
        (student_allocated_to_instance ?student ?exam_instance)
        (record_exam_component_linked ?exam_record ?course_exam_component)
        (instance_requires_check_a ?exam_instance)
        (room_feature_reserved ?exam_record)
        (record_linked_to_room_feature ?exam_record ?room_feature)
        (not
          (record_staff_assignment_completed ?exam_record)
        )
      )
    :effect
      (and
        (record_staff_assignment_completed ?exam_record)
        (room_feature_confirmation_recorded ?exam_record)
      )
  )
  (:action assign_proctor_standard
    :parameters (?exam_record - exam_record ?proctor - proctor ?instructor_approver - instructor_approver ?student - student ?exam_instance - exam_instance)
    :precondition
      (and
        (record_staff_assignment_completed ?exam_record)
        (record_assigned_proctor ?exam_record ?proctor)
        (record_approver_assigned ?exam_record ?instructor_approver)
        (exam_record_has_student ?exam_record ?student)
        (student_allocated_to_instance ?student ?exam_instance)
        (not
          (instance_requires_check_b ?exam_instance)
        )
        (not
          (record_proctor_assignment_completed ?exam_record)
        )
      )
    :effect (record_proctor_assignment_completed ?exam_record)
  )
  (:action assign_proctor_with_instance_flag
    :parameters (?exam_record - exam_record ?proctor - proctor ?instructor_approver - instructor_approver ?student - student ?exam_instance - exam_instance)
    :precondition
      (and
        (record_staff_assignment_completed ?exam_record)
        (record_assigned_proctor ?exam_record ?proctor)
        (record_approver_assigned ?exam_record ?instructor_approver)
        (exam_record_has_student ?exam_record ?student)
        (student_allocated_to_instance ?student ?exam_instance)
        (instance_requires_check_b ?exam_instance)
        (not
          (record_proctor_assignment_completed ?exam_record)
        )
      )
    :effect (record_proctor_assignment_completed ?exam_record)
  )
  (:action advance_record_to_review_no_instance_checks
    :parameters (?exam_record - exam_record ?board_approval_token - board_approval_token ?student - student ?exam_instance - exam_instance)
    :precondition
      (and
        (record_proctor_assignment_completed ?exam_record)
        (record_linked_to_board_approval_token ?exam_record ?board_approval_token)
        (exam_record_has_student ?exam_record ?student)
        (student_allocated_to_instance ?student ?exam_instance)
        (not
          (instance_requires_check_a ?exam_instance)
        )
        (not
          (instance_requires_check_b ?exam_instance)
        )
        (not
          (record_ready_for_review ?exam_record)
        )
      )
    :effect (record_ready_for_review ?exam_record)
  )
  (:action advance_record_to_review_and_pass_quality_check_a
    :parameters (?exam_record - exam_record ?board_approval_token - board_approval_token ?student - student ?exam_instance - exam_instance)
    :precondition
      (and
        (record_proctor_assignment_completed ?exam_record)
        (record_linked_to_board_approval_token ?exam_record ?board_approval_token)
        (exam_record_has_student ?exam_record ?student)
        (student_allocated_to_instance ?student ?exam_instance)
        (instance_requires_check_a ?exam_instance)
        (not
          (instance_requires_check_b ?exam_instance)
        )
        (not
          (record_ready_for_review ?exam_record)
        )
      )
    :effect
      (and
        (record_ready_for_review ?exam_record)
        (quality_checks_passed ?exam_record)
      )
  )
  (:action advance_record_to_review_and_pass_quality_check_b
    :parameters (?exam_record - exam_record ?board_approval_token - board_approval_token ?student - student ?exam_instance - exam_instance)
    :precondition
      (and
        (record_proctor_assignment_completed ?exam_record)
        (record_linked_to_board_approval_token ?exam_record ?board_approval_token)
        (exam_record_has_student ?exam_record ?student)
        (student_allocated_to_instance ?student ?exam_instance)
        (not
          (instance_requires_check_a ?exam_instance)
        )
        (instance_requires_check_b ?exam_instance)
        (not
          (record_ready_for_review ?exam_record)
        )
      )
    :effect
      (and
        (record_ready_for_review ?exam_record)
        (quality_checks_passed ?exam_record)
      )
  )
  (:action advance_record_to_review_and_pass_quality_checks
    :parameters (?exam_record - exam_record ?board_approval_token - board_approval_token ?student - student ?exam_instance - exam_instance)
    :precondition
      (and
        (record_proctor_assignment_completed ?exam_record)
        (record_linked_to_board_approval_token ?exam_record ?board_approval_token)
        (exam_record_has_student ?exam_record ?student)
        (student_allocated_to_instance ?student ?exam_instance)
        (instance_requires_check_a ?exam_instance)
        (instance_requires_check_b ?exam_instance)
        (not
          (record_ready_for_review ?exam_record)
        )
      )
    :effect
      (and
        (record_ready_for_review ?exam_record)
        (quality_checks_passed ?exam_record)
      )
  )
  (:action complete_record_administratively
    :parameters (?exam_record - exam_record)
    :precondition
      (and
        (record_ready_for_review ?exam_record)
        (not
          (quality_checks_passed ?exam_record)
        )
        (not
          (record_marked_complete ?exam_record)
        )
      )
    :effect
      (and
        (record_marked_complete ?exam_record)
        (record_ready_for_finalization ?exam_record)
      )
  )
  (:action assign_evaluation_mode_to_record
    :parameters (?exam_record - exam_record ?evaluation_mode - evaluation_mode)
    :precondition
      (and
        (record_ready_for_review ?exam_record)
        (quality_checks_passed ?exam_record)
        (evaluation_mode_available ?evaluation_mode)
      )
    :effect
      (and
        (record_linked_to_evaluation_mode ?exam_record ?evaluation_mode)
        (not
          (evaluation_mode_available ?evaluation_mode)
        )
      )
  )
  (:action validate_record_for_finalization
    :parameters (?exam_record - exam_record ?course_offering - course_offering ?student_cohort - student_cohort ?course_exam_component - course_exam_component ?evaluation_mode - evaluation_mode)
    :precondition
      (and
        (record_ready_for_review ?exam_record)
        (quality_checks_passed ?exam_record)
        (record_linked_to_evaluation_mode ?exam_record ?evaluation_mode)
        (exam_record_requires_course_offering ?exam_record ?course_offering)
        (exam_record_requires_student_cohort ?exam_record ?student_cohort)
        (course_offering_allocation_confirmed ?course_offering)
        (student_cohort_allocation_confirmed ?student_cohort)
        (record_exam_component_linked ?exam_record ?course_exam_component)
        (not
          (record_validated_for_finalization ?exam_record)
        )
      )
    :effect (record_validated_for_finalization ?exam_record)
  )
  (:action complete_record_after_validation
    :parameters (?exam_record - exam_record)
    :precondition
      (and
        (record_ready_for_review ?exam_record)
        (record_validated_for_finalization ?exam_record)
        (not
          (record_marked_complete ?exam_record)
        )
      )
    :effect
      (and
        (record_marked_complete ?exam_record)
        (record_ready_for_finalization ?exam_record)
      )
  )
  (:action engage_external_stakeholder_for_record
    :parameters (?exam_record - exam_record ?external_stakeholder - external_stakeholder ?course_exam_component - course_exam_component)
    :precondition
      (and
        (record_verified ?exam_record)
        (record_exam_component_linked ?exam_record ?course_exam_component)
        (external_stakeholder_available ?external_stakeholder)
        (record_linked_to_external_stakeholder ?exam_record ?external_stakeholder)
        (not
          (stakeholder_engaged ?exam_record)
        )
      )
    :effect
      (and
        (stakeholder_engaged ?exam_record)
        (not
          (external_stakeholder_available ?external_stakeholder)
        )
      )
  )
  (:action set_stakeholder_approval_pending_for_record
    :parameters (?exam_record - exam_record ?instructor_approver - instructor_approver)
    :precondition
      (and
        (stakeholder_engaged ?exam_record)
        (record_approver_assigned ?exam_record ?instructor_approver)
        (not
          (stakeholder_approval_pending ?exam_record)
        )
      )
    :effect (stakeholder_approval_pending ?exam_record)
  )
  (:action stakeholder_approve_record
    :parameters (?exam_record - exam_record ?board_approval_token - board_approval_token)
    :precondition
      (and
        (stakeholder_approval_pending ?exam_record)
        (record_linked_to_board_approval_token ?exam_record ?board_approval_token)
        (not
          (stakeholder_approved ?exam_record)
        )
      )
    :effect (stakeholder_approved ?exam_record)
  )
  (:action complete_record_after_stakeholder_approval
    :parameters (?exam_record - exam_record)
    :precondition
      (and
        (stakeholder_approved ?exam_record)
        (not
          (record_marked_complete ?exam_record)
        )
      )
    :effect
      (and
        (record_marked_complete ?exam_record)
        (record_ready_for_finalization ?exam_record)
      )
  )
  (:action mark_course_offering_ready_for_finalization
    :parameters (?course_offering - course_offering ?exam_instance - exam_instance)
    :precondition
      (and
        (course_offering_locked_for_allocation ?course_offering)
        (course_offering_allocation_confirmed ?course_offering)
        (exam_instance_prepared ?exam_instance)
        (instance_final_ready ?exam_instance)
        (not
          (record_ready_for_finalization ?course_offering)
        )
      )
    :effect (record_ready_for_finalization ?course_offering)
  )
  (:action mark_cohort_ready_for_finalization
    :parameters (?student_cohort - student_cohort ?exam_instance - exam_instance)
    :precondition
      (and
        (student_cohort_locked_for_allocation ?student_cohort)
        (student_cohort_allocation_confirmed ?student_cohort)
        (exam_instance_prepared ?exam_instance)
        (instance_final_ready ?exam_instance)
        (not
          (record_ready_for_finalization ?student_cohort)
        )
      )
    :effect (record_ready_for_finalization ?student_cohort)
  )
  (:action finalize_record_with_evidence
    :parameters (?exam_case - exam_case ?evidence_document - evidence_document ?course_exam_component - course_exam_component)
    :precondition
      (and
        (record_ready_for_finalization ?exam_case)
        (record_exam_component_linked ?exam_case ?course_exam_component)
        (evidence_document_available ?evidence_document)
        (not
          (record_finalized ?exam_case)
        )
      )
    :effect
      (and
        (record_finalized ?exam_case)
        (record_linked_to_evidence_document ?exam_case ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action finalize_and_publish_course_offering_schedule
    :parameters (?course_offering - course_offering ?coordinator - coordinator ?evidence_document - evidence_document)
    :precondition
      (and
        (record_finalized ?course_offering)
        (record_assigned_to_coordinator ?course_offering ?coordinator)
        (record_linked_to_evidence_document ?course_offering ?evidence_document)
        (not
          (record_resolved ?course_offering)
        )
      )
    :effect
      (and
        (record_resolved ?course_offering)
        (coordinator_available ?coordinator)
        (evidence_document_available ?evidence_document)
      )
  )
  (:action finalize_and_publish_cohort_schedule
    :parameters (?student_cohort - student_cohort ?coordinator - coordinator ?evidence_document - evidence_document)
    :precondition
      (and
        (record_finalized ?student_cohort)
        (record_assigned_to_coordinator ?student_cohort ?coordinator)
        (record_linked_to_evidence_document ?student_cohort ?evidence_document)
        (not
          (record_resolved ?student_cohort)
        )
      )
    :effect
      (and
        (record_resolved ?student_cohort)
        (coordinator_available ?coordinator)
        (evidence_document_available ?evidence_document)
      )
  )
  (:action finalize_and_publish_exam_record
    :parameters (?exam_record - exam_record ?coordinator - coordinator ?evidence_document - evidence_document)
    :precondition
      (and
        (record_finalized ?exam_record)
        (record_assigned_to_coordinator ?exam_record ?coordinator)
        (record_linked_to_evidence_document ?exam_record ?evidence_document)
        (not
          (record_resolved ?exam_record)
        )
      )
    :effect
      (and
        (record_resolved ?exam_record)
        (coordinator_available ?coordinator)
        (evidence_document_available ?evidence_document)
      )
  )
)

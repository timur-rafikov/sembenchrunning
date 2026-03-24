(define (domain accelerated_program_completion_plan_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types program_entity_group - object resource_group - object temporal_group - object plan_container - object accelerated_learning_plan - plan_container academic_advisor - program_entity_group course_section - program_entity_group instructor - program_entity_group waiver_document - program_entity_group elective_offer - program_entity_group conferral_token - program_entity_group lab_placement - program_entity_group external_certificate - program_entity_group seat_slot - resource_group assessment_component - resource_group department_approval - resource_group timeslot - temporal_group session - temporal_group accelerated_term_bundle - temporal_group candidate_group - accelerated_learning_plan program_group - accelerated_learning_plan primary_student - candidate_group peer_student - candidate_group program_advisor_unit - program_group)
  (:predicates
    (learning_plan_registered ?accelerated_learning_plan - accelerated_learning_plan)
    (approval_granted ?accelerated_learning_plan - accelerated_learning_plan)
    (advisor_assigned ?accelerated_learning_plan - accelerated_learning_plan)
    (completion_cleared ?accelerated_learning_plan - accelerated_learning_plan)
    (conferral_ready ?accelerated_learning_plan - accelerated_learning_plan)
    (conferral_allocated ?accelerated_learning_plan - accelerated_learning_plan)
    (advisor_available ?academic_advisor - academic_advisor)
    (assigned_advisor ?accelerated_learning_plan - accelerated_learning_plan ?academic_advisor - academic_advisor)
    (course_section_has_capacity ?course_section - course_section)
    (reserved_course_section ?accelerated_learning_plan - accelerated_learning_plan ?course_section - course_section)
    (instructor_available ?instructor - instructor)
    (assigned_instructor ?accelerated_learning_plan - accelerated_learning_plan ?instructor - instructor)
    (seat_slot_available ?seat_slot - seat_slot)
    (allocated_seat_slot ?primary_student - primary_student ?seat_slot - seat_slot)
    (peer_allocated_seat_slot ?peer_student - peer_student ?seat_slot - seat_slot)
    (student_assigned_timeslot ?primary_student - primary_student ?timeslot - timeslot)
    (timeslot_confirmed ?timeslot - timeslot)
    (timeslot_allocated ?timeslot - timeslot)
    (student_milestone_verified ?primary_student - primary_student)
    (peer_assigned_session ?peer_student - peer_student ?session - session)
    (session_confirmed ?session - session)
    (session_slot_allocated ?session - session)
    (peer_milestone_verified ?peer_student - peer_student)
    (bundle_available ?accelerated_term_bundle - accelerated_term_bundle)
    (bundle_assembled ?accelerated_term_bundle - accelerated_term_bundle)
    (bundle_includes_timeslot ?accelerated_term_bundle - accelerated_term_bundle ?timeslot - timeslot)
    (bundle_includes_session ?accelerated_term_bundle - accelerated_term_bundle ?session - session)
    (bundle_includes_primary_timeslot ?accelerated_term_bundle - accelerated_term_bundle)
    (bundle_includes_session_slot ?accelerated_term_bundle - accelerated_term_bundle)
    (bundle_activated ?accelerated_term_bundle - accelerated_term_bundle)
    (unit_assigned_primary_student ?program_advisor_unit - program_advisor_unit ?primary_student - primary_student)
    (unit_assigned_peer_student ?program_advisor_unit - program_advisor_unit ?peer_student - peer_student)
    (unit_manages_bundle ?program_advisor_unit - program_advisor_unit ?accelerated_term_bundle - accelerated_term_bundle)
    (assessment_available ?assessment_component - assessment_component)
    (unit_has_assessment ?program_advisor_unit - program_advisor_unit ?assessment_component - assessment_component)
    (assessment_completed ?assessment_component - assessment_component)
    (assessment_linked_to_bundle ?assessment_component - assessment_component ?accelerated_term_bundle - accelerated_term_bundle)
    (unit_assessments_verified ?program_advisor_unit - program_advisor_unit)
    (unit_placement_confirmed ?program_advisor_unit - program_advisor_unit)
    (eligibility_flagged ?program_advisor_unit - program_advisor_unit)
    (waiver_applied ?program_advisor_unit - program_advisor_unit)
    (waiver_acknowledged ?program_advisor_unit - program_advisor_unit)
    (preconferral_checks_passed ?program_advisor_unit - program_advisor_unit)
    (final_checks_completed ?program_advisor_unit - program_advisor_unit)
    (department_approval_available ?department_approval - department_approval)
    (unit_has_department_approval ?program_advisor_unit - program_advisor_unit ?department_approval - department_approval)
    (department_approval_applied ?program_advisor_unit - program_advisor_unit)
    (department_approval_processed ?program_advisor_unit - program_advisor_unit)
    (department_approval_finalized ?program_advisor_unit - program_advisor_unit)
    (waiver_available ?waiver_document - waiver_document)
    (unit_waiver_attached ?program_advisor_unit - program_advisor_unit ?waiver_document - waiver_document)
    (elective_available ?elective_offer - elective_offer)
    (unit_has_elective ?program_advisor_unit - program_advisor_unit ?elective_offer - elective_offer)
    (lab_placement_available ?lab_placement - lab_placement)
    (unit_has_lab_placement ?program_advisor_unit - program_advisor_unit ?lab_placement - lab_placement)
    (external_certificate_available ?external_certificate - external_certificate)
    (unit_has_external_certificate ?program_advisor_unit - program_advisor_unit ?external_certificate - external_certificate)
    (conferral_token_available ?conferral_token - conferral_token)
    (assigned_conferral_token ?accelerated_learning_plan - accelerated_learning_plan ?conferral_token - conferral_token)
    (student_ready_for_bundle ?primary_student - primary_student)
    (peer_ready_for_bundle ?peer_student - peer_student)
    (unit_conferral_cleared ?program_advisor_unit - program_advisor_unit)
  )
  (:action register_accelerated_learning_plan
    :parameters (?accelerated_learning_plan - accelerated_learning_plan)
    :precondition
      (and
        (not
          (learning_plan_registered ?accelerated_learning_plan)
        )
        (not
          (completion_cleared ?accelerated_learning_plan)
        )
      )
    :effect (learning_plan_registered ?accelerated_learning_plan)
  )
  (:action assign_academic_advisor_to_plan
    :parameters (?accelerated_learning_plan - accelerated_learning_plan ?academic_advisor - academic_advisor)
    :precondition
      (and
        (learning_plan_registered ?accelerated_learning_plan)
        (not
          (advisor_assigned ?accelerated_learning_plan)
        )
        (advisor_available ?academic_advisor)
      )
    :effect
      (and
        (advisor_assigned ?accelerated_learning_plan)
        (assigned_advisor ?accelerated_learning_plan ?academic_advisor)
        (not
          (advisor_available ?academic_advisor)
        )
      )
  )
  (:action request_section_reservation_for_plan
    :parameters (?accelerated_learning_plan - accelerated_learning_plan ?course_section - course_section)
    :precondition
      (and
        (learning_plan_registered ?accelerated_learning_plan)
        (advisor_assigned ?accelerated_learning_plan)
        (course_section_has_capacity ?course_section)
      )
    :effect
      (and
        (reserved_course_section ?accelerated_learning_plan ?course_section)
        (not
          (course_section_has_capacity ?course_section)
        )
      )
  )
  (:action confirm_section_enrollment_for_plan
    :parameters (?accelerated_learning_plan - accelerated_learning_plan ?course_section - course_section)
    :precondition
      (and
        (learning_plan_registered ?accelerated_learning_plan)
        (advisor_assigned ?accelerated_learning_plan)
        (reserved_course_section ?accelerated_learning_plan ?course_section)
        (not
          (approval_granted ?accelerated_learning_plan)
        )
      )
    :effect (approval_granted ?accelerated_learning_plan)
  )
  (:action release_tentative_section_reservation
    :parameters (?accelerated_learning_plan - accelerated_learning_plan ?course_section - course_section)
    :precondition
      (and
        (reserved_course_section ?accelerated_learning_plan ?course_section)
      )
    :effect
      (and
        (course_section_has_capacity ?course_section)
        (not
          (reserved_course_section ?accelerated_learning_plan ?course_section)
        )
      )
  )
  (:action assign_instructor_to_plan
    :parameters (?accelerated_learning_plan - accelerated_learning_plan ?instructor - instructor)
    :precondition
      (and
        (approval_granted ?accelerated_learning_plan)
        (instructor_available ?instructor)
      )
    :effect
      (and
        (assigned_instructor ?accelerated_learning_plan ?instructor)
        (not
          (instructor_available ?instructor)
        )
      )
  )
  (:action release_instructor_from_plan
    :parameters (?accelerated_learning_plan - accelerated_learning_plan ?instructor - instructor)
    :precondition
      (and
        (assigned_instructor ?accelerated_learning_plan ?instructor)
      )
    :effect
      (and
        (instructor_available ?instructor)
        (not
          (assigned_instructor ?accelerated_learning_plan ?instructor)
        )
      )
  )
  (:action assign_lab_placement_to_unit
    :parameters (?program_advisor_unit - program_advisor_unit ?lab_placement - lab_placement)
    :precondition
      (and
        (approval_granted ?program_advisor_unit)
        (lab_placement_available ?lab_placement)
      )
    :effect
      (and
        (unit_has_lab_placement ?program_advisor_unit ?lab_placement)
        (not
          (lab_placement_available ?lab_placement)
        )
      )
  )
  (:action release_lab_placement_from_unit
    :parameters (?program_advisor_unit - program_advisor_unit ?lab_placement - lab_placement)
    :precondition
      (and
        (unit_has_lab_placement ?program_advisor_unit ?lab_placement)
      )
    :effect
      (and
        (lab_placement_available ?lab_placement)
        (not
          (unit_has_lab_placement ?program_advisor_unit ?lab_placement)
        )
      )
  )
  (:action attach_external_certificate_to_unit
    :parameters (?program_advisor_unit - program_advisor_unit ?external_certificate - external_certificate)
    :precondition
      (and
        (approval_granted ?program_advisor_unit)
        (external_certificate_available ?external_certificate)
      )
    :effect
      (and
        (unit_has_external_certificate ?program_advisor_unit ?external_certificate)
        (not
          (external_certificate_available ?external_certificate)
        )
      )
  )
  (:action detach_external_certificate_from_unit
    :parameters (?program_advisor_unit - program_advisor_unit ?external_certificate - external_certificate)
    :precondition
      (and
        (unit_has_external_certificate ?program_advisor_unit ?external_certificate)
      )
    :effect
      (and
        (external_certificate_available ?external_certificate)
        (not
          (unit_has_external_certificate ?program_advisor_unit ?external_certificate)
        )
      )
  )
  (:action reserve_timeslot_for_student
    :parameters (?primary_student - primary_student ?timeslot - timeslot ?course_section - course_section)
    :precondition
      (and
        (approval_granted ?primary_student)
        (reserved_course_section ?primary_student ?course_section)
        (student_assigned_timeslot ?primary_student ?timeslot)
        (not
          (timeslot_confirmed ?timeslot)
        )
        (not
          (timeslot_allocated ?timeslot)
        )
      )
    :effect (timeslot_confirmed ?timeslot)
  )
  (:action confirm_primary_student_timeslot_with_instructor
    :parameters (?primary_student - primary_student ?timeslot - timeslot ?instructor - instructor)
    :precondition
      (and
        (approval_granted ?primary_student)
        (assigned_instructor ?primary_student ?instructor)
        (student_assigned_timeslot ?primary_student ?timeslot)
        (timeslot_confirmed ?timeslot)
        (not
          (student_ready_for_bundle ?primary_student)
        )
      )
    :effect
      (and
        (student_ready_for_bundle ?primary_student)
        (student_milestone_verified ?primary_student)
      )
  )
  (:action allocate_seat_slot_to_primary_student
    :parameters (?primary_student - primary_student ?timeslot - timeslot ?seat_slot - seat_slot)
    :precondition
      (and
        (approval_granted ?primary_student)
        (student_assigned_timeslot ?primary_student ?timeslot)
        (seat_slot_available ?seat_slot)
        (not
          (student_ready_for_bundle ?primary_student)
        )
      )
    :effect
      (and
        (timeslot_allocated ?timeslot)
        (student_ready_for_bundle ?primary_student)
        (allocated_seat_slot ?primary_student ?seat_slot)
        (not
          (seat_slot_available ?seat_slot)
        )
      )
  )
  (:action finalize_primary_student_slot_assignment
    :parameters (?primary_student - primary_student ?timeslot - timeslot ?course_section - course_section ?seat_slot - seat_slot)
    :precondition
      (and
        (approval_granted ?primary_student)
        (reserved_course_section ?primary_student ?course_section)
        (student_assigned_timeslot ?primary_student ?timeslot)
        (timeslot_allocated ?timeslot)
        (allocated_seat_slot ?primary_student ?seat_slot)
        (not
          (student_milestone_verified ?primary_student)
        )
      )
    :effect
      (and
        (timeslot_confirmed ?timeslot)
        (student_milestone_verified ?primary_student)
        (seat_slot_available ?seat_slot)
        (not
          (allocated_seat_slot ?primary_student ?seat_slot)
        )
      )
  )
  (:action reserve_timeslot_for_peer_student
    :parameters (?peer_student - peer_student ?session - session ?course_section - course_section)
    :precondition
      (and
        (approval_granted ?peer_student)
        (reserved_course_section ?peer_student ?course_section)
        (peer_assigned_session ?peer_student ?session)
        (not
          (session_confirmed ?session)
        )
        (not
          (session_slot_allocated ?session)
        )
      )
    :effect (session_confirmed ?session)
  )
  (:action confirm_peer_timeslot_with_instructor
    :parameters (?peer_student - peer_student ?session - session ?instructor - instructor)
    :precondition
      (and
        (approval_granted ?peer_student)
        (assigned_instructor ?peer_student ?instructor)
        (peer_assigned_session ?peer_student ?session)
        (session_confirmed ?session)
        (not
          (peer_ready_for_bundle ?peer_student)
        )
      )
    :effect
      (and
        (peer_ready_for_bundle ?peer_student)
        (peer_milestone_verified ?peer_student)
      )
  )
  (:action allocate_seat_slot_to_peer_student
    :parameters (?peer_student - peer_student ?session - session ?seat_slot - seat_slot)
    :precondition
      (and
        (approval_granted ?peer_student)
        (peer_assigned_session ?peer_student ?session)
        (seat_slot_available ?seat_slot)
        (not
          (peer_ready_for_bundle ?peer_student)
        )
      )
    :effect
      (and
        (session_slot_allocated ?session)
        (peer_ready_for_bundle ?peer_student)
        (peer_allocated_seat_slot ?peer_student ?seat_slot)
        (not
          (seat_slot_available ?seat_slot)
        )
      )
  )
  (:action finalize_peer_slot_assignment
    :parameters (?peer_student - peer_student ?session - session ?course_section - course_section ?seat_slot - seat_slot)
    :precondition
      (and
        (approval_granted ?peer_student)
        (reserved_course_section ?peer_student ?course_section)
        (peer_assigned_session ?peer_student ?session)
        (session_slot_allocated ?session)
        (peer_allocated_seat_slot ?peer_student ?seat_slot)
        (not
          (peer_milestone_verified ?peer_student)
        )
      )
    :effect
      (and
        (session_confirmed ?session)
        (peer_milestone_verified ?peer_student)
        (seat_slot_available ?seat_slot)
        (not
          (peer_allocated_seat_slot ?peer_student ?seat_slot)
        )
      )
  )
  (:action assemble_accelerated_term_bundle
    :parameters (?primary_student - primary_student ?peer_student - peer_student ?timeslot - timeslot ?session - session ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (student_ready_for_bundle ?primary_student)
        (peer_ready_for_bundle ?peer_student)
        (student_assigned_timeslot ?primary_student ?timeslot)
        (peer_assigned_session ?peer_student ?session)
        (timeslot_confirmed ?timeslot)
        (session_confirmed ?session)
        (student_milestone_verified ?primary_student)
        (peer_milestone_verified ?peer_student)
        (bundle_available ?accelerated_term_bundle)
      )
    :effect
      (and
        (bundle_assembled ?accelerated_term_bundle)
        (bundle_includes_timeslot ?accelerated_term_bundle ?timeslot)
        (bundle_includes_session ?accelerated_term_bundle ?session)
        (not
          (bundle_available ?accelerated_term_bundle)
        )
      )
  )
  (:action assemble_accelerated_term_bundle_with_primary_allocation
    :parameters (?primary_student - primary_student ?peer_student - peer_student ?timeslot - timeslot ?session - session ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (student_ready_for_bundle ?primary_student)
        (peer_ready_for_bundle ?peer_student)
        (student_assigned_timeslot ?primary_student ?timeslot)
        (peer_assigned_session ?peer_student ?session)
        (timeslot_allocated ?timeslot)
        (session_confirmed ?session)
        (not
          (student_milestone_verified ?primary_student)
        )
        (peer_milestone_verified ?peer_student)
        (bundle_available ?accelerated_term_bundle)
      )
    :effect
      (and
        (bundle_assembled ?accelerated_term_bundle)
        (bundle_includes_timeslot ?accelerated_term_bundle ?timeslot)
        (bundle_includes_session ?accelerated_term_bundle ?session)
        (bundle_includes_primary_timeslot ?accelerated_term_bundle)
        (not
          (bundle_available ?accelerated_term_bundle)
        )
      )
  )
  (:action assemble_accelerated_term_bundle_with_peer_allocation
    :parameters (?primary_student - primary_student ?peer_student - peer_student ?timeslot - timeslot ?session - session ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (student_ready_for_bundle ?primary_student)
        (peer_ready_for_bundle ?peer_student)
        (student_assigned_timeslot ?primary_student ?timeslot)
        (peer_assigned_session ?peer_student ?session)
        (timeslot_confirmed ?timeslot)
        (session_slot_allocated ?session)
        (student_milestone_verified ?primary_student)
        (not
          (peer_milestone_verified ?peer_student)
        )
        (bundle_available ?accelerated_term_bundle)
      )
    :effect
      (and
        (bundle_assembled ?accelerated_term_bundle)
        (bundle_includes_timeslot ?accelerated_term_bundle ?timeslot)
        (bundle_includes_session ?accelerated_term_bundle ?session)
        (bundle_includes_session_slot ?accelerated_term_bundle)
        (not
          (bundle_available ?accelerated_term_bundle)
        )
      )
  )
  (:action assemble_accelerated_term_bundle_with_full_allocations
    :parameters (?primary_student - primary_student ?peer_student - peer_student ?timeslot - timeslot ?session - session ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (student_ready_for_bundle ?primary_student)
        (peer_ready_for_bundle ?peer_student)
        (student_assigned_timeslot ?primary_student ?timeslot)
        (peer_assigned_session ?peer_student ?session)
        (timeslot_allocated ?timeslot)
        (session_slot_allocated ?session)
        (not
          (student_milestone_verified ?primary_student)
        )
        (not
          (peer_milestone_verified ?peer_student)
        )
        (bundle_available ?accelerated_term_bundle)
      )
    :effect
      (and
        (bundle_assembled ?accelerated_term_bundle)
        (bundle_includes_timeslot ?accelerated_term_bundle ?timeslot)
        (bundle_includes_session ?accelerated_term_bundle ?session)
        (bundle_includes_primary_timeslot ?accelerated_term_bundle)
        (bundle_includes_session_slot ?accelerated_term_bundle)
        (not
          (bundle_available ?accelerated_term_bundle)
        )
      )
  )
  (:action activate_accelerated_term_bundle_for_student
    :parameters (?accelerated_term_bundle - accelerated_term_bundle ?primary_student - primary_student ?course_section - course_section)
    :precondition
      (and
        (bundle_assembled ?accelerated_term_bundle)
        (student_ready_for_bundle ?primary_student)
        (reserved_course_section ?primary_student ?course_section)
        (not
          (bundle_activated ?accelerated_term_bundle)
        )
      )
    :effect (bundle_activated ?accelerated_term_bundle)
  )
  (:action assign_assessment_to_bundle
    :parameters (?program_advisor_unit - program_advisor_unit ?assessment_component - assessment_component ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (approval_granted ?program_advisor_unit)
        (unit_manages_bundle ?program_advisor_unit ?accelerated_term_bundle)
        (unit_has_assessment ?program_advisor_unit ?assessment_component)
        (assessment_available ?assessment_component)
        (bundle_assembled ?accelerated_term_bundle)
        (bundle_activated ?accelerated_term_bundle)
        (not
          (assessment_completed ?assessment_component)
        )
      )
    :effect
      (and
        (assessment_completed ?assessment_component)
        (assessment_linked_to_bundle ?assessment_component ?accelerated_term_bundle)
        (not
          (assessment_available ?assessment_component)
        )
      )
  )
  (:action verify_assessment_for_unit_and_bundle
    :parameters (?program_advisor_unit - program_advisor_unit ?assessment_component - assessment_component ?accelerated_term_bundle - accelerated_term_bundle ?course_section - course_section)
    :precondition
      (and
        (approval_granted ?program_advisor_unit)
        (unit_has_assessment ?program_advisor_unit ?assessment_component)
        (assessment_completed ?assessment_component)
        (assessment_linked_to_bundle ?assessment_component ?accelerated_term_bundle)
        (reserved_course_section ?program_advisor_unit ?course_section)
        (not
          (bundle_includes_primary_timeslot ?accelerated_term_bundle)
        )
        (not
          (unit_assessments_verified ?program_advisor_unit)
        )
      )
    :effect (unit_assessments_verified ?program_advisor_unit)
  )
  (:action attach_waiver_to_unit
    :parameters (?program_advisor_unit - program_advisor_unit ?waiver_document - waiver_document)
    :precondition
      (and
        (approval_granted ?program_advisor_unit)
        (waiver_available ?waiver_document)
        (not
          (waiver_applied ?program_advisor_unit)
        )
      )
    :effect
      (and
        (waiver_applied ?program_advisor_unit)
        (unit_waiver_attached ?program_advisor_unit ?waiver_document)
        (not
          (waiver_available ?waiver_document)
        )
      )
  )
  (:action process_waiver_and_update_unit
    :parameters (?program_advisor_unit - program_advisor_unit ?assessment_component - assessment_component ?accelerated_term_bundle - accelerated_term_bundle ?course_section - course_section ?waiver_document - waiver_document)
    :precondition
      (and
        (approval_granted ?program_advisor_unit)
        (unit_has_assessment ?program_advisor_unit ?assessment_component)
        (assessment_completed ?assessment_component)
        (assessment_linked_to_bundle ?assessment_component ?accelerated_term_bundle)
        (reserved_course_section ?program_advisor_unit ?course_section)
        (bundle_includes_primary_timeslot ?accelerated_term_bundle)
        (waiver_applied ?program_advisor_unit)
        (unit_waiver_attached ?program_advisor_unit ?waiver_document)
        (not
          (unit_assessments_verified ?program_advisor_unit)
        )
      )
    :effect
      (and
        (unit_assessments_verified ?program_advisor_unit)
        (waiver_acknowledged ?program_advisor_unit)
      )
  )
  (:action assign_lab_placement_and_flag_unit
    :parameters (?program_advisor_unit - program_advisor_unit ?lab_placement - lab_placement ?instructor - instructor ?assessment_component - assessment_component ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (unit_assessments_verified ?program_advisor_unit)
        (unit_has_lab_placement ?program_advisor_unit ?lab_placement)
        (assigned_instructor ?program_advisor_unit ?instructor)
        (unit_has_assessment ?program_advisor_unit ?assessment_component)
        (assessment_linked_to_bundle ?assessment_component ?accelerated_term_bundle)
        (not
          (bundle_includes_session_slot ?accelerated_term_bundle)
        )
        (not
          (unit_placement_confirmed ?program_advisor_unit)
        )
      )
    :effect (unit_placement_confirmed ?program_advisor_unit)
  )
  (:action confirm_lab_placement_for_unit
    :parameters (?program_advisor_unit - program_advisor_unit ?lab_placement - lab_placement ?instructor - instructor ?assessment_component - assessment_component ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (unit_assessments_verified ?program_advisor_unit)
        (unit_has_lab_placement ?program_advisor_unit ?lab_placement)
        (assigned_instructor ?program_advisor_unit ?instructor)
        (unit_has_assessment ?program_advisor_unit ?assessment_component)
        (assessment_linked_to_bundle ?assessment_component ?accelerated_term_bundle)
        (bundle_includes_session_slot ?accelerated_term_bundle)
        (not
          (unit_placement_confirmed ?program_advisor_unit)
        )
      )
    :effect (unit_placement_confirmed ?program_advisor_unit)
  )
  (:action apply_external_certificate_and_flag_eligibility
    :parameters (?program_advisor_unit - program_advisor_unit ?external_certificate - external_certificate ?assessment_component - assessment_component ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (unit_placement_confirmed ?program_advisor_unit)
        (unit_has_external_certificate ?program_advisor_unit ?external_certificate)
        (unit_has_assessment ?program_advisor_unit ?assessment_component)
        (assessment_linked_to_bundle ?assessment_component ?accelerated_term_bundle)
        (not
          (bundle_includes_primary_timeslot ?accelerated_term_bundle)
        )
        (not
          (bundle_includes_session_slot ?accelerated_term_bundle)
        )
        (not
          (eligibility_flagged ?program_advisor_unit)
        )
      )
    :effect (eligibility_flagged ?program_advisor_unit)
  )
  (:action apply_external_certificate_and_pass_preconferral_checks
    :parameters (?program_advisor_unit - program_advisor_unit ?external_certificate - external_certificate ?assessment_component - assessment_component ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (unit_placement_confirmed ?program_advisor_unit)
        (unit_has_external_certificate ?program_advisor_unit ?external_certificate)
        (unit_has_assessment ?program_advisor_unit ?assessment_component)
        (assessment_linked_to_bundle ?assessment_component ?accelerated_term_bundle)
        (bundle_includes_primary_timeslot ?accelerated_term_bundle)
        (not
          (bundle_includes_session_slot ?accelerated_term_bundle)
        )
        (not
          (eligibility_flagged ?program_advisor_unit)
        )
      )
    :effect
      (and
        (eligibility_flagged ?program_advisor_unit)
        (preconferral_checks_passed ?program_advisor_unit)
      )
  )
  (:action apply_external_certificate_and_complete_checks_variant
    :parameters (?program_advisor_unit - program_advisor_unit ?external_certificate - external_certificate ?assessment_component - assessment_component ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (unit_placement_confirmed ?program_advisor_unit)
        (unit_has_external_certificate ?program_advisor_unit ?external_certificate)
        (unit_has_assessment ?program_advisor_unit ?assessment_component)
        (assessment_linked_to_bundle ?assessment_component ?accelerated_term_bundle)
        (not
          (bundle_includes_primary_timeslot ?accelerated_term_bundle)
        )
        (bundle_includes_session_slot ?accelerated_term_bundle)
        (not
          (eligibility_flagged ?program_advisor_unit)
        )
      )
    :effect
      (and
        (eligibility_flagged ?program_advisor_unit)
        (preconferral_checks_passed ?program_advisor_unit)
      )
  )
  (:action apply_external_certificate_and_complete_checks_alternate
    :parameters (?program_advisor_unit - program_advisor_unit ?external_certificate - external_certificate ?assessment_component - assessment_component ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (unit_placement_confirmed ?program_advisor_unit)
        (unit_has_external_certificate ?program_advisor_unit ?external_certificate)
        (unit_has_assessment ?program_advisor_unit ?assessment_component)
        (assessment_linked_to_bundle ?assessment_component ?accelerated_term_bundle)
        (bundle_includes_primary_timeslot ?accelerated_term_bundle)
        (bundle_includes_session_slot ?accelerated_term_bundle)
        (not
          (eligibility_flagged ?program_advisor_unit)
        )
      )
    :effect
      (and
        (eligibility_flagged ?program_advisor_unit)
        (preconferral_checks_passed ?program_advisor_unit)
      )
  )
  (:action mark_unit_conferral_ready
    :parameters (?program_advisor_unit - program_advisor_unit)
    :precondition
      (and
        (eligibility_flagged ?program_advisor_unit)
        (not
          (preconferral_checks_passed ?program_advisor_unit)
        )
        (not
          (unit_conferral_cleared ?program_advisor_unit)
        )
      )
    :effect
      (and
        (unit_conferral_cleared ?program_advisor_unit)
        (conferral_ready ?program_advisor_unit)
      )
  )
  (:action assign_elective_to_unit
    :parameters (?program_advisor_unit - program_advisor_unit ?elective_offer - elective_offer)
    :precondition
      (and
        (eligibility_flagged ?program_advisor_unit)
        (preconferral_checks_passed ?program_advisor_unit)
        (elective_available ?elective_offer)
      )
    :effect
      (and
        (unit_has_elective ?program_advisor_unit ?elective_offer)
        (not
          (elective_available ?elective_offer)
        )
      )
  )
  (:action perform_unit_final_checks
    :parameters (?program_advisor_unit - program_advisor_unit ?primary_student - primary_student ?peer_student - peer_student ?course_section - course_section ?elective_offer - elective_offer)
    :precondition
      (and
        (eligibility_flagged ?program_advisor_unit)
        (preconferral_checks_passed ?program_advisor_unit)
        (unit_has_elective ?program_advisor_unit ?elective_offer)
        (unit_assigned_primary_student ?program_advisor_unit ?primary_student)
        (unit_assigned_peer_student ?program_advisor_unit ?peer_student)
        (student_milestone_verified ?primary_student)
        (peer_milestone_verified ?peer_student)
        (reserved_course_section ?program_advisor_unit ?course_section)
        (not
          (final_checks_completed ?program_advisor_unit)
        )
      )
    :effect (final_checks_completed ?program_advisor_unit)
  )
  (:action finalize_unit_and_mark_conferral_ready
    :parameters (?program_advisor_unit - program_advisor_unit)
    :precondition
      (and
        (eligibility_flagged ?program_advisor_unit)
        (final_checks_completed ?program_advisor_unit)
        (not
          (unit_conferral_cleared ?program_advisor_unit)
        )
      )
    :effect
      (and
        (unit_conferral_cleared ?program_advisor_unit)
        (conferral_ready ?program_advisor_unit)
      )
  )
  (:action apply_department_approval_to_unit
    :parameters (?program_advisor_unit - program_advisor_unit ?department_approval - department_approval ?course_section - course_section)
    :precondition
      (and
        (approval_granted ?program_advisor_unit)
        (reserved_course_section ?program_advisor_unit ?course_section)
        (department_approval_available ?department_approval)
        (unit_has_department_approval ?program_advisor_unit ?department_approval)
        (not
          (department_approval_applied ?program_advisor_unit)
        )
      )
    :effect
      (and
        (department_approval_applied ?program_advisor_unit)
        (not
          (department_approval_available ?department_approval)
        )
      )
  )
  (:action record_instructor_clearance_for_department_approval
    :parameters (?program_advisor_unit - program_advisor_unit ?instructor - instructor)
    :precondition
      (and
        (department_approval_applied ?program_advisor_unit)
        (assigned_instructor ?program_advisor_unit ?instructor)
        (not
          (department_approval_processed ?program_advisor_unit)
        )
      )
    :effect (department_approval_processed ?program_advisor_unit)
  )
  (:action finalize_department_approval
    :parameters (?program_advisor_unit - program_advisor_unit ?external_certificate - external_certificate)
    :precondition
      (and
        (department_approval_processed ?program_advisor_unit)
        (unit_has_external_certificate ?program_advisor_unit ?external_certificate)
        (not
          (department_approval_finalized ?program_advisor_unit)
        )
      )
    :effect (department_approval_finalized ?program_advisor_unit)
  )
  (:action finalize_unit_post_department_approval
    :parameters (?program_advisor_unit - program_advisor_unit)
    :precondition
      (and
        (department_approval_finalized ?program_advisor_unit)
        (not
          (unit_conferral_cleared ?program_advisor_unit)
        )
      )
    :effect
      (and
        (unit_conferral_cleared ?program_advisor_unit)
        (conferral_ready ?program_advisor_unit)
      )
  )
  (:action issue_completion_clearance_for_primary_student
    :parameters (?primary_student - primary_student ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (student_ready_for_bundle ?primary_student)
        (student_milestone_verified ?primary_student)
        (bundle_assembled ?accelerated_term_bundle)
        (bundle_activated ?accelerated_term_bundle)
        (not
          (conferral_ready ?primary_student)
        )
      )
    :effect (conferral_ready ?primary_student)
  )
  (:action issue_completion_clearance_for_peer_student
    :parameters (?peer_student - peer_student ?accelerated_term_bundle - accelerated_term_bundle)
    :precondition
      (and
        (peer_ready_for_bundle ?peer_student)
        (peer_milestone_verified ?peer_student)
        (bundle_assembled ?accelerated_term_bundle)
        (bundle_activated ?accelerated_term_bundle)
        (not
          (conferral_ready ?peer_student)
        )
      )
    :effect (conferral_ready ?peer_student)
  )
  (:action allocate_conferral_token_to_plan
    :parameters (?accelerated_learning_plan - accelerated_learning_plan ?conferral_token - conferral_token ?course_section - course_section)
    :precondition
      (and
        (conferral_ready ?accelerated_learning_plan)
        (reserved_course_section ?accelerated_learning_plan ?course_section)
        (conferral_token_available ?conferral_token)
        (not
          (conferral_allocated ?accelerated_learning_plan)
        )
      )
    :effect
      (and
        (conferral_allocated ?accelerated_learning_plan)
        (assigned_conferral_token ?accelerated_learning_plan ?conferral_token)
        (not
          (conferral_token_available ?conferral_token)
        )
      )
  )
  (:action finalize_primary_student_completion_and_release_advisor
    :parameters (?primary_student - primary_student ?academic_advisor - academic_advisor ?conferral_token - conferral_token)
    :precondition
      (and
        (conferral_allocated ?primary_student)
        (assigned_advisor ?primary_student ?academic_advisor)
        (assigned_conferral_token ?primary_student ?conferral_token)
        (not
          (completion_cleared ?primary_student)
        )
      )
    :effect
      (and
        (completion_cleared ?primary_student)
        (advisor_available ?academic_advisor)
        (conferral_token_available ?conferral_token)
      )
  )
  (:action finalize_peer_student_completion_and_release_advisor
    :parameters (?peer_student - peer_student ?academic_advisor - academic_advisor ?conferral_token - conferral_token)
    :precondition
      (and
        (conferral_allocated ?peer_student)
        (assigned_advisor ?peer_student ?academic_advisor)
        (assigned_conferral_token ?peer_student ?conferral_token)
        (not
          (completion_cleared ?peer_student)
        )
      )
    :effect
      (and
        (completion_cleared ?peer_student)
        (advisor_available ?academic_advisor)
        (conferral_token_available ?conferral_token)
      )
  )
  (:action finalize_unit_completion_and_release_advisor
    :parameters (?program_advisor_unit - program_advisor_unit ?academic_advisor - academic_advisor ?conferral_token - conferral_token)
    :precondition
      (and
        (conferral_allocated ?program_advisor_unit)
        (assigned_advisor ?program_advisor_unit ?academic_advisor)
        (assigned_conferral_token ?program_advisor_unit ?conferral_token)
        (not
          (completion_cleared ?program_advisor_unit)
        )
      )
    :effect
      (and
        (completion_cleared ?program_advisor_unit)
        (advisor_available ?academic_advisor)
        (conferral_token_available ?conferral_token)
      )
  )
)

(define (domain enrollment_timetable_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_token - object administrative_resource - object temporal_resource - object enrollment_case_root - object enrollment_case - enrollment_case_root section_seat_token - resource_token instructor_availability - resource_token approver - resource_token department_document - resource_token teaching_format - resource_token enrollment_deadline - resource_token instructor_assignment_token - resource_token external_constraint_token - resource_token administrative_resource_request - administrative_resource room - administrative_resource department_constraint - administrative_resource time_slot_primary - temporal_resource time_slot_secondary - temporal_resource timetable_proposal - temporal_resource student_case_group - enrollment_case section_case_group - enrollment_case student - student_case_group student_alternate - student_case_group course_section - section_case_group)
  (:predicates
    (intake_recorded ?enrollment_case - enrollment_case)
    (provisionally_approved ?enrollment_case - enrollment_case)
    (seat_assigned ?enrollment_case - enrollment_case)
    (confirmed ?enrollment_case - enrollment_case)
    (finalized ?enrollment_case - enrollment_case)
    (confirmation_recorded ?enrollment_case - enrollment_case)
    (seat_token_available ?section_seat_token - section_seat_token)
    (assigned_seat_token ?enrollment_case - enrollment_case ?section_seat_token - section_seat_token)
    (instructor_availability_available ?instructor_availability - instructor_availability)
    (assigned_instructor_availability ?enrollment_case - enrollment_case ?instructor_availability - instructor_availability)
    (approver_available ?approver - approver)
    (assigned_approver ?enrollment_case - enrollment_case ?approver - approver)
    (administrative_request_available ?administrative_resource_request - administrative_resource_request)
    (student_assigned_administrative_request ?student - student ?administrative_resource_request - administrative_resource_request)
    (student_alternate_assigned_administrative_request ?student_alternate - student_alternate ?administrative_resource_request - administrative_resource_request)
    (student_assigned_time_slot_primary ?student - student ?time_slot_primary - time_slot_primary)
    (time_slot_primary_reserved ?time_slot_primary - time_slot_primary)
    (time_slot_primary_conflict ?time_slot_primary - time_slot_primary)
    (student_primary_slot_confirmed ?student - student)
    (student_assigned_time_slot_secondary ?student_alternate - student_alternate ?time_slot_secondary - time_slot_secondary)
    (time_slot_secondary_reserved ?time_slot_secondary - time_slot_secondary)
    (time_slot_secondary_conflict ?time_slot_secondary - time_slot_secondary)
    (student_alternate_secondary_slot_confirmed ?student_alternate - student_alternate)
    (timetable_proposal_available ?timetable_proposal - timetable_proposal)
    (timetable_proposal_claimed ?timetable_proposal - timetable_proposal)
    (timetable_proposal_assigned_time_slot_primary ?timetable_proposal - timetable_proposal ?time_slot_primary - time_slot_primary)
    (timetable_proposal_assigned_time_slot_secondary ?timetable_proposal - timetable_proposal ?time_slot_secondary - time_slot_secondary)
    (timetable_proposal_requires_student_conflict_resolution ?timetable_proposal - timetable_proposal)
    (timetable_proposal_requires_section_conflict_resolution ?timetable_proposal - timetable_proposal)
    (timetable_proposal_locked ?timetable_proposal - timetable_proposal)
    (section_has_primary_student ?course_section - course_section ?student - student)
    (section_has_alternate_student ?course_section - course_section ?student_alternate - student_alternate)
    (section_associated_timetable_proposal ?course_section - course_section ?timetable_proposal - timetable_proposal)
    (room_available ?room - room)
    (section_associated_room ?course_section - course_section ?room - room)
    (room_reserved ?room - room)
    (room_assigned_to_timetable_proposal ?room - room ?timetable_proposal - timetable_proposal)
    (section_ready_for_assignment ?course_section - course_section)
    (section_instructor_assignment_confirmed ?course_section - course_section)
    (section_constraints_validated ?course_section - course_section)
    (section_has_department_document ?course_section - course_section)
    (section_department_document_applied ?course_section - course_section)
    (section_requires_additional_checks ?course_section - course_section)
    (section_ready_for_publication ?course_section - course_section)
    (department_constraint_available ?department_constraint - department_constraint)
    (section_has_department_constraint ?course_section - course_section ?department_constraint - department_constraint)
    (section_department_constraint_engaged ?course_section - course_section)
    (section_department_approver_verified ?course_section - course_section)
    (section_external_constraints_verified ?course_section - course_section)
    (department_document_available ?department_document - department_document)
    (section_assigned_department_document ?course_section - course_section ?department_document - department_document)
    (teaching_format_available ?teaching_format - teaching_format)
    (section_assigned_teaching_format ?course_section - course_section ?teaching_format - teaching_format)
    (instructor_assignment_token_available ?instructor_assignment_token - instructor_assignment_token)
    (section_instructor_assignment_offered ?course_section - course_section ?instructor_assignment_token - instructor_assignment_token)
    (external_constraint_token_available ?external_constraint_token - external_constraint_token)
    (section_assigned_external_constraint ?course_section - course_section ?external_constraint_token - external_constraint_token)
    (enrollment_deadline_available ?enrollment_deadline - enrollment_deadline)
    (associated_deadline ?enrollment_case - enrollment_case ?enrollment_deadline - enrollment_deadline)
    (student_primary_ready ?student - student)
    (student_alternate_ready ?student_alternate - student_alternate)
    (section_publication_locked ?course_section - course_section)
  )
  (:action record_enrollment_intake
    :parameters (?enrollment_case - enrollment_case)
    :precondition
      (and
        (not
          (intake_recorded ?enrollment_case)
        )
        (not
          (confirmed ?enrollment_case)
        )
      )
    :effect (intake_recorded ?enrollment_case)
  )
  (:action allocate_section_seat_token
    :parameters (?enrollment_case - enrollment_case ?section_seat_token - section_seat_token)
    :precondition
      (and
        (intake_recorded ?enrollment_case)
        (not
          (seat_assigned ?enrollment_case)
        )
        (seat_token_available ?section_seat_token)
      )
    :effect
      (and
        (seat_assigned ?enrollment_case)
        (assigned_seat_token ?enrollment_case ?section_seat_token)
        (not
          (seat_token_available ?section_seat_token)
        )
      )
  )
  (:action assign_instructor_availability
    :parameters (?enrollment_case - enrollment_case ?instructor_availability - instructor_availability)
    :precondition
      (and
        (intake_recorded ?enrollment_case)
        (seat_assigned ?enrollment_case)
        (instructor_availability_available ?instructor_availability)
      )
    :effect
      (and
        (assigned_instructor_availability ?enrollment_case ?instructor_availability)
        (not
          (instructor_availability_available ?instructor_availability)
        )
      )
  )
  (:action provisionally_approve_case
    :parameters (?enrollment_case - enrollment_case ?instructor_availability - instructor_availability)
    :precondition
      (and
        (intake_recorded ?enrollment_case)
        (seat_assigned ?enrollment_case)
        (assigned_instructor_availability ?enrollment_case ?instructor_availability)
        (not
          (provisionally_approved ?enrollment_case)
        )
      )
    :effect (provisionally_approved ?enrollment_case)
  )
  (:action revoke_instructor_availability
    :parameters (?enrollment_case - enrollment_case ?instructor_availability - instructor_availability)
    :precondition
      (and
        (assigned_instructor_availability ?enrollment_case ?instructor_availability)
      )
    :effect
      (and
        (instructor_availability_available ?instructor_availability)
        (not
          (assigned_instructor_availability ?enrollment_case ?instructor_availability)
        )
      )
  )
  (:action assign_approver
    :parameters (?enrollment_case - enrollment_case ?approver - approver)
    :precondition
      (and
        (provisionally_approved ?enrollment_case)
        (approver_available ?approver)
      )
    :effect
      (and
        (assigned_approver ?enrollment_case ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action release_approver
    :parameters (?enrollment_case - enrollment_case ?approver - approver)
    :precondition
      (and
        (assigned_approver ?enrollment_case ?approver)
      )
    :effect
      (and
        (approver_available ?approver)
        (not
          (assigned_approver ?enrollment_case ?approver)
        )
      )
  )
  (:action offer_instructor_assignment
    :parameters (?course_section - course_section ?instructor_assignment_token - instructor_assignment_token)
    :precondition
      (and
        (provisionally_approved ?course_section)
        (instructor_assignment_token_available ?instructor_assignment_token)
      )
    :effect
      (and
        (section_instructor_assignment_offered ?course_section ?instructor_assignment_token)
        (not
          (instructor_assignment_token_available ?instructor_assignment_token)
        )
      )
  )
  (:action withdraw_instructor_assignment_offer
    :parameters (?course_section - course_section ?instructor_assignment_token - instructor_assignment_token)
    :precondition
      (and
        (section_instructor_assignment_offered ?course_section ?instructor_assignment_token)
      )
    :effect
      (and
        (instructor_assignment_token_available ?instructor_assignment_token)
        (not
          (section_instructor_assignment_offered ?course_section ?instructor_assignment_token)
        )
      )
  )
  (:action offer_external_constraint
    :parameters (?course_section - course_section ?external_constraint_token - external_constraint_token)
    :precondition
      (and
        (provisionally_approved ?course_section)
        (external_constraint_token_available ?external_constraint_token)
      )
    :effect
      (and
        (section_assigned_external_constraint ?course_section ?external_constraint_token)
        (not
          (external_constraint_token_available ?external_constraint_token)
        )
      )
  )
  (:action withdraw_external_constraint_offer
    :parameters (?course_section - course_section ?external_constraint_token - external_constraint_token)
    :precondition
      (and
        (section_assigned_external_constraint ?course_section ?external_constraint_token)
      )
    :effect
      (and
        (external_constraint_token_available ?external_constraint_token)
        (not
          (section_assigned_external_constraint ?course_section ?external_constraint_token)
        )
      )
  )
  (:action reserve_primary_time_slot_for_student
    :parameters (?student - student ?time_slot_primary - time_slot_primary ?instructor_availability - instructor_availability)
    :precondition
      (and
        (provisionally_approved ?student)
        (assigned_instructor_availability ?student ?instructor_availability)
        (student_assigned_time_slot_primary ?student ?time_slot_primary)
        (not
          (time_slot_primary_reserved ?time_slot_primary)
        )
        (not
          (time_slot_primary_conflict ?time_slot_primary)
        )
      )
    :effect (time_slot_primary_reserved ?time_slot_primary)
  )
  (:action confirm_student_primary_time_slot
    :parameters (?student - student ?time_slot_primary - time_slot_primary ?approver - approver)
    :precondition
      (and
        (provisionally_approved ?student)
        (assigned_approver ?student ?approver)
        (student_assigned_time_slot_primary ?student ?time_slot_primary)
        (time_slot_primary_reserved ?time_slot_primary)
        (not
          (student_primary_ready ?student)
        )
      )
    :effect
      (and
        (student_primary_ready ?student)
        (student_primary_slot_confirmed ?student)
      )
  )
  (:action assign_admin_request_and_mark_primary_conflict
    :parameters (?student - student ?time_slot_primary - time_slot_primary ?administrative_resource_request - administrative_resource_request)
    :precondition
      (and
        (provisionally_approved ?student)
        (student_assigned_time_slot_primary ?student ?time_slot_primary)
        (administrative_request_available ?administrative_resource_request)
        (not
          (student_primary_ready ?student)
        )
      )
    :effect
      (and
        (time_slot_primary_conflict ?time_slot_primary)
        (student_primary_ready ?student)
        (student_assigned_administrative_request ?student ?administrative_resource_request)
        (not
          (administrative_request_available ?administrative_resource_request)
        )
      )
  )
  (:action resolve_student_primary_conflict
    :parameters (?student - student ?time_slot_primary - time_slot_primary ?instructor_availability - instructor_availability ?administrative_resource_request - administrative_resource_request)
    :precondition
      (and
        (provisionally_approved ?student)
        (assigned_instructor_availability ?student ?instructor_availability)
        (student_assigned_time_slot_primary ?student ?time_slot_primary)
        (time_slot_primary_conflict ?time_slot_primary)
        (student_assigned_administrative_request ?student ?administrative_resource_request)
        (not
          (student_primary_slot_confirmed ?student)
        )
      )
    :effect
      (and
        (time_slot_primary_reserved ?time_slot_primary)
        (student_primary_slot_confirmed ?student)
        (administrative_request_available ?administrative_resource_request)
        (not
          (student_assigned_administrative_request ?student ?administrative_resource_request)
        )
      )
  )
  (:action reserve_secondary_time_slot_for_section
    :parameters (?student_alternate - student_alternate ?time_slot_secondary - time_slot_secondary ?instructor_availability - instructor_availability)
    :precondition
      (and
        (provisionally_approved ?student_alternate)
        (assigned_instructor_availability ?student_alternate ?instructor_availability)
        (student_assigned_time_slot_secondary ?student_alternate ?time_slot_secondary)
        (not
          (time_slot_secondary_reserved ?time_slot_secondary)
        )
        (not
          (time_slot_secondary_conflict ?time_slot_secondary)
        )
      )
    :effect (time_slot_secondary_reserved ?time_slot_secondary)
  )
  (:action confirm_section_secondary_time_slot
    :parameters (?student_alternate - student_alternate ?time_slot_secondary - time_slot_secondary ?approver - approver)
    :precondition
      (and
        (provisionally_approved ?student_alternate)
        (assigned_approver ?student_alternate ?approver)
        (student_assigned_time_slot_secondary ?student_alternate ?time_slot_secondary)
        (time_slot_secondary_reserved ?time_slot_secondary)
        (not
          (student_alternate_ready ?student_alternate)
        )
      )
    :effect
      (and
        (student_alternate_ready ?student_alternate)
        (student_alternate_secondary_slot_confirmed ?student_alternate)
      )
  )
  (:action assign_admin_request_and_mark_secondary_conflict
    :parameters (?student_alternate - student_alternate ?time_slot_secondary - time_slot_secondary ?administrative_resource_request - administrative_resource_request)
    :precondition
      (and
        (provisionally_approved ?student_alternate)
        (student_assigned_time_slot_secondary ?student_alternate ?time_slot_secondary)
        (administrative_request_available ?administrative_resource_request)
        (not
          (student_alternate_ready ?student_alternate)
        )
      )
    :effect
      (and
        (time_slot_secondary_conflict ?time_slot_secondary)
        (student_alternate_ready ?student_alternate)
        (student_alternate_assigned_administrative_request ?student_alternate ?administrative_resource_request)
        (not
          (administrative_request_available ?administrative_resource_request)
        )
      )
  )
  (:action resolve_section_secondary_conflict
    :parameters (?student_alternate - student_alternate ?time_slot_secondary - time_slot_secondary ?instructor_availability - instructor_availability ?administrative_resource_request - administrative_resource_request)
    :precondition
      (and
        (provisionally_approved ?student_alternate)
        (assigned_instructor_availability ?student_alternate ?instructor_availability)
        (student_assigned_time_slot_secondary ?student_alternate ?time_slot_secondary)
        (time_slot_secondary_conflict ?time_slot_secondary)
        (student_alternate_assigned_administrative_request ?student_alternate ?administrative_resource_request)
        (not
          (student_alternate_secondary_slot_confirmed ?student_alternate)
        )
      )
    :effect
      (and
        (time_slot_secondary_reserved ?time_slot_secondary)
        (student_alternate_secondary_slot_confirmed ?student_alternate)
        (administrative_request_available ?administrative_resource_request)
        (not
          (student_alternate_assigned_administrative_request ?student_alternate ?administrative_resource_request)
        )
      )
  )
  (:action assemble_timetable_proposal_standard
    :parameters (?student - student ?student_alternate - student_alternate ?time_slot_primary - time_slot_primary ?time_slot_secondary - time_slot_secondary ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (student_primary_ready ?student)
        (student_alternate_ready ?student_alternate)
        (student_assigned_time_slot_primary ?student ?time_slot_primary)
        (student_assigned_time_slot_secondary ?student_alternate ?time_slot_secondary)
        (time_slot_primary_reserved ?time_slot_primary)
        (time_slot_secondary_reserved ?time_slot_secondary)
        (student_primary_slot_confirmed ?student)
        (student_alternate_secondary_slot_confirmed ?student_alternate)
        (timetable_proposal_available ?timetable_proposal)
      )
    :effect
      (and
        (timetable_proposal_claimed ?timetable_proposal)
        (timetable_proposal_assigned_time_slot_primary ?timetable_proposal ?time_slot_primary)
        (timetable_proposal_assigned_time_slot_secondary ?timetable_proposal ?time_slot_secondary)
        (not
          (timetable_proposal_available ?timetable_proposal)
        )
      )
  )
  (:action assemble_timetable_proposal_student_conflict
    :parameters (?student - student ?student_alternate - student_alternate ?time_slot_primary - time_slot_primary ?time_slot_secondary - time_slot_secondary ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (student_primary_ready ?student)
        (student_alternate_ready ?student_alternate)
        (student_assigned_time_slot_primary ?student ?time_slot_primary)
        (student_assigned_time_slot_secondary ?student_alternate ?time_slot_secondary)
        (time_slot_primary_conflict ?time_slot_primary)
        (time_slot_secondary_reserved ?time_slot_secondary)
        (not
          (student_primary_slot_confirmed ?student)
        )
        (student_alternate_secondary_slot_confirmed ?student_alternate)
        (timetable_proposal_available ?timetable_proposal)
      )
    :effect
      (and
        (timetable_proposal_claimed ?timetable_proposal)
        (timetable_proposal_assigned_time_slot_primary ?timetable_proposal ?time_slot_primary)
        (timetable_proposal_assigned_time_slot_secondary ?timetable_proposal ?time_slot_secondary)
        (timetable_proposal_requires_student_conflict_resolution ?timetable_proposal)
        (not
          (timetable_proposal_available ?timetable_proposal)
        )
      )
  )
  (:action assemble_timetable_proposal_section_conflict
    :parameters (?student - student ?student_alternate - student_alternate ?time_slot_primary - time_slot_primary ?time_slot_secondary - time_slot_secondary ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (student_primary_ready ?student)
        (student_alternate_ready ?student_alternate)
        (student_assigned_time_slot_primary ?student ?time_slot_primary)
        (student_assigned_time_slot_secondary ?student_alternate ?time_slot_secondary)
        (time_slot_primary_reserved ?time_slot_primary)
        (time_slot_secondary_conflict ?time_slot_secondary)
        (student_primary_slot_confirmed ?student)
        (not
          (student_alternate_secondary_slot_confirmed ?student_alternate)
        )
        (timetable_proposal_available ?timetable_proposal)
      )
    :effect
      (and
        (timetable_proposal_claimed ?timetable_proposal)
        (timetable_proposal_assigned_time_slot_primary ?timetable_proposal ?time_slot_primary)
        (timetable_proposal_assigned_time_slot_secondary ?timetable_proposal ?time_slot_secondary)
        (timetable_proposal_requires_section_conflict_resolution ?timetable_proposal)
        (not
          (timetable_proposal_available ?timetable_proposal)
        )
      )
  )
  (:action assemble_timetable_proposal_both_conflicts
    :parameters (?student - student ?student_alternate - student_alternate ?time_slot_primary - time_slot_primary ?time_slot_secondary - time_slot_secondary ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (student_primary_ready ?student)
        (student_alternate_ready ?student_alternate)
        (student_assigned_time_slot_primary ?student ?time_slot_primary)
        (student_assigned_time_slot_secondary ?student_alternate ?time_slot_secondary)
        (time_slot_primary_conflict ?time_slot_primary)
        (time_slot_secondary_conflict ?time_slot_secondary)
        (not
          (student_primary_slot_confirmed ?student)
        )
        (not
          (student_alternate_secondary_slot_confirmed ?student_alternate)
        )
        (timetable_proposal_available ?timetable_proposal)
      )
    :effect
      (and
        (timetable_proposal_claimed ?timetable_proposal)
        (timetable_proposal_assigned_time_slot_primary ?timetable_proposal ?time_slot_primary)
        (timetable_proposal_assigned_time_slot_secondary ?timetable_proposal ?time_slot_secondary)
        (timetable_proposal_requires_student_conflict_resolution ?timetable_proposal)
        (timetable_proposal_requires_section_conflict_resolution ?timetable_proposal)
        (not
          (timetable_proposal_available ?timetable_proposal)
        )
      )
  )
  (:action lock_timetable_proposal
    :parameters (?timetable_proposal - timetable_proposal ?student - student ?instructor_availability - instructor_availability)
    :precondition
      (and
        (timetable_proposal_claimed ?timetable_proposal)
        (student_primary_ready ?student)
        (assigned_instructor_availability ?student ?instructor_availability)
        (not
          (timetable_proposal_locked ?timetable_proposal)
        )
      )
    :effect (timetable_proposal_locked ?timetable_proposal)
  )
  (:action reserve_room_for_proposal
    :parameters (?course_section - course_section ?room - room ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (provisionally_approved ?course_section)
        (section_associated_timetable_proposal ?course_section ?timetable_proposal)
        (section_associated_room ?course_section ?room)
        (room_available ?room)
        (timetable_proposal_claimed ?timetable_proposal)
        (timetable_proposal_locked ?timetable_proposal)
        (not
          (room_reserved ?room)
        )
      )
    :effect
      (and
        (room_reserved ?room)
        (room_assigned_to_timetable_proposal ?room ?timetable_proposal)
        (not
          (room_available ?room)
        )
      )
  )
  (:action validate_room_assignment_for_section
    :parameters (?course_section - course_section ?room - room ?timetable_proposal - timetable_proposal ?instructor_availability - instructor_availability)
    :precondition
      (and
        (provisionally_approved ?course_section)
        (section_associated_room ?course_section ?room)
        (room_reserved ?room)
        (room_assigned_to_timetable_proposal ?room ?timetable_proposal)
        (assigned_instructor_availability ?course_section ?instructor_availability)
        (not
          (timetable_proposal_requires_student_conflict_resolution ?timetable_proposal)
        )
        (not
          (section_ready_for_assignment ?course_section)
        )
      )
    :effect (section_ready_for_assignment ?course_section)
  )
  (:action assign_department_document
    :parameters (?course_section - course_section ?department_document - department_document)
    :precondition
      (and
        (provisionally_approved ?course_section)
        (department_document_available ?department_document)
        (not
          (section_has_department_document ?course_section)
        )
      )
    :effect
      (and
        (section_has_department_document ?course_section)
        (section_assigned_department_document ?course_section ?department_document)
        (not
          (department_document_available ?department_document)
        )
      )
  )
  (:action apply_department_document_and_prepare_section
    :parameters (?course_section - course_section ?room - room ?timetable_proposal - timetable_proposal ?instructor_availability - instructor_availability ?department_document - department_document)
    :precondition
      (and
        (provisionally_approved ?course_section)
        (section_associated_room ?course_section ?room)
        (room_reserved ?room)
        (room_assigned_to_timetable_proposal ?room ?timetable_proposal)
        (assigned_instructor_availability ?course_section ?instructor_availability)
        (timetable_proposal_requires_student_conflict_resolution ?timetable_proposal)
        (section_has_department_document ?course_section)
        (section_assigned_department_document ?course_section ?department_document)
        (not
          (section_ready_for_assignment ?course_section)
        )
      )
    :effect
      (and
        (section_ready_for_assignment ?course_section)
        (section_department_document_applied ?course_section)
      )
  )
  (:action confirm_instructor_assignment_for_section
    :parameters (?course_section - course_section ?instructor_assignment_token - instructor_assignment_token ?approver - approver ?room - room ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (section_ready_for_assignment ?course_section)
        (section_instructor_assignment_offered ?course_section ?instructor_assignment_token)
        (assigned_approver ?course_section ?approver)
        (section_associated_room ?course_section ?room)
        (room_assigned_to_timetable_proposal ?room ?timetable_proposal)
        (not
          (timetable_proposal_requires_section_conflict_resolution ?timetable_proposal)
        )
        (not
          (section_instructor_assignment_confirmed ?course_section)
        )
      )
    :effect (section_instructor_assignment_confirmed ?course_section)
  )
  (:action confirm_instructor_assignment_for_section_alternate
    :parameters (?course_section - course_section ?instructor_assignment_token - instructor_assignment_token ?approver - approver ?room - room ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (section_ready_for_assignment ?course_section)
        (section_instructor_assignment_offered ?course_section ?instructor_assignment_token)
        (assigned_approver ?course_section ?approver)
        (section_associated_room ?course_section ?room)
        (room_assigned_to_timetable_proposal ?room ?timetable_proposal)
        (timetable_proposal_requires_section_conflict_resolution ?timetable_proposal)
        (not
          (section_instructor_assignment_confirmed ?course_section)
        )
      )
    :effect (section_instructor_assignment_confirmed ?course_section)
  )
  (:action apply_external_constraint_to_section
    :parameters (?course_section - course_section ?external_constraint_token - external_constraint_token ?room - room ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (section_instructor_assignment_confirmed ?course_section)
        (section_assigned_external_constraint ?course_section ?external_constraint_token)
        (section_associated_room ?course_section ?room)
        (room_assigned_to_timetable_proposal ?room ?timetable_proposal)
        (not
          (timetable_proposal_requires_student_conflict_resolution ?timetable_proposal)
        )
        (not
          (timetable_proposal_requires_section_conflict_resolution ?timetable_proposal)
        )
        (not
          (section_constraints_validated ?course_section)
        )
      )
    :effect (section_constraints_validated ?course_section)
  )
  (:action apply_external_constraint_and_mark_additional_checks
    :parameters (?course_section - course_section ?external_constraint_token - external_constraint_token ?room - room ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (section_instructor_assignment_confirmed ?course_section)
        (section_assigned_external_constraint ?course_section ?external_constraint_token)
        (section_associated_room ?course_section ?room)
        (room_assigned_to_timetable_proposal ?room ?timetable_proposal)
        (timetable_proposal_requires_student_conflict_resolution ?timetable_proposal)
        (not
          (timetable_proposal_requires_section_conflict_resolution ?timetable_proposal)
        )
        (not
          (section_constraints_validated ?course_section)
        )
      )
    :effect
      (and
        (section_constraints_validated ?course_section)
        (section_requires_additional_checks ?course_section)
      )
  )
  (:action apply_external_constraint_and_mark_additional_checks_variant
    :parameters (?course_section - course_section ?external_constraint_token - external_constraint_token ?room - room ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (section_instructor_assignment_confirmed ?course_section)
        (section_assigned_external_constraint ?course_section ?external_constraint_token)
        (section_associated_room ?course_section ?room)
        (room_assigned_to_timetable_proposal ?room ?timetable_proposal)
        (not
          (timetable_proposal_requires_student_conflict_resolution ?timetable_proposal)
        )
        (timetable_proposal_requires_section_conflict_resolution ?timetable_proposal)
        (not
          (section_constraints_validated ?course_section)
        )
      )
    :effect
      (and
        (section_constraints_validated ?course_section)
        (section_requires_additional_checks ?course_section)
      )
  )
  (:action apply_external_constraint_and_mark_additional_checks_alternate
    :parameters (?course_section - course_section ?external_constraint_token - external_constraint_token ?room - room ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (section_instructor_assignment_confirmed ?course_section)
        (section_assigned_external_constraint ?course_section ?external_constraint_token)
        (section_associated_room ?course_section ?room)
        (room_assigned_to_timetable_proposal ?room ?timetable_proposal)
        (timetable_proposal_requires_student_conflict_resolution ?timetable_proposal)
        (timetable_proposal_requires_section_conflict_resolution ?timetable_proposal)
        (not
          (section_constraints_validated ?course_section)
        )
      )
    :effect
      (and
        (section_constraints_validated ?course_section)
        (section_requires_additional_checks ?course_section)
      )
  )
  (:action finalize_section_without_additional_checks
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_constraints_validated ?course_section)
        (not
          (section_requires_additional_checks ?course_section)
        )
        (not
          (section_publication_locked ?course_section)
        )
      )
    :effect
      (and
        (section_publication_locked ?course_section)
        (finalized ?course_section)
      )
  )
  (:action assign_teaching_format_to_section
    :parameters (?course_section - course_section ?teaching_format - teaching_format)
    :precondition
      (and
        (section_constraints_validated ?course_section)
        (section_requires_additional_checks ?course_section)
        (teaching_format_available ?teaching_format)
      )
    :effect
      (and
        (section_assigned_teaching_format ?course_section ?teaching_format)
        (not
          (teaching_format_available ?teaching_format)
        )
      )
  )
  (:action mark_section_ready_for_publication
    :parameters (?course_section - course_section ?student - student ?student_alternate - student_alternate ?instructor_availability - instructor_availability ?teaching_format - teaching_format)
    :precondition
      (and
        (section_constraints_validated ?course_section)
        (section_requires_additional_checks ?course_section)
        (section_assigned_teaching_format ?course_section ?teaching_format)
        (section_has_primary_student ?course_section ?student)
        (section_has_alternate_student ?course_section ?student_alternate)
        (student_primary_slot_confirmed ?student)
        (student_alternate_secondary_slot_confirmed ?student_alternate)
        (assigned_instructor_availability ?course_section ?instructor_availability)
        (not
          (section_ready_for_publication ?course_section)
        )
      )
    :effect (section_ready_for_publication ?course_section)
  )
  (:action publish_section
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_constraints_validated ?course_section)
        (section_ready_for_publication ?course_section)
        (not
          (section_publication_locked ?course_section)
        )
      )
    :effect
      (and
        (section_publication_locked ?course_section)
        (finalized ?course_section)
      )
  )
  (:action engage_department_constraint_for_section
    :parameters (?course_section - course_section ?department_constraint - department_constraint ?instructor_availability - instructor_availability)
    :precondition
      (and
        (provisionally_approved ?course_section)
        (assigned_instructor_availability ?course_section ?instructor_availability)
        (department_constraint_available ?department_constraint)
        (section_has_department_constraint ?course_section ?department_constraint)
        (not
          (section_department_constraint_engaged ?course_section)
        )
      )
    :effect
      (and
        (section_department_constraint_engaged ?course_section)
        (not
          (department_constraint_available ?department_constraint)
        )
      )
  )
  (:action verify_department_approver_for_section
    :parameters (?course_section - course_section ?approver - approver)
    :precondition
      (and
        (section_department_constraint_engaged ?course_section)
        (assigned_approver ?course_section ?approver)
        (not
          (section_department_approver_verified ?course_section)
        )
      )
    :effect (section_department_approver_verified ?course_section)
  )
  (:action verify_external_constraint_for_section
    :parameters (?course_section - course_section ?external_constraint_token - external_constraint_token)
    :precondition
      (and
        (section_department_approver_verified ?course_section)
        (section_assigned_external_constraint ?course_section ?external_constraint_token)
        (not
          (section_external_constraints_verified ?course_section)
        )
      )
    :effect (section_external_constraints_verified ?course_section)
  )
  (:action finalize_and_publish_section_after_external_checks
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_external_constraints_verified ?course_section)
        (not
          (section_publication_locked ?course_section)
        )
      )
    :effect
      (and
        (section_publication_locked ?course_section)
        (finalized ?course_section)
      )
  )
  (:action finalize_student_enrollment
    :parameters (?student - student ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (student_primary_ready ?student)
        (student_primary_slot_confirmed ?student)
        (timetable_proposal_claimed ?timetable_proposal)
        (timetable_proposal_locked ?timetable_proposal)
        (not
          (finalized ?student)
        )
      )
    :effect (finalized ?student)
  )
  (:action finalize_student_alternate_enrollment
    :parameters (?student_alternate - student_alternate ?timetable_proposal - timetable_proposal)
    :precondition
      (and
        (student_alternate_ready ?student_alternate)
        (student_alternate_secondary_slot_confirmed ?student_alternate)
        (timetable_proposal_claimed ?timetable_proposal)
        (timetable_proposal_locked ?timetable_proposal)
        (not
          (finalized ?student_alternate)
        )
      )
    :effect (finalized ?student_alternate)
  )
  (:action record_student_confirmation_and_associate_deadline
    :parameters (?enrollment_case - enrollment_case ?enrollment_deadline - enrollment_deadline ?instructor_availability - instructor_availability)
    :precondition
      (and
        (finalized ?enrollment_case)
        (assigned_instructor_availability ?enrollment_case ?instructor_availability)
        (enrollment_deadline_available ?enrollment_deadline)
        (not
          (confirmation_recorded ?enrollment_case)
        )
      )
    :effect
      (and
        (confirmation_recorded ?enrollment_case)
        (associated_deadline ?enrollment_case ?enrollment_deadline)
        (not
          (enrollment_deadline_available ?enrollment_deadline)
        )
      )
  )
  (:action confirm_enrollment_and_reconcile_seat_for_student
    :parameters (?student - student ?section_seat_token - section_seat_token ?enrollment_deadline - enrollment_deadline)
    :precondition
      (and
        (confirmation_recorded ?student)
        (assigned_seat_token ?student ?section_seat_token)
        (associated_deadline ?student ?enrollment_deadline)
        (not
          (confirmed ?student)
        )
      )
    :effect
      (and
        (confirmed ?student)
        (seat_token_available ?section_seat_token)
        (enrollment_deadline_available ?enrollment_deadline)
      )
  )
  (:action confirm_enrollment_and_reconcile_seat_for_student_alternate
    :parameters (?student_alternate - student_alternate ?section_seat_token - section_seat_token ?enrollment_deadline - enrollment_deadline)
    :precondition
      (and
        (confirmation_recorded ?student_alternate)
        (assigned_seat_token ?student_alternate ?section_seat_token)
        (associated_deadline ?student_alternate ?enrollment_deadline)
        (not
          (confirmed ?student_alternate)
        )
      )
    :effect
      (and
        (confirmed ?student_alternate)
        (seat_token_available ?section_seat_token)
        (enrollment_deadline_available ?enrollment_deadline)
      )
  )
  (:action confirm_enrollment_and_reconcile_seat_for_section
    :parameters (?course_section - course_section ?section_seat_token - section_seat_token ?enrollment_deadline - enrollment_deadline)
    :precondition
      (and
        (confirmation_recorded ?course_section)
        (assigned_seat_token ?course_section ?section_seat_token)
        (associated_deadline ?course_section ?enrollment_deadline)
        (not
          (confirmed ?course_section)
        )
      )
    :effect
      (and
        (confirmed ?course_section)
        (seat_token_available ?section_seat_token)
        (enrollment_deadline_available ?enrollment_deadline)
      )
  )
)

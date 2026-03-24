(define (domain course_swap_without_progress_loss)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_supertype - object schedule_resource_supertype - object role_entity_supertype - object domain_entity_supertype - object request_subject - domain_entity_supertype section_seat - resource_supertype timetable_slot - resource_supertype administrator - resource_supertype department_constraint - resource_supertype policy_consent - resource_supertype deadline_token - resource_supertype instructor_approval_token - resource_supertype venue_approval_token - resource_supertype supporting_document - schedule_resource_supertype registrar_record_fragment - schedule_resource_supertype department_approval_token - schedule_resource_supertype venue - role_entity_supertype instructor_schedule - role_entity_supertype swap_case - role_entity_supertype enrollment_group - request_subject section_group - request_subject student_enrollment - enrollment_group requested_enrollment - enrollment_group course_section - section_group)
  (:predicates
    (swap_request_received ?actor - request_subject)
    (request_ready_for_review ?actor - request_subject)
    (seat_reservation_active ?actor - request_subject)
    (enrollment_committed ?actor - request_subject)
    (ready_for_section_commit ?actor - request_subject)
    (ready_for_enrollment_commit ?actor - request_subject)
    (seat_available ?section_seat - section_seat)
    (has_reserved_seat ?actor - request_subject ?section_seat - section_seat)
    (slot_available ?timetable_slot - timetable_slot)
    (has_linked_timetable_slot ?actor - request_subject ?timetable_slot - timetable_slot)
    (administrator_available ?administrator - administrator)
    (assigned_administrator_to_request ?actor - request_subject ?administrator - administrator)
    (supporting_document_available ?supporting_document - supporting_document)
    (enrollment_attached_document ?student_enrollment - student_enrollment ?supporting_document - supporting_document)
    (requested_enrollment_attached_document ?requested_enrollment - requested_enrollment ?supporting_document - supporting_document)
    (enrollment_assigned_venue ?student_enrollment - student_enrollment ?venue - venue)
    (venue_prelim_reserved ?venue - venue)
    (venue_confirmed_reserved ?venue - venue)
    (venue_confirmed_for_enrollment ?student_enrollment - student_enrollment)
    (requested_enrollment_assigned_instructor_schedule ?requested_enrollment - requested_enrollment ?instructor_schedule - instructor_schedule)
    (instructor_prelim_reserved ?instructor_schedule - instructor_schedule)
    (instructor_confirmed_reserved ?instructor_schedule - instructor_schedule)
    (instructor_confirmed_for_requested_enrollment ?requested_enrollment - requested_enrollment)
    (case_unallocated ?swap_case - swap_case)
    (case_created ?swap_case - swap_case)
    (case_allocated_venue ?swap_case - swap_case ?venue - venue)
    (case_allocated_instructor ?swap_case - swap_case ?instructor_schedule - instructor_schedule)
    (case_requires_department_constraint ?swap_case - swap_case)
    (case_requires_instructor_approval ?swap_case - swap_case)
    (case_slot_locked ?swap_case - swap_case)
    (section_has_student_enrollment ?course_section - course_section ?student_enrollment - student_enrollment)
    (section_has_requested_enrollment ?course_section - course_section ?requested_enrollment - requested_enrollment)
    (section_associated_with_case ?course_section - course_section ?swap_case - swap_case)
    (registrar_fragment_available ?registrar_record_fragment - registrar_record_fragment)
    (section_has_registrar_fragment ?course_section - course_section ?registrar_record_fragment - registrar_record_fragment)
    (registrar_fragment_consumed ?registrar_record_fragment - registrar_record_fragment)
    (registrar_fragment_linked_to_case ?registrar_record_fragment - registrar_record_fragment ?swap_case - swap_case)
    (section_validated ?course_section - course_section)
    (instructor_allocated_to_section ?course_section - course_section)
    (section_checks_complete ?course_section - course_section)
    (section_constraint_attached ?course_section - course_section)
    (section_constraint_processed ?course_section - course_section)
    (section_ready_for_final_validation ?course_section - course_section)
    (section_prepared_for_lock ?course_section - course_section)
    (department_approval_token_available ?department_approval_token - department_approval_token)
    (section_has_department_approval_token ?course_section - course_section ?department_approval_token - department_approval_token)
    (special_approval_recorded ?course_section - course_section)
    (special_approval_verified ?course_section - course_section)
    (special_approval_finalized ?course_section - course_section)
    (department_constraint_available ?department_constraint - department_constraint)
    (section_has_department_constraint ?course_section - course_section ?department_constraint - department_constraint)
    (policy_consent_available ?policy_consent - policy_consent)
    (section_has_policy_consent ?course_section - course_section ?policy_consent - policy_consent)
    (instructor_approval_token_available ?instructor_approval_token - instructor_approval_token)
    (section_has_instructor_approval_token ?course_section - course_section ?instructor_approval_token - instructor_approval_token)
    (venue_approval_token_available ?venue_approval_token - venue_approval_token)
    (section_has_venue_approval_token ?course_section - course_section ?venue_approval_token - venue_approval_token)
    (deadline_token_available ?deadline_token - deadline_token)
    (has_deadline_token_for ?actor - request_subject ?deadline_token - deadline_token)
    (student_enrollment_feasible ?student_enrollment - student_enrollment)
    (requested_enrollment_feasible ?requested_enrollment - requested_enrollment)
    (section_locked ?course_section - course_section)
  )
  (:action submit_swap_request
    :parameters (?actor - request_subject)
    :precondition
      (and
        (not
          (swap_request_received ?actor)
        )
        (not
          (enrollment_committed ?actor)
        )
      )
    :effect (swap_request_received ?actor)
  )
  (:action reserve_section_seat
    :parameters (?actor - request_subject ?section_seat - section_seat)
    :precondition
      (and
        (swap_request_received ?actor)
        (not
          (seat_reservation_active ?actor)
        )
        (seat_available ?section_seat)
      )
    :effect
      (and
        (seat_reservation_active ?actor)
        (has_reserved_seat ?actor ?section_seat)
        (not
          (seat_available ?section_seat)
        )
      )
  )
  (:action allocate_timetable_slot
    :parameters (?actor - request_subject ?timetable_slot - timetable_slot)
    :precondition
      (and
        (swap_request_received ?actor)
        (seat_reservation_active ?actor)
        (slot_available ?timetable_slot)
      )
    :effect
      (and
        (has_linked_timetable_slot ?actor ?timetable_slot)
        (not
          (slot_available ?timetable_slot)
        )
      )
  )
  (:action validate_request_for_review
    :parameters (?actor - request_subject ?timetable_slot - timetable_slot)
    :precondition
      (and
        (swap_request_received ?actor)
        (seat_reservation_active ?actor)
        (has_linked_timetable_slot ?actor ?timetable_slot)
        (not
          (request_ready_for_review ?actor)
        )
      )
    :effect (request_ready_for_review ?actor)
  )
  (:action release_timetable_slot
    :parameters (?actor - request_subject ?timetable_slot - timetable_slot)
    :precondition
      (and
        (has_linked_timetable_slot ?actor ?timetable_slot)
      )
    :effect
      (and
        (slot_available ?timetable_slot)
        (not
          (has_linked_timetable_slot ?actor ?timetable_slot)
        )
      )
  )
  (:action assign_administrator
    :parameters (?actor - request_subject ?administrator - administrator)
    :precondition
      (and
        (request_ready_for_review ?actor)
        (administrator_available ?administrator)
      )
    :effect
      (and
        (assigned_administrator_to_request ?actor ?administrator)
        (not
          (administrator_available ?administrator)
        )
      )
  )
  (:action release_administrator
    :parameters (?actor - request_subject ?administrator - administrator)
    :precondition
      (and
        (assigned_administrator_to_request ?actor ?administrator)
      )
    :effect
      (and
        (administrator_available ?administrator)
        (not
          (assigned_administrator_to_request ?actor ?administrator)
        )
      )
  )
  (:action allocate_instructor_approval_token
    :parameters (?course_section - course_section ?instructor_approval_token - instructor_approval_token)
    :precondition
      (and
        (request_ready_for_review ?course_section)
        (instructor_approval_token_available ?instructor_approval_token)
      )
    :effect
      (and
        (section_has_instructor_approval_token ?course_section ?instructor_approval_token)
        (not
          (instructor_approval_token_available ?instructor_approval_token)
        )
      )
  )
  (:action release_instructor_approval_token
    :parameters (?course_section - course_section ?instructor_approval_token - instructor_approval_token)
    :precondition
      (and
        (section_has_instructor_approval_token ?course_section ?instructor_approval_token)
      )
    :effect
      (and
        (instructor_approval_token_available ?instructor_approval_token)
        (not
          (section_has_instructor_approval_token ?course_section ?instructor_approval_token)
        )
      )
  )
  (:action allocate_venue_approval_token
    :parameters (?course_section - course_section ?venue_approval_token - venue_approval_token)
    :precondition
      (and
        (request_ready_for_review ?course_section)
        (venue_approval_token_available ?venue_approval_token)
      )
    :effect
      (and
        (section_has_venue_approval_token ?course_section ?venue_approval_token)
        (not
          (venue_approval_token_available ?venue_approval_token)
        )
      )
  )
  (:action release_venue_approval_token
    :parameters (?course_section - course_section ?venue_approval_token - venue_approval_token)
    :precondition
      (and
        (section_has_venue_approval_token ?course_section ?venue_approval_token)
      )
    :effect
      (and
        (venue_approval_token_available ?venue_approval_token)
        (not
          (section_has_venue_approval_token ?course_section ?venue_approval_token)
        )
      )
  )
  (:action reserve_venue_candidate
    :parameters (?student_enrollment - student_enrollment ?venue - venue ?timetable_slot - timetable_slot)
    :precondition
      (and
        (request_ready_for_review ?student_enrollment)
        (has_linked_timetable_slot ?student_enrollment ?timetable_slot)
        (enrollment_assigned_venue ?student_enrollment ?venue)
        (not
          (venue_prelim_reserved ?venue)
        )
        (not
          (venue_confirmed_reserved ?venue)
        )
      )
    :effect (venue_prelim_reserved ?venue)
  )
  (:action confirm_venue_with_administrator
    :parameters (?student_enrollment - student_enrollment ?venue - venue ?administrator - administrator)
    :precondition
      (and
        (request_ready_for_review ?student_enrollment)
        (assigned_administrator_to_request ?student_enrollment ?administrator)
        (enrollment_assigned_venue ?student_enrollment ?venue)
        (venue_prelim_reserved ?venue)
        (not
          (student_enrollment_feasible ?student_enrollment)
        )
      )
    :effect
      (and
        (student_enrollment_feasible ?student_enrollment)
        (venue_confirmed_for_enrollment ?student_enrollment)
      )
  )
  (:action claim_venue_with_document
    :parameters (?student_enrollment - student_enrollment ?venue - venue ?supporting_document - supporting_document)
    :precondition
      (and
        (request_ready_for_review ?student_enrollment)
        (enrollment_assigned_venue ?student_enrollment ?venue)
        (supporting_document_available ?supporting_document)
        (not
          (student_enrollment_feasible ?student_enrollment)
        )
      )
    :effect
      (and
        (venue_confirmed_reserved ?venue)
        (student_enrollment_feasible ?student_enrollment)
        (enrollment_attached_document ?student_enrollment ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action transfer_venue_claim_with_document
    :parameters (?student_enrollment - student_enrollment ?venue - venue ?timetable_slot - timetable_slot ?supporting_document - supporting_document)
    :precondition
      (and
        (request_ready_for_review ?student_enrollment)
        (has_linked_timetable_slot ?student_enrollment ?timetable_slot)
        (enrollment_assigned_venue ?student_enrollment ?venue)
        (venue_confirmed_reserved ?venue)
        (enrollment_attached_document ?student_enrollment ?supporting_document)
        (not
          (venue_confirmed_for_enrollment ?student_enrollment)
        )
      )
    :effect
      (and
        (venue_prelim_reserved ?venue)
        (venue_confirmed_for_enrollment ?student_enrollment)
        (supporting_document_available ?supporting_document)
        (not
          (enrollment_attached_document ?student_enrollment ?supporting_document)
        )
      )
  )
  (:action reserve_instructor_candidate
    :parameters (?requested_enrollment - requested_enrollment ?instructor_schedule - instructor_schedule ?timetable_slot - timetable_slot)
    :precondition
      (and
        (request_ready_for_review ?requested_enrollment)
        (has_linked_timetable_slot ?requested_enrollment ?timetable_slot)
        (requested_enrollment_assigned_instructor_schedule ?requested_enrollment ?instructor_schedule)
        (not
          (instructor_prelim_reserved ?instructor_schedule)
        )
        (not
          (instructor_confirmed_reserved ?instructor_schedule)
        )
      )
    :effect (instructor_prelim_reserved ?instructor_schedule)
  )
  (:action confirm_instructor_with_administrator
    :parameters (?requested_enrollment - requested_enrollment ?instructor_schedule - instructor_schedule ?administrator - administrator)
    :precondition
      (and
        (request_ready_for_review ?requested_enrollment)
        (assigned_administrator_to_request ?requested_enrollment ?administrator)
        (requested_enrollment_assigned_instructor_schedule ?requested_enrollment ?instructor_schedule)
        (instructor_prelim_reserved ?instructor_schedule)
        (not
          (requested_enrollment_feasible ?requested_enrollment)
        )
      )
    :effect
      (and
        (requested_enrollment_feasible ?requested_enrollment)
        (instructor_confirmed_for_requested_enrollment ?requested_enrollment)
      )
  )
  (:action claim_instructor_with_document
    :parameters (?requested_enrollment - requested_enrollment ?instructor_schedule - instructor_schedule ?supporting_document - supporting_document)
    :precondition
      (and
        (request_ready_for_review ?requested_enrollment)
        (requested_enrollment_assigned_instructor_schedule ?requested_enrollment ?instructor_schedule)
        (supporting_document_available ?supporting_document)
        (not
          (requested_enrollment_feasible ?requested_enrollment)
        )
      )
    :effect
      (and
        (instructor_confirmed_reserved ?instructor_schedule)
        (requested_enrollment_feasible ?requested_enrollment)
        (requested_enrollment_attached_document ?requested_enrollment ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action transfer_instructor_claim_with_document
    :parameters (?requested_enrollment - requested_enrollment ?instructor_schedule - instructor_schedule ?timetable_slot - timetable_slot ?supporting_document - supporting_document)
    :precondition
      (and
        (request_ready_for_review ?requested_enrollment)
        (has_linked_timetable_slot ?requested_enrollment ?timetable_slot)
        (requested_enrollment_assigned_instructor_schedule ?requested_enrollment ?instructor_schedule)
        (instructor_confirmed_reserved ?instructor_schedule)
        (requested_enrollment_attached_document ?requested_enrollment ?supporting_document)
        (not
          (instructor_confirmed_for_requested_enrollment ?requested_enrollment)
        )
      )
    :effect
      (and
        (instructor_prelim_reserved ?instructor_schedule)
        (instructor_confirmed_for_requested_enrollment ?requested_enrollment)
        (supporting_document_available ?supporting_document)
        (not
          (requested_enrollment_attached_document ?requested_enrollment ?supporting_document)
        )
      )
  )
  (:action assemble_swap_case_variant_a
    :parameters (?student_enrollment - student_enrollment ?requested_enrollment - requested_enrollment ?venue - venue ?instructor_schedule - instructor_schedule ?swap_case - swap_case)
    :precondition
      (and
        (student_enrollment_feasible ?student_enrollment)
        (requested_enrollment_feasible ?requested_enrollment)
        (enrollment_assigned_venue ?student_enrollment ?venue)
        (requested_enrollment_assigned_instructor_schedule ?requested_enrollment ?instructor_schedule)
        (venue_prelim_reserved ?venue)
        (instructor_prelim_reserved ?instructor_schedule)
        (venue_confirmed_for_enrollment ?student_enrollment)
        (instructor_confirmed_for_requested_enrollment ?requested_enrollment)
        (case_unallocated ?swap_case)
      )
    :effect
      (and
        (case_created ?swap_case)
        (case_allocated_venue ?swap_case ?venue)
        (case_allocated_instructor ?swap_case ?instructor_schedule)
        (not
          (case_unallocated ?swap_case)
        )
      )
  )
  (:action assemble_swap_case_variant_b
    :parameters (?student_enrollment - student_enrollment ?requested_enrollment - requested_enrollment ?venue - venue ?instructor_schedule - instructor_schedule ?swap_case - swap_case)
    :precondition
      (and
        (student_enrollment_feasible ?student_enrollment)
        (requested_enrollment_feasible ?requested_enrollment)
        (enrollment_assigned_venue ?student_enrollment ?venue)
        (requested_enrollment_assigned_instructor_schedule ?requested_enrollment ?instructor_schedule)
        (venue_confirmed_reserved ?venue)
        (instructor_prelim_reserved ?instructor_schedule)
        (not
          (venue_confirmed_for_enrollment ?student_enrollment)
        )
        (instructor_confirmed_for_requested_enrollment ?requested_enrollment)
        (case_unallocated ?swap_case)
      )
    :effect
      (and
        (case_created ?swap_case)
        (case_allocated_venue ?swap_case ?venue)
        (case_allocated_instructor ?swap_case ?instructor_schedule)
        (case_requires_department_constraint ?swap_case)
        (not
          (case_unallocated ?swap_case)
        )
      )
  )
  (:action assemble_swap_case_variant_c
    :parameters (?student_enrollment - student_enrollment ?requested_enrollment - requested_enrollment ?venue - venue ?instructor_schedule - instructor_schedule ?swap_case - swap_case)
    :precondition
      (and
        (student_enrollment_feasible ?student_enrollment)
        (requested_enrollment_feasible ?requested_enrollment)
        (enrollment_assigned_venue ?student_enrollment ?venue)
        (requested_enrollment_assigned_instructor_schedule ?requested_enrollment ?instructor_schedule)
        (venue_prelim_reserved ?venue)
        (instructor_confirmed_reserved ?instructor_schedule)
        (venue_confirmed_for_enrollment ?student_enrollment)
        (not
          (instructor_confirmed_for_requested_enrollment ?requested_enrollment)
        )
        (case_unallocated ?swap_case)
      )
    :effect
      (and
        (case_created ?swap_case)
        (case_allocated_venue ?swap_case ?venue)
        (case_allocated_instructor ?swap_case ?instructor_schedule)
        (case_requires_instructor_approval ?swap_case)
        (not
          (case_unallocated ?swap_case)
        )
      )
  )
  (:action assemble_swap_case_variant_d
    :parameters (?student_enrollment - student_enrollment ?requested_enrollment - requested_enrollment ?venue - venue ?instructor_schedule - instructor_schedule ?swap_case - swap_case)
    :precondition
      (and
        (student_enrollment_feasible ?student_enrollment)
        (requested_enrollment_feasible ?requested_enrollment)
        (enrollment_assigned_venue ?student_enrollment ?venue)
        (requested_enrollment_assigned_instructor_schedule ?requested_enrollment ?instructor_schedule)
        (venue_confirmed_reserved ?venue)
        (instructor_confirmed_reserved ?instructor_schedule)
        (not
          (venue_confirmed_for_enrollment ?student_enrollment)
        )
        (not
          (instructor_confirmed_for_requested_enrollment ?requested_enrollment)
        )
        (case_unallocated ?swap_case)
      )
    :effect
      (and
        (case_created ?swap_case)
        (case_allocated_venue ?swap_case ?venue)
        (case_allocated_instructor ?swap_case ?instructor_schedule)
        (case_requires_department_constraint ?swap_case)
        (case_requires_instructor_approval ?swap_case)
        (not
          (case_unallocated ?swap_case)
        )
      )
  )
  (:action lock_case_slot
    :parameters (?swap_case - swap_case ?student_enrollment - student_enrollment ?timetable_slot - timetable_slot)
    :precondition
      (and
        (case_created ?swap_case)
        (student_enrollment_feasible ?student_enrollment)
        (has_linked_timetable_slot ?student_enrollment ?timetable_slot)
        (not
          (case_slot_locked ?swap_case)
        )
      )
    :effect (case_slot_locked ?swap_case)
  )
  (:action consume_registrar_fragment
    :parameters (?course_section - course_section ?registrar_record_fragment - registrar_record_fragment ?swap_case - swap_case)
    :precondition
      (and
        (request_ready_for_review ?course_section)
        (section_associated_with_case ?course_section ?swap_case)
        (section_has_registrar_fragment ?course_section ?registrar_record_fragment)
        (registrar_fragment_available ?registrar_record_fragment)
        (case_created ?swap_case)
        (case_slot_locked ?swap_case)
        (not
          (registrar_fragment_consumed ?registrar_record_fragment)
        )
      )
    :effect
      (and
        (registrar_fragment_consumed ?registrar_record_fragment)
        (registrar_fragment_linked_to_case ?registrar_record_fragment ?swap_case)
        (not
          (registrar_fragment_available ?registrar_record_fragment)
        )
      )
  )
  (:action validate_section_against_fragment
    :parameters (?course_section - course_section ?registrar_record_fragment - registrar_record_fragment ?swap_case - swap_case ?timetable_slot - timetable_slot)
    :precondition
      (and
        (request_ready_for_review ?course_section)
        (section_has_registrar_fragment ?course_section ?registrar_record_fragment)
        (registrar_fragment_consumed ?registrar_record_fragment)
        (registrar_fragment_linked_to_case ?registrar_record_fragment ?swap_case)
        (has_linked_timetable_slot ?course_section ?timetable_slot)
        (not
          (case_requires_department_constraint ?swap_case)
        )
        (not
          (section_validated ?course_section)
        )
      )
    :effect (section_validated ?course_section)
  )
  (:action attach_department_constraint
    :parameters (?course_section - course_section ?department_constraint - department_constraint)
    :precondition
      (and
        (request_ready_for_review ?course_section)
        (department_constraint_available ?department_constraint)
        (not
          (section_constraint_attached ?course_section)
        )
      )
    :effect
      (and
        (section_constraint_attached ?course_section)
        (section_has_department_constraint ?course_section ?department_constraint)
        (not
          (department_constraint_available ?department_constraint)
        )
      )
  )
  (:action process_constraint_and_prepare_section
    :parameters (?course_section - course_section ?registrar_record_fragment - registrar_record_fragment ?swap_case - swap_case ?timetable_slot - timetable_slot ?department_constraint - department_constraint)
    :precondition
      (and
        (request_ready_for_review ?course_section)
        (section_has_registrar_fragment ?course_section ?registrar_record_fragment)
        (registrar_fragment_consumed ?registrar_record_fragment)
        (registrar_fragment_linked_to_case ?registrar_record_fragment ?swap_case)
        (has_linked_timetable_slot ?course_section ?timetable_slot)
        (case_requires_department_constraint ?swap_case)
        (section_constraint_attached ?course_section)
        (section_has_department_constraint ?course_section ?department_constraint)
        (not
          (section_validated ?course_section)
        )
      )
    :effect
      (and
        (section_validated ?course_section)
        (section_constraint_processed ?course_section)
      )
  )
  (:action allocate_instructor_to_section_path1
    :parameters (?course_section - course_section ?instructor_approval_token - instructor_approval_token ?administrator - administrator ?registrar_record_fragment - registrar_record_fragment ?swap_case - swap_case)
    :precondition
      (and
        (section_validated ?course_section)
        (section_has_instructor_approval_token ?course_section ?instructor_approval_token)
        (assigned_administrator_to_request ?course_section ?administrator)
        (section_has_registrar_fragment ?course_section ?registrar_record_fragment)
        (registrar_fragment_linked_to_case ?registrar_record_fragment ?swap_case)
        (not
          (case_requires_instructor_approval ?swap_case)
        )
        (not
          (instructor_allocated_to_section ?course_section)
        )
      )
    :effect (instructor_allocated_to_section ?course_section)
  )
  (:action allocate_instructor_to_section_path2
    :parameters (?course_section - course_section ?instructor_approval_token - instructor_approval_token ?administrator - administrator ?registrar_record_fragment - registrar_record_fragment ?swap_case - swap_case)
    :precondition
      (and
        (section_validated ?course_section)
        (section_has_instructor_approval_token ?course_section ?instructor_approval_token)
        (assigned_administrator_to_request ?course_section ?administrator)
        (section_has_registrar_fragment ?course_section ?registrar_record_fragment)
        (registrar_fragment_linked_to_case ?registrar_record_fragment ?swap_case)
        (case_requires_instructor_approval ?swap_case)
        (not
          (instructor_allocated_to_section ?course_section)
        )
      )
    :effect (instructor_allocated_to_section ?course_section)
  )
  (:action process_venue_approval_and_finalize_section_checks
    :parameters (?course_section - course_section ?venue_approval_token - venue_approval_token ?registrar_record_fragment - registrar_record_fragment ?swap_case - swap_case)
    :precondition
      (and
        (instructor_allocated_to_section ?course_section)
        (section_has_venue_approval_token ?course_section ?venue_approval_token)
        (section_has_registrar_fragment ?course_section ?registrar_record_fragment)
        (registrar_fragment_linked_to_case ?registrar_record_fragment ?swap_case)
        (not
          (case_requires_department_constraint ?swap_case)
        )
        (not
          (case_requires_instructor_approval ?swap_case)
        )
        (not
          (section_checks_complete ?course_section)
        )
      )
    :effect (section_checks_complete ?course_section)
  )
  (:action process_venue_approval_with_alternate_path
    :parameters (?course_section - course_section ?venue_approval_token - venue_approval_token ?registrar_record_fragment - registrar_record_fragment ?swap_case - swap_case)
    :precondition
      (and
        (instructor_allocated_to_section ?course_section)
        (section_has_venue_approval_token ?course_section ?venue_approval_token)
        (section_has_registrar_fragment ?course_section ?registrar_record_fragment)
        (registrar_fragment_linked_to_case ?registrar_record_fragment ?swap_case)
        (case_requires_department_constraint ?swap_case)
        (not
          (case_requires_instructor_approval ?swap_case)
        )
        (not
          (section_checks_complete ?course_section)
        )
      )
    :effect
      (and
        (section_checks_complete ?course_section)
        (section_ready_for_final_validation ?course_section)
      )
  )
  (:action process_venue_approval_path_c
    :parameters (?course_section - course_section ?venue_approval_token - venue_approval_token ?registrar_record_fragment - registrar_record_fragment ?swap_case - swap_case)
    :precondition
      (and
        (instructor_allocated_to_section ?course_section)
        (section_has_venue_approval_token ?course_section ?venue_approval_token)
        (section_has_registrar_fragment ?course_section ?registrar_record_fragment)
        (registrar_fragment_linked_to_case ?registrar_record_fragment ?swap_case)
        (not
          (case_requires_department_constraint ?swap_case)
        )
        (case_requires_instructor_approval ?swap_case)
        (not
          (section_checks_complete ?course_section)
        )
      )
    :effect
      (and
        (section_checks_complete ?course_section)
        (section_ready_for_final_validation ?course_section)
      )
  )
  (:action process_venue_approval_path_d
    :parameters (?course_section - course_section ?venue_approval_token - venue_approval_token ?registrar_record_fragment - registrar_record_fragment ?swap_case - swap_case)
    :precondition
      (and
        (instructor_allocated_to_section ?course_section)
        (section_has_venue_approval_token ?course_section ?venue_approval_token)
        (section_has_registrar_fragment ?course_section ?registrar_record_fragment)
        (registrar_fragment_linked_to_case ?registrar_record_fragment ?swap_case)
        (case_requires_department_constraint ?swap_case)
        (case_requires_instructor_approval ?swap_case)
        (not
          (section_checks_complete ?course_section)
        )
      )
    :effect
      (and
        (section_checks_complete ?course_section)
        (section_ready_for_final_validation ?course_section)
      )
  )
  (:action final_validation_and_mark_ready_for_commit
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_checks_complete ?course_section)
        (not
          (section_ready_for_final_validation ?course_section)
        )
        (not
          (section_locked ?course_section)
        )
      )
    :effect
      (and
        (section_locked ?course_section)
        (ready_for_section_commit ?course_section)
      )
  )
  (:action attach_policy_consent_to_section
    :parameters (?course_section - course_section ?policy_consent - policy_consent)
    :precondition
      (and
        (section_checks_complete ?course_section)
        (section_ready_for_final_validation ?course_section)
        (policy_consent_available ?policy_consent)
      )
    :effect
      (and
        (section_has_policy_consent ?course_section ?policy_consent)
        (not
          (policy_consent_available ?policy_consent)
        )
      )
  )
  (:action run_degree_audit_and_lock_preconditions
    :parameters (?course_section - course_section ?student_enrollment - student_enrollment ?requested_enrollment - requested_enrollment ?timetable_slot - timetable_slot ?policy_consent - policy_consent)
    :precondition
      (and
        (section_checks_complete ?course_section)
        (section_ready_for_final_validation ?course_section)
        (section_has_policy_consent ?course_section ?policy_consent)
        (section_has_student_enrollment ?course_section ?student_enrollment)
        (section_has_requested_enrollment ?course_section ?requested_enrollment)
        (venue_confirmed_for_enrollment ?student_enrollment)
        (instructor_confirmed_for_requested_enrollment ?requested_enrollment)
        (has_linked_timetable_slot ?course_section ?timetable_slot)
        (not
          (section_prepared_for_lock ?course_section)
        )
      )
    :effect (section_prepared_for_lock ?course_section)
  )
  (:action lock_section_and_mark_ready_for_commit
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_checks_complete ?course_section)
        (section_prepared_for_lock ?course_section)
        (not
          (section_locked ?course_section)
        )
      )
    :effect
      (and
        (section_locked ?course_section)
        (ready_for_section_commit ?course_section)
      )
  )
  (:action record_special_approval
    :parameters (?course_section - course_section ?department_approval_token - department_approval_token ?timetable_slot - timetable_slot)
    :precondition
      (and
        (request_ready_for_review ?course_section)
        (has_linked_timetable_slot ?course_section ?timetable_slot)
        (department_approval_token_available ?department_approval_token)
        (section_has_department_approval_token ?course_section ?department_approval_token)
        (not
          (special_approval_recorded ?course_section)
        )
      )
    :effect
      (and
        (special_approval_recorded ?course_section)
        (not
          (department_approval_token_available ?department_approval_token)
        )
      )
  )
  (:action verify_special_approval
    :parameters (?course_section - course_section ?administrator - administrator)
    :precondition
      (and
        (special_approval_recorded ?course_section)
        (assigned_administrator_to_request ?course_section ?administrator)
        (not
          (special_approval_verified ?course_section)
        )
      )
    :effect (special_approval_verified ?course_section)
  )
  (:action attach_venue_approval_to_section
    :parameters (?course_section - course_section ?venue_approval_token - venue_approval_token)
    :precondition
      (and
        (special_approval_verified ?course_section)
        (section_has_venue_approval_token ?course_section ?venue_approval_token)
        (not
          (special_approval_finalized ?course_section)
        )
      )
    :effect (special_approval_finalized ?course_section)
  )
  (:action finalize_special_approval_and_ready
    :parameters (?course_section - course_section)
    :precondition
      (and
        (special_approval_finalized ?course_section)
        (not
          (section_locked ?course_section)
        )
      )
    :effect
      (and
        (section_locked ?course_section)
        (ready_for_section_commit ?course_section)
      )
  )
  (:action commit_enrollment_source
    :parameters (?student_enrollment - student_enrollment ?swap_case - swap_case)
    :precondition
      (and
        (student_enrollment_feasible ?student_enrollment)
        (venue_confirmed_for_enrollment ?student_enrollment)
        (case_created ?swap_case)
        (case_slot_locked ?swap_case)
        (not
          (ready_for_section_commit ?student_enrollment)
        )
      )
    :effect (ready_for_section_commit ?student_enrollment)
  )
  (:action commit_enrollment_requested
    :parameters (?requested_enrollment - requested_enrollment ?swap_case - swap_case)
    :precondition
      (and
        (requested_enrollment_feasible ?requested_enrollment)
        (instructor_confirmed_for_requested_enrollment ?requested_enrollment)
        (case_created ?swap_case)
        (case_slot_locked ?swap_case)
        (not
          (ready_for_section_commit ?requested_enrollment)
        )
      )
    :effect (ready_for_section_commit ?requested_enrollment)
  )
  (:action prepare_enrollment_for_commit
    :parameters (?actor - request_subject ?deadline_token - deadline_token ?timetable_slot - timetable_slot)
    :precondition
      (and
        (ready_for_section_commit ?actor)
        (has_linked_timetable_slot ?actor ?timetable_slot)
        (deadline_token_available ?deadline_token)
        (not
          (ready_for_enrollment_commit ?actor)
        )
      )
    :effect
      (and
        (ready_for_enrollment_commit ?actor)
        (has_deadline_token_for ?actor ?deadline_token)
        (not
          (deadline_token_available ?deadline_token)
        )
      )
  )
  (:action apply_commit_to_source_enrollment_with_seat
    :parameters (?student_enrollment - student_enrollment ?section_seat - section_seat ?deadline_token - deadline_token)
    :precondition
      (and
        (ready_for_enrollment_commit ?student_enrollment)
        (has_reserved_seat ?student_enrollment ?section_seat)
        (has_deadline_token_for ?student_enrollment ?deadline_token)
        (not
          (enrollment_committed ?student_enrollment)
        )
      )
    :effect
      (and
        (enrollment_committed ?student_enrollment)
        (seat_available ?section_seat)
        (deadline_token_available ?deadline_token)
      )
  )
  (:action apply_commit_to_requested_enrollment_with_seat
    :parameters (?requested_enrollment - requested_enrollment ?section_seat - section_seat ?deadline_token - deadline_token)
    :precondition
      (and
        (ready_for_enrollment_commit ?requested_enrollment)
        (has_reserved_seat ?requested_enrollment ?section_seat)
        (has_deadline_token_for ?requested_enrollment ?deadline_token)
        (not
          (enrollment_committed ?requested_enrollment)
        )
      )
    :effect
      (and
        (enrollment_committed ?requested_enrollment)
        (seat_available ?section_seat)
        (deadline_token_available ?deadline_token)
      )
  )
  (:action apply_commit_to_section_with_seat
    :parameters (?course_section - course_section ?section_seat - section_seat ?deadline_token - deadline_token)
    :precondition
      (and
        (ready_for_enrollment_commit ?course_section)
        (has_reserved_seat ?course_section ?section_seat)
        (has_deadline_token_for ?course_section ?deadline_token)
        (not
          (enrollment_committed ?course_section)
        )
      )
    :effect
      (and
        (enrollment_committed ?course_section)
        (seat_available ?section_seat)
        (deadline_token_available ?deadline_token)
      )
  )
)

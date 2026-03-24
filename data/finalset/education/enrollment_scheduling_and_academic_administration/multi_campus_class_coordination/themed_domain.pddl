(define (domain multi_campus_class_coordination_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types admin_meta_cluster - object scheduling_meta_cluster - object resource_meta_cluster - object course_supertype - object registration_request - course_supertype enrollment_officer - admin_meta_cluster requested_timeslot_preference - admin_meta_cluster department_approver - admin_meta_cluster crosslisting_slot - admin_meta_cluster academic_term - admin_meta_cluster student_record - admin_meta_cluster instructor - admin_meta_cluster accreditation_officer - admin_meta_cluster auxiliary_resource - scheduling_meta_cluster instructional_package - scheduling_meta_cluster curriculum_representative - scheduling_meta_cluster timeslot_candidate_a - resource_meta_cluster timeslot_candidate_b - resource_meta_cluster classroom_resource - resource_meta_cluster section_supertype_a - registration_request section_supertype_b - registration_request section_variant_a - section_supertype_a section_variant_b - section_supertype_a course_offering - section_supertype_b)
  (:predicates
    (request_recorded ?registration_request - registration_request)
    (preliminary_approval_granted_for_subject ?registration_request - registration_request)
    (request_officer_assigned ?registration_request - registration_request)
    (finalized_for_subject ?registration_request - registration_request)
    (ready_for_enrollment_confirmation_for_subject ?registration_request - registration_request)
    (enrollment_confirmed_for_subject ?registration_request - registration_request)
    (enrollment_officer_available ?enrollment_officer - enrollment_officer)
    (assigned_enrollment_officer_for_subject ?registration_request - registration_request ?enrollment_officer - enrollment_officer)
    (timeslot_preference_available ?requested_timeslot_preference - requested_timeslot_preference)
    (tentative_timeslot_match_for_subject ?registration_request - registration_request ?requested_timeslot_preference - requested_timeslot_preference)
    (department_approver_available ?department_approver - department_approver)
    (assigned_department_approver_for_subject ?registration_request - registration_request ?department_approver - department_approver)
    (auxiliary_resource_available ?auxiliary_resource - auxiliary_resource)
    (section_variant_a_reserved_auxiliary_resource ?section_variant_a - section_variant_a ?auxiliary_resource - auxiliary_resource)
    (section_variant_b_reserved_auxiliary_resource ?section_variant_b - section_variant_b ?auxiliary_resource - auxiliary_resource)
    (section_variant_a_claims_timeslot_candidate ?section_variant_a - section_variant_a ?timeslot_candidate_a - timeslot_candidate_a)
    (timeslot_candidate_a_reserved ?timeslot_candidate_a - timeslot_candidate_a)
    (timeslot_candidate_a_auxiliary_reserved ?timeslot_candidate_a - timeslot_candidate_a)
    (section_variant_a_ready_for_room_assignment ?section_variant_a - section_variant_a)
    (section_variant_b_claims_timeslot_candidate ?section_variant_b - section_variant_b ?timeslot_candidate_b - timeslot_candidate_b)
    (timeslot_candidate_b_reserved ?timeslot_candidate_b - timeslot_candidate_b)
    (timeslot_candidate_b_auxiliary_reserved ?timeslot_candidate_b - timeslot_candidate_b)
    (section_variant_b_ready_for_room_assignment ?section_variant_b - section_variant_b)
    (classroom_resource_available ?classroom_resource - classroom_resource)
    (classroom_resource_reserved ?classroom_resource - classroom_resource)
    (classroom_allocated_to_timeslot_candidate_a ?classroom_resource - classroom_resource ?timeslot_candidate_a - timeslot_candidate_a)
    (classroom_allocated_to_timeslot_candidate_b ?classroom_resource - classroom_resource ?timeslot_candidate_b - timeslot_candidate_b)
    (classroom_mark_variant_a_path ?classroom_resource - classroom_resource)
    (classroom_mark_variant_b_path ?classroom_resource - classroom_resource)
    (classroom_locked ?classroom_resource - classroom_resource)
    (offering_includes_variant_a ?course_offering - course_offering ?section_variant_a - section_variant_a)
    (offering_includes_variant_b ?course_offering - course_offering ?section_variant_b - section_variant_b)
    (offering_associated_classroom ?course_offering - course_offering ?classroom_resource - classroom_resource)
    (instructional_package_available ?instructional_resource_package - instructional_package)
    (offering_has_instructional_package ?course_offering - course_offering ?instructional_resource_package - instructional_package)
    (instructional_package_reserved ?instructional_resource_package - instructional_package)
    (instructional_package_allocated_to_classroom ?instructional_resource_package - instructional_package ?classroom_resource - classroom_resource)
    (offering_instructional_package_validated ?course_offering - course_offering)
    (offering_materials_allocated ?course_offering - course_offering)
    (offering_ready_for_final_activation ?course_offering - course_offering)
    (offering_crosslisting_assigned ?course_offering - course_offering)
    (offering_crosslisting_confirmed ?course_offering - course_offering)
    (offering_packaging_authorized ?course_offering - course_offering)
    (offering_instructor_assignment_completed ?course_offering - course_offering)
    (curriculum_representative_available ?curriculum_representative - curriculum_representative)
    (offering_assigned_curriculum_representative ?course_offering - course_offering ?curriculum_representative - curriculum_representative)
    (offering_curriculum_representative_confirmed ?course_offering - course_offering)
    (offering_department_endorsed ?course_offering - course_offering)
    (offering_accreditation_endorsed ?course_offering - course_offering)
    (crosslisting_slot_available ?crosslisting_slot - crosslisting_slot)
    (offering_assigned_crosslisting_slot ?course_offering - course_offering ?crosslisting_slot - crosslisting_slot)
    (academic_term_available ?academic_term - academic_term)
    (offering_scheduled_for_term ?course_offering - course_offering ?academic_term - academic_term)
    (instructor_available ?instructor - instructor)
    (offering_assigned_instructor ?course_offering - course_offering ?instructor - instructor)
    (accreditation_officer_available ?accreditation_officer - accreditation_officer)
    (offering_assigned_accreditation_officer ?course_offering - course_offering ?accreditation_officer - accreditation_officer)
    (student_record_available ?student_record - student_record)
    (bound_to_student_record ?registration_request - registration_request ?student_record - student_record)
    (section_variant_a_has_local_claim ?section_variant_a - section_variant_a)
    (section_variant_b_has_local_claim ?section_variant_b - section_variant_b)
    (offering_finalization_committed ?course_offering - course_offering)
  )
  (:action record_registration_request
    :parameters (?registration_request - registration_request)
    :precondition
      (and
        (not
          (request_recorded ?registration_request)
        )
        (not
          (finalized_for_subject ?registration_request)
        )
      )
    :effect (request_recorded ?registration_request)
  )
  (:action assign_enrollment_officer_to_request
    :parameters (?registration_request - registration_request ?enrollment_officer - enrollment_officer)
    :precondition
      (and
        (request_recorded ?registration_request)
        (not
          (request_officer_assigned ?registration_request)
        )
        (enrollment_officer_available ?enrollment_officer)
      )
    :effect
      (and
        (request_officer_assigned ?registration_request)
        (assigned_enrollment_officer_for_subject ?registration_request ?enrollment_officer)
        (not
          (enrollment_officer_available ?enrollment_officer)
        )
      )
  )
  (:action associate_timeslot_preference_with_request
    :parameters (?registration_request - registration_request ?requested_timeslot_preference - requested_timeslot_preference)
    :precondition
      (and
        (request_recorded ?registration_request)
        (request_officer_assigned ?registration_request)
        (timeslot_preference_available ?requested_timeslot_preference)
      )
    :effect
      (and
        (tentative_timeslot_match_for_subject ?registration_request ?requested_timeslot_preference)
        (not
          (timeslot_preference_available ?requested_timeslot_preference)
        )
      )
  )
  (:action preliminarily_validate_request
    :parameters (?registration_request - registration_request ?requested_timeslot_preference - requested_timeslot_preference)
    :precondition
      (and
        (request_recorded ?registration_request)
        (request_officer_assigned ?registration_request)
        (tentative_timeslot_match_for_subject ?registration_request ?requested_timeslot_preference)
        (not
          (preliminary_approval_granted_for_subject ?registration_request)
        )
      )
    :effect (preliminary_approval_granted_for_subject ?registration_request)
  )
  (:action rollback_timeslot_preference_match
    :parameters (?registration_request - registration_request ?requested_timeslot_preference - requested_timeslot_preference)
    :precondition
      (and
        (tentative_timeslot_match_for_subject ?registration_request ?requested_timeslot_preference)
      )
    :effect
      (and
        (timeslot_preference_available ?requested_timeslot_preference)
        (not
          (tentative_timeslot_match_for_subject ?registration_request ?requested_timeslot_preference)
        )
      )
  )
  (:action assign_department_approver_to_request
    :parameters (?registration_request - registration_request ?department_approver - department_approver)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?registration_request)
        (department_approver_available ?department_approver)
      )
    :effect
      (and
        (assigned_department_approver_for_subject ?registration_request ?department_approver)
        (not
          (department_approver_available ?department_approver)
        )
      )
  )
  (:action unassign_department_approver_from_request
    :parameters (?registration_request - registration_request ?department_approver - department_approver)
    :precondition
      (and
        (assigned_department_approver_for_subject ?registration_request ?department_approver)
      )
    :effect
      (and
        (department_approver_available ?department_approver)
        (not
          (assigned_department_approver_for_subject ?registration_request ?department_approver)
        )
      )
  )
  (:action assign_instructor_to_offering
    :parameters (?course_offering - course_offering ?instructor - instructor)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?course_offering)
        (instructor_available ?instructor)
      )
    :effect
      (and
        (offering_assigned_instructor ?course_offering ?instructor)
        (not
          (instructor_available ?instructor)
        )
      )
  )
  (:action unassign_instructor_from_offering
    :parameters (?course_offering - course_offering ?instructor - instructor)
    :precondition
      (and
        (offering_assigned_instructor ?course_offering ?instructor)
      )
    :effect
      (and
        (instructor_available ?instructor)
        (not
          (offering_assigned_instructor ?course_offering ?instructor)
        )
      )
  )
  (:action assign_accreditation_officer_to_offering
    :parameters (?course_offering - course_offering ?accreditation_officer - accreditation_officer)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?course_offering)
        (accreditation_officer_available ?accreditation_officer)
      )
    :effect
      (and
        (offering_assigned_accreditation_officer ?course_offering ?accreditation_officer)
        (not
          (accreditation_officer_available ?accreditation_officer)
        )
      )
  )
  (:action unassign_accreditation_officer_from_offering
    :parameters (?course_offering - course_offering ?accreditation_officer - accreditation_officer)
    :precondition
      (and
        (offering_assigned_accreditation_officer ?course_offering ?accreditation_officer)
      )
    :effect
      (and
        (accreditation_officer_available ?accreditation_officer)
        (not
          (offering_assigned_accreditation_officer ?course_offering ?accreditation_officer)
        )
      )
  )
  (:action reserve_timeslot_candidate_a_for_variant
    :parameters (?section_variant_a - section_variant_a ?timeslot_candidate_a - timeslot_candidate_a ?requested_timeslot_preference - requested_timeslot_preference)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?section_variant_a)
        (tentative_timeslot_match_for_subject ?section_variant_a ?requested_timeslot_preference)
        (section_variant_a_claims_timeslot_candidate ?section_variant_a ?timeslot_candidate_a)
        (not
          (timeslot_candidate_a_reserved ?timeslot_candidate_a)
        )
        (not
          (timeslot_candidate_a_auxiliary_reserved ?timeslot_candidate_a)
        )
      )
    :effect (timeslot_candidate_a_reserved ?timeslot_candidate_a)
  )
  (:action approve_timeslot_candidate_for_variant_a
    :parameters (?section_variant_a - section_variant_a ?timeslot_candidate_a - timeslot_candidate_a ?department_approver - department_approver)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?section_variant_a)
        (assigned_department_approver_for_subject ?section_variant_a ?department_approver)
        (section_variant_a_claims_timeslot_candidate ?section_variant_a ?timeslot_candidate_a)
        (timeslot_candidate_a_reserved ?timeslot_candidate_a)
        (not
          (section_variant_a_has_local_claim ?section_variant_a)
        )
      )
    :effect
      (and
        (section_variant_a_has_local_claim ?section_variant_a)
        (section_variant_a_ready_for_room_assignment ?section_variant_a)
      )
  )
  (:action claim_auxiliary_resource_for_variant_a
    :parameters (?section_variant_a - section_variant_a ?timeslot_candidate_a - timeslot_candidate_a ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?section_variant_a)
        (section_variant_a_claims_timeslot_candidate ?section_variant_a ?timeslot_candidate_a)
        (auxiliary_resource_available ?auxiliary_resource)
        (not
          (section_variant_a_has_local_claim ?section_variant_a)
        )
      )
    :effect
      (and
        (timeslot_candidate_a_auxiliary_reserved ?timeslot_candidate_a)
        (section_variant_a_has_local_claim ?section_variant_a)
        (section_variant_a_reserved_auxiliary_resource ?section_variant_a ?auxiliary_resource)
        (not
          (auxiliary_resource_available ?auxiliary_resource)
        )
      )
  )
  (:action finalize_auxiliary_allocation_for_variant_a
    :parameters (?section_variant_a - section_variant_a ?timeslot_candidate_a - timeslot_candidate_a ?requested_timeslot_preference - requested_timeslot_preference ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?section_variant_a)
        (tentative_timeslot_match_for_subject ?section_variant_a ?requested_timeslot_preference)
        (section_variant_a_claims_timeslot_candidate ?section_variant_a ?timeslot_candidate_a)
        (timeslot_candidate_a_auxiliary_reserved ?timeslot_candidate_a)
        (section_variant_a_reserved_auxiliary_resource ?section_variant_a ?auxiliary_resource)
        (not
          (section_variant_a_ready_for_room_assignment ?section_variant_a)
        )
      )
    :effect
      (and
        (timeslot_candidate_a_reserved ?timeslot_candidate_a)
        (section_variant_a_ready_for_room_assignment ?section_variant_a)
        (auxiliary_resource_available ?auxiliary_resource)
        (not
          (section_variant_a_reserved_auxiliary_resource ?section_variant_a ?auxiliary_resource)
        )
      )
  )
  (:action reserve_timeslot_candidate_b_for_variant
    :parameters (?section_variant_b - section_variant_b ?timeslot_candidate_b - timeslot_candidate_b ?requested_timeslot_preference - requested_timeslot_preference)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?section_variant_b)
        (tentative_timeslot_match_for_subject ?section_variant_b ?requested_timeslot_preference)
        (section_variant_b_claims_timeslot_candidate ?section_variant_b ?timeslot_candidate_b)
        (not
          (timeslot_candidate_b_reserved ?timeslot_candidate_b)
        )
        (not
          (timeslot_candidate_b_auxiliary_reserved ?timeslot_candidate_b)
        )
      )
    :effect (timeslot_candidate_b_reserved ?timeslot_candidate_b)
  )
  (:action approve_timeslot_candidate_for_variant_b
    :parameters (?section_variant_b - section_variant_b ?timeslot_candidate_b - timeslot_candidate_b ?department_approver - department_approver)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?section_variant_b)
        (assigned_department_approver_for_subject ?section_variant_b ?department_approver)
        (section_variant_b_claims_timeslot_candidate ?section_variant_b ?timeslot_candidate_b)
        (timeslot_candidate_b_reserved ?timeslot_candidate_b)
        (not
          (section_variant_b_has_local_claim ?section_variant_b)
        )
      )
    :effect
      (and
        (section_variant_b_has_local_claim ?section_variant_b)
        (section_variant_b_ready_for_room_assignment ?section_variant_b)
      )
  )
  (:action claim_auxiliary_resource_for_variant_b
    :parameters (?section_variant_b - section_variant_b ?timeslot_candidate_b - timeslot_candidate_b ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?section_variant_b)
        (section_variant_b_claims_timeslot_candidate ?section_variant_b ?timeslot_candidate_b)
        (auxiliary_resource_available ?auxiliary_resource)
        (not
          (section_variant_b_has_local_claim ?section_variant_b)
        )
      )
    :effect
      (and
        (timeslot_candidate_b_auxiliary_reserved ?timeslot_candidate_b)
        (section_variant_b_has_local_claim ?section_variant_b)
        (section_variant_b_reserved_auxiliary_resource ?section_variant_b ?auxiliary_resource)
        (not
          (auxiliary_resource_available ?auxiliary_resource)
        )
      )
  )
  (:action finalize_auxiliary_allocation_for_variant_b
    :parameters (?section_variant_b - section_variant_b ?timeslot_candidate_b - timeslot_candidate_b ?requested_timeslot_preference - requested_timeslot_preference ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?section_variant_b)
        (tentative_timeslot_match_for_subject ?section_variant_b ?requested_timeslot_preference)
        (section_variant_b_claims_timeslot_candidate ?section_variant_b ?timeslot_candidate_b)
        (timeslot_candidate_b_auxiliary_reserved ?timeslot_candidate_b)
        (section_variant_b_reserved_auxiliary_resource ?section_variant_b ?auxiliary_resource)
        (not
          (section_variant_b_ready_for_room_assignment ?section_variant_b)
        )
      )
    :effect
      (and
        (timeslot_candidate_b_reserved ?timeslot_candidate_b)
        (section_variant_b_ready_for_room_assignment ?section_variant_b)
        (auxiliary_resource_available ?auxiliary_resource)
        (not
          (section_variant_b_reserved_auxiliary_resource ?section_variant_b ?auxiliary_resource)
        )
      )
  )
  (:action allocate_classroom_for_variants
    :parameters (?section_variant_a - section_variant_a ?section_variant_b - section_variant_b ?timeslot_candidate_a - timeslot_candidate_a ?timeslot_candidate_b - timeslot_candidate_b ?classroom_resource - classroom_resource)
    :precondition
      (and
        (section_variant_a_has_local_claim ?section_variant_a)
        (section_variant_b_has_local_claim ?section_variant_b)
        (section_variant_a_claims_timeslot_candidate ?section_variant_a ?timeslot_candidate_a)
        (section_variant_b_claims_timeslot_candidate ?section_variant_b ?timeslot_candidate_b)
        (timeslot_candidate_a_reserved ?timeslot_candidate_a)
        (timeslot_candidate_b_reserved ?timeslot_candidate_b)
        (section_variant_a_ready_for_room_assignment ?section_variant_a)
        (section_variant_b_ready_for_room_assignment ?section_variant_b)
        (classroom_resource_available ?classroom_resource)
      )
    :effect
      (and
        (classroom_resource_reserved ?classroom_resource)
        (classroom_allocated_to_timeslot_candidate_a ?classroom_resource ?timeslot_candidate_a)
        (classroom_allocated_to_timeslot_candidate_b ?classroom_resource ?timeslot_candidate_b)
        (not
          (classroom_resource_available ?classroom_resource)
        )
      )
  )
  (:action allocate_classroom_for_variants_auxiliary_a_path
    :parameters (?section_variant_a - section_variant_a ?section_variant_b - section_variant_b ?timeslot_candidate_a - timeslot_candidate_a ?timeslot_candidate_b - timeslot_candidate_b ?classroom_resource - classroom_resource)
    :precondition
      (and
        (section_variant_a_has_local_claim ?section_variant_a)
        (section_variant_b_has_local_claim ?section_variant_b)
        (section_variant_a_claims_timeslot_candidate ?section_variant_a ?timeslot_candidate_a)
        (section_variant_b_claims_timeslot_candidate ?section_variant_b ?timeslot_candidate_b)
        (timeslot_candidate_a_auxiliary_reserved ?timeslot_candidate_a)
        (timeslot_candidate_b_reserved ?timeslot_candidate_b)
        (not
          (section_variant_a_ready_for_room_assignment ?section_variant_a)
        )
        (section_variant_b_ready_for_room_assignment ?section_variant_b)
        (classroom_resource_available ?classroom_resource)
      )
    :effect
      (and
        (classroom_resource_reserved ?classroom_resource)
        (classroom_allocated_to_timeslot_candidate_a ?classroom_resource ?timeslot_candidate_a)
        (classroom_allocated_to_timeslot_candidate_b ?classroom_resource ?timeslot_candidate_b)
        (classroom_mark_variant_a_path ?classroom_resource)
        (not
          (classroom_resource_available ?classroom_resource)
        )
      )
  )
  (:action allocate_classroom_for_variants_auxiliary_b_path
    :parameters (?section_variant_a - section_variant_a ?section_variant_b - section_variant_b ?timeslot_candidate_a - timeslot_candidate_a ?timeslot_candidate_b - timeslot_candidate_b ?classroom_resource - classroom_resource)
    :precondition
      (and
        (section_variant_a_has_local_claim ?section_variant_a)
        (section_variant_b_has_local_claim ?section_variant_b)
        (section_variant_a_claims_timeslot_candidate ?section_variant_a ?timeslot_candidate_a)
        (section_variant_b_claims_timeslot_candidate ?section_variant_b ?timeslot_candidate_b)
        (timeslot_candidate_a_reserved ?timeslot_candidate_a)
        (timeslot_candidate_b_auxiliary_reserved ?timeslot_candidate_b)
        (section_variant_a_ready_for_room_assignment ?section_variant_a)
        (not
          (section_variant_b_ready_for_room_assignment ?section_variant_b)
        )
        (classroom_resource_available ?classroom_resource)
      )
    :effect
      (and
        (classroom_resource_reserved ?classroom_resource)
        (classroom_allocated_to_timeslot_candidate_a ?classroom_resource ?timeslot_candidate_a)
        (classroom_allocated_to_timeslot_candidate_b ?classroom_resource ?timeslot_candidate_b)
        (classroom_mark_variant_b_path ?classroom_resource)
        (not
          (classroom_resource_available ?classroom_resource)
        )
      )
  )
  (:action allocate_classroom_for_variants_auxiliary_both_paths
    :parameters (?section_variant_a - section_variant_a ?section_variant_b - section_variant_b ?timeslot_candidate_a - timeslot_candidate_a ?timeslot_candidate_b - timeslot_candidate_b ?classroom_resource - classroom_resource)
    :precondition
      (and
        (section_variant_a_has_local_claim ?section_variant_a)
        (section_variant_b_has_local_claim ?section_variant_b)
        (section_variant_a_claims_timeslot_candidate ?section_variant_a ?timeslot_candidate_a)
        (section_variant_b_claims_timeslot_candidate ?section_variant_b ?timeslot_candidate_b)
        (timeslot_candidate_a_auxiliary_reserved ?timeslot_candidate_a)
        (timeslot_candidate_b_auxiliary_reserved ?timeslot_candidate_b)
        (not
          (section_variant_a_ready_for_room_assignment ?section_variant_a)
        )
        (not
          (section_variant_b_ready_for_room_assignment ?section_variant_b)
        )
        (classroom_resource_available ?classroom_resource)
      )
    :effect
      (and
        (classroom_resource_reserved ?classroom_resource)
        (classroom_allocated_to_timeslot_candidate_a ?classroom_resource ?timeslot_candidate_a)
        (classroom_allocated_to_timeslot_candidate_b ?classroom_resource ?timeslot_candidate_b)
        (classroom_mark_variant_a_path ?classroom_resource)
        (classroom_mark_variant_b_path ?classroom_resource)
        (not
          (classroom_resource_available ?classroom_resource)
        )
      )
  )
  (:action lock_classroom_for_slot
    :parameters (?classroom_resource - classroom_resource ?section_variant_a - section_variant_a ?requested_timeslot_preference - requested_timeslot_preference)
    :precondition
      (and
        (classroom_resource_reserved ?classroom_resource)
        (section_variant_a_has_local_claim ?section_variant_a)
        (tentative_timeslot_match_for_subject ?section_variant_a ?requested_timeslot_preference)
        (not
          (classroom_locked ?classroom_resource)
        )
      )
    :effect (classroom_locked ?classroom_resource)
  )
  (:action reserve_instructional_package_for_offering
    :parameters (?course_offering - course_offering ?instructional_resource_package - instructional_package ?classroom_resource - classroom_resource)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?course_offering)
        (offering_associated_classroom ?course_offering ?classroom_resource)
        (offering_has_instructional_package ?course_offering ?instructional_resource_package)
        (instructional_package_available ?instructional_resource_package)
        (classroom_resource_reserved ?classroom_resource)
        (classroom_locked ?classroom_resource)
        (not
          (instructional_package_reserved ?instructional_resource_package)
        )
      )
    :effect
      (and
        (instructional_package_reserved ?instructional_resource_package)
        (instructional_package_allocated_to_classroom ?instructional_resource_package ?classroom_resource)
        (not
          (instructional_package_available ?instructional_resource_package)
        )
      )
  )
  (:action validate_instructional_package_for_offering
    :parameters (?course_offering - course_offering ?instructional_resource_package - instructional_package ?classroom_resource - classroom_resource ?requested_timeslot_preference - requested_timeslot_preference)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?course_offering)
        (offering_has_instructional_package ?course_offering ?instructional_resource_package)
        (instructional_package_reserved ?instructional_resource_package)
        (instructional_package_allocated_to_classroom ?instructional_resource_package ?classroom_resource)
        (tentative_timeslot_match_for_subject ?course_offering ?requested_timeslot_preference)
        (not
          (classroom_mark_variant_a_path ?classroom_resource)
        )
        (not
          (offering_instructional_package_validated ?course_offering)
        )
      )
    :effect (offering_instructional_package_validated ?course_offering)
  )
  (:action assign_crosslisting_slot_to_offering
    :parameters (?course_offering - course_offering ?crosslisting_slot - crosslisting_slot)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?course_offering)
        (crosslisting_slot_available ?crosslisting_slot)
        (not
          (offering_crosslisting_assigned ?course_offering)
        )
      )
    :effect
      (and
        (offering_crosslisting_assigned ?course_offering)
        (offering_assigned_crosslisting_slot ?course_offering ?crosslisting_slot)
        (not
          (crosslisting_slot_available ?crosslisting_slot)
        )
      )
  )
  (:action confirm_crosslisting_and_authorize_offering
    :parameters (?course_offering - course_offering ?instructional_resource_package - instructional_package ?classroom_resource - classroom_resource ?requested_timeslot_preference - requested_timeslot_preference ?crosslisting_slot - crosslisting_slot)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?course_offering)
        (offering_has_instructional_package ?course_offering ?instructional_resource_package)
        (instructional_package_reserved ?instructional_resource_package)
        (instructional_package_allocated_to_classroom ?instructional_resource_package ?classroom_resource)
        (tentative_timeslot_match_for_subject ?course_offering ?requested_timeslot_preference)
        (classroom_mark_variant_a_path ?classroom_resource)
        (offering_crosslisting_assigned ?course_offering)
        (offering_assigned_crosslisting_slot ?course_offering ?crosslisting_slot)
        (not
          (offering_instructional_package_validated ?course_offering)
        )
      )
    :effect
      (and
        (offering_instructional_package_validated ?course_offering)
        (offering_crosslisting_confirmed ?course_offering)
      )
  )
  (:action authorize_offering_materials_for_instructor
    :parameters (?course_offering - course_offering ?instructor - instructor ?department_approver - department_approver ?instructional_resource_package - instructional_package ?classroom_resource - classroom_resource)
    :precondition
      (and
        (offering_instructional_package_validated ?course_offering)
        (offering_assigned_instructor ?course_offering ?instructor)
        (assigned_department_approver_for_subject ?course_offering ?department_approver)
        (offering_has_instructional_package ?course_offering ?instructional_resource_package)
        (instructional_package_allocated_to_classroom ?instructional_resource_package ?classroom_resource)
        (not
          (classroom_mark_variant_b_path ?classroom_resource)
        )
        (not
          (offering_materials_allocated ?course_offering)
        )
      )
    :effect (offering_materials_allocated ?course_offering)
  )
  (:action authorize_offering_materials_for_instructor_with_room_flag
    :parameters (?course_offering - course_offering ?instructor - instructor ?department_approver - department_approver ?instructional_resource_package - instructional_package ?classroom_resource - classroom_resource)
    :precondition
      (and
        (offering_instructional_package_validated ?course_offering)
        (offering_assigned_instructor ?course_offering ?instructor)
        (assigned_department_approver_for_subject ?course_offering ?department_approver)
        (offering_has_instructional_package ?course_offering ?instructional_resource_package)
        (instructional_package_allocated_to_classroom ?instructional_resource_package ?classroom_resource)
        (classroom_mark_variant_b_path ?classroom_resource)
        (not
          (offering_materials_allocated ?course_offering)
        )
      )
    :effect (offering_materials_allocated ?course_offering)
  )
  (:action authorize_offering_for_activation
    :parameters (?course_offering - course_offering ?accreditation_officer - accreditation_officer ?instructional_resource_package - instructional_package ?classroom_resource - classroom_resource)
    :precondition
      (and
        (offering_materials_allocated ?course_offering)
        (offering_assigned_accreditation_officer ?course_offering ?accreditation_officer)
        (offering_has_instructional_package ?course_offering ?instructional_resource_package)
        (instructional_package_allocated_to_classroom ?instructional_resource_package ?classroom_resource)
        (not
          (classroom_mark_variant_a_path ?classroom_resource)
        )
        (not
          (classroom_mark_variant_b_path ?classroom_resource)
        )
        (not
          (offering_ready_for_final_activation ?course_offering)
        )
      )
    :effect (offering_ready_for_final_activation ?course_offering)
  )
  (:action authorize_offering_for_activation_with_package_authorization
    :parameters (?course_offering - course_offering ?accreditation_officer - accreditation_officer ?instructional_resource_package - instructional_package ?classroom_resource - classroom_resource)
    :precondition
      (and
        (offering_materials_allocated ?course_offering)
        (offering_assigned_accreditation_officer ?course_offering ?accreditation_officer)
        (offering_has_instructional_package ?course_offering ?instructional_resource_package)
        (instructional_package_allocated_to_classroom ?instructional_resource_package ?classroom_resource)
        (classroom_mark_variant_a_path ?classroom_resource)
        (not
          (classroom_mark_variant_b_path ?classroom_resource)
        )
        (not
          (offering_ready_for_final_activation ?course_offering)
        )
      )
    :effect
      (and
        (offering_ready_for_final_activation ?course_offering)
        (offering_packaging_authorized ?course_offering)
      )
  )
  (:action authorize_offering_for_activation_and_package_alt
    :parameters (?course_offering - course_offering ?accreditation_officer - accreditation_officer ?instructional_resource_package - instructional_package ?classroom_resource - classroom_resource)
    :precondition
      (and
        (offering_materials_allocated ?course_offering)
        (offering_assigned_accreditation_officer ?course_offering ?accreditation_officer)
        (offering_has_instructional_package ?course_offering ?instructional_resource_package)
        (instructional_package_allocated_to_classroom ?instructional_resource_package ?classroom_resource)
        (not
          (classroom_mark_variant_a_path ?classroom_resource)
        )
        (classroom_mark_variant_b_path ?classroom_resource)
        (not
          (offering_ready_for_final_activation ?course_offering)
        )
      )
    :effect
      (and
        (offering_ready_for_final_activation ?course_offering)
        (offering_packaging_authorized ?course_offering)
      )
  )
  (:action authorize_offering_for_activation_and_package_both
    :parameters (?course_offering - course_offering ?accreditation_officer - accreditation_officer ?instructional_resource_package - instructional_package ?classroom_resource - classroom_resource)
    :precondition
      (and
        (offering_materials_allocated ?course_offering)
        (offering_assigned_accreditation_officer ?course_offering ?accreditation_officer)
        (offering_has_instructional_package ?course_offering ?instructional_resource_package)
        (instructional_package_allocated_to_classroom ?instructional_resource_package ?classroom_resource)
        (classroom_mark_variant_a_path ?classroom_resource)
        (classroom_mark_variant_b_path ?classroom_resource)
        (not
          (offering_ready_for_final_activation ?course_offering)
        )
      )
    :effect
      (and
        (offering_ready_for_final_activation ?course_offering)
        (offering_packaging_authorized ?course_offering)
      )
  )
  (:action trigger_offering_finalization
    :parameters (?course_offering - course_offering)
    :precondition
      (and
        (offering_ready_for_final_activation ?course_offering)
        (not
          (offering_packaging_authorized ?course_offering)
        )
        (not
          (offering_finalization_committed ?course_offering)
        )
      )
    :effect
      (and
        (offering_finalization_committed ?course_offering)
        (ready_for_enrollment_confirmation_for_subject ?course_offering)
      )
  )
  (:action schedule_offering_for_academic_term
    :parameters (?course_offering - course_offering ?academic_term - academic_term)
    :precondition
      (and
        (offering_ready_for_final_activation ?course_offering)
        (offering_packaging_authorized ?course_offering)
        (academic_term_available ?academic_term)
      )
    :effect
      (and
        (offering_scheduled_for_term ?course_offering ?academic_term)
        (not
          (academic_term_available ?academic_term)
        )
      )
  )
  (:action complete_instructor_assignment_for_offering
    :parameters (?course_offering - course_offering ?section_variant_a - section_variant_a ?section_variant_b - section_variant_b ?requested_timeslot_preference - requested_timeslot_preference ?academic_term - academic_term)
    :precondition
      (and
        (offering_ready_for_final_activation ?course_offering)
        (offering_packaging_authorized ?course_offering)
        (offering_scheduled_for_term ?course_offering ?academic_term)
        (offering_includes_variant_a ?course_offering ?section_variant_a)
        (offering_includes_variant_b ?course_offering ?section_variant_b)
        (section_variant_a_ready_for_room_assignment ?section_variant_a)
        (section_variant_b_ready_for_room_assignment ?section_variant_b)
        (tentative_timeslot_match_for_subject ?course_offering ?requested_timeslot_preference)
        (not
          (offering_instructor_assignment_completed ?course_offering)
        )
      )
    :effect (offering_instructor_assignment_completed ?course_offering)
  )
  (:action finalize_offering_activation
    :parameters (?course_offering - course_offering)
    :precondition
      (and
        (offering_ready_for_final_activation ?course_offering)
        (offering_instructor_assignment_completed ?course_offering)
        (not
          (offering_finalization_committed ?course_offering)
        )
      )
    :effect
      (and
        (offering_finalization_committed ?course_offering)
        (ready_for_enrollment_confirmation_for_subject ?course_offering)
      )
  )
  (:action endorse_offering_by_curriculum_representative
    :parameters (?course_offering - course_offering ?curriculum_representative - curriculum_representative ?requested_timeslot_preference - requested_timeslot_preference)
    :precondition
      (and
        (preliminary_approval_granted_for_subject ?course_offering)
        (tentative_timeslot_match_for_subject ?course_offering ?requested_timeslot_preference)
        (curriculum_representative_available ?curriculum_representative)
        (offering_assigned_curriculum_representative ?course_offering ?curriculum_representative)
        (not
          (offering_curriculum_representative_confirmed ?course_offering)
        )
      )
    :effect
      (and
        (offering_curriculum_representative_confirmed ?course_offering)
        (not
          (curriculum_representative_available ?curriculum_representative)
        )
      )
  )
  (:action record_department_endorsement
    :parameters (?course_offering - course_offering ?department_approver - department_approver)
    :precondition
      (and
        (offering_curriculum_representative_confirmed ?course_offering)
        (assigned_department_approver_for_subject ?course_offering ?department_approver)
        (not
          (offering_department_endorsed ?course_offering)
        )
      )
    :effect (offering_department_endorsed ?course_offering)
  )
  (:action record_accreditation_endorsement
    :parameters (?course_offering - course_offering ?accreditation_officer - accreditation_officer)
    :precondition
      (and
        (offering_department_endorsed ?course_offering)
        (offering_assigned_accreditation_officer ?course_offering ?accreditation_officer)
        (not
          (offering_accreditation_endorsed ?course_offering)
        )
      )
    :effect (offering_accreditation_endorsed ?course_offering)
  )
  (:action finalize_offering_activation_after_accreditation
    :parameters (?course_offering - course_offering)
    :precondition
      (and
        (offering_accreditation_endorsed ?course_offering)
        (not
          (offering_finalization_committed ?course_offering)
        )
      )
    :effect
      (and
        (offering_finalization_committed ?course_offering)
        (ready_for_enrollment_confirmation_for_subject ?course_offering)
      )
  )
  (:action confirm_variant_a_ready_for_finalization
    :parameters (?section_variant_a - section_variant_a ?classroom_resource - classroom_resource)
    :precondition
      (and
        (section_variant_a_has_local_claim ?section_variant_a)
        (section_variant_a_ready_for_room_assignment ?section_variant_a)
        (classroom_resource_reserved ?classroom_resource)
        (classroom_locked ?classroom_resource)
        (not
          (ready_for_enrollment_confirmation_for_subject ?section_variant_a)
        )
      )
    :effect (ready_for_enrollment_confirmation_for_subject ?section_variant_a)
  )
  (:action confirm_variant_b_ready_for_finalization
    :parameters (?section_variant_b - section_variant_b ?classroom_resource - classroom_resource)
    :precondition
      (and
        (section_variant_b_has_local_claim ?section_variant_b)
        (section_variant_b_ready_for_room_assignment ?section_variant_b)
        (classroom_resource_reserved ?classroom_resource)
        (classroom_locked ?classroom_resource)
        (not
          (ready_for_enrollment_confirmation_for_subject ?section_variant_b)
        )
      )
    :effect (ready_for_enrollment_confirmation_for_subject ?section_variant_b)
  )
  (:action confirm_enrollment_against_student_record
    :parameters (?registration_request - registration_request ?student_record - student_record ?requested_timeslot_preference - requested_timeslot_preference)
    :precondition
      (and
        (ready_for_enrollment_confirmation_for_subject ?registration_request)
        (tentative_timeslot_match_for_subject ?registration_request ?requested_timeslot_preference)
        (student_record_available ?student_record)
        (not
          (enrollment_confirmed_for_subject ?registration_request)
        )
      )
    :effect
      (and
        (enrollment_confirmed_for_subject ?registration_request)
        (bound_to_student_record ?registration_request ?student_record)
        (not
          (student_record_available ?student_record)
        )
      )
  )
  (:action finalize_section_variant_a_and_release_officer
    :parameters (?section_variant_a - section_variant_a ?enrollment_officer - enrollment_officer ?student_record - student_record)
    :precondition
      (and
        (enrollment_confirmed_for_subject ?section_variant_a)
        (assigned_enrollment_officer_for_subject ?section_variant_a ?enrollment_officer)
        (bound_to_student_record ?section_variant_a ?student_record)
        (not
          (finalized_for_subject ?section_variant_a)
        )
      )
    :effect
      (and
        (finalized_for_subject ?section_variant_a)
        (enrollment_officer_available ?enrollment_officer)
        (student_record_available ?student_record)
      )
  )
  (:action finalize_section_variant_b_and_release_officer
    :parameters (?section_variant_b - section_variant_b ?enrollment_officer - enrollment_officer ?student_record - student_record)
    :precondition
      (and
        (enrollment_confirmed_for_subject ?section_variant_b)
        (assigned_enrollment_officer_for_subject ?section_variant_b ?enrollment_officer)
        (bound_to_student_record ?section_variant_b ?student_record)
        (not
          (finalized_for_subject ?section_variant_b)
        )
      )
    :effect
      (and
        (finalized_for_subject ?section_variant_b)
        (enrollment_officer_available ?enrollment_officer)
        (student_record_available ?student_record)
      )
  )
  (:action finalize_offering_and_release_officer
    :parameters (?course_offering - course_offering ?enrollment_officer - enrollment_officer ?student_record - student_record)
    :precondition
      (and
        (enrollment_confirmed_for_subject ?course_offering)
        (assigned_enrollment_officer_for_subject ?course_offering ?enrollment_officer)
        (bound_to_student_record ?course_offering ?student_record)
        (not
          (finalized_for_subject ?course_offering)
        )
      )
    :effect
      (and
        (finalized_for_subject ?course_offering)
        (enrollment_officer_available ?enrollment_officer)
        (student_record_available ?student_record)
      )
  )
)

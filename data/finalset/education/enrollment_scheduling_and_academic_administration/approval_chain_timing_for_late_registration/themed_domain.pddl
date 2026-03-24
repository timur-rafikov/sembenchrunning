(define (domain approval_chain_timing_for_late_registration)
  (:requirements :strips :typing :negative-preconditions)
  (:types administrative_entity - object supporting_resource - object scheduling_entity - object request_category - object approvable_entity - request_category approver_unit - administrative_entity course_section - administrative_entity staff_member - administrative_entity policy_exception - administrative_entity authorization_package - administrative_entity timing_marker - administrative_entity instructor_approval_token - administrative_entity dean_approval_token - administrative_entity administrative_document - supporting_resource resource_token - supporting_resource departmental_override - supporting_resource timetable_slot_a - scheduling_entity timetable_slot_b - scheduling_entity schedule_candidate - scheduling_entity student_category - approvable_entity offering_category - approvable_entity student_undergraduate - student_category student_graduate - student_category course_offering - offering_category)
  (:predicates
    (approval_subject_submitted ?late_registration_request - approvable_entity)
    (approval_subject_section_confirmed ?late_registration_request - approvable_entity)
    (approver_allocated_for_request ?late_registration_request - approvable_entity)
    (enrollment_confirmed ?late_registration_request - approvable_entity)
    (final_enrollment_flag ?late_registration_request - approvable_entity)
    (approval_subject_authorized ?late_registration_request - approvable_entity)
    (approver_available ?approver_unit - approver_unit)
    (assigned_approver ?late_registration_request - approvable_entity ?approver_unit - approver_unit)
    (section_available ?course_section - course_section)
    (proposed_section ?late_registration_request - approvable_entity ?course_section - course_section)
    (staff_available ?staff_member - staff_member)
    (assigned_staff_for_request ?late_registration_request - approvable_entity ?staff_member - staff_member)
    (document_available ?administrative_document - administrative_document)
    (student_undergrad_document_attached ?student_undergraduate - student_undergraduate ?administrative_document - administrative_document)
    (student_graduate_document_attached ?student_graduate - student_graduate ?administrative_document - administrative_document)
    (student_slot_a_candidate ?student_undergraduate - student_undergraduate ?timetable_slot_a - timetable_slot_a)
    (slot_a_locked ?timetable_slot_a - timetable_slot_a)
    (slot_a_reserved ?timetable_slot_a - timetable_slot_a)
    (student_undergrad_reservation_confirmed ?student_undergraduate - student_undergraduate)
    (student_slot_b_candidate ?student_graduate - student_graduate ?timetable_slot_b - timetable_slot_b)
    (slot_b_locked ?timetable_slot_b - timetable_slot_b)
    (slot_b_reserved ?timetable_slot_b - timetable_slot_b)
    (student_graduate_reservation_confirmed ?student_graduate - student_graduate)
    (schedule_candidate_available ?schedule_candidate - schedule_candidate)
    (schedule_candidate_selected ?schedule_candidate - schedule_candidate)
    (candidate_slot_a_link ?schedule_candidate - schedule_candidate ?timetable_slot_a - timetable_slot_a)
    (candidate_slot_b_link ?schedule_candidate - schedule_candidate ?timetable_slot_b - timetable_slot_b)
    (candidate_requires_instructor_approval ?schedule_candidate - schedule_candidate)
    (candidate_requires_dean_approval ?schedule_candidate - schedule_candidate)
    (candidate_finalized ?schedule_candidate - schedule_candidate)
    (offering_supports_undergrad ?course_offering - course_offering ?student_undergraduate - student_undergraduate)
    (offering_supports_graduate ?course_offering - course_offering ?student_graduate - student_graduate)
    (offering_has_schedule_candidate ?course_offering - course_offering ?schedule_candidate - schedule_candidate)
    (resource_token_available ?resource_token - resource_token)
    (offering_has_resource_token ?course_offering - course_offering ?resource_token - resource_token)
    (resource_token_attached ?resource_token - resource_token)
    (resource_token_linked_to_candidate ?resource_token - resource_token ?schedule_candidate - schedule_candidate)
    (offering_packet_initialized ?course_offering - course_offering)
    (instructor_approval_recorded ?course_offering - course_offering)
    (offering_ready_for_final_authorization ?course_offering - course_offering)
    (offering_has_policy_exception ?course_offering - course_offering)
    (offering_policy_exception_confirmed ?course_offering - course_offering)
    (offering_has_authorization_package ?course_offering - course_offering)
    (offering_authorization_executed ?course_offering - course_offering)
    (departmental_override_available ?departmental_override - departmental_override)
    (offering_has_dept_override ?course_offering - course_offering ?departmental_override - departmental_override)
    (offering_dept_override_applied ?course_offering - course_offering)
    (dean_approval_requested ?course_offering - course_offering)
    (dean_approval_recorded ?course_offering - course_offering)
    (policy_exception_available ?policy_exception - policy_exception)
    (offering_policy_exception_link ?course_offering - course_offering ?policy_exception - policy_exception)
    (authorization_package_available ?authorization_package - authorization_package)
    (offering_attached_authorization_package ?course_offering - course_offering ?authorization_package - authorization_package)
    (instructor_approval_token_available ?instructor_approval_token - instructor_approval_token)
    (offering_instructor_approval_link ?course_offering - course_offering ?instructor_approval_token - instructor_approval_token)
    (dean_approval_token_available ?dean_approval_token - dean_approval_token)
    (offering_dean_approval_link ?course_offering - course_offering ?dean_approval_token - dean_approval_token)
    (timing_marker_available ?timing_marker - timing_marker)
    (approval_subject_timing_marker_link ?late_registration_request - approvable_entity ?timing_marker - timing_marker)
    (student_undergrad_ready ?student_undergraduate - student_undergraduate)
    (student_graduate_ready ?student_graduate - student_graduate)
    (offering_final_authorized_flag ?course_offering - course_offering)
  )
  (:action submit_late_registration_request
    :parameters (?late_registration_request - approvable_entity)
    :precondition
      (and
        (not
          (approval_subject_submitted ?late_registration_request)
        )
        (not
          (enrollment_confirmed ?late_registration_request)
        )
      )
    :effect (approval_subject_submitted ?late_registration_request)
  )
  (:action assign_approver_unit_to_request
    :parameters (?late_registration_request - approvable_entity ?approver_unit - approver_unit)
    :precondition
      (and
        (approval_subject_submitted ?late_registration_request)
        (not
          (approver_allocated_for_request ?late_registration_request)
        )
        (approver_available ?approver_unit)
      )
    :effect
      (and
        (approver_allocated_for_request ?late_registration_request)
        (assigned_approver ?late_registration_request ?approver_unit)
        (not
          (approver_available ?approver_unit)
        )
      )
  )
  (:action propose_course_section_for_request
    :parameters (?late_registration_request - approvable_entity ?course_section - course_section)
    :precondition
      (and
        (approval_subject_submitted ?late_registration_request)
        (approver_allocated_for_request ?late_registration_request)
        (section_available ?course_section)
      )
    :effect
      (and
        (proposed_section ?late_registration_request ?course_section)
        (not
          (section_available ?course_section)
        )
      )
  )
  (:action confirm_section_assignment
    :parameters (?late_registration_request - approvable_entity ?course_section - course_section)
    :precondition
      (and
        (approval_subject_submitted ?late_registration_request)
        (approver_allocated_for_request ?late_registration_request)
        (proposed_section ?late_registration_request ?course_section)
        (not
          (approval_subject_section_confirmed ?late_registration_request)
        )
      )
    :effect (approval_subject_section_confirmed ?late_registration_request)
  )
  (:action release_section_proposal
    :parameters (?late_registration_request - approvable_entity ?course_section - course_section)
    :precondition
      (and
        (proposed_section ?late_registration_request ?course_section)
      )
    :effect
      (and
        (section_available ?course_section)
        (not
          (proposed_section ?late_registration_request ?course_section)
        )
      )
  )
  (:action allocate_staff_to_request
    :parameters (?late_registration_request - approvable_entity ?staff_member - staff_member)
    :precondition
      (and
        (approval_subject_section_confirmed ?late_registration_request)
        (staff_available ?staff_member)
      )
    :effect
      (and
        (assigned_staff_for_request ?late_registration_request ?staff_member)
        (not
          (staff_available ?staff_member)
        )
      )
  )
  (:action release_staff_from_request
    :parameters (?late_registration_request - approvable_entity ?staff_member - staff_member)
    :precondition
      (and
        (assigned_staff_for_request ?late_registration_request ?staff_member)
      )
    :effect
      (and
        (staff_available ?staff_member)
        (not
          (assigned_staff_for_request ?late_registration_request ?staff_member)
        )
      )
  )
  (:action attach_instructor_approval_token
    :parameters (?course_offering - course_offering ?instructor_approval_token - instructor_approval_token)
    :precondition
      (and
        (approval_subject_section_confirmed ?course_offering)
        (instructor_approval_token_available ?instructor_approval_token)
      )
    :effect
      (and
        (offering_instructor_approval_link ?course_offering ?instructor_approval_token)
        (not
          (instructor_approval_token_available ?instructor_approval_token)
        )
      )
  )
  (:action detach_instructor_approval_token
    :parameters (?course_offering - course_offering ?instructor_approval_token - instructor_approval_token)
    :precondition
      (and
        (offering_instructor_approval_link ?course_offering ?instructor_approval_token)
      )
    :effect
      (and
        (instructor_approval_token_available ?instructor_approval_token)
        (not
          (offering_instructor_approval_link ?course_offering ?instructor_approval_token)
        )
      )
  )
  (:action attach_dean_approval_token
    :parameters (?course_offering - course_offering ?dean_approval_token - dean_approval_token)
    :precondition
      (and
        (approval_subject_section_confirmed ?course_offering)
        (dean_approval_token_available ?dean_approval_token)
      )
    :effect
      (and
        (offering_dean_approval_link ?course_offering ?dean_approval_token)
        (not
          (dean_approval_token_available ?dean_approval_token)
        )
      )
  )
  (:action detach_dean_approval_token
    :parameters (?course_offering - course_offering ?dean_approval_token - dean_approval_token)
    :precondition
      (and
        (offering_dean_approval_link ?course_offering ?dean_approval_token)
      )
    :effect
      (and
        (dean_approval_token_available ?dean_approval_token)
        (not
          (offering_dean_approval_link ?course_offering ?dean_approval_token)
        )
      )
  )
  (:action lock_slot_a_for_student
    :parameters (?student_undergraduate - student_undergraduate ?timetable_slot_a - timetable_slot_a ?course_section - course_section)
    :precondition
      (and
        (approval_subject_section_confirmed ?student_undergraduate)
        (proposed_section ?student_undergraduate ?course_section)
        (student_slot_a_candidate ?student_undergraduate ?timetable_slot_a)
        (not
          (slot_a_locked ?timetable_slot_a)
        )
        (not
          (slot_a_reserved ?timetable_slot_a)
        )
      )
    :effect (slot_a_locked ?timetable_slot_a)
  )
  (:action confirm_undergrad_reservation_after_staff
    :parameters (?student_undergraduate - student_undergraduate ?timetable_slot_a - timetable_slot_a ?staff_member - staff_member)
    :precondition
      (and
        (approval_subject_section_confirmed ?student_undergraduate)
        (assigned_staff_for_request ?student_undergraduate ?staff_member)
        (student_slot_a_candidate ?student_undergraduate ?timetable_slot_a)
        (slot_a_locked ?timetable_slot_a)
        (not
          (student_undergrad_ready ?student_undergraduate)
        )
      )
    :effect
      (and
        (student_undergrad_ready ?student_undergraduate)
        (student_undergrad_reservation_confirmed ?student_undergraduate)
      )
  )
  (:action reserve_slot_a_with_document
    :parameters (?student_undergraduate - student_undergraduate ?timetable_slot_a - timetable_slot_a ?administrative_document - administrative_document)
    :precondition
      (and
        (approval_subject_section_confirmed ?student_undergraduate)
        (student_slot_a_candidate ?student_undergraduate ?timetable_slot_a)
        (document_available ?administrative_document)
        (not
          (student_undergrad_ready ?student_undergraduate)
        )
      )
    :effect
      (and
        (slot_a_reserved ?timetable_slot_a)
        (student_undergrad_ready ?student_undergraduate)
        (student_undergrad_document_attached ?student_undergraduate ?administrative_document)
        (not
          (document_available ?administrative_document)
        )
      )
  )
  (:action finalize_slot_a_reservation
    :parameters (?student_undergraduate - student_undergraduate ?timetable_slot_a - timetable_slot_a ?course_section - course_section ?administrative_document - administrative_document)
    :precondition
      (and
        (approval_subject_section_confirmed ?student_undergraduate)
        (proposed_section ?student_undergraduate ?course_section)
        (student_slot_a_candidate ?student_undergraduate ?timetable_slot_a)
        (slot_a_reserved ?timetable_slot_a)
        (student_undergrad_document_attached ?student_undergraduate ?administrative_document)
        (not
          (student_undergrad_reservation_confirmed ?student_undergraduate)
        )
      )
    :effect
      (and
        (slot_a_locked ?timetable_slot_a)
        (student_undergrad_reservation_confirmed ?student_undergraduate)
        (document_available ?administrative_document)
        (not
          (student_undergrad_document_attached ?student_undergraduate ?administrative_document)
        )
      )
  )
  (:action lock_slot_b_for_student
    :parameters (?student_graduate - student_graduate ?timetable_slot_b - timetable_slot_b ?course_section - course_section)
    :precondition
      (and
        (approval_subject_section_confirmed ?student_graduate)
        (proposed_section ?student_graduate ?course_section)
        (student_slot_b_candidate ?student_graduate ?timetable_slot_b)
        (not
          (slot_b_locked ?timetable_slot_b)
        )
        (not
          (slot_b_reserved ?timetable_slot_b)
        )
      )
    :effect (slot_b_locked ?timetable_slot_b)
  )
  (:action confirm_graduate_reservation_after_staff
    :parameters (?student_graduate - student_graduate ?timetable_slot_b - timetable_slot_b ?staff_member - staff_member)
    :precondition
      (and
        (approval_subject_section_confirmed ?student_graduate)
        (assigned_staff_for_request ?student_graduate ?staff_member)
        (student_slot_b_candidate ?student_graduate ?timetable_slot_b)
        (slot_b_locked ?timetable_slot_b)
        (not
          (student_graduate_ready ?student_graduate)
        )
      )
    :effect
      (and
        (student_graduate_ready ?student_graduate)
        (student_graduate_reservation_confirmed ?student_graduate)
      )
  )
  (:action reserve_slot_b_with_document
    :parameters (?student_graduate - student_graduate ?timetable_slot_b - timetable_slot_b ?administrative_document - administrative_document)
    :precondition
      (and
        (approval_subject_section_confirmed ?student_graduate)
        (student_slot_b_candidate ?student_graduate ?timetable_slot_b)
        (document_available ?administrative_document)
        (not
          (student_graduate_ready ?student_graduate)
        )
      )
    :effect
      (and
        (slot_b_reserved ?timetable_slot_b)
        (student_graduate_ready ?student_graduate)
        (student_graduate_document_attached ?student_graduate ?administrative_document)
        (not
          (document_available ?administrative_document)
        )
      )
  )
  (:action finalize_slot_b_reservation
    :parameters (?student_graduate - student_graduate ?timetable_slot_b - timetable_slot_b ?course_section - course_section ?administrative_document - administrative_document)
    :precondition
      (and
        (approval_subject_section_confirmed ?student_graduate)
        (proposed_section ?student_graduate ?course_section)
        (student_slot_b_candidate ?student_graduate ?timetable_slot_b)
        (slot_b_reserved ?timetable_slot_b)
        (student_graduate_document_attached ?student_graduate ?administrative_document)
        (not
          (student_graduate_reservation_confirmed ?student_graduate)
        )
      )
    :effect
      (and
        (slot_b_locked ?timetable_slot_b)
        (student_graduate_reservation_confirmed ?student_graduate)
        (document_available ?administrative_document)
        (not
          (student_graduate_document_attached ?student_graduate ?administrative_document)
        )
      )
  )
  (:action create_schedule_candidate
    :parameters (?student_undergraduate - student_undergraduate ?student_graduate - student_graduate ?timetable_slot_a - timetable_slot_a ?timetable_slot_b - timetable_slot_b ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (student_undergrad_ready ?student_undergraduate)
        (student_graduate_ready ?student_graduate)
        (student_slot_a_candidate ?student_undergraduate ?timetable_slot_a)
        (student_slot_b_candidate ?student_graduate ?timetable_slot_b)
        (slot_a_locked ?timetable_slot_a)
        (slot_b_locked ?timetable_slot_b)
        (student_undergrad_reservation_confirmed ?student_undergraduate)
        (student_graduate_reservation_confirmed ?student_graduate)
        (schedule_candidate_available ?schedule_candidate)
      )
    :effect
      (and
        (schedule_candidate_selected ?schedule_candidate)
        (candidate_slot_a_link ?schedule_candidate ?timetable_slot_a)
        (candidate_slot_b_link ?schedule_candidate ?timetable_slot_b)
        (not
          (schedule_candidate_available ?schedule_candidate)
        )
      )
  )
  (:action create_schedule_candidate_instructor_required
    :parameters (?student_undergraduate - student_undergraduate ?student_graduate - student_graduate ?timetable_slot_a - timetable_slot_a ?timetable_slot_b - timetable_slot_b ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (student_undergrad_ready ?student_undergraduate)
        (student_graduate_ready ?student_graduate)
        (student_slot_a_candidate ?student_undergraduate ?timetable_slot_a)
        (student_slot_b_candidate ?student_graduate ?timetable_slot_b)
        (slot_a_reserved ?timetable_slot_a)
        (slot_b_locked ?timetable_slot_b)
        (not
          (student_undergrad_reservation_confirmed ?student_undergraduate)
        )
        (student_graduate_reservation_confirmed ?student_graduate)
        (schedule_candidate_available ?schedule_candidate)
      )
    :effect
      (and
        (schedule_candidate_selected ?schedule_candidate)
        (candidate_slot_a_link ?schedule_candidate ?timetable_slot_a)
        (candidate_slot_b_link ?schedule_candidate ?timetable_slot_b)
        (candidate_requires_instructor_approval ?schedule_candidate)
        (not
          (schedule_candidate_available ?schedule_candidate)
        )
      )
  )
  (:action create_schedule_candidate_dean_required
    :parameters (?student_undergraduate - student_undergraduate ?student_graduate - student_graduate ?timetable_slot_a - timetable_slot_a ?timetable_slot_b - timetable_slot_b ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (student_undergrad_ready ?student_undergraduate)
        (student_graduate_ready ?student_graduate)
        (student_slot_a_candidate ?student_undergraduate ?timetable_slot_a)
        (student_slot_b_candidate ?student_graduate ?timetable_slot_b)
        (slot_a_locked ?timetable_slot_a)
        (slot_b_reserved ?timetable_slot_b)
        (student_undergrad_reservation_confirmed ?student_undergraduate)
        (not
          (student_graduate_reservation_confirmed ?student_graduate)
        )
        (schedule_candidate_available ?schedule_candidate)
      )
    :effect
      (and
        (schedule_candidate_selected ?schedule_candidate)
        (candidate_slot_a_link ?schedule_candidate ?timetable_slot_a)
        (candidate_slot_b_link ?schedule_candidate ?timetable_slot_b)
        (candidate_requires_dean_approval ?schedule_candidate)
        (not
          (schedule_candidate_available ?schedule_candidate)
        )
      )
  )
  (:action create_schedule_candidate_full_requirements
    :parameters (?student_undergraduate - student_undergraduate ?student_graduate - student_graduate ?timetable_slot_a - timetable_slot_a ?timetable_slot_b - timetable_slot_b ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (student_undergrad_ready ?student_undergraduate)
        (student_graduate_ready ?student_graduate)
        (student_slot_a_candidate ?student_undergraduate ?timetable_slot_a)
        (student_slot_b_candidate ?student_graduate ?timetable_slot_b)
        (slot_a_reserved ?timetable_slot_a)
        (slot_b_reserved ?timetable_slot_b)
        (not
          (student_undergrad_reservation_confirmed ?student_undergraduate)
        )
        (not
          (student_graduate_reservation_confirmed ?student_graduate)
        )
        (schedule_candidate_available ?schedule_candidate)
      )
    :effect
      (and
        (schedule_candidate_selected ?schedule_candidate)
        (candidate_slot_a_link ?schedule_candidate ?timetable_slot_a)
        (candidate_slot_b_link ?schedule_candidate ?timetable_slot_b)
        (candidate_requires_instructor_approval ?schedule_candidate)
        (candidate_requires_dean_approval ?schedule_candidate)
        (not
          (schedule_candidate_available ?schedule_candidate)
        )
      )
  )
  (:action finalize_schedule_candidate
    :parameters (?schedule_candidate - schedule_candidate ?student_undergraduate - student_undergraduate ?course_section - course_section)
    :precondition
      (and
        (schedule_candidate_selected ?schedule_candidate)
        (student_undergrad_ready ?student_undergraduate)
        (proposed_section ?student_undergraduate ?course_section)
        (not
          (candidate_finalized ?schedule_candidate)
        )
      )
    :effect (candidate_finalized ?schedule_candidate)
  )
  (:action attach_resource_to_offering
    :parameters (?course_offering - course_offering ?resource_token - resource_token ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (approval_subject_section_confirmed ?course_offering)
        (offering_has_schedule_candidate ?course_offering ?schedule_candidate)
        (offering_has_resource_token ?course_offering ?resource_token)
        (resource_token_available ?resource_token)
        (schedule_candidate_selected ?schedule_candidate)
        (candidate_finalized ?schedule_candidate)
        (not
          (resource_token_attached ?resource_token)
        )
      )
    :effect
      (and
        (resource_token_attached ?resource_token)
        (resource_token_linked_to_candidate ?resource_token ?schedule_candidate)
        (not
          (resource_token_available ?resource_token)
        )
      )
  )
  (:action prepare_offering_for_instructor_review
    :parameters (?course_offering - course_offering ?resource_token - resource_token ?schedule_candidate - schedule_candidate ?course_section - course_section)
    :precondition
      (and
        (approval_subject_section_confirmed ?course_offering)
        (offering_has_resource_token ?course_offering ?resource_token)
        (resource_token_attached ?resource_token)
        (resource_token_linked_to_candidate ?resource_token ?schedule_candidate)
        (proposed_section ?course_offering ?course_section)
        (not
          (candidate_requires_instructor_approval ?schedule_candidate)
        )
        (not
          (offering_packet_initialized ?course_offering)
        )
      )
    :effect (offering_packet_initialized ?course_offering)
  )
  (:action attach_policy_exception
    :parameters (?course_offering - course_offering ?policy_exception - policy_exception)
    :precondition
      (and
        (approval_subject_section_confirmed ?course_offering)
        (policy_exception_available ?policy_exception)
        (not
          (offering_has_policy_exception ?course_offering)
        )
      )
    :effect
      (and
        (offering_has_policy_exception ?course_offering)
        (offering_policy_exception_link ?course_offering ?policy_exception)
        (not
          (policy_exception_available ?policy_exception)
        )
      )
  )
  (:action apply_policy_exception_and_prepare
    :parameters (?course_offering - course_offering ?resource_token - resource_token ?schedule_candidate - schedule_candidate ?course_section - course_section ?policy_exception - policy_exception)
    :precondition
      (and
        (approval_subject_section_confirmed ?course_offering)
        (offering_has_resource_token ?course_offering ?resource_token)
        (resource_token_attached ?resource_token)
        (resource_token_linked_to_candidate ?resource_token ?schedule_candidate)
        (proposed_section ?course_offering ?course_section)
        (candidate_requires_instructor_approval ?schedule_candidate)
        (offering_has_policy_exception ?course_offering)
        (offering_policy_exception_link ?course_offering ?policy_exception)
        (not
          (offering_packet_initialized ?course_offering)
        )
      )
    :effect
      (and
        (offering_packet_initialized ?course_offering)
        (offering_policy_exception_confirmed ?course_offering)
      )
  )
  (:action record_instructor_approval
    :parameters (?course_offering - course_offering ?instructor_approval_token - instructor_approval_token ?staff_member - staff_member ?resource_token - resource_token ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (offering_packet_initialized ?course_offering)
        (offering_instructor_approval_link ?course_offering ?instructor_approval_token)
        (assigned_staff_for_request ?course_offering ?staff_member)
        (offering_has_resource_token ?course_offering ?resource_token)
        (resource_token_linked_to_candidate ?resource_token ?schedule_candidate)
        (not
          (candidate_requires_dean_approval ?schedule_candidate)
        )
        (not
          (instructor_approval_recorded ?course_offering)
        )
      )
    :effect (instructor_approval_recorded ?course_offering)
  )
  (:action record_instructor_approval_confirm
    :parameters (?course_offering - course_offering ?instructor_approval_token - instructor_approval_token ?staff_member - staff_member ?resource_token - resource_token ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (offering_packet_initialized ?course_offering)
        (offering_instructor_approval_link ?course_offering ?instructor_approval_token)
        (assigned_staff_for_request ?course_offering ?staff_member)
        (offering_has_resource_token ?course_offering ?resource_token)
        (resource_token_linked_to_candidate ?resource_token ?schedule_candidate)
        (candidate_requires_dean_approval ?schedule_candidate)
        (not
          (instructor_approval_recorded ?course_offering)
        )
      )
    :effect (instructor_approval_recorded ?course_offering)
  )
  (:action record_dean_approval
    :parameters (?course_offering - course_offering ?dean_approval_token - dean_approval_token ?resource_token - resource_token ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (instructor_approval_recorded ?course_offering)
        (offering_dean_approval_link ?course_offering ?dean_approval_token)
        (offering_has_resource_token ?course_offering ?resource_token)
        (resource_token_linked_to_candidate ?resource_token ?schedule_candidate)
        (not
          (candidate_requires_instructor_approval ?schedule_candidate)
        )
        (not
          (candidate_requires_dean_approval ?schedule_candidate)
        )
        (not
          (offering_ready_for_final_authorization ?course_offering)
        )
      )
    :effect (offering_ready_for_final_authorization ?course_offering)
  )
  (:action record_dean_approval_with_package_marker
    :parameters (?course_offering - course_offering ?dean_approval_token - dean_approval_token ?resource_token - resource_token ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (instructor_approval_recorded ?course_offering)
        (offering_dean_approval_link ?course_offering ?dean_approval_token)
        (offering_has_resource_token ?course_offering ?resource_token)
        (resource_token_linked_to_candidate ?resource_token ?schedule_candidate)
        (candidate_requires_instructor_approval ?schedule_candidate)
        (not
          (candidate_requires_dean_approval ?schedule_candidate)
        )
        (not
          (offering_ready_for_final_authorization ?course_offering)
        )
      )
    :effect
      (and
        (offering_ready_for_final_authorization ?course_offering)
        (offering_has_authorization_package ?course_offering)
      )
  )
  (:action record_dean_approval_set_package_marker
    :parameters (?course_offering - course_offering ?dean_approval_token - dean_approval_token ?resource_token - resource_token ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (instructor_approval_recorded ?course_offering)
        (offering_dean_approval_link ?course_offering ?dean_approval_token)
        (offering_has_resource_token ?course_offering ?resource_token)
        (resource_token_linked_to_candidate ?resource_token ?schedule_candidate)
        (not
          (candidate_requires_instructor_approval ?schedule_candidate)
        )
        (candidate_requires_dean_approval ?schedule_candidate)
        (not
          (offering_ready_for_final_authorization ?course_offering)
        )
      )
    :effect
      (and
        (offering_ready_for_final_authorization ?course_offering)
        (offering_has_authorization_package ?course_offering)
      )
  )
  (:action record_dean_approval_confirm_package
    :parameters (?course_offering - course_offering ?dean_approval_token - dean_approval_token ?resource_token - resource_token ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (instructor_approval_recorded ?course_offering)
        (offering_dean_approval_link ?course_offering ?dean_approval_token)
        (offering_has_resource_token ?course_offering ?resource_token)
        (resource_token_linked_to_candidate ?resource_token ?schedule_candidate)
        (candidate_requires_instructor_approval ?schedule_candidate)
        (candidate_requires_dean_approval ?schedule_candidate)
        (not
          (offering_ready_for_final_authorization ?course_offering)
        )
      )
    :effect
      (and
        (offering_ready_for_final_authorization ?course_offering)
        (offering_has_authorization_package ?course_offering)
      )
  )
  (:action finalize_offering_authorization
    :parameters (?course_offering - course_offering)
    :precondition
      (and
        (offering_ready_for_final_authorization ?course_offering)
        (not
          (offering_has_authorization_package ?course_offering)
        )
        (not
          (offering_final_authorized_flag ?course_offering)
        )
      )
    :effect
      (and
        (offering_final_authorized_flag ?course_offering)
        (final_enrollment_flag ?course_offering)
      )
  )
  (:action attach_authorization_package_to_offering
    :parameters (?course_offering - course_offering ?authorization_package - authorization_package)
    :precondition
      (and
        (offering_ready_for_final_authorization ?course_offering)
        (offering_has_authorization_package ?course_offering)
        (authorization_package_available ?authorization_package)
      )
    :effect
      (and
        (offering_attached_authorization_package ?course_offering ?authorization_package)
        (not
          (authorization_package_available ?authorization_package)
        )
      )
  )
  (:action authorize_offering_for_enrollment
    :parameters (?course_offering - course_offering ?student_undergraduate - student_undergraduate ?student_graduate - student_graduate ?course_section - course_section ?authorization_package - authorization_package)
    :precondition
      (and
        (offering_ready_for_final_authorization ?course_offering)
        (offering_has_authorization_package ?course_offering)
        (offering_attached_authorization_package ?course_offering ?authorization_package)
        (offering_supports_undergrad ?course_offering ?student_undergraduate)
        (offering_supports_graduate ?course_offering ?student_graduate)
        (student_undergrad_reservation_confirmed ?student_undergraduate)
        (student_graduate_reservation_confirmed ?student_graduate)
        (proposed_section ?course_offering ?course_section)
        (not
          (offering_authorization_executed ?course_offering)
        )
      )
    :effect (offering_authorization_executed ?course_offering)
  )
  (:action record_final_authorization
    :parameters (?course_offering - course_offering)
    :precondition
      (and
        (offering_ready_for_final_authorization ?course_offering)
        (offering_authorization_executed ?course_offering)
        (not
          (offering_final_authorized_flag ?course_offering)
        )
      )
    :effect
      (and
        (offering_final_authorized_flag ?course_offering)
        (final_enrollment_flag ?course_offering)
      )
  )
  (:action apply_departmental_override
    :parameters (?course_offering - course_offering ?departmental_override - departmental_override ?course_section - course_section)
    :precondition
      (and
        (approval_subject_section_confirmed ?course_offering)
        (proposed_section ?course_offering ?course_section)
        (departmental_override_available ?departmental_override)
        (offering_has_dept_override ?course_offering ?departmental_override)
        (not
          (offering_dept_override_applied ?course_offering)
        )
      )
    :effect
      (and
        (offering_dept_override_applied ?course_offering)
        (not
          (departmental_override_available ?departmental_override)
        )
      )
  )
  (:action request_dean_approval
    :parameters (?course_offering - course_offering ?staff_member - staff_member)
    :precondition
      (and
        (offering_dept_override_applied ?course_offering)
        (assigned_staff_for_request ?course_offering ?staff_member)
        (not
          (dean_approval_requested ?course_offering)
        )
      )
    :effect (dean_approval_requested ?course_offering)
  )
  (:action record_dean_approval_received
    :parameters (?course_offering - course_offering ?dean_approval_token - dean_approval_token)
    :precondition
      (and
        (dean_approval_requested ?course_offering)
        (offering_dean_approval_link ?course_offering ?dean_approval_token)
        (not
          (dean_approval_recorded ?course_offering)
        )
      )
    :effect (dean_approval_recorded ?course_offering)
  )
  (:action finalize_dean_authorization
    :parameters (?course_offering - course_offering)
    :precondition
      (and
        (dean_approval_recorded ?course_offering)
        (not
          (offering_final_authorized_flag ?course_offering)
        )
      )
    :effect
      (and
        (offering_final_authorized_flag ?course_offering)
        (final_enrollment_flag ?course_offering)
      )
  )
  (:action confirm_enrollment_undergrad
    :parameters (?student_undergraduate - student_undergraduate ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (student_undergrad_ready ?student_undergraduate)
        (student_undergrad_reservation_confirmed ?student_undergraduate)
        (schedule_candidate_selected ?schedule_candidate)
        (candidate_finalized ?schedule_candidate)
        (not
          (final_enrollment_flag ?student_undergraduate)
        )
      )
    :effect (final_enrollment_flag ?student_undergraduate)
  )
  (:action confirm_enrollment_graduate
    :parameters (?student_graduate - student_graduate ?schedule_candidate - schedule_candidate)
    :precondition
      (and
        (student_graduate_ready ?student_graduate)
        (student_graduate_reservation_confirmed ?student_graduate)
        (schedule_candidate_selected ?schedule_candidate)
        (candidate_finalized ?schedule_candidate)
        (not
          (final_enrollment_flag ?student_graduate)
        )
      )
    :effect (final_enrollment_flag ?student_graduate)
  )
  (:action attach_timing_marker_to_request
    :parameters (?late_registration_request - approvable_entity ?timing_marker - timing_marker ?course_section - course_section)
    :precondition
      (and
        (final_enrollment_flag ?late_registration_request)
        (proposed_section ?late_registration_request ?course_section)
        (timing_marker_available ?timing_marker)
        (not
          (approval_subject_authorized ?late_registration_request)
        )
      )
    :effect
      (and
        (approval_subject_authorized ?late_registration_request)
        (approval_subject_timing_marker_link ?late_registration_request ?timing_marker)
        (not
          (timing_marker_available ?timing_marker)
        )
      )
  )
  (:action confirm_undergrad_enrollment_and_release_approver
    :parameters (?student_undergraduate - student_undergraduate ?approver_unit - approver_unit ?timing_marker - timing_marker)
    :precondition
      (and
        (approval_subject_authorized ?student_undergraduate)
        (assigned_approver ?student_undergraduate ?approver_unit)
        (approval_subject_timing_marker_link ?student_undergraduate ?timing_marker)
        (not
          (enrollment_confirmed ?student_undergraduate)
        )
      )
    :effect
      (and
        (enrollment_confirmed ?student_undergraduate)
        (approver_available ?approver_unit)
        (timing_marker_available ?timing_marker)
      )
  )
  (:action confirm_graduate_enrollment_and_release_approver
    :parameters (?student_graduate - student_graduate ?approver_unit - approver_unit ?timing_marker - timing_marker)
    :precondition
      (and
        (approval_subject_authorized ?student_graduate)
        (assigned_approver ?student_graduate ?approver_unit)
        (approval_subject_timing_marker_link ?student_graduate ?timing_marker)
        (not
          (enrollment_confirmed ?student_graduate)
        )
      )
    :effect
      (and
        (enrollment_confirmed ?student_graduate)
        (approver_available ?approver_unit)
        (timing_marker_available ?timing_marker)
      )
  )
  (:action confirm_offering_enrollment_and_release_approver
    :parameters (?course_offering - course_offering ?approver_unit - approver_unit ?timing_marker - timing_marker)
    :precondition
      (and
        (approval_subject_authorized ?course_offering)
        (assigned_approver ?course_offering ?approver_unit)
        (approval_subject_timing_marker_link ?course_offering ?timing_marker)
        (not
          (enrollment_confirmed ?course_offering)
        )
      )
    :effect
      (and
        (enrollment_confirmed ?course_offering)
        (approver_available ?approver_unit)
        (timing_marker_available ?timing_marker)
      )
  )
)

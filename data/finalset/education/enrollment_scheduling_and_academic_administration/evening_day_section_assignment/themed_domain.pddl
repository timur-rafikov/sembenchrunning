(define (domain evening_day_section_assignment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types administrative_entity - object resource_entity - object scheduling_entity - object registrable_entity - object registration_record - registrable_entity allocation_token - administrative_entity course - administrative_entity department_advisor - administrative_entity faculty_preference_form - administrative_entity instructor - administrative_entity authorization_document - administrative_entity teaching_qualification_record - administrative_entity regulatory_certificate - administrative_entity auxiliary_resource - resource_entity classroom - resource_entity departmental_clearance_resource - resource_entity evening_timeslot - scheduling_entity day_timeslot - scheduling_entity section_instance - scheduling_entity request_category - registration_record administrative_assignment - registration_record evening_section_request - request_category day_section_request - request_category academic_officer - administrative_assignment)
  (:predicates
    (registrable_entity_received ?registration_record - registration_record)
    (registrable_entity_prequalified ?registration_record - registration_record)
    (registrable_entity_token_reserved ?registration_record - registration_record)
    (registrable_entity_committed ?registration_record - registration_record)
    (registrable_entity_ready_for_finalization ?registration_record - registration_record)
    (registrable_entity_authorized ?registration_record - registration_record)
    (allocation_token_available ?allocation_token - allocation_token)
    (registrable_entity_has_allocation_token ?registration_record - registration_record ?allocation_token - allocation_token)
    (course_available ?course - course)
    (registrable_entity_selected_course ?registration_record - registration_record ?course - course)
    (advisor_available ?department_advisor - department_advisor)
    (registrable_entity_assigned_advisor ?registration_record - registration_record ?department_advisor - department_advisor)
    (auxiliary_resource_available ?auxiliary_resource - auxiliary_resource)
    (evening_request_has_auxiliary ?evening_section_request - evening_section_request ?auxiliary_resource - auxiliary_resource)
    (day_request_has_auxiliary ?day_section_request - day_section_request ?auxiliary_resource - auxiliary_resource)
    (evening_request_timeslot_match ?evening_section_request - evening_section_request ?evening_timeslot - evening_timeslot)
    (evening_timeslot_marked ?evening_timeslot - evening_timeslot)
    (evening_timeslot_auxiliary_reserved ?evening_timeslot - evening_timeslot)
    (evening_request_ready ?evening_section_request - evening_section_request)
    (day_request_timeslot_match ?day_section_request - day_section_request ?day_timeslot - day_timeslot)
    (day_timeslot_marked ?day_timeslot - day_timeslot)
    (day_timeslot_auxiliary_reserved ?day_timeslot - day_timeslot)
    (day_request_ready ?day_section_request - day_section_request)
    (section_instance_available ?section_instance - section_instance)
    (section_instance_initialized ?section_instance - section_instance)
    (section_instance_has_evening_timeslot ?section_instance - section_instance ?evening_timeslot - evening_timeslot)
    (section_instance_has_day_timeslot ?section_instance - section_instance ?day_timeslot - day_timeslot)
    (section_instance_requires_facility_check ?section_instance - section_instance)
    (section_instance_requires_additional_review ?section_instance - section_instance)
    (section_instance_room_eligibility_confirmed ?section_instance - section_instance)
    (academic_officer_assigned_to_evening_request ?academic_officer - academic_officer ?evening_section_request - evening_section_request)
    (academic_officer_assigned_to_day_request ?academic_officer - academic_officer ?day_section_request - day_section_request)
    (academic_officer_assigned_section_instance ?academic_officer - academic_officer ?section_instance - section_instance)
    (classroom_available ?classroom - classroom)
    (academic_officer_associated_classroom ?academic_officer - academic_officer ?classroom - classroom)
    (classroom_reserved ?classroom - classroom)
    (classroom_reserved_for_section ?classroom - classroom ?section_instance - section_instance)
    (academic_officer_instructor_binding_initiated ?academic_officer - academic_officer)
    (academic_officer_instructor_binding_confirmed ?academic_officer - academic_officer)
    (academic_officer_preference_consumed ?academic_officer - academic_officer)
    (academic_officer_pref_attached ?academic_officer - academic_officer)
    (academic_officer_pref_processed ?academic_officer - academic_officer)
    (academic_officer_instructor_assignment_ready ?academic_officer - academic_officer)
    (academic_officer_instructor_assignment_locked ?academic_officer - academic_officer)
    (departmental_clearance_available ?departmental_clearance_document - departmental_clearance_resource)
    (academic_officer_has_departmental_clearance ?academic_officer - academic_officer ?departmental_clearance_document - departmental_clearance_resource)
    (academic_officer_departmental_clearance_attached ?academic_officer - academic_officer)
    (academic_officer_departmental_clearance_verified ?academic_officer - academic_officer)
    (academic_officer_regulatory_certificate_verified ?academic_officer - academic_officer)
    (faculty_preference_form_available ?faculty_preference_form - faculty_preference_form)
    (academic_officer_linked_faculty_preference ?academic_officer - academic_officer ?faculty_preference_form - faculty_preference_form)
    (instructor_available ?instructor - instructor)
    (academic_officer_assigned_instructor ?academic_officer - academic_officer ?instructor - instructor)
    (teaching_qualification_available ?teaching_qualification_record - teaching_qualification_record)
    (academic_officer_assigned_teaching_qualification ?academic_officer - academic_officer ?teaching_qualification_record - teaching_qualification_record)
    (regulatory_certificate_available ?regulatory_certificate - regulatory_certificate)
    (academic_officer_assigned_regulatory_certificate ?academic_officer - academic_officer ?regulatory_certificate - regulatory_certificate)
    (authorization_document_available ?authorization_document - authorization_document)
    (registrable_entity_has_authorization_document ?registration_record - registration_record ?authorization_document - authorization_document)
    (evening_request_reserved_flag ?evening_section_request - evening_section_request)
    (day_request_reserved_flag ?day_section_request - day_section_request)
    (academic_officer_finalized ?academic_officer - academic_officer)
  )
  (:action capture_registration_record
    :parameters (?registration_record - registration_record)
    :precondition
      (and
        (not
          (registrable_entity_received ?registration_record)
        )
        (not
          (registrable_entity_committed ?registration_record)
        )
      )
    :effect (registrable_entity_received ?registration_record)
  )
  (:action attach_allocation_token
    :parameters (?registration_record - registration_record ?allocation_token - allocation_token)
    :precondition
      (and
        (registrable_entity_received ?registration_record)
        (not
          (registrable_entity_token_reserved ?registration_record)
        )
        (allocation_token_available ?allocation_token)
      )
    :effect
      (and
        (registrable_entity_token_reserved ?registration_record)
        (registrable_entity_has_allocation_token ?registration_record ?allocation_token)
        (not
          (allocation_token_available ?allocation_token)
        )
      )
  )
  (:action assign_course_to_registration
    :parameters (?registration_record - registration_record ?course - course)
    :precondition
      (and
        (registrable_entity_received ?registration_record)
        (registrable_entity_token_reserved ?registration_record)
        (course_available ?course)
      )
    :effect
      (and
        (registrable_entity_selected_course ?registration_record ?course)
        (not
          (course_available ?course)
        )
      )
  )
  (:action confirm_registration_prequalification
    :parameters (?registration_record - registration_record ?course - course)
    :precondition
      (and
        (registrable_entity_received ?registration_record)
        (registrable_entity_token_reserved ?registration_record)
        (registrable_entity_selected_course ?registration_record ?course)
        (not
          (registrable_entity_prequalified ?registration_record)
        )
      )
    :effect (registrable_entity_prequalified ?registration_record)
  )
  (:action unassign_course_from_registration
    :parameters (?registration_record - registration_record ?course - course)
    :precondition
      (and
        (registrable_entity_selected_course ?registration_record ?course)
      )
    :effect
      (and
        (course_available ?course)
        (not
          (registrable_entity_selected_course ?registration_record ?course)
        )
      )
  )
  (:action assign_advisor_to_registration
    :parameters (?registration_record - registration_record ?department_advisor - department_advisor)
    :precondition
      (and
        (registrable_entity_prequalified ?registration_record)
        (advisor_available ?department_advisor)
      )
    :effect
      (and
        (registrable_entity_assigned_advisor ?registration_record ?department_advisor)
        (not
          (advisor_available ?department_advisor)
        )
      )
  )
  (:action unassign_advisor_from_registration
    :parameters (?registration_record - registration_record ?department_advisor - department_advisor)
    :precondition
      (and
        (registrable_entity_assigned_advisor ?registration_record ?department_advisor)
      )
    :effect
      (and
        (advisor_available ?department_advisor)
        (not
          (registrable_entity_assigned_advisor ?registration_record ?department_advisor)
        )
      )
  )
  (:action assign_teaching_qualification_to_officer
    :parameters (?academic_officer - academic_officer ?teaching_qualification_record - teaching_qualification_record)
    :precondition
      (and
        (registrable_entity_prequalified ?academic_officer)
        (teaching_qualification_available ?teaching_qualification_record)
      )
    :effect
      (and
        (academic_officer_assigned_teaching_qualification ?academic_officer ?teaching_qualification_record)
        (not
          (teaching_qualification_available ?teaching_qualification_record)
        )
      )
  )
  (:action unassign_teaching_qualification_from_officer
    :parameters (?academic_officer - academic_officer ?teaching_qualification_record - teaching_qualification_record)
    :precondition
      (and
        (academic_officer_assigned_teaching_qualification ?academic_officer ?teaching_qualification_record)
      )
    :effect
      (and
        (teaching_qualification_available ?teaching_qualification_record)
        (not
          (academic_officer_assigned_teaching_qualification ?academic_officer ?teaching_qualification_record)
        )
      )
  )
  (:action assign_regulatory_certificate_to_officer
    :parameters (?academic_officer - academic_officer ?regulatory_certificate - regulatory_certificate)
    :precondition
      (and
        (registrable_entity_prequalified ?academic_officer)
        (regulatory_certificate_available ?regulatory_certificate)
      )
    :effect
      (and
        (academic_officer_assigned_regulatory_certificate ?academic_officer ?regulatory_certificate)
        (not
          (regulatory_certificate_available ?regulatory_certificate)
        )
      )
  )
  (:action unassign_regulatory_certificate_from_officer
    :parameters (?academic_officer - academic_officer ?regulatory_certificate - regulatory_certificate)
    :precondition
      (and
        (academic_officer_assigned_regulatory_certificate ?academic_officer ?regulatory_certificate)
      )
    :effect
      (and
        (regulatory_certificate_available ?regulatory_certificate)
        (not
          (academic_officer_assigned_regulatory_certificate ?academic_officer ?regulatory_certificate)
        )
      )
  )
  (:action reserve_evening_timeslot
    :parameters (?evening_section_request - evening_section_request ?evening_timeslot - evening_timeslot ?course - course)
    :precondition
      (and
        (registrable_entity_prequalified ?evening_section_request)
        (registrable_entity_selected_course ?evening_section_request ?course)
        (evening_request_timeslot_match ?evening_section_request ?evening_timeslot)
        (not
          (evening_timeslot_marked ?evening_timeslot)
        )
        (not
          (evening_timeslot_auxiliary_reserved ?evening_timeslot)
        )
      )
    :effect (evening_timeslot_marked ?evening_timeslot)
  )
  (:action confirm_evening_request_with_advisor
    :parameters (?evening_section_request - evening_section_request ?evening_timeslot - evening_timeslot ?department_advisor - department_advisor)
    :precondition
      (and
        (registrable_entity_prequalified ?evening_section_request)
        (registrable_entity_assigned_advisor ?evening_section_request ?department_advisor)
        (evening_request_timeslot_match ?evening_section_request ?evening_timeslot)
        (evening_timeslot_marked ?evening_timeslot)
        (not
          (evening_request_reserved_flag ?evening_section_request)
        )
      )
    :effect
      (and
        (evening_request_reserved_flag ?evening_section_request)
        (evening_request_ready ?evening_section_request)
      )
  )
  (:action reserve_evening_timeslot_with_auxiliary
    :parameters (?evening_section_request - evening_section_request ?evening_timeslot - evening_timeslot ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (registrable_entity_prequalified ?evening_section_request)
        (evening_request_timeslot_match ?evening_section_request ?evening_timeslot)
        (auxiliary_resource_available ?auxiliary_resource)
        (not
          (evening_request_reserved_flag ?evening_section_request)
        )
      )
    :effect
      (and
        (evening_timeslot_auxiliary_reserved ?evening_timeslot)
        (evening_request_reserved_flag ?evening_section_request)
        (evening_request_has_auxiliary ?evening_section_request ?auxiliary_resource)
        (not
          (auxiliary_resource_available ?auxiliary_resource)
        )
      )
  )
  (:action finalize_evening_request_resources
    :parameters (?evening_section_request - evening_section_request ?evening_timeslot - evening_timeslot ?course - course ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (registrable_entity_prequalified ?evening_section_request)
        (registrable_entity_selected_course ?evening_section_request ?course)
        (evening_request_timeslot_match ?evening_section_request ?evening_timeslot)
        (evening_timeslot_auxiliary_reserved ?evening_timeslot)
        (evening_request_has_auxiliary ?evening_section_request ?auxiliary_resource)
        (not
          (evening_request_ready ?evening_section_request)
        )
      )
    :effect
      (and
        (evening_timeslot_marked ?evening_timeslot)
        (evening_request_ready ?evening_section_request)
        (auxiliary_resource_available ?auxiliary_resource)
        (not
          (evening_request_has_auxiliary ?evening_section_request ?auxiliary_resource)
        )
      )
  )
  (:action reserve_day_timeslot_for_request
    :parameters (?day_section_request - day_section_request ?day_timeslot - day_timeslot ?course - course)
    :precondition
      (and
        (registrable_entity_prequalified ?day_section_request)
        (registrable_entity_selected_course ?day_section_request ?course)
        (day_request_timeslot_match ?day_section_request ?day_timeslot)
        (not
          (day_timeslot_marked ?day_timeslot)
        )
        (not
          (day_timeslot_auxiliary_reserved ?day_timeslot)
        )
      )
    :effect (day_timeslot_marked ?day_timeslot)
  )
  (:action confirm_day_request_with_advisor
    :parameters (?day_section_request - day_section_request ?day_timeslot - day_timeslot ?department_advisor - department_advisor)
    :precondition
      (and
        (registrable_entity_prequalified ?day_section_request)
        (registrable_entity_assigned_advisor ?day_section_request ?department_advisor)
        (day_request_timeslot_match ?day_section_request ?day_timeslot)
        (day_timeslot_marked ?day_timeslot)
        (not
          (day_request_reserved_flag ?day_section_request)
        )
      )
    :effect
      (and
        (day_request_reserved_flag ?day_section_request)
        (day_request_ready ?day_section_request)
      )
  )
  (:action reserve_day_timeslot_with_auxiliary
    :parameters (?day_section_request - day_section_request ?day_timeslot - day_timeslot ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (registrable_entity_prequalified ?day_section_request)
        (day_request_timeslot_match ?day_section_request ?day_timeslot)
        (auxiliary_resource_available ?auxiliary_resource)
        (not
          (day_request_reserved_flag ?day_section_request)
        )
      )
    :effect
      (and
        (day_timeslot_auxiliary_reserved ?day_timeslot)
        (day_request_reserved_flag ?day_section_request)
        (day_request_has_auxiliary ?day_section_request ?auxiliary_resource)
        (not
          (auxiliary_resource_available ?auxiliary_resource)
        )
      )
  )
  (:action finalize_day_request_resources
    :parameters (?day_section_request - day_section_request ?day_timeslot - day_timeslot ?course - course ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (registrable_entity_prequalified ?day_section_request)
        (registrable_entity_selected_course ?day_section_request ?course)
        (day_request_timeslot_match ?day_section_request ?day_timeslot)
        (day_timeslot_auxiliary_reserved ?day_timeslot)
        (day_request_has_auxiliary ?day_section_request ?auxiliary_resource)
        (not
          (day_request_ready ?day_section_request)
        )
      )
    :effect
      (and
        (day_timeslot_marked ?day_timeslot)
        (day_request_ready ?day_section_request)
        (auxiliary_resource_available ?auxiliary_resource)
        (not
          (day_request_has_auxiliary ?day_section_request ?auxiliary_resource)
        )
      )
  )
  (:action create_section_instance_candidate
    :parameters (?evening_section_request - evening_section_request ?day_section_request - day_section_request ?evening_timeslot - evening_timeslot ?day_timeslot - day_timeslot ?section_instance - section_instance)
    :precondition
      (and
        (evening_request_reserved_flag ?evening_section_request)
        (day_request_reserved_flag ?day_section_request)
        (evening_request_timeslot_match ?evening_section_request ?evening_timeslot)
        (day_request_timeslot_match ?day_section_request ?day_timeslot)
        (evening_timeslot_marked ?evening_timeslot)
        (day_timeslot_marked ?day_timeslot)
        (evening_request_ready ?evening_section_request)
        (day_request_ready ?day_section_request)
        (section_instance_available ?section_instance)
      )
    :effect
      (and
        (section_instance_initialized ?section_instance)
        (section_instance_has_evening_timeslot ?section_instance ?evening_timeslot)
        (section_instance_has_day_timeslot ?section_instance ?day_timeslot)
        (not
          (section_instance_available ?section_instance)
        )
      )
  )
  (:action create_section_instance_candidate_with_facility_check
    :parameters (?evening_section_request - evening_section_request ?day_section_request - day_section_request ?evening_timeslot - evening_timeslot ?day_timeslot - day_timeslot ?section_instance - section_instance)
    :precondition
      (and
        (evening_request_reserved_flag ?evening_section_request)
        (day_request_reserved_flag ?day_section_request)
        (evening_request_timeslot_match ?evening_section_request ?evening_timeslot)
        (day_request_timeslot_match ?day_section_request ?day_timeslot)
        (evening_timeslot_auxiliary_reserved ?evening_timeslot)
        (day_timeslot_marked ?day_timeslot)
        (not
          (evening_request_ready ?evening_section_request)
        )
        (day_request_ready ?day_section_request)
        (section_instance_available ?section_instance)
      )
    :effect
      (and
        (section_instance_initialized ?section_instance)
        (section_instance_has_evening_timeslot ?section_instance ?evening_timeslot)
        (section_instance_has_day_timeslot ?section_instance ?day_timeslot)
        (section_instance_requires_facility_check ?section_instance)
        (not
          (section_instance_available ?section_instance)
        )
      )
  )
  (:action create_section_instance_candidate_with_additional_review
    :parameters (?evening_section_request - evening_section_request ?day_section_request - day_section_request ?evening_timeslot - evening_timeslot ?day_timeslot - day_timeslot ?section_instance - section_instance)
    :precondition
      (and
        (evening_request_reserved_flag ?evening_section_request)
        (day_request_reserved_flag ?day_section_request)
        (evening_request_timeslot_match ?evening_section_request ?evening_timeslot)
        (day_request_timeslot_match ?day_section_request ?day_timeslot)
        (evening_timeslot_marked ?evening_timeslot)
        (day_timeslot_auxiliary_reserved ?day_timeslot)
        (evening_request_ready ?evening_section_request)
        (not
          (day_request_ready ?day_section_request)
        )
        (section_instance_available ?section_instance)
      )
    :effect
      (and
        (section_instance_initialized ?section_instance)
        (section_instance_has_evening_timeslot ?section_instance ?evening_timeslot)
        (section_instance_has_day_timeslot ?section_instance ?day_timeslot)
        (section_instance_requires_additional_review ?section_instance)
        (not
          (section_instance_available ?section_instance)
        )
      )
  )
  (:action create_section_instance_candidate_with_full_checks
    :parameters (?evening_section_request - evening_section_request ?day_section_request - day_section_request ?evening_timeslot - evening_timeslot ?day_timeslot - day_timeslot ?section_instance - section_instance)
    :precondition
      (and
        (evening_request_reserved_flag ?evening_section_request)
        (day_request_reserved_flag ?day_section_request)
        (evening_request_timeslot_match ?evening_section_request ?evening_timeslot)
        (day_request_timeslot_match ?day_section_request ?day_timeslot)
        (evening_timeslot_auxiliary_reserved ?evening_timeslot)
        (day_timeslot_auxiliary_reserved ?day_timeslot)
        (not
          (evening_request_ready ?evening_section_request)
        )
        (not
          (day_request_ready ?day_section_request)
        )
        (section_instance_available ?section_instance)
      )
    :effect
      (and
        (section_instance_initialized ?section_instance)
        (section_instance_has_evening_timeslot ?section_instance ?evening_timeslot)
        (section_instance_has_day_timeslot ?section_instance ?day_timeslot)
        (section_instance_requires_facility_check ?section_instance)
        (section_instance_requires_additional_review ?section_instance)
        (not
          (section_instance_available ?section_instance)
        )
      )
  )
  (:action confirm_section_room_eligibility
    :parameters (?section_instance - section_instance ?evening_section_request - evening_section_request ?course - course)
    :precondition
      (and
        (section_instance_initialized ?section_instance)
        (evening_request_reserved_flag ?evening_section_request)
        (registrable_entity_selected_course ?evening_section_request ?course)
        (not
          (section_instance_room_eligibility_confirmed ?section_instance)
        )
      )
    :effect (section_instance_room_eligibility_confirmed ?section_instance)
  )
  (:action reserve_classroom_for_section_instance
    :parameters (?academic_officer - academic_officer ?classroom - classroom ?section_instance - section_instance)
    :precondition
      (and
        (registrable_entity_prequalified ?academic_officer)
        (academic_officer_assigned_section_instance ?academic_officer ?section_instance)
        (academic_officer_associated_classroom ?academic_officer ?classroom)
        (classroom_available ?classroom)
        (section_instance_initialized ?section_instance)
        (section_instance_room_eligibility_confirmed ?section_instance)
        (not
          (classroom_reserved ?classroom)
        )
      )
    :effect
      (and
        (classroom_reserved ?classroom)
        (classroom_reserved_for_section ?classroom ?section_instance)
        (not
          (classroom_available ?classroom)
        )
      )
  )
  (:action approve_classroom_assignment_by_officer
    :parameters (?academic_officer - academic_officer ?classroom - classroom ?section_instance - section_instance ?course - course)
    :precondition
      (and
        (registrable_entity_prequalified ?academic_officer)
        (academic_officer_associated_classroom ?academic_officer ?classroom)
        (classroom_reserved ?classroom)
        (classroom_reserved_for_section ?classroom ?section_instance)
        (registrable_entity_selected_course ?academic_officer ?course)
        (not
          (section_instance_requires_facility_check ?section_instance)
        )
        (not
          (academic_officer_instructor_binding_initiated ?academic_officer)
        )
      )
    :effect (academic_officer_instructor_binding_initiated ?academic_officer)
  )
  (:action attach_faculty_preference_form
    :parameters (?academic_officer - academic_officer ?faculty_preference_form - faculty_preference_form)
    :precondition
      (and
        (registrable_entity_prequalified ?academic_officer)
        (faculty_preference_form_available ?faculty_preference_form)
        (not
          (academic_officer_pref_attached ?academic_officer)
        )
      )
    :effect
      (and
        (academic_officer_pref_attached ?academic_officer)
        (academic_officer_linked_faculty_preference ?academic_officer ?faculty_preference_form)
        (not
          (faculty_preference_form_available ?faculty_preference_form)
        )
      )
  )
  (:action process_faculty_preference_for_assignment
    :parameters (?academic_officer - academic_officer ?classroom - classroom ?section_instance - section_instance ?course - course ?faculty_preference_form - faculty_preference_form)
    :precondition
      (and
        (registrable_entity_prequalified ?academic_officer)
        (academic_officer_associated_classroom ?academic_officer ?classroom)
        (classroom_reserved ?classroom)
        (classroom_reserved_for_section ?classroom ?section_instance)
        (registrable_entity_selected_course ?academic_officer ?course)
        (section_instance_requires_facility_check ?section_instance)
        (academic_officer_pref_attached ?academic_officer)
        (academic_officer_linked_faculty_preference ?academic_officer ?faculty_preference_form)
        (not
          (academic_officer_instructor_binding_initiated ?academic_officer)
        )
      )
    :effect
      (and
        (academic_officer_instructor_binding_initiated ?academic_officer)
        (academic_officer_pref_processed ?academic_officer)
      )
  )
  (:action assign_instructor_qualification_and_lock
    :parameters (?academic_officer - academic_officer ?teaching_qualification_record - teaching_qualification_record ?department_advisor - department_advisor ?classroom - classroom ?section_instance - section_instance)
    :precondition
      (and
        (academic_officer_instructor_binding_initiated ?academic_officer)
        (academic_officer_assigned_teaching_qualification ?academic_officer ?teaching_qualification_record)
        (registrable_entity_assigned_advisor ?academic_officer ?department_advisor)
        (academic_officer_associated_classroom ?academic_officer ?classroom)
        (classroom_reserved_for_section ?classroom ?section_instance)
        (not
          (section_instance_requires_additional_review ?section_instance)
        )
        (not
          (academic_officer_instructor_binding_confirmed ?academic_officer)
        )
      )
    :effect (academic_officer_instructor_binding_confirmed ?academic_officer)
  )
  (:action confirm_instructor_qualification_and_lock
    :parameters (?academic_officer - academic_officer ?teaching_qualification_record - teaching_qualification_record ?department_advisor - department_advisor ?classroom - classroom ?section_instance - section_instance)
    :precondition
      (and
        (academic_officer_instructor_binding_initiated ?academic_officer)
        (academic_officer_assigned_teaching_qualification ?academic_officer ?teaching_qualification_record)
        (registrable_entity_assigned_advisor ?academic_officer ?department_advisor)
        (academic_officer_associated_classroom ?academic_officer ?classroom)
        (classroom_reserved_for_section ?classroom ?section_instance)
        (section_instance_requires_additional_review ?section_instance)
        (not
          (academic_officer_instructor_binding_confirmed ?academic_officer)
        )
      )
    :effect (academic_officer_instructor_binding_confirmed ?academic_officer)
  )
  (:action apply_regulatory_certificate_and_stage
    :parameters (?academic_officer - academic_officer ?regulatory_certificate - regulatory_certificate ?classroom - classroom ?section_instance - section_instance)
    :precondition
      (and
        (academic_officer_instructor_binding_confirmed ?academic_officer)
        (academic_officer_assigned_regulatory_certificate ?academic_officer ?regulatory_certificate)
        (academic_officer_associated_classroom ?academic_officer ?classroom)
        (classroom_reserved_for_section ?classroom ?section_instance)
        (not
          (section_instance_requires_facility_check ?section_instance)
        )
        (not
          (section_instance_requires_additional_review ?section_instance)
        )
        (not
          (academic_officer_preference_consumed ?academic_officer)
        )
      )
    :effect (academic_officer_preference_consumed ?academic_officer)
  )
  (:action apply_regulatory_certificate_and_mark_primary
    :parameters (?academic_officer - academic_officer ?regulatory_certificate - regulatory_certificate ?classroom - classroom ?section_instance - section_instance)
    :precondition
      (and
        (academic_officer_instructor_binding_confirmed ?academic_officer)
        (academic_officer_assigned_regulatory_certificate ?academic_officer ?regulatory_certificate)
        (academic_officer_associated_classroom ?academic_officer ?classroom)
        (classroom_reserved_for_section ?classroom ?section_instance)
        (section_instance_requires_facility_check ?section_instance)
        (not
          (section_instance_requires_additional_review ?section_instance)
        )
        (not
          (academic_officer_preference_consumed ?academic_officer)
        )
      )
    :effect
      (and
        (academic_officer_preference_consumed ?academic_officer)
        (academic_officer_instructor_assignment_ready ?academic_officer)
      )
  )
  (:action apply_regulatory_certificate_and_mark_secondary
    :parameters (?academic_officer - academic_officer ?regulatory_certificate - regulatory_certificate ?classroom - classroom ?section_instance - section_instance)
    :precondition
      (and
        (academic_officer_instructor_binding_confirmed ?academic_officer)
        (academic_officer_assigned_regulatory_certificate ?academic_officer ?regulatory_certificate)
        (academic_officer_associated_classroom ?academic_officer ?classroom)
        (classroom_reserved_for_section ?classroom ?section_instance)
        (not
          (section_instance_requires_facility_check ?section_instance)
        )
        (section_instance_requires_additional_review ?section_instance)
        (not
          (academic_officer_preference_consumed ?academic_officer)
        )
      )
    :effect
      (and
        (academic_officer_preference_consumed ?academic_officer)
        (academic_officer_instructor_assignment_ready ?academic_officer)
      )
  )
  (:action finalize_regulatory_certificate_processing
    :parameters (?academic_officer - academic_officer ?regulatory_certificate - regulatory_certificate ?classroom - classroom ?section_instance - section_instance)
    :precondition
      (and
        (academic_officer_instructor_binding_confirmed ?academic_officer)
        (academic_officer_assigned_regulatory_certificate ?academic_officer ?regulatory_certificate)
        (academic_officer_associated_classroom ?academic_officer ?classroom)
        (classroom_reserved_for_section ?classroom ?section_instance)
        (section_instance_requires_facility_check ?section_instance)
        (section_instance_requires_additional_review ?section_instance)
        (not
          (academic_officer_preference_consumed ?academic_officer)
        )
      )
    :effect
      (and
        (academic_officer_preference_consumed ?academic_officer)
        (academic_officer_instructor_assignment_ready ?academic_officer)
      )
  )
  (:action mark_officer_ready_for_finalization
    :parameters (?academic_officer - academic_officer)
    :precondition
      (and
        (academic_officer_preference_consumed ?academic_officer)
        (not
          (academic_officer_instructor_assignment_ready ?academic_officer)
        )
        (not
          (academic_officer_finalized ?academic_officer)
        )
      )
    :effect
      (and
        (academic_officer_finalized ?academic_officer)
        (registrable_entity_ready_for_finalization ?academic_officer)
      )
  )
  (:action attach_instructor_to_officer
    :parameters (?academic_officer - academic_officer ?instructor - instructor)
    :precondition
      (and
        (academic_officer_preference_consumed ?academic_officer)
        (academic_officer_instructor_assignment_ready ?academic_officer)
        (instructor_available ?instructor)
      )
    :effect
      (and
        (academic_officer_assigned_instructor ?academic_officer ?instructor)
        (not
          (instructor_available ?instructor)
        )
      )
  )
  (:action approve_section_candidate
    :parameters (?academic_officer - academic_officer ?evening_section_request - evening_section_request ?day_section_request - day_section_request ?course - course ?instructor - instructor)
    :precondition
      (and
        (academic_officer_preference_consumed ?academic_officer)
        (academic_officer_instructor_assignment_ready ?academic_officer)
        (academic_officer_assigned_instructor ?academic_officer ?instructor)
        (academic_officer_assigned_to_evening_request ?academic_officer ?evening_section_request)
        (academic_officer_assigned_to_day_request ?academic_officer ?day_section_request)
        (evening_request_ready ?evening_section_request)
        (day_request_ready ?day_section_request)
        (registrable_entity_selected_course ?academic_officer ?course)
        (not
          (academic_officer_instructor_assignment_locked ?academic_officer)
        )
      )
    :effect (academic_officer_instructor_assignment_locked ?academic_officer)
  )
  (:action record_officer_final_approval
    :parameters (?academic_officer - academic_officer)
    :precondition
      (and
        (academic_officer_preference_consumed ?academic_officer)
        (academic_officer_instructor_assignment_locked ?academic_officer)
        (not
          (academic_officer_finalized ?academic_officer)
        )
      )
    :effect
      (and
        (academic_officer_finalized ?academic_officer)
        (registrable_entity_ready_for_finalization ?academic_officer)
      )
  )
  (:action attach_departmental_clearance_to_officer
    :parameters (?academic_officer - academic_officer ?departmental_clearance_document - departmental_clearance_resource ?course - course)
    :precondition
      (and
        (registrable_entity_prequalified ?academic_officer)
        (registrable_entity_selected_course ?academic_officer ?course)
        (departmental_clearance_available ?departmental_clearance_document)
        (academic_officer_has_departmental_clearance ?academic_officer ?departmental_clearance_document)
        (not
          (academic_officer_departmental_clearance_attached ?academic_officer)
        )
      )
    :effect
      (and
        (academic_officer_departmental_clearance_attached ?academic_officer)
        (not
          (departmental_clearance_available ?departmental_clearance_document)
        )
      )
  )
  (:action verify_departmental_clearance_for_officer
    :parameters (?academic_officer - academic_officer ?department_advisor - department_advisor)
    :precondition
      (and
        (academic_officer_departmental_clearance_attached ?academic_officer)
        (registrable_entity_assigned_advisor ?academic_officer ?department_advisor)
        (not
          (academic_officer_departmental_clearance_verified ?academic_officer)
        )
      )
    :effect (academic_officer_departmental_clearance_verified ?academic_officer)
  )
  (:action verify_regulatory_certificate_for_officer
    :parameters (?academic_officer - academic_officer ?regulatory_certificate - regulatory_certificate)
    :precondition
      (and
        (academic_officer_departmental_clearance_verified ?academic_officer)
        (academic_officer_assigned_regulatory_certificate ?academic_officer ?regulatory_certificate)
        (not
          (academic_officer_regulatory_certificate_verified ?academic_officer)
        )
      )
    :effect (academic_officer_regulatory_certificate_verified ?academic_officer)
  )
  (:action record_officer_clearance
    :parameters (?academic_officer - academic_officer)
    :precondition
      (and
        (academic_officer_regulatory_certificate_verified ?academic_officer)
        (not
          (academic_officer_finalized ?academic_officer)
        )
      )
    :effect
      (and
        (academic_officer_finalized ?academic_officer)
        (registrable_entity_ready_for_finalization ?academic_officer)
      )
  )
  (:action finalize_evening_section_instance
    :parameters (?evening_section_request - evening_section_request ?section_instance - section_instance)
    :precondition
      (and
        (evening_request_reserved_flag ?evening_section_request)
        (evening_request_ready ?evening_section_request)
        (section_instance_initialized ?section_instance)
        (section_instance_room_eligibility_confirmed ?section_instance)
        (not
          (registrable_entity_ready_for_finalization ?evening_section_request)
        )
      )
    :effect (registrable_entity_ready_for_finalization ?evening_section_request)
  )
  (:action finalize_day_section_instance
    :parameters (?day_section_request - day_section_request ?section_instance - section_instance)
    :precondition
      (and
        (day_request_reserved_flag ?day_section_request)
        (day_request_ready ?day_section_request)
        (section_instance_initialized ?section_instance)
        (section_instance_room_eligibility_confirmed ?section_instance)
        (not
          (registrable_entity_ready_for_finalization ?day_section_request)
        )
      )
    :effect (registrable_entity_ready_for_finalization ?day_section_request)
  )
  (:action authorize_registration_with_document
    :parameters (?registration_record - registration_record ?authorization_document - authorization_document ?course - course)
    :precondition
      (and
        (registrable_entity_ready_for_finalization ?registration_record)
        (registrable_entity_selected_course ?registration_record ?course)
        (authorization_document_available ?authorization_document)
        (not
          (registrable_entity_authorized ?registration_record)
        )
      )
    :effect
      (and
        (registrable_entity_authorized ?registration_record)
        (registrable_entity_has_authorization_document ?registration_record ?authorization_document)
        (not
          (authorization_document_available ?authorization_document)
        )
      )
  )
  (:action commit_registration_and_release_token
    :parameters (?evening_section_request - evening_section_request ?allocation_token - allocation_token ?authorization_document - authorization_document)
    :precondition
      (and
        (registrable_entity_authorized ?evening_section_request)
        (registrable_entity_has_allocation_token ?evening_section_request ?allocation_token)
        (registrable_entity_has_authorization_document ?evening_section_request ?authorization_document)
        (not
          (registrable_entity_committed ?evening_section_request)
        )
      )
    :effect
      (and
        (registrable_entity_committed ?evening_section_request)
        (allocation_token_available ?allocation_token)
        (authorization_document_available ?authorization_document)
      )
  )
  (:action commit_day_registration_and_release_token
    :parameters (?day_section_request - day_section_request ?allocation_token - allocation_token ?authorization_document - authorization_document)
    :precondition
      (and
        (registrable_entity_authorized ?day_section_request)
        (registrable_entity_has_allocation_token ?day_section_request ?allocation_token)
        (registrable_entity_has_authorization_document ?day_section_request ?authorization_document)
        (not
          (registrable_entity_committed ?day_section_request)
        )
      )
    :effect
      (and
        (registrable_entity_committed ?day_section_request)
        (allocation_token_available ?allocation_token)
        (authorization_document_available ?authorization_document)
      )
  )
  (:action commit_officer_and_release_token
    :parameters (?academic_officer - academic_officer ?allocation_token - allocation_token ?authorization_document - authorization_document)
    :precondition
      (and
        (registrable_entity_authorized ?academic_officer)
        (registrable_entity_has_allocation_token ?academic_officer ?allocation_token)
        (registrable_entity_has_authorization_document ?academic_officer ?authorization_document)
        (not
          (registrable_entity_committed ?academic_officer)
        )
      )
    :effect
      (and
        (registrable_entity_committed ?academic_officer)
        (allocation_token_available ?allocation_token)
        (authorization_document_available ?authorization_document)
      )
  )
)

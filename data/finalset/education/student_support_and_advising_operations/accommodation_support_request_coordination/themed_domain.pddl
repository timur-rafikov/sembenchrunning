(define (domain accommodation_support_request_coordination)
  (:requirements :strips :typing :negative-preconditions)
  (:types administrative_resource - object organizational_unit - object external_entity - object accommodation_domain_root - object student_case - accommodation_domain_root support_service_unit - administrative_resource appointment_slot - administrative_resource campus_staff_contact - administrative_resource approval_item - administrative_resource program_track - administrative_resource consent_token - administrative_resource specialist_personnel - administrative_resource specialist_role - administrative_resource referral_resource - organizational_unit supporting_document - organizational_unit approver_role - organizational_unit course_section - external_entity instructor_role - external_entity accommodation_plan - external_entity student_case_subtype_a - student_case student_case_subtype_b - student_case student_profile - student_case_subtype_a course_participant_record - student_case_subtype_a case_coordinator - student_case_subtype_b)
  (:predicates
    (registered ?student_case - student_case)
    (ready_for_referral ?student_case - student_case)
    (has_service_assignment ?student_case - student_case)
    (allocation_confirmed ?student_case - student_case)
    (ready_for_implementation ?student_case - student_case)
    (consent_recorded ?student_case - student_case)
    (support_unit_available ?support_service_unit - support_service_unit)
    (assigned_to_support_unit ?student_case - student_case ?support_service_unit - support_service_unit)
    (appointment_slot_available ?appointment_slot - appointment_slot)
    (scheduled_in_slot ?student_case - student_case ?appointment_slot - appointment_slot)
    (campus_staff_available ?campus_staff_contact - campus_staff_contact)
    (referred_to_staff_contact ?student_case - student_case ?campus_staff_contact - campus_staff_contact)
    (referral_resource_available ?referral_resource - referral_resource)
    (student_profile_selected_resource ?student_profile - student_profile ?referral_resource - referral_resource)
    (course_participant_selected_resource ?course_participant_record - course_participant_record ?referral_resource - referral_resource)
    (profile_enrolled_in_section ?student_profile - student_profile ?course_section - course_section)
    (section_selected_for_student_path ?course_section - course_section)
    (section_selected_for_course_path ?course_section - course_section)
    (student_profile_ready_for_plan ?student_profile - student_profile)
    (participant_associated_with_instructor ?course_participant_record - course_participant_record ?instructor_role - instructor_role)
    (instructor_flagged_student_path ?instructor_role - instructor_role)
    (instructor_flagged_course_path ?instructor_role - instructor_role)
    (course_participant_ready_for_plan ?course_participant_record - course_participant_record)
    (plan_draft_available ?accommodation_plan - accommodation_plan)
    (plan_assembled ?accommodation_plan - accommodation_plan)
    (plan_associated_with_section ?accommodation_plan - accommodation_plan ?course_section - course_section)
    (plan_associated_with_instructor ?accommodation_plan - accommodation_plan ?instructor_role - instructor_role)
    (plan_requires_admin_path_a ?accommodation_plan - accommodation_plan)
    (plan_requires_admin_path_b ?accommodation_plan - accommodation_plan)
    (plan_locked ?accommodation_plan - accommodation_plan)
    (coordinator_responsible_for_profile ?case_coordinator - case_coordinator ?student_profile - student_profile)
    (coordinator_responsible_for_participant ?case_coordinator - case_coordinator ?course_participant_record - course_participant_record)
    (coordinator_responsible_for_plan ?case_coordinator - case_coordinator ?accommodation_plan - accommodation_plan)
    (supporting_document_available ?supporting_document - supporting_document)
    (coordinator_has_document ?case_coordinator - case_coordinator ?supporting_document - supporting_document)
    (supporting_document_attached ?supporting_document - supporting_document)
    (document_attached_to_plan ?supporting_document - supporting_document ?accommodation_plan - accommodation_plan)
    (coordinator_activated ?case_coordinator - case_coordinator)
    (coordinator_approval_in_progress ?case_coordinator - case_coordinator)
    (approvals_collected ?case_coordinator - case_coordinator)
    (coordinator_has_approval_item ?case_coordinator - case_coordinator)
    (coordinator_approval_stage_two ?case_coordinator - case_coordinator)
    (coordinator_approver_assigned ?case_coordinator - case_coordinator)
    (coordinator_ready_for_signoff ?case_coordinator - case_coordinator)
    (approver_available ?approver_role - approver_role)
    (coordinator_has_approver_role ?case_coordinator - case_coordinator ?approver_role - approver_role)
    (coordinator_approver_engaged ?case_coordinator - case_coordinator)
    (approval_request_submitted ?case_coordinator - case_coordinator)
    (approval_confirmed ?case_coordinator - case_coordinator)
    (approval_item_available ?approval_item - approval_item)
    (coordinator_linked_to_approval_item ?case_coordinator - case_coordinator ?approval_item - approval_item)
    (program_track_available ?program_track - program_track)
    (coordinator_assigned_program_track ?case_coordinator - case_coordinator ?program_track - program_track)
    (specialist_available ?specialist_personnel - specialist_personnel)
    (coordinator_assigned_specialist ?case_coordinator - case_coordinator ?specialist_personnel - specialist_personnel)
    (specialist_role_available ?specialist_role - specialist_role)
    (coordinator_assigned_specialist_role ?case_coordinator - case_coordinator ?specialist_role - specialist_role)
    (consent_token_available ?consent_token - consent_token)
    (linked_to_consent_token ?student_case - student_case ?consent_token - consent_token)
    (student_profile_assessed ?student_profile - student_profile)
    (course_participant_assessed ?course_participant_record - course_participant_record)
    (coordinator_signoff_recorded ?case_coordinator - case_coordinator)
  )
  (:action register_accommodation_request
    :parameters (?student_case - student_case)
    :precondition
      (and
        (not
          (registered ?student_case)
        )
        (not
          (allocation_confirmed ?student_case)
        )
      )
    :effect (registered ?student_case)
  )
  (:action assign_support_unit_to_case
    :parameters (?student_case - student_case ?support_service_unit - support_service_unit)
    :precondition
      (and
        (registered ?student_case)
        (not
          (has_service_assignment ?student_case)
        )
        (support_unit_available ?support_service_unit)
      )
    :effect
      (and
        (has_service_assignment ?student_case)
        (assigned_to_support_unit ?student_case ?support_service_unit)
        (not
          (support_unit_available ?support_service_unit)
        )
      )
  )
  (:action schedule_intake_appointment
    :parameters (?student_case - student_case ?appointment_slot - appointment_slot)
    :precondition
      (and
        (registered ?student_case)
        (has_service_assignment ?student_case)
        (appointment_slot_available ?appointment_slot)
      )
    :effect
      (and
        (scheduled_in_slot ?student_case ?appointment_slot)
        (not
          (appointment_slot_available ?appointment_slot)
        )
      )
  )
  (:action confirm_scheduled_appointment
    :parameters (?student_case - student_case ?appointment_slot - appointment_slot)
    :precondition
      (and
        (registered ?student_case)
        (has_service_assignment ?student_case)
        (scheduled_in_slot ?student_case ?appointment_slot)
        (not
          (ready_for_referral ?student_case)
        )
      )
    :effect (ready_for_referral ?student_case)
  )
  (:action release_appointment_slot
    :parameters (?student_case - student_case ?appointment_slot - appointment_slot)
    :precondition
      (and
        (scheduled_in_slot ?student_case ?appointment_slot)
      )
    :effect
      (and
        (appointment_slot_available ?appointment_slot)
        (not
          (scheduled_in_slot ?student_case ?appointment_slot)
        )
      )
  )
  (:action refer_case_to_staff_contact
    :parameters (?student_case - student_case ?campus_staff_contact - campus_staff_contact)
    :precondition
      (and
        (ready_for_referral ?student_case)
        (campus_staff_available ?campus_staff_contact)
      )
    :effect
      (and
        (referred_to_staff_contact ?student_case ?campus_staff_contact)
        (not
          (campus_staff_available ?campus_staff_contact)
        )
      )
  )
  (:action revoke_staff_referral
    :parameters (?student_case - student_case ?campus_staff_contact - campus_staff_contact)
    :precondition
      (and
        (referred_to_staff_contact ?student_case ?campus_staff_contact)
      )
    :effect
      (and
        (campus_staff_available ?campus_staff_contact)
        (not
          (referred_to_staff_contact ?student_case ?campus_staff_contact)
        )
      )
  )
  (:action assign_specialist_personnel
    :parameters (?case_coordinator - case_coordinator ?specialist_personnel - specialist_personnel)
    :precondition
      (and
        (ready_for_referral ?case_coordinator)
        (specialist_available ?specialist_personnel)
      )
    :effect
      (and
        (coordinator_assigned_specialist ?case_coordinator ?specialist_personnel)
        (not
          (specialist_available ?specialist_personnel)
        )
      )
  )
  (:action release_specialist_personnel
    :parameters (?case_coordinator - case_coordinator ?specialist_personnel - specialist_personnel)
    :precondition
      (and
        (coordinator_assigned_specialist ?case_coordinator ?specialist_personnel)
      )
    :effect
      (and
        (specialist_available ?specialist_personnel)
        (not
          (coordinator_assigned_specialist ?case_coordinator ?specialist_personnel)
        )
      )
  )
  (:action assign_specialist_role
    :parameters (?case_coordinator - case_coordinator ?specialist_role - specialist_role)
    :precondition
      (and
        (ready_for_referral ?case_coordinator)
        (specialist_role_available ?specialist_role)
      )
    :effect
      (and
        (coordinator_assigned_specialist_role ?case_coordinator ?specialist_role)
        (not
          (specialist_role_available ?specialist_role)
        )
      )
  )
  (:action release_specialist_role
    :parameters (?case_coordinator - case_coordinator ?specialist_role - specialist_role)
    :precondition
      (and
        (coordinator_assigned_specialist_role ?case_coordinator ?specialist_role)
      )
    :effect
      (and
        (specialist_role_available ?specialist_role)
        (not
          (coordinator_assigned_specialist_role ?case_coordinator ?specialist_role)
        )
      )
  )
  (:action mark_section_for_student_path
    :parameters (?student_profile - student_profile ?course_section - course_section ?appointment_slot - appointment_slot)
    :precondition
      (and
        (ready_for_referral ?student_profile)
        (scheduled_in_slot ?student_profile ?appointment_slot)
        (profile_enrolled_in_section ?student_profile ?course_section)
        (not
          (section_selected_for_student_path ?course_section)
        )
        (not
          (section_selected_for_course_path ?course_section)
        )
      )
    :effect (section_selected_for_student_path ?course_section)
  )
  (:action confirm_student_path_assessment
    :parameters (?student_profile - student_profile ?course_section - course_section ?campus_staff_contact - campus_staff_contact)
    :precondition
      (and
        (ready_for_referral ?student_profile)
        (referred_to_staff_contact ?student_profile ?campus_staff_contact)
        (profile_enrolled_in_section ?student_profile ?course_section)
        (section_selected_for_student_path ?course_section)
        (not
          (student_profile_assessed ?student_profile)
        )
      )
    :effect
      (and
        (student_profile_assessed ?student_profile)
        (student_profile_ready_for_plan ?student_profile)
      )
  )
  (:action assign_referral_resource_to_profile
    :parameters (?student_profile - student_profile ?course_section - course_section ?referral_resource - referral_resource)
    :precondition
      (and
        (ready_for_referral ?student_profile)
        (profile_enrolled_in_section ?student_profile ?course_section)
        (referral_resource_available ?referral_resource)
        (not
          (student_profile_assessed ?student_profile)
        )
      )
    :effect
      (and
        (section_selected_for_course_path ?course_section)
        (student_profile_assessed ?student_profile)
        (student_profile_selected_resource ?student_profile ?referral_resource)
        (not
          (referral_resource_available ?referral_resource)
        )
      )
  )
  (:action advance_student_path_intervention
    :parameters (?student_profile - student_profile ?course_section - course_section ?appointment_slot - appointment_slot ?referral_resource - referral_resource)
    :precondition
      (and
        (ready_for_referral ?student_profile)
        (scheduled_in_slot ?student_profile ?appointment_slot)
        (profile_enrolled_in_section ?student_profile ?course_section)
        (section_selected_for_course_path ?course_section)
        (student_profile_selected_resource ?student_profile ?referral_resource)
        (not
          (student_profile_ready_for_plan ?student_profile)
        )
      )
    :effect
      (and
        (section_selected_for_student_path ?course_section)
        (student_profile_ready_for_plan ?student_profile)
        (referral_resource_available ?referral_resource)
        (not
          (student_profile_selected_resource ?student_profile ?referral_resource)
        )
      )
  )
  (:action flag_instructor_for_student_path
    :parameters (?course_participant_record - course_participant_record ?instructor_role - instructor_role ?appointment_slot - appointment_slot)
    :precondition
      (and
        (ready_for_referral ?course_participant_record)
        (scheduled_in_slot ?course_participant_record ?appointment_slot)
        (participant_associated_with_instructor ?course_participant_record ?instructor_role)
        (not
          (instructor_flagged_student_path ?instructor_role)
        )
        (not
          (instructor_flagged_course_path ?instructor_role)
        )
      )
    :effect (instructor_flagged_student_path ?instructor_role)
  )
  (:action confirm_instructor_path_assessment
    :parameters (?course_participant_record - course_participant_record ?instructor_role - instructor_role ?campus_staff_contact - campus_staff_contact)
    :precondition
      (and
        (ready_for_referral ?course_participant_record)
        (referred_to_staff_contact ?course_participant_record ?campus_staff_contact)
        (participant_associated_with_instructor ?course_participant_record ?instructor_role)
        (instructor_flagged_student_path ?instructor_role)
        (not
          (course_participant_assessed ?course_participant_record)
        )
      )
    :effect
      (and
        (course_participant_assessed ?course_participant_record)
        (course_participant_ready_for_plan ?course_participant_record)
      )
  )
  (:action assign_referral_resource_to_participant
    :parameters (?course_participant_record - course_participant_record ?instructor_role - instructor_role ?referral_resource - referral_resource)
    :precondition
      (and
        (ready_for_referral ?course_participant_record)
        (participant_associated_with_instructor ?course_participant_record ?instructor_role)
        (referral_resource_available ?referral_resource)
        (not
          (course_participant_assessed ?course_participant_record)
        )
      )
    :effect
      (and
        (instructor_flagged_course_path ?instructor_role)
        (course_participant_assessed ?course_participant_record)
        (course_participant_selected_resource ?course_participant_record ?referral_resource)
        (not
          (referral_resource_available ?referral_resource)
        )
      )
  )
  (:action advance_course_participant_intervention
    :parameters (?course_participant_record - course_participant_record ?instructor_role - instructor_role ?appointment_slot - appointment_slot ?referral_resource - referral_resource)
    :precondition
      (and
        (ready_for_referral ?course_participant_record)
        (scheduled_in_slot ?course_participant_record ?appointment_slot)
        (participant_associated_with_instructor ?course_participant_record ?instructor_role)
        (instructor_flagged_course_path ?instructor_role)
        (course_participant_selected_resource ?course_participant_record ?referral_resource)
        (not
          (course_participant_ready_for_plan ?course_participant_record)
        )
      )
    :effect
      (and
        (instructor_flagged_student_path ?instructor_role)
        (course_participant_ready_for_plan ?course_participant_record)
        (referral_resource_available ?referral_resource)
        (not
          (course_participant_selected_resource ?course_participant_record ?referral_resource)
        )
      )
  )
  (:action assemble_accommodation_plan_from_inputs
    :parameters (?student_profile - student_profile ?course_participant_record - course_participant_record ?course_section - course_section ?instructor_role - instructor_role ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (student_profile_assessed ?student_profile)
        (course_participant_assessed ?course_participant_record)
        (profile_enrolled_in_section ?student_profile ?course_section)
        (participant_associated_with_instructor ?course_participant_record ?instructor_role)
        (section_selected_for_student_path ?course_section)
        (instructor_flagged_student_path ?instructor_role)
        (student_profile_ready_for_plan ?student_profile)
        (course_participant_ready_for_plan ?course_participant_record)
        (plan_draft_available ?accommodation_plan)
      )
    :effect
      (and
        (plan_assembled ?accommodation_plan)
        (plan_associated_with_section ?accommodation_plan ?course_section)
        (plan_associated_with_instructor ?accommodation_plan ?instructor_role)
        (not
          (plan_draft_available ?accommodation_plan)
        )
      )
  )
  (:action assemble_accommodation_plan_with_admin_path_a
    :parameters (?student_profile - student_profile ?course_participant_record - course_participant_record ?course_section - course_section ?instructor_role - instructor_role ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (student_profile_assessed ?student_profile)
        (course_participant_assessed ?course_participant_record)
        (profile_enrolled_in_section ?student_profile ?course_section)
        (participant_associated_with_instructor ?course_participant_record ?instructor_role)
        (section_selected_for_course_path ?course_section)
        (instructor_flagged_student_path ?instructor_role)
        (not
          (student_profile_ready_for_plan ?student_profile)
        )
        (course_participant_ready_for_plan ?course_participant_record)
        (plan_draft_available ?accommodation_plan)
      )
    :effect
      (and
        (plan_assembled ?accommodation_plan)
        (plan_associated_with_section ?accommodation_plan ?course_section)
        (plan_associated_with_instructor ?accommodation_plan ?instructor_role)
        (plan_requires_admin_path_a ?accommodation_plan)
        (not
          (plan_draft_available ?accommodation_plan)
        )
      )
  )
  (:action assemble_accommodation_plan_with_admin_path_b
    :parameters (?student_profile - student_profile ?course_participant_record - course_participant_record ?course_section - course_section ?instructor_role - instructor_role ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (student_profile_assessed ?student_profile)
        (course_participant_assessed ?course_participant_record)
        (profile_enrolled_in_section ?student_profile ?course_section)
        (participant_associated_with_instructor ?course_participant_record ?instructor_role)
        (section_selected_for_student_path ?course_section)
        (instructor_flagged_course_path ?instructor_role)
        (student_profile_ready_for_plan ?student_profile)
        (not
          (course_participant_ready_for_plan ?course_participant_record)
        )
        (plan_draft_available ?accommodation_plan)
      )
    :effect
      (and
        (plan_assembled ?accommodation_plan)
        (plan_associated_with_section ?accommodation_plan ?course_section)
        (plan_associated_with_instructor ?accommodation_plan ?instructor_role)
        (plan_requires_admin_path_b ?accommodation_plan)
        (not
          (plan_draft_available ?accommodation_plan)
        )
      )
  )
  (:action assemble_accommodation_plan_with_both_admin_paths
    :parameters (?student_profile - student_profile ?course_participant_record - course_participant_record ?course_section - course_section ?instructor_role - instructor_role ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (student_profile_assessed ?student_profile)
        (course_participant_assessed ?course_participant_record)
        (profile_enrolled_in_section ?student_profile ?course_section)
        (participant_associated_with_instructor ?course_participant_record ?instructor_role)
        (section_selected_for_course_path ?course_section)
        (instructor_flagged_course_path ?instructor_role)
        (not
          (student_profile_ready_for_plan ?student_profile)
        )
        (not
          (course_participant_ready_for_plan ?course_participant_record)
        )
        (plan_draft_available ?accommodation_plan)
      )
    :effect
      (and
        (plan_assembled ?accommodation_plan)
        (plan_associated_with_section ?accommodation_plan ?course_section)
        (plan_associated_with_instructor ?accommodation_plan ?instructor_role)
        (plan_requires_admin_path_a ?accommodation_plan)
        (plan_requires_admin_path_b ?accommodation_plan)
        (not
          (plan_draft_available ?accommodation_plan)
        )
      )
  )
  (:action lock_accommodation_plan
    :parameters (?accommodation_plan - accommodation_plan ?student_profile - student_profile ?appointment_slot - appointment_slot)
    :precondition
      (and
        (plan_assembled ?accommodation_plan)
        (student_profile_assessed ?student_profile)
        (scheduled_in_slot ?student_profile ?appointment_slot)
        (not
          (plan_locked ?accommodation_plan)
        )
      )
    :effect (plan_locked ?accommodation_plan)
  )
  (:action attach_supporting_document_to_plan
    :parameters (?case_coordinator - case_coordinator ?supporting_document - supporting_document ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (ready_for_referral ?case_coordinator)
        (coordinator_responsible_for_plan ?case_coordinator ?accommodation_plan)
        (coordinator_has_document ?case_coordinator ?supporting_document)
        (supporting_document_available ?supporting_document)
        (plan_assembled ?accommodation_plan)
        (plan_locked ?accommodation_plan)
        (not
          (supporting_document_attached ?supporting_document)
        )
      )
    :effect
      (and
        (supporting_document_attached ?supporting_document)
        (document_attached_to_plan ?supporting_document ?accommodation_plan)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action activate_coordinator_for_administration
    :parameters (?case_coordinator - case_coordinator ?supporting_document - supporting_document ?accommodation_plan - accommodation_plan ?appointment_slot - appointment_slot)
    :precondition
      (and
        (ready_for_referral ?case_coordinator)
        (coordinator_has_document ?case_coordinator ?supporting_document)
        (supporting_document_attached ?supporting_document)
        (document_attached_to_plan ?supporting_document ?accommodation_plan)
        (scheduled_in_slot ?case_coordinator ?appointment_slot)
        (not
          (plan_requires_admin_path_a ?accommodation_plan)
        )
        (not
          (coordinator_activated ?case_coordinator)
        )
      )
    :effect (coordinator_activated ?case_coordinator)
  )
  (:action assign_approval_item_to_coordinator
    :parameters (?case_coordinator - case_coordinator ?approval_item - approval_item)
    :precondition
      (and
        (ready_for_referral ?case_coordinator)
        (approval_item_available ?approval_item)
        (not
          (coordinator_has_approval_item ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_has_approval_item ?case_coordinator)
        (coordinator_linked_to_approval_item ?case_coordinator ?approval_item)
        (not
          (approval_item_available ?approval_item)
        )
      )
  )
  (:action process_approval_item_for_coordinator
    :parameters (?case_coordinator - case_coordinator ?supporting_document - supporting_document ?accommodation_plan - accommodation_plan ?appointment_slot - appointment_slot ?approval_item - approval_item)
    :precondition
      (and
        (ready_for_referral ?case_coordinator)
        (coordinator_has_document ?case_coordinator ?supporting_document)
        (supporting_document_attached ?supporting_document)
        (document_attached_to_plan ?supporting_document ?accommodation_plan)
        (scheduled_in_slot ?case_coordinator ?appointment_slot)
        (plan_requires_admin_path_a ?accommodation_plan)
        (coordinator_has_approval_item ?case_coordinator)
        (coordinator_linked_to_approval_item ?case_coordinator ?approval_item)
        (not
          (coordinator_activated ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_activated ?case_coordinator)
        (coordinator_approval_stage_two ?case_coordinator)
      )
  )
  (:action initiate_approval_workflow
    :parameters (?case_coordinator - case_coordinator ?specialist_personnel - specialist_personnel ?campus_staff_contact - campus_staff_contact ?supporting_document - supporting_document ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (coordinator_activated ?case_coordinator)
        (coordinator_assigned_specialist ?case_coordinator ?specialist_personnel)
        (referred_to_staff_contact ?case_coordinator ?campus_staff_contact)
        (coordinator_has_document ?case_coordinator ?supporting_document)
        (document_attached_to_plan ?supporting_document ?accommodation_plan)
        (not
          (plan_requires_admin_path_b ?accommodation_plan)
        )
        (not
          (coordinator_approval_in_progress ?case_coordinator)
        )
      )
    :effect (coordinator_approval_in_progress ?case_coordinator)
  )
  (:action initiate_approval_workflow_variant_b
    :parameters (?case_coordinator - case_coordinator ?specialist_personnel - specialist_personnel ?campus_staff_contact - campus_staff_contact ?supporting_document - supporting_document ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (coordinator_activated ?case_coordinator)
        (coordinator_assigned_specialist ?case_coordinator ?specialist_personnel)
        (referred_to_staff_contact ?case_coordinator ?campus_staff_contact)
        (coordinator_has_document ?case_coordinator ?supporting_document)
        (document_attached_to_plan ?supporting_document ?accommodation_plan)
        (plan_requires_admin_path_b ?accommodation_plan)
        (not
          (coordinator_approval_in_progress ?case_coordinator)
        )
      )
    :effect (coordinator_approval_in_progress ?case_coordinator)
  )
  (:action collect_approvals
    :parameters (?case_coordinator - case_coordinator ?specialist_role - specialist_role ?supporting_document - supporting_document ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (coordinator_approval_in_progress ?case_coordinator)
        (coordinator_assigned_specialist_role ?case_coordinator ?specialist_role)
        (coordinator_has_document ?case_coordinator ?supporting_document)
        (document_attached_to_plan ?supporting_document ?accommodation_plan)
        (not
          (plan_requires_admin_path_a ?accommodation_plan)
        )
        (not
          (plan_requires_admin_path_b ?accommodation_plan)
        )
        (not
          (approvals_collected ?case_coordinator)
        )
      )
    :effect (approvals_collected ?case_coordinator)
  )
  (:action collect_approvals_and_assign_approver_path_a
    :parameters (?case_coordinator - case_coordinator ?specialist_role - specialist_role ?supporting_document - supporting_document ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (coordinator_approval_in_progress ?case_coordinator)
        (coordinator_assigned_specialist_role ?case_coordinator ?specialist_role)
        (coordinator_has_document ?case_coordinator ?supporting_document)
        (document_attached_to_plan ?supporting_document ?accommodation_plan)
        (plan_requires_admin_path_a ?accommodation_plan)
        (not
          (plan_requires_admin_path_b ?accommodation_plan)
        )
        (not
          (approvals_collected ?case_coordinator)
        )
      )
    :effect
      (and
        (approvals_collected ?case_coordinator)
        (coordinator_approver_assigned ?case_coordinator)
      )
  )
  (:action collect_approvals_and_assign_approver_path_b
    :parameters (?case_coordinator - case_coordinator ?specialist_role - specialist_role ?supporting_document - supporting_document ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (coordinator_approval_in_progress ?case_coordinator)
        (coordinator_assigned_specialist_role ?case_coordinator ?specialist_role)
        (coordinator_has_document ?case_coordinator ?supporting_document)
        (document_attached_to_plan ?supporting_document ?accommodation_plan)
        (not
          (plan_requires_admin_path_a ?accommodation_plan)
        )
        (plan_requires_admin_path_b ?accommodation_plan)
        (not
          (approvals_collected ?case_coordinator)
        )
      )
    :effect
      (and
        (approvals_collected ?case_coordinator)
        (coordinator_approver_assigned ?case_coordinator)
      )
  )
  (:action collect_approvals_and_assign_approver_both_paths
    :parameters (?case_coordinator - case_coordinator ?specialist_role - specialist_role ?supporting_document - supporting_document ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (coordinator_approval_in_progress ?case_coordinator)
        (coordinator_assigned_specialist_role ?case_coordinator ?specialist_role)
        (coordinator_has_document ?case_coordinator ?supporting_document)
        (document_attached_to_plan ?supporting_document ?accommodation_plan)
        (plan_requires_admin_path_a ?accommodation_plan)
        (plan_requires_admin_path_b ?accommodation_plan)
        (not
          (approvals_collected ?case_coordinator)
        )
      )
    :effect
      (and
        (approvals_collected ?case_coordinator)
        (coordinator_approver_assigned ?case_coordinator)
      )
  )
  (:action finalize_coordinator_signoff
    :parameters (?case_coordinator - case_coordinator)
    :precondition
      (and
        (approvals_collected ?case_coordinator)
        (not
          (coordinator_approver_assigned ?case_coordinator)
        )
        (not
          (coordinator_signoff_recorded ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_signoff_recorded ?case_coordinator)
        (ready_for_implementation ?case_coordinator)
      )
  )
  (:action assign_program_track_to_case
    :parameters (?case_coordinator - case_coordinator ?program_track - program_track)
    :precondition
      (and
        (approvals_collected ?case_coordinator)
        (coordinator_approver_assigned ?case_coordinator)
        (program_track_available ?program_track)
      )
    :effect
      (and
        (coordinator_assigned_program_track ?case_coordinator ?program_track)
        (not
          (program_track_available ?program_track)
        )
      )
  )
  (:action prepare_coordinator_for_final_signoff
    :parameters (?case_coordinator - case_coordinator ?student_profile - student_profile ?course_participant_record - course_participant_record ?appointment_slot - appointment_slot ?program_track - program_track)
    :precondition
      (and
        (approvals_collected ?case_coordinator)
        (coordinator_approver_assigned ?case_coordinator)
        (coordinator_assigned_program_track ?case_coordinator ?program_track)
        (coordinator_responsible_for_profile ?case_coordinator ?student_profile)
        (coordinator_responsible_for_participant ?case_coordinator ?course_participant_record)
        (student_profile_ready_for_plan ?student_profile)
        (course_participant_ready_for_plan ?course_participant_record)
        (scheduled_in_slot ?case_coordinator ?appointment_slot)
        (not
          (coordinator_ready_for_signoff ?case_coordinator)
        )
      )
    :effect (coordinator_ready_for_signoff ?case_coordinator)
  )
  (:action record_final_signoff_and_mark_case_ready
    :parameters (?case_coordinator - case_coordinator)
    :precondition
      (and
        (approvals_collected ?case_coordinator)
        (coordinator_ready_for_signoff ?case_coordinator)
        (not
          (coordinator_signoff_recorded ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_signoff_recorded ?case_coordinator)
        (ready_for_implementation ?case_coordinator)
      )
  )
  (:action engage_approver_for_coordinator
    :parameters (?case_coordinator - case_coordinator ?approver_role - approver_role ?appointment_slot - appointment_slot)
    :precondition
      (and
        (ready_for_referral ?case_coordinator)
        (scheduled_in_slot ?case_coordinator ?appointment_slot)
        (approver_available ?approver_role)
        (coordinator_has_approver_role ?case_coordinator ?approver_role)
        (not
          (coordinator_approver_engaged ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_approver_engaged ?case_coordinator)
        (not
          (approver_available ?approver_role)
        )
      )
  )
  (:action submit_approval_request
    :parameters (?case_coordinator - case_coordinator ?campus_staff_contact - campus_staff_contact)
    :precondition
      (and
        (coordinator_approver_engaged ?case_coordinator)
        (referred_to_staff_contact ?case_coordinator ?campus_staff_contact)
        (not
          (approval_request_submitted ?case_coordinator)
        )
      )
    :effect (approval_request_submitted ?case_coordinator)
  )
  (:action record_approver_confirmation
    :parameters (?case_coordinator - case_coordinator ?specialist_role - specialist_role)
    :precondition
      (and
        (approval_request_submitted ?case_coordinator)
        (coordinator_assigned_specialist_role ?case_coordinator ?specialist_role)
        (not
          (approval_confirmed ?case_coordinator)
        )
      )
    :effect (approval_confirmed ?case_coordinator)
  )
  (:action finalize_approval_and_mark_ready
    :parameters (?case_coordinator - case_coordinator)
    :precondition
      (and
        (approval_confirmed ?case_coordinator)
        (not
          (coordinator_signoff_recorded ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_signoff_recorded ?case_coordinator)
        (ready_for_implementation ?case_coordinator)
      )
  )
  (:action mark_profile_ready_for_implementation
    :parameters (?student_profile - student_profile ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (student_profile_assessed ?student_profile)
        (student_profile_ready_for_plan ?student_profile)
        (plan_assembled ?accommodation_plan)
        (plan_locked ?accommodation_plan)
        (not
          (ready_for_implementation ?student_profile)
        )
      )
    :effect (ready_for_implementation ?student_profile)
  )
  (:action mark_participant_ready_for_implementation
    :parameters (?course_participant_record - course_participant_record ?accommodation_plan - accommodation_plan)
    :precondition
      (and
        (course_participant_assessed ?course_participant_record)
        (course_participant_ready_for_plan ?course_participant_record)
        (plan_assembled ?accommodation_plan)
        (plan_locked ?accommodation_plan)
        (not
          (ready_for_implementation ?course_participant_record)
        )
      )
    :effect (ready_for_implementation ?course_participant_record)
  )
  (:action record_consent_and_create_followup_token
    :parameters (?student_case - student_case ?consent_token - consent_token ?appointment_slot - appointment_slot)
    :precondition
      (and
        (ready_for_implementation ?student_case)
        (scheduled_in_slot ?student_case ?appointment_slot)
        (consent_token_available ?consent_token)
        (not
          (consent_recorded ?student_case)
        )
      )
    :effect
      (and
        (consent_recorded ?student_case)
        (linked_to_consent_token ?student_case ?consent_token)
        (not
          (consent_token_available ?consent_token)
        )
      )
  )
  (:action finalize_service_allocation_for_profile
    :parameters (?student_profile - student_profile ?support_service_unit - support_service_unit ?consent_token - consent_token)
    :precondition
      (and
        (consent_recorded ?student_profile)
        (assigned_to_support_unit ?student_profile ?support_service_unit)
        (linked_to_consent_token ?student_profile ?consent_token)
        (not
          (allocation_confirmed ?student_profile)
        )
      )
    :effect
      (and
        (allocation_confirmed ?student_profile)
        (support_unit_available ?support_service_unit)
        (consent_token_available ?consent_token)
      )
  )
  (:action finalize_service_allocation_for_participant
    :parameters (?course_participant_record - course_participant_record ?support_service_unit - support_service_unit ?consent_token - consent_token)
    :precondition
      (and
        (consent_recorded ?course_participant_record)
        (assigned_to_support_unit ?course_participant_record ?support_service_unit)
        (linked_to_consent_token ?course_participant_record ?consent_token)
        (not
          (allocation_confirmed ?course_participant_record)
        )
      )
    :effect
      (and
        (allocation_confirmed ?course_participant_record)
        (support_unit_available ?support_service_unit)
        (consent_token_available ?consent_token)
      )
  )
  (:action finalize_service_allocation_for_coordinator
    :parameters (?case_coordinator - case_coordinator ?support_service_unit - support_service_unit ?consent_token - consent_token)
    :precondition
      (and
        (consent_recorded ?case_coordinator)
        (assigned_to_support_unit ?case_coordinator ?support_service_unit)
        (linked_to_consent_token ?case_coordinator ?consent_token)
        (not
          (allocation_confirmed ?case_coordinator)
        )
      )
    :effect
      (and
        (allocation_confirmed ?case_coordinator)
        (support_unit_available ?support_service_unit)
        (consent_token_available ?consent_token)
      )
  )
)

(define (domain campus_closure_makeup_calendar_repair)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object schedule_category - object venue_category - object case_category - object exception_case - case_category recovery_resource_token - resource_category curricular_component - resource_category staff_member - resource_category policy_reference - resource_category funding_allocation - resource_category appeal_form - resource_category replacement_instructor - resource_category operational_protocol - resource_category evidence_package - schedule_category validation_document - schedule_category external_authority_record - schedule_category makeup_time_slot - venue_category delivery_option - venue_category makeup_calendar - venue_category academic_component_container - exception_case administrative_component_container - exception_case course_section - academic_component_container alternate_section - academic_component_container administrative_agent - administrative_component_container)
  (:predicates
    (subject_opened ?exception_case - exception_case)
    (subject_verified ?exception_case - exception_case)
    (subject_triaged ?exception_case - exception_case)
    (administrative_correction_applied ?exception_case - exception_case)
    (ready_for_execution ?exception_case - exception_case)
    (subject_adjudicated ?exception_case - exception_case)
    (resource_token_available ?recovery_resource_token - recovery_resource_token)
    (subject_allocated_resource ?exception_case - exception_case ?recovery_resource_token - recovery_resource_token)
    (curricular_component_available ?curricular_component - curricular_component)
    (subject_attached_component ?exception_case - exception_case ?curricular_component - curricular_component)
    (staff_available ?staff_member - staff_member)
    (subject_assigned_staff ?exception_case - exception_case ?staff_member - staff_member)
    (evidence_package_available ?evidence_package - evidence_package)
    (section_attached_evidence ?course_section - course_section ?evidence_package - evidence_package)
    (alternate_section_attached_evidence ?alternate_section - alternate_section ?evidence_package - evidence_package)
    (section_candidate_slot ?course_section - course_section ?makeup_time_slot - makeup_time_slot)
    (slot_confirmed ?makeup_time_slot - makeup_time_slot)
    (slot_provisional ?makeup_time_slot - makeup_time_slot)
    (section_ready_for_calendar ?course_section - course_section)
    (alternate_section_has_delivery_option ?alternate_section - alternate_section ?delivery_venue_or_mode - delivery_option)
    (delivery_option_confirmed ?delivery_venue_or_mode - delivery_option)
    (delivery_option_provisional ?delivery_venue_or_mode - delivery_option)
    (alternate_section_ready_for_calendar ?alternate_section - alternate_section)
    (makeup_calendar_available ?makeup_calendar - makeup_calendar)
    (makeup_calendar_prepared ?makeup_calendar - makeup_calendar)
    (makeup_calendar_includes_slot ?makeup_calendar - makeup_calendar ?makeup_time_slot - makeup_time_slot)
    (makeup_calendar_includes_delivery_option ?makeup_calendar - makeup_calendar ?delivery_venue_or_mode - delivery_option)
    (makeup_calendar_requires_instructor_assignment ?makeup_calendar - makeup_calendar)
    (makeup_calendar_requires_external_approval ?makeup_calendar - makeup_calendar)
    (makeup_calendar_finalized ?makeup_calendar - makeup_calendar)
    (agent_responsible_for_section ?administrative_agent - administrative_agent ?course_section - course_section)
    (agent_responsible_for_alternate_section ?administrative_agent - administrative_agent ?alternate_section - alternate_section)
    (agent_assigned_calendar ?administrative_agent - administrative_agent ?makeup_calendar - makeup_calendar)
    (validation_document_available ?validation_document - validation_document)
    (agent_has_validation_document ?administrative_agent - administrative_agent ?validation_document - validation_document)
    (validation_document_verified ?validation_document - validation_document)
    (validation_document_attaches_to_calendar ?validation_document - validation_document ?makeup_calendar - makeup_calendar)
    (agent_validated ?administrative_agent - administrative_agent)
    (agent_authorized ?administrative_agent - administrative_agent)
    (agent_ready_for_finalization ?administrative_agent - administrative_agent)
    (agent_has_policy_reference ?administrative_agent - administrative_agent)
    (agent_policy_validated ?administrative_agent - administrative_agent)
    (agent_certified ?administrative_agent - administrative_agent)
    (agent_finalized ?administrative_agent - administrative_agent)
    (external_authority_record_available ?external_authority_record - external_authority_record)
    (agent_has_external_authority_record ?administrative_agent - administrative_agent ?external_authority_record - external_authority_record)
    (agent_external_approval_obtained ?administrative_agent - administrative_agent)
    (agent_in_external_review ?administrative_agent - administrative_agent)
    (agent_external_approval_confirmed ?administrative_agent - administrative_agent)
    (policy_reference_available ?policy_reference - policy_reference)
    (agent_attached_policy_reference ?administrative_agent - administrative_agent ?policy_reference - policy_reference)
    (funding_allocation_available ?funding_allocation - funding_allocation)
    (agent_received_funding_allocation ?administrative_agent - administrative_agent ?funding_allocation - funding_allocation)
    (replacement_instructor_available ?replacement_instructor - replacement_instructor)
    (agent_assigned_replacement_instructor ?administrative_agent - administrative_agent ?replacement_instructor - replacement_instructor)
    (operational_protocol_available ?operational_protocol - operational_protocol)
    (agent_assigned_operational_protocol ?administrative_agent - administrative_agent ?operational_protocol - operational_protocol)
    (appeal_form_available ?appeal_form - appeal_form)
    (subject_has_appeal_form ?exception_case - exception_case ?appeal_form - appeal_form)
    (section_slot_assigned ?course_section - course_section)
    (alternate_section_slot_assigned ?alternate_section - alternate_section)
    (agent_final_certification_recorded ?administrative_agent - administrative_agent)
  )
  (:action register_exception_case
    :parameters (?exception_case - exception_case)
    :precondition
      (and
        (not
          (subject_opened ?exception_case)
        )
        (not
          (administrative_correction_applied ?exception_case)
        )
      )
    :effect (subject_opened ?exception_case)
  )
  (:action allocate_resource_to_case
    :parameters (?exception_case - exception_case ?recovery_resource_token - recovery_resource_token)
    :precondition
      (and
        (subject_opened ?exception_case)
        (not
          (subject_triaged ?exception_case)
        )
        (resource_token_available ?recovery_resource_token)
      )
    :effect
      (and
        (subject_triaged ?exception_case)
        (subject_allocated_resource ?exception_case ?recovery_resource_token)
        (not
          (resource_token_available ?recovery_resource_token)
        )
      )
  )
  (:action attach_component_to_case
    :parameters (?exception_case - exception_case ?curricular_component - curricular_component)
    :precondition
      (and
        (subject_opened ?exception_case)
        (subject_triaged ?exception_case)
        (curricular_component_available ?curricular_component)
      )
    :effect
      (and
        (subject_attached_component ?exception_case ?curricular_component)
        (not
          (curricular_component_available ?curricular_component)
        )
      )
  )
  (:action validate_case
    :parameters (?exception_case - exception_case ?curricular_component - curricular_component)
    :precondition
      (and
        (subject_opened ?exception_case)
        (subject_triaged ?exception_case)
        (subject_attached_component ?exception_case ?curricular_component)
        (not
          (subject_verified ?exception_case)
        )
      )
    :effect (subject_verified ?exception_case)
  )
  (:action unassign_component_from_case
    :parameters (?exception_case - exception_case ?curricular_component - curricular_component)
    :precondition
      (and
        (subject_attached_component ?exception_case ?curricular_component)
      )
    :effect
      (and
        (curricular_component_available ?curricular_component)
        (not
          (subject_attached_component ?exception_case ?curricular_component)
        )
      )
  )
  (:action assign_staff_to_case
    :parameters (?exception_case - exception_case ?staff_member - staff_member)
    :precondition
      (and
        (subject_verified ?exception_case)
        (staff_available ?staff_member)
      )
    :effect
      (and
        (subject_assigned_staff ?exception_case ?staff_member)
        (not
          (staff_available ?staff_member)
        )
      )
  )
  (:action unassign_staff_from_case
    :parameters (?exception_case - exception_case ?staff_member - staff_member)
    :precondition
      (and
        (subject_assigned_staff ?exception_case ?staff_member)
      )
    :effect
      (and
        (staff_available ?staff_member)
        (not
          (subject_assigned_staff ?exception_case ?staff_member)
        )
      )
  )
  (:action assign_replacement_instructor_to_agent
    :parameters (?administrative_agent - administrative_agent ?replacement_instructor - replacement_instructor)
    :precondition
      (and
        (subject_verified ?administrative_agent)
        (replacement_instructor_available ?replacement_instructor)
      )
    :effect
      (and
        (agent_assigned_replacement_instructor ?administrative_agent ?replacement_instructor)
        (not
          (replacement_instructor_available ?replacement_instructor)
        )
      )
  )
  (:action unassign_replacement_instructor_from_agent
    :parameters (?administrative_agent - administrative_agent ?replacement_instructor - replacement_instructor)
    :precondition
      (and
        (agent_assigned_replacement_instructor ?administrative_agent ?replacement_instructor)
      )
    :effect
      (and
        (replacement_instructor_available ?replacement_instructor)
        (not
          (agent_assigned_replacement_instructor ?administrative_agent ?replacement_instructor)
        )
      )
  )
  (:action assign_operational_protocol_to_agent
    :parameters (?administrative_agent - administrative_agent ?operational_protocol - operational_protocol)
    :precondition
      (and
        (subject_verified ?administrative_agent)
        (operational_protocol_available ?operational_protocol)
      )
    :effect
      (and
        (agent_assigned_operational_protocol ?administrative_agent ?operational_protocol)
        (not
          (operational_protocol_available ?operational_protocol)
        )
      )
  )
  (:action remove_operational_protocol_from_agent
    :parameters (?administrative_agent - administrative_agent ?operational_protocol - operational_protocol)
    :precondition
      (and
        (agent_assigned_operational_protocol ?administrative_agent ?operational_protocol)
      )
    :effect
      (and
        (operational_protocol_available ?operational_protocol)
        (not
          (agent_assigned_operational_protocol ?administrative_agent ?operational_protocol)
        )
      )
  )
  (:action reserve_makeup_slot
    :parameters (?course_section - course_section ?makeup_time_slot - makeup_time_slot ?curricular_component - curricular_component)
    :precondition
      (and
        (subject_verified ?course_section)
        (subject_attached_component ?course_section ?curricular_component)
        (section_candidate_slot ?course_section ?makeup_time_slot)
        (not
          (slot_confirmed ?makeup_time_slot)
        )
        (not
          (slot_provisional ?makeup_time_slot)
        )
      )
    :effect (slot_confirmed ?makeup_time_slot)
  )
  (:action confirm_slot_with_staff_assignment
    :parameters (?course_section - course_section ?makeup_time_slot - makeup_time_slot ?staff_member - staff_member)
    :precondition
      (and
        (subject_verified ?course_section)
        (subject_assigned_staff ?course_section ?staff_member)
        (section_candidate_slot ?course_section ?makeup_time_slot)
        (slot_confirmed ?makeup_time_slot)
        (not
          (section_slot_assigned ?course_section)
        )
      )
    :effect
      (and
        (section_slot_assigned ?course_section)
        (section_ready_for_calendar ?course_section)
      )
  )
  (:action attach_evidence_and_reserve_slot
    :parameters (?course_section - course_section ?makeup_time_slot - makeup_time_slot ?evidence_package - evidence_package)
    :precondition
      (and
        (subject_verified ?course_section)
        (section_candidate_slot ?course_section ?makeup_time_slot)
        (evidence_package_available ?evidence_package)
        (not
          (section_slot_assigned ?course_section)
        )
      )
    :effect
      (and
        (slot_provisional ?makeup_time_slot)
        (section_slot_assigned ?course_section)
        (section_attached_evidence ?course_section ?evidence_package)
        (not
          (evidence_package_available ?evidence_package)
        )
      )
  )
  (:action finalize_slot_reservation
    :parameters (?course_section - course_section ?makeup_time_slot - makeup_time_slot ?curricular_component - curricular_component ?evidence_package - evidence_package)
    :precondition
      (and
        (subject_verified ?course_section)
        (subject_attached_component ?course_section ?curricular_component)
        (section_candidate_slot ?course_section ?makeup_time_slot)
        (slot_provisional ?makeup_time_slot)
        (section_attached_evidence ?course_section ?evidence_package)
        (not
          (section_ready_for_calendar ?course_section)
        )
      )
    :effect
      (and
        (slot_confirmed ?makeup_time_slot)
        (section_ready_for_calendar ?course_section)
        (evidence_package_available ?evidence_package)
        (not
          (section_attached_evidence ?course_section ?evidence_package)
        )
      )
  )
  (:action reserve_alternate_section_slot
    :parameters (?alternate_section - alternate_section ?delivery_venue_or_mode - delivery_option ?curricular_component - curricular_component)
    :precondition
      (and
        (subject_verified ?alternate_section)
        (subject_attached_component ?alternate_section ?curricular_component)
        (alternate_section_has_delivery_option ?alternate_section ?delivery_venue_or_mode)
        (not
          (delivery_option_confirmed ?delivery_venue_or_mode)
        )
        (not
          (delivery_option_provisional ?delivery_venue_or_mode)
        )
      )
    :effect (delivery_option_confirmed ?delivery_venue_or_mode)
  )
  (:action confirm_alternate_slot_with_staff
    :parameters (?alternate_section - alternate_section ?delivery_venue_or_mode - delivery_option ?staff_member - staff_member)
    :precondition
      (and
        (subject_verified ?alternate_section)
        (subject_assigned_staff ?alternate_section ?staff_member)
        (alternate_section_has_delivery_option ?alternate_section ?delivery_venue_or_mode)
        (delivery_option_confirmed ?delivery_venue_or_mode)
        (not
          (alternate_section_slot_assigned ?alternate_section)
        )
      )
    :effect
      (and
        (alternate_section_slot_assigned ?alternate_section)
        (alternate_section_ready_for_calendar ?alternate_section)
      )
  )
  (:action attach_evidence_and_reserve_alternate_slot
    :parameters (?alternate_section - alternate_section ?delivery_venue_or_mode - delivery_option ?evidence_package - evidence_package)
    :precondition
      (and
        (subject_verified ?alternate_section)
        (alternate_section_has_delivery_option ?alternate_section ?delivery_venue_or_mode)
        (evidence_package_available ?evidence_package)
        (not
          (alternate_section_slot_assigned ?alternate_section)
        )
      )
    :effect
      (and
        (delivery_option_provisional ?delivery_venue_or_mode)
        (alternate_section_slot_assigned ?alternate_section)
        (alternate_section_attached_evidence ?alternate_section ?evidence_package)
        (not
          (evidence_package_available ?evidence_package)
        )
      )
  )
  (:action finalize_alternate_slot_reservation
    :parameters (?alternate_section - alternate_section ?delivery_venue_or_mode - delivery_option ?curricular_component - curricular_component ?evidence_package - evidence_package)
    :precondition
      (and
        (subject_verified ?alternate_section)
        (subject_attached_component ?alternate_section ?curricular_component)
        (alternate_section_has_delivery_option ?alternate_section ?delivery_venue_or_mode)
        (delivery_option_provisional ?delivery_venue_or_mode)
        (alternate_section_attached_evidence ?alternate_section ?evidence_package)
        (not
          (alternate_section_ready_for_calendar ?alternate_section)
        )
      )
    :effect
      (and
        (delivery_option_confirmed ?delivery_venue_or_mode)
        (alternate_section_ready_for_calendar ?alternate_section)
        (evidence_package_available ?evidence_package)
        (not
          (alternate_section_attached_evidence ?alternate_section ?evidence_package)
        )
      )
  )
  (:action assemble_makeup_calendar_instance
    :parameters (?course_section - course_section ?alternate_section - alternate_section ?makeup_time_slot - makeup_time_slot ?delivery_venue_or_mode - delivery_option ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (section_slot_assigned ?course_section)
        (alternate_section_slot_assigned ?alternate_section)
        (section_candidate_slot ?course_section ?makeup_time_slot)
        (alternate_section_has_delivery_option ?alternate_section ?delivery_venue_or_mode)
        (slot_confirmed ?makeup_time_slot)
        (delivery_option_confirmed ?delivery_venue_or_mode)
        (section_ready_for_calendar ?course_section)
        (alternate_section_ready_for_calendar ?alternate_section)
        (makeup_calendar_available ?makeup_calendar)
      )
    :effect
      (and
        (makeup_calendar_prepared ?makeup_calendar)
        (makeup_calendar_includes_slot ?makeup_calendar ?makeup_time_slot)
        (makeup_calendar_includes_delivery_option ?makeup_calendar ?delivery_venue_or_mode)
        (not
          (makeup_calendar_available ?makeup_calendar)
        )
      )
  )
  (:action assemble_makeup_calendar_with_instructor_requirement
    :parameters (?course_section - course_section ?alternate_section - alternate_section ?makeup_time_slot - makeup_time_slot ?delivery_venue_or_mode - delivery_option ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (section_slot_assigned ?course_section)
        (alternate_section_slot_assigned ?alternate_section)
        (section_candidate_slot ?course_section ?makeup_time_slot)
        (alternate_section_has_delivery_option ?alternate_section ?delivery_venue_or_mode)
        (slot_provisional ?makeup_time_slot)
        (delivery_option_confirmed ?delivery_venue_or_mode)
        (not
          (section_ready_for_calendar ?course_section)
        )
        (alternate_section_ready_for_calendar ?alternate_section)
        (makeup_calendar_available ?makeup_calendar)
      )
    :effect
      (and
        (makeup_calendar_prepared ?makeup_calendar)
        (makeup_calendar_includes_slot ?makeup_calendar ?makeup_time_slot)
        (makeup_calendar_includes_delivery_option ?makeup_calendar ?delivery_venue_or_mode)
        (makeup_calendar_requires_instructor_assignment ?makeup_calendar)
        (not
          (makeup_calendar_available ?makeup_calendar)
        )
      )
  )
  (:action assemble_makeup_calendar_with_external_approval
    :parameters (?course_section - course_section ?alternate_section - alternate_section ?makeup_time_slot - makeup_time_slot ?delivery_venue_or_mode - delivery_option ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (section_slot_assigned ?course_section)
        (alternate_section_slot_assigned ?alternate_section)
        (section_candidate_slot ?course_section ?makeup_time_slot)
        (alternate_section_has_delivery_option ?alternate_section ?delivery_venue_or_mode)
        (slot_confirmed ?makeup_time_slot)
        (delivery_option_provisional ?delivery_venue_or_mode)
        (section_ready_for_calendar ?course_section)
        (not
          (alternate_section_ready_for_calendar ?alternate_section)
        )
        (makeup_calendar_available ?makeup_calendar)
      )
    :effect
      (and
        (makeup_calendar_prepared ?makeup_calendar)
        (makeup_calendar_includes_slot ?makeup_calendar ?makeup_time_slot)
        (makeup_calendar_includes_delivery_option ?makeup_calendar ?delivery_venue_or_mode)
        (makeup_calendar_requires_external_approval ?makeup_calendar)
        (not
          (makeup_calendar_available ?makeup_calendar)
        )
      )
  )
  (:action assemble_comprehensive_makeup_calendar
    :parameters (?course_section - course_section ?alternate_section - alternate_section ?makeup_time_slot - makeup_time_slot ?delivery_venue_or_mode - delivery_option ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (section_slot_assigned ?course_section)
        (alternate_section_slot_assigned ?alternate_section)
        (section_candidate_slot ?course_section ?makeup_time_slot)
        (alternate_section_has_delivery_option ?alternate_section ?delivery_venue_or_mode)
        (slot_provisional ?makeup_time_slot)
        (delivery_option_provisional ?delivery_venue_or_mode)
        (not
          (section_ready_for_calendar ?course_section)
        )
        (not
          (alternate_section_ready_for_calendar ?alternate_section)
        )
        (makeup_calendar_available ?makeup_calendar)
      )
    :effect
      (and
        (makeup_calendar_prepared ?makeup_calendar)
        (makeup_calendar_includes_slot ?makeup_calendar ?makeup_time_slot)
        (makeup_calendar_includes_delivery_option ?makeup_calendar ?delivery_venue_or_mode)
        (makeup_calendar_requires_instructor_assignment ?makeup_calendar)
        (makeup_calendar_requires_external_approval ?makeup_calendar)
        (not
          (makeup_calendar_available ?makeup_calendar)
        )
      )
  )
  (:action materialize_makeup_calendar
    :parameters (?makeup_calendar - makeup_calendar ?course_section - course_section ?curricular_component - curricular_component)
    :precondition
      (and
        (makeup_calendar_prepared ?makeup_calendar)
        (section_slot_assigned ?course_section)
        (subject_attached_component ?course_section ?curricular_component)
        (not
          (makeup_calendar_finalized ?makeup_calendar)
        )
      )
    :effect (makeup_calendar_finalized ?makeup_calendar)
  )
  (:action attach_validation_document_to_calendar
    :parameters (?administrative_agent - administrative_agent ?validation_document - validation_document ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (subject_verified ?administrative_agent)
        (agent_assigned_calendar ?administrative_agent ?makeup_calendar)
        (agent_has_validation_document ?administrative_agent ?validation_document)
        (validation_document_available ?validation_document)
        (makeup_calendar_prepared ?makeup_calendar)
        (makeup_calendar_finalized ?makeup_calendar)
        (not
          (validation_document_verified ?validation_document)
        )
      )
    :effect
      (and
        (validation_document_verified ?validation_document)
        (validation_document_attaches_to_calendar ?validation_document ?makeup_calendar)
        (not
          (validation_document_available ?validation_document)
        )
      )
  )
  (:action validate_agent_with_document
    :parameters (?administrative_agent - administrative_agent ?validation_document - validation_document ?makeup_calendar - makeup_calendar ?curricular_component - curricular_component)
    :precondition
      (and
        (subject_verified ?administrative_agent)
        (agent_has_validation_document ?administrative_agent ?validation_document)
        (validation_document_verified ?validation_document)
        (validation_document_attaches_to_calendar ?validation_document ?makeup_calendar)
        (subject_attached_component ?administrative_agent ?curricular_component)
        (not
          (makeup_calendar_requires_instructor_assignment ?makeup_calendar)
        )
        (not
          (agent_validated ?administrative_agent)
        )
      )
    :effect (agent_validated ?administrative_agent)
  )
  (:action attach_policy_reference_to_agent
    :parameters (?administrative_agent - administrative_agent ?policy_reference - policy_reference)
    :precondition
      (and
        (subject_verified ?administrative_agent)
        (policy_reference_available ?policy_reference)
        (not
          (agent_has_policy_reference ?administrative_agent)
        )
      )
    :effect
      (and
        (agent_has_policy_reference ?administrative_agent)
        (agent_attached_policy_reference ?administrative_agent ?policy_reference)
        (not
          (policy_reference_available ?policy_reference)
        )
      )
  )
  (:action apply_policy_and_activate_agent
    :parameters (?administrative_agent - administrative_agent ?validation_document - validation_document ?makeup_calendar - makeup_calendar ?curricular_component - curricular_component ?policy_reference - policy_reference)
    :precondition
      (and
        (subject_verified ?administrative_agent)
        (agent_has_validation_document ?administrative_agent ?validation_document)
        (validation_document_verified ?validation_document)
        (validation_document_attaches_to_calendar ?validation_document ?makeup_calendar)
        (subject_attached_component ?administrative_agent ?curricular_component)
        (makeup_calendar_requires_instructor_assignment ?makeup_calendar)
        (agent_has_policy_reference ?administrative_agent)
        (agent_attached_policy_reference ?administrative_agent ?policy_reference)
        (not
          (agent_validated ?administrative_agent)
        )
      )
    :effect
      (and
        (agent_validated ?administrative_agent)
        (agent_policy_validated ?administrative_agent)
      )
  )
  (:action authorize_agent_after_instructor_assignment
    :parameters (?administrative_agent - administrative_agent ?replacement_instructor - replacement_instructor ?staff_member - staff_member ?validation_document - validation_document ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (agent_validated ?administrative_agent)
        (agent_assigned_replacement_instructor ?administrative_agent ?replacement_instructor)
        (subject_assigned_staff ?administrative_agent ?staff_member)
        (agent_has_validation_document ?administrative_agent ?validation_document)
        (validation_document_attaches_to_calendar ?validation_document ?makeup_calendar)
        (not
          (makeup_calendar_requires_external_approval ?makeup_calendar)
        )
        (not
          (agent_authorized ?administrative_agent)
        )
      )
    :effect (agent_authorized ?administrative_agent)
  )
  (:action authorize_agent_after_instructor_assignment_variant
    :parameters (?administrative_agent - administrative_agent ?replacement_instructor - replacement_instructor ?staff_member - staff_member ?validation_document - validation_document ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (agent_validated ?administrative_agent)
        (agent_assigned_replacement_instructor ?administrative_agent ?replacement_instructor)
        (subject_assigned_staff ?administrative_agent ?staff_member)
        (agent_has_validation_document ?administrative_agent ?validation_document)
        (validation_document_attaches_to_calendar ?validation_document ?makeup_calendar)
        (makeup_calendar_requires_external_approval ?makeup_calendar)
        (not
          (agent_authorized ?administrative_agent)
        )
      )
    :effect (agent_authorized ?administrative_agent)
  )
  (:action authorize_agent_with_operational_protocol
    :parameters (?administrative_agent - administrative_agent ?operational_protocol - operational_protocol ?validation_document - validation_document ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (agent_authorized ?administrative_agent)
        (agent_assigned_operational_protocol ?administrative_agent ?operational_protocol)
        (agent_has_validation_document ?administrative_agent ?validation_document)
        (validation_document_attaches_to_calendar ?validation_document ?makeup_calendar)
        (not
          (makeup_calendar_requires_instructor_assignment ?makeup_calendar)
        )
        (not
          (makeup_calendar_requires_external_approval ?makeup_calendar)
        )
        (not
          (agent_ready_for_finalization ?administrative_agent)
        )
      )
    :effect (agent_ready_for_finalization ?administrative_agent)
  )
  (:action authorize_and_certify_agent
    :parameters (?administrative_agent - administrative_agent ?operational_protocol - operational_protocol ?validation_document - validation_document ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (agent_authorized ?administrative_agent)
        (agent_assigned_operational_protocol ?administrative_agent ?operational_protocol)
        (agent_has_validation_document ?administrative_agent ?validation_document)
        (validation_document_attaches_to_calendar ?validation_document ?makeup_calendar)
        (makeup_calendar_requires_instructor_assignment ?makeup_calendar)
        (not
          (makeup_calendar_requires_external_approval ?makeup_calendar)
        )
        (not
          (agent_ready_for_finalization ?administrative_agent)
        )
      )
    :effect
      (and
        (agent_ready_for_finalization ?administrative_agent)
        (agent_certified ?administrative_agent)
      )
  )
  (:action authorize_and_certify_agent_alternate
    :parameters (?administrative_agent - administrative_agent ?operational_protocol - operational_protocol ?validation_document - validation_document ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (agent_authorized ?administrative_agent)
        (agent_assigned_operational_protocol ?administrative_agent ?operational_protocol)
        (agent_has_validation_document ?administrative_agent ?validation_document)
        (validation_document_attaches_to_calendar ?validation_document ?makeup_calendar)
        (not
          (makeup_calendar_requires_instructor_assignment ?makeup_calendar)
        )
        (makeup_calendar_requires_external_approval ?makeup_calendar)
        (not
          (agent_ready_for_finalization ?administrative_agent)
        )
      )
    :effect
      (and
        (agent_ready_for_finalization ?administrative_agent)
        (agent_certified ?administrative_agent)
      )
  )
  (:action authorize_and_certify_agent_full
    :parameters (?administrative_agent - administrative_agent ?operational_protocol - operational_protocol ?validation_document - validation_document ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (agent_authorized ?administrative_agent)
        (agent_assigned_operational_protocol ?administrative_agent ?operational_protocol)
        (agent_has_validation_document ?administrative_agent ?validation_document)
        (validation_document_attaches_to_calendar ?validation_document ?makeup_calendar)
        (makeup_calendar_requires_instructor_assignment ?makeup_calendar)
        (makeup_calendar_requires_external_approval ?makeup_calendar)
        (not
          (agent_ready_for_finalization ?administrative_agent)
        )
      )
    :effect
      (and
        (agent_ready_for_finalization ?administrative_agent)
        (agent_certified ?administrative_agent)
      )
  )
  (:action record_agent_final_approval
    :parameters (?administrative_agent - administrative_agent)
    :precondition
      (and
        (agent_ready_for_finalization ?administrative_agent)
        (not
          (agent_certified ?administrative_agent)
        )
        (not
          (agent_final_certification_recorded ?administrative_agent)
        )
      )
    :effect
      (and
        (agent_final_certification_recorded ?administrative_agent)
        (ready_for_execution ?administrative_agent)
      )
  )
  (:action assign_funding_to_agent
    :parameters (?administrative_agent - administrative_agent ?funding_allocation - funding_allocation)
    :precondition
      (and
        (agent_ready_for_finalization ?administrative_agent)
        (agent_certified ?administrative_agent)
        (funding_allocation_available ?funding_allocation)
      )
    :effect
      (and
        (agent_received_funding_allocation ?administrative_agent ?funding_allocation)
        (not
          (funding_allocation_available ?funding_allocation)
        )
      )
  )
  (:action perform_final_checks_for_agent
    :parameters (?administrative_agent - administrative_agent ?course_section - course_section ?alternate_section - alternate_section ?curricular_component - curricular_component ?funding_allocation - funding_allocation)
    :precondition
      (and
        (agent_ready_for_finalization ?administrative_agent)
        (agent_certified ?administrative_agent)
        (agent_received_funding_allocation ?administrative_agent ?funding_allocation)
        (agent_responsible_for_section ?administrative_agent ?course_section)
        (agent_responsible_for_alternate_section ?administrative_agent ?alternate_section)
        (section_ready_for_calendar ?course_section)
        (alternate_section_ready_for_calendar ?alternate_section)
        (subject_attached_component ?administrative_agent ?curricular_component)
        (not
          (agent_finalized ?administrative_agent)
        )
      )
    :effect (agent_finalized ?administrative_agent)
  )
  (:action finalize_agent_certification
    :parameters (?administrative_agent - administrative_agent)
    :precondition
      (and
        (agent_ready_for_finalization ?administrative_agent)
        (agent_finalized ?administrative_agent)
        (not
          (agent_final_certification_recorded ?administrative_agent)
        )
      )
    :effect
      (and
        (agent_final_certification_recorded ?administrative_agent)
        (ready_for_execution ?administrative_agent)
      )
  )
  (:action obtain_external_authority_approval_for_agent
    :parameters (?administrative_agent - administrative_agent ?external_authority_record - external_authority_record ?curricular_component - curricular_component)
    :precondition
      (and
        (subject_verified ?administrative_agent)
        (subject_attached_component ?administrative_agent ?curricular_component)
        (external_authority_record_available ?external_authority_record)
        (agent_has_external_authority_record ?administrative_agent ?external_authority_record)
        (not
          (agent_external_approval_obtained ?administrative_agent)
        )
      )
    :effect
      (and
        (agent_external_approval_obtained ?administrative_agent)
        (not
          (external_authority_record_available ?external_authority_record)
        )
      )
  )
  (:action start_external_review_for_agent
    :parameters (?administrative_agent - administrative_agent ?staff_member - staff_member)
    :precondition
      (and
        (agent_external_approval_obtained ?administrative_agent)
        (subject_assigned_staff ?administrative_agent ?staff_member)
        (not
          (agent_in_external_review ?administrative_agent)
        )
      )
    :effect (agent_in_external_review ?administrative_agent)
  )
  (:action confirm_external_review_for_agent
    :parameters (?administrative_agent - administrative_agent ?operational_protocol - operational_protocol)
    :precondition
      (and
        (agent_in_external_review ?administrative_agent)
        (agent_assigned_operational_protocol ?administrative_agent ?operational_protocol)
        (not
          (agent_external_approval_confirmed ?administrative_agent)
        )
      )
    :effect (agent_external_approval_confirmed ?administrative_agent)
  )
  (:action finalize_external_approval_for_agent
    :parameters (?administrative_agent - administrative_agent)
    :precondition
      (and
        (agent_external_approval_confirmed ?administrative_agent)
        (not
          (agent_final_certification_recorded ?administrative_agent)
        )
      )
    :effect
      (and
        (agent_final_certification_recorded ?administrative_agent)
        (ready_for_execution ?administrative_agent)
      )
  )
  (:action certify_section_for_execution
    :parameters (?course_section - course_section ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (section_slot_assigned ?course_section)
        (section_ready_for_calendar ?course_section)
        (makeup_calendar_prepared ?makeup_calendar)
        (makeup_calendar_finalized ?makeup_calendar)
        (not
          (ready_for_execution ?course_section)
        )
      )
    :effect (ready_for_execution ?course_section)
  )
  (:action certify_alternate_section_for_execution
    :parameters (?alternate_section - alternate_section ?makeup_calendar - makeup_calendar)
    :precondition
      (and
        (alternate_section_slot_assigned ?alternate_section)
        (alternate_section_ready_for_calendar ?alternate_section)
        (makeup_calendar_prepared ?makeup_calendar)
        (makeup_calendar_finalized ?makeup_calendar)
        (not
          (ready_for_execution ?alternate_section)
        )
      )
    :effect (ready_for_execution ?alternate_section)
  )
  (:action adjudicate_case_and_attach_appeal_form
    :parameters (?exception_case - exception_case ?appeal_form - appeal_form ?curricular_component - curricular_component)
    :precondition
      (and
        (ready_for_execution ?exception_case)
        (subject_attached_component ?exception_case ?curricular_component)
        (appeal_form_available ?appeal_form)
        (not
          (subject_adjudicated ?exception_case)
        )
      )
    :effect
      (and
        (subject_adjudicated ?exception_case)
        (subject_has_appeal_form ?exception_case ?appeal_form)
        (not
          (appeal_form_available ?appeal_form)
        )
      )
  )
  (:action apply_administrative_correction_to_section
    :parameters (?course_section - course_section ?recovery_resource_token - recovery_resource_token ?appeal_form - appeal_form)
    :precondition
      (and
        (subject_adjudicated ?course_section)
        (subject_allocated_resource ?course_section ?recovery_resource_token)
        (subject_has_appeal_form ?course_section ?appeal_form)
        (not
          (administrative_correction_applied ?course_section)
        )
      )
    :effect
      (and
        (administrative_correction_applied ?course_section)
        (resource_token_available ?recovery_resource_token)
        (appeal_form_available ?appeal_form)
      )
  )
  (:action apply_administrative_correction_to_alternate_section
    :parameters (?alternate_section - alternate_section ?recovery_resource_token - recovery_resource_token ?appeal_form - appeal_form)
    :precondition
      (and
        (subject_adjudicated ?alternate_section)
        (subject_allocated_resource ?alternate_section ?recovery_resource_token)
        (subject_has_appeal_form ?alternate_section ?appeal_form)
        (not
          (administrative_correction_applied ?alternate_section)
        )
      )
    :effect
      (and
        (administrative_correction_applied ?alternate_section)
        (resource_token_available ?recovery_resource_token)
        (appeal_form_available ?appeal_form)
      )
  )
  (:action apply_administrative_correction_to_agent
    :parameters (?administrative_agent - administrative_agent ?recovery_resource_token - recovery_resource_token ?appeal_form - appeal_form)
    :precondition
      (and
        (subject_adjudicated ?administrative_agent)
        (subject_allocated_resource ?administrative_agent ?recovery_resource_token)
        (subject_has_appeal_form ?administrative_agent ?appeal_form)
        (not
          (administrative_correction_applied ?administrative_agent)
        )
      )
    :effect
      (and
        (administrative_correction_applied ?administrative_agent)
        (resource_token_available ?recovery_resource_token)
        (appeal_form_available ?appeal_form)
      )
  )
)

(define (domain overlapping_exam_emergency_resolution_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_entity - object actor_or_resource_group - domain_entity document_person_group - domain_entity session_group - domain_entity case_root - domain_entity exception_case - case_root exam_slot - actor_or_resource_group supporting_document - actor_or_resource_group administrative_staff - actor_or_resource_group policy_clause - actor_or_resource_group authorization_token - actor_or_resource_group calendar_entry - actor_or_resource_group remedial_option - actor_or_resource_group exam_board - actor_or_resource_group student_request - document_person_group evidence_file - document_person_group student - document_person_group primary_session - session_group secondary_session - session_group resolution_plan - session_group affected_exam_reference - exception_case case_record_container - exception_case primary_exam - affected_exam_reference secondary_exam - affected_exam_reference administrative_record - case_record_container)

  (:predicates
    (entity_open ?exception_case - exception_case)
    (entity_eligibility_confirmed ?exception_case - exception_case)
    (entity_slot_assigned ?exception_case - exception_case)
    (entity_resolution_implemented ?exception_case - exception_case)
    (entity_recovery_executed ?exception_case - exception_case)
    (entity_authorization_granted ?exception_case - exception_case)
    (exam_slot_available ?exam_slot - exam_slot)
    (entity_assigned_slot ?exception_case - exception_case ?exam_slot - exam_slot)
    (supporting_document_available ?supporting_document - supporting_document)
    (entity_attached_supporting_document ?exception_case - exception_case ?supporting_document - supporting_document)
    (staff_available ?administrative_staff - administrative_staff)
    (entity_assigned_staff ?exception_case - exception_case ?administrative_staff - administrative_staff)
    (student_request_available ?student_request - student_request)
    (primary_exam_linked_request ?primary_exam - primary_exam ?student_request - student_request)
    (secondary_exam_linked_request ?secondary_exam - secondary_exam ?student_request - student_request)
    (primary_exam_scheduled_session ?primary_exam - primary_exam ?primary_session - primary_session)
    (primary_session_confirmed ?primary_session - primary_session)
    (primary_session_reserved ?primary_session - primary_session)
    (primary_exam_verification_complete ?primary_exam - primary_exam)
    (secondary_exam_scheduled_session ?secondary_exam - secondary_exam ?secondary_session - secondary_session)
    (secondary_session_confirmed ?secondary_session - secondary_session)
    (secondary_session_reserved ?secondary_session - secondary_session)
    (secondary_exam_verification_complete ?secondary_exam - secondary_exam)
    (plan_proposed ?resolution_plan - resolution_plan)
    (plan_generated ?resolution_plan - resolution_plan)
    (plan_assigned_primary_session ?resolution_plan - resolution_plan ?primary_session - primary_session)
    (plan_assigned_secondary_session ?resolution_plan - resolution_plan ?secondary_session - secondary_session)
    (plan_staff_approved ?resolution_plan - resolution_plan)
    (plan_board_approved ?resolution_plan - resolution_plan)
    (plan_locked_for_execution ?resolution_plan - resolution_plan)
    (references_primary_exam ?administrative_record - administrative_record ?primary_exam - primary_exam)
    (references_secondary_exam ?administrative_record - administrative_record ?secondary_exam - secondary_exam)
    (references_resolution_plan ?administrative_record - administrative_record ?resolution_plan - resolution_plan)
    (evidence_file_available ?evidence_file - evidence_file)
    (references_evidence_file ?administrative_record - administrative_record ?evidence_file - evidence_file)
    (evidence_file_verified ?evidence_file - evidence_file)
    (evidence_supports_plan ?evidence_file - evidence_file ?resolution_plan - resolution_plan)
    (administrative_validated ?administrative_record - administrative_record)
    (administrative_authorized ?administrative_record - administrative_record)
    (board_approval_obtained ?administrative_record - administrative_record)
    (policy_clause_applied ?administrative_record - administrative_record)
    (policy_evidence_attested ?administrative_record - administrative_record)
    (authorization_ready ?administrative_record - administrative_record)
    (implementation_prepared ?administrative_record - administrative_record)
    (student_available_for_link ?student - student)
    (references_student ?administrative_record - administrative_record ?student - student)
    (student_linked ?administrative_record - administrative_record)
    (student_link_verified ?administrative_record - administrative_record)
    (student_link_authorized ?administrative_record - administrative_record)
    (policy_clause_available ?policy_clause - policy_clause)
    (references_policy_clause ?administrative_record - administrative_record ?policy_clause - policy_clause)
    (authorization_token_available ?authorization_token - authorization_token)
    (references_authorization_token ?administrative_record - administrative_record ?authorization_token - authorization_token)
    (remedial_option_available ?remedial_option - remedial_option)
    (references_remedial_option ?administrative_record - administrative_record ?remedial_option - remedial_option)
    (exam_board_available ?exam_board - exam_board)
    (references_exam_board ?administrative_record - administrative_record ?exam_board - exam_board)
    (calendar_entry_available ?calendar_entry - calendar_entry)
    (entity_assigned_calendar_entry ?exception_case - exception_case ?calendar_entry - calendar_entry)
    (primary_exam_ready_for_plan ?primary_exam - primary_exam)
    (secondary_exam_ready_for_plan ?secondary_exam - secondary_exam)
    (administrative_record_finalized ?administrative_record - administrative_record)
  )
  (:action open_exception_case
    :parameters (?exception_case - exception_case)
    :precondition
      (and
        (not
          (entity_open ?exception_case)
        )
        (not
          (entity_resolution_implemented ?exception_case)
        )
      )
    :effect (entity_open ?exception_case)
  )
  (:action claim_exam_slot
    :parameters (?exception_case - exception_case ?exam_slot - exam_slot)
    :precondition
      (and
        (entity_open ?exception_case)
        (not
          (entity_slot_assigned ?exception_case)
        )
        (exam_slot_available ?exam_slot)
      )
    :effect
      (and
        (entity_slot_assigned ?exception_case)
        (entity_assigned_slot ?exception_case ?exam_slot)
        (not
          (exam_slot_available ?exam_slot)
        )
      )
  )
  (:action attach_supporting_document
    :parameters (?exception_case - exception_case ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_open ?exception_case)
        (entity_slot_assigned ?exception_case)
        (supporting_document_available ?supporting_document)
      )
    :effect
      (and
        (entity_attached_supporting_document ?exception_case ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action confirm_case_eligibility
    :parameters (?exception_case - exception_case ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_open ?exception_case)
        (entity_slot_assigned ?exception_case)
        (entity_attached_supporting_document ?exception_case ?supporting_document)
        (not
          (entity_eligibility_confirmed ?exception_case)
        )
      )
    :effect (entity_eligibility_confirmed ?exception_case)
  )
  (:action release_supporting_document
    :parameters (?exception_case - exception_case ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_attached_supporting_document ?exception_case ?supporting_document)
      )
    :effect
      (and
        (supporting_document_available ?supporting_document)
        (not
          (entity_attached_supporting_document ?exception_case ?supporting_document)
        )
      )
  )
  (:action assign_staff_to_case
    :parameters (?exception_case - exception_case ?administrative_staff - administrative_staff)
    :precondition
      (and
        (entity_eligibility_confirmed ?exception_case)
        (staff_available ?administrative_staff)
      )
    :effect
      (and
        (entity_assigned_staff ?exception_case ?administrative_staff)
        (not
          (staff_available ?administrative_staff)
        )
      )
  )
  (:action unassign_staff_from_case
    :parameters (?exception_case - exception_case ?administrative_staff - administrative_staff)
    :precondition
      (and
        (entity_assigned_staff ?exception_case ?administrative_staff)
      )
    :effect
      (and
        (staff_available ?administrative_staff)
        (not
          (entity_assigned_staff ?exception_case ?administrative_staff)
        )
      )
  )
  (:action link_remedial_option_to_record
    :parameters (?administrative_record - administrative_record ?remedial_option - remedial_option)
    :precondition
      (and
        (entity_eligibility_confirmed ?administrative_record)
        (remedial_option_available ?remedial_option)
      )
    :effect
      (and
        (references_remedial_option ?administrative_record ?remedial_option)
        (not
          (remedial_option_available ?remedial_option)
        )
      )
  )
  (:action remove_remedial_option_from_record
    :parameters (?administrative_record - administrative_record ?remedial_option - remedial_option)
    :precondition
      (and
        (references_remedial_option ?administrative_record ?remedial_option)
      )
    :effect
      (and
        (remedial_option_available ?remedial_option)
        (not
          (references_remedial_option ?administrative_record ?remedial_option)
        )
      )
  )
  (:action assign_exam_board_to_record
    :parameters (?administrative_record - administrative_record ?exam_board - exam_board)
    :precondition
      (and
        (entity_eligibility_confirmed ?administrative_record)
        (exam_board_available ?exam_board)
      )
    :effect
      (and
        (references_exam_board ?administrative_record ?exam_board)
        (not
          (exam_board_available ?exam_board)
        )
      )
  )
  (:action remove_exam_board_from_record
    :parameters (?administrative_record - administrative_record ?exam_board - exam_board)
    :precondition
      (and
        (references_exam_board ?administrative_record ?exam_board)
      )
    :effect
      (and
        (exam_board_available ?exam_board)
        (not
          (references_exam_board ?administrative_record ?exam_board)
        )
      )
  )
  (:action confirm_primary_session_availability
    :parameters (?primary_exam - primary_exam ?primary_session - primary_session ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_eligibility_confirmed ?primary_exam)
        (entity_attached_supporting_document ?primary_exam ?supporting_document)
        (primary_exam_scheduled_session ?primary_exam ?primary_session)
        (not
          (primary_session_confirmed ?primary_session)
        )
        (not
          (primary_session_reserved ?primary_session)
        )
      )
    :effect (primary_session_confirmed ?primary_session)
  )
  (:action staff_verify_primary_exam
    :parameters (?primary_exam - primary_exam ?primary_session - primary_session ?administrative_staff - administrative_staff)
    :precondition
      (and
        (entity_eligibility_confirmed ?primary_exam)
        (entity_assigned_staff ?primary_exam ?administrative_staff)
        (primary_exam_scheduled_session ?primary_exam ?primary_session)
        (primary_session_confirmed ?primary_session)
        (not
          (primary_exam_ready_for_plan ?primary_exam)
        )
      )
    :effect
      (and
        (primary_exam_ready_for_plan ?primary_exam)
        (primary_exam_verification_complete ?primary_exam)
      )
  )
  (:action link_student_request_to_primary_exam
    :parameters (?primary_exam - primary_exam ?primary_session - primary_session ?student_request - student_request)
    :precondition
      (and
        (entity_eligibility_confirmed ?primary_exam)
        (primary_exam_scheduled_session ?primary_exam ?primary_session)
        (student_request_available ?student_request)
        (not
          (primary_exam_ready_for_plan ?primary_exam)
        )
      )
    :effect
      (and
        (primary_session_reserved ?primary_session)
        (primary_exam_ready_for_plan ?primary_exam)
        (primary_exam_linked_request ?primary_exam ?student_request)
        (not
          (student_request_available ?student_request)
        )
      )
  )
  (:action finalize_primary_session_allocation
    :parameters (?primary_exam - primary_exam ?primary_session - primary_session ?supporting_document - supporting_document ?student_request - student_request)
    :precondition
      (and
        (entity_eligibility_confirmed ?primary_exam)
        (entity_attached_supporting_document ?primary_exam ?supporting_document)
        (primary_exam_scheduled_session ?primary_exam ?primary_session)
        (primary_session_reserved ?primary_session)
        (primary_exam_linked_request ?primary_exam ?student_request)
        (not
          (primary_exam_verification_complete ?primary_exam)
        )
      )
    :effect
      (and
        (primary_session_confirmed ?primary_session)
        (primary_exam_verification_complete ?primary_exam)
        (student_request_available ?student_request)
        (not
          (primary_exam_linked_request ?primary_exam ?student_request)
        )
      )
  )
  (:action confirm_secondary_session_availability
    :parameters (?secondary_exam - secondary_exam ?secondary_session - secondary_session ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_eligibility_confirmed ?secondary_exam)
        (entity_attached_supporting_document ?secondary_exam ?supporting_document)
        (secondary_exam_scheduled_session ?secondary_exam ?secondary_session)
        (not
          (secondary_session_confirmed ?secondary_session)
        )
        (not
          (secondary_session_reserved ?secondary_session)
        )
      )
    :effect (secondary_session_confirmed ?secondary_session)
  )
  (:action staff_verify_secondary_exam
    :parameters (?secondary_exam - secondary_exam ?secondary_session - secondary_session ?administrative_staff - administrative_staff)
    :precondition
      (and
        (entity_eligibility_confirmed ?secondary_exam)
        (entity_assigned_staff ?secondary_exam ?administrative_staff)
        (secondary_exam_scheduled_session ?secondary_exam ?secondary_session)
        (secondary_session_confirmed ?secondary_session)
        (not
          (secondary_exam_ready_for_plan ?secondary_exam)
        )
      )
    :effect
      (and
        (secondary_exam_ready_for_plan ?secondary_exam)
        (secondary_exam_verification_complete ?secondary_exam)
      )
  )
  (:action link_student_request_to_secondary_exam
    :parameters (?secondary_exam - secondary_exam ?secondary_session - secondary_session ?student_request - student_request)
    :precondition
      (and
        (entity_eligibility_confirmed ?secondary_exam)
        (secondary_exam_scheduled_session ?secondary_exam ?secondary_session)
        (student_request_available ?student_request)
        (not
          (secondary_exam_ready_for_plan ?secondary_exam)
        )
      )
    :effect
      (and
        (secondary_session_reserved ?secondary_session)
        (secondary_exam_ready_for_plan ?secondary_exam)
        (secondary_exam_linked_request ?secondary_exam ?student_request)
        (not
          (student_request_available ?student_request)
        )
      )
  )
  (:action finalize_secondary_session_allocation
    :parameters (?secondary_exam - secondary_exam ?secondary_session - secondary_session ?supporting_document - supporting_document ?student_request - student_request)
    :precondition
      (and
        (entity_eligibility_confirmed ?secondary_exam)
        (entity_attached_supporting_document ?secondary_exam ?supporting_document)
        (secondary_exam_scheduled_session ?secondary_exam ?secondary_session)
        (secondary_session_reserved ?secondary_session)
        (secondary_exam_linked_request ?secondary_exam ?student_request)
        (not
          (secondary_exam_verification_complete ?secondary_exam)
        )
      )
    :effect
      (and
        (secondary_session_confirmed ?secondary_session)
        (secondary_exam_verification_complete ?secondary_exam)
        (student_request_available ?student_request)
        (not
          (secondary_exam_linked_request ?secondary_exam ?student_request)
        )
      )
  )
  (:action construct_resolution_plan
    :parameters (?primary_exam - primary_exam ?secondary_exam - secondary_exam ?primary_session - primary_session ?secondary_session - secondary_session ?resolution_plan - resolution_plan)
    :precondition
      (and
        (primary_exam_ready_for_plan ?primary_exam)
        (secondary_exam_ready_for_plan ?secondary_exam)
        (primary_exam_scheduled_session ?primary_exam ?primary_session)
        (secondary_exam_scheduled_session ?secondary_exam ?secondary_session)
        (primary_session_confirmed ?primary_session)
        (secondary_session_confirmed ?secondary_session)
        (primary_exam_verification_complete ?primary_exam)
        (secondary_exam_verification_complete ?secondary_exam)
        (plan_proposed ?resolution_plan)
      )
    :effect
      (and
        (plan_generated ?resolution_plan)
        (plan_assigned_primary_session ?resolution_plan ?primary_session)
        (plan_assigned_secondary_session ?resolution_plan ?secondary_session)
        (not
          (plan_proposed ?resolution_plan)
        )
      )
  )
  (:action construct_resolution_plan_with_primary_reserved
    :parameters (?primary_exam - primary_exam ?secondary_exam - secondary_exam ?primary_session - primary_session ?secondary_session - secondary_session ?resolution_plan - resolution_plan)
    :precondition
      (and
        (primary_exam_ready_for_plan ?primary_exam)
        (secondary_exam_ready_for_plan ?secondary_exam)
        (primary_exam_scheduled_session ?primary_exam ?primary_session)
        (secondary_exam_scheduled_session ?secondary_exam ?secondary_session)
        (primary_session_reserved ?primary_session)
        (secondary_session_confirmed ?secondary_session)
        (not
          (primary_exam_verification_complete ?primary_exam)
        )
        (secondary_exam_verification_complete ?secondary_exam)
        (plan_proposed ?resolution_plan)
      )
    :effect
      (and
        (plan_generated ?resolution_plan)
        (plan_assigned_primary_session ?resolution_plan ?primary_session)
        (plan_assigned_secondary_session ?resolution_plan ?secondary_session)
        (plan_staff_approved ?resolution_plan)
        (not
          (plan_proposed ?resolution_plan)
        )
      )
  )
  (:action construct_resolution_plan_with_secondary_reserved
    :parameters (?primary_exam - primary_exam ?secondary_exam - secondary_exam ?primary_session - primary_session ?secondary_session - secondary_session ?resolution_plan - resolution_plan)
    :precondition
      (and
        (primary_exam_ready_for_plan ?primary_exam)
        (secondary_exam_ready_for_plan ?secondary_exam)
        (primary_exam_scheduled_session ?primary_exam ?primary_session)
        (secondary_exam_scheduled_session ?secondary_exam ?secondary_session)
        (primary_session_confirmed ?primary_session)
        (secondary_session_reserved ?secondary_session)
        (primary_exam_verification_complete ?primary_exam)
        (not
          (secondary_exam_verification_complete ?secondary_exam)
        )
        (plan_proposed ?resolution_plan)
      )
    :effect
      (and
        (plan_generated ?resolution_plan)
        (plan_assigned_primary_session ?resolution_plan ?primary_session)
        (plan_assigned_secondary_session ?resolution_plan ?secondary_session)
        (plan_board_approved ?resolution_plan)
        (not
          (plan_proposed ?resolution_plan)
        )
      )
  )
  (:action construct_full_resolution_plan
    :parameters (?primary_exam - primary_exam ?secondary_exam - secondary_exam ?primary_session - primary_session ?secondary_session - secondary_session ?resolution_plan - resolution_plan)
    :precondition
      (and
        (primary_exam_ready_for_plan ?primary_exam)
        (secondary_exam_ready_for_plan ?secondary_exam)
        (primary_exam_scheduled_session ?primary_exam ?primary_session)
        (secondary_exam_scheduled_session ?secondary_exam ?secondary_session)
        (primary_session_reserved ?primary_session)
        (secondary_session_reserved ?secondary_session)
        (not
          (primary_exam_verification_complete ?primary_exam)
        )
        (not
          (secondary_exam_verification_complete ?secondary_exam)
        )
        (plan_proposed ?resolution_plan)
      )
    :effect
      (and
        (plan_generated ?resolution_plan)
        (plan_assigned_primary_session ?resolution_plan ?primary_session)
        (plan_assigned_secondary_session ?resolution_plan ?secondary_session)
        (plan_staff_approved ?resolution_plan)
        (plan_board_approved ?resolution_plan)
        (not
          (plan_proposed ?resolution_plan)
        )
      )
  )
  (:action lock_resolution_plan
    :parameters (?resolution_plan - resolution_plan ?primary_exam - primary_exam ?supporting_document - supporting_document)
    :precondition
      (and
        (plan_generated ?resolution_plan)
        (primary_exam_ready_for_plan ?primary_exam)
        (entity_attached_supporting_document ?primary_exam ?supporting_document)
        (not
          (plan_locked_for_execution ?resolution_plan)
        )
      )
    :effect (plan_locked_for_execution ?resolution_plan)
  )
  (:action validate_evidence_and_attach_plan
    :parameters (?administrative_record - administrative_record ?evidence_file - evidence_file ?resolution_plan - resolution_plan)
    :precondition
      (and
        (entity_eligibility_confirmed ?administrative_record)
        (references_resolution_plan ?administrative_record ?resolution_plan)
        (references_evidence_file ?administrative_record ?evidence_file)
        (evidence_file_available ?evidence_file)
        (plan_generated ?resolution_plan)
        (plan_locked_for_execution ?resolution_plan)
        (not
          (evidence_file_verified ?evidence_file)
        )
      )
    :effect
      (and
        (evidence_file_verified ?evidence_file)
        (evidence_supports_plan ?evidence_file ?resolution_plan)
        (not
          (evidence_file_available ?evidence_file)
        )
      )
  )
  (:action validate_administrative_record_against_plan
    :parameters (?administrative_record - administrative_record ?evidence_file - evidence_file ?resolution_plan - resolution_plan ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_eligibility_confirmed ?administrative_record)
        (references_evidence_file ?administrative_record ?evidence_file)
        (evidence_file_verified ?evidence_file)
        (evidence_supports_plan ?evidence_file ?resolution_plan)
        (entity_attached_supporting_document ?administrative_record ?supporting_document)
        (not
          (plan_staff_approved ?resolution_plan)
        )
        (not
          (administrative_validated ?administrative_record)
        )
      )
    :effect (administrative_validated ?administrative_record)
  )
  (:action attach_policy_clause
    :parameters (?administrative_record - administrative_record ?policy_clause - policy_clause)
    :precondition
      (and
        (entity_eligibility_confirmed ?administrative_record)
        (policy_clause_available ?policy_clause)
        (not
          (policy_clause_applied ?administrative_record)
        )
      )
    :effect
      (and
        (policy_clause_applied ?administrative_record)
        (references_policy_clause ?administrative_record ?policy_clause)
        (not
          (policy_clause_available ?policy_clause)
        )
      )
  )
  (:action process_policy_and_evidence
    :parameters (?administrative_record - administrative_record ?evidence_file - evidence_file ?resolution_plan - resolution_plan ?supporting_document - supporting_document ?policy_clause - policy_clause)
    :precondition
      (and
        (entity_eligibility_confirmed ?administrative_record)
        (references_evidence_file ?administrative_record ?evidence_file)
        (evidence_file_verified ?evidence_file)
        (evidence_supports_plan ?evidence_file ?resolution_plan)
        (entity_attached_supporting_document ?administrative_record ?supporting_document)
        (plan_staff_approved ?resolution_plan)
        (policy_clause_applied ?administrative_record)
        (references_policy_clause ?administrative_record ?policy_clause)
        (not
          (administrative_validated ?administrative_record)
        )
      )
    :effect
      (and
        (administrative_validated ?administrative_record)
        (policy_evidence_attested ?administrative_record)
      )
  )
  (:action obtain_staff_authorization
    :parameters (?administrative_record - administrative_record ?remedial_option - remedial_option ?administrative_staff - administrative_staff ?evidence_file - evidence_file ?resolution_plan - resolution_plan)
    :precondition
      (and
        (administrative_validated ?administrative_record)
        (references_remedial_option ?administrative_record ?remedial_option)
        (entity_assigned_staff ?administrative_record ?administrative_staff)
        (references_evidence_file ?administrative_record ?evidence_file)
        (evidence_supports_plan ?evidence_file ?resolution_plan)
        (not
          (plan_board_approved ?resolution_plan)
        )
        (not
          (administrative_authorized ?administrative_record)
        )
      )
    :effect (administrative_authorized ?administrative_record)
  )
  (:action obtain_staff_authorization_alternative
    :parameters (?administrative_record - administrative_record ?remedial_option - remedial_option ?administrative_staff - administrative_staff ?evidence_file - evidence_file ?resolution_plan - resolution_plan)
    :precondition
      (and
        (administrative_validated ?administrative_record)
        (references_remedial_option ?administrative_record ?remedial_option)
        (entity_assigned_staff ?administrative_record ?administrative_staff)
        (references_evidence_file ?administrative_record ?evidence_file)
        (evidence_supports_plan ?evidence_file ?resolution_plan)
        (plan_board_approved ?resolution_plan)
        (not
          (administrative_authorized ?administrative_record)
        )
      )
    :effect (administrative_authorized ?administrative_record)
  )
  (:action request_board_authorization
    :parameters (?administrative_record - administrative_record ?exam_board - exam_board ?evidence_file - evidence_file ?resolution_plan - resolution_plan)
    :precondition
      (and
        (administrative_authorized ?administrative_record)
        (references_exam_board ?administrative_record ?exam_board)
        (references_evidence_file ?administrative_record ?evidence_file)
        (evidence_supports_plan ?evidence_file ?resolution_plan)
        (not
          (plan_staff_approved ?resolution_plan)
        )
        (not
          (plan_board_approved ?resolution_plan)
        )
        (not
          (board_approval_obtained ?administrative_record)
        )
      )
    :effect (board_approval_obtained ?administrative_record)
  )
  (:action confirm_board_authorization_with_token
    :parameters (?administrative_record - administrative_record ?exam_board - exam_board ?evidence_file - evidence_file ?resolution_plan - resolution_plan)
    :precondition
      (and
        (administrative_authorized ?administrative_record)
        (references_exam_board ?administrative_record ?exam_board)
        (references_evidence_file ?administrative_record ?evidence_file)
        (evidence_supports_plan ?evidence_file ?resolution_plan)
        (plan_staff_approved ?resolution_plan)
        (not
          (plan_board_approved ?resolution_plan)
        )
        (not
          (board_approval_obtained ?administrative_record)
        )
      )
    :effect
      (and
        (board_approval_obtained ?administrative_record)
        (authorization_ready ?administrative_record)
      )
  )
  (:action confirm_board_authorization_variant
    :parameters (?administrative_record - administrative_record ?exam_board - exam_board ?evidence_file - evidence_file ?resolution_plan - resolution_plan)
    :precondition
      (and
        (administrative_authorized ?administrative_record)
        (references_exam_board ?administrative_record ?exam_board)
        (references_evidence_file ?administrative_record ?evidence_file)
        (evidence_supports_plan ?evidence_file ?resolution_plan)
        (not
          (plan_staff_approved ?resolution_plan)
        )
        (plan_board_approved ?resolution_plan)
        (not
          (board_approval_obtained ?administrative_record)
        )
      )
    :effect
      (and
        (board_approval_obtained ?administrative_record)
        (authorization_ready ?administrative_record)
      )
  )
  (:action confirm_board_authorization_full
    :parameters (?administrative_record - administrative_record ?exam_board - exam_board ?evidence_file - evidence_file ?resolution_plan - resolution_plan)
    :precondition
      (and
        (administrative_authorized ?administrative_record)
        (references_exam_board ?administrative_record ?exam_board)
        (references_evidence_file ?administrative_record ?evidence_file)
        (evidence_supports_plan ?evidence_file ?resolution_plan)
        (plan_staff_approved ?resolution_plan)
        (plan_board_approved ?resolution_plan)
        (not
          (board_approval_obtained ?administrative_record)
        )
      )
    :effect
      (and
        (board_approval_obtained ?administrative_record)
        (authorization_ready ?administrative_record)
      )
  )
  (:action finalize_administrative_record
    :parameters (?administrative_record - administrative_record)
    :precondition
      (and
        (board_approval_obtained ?administrative_record)
        (not
          (authorization_ready ?administrative_record)
        )
        (not
          (administrative_record_finalized ?administrative_record)
        )
      )
    :effect
      (and
        (administrative_record_finalized ?administrative_record)
        (entity_recovery_executed ?administrative_record)
      )
  )
  (:action issue_authorization_token_to_record
    :parameters (?administrative_record - administrative_record ?authorization_token - authorization_token)
    :precondition
      (and
        (board_approval_obtained ?administrative_record)
        (authorization_ready ?administrative_record)
        (authorization_token_available ?authorization_token)
      )
    :effect
      (and
        (references_authorization_token ?administrative_record ?authorization_token)
        (not
          (authorization_token_available ?authorization_token)
        )
      )
  )
  (:action execute_remedial_option
    :parameters (?administrative_record - administrative_record ?primary_exam - primary_exam ?secondary_exam - secondary_exam ?supporting_document - supporting_document ?authorization_token - authorization_token)
    :precondition
      (and
        (board_approval_obtained ?administrative_record)
        (authorization_ready ?administrative_record)
        (references_authorization_token ?administrative_record ?authorization_token)
        (references_primary_exam ?administrative_record ?primary_exam)
        (references_secondary_exam ?administrative_record ?secondary_exam)
        (primary_exam_verification_complete ?primary_exam)
        (secondary_exam_verification_complete ?secondary_exam)
        (entity_attached_supporting_document ?administrative_record ?supporting_document)
        (not
          (implementation_prepared ?administrative_record)
        )
      )
    :effect (implementation_prepared ?administrative_record)
  )
  (:action mark_administrative_record_executed
    :parameters (?administrative_record - administrative_record)
    :precondition
      (and
        (board_approval_obtained ?administrative_record)
        (implementation_prepared ?administrative_record)
        (not
          (administrative_record_finalized ?administrative_record)
        )
      )
    :effect
      (and
        (administrative_record_finalized ?administrative_record)
        (entity_recovery_executed ?administrative_record)
      )
  )
  (:action link_student_to_administrative_record
    :parameters (?administrative_record - administrative_record ?student - student ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_eligibility_confirmed ?administrative_record)
        (entity_attached_supporting_document ?administrative_record ?supporting_document)
        (student_available_for_link ?student)
        (references_student ?administrative_record ?student)
        (not
          (student_linked ?administrative_record)
        )
      )
    :effect
      (and
        (student_linked ?administrative_record)
        (not
          (student_available_for_link ?student)
        )
      )
  )
  (:action confirm_student_link
    :parameters (?administrative_record - administrative_record ?administrative_staff - administrative_staff)
    :precondition
      (and
        (student_linked ?administrative_record)
        (entity_assigned_staff ?administrative_record ?administrative_staff)
        (not
          (student_link_verified ?administrative_record)
        )
      )
    :effect (student_link_verified ?administrative_record)
  )
  (:action authorize_student_link
    :parameters (?administrative_record - administrative_record ?exam_board - exam_board)
    :precondition
      (and
        (student_link_verified ?administrative_record)
        (references_exam_board ?administrative_record ?exam_board)
        (not
          (student_link_authorized ?administrative_record)
        )
      )
    :effect (student_link_authorized ?administrative_record)
  )
  (:action finalize_authorizations
    :parameters (?administrative_record - administrative_record)
    :precondition
      (and
        (student_link_authorized ?administrative_record)
        (not
          (administrative_record_finalized ?administrative_record)
        )
      )
    :effect
      (and
        (administrative_record_finalized ?administrative_record)
        (entity_recovery_executed ?administrative_record)
      )
  )
  (:action apply_resolution_to_primary_exam
    :parameters (?primary_exam - primary_exam ?resolution_plan - resolution_plan)
    :precondition
      (and
        (primary_exam_ready_for_plan ?primary_exam)
        (primary_exam_verification_complete ?primary_exam)
        (plan_generated ?resolution_plan)
        (plan_locked_for_execution ?resolution_plan)
        (not
          (entity_recovery_executed ?primary_exam)
        )
      )
    :effect (entity_recovery_executed ?primary_exam)
  )
  (:action apply_resolution_to_secondary_exam
    :parameters (?secondary_exam - secondary_exam ?resolution_plan - resolution_plan)
    :precondition
      (and
        (secondary_exam_ready_for_plan ?secondary_exam)
        (secondary_exam_verification_complete ?secondary_exam)
        (plan_generated ?resolution_plan)
        (plan_locked_for_execution ?resolution_plan)
        (not
          (entity_recovery_executed ?secondary_exam)
        )
      )
    :effect (entity_recovery_executed ?secondary_exam)
  )
  (:action issue_case_authorization
    :parameters (?exception_case - exception_case ?calendar_entry - calendar_entry ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_recovery_executed ?exception_case)
        (entity_attached_supporting_document ?exception_case ?supporting_document)
        (calendar_entry_available ?calendar_entry)
        (not
          (entity_authorization_granted ?exception_case)
        )
      )
    :effect
      (and
        (entity_authorization_granted ?exception_case)
        (entity_assigned_calendar_entry ?exception_case ?calendar_entry)
        (not
          (calendar_entry_available ?calendar_entry)
        )
      )
  )
  (:action implement_resolution_on_primary_exam
    :parameters (?primary_exam - primary_exam ?exam_slot - exam_slot ?calendar_entry - calendar_entry)
    :precondition
      (and
        (entity_authorization_granted ?primary_exam)
        (entity_assigned_slot ?primary_exam ?exam_slot)
        (entity_assigned_calendar_entry ?primary_exam ?calendar_entry)
        (not
          (entity_resolution_implemented ?primary_exam)
        )
      )
    :effect
      (and
        (entity_resolution_implemented ?primary_exam)
        (exam_slot_available ?exam_slot)
        (calendar_entry_available ?calendar_entry)
      )
  )
  (:action implement_resolution_on_secondary_exam
    :parameters (?secondary_exam - secondary_exam ?exam_slot - exam_slot ?calendar_entry - calendar_entry)
    :precondition
      (and
        (entity_authorization_granted ?secondary_exam)
        (entity_assigned_slot ?secondary_exam ?exam_slot)
        (entity_assigned_calendar_entry ?secondary_exam ?calendar_entry)
        (not
          (entity_resolution_implemented ?secondary_exam)
        )
      )
    :effect
      (and
        (entity_resolution_implemented ?secondary_exam)
        (exam_slot_available ?exam_slot)
        (calendar_entry_available ?calendar_entry)
      )
  )
  (:action implement_resolution_on_administrative_record
    :parameters (?administrative_record - administrative_record ?exam_slot - exam_slot ?calendar_entry - calendar_entry)
    :precondition
      (and
        (entity_authorization_granted ?administrative_record)
        (entity_assigned_slot ?administrative_record ?exam_slot)
        (entity_assigned_calendar_entry ?administrative_record ?calendar_entry)
        (not
          (entity_resolution_implemented ?administrative_record)
        )
      )
    :effect
      (and
        (entity_resolution_implemented ?administrative_record)
        (exam_slot_available ?exam_slot)
        (calendar_entry_available ?calendar_entry)
      )
  )
)

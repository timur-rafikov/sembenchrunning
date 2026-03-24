(define (domain cross_department_registration_coordination)
  (:requirements :strips :typing :negative-preconditions)
  (:types administrative_artifact - object resource_artifact - object resource_entity - object case_root - object registration_case - case_root department_approver - administrative_artifact proposed_time_slot - administrative_artifact department_reviewer - administrative_artifact auxiliary_resource - administrative_artifact policy_exception_type - administrative_artifact deadline_document - administrative_artifact instructor_availability - administrative_artifact escalation_approval - administrative_artifact supporting_document - resource_artifact room - resource_artifact external_authorization - resource_artifact home_time_option - resource_entity requested_time_option - resource_entity provisional_section - resource_entity department_case_group - registration_case registrar_case_group - registration_case home_department_case - department_case_group requested_department_case - department_case_group central_registrar_case - registrar_case_group)
  (:predicates
    (case_submitted ?registration_case - registration_case)
    (case_acknowledged ?registration_case - registration_case)
    (approver_assigned ?registration_case - registration_case)
    (case_finalized ?registration_case - registration_case)
    (enrollment_recorded ?registration_case - registration_case)
    (final_approval ?registration_case - registration_case)
    (approver_available ?department_approver - department_approver)
    (assigned_approver ?registration_case - registration_case ?department_approver - department_approver)
    (proposed_time_slot_available ?proposed_time_slot - proposed_time_slot)
    (case_proposed_time ?registration_case - registration_case ?proposed_time_slot - proposed_time_slot)
    (reviewer_available ?department_reviewer - department_reviewer)
    (assigned_reviewer ?registration_case - registration_case ?department_reviewer - department_reviewer)
    (supporting_doc_available ?supporting_document - supporting_document)
    (home_case_attached_document ?home_department_case - home_department_case ?supporting_document - supporting_document)
    (requested_case_attached_document ?requested_department_case - requested_department_case ?supporting_document - supporting_document)
    (home_case_time_option ?home_department_case - home_department_case ?home_time_option - home_time_option)
    (home_time_reserved ?home_time_option - home_time_option)
    (home_time_supported ?home_time_option - home_time_option)
    (home_case_time_confirmed ?home_department_case - home_department_case)
    (requested_case_time_option ?requested_department_case - requested_department_case ?requested_time_option - requested_time_option)
    (requested_time_reserved ?requested_time_option - requested_time_option)
    (requested_time_supported ?requested_time_option - requested_time_option)
    (requested_case_time_confirmed ?requested_department_case - requested_department_case)
    (section_unallocated ?provisional_section - provisional_section)
    (section_allocated ?provisional_section - provisional_section)
    (section_has_home_time_option ?provisional_section - provisional_section ?home_time_option - home_time_option)
    (section_has_requested_time_option ?provisional_section - provisional_section ?requested_time_option - requested_time_option)
    (section_home_time_supported ?provisional_section - provisional_section)
    (section_requested_time_supported ?provisional_section - provisional_section)
    (section_locked ?provisional_section - provisional_section)
    (central_has_home_case ?central_registrar_case - central_registrar_case ?home_department_case - home_department_case)
    (central_has_requested_case ?central_registrar_case - central_registrar_case ?requested_department_case - requested_department_case)
    (central_has_provisional_section ?central_registrar_case - central_registrar_case ?provisional_section - provisional_section)
    (room_available ?room - room)
    (central_has_room_option ?central_registrar_case - central_registrar_case ?room - room)
    (room_reserved ?room - room)
    (room_assigned_to_section ?room - room ?provisional_section - provisional_section)
    (instructor_assignment_initiated ?central_registrar_case - central_registrar_case)
    (instructor_assigned ?central_registrar_case - central_registrar_case)
    (instructor_availability_confirmed ?central_registrar_case - central_registrar_case)
    (central_case_aux_resource_reserved ?central_registrar_case - central_registrar_case)
    (auxiliary_reservation_locked ?central_registrar_case - central_registrar_case)
    (policy_exception_attached ?central_registrar_case - central_registrar_case)
    (central_case_instructor_confirmed ?central_registrar_case - central_registrar_case)
    (external_authorization_available ?external_authorization - external_authorization)
    (central_has_external_authorization ?central_registrar_case - central_registrar_case ?external_authorization - external_authorization)
    (external_authorization_attached ?central_registrar_case - central_registrar_case)
    (external_authorization_verified ?central_registrar_case - central_registrar_case)
    (external_authorization_finalized ?central_registrar_case - central_registrar_case)
    (aux_resource_available ?auxiliary_resource - auxiliary_resource)
    (central_has_aux_resource ?central_registrar_case - central_registrar_case ?auxiliary_resource - auxiliary_resource)
    (policy_exception_available ?policy_exception_type - policy_exception_type)
    (central_has_policy_exception ?central_registrar_case - central_registrar_case ?policy_exception_type - policy_exception_type)
    (instructor_availability_available ?instructor_availability - instructor_availability)
    (central_assigned_instructor_availability ?central_registrar_case - central_registrar_case ?instructor_availability - instructor_availability)
    (escalation_approval_available ?escalation_approval - escalation_approval)
    (central_has_escalation_approval ?central_registrar_case - central_registrar_case ?escalation_approval - escalation_approval)
    (deadline_document_available ?deadline_document - deadline_document)
    (case_has_deadline_document ?registration_case - registration_case ?deadline_document - deadline_document)
    (home_case_time_ready ?home_department_case - home_department_case)
    (requested_case_time_ready ?requested_department_case - requested_department_case)
    (central_case_validated ?central_registrar_case - central_registrar_case)
  )
  (:action submit_registration_case
    :parameters (?registration_case - registration_case)
    :precondition
      (and
        (not
          (case_submitted ?registration_case)
        )
        (not
          (case_finalized ?registration_case)
        )
      )
    :effect (case_submitted ?registration_case)
  )
  (:action assign_department_approver
    :parameters (?registration_case - registration_case ?department_approver - department_approver)
    :precondition
      (and
        (case_submitted ?registration_case)
        (not
          (approver_assigned ?registration_case)
        )
        (approver_available ?department_approver)
      )
    :effect
      (and
        (approver_assigned ?registration_case)
        (assigned_approver ?registration_case ?department_approver)
        (not
          (approver_available ?department_approver)
        )
      )
  )
  (:action propose_time_slot_for_case
    :parameters (?registration_case - registration_case ?proposed_time_slot - proposed_time_slot)
    :precondition
      (and
        (case_submitted ?registration_case)
        (approver_assigned ?registration_case)
        (proposed_time_slot_available ?proposed_time_slot)
      )
    :effect
      (and
        (case_proposed_time ?registration_case ?proposed_time_slot)
        (not
          (proposed_time_slot_available ?proposed_time_slot)
        )
      )
  )
  (:action confirm_proposed_time
    :parameters (?registration_case - registration_case ?proposed_time_slot - proposed_time_slot)
    :precondition
      (and
        (case_submitted ?registration_case)
        (approver_assigned ?registration_case)
        (case_proposed_time ?registration_case ?proposed_time_slot)
        (not
          (case_acknowledged ?registration_case)
        )
      )
    :effect (case_acknowledged ?registration_case)
  )
  (:action release_proposed_time
    :parameters (?registration_case - registration_case ?proposed_time_slot - proposed_time_slot)
    :precondition
      (and
        (case_proposed_time ?registration_case ?proposed_time_slot)
      )
    :effect
      (and
        (proposed_time_slot_available ?proposed_time_slot)
        (not
          (case_proposed_time ?registration_case ?proposed_time_slot)
        )
      )
  )
  (:action assign_department_reviewer
    :parameters (?registration_case - registration_case ?department_reviewer - department_reviewer)
    :precondition
      (and
        (case_acknowledged ?registration_case)
        (reviewer_available ?department_reviewer)
      )
    :effect
      (and
        (assigned_reviewer ?registration_case ?department_reviewer)
        (not
          (reviewer_available ?department_reviewer)
        )
      )
  )
  (:action revoke_department_reviewer_assignment
    :parameters (?registration_case - registration_case ?department_reviewer - department_reviewer)
    :precondition
      (and
        (assigned_reviewer ?registration_case ?department_reviewer)
      )
    :effect
      (and
        (reviewer_available ?department_reviewer)
        (not
          (assigned_reviewer ?registration_case ?department_reviewer)
        )
      )
  )
  (:action claim_instructor_availability_for_case
    :parameters (?central_registrar_case - central_registrar_case ?instructor_availability - instructor_availability)
    :precondition
      (and
        (case_acknowledged ?central_registrar_case)
        (instructor_availability_available ?instructor_availability)
      )
    :effect
      (and
        (central_assigned_instructor_availability ?central_registrar_case ?instructor_availability)
        (not
          (instructor_availability_available ?instructor_availability)
        )
      )
  )
  (:action release_instructor_availability_for_case
    :parameters (?central_registrar_case - central_registrar_case ?instructor_availability - instructor_availability)
    :precondition
      (and
        (central_assigned_instructor_availability ?central_registrar_case ?instructor_availability)
      )
    :effect
      (and
        (instructor_availability_available ?instructor_availability)
        (not
          (central_assigned_instructor_availability ?central_registrar_case ?instructor_availability)
        )
      )
  )
  (:action claim_escalation_approval_for_case
    :parameters (?central_registrar_case - central_registrar_case ?escalation_approval - escalation_approval)
    :precondition
      (and
        (case_acknowledged ?central_registrar_case)
        (escalation_approval_available ?escalation_approval)
      )
    :effect
      (and
        (central_has_escalation_approval ?central_registrar_case ?escalation_approval)
        (not
          (escalation_approval_available ?escalation_approval)
        )
      )
  )
  (:action release_escalation_approval_for_case
    :parameters (?central_registrar_case - central_registrar_case ?escalation_approval - escalation_approval)
    :precondition
      (and
        (central_has_escalation_approval ?central_registrar_case ?escalation_approval)
      )
    :effect
      (and
        (escalation_approval_available ?escalation_approval)
        (not
          (central_has_escalation_approval ?central_registrar_case ?escalation_approval)
        )
      )
  )
  (:action reserve_home_time_option
    :parameters (?home_department_case - home_department_case ?home_time_option - home_time_option ?proposed_time_slot - proposed_time_slot)
    :precondition
      (and
        (case_acknowledged ?home_department_case)
        (case_proposed_time ?home_department_case ?proposed_time_slot)
        (home_case_time_option ?home_department_case ?home_time_option)
        (not
          (home_time_reserved ?home_time_option)
        )
        (not
          (home_time_supported ?home_time_option)
        )
      )
    :effect (home_time_reserved ?home_time_option)
  )
  (:action home_reviewer_confirm_time
    :parameters (?home_department_case - home_department_case ?home_time_option - home_time_option ?department_reviewer - department_reviewer)
    :precondition
      (and
        (case_acknowledged ?home_department_case)
        (assigned_reviewer ?home_department_case ?department_reviewer)
        (home_case_time_option ?home_department_case ?home_time_option)
        (home_time_reserved ?home_time_option)
        (not
          (home_case_time_ready ?home_department_case)
        )
      )
    :effect
      (and
        (home_case_time_ready ?home_department_case)
        (home_case_time_confirmed ?home_department_case)
      )
  )
  (:action attach_supporting_document_to_home_case
    :parameters (?home_department_case - home_department_case ?home_time_option - home_time_option ?supporting_document - supporting_document)
    :precondition
      (and
        (case_acknowledged ?home_department_case)
        (home_case_time_option ?home_department_case ?home_time_option)
        (supporting_doc_available ?supporting_document)
        (not
          (home_case_time_ready ?home_department_case)
        )
      )
    :effect
      (and
        (home_time_supported ?home_time_option)
        (home_case_time_ready ?home_department_case)
        (home_case_attached_document ?home_department_case ?supporting_document)
        (not
          (supporting_doc_available ?supporting_document)
        )
      )
  )
  (:action finalize_home_time_negotiation
    :parameters (?home_department_case - home_department_case ?home_time_option - home_time_option ?proposed_time_slot - proposed_time_slot ?supporting_document - supporting_document)
    :precondition
      (and
        (case_acknowledged ?home_department_case)
        (case_proposed_time ?home_department_case ?proposed_time_slot)
        (home_case_time_option ?home_department_case ?home_time_option)
        (home_time_supported ?home_time_option)
        (home_case_attached_document ?home_department_case ?supporting_document)
        (not
          (home_case_time_confirmed ?home_department_case)
        )
      )
    :effect
      (and
        (home_time_reserved ?home_time_option)
        (home_case_time_confirmed ?home_department_case)
        (supporting_doc_available ?supporting_document)
        (not
          (home_case_attached_document ?home_department_case ?supporting_document)
        )
      )
  )
  (:action reserve_requested_time_option
    :parameters (?requested_department_case - requested_department_case ?requested_time_option - requested_time_option ?proposed_time_slot - proposed_time_slot)
    :precondition
      (and
        (case_acknowledged ?requested_department_case)
        (case_proposed_time ?requested_department_case ?proposed_time_slot)
        (requested_case_time_option ?requested_department_case ?requested_time_option)
        (not
          (requested_time_reserved ?requested_time_option)
        )
        (not
          (requested_time_supported ?requested_time_option)
        )
      )
    :effect (requested_time_reserved ?requested_time_option)
  )
  (:action requested_reviewer_confirm_time
    :parameters (?requested_department_case - requested_department_case ?requested_time_option - requested_time_option ?department_reviewer - department_reviewer)
    :precondition
      (and
        (case_acknowledged ?requested_department_case)
        (assigned_reviewer ?requested_department_case ?department_reviewer)
        (requested_case_time_option ?requested_department_case ?requested_time_option)
        (requested_time_reserved ?requested_time_option)
        (not
          (requested_case_time_ready ?requested_department_case)
        )
      )
    :effect
      (and
        (requested_case_time_ready ?requested_department_case)
        (requested_case_time_confirmed ?requested_department_case)
      )
  )
  (:action attach_supporting_document_to_requested_case
    :parameters (?requested_department_case - requested_department_case ?requested_time_option - requested_time_option ?supporting_document - supporting_document)
    :precondition
      (and
        (case_acknowledged ?requested_department_case)
        (requested_case_time_option ?requested_department_case ?requested_time_option)
        (supporting_doc_available ?supporting_document)
        (not
          (requested_case_time_ready ?requested_department_case)
        )
      )
    :effect
      (and
        (requested_time_supported ?requested_time_option)
        (requested_case_time_ready ?requested_department_case)
        (requested_case_attached_document ?requested_department_case ?supporting_document)
        (not
          (supporting_doc_available ?supporting_document)
        )
      )
  )
  (:action finalize_requested_time_negotiation
    :parameters (?requested_department_case - requested_department_case ?requested_time_option - requested_time_option ?proposed_time_slot - proposed_time_slot ?supporting_document - supporting_document)
    :precondition
      (and
        (case_acknowledged ?requested_department_case)
        (case_proposed_time ?requested_department_case ?proposed_time_slot)
        (requested_case_time_option ?requested_department_case ?requested_time_option)
        (requested_time_supported ?requested_time_option)
        (requested_case_attached_document ?requested_department_case ?supporting_document)
        (not
          (requested_case_time_confirmed ?requested_department_case)
        )
      )
    :effect
      (and
        (requested_time_reserved ?requested_time_option)
        (requested_case_time_confirmed ?requested_department_case)
        (supporting_doc_available ?supporting_document)
        (not
          (requested_case_attached_document ?requested_department_case ?supporting_document)
        )
      )
  )
  (:action provision_provisional_section_standard
    :parameters (?home_department_case - home_department_case ?requested_department_case - requested_department_case ?home_time_option - home_time_option ?requested_time_option - requested_time_option ?provisional_section - provisional_section)
    :precondition
      (and
        (home_case_time_ready ?home_department_case)
        (requested_case_time_ready ?requested_department_case)
        (home_case_time_option ?home_department_case ?home_time_option)
        (requested_case_time_option ?requested_department_case ?requested_time_option)
        (home_time_reserved ?home_time_option)
        (requested_time_reserved ?requested_time_option)
        (home_case_time_confirmed ?home_department_case)
        (requested_case_time_confirmed ?requested_department_case)
        (section_unallocated ?provisional_section)
      )
    :effect
      (and
        (section_allocated ?provisional_section)
        (section_has_home_time_option ?provisional_section ?home_time_option)
        (section_has_requested_time_option ?provisional_section ?requested_time_option)
        (not
          (section_unallocated ?provisional_section)
        )
      )
  )
  (:action provision_provisional_section_with_home_support
    :parameters (?home_department_case - home_department_case ?requested_department_case - requested_department_case ?home_time_option - home_time_option ?requested_time_option - requested_time_option ?provisional_section - provisional_section)
    :precondition
      (and
        (home_case_time_ready ?home_department_case)
        (requested_case_time_ready ?requested_department_case)
        (home_case_time_option ?home_department_case ?home_time_option)
        (requested_case_time_option ?requested_department_case ?requested_time_option)
        (home_time_supported ?home_time_option)
        (requested_time_reserved ?requested_time_option)
        (not
          (home_case_time_confirmed ?home_department_case)
        )
        (requested_case_time_confirmed ?requested_department_case)
        (section_unallocated ?provisional_section)
      )
    :effect
      (and
        (section_allocated ?provisional_section)
        (section_has_home_time_option ?provisional_section ?home_time_option)
        (section_has_requested_time_option ?provisional_section ?requested_time_option)
        (section_home_time_supported ?provisional_section)
        (not
          (section_unallocated ?provisional_section)
        )
      )
  )
  (:action provision_provisional_section_with_requested_support
    :parameters (?home_department_case - home_department_case ?requested_department_case - requested_department_case ?home_time_option - home_time_option ?requested_time_option - requested_time_option ?provisional_section - provisional_section)
    :precondition
      (and
        (home_case_time_ready ?home_department_case)
        (requested_case_time_ready ?requested_department_case)
        (home_case_time_option ?home_department_case ?home_time_option)
        (requested_case_time_option ?requested_department_case ?requested_time_option)
        (home_time_reserved ?home_time_option)
        (requested_time_supported ?requested_time_option)
        (home_case_time_confirmed ?home_department_case)
        (not
          (requested_case_time_confirmed ?requested_department_case)
        )
        (section_unallocated ?provisional_section)
      )
    :effect
      (and
        (section_allocated ?provisional_section)
        (section_has_home_time_option ?provisional_section ?home_time_option)
        (section_has_requested_time_option ?provisional_section ?requested_time_option)
        (section_requested_time_supported ?provisional_section)
        (not
          (section_unallocated ?provisional_section)
        )
      )
  )
  (:action provision_provisional_section_with_both_supports
    :parameters (?home_department_case - home_department_case ?requested_department_case - requested_department_case ?home_time_option - home_time_option ?requested_time_option - requested_time_option ?provisional_section - provisional_section)
    :precondition
      (and
        (home_case_time_ready ?home_department_case)
        (requested_case_time_ready ?requested_department_case)
        (home_case_time_option ?home_department_case ?home_time_option)
        (requested_case_time_option ?requested_department_case ?requested_time_option)
        (home_time_supported ?home_time_option)
        (requested_time_supported ?requested_time_option)
        (not
          (home_case_time_confirmed ?home_department_case)
        )
        (not
          (requested_case_time_confirmed ?requested_department_case)
        )
        (section_unallocated ?provisional_section)
      )
    :effect
      (and
        (section_allocated ?provisional_section)
        (section_has_home_time_option ?provisional_section ?home_time_option)
        (section_has_requested_time_option ?provisional_section ?requested_time_option)
        (section_home_time_supported ?provisional_section)
        (section_requested_time_supported ?provisional_section)
        (not
          (section_unallocated ?provisional_section)
        )
      )
  )
  (:action lock_provisional_section
    :parameters (?provisional_section - provisional_section ?home_department_case - home_department_case ?proposed_time_slot - proposed_time_slot)
    :precondition
      (and
        (section_allocated ?provisional_section)
        (home_case_time_ready ?home_department_case)
        (case_proposed_time ?home_department_case ?proposed_time_slot)
        (not
          (section_locked ?provisional_section)
        )
      )
    :effect (section_locked ?provisional_section)
  )
  (:action reserve_room_for_section
    :parameters (?central_registrar_case - central_registrar_case ?room - room ?provisional_section - provisional_section)
    :precondition
      (and
        (case_acknowledged ?central_registrar_case)
        (central_has_provisional_section ?central_registrar_case ?provisional_section)
        (central_has_room_option ?central_registrar_case ?room)
        (room_available ?room)
        (section_allocated ?provisional_section)
        (section_locked ?provisional_section)
        (not
          (room_reserved ?room)
        )
      )
    :effect
      (and
        (room_reserved ?room)
        (room_assigned_to_section ?room ?provisional_section)
        (not
          (room_available ?room)
        )
      )
  )
  (:action confirm_room_assignment_for_section
    :parameters (?central_registrar_case - central_registrar_case ?room - room ?provisional_section - provisional_section ?proposed_time_slot - proposed_time_slot)
    :precondition
      (and
        (case_acknowledged ?central_registrar_case)
        (central_has_room_option ?central_registrar_case ?room)
        (room_reserved ?room)
        (room_assigned_to_section ?room ?provisional_section)
        (case_proposed_time ?central_registrar_case ?proposed_time_slot)
        (not
          (section_home_time_supported ?provisional_section)
        )
        (not
          (instructor_assignment_initiated ?central_registrar_case)
        )
      )
    :effect (instructor_assignment_initiated ?central_registrar_case)
  )
  (:action reserve_auxiliary_resource_for_case
    :parameters (?central_registrar_case - central_registrar_case ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (case_acknowledged ?central_registrar_case)
        (aux_resource_available ?auxiliary_resource)
        (not
          (central_case_aux_resource_reserved ?central_registrar_case)
        )
      )
    :effect
      (and
        (central_case_aux_resource_reserved ?central_registrar_case)
        (central_has_aux_resource ?central_registrar_case ?auxiliary_resource)
        (not
          (aux_resource_available ?auxiliary_resource)
        )
      )
  )
  (:action lock_auxiliary_resource_assignment
    :parameters (?central_registrar_case - central_registrar_case ?room - room ?provisional_section - provisional_section ?proposed_time_slot - proposed_time_slot ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (case_acknowledged ?central_registrar_case)
        (central_has_room_option ?central_registrar_case ?room)
        (room_reserved ?room)
        (room_assigned_to_section ?room ?provisional_section)
        (case_proposed_time ?central_registrar_case ?proposed_time_slot)
        (section_home_time_supported ?provisional_section)
        (central_case_aux_resource_reserved ?central_registrar_case)
        (central_has_aux_resource ?central_registrar_case ?auxiliary_resource)
        (not
          (instructor_assignment_initiated ?central_registrar_case)
        )
      )
    :effect
      (and
        (instructor_assignment_initiated ?central_registrar_case)
        (auxiliary_reservation_locked ?central_registrar_case)
      )
  )
  (:action assign_instructor_to_central_case
    :parameters (?central_registrar_case - central_registrar_case ?instructor_availability - instructor_availability ?department_reviewer - department_reviewer ?room - room ?provisional_section - provisional_section)
    :precondition
      (and
        (instructor_assignment_initiated ?central_registrar_case)
        (central_assigned_instructor_availability ?central_registrar_case ?instructor_availability)
        (assigned_reviewer ?central_registrar_case ?department_reviewer)
        (central_has_room_option ?central_registrar_case ?room)
        (room_assigned_to_section ?room ?provisional_section)
        (not
          (section_requested_time_supported ?provisional_section)
        )
        (not
          (instructor_assigned ?central_registrar_case)
        )
      )
    :effect (instructor_assigned ?central_registrar_case)
  )
  (:action confirm_instructor_assignment
    :parameters (?central_registrar_case - central_registrar_case ?instructor_availability - instructor_availability ?department_reviewer - department_reviewer ?room - room ?provisional_section - provisional_section)
    :precondition
      (and
        (instructor_assignment_initiated ?central_registrar_case)
        (central_assigned_instructor_availability ?central_registrar_case ?instructor_availability)
        (assigned_reviewer ?central_registrar_case ?department_reviewer)
        (central_has_room_option ?central_registrar_case ?room)
        (room_assigned_to_section ?room ?provisional_section)
        (section_requested_time_supported ?provisional_section)
        (not
          (instructor_assigned ?central_registrar_case)
        )
      )
    :effect (instructor_assigned ?central_registrar_case)
  )
  (:action authorize_instructor_escalation
    :parameters (?central_registrar_case - central_registrar_case ?escalation_approval - escalation_approval ?room - room ?provisional_section - provisional_section)
    :precondition
      (and
        (instructor_assigned ?central_registrar_case)
        (central_has_escalation_approval ?central_registrar_case ?escalation_approval)
        (central_has_room_option ?central_registrar_case ?room)
        (room_assigned_to_section ?room ?provisional_section)
        (not
          (section_home_time_supported ?provisional_section)
        )
        (not
          (section_requested_time_supported ?provisional_section)
        )
        (not
          (instructor_availability_confirmed ?central_registrar_case)
        )
      )
    :effect (instructor_availability_confirmed ?central_registrar_case)
  )
  (:action authorize_instructor_escalation_and_record
    :parameters (?central_registrar_case - central_registrar_case ?escalation_approval - escalation_approval ?room - room ?provisional_section - provisional_section)
    :precondition
      (and
        (instructor_assigned ?central_registrar_case)
        (central_has_escalation_approval ?central_registrar_case ?escalation_approval)
        (central_has_room_option ?central_registrar_case ?room)
        (room_assigned_to_section ?room ?provisional_section)
        (section_home_time_supported ?provisional_section)
        (not
          (section_requested_time_supported ?provisional_section)
        )
        (not
          (instructor_availability_confirmed ?central_registrar_case)
        )
      )
    :effect
      (and
        (instructor_availability_confirmed ?central_registrar_case)
        (policy_exception_attached ?central_registrar_case)
      )
  )
  (:action authorize_instructor_escalation_alternate
    :parameters (?central_registrar_case - central_registrar_case ?escalation_approval - escalation_approval ?room - room ?provisional_section - provisional_section)
    :precondition
      (and
        (instructor_assigned ?central_registrar_case)
        (central_has_escalation_approval ?central_registrar_case ?escalation_approval)
        (central_has_room_option ?central_registrar_case ?room)
        (room_assigned_to_section ?room ?provisional_section)
        (not
          (section_home_time_supported ?provisional_section)
        )
        (section_requested_time_supported ?provisional_section)
        (not
          (instructor_availability_confirmed ?central_registrar_case)
        )
      )
    :effect
      (and
        (instructor_availability_confirmed ?central_registrar_case)
        (policy_exception_attached ?central_registrar_case)
      )
  )
  (:action authorize_instructor_escalation_finalize
    :parameters (?central_registrar_case - central_registrar_case ?escalation_approval - escalation_approval ?room - room ?provisional_section - provisional_section)
    :precondition
      (and
        (instructor_assigned ?central_registrar_case)
        (central_has_escalation_approval ?central_registrar_case ?escalation_approval)
        (central_has_room_option ?central_registrar_case ?room)
        (room_assigned_to_section ?room ?provisional_section)
        (section_home_time_supported ?provisional_section)
        (section_requested_time_supported ?provisional_section)
        (not
          (instructor_availability_confirmed ?central_registrar_case)
        )
      )
    :effect
      (and
        (instructor_availability_confirmed ?central_registrar_case)
        (policy_exception_attached ?central_registrar_case)
      )
  )
  (:action finalize_central_case_standard
    :parameters (?central_registrar_case - central_registrar_case)
    :precondition
      (and
        (instructor_availability_confirmed ?central_registrar_case)
        (not
          (policy_exception_attached ?central_registrar_case)
        )
        (not
          (central_case_validated ?central_registrar_case)
        )
      )
    :effect
      (and
        (central_case_validated ?central_registrar_case)
        (enrollment_recorded ?central_registrar_case)
      )
  )
  (:action attach_policy_exception_to_central_case
    :parameters (?central_registrar_case - central_registrar_case ?policy_exception_type - policy_exception_type)
    :precondition
      (and
        (instructor_availability_confirmed ?central_registrar_case)
        (policy_exception_attached ?central_registrar_case)
        (policy_exception_available ?policy_exception_type)
      )
    :effect
      (and
        (central_has_policy_exception ?central_registrar_case ?policy_exception_type)
        (not
          (policy_exception_available ?policy_exception_type)
        )
      )
  )
  (:action validate_central_case_for_enrollment
    :parameters (?central_registrar_case - central_registrar_case ?home_department_case - home_department_case ?requested_department_case - requested_department_case ?proposed_time_slot - proposed_time_slot ?policy_exception_type - policy_exception_type)
    :precondition
      (and
        (instructor_availability_confirmed ?central_registrar_case)
        (policy_exception_attached ?central_registrar_case)
        (central_has_policy_exception ?central_registrar_case ?policy_exception_type)
        (central_has_home_case ?central_registrar_case ?home_department_case)
        (central_has_requested_case ?central_registrar_case ?requested_department_case)
        (home_case_time_confirmed ?home_department_case)
        (requested_case_time_confirmed ?requested_department_case)
        (case_proposed_time ?central_registrar_case ?proposed_time_slot)
        (not
          (central_case_instructor_confirmed ?central_registrar_case)
        )
      )
    :effect (central_case_instructor_confirmed ?central_registrar_case)
  )
  (:action finalize_central_case_with_instructor_confirmation
    :parameters (?central_registrar_case - central_registrar_case)
    :precondition
      (and
        (instructor_availability_confirmed ?central_registrar_case)
        (central_case_instructor_confirmed ?central_registrar_case)
        (not
          (central_case_validated ?central_registrar_case)
        )
      )
    :effect
      (and
        (central_case_validated ?central_registrar_case)
        (enrollment_recorded ?central_registrar_case)
      )
  )
  (:action request_external_authorization
    :parameters (?central_registrar_case - central_registrar_case ?external_authorization - external_authorization ?proposed_time_slot - proposed_time_slot)
    :precondition
      (and
        (case_acknowledged ?central_registrar_case)
        (case_proposed_time ?central_registrar_case ?proposed_time_slot)
        (external_authorization_available ?external_authorization)
        (central_has_external_authorization ?central_registrar_case ?external_authorization)
        (not
          (external_authorization_attached ?central_registrar_case)
        )
      )
    :effect
      (and
        (external_authorization_attached ?central_registrar_case)
        (not
          (external_authorization_available ?external_authorization)
        )
      )
  )
  (:action verify_external_authorization_by_reviewer
    :parameters (?central_registrar_case - central_registrar_case ?department_reviewer - department_reviewer)
    :precondition
      (and
        (external_authorization_attached ?central_registrar_case)
        (assigned_reviewer ?central_registrar_case ?department_reviewer)
        (not
          (external_authorization_verified ?central_registrar_case)
        )
      )
    :effect (external_authorization_verified ?central_registrar_case)
  )
  (:action confirm_external_authorization
    :parameters (?central_registrar_case - central_registrar_case ?escalation_approval - escalation_approval)
    :precondition
      (and
        (external_authorization_verified ?central_registrar_case)
        (central_has_escalation_approval ?central_registrar_case ?escalation_approval)
        (not
          (external_authorization_finalized ?central_registrar_case)
        )
      )
    :effect (external_authorization_finalized ?central_registrar_case)
  )
  (:action finalize_external_authorization
    :parameters (?central_registrar_case - central_registrar_case)
    :precondition
      (and
        (external_authorization_finalized ?central_registrar_case)
        (not
          (central_case_validated ?central_registrar_case)
        )
      )
    :effect
      (and
        (central_case_validated ?central_registrar_case)
        (enrollment_recorded ?central_registrar_case)
      )
  )
  (:action record_enrollment_home_department
    :parameters (?home_department_case - home_department_case ?provisional_section - provisional_section)
    :precondition
      (and
        (home_case_time_ready ?home_department_case)
        (home_case_time_confirmed ?home_department_case)
        (section_allocated ?provisional_section)
        (section_locked ?provisional_section)
        (not
          (enrollment_recorded ?home_department_case)
        )
      )
    :effect (enrollment_recorded ?home_department_case)
  )
  (:action record_enrollment_requested_department
    :parameters (?requested_department_case - requested_department_case ?provisional_section - provisional_section)
    :precondition
      (and
        (requested_case_time_ready ?requested_department_case)
        (requested_case_time_confirmed ?requested_department_case)
        (section_allocated ?provisional_section)
        (section_locked ?provisional_section)
        (not
          (enrollment_recorded ?requested_department_case)
        )
      )
    :effect (enrollment_recorded ?requested_department_case)
  )
  (:action consume_deadline_and_propagate_approval
    :parameters (?registration_case - registration_case ?deadline_document - deadline_document ?proposed_time_slot - proposed_time_slot)
    :precondition
      (and
        (enrollment_recorded ?registration_case)
        (case_proposed_time ?registration_case ?proposed_time_slot)
        (deadline_document_available ?deadline_document)
        (not
          (final_approval ?registration_case)
        )
      )
    :effect
      (and
        (final_approval ?registration_case)
        (case_has_deadline_document ?registration_case ?deadline_document)
        (not
          (deadline_document_available ?deadline_document)
        )
      )
  )
  (:action finalize_home_department_record
    :parameters (?home_department_case - home_department_case ?department_approver - department_approver ?deadline_document - deadline_document)
    :precondition
      (and
        (final_approval ?home_department_case)
        (assigned_approver ?home_department_case ?department_approver)
        (case_has_deadline_document ?home_department_case ?deadline_document)
        (not
          (case_finalized ?home_department_case)
        )
      )
    :effect
      (and
        (case_finalized ?home_department_case)
        (approver_available ?department_approver)
        (deadline_document_available ?deadline_document)
      )
  )
  (:action finalize_requested_department_record
    :parameters (?requested_department_case - requested_department_case ?department_approver - department_approver ?deadline_document - deadline_document)
    :precondition
      (and
        (final_approval ?requested_department_case)
        (assigned_approver ?requested_department_case ?department_approver)
        (case_has_deadline_document ?requested_department_case ?deadline_document)
        (not
          (case_finalized ?requested_department_case)
        )
      )
    :effect
      (and
        (case_finalized ?requested_department_case)
        (approver_available ?department_approver)
        (deadline_document_available ?deadline_document)
      )
  )
  (:action finalize_central_registrar_record
    :parameters (?central_registrar_case - central_registrar_case ?department_approver - department_approver ?deadline_document - deadline_document)
    :precondition
      (and
        (final_approval ?central_registrar_case)
        (assigned_approver ?central_registrar_case ?department_approver)
        (case_has_deadline_document ?central_registrar_case ?deadline_document)
        (not
          (case_finalized ?central_registrar_case)
        )
      )
    :effect
      (and
        (case_finalized ?central_registrar_case)
        (approver_available ?department_approver)
        (deadline_document_available ?deadline_document)
      )
  )
)

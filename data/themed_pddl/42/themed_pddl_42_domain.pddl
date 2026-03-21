(define (domain operating_room_block_reallocation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types reallocation_case - object operating_room_block - object time_slot - object nursing_team - object surgeon - object anesthesia_team - object auxiliary_operating_room - object credential_reviewer - object approval_document - object facilities_coordinator - object supply_kit - object special_equipment - object approver_group - object department_approver - approver_group compliance_approver - approver_group scheduled_block_case - reallocation_case ad_hoc_block_case - reallocation_case)
  (:predicates
    (credential_reviewer_available ?credential_reviewer - credential_reviewer)
    (assigned_nursing_team ?reallocation_case - reallocation_case ?nursing_team - nursing_team)
    (case_final_clinical_signoff ?reallocation_case - reallocation_case)
    (case_assigned_block ?reallocation_case - reallocation_case ?operating_room_block - operating_room_block)
    (case_assigned_approver_group ?reallocation_case - reallocation_case ?approver_group - approver_group)
    (anesthesia_team_available ?anesthesia_team - anesthesia_team)
    (nursing_team_available ?nursing_team - nursing_team)
    (case_equipment_eligible ?reallocation_case - reallocation_case ?special_equipment - special_equipment)
    (case_closed ?reallocation_case - reallocation_case)
    (is_scheduled_case ?reallocation_case - reallocation_case)
    (case_block_eligible ?reallocation_case - reallocation_case ?operating_room_block - operating_room_block)
    (time_slot_available ?time_slot - time_slot)
    (supply_kit_available ?supply_kit - supply_kit)
    (aux_or_available ?auxiliary_operating_room - auxiliary_operating_room)
    (case_schedule_confirmed ?reallocation_case - reallocation_case)
    (case_nursing_eligible ?reallocation_case - reallocation_case ?nursing_team - nursing_team)
    (assigned_special_equipment ?reallocation_case - reallocation_case ?special_equipment - special_equipment)
    (case_scheduled_slot ?reallocation_case - reallocation_case ?time_slot - time_slot)
    (case_department_approval_obtained ?reallocation_case - reallocation_case)
    (case_anesthesia_eligible ?reallocation_case - reallocation_case ?anesthesia_team - anesthesia_team)
    (special_equipment_available ?special_equipment - special_equipment)
    (is_ad_hoc_case ?reallocation_case - reallocation_case)
    (case_operational_readiness_confirmed ?reallocation_case - reallocation_case)
    (case_surgeon_eligible ?reallocation_case - reallocation_case ?surgeon - surgeon)
    (assigned_surgeon ?reallocation_case - reallocation_case ?surgeon - surgeon)
    (clinical_review_requested ?reallocation_case - reallocation_case)
    (case_assigned_aux_or ?reallocation_case - reallocation_case ?auxiliary_operating_room - auxiliary_operating_room)
    (case_supply_and_equipment_verified ?reallocation_case - reallocation_case)
    (case_supplykit_eligible ?reallocation_case - reallocation_case ?supply_kit - supply_kit)
    (case_registered ?reallocation_case - reallocation_case)
    (block_available ?operating_room_block - operating_room_block)
    (case_has_block ?reallocation_case - reallocation_case)
    (facilities_coordinator_available ?facilities_coordinator - facilities_coordinator)
    (approval_document_available ?approval_document - approval_document)
    (assigned_anesthesia_team ?reallocation_case - reallocation_case ?anesthesia_team - anesthesia_team)
    (case_document_registered ?reallocation_case - reallocation_case ?approval_document - approval_document)
    (case_clinical_confirmation_obtained ?reallocation_case - reallocation_case)
    (case_facilities_check_completed ?reallocation_case - reallocation_case)
    (case_document_association ?reallocation_case - reallocation_case ?approval_document - approval_document)
    (surgeon_available ?surgeon - surgeon)
    (case_linked_document ?reallocation_case - reallocation_case ?approval_document - approval_document)
    (case_timeslot_eligible ?reallocation_case - reallocation_case ?time_slot - time_slot)
    (case_credential_verification_recorded ?reallocation_case - reallocation_case)
    (case_document_applied ?reallocation_case - reallocation_case ?approval_document - approval_document)
  )
  (:action release_special_equipment
    :parameters (?reallocation_case - reallocation_case ?special_equipment - special_equipment)
    :precondition
      (and
        (assigned_special_equipment ?reallocation_case ?special_equipment)
      )
    :effect
      (and
        (special_equipment_available ?special_equipment)
        (not
          (assigned_special_equipment ?reallocation_case ?special_equipment)
        )
      )
  )
  (:action obtain_administrative_approval
    :parameters (?reallocation_case - reallocation_case ?anesthesia_team - anesthesia_team ?special_equipment - special_equipment ?compliance_approver - compliance_approver)
    :precondition
      (and
        (not
          (case_department_approval_obtained ?reallocation_case)
        )
        (case_schedule_confirmed ?reallocation_case)
        (case_operational_readiness_confirmed ?reallocation_case)
        (assigned_special_equipment ?reallocation_case ?special_equipment)
        (case_assigned_approver_group ?reallocation_case ?compliance_approver)
        (assigned_anesthesia_team ?reallocation_case ?anesthesia_team)
      )
    :effect
      (and
        (case_credential_verification_recorded ?reallocation_case)
        (case_department_approval_obtained ?reallocation_case)
      )
  )
  (:action close_case_finalization
    :parameters (?reallocation_case - reallocation_case)
    :precondition
      (and
        (case_operational_readiness_confirmed ?reallocation_case)
        (case_has_block ?reallocation_case)
        (case_schedule_confirmed ?reallocation_case)
        (case_registered ?reallocation_case)
        (case_facilities_check_completed ?reallocation_case)
        (not
          (case_closed ?reallocation_case)
        )
        (is_scheduled_case ?reallocation_case)
        (case_department_approval_obtained ?reallocation_case)
      )
    :effect
      (and
        (case_closed ?reallocation_case)
      )
  )
  (:action clear_clinical_followup_review
    :parameters (?reallocation_case - reallocation_case ?surgeon - surgeon ?nursing_team - nursing_team)
    :precondition
      (and
        (case_schedule_confirmed ?reallocation_case)
        (clinical_review_requested ?reallocation_case)
        (assigned_surgeon ?reallocation_case ?surgeon)
        (assigned_nursing_team ?reallocation_case ?nursing_team)
      )
    :effect
      (and
        (not
          (clinical_review_requested ?reallocation_case)
        )
        (not
          (case_credential_verification_recorded ?reallocation_case)
        )
      )
  )
  (:action assign_auxiliary_operating_room
    :parameters (?reallocation_case - reallocation_case ?auxiliary_operating_room - auxiliary_operating_room)
    :precondition
      (and
        (aux_or_available ?auxiliary_operating_room)
        (case_registered ?reallocation_case)
      )
    :effect
      (and
        (not
          (aux_or_available ?auxiliary_operating_room)
        )
        (case_assigned_aux_or ?reallocation_case ?auxiliary_operating_room)
      )
  )
  (:action obtain_department_approval
    :parameters (?reallocation_case - reallocation_case ?surgeon - surgeon ?nursing_team - nursing_team ?department_approver - department_approver)
    :precondition
      (and
        (case_assigned_approver_group ?reallocation_case ?department_approver)
        (case_operational_readiness_confirmed ?reallocation_case)
        (not
          (case_credential_verification_recorded ?reallocation_case)
        )
        (assigned_surgeon ?reallocation_case ?surgeon)
        (case_schedule_confirmed ?reallocation_case)
        (assigned_nursing_team ?reallocation_case ?nursing_team)
        (not
          (case_department_approval_obtained ?reallocation_case)
        )
      )
    :effect
      (and
        (case_department_approval_obtained ?reallocation_case)
      )
  )
  (:action apply_approval_document_for_readiness
    :parameters (?reallocation_case - reallocation_case ?approval_document - approval_document)
    :precondition
      (and
        (case_has_block ?reallocation_case)
        (case_document_applied ?reallocation_case ?approval_document)
        (not
          (case_operational_readiness_confirmed ?reallocation_case)
        )
      )
    :effect
      (and
        (case_operational_readiness_confirmed ?reallocation_case)
        (not
          (case_credential_verification_recorded ?reallocation_case)
        )
      )
  )
  (:action reserve_anesthesia_team
    :parameters (?reallocation_case - reallocation_case ?anesthesia_team - anesthesia_team)
    :precondition
      (and
        (case_anesthesia_eligible ?reallocation_case ?anesthesia_team)
        (case_registered ?reallocation_case)
        (anesthesia_team_available ?anesthesia_team)
      )
    :effect
      (and
        (assigned_anesthesia_team ?reallocation_case ?anesthesia_team)
        (not
          (anesthesia_team_available ?anesthesia_team)
        )
      )
  )
  (:action reserve_surgeon_for_case
    :parameters (?reallocation_case - reallocation_case ?surgeon - surgeon)
    :precondition
      (and
        (case_registered ?reallocation_case)
        (surgeon_available ?surgeon)
        (case_surgeon_eligible ?reallocation_case ?surgeon)
      )
    :effect
      (and
        (not
          (surgeon_available ?surgeon)
        )
        (assigned_surgeon ?reallocation_case ?surgeon)
      )
  )
  (:action release_anesthesia_reservation
    :parameters (?reallocation_case - reallocation_case ?anesthesia_team - anesthesia_team)
    :precondition
      (and
        (assigned_anesthesia_team ?reallocation_case ?anesthesia_team)
      )
    :effect
      (and
        (anesthesia_team_available ?anesthesia_team)
        (not
          (assigned_anesthesia_team ?reallocation_case ?anesthesia_team)
        )
      )
  )
  (:action release_nursing_reservation
    :parameters (?reallocation_case - reallocation_case ?nursing_team - nursing_team)
    :precondition
      (and
        (assigned_nursing_team ?reallocation_case ?nursing_team)
      )
    :effect
      (and
        (nursing_team_available ?nursing_team)
        (not
          (assigned_nursing_team ?reallocation_case ?nursing_team)
        )
      )
  )
  (:action register_approval_document_for_case
    :parameters (?reallocation_case - reallocation_case ?approval_document - approval_document)
    :precondition
      (and
        (case_facilities_check_completed ?reallocation_case)
        (approval_document_available ?approval_document)
        (case_document_association ?reallocation_case ?approval_document)
      )
    :effect
      (and
        (case_document_registered ?reallocation_case ?approval_document)
        (not
          (approval_document_available ?approval_document)
        )
      )
  )
  (:action reserve_nursing_team
    :parameters (?reallocation_case - reallocation_case ?nursing_team - nursing_team)
    :precondition
      (and
        (case_registered ?reallocation_case)
        (nursing_team_available ?nursing_team)
        (case_nursing_eligible ?reallocation_case ?nursing_team)
      )
    :effect
      (and
        (assigned_nursing_team ?reallocation_case ?nursing_team)
        (not
          (nursing_team_available ?nursing_team)
        )
      )
  )
  (:action schedule_time_slot_and_confirm
    :parameters (?reallocation_case - reallocation_case ?time_slot - time_slot ?surgeon - surgeon ?nursing_team - nursing_team)
    :precondition
      (and
        (case_has_block ?reallocation_case)
        (time_slot_available ?time_slot)
        (case_timeslot_eligible ?reallocation_case ?time_slot)
        (not
          (case_schedule_confirmed ?reallocation_case)
        )
        (assigned_nursing_team ?reallocation_case ?nursing_team)
        (assigned_surgeon ?reallocation_case ?surgeon)
      )
    :effect
      (and
        (case_scheduled_slot ?reallocation_case ?time_slot)
        (not
          (time_slot_available ?time_slot)
        )
        (case_schedule_confirmed ?reallocation_case)
      )
  )
  (:action finalize_administrative_approval
    :parameters (?reallocation_case - reallocation_case ?surgeon - surgeon ?nursing_team - nursing_team)
    :precondition
      (and
        (assigned_surgeon ?reallocation_case ?surgeon)
        (case_department_approval_obtained ?reallocation_case)
        (assigned_nursing_team ?reallocation_case ?nursing_team)
        (case_credential_verification_recorded ?reallocation_case)
      )
    :effect
      (and
        (not
          (clinical_review_requested ?reallocation_case)
        )
        (not
          (case_credential_verification_recorded ?reallocation_case)
        )
        (not
          (case_operational_readiness_confirmed ?reallocation_case)
        )
        (case_final_clinical_signoff ?reallocation_case)
      )
  )
  (:action release_auxiliary_operating_room
    :parameters (?reallocation_case - reallocation_case ?auxiliary_operating_room - auxiliary_operating_room)
    :precondition
      (and
        (case_assigned_aux_or ?reallocation_case ?auxiliary_operating_room)
      )
    :effect
      (and
        (aux_or_available ?auxiliary_operating_room)
        (not
          (case_assigned_aux_or ?reallocation_case ?auxiliary_operating_room)
        )
      )
  )
  (:action perform_facilities_check
    :parameters (?reallocation_case - reallocation_case ?auxiliary_operating_room - auxiliary_operating_room ?facilities_coordinator - facilities_coordinator)
    :precondition
      (and
        (not
          (case_operational_readiness_confirmed ?reallocation_case)
        )
        (case_has_block ?reallocation_case)
        (facilities_coordinator_available ?facilities_coordinator)
        (case_assigned_aux_or ?reallocation_case ?auxiliary_operating_room)
        (case_clinical_confirmation_obtained ?reallocation_case)
      )
    :effect
      (and
        (not
          (case_credential_verification_recorded ?reallocation_case)
        )
        (case_operational_readiness_confirmed ?reallocation_case)
      )
  )
  (:action close_case_with_supply_verification
    :parameters (?reallocation_case - reallocation_case)
    :precondition
      (and
        (case_registered ?reallocation_case)
        (is_ad_hoc_case ?reallocation_case)
        (case_supply_and_equipment_verified ?reallocation_case)
        (case_has_block ?reallocation_case)
        (case_operational_readiness_confirmed ?reallocation_case)
        (not
          (case_closed ?reallocation_case)
        )
        (case_facilities_check_completed ?reallocation_case)
        (case_schedule_confirmed ?reallocation_case)
        (case_department_approval_obtained ?reallocation_case)
      )
    :effect
      (and
        (case_closed ?reallocation_case)
      )
  )
  (:action mark_operational_readiness_check_complete
    :parameters (?reallocation_case - reallocation_case ?auxiliary_operating_room - auxiliary_operating_room ?facilities_coordinator - facilities_coordinator)
    :precondition
      (and
        (case_operational_readiness_confirmed ?reallocation_case)
        (facilities_coordinator_available ?facilities_coordinator)
        (not
          (case_supply_and_equipment_verified ?reallocation_case)
        )
        (case_facilities_check_completed ?reallocation_case)
        (case_registered ?reallocation_case)
        (is_ad_hoc_case ?reallocation_case)
        (case_assigned_aux_or ?reallocation_case ?auxiliary_operating_room)
      )
    :effect
      (and
        (case_supply_and_equipment_verified ?reallocation_case)
      )
  )
  (:action release_surgeon_reservation
    :parameters (?reallocation_case - reallocation_case ?surgeon - surgeon)
    :precondition
      (and
        (assigned_surgeon ?reallocation_case ?surgeon)
      )
    :effect
      (and
        (surgeon_available ?surgeon)
        (not
          (assigned_surgeon ?reallocation_case ?surgeon)
        )
      )
  )
  (:action reserve_special_equipment
    :parameters (?reallocation_case - reallocation_case ?special_equipment - special_equipment)
    :precondition
      (and
        (special_equipment_available ?special_equipment)
        (case_registered ?reallocation_case)
        (case_equipment_eligible ?reallocation_case ?special_equipment)
      )
    :effect
      (and
        (assigned_special_equipment ?reallocation_case ?special_equipment)
        (not
          (special_equipment_available ?special_equipment)
        )
      )
  )
  (:action register_reallocation_case
    :parameters (?reallocation_case - reallocation_case)
    :precondition
      (and
        (not
          (case_registered ?reallocation_case)
        )
        (not
          (case_closed ?reallocation_case)
        )
      )
    :effect
      (and
        (case_registered ?reallocation_case)
      )
  )
  (:action perform_credential_verification
    :parameters (?reallocation_case - reallocation_case ?credential_reviewer - credential_reviewer)
    :precondition
      (and
        (not
          (case_clinical_confirmation_obtained ?reallocation_case)
        )
        (case_registered ?reallocation_case)
        (credential_reviewer_available ?credential_reviewer)
        (case_has_block ?reallocation_case)
      )
    :effect
      (and
        (case_credential_verification_recorded ?reallocation_case)
        (not
          (credential_reviewer_available ?credential_reviewer)
        )
        (case_clinical_confirmation_obtained ?reallocation_case)
      )
  )
  (:action schedule_time_slot_with_equipment_and_supply_check
    :parameters (?reallocation_case - reallocation_case ?time_slot - time_slot ?anesthesia_team - anesthesia_team ?supply_kit - supply_kit)
    :precondition
      (and
        (supply_kit_available ?supply_kit)
        (case_supplykit_eligible ?reallocation_case ?supply_kit)
        (not
          (case_schedule_confirmed ?reallocation_case)
        )
        (case_has_block ?reallocation_case)
        (time_slot_available ?time_slot)
        (case_timeslot_eligible ?reallocation_case ?time_slot)
        (assigned_anesthesia_team ?reallocation_case ?anesthesia_team)
      )
    :effect
      (and
        (case_scheduled_slot ?reallocation_case ?time_slot)
        (not
          (supply_kit_available ?supply_kit)
        )
        (clinical_review_requested ?reallocation_case)
        (not
          (time_slot_available ?time_slot)
        )
        (case_credential_verification_recorded ?reallocation_case)
        (case_schedule_confirmed ?reallocation_case)
      )
  )
  (:action record_credential_verification_and_mark_facilities_check_complete
    :parameters (?reallocation_case - reallocation_case ?credential_reviewer - credential_reviewer)
    :precondition
      (and
        (credential_reviewer_available ?credential_reviewer)
        (not
          (case_credential_verification_recorded ?reallocation_case)
        )
        (case_operational_readiness_confirmed ?reallocation_case)
        (case_department_approval_obtained ?reallocation_case)
        (not
          (case_facilities_check_completed ?reallocation_case)
        )
      )
    :effect
      (and
        (case_facilities_check_completed ?reallocation_case)
        (not
          (credential_reviewer_available ?credential_reviewer)
        )
      )
  )
  (:action release_operating_room_block
    :parameters (?reallocation_case - reallocation_case ?operating_room_block - operating_room_block)
    :precondition
      (and
        (case_assigned_block ?reallocation_case ?operating_room_block)
        (not
          (case_department_approval_obtained ?reallocation_case)
        )
        (not
          (case_schedule_confirmed ?reallocation_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned_block ?reallocation_case ?operating_room_block)
        )
        (block_available ?operating_room_block)
        (not
          (case_has_block ?reallocation_case)
        )
        (not
          (case_clinical_confirmation_obtained ?reallocation_case)
        )
        (not
          (case_final_clinical_signoff ?reallocation_case)
        )
        (not
          (case_operational_readiness_confirmed ?reallocation_case)
        )
        (not
          (clinical_review_requested ?reallocation_case)
        )
        (not
          (case_credential_verification_recorded ?reallocation_case)
        )
      )
  )
  (:action record_facilities_check_completion
    :parameters (?reallocation_case - reallocation_case ?auxiliary_operating_room - auxiliary_operating_room)
    :precondition
      (and
        (not
          (case_facilities_check_completed ?reallocation_case)
        )
        (case_assigned_aux_or ?reallocation_case ?auxiliary_operating_room)
        (case_operational_readiness_confirmed ?reallocation_case)
        (case_department_approval_obtained ?reallocation_case)
        (not
          (case_credential_verification_recorded ?reallocation_case)
        )
      )
    :effect
      (and
        (case_facilities_check_completed ?reallocation_case)
      )
  )
  (:action close_case_with_document
    :parameters (?reallocation_case - reallocation_case ?approval_document - approval_document)
    :precondition
      (and
        (case_facilities_check_completed ?reallocation_case)
        (case_department_approval_obtained ?reallocation_case)
        (case_schedule_confirmed ?reallocation_case)
        (case_document_applied ?reallocation_case ?approval_document)
        (case_operational_readiness_confirmed ?reallocation_case)
        (case_has_block ?reallocation_case)
        (case_registered ?reallocation_case)
        (not
          (case_closed ?reallocation_case)
        )
        (is_ad_hoc_case ?reallocation_case)
      )
    :effect
      (and
        (case_closed ?reallocation_case)
      )
  )
  (:action confirm_aux_or_for_case
    :parameters (?reallocation_case - reallocation_case ?auxiliary_operating_room - auxiliary_operating_room)
    :precondition
      (and
        (case_registered ?reallocation_case)
        (case_has_block ?reallocation_case)
        (not
          (case_clinical_confirmation_obtained ?reallocation_case)
        )
        (case_assigned_aux_or ?reallocation_case ?auxiliary_operating_room)
      )
    :effect
      (and
        (case_clinical_confirmation_obtained ?reallocation_case)
      )
  )
  (:action claim_operating_room_block
    :parameters (?reallocation_case - reallocation_case ?operating_room_block - operating_room_block)
    :precondition
      (and
        (not
          (case_has_block ?reallocation_case)
        )
        (case_registered ?reallocation_case)
        (block_available ?operating_room_block)
        (case_block_eligible ?reallocation_case ?operating_room_block)
      )
    :effect
      (and
        (case_has_block ?reallocation_case)
        (not
          (block_available ?operating_room_block)
        )
        (case_assigned_block ?reallocation_case ?operating_room_block)
      )
  )
  (:action perform_post_approval_readiness_check
    :parameters (?reallocation_case - reallocation_case ?auxiliary_operating_room - auxiliary_operating_room ?facilities_coordinator - facilities_coordinator)
    :precondition
      (and
        (case_has_block ?reallocation_case)
        (not
          (case_operational_readiness_confirmed ?reallocation_case)
        )
        (case_assigned_aux_or ?reallocation_case ?auxiliary_operating_room)
        (case_department_approval_obtained ?reallocation_case)
        (facilities_coordinator_available ?facilities_coordinator)
        (case_final_clinical_signoff ?reallocation_case)
      )
    :effect
      (and
        (case_operational_readiness_confirmed ?reallocation_case)
      )
  )
  (:action apply_scheduled_case_document_to_ad_hoc_case
    :parameters (?ad_hoc_block_case - ad_hoc_block_case ?scheduled_block_case - scheduled_block_case ?approval_document - approval_document)
    :precondition
      (and
        (case_registered ?ad_hoc_block_case)
        (case_document_registered ?scheduled_block_case ?approval_document)
        (is_ad_hoc_case ?ad_hoc_block_case)
        (not
          (case_document_applied ?ad_hoc_block_case ?approval_document)
        )
        (case_linked_document ?ad_hoc_block_case ?approval_document)
      )
    :effect
      (and
        (case_document_applied ?ad_hoc_block_case ?approval_document)
      )
  )
)

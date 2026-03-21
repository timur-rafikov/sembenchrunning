(define (domain chronic_followup_recall_orchestration_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types recall_case - object time_slot_candidate - object appointment_type - object clinical_location - object clinician_resource - object diagnostic_service - object provisional_time_block - object communication_channel - object booking_pattern - object scheduling_administrator - object equipment_resource - object ancillary_provider - object care_team_role - object clinician_shift - care_team_role coordinator_shift - care_team_role holding_case - recall_case finalizing_case - recall_case)
  (:predicates
    (comm_channel_available ?communication_channel - communication_channel)
    (case_assigned_location ?recall_case - recall_case ?clinical_location - clinical_location)
    (readiness_certified ?recall_case - recall_case)
    (case_allocated_slot ?recall_case - recall_case ?time_slot_candidate - time_slot_candidate)
    (case_care_team_role_association ?recall_case - recall_case ?care_team_role - care_team_role)
    (diagnostic_service_available ?diagnostic_service - diagnostic_service)
    (location_available ?clinical_location - clinical_location)
    (case_ancillary_compatible ?recall_case - recall_case ?ancillary_provider - ancillary_provider)
    (case_finalized ?recall_case - recall_case)
    (holding_case_flag ?holding_case - recall_case)
    (case_slot_compatible ?recall_case - recall_case ?time_slot_candidate - time_slot_candidate)
    (appointment_type_available ?appointment_type - appointment_type)
    (equipment_available ?equipment_resource - equipment_resource)
    (provisional_block_available ?provisional_time_block - provisional_time_block)
    (appointment_confirmed_flag ?recall_case - recall_case)
    (case_location_compatible ?recall_case - recall_case ?clinical_location - clinical_location)
    (case_assigned_ancillary_provider ?recall_case - recall_case ?ancillary_provider - ancillary_provider)
    (case_has_appointment_type ?recall_case - recall_case ?appointment_type - appointment_type)
    (eligibility_verified ?recall_case - recall_case)
    (case_diagnostic_compatible ?recall_case - recall_case ?diagnostic_service - diagnostic_service)
    (ancillary_available ?ancillary_provider - ancillary_provider)
    (finalizing_case_flag ?finalizing_case - recall_case)
    (preappointment_checks_complete ?recall_case - recall_case)
    (case_clinician_compatible ?recall_case - recall_case ?clinician_resource - clinician_resource)
    (case_assigned_clinician ?recall_case - recall_case ?clinician_resource - clinician_resource)
    (resource_conflict_flag ?recall_case - recall_case)
    (case_provisional_block_assignment ?recall_case - recall_case ?provisional_time_block - provisional_time_block)
    (preparatory_notification_sent ?recall_case - recall_case)
    (case_equipment_compatible ?recall_case - recall_case ?equipment_resource - equipment_resource)
    (case_registered ?recall_case - recall_case)
    (time_slot_available ?time_slot_candidate - time_slot_candidate)
    (case_slot_claimed ?recall_case - recall_case)
    (scheduling_admin_available ?scheduling_administrator - scheduling_administrator)
    (booking_pattern_slot_available ?booking_pattern - booking_pattern)
    (case_assigned_diagnostic_service ?recall_case - recall_case ?diagnostic_service - diagnostic_service)
    (holding_case_pattern_association ?recall_case - recall_case ?booking_pattern - booking_pattern)
    (patient_contact_confirmed ?recall_case - recall_case)
    (provisional_block_acknowledged ?recall_case - recall_case)
    (holding_case_booking_pattern_link ?recall_case - recall_case ?booking_pattern - booking_pattern)
    (clinician_available ?clinician_resource - clinician_resource)
    (finalizing_case_pattern_association ?recall_case - recall_case ?booking_pattern - booking_pattern)
    (case_appointment_type_compatible ?recall_case - recall_case ?appointment_type - appointment_type)
    (contact_attempt_recorded ?recall_case - recall_case)
    (finalizing_case_pattern_recorded ?recall_case - recall_case ?booking_pattern - booking_pattern)
  )
  (:action release_ancillary_reservation
    :parameters (?recall_case - recall_case ?ancillary_provider - ancillary_provider)
    :precondition
      (and
        (case_assigned_ancillary_provider ?recall_case ?ancillary_provider)
      )
    :effect
      (and
        (ancillary_available ?ancillary_provider)
        (not
          (case_assigned_ancillary_provider ?recall_case ?ancillary_provider)
        )
      )
  )
  (:action certify_eligibility_with_shifts
    :parameters (?recall_case - recall_case ?diagnostic_service - diagnostic_service ?ancillary_provider - ancillary_provider ?coordinator_shift - coordinator_shift)
    :precondition
      (and
        (not
          (eligibility_verified ?recall_case)
        )
        (appointment_confirmed_flag ?recall_case)
        (preappointment_checks_complete ?recall_case)
        (case_assigned_ancillary_provider ?recall_case ?ancillary_provider)
        (case_care_team_role_association ?recall_case ?coordinator_shift)
        (case_assigned_diagnostic_service ?recall_case ?diagnostic_service)
      )
    :effect
      (and
        (contact_attempt_recorded ?recall_case)
        (eligibility_verified ?recall_case)
      )
  )
  (:action finalize_case
    :parameters (?recall_case - recall_case)
    :precondition
      (and
        (preappointment_checks_complete ?recall_case)
        (case_slot_claimed ?recall_case)
        (appointment_confirmed_flag ?recall_case)
        (case_registered ?recall_case)
        (provisional_block_acknowledged ?recall_case)
        (not
          (case_finalized ?recall_case)
        )
        (holding_case_flag ?recall_case)
        (eligibility_verified ?recall_case)
      )
    :effect
      (and
        (case_finalized ?recall_case)
      )
  )
  (:action clear_conflicts_after_validation
    :parameters (?recall_case - recall_case ?clinician_resource - clinician_resource ?clinical_location - clinical_location)
    :precondition
      (and
        (appointment_confirmed_flag ?recall_case)
        (resource_conflict_flag ?recall_case)
        (case_assigned_clinician ?recall_case ?clinician_resource)
        (case_assigned_location ?recall_case ?clinical_location)
      )
    :effect
      (and
        (not
          (resource_conflict_flag ?recall_case)
        )
        (not
          (contact_attempt_recorded ?recall_case)
        )
      )
  )
  (:action assign_provisional_time_block
    :parameters (?recall_case - recall_case ?provisional_time_block - provisional_time_block)
    :precondition
      (and
        (provisional_block_available ?provisional_time_block)
        (case_registered ?recall_case)
      )
    :effect
      (and
        (not
          (provisional_block_available ?provisional_time_block)
        )
        (case_provisional_block_assignment ?recall_case ?provisional_time_block)
      )
  )
  (:action certify_eligibility
    :parameters (?recall_case - recall_case ?clinician_resource - clinician_resource ?clinical_location - clinical_location ?clinician_shift - clinician_shift)
    :precondition
      (and
        (case_care_team_role_association ?recall_case ?clinician_shift)
        (preappointment_checks_complete ?recall_case)
        (not
          (contact_attempt_recorded ?recall_case)
        )
        (case_assigned_clinician ?recall_case ?clinician_resource)
        (appointment_confirmed_flag ?recall_case)
        (case_assigned_location ?recall_case ?clinical_location)
        (not
          (eligibility_verified ?recall_case)
        )
      )
    :effect
      (and
        (eligibility_verified ?recall_case)
      )
  )
  (:action complete_preparation_using_booking_pattern
    :parameters (?recall_case - recall_case ?booking_pattern - booking_pattern)
    :precondition
      (and
        (case_slot_claimed ?recall_case)
        (finalizing_case_pattern_recorded ?recall_case ?booking_pattern)
        (not
          (preappointment_checks_complete ?recall_case)
        )
      )
    :effect
      (and
        (preappointment_checks_complete ?recall_case)
        (not
          (contact_attempt_recorded ?recall_case)
        )
      )
  )
  (:action reserve_diagnostic_service_for_case
    :parameters (?recall_case - recall_case ?diagnostic_service - diagnostic_service)
    :precondition
      (and
        (case_diagnostic_compatible ?recall_case ?diagnostic_service)
        (case_registered ?recall_case)
        (diagnostic_service_available ?diagnostic_service)
      )
    :effect
      (and
        (case_assigned_diagnostic_service ?recall_case ?diagnostic_service)
        (not
          (diagnostic_service_available ?diagnostic_service)
        )
      )
  )
  (:action reserve_clinician_for_case
    :parameters (?recall_case - recall_case ?clinician_resource - clinician_resource)
    :precondition
      (and
        (case_registered ?recall_case)
        (clinician_available ?clinician_resource)
        (case_clinician_compatible ?recall_case ?clinician_resource)
      )
    :effect
      (and
        (not
          (clinician_available ?clinician_resource)
        )
        (case_assigned_clinician ?recall_case ?clinician_resource)
      )
  )
  (:action release_diagnostic_service_reservation
    :parameters (?recall_case - recall_case ?diagnostic_service - diagnostic_service)
    :precondition
      (and
        (case_assigned_diagnostic_service ?recall_case ?diagnostic_service)
      )
    :effect
      (and
        (diagnostic_service_available ?diagnostic_service)
        (not
          (case_assigned_diagnostic_service ?recall_case ?diagnostic_service)
        )
      )
  )
  (:action release_location_reservation
    :parameters (?recall_case - recall_case ?clinical_location - clinical_location)
    :precondition
      (and
        (case_assigned_location ?recall_case ?clinical_location)
      )
    :effect
      (and
        (location_available ?clinical_location)
        (not
          (case_assigned_location ?recall_case ?clinical_location)
        )
      )
  )
  (:action allocate_booking_pattern_hold
    :parameters (?recall_case - recall_case ?booking_pattern - booking_pattern)
    :precondition
      (and
        (provisional_block_acknowledged ?recall_case)
        (booking_pattern_slot_available ?booking_pattern)
        (holding_case_booking_pattern_link ?recall_case ?booking_pattern)
      )
    :effect
      (and
        (holding_case_pattern_association ?recall_case ?booking_pattern)
        (not
          (booking_pattern_slot_available ?booking_pattern)
        )
      )
  )
  (:action reserve_location_for_case
    :parameters (?recall_case - recall_case ?clinical_location - clinical_location)
    :precondition
      (and
        (case_registered ?recall_case)
        (location_available ?clinical_location)
        (case_location_compatible ?recall_case ?clinical_location)
      )
    :effect
      (and
        (case_assigned_location ?recall_case ?clinical_location)
        (not
          (location_available ?clinical_location)
        )
      )
  )
  (:action construct_multiresource_appointment
    :parameters (?recall_case - recall_case ?appointment_type - appointment_type ?clinician_resource - clinician_resource ?clinical_location - clinical_location)
    :precondition
      (and
        (case_slot_claimed ?recall_case)
        (appointment_type_available ?appointment_type)
        (case_appointment_type_compatible ?recall_case ?appointment_type)
        (not
          (appointment_confirmed_flag ?recall_case)
        )
        (case_assigned_location ?recall_case ?clinical_location)
        (case_assigned_clinician ?recall_case ?clinician_resource)
      )
    :effect
      (and
        (case_has_appointment_type ?recall_case ?appointment_type)
        (not
          (appointment_type_available ?appointment_type)
        )
        (appointment_confirmed_flag ?recall_case)
      )
  )
  (:action confirm_appointment_and_mark_ready
    :parameters (?recall_case - recall_case ?clinician_resource - clinician_resource ?clinical_location - clinical_location)
    :precondition
      (and
        (case_assigned_clinician ?recall_case ?clinician_resource)
        (eligibility_verified ?recall_case)
        (case_assigned_location ?recall_case ?clinical_location)
        (contact_attempt_recorded ?recall_case)
      )
    :effect
      (and
        (not
          (resource_conflict_flag ?recall_case)
        )
        (not
          (contact_attempt_recorded ?recall_case)
        )
        (not
          (preappointment_checks_complete ?recall_case)
        )
        (readiness_certified ?recall_case)
      )
  )
  (:action release_provisional_time_block
    :parameters (?recall_case - recall_case ?provisional_time_block - provisional_time_block)
    :precondition
      (and
        (case_provisional_block_assignment ?recall_case ?provisional_time_block)
      )
    :effect
      (and
        (provisional_block_available ?provisional_time_block)
        (not
          (case_provisional_block_assignment ?recall_case ?provisional_time_block)
        )
      )
  )
  (:action complete_preappointment_checks_with_admin
    :parameters (?recall_case - recall_case ?provisional_time_block - provisional_time_block ?scheduling_administrator - scheduling_administrator)
    :precondition
      (and
        (not
          (preappointment_checks_complete ?recall_case)
        )
        (case_slot_claimed ?recall_case)
        (scheduling_admin_available ?scheduling_administrator)
        (case_provisional_block_assignment ?recall_case ?provisional_time_block)
        (patient_contact_confirmed ?recall_case)
      )
    :effect
      (and
        (not
          (contact_attempt_recorded ?recall_case)
        )
        (preappointment_checks_complete ?recall_case)
      )
  )
  (:action finalize_case_with_notification
    :parameters (?recall_case - recall_case)
    :precondition
      (and
        (case_registered ?recall_case)
        (finalizing_case_flag ?recall_case)
        (preparatory_notification_sent ?recall_case)
        (case_slot_claimed ?recall_case)
        (preappointment_checks_complete ?recall_case)
        (not
          (case_finalized ?recall_case)
        )
        (provisional_block_acknowledged ?recall_case)
        (appointment_confirmed_flag ?recall_case)
        (eligibility_verified ?recall_case)
      )
    :effect
      (and
        (case_finalized ?recall_case)
      )
  )
  (:action mark_preparatory_notification_sent
    :parameters (?recall_case - recall_case ?provisional_time_block - provisional_time_block ?scheduling_administrator - scheduling_administrator)
    :precondition
      (and
        (preappointment_checks_complete ?recall_case)
        (scheduling_admin_available ?scheduling_administrator)
        (not
          (preparatory_notification_sent ?recall_case)
        )
        (provisional_block_acknowledged ?recall_case)
        (case_registered ?recall_case)
        (finalizing_case_flag ?recall_case)
        (case_provisional_block_assignment ?recall_case ?provisional_time_block)
      )
    :effect
      (and
        (preparatory_notification_sent ?recall_case)
      )
  )
  (:action release_clinician_reservation
    :parameters (?recall_case - recall_case ?clinician_resource - clinician_resource)
    :precondition
      (and
        (case_assigned_clinician ?recall_case ?clinician_resource)
      )
    :effect
      (and
        (clinician_available ?clinician_resource)
        (not
          (case_assigned_clinician ?recall_case ?clinician_resource)
        )
      )
  )
  (:action reserve_ancillary_for_case
    :parameters (?recall_case - recall_case ?ancillary_provider - ancillary_provider)
    :precondition
      (and
        (ancillary_available ?ancillary_provider)
        (case_registered ?recall_case)
        (case_ancillary_compatible ?recall_case ?ancillary_provider)
      )
    :effect
      (and
        (case_assigned_ancillary_provider ?recall_case ?ancillary_provider)
        (not
          (ancillary_available ?ancillary_provider)
        )
      )
  )
  (:action create_recall_case
    :parameters (?recall_case - recall_case)
    :precondition
      (and
        (not
          (case_registered ?recall_case)
        )
        (not
          (case_finalized ?recall_case)
        )
      )
    :effect
      (and
        (case_registered ?recall_case)
      )
  )
  (:action confirm_contact_via_channel
    :parameters (?recall_case - recall_case ?communication_channel - communication_channel)
    :precondition
      (and
        (not
          (patient_contact_confirmed ?recall_case)
        )
        (case_registered ?recall_case)
        (comm_channel_available ?communication_channel)
        (case_slot_claimed ?recall_case)
      )
    :effect
      (and
        (contact_attempt_recorded ?recall_case)
        (not
          (comm_channel_available ?communication_channel)
        )
        (patient_contact_confirmed ?recall_case)
      )
  )
  (:action construct_multiresource_appointment_with_equipment
    :parameters (?recall_case - recall_case ?appointment_type - appointment_type ?diagnostic_service - diagnostic_service ?equipment_resource - equipment_resource)
    :precondition
      (and
        (equipment_available ?equipment_resource)
        (case_equipment_compatible ?recall_case ?equipment_resource)
        (not
          (appointment_confirmed_flag ?recall_case)
        )
        (case_slot_claimed ?recall_case)
        (appointment_type_available ?appointment_type)
        (case_appointment_type_compatible ?recall_case ?appointment_type)
        (case_assigned_diagnostic_service ?recall_case ?diagnostic_service)
      )
    :effect
      (and
        (case_has_appointment_type ?recall_case ?appointment_type)
        (not
          (equipment_available ?equipment_resource)
        )
        (resource_conflict_flag ?recall_case)
        (not
          (appointment_type_available ?appointment_type)
        )
        (contact_attempt_recorded ?recall_case)
        (appointment_confirmed_flag ?recall_case)
      )
  )
  (:action acknowledge_communication_channel
    :parameters (?recall_case - recall_case ?communication_channel - communication_channel)
    :precondition
      (and
        (comm_channel_available ?communication_channel)
        (not
          (contact_attempt_recorded ?recall_case)
        )
        (preappointment_checks_complete ?recall_case)
        (eligibility_verified ?recall_case)
        (not
          (provisional_block_acknowledged ?recall_case)
        )
      )
    :effect
      (and
        (provisional_block_acknowledged ?recall_case)
        (not
          (comm_channel_available ?communication_channel)
        )
      )
  )
  (:action release_claimed_time_slot
    :parameters (?recall_case - recall_case ?time_slot_candidate - time_slot_candidate)
    :precondition
      (and
        (case_allocated_slot ?recall_case ?time_slot_candidate)
        (not
          (eligibility_verified ?recall_case)
        )
        (not
          (appointment_confirmed_flag ?recall_case)
        )
      )
    :effect
      (and
        (not
          (case_allocated_slot ?recall_case ?time_slot_candidate)
        )
        (time_slot_available ?time_slot_candidate)
        (not
          (case_slot_claimed ?recall_case)
        )
        (not
          (patient_contact_confirmed ?recall_case)
        )
        (not
          (readiness_certified ?recall_case)
        )
        (not
          (preappointment_checks_complete ?recall_case)
        )
        (not
          (resource_conflict_flag ?recall_case)
        )
        (not
          (contact_attempt_recorded ?recall_case)
        )
      )
  )
  (:action acknowledge_provisional_block_for_case
    :parameters (?recall_case - recall_case ?provisional_time_block - provisional_time_block)
    :precondition
      (and
        (not
          (provisional_block_acknowledged ?recall_case)
        )
        (case_provisional_block_assignment ?recall_case ?provisional_time_block)
        (preappointment_checks_complete ?recall_case)
        (eligibility_verified ?recall_case)
        (not
          (contact_attempt_recorded ?recall_case)
        )
      )
    :effect
      (and
        (provisional_block_acknowledged ?recall_case)
      )
  )
  (:action finalize_case_with_pattern
    :parameters (?recall_case - recall_case ?booking_pattern - booking_pattern)
    :precondition
      (and
        (provisional_block_acknowledged ?recall_case)
        (eligibility_verified ?recall_case)
        (appointment_confirmed_flag ?recall_case)
        (finalizing_case_pattern_recorded ?recall_case ?booking_pattern)
        (preappointment_checks_complete ?recall_case)
        (case_slot_claimed ?recall_case)
        (case_registered ?recall_case)
        (not
          (case_finalized ?recall_case)
        )
        (finalizing_case_flag ?recall_case)
      )
    :effect
      (and
        (case_finalized ?recall_case)
      )
  )
  (:action confirm_contact_for_provisional_block
    :parameters (?recall_case - recall_case ?provisional_time_block - provisional_time_block)
    :precondition
      (and
        (case_registered ?recall_case)
        (case_slot_claimed ?recall_case)
        (not
          (patient_contact_confirmed ?recall_case)
        )
        (case_provisional_block_assignment ?recall_case ?provisional_time_block)
      )
    :effect
      (and
        (patient_contact_confirmed ?recall_case)
      )
  )
  (:action claim_time_slot_candidate
    :parameters (?recall_case - recall_case ?time_slot_candidate - time_slot_candidate)
    :precondition
      (and
        (not
          (case_slot_claimed ?recall_case)
        )
        (case_registered ?recall_case)
        (time_slot_available ?time_slot_candidate)
        (case_slot_compatible ?recall_case ?time_slot_candidate)
      )
    :effect
      (and
        (case_slot_claimed ?recall_case)
        (not
          (time_slot_available ?time_slot_candidate)
        )
        (case_allocated_slot ?recall_case ?time_slot_candidate)
      )
  )
  (:action reapply_preappointment_checks_with_block
    :parameters (?recall_case - recall_case ?provisional_time_block - provisional_time_block ?scheduling_administrator - scheduling_administrator)
    :precondition
      (and
        (case_slot_claimed ?recall_case)
        (not
          (preappointment_checks_complete ?recall_case)
        )
        (case_provisional_block_assignment ?recall_case ?provisional_time_block)
        (eligibility_verified ?recall_case)
        (scheduling_admin_available ?scheduling_administrator)
        (readiness_certified ?recall_case)
      )
    :effect
      (and
        (preappointment_checks_complete ?recall_case)
      )
  )
  (:action transfer_booking_pattern_from_holder
    :parameters (?finalizing_case - finalizing_case ?holding_case - holding_case ?booking_pattern - booking_pattern)
    :precondition
      (and
        (case_registered ?finalizing_case)
        (holding_case_pattern_association ?holding_case ?booking_pattern)
        (finalizing_case_flag ?finalizing_case)
        (not
          (finalizing_case_pattern_recorded ?finalizing_case ?booking_pattern)
        )
        (finalizing_case_pattern_association ?finalizing_case ?booking_pattern)
      )
    :effect
      (and
        (finalizing_case_pattern_recorded ?finalizing_case ?booking_pattern)
      )
  )
)

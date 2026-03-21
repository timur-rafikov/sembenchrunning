(define (domain oncology_cycle_visit_alignment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types oncology_cycle_visit - object appointment_slot - object session_type - object clinician - object infusion_pump - object ancillary_device - object treatment_room - object logistics_service - object time_block - object registered_nurse - object laboratory_slot - object medication_batch - object care_unit - object infusion_nurse_team - care_unit pharmacy_team - care_unit initial_cycle_visit - oncology_cycle_visit followup_cycle_visit - oncology_cycle_visit)
  (:predicates
    (visit_initialized ?oncology_cycle_visit - oncology_cycle_visit)
    (visit_slot_reservation ?oncology_cycle_visit - oncology_cycle_visit ?appointment_slot - appointment_slot)
    (visit_slot_allocated ?oncology_cycle_visit - oncology_cycle_visit)
    (visit_room_confirmed ?oncology_cycle_visit - oncology_cycle_visit)
    (visit_resources_ready ?oncology_cycle_visit - oncology_cycle_visit)
    (visit_infusion_pump_reserved ?oncology_cycle_visit - oncology_cycle_visit ?infusion_pump - infusion_pump)
    (visit_clinician_assigned ?oncology_cycle_visit - oncology_cycle_visit ?clinician - clinician)
    (visit_ancillary_device_reserved ?oncology_cycle_visit - oncology_cycle_visit ?ancillary_device - ancillary_device)
    (visit_medication_assigned ?oncology_cycle_visit - oncology_cycle_visit ?medication_batch - medication_batch)
    (visit_session_scheduled ?oncology_cycle_visit - oncology_cycle_visit ?treatment_session_type - session_type)
    (visit_treatment_performed ?oncology_cycle_visit - oncology_cycle_visit)
    (visit_staff_confirmed ?oncology_cycle_visit - oncology_cycle_visit)
    (visit_room_checklist_completed ?oncology_cycle_visit - oncology_cycle_visit)
    (visit_finalized ?oncology_cycle_visit - oncology_cycle_visit)
    (logistics_service_in_use ?oncology_cycle_visit - oncology_cycle_visit)
    (visit_post_treatment_processing ?oncology_cycle_visit - oncology_cycle_visit)
    (visit_time_block_proposed ?oncology_cycle_visit - oncology_cycle_visit ?time_block - time_block)
    (visit_time_block_confirmed ?oncology_cycle_visit - oncology_cycle_visit ?time_block - time_block)
    (visit_previsit_confirmed ?oncology_cycle_visit - oncology_cycle_visit)
    (slot_available ?appointment_slot - appointment_slot)
    (session_type_available ?treatment_session_type - session_type)
    (infusion_pump_available ?infusion_pump - infusion_pump)
    (clinician_available ?clinician - clinician)
    (ancillary_device_available ?ancillary_device - ancillary_device)
    (room_available ?treatment_room - treatment_room)
    (logistics_service_available ?logistics_service - logistics_service)
    (time_block_available ?time_block - time_block)
    (registered_nurse_available ?registered_nurse - registered_nurse)
    (lab_slot_available ?laboratory_slot - laboratory_slot)
    (medication_batch_available ?medication_batch - medication_batch)
    (visit_slot_compatible ?oncology_cycle_visit - oncology_cycle_visit ?appointment_slot - appointment_slot)
    (visit_session_type_compatible ?oncology_cycle_visit - oncology_cycle_visit ?treatment_session_type - session_type)
    (visit_pump_compatible ?oncology_cycle_visit - oncology_cycle_visit ?infusion_pump - infusion_pump)
    (visit_clinician_compatible ?oncology_cycle_visit - oncology_cycle_visit ?clinician - clinician)
    (visit_ancillary_device_compatible ?oncology_cycle_visit - oncology_cycle_visit ?ancillary_device - ancillary_device)
    (visit_lab_slot_compatible ?oncology_cycle_visit - oncology_cycle_visit ?laboratory_slot - laboratory_slot)
    (visit_medication_batch_compatible ?oncology_cycle_visit - oncology_cycle_visit ?medication_batch - medication_batch)
    (visit_care_unit_assigned ?oncology_cycle_visit - oncology_cycle_visit ?care_unit - care_unit)
    (visit_time_block_linked ?oncology_cycle_visit - oncology_cycle_visit ?time_block - time_block)
    (initial_visit_flag ?initial_cycle_visit - oncology_cycle_visit)
    (followup_visit_flag ?followup_cycle_visit - oncology_cycle_visit)
    (visit_room_allocated ?oncology_cycle_visit - oncology_cycle_visit ?treatment_room - treatment_room)
    (visit_requires_postproc ?oncology_cycle_visit - oncology_cycle_visit)
    (visit_time_block_compatible ?oncology_cycle_visit - oncology_cycle_visit ?time_block - time_block)
  )
  (:action initiate_cycle_visit
    :parameters (?oncology_cycle_visit - oncology_cycle_visit)
    :precondition
      (and
        (not
          (visit_initialized ?oncology_cycle_visit)
        )
        (not
          (visit_finalized ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_initialized ?oncology_cycle_visit)
      )
  )
  (:action reserve_appointment_slot
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?appointment_slot - appointment_slot)
    :precondition
      (and
        (visit_initialized ?oncology_cycle_visit)
        (slot_available ?appointment_slot)
        (visit_slot_compatible ?oncology_cycle_visit ?appointment_slot)
        (not
          (visit_slot_allocated ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_slot_reservation ?oncology_cycle_visit ?appointment_slot)
        (visit_slot_allocated ?oncology_cycle_visit)
        (not
          (slot_available ?appointment_slot)
        )
      )
  )
  (:action release_appointment_slot
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?appointment_slot - appointment_slot)
    :precondition
      (and
        (visit_slot_reservation ?oncology_cycle_visit ?appointment_slot)
        (not
          (visit_treatment_performed ?oncology_cycle_visit)
        )
        (not
          (visit_staff_confirmed ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (not
          (visit_slot_reservation ?oncology_cycle_visit ?appointment_slot)
        )
        (not
          (visit_slot_allocated ?oncology_cycle_visit)
        )
        (not
          (visit_room_confirmed ?oncology_cycle_visit)
        )
        (not
          (visit_resources_ready ?oncology_cycle_visit)
        )
        (not
          (logistics_service_in_use ?oncology_cycle_visit)
        )
        (not
          (visit_post_treatment_processing ?oncology_cycle_visit)
        )
        (not
          (visit_requires_postproc ?oncology_cycle_visit)
        )
        (slot_available ?appointment_slot)
      )
  )
  (:action allocate_treatment_room
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?treatment_room - treatment_room)
    :precondition
      (and
        (visit_initialized ?oncology_cycle_visit)
        (room_available ?treatment_room)
      )
    :effect
      (and
        (visit_room_allocated ?oncology_cycle_visit ?treatment_room)
        (not
          (room_available ?treatment_room)
        )
      )
  )
  (:action release_treatment_room
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?treatment_room - treatment_room)
    :precondition
      (and
        (visit_room_allocated ?oncology_cycle_visit ?treatment_room)
      )
    :effect
      (and
        (room_available ?treatment_room)
        (not
          (visit_room_allocated ?oncology_cycle_visit ?treatment_room)
        )
      )
  )
  (:action confirm_room_allocation
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?treatment_room - treatment_room)
    :precondition
      (and
        (visit_initialized ?oncology_cycle_visit)
        (visit_slot_allocated ?oncology_cycle_visit)
        (visit_room_allocated ?oncology_cycle_visit ?treatment_room)
        (not
          (visit_room_confirmed ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_room_confirmed ?oncology_cycle_visit)
      )
  )
  (:action assign_logistics_and_confirm_room
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?logistics_service - logistics_service)
    :precondition
      (and
        (visit_initialized ?oncology_cycle_visit)
        (visit_slot_allocated ?oncology_cycle_visit)
        (logistics_service_available ?logistics_service)
        (not
          (visit_room_confirmed ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_room_confirmed ?oncology_cycle_visit)
        (logistics_service_in_use ?oncology_cycle_visit)
        (not
          (logistics_service_available ?logistics_service)
        )
      )
  )
  (:action assign_nurse_to_room
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?treatment_room - treatment_room ?registered_nurse - registered_nurse)
    :precondition
      (and
        (visit_room_confirmed ?oncology_cycle_visit)
        (visit_slot_allocated ?oncology_cycle_visit)
        (visit_room_allocated ?oncology_cycle_visit ?treatment_room)
        (registered_nurse_available ?registered_nurse)
        (not
          (visit_resources_ready ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_resources_ready ?oncology_cycle_visit)
        (not
          (logistics_service_in_use ?oncology_cycle_visit)
        )
      )
  )
  (:action confirm_time_block_for_visit
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?time_block - time_block)
    :precondition
      (and
        (visit_slot_allocated ?oncology_cycle_visit)
        (visit_time_block_confirmed ?oncology_cycle_visit ?time_block)
        (not
          (visit_resources_ready ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_resources_ready ?oncology_cycle_visit)
        (not
          (logistics_service_in_use ?oncology_cycle_visit)
        )
      )
  )
  (:action allocate_infusion_pump
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?infusion_pump - infusion_pump)
    :precondition
      (and
        (visit_initialized ?oncology_cycle_visit)
        (infusion_pump_available ?infusion_pump)
        (visit_pump_compatible ?oncology_cycle_visit ?infusion_pump)
      )
    :effect
      (and
        (visit_infusion_pump_reserved ?oncology_cycle_visit ?infusion_pump)
        (not
          (infusion_pump_available ?infusion_pump)
        )
      )
  )
  (:action release_infusion_pump
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?infusion_pump - infusion_pump)
    :precondition
      (and
        (visit_infusion_pump_reserved ?oncology_cycle_visit ?infusion_pump)
      )
    :effect
      (and
        (infusion_pump_available ?infusion_pump)
        (not
          (visit_infusion_pump_reserved ?oncology_cycle_visit ?infusion_pump)
        )
      )
  )
  (:action allocate_clinician
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?clinician - clinician)
    :precondition
      (and
        (visit_initialized ?oncology_cycle_visit)
        (clinician_available ?clinician)
        (visit_clinician_compatible ?oncology_cycle_visit ?clinician)
      )
    :effect
      (and
        (visit_clinician_assigned ?oncology_cycle_visit ?clinician)
        (not
          (clinician_available ?clinician)
        )
      )
  )
  (:action release_clinician
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?clinician - clinician)
    :precondition
      (and
        (visit_clinician_assigned ?oncology_cycle_visit ?clinician)
      )
    :effect
      (and
        (clinician_available ?clinician)
        (not
          (visit_clinician_assigned ?oncology_cycle_visit ?clinician)
        )
      )
  )
  (:action allocate_ancillary_device
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?ancillary_device - ancillary_device)
    :precondition
      (and
        (visit_initialized ?oncology_cycle_visit)
        (ancillary_device_available ?ancillary_device)
        (visit_ancillary_device_compatible ?oncology_cycle_visit ?ancillary_device)
      )
    :effect
      (and
        (visit_ancillary_device_reserved ?oncology_cycle_visit ?ancillary_device)
        (not
          (ancillary_device_available ?ancillary_device)
        )
      )
  )
  (:action release_ancillary_device
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?ancillary_device - ancillary_device)
    :precondition
      (and
        (visit_ancillary_device_reserved ?oncology_cycle_visit ?ancillary_device)
      )
    :effect
      (and
        (ancillary_device_available ?ancillary_device)
        (not
          (visit_ancillary_device_reserved ?oncology_cycle_visit ?ancillary_device)
        )
      )
  )
  (:action allocate_medication_batch
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?medication_batch - medication_batch)
    :precondition
      (and
        (visit_initialized ?oncology_cycle_visit)
        (medication_batch_available ?medication_batch)
        (visit_medication_batch_compatible ?oncology_cycle_visit ?medication_batch)
      )
    :effect
      (and
        (visit_medication_assigned ?oncology_cycle_visit ?medication_batch)
        (not
          (medication_batch_available ?medication_batch)
        )
      )
  )
  (:action release_medication_batch
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?medication_batch - medication_batch)
    :precondition
      (and
        (visit_medication_assigned ?oncology_cycle_visit ?medication_batch)
      )
    :effect
      (and
        (medication_batch_available ?medication_batch)
        (not
          (visit_medication_assigned ?oncology_cycle_visit ?medication_batch)
        )
      )
  )
  (:action schedule_and_confirm_treatment_session
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?treatment_session_type - session_type ?infusion_pump - infusion_pump ?clinician - clinician)
    :precondition
      (and
        (visit_slot_allocated ?oncology_cycle_visit)
        (visit_infusion_pump_reserved ?oncology_cycle_visit ?infusion_pump)
        (visit_clinician_assigned ?oncology_cycle_visit ?clinician)
        (session_type_available ?treatment_session_type)
        (visit_session_type_compatible ?oncology_cycle_visit ?treatment_session_type)
        (not
          (visit_treatment_performed ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_session_scheduled ?oncology_cycle_visit ?treatment_session_type)
        (visit_treatment_performed ?oncology_cycle_visit)
        (not
          (session_type_available ?treatment_session_type)
        )
      )
  )
  (:action schedule_treatment_with_ancillary_and_lab
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?treatment_session_type - session_type ?ancillary_device - ancillary_device ?laboratory_slot - laboratory_slot)
    :precondition
      (and
        (visit_slot_allocated ?oncology_cycle_visit)
        (visit_ancillary_device_reserved ?oncology_cycle_visit ?ancillary_device)
        (lab_slot_available ?laboratory_slot)
        (session_type_available ?treatment_session_type)
        (visit_session_type_compatible ?oncology_cycle_visit ?treatment_session_type)
        (visit_lab_slot_compatible ?oncology_cycle_visit ?laboratory_slot)
        (not
          (visit_treatment_performed ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_session_scheduled ?oncology_cycle_visit ?treatment_session_type)
        (visit_treatment_performed ?oncology_cycle_visit)
        (visit_requires_postproc ?oncology_cycle_visit)
        (logistics_service_in_use ?oncology_cycle_visit)
        (not
          (session_type_available ?treatment_session_type)
        )
        (not
          (lab_slot_available ?laboratory_slot)
        )
      )
  )
  (:action complete_pre_treatment_checks
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?infusion_pump - infusion_pump ?clinician - clinician)
    :precondition
      (and
        (visit_treatment_performed ?oncology_cycle_visit)
        (visit_requires_postproc ?oncology_cycle_visit)
        (visit_infusion_pump_reserved ?oncology_cycle_visit ?infusion_pump)
        (visit_clinician_assigned ?oncology_cycle_visit ?clinician)
      )
    :effect
      (and
        (not
          (visit_requires_postproc ?oncology_cycle_visit)
        )
        (not
          (logistics_service_in_use ?oncology_cycle_visit)
        )
      )
  )
  (:action assign_infusion_nurse_team
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?infusion_pump - infusion_pump ?clinician - clinician ?infusion_nurse_team - infusion_nurse_team)
    :precondition
      (and
        (visit_resources_ready ?oncology_cycle_visit)
        (visit_treatment_performed ?oncology_cycle_visit)
        (visit_infusion_pump_reserved ?oncology_cycle_visit ?infusion_pump)
        (visit_clinician_assigned ?oncology_cycle_visit ?clinician)
        (visit_care_unit_assigned ?oncology_cycle_visit ?infusion_nurse_team)
        (not
          (logistics_service_in_use ?oncology_cycle_visit)
        )
        (not
          (visit_staff_confirmed ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_staff_confirmed ?oncology_cycle_visit)
      )
  )
  (:action assign_pharmacy_team
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?ancillary_device - ancillary_device ?medication_batch - medication_batch ?pharmacy_team - pharmacy_team)
    :precondition
      (and
        (visit_resources_ready ?oncology_cycle_visit)
        (visit_treatment_performed ?oncology_cycle_visit)
        (visit_ancillary_device_reserved ?oncology_cycle_visit ?ancillary_device)
        (visit_medication_assigned ?oncology_cycle_visit ?medication_batch)
        (visit_care_unit_assigned ?oncology_cycle_visit ?pharmacy_team)
        (not
          (visit_staff_confirmed ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_staff_confirmed ?oncology_cycle_visit)
        (logistics_service_in_use ?oncology_cycle_visit)
      )
  )
  (:action finalize_treatment_execution
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?infusion_pump - infusion_pump ?clinician - clinician)
    :precondition
      (and
        (visit_staff_confirmed ?oncology_cycle_visit)
        (logistics_service_in_use ?oncology_cycle_visit)
        (visit_infusion_pump_reserved ?oncology_cycle_visit ?infusion_pump)
        (visit_clinician_assigned ?oncology_cycle_visit ?clinician)
      )
    :effect
      (and
        (visit_post_treatment_processing ?oncology_cycle_visit)
        (not
          (logistics_service_in_use ?oncology_cycle_visit)
        )
        (not
          (visit_resources_ready ?oncology_cycle_visit)
        )
        (not
          (visit_requires_postproc ?oncology_cycle_visit)
        )
      )
  )
  (:action reconfirm_room_resources
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?treatment_room - treatment_room ?registered_nurse - registered_nurse)
    :precondition
      (and
        (visit_post_treatment_processing ?oncology_cycle_visit)
        (visit_staff_confirmed ?oncology_cycle_visit)
        (visit_slot_allocated ?oncology_cycle_visit)
        (visit_room_allocated ?oncology_cycle_visit ?treatment_room)
        (registered_nurse_available ?registered_nurse)
        (not
          (visit_resources_ready ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_resources_ready ?oncology_cycle_visit)
      )
  )
  (:action complete_room_checklist
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?treatment_room - treatment_room)
    :precondition
      (and
        (visit_staff_confirmed ?oncology_cycle_visit)
        (visit_resources_ready ?oncology_cycle_visit)
        (not
          (logistics_service_in_use ?oncology_cycle_visit)
        )
        (visit_room_allocated ?oncology_cycle_visit ?treatment_room)
        (not
          (visit_room_checklist_completed ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_room_checklist_completed ?oncology_cycle_visit)
      )
  )
  (:action request_logistics_service
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?logistics_service - logistics_service)
    :precondition
      (and
        (visit_staff_confirmed ?oncology_cycle_visit)
        (visit_resources_ready ?oncology_cycle_visit)
        (not
          (logistics_service_in_use ?oncology_cycle_visit)
        )
        (logistics_service_available ?logistics_service)
        (not
          (visit_room_checklist_completed ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_room_checklist_completed ?oncology_cycle_visit)
        (not
          (logistics_service_available ?logistics_service)
        )
      )
  )
  (:action link_time_block_for_med_administration
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?time_block - time_block)
    :precondition
      (and
        (visit_room_checklist_completed ?oncology_cycle_visit)
        (time_block_available ?time_block)
        (visit_time_block_compatible ?oncology_cycle_visit ?time_block)
      )
    :effect
      (and
        (visit_time_block_linked ?oncology_cycle_visit ?time_block)
        (not
          (time_block_available ?time_block)
        )
      )
  )
  (:action align_time_blocks_between_visits
    :parameters (?followup_cycle_visit - followup_cycle_visit ?initial_cycle_visit - initial_cycle_visit ?time_block - time_block)
    :precondition
      (and
        (visit_initialized ?followup_cycle_visit)
        (followup_visit_flag ?followup_cycle_visit)
        (visit_time_block_proposed ?followup_cycle_visit ?time_block)
        (visit_time_block_linked ?initial_cycle_visit ?time_block)
        (not
          (visit_time_block_confirmed ?followup_cycle_visit ?time_block)
        )
      )
    :effect
      (and
        (visit_time_block_confirmed ?followup_cycle_visit ?time_block)
      )
  )
  (:action perform_previsit_confirmation
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?treatment_room - treatment_room ?registered_nurse - registered_nurse)
    :precondition
      (and
        (visit_initialized ?oncology_cycle_visit)
        (followup_visit_flag ?oncology_cycle_visit)
        (visit_resources_ready ?oncology_cycle_visit)
        (visit_room_checklist_completed ?oncology_cycle_visit)
        (visit_room_allocated ?oncology_cycle_visit ?treatment_room)
        (registered_nurse_available ?registered_nurse)
        (not
          (visit_previsit_confirmed ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_previsit_confirmed ?oncology_cycle_visit)
      )
  )
  (:action finalize_visit_initial_checks
    :parameters (?oncology_cycle_visit - oncology_cycle_visit)
    :precondition
      (and
        (initial_visit_flag ?oncology_cycle_visit)
        (visit_initialized ?oncology_cycle_visit)
        (visit_slot_allocated ?oncology_cycle_visit)
        (visit_treatment_performed ?oncology_cycle_visit)
        (visit_staff_confirmed ?oncology_cycle_visit)
        (visit_room_checklist_completed ?oncology_cycle_visit)
        (visit_resources_ready ?oncology_cycle_visit)
        (not
          (visit_finalized ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_finalized ?oncology_cycle_visit)
      )
  )
  (:action finalize_visit_with_timeblock
    :parameters (?oncology_cycle_visit - oncology_cycle_visit ?time_block - time_block)
    :precondition
      (and
        (followup_visit_flag ?oncology_cycle_visit)
        (visit_initialized ?oncology_cycle_visit)
        (visit_slot_allocated ?oncology_cycle_visit)
        (visit_treatment_performed ?oncology_cycle_visit)
        (visit_staff_confirmed ?oncology_cycle_visit)
        (visit_room_checklist_completed ?oncology_cycle_visit)
        (visit_resources_ready ?oncology_cycle_visit)
        (visit_time_block_confirmed ?oncology_cycle_visit ?time_block)
        (not
          (visit_finalized ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_finalized ?oncology_cycle_visit)
      )
  )
  (:action finalize_visit_with_previsit_confirmation
    :parameters (?oncology_cycle_visit - oncology_cycle_visit)
    :precondition
      (and
        (followup_visit_flag ?oncology_cycle_visit)
        (visit_initialized ?oncology_cycle_visit)
        (visit_slot_allocated ?oncology_cycle_visit)
        (visit_treatment_performed ?oncology_cycle_visit)
        (visit_staff_confirmed ?oncology_cycle_visit)
        (visit_room_checklist_completed ?oncology_cycle_visit)
        (visit_resources_ready ?oncology_cycle_visit)
        (visit_previsit_confirmed ?oncology_cycle_visit)
        (not
          (visit_finalized ?oncology_cycle_visit)
        )
      )
    :effect
      (and
        (visit_finalized ?oncology_cycle_visit)
      )
  )
)

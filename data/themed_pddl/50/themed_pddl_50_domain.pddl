(define (domain healthcare_preop_clearance_coordination)
  (:requirements :strips :typing :negative-preconditions)
  (:types preop_case - object appointment_slot - object planned_procedure - object physical_location - object device_or_equipment - object support_service - object preop_nurse_slot - object diagnostic_technician - object clinician_slot - object preop_nurse - object laboratory_slot - object modality_reservation - object clinical_team - object operating_team - clinical_team anesthesia_team - clinical_team case_type_elective - preop_case case_type_urgent - preop_case)
  (:predicates
    (diagnostic_technician_available ?diagnostic_technician - diagnostic_technician)
    (case_assigned_physical_location ?preop_case - preop_case ?physical_location - physical_location)
    (case_provisionally_scheduled ?preop_case - preop_case)
    (case_assigned_appointment_slot ?preop_case - preop_case ?appointment_slot - appointment_slot)
    (case_assigned_clinical_team ?preop_case - preop_case ?clinical_team - clinical_team)
    (support_service_available ?support_service - support_service)
    (location_available ?physical_location - physical_location)
    (case_compatible_with_modality_reservation ?preop_case - preop_case ?modality_reservation - modality_reservation)
    (case_ready_for_procedure ?preop_case - preop_case)
    (case_type_elective_flag ?preop_case - preop_case)
    (case_compatible_with_appointment_slot ?preop_case - preop_case ?appointment_slot - appointment_slot)
    (planned_procedure_available ?planned_procedure - planned_procedure)
    (laboratory_slot_available ?laboratory_slot - laboratory_slot)
    (preop_nurse_slot_available ?preop_nurse_slot - preop_nurse_slot)
    (case_procedure_confirmed ?preop_case - preop_case)
    (case_compatible_with_location ?preop_case - preop_case ?physical_location - physical_location)
    (case_assigned_modality_reservation ?preop_case - preop_case ?modality_reservation - modality_reservation)
    (case_scheduled_procedure ?preop_case - preop_case ?planned_procedure - planned_procedure)
    (case_team_assignment_confirmed ?preop_case - preop_case)
    (case_compatible_with_support_service ?preop_case - preop_case ?support_service - support_service)
    (modality_available ?modality_reservation - modality_reservation)
    (case_type_urgent_flag ?preop_case - preop_case)
    (case_nursing_check_complete ?preop_case - preop_case)
    (case_compatible_with_equipment ?preop_case - preop_case ?device_or_equipment - device_or_equipment)
    (case_assigned_device_or_equipment ?preop_case - preop_case ?device_or_equipment - device_or_equipment)
    (case_additional_setup_required ?preop_case - preop_case)
    (case_assigned_preop_nurse_slot ?preop_case - preop_case ?preop_nurse_slot - preop_nurse_slot)
    (case_nurse_clearance_acknowledged ?preop_case - preop_case)
    (case_compatible_with_laboratory_slot ?preop_case - preop_case ?laboratory_slot - laboratory_slot)
    (preop_case_registered ?preop_case - preop_case)
    (appointment_slot_available ?appointment_slot - appointment_slot)
    (case_has_appointment ?preop_case - preop_case)
    (preop_nurse_available ?preop_nurse - preop_nurse)
    (clinician_slot_available ?clinician_slot - clinician_slot)
    (case_assigned_support_service ?preop_case - preop_case ?support_service - support_service)
    (case_assigned_clinician_slot ?preop_case - preop_case ?clinician_slot - clinician_slot)
    (case_checks_initiated ?preop_case - preop_case)
    (case_nurse_checklist_complete ?preop_case - preop_case)
    (clinician_slot_compatible_with_case_type ?preop_case - preop_case ?clinician_slot - clinician_slot)
    (equipment_available ?device_or_equipment - device_or_equipment)
    (case_assigned_clinician_slot_candidate ?preop_case - preop_case ?clinician_slot - clinician_slot)
    (case_compatible_with_planned_procedure ?preop_case - preop_case ?planned_procedure - planned_procedure)
    (case_requires_technician_followup ?preop_case - preop_case)
    (case_assigned_clinician_slot_reserved ?preop_case - preop_case ?clinician_slot - clinician_slot)
  )
  (:action release_modality_from_case
    :parameters (?preop_case - preop_case ?modality_reservation - modality_reservation)
    :precondition
      (and
        (case_assigned_modality_reservation ?preop_case ?modality_reservation)
      )
    :effect
      (and
        (modality_available ?modality_reservation)
        (not
          (case_assigned_modality_reservation ?preop_case ?modality_reservation)
        )
      )
  )
  (:action confirm_team_assignment_with_anesthesia
    :parameters (?preop_case - preop_case ?support_service - support_service ?modality_reservation - modality_reservation ?anesthesia_team - anesthesia_team)
    :precondition
      (and
        (not
          (case_team_assignment_confirmed ?preop_case)
        )
        (case_procedure_confirmed ?preop_case)
        (case_nursing_check_complete ?preop_case)
        (case_assigned_modality_reservation ?preop_case ?modality_reservation)
        (case_assigned_clinical_team ?preop_case ?anesthesia_team)
        (case_assigned_support_service ?preop_case ?support_service)
      )
    :effect
      (and
        (case_requires_technician_followup ?preop_case)
        (case_team_assignment_confirmed ?preop_case)
      )
  )
  (:action finalize_case_clearance
    :parameters (?preop_case - preop_case)
    :precondition
      (and
        (case_nursing_check_complete ?preop_case)
        (case_has_appointment ?preop_case)
        (case_procedure_confirmed ?preop_case)
        (preop_case_registered ?preop_case)
        (case_nurse_checklist_complete ?preop_case)
        (not
          (case_ready_for_procedure ?preop_case)
        )
        (case_type_elective_flag ?preop_case)
        (case_team_assignment_confirmed ?preop_case)
      )
    :effect
      (and
        (case_ready_for_procedure ?preop_case)
      )
  )
  (:action finalize_additional_setup
    :parameters (?preop_case - preop_case ?device_or_equipment - device_or_equipment ?physical_location - physical_location)
    :precondition
      (and
        (case_procedure_confirmed ?preop_case)
        (case_additional_setup_required ?preop_case)
        (case_assigned_device_or_equipment ?preop_case ?device_or_equipment)
        (case_assigned_physical_location ?preop_case ?physical_location)
      )
    :effect
      (and
        (not
          (case_additional_setup_required ?preop_case)
        )
        (not
          (case_requires_technician_followup ?preop_case)
        )
      )
  )
  (:action reserve_preop_nurse_slot_for_case
    :parameters (?preop_case - preop_case ?preop_nurse_slot - preop_nurse_slot)
    :precondition
      (and
        (preop_nurse_slot_available ?preop_nurse_slot)
        (preop_case_registered ?preop_case)
      )
    :effect
      (and
        (not
          (preop_nurse_slot_available ?preop_nurse_slot)
        )
        (case_assigned_preop_nurse_slot ?preop_case ?preop_nurse_slot)
      )
  )
  (:action confirm_operating_team_assignment
    :parameters (?preop_case - preop_case ?device_or_equipment - device_or_equipment ?physical_location - physical_location ?operating_team - operating_team)
    :precondition
      (and
        (case_assigned_clinical_team ?preop_case ?operating_team)
        (case_nursing_check_complete ?preop_case)
        (not
          (case_requires_technician_followup ?preop_case)
        )
        (case_assigned_device_or_equipment ?preop_case ?device_or_equipment)
        (case_procedure_confirmed ?preop_case)
        (case_assigned_physical_location ?preop_case ?physical_location)
        (not
          (case_team_assignment_confirmed ?preop_case)
        )
      )
    :effect
      (and
        (case_team_assignment_confirmed ?preop_case)
      )
  )
  (:action clinician_finalize_nursing_check
    :parameters (?preop_case - preop_case ?clinician_slot - clinician_slot)
    :precondition
      (and
        (case_has_appointment ?preop_case)
        (case_assigned_clinician_slot_reserved ?preop_case ?clinician_slot)
        (not
          (case_nursing_check_complete ?preop_case)
        )
      )
    :effect
      (and
        (case_nursing_check_complete ?preop_case)
        (not
          (case_requires_technician_followup ?preop_case)
        )
      )
  )
  (:action reserve_support_service_for_case
    :parameters (?preop_case - preop_case ?support_service - support_service)
    :precondition
      (and
        (case_compatible_with_support_service ?preop_case ?support_service)
        (preop_case_registered ?preop_case)
        (support_service_available ?support_service)
      )
    :effect
      (and
        (case_assigned_support_service ?preop_case ?support_service)
        (not
          (support_service_available ?support_service)
        )
      )
  )
  (:action reserve_equipment_for_case
    :parameters (?preop_case - preop_case ?device_or_equipment - device_or_equipment)
    :precondition
      (and
        (preop_case_registered ?preop_case)
        (equipment_available ?device_or_equipment)
        (case_compatible_with_equipment ?preop_case ?device_or_equipment)
      )
    :effect
      (and
        (not
          (equipment_available ?device_or_equipment)
        )
        (case_assigned_device_or_equipment ?preop_case ?device_or_equipment)
      )
  )
  (:action release_support_service_for_case
    :parameters (?preop_case - preop_case ?support_service - support_service)
    :precondition
      (and
        (case_assigned_support_service ?preop_case ?support_service)
      )
    :effect
      (and
        (support_service_available ?support_service)
        (not
          (case_assigned_support_service ?preop_case ?support_service)
        )
      )
  )
  (:action release_location_for_case
    :parameters (?preop_case - preop_case ?physical_location - physical_location)
    :precondition
      (and
        (case_assigned_physical_location ?preop_case ?physical_location)
      )
    :effect
      (and
        (location_available ?physical_location)
        (not
          (case_assigned_physical_location ?preop_case ?physical_location)
        )
      )
  )
  (:action assign_clinician_slot_to_case
    :parameters (?preop_case - preop_case ?clinician_slot - clinician_slot)
    :precondition
      (and
        (case_nurse_checklist_complete ?preop_case)
        (clinician_slot_available ?clinician_slot)
        (clinician_slot_compatible_with_case_type ?preop_case ?clinician_slot)
      )
    :effect
      (and
        (case_assigned_clinician_slot ?preop_case ?clinician_slot)
        (not
          (clinician_slot_available ?clinician_slot)
        )
      )
  )
  (:action reserve_location_for_case
    :parameters (?preop_case - preop_case ?physical_location - physical_location)
    :precondition
      (and
        (preop_case_registered ?preop_case)
        (location_available ?physical_location)
        (case_compatible_with_location ?preop_case ?physical_location)
      )
    :effect
      (and
        (case_assigned_physical_location ?preop_case ?physical_location)
        (not
          (location_available ?physical_location)
        )
      )
  )
  (:action schedule_procedure_with_resources
    :parameters (?preop_case - preop_case ?planned_procedure - planned_procedure ?device_or_equipment - device_or_equipment ?physical_location - physical_location)
    :precondition
      (and
        (case_has_appointment ?preop_case)
        (planned_procedure_available ?planned_procedure)
        (case_compatible_with_planned_procedure ?preop_case ?planned_procedure)
        (not
          (case_procedure_confirmed ?preop_case)
        )
        (case_assigned_physical_location ?preop_case ?physical_location)
        (case_assigned_device_or_equipment ?preop_case ?device_or_equipment)
      )
    :effect
      (and
        (case_scheduled_procedure ?preop_case ?planned_procedure)
        (not
          (planned_procedure_available ?planned_procedure)
        )
        (case_procedure_confirmed ?preop_case)
      )
  )
  (:action provisionally_schedule_case
    :parameters (?preop_case - preop_case ?device_or_equipment - device_or_equipment ?physical_location - physical_location)
    :precondition
      (and
        (case_assigned_device_or_equipment ?preop_case ?device_or_equipment)
        (case_team_assignment_confirmed ?preop_case)
        (case_assigned_physical_location ?preop_case ?physical_location)
        (case_requires_technician_followup ?preop_case)
      )
    :effect
      (and
        (not
          (case_additional_setup_required ?preop_case)
        )
        (not
          (case_requires_technician_followup ?preop_case)
        )
        (not
          (case_nursing_check_complete ?preop_case)
        )
        (case_provisionally_scheduled ?preop_case)
      )
  )
  (:action release_preop_nurse_slot_from_case
    :parameters (?preop_case - preop_case ?preop_nurse_slot - preop_nurse_slot)
    :precondition
      (and
        (case_assigned_preop_nurse_slot ?preop_case ?preop_nurse_slot)
      )
    :effect
      (and
        (preop_nurse_slot_available ?preop_nurse_slot)
        (not
          (case_assigned_preop_nurse_slot ?preop_case ?preop_nurse_slot)
        )
      )
  )
  (:action complete_nursing_assessment
    :parameters (?preop_case - preop_case ?preop_nurse_slot - preop_nurse_slot ?preop_nurse - preop_nurse)
    :precondition
      (and
        (not
          (case_nursing_check_complete ?preop_case)
        )
        (case_has_appointment ?preop_case)
        (preop_nurse_available ?preop_nurse)
        (case_assigned_preop_nurse_slot ?preop_case ?preop_nurse_slot)
        (case_checks_initiated ?preop_case)
      )
    :effect
      (and
        (not
          (case_requires_technician_followup ?preop_case)
        )
        (case_nursing_check_complete ?preop_case)
      )
  )
  (:action finalize_case_clearance_with_lab_acknowledgement
    :parameters (?preop_case - preop_case)
    :precondition
      (and
        (preop_case_registered ?preop_case)
        (case_type_urgent_flag ?preop_case)
        (case_nurse_clearance_acknowledged ?preop_case)
        (case_has_appointment ?preop_case)
        (case_nursing_check_complete ?preop_case)
        (not
          (case_ready_for_procedure ?preop_case)
        )
        (case_nurse_checklist_complete ?preop_case)
        (case_procedure_confirmed ?preop_case)
        (case_team_assignment_confirmed ?preop_case)
      )
    :effect
      (and
        (case_ready_for_procedure ?preop_case)
      )
  )
  (:action acknowledge_nursing_clearance
    :parameters (?preop_case - preop_case ?preop_nurse_slot - preop_nurse_slot ?preop_nurse - preop_nurse)
    :precondition
      (and
        (case_nursing_check_complete ?preop_case)
        (preop_nurse_available ?preop_nurse)
        (not
          (case_nurse_clearance_acknowledged ?preop_case)
        )
        (case_nurse_checklist_complete ?preop_case)
        (preop_case_registered ?preop_case)
        (case_type_urgent_flag ?preop_case)
        (case_assigned_preop_nurse_slot ?preop_case ?preop_nurse_slot)
      )
    :effect
      (and
        (case_nurse_clearance_acknowledged ?preop_case)
      )
  )
  (:action release_equipment_for_case
    :parameters (?preop_case - preop_case ?device_or_equipment - device_or_equipment)
    :precondition
      (and
        (case_assigned_device_or_equipment ?preop_case ?device_or_equipment)
      )
    :effect
      (and
        (equipment_available ?device_or_equipment)
        (not
          (case_assigned_device_or_equipment ?preop_case ?device_or_equipment)
        )
      )
  )
  (:action reserve_modality_for_case
    :parameters (?preop_case - preop_case ?modality_reservation - modality_reservation)
    :precondition
      (and
        (modality_available ?modality_reservation)
        (preop_case_registered ?preop_case)
        (case_compatible_with_modality_reservation ?preop_case ?modality_reservation)
      )
    :effect
      (and
        (case_assigned_modality_reservation ?preop_case ?modality_reservation)
        (not
          (modality_available ?modality_reservation)
        )
      )
  )
  (:action register_preop_case
    :parameters (?preop_case - preop_case)
    :precondition
      (and
        (not
          (preop_case_registered ?preop_case)
        )
        (not
          (case_ready_for_procedure ?preop_case)
        )
      )
    :effect
      (and
        (preop_case_registered ?preop_case)
      )
  )
  (:action assign_diagnostic_technician_and_initiate_check
    :parameters (?preop_case - preop_case ?diagnostic_technician - diagnostic_technician)
    :precondition
      (and
        (not
          (case_checks_initiated ?preop_case)
        )
        (preop_case_registered ?preop_case)
        (diagnostic_technician_available ?diagnostic_technician)
        (case_has_appointment ?preop_case)
      )
    :effect
      (and
        (case_requires_technician_followup ?preop_case)
        (not
          (diagnostic_technician_available ?diagnostic_technician)
        )
        (case_checks_initiated ?preop_case)
      )
  )
  (:action schedule_procedure_with_lab_and_resources
    :parameters (?preop_case - preop_case ?planned_procedure - planned_procedure ?support_service - support_service ?laboratory_slot - laboratory_slot)
    :precondition
      (and
        (laboratory_slot_available ?laboratory_slot)
        (case_compatible_with_laboratory_slot ?preop_case ?laboratory_slot)
        (not
          (case_procedure_confirmed ?preop_case)
        )
        (case_has_appointment ?preop_case)
        (planned_procedure_available ?planned_procedure)
        (case_compatible_with_planned_procedure ?preop_case ?planned_procedure)
        (case_assigned_support_service ?preop_case ?support_service)
      )
    :effect
      (and
        (case_scheduled_procedure ?preop_case ?planned_procedure)
        (not
          (laboratory_slot_available ?laboratory_slot)
        )
        (case_additional_setup_required ?preop_case)
        (not
          (planned_procedure_available ?planned_procedure)
        )
        (case_requires_technician_followup ?preop_case)
        (case_procedure_confirmed ?preop_case)
      )
  )
  (:action mark_diagnostic_checklist_complete
    :parameters (?preop_case - preop_case ?diagnostic_technician - diagnostic_technician)
    :precondition
      (and
        (diagnostic_technician_available ?diagnostic_technician)
        (not
          (case_requires_technician_followup ?preop_case)
        )
        (case_nursing_check_complete ?preop_case)
        (case_team_assignment_confirmed ?preop_case)
        (not
          (case_nurse_checklist_complete ?preop_case)
        )
      )
    :effect
      (and
        (case_nurse_checklist_complete ?preop_case)
        (not
          (diagnostic_technician_available ?diagnostic_technician)
        )
      )
  )
  (:action release_appointment_slot_from_case
    :parameters (?preop_case - preop_case ?appointment_slot - appointment_slot)
    :precondition
      (and
        (case_assigned_appointment_slot ?preop_case ?appointment_slot)
        (not
          (case_team_assignment_confirmed ?preop_case)
        )
        (not
          (case_procedure_confirmed ?preop_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned_appointment_slot ?preop_case ?appointment_slot)
        )
        (appointment_slot_available ?appointment_slot)
        (not
          (case_has_appointment ?preop_case)
        )
        (not
          (case_checks_initiated ?preop_case)
        )
        (not
          (case_provisionally_scheduled ?preop_case)
        )
        (not
          (case_nursing_check_complete ?preop_case)
        )
        (not
          (case_additional_setup_required ?preop_case)
        )
        (not
          (case_requires_technician_followup ?preop_case)
        )
      )
  )
  (:action mark_nurse_checklist_complete
    :parameters (?preop_case - preop_case ?preop_nurse_slot - preop_nurse_slot)
    :precondition
      (and
        (not
          (case_nurse_checklist_complete ?preop_case)
        )
        (case_assigned_preop_nurse_slot ?preop_case ?preop_nurse_slot)
        (case_nursing_check_complete ?preop_case)
        (case_team_assignment_confirmed ?preop_case)
        (not
          (case_requires_technician_followup ?preop_case)
        )
      )
    :effect
      (and
        (case_nurse_checklist_complete ?preop_case)
      )
  )
  (:action finalize_case_clearance_with_clinician_slot
    :parameters (?preop_case - preop_case ?clinician_slot - clinician_slot)
    :precondition
      (and
        (case_nurse_checklist_complete ?preop_case)
        (case_team_assignment_confirmed ?preop_case)
        (case_procedure_confirmed ?preop_case)
        (case_assigned_clinician_slot_reserved ?preop_case ?clinician_slot)
        (case_nursing_check_complete ?preop_case)
        (case_has_appointment ?preop_case)
        (preop_case_registered ?preop_case)
        (not
          (case_ready_for_procedure ?preop_case)
        )
        (case_type_urgent_flag ?preop_case)
      )
    :effect
      (and
        (case_ready_for_procedure ?preop_case)
      )
  )
  (:action initiate_preop_checks_via_nurse_slot
    :parameters (?preop_case - preop_case ?preop_nurse_slot - preop_nurse_slot)
    :precondition
      (and
        (preop_case_registered ?preop_case)
        (case_has_appointment ?preop_case)
        (not
          (case_checks_initiated ?preop_case)
        )
        (case_assigned_preop_nurse_slot ?preop_case ?preop_nurse_slot)
      )
    :effect
      (and
        (case_checks_initiated ?preop_case)
      )
  )
  (:action reserve_appointment_slot_for_case
    :parameters (?preop_case - preop_case ?appointment_slot - appointment_slot)
    :precondition
      (and
        (not
          (case_has_appointment ?preop_case)
        )
        (preop_case_registered ?preop_case)
        (appointment_slot_available ?appointment_slot)
        (case_compatible_with_appointment_slot ?preop_case ?appointment_slot)
      )
    :effect
      (and
        (case_has_appointment ?preop_case)
        (not
          (appointment_slot_available ?appointment_slot)
        )
        (case_assigned_appointment_slot ?preop_case ?appointment_slot)
      )
  )
  (:action restore_nursing_check_after_provisional
    :parameters (?preop_case - preop_case ?preop_nurse_slot - preop_nurse_slot ?preop_nurse - preop_nurse)
    :precondition
      (and
        (case_has_appointment ?preop_case)
        (not
          (case_nursing_check_complete ?preop_case)
        )
        (case_assigned_preop_nurse_slot ?preop_case ?preop_nurse_slot)
        (case_team_assignment_confirmed ?preop_case)
        (preop_nurse_available ?preop_nurse)
        (case_provisionally_scheduled ?preop_case)
      )
    :effect
      (and
        (case_nursing_check_complete ?preop_case)
      )
  )
  (:action reserve_clinician_slot_for_urgent_case
    :parameters (?case_type_urgent - case_type_urgent ?case_type_elective - case_type_elective ?clinician_slot - clinician_slot)
    :precondition
      (and
        (preop_case_registered ?case_type_urgent)
        (case_assigned_clinician_slot ?case_type_elective ?clinician_slot)
        (case_type_urgent_flag ?case_type_urgent)
        (not
          (case_assigned_clinician_slot_reserved ?case_type_urgent ?clinician_slot)
        )
        (case_assigned_clinician_slot_candidate ?case_type_urgent ?clinician_slot)
      )
    :effect
      (and
        (case_assigned_clinician_slot_reserved ?case_type_urgent ?clinician_slot)
      )
  )
)

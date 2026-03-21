(define (domain pediatric_emergency_bed_assignment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types patient_encounter - object bed_resource - object treatment_area - object clinical_staff - object medical_device - object procedure_room - object support_equipment - object consultation_slot - object care_protocol - object specialist_staff - object diagnostic_resource - object medication_set - object care_attribute - object nurse_team - care_attribute physician_team - care_attribute patient_group_a - patient_encounter patient_group_b - patient_encounter)
  (:predicates
    (patient_registered ?patient_encounter - patient_encounter)
    (bed_reserved_for ?patient_encounter - patient_encounter ?resource_slot - bed_resource)
    (has_provisional_bed ?patient_encounter - patient_encounter)
    (staff_assigned ?patient_encounter - patient_encounter)
    (treatment_ready ?patient_encounter - patient_encounter)
    (device_reserved_for ?patient_encounter - patient_encounter ?resource_slot - medical_device)
    (staff_assigned_to ?patient_encounter - patient_encounter ?resource_slot - clinical_staff)
    (procedure_room_reserved_for ?patient_encounter - patient_encounter ?resource_slot - procedure_room)
    (medication_reserved_for ?patient_encounter - patient_encounter ?resource_slot - medication_set)
    (treatment_area_assigned_to ?patient_encounter - patient_encounter ?resource_slot - treatment_area)
    (treatment_area_confirmed ?patient_encounter - patient_encounter)
    (care_team_allocated ?patient_encounter - patient_encounter)
    (support_equipment_verified ?patient_encounter - patient_encounter)
    (final_assignment_confirmed ?patient_encounter - patient_encounter)
    (consultation_assigned ?patient_encounter - patient_encounter)
    (ready_for_equipment_allocation ?patient_encounter - patient_encounter)
    (protocol_applicable_to_patient ?patient_encounter - patient_encounter ?resource_slot - care_protocol)
    (patient_protocol_bound ?patient_encounter - patient_encounter ?resource_slot - care_protocol)
    (specialist_consult_confirmed ?patient_encounter - patient_encounter)
    (bed_available ?bed_resource - bed_resource)
    (treatment_area_available ?treatment_area - treatment_area)
    (device_available ?medical_device - medical_device)
    (staff_available ?clinical_staff - clinical_staff)
    (procedure_room_available ?procedure_room - procedure_room)
    (equipment_available ?support_equipment - support_equipment)
    (consult_slot_available ?consultation_slot - consultation_slot)
    (protocol_available ?care_protocol - care_protocol)
    (specialist_available ?specialist_staff - specialist_staff)
    (diagnostic_available ?diagnostic_resource - diagnostic_resource)
    (medication_available ?medication_set - medication_set)
    (bed_compatible_for ?patient_encounter - patient_encounter ?resource_slot - bed_resource)
    (treatment_area_compatible_for ?patient_encounter - patient_encounter ?resource_slot - treatment_area)
    (device_compatible_for ?patient_encounter - patient_encounter ?resource_slot - medical_device)
    (staff_compatible_for ?patient_encounter - patient_encounter ?resource_slot - clinical_staff)
    (procedure_room_compatible_for ?patient_encounter - patient_encounter ?resource_slot - procedure_room)
    (diagnostic_compatible_for ?patient_encounter - patient_encounter ?resource_slot - diagnostic_resource)
    (medication_compatible_for ?patient_encounter - patient_encounter ?resource_slot - medication_set)
    (patient_has_attribute ?patient_encounter - patient_encounter ?resource_slot - care_attribute)
    (protocol_applicable_to_group ?patient_group_a - patient_encounter ?resource_slot - care_protocol)
    (triage_category_a ?patient_encounter - patient_encounter)
    (triage_category_b ?patient_encounter - patient_encounter)
    (equipment_allocated_to ?patient_encounter - patient_encounter ?resource_slot - support_equipment)
    (resource_check_flag ?patient_encounter - patient_encounter)
    (protocol_compatible_with_patient ?patient_encounter - patient_encounter ?resource_slot - care_protocol)
  )
  (:action register_patient_encounter
    :parameters (?patient_encounter - patient_encounter)
    :precondition
      (and
        (not
          (patient_registered ?patient_encounter)
        )
        (not
          (final_assignment_confirmed ?patient_encounter)
        )
      )
    :effect
      (and
        (patient_registered ?patient_encounter)
      )
  )
  (:action reserve_provisional_bed
    :parameters (?patient_encounter - patient_encounter ?resource_slot - bed_resource)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (bed_available ?resource_slot)
        (bed_compatible_for ?patient_encounter ?resource_slot)
        (not
          (has_provisional_bed ?patient_encounter)
        )
      )
    :effect
      (and
        (bed_reserved_for ?patient_encounter ?resource_slot)
        (has_provisional_bed ?patient_encounter)
        (not
          (bed_available ?resource_slot)
        )
      )
  )
  (:action release_provisional_bed
    :parameters (?patient_encounter - patient_encounter ?resource_slot - bed_resource)
    :precondition
      (and
        (bed_reserved_for ?patient_encounter ?resource_slot)
        (not
          (treatment_area_confirmed ?patient_encounter)
        )
        (not
          (care_team_allocated ?patient_encounter)
        )
      )
    :effect
      (and
        (not
          (bed_reserved_for ?patient_encounter ?resource_slot)
        )
        (not
          (has_provisional_bed ?patient_encounter)
        )
        (not
          (staff_assigned ?patient_encounter)
        )
        (not
          (treatment_ready ?patient_encounter)
        )
        (not
          (consultation_assigned ?patient_encounter)
        )
        (not
          (ready_for_equipment_allocation ?patient_encounter)
        )
        (not
          (resource_check_flag ?patient_encounter)
        )
        (bed_available ?resource_slot)
      )
  )
  (:action allocate_support_equipment
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (equipment_available ?resource_slot)
      )
    :effect
      (and
        (equipment_allocated_to ?patient_encounter ?resource_slot)
        (not
          (equipment_available ?resource_slot)
        )
      )
  )
  (:action return_support_equipment
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment)
    :precondition
      (and
        (equipment_allocated_to ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (equipment_available ?resource_slot)
        (not
          (equipment_allocated_to ?patient_encounter ?resource_slot)
        )
      )
  )
  (:action confirm_equipment_assignment
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (equipment_allocated_to ?patient_encounter ?resource_slot)
        (not
          (staff_assigned ?patient_encounter)
        )
      )
    :effect
      (and
        (staff_assigned ?patient_encounter)
      )
  )
  (:action assign_consultation_slot_to_patient
    :parameters (?patient_encounter - patient_encounter ?resource_slot - consultation_slot)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (consult_slot_available ?resource_slot)
        (not
          (staff_assigned ?patient_encounter)
        )
      )
    :effect
      (and
        (staff_assigned ?patient_encounter)
        (consultation_assigned ?patient_encounter)
        (not
          (consult_slot_available ?resource_slot)
        )
      )
  )
  (:action confirm_specialist_and_equipment
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment ?specialist_staff - specialist_staff)
    :precondition
      (and
        (staff_assigned ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (equipment_allocated_to ?patient_encounter ?resource_slot)
        (specialist_available ?specialist_staff)
        (not
          (treatment_ready ?patient_encounter)
        )
      )
    :effect
      (and
        (treatment_ready ?patient_encounter)
        (not
          (consultation_assigned ?patient_encounter)
        )
      )
  )
  (:action bind_protocol_to_patient
    :parameters (?patient_encounter - patient_encounter ?resource_slot - care_protocol)
    :precondition
      (and
        (has_provisional_bed ?patient_encounter)
        (patient_protocol_bound ?patient_encounter ?resource_slot)
        (not
          (treatment_ready ?patient_encounter)
        )
      )
    :effect
      (and
        (treatment_ready ?patient_encounter)
        (not
          (consultation_assigned ?patient_encounter)
        )
      )
  )
  (:action reserve_medical_device
    :parameters (?patient_encounter - patient_encounter ?resource_slot - medical_device)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (device_available ?resource_slot)
        (device_compatible_for ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (device_reserved_for ?patient_encounter ?resource_slot)
        (not
          (device_available ?resource_slot)
        )
      )
  )
  (:action release_medical_device
    :parameters (?patient_encounter - patient_encounter ?resource_slot - medical_device)
    :precondition
      (and
        (device_reserved_for ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (device_available ?resource_slot)
        (not
          (device_reserved_for ?patient_encounter ?resource_slot)
        )
      )
  )
  (:action reserve_clinical_staff_for_patient
    :parameters (?patient_encounter - patient_encounter ?resource_slot - clinical_staff)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (staff_available ?resource_slot)
        (staff_compatible_for ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (staff_assigned_to ?patient_encounter ?resource_slot)
        (not
          (staff_available ?resource_slot)
        )
      )
  )
  (:action release_clinical_staff_for_patient
    :parameters (?patient_encounter - patient_encounter ?resource_slot - clinical_staff)
    :precondition
      (and
        (staff_assigned_to ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (staff_available ?resource_slot)
        (not
          (staff_assigned_to ?patient_encounter ?resource_slot)
        )
      )
  )
  (:action reserve_procedure_room
    :parameters (?patient_encounter - patient_encounter ?resource_slot - procedure_room)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (procedure_room_available ?resource_slot)
        (procedure_room_compatible_for ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (procedure_room_reserved_for ?patient_encounter ?resource_slot)
        (not
          (procedure_room_available ?resource_slot)
        )
      )
  )
  (:action release_procedure_room
    :parameters (?patient_encounter - patient_encounter ?resource_slot - procedure_room)
    :precondition
      (and
        (procedure_room_reserved_for ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (procedure_room_available ?resource_slot)
        (not
          (procedure_room_reserved_for ?patient_encounter ?resource_slot)
        )
      )
  )
  (:action reserve_medication_set
    :parameters (?patient_encounter - patient_encounter ?resource_slot - medication_set)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (medication_available ?resource_slot)
        (medication_compatible_for ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (medication_reserved_for ?patient_encounter ?resource_slot)
        (not
          (medication_available ?resource_slot)
        )
      )
  )
  (:action release_medication_set
    :parameters (?patient_encounter - patient_encounter ?resource_slot - medication_set)
    :precondition
      (and
        (medication_reserved_for ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (medication_available ?resource_slot)
        (not
          (medication_reserved_for ?patient_encounter ?resource_slot)
        )
      )
  )
  (:action assign_treatment_area_and_initialize
    :parameters (?patient_encounter - patient_encounter ?resource_slot - treatment_area ?medical_device - medical_device ?clinical_staff - clinical_staff)
    :precondition
      (and
        (has_provisional_bed ?patient_encounter)
        (device_reserved_for ?patient_encounter ?medical_device)
        (staff_assigned_to ?patient_encounter ?clinical_staff)
        (treatment_area_available ?resource_slot)
        (treatment_area_compatible_for ?patient_encounter ?resource_slot)
        (not
          (treatment_area_confirmed ?patient_encounter)
        )
      )
    :effect
      (and
        (treatment_area_assigned_to ?patient_encounter ?resource_slot)
        (treatment_area_confirmed ?patient_encounter)
        (not
          (treatment_area_available ?resource_slot)
        )
      )
  )
  (:action assign_treatment_area_with_resources
    :parameters (?patient_encounter - patient_encounter ?resource_slot - treatment_area ?procedure_room - procedure_room ?diagnostic_resource - diagnostic_resource)
    :precondition
      (and
        (has_provisional_bed ?patient_encounter)
        (procedure_room_reserved_for ?patient_encounter ?procedure_room)
        (diagnostic_available ?diagnostic_resource)
        (treatment_area_available ?resource_slot)
        (treatment_area_compatible_for ?patient_encounter ?resource_slot)
        (diagnostic_compatible_for ?patient_encounter ?diagnostic_resource)
        (not
          (treatment_area_confirmed ?patient_encounter)
        )
      )
    :effect
      (and
        (treatment_area_assigned_to ?patient_encounter ?resource_slot)
        (treatment_area_confirmed ?patient_encounter)
        (resource_check_flag ?patient_encounter)
        (consultation_assigned ?patient_encounter)
        (not
          (treatment_area_available ?resource_slot)
        )
        (not
          (diagnostic_available ?diagnostic_resource)
        )
      )
  )
  (:action acknowledge_treatment_area_readiness
    :parameters (?patient_encounter - patient_encounter ?resource_slot - medical_device ?clinical_staff - clinical_staff)
    :precondition
      (and
        (treatment_area_confirmed ?patient_encounter)
        (resource_check_flag ?patient_encounter)
        (device_reserved_for ?patient_encounter ?resource_slot)
        (staff_assigned_to ?patient_encounter ?clinical_staff)
      )
    :effect
      (and
        (not
          (resource_check_flag ?patient_encounter)
        )
        (not
          (consultation_assigned ?patient_encounter)
        )
      )
  )
  (:action allocate_care_team
    :parameters (?patient_encounter - patient_encounter ?resource_slot - medical_device ?clinical_staff - clinical_staff ?nurse_team - nurse_team)
    :precondition
      (and
        (treatment_ready ?patient_encounter)
        (treatment_area_confirmed ?patient_encounter)
        (device_reserved_for ?patient_encounter ?resource_slot)
        (staff_assigned_to ?patient_encounter ?clinical_staff)
        (patient_has_attribute ?patient_encounter ?nurse_team)
        (not
          (consultation_assigned ?patient_encounter)
        )
        (not
          (care_team_allocated ?patient_encounter)
        )
      )
    :effect
      (and
        (care_team_allocated ?patient_encounter)
      )
  )
  (:action allocate_physician_team
    :parameters (?patient_encounter - patient_encounter ?resource_slot - procedure_room ?medication_set - medication_set ?physician_team - physician_team)
    :precondition
      (and
        (treatment_ready ?patient_encounter)
        (treatment_area_confirmed ?patient_encounter)
        (procedure_room_reserved_for ?patient_encounter ?resource_slot)
        (medication_reserved_for ?patient_encounter ?medication_set)
        (patient_has_attribute ?patient_encounter ?physician_team)
        (not
          (care_team_allocated ?patient_encounter)
        )
      )
    :effect
      (and
        (care_team_allocated ?patient_encounter)
        (consultation_assigned ?patient_encounter)
      )
  )
  (:action finalize_phase_transition
    :parameters (?patient_encounter - patient_encounter ?resource_slot - medical_device ?clinical_staff - clinical_staff)
    :precondition
      (and
        (care_team_allocated ?patient_encounter)
        (consultation_assigned ?patient_encounter)
        (device_reserved_for ?patient_encounter ?resource_slot)
        (staff_assigned_to ?patient_encounter ?clinical_staff)
      )
    :effect
      (and
        (ready_for_equipment_allocation ?patient_encounter)
        (not
          (consultation_assigned ?patient_encounter)
        )
        (not
          (treatment_ready ?patient_encounter)
        )
        (not
          (resource_check_flag ?patient_encounter)
        )
      )
  )
  (:action confirm_support_equipment_with_specialist
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment ?specialist_staff - specialist_staff)
    :precondition
      (and
        (ready_for_equipment_allocation ?patient_encounter)
        (care_team_allocated ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (equipment_allocated_to ?patient_encounter ?resource_slot)
        (specialist_available ?specialist_staff)
        (not
          (treatment_ready ?patient_encounter)
        )
      )
    :effect
      (and
        (treatment_ready ?patient_encounter)
      )
  )
  (:action verify_support_equipment
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment)
    :precondition
      (and
        (care_team_allocated ?patient_encounter)
        (treatment_ready ?patient_encounter)
        (not
          (consultation_assigned ?patient_encounter)
        )
        (equipment_allocated_to ?patient_encounter ?resource_slot)
        (not
          (support_equipment_verified ?patient_encounter)
        )
      )
    :effect
      (and
        (support_equipment_verified ?patient_encounter)
      )
  )
  (:action reserve_consultation_slot
    :parameters (?patient_encounter - patient_encounter ?resource_slot - consultation_slot)
    :precondition
      (and
        (care_team_allocated ?patient_encounter)
        (treatment_ready ?patient_encounter)
        (not
          (consultation_assigned ?patient_encounter)
        )
        (consult_slot_available ?resource_slot)
        (not
          (support_equipment_verified ?patient_encounter)
        )
      )
    :effect
      (and
        (support_equipment_verified ?patient_encounter)
        (not
          (consult_slot_available ?resource_slot)
        )
      )
  )
  (:action reserve_protocol_for_group
    :parameters (?patient_encounter - patient_encounter ?resource_slot - care_protocol)
    :precondition
      (and
        (support_equipment_verified ?patient_encounter)
        (protocol_available ?resource_slot)
        (protocol_compatible_with_patient ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (protocol_applicable_to_group ?patient_encounter ?resource_slot)
        (not
          (protocol_available ?resource_slot)
        )
      )
  )
  (:action bind_group_protocol_compatibility
    :parameters (?patient_group_b - patient_group_b ?resource_slot - patient_group_a ?care_protocol - care_protocol)
    :precondition
      (and
        (patient_registered ?patient_group_b)
        (triage_category_b ?patient_group_b)
        (protocol_applicable_to_patient ?patient_group_b ?care_protocol)
        (protocol_applicable_to_group ?resource_slot ?care_protocol)
        (not
          (patient_protocol_bound ?patient_group_b ?care_protocol)
        )
      )
    :effect
      (and
        (patient_protocol_bound ?patient_group_b ?care_protocol)
      )
  )
  (:action confirm_specialist_consult
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment ?specialist_staff - specialist_staff)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (triage_category_b ?patient_encounter)
        (treatment_ready ?patient_encounter)
        (support_equipment_verified ?patient_encounter)
        (equipment_allocated_to ?patient_encounter ?resource_slot)
        (specialist_available ?specialist_staff)
        (not
          (specialist_consult_confirmed ?patient_encounter)
        )
      )
    :effect
      (and
        (specialist_consult_confirmed ?patient_encounter)
      )
  )
  (:action confirm_final_assignment_priority_a
    :parameters (?patient_encounter - patient_encounter)
    :precondition
      (and
        (triage_category_a ?patient_encounter)
        (patient_registered ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (treatment_area_confirmed ?patient_encounter)
        (care_team_allocated ?patient_encounter)
        (support_equipment_verified ?patient_encounter)
        (treatment_ready ?patient_encounter)
        (not
          (final_assignment_confirmed ?patient_encounter)
        )
      )
    :effect
      (and
        (final_assignment_confirmed ?patient_encounter)
      )
  )
  (:action confirm_final_assignment_with_protocol
    :parameters (?patient_encounter - patient_encounter ?resource_slot - care_protocol)
    :precondition
      (and
        (triage_category_b ?patient_encounter)
        (patient_registered ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (treatment_area_confirmed ?patient_encounter)
        (care_team_allocated ?patient_encounter)
        (support_equipment_verified ?patient_encounter)
        (treatment_ready ?patient_encounter)
        (patient_protocol_bound ?patient_encounter ?resource_slot)
        (not
          (final_assignment_confirmed ?patient_encounter)
        )
      )
    :effect
      (and
        (final_assignment_confirmed ?patient_encounter)
      )
  )
  (:action confirm_final_assignment_with_specialist_consult
    :parameters (?patient_encounter - patient_encounter)
    :precondition
      (and
        (triage_category_b ?patient_encounter)
        (patient_registered ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (treatment_area_confirmed ?patient_encounter)
        (care_team_allocated ?patient_encounter)
        (support_equipment_verified ?patient_encounter)
        (treatment_ready ?patient_encounter)
        (specialist_consult_confirmed ?patient_encounter)
        (not
          (final_assignment_confirmed ?patient_encounter)
        )
      )
    :effect
      (and
        (final_assignment_confirmed ?patient_encounter)
      )
  )
)

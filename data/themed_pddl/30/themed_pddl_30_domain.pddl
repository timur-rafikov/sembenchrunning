(define (domain pediatric_emergency_bed_assignment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types patient_encounter - object bed_resource - object treatment_area - object clinical_staff - object medical_device - object procedure_room - object support_equipment - object consultation_slot - object care_protocol - object specialist_staff - object diagnostic_resource - object medication_set - object care_attribute - object nurse_team - care_attribute physician_team - care_attribute patient_group_a - patient_encounter patient_group_b - patient_encounter)
  (:predicates
    (consult_slot_available ?consultation_slot - consultation_slot)
    (staff_assigned_to ?patient_encounter - patient_encounter ?resource_slot - clinical_staff)
    (ready_for_equipment_allocation ?patient_encounter - patient_encounter)
    (bed_reserved_for ?patient_encounter - patient_encounter ?resource_slot - bed_resource)
    (patient_has_attribute ?patient_encounter - patient_encounter ?resource_slot - care_attribute)
    (procedure_room_available ?procedure_room - procedure_room)
    (staff_available ?clinical_staff - clinical_staff)
    (medication_compatible_for ?patient_encounter - patient_encounter ?resource_slot - medication_set)
    (final_assignment_confirmed ?patient_encounter - patient_encounter)
    (triage_category_a ?patient_encounter - patient_encounter)
    (bed_compatible_for ?patient_encounter - patient_encounter ?resource_slot - bed_resource)
    (treatment_area_available ?treatment_area - treatment_area)
    (diagnostic_available ?diagnostic_resource - diagnostic_resource)
    (equipment_available ?support_equipment - support_equipment)
    (treatment_area_confirmed ?patient_encounter - patient_encounter)
    (staff_compatible_for ?patient_encounter - patient_encounter ?resource_slot - clinical_staff)
    (medication_reserved_for ?patient_encounter - patient_encounter ?resource_slot - medication_set)
    (treatment_area_assigned_to ?patient_encounter - patient_encounter ?resource_slot - treatment_area)
    (care_team_allocated ?patient_encounter - patient_encounter)
    (procedure_room_compatible_for ?patient_encounter - patient_encounter ?resource_slot - procedure_room)
    (medication_available ?medication_set - medication_set)
    (triage_category_b ?patient_encounter - patient_encounter)
    (treatment_ready ?patient_encounter - patient_encounter)
    (device_compatible_for ?patient_encounter - patient_encounter ?resource_slot - medical_device)
    (device_reserved_for ?patient_encounter - patient_encounter ?resource_slot - medical_device)
    (resource_check_flag ?patient_encounter - patient_encounter)
    (equipment_allocated_to ?patient_encounter - patient_encounter ?resource_slot - support_equipment)
    (specialist_consult_confirmed ?patient_encounter - patient_encounter)
    (diagnostic_compatible_for ?patient_encounter - patient_encounter ?resource_slot - diagnostic_resource)
    (patient_registered ?patient_encounter - patient_encounter)
    (bed_available ?bed_resource - bed_resource)
    (has_provisional_bed ?patient_encounter - patient_encounter)
    (specialist_available ?specialist_staff - specialist_staff)
    (protocol_available ?care_protocol - care_protocol)
    (procedure_room_reserved_for ?patient_encounter - patient_encounter ?resource_slot - procedure_room)
    (protocol_applicable_to_group ?patient_group_a - patient_encounter ?resource_slot - care_protocol)
    (staff_assigned ?patient_encounter - patient_encounter)
    (support_equipment_verified ?patient_encounter - patient_encounter)
    (protocol_compatible_with_patient ?patient_encounter - patient_encounter ?resource_slot - care_protocol)
    (device_available ?medical_device - medical_device)
    (protocol_applicable_to_patient ?patient_encounter - patient_encounter ?resource_slot - care_protocol)
    (treatment_area_compatible_for ?patient_encounter - patient_encounter ?resource_slot - treatment_area)
    (consultation_assigned ?patient_encounter - patient_encounter)
    (patient_protocol_bound ?patient_encounter - patient_encounter ?resource_slot - care_protocol)
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
  (:action allocate_physician_team
    :parameters (?patient_encounter - patient_encounter ?resource_slot - procedure_room ?medication_set - medication_set ?physician_team - physician_team)
    :precondition
      (and
        (not
          (care_team_allocated ?patient_encounter)
        )
        (treatment_area_confirmed ?patient_encounter)
        (treatment_ready ?patient_encounter)
        (medication_reserved_for ?patient_encounter ?medication_set)
        (patient_has_attribute ?patient_encounter ?physician_team)
        (procedure_room_reserved_for ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (consultation_assigned ?patient_encounter)
        (care_team_allocated ?patient_encounter)
      )
  )
  (:action confirm_final_assignment_priority_a
    :parameters (?patient_encounter - patient_encounter)
    :precondition
      (and
        (treatment_ready ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (treatment_area_confirmed ?patient_encounter)
        (patient_registered ?patient_encounter)
        (support_equipment_verified ?patient_encounter)
        (not
          (final_assignment_confirmed ?patient_encounter)
        )
        (triage_category_a ?patient_encounter)
        (care_team_allocated ?patient_encounter)
      )
    :effect
      (and
        (final_assignment_confirmed ?patient_encounter)
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
  (:action allocate_support_equipment
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment)
    :precondition
      (and
        (equipment_available ?resource_slot)
        (patient_registered ?patient_encounter)
      )
    :effect
      (and
        (not
          (equipment_available ?resource_slot)
        )
        (equipment_allocated_to ?patient_encounter ?resource_slot)
      )
  )
  (:action allocate_care_team
    :parameters (?patient_encounter - patient_encounter ?resource_slot - medical_device ?clinical_staff - clinical_staff ?nurse_team - nurse_team)
    :precondition
      (and
        (patient_has_attribute ?patient_encounter ?nurse_team)
        (treatment_ready ?patient_encounter)
        (not
          (consultation_assigned ?patient_encounter)
        )
        (device_reserved_for ?patient_encounter ?resource_slot)
        (treatment_area_confirmed ?patient_encounter)
        (staff_assigned_to ?patient_encounter ?clinical_staff)
        (not
          (care_team_allocated ?patient_encounter)
        )
      )
    :effect
      (and
        (care_team_allocated ?patient_encounter)
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
  (:action reserve_procedure_room
    :parameters (?patient_encounter - patient_encounter ?resource_slot - procedure_room)
    :precondition
      (and
        (procedure_room_compatible_for ?patient_encounter ?resource_slot)
        (patient_registered ?patient_encounter)
        (procedure_room_available ?resource_slot)
      )
    :effect
      (and
        (procedure_room_reserved_for ?patient_encounter ?resource_slot)
        (not
          (procedure_room_available ?resource_slot)
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
        (not
          (device_available ?resource_slot)
        )
        (device_reserved_for ?patient_encounter ?resource_slot)
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
  (:action assign_treatment_area_and_initialize
    :parameters (?patient_encounter - patient_encounter ?resource_slot - treatment_area ?medical_device - medical_device ?clinical_staff - clinical_staff)
    :precondition
      (and
        (has_provisional_bed ?patient_encounter)
        (treatment_area_available ?resource_slot)
        (treatment_area_compatible_for ?patient_encounter ?resource_slot)
        (not
          (treatment_area_confirmed ?patient_encounter)
        )
        (staff_assigned_to ?patient_encounter ?clinical_staff)
        (device_reserved_for ?patient_encounter ?medical_device)
      )
    :effect
      (and
        (treatment_area_assigned_to ?patient_encounter ?resource_slot)
        (not
          (treatment_area_available ?resource_slot)
        )
        (treatment_area_confirmed ?patient_encounter)
      )
  )
  (:action finalize_phase_transition
    :parameters (?patient_encounter - patient_encounter ?resource_slot - medical_device ?clinical_staff - clinical_staff)
    :precondition
      (and
        (device_reserved_for ?patient_encounter ?resource_slot)
        (care_team_allocated ?patient_encounter)
        (staff_assigned_to ?patient_encounter ?clinical_staff)
        (consultation_assigned ?patient_encounter)
      )
    :effect
      (and
        (not
          (resource_check_flag ?patient_encounter)
        )
        (not
          (consultation_assigned ?patient_encounter)
        )
        (not
          (treatment_ready ?patient_encounter)
        )
        (ready_for_equipment_allocation ?patient_encounter)
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
  (:action confirm_specialist_and_equipment
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment ?specialist_staff - specialist_staff)
    :precondition
      (and
        (not
          (treatment_ready ?patient_encounter)
        )
        (has_provisional_bed ?patient_encounter)
        (specialist_available ?specialist_staff)
        (equipment_allocated_to ?patient_encounter ?resource_slot)
        (staff_assigned ?patient_encounter)
      )
    :effect
      (and
        (not
          (consultation_assigned ?patient_encounter)
        )
        (treatment_ready ?patient_encounter)
      )
  )
  (:action confirm_final_assignment_with_specialist_consult
    :parameters (?patient_encounter - patient_encounter)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (triage_category_b ?patient_encounter)
        (specialist_consult_confirmed ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (treatment_ready ?patient_encounter)
        (not
          (final_assignment_confirmed ?patient_encounter)
        )
        (support_equipment_verified ?patient_encounter)
        (treatment_area_confirmed ?patient_encounter)
        (care_team_allocated ?patient_encounter)
      )
    :effect
      (and
        (final_assignment_confirmed ?patient_encounter)
      )
  )
  (:action confirm_specialist_consult
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment ?specialist_staff - specialist_staff)
    :precondition
      (and
        (treatment_ready ?patient_encounter)
        (specialist_available ?specialist_staff)
        (not
          (specialist_consult_confirmed ?patient_encounter)
        )
        (support_equipment_verified ?patient_encounter)
        (patient_registered ?patient_encounter)
        (triage_category_b ?patient_encounter)
        (equipment_allocated_to ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (specialist_consult_confirmed ?patient_encounter)
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
  (:action reserve_medication_set
    :parameters (?patient_encounter - patient_encounter ?resource_slot - medication_set)
    :precondition
      (and
        (medication_available ?resource_slot)
        (patient_registered ?patient_encounter)
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
  (:action assign_consultation_slot_to_patient
    :parameters (?patient_encounter - patient_encounter ?resource_slot - consultation_slot)
    :precondition
      (and
        (not
          (staff_assigned ?patient_encounter)
        )
        (patient_registered ?patient_encounter)
        (consult_slot_available ?resource_slot)
        (has_provisional_bed ?patient_encounter)
      )
    :effect
      (and
        (consultation_assigned ?patient_encounter)
        (not
          (consult_slot_available ?resource_slot)
        )
        (staff_assigned ?patient_encounter)
      )
  )
  (:action assign_treatment_area_with_resources
    :parameters (?patient_encounter - patient_encounter ?resource_slot - treatment_area ?procedure_room - procedure_room ?diagnostic_resource - diagnostic_resource)
    :precondition
      (and
        (diagnostic_available ?diagnostic_resource)
        (diagnostic_compatible_for ?patient_encounter ?diagnostic_resource)
        (not
          (treatment_area_confirmed ?patient_encounter)
        )
        (has_provisional_bed ?patient_encounter)
        (treatment_area_available ?resource_slot)
        (treatment_area_compatible_for ?patient_encounter ?resource_slot)
        (procedure_room_reserved_for ?patient_encounter ?procedure_room)
      )
    :effect
      (and
        (treatment_area_assigned_to ?patient_encounter ?resource_slot)
        (not
          (diagnostic_available ?diagnostic_resource)
        )
        (resource_check_flag ?patient_encounter)
        (not
          (treatment_area_available ?resource_slot)
        )
        (consultation_assigned ?patient_encounter)
        (treatment_area_confirmed ?patient_encounter)
      )
  )
  (:action reserve_consultation_slot
    :parameters (?patient_encounter - patient_encounter ?resource_slot - consultation_slot)
    :precondition
      (and
        (consult_slot_available ?resource_slot)
        (not
          (consultation_assigned ?patient_encounter)
        )
        (treatment_ready ?patient_encounter)
        (care_team_allocated ?patient_encounter)
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
  (:action release_provisional_bed
    :parameters (?patient_encounter - patient_encounter ?resource_slot - bed_resource)
    :precondition
      (and
        (bed_reserved_for ?patient_encounter ?resource_slot)
        (not
          (care_team_allocated ?patient_encounter)
        )
        (not
          (treatment_area_confirmed ?patient_encounter)
        )
      )
    :effect
      (and
        (not
          (bed_reserved_for ?patient_encounter ?resource_slot)
        )
        (bed_available ?resource_slot)
        (not
          (has_provisional_bed ?patient_encounter)
        )
        (not
          (staff_assigned ?patient_encounter)
        )
        (not
          (ready_for_equipment_allocation ?patient_encounter)
        )
        (not
          (treatment_ready ?patient_encounter)
        )
        (not
          (resource_check_flag ?patient_encounter)
        )
        (not
          (consultation_assigned ?patient_encounter)
        )
      )
  )
  (:action verify_support_equipment
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment)
    :precondition
      (and
        (not
          (support_equipment_verified ?patient_encounter)
        )
        (equipment_allocated_to ?patient_encounter ?resource_slot)
        (treatment_ready ?patient_encounter)
        (care_team_allocated ?patient_encounter)
        (not
          (consultation_assigned ?patient_encounter)
        )
      )
    :effect
      (and
        (support_equipment_verified ?patient_encounter)
      )
  )
  (:action confirm_final_assignment_with_protocol
    :parameters (?patient_encounter - patient_encounter ?resource_slot - care_protocol)
    :precondition
      (and
        (support_equipment_verified ?patient_encounter)
        (care_team_allocated ?patient_encounter)
        (treatment_area_confirmed ?patient_encounter)
        (patient_protocol_bound ?patient_encounter ?resource_slot)
        (treatment_ready ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (patient_registered ?patient_encounter)
        (not
          (final_assignment_confirmed ?patient_encounter)
        )
        (triage_category_b ?patient_encounter)
      )
    :effect
      (and
        (final_assignment_confirmed ?patient_encounter)
      )
  )
  (:action confirm_equipment_assignment
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment)
    :precondition
      (and
        (patient_registered ?patient_encounter)
        (has_provisional_bed ?patient_encounter)
        (not
          (staff_assigned ?patient_encounter)
        )
        (equipment_allocated_to ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (staff_assigned ?patient_encounter)
      )
  )
  (:action reserve_provisional_bed
    :parameters (?patient_encounter - patient_encounter ?resource_slot - bed_resource)
    :precondition
      (and
        (not
          (has_provisional_bed ?patient_encounter)
        )
        (patient_registered ?patient_encounter)
        (bed_available ?resource_slot)
        (bed_compatible_for ?patient_encounter ?resource_slot)
      )
    :effect
      (and
        (has_provisional_bed ?patient_encounter)
        (not
          (bed_available ?resource_slot)
        )
        (bed_reserved_for ?patient_encounter ?resource_slot)
      )
  )
  (:action confirm_support_equipment_with_specialist
    :parameters (?patient_encounter - patient_encounter ?resource_slot - support_equipment ?specialist_staff - specialist_staff)
    :precondition
      (and
        (has_provisional_bed ?patient_encounter)
        (not
          (treatment_ready ?patient_encounter)
        )
        (equipment_allocated_to ?patient_encounter ?resource_slot)
        (care_team_allocated ?patient_encounter)
        (specialist_available ?specialist_staff)
        (ready_for_equipment_allocation ?patient_encounter)
      )
    :effect
      (and
        (treatment_ready ?patient_encounter)
      )
  )
  (:action bind_group_protocol_compatibility
    :parameters (?patient_group_b - patient_group_b ?resource_slot - patient_group_a ?care_protocol - care_protocol)
    :precondition
      (and
        (patient_registered ?patient_group_b)
        (protocol_applicable_to_group ?resource_slot ?care_protocol)
        (triage_category_b ?patient_group_b)
        (not
          (patient_protocol_bound ?patient_group_b ?care_protocol)
        )
        (protocol_applicable_to_patient ?patient_group_b ?care_protocol)
      )
    :effect
      (and
        (patient_protocol_bound ?patient_group_b ?care_protocol)
      )
  )
)

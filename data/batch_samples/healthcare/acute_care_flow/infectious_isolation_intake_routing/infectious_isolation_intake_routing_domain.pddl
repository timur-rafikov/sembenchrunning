(define (domain infectious_isolation_intake_routing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types physical_entity - object case_entity - physical_entity intake_channel - physical_entity inpatient_bed - physical_entity isolation_protocol - physical_entity clinical_supply - physical_entity transport_asset - physical_entity isolation_room - physical_entity ppe_kit - physical_entity laboratory_service - physical_entity environmental_service_team - physical_entity diagnostic_device - physical_entity specimen_kit - physical_entity assignment_unit - physical_entity nurse_team - assignment_unit physician_team - assignment_unit staff_member - case_entity workflow_coordinator - case_entity)

  (:predicates
    (case_registered ?patient_case - case_entity)
    (intake_assignment ?patient_case - case_entity ?intake_channel - intake_channel)
    (intake_allocated ?patient_case - case_entity)
    (precontact_cleared ?patient_case - case_entity)
    (isolation_room_ready ?patient_case - case_entity)
    (supply_assignment ?patient_case - case_entity ?clinical_supply - clinical_supply)
    (protocol_assignment ?patient_case - case_entity ?isolation_protocol - isolation_protocol)
    (transport_assignment ?patient_case - case_entity ?transport_asset - transport_asset)
    (specimen_kit_assignment ?patient_case - case_entity ?specimen_kit - specimen_kit)
    (bed_assignment ?patient_case - case_entity ?inpatient_bed - inpatient_bed)
    (admitted_flag ?patient_case - case_entity)
    (multidisciplinary_assigned ?patient_case - case_entity)
    (ppe_verified ?patient_case - case_entity)
    (isolation_cleared ?patient_case - case_entity)
    (ppe_allocated ?patient_case - case_entity)
    (care_initiated ?patient_case - case_entity)
    (lab_authorization ?patient_case - case_entity ?laboratory_service - laboratory_service)
    (specimen_routed ?patient_case - case_entity ?laboratory_service - laboratory_service)
    (monitoring_ready_flag ?patient_case - case_entity)
    (intake_channel_available ?intake_channel - intake_channel)
    (bed_available ?inpatient_bed - inpatient_bed)
    (supply_available ?clinical_supply - clinical_supply)
    (protocol_available ?isolation_protocol - isolation_protocol)
    (transport_available ?transport_asset - transport_asset)
    (room_available ?isolation_room - isolation_room)
    (ppe_kit_available ?ppe_kit - ppe_kit)
    (laboratory_service_available ?laboratory_service - laboratory_service)
    (env_service_team_available ?environmental_service_team - environmental_service_team)
    (diagnostic_device_available ?diagnostic_device - diagnostic_device)
    (specimen_kit_available ?specimen_kit - specimen_kit)
    (channel_compatible_with_case ?patient_case - case_entity ?intake_channel - intake_channel)
    (bed_compatible_with_case ?patient_case - case_entity ?inpatient_bed - inpatient_bed)
    (supply_compatible_with_case ?patient_case - case_entity ?clinical_supply - clinical_supply)
    (protocol_applicable_to_case ?patient_case - case_entity ?isolation_protocol - isolation_protocol)
    (transport_assignable_to_case ?patient_case - case_entity ?transport_asset - transport_asset)
    (device_compatible_with_case ?patient_case - case_entity ?diagnostic_device - diagnostic_device)
    (specimen_required_for_case ?patient_case - case_entity ?specimen_kit - specimen_kit)
    (assignment_unit_eligible_for_case ?patient_case - case_entity ?assignment_unit - assignment_unit)
    (entity_linked_to_lab_service ?patient_case - case_entity ?laboratory_service - laboratory_service)
    (requires_isolation ?patient_case - case_entity)
    (requires_lab_processing ?patient_case - case_entity)
    (room_reservation ?patient_case - case_entity ?isolation_room - isolation_room)
    (requires_enhanced_monitoring ?patient_case - case_entity)
    (lab_service_linked_to_case ?patient_case - case_entity ?laboratory_service - laboratory_service)
  )
  (:action register_patient_case
    :parameters (?patient_case - case_entity)
    :precondition
      (and
        (not
          (case_registered ?patient_case)
        )
        (not
          (isolation_cleared ?patient_case)
        )
      )
    :effect
      (and
        (case_registered ?patient_case)
      )
  )
  (:action assign_intake_channel
    :parameters (?patient_case - case_entity ?intake_channel - intake_channel)
    :precondition
      (and
        (case_registered ?patient_case)
        (intake_channel_available ?intake_channel)
        (channel_compatible_with_case ?patient_case ?intake_channel)
        (not
          (intake_allocated ?patient_case)
        )
      )
    :effect
      (and
        (intake_assignment ?patient_case ?intake_channel)
        (intake_allocated ?patient_case)
        (not
          (intake_channel_available ?intake_channel)
        )
      )
  )
  (:action release_intake_channel_allocation
    :parameters (?patient_case - case_entity ?intake_channel - intake_channel)
    :precondition
      (and
        (intake_assignment ?patient_case ?intake_channel)
        (not
          (admitted_flag ?patient_case)
        )
        (not
          (multidisciplinary_assigned ?patient_case)
        )
      )
    :effect
      (and
        (not
          (intake_assignment ?patient_case ?intake_channel)
        )
        (not
          (intake_allocated ?patient_case)
        )
        (not
          (precontact_cleared ?patient_case)
        )
        (not
          (isolation_room_ready ?patient_case)
        )
        (not
          (ppe_allocated ?patient_case)
        )
        (not
          (care_initiated ?patient_case)
        )
        (not
          (requires_enhanced_monitoring ?patient_case)
        )
        (intake_channel_available ?intake_channel)
      )
  )
  (:action reserve_isolation_room
    :parameters (?patient_case - case_entity ?isolation_room - isolation_room)
    :precondition
      (and
        (case_registered ?patient_case)
        (room_available ?isolation_room)
      )
    :effect
      (and
        (room_reservation ?patient_case ?isolation_room)
        (not
          (room_available ?isolation_room)
        )
      )
  )
  (:action cancel_isolation_room_reservation
    :parameters (?patient_case - case_entity ?isolation_room - isolation_room)
    :precondition
      (and
        (room_reservation ?patient_case ?isolation_room)
      )
    :effect
      (and
        (room_available ?isolation_room)
        (not
          (room_reservation ?patient_case ?isolation_room)
        )
      )
  )
  (:action confirm_room_preparation
    :parameters (?patient_case - case_entity ?isolation_room - isolation_room)
    :precondition
      (and
        (case_registered ?patient_case)
        (intake_allocated ?patient_case)
        (room_reservation ?patient_case ?isolation_room)
        (not
          (precontact_cleared ?patient_case)
        )
      )
    :effect
      (and
        (precontact_cleared ?patient_case)
      )
  )
  (:action assign_ppe_kit_to_case
    :parameters (?patient_case - case_entity ?ppe_kit - ppe_kit)
    :precondition
      (and
        (case_registered ?patient_case)
        (intake_allocated ?patient_case)
        (ppe_kit_available ?ppe_kit)
        (not
          (precontact_cleared ?patient_case)
        )
      )
    :effect
      (and
        (precontact_cleared ?patient_case)
        (ppe_allocated ?patient_case)
        (not
          (ppe_kit_available ?ppe_kit)
        )
      )
  )
  (:action perform_environmental_turnover
    :parameters (?patient_case - case_entity ?isolation_room - isolation_room ?environmental_service_team - environmental_service_team)
    :precondition
      (and
        (precontact_cleared ?patient_case)
        (intake_allocated ?patient_case)
        (room_reservation ?patient_case ?isolation_room)
        (env_service_team_available ?environmental_service_team)
        (not
          (isolation_room_ready ?patient_case)
        )
      )
    :effect
      (and
        (isolation_room_ready ?patient_case)
        (not
          (ppe_allocated ?patient_case)
        )
      )
  )
  (:action collect_and_prepare_specimen
    :parameters (?patient_case - case_entity ?laboratory_service - laboratory_service)
    :precondition
      (and
        (intake_allocated ?patient_case)
        (specimen_routed ?patient_case ?laboratory_service)
        (not
          (isolation_room_ready ?patient_case)
        )
      )
    :effect
      (and
        (isolation_room_ready ?patient_case)
        (not
          (ppe_allocated ?patient_case)
        )
      )
  )
  (:action reserve_clinical_supply
    :parameters (?patient_case - case_entity ?clinical_supply - clinical_supply)
    :precondition
      (and
        (case_registered ?patient_case)
        (supply_available ?clinical_supply)
        (supply_compatible_with_case ?patient_case ?clinical_supply)
      )
    :effect
      (and
        (supply_assignment ?patient_case ?clinical_supply)
        (not
          (supply_available ?clinical_supply)
        )
      )
  )
  (:action release_clinical_supply
    :parameters (?patient_case - case_entity ?clinical_supply - clinical_supply)
    :precondition
      (and
        (supply_assignment ?patient_case ?clinical_supply)
      )
    :effect
      (and
        (supply_available ?clinical_supply)
        (not
          (supply_assignment ?patient_case ?clinical_supply)
        )
      )
  )
  (:action apply_isolation_protocol
    :parameters (?patient_case - case_entity ?isolation_protocol - isolation_protocol)
    :precondition
      (and
        (case_registered ?patient_case)
        (protocol_available ?isolation_protocol)
        (protocol_applicable_to_case ?patient_case ?isolation_protocol)
      )
    :effect
      (and
        (protocol_assignment ?patient_case ?isolation_protocol)
        (not
          (protocol_available ?isolation_protocol)
        )
      )
  )
  (:action release_isolation_protocol
    :parameters (?patient_case - case_entity ?isolation_protocol - isolation_protocol)
    :precondition
      (and
        (protocol_assignment ?patient_case ?isolation_protocol)
      )
    :effect
      (and
        (protocol_available ?isolation_protocol)
        (not
          (protocol_assignment ?patient_case ?isolation_protocol)
        )
      )
  )
  (:action reserve_transport_asset
    :parameters (?patient_case - case_entity ?transport_asset - transport_asset)
    :precondition
      (and
        (case_registered ?patient_case)
        (transport_available ?transport_asset)
        (transport_assignable_to_case ?patient_case ?transport_asset)
      )
    :effect
      (and
        (transport_assignment ?patient_case ?transport_asset)
        (not
          (transport_available ?transport_asset)
        )
      )
  )
  (:action release_transport_asset
    :parameters (?patient_case - case_entity ?transport_asset - transport_asset)
    :precondition
      (and
        (transport_assignment ?patient_case ?transport_asset)
      )
    :effect
      (and
        (transport_available ?transport_asset)
        (not
          (transport_assignment ?patient_case ?transport_asset)
        )
      )
  )
  (:action reserve_specimen_kit
    :parameters (?patient_case - case_entity ?specimen_kit - specimen_kit)
    :precondition
      (and
        (case_registered ?patient_case)
        (specimen_kit_available ?specimen_kit)
        (specimen_required_for_case ?patient_case ?specimen_kit)
      )
    :effect
      (and
        (specimen_kit_assignment ?patient_case ?specimen_kit)
        (not
          (specimen_kit_available ?specimen_kit)
        )
      )
  )
  (:action release_specimen_kit
    :parameters (?patient_case - case_entity ?specimen_kit - specimen_kit)
    :precondition
      (and
        (specimen_kit_assignment ?patient_case ?specimen_kit)
      )
    :effect
      (and
        (specimen_kit_available ?specimen_kit)
        (not
          (specimen_kit_assignment ?patient_case ?specimen_kit)
        )
      )
  )
  (:action assign_bed_and_admit
    :parameters (?patient_case - case_entity ?inpatient_bed - inpatient_bed ?clinical_supply - clinical_supply ?isolation_protocol - isolation_protocol)
    :precondition
      (and
        (intake_allocated ?patient_case)
        (supply_assignment ?patient_case ?clinical_supply)
        (protocol_assignment ?patient_case ?isolation_protocol)
        (bed_available ?inpatient_bed)
        (bed_compatible_with_case ?patient_case ?inpatient_bed)
        (not
          (admitted_flag ?patient_case)
        )
      )
    :effect
      (and
        (bed_assignment ?patient_case ?inpatient_bed)
        (admitted_flag ?patient_case)
        (not
          (bed_available ?inpatient_bed)
        )
      )
  )
  (:action assign_bed_with_diagnostic_device_and_admit
    :parameters (?patient_case - case_entity ?inpatient_bed - inpatient_bed ?transport_asset - transport_asset ?diagnostic_device - diagnostic_device)
    :precondition
      (and
        (intake_allocated ?patient_case)
        (transport_assignment ?patient_case ?transport_asset)
        (diagnostic_device_available ?diagnostic_device)
        (bed_available ?inpatient_bed)
        (bed_compatible_with_case ?patient_case ?inpatient_bed)
        (device_compatible_with_case ?patient_case ?diagnostic_device)
        (not
          (admitted_flag ?patient_case)
        )
      )
    :effect
      (and
        (bed_assignment ?patient_case ?inpatient_bed)
        (admitted_flag ?patient_case)
        (requires_enhanced_monitoring ?patient_case)
        (ppe_allocated ?patient_case)
        (not
          (bed_available ?inpatient_bed)
        )
        (not
          (diagnostic_device_available ?diagnostic_device)
        )
      )
  )
  (:action complete_initial_admission_status
    :parameters (?patient_case - case_entity ?clinical_supply - clinical_supply ?isolation_protocol - isolation_protocol)
    :precondition
      (and
        (admitted_flag ?patient_case)
        (requires_enhanced_monitoring ?patient_case)
        (supply_assignment ?patient_case ?clinical_supply)
        (protocol_assignment ?patient_case ?isolation_protocol)
      )
    :effect
      (and
        (not
          (requires_enhanced_monitoring ?patient_case)
        )
        (not
          (ppe_allocated ?patient_case)
        )
      )
  )
  (:action initiate_multidisciplinary_care
    :parameters (?patient_case - case_entity ?clinical_supply - clinical_supply ?isolation_protocol - isolation_protocol ?nurse_team - nurse_team)
    :precondition
      (and
        (isolation_room_ready ?patient_case)
        (admitted_flag ?patient_case)
        (supply_assignment ?patient_case ?clinical_supply)
        (protocol_assignment ?patient_case ?isolation_protocol)
        (assignment_unit_eligible_for_case ?patient_case ?nurse_team)
        (not
          (ppe_allocated ?patient_case)
        )
        (not
          (multidisciplinary_assigned ?patient_case)
        )
      )
    :effect
      (and
        (multidisciplinary_assigned ?patient_case)
      )
  )
  (:action assign_multidisciplinary_with_physician
    :parameters (?patient_case - case_entity ?transport_asset - transport_asset ?specimen_kit - specimen_kit ?physician_team - physician_team)
    :precondition
      (and
        (isolation_room_ready ?patient_case)
        (admitted_flag ?patient_case)
        (transport_assignment ?patient_case ?transport_asset)
        (specimen_kit_assignment ?patient_case ?specimen_kit)
        (assignment_unit_eligible_for_case ?patient_case ?physician_team)
        (not
          (multidisciplinary_assigned ?patient_case)
        )
      )
    :effect
      (and
        (multidisciplinary_assigned ?patient_case)
        (ppe_allocated ?patient_case)
      )
  )
  (:action progress_care_to_active_management
    :parameters (?patient_case - case_entity ?clinical_supply - clinical_supply ?isolation_protocol - isolation_protocol)
    :precondition
      (and
        (multidisciplinary_assigned ?patient_case)
        (ppe_allocated ?patient_case)
        (supply_assignment ?patient_case ?clinical_supply)
        (protocol_assignment ?patient_case ?isolation_protocol)
      )
    :effect
      (and
        (care_initiated ?patient_case)
        (not
          (ppe_allocated ?patient_case)
        )
        (not
          (isolation_room_ready ?patient_case)
        )
        (not
          (requires_enhanced_monitoring ?patient_case)
        )
      )
  )
  (:action reprepare_room_after_turnover
    :parameters (?patient_case - case_entity ?isolation_room - isolation_room ?environmental_service_team - environmental_service_team)
    :precondition
      (and
        (care_initiated ?patient_case)
        (multidisciplinary_assigned ?patient_case)
        (intake_allocated ?patient_case)
        (room_reservation ?patient_case ?isolation_room)
        (env_service_team_available ?environmental_service_team)
        (not
          (isolation_room_ready ?patient_case)
        )
      )
    :effect
      (and
        (isolation_room_ready ?patient_case)
      )
  )
  (:action verify_provider_readiness
    :parameters (?patient_case - case_entity ?isolation_room - isolation_room)
    :precondition
      (and
        (multidisciplinary_assigned ?patient_case)
        (isolation_room_ready ?patient_case)
        (not
          (ppe_allocated ?patient_case)
        )
        (room_reservation ?patient_case ?isolation_room)
        (not
          (ppe_verified ?patient_case)
        )
      )
    :effect
      (and
        (ppe_verified ?patient_case)
      )
  )
  (:action verify_provider_readiness_with_ppe_kit
    :parameters (?patient_case - case_entity ?ppe_kit - ppe_kit)
    :precondition
      (and
        (multidisciplinary_assigned ?patient_case)
        (isolation_room_ready ?patient_case)
        (not
          (ppe_allocated ?patient_case)
        )
        (ppe_kit_available ?ppe_kit)
        (not
          (ppe_verified ?patient_case)
        )
      )
    :effect
      (and
        (ppe_verified ?patient_case)
        (not
          (ppe_kit_available ?ppe_kit)
        )
      )
  )
  (:action route_specimen_to_lab_service
    :parameters (?patient_case - case_entity ?laboratory_service - laboratory_service)
    :precondition
      (and
        (ppe_verified ?patient_case)
        (laboratory_service_available ?laboratory_service)
        (lab_service_linked_to_case ?patient_case ?laboratory_service)
      )
    :effect
      (and
        (entity_linked_to_lab_service ?patient_case ?laboratory_service)
        (not
          (laboratory_service_available ?laboratory_service)
        )
      )
  )
  (:action authorize_lab_routing
    :parameters (?workflow_coordinator - workflow_coordinator ?staff_member - staff_member ?laboratory_service - laboratory_service)
    :precondition
      (and
        (case_registered ?workflow_coordinator)
        (requires_lab_processing ?workflow_coordinator)
        (lab_authorization ?workflow_coordinator ?laboratory_service)
        (entity_linked_to_lab_service ?staff_member ?laboratory_service)
        (not
          (specimen_routed ?workflow_coordinator ?laboratory_service)
        )
      )
    :effect
      (and
        (specimen_routed ?workflow_coordinator ?laboratory_service)
      )
  )
  (:action perform_room_turnover_check
    :parameters (?patient_case - case_entity ?isolation_room - isolation_room ?environmental_service_team - environmental_service_team)
    :precondition
      (and
        (case_registered ?patient_case)
        (requires_lab_processing ?patient_case)
        (isolation_room_ready ?patient_case)
        (ppe_verified ?patient_case)
        (room_reservation ?patient_case ?isolation_room)
        (env_service_team_available ?environmental_service_team)
        (not
          (monitoring_ready_flag ?patient_case)
        )
      )
    :effect
      (and
        (monitoring_ready_flag ?patient_case)
      )
  )
  (:action mark_isolation_cleared
    :parameters (?patient_case - case_entity)
    :precondition
      (and
        (requires_isolation ?patient_case)
        (case_registered ?patient_case)
        (intake_allocated ?patient_case)
        (admitted_flag ?patient_case)
        (multidisciplinary_assigned ?patient_case)
        (ppe_verified ?patient_case)
        (isolation_room_ready ?patient_case)
        (not
          (isolation_cleared ?patient_case)
        )
      )
    :effect
      (and
        (isolation_cleared ?patient_case)
      )
  )
  (:action mark_isolation_cleared_with_lab_result
    :parameters (?patient_case - case_entity ?laboratory_service - laboratory_service)
    :precondition
      (and
        (requires_lab_processing ?patient_case)
        (case_registered ?patient_case)
        (intake_allocated ?patient_case)
        (admitted_flag ?patient_case)
        (multidisciplinary_assigned ?patient_case)
        (ppe_verified ?patient_case)
        (isolation_room_ready ?patient_case)
        (specimen_routed ?patient_case ?laboratory_service)
        (not
          (isolation_cleared ?patient_case)
        )
      )
    :effect
      (and
        (isolation_cleared ?patient_case)
      )
  )
  (:action mark_isolation_cleared_with_monitoring
    :parameters (?patient_case - case_entity)
    :precondition
      (and
        (requires_lab_processing ?patient_case)
        (case_registered ?patient_case)
        (intake_allocated ?patient_case)
        (admitted_flag ?patient_case)
        (multidisciplinary_assigned ?patient_case)
        (ppe_verified ?patient_case)
        (isolation_room_ready ?patient_case)
        (monitoring_ready_flag ?patient_case)
        (not
          (isolation_cleared ?patient_case)
        )
      )
    :effect
      (and
        (isolation_cleared ?patient_case)
      )
  )
)

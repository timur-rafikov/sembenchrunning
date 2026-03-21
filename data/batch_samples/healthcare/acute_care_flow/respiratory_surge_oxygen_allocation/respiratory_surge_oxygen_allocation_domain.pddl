(define (domain respiratory_surge_oxygen_allocation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types patient_encounter - object oxygen_interface_point - object therapy_protocol - object patient_interface_device - object oxygen_source_unit - object high_flow_device_unit - object adapter_kit - object consumable_stock_item - object resource_batch - object respiratory_therapist - object ancillary_module - object monitoring_device_unit - object clinical_team - object nursing_team - clinical_team respiratory_team - clinical_team patient_adult - patient_encounter patient_pediatric - patient_encounter)
  (:predicates
    (encounter_registered ?patient_encounter - patient_encounter)
    (interface_assigned ?patient_encounter - patient_encounter ?oxygen_interface_point - oxygen_interface_point)
    (assignment_in_progress ?patient_encounter - patient_encounter)
    (adapter_attached ?patient_encounter - patient_encounter)
    (therapy_setup_complete ?patient_encounter - patient_encounter)
    (source_assigned ?patient_encounter - patient_encounter ?oxygen_source_unit - oxygen_source_unit)
    (device_assigned ?patient_encounter - patient_encounter ?patient_interface_device - patient_interface_device)
    (high_flow_assigned ?patient_encounter - patient_encounter ?high_flow_device_unit - high_flow_device_unit)
    (monitoring_assigned ?patient_encounter - patient_encounter ?monitoring_device_unit - monitoring_device_unit)
    (therapy_ordered ?patient_encounter - patient_encounter ?therapy_protocol - therapy_protocol)
    (order_confirmed ?patient_encounter - patient_encounter)
    (approval_granted ?patient_encounter - patient_encounter)
    (safety_check_completed ?patient_encounter - patient_encounter)
    (encounter_finalized ?patient_encounter - patient_encounter)
    (consumable_staged ?patient_encounter - patient_encounter)
    (therapy_active ?patient_encounter - patient_encounter)
    (cohort_resource_link ?patient_encounter - patient_encounter ?resource_batch - resource_batch)
    (resource_allocated ?patient_encounter - patient_encounter ?resource_batch - resource_batch)
    (monitoring_activated ?patient_encounter - patient_encounter)
    (interface_available ?oxygen_interface_point - oxygen_interface_point)
    (protocol_available ?therapy_protocol - therapy_protocol)
    (source_available ?oxygen_source_unit - oxygen_source_unit)
    (device_available ?patient_interface_device - patient_interface_device)
    (high_flow_available ?high_flow_device_unit - high_flow_device_unit)
    (adapter_available ?adapter_kit - adapter_kit)
    (consumable_available ?consumable_stock_item - consumable_stock_item)
    (resource_batch_available ?resource_batch - resource_batch)
    (therapist_available ?respiratory_therapist - respiratory_therapist)
    (ancillary_available ?ancillary_module - ancillary_module)
    (monitoring_available ?monitoring_device_unit - monitoring_device_unit)
    (patient_interface_compatible ?patient_encounter - patient_encounter ?oxygen_interface_point - oxygen_interface_point)
    (patient_protocol_compatible ?patient_encounter - patient_encounter ?therapy_protocol - therapy_protocol)
    (patient_source_compatible ?patient_encounter - patient_encounter ?oxygen_source_unit - oxygen_source_unit)
    (patient_device_compatible ?patient_encounter - patient_encounter ?patient_interface_device - patient_interface_device)
    (patient_high_flow_compatible ?patient_encounter - patient_encounter ?high_flow_device_unit - high_flow_device_unit)
    (patient_ancillary_compatible ?patient_encounter - patient_encounter ?ancillary_module - ancillary_module)
    (patient_monitoring_compatible ?patient_encounter - patient_encounter ?monitoring_device_unit - monitoring_device_unit)
    (team_eligible ?patient_encounter - patient_encounter ?clinical_team - clinical_team)
    (patient_resource_compatible ?patient_encounter - patient_encounter ?resource_batch - resource_batch)
    (stabilized_flag ?patient_encounter - patient_encounter)
    (special_population_flag ?patient_encounter - patient_encounter)
    (adapter_assigned_to_patient ?patient_encounter - patient_encounter ?adapter_kit - adapter_kit)
    (ancillary_required_flag ?patient_encounter - patient_encounter)
    (patient_resource_binding_possible ?patient_encounter - patient_encounter ?resource_batch - resource_batch)
  )
  (:action register_encounter
    :parameters (?patient_encounter - patient_encounter)
    :precondition
      (and
        (not
          (encounter_registered ?patient_encounter)
        )
        (not
          (encounter_finalized ?patient_encounter)
        )
      )
    :effect
      (and
        (encounter_registered ?patient_encounter)
      )
  )
  (:action assign_interface_to_patient
    :parameters (?patient_encounter - patient_encounter ?oxygen_interface_point - oxygen_interface_point)
    :precondition
      (and
        (encounter_registered ?patient_encounter)
        (interface_available ?oxygen_interface_point)
        (patient_interface_compatible ?patient_encounter ?oxygen_interface_point)
        (not
          (assignment_in_progress ?patient_encounter)
        )
      )
    :effect
      (and
        (interface_assigned ?patient_encounter ?oxygen_interface_point)
        (assignment_in_progress ?patient_encounter)
        (not
          (interface_available ?oxygen_interface_point)
        )
      )
  )
  (:action release_interface_and_cleanup
    :parameters (?patient_encounter - patient_encounter ?oxygen_interface_point - oxygen_interface_point)
    :precondition
      (and
        (interface_assigned ?patient_encounter ?oxygen_interface_point)
        (not
          (order_confirmed ?patient_encounter)
        )
        (not
          (approval_granted ?patient_encounter)
        )
      )
    :effect
      (and
        (not
          (interface_assigned ?patient_encounter ?oxygen_interface_point)
        )
        (not
          (assignment_in_progress ?patient_encounter)
        )
        (not
          (adapter_attached ?patient_encounter)
        )
        (not
          (therapy_setup_complete ?patient_encounter)
        )
        (not
          (consumable_staged ?patient_encounter)
        )
        (not
          (therapy_active ?patient_encounter)
        )
        (not
          (ancillary_required_flag ?patient_encounter)
        )
        (interface_available ?oxygen_interface_point)
      )
  )
  (:action reserve_adapter_for_patient
    :parameters (?patient_encounter - patient_encounter ?adapter_kit - adapter_kit)
    :precondition
      (and
        (encounter_registered ?patient_encounter)
        (adapter_available ?adapter_kit)
      )
    :effect
      (and
        (adapter_assigned_to_patient ?patient_encounter ?adapter_kit)
        (not
          (adapter_available ?adapter_kit)
        )
      )
  )
  (:action release_adapter_from_patient
    :parameters (?patient_encounter - patient_encounter ?adapter_kit - adapter_kit)
    :precondition
      (and
        (adapter_assigned_to_patient ?patient_encounter ?adapter_kit)
      )
    :effect
      (and
        (adapter_available ?adapter_kit)
        (not
          (adapter_assigned_to_patient ?patient_encounter ?adapter_kit)
        )
      )
  )
  (:action attach_adapter
    :parameters (?patient_encounter - patient_encounter ?adapter_kit - adapter_kit)
    :precondition
      (and
        (encounter_registered ?patient_encounter)
        (assignment_in_progress ?patient_encounter)
        (adapter_assigned_to_patient ?patient_encounter ?adapter_kit)
        (not
          (adapter_attached ?patient_encounter)
        )
      )
    :effect
      (and
        (adapter_attached ?patient_encounter)
      )
  )
  (:action apply_consumable
    :parameters (?patient_encounter - patient_encounter ?consumable_stock_item - consumable_stock_item)
    :precondition
      (and
        (encounter_registered ?patient_encounter)
        (assignment_in_progress ?patient_encounter)
        (consumable_available ?consumable_stock_item)
        (not
          (adapter_attached ?patient_encounter)
        )
      )
    :effect
      (and
        (adapter_attached ?patient_encounter)
        (consumable_staged ?patient_encounter)
        (not
          (consumable_available ?consumable_stock_item)
        )
      )
  )
  (:action therapist_confirm_setup_with_adapter
    :parameters (?patient_encounter - patient_encounter ?adapter_kit - adapter_kit ?respiratory_therapist - respiratory_therapist)
    :precondition
      (and
        (adapter_attached ?patient_encounter)
        (assignment_in_progress ?patient_encounter)
        (adapter_assigned_to_patient ?patient_encounter ?adapter_kit)
        (therapist_available ?respiratory_therapist)
        (not
          (therapy_setup_complete ?patient_encounter)
        )
      )
    :effect
      (and
        (therapy_setup_complete ?patient_encounter)
        (not
          (consumable_staged ?patient_encounter)
        )
      )
  )
  (:action therapist_confirm_setup_with_resource_batch
    :parameters (?patient_encounter - patient_encounter ?resource_batch - resource_batch)
    :precondition
      (and
        (assignment_in_progress ?patient_encounter)
        (resource_allocated ?patient_encounter ?resource_batch)
        (not
          (therapy_setup_complete ?patient_encounter)
        )
      )
    :effect
      (and
        (therapy_setup_complete ?patient_encounter)
        (not
          (consumable_staged ?patient_encounter)
        )
      )
  )
  (:action assign_oxygen_source_to_patient
    :parameters (?patient_encounter - patient_encounter ?oxygen_source_unit - oxygen_source_unit)
    :precondition
      (and
        (encounter_registered ?patient_encounter)
        (source_available ?oxygen_source_unit)
        (patient_source_compatible ?patient_encounter ?oxygen_source_unit)
      )
    :effect
      (and
        (source_assigned ?patient_encounter ?oxygen_source_unit)
        (not
          (source_available ?oxygen_source_unit)
        )
      )
  )
  (:action release_oxygen_source
    :parameters (?patient_encounter - patient_encounter ?oxygen_source_unit - oxygen_source_unit)
    :precondition
      (and
        (source_assigned ?patient_encounter ?oxygen_source_unit)
      )
    :effect
      (and
        (source_available ?oxygen_source_unit)
        (not
          (source_assigned ?patient_encounter ?oxygen_source_unit)
        )
      )
  )
  (:action assign_interface_device_to_patient
    :parameters (?patient_encounter - patient_encounter ?patient_interface_device - patient_interface_device)
    :precondition
      (and
        (encounter_registered ?patient_encounter)
        (device_available ?patient_interface_device)
        (patient_device_compatible ?patient_encounter ?patient_interface_device)
      )
    :effect
      (and
        (device_assigned ?patient_encounter ?patient_interface_device)
        (not
          (device_available ?patient_interface_device)
        )
      )
  )
  (:action release_interface_device
    :parameters (?patient_encounter - patient_encounter ?patient_interface_device - patient_interface_device)
    :precondition
      (and
        (device_assigned ?patient_encounter ?patient_interface_device)
      )
    :effect
      (and
        (device_available ?patient_interface_device)
        (not
          (device_assigned ?patient_encounter ?patient_interface_device)
        )
      )
  )
  (:action assign_high_flow_device_to_patient
    :parameters (?patient_encounter - patient_encounter ?high_flow_device_unit - high_flow_device_unit)
    :precondition
      (and
        (encounter_registered ?patient_encounter)
        (high_flow_available ?high_flow_device_unit)
        (patient_high_flow_compatible ?patient_encounter ?high_flow_device_unit)
      )
    :effect
      (and
        (high_flow_assigned ?patient_encounter ?high_flow_device_unit)
        (not
          (high_flow_available ?high_flow_device_unit)
        )
      )
  )
  (:action release_high_flow_device
    :parameters (?patient_encounter - patient_encounter ?high_flow_device_unit - high_flow_device_unit)
    :precondition
      (and
        (high_flow_assigned ?patient_encounter ?high_flow_device_unit)
      )
    :effect
      (and
        (high_flow_available ?high_flow_device_unit)
        (not
          (high_flow_assigned ?patient_encounter ?high_flow_device_unit)
        )
      )
  )
  (:action assign_monitor_to_patient
    :parameters (?patient_encounter - patient_encounter ?monitoring_device_unit - monitoring_device_unit)
    :precondition
      (and
        (encounter_registered ?patient_encounter)
        (monitoring_available ?monitoring_device_unit)
        (patient_monitoring_compatible ?patient_encounter ?monitoring_device_unit)
      )
    :effect
      (and
        (monitoring_assigned ?patient_encounter ?monitoring_device_unit)
        (not
          (monitoring_available ?monitoring_device_unit)
        )
      )
  )
  (:action release_monitor_from_patient
    :parameters (?patient_encounter - patient_encounter ?monitoring_device_unit - monitoring_device_unit)
    :precondition
      (and
        (monitoring_assigned ?patient_encounter ?monitoring_device_unit)
      )
    :effect
      (and
        (monitoring_available ?monitoring_device_unit)
        (not
          (monitoring_assigned ?patient_encounter ?monitoring_device_unit)
        )
      )
  )
  (:action create_therapy_order_with_source_and_device
    :parameters (?patient_encounter - patient_encounter ?therapy_protocol - therapy_protocol ?oxygen_source_unit - oxygen_source_unit ?patient_interface_device - patient_interface_device)
    :precondition
      (and
        (assignment_in_progress ?patient_encounter)
        (source_assigned ?patient_encounter ?oxygen_source_unit)
        (device_assigned ?patient_encounter ?patient_interface_device)
        (protocol_available ?therapy_protocol)
        (patient_protocol_compatible ?patient_encounter ?therapy_protocol)
        (not
          (order_confirmed ?patient_encounter)
        )
      )
    :effect
      (and
        (therapy_ordered ?patient_encounter ?therapy_protocol)
        (order_confirmed ?patient_encounter)
        (not
          (protocol_available ?therapy_protocol)
        )
      )
  )
  (:action create_therapy_order_with_highflow_and_ancillary
    :parameters (?patient_encounter - patient_encounter ?therapy_protocol - therapy_protocol ?high_flow_device_unit - high_flow_device_unit ?ancillary_module - ancillary_module)
    :precondition
      (and
        (assignment_in_progress ?patient_encounter)
        (high_flow_assigned ?patient_encounter ?high_flow_device_unit)
        (ancillary_available ?ancillary_module)
        (protocol_available ?therapy_protocol)
        (patient_protocol_compatible ?patient_encounter ?therapy_protocol)
        (patient_ancillary_compatible ?patient_encounter ?ancillary_module)
        (not
          (order_confirmed ?patient_encounter)
        )
      )
    :effect
      (and
        (therapy_ordered ?patient_encounter ?therapy_protocol)
        (order_confirmed ?patient_encounter)
        (ancillary_required_flag ?patient_encounter)
        (consumable_staged ?patient_encounter)
        (not
          (protocol_available ?therapy_protocol)
        )
        (not
          (ancillary_available ?ancillary_module)
        )
      )
  )
  (:action finalize_order_staging
    :parameters (?patient_encounter - patient_encounter ?oxygen_source_unit - oxygen_source_unit ?patient_interface_device - patient_interface_device)
    :precondition
      (and
        (order_confirmed ?patient_encounter)
        (ancillary_required_flag ?patient_encounter)
        (source_assigned ?patient_encounter ?oxygen_source_unit)
        (device_assigned ?patient_encounter ?patient_interface_device)
      )
    :effect
      (and
        (not
          (ancillary_required_flag ?patient_encounter)
        )
        (not
          (consumable_staged ?patient_encounter)
        )
      )
  )
  (:action assign_team_and_grant_approval
    :parameters (?patient_encounter - patient_encounter ?oxygen_source_unit - oxygen_source_unit ?patient_interface_device - patient_interface_device ?nursing_team - nursing_team)
    :precondition
      (and
        (therapy_setup_complete ?patient_encounter)
        (order_confirmed ?patient_encounter)
        (source_assigned ?patient_encounter ?oxygen_source_unit)
        (device_assigned ?patient_encounter ?patient_interface_device)
        (team_eligible ?patient_encounter ?nursing_team)
        (not
          (consumable_staged ?patient_encounter)
        )
        (not
          (approval_granted ?patient_encounter)
        )
      )
    :effect
      (and
        (approval_granted ?patient_encounter)
      )
  )
  (:action assign_resp_team_and_grant_approval
    :parameters (?patient_encounter - patient_encounter ?high_flow_device_unit - high_flow_device_unit ?monitoring_device_unit - monitoring_device_unit ?respiratory_team - respiratory_team)
    :precondition
      (and
        (therapy_setup_complete ?patient_encounter)
        (order_confirmed ?patient_encounter)
        (high_flow_assigned ?patient_encounter ?high_flow_device_unit)
        (monitoring_assigned ?patient_encounter ?monitoring_device_unit)
        (team_eligible ?patient_encounter ?respiratory_team)
        (not
          (approval_granted ?patient_encounter)
        )
      )
    :effect
      (and
        (approval_granted ?patient_encounter)
        (consumable_staged ?patient_encounter)
      )
  )
  (:action activate_therapy
    :parameters (?patient_encounter - patient_encounter ?oxygen_source_unit - oxygen_source_unit ?patient_interface_device - patient_interface_device)
    :precondition
      (and
        (approval_granted ?patient_encounter)
        (consumable_staged ?patient_encounter)
        (source_assigned ?patient_encounter ?oxygen_source_unit)
        (device_assigned ?patient_encounter ?patient_interface_device)
      )
    :effect
      (and
        (therapy_active ?patient_encounter)
        (not
          (consumable_staged ?patient_encounter)
        )
        (not
          (therapy_setup_complete ?patient_encounter)
        )
        (not
          (ancillary_required_flag ?patient_encounter)
        )
      )
  )
  (:action therapist_attach_adapter_for_finalization
    :parameters (?patient_encounter - patient_encounter ?adapter_kit - adapter_kit ?respiratory_therapist - respiratory_therapist)
    :precondition
      (and
        (therapy_active ?patient_encounter)
        (approval_granted ?patient_encounter)
        (assignment_in_progress ?patient_encounter)
        (adapter_assigned_to_patient ?patient_encounter ?adapter_kit)
        (therapist_available ?respiratory_therapist)
        (not
          (therapy_setup_complete ?patient_encounter)
        )
      )
    :effect
      (and
        (therapy_setup_complete ?patient_encounter)
      )
  )
  (:action complete_adapter_qc_check
    :parameters (?patient_encounter - patient_encounter ?adapter_kit - adapter_kit)
    :precondition
      (and
        (approval_granted ?patient_encounter)
        (therapy_setup_complete ?patient_encounter)
        (not
          (consumable_staged ?patient_encounter)
        )
        (adapter_assigned_to_patient ?patient_encounter ?adapter_kit)
        (not
          (safety_check_completed ?patient_encounter)
        )
      )
    :effect
      (and
        (safety_check_completed ?patient_encounter)
      )
  )
  (:action complete_consumable_qc_check
    :parameters (?patient_encounter - patient_encounter ?consumable_stock_item - consumable_stock_item)
    :precondition
      (and
        (approval_granted ?patient_encounter)
        (therapy_setup_complete ?patient_encounter)
        (not
          (consumable_staged ?patient_encounter)
        )
        (consumable_available ?consumable_stock_item)
        (not
          (safety_check_completed ?patient_encounter)
        )
      )
    :effect
      (and
        (safety_check_completed ?patient_encounter)
        (not
          (consumable_available ?consumable_stock_item)
        )
      )
  )
  (:action bind_resource_batch_to_patient
    :parameters (?patient_encounter - patient_encounter ?resource_batch - resource_batch)
    :precondition
      (and
        (safety_check_completed ?patient_encounter)
        (resource_batch_available ?resource_batch)
        (patient_resource_binding_possible ?patient_encounter ?resource_batch)
      )
    :effect
      (and
        (patient_resource_compatible ?patient_encounter ?resource_batch)
        (not
          (resource_batch_available ?resource_batch)
        )
      )
  )
  (:action linked_adult_patient
    :parameters (?patient_pediatric - patient_pediatric ?patient_adult - patient_adult ?resource_batch - resource_batch)
    :precondition
      (and
        (encounter_registered ?patient_pediatric)
        (special_population_flag ?patient_pediatric)
        (cohort_resource_link ?patient_pediatric ?resource_batch)
        (patient_resource_compatible ?patient_adult ?resource_batch)
        (not
          (resource_allocated ?patient_pediatric ?resource_batch)
        )
      )
    :effect
      (and
        (resource_allocated ?patient_pediatric ?resource_batch)
      )
  )
  (:action activate_monitoring_workflow
    :parameters (?patient_encounter - patient_encounter ?adapter_kit - adapter_kit ?respiratory_therapist - respiratory_therapist)
    :precondition
      (and
        (encounter_registered ?patient_encounter)
        (special_population_flag ?patient_encounter)
        (therapy_setup_complete ?patient_encounter)
        (safety_check_completed ?patient_encounter)
        (adapter_assigned_to_patient ?patient_encounter ?adapter_kit)
        (therapist_available ?respiratory_therapist)
        (not
          (monitoring_activated ?patient_encounter)
        )
      )
    :effect
      (and
        (monitoring_activated ?patient_encounter)
      )
  )
  (:action finalize_encounter_standard
    :parameters (?patient_encounter - patient_encounter)
    :precondition
      (and
        (stabilized_flag ?patient_encounter)
        (encounter_registered ?patient_encounter)
        (assignment_in_progress ?patient_encounter)
        (order_confirmed ?patient_encounter)
        (approval_granted ?patient_encounter)
        (safety_check_completed ?patient_encounter)
        (therapy_setup_complete ?patient_encounter)
        (not
          (encounter_finalized ?patient_encounter)
        )
      )
    :effect
      (and
        (encounter_finalized ?patient_encounter)
      )
  )
  (:action finalize_encounter_with_resource_batch
    :parameters (?patient_encounter - patient_encounter ?resource_batch - resource_batch)
    :precondition
      (and
        (special_population_flag ?patient_encounter)
        (encounter_registered ?patient_encounter)
        (assignment_in_progress ?patient_encounter)
        (order_confirmed ?patient_encounter)
        (approval_granted ?patient_encounter)
        (safety_check_completed ?patient_encounter)
        (therapy_setup_complete ?patient_encounter)
        (resource_allocated ?patient_encounter ?resource_batch)
        (not
          (encounter_finalized ?patient_encounter)
        )
      )
    :effect
      (and
        (encounter_finalized ?patient_encounter)
      )
  )
  (:action finalize_encounter_with_monitoring
    :parameters (?patient_encounter - patient_encounter)
    :precondition
      (and
        (special_population_flag ?patient_encounter)
        (encounter_registered ?patient_encounter)
        (assignment_in_progress ?patient_encounter)
        (order_confirmed ?patient_encounter)
        (approval_granted ?patient_encounter)
        (safety_check_completed ?patient_encounter)
        (therapy_setup_complete ?patient_encounter)
        (monitoring_activated ?patient_encounter)
        (not
          (encounter_finalized ?patient_encounter)
        )
      )
    :effect
      (and
        (encounter_finalized ?patient_encounter)
      )
  )
)

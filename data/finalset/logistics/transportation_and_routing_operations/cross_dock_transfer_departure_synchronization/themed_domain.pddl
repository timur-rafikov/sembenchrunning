(define (domain cross_dock_transfer_departure_synchronization)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_group - object equipment_group - object slot_group - object shipment_group - object shipment - shipment_group transport_asset - resource_group time_slot - resource_group dock_bay - resource_group clearance - resource_group cargo_profile - resource_group routing_document - resource_group equipment_team - resource_group security_pass - resource_group unit_load - equipment_group handling_equipment - equipment_group carrier_authorization - equipment_group inbound_slot - slot_group outbound_slot - slot_group departure_batch - slot_group inbound_group - shipment outbound_group - shipment inbound_movement - inbound_group outbound_movement - inbound_group transfer_job - outbound_group)
  (:predicates
    (entity_registered ?shipment - shipment)
    (entity_confirmed ?shipment - shipment)
    (entity_assignment_flag ?shipment - shipment)
    (dispatch_assigned ?shipment - shipment)
    (dispatch_ready ?shipment - shipment)
    (dispatch_initiated ?shipment - shipment)
    (asset_available ?transport_asset - transport_asset)
    (entity_assigned_to_asset ?shipment - shipment ?transport_asset - transport_asset)
    (time_slot_available ?time_slot - time_slot)
    (entity_time_slot_assigned ?shipment - shipment ?time_slot - time_slot)
    (dock_available ?dock_bay - dock_bay)
    (entity_assigned_dock ?shipment - shipment ?dock_bay - dock_bay)
    (unit_load_available ?unit_load - unit_load)
    (inbound_unit_load_assigned ?inbound_movement - inbound_movement ?unit_load - unit_load)
    (outbound_unit_load_assigned ?outbound_movement - outbound_movement ?unit_load - unit_load)
    (inbound_movement_assigned_inbound_slot ?inbound_movement - inbound_movement ?inbound_slot - inbound_slot)
    (inbound_slot_ready ?inbound_slot - inbound_slot)
    (inbound_slot_occupied ?inbound_slot - inbound_slot)
    (inbound_movement_staged ?inbound_movement - inbound_movement)
    (outbound_movement_assigned_outbound_slot ?outbound_movement - outbound_movement ?outbound_slot - outbound_slot)
    (outbound_slot_ready ?outbound_slot - outbound_slot)
    (outbound_slot_occupied ?outbound_slot - outbound_slot)
    (outbound_movement_staged ?outbound_movement - outbound_movement)
    (departure_batch_available ?departure_batch - departure_batch)
    (departure_batch_reserved ?departure_batch - departure_batch)
    (departure_batch_inbound_slot_link ?departure_batch - departure_batch ?inbound_slot - inbound_slot)
    (departure_batch_outbound_slot_link ?departure_batch - departure_batch ?outbound_slot - outbound_slot)
    (departure_batch_inbound_loads_attached ?departure_batch - departure_batch)
    (departure_batch_outbound_loads_attached ?departure_batch - departure_batch)
    (departure_batch_validated ?departure_batch - departure_batch)
    (transfer_job_assigned_inbound_movement ?transfer_job - transfer_job ?inbound_movement - inbound_movement)
    (transfer_job_assigned_outbound_movement ?transfer_job - transfer_job ?outbound_movement - outbound_movement)
    (transfer_job_part_of_departure_batch ?transfer_job - transfer_job ?departure_batch - departure_batch)
    (equipment_available ?handling_equipment - handling_equipment)
    (transfer_job_assigned_equipment ?transfer_job - transfer_job ?handling_equipment - handling_equipment)
    (equipment_reserved ?handling_equipment - handling_equipment)
    (equipment_assigned_to_batch ?handling_equipment - handling_equipment ?departure_batch - departure_batch)
    (transfer_job_ready_for_handling ?transfer_job - transfer_job)
    (transfer_job_handled ?transfer_job - transfer_job)
    (transfer_job_checks_completed ?transfer_job - transfer_job)
    (transfer_job_has_clearance ?transfer_job - transfer_job)
    (transfer_job_stage_two_ready ?transfer_job - transfer_job)
    (transfer_job_profile_required ?transfer_job - transfer_job)
    (transfer_job_handling_complete ?transfer_job - transfer_job)
    (carrier_authorization_available ?carrier_authorization - carrier_authorization)
    (transfer_job_has_carrier_authorization ?transfer_job - transfer_job ?carrier_authorization - carrier_authorization)
    (transfer_job_carrier_authorized ?transfer_job - transfer_job)
    (transfer_job_inspection_ready ?transfer_job - transfer_job)
    (transfer_job_inspection_completed ?transfer_job - transfer_job)
    (clearance_available ?clearance - clearance)
    (transfer_job_assigned_clearance ?transfer_job - transfer_job ?clearance - clearance)
    (cargo_profile_available ?cargo_profile - cargo_profile)
    (transfer_job_assigned_cargo_profile ?transfer_job - transfer_job ?cargo_profile - cargo_profile)
    (equipment_team_available ?equipment_team - equipment_team)
    (transfer_job_assigned_team ?transfer_job - transfer_job ?equipment_team - equipment_team)
    (security_pass_available ?security_pass - security_pass)
    (transfer_job_security_pass_assigned ?transfer_job - transfer_job ?security_pass - security_pass)
    (routing_document_available ?routing_document - routing_document)
    (entity_has_routing_document ?shipment - shipment ?routing_document - routing_document)
    (inbound_movement_ready ?inbound_movement - inbound_movement)
    (outbound_movement_ready ?outbound_movement - outbound_movement)
    (transfer_job_dispatch_confirmed ?transfer_job - transfer_job)
  )
  (:action register_shipment
    :parameters (?shipment - shipment)
    :precondition
      (and
        (not
          (entity_registered ?shipment)
        )
        (not
          (dispatch_assigned ?shipment)
        )
      )
    :effect (entity_registered ?shipment)
  )
  (:action assign_asset_to_shipment
    :parameters (?shipment - shipment ?transport_asset - transport_asset)
    :precondition
      (and
        (entity_registered ?shipment)
        (not
          (entity_assignment_flag ?shipment)
        )
        (asset_available ?transport_asset)
      )
    :effect
      (and
        (entity_assignment_flag ?shipment)
        (entity_assigned_to_asset ?shipment ?transport_asset)
        (not
          (asset_available ?transport_asset)
        )
      )
  )
  (:action assign_time_slot_to_shipment
    :parameters (?shipment - shipment ?time_slot - time_slot)
    :precondition
      (and
        (entity_registered ?shipment)
        (entity_assignment_flag ?shipment)
        (time_slot_available ?time_slot)
      )
    :effect
      (and
        (entity_time_slot_assigned ?shipment ?time_slot)
        (not
          (time_slot_available ?time_slot)
        )
      )
  )
  (:action confirm_shipment_schedule
    :parameters (?shipment - shipment ?time_slot - time_slot)
    :precondition
      (and
        (entity_registered ?shipment)
        (entity_assignment_flag ?shipment)
        (entity_time_slot_assigned ?shipment ?time_slot)
        (not
          (entity_confirmed ?shipment)
        )
      )
    :effect (entity_confirmed ?shipment)
  )
  (:action release_shipment_time_slot
    :parameters (?shipment - shipment ?time_slot - time_slot)
    :precondition
      (and
        (entity_time_slot_assigned ?shipment ?time_slot)
      )
    :effect
      (and
        (time_slot_available ?time_slot)
        (not
          (entity_time_slot_assigned ?shipment ?time_slot)
        )
      )
  )
  (:action assign_dock_to_shipment
    :parameters (?shipment - shipment ?dock_bay - dock_bay)
    :precondition
      (and
        (entity_confirmed ?shipment)
        (dock_available ?dock_bay)
      )
    :effect
      (and
        (entity_assigned_dock ?shipment ?dock_bay)
        (not
          (dock_available ?dock_bay)
        )
      )
  )
  (:action release_dock_from_shipment
    :parameters (?shipment - shipment ?dock_bay - dock_bay)
    :precondition
      (and
        (entity_assigned_dock ?shipment ?dock_bay)
      )
    :effect
      (and
        (dock_available ?dock_bay)
        (not
          (entity_assigned_dock ?shipment ?dock_bay)
        )
      )
  )
  (:action allocate_equipment_team_to_transfer_job
    :parameters (?transfer_job - transfer_job ?equipment_team - equipment_team)
    :precondition
      (and
        (entity_confirmed ?transfer_job)
        (equipment_team_available ?equipment_team)
      )
    :effect
      (and
        (transfer_job_assigned_team ?transfer_job ?equipment_team)
        (not
          (equipment_team_available ?equipment_team)
        )
      )
  )
  (:action release_equipment_team_from_transfer_job
    :parameters (?transfer_job - transfer_job ?equipment_team - equipment_team)
    :precondition
      (and
        (transfer_job_assigned_team ?transfer_job ?equipment_team)
      )
    :effect
      (and
        (equipment_team_available ?equipment_team)
        (not
          (transfer_job_assigned_team ?transfer_job ?equipment_team)
        )
      )
  )
  (:action assign_security_pass_to_transfer_job
    :parameters (?transfer_job - transfer_job ?security_pass - security_pass)
    :precondition
      (and
        (entity_confirmed ?transfer_job)
        (security_pass_available ?security_pass)
      )
    :effect
      (and
        (transfer_job_security_pass_assigned ?transfer_job ?security_pass)
        (not
          (security_pass_available ?security_pass)
        )
      )
  )
  (:action release_security_pass_from_transfer_job
    :parameters (?transfer_job - transfer_job ?security_pass - security_pass)
    :precondition
      (and
        (transfer_job_security_pass_assigned ?transfer_job ?security_pass)
      )
    :effect
      (and
        (security_pass_available ?security_pass)
        (not
          (transfer_job_security_pass_assigned ?transfer_job ?security_pass)
        )
      )
  )
  (:action mark_inbound_slot_ready
    :parameters (?inbound_movement - inbound_movement ?inbound_slot - inbound_slot ?time_slot - time_slot)
    :precondition
      (and
        (entity_confirmed ?inbound_movement)
        (entity_time_slot_assigned ?inbound_movement ?time_slot)
        (inbound_movement_assigned_inbound_slot ?inbound_movement ?inbound_slot)
        (not
          (inbound_slot_ready ?inbound_slot)
        )
        (not
          (inbound_slot_occupied ?inbound_slot)
        )
      )
    :effect (inbound_slot_ready ?inbound_slot)
  )
  (:action stage_inbound_movement
    :parameters (?inbound_movement - inbound_movement ?inbound_slot - inbound_slot ?dock_bay - dock_bay)
    :precondition
      (and
        (entity_confirmed ?inbound_movement)
        (entity_assigned_dock ?inbound_movement ?dock_bay)
        (inbound_movement_assigned_inbound_slot ?inbound_movement ?inbound_slot)
        (inbound_slot_ready ?inbound_slot)
        (not
          (inbound_movement_ready ?inbound_movement)
        )
      )
    :effect
      (and
        (inbound_movement_ready ?inbound_movement)
        (inbound_movement_staged ?inbound_movement)
      )
  )
  (:action stage_unit_load_on_inbound_slot
    :parameters (?inbound_movement - inbound_movement ?inbound_slot - inbound_slot ?unit_load - unit_load)
    :precondition
      (and
        (entity_confirmed ?inbound_movement)
        (inbound_movement_assigned_inbound_slot ?inbound_movement ?inbound_slot)
        (unit_load_available ?unit_load)
        (not
          (inbound_movement_ready ?inbound_movement)
        )
      )
    :effect
      (and
        (inbound_slot_occupied ?inbound_slot)
        (inbound_movement_ready ?inbound_movement)
        (inbound_unit_load_assigned ?inbound_movement ?unit_load)
        (not
          (unit_load_available ?unit_load)
        )
      )
  )
  (:action finalize_inbound_staging
    :parameters (?inbound_movement - inbound_movement ?inbound_slot - inbound_slot ?time_slot - time_slot ?unit_load - unit_load)
    :precondition
      (and
        (entity_confirmed ?inbound_movement)
        (entity_time_slot_assigned ?inbound_movement ?time_slot)
        (inbound_movement_assigned_inbound_slot ?inbound_movement ?inbound_slot)
        (inbound_slot_occupied ?inbound_slot)
        (inbound_unit_load_assigned ?inbound_movement ?unit_load)
        (not
          (inbound_movement_staged ?inbound_movement)
        )
      )
    :effect
      (and
        (inbound_slot_ready ?inbound_slot)
        (inbound_movement_staged ?inbound_movement)
        (unit_load_available ?unit_load)
        (not
          (inbound_unit_load_assigned ?inbound_movement ?unit_load)
        )
      )
  )
  (:action mark_outbound_slot_ready
    :parameters (?outbound_movement - outbound_movement ?outbound_slot - outbound_slot ?time_slot - time_slot)
    :precondition
      (and
        (entity_confirmed ?outbound_movement)
        (entity_time_slot_assigned ?outbound_movement ?time_slot)
        (outbound_movement_assigned_outbound_slot ?outbound_movement ?outbound_slot)
        (not
          (outbound_slot_ready ?outbound_slot)
        )
        (not
          (outbound_slot_occupied ?outbound_slot)
        )
      )
    :effect (outbound_slot_ready ?outbound_slot)
  )
  (:action stage_outbound_movement
    :parameters (?outbound_movement - outbound_movement ?outbound_slot - outbound_slot ?dock_bay - dock_bay)
    :precondition
      (and
        (entity_confirmed ?outbound_movement)
        (entity_assigned_dock ?outbound_movement ?dock_bay)
        (outbound_movement_assigned_outbound_slot ?outbound_movement ?outbound_slot)
        (outbound_slot_ready ?outbound_slot)
        (not
          (outbound_movement_ready ?outbound_movement)
        )
      )
    :effect
      (and
        (outbound_movement_ready ?outbound_movement)
        (outbound_movement_staged ?outbound_movement)
      )
  )
  (:action stage_unit_load_on_outbound_slot
    :parameters (?outbound_movement - outbound_movement ?outbound_slot - outbound_slot ?unit_load - unit_load)
    :precondition
      (and
        (entity_confirmed ?outbound_movement)
        (outbound_movement_assigned_outbound_slot ?outbound_movement ?outbound_slot)
        (unit_load_available ?unit_load)
        (not
          (outbound_movement_ready ?outbound_movement)
        )
      )
    :effect
      (and
        (outbound_slot_occupied ?outbound_slot)
        (outbound_movement_ready ?outbound_movement)
        (outbound_unit_load_assigned ?outbound_movement ?unit_load)
        (not
          (unit_load_available ?unit_load)
        )
      )
  )
  (:action finalize_outbound_staging
    :parameters (?outbound_movement - outbound_movement ?outbound_slot - outbound_slot ?time_slot - time_slot ?unit_load - unit_load)
    :precondition
      (and
        (entity_confirmed ?outbound_movement)
        (entity_time_slot_assigned ?outbound_movement ?time_slot)
        (outbound_movement_assigned_outbound_slot ?outbound_movement ?outbound_slot)
        (outbound_slot_occupied ?outbound_slot)
        (outbound_unit_load_assigned ?outbound_movement ?unit_load)
        (not
          (outbound_movement_staged ?outbound_movement)
        )
      )
    :effect
      (and
        (outbound_slot_ready ?outbound_slot)
        (outbound_movement_staged ?outbound_movement)
        (unit_load_available ?unit_load)
        (not
          (outbound_unit_load_assigned ?outbound_movement ?unit_load)
        )
      )
  )
  (:action create_departure_batch
    :parameters (?inbound_movement - inbound_movement ?outbound_movement - outbound_movement ?inbound_slot - inbound_slot ?outbound_slot - outbound_slot ?departure_batch - departure_batch)
    :precondition
      (and
        (inbound_movement_ready ?inbound_movement)
        (outbound_movement_ready ?outbound_movement)
        (inbound_movement_assigned_inbound_slot ?inbound_movement ?inbound_slot)
        (outbound_movement_assigned_outbound_slot ?outbound_movement ?outbound_slot)
        (inbound_slot_ready ?inbound_slot)
        (outbound_slot_ready ?outbound_slot)
        (inbound_movement_staged ?inbound_movement)
        (outbound_movement_staged ?outbound_movement)
        (departure_batch_available ?departure_batch)
      )
    :effect
      (and
        (departure_batch_reserved ?departure_batch)
        (departure_batch_inbound_slot_link ?departure_batch ?inbound_slot)
        (departure_batch_outbound_slot_link ?departure_batch ?outbound_slot)
        (not
          (departure_batch_available ?departure_batch)
        )
      )
  )
  (:action create_departure_batch_with_inbound_marker
    :parameters (?inbound_movement - inbound_movement ?outbound_movement - outbound_movement ?inbound_slot - inbound_slot ?outbound_slot - outbound_slot ?departure_batch - departure_batch)
    :precondition
      (and
        (inbound_movement_ready ?inbound_movement)
        (outbound_movement_ready ?outbound_movement)
        (inbound_movement_assigned_inbound_slot ?inbound_movement ?inbound_slot)
        (outbound_movement_assigned_outbound_slot ?outbound_movement ?outbound_slot)
        (inbound_slot_occupied ?inbound_slot)
        (outbound_slot_ready ?outbound_slot)
        (not
          (inbound_movement_staged ?inbound_movement)
        )
        (outbound_movement_staged ?outbound_movement)
        (departure_batch_available ?departure_batch)
      )
    :effect
      (and
        (departure_batch_reserved ?departure_batch)
        (departure_batch_inbound_slot_link ?departure_batch ?inbound_slot)
        (departure_batch_outbound_slot_link ?departure_batch ?outbound_slot)
        (departure_batch_inbound_loads_attached ?departure_batch)
        (not
          (departure_batch_available ?departure_batch)
        )
      )
  )
  (:action create_departure_batch_with_outbound_marker
    :parameters (?inbound_movement - inbound_movement ?outbound_movement - outbound_movement ?inbound_slot - inbound_slot ?outbound_slot - outbound_slot ?departure_batch - departure_batch)
    :precondition
      (and
        (inbound_movement_ready ?inbound_movement)
        (outbound_movement_ready ?outbound_movement)
        (inbound_movement_assigned_inbound_slot ?inbound_movement ?inbound_slot)
        (outbound_movement_assigned_outbound_slot ?outbound_movement ?outbound_slot)
        (inbound_slot_ready ?inbound_slot)
        (outbound_slot_occupied ?outbound_slot)
        (inbound_movement_staged ?inbound_movement)
        (not
          (outbound_movement_staged ?outbound_movement)
        )
        (departure_batch_available ?departure_batch)
      )
    :effect
      (and
        (departure_batch_reserved ?departure_batch)
        (departure_batch_inbound_slot_link ?departure_batch ?inbound_slot)
        (departure_batch_outbound_slot_link ?departure_batch ?outbound_slot)
        (departure_batch_outbound_loads_attached ?departure_batch)
        (not
          (departure_batch_available ?departure_batch)
        )
      )
  )
  (:action create_departure_batch_with_both_markers
    :parameters (?inbound_movement - inbound_movement ?outbound_movement - outbound_movement ?inbound_slot - inbound_slot ?outbound_slot - outbound_slot ?departure_batch - departure_batch)
    :precondition
      (and
        (inbound_movement_ready ?inbound_movement)
        (outbound_movement_ready ?outbound_movement)
        (inbound_movement_assigned_inbound_slot ?inbound_movement ?inbound_slot)
        (outbound_movement_assigned_outbound_slot ?outbound_movement ?outbound_slot)
        (inbound_slot_occupied ?inbound_slot)
        (outbound_slot_occupied ?outbound_slot)
        (not
          (inbound_movement_staged ?inbound_movement)
        )
        (not
          (outbound_movement_staged ?outbound_movement)
        )
        (departure_batch_available ?departure_batch)
      )
    :effect
      (and
        (departure_batch_reserved ?departure_batch)
        (departure_batch_inbound_slot_link ?departure_batch ?inbound_slot)
        (departure_batch_outbound_slot_link ?departure_batch ?outbound_slot)
        (departure_batch_inbound_loads_attached ?departure_batch)
        (departure_batch_outbound_loads_attached ?departure_batch)
        (not
          (departure_batch_available ?departure_batch)
        )
      )
  )
  (:action validate_and_activate_departure_batch
    :parameters (?departure_batch - departure_batch ?inbound_movement - inbound_movement ?time_slot - time_slot)
    :precondition
      (and
        (departure_batch_reserved ?departure_batch)
        (inbound_movement_ready ?inbound_movement)
        (entity_time_slot_assigned ?inbound_movement ?time_slot)
        (not
          (departure_batch_validated ?departure_batch)
        )
      )
    :effect (departure_batch_validated ?departure_batch)
  )
  (:action allocate_handling_equipment_to_transfer_job
    :parameters (?transfer_job - transfer_job ?handling_equipment - handling_equipment ?departure_batch - departure_batch)
    :precondition
      (and
        (entity_confirmed ?transfer_job)
        (transfer_job_part_of_departure_batch ?transfer_job ?departure_batch)
        (transfer_job_assigned_equipment ?transfer_job ?handling_equipment)
        (equipment_available ?handling_equipment)
        (departure_batch_reserved ?departure_batch)
        (departure_batch_validated ?departure_batch)
        (not
          (equipment_reserved ?handling_equipment)
        )
      )
    :effect
      (and
        (equipment_reserved ?handling_equipment)
        (equipment_assigned_to_batch ?handling_equipment ?departure_batch)
        (not
          (equipment_available ?handling_equipment)
        )
      )
  )
  (:action claim_transfer_job_for_handling
    :parameters (?transfer_job - transfer_job ?handling_equipment - handling_equipment ?departure_batch - departure_batch ?time_slot - time_slot)
    :precondition
      (and
        (entity_confirmed ?transfer_job)
        (transfer_job_assigned_equipment ?transfer_job ?handling_equipment)
        (equipment_reserved ?handling_equipment)
        (equipment_assigned_to_batch ?handling_equipment ?departure_batch)
        (entity_time_slot_assigned ?transfer_job ?time_slot)
        (not
          (departure_batch_inbound_loads_attached ?departure_batch)
        )
        (not
          (transfer_job_ready_for_handling ?transfer_job)
        )
      )
    :effect (transfer_job_ready_for_handling ?transfer_job)
  )
  (:action assign_clearance_to_transfer_job
    :parameters (?transfer_job - transfer_job ?clearance - clearance)
    :precondition
      (and
        (entity_confirmed ?transfer_job)
        (clearance_available ?clearance)
        (not
          (transfer_job_has_clearance ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_has_clearance ?transfer_job)
        (transfer_job_assigned_clearance ?transfer_job ?clearance)
        (not
          (clearance_available ?clearance)
        )
      )
  )
  (:action advance_transfer_job_with_clearance
    :parameters (?transfer_job - transfer_job ?handling_equipment - handling_equipment ?departure_batch - departure_batch ?time_slot - time_slot ?clearance - clearance)
    :precondition
      (and
        (entity_confirmed ?transfer_job)
        (transfer_job_assigned_equipment ?transfer_job ?handling_equipment)
        (equipment_reserved ?handling_equipment)
        (equipment_assigned_to_batch ?handling_equipment ?departure_batch)
        (entity_time_slot_assigned ?transfer_job ?time_slot)
        (departure_batch_inbound_loads_attached ?departure_batch)
        (transfer_job_has_clearance ?transfer_job)
        (transfer_job_assigned_clearance ?transfer_job ?clearance)
        (not
          (transfer_job_ready_for_handling ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_ready_for_handling ?transfer_job)
        (transfer_job_stage_two_ready ?transfer_job)
      )
  )
  (:action execute_transfer_job_handling_by_team
    :parameters (?transfer_job - transfer_job ?equipment_team - equipment_team ?dock_bay - dock_bay ?handling_equipment - handling_equipment ?departure_batch - departure_batch)
    :precondition
      (and
        (transfer_job_ready_for_handling ?transfer_job)
        (transfer_job_assigned_team ?transfer_job ?equipment_team)
        (entity_assigned_dock ?transfer_job ?dock_bay)
        (transfer_job_assigned_equipment ?transfer_job ?handling_equipment)
        (equipment_assigned_to_batch ?handling_equipment ?departure_batch)
        (not
          (departure_batch_outbound_loads_attached ?departure_batch)
        )
        (not
          (transfer_job_handled ?transfer_job)
        )
      )
    :effect (transfer_job_handled ?transfer_job)
  )
  (:action execute_transfer_job_handling_by_team_confirmed
    :parameters (?transfer_job - transfer_job ?equipment_team - equipment_team ?dock_bay - dock_bay ?handling_equipment - handling_equipment ?departure_batch - departure_batch)
    :precondition
      (and
        (transfer_job_ready_for_handling ?transfer_job)
        (transfer_job_assigned_team ?transfer_job ?equipment_team)
        (entity_assigned_dock ?transfer_job ?dock_bay)
        (transfer_job_assigned_equipment ?transfer_job ?handling_equipment)
        (equipment_assigned_to_batch ?handling_equipment ?departure_batch)
        (departure_batch_outbound_loads_attached ?departure_batch)
        (not
          (transfer_job_handled ?transfer_job)
        )
      )
    :effect (transfer_job_handled ?transfer_job)
  )
  (:action run_security_checks_standard
    :parameters (?transfer_job - transfer_job ?security_pass - security_pass ?handling_equipment - handling_equipment ?departure_batch - departure_batch)
    :precondition
      (and
        (transfer_job_handled ?transfer_job)
        (transfer_job_security_pass_assigned ?transfer_job ?security_pass)
        (transfer_job_assigned_equipment ?transfer_job ?handling_equipment)
        (equipment_assigned_to_batch ?handling_equipment ?departure_batch)
        (not
          (departure_batch_inbound_loads_attached ?departure_batch)
        )
        (not
          (departure_batch_outbound_loads_attached ?departure_batch)
        )
        (not
          (transfer_job_checks_completed ?transfer_job)
        )
      )
    :effect (transfer_job_checks_completed ?transfer_job)
  )
  (:action run_security_checks_with_inbound_marker
    :parameters (?transfer_job - transfer_job ?security_pass - security_pass ?handling_equipment - handling_equipment ?departure_batch - departure_batch)
    :precondition
      (and
        (transfer_job_handled ?transfer_job)
        (transfer_job_security_pass_assigned ?transfer_job ?security_pass)
        (transfer_job_assigned_equipment ?transfer_job ?handling_equipment)
        (equipment_assigned_to_batch ?handling_equipment ?departure_batch)
        (departure_batch_inbound_loads_attached ?departure_batch)
        (not
          (departure_batch_outbound_loads_attached ?departure_batch)
        )
        (not
          (transfer_job_checks_completed ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_checks_completed ?transfer_job)
        (transfer_job_profile_required ?transfer_job)
      )
  )
  (:action run_security_checks_with_outbound_marker
    :parameters (?transfer_job - transfer_job ?security_pass - security_pass ?handling_equipment - handling_equipment ?departure_batch - departure_batch)
    :precondition
      (and
        (transfer_job_handled ?transfer_job)
        (transfer_job_security_pass_assigned ?transfer_job ?security_pass)
        (transfer_job_assigned_equipment ?transfer_job ?handling_equipment)
        (equipment_assigned_to_batch ?handling_equipment ?departure_batch)
        (not
          (departure_batch_inbound_loads_attached ?departure_batch)
        )
        (departure_batch_outbound_loads_attached ?departure_batch)
        (not
          (transfer_job_checks_completed ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_checks_completed ?transfer_job)
        (transfer_job_profile_required ?transfer_job)
      )
  )
  (:action run_security_checks_with_both_markers
    :parameters (?transfer_job - transfer_job ?security_pass - security_pass ?handling_equipment - handling_equipment ?departure_batch - departure_batch)
    :precondition
      (and
        (transfer_job_handled ?transfer_job)
        (transfer_job_security_pass_assigned ?transfer_job ?security_pass)
        (transfer_job_assigned_equipment ?transfer_job ?handling_equipment)
        (equipment_assigned_to_batch ?handling_equipment ?departure_batch)
        (departure_batch_inbound_loads_attached ?departure_batch)
        (departure_batch_outbound_loads_attached ?departure_batch)
        (not
          (transfer_job_checks_completed ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_checks_completed ?transfer_job)
        (transfer_job_profile_required ?transfer_job)
      )
  )
  (:action confirm_transfer_job_for_dispatch
    :parameters (?transfer_job - transfer_job)
    :precondition
      (and
        (transfer_job_checks_completed ?transfer_job)
        (not
          (transfer_job_profile_required ?transfer_job)
        )
        (not
          (transfer_job_dispatch_confirmed ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_dispatch_confirmed ?transfer_job)
        (dispatch_ready ?transfer_job)
      )
  )
  (:action assign_cargo_profile_to_transfer_job
    :parameters (?transfer_job - transfer_job ?cargo_profile - cargo_profile)
    :precondition
      (and
        (transfer_job_checks_completed ?transfer_job)
        (transfer_job_profile_required ?transfer_job)
        (cargo_profile_available ?cargo_profile)
      )
    :effect
      (and
        (transfer_job_assigned_cargo_profile ?transfer_job ?cargo_profile)
        (not
          (cargo_profile_available ?cargo_profile)
        )
      )
  )
  (:action start_transfer_job_handling
    :parameters (?transfer_job - transfer_job ?inbound_movement - inbound_movement ?outbound_movement - outbound_movement ?time_slot - time_slot ?cargo_profile - cargo_profile)
    :precondition
      (and
        (transfer_job_checks_completed ?transfer_job)
        (transfer_job_profile_required ?transfer_job)
        (transfer_job_assigned_cargo_profile ?transfer_job ?cargo_profile)
        (transfer_job_assigned_inbound_movement ?transfer_job ?inbound_movement)
        (transfer_job_assigned_outbound_movement ?transfer_job ?outbound_movement)
        (inbound_movement_staged ?inbound_movement)
        (outbound_movement_staged ?outbound_movement)
        (entity_time_slot_assigned ?transfer_job ?time_slot)
        (not
          (transfer_job_handling_complete ?transfer_job)
        )
      )
    :effect (transfer_job_handling_complete ?transfer_job)
  )
  (:action finalize_transfer_job_and_mark_dispatch_ready
    :parameters (?transfer_job - transfer_job)
    :precondition
      (and
        (transfer_job_checks_completed ?transfer_job)
        (transfer_job_handling_complete ?transfer_job)
        (not
          (transfer_job_dispatch_confirmed ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_dispatch_confirmed ?transfer_job)
        (dispatch_ready ?transfer_job)
      )
  )
  (:action assign_carrier_authorization_to_transfer_job
    :parameters (?transfer_job - transfer_job ?carrier_authorization - carrier_authorization ?time_slot - time_slot)
    :precondition
      (and
        (entity_confirmed ?transfer_job)
        (entity_time_slot_assigned ?transfer_job ?time_slot)
        (carrier_authorization_available ?carrier_authorization)
        (transfer_job_has_carrier_authorization ?transfer_job ?carrier_authorization)
        (not
          (transfer_job_carrier_authorized ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_carrier_authorized ?transfer_job)
        (not
          (carrier_authorization_available ?carrier_authorization)
        )
      )
  )
  (:action mark_transfer_job_inspection_ready
    :parameters (?transfer_job - transfer_job ?dock_bay - dock_bay)
    :precondition
      (and
        (transfer_job_carrier_authorized ?transfer_job)
        (entity_assigned_dock ?transfer_job ?dock_bay)
        (not
          (transfer_job_inspection_ready ?transfer_job)
        )
      )
    :effect (transfer_job_inspection_ready ?transfer_job)
  )
  (:action perform_transfer_job_inspection
    :parameters (?transfer_job - transfer_job ?security_pass - security_pass)
    :precondition
      (and
        (transfer_job_inspection_ready ?transfer_job)
        (transfer_job_security_pass_assigned ?transfer_job ?security_pass)
        (not
          (transfer_job_inspection_completed ?transfer_job)
        )
      )
    :effect (transfer_job_inspection_completed ?transfer_job)
  )
  (:action complete_inspection_and_mark_dispatch_ready
    :parameters (?transfer_job - transfer_job)
    :precondition
      (and
        (transfer_job_inspection_completed ?transfer_job)
        (not
          (transfer_job_dispatch_confirmed ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_dispatch_confirmed ?transfer_job)
        (dispatch_ready ?transfer_job)
      )
  )
  (:action trigger_dispatch_for_inbound_movement
    :parameters (?inbound_movement - inbound_movement ?departure_batch - departure_batch)
    :precondition
      (and
        (inbound_movement_ready ?inbound_movement)
        (inbound_movement_staged ?inbound_movement)
        (departure_batch_reserved ?departure_batch)
        (departure_batch_validated ?departure_batch)
        (not
          (dispatch_ready ?inbound_movement)
        )
      )
    :effect (dispatch_ready ?inbound_movement)
  )
  (:action trigger_dispatch_for_outbound_movement
    :parameters (?outbound_movement - outbound_movement ?departure_batch - departure_batch)
    :precondition
      (and
        (outbound_movement_ready ?outbound_movement)
        (outbound_movement_staged ?outbound_movement)
        (departure_batch_reserved ?departure_batch)
        (departure_batch_validated ?departure_batch)
        (not
          (dispatch_ready ?outbound_movement)
        )
      )
    :effect (dispatch_ready ?outbound_movement)
  )
  (:action attach_routing_document_and_initiate_dispatch
    :parameters (?shipment - shipment ?routing_document - routing_document ?time_slot - time_slot)
    :precondition
      (and
        (dispatch_ready ?shipment)
        (entity_time_slot_assigned ?shipment ?time_slot)
        (routing_document_available ?routing_document)
        (not
          (dispatch_initiated ?shipment)
        )
      )
    :effect
      (and
        (dispatch_initiated ?shipment)
        (entity_has_routing_document ?shipment ?routing_document)
        (not
          (routing_document_available ?routing_document)
        )
      )
  )
  (:action apply_dispatch_to_inbound_movement
    :parameters (?inbound_movement - inbound_movement ?transport_asset - transport_asset ?routing_document - routing_document)
    :precondition
      (and
        (dispatch_initiated ?inbound_movement)
        (entity_assigned_to_asset ?inbound_movement ?transport_asset)
        (entity_has_routing_document ?inbound_movement ?routing_document)
        (not
          (dispatch_assigned ?inbound_movement)
        )
      )
    :effect
      (and
        (dispatch_assigned ?inbound_movement)
        (asset_available ?transport_asset)
        (routing_document_available ?routing_document)
      )
  )
  (:action apply_dispatch_to_outbound_movement
    :parameters (?outbound_movement - outbound_movement ?transport_asset - transport_asset ?routing_document - routing_document)
    :precondition
      (and
        (dispatch_initiated ?outbound_movement)
        (entity_assigned_to_asset ?outbound_movement ?transport_asset)
        (entity_has_routing_document ?outbound_movement ?routing_document)
        (not
          (dispatch_assigned ?outbound_movement)
        )
      )
    :effect
      (and
        (dispatch_assigned ?outbound_movement)
        (asset_available ?transport_asset)
        (routing_document_available ?routing_document)
      )
  )
  (:action apply_dispatch_to_transfer_job
    :parameters (?transfer_job - transfer_job ?transport_asset - transport_asset ?routing_document - routing_document)
    :precondition
      (and
        (dispatch_initiated ?transfer_job)
        (entity_assigned_to_asset ?transfer_job ?transport_asset)
        (entity_has_routing_document ?transfer_job ?routing_document)
        (not
          (dispatch_assigned ?transfer_job)
        )
      )
    :effect
      (and
        (dispatch_assigned ?transfer_job)
        (asset_available ?transport_asset)
        (routing_document_available ?routing_document)
      )
  )
)

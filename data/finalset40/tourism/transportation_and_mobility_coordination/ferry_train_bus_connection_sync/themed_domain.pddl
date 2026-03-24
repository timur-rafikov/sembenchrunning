(define (domain ferry_train_bus_connection_sync)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource_class - object facility_resource_class - object resource_class - object itinerary_element - object connection_entity - itinerary_element local_transport_option - operational_resource_class schedule_slot - operational_resource_class local_transit_provider - operational_resource_class priority_marker - operational_resource_class passenger_group_type - operational_resource_class manifest_record - operational_resource_class equipment_attribute - operational_resource_class crew_assignment - operational_resource_class local_mode_token - facility_resource_class facility_platform - facility_resource_class operational_constraint_profile - facility_resource_class arrival_window - resource_class departure_window - resource_class vehicle_asset - resource_class leg_category - connection_entity connection_category - connection_entity ferry_leg - leg_category rail_or_bus_leg - leg_category transfer_case - connection_category)
  (:predicates
    (connection_initialized ?connection_entity - connection_entity)
    (connection_ready ?connection_entity - connection_entity)
    (connection_option_proposed ?connection_entity - connection_entity)
    (connection_confirmed ?connection_entity - connection_entity)
    (ready_for_manifest_binding ?connection_entity - connection_entity)
    (manifest_attached ?connection_entity - connection_entity)
    (local_transport_option_available ?local_transport_option - local_transport_option)
    (connection_local_transport_option_assigned ?connection_entity - connection_entity ?local_transport_option - local_transport_option)
    (slot_available ?schedule_slot_var - schedule_slot)
    (connection_reserved_slot ?connection_entity - connection_entity ?schedule_slot_var - schedule_slot)
    (local_transit_provider_available ?local_transit_provider - local_transit_provider)
    (connection_assigned_local_transit_provider ?connection_entity - connection_entity ?local_transit_provider - local_transit_provider)
    (local_mode_token_available ?local_mode_token - local_mode_token)
    (ferry_leg_local_mode_assigned ?ferry_leg - ferry_leg ?local_mode_token - local_mode_token)
    (rail_or_bus_leg_local_mode_assigned ?rail_or_bus_leg - rail_or_bus_leg ?local_mode_token - local_mode_token)
    (ferry_leg_arrival_window ?ferry_leg - ferry_leg ?arrival_window - arrival_window)
    (arrival_window_detected ?arrival_window - arrival_window)
    (arrival_window_local_mode_engaged ?arrival_window - arrival_window)
    (ferry_leg_arrival_buffered ?ferry_leg - ferry_leg)
    (rail_or_bus_leg_departure_window ?rail_or_bus_leg - rail_or_bus_leg ?departure_window - departure_window)
    (departure_window_detected ?departure_window - departure_window)
    (departure_window_local_mode_engaged ?departure_window - departure_window)
    (rail_or_bus_leg_departure_buffered ?rail_or_bus_leg - rail_or_bus_leg)
    (vehicle_available ?vehicle_asset - vehicle_asset)
    (vehicle_reserved ?vehicle_asset - vehicle_asset)
    (vehicle_assigned_arrival_window ?vehicle_asset - vehicle_asset ?arrival_window - arrival_window)
    (vehicle_assigned_departure_window ?vehicle_asset - vehicle_asset ?departure_window - departure_window)
    (vehicle_arrival_confirmed ?vehicle_asset - vehicle_asset)
    (vehicle_departure_confirmed ?vehicle_asset - vehicle_asset)
    (vehicle_ready_for_platform ?vehicle_asset - vehicle_asset)
    (transfer_includes_ferry_leg ?transfer_case - transfer_case ?ferry_leg - ferry_leg)
    (transfer_includes_rail_or_bus_leg ?transfer_case - transfer_case ?rail_or_bus_leg - rail_or_bus_leg)
    (transfer_case_vehicle_candidate ?transfer_case - transfer_case ?vehicle_asset - vehicle_asset)
    (platform_available ?facility_platform - facility_platform)
    (transfer_case_has_platform ?transfer_case - transfer_case ?facility_platform - facility_platform)
    (platform_allocated ?facility_platform - facility_platform)
    (platform_assigned_vehicle ?facility_platform - facility_platform ?vehicle_asset - vehicle_asset)
    (transfer_case_facility_ready ?transfer_case - transfer_case)
    (preboarding_checks_passed ?transfer_case - transfer_case)
    (transfer_ready_for_finalization ?transfer_case - transfer_case)
    (transfer_case_priority_applied ?transfer_case - transfer_case)
    (transfer_case_priority_acknowledged ?transfer_case - transfer_case)
    (passenger_group_registered ?transfer_case - transfer_case)
    (preboarding_final_checks_passed ?transfer_case - transfer_case)
    (constraint_profile_available ?operational_constraint_profile - operational_constraint_profile)
    (transfer_case_constraint_profile_assigned ?transfer_case - transfer_case ?operational_constraint_profile - operational_constraint_profile)
    (constraint_profile_verified ?transfer_case - transfer_case)
    (provider_check_passed ?transfer_case - transfer_case)
    (crew_assignment_verified ?transfer_case - transfer_case)
    (priority_marker_available ?priority_marker - priority_marker)
    (transfer_case_priority_assigned ?transfer_case - transfer_case ?priority_marker - priority_marker)
    (passenger_group_type_available ?passenger_group_type - passenger_group_type)
    (transfer_case_passenger_group_assigned ?transfer_case - transfer_case ?passenger_group_type - passenger_group_type)
    (equipment_attribute_available ?equipment_attribute - equipment_attribute)
    (transfer_case_equipment_attribute_assigned ?transfer_case - transfer_case ?equipment_attribute - equipment_attribute)
    (crew_assignment_available ?crew_assignment - crew_assignment)
    (transfer_case_crew_assigned ?transfer_case - transfer_case ?crew_assignment - crew_assignment)
    (manifest_available ?manifest_record - manifest_record)
    (connection_manifest_assigned ?connection_entity - connection_entity ?manifest_record - manifest_record)
    (ferry_leg_staged ?ferry_leg - ferry_leg)
    (rail_or_bus_leg_staged ?rail_or_bus_leg - rail_or_bus_leg)
    (transfer_case_confirmed ?transfer_case - transfer_case)
  )
  (:action initialize_connection
    :parameters (?connection_entity - connection_entity)
    :precondition
      (and
        (not
          (connection_initialized ?connection_entity)
        )
        (not
          (connection_confirmed ?connection_entity)
        )
      )
    :effect (connection_initialized ?connection_entity)
  )
  (:action propose_local_transport_option
    :parameters (?connection_entity - connection_entity ?local_transport_option - local_transport_option)
    :precondition
      (and
        (connection_initialized ?connection_entity)
        (not
          (connection_option_proposed ?connection_entity)
        )
        (local_transport_option_available ?local_transport_option)
      )
    :effect
      (and
        (connection_option_proposed ?connection_entity)
        (connection_local_transport_option_assigned ?connection_entity ?local_transport_option)
        (not
          (local_transport_option_available ?local_transport_option)
        )
      )
  )
  (:action reserve_schedule_slot_for_connection
    :parameters (?connection_entity - connection_entity ?schedule_slot_var - schedule_slot)
    :precondition
      (and
        (connection_initialized ?connection_entity)
        (connection_option_proposed ?connection_entity)
        (slot_available ?schedule_slot_var)
      )
    :effect
      (and
        (connection_reserved_slot ?connection_entity ?schedule_slot_var)
        (not
          (slot_available ?schedule_slot_var)
        )
      )
  )
  (:action mark_connection_ready
    :parameters (?connection_entity - connection_entity ?schedule_slot_var - schedule_slot)
    :precondition
      (and
        (connection_initialized ?connection_entity)
        (connection_option_proposed ?connection_entity)
        (connection_reserved_slot ?connection_entity ?schedule_slot_var)
        (not
          (connection_ready ?connection_entity)
        )
      )
    :effect (connection_ready ?connection_entity)
  )
  (:action release_schedule_slot_reservation
    :parameters (?connection_entity - connection_entity ?schedule_slot_var - schedule_slot)
    :precondition
      (and
        (connection_reserved_slot ?connection_entity ?schedule_slot_var)
      )
    :effect
      (and
        (slot_available ?schedule_slot_var)
        (not
          (connection_reserved_slot ?connection_entity ?schedule_slot_var)
        )
      )
  )
  (:action assign_local_provider_to_connection
    :parameters (?connection_entity - connection_entity ?local_transit_provider - local_transit_provider)
    :precondition
      (and
        (connection_ready ?connection_entity)
        (local_transit_provider_available ?local_transit_provider)
      )
    :effect
      (and
        (connection_assigned_local_transit_provider ?connection_entity ?local_transit_provider)
        (not
          (local_transit_provider_available ?local_transit_provider)
        )
      )
  )
  (:action release_local_provider_from_connection
    :parameters (?connection_entity - connection_entity ?local_transit_provider - local_transit_provider)
    :precondition
      (and
        (connection_assigned_local_transit_provider ?connection_entity ?local_transit_provider)
      )
    :effect
      (and
        (local_transit_provider_available ?local_transit_provider)
        (not
          (connection_assigned_local_transit_provider ?connection_entity ?local_transit_provider)
        )
      )
  )
  (:action assign_equipment_attribute_to_transfer_case
    :parameters (?transfer_case - transfer_case ?equipment_attribute - equipment_attribute)
    :precondition
      (and
        (connection_ready ?transfer_case)
        (equipment_attribute_available ?equipment_attribute)
      )
    :effect
      (and
        (transfer_case_equipment_attribute_assigned ?transfer_case ?equipment_attribute)
        (not
          (equipment_attribute_available ?equipment_attribute)
        )
      )
  )
  (:action remove_equipment_attribute_from_transfer_case
    :parameters (?transfer_case - transfer_case ?equipment_attribute - equipment_attribute)
    :precondition
      (and
        (transfer_case_equipment_attribute_assigned ?transfer_case ?equipment_attribute)
      )
    :effect
      (and
        (equipment_attribute_available ?equipment_attribute)
        (not
          (transfer_case_equipment_attribute_assigned ?transfer_case ?equipment_attribute)
        )
      )
  )
  (:action assign_crew_to_transfer_case
    :parameters (?transfer_case - transfer_case ?crew_assignment - crew_assignment)
    :precondition
      (and
        (connection_ready ?transfer_case)
        (crew_assignment_available ?crew_assignment)
      )
    :effect
      (and
        (transfer_case_crew_assigned ?transfer_case ?crew_assignment)
        (not
          (crew_assignment_available ?crew_assignment)
        )
      )
  )
  (:action remove_crew_from_transfer_case
    :parameters (?transfer_case - transfer_case ?crew_assignment - crew_assignment)
    :precondition
      (and
        (transfer_case_crew_assigned ?transfer_case ?crew_assignment)
      )
    :effect
      (and
        (crew_assignment_available ?crew_assignment)
        (not
          (transfer_case_crew_assigned ?transfer_case ?crew_assignment)
        )
      )
  )
  (:action detect_arrival_window_for_leg
    :parameters (?ferry_leg - ferry_leg ?arrival_window - arrival_window ?schedule_slot_var - schedule_slot)
    :precondition
      (and
        (connection_ready ?ferry_leg)
        (connection_reserved_slot ?ferry_leg ?schedule_slot_var)
        (ferry_leg_arrival_window ?ferry_leg ?arrival_window)
        (not
          (arrival_window_detected ?arrival_window)
        )
        (not
          (arrival_window_local_mode_engaged ?arrival_window)
        )
      )
    :effect (arrival_window_detected ?arrival_window)
  )
  (:action activate_arrival_staging_with_provider
    :parameters (?ferry_leg - ferry_leg ?arrival_window - arrival_window ?local_transit_provider - local_transit_provider)
    :precondition
      (and
        (connection_ready ?ferry_leg)
        (connection_assigned_local_transit_provider ?ferry_leg ?local_transit_provider)
        (ferry_leg_arrival_window ?ferry_leg ?arrival_window)
        (arrival_window_detected ?arrival_window)
        (not
          (ferry_leg_staged ?ferry_leg)
        )
      )
    :effect
      (and
        (ferry_leg_staged ?ferry_leg)
        (ferry_leg_arrival_buffered ?ferry_leg)
      )
  )
  (:action assign_local_mode_to_arrival_leg
    :parameters (?ferry_leg - ferry_leg ?arrival_window - arrival_window ?local_mode_token - local_mode_token)
    :precondition
      (and
        (connection_ready ?ferry_leg)
        (ferry_leg_arrival_window ?ferry_leg ?arrival_window)
        (local_mode_token_available ?local_mode_token)
        (not
          (ferry_leg_staged ?ferry_leg)
        )
      )
    :effect
      (and
        (arrival_window_local_mode_engaged ?arrival_window)
        (ferry_leg_staged ?ferry_leg)
        (ferry_leg_local_mode_assigned ?ferry_leg ?local_mode_token)
        (not
          (local_mode_token_available ?local_mode_token)
        )
      )
  )
  (:action finalize_arrival_local_mode_selection
    :parameters (?ferry_leg - ferry_leg ?arrival_window - arrival_window ?schedule_slot_var - schedule_slot ?local_mode_token - local_mode_token)
    :precondition
      (and
        (connection_ready ?ferry_leg)
        (connection_reserved_slot ?ferry_leg ?schedule_slot_var)
        (ferry_leg_arrival_window ?ferry_leg ?arrival_window)
        (arrival_window_local_mode_engaged ?arrival_window)
        (ferry_leg_local_mode_assigned ?ferry_leg ?local_mode_token)
        (not
          (ferry_leg_arrival_buffered ?ferry_leg)
        )
      )
    :effect
      (and
        (arrival_window_detected ?arrival_window)
        (ferry_leg_arrival_buffered ?ferry_leg)
        (local_mode_token_available ?local_mode_token)
        (not
          (ferry_leg_local_mode_assigned ?ferry_leg ?local_mode_token)
        )
      )
  )
  (:action detect_departure_window_for_leg
    :parameters (?rail_or_bus_leg - rail_or_bus_leg ?departure_window - departure_window ?schedule_slot_var - schedule_slot)
    :precondition
      (and
        (connection_ready ?rail_or_bus_leg)
        (connection_reserved_slot ?rail_or_bus_leg ?schedule_slot_var)
        (rail_or_bus_leg_departure_window ?rail_or_bus_leg ?departure_window)
        (not
          (departure_window_detected ?departure_window)
        )
        (not
          (departure_window_local_mode_engaged ?departure_window)
        )
      )
    :effect (departure_window_detected ?departure_window)
  )
  (:action activate_departure_staging_with_provider
    :parameters (?rail_or_bus_leg - rail_or_bus_leg ?departure_window - departure_window ?local_transit_provider - local_transit_provider)
    :precondition
      (and
        (connection_ready ?rail_or_bus_leg)
        (connection_assigned_local_transit_provider ?rail_or_bus_leg ?local_transit_provider)
        (rail_or_bus_leg_departure_window ?rail_or_bus_leg ?departure_window)
        (departure_window_detected ?departure_window)
        (not
          (rail_or_bus_leg_staged ?rail_or_bus_leg)
        )
      )
    :effect
      (and
        (rail_or_bus_leg_staged ?rail_or_bus_leg)
        (rail_or_bus_leg_departure_buffered ?rail_or_bus_leg)
      )
  )
  (:action assign_local_mode_to_departure_leg
    :parameters (?rail_or_bus_leg - rail_or_bus_leg ?departure_window - departure_window ?local_mode_token - local_mode_token)
    :precondition
      (and
        (connection_ready ?rail_or_bus_leg)
        (rail_or_bus_leg_departure_window ?rail_or_bus_leg ?departure_window)
        (local_mode_token_available ?local_mode_token)
        (not
          (rail_or_bus_leg_staged ?rail_or_bus_leg)
        )
      )
    :effect
      (and
        (departure_window_local_mode_engaged ?departure_window)
        (rail_or_bus_leg_staged ?rail_or_bus_leg)
        (rail_or_bus_leg_local_mode_assigned ?rail_or_bus_leg ?local_mode_token)
        (not
          (local_mode_token_available ?local_mode_token)
        )
      )
  )
  (:action finalize_departure_local_mode_selection
    :parameters (?rail_or_bus_leg - rail_or_bus_leg ?departure_window - departure_window ?schedule_slot_var - schedule_slot ?local_mode_token - local_mode_token)
    :precondition
      (and
        (connection_ready ?rail_or_bus_leg)
        (connection_reserved_slot ?rail_or_bus_leg ?schedule_slot_var)
        (rail_or_bus_leg_departure_window ?rail_or_bus_leg ?departure_window)
        (departure_window_local_mode_engaged ?departure_window)
        (rail_or_bus_leg_local_mode_assigned ?rail_or_bus_leg ?local_mode_token)
        (not
          (rail_or_bus_leg_departure_buffered ?rail_or_bus_leg)
        )
      )
    :effect
      (and
        (departure_window_detected ?departure_window)
        (rail_or_bus_leg_departure_buffered ?rail_or_bus_leg)
        (local_mode_token_available ?local_mode_token)
        (not
          (rail_or_bus_leg_local_mode_assigned ?rail_or_bus_leg ?local_mode_token)
        )
      )
  )
  (:action select_and_reserve_vehicle_candidate
    :parameters (?ferry_leg - ferry_leg ?rail_or_bus_leg - rail_or_bus_leg ?arrival_window - arrival_window ?departure_window - departure_window ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (ferry_leg_staged ?ferry_leg)
        (rail_or_bus_leg_staged ?rail_or_bus_leg)
        (ferry_leg_arrival_window ?ferry_leg ?arrival_window)
        (rail_or_bus_leg_departure_window ?rail_or_bus_leg ?departure_window)
        (arrival_window_detected ?arrival_window)
        (departure_window_detected ?departure_window)
        (ferry_leg_arrival_buffered ?ferry_leg)
        (rail_or_bus_leg_departure_buffered ?rail_or_bus_leg)
        (vehicle_available ?vehicle_asset)
      )
    :effect
      (and
        (vehicle_reserved ?vehicle_asset)
        (vehicle_assigned_arrival_window ?vehicle_asset ?arrival_window)
        (vehicle_assigned_departure_window ?vehicle_asset ?departure_window)
        (not
          (vehicle_available ?vehicle_asset)
        )
      )
  )
  (:action reserve_vehicle_with_arrival_confirmation
    :parameters (?ferry_leg - ferry_leg ?rail_or_bus_leg - rail_or_bus_leg ?arrival_window - arrival_window ?departure_window - departure_window ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (ferry_leg_staged ?ferry_leg)
        (rail_or_bus_leg_staged ?rail_or_bus_leg)
        (ferry_leg_arrival_window ?ferry_leg ?arrival_window)
        (rail_or_bus_leg_departure_window ?rail_or_bus_leg ?departure_window)
        (arrival_window_local_mode_engaged ?arrival_window)
        (departure_window_detected ?departure_window)
        (not
          (ferry_leg_arrival_buffered ?ferry_leg)
        )
        (rail_or_bus_leg_departure_buffered ?rail_or_bus_leg)
        (vehicle_available ?vehicle_asset)
      )
    :effect
      (and
        (vehicle_reserved ?vehicle_asset)
        (vehicle_assigned_arrival_window ?vehicle_asset ?arrival_window)
        (vehicle_assigned_departure_window ?vehicle_asset ?departure_window)
        (vehicle_arrival_confirmed ?vehicle_asset)
        (not
          (vehicle_available ?vehicle_asset)
        )
      )
  )
  (:action reserve_vehicle_with_departure_confirmation
    :parameters (?ferry_leg - ferry_leg ?rail_or_bus_leg - rail_or_bus_leg ?arrival_window - arrival_window ?departure_window - departure_window ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (ferry_leg_staged ?ferry_leg)
        (rail_or_bus_leg_staged ?rail_or_bus_leg)
        (ferry_leg_arrival_window ?ferry_leg ?arrival_window)
        (rail_or_bus_leg_departure_window ?rail_or_bus_leg ?departure_window)
        (arrival_window_detected ?arrival_window)
        (departure_window_local_mode_engaged ?departure_window)
        (ferry_leg_arrival_buffered ?ferry_leg)
        (not
          (rail_or_bus_leg_departure_buffered ?rail_or_bus_leg)
        )
        (vehicle_available ?vehicle_asset)
      )
    :effect
      (and
        (vehicle_reserved ?vehicle_asset)
        (vehicle_assigned_arrival_window ?vehicle_asset ?arrival_window)
        (vehicle_assigned_departure_window ?vehicle_asset ?departure_window)
        (vehicle_departure_confirmed ?vehicle_asset)
        (not
          (vehicle_available ?vehicle_asset)
        )
      )
  )
  (:action reserve_vehicle_with_full_confirmation
    :parameters (?ferry_leg - ferry_leg ?rail_or_bus_leg - rail_or_bus_leg ?arrival_window - arrival_window ?departure_window - departure_window ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (ferry_leg_staged ?ferry_leg)
        (rail_or_bus_leg_staged ?rail_or_bus_leg)
        (ferry_leg_arrival_window ?ferry_leg ?arrival_window)
        (rail_or_bus_leg_departure_window ?rail_or_bus_leg ?departure_window)
        (arrival_window_local_mode_engaged ?arrival_window)
        (departure_window_local_mode_engaged ?departure_window)
        (not
          (ferry_leg_arrival_buffered ?ferry_leg)
        )
        (not
          (rail_or_bus_leg_departure_buffered ?rail_or_bus_leg)
        )
        (vehicle_available ?vehicle_asset)
      )
    :effect
      (and
        (vehicle_reserved ?vehicle_asset)
        (vehicle_assigned_arrival_window ?vehicle_asset ?arrival_window)
        (vehicle_assigned_departure_window ?vehicle_asset ?departure_window)
        (vehicle_arrival_confirmed ?vehicle_asset)
        (vehicle_departure_confirmed ?vehicle_asset)
        (not
          (vehicle_available ?vehicle_asset)
        )
      )
  )
  (:action prepare_vehicle_for_platform_assignment
    :parameters (?vehicle_asset - vehicle_asset ?ferry_leg - ferry_leg ?schedule_slot_var - schedule_slot)
    :precondition
      (and
        (vehicle_reserved ?vehicle_asset)
        (ferry_leg_staged ?ferry_leg)
        (connection_reserved_slot ?ferry_leg ?schedule_slot_var)
        (not
          (vehicle_ready_for_platform ?vehicle_asset)
        )
      )
    :effect (vehicle_ready_for_platform ?vehicle_asset)
  )
  (:action allocate_platform_to_transfer_case
    :parameters (?transfer_case - transfer_case ?facility_platform - facility_platform ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (connection_ready ?transfer_case)
        (transfer_case_vehicle_candidate ?transfer_case ?vehicle_asset)
        (transfer_case_has_platform ?transfer_case ?facility_platform)
        (platform_available ?facility_platform)
        (vehicle_reserved ?vehicle_asset)
        (vehicle_ready_for_platform ?vehicle_asset)
        (not
          (platform_allocated ?facility_platform)
        )
      )
    :effect
      (and
        (platform_allocated ?facility_platform)
        (platform_assigned_vehicle ?facility_platform ?vehicle_asset)
        (not
          (platform_available ?facility_platform)
        )
      )
  )
  (:action confirm_facility_readiness
    :parameters (?transfer_case - transfer_case ?facility_platform - facility_platform ?vehicle_asset - vehicle_asset ?schedule_slot_var - schedule_slot)
    :precondition
      (and
        (connection_ready ?transfer_case)
        (transfer_case_has_platform ?transfer_case ?facility_platform)
        (platform_allocated ?facility_platform)
        (platform_assigned_vehicle ?facility_platform ?vehicle_asset)
        (connection_reserved_slot ?transfer_case ?schedule_slot_var)
        (not
          (vehicle_arrival_confirmed ?vehicle_asset)
        )
        (not
          (transfer_case_facility_ready ?transfer_case)
        )
      )
    :effect (transfer_case_facility_ready ?transfer_case)
  )
  (:action attach_priority_marker_to_transfer_case
    :parameters (?transfer_case - transfer_case ?priority_marker - priority_marker)
    :precondition
      (and
        (connection_ready ?transfer_case)
        (priority_marker_available ?priority_marker)
        (not
          (transfer_case_priority_applied ?transfer_case)
        )
      )
    :effect
      (and
        (transfer_case_priority_applied ?transfer_case)
        (transfer_case_priority_assigned ?transfer_case ?priority_marker)
        (not
          (priority_marker_available ?priority_marker)
        )
      )
  )
  (:action acknowledge_priority_and_confirm_facility
    :parameters (?transfer_case - transfer_case ?facility_platform - facility_platform ?vehicle_asset - vehicle_asset ?schedule_slot_var - schedule_slot ?priority_marker - priority_marker)
    :precondition
      (and
        (connection_ready ?transfer_case)
        (transfer_case_has_platform ?transfer_case ?facility_platform)
        (platform_allocated ?facility_platform)
        (platform_assigned_vehicle ?facility_platform ?vehicle_asset)
        (connection_reserved_slot ?transfer_case ?schedule_slot_var)
        (vehicle_arrival_confirmed ?vehicle_asset)
        (transfer_case_priority_applied ?transfer_case)
        (transfer_case_priority_assigned ?transfer_case ?priority_marker)
        (not
          (transfer_case_facility_ready ?transfer_case)
        )
      )
    :effect
      (and
        (transfer_case_facility_ready ?transfer_case)
        (transfer_case_priority_acknowledged ?transfer_case)
      )
  )
  (:action start_preboarding_check
    :parameters (?transfer_case - transfer_case ?equipment_attribute - equipment_attribute ?local_transit_provider - local_transit_provider ?facility_platform - facility_platform ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (transfer_case_facility_ready ?transfer_case)
        (transfer_case_equipment_attribute_assigned ?transfer_case ?equipment_attribute)
        (connection_assigned_local_transit_provider ?transfer_case ?local_transit_provider)
        (transfer_case_has_platform ?transfer_case ?facility_platform)
        (platform_assigned_vehicle ?facility_platform ?vehicle_asset)
        (not
          (vehicle_departure_confirmed ?vehicle_asset)
        )
        (not
          (preboarding_checks_passed ?transfer_case)
        )
      )
    :effect (preboarding_checks_passed ?transfer_case)
  )
  (:action continue_preboarding_check
    :parameters (?transfer_case - transfer_case ?equipment_attribute - equipment_attribute ?local_transit_provider - local_transit_provider ?facility_platform - facility_platform ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (transfer_case_facility_ready ?transfer_case)
        (transfer_case_equipment_attribute_assigned ?transfer_case ?equipment_attribute)
        (connection_assigned_local_transit_provider ?transfer_case ?local_transit_provider)
        (transfer_case_has_platform ?transfer_case ?facility_platform)
        (platform_assigned_vehicle ?facility_platform ?vehicle_asset)
        (vehicle_departure_confirmed ?vehicle_asset)
        (not
          (preboarding_checks_passed ?transfer_case)
        )
      )
    :effect (preboarding_checks_passed ?transfer_case)
  )
  (:action perform_crew_facility_check_no_vehicle_confirmation
    :parameters (?transfer_case - transfer_case ?crew_assignment - crew_assignment ?facility_platform - facility_platform ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (preboarding_checks_passed ?transfer_case)
        (transfer_case_crew_assigned ?transfer_case ?crew_assignment)
        (transfer_case_has_platform ?transfer_case ?facility_platform)
        (platform_assigned_vehicle ?facility_platform ?vehicle_asset)
        (not
          (vehicle_arrival_confirmed ?vehicle_asset)
        )
        (not
          (vehicle_departure_confirmed ?vehicle_asset)
        )
        (not
          (transfer_ready_for_finalization ?transfer_case)
        )
      )
    :effect (transfer_ready_for_finalization ?transfer_case)
  )
  (:action perform_crew_facility_check_with_arrival_confirmation
    :parameters (?transfer_case - transfer_case ?crew_assignment - crew_assignment ?facility_platform - facility_platform ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (preboarding_checks_passed ?transfer_case)
        (transfer_case_crew_assigned ?transfer_case ?crew_assignment)
        (transfer_case_has_platform ?transfer_case ?facility_platform)
        (platform_assigned_vehicle ?facility_platform ?vehicle_asset)
        (vehicle_arrival_confirmed ?vehicle_asset)
        (not
          (vehicle_departure_confirmed ?vehicle_asset)
        )
        (not
          (transfer_ready_for_finalization ?transfer_case)
        )
      )
    :effect
      (and
        (transfer_ready_for_finalization ?transfer_case)
        (passenger_group_registered ?transfer_case)
      )
  )
  (:action perform_crew_facility_check_with_departure_confirmation
    :parameters (?transfer_case - transfer_case ?crew_assignment - crew_assignment ?facility_platform - facility_platform ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (preboarding_checks_passed ?transfer_case)
        (transfer_case_crew_assigned ?transfer_case ?crew_assignment)
        (transfer_case_has_platform ?transfer_case ?facility_platform)
        (platform_assigned_vehicle ?facility_platform ?vehicle_asset)
        (not
          (vehicle_arrival_confirmed ?vehicle_asset)
        )
        (vehicle_departure_confirmed ?vehicle_asset)
        (not
          (transfer_ready_for_finalization ?transfer_case)
        )
      )
    :effect
      (and
        (transfer_ready_for_finalization ?transfer_case)
        (passenger_group_registered ?transfer_case)
      )
  )
  (:action perform_crew_facility_check_with_both_confirmations
    :parameters (?transfer_case - transfer_case ?crew_assignment - crew_assignment ?facility_platform - facility_platform ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (preboarding_checks_passed ?transfer_case)
        (transfer_case_crew_assigned ?transfer_case ?crew_assignment)
        (transfer_case_has_platform ?transfer_case ?facility_platform)
        (platform_assigned_vehicle ?facility_platform ?vehicle_asset)
        (vehicle_arrival_confirmed ?vehicle_asset)
        (vehicle_departure_confirmed ?vehicle_asset)
        (not
          (transfer_ready_for_finalization ?transfer_case)
        )
      )
    :effect
      (and
        (transfer_ready_for_finalization ?transfer_case)
        (passenger_group_registered ?transfer_case)
      )
  )
  (:action confirm_transfer_case_for_manifest_binding
    :parameters (?transfer_case - transfer_case)
    :precondition
      (and
        (transfer_ready_for_finalization ?transfer_case)
        (not
          (passenger_group_registered ?transfer_case)
        )
        (not
          (transfer_case_confirmed ?transfer_case)
        )
      )
    :effect
      (and
        (transfer_case_confirmed ?transfer_case)
        (ready_for_manifest_binding ?transfer_case)
      )
  )
  (:action attach_passenger_group_type_to_transfer_case
    :parameters (?transfer_case - transfer_case ?passenger_group_type - passenger_group_type)
    :precondition
      (and
        (transfer_ready_for_finalization ?transfer_case)
        (passenger_group_registered ?transfer_case)
        (passenger_group_type_available ?passenger_group_type)
      )
    :effect
      (and
        (transfer_case_passenger_group_assigned ?transfer_case ?passenger_group_type)
        (not
          (passenger_group_type_available ?passenger_group_type)
        )
      )
  )
  (:action complete_preboarding_checks
    :parameters (?transfer_case - transfer_case ?ferry_leg - ferry_leg ?rail_or_bus_leg - rail_or_bus_leg ?schedule_slot_var - schedule_slot ?passenger_group_type - passenger_group_type)
    :precondition
      (and
        (transfer_ready_for_finalization ?transfer_case)
        (passenger_group_registered ?transfer_case)
        (transfer_case_passenger_group_assigned ?transfer_case ?passenger_group_type)
        (transfer_includes_ferry_leg ?transfer_case ?ferry_leg)
        (transfer_includes_rail_or_bus_leg ?transfer_case ?rail_or_bus_leg)
        (ferry_leg_arrival_buffered ?ferry_leg)
        (rail_or_bus_leg_departure_buffered ?rail_or_bus_leg)
        (connection_reserved_slot ?transfer_case ?schedule_slot_var)
        (not
          (preboarding_final_checks_passed ?transfer_case)
        )
      )
    :effect (preboarding_final_checks_passed ?transfer_case)
  )
  (:action finalize_and_confirm_transfer_case
    :parameters (?transfer_case - transfer_case)
    :precondition
      (and
        (transfer_ready_for_finalization ?transfer_case)
        (preboarding_final_checks_passed ?transfer_case)
        (not
          (transfer_case_confirmed ?transfer_case)
        )
      )
    :effect
      (and
        (transfer_case_confirmed ?transfer_case)
        (ready_for_manifest_binding ?transfer_case)
      )
  )
  (:action apply_operational_constraint_profile_to_transfer_case
    :parameters (?transfer_case - transfer_case ?operational_constraint_profile - operational_constraint_profile ?schedule_slot_var - schedule_slot)
    :precondition
      (and
        (connection_ready ?transfer_case)
        (connection_reserved_slot ?transfer_case ?schedule_slot_var)
        (constraint_profile_available ?operational_constraint_profile)
        (transfer_case_constraint_profile_assigned ?transfer_case ?operational_constraint_profile)
        (not
          (constraint_profile_verified ?transfer_case)
        )
      )
    :effect
      (and
        (constraint_profile_verified ?transfer_case)
        (not
          (constraint_profile_available ?operational_constraint_profile)
        )
      )
  )
  (:action confirm_provider_compliance
    :parameters (?transfer_case - transfer_case ?local_transit_provider - local_transit_provider)
    :precondition
      (and
        (constraint_profile_verified ?transfer_case)
        (connection_assigned_local_transit_provider ?transfer_case ?local_transit_provider)
        (not
          (provider_check_passed ?transfer_case)
        )
      )
    :effect (provider_check_passed ?transfer_case)
  )
  (:action verify_crew_assignment
    :parameters (?transfer_case - transfer_case ?crew_assignment - crew_assignment)
    :precondition
      (and
        (provider_check_passed ?transfer_case)
        (transfer_case_crew_assigned ?transfer_case ?crew_assignment)
        (not
          (crew_assignment_verified ?transfer_case)
        )
      )
    :effect (crew_assignment_verified ?transfer_case)
  )
  (:action finalize_transfer_case_after_crew_verification
    :parameters (?transfer_case - transfer_case)
    :precondition
      (and
        (crew_assignment_verified ?transfer_case)
        (not
          (transfer_case_confirmed ?transfer_case)
        )
      )
    :effect
      (and
        (transfer_case_confirmed ?transfer_case)
        (ready_for_manifest_binding ?transfer_case)
      )
  )
  (:action confirm_ferry_leg_for_manifest_binding
    :parameters (?ferry_leg - ferry_leg ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (ferry_leg_staged ?ferry_leg)
        (ferry_leg_arrival_buffered ?ferry_leg)
        (vehicle_reserved ?vehicle_asset)
        (vehicle_ready_for_platform ?vehicle_asset)
        (not
          (ready_for_manifest_binding ?ferry_leg)
        )
      )
    :effect (ready_for_manifest_binding ?ferry_leg)
  )
  (:action confirm_rail_or_bus_leg_for_manifest_binding
    :parameters (?rail_or_bus_leg - rail_or_bus_leg ?vehicle_asset - vehicle_asset)
    :precondition
      (and
        (rail_or_bus_leg_staged ?rail_or_bus_leg)
        (rail_or_bus_leg_departure_buffered ?rail_or_bus_leg)
        (vehicle_reserved ?vehicle_asset)
        (vehicle_ready_for_platform ?vehicle_asset)
        (not
          (ready_for_manifest_binding ?rail_or_bus_leg)
        )
      )
    :effect (ready_for_manifest_binding ?rail_or_bus_leg)
  )
  (:action bind_manifest_to_connection
    :parameters (?connection_entity - connection_entity ?manifest_record - manifest_record ?schedule_slot_var - schedule_slot)
    :precondition
      (and
        (ready_for_manifest_binding ?connection_entity)
        (connection_reserved_slot ?connection_entity ?schedule_slot_var)
        (manifest_available ?manifest_record)
        (not
          (manifest_attached ?connection_entity)
        )
      )
    :effect
      (and
        (manifest_attached ?connection_entity)
        (connection_manifest_assigned ?connection_entity ?manifest_record)
        (not
          (manifest_available ?manifest_record)
        )
      )
  )
  (:action assign_manifest_and_local_option_to_ferry_leg
    :parameters (?ferry_leg - ferry_leg ?local_transport_option - local_transport_option ?manifest_record - manifest_record)
    :precondition
      (and
        (manifest_attached ?ferry_leg)
        (connection_local_transport_option_assigned ?ferry_leg ?local_transport_option)
        (connection_manifest_assigned ?ferry_leg ?manifest_record)
        (not
          (connection_confirmed ?ferry_leg)
        )
      )
    :effect
      (and
        (connection_confirmed ?ferry_leg)
        (local_transport_option_available ?local_transport_option)
        (manifest_available ?manifest_record)
      )
  )
  (:action assign_manifest_and_local_option_to_rail_or_bus_leg
    :parameters (?rail_or_bus_leg - rail_or_bus_leg ?local_transport_option - local_transport_option ?manifest_record - manifest_record)
    :precondition
      (and
        (manifest_attached ?rail_or_bus_leg)
        (connection_local_transport_option_assigned ?rail_or_bus_leg ?local_transport_option)
        (connection_manifest_assigned ?rail_or_bus_leg ?manifest_record)
        (not
          (connection_confirmed ?rail_or_bus_leg)
        )
      )
    :effect
      (and
        (connection_confirmed ?rail_or_bus_leg)
        (local_transport_option_available ?local_transport_option)
        (manifest_available ?manifest_record)
      )
  )
  (:action assign_manifest_and_local_option_to_transfer_case
    :parameters (?transfer_case - transfer_case ?local_transport_option - local_transport_option ?manifest_record - manifest_record)
    :precondition
      (and
        (manifest_attached ?transfer_case)
        (connection_local_transport_option_assigned ?transfer_case ?local_transport_option)
        (connection_manifest_assigned ?transfer_case ?manifest_record)
        (not
          (connection_confirmed ?transfer_case)
        )
      )
    :effect
      (and
        (connection_confirmed ?transfer_case)
        (local_transport_option_available ?local_transport_option)
        (manifest_available ?manifest_record)
      )
  )
)

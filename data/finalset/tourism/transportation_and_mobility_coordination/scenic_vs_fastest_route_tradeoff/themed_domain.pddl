(define (domain scenic_vs_fastest_route_tradeoff_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object resource_category - entity service_category - entity path_category - entity segment_category - entity route_segment_template - segment_category vehicle_type - resource_category transport_mode - resource_category transfer_node - resource_category preference_token - resource_category amenity_service - resource_category time_buffer - resource_category crew_member - resource_category authorization - resource_category local_option - service_category service_equipment - service_category site_permit - service_category path_option_scenic - path_category path_option_fastest - path_category vehicle_unit - path_category segment_group_a - route_segment_template segment_group_b - route_segment_template outbound_leg - segment_group_a inbound_leg - segment_group_a itinerary_segment - segment_group_b)

  (:predicates
    (trip_segment_initialized ?route_segment_template - route_segment_template)
    (trip_segment_ready ?route_segment_template - route_segment_template)
    (trip_segment_vehicle_reserved ?route_segment_template - route_segment_template)
    (trip_segment_completed ?route_segment_template - route_segment_template)
    (boarded ?route_segment_template - route_segment_template)
    (trip_segment_enroute ?route_segment_template - route_segment_template)
    (vehicle_type_available ?vehicle_type - vehicle_type)
    (trip_segment_has_vehicle_type ?route_segment_template - route_segment_template ?vehicle_type - vehicle_type)
    (transport_mode_available ?transport_mode - transport_mode)
    (trip_segment_has_mode ?route_segment_template - route_segment_template ?transport_mode - transport_mode)
    (transfer_node_available ?transfer_node - transfer_node)
    (trip_segment_transfer_node_assigned ?route_segment_template - route_segment_template ?transfer_node - transfer_node)
    (local_option_available ?local_option - local_option)
    (outbound_leg_local_option_assigned ?outbound_leg - outbound_leg ?local_option - local_option)
    (inbound_leg_local_option_assigned ?inbound_leg - inbound_leg ?local_option - local_option)
    (outbound_leg_has_scenic_path_option ?outbound_leg - outbound_leg ?path_option_scenic - path_option_scenic)
    (path_option_scenic_reserved ?path_option_scenic - path_option_scenic)
    (path_option_scenic_local_option_engaged ?path_option_scenic - path_option_scenic)
    (outbound_leg_ready ?outbound_leg - outbound_leg)
    (inbound_leg_has_fastest_path_option ?inbound_leg - inbound_leg ?path_option_fastest - path_option_fastest)
    (path_option_fastest_reserved ?path_option_fastest - path_option_fastest)
    (path_option_fastest_local_option_engaged ?path_option_fastest - path_option_fastest)
    (inbound_leg_ready ?inbound_leg - inbound_leg)
    (vehicle_unit_available ?vehicle_unit - vehicle_unit)
    (vehicle_unit_assigned ?vehicle_unit - vehicle_unit)
    (vehicle_unit_assigned_to_scenic_path ?vehicle_unit - vehicle_unit ?path_option_scenic - path_option_scenic)
    (vehicle_unit_assigned_to_fastest_path ?vehicle_unit - vehicle_unit ?path_option_fastest - path_option_fastest)
    (vehicle_unit_flag_scenic_ready ?vehicle_unit - vehicle_unit)
    (vehicle_unit_flag_fastest_ready ?vehicle_unit - vehicle_unit)
    (vehicle_unit_departure_ready ?vehicle_unit - vehicle_unit)
    (itinerary_contains_outbound_leg ?itinerary_item - itinerary_segment ?outbound_leg - outbound_leg)
    (itinerary_contains_inbound_leg ?itinerary_item - itinerary_segment ?inbound_leg - inbound_leg)
    (itinerary_has_vehicle_unit ?itinerary_item - itinerary_segment ?vehicle_unit - vehicle_unit)
    (equipment_available ?service_equipment - service_equipment)
    (itinerary_requires_equipment ?itinerary_item - itinerary_segment ?service_equipment - service_equipment)
    (equipment_allocated ?service_equipment - service_equipment)
    (equipment_allocated_to_vehicle ?service_equipment - service_equipment ?vehicle_unit - vehicle_unit)
    (itinerary_item_prepared ?itinerary_item - itinerary_segment)
    (itinerary_crew_allocated ?itinerary_item - itinerary_segment)
    (itinerary_services_confirmed ?itinerary_item - itinerary_segment)
    (itinerary_preference_recorded ?itinerary_item - itinerary_segment)
    (itinerary_preference_applied ?itinerary_item - itinerary_segment)
    (itinerary_services_ready ?itinerary_item - itinerary_segment)
    (itinerary_final_checks_passed ?itinerary_item - itinerary_segment)
    (site_permit_available ?site_permit - site_permit)
    (itinerary_has_site_permit ?itinerary_item - itinerary_segment ?site_permit - site_permit)
    (itinerary_permit_claimed ?itinerary_item - itinerary_segment)
    (itinerary_permit_validated ?itinerary_item - itinerary_segment)
    (itinerary_permit_finalized ?itinerary_item - itinerary_segment)
    (preference_token_available ?preference_token - preference_token)
    (itinerary_preference_binding ?itinerary_item - itinerary_segment ?preference_token - preference_token)
    (amenity_available ?amenity_service - amenity_service)
    (itinerary_amenity_assigned ?itinerary_item - itinerary_segment ?amenity_service - amenity_service)
    (crew_available ?crew_member - crew_member)
    (itinerary_crew_assigned ?itinerary_item - itinerary_segment ?crew_member - crew_member)
    (authorization_available ?authorization - authorization)
    (itinerary_authorization_assigned ?itinerary_item - itinerary_segment ?authorization - authorization)
    (time_buffer_available ?time_buffer - time_buffer)
    (trip_segment_time_buffer_assigned ?route_segment_template - route_segment_template ?time_buffer - time_buffer)
    (outbound_leg_buffer_allocated ?outbound_leg - outbound_leg)
    (inbound_leg_buffer_allocated ?inbound_leg - inbound_leg)
    (itinerary_item_committed ?itinerary_item - itinerary_segment)
  )
  (:action initialize_segment
    :parameters (?route_segment_template - route_segment_template)
    :precondition
      (and
        (not
          (trip_segment_initialized ?route_segment_template)
        )
        (not
          (trip_segment_completed ?route_segment_template)
        )
      )
    :effect (trip_segment_initialized ?route_segment_template)
  )
  (:action bind_vehicle_type_to_segment
    :parameters (?route_segment_template - route_segment_template ?vehicle_type - vehicle_type)
    :precondition
      (and
        (trip_segment_initialized ?route_segment_template)
        (not
          (trip_segment_vehicle_reserved ?route_segment_template)
        )
        (vehicle_type_available ?vehicle_type)
      )
    :effect
      (and
        (trip_segment_vehicle_reserved ?route_segment_template)
        (trip_segment_has_vehicle_type ?route_segment_template ?vehicle_type)
        (not
          (vehicle_type_available ?vehicle_type)
        )
      )
  )
  (:action bind_transport_mode_to_segment
    :parameters (?route_segment_template - route_segment_template ?transport_mode - transport_mode)
    :precondition
      (and
        (trip_segment_initialized ?route_segment_template)
        (trip_segment_vehicle_reserved ?route_segment_template)
        (transport_mode_available ?transport_mode)
      )
    :effect
      (and
        (trip_segment_has_mode ?route_segment_template ?transport_mode)
        (not
          (transport_mode_available ?transport_mode)
        )
      )
  )
  (:action confirm_segment_feasibility
    :parameters (?route_segment_template - route_segment_template ?transport_mode - transport_mode)
    :precondition
      (and
        (trip_segment_initialized ?route_segment_template)
        (trip_segment_vehicle_reserved ?route_segment_template)
        (trip_segment_has_mode ?route_segment_template ?transport_mode)
        (not
          (trip_segment_ready ?route_segment_template)
        )
      )
    :effect (trip_segment_ready ?route_segment_template)
  )
  (:action release_transport_mode_reservation
    :parameters (?route_segment_template - route_segment_template ?transport_mode - transport_mode)
    :precondition
      (and
        (trip_segment_has_mode ?route_segment_template ?transport_mode)
      )
    :effect
      (and
        (transport_mode_available ?transport_mode)
        (not
          (trip_segment_has_mode ?route_segment_template ?transport_mode)
        )
      )
  )
  (:action assign_segment_to_transfer_node
    :parameters (?route_segment_template - route_segment_template ?transfer_node - transfer_node)
    :precondition
      (and
        (trip_segment_ready ?route_segment_template)
        (transfer_node_available ?transfer_node)
      )
    :effect
      (and
        (trip_segment_transfer_node_assigned ?route_segment_template ?transfer_node)
        (not
          (transfer_node_available ?transfer_node)
        )
      )
  )
  (:action release_segment_from_transfer_node
    :parameters (?route_segment_template - route_segment_template ?transfer_node - transfer_node)
    :precondition
      (and
        (trip_segment_transfer_node_assigned ?route_segment_template ?transfer_node)
      )
    :effect
      (and
        (transfer_node_available ?transfer_node)
        (not
          (trip_segment_transfer_node_assigned ?route_segment_template ?transfer_node)
        )
      )
  )
  (:action assign_crew_to_itinerary_item
    :parameters (?itinerary_item - itinerary_segment ?crew_member - crew_member)
    :precondition
      (and
        (trip_segment_ready ?itinerary_item)
        (crew_available ?crew_member)
      )
    :effect
      (and
        (itinerary_crew_assigned ?itinerary_item ?crew_member)
        (not
          (crew_available ?crew_member)
        )
      )
  )
  (:action release_crew_from_itinerary_item
    :parameters (?itinerary_item - itinerary_segment ?crew_member - crew_member)
    :precondition
      (and
        (itinerary_crew_assigned ?itinerary_item ?crew_member)
      )
    :effect
      (and
        (crew_available ?crew_member)
        (not
          (itinerary_crew_assigned ?itinerary_item ?crew_member)
        )
      )
  )
  (:action assign_authorization_to_itinerary_item
    :parameters (?itinerary_item - itinerary_segment ?authorization - authorization)
    :precondition
      (and
        (trip_segment_ready ?itinerary_item)
        (authorization_available ?authorization)
      )
    :effect
      (and
        (itinerary_authorization_assigned ?itinerary_item ?authorization)
        (not
          (authorization_available ?authorization)
        )
      )
  )
  (:action release_authorization_from_itinerary_item
    :parameters (?itinerary_item - itinerary_segment ?authorization - authorization)
    :precondition
      (and
        (itinerary_authorization_assigned ?itinerary_item ?authorization)
      )
    :effect
      (and
        (authorization_available ?authorization)
        (not
          (itinerary_authorization_assigned ?itinerary_item ?authorization)
        )
      )
  )
  (:action reserve_scenic_path_option
    :parameters (?outbound_leg - outbound_leg ?path_option_scenic - path_option_scenic ?transport_mode - transport_mode)
    :precondition
      (and
        (trip_segment_ready ?outbound_leg)
        (trip_segment_has_mode ?outbound_leg ?transport_mode)
        (outbound_leg_has_scenic_path_option ?outbound_leg ?path_option_scenic)
        (not
          (path_option_scenic_reserved ?path_option_scenic)
        )
        (not
          (path_option_scenic_local_option_engaged ?path_option_scenic)
        )
      )
    :effect (path_option_scenic_reserved ?path_option_scenic)
  )
  (:action allocate_buffer_and_mark_outbound_ready
    :parameters (?outbound_leg - outbound_leg ?path_option_scenic - path_option_scenic ?transfer_node - transfer_node)
    :precondition
      (and
        (trip_segment_ready ?outbound_leg)
        (trip_segment_transfer_node_assigned ?outbound_leg ?transfer_node)
        (outbound_leg_has_scenic_path_option ?outbound_leg ?path_option_scenic)
        (path_option_scenic_reserved ?path_option_scenic)
        (not
          (outbound_leg_buffer_allocated ?outbound_leg)
        )
      )
    :effect
      (and
        (outbound_leg_buffer_allocated ?outbound_leg)
        (outbound_leg_ready ?outbound_leg)
      )
  )
  (:action engage_local_option_for_outbound_leg
    :parameters (?outbound_leg - outbound_leg ?path_option_scenic - path_option_scenic ?local_option - local_option)
    :precondition
      (and
        (trip_segment_ready ?outbound_leg)
        (outbound_leg_has_scenic_path_option ?outbound_leg ?path_option_scenic)
        (local_option_available ?local_option)
        (not
          (outbound_leg_buffer_allocated ?outbound_leg)
        )
      )
    :effect
      (and
        (path_option_scenic_local_option_engaged ?path_option_scenic)
        (outbound_leg_buffer_allocated ?outbound_leg)
        (outbound_leg_local_option_assigned ?outbound_leg ?local_option)
        (not
          (local_option_available ?local_option)
        )
      )
  )
  (:action confirm_outbound_local_option
    :parameters (?outbound_leg - outbound_leg ?path_option_scenic - path_option_scenic ?transport_mode - transport_mode ?local_option - local_option)
    :precondition
      (and
        (trip_segment_ready ?outbound_leg)
        (trip_segment_has_mode ?outbound_leg ?transport_mode)
        (outbound_leg_has_scenic_path_option ?outbound_leg ?path_option_scenic)
        (path_option_scenic_local_option_engaged ?path_option_scenic)
        (outbound_leg_local_option_assigned ?outbound_leg ?local_option)
        (not
          (outbound_leg_ready ?outbound_leg)
        )
      )
    :effect
      (and
        (path_option_scenic_reserved ?path_option_scenic)
        (outbound_leg_ready ?outbound_leg)
        (local_option_available ?local_option)
        (not
          (outbound_leg_local_option_assigned ?outbound_leg ?local_option)
        )
      )
  )
  (:action reserve_fastest_path_option
    :parameters (?inbound_leg - inbound_leg ?path_option_fastest - path_option_fastest ?transport_mode - transport_mode)
    :precondition
      (and
        (trip_segment_ready ?inbound_leg)
        (trip_segment_has_mode ?inbound_leg ?transport_mode)
        (inbound_leg_has_fastest_path_option ?inbound_leg ?path_option_fastest)
        (not
          (path_option_fastest_reserved ?path_option_fastest)
        )
        (not
          (path_option_fastest_local_option_engaged ?path_option_fastest)
        )
      )
    :effect (path_option_fastest_reserved ?path_option_fastest)
  )
  (:action assign_transfer_node_and_mark_inbound_ready
    :parameters (?inbound_leg - inbound_leg ?path_option_fastest - path_option_fastest ?transfer_node - transfer_node)
    :precondition
      (and
        (trip_segment_ready ?inbound_leg)
        (trip_segment_transfer_node_assigned ?inbound_leg ?transfer_node)
        (inbound_leg_has_fastest_path_option ?inbound_leg ?path_option_fastest)
        (path_option_fastest_reserved ?path_option_fastest)
        (not
          (inbound_leg_buffer_allocated ?inbound_leg)
        )
      )
    :effect
      (and
        (inbound_leg_buffer_allocated ?inbound_leg)
        (inbound_leg_ready ?inbound_leg)
      )
  )
  (:action engage_local_option_for_inbound_leg
    :parameters (?inbound_leg - inbound_leg ?path_option_fastest - path_option_fastest ?local_option - local_option)
    :precondition
      (and
        (trip_segment_ready ?inbound_leg)
        (inbound_leg_has_fastest_path_option ?inbound_leg ?path_option_fastest)
        (local_option_available ?local_option)
        (not
          (inbound_leg_buffer_allocated ?inbound_leg)
        )
      )
    :effect
      (and
        (path_option_fastest_local_option_engaged ?path_option_fastest)
        (inbound_leg_buffer_allocated ?inbound_leg)
        (inbound_leg_local_option_assigned ?inbound_leg ?local_option)
        (not
          (local_option_available ?local_option)
        )
      )
  )
  (:action confirm_inbound_local_option
    :parameters (?inbound_leg - inbound_leg ?path_option_fastest - path_option_fastest ?transport_mode - transport_mode ?local_option - local_option)
    :precondition
      (and
        (trip_segment_ready ?inbound_leg)
        (trip_segment_has_mode ?inbound_leg ?transport_mode)
        (inbound_leg_has_fastest_path_option ?inbound_leg ?path_option_fastest)
        (path_option_fastest_local_option_engaged ?path_option_fastest)
        (inbound_leg_local_option_assigned ?inbound_leg ?local_option)
        (not
          (inbound_leg_ready ?inbound_leg)
        )
      )
    :effect
      (and
        (path_option_fastest_reserved ?path_option_fastest)
        (inbound_leg_ready ?inbound_leg)
        (local_option_available ?local_option)
        (not
          (inbound_leg_local_option_assigned ?inbound_leg ?local_option)
        )
      )
  )
  (:action assign_vehicle_unit_to_paths_and_lock
    :parameters (?outbound_leg - outbound_leg ?inbound_leg - inbound_leg ?path_option_scenic - path_option_scenic ?path_option_fastest - path_option_fastest ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (outbound_leg_buffer_allocated ?outbound_leg)
        (inbound_leg_buffer_allocated ?inbound_leg)
        (outbound_leg_has_scenic_path_option ?outbound_leg ?path_option_scenic)
        (inbound_leg_has_fastest_path_option ?inbound_leg ?path_option_fastest)
        (path_option_scenic_reserved ?path_option_scenic)
        (path_option_fastest_reserved ?path_option_fastest)
        (outbound_leg_ready ?outbound_leg)
        (inbound_leg_ready ?inbound_leg)
        (vehicle_unit_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_unit_assigned ?vehicle_unit)
        (vehicle_unit_assigned_to_scenic_path ?vehicle_unit ?path_option_scenic)
        (vehicle_unit_assigned_to_fastest_path ?vehicle_unit ?path_option_fastest)
        (not
          (vehicle_unit_available ?vehicle_unit)
        )
      )
  )
  (:action assign_vehicle_unit_with_scenic_flag
    :parameters (?outbound_leg - outbound_leg ?inbound_leg - inbound_leg ?path_option_scenic - path_option_scenic ?path_option_fastest - path_option_fastest ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (outbound_leg_buffer_allocated ?outbound_leg)
        (inbound_leg_buffer_allocated ?inbound_leg)
        (outbound_leg_has_scenic_path_option ?outbound_leg ?path_option_scenic)
        (inbound_leg_has_fastest_path_option ?inbound_leg ?path_option_fastest)
        (path_option_scenic_local_option_engaged ?path_option_scenic)
        (path_option_fastest_reserved ?path_option_fastest)
        (not
          (outbound_leg_ready ?outbound_leg)
        )
        (inbound_leg_ready ?inbound_leg)
        (vehicle_unit_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_unit_assigned ?vehicle_unit)
        (vehicle_unit_assigned_to_scenic_path ?vehicle_unit ?path_option_scenic)
        (vehicle_unit_assigned_to_fastest_path ?vehicle_unit ?path_option_fastest)
        (vehicle_unit_flag_scenic_ready ?vehicle_unit)
        (not
          (vehicle_unit_available ?vehicle_unit)
        )
      )
  )
  (:action assign_vehicle_unit_with_fastest_flag
    :parameters (?outbound_leg - outbound_leg ?inbound_leg - inbound_leg ?path_option_scenic - path_option_scenic ?path_option_fastest - path_option_fastest ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (outbound_leg_buffer_allocated ?outbound_leg)
        (inbound_leg_buffer_allocated ?inbound_leg)
        (outbound_leg_has_scenic_path_option ?outbound_leg ?path_option_scenic)
        (inbound_leg_has_fastest_path_option ?inbound_leg ?path_option_fastest)
        (path_option_scenic_reserved ?path_option_scenic)
        (path_option_fastest_local_option_engaged ?path_option_fastest)
        (outbound_leg_ready ?outbound_leg)
        (not
          (inbound_leg_ready ?inbound_leg)
        )
        (vehicle_unit_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_unit_assigned ?vehicle_unit)
        (vehicle_unit_assigned_to_scenic_path ?vehicle_unit ?path_option_scenic)
        (vehicle_unit_assigned_to_fastest_path ?vehicle_unit ?path_option_fastest)
        (vehicle_unit_flag_fastest_ready ?vehicle_unit)
        (not
          (vehicle_unit_available ?vehicle_unit)
        )
      )
  )
  (:action assign_vehicle_unit_with_combined_flags
    :parameters (?outbound_leg - outbound_leg ?inbound_leg - inbound_leg ?path_option_scenic - path_option_scenic ?path_option_fastest - path_option_fastest ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (outbound_leg_buffer_allocated ?outbound_leg)
        (inbound_leg_buffer_allocated ?inbound_leg)
        (outbound_leg_has_scenic_path_option ?outbound_leg ?path_option_scenic)
        (inbound_leg_has_fastest_path_option ?inbound_leg ?path_option_fastest)
        (path_option_scenic_local_option_engaged ?path_option_scenic)
        (path_option_fastest_local_option_engaged ?path_option_fastest)
        (not
          (outbound_leg_ready ?outbound_leg)
        )
        (not
          (inbound_leg_ready ?inbound_leg)
        )
        (vehicle_unit_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_unit_assigned ?vehicle_unit)
        (vehicle_unit_assigned_to_scenic_path ?vehicle_unit ?path_option_scenic)
        (vehicle_unit_assigned_to_fastest_path ?vehicle_unit ?path_option_fastest)
        (vehicle_unit_flag_scenic_ready ?vehicle_unit)
        (vehicle_unit_flag_fastest_ready ?vehicle_unit)
        (not
          (vehicle_unit_available ?vehicle_unit)
        )
      )
  )
  (:action lock_vehicle_for_departure
    :parameters (?vehicle_unit - vehicle_unit ?outbound_leg - outbound_leg ?transport_mode - transport_mode)
    :precondition
      (and
        (vehicle_unit_assigned ?vehicle_unit)
        (outbound_leg_buffer_allocated ?outbound_leg)
        (trip_segment_has_mode ?outbound_leg ?transport_mode)
        (not
          (vehicle_unit_departure_ready ?vehicle_unit)
        )
      )
    :effect (vehicle_unit_departure_ready ?vehicle_unit)
  )
  (:action allocate_equipment_and_attach_to_vehicle
    :parameters (?itinerary_item - itinerary_segment ?service_equipment - service_equipment ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (trip_segment_ready ?itinerary_item)
        (itinerary_has_vehicle_unit ?itinerary_item ?vehicle_unit)
        (itinerary_requires_equipment ?itinerary_item ?service_equipment)
        (equipment_available ?service_equipment)
        (vehicle_unit_assigned ?vehicle_unit)
        (vehicle_unit_departure_ready ?vehicle_unit)
        (not
          (equipment_allocated ?service_equipment)
        )
      )
    :effect
      (and
        (equipment_allocated ?service_equipment)
        (equipment_allocated_to_vehicle ?service_equipment ?vehicle_unit)
        (not
          (equipment_available ?service_equipment)
        )
      )
  )
  (:action mark_itinerary_item_prepared
    :parameters (?itinerary_item - itinerary_segment ?service_equipment - service_equipment ?vehicle_unit - vehicle_unit ?transport_mode - transport_mode)
    :precondition
      (and
        (trip_segment_ready ?itinerary_item)
        (itinerary_requires_equipment ?itinerary_item ?service_equipment)
        (equipment_allocated ?service_equipment)
        (equipment_allocated_to_vehicle ?service_equipment ?vehicle_unit)
        (trip_segment_has_mode ?itinerary_item ?transport_mode)
        (not
          (vehicle_unit_flag_scenic_ready ?vehicle_unit)
        )
        (not
          (itinerary_item_prepared ?itinerary_item)
        )
      )
    :effect (itinerary_item_prepared ?itinerary_item)
  )
  (:action record_preference_for_itinerary_item
    :parameters (?itinerary_item - itinerary_segment ?preference_token - preference_token)
    :precondition
      (and
        (trip_segment_ready ?itinerary_item)
        (preference_token_available ?preference_token)
        (not
          (itinerary_preference_recorded ?itinerary_item)
        )
      )
    :effect
      (and
        (itinerary_preference_recorded ?itinerary_item)
        (itinerary_preference_binding ?itinerary_item ?preference_token)
        (not
          (preference_token_available ?preference_token)
        )
      )
  )
  (:action apply_preference_and_prepare_itinerary_item
    :parameters (?itinerary_item - itinerary_segment ?service_equipment - service_equipment ?vehicle_unit - vehicle_unit ?transport_mode - transport_mode ?preference_token - preference_token)
    :precondition
      (and
        (trip_segment_ready ?itinerary_item)
        (itinerary_requires_equipment ?itinerary_item ?service_equipment)
        (equipment_allocated ?service_equipment)
        (equipment_allocated_to_vehicle ?service_equipment ?vehicle_unit)
        (trip_segment_has_mode ?itinerary_item ?transport_mode)
        (vehicle_unit_flag_scenic_ready ?vehicle_unit)
        (itinerary_preference_recorded ?itinerary_item)
        (itinerary_preference_binding ?itinerary_item ?preference_token)
        (not
          (itinerary_item_prepared ?itinerary_item)
        )
      )
    :effect
      (and
        (itinerary_item_prepared ?itinerary_item)
        (itinerary_preference_applied ?itinerary_item)
      )
  )
  (:action assign_crew_to_itinerary_item_when_vehicle_unflagged
    :parameters (?itinerary_item - itinerary_segment ?crew_member - crew_member ?transfer_node - transfer_node ?service_equipment - service_equipment ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_item_prepared ?itinerary_item)
        (itinerary_crew_assigned ?itinerary_item ?crew_member)
        (trip_segment_transfer_node_assigned ?itinerary_item ?transfer_node)
        (itinerary_requires_equipment ?itinerary_item ?service_equipment)
        (equipment_allocated_to_vehicle ?service_equipment ?vehicle_unit)
        (not
          (vehicle_unit_flag_fastest_ready ?vehicle_unit)
        )
        (not
          (itinerary_crew_allocated ?itinerary_item)
        )
      )
    :effect (itinerary_crew_allocated ?itinerary_item)
  )
  (:action assign_crew_to_itinerary_item_when_vehicle_flagged
    :parameters (?itinerary_item - itinerary_segment ?crew_member - crew_member ?transfer_node - transfer_node ?service_equipment - service_equipment ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_item_prepared ?itinerary_item)
        (itinerary_crew_assigned ?itinerary_item ?crew_member)
        (trip_segment_transfer_node_assigned ?itinerary_item ?transfer_node)
        (itinerary_requires_equipment ?itinerary_item ?service_equipment)
        (equipment_allocated_to_vehicle ?service_equipment ?vehicle_unit)
        (vehicle_unit_flag_fastest_ready ?vehicle_unit)
        (not
          (itinerary_crew_allocated ?itinerary_item)
        )
      )
    :effect (itinerary_crew_allocated ?itinerary_item)
  )
  (:action assign_authorization_and_confirm_services
    :parameters (?itinerary_item - itinerary_segment ?authorization - authorization ?service_equipment - service_equipment ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_crew_allocated ?itinerary_item)
        (itinerary_authorization_assigned ?itinerary_item ?authorization)
        (itinerary_requires_equipment ?itinerary_item ?service_equipment)
        (equipment_allocated_to_vehicle ?service_equipment ?vehicle_unit)
        (not
          (vehicle_unit_flag_scenic_ready ?vehicle_unit)
        )
        (not
          (vehicle_unit_flag_fastest_ready ?vehicle_unit)
        )
        (not
          (itinerary_services_confirmed ?itinerary_item)
        )
      )
    :effect (itinerary_services_confirmed ?itinerary_item)
  )
  (:action assign_authorization_and_confirm_services_with_preference
    :parameters (?itinerary_item - itinerary_segment ?authorization - authorization ?service_equipment - service_equipment ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_crew_allocated ?itinerary_item)
        (itinerary_authorization_assigned ?itinerary_item ?authorization)
        (itinerary_requires_equipment ?itinerary_item ?service_equipment)
        (equipment_allocated_to_vehicle ?service_equipment ?vehicle_unit)
        (vehicle_unit_flag_scenic_ready ?vehicle_unit)
        (not
          (vehicle_unit_flag_fastest_ready ?vehicle_unit)
        )
        (not
          (itinerary_services_confirmed ?itinerary_item)
        )
      )
    :effect
      (and
        (itinerary_services_confirmed ?itinerary_item)
        (itinerary_services_ready ?itinerary_item)
      )
  )
  (:action assign_authorization_and_confirm_services_with_fastest_flag
    :parameters (?itinerary_item - itinerary_segment ?authorization - authorization ?service_equipment - service_equipment ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_crew_allocated ?itinerary_item)
        (itinerary_authorization_assigned ?itinerary_item ?authorization)
        (itinerary_requires_equipment ?itinerary_item ?service_equipment)
        (equipment_allocated_to_vehicle ?service_equipment ?vehicle_unit)
        (not
          (vehicle_unit_flag_scenic_ready ?vehicle_unit)
        )
        (vehicle_unit_flag_fastest_ready ?vehicle_unit)
        (not
          (itinerary_services_confirmed ?itinerary_item)
        )
      )
    :effect
      (and
        (itinerary_services_confirmed ?itinerary_item)
        (itinerary_services_ready ?itinerary_item)
      )
  )
  (:action assign_authorization_and_confirm_services_with_both_flags
    :parameters (?itinerary_item - itinerary_segment ?authorization - authorization ?service_equipment - service_equipment ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_crew_allocated ?itinerary_item)
        (itinerary_authorization_assigned ?itinerary_item ?authorization)
        (itinerary_requires_equipment ?itinerary_item ?service_equipment)
        (equipment_allocated_to_vehicle ?service_equipment ?vehicle_unit)
        (vehicle_unit_flag_scenic_ready ?vehicle_unit)
        (vehicle_unit_flag_fastest_ready ?vehicle_unit)
        (not
          (itinerary_services_confirmed ?itinerary_item)
        )
      )
    :effect
      (and
        (itinerary_services_confirmed ?itinerary_item)
        (itinerary_services_ready ?itinerary_item)
      )
  )
  (:action commit_itinerary_item_direct
    :parameters (?itinerary_item - itinerary_segment)
    :precondition
      (and
        (itinerary_services_confirmed ?itinerary_item)
        (not
          (itinerary_services_ready ?itinerary_item)
        )
        (not
          (itinerary_item_committed ?itinerary_item)
        )
      )
    :effect
      (and
        (itinerary_item_committed ?itinerary_item)
        (boarded ?itinerary_item)
      )
  )
  (:action assign_amenity_to_itinerary_item
    :parameters (?itinerary_item - itinerary_segment ?amenity_service - amenity_service)
    :precondition
      (and
        (itinerary_services_confirmed ?itinerary_item)
        (itinerary_services_ready ?itinerary_item)
        (amenity_available ?amenity_service)
      )
    :effect
      (and
        (itinerary_amenity_assigned ?itinerary_item ?amenity_service)
        (not
          (amenity_available ?amenity_service)
        )
      )
  )
  (:action perform_multi_resource_readiness_check
    :parameters (?itinerary_item - itinerary_segment ?outbound_leg - outbound_leg ?inbound_leg - inbound_leg ?transport_mode - transport_mode ?amenity_service - amenity_service)
    :precondition
      (and
        (itinerary_services_confirmed ?itinerary_item)
        (itinerary_services_ready ?itinerary_item)
        (itinerary_amenity_assigned ?itinerary_item ?amenity_service)
        (itinerary_contains_outbound_leg ?itinerary_item ?outbound_leg)
        (itinerary_contains_inbound_leg ?itinerary_item ?inbound_leg)
        (outbound_leg_ready ?outbound_leg)
        (inbound_leg_ready ?inbound_leg)
        (trip_segment_has_mode ?itinerary_item ?transport_mode)
        (not
          (itinerary_final_checks_passed ?itinerary_item)
        )
      )
    :effect (itinerary_final_checks_passed ?itinerary_item)
  )
  (:action commit_itinerary_item_post_checks
    :parameters (?itinerary_item - itinerary_segment)
    :precondition
      (and
        (itinerary_services_confirmed ?itinerary_item)
        (itinerary_final_checks_passed ?itinerary_item)
        (not
          (itinerary_item_committed ?itinerary_item)
        )
      )
    :effect
      (and
        (itinerary_item_committed ?itinerary_item)
        (boarded ?itinerary_item)
      )
  )
  (:action claim_itinerary_permit
    :parameters (?itinerary_item - itinerary_segment ?site_permit - site_permit ?transport_mode - transport_mode)
    :precondition
      (and
        (trip_segment_ready ?itinerary_item)
        (trip_segment_has_mode ?itinerary_item ?transport_mode)
        (site_permit_available ?site_permit)
        (itinerary_has_site_permit ?itinerary_item ?site_permit)
        (not
          (itinerary_permit_claimed ?itinerary_item)
        )
      )
    :effect
      (and
        (itinerary_permit_claimed ?itinerary_item)
        (not
          (site_permit_available ?site_permit)
        )
      )
  )
  (:action validate_itinerary_permit
    :parameters (?itinerary_item - itinerary_segment ?transfer_node - transfer_node)
    :precondition
      (and
        (itinerary_permit_claimed ?itinerary_item)
        (trip_segment_transfer_node_assigned ?itinerary_item ?transfer_node)
        (not
          (itinerary_permit_validated ?itinerary_item)
        )
      )
    :effect (itinerary_permit_validated ?itinerary_item)
  )
  (:action finalize_itinerary_permit
    :parameters (?itinerary_item - itinerary_segment ?authorization - authorization)
    :precondition
      (and
        (itinerary_permit_validated ?itinerary_item)
        (itinerary_authorization_assigned ?itinerary_item ?authorization)
        (not
          (itinerary_permit_finalized ?itinerary_item)
        )
      )
    :effect (itinerary_permit_finalized ?itinerary_item)
  )
  (:action commit_itinerary_item_after_permit
    :parameters (?itinerary_item - itinerary_segment)
    :precondition
      (and
        (itinerary_permit_finalized ?itinerary_item)
        (not
          (itinerary_item_committed ?itinerary_item)
        )
      )
    :effect
      (and
        (itinerary_item_committed ?itinerary_item)
        (boarded ?itinerary_item)
      )
  )
  (:action board_outbound_leg
    :parameters (?outbound_leg - outbound_leg ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (outbound_leg_buffer_allocated ?outbound_leg)
        (outbound_leg_ready ?outbound_leg)
        (vehicle_unit_assigned ?vehicle_unit)
        (vehicle_unit_departure_ready ?vehicle_unit)
        (not
          (boarded ?outbound_leg)
        )
      )
    :effect (boarded ?outbound_leg)
  )
  (:action board_inbound_leg
    :parameters (?inbound_leg - inbound_leg ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (inbound_leg_buffer_allocated ?inbound_leg)
        (inbound_leg_ready ?inbound_leg)
        (vehicle_unit_assigned ?vehicle_unit)
        (vehicle_unit_departure_ready ?vehicle_unit)
        (not
          (boarded ?inbound_leg)
        )
      )
    :effect (boarded ?inbound_leg)
  )
  (:action start_segment_and_assign_time_buffer
    :parameters (?route_segment_template - route_segment_template ?time_buffer - time_buffer ?transport_mode - transport_mode)
    :precondition
      (and
        (boarded ?route_segment_template)
        (trip_segment_has_mode ?route_segment_template ?transport_mode)
        (time_buffer_available ?time_buffer)
        (not
          (trip_segment_enroute ?route_segment_template)
        )
      )
    :effect
      (and
        (trip_segment_enroute ?route_segment_template)
        (trip_segment_time_buffer_assigned ?route_segment_template ?time_buffer)
        (not
          (time_buffer_available ?time_buffer)
        )
      )
  )
  (:action complete_outbound_leg_and_release_vehicle_type
    :parameters (?outbound_leg - outbound_leg ?vehicle_type - vehicle_type ?time_buffer - time_buffer)
    :precondition
      (and
        (trip_segment_enroute ?outbound_leg)
        (trip_segment_has_vehicle_type ?outbound_leg ?vehicle_type)
        (trip_segment_time_buffer_assigned ?outbound_leg ?time_buffer)
        (not
          (trip_segment_completed ?outbound_leg)
        )
      )
    :effect
      (and
        (trip_segment_completed ?outbound_leg)
        (vehicle_type_available ?vehicle_type)
        (time_buffer_available ?time_buffer)
      )
  )
  (:action complete_inbound_leg_and_release_vehicle_type
    :parameters (?inbound_leg - inbound_leg ?vehicle_type - vehicle_type ?time_buffer - time_buffer)
    :precondition
      (and
        (trip_segment_enroute ?inbound_leg)
        (trip_segment_has_vehicle_type ?inbound_leg ?vehicle_type)
        (trip_segment_time_buffer_assigned ?inbound_leg ?time_buffer)
        (not
          (trip_segment_completed ?inbound_leg)
        )
      )
    :effect
      (and
        (trip_segment_completed ?inbound_leg)
        (vehicle_type_available ?vehicle_type)
        (time_buffer_available ?time_buffer)
      )
  )
  (:action complete_itinerary_item_and_release_vehicle_type
    :parameters (?itinerary_item - itinerary_segment ?vehicle_type - vehicle_type ?time_buffer - time_buffer)
    :precondition
      (and
        (trip_segment_enroute ?itinerary_item)
        (trip_segment_has_vehicle_type ?itinerary_item ?vehicle_type)
        (trip_segment_time_buffer_assigned ?itinerary_item ?time_buffer)
        (not
          (trip_segment_completed ?itinerary_item)
        )
      )
    :effect
      (and
        (trip_segment_completed ?itinerary_item)
        (vehicle_type_available ?vehicle_type)
        (time_buffer_available ?time_buffer)
      )
  )
)

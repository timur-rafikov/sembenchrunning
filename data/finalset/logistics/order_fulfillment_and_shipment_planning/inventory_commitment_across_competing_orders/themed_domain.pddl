(define (domain order_fulfillment_inventory_commitment)
  (:requirements :strips :typing :negative-preconditions)
  (:types physical_resource_type - object inventory_entity_type - object location_entity_type - object order_entity_type - object customer_order - order_entity_type fulfillment_center - physical_resource_type product_sku - physical_resource_type warehouse_zone - physical_resource_type routing_profile - physical_resource_type transport_equipment - physical_resource_type delivery_time_window - physical_resource_type special_handling_resource - physical_resource_type carrier - physical_resource_type inventory_lot - inventory_entity_type package - inventory_entity_type service_option - inventory_entity_type pick_slot - location_entity_type consolidation_slot - location_entity_type shipment - location_entity_type order_line_group - customer_order fulfillment_group - customer_order order_line_primary - order_line_group order_line_competing - order_line_group fulfillment_request - fulfillment_group)
  (:predicates
    (order_released ?customer_order - customer_order)
    (ready_for_fulfillment ?customer_order - customer_order)
    (order_sourcing_proposed ?customer_order - customer_order)
    (allocation_committed ?customer_order - customer_order)
    (released_for_execution ?customer_order - customer_order)
    (committed_for_delivery ?customer_order - customer_order)
    (fulfillment_center_available ?fulfillment_center - fulfillment_center)
    (proposed_fulfillment_center ?customer_order - customer_order ?fulfillment_center - fulfillment_center)
    (sku_available ?product_sku - product_sku)
    (sku_bound ?customer_order - customer_order ?product_sku - product_sku)
    (warehouse_zone_available ?warehouse_zone - warehouse_zone)
    (order_assigned_zone ?customer_order - customer_order ?warehouse_zone - warehouse_zone)
    (inventory_lot_available ?inventory_lot - inventory_lot)
    (order_line_reserved_lot ?order_line_primary - order_line_primary ?inventory_lot - inventory_lot)
    (competing_order_line_reserved_lot ?order_line_competing - order_line_competing ?inventory_lot - inventory_lot)
    (order_line_candidate_pick_slot ?order_line_primary - order_line_primary ?pick_slot - pick_slot)
    (pick_slot_selected ?pick_slot - pick_slot)
    (pick_slot_locked ?pick_slot - pick_slot)
    (order_line_slot_committed ?order_line_primary - order_line_primary)
    (competing_line_candidate_consolidation_slot ?order_line_competing - order_line_competing ?consolidation_slot - consolidation_slot)
    (consolidation_slot_selected ?consolidation_slot - consolidation_slot)
    (consolidation_slot_locked ?consolidation_slot - consolidation_slot)
    (competing_order_line_slot_committed ?order_line_competing - order_line_competing)
    (shipment_available_for_consolidation ?shipment - shipment)
    (shipment_staged ?shipment - shipment)
    (shipment_assigned_pick_slot ?shipment - shipment ?pick_slot - pick_slot)
    (shipment_assigned_consolidation_slot ?shipment - shipment ?consolidation_slot - consolidation_slot)
    (shipment_includes_selected_pick_items ?shipment - shipment)
    (shipment_includes_locked_pick_items ?shipment - shipment)
    (shipment_packaging_ready ?shipment - shipment)
    (fulfillment_request_assigned_primary_line ?fulfillment_request - fulfillment_request ?order_line_primary - order_line_primary)
    (fulfillment_request_assigned_competing_line ?fulfillment_request - fulfillment_request ?order_line_competing - order_line_competing)
    (fulfillment_request_assigned_shipment ?fulfillment_request - fulfillment_request ?shipment - shipment)
    (package_available ?package - package)
    (fulfillment_request_assigned_package ?fulfillment_request - fulfillment_request ?package - package)
    (package_finalized ?package - package)
    (package_assigned_to_shipment ?package - package ?shipment - shipment)
    (fulfillment_request_package_validated ?fulfillment_request - fulfillment_request)
    (fulfillment_request_handling_allocated ?fulfillment_request - fulfillment_request)
    (fulfillment_request_ready_for_finalization ?fulfillment_request - fulfillment_request)
    (fulfillment_request_routing_profile_assigned_flag ?fulfillment_request - fulfillment_request)
    (fulfillment_request_packaging_verified ?fulfillment_request - fulfillment_request)
    (fulfillment_request_handling_requirements_met ?fulfillment_request - fulfillment_request)
    (fulfillment_request_final_checks_passed ?fulfillment_request - fulfillment_request)
    (service_option_available ?service_option - service_option)
    (fulfillment_request_assigned_service_option ?fulfillment_request - fulfillment_request ?service_option - service_option)
    (fulfillment_request_service_option_confirmed ?fulfillment_request - fulfillment_request)
    (fulfillment_request_routing_initiated ?fulfillment_request - fulfillment_request)
    (fulfillment_request_carrier_assigned_flag ?fulfillment_request - fulfillment_request)
    (routing_profile_available ?routing_profile - routing_profile)
    (fulfillment_request_assigned_routing_profile ?fulfillment_request - fulfillment_request ?routing_profile - routing_profile)
    (transport_equipment_available ?transport_equipment - transport_equipment)
    (fulfillment_request_assigned_transport_equipment ?fulfillment_request - fulfillment_request ?transport_equipment - transport_equipment)
    (special_handling_resource_available ?special_handling_resource - special_handling_resource)
    (fulfillment_request_assigned_special_handling_resource ?fulfillment_request - fulfillment_request ?special_handling_resource - special_handling_resource)
    (carrier_available ?carrier - carrier)
    (fulfillment_request_assigned_carrier ?fulfillment_request - fulfillment_request ?carrier - carrier)
    (delivery_time_window_available ?delivery_time_window - delivery_time_window)
    (order_assigned_delivery_window ?customer_order - customer_order ?delivery_time_window - delivery_time_window)
    (order_line_slot_allocation_flag ?order_line_primary - order_line_primary)
    (competing_order_line_slot_allocation_flag ?order_line_competing - order_line_competing)
    (fulfillment_request_release_marked ?fulfillment_request - fulfillment_request)
  )
  (:action release_order_for_sourcing
    :parameters (?customer_order - customer_order)
    :precondition
      (and
        (not
          (order_released ?customer_order)
        )
        (not
          (allocation_committed ?customer_order)
        )
      )
    :effect (order_released ?customer_order)
  )
  (:action propose_fulfillment_center_for_order
    :parameters (?customer_order - customer_order ?fulfillment_center - fulfillment_center)
    :precondition
      (and
        (order_released ?customer_order)
        (not
          (order_sourcing_proposed ?customer_order)
        )
        (fulfillment_center_available ?fulfillment_center)
      )
    :effect
      (and
        (order_sourcing_proposed ?customer_order)
        (proposed_fulfillment_center ?customer_order ?fulfillment_center)
        (not
          (fulfillment_center_available ?fulfillment_center)
        )
      )
  )
  (:action bind_sku_to_order
    :parameters (?customer_order - customer_order ?product_sku - product_sku)
    :precondition
      (and
        (order_released ?customer_order)
        (order_sourcing_proposed ?customer_order)
        (sku_available ?product_sku)
      )
    :effect
      (and
        (sku_bound ?customer_order ?product_sku)
        (not
          (sku_available ?product_sku)
        )
      )
  )
  (:action confirm_order_sourcing
    :parameters (?customer_order - customer_order ?product_sku - product_sku)
    :precondition
      (and
        (order_released ?customer_order)
        (order_sourcing_proposed ?customer_order)
        (sku_bound ?customer_order ?product_sku)
        (not
          (ready_for_fulfillment ?customer_order)
        )
      )
    :effect (ready_for_fulfillment ?customer_order)
  )
  (:action rollback_sku_binding
    :parameters (?customer_order - customer_order ?product_sku - product_sku)
    :precondition
      (and
        (sku_bound ?customer_order ?product_sku)
      )
    :effect
      (and
        (sku_available ?product_sku)
        (not
          (sku_bound ?customer_order ?product_sku)
        )
      )
  )
  (:action assign_zone_to_order
    :parameters (?customer_order - customer_order ?warehouse_zone - warehouse_zone)
    :precondition
      (and
        (ready_for_fulfillment ?customer_order)
        (warehouse_zone_available ?warehouse_zone)
      )
    :effect
      (and
        (order_assigned_zone ?customer_order ?warehouse_zone)
        (not
          (warehouse_zone_available ?warehouse_zone)
        )
      )
  )
  (:action unassign_zone_from_order
    :parameters (?customer_order - customer_order ?warehouse_zone - warehouse_zone)
    :precondition
      (and
        (order_assigned_zone ?customer_order ?warehouse_zone)
      )
    :effect
      (and
        (warehouse_zone_available ?warehouse_zone)
        (not
          (order_assigned_zone ?customer_order ?warehouse_zone)
        )
      )
  )
  (:action assign_special_handling_resource_to_request
    :parameters (?fulfillment_request - fulfillment_request ?special_handling_resource - special_handling_resource)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_request)
        (special_handling_resource_available ?special_handling_resource)
      )
    :effect
      (and
        (fulfillment_request_assigned_special_handling_resource ?fulfillment_request ?special_handling_resource)
        (not
          (special_handling_resource_available ?special_handling_resource)
        )
      )
  )
  (:action release_special_handling_resource_from_request
    :parameters (?fulfillment_request - fulfillment_request ?special_handling_resource - special_handling_resource)
    :precondition
      (and
        (fulfillment_request_assigned_special_handling_resource ?fulfillment_request ?special_handling_resource)
      )
    :effect
      (and
        (special_handling_resource_available ?special_handling_resource)
        (not
          (fulfillment_request_assigned_special_handling_resource ?fulfillment_request ?special_handling_resource)
        )
      )
  )
  (:action assign_carrier_to_request
    :parameters (?fulfillment_request - fulfillment_request ?carrier - carrier)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_request)
        (carrier_available ?carrier)
      )
    :effect
      (and
        (fulfillment_request_assigned_carrier ?fulfillment_request ?carrier)
        (not
          (carrier_available ?carrier)
        )
      )
  )
  (:action release_carrier_from_request
    :parameters (?fulfillment_request - fulfillment_request ?carrier - carrier)
    :precondition
      (and
        (fulfillment_request_assigned_carrier ?fulfillment_request ?carrier)
      )
    :effect
      (and
        (carrier_available ?carrier)
        (not
          (fulfillment_request_assigned_carrier ?fulfillment_request ?carrier)
        )
      )
  )
  (:action select_pick_slot_candidate
    :parameters (?order_line_primary - order_line_primary ?pick_slot - pick_slot ?product_sku - product_sku)
    :precondition
      (and
        (ready_for_fulfillment ?order_line_primary)
        (sku_bound ?order_line_primary ?product_sku)
        (order_line_candidate_pick_slot ?order_line_primary ?pick_slot)
        (not
          (pick_slot_selected ?pick_slot)
        )
        (not
          (pick_slot_locked ?pick_slot)
        )
      )
    :effect (pick_slot_selected ?pick_slot)
  )
  (:action confirm_pick_slot_for_order_line
    :parameters (?order_line_primary - order_line_primary ?pick_slot - pick_slot ?warehouse_zone - warehouse_zone)
    :precondition
      (and
        (ready_for_fulfillment ?order_line_primary)
        (order_assigned_zone ?order_line_primary ?warehouse_zone)
        (order_line_candidate_pick_slot ?order_line_primary ?pick_slot)
        (pick_slot_selected ?pick_slot)
        (not
          (order_line_slot_allocation_flag ?order_line_primary)
        )
      )
    :effect
      (and
        (order_line_slot_allocation_flag ?order_line_primary)
        (order_line_slot_committed ?order_line_primary)
      )
  )
  (:action reserve_inventory_lot_and_lock_pick_slot
    :parameters (?order_line_primary - order_line_primary ?pick_slot - pick_slot ?inventory_lot - inventory_lot)
    :precondition
      (and
        (ready_for_fulfillment ?order_line_primary)
        (order_line_candidate_pick_slot ?order_line_primary ?pick_slot)
        (inventory_lot_available ?inventory_lot)
        (not
          (order_line_slot_allocation_flag ?order_line_primary)
        )
      )
    :effect
      (and
        (pick_slot_locked ?pick_slot)
        (order_line_slot_allocation_flag ?order_line_primary)
        (order_line_reserved_lot ?order_line_primary ?inventory_lot)
        (not
          (inventory_lot_available ?inventory_lot)
        )
      )
  )
  (:action commit_pick_slot_and_inventory_lot
    :parameters (?order_line_primary - order_line_primary ?pick_slot - pick_slot ?product_sku - product_sku ?inventory_lot - inventory_lot)
    :precondition
      (and
        (ready_for_fulfillment ?order_line_primary)
        (sku_bound ?order_line_primary ?product_sku)
        (order_line_candidate_pick_slot ?order_line_primary ?pick_slot)
        (pick_slot_locked ?pick_slot)
        (order_line_reserved_lot ?order_line_primary ?inventory_lot)
        (not
          (order_line_slot_committed ?order_line_primary)
        )
      )
    :effect
      (and
        (pick_slot_selected ?pick_slot)
        (order_line_slot_committed ?order_line_primary)
        (inventory_lot_available ?inventory_lot)
        (not
          (order_line_reserved_lot ?order_line_primary ?inventory_lot)
        )
      )
  )
  (:action select_consolidation_slot_candidate
    :parameters (?order_line_competing - order_line_competing ?consolidation_slot - consolidation_slot ?product_sku - product_sku)
    :precondition
      (and
        (ready_for_fulfillment ?order_line_competing)
        (sku_bound ?order_line_competing ?product_sku)
        (competing_line_candidate_consolidation_slot ?order_line_competing ?consolidation_slot)
        (not
          (consolidation_slot_selected ?consolidation_slot)
        )
        (not
          (consolidation_slot_locked ?consolidation_slot)
        )
      )
    :effect (consolidation_slot_selected ?consolidation_slot)
  )
  (:action confirm_consolidation_slot_for_competing_line
    :parameters (?order_line_competing - order_line_competing ?consolidation_slot - consolidation_slot ?warehouse_zone - warehouse_zone)
    :precondition
      (and
        (ready_for_fulfillment ?order_line_competing)
        (order_assigned_zone ?order_line_competing ?warehouse_zone)
        (competing_line_candidate_consolidation_slot ?order_line_competing ?consolidation_slot)
        (consolidation_slot_selected ?consolidation_slot)
        (not
          (competing_order_line_slot_allocation_flag ?order_line_competing)
        )
      )
    :effect
      (and
        (competing_order_line_slot_allocation_flag ?order_line_competing)
        (competing_order_line_slot_committed ?order_line_competing)
      )
  )
  (:action reserve_inventory_lot_and_lock_consolidation_slot
    :parameters (?order_line_competing - order_line_competing ?consolidation_slot - consolidation_slot ?inventory_lot - inventory_lot)
    :precondition
      (and
        (ready_for_fulfillment ?order_line_competing)
        (competing_line_candidate_consolidation_slot ?order_line_competing ?consolidation_slot)
        (inventory_lot_available ?inventory_lot)
        (not
          (competing_order_line_slot_allocation_flag ?order_line_competing)
        )
      )
    :effect
      (and
        (consolidation_slot_locked ?consolidation_slot)
        (competing_order_line_slot_allocation_flag ?order_line_competing)
        (competing_order_line_reserved_lot ?order_line_competing ?inventory_lot)
        (not
          (inventory_lot_available ?inventory_lot)
        )
      )
  )
  (:action commit_competing_line_slot_and_inventory
    :parameters (?order_line_competing - order_line_competing ?consolidation_slot - consolidation_slot ?product_sku - product_sku ?inventory_lot - inventory_lot)
    :precondition
      (and
        (ready_for_fulfillment ?order_line_competing)
        (sku_bound ?order_line_competing ?product_sku)
        (competing_line_candidate_consolidation_slot ?order_line_competing ?consolidation_slot)
        (consolidation_slot_locked ?consolidation_slot)
        (competing_order_line_reserved_lot ?order_line_competing ?inventory_lot)
        (not
          (competing_order_line_slot_committed ?order_line_competing)
        )
      )
    :effect
      (and
        (consolidation_slot_selected ?consolidation_slot)
        (competing_order_line_slot_committed ?order_line_competing)
        (inventory_lot_available ?inventory_lot)
        (not
          (competing_order_line_reserved_lot ?order_line_competing ?inventory_lot)
        )
      )
  )
  (:action form_shipment_from_selected_pick_and_selected_consolidation
    :parameters (?order_line_primary - order_line_primary ?order_line_competing - order_line_competing ?pick_slot - pick_slot ?consolidation_slot - consolidation_slot ?shipment - shipment)
    :precondition
      (and
        (order_line_slot_allocation_flag ?order_line_primary)
        (competing_order_line_slot_allocation_flag ?order_line_competing)
        (order_line_candidate_pick_slot ?order_line_primary ?pick_slot)
        (competing_line_candidate_consolidation_slot ?order_line_competing ?consolidation_slot)
        (pick_slot_selected ?pick_slot)
        (consolidation_slot_selected ?consolidation_slot)
        (order_line_slot_committed ?order_line_primary)
        (competing_order_line_slot_committed ?order_line_competing)
        (shipment_available_for_consolidation ?shipment)
      )
    :effect
      (and
        (shipment_staged ?shipment)
        (shipment_assigned_pick_slot ?shipment ?pick_slot)
        (shipment_assigned_consolidation_slot ?shipment ?consolidation_slot)
        (not
          (shipment_available_for_consolidation ?shipment)
        )
      )
  )
  (:action form_shipment_from_locked_pick_and_selected_consolidation
    :parameters (?order_line_primary - order_line_primary ?order_line_competing - order_line_competing ?pick_slot - pick_slot ?consolidation_slot - consolidation_slot ?shipment - shipment)
    :precondition
      (and
        (order_line_slot_allocation_flag ?order_line_primary)
        (competing_order_line_slot_allocation_flag ?order_line_competing)
        (order_line_candidate_pick_slot ?order_line_primary ?pick_slot)
        (competing_line_candidate_consolidation_slot ?order_line_competing ?consolidation_slot)
        (pick_slot_locked ?pick_slot)
        (consolidation_slot_selected ?consolidation_slot)
        (not
          (order_line_slot_committed ?order_line_primary)
        )
        (competing_order_line_slot_committed ?order_line_competing)
        (shipment_available_for_consolidation ?shipment)
      )
    :effect
      (and
        (shipment_staged ?shipment)
        (shipment_assigned_pick_slot ?shipment ?pick_slot)
        (shipment_assigned_consolidation_slot ?shipment ?consolidation_slot)
        (shipment_includes_selected_pick_items ?shipment)
        (not
          (shipment_available_for_consolidation ?shipment)
        )
      )
  )
  (:action form_shipment_from_selected_pick_and_locked_consolidation
    :parameters (?order_line_primary - order_line_primary ?order_line_competing - order_line_competing ?pick_slot - pick_slot ?consolidation_slot - consolidation_slot ?shipment - shipment)
    :precondition
      (and
        (order_line_slot_allocation_flag ?order_line_primary)
        (competing_order_line_slot_allocation_flag ?order_line_competing)
        (order_line_candidate_pick_slot ?order_line_primary ?pick_slot)
        (competing_line_candidate_consolidation_slot ?order_line_competing ?consolidation_slot)
        (pick_slot_selected ?pick_slot)
        (consolidation_slot_locked ?consolidation_slot)
        (order_line_slot_committed ?order_line_primary)
        (not
          (competing_order_line_slot_committed ?order_line_competing)
        )
        (shipment_available_for_consolidation ?shipment)
      )
    :effect
      (and
        (shipment_staged ?shipment)
        (shipment_assigned_pick_slot ?shipment ?pick_slot)
        (shipment_assigned_consolidation_slot ?shipment ?consolidation_slot)
        (shipment_includes_locked_pick_items ?shipment)
        (not
          (shipment_available_for_consolidation ?shipment)
        )
      )
  )
  (:action form_shipment_from_locked_pick_and_locked_consolidation
    :parameters (?order_line_primary - order_line_primary ?order_line_competing - order_line_competing ?pick_slot - pick_slot ?consolidation_slot - consolidation_slot ?shipment - shipment)
    :precondition
      (and
        (order_line_slot_allocation_flag ?order_line_primary)
        (competing_order_line_slot_allocation_flag ?order_line_competing)
        (order_line_candidate_pick_slot ?order_line_primary ?pick_slot)
        (competing_line_candidate_consolidation_slot ?order_line_competing ?consolidation_slot)
        (pick_slot_locked ?pick_slot)
        (consolidation_slot_locked ?consolidation_slot)
        (not
          (order_line_slot_committed ?order_line_primary)
        )
        (not
          (competing_order_line_slot_committed ?order_line_competing)
        )
        (shipment_available_for_consolidation ?shipment)
      )
    :effect
      (and
        (shipment_staged ?shipment)
        (shipment_assigned_pick_slot ?shipment ?pick_slot)
        (shipment_assigned_consolidation_slot ?shipment ?consolidation_slot)
        (shipment_includes_selected_pick_items ?shipment)
        (shipment_includes_locked_pick_items ?shipment)
        (not
          (shipment_available_for_consolidation ?shipment)
        )
      )
  )
  (:action validate_shipment_for_packaging
    :parameters (?shipment - shipment ?order_line_primary - order_line_primary ?product_sku - product_sku)
    :precondition
      (and
        (shipment_staged ?shipment)
        (order_line_slot_allocation_flag ?order_line_primary)
        (sku_bound ?order_line_primary ?product_sku)
        (not
          (shipment_packaging_ready ?shipment)
        )
      )
    :effect (shipment_packaging_ready ?shipment)
  )
  (:action assign_and_finalize_package_for_request
    :parameters (?fulfillment_request - fulfillment_request ?package - package ?shipment - shipment)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_request)
        (fulfillment_request_assigned_shipment ?fulfillment_request ?shipment)
        (fulfillment_request_assigned_package ?fulfillment_request ?package)
        (package_available ?package)
        (shipment_staged ?shipment)
        (shipment_packaging_ready ?shipment)
        (not
          (package_finalized ?package)
        )
      )
    :effect
      (and
        (package_finalized ?package)
        (package_assigned_to_shipment ?package ?shipment)
        (not
          (package_available ?package)
        )
      )
  )
  (:action validate_package_and_mark_request
    :parameters (?fulfillment_request - fulfillment_request ?package - package ?shipment - shipment ?product_sku - product_sku)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_request)
        (fulfillment_request_assigned_package ?fulfillment_request ?package)
        (package_finalized ?package)
        (package_assigned_to_shipment ?package ?shipment)
        (sku_bound ?fulfillment_request ?product_sku)
        (not
          (shipment_includes_selected_pick_items ?shipment)
        )
        (not
          (fulfillment_request_package_validated ?fulfillment_request)
        )
      )
    :effect (fulfillment_request_package_validated ?fulfillment_request)
  )
  (:action assign_routing_profile_to_request
    :parameters (?fulfillment_request - fulfillment_request ?routing_profile - routing_profile)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_request)
        (routing_profile_available ?routing_profile)
        (not
          (fulfillment_request_routing_profile_assigned_flag ?fulfillment_request)
        )
      )
    :effect
      (and
        (fulfillment_request_routing_profile_assigned_flag ?fulfillment_request)
        (fulfillment_request_assigned_routing_profile ?fulfillment_request ?routing_profile)
        (not
          (routing_profile_available ?routing_profile)
        )
      )
  )
  (:action finalize_packaging_with_routing_profile
    :parameters (?fulfillment_request - fulfillment_request ?package - package ?shipment - shipment ?product_sku - product_sku ?routing_profile - routing_profile)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_request)
        (fulfillment_request_assigned_package ?fulfillment_request ?package)
        (package_finalized ?package)
        (package_assigned_to_shipment ?package ?shipment)
        (sku_bound ?fulfillment_request ?product_sku)
        (shipment_includes_selected_pick_items ?shipment)
        (fulfillment_request_routing_profile_assigned_flag ?fulfillment_request)
        (fulfillment_request_assigned_routing_profile ?fulfillment_request ?routing_profile)
        (not
          (fulfillment_request_package_validated ?fulfillment_request)
        )
      )
    :effect
      (and
        (fulfillment_request_package_validated ?fulfillment_request)
        (fulfillment_request_packaging_verified ?fulfillment_request)
      )
  )
  (:action allocate_special_handling_and_prepare_request_for_processing
    :parameters (?fulfillment_request - fulfillment_request ?special_handling_resource - special_handling_resource ?warehouse_zone - warehouse_zone ?package - package ?shipment - shipment)
    :precondition
      (and
        (fulfillment_request_package_validated ?fulfillment_request)
        (fulfillment_request_assigned_special_handling_resource ?fulfillment_request ?special_handling_resource)
        (order_assigned_zone ?fulfillment_request ?warehouse_zone)
        (fulfillment_request_assigned_package ?fulfillment_request ?package)
        (package_assigned_to_shipment ?package ?shipment)
        (not
          (shipment_includes_locked_pick_items ?shipment)
        )
        (not
          (fulfillment_request_handling_allocated ?fulfillment_request)
        )
      )
    :effect (fulfillment_request_handling_allocated ?fulfillment_request)
  )
  (:action allocate_special_handling_for_locked_shipment_and_prepare_request
    :parameters (?fulfillment_request - fulfillment_request ?special_handling_resource - special_handling_resource ?warehouse_zone - warehouse_zone ?package - package ?shipment - shipment)
    :precondition
      (and
        (fulfillment_request_package_validated ?fulfillment_request)
        (fulfillment_request_assigned_special_handling_resource ?fulfillment_request ?special_handling_resource)
        (order_assigned_zone ?fulfillment_request ?warehouse_zone)
        (fulfillment_request_assigned_package ?fulfillment_request ?package)
        (package_assigned_to_shipment ?package ?shipment)
        (shipment_includes_locked_pick_items ?shipment)
        (not
          (fulfillment_request_handling_allocated ?fulfillment_request)
        )
      )
    :effect (fulfillment_request_handling_allocated ?fulfillment_request)
  )
  (:action assign_carrier_and_mark_request_ready
    :parameters (?fulfillment_request - fulfillment_request ?carrier - carrier ?package - package ?shipment - shipment)
    :precondition
      (and
        (fulfillment_request_handling_allocated ?fulfillment_request)
        (fulfillment_request_assigned_carrier ?fulfillment_request ?carrier)
        (fulfillment_request_assigned_package ?fulfillment_request ?package)
        (package_assigned_to_shipment ?package ?shipment)
        (not
          (shipment_includes_selected_pick_items ?shipment)
        )
        (not
          (shipment_includes_locked_pick_items ?shipment)
        )
        (not
          (fulfillment_request_ready_for_finalization ?fulfillment_request)
        )
      )
    :effect (fulfillment_request_ready_for_finalization ?fulfillment_request)
  )
  (:action assign_carrier_and_confirm_handling_requirements_for_selected_pick
    :parameters (?fulfillment_request - fulfillment_request ?carrier - carrier ?package - package ?shipment - shipment)
    :precondition
      (and
        (fulfillment_request_handling_allocated ?fulfillment_request)
        (fulfillment_request_assigned_carrier ?fulfillment_request ?carrier)
        (fulfillment_request_assigned_package ?fulfillment_request ?package)
        (package_assigned_to_shipment ?package ?shipment)
        (shipment_includes_selected_pick_items ?shipment)
        (not
          (shipment_includes_locked_pick_items ?shipment)
        )
        (not
          (fulfillment_request_ready_for_finalization ?fulfillment_request)
        )
      )
    :effect
      (and
        (fulfillment_request_ready_for_finalization ?fulfillment_request)
        (fulfillment_request_handling_requirements_met ?fulfillment_request)
      )
  )
  (:action assign_carrier_and_confirm_handling_requirements_for_locked_pick
    :parameters (?fulfillment_request - fulfillment_request ?carrier - carrier ?package - package ?shipment - shipment)
    :precondition
      (and
        (fulfillment_request_handling_allocated ?fulfillment_request)
        (fulfillment_request_assigned_carrier ?fulfillment_request ?carrier)
        (fulfillment_request_assigned_package ?fulfillment_request ?package)
        (package_assigned_to_shipment ?package ?shipment)
        (not
          (shipment_includes_selected_pick_items ?shipment)
        )
        (shipment_includes_locked_pick_items ?shipment)
        (not
          (fulfillment_request_ready_for_finalization ?fulfillment_request)
        )
      )
    :effect
      (and
        (fulfillment_request_ready_for_finalization ?fulfillment_request)
        (fulfillment_request_handling_requirements_met ?fulfillment_request)
      )
  )
  (:action assign_carrier_and_confirm_handling_requirements_for_mixed_pick
    :parameters (?fulfillment_request - fulfillment_request ?carrier - carrier ?package - package ?shipment - shipment)
    :precondition
      (and
        (fulfillment_request_handling_allocated ?fulfillment_request)
        (fulfillment_request_assigned_carrier ?fulfillment_request ?carrier)
        (fulfillment_request_assigned_package ?fulfillment_request ?package)
        (package_assigned_to_shipment ?package ?shipment)
        (shipment_includes_selected_pick_items ?shipment)
        (shipment_includes_locked_pick_items ?shipment)
        (not
          (fulfillment_request_ready_for_finalization ?fulfillment_request)
        )
      )
    :effect
      (and
        (fulfillment_request_ready_for_finalization ?fulfillment_request)
        (fulfillment_request_handling_requirements_met ?fulfillment_request)
      )
  )
  (:action mark_request_ready_for_release
    :parameters (?fulfillment_request - fulfillment_request)
    :precondition
      (and
        (fulfillment_request_ready_for_finalization ?fulfillment_request)
        (not
          (fulfillment_request_handling_requirements_met ?fulfillment_request)
        )
        (not
          (fulfillment_request_release_marked ?fulfillment_request)
        )
      )
    :effect
      (and
        (fulfillment_request_release_marked ?fulfillment_request)
        (released_for_execution ?fulfillment_request)
      )
  )
  (:action assign_transport_equipment_to_request
    :parameters (?fulfillment_request - fulfillment_request ?transport_equipment - transport_equipment)
    :precondition
      (and
        (fulfillment_request_ready_for_finalization ?fulfillment_request)
        (fulfillment_request_handling_requirements_met ?fulfillment_request)
        (transport_equipment_available ?transport_equipment)
      )
    :effect
      (and
        (fulfillment_request_assigned_transport_equipment ?fulfillment_request ?transport_equipment)
        (not
          (transport_equipment_available ?transport_equipment)
        )
      )
  )
  (:action finalize_request_execution_checks
    :parameters (?fulfillment_request - fulfillment_request ?order_line_primary - order_line_primary ?order_line_competing - order_line_competing ?product_sku - product_sku ?transport_equipment - transport_equipment)
    :precondition
      (and
        (fulfillment_request_ready_for_finalization ?fulfillment_request)
        (fulfillment_request_handling_requirements_met ?fulfillment_request)
        (fulfillment_request_assigned_transport_equipment ?fulfillment_request ?transport_equipment)
        (fulfillment_request_assigned_primary_line ?fulfillment_request ?order_line_primary)
        (fulfillment_request_assigned_competing_line ?fulfillment_request ?order_line_competing)
        (order_line_slot_committed ?order_line_primary)
        (competing_order_line_slot_committed ?order_line_competing)
        (sku_bound ?fulfillment_request ?product_sku)
        (not
          (fulfillment_request_final_checks_passed ?fulfillment_request)
        )
      )
    :effect (fulfillment_request_final_checks_passed ?fulfillment_request)
  )
  (:action finalize_and_release_request_for_execution
    :parameters (?fulfillment_request - fulfillment_request)
    :precondition
      (and
        (fulfillment_request_ready_for_finalization ?fulfillment_request)
        (fulfillment_request_final_checks_passed ?fulfillment_request)
        (not
          (fulfillment_request_release_marked ?fulfillment_request)
        )
      )
    :effect
      (and
        (fulfillment_request_release_marked ?fulfillment_request)
        (released_for_execution ?fulfillment_request)
      )
  )
  (:action confirm_service_option_for_request
    :parameters (?fulfillment_request - fulfillment_request ?service_option - service_option ?product_sku - product_sku)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_request)
        (sku_bound ?fulfillment_request ?product_sku)
        (service_option_available ?service_option)
        (fulfillment_request_assigned_service_option ?fulfillment_request ?service_option)
        (not
          (fulfillment_request_service_option_confirmed ?fulfillment_request)
        )
      )
    :effect
      (and
        (fulfillment_request_service_option_confirmed ?fulfillment_request)
        (not
          (service_option_available ?service_option)
        )
      )
  )
  (:action initiate_routing_for_request
    :parameters (?fulfillment_request - fulfillment_request ?warehouse_zone - warehouse_zone)
    :precondition
      (and
        (fulfillment_request_service_option_confirmed ?fulfillment_request)
        (order_assigned_zone ?fulfillment_request ?warehouse_zone)
        (not
          (fulfillment_request_routing_initiated ?fulfillment_request)
        )
      )
    :effect (fulfillment_request_routing_initiated ?fulfillment_request)
  )
  (:action lock_carrier_assignment_for_request
    :parameters (?fulfillment_request - fulfillment_request ?carrier - carrier)
    :precondition
      (and
        (fulfillment_request_routing_initiated ?fulfillment_request)
        (fulfillment_request_assigned_carrier ?fulfillment_request ?carrier)
        (not
          (fulfillment_request_carrier_assigned_flag ?fulfillment_request)
        )
      )
    :effect (fulfillment_request_carrier_assigned_flag ?fulfillment_request)
  )
  (:action release_request_after_carrier_assignment
    :parameters (?fulfillment_request - fulfillment_request)
    :precondition
      (and
        (fulfillment_request_carrier_assigned_flag ?fulfillment_request)
        (not
          (fulfillment_request_release_marked ?fulfillment_request)
        )
      )
    :effect
      (and
        (fulfillment_request_release_marked ?fulfillment_request)
        (released_for_execution ?fulfillment_request)
      )
  )
  (:action release_order_line
    :parameters (?order_line_primary - order_line_primary ?shipment - shipment)
    :precondition
      (and
        (order_line_slot_allocation_flag ?order_line_primary)
        (order_line_slot_committed ?order_line_primary)
        (shipment_staged ?shipment)
        (shipment_packaging_ready ?shipment)
        (not
          (released_for_execution ?order_line_primary)
        )
      )
    :effect (released_for_execution ?order_line_primary)
  )
  (:action release_competing_order_line
    :parameters (?order_line_competing - order_line_competing ?shipment - shipment)
    :precondition
      (and
        (competing_order_line_slot_allocation_flag ?order_line_competing)
        (competing_order_line_slot_committed ?order_line_competing)
        (shipment_staged ?shipment)
        (shipment_packaging_ready ?shipment)
        (not
          (released_for_execution ?order_line_competing)
        )
      )
    :effect (released_for_execution ?order_line_competing)
  )
  (:action commit_order_to_delivery_window
    :parameters (?customer_order - customer_order ?delivery_time_window - delivery_time_window ?product_sku - product_sku)
    :precondition
      (and
        (released_for_execution ?customer_order)
        (sku_bound ?customer_order ?product_sku)
        (delivery_time_window_available ?delivery_time_window)
        (not
          (committed_for_delivery ?customer_order)
        )
      )
    :effect
      (and
        (committed_for_delivery ?customer_order)
        (order_assigned_delivery_window ?customer_order ?delivery_time_window)
        (not
          (delivery_time_window_available ?delivery_time_window)
        )
      )
  )
  (:action apply_commitment_to_order_line
    :parameters (?order_line_primary - order_line_primary ?fulfillment_center - fulfillment_center ?delivery_time_window - delivery_time_window)
    :precondition
      (and
        (committed_for_delivery ?order_line_primary)
        (proposed_fulfillment_center ?order_line_primary ?fulfillment_center)
        (order_assigned_delivery_window ?order_line_primary ?delivery_time_window)
        (not
          (allocation_committed ?order_line_primary)
        )
      )
    :effect
      (and
        (allocation_committed ?order_line_primary)
        (fulfillment_center_available ?fulfillment_center)
        (delivery_time_window_available ?delivery_time_window)
      )
  )
  (:action apply_commitment_to_competing_order_line
    :parameters (?order_line_competing - order_line_competing ?fulfillment_center - fulfillment_center ?delivery_time_window - delivery_time_window)
    :precondition
      (and
        (committed_for_delivery ?order_line_competing)
        (proposed_fulfillment_center ?order_line_competing ?fulfillment_center)
        (order_assigned_delivery_window ?order_line_competing ?delivery_time_window)
        (not
          (allocation_committed ?order_line_competing)
        )
      )
    :effect
      (and
        (allocation_committed ?order_line_competing)
        (fulfillment_center_available ?fulfillment_center)
        (delivery_time_window_available ?delivery_time_window)
      )
  )
  (:action apply_commitment_to_fulfillment_request
    :parameters (?fulfillment_request - fulfillment_request ?fulfillment_center - fulfillment_center ?delivery_time_window - delivery_time_window)
    :precondition
      (and
        (committed_for_delivery ?fulfillment_request)
        (proposed_fulfillment_center ?fulfillment_request ?fulfillment_center)
        (order_assigned_delivery_window ?fulfillment_request ?delivery_time_window)
        (not
          (allocation_committed ?fulfillment_request)
        )
      )
    :effect
      (and
        (allocation_committed ?fulfillment_request)
        (fulfillment_center_available ?fulfillment_center)
        (delivery_time_window_available ?delivery_time_window)
      )
  )
)

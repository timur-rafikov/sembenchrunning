(define (domain service_level_shipment_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types operation_resource - object package_and_constraint_type - object logistics_node_type - object order_root_type - object order - order_root_type inventory_source - operation_resource product_sku - operation_resource pack_station - operation_resource transport_mode - operation_resource shipping_label - operation_resource service_level - operation_resource carrier_option - operation_resource delivery_time_window - operation_resource packing_material - package_and_constraint_type pallet_or_container - package_and_constraint_type routing_preference - package_and_constraint_type origin_loading_dock - logistics_node_type destination_loading_dock - logistics_node_type shipment_unit - logistics_node_type order_line_type_group - order order_aggregate_type_group - order order_line_origin - order_line_type_group order_line_destination - order_line_type_group customer_order_aggregate - order_aggregate_type_group)
  (:predicates
    (order_entity_registered ?order - order)
    (order_entity_allocated ?order - order)
    (order_entity_sourced ?order - order)
    (finalized ?order - order)
    (dispatched ?order - order)
    (order_entity_released ?order - order)
    (inventory_source_available ?inventory_source - inventory_source)
    (order_entity_assigned_to_inventory_source ?order - order ?inventory_source - inventory_source)
    (sku_available ?product_sku - product_sku)
    (order_entity_allocated_sku ?order - order ?product_sku - product_sku)
    (pack_station_available ?pack_station - pack_station)
    (order_entity_assigned_to_pack_station ?order - order ?pack_station - pack_station)
    (packing_material_available ?packing_material - packing_material)
    (order_line_origin_assigned_packing_material ?order_line_origin - order_line_origin ?packing_material - packing_material)
    (order_line_destination_assigned_packing_material ?order_line_destination - order_line_destination ?packing_material - packing_material)
    (order_line_origin_assigned_to_dock ?order_line_origin - order_line_origin ?origin_loading_dock - origin_loading_dock)
    (origin_loading_dock_staged ?origin_loading_dock - origin_loading_dock)
    (origin_loading_dock_materials_staged ?origin_loading_dock - origin_loading_dock)
    (order_line_origin_ready_for_shipment ?order_line_origin - order_line_origin)
    (order_line_destination_assigned_to_dock ?order_line_destination - order_line_destination ?destination_loading_dock - destination_loading_dock)
    (destination_loading_dock_staged ?destination_loading_dock - destination_loading_dock)
    (destination_loading_dock_materials_staged ?destination_loading_dock - destination_loading_dock)
    (order_line_destination_ready_for_shipment ?order_line_destination - order_line_destination)
    (shipment_open ?shipment_unit - shipment_unit)
    (shipment_created ?shipment_unit - shipment_unit)
    (shipment_assigned_origin_dock ?shipment_unit - shipment_unit ?origin_loading_dock - origin_loading_dock)
    (shipment_assigned_destination_dock ?shipment_unit - shipment_unit ?destination_loading_dock - destination_loading_dock)
    (shipment_origin_materials_flag ?shipment_unit - shipment_unit)
    (shipment_destination_materials_flag ?shipment_unit - shipment_unit)
    (shipment_ready_for_containerization ?shipment_unit - shipment_unit)
    (aggregate_contains_origin_line ?customer_order_aggregate - customer_order_aggregate ?order_line_origin - order_line_origin)
    (aggregate_contains_destination_line ?customer_order_aggregate - customer_order_aggregate ?order_line_destination - order_line_destination)
    (aggregate_assigned_to_shipment ?customer_order_aggregate - customer_order_aggregate ?shipment_unit - shipment_unit)
    (container_available ?pallet_or_container - pallet_or_container)
    (aggregate_assigned_container ?customer_order_aggregate - customer_order_aggregate ?pallet_or_container - pallet_or_container)
    (container_allocated ?pallet_or_container - pallet_or_container)
    (container_assigned_to_shipment ?pallet_or_container - pallet_or_container ?shipment_unit - shipment_unit)
    (aggregate_ready_for_carrier_assignment ?customer_order_aggregate - customer_order_aggregate)
    (aggregate_carrier_option_selected ?customer_order_aggregate - customer_order_aggregate)
    (aggregate_ready_for_finalization ?customer_order_aggregate - customer_order_aggregate)
    (aggregate_transport_mode_reserved ?customer_order_aggregate - customer_order_aggregate)
    (aggregate_transport_mode_confirmed ?customer_order_aggregate - customer_order_aggregate)
    (aggregate_authorized_for_labeling ?customer_order_aggregate - customer_order_aggregate)
    (aggregate_dispatch_check_passed ?customer_order_aggregate - customer_order_aggregate)
    (routing_preference_available ?routing_preference - routing_preference)
    (aggregate_assigned_routing_preference ?customer_order_aggregate - customer_order_aggregate ?routing_preference - routing_preference)
    (aggregate_routing_preference_attached ?customer_order_aggregate - customer_order_aggregate)
    (aggregate_routing_selection_confirmed ?customer_order_aggregate - customer_order_aggregate)
    (aggregate_routing_time_window_confirmed ?customer_order_aggregate - customer_order_aggregate)
    (transport_mode_available ?transport_mode - transport_mode)
    (aggregate_assigned_transport_mode ?customer_order_aggregate - customer_order_aggregate ?transport_mode - transport_mode)
    (shipping_label_available ?shipping_label - shipping_label)
    (aggregate_assigned_shipping_label ?customer_order_aggregate - customer_order_aggregate ?shipping_label - shipping_label)
    (carrier_option_available ?carrier_option - carrier_option)
    (aggregate_assigned_carrier_option ?customer_order_aggregate - customer_order_aggregate ?carrier_option - carrier_option)
    (delivery_time_window_available ?delivery_time_window - delivery_time_window)
    (aggregate_assigned_delivery_time_window ?customer_order_aggregate - customer_order_aggregate ?delivery_time_window - delivery_time_window)
    (service_level_available ?service_level - service_level)
    (order_entity_assigned_service_level ?order - order ?service_level - service_level)
    (order_line_origin_staged ?order_line_origin - order_line_origin)
    (order_line_destination_staged ?order_line_destination - order_line_destination)
    (dispatch_authorized ?customer_order_aggregate - customer_order_aggregate)
  )
  (:action register_order
    :parameters (?order - order)
    :precondition
      (and
        (not
          (order_entity_registered ?order)
        )
        (not
          (finalized ?order)
        )
      )
    :effect (order_entity_registered ?order)
  )
  (:action assign_order_to_source
    :parameters (?order - order ?inventory_source - inventory_source)
    :precondition
      (and
        (order_entity_registered ?order)
        (not
          (order_entity_sourced ?order)
        )
        (inventory_source_available ?inventory_source)
      )
    :effect
      (and
        (order_entity_sourced ?order)
        (order_entity_assigned_to_inventory_source ?order ?inventory_source)
        (not
          (inventory_source_available ?inventory_source)
        )
      )
  )
  (:action allocate_sku_to_order
    :parameters (?order - order ?product_sku - product_sku)
    :precondition
      (and
        (order_entity_registered ?order)
        (order_entity_sourced ?order)
        (sku_available ?product_sku)
      )
    :effect
      (and
        (order_entity_allocated_sku ?order ?product_sku)
        (not
          (sku_available ?product_sku)
        )
      )
  )
  (:action confirm_order_allocation
    :parameters (?order - order ?product_sku - product_sku)
    :precondition
      (and
        (order_entity_registered ?order)
        (order_entity_sourced ?order)
        (order_entity_allocated_sku ?order ?product_sku)
        (not
          (order_entity_allocated ?order)
        )
      )
    :effect (order_entity_allocated ?order)
  )
  (:action release_sku_allocation
    :parameters (?order - order ?product_sku - product_sku)
    :precondition
      (and
        (order_entity_allocated_sku ?order ?product_sku)
      )
    :effect
      (and
        (sku_available ?product_sku)
        (not
          (order_entity_allocated_sku ?order ?product_sku)
        )
      )
  )
  (:action assign_pack_station_to_order
    :parameters (?order - order ?pack_station - pack_station)
    :precondition
      (and
        (order_entity_allocated ?order)
        (pack_station_available ?pack_station)
      )
    :effect
      (and
        (order_entity_assigned_to_pack_station ?order ?pack_station)
        (not
          (pack_station_available ?pack_station)
        )
      )
  )
  (:action release_pack_station_assignment
    :parameters (?order - order ?pack_station - pack_station)
    :precondition
      (and
        (order_entity_assigned_to_pack_station ?order ?pack_station)
      )
    :effect
      (and
        (pack_station_available ?pack_station)
        (not
          (order_entity_assigned_to_pack_station ?order ?pack_station)
        )
      )
  )
  (:action assign_carrier_option_to_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?carrier_option - carrier_option)
    :precondition
      (and
        (order_entity_allocated ?customer_order_aggregate)
        (carrier_option_available ?carrier_option)
      )
    :effect
      (and
        (aggregate_assigned_carrier_option ?customer_order_aggregate ?carrier_option)
        (not
          (carrier_option_available ?carrier_option)
        )
      )
  )
  (:action unassign_carrier_option_from_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?carrier_option - carrier_option)
    :precondition
      (and
        (aggregate_assigned_carrier_option ?customer_order_aggregate ?carrier_option)
      )
    :effect
      (and
        (carrier_option_available ?carrier_option)
        (not
          (aggregate_assigned_carrier_option ?customer_order_aggregate ?carrier_option)
        )
      )
  )
  (:action assign_delivery_time_window_to_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?delivery_time_window - delivery_time_window)
    :precondition
      (and
        (order_entity_allocated ?customer_order_aggregate)
        (delivery_time_window_available ?delivery_time_window)
      )
    :effect
      (and
        (aggregate_assigned_delivery_time_window ?customer_order_aggregate ?delivery_time_window)
        (not
          (delivery_time_window_available ?delivery_time_window)
        )
      )
  )
  (:action unassign_delivery_time_window_from_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?delivery_time_window - delivery_time_window)
    :precondition
      (and
        (aggregate_assigned_delivery_time_window ?customer_order_aggregate ?delivery_time_window)
      )
    :effect
      (and
        (delivery_time_window_available ?delivery_time_window)
        (not
          (aggregate_assigned_delivery_time_window ?customer_order_aggregate ?delivery_time_window)
        )
      )
  )
  (:action initiate_origin_dock_staging
    :parameters (?order_line_origin - order_line_origin ?origin_loading_dock - origin_loading_dock ?product_sku - product_sku)
    :precondition
      (and
        (order_entity_allocated ?order_line_origin)
        (order_entity_allocated_sku ?order_line_origin ?product_sku)
        (order_line_origin_assigned_to_dock ?order_line_origin ?origin_loading_dock)
        (not
          (origin_loading_dock_staged ?origin_loading_dock)
        )
        (not
          (origin_loading_dock_materials_staged ?origin_loading_dock)
        )
      )
    :effect (origin_loading_dock_staged ?origin_loading_dock)
  )
  (:action confirm_origin_staging_with_pack_station
    :parameters (?order_line_origin - order_line_origin ?origin_loading_dock - origin_loading_dock ?pack_station - pack_station)
    :precondition
      (and
        (order_entity_allocated ?order_line_origin)
        (order_entity_assigned_to_pack_station ?order_line_origin ?pack_station)
        (order_line_origin_assigned_to_dock ?order_line_origin ?origin_loading_dock)
        (origin_loading_dock_staged ?origin_loading_dock)
        (not
          (order_line_origin_staged ?order_line_origin)
        )
      )
    :effect
      (and
        (order_line_origin_staged ?order_line_origin)
        (order_line_origin_ready_for_shipment ?order_line_origin)
      )
  )
  (:action assign_packing_material_and_stage_origin
    :parameters (?order_line_origin - order_line_origin ?origin_loading_dock - origin_loading_dock ?packing_material - packing_material)
    :precondition
      (and
        (order_entity_allocated ?order_line_origin)
        (order_line_origin_assigned_to_dock ?order_line_origin ?origin_loading_dock)
        (packing_material_available ?packing_material)
        (not
          (order_line_origin_staged ?order_line_origin)
        )
      )
    :effect
      (and
        (origin_loading_dock_materials_staged ?origin_loading_dock)
        (order_line_origin_staged ?order_line_origin)
        (order_line_origin_assigned_packing_material ?order_line_origin ?packing_material)
        (not
          (packing_material_available ?packing_material)
        )
      )
  )
  (:action finalize_origin_staging
    :parameters (?order_line_origin - order_line_origin ?origin_loading_dock - origin_loading_dock ?product_sku - product_sku ?packing_material - packing_material)
    :precondition
      (and
        (order_entity_allocated ?order_line_origin)
        (order_entity_allocated_sku ?order_line_origin ?product_sku)
        (order_line_origin_assigned_to_dock ?order_line_origin ?origin_loading_dock)
        (origin_loading_dock_materials_staged ?origin_loading_dock)
        (order_line_origin_assigned_packing_material ?order_line_origin ?packing_material)
        (not
          (order_line_origin_ready_for_shipment ?order_line_origin)
        )
      )
    :effect
      (and
        (origin_loading_dock_staged ?origin_loading_dock)
        (order_line_origin_ready_for_shipment ?order_line_origin)
        (packing_material_available ?packing_material)
        (not
          (order_line_origin_assigned_packing_material ?order_line_origin ?packing_material)
        )
      )
  )
  (:action initiate_destination_dock_staging
    :parameters (?order_line_destination - order_line_destination ?destination_loading_dock - destination_loading_dock ?product_sku - product_sku)
    :precondition
      (and
        (order_entity_allocated ?order_line_destination)
        (order_entity_allocated_sku ?order_line_destination ?product_sku)
        (order_line_destination_assigned_to_dock ?order_line_destination ?destination_loading_dock)
        (not
          (destination_loading_dock_staged ?destination_loading_dock)
        )
        (not
          (destination_loading_dock_materials_staged ?destination_loading_dock)
        )
      )
    :effect (destination_loading_dock_staged ?destination_loading_dock)
  )
  (:action confirm_destination_staging_with_pack_station
    :parameters (?order_line_destination - order_line_destination ?destination_loading_dock - destination_loading_dock ?pack_station - pack_station)
    :precondition
      (and
        (order_entity_allocated ?order_line_destination)
        (order_entity_assigned_to_pack_station ?order_line_destination ?pack_station)
        (order_line_destination_assigned_to_dock ?order_line_destination ?destination_loading_dock)
        (destination_loading_dock_staged ?destination_loading_dock)
        (not
          (order_line_destination_staged ?order_line_destination)
        )
      )
    :effect
      (and
        (order_line_destination_staged ?order_line_destination)
        (order_line_destination_ready_for_shipment ?order_line_destination)
      )
  )
  (:action assign_packing_material_and_stage_destination
    :parameters (?order_line_destination - order_line_destination ?destination_loading_dock - destination_loading_dock ?packing_material - packing_material)
    :precondition
      (and
        (order_entity_allocated ?order_line_destination)
        (order_line_destination_assigned_to_dock ?order_line_destination ?destination_loading_dock)
        (packing_material_available ?packing_material)
        (not
          (order_line_destination_staged ?order_line_destination)
        )
      )
    :effect
      (and
        (destination_loading_dock_materials_staged ?destination_loading_dock)
        (order_line_destination_staged ?order_line_destination)
        (order_line_destination_assigned_packing_material ?order_line_destination ?packing_material)
        (not
          (packing_material_available ?packing_material)
        )
      )
  )
  (:action finalize_destination_staging
    :parameters (?order_line_destination - order_line_destination ?destination_loading_dock - destination_loading_dock ?product_sku - product_sku ?packing_material - packing_material)
    :precondition
      (and
        (order_entity_allocated ?order_line_destination)
        (order_entity_allocated_sku ?order_line_destination ?product_sku)
        (order_line_destination_assigned_to_dock ?order_line_destination ?destination_loading_dock)
        (destination_loading_dock_materials_staged ?destination_loading_dock)
        (order_line_destination_assigned_packing_material ?order_line_destination ?packing_material)
        (not
          (order_line_destination_ready_for_shipment ?order_line_destination)
        )
      )
    :effect
      (and
        (destination_loading_dock_staged ?destination_loading_dock)
        (order_line_destination_ready_for_shipment ?order_line_destination)
        (packing_material_available ?packing_material)
        (not
          (order_line_destination_assigned_packing_material ?order_line_destination ?packing_material)
        )
      )
  )
  (:action form_shipment_standard
    :parameters (?order_line_origin - order_line_origin ?order_line_destination - order_line_destination ?origin_loading_dock - origin_loading_dock ?destination_loading_dock - destination_loading_dock ?shipment_unit - shipment_unit)
    :precondition
      (and
        (order_line_origin_staged ?order_line_origin)
        (order_line_destination_staged ?order_line_destination)
        (order_line_origin_assigned_to_dock ?order_line_origin ?origin_loading_dock)
        (order_line_destination_assigned_to_dock ?order_line_destination ?destination_loading_dock)
        (origin_loading_dock_staged ?origin_loading_dock)
        (destination_loading_dock_staged ?destination_loading_dock)
        (order_line_origin_ready_for_shipment ?order_line_origin)
        (order_line_destination_ready_for_shipment ?order_line_destination)
        (shipment_open ?shipment_unit)
      )
    :effect
      (and
        (shipment_created ?shipment_unit)
        (shipment_assigned_origin_dock ?shipment_unit ?origin_loading_dock)
        (shipment_assigned_destination_dock ?shipment_unit ?destination_loading_dock)
        (not
          (shipment_open ?shipment_unit)
        )
      )
  )
  (:action form_shipment_with_origin_materials
    :parameters (?order_line_origin - order_line_origin ?order_line_destination - order_line_destination ?origin_loading_dock - origin_loading_dock ?destination_loading_dock - destination_loading_dock ?shipment_unit - shipment_unit)
    :precondition
      (and
        (order_line_origin_staged ?order_line_origin)
        (order_line_destination_staged ?order_line_destination)
        (order_line_origin_assigned_to_dock ?order_line_origin ?origin_loading_dock)
        (order_line_destination_assigned_to_dock ?order_line_destination ?destination_loading_dock)
        (origin_loading_dock_materials_staged ?origin_loading_dock)
        (destination_loading_dock_staged ?destination_loading_dock)
        (not
          (order_line_origin_ready_for_shipment ?order_line_origin)
        )
        (order_line_destination_ready_for_shipment ?order_line_destination)
        (shipment_open ?shipment_unit)
      )
    :effect
      (and
        (shipment_created ?shipment_unit)
        (shipment_assigned_origin_dock ?shipment_unit ?origin_loading_dock)
        (shipment_assigned_destination_dock ?shipment_unit ?destination_loading_dock)
        (shipment_origin_materials_flag ?shipment_unit)
        (not
          (shipment_open ?shipment_unit)
        )
      )
  )
  (:action form_shipment_with_destination_materials
    :parameters (?order_line_origin - order_line_origin ?order_line_destination - order_line_destination ?origin_loading_dock - origin_loading_dock ?destination_loading_dock - destination_loading_dock ?shipment_unit - shipment_unit)
    :precondition
      (and
        (order_line_origin_staged ?order_line_origin)
        (order_line_destination_staged ?order_line_destination)
        (order_line_origin_assigned_to_dock ?order_line_origin ?origin_loading_dock)
        (order_line_destination_assigned_to_dock ?order_line_destination ?destination_loading_dock)
        (origin_loading_dock_staged ?origin_loading_dock)
        (destination_loading_dock_materials_staged ?destination_loading_dock)
        (order_line_origin_ready_for_shipment ?order_line_origin)
        (not
          (order_line_destination_ready_for_shipment ?order_line_destination)
        )
        (shipment_open ?shipment_unit)
      )
    :effect
      (and
        (shipment_created ?shipment_unit)
        (shipment_assigned_origin_dock ?shipment_unit ?origin_loading_dock)
        (shipment_assigned_destination_dock ?shipment_unit ?destination_loading_dock)
        (shipment_destination_materials_flag ?shipment_unit)
        (not
          (shipment_open ?shipment_unit)
        )
      )
  )
  (:action form_shipment_with_both_materials
    :parameters (?order_line_origin - order_line_origin ?order_line_destination - order_line_destination ?origin_loading_dock - origin_loading_dock ?destination_loading_dock - destination_loading_dock ?shipment_unit - shipment_unit)
    :precondition
      (and
        (order_line_origin_staged ?order_line_origin)
        (order_line_destination_staged ?order_line_destination)
        (order_line_origin_assigned_to_dock ?order_line_origin ?origin_loading_dock)
        (order_line_destination_assigned_to_dock ?order_line_destination ?destination_loading_dock)
        (origin_loading_dock_materials_staged ?origin_loading_dock)
        (destination_loading_dock_materials_staged ?destination_loading_dock)
        (not
          (order_line_origin_ready_for_shipment ?order_line_origin)
        )
        (not
          (order_line_destination_ready_for_shipment ?order_line_destination)
        )
        (shipment_open ?shipment_unit)
      )
    :effect
      (and
        (shipment_created ?shipment_unit)
        (shipment_assigned_origin_dock ?shipment_unit ?origin_loading_dock)
        (shipment_assigned_destination_dock ?shipment_unit ?destination_loading_dock)
        (shipment_origin_materials_flag ?shipment_unit)
        (shipment_destination_materials_flag ?shipment_unit)
        (not
          (shipment_open ?shipment_unit)
        )
      )
  )
  (:action mark_shipment_ready_for_containerization
    :parameters (?shipment_unit - shipment_unit ?order_line_origin - order_line_origin ?product_sku - product_sku)
    :precondition
      (and
        (shipment_created ?shipment_unit)
        (order_line_origin_staged ?order_line_origin)
        (order_entity_allocated_sku ?order_line_origin ?product_sku)
        (not
          (shipment_ready_for_containerization ?shipment_unit)
        )
      )
    :effect (shipment_ready_for_containerization ?shipment_unit)
  )
  (:action allocate_container_and_attach_to_shipment
    :parameters (?customer_order_aggregate - customer_order_aggregate ?pallet_or_container - pallet_or_container ?shipment_unit - shipment_unit)
    :precondition
      (and
        (order_entity_allocated ?customer_order_aggregate)
        (aggregate_assigned_to_shipment ?customer_order_aggregate ?shipment_unit)
        (aggregate_assigned_container ?customer_order_aggregate ?pallet_or_container)
        (container_available ?pallet_or_container)
        (shipment_created ?shipment_unit)
        (shipment_ready_for_containerization ?shipment_unit)
        (not
          (container_allocated ?pallet_or_container)
        )
      )
    :effect
      (and
        (container_allocated ?pallet_or_container)
        (container_assigned_to_shipment ?pallet_or_container ?shipment_unit)
        (not
          (container_available ?pallet_or_container)
        )
      )
  )
  (:action prepare_aggregate_for_carrier_assignment
    :parameters (?customer_order_aggregate - customer_order_aggregate ?pallet_or_container - pallet_or_container ?shipment_unit - shipment_unit ?product_sku - product_sku)
    :precondition
      (and
        (order_entity_allocated ?customer_order_aggregate)
        (aggregate_assigned_container ?customer_order_aggregate ?pallet_or_container)
        (container_allocated ?pallet_or_container)
        (container_assigned_to_shipment ?pallet_or_container ?shipment_unit)
        (order_entity_allocated_sku ?customer_order_aggregate ?product_sku)
        (not
          (shipment_origin_materials_flag ?shipment_unit)
        )
        (not
          (aggregate_ready_for_carrier_assignment ?customer_order_aggregate)
        )
      )
    :effect (aggregate_ready_for_carrier_assignment ?customer_order_aggregate)
  )
  (:action assign_transport_mode_to_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?transport_mode - transport_mode)
    :precondition
      (and
        (order_entity_allocated ?customer_order_aggregate)
        (transport_mode_available ?transport_mode)
        (not
          (aggregate_transport_mode_reserved ?customer_order_aggregate)
        )
      )
    :effect
      (and
        (aggregate_transport_mode_reserved ?customer_order_aggregate)
        (aggregate_assigned_transport_mode ?customer_order_aggregate ?transport_mode)
        (not
          (transport_mode_available ?transport_mode)
        )
      )
  )
  (:action confirm_transport_mode_and_enable_carrier_assignment
    :parameters (?customer_order_aggregate - customer_order_aggregate ?pallet_or_container - pallet_or_container ?shipment_unit - shipment_unit ?product_sku - product_sku ?transport_mode - transport_mode)
    :precondition
      (and
        (order_entity_allocated ?customer_order_aggregate)
        (aggregate_assigned_container ?customer_order_aggregate ?pallet_or_container)
        (container_allocated ?pallet_or_container)
        (container_assigned_to_shipment ?pallet_or_container ?shipment_unit)
        (order_entity_allocated_sku ?customer_order_aggregate ?product_sku)
        (shipment_origin_materials_flag ?shipment_unit)
        (aggregate_transport_mode_reserved ?customer_order_aggregate)
        (aggregate_assigned_transport_mode ?customer_order_aggregate ?transport_mode)
        (not
          (aggregate_ready_for_carrier_assignment ?customer_order_aggregate)
        )
      )
    :effect
      (and
        (aggregate_ready_for_carrier_assignment ?customer_order_aggregate)
        (aggregate_transport_mode_confirmed ?customer_order_aggregate)
      )
  )
  (:action select_carrier_option_for_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?carrier_option - carrier_option ?pack_station - pack_station ?pallet_or_container - pallet_or_container ?shipment_unit - shipment_unit)
    :precondition
      (and
        (aggregate_ready_for_carrier_assignment ?customer_order_aggregate)
        (aggregate_assigned_carrier_option ?customer_order_aggregate ?carrier_option)
        (order_entity_assigned_to_pack_station ?customer_order_aggregate ?pack_station)
        (aggregate_assigned_container ?customer_order_aggregate ?pallet_or_container)
        (container_assigned_to_shipment ?pallet_or_container ?shipment_unit)
        (not
          (shipment_destination_materials_flag ?shipment_unit)
        )
        (not
          (aggregate_carrier_option_selected ?customer_order_aggregate)
        )
      )
    :effect (aggregate_carrier_option_selected ?customer_order_aggregate)
  )
  (:action select_carrier_option_for_aggregate_alternate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?carrier_option - carrier_option ?pack_station - pack_station ?pallet_or_container - pallet_or_container ?shipment_unit - shipment_unit)
    :precondition
      (and
        (aggregate_ready_for_carrier_assignment ?customer_order_aggregate)
        (aggregate_assigned_carrier_option ?customer_order_aggregate ?carrier_option)
        (order_entity_assigned_to_pack_station ?customer_order_aggregate ?pack_station)
        (aggregate_assigned_container ?customer_order_aggregate ?pallet_or_container)
        (container_assigned_to_shipment ?pallet_or_container ?shipment_unit)
        (shipment_destination_materials_flag ?shipment_unit)
        (not
          (aggregate_carrier_option_selected ?customer_order_aggregate)
        )
      )
    :effect (aggregate_carrier_option_selected ?customer_order_aggregate)
  )
  (:action confirm_carrier_and_time_window_for_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?delivery_time_window - delivery_time_window ?pallet_or_container - pallet_or_container ?shipment_unit - shipment_unit)
    :precondition
      (and
        (aggregate_carrier_option_selected ?customer_order_aggregate)
        (aggregate_assigned_delivery_time_window ?customer_order_aggregate ?delivery_time_window)
        (aggregate_assigned_container ?customer_order_aggregate ?pallet_or_container)
        (container_assigned_to_shipment ?pallet_or_container ?shipment_unit)
        (not
          (shipment_origin_materials_flag ?shipment_unit)
        )
        (not
          (shipment_destination_materials_flag ?shipment_unit)
        )
        (not
          (aggregate_ready_for_finalization ?customer_order_aggregate)
        )
      )
    :effect (aggregate_ready_for_finalization ?customer_order_aggregate)
  )
  (:action confirm_carrier_time_and_origin_material
    :parameters (?customer_order_aggregate - customer_order_aggregate ?delivery_time_window - delivery_time_window ?pallet_or_container - pallet_or_container ?shipment_unit - shipment_unit)
    :precondition
      (and
        (aggregate_carrier_option_selected ?customer_order_aggregate)
        (aggregate_assigned_delivery_time_window ?customer_order_aggregate ?delivery_time_window)
        (aggregate_assigned_container ?customer_order_aggregate ?pallet_or_container)
        (container_assigned_to_shipment ?pallet_or_container ?shipment_unit)
        (shipment_origin_materials_flag ?shipment_unit)
        (not
          (shipment_destination_materials_flag ?shipment_unit)
        )
        (not
          (aggregate_ready_for_finalization ?customer_order_aggregate)
        )
      )
    :effect
      (and
        (aggregate_ready_for_finalization ?customer_order_aggregate)
        (aggregate_authorized_for_labeling ?customer_order_aggregate)
      )
  )
  (:action confirm_carrier_time_and_destination_material
    :parameters (?customer_order_aggregate - customer_order_aggregate ?delivery_time_window - delivery_time_window ?pallet_or_container - pallet_or_container ?shipment_unit - shipment_unit)
    :precondition
      (and
        (aggregate_carrier_option_selected ?customer_order_aggregate)
        (aggregate_assigned_delivery_time_window ?customer_order_aggregate ?delivery_time_window)
        (aggregate_assigned_container ?customer_order_aggregate ?pallet_or_container)
        (container_assigned_to_shipment ?pallet_or_container ?shipment_unit)
        (not
          (shipment_origin_materials_flag ?shipment_unit)
        )
        (shipment_destination_materials_flag ?shipment_unit)
        (not
          (aggregate_ready_for_finalization ?customer_order_aggregate)
        )
      )
    :effect
      (and
        (aggregate_ready_for_finalization ?customer_order_aggregate)
        (aggregate_authorized_for_labeling ?customer_order_aggregate)
      )
  )
  (:action confirm_carrier_time_and_both_materials_for_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?delivery_time_window - delivery_time_window ?pallet_or_container - pallet_or_container ?shipment_unit - shipment_unit)
    :precondition
      (and
        (aggregate_carrier_option_selected ?customer_order_aggregate)
        (aggregate_assigned_delivery_time_window ?customer_order_aggregate ?delivery_time_window)
        (aggregate_assigned_container ?customer_order_aggregate ?pallet_or_container)
        (container_assigned_to_shipment ?pallet_or_container ?shipment_unit)
        (shipment_origin_materials_flag ?shipment_unit)
        (shipment_destination_materials_flag ?shipment_unit)
        (not
          (aggregate_ready_for_finalization ?customer_order_aggregate)
        )
      )
    :effect
      (and
        (aggregate_ready_for_finalization ?customer_order_aggregate)
        (aggregate_authorized_for_labeling ?customer_order_aggregate)
      )
  )
  (:action authorize_aggregate_dispatch
    :parameters (?customer_order_aggregate - customer_order_aggregate)
    :precondition
      (and
        (aggregate_ready_for_finalization ?customer_order_aggregate)
        (not
          (aggregate_authorized_for_labeling ?customer_order_aggregate)
        )
        (not
          (dispatch_authorized ?customer_order_aggregate)
        )
      )
    :effect
      (and
        (dispatch_authorized ?customer_order_aggregate)
        (dispatched ?customer_order_aggregate)
      )
  )
  (:action attach_shipping_label_to_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?shipping_label - shipping_label)
    :precondition
      (and
        (aggregate_ready_for_finalization ?customer_order_aggregate)
        (aggregate_authorized_for_labeling ?customer_order_aggregate)
        (shipping_label_available ?shipping_label)
      )
    :effect
      (and
        (aggregate_assigned_shipping_label ?customer_order_aggregate ?shipping_label)
        (not
          (shipping_label_available ?shipping_label)
        )
      )
  )
  (:action perform_final_dispatch_checks_on_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?order_line_origin - order_line_origin ?order_line_destination - order_line_destination ?product_sku - product_sku ?shipping_label - shipping_label)
    :precondition
      (and
        (aggregate_ready_for_finalization ?customer_order_aggregate)
        (aggregate_authorized_for_labeling ?customer_order_aggregate)
        (aggregate_assigned_shipping_label ?customer_order_aggregate ?shipping_label)
        (aggregate_contains_origin_line ?customer_order_aggregate ?order_line_origin)
        (aggregate_contains_destination_line ?customer_order_aggregate ?order_line_destination)
        (order_line_origin_ready_for_shipment ?order_line_origin)
        (order_line_destination_ready_for_shipment ?order_line_destination)
        (order_entity_allocated_sku ?customer_order_aggregate ?product_sku)
        (not
          (aggregate_dispatch_check_passed ?customer_order_aggregate)
        )
      )
    :effect (aggregate_dispatch_check_passed ?customer_order_aggregate)
  )
  (:action finalize_aggregate_dispatch
    :parameters (?customer_order_aggregate - customer_order_aggregate)
    :precondition
      (and
        (aggregate_ready_for_finalization ?customer_order_aggregate)
        (aggregate_dispatch_check_passed ?customer_order_aggregate)
        (not
          (dispatch_authorized ?customer_order_aggregate)
        )
      )
    :effect
      (and
        (dispatch_authorized ?customer_order_aggregate)
        (dispatched ?customer_order_aggregate)
      )
  )
  (:action assign_routing_preference_to_aggregate
    :parameters (?customer_order_aggregate - customer_order_aggregate ?routing_preference - routing_preference ?product_sku - product_sku)
    :precondition
      (and
        (order_entity_allocated ?customer_order_aggregate)
        (order_entity_allocated_sku ?customer_order_aggregate ?product_sku)
        (routing_preference_available ?routing_preference)
        (aggregate_assigned_routing_preference ?customer_order_aggregate ?routing_preference)
        (not
          (aggregate_routing_preference_attached ?customer_order_aggregate)
        )
      )
    :effect
      (and
        (aggregate_routing_preference_attached ?customer_order_aggregate)
        (not
          (routing_preference_available ?routing_preference)
        )
      )
  )
  (:action confirm_routing_selection
    :parameters (?customer_order_aggregate - customer_order_aggregate ?pack_station - pack_station)
    :precondition
      (and
        (aggregate_routing_preference_attached ?customer_order_aggregate)
        (order_entity_assigned_to_pack_station ?customer_order_aggregate ?pack_station)
        (not
          (aggregate_routing_selection_confirmed ?customer_order_aggregate)
        )
      )
    :effect (aggregate_routing_selection_confirmed ?customer_order_aggregate)
  )
  (:action confirm_routing_time_window
    :parameters (?customer_order_aggregate - customer_order_aggregate ?delivery_time_window - delivery_time_window)
    :precondition
      (and
        (aggregate_routing_selection_confirmed ?customer_order_aggregate)
        (aggregate_assigned_delivery_time_window ?customer_order_aggregate ?delivery_time_window)
        (not
          (aggregate_routing_time_window_confirmed ?customer_order_aggregate)
        )
      )
    :effect (aggregate_routing_time_window_confirmed ?customer_order_aggregate)
  )
  (:action authorize_routing_based_dispatch
    :parameters (?customer_order_aggregate - customer_order_aggregate)
    :precondition
      (and
        (aggregate_routing_time_window_confirmed ?customer_order_aggregate)
        (not
          (dispatch_authorized ?customer_order_aggregate)
        )
      )
    :effect
      (and
        (dispatch_authorized ?customer_order_aggregate)
        (dispatched ?customer_order_aggregate)
      )
  )
  (:action mark_origin_line_shipped
    :parameters (?order_line_origin - order_line_origin ?shipment_unit - shipment_unit)
    :precondition
      (and
        (order_line_origin_staged ?order_line_origin)
        (order_line_origin_ready_for_shipment ?order_line_origin)
        (shipment_created ?shipment_unit)
        (shipment_ready_for_containerization ?shipment_unit)
        (not
          (dispatched ?order_line_origin)
        )
      )
    :effect (dispatched ?order_line_origin)
  )
  (:action mark_destination_line_shipped
    :parameters (?order_line_destination - order_line_destination ?shipment_unit - shipment_unit)
    :precondition
      (and
        (order_line_destination_staged ?order_line_destination)
        (order_line_destination_ready_for_shipment ?order_line_destination)
        (shipment_created ?shipment_unit)
        (shipment_ready_for_containerization ?shipment_unit)
        (not
          (dispatched ?order_line_destination)
        )
      )
    :effect (dispatched ?order_line_destination)
  )
  (:action release_order_with_service_level
    :parameters (?order - order ?service_level - service_level ?product_sku - product_sku)
    :precondition
      (and
        (dispatched ?order)
        (order_entity_allocated_sku ?order ?product_sku)
        (service_level_available ?service_level)
        (not
          (order_entity_released ?order)
        )
      )
    :effect
      (and
        (order_entity_released ?order)
        (order_entity_assigned_service_level ?order ?service_level)
        (not
          (service_level_available ?service_level)
        )
      )
  )
  (:action finalize_origin_sourcing_and_release_resources
    :parameters (?order_line_origin - order_line_origin ?inventory_source - inventory_source ?service_level - service_level)
    :precondition
      (and
        (order_entity_released ?order_line_origin)
        (order_entity_assigned_to_inventory_source ?order_line_origin ?inventory_source)
        (order_entity_assigned_service_level ?order_line_origin ?service_level)
        (not
          (finalized ?order_line_origin)
        )
      )
    :effect
      (and
        (finalized ?order_line_origin)
        (inventory_source_available ?inventory_source)
        (service_level_available ?service_level)
      )
  )
  (:action finalize_destination_sourcing_and_release_resources
    :parameters (?order_line_destination - order_line_destination ?inventory_source - inventory_source ?service_level - service_level)
    :precondition
      (and
        (order_entity_released ?order_line_destination)
        (order_entity_assigned_to_inventory_source ?order_line_destination ?inventory_source)
        (order_entity_assigned_service_level ?order_line_destination ?service_level)
        (not
          (finalized ?order_line_destination)
        )
      )
    :effect
      (and
        (finalized ?order_line_destination)
        (inventory_source_available ?inventory_source)
        (service_level_available ?service_level)
      )
  )
  (:action finalize_aggregate_sourcing_and_release_resources
    :parameters (?customer_order_aggregate - customer_order_aggregate ?inventory_source - inventory_source ?service_level - service_level)
    :precondition
      (and
        (order_entity_released ?customer_order_aggregate)
        (order_entity_assigned_to_inventory_source ?customer_order_aggregate ?inventory_source)
        (order_entity_assigned_service_level ?customer_order_aggregate ?service_level)
        (not
          (finalized ?customer_order_aggregate)
        )
      )
    :effect
      (and
        (finalized ?customer_order_aggregate)
        (inventory_source_available ?inventory_source)
        (service_level_available ?service_level)
      )
  )
)

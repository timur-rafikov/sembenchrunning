(define (domain pickup_and_delivery_pairing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object resource_category - entity location_category - entity node_category - entity order_category_group - entity order - order_category_group vehicle - resource_category commodity_class - resource_category operator - resource_category equipment_type - resource_category load_requirement - resource_category time_window - resource_category equipment_id - resource_category regulatory_clearance - resource_category package_unit - location_category load_unit - location_category handling_code - location_category origin_location - node_category destination_location - node_category vehicle_trip - node_category stop_category_group - order route_category_group - order pickup_stop - stop_category_group delivery_stop - stop_category_group route_plan - route_category_group)

  (:predicates
    (shipment_created ?order - order)
    (shipment_ready ?order - order)
    (shipment_allocated ?order - order)
    (shipment_assignment_confirmed ?order - order)
    (active_for_dispatch ?order - order)
    (shipment_finalized ?order - order)
    (vehicle_available ?vehicle - vehicle)
    (shipment_assigned_vehicle ?order - order ?vehicle - vehicle)
    (commodity_available ?commodity_class - commodity_class)
    (shipment_commodity_assigned ?order - order ?commodity_class - commodity_class)
    (operator_available ?operator - operator)
    (shipment_assigned_operator ?order - order ?operator - operator)
    (package_available ?package_unit - package_unit)
    (pickup_stop_has_package ?pickup_stop - pickup_stop ?package_unit - package_unit)
    (delivery_stop_has_package ?delivery_stop - delivery_stop ?package_unit - package_unit)
    (stop_origin_location ?pickup_stop - pickup_stop ?origin_location - origin_location)
    (origin_staged ?origin_location - origin_location)
    (origin_loaded ?origin_location - origin_location)
    (pickup_stop_ready ?pickup_stop - pickup_stop)
    (stop_destination_location ?delivery_stop - delivery_stop ?destination_location - destination_location)
    (destination_staged ?destination_location - destination_location)
    (destination_loaded ?destination_location - destination_location)
    (delivery_stop_ready ?delivery_stop - delivery_stop)
    (trip_available ?vehicle_trip - vehicle_trip)
    (trip_allocated ?vehicle_trip - vehicle_trip)
    (trip_origin_location ?vehicle_trip - vehicle_trip ?origin_location - origin_location)
    (trip_destination_location ?vehicle_trip - vehicle_trip ?destination_location - destination_location)
    (trip_origin_loaded ?vehicle_trip - vehicle_trip)
    (trip_destination_loaded ?vehicle_trip - vehicle_trip)
    (trip_ready_for_loading ?vehicle_trip - vehicle_trip)
    (route_includes_pickup_stop ?route_plan - route_plan ?pickup_stop - pickup_stop)
    (route_includes_delivery_stop ?route_plan - route_plan ?delivery_stop - delivery_stop)
    (route_assigned_trip ?route_plan - route_plan ?vehicle_trip - vehicle_trip)
    (load_unit_available ?load_unit - load_unit)
    (route_includes_load_unit ?route_plan - route_plan ?load_unit - load_unit)
    (load_unit_loaded ?load_unit - load_unit)
    (load_unit_assigned_trip ?load_unit - load_unit ?vehicle_trip - vehicle_trip)
    (route_container_attached ?route_plan - route_plan)
    (route_container_prepared ?route_plan - route_plan)
    (route_verified ?route_plan - route_plan)
    (route_equipment_allocated ?route_plan - route_plan)
    (route_equipment_confirmed ?route_plan - route_plan)
    (route_handling_applied ?route_plan - route_plan)
    (route_ready_for_dispatch ?route_plan - route_plan)
    (handling_code_available ?handling_code - handling_code)
    (route_has_handling_code ?route_plan - route_plan ?handling_code - handling_code)
    (handling_code_committed ?route_plan - route_plan)
    (handling_operator_assigned ?route_plan - route_plan)
    (handling_verified ?route_plan - route_plan)
    (equipment_type_available ?equipment_type - equipment_type)
    (route_requires_equipment_type ?route_plan - route_plan ?equipment_type - equipment_type)
    (load_requirement_available ?load_requirement - load_requirement)
    (route_load_requirement ?route_plan - route_plan ?load_requirement - load_requirement)
    (equipment_id_available ?equipment_id - equipment_id)
    (route_equipment_id_assigned ?route_plan - route_plan ?equipment_id - equipment_id)
    (regulatory_clearance_available ?regulatory_clearance - regulatory_clearance)
    (route_regulatory_clearance_attached ?route_plan - route_plan ?regulatory_clearance - regulatory_clearance)
    (time_window_available ?time_window - time_window)
    (shipment_time_window ?order - order ?time_window - time_window)
    (pickup_stop_staged_for_loading ?pickup_stop - pickup_stop)
    (delivery_stop_staged_for_loading ?delivery_stop - delivery_stop)
    (route_finalized ?route_plan - route_plan)
  )
  (:action create_order
    :parameters (?order - order)
    :precondition
      (and
        (not
          (shipment_created ?order)
        )
        (not
          (shipment_assignment_confirmed ?order)
        )
      )
    :effect (shipment_created ?order)
  )
  (:action assign_vehicle_to_order
    :parameters (?order - order ?vehicle - vehicle)
    :precondition
      (and
        (shipment_created ?order)
        (not
          (shipment_allocated ?order)
        )
        (vehicle_available ?vehicle)
      )
    :effect
      (and
        (shipment_allocated ?order)
        (shipment_assigned_vehicle ?order ?vehicle)
        (not
          (vehicle_available ?vehicle)
        )
      )
  )
  (:action attach_commodity_to_order
    :parameters (?order - order ?commodity_class - commodity_class)
    :precondition
      (and
        (shipment_created ?order)
        (shipment_allocated ?order)
        (commodity_available ?commodity_class)
      )
    :effect
      (and
        (shipment_commodity_assigned ?order ?commodity_class)
        (not
          (commodity_available ?commodity_class)
        )
      )
  )
  (:action mark_order_ready
    :parameters (?order - order ?commodity_class - commodity_class)
    :precondition
      (and
        (shipment_created ?order)
        (shipment_allocated ?order)
        (shipment_commodity_assigned ?order ?commodity_class)
        (not
          (shipment_ready ?order)
        )
      )
    :effect (shipment_ready ?order)
  )
  (:action release_commodity_from_order
    :parameters (?order - order ?commodity_class - commodity_class)
    :precondition
      (and
        (shipment_commodity_assigned ?order ?commodity_class)
      )
    :effect
      (and
        (commodity_available ?commodity_class)
        (not
          (shipment_commodity_assigned ?order ?commodity_class)
        )
      )
  )
  (:action assign_operator_to_order
    :parameters (?order - order ?operator - operator)
    :precondition
      (and
        (shipment_ready ?order)
        (operator_available ?operator)
      )
    :effect
      (and
        (shipment_assigned_operator ?order ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action unassign_operator_from_order
    :parameters (?order - order ?operator - operator)
    :precondition
      (and
        (shipment_assigned_operator ?order ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (shipment_assigned_operator ?order ?operator)
        )
      )
  )
  (:action attach_equipment_id_to_route
    :parameters (?route_plan - route_plan ?equipment_id - equipment_id)
    :precondition
      (and
        (shipment_ready ?route_plan)
        (equipment_id_available ?equipment_id)
      )
    :effect
      (and
        (route_equipment_id_assigned ?route_plan ?equipment_id)
        (not
          (equipment_id_available ?equipment_id)
        )
      )
  )
  (:action detach_equipment_id_from_route
    :parameters (?route_plan - route_plan ?equipment_id - equipment_id)
    :precondition
      (and
        (route_equipment_id_assigned ?route_plan ?equipment_id)
      )
    :effect
      (and
        (equipment_id_available ?equipment_id)
        (not
          (route_equipment_id_assigned ?route_plan ?equipment_id)
        )
      )
  )
  (:action attach_regulatory_clearance_to_route
    :parameters (?route_plan - route_plan ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (shipment_ready ?route_plan)
        (regulatory_clearance_available ?regulatory_clearance)
      )
    :effect
      (and
        (route_regulatory_clearance_attached ?route_plan ?regulatory_clearance)
        (not
          (regulatory_clearance_available ?regulatory_clearance)
        )
      )
  )
  (:action detach_regulatory_clearance_from_route
    :parameters (?route_plan - route_plan ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (route_regulatory_clearance_attached ?route_plan ?regulatory_clearance)
      )
    :effect
      (and
        (regulatory_clearance_available ?regulatory_clearance)
        (not
          (route_regulatory_clearance_attached ?route_plan ?regulatory_clearance)
        )
      )
  )
  (:action stage_pickup_at_origin
    :parameters (?pickup_stop - pickup_stop ?origin_location - origin_location ?commodity_class - commodity_class)
    :precondition
      (and
        (shipment_ready ?pickup_stop)
        (shipment_commodity_assigned ?pickup_stop ?commodity_class)
        (stop_origin_location ?pickup_stop ?origin_location)
        (not
          (origin_staged ?origin_location)
        )
        (not
          (origin_loaded ?origin_location)
        )
      )
    :effect (origin_staged ?origin_location)
  )
  (:action assign_operator_to_pickup
    :parameters (?pickup_stop - pickup_stop ?origin_location - origin_location ?operator - operator)
    :precondition
      (and
        (shipment_ready ?pickup_stop)
        (shipment_assigned_operator ?pickup_stop ?operator)
        (stop_origin_location ?pickup_stop ?origin_location)
        (origin_staged ?origin_location)
        (not
          (pickup_stop_staged_for_loading ?pickup_stop)
        )
      )
    :effect
      (and
        (pickup_stop_staged_for_loading ?pickup_stop)
        (pickup_stop_ready ?pickup_stop)
      )
  )
  (:action load_package_onto_pickup
    :parameters (?pickup_stop - pickup_stop ?origin_location - origin_location ?package_unit - package_unit)
    :precondition
      (and
        (shipment_ready ?pickup_stop)
        (stop_origin_location ?pickup_stop ?origin_location)
        (package_available ?package_unit)
        (not
          (pickup_stop_staged_for_loading ?pickup_stop)
        )
      )
    :effect
      (and
        (origin_loaded ?origin_location)
        (pickup_stop_staged_for_loading ?pickup_stop)
        (pickup_stop_has_package ?pickup_stop ?package_unit)
        (not
          (package_available ?package_unit)
        )
      )
  )
  (:action finalize_pickup_loading
    :parameters (?pickup_stop - pickup_stop ?origin_location - origin_location ?commodity_class - commodity_class ?package_unit - package_unit)
    :precondition
      (and
        (shipment_ready ?pickup_stop)
        (shipment_commodity_assigned ?pickup_stop ?commodity_class)
        (stop_origin_location ?pickup_stop ?origin_location)
        (origin_loaded ?origin_location)
        (pickup_stop_has_package ?pickup_stop ?package_unit)
        (not
          (pickup_stop_ready ?pickup_stop)
        )
      )
    :effect
      (and
        (origin_staged ?origin_location)
        (pickup_stop_ready ?pickup_stop)
        (package_available ?package_unit)
        (not
          (pickup_stop_has_package ?pickup_stop ?package_unit)
        )
      )
  )
  (:action stage_delivery_at_destination
    :parameters (?delivery_stop - delivery_stop ?destination_location - destination_location ?commodity_class - commodity_class)
    :precondition
      (and
        (shipment_ready ?delivery_stop)
        (shipment_commodity_assigned ?delivery_stop ?commodity_class)
        (stop_destination_location ?delivery_stop ?destination_location)
        (not
          (destination_staged ?destination_location)
        )
        (not
          (destination_loaded ?destination_location)
        )
      )
    :effect (destination_staged ?destination_location)
  )
  (:action assign_operator_to_delivery
    :parameters (?delivery_stop - delivery_stop ?destination_location - destination_location ?operator - operator)
    :precondition
      (and
        (shipment_ready ?delivery_stop)
        (shipment_assigned_operator ?delivery_stop ?operator)
        (stop_destination_location ?delivery_stop ?destination_location)
        (destination_staged ?destination_location)
        (not
          (delivery_stop_staged_for_loading ?delivery_stop)
        )
      )
    :effect
      (and
        (delivery_stop_staged_for_loading ?delivery_stop)
        (delivery_stop_ready ?delivery_stop)
      )
  )
  (:action load_package_for_delivery
    :parameters (?delivery_stop - delivery_stop ?destination_location - destination_location ?package_unit - package_unit)
    :precondition
      (and
        (shipment_ready ?delivery_stop)
        (stop_destination_location ?delivery_stop ?destination_location)
        (package_available ?package_unit)
        (not
          (delivery_stop_staged_for_loading ?delivery_stop)
        )
      )
    :effect
      (and
        (destination_loaded ?destination_location)
        (delivery_stop_staged_for_loading ?delivery_stop)
        (delivery_stop_has_package ?delivery_stop ?package_unit)
        (not
          (package_available ?package_unit)
        )
      )
  )
  (:action finalize_delivery_loading
    :parameters (?delivery_stop - delivery_stop ?destination_location - destination_location ?commodity_class - commodity_class ?package_unit - package_unit)
    :precondition
      (and
        (shipment_ready ?delivery_stop)
        (shipment_commodity_assigned ?delivery_stop ?commodity_class)
        (stop_destination_location ?delivery_stop ?destination_location)
        (destination_loaded ?destination_location)
        (delivery_stop_has_package ?delivery_stop ?package_unit)
        (not
          (delivery_stop_ready ?delivery_stop)
        )
      )
    :effect
      (and
        (destination_staged ?destination_location)
        (delivery_stop_ready ?delivery_stop)
        (package_available ?package_unit)
        (not
          (delivery_stop_has_package ?delivery_stop ?package_unit)
        )
      )
  )
  (:action form_trip_from_staged_stops
    :parameters (?pickup_stop - pickup_stop ?delivery_stop - delivery_stop ?origin_location - origin_location ?destination_location - destination_location ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (pickup_stop_staged_for_loading ?pickup_stop)
        (delivery_stop_staged_for_loading ?delivery_stop)
        (stop_origin_location ?pickup_stop ?origin_location)
        (stop_destination_location ?delivery_stop ?destination_location)
        (origin_staged ?origin_location)
        (destination_staged ?destination_location)
        (pickup_stop_ready ?pickup_stop)
        (delivery_stop_ready ?delivery_stop)
        (trip_available ?vehicle_trip)
      )
    :effect
      (and
        (trip_allocated ?vehicle_trip)
        (trip_origin_location ?vehicle_trip ?origin_location)
        (trip_destination_location ?vehicle_trip ?destination_location)
        (not
          (trip_available ?vehicle_trip)
        )
      )
  )
  (:action form_trip_with_origin_loaded
    :parameters (?pickup_stop - pickup_stop ?delivery_stop - delivery_stop ?origin_location - origin_location ?destination_location - destination_location ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (pickup_stop_staged_for_loading ?pickup_stop)
        (delivery_stop_staged_for_loading ?delivery_stop)
        (stop_origin_location ?pickup_stop ?origin_location)
        (stop_destination_location ?delivery_stop ?destination_location)
        (origin_loaded ?origin_location)
        (destination_staged ?destination_location)
        (not
          (pickup_stop_ready ?pickup_stop)
        )
        (delivery_stop_ready ?delivery_stop)
        (trip_available ?vehicle_trip)
      )
    :effect
      (and
        (trip_allocated ?vehicle_trip)
        (trip_origin_location ?vehicle_trip ?origin_location)
        (trip_destination_location ?vehicle_trip ?destination_location)
        (trip_origin_loaded ?vehicle_trip)
        (not
          (trip_available ?vehicle_trip)
        )
      )
  )
  (:action form_trip_with_destination_loaded
    :parameters (?pickup_stop - pickup_stop ?delivery_stop - delivery_stop ?origin_location - origin_location ?destination_location - destination_location ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (pickup_stop_staged_for_loading ?pickup_stop)
        (delivery_stop_staged_for_loading ?delivery_stop)
        (stop_origin_location ?pickup_stop ?origin_location)
        (stop_destination_location ?delivery_stop ?destination_location)
        (origin_staged ?origin_location)
        (destination_loaded ?destination_location)
        (pickup_stop_ready ?pickup_stop)
        (not
          (delivery_stop_ready ?delivery_stop)
        )
        (trip_available ?vehicle_trip)
      )
    :effect
      (and
        (trip_allocated ?vehicle_trip)
        (trip_origin_location ?vehicle_trip ?origin_location)
        (trip_destination_location ?vehicle_trip ?destination_location)
        (trip_destination_loaded ?vehicle_trip)
        (not
          (trip_available ?vehicle_trip)
        )
      )
  )
  (:action form_trip_with_origin_and_destination_loaded
    :parameters (?pickup_stop - pickup_stop ?delivery_stop - delivery_stop ?origin_location - origin_location ?destination_location - destination_location ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (pickup_stop_staged_for_loading ?pickup_stop)
        (delivery_stop_staged_for_loading ?delivery_stop)
        (stop_origin_location ?pickup_stop ?origin_location)
        (stop_destination_location ?delivery_stop ?destination_location)
        (origin_loaded ?origin_location)
        (destination_loaded ?destination_location)
        (not
          (pickup_stop_ready ?pickup_stop)
        )
        (not
          (delivery_stop_ready ?delivery_stop)
        )
        (trip_available ?vehicle_trip)
      )
    :effect
      (and
        (trip_allocated ?vehicle_trip)
        (trip_origin_location ?vehicle_trip ?origin_location)
        (trip_destination_location ?vehicle_trip ?destination_location)
        (trip_origin_loaded ?vehicle_trip)
        (trip_destination_loaded ?vehicle_trip)
        (not
          (trip_available ?vehicle_trip)
        )
      )
  )
  (:action mark_trip_ready_for_loading
    :parameters (?vehicle_trip - vehicle_trip ?pickup_stop - pickup_stop ?commodity_class - commodity_class)
    :precondition
      (and
        (trip_allocated ?vehicle_trip)
        (pickup_stop_staged_for_loading ?pickup_stop)
        (shipment_commodity_assigned ?pickup_stop ?commodity_class)
        (not
          (trip_ready_for_loading ?vehicle_trip)
        )
      )
    :effect (trip_ready_for_loading ?vehicle_trip)
  )
  (:action assign_load_unit_to_trip
    :parameters (?route_plan - route_plan ?load_unit - load_unit ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (shipment_ready ?route_plan)
        (route_assigned_trip ?route_plan ?vehicle_trip)
        (route_includes_load_unit ?route_plan ?load_unit)
        (load_unit_available ?load_unit)
        (trip_allocated ?vehicle_trip)
        (trip_ready_for_loading ?vehicle_trip)
        (not
          (load_unit_loaded ?load_unit)
        )
      )
    :effect
      (and
        (load_unit_loaded ?load_unit)
        (load_unit_assigned_trip ?load_unit ?vehicle_trip)
        (not
          (load_unit_available ?load_unit)
        )
      )
  )
  (:action attach_container_to_route
    :parameters (?route_plan - route_plan ?load_unit - load_unit ?vehicle_trip - vehicle_trip ?commodity_class - commodity_class)
    :precondition
      (and
        (shipment_ready ?route_plan)
        (route_includes_load_unit ?route_plan ?load_unit)
        (load_unit_loaded ?load_unit)
        (load_unit_assigned_trip ?load_unit ?vehicle_trip)
        (shipment_commodity_assigned ?route_plan ?commodity_class)
        (not
          (trip_origin_loaded ?vehicle_trip)
        )
        (not
          (route_container_attached ?route_plan)
        )
      )
    :effect (route_container_attached ?route_plan)
  )
  (:action assign_equipment_type_to_route
    :parameters (?route_plan - route_plan ?equipment_type - equipment_type)
    :precondition
      (and
        (shipment_ready ?route_plan)
        (equipment_type_available ?equipment_type)
        (not
          (route_equipment_allocated ?route_plan)
        )
      )
    :effect
      (and
        (route_equipment_allocated ?route_plan)
        (route_requires_equipment_type ?route_plan ?equipment_type)
        (not
          (equipment_type_available ?equipment_type)
        )
      )
  )
  (:action confirm_equipment_and_attach_container
    :parameters (?route_plan - route_plan ?load_unit - load_unit ?vehicle_trip - vehicle_trip ?commodity_class - commodity_class ?equipment_type - equipment_type)
    :precondition
      (and
        (shipment_ready ?route_plan)
        (route_includes_load_unit ?route_plan ?load_unit)
        (load_unit_loaded ?load_unit)
        (load_unit_assigned_trip ?load_unit ?vehicle_trip)
        (shipment_commodity_assigned ?route_plan ?commodity_class)
        (trip_origin_loaded ?vehicle_trip)
        (route_equipment_allocated ?route_plan)
        (route_requires_equipment_type ?route_plan ?equipment_type)
        (not
          (route_container_attached ?route_plan)
        )
      )
    :effect
      (and
        (route_container_attached ?route_plan)
        (route_equipment_confirmed ?route_plan)
      )
  )
  (:action prepare_route_container_for_loading
    :parameters (?route_plan - route_plan ?equipment_id - equipment_id ?operator - operator ?load_unit - load_unit ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (route_container_attached ?route_plan)
        (route_equipment_id_assigned ?route_plan ?equipment_id)
        (shipment_assigned_operator ?route_plan ?operator)
        (route_includes_load_unit ?route_plan ?load_unit)
        (load_unit_assigned_trip ?load_unit ?vehicle_trip)
        (not
          (trip_destination_loaded ?vehicle_trip)
        )
        (not
          (route_container_prepared ?route_plan)
        )
      )
    :effect (route_container_prepared ?route_plan)
  )
  (:action prepare_route_container_after_loading
    :parameters (?route_plan - route_plan ?equipment_id - equipment_id ?operator - operator ?load_unit - load_unit ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (route_container_attached ?route_plan)
        (route_equipment_id_assigned ?route_plan ?equipment_id)
        (shipment_assigned_operator ?route_plan ?operator)
        (route_includes_load_unit ?route_plan ?load_unit)
        (load_unit_assigned_trip ?load_unit ?vehicle_trip)
        (trip_destination_loaded ?vehicle_trip)
        (not
          (route_container_prepared ?route_plan)
        )
      )
    :effect (route_container_prepared ?route_plan)
  )
  (:action verify_route_container
    :parameters (?route_plan - route_plan ?regulatory_clearance - regulatory_clearance ?load_unit - load_unit ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (route_container_prepared ?route_plan)
        (route_regulatory_clearance_attached ?route_plan ?regulatory_clearance)
        (route_includes_load_unit ?route_plan ?load_unit)
        (load_unit_assigned_trip ?load_unit ?vehicle_trip)
        (not
          (trip_origin_loaded ?vehicle_trip)
        )
        (not
          (trip_destination_loaded ?vehicle_trip)
        )
        (not
          (route_verified ?route_plan)
        )
      )
    :effect (route_verified ?route_plan)
  )
  (:action verify_route_and_apply_handling
    :parameters (?route_plan - route_plan ?regulatory_clearance - regulatory_clearance ?load_unit - load_unit ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (route_container_prepared ?route_plan)
        (route_regulatory_clearance_attached ?route_plan ?regulatory_clearance)
        (route_includes_load_unit ?route_plan ?load_unit)
        (load_unit_assigned_trip ?load_unit ?vehicle_trip)
        (trip_origin_loaded ?vehicle_trip)
        (not
          (trip_destination_loaded ?vehicle_trip)
        )
        (not
          (route_verified ?route_plan)
        )
      )
    :effect
      (and
        (route_verified ?route_plan)
        (route_handling_applied ?route_plan)
      )
  )
  (:action verify_route_and_apply_handling_secondary
    :parameters (?route_plan - route_plan ?regulatory_clearance - regulatory_clearance ?load_unit - load_unit ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (route_container_prepared ?route_plan)
        (route_regulatory_clearance_attached ?route_plan ?regulatory_clearance)
        (route_includes_load_unit ?route_plan ?load_unit)
        (load_unit_assigned_trip ?load_unit ?vehicle_trip)
        (not
          (trip_origin_loaded ?vehicle_trip)
        )
        (trip_destination_loaded ?vehicle_trip)
        (not
          (route_verified ?route_plan)
        )
      )
    :effect
      (and
        (route_verified ?route_plan)
        (route_handling_applied ?route_plan)
      )
  )
  (:action verify_route_and_apply_handling_both
    :parameters (?route_plan - route_plan ?regulatory_clearance - regulatory_clearance ?load_unit - load_unit ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (route_container_prepared ?route_plan)
        (route_regulatory_clearance_attached ?route_plan ?regulatory_clearance)
        (route_includes_load_unit ?route_plan ?load_unit)
        (load_unit_assigned_trip ?load_unit ?vehicle_trip)
        (trip_origin_loaded ?vehicle_trip)
        (trip_destination_loaded ?vehicle_trip)
        (not
          (route_verified ?route_plan)
        )
      )
    :effect
      (and
        (route_verified ?route_plan)
        (route_handling_applied ?route_plan)
      )
  )
  (:action finalize_route_verification
    :parameters (?route_plan - route_plan)
    :precondition
      (and
        (route_verified ?route_plan)
        (not
          (route_handling_applied ?route_plan)
        )
        (not
          (route_finalized ?route_plan)
        )
      )
    :effect
      (and
        (route_finalized ?route_plan)
        (active_for_dispatch ?route_plan)
      )
  )
  (:action assign_load_requirement_to_route
    :parameters (?route_plan - route_plan ?load_requirement - load_requirement)
    :precondition
      (and
        (route_verified ?route_plan)
        (route_handling_applied ?route_plan)
        (load_requirement_available ?load_requirement)
      )
    :effect
      (and
        (route_load_requirement ?route_plan ?load_requirement)
        (not
          (load_requirement_available ?load_requirement)
        )
      )
  )
  (:action confirm_route_plan_ready
    :parameters (?route_plan - route_plan ?pickup_stop - pickup_stop ?delivery_stop - delivery_stop ?commodity_class - commodity_class ?load_requirement - load_requirement)
    :precondition
      (and
        (route_verified ?route_plan)
        (route_handling_applied ?route_plan)
        (route_load_requirement ?route_plan ?load_requirement)
        (route_includes_pickup_stop ?route_plan ?pickup_stop)
        (route_includes_delivery_stop ?route_plan ?delivery_stop)
        (pickup_stop_ready ?pickup_stop)
        (delivery_stop_ready ?delivery_stop)
        (shipment_commodity_assigned ?route_plan ?commodity_class)
        (not
          (route_ready_for_dispatch ?route_plan)
        )
      )
    :effect (route_ready_for_dispatch ?route_plan)
  )
  (:action finalize_route_and_activate
    :parameters (?route_plan - route_plan)
    :precondition
      (and
        (route_verified ?route_plan)
        (route_ready_for_dispatch ?route_plan)
        (not
          (route_finalized ?route_plan)
        )
      )
    :effect
      (and
        (route_finalized ?route_plan)
        (active_for_dispatch ?route_plan)
      )
  )
  (:action reserve_handling_code_for_route
    :parameters (?route_plan - route_plan ?handling_code - handling_code ?commodity_class - commodity_class)
    :precondition
      (and
        (shipment_ready ?route_plan)
        (shipment_commodity_assigned ?route_plan ?commodity_class)
        (handling_code_available ?handling_code)
        (route_has_handling_code ?route_plan ?handling_code)
        (not
          (handling_code_committed ?route_plan)
        )
      )
    :effect
      (and
        (handling_code_committed ?route_plan)
        (not
          (handling_code_available ?handling_code)
        )
      )
  )
  (:action assign_operator_for_handling
    :parameters (?route_plan - route_plan ?operator - operator)
    :precondition
      (and
        (handling_code_committed ?route_plan)
        (shipment_assigned_operator ?route_plan ?operator)
        (not
          (handling_operator_assigned ?route_plan)
        )
      )
    :effect (handling_operator_assigned ?route_plan)
  )
  (:action verify_regulatory_clearance
    :parameters (?route_plan - route_plan ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (handling_operator_assigned ?route_plan)
        (route_regulatory_clearance_attached ?route_plan ?regulatory_clearance)
        (not
          (handling_verified ?route_plan)
        )
      )
    :effect (handling_verified ?route_plan)
  )
  (:action finalize_handling_checks
    :parameters (?route_plan - route_plan)
    :precondition
      (and
        (handling_verified ?route_plan)
        (not
          (route_finalized ?route_plan)
        )
      )
    :effect
      (and
        (route_finalized ?route_plan)
        (active_for_dispatch ?route_plan)
      )
  )
  (:action activate_pickup_stop
    :parameters (?pickup_stop - pickup_stop ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (pickup_stop_staged_for_loading ?pickup_stop)
        (pickup_stop_ready ?pickup_stop)
        (trip_allocated ?vehicle_trip)
        (trip_ready_for_loading ?vehicle_trip)
        (not
          (active_for_dispatch ?pickup_stop)
        )
      )
    :effect (active_for_dispatch ?pickup_stop)
  )
  (:action activate_delivery_stop
    :parameters (?delivery_stop - delivery_stop ?vehicle_trip - vehicle_trip)
    :precondition
      (and
        (delivery_stop_staged_for_loading ?delivery_stop)
        (delivery_stop_ready ?delivery_stop)
        (trip_allocated ?vehicle_trip)
        (trip_ready_for_loading ?vehicle_trip)
        (not
          (active_for_dispatch ?delivery_stop)
        )
      )
    :effect (active_for_dispatch ?delivery_stop)
  )
  (:action finalize_order_pairing
    :parameters (?order - order ?time_window - time_window ?commodity_class - commodity_class)
    :precondition
      (and
        (active_for_dispatch ?order)
        (shipment_commodity_assigned ?order ?commodity_class)
        (time_window_available ?time_window)
        (not
          (shipment_finalized ?order)
        )
      )
    :effect
      (and
        (shipment_finalized ?order)
        (shipment_time_window ?order ?time_window)
        (not
          (time_window_available ?time_window)
        )
      )
  )
  (:action commit_pickup_pairing
    :parameters (?pickup_stop - pickup_stop ?vehicle - vehicle ?time_window - time_window)
    :precondition
      (and
        (shipment_finalized ?pickup_stop)
        (shipment_assigned_vehicle ?pickup_stop ?vehicle)
        (shipment_time_window ?pickup_stop ?time_window)
        (not
          (shipment_assignment_confirmed ?pickup_stop)
        )
      )
    :effect
      (and
        (shipment_assignment_confirmed ?pickup_stop)
        (vehicle_available ?vehicle)
        (time_window_available ?time_window)
      )
  )
  (:action commit_delivery_pairing
    :parameters (?delivery_stop - delivery_stop ?vehicle - vehicle ?time_window - time_window)
    :precondition
      (and
        (shipment_finalized ?delivery_stop)
        (shipment_assigned_vehicle ?delivery_stop ?vehicle)
        (shipment_time_window ?delivery_stop ?time_window)
        (not
          (shipment_assignment_confirmed ?delivery_stop)
        )
      )
    :effect
      (and
        (shipment_assignment_confirmed ?delivery_stop)
        (vehicle_available ?vehicle)
        (time_window_available ?time_window)
      )
  )
  (:action commit_route_pairing
    :parameters (?route_plan - route_plan ?vehicle - vehicle ?time_window - time_window)
    :precondition
      (and
        (shipment_finalized ?route_plan)
        (shipment_assigned_vehicle ?route_plan ?vehicle)
        (shipment_time_window ?route_plan ?time_window)
        (not
          (shipment_assignment_confirmed ?route_plan)
        )
      )
    :effect
      (and
        (shipment_assignment_confirmed ?route_plan)
        (vehicle_available ?vehicle)
        (time_window_available ?time_window)
      )
  )
)

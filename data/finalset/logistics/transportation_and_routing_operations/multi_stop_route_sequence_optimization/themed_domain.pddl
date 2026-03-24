(define (domain multi_stop_route_sequence_optimization)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object logistics_category - object node_category - object domain_entity - object dispatchable_entity - domain_entity transport_asset - resource_category time_window - resource_category terminal_dock - resource_category special_equipment - resource_category operator_qualification - resource_category dispatch_token - resource_category vehicle_type - resource_category hazard_clearance_certificate - resource_category cargo_unit - logistics_category cargo_batch - logistics_category route_constraint - logistics_category transfer_node - node_category destination_node - node_category transfer_container - node_category origin_entity - dispatchable_entity destination_entity - dispatchable_entity origin_stop - origin_entity destination_stop - origin_entity route_plan - destination_entity)
  (:predicates
    (entity_registered ?dispatchable_entity - dispatchable_entity)
    (entity_configured ?dispatchable_entity - dispatchable_entity)
    (entity_asset_assigned_flag ?dispatchable_entity - dispatchable_entity)
    (entity_marked_dispatched ?dispatchable_entity - dispatchable_entity)
    (entity_dispatch_ready ?dispatchable_entity - dispatchable_entity)
    (entity_confirmed ?dispatchable_entity - dispatchable_entity)
    (transport_asset_available ?transport_asset - transport_asset)
    (asset_allocated_to_entity ?dispatchable_entity - dispatchable_entity ?transport_asset - transport_asset)
    (timewindow_available ?time_window - time_window)
    (timewindow_allocated ?dispatchable_entity - dispatchable_entity ?time_window - time_window)
    (terminal_available ?terminal_dock - terminal_dock)
    (terminal_allocated_to_entity ?dispatchable_entity - dispatchable_entity ?terminal_dock - terminal_dock)
    (cargo_unit_available ?cargo_unit - cargo_unit)
    (origin_has_cargo_unit ?origin_stop - origin_stop ?cargo_unit - cargo_unit)
    (destination_has_cargo_unit ?destination_stop - destination_stop ?cargo_unit - cargo_unit)
    (stop_to_node_mapping ?origin_stop - origin_stop ?transfer_node - transfer_node)
    (node_reserved_for_origin ?transfer_node - transfer_node)
    (node_reserved_for_destination ?transfer_node - transfer_node)
    (origin_allocation_confirmed ?origin_stop - origin_stop)
    (destination_stop_to_node_mapping ?destination_stop - destination_stop ?destination_node - destination_node)
    (node_reserved_for_destination_primary ?destination_node - destination_node)
    (node_reserved_for_destination_secondary ?destination_node - destination_node)
    (destination_processing_confirmed ?destination_stop - destination_stop)
    (container_unassigned ?transfer_container - transfer_container)
    (container_issued ?transfer_container - transfer_container)
    (container_origin_link ?transfer_container - transfer_container ?transfer_node - transfer_node)
    (container_destination_link ?transfer_container - transfer_container ?destination_node - destination_node)
    (container_origin_staged ?transfer_container - transfer_container)
    (container_destination_staged ?transfer_container - transfer_container)
    (container_stage_complete ?transfer_container - transfer_container)
    (route_has_origin_entity ?route_plan - route_plan ?origin_stop - origin_stop)
    (route_has_destination_entity ?route_plan - route_plan ?destination_stop - destination_stop)
    (route_assigned_to_container ?route_plan - route_plan ?transfer_container - transfer_container)
    (cargo_batch_available ?cargo_batch - cargo_batch)
    (route_has_cargo_batch ?route_plan - route_plan ?cargo_batch - cargo_batch)
    (cargo_batch_staged ?cargo_batch - cargo_batch)
    (cargo_batch_linked_to_container ?cargo_batch - cargo_batch ?transfer_container - transfer_container)
    (route_staging_ready ?route_plan - route_plan)
    (equipment_assigned_indicator ?route_plan - route_plan)
    (authorization_checks_passed ?route_plan - route_plan)
    (equipment_allocation_registered ?route_plan - route_plan)
    (equipment_prepared_for_route ?route_plan - route_plan)
    (credentials_linked ?route_plan - route_plan)
    (route_authorized_for_dispatch ?route_plan - route_plan)
    (route_constraint_available ?route_constraint - route_constraint)
    (route_has_constraint ?route_plan - route_plan ?route_constraint - route_constraint)
    (constraint_assignment_recorded ?route_plan - route_plan)
    (route_constraint_checks_passed ?route_plan - route_plan)
    (final_authorization_flag ?route_plan - route_plan)
    (special_equipment_available ?special_equipment - special_equipment)
    (route_special_equipment_allocated ?route_plan - route_plan ?special_equipment - special_equipment)
    (operator_qualification_available ?operator_qualification - operator_qualification)
    (operator_assigned_to_route ?route_plan - route_plan ?operator_qualification - operator_qualification)
    (vehicle_type_available ?vehicle_type - vehicle_type)
    (route_assigned_vehicle_type ?route_plan - route_plan ?vehicle_type - vehicle_type)
    (hazard_clearance_certificate_available ?hazard_clearance_certificate - hazard_clearance_certificate)
    (route_hazard_certificate_assigned ?route_plan - route_plan ?hazard_clearance_certificate - hazard_clearance_certificate)
    (dispatch_token_available ?dispatch_token - dispatch_token)
    (entity_bound_to_dispatch_token ?dispatchable_entity - dispatchable_entity ?dispatch_token - dispatch_token)
    (origin_processing_flag ?origin_stop - origin_stop)
    (destination_processing_flag ?destination_stop - destination_stop)
    (route_finalization_marker ?route_plan - route_plan)
  )
  (:action register_route_request
    :parameters (?dispatchable_entity - dispatchable_entity)
    :precondition
      (and
        (not
          (entity_registered ?dispatchable_entity)
        )
        (not
          (entity_marked_dispatched ?dispatchable_entity)
        )
      )
    :effect (entity_registered ?dispatchable_entity)
  )
  (:action assign_asset_to_route
    :parameters (?dispatchable_entity - dispatchable_entity ?transport_asset - transport_asset)
    :precondition
      (and
        (entity_registered ?dispatchable_entity)
        (not
          (entity_asset_assigned_flag ?dispatchable_entity)
        )
        (transport_asset_available ?transport_asset)
      )
    :effect
      (and
        (entity_asset_assigned_flag ?dispatchable_entity)
        (asset_allocated_to_entity ?dispatchable_entity ?transport_asset)
        (not
          (transport_asset_available ?transport_asset)
        )
      )
  )
  (:action allocate_time_window_to_route
    :parameters (?dispatchable_entity - dispatchable_entity ?time_window - time_window)
    :precondition
      (and
        (entity_registered ?dispatchable_entity)
        (entity_asset_assigned_flag ?dispatchable_entity)
        (timewindow_available ?time_window)
      )
    :effect
      (and
        (timewindow_allocated ?dispatchable_entity ?time_window)
        (not
          (timewindow_available ?time_window)
        )
      )
  )
  (:action confirm_route_configuration
    :parameters (?dispatchable_entity - dispatchable_entity ?time_window - time_window)
    :precondition
      (and
        (entity_registered ?dispatchable_entity)
        (entity_asset_assigned_flag ?dispatchable_entity)
        (timewindow_allocated ?dispatchable_entity ?time_window)
        (not
          (entity_configured ?dispatchable_entity)
        )
      )
    :effect (entity_configured ?dispatchable_entity)
  )
  (:action release_time_window
    :parameters (?dispatchable_entity - dispatchable_entity ?time_window - time_window)
    :precondition
      (and
        (timewindow_allocated ?dispatchable_entity ?time_window)
      )
    :effect
      (and
        (timewindow_available ?time_window)
        (not
          (timewindow_allocated ?dispatchable_entity ?time_window)
        )
      )
  )
  (:action assign_terminal_to_route
    :parameters (?dispatchable_entity - dispatchable_entity ?terminal_dock - terminal_dock)
    :precondition
      (and
        (entity_configured ?dispatchable_entity)
        (terminal_available ?terminal_dock)
      )
    :effect
      (and
        (terminal_allocated_to_entity ?dispatchable_entity ?terminal_dock)
        (not
          (terminal_available ?terminal_dock)
        )
      )
  )
  (:action release_terminal_from_route
    :parameters (?dispatchable_entity - dispatchable_entity ?terminal_dock - terminal_dock)
    :precondition
      (and
        (terminal_allocated_to_entity ?dispatchable_entity ?terminal_dock)
      )
    :effect
      (and
        (terminal_available ?terminal_dock)
        (not
          (terminal_allocated_to_entity ?dispatchable_entity ?terminal_dock)
        )
      )
  )
  (:action assign_vehicle_type_to_route
    :parameters (?route_plan - route_plan ?vehicle_type - vehicle_type)
    :precondition
      (and
        (entity_configured ?route_plan)
        (vehicle_type_available ?vehicle_type)
      )
    :effect
      (and
        (route_assigned_vehicle_type ?route_plan ?vehicle_type)
        (not
          (vehicle_type_available ?vehicle_type)
        )
      )
  )
  (:action release_vehicle_type_from_route
    :parameters (?route_plan - route_plan ?vehicle_type - vehicle_type)
    :precondition
      (and
        (route_assigned_vehicle_type ?route_plan ?vehicle_type)
      )
    :effect
      (and
        (vehicle_type_available ?vehicle_type)
        (not
          (route_assigned_vehicle_type ?route_plan ?vehicle_type)
        )
      )
  )
  (:action assign_hazard_certificate_to_route
    :parameters (?route_plan - route_plan ?hazard_clearance_certificate - hazard_clearance_certificate)
    :precondition
      (and
        (entity_configured ?route_plan)
        (hazard_clearance_certificate_available ?hazard_clearance_certificate)
      )
    :effect
      (and
        (route_hazard_certificate_assigned ?route_plan ?hazard_clearance_certificate)
        (not
          (hazard_clearance_certificate_available ?hazard_clearance_certificate)
        )
      )
  )
  (:action release_hazard_certificate_from_route
    :parameters (?route_plan - route_plan ?hazard_clearance_certificate - hazard_clearance_certificate)
    :precondition
      (and
        (route_hazard_certificate_assigned ?route_plan ?hazard_clearance_certificate)
      )
    :effect
      (and
        (hazard_clearance_certificate_available ?hazard_clearance_certificate)
        (not
          (route_hazard_certificate_assigned ?route_plan ?hazard_clearance_certificate)
        )
      )
  )
  (:action reserve_node_for_origin
    :parameters (?origin_stop - origin_stop ?transfer_node - transfer_node ?time_window - time_window)
    :precondition
      (and
        (entity_configured ?origin_stop)
        (timewindow_allocated ?origin_stop ?time_window)
        (stop_to_node_mapping ?origin_stop ?transfer_node)
        (not
          (node_reserved_for_origin ?transfer_node)
        )
        (not
          (node_reserved_for_destination ?transfer_node)
        )
      )
    :effect (node_reserved_for_origin ?transfer_node)
  )
  (:action prepare_origin_for_transfer
    :parameters (?origin_stop - origin_stop ?transfer_node - transfer_node ?terminal_dock - terminal_dock)
    :precondition
      (and
        (entity_configured ?origin_stop)
        (terminal_allocated_to_entity ?origin_stop ?terminal_dock)
        (stop_to_node_mapping ?origin_stop ?transfer_node)
        (node_reserved_for_origin ?transfer_node)
        (not
          (origin_processing_flag ?origin_stop)
        )
      )
    :effect
      (and
        (origin_processing_flag ?origin_stop)
        (origin_allocation_confirmed ?origin_stop)
      )
  )
  (:action stage_cargo_unit_at_origin
    :parameters (?origin_stop - origin_stop ?transfer_node - transfer_node ?cargo_unit - cargo_unit)
    :precondition
      (and
        (entity_configured ?origin_stop)
        (stop_to_node_mapping ?origin_stop ?transfer_node)
        (cargo_unit_available ?cargo_unit)
        (not
          (origin_processing_flag ?origin_stop)
        )
      )
    :effect
      (and
        (node_reserved_for_destination ?transfer_node)
        (origin_processing_flag ?origin_stop)
        (origin_has_cargo_unit ?origin_stop ?cargo_unit)
        (not
          (cargo_unit_available ?cargo_unit)
        )
      )
  )
  (:action complete_origin_cargo_handling
    :parameters (?origin_stop - origin_stop ?transfer_node - transfer_node ?time_window - time_window ?cargo_unit - cargo_unit)
    :precondition
      (and
        (entity_configured ?origin_stop)
        (timewindow_allocated ?origin_stop ?time_window)
        (stop_to_node_mapping ?origin_stop ?transfer_node)
        (node_reserved_for_destination ?transfer_node)
        (origin_has_cargo_unit ?origin_stop ?cargo_unit)
        (not
          (origin_allocation_confirmed ?origin_stop)
        )
      )
    :effect
      (and
        (node_reserved_for_origin ?transfer_node)
        (origin_allocation_confirmed ?origin_stop)
        (cargo_unit_available ?cargo_unit)
        (not
          (origin_has_cargo_unit ?origin_stop ?cargo_unit)
        )
      )
  )
  (:action reserve_node_for_destination
    :parameters (?destination_stop - destination_stop ?destination_node - destination_node ?time_window - time_window)
    :precondition
      (and
        (entity_configured ?destination_stop)
        (timewindow_allocated ?destination_stop ?time_window)
        (destination_stop_to_node_mapping ?destination_stop ?destination_node)
        (not
          (node_reserved_for_destination_primary ?destination_node)
        )
        (not
          (node_reserved_for_destination_secondary ?destination_node)
        )
      )
    :effect (node_reserved_for_destination_primary ?destination_node)
  )
  (:action prepare_destination_for_transfer
    :parameters (?destination_stop - destination_stop ?destination_node - destination_node ?terminal_dock - terminal_dock)
    :precondition
      (and
        (entity_configured ?destination_stop)
        (terminal_allocated_to_entity ?destination_stop ?terminal_dock)
        (destination_stop_to_node_mapping ?destination_stop ?destination_node)
        (node_reserved_for_destination_primary ?destination_node)
        (not
          (destination_processing_flag ?destination_stop)
        )
      )
    :effect
      (and
        (destination_processing_flag ?destination_stop)
        (destination_processing_confirmed ?destination_stop)
      )
  )
  (:action stage_cargo_unit_at_destination
    :parameters (?destination_stop - destination_stop ?destination_node - destination_node ?cargo_unit - cargo_unit)
    :precondition
      (and
        (entity_configured ?destination_stop)
        (destination_stop_to_node_mapping ?destination_stop ?destination_node)
        (cargo_unit_available ?cargo_unit)
        (not
          (destination_processing_flag ?destination_stop)
        )
      )
    :effect
      (and
        (node_reserved_for_destination_secondary ?destination_node)
        (destination_processing_flag ?destination_stop)
        (destination_has_cargo_unit ?destination_stop ?cargo_unit)
        (not
          (cargo_unit_available ?cargo_unit)
        )
      )
  )
  (:action complete_destination_cargo_handling
    :parameters (?destination_stop - destination_stop ?destination_node - destination_node ?time_window - time_window ?cargo_unit - cargo_unit)
    :precondition
      (and
        (entity_configured ?destination_stop)
        (timewindow_allocated ?destination_stop ?time_window)
        (destination_stop_to_node_mapping ?destination_stop ?destination_node)
        (node_reserved_for_destination_secondary ?destination_node)
        (destination_has_cargo_unit ?destination_stop ?cargo_unit)
        (not
          (destination_processing_confirmed ?destination_stop)
        )
      )
    :effect
      (and
        (node_reserved_for_destination_primary ?destination_node)
        (destination_processing_confirmed ?destination_stop)
        (cargo_unit_available ?cargo_unit)
        (not
          (destination_has_cargo_unit ?destination_stop ?cargo_unit)
        )
      )
  )
  (:action issue_container_for_staged_nodes
    :parameters (?origin_stop - origin_stop ?destination_stop - destination_stop ?transfer_node - transfer_node ?destination_node - destination_node ?transfer_container - transfer_container)
    :precondition
      (and
        (origin_processing_flag ?origin_stop)
        (destination_processing_flag ?destination_stop)
        (stop_to_node_mapping ?origin_stop ?transfer_node)
        (destination_stop_to_node_mapping ?destination_stop ?destination_node)
        (node_reserved_for_origin ?transfer_node)
        (node_reserved_for_destination_primary ?destination_node)
        (origin_allocation_confirmed ?origin_stop)
        (destination_processing_confirmed ?destination_stop)
        (container_unassigned ?transfer_container)
      )
    :effect
      (and
        (container_issued ?transfer_container)
        (container_origin_link ?transfer_container ?transfer_node)
        (container_destination_link ?transfer_container ?destination_node)
        (not
          (container_unassigned ?transfer_container)
        )
      )
  )
  (:action issue_container_with_origin_staging
    :parameters (?origin_stop - origin_stop ?destination_stop - destination_stop ?transfer_node - transfer_node ?destination_node - destination_node ?transfer_container - transfer_container)
    :precondition
      (and
        (origin_processing_flag ?origin_stop)
        (destination_processing_flag ?destination_stop)
        (stop_to_node_mapping ?origin_stop ?transfer_node)
        (destination_stop_to_node_mapping ?destination_stop ?destination_node)
        (node_reserved_for_destination ?transfer_node)
        (node_reserved_for_destination_primary ?destination_node)
        (not
          (origin_allocation_confirmed ?origin_stop)
        )
        (destination_processing_confirmed ?destination_stop)
        (container_unassigned ?transfer_container)
      )
    :effect
      (and
        (container_issued ?transfer_container)
        (container_origin_link ?transfer_container ?transfer_node)
        (container_destination_link ?transfer_container ?destination_node)
        (container_origin_staged ?transfer_container)
        (not
          (container_unassigned ?transfer_container)
        )
      )
  )
  (:action issue_container_with_destination_staging
    :parameters (?origin_stop - origin_stop ?destination_stop - destination_stop ?transfer_node - transfer_node ?destination_node - destination_node ?transfer_container - transfer_container)
    :precondition
      (and
        (origin_processing_flag ?origin_stop)
        (destination_processing_flag ?destination_stop)
        (stop_to_node_mapping ?origin_stop ?transfer_node)
        (destination_stop_to_node_mapping ?destination_stop ?destination_node)
        (node_reserved_for_origin ?transfer_node)
        (node_reserved_for_destination_secondary ?destination_node)
        (origin_allocation_confirmed ?origin_stop)
        (not
          (destination_processing_confirmed ?destination_stop)
        )
        (container_unassigned ?transfer_container)
      )
    :effect
      (and
        (container_issued ?transfer_container)
        (container_origin_link ?transfer_container ?transfer_node)
        (container_destination_link ?transfer_container ?destination_node)
        (container_destination_staged ?transfer_container)
        (not
          (container_unassigned ?transfer_container)
        )
      )
  )
  (:action issue_container_with_both_staged
    :parameters (?origin_stop - origin_stop ?destination_stop - destination_stop ?transfer_node - transfer_node ?destination_node - destination_node ?transfer_container - transfer_container)
    :precondition
      (and
        (origin_processing_flag ?origin_stop)
        (destination_processing_flag ?destination_stop)
        (stop_to_node_mapping ?origin_stop ?transfer_node)
        (destination_stop_to_node_mapping ?destination_stop ?destination_node)
        (node_reserved_for_destination ?transfer_node)
        (node_reserved_for_destination_secondary ?destination_node)
        (not
          (origin_allocation_confirmed ?origin_stop)
        )
        (not
          (destination_processing_confirmed ?destination_stop)
        )
        (container_unassigned ?transfer_container)
      )
    :effect
      (and
        (container_issued ?transfer_container)
        (container_origin_link ?transfer_container ?transfer_node)
        (container_destination_link ?transfer_container ?destination_node)
        (container_origin_staged ?transfer_container)
        (container_destination_staged ?transfer_container)
        (not
          (container_unassigned ?transfer_container)
        )
      )
  )
  (:action mark_container_stage_complete
    :parameters (?transfer_container - transfer_container ?origin_stop - origin_stop ?time_window - time_window)
    :precondition
      (and
        (container_issued ?transfer_container)
        (origin_processing_flag ?origin_stop)
        (timewindow_allocated ?origin_stop ?time_window)
        (not
          (container_stage_complete ?transfer_container)
        )
      )
    :effect (container_stage_complete ?transfer_container)
  )
  (:action stage_cargo_batch_into_container
    :parameters (?route_plan - route_plan ?cargo_batch - cargo_batch ?transfer_container - transfer_container)
    :precondition
      (and
        (entity_configured ?route_plan)
        (route_assigned_to_container ?route_plan ?transfer_container)
        (route_has_cargo_batch ?route_plan ?cargo_batch)
        (cargo_batch_available ?cargo_batch)
        (container_issued ?transfer_container)
        (container_stage_complete ?transfer_container)
        (not
          (cargo_batch_staged ?cargo_batch)
        )
      )
    :effect
      (and
        (cargo_batch_staged ?cargo_batch)
        (cargo_batch_linked_to_container ?cargo_batch ?transfer_container)
        (not
          (cargo_batch_available ?cargo_batch)
        )
      )
  )
  (:action mark_route_staging_ready
    :parameters (?route_plan - route_plan ?cargo_batch - cargo_batch ?transfer_container - transfer_container ?time_window - time_window)
    :precondition
      (and
        (entity_configured ?route_plan)
        (route_has_cargo_batch ?route_plan ?cargo_batch)
        (cargo_batch_staged ?cargo_batch)
        (cargo_batch_linked_to_container ?cargo_batch ?transfer_container)
        (timewindow_allocated ?route_plan ?time_window)
        (not
          (container_origin_staged ?transfer_container)
        )
        (not
          (route_staging_ready ?route_plan)
        )
      )
    :effect (route_staging_ready ?route_plan)
  )
  (:action reserve_special_equipment_for_route
    :parameters (?route_plan - route_plan ?special_equipment - special_equipment)
    :precondition
      (and
        (entity_configured ?route_plan)
        (special_equipment_available ?special_equipment)
        (not
          (equipment_allocation_registered ?route_plan)
        )
      )
    :effect
      (and
        (equipment_allocation_registered ?route_plan)
        (route_special_equipment_allocated ?route_plan ?special_equipment)
        (not
          (special_equipment_available ?special_equipment)
        )
      )
  )
  (:action prepare_route_staging_with_equipment
    :parameters (?route_plan - route_plan ?cargo_batch - cargo_batch ?transfer_container - transfer_container ?time_window - time_window ?special_equipment - special_equipment)
    :precondition
      (and
        (entity_configured ?route_plan)
        (route_has_cargo_batch ?route_plan ?cargo_batch)
        (cargo_batch_staged ?cargo_batch)
        (cargo_batch_linked_to_container ?cargo_batch ?transfer_container)
        (timewindow_allocated ?route_plan ?time_window)
        (container_origin_staged ?transfer_container)
        (equipment_allocation_registered ?route_plan)
        (route_special_equipment_allocated ?route_plan ?special_equipment)
        (not
          (route_staging_ready ?route_plan)
        )
      )
    :effect
      (and
        (route_staging_ready ?route_plan)
        (equipment_prepared_for_route ?route_plan)
      )
  )
  (:action assign_equipment_indicator_to_route_primary
    :parameters (?route_plan - route_plan ?vehicle_type - vehicle_type ?terminal_dock - terminal_dock ?cargo_batch - cargo_batch ?transfer_container - transfer_container)
    :precondition
      (and
        (route_staging_ready ?route_plan)
        (route_assigned_vehicle_type ?route_plan ?vehicle_type)
        (terminal_allocated_to_entity ?route_plan ?terminal_dock)
        (route_has_cargo_batch ?route_plan ?cargo_batch)
        (cargo_batch_linked_to_container ?cargo_batch ?transfer_container)
        (not
          (container_destination_staged ?transfer_container)
        )
        (not
          (equipment_assigned_indicator ?route_plan)
        )
      )
    :effect (equipment_assigned_indicator ?route_plan)
  )
  (:action assign_equipment_indicator_to_route_secondary
    :parameters (?route_plan - route_plan ?vehicle_type - vehicle_type ?terminal_dock - terminal_dock ?cargo_batch - cargo_batch ?transfer_container - transfer_container)
    :precondition
      (and
        (route_staging_ready ?route_plan)
        (route_assigned_vehicle_type ?route_plan ?vehicle_type)
        (terminal_allocated_to_entity ?route_plan ?terminal_dock)
        (route_has_cargo_batch ?route_plan ?cargo_batch)
        (cargo_batch_linked_to_container ?cargo_batch ?transfer_container)
        (container_destination_staged ?transfer_container)
        (not
          (equipment_assigned_indicator ?route_plan)
        )
      )
    :effect (equipment_assigned_indicator ?route_plan)
  )
  (:action execute_authorization_checks
    :parameters (?route_plan - route_plan ?hazard_clearance_certificate - hazard_clearance_certificate ?cargo_batch - cargo_batch ?transfer_container - transfer_container)
    :precondition
      (and
        (equipment_assigned_indicator ?route_plan)
        (route_hazard_certificate_assigned ?route_plan ?hazard_clearance_certificate)
        (route_has_cargo_batch ?route_plan ?cargo_batch)
        (cargo_batch_linked_to_container ?cargo_batch ?transfer_container)
        (not
          (container_origin_staged ?transfer_container)
        )
        (not
          (container_destination_staged ?transfer_container)
        )
        (not
          (authorization_checks_passed ?route_plan)
        )
      )
    :effect (authorization_checks_passed ?route_plan)
  )
  (:action execute_authorization_checks_and_link_credentials
    :parameters (?route_plan - route_plan ?hazard_clearance_certificate - hazard_clearance_certificate ?cargo_batch - cargo_batch ?transfer_container - transfer_container)
    :precondition
      (and
        (equipment_assigned_indicator ?route_plan)
        (route_hazard_certificate_assigned ?route_plan ?hazard_clearance_certificate)
        (route_has_cargo_batch ?route_plan ?cargo_batch)
        (cargo_batch_linked_to_container ?cargo_batch ?transfer_container)
        (container_origin_staged ?transfer_container)
        (not
          (container_destination_staged ?transfer_container)
        )
        (not
          (authorization_checks_passed ?route_plan)
        )
      )
    :effect
      (and
        (authorization_checks_passed ?route_plan)
        (credentials_linked ?route_plan)
      )
  )
  (:action execute_authorization_checks_and_link_credentials_variant
    :parameters (?route_plan - route_plan ?hazard_clearance_certificate - hazard_clearance_certificate ?cargo_batch - cargo_batch ?transfer_container - transfer_container)
    :precondition
      (and
        (equipment_assigned_indicator ?route_plan)
        (route_hazard_certificate_assigned ?route_plan ?hazard_clearance_certificate)
        (route_has_cargo_batch ?route_plan ?cargo_batch)
        (cargo_batch_linked_to_container ?cargo_batch ?transfer_container)
        (not
          (container_origin_staged ?transfer_container)
        )
        (container_destination_staged ?transfer_container)
        (not
          (authorization_checks_passed ?route_plan)
        )
      )
    :effect
      (and
        (authorization_checks_passed ?route_plan)
        (credentials_linked ?route_plan)
      )
  )
  (:action execute_authorization_checks_and_link_credentials_both
    :parameters (?route_plan - route_plan ?hazard_clearance_certificate - hazard_clearance_certificate ?cargo_batch - cargo_batch ?transfer_container - transfer_container)
    :precondition
      (and
        (equipment_assigned_indicator ?route_plan)
        (route_hazard_certificate_assigned ?route_plan ?hazard_clearance_certificate)
        (route_has_cargo_batch ?route_plan ?cargo_batch)
        (cargo_batch_linked_to_container ?cargo_batch ?transfer_container)
        (container_origin_staged ?transfer_container)
        (container_destination_staged ?transfer_container)
        (not
          (authorization_checks_passed ?route_plan)
        )
      )
    :effect
      (and
        (authorization_checks_passed ?route_plan)
        (credentials_linked ?route_plan)
      )
  )
  (:action finalize_and_mark_route_ready
    :parameters (?route_plan - route_plan)
    :precondition
      (and
        (authorization_checks_passed ?route_plan)
        (not
          (credentials_linked ?route_plan)
        )
        (not
          (route_finalization_marker ?route_plan)
        )
      )
    :effect
      (and
        (route_finalization_marker ?route_plan)
        (entity_dispatch_ready ?route_plan)
      )
  )
  (:action assign_operator_to_route
    :parameters (?route_plan - route_plan ?operator_qualification - operator_qualification)
    :precondition
      (and
        (authorization_checks_passed ?route_plan)
        (credentials_linked ?route_plan)
        (operator_qualification_available ?operator_qualification)
      )
    :effect
      (and
        (operator_assigned_to_route ?route_plan ?operator_qualification)
        (not
          (operator_qualification_available ?operator_qualification)
        )
      )
  )
  (:action authorize_route_for_dispatch
    :parameters (?route_plan - route_plan ?origin_stop - origin_stop ?destination_stop - destination_stop ?time_window - time_window ?operator_qualification - operator_qualification)
    :precondition
      (and
        (authorization_checks_passed ?route_plan)
        (credentials_linked ?route_plan)
        (operator_assigned_to_route ?route_plan ?operator_qualification)
        (route_has_origin_entity ?route_plan ?origin_stop)
        (route_has_destination_entity ?route_plan ?destination_stop)
        (origin_allocation_confirmed ?origin_stop)
        (destination_processing_confirmed ?destination_stop)
        (timewindow_allocated ?route_plan ?time_window)
        (not
          (route_authorized_for_dispatch ?route_plan)
        )
      )
    :effect (route_authorized_for_dispatch ?route_plan)
  )
  (:action finalize_route_with_authorization
    :parameters (?route_plan - route_plan)
    :precondition
      (and
        (authorization_checks_passed ?route_plan)
        (route_authorized_for_dispatch ?route_plan)
        (not
          (route_finalization_marker ?route_plan)
        )
      )
    :effect
      (and
        (route_finalization_marker ?route_plan)
        (entity_dispatch_ready ?route_plan)
      )
  )
  (:action apply_route_constraint_to_route
    :parameters (?route_plan - route_plan ?route_constraint - route_constraint ?time_window - time_window)
    :precondition
      (and
        (entity_configured ?route_plan)
        (timewindow_allocated ?route_plan ?time_window)
        (route_constraint_available ?route_constraint)
        (route_has_constraint ?route_plan ?route_constraint)
        (not
          (constraint_assignment_recorded ?route_plan)
        )
      )
    :effect
      (and
        (constraint_assignment_recorded ?route_plan)
        (not
          (route_constraint_available ?route_constraint)
        )
      )
  )
  (:action record_constraint_check_passed
    :parameters (?route_plan - route_plan ?terminal_dock - terminal_dock)
    :precondition
      (and
        (constraint_assignment_recorded ?route_plan)
        (terminal_allocated_to_entity ?route_plan ?terminal_dock)
        (not
          (route_constraint_checks_passed ?route_plan)
        )
      )
    :effect (route_constraint_checks_passed ?route_plan)
  )
  (:action set_final_authorization_flag
    :parameters (?route_plan - route_plan ?hazard_clearance_certificate - hazard_clearance_certificate)
    :precondition
      (and
        (route_constraint_checks_passed ?route_plan)
        (route_hazard_certificate_assigned ?route_plan ?hazard_clearance_certificate)
        (not
          (final_authorization_flag ?route_plan)
        )
      )
    :effect (final_authorization_flag ?route_plan)
  )
  (:action finalize_route_after_authorization
    :parameters (?route_plan - route_plan)
    :precondition
      (and
        (final_authorization_flag ?route_plan)
        (not
          (route_finalization_marker ?route_plan)
        )
      )
    :effect
      (and
        (route_finalization_marker ?route_plan)
        (entity_dispatch_ready ?route_plan)
      )
  )
  (:action mark_origin_entity_ready_for_dispatch
    :parameters (?origin_stop - origin_stop ?transfer_container - transfer_container)
    :precondition
      (and
        (origin_processing_flag ?origin_stop)
        (origin_allocation_confirmed ?origin_stop)
        (container_issued ?transfer_container)
        (container_stage_complete ?transfer_container)
        (not
          (entity_dispatch_ready ?origin_stop)
        )
      )
    :effect (entity_dispatch_ready ?origin_stop)
  )
  (:action mark_destination_entity_ready_for_dispatch
    :parameters (?destination_stop - destination_stop ?transfer_container - transfer_container)
    :precondition
      (and
        (destination_processing_flag ?destination_stop)
        (destination_processing_confirmed ?destination_stop)
        (container_issued ?transfer_container)
        (container_stage_complete ?transfer_container)
        (not
          (entity_dispatch_ready ?destination_stop)
        )
      )
    :effect (entity_dispatch_ready ?destination_stop)
  )
  (:action confirm_route_booking
    :parameters (?dispatchable_entity - dispatchable_entity ?dispatch_token - dispatch_token ?time_window - time_window)
    :precondition
      (and
        (entity_dispatch_ready ?dispatchable_entity)
        (timewindow_allocated ?dispatchable_entity ?time_window)
        (dispatch_token_available ?dispatch_token)
        (not
          (entity_confirmed ?dispatchable_entity)
        )
      )
    :effect
      (and
        (entity_confirmed ?dispatchable_entity)
        (entity_bound_to_dispatch_token ?dispatchable_entity ?dispatch_token)
        (not
          (dispatch_token_available ?dispatch_token)
        )
      )
  )
  (:action dispatch_origin_and_update_asset_status
    :parameters (?origin_stop - origin_stop ?transport_asset - transport_asset ?dispatch_token - dispatch_token)
    :precondition
      (and
        (entity_confirmed ?origin_stop)
        (asset_allocated_to_entity ?origin_stop ?transport_asset)
        (entity_bound_to_dispatch_token ?origin_stop ?dispatch_token)
        (not
          (entity_marked_dispatched ?origin_stop)
        )
      )
    :effect
      (and
        (entity_marked_dispatched ?origin_stop)
        (transport_asset_available ?transport_asset)
        (dispatch_token_available ?dispatch_token)
      )
  )
  (:action dispatch_destination_and_update_asset_status
    :parameters (?destination_stop - destination_stop ?transport_asset - transport_asset ?dispatch_token - dispatch_token)
    :precondition
      (and
        (entity_confirmed ?destination_stop)
        (asset_allocated_to_entity ?destination_stop ?transport_asset)
        (entity_bound_to_dispatch_token ?destination_stop ?dispatch_token)
        (not
          (entity_marked_dispatched ?destination_stop)
        )
      )
    :effect
      (and
        (entity_marked_dispatched ?destination_stop)
        (transport_asset_available ?transport_asset)
        (dispatch_token_available ?dispatch_token)
      )
  )
  (:action dispatch_route_and_update_asset_status
    :parameters (?route_plan - route_plan ?transport_asset - transport_asset ?dispatch_token - dispatch_token)
    :precondition
      (and
        (entity_confirmed ?route_plan)
        (asset_allocated_to_entity ?route_plan ?transport_asset)
        (entity_bound_to_dispatch_token ?route_plan ?dispatch_token)
        (not
          (entity_marked_dispatched ?route_plan)
        )
      )
    :effect
      (and
        (entity_marked_dispatched ?route_plan)
        (transport_asset_available ?transport_asset)
        (dispatch_token_available ?dispatch_token)
      )
  )
)

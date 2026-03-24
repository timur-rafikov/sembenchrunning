(define (domain storage_overflow_contingency_distribution_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource_group - object route_and_channel_group - object logistics_asset_group - object storage_workflow_entity - object storage_unit - storage_workflow_entity distribution_channel - operational_resource_group conditioning_station - operational_resource_group handling_equipment - operational_resource_group special_handling_instruction - operational_resource_group packaging_specification - operational_resource_group destination_allocation_token - operational_resource_group certification_stamp - operational_resource_group shipping_permit_token - operational_resource_group packaging_item - route_and_channel_group container_pallet - route_and_channel_group authorization_document - route_and_channel_group primary_route_segment - logistics_asset_group overflow_route_segment - logistics_asset_group transport_load_unit - logistics_asset_group storage_slot_group - storage_unit unitized_storage_group - storage_unit primary_storage_bay - storage_slot_group overflow_storage_bay - storage_slot_group unitized_pallet - unitized_storage_group)
  (:predicates
    (unit_registered ?unit - storage_unit)
    (unit_quality_cleared ?unit - storage_unit)
    (unit_channel_reserved ?unit - storage_unit)
    (cleared_for_dispatch ?unit - storage_unit)
    (unit_finalization_verified ?unit - storage_unit)
    (unit_release_allocated ?unit - storage_unit)
    (channel_available ?distribution_channel - distribution_channel)
    (unit_assigned_to_channel ?unit - storage_unit ?distribution_channel - distribution_channel)
    (conditioning_station_available ?conditioning_station - conditioning_station)
    (unit_assigned_to_station ?unit - storage_unit ?conditioning_station - conditioning_station)
    (handling_equipment_available ?handling_equipment - handling_equipment)
    (unit_assigned_to_handling_equipment ?unit - storage_unit ?handling_equipment - handling_equipment)
    (packaging_item_available ?packaging_item - packaging_item)
    (primary_bay_packaging_assigned ?primary_storage_bay - primary_storage_bay ?packaging_item - packaging_item)
    (overflow_bay_packaging_assigned ?overflow_storage_bay - overflow_storage_bay ?packaging_item - packaging_item)
    (primary_bay_route_assigned ?primary_storage_bay - primary_storage_bay ?primary_route_segment - primary_route_segment)
    (primary_route_confirmed ?primary_route_segment - primary_route_segment)
    (primary_route_provisioned ?primary_route_segment - primary_route_segment)
    (primary_bay_ready_for_assembly ?primary_storage_bay - primary_storage_bay)
    (overflow_bay_route_assigned ?overflow_storage_bay - overflow_storage_bay ?overflow_route_segment - overflow_route_segment)
    (overflow_route_confirmed ?overflow_route_segment - overflow_route_segment)
    (overflow_route_provisioned ?overflow_route_segment - overflow_route_segment)
    (overflow_bay_ready_for_assembly ?overflow_storage_bay - overflow_storage_bay)
    (load_unit_available ?transport_load_unit - transport_load_unit)
    (load_unit_booked ?transport_load_unit - transport_load_unit)
    (load_unit_bound_to_primary_route ?transport_load_unit - transport_load_unit ?primary_route_segment - primary_route_segment)
    (load_unit_bound_to_overflow_route ?transport_load_unit - transport_load_unit ?overflow_route_segment - overflow_route_segment)
    (load_unit_manifest_attached ?transport_load_unit - transport_load_unit)
    (load_unit_priority_flag ?transport_load_unit - transport_load_unit)
    (load_unit_manifest_finalized ?transport_load_unit - transport_load_unit)
    (unit_in_primary_bay ?unitized_pallet - unitized_pallet ?primary_storage_bay - primary_storage_bay)
    (unit_in_overflow_bay ?unitized_pallet - unitized_pallet ?overflow_storage_bay - overflow_storage_bay)
    (unit_bound_to_load ?unitized_pallet - unitized_pallet ?transport_load_unit - transport_load_unit)
    (container_available ?container_pallet - container_pallet)
    (unit_container_association ?unitized_pallet - unitized_pallet ?container_pallet - container_pallet)
    (container_reserved ?container_pallet - container_pallet)
    (container_bound_to_load ?container_pallet - container_pallet ?transport_load_unit - transport_load_unit)
    (unit_containerization_initiated ?unitized_pallet - unitized_pallet)
    (unit_packaging_confirmed ?unitized_pallet - unitized_pallet)
    (unit_packaging_ready_for_finalization ?unitized_pallet - unitized_pallet)
    (unit_handling_instruction_applied ?unitized_pallet - unitized_pallet)
    (unit_handling_instruction_confirmed ?unitized_pallet - unitized_pallet)
    (unit_packaging_spec_applied ?unitized_pallet - unitized_pallet)
    (unit_ready_for_final_assembly ?unitized_pallet - unitized_pallet)
    (authorization_document_available ?authorization_document - authorization_document)
    (unit_authorization_assigned ?unitized_pallet - unitized_pallet ?authorization_document - authorization_document)
    (unit_authorized ?unitized_pallet - unitized_pallet)
    (unit_authorization_acknowledged ?unitized_pallet - unitized_pallet)
    (unit_permit_confirmed ?unitized_pallet - unitized_pallet)
    (special_handling_instruction_available ?special_handling_instruction - special_handling_instruction)
    (unit_special_handling_assigned ?unitized_pallet - unitized_pallet ?special_handling_instruction - special_handling_instruction)
    (packaging_spec_available ?packaging_specification - packaging_specification)
    (unit_packaging_spec_bound ?unitized_pallet - unitized_pallet ?packaging_specification - packaging_specification)
    (certification_stamp_available ?certification_stamp - certification_stamp)
    (unit_certified ?unitized_pallet - unitized_pallet ?certification_stamp - certification_stamp)
    (shipping_permit_available ?shipping_permit_token - shipping_permit_token)
    (unit_permit_bound ?unitized_pallet - unitized_pallet ?shipping_permit_token - shipping_permit_token)
    (destination_token_available ?destination_allocation_token - destination_allocation_token)
    (unit_destination_assigned ?unit - storage_unit ?destination_allocation_token - destination_allocation_token)
    (primary_bay_ready_flag ?primary_storage_bay - primary_storage_bay)
    (overflow_bay_ready_flag ?overflow_storage_bay - overflow_storage_bay)
    (unit_finalization_recorded ?unitized_pallet - unitized_pallet)
  )
  (:action receive_and_register_unit
    :parameters (?unit - storage_unit)
    :precondition
      (and
        (not
          (unit_registered ?unit)
        )
        (not
          (cleared_for_dispatch ?unit)
        )
      )
    :effect (unit_registered ?unit)
  )
  (:action assign_distribution_channel_to_unit
    :parameters (?unit - storage_unit ?distribution_channel - distribution_channel)
    :precondition
      (and
        (unit_registered ?unit)
        (not
          (unit_channel_reserved ?unit)
        )
        (channel_available ?distribution_channel)
      )
    :effect
      (and
        (unit_channel_reserved ?unit)
        (unit_assigned_to_channel ?unit ?distribution_channel)
        (not
          (channel_available ?distribution_channel)
        )
      )
  )
  (:action assign_unit_to_conditioning_station
    :parameters (?unit - storage_unit ?conditioning_station - conditioning_station)
    :precondition
      (and
        (unit_registered ?unit)
        (unit_channel_reserved ?unit)
        (conditioning_station_available ?conditioning_station)
      )
    :effect
      (and
        (unit_assigned_to_station ?unit ?conditioning_station)
        (not
          (conditioning_station_available ?conditioning_station)
        )
      )
  )
  (:action finalize_conditioning_for_unit
    :parameters (?unit - storage_unit ?conditioning_station - conditioning_station)
    :precondition
      (and
        (unit_registered ?unit)
        (unit_channel_reserved ?unit)
        (unit_assigned_to_station ?unit ?conditioning_station)
        (not
          (unit_quality_cleared ?unit)
        )
      )
    :effect (unit_quality_cleared ?unit)
  )
  (:action release_conditioning_station
    :parameters (?unit - storage_unit ?conditioning_station - conditioning_station)
    :precondition
      (and
        (unit_assigned_to_station ?unit ?conditioning_station)
      )
    :effect
      (and
        (conditioning_station_available ?conditioning_station)
        (not
          (unit_assigned_to_station ?unit ?conditioning_station)
        )
      )
  )
  (:action reserve_handling_equipment_for_unit
    :parameters (?unit - storage_unit ?handling_equipment - handling_equipment)
    :precondition
      (and
        (unit_quality_cleared ?unit)
        (handling_equipment_available ?handling_equipment)
      )
    :effect
      (and
        (unit_assigned_to_handling_equipment ?unit ?handling_equipment)
        (not
          (handling_equipment_available ?handling_equipment)
        )
      )
  )
  (:action release_handling_equipment_from_unit
    :parameters (?unit - storage_unit ?handling_equipment - handling_equipment)
    :precondition
      (and
        (unit_assigned_to_handling_equipment ?unit ?handling_equipment)
      )
    :effect
      (and
        (handling_equipment_available ?handling_equipment)
        (not
          (unit_assigned_to_handling_equipment ?unit ?handling_equipment)
        )
      )
  )
  (:action apply_certification_to_unit
    :parameters (?unitized_pallet - unitized_pallet ?certification_stamp - certification_stamp)
    :precondition
      (and
        (unit_quality_cleared ?unitized_pallet)
        (certification_stamp_available ?certification_stamp)
      )
    :effect
      (and
        (unit_certified ?unitized_pallet ?certification_stamp)
        (not
          (certification_stamp_available ?certification_stamp)
        )
      )
  )
  (:action revoke_certification_from_unit
    :parameters (?unitized_pallet - unitized_pallet ?certification_stamp - certification_stamp)
    :precondition
      (and
        (unit_certified ?unitized_pallet ?certification_stamp)
      )
    :effect
      (and
        (certification_stamp_available ?certification_stamp)
        (not
          (unit_certified ?unitized_pallet ?certification_stamp)
        )
      )
  )
  (:action bind_shipping_permit_to_unit
    :parameters (?unitized_pallet - unitized_pallet ?shipping_permit_token - shipping_permit_token)
    :precondition
      (and
        (unit_quality_cleared ?unitized_pallet)
        (shipping_permit_available ?shipping_permit_token)
      )
    :effect
      (and
        (unit_permit_bound ?unitized_pallet ?shipping_permit_token)
        (not
          (shipping_permit_available ?shipping_permit_token)
        )
      )
  )
  (:action unbind_shipping_permit_from_unit
    :parameters (?unitized_pallet - unitized_pallet ?shipping_permit_token - shipping_permit_token)
    :precondition
      (and
        (unit_permit_bound ?unitized_pallet ?shipping_permit_token)
      )
    :effect
      (and
        (shipping_permit_available ?shipping_permit_token)
        (not
          (unit_permit_bound ?unitized_pallet ?shipping_permit_token)
        )
      )
  )
  (:action confirm_primary_route_for_primary_bay
    :parameters (?primary_storage_bay - primary_storage_bay ?primary_route_segment - primary_route_segment ?conditioning_station - conditioning_station)
    :precondition
      (and
        (unit_quality_cleared ?primary_storage_bay)
        (unit_assigned_to_station ?primary_storage_bay ?conditioning_station)
        (primary_bay_route_assigned ?primary_storage_bay ?primary_route_segment)
        (not
          (primary_route_confirmed ?primary_route_segment)
        )
        (not
          (primary_route_provisioned ?primary_route_segment)
        )
      )
    :effect (primary_route_confirmed ?primary_route_segment)
  )
  (:action allocate_handler_and_mark_primary_bay_ready
    :parameters (?primary_storage_bay - primary_storage_bay ?primary_route_segment - primary_route_segment ?handling_equipment - handling_equipment)
    :precondition
      (and
        (unit_quality_cleared ?primary_storage_bay)
        (unit_assigned_to_handling_equipment ?primary_storage_bay ?handling_equipment)
        (primary_bay_route_assigned ?primary_storage_bay ?primary_route_segment)
        (primary_route_confirmed ?primary_route_segment)
        (not
          (primary_bay_ready_flag ?primary_storage_bay)
        )
      )
    :effect
      (and
        (primary_bay_ready_flag ?primary_storage_bay)
        (primary_bay_ready_for_assembly ?primary_storage_bay)
      )
  )
  (:action assign_packaging_to_primary_bay
    :parameters (?primary_storage_bay - primary_storage_bay ?primary_route_segment - primary_route_segment ?packaging_item - packaging_item)
    :precondition
      (and
        (unit_quality_cleared ?primary_storage_bay)
        (primary_bay_route_assigned ?primary_storage_bay ?primary_route_segment)
        (packaging_item_available ?packaging_item)
        (not
          (primary_bay_ready_flag ?primary_storage_bay)
        )
      )
    :effect
      (and
        (primary_route_provisioned ?primary_route_segment)
        (primary_bay_ready_flag ?primary_storage_bay)
        (primary_bay_packaging_assigned ?primary_storage_bay ?packaging_item)
        (not
          (packaging_item_available ?packaging_item)
        )
      )
  )
  (:action finalize_packaging_for_primary_bay
    :parameters (?primary_storage_bay - primary_storage_bay ?primary_route_segment - primary_route_segment ?conditioning_station - conditioning_station ?packaging_item - packaging_item)
    :precondition
      (and
        (unit_quality_cleared ?primary_storage_bay)
        (unit_assigned_to_station ?primary_storage_bay ?conditioning_station)
        (primary_bay_route_assigned ?primary_storage_bay ?primary_route_segment)
        (primary_route_provisioned ?primary_route_segment)
        (primary_bay_packaging_assigned ?primary_storage_bay ?packaging_item)
        (not
          (primary_bay_ready_for_assembly ?primary_storage_bay)
        )
      )
    :effect
      (and
        (primary_route_confirmed ?primary_route_segment)
        (primary_bay_ready_for_assembly ?primary_storage_bay)
        (packaging_item_available ?packaging_item)
        (not
          (primary_bay_packaging_assigned ?primary_storage_bay ?packaging_item)
        )
      )
  )
  (:action confirm_overflow_route_for_overflow_bay
    :parameters (?overflow_storage_bay - overflow_storage_bay ?overflow_route_segment - overflow_route_segment ?conditioning_station - conditioning_station)
    :precondition
      (and
        (unit_quality_cleared ?overflow_storage_bay)
        (unit_assigned_to_station ?overflow_storage_bay ?conditioning_station)
        (overflow_bay_route_assigned ?overflow_storage_bay ?overflow_route_segment)
        (not
          (overflow_route_confirmed ?overflow_route_segment)
        )
        (not
          (overflow_route_provisioned ?overflow_route_segment)
        )
      )
    :effect (overflow_route_confirmed ?overflow_route_segment)
  )
  (:action allocate_handler_and_mark_overflow_bay_ready
    :parameters (?overflow_storage_bay - overflow_storage_bay ?overflow_route_segment - overflow_route_segment ?handling_equipment - handling_equipment)
    :precondition
      (and
        (unit_quality_cleared ?overflow_storage_bay)
        (unit_assigned_to_handling_equipment ?overflow_storage_bay ?handling_equipment)
        (overflow_bay_route_assigned ?overflow_storage_bay ?overflow_route_segment)
        (overflow_route_confirmed ?overflow_route_segment)
        (not
          (overflow_bay_ready_flag ?overflow_storage_bay)
        )
      )
    :effect
      (and
        (overflow_bay_ready_flag ?overflow_storage_bay)
        (overflow_bay_ready_for_assembly ?overflow_storage_bay)
      )
  )
  (:action assign_packaging_to_overflow_bay
    :parameters (?overflow_storage_bay - overflow_storage_bay ?overflow_route_segment - overflow_route_segment ?packaging_item - packaging_item)
    :precondition
      (and
        (unit_quality_cleared ?overflow_storage_bay)
        (overflow_bay_route_assigned ?overflow_storage_bay ?overflow_route_segment)
        (packaging_item_available ?packaging_item)
        (not
          (overflow_bay_ready_flag ?overflow_storage_bay)
        )
      )
    :effect
      (and
        (overflow_route_provisioned ?overflow_route_segment)
        (overflow_bay_ready_flag ?overflow_storage_bay)
        (overflow_bay_packaging_assigned ?overflow_storage_bay ?packaging_item)
        (not
          (packaging_item_available ?packaging_item)
        )
      )
  )
  (:action finalize_packaging_for_overflow_bay
    :parameters (?overflow_storage_bay - overflow_storage_bay ?overflow_route_segment - overflow_route_segment ?conditioning_station - conditioning_station ?packaging_item - packaging_item)
    :precondition
      (and
        (unit_quality_cleared ?overflow_storage_bay)
        (unit_assigned_to_station ?overflow_storage_bay ?conditioning_station)
        (overflow_bay_route_assigned ?overflow_storage_bay ?overflow_route_segment)
        (overflow_route_provisioned ?overflow_route_segment)
        (overflow_bay_packaging_assigned ?overflow_storage_bay ?packaging_item)
        (not
          (overflow_bay_ready_for_assembly ?overflow_storage_bay)
        )
      )
    :effect
      (and
        (overflow_route_confirmed ?overflow_route_segment)
        (overflow_bay_ready_for_assembly ?overflow_storage_bay)
        (packaging_item_available ?packaging_item)
        (not
          (overflow_bay_packaging_assigned ?overflow_storage_bay ?packaging_item)
        )
      )
  )
  (:action reserve_load_unit_and_bind_routes
    :parameters (?primary_storage_bay - primary_storage_bay ?overflow_storage_bay - overflow_storage_bay ?primary_route_segment - primary_route_segment ?overflow_route_segment - overflow_route_segment ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (primary_bay_ready_flag ?primary_storage_bay)
        (overflow_bay_ready_flag ?overflow_storage_bay)
        (primary_bay_route_assigned ?primary_storage_bay ?primary_route_segment)
        (overflow_bay_route_assigned ?overflow_storage_bay ?overflow_route_segment)
        (primary_route_confirmed ?primary_route_segment)
        (overflow_route_confirmed ?overflow_route_segment)
        (primary_bay_ready_for_assembly ?primary_storage_bay)
        (overflow_bay_ready_for_assembly ?overflow_storage_bay)
        (load_unit_available ?transport_load_unit)
      )
    :effect
      (and
        (load_unit_booked ?transport_load_unit)
        (load_unit_bound_to_primary_route ?transport_load_unit ?primary_route_segment)
        (load_unit_bound_to_overflow_route ?transport_load_unit ?overflow_route_segment)
        (not
          (load_unit_available ?transport_load_unit)
        )
      )
  )
  (:action reserve_load_unit_bind_routes_and_attach_manifest
    :parameters (?primary_storage_bay - primary_storage_bay ?overflow_storage_bay - overflow_storage_bay ?primary_route_segment - primary_route_segment ?overflow_route_segment - overflow_route_segment ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (primary_bay_ready_flag ?primary_storage_bay)
        (overflow_bay_ready_flag ?overflow_storage_bay)
        (primary_bay_route_assigned ?primary_storage_bay ?primary_route_segment)
        (overflow_bay_route_assigned ?overflow_storage_bay ?overflow_route_segment)
        (primary_route_provisioned ?primary_route_segment)
        (overflow_route_confirmed ?overflow_route_segment)
        (not
          (primary_bay_ready_for_assembly ?primary_storage_bay)
        )
        (overflow_bay_ready_for_assembly ?overflow_storage_bay)
        (load_unit_available ?transport_load_unit)
      )
    :effect
      (and
        (load_unit_booked ?transport_load_unit)
        (load_unit_bound_to_primary_route ?transport_load_unit ?primary_route_segment)
        (load_unit_bound_to_overflow_route ?transport_load_unit ?overflow_route_segment)
        (load_unit_manifest_attached ?transport_load_unit)
        (not
          (load_unit_available ?transport_load_unit)
        )
      )
  )
  (:action reserve_load_unit_bind_routes_and_attach_priority
    :parameters (?primary_storage_bay - primary_storage_bay ?overflow_storage_bay - overflow_storage_bay ?primary_route_segment - primary_route_segment ?overflow_route_segment - overflow_route_segment ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (primary_bay_ready_flag ?primary_storage_bay)
        (overflow_bay_ready_flag ?overflow_storage_bay)
        (primary_bay_route_assigned ?primary_storage_bay ?primary_route_segment)
        (overflow_bay_route_assigned ?overflow_storage_bay ?overflow_route_segment)
        (primary_route_confirmed ?primary_route_segment)
        (overflow_route_provisioned ?overflow_route_segment)
        (primary_bay_ready_for_assembly ?primary_storage_bay)
        (not
          (overflow_bay_ready_for_assembly ?overflow_storage_bay)
        )
        (load_unit_available ?transport_load_unit)
      )
    :effect
      (and
        (load_unit_booked ?transport_load_unit)
        (load_unit_bound_to_primary_route ?transport_load_unit ?primary_route_segment)
        (load_unit_bound_to_overflow_route ?transport_load_unit ?overflow_route_segment)
        (load_unit_priority_flag ?transport_load_unit)
        (not
          (load_unit_available ?transport_load_unit)
        )
      )
  )
  (:action reserve_load_unit_bind_routes_attach_manifest_and_priority
    :parameters (?primary_storage_bay - primary_storage_bay ?overflow_storage_bay - overflow_storage_bay ?primary_route_segment - primary_route_segment ?overflow_route_segment - overflow_route_segment ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (primary_bay_ready_flag ?primary_storage_bay)
        (overflow_bay_ready_flag ?overflow_storage_bay)
        (primary_bay_route_assigned ?primary_storage_bay ?primary_route_segment)
        (overflow_bay_route_assigned ?overflow_storage_bay ?overflow_route_segment)
        (primary_route_provisioned ?primary_route_segment)
        (overflow_route_provisioned ?overflow_route_segment)
        (not
          (primary_bay_ready_for_assembly ?primary_storage_bay)
        )
        (not
          (overflow_bay_ready_for_assembly ?overflow_storage_bay)
        )
        (load_unit_available ?transport_load_unit)
      )
    :effect
      (and
        (load_unit_booked ?transport_load_unit)
        (load_unit_bound_to_primary_route ?transport_load_unit ?primary_route_segment)
        (load_unit_bound_to_overflow_route ?transport_load_unit ?overflow_route_segment)
        (load_unit_manifest_attached ?transport_load_unit)
        (load_unit_priority_flag ?transport_load_unit)
        (not
          (load_unit_available ?transport_load_unit)
        )
      )
  )
  (:action finalize_load_unit_manifest
    :parameters (?transport_load_unit - transport_load_unit ?primary_storage_bay - primary_storage_bay ?conditioning_station - conditioning_station)
    :precondition
      (and
        (load_unit_booked ?transport_load_unit)
        (primary_bay_ready_flag ?primary_storage_bay)
        (unit_assigned_to_station ?primary_storage_bay ?conditioning_station)
        (not
          (load_unit_manifest_finalized ?transport_load_unit)
        )
      )
    :effect (load_unit_manifest_finalized ?transport_load_unit)
  )
  (:action allocate_container_to_unit_and_bind_to_load
    :parameters (?unitized_pallet - unitized_pallet ?container_pallet - container_pallet ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (unit_quality_cleared ?unitized_pallet)
        (unit_bound_to_load ?unitized_pallet ?transport_load_unit)
        (unit_container_association ?unitized_pallet ?container_pallet)
        (container_available ?container_pallet)
        (load_unit_booked ?transport_load_unit)
        (load_unit_manifest_finalized ?transport_load_unit)
        (not
          (container_reserved ?container_pallet)
        )
      )
    :effect
      (and
        (container_reserved ?container_pallet)
        (container_bound_to_load ?container_pallet ?transport_load_unit)
        (not
          (container_available ?container_pallet)
        )
      )
  )
  (:action initiate_containerization_for_unit
    :parameters (?unitized_pallet - unitized_pallet ?container_pallet - container_pallet ?transport_load_unit - transport_load_unit ?conditioning_station - conditioning_station)
    :precondition
      (and
        (unit_quality_cleared ?unitized_pallet)
        (unit_container_association ?unitized_pallet ?container_pallet)
        (container_reserved ?container_pallet)
        (container_bound_to_load ?container_pallet ?transport_load_unit)
        (unit_assigned_to_station ?unitized_pallet ?conditioning_station)
        (not
          (load_unit_manifest_attached ?transport_load_unit)
        )
        (not
          (unit_containerization_initiated ?unitized_pallet)
        )
      )
    :effect (unit_containerization_initiated ?unitized_pallet)
  )
  (:action assign_special_handling_instruction_to_unit
    :parameters (?unitized_pallet - unitized_pallet ?special_handling_instruction - special_handling_instruction)
    :precondition
      (and
        (unit_quality_cleared ?unitized_pallet)
        (special_handling_instruction_available ?special_handling_instruction)
        (not
          (unit_handling_instruction_applied ?unitized_pallet)
        )
      )
    :effect
      (and
        (unit_handling_instruction_applied ?unitized_pallet)
        (unit_special_handling_assigned ?unitized_pallet ?special_handling_instruction)
        (not
          (special_handling_instruction_available ?special_handling_instruction)
        )
      )
  )
  (:action apply_handling_instruction_and_progress_containerization
    :parameters (?unitized_pallet - unitized_pallet ?container_pallet - container_pallet ?transport_load_unit - transport_load_unit ?conditioning_station - conditioning_station ?special_handling_instruction - special_handling_instruction)
    :precondition
      (and
        (unit_quality_cleared ?unitized_pallet)
        (unit_container_association ?unitized_pallet ?container_pallet)
        (container_reserved ?container_pallet)
        (container_bound_to_load ?container_pallet ?transport_load_unit)
        (unit_assigned_to_station ?unitized_pallet ?conditioning_station)
        (load_unit_manifest_attached ?transport_load_unit)
        (unit_handling_instruction_applied ?unitized_pallet)
        (unit_special_handling_assigned ?unitized_pallet ?special_handling_instruction)
        (not
          (unit_containerization_initiated ?unitized_pallet)
        )
      )
    :effect
      (and
        (unit_containerization_initiated ?unitized_pallet)
        (unit_handling_instruction_confirmed ?unitized_pallet)
      )
  )
  (:action perform_certified_packaging_step_on_unit
    :parameters (?unitized_pallet - unitized_pallet ?certification_stamp - certification_stamp ?handling_equipment - handling_equipment ?container_pallet - container_pallet ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (unit_containerization_initiated ?unitized_pallet)
        (unit_certified ?unitized_pallet ?certification_stamp)
        (unit_assigned_to_handling_equipment ?unitized_pallet ?handling_equipment)
        (unit_container_association ?unitized_pallet ?container_pallet)
        (container_bound_to_load ?container_pallet ?transport_load_unit)
        (not
          (load_unit_priority_flag ?transport_load_unit)
        )
        (not
          (unit_packaging_confirmed ?unitized_pallet)
        )
      )
    :effect (unit_packaging_confirmed ?unitized_pallet)
  )
  (:action perform_certified_packaging_step_on_unit_with_priority
    :parameters (?unitized_pallet - unitized_pallet ?certification_stamp - certification_stamp ?handling_equipment - handling_equipment ?container_pallet - container_pallet ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (unit_containerization_initiated ?unitized_pallet)
        (unit_certified ?unitized_pallet ?certification_stamp)
        (unit_assigned_to_handling_equipment ?unitized_pallet ?handling_equipment)
        (unit_container_association ?unitized_pallet ?container_pallet)
        (container_bound_to_load ?container_pallet ?transport_load_unit)
        (load_unit_priority_flag ?transport_load_unit)
        (not
          (unit_packaging_confirmed ?unitized_pallet)
        )
      )
    :effect (unit_packaging_confirmed ?unitized_pallet)
  )
  (:action apply_permit_and_mark_unit_for_finalization
    :parameters (?unitized_pallet - unitized_pallet ?shipping_permit_token - shipping_permit_token ?container_pallet - container_pallet ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (unit_packaging_confirmed ?unitized_pallet)
        (unit_permit_bound ?unitized_pallet ?shipping_permit_token)
        (unit_container_association ?unitized_pallet ?container_pallet)
        (container_bound_to_load ?container_pallet ?transport_load_unit)
        (not
          (load_unit_manifest_attached ?transport_load_unit)
        )
        (not
          (load_unit_priority_flag ?transport_load_unit)
        )
        (not
          (unit_packaging_ready_for_finalization ?unitized_pallet)
        )
      )
    :effect (unit_packaging_ready_for_finalization ?unitized_pallet)
  )
  (:action apply_permit_and_mark_unit_for_finalization_with_manifest
    :parameters (?unitized_pallet - unitized_pallet ?shipping_permit_token - shipping_permit_token ?container_pallet - container_pallet ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (unit_packaging_confirmed ?unitized_pallet)
        (unit_permit_bound ?unitized_pallet ?shipping_permit_token)
        (unit_container_association ?unitized_pallet ?container_pallet)
        (container_bound_to_load ?container_pallet ?transport_load_unit)
        (load_unit_manifest_attached ?transport_load_unit)
        (not
          (load_unit_priority_flag ?transport_load_unit)
        )
        (not
          (unit_packaging_ready_for_finalization ?unitized_pallet)
        )
      )
    :effect
      (and
        (unit_packaging_ready_for_finalization ?unitized_pallet)
        (unit_packaging_spec_applied ?unitized_pallet)
      )
  )
  (:action apply_permit_and_mark_unit_for_finalization_with_priority
    :parameters (?unitized_pallet - unitized_pallet ?shipping_permit_token - shipping_permit_token ?container_pallet - container_pallet ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (unit_packaging_confirmed ?unitized_pallet)
        (unit_permit_bound ?unitized_pallet ?shipping_permit_token)
        (unit_container_association ?unitized_pallet ?container_pallet)
        (container_bound_to_load ?container_pallet ?transport_load_unit)
        (not
          (load_unit_manifest_attached ?transport_load_unit)
        )
        (load_unit_priority_flag ?transport_load_unit)
        (not
          (unit_packaging_ready_for_finalization ?unitized_pallet)
        )
      )
    :effect
      (and
        (unit_packaging_ready_for_finalization ?unitized_pallet)
        (unit_packaging_spec_applied ?unitized_pallet)
      )
  )
  (:action apply_permit_and_mark_unit_for_finalization_with_manifest_and_priority
    :parameters (?unitized_pallet - unitized_pallet ?shipping_permit_token - shipping_permit_token ?container_pallet - container_pallet ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (unit_packaging_confirmed ?unitized_pallet)
        (unit_permit_bound ?unitized_pallet ?shipping_permit_token)
        (unit_container_association ?unitized_pallet ?container_pallet)
        (container_bound_to_load ?container_pallet ?transport_load_unit)
        (load_unit_manifest_attached ?transport_load_unit)
        (load_unit_priority_flag ?transport_load_unit)
        (not
          (unit_packaging_ready_for_finalization ?unitized_pallet)
        )
      )
    :effect
      (and
        (unit_packaging_ready_for_finalization ?unitized_pallet)
        (unit_packaging_spec_applied ?unitized_pallet)
      )
  )
  (:action record_unit_finalization
    :parameters (?unitized_pallet - unitized_pallet)
    :precondition
      (and
        (unit_packaging_ready_for_finalization ?unitized_pallet)
        (not
          (unit_packaging_spec_applied ?unitized_pallet)
        )
        (not
          (unit_finalization_recorded ?unitized_pallet)
        )
      )
    :effect
      (and
        (unit_finalization_recorded ?unitized_pallet)
        (unit_finalization_verified ?unitized_pallet)
      )
  )
  (:action attach_packaging_spec_to_unit
    :parameters (?unitized_pallet - unitized_pallet ?packaging_specification - packaging_specification)
    :precondition
      (and
        (unit_packaging_ready_for_finalization ?unitized_pallet)
        (unit_packaging_spec_applied ?unitized_pallet)
        (packaging_spec_available ?packaging_specification)
      )
    :effect
      (and
        (unit_packaging_spec_bound ?unitized_pallet ?packaging_specification)
        (not
          (packaging_spec_available ?packaging_specification)
        )
      )
  )
  (:action consolidate_unit_for_dispatch
    :parameters (?unitized_pallet - unitized_pallet ?primary_storage_bay - primary_storage_bay ?overflow_storage_bay - overflow_storage_bay ?conditioning_station - conditioning_station ?packaging_specification - packaging_specification)
    :precondition
      (and
        (unit_packaging_ready_for_finalization ?unitized_pallet)
        (unit_packaging_spec_applied ?unitized_pallet)
        (unit_packaging_spec_bound ?unitized_pallet ?packaging_specification)
        (unit_in_primary_bay ?unitized_pallet ?primary_storage_bay)
        (unit_in_overflow_bay ?unitized_pallet ?overflow_storage_bay)
        (primary_bay_ready_for_assembly ?primary_storage_bay)
        (overflow_bay_ready_for_assembly ?overflow_storage_bay)
        (unit_assigned_to_station ?unitized_pallet ?conditioning_station)
        (not
          (unit_ready_for_final_assembly ?unitized_pallet)
        )
      )
    :effect (unit_ready_for_final_assembly ?unitized_pallet)
  )
  (:action finalize_and_mark_unit_for_release
    :parameters (?unitized_pallet - unitized_pallet)
    :precondition
      (and
        (unit_packaging_ready_for_finalization ?unitized_pallet)
        (unit_ready_for_final_assembly ?unitized_pallet)
        (not
          (unit_finalization_recorded ?unitized_pallet)
        )
      )
    :effect
      (and
        (unit_finalization_recorded ?unitized_pallet)
        (unit_finalization_verified ?unitized_pallet)
      )
  )
  (:action apply_authorization_to_unit
    :parameters (?unitized_pallet - unitized_pallet ?authorization_document - authorization_document ?conditioning_station - conditioning_station)
    :precondition
      (and
        (unit_quality_cleared ?unitized_pallet)
        (unit_assigned_to_station ?unitized_pallet ?conditioning_station)
        (authorization_document_available ?authorization_document)
        (unit_authorization_assigned ?unitized_pallet ?authorization_document)
        (not
          (unit_authorized ?unitized_pallet)
        )
      )
    :effect
      (and
        (unit_authorized ?unitized_pallet)
        (not
          (authorization_document_available ?authorization_document)
        )
      )
  )
  (:action acknowledge_authorization_for_unit
    :parameters (?unitized_pallet - unitized_pallet ?handling_equipment - handling_equipment)
    :precondition
      (and
        (unit_authorized ?unitized_pallet)
        (unit_assigned_to_handling_equipment ?unitized_pallet ?handling_equipment)
        (not
          (unit_authorization_acknowledged ?unitized_pallet)
        )
      )
    :effect (unit_authorization_acknowledged ?unitized_pallet)
  )
  (:action apply_shipping_permit_after_authorization
    :parameters (?unitized_pallet - unitized_pallet ?shipping_permit_token - shipping_permit_token)
    :precondition
      (and
        (unit_authorization_acknowledged ?unitized_pallet)
        (unit_permit_bound ?unitized_pallet ?shipping_permit_token)
        (not
          (unit_permit_confirmed ?unitized_pallet)
        )
      )
    :effect (unit_permit_confirmed ?unitized_pallet)
  )
  (:action finalize_unit_after_permit
    :parameters (?unitized_pallet - unitized_pallet)
    :precondition
      (and
        (unit_permit_confirmed ?unitized_pallet)
        (not
          (unit_finalization_recorded ?unitized_pallet)
        )
      )
    :effect
      (and
        (unit_finalization_recorded ?unitized_pallet)
        (unit_finalization_verified ?unitized_pallet)
      )
  )
  (:action finalize_primary_bay_for_dispatch
    :parameters (?primary_storage_bay - primary_storage_bay ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (primary_bay_ready_flag ?primary_storage_bay)
        (primary_bay_ready_for_assembly ?primary_storage_bay)
        (load_unit_booked ?transport_load_unit)
        (load_unit_manifest_finalized ?transport_load_unit)
        (not
          (unit_finalization_verified ?primary_storage_bay)
        )
      )
    :effect (unit_finalization_verified ?primary_storage_bay)
  )
  (:action finalize_overflow_bay_for_dispatch
    :parameters (?overflow_storage_bay - overflow_storage_bay ?transport_load_unit - transport_load_unit)
    :precondition
      (and
        (overflow_bay_ready_flag ?overflow_storage_bay)
        (overflow_bay_ready_for_assembly ?overflow_storage_bay)
        (load_unit_booked ?transport_load_unit)
        (load_unit_manifest_finalized ?transport_load_unit)
        (not
          (unit_finalization_verified ?overflow_storage_bay)
        )
      )
    :effect (unit_finalization_verified ?overflow_storage_bay)
  )
  (:action allocate_destination_token_for_unit
    :parameters (?unit - storage_unit ?destination_allocation_token - destination_allocation_token ?conditioning_station - conditioning_station)
    :precondition
      (and
        (unit_finalization_verified ?unit)
        (unit_assigned_to_station ?unit ?conditioning_station)
        (destination_token_available ?destination_allocation_token)
        (not
          (unit_release_allocated ?unit)
        )
      )
    :effect
      (and
        (unit_release_allocated ?unit)
        (unit_destination_assigned ?unit ?destination_allocation_token)
        (not
          (destination_token_available ?destination_allocation_token)
        )
      )
  )
  (:action release_primary_bay_and_reserve_channel
    :parameters (?primary_storage_bay - primary_storage_bay ?distribution_channel - distribution_channel ?destination_allocation_token - destination_allocation_token)
    :precondition
      (and
        (unit_release_allocated ?primary_storage_bay)
        (unit_assigned_to_channel ?primary_storage_bay ?distribution_channel)
        (unit_destination_assigned ?primary_storage_bay ?destination_allocation_token)
        (not
          (cleared_for_dispatch ?primary_storage_bay)
        )
      )
    :effect
      (and
        (cleared_for_dispatch ?primary_storage_bay)
        (channel_available ?distribution_channel)
        (destination_token_available ?destination_allocation_token)
      )
  )
  (:action release_overflow_bay_and_reserve_channel
    :parameters (?overflow_storage_bay - overflow_storage_bay ?distribution_channel - distribution_channel ?destination_allocation_token - destination_allocation_token)
    :precondition
      (and
        (unit_release_allocated ?overflow_storage_bay)
        (unit_assigned_to_channel ?overflow_storage_bay ?distribution_channel)
        (unit_destination_assigned ?overflow_storage_bay ?destination_allocation_token)
        (not
          (cleared_for_dispatch ?overflow_storage_bay)
        )
      )
    :effect
      (and
        (cleared_for_dispatch ?overflow_storage_bay)
        (channel_available ?distribution_channel)
        (destination_token_available ?destination_allocation_token)
      )
  )
  (:action release_unit_and_reserve_channel
    :parameters (?unitized_pallet - unitized_pallet ?distribution_channel - distribution_channel ?destination_allocation_token - destination_allocation_token)
    :precondition
      (and
        (unit_release_allocated ?unitized_pallet)
        (unit_assigned_to_channel ?unitized_pallet ?distribution_channel)
        (unit_destination_assigned ?unitized_pallet ?destination_allocation_token)
        (not
          (cleared_for_dispatch ?unitized_pallet)
        )
      )
    :effect
      (and
        (cleared_for_dispatch ?unitized_pallet)
        (channel_available ?distribution_channel)
        (destination_token_available ?destination_allocation_token)
      )
  )
)

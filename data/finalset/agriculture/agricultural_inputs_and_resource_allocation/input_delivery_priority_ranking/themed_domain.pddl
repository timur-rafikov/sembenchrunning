(define (domain agriculture_input_delivery_priority_ranking)
  (:requirements :strips :typing :negative-preconditions)
  (:types physical_entity - object resource_supertype - physical_entity priority_supertype - physical_entity logistics_supertype - physical_entity beneficiary_root - physical_entity beneficiary_unit - beneficiary_root supplier_asset - resource_supertype input_type - resource_supertype machinery_or_crew - resource_supertype regulatory_permit - resource_supertype timeslot - resource_supertype contingency_reserve - resource_supertype resource_bundle_standard - resource_supertype emergency_bundle - resource_supertype supply_batch - priority_supertype allocation_voucher - priority_supertype specialist_credential - priority_supertype priority_axis_seasonal - logistics_supertype priority_axis_operational - logistics_supertype delivery_order - logistics_supertype beneficiary_subset - beneficiary_unit beneficiary_subset_alt - beneficiary_unit crop_plot - beneficiary_subset livestock_unit - beneficiary_subset distribution_node - beneficiary_subset_alt)

  (:predicates
    (request_registered ?beneficiary_unit - beneficiary_unit)
    (entity_request_validated ?beneficiary_unit - beneficiary_unit)
    (beneficiary_assigned_supplier_flag ?beneficiary_unit - beneficiary_unit)
    (entity_delivery_committed ?beneficiary_unit - beneficiary_unit)
    (entity_delivery_confirmed ?beneficiary_unit - beneficiary_unit)
    (contingency_allocated ?beneficiary_unit - beneficiary_unit)
    (supplier_available ?supplier_asset - supplier_asset)
    (beneficiary_assigned_supplier ?beneficiary_unit - beneficiary_unit ?supplier_asset - supplier_asset)
    (input_available ?input_type_var - input_type)
    (reserved_input ?beneficiary_unit - beneficiary_unit ?input_type_var - input_type)
    (machinery_available ?machinery_crew - machinery_or_crew)
    (assigned_machinery ?beneficiary_unit - beneficiary_unit ?machinery_crew - machinery_or_crew)
    (batch_available ?supply_batch - supply_batch)
    (plot_allocated_batch ?plot_var - crop_plot ?supply_batch - supply_batch)
    (livestock_allocated_batch ?livestock_var - livestock_unit ?supply_batch - supply_batch)
    (plot_seasonal_priority ?plot_var - crop_plot ?seasonal_priority - priority_axis_seasonal)
    (seasonal_priority_confirmed ?seasonal_priority - priority_axis_seasonal)
    (seasonal_priority_pending ?seasonal_priority - priority_axis_seasonal)
    (plot_ready_for_dispatch ?plot_var - crop_plot)
    (livestock_operational_priority ?livestock_var - livestock_unit ?operational_priority - priority_axis_operational)
    (operational_priority_active ?operational_priority - priority_axis_operational)
    (operational_priority_pending ?operational_priority - priority_axis_operational)
    (livestock_ready_for_dispatch ?livestock_var - livestock_unit)
    (delivery_order_open ?delivery_order - delivery_order)
    (order_ready ?delivery_order - delivery_order)
    (order_has_seasonal_priority ?delivery_order - delivery_order ?seasonal_priority - priority_axis_seasonal)
    (order_has_operational_priority ?delivery_order - delivery_order ?operational_priority - priority_axis_operational)
    (order_flag_seasonal_pending ?delivery_order - delivery_order)
    (order_flag_operational_pending ?delivery_order - delivery_order)
    (order_shipment_verified ?delivery_order - delivery_order)
    (node_serves_plot ?distribution_node - distribution_node ?plot_var - crop_plot)
    (node_serves_livestock ?distribution_node - distribution_node ?livestock_var - livestock_unit)
    (node_assigned_order ?distribution_node - distribution_node ?delivery_order - delivery_order)
    (voucher_available ?allocation_voucher - allocation_voucher)
    (node_has_voucher ?distribution_node - distribution_node ?allocation_voucher - allocation_voucher)
    (voucher_redeemed ?allocation_voucher - allocation_voucher)
    (voucher_bound_to_order ?allocation_voucher - allocation_voucher ?delivery_order - delivery_order)
    (node_authorized ?distribution_node - distribution_node)
    (node_bundle_staged ?distribution_node - distribution_node)
    (node_preparation_complete ?distribution_node - distribution_node)
    (permit_registered ?distribution_node - distribution_node)
    (node_permit_verified ?distribution_node - distribution_node)
    (node_staged_for_scheduling ?distribution_node - distribution_node)
    (node_resources_allocated ?distribution_node - distribution_node)
    (credential_available ?specialist_credential - specialist_credential)
    (node_has_credential ?distribution_node - distribution_node ?specialist_credential - specialist_credential)
    (node_credential_approved ?distribution_node - distribution_node)
    (node_credential_used ?distribution_node - distribution_node)
    (node_credential_confirmed ?distribution_node - distribution_node)
    (permit_available ?regulatory_permit - regulatory_permit)
    (node_has_permit ?distribution_node - distribution_node ?regulatory_permit - regulatory_permit)
    (timeslot_available ?timeslot_var - timeslot)
    (node_scheduled_timeslot ?distribution_node - distribution_node ?timeslot_var - timeslot)
    (standard_bundle_available ?standard_resource_bundle - resource_bundle_standard)
    (node_allocated_standard_bundle ?distribution_node - distribution_node ?standard_resource_bundle - resource_bundle_standard)
    (emergency_bundle_available ?emergency_bundle - emergency_bundle)
    (node_allocated_emergency_bundle ?distribution_node - distribution_node ?emergency_bundle - emergency_bundle)
    (contingency_reserve_available ?contingency_reserve - contingency_reserve)
    (beneficiary_has_contingency_reserve ?beneficiary_unit - beneficiary_unit ?contingency_reserve - contingency_reserve)
    (plot_local_score_set ?plot_var - crop_plot)
    (livestock_local_score_set ?livestock_var - livestock_unit)
    (dispatch_authorized ?distribution_node - distribution_node)
  )
  (:action register_beneficiary_request
    :parameters (?beneficiary_unit - beneficiary_unit)
    :precondition
      (and
        (not
          (request_registered ?beneficiary_unit)
        )
        (not
          (entity_delivery_committed ?beneficiary_unit)
        )
      )
    :effect (request_registered ?beneficiary_unit)
  )
  (:action assign_supplier_to_request
    :parameters (?beneficiary_unit - beneficiary_unit ?supplier_asset - supplier_asset)
    :precondition
      (and
        (request_registered ?beneficiary_unit)
        (not
          (beneficiary_assigned_supplier_flag ?beneficiary_unit)
        )
        (supplier_available ?supplier_asset)
      )
    :effect
      (and
        (beneficiary_assigned_supplier_flag ?beneficiary_unit)
        (beneficiary_assigned_supplier ?beneficiary_unit ?supplier_asset)
        (not
          (supplier_available ?supplier_asset)
        )
      )
  )
  (:action reserve_input_item
    :parameters (?beneficiary_unit - beneficiary_unit ?input_type_var - input_type)
    :precondition
      (and
        (request_registered ?beneficiary_unit)
        (beneficiary_assigned_supplier_flag ?beneficiary_unit)
        (input_available ?input_type_var)
      )
    :effect
      (and
        (reserved_input ?beneficiary_unit ?input_type_var)
        (not
          (input_available ?input_type_var)
        )
      )
  )
  (:action confirm_request_validation
    :parameters (?beneficiary_unit - beneficiary_unit ?input_type_var - input_type)
    :precondition
      (and
        (request_registered ?beneficiary_unit)
        (beneficiary_assigned_supplier_flag ?beneficiary_unit)
        (reserved_input ?beneficiary_unit ?input_type_var)
        (not
          (entity_request_validated ?beneficiary_unit)
        )
      )
    :effect (entity_request_validated ?beneficiary_unit)
  )
  (:action release_reserved_input
    :parameters (?beneficiary_unit - beneficiary_unit ?input_type_var - input_type)
    :precondition
      (and
        (reserved_input ?beneficiary_unit ?input_type_var)
      )
    :effect
      (and
        (input_available ?input_type_var)
        (not
          (reserved_input ?beneficiary_unit ?input_type_var)
        )
      )
  )
  (:action assign_machinery
    :parameters (?beneficiary_unit - beneficiary_unit ?machinery_crew - machinery_or_crew)
    :precondition
      (and
        (entity_request_validated ?beneficiary_unit)
        (machinery_available ?machinery_crew)
      )
    :effect
      (and
        (assigned_machinery ?beneficiary_unit ?machinery_crew)
        (not
          (machinery_available ?machinery_crew)
        )
      )
  )
  (:action release_machinery_assignment
    :parameters (?beneficiary_unit - beneficiary_unit ?machinery_crew - machinery_or_crew)
    :precondition
      (and
        (assigned_machinery ?beneficiary_unit ?machinery_crew)
      )
    :effect
      (and
        (machinery_available ?machinery_crew)
        (not
          (assigned_machinery ?beneficiary_unit ?machinery_crew)
        )
      )
  )
  (:action allocate_standard_bundle
    :parameters (?distribution_node - distribution_node ?standard_resource_bundle - resource_bundle_standard)
    :precondition
      (and
        (entity_request_validated ?distribution_node)
        (standard_bundle_available ?standard_resource_bundle)
      )
    :effect
      (and
        (node_allocated_standard_bundle ?distribution_node ?standard_resource_bundle)
        (not
          (standard_bundle_available ?standard_resource_bundle)
        )
      )
  )
  (:action release_standard_bundle
    :parameters (?distribution_node - distribution_node ?standard_resource_bundle - resource_bundle_standard)
    :precondition
      (and
        (node_allocated_standard_bundle ?distribution_node ?standard_resource_bundle)
      )
    :effect
      (and
        (standard_bundle_available ?standard_resource_bundle)
        (not
          (node_allocated_standard_bundle ?distribution_node ?standard_resource_bundle)
        )
      )
  )
  (:action allocate_emergency_bundle
    :parameters (?distribution_node - distribution_node ?emergency_bundle - emergency_bundle)
    :precondition
      (and
        (entity_request_validated ?distribution_node)
        (emergency_bundle_available ?emergency_bundle)
      )
    :effect
      (and
        (node_allocated_emergency_bundle ?distribution_node ?emergency_bundle)
        (not
          (emergency_bundle_available ?emergency_bundle)
        )
      )
  )
  (:action release_emergency_bundle
    :parameters (?distribution_node - distribution_node ?emergency_bundle - emergency_bundle)
    :precondition
      (and
        (node_allocated_emergency_bundle ?distribution_node ?emergency_bundle)
      )
    :effect
      (and
        (emergency_bundle_available ?emergency_bundle)
        (not
          (node_allocated_emergency_bundle ?distribution_node ?emergency_bundle)
        )
      )
  )
  (:action activate_seasonal_priority
    :parameters (?plot_var - crop_plot ?seasonal_priority - priority_axis_seasonal ?input_type_var - input_type)
    :precondition
      (and
        (entity_request_validated ?plot_var)
        (reserved_input ?plot_var ?input_type_var)
        (plot_seasonal_priority ?plot_var ?seasonal_priority)
        (not
          (seasonal_priority_confirmed ?seasonal_priority)
        )
        (not
          (seasonal_priority_pending ?seasonal_priority)
        )
      )
    :effect (seasonal_priority_confirmed ?seasonal_priority)
  )
  (:action allocate_machinery_and_mark_plot
    :parameters (?plot_var - crop_plot ?seasonal_priority - priority_axis_seasonal ?machinery_crew - machinery_or_crew)
    :precondition
      (and
        (entity_request_validated ?plot_var)
        (assigned_machinery ?plot_var ?machinery_crew)
        (plot_seasonal_priority ?plot_var ?seasonal_priority)
        (seasonal_priority_confirmed ?seasonal_priority)
        (not
          (plot_local_score_set ?plot_var)
        )
      )
    :effect
      (and
        (plot_local_score_set ?plot_var)
        (plot_ready_for_dispatch ?plot_var)
      )
  )
  (:action allocate_batch_to_plot_and_mark
    :parameters (?plot_var - crop_plot ?seasonal_priority - priority_axis_seasonal ?supply_batch - supply_batch)
    :precondition
      (and
        (entity_request_validated ?plot_var)
        (plot_seasonal_priority ?plot_var ?seasonal_priority)
        (batch_available ?supply_batch)
        (not
          (plot_local_score_set ?plot_var)
        )
      )
    :effect
      (and
        (seasonal_priority_pending ?seasonal_priority)
        (plot_local_score_set ?plot_var)
        (plot_allocated_batch ?plot_var ?supply_batch)
        (not
          (batch_available ?supply_batch)
        )
      )
  )
  (:action finalize_plot_batch_allocation
    :parameters (?plot_var - crop_plot ?seasonal_priority - priority_axis_seasonal ?input_type_var - input_type ?supply_batch - supply_batch)
    :precondition
      (and
        (entity_request_validated ?plot_var)
        (reserved_input ?plot_var ?input_type_var)
        (plot_seasonal_priority ?plot_var ?seasonal_priority)
        (seasonal_priority_pending ?seasonal_priority)
        (plot_allocated_batch ?plot_var ?supply_batch)
        (not
          (plot_ready_for_dispatch ?plot_var)
        )
      )
    :effect
      (and
        (seasonal_priority_confirmed ?seasonal_priority)
        (plot_ready_for_dispatch ?plot_var)
        (batch_available ?supply_batch)
        (not
          (plot_allocated_batch ?plot_var ?supply_batch)
        )
      )
  )
  (:action activate_operational_priority
    :parameters (?livestock_var - livestock_unit ?operational_priority - priority_axis_operational ?input_type_var - input_type)
    :precondition
      (and
        (entity_request_validated ?livestock_var)
        (reserved_input ?livestock_var ?input_type_var)
        (livestock_operational_priority ?livestock_var ?operational_priority)
        (not
          (operational_priority_active ?operational_priority)
        )
        (not
          (operational_priority_pending ?operational_priority)
        )
      )
    :effect (operational_priority_active ?operational_priority)
  )
  (:action allocate_machinery_and_mark_livestock
    :parameters (?livestock_var - livestock_unit ?operational_priority - priority_axis_operational ?machinery_crew - machinery_or_crew)
    :precondition
      (and
        (entity_request_validated ?livestock_var)
        (assigned_machinery ?livestock_var ?machinery_crew)
        (livestock_operational_priority ?livestock_var ?operational_priority)
        (operational_priority_active ?operational_priority)
        (not
          (livestock_local_score_set ?livestock_var)
        )
      )
    :effect
      (and
        (livestock_local_score_set ?livestock_var)
        (livestock_ready_for_dispatch ?livestock_var)
      )
  )
  (:action allocate_batch_to_livestock_and_mark
    :parameters (?livestock_var - livestock_unit ?operational_priority - priority_axis_operational ?supply_batch - supply_batch)
    :precondition
      (and
        (entity_request_validated ?livestock_var)
        (livestock_operational_priority ?livestock_var ?operational_priority)
        (batch_available ?supply_batch)
        (not
          (livestock_local_score_set ?livestock_var)
        )
      )
    :effect
      (and
        (operational_priority_pending ?operational_priority)
        (livestock_local_score_set ?livestock_var)
        (livestock_allocated_batch ?livestock_var ?supply_batch)
        (not
          (batch_available ?supply_batch)
        )
      )
  )
  (:action finalize_livestock_batch_allocation
    :parameters (?livestock_var - livestock_unit ?operational_priority - priority_axis_operational ?input_type_var - input_type ?supply_batch - supply_batch)
    :precondition
      (and
        (entity_request_validated ?livestock_var)
        (reserved_input ?livestock_var ?input_type_var)
        (livestock_operational_priority ?livestock_var ?operational_priority)
        (operational_priority_pending ?operational_priority)
        (livestock_allocated_batch ?livestock_var ?supply_batch)
        (not
          (livestock_ready_for_dispatch ?livestock_var)
        )
      )
    :effect
      (and
        (operational_priority_active ?operational_priority)
        (livestock_ready_for_dispatch ?livestock_var)
        (batch_available ?supply_batch)
        (not
          (livestock_allocated_batch ?livestock_var ?supply_batch)
        )
      )
  )
  (:action assemble_delivery_order
    :parameters (?plot_var - crop_plot ?livestock_var - livestock_unit ?seasonal_priority - priority_axis_seasonal ?operational_priority - priority_axis_operational ?delivery_order - delivery_order)
    :precondition
      (and
        (plot_local_score_set ?plot_var)
        (livestock_local_score_set ?livestock_var)
        (plot_seasonal_priority ?plot_var ?seasonal_priority)
        (livestock_operational_priority ?livestock_var ?operational_priority)
        (seasonal_priority_confirmed ?seasonal_priority)
        (operational_priority_active ?operational_priority)
        (plot_ready_for_dispatch ?plot_var)
        (livestock_ready_for_dispatch ?livestock_var)
        (delivery_order_open ?delivery_order)
      )
    :effect
      (and
        (order_ready ?delivery_order)
        (order_has_seasonal_priority ?delivery_order ?seasonal_priority)
        (order_has_operational_priority ?delivery_order ?operational_priority)
        (not
          (delivery_order_open ?delivery_order)
        )
      )
  )
  (:action assemble_order_seasonal_pending
    :parameters (?plot_var - crop_plot ?livestock_var - livestock_unit ?seasonal_priority - priority_axis_seasonal ?operational_priority - priority_axis_operational ?delivery_order - delivery_order)
    :precondition
      (and
        (plot_local_score_set ?plot_var)
        (livestock_local_score_set ?livestock_var)
        (plot_seasonal_priority ?plot_var ?seasonal_priority)
        (livestock_operational_priority ?livestock_var ?operational_priority)
        (seasonal_priority_pending ?seasonal_priority)
        (operational_priority_active ?operational_priority)
        (not
          (plot_ready_for_dispatch ?plot_var)
        )
        (livestock_ready_for_dispatch ?livestock_var)
        (delivery_order_open ?delivery_order)
      )
    :effect
      (and
        (order_ready ?delivery_order)
        (order_has_seasonal_priority ?delivery_order ?seasonal_priority)
        (order_has_operational_priority ?delivery_order ?operational_priority)
        (order_flag_seasonal_pending ?delivery_order)
        (not
          (delivery_order_open ?delivery_order)
        )
      )
  )
  (:action assemble_order_operational_pending
    :parameters (?plot_var - crop_plot ?livestock_var - livestock_unit ?seasonal_priority - priority_axis_seasonal ?operational_priority - priority_axis_operational ?delivery_order - delivery_order)
    :precondition
      (and
        (plot_local_score_set ?plot_var)
        (livestock_local_score_set ?livestock_var)
        (plot_seasonal_priority ?plot_var ?seasonal_priority)
        (livestock_operational_priority ?livestock_var ?operational_priority)
        (seasonal_priority_confirmed ?seasonal_priority)
        (operational_priority_pending ?operational_priority)
        (plot_ready_for_dispatch ?plot_var)
        (not
          (livestock_ready_for_dispatch ?livestock_var)
        )
        (delivery_order_open ?delivery_order)
      )
    :effect
      (and
        (order_ready ?delivery_order)
        (order_has_seasonal_priority ?delivery_order ?seasonal_priority)
        (order_has_operational_priority ?delivery_order ?operational_priority)
        (order_flag_operational_pending ?delivery_order)
        (not
          (delivery_order_open ?delivery_order)
        )
      )
  )
  (:action assemble_delivery_order_mixed_priority
    :parameters (?plot_var - crop_plot ?livestock_var - livestock_unit ?seasonal_priority - priority_axis_seasonal ?operational_priority - priority_axis_operational ?delivery_order - delivery_order)
    :precondition
      (and
        (plot_local_score_set ?plot_var)
        (livestock_local_score_set ?livestock_var)
        (plot_seasonal_priority ?plot_var ?seasonal_priority)
        (livestock_operational_priority ?livestock_var ?operational_priority)
        (seasonal_priority_pending ?seasonal_priority)
        (operational_priority_pending ?operational_priority)
        (not
          (plot_ready_for_dispatch ?plot_var)
        )
        (not
          (livestock_ready_for_dispatch ?livestock_var)
        )
        (delivery_order_open ?delivery_order)
      )
    :effect
      (and
        (order_ready ?delivery_order)
        (order_has_seasonal_priority ?delivery_order ?seasonal_priority)
        (order_has_operational_priority ?delivery_order ?operational_priority)
        (order_flag_seasonal_pending ?delivery_order)
        (order_flag_operational_pending ?delivery_order)
        (not
          (delivery_order_open ?delivery_order)
        )
      )
  )
  (:action process_shipment_document
    :parameters (?delivery_order - delivery_order ?plot_var - crop_plot ?input_type_var - input_type)
    :precondition
      (and
        (order_ready ?delivery_order)
        (plot_local_score_set ?plot_var)
        (reserved_input ?plot_var ?input_type_var)
        (not
          (order_shipment_verified ?delivery_order)
        )
      )
    :effect (order_shipment_verified ?delivery_order)
  )
  (:action redeem_voucher_and_bind_order
    :parameters (?distribution_node - distribution_node ?allocation_voucher - allocation_voucher ?delivery_order - delivery_order)
    :precondition
      (and
        (entity_request_validated ?distribution_node)
        (node_assigned_order ?distribution_node ?delivery_order)
        (node_has_voucher ?distribution_node ?allocation_voucher)
        (voucher_available ?allocation_voucher)
        (order_ready ?delivery_order)
        (order_shipment_verified ?delivery_order)
        (not
          (voucher_redeemed ?allocation_voucher)
        )
      )
    :effect
      (and
        (voucher_redeemed ?allocation_voucher)
        (voucher_bound_to_order ?allocation_voucher ?delivery_order)
        (not
          (voucher_available ?allocation_voucher)
        )
      )
  )
  (:action authorize_node_for_dispatch
    :parameters (?distribution_node - distribution_node ?allocation_voucher - allocation_voucher ?delivery_order - delivery_order ?input_type_var - input_type)
    :precondition
      (and
        (entity_request_validated ?distribution_node)
        (node_has_voucher ?distribution_node ?allocation_voucher)
        (voucher_redeemed ?allocation_voucher)
        (voucher_bound_to_order ?allocation_voucher ?delivery_order)
        (reserved_input ?distribution_node ?input_type_var)
        (not
          (order_flag_seasonal_pending ?delivery_order)
        )
        (not
          (node_authorized ?distribution_node)
        )
      )
    :effect (node_authorized ?distribution_node)
  )
  (:action register_node_permit
    :parameters (?distribution_node - distribution_node ?regulatory_permit - regulatory_permit)
    :precondition
      (and
        (entity_request_validated ?distribution_node)
        (permit_available ?regulatory_permit)
        (not
          (permit_registered ?distribution_node)
        )
      )
    :effect
      (and
        (permit_registered ?distribution_node)
        (node_has_permit ?distribution_node ?regulatory_permit)
        (not
          (permit_available ?regulatory_permit)
        )
      )
  )
  (:action verify_permit_and_stage_node
    :parameters (?distribution_node - distribution_node ?allocation_voucher - allocation_voucher ?delivery_order - delivery_order ?input_type_var - input_type ?regulatory_permit - regulatory_permit)
    :precondition
      (and
        (entity_request_validated ?distribution_node)
        (node_has_voucher ?distribution_node ?allocation_voucher)
        (voucher_redeemed ?allocation_voucher)
        (voucher_bound_to_order ?allocation_voucher ?delivery_order)
        (reserved_input ?distribution_node ?input_type_var)
        (order_flag_seasonal_pending ?delivery_order)
        (permit_registered ?distribution_node)
        (node_has_permit ?distribution_node ?regulatory_permit)
        (not
          (node_authorized ?distribution_node)
        )
      )
    :effect
      (and
        (node_authorized ?distribution_node)
        (node_permit_verified ?distribution_node)
      )
  )
  (:action stage_resource_bundle_on_node
    :parameters (?distribution_node - distribution_node ?standard_resource_bundle - resource_bundle_standard ?machinery_crew - machinery_or_crew ?allocation_voucher - allocation_voucher ?delivery_order - delivery_order)
    :precondition
      (and
        (node_authorized ?distribution_node)
        (node_allocated_standard_bundle ?distribution_node ?standard_resource_bundle)
        (assigned_machinery ?distribution_node ?machinery_crew)
        (node_has_voucher ?distribution_node ?allocation_voucher)
        (voucher_bound_to_order ?allocation_voucher ?delivery_order)
        (not
          (order_flag_operational_pending ?delivery_order)
        )
        (not
          (node_bundle_staged ?distribution_node)
        )
      )
    :effect (node_bundle_staged ?distribution_node)
  )
  (:action stage_resource_bundle_on_node_confirmed
    :parameters (?distribution_node - distribution_node ?standard_resource_bundle - resource_bundle_standard ?machinery_crew - machinery_or_crew ?allocation_voucher - allocation_voucher ?delivery_order - delivery_order)
    :precondition
      (and
        (node_authorized ?distribution_node)
        (node_allocated_standard_bundle ?distribution_node ?standard_resource_bundle)
        (assigned_machinery ?distribution_node ?machinery_crew)
        (node_has_voucher ?distribution_node ?allocation_voucher)
        (voucher_bound_to_order ?allocation_voucher ?delivery_order)
        (order_flag_operational_pending ?delivery_order)
        (not
          (node_bundle_staged ?distribution_node)
        )
      )
    :effect (node_bundle_staged ?distribution_node)
  )
  (:action activate_node_preparation_phase
    :parameters (?distribution_node - distribution_node ?emergency_bundle - emergency_bundle ?allocation_voucher - allocation_voucher ?delivery_order - delivery_order)
    :precondition
      (and
        (node_bundle_staged ?distribution_node)
        (node_allocated_emergency_bundle ?distribution_node ?emergency_bundle)
        (node_has_voucher ?distribution_node ?allocation_voucher)
        (voucher_bound_to_order ?allocation_voucher ?delivery_order)
        (not
          (order_flag_seasonal_pending ?delivery_order)
        )
        (not
          (order_flag_operational_pending ?delivery_order)
        )
        (not
          (node_preparation_complete ?distribution_node)
        )
      )
    :effect (node_preparation_complete ?distribution_node)
  )
  (:action activate_node_preparation_and_set_scheduling_flag
    :parameters (?distribution_node - distribution_node ?emergency_bundle - emergency_bundle ?allocation_voucher - allocation_voucher ?delivery_order - delivery_order)
    :precondition
      (and
        (node_bundle_staged ?distribution_node)
        (node_allocated_emergency_bundle ?distribution_node ?emergency_bundle)
        (node_has_voucher ?distribution_node ?allocation_voucher)
        (voucher_bound_to_order ?allocation_voucher ?delivery_order)
        (order_flag_seasonal_pending ?delivery_order)
        (not
          (order_flag_operational_pending ?delivery_order)
        )
        (not
          (node_preparation_complete ?distribution_node)
        )
      )
    :effect
      (and
        (node_preparation_complete ?distribution_node)
        (node_staged_for_scheduling ?distribution_node)
      )
  )
  (:action activate_node_preparation_and_set_scheduling_flag_alt
    :parameters (?distribution_node - distribution_node ?emergency_bundle - emergency_bundle ?allocation_voucher - allocation_voucher ?delivery_order - delivery_order)
    :precondition
      (and
        (node_bundle_staged ?distribution_node)
        (node_allocated_emergency_bundle ?distribution_node ?emergency_bundle)
        (node_has_voucher ?distribution_node ?allocation_voucher)
        (voucher_bound_to_order ?allocation_voucher ?delivery_order)
        (not
          (order_flag_seasonal_pending ?delivery_order)
        )
        (order_flag_operational_pending ?delivery_order)
        (not
          (node_preparation_complete ?distribution_node)
        )
      )
    :effect
      (and
        (node_preparation_complete ?distribution_node)
        (node_staged_for_scheduling ?distribution_node)
      )
  )
  (:action activate_node_preparation_and_set_scheduling_flag_full
    :parameters (?distribution_node - distribution_node ?emergency_bundle - emergency_bundle ?allocation_voucher - allocation_voucher ?delivery_order - delivery_order)
    :precondition
      (and
        (node_bundle_staged ?distribution_node)
        (node_allocated_emergency_bundle ?distribution_node ?emergency_bundle)
        (node_has_voucher ?distribution_node ?allocation_voucher)
        (voucher_bound_to_order ?allocation_voucher ?delivery_order)
        (order_flag_seasonal_pending ?delivery_order)
        (order_flag_operational_pending ?delivery_order)
        (not
          (node_preparation_complete ?distribution_node)
        )
      )
    :effect
      (and
        (node_preparation_complete ?distribution_node)
        (node_staged_for_scheduling ?distribution_node)
      )
  )
  (:action finalize_node_staging
    :parameters (?distribution_node - distribution_node)
    :precondition
      (and
        (node_preparation_complete ?distribution_node)
        (not
          (node_staged_for_scheduling ?distribution_node)
        )
        (not
          (dispatch_authorized ?distribution_node)
        )
      )
    :effect
      (and
        (dispatch_authorized ?distribution_node)
        (entity_delivery_confirmed ?distribution_node)
      )
  )
  (:action assign_timeslot_to_node
    :parameters (?distribution_node - distribution_node ?timeslot_var - timeslot)
    :precondition
      (and
        (node_preparation_complete ?distribution_node)
        (node_staged_for_scheduling ?distribution_node)
        (timeslot_available ?timeslot_var)
      )
    :effect
      (and
        (node_scheduled_timeslot ?distribution_node ?timeslot_var)
        (not
          (timeslot_available ?timeslot_var)
        )
      )
  )
  (:action confirm_node_dispatch_allocation
    :parameters (?distribution_node - distribution_node ?plot_var - crop_plot ?livestock_var - livestock_unit ?input_type_var - input_type ?timeslot_var - timeslot)
    :precondition
      (and
        (node_preparation_complete ?distribution_node)
        (node_staged_for_scheduling ?distribution_node)
        (node_scheduled_timeslot ?distribution_node ?timeslot_var)
        (node_serves_plot ?distribution_node ?plot_var)
        (node_serves_livestock ?distribution_node ?livestock_var)
        (plot_ready_for_dispatch ?plot_var)
        (livestock_ready_for_dispatch ?livestock_var)
        (reserved_input ?distribution_node ?input_type_var)
        (not
          (node_resources_allocated ?distribution_node)
        )
      )
    :effect (node_resources_allocated ?distribution_node)
  )
  (:action authorize_node_dispatch
    :parameters (?distribution_node - distribution_node)
    :precondition
      (and
        (node_preparation_complete ?distribution_node)
        (node_resources_allocated ?distribution_node)
        (not
          (dispatch_authorized ?distribution_node)
        )
      )
    :effect
      (and
        (dispatch_authorized ?distribution_node)
        (entity_delivery_confirmed ?distribution_node)
      )
  )
  (:action apply_specialist_credential_to_node
    :parameters (?distribution_node - distribution_node ?specialist_credential - specialist_credential ?input_type_var - input_type)
    :precondition
      (and
        (entity_request_validated ?distribution_node)
        (reserved_input ?distribution_node ?input_type_var)
        (credential_available ?specialist_credential)
        (node_has_credential ?distribution_node ?specialist_credential)
        (not
          (node_credential_approved ?distribution_node)
        )
      )
    :effect
      (and
        (node_credential_approved ?distribution_node)
        (not
          (credential_available ?specialist_credential)
        )
      )
  )
  (:action use_specialist_credential_on_node
    :parameters (?distribution_node - distribution_node ?machinery_crew - machinery_or_crew)
    :precondition
      (and
        (node_credential_approved ?distribution_node)
        (assigned_machinery ?distribution_node ?machinery_crew)
        (not
          (node_credential_used ?distribution_node)
        )
      )
    :effect (node_credential_used ?distribution_node)
  )
  (:action confirm_node_credential
    :parameters (?distribution_node - distribution_node ?emergency_bundle - emergency_bundle)
    :precondition
      (and
        (node_credential_used ?distribution_node)
        (node_allocated_emergency_bundle ?distribution_node ?emergency_bundle)
        (not
          (node_credential_confirmed ?distribution_node)
        )
      )
    :effect (node_credential_confirmed ?distribution_node)
  )
  (:action finalize_credential_and_mark_node_ready
    :parameters (?distribution_node - distribution_node)
    :precondition
      (and
        (node_credential_confirmed ?distribution_node)
        (not
          (dispatch_authorized ?distribution_node)
        )
      )
    :effect
      (and
        (dispatch_authorized ?distribution_node)
        (entity_delivery_confirmed ?distribution_node)
      )
  )
  (:action confirm_delivery_plot
    :parameters (?plot_var - crop_plot ?delivery_order - delivery_order)
    :precondition
      (and
        (plot_local_score_set ?plot_var)
        (plot_ready_for_dispatch ?plot_var)
        (order_ready ?delivery_order)
        (order_shipment_verified ?delivery_order)
        (not
          (entity_delivery_confirmed ?plot_var)
        )
      )
    :effect (entity_delivery_confirmed ?plot_var)
  )
  (:action confirm_delivery_livestock
    :parameters (?livestock_var - livestock_unit ?delivery_order - delivery_order)
    :precondition
      (and
        (livestock_local_score_set ?livestock_var)
        (livestock_ready_for_dispatch ?livestock_var)
        (order_ready ?delivery_order)
        (order_shipment_verified ?delivery_order)
        (not
          (entity_delivery_confirmed ?livestock_var)
        )
      )
    :effect (entity_delivery_confirmed ?livestock_var)
  )
  (:action allocate_contingency_supply
    :parameters (?beneficiary_unit - beneficiary_unit ?contingency_reserve - contingency_reserve ?input_type_var - input_type)
    :precondition
      (and
        (entity_delivery_confirmed ?beneficiary_unit)
        (reserved_input ?beneficiary_unit ?input_type_var)
        (contingency_reserve_available ?contingency_reserve)
        (not
          (contingency_allocated ?beneficiary_unit)
        )
      )
    :effect
      (and
        (contingency_allocated ?beneficiary_unit)
        (beneficiary_has_contingency_reserve ?beneficiary_unit ?contingency_reserve)
        (not
          (contingency_reserve_available ?contingency_reserve)
        )
      )
  )
  (:action finalize_supplier_commitment_plot
    :parameters (?plot_var - crop_plot ?supplier_asset - supplier_asset ?contingency_reserve - contingency_reserve)
    :precondition
      (and
        (contingency_allocated ?plot_var)
        (beneficiary_assigned_supplier ?plot_var ?supplier_asset)
        (beneficiary_has_contingency_reserve ?plot_var ?contingency_reserve)
        (not
          (entity_delivery_committed ?plot_var)
        )
      )
    :effect
      (and
        (entity_delivery_committed ?plot_var)
        (supplier_available ?supplier_asset)
        (contingency_reserve_available ?contingency_reserve)
      )
  )
  (:action finalize_supplier_commitment_livestock
    :parameters (?livestock_var - livestock_unit ?supplier_asset - supplier_asset ?contingency_reserve - contingency_reserve)
    :precondition
      (and
        (contingency_allocated ?livestock_var)
        (beneficiary_assigned_supplier ?livestock_var ?supplier_asset)
        (beneficiary_has_contingency_reserve ?livestock_var ?contingency_reserve)
        (not
          (entity_delivery_committed ?livestock_var)
        )
      )
    :effect
      (and
        (entity_delivery_committed ?livestock_var)
        (supplier_available ?supplier_asset)
        (contingency_reserve_available ?contingency_reserve)
      )
  )
  (:action finalize_supplier_commitment_node
    :parameters (?distribution_node - distribution_node ?supplier_asset - supplier_asset ?contingency_reserve - contingency_reserve)
    :precondition
      (and
        (contingency_allocated ?distribution_node)
        (beneficiary_assigned_supplier ?distribution_node ?supplier_asset)
        (beneficiary_has_contingency_reserve ?distribution_node ?contingency_reserve)
        (not
          (entity_delivery_committed ?distribution_node)
        )
      )
    :effect
      (and
        (entity_delivery_committed ?distribution_node)
        (supplier_available ?supplier_asset)
        (contingency_reserve_available ?contingency_reserve)
      )
  )
)

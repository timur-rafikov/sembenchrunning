(define (domain harvest_window_prioritization)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_pool - object logistics_class - object time_window_class - object farm_unit - object field_block - farm_unit harvest_team - resource_pool harvest_method - resource_pool operator - resource_pool market_constraint - resource_pool quality_requirement - resource_pool storage_slot - resource_pool processing_option - resource_pool weather_constraint - resource_pool consumable_input - logistics_class quality_test_type - logistics_class market_contract_window - logistics_class harvest_window - time_window_class transport_window - time_window_class harvest_batch - time_window_class field_subunit_group - field_block crop_order_group - field_block harvest_unit - field_subunit_group transport_unit - field_subunit_group crop_work_order - crop_order_group)
  (:predicates
    (work_item_identified ?field_block - field_block)
    (work_item_ready ?field_block - field_block)
    (work_item_assigned ?field_block - field_block)
    (work_item_finalized ?field_block - field_block)
    (work_item_processing_completed ?field_block - field_block)
    (work_item_postharvest_released ?field_block - field_block)
    (team_available ?harvest_team - harvest_team)
    (work_item_assigned_team ?field_block - field_block ?harvest_team - harvest_team)
    (method_available ?harvest_method - harvest_method)
    (work_item_assigned_method ?field_block - field_block ?harvest_method - harvest_method)
    (operator_available ?operator - operator)
    (work_item_assigned_operator ?field_block - field_block ?operator - operator)
    (consumable_available ?consumable_input - consumable_input)
    (allocated_consumable ?harvest_unit - harvest_unit ?consumable_input - consumable_input)
    (transport_unit_allocated_input ?transport_unit - transport_unit ?consumable_input - consumable_input)
    (harvest_unit_window_assignment ?harvest_unit - harvest_unit ?harvest_window - harvest_window)
    (harvest_window_primary_reserved ?harvest_window - harvest_window)
    (harvest_window_secondary_reserved ?harvest_window - harvest_window)
    (unit_ready_for_batching ?harvest_unit - harvest_unit)
    (transport_window_assignment ?transport_unit - transport_unit ?transport_window - transport_window)
    (transport_window_primary_reserved ?transport_window - transport_window)
    (transport_window_secondary_reserved ?transport_window - transport_window)
    (transport_unit_ready ?transport_unit - transport_unit)
    (batch_available ?harvest_batch - harvest_batch)
    (batch_committed ?harvest_batch - harvest_batch)
    (batch_harvest_window ?harvest_batch - harvest_batch ?harvest_window - harvest_window)
    (batch_transport_window ?harvest_batch - harvest_batch ?transport_window - transport_window)
    (batch_requires_primary_processing ?harvest_batch - harvest_batch)
    (batch_requires_secondary_processing ?harvest_batch - harvest_batch)
    (batch_ready_for_quality ?harvest_batch - harvest_batch)
    (work_order_contains_unit ?crop_work_order - crop_work_order ?harvest_unit - harvest_unit)
    (work_order_contains_transport_unit ?crop_work_order - crop_work_order ?transport_unit - transport_unit)
    (work_order_assigned_batch ?crop_work_order - crop_work_order ?harvest_batch - harvest_batch)
    (quality_test_available ?quality_test_type - quality_test_type)
    (work_order_has_test ?crop_work_order - crop_work_order ?quality_test_type - quality_test_type)
    (quality_test_consumed ?quality_test_type - quality_test_type)
    (test_assigned_to_batch ?quality_test_type - quality_test_type ?harvest_batch - harvest_batch)
    (processing_option_committed ?crop_work_order - crop_work_order)
    (processing_assigned ?crop_work_order - crop_work_order)
    (processing_ready ?crop_work_order - crop_work_order)
    (market_constraint_attached ?crop_work_order - crop_work_order)
    (market_constraint_applied ?crop_work_order - crop_work_order)
    (quality_requirement_flagged ?crop_work_order - crop_work_order)
    (processing_executed ?crop_work_order - crop_work_order)
    (market_contract_window_available ?market_contract_window - market_contract_window)
    (work_order_has_market_contract_window ?crop_work_order - crop_work_order ?market_contract_window - market_contract_window)
    (market_contract_confirmed ?crop_work_order - crop_work_order)
    (market_contract_operator_ready ?crop_work_order - crop_work_order)
    (market_contract_authorized ?crop_work_order - crop_work_order)
    (market_constraint_available ?market_constraint - market_constraint)
    (work_order_has_market_constraint ?crop_work_order - crop_work_order ?market_constraint - market_constraint)
    (quality_requirement_available ?quality_requirement - quality_requirement)
    (work_order_assigned_quality_requirement ?crop_work_order - crop_work_order ?quality_requirement - quality_requirement)
    (processing_option_available ?processing_option - processing_option)
    (work_order_assigned_processing_option ?crop_work_order - crop_work_order ?processing_option - processing_option)
    (weather_constraint_available ?weather_constraint - weather_constraint)
    (work_order_has_weather_constraint ?crop_work_order - crop_work_order ?weather_constraint - weather_constraint)
    (storage_slot_available ?storage_slot - storage_slot)
    (work_item_assigned_storage_slot ?field_block - field_block ?storage_slot - storage_slot)
    (unit_prepared ?harvest_unit - harvest_unit)
    (transport_unit_prepared ?transport_unit - transport_unit)
    (work_order_finalized ?crop_work_order - crop_work_order)
  )
  (:action identify_field_block
    :parameters (?field_block - field_block)
    :precondition
      (and
        (not
          (work_item_identified ?field_block)
        )
        (not
          (work_item_finalized ?field_block)
        )
      )
    :effect (work_item_identified ?field_block)
  )
  (:action assign_team_to_field
    :parameters (?field_block - field_block ?harvest_team - harvest_team)
    :precondition
      (and
        (work_item_identified ?field_block)
        (not
          (work_item_assigned ?field_block)
        )
        (team_available ?harvest_team)
      )
    :effect
      (and
        (work_item_assigned ?field_block)
        (work_item_assigned_team ?field_block ?harvest_team)
        (not
          (team_available ?harvest_team)
        )
      )
  )
  (:action assign_method_to_field
    :parameters (?field_block - field_block ?harvest_method - harvest_method)
    :precondition
      (and
        (work_item_identified ?field_block)
        (work_item_assigned ?field_block)
        (method_available ?harvest_method)
      )
    :effect
      (and
        (work_item_assigned_method ?field_block ?harvest_method)
        (not
          (method_available ?harvest_method)
        )
      )
  )
  (:action confirm_field_readiness
    :parameters (?field_block - field_block ?harvest_method - harvest_method)
    :precondition
      (and
        (work_item_identified ?field_block)
        (work_item_assigned ?field_block)
        (work_item_assigned_method ?field_block ?harvest_method)
        (not
          (work_item_ready ?field_block)
        )
      )
    :effect (work_item_ready ?field_block)
  )
  (:action unassign_method_from_field
    :parameters (?field_block - field_block ?harvest_method - harvest_method)
    :precondition
      (and
        (work_item_assigned_method ?field_block ?harvest_method)
      )
    :effect
      (and
        (method_available ?harvest_method)
        (not
          (work_item_assigned_method ?field_block ?harvest_method)
        )
      )
  )
  (:action assign_operator_to_field
    :parameters (?field_block - field_block ?operator - operator)
    :precondition
      (and
        (work_item_ready ?field_block)
        (operator_available ?operator)
      )
    :effect
      (and
        (work_item_assigned_operator ?field_block ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action unassign_operator_from_field
    :parameters (?field_block - field_block ?operator - operator)
    :precondition
      (and
        (work_item_assigned_operator ?field_block ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (work_item_assigned_operator ?field_block ?operator)
        )
      )
  )
  (:action assign_processing_option_to_work_order
    :parameters (?crop_work_order - crop_work_order ?processing_option - processing_option)
    :precondition
      (and
        (work_item_ready ?crop_work_order)
        (processing_option_available ?processing_option)
      )
    :effect
      (and
        (work_order_assigned_processing_option ?crop_work_order ?processing_option)
        (not
          (processing_option_available ?processing_option)
        )
      )
  )
  (:action release_processing_option_from_work_order
    :parameters (?crop_work_order - crop_work_order ?processing_option - processing_option)
    :precondition
      (and
        (work_order_assigned_processing_option ?crop_work_order ?processing_option)
      )
    :effect
      (and
        (processing_option_available ?processing_option)
        (not
          (work_order_assigned_processing_option ?crop_work_order ?processing_option)
        )
      )
  )
  (:action assign_weather_constraint_to_work_order
    :parameters (?crop_work_order - crop_work_order ?weather_constraint - weather_constraint)
    :precondition
      (and
        (work_item_ready ?crop_work_order)
        (weather_constraint_available ?weather_constraint)
      )
    :effect
      (and
        (work_order_has_weather_constraint ?crop_work_order ?weather_constraint)
        (not
          (weather_constraint_available ?weather_constraint)
        )
      )
  )
  (:action clear_weather_constraint_from_work_order
    :parameters (?crop_work_order - crop_work_order ?weather_constraint - weather_constraint)
    :precondition
      (and
        (work_order_has_weather_constraint ?crop_work_order ?weather_constraint)
      )
    :effect
      (and
        (weather_constraint_available ?weather_constraint)
        (not
          (work_order_has_weather_constraint ?crop_work_order ?weather_constraint)
        )
      )
  )
  (:action reserve_harvest_window_primary
    :parameters (?harvest_unit - harvest_unit ?harvest_window - harvest_window ?harvest_method - harvest_method)
    :precondition
      (and
        (work_item_ready ?harvest_unit)
        (work_item_assigned_method ?harvest_unit ?harvest_method)
        (harvest_unit_window_assignment ?harvest_unit ?harvest_window)
        (not
          (harvest_window_primary_reserved ?harvest_window)
        )
        (not
          (harvest_window_secondary_reserved ?harvest_window)
        )
      )
    :effect (harvest_window_primary_reserved ?harvest_window)
  )
  (:action prepare_harvest_unit_with_operator
    :parameters (?harvest_unit - harvest_unit ?harvest_window - harvest_window ?operator - operator)
    :precondition
      (and
        (work_item_ready ?harvest_unit)
        (work_item_assigned_operator ?harvest_unit ?operator)
        (harvest_unit_window_assignment ?harvest_unit ?harvest_window)
        (harvest_window_primary_reserved ?harvest_window)
        (not
          (unit_prepared ?harvest_unit)
        )
      )
    :effect
      (and
        (unit_prepared ?harvest_unit)
        (unit_ready_for_batching ?harvest_unit)
      )
  )
  (:action allocate_input_and_reserve_window
    :parameters (?harvest_unit - harvest_unit ?harvest_window - harvest_window ?consumable_input - consumable_input)
    :precondition
      (and
        (work_item_ready ?harvest_unit)
        (harvest_unit_window_assignment ?harvest_unit ?harvest_window)
        (consumable_available ?consumable_input)
        (not
          (unit_prepared ?harvest_unit)
        )
      )
    :effect
      (and
        (harvest_window_secondary_reserved ?harvest_window)
        (unit_prepared ?harvest_unit)
        (allocated_consumable ?harvest_unit ?consumable_input)
        (not
          (consumable_available ?consumable_input)
        )
      )
  )
  (:action finalize_harvest_unit_preparation
    :parameters (?harvest_unit - harvest_unit ?harvest_window - harvest_window ?harvest_method - harvest_method ?consumable_input - consumable_input)
    :precondition
      (and
        (work_item_ready ?harvest_unit)
        (work_item_assigned_method ?harvest_unit ?harvest_method)
        (harvest_unit_window_assignment ?harvest_unit ?harvest_window)
        (harvest_window_secondary_reserved ?harvest_window)
        (allocated_consumable ?harvest_unit ?consumable_input)
        (not
          (unit_ready_for_batching ?harvest_unit)
        )
      )
    :effect
      (and
        (harvest_window_primary_reserved ?harvest_window)
        (unit_ready_for_batching ?harvest_unit)
        (consumable_available ?consumable_input)
        (not
          (allocated_consumable ?harvest_unit ?consumable_input)
        )
      )
  )
  (:action reserve_transport_window_primary
    :parameters (?transport_unit - transport_unit ?transport_window - transport_window ?harvest_method - harvest_method)
    :precondition
      (and
        (work_item_ready ?transport_unit)
        (work_item_assigned_method ?transport_unit ?harvest_method)
        (transport_window_assignment ?transport_unit ?transport_window)
        (not
          (transport_window_primary_reserved ?transport_window)
        )
        (not
          (transport_window_secondary_reserved ?transport_window)
        )
      )
    :effect (transport_window_primary_reserved ?transport_window)
  )
  (:action prepare_transport_unit_with_operator
    :parameters (?transport_unit - transport_unit ?transport_window - transport_window ?operator - operator)
    :precondition
      (and
        (work_item_ready ?transport_unit)
        (work_item_assigned_operator ?transport_unit ?operator)
        (transport_window_assignment ?transport_unit ?transport_window)
        (transport_window_primary_reserved ?transport_window)
        (not
          (transport_unit_prepared ?transport_unit)
        )
      )
    :effect
      (and
        (transport_unit_prepared ?transport_unit)
        (transport_unit_ready ?transport_unit)
      )
  )
  (:action allocate_input_to_transport_unit
    :parameters (?transport_unit - transport_unit ?transport_window - transport_window ?consumable_input - consumable_input)
    :precondition
      (and
        (work_item_ready ?transport_unit)
        (transport_window_assignment ?transport_unit ?transport_window)
        (consumable_available ?consumable_input)
        (not
          (transport_unit_prepared ?transport_unit)
        )
      )
    :effect
      (and
        (transport_window_secondary_reserved ?transport_window)
        (transport_unit_prepared ?transport_unit)
        (transport_unit_allocated_input ?transport_unit ?consumable_input)
        (not
          (consumable_available ?consumable_input)
        )
      )
  )
  (:action finalize_transport_unit_preparation
    :parameters (?transport_unit - transport_unit ?transport_window - transport_window ?harvest_method - harvest_method ?consumable_input - consumable_input)
    :precondition
      (and
        (work_item_ready ?transport_unit)
        (work_item_assigned_method ?transport_unit ?harvest_method)
        (transport_window_assignment ?transport_unit ?transport_window)
        (transport_window_secondary_reserved ?transport_window)
        (transport_unit_allocated_input ?transport_unit ?consumable_input)
        (not
          (transport_unit_ready ?transport_unit)
        )
      )
    :effect
      (and
        (transport_window_primary_reserved ?transport_window)
        (transport_unit_ready ?transport_unit)
        (consumable_available ?consumable_input)
        (not
          (transport_unit_allocated_input ?transport_unit ?consumable_input)
        )
      )
  )
  (:action form_harvest_batch
    :parameters (?harvest_unit - harvest_unit ?transport_unit - transport_unit ?harvest_window - harvest_window ?transport_window - transport_window ?harvest_batch - harvest_batch)
    :precondition
      (and
        (unit_prepared ?harvest_unit)
        (transport_unit_prepared ?transport_unit)
        (harvest_unit_window_assignment ?harvest_unit ?harvest_window)
        (transport_window_assignment ?transport_unit ?transport_window)
        (harvest_window_primary_reserved ?harvest_window)
        (transport_window_primary_reserved ?transport_window)
        (unit_ready_for_batching ?harvest_unit)
        (transport_unit_ready ?transport_unit)
        (batch_available ?harvest_batch)
      )
    :effect
      (and
        (batch_committed ?harvest_batch)
        (batch_harvest_window ?harvest_batch ?harvest_window)
        (batch_transport_window ?harvest_batch ?transport_window)
        (not
          (batch_available ?harvest_batch)
        )
      )
  )
  (:action create_harvest_batch_with_primary_processing
    :parameters (?harvest_unit - harvest_unit ?transport_unit - transport_unit ?harvest_window - harvest_window ?transport_window - transport_window ?harvest_batch - harvest_batch)
    :precondition
      (and
        (unit_prepared ?harvest_unit)
        (transport_unit_prepared ?transport_unit)
        (harvest_unit_window_assignment ?harvest_unit ?harvest_window)
        (transport_window_assignment ?transport_unit ?transport_window)
        (harvest_window_secondary_reserved ?harvest_window)
        (transport_window_primary_reserved ?transport_window)
        (not
          (unit_ready_for_batching ?harvest_unit)
        )
        (transport_unit_ready ?transport_unit)
        (batch_available ?harvest_batch)
      )
    :effect
      (and
        (batch_committed ?harvest_batch)
        (batch_harvest_window ?harvest_batch ?harvest_window)
        (batch_transport_window ?harvest_batch ?transport_window)
        (batch_requires_primary_processing ?harvest_batch)
        (not
          (batch_available ?harvest_batch)
        )
      )
  )
  (:action create_harvest_batch_with_secondary_processing
    :parameters (?harvest_unit - harvest_unit ?transport_unit - transport_unit ?harvest_window - harvest_window ?transport_window - transport_window ?harvest_batch - harvest_batch)
    :precondition
      (and
        (unit_prepared ?harvest_unit)
        (transport_unit_prepared ?transport_unit)
        (harvest_unit_window_assignment ?harvest_unit ?harvest_window)
        (transport_window_assignment ?transport_unit ?transport_window)
        (harvest_window_primary_reserved ?harvest_window)
        (transport_window_secondary_reserved ?transport_window)
        (unit_ready_for_batching ?harvest_unit)
        (not
          (transport_unit_ready ?transport_unit)
        )
        (batch_available ?harvest_batch)
      )
    :effect
      (and
        (batch_committed ?harvest_batch)
        (batch_harvest_window ?harvest_batch ?harvest_window)
        (batch_transport_window ?harvest_batch ?transport_window)
        (batch_requires_secondary_processing ?harvest_batch)
        (not
          (batch_available ?harvest_batch)
        )
      )
  )
  (:action create_harvest_batch_with_combined_processing
    :parameters (?harvest_unit - harvest_unit ?transport_unit - transport_unit ?harvest_window - harvest_window ?transport_window - transport_window ?harvest_batch - harvest_batch)
    :precondition
      (and
        (unit_prepared ?harvest_unit)
        (transport_unit_prepared ?transport_unit)
        (harvest_unit_window_assignment ?harvest_unit ?harvest_window)
        (transport_window_assignment ?transport_unit ?transport_window)
        (harvest_window_secondary_reserved ?harvest_window)
        (transport_window_secondary_reserved ?transport_window)
        (not
          (unit_ready_for_batching ?harvest_unit)
        )
        (not
          (transport_unit_ready ?transport_unit)
        )
        (batch_available ?harvest_batch)
      )
    :effect
      (and
        (batch_committed ?harvest_batch)
        (batch_harvest_window ?harvest_batch ?harvest_window)
        (batch_transport_window ?harvest_batch ?transport_window)
        (batch_requires_primary_processing ?harvest_batch)
        (batch_requires_secondary_processing ?harvest_batch)
        (not
          (batch_available ?harvest_batch)
        )
      )
  )
  (:action mark_batch_ready_for_quality
    :parameters (?harvest_batch - harvest_batch ?harvest_unit - harvest_unit ?harvest_method - harvest_method)
    :precondition
      (and
        (batch_committed ?harvest_batch)
        (unit_prepared ?harvest_unit)
        (work_item_assigned_method ?harvest_unit ?harvest_method)
        (not
          (batch_ready_for_quality ?harvest_batch)
        )
      )
    :effect (batch_ready_for_quality ?harvest_batch)
  )
  (:action assign_quality_test
    :parameters (?crop_work_order - crop_work_order ?quality_test_type - quality_test_type ?harvest_batch - harvest_batch)
    :precondition
      (and
        (work_item_ready ?crop_work_order)
        (work_order_assigned_batch ?crop_work_order ?harvest_batch)
        (work_order_has_test ?crop_work_order ?quality_test_type)
        (quality_test_available ?quality_test_type)
        (batch_committed ?harvest_batch)
        (batch_ready_for_quality ?harvest_batch)
        (not
          (quality_test_consumed ?quality_test_type)
        )
      )
    :effect
      (and
        (quality_test_consumed ?quality_test_type)
        (test_assigned_to_batch ?quality_test_type ?harvest_batch)
        (not
          (quality_test_available ?quality_test_type)
        )
      )
  )
  (:action commit_processing_option
    :parameters (?crop_work_order - crop_work_order ?quality_test_type - quality_test_type ?harvest_batch - harvest_batch ?harvest_method - harvest_method)
    :precondition
      (and
        (work_item_ready ?crop_work_order)
        (work_order_has_test ?crop_work_order ?quality_test_type)
        (quality_test_consumed ?quality_test_type)
        (test_assigned_to_batch ?quality_test_type ?harvest_batch)
        (work_item_assigned_method ?crop_work_order ?harvest_method)
        (not
          (batch_requires_primary_processing ?harvest_batch)
        )
        (not
          (processing_option_committed ?crop_work_order)
        )
      )
    :effect (processing_option_committed ?crop_work_order)
  )
  (:action apply_market_constraint_to_work_order
    :parameters (?crop_work_order - crop_work_order ?market_constraint - market_constraint)
    :precondition
      (and
        (work_item_ready ?crop_work_order)
        (market_constraint_available ?market_constraint)
        (not
          (market_constraint_attached ?crop_work_order)
        )
      )
    :effect
      (and
        (market_constraint_attached ?crop_work_order)
        (work_order_has_market_constraint ?crop_work_order ?market_constraint)
        (not
          (market_constraint_available ?market_constraint)
        )
      )
  )
  (:action apply_market_and_processing_constraints
    :parameters (?crop_work_order - crop_work_order ?quality_test_type - quality_test_type ?harvest_batch - harvest_batch ?harvest_method - harvest_method ?market_constraint - market_constraint)
    :precondition
      (and
        (work_item_ready ?crop_work_order)
        (work_order_has_test ?crop_work_order ?quality_test_type)
        (quality_test_consumed ?quality_test_type)
        (test_assigned_to_batch ?quality_test_type ?harvest_batch)
        (work_item_assigned_method ?crop_work_order ?harvest_method)
        (batch_requires_primary_processing ?harvest_batch)
        (market_constraint_attached ?crop_work_order)
        (work_order_has_market_constraint ?crop_work_order ?market_constraint)
        (not
          (processing_option_committed ?crop_work_order)
        )
      )
    :effect
      (and
        (processing_option_committed ?crop_work_order)
        (market_constraint_applied ?crop_work_order)
      )
  )
  (:action assign_processing_for_work_order_primary
    :parameters (?crop_work_order - crop_work_order ?processing_option - processing_option ?operator - operator ?quality_test_type - quality_test_type ?harvest_batch - harvest_batch)
    :precondition
      (and
        (processing_option_committed ?crop_work_order)
        (work_order_assigned_processing_option ?crop_work_order ?processing_option)
        (work_item_assigned_operator ?crop_work_order ?operator)
        (work_order_has_test ?crop_work_order ?quality_test_type)
        (test_assigned_to_batch ?quality_test_type ?harvest_batch)
        (not
          (batch_requires_secondary_processing ?harvest_batch)
        )
        (not
          (processing_assigned ?crop_work_order)
        )
      )
    :effect (processing_assigned ?crop_work_order)
  )
  (:action assign_processing_for_work_order_secondary
    :parameters (?crop_work_order - crop_work_order ?processing_option - processing_option ?operator - operator ?quality_test_type - quality_test_type ?harvest_batch - harvest_batch)
    :precondition
      (and
        (processing_option_committed ?crop_work_order)
        (work_order_assigned_processing_option ?crop_work_order ?processing_option)
        (work_item_assigned_operator ?crop_work_order ?operator)
        (work_order_has_test ?crop_work_order ?quality_test_type)
        (test_assigned_to_batch ?quality_test_type ?harvest_batch)
        (batch_requires_secondary_processing ?harvest_batch)
        (not
          (processing_assigned ?crop_work_order)
        )
      )
    :effect (processing_assigned ?crop_work_order)
  )
  (:action confirm_processing_ready
    :parameters (?crop_work_order - crop_work_order ?weather_constraint - weather_constraint ?quality_test_type - quality_test_type ?harvest_batch - harvest_batch)
    :precondition
      (and
        (processing_assigned ?crop_work_order)
        (work_order_has_weather_constraint ?crop_work_order ?weather_constraint)
        (work_order_has_test ?crop_work_order ?quality_test_type)
        (test_assigned_to_batch ?quality_test_type ?harvest_batch)
        (not
          (batch_requires_primary_processing ?harvest_batch)
        )
        (not
          (batch_requires_secondary_processing ?harvest_batch)
        )
        (not
          (processing_ready ?crop_work_order)
        )
      )
    :effect (processing_ready ?crop_work_order)
  )
  (:action confirm_processing_and_flag_quality_requirement
    :parameters (?crop_work_order - crop_work_order ?weather_constraint - weather_constraint ?quality_test_type - quality_test_type ?harvest_batch - harvest_batch)
    :precondition
      (and
        (processing_assigned ?crop_work_order)
        (work_order_has_weather_constraint ?crop_work_order ?weather_constraint)
        (work_order_has_test ?crop_work_order ?quality_test_type)
        (test_assigned_to_batch ?quality_test_type ?harvest_batch)
        (batch_requires_primary_processing ?harvest_batch)
        (not
          (batch_requires_secondary_processing ?harvest_batch)
        )
        (not
          (processing_ready ?crop_work_order)
        )
      )
    :effect
      (and
        (processing_ready ?crop_work_order)
        (quality_requirement_flagged ?crop_work_order)
      )
  )
  (:action confirm_processing_and_flag_quality_requirement_alt
    :parameters (?crop_work_order - crop_work_order ?weather_constraint - weather_constraint ?quality_test_type - quality_test_type ?harvest_batch - harvest_batch)
    :precondition
      (and
        (processing_assigned ?crop_work_order)
        (work_order_has_weather_constraint ?crop_work_order ?weather_constraint)
        (work_order_has_test ?crop_work_order ?quality_test_type)
        (test_assigned_to_batch ?quality_test_type ?harvest_batch)
        (not
          (batch_requires_primary_processing ?harvest_batch)
        )
        (batch_requires_secondary_processing ?harvest_batch)
        (not
          (processing_ready ?crop_work_order)
        )
      )
    :effect
      (and
        (processing_ready ?crop_work_order)
        (quality_requirement_flagged ?crop_work_order)
      )
  )
  (:action confirm_processing_and_flag_quality_requirement_combined
    :parameters (?crop_work_order - crop_work_order ?weather_constraint - weather_constraint ?quality_test_type - quality_test_type ?harvest_batch - harvest_batch)
    :precondition
      (and
        (processing_assigned ?crop_work_order)
        (work_order_has_weather_constraint ?crop_work_order ?weather_constraint)
        (work_order_has_test ?crop_work_order ?quality_test_type)
        (test_assigned_to_batch ?quality_test_type ?harvest_batch)
        (batch_requires_primary_processing ?harvest_batch)
        (batch_requires_secondary_processing ?harvest_batch)
        (not
          (processing_ready ?crop_work_order)
        )
      )
    :effect
      (and
        (processing_ready ?crop_work_order)
        (quality_requirement_flagged ?crop_work_order)
      )
  )
  (:action finalize_processing
    :parameters (?crop_work_order - crop_work_order)
    :precondition
      (and
        (processing_ready ?crop_work_order)
        (not
          (quality_requirement_flagged ?crop_work_order)
        )
        (not
          (work_order_finalized ?crop_work_order)
        )
      )
    :effect
      (and
        (work_order_finalized ?crop_work_order)
        (work_item_processing_completed ?crop_work_order)
      )
  )
  (:action apply_quality_requirement_to_work_order
    :parameters (?crop_work_order - crop_work_order ?quality_requirement - quality_requirement)
    :precondition
      (and
        (processing_ready ?crop_work_order)
        (quality_requirement_flagged ?crop_work_order)
        (quality_requirement_available ?quality_requirement)
      )
    :effect
      (and
        (work_order_assigned_quality_requirement ?crop_work_order ?quality_requirement)
        (not
          (quality_requirement_available ?quality_requirement)
        )
      )
  )
  (:action execute_processing
    :parameters (?crop_work_order - crop_work_order ?harvest_unit - harvest_unit ?transport_unit - transport_unit ?harvest_method - harvest_method ?quality_requirement - quality_requirement)
    :precondition
      (and
        (processing_ready ?crop_work_order)
        (quality_requirement_flagged ?crop_work_order)
        (work_order_assigned_quality_requirement ?crop_work_order ?quality_requirement)
        (work_order_contains_unit ?crop_work_order ?harvest_unit)
        (work_order_contains_transport_unit ?crop_work_order ?transport_unit)
        (unit_ready_for_batching ?harvest_unit)
        (transport_unit_ready ?transport_unit)
        (work_item_assigned_method ?crop_work_order ?harvest_method)
        (not
          (processing_executed ?crop_work_order)
        )
      )
    :effect (processing_executed ?crop_work_order)
  )
  (:action complete_work_order_processing
    :parameters (?crop_work_order - crop_work_order)
    :precondition
      (and
        (processing_ready ?crop_work_order)
        (processing_executed ?crop_work_order)
        (not
          (work_order_finalized ?crop_work_order)
        )
      )
    :effect
      (and
        (work_order_finalized ?crop_work_order)
        (work_item_processing_completed ?crop_work_order)
      )
  )
  (:action assign_market_contract_window
    :parameters (?crop_work_order - crop_work_order ?market_contract_window - market_contract_window ?harvest_method - harvest_method)
    :precondition
      (and
        (work_item_ready ?crop_work_order)
        (work_item_assigned_method ?crop_work_order ?harvest_method)
        (market_contract_window_available ?market_contract_window)
        (work_order_has_market_contract_window ?crop_work_order ?market_contract_window)
        (not
          (market_contract_confirmed ?crop_work_order)
        )
      )
    :effect
      (and
        (market_contract_confirmed ?crop_work_order)
        (not
          (market_contract_window_available ?market_contract_window)
        )
      )
  )
  (:action allocate_operator_for_market_contract
    :parameters (?crop_work_order - crop_work_order ?operator - operator)
    :precondition
      (and
        (market_contract_confirmed ?crop_work_order)
        (work_item_assigned_operator ?crop_work_order ?operator)
        (not
          (market_contract_operator_ready ?crop_work_order)
        )
      )
    :effect (market_contract_operator_ready ?crop_work_order)
  )
  (:action authorize_market_contract
    :parameters (?crop_work_order - crop_work_order ?weather_constraint - weather_constraint)
    :precondition
      (and
        (market_contract_operator_ready ?crop_work_order)
        (work_order_has_weather_constraint ?crop_work_order ?weather_constraint)
        (not
          (market_contract_authorized ?crop_work_order)
        )
      )
    :effect (market_contract_authorized ?crop_work_order)
  )
  (:action finalize_market_contract
    :parameters (?crop_work_order - crop_work_order)
    :precondition
      (and
        (market_contract_authorized ?crop_work_order)
        (not
          (work_order_finalized ?crop_work_order)
        )
      )
    :effect
      (and
        (work_order_finalized ?crop_work_order)
        (work_item_processing_completed ?crop_work_order)
      )
  )
  (:action mark_harvest_unit_processed
    :parameters (?harvest_unit - harvest_unit ?harvest_batch - harvest_batch)
    :precondition
      (and
        (unit_prepared ?harvest_unit)
        (unit_ready_for_batching ?harvest_unit)
        (batch_committed ?harvest_batch)
        (batch_ready_for_quality ?harvest_batch)
        (not
          (work_item_processing_completed ?harvest_unit)
        )
      )
    :effect (work_item_processing_completed ?harvest_unit)
  )
  (:action mark_transport_unit_processed
    :parameters (?transport_unit - transport_unit ?harvest_batch - harvest_batch)
    :precondition
      (and
        (transport_unit_prepared ?transport_unit)
        (transport_unit_ready ?transport_unit)
        (batch_committed ?harvest_batch)
        (batch_ready_for_quality ?harvest_batch)
        (not
          (work_item_processing_completed ?transport_unit)
        )
      )
    :effect (work_item_processing_completed ?transport_unit)
  )
  (:action release_field_to_storage_slot
    :parameters (?field_block - field_block ?storage_slot - storage_slot ?harvest_method - harvest_method)
    :precondition
      (and
        (work_item_processing_completed ?field_block)
        (work_item_assigned_method ?field_block ?harvest_method)
        (storage_slot_available ?storage_slot)
        (not
          (work_item_postharvest_released ?field_block)
        )
      )
    :effect
      (and
        (work_item_postharvest_released ?field_block)
        (work_item_assigned_storage_slot ?field_block ?storage_slot)
        (not
          (storage_slot_available ?storage_slot)
        )
      )
  )
  (:action release_harvest_unit_and_allocate_team
    :parameters (?harvest_unit - harvest_unit ?harvest_team - harvest_team ?storage_slot - storage_slot)
    :precondition
      (and
        (work_item_postharvest_released ?harvest_unit)
        (work_item_assigned_team ?harvest_unit ?harvest_team)
        (work_item_assigned_storage_slot ?harvest_unit ?storage_slot)
        (not
          (work_item_finalized ?harvest_unit)
        )
      )
    :effect
      (and
        (work_item_finalized ?harvest_unit)
        (team_available ?harvest_team)
        (storage_slot_available ?storage_slot)
      )
  )
  (:action release_transport_unit_and_allocate_team
    :parameters (?transport_unit - transport_unit ?harvest_team - harvest_team ?storage_slot - storage_slot)
    :precondition
      (and
        (work_item_postharvest_released ?transport_unit)
        (work_item_assigned_team ?transport_unit ?harvest_team)
        (work_item_assigned_storage_slot ?transport_unit ?storage_slot)
        (not
          (work_item_finalized ?transport_unit)
        )
      )
    :effect
      (and
        (work_item_finalized ?transport_unit)
        (team_available ?harvest_team)
        (storage_slot_available ?storage_slot)
      )
  )
  (:action release_work_order_and_allocate_team
    :parameters (?crop_work_order - crop_work_order ?harvest_team - harvest_team ?storage_slot - storage_slot)
    :precondition
      (and
        (work_item_postharvest_released ?crop_work_order)
        (work_item_assigned_team ?crop_work_order ?harvest_team)
        (work_item_assigned_storage_slot ?crop_work_order ?storage_slot)
        (not
          (work_item_finalized ?crop_work_order)
        )
      )
    :effect
      (and
        (work_item_finalized ?crop_work_order)
        (team_available ?harvest_team)
        (storage_slot_available ?storage_slot)
      )
  )
)

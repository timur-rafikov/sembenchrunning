(define (domain order_priority_fulfillment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types fulfillment_component - object inventory_entity - object consolidation_group - object order_entity - object order_request - order_entity supply_source - fulfillment_component pick_task - fulfillment_component operator - fulfillment_component priority_tag - fulfillment_component carrier_option - fulfillment_component delivery_window - fulfillment_component handling_resource - fulfillment_component routing_constraint - fulfillment_component sku_unit - inventory_entity item_unit - inventory_entity service_constraint - inventory_entity pick_wave - consolidation_group pack_batch - consolidation_group shipment - consolidation_group order_zone_allocation - order_request job_allocation - order_request pick_zone_instance - order_zone_allocation pack_zone_instance - order_zone_allocation fulfillment_job - job_allocation)
  (:predicates
    (fulfillment_entity_released ?order_request - order_request)
    (ready_for_fulfillment ?order_request - order_request)
    (fulfillment_entity_sourced ?order_request - order_request)
    (sourcing_allocation_finalized ?order_request - order_request)
    (fulfillment_entity_released_for_outbound ?order_request - order_request)
    (fulfillment_entity_delivery_window_assigned ?order_request - order_request)
    (supply_source_available ?supply_source - supply_source)
    (fulfillment_entity_assigned_supply_source ?order_request - order_request ?supply_source - supply_source)
    (pick_task_available ?pick_task - pick_task)
    (fulfillment_entity_assigned_pick_task ?order_request - order_request ?pick_task - pick_task)
    (operator_available ?operator - operator)
    (fulfillment_entity_assigned_operator ?order_request - order_request ?operator - operator)
    (sku_unit_available ?sku_unit - sku_unit)
    (pick_zone_reserved_sku ?pick_zone_instance - pick_zone_instance ?sku_unit - sku_unit)
    (pack_zone_reserved_sku ?pack_zone_instance - pack_zone_instance ?sku_unit - sku_unit)
    (pick_zone_assigned_to_wave ?pick_zone_instance - pick_zone_instance ?pick_wave - pick_wave)
    (pick_wave_ready ?pick_wave - pick_wave)
    (pick_wave_has_items ?pick_wave - pick_wave)
    (pick_zone_ready ?pick_zone_instance - pick_zone_instance)
    (pack_zone_assigned_to_batch ?pack_zone_instance - pack_zone_instance ?pack_batch - pack_batch)
    (pack_batch_ready ?pack_batch - pack_batch)
    (pack_batch_has_items ?pack_batch - pack_batch)
    (pack_zone_ready ?pack_zone_instance - pack_zone_instance)
    (shipment_slot_available ?shipment - shipment)
    (shipment_open ?shipment - shipment)
    (shipment_contains_pick_wave ?shipment - shipment ?pick_wave - pick_wave)
    (shipment_contains_pack_batch ?shipment - shipment ?pack_batch - pack_batch)
    (shipment_contains_unprocessed_pick_wave ?shipment - shipment)
    (shipment_contains_unprocessed_pack_batch ?shipment - shipment)
    (shipment_ready_for_staging ?shipment - shipment)
    (fulfillment_entity_assigned_pick_zone ?fulfillment_job - fulfillment_job ?pick_zone_instance - pick_zone_instance)
    (fulfillment_entity_assigned_pack_zone ?fulfillment_job - fulfillment_job ?pack_zone_instance - pack_zone_instance)
    (fulfillment_entity_assigned_shipment ?fulfillment_job - fulfillment_job ?shipment - shipment)
    (item_unit_available ?item_unit - item_unit)
    (job_contains_item_unit ?fulfillment_job - fulfillment_job ?item_unit - item_unit)
    (item_unit_staged ?item_unit - item_unit)
    (item_unit_staged_in_shipment ?item_unit - item_unit ?shipment - shipment)
    (job_items_verified ?fulfillment_job - fulfillment_job)
    (job_handling_assigned ?fulfillment_job - fulfillment_job)
    (job_constraints_verified ?fulfillment_job - fulfillment_job)
    (job_priority_assigned ?fulfillment_job - fulfillment_job)
    (job_priority_confirmed ?fulfillment_job - fulfillment_job)
    (job_ready_for_loading ?fulfillment_job - fulfillment_job)
    (job_marked_for_loading ?fulfillment_job - fulfillment_job)
    (service_constraint_available ?service_constraint - service_constraint)
    (fulfillment_entity_assigned_service_constraint ?fulfillment_job - fulfillment_job ?service_constraint - service_constraint)
    (job_service_constraint_attached ?fulfillment_job - fulfillment_job)
    (job_prepared_for_routing_checks ?fulfillment_job - fulfillment_job)
    (job_routing_verified ?fulfillment_job - fulfillment_job)
    (priority_tag_available ?priority_tag - priority_tag)
    (fulfillment_entity_assigned_priority_tag ?fulfillment_job - fulfillment_job ?priority_tag - priority_tag)
    (carrier_option_available ?carrier_option - carrier_option)
    (fulfillment_entity_assigned_carrier_option ?fulfillment_job - fulfillment_job ?carrier_option - carrier_option)
    (handling_resource_available ?handling_resource - handling_resource)
    (fulfillment_entity_assigned_handling_resource ?fulfillment_job - fulfillment_job ?handling_resource - handling_resource)
    (routing_constraint_available ?routing_constraint - routing_constraint)
    (fulfillment_entity_assigned_routing_constraint ?fulfillment_job - fulfillment_job ?routing_constraint - routing_constraint)
    (delivery_window_available ?delivery_window - delivery_window)
    (fulfillment_entity_assigned_delivery_window ?order_request - order_request ?delivery_window - delivery_window)
    (pick_zone_locked ?pick_zone_instance - pick_zone_instance)
    (pack_zone_locked ?pack_zone_instance - pack_zone_instance)
    (fulfillment_job_finalized ?fulfillment_job - fulfillment_job)
  )
  (:action release_order
    :parameters (?order_request - order_request)
    :precondition
      (and
        (not
          (fulfillment_entity_released ?order_request)
        )
        (not
          (sourcing_allocation_finalized ?order_request)
        )
      )
    :effect (fulfillment_entity_released ?order_request)
  )
  (:action assign_supply_source_to_order
    :parameters (?order_request - order_request ?supply_source - supply_source)
    :precondition
      (and
        (fulfillment_entity_released ?order_request)
        (not
          (fulfillment_entity_sourced ?order_request)
        )
        (supply_source_available ?supply_source)
      )
    :effect
      (and
        (fulfillment_entity_sourced ?order_request)
        (fulfillment_entity_assigned_supply_source ?order_request ?supply_source)
        (not
          (supply_source_available ?supply_source)
        )
      )
  )
  (:action assign_pick_task_to_order
    :parameters (?order_request - order_request ?pick_task - pick_task)
    :precondition
      (and
        (fulfillment_entity_released ?order_request)
        (fulfillment_entity_sourced ?order_request)
        (pick_task_available ?pick_task)
      )
    :effect
      (and
        (fulfillment_entity_assigned_pick_task ?order_request ?pick_task)
        (not
          (pick_task_available ?pick_task)
        )
      )
  )
  (:action confirm_pick_assignment
    :parameters (?order_request - order_request ?pick_task - pick_task)
    :precondition
      (and
        (fulfillment_entity_released ?order_request)
        (fulfillment_entity_sourced ?order_request)
        (fulfillment_entity_assigned_pick_task ?order_request ?pick_task)
        (not
          (ready_for_fulfillment ?order_request)
        )
      )
    :effect (ready_for_fulfillment ?order_request)
  )
  (:action unassign_pick_task_from_order
    :parameters (?order_request - order_request ?pick_task - pick_task)
    :precondition
      (and
        (fulfillment_entity_assigned_pick_task ?order_request ?pick_task)
      )
    :effect
      (and
        (pick_task_available ?pick_task)
        (not
          (fulfillment_entity_assigned_pick_task ?order_request ?pick_task)
        )
      )
  )
  (:action assign_operator_to_order
    :parameters (?order_request - order_request ?operator - operator)
    :precondition
      (and
        (ready_for_fulfillment ?order_request)
        (operator_available ?operator)
      )
    :effect
      (and
        (fulfillment_entity_assigned_operator ?order_request ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action unassign_operator_from_order
    :parameters (?order_request - order_request ?operator - operator)
    :precondition
      (and
        (fulfillment_entity_assigned_operator ?order_request ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (fulfillment_entity_assigned_operator ?order_request ?operator)
        )
      )
  )
  (:action assign_handling_resource_to_job
    :parameters (?fulfillment_job - fulfillment_job ?handling_resource - handling_resource)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_job)
        (handling_resource_available ?handling_resource)
      )
    :effect
      (and
        (fulfillment_entity_assigned_handling_resource ?fulfillment_job ?handling_resource)
        (not
          (handling_resource_available ?handling_resource)
        )
      )
  )
  (:action release_handling_resource_from_job
    :parameters (?fulfillment_job - fulfillment_job ?handling_resource - handling_resource)
    :precondition
      (and
        (fulfillment_entity_assigned_handling_resource ?fulfillment_job ?handling_resource)
      )
    :effect
      (and
        (handling_resource_available ?handling_resource)
        (not
          (fulfillment_entity_assigned_handling_resource ?fulfillment_job ?handling_resource)
        )
      )
  )
  (:action assign_routing_constraint_to_job
    :parameters (?fulfillment_job - fulfillment_job ?routing_constraint - routing_constraint)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_job)
        (routing_constraint_available ?routing_constraint)
      )
    :effect
      (and
        (fulfillment_entity_assigned_routing_constraint ?fulfillment_job ?routing_constraint)
        (not
          (routing_constraint_available ?routing_constraint)
        )
      )
  )
  (:action release_routing_constraint_from_job
    :parameters (?fulfillment_job - fulfillment_job ?routing_constraint - routing_constraint)
    :precondition
      (and
        (fulfillment_entity_assigned_routing_constraint ?fulfillment_job ?routing_constraint)
      )
    :effect
      (and
        (routing_constraint_available ?routing_constraint)
        (not
          (fulfillment_entity_assigned_routing_constraint ?fulfillment_job ?routing_constraint)
        )
      )
  )
  (:action activate_pick_wave_for_zone
    :parameters (?pick_zone_instance - pick_zone_instance ?pick_wave - pick_wave ?pick_task - pick_task)
    :precondition
      (and
        (ready_for_fulfillment ?pick_zone_instance)
        (fulfillment_entity_assigned_pick_task ?pick_zone_instance ?pick_task)
        (pick_zone_assigned_to_wave ?pick_zone_instance ?pick_wave)
        (not
          (pick_wave_ready ?pick_wave)
        )
        (not
          (pick_wave_has_items ?pick_wave)
        )
      )
    :effect (pick_wave_ready ?pick_wave)
  )
  (:action reserve_pick_zone_for_wave
    :parameters (?pick_zone_instance - pick_zone_instance ?pick_wave - pick_wave ?operator - operator)
    :precondition
      (and
        (ready_for_fulfillment ?pick_zone_instance)
        (fulfillment_entity_assigned_operator ?pick_zone_instance ?operator)
        (pick_zone_assigned_to_wave ?pick_zone_instance ?pick_wave)
        (pick_wave_ready ?pick_wave)
        (not
          (pick_zone_locked ?pick_zone_instance)
        )
      )
    :effect
      (and
        (pick_zone_locked ?pick_zone_instance)
        (pick_zone_ready ?pick_zone_instance)
      )
  )
  (:action stage_sku_in_pick_zone
    :parameters (?pick_zone_instance - pick_zone_instance ?pick_wave - pick_wave ?sku_unit - sku_unit)
    :precondition
      (and
        (ready_for_fulfillment ?pick_zone_instance)
        (pick_zone_assigned_to_wave ?pick_zone_instance ?pick_wave)
        (sku_unit_available ?sku_unit)
        (not
          (pick_zone_locked ?pick_zone_instance)
        )
      )
    :effect
      (and
        (pick_wave_has_items ?pick_wave)
        (pick_zone_locked ?pick_zone_instance)
        (pick_zone_reserved_sku ?pick_zone_instance ?sku_unit)
        (not
          (sku_unit_available ?sku_unit)
        )
      )
  )
  (:action finalize_staged_item_in_zone
    :parameters (?pick_zone_instance - pick_zone_instance ?pick_wave - pick_wave ?pick_task - pick_task ?sku_unit - sku_unit)
    :precondition
      (and
        (ready_for_fulfillment ?pick_zone_instance)
        (fulfillment_entity_assigned_pick_task ?pick_zone_instance ?pick_task)
        (pick_zone_assigned_to_wave ?pick_zone_instance ?pick_wave)
        (pick_wave_has_items ?pick_wave)
        (pick_zone_reserved_sku ?pick_zone_instance ?sku_unit)
        (not
          (pick_zone_ready ?pick_zone_instance)
        )
      )
    :effect
      (and
        (pick_wave_ready ?pick_wave)
        (pick_zone_ready ?pick_zone_instance)
        (sku_unit_available ?sku_unit)
        (not
          (pick_zone_reserved_sku ?pick_zone_instance ?sku_unit)
        )
      )
  )
  (:action activate_pack_batch_for_zone
    :parameters (?pack_zone_instance - pack_zone_instance ?pack_batch - pack_batch ?pick_task - pick_task)
    :precondition
      (and
        (ready_for_fulfillment ?pack_zone_instance)
        (fulfillment_entity_assigned_pick_task ?pack_zone_instance ?pick_task)
        (pack_zone_assigned_to_batch ?pack_zone_instance ?pack_batch)
        (not
          (pack_batch_ready ?pack_batch)
        )
        (not
          (pack_batch_has_items ?pack_batch)
        )
      )
    :effect (pack_batch_ready ?pack_batch)
  )
  (:action reserve_pack_zone_for_batch
    :parameters (?pack_zone_instance - pack_zone_instance ?pack_batch - pack_batch ?operator - operator)
    :precondition
      (and
        (ready_for_fulfillment ?pack_zone_instance)
        (fulfillment_entity_assigned_operator ?pack_zone_instance ?operator)
        (pack_zone_assigned_to_batch ?pack_zone_instance ?pack_batch)
        (pack_batch_ready ?pack_batch)
        (not
          (pack_zone_locked ?pack_zone_instance)
        )
      )
    :effect
      (and
        (pack_zone_locked ?pack_zone_instance)
        (pack_zone_ready ?pack_zone_instance)
      )
  )
  (:action stage_sku_in_pack_zone
    :parameters (?pack_zone_instance - pack_zone_instance ?pack_batch - pack_batch ?sku_unit - sku_unit)
    :precondition
      (and
        (ready_for_fulfillment ?pack_zone_instance)
        (pack_zone_assigned_to_batch ?pack_zone_instance ?pack_batch)
        (sku_unit_available ?sku_unit)
        (not
          (pack_zone_locked ?pack_zone_instance)
        )
      )
    :effect
      (and
        (pack_batch_has_items ?pack_batch)
        (pack_zone_locked ?pack_zone_instance)
        (pack_zone_reserved_sku ?pack_zone_instance ?sku_unit)
        (not
          (sku_unit_available ?sku_unit)
        )
      )
  )
  (:action finalize_staged_item_in_pack_zone
    :parameters (?pack_zone_instance - pack_zone_instance ?pack_batch - pack_batch ?pick_task - pick_task ?sku_unit - sku_unit)
    :precondition
      (and
        (ready_for_fulfillment ?pack_zone_instance)
        (fulfillment_entity_assigned_pick_task ?pack_zone_instance ?pick_task)
        (pack_zone_assigned_to_batch ?pack_zone_instance ?pack_batch)
        (pack_batch_has_items ?pack_batch)
        (pack_zone_reserved_sku ?pack_zone_instance ?sku_unit)
        (not
          (pack_zone_ready ?pack_zone_instance)
        )
      )
    :effect
      (and
        (pack_batch_ready ?pack_batch)
        (pack_zone_ready ?pack_zone_instance)
        (sku_unit_available ?sku_unit)
        (not
          (pack_zone_reserved_sku ?pack_zone_instance ?sku_unit)
        )
      )
  )
  (:action form_shipment_from_wave_and_batch
    :parameters (?pick_zone_instance - pick_zone_instance ?pack_zone_instance - pack_zone_instance ?pick_wave - pick_wave ?pack_batch - pack_batch ?shipment - shipment)
    :precondition
      (and
        (pick_zone_locked ?pick_zone_instance)
        (pack_zone_locked ?pack_zone_instance)
        (pick_zone_assigned_to_wave ?pick_zone_instance ?pick_wave)
        (pack_zone_assigned_to_batch ?pack_zone_instance ?pack_batch)
        (pick_wave_ready ?pick_wave)
        (pack_batch_ready ?pack_batch)
        (pick_zone_ready ?pick_zone_instance)
        (pack_zone_ready ?pack_zone_instance)
        (shipment_slot_available ?shipment)
      )
    :effect
      (and
        (shipment_open ?shipment)
        (shipment_contains_pick_wave ?shipment ?pick_wave)
        (shipment_contains_pack_batch ?shipment ?pack_batch)
        (not
          (shipment_slot_available ?shipment)
        )
      )
  )
  (:action form_shipment_with_unprocessed_pick_wave
    :parameters (?pick_zone_instance - pick_zone_instance ?pack_zone_instance - pack_zone_instance ?pick_wave - pick_wave ?pack_batch - pack_batch ?shipment - shipment)
    :precondition
      (and
        (pick_zone_locked ?pick_zone_instance)
        (pack_zone_locked ?pack_zone_instance)
        (pick_zone_assigned_to_wave ?pick_zone_instance ?pick_wave)
        (pack_zone_assigned_to_batch ?pack_zone_instance ?pack_batch)
        (pick_wave_has_items ?pick_wave)
        (pack_batch_ready ?pack_batch)
        (not
          (pick_zone_ready ?pick_zone_instance)
        )
        (pack_zone_ready ?pack_zone_instance)
        (shipment_slot_available ?shipment)
      )
    :effect
      (and
        (shipment_open ?shipment)
        (shipment_contains_pick_wave ?shipment ?pick_wave)
        (shipment_contains_pack_batch ?shipment ?pack_batch)
        (shipment_contains_unprocessed_pick_wave ?shipment)
        (not
          (shipment_slot_available ?shipment)
        )
      )
  )
  (:action form_shipment_with_unprocessed_pack_batch
    :parameters (?pick_zone_instance - pick_zone_instance ?pack_zone_instance - pack_zone_instance ?pick_wave - pick_wave ?pack_batch - pack_batch ?shipment - shipment)
    :precondition
      (and
        (pick_zone_locked ?pick_zone_instance)
        (pack_zone_locked ?pack_zone_instance)
        (pick_zone_assigned_to_wave ?pick_zone_instance ?pick_wave)
        (pack_zone_assigned_to_batch ?pack_zone_instance ?pack_batch)
        (pick_wave_ready ?pick_wave)
        (pack_batch_has_items ?pack_batch)
        (pick_zone_ready ?pick_zone_instance)
        (not
          (pack_zone_ready ?pack_zone_instance)
        )
        (shipment_slot_available ?shipment)
      )
    :effect
      (and
        (shipment_open ?shipment)
        (shipment_contains_pick_wave ?shipment ?pick_wave)
        (shipment_contains_pack_batch ?shipment ?pack_batch)
        (shipment_contains_unprocessed_pack_batch ?shipment)
        (not
          (shipment_slot_available ?shipment)
        )
      )
  )
  (:action form_shipment_with_unprocessed_wave_and_batch
    :parameters (?pick_zone_instance - pick_zone_instance ?pack_zone_instance - pack_zone_instance ?pick_wave - pick_wave ?pack_batch - pack_batch ?shipment - shipment)
    :precondition
      (and
        (pick_zone_locked ?pick_zone_instance)
        (pack_zone_locked ?pack_zone_instance)
        (pick_zone_assigned_to_wave ?pick_zone_instance ?pick_wave)
        (pack_zone_assigned_to_batch ?pack_zone_instance ?pack_batch)
        (pick_wave_has_items ?pick_wave)
        (pack_batch_has_items ?pack_batch)
        (not
          (pick_zone_ready ?pick_zone_instance)
        )
        (not
          (pack_zone_ready ?pack_zone_instance)
        )
        (shipment_slot_available ?shipment)
      )
    :effect
      (and
        (shipment_open ?shipment)
        (shipment_contains_pick_wave ?shipment ?pick_wave)
        (shipment_contains_pack_batch ?shipment ?pack_batch)
        (shipment_contains_unprocessed_pick_wave ?shipment)
        (shipment_contains_unprocessed_pack_batch ?shipment)
        (not
          (shipment_slot_available ?shipment)
        )
      )
  )
  (:action confirm_shipment_for_staging
    :parameters (?shipment - shipment ?pick_zone_instance - pick_zone_instance ?pick_task - pick_task)
    :precondition
      (and
        (shipment_open ?shipment)
        (pick_zone_locked ?pick_zone_instance)
        (fulfillment_entity_assigned_pick_task ?pick_zone_instance ?pick_task)
        (not
          (shipment_ready_for_staging ?shipment)
        )
      )
    :effect (shipment_ready_for_staging ?shipment)
  )
  (:action stage_item_into_shipment
    :parameters (?fulfillment_job - fulfillment_job ?item_unit - item_unit ?shipment - shipment)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_job)
        (fulfillment_entity_assigned_shipment ?fulfillment_job ?shipment)
        (job_contains_item_unit ?fulfillment_job ?item_unit)
        (item_unit_available ?item_unit)
        (shipment_open ?shipment)
        (shipment_ready_for_staging ?shipment)
        (not
          (item_unit_staged ?item_unit)
        )
      )
    :effect
      (and
        (item_unit_staged ?item_unit)
        (item_unit_staged_in_shipment ?item_unit ?shipment)
        (not
          (item_unit_available ?item_unit)
        )
      )
  )
  (:action verify_item_and_flag_job
    :parameters (?fulfillment_job - fulfillment_job ?item_unit - item_unit ?shipment - shipment ?pick_task - pick_task)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_job)
        (job_contains_item_unit ?fulfillment_job ?item_unit)
        (item_unit_staged ?item_unit)
        (item_unit_staged_in_shipment ?item_unit ?shipment)
        (fulfillment_entity_assigned_pick_task ?fulfillment_job ?pick_task)
        (not
          (shipment_contains_unprocessed_pick_wave ?shipment)
        )
        (not
          (job_items_verified ?fulfillment_job)
        )
      )
    :effect (job_items_verified ?fulfillment_job)
  )
  (:action assign_priority_tag_to_job
    :parameters (?fulfillment_job - fulfillment_job ?priority_tag - priority_tag)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_job)
        (priority_tag_available ?priority_tag)
        (not
          (job_priority_assigned ?fulfillment_job)
        )
      )
    :effect
      (and
        (job_priority_assigned ?fulfillment_job)
        (fulfillment_entity_assigned_priority_tag ?fulfillment_job ?priority_tag)
        (not
          (priority_tag_available ?priority_tag)
        )
      )
  )
  (:action apply_priority_and_mark_items_verified
    :parameters (?fulfillment_job - fulfillment_job ?item_unit - item_unit ?shipment - shipment ?pick_task - pick_task ?priority_tag - priority_tag)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_job)
        (job_contains_item_unit ?fulfillment_job ?item_unit)
        (item_unit_staged ?item_unit)
        (item_unit_staged_in_shipment ?item_unit ?shipment)
        (fulfillment_entity_assigned_pick_task ?fulfillment_job ?pick_task)
        (shipment_contains_unprocessed_pick_wave ?shipment)
        (job_priority_assigned ?fulfillment_job)
        (fulfillment_entity_assigned_priority_tag ?fulfillment_job ?priority_tag)
        (not
          (job_items_verified ?fulfillment_job)
        )
      )
    :effect
      (and
        (job_items_verified ?fulfillment_job)
        (job_priority_confirmed ?fulfillment_job)
      )
  )
  (:action prepare_job_with_handling_resource
    :parameters (?fulfillment_job - fulfillment_job ?handling_resource - handling_resource ?operator - operator ?item_unit - item_unit ?shipment - shipment)
    :precondition
      (and
        (job_items_verified ?fulfillment_job)
        (fulfillment_entity_assigned_handling_resource ?fulfillment_job ?handling_resource)
        (fulfillment_entity_assigned_operator ?fulfillment_job ?operator)
        (job_contains_item_unit ?fulfillment_job ?item_unit)
        (item_unit_staged_in_shipment ?item_unit ?shipment)
        (not
          (shipment_contains_unprocessed_pack_batch ?shipment)
        )
        (not
          (job_handling_assigned ?fulfillment_job)
        )
      )
    :effect (job_handling_assigned ?fulfillment_job)
  )
  (:action prepare_job_with_handling_resource_confirmed
    :parameters (?fulfillment_job - fulfillment_job ?handling_resource - handling_resource ?operator - operator ?item_unit - item_unit ?shipment - shipment)
    :precondition
      (and
        (job_items_verified ?fulfillment_job)
        (fulfillment_entity_assigned_handling_resource ?fulfillment_job ?handling_resource)
        (fulfillment_entity_assigned_operator ?fulfillment_job ?operator)
        (job_contains_item_unit ?fulfillment_job ?item_unit)
        (item_unit_staged_in_shipment ?item_unit ?shipment)
        (shipment_contains_unprocessed_pack_batch ?shipment)
        (not
          (job_handling_assigned ?fulfillment_job)
        )
      )
    :effect (job_handling_assigned ?fulfillment_job)
  )
  (:action mark_routing_checked
    :parameters (?fulfillment_job - fulfillment_job ?routing_constraint - routing_constraint ?item_unit - item_unit ?shipment - shipment)
    :precondition
      (and
        (job_handling_assigned ?fulfillment_job)
        (fulfillment_entity_assigned_routing_constraint ?fulfillment_job ?routing_constraint)
        (job_contains_item_unit ?fulfillment_job ?item_unit)
        (item_unit_staged_in_shipment ?item_unit ?shipment)
        (not
          (shipment_contains_unprocessed_pick_wave ?shipment)
        )
        (not
          (shipment_contains_unprocessed_pack_batch ?shipment)
        )
        (not
          (job_constraints_verified ?fulfillment_job)
        )
      )
    :effect (job_constraints_verified ?fulfillment_job)
  )
  (:action mark_routing_checked_and_flag_pick
    :parameters (?fulfillment_job - fulfillment_job ?routing_constraint - routing_constraint ?item_unit - item_unit ?shipment - shipment)
    :precondition
      (and
        (job_handling_assigned ?fulfillment_job)
        (fulfillment_entity_assigned_routing_constraint ?fulfillment_job ?routing_constraint)
        (job_contains_item_unit ?fulfillment_job ?item_unit)
        (item_unit_staged_in_shipment ?item_unit ?shipment)
        (shipment_contains_unprocessed_pick_wave ?shipment)
        (not
          (shipment_contains_unprocessed_pack_batch ?shipment)
        )
        (not
          (job_constraints_verified ?fulfillment_job)
        )
      )
    :effect
      (and
        (job_constraints_verified ?fulfillment_job)
        (job_ready_for_loading ?fulfillment_job)
      )
  )
  (:action mark_routing_checked_and_flag_pack
    :parameters (?fulfillment_job - fulfillment_job ?routing_constraint - routing_constraint ?item_unit - item_unit ?shipment - shipment)
    :precondition
      (and
        (job_handling_assigned ?fulfillment_job)
        (fulfillment_entity_assigned_routing_constraint ?fulfillment_job ?routing_constraint)
        (job_contains_item_unit ?fulfillment_job ?item_unit)
        (item_unit_staged_in_shipment ?item_unit ?shipment)
        (not
          (shipment_contains_unprocessed_pick_wave ?shipment)
        )
        (shipment_contains_unprocessed_pack_batch ?shipment)
        (not
          (job_constraints_verified ?fulfillment_job)
        )
      )
    :effect
      (and
        (job_constraints_verified ?fulfillment_job)
        (job_ready_for_loading ?fulfillment_job)
      )
  )
  (:action mark_routing_checked_and_flag_both
    :parameters (?fulfillment_job - fulfillment_job ?routing_constraint - routing_constraint ?item_unit - item_unit ?shipment - shipment)
    :precondition
      (and
        (job_handling_assigned ?fulfillment_job)
        (fulfillment_entity_assigned_routing_constraint ?fulfillment_job ?routing_constraint)
        (job_contains_item_unit ?fulfillment_job ?item_unit)
        (item_unit_staged_in_shipment ?item_unit ?shipment)
        (shipment_contains_unprocessed_pick_wave ?shipment)
        (shipment_contains_unprocessed_pack_batch ?shipment)
        (not
          (job_constraints_verified ?fulfillment_job)
        )
      )
    :effect
      (and
        (job_constraints_verified ?fulfillment_job)
        (job_ready_for_loading ?fulfillment_job)
      )
  )
  (:action finalize_fulfillment_job
    :parameters (?fulfillment_job - fulfillment_job)
    :precondition
      (and
        (job_constraints_verified ?fulfillment_job)
        (not
          (job_ready_for_loading ?fulfillment_job)
        )
        (not
          (fulfillment_job_finalized ?fulfillment_job)
        )
      )
    :effect
      (and
        (fulfillment_job_finalized ?fulfillment_job)
        (fulfillment_entity_released_for_outbound ?fulfillment_job)
      )
  )
  (:action assign_carrier_option_to_job
    :parameters (?fulfillment_job - fulfillment_job ?carrier_option - carrier_option)
    :precondition
      (and
        (job_constraints_verified ?fulfillment_job)
        (job_ready_for_loading ?fulfillment_job)
        (carrier_option_available ?carrier_option)
      )
    :effect
      (and
        (fulfillment_entity_assigned_carrier_option ?fulfillment_job ?carrier_option)
        (not
          (carrier_option_available ?carrier_option)
        )
      )
  )
  (:action flag_job_ready_for_loading
    :parameters (?fulfillment_job - fulfillment_job ?pick_zone_instance - pick_zone_instance ?pack_zone_instance - pack_zone_instance ?pick_task - pick_task ?carrier_option - carrier_option)
    :precondition
      (and
        (job_constraints_verified ?fulfillment_job)
        (job_ready_for_loading ?fulfillment_job)
        (fulfillment_entity_assigned_carrier_option ?fulfillment_job ?carrier_option)
        (fulfillment_entity_assigned_pick_zone ?fulfillment_job ?pick_zone_instance)
        (fulfillment_entity_assigned_pack_zone ?fulfillment_job ?pack_zone_instance)
        (pick_zone_ready ?pick_zone_instance)
        (pack_zone_ready ?pack_zone_instance)
        (fulfillment_entity_assigned_pick_task ?fulfillment_job ?pick_task)
        (not
          (job_marked_for_loading ?fulfillment_job)
        )
      )
    :effect (job_marked_for_loading ?fulfillment_job)
  )
  (:action finalize_job_after_loading_prep
    :parameters (?fulfillment_job - fulfillment_job)
    :precondition
      (and
        (job_constraints_verified ?fulfillment_job)
        (job_marked_for_loading ?fulfillment_job)
        (not
          (fulfillment_job_finalized ?fulfillment_job)
        )
      )
    :effect
      (and
        (fulfillment_job_finalized ?fulfillment_job)
        (fulfillment_entity_released_for_outbound ?fulfillment_job)
      )
  )
  (:action attach_service_constraint_to_job
    :parameters (?fulfillment_job - fulfillment_job ?service_constraint - service_constraint ?pick_task - pick_task)
    :precondition
      (and
        (ready_for_fulfillment ?fulfillment_job)
        (fulfillment_entity_assigned_pick_task ?fulfillment_job ?pick_task)
        (service_constraint_available ?service_constraint)
        (fulfillment_entity_assigned_service_constraint ?fulfillment_job ?service_constraint)
        (not
          (job_service_constraint_attached ?fulfillment_job)
        )
      )
    :effect
      (and
        (job_service_constraint_attached ?fulfillment_job)
        (not
          (service_constraint_available ?service_constraint)
        )
      )
  )
  (:action prepare_job_for_routing_checks
    :parameters (?fulfillment_job - fulfillment_job ?operator - operator)
    :precondition
      (and
        (job_service_constraint_attached ?fulfillment_job)
        (fulfillment_entity_assigned_operator ?fulfillment_job ?operator)
        (not
          (job_prepared_for_routing_checks ?fulfillment_job)
        )
      )
    :effect (job_prepared_for_routing_checks ?fulfillment_job)
  )
  (:action verify_routing_for_job
    :parameters (?fulfillment_job - fulfillment_job ?routing_constraint - routing_constraint)
    :precondition
      (and
        (job_prepared_for_routing_checks ?fulfillment_job)
        (fulfillment_entity_assigned_routing_constraint ?fulfillment_job ?routing_constraint)
        (not
          (job_routing_verified ?fulfillment_job)
        )
      )
    :effect (job_routing_verified ?fulfillment_job)
  )
  (:action finalize_job_after_routing_verification
    :parameters (?fulfillment_job - fulfillment_job)
    :precondition
      (and
        (job_routing_verified ?fulfillment_job)
        (not
          (fulfillment_job_finalized ?fulfillment_job)
        )
      )
    :effect
      (and
        (fulfillment_job_finalized ?fulfillment_job)
        (fulfillment_entity_released_for_outbound ?fulfillment_job)
      )
  )
  (:action release_pick_zone_for_outbound
    :parameters (?pick_zone_instance - pick_zone_instance ?shipment - shipment)
    :precondition
      (and
        (pick_zone_locked ?pick_zone_instance)
        (pick_zone_ready ?pick_zone_instance)
        (shipment_open ?shipment)
        (shipment_ready_for_staging ?shipment)
        (not
          (fulfillment_entity_released_for_outbound ?pick_zone_instance)
        )
      )
    :effect (fulfillment_entity_released_for_outbound ?pick_zone_instance)
  )
  (:action release_pack_zone_for_outbound
    :parameters (?pack_zone_instance - pack_zone_instance ?shipment - shipment)
    :precondition
      (and
        (pack_zone_locked ?pack_zone_instance)
        (pack_zone_ready ?pack_zone_instance)
        (shipment_open ?shipment)
        (shipment_ready_for_staging ?shipment)
        (not
          (fulfillment_entity_released_for_outbound ?pack_zone_instance)
        )
      )
    :effect (fulfillment_entity_released_for_outbound ?pack_zone_instance)
  )
  (:action assign_delivery_window_to_order
    :parameters (?order_request - order_request ?delivery_window - delivery_window ?pick_task - pick_task)
    :precondition
      (and
        (fulfillment_entity_released_for_outbound ?order_request)
        (fulfillment_entity_assigned_pick_task ?order_request ?pick_task)
        (delivery_window_available ?delivery_window)
        (not
          (fulfillment_entity_delivery_window_assigned ?order_request)
        )
      )
    :effect
      (and
        (fulfillment_entity_delivery_window_assigned ?order_request)
        (fulfillment_entity_assigned_delivery_window ?order_request ?delivery_window)
        (not
          (delivery_window_available ?delivery_window)
        )
      )
  )
  (:action commit_zone_allocation
    :parameters (?pick_zone_instance - pick_zone_instance ?supply_source - supply_source ?delivery_window - delivery_window)
    :precondition
      (and
        (fulfillment_entity_delivery_window_assigned ?pick_zone_instance)
        (fulfillment_entity_assigned_supply_source ?pick_zone_instance ?supply_source)
        (fulfillment_entity_assigned_delivery_window ?pick_zone_instance ?delivery_window)
        (not
          (sourcing_allocation_finalized ?pick_zone_instance)
        )
      )
    :effect
      (and
        (sourcing_allocation_finalized ?pick_zone_instance)
        (supply_source_available ?supply_source)
        (delivery_window_available ?delivery_window)
      )
  )
  (:action commit_pack_zone_allocation
    :parameters (?pack_zone_instance - pack_zone_instance ?supply_source - supply_source ?delivery_window - delivery_window)
    :precondition
      (and
        (fulfillment_entity_delivery_window_assigned ?pack_zone_instance)
        (fulfillment_entity_assigned_supply_source ?pack_zone_instance ?supply_source)
        (fulfillment_entity_assigned_delivery_window ?pack_zone_instance ?delivery_window)
        (not
          (sourcing_allocation_finalized ?pack_zone_instance)
        )
      )
    :effect
      (and
        (sourcing_allocation_finalized ?pack_zone_instance)
        (supply_source_available ?supply_source)
        (delivery_window_available ?delivery_window)
      )
  )
  (:action commit_fulfillment_job_allocation
    :parameters (?fulfillment_job - fulfillment_job ?supply_source - supply_source ?delivery_window - delivery_window)
    :precondition
      (and
        (fulfillment_entity_delivery_window_assigned ?fulfillment_job)
        (fulfillment_entity_assigned_supply_source ?fulfillment_job ?supply_source)
        (fulfillment_entity_assigned_delivery_window ?fulfillment_job ?delivery_window)
        (not
          (sourcing_allocation_finalized ?fulfillment_job)
        )
      )
    :effect
      (and
        (sourcing_allocation_finalized ?fulfillment_job)
        (supply_source_available ?supply_source)
        (delivery_window_available ?delivery_window)
      )
  )
)

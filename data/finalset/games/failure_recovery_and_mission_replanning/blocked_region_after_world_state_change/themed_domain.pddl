(define (domain blocked_region_recovery)
  (:requirements :strips :typing :negative-preconditions)
  (:types base_object - object asset_category - base_object path_category - base_object vehicle_category - base_object location_base - base_object region - location_base asset_unit - asset_category route_option - asset_category operator - asset_category mod_slot - asset_category upgrade_module - asset_category checkpoint_marker - asset_category equipment_unit - asset_category tactic_profile - asset_category consumable_supply - path_category supply_cache - path_category intel_packet - path_category map_segment - vehicle_category detour_option - vehicle_category transport_vehicle - vehicle_category unit_location - region operation_location - region scout_unit - unit_location assault_unit - unit_location operation_slot - operation_location)

  (:predicates
    (recovery_task_created ?region - region)
    (route_validated_for_entity ?region - region)
    (asset_reserved ?region - region)
    (region_unblocked ?region - region)
    (activated ?region - region)
    (entity_prepped ?region - region)
    (asset_available ?asset_unit - asset_unit)
    (asset_bound_to_entity ?region - region ?asset_unit - asset_unit)
    (route_available ?route_option - route_option)
    (route_bound_to_entity ?region - region ?route_option - route_option)
    (operator_available ?operator - operator)
    (operator_bound_to_entity ?region - region ?operator - operator)
    (supply_available ?consumable_supply - consumable_supply)
    (supply_assigned_to_scout ?scout_unit - scout_unit ?consumable_supply - consumable_supply)
    (supply_assigned_to_assault ?assault_unit - assault_unit ?consumable_supply - consumable_supply)
    (unit_associated_segment ?scout_unit - scout_unit ?map_segment - map_segment)
    (segment_verified ?map_segment - map_segment)
    (segment_has_supply ?map_segment - map_segment)
    (scout_validated ?scout_unit - scout_unit)
    (unit_associated_detour ?assault_unit - assault_unit ?detour_option - detour_option)
    (detour_verified ?detour_option - detour_option)
    (detour_has_supply ?detour_option - detour_option)
    (assault_validated ?assault_unit - assault_unit)
    (vehicle_available ?transport_vehicle - transport_vehicle)
    (vehicle_configured ?transport_vehicle - transport_vehicle)
    (vehicle_bound_to_segment ?transport_vehicle - transport_vehicle ?map_segment - map_segment)
    (vehicle_bound_to_detour ?transport_vehicle - transport_vehicle ?detour_option - detour_option)
    (vehicle_segment_supply_attached ?transport_vehicle - transport_vehicle)
    (vehicle_detour_supply_attached ?transport_vehicle - transport_vehicle)
    (vehicle_insert_ready ?transport_vehicle - transport_vehicle)
    (op_slot_assigned_scout ?operation_slot - operation_slot ?scout_unit - scout_unit)
    (op_slot_assigned_assault ?operation_slot - operation_slot ?assault_unit - assault_unit)
    (op_slot_assigned_vehicle ?operation_slot - operation_slot ?transport_vehicle - transport_vehicle)
    (supply_cache_available ?supply_cache - supply_cache)
    (op_slot_has_supply_cache ?operation_slot - operation_slot ?supply_cache - supply_cache)
    (supply_cache_deployed ?supply_cache - supply_cache)
    (supply_cache_attached_to_vehicle ?supply_cache - supply_cache ?transport_vehicle - transport_vehicle)
    (op_slot_stage1_ready ?operation_slot - operation_slot)
    (op_slot_stage2_ready ?operation_slot - operation_slot)
    (op_slot_stage3_ready ?operation_slot - operation_slot)
    (op_slot_mod_ready ?operation_slot - operation_slot)
    (op_slot_mod_verified ?operation_slot - operation_slot)
    (op_slot_upgrade_attached ?operation_slot - operation_slot)
    (op_slot_team_finalized ?operation_slot - operation_slot)
    (intel_packet_available ?intel_packet - intel_packet)
    (op_slot_has_intel_packet ?operation_slot - operation_slot ?intel_packet - intel_packet)
    (op_slot_intel_attached ?operation_slot - operation_slot)
    (op_slot_intel_processed ?operation_slot - operation_slot)
    (op_slot_tactic_set ?operation_slot - operation_slot)
    (mod_slot_available ?mod_slot - mod_slot)
    (op_slot_bound_mod_slot ?operation_slot - operation_slot ?mod_slot - mod_slot)
    (upgrade_module_available ?upgrade_module - upgrade_module)
    (op_slot_has_upgrade_module ?operation_slot - operation_slot ?upgrade_module - upgrade_module)
    (equipment_unit_available ?equipment_unit - equipment_unit)
    (op_slot_equipped_with_equipment ?operation_slot - operation_slot ?equipment_unit - equipment_unit)
    (tactic_profile_available ?tactic_profile - tactic_profile)
    (op_slot_has_tactic_profile ?operation_slot - operation_slot ?tactic_profile - tactic_profile)
    (checkpoint_marker_available ?checkpoint_marker - checkpoint_marker)
    (region_has_checkpoint ?region - region ?checkpoint_marker - checkpoint_marker)
    (scout_prepped ?scout_unit - scout_unit)
    (assault_prepped ?assault_unit - assault_unit)
    (activation_committed ?operation_slot - operation_slot)
  )
  (:action initiate_recovery_task
    :parameters (?region - region)
    :precondition
      (and
        (not
          (recovery_task_created ?region)
        )
        (not
          (region_unblocked ?region)
        )
      )
    :effect (recovery_task_created ?region)
  )
  (:action reserve_asset_for_region
    :parameters (?region - region ?asset_unit - asset_unit)
    :precondition
      (and
        (recovery_task_created ?region)
        (not
          (asset_reserved ?region)
        )
        (asset_available ?asset_unit)
      )
    :effect
      (and
        (asset_reserved ?region)
        (asset_bound_to_entity ?region ?asset_unit)
        (not
          (asset_available ?asset_unit)
        )
      )
  )
  (:action bind_route_to_region
    :parameters (?region - region ?route_option - route_option)
    :precondition
      (and
        (recovery_task_created ?region)
        (asset_reserved ?region)
        (route_available ?route_option)
      )
    :effect
      (and
        (route_bound_to_entity ?region ?route_option)
        (not
          (route_available ?route_option)
        )
      )
  )
  (:action validate_route_for_region
    :parameters (?region - region ?route_option - route_option)
    :precondition
      (and
        (recovery_task_created ?region)
        (asset_reserved ?region)
        (route_bound_to_entity ?region ?route_option)
        (not
          (route_validated_for_entity ?region)
        )
      )
    :effect (route_validated_for_entity ?region)
  )
  (:action release_route_from_region
    :parameters (?region - region ?route_option - route_option)
    :precondition
      (and
        (route_bound_to_entity ?region ?route_option)
      )
    :effect
      (and
        (route_available ?route_option)
        (not
          (route_bound_to_entity ?region ?route_option)
        )
      )
  )
  (:action assign_operator_to_region
    :parameters (?region - region ?operator - operator)
    :precondition
      (and
        (route_validated_for_entity ?region)
        (operator_available ?operator)
      )
    :effect
      (and
        (operator_bound_to_entity ?region ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action release_operator_from_region
    :parameters (?region - region ?operator - operator)
    :precondition
      (and
        (operator_bound_to_entity ?region ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (operator_bound_to_entity ?region ?operator)
        )
      )
  )
  (:action assign_equipment_to_operation
    :parameters (?operation_slot - operation_slot ?equipment_unit - equipment_unit)
    :precondition
      (and
        (route_validated_for_entity ?operation_slot)
        (equipment_unit_available ?equipment_unit)
      )
    :effect
      (and
        (op_slot_equipped_with_equipment ?operation_slot ?equipment_unit)
        (not
          (equipment_unit_available ?equipment_unit)
        )
      )
  )
  (:action remove_equipment_from_operation
    :parameters (?operation_slot - operation_slot ?equipment_unit - equipment_unit)
    :precondition
      (and
        (op_slot_equipped_with_equipment ?operation_slot ?equipment_unit)
      )
    :effect
      (and
        (equipment_unit_available ?equipment_unit)
        (not
          (op_slot_equipped_with_equipment ?operation_slot ?equipment_unit)
        )
      )
  )
  (:action assign_tactic_profile_to_operation
    :parameters (?operation_slot - operation_slot ?tactic_profile - tactic_profile)
    :precondition
      (and
        (route_validated_for_entity ?operation_slot)
        (tactic_profile_available ?tactic_profile)
      )
    :effect
      (and
        (op_slot_has_tactic_profile ?operation_slot ?tactic_profile)
        (not
          (tactic_profile_available ?tactic_profile)
        )
      )
  )
  (:action unassign_tactic_profile_from_operation
    :parameters (?operation_slot - operation_slot ?tactic_profile - tactic_profile)
    :precondition
      (and
        (op_slot_has_tactic_profile ?operation_slot ?tactic_profile)
      )
    :effect
      (and
        (tactic_profile_available ?tactic_profile)
        (not
          (op_slot_has_tactic_profile ?operation_slot ?tactic_profile)
        )
      )
  )
  (:action validate_map_segment_for_unit
    :parameters (?scout_unit - scout_unit ?map_segment - map_segment ?route_option - route_option)
    :precondition
      (and
        (route_validated_for_entity ?scout_unit)
        (route_bound_to_entity ?scout_unit ?route_option)
        (unit_associated_segment ?scout_unit ?map_segment)
        (not
          (segment_verified ?map_segment)
        )
        (not
          (segment_has_supply ?map_segment)
        )
      )
    :effect (segment_verified ?map_segment)
  )
  (:action prepare_scout_with_operator
    :parameters (?scout_unit - scout_unit ?map_segment - map_segment ?operator - operator)
    :precondition
      (and
        (route_validated_for_entity ?scout_unit)
        (operator_bound_to_entity ?scout_unit ?operator)
        (unit_associated_segment ?scout_unit ?map_segment)
        (segment_verified ?map_segment)
        (not
          (scout_prepped ?scout_unit)
        )
      )
    :effect
      (and
        (scout_prepped ?scout_unit)
        (scout_validated ?scout_unit)
      )
  )
  (:action deploy_supply_to_unit_and_segment
    :parameters (?scout_unit - scout_unit ?map_segment - map_segment ?consumable_supply - consumable_supply)
    :precondition
      (and
        (route_validated_for_entity ?scout_unit)
        (unit_associated_segment ?scout_unit ?map_segment)
        (supply_available ?consumable_supply)
        (not
          (scout_prepped ?scout_unit)
        )
      )
    :effect
      (and
        (segment_has_supply ?map_segment)
        (scout_prepped ?scout_unit)
        (supply_assigned_to_scout ?scout_unit ?consumable_supply)
        (not
          (supply_available ?consumable_supply)
        )
      )
  )
  (:action use_supply_to_validate_segment
    :parameters (?scout_unit - scout_unit ?map_segment - map_segment ?route_option - route_option ?consumable_supply - consumable_supply)
    :precondition
      (and
        (route_validated_for_entity ?scout_unit)
        (route_bound_to_entity ?scout_unit ?route_option)
        (unit_associated_segment ?scout_unit ?map_segment)
        (segment_has_supply ?map_segment)
        (supply_assigned_to_scout ?scout_unit ?consumable_supply)
        (not
          (scout_validated ?scout_unit)
        )
      )
    :effect
      (and
        (segment_verified ?map_segment)
        (scout_validated ?scout_unit)
        (supply_available ?consumable_supply)
        (not
          (supply_assigned_to_scout ?scout_unit ?consumable_supply)
        )
      )
  )
  (:action validate_detour_for_unit
    :parameters (?assault_unit - assault_unit ?detour_option - detour_option ?route_option - route_option)
    :precondition
      (and
        (route_validated_for_entity ?assault_unit)
        (route_bound_to_entity ?assault_unit ?route_option)
        (unit_associated_detour ?assault_unit ?detour_option)
        (not
          (detour_verified ?detour_option)
        )
        (not
          (detour_has_supply ?detour_option)
        )
      )
    :effect (detour_verified ?detour_option)
  )
  (:action prepare_assault_with_operator
    :parameters (?assault_unit - assault_unit ?detour_option - detour_option ?operator - operator)
    :precondition
      (and
        (route_validated_for_entity ?assault_unit)
        (operator_bound_to_entity ?assault_unit ?operator)
        (unit_associated_detour ?assault_unit ?detour_option)
        (detour_verified ?detour_option)
        (not
          (assault_prepped ?assault_unit)
        )
      )
    :effect
      (and
        (assault_prepped ?assault_unit)
        (assault_validated ?assault_unit)
      )
  )
  (:action deploy_supply_to_assault_and_detour
    :parameters (?assault_unit - assault_unit ?detour_option - detour_option ?consumable_supply - consumable_supply)
    :precondition
      (and
        (route_validated_for_entity ?assault_unit)
        (unit_associated_detour ?assault_unit ?detour_option)
        (supply_available ?consumable_supply)
        (not
          (assault_prepped ?assault_unit)
        )
      )
    :effect
      (and
        (detour_has_supply ?detour_option)
        (assault_prepped ?assault_unit)
        (supply_assigned_to_assault ?assault_unit ?consumable_supply)
        (not
          (supply_available ?consumable_supply)
        )
      )
  )
  (:action use_supply_to_validate_detour
    :parameters (?assault_unit - assault_unit ?detour_option - detour_option ?route_option - route_option ?consumable_supply - consumable_supply)
    :precondition
      (and
        (route_validated_for_entity ?assault_unit)
        (route_bound_to_entity ?assault_unit ?route_option)
        (unit_associated_detour ?assault_unit ?detour_option)
        (detour_has_supply ?detour_option)
        (supply_assigned_to_assault ?assault_unit ?consumable_supply)
        (not
          (assault_validated ?assault_unit)
        )
      )
    :effect
      (and
        (detour_verified ?detour_option)
        (assault_validated ?assault_unit)
        (supply_available ?consumable_supply)
        (not
          (supply_assigned_to_assault ?assault_unit ?consumable_supply)
        )
      )
  )
  (:action configure_transport_with_segment_and_detour
    :parameters (?scout_unit - scout_unit ?assault_unit - assault_unit ?map_segment - map_segment ?detour_option - detour_option ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (scout_prepped ?scout_unit)
        (assault_prepped ?assault_unit)
        (unit_associated_segment ?scout_unit ?map_segment)
        (unit_associated_detour ?assault_unit ?detour_option)
        (segment_verified ?map_segment)
        (detour_verified ?detour_option)
        (scout_validated ?scout_unit)
        (assault_validated ?assault_unit)
        (vehicle_available ?transport_vehicle)
      )
    :effect
      (and
        (vehicle_configured ?transport_vehicle)
        (vehicle_bound_to_segment ?transport_vehicle ?map_segment)
        (vehicle_bound_to_detour ?transport_vehicle ?detour_option)
        (not
          (vehicle_available ?transport_vehicle)
        )
      )
  )
  (:action configure_transport_with_segment_supply
    :parameters (?scout_unit - scout_unit ?assault_unit - assault_unit ?map_segment - map_segment ?detour_option - detour_option ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (scout_prepped ?scout_unit)
        (assault_prepped ?assault_unit)
        (unit_associated_segment ?scout_unit ?map_segment)
        (unit_associated_detour ?assault_unit ?detour_option)
        (segment_has_supply ?map_segment)
        (detour_verified ?detour_option)
        (not
          (scout_validated ?scout_unit)
        )
        (assault_validated ?assault_unit)
        (vehicle_available ?transport_vehicle)
      )
    :effect
      (and
        (vehicle_configured ?transport_vehicle)
        (vehicle_bound_to_segment ?transport_vehicle ?map_segment)
        (vehicle_bound_to_detour ?transport_vehicle ?detour_option)
        (vehicle_segment_supply_attached ?transport_vehicle)
        (not
          (vehicle_available ?transport_vehicle)
        )
      )
  )
  (:action configure_transport_with_detour_supply
    :parameters (?scout_unit - scout_unit ?assault_unit - assault_unit ?map_segment - map_segment ?detour_option - detour_option ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (scout_prepped ?scout_unit)
        (assault_prepped ?assault_unit)
        (unit_associated_segment ?scout_unit ?map_segment)
        (unit_associated_detour ?assault_unit ?detour_option)
        (segment_verified ?map_segment)
        (detour_has_supply ?detour_option)
        (scout_validated ?scout_unit)
        (not
          (assault_validated ?assault_unit)
        )
        (vehicle_available ?transport_vehicle)
      )
    :effect
      (and
        (vehicle_configured ?transport_vehicle)
        (vehicle_bound_to_segment ?transport_vehicle ?map_segment)
        (vehicle_bound_to_detour ?transport_vehicle ?detour_option)
        (vehicle_detour_supply_attached ?transport_vehicle)
        (not
          (vehicle_available ?transport_vehicle)
        )
      )
  )
  (:action configure_transport_with_segment_and_detour_supply
    :parameters (?scout_unit - scout_unit ?assault_unit - assault_unit ?map_segment - map_segment ?detour_option - detour_option ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (scout_prepped ?scout_unit)
        (assault_prepped ?assault_unit)
        (unit_associated_segment ?scout_unit ?map_segment)
        (unit_associated_detour ?assault_unit ?detour_option)
        (segment_has_supply ?map_segment)
        (detour_has_supply ?detour_option)
        (not
          (scout_validated ?scout_unit)
        )
        (not
          (assault_validated ?assault_unit)
        )
        (vehicle_available ?transport_vehicle)
      )
    :effect
      (and
        (vehicle_configured ?transport_vehicle)
        (vehicle_bound_to_segment ?transport_vehicle ?map_segment)
        (vehicle_bound_to_detour ?transport_vehicle ?detour_option)
        (vehicle_segment_supply_attached ?transport_vehicle)
        (vehicle_detour_supply_attached ?transport_vehicle)
        (not
          (vehicle_available ?transport_vehicle)
        )
      )
  )
  (:action mark_vehicle_insert_ready
    :parameters (?transport_vehicle - transport_vehicle ?scout_unit - scout_unit ?route_option - route_option)
    :precondition
      (and
        (vehicle_configured ?transport_vehicle)
        (scout_prepped ?scout_unit)
        (route_bound_to_entity ?scout_unit ?route_option)
        (not
          (vehicle_insert_ready ?transport_vehicle)
        )
      )
    :effect (vehicle_insert_ready ?transport_vehicle)
  )
  (:action deploy_supply_cache
    :parameters (?operation_slot - operation_slot ?supply_cache - supply_cache ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (route_validated_for_entity ?operation_slot)
        (op_slot_assigned_vehicle ?operation_slot ?transport_vehicle)
        (op_slot_has_supply_cache ?operation_slot ?supply_cache)
        (supply_cache_available ?supply_cache)
        (vehicle_configured ?transport_vehicle)
        (vehicle_insert_ready ?transport_vehicle)
        (not
          (supply_cache_deployed ?supply_cache)
        )
      )
    :effect
      (and
        (supply_cache_deployed ?supply_cache)
        (supply_cache_attached_to_vehicle ?supply_cache ?transport_vehicle)
        (not
          (supply_cache_available ?supply_cache)
        )
      )
  )
  (:action unlock_operation_stage1
    :parameters (?operation_slot - operation_slot ?supply_cache - supply_cache ?transport_vehicle - transport_vehicle ?route_option - route_option)
    :precondition
      (and
        (route_validated_for_entity ?operation_slot)
        (op_slot_has_supply_cache ?operation_slot ?supply_cache)
        (supply_cache_deployed ?supply_cache)
        (supply_cache_attached_to_vehicle ?supply_cache ?transport_vehicle)
        (route_bound_to_entity ?operation_slot ?route_option)
        (not
          (vehicle_segment_supply_attached ?transport_vehicle)
        )
        (not
          (op_slot_stage1_ready ?operation_slot)
        )
      )
    :effect (op_slot_stage1_ready ?operation_slot)
  )
  (:action attach_mod_slot_to_operation
    :parameters (?operation_slot - operation_slot ?mod_slot - mod_slot)
    :precondition
      (and
        (route_validated_for_entity ?operation_slot)
        (mod_slot_available ?mod_slot)
        (not
          (op_slot_mod_ready ?operation_slot)
        )
      )
    :effect
      (and
        (op_slot_mod_ready ?operation_slot)
        (op_slot_bound_mod_slot ?operation_slot ?mod_slot)
        (not
          (mod_slot_available ?mod_slot)
        )
      )
  )
  (:action activate_mod_and_unlock_operation
    :parameters (?operation_slot - operation_slot ?supply_cache - supply_cache ?transport_vehicle - transport_vehicle ?route_option - route_option ?mod_slot - mod_slot)
    :precondition
      (and
        (route_validated_for_entity ?operation_slot)
        (op_slot_has_supply_cache ?operation_slot ?supply_cache)
        (supply_cache_deployed ?supply_cache)
        (supply_cache_attached_to_vehicle ?supply_cache ?transport_vehicle)
        (route_bound_to_entity ?operation_slot ?route_option)
        (vehicle_segment_supply_attached ?transport_vehicle)
        (op_slot_mod_ready ?operation_slot)
        (op_slot_bound_mod_slot ?operation_slot ?mod_slot)
        (not
          (op_slot_stage1_ready ?operation_slot)
        )
      )
    :effect
      (and
        (op_slot_stage1_ready ?operation_slot)
        (op_slot_mod_verified ?operation_slot)
      )
  )
  (:action stage_operation_with_equipment_no_vehicle_detour_supply
    :parameters (?operation_slot - operation_slot ?equipment_unit - equipment_unit ?operator - operator ?supply_cache - supply_cache ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (op_slot_stage1_ready ?operation_slot)
        (op_slot_equipped_with_equipment ?operation_slot ?equipment_unit)
        (operator_bound_to_entity ?operation_slot ?operator)
        (op_slot_has_supply_cache ?operation_slot ?supply_cache)
        (supply_cache_attached_to_vehicle ?supply_cache ?transport_vehicle)
        (not
          (vehicle_detour_supply_attached ?transport_vehicle)
        )
        (not
          (op_slot_stage2_ready ?operation_slot)
        )
      )
    :effect (op_slot_stage2_ready ?operation_slot)
  )
  (:action stage_operation_with_equipment_with_vehicle_detour_supply
    :parameters (?operation_slot - operation_slot ?equipment_unit - equipment_unit ?operator - operator ?supply_cache - supply_cache ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (op_slot_stage1_ready ?operation_slot)
        (op_slot_equipped_with_equipment ?operation_slot ?equipment_unit)
        (operator_bound_to_entity ?operation_slot ?operator)
        (op_slot_has_supply_cache ?operation_slot ?supply_cache)
        (supply_cache_attached_to_vehicle ?supply_cache ?transport_vehicle)
        (vehicle_detour_supply_attached ?transport_vehicle)
        (not
          (op_slot_stage2_ready ?operation_slot)
        )
      )
    :effect (op_slot_stage2_ready ?operation_slot)
  )
  (:action stage_operation_with_tactic_no_vehicle_flags
    :parameters (?operation_slot - operation_slot ?tactic_profile - tactic_profile ?supply_cache - supply_cache ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (op_slot_stage2_ready ?operation_slot)
        (op_slot_has_tactic_profile ?operation_slot ?tactic_profile)
        (op_slot_has_supply_cache ?operation_slot ?supply_cache)
        (supply_cache_attached_to_vehicle ?supply_cache ?transport_vehicle)
        (not
          (vehicle_segment_supply_attached ?transport_vehicle)
        )
        (not
          (vehicle_detour_supply_attached ?transport_vehicle)
        )
        (not
          (op_slot_stage3_ready ?operation_slot)
        )
      )
    :effect (op_slot_stage3_ready ?operation_slot)
  )
  (:action stage_operation_with_tactic_and_vehicle_segment_flag
    :parameters (?operation_slot - operation_slot ?tactic_profile - tactic_profile ?supply_cache - supply_cache ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (op_slot_stage2_ready ?operation_slot)
        (op_slot_has_tactic_profile ?operation_slot ?tactic_profile)
        (op_slot_has_supply_cache ?operation_slot ?supply_cache)
        (supply_cache_attached_to_vehicle ?supply_cache ?transport_vehicle)
        (vehicle_segment_supply_attached ?transport_vehicle)
        (not
          (vehicle_detour_supply_attached ?transport_vehicle)
        )
        (not
          (op_slot_stage3_ready ?operation_slot)
        )
      )
    :effect
      (and
        (op_slot_stage3_ready ?operation_slot)
        (op_slot_upgrade_attached ?operation_slot)
      )
  )
  (:action stage_operation_with_tactic_and_vehicle_detour_flag
    :parameters (?operation_slot - operation_slot ?tactic_profile - tactic_profile ?supply_cache - supply_cache ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (op_slot_stage2_ready ?operation_slot)
        (op_slot_has_tactic_profile ?operation_slot ?tactic_profile)
        (op_slot_has_supply_cache ?operation_slot ?supply_cache)
        (supply_cache_attached_to_vehicle ?supply_cache ?transport_vehicle)
        (not
          (vehicle_segment_supply_attached ?transport_vehicle)
        )
        (vehicle_detour_supply_attached ?transport_vehicle)
        (not
          (op_slot_stage3_ready ?operation_slot)
        )
      )
    :effect
      (and
        (op_slot_stage3_ready ?operation_slot)
        (op_slot_upgrade_attached ?operation_slot)
      )
  )
  (:action stage_operation_with_tactic_and_all_vehicle_flags
    :parameters (?operation_slot - operation_slot ?tactic_profile - tactic_profile ?supply_cache - supply_cache ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (op_slot_stage2_ready ?operation_slot)
        (op_slot_has_tactic_profile ?operation_slot ?tactic_profile)
        (op_slot_has_supply_cache ?operation_slot ?supply_cache)
        (supply_cache_attached_to_vehicle ?supply_cache ?transport_vehicle)
        (vehicle_segment_supply_attached ?transport_vehicle)
        (vehicle_detour_supply_attached ?transport_vehicle)
        (not
          (op_slot_stage3_ready ?operation_slot)
        )
      )
    :effect
      (and
        (op_slot_stage3_ready ?operation_slot)
        (op_slot_upgrade_attached ?operation_slot)
      )
  )
  (:action activate_operation_slot_stage
    :parameters (?operation_slot - operation_slot)
    :precondition
      (and
        (op_slot_stage3_ready ?operation_slot)
        (not
          (op_slot_upgrade_attached ?operation_slot)
        )
        (not
          (activation_committed ?operation_slot)
        )
      )
    :effect
      (and
        (activation_committed ?operation_slot)
        (activated ?operation_slot)
      )
  )
  (:action attach_upgrade_module_to_operation
    :parameters (?operation_slot - operation_slot ?upgrade_module - upgrade_module)
    :precondition
      (and
        (op_slot_stage3_ready ?operation_slot)
        (op_slot_upgrade_attached ?operation_slot)
        (upgrade_module_available ?upgrade_module)
      )
    :effect
      (and
        (op_slot_has_upgrade_module ?operation_slot ?upgrade_module)
        (not
          (upgrade_module_available ?upgrade_module)
        )
      )
  )
  (:action finalize_team_assignment
    :parameters (?operation_slot - operation_slot ?scout_unit - scout_unit ?assault_unit - assault_unit ?route_option - route_option ?upgrade_module - upgrade_module)
    :precondition
      (and
        (op_slot_stage3_ready ?operation_slot)
        (op_slot_upgrade_attached ?operation_slot)
        (op_slot_has_upgrade_module ?operation_slot ?upgrade_module)
        (op_slot_assigned_scout ?operation_slot ?scout_unit)
        (op_slot_assigned_assault ?operation_slot ?assault_unit)
        (scout_validated ?scout_unit)
        (assault_validated ?assault_unit)
        (route_bound_to_entity ?operation_slot ?route_option)
        (not
          (op_slot_team_finalized ?operation_slot)
        )
      )
    :effect (op_slot_team_finalized ?operation_slot)
  )
  (:action finalize_and_activate_operation
    :parameters (?operation_slot - operation_slot)
    :precondition
      (and
        (op_slot_stage3_ready ?operation_slot)
        (op_slot_team_finalized ?operation_slot)
        (not
          (activation_committed ?operation_slot)
        )
      )
    :effect
      (and
        (activation_committed ?operation_slot)
        (activated ?operation_slot)
      )
  )
  (:action attach_intel_to_operation
    :parameters (?operation_slot - operation_slot ?intel_packet - intel_packet ?route_option - route_option)
    :precondition
      (and
        (route_validated_for_entity ?operation_slot)
        (route_bound_to_entity ?operation_slot ?route_option)
        (intel_packet_available ?intel_packet)
        (op_slot_has_intel_packet ?operation_slot ?intel_packet)
        (not
          (op_slot_intel_attached ?operation_slot)
        )
      )
    :effect
      (and
        (op_slot_intel_attached ?operation_slot)
        (not
          (intel_packet_available ?intel_packet)
        )
      )
  )
  (:action process_intel_with_operator
    :parameters (?operation_slot - operation_slot ?operator - operator)
    :precondition
      (and
        (op_slot_intel_attached ?operation_slot)
        (operator_bound_to_entity ?operation_slot ?operator)
        (not
          (op_slot_intel_processed ?operation_slot)
        )
      )
    :effect (op_slot_intel_processed ?operation_slot)
  )
  (:action apply_tactic_profile_to_operation
    :parameters (?operation_slot - operation_slot ?tactic_profile - tactic_profile)
    :precondition
      (and
        (op_slot_intel_processed ?operation_slot)
        (op_slot_has_tactic_profile ?operation_slot ?tactic_profile)
        (not
          (op_slot_tactic_set ?operation_slot)
        )
      )
    :effect (op_slot_tactic_set ?operation_slot)
  )
  (:action finalize_activation_via_tactics
    :parameters (?operation_slot - operation_slot)
    :precondition
      (and
        (op_slot_tactic_set ?operation_slot)
        (not
          (activation_committed ?operation_slot)
        )
      )
    :effect
      (and
        (activation_committed ?operation_slot)
        (activated ?operation_slot)
      )
  )
  (:action activate_scout_unit_via_vehicle
    :parameters (?scout_unit - scout_unit ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (scout_prepped ?scout_unit)
        (scout_validated ?scout_unit)
        (vehicle_configured ?transport_vehicle)
        (vehicle_insert_ready ?transport_vehicle)
        (not
          (activated ?scout_unit)
        )
      )
    :effect (activated ?scout_unit)
  )
  (:action activate_assault_unit_via_vehicle
    :parameters (?assault_unit - assault_unit ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (assault_prepped ?assault_unit)
        (assault_validated ?assault_unit)
        (vehicle_configured ?transport_vehicle)
        (vehicle_insert_ready ?transport_vehicle)
        (not
          (activated ?assault_unit)
        )
      )
    :effect (activated ?assault_unit)
  )
  (:action apply_recovery_action_to_prep_region
    :parameters (?region - region ?checkpoint_marker - checkpoint_marker ?route_option - route_option)
    :precondition
      (and
        (activated ?region)
        (route_bound_to_entity ?region ?route_option)
        (checkpoint_marker_available ?checkpoint_marker)
        (not
          (entity_prepped ?region)
        )
      )
    :effect
      (and
        (entity_prepped ?region)
        (region_has_checkpoint ?region ?checkpoint_marker)
        (not
          (checkpoint_marker_available ?checkpoint_marker)
        )
      )
  )
  (:action execute_final_unblock_with_scout
    :parameters (?scout_unit - scout_unit ?asset_unit - asset_unit ?checkpoint_marker - checkpoint_marker)
    :precondition
      (and
        (entity_prepped ?scout_unit)
        (asset_bound_to_entity ?scout_unit ?asset_unit)
        (region_has_checkpoint ?scout_unit ?checkpoint_marker)
        (not
          (region_unblocked ?scout_unit)
        )
      )
    :effect
      (and
        (region_unblocked ?scout_unit)
        (asset_available ?asset_unit)
        (checkpoint_marker_available ?checkpoint_marker)
      )
  )
  (:action execute_final_unblock_with_assault
    :parameters (?assault_unit - assault_unit ?asset_unit - asset_unit ?checkpoint_marker - checkpoint_marker)
    :precondition
      (and
        (entity_prepped ?assault_unit)
        (asset_bound_to_entity ?assault_unit ?asset_unit)
        (region_has_checkpoint ?assault_unit ?checkpoint_marker)
        (not
          (region_unblocked ?assault_unit)
        )
      )
    :effect
      (and
        (region_unblocked ?assault_unit)
        (asset_available ?asset_unit)
        (checkpoint_marker_available ?checkpoint_marker)
      )
  )
  (:action execute_final_unblock_with_operation_slot
    :parameters (?operation_slot - operation_slot ?asset_unit - asset_unit ?checkpoint_marker - checkpoint_marker)
    :precondition
      (and
        (entity_prepped ?operation_slot)
        (asset_bound_to_entity ?operation_slot ?asset_unit)
        (region_has_checkpoint ?operation_slot ?checkpoint_marker)
        (not
          (region_unblocked ?operation_slot)
        )
      )
    :effect
      (and
        (region_unblocked ?operation_slot)
        (asset_available ?asset_unit)
        (checkpoint_marker_available ?checkpoint_marker)
      )
  )
)

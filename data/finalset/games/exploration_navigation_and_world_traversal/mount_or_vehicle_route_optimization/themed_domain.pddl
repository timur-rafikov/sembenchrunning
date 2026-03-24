(define (domain mount_route_optimization)
  (:requirements :strips :typing :negative-preconditions)
  (:types base_object - object game_entity_group - base_object map_component_group - base_object route_component_group - base_object operational_context - base_object expedition_plan - operational_context mount_option - game_entity_group waypoint_marker - game_entity_group support_asset - game_entity_group special_checkpoint - game_entity_group upgrade_module - game_entity_group return_marker - game_entity_group performance_modifier - game_entity_group priority_marker - game_entity_group consumable_token - map_component_group coverage_beacon - map_component_group area_trigger - map_component_group node_point_a - route_component_group node_point_b - route_component_group route_token - route_component_group sector_group_a - expedition_plan sector_group_b - expedition_plan sector_node_a - sector_group_a sector_node_b - sector_group_a planner_unit - sector_group_b)

  (:predicates
    (entity_active ?expedition_plan - expedition_plan)
    (entity_confirmed ?expedition_plan - expedition_plan)
    (entity_has_mount ?expedition_plan - expedition_plan)
    (return_finalized ?expedition_plan - expedition_plan)
    (marked_completed ?expedition_plan - expedition_plan)
    (return_marker_used ?expedition_plan - expedition_plan)
    (mount_available ?mount_option - mount_option)
    (entity_assigned_mount ?expedition_plan - expedition_plan ?mount_option - mount_option)
    (waypoint_available ?waypoint_marker - waypoint_marker)
    (entity_has_waypoint ?expedition_plan - expedition_plan ?waypoint_marker - waypoint_marker)
    (support_available ?support_asset - support_asset)
    (entity_has_support ?expedition_plan - expedition_plan ?support_asset - support_asset)
    (consumable_available ?consumable_token - consumable_token)
    (consumable_assigned_to_sector_a ?sector_node_a - sector_node_a ?consumable_token - consumable_token)
    (consumable_assigned_to_sector_b ?sector_node_b - sector_node_b ?consumable_token - consumable_token)
    (sector_a_has_point ?sector_node_a - sector_node_a ?node_point_a - node_point_a)
    (point_a_scouted ?node_point_a - node_point_a)
    (point_a_consumable_marked ?node_point_a - node_point_a)
    (sector_a_ready ?sector_node_a - sector_node_a)
    (sector_b_has_point ?sector_node_b - sector_node_b ?node_point_b - node_point_b)
    (point_b_scouted ?node_point_b - node_point_b)
    (point_b_consumable_marked ?node_point_b - node_point_b)
    (sector_b_ready ?sector_node_b - sector_node_b)
    (route_slot_available ?route_token - route_token)
    (route_token_created ?route_token - route_token)
    (route_has_point_a ?route_token - route_token ?node_point_a - node_point_a)
    (route_has_point_b ?route_token - route_token ?node_point_b - node_point_b)
    (route_variant_a_consumable_used ?route_token - route_token)
    (route_variant_b_consumable_used ?route_token - route_token)
    (route_validated_for_beacon ?route_token - route_token)
    (planner_covers_sector_a ?planner_unit - planner_unit ?sector_node_a - sector_node_a)
    (planner_covers_sector_b ?planner_unit - planner_unit ?sector_node_b - sector_node_b)
    (planner_linked_route ?planner_unit - planner_unit ?route_token - route_token)
    (coverage_beacon_available ?coverage_beacon - coverage_beacon)
    (planner_has_beacon ?planner_unit - planner_unit ?coverage_beacon - coverage_beacon)
    (beacon_activated ?coverage_beacon - coverage_beacon)
    (beacon_linked_to_route ?coverage_beacon - coverage_beacon ?route_token - route_token)
    (planner_beacon_integrated ?planner_unit - planner_unit)
    (planner_modifier_attached ?planner_unit - planner_unit)
    (planner_priority_confirmed ?planner_unit - planner_unit)
    (checkpoint_reserved ?planner_unit - planner_unit)
    (checkpoint_activated ?planner_unit - planner_unit)
    (upgrade_slot_ready ?planner_unit - planner_unit)
    (evaluation_passed ?planner_unit - planner_unit)
    (area_trigger_available ?area_trigger - area_trigger)
    (planner_assigned_area_trigger ?planner_unit - planner_unit ?area_trigger - area_trigger)
    (checkpoint_engaged ?planner_unit - planner_unit)
    (checkpoint_prepared ?planner_unit - planner_unit)
    (checkpoint_finalised ?planner_unit - planner_unit)
    (special_checkpoint_available ?special_checkpoint - special_checkpoint)
    (planner_reserved_checkpoint ?planner_unit - planner_unit ?special_checkpoint - special_checkpoint)
    (upgrade_module_available ?upgrade_module - upgrade_module)
    (planner_has_upgrade ?planner_unit - planner_unit ?upgrade_module - upgrade_module)
    (performance_modifier_available ?performance_modifier - performance_modifier)
    (planner_has_performance_modifier ?planner_unit - planner_unit ?performance_modifier - performance_modifier)
    (priority_marker_available ?priority_marker - priority_marker)
    (planner_has_priority_marker ?planner_unit - planner_unit ?priority_marker - priority_marker)
    (return_marker_available ?return_marker - return_marker)
    (entity_has_return_marker ?expedition_plan - expedition_plan ?return_marker - return_marker)
    (sector_a_scan_complete ?sector_node_a - sector_node_a)
    (sector_b_scan_complete ?sector_node_b - sector_node_b)
    (coverage_consolidated ?planner_unit - planner_unit)
  )
  (:action initialize_entity_plan
    :parameters (?expedition_plan - expedition_plan)
    :precondition
      (and
        (not
          (entity_active ?expedition_plan)
        )
        (not
          (return_finalized ?expedition_plan)
        )
      )
    :effect (entity_active ?expedition_plan)
  )
  (:action assign_mount_to_entity
    :parameters (?expedition_plan - expedition_plan ?mount_option - mount_option)
    :precondition
      (and
        (entity_active ?expedition_plan)
        (not
          (entity_has_mount ?expedition_plan)
        )
        (mount_available ?mount_option)
      )
    :effect
      (and
        (entity_has_mount ?expedition_plan)
        (entity_assigned_mount ?expedition_plan ?mount_option)
        (not
          (mount_available ?mount_option)
        )
      )
  )
  (:action attach_waypoint_to_entity
    :parameters (?expedition_plan - expedition_plan ?waypoint_marker - waypoint_marker)
    :precondition
      (and
        (entity_active ?expedition_plan)
        (entity_has_mount ?expedition_plan)
        (waypoint_available ?waypoint_marker)
      )
    :effect
      (and
        (entity_has_waypoint ?expedition_plan ?waypoint_marker)
        (not
          (waypoint_available ?waypoint_marker)
        )
      )
  )
  (:action confirm_waypoint_attachment
    :parameters (?expedition_plan - expedition_plan ?waypoint_marker - waypoint_marker)
    :precondition
      (and
        (entity_active ?expedition_plan)
        (entity_has_mount ?expedition_plan)
        (entity_has_waypoint ?expedition_plan ?waypoint_marker)
        (not
          (entity_confirmed ?expedition_plan)
        )
      )
    :effect (entity_confirmed ?expedition_plan)
  )
  (:action release_waypoint_from_entity
    :parameters (?expedition_plan - expedition_plan ?waypoint_marker - waypoint_marker)
    :precondition
      (and
        (entity_has_waypoint ?expedition_plan ?waypoint_marker)
      )
    :effect
      (and
        (waypoint_available ?waypoint_marker)
        (not
          (entity_has_waypoint ?expedition_plan ?waypoint_marker)
        )
      )
  )
  (:action assign_support_to_entity
    :parameters (?expedition_plan - expedition_plan ?support_asset - support_asset)
    :precondition
      (and
        (entity_confirmed ?expedition_plan)
        (support_available ?support_asset)
      )
    :effect
      (and
        (entity_has_support ?expedition_plan ?support_asset)
        (not
          (support_available ?support_asset)
        )
      )
  )
  (:action release_support_from_entity
    :parameters (?expedition_plan - expedition_plan ?support_asset - support_asset)
    :precondition
      (and
        (entity_has_support ?expedition_plan ?support_asset)
      )
    :effect
      (and
        (support_available ?support_asset)
        (not
          (entity_has_support ?expedition_plan ?support_asset)
        )
      )
  )
  (:action attach_performance_modifier_to_planner
    :parameters (?planner_unit - planner_unit ?performance_modifier - performance_modifier)
    :precondition
      (and
        (entity_confirmed ?planner_unit)
        (performance_modifier_available ?performance_modifier)
      )
    :effect
      (and
        (planner_has_performance_modifier ?planner_unit ?performance_modifier)
        (not
          (performance_modifier_available ?performance_modifier)
        )
      )
  )
  (:action detach_performance_modifier_from_planner
    :parameters (?planner_unit - planner_unit ?performance_modifier - performance_modifier)
    :precondition
      (and
        (planner_has_performance_modifier ?planner_unit ?performance_modifier)
      )
    :effect
      (and
        (performance_modifier_available ?performance_modifier)
        (not
          (planner_has_performance_modifier ?planner_unit ?performance_modifier)
        )
      )
  )
  (:action attach_priority_marker_to_planner
    :parameters (?planner_unit - planner_unit ?priority_marker - priority_marker)
    :precondition
      (and
        (entity_confirmed ?planner_unit)
        (priority_marker_available ?priority_marker)
      )
    :effect
      (and
        (planner_has_priority_marker ?planner_unit ?priority_marker)
        (not
          (priority_marker_available ?priority_marker)
        )
      )
  )
  (:action detach_priority_marker_from_planner
    :parameters (?planner_unit - planner_unit ?priority_marker - priority_marker)
    :precondition
      (and
        (planner_has_priority_marker ?planner_unit ?priority_marker)
      )
    :effect
      (and
        (priority_marker_available ?priority_marker)
        (not
          (planner_has_priority_marker ?planner_unit ?priority_marker)
        )
      )
  )
  (:action scout_node_point_a
    :parameters (?sector_node_a - sector_node_a ?node_point_a - node_point_a ?waypoint_marker - waypoint_marker)
    :precondition
      (and
        (entity_confirmed ?sector_node_a)
        (entity_has_waypoint ?sector_node_a ?waypoint_marker)
        (sector_a_has_point ?sector_node_a ?node_point_a)
        (not
          (point_a_scouted ?node_point_a)
        )
        (not
          (point_a_consumable_marked ?node_point_a)
        )
      )
    :effect (point_a_scouted ?node_point_a)
  )
  (:action confirm_sector_a_point_with_support
    :parameters (?sector_node_a - sector_node_a ?node_point_a - node_point_a ?support_asset - support_asset)
    :precondition
      (and
        (entity_confirmed ?sector_node_a)
        (entity_has_support ?sector_node_a ?support_asset)
        (sector_a_has_point ?sector_node_a ?node_point_a)
        (point_a_scouted ?node_point_a)
        (not
          (sector_a_scan_complete ?sector_node_a)
        )
      )
    :effect
      (and
        (sector_a_scan_complete ?sector_node_a)
        (sector_a_ready ?sector_node_a)
      )
  )
  (:action use_consumable_on_sector_a_point
    :parameters (?sector_node_a - sector_node_a ?node_point_a - node_point_a ?consumable_token - consumable_token)
    :precondition
      (and
        (entity_confirmed ?sector_node_a)
        (sector_a_has_point ?sector_node_a ?node_point_a)
        (consumable_available ?consumable_token)
        (not
          (sector_a_scan_complete ?sector_node_a)
        )
      )
    :effect
      (and
        (point_a_consumable_marked ?node_point_a)
        (sector_a_scan_complete ?sector_node_a)
        (consumable_assigned_to_sector_a ?sector_node_a ?consumable_token)
        (not
          (consumable_available ?consumable_token)
        )
      )
  )
  (:action finalize_sector_a_point_with_consumable
    :parameters (?sector_node_a - sector_node_a ?node_point_a - node_point_a ?waypoint_marker - waypoint_marker ?consumable_token - consumable_token)
    :precondition
      (and
        (entity_confirmed ?sector_node_a)
        (entity_has_waypoint ?sector_node_a ?waypoint_marker)
        (sector_a_has_point ?sector_node_a ?node_point_a)
        (point_a_consumable_marked ?node_point_a)
        (consumable_assigned_to_sector_a ?sector_node_a ?consumable_token)
        (not
          (sector_a_ready ?sector_node_a)
        )
      )
    :effect
      (and
        (point_a_scouted ?node_point_a)
        (sector_a_ready ?sector_node_a)
        (consumable_available ?consumable_token)
        (not
          (consumable_assigned_to_sector_a ?sector_node_a ?consumable_token)
        )
      )
  )
  (:action scout_node_point_b
    :parameters (?sector_node_b - sector_node_b ?node_point_b - node_point_b ?waypoint_marker - waypoint_marker)
    :precondition
      (and
        (entity_confirmed ?sector_node_b)
        (entity_has_waypoint ?sector_node_b ?waypoint_marker)
        (sector_b_has_point ?sector_node_b ?node_point_b)
        (not
          (point_b_scouted ?node_point_b)
        )
        (not
          (point_b_consumable_marked ?node_point_b)
        )
      )
    :effect (point_b_scouted ?node_point_b)
  )
  (:action confirm_sector_b_point_with_support
    :parameters (?sector_node_b - sector_node_b ?node_point_b - node_point_b ?support_asset - support_asset)
    :precondition
      (and
        (entity_confirmed ?sector_node_b)
        (entity_has_support ?sector_node_b ?support_asset)
        (sector_b_has_point ?sector_node_b ?node_point_b)
        (point_b_scouted ?node_point_b)
        (not
          (sector_b_scan_complete ?sector_node_b)
        )
      )
    :effect
      (and
        (sector_b_scan_complete ?sector_node_b)
        (sector_b_ready ?sector_node_b)
      )
  )
  (:action use_consumable_on_sector_b_point
    :parameters (?sector_node_b - sector_node_b ?node_point_b - node_point_b ?consumable_token - consumable_token)
    :precondition
      (and
        (entity_confirmed ?sector_node_b)
        (sector_b_has_point ?sector_node_b ?node_point_b)
        (consumable_available ?consumable_token)
        (not
          (sector_b_scan_complete ?sector_node_b)
        )
      )
    :effect
      (and
        (point_b_consumable_marked ?node_point_b)
        (sector_b_scan_complete ?sector_node_b)
        (consumable_assigned_to_sector_b ?sector_node_b ?consumable_token)
        (not
          (consumable_available ?consumable_token)
        )
      )
  )
  (:action finalize_sector_b_point_with_consumable
    :parameters (?sector_node_b - sector_node_b ?node_point_b - node_point_b ?waypoint_marker - waypoint_marker ?consumable_token - consumable_token)
    :precondition
      (and
        (entity_confirmed ?sector_node_b)
        (entity_has_waypoint ?sector_node_b ?waypoint_marker)
        (sector_b_has_point ?sector_node_b ?node_point_b)
        (point_b_consumable_marked ?node_point_b)
        (consumable_assigned_to_sector_b ?sector_node_b ?consumable_token)
        (not
          (sector_b_ready ?sector_node_b)
        )
      )
    :effect
      (and
        (point_b_scouted ?node_point_b)
        (sector_b_ready ?sector_node_b)
        (consumable_available ?consumable_token)
        (not
          (consumable_assigned_to_sector_b ?sector_node_b ?consumable_token)
        )
      )
  )
  (:action synthesize_route_token_from_sectors
    :parameters (?sector_node_a - sector_node_a ?sector_node_b - sector_node_b ?node_point_a - node_point_a ?node_point_b - node_point_b ?route_token - route_token)
    :precondition
      (and
        (sector_a_scan_complete ?sector_node_a)
        (sector_b_scan_complete ?sector_node_b)
        (sector_a_has_point ?sector_node_a ?node_point_a)
        (sector_b_has_point ?sector_node_b ?node_point_b)
        (point_a_scouted ?node_point_a)
        (point_b_scouted ?node_point_b)
        (sector_a_ready ?sector_node_a)
        (sector_b_ready ?sector_node_b)
        (route_slot_available ?route_token)
      )
    :effect
      (and
        (route_token_created ?route_token)
        (route_has_point_a ?route_token ?node_point_a)
        (route_has_point_b ?route_token ?node_point_b)
        (not
          (route_slot_available ?route_token)
        )
      )
  )
  (:action synthesize_route_token_variant_a_consumable
    :parameters (?sector_node_a - sector_node_a ?sector_node_b - sector_node_b ?node_point_a - node_point_a ?node_point_b - node_point_b ?route_token - route_token)
    :precondition
      (and
        (sector_a_scan_complete ?sector_node_a)
        (sector_b_scan_complete ?sector_node_b)
        (sector_a_has_point ?sector_node_a ?node_point_a)
        (sector_b_has_point ?sector_node_b ?node_point_b)
        (point_a_consumable_marked ?node_point_a)
        (point_b_scouted ?node_point_b)
        (not
          (sector_a_ready ?sector_node_a)
        )
        (sector_b_ready ?sector_node_b)
        (route_slot_available ?route_token)
      )
    :effect
      (and
        (route_token_created ?route_token)
        (route_has_point_a ?route_token ?node_point_a)
        (route_has_point_b ?route_token ?node_point_b)
        (route_variant_a_consumable_used ?route_token)
        (not
          (route_slot_available ?route_token)
        )
      )
  )
  (:action synthesize_route_token_variant_b_consumable
    :parameters (?sector_node_a - sector_node_a ?sector_node_b - sector_node_b ?node_point_a - node_point_a ?node_point_b - node_point_b ?route_token - route_token)
    :precondition
      (and
        (sector_a_scan_complete ?sector_node_a)
        (sector_b_scan_complete ?sector_node_b)
        (sector_a_has_point ?sector_node_a ?node_point_a)
        (sector_b_has_point ?sector_node_b ?node_point_b)
        (point_a_scouted ?node_point_a)
        (point_b_consumable_marked ?node_point_b)
        (sector_a_ready ?sector_node_a)
        (not
          (sector_b_ready ?sector_node_b)
        )
        (route_slot_available ?route_token)
      )
    :effect
      (and
        (route_token_created ?route_token)
        (route_has_point_a ?route_token ?node_point_a)
        (route_has_point_b ?route_token ?node_point_b)
        (route_variant_b_consumable_used ?route_token)
        (not
          (route_slot_available ?route_token)
        )
      )
  )
  (:action synthesize_route_token_variant_both_consumables
    :parameters (?sector_node_a - sector_node_a ?sector_node_b - sector_node_b ?node_point_a - node_point_a ?node_point_b - node_point_b ?route_token - route_token)
    :precondition
      (and
        (sector_a_scan_complete ?sector_node_a)
        (sector_b_scan_complete ?sector_node_b)
        (sector_a_has_point ?sector_node_a ?node_point_a)
        (sector_b_has_point ?sector_node_b ?node_point_b)
        (point_a_consumable_marked ?node_point_a)
        (point_b_consumable_marked ?node_point_b)
        (not
          (sector_a_ready ?sector_node_a)
        )
        (not
          (sector_b_ready ?sector_node_b)
        )
        (route_slot_available ?route_token)
      )
    :effect
      (and
        (route_token_created ?route_token)
        (route_has_point_a ?route_token ?node_point_a)
        (route_has_point_b ?route_token ?node_point_b)
        (route_variant_a_consumable_used ?route_token)
        (route_variant_b_consumable_used ?route_token)
        (not
          (route_slot_available ?route_token)
        )
      )
  )
  (:action validate_route_token_for_beacon_inclusion
    :parameters (?route_token - route_token ?sector_node_a - sector_node_a ?waypoint_marker - waypoint_marker)
    :precondition
      (and
        (route_token_created ?route_token)
        (sector_a_scan_complete ?sector_node_a)
        (entity_has_waypoint ?sector_node_a ?waypoint_marker)
        (not
          (route_validated_for_beacon ?route_token)
        )
      )
    :effect (route_validated_for_beacon ?route_token)
  )
  (:action integrate_coverage_beacon
    :parameters (?planner_unit - planner_unit ?coverage_beacon - coverage_beacon ?route_token - route_token)
    :precondition
      (and
        (entity_confirmed ?planner_unit)
        (planner_linked_route ?planner_unit ?route_token)
        (planner_has_beacon ?planner_unit ?coverage_beacon)
        (coverage_beacon_available ?coverage_beacon)
        (route_token_created ?route_token)
        (route_validated_for_beacon ?route_token)
        (not
          (beacon_activated ?coverage_beacon)
        )
      )
    :effect
      (and
        (beacon_activated ?coverage_beacon)
        (beacon_linked_to_route ?coverage_beacon ?route_token)
        (not
          (coverage_beacon_available ?coverage_beacon)
        )
      )
  )
  (:action consolidate_beacon_into_planner
    :parameters (?planner_unit - planner_unit ?coverage_beacon - coverage_beacon ?route_token - route_token ?waypoint_marker - waypoint_marker)
    :precondition
      (and
        (entity_confirmed ?planner_unit)
        (planner_has_beacon ?planner_unit ?coverage_beacon)
        (beacon_activated ?coverage_beacon)
        (beacon_linked_to_route ?coverage_beacon ?route_token)
        (entity_has_waypoint ?planner_unit ?waypoint_marker)
        (not
          (route_variant_a_consumable_used ?route_token)
        )
        (not
          (planner_beacon_integrated ?planner_unit)
        )
      )
    :effect (planner_beacon_integrated ?planner_unit)
  )
  (:action reserve_special_checkpoint
    :parameters (?planner_unit - planner_unit ?special_checkpoint - special_checkpoint)
    :precondition
      (and
        (entity_confirmed ?planner_unit)
        (special_checkpoint_available ?special_checkpoint)
        (not
          (checkpoint_reserved ?planner_unit)
        )
      )
    :effect
      (and
        (checkpoint_reserved ?planner_unit)
        (planner_reserved_checkpoint ?planner_unit ?special_checkpoint)
        (not
          (special_checkpoint_available ?special_checkpoint)
        )
      )
  )
  (:action activate_reserved_checkpoint
    :parameters (?planner_unit - planner_unit ?coverage_beacon - coverage_beacon ?route_token - route_token ?waypoint_marker - waypoint_marker ?special_checkpoint - special_checkpoint)
    :precondition
      (and
        (entity_confirmed ?planner_unit)
        (planner_has_beacon ?planner_unit ?coverage_beacon)
        (beacon_activated ?coverage_beacon)
        (beacon_linked_to_route ?coverage_beacon ?route_token)
        (entity_has_waypoint ?planner_unit ?waypoint_marker)
        (route_variant_a_consumable_used ?route_token)
        (checkpoint_reserved ?planner_unit)
        (planner_reserved_checkpoint ?planner_unit ?special_checkpoint)
        (not
          (planner_beacon_integrated ?planner_unit)
        )
      )
    :effect
      (and
        (planner_beacon_integrated ?planner_unit)
        (checkpoint_activated ?planner_unit)
      )
  )
  (:action apply_performance_modifier_to_planner
    :parameters (?planner_unit - planner_unit ?performance_modifier - performance_modifier ?support_asset - support_asset ?coverage_beacon - coverage_beacon ?route_token - route_token)
    :precondition
      (and
        (planner_beacon_integrated ?planner_unit)
        (planner_has_performance_modifier ?planner_unit ?performance_modifier)
        (entity_has_support ?planner_unit ?support_asset)
        (planner_has_beacon ?planner_unit ?coverage_beacon)
        (beacon_linked_to_route ?coverage_beacon ?route_token)
        (not
          (route_variant_b_consumable_used ?route_token)
        )
        (not
          (planner_modifier_attached ?planner_unit)
        )
      )
    :effect (planner_modifier_attached ?planner_unit)
  )
  (:action apply_performance_modifier_to_planner_variant
    :parameters (?planner_unit - planner_unit ?performance_modifier - performance_modifier ?support_asset - support_asset ?coverage_beacon - coverage_beacon ?route_token - route_token)
    :precondition
      (and
        (planner_beacon_integrated ?planner_unit)
        (planner_has_performance_modifier ?planner_unit ?performance_modifier)
        (entity_has_support ?planner_unit ?support_asset)
        (planner_has_beacon ?planner_unit ?coverage_beacon)
        (beacon_linked_to_route ?coverage_beacon ?route_token)
        (route_variant_b_consumable_used ?route_token)
        (not
          (planner_modifier_attached ?planner_unit)
        )
      )
    :effect (planner_modifier_attached ?planner_unit)
  )
  (:action activate_priority_marker_phase1
    :parameters (?planner_unit - planner_unit ?priority_marker - priority_marker ?coverage_beacon - coverage_beacon ?route_token - route_token)
    :precondition
      (and
        (planner_modifier_attached ?planner_unit)
        (planner_has_priority_marker ?planner_unit ?priority_marker)
        (planner_has_beacon ?planner_unit ?coverage_beacon)
        (beacon_linked_to_route ?coverage_beacon ?route_token)
        (not
          (route_variant_a_consumable_used ?route_token)
        )
        (not
          (route_variant_b_consumable_used ?route_token)
        )
        (not
          (planner_priority_confirmed ?planner_unit)
        )
      )
    :effect (planner_priority_confirmed ?planner_unit)
  )
  (:action activate_priority_marker_phase2
    :parameters (?planner_unit - planner_unit ?priority_marker - priority_marker ?coverage_beacon - coverage_beacon ?route_token - route_token)
    :precondition
      (and
        (planner_modifier_attached ?planner_unit)
        (planner_has_priority_marker ?planner_unit ?priority_marker)
        (planner_has_beacon ?planner_unit ?coverage_beacon)
        (beacon_linked_to_route ?coverage_beacon ?route_token)
        (route_variant_a_consumable_used ?route_token)
        (not
          (route_variant_b_consumable_used ?route_token)
        )
        (not
          (planner_priority_confirmed ?planner_unit)
        )
      )
    :effect
      (and
        (planner_priority_confirmed ?planner_unit)
        (upgrade_slot_ready ?planner_unit)
      )
  )
  (:action activate_priority_marker_phase3
    :parameters (?planner_unit - planner_unit ?priority_marker - priority_marker ?coverage_beacon - coverage_beacon ?route_token - route_token)
    :precondition
      (and
        (planner_modifier_attached ?planner_unit)
        (planner_has_priority_marker ?planner_unit ?priority_marker)
        (planner_has_beacon ?planner_unit ?coverage_beacon)
        (beacon_linked_to_route ?coverage_beacon ?route_token)
        (not
          (route_variant_a_consumable_used ?route_token)
        )
        (route_variant_b_consumable_used ?route_token)
        (not
          (planner_priority_confirmed ?planner_unit)
        )
      )
    :effect
      (and
        (planner_priority_confirmed ?planner_unit)
        (upgrade_slot_ready ?planner_unit)
      )
  )
  (:action activate_priority_marker_phase4
    :parameters (?planner_unit - planner_unit ?priority_marker - priority_marker ?coverage_beacon - coverage_beacon ?route_token - route_token)
    :precondition
      (and
        (planner_modifier_attached ?planner_unit)
        (planner_has_priority_marker ?planner_unit ?priority_marker)
        (planner_has_beacon ?planner_unit ?coverage_beacon)
        (beacon_linked_to_route ?coverage_beacon ?route_token)
        (route_variant_a_consumable_used ?route_token)
        (route_variant_b_consumable_used ?route_token)
        (not
          (planner_priority_confirmed ?planner_unit)
        )
      )
    :effect
      (and
        (planner_priority_confirmed ?planner_unit)
        (upgrade_slot_ready ?planner_unit)
      )
  )
  (:action finalize_planner_coverage_without_upgrade
    :parameters (?planner_unit - planner_unit)
    :precondition
      (and
        (planner_priority_confirmed ?planner_unit)
        (not
          (upgrade_slot_ready ?planner_unit)
        )
        (not
          (coverage_consolidated ?planner_unit)
        )
      )
    :effect
      (and
        (coverage_consolidated ?planner_unit)
        (marked_completed ?planner_unit)
      )
  )
  (:action apply_upgrade_to_planner
    :parameters (?planner_unit - planner_unit ?upgrade_module - upgrade_module)
    :precondition
      (and
        (planner_priority_confirmed ?planner_unit)
        (upgrade_slot_ready ?planner_unit)
        (upgrade_module_available ?upgrade_module)
      )
    :effect
      (and
        (planner_has_upgrade ?planner_unit ?upgrade_module)
        (not
          (upgrade_module_available ?upgrade_module)
        )
      )
  )
  (:action evaluate_planner_for_completion
    :parameters (?planner_unit - planner_unit ?sector_node_a - sector_node_a ?sector_node_b - sector_node_b ?waypoint_marker - waypoint_marker ?upgrade_module - upgrade_module)
    :precondition
      (and
        (planner_priority_confirmed ?planner_unit)
        (upgrade_slot_ready ?planner_unit)
        (planner_has_upgrade ?planner_unit ?upgrade_module)
        (planner_covers_sector_a ?planner_unit ?sector_node_a)
        (planner_covers_sector_b ?planner_unit ?sector_node_b)
        (sector_a_ready ?sector_node_a)
        (sector_b_ready ?sector_node_b)
        (entity_has_waypoint ?planner_unit ?waypoint_marker)
        (not
          (evaluation_passed ?planner_unit)
        )
      )
    :effect (evaluation_passed ?planner_unit)
  )
  (:action finalize_planner_coverage_after_evaluation
    :parameters (?planner_unit - planner_unit)
    :precondition
      (and
        (planner_priority_confirmed ?planner_unit)
        (evaluation_passed ?planner_unit)
        (not
          (coverage_consolidated ?planner_unit)
        )
      )
    :effect
      (and
        (coverage_consolidated ?planner_unit)
        (marked_completed ?planner_unit)
      )
  )
  (:action engage_area_trigger_checkpoint
    :parameters (?planner_unit - planner_unit ?area_trigger - area_trigger ?waypoint_marker - waypoint_marker)
    :precondition
      (and
        (entity_confirmed ?planner_unit)
        (entity_has_waypoint ?planner_unit ?waypoint_marker)
        (area_trigger_available ?area_trigger)
        (planner_assigned_area_trigger ?planner_unit ?area_trigger)
        (not
          (checkpoint_engaged ?planner_unit)
        )
      )
    :effect
      (and
        (checkpoint_engaged ?planner_unit)
        (not
          (area_trigger_available ?area_trigger)
        )
      )
  )
  (:action prepare_checkpoint_with_support
    :parameters (?planner_unit - planner_unit ?support_asset - support_asset)
    :precondition
      (and
        (checkpoint_engaged ?planner_unit)
        (entity_has_support ?planner_unit ?support_asset)
        (not
          (checkpoint_prepared ?planner_unit)
        )
      )
    :effect (checkpoint_prepared ?planner_unit)
  )
  (:action finalize_checkpoint_with_priority_marker
    :parameters (?planner_unit - planner_unit ?priority_marker - priority_marker)
    :precondition
      (and
        (checkpoint_prepared ?planner_unit)
        (planner_has_priority_marker ?planner_unit ?priority_marker)
        (not
          (checkpoint_finalised ?planner_unit)
        )
      )
    :effect (checkpoint_finalised ?planner_unit)
  )
  (:action finalize_planner_checkpoint_completion
    :parameters (?planner_unit - planner_unit)
    :precondition
      (and
        (checkpoint_finalised ?planner_unit)
        (not
          (coverage_consolidated ?planner_unit)
        )
      )
    :effect
      (and
        (coverage_consolidated ?planner_unit)
        (marked_completed ?planner_unit)
      )
  )
  (:action grant_sector_a_completion
    :parameters (?sector_node_a - sector_node_a ?route_token - route_token)
    :precondition
      (and
        (sector_a_scan_complete ?sector_node_a)
        (sector_a_ready ?sector_node_a)
        (route_token_created ?route_token)
        (route_validated_for_beacon ?route_token)
        (not
          (marked_completed ?sector_node_a)
        )
      )
    :effect (marked_completed ?sector_node_a)
  )
  (:action grant_sector_b_completion
    :parameters (?sector_node_b - sector_node_b ?route_token - route_token)
    :precondition
      (and
        (sector_b_scan_complete ?sector_node_b)
        (sector_b_ready ?sector_node_b)
        (route_token_created ?route_token)
        (route_validated_for_beacon ?route_token)
        (not
          (marked_completed ?sector_node_b)
        )
      )
    :effect (marked_completed ?sector_node_b)
  )
  (:action consume_return_marker_for_entity
    :parameters (?expedition_plan - expedition_plan ?return_marker - return_marker ?waypoint_marker - waypoint_marker)
    :precondition
      (and
        (marked_completed ?expedition_plan)
        (entity_has_waypoint ?expedition_plan ?waypoint_marker)
        (return_marker_available ?return_marker)
        (not
          (return_marker_used ?expedition_plan)
        )
      )
    :effect
      (and
        (return_marker_used ?expedition_plan)
        (entity_has_return_marker ?expedition_plan ?return_marker)
        (not
          (return_marker_available ?return_marker)
        )
      )
  )
  (:action finalize_return_and_release_mount_for_sector_a
    :parameters (?sector_node_a - sector_node_a ?mount_option - mount_option ?return_marker - return_marker)
    :precondition
      (and
        (return_marker_used ?sector_node_a)
        (entity_assigned_mount ?sector_node_a ?mount_option)
        (entity_has_return_marker ?sector_node_a ?return_marker)
        (not
          (return_finalized ?sector_node_a)
        )
      )
    :effect
      (and
        (return_finalized ?sector_node_a)
        (mount_available ?mount_option)
        (return_marker_available ?return_marker)
      )
  )
  (:action finalize_return_and_release_mount_for_sector_b
    :parameters (?sector_node_b - sector_node_b ?mount_option - mount_option ?return_marker - return_marker)
    :precondition
      (and
        (return_marker_used ?sector_node_b)
        (entity_assigned_mount ?sector_node_b ?mount_option)
        (entity_has_return_marker ?sector_node_b ?return_marker)
        (not
          (return_finalized ?sector_node_b)
        )
      )
    :effect
      (and
        (return_finalized ?sector_node_b)
        (mount_available ?mount_option)
        (return_marker_available ?return_marker)
      )
  )
  (:action finalize_return_and_release_mount_for_planner
    :parameters (?planner_unit - planner_unit ?mount_option - mount_option ?return_marker - return_marker)
    :precondition
      (and
        (return_marker_used ?planner_unit)
        (entity_assigned_mount ?planner_unit ?mount_option)
        (entity_has_return_marker ?planner_unit ?return_marker)
        (not
          (return_finalized ?planner_unit)
        )
      )
    :effect
      (and
        (return_finalized ?planner_unit)
        (mount_available ?mount_option)
        (return_marker_available ?return_marker)
      )
  )
)

(define (domain safehouse_checkpoint_chain_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types deployable_asset - object resource_type - object vector_type - object world_region - object site - world_region link_token - deployable_asset scout_unit - deployable_asset access_tool - deployable_asset optional_modifier - deployable_asset mission_asset - deployable_asset hazard_marker - deployable_asset equipment - deployable_asset environmental_tag - deployable_asset consumable_supply - resource_type map_fragment - resource_type objective_marker - resource_type approach_vector - vector_type departure_vector - vector_type plan_token - vector_type site_subtype_a - site site_subtype_b - site origin_waypoint - site_subtype_a transit_waypoint - site_subtype_a base_node - site_subtype_b)
  (:predicates
    (site_discovered ?site - site)
    (site_validated ?site - site)
    (site_link_reserved ?site - site)
    (site_activated ?site - site)
    (checkpoint_deployed ?site - site)
    (hazard_tagged ?site - site)
    (link_token_available ?link_token - link_token)
    (reserved_link ?site - site ?link_token - link_token)
    (scout_available ?scout_unit - scout_unit)
    (scout_assigned ?site - site ?scout_unit - scout_unit)
    (access_tool_available ?access_tool - access_tool)
    (access_tool_attached ?site - site ?access_tool - access_tool)
    (consumable_available ?consumable_supply - consumable_supply)
    (origin_consumable_assigned ?origin_waypoint - origin_waypoint ?consumable_supply - consumable_supply)
    (transit_consumable_assigned ?transit_waypoint - transit_waypoint ?consumable_supply - consumable_supply)
    (has_approach_vector ?origin_waypoint - origin_waypoint ?approach_vector - approach_vector)
    (approach_vector_confirmed ?approach_vector - approach_vector)
    (approach_vector_flagged ?approach_vector - approach_vector)
    (origin_approach_ready ?origin_waypoint - origin_waypoint)
    (has_departure_vector ?transit_waypoint - transit_waypoint ?departure_vector - departure_vector)
    (departure_vector_confirmed ?departure_vector - departure_vector)
    (departure_vector_flagged ?departure_vector - departure_vector)
    (transit_departure_ready ?transit_waypoint - transit_waypoint)
    (plan_token_available ?plan_token - plan_token)
    (plan_token_finalized ?plan_token - plan_token)
    (plan_includes_approach ?plan_token - plan_token ?approach_vector - approach_vector)
    (plan_includes_departure ?plan_token - plan_token ?departure_vector - departure_vector)
    (plan_approach_condition ?plan_token - plan_token)
    (plan_departure_condition ?plan_token - plan_token)
    (plan_token_ready ?plan_token - plan_token)
    (node_has_origin ?base_node - base_node ?origin_waypoint - origin_waypoint)
    (node_has_transit ?base_node - base_node ?transit_waypoint - transit_waypoint)
    (node_assigned_plan ?base_node - base_node ?plan_token - plan_token)
    (map_fragment_available ?map_fragment - map_fragment)
    (node_has_map_fragment ?base_node - base_node ?map_fragment - map_fragment)
    (map_fragment_consumed ?map_fragment - map_fragment)
    (fragment_validates_plan ?map_fragment - map_fragment ?plan_token - plan_token)
    (node_ready_for_equipment ?base_node - base_node)
    (node_equipment_activated ?base_node - base_node)
    (node_attached_objectives_flag ?base_node - base_node)
    (node_modifier_attached ?base_node - base_node)
    (node_modifier_engaged ?base_node - base_node)
    (node_ready_for_assets ?base_node - base_node)
    (node_configuration_complete ?base_node - base_node)
    (objective_available ?objective_marker - objective_marker)
    (node_has_objective ?base_node - base_node ?objective_marker - objective_marker)
    (node_objective_attached ?base_node - base_node)
    (node_objective_ready ?base_node - base_node)
    (node_objective_finalized ?base_node - base_node)
    (optional_modifier_available ?optional_modifier - optional_modifier)
    (node_has_optional_modifier ?base_node - base_node ?optional_modifier - optional_modifier)
    (mission_asset_available ?mission_asset - mission_asset)
    (node_has_mission_asset ?base_node - base_node ?mission_asset - mission_asset)
    (equipment_available ?equipment - equipment)
    (node_has_equipment ?base_node - base_node ?equipment - equipment)
    (environmental_tag_available ?environmental_tag - environmental_tag)
    (node_has_environmental_tag ?base_node - base_node ?environmental_tag - environmental_tag)
    (hazard_marker_available ?hazard_marker - hazard_marker)
    (site_has_hazard_marker ?site - site ?hazard_marker - hazard_marker)
    (origin_approach_marked ?origin_waypoint - origin_waypoint)
    (transit_departure_marked ?transit_waypoint - transit_waypoint)
    (node_registered ?base_node - base_node)
  )
  (:action discover_site
    :parameters (?site - site)
    :precondition
      (and
        (not
          (site_discovered ?site)
        )
        (not
          (site_activated ?site)
        )
      )
    :effect (site_discovered ?site)
  )
  (:action reserve_site_link
    :parameters (?site - site ?link_token - link_token)
    :precondition
      (and
        (site_discovered ?site)
        (not
          (site_link_reserved ?site)
        )
        (link_token_available ?link_token)
      )
    :effect
      (and
        (site_link_reserved ?site)
        (reserved_link ?site ?link_token)
        (not
          (link_token_available ?link_token)
        )
      )
  )
  (:action assign_scout_to_site
    :parameters (?site - site ?scout_unit - scout_unit)
    :precondition
      (and
        (site_discovered ?site)
        (site_link_reserved ?site)
        (scout_available ?scout_unit)
      )
    :effect
      (and
        (scout_assigned ?site ?scout_unit)
        (not
          (scout_available ?scout_unit)
        )
      )
  )
  (:action validate_site_with_scout
    :parameters (?site - site ?scout_unit - scout_unit)
    :precondition
      (and
        (site_discovered ?site)
        (site_link_reserved ?site)
        (scout_assigned ?site ?scout_unit)
        (not
          (site_validated ?site)
        )
      )
    :effect (site_validated ?site)
  )
  (:action release_scout_from_site
    :parameters (?site - site ?scout_unit - scout_unit)
    :precondition
      (and
        (scout_assigned ?site ?scout_unit)
      )
    :effect
      (and
        (scout_available ?scout_unit)
        (not
          (scout_assigned ?site ?scout_unit)
        )
      )
  )
  (:action attach_access_tool_to_site
    :parameters (?site - site ?access_tool - access_tool)
    :precondition
      (and
        (site_validated ?site)
        (access_tool_available ?access_tool)
      )
    :effect
      (and
        (access_tool_attached ?site ?access_tool)
        (not
          (access_tool_available ?access_tool)
        )
      )
  )
  (:action detach_access_tool_from_site
    :parameters (?site - site ?access_tool - access_tool)
    :precondition
      (and
        (access_tool_attached ?site ?access_tool)
      )
    :effect
      (and
        (access_tool_available ?access_tool)
        (not
          (access_tool_attached ?site ?access_tool)
        )
      )
  )
  (:action assign_equipment_to_node
    :parameters (?base_node - base_node ?equipment - equipment)
    :precondition
      (and
        (site_validated ?base_node)
        (equipment_available ?equipment)
      )
    :effect
      (and
        (node_has_equipment ?base_node ?equipment)
        (not
          (equipment_available ?equipment)
        )
      )
  )
  (:action remove_equipment_from_node
    :parameters (?base_node - base_node ?equipment - equipment)
    :precondition
      (and
        (node_has_equipment ?base_node ?equipment)
      )
    :effect
      (and
        (equipment_available ?equipment)
        (not
          (node_has_equipment ?base_node ?equipment)
        )
      )
  )
  (:action attach_environmental_tag_to_node
    :parameters (?base_node - base_node ?environmental_tag - environmental_tag)
    :precondition
      (and
        (site_validated ?base_node)
        (environmental_tag_available ?environmental_tag)
      )
    :effect
      (and
        (node_has_environmental_tag ?base_node ?environmental_tag)
        (not
          (environmental_tag_available ?environmental_tag)
        )
      )
  )
  (:action detach_environmental_tag_from_node
    :parameters (?base_node - base_node ?environmental_tag - environmental_tag)
    :precondition
      (and
        (node_has_environmental_tag ?base_node ?environmental_tag)
      )
    :effect
      (and
        (environmental_tag_available ?environmental_tag)
        (not
          (node_has_environmental_tag ?base_node ?environmental_tag)
        )
      )
  )
  (:action probe_approach_vector
    :parameters (?origin_waypoint - origin_waypoint ?approach_vector - approach_vector ?scout_unit - scout_unit)
    :precondition
      (and
        (site_validated ?origin_waypoint)
        (scout_assigned ?origin_waypoint ?scout_unit)
        (has_approach_vector ?origin_waypoint ?approach_vector)
        (not
          (approach_vector_confirmed ?approach_vector)
        )
        (not
          (approach_vector_flagged ?approach_vector)
        )
      )
    :effect (approach_vector_confirmed ?approach_vector)
  )
  (:action mark_approach_with_tool
    :parameters (?origin_waypoint - origin_waypoint ?approach_vector - approach_vector ?access_tool - access_tool)
    :precondition
      (and
        (site_validated ?origin_waypoint)
        (access_tool_attached ?origin_waypoint ?access_tool)
        (has_approach_vector ?origin_waypoint ?approach_vector)
        (approach_vector_confirmed ?approach_vector)
        (not
          (origin_approach_marked ?origin_waypoint)
        )
      )
    :effect
      (and
        (origin_approach_marked ?origin_waypoint)
        (origin_approach_ready ?origin_waypoint)
      )
  )
  (:action assign_consumable_to_approach
    :parameters (?origin_waypoint - origin_waypoint ?approach_vector - approach_vector ?consumable_supply - consumable_supply)
    :precondition
      (and
        (site_validated ?origin_waypoint)
        (has_approach_vector ?origin_waypoint ?approach_vector)
        (consumable_available ?consumable_supply)
        (not
          (origin_approach_marked ?origin_waypoint)
        )
      )
    :effect
      (and
        (approach_vector_flagged ?approach_vector)
        (origin_approach_marked ?origin_waypoint)
        (origin_consumable_assigned ?origin_waypoint ?consumable_supply)
        (not
          (consumable_available ?consumable_supply)
        )
      )
  )
  (:action finalize_approach_marking
    :parameters (?origin_waypoint - origin_waypoint ?approach_vector - approach_vector ?scout_unit - scout_unit ?consumable_supply - consumable_supply)
    :precondition
      (and
        (site_validated ?origin_waypoint)
        (scout_assigned ?origin_waypoint ?scout_unit)
        (has_approach_vector ?origin_waypoint ?approach_vector)
        (approach_vector_flagged ?approach_vector)
        (origin_consumable_assigned ?origin_waypoint ?consumable_supply)
        (not
          (origin_approach_ready ?origin_waypoint)
        )
      )
    :effect
      (and
        (approach_vector_confirmed ?approach_vector)
        (origin_approach_ready ?origin_waypoint)
        (consumable_available ?consumable_supply)
        (not
          (origin_consumable_assigned ?origin_waypoint ?consumable_supply)
        )
      )
  )
  (:action probe_departure_vector
    :parameters (?transit_waypoint - transit_waypoint ?departure_vector - departure_vector ?scout_unit - scout_unit)
    :precondition
      (and
        (site_validated ?transit_waypoint)
        (scout_assigned ?transit_waypoint ?scout_unit)
        (has_departure_vector ?transit_waypoint ?departure_vector)
        (not
          (departure_vector_confirmed ?departure_vector)
        )
        (not
          (departure_vector_flagged ?departure_vector)
        )
      )
    :effect (departure_vector_confirmed ?departure_vector)
  )
  (:action mark_departure_with_tool
    :parameters (?transit_waypoint - transit_waypoint ?departure_vector - departure_vector ?access_tool - access_tool)
    :precondition
      (and
        (site_validated ?transit_waypoint)
        (access_tool_attached ?transit_waypoint ?access_tool)
        (has_departure_vector ?transit_waypoint ?departure_vector)
        (departure_vector_confirmed ?departure_vector)
        (not
          (transit_departure_marked ?transit_waypoint)
        )
      )
    :effect
      (and
        (transit_departure_marked ?transit_waypoint)
        (transit_departure_ready ?transit_waypoint)
      )
  )
  (:action assign_consumable_to_departure
    :parameters (?transit_waypoint - transit_waypoint ?departure_vector - departure_vector ?consumable_supply - consumable_supply)
    :precondition
      (and
        (site_validated ?transit_waypoint)
        (has_departure_vector ?transit_waypoint ?departure_vector)
        (consumable_available ?consumable_supply)
        (not
          (transit_departure_marked ?transit_waypoint)
        )
      )
    :effect
      (and
        (departure_vector_flagged ?departure_vector)
        (transit_departure_marked ?transit_waypoint)
        (transit_consumable_assigned ?transit_waypoint ?consumable_supply)
        (not
          (consumable_available ?consumable_supply)
        )
      )
  )
  (:action finalize_departure_marking
    :parameters (?transit_waypoint - transit_waypoint ?departure_vector - departure_vector ?scout_unit - scout_unit ?consumable_supply - consumable_supply)
    :precondition
      (and
        (site_validated ?transit_waypoint)
        (scout_assigned ?transit_waypoint ?scout_unit)
        (has_departure_vector ?transit_waypoint ?departure_vector)
        (departure_vector_flagged ?departure_vector)
        (transit_consumable_assigned ?transit_waypoint ?consumable_supply)
        (not
          (transit_departure_ready ?transit_waypoint)
        )
      )
    :effect
      (and
        (departure_vector_confirmed ?departure_vector)
        (transit_departure_ready ?transit_waypoint)
        (consumable_available ?consumable_supply)
        (not
          (transit_consumable_assigned ?transit_waypoint ?consumable_supply)
        )
      )
  )
  (:action mint_plan_token_basic
    :parameters (?origin_waypoint - origin_waypoint ?transit_waypoint - transit_waypoint ?approach_vector - approach_vector ?departure_vector - departure_vector ?plan_token - plan_token)
    :precondition
      (and
        (origin_approach_marked ?origin_waypoint)
        (transit_departure_marked ?transit_waypoint)
        (has_approach_vector ?origin_waypoint ?approach_vector)
        (has_departure_vector ?transit_waypoint ?departure_vector)
        (approach_vector_confirmed ?approach_vector)
        (departure_vector_confirmed ?departure_vector)
        (origin_approach_ready ?origin_waypoint)
        (transit_departure_ready ?transit_waypoint)
        (plan_token_available ?plan_token)
      )
    :effect
      (and
        (plan_token_finalized ?plan_token)
        (plan_includes_approach ?plan_token ?approach_vector)
        (plan_includes_departure ?plan_token ?departure_vector)
        (not
          (plan_token_available ?plan_token)
        )
      )
  )
  (:action mint_plan_token_with_approach_condition
    :parameters (?origin_waypoint - origin_waypoint ?transit_waypoint - transit_waypoint ?approach_vector - approach_vector ?departure_vector - departure_vector ?plan_token - plan_token)
    :precondition
      (and
        (origin_approach_marked ?origin_waypoint)
        (transit_departure_marked ?transit_waypoint)
        (has_approach_vector ?origin_waypoint ?approach_vector)
        (has_departure_vector ?transit_waypoint ?departure_vector)
        (approach_vector_flagged ?approach_vector)
        (departure_vector_confirmed ?departure_vector)
        (not
          (origin_approach_ready ?origin_waypoint)
        )
        (transit_departure_ready ?transit_waypoint)
        (plan_token_available ?plan_token)
      )
    :effect
      (and
        (plan_token_finalized ?plan_token)
        (plan_includes_approach ?plan_token ?approach_vector)
        (plan_includes_departure ?plan_token ?departure_vector)
        (plan_approach_condition ?plan_token)
        (not
          (plan_token_available ?plan_token)
        )
      )
  )
  (:action mint_plan_token_with_departure_condition
    :parameters (?origin_waypoint - origin_waypoint ?transit_waypoint - transit_waypoint ?approach_vector - approach_vector ?departure_vector - departure_vector ?plan_token - plan_token)
    :precondition
      (and
        (origin_approach_marked ?origin_waypoint)
        (transit_departure_marked ?transit_waypoint)
        (has_approach_vector ?origin_waypoint ?approach_vector)
        (has_departure_vector ?transit_waypoint ?departure_vector)
        (approach_vector_confirmed ?approach_vector)
        (departure_vector_flagged ?departure_vector)
        (origin_approach_ready ?origin_waypoint)
        (not
          (transit_departure_ready ?transit_waypoint)
        )
        (plan_token_available ?plan_token)
      )
    :effect
      (and
        (plan_token_finalized ?plan_token)
        (plan_includes_approach ?plan_token ?approach_vector)
        (plan_includes_departure ?plan_token ?departure_vector)
        (plan_departure_condition ?plan_token)
        (not
          (plan_token_available ?plan_token)
        )
      )
  )
  (:action mint_plan_token_with_both_conditions
    :parameters (?origin_waypoint - origin_waypoint ?transit_waypoint - transit_waypoint ?approach_vector - approach_vector ?departure_vector - departure_vector ?plan_token - plan_token)
    :precondition
      (and
        (origin_approach_marked ?origin_waypoint)
        (transit_departure_marked ?transit_waypoint)
        (has_approach_vector ?origin_waypoint ?approach_vector)
        (has_departure_vector ?transit_waypoint ?departure_vector)
        (approach_vector_flagged ?approach_vector)
        (departure_vector_flagged ?departure_vector)
        (not
          (origin_approach_ready ?origin_waypoint)
        )
        (not
          (transit_departure_ready ?transit_waypoint)
        )
        (plan_token_available ?plan_token)
      )
    :effect
      (and
        (plan_token_finalized ?plan_token)
        (plan_includes_approach ?plan_token ?approach_vector)
        (plan_includes_departure ?plan_token ?departure_vector)
        (plan_approach_condition ?plan_token)
        (plan_departure_condition ?plan_token)
        (not
          (plan_token_available ?plan_token)
        )
      )
  )
  (:action prepare_plan_token
    :parameters (?plan_token - plan_token ?origin_waypoint - origin_waypoint ?scout_unit - scout_unit)
    :precondition
      (and
        (plan_token_finalized ?plan_token)
        (origin_approach_marked ?origin_waypoint)
        (scout_assigned ?origin_waypoint ?scout_unit)
        (not
          (plan_token_ready ?plan_token)
        )
      )
    :effect (plan_token_ready ?plan_token)
  )
  (:action ingest_map_fragment
    :parameters (?base_node - base_node ?map_fragment - map_fragment ?plan_token - plan_token)
    :precondition
      (and
        (site_validated ?base_node)
        (node_assigned_plan ?base_node ?plan_token)
        (node_has_map_fragment ?base_node ?map_fragment)
        (map_fragment_available ?map_fragment)
        (plan_token_finalized ?plan_token)
        (plan_token_ready ?plan_token)
        (not
          (map_fragment_consumed ?map_fragment)
        )
      )
    :effect
      (and
        (map_fragment_consumed ?map_fragment)
        (fragment_validates_plan ?map_fragment ?plan_token)
        (not
          (map_fragment_available ?map_fragment)
        )
      )
  )
  (:action confirm_map_fragment_ingestion
    :parameters (?base_node - base_node ?map_fragment - map_fragment ?plan_token - plan_token ?scout_unit - scout_unit)
    :precondition
      (and
        (site_validated ?base_node)
        (node_has_map_fragment ?base_node ?map_fragment)
        (map_fragment_consumed ?map_fragment)
        (fragment_validates_plan ?map_fragment ?plan_token)
        (scout_assigned ?base_node ?scout_unit)
        (not
          (plan_approach_condition ?plan_token)
        )
        (not
          (node_ready_for_equipment ?base_node)
        )
      )
    :effect (node_ready_for_equipment ?base_node)
  )
  (:action attach_optional_modifier_to_node
    :parameters (?base_node - base_node ?optional_modifier - optional_modifier)
    :precondition
      (and
        (site_validated ?base_node)
        (optional_modifier_available ?optional_modifier)
        (not
          (node_modifier_attached ?base_node)
        )
      )
    :effect
      (and
        (node_modifier_attached ?base_node)
        (node_has_optional_modifier ?base_node ?optional_modifier)
        (not
          (optional_modifier_available ?optional_modifier)
        )
      )
  )
  (:action apply_optional_modifier_with_fragment
    :parameters (?base_node - base_node ?map_fragment - map_fragment ?plan_token - plan_token ?scout_unit - scout_unit ?optional_modifier - optional_modifier)
    :precondition
      (and
        (site_validated ?base_node)
        (node_has_map_fragment ?base_node ?map_fragment)
        (map_fragment_consumed ?map_fragment)
        (fragment_validates_plan ?map_fragment ?plan_token)
        (scout_assigned ?base_node ?scout_unit)
        (plan_approach_condition ?plan_token)
        (node_modifier_attached ?base_node)
        (node_has_optional_modifier ?base_node ?optional_modifier)
        (not
          (node_ready_for_equipment ?base_node)
        )
      )
    :effect
      (and
        (node_ready_for_equipment ?base_node)
        (node_modifier_engaged ?base_node)
      )
  )
  (:action activate_equipment_on_node
    :parameters (?base_node - base_node ?equipment - equipment ?access_tool - access_tool ?map_fragment - map_fragment ?plan_token - plan_token)
    :precondition
      (and
        (node_ready_for_equipment ?base_node)
        (node_has_equipment ?base_node ?equipment)
        (access_tool_attached ?base_node ?access_tool)
        (node_has_map_fragment ?base_node ?map_fragment)
        (fragment_validates_plan ?map_fragment ?plan_token)
        (not
          (plan_departure_condition ?plan_token)
        )
        (not
          (node_equipment_activated ?base_node)
        )
      )
    :effect (node_equipment_activated ?base_node)
  )
  (:action activate_equipment_variation_on_node
    :parameters (?base_node - base_node ?equipment - equipment ?access_tool - access_tool ?map_fragment - map_fragment ?plan_token - plan_token)
    :precondition
      (and
        (node_ready_for_equipment ?base_node)
        (node_has_equipment ?base_node ?equipment)
        (access_tool_attached ?base_node ?access_tool)
        (node_has_map_fragment ?base_node ?map_fragment)
        (fragment_validates_plan ?map_fragment ?plan_token)
        (plan_departure_condition ?plan_token)
        (not
          (node_equipment_activated ?base_node)
        )
      )
    :effect (node_equipment_activated ?base_node)
  )
  (:action bind_objective_variant_a
    :parameters (?base_node - base_node ?environmental_tag - environmental_tag ?map_fragment - map_fragment ?plan_token - plan_token)
    :precondition
      (and
        (node_equipment_activated ?base_node)
        (node_has_environmental_tag ?base_node ?environmental_tag)
        (node_has_map_fragment ?base_node ?map_fragment)
        (fragment_validates_plan ?map_fragment ?plan_token)
        (not
          (plan_approach_condition ?plan_token)
        )
        (not
          (plan_departure_condition ?plan_token)
        )
        (not
          (node_attached_objectives_flag ?base_node)
        )
      )
    :effect (node_attached_objectives_flag ?base_node)
  )
  (:action bind_objective_variant_b
    :parameters (?base_node - base_node ?environmental_tag - environmental_tag ?map_fragment - map_fragment ?plan_token - plan_token)
    :precondition
      (and
        (node_equipment_activated ?base_node)
        (node_has_environmental_tag ?base_node ?environmental_tag)
        (node_has_map_fragment ?base_node ?map_fragment)
        (fragment_validates_plan ?map_fragment ?plan_token)
        (plan_approach_condition ?plan_token)
        (not
          (plan_departure_condition ?plan_token)
        )
        (not
          (node_attached_objectives_flag ?base_node)
        )
      )
    :effect
      (and
        (node_attached_objectives_flag ?base_node)
        (node_ready_for_assets ?base_node)
      )
  )
  (:action bind_objective_variant_c
    :parameters (?base_node - base_node ?environmental_tag - environmental_tag ?map_fragment - map_fragment ?plan_token - plan_token)
    :precondition
      (and
        (node_equipment_activated ?base_node)
        (node_has_environmental_tag ?base_node ?environmental_tag)
        (node_has_map_fragment ?base_node ?map_fragment)
        (fragment_validates_plan ?map_fragment ?plan_token)
        (not
          (plan_approach_condition ?plan_token)
        )
        (plan_departure_condition ?plan_token)
        (not
          (node_attached_objectives_flag ?base_node)
        )
      )
    :effect
      (and
        (node_attached_objectives_flag ?base_node)
        (node_ready_for_assets ?base_node)
      )
  )
  (:action bind_objective_variant_d
    :parameters (?base_node - base_node ?environmental_tag - environmental_tag ?map_fragment - map_fragment ?plan_token - plan_token)
    :precondition
      (and
        (node_equipment_activated ?base_node)
        (node_has_environmental_tag ?base_node ?environmental_tag)
        (node_has_map_fragment ?base_node ?map_fragment)
        (fragment_validates_plan ?map_fragment ?plan_token)
        (plan_approach_condition ?plan_token)
        (plan_departure_condition ?plan_token)
        (not
          (node_attached_objectives_flag ?base_node)
        )
      )
    :effect
      (and
        (node_attached_objectives_flag ?base_node)
        (node_ready_for_assets ?base_node)
      )
  )
  (:action finalize_and_register_node
    :parameters (?base_node - base_node)
    :precondition
      (and
        (node_attached_objectives_flag ?base_node)
        (not
          (node_ready_for_assets ?base_node)
        )
        (not
          (node_registered ?base_node)
        )
      )
    :effect
      (and
        (node_registered ?base_node)
        (checkpoint_deployed ?base_node)
      )
  )
  (:action attach_mission_asset_to_node
    :parameters (?base_node - base_node ?mission_asset - mission_asset)
    :precondition
      (and
        (node_attached_objectives_flag ?base_node)
        (node_ready_for_assets ?base_node)
        (mission_asset_available ?mission_asset)
      )
    :effect
      (and
        (node_has_mission_asset ?base_node ?mission_asset)
        (not
          (mission_asset_available ?mission_asset)
        )
      )
  )
  (:action configure_node_with_assets
    :parameters (?base_node - base_node ?origin_waypoint - origin_waypoint ?transit_waypoint - transit_waypoint ?scout_unit - scout_unit ?mission_asset - mission_asset)
    :precondition
      (and
        (node_attached_objectives_flag ?base_node)
        (node_ready_for_assets ?base_node)
        (node_has_mission_asset ?base_node ?mission_asset)
        (node_has_origin ?base_node ?origin_waypoint)
        (node_has_transit ?base_node ?transit_waypoint)
        (origin_approach_ready ?origin_waypoint)
        (transit_departure_ready ?transit_waypoint)
        (scout_assigned ?base_node ?scout_unit)
        (not
          (node_configuration_complete ?base_node)
        )
      )
    :effect (node_configuration_complete ?base_node)
  )
  (:action register_node_from_configuration
    :parameters (?base_node - base_node)
    :precondition
      (and
        (node_attached_objectives_flag ?base_node)
        (node_configuration_complete ?base_node)
        (not
          (node_registered ?base_node)
        )
      )
    :effect
      (and
        (node_registered ?base_node)
        (checkpoint_deployed ?base_node)
      )
  )
  (:action attach_objective_marker_to_node
    :parameters (?base_node - base_node ?objective_marker - objective_marker ?scout_unit - scout_unit)
    :precondition
      (and
        (site_validated ?base_node)
        (scout_assigned ?base_node ?scout_unit)
        (objective_available ?objective_marker)
        (node_has_objective ?base_node ?objective_marker)
        (not
          (node_objective_attached ?base_node)
        )
      )
    :effect
      (and
        (node_objective_attached ?base_node)
        (not
          (objective_available ?objective_marker)
        )
      )
  )
  (:action enable_objective_on_node
    :parameters (?base_node - base_node ?access_tool - access_tool)
    :precondition
      (and
        (node_objective_attached ?base_node)
        (access_tool_attached ?base_node ?access_tool)
        (not
          (node_objective_ready ?base_node)
        )
      )
    :effect (node_objective_ready ?base_node)
  )
  (:action finalize_objective_with_tag
    :parameters (?base_node - base_node ?environmental_tag - environmental_tag)
    :precondition
      (and
        (node_objective_ready ?base_node)
        (node_has_environmental_tag ?base_node ?environmental_tag)
        (not
          (node_objective_finalized ?base_node)
        )
      )
    :effect (node_objective_finalized ?base_node)
  )
  (:action register_objective_on_node
    :parameters (?base_node - base_node)
    :precondition
      (and
        (node_objective_finalized ?base_node)
        (not
          (node_registered ?base_node)
        )
      )
    :effect
      (and
        (node_registered ?base_node)
        (checkpoint_deployed ?base_node)
      )
  )
  (:action deploy_checkpoint_to_origin
    :parameters (?origin_waypoint - origin_waypoint ?plan_token - plan_token)
    :precondition
      (and
        (origin_approach_marked ?origin_waypoint)
        (origin_approach_ready ?origin_waypoint)
        (plan_token_finalized ?plan_token)
        (plan_token_ready ?plan_token)
        (not
          (checkpoint_deployed ?origin_waypoint)
        )
      )
    :effect (checkpoint_deployed ?origin_waypoint)
  )
  (:action deploy_checkpoint_to_transit
    :parameters (?transit_waypoint - transit_waypoint ?plan_token - plan_token)
    :precondition
      (and
        (transit_departure_marked ?transit_waypoint)
        (transit_departure_ready ?transit_waypoint)
        (plan_token_finalized ?plan_token)
        (plan_token_ready ?plan_token)
        (not
          (checkpoint_deployed ?transit_waypoint)
        )
      )
    :effect (checkpoint_deployed ?transit_waypoint)
  )
  (:action apply_hazard_tag_to_site
    :parameters (?site - site ?hazard_marker - hazard_marker ?scout_unit - scout_unit)
    :precondition
      (and
        (checkpoint_deployed ?site)
        (scout_assigned ?site ?scout_unit)
        (hazard_marker_available ?hazard_marker)
        (not
          (hazard_tagged ?site)
        )
      )
    :effect
      (and
        (hazard_tagged ?site)
        (site_has_hazard_marker ?site ?hazard_marker)
        (not
          (hazard_marker_available ?hazard_marker)
        )
      )
  )
  (:action enable_site_from_origin
    :parameters (?origin_waypoint - origin_waypoint ?link_token - link_token ?hazard_marker - hazard_marker)
    :precondition
      (and
        (hazard_tagged ?origin_waypoint)
        (reserved_link ?origin_waypoint ?link_token)
        (site_has_hazard_marker ?origin_waypoint ?hazard_marker)
        (not
          (site_activated ?origin_waypoint)
        )
      )
    :effect
      (and
        (site_activated ?origin_waypoint)
        (link_token_available ?link_token)
        (hazard_marker_available ?hazard_marker)
      )
  )
  (:action enable_site_from_transit
    :parameters (?transit_waypoint - transit_waypoint ?link_token - link_token ?hazard_marker - hazard_marker)
    :precondition
      (and
        (hazard_tagged ?transit_waypoint)
        (reserved_link ?transit_waypoint ?link_token)
        (site_has_hazard_marker ?transit_waypoint ?hazard_marker)
        (not
          (site_activated ?transit_waypoint)
        )
      )
    :effect
      (and
        (site_activated ?transit_waypoint)
        (link_token_available ?link_token)
        (hazard_marker_available ?hazard_marker)
      )
  )
  (:action enable_site_from_node
    :parameters (?base_node - base_node ?link_token - link_token ?hazard_marker - hazard_marker)
    :precondition
      (and
        (hazard_tagged ?base_node)
        (reserved_link ?base_node ?link_token)
        (site_has_hazard_marker ?base_node ?hazard_marker)
        (not
          (site_activated ?base_node)
        )
      )
    :effect
      (and
        (site_activated ?base_node)
        (link_token_available ?link_token)
        (hazard_marker_available ?hazard_marker)
      )
  )
)

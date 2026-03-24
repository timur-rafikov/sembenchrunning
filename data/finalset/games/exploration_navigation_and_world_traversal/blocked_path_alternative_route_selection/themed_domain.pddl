(define (domain blocked_path_alternative_route_selection)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object unit_group - entity node_category - entity point_category - entity top_node_category - entity site_node - top_node_category route_candidate_token - unit_group recon_report - unit_group device_unit - unit_group landmark_marker - unit_group upgrade_module - unit_group return_beacon - unit_group equipment_module - unit_group modifier_chip - unit_group consumable_supply - node_category map_fragment - node_category landmark_annotation - node_category entry_point - point_category exit_point - point_category proposed_route - point_category node_subtype - site_node sector_subtype - site_node ground_scout - node_subtype ranged_scout - node_subtype sector_controller - sector_subtype)

  (:predicates
    (entity_discovered ?site_node - site_node)
    (entity_scouted ?site_node - site_node)
    (candidate_assigned ?site_node - site_node)
    (entity_unblocked ?site_node - site_node)
    (finalized_for_unlock ?site_node - site_node)
    (unlock_binding_ready ?site_node - site_node)
    (candidate_available ?route_candidate_token - route_candidate_token)
    (entity_has_candidate ?site_node - site_node ?route_candidate_token - route_candidate_token)
    (recon_available ?recon_report - recon_report)
    (entity_supports_recon ?site_node - site_node ?recon_report - recon_report)
    (device_available ?device_unit - device_unit)
    (entity_has_device ?site_node - site_node ?device_unit - device_unit)
    (supply_available ?consumable_supply - consumable_supply)
    (ground_scout_has_supply ?ground_scout - ground_scout ?consumable_supply - consumable_supply)
    (ranged_scout_has_supply ?ranged_scout - ranged_scout ?consumable_supply - consumable_supply)
    (agent_connected_entry ?ground_scout - ground_scout ?entry_point - entry_point)
    (entry_marked_confirmed ?entry_point - entry_point)
    (entry_marked_supplemental ?entry_point - entry_point)
    (ground_probe_confirmed ?ground_scout - ground_scout)
    (agent_connected_exit ?ranged_scout - ranged_scout ?exit_point - exit_point)
    (exit_marked_confirmed ?exit_point - exit_point)
    (exit_marked_supplemental ?exit_point - exit_point)
    (ranged_probe_confirmed ?ranged_scout - ranged_scout)
    (route_plan_slot_available ?proposed_route - proposed_route)
    (route_plan_materialized ?proposed_route - proposed_route)
    (route_has_entry ?proposed_route - proposed_route ?entry_point - entry_point)
    (route_has_exit ?proposed_route - proposed_route ?exit_point - exit_point)
    (route_flag_quality_low ?proposed_route - proposed_route)
    (route_flag_quality_high ?proposed_route - proposed_route)
    (route_confirmed_for_materialization ?proposed_route - proposed_route)
    (controller_has_ground_agent ?sector_controller - sector_controller ?ground_scout - ground_scout)
    (controller_has_ranged_agent ?sector_controller - sector_controller ?ranged_scout - ranged_scout)
    (controller_owns_route ?sector_controller - sector_controller ?proposed_route - proposed_route)
    (map_fragment_available ?map_fragment - map_fragment)
    (controller_has_fragment_slot ?sector_controller - sector_controller ?map_fragment - map_fragment)
    (fragment_attached ?map_fragment - map_fragment)
    (fragment_linked_route ?map_fragment - map_fragment ?proposed_route - proposed_route)
    (controller_validation_step1_complete ?sector_controller - sector_controller)
    (controller_validation_step2_ready ?sector_controller - sector_controller)
    (controller_ready_for_finalization ?sector_controller - sector_controller)
    (landmark_attached_flag ?sector_controller - sector_controller)
    (controller_used_landmark ?sector_controller - sector_controller)
    (controller_has_required_modules ?sector_controller - sector_controller)
    (controller_finalized ?sector_controller - sector_controller)
    (landmark_annotation_available ?annotation_tag - landmark_annotation)
    (controller_bound_landmark_annotation ?sector_controller - sector_controller ?annotation_tag - landmark_annotation)
    (controller_landmark_state1 ?sector_controller - sector_controller)
    (controller_landmark_state2 ?sector_controller - sector_controller)
    (controller_landmark_state3 ?sector_controller - sector_controller)
    (landmark_marker_available ?landmark_token - landmark_marker)
    (controller_has_landmark_marker ?sector_controller - sector_controller ?landmark_token - landmark_marker)
    (upgrade_module_available ?upgrade_module - upgrade_module)
    (controller_has_upgrade ?sector_controller - sector_controller ?upgrade_module - upgrade_module)
    (equipment_module_available ?equipment_module - equipment_module)
    (controller_has_equipment ?sector_controller - sector_controller ?equipment_module - equipment_module)
    (modifier_available ?modifier_chip - modifier_chip)
    (controller_has_modifier ?sector_controller - sector_controller ?modifier_chip - modifier_chip)
    (beacon_available ?return_beacon - return_beacon)
    (entity_bound_beacon ?site_node - site_node ?return_beacon - return_beacon)
    (ground_agent_probe_ready ?ground_scout - ground_scout)
    (ranged_agent_probe_ready ?ranged_scout - ranged_scout)
    (controller_activation_flag ?sector_controller - sector_controller)
  )
  (:action discover_site
    :parameters (?site_node - site_node)
    :precondition
      (and
        (not
          (entity_discovered ?site_node)
        )
        (not
          (entity_unblocked ?site_node)
        )
      )
    :effect (entity_discovered ?site_node)
  )
  (:action assign_route_candidate_to_site
    :parameters (?site_node - site_node ?route_candidate_token - route_candidate_token)
    :precondition
      (and
        (entity_discovered ?site_node)
        (not
          (candidate_assigned ?site_node)
        )
        (candidate_available ?route_candidate_token)
      )
    :effect
      (and
        (candidate_assigned ?site_node)
        (entity_has_candidate ?site_node ?route_candidate_token)
        (not
          (candidate_available ?route_candidate_token)
        )
      )
  )
  (:action attach_recon_report_to_site
    :parameters (?site_node - site_node ?recon_report - recon_report)
    :precondition
      (and
        (entity_discovered ?site_node)
        (candidate_assigned ?site_node)
        (recon_available ?recon_report)
      )
    :effect
      (and
        (entity_supports_recon ?site_node ?recon_report)
        (not
          (recon_available ?recon_report)
        )
      )
  )
  (:action confirm_site_scouting
    :parameters (?site_node - site_node ?recon_report - recon_report)
    :precondition
      (and
        (entity_discovered ?site_node)
        (candidate_assigned ?site_node)
        (entity_supports_recon ?site_node ?recon_report)
        (not
          (entity_scouted ?site_node)
        )
      )
    :effect (entity_scouted ?site_node)
  )
  (:action retract_recon_report_from_site
    :parameters (?site_node - site_node ?recon_report - recon_report)
    :precondition
      (and
        (entity_supports_recon ?site_node ?recon_report)
      )
    :effect
      (and
        (recon_available ?recon_report)
        (not
          (entity_supports_recon ?site_node ?recon_report)
        )
      )
  )
  (:action attach_device_to_site
    :parameters (?site_node - site_node ?device_unit - device_unit)
    :precondition
      (and
        (entity_scouted ?site_node)
        (device_available ?device_unit)
      )
    :effect
      (and
        (entity_has_device ?site_node ?device_unit)
        (not
          (device_available ?device_unit)
        )
      )
  )
  (:action detach_device_from_site
    :parameters (?site_node - site_node ?device_unit - device_unit)
    :precondition
      (and
        (entity_has_device ?site_node ?device_unit)
      )
    :effect
      (and
        (device_available ?device_unit)
        (not
          (entity_has_device ?site_node ?device_unit)
        )
      )
  )
  (:action assign_equipment_to_controller
    :parameters (?sector_controller - sector_controller ?equipment_module - equipment_module)
    :precondition
      (and
        (entity_scouted ?sector_controller)
        (equipment_module_available ?equipment_module)
      )
    :effect
      (and
        (controller_has_equipment ?sector_controller ?equipment_module)
        (not
          (equipment_module_available ?equipment_module)
        )
      )
  )
  (:action remove_equipment_from_controller
    :parameters (?sector_controller - sector_controller ?equipment_module - equipment_module)
    :precondition
      (and
        (controller_has_equipment ?sector_controller ?equipment_module)
      )
    :effect
      (and
        (equipment_module_available ?equipment_module)
        (not
          (controller_has_equipment ?sector_controller ?equipment_module)
        )
      )
  )
  (:action assign_modifier_to_controller
    :parameters (?sector_controller - sector_controller ?modifier_chip - modifier_chip)
    :precondition
      (and
        (entity_scouted ?sector_controller)
        (modifier_available ?modifier_chip)
      )
    :effect
      (and
        (controller_has_modifier ?sector_controller ?modifier_chip)
        (not
          (modifier_available ?modifier_chip)
        )
      )
  )
  (:action remove_modifier_from_controller
    :parameters (?sector_controller - sector_controller ?modifier_chip - modifier_chip)
    :precondition
      (and
        (controller_has_modifier ?sector_controller ?modifier_chip)
      )
    :effect
      (and
        (modifier_available ?modifier_chip)
        (not
          (controller_has_modifier ?sector_controller ?modifier_chip)
        )
      )
  )
  (:action ground_probe_mark_entry
    :parameters (?ground_scout - ground_scout ?entry_point - entry_point ?recon_report - recon_report)
    :precondition
      (and
        (entity_scouted ?ground_scout)
        (entity_supports_recon ?ground_scout ?recon_report)
        (agent_connected_entry ?ground_scout ?entry_point)
        (not
          (entry_marked_confirmed ?entry_point)
        )
        (not
          (entry_marked_supplemental ?entry_point)
        )
      )
    :effect (entry_marked_confirmed ?entry_point)
  )
  (:action ground_finalize_entry_probe
    :parameters (?ground_scout - ground_scout ?entry_point - entry_point ?device_unit - device_unit)
    :precondition
      (and
        (entity_scouted ?ground_scout)
        (entity_has_device ?ground_scout ?device_unit)
        (agent_connected_entry ?ground_scout ?entry_point)
        (entry_marked_confirmed ?entry_point)
        (not
          (ground_agent_probe_ready ?ground_scout)
        )
      )
    :effect
      (and
        (ground_agent_probe_ready ?ground_scout)
        (ground_probe_confirmed ?ground_scout)
      )
  )
  (:action ground_apply_consumable_to_entry
    :parameters (?ground_scout - ground_scout ?entry_point - entry_point ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_scouted ?ground_scout)
        (agent_connected_entry ?ground_scout ?entry_point)
        (supply_available ?consumable_supply)
        (not
          (ground_agent_probe_ready ?ground_scout)
        )
      )
    :effect
      (and
        (entry_marked_supplemental ?entry_point)
        (ground_agent_probe_ready ?ground_scout)
        (ground_scout_has_supply ?ground_scout ?consumable_supply)
        (not
          (supply_available ?consumable_supply)
        )
      )
  )
  (:action ground_finalize_entry_confirmation
    :parameters (?ground_scout - ground_scout ?entry_point - entry_point ?recon_report - recon_report ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_scouted ?ground_scout)
        (entity_supports_recon ?ground_scout ?recon_report)
        (agent_connected_entry ?ground_scout ?entry_point)
        (entry_marked_supplemental ?entry_point)
        (ground_scout_has_supply ?ground_scout ?consumable_supply)
        (not
          (ground_probe_confirmed ?ground_scout)
        )
      )
    :effect
      (and
        (entry_marked_confirmed ?entry_point)
        (ground_probe_confirmed ?ground_scout)
        (supply_available ?consumable_supply)
        (not
          (ground_scout_has_supply ?ground_scout ?consumable_supply)
        )
      )
  )
  (:action ranged_probe_mark_exit
    :parameters (?ranged_scout - ranged_scout ?exit_point - exit_point ?recon_report - recon_report)
    :precondition
      (and
        (entity_scouted ?ranged_scout)
        (entity_supports_recon ?ranged_scout ?recon_report)
        (agent_connected_exit ?ranged_scout ?exit_point)
        (not
          (exit_marked_confirmed ?exit_point)
        )
        (not
          (exit_marked_supplemental ?exit_point)
        )
      )
    :effect (exit_marked_confirmed ?exit_point)
  )
  (:action ranged_finalize_exit_probe
    :parameters (?ranged_scout - ranged_scout ?exit_point - exit_point ?device_unit - device_unit)
    :precondition
      (and
        (entity_scouted ?ranged_scout)
        (entity_has_device ?ranged_scout ?device_unit)
        (agent_connected_exit ?ranged_scout ?exit_point)
        (exit_marked_confirmed ?exit_point)
        (not
          (ranged_agent_probe_ready ?ranged_scout)
        )
      )
    :effect
      (and
        (ranged_agent_probe_ready ?ranged_scout)
        (ranged_probe_confirmed ?ranged_scout)
      )
  )
  (:action ranged_apply_consumable_to_exit
    :parameters (?ranged_scout - ranged_scout ?exit_point - exit_point ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_scouted ?ranged_scout)
        (agent_connected_exit ?ranged_scout ?exit_point)
        (supply_available ?consumable_supply)
        (not
          (ranged_agent_probe_ready ?ranged_scout)
        )
      )
    :effect
      (and
        (exit_marked_supplemental ?exit_point)
        (ranged_agent_probe_ready ?ranged_scout)
        (ranged_scout_has_supply ?ranged_scout ?consumable_supply)
        (not
          (supply_available ?consumable_supply)
        )
      )
  )
  (:action ranged_finalize_exit_confirmation
    :parameters (?ranged_scout - ranged_scout ?exit_point - exit_point ?recon_report - recon_report ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_scouted ?ranged_scout)
        (entity_supports_recon ?ranged_scout ?recon_report)
        (agent_connected_exit ?ranged_scout ?exit_point)
        (exit_marked_supplemental ?exit_point)
        (ranged_scout_has_supply ?ranged_scout ?consumable_supply)
        (not
          (ranged_probe_confirmed ?ranged_scout)
        )
      )
    :effect
      (and
        (exit_marked_confirmed ?exit_point)
        (ranged_probe_confirmed ?ranged_scout)
        (supply_available ?consumable_supply)
        (not
          (ranged_scout_has_supply ?ranged_scout ?consumable_supply)
        )
      )
  )
  (:action synthesize_route_proposal
    :parameters (?ground_scout - ground_scout ?ranged_scout - ranged_scout ?entry_point - entry_point ?exit_point - exit_point ?proposed_route - proposed_route)
    :precondition
      (and
        (ground_agent_probe_ready ?ground_scout)
        (ranged_agent_probe_ready ?ranged_scout)
        (agent_connected_entry ?ground_scout ?entry_point)
        (agent_connected_exit ?ranged_scout ?exit_point)
        (entry_marked_confirmed ?entry_point)
        (exit_marked_confirmed ?exit_point)
        (ground_probe_confirmed ?ground_scout)
        (ranged_probe_confirmed ?ranged_scout)
        (route_plan_slot_available ?proposed_route)
      )
    :effect
      (and
        (route_plan_materialized ?proposed_route)
        (route_has_entry ?proposed_route ?entry_point)
        (route_has_exit ?proposed_route ?exit_point)
        (not
          (route_plan_slot_available ?proposed_route)
        )
      )
  )
  (:action synthesize_route_proposal_low_quality
    :parameters (?ground_scout - ground_scout ?ranged_scout - ranged_scout ?entry_point - entry_point ?exit_point - exit_point ?proposed_route - proposed_route)
    :precondition
      (and
        (ground_agent_probe_ready ?ground_scout)
        (ranged_agent_probe_ready ?ranged_scout)
        (agent_connected_entry ?ground_scout ?entry_point)
        (agent_connected_exit ?ranged_scout ?exit_point)
        (entry_marked_supplemental ?entry_point)
        (exit_marked_confirmed ?exit_point)
        (not
          (ground_probe_confirmed ?ground_scout)
        )
        (ranged_probe_confirmed ?ranged_scout)
        (route_plan_slot_available ?proposed_route)
      )
    :effect
      (and
        (route_plan_materialized ?proposed_route)
        (route_has_entry ?proposed_route ?entry_point)
        (route_has_exit ?proposed_route ?exit_point)
        (route_flag_quality_low ?proposed_route)
        (not
          (route_plan_slot_available ?proposed_route)
        )
      )
  )
  (:action synthesize_route_proposal_high_quality
    :parameters (?ground_scout - ground_scout ?ranged_scout - ranged_scout ?entry_point - entry_point ?exit_point - exit_point ?proposed_route - proposed_route)
    :precondition
      (and
        (ground_agent_probe_ready ?ground_scout)
        (ranged_agent_probe_ready ?ranged_scout)
        (agent_connected_entry ?ground_scout ?entry_point)
        (agent_connected_exit ?ranged_scout ?exit_point)
        (entry_marked_confirmed ?entry_point)
        (exit_marked_supplemental ?exit_point)
        (ground_probe_confirmed ?ground_scout)
        (not
          (ranged_probe_confirmed ?ranged_scout)
        )
        (route_plan_slot_available ?proposed_route)
      )
    :effect
      (and
        (route_plan_materialized ?proposed_route)
        (route_has_entry ?proposed_route ?entry_point)
        (route_has_exit ?proposed_route ?exit_point)
        (route_flag_quality_high ?proposed_route)
        (not
          (route_plan_slot_available ?proposed_route)
        )
      )
  )
  (:action synthesize_route_proposal_both_quality_flags
    :parameters (?ground_scout - ground_scout ?ranged_scout - ranged_scout ?entry_point - entry_point ?exit_point - exit_point ?proposed_route - proposed_route)
    :precondition
      (and
        (ground_agent_probe_ready ?ground_scout)
        (ranged_agent_probe_ready ?ranged_scout)
        (agent_connected_entry ?ground_scout ?entry_point)
        (agent_connected_exit ?ranged_scout ?exit_point)
        (entry_marked_supplemental ?entry_point)
        (exit_marked_supplemental ?exit_point)
        (not
          (ground_probe_confirmed ?ground_scout)
        )
        (not
          (ranged_probe_confirmed ?ranged_scout)
        )
        (route_plan_slot_available ?proposed_route)
      )
    :effect
      (and
        (route_plan_materialized ?proposed_route)
        (route_has_entry ?proposed_route ?entry_point)
        (route_has_exit ?proposed_route ?exit_point)
        (route_flag_quality_low ?proposed_route)
        (route_flag_quality_high ?proposed_route)
        (not
          (route_plan_slot_available ?proposed_route)
        )
      )
  )
  (:action confirm_route_for_materialization
    :parameters (?proposed_route - proposed_route ?ground_scout - ground_scout ?recon_report - recon_report)
    :precondition
      (and
        (route_plan_materialized ?proposed_route)
        (ground_agent_probe_ready ?ground_scout)
        (entity_supports_recon ?ground_scout ?recon_report)
        (not
          (route_confirmed_for_materialization ?proposed_route)
        )
      )
    :effect (route_confirmed_for_materialization ?proposed_route)
  )
  (:action attach_map_fragment_to_controller
    :parameters (?sector_controller - sector_controller ?map_fragment - map_fragment ?proposed_route - proposed_route)
    :precondition
      (and
        (entity_scouted ?sector_controller)
        (controller_owns_route ?sector_controller ?proposed_route)
        (controller_has_fragment_slot ?sector_controller ?map_fragment)
        (map_fragment_available ?map_fragment)
        (route_plan_materialized ?proposed_route)
        (route_confirmed_for_materialization ?proposed_route)
        (not
          (fragment_attached ?map_fragment)
        )
      )
    :effect
      (and
        (fragment_attached ?map_fragment)
        (fragment_linked_route ?map_fragment ?proposed_route)
        (not
          (map_fragment_available ?map_fragment)
        )
      )
  )
  (:action mark_controller_validation_step1
    :parameters (?sector_controller - sector_controller ?map_fragment - map_fragment ?proposed_route - proposed_route ?recon_report - recon_report)
    :precondition
      (and
        (entity_scouted ?sector_controller)
        (controller_has_fragment_slot ?sector_controller ?map_fragment)
        (fragment_attached ?map_fragment)
        (fragment_linked_route ?map_fragment ?proposed_route)
        (entity_supports_recon ?sector_controller ?recon_report)
        (not
          (route_flag_quality_low ?proposed_route)
        )
        (not
          (controller_validation_step1_complete ?sector_controller)
        )
      )
    :effect (controller_validation_step1_complete ?sector_controller)
  )
  (:action attach_landmark_marker_to_controller
    :parameters (?sector_controller - sector_controller ?landmark_token - landmark_marker)
    :precondition
      (and
        (entity_scouted ?sector_controller)
        (landmark_marker_available ?landmark_token)
        (not
          (landmark_attached_flag ?sector_controller)
        )
      )
    :effect
      (and
        (landmark_attached_flag ?sector_controller)
        (controller_has_landmark_marker ?sector_controller ?landmark_token)
        (not
          (landmark_marker_available ?landmark_token)
        )
      )
  )
  (:action prepare_controller_with_landmark_marker_and_fragment
    :parameters (?sector_controller - sector_controller ?map_fragment - map_fragment ?proposed_route - proposed_route ?recon_report - recon_report ?landmark_token - landmark_marker)
    :precondition
      (and
        (entity_scouted ?sector_controller)
        (controller_has_fragment_slot ?sector_controller ?map_fragment)
        (fragment_attached ?map_fragment)
        (fragment_linked_route ?map_fragment ?proposed_route)
        (entity_supports_recon ?sector_controller ?recon_report)
        (route_flag_quality_low ?proposed_route)
        (landmark_attached_flag ?sector_controller)
        (controller_has_landmark_marker ?sector_controller ?landmark_token)
        (not
          (controller_validation_step1_complete ?sector_controller)
        )
      )
    :effect
      (and
        (controller_validation_step1_complete ?sector_controller)
        (controller_used_landmark ?sector_controller)
      )
  )
  (:action assign_equipment_and_prepare_controller
    :parameters (?sector_controller - sector_controller ?equipment_module - equipment_module ?device_unit - device_unit ?map_fragment - map_fragment ?proposed_route - proposed_route)
    :precondition
      (and
        (controller_validation_step1_complete ?sector_controller)
        (controller_has_equipment ?sector_controller ?equipment_module)
        (entity_has_device ?sector_controller ?device_unit)
        (controller_has_fragment_slot ?sector_controller ?map_fragment)
        (fragment_linked_route ?map_fragment ?proposed_route)
        (not
          (route_flag_quality_high ?proposed_route)
        )
        (not
          (controller_validation_step2_ready ?sector_controller)
        )
      )
    :effect (controller_validation_step2_ready ?sector_controller)
  )
  (:action assign_equipment_with_route_flag_and_prepare_controller
    :parameters (?sector_controller - sector_controller ?equipment_module - equipment_module ?device_unit - device_unit ?map_fragment - map_fragment ?proposed_route - proposed_route)
    :precondition
      (and
        (controller_validation_step1_complete ?sector_controller)
        (controller_has_equipment ?sector_controller ?equipment_module)
        (entity_has_device ?sector_controller ?device_unit)
        (controller_has_fragment_slot ?sector_controller ?map_fragment)
        (fragment_linked_route ?map_fragment ?proposed_route)
        (route_flag_quality_high ?proposed_route)
        (not
          (controller_validation_step2_ready ?sector_controller)
        )
      )
    :effect (controller_validation_step2_ready ?sector_controller)
  )
  (:action apply_modifier_to_controller
    :parameters (?sector_controller - sector_controller ?modifier_chip - modifier_chip ?map_fragment - map_fragment ?proposed_route - proposed_route)
    :precondition
      (and
        (controller_validation_step2_ready ?sector_controller)
        (controller_has_modifier ?sector_controller ?modifier_chip)
        (controller_has_fragment_slot ?sector_controller ?map_fragment)
        (fragment_linked_route ?map_fragment ?proposed_route)
        (not
          (route_flag_quality_low ?proposed_route)
        )
        (not
          (route_flag_quality_high ?proposed_route)
        )
        (not
          (controller_ready_for_finalization ?sector_controller)
        )
      )
    :effect (controller_ready_for_finalization ?sector_controller)
  )
  (:action apply_modifier_and_mark_modules_present_low_quality
    :parameters (?sector_controller - sector_controller ?modifier_chip - modifier_chip ?map_fragment - map_fragment ?proposed_route - proposed_route)
    :precondition
      (and
        (controller_validation_step2_ready ?sector_controller)
        (controller_has_modifier ?sector_controller ?modifier_chip)
        (controller_has_fragment_slot ?sector_controller ?map_fragment)
        (fragment_linked_route ?map_fragment ?proposed_route)
        (route_flag_quality_low ?proposed_route)
        (not
          (route_flag_quality_high ?proposed_route)
        )
        (not
          (controller_ready_for_finalization ?sector_controller)
        )
      )
    :effect
      (and
        (controller_ready_for_finalization ?sector_controller)
        (controller_has_required_modules ?sector_controller)
      )
  )
  (:action apply_modifier_and_mark_modules_present_high_quality
    :parameters (?sector_controller - sector_controller ?modifier_chip - modifier_chip ?map_fragment - map_fragment ?proposed_route - proposed_route)
    :precondition
      (and
        (controller_validation_step2_ready ?sector_controller)
        (controller_has_modifier ?sector_controller ?modifier_chip)
        (controller_has_fragment_slot ?sector_controller ?map_fragment)
        (fragment_linked_route ?map_fragment ?proposed_route)
        (not
          (route_flag_quality_low ?proposed_route)
        )
        (route_flag_quality_high ?proposed_route)
        (not
          (controller_ready_for_finalization ?sector_controller)
        )
      )
    :effect
      (and
        (controller_ready_for_finalization ?sector_controller)
        (controller_has_required_modules ?sector_controller)
      )
  )
  (:action apply_modifier_and_mark_modules_present_both_flags
    :parameters (?sector_controller - sector_controller ?modifier_chip - modifier_chip ?map_fragment - map_fragment ?proposed_route - proposed_route)
    :precondition
      (and
        (controller_validation_step2_ready ?sector_controller)
        (controller_has_modifier ?sector_controller ?modifier_chip)
        (controller_has_fragment_slot ?sector_controller ?map_fragment)
        (fragment_linked_route ?map_fragment ?proposed_route)
        (route_flag_quality_low ?proposed_route)
        (route_flag_quality_high ?proposed_route)
        (not
          (controller_ready_for_finalization ?sector_controller)
        )
      )
    :effect
      (and
        (controller_ready_for_finalization ?sector_controller)
        (controller_has_required_modules ?sector_controller)
      )
  )
  (:action finalize_controller_for_unlock
    :parameters (?sector_controller - sector_controller)
    :precondition
      (and
        (controller_ready_for_finalization ?sector_controller)
        (not
          (controller_has_required_modules ?sector_controller)
        )
        (not
          (controller_activation_flag ?sector_controller)
        )
      )
    :effect
      (and
        (controller_activation_flag ?sector_controller)
        (finalized_for_unlock ?sector_controller)
      )
  )
  (:action attach_upgrade_module_to_controller
    :parameters (?sector_controller - sector_controller ?upgrade_module - upgrade_module)
    :precondition
      (and
        (controller_ready_for_finalization ?sector_controller)
        (controller_has_required_modules ?sector_controller)
        (upgrade_module_available ?upgrade_module)
      )
    :effect
      (and
        (controller_has_upgrade ?sector_controller ?upgrade_module)
        (not
          (upgrade_module_available ?upgrade_module)
        )
      )
  )
  (:action finalize_controller_checks
    :parameters (?sector_controller - sector_controller ?ground_scout - ground_scout ?ranged_scout - ranged_scout ?recon_report - recon_report ?upgrade_module - upgrade_module)
    :precondition
      (and
        (controller_ready_for_finalization ?sector_controller)
        (controller_has_required_modules ?sector_controller)
        (controller_has_upgrade ?sector_controller ?upgrade_module)
        (controller_has_ground_agent ?sector_controller ?ground_scout)
        (controller_has_ranged_agent ?sector_controller ?ranged_scout)
        (ground_probe_confirmed ?ground_scout)
        (ranged_probe_confirmed ?ranged_scout)
        (entity_supports_recon ?sector_controller ?recon_report)
        (not
          (controller_finalized ?sector_controller)
        )
      )
    :effect (controller_finalized ?sector_controller)
  )
  (:action activate_controller_after_finalization
    :parameters (?sector_controller - sector_controller)
    :precondition
      (and
        (controller_ready_for_finalization ?sector_controller)
        (controller_finalized ?sector_controller)
        (not
          (controller_activation_flag ?sector_controller)
        )
      )
    :effect
      (and
        (controller_activation_flag ?sector_controller)
        (finalized_for_unlock ?sector_controller)
      )
  )
  (:action process_landmark_annotation_for_controller_state1
    :parameters (?sector_controller - sector_controller ?annotation_tag - landmark_annotation ?recon_report - recon_report)
    :precondition
      (and
        (entity_scouted ?sector_controller)
        (entity_supports_recon ?sector_controller ?recon_report)
        (landmark_annotation_available ?annotation_tag)
        (controller_bound_landmark_annotation ?sector_controller ?annotation_tag)
        (not
          (controller_landmark_state1 ?sector_controller)
        )
      )
    :effect
      (and
        (controller_landmark_state1 ?sector_controller)
        (not
          (landmark_annotation_available ?annotation_tag)
        )
      )
  )
  (:action advance_controller_landmark_state2
    :parameters (?sector_controller - sector_controller ?device_unit - device_unit)
    :precondition
      (and
        (controller_landmark_state1 ?sector_controller)
        (entity_has_device ?sector_controller ?device_unit)
        (not
          (controller_landmark_state2 ?sector_controller)
        )
      )
    :effect (controller_landmark_state2 ?sector_controller)
  )
  (:action advance_controller_landmark_state3
    :parameters (?sector_controller - sector_controller ?modifier_chip - modifier_chip)
    :precondition
      (and
        (controller_landmark_state2 ?sector_controller)
        (controller_has_modifier ?sector_controller ?modifier_chip)
        (not
          (controller_landmark_state3 ?sector_controller)
        )
      )
    :effect (controller_landmark_state3 ?sector_controller)
  )
  (:action finalize_landmark_activation
    :parameters (?sector_controller - sector_controller)
    :precondition
      (and
        (controller_landmark_state3 ?sector_controller)
        (not
          (controller_activation_flag ?sector_controller)
        )
      )
    :effect
      (and
        (controller_activation_flag ?sector_controller)
        (finalized_for_unlock ?sector_controller)
      )
  )
  (:action finalize_ground_scout_for_unlock
    :parameters (?ground_scout - ground_scout ?proposed_route - proposed_route)
    :precondition
      (and
        (ground_agent_probe_ready ?ground_scout)
        (ground_probe_confirmed ?ground_scout)
        (route_plan_materialized ?proposed_route)
        (route_confirmed_for_materialization ?proposed_route)
        (not
          (finalized_for_unlock ?ground_scout)
        )
      )
    :effect (finalized_for_unlock ?ground_scout)
  )
  (:action finalize_ranged_scout_for_unlock
    :parameters (?ranged_scout - ranged_scout ?proposed_route - proposed_route)
    :precondition
      (and
        (ranged_agent_probe_ready ?ranged_scout)
        (ranged_probe_confirmed ?ranged_scout)
        (route_plan_materialized ?proposed_route)
        (route_confirmed_for_materialization ?proposed_route)
        (not
          (finalized_for_unlock ?ranged_scout)
        )
      )
    :effect (finalized_for_unlock ?ranged_scout)
  )
  (:action bind_return_beacon_to_site
    :parameters (?site_node - site_node ?return_beacon - return_beacon ?recon_report - recon_report)
    :precondition
      (and
        (finalized_for_unlock ?site_node)
        (entity_supports_recon ?site_node ?recon_report)
        (beacon_available ?return_beacon)
        (not
          (unlock_binding_ready ?site_node)
        )
      )
    :effect
      (and
        (unlock_binding_ready ?site_node)
        (entity_bound_beacon ?site_node ?return_beacon)
        (not
          (beacon_available ?return_beacon)
        )
      )
  )
  (:action perform_unlock_using_ground_scout
    :parameters (?ground_scout - ground_scout ?route_candidate_token - route_candidate_token ?return_beacon - return_beacon)
    :precondition
      (and
        (unlock_binding_ready ?ground_scout)
        (entity_has_candidate ?ground_scout ?route_candidate_token)
        (entity_bound_beacon ?ground_scout ?return_beacon)
        (not
          (entity_unblocked ?ground_scout)
        )
      )
    :effect
      (and
        (entity_unblocked ?ground_scout)
        (candidate_available ?route_candidate_token)
        (beacon_available ?return_beacon)
      )
  )
  (:action perform_unlock_using_ranged_scout
    :parameters (?ranged_scout - ranged_scout ?route_candidate_token - route_candidate_token ?return_beacon - return_beacon)
    :precondition
      (and
        (unlock_binding_ready ?ranged_scout)
        (entity_has_candidate ?ranged_scout ?route_candidate_token)
        (entity_bound_beacon ?ranged_scout ?return_beacon)
        (not
          (entity_unblocked ?ranged_scout)
        )
      )
    :effect
      (and
        (entity_unblocked ?ranged_scout)
        (candidate_available ?route_candidate_token)
        (beacon_available ?return_beacon)
      )
  )
  (:action perform_unlock_using_controller
    :parameters (?sector_controller - sector_controller ?route_candidate_token - route_candidate_token ?return_beacon - return_beacon)
    :precondition
      (and
        (unlock_binding_ready ?sector_controller)
        (entity_has_candidate ?sector_controller ?route_candidate_token)
        (entity_bound_beacon ?sector_controller ?return_beacon)
        (not
          (entity_unblocked ?sector_controller)
        )
      )
    :effect
      (and
        (entity_unblocked ?sector_controller)
        (candidate_available ?route_candidate_token)
        (beacon_available ?return_beacon)
      )
  )
)

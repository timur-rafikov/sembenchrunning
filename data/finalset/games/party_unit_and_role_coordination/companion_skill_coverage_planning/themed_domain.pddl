(define (domain companion_skill_coverage_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types companion_asset_type - object resource_type - object point_type - object companion_base_type - object companion_candidate - companion_base_type role_token - companion_asset_type skill - companion_asset_type equipment - companion_asset_type buff_card - companion_asset_type trait_module - companion_asset_type resource_marker - companion_asset_type equipment_upgrade - companion_asset_type signature_talent - companion_asset_type consumable - resource_type support_node - resource_type bond_modifier - resource_type encounter_point_frontline - point_type encounter_point_rearguard - point_type tactic_slot - point_type frontline_slot_type - companion_candidate rearguard_slot_type - companion_candidate frontline_companion - frontline_slot_type rearguard_companion - frontline_slot_type planner_agent - rearguard_slot_type)
  (:predicates
    (candidate_selected ?companion_candidate - companion_candidate)
    (actor_role_confirmed ?companion_candidate - companion_candidate)
    (role_assigned ?companion_candidate - companion_candidate)
    (actor_deployed ?companion_candidate - companion_candidate)
    (actor_deployment_configured ?companion_candidate - companion_candidate)
    (deployment_approved ?companion_candidate - companion_candidate)
    (role_token_available ?role_token - role_token)
    (role_token_assigned ?companion_candidate - companion_candidate ?role_token - role_token)
    (skill_available ?skill - skill)
    (actor_has_skill ?companion_candidate - companion_candidate ?skill - skill)
    (equipment_available ?equipment - equipment)
    (equipment_assigned ?companion_candidate - companion_candidate ?equipment - equipment)
    (consumable_available ?consumable - consumable)
    (consumable_assigned_frontline ?frontline_companion - frontline_companion ?consumable - consumable)
    (consumable_assigned_rearguard ?rearguard_companion - rearguard_companion ?consumable - consumable)
    (frontline_assigned_point ?frontline_companion - frontline_companion ?encounter_point_frontline - encounter_point_frontline)
    (frontline_point_marked ?encounter_point_frontline - encounter_point_frontline)
    (frontline_point_consumed ?encounter_point_frontline - encounter_point_frontline)
    (frontline_claimed ?frontline_companion - frontline_companion)
    (rearguard_assigned_point ?rearguard_companion - rearguard_companion ?encounter_point_rearguard - encounter_point_rearguard)
    (rearguard_point_marked ?encounter_point_rearguard - encounter_point_rearguard)
    (rearguard_point_consumed ?encounter_point_rearguard - encounter_point_rearguard)
    (rearguard_claimed ?rearguard_companion - rearguard_companion)
    (tactic_slot_available ?tactic_slot - tactic_slot)
    (tactic_slot_committed ?tactic_slot - tactic_slot)
    (tactic_slot_link_frontline_point ?tactic_slot - tactic_slot ?encounter_point_frontline - encounter_point_frontline)
    (tactic_slot_link_rearguard_point ?tactic_slot - tactic_slot ?encounter_point_rearguard - encounter_point_rearguard)
    (tactic_slot_flag_a ?tactic_slot - tactic_slot)
    (tactic_slot_flag_b ?tactic_slot - tactic_slot)
    (tactic_slot_activated ?tactic_slot - tactic_slot)
    (planner_link_frontline_companion ?planner_agent - planner_agent ?frontline_companion - frontline_companion)
    (planner_link_rearguard_companion ?planner_agent - planner_agent ?rearguard_companion - rearguard_companion)
    (planner_link_tactic_slot ?planner_agent - planner_agent ?tactic_slot - tactic_slot)
    (support_node_available ?support_node - support_node)
    (planner_link_support_node ?planner_agent - planner_agent ?support_node - support_node)
    (support_node_activated ?support_node - support_node)
    (support_node_linked_to_tactic ?support_node - support_node ?tactic_slot - tactic_slot)
    (planner_stage_one_complete ?planner_agent - planner_agent)
    (planner_stage_two_complete ?planner_agent - planner_agent)
    (planner_stage_three_complete ?planner_agent - planner_agent)
    (planner_consumed_buff ?planner_agent - planner_agent)
    (planner_flag_after_buff ?planner_agent - planner_agent)
    (planner_trait_applied ?planner_agent - planner_agent)
    (planner_upgrade_applied ?planner_agent - planner_agent)
    (bond_modifier_available ?bond_modifier - bond_modifier)
    (planner_link_bond_modifier ?planner_agent - planner_agent ?bond_modifier - bond_modifier)
    (planner_bond_applied ?planner_agent - planner_agent)
    (planner_bond_stage_ready ?planner_agent - planner_agent)
    (planner_signature_prepared ?planner_agent - planner_agent)
    (buff_card_available ?buff_card - buff_card)
    (planner_consumed_buff_card ?planner_agent - planner_agent ?buff_card - buff_card)
    (trait_module_available ?trait_module - trait_module)
    (planner_consumed_trait_module ?planner_agent - planner_agent ?trait_module - trait_module)
    (equipment_upgrade_available ?equipment_upgrade - equipment_upgrade)
    (planner_applied_equipment_upgrade ?planner_agent - planner_agent ?equipment_upgrade - equipment_upgrade)
    (signature_talent_available ?signature_talent - signature_talent)
    (planner_applied_signature_talent ?planner_agent - planner_agent ?signature_talent - signature_talent)
    (resource_marker_available ?resource_marker - resource_marker)
    (resource_marker_assigned ?companion_candidate - companion_candidate ?resource_marker - resource_marker)
    (frontline_ready_for_tactic ?frontline_companion - frontline_companion)
    (rearguard_ready_for_tactic ?rearguard_companion - rearguard_companion)
    (planner_committed ?planner_agent - planner_agent)
  )
  (:action select_companion_candidate
    :parameters (?companion_candidate - companion_candidate)
    :precondition
      (and
        (not
          (candidate_selected ?companion_candidate)
        )
        (not
          (actor_deployed ?companion_candidate)
        )
      )
    :effect (candidate_selected ?companion_candidate)
  )
  (:action assign_role_token
    :parameters (?companion_candidate - companion_candidate ?role_token - role_token)
    :precondition
      (and
        (candidate_selected ?companion_candidate)
        (not
          (role_assigned ?companion_candidate)
        )
        (role_token_available ?role_token)
      )
    :effect
      (and
        (role_assigned ?companion_candidate)
        (role_token_assigned ?companion_candidate ?role_token)
        (not
          (role_token_available ?role_token)
        )
      )
  )
  (:action validate_candidate_skill
    :parameters (?companion_candidate - companion_candidate ?skill - skill)
    :precondition
      (and
        (candidate_selected ?companion_candidate)
        (role_assigned ?companion_candidate)
        (skill_available ?skill)
      )
    :effect
      (and
        (actor_has_skill ?companion_candidate ?skill)
        (not
          (skill_available ?skill)
        )
      )
  )
  (:action confirm_candidate_role
    :parameters (?companion_candidate - companion_candidate ?skill - skill)
    :precondition
      (and
        (candidate_selected ?companion_candidate)
        (role_assigned ?companion_candidate)
        (actor_has_skill ?companion_candidate ?skill)
        (not
          (actor_role_confirmed ?companion_candidate)
        )
      )
    :effect (actor_role_confirmed ?companion_candidate)
  )
  (:action release_candidate_skill
    :parameters (?companion_candidate - companion_candidate ?skill - skill)
    :precondition
      (and
        (actor_has_skill ?companion_candidate ?skill)
      )
    :effect
      (and
        (skill_available ?skill)
        (not
          (actor_has_skill ?companion_candidate ?skill)
        )
      )
  )
  (:action attach_equipment
    :parameters (?companion_candidate - companion_candidate ?equipment - equipment)
    :precondition
      (and
        (actor_role_confirmed ?companion_candidate)
        (equipment_available ?equipment)
      )
    :effect
      (and
        (equipment_assigned ?companion_candidate ?equipment)
        (not
          (equipment_available ?equipment)
        )
      )
  )
  (:action detach_equipment
    :parameters (?companion_candidate - companion_candidate ?equipment - equipment)
    :precondition
      (and
        (equipment_assigned ?companion_candidate ?equipment)
      )
    :effect
      (and
        (equipment_available ?equipment)
        (not
          (equipment_assigned ?companion_candidate ?equipment)
        )
      )
  )
  (:action apply_equipment_upgrade
    :parameters (?planner_agent - planner_agent ?equipment_upgrade - equipment_upgrade)
    :precondition
      (and
        (actor_role_confirmed ?planner_agent)
        (equipment_upgrade_available ?equipment_upgrade)
      )
    :effect
      (and
        (planner_applied_equipment_upgrade ?planner_agent ?equipment_upgrade)
        (not
          (equipment_upgrade_available ?equipment_upgrade)
        )
      )
  )
  (:action revoke_equipment_upgrade
    :parameters (?planner_agent - planner_agent ?equipment_upgrade - equipment_upgrade)
    :precondition
      (and
        (planner_applied_equipment_upgrade ?planner_agent ?equipment_upgrade)
      )
    :effect
      (and
        (equipment_upgrade_available ?equipment_upgrade)
        (not
          (planner_applied_equipment_upgrade ?planner_agent ?equipment_upgrade)
        )
      )
  )
  (:action bind_signature_talent
    :parameters (?planner_agent - planner_agent ?signature_talent - signature_talent)
    :precondition
      (and
        (actor_role_confirmed ?planner_agent)
        (signature_talent_available ?signature_talent)
      )
    :effect
      (and
        (planner_applied_signature_talent ?planner_agent ?signature_talent)
        (not
          (signature_talent_available ?signature_talent)
        )
      )
  )
  (:action release_signature_talent
    :parameters (?planner_agent - planner_agent ?signature_talent - signature_talent)
    :precondition
      (and
        (planner_applied_signature_talent ?planner_agent ?signature_talent)
      )
    :effect
      (and
        (signature_talent_available ?signature_talent)
        (not
          (planner_applied_signature_talent ?planner_agent ?signature_talent)
        )
      )
  )
  (:action claim_frontline_point
    :parameters (?frontline_companion - frontline_companion ?encounter_point_frontline - encounter_point_frontline ?skill - skill)
    :precondition
      (and
        (actor_role_confirmed ?frontline_companion)
        (actor_has_skill ?frontline_companion ?skill)
        (frontline_assigned_point ?frontline_companion ?encounter_point_frontline)
        (not
          (frontline_point_marked ?encounter_point_frontline)
        )
        (not
          (frontline_point_consumed ?encounter_point_frontline)
        )
      )
    :effect (frontline_point_marked ?encounter_point_frontline)
  )
  (:action prepare_frontline_companion
    :parameters (?frontline_companion - frontline_companion ?encounter_point_frontline - encounter_point_frontline ?equipment - equipment)
    :precondition
      (and
        (actor_role_confirmed ?frontline_companion)
        (equipment_assigned ?frontline_companion ?equipment)
        (frontline_assigned_point ?frontline_companion ?encounter_point_frontline)
        (frontline_point_marked ?encounter_point_frontline)
        (not
          (frontline_ready_for_tactic ?frontline_companion)
        )
      )
    :effect
      (and
        (frontline_ready_for_tactic ?frontline_companion)
        (frontline_claimed ?frontline_companion)
      )
  )
  (:action use_consumable_on_frontline_point
    :parameters (?frontline_companion - frontline_companion ?encounter_point_frontline - encounter_point_frontline ?consumable - consumable)
    :precondition
      (and
        (actor_role_confirmed ?frontline_companion)
        (frontline_assigned_point ?frontline_companion ?encounter_point_frontline)
        (consumable_available ?consumable)
        (not
          (frontline_ready_for_tactic ?frontline_companion)
        )
      )
    :effect
      (and
        (frontline_point_consumed ?encounter_point_frontline)
        (frontline_ready_for_tactic ?frontline_companion)
        (consumable_assigned_frontline ?frontline_companion ?consumable)
        (not
          (consumable_available ?consumable)
        )
      )
  )
  (:action finalize_frontline_coverage
    :parameters (?frontline_companion - frontline_companion ?encounter_point_frontline - encounter_point_frontline ?skill - skill ?consumable - consumable)
    :precondition
      (and
        (actor_role_confirmed ?frontline_companion)
        (actor_has_skill ?frontline_companion ?skill)
        (frontline_assigned_point ?frontline_companion ?encounter_point_frontline)
        (frontline_point_consumed ?encounter_point_frontline)
        (consumable_assigned_frontline ?frontline_companion ?consumable)
        (not
          (frontline_claimed ?frontline_companion)
        )
      )
    :effect
      (and
        (frontline_point_marked ?encounter_point_frontline)
        (frontline_claimed ?frontline_companion)
        (consumable_available ?consumable)
        (not
          (consumable_assigned_frontline ?frontline_companion ?consumable)
        )
      )
  )
  (:action claim_rearguard_point
    :parameters (?rearguard_companion - rearguard_companion ?encounter_point_rearguard - encounter_point_rearguard ?skill - skill)
    :precondition
      (and
        (actor_role_confirmed ?rearguard_companion)
        (actor_has_skill ?rearguard_companion ?skill)
        (rearguard_assigned_point ?rearguard_companion ?encounter_point_rearguard)
        (not
          (rearguard_point_marked ?encounter_point_rearguard)
        )
        (not
          (rearguard_point_consumed ?encounter_point_rearguard)
        )
      )
    :effect (rearguard_point_marked ?encounter_point_rearguard)
  )
  (:action prepare_rearguard_companion
    :parameters (?rearguard_companion - rearguard_companion ?encounter_point_rearguard - encounter_point_rearguard ?equipment - equipment)
    :precondition
      (and
        (actor_role_confirmed ?rearguard_companion)
        (equipment_assigned ?rearguard_companion ?equipment)
        (rearguard_assigned_point ?rearguard_companion ?encounter_point_rearguard)
        (rearguard_point_marked ?encounter_point_rearguard)
        (not
          (rearguard_ready_for_tactic ?rearguard_companion)
        )
      )
    :effect
      (and
        (rearguard_ready_for_tactic ?rearguard_companion)
        (rearguard_claimed ?rearguard_companion)
      )
  )
  (:action use_consumable_on_rearguard_point
    :parameters (?rearguard_companion - rearguard_companion ?encounter_point_rearguard - encounter_point_rearguard ?consumable - consumable)
    :precondition
      (and
        (actor_role_confirmed ?rearguard_companion)
        (rearguard_assigned_point ?rearguard_companion ?encounter_point_rearguard)
        (consumable_available ?consumable)
        (not
          (rearguard_ready_for_tactic ?rearguard_companion)
        )
      )
    :effect
      (and
        (rearguard_point_consumed ?encounter_point_rearguard)
        (rearguard_ready_for_tactic ?rearguard_companion)
        (consumable_assigned_rearguard ?rearguard_companion ?consumable)
        (not
          (consumable_available ?consumable)
        )
      )
  )
  (:action finalize_rearguard_coverage
    :parameters (?rearguard_companion - rearguard_companion ?encounter_point_rearguard - encounter_point_rearguard ?skill - skill ?consumable - consumable)
    :precondition
      (and
        (actor_role_confirmed ?rearguard_companion)
        (actor_has_skill ?rearguard_companion ?skill)
        (rearguard_assigned_point ?rearguard_companion ?encounter_point_rearguard)
        (rearguard_point_consumed ?encounter_point_rearguard)
        (consumable_assigned_rearguard ?rearguard_companion ?consumable)
        (not
          (rearguard_claimed ?rearguard_companion)
        )
      )
    :effect
      (and
        (rearguard_point_marked ?encounter_point_rearguard)
        (rearguard_claimed ?rearguard_companion)
        (consumable_available ?consumable)
        (not
          (consumable_assigned_rearguard ?rearguard_companion ?consumable)
        )
      )
  )
  (:action compose_tactic_from_coverage_primary
    :parameters (?frontline_companion - frontline_companion ?rearguard_companion - rearguard_companion ?encounter_point_frontline - encounter_point_frontline ?encounter_point_rearguard - encounter_point_rearguard ?tactic_slot - tactic_slot)
    :precondition
      (and
        (frontline_ready_for_tactic ?frontline_companion)
        (rearguard_ready_for_tactic ?rearguard_companion)
        (frontline_assigned_point ?frontline_companion ?encounter_point_frontline)
        (rearguard_assigned_point ?rearguard_companion ?encounter_point_rearguard)
        (frontline_point_marked ?encounter_point_frontline)
        (rearguard_point_marked ?encounter_point_rearguard)
        (frontline_claimed ?frontline_companion)
        (rearguard_claimed ?rearguard_companion)
        (tactic_slot_available ?tactic_slot)
      )
    :effect
      (and
        (tactic_slot_committed ?tactic_slot)
        (tactic_slot_link_frontline_point ?tactic_slot ?encounter_point_frontline)
        (tactic_slot_link_rearguard_point ?tactic_slot ?encounter_point_rearguard)
        (not
          (tactic_slot_available ?tactic_slot)
        )
      )
  )
  (:action compose_tactic_from_coverage_frontline_consumed
    :parameters (?frontline_companion - frontline_companion ?rearguard_companion - rearguard_companion ?encounter_point_frontline - encounter_point_frontline ?encounter_point_rearguard - encounter_point_rearguard ?tactic_slot - tactic_slot)
    :precondition
      (and
        (frontline_ready_for_tactic ?frontline_companion)
        (rearguard_ready_for_tactic ?rearguard_companion)
        (frontline_assigned_point ?frontline_companion ?encounter_point_frontline)
        (rearguard_assigned_point ?rearguard_companion ?encounter_point_rearguard)
        (frontline_point_consumed ?encounter_point_frontline)
        (rearguard_point_marked ?encounter_point_rearguard)
        (not
          (frontline_claimed ?frontline_companion)
        )
        (rearguard_claimed ?rearguard_companion)
        (tactic_slot_available ?tactic_slot)
      )
    :effect
      (and
        (tactic_slot_committed ?tactic_slot)
        (tactic_slot_link_frontline_point ?tactic_slot ?encounter_point_frontline)
        (tactic_slot_link_rearguard_point ?tactic_slot ?encounter_point_rearguard)
        (tactic_slot_flag_a ?tactic_slot)
        (not
          (tactic_slot_available ?tactic_slot)
        )
      )
  )
  (:action compose_tactic_from_coverage_rearguard_consumed
    :parameters (?frontline_companion - frontline_companion ?rearguard_companion - rearguard_companion ?encounter_point_frontline - encounter_point_frontline ?encounter_point_rearguard - encounter_point_rearguard ?tactic_slot - tactic_slot)
    :precondition
      (and
        (frontline_ready_for_tactic ?frontline_companion)
        (rearguard_ready_for_tactic ?rearguard_companion)
        (frontline_assigned_point ?frontline_companion ?encounter_point_frontline)
        (rearguard_assigned_point ?rearguard_companion ?encounter_point_rearguard)
        (frontline_point_marked ?encounter_point_frontline)
        (rearguard_point_consumed ?encounter_point_rearguard)
        (frontline_claimed ?frontline_companion)
        (not
          (rearguard_claimed ?rearguard_companion)
        )
        (tactic_slot_available ?tactic_slot)
      )
    :effect
      (and
        (tactic_slot_committed ?tactic_slot)
        (tactic_slot_link_frontline_point ?tactic_slot ?encounter_point_frontline)
        (tactic_slot_link_rearguard_point ?tactic_slot ?encounter_point_rearguard)
        (tactic_slot_flag_b ?tactic_slot)
        (not
          (tactic_slot_available ?tactic_slot)
        )
      )
  )
  (:action compose_tactic_from_coverage_both_consumed
    :parameters (?frontline_companion - frontline_companion ?rearguard_companion - rearguard_companion ?encounter_point_frontline - encounter_point_frontline ?encounter_point_rearguard - encounter_point_rearguard ?tactic_slot - tactic_slot)
    :precondition
      (and
        (frontline_ready_for_tactic ?frontline_companion)
        (rearguard_ready_for_tactic ?rearguard_companion)
        (frontline_assigned_point ?frontline_companion ?encounter_point_frontline)
        (rearguard_assigned_point ?rearguard_companion ?encounter_point_rearguard)
        (frontline_point_consumed ?encounter_point_frontline)
        (rearguard_point_consumed ?encounter_point_rearguard)
        (not
          (frontline_claimed ?frontline_companion)
        )
        (not
          (rearguard_claimed ?rearguard_companion)
        )
        (tactic_slot_available ?tactic_slot)
      )
    :effect
      (and
        (tactic_slot_committed ?tactic_slot)
        (tactic_slot_link_frontline_point ?tactic_slot ?encounter_point_frontline)
        (tactic_slot_link_rearguard_point ?tactic_slot ?encounter_point_rearguard)
        (tactic_slot_flag_a ?tactic_slot)
        (tactic_slot_flag_b ?tactic_slot)
        (not
          (tactic_slot_available ?tactic_slot)
        )
      )
  )
  (:action activate_tactic_slot
    :parameters (?tactic_slot - tactic_slot ?frontline_companion - frontline_companion ?skill - skill)
    :precondition
      (and
        (tactic_slot_committed ?tactic_slot)
        (frontline_ready_for_tactic ?frontline_companion)
        (actor_has_skill ?frontline_companion ?skill)
        (not
          (tactic_slot_activated ?tactic_slot)
        )
      )
    :effect (tactic_slot_activated ?tactic_slot)
  )
  (:action activate_support_node
    :parameters (?planner_agent - planner_agent ?support_node - support_node ?tactic_slot - tactic_slot)
    :precondition
      (and
        (actor_role_confirmed ?planner_agent)
        (planner_link_tactic_slot ?planner_agent ?tactic_slot)
        (planner_link_support_node ?planner_agent ?support_node)
        (support_node_available ?support_node)
        (tactic_slot_committed ?tactic_slot)
        (tactic_slot_activated ?tactic_slot)
        (not
          (support_node_activated ?support_node)
        )
      )
    :effect
      (and
        (support_node_activated ?support_node)
        (support_node_linked_to_tactic ?support_node ?tactic_slot)
        (not
          (support_node_available ?support_node)
        )
      )
  )
  (:action finalize_support_node_activation
    :parameters (?planner_agent - planner_agent ?support_node - support_node ?tactic_slot - tactic_slot ?skill - skill)
    :precondition
      (and
        (actor_role_confirmed ?planner_agent)
        (planner_link_support_node ?planner_agent ?support_node)
        (support_node_activated ?support_node)
        (support_node_linked_to_tactic ?support_node ?tactic_slot)
        (actor_has_skill ?planner_agent ?skill)
        (not
          (tactic_slot_flag_a ?tactic_slot)
        )
        (not
          (planner_stage_one_complete ?planner_agent)
        )
      )
    :effect (planner_stage_one_complete ?planner_agent)
  )
  (:action consume_buff_card
    :parameters (?planner_agent - planner_agent ?buff_card - buff_card)
    :precondition
      (and
        (actor_role_confirmed ?planner_agent)
        (buff_card_available ?buff_card)
        (not
          (planner_consumed_buff ?planner_agent)
        )
      )
    :effect
      (and
        (planner_consumed_buff ?planner_agent)
        (planner_consumed_buff_card ?planner_agent ?buff_card)
        (not
          (buff_card_available ?buff_card)
        )
      )
  )
  (:action apply_buff_sequence
    :parameters (?planner_agent - planner_agent ?support_node - support_node ?tactic_slot - tactic_slot ?skill - skill ?buff_card - buff_card)
    :precondition
      (and
        (actor_role_confirmed ?planner_agent)
        (planner_link_support_node ?planner_agent ?support_node)
        (support_node_activated ?support_node)
        (support_node_linked_to_tactic ?support_node ?tactic_slot)
        (actor_has_skill ?planner_agent ?skill)
        (tactic_slot_flag_a ?tactic_slot)
        (planner_consumed_buff ?planner_agent)
        (planner_consumed_buff_card ?planner_agent ?buff_card)
        (not
          (planner_stage_one_complete ?planner_agent)
        )
      )
    :effect
      (and
        (planner_stage_one_complete ?planner_agent)
        (planner_flag_after_buff ?planner_agent)
      )
  )
  (:action apply_upgrade_stage_one
    :parameters (?planner_agent - planner_agent ?equipment_upgrade - equipment_upgrade ?equipment - equipment ?support_node - support_node ?tactic_slot - tactic_slot)
    :precondition
      (and
        (planner_stage_one_complete ?planner_agent)
        (planner_applied_equipment_upgrade ?planner_agent ?equipment_upgrade)
        (equipment_assigned ?planner_agent ?equipment)
        (planner_link_support_node ?planner_agent ?support_node)
        (support_node_linked_to_tactic ?support_node ?tactic_slot)
        (not
          (tactic_slot_flag_b ?tactic_slot)
        )
        (not
          (planner_stage_two_complete ?planner_agent)
        )
      )
    :effect (planner_stage_two_complete ?planner_agent)
  )
  (:action apply_upgrade_stage_two
    :parameters (?planner_agent - planner_agent ?equipment_upgrade - equipment_upgrade ?equipment - equipment ?support_node - support_node ?tactic_slot - tactic_slot)
    :precondition
      (and
        (planner_stage_one_complete ?planner_agent)
        (planner_applied_equipment_upgrade ?planner_agent ?equipment_upgrade)
        (equipment_assigned ?planner_agent ?equipment)
        (planner_link_support_node ?planner_agent ?support_node)
        (support_node_linked_to_tactic ?support_node ?tactic_slot)
        (tactic_slot_flag_b ?tactic_slot)
        (not
          (planner_stage_two_complete ?planner_agent)
        )
      )
    :effect (planner_stage_two_complete ?planner_agent)
  )
  (:action apply_signature_precommit
    :parameters (?planner_agent - planner_agent ?signature_talent - signature_talent ?support_node - support_node ?tactic_slot - tactic_slot)
    :precondition
      (and
        (planner_stage_two_complete ?planner_agent)
        (planner_applied_signature_talent ?planner_agent ?signature_talent)
        (planner_link_support_node ?planner_agent ?support_node)
        (support_node_linked_to_tactic ?support_node ?tactic_slot)
        (not
          (tactic_slot_flag_a ?tactic_slot)
        )
        (not
          (tactic_slot_flag_b ?tactic_slot)
        )
        (not
          (planner_stage_three_complete ?planner_agent)
        )
      )
    :effect (planner_stage_three_complete ?planner_agent)
  )
  (:action apply_signature_with_flag_a
    :parameters (?planner_agent - planner_agent ?signature_talent - signature_talent ?support_node - support_node ?tactic_slot - tactic_slot)
    :precondition
      (and
        (planner_stage_two_complete ?planner_agent)
        (planner_applied_signature_talent ?planner_agent ?signature_talent)
        (planner_link_support_node ?planner_agent ?support_node)
        (support_node_linked_to_tactic ?support_node ?tactic_slot)
        (tactic_slot_flag_a ?tactic_slot)
        (not
          (tactic_slot_flag_b ?tactic_slot)
        )
        (not
          (planner_stage_three_complete ?planner_agent)
        )
      )
    :effect
      (and
        (planner_stage_three_complete ?planner_agent)
        (planner_trait_applied ?planner_agent)
      )
  )
  (:action apply_signature_with_flag_b
    :parameters (?planner_agent - planner_agent ?signature_talent - signature_talent ?support_node - support_node ?tactic_slot - tactic_slot)
    :precondition
      (and
        (planner_stage_two_complete ?planner_agent)
        (planner_applied_signature_talent ?planner_agent ?signature_talent)
        (planner_link_support_node ?planner_agent ?support_node)
        (support_node_linked_to_tactic ?support_node ?tactic_slot)
        (not
          (tactic_slot_flag_a ?tactic_slot)
        )
        (tactic_slot_flag_b ?tactic_slot)
        (not
          (planner_stage_three_complete ?planner_agent)
        )
      )
    :effect
      (and
        (planner_stage_three_complete ?planner_agent)
        (planner_trait_applied ?planner_agent)
      )
  )
  (:action apply_signature_with_flags_ab
    :parameters (?planner_agent - planner_agent ?signature_talent - signature_talent ?support_node - support_node ?tactic_slot - tactic_slot)
    :precondition
      (and
        (planner_stage_two_complete ?planner_agent)
        (planner_applied_signature_talent ?planner_agent ?signature_talent)
        (planner_link_support_node ?planner_agent ?support_node)
        (support_node_linked_to_tactic ?support_node ?tactic_slot)
        (tactic_slot_flag_a ?tactic_slot)
        (tactic_slot_flag_b ?tactic_slot)
        (not
          (planner_stage_three_complete ?planner_agent)
        )
      )
    :effect
      (and
        (planner_stage_three_complete ?planner_agent)
        (planner_trait_applied ?planner_agent)
      )
  )
  (:action commit_planner_sequence_basic
    :parameters (?planner_agent - planner_agent)
    :precondition
      (and
        (planner_stage_three_complete ?planner_agent)
        (not
          (planner_trait_applied ?planner_agent)
        )
        (not
          (planner_committed ?planner_agent)
        )
      )
    :effect
      (and
        (planner_committed ?planner_agent)
        (actor_deployment_configured ?planner_agent)
      )
  )
  (:action consume_trait_module
    :parameters (?planner_agent - planner_agent ?trait_module - trait_module)
    :precondition
      (and
        (planner_stage_three_complete ?planner_agent)
        (planner_trait_applied ?planner_agent)
        (trait_module_available ?trait_module)
      )
    :effect
      (and
        (planner_consumed_trait_module ?planner_agent ?trait_module)
        (not
          (trait_module_available ?trait_module)
        )
      )
  )
  (:action apply_planner_upgrade_sequence
    :parameters (?planner_agent - planner_agent ?frontline_companion - frontline_companion ?rearguard_companion - rearguard_companion ?skill - skill ?trait_module - trait_module)
    :precondition
      (and
        (planner_stage_three_complete ?planner_agent)
        (planner_trait_applied ?planner_agent)
        (planner_consumed_trait_module ?planner_agent ?trait_module)
        (planner_link_frontline_companion ?planner_agent ?frontline_companion)
        (planner_link_rearguard_companion ?planner_agent ?rearguard_companion)
        (frontline_claimed ?frontline_companion)
        (rearguard_claimed ?rearguard_companion)
        (actor_has_skill ?planner_agent ?skill)
        (not
          (planner_upgrade_applied ?planner_agent)
        )
      )
    :effect (planner_upgrade_applied ?planner_agent)
  )
  (:action commit_planner_sequence_with_upgrade
    :parameters (?planner_agent - planner_agent)
    :precondition
      (and
        (planner_stage_three_complete ?planner_agent)
        (planner_upgrade_applied ?planner_agent)
        (not
          (planner_committed ?planner_agent)
        )
      )
    :effect
      (and
        (planner_committed ?planner_agent)
        (actor_deployment_configured ?planner_agent)
      )
  )
  (:action apply_bond_modifier
    :parameters (?planner_agent - planner_agent ?bond_modifier - bond_modifier ?skill - skill)
    :precondition
      (and
        (actor_role_confirmed ?planner_agent)
        (actor_has_skill ?planner_agent ?skill)
        (bond_modifier_available ?bond_modifier)
        (planner_link_bond_modifier ?planner_agent ?bond_modifier)
        (not
          (planner_bond_applied ?planner_agent)
        )
      )
    :effect
      (and
        (planner_bond_applied ?planner_agent)
        (not
          (bond_modifier_available ?bond_modifier)
        )
      )
  )
  (:action prepare_bond_stage
    :parameters (?planner_agent - planner_agent ?equipment - equipment)
    :precondition
      (and
        (planner_bond_applied ?planner_agent)
        (equipment_assigned ?planner_agent ?equipment)
        (not
          (planner_bond_stage_ready ?planner_agent)
        )
      )
    :effect (planner_bond_stage_ready ?planner_agent)
  )
  (:action apply_signature_talent_for_bond
    :parameters (?planner_agent - planner_agent ?signature_talent - signature_talent)
    :precondition
      (and
        (planner_bond_stage_ready ?planner_agent)
        (planner_applied_signature_talent ?planner_agent ?signature_talent)
        (not
          (planner_signature_prepared ?planner_agent)
        )
      )
    :effect (planner_signature_prepared ?planner_agent)
  )
  (:action commit_planner_sequence_after_bond
    :parameters (?planner_agent - planner_agent)
    :precondition
      (and
        (planner_signature_prepared ?planner_agent)
        (not
          (planner_committed ?planner_agent)
        )
      )
    :effect
      (and
        (planner_committed ?planner_agent)
        (actor_deployment_configured ?planner_agent)
      )
  )
  (:action confirm_frontline_deployment_ready
    :parameters (?frontline_companion - frontline_companion ?tactic_slot - tactic_slot)
    :precondition
      (and
        (frontline_ready_for_tactic ?frontline_companion)
        (frontline_claimed ?frontline_companion)
        (tactic_slot_committed ?tactic_slot)
        (tactic_slot_activated ?tactic_slot)
        (not
          (actor_deployment_configured ?frontline_companion)
        )
      )
    :effect (actor_deployment_configured ?frontline_companion)
  )
  (:action confirm_rearguard_deployment_ready
    :parameters (?rearguard_companion - rearguard_companion ?tactic_slot - tactic_slot)
    :precondition
      (and
        (rearguard_ready_for_tactic ?rearguard_companion)
        (rearguard_claimed ?rearguard_companion)
        (tactic_slot_committed ?tactic_slot)
        (tactic_slot_activated ?tactic_slot)
        (not
          (actor_deployment_configured ?rearguard_companion)
        )
      )
    :effect (actor_deployment_configured ?rearguard_companion)
  )
  (:action assign_resource_marker_to_candidate
    :parameters (?companion_candidate - companion_candidate ?resource_marker - resource_marker ?skill - skill)
    :precondition
      (and
        (actor_deployment_configured ?companion_candidate)
        (actor_has_skill ?companion_candidate ?skill)
        (resource_marker_available ?resource_marker)
        (not
          (deployment_approved ?companion_candidate)
        )
      )
    :effect
      (and
        (deployment_approved ?companion_candidate)
        (resource_marker_assigned ?companion_candidate ?resource_marker)
        (not
          (resource_marker_available ?resource_marker)
        )
      )
  )
  (:action finalize_frontline_deployment
    :parameters (?frontline_companion - frontline_companion ?role_token - role_token ?resource_marker - resource_marker)
    :precondition
      (and
        (deployment_approved ?frontline_companion)
        (role_token_assigned ?frontline_companion ?role_token)
        (resource_marker_assigned ?frontline_companion ?resource_marker)
        (not
          (actor_deployed ?frontline_companion)
        )
      )
    :effect
      (and
        (actor_deployed ?frontline_companion)
        (role_token_available ?role_token)
        (resource_marker_available ?resource_marker)
      )
  )
  (:action finalize_rearguard_deployment
    :parameters (?rearguard_companion - rearguard_companion ?role_token - role_token ?resource_marker - resource_marker)
    :precondition
      (and
        (deployment_approved ?rearguard_companion)
        (role_token_assigned ?rearguard_companion ?role_token)
        (resource_marker_assigned ?rearguard_companion ?resource_marker)
        (not
          (actor_deployed ?rearguard_companion)
        )
      )
    :effect
      (and
        (actor_deployed ?rearguard_companion)
        (role_token_available ?role_token)
        (resource_marker_available ?resource_marker)
      )
  )
  (:action finalize_planner_deployment
    :parameters (?planner_agent - planner_agent ?role_token - role_token ?resource_marker - resource_marker)
    :precondition
      (and
        (deployment_approved ?planner_agent)
        (role_token_assigned ?planner_agent ?role_token)
        (resource_marker_assigned ?planner_agent ?resource_marker)
        (not
          (actor_deployed ?planner_agent)
        )
      )
    :effect
      (and
        (actor_deployed ?planner_agent)
        (role_token_available ?role_token)
        (resource_marker_available ?resource_marker)
      )
  )
)

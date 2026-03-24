(define (domain cooperative_ability_combo_sequencing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types unit_class_group - object position_class_group - object node_class_group - object generic_slot - object combat_unit_slot - generic_slot ability_token - unit_class_group ability_component - unit_class_group equipment_module - unit_class_group field_upgrade - unit_class_group synergy_modifier - unit_class_group recovery_resource - unit_class_group special_gadget_a - unit_class_group special_gadget_b - unit_class_group consumable_resource - position_class_group tactical_module - position_class_group priority_marker - position_class_group left_flank_node - node_class_group right_flank_node - node_class_group encounter_point - node_class_group slot_group_a - combat_unit_slot slot_group_b - combat_unit_slot strike_squad_member - slot_group_a support_squad_member - slot_group_a planner_slot - slot_group_b)
  (:predicates
    (slot_initialized ?combat_unit_slot - combat_unit_slot)
    (slot_primed ?combat_unit_slot - combat_unit_slot)
    (slot_token_bound ?combat_unit_slot - combat_unit_slot)
    (slot_reconfigured ?combat_unit_slot - combat_unit_slot)
    (combo_executed ?combat_unit_slot - combat_unit_slot)
    (slot_in_recovery ?combat_unit_slot - combat_unit_slot)
    (ability_token_available ?ability_token - ability_token)
    (slot_token_binding ?combat_unit_slot - combat_unit_slot ?ability_token - ability_token)
    (ability_component_available ?ability_component - ability_component)
    (slot_component_binding ?combat_unit_slot - combat_unit_slot ?ability_component - ability_component)
    (equipment_module_available ?equipment_module - equipment_module)
    (slot_equipped_with_module ?combat_unit_slot - combat_unit_slot ?equipment_module - equipment_module)
    (consumable_resource_available ?consumable_resource - consumable_resource)
    (strike_member_consumable_assigned ?strike_squad_member - strike_squad_member ?consumable_resource - consumable_resource)
    (support_member_consumable_assigned ?support_squad_member - support_squad_member ?consumable_resource - consumable_resource)
    (strike_member_left_flank_link ?strike_squad_member - strike_squad_member ?left_flank_node - left_flank_node)
    (left_flank_primary_marker ?left_flank_node - left_flank_node)
    (left_flank_secondary_marker ?left_flank_node - left_flank_node)
    (strike_member_payload_staged ?strike_squad_member - strike_squad_member)
    (support_member_right_flank_link ?support_squad_member - support_squad_member ?right_flank_node - right_flank_node)
    (right_flank_primary_marker ?right_flank_node - right_flank_node)
    (right_flank_secondary_marker ?right_flank_node - right_flank_node)
    (support_member_payload_staged ?support_squad_member - support_squad_member)
    (encounter_point_open ?encounter_point - encounter_point)
    (encounter_point_engaged ?encounter_point - encounter_point)
    (encounter_left_node_link ?encounter_point - encounter_point ?left_flank_node - left_flank_node)
    (encounter_right_node_link ?encounter_point - encounter_point ?right_flank_node - right_flank_node)
    (encounter_left_coverage ?encounter_point - encounter_point)
    (encounter_right_coverage ?encounter_point - encounter_point)
    (encounter_point_finalized ?encounter_point - encounter_point)
    (planner_strike_member_link ?planner_agent - planner_slot ?strike_squad_member - strike_squad_member)
    (planner_support_member_link ?planner_agent - planner_slot ?support_squad_member - support_squad_member)
    (planner_encounter_assignment ?planner_agent - planner_slot ?encounter_point - encounter_point)
    (tactical_module_available ?tactical_module - tactical_module)
    (planner_has_tactical_module ?planner_agent - planner_slot ?tactical_module - tactical_module)
    (tactical_module_installed ?tactical_module - tactical_module)
    (tactical_module_installed_on_encounter ?tactical_module - tactical_module ?encounter_point - encounter_point)
    (planner_module_armed ?planner_agent - planner_slot)
    (planner_module_primed ?planner_agent - planner_slot)
    (planner_module_confirmed ?planner_agent - planner_slot)
    (planner_upgrade_installed ?planner_agent - planner_slot)
    (planner_upgrade_armed ?planner_agent - planner_slot)
    (planner_synergy_enabled ?planner_agent - planner_slot)
    (planner_final_check_passed ?planner_agent - planner_slot)
    (priority_marker_available ?priority_marker - priority_marker)
    (planner_priority_marker_link ?planner_agent - planner_slot ?priority_marker - priority_marker)
    (planner_priority_applied ?planner_agent - planner_slot)
    (planner_priority_slot_armed ?planner_agent - planner_slot)
    (planner_priority_confirmed ?planner_agent - planner_slot)
    (field_upgrade_available ?field_upgrade - field_upgrade)
    (planner_field_upgrade_link ?planner_agent - planner_slot ?field_upgrade - field_upgrade)
    (synergy_modifier_available ?synergy_modifier - synergy_modifier)
    (planner_synergy_modifier_link ?planner_agent - planner_slot ?synergy_modifier - synergy_modifier)
    (special_gadget_a_available ?special_gadget_a - special_gadget_a)
    (planner_special_gadget_a_link ?planner_agent - planner_slot ?special_gadget_a - special_gadget_a)
    (special_gadget_b_available ?special_gadget_b - special_gadget_b)
    (planner_special_gadget_b_link ?planner_agent - planner_slot ?special_gadget_b - special_gadget_b)
    (recovery_resource_available ?recovery_resource - recovery_resource)
    (slot_recovery_binding ?combat_unit_slot - combat_unit_slot ?recovery_resource - recovery_resource)
    (strike_member_stage_flag ?strike_squad_member - strike_squad_member)
    (support_member_stage_flag ?support_squad_member - support_squad_member)
    (planner_signoff ?planner_agent - planner_slot)
  )
  (:action initialize_combat_slot
    :parameters (?combat_unit_slot - combat_unit_slot)
    :precondition
      (and
        (not
          (slot_initialized ?combat_unit_slot)
        )
        (not
          (slot_reconfigured ?combat_unit_slot)
        )
      )
    :effect (slot_initialized ?combat_unit_slot)
  )
  (:action assign_ability_token
    :parameters (?combat_unit_slot - combat_unit_slot ?ability_token - ability_token)
    :precondition
      (and
        (slot_initialized ?combat_unit_slot)
        (not
          (slot_token_bound ?combat_unit_slot)
        )
        (ability_token_available ?ability_token)
      )
    :effect
      (and
        (slot_token_bound ?combat_unit_slot)
        (slot_token_binding ?combat_unit_slot ?ability_token)
        (not
          (ability_token_available ?ability_token)
        )
      )
  )
  (:action attach_ability_component
    :parameters (?combat_unit_slot - combat_unit_slot ?ability_component - ability_component)
    :precondition
      (and
        (slot_initialized ?combat_unit_slot)
        (slot_token_bound ?combat_unit_slot)
        (ability_component_available ?ability_component)
      )
    :effect
      (and
        (slot_component_binding ?combat_unit_slot ?ability_component)
        (not
          (ability_component_available ?ability_component)
        )
      )
  )
  (:action prime_slot_for_combo
    :parameters (?combat_unit_slot - combat_unit_slot ?ability_component - ability_component)
    :precondition
      (and
        (slot_initialized ?combat_unit_slot)
        (slot_token_bound ?combat_unit_slot)
        (slot_component_binding ?combat_unit_slot ?ability_component)
        (not
          (slot_primed ?combat_unit_slot)
        )
      )
    :effect (slot_primed ?combat_unit_slot)
  )
  (:action release_ability_component
    :parameters (?combat_unit_slot - combat_unit_slot ?ability_component - ability_component)
    :precondition
      (and
        (slot_component_binding ?combat_unit_slot ?ability_component)
      )
    :effect
      (and
        (ability_component_available ?ability_component)
        (not
          (slot_component_binding ?combat_unit_slot ?ability_component)
        )
      )
  )
  (:action attach_equipment_module
    :parameters (?combat_unit_slot - combat_unit_slot ?equipment_module - equipment_module)
    :precondition
      (and
        (slot_primed ?combat_unit_slot)
        (equipment_module_available ?equipment_module)
      )
    :effect
      (and
        (slot_equipped_with_module ?combat_unit_slot ?equipment_module)
        (not
          (equipment_module_available ?equipment_module)
        )
      )
  )
  (:action detach_equipment_module
    :parameters (?combat_unit_slot - combat_unit_slot ?equipment_module - equipment_module)
    :precondition
      (and
        (slot_equipped_with_module ?combat_unit_slot ?equipment_module)
      )
    :effect
      (and
        (equipment_module_available ?equipment_module)
        (not
          (slot_equipped_with_module ?combat_unit_slot ?equipment_module)
        )
      )
  )
  (:action planner_assign_special_gadget_a
    :parameters (?planner_agent - planner_slot ?special_gadget_a - special_gadget_a)
    :precondition
      (and
        (slot_primed ?planner_agent)
        (special_gadget_a_available ?special_gadget_a)
      )
    :effect
      (and
        (planner_special_gadget_a_link ?planner_agent ?special_gadget_a)
        (not
          (special_gadget_a_available ?special_gadget_a)
        )
      )
  )
  (:action planner_remove_special_gadget_a
    :parameters (?planner_agent - planner_slot ?special_gadget_a - special_gadget_a)
    :precondition
      (and
        (planner_special_gadget_a_link ?planner_agent ?special_gadget_a)
      )
    :effect
      (and
        (special_gadget_a_available ?special_gadget_a)
        (not
          (planner_special_gadget_a_link ?planner_agent ?special_gadget_a)
        )
      )
  )
  (:action planner_assign_special_gadget_b
    :parameters (?planner_agent - planner_slot ?special_gadget_b - special_gadget_b)
    :precondition
      (and
        (slot_primed ?planner_agent)
        (special_gadget_b_available ?special_gadget_b)
      )
    :effect
      (and
        (planner_special_gadget_b_link ?planner_agent ?special_gadget_b)
        (not
          (special_gadget_b_available ?special_gadget_b)
        )
      )
  )
  (:action planner_remove_special_gadget_b
    :parameters (?planner_agent - planner_slot ?special_gadget_b - special_gadget_b)
    :precondition
      (and
        (planner_special_gadget_b_link ?planner_agent ?special_gadget_b)
      )
    :effect
      (and
        (special_gadget_b_available ?special_gadget_b)
        (not
          (planner_special_gadget_b_link ?planner_agent ?special_gadget_b)
        )
      )
  )
  (:action stage_left_flank_primary
    :parameters (?strike_squad_member - strike_squad_member ?left_flank_node - left_flank_node ?ability_component - ability_component)
    :precondition
      (and
        (slot_primed ?strike_squad_member)
        (slot_component_binding ?strike_squad_member ?ability_component)
        (strike_member_left_flank_link ?strike_squad_member ?left_flank_node)
        (not
          (left_flank_primary_marker ?left_flank_node)
        )
        (not
          (left_flank_secondary_marker ?left_flank_node)
        )
      )
    :effect (left_flank_primary_marker ?left_flank_node)
  )
  (:action arm_strike_member_with_module
    :parameters (?strike_squad_member - strike_squad_member ?left_flank_node - left_flank_node ?equipment_module - equipment_module)
    :precondition
      (and
        (slot_primed ?strike_squad_member)
        (slot_equipped_with_module ?strike_squad_member ?equipment_module)
        (strike_member_left_flank_link ?strike_squad_member ?left_flank_node)
        (left_flank_primary_marker ?left_flank_node)
        (not
          (strike_member_stage_flag ?strike_squad_member)
        )
      )
    :effect
      (and
        (strike_member_stage_flag ?strike_squad_member)
        (strike_member_payload_staged ?strike_squad_member)
      )
  )
  (:action assign_consumable_to_strike_member
    :parameters (?strike_squad_member - strike_squad_member ?left_flank_node - left_flank_node ?consumable_resource - consumable_resource)
    :precondition
      (and
        (slot_primed ?strike_squad_member)
        (strike_member_left_flank_link ?strike_squad_member ?left_flank_node)
        (consumable_resource_available ?consumable_resource)
        (not
          (strike_member_stage_flag ?strike_squad_member)
        )
      )
    :effect
      (and
        (left_flank_secondary_marker ?left_flank_node)
        (strike_member_stage_flag ?strike_squad_member)
        (strike_member_consumable_assigned ?strike_squad_member ?consumable_resource)
        (not
          (consumable_resource_available ?consumable_resource)
        )
      )
  )
  (:action finalize_strike_flank_payload
    :parameters (?strike_squad_member - strike_squad_member ?left_flank_node - left_flank_node ?ability_component - ability_component ?consumable_resource - consumable_resource)
    :precondition
      (and
        (slot_primed ?strike_squad_member)
        (slot_component_binding ?strike_squad_member ?ability_component)
        (strike_member_left_flank_link ?strike_squad_member ?left_flank_node)
        (left_flank_secondary_marker ?left_flank_node)
        (strike_member_consumable_assigned ?strike_squad_member ?consumable_resource)
        (not
          (strike_member_payload_staged ?strike_squad_member)
        )
      )
    :effect
      (and
        (left_flank_primary_marker ?left_flank_node)
        (strike_member_payload_staged ?strike_squad_member)
        (consumable_resource_available ?consumable_resource)
        (not
          (strike_member_consumable_assigned ?strike_squad_member ?consumable_resource)
        )
      )
  )
  (:action stage_right_flank_primary
    :parameters (?support_squad_member - support_squad_member ?right_flank_node - right_flank_node ?ability_component - ability_component)
    :precondition
      (and
        (slot_primed ?support_squad_member)
        (slot_component_binding ?support_squad_member ?ability_component)
        (support_member_right_flank_link ?support_squad_member ?right_flank_node)
        (not
          (right_flank_primary_marker ?right_flank_node)
        )
        (not
          (right_flank_secondary_marker ?right_flank_node)
        )
      )
    :effect (right_flank_primary_marker ?right_flank_node)
  )
  (:action arm_support_member_with_module
    :parameters (?support_squad_member - support_squad_member ?right_flank_node - right_flank_node ?equipment_module - equipment_module)
    :precondition
      (and
        (slot_primed ?support_squad_member)
        (slot_equipped_with_module ?support_squad_member ?equipment_module)
        (support_member_right_flank_link ?support_squad_member ?right_flank_node)
        (right_flank_primary_marker ?right_flank_node)
        (not
          (support_member_stage_flag ?support_squad_member)
        )
      )
    :effect
      (and
        (support_member_stage_flag ?support_squad_member)
        (support_member_payload_staged ?support_squad_member)
      )
  )
  (:action assign_consumable_to_support_member
    :parameters (?support_squad_member - support_squad_member ?right_flank_node - right_flank_node ?consumable_resource - consumable_resource)
    :precondition
      (and
        (slot_primed ?support_squad_member)
        (support_member_right_flank_link ?support_squad_member ?right_flank_node)
        (consumable_resource_available ?consumable_resource)
        (not
          (support_member_stage_flag ?support_squad_member)
        )
      )
    :effect
      (and
        (right_flank_secondary_marker ?right_flank_node)
        (support_member_stage_flag ?support_squad_member)
        (support_member_consumable_assigned ?support_squad_member ?consumable_resource)
        (not
          (consumable_resource_available ?consumable_resource)
        )
      )
  )
  (:action finalize_support_flank_payload
    :parameters (?support_squad_member - support_squad_member ?right_flank_node - right_flank_node ?ability_component - ability_component ?consumable_resource - consumable_resource)
    :precondition
      (and
        (slot_primed ?support_squad_member)
        (slot_component_binding ?support_squad_member ?ability_component)
        (support_member_right_flank_link ?support_squad_member ?right_flank_node)
        (right_flank_secondary_marker ?right_flank_node)
        (support_member_consumable_assigned ?support_squad_member ?consumable_resource)
        (not
          (support_member_payload_staged ?support_squad_member)
        )
      )
    :effect
      (and
        (right_flank_primary_marker ?right_flank_node)
        (support_member_payload_staged ?support_squad_member)
        (consumable_resource_available ?consumable_resource)
        (not
          (support_member_consumable_assigned ?support_squad_member ?consumable_resource)
        )
      )
  )
  (:action coordinate_flank_delivery
    :parameters (?strike_squad_member - strike_squad_member ?support_squad_member - support_squad_member ?left_flank_node - left_flank_node ?right_flank_node - right_flank_node ?encounter_point - encounter_point)
    :precondition
      (and
        (strike_member_stage_flag ?strike_squad_member)
        (support_member_stage_flag ?support_squad_member)
        (strike_member_left_flank_link ?strike_squad_member ?left_flank_node)
        (support_member_right_flank_link ?support_squad_member ?right_flank_node)
        (left_flank_primary_marker ?left_flank_node)
        (right_flank_primary_marker ?right_flank_node)
        (strike_member_payload_staged ?strike_squad_member)
        (support_member_payload_staged ?support_squad_member)
        (encounter_point_open ?encounter_point)
      )
    :effect
      (and
        (encounter_point_engaged ?encounter_point)
        (encounter_left_node_link ?encounter_point ?left_flank_node)
        (encounter_right_node_link ?encounter_point ?right_flank_node)
        (not
          (encounter_point_open ?encounter_point)
        )
      )
  )
  (:action coordinate_encounter_delivery_left_coverage
    :parameters (?strike_squad_member - strike_squad_member ?support_squad_member - support_squad_member ?left_flank_node - left_flank_node ?right_flank_node - right_flank_node ?encounter_point - encounter_point)
    :precondition
      (and
        (strike_member_stage_flag ?strike_squad_member)
        (support_member_stage_flag ?support_squad_member)
        (strike_member_left_flank_link ?strike_squad_member ?left_flank_node)
        (support_member_right_flank_link ?support_squad_member ?right_flank_node)
        (left_flank_secondary_marker ?left_flank_node)
        (right_flank_primary_marker ?right_flank_node)
        (not
          (strike_member_payload_staged ?strike_squad_member)
        )
        (support_member_payload_staged ?support_squad_member)
        (encounter_point_open ?encounter_point)
      )
    :effect
      (and
        (encounter_point_engaged ?encounter_point)
        (encounter_left_node_link ?encounter_point ?left_flank_node)
        (encounter_right_node_link ?encounter_point ?right_flank_node)
        (encounter_left_coverage ?encounter_point)
        (not
          (encounter_point_open ?encounter_point)
        )
      )
  )
  (:action coordinate_encounter_delivery_right_coverage
    :parameters (?strike_squad_member - strike_squad_member ?support_squad_member - support_squad_member ?left_flank_node - left_flank_node ?right_flank_node - right_flank_node ?encounter_point - encounter_point)
    :precondition
      (and
        (strike_member_stage_flag ?strike_squad_member)
        (support_member_stage_flag ?support_squad_member)
        (strike_member_left_flank_link ?strike_squad_member ?left_flank_node)
        (support_member_right_flank_link ?support_squad_member ?right_flank_node)
        (left_flank_primary_marker ?left_flank_node)
        (right_flank_secondary_marker ?right_flank_node)
        (strike_member_payload_staged ?strike_squad_member)
        (not
          (support_member_payload_staged ?support_squad_member)
        )
        (encounter_point_open ?encounter_point)
      )
    :effect
      (and
        (encounter_point_engaged ?encounter_point)
        (encounter_left_node_link ?encounter_point ?left_flank_node)
        (encounter_right_node_link ?encounter_point ?right_flank_node)
        (encounter_right_coverage ?encounter_point)
        (not
          (encounter_point_open ?encounter_point)
        )
      )
  )
  (:action coordinate_encounter_delivery_full_coverage
    :parameters (?strike_squad_member - strike_squad_member ?support_squad_member - support_squad_member ?left_flank_node - left_flank_node ?right_flank_node - right_flank_node ?encounter_point - encounter_point)
    :precondition
      (and
        (strike_member_stage_flag ?strike_squad_member)
        (support_member_stage_flag ?support_squad_member)
        (strike_member_left_flank_link ?strike_squad_member ?left_flank_node)
        (support_member_right_flank_link ?support_squad_member ?right_flank_node)
        (left_flank_secondary_marker ?left_flank_node)
        (right_flank_secondary_marker ?right_flank_node)
        (not
          (strike_member_payload_staged ?strike_squad_member)
        )
        (not
          (support_member_payload_staged ?support_squad_member)
        )
        (encounter_point_open ?encounter_point)
      )
    :effect
      (and
        (encounter_point_engaged ?encounter_point)
        (encounter_left_node_link ?encounter_point ?left_flank_node)
        (encounter_right_node_link ?encounter_point ?right_flank_node)
        (encounter_left_coverage ?encounter_point)
        (encounter_right_coverage ?encounter_point)
        (not
          (encounter_point_open ?encounter_point)
        )
      )
  )
  (:action finalize_encounter_stage
    :parameters (?encounter_point - encounter_point ?strike_squad_member - strike_squad_member ?ability_component - ability_component)
    :precondition
      (and
        (encounter_point_engaged ?encounter_point)
        (strike_member_stage_flag ?strike_squad_member)
        (slot_component_binding ?strike_squad_member ?ability_component)
        (not
          (encounter_point_finalized ?encounter_point)
        )
      )
    :effect (encounter_point_finalized ?encounter_point)
  )
  (:action install_tactical_module_on_encounter
    :parameters (?planner_agent - planner_slot ?tactical_module - tactical_module ?encounter_point - encounter_point)
    :precondition
      (and
        (slot_primed ?planner_agent)
        (planner_encounter_assignment ?planner_agent ?encounter_point)
        (planner_has_tactical_module ?planner_agent ?tactical_module)
        (tactical_module_available ?tactical_module)
        (encounter_point_engaged ?encounter_point)
        (encounter_point_finalized ?encounter_point)
        (not
          (tactical_module_installed ?tactical_module)
        )
      )
    :effect
      (and
        (tactical_module_installed ?tactical_module)
        (tactical_module_installed_on_encounter ?tactical_module ?encounter_point)
        (not
          (tactical_module_available ?tactical_module)
        )
      )
  )
  (:action arm_tactical_module_activation
    :parameters (?planner_agent - planner_slot ?tactical_module - tactical_module ?encounter_point - encounter_point ?ability_component - ability_component)
    :precondition
      (and
        (slot_primed ?planner_agent)
        (planner_has_tactical_module ?planner_agent ?tactical_module)
        (tactical_module_installed ?tactical_module)
        (tactical_module_installed_on_encounter ?tactical_module ?encounter_point)
        (slot_component_binding ?planner_agent ?ability_component)
        (not
          (encounter_left_coverage ?encounter_point)
        )
        (not
          (planner_module_armed ?planner_agent)
        )
      )
    :effect (planner_module_armed ?planner_agent)
  )
  (:action install_field_upgrade_on_planner
    :parameters (?planner_agent - planner_slot ?field_upgrade - field_upgrade)
    :precondition
      (and
        (slot_primed ?planner_agent)
        (field_upgrade_available ?field_upgrade)
        (not
          (planner_upgrade_installed ?planner_agent)
        )
      )
    :effect
      (and
        (planner_upgrade_installed ?planner_agent)
        (planner_field_upgrade_link ?planner_agent ?field_upgrade)
        (not
          (field_upgrade_available ?field_upgrade)
        )
      )
  )
  (:action activate_planner_module_with_upgrade
    :parameters (?planner_agent - planner_slot ?tactical_module - tactical_module ?encounter_point - encounter_point ?ability_component - ability_component ?field_upgrade - field_upgrade)
    :precondition
      (and
        (slot_primed ?planner_agent)
        (planner_has_tactical_module ?planner_agent ?tactical_module)
        (tactical_module_installed ?tactical_module)
        (tactical_module_installed_on_encounter ?tactical_module ?encounter_point)
        (slot_component_binding ?planner_agent ?ability_component)
        (encounter_left_coverage ?encounter_point)
        (planner_upgrade_installed ?planner_agent)
        (planner_field_upgrade_link ?planner_agent ?field_upgrade)
        (not
          (planner_module_armed ?planner_agent)
        )
      )
    :effect
      (and
        (planner_module_armed ?planner_agent)
        (planner_upgrade_armed ?planner_agent)
      )
  )
  (:action prime_planner_module_for_activation
    :parameters (?planner_agent - planner_slot ?special_gadget_a - special_gadget_a ?equipment_module - equipment_module ?tactical_module - tactical_module ?encounter_point - encounter_point)
    :precondition
      (and
        (planner_module_armed ?planner_agent)
        (planner_special_gadget_a_link ?planner_agent ?special_gadget_a)
        (slot_equipped_with_module ?planner_agent ?equipment_module)
        (planner_has_tactical_module ?planner_agent ?tactical_module)
        (tactical_module_installed_on_encounter ?tactical_module ?encounter_point)
        (not
          (encounter_right_coverage ?encounter_point)
        )
        (not
          (planner_module_primed ?planner_agent)
        )
      )
    :effect (planner_module_primed ?planner_agent)
  )
  (:action finalize_planner_module_preparation
    :parameters (?planner_agent - planner_slot ?special_gadget_a - special_gadget_a ?equipment_module - equipment_module ?tactical_module - tactical_module ?encounter_point - encounter_point)
    :precondition
      (and
        (planner_module_armed ?planner_agent)
        (planner_special_gadget_a_link ?planner_agent ?special_gadget_a)
        (slot_equipped_with_module ?planner_agent ?equipment_module)
        (planner_has_tactical_module ?planner_agent ?tactical_module)
        (tactical_module_installed_on_encounter ?tactical_module ?encounter_point)
        (encounter_right_coverage ?encounter_point)
        (not
          (planner_module_primed ?planner_agent)
        )
      )
    :effect (planner_module_primed ?planner_agent)
  )
  (:action prime_planner_with_special_gadget_b
    :parameters (?planner_agent - planner_slot ?special_gadget_b - special_gadget_b ?tactical_module - tactical_module ?encounter_point - encounter_point)
    :precondition
      (and
        (planner_module_primed ?planner_agent)
        (planner_special_gadget_b_link ?planner_agent ?special_gadget_b)
        (planner_has_tactical_module ?planner_agent ?tactical_module)
        (tactical_module_installed_on_encounter ?tactical_module ?encounter_point)
        (not
          (encounter_left_coverage ?encounter_point)
        )
        (not
          (encounter_right_coverage ?encounter_point)
        )
        (not
          (planner_module_confirmed ?planner_agent)
        )
      )
    :effect (planner_module_confirmed ?planner_agent)
  )
  (:action confirm_planner_module_activation_variant
    :parameters (?planner_agent - planner_slot ?special_gadget_b - special_gadget_b ?tactical_module - tactical_module ?encounter_point - encounter_point)
    :precondition
      (and
        (planner_module_primed ?planner_agent)
        (planner_special_gadget_b_link ?planner_agent ?special_gadget_b)
        (planner_has_tactical_module ?planner_agent ?tactical_module)
        (tactical_module_installed_on_encounter ?tactical_module ?encounter_point)
        (encounter_left_coverage ?encounter_point)
        (not
          (encounter_right_coverage ?encounter_point)
        )
        (not
          (planner_module_confirmed ?planner_agent)
        )
      )
    :effect
      (and
        (planner_module_confirmed ?planner_agent)
        (planner_synergy_enabled ?planner_agent)
      )
  )
  (:action confirm_planner_module_activation_variant_b
    :parameters (?planner_agent - planner_slot ?special_gadget_b - special_gadget_b ?tactical_module - tactical_module ?encounter_point - encounter_point)
    :precondition
      (and
        (planner_module_primed ?planner_agent)
        (planner_special_gadget_b_link ?planner_agent ?special_gadget_b)
        (planner_has_tactical_module ?planner_agent ?tactical_module)
        (tactical_module_installed_on_encounter ?tactical_module ?encounter_point)
        (not
          (encounter_left_coverage ?encounter_point)
        )
        (encounter_right_coverage ?encounter_point)
        (not
          (planner_module_confirmed ?planner_agent)
        )
      )
    :effect
      (and
        (planner_module_confirmed ?planner_agent)
        (planner_synergy_enabled ?planner_agent)
      )
  )
  (:action confirm_planner_module_activation_variant_c
    :parameters (?planner_agent - planner_slot ?special_gadget_b - special_gadget_b ?tactical_module - tactical_module ?encounter_point - encounter_point)
    :precondition
      (and
        (planner_module_primed ?planner_agent)
        (planner_special_gadget_b_link ?planner_agent ?special_gadget_b)
        (planner_has_tactical_module ?planner_agent ?tactical_module)
        (tactical_module_installed_on_encounter ?tactical_module ?encounter_point)
        (encounter_left_coverage ?encounter_point)
        (encounter_right_coverage ?encounter_point)
        (not
          (planner_module_confirmed ?planner_agent)
        )
      )
    :effect
      (and
        (planner_module_confirmed ?planner_agent)
        (planner_synergy_enabled ?planner_agent)
      )
  )
  (:action planner_finalize_without_synergy
    :parameters (?planner_agent - planner_slot)
    :precondition
      (and
        (planner_module_confirmed ?planner_agent)
        (not
          (planner_synergy_enabled ?planner_agent)
        )
        (not
          (planner_signoff ?planner_agent)
        )
      )
    :effect
      (and
        (planner_signoff ?planner_agent)
        (combo_executed ?planner_agent)
      )
  )
  (:action attach_synergy_modifier_to_planner
    :parameters (?planner_agent - planner_slot ?synergy_modifier - synergy_modifier)
    :precondition
      (and
        (planner_module_confirmed ?planner_agent)
        (planner_synergy_enabled ?planner_agent)
        (synergy_modifier_available ?synergy_modifier)
      )
    :effect
      (and
        (planner_synergy_modifier_link ?planner_agent ?synergy_modifier)
        (not
          (synergy_modifier_available ?synergy_modifier)
        )
      )
  )
  (:action finalize_planner_module_installation
    :parameters (?planner_agent - planner_slot ?strike_squad_member - strike_squad_member ?support_squad_member - support_squad_member ?ability_component - ability_component ?synergy_modifier - synergy_modifier)
    :precondition
      (and
        (planner_module_confirmed ?planner_agent)
        (planner_synergy_enabled ?planner_agent)
        (planner_synergy_modifier_link ?planner_agent ?synergy_modifier)
        (planner_strike_member_link ?planner_agent ?strike_squad_member)
        (planner_support_member_link ?planner_agent ?support_squad_member)
        (strike_member_payload_staged ?strike_squad_member)
        (support_member_payload_staged ?support_squad_member)
        (slot_component_binding ?planner_agent ?ability_component)
        (not
          (planner_final_check_passed ?planner_agent)
        )
      )
    :effect (planner_final_check_passed ?planner_agent)
  )
  (:action planner_finalize_with_check
    :parameters (?planner_agent - planner_slot)
    :precondition
      (and
        (planner_module_confirmed ?planner_agent)
        (planner_final_check_passed ?planner_agent)
        (not
          (planner_signoff ?planner_agent)
        )
      )
    :effect
      (and
        (planner_signoff ?planner_agent)
        (combo_executed ?planner_agent)
      )
  )
  (:action apply_priority_marker_to_planner
    :parameters (?planner_agent - planner_slot ?priority_marker - priority_marker ?ability_component - ability_component)
    :precondition
      (and
        (slot_primed ?planner_agent)
        (slot_component_binding ?planner_agent ?ability_component)
        (priority_marker_available ?priority_marker)
        (planner_priority_marker_link ?planner_agent ?priority_marker)
        (not
          (planner_priority_applied ?planner_agent)
        )
      )
    :effect
      (and
        (planner_priority_applied ?planner_agent)
        (not
          (priority_marker_available ?priority_marker)
        )
      )
  )
  (:action arm_planner_priority_slot
    :parameters (?planner_agent - planner_slot ?equipment_module - equipment_module)
    :precondition
      (and
        (planner_priority_applied ?planner_agent)
        (slot_equipped_with_module ?planner_agent ?equipment_module)
        (not
          (planner_priority_slot_armed ?planner_agent)
        )
      )
    :effect (planner_priority_slot_armed ?planner_agent)
  )
  (:action confirm_planner_priority_with_gadget_b
    :parameters (?planner_agent - planner_slot ?special_gadget_b - special_gadget_b)
    :precondition
      (and
        (planner_priority_slot_armed ?planner_agent)
        (planner_special_gadget_b_link ?planner_agent ?special_gadget_b)
        (not
          (planner_priority_confirmed ?planner_agent)
        )
      )
    :effect (planner_priority_confirmed ?planner_agent)
  )
  (:action planner_accept_priority_and_signoff
    :parameters (?planner_agent - planner_slot)
    :precondition
      (and
        (planner_priority_confirmed ?planner_agent)
        (not
          (planner_signoff ?planner_agent)
        )
      )
    :effect
      (and
        (planner_signoff ?planner_agent)
        (combo_executed ?planner_agent)
      )
  )
  (:action finalize_strike_member_combo
    :parameters (?strike_squad_member - strike_squad_member ?encounter_point - encounter_point)
    :precondition
      (and
        (strike_member_stage_flag ?strike_squad_member)
        (strike_member_payload_staged ?strike_squad_member)
        (encounter_point_engaged ?encounter_point)
        (encounter_point_finalized ?encounter_point)
        (not
          (combo_executed ?strike_squad_member)
        )
      )
    :effect (combo_executed ?strike_squad_member)
  )
  (:action finalize_support_member_combo
    :parameters (?support_squad_member - support_squad_member ?encounter_point - encounter_point)
    :precondition
      (and
        (support_member_stage_flag ?support_squad_member)
        (support_member_payload_staged ?support_squad_member)
        (encounter_point_engaged ?encounter_point)
        (encounter_point_finalized ?encounter_point)
        (not
          (combo_executed ?support_squad_member)
        )
      )
    :effect (combo_executed ?support_squad_member)
  )
  (:action consume_recovery_resource
    :parameters (?combat_unit_slot - combat_unit_slot ?recovery_resource - recovery_resource ?ability_component - ability_component)
    :precondition
      (and
        (combo_executed ?combat_unit_slot)
        (slot_component_binding ?combat_unit_slot ?ability_component)
        (recovery_resource_available ?recovery_resource)
        (not
          (slot_in_recovery ?combat_unit_slot)
        )
      )
    :effect
      (and
        (slot_in_recovery ?combat_unit_slot)
        (slot_recovery_binding ?combat_unit_slot ?recovery_resource)
        (not
          (recovery_resource_available ?recovery_resource)
        )
      )
  )
  (:action redeploy_member_and_restock_token
    :parameters (?strike_squad_member - strike_squad_member ?ability_token - ability_token ?recovery_resource - recovery_resource)
    :precondition
      (and
        (slot_in_recovery ?strike_squad_member)
        (slot_token_binding ?strike_squad_member ?ability_token)
        (slot_recovery_binding ?strike_squad_member ?recovery_resource)
        (not
          (slot_reconfigured ?strike_squad_member)
        )
      )
    :effect
      (and
        (slot_reconfigured ?strike_squad_member)
        (ability_token_available ?ability_token)
        (recovery_resource_available ?recovery_resource)
      )
  )
  (:action redeploy_support_member_and_restock_token
    :parameters (?support_squad_member - support_squad_member ?ability_token - ability_token ?recovery_resource - recovery_resource)
    :precondition
      (and
        (slot_in_recovery ?support_squad_member)
        (slot_token_binding ?support_squad_member ?ability_token)
        (slot_recovery_binding ?support_squad_member ?recovery_resource)
        (not
          (slot_reconfigured ?support_squad_member)
        )
      )
    :effect
      (and
        (slot_reconfigured ?support_squad_member)
        (ability_token_available ?ability_token)
        (recovery_resource_available ?recovery_resource)
      )
  )
  (:action redeploy_planner_and_restock_token
    :parameters (?planner_agent - planner_slot ?ability_token - ability_token ?recovery_resource - recovery_resource)
    :precondition
      (and
        (slot_in_recovery ?planner_agent)
        (slot_token_binding ?planner_agent ?ability_token)
        (slot_recovery_binding ?planner_agent ?recovery_resource)
        (not
          (slot_reconfigured ?planner_agent)
        )
      )
    :effect
      (and
        (slot_reconfigured ?planner_agent)
        (ability_token_available ?ability_token)
        (recovery_resource_available ?recovery_resource)
      )
  )
)

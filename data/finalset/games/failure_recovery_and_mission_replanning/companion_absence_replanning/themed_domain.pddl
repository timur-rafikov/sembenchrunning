(define (domain companion_absence_replanning)
  (:requirements :strips :typing :negative-preconditions)
  (:types companion_asset - object unused_subtype_20 - object unused_subtype_21 - object mission_context_root - object mission_context - mission_context_root companion_template - companion_asset companion_role_profile - companion_asset equipment_module - companion_asset strategic_modifier - companion_asset tactical_modifier - companion_asset mission_token - companion_asset skill_module - companion_asset personality_module - companion_asset consumable_resource - unused_subtype_20 supply_cache - unused_subtype_20 ally_trait - unused_subtype_20 route_segment - unused_subtype_21 alt_route_segment - unused_subtype_21 continuation_node - unused_subtype_21 mission_context_subtype_a - mission_context mission_context_subtype_b - mission_context primary_companion_slot - mission_context_subtype_a secondary_companion_slot - mission_context_subtype_a replan_agent - mission_context_subtype_b)
  (:predicates
    (replan_needed ?mission_ctx - mission_context)
    (entity_assignment_confirmed ?mission_ctx - mission_context)
    (companion_reserved ?mission_ctx - mission_context)
    (entity_continuation_committed ?mission_ctx - mission_context)
    (entity_assignment_ready ?mission_ctx - mission_context)
    (entity_finalization_authorized ?mission_ctx - mission_context)
    (template_available ?companion_template - companion_template)
    (entity_reserved_companion_template ?mission_ctx - mission_context ?companion_template - companion_template)
    (role_profile_available ?role_profile - companion_role_profile)
    (entity_assigned_role_profile ?mission_ctx - mission_context ?role_profile - companion_role_profile)
    (equipment_available ?equipment_module - equipment_module)
    (entity_assigned_equipment_module ?mission_ctx - mission_context ?equipment_module - equipment_module)
    (consumable_available ?consumable - consumable_resource)
    (primary_slot_consumable_assigned ?primary_slot - primary_companion_slot ?consumable - consumable_resource)
    (secondary_slot_consumable_assigned ?secondary_slot - secondary_companion_slot ?consumable - consumable_resource)
    (primary_slot_route_link ?primary_slot - primary_companion_slot ?route_segment - route_segment)
    (route_segment_verified ?route_segment - route_segment)
    (route_segment_secured ?route_segment - route_segment)
    (primary_slot_ready ?primary_slot - primary_companion_slot)
    (secondary_slot_route_link ?secondary_slot - secondary_companion_slot ?alt_route_segment - alt_route_segment)
    (alt_route_verified ?alt_route_segment - alt_route_segment)
    (alt_route_secured ?alt_route_segment - alt_route_segment)
    (secondary_slot_ready ?secondary_slot - secondary_companion_slot)
    (continuation_node_available ?continuation_node - continuation_node)
    (continuation_node_selected ?continuation_node - continuation_node)
    (continuation_node_route_link ?continuation_node - continuation_node ?route_segment - route_segment)
    (continuation_node_alt_route_link ?continuation_node - continuation_node ?alt_route_segment - alt_route_segment)
    (continuation_node_primary_secured ?continuation_node - continuation_node)
    (continuation_node_secondary_secured ?continuation_node - continuation_node)
    (continuation_node_ready ?continuation_node - continuation_node)
    (agent_bound_to_primary_slot ?replan_agent - replan_agent ?primary_slot - primary_companion_slot)
    (agent_bound_to_secondary_slot ?replan_agent - replan_agent ?secondary_slot - secondary_companion_slot)
    (agent_linked_to_continuation_node ?replan_agent - replan_agent ?continuation_node - continuation_node)
    (supply_cache_available ?supply_cache - supply_cache)
    (agent_linked_supply_cache ?replan_agent - replan_agent ?supply_cache - supply_cache)
    (supply_cache_integrated ?supply_cache - supply_cache)
    (supply_cache_linked_to_node ?supply_cache - supply_cache ?continuation_node - continuation_node)
    (agent_unlocked ?replan_agent - replan_agent)
    (agent_skill_integration_ready ?replan_agent - replan_agent)
    (agent_personality_applied ?replan_agent - replan_agent)
    (agent_strategic_modifier_attached ?replan_agent - replan_agent)
    (agent_modifier_staged ?replan_agent - replan_agent)
    (agent_modifier_applied ?replan_agent - replan_agent)
    (agent_ready_for_authorization ?replan_agent - replan_agent)
    (ally_trait_available ?ally_trait - ally_trait)
    (agent_ally_trait_link ?replan_agent - replan_agent ?ally_trait - ally_trait)
    (agent_ally_trait_engaged ?replan_agent - replan_agent)
    (agent_trait_equipped ?replan_agent - replan_agent)
    (agent_trait_personality_attached ?replan_agent - replan_agent)
    (strategic_modifier_available ?strategic_modifier - strategic_modifier)
    (agent_strategic_modifier_link ?replan_agent - replan_agent ?strategic_modifier - strategic_modifier)
    (tactical_modifier_available ?tactical_modifier - tactical_modifier)
    (agent_tactical_modifier_attached ?replan_agent - replan_agent ?tactical_modifier - tactical_modifier)
    (skill_module_available ?skill_module - skill_module)
    (agent_skill_module_attached ?replan_agent - replan_agent ?skill_module - skill_module)
    (personality_module_available ?personality_module - personality_module)
    (agent_personality_module_link ?replan_agent - replan_agent ?personality_module - personality_module)
    (mission_token_available ?mission_token - mission_token)
    (entity_mission_token_bound ?mission_ctx - mission_context ?mission_token - mission_token)
    (primary_slot_engaged ?primary_slot - primary_companion_slot)
    (secondary_slot_engaged ?secondary_slot - secondary_companion_slot)
    (agent_authorized ?replan_agent - replan_agent)
  )
  (:action detect_and_mark_replan
    :parameters (?mission_ctx - mission_context)
    :precondition
      (and
        (not
          (replan_needed ?mission_ctx)
        )
        (not
          (entity_continuation_committed ?mission_ctx)
        )
      )
    :effect (replan_needed ?mission_ctx)
  )
  (:action reserve_companion_template
    :parameters (?mission_ctx - mission_context ?companion_template - companion_template)
    :precondition
      (and
        (replan_needed ?mission_ctx)
        (not
          (companion_reserved ?mission_ctx)
        )
        (template_available ?companion_template)
      )
    :effect
      (and
        (companion_reserved ?mission_ctx)
        (entity_reserved_companion_template ?mission_ctx ?companion_template)
        (not
          (template_available ?companion_template)
        )
      )
  )
  (:action assign_role_profile_to_mission
    :parameters (?mission_ctx - mission_context ?role_profile - companion_role_profile)
    :precondition
      (and
        (replan_needed ?mission_ctx)
        (companion_reserved ?mission_ctx)
        (role_profile_available ?role_profile)
      )
    :effect
      (and
        (entity_assigned_role_profile ?mission_ctx ?role_profile)
        (not
          (role_profile_available ?role_profile)
        )
      )
  )
  (:action confirm_companion_assignment
    :parameters (?mission_ctx - mission_context ?role_profile - companion_role_profile)
    :precondition
      (and
        (replan_needed ?mission_ctx)
        (companion_reserved ?mission_ctx)
        (entity_assigned_role_profile ?mission_ctx ?role_profile)
        (not
          (entity_assignment_confirmed ?mission_ctx)
        )
      )
    :effect (entity_assignment_confirmed ?mission_ctx)
  )
  (:action release_role_profile
    :parameters (?mission_ctx - mission_context ?role_profile - companion_role_profile)
    :precondition
      (and
        (entity_assigned_role_profile ?mission_ctx ?role_profile)
      )
    :effect
      (and
        (role_profile_available ?role_profile)
        (not
          (entity_assigned_role_profile ?mission_ctx ?role_profile)
        )
      )
  )
  (:action assign_equipment_module
    :parameters (?mission_ctx - mission_context ?equipment_module - equipment_module)
    :precondition
      (and
        (entity_assignment_confirmed ?mission_ctx)
        (equipment_available ?equipment_module)
      )
    :effect
      (and
        (entity_assigned_equipment_module ?mission_ctx ?equipment_module)
        (not
          (equipment_available ?equipment_module)
        )
      )
  )
  (:action release_equipment_module
    :parameters (?mission_ctx - mission_context ?equipment_module - equipment_module)
    :precondition
      (and
        (entity_assigned_equipment_module ?mission_ctx ?equipment_module)
      )
    :effect
      (and
        (equipment_available ?equipment_module)
        (not
          (entity_assigned_equipment_module ?mission_ctx ?equipment_module)
        )
      )
  )
  (:action attach_skill_module_to_agent
    :parameters (?replan_agent - replan_agent ?skill_module - skill_module)
    :precondition
      (and
        (entity_assignment_confirmed ?replan_agent)
        (skill_module_available ?skill_module)
      )
    :effect
      (and
        (agent_skill_module_attached ?replan_agent ?skill_module)
        (not
          (skill_module_available ?skill_module)
        )
      )
  )
  (:action detach_skill_module_from_agent
    :parameters (?replan_agent - replan_agent ?skill_module - skill_module)
    :precondition
      (and
        (agent_skill_module_attached ?replan_agent ?skill_module)
      )
    :effect
      (and
        (skill_module_available ?skill_module)
        (not
          (agent_skill_module_attached ?replan_agent ?skill_module)
        )
      )
  )
  (:action attach_personality_module_to_agent
    :parameters (?replan_agent - replan_agent ?personality_module - personality_module)
    :precondition
      (and
        (entity_assignment_confirmed ?replan_agent)
        (personality_module_available ?personality_module)
      )
    :effect
      (and
        (agent_personality_module_link ?replan_agent ?personality_module)
        (not
          (personality_module_available ?personality_module)
        )
      )
  )
  (:action detach_personality_module_from_agent
    :parameters (?replan_agent - replan_agent ?personality_module - personality_module)
    :precondition
      (and
        (agent_personality_module_link ?replan_agent ?personality_module)
      )
    :effect
      (and
        (personality_module_available ?personality_module)
        (not
          (agent_personality_module_link ?replan_agent ?personality_module)
        )
      )
  )
  (:action verify_route_segment_for_primary_slot
    :parameters (?primary_slot - primary_companion_slot ?route_segment - route_segment ?role_profile - companion_role_profile)
    :precondition
      (and
        (entity_assignment_confirmed ?primary_slot)
        (entity_assigned_role_profile ?primary_slot ?role_profile)
        (primary_slot_route_link ?primary_slot ?route_segment)
        (not
          (route_segment_verified ?route_segment)
        )
        (not
          (route_segment_secured ?route_segment)
        )
      )
    :effect (route_segment_verified ?route_segment)
  )
  (:action finalize_primary_slot_readiness_with_equipment
    :parameters (?primary_slot - primary_companion_slot ?route_segment - route_segment ?equipment_module - equipment_module)
    :precondition
      (and
        (entity_assignment_confirmed ?primary_slot)
        (entity_assigned_equipment_module ?primary_slot ?equipment_module)
        (primary_slot_route_link ?primary_slot ?route_segment)
        (route_segment_verified ?route_segment)
        (not
          (primary_slot_engaged ?primary_slot)
        )
      )
    :effect
      (and
        (primary_slot_engaged ?primary_slot)
        (primary_slot_ready ?primary_slot)
      )
  )
  (:action use_consumable_to_secure_route_primary
    :parameters (?primary_slot - primary_companion_slot ?route_segment - route_segment ?consumable - consumable_resource)
    :precondition
      (and
        (entity_assignment_confirmed ?primary_slot)
        (primary_slot_route_link ?primary_slot ?route_segment)
        (consumable_available ?consumable)
        (not
          (primary_slot_engaged ?primary_slot)
        )
      )
    :effect
      (and
        (route_segment_secured ?route_segment)
        (primary_slot_engaged ?primary_slot)
        (primary_slot_consumable_assigned ?primary_slot ?consumable)
        (not
          (consumable_available ?consumable)
        )
      )
  )
  (:action confirm_route_and_restore_consumable_primary
    :parameters (?primary_slot - primary_companion_slot ?route_segment - route_segment ?role_profile - companion_role_profile ?consumable - consumable_resource)
    :precondition
      (and
        (entity_assignment_confirmed ?primary_slot)
        (entity_assigned_role_profile ?primary_slot ?role_profile)
        (primary_slot_route_link ?primary_slot ?route_segment)
        (route_segment_secured ?route_segment)
        (primary_slot_consumable_assigned ?primary_slot ?consumable)
        (not
          (primary_slot_ready ?primary_slot)
        )
      )
    :effect
      (and
        (route_segment_verified ?route_segment)
        (primary_slot_ready ?primary_slot)
        (consumable_available ?consumable)
        (not
          (primary_slot_consumable_assigned ?primary_slot ?consumable)
        )
      )
  )
  (:action verify_alt_route_for_secondary_slot
    :parameters (?secondary_slot - secondary_companion_slot ?alt_route_segment - alt_route_segment ?role_profile - companion_role_profile)
    :precondition
      (and
        (entity_assignment_confirmed ?secondary_slot)
        (entity_assigned_role_profile ?secondary_slot ?role_profile)
        (secondary_slot_route_link ?secondary_slot ?alt_route_segment)
        (not
          (alt_route_verified ?alt_route_segment)
        )
        (not
          (alt_route_secured ?alt_route_segment)
        )
      )
    :effect (alt_route_verified ?alt_route_segment)
  )
  (:action finalize_secondary_slot_readiness_with_equipment
    :parameters (?secondary_slot - secondary_companion_slot ?alt_route_segment - alt_route_segment ?equipment_module - equipment_module)
    :precondition
      (and
        (entity_assignment_confirmed ?secondary_slot)
        (entity_assigned_equipment_module ?secondary_slot ?equipment_module)
        (secondary_slot_route_link ?secondary_slot ?alt_route_segment)
        (alt_route_verified ?alt_route_segment)
        (not
          (secondary_slot_engaged ?secondary_slot)
        )
      )
    :effect
      (and
        (secondary_slot_engaged ?secondary_slot)
        (secondary_slot_ready ?secondary_slot)
      )
  )
  (:action use_consumable_to_secure_alt_route_secondary
    :parameters (?secondary_slot - secondary_companion_slot ?alt_route_segment - alt_route_segment ?consumable - consumable_resource)
    :precondition
      (and
        (entity_assignment_confirmed ?secondary_slot)
        (secondary_slot_route_link ?secondary_slot ?alt_route_segment)
        (consumable_available ?consumable)
        (not
          (secondary_slot_engaged ?secondary_slot)
        )
      )
    :effect
      (and
        (alt_route_secured ?alt_route_segment)
        (secondary_slot_engaged ?secondary_slot)
        (secondary_slot_consumable_assigned ?secondary_slot ?consumable)
        (not
          (consumable_available ?consumable)
        )
      )
  )
  (:action confirm_alt_route_and_restore_consumable_secondary
    :parameters (?secondary_slot - secondary_companion_slot ?alt_route_segment - alt_route_segment ?role_profile - companion_role_profile ?consumable - consumable_resource)
    :precondition
      (and
        (entity_assignment_confirmed ?secondary_slot)
        (entity_assigned_role_profile ?secondary_slot ?role_profile)
        (secondary_slot_route_link ?secondary_slot ?alt_route_segment)
        (alt_route_secured ?alt_route_segment)
        (secondary_slot_consumable_assigned ?secondary_slot ?consumable)
        (not
          (secondary_slot_ready ?secondary_slot)
        )
      )
    :effect
      (and
        (alt_route_verified ?alt_route_segment)
        (secondary_slot_ready ?secondary_slot)
        (consumable_available ?consumable)
        (not
          (secondary_slot_consumable_assigned ?secondary_slot ?consumable)
        )
      )
  )
  (:action select_and_bind_continuation_node
    :parameters (?primary_slot - primary_companion_slot ?secondary_slot - secondary_companion_slot ?route_segment - route_segment ?alt_route_segment - alt_route_segment ?continuation_node - continuation_node)
    :precondition
      (and
        (primary_slot_engaged ?primary_slot)
        (secondary_slot_engaged ?secondary_slot)
        (primary_slot_route_link ?primary_slot ?route_segment)
        (secondary_slot_route_link ?secondary_slot ?alt_route_segment)
        (route_segment_verified ?route_segment)
        (alt_route_verified ?alt_route_segment)
        (primary_slot_ready ?primary_slot)
        (secondary_slot_ready ?secondary_slot)
        (continuation_node_available ?continuation_node)
      )
    :effect
      (and
        (continuation_node_selected ?continuation_node)
        (continuation_node_route_link ?continuation_node ?route_segment)
        (continuation_node_alt_route_link ?continuation_node ?alt_route_segment)
        (not
          (continuation_node_available ?continuation_node)
        )
      )
  )
  (:action select_continuation_node_with_primary_secured
    :parameters (?primary_slot - primary_companion_slot ?secondary_slot - secondary_companion_slot ?route_segment - route_segment ?alt_route_segment - alt_route_segment ?continuation_node - continuation_node)
    :precondition
      (and
        (primary_slot_engaged ?primary_slot)
        (secondary_slot_engaged ?secondary_slot)
        (primary_slot_route_link ?primary_slot ?route_segment)
        (secondary_slot_route_link ?secondary_slot ?alt_route_segment)
        (route_segment_secured ?route_segment)
        (alt_route_verified ?alt_route_segment)
        (not
          (primary_slot_ready ?primary_slot)
        )
        (secondary_slot_ready ?secondary_slot)
        (continuation_node_available ?continuation_node)
      )
    :effect
      (and
        (continuation_node_selected ?continuation_node)
        (continuation_node_route_link ?continuation_node ?route_segment)
        (continuation_node_alt_route_link ?continuation_node ?alt_route_segment)
        (continuation_node_primary_secured ?continuation_node)
        (not
          (continuation_node_available ?continuation_node)
        )
      )
  )
  (:action select_continuation_node_with_secondary_secured
    :parameters (?primary_slot - primary_companion_slot ?secondary_slot - secondary_companion_slot ?route_segment - route_segment ?alt_route_segment - alt_route_segment ?continuation_node - continuation_node)
    :precondition
      (and
        (primary_slot_engaged ?primary_slot)
        (secondary_slot_engaged ?secondary_slot)
        (primary_slot_route_link ?primary_slot ?route_segment)
        (secondary_slot_route_link ?secondary_slot ?alt_route_segment)
        (route_segment_verified ?route_segment)
        (alt_route_secured ?alt_route_segment)
        (primary_slot_ready ?primary_slot)
        (not
          (secondary_slot_ready ?secondary_slot)
        )
        (continuation_node_available ?continuation_node)
      )
    :effect
      (and
        (continuation_node_selected ?continuation_node)
        (continuation_node_route_link ?continuation_node ?route_segment)
        (continuation_node_alt_route_link ?continuation_node ?alt_route_segment)
        (continuation_node_secondary_secured ?continuation_node)
        (not
          (continuation_node_available ?continuation_node)
        )
      )
  )
  (:action select_continuation_node_with_both_secured
    :parameters (?primary_slot - primary_companion_slot ?secondary_slot - secondary_companion_slot ?route_segment - route_segment ?alt_route_segment - alt_route_segment ?continuation_node - continuation_node)
    :precondition
      (and
        (primary_slot_engaged ?primary_slot)
        (secondary_slot_engaged ?secondary_slot)
        (primary_slot_route_link ?primary_slot ?route_segment)
        (secondary_slot_route_link ?secondary_slot ?alt_route_segment)
        (route_segment_secured ?route_segment)
        (alt_route_secured ?alt_route_segment)
        (not
          (primary_slot_ready ?primary_slot)
        )
        (not
          (secondary_slot_ready ?secondary_slot)
        )
        (continuation_node_available ?continuation_node)
      )
    :effect
      (and
        (continuation_node_selected ?continuation_node)
        (continuation_node_route_link ?continuation_node ?route_segment)
        (continuation_node_alt_route_link ?continuation_node ?alt_route_segment)
        (continuation_node_primary_secured ?continuation_node)
        (continuation_node_secondary_secured ?continuation_node)
        (not
          (continuation_node_available ?continuation_node)
        )
      )
  )
  (:action prepare_continuation_node
    :parameters (?continuation_node - continuation_node ?primary_slot - primary_companion_slot ?role_profile - companion_role_profile)
    :precondition
      (and
        (continuation_node_selected ?continuation_node)
        (primary_slot_engaged ?primary_slot)
        (entity_assigned_role_profile ?primary_slot ?role_profile)
        (not
          (continuation_node_ready ?continuation_node)
        )
      )
    :effect (continuation_node_ready ?continuation_node)
  )
  (:action integrate_supply_cache
    :parameters (?replan_agent - replan_agent ?supply_cache - supply_cache ?continuation_node - continuation_node)
    :precondition
      (and
        (entity_assignment_confirmed ?replan_agent)
        (agent_linked_to_continuation_node ?replan_agent ?continuation_node)
        (agent_linked_supply_cache ?replan_agent ?supply_cache)
        (supply_cache_available ?supply_cache)
        (continuation_node_selected ?continuation_node)
        (continuation_node_ready ?continuation_node)
        (not
          (supply_cache_integrated ?supply_cache)
        )
      )
    :effect
      (and
        (supply_cache_integrated ?supply_cache)
        (supply_cache_linked_to_node ?supply_cache ?continuation_node)
        (not
          (supply_cache_available ?supply_cache)
        )
      )
  )
  (:action unlock_agent_capabilities_from_cache
    :parameters (?replan_agent - replan_agent ?supply_cache - supply_cache ?continuation_node - continuation_node ?role_profile - companion_role_profile)
    :precondition
      (and
        (entity_assignment_confirmed ?replan_agent)
        (agent_linked_supply_cache ?replan_agent ?supply_cache)
        (supply_cache_integrated ?supply_cache)
        (supply_cache_linked_to_node ?supply_cache ?continuation_node)
        (entity_assigned_role_profile ?replan_agent ?role_profile)
        (not
          (continuation_node_primary_secured ?continuation_node)
        )
        (not
          (agent_unlocked ?replan_agent)
        )
      )
    :effect (agent_unlocked ?replan_agent)
  )
  (:action attach_strategic_modifier
    :parameters (?replan_agent - replan_agent ?strategic_modifier - strategic_modifier)
    :precondition
      (and
        (entity_assignment_confirmed ?replan_agent)
        (strategic_modifier_available ?strategic_modifier)
        (not
          (agent_strategic_modifier_attached ?replan_agent)
        )
      )
    :effect
      (and
        (agent_strategic_modifier_attached ?replan_agent)
        (agent_strategic_modifier_link ?replan_agent ?strategic_modifier)
        (not
          (strategic_modifier_available ?strategic_modifier)
        )
      )
  )
  (:action stage_modifier_integration
    :parameters (?replan_agent - replan_agent ?supply_cache - supply_cache ?continuation_node - continuation_node ?role_profile - companion_role_profile ?strategic_modifier - strategic_modifier)
    :precondition
      (and
        (entity_assignment_confirmed ?replan_agent)
        (agent_linked_supply_cache ?replan_agent ?supply_cache)
        (supply_cache_integrated ?supply_cache)
        (supply_cache_linked_to_node ?supply_cache ?continuation_node)
        (entity_assigned_role_profile ?replan_agent ?role_profile)
        (continuation_node_primary_secured ?continuation_node)
        (agent_strategic_modifier_attached ?replan_agent)
        (agent_strategic_modifier_link ?replan_agent ?strategic_modifier)
        (not
          (agent_unlocked ?replan_agent)
        )
      )
    :effect
      (and
        (agent_unlocked ?replan_agent)
        (agent_modifier_staged ?replan_agent)
      )
  )
  (:action integrate_skill_module_into_agent
    :parameters (?replan_agent - replan_agent ?skill_module - skill_module ?equipment_module - equipment_module ?supply_cache - supply_cache ?continuation_node - continuation_node)
    :precondition
      (and
        (agent_unlocked ?replan_agent)
        (agent_skill_module_attached ?replan_agent ?skill_module)
        (entity_assigned_equipment_module ?replan_agent ?equipment_module)
        (agent_linked_supply_cache ?replan_agent ?supply_cache)
        (supply_cache_linked_to_node ?supply_cache ?continuation_node)
        (not
          (continuation_node_secondary_secured ?continuation_node)
        )
        (not
          (agent_skill_integration_ready ?replan_agent)
        )
      )
    :effect (agent_skill_integration_ready ?replan_agent)
  )
  (:action confirm_skill_module_integration
    :parameters (?replan_agent - replan_agent ?skill_module - skill_module ?equipment_module - equipment_module ?supply_cache - supply_cache ?continuation_node - continuation_node)
    :precondition
      (and
        (agent_unlocked ?replan_agent)
        (agent_skill_module_attached ?replan_agent ?skill_module)
        (entity_assigned_equipment_module ?replan_agent ?equipment_module)
        (agent_linked_supply_cache ?replan_agent ?supply_cache)
        (supply_cache_linked_to_node ?supply_cache ?continuation_node)
        (continuation_node_secondary_secured ?continuation_node)
        (not
          (agent_skill_integration_ready ?replan_agent)
        )
      )
    :effect (agent_skill_integration_ready ?replan_agent)
  )
  (:action apply_personality_module
    :parameters (?replan_agent - replan_agent ?personality_module - personality_module ?supply_cache - supply_cache ?continuation_node - continuation_node)
    :precondition
      (and
        (agent_skill_integration_ready ?replan_agent)
        (agent_personality_module_link ?replan_agent ?personality_module)
        (agent_linked_supply_cache ?replan_agent ?supply_cache)
        (supply_cache_linked_to_node ?supply_cache ?continuation_node)
        (not
          (continuation_node_primary_secured ?continuation_node)
        )
        (not
          (continuation_node_secondary_secured ?continuation_node)
        )
        (not
          (agent_personality_applied ?replan_agent)
        )
      )
    :effect (agent_personality_applied ?replan_agent)
  )
  (:action apply_personality_with_modifier
    :parameters (?replan_agent - replan_agent ?personality_module - personality_module ?supply_cache - supply_cache ?continuation_node - continuation_node)
    :precondition
      (and
        (agent_skill_integration_ready ?replan_agent)
        (agent_personality_module_link ?replan_agent ?personality_module)
        (agent_linked_supply_cache ?replan_agent ?supply_cache)
        (supply_cache_linked_to_node ?supply_cache ?continuation_node)
        (continuation_node_primary_secured ?continuation_node)
        (not
          (continuation_node_secondary_secured ?continuation_node)
        )
        (not
          (agent_personality_applied ?replan_agent)
        )
      )
    :effect
      (and
        (agent_personality_applied ?replan_agent)
        (agent_modifier_applied ?replan_agent)
      )
  )
  (:action apply_personality_variant
    :parameters (?replan_agent - replan_agent ?personality_module - personality_module ?supply_cache - supply_cache ?continuation_node - continuation_node)
    :precondition
      (and
        (agent_skill_integration_ready ?replan_agent)
        (agent_personality_module_link ?replan_agent ?personality_module)
        (agent_linked_supply_cache ?replan_agent ?supply_cache)
        (supply_cache_linked_to_node ?supply_cache ?continuation_node)
        (not
          (continuation_node_primary_secured ?continuation_node)
        )
        (continuation_node_secondary_secured ?continuation_node)
        (not
          (agent_personality_applied ?replan_agent)
        )
      )
    :effect
      (and
        (agent_personality_applied ?replan_agent)
        (agent_modifier_applied ?replan_agent)
      )
  )
  (:action apply_personality_combined_variant
    :parameters (?replan_agent - replan_agent ?personality_module - personality_module ?supply_cache - supply_cache ?continuation_node - continuation_node)
    :precondition
      (and
        (agent_skill_integration_ready ?replan_agent)
        (agent_personality_module_link ?replan_agent ?personality_module)
        (agent_linked_supply_cache ?replan_agent ?supply_cache)
        (supply_cache_linked_to_node ?supply_cache ?continuation_node)
        (continuation_node_primary_secured ?continuation_node)
        (continuation_node_secondary_secured ?continuation_node)
        (not
          (agent_personality_applied ?replan_agent)
        )
      )
    :effect
      (and
        (agent_personality_applied ?replan_agent)
        (agent_modifier_applied ?replan_agent)
      )
  )
  (:action authorize_agent_for_assignment
    :parameters (?replan_agent - replan_agent)
    :precondition
      (and
        (agent_personality_applied ?replan_agent)
        (not
          (agent_modifier_applied ?replan_agent)
        )
        (not
          (agent_authorized ?replan_agent)
        )
      )
    :effect
      (and
        (agent_authorized ?replan_agent)
        (entity_assignment_ready ?replan_agent)
      )
  )
  (:action attach_tactical_modifier
    :parameters (?replan_agent - replan_agent ?tactical_modifier - tactical_modifier)
    :precondition
      (and
        (agent_personality_applied ?replan_agent)
        (agent_modifier_applied ?replan_agent)
        (tactical_modifier_available ?tactical_modifier)
      )
    :effect
      (and
        (agent_tactical_modifier_attached ?replan_agent ?tactical_modifier)
        (not
          (tactical_modifier_available ?tactical_modifier)
        )
      )
  )
  (:action finalize_agent_capabilities
    :parameters (?replan_agent - replan_agent ?primary_slot - primary_companion_slot ?secondary_slot - secondary_companion_slot ?role_profile - companion_role_profile ?tactical_modifier - tactical_modifier)
    :precondition
      (and
        (agent_personality_applied ?replan_agent)
        (agent_modifier_applied ?replan_agent)
        (agent_tactical_modifier_attached ?replan_agent ?tactical_modifier)
        (agent_bound_to_primary_slot ?replan_agent ?primary_slot)
        (agent_bound_to_secondary_slot ?replan_agent ?secondary_slot)
        (primary_slot_ready ?primary_slot)
        (secondary_slot_ready ?secondary_slot)
        (entity_assigned_role_profile ?replan_agent ?role_profile)
        (not
          (agent_ready_for_authorization ?replan_agent)
        )
      )
    :effect (agent_ready_for_authorization ?replan_agent)
  )
  (:action authorize_agent_post_finalize
    :parameters (?replan_agent - replan_agent)
    :precondition
      (and
        (agent_personality_applied ?replan_agent)
        (agent_ready_for_authorization ?replan_agent)
        (not
          (agent_authorized ?replan_agent)
        )
      )
    :effect
      (and
        (agent_authorized ?replan_agent)
        (entity_assignment_ready ?replan_agent)
      )
  )
  (:action engage_ally_trait_for_agent
    :parameters (?replan_agent - replan_agent ?ally_trait - ally_trait ?role_profile - companion_role_profile)
    :precondition
      (and
        (entity_assignment_confirmed ?replan_agent)
        (entity_assigned_role_profile ?replan_agent ?role_profile)
        (ally_trait_available ?ally_trait)
        (agent_ally_trait_link ?replan_agent ?ally_trait)
        (not
          (agent_ally_trait_engaged ?replan_agent)
        )
      )
    :effect
      (and
        (agent_ally_trait_engaged ?replan_agent)
        (not
          (ally_trait_available ?ally_trait)
        )
      )
  )
  (:action equip_ally_trait_equipment
    :parameters (?replan_agent - replan_agent ?equipment_module - equipment_module)
    :precondition
      (and
        (agent_ally_trait_engaged ?replan_agent)
        (entity_assigned_equipment_module ?replan_agent ?equipment_module)
        (not
          (agent_trait_equipped ?replan_agent)
        )
      )
    :effect (agent_trait_equipped ?replan_agent)
  )
  (:action apply_personality_module_to_trait
    :parameters (?replan_agent - replan_agent ?personality_module - personality_module)
    :precondition
      (and
        (agent_trait_equipped ?replan_agent)
        (agent_personality_module_link ?replan_agent ?personality_module)
        (not
          (agent_trait_personality_attached ?replan_agent)
        )
      )
    :effect (agent_trait_personality_attached ?replan_agent)
  )
  (:action authorize_trait_application
    :parameters (?replan_agent - replan_agent)
    :precondition
      (and
        (agent_trait_personality_attached ?replan_agent)
        (not
          (agent_authorized ?replan_agent)
        )
      )
    :effect
      (and
        (agent_authorized ?replan_agent)
        (entity_assignment_ready ?replan_agent)
      )
  )
  (:action apply_assignment_to_primary_slot
    :parameters (?primary_slot - primary_companion_slot ?continuation_node - continuation_node)
    :precondition
      (and
        (primary_slot_engaged ?primary_slot)
        (primary_slot_ready ?primary_slot)
        (continuation_node_selected ?continuation_node)
        (continuation_node_ready ?continuation_node)
        (not
          (entity_assignment_ready ?primary_slot)
        )
      )
    :effect (entity_assignment_ready ?primary_slot)
  )
  (:action apply_assignment_to_secondary_slot
    :parameters (?secondary_slot - secondary_companion_slot ?continuation_node - continuation_node)
    :precondition
      (and
        (secondary_slot_engaged ?secondary_slot)
        (secondary_slot_ready ?secondary_slot)
        (continuation_node_selected ?continuation_node)
        (continuation_node_ready ?continuation_node)
        (not
          (entity_assignment_ready ?secondary_slot)
        )
      )
    :effect (entity_assignment_ready ?secondary_slot)
  )
  (:action grant_finalization_authority
    :parameters (?mission_ctx - mission_context ?mission_token - mission_token ?role_profile - companion_role_profile)
    :precondition
      (and
        (entity_assignment_ready ?mission_ctx)
        (entity_assigned_role_profile ?mission_ctx ?role_profile)
        (mission_token_available ?mission_token)
        (not
          (entity_finalization_authorized ?mission_ctx)
        )
      )
    :effect
      (and
        (entity_finalization_authorized ?mission_ctx)
        (entity_mission_token_bound ?mission_ctx ?mission_token)
        (not
          (mission_token_available ?mission_token)
        )
      )
  )
  (:action apply_revised_assignment_to_primary_slot
    :parameters (?primary_slot - primary_companion_slot ?companion_template - companion_template ?mission_token - mission_token)
    :precondition
      (and
        (entity_finalization_authorized ?primary_slot)
        (entity_reserved_companion_template ?primary_slot ?companion_template)
        (entity_mission_token_bound ?primary_slot ?mission_token)
        (not
          (entity_continuation_committed ?primary_slot)
        )
      )
    :effect
      (and
        (entity_continuation_committed ?primary_slot)
        (template_available ?companion_template)
        (mission_token_available ?mission_token)
      )
  )
  (:action apply_revised_assignment_to_secondary_slot
    :parameters (?secondary_slot - secondary_companion_slot ?companion_template - companion_template ?mission_token - mission_token)
    :precondition
      (and
        (entity_finalization_authorized ?secondary_slot)
        (entity_reserved_companion_template ?secondary_slot ?companion_template)
        (entity_mission_token_bound ?secondary_slot ?mission_token)
        (not
          (entity_continuation_committed ?secondary_slot)
        )
      )
    :effect
      (and
        (entity_continuation_committed ?secondary_slot)
        (template_available ?companion_template)
        (mission_token_available ?mission_token)
      )
  )
  (:action apply_revised_assignment_to_agent
    :parameters (?replan_agent - replan_agent ?companion_template - companion_template ?mission_token - mission_token)
    :precondition
      (and
        (entity_finalization_authorized ?replan_agent)
        (entity_reserved_companion_template ?replan_agent ?companion_template)
        (entity_mission_token_bound ?replan_agent ?mission_token)
        (not
          (entity_continuation_committed ?replan_agent)
        )
      )
    :effect
      (and
        (entity_continuation_committed ?replan_agent)
        (template_available ?companion_template)
        (mission_token_available ?mission_token)
      )
  )
)

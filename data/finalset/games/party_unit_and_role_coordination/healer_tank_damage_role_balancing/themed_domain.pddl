(define (domain healer_tank_damage_role_balancing)
  (:requirements :strips :typing :negative-preconditions)
  (:types role_prototype - object resource_prototype - object assignment_prototype - object party - object party_member - party role_token - role_prototype specialization - role_prototype ability - role_prototype role_attachment - role_prototype loadout - role_prototype strategy_token - role_prototype support_resource - role_prototype rotation_module - role_prototype consumable - resource_prototype tactical_marker - resource_prototype objective_indicator - resource_prototype tank_region - assignment_prototype damage_region - assignment_prototype encounter_slot - assignment_prototype frontline_member - party_member support_member - party_member tank_member - frontline_member damage_member - frontline_member healer_member - support_member)
  (:predicates
    (candidate_marked ?party_member - party_member)
    (member_locked ?party_member - party_member)
    (role_assigned ?party_member - party_member)
    (member_deployed ?party_member - party_member)
    (ready_for_deployment ?party_member - party_member)
    (strategy_token_assigned ?party_member - party_member)
    (role_token_available ?role_token - role_token)
    (has_role_token ?party_member - party_member ?role_token - role_token)
    (specialization_available ?specialization - specialization)
    (has_specialization ?party_member - party_member ?specialization - specialization)
    (ability_available ?ability - ability)
    (has_ability ?party_member - party_member ?ability - ability)
    (consumable_available ?consumable - consumable)
    (tank_has_consumable ?tank_member - tank_member ?consumable - consumable)
    (damage_has_consumable ?damage_member - damage_member ?consumable - consumable)
    (tank_assigned_region ?tank_member - tank_member ?tank_region - tank_region)
    (tank_region_primary ?tank_region - tank_region)
    (tank_region_secondary ?tank_region - tank_region)
    (tank_prepared ?tank_member - tank_member)
    (damage_assigned_region ?damage_member - damage_member ?damage_region - damage_region)
    (damage_region_primary ?damage_region - damage_region)
    (damage_region_secondary ?damage_region - damage_region)
    (damage_prepared ?damage_member - damage_member)
    (encounter_slot_available ?encounter_slot - encounter_slot)
    (encounter_allocated ?encounter_slot - encounter_slot)
    (encounter_tank_region_assigned ?encounter_slot - encounter_slot ?tank_region - tank_region)
    (encounter_damage_region_assigned ?encounter_slot - encounter_slot ?damage_region - damage_region)
    (encounter_tank_secondary ?encounter_slot - encounter_slot)
    (encounter_damage_secondary ?encounter_slot - encounter_slot)
    (encounter_primed ?encounter_slot - encounter_slot)
    (healer_linked_tank_member ?healer_member - healer_member ?tank_member - tank_member)
    (healer_linked_damage_member ?healer_member - healer_member ?damage_member - damage_member)
    (healer_assigned_encounter ?healer_member - healer_member ?encounter_slot - encounter_slot)
    (marker_available ?tactical_marker - tactical_marker)
    (healer_has_marker ?healer_member - healer_member ?tactical_marker - tactical_marker)
    (marker_active ?tactical_marker - tactical_marker)
    (marker_linked_encounter ?tactical_marker - tactical_marker ?encounter_slot - encounter_slot)
    (healer_marker_claimed ?healer_member - healer_member)
    (healer_loadout_configured ?healer_member - healer_member)
    (healer_rotation_bound ?healer_member - healer_member)
    (attachment_applied ?healer_member - healer_member)
    (attachment_aux_flag ?healer_member - healer_member)
    (healer_aux_configured ?healer_member - healer_member)
    (healer_ready_check ?healer_member - healer_member)
    (objective_indicator_available ?objective_indicator - objective_indicator)
    (healer_has_objective_indicator ?healer_member - healer_member ?objective_indicator - objective_indicator)
    (objective_applied ?healer_member - healer_member)
    (objective_prepared ?healer_member - healer_member)
    (objective_ready ?healer_member - healer_member)
    (role_attachment_available ?role_attachment - role_attachment)
    (healer_has_attachment ?healer_member - healer_member ?role_attachment - role_attachment)
    (loadout_available ?loadout - loadout)
    (healer_has_loadout ?healer_member - healer_member ?loadout - loadout)
    (support_resource_available ?support_resource - support_resource)
    (healer_bound_support_resource ?healer_member - healer_member ?support_resource - support_resource)
    (rotation_module_available ?rotation_module - rotation_module)
    (healer_bound_rotation_module ?healer_member - healer_member ?rotation_module - rotation_module)
    (strategy_token_available ?strategy_token - strategy_token)
    (has_strategy_token ?party_member - party_member ?strategy_token - strategy_token)
    (tank_ready ?tank_member - tank_member)
    (damage_ready ?damage_member - damage_member)
    (healer_configuration_finalized ?healer_member - healer_member)
  )
  (:action mark_candidate
    :parameters (?party_member - party_member)
    :precondition
      (and
        (not
          (candidate_marked ?party_member)
        )
        (not
          (member_deployed ?party_member)
        )
      )
    :effect (candidate_marked ?party_member)
  )
  (:action assign_role_token_to_member
    :parameters (?party_member - party_member ?role_token - role_token)
    :precondition
      (and
        (candidate_marked ?party_member)
        (not
          (role_assigned ?party_member)
        )
        (role_token_available ?role_token)
      )
    :effect
      (and
        (role_assigned ?party_member)
        (has_role_token ?party_member ?role_token)
        (not
          (role_token_available ?role_token)
        )
      )
  )
  (:action bind_specialization_to_member
    :parameters (?party_member - party_member ?specialization - specialization)
    :precondition
      (and
        (candidate_marked ?party_member)
        (role_assigned ?party_member)
        (specialization_available ?specialization)
      )
    :effect
      (and
        (has_specialization ?party_member ?specialization)
        (not
          (specialization_available ?specialization)
        )
      )
  )
  (:action lock_member_specialization
    :parameters (?party_member - party_member ?specialization - specialization)
    :precondition
      (and
        (candidate_marked ?party_member)
        (role_assigned ?party_member)
        (has_specialization ?party_member ?specialization)
        (not
          (member_locked ?party_member)
        )
      )
    :effect (member_locked ?party_member)
  )
  (:action release_specialization_from_member
    :parameters (?party_member - party_member ?specialization - specialization)
    :precondition
      (and
        (has_specialization ?party_member ?specialization)
      )
    :effect
      (and
        (specialization_available ?specialization)
        (not
          (has_specialization ?party_member ?specialization)
        )
      )
  )
  (:action assign_ability_to_member
    :parameters (?party_member - party_member ?ability - ability)
    :precondition
      (and
        (member_locked ?party_member)
        (ability_available ?ability)
      )
    :effect
      (and
        (has_ability ?party_member ?ability)
        (not
          (ability_available ?ability)
        )
      )
  )
  (:action remove_ability_from_member
    :parameters (?party_member - party_member ?ability - ability)
    :precondition
      (and
        (has_ability ?party_member ?ability)
      )
    :effect
      (and
        (ability_available ?ability)
        (not
          (has_ability ?party_member ?ability)
        )
      )
  )
  (:action allocate_support_resource_to_healer
    :parameters (?healer_member - healer_member ?support_resource - support_resource)
    :precondition
      (and
        (member_locked ?healer_member)
        (support_resource_available ?support_resource)
      )
    :effect
      (and
        (healer_bound_support_resource ?healer_member ?support_resource)
        (not
          (support_resource_available ?support_resource)
        )
      )
  )
  (:action release_support_resource_from_healer
    :parameters (?healer_member - healer_member ?support_resource - support_resource)
    :precondition
      (and
        (healer_bound_support_resource ?healer_member ?support_resource)
      )
    :effect
      (and
        (support_resource_available ?support_resource)
        (not
          (healer_bound_support_resource ?healer_member ?support_resource)
        )
      )
  )
  (:action allocate_rotation_module_to_healer
    :parameters (?healer_member - healer_member ?rotation_module - rotation_module)
    :precondition
      (and
        (member_locked ?healer_member)
        (rotation_module_available ?rotation_module)
      )
    :effect
      (and
        (healer_bound_rotation_module ?healer_member ?rotation_module)
        (not
          (rotation_module_available ?rotation_module)
        )
      )
  )
  (:action release_rotation_module_from_healer
    :parameters (?healer_member - healer_member ?rotation_module - rotation_module)
    :precondition
      (and
        (healer_bound_rotation_module ?healer_member ?rotation_module)
      )
    :effect
      (and
        (rotation_module_available ?rotation_module)
        (not
          (healer_bound_rotation_module ?healer_member ?rotation_module)
        )
      )
  )
  (:action assign_tank_to_region_primary
    :parameters (?tank_member - tank_member ?tank_region - tank_region ?specialization - specialization)
    :precondition
      (and
        (member_locked ?tank_member)
        (has_specialization ?tank_member ?specialization)
        (tank_assigned_region ?tank_member ?tank_region)
        (not
          (tank_region_primary ?tank_region)
        )
        (not
          (tank_region_secondary ?tank_region)
        )
      )
    :effect (tank_region_primary ?tank_region)
  )
  (:action confirm_tank_readiness_with_ability
    :parameters (?tank_member - tank_member ?tank_region - tank_region ?ability - ability)
    :precondition
      (and
        (member_locked ?tank_member)
        (has_ability ?tank_member ?ability)
        (tank_assigned_region ?tank_member ?tank_region)
        (tank_region_primary ?tank_region)
        (not
          (tank_ready ?tank_member)
        )
      )
    :effect
      (and
        (tank_ready ?tank_member)
        (tank_prepared ?tank_member)
      )
  )
  (:action use_consumable_on_tank
    :parameters (?tank_member - tank_member ?tank_region - tank_region ?consumable - consumable)
    :precondition
      (and
        (member_locked ?tank_member)
        (tank_assigned_region ?tank_member ?tank_region)
        (consumable_available ?consumable)
        (not
          (tank_ready ?tank_member)
        )
      )
    :effect
      (and
        (tank_region_secondary ?tank_region)
        (tank_ready ?tank_member)
        (tank_has_consumable ?tank_member ?consumable)
        (not
          (consumable_available ?consumable)
        )
      )
  )
  (:action finalize_tank_readiness
    :parameters (?tank_member - tank_member ?tank_region - tank_region ?specialization - specialization ?consumable - consumable)
    :precondition
      (and
        (member_locked ?tank_member)
        (has_specialization ?tank_member ?specialization)
        (tank_assigned_region ?tank_member ?tank_region)
        (tank_region_secondary ?tank_region)
        (tank_has_consumable ?tank_member ?consumable)
        (not
          (tank_prepared ?tank_member)
        )
      )
    :effect
      (and
        (tank_region_primary ?tank_region)
        (tank_prepared ?tank_member)
        (consumable_available ?consumable)
        (not
          (tank_has_consumable ?tank_member ?consumable)
        )
      )
  )
  (:action assign_damage_to_region_primary
    :parameters (?damage_member - damage_member ?damage_region - damage_region ?specialization - specialization)
    :precondition
      (and
        (member_locked ?damage_member)
        (has_specialization ?damage_member ?specialization)
        (damage_assigned_region ?damage_member ?damage_region)
        (not
          (damage_region_primary ?damage_region)
        )
        (not
          (damage_region_secondary ?damage_region)
        )
      )
    :effect (damage_region_primary ?damage_region)
  )
  (:action confirm_damage_readiness_with_ability
    :parameters (?damage_member - damage_member ?damage_region - damage_region ?ability - ability)
    :precondition
      (and
        (member_locked ?damage_member)
        (has_ability ?damage_member ?ability)
        (damage_assigned_region ?damage_member ?damage_region)
        (damage_region_primary ?damage_region)
        (not
          (damage_ready ?damage_member)
        )
      )
    :effect
      (and
        (damage_ready ?damage_member)
        (damage_prepared ?damage_member)
      )
  )
  (:action use_consumable_on_damage
    :parameters (?damage_member - damage_member ?damage_region - damage_region ?consumable - consumable)
    :precondition
      (and
        (member_locked ?damage_member)
        (damage_assigned_region ?damage_member ?damage_region)
        (consumable_available ?consumable)
        (not
          (damage_ready ?damage_member)
        )
      )
    :effect
      (and
        (damage_region_secondary ?damage_region)
        (damage_ready ?damage_member)
        (damage_has_consumable ?damage_member ?consumable)
        (not
          (consumable_available ?consumable)
        )
      )
  )
  (:action finalize_damage_readiness
    :parameters (?damage_member - damage_member ?damage_region - damage_region ?specialization - specialization ?consumable - consumable)
    :precondition
      (and
        (member_locked ?damage_member)
        (has_specialization ?damage_member ?specialization)
        (damage_assigned_region ?damage_member ?damage_region)
        (damage_region_secondary ?damage_region)
        (damage_has_consumable ?damage_member ?consumable)
        (not
          (damage_prepared ?damage_member)
        )
      )
    :effect
      (and
        (damage_region_primary ?damage_region)
        (damage_prepared ?damage_member)
        (consumable_available ?consumable)
        (not
          (damage_has_consumable ?damage_member ?consumable)
        )
      )
  )
  (:action allocate_encounter_slot
    :parameters (?tank_member - tank_member ?damage_member - damage_member ?tank_region - tank_region ?damage_region - damage_region ?encounter_slot - encounter_slot)
    :precondition
      (and
        (tank_ready ?tank_member)
        (damage_ready ?damage_member)
        (tank_assigned_region ?tank_member ?tank_region)
        (damage_assigned_region ?damage_member ?damage_region)
        (tank_region_primary ?tank_region)
        (damage_region_primary ?damage_region)
        (tank_prepared ?tank_member)
        (damage_prepared ?damage_member)
        (encounter_slot_available ?encounter_slot)
      )
    :effect
      (and
        (encounter_allocated ?encounter_slot)
        (encounter_tank_region_assigned ?encounter_slot ?tank_region)
        (encounter_damage_region_assigned ?encounter_slot ?damage_region)
        (not
          (encounter_slot_available ?encounter_slot)
        )
      )
  )
  (:action allocate_encounter_slot_with_tank_secondary
    :parameters (?tank_member - tank_member ?damage_member - damage_member ?tank_region - tank_region ?damage_region - damage_region ?encounter_slot - encounter_slot)
    :precondition
      (and
        (tank_ready ?tank_member)
        (damage_ready ?damage_member)
        (tank_assigned_region ?tank_member ?tank_region)
        (damage_assigned_region ?damage_member ?damage_region)
        (tank_region_secondary ?tank_region)
        (damage_region_primary ?damage_region)
        (not
          (tank_prepared ?tank_member)
        )
        (damage_prepared ?damage_member)
        (encounter_slot_available ?encounter_slot)
      )
    :effect
      (and
        (encounter_allocated ?encounter_slot)
        (encounter_tank_region_assigned ?encounter_slot ?tank_region)
        (encounter_damage_region_assigned ?encounter_slot ?damage_region)
        (encounter_tank_secondary ?encounter_slot)
        (not
          (encounter_slot_available ?encounter_slot)
        )
      )
  )
  (:action allocate_encounter_slot_with_damage_secondary
    :parameters (?tank_member - tank_member ?damage_member - damage_member ?tank_region - tank_region ?damage_region - damage_region ?encounter_slot - encounter_slot)
    :precondition
      (and
        (tank_ready ?tank_member)
        (damage_ready ?damage_member)
        (tank_assigned_region ?tank_member ?tank_region)
        (damage_assigned_region ?damage_member ?damage_region)
        (tank_region_primary ?tank_region)
        (damage_region_secondary ?damage_region)
        (tank_prepared ?tank_member)
        (not
          (damage_prepared ?damage_member)
        )
        (encounter_slot_available ?encounter_slot)
      )
    :effect
      (and
        (encounter_allocated ?encounter_slot)
        (encounter_tank_region_assigned ?encounter_slot ?tank_region)
        (encounter_damage_region_assigned ?encounter_slot ?damage_region)
        (encounter_damage_secondary ?encounter_slot)
        (not
          (encounter_slot_available ?encounter_slot)
        )
      )
  )
  (:action allocate_encounter_slot_with_both_secondary
    :parameters (?tank_member - tank_member ?damage_member - damage_member ?tank_region - tank_region ?damage_region - damage_region ?encounter_slot - encounter_slot)
    :precondition
      (and
        (tank_ready ?tank_member)
        (damage_ready ?damage_member)
        (tank_assigned_region ?tank_member ?tank_region)
        (damage_assigned_region ?damage_member ?damage_region)
        (tank_region_secondary ?tank_region)
        (damage_region_secondary ?damage_region)
        (not
          (tank_prepared ?tank_member)
        )
        (not
          (damage_prepared ?damage_member)
        )
        (encounter_slot_available ?encounter_slot)
      )
    :effect
      (and
        (encounter_allocated ?encounter_slot)
        (encounter_tank_region_assigned ?encounter_slot ?tank_region)
        (encounter_damage_region_assigned ?encounter_slot ?damage_region)
        (encounter_tank_secondary ?encounter_slot)
        (encounter_damage_secondary ?encounter_slot)
        (not
          (encounter_slot_available ?encounter_slot)
        )
      )
  )
  (:action prime_encounter_for_healer_assignment
    :parameters (?encounter_slot - encounter_slot ?tank_member - tank_member ?specialization - specialization)
    :precondition
      (and
        (encounter_allocated ?encounter_slot)
        (tank_ready ?tank_member)
        (has_specialization ?tank_member ?specialization)
        (not
          (encounter_primed ?encounter_slot)
        )
      )
    :effect (encounter_primed ?encounter_slot)
  )
  (:action apply_tactical_marker_to_encounter
    :parameters (?healer_member - healer_member ?tactical_marker - tactical_marker ?encounter_slot - encounter_slot)
    :precondition
      (and
        (member_locked ?healer_member)
        (healer_assigned_encounter ?healer_member ?encounter_slot)
        (healer_has_marker ?healer_member ?tactical_marker)
        (marker_available ?tactical_marker)
        (encounter_allocated ?encounter_slot)
        (encounter_primed ?encounter_slot)
        (not
          (marker_active ?tactical_marker)
        )
      )
    :effect
      (and
        (marker_active ?tactical_marker)
        (marker_linked_encounter ?tactical_marker ?encounter_slot)
        (not
          (marker_available ?tactical_marker)
        )
      )
  )
  (:action claim_tactical_marker_by_healer
    :parameters (?healer_member - healer_member ?tactical_marker - tactical_marker ?encounter_slot - encounter_slot ?specialization - specialization)
    :precondition
      (and
        (member_locked ?healer_member)
        (healer_has_marker ?healer_member ?tactical_marker)
        (marker_active ?tactical_marker)
        (marker_linked_encounter ?tactical_marker ?encounter_slot)
        (has_specialization ?healer_member ?specialization)
        (not
          (encounter_tank_secondary ?encounter_slot)
        )
        (not
          (healer_marker_claimed ?healer_member)
        )
      )
    :effect (healer_marker_claimed ?healer_member)
  )
  (:action apply_role_attachment_to_healer
    :parameters (?healer_member - healer_member ?role_attachment - role_attachment)
    :precondition
      (and
        (member_locked ?healer_member)
        (role_attachment_available ?role_attachment)
        (not
          (attachment_applied ?healer_member)
        )
      )
    :effect
      (and
        (attachment_applied ?healer_member)
        (healer_has_attachment ?healer_member ?role_attachment)
        (not
          (role_attachment_available ?role_attachment)
        )
      )
  )
  (:action finalize_marker_and_attachment
    :parameters (?healer_member - healer_member ?tactical_marker - tactical_marker ?encounter_slot - encounter_slot ?specialization - specialization ?role_attachment - role_attachment)
    :precondition
      (and
        (member_locked ?healer_member)
        (healer_has_marker ?healer_member ?tactical_marker)
        (marker_active ?tactical_marker)
        (marker_linked_encounter ?tactical_marker ?encounter_slot)
        (has_specialization ?healer_member ?specialization)
        (encounter_tank_secondary ?encounter_slot)
        (attachment_applied ?healer_member)
        (healer_has_attachment ?healer_member ?role_attachment)
        (not
          (healer_marker_claimed ?healer_member)
        )
      )
    :effect
      (and
        (healer_marker_claimed ?healer_member)
        (attachment_aux_flag ?healer_member)
      )
  )
  (:action configure_healer_loadout_stage1
    :parameters (?healer_member - healer_member ?support_resource - support_resource ?ability - ability ?tactical_marker - tactical_marker ?encounter_slot - encounter_slot)
    :precondition
      (and
        (healer_marker_claimed ?healer_member)
        (healer_bound_support_resource ?healer_member ?support_resource)
        (has_ability ?healer_member ?ability)
        (healer_has_marker ?healer_member ?tactical_marker)
        (marker_linked_encounter ?tactical_marker ?encounter_slot)
        (not
          (encounter_damage_secondary ?encounter_slot)
        )
        (not
          (healer_loadout_configured ?healer_member)
        )
      )
    :effect (healer_loadout_configured ?healer_member)
  )
  (:action configure_healer_loadout_stage2
    :parameters (?healer_member - healer_member ?support_resource - support_resource ?ability - ability ?tactical_marker - tactical_marker ?encounter_slot - encounter_slot)
    :precondition
      (and
        (healer_marker_claimed ?healer_member)
        (healer_bound_support_resource ?healer_member ?support_resource)
        (has_ability ?healer_member ?ability)
        (healer_has_marker ?healer_member ?tactical_marker)
        (marker_linked_encounter ?tactical_marker ?encounter_slot)
        (encounter_damage_secondary ?encounter_slot)
        (not
          (healer_loadout_configured ?healer_member)
        )
      )
    :effect (healer_loadout_configured ?healer_member)
  )
  (:action bind_healer_rotation
    :parameters (?healer_member - healer_member ?rotation_module - rotation_module ?tactical_marker - tactical_marker ?encounter_slot - encounter_slot)
    :precondition
      (and
        (healer_loadout_configured ?healer_member)
        (healer_bound_rotation_module ?healer_member ?rotation_module)
        (healer_has_marker ?healer_member ?tactical_marker)
        (marker_linked_encounter ?tactical_marker ?encounter_slot)
        (not
          (encounter_tank_secondary ?encounter_slot)
        )
        (not
          (encounter_damage_secondary ?encounter_slot)
        )
        (not
          (healer_rotation_bound ?healer_member)
        )
      )
    :effect (healer_rotation_bound ?healer_member)
  )
  (:action bind_healer_rotation_and_aux
    :parameters (?healer_member - healer_member ?rotation_module - rotation_module ?tactical_marker - tactical_marker ?encounter_slot - encounter_slot)
    :precondition
      (and
        (healer_loadout_configured ?healer_member)
        (healer_bound_rotation_module ?healer_member ?rotation_module)
        (healer_has_marker ?healer_member ?tactical_marker)
        (marker_linked_encounter ?tactical_marker ?encounter_slot)
        (encounter_tank_secondary ?encounter_slot)
        (not
          (encounter_damage_secondary ?encounter_slot)
        )
        (not
          (healer_rotation_bound ?healer_member)
        )
      )
    :effect
      (and
        (healer_rotation_bound ?healer_member)
        (healer_aux_configured ?healer_member)
      )
  )
  (:action bind_healer_rotation_and_aux_variant2
    :parameters (?healer_member - healer_member ?rotation_module - rotation_module ?tactical_marker - tactical_marker ?encounter_slot - encounter_slot)
    :precondition
      (and
        (healer_loadout_configured ?healer_member)
        (healer_bound_rotation_module ?healer_member ?rotation_module)
        (healer_has_marker ?healer_member ?tactical_marker)
        (marker_linked_encounter ?tactical_marker ?encounter_slot)
        (not
          (encounter_tank_secondary ?encounter_slot)
        )
        (encounter_damage_secondary ?encounter_slot)
        (not
          (healer_rotation_bound ?healer_member)
        )
      )
    :effect
      (and
        (healer_rotation_bound ?healer_member)
        (healer_aux_configured ?healer_member)
      )
  )
  (:action bind_healer_rotation_and_aux_variant3
    :parameters (?healer_member - healer_member ?rotation_module - rotation_module ?tactical_marker - tactical_marker ?encounter_slot - encounter_slot)
    :precondition
      (and
        (healer_loadout_configured ?healer_member)
        (healer_bound_rotation_module ?healer_member ?rotation_module)
        (healer_has_marker ?healer_member ?tactical_marker)
        (marker_linked_encounter ?tactical_marker ?encounter_slot)
        (encounter_tank_secondary ?encounter_slot)
        (encounter_damage_secondary ?encounter_slot)
        (not
          (healer_rotation_bound ?healer_member)
        )
      )
    :effect
      (and
        (healer_rotation_bound ?healer_member)
        (healer_aux_configured ?healer_member)
      )
  )
  (:action finalize_healer_configuration
    :parameters (?healer_member - healer_member)
    :precondition
      (and
        (healer_rotation_bound ?healer_member)
        (not
          (healer_aux_configured ?healer_member)
        )
        (not
          (healer_configuration_finalized ?healer_member)
        )
      )
    :effect
      (and
        (healer_configuration_finalized ?healer_member)
        (ready_for_deployment ?healer_member)
      )
  )
  (:action assign_loadout_to_healer
    :parameters (?healer_member - healer_member ?loadout - loadout)
    :precondition
      (and
        (healer_rotation_bound ?healer_member)
        (healer_aux_configured ?healer_member)
        (loadout_available ?loadout)
      )
    :effect
      (and
        (healer_has_loadout ?healer_member ?loadout)
        (not
          (loadout_available ?loadout)
        )
      )
  )
  (:action perform_healer_readiness_check
    :parameters (?healer_member - healer_member ?tank_member - tank_member ?damage_member - damage_member ?specialization - specialization ?loadout - loadout)
    :precondition
      (and
        (healer_rotation_bound ?healer_member)
        (healer_aux_configured ?healer_member)
        (healer_has_loadout ?healer_member ?loadout)
        (healer_linked_tank_member ?healer_member ?tank_member)
        (healer_linked_damage_member ?healer_member ?damage_member)
        (tank_prepared ?tank_member)
        (damage_prepared ?damage_member)
        (has_specialization ?healer_member ?specialization)
        (not
          (healer_ready_check ?healer_member)
        )
      )
    :effect (healer_ready_check ?healer_member)
  )
  (:action confirm_healer_ready
    :parameters (?healer_member - healer_member)
    :precondition
      (and
        (healer_rotation_bound ?healer_member)
        (healer_ready_check ?healer_member)
        (not
          (healer_configuration_finalized ?healer_member)
        )
      )
    :effect
      (and
        (healer_configuration_finalized ?healer_member)
        (ready_for_deployment ?healer_member)
      )
  )
  (:action apply_objective_indicator
    :parameters (?healer_member - healer_member ?objective_indicator - objective_indicator ?specialization - specialization)
    :precondition
      (and
        (member_locked ?healer_member)
        (has_specialization ?healer_member ?specialization)
        (objective_indicator_available ?objective_indicator)
        (healer_has_objective_indicator ?healer_member ?objective_indicator)
        (not
          (objective_applied ?healer_member)
        )
      )
    :effect
      (and
        (objective_applied ?healer_member)
        (not
          (objective_indicator_available ?objective_indicator)
        )
      )
  )
  (:action prepare_objective
    :parameters (?healer_member - healer_member ?ability - ability)
    :precondition
      (and
        (objective_applied ?healer_member)
        (has_ability ?healer_member ?ability)
        (not
          (objective_prepared ?healer_member)
        )
      )
    :effect (objective_prepared ?healer_member)
  )
  (:action activate_objective
    :parameters (?healer_member - healer_member ?rotation_module - rotation_module)
    :precondition
      (and
        (objective_prepared ?healer_member)
        (healer_bound_rotation_module ?healer_member ?rotation_module)
        (not
          (objective_ready ?healer_member)
        )
      )
    :effect (objective_ready ?healer_member)
  )
  (:action finalize_objective_activation
    :parameters (?healer_member - healer_member)
    :precondition
      (and
        (objective_ready ?healer_member)
        (not
          (healer_configuration_finalized ?healer_member)
        )
      )
    :effect
      (and
        (healer_configuration_finalized ?healer_member)
        (ready_for_deployment ?healer_member)
      )
  )
  (:action mark_tank_ready
    :parameters (?tank_member - tank_member ?encounter_slot - encounter_slot)
    :precondition
      (and
        (tank_ready ?tank_member)
        (tank_prepared ?tank_member)
        (encounter_allocated ?encounter_slot)
        (encounter_primed ?encounter_slot)
        (not
          (ready_for_deployment ?tank_member)
        )
      )
    :effect (ready_for_deployment ?tank_member)
  )
  (:action mark_damage_ready
    :parameters (?damage_member - damage_member ?encounter_slot - encounter_slot)
    :precondition
      (and
        (damage_ready ?damage_member)
        (damage_prepared ?damage_member)
        (encounter_allocated ?encounter_slot)
        (encounter_primed ?encounter_slot)
        (not
          (ready_for_deployment ?damage_member)
        )
      )
    :effect (ready_for_deployment ?damage_member)
  )
  (:action bind_strategy_token_to_member
    :parameters (?party_member - party_member ?strategy_token - strategy_token ?specialization - specialization)
    :precondition
      (and
        (ready_for_deployment ?party_member)
        (has_specialization ?party_member ?specialization)
        (strategy_token_available ?strategy_token)
        (not
          (strategy_token_assigned ?party_member)
        )
      )
    :effect
      (and
        (strategy_token_assigned ?party_member)
        (has_strategy_token ?party_member ?strategy_token)
        (not
          (strategy_token_available ?strategy_token)
        )
      )
  )
  (:action finalize_role_assignment_to_tank
    :parameters (?tank_member - tank_member ?role_token - role_token ?strategy_token - strategy_token)
    :precondition
      (and
        (strategy_token_assigned ?tank_member)
        (has_role_token ?tank_member ?role_token)
        (has_strategy_token ?tank_member ?strategy_token)
        (not
          (member_deployed ?tank_member)
        )
      )
    :effect
      (and
        (member_deployed ?tank_member)
        (role_token_available ?role_token)
        (strategy_token_available ?strategy_token)
      )
  )
  (:action finalize_role_assignment_to_damage
    :parameters (?damage_member - damage_member ?role_token - role_token ?strategy_token - strategy_token)
    :precondition
      (and
        (strategy_token_assigned ?damage_member)
        (has_role_token ?damage_member ?role_token)
        (has_strategy_token ?damage_member ?strategy_token)
        (not
          (member_deployed ?damage_member)
        )
      )
    :effect
      (and
        (member_deployed ?damage_member)
        (role_token_available ?role_token)
        (strategy_token_available ?strategy_token)
      )
  )
  (:action finalize_role_assignment_to_healer
    :parameters (?healer_member - healer_member ?role_token - role_token ?strategy_token - strategy_token)
    :precondition
      (and
        (strategy_token_assigned ?healer_member)
        (has_role_token ?healer_member ?role_token)
        (has_strategy_token ?healer_member ?strategy_token)
        (not
          (member_deployed ?healer_member)
        )
      )
    :effect
      (and
        (member_deployed ?healer_member)
        (role_token_available ?role_token)
        (strategy_token_available ?strategy_token)
      )
  )
)

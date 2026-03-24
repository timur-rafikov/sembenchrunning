(define (domain final_encounter_role_reconfiguration)
  (:requirements :strips :typing :negative-preconditions)
  (:types equipment_group - object binding_group - object marker_group - object unit_type - object party_unit - unit_type role_token - equipment_group ability_slot - equipment_group support_device - equipment_group attunement_token - equipment_group synergy_token - equipment_group final_marker - equipment_group specialist_module - equipment_group boon_token - equipment_group consumable_payload - binding_group target_marker - binding_group order_token - binding_group position_marker_a - marker_group position_marker_b - marker_group execution_device - marker_group unit_slot_group - party_unit unit_slot_group_alt - party_unit subgroup_slot_alpha - unit_slot_group subgroup_slot_beta - unit_slot_group encounter_coordinator - unit_slot_group_alt)
  (:predicates
    (unit_registered ?party_unit - party_unit)
    (unit_ready ?party_unit - party_unit)
    (role_selected ?party_unit - party_unit)
    (unit_committed ?party_unit - party_unit)
    (activation_ready ?party_unit - party_unit)
    (final_marker_attached ?party_unit - party_unit)
    (role_token_available ?role_token - role_token)
    (unit_role_bound ?party_unit - party_unit ?role_token - role_token)
    (ability_slot_available ?ability_slot - ability_slot)
    (unit_ability_bound ?party_unit - party_unit ?ability_slot - ability_slot)
    (support_device_available ?support_device - support_device)
    (unit_support_attached ?party_unit - party_unit ?support_device - support_device)
    (payload_available ?consumable_payload - consumable_payload)
    (alpha_payload_attached ?subgroup_slot_alpha - subgroup_slot_alpha ?consumable_payload - consumable_payload)
    (beta_payload_attached ?subgroup_slot_beta - subgroup_slot_beta ?consumable_payload - consumable_payload)
    (alpha_position_claimed ?subgroup_slot_alpha - subgroup_slot_alpha ?position_marker_a - position_marker_a)
    (position_a_claimed ?position_marker_a - position_marker_a)
    (position_a_loaded ?position_marker_a - position_marker_a)
    (alpha_ready ?subgroup_slot_alpha - subgroup_slot_alpha)
    (beta_position_claimed ?subgroup_slot_beta - subgroup_slot_beta ?position_marker_b - position_marker_b)
    (position_b_claimed ?position_marker_b - position_marker_b)
    (position_b_loaded ?position_marker_b - position_marker_b)
    (beta_ready ?subgroup_slot_beta - subgroup_slot_beta)
    (device_available ?execution_device - execution_device)
    (device_prepared ?execution_device - execution_device)
    (device_bound_to_position_a ?execution_device - execution_device ?position_marker_a - position_marker_a)
    (device_bound_to_position_b ?execution_device - execution_device ?position_marker_b - position_marker_b)
    (device_has_alpha_payload ?execution_device - execution_device)
    (device_has_beta_payload ?execution_device - execution_device)
    (device_target_ready ?execution_device - execution_device)
    (coordinator_has_alpha_slot ?encounter_coordinator - encounter_coordinator ?subgroup_slot_alpha - subgroup_slot_alpha)
    (coordinator_has_beta_slot ?encounter_coordinator - encounter_coordinator ?subgroup_slot_beta - subgroup_slot_beta)
    (coordinator_assigned_device ?encounter_coordinator - encounter_coordinator ?execution_device - execution_device)
    (target_marker_available ?target_marker - target_marker)
    (coordinator_target_attached ?encounter_coordinator - encounter_coordinator ?target_marker - target_marker)
    (target_marker_locked ?target_marker - target_marker)
    (target_bound_to_device ?target_marker - target_marker ?execution_device - execution_device)
    (coordinator_payload_ready ?encounter_coordinator - encounter_coordinator)
    (coordinator_payload_integrated ?encounter_coordinator - encounter_coordinator)
    (coordinator_final_ready ?encounter_coordinator - encounter_coordinator)
    (coordinator_attuned ?encounter_coordinator - encounter_coordinator)
    (coordinator_payload_staged ?encounter_coordinator - encounter_coordinator)
    (coordinator_payload_verified ?encounter_coordinator - encounter_coordinator)
    (coordinator_execution_staged ?encounter_coordinator - encounter_coordinator)
    (order_token_available ?order_token - order_token)
    (coordinator_has_order_token ?encounter_coordinator - encounter_coordinator ?order_token - order_token)
    (coordinator_order_locked ?encounter_coordinator - encounter_coordinator)
    (coordinator_order_step_started ?encounter_coordinator - encounter_coordinator)
    (coordinator_order_complete ?encounter_coordinator - encounter_coordinator)
    (attunement_token_available ?attunement_token - attunement_token)
    (coordinator_has_attunement ?encounter_coordinator - encounter_coordinator ?attunement_token - attunement_token)
    (synergy_token_available ?synergy_token - synergy_token)
    (coordinator_has_synergy_token ?encounter_coordinator - encounter_coordinator ?synergy_token - synergy_token)
    (specialist_available ?specialist_module - specialist_module)
    (coordinator_has_specialist ?encounter_coordinator - encounter_coordinator ?specialist_module - specialist_module)
    (boon_token_available ?boon_token - boon_token)
    (coordinator_has_boon ?encounter_coordinator - encounter_coordinator ?boon_token - boon_token)
    (final_marker_available ?final_marker - final_marker)
    (unit_bound_to_final_marker ?party_unit - party_unit ?final_marker - final_marker)
    (alpha_slot_confirmed ?subgroup_slot_alpha - subgroup_slot_alpha)
    (beta_slot_confirmed ?subgroup_slot_beta - subgroup_slot_beta)
    (coordinator_committed ?encounter_coordinator - encounter_coordinator)
  )
  (:action register_unit_for_final_phase
    :parameters (?party_unit - party_unit)
    :precondition
      (and
        (not
          (unit_registered ?party_unit)
        )
        (not
          (unit_committed ?party_unit)
        )
      )
    :effect (unit_registered ?party_unit)
  )
  (:action assign_role_token_to_unit
    :parameters (?party_unit - party_unit ?role_token - role_token)
    :precondition
      (and
        (unit_registered ?party_unit)
        (not
          (role_selected ?party_unit)
        )
        (role_token_available ?role_token)
      )
    :effect
      (and
        (role_selected ?party_unit)
        (unit_role_bound ?party_unit ?role_token)
        (not
          (role_token_available ?role_token)
        )
      )
  )
  (:action bind_ability_slot_to_unit
    :parameters (?party_unit - party_unit ?ability_slot - ability_slot)
    :precondition
      (and
        (unit_registered ?party_unit)
        (role_selected ?party_unit)
        (ability_slot_available ?ability_slot)
      )
    :effect
      (and
        (unit_ability_bound ?party_unit ?ability_slot)
        (not
          (ability_slot_available ?ability_slot)
        )
      )
  )
  (:action confirm_unit_readiness
    :parameters (?party_unit - party_unit ?ability_slot - ability_slot)
    :precondition
      (and
        (unit_registered ?party_unit)
        (role_selected ?party_unit)
        (unit_ability_bound ?party_unit ?ability_slot)
        (not
          (unit_ready ?party_unit)
        )
      )
    :effect (unit_ready ?party_unit)
  )
  (:action release_ability_slot_from_unit
    :parameters (?party_unit - party_unit ?ability_slot - ability_slot)
    :precondition
      (and
        (unit_ability_bound ?party_unit ?ability_slot)
      )
    :effect
      (and
        (ability_slot_available ?ability_slot)
        (not
          (unit_ability_bound ?party_unit ?ability_slot)
        )
      )
  )
  (:action attach_support_device_to_unit
    :parameters (?party_unit - party_unit ?support_device - support_device)
    :precondition
      (and
        (unit_ready ?party_unit)
        (support_device_available ?support_device)
      )
    :effect
      (and
        (unit_support_attached ?party_unit ?support_device)
        (not
          (support_device_available ?support_device)
        )
      )
  )
  (:action detach_support_device_from_unit
    :parameters (?party_unit - party_unit ?support_device - support_device)
    :precondition
      (and
        (unit_support_attached ?party_unit ?support_device)
      )
    :effect
      (and
        (support_device_available ?support_device)
        (not
          (unit_support_attached ?party_unit ?support_device)
        )
      )
  )
  (:action attach_specialist_to_coordinator
    :parameters (?encounter_coordinator - encounter_coordinator ?specialist_module - specialist_module)
    :precondition
      (and
        (unit_ready ?encounter_coordinator)
        (specialist_available ?specialist_module)
      )
    :effect
      (and
        (coordinator_has_specialist ?encounter_coordinator ?specialist_module)
        (not
          (specialist_available ?specialist_module)
        )
      )
  )
  (:action detach_specialist_from_coordinator
    :parameters (?encounter_coordinator - encounter_coordinator ?specialist_module - specialist_module)
    :precondition
      (and
        (coordinator_has_specialist ?encounter_coordinator ?specialist_module)
      )
    :effect
      (and
        (specialist_available ?specialist_module)
        (not
          (coordinator_has_specialist ?encounter_coordinator ?specialist_module)
        )
      )
  )
  (:action attach_boon_to_coordinator
    :parameters (?encounter_coordinator - encounter_coordinator ?boon_token - boon_token)
    :precondition
      (and
        (unit_ready ?encounter_coordinator)
        (boon_token_available ?boon_token)
      )
    :effect
      (and
        (coordinator_has_boon ?encounter_coordinator ?boon_token)
        (not
          (boon_token_available ?boon_token)
        )
      )
  )
  (:action detach_boon_from_coordinator
    :parameters (?encounter_coordinator - encounter_coordinator ?boon_token - boon_token)
    :precondition
      (and
        (coordinator_has_boon ?encounter_coordinator ?boon_token)
      )
    :effect
      (and
        (boon_token_available ?boon_token)
        (not
          (coordinator_has_boon ?encounter_coordinator ?boon_token)
        )
      )
  )
  (:action alpha_claim_position_marker
    :parameters (?subgroup_slot_alpha - subgroup_slot_alpha ?position_marker_a - position_marker_a ?ability_slot - ability_slot)
    :precondition
      (and
        (unit_ready ?subgroup_slot_alpha)
        (unit_ability_bound ?subgroup_slot_alpha ?ability_slot)
        (alpha_position_claimed ?subgroup_slot_alpha ?position_marker_a)
        (not
          (position_a_claimed ?position_marker_a)
        )
        (not
          (position_a_loaded ?position_marker_a)
        )
      )
    :effect (position_a_claimed ?position_marker_a)
  )
  (:action alpha_confirm_ready_with_support
    :parameters (?subgroup_slot_alpha - subgroup_slot_alpha ?position_marker_a - position_marker_a ?support_device - support_device)
    :precondition
      (and
        (unit_ready ?subgroup_slot_alpha)
        (unit_support_attached ?subgroup_slot_alpha ?support_device)
        (alpha_position_claimed ?subgroup_slot_alpha ?position_marker_a)
        (position_a_claimed ?position_marker_a)
        (not
          (alpha_slot_confirmed ?subgroup_slot_alpha)
        )
      )
    :effect
      (and
        (alpha_slot_confirmed ?subgroup_slot_alpha)
        (alpha_ready ?subgroup_slot_alpha)
      )
  )
  (:action alpha_load_consumable_payload
    :parameters (?subgroup_slot_alpha - subgroup_slot_alpha ?position_marker_a - position_marker_a ?consumable_payload - consumable_payload)
    :precondition
      (and
        (unit_ready ?subgroup_slot_alpha)
        (alpha_position_claimed ?subgroup_slot_alpha ?position_marker_a)
        (payload_available ?consumable_payload)
        (not
          (alpha_slot_confirmed ?subgroup_slot_alpha)
        )
      )
    :effect
      (and
        (position_a_loaded ?position_marker_a)
        (alpha_slot_confirmed ?subgroup_slot_alpha)
        (alpha_payload_attached ?subgroup_slot_alpha ?consumable_payload)
        (not
          (payload_available ?consumable_payload)
        )
      )
  )
  (:action alpha_finalize_payload_attachment
    :parameters (?subgroup_slot_alpha - subgroup_slot_alpha ?position_marker_a - position_marker_a ?ability_slot - ability_slot ?consumable_payload - consumable_payload)
    :precondition
      (and
        (unit_ready ?subgroup_slot_alpha)
        (unit_ability_bound ?subgroup_slot_alpha ?ability_slot)
        (alpha_position_claimed ?subgroup_slot_alpha ?position_marker_a)
        (position_a_loaded ?position_marker_a)
        (alpha_payload_attached ?subgroup_slot_alpha ?consumable_payload)
        (not
          (alpha_ready ?subgroup_slot_alpha)
        )
      )
    :effect
      (and
        (position_a_claimed ?position_marker_a)
        (alpha_ready ?subgroup_slot_alpha)
        (payload_available ?consumable_payload)
        (not
          (alpha_payload_attached ?subgroup_slot_alpha ?consumable_payload)
        )
      )
  )
  (:action beta_claim_position_marker
    :parameters (?subgroup_slot_beta - subgroup_slot_beta ?position_marker_b - position_marker_b ?ability_slot - ability_slot)
    :precondition
      (and
        (unit_ready ?subgroup_slot_beta)
        (unit_ability_bound ?subgroup_slot_beta ?ability_slot)
        (beta_position_claimed ?subgroup_slot_beta ?position_marker_b)
        (not
          (position_b_claimed ?position_marker_b)
        )
        (not
          (position_b_loaded ?position_marker_b)
        )
      )
    :effect (position_b_claimed ?position_marker_b)
  )
  (:action beta_confirm_ready_with_support
    :parameters (?subgroup_slot_beta - subgroup_slot_beta ?position_marker_b - position_marker_b ?support_device - support_device)
    :precondition
      (and
        (unit_ready ?subgroup_slot_beta)
        (unit_support_attached ?subgroup_slot_beta ?support_device)
        (beta_position_claimed ?subgroup_slot_beta ?position_marker_b)
        (position_b_claimed ?position_marker_b)
        (not
          (beta_slot_confirmed ?subgroup_slot_beta)
        )
      )
    :effect
      (and
        (beta_slot_confirmed ?subgroup_slot_beta)
        (beta_ready ?subgroup_slot_beta)
      )
  )
  (:action beta_load_consumable_payload
    :parameters (?subgroup_slot_beta - subgroup_slot_beta ?position_marker_b - position_marker_b ?consumable_payload - consumable_payload)
    :precondition
      (and
        (unit_ready ?subgroup_slot_beta)
        (beta_position_claimed ?subgroup_slot_beta ?position_marker_b)
        (payload_available ?consumable_payload)
        (not
          (beta_slot_confirmed ?subgroup_slot_beta)
        )
      )
    :effect
      (and
        (position_b_loaded ?position_marker_b)
        (beta_slot_confirmed ?subgroup_slot_beta)
        (beta_payload_attached ?subgroup_slot_beta ?consumable_payload)
        (not
          (payload_available ?consumable_payload)
        )
      )
  )
  (:action beta_finalize_payload_attachment
    :parameters (?subgroup_slot_beta - subgroup_slot_beta ?position_marker_b - position_marker_b ?ability_slot - ability_slot ?consumable_payload - consumable_payload)
    :precondition
      (and
        (unit_ready ?subgroup_slot_beta)
        (unit_ability_bound ?subgroup_slot_beta ?ability_slot)
        (beta_position_claimed ?subgroup_slot_beta ?position_marker_b)
        (position_b_loaded ?position_marker_b)
        (beta_payload_attached ?subgroup_slot_beta ?consumable_payload)
        (not
          (beta_ready ?subgroup_slot_beta)
        )
      )
    :effect
      (and
        (position_b_claimed ?position_marker_b)
        (beta_ready ?subgroup_slot_beta)
        (payload_available ?consumable_payload)
        (not
          (beta_payload_attached ?subgroup_slot_beta ?consumable_payload)
        )
      )
  )
  (:action assemble_execution_device_from_both_tracks
    :parameters (?subgroup_slot_alpha - subgroup_slot_alpha ?subgroup_slot_beta - subgroup_slot_beta ?position_marker_a - position_marker_a ?position_marker_b - position_marker_b ?execution_device - execution_device)
    :precondition
      (and
        (alpha_slot_confirmed ?subgroup_slot_alpha)
        (beta_slot_confirmed ?subgroup_slot_beta)
        (alpha_position_claimed ?subgroup_slot_alpha ?position_marker_a)
        (beta_position_claimed ?subgroup_slot_beta ?position_marker_b)
        (position_a_claimed ?position_marker_a)
        (position_b_claimed ?position_marker_b)
        (alpha_ready ?subgroup_slot_alpha)
        (beta_ready ?subgroup_slot_beta)
        (device_available ?execution_device)
      )
    :effect
      (and
        (device_prepared ?execution_device)
        (device_bound_to_position_a ?execution_device ?position_marker_a)
        (device_bound_to_position_b ?execution_device ?position_marker_b)
        (not
          (device_available ?execution_device)
        )
      )
  )
  (:action assemble_device_with_alpha_payload
    :parameters (?subgroup_slot_alpha - subgroup_slot_alpha ?subgroup_slot_beta - subgroup_slot_beta ?position_marker_a - position_marker_a ?position_marker_b - position_marker_b ?execution_device - execution_device)
    :precondition
      (and
        (alpha_slot_confirmed ?subgroup_slot_alpha)
        (beta_slot_confirmed ?subgroup_slot_beta)
        (alpha_position_claimed ?subgroup_slot_alpha ?position_marker_a)
        (beta_position_claimed ?subgroup_slot_beta ?position_marker_b)
        (position_a_loaded ?position_marker_a)
        (position_b_claimed ?position_marker_b)
        (not
          (alpha_ready ?subgroup_slot_alpha)
        )
        (beta_ready ?subgroup_slot_beta)
        (device_available ?execution_device)
      )
    :effect
      (and
        (device_prepared ?execution_device)
        (device_bound_to_position_a ?execution_device ?position_marker_a)
        (device_bound_to_position_b ?execution_device ?position_marker_b)
        (device_has_alpha_payload ?execution_device)
        (not
          (device_available ?execution_device)
        )
      )
  )
  (:action assemble_device_with_beta_payload
    :parameters (?subgroup_slot_alpha - subgroup_slot_alpha ?subgroup_slot_beta - subgroup_slot_beta ?position_marker_a - position_marker_a ?position_marker_b - position_marker_b ?execution_device - execution_device)
    :precondition
      (and
        (alpha_slot_confirmed ?subgroup_slot_alpha)
        (beta_slot_confirmed ?subgroup_slot_beta)
        (alpha_position_claimed ?subgroup_slot_alpha ?position_marker_a)
        (beta_position_claimed ?subgroup_slot_beta ?position_marker_b)
        (position_a_claimed ?position_marker_a)
        (position_b_loaded ?position_marker_b)
        (alpha_ready ?subgroup_slot_alpha)
        (not
          (beta_ready ?subgroup_slot_beta)
        )
        (device_available ?execution_device)
      )
    :effect
      (and
        (device_prepared ?execution_device)
        (device_bound_to_position_a ?execution_device ?position_marker_a)
        (device_bound_to_position_b ?execution_device ?position_marker_b)
        (device_has_beta_payload ?execution_device)
        (not
          (device_available ?execution_device)
        )
      )
  )
  (:action assemble_device_with_both_payloads
    :parameters (?subgroup_slot_alpha - subgroup_slot_alpha ?subgroup_slot_beta - subgroup_slot_beta ?position_marker_a - position_marker_a ?position_marker_b - position_marker_b ?execution_device - execution_device)
    :precondition
      (and
        (alpha_slot_confirmed ?subgroup_slot_alpha)
        (beta_slot_confirmed ?subgroup_slot_beta)
        (alpha_position_claimed ?subgroup_slot_alpha ?position_marker_a)
        (beta_position_claimed ?subgroup_slot_beta ?position_marker_b)
        (position_a_loaded ?position_marker_a)
        (position_b_loaded ?position_marker_b)
        (not
          (alpha_ready ?subgroup_slot_alpha)
        )
        (not
          (beta_ready ?subgroup_slot_beta)
        )
        (device_available ?execution_device)
      )
    :effect
      (and
        (device_prepared ?execution_device)
        (device_bound_to_position_a ?execution_device ?position_marker_a)
        (device_bound_to_position_b ?execution_device ?position_marker_b)
        (device_has_alpha_payload ?execution_device)
        (device_has_beta_payload ?execution_device)
        (not
          (device_available ?execution_device)
        )
      )
  )
  (:action arm_execution_device_for_targeting
    :parameters (?execution_device - execution_device ?subgroup_slot_alpha - subgroup_slot_alpha ?ability_slot - ability_slot)
    :precondition
      (and
        (device_prepared ?execution_device)
        (alpha_slot_confirmed ?subgroup_slot_alpha)
        (unit_ability_bound ?subgroup_slot_alpha ?ability_slot)
        (not
          (device_target_ready ?execution_device)
        )
      )
    :effect (device_target_ready ?execution_device)
  )
  (:action attach_target_marker_to_device
    :parameters (?encounter_coordinator - encounter_coordinator ?target_marker - target_marker ?execution_device - execution_device)
    :precondition
      (and
        (unit_ready ?encounter_coordinator)
        (coordinator_assigned_device ?encounter_coordinator ?execution_device)
        (coordinator_target_attached ?encounter_coordinator ?target_marker)
        (target_marker_available ?target_marker)
        (device_prepared ?execution_device)
        (device_target_ready ?execution_device)
        (not
          (target_marker_locked ?target_marker)
        )
      )
    :effect
      (and
        (target_marker_locked ?target_marker)
        (target_bound_to_device ?target_marker ?execution_device)
        (not
          (target_marker_available ?target_marker)
        )
      )
  )
  (:action stage_coordinator_payload
    :parameters (?encounter_coordinator - encounter_coordinator ?target_marker - target_marker ?execution_device - execution_device ?ability_slot - ability_slot)
    :precondition
      (and
        (unit_ready ?encounter_coordinator)
        (coordinator_target_attached ?encounter_coordinator ?target_marker)
        (target_marker_locked ?target_marker)
        (target_bound_to_device ?target_marker ?execution_device)
        (unit_ability_bound ?encounter_coordinator ?ability_slot)
        (not
          (device_has_alpha_payload ?execution_device)
        )
        (not
          (coordinator_payload_ready ?encounter_coordinator)
        )
      )
    :effect (coordinator_payload_ready ?encounter_coordinator)
  )
  (:action attach_attunement_to_coordinator
    :parameters (?encounter_coordinator - encounter_coordinator ?attunement_token - attunement_token)
    :precondition
      (and
        (unit_ready ?encounter_coordinator)
        (attunement_token_available ?attunement_token)
        (not
          (coordinator_attuned ?encounter_coordinator)
        )
      )
    :effect
      (and
        (coordinator_attuned ?encounter_coordinator)
        (coordinator_has_attunement ?encounter_coordinator ?attunement_token)
        (not
          (attunement_token_available ?attunement_token)
        )
      )
  )
  (:action stage_attunement_and_target_for_processing
    :parameters (?encounter_coordinator - encounter_coordinator ?target_marker - target_marker ?execution_device - execution_device ?ability_slot - ability_slot ?attunement_token - attunement_token)
    :precondition
      (and
        (unit_ready ?encounter_coordinator)
        (coordinator_target_attached ?encounter_coordinator ?target_marker)
        (target_marker_locked ?target_marker)
        (target_bound_to_device ?target_marker ?execution_device)
        (unit_ability_bound ?encounter_coordinator ?ability_slot)
        (device_has_alpha_payload ?execution_device)
        (coordinator_attuned ?encounter_coordinator)
        (coordinator_has_attunement ?encounter_coordinator ?attunement_token)
        (not
          (coordinator_payload_ready ?encounter_coordinator)
        )
      )
    :effect
      (and
        (coordinator_payload_ready ?encounter_coordinator)
        (coordinator_payload_staged ?encounter_coordinator)
      )
  )
  (:action integrate_payload_with_specialist_primary
    :parameters (?encounter_coordinator - encounter_coordinator ?specialist_module - specialist_module ?support_device - support_device ?target_marker - target_marker ?execution_device - execution_device)
    :precondition
      (and
        (coordinator_payload_ready ?encounter_coordinator)
        (coordinator_has_specialist ?encounter_coordinator ?specialist_module)
        (unit_support_attached ?encounter_coordinator ?support_device)
        (coordinator_target_attached ?encounter_coordinator ?target_marker)
        (target_bound_to_device ?target_marker ?execution_device)
        (not
          (device_has_beta_payload ?execution_device)
        )
        (not
          (coordinator_payload_integrated ?encounter_coordinator)
        )
      )
    :effect (coordinator_payload_integrated ?encounter_coordinator)
  )
  (:action integrate_payload_with_specialist_secondary
    :parameters (?encounter_coordinator - encounter_coordinator ?specialist_module - specialist_module ?support_device - support_device ?target_marker - target_marker ?execution_device - execution_device)
    :precondition
      (and
        (coordinator_payload_ready ?encounter_coordinator)
        (coordinator_has_specialist ?encounter_coordinator ?specialist_module)
        (unit_support_attached ?encounter_coordinator ?support_device)
        (coordinator_target_attached ?encounter_coordinator ?target_marker)
        (target_bound_to_device ?target_marker ?execution_device)
        (device_has_beta_payload ?execution_device)
        (not
          (coordinator_payload_integrated ?encounter_coordinator)
        )
      )
    :effect (coordinator_payload_integrated ?encounter_coordinator)
  )
  (:action mark_coordinator_final_ready
    :parameters (?encounter_coordinator - encounter_coordinator ?boon_token - boon_token ?target_marker - target_marker ?execution_device - execution_device)
    :precondition
      (and
        (coordinator_payload_integrated ?encounter_coordinator)
        (coordinator_has_boon ?encounter_coordinator ?boon_token)
        (coordinator_target_attached ?encounter_coordinator ?target_marker)
        (target_bound_to_device ?target_marker ?execution_device)
        (not
          (device_has_alpha_payload ?execution_device)
        )
        (not
          (device_has_beta_payload ?execution_device)
        )
        (not
          (coordinator_final_ready ?encounter_coordinator)
        )
      )
    :effect (coordinator_final_ready ?encounter_coordinator)
  )
  (:action verify_and_mark_coordinator_ready_alpha
    :parameters (?encounter_coordinator - encounter_coordinator ?boon_token - boon_token ?target_marker - target_marker ?execution_device - execution_device)
    :precondition
      (and
        (coordinator_payload_integrated ?encounter_coordinator)
        (coordinator_has_boon ?encounter_coordinator ?boon_token)
        (coordinator_target_attached ?encounter_coordinator ?target_marker)
        (target_bound_to_device ?target_marker ?execution_device)
        (device_has_alpha_payload ?execution_device)
        (not
          (device_has_beta_payload ?execution_device)
        )
        (not
          (coordinator_final_ready ?encounter_coordinator)
        )
      )
    :effect
      (and
        (coordinator_final_ready ?encounter_coordinator)
        (coordinator_payload_verified ?encounter_coordinator)
      )
  )
  (:action verify_and_mark_coordinator_ready_beta
    :parameters (?encounter_coordinator - encounter_coordinator ?boon_token - boon_token ?target_marker - target_marker ?execution_device - execution_device)
    :precondition
      (and
        (coordinator_payload_integrated ?encounter_coordinator)
        (coordinator_has_boon ?encounter_coordinator ?boon_token)
        (coordinator_target_attached ?encounter_coordinator ?target_marker)
        (target_bound_to_device ?target_marker ?execution_device)
        (not
          (device_has_alpha_payload ?execution_device)
        )
        (device_has_beta_payload ?execution_device)
        (not
          (coordinator_final_ready ?encounter_coordinator)
        )
      )
    :effect
      (and
        (coordinator_final_ready ?encounter_coordinator)
        (coordinator_payload_verified ?encounter_coordinator)
      )
  )
  (:action verify_and_mark_coordinator_ready_both
    :parameters (?encounter_coordinator - encounter_coordinator ?boon_token - boon_token ?target_marker - target_marker ?execution_device - execution_device)
    :precondition
      (and
        (coordinator_payload_integrated ?encounter_coordinator)
        (coordinator_has_boon ?encounter_coordinator ?boon_token)
        (coordinator_target_attached ?encounter_coordinator ?target_marker)
        (target_bound_to_device ?target_marker ?execution_device)
        (device_has_alpha_payload ?execution_device)
        (device_has_beta_payload ?execution_device)
        (not
          (coordinator_final_ready ?encounter_coordinator)
        )
      )
    :effect
      (and
        (coordinator_final_ready ?encounter_coordinator)
        (coordinator_payload_verified ?encounter_coordinator)
      )
  )
  (:action commit_coordinator_activation_immediate
    :parameters (?encounter_coordinator - encounter_coordinator)
    :precondition
      (and
        (coordinator_final_ready ?encounter_coordinator)
        (not
          (coordinator_payload_verified ?encounter_coordinator)
        )
        (not
          (coordinator_committed ?encounter_coordinator)
        )
      )
    :effect
      (and
        (coordinator_committed ?encounter_coordinator)
        (activation_ready ?encounter_coordinator)
      )
  )
  (:action attach_synergy_token_to_coordinator
    :parameters (?encounter_coordinator - encounter_coordinator ?synergy_token - synergy_token)
    :precondition
      (and
        (coordinator_final_ready ?encounter_coordinator)
        (coordinator_payload_verified ?encounter_coordinator)
        (synergy_token_available ?synergy_token)
      )
    :effect
      (and
        (coordinator_has_synergy_token ?encounter_coordinator ?synergy_token)
        (not
          (synergy_token_available ?synergy_token)
        )
      )
  )
  (:action stage_coordinator_for_execution
    :parameters (?encounter_coordinator - encounter_coordinator ?subgroup_slot_alpha - subgroup_slot_alpha ?subgroup_slot_beta - subgroup_slot_beta ?ability_slot - ability_slot ?synergy_token - synergy_token)
    :precondition
      (and
        (coordinator_final_ready ?encounter_coordinator)
        (coordinator_payload_verified ?encounter_coordinator)
        (coordinator_has_synergy_token ?encounter_coordinator ?synergy_token)
        (coordinator_has_alpha_slot ?encounter_coordinator ?subgroup_slot_alpha)
        (coordinator_has_beta_slot ?encounter_coordinator ?subgroup_slot_beta)
        (alpha_ready ?subgroup_slot_alpha)
        (beta_ready ?subgroup_slot_beta)
        (unit_ability_bound ?encounter_coordinator ?ability_slot)
        (not
          (coordinator_execution_staged ?encounter_coordinator)
        )
      )
    :effect (coordinator_execution_staged ?encounter_coordinator)
  )
  (:action commit_coordinator_activation_staged
    :parameters (?encounter_coordinator - encounter_coordinator)
    :precondition
      (and
        (coordinator_final_ready ?encounter_coordinator)
        (coordinator_execution_staged ?encounter_coordinator)
        (not
          (coordinator_committed ?encounter_coordinator)
        )
      )
    :effect
      (and
        (coordinator_committed ?encounter_coordinator)
        (activation_ready ?encounter_coordinator)
      )
  )
  (:action apply_order_token_to_coordinator
    :parameters (?encounter_coordinator - encounter_coordinator ?order_token - order_token ?ability_slot - ability_slot)
    :precondition
      (and
        (unit_ready ?encounter_coordinator)
        (unit_ability_bound ?encounter_coordinator ?ability_slot)
        (order_token_available ?order_token)
        (coordinator_has_order_token ?encounter_coordinator ?order_token)
        (not
          (coordinator_order_locked ?encounter_coordinator)
        )
      )
    :effect
      (and
        (coordinator_order_locked ?encounter_coordinator)
        (not
          (order_token_available ?order_token)
        )
      )
  )
  (:action start_coordinator_order_sequence
    :parameters (?encounter_coordinator - encounter_coordinator ?support_device - support_device)
    :precondition
      (and
        (coordinator_order_locked ?encounter_coordinator)
        (unit_support_attached ?encounter_coordinator ?support_device)
        (not
          (coordinator_order_step_started ?encounter_coordinator)
        )
      )
    :effect (coordinator_order_step_started ?encounter_coordinator)
  )
  (:action apply_coordinator_order_with_boon
    :parameters (?encounter_coordinator - encounter_coordinator ?boon_token - boon_token)
    :precondition
      (and
        (coordinator_order_step_started ?encounter_coordinator)
        (coordinator_has_boon ?encounter_coordinator ?boon_token)
        (not
          (coordinator_order_complete ?encounter_coordinator)
        )
      )
    :effect (coordinator_order_complete ?encounter_coordinator)
  )
  (:action commit_coordinator_order_sequence
    :parameters (?encounter_coordinator - encounter_coordinator)
    :precondition
      (and
        (coordinator_order_complete ?encounter_coordinator)
        (not
          (coordinator_committed ?encounter_coordinator)
        )
      )
    :effect
      (and
        (coordinator_committed ?encounter_coordinator)
        (activation_ready ?encounter_coordinator)
      )
  )
  (:action commit_alpha_subgroup_execution
    :parameters (?subgroup_slot_alpha - subgroup_slot_alpha ?execution_device - execution_device)
    :precondition
      (and
        (alpha_slot_confirmed ?subgroup_slot_alpha)
        (alpha_ready ?subgroup_slot_alpha)
        (device_prepared ?execution_device)
        (device_target_ready ?execution_device)
        (not
          (activation_ready ?subgroup_slot_alpha)
        )
      )
    :effect (activation_ready ?subgroup_slot_alpha)
  )
  (:action commit_beta_subgroup_execution
    :parameters (?subgroup_slot_beta - subgroup_slot_beta ?execution_device - execution_device)
    :precondition
      (and
        (beta_slot_confirmed ?subgroup_slot_beta)
        (beta_ready ?subgroup_slot_beta)
        (device_prepared ?execution_device)
        (device_target_ready ?execution_device)
        (not
          (activation_ready ?subgroup_slot_beta)
        )
      )
    :effect (activation_ready ?subgroup_slot_beta)
  )
  (:action attach_final_marker_to_unit
    :parameters (?party_unit - party_unit ?final_marker - final_marker ?ability_slot - ability_slot)
    :precondition
      (and
        (activation_ready ?party_unit)
        (unit_ability_bound ?party_unit ?ability_slot)
        (final_marker_available ?final_marker)
        (not
          (final_marker_attached ?party_unit)
        )
      )
    :effect
      (and
        (final_marker_attached ?party_unit)
        (unit_bound_to_final_marker ?party_unit ?final_marker)
        (not
          (final_marker_available ?final_marker)
        )
      )
  )
  (:action finalize_alpha_commitment
    :parameters (?subgroup_slot_alpha - subgroup_slot_alpha ?role_token - role_token ?final_marker - final_marker)
    :precondition
      (and
        (final_marker_attached ?subgroup_slot_alpha)
        (unit_role_bound ?subgroup_slot_alpha ?role_token)
        (unit_bound_to_final_marker ?subgroup_slot_alpha ?final_marker)
        (not
          (unit_committed ?subgroup_slot_alpha)
        )
      )
    :effect
      (and
        (unit_committed ?subgroup_slot_alpha)
        (role_token_available ?role_token)
        (final_marker_available ?final_marker)
      )
  )
  (:action finalize_beta_commitment
    :parameters (?subgroup_slot_beta - subgroup_slot_beta ?role_token - role_token ?final_marker - final_marker)
    :precondition
      (and
        (final_marker_attached ?subgroup_slot_beta)
        (unit_role_bound ?subgroup_slot_beta ?role_token)
        (unit_bound_to_final_marker ?subgroup_slot_beta ?final_marker)
        (not
          (unit_committed ?subgroup_slot_beta)
        )
      )
    :effect
      (and
        (unit_committed ?subgroup_slot_beta)
        (role_token_available ?role_token)
        (final_marker_available ?final_marker)
      )
  )
  (:action finalize_coordinator_commitment
    :parameters (?encounter_coordinator - encounter_coordinator ?role_token - role_token ?final_marker - final_marker)
    :precondition
      (and
        (final_marker_attached ?encounter_coordinator)
        (unit_role_bound ?encounter_coordinator ?role_token)
        (unit_bound_to_final_marker ?encounter_coordinator ?final_marker)
        (not
          (unit_committed ?encounter_coordinator)
        )
      )
    :effect
      (and
        (unit_committed ?encounter_coordinator)
        (role_token_available ?role_token)
        (final_marker_available ?final_marker)
      )
  )
)

(define (domain companion_unlock_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types root_object - object domain_entity - root_object entity_category_b - root_object entity_category_c - root_object unlock_root_category - root_object unlockable_entity_root - unlock_root_category unlock_token - domain_entity task_objective - domain_entity gating_npc_or_actor - domain_entity optional_modifier - domain_entity promotion_token - domain_entity companion_credential - domain_entity affinity_material - domain_entity unique_requirement_item - domain_entity consumable_asset - entity_category_b staged_asset - entity_category_b special_requirement - entity_category_b stage_flag - entity_category_c branch_variant - entity_category_c reward_bundle_entry - entity_category_c unlock_node_category - unlockable_entity_root unlock_node_variant - unlockable_entity_root primary_unlock_node - unlock_node_category secondary_unlock_node - unlock_node_category companion_profile - unlock_node_variant)

  (:predicates
    (unlockable_entity_registered ?unlockable_entity_root - unlockable_entity_root)
    (unlockable_entity_ready ?unlockable_entity_root - unlockable_entity_root)
    (unlockable_entity_intermediate_binding ?unlockable_entity_root - unlockable_entity_root)
    (unlockable_entity_completed ?unlockable_entity_root - unlockable_entity_root)
    (unlockable_entity_granted ?unlockable_entity_root - unlockable_entity_root)
    (unlockable_entity_credential_applied ?unlockable_entity_root - unlockable_entity_root)
    (unlock_token_available ?unlock_token - unlock_token)
    (unlockable_entity_has_unlock_token ?unlockable_entity_root - unlockable_entity_root ?unlock_token - unlock_token)
    (objective_available ?task_objective - task_objective)
    (unlockable_entity_has_objective ?unlockable_entity_root - unlockable_entity_root ?task_objective - task_objective)
    (gating_npc_available ?gating_npc_or_actor - gating_npc_or_actor)
    (unlockable_entity_has_gating_npc ?unlockable_entity_root - unlockable_entity_root ?gating_npc_or_actor - gating_npc_or_actor)
    (consumable_available ?consumable_asset - consumable_asset)
    (primary_node_consumable_attached ?primary_unlock_node - primary_unlock_node ?consumable_asset - consumable_asset)
    (secondary_node_consumable_attached ?secondary_unlock_node - secondary_unlock_node ?consumable_asset - consumable_asset)
    (primary_node_stage_slot_link ?primary_unlock_node - primary_unlock_node ?stage_flag - stage_flag)
    (stage_flag_active ?stage_flag - stage_flag)
    (stage_flag_committed ?stage_flag - stage_flag)
    (primary_node_stage_completed ?primary_unlock_node - primary_unlock_node)
    (secondary_node_variant_link ?secondary_unlock_node - secondary_unlock_node ?branch_variant - branch_variant)
    (branch_variant_stage_a_set ?branch_variant - branch_variant)
    (branch_variant_stage_b_set ?branch_variant - branch_variant)
    (secondary_node_stage_completed ?secondary_unlock_node - secondary_unlock_node)
    (reward_bundle_seeded ?reward_bundle_entry - reward_bundle_entry)
    (reward_bundle_ready ?reward_bundle_entry - reward_bundle_entry)
    (bundle_stage_flag_link ?reward_bundle_entry - reward_bundle_entry ?stage_flag - stage_flag)
    (bundle_variant_link ?reward_bundle_entry - reward_bundle_entry ?branch_variant - branch_variant)
    (reward_bundle_phase_a_ready ?reward_bundle_entry - reward_bundle_entry)
    (reward_bundle_phase_b_ready ?reward_bundle_entry - reward_bundle_entry)
    (reward_bundle_asset_commit_ready ?reward_bundle_entry - reward_bundle_entry)
    (profile_link_primary_node ?companion_profile - companion_profile ?primary_unlock_node - primary_unlock_node)
    (profile_link_secondary_node ?companion_profile - companion_profile ?secondary_unlock_node - secondary_unlock_node)
    (profile_link_bundle_entry ?companion_profile - companion_profile ?reward_bundle_entry - reward_bundle_entry)
    (staged_asset_available ?staged_asset - staged_asset)
    (profile_staged_asset_link ?companion_profile - companion_profile ?staged_asset - staged_asset)
    (staged_asset_committed ?staged_asset - staged_asset)
    (staged_asset_bundle_link ?staged_asset - staged_asset ?reward_bundle_entry - reward_bundle_entry)
    (profile_materials_attached ?companion_profile - companion_profile)
    (profile_stage_one_complete ?companion_profile - companion_profile)
    (profile_pre_finalization_marker ?companion_profile - companion_profile)
    (profile_modifier_applied ?companion_profile - companion_profile)
    (profile_modifier_committed ?companion_profile - companion_profile)
    (profile_finalization_stage_b ?companion_profile - companion_profile)
    (profile_packaging_confirmed ?companion_profile - companion_profile)
    (special_requirement_available ?special_requirement - special_requirement)
    (profile_has_special_requirement ?companion_profile - companion_profile ?special_requirement - special_requirement)
    (profile_special_unlocked ?companion_profile - companion_profile)
    (profile_special_prep_done ?companion_profile - companion_profile)
    (profile_special_ready_for_finalize ?companion_profile - companion_profile)
    (optional_modifier_available ?optional_modifier - optional_modifier)
    (profile_optional_modifier_link ?companion_profile - companion_profile ?optional_modifier - optional_modifier)
    (promotion_token_available ?promotion_token - promotion_token)
    (profile_promotion_attached ?companion_profile - companion_profile ?promotion_token - promotion_token)
    (affinity_material_available ?affinity_material - affinity_material)
    (profile_affinity_attached ?companion_profile - companion_profile ?affinity_material - affinity_material)
    (unique_requirement_item_available ?unique_requirement_item - unique_requirement_item)
    (profile_unique_requirement_attached ?companion_profile - companion_profile ?unique_requirement_item - unique_requirement_item)
    (companion_credential_available ?companion_credential - companion_credential)
    (unlockable_entity_credential_bound ?unlockable_entity_root - unlockable_entity_root ?companion_credential - companion_credential)
    (primary_node_marked ?primary_unlock_node - primary_unlock_node)
    (secondary_node_marked ?secondary_unlock_node - secondary_unlock_node)
    (profile_finalization_committed ?companion_profile - companion_profile)
  )
  (:action activate_unlockable_entity
    :parameters (?unlockable_entity_root - unlockable_entity_root)
    :precondition
      (and
        (not
          (unlockable_entity_registered ?unlockable_entity_root)
        )
        (not
          (unlockable_entity_completed ?unlockable_entity_root)
        )
      )
    :effect (unlockable_entity_registered ?unlockable_entity_root)
  )
  (:action assign_unlock_token
    :parameters (?unlockable_entity_root - unlockable_entity_root ?unlock_token - unlock_token)
    :precondition
      (and
        (unlockable_entity_registered ?unlockable_entity_root)
        (not
          (unlockable_entity_intermediate_binding ?unlockable_entity_root)
        )
        (unlock_token_available ?unlock_token)
      )
    :effect
      (and
        (unlockable_entity_intermediate_binding ?unlockable_entity_root)
        (unlockable_entity_has_unlock_token ?unlockable_entity_root ?unlock_token)
        (not
          (unlock_token_available ?unlock_token)
        )
      )
  )
  (:action assign_objective_to_unlockable_entity
    :parameters (?unlockable_entity_root - unlockable_entity_root ?task_objective - task_objective)
    :precondition
      (and
        (unlockable_entity_registered ?unlockable_entity_root)
        (unlockable_entity_intermediate_binding ?unlockable_entity_root)
        (objective_available ?task_objective)
      )
    :effect
      (and
        (unlockable_entity_has_objective ?unlockable_entity_root ?task_objective)
        (not
          (objective_available ?task_objective)
        )
      )
  )
  (:action set_unlockable_entity_readiness_checkpoint
    :parameters (?unlockable_entity_root - unlockable_entity_root ?task_objective - task_objective)
    :precondition
      (and
        (unlockable_entity_registered ?unlockable_entity_root)
        (unlockable_entity_intermediate_binding ?unlockable_entity_root)
        (unlockable_entity_has_objective ?unlockable_entity_root ?task_objective)
        (not
          (unlockable_entity_ready ?unlockable_entity_root)
        )
      )
    :effect (unlockable_entity_ready ?unlockable_entity_root)
  )
  (:action unassign_objective_from_unlockable_entity
    :parameters (?unlockable_entity_root - unlockable_entity_root ?task_objective - task_objective)
    :precondition
      (and
        (unlockable_entity_has_objective ?unlockable_entity_root ?task_objective)
      )
    :effect
      (and
        (objective_available ?task_objective)
        (not
          (unlockable_entity_has_objective ?unlockable_entity_root ?task_objective)
        )
      )
  )
  (:action assign_gating_npc_to_unlockable_entity
    :parameters (?unlockable_entity_root - unlockable_entity_root ?gating_npc_or_actor - gating_npc_or_actor)
    :precondition
      (and
        (unlockable_entity_ready ?unlockable_entity_root)
        (gating_npc_available ?gating_npc_or_actor)
      )
    :effect
      (and
        (unlockable_entity_has_gating_npc ?unlockable_entity_root ?gating_npc_or_actor)
        (not
          (gating_npc_available ?gating_npc_or_actor)
        )
      )
  )
  (:action unassign_gating_npc_from_unlockable_entity
    :parameters (?unlockable_entity_root - unlockable_entity_root ?gating_npc_or_actor - gating_npc_or_actor)
    :precondition
      (and
        (unlockable_entity_has_gating_npc ?unlockable_entity_root ?gating_npc_or_actor)
      )
    :effect
      (and
        (gating_npc_available ?gating_npc_or_actor)
        (not
          (unlockable_entity_has_gating_npc ?unlockable_entity_root ?gating_npc_or_actor)
        )
      )
  )
  (:action attach_affinity_material_to_profile
    :parameters (?companion_profile - companion_profile ?affinity_material - affinity_material)
    :precondition
      (and
        (unlockable_entity_ready ?companion_profile)
        (affinity_material_available ?affinity_material)
      )
    :effect
      (and
        (profile_affinity_attached ?companion_profile ?affinity_material)
        (not
          (affinity_material_available ?affinity_material)
        )
      )
  )
  (:action detach_affinity_material_from_profile
    :parameters (?companion_profile - companion_profile ?affinity_material - affinity_material)
    :precondition
      (and
        (profile_affinity_attached ?companion_profile ?affinity_material)
      )
    :effect
      (and
        (affinity_material_available ?affinity_material)
        (not
          (profile_affinity_attached ?companion_profile ?affinity_material)
        )
      )
  )
  (:action attach_unique_requirement_to_profile
    :parameters (?companion_profile - companion_profile ?unique_requirement_item - unique_requirement_item)
    :precondition
      (and
        (unlockable_entity_ready ?companion_profile)
        (unique_requirement_item_available ?unique_requirement_item)
      )
    :effect
      (and
        (profile_unique_requirement_attached ?companion_profile ?unique_requirement_item)
        (not
          (unique_requirement_item_available ?unique_requirement_item)
        )
      )
  )
  (:action detach_unique_requirement_from_profile
    :parameters (?companion_profile - companion_profile ?unique_requirement_item - unique_requirement_item)
    :precondition
      (and
        (profile_unique_requirement_attached ?companion_profile ?unique_requirement_item)
      )
    :effect
      (and
        (unique_requirement_item_available ?unique_requirement_item)
        (not
          (profile_unique_requirement_attached ?companion_profile ?unique_requirement_item)
        )
      )
  )
  (:action activate_stage_flag
    :parameters (?primary_unlock_node - primary_unlock_node ?stage_flag - stage_flag ?task_objective - task_objective)
    :precondition
      (and
        (unlockable_entity_ready ?primary_unlock_node)
        (unlockable_entity_has_objective ?primary_unlock_node ?task_objective)
        (primary_node_stage_slot_link ?primary_unlock_node ?stage_flag)
        (not
          (stage_flag_active ?stage_flag)
        )
        (not
          (stage_flag_committed ?stage_flag)
        )
      )
    :effect (stage_flag_active ?stage_flag)
  )
  (:action apply_npc_to_primary_stage
    :parameters (?primary_unlock_node - primary_unlock_node ?stage_flag - stage_flag ?gating_npc_or_actor - gating_npc_or_actor)
    :precondition
      (and
        (unlockable_entity_ready ?primary_unlock_node)
        (unlockable_entity_has_gating_npc ?primary_unlock_node ?gating_npc_or_actor)
        (primary_node_stage_slot_link ?primary_unlock_node ?stage_flag)
        (stage_flag_active ?stage_flag)
        (not
          (primary_node_marked ?primary_unlock_node)
        )
      )
    :effect
      (and
        (primary_node_marked ?primary_unlock_node)
        (primary_node_stage_completed ?primary_unlock_node)
      )
  )
  (:action attach_consumable_to_primary_stage
    :parameters (?primary_unlock_node - primary_unlock_node ?stage_flag - stage_flag ?consumable_asset - consumable_asset)
    :precondition
      (and
        (unlockable_entity_ready ?primary_unlock_node)
        (primary_node_stage_slot_link ?primary_unlock_node ?stage_flag)
        (consumable_available ?consumable_asset)
        (not
          (primary_node_marked ?primary_unlock_node)
        )
      )
    :effect
      (and
        (stage_flag_committed ?stage_flag)
        (primary_node_marked ?primary_unlock_node)
        (primary_node_consumable_attached ?primary_unlock_node ?consumable_asset)
        (not
          (consumable_available ?consumable_asset)
        )
      )
  )
  (:action resolve_primary_stage_with_objective_and_asset
    :parameters (?primary_unlock_node - primary_unlock_node ?stage_flag - stage_flag ?task_objective - task_objective ?consumable_asset - consumable_asset)
    :precondition
      (and
        (unlockable_entity_ready ?primary_unlock_node)
        (unlockable_entity_has_objective ?primary_unlock_node ?task_objective)
        (primary_node_stage_slot_link ?primary_unlock_node ?stage_flag)
        (stage_flag_committed ?stage_flag)
        (primary_node_consumable_attached ?primary_unlock_node ?consumable_asset)
        (not
          (primary_node_stage_completed ?primary_unlock_node)
        )
      )
    :effect
      (and
        (stage_flag_active ?stage_flag)
        (primary_node_stage_completed ?primary_unlock_node)
        (consumable_available ?consumable_asset)
        (not
          (primary_node_consumable_attached ?primary_unlock_node ?consumable_asset)
        )
      )
  )
  (:action activate_variant_stage_flag
    :parameters (?secondary_unlock_node - secondary_unlock_node ?branch_variant - branch_variant ?task_objective - task_objective)
    :precondition
      (and
        (unlockable_entity_ready ?secondary_unlock_node)
        (unlockable_entity_has_objective ?secondary_unlock_node ?task_objective)
        (secondary_node_variant_link ?secondary_unlock_node ?branch_variant)
        (not
          (branch_variant_stage_a_set ?branch_variant)
        )
        (not
          (branch_variant_stage_b_set ?branch_variant)
        )
      )
    :effect (branch_variant_stage_a_set ?branch_variant)
  )
  (:action apply_npc_to_variant_stage
    :parameters (?secondary_unlock_node - secondary_unlock_node ?branch_variant - branch_variant ?gating_npc_or_actor - gating_npc_or_actor)
    :precondition
      (and
        (unlockable_entity_ready ?secondary_unlock_node)
        (unlockable_entity_has_gating_npc ?secondary_unlock_node ?gating_npc_or_actor)
        (secondary_node_variant_link ?secondary_unlock_node ?branch_variant)
        (branch_variant_stage_a_set ?branch_variant)
        (not
          (secondary_node_marked ?secondary_unlock_node)
        )
      )
    :effect
      (and
        (secondary_node_marked ?secondary_unlock_node)
        (secondary_node_stage_completed ?secondary_unlock_node)
      )
  )
  (:action attach_consumable_to_variant_stage
    :parameters (?secondary_unlock_node - secondary_unlock_node ?branch_variant - branch_variant ?consumable_asset - consumable_asset)
    :precondition
      (and
        (unlockable_entity_ready ?secondary_unlock_node)
        (secondary_node_variant_link ?secondary_unlock_node ?branch_variant)
        (consumable_available ?consumable_asset)
        (not
          (secondary_node_marked ?secondary_unlock_node)
        )
      )
    :effect
      (and
        (branch_variant_stage_b_set ?branch_variant)
        (secondary_node_marked ?secondary_unlock_node)
        (secondary_node_consumable_attached ?secondary_unlock_node ?consumable_asset)
        (not
          (consumable_available ?consumable_asset)
        )
      )
  )
  (:action resolve_variant_stage_with_objective_and_asset
    :parameters (?secondary_unlock_node - secondary_unlock_node ?branch_variant - branch_variant ?task_objective - task_objective ?consumable_asset - consumable_asset)
    :precondition
      (and
        (unlockable_entity_ready ?secondary_unlock_node)
        (unlockable_entity_has_objective ?secondary_unlock_node ?task_objective)
        (secondary_node_variant_link ?secondary_unlock_node ?branch_variant)
        (branch_variant_stage_b_set ?branch_variant)
        (secondary_node_consumable_attached ?secondary_unlock_node ?consumable_asset)
        (not
          (secondary_node_stage_completed ?secondary_unlock_node)
        )
      )
    :effect
      (and
        (branch_variant_stage_a_set ?branch_variant)
        (secondary_node_stage_completed ?secondary_unlock_node)
        (consumable_available ?consumable_asset)
        (not
          (secondary_node_consumable_attached ?secondary_unlock_node ?consumable_asset)
        )
      )
  )
  (:action assemble_reward_bundle_entry
    :parameters (?primary_unlock_node - primary_unlock_node ?secondary_unlock_node - secondary_unlock_node ?stage_flag - stage_flag ?branch_variant - branch_variant ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (primary_node_marked ?primary_unlock_node)
        (secondary_node_marked ?secondary_unlock_node)
        (primary_node_stage_slot_link ?primary_unlock_node ?stage_flag)
        (secondary_node_variant_link ?secondary_unlock_node ?branch_variant)
        (stage_flag_active ?stage_flag)
        (branch_variant_stage_a_set ?branch_variant)
        (primary_node_stage_completed ?primary_unlock_node)
        (secondary_node_stage_completed ?secondary_unlock_node)
        (reward_bundle_seeded ?reward_bundle_entry)
      )
    :effect
      (and
        (reward_bundle_ready ?reward_bundle_entry)
        (bundle_stage_flag_link ?reward_bundle_entry ?stage_flag)
        (bundle_variant_link ?reward_bundle_entry ?branch_variant)
        (not
          (reward_bundle_seeded ?reward_bundle_entry)
        )
      )
  )
  (:action assemble_reward_bundle_phase_a_ready
    :parameters (?primary_unlock_node - primary_unlock_node ?secondary_unlock_node - secondary_unlock_node ?stage_flag - stage_flag ?branch_variant - branch_variant ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (primary_node_marked ?primary_unlock_node)
        (secondary_node_marked ?secondary_unlock_node)
        (primary_node_stage_slot_link ?primary_unlock_node ?stage_flag)
        (secondary_node_variant_link ?secondary_unlock_node ?branch_variant)
        (stage_flag_committed ?stage_flag)
        (branch_variant_stage_a_set ?branch_variant)
        (not
          (primary_node_stage_completed ?primary_unlock_node)
        )
        (secondary_node_stage_completed ?secondary_unlock_node)
        (reward_bundle_seeded ?reward_bundle_entry)
      )
    :effect
      (and
        (reward_bundle_ready ?reward_bundle_entry)
        (bundle_stage_flag_link ?reward_bundle_entry ?stage_flag)
        (bundle_variant_link ?reward_bundle_entry ?branch_variant)
        (reward_bundle_phase_a_ready ?reward_bundle_entry)
        (not
          (reward_bundle_seeded ?reward_bundle_entry)
        )
      )
  )
  (:action assemble_reward_bundle_phase_b_ready
    :parameters (?primary_unlock_node - primary_unlock_node ?secondary_unlock_node - secondary_unlock_node ?stage_flag - stage_flag ?branch_variant - branch_variant ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (primary_node_marked ?primary_unlock_node)
        (secondary_node_marked ?secondary_unlock_node)
        (primary_node_stage_slot_link ?primary_unlock_node ?stage_flag)
        (secondary_node_variant_link ?secondary_unlock_node ?branch_variant)
        (stage_flag_active ?stage_flag)
        (branch_variant_stage_b_set ?branch_variant)
        (primary_node_stage_completed ?primary_unlock_node)
        (not
          (secondary_node_stage_completed ?secondary_unlock_node)
        )
        (reward_bundle_seeded ?reward_bundle_entry)
      )
    :effect
      (and
        (reward_bundle_ready ?reward_bundle_entry)
        (bundle_stage_flag_link ?reward_bundle_entry ?stage_flag)
        (bundle_variant_link ?reward_bundle_entry ?branch_variant)
        (reward_bundle_phase_b_ready ?reward_bundle_entry)
        (not
          (reward_bundle_seeded ?reward_bundle_entry)
        )
      )
  )
  (:action assemble_reward_bundle_phase_ab_ready
    :parameters (?primary_unlock_node - primary_unlock_node ?secondary_unlock_node - secondary_unlock_node ?stage_flag - stage_flag ?branch_variant - branch_variant ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (primary_node_marked ?primary_unlock_node)
        (secondary_node_marked ?secondary_unlock_node)
        (primary_node_stage_slot_link ?primary_unlock_node ?stage_flag)
        (secondary_node_variant_link ?secondary_unlock_node ?branch_variant)
        (stage_flag_committed ?stage_flag)
        (branch_variant_stage_b_set ?branch_variant)
        (not
          (primary_node_stage_completed ?primary_unlock_node)
        )
        (not
          (secondary_node_stage_completed ?secondary_unlock_node)
        )
        (reward_bundle_seeded ?reward_bundle_entry)
      )
    :effect
      (and
        (reward_bundle_ready ?reward_bundle_entry)
        (bundle_stage_flag_link ?reward_bundle_entry ?stage_flag)
        (bundle_variant_link ?reward_bundle_entry ?branch_variant)
        (reward_bundle_phase_a_ready ?reward_bundle_entry)
        (reward_bundle_phase_b_ready ?reward_bundle_entry)
        (not
          (reward_bundle_seeded ?reward_bundle_entry)
        )
      )
  )
  (:action confirm_bundle_asset_commit
    :parameters (?reward_bundle_entry - reward_bundle_entry ?primary_unlock_node - primary_unlock_node ?task_objective - task_objective)
    :precondition
      (and
        (reward_bundle_ready ?reward_bundle_entry)
        (primary_node_marked ?primary_unlock_node)
        (unlockable_entity_has_objective ?primary_unlock_node ?task_objective)
        (not
          (reward_bundle_asset_commit_ready ?reward_bundle_entry)
        )
      )
    :effect (reward_bundle_asset_commit_ready ?reward_bundle_entry)
  )
  (:action commit_staged_asset_to_bundle
    :parameters (?companion_profile - companion_profile ?staged_asset - staged_asset ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (unlockable_entity_ready ?companion_profile)
        (profile_link_bundle_entry ?companion_profile ?reward_bundle_entry)
        (profile_staged_asset_link ?companion_profile ?staged_asset)
        (staged_asset_available ?staged_asset)
        (reward_bundle_ready ?reward_bundle_entry)
        (reward_bundle_asset_commit_ready ?reward_bundle_entry)
        (not
          (staged_asset_committed ?staged_asset)
        )
      )
    :effect
      (and
        (staged_asset_committed ?staged_asset)
        (staged_asset_bundle_link ?staged_asset ?reward_bundle_entry)
        (not
          (staged_asset_available ?staged_asset)
        )
      )
  )
  (:action verify_profile_materials_for_bundle
    :parameters (?companion_profile - companion_profile ?staged_asset - staged_asset ?reward_bundle_entry - reward_bundle_entry ?task_objective - task_objective)
    :precondition
      (and
        (unlockable_entity_ready ?companion_profile)
        (profile_staged_asset_link ?companion_profile ?staged_asset)
        (staged_asset_committed ?staged_asset)
        (staged_asset_bundle_link ?staged_asset ?reward_bundle_entry)
        (unlockable_entity_has_objective ?companion_profile ?task_objective)
        (not
          (reward_bundle_phase_a_ready ?reward_bundle_entry)
        )
        (not
          (profile_materials_attached ?companion_profile)
        )
      )
    :effect (profile_materials_attached ?companion_profile)
  )
  (:action attach_optional_modifier_to_profile
    :parameters (?companion_profile - companion_profile ?optional_modifier - optional_modifier)
    :precondition
      (and
        (unlockable_entity_ready ?companion_profile)
        (optional_modifier_available ?optional_modifier)
        (not
          (profile_modifier_applied ?companion_profile)
        )
      )
    :effect
      (and
        (profile_modifier_applied ?companion_profile)
        (profile_optional_modifier_link ?companion_profile ?optional_modifier)
        (not
          (optional_modifier_available ?optional_modifier)
        )
      )
  )
  (:action link_profile_asset_and_modifier_to_bundle
    :parameters (?companion_profile - companion_profile ?staged_asset - staged_asset ?reward_bundle_entry - reward_bundle_entry ?task_objective - task_objective ?optional_modifier - optional_modifier)
    :precondition
      (and
        (unlockable_entity_ready ?companion_profile)
        (profile_staged_asset_link ?companion_profile ?staged_asset)
        (staged_asset_committed ?staged_asset)
        (staged_asset_bundle_link ?staged_asset ?reward_bundle_entry)
        (unlockable_entity_has_objective ?companion_profile ?task_objective)
        (reward_bundle_phase_a_ready ?reward_bundle_entry)
        (profile_modifier_applied ?companion_profile)
        (profile_optional_modifier_link ?companion_profile ?optional_modifier)
        (not
          (profile_materials_attached ?companion_profile)
        )
      )
    :effect
      (and
        (profile_materials_attached ?companion_profile)
        (profile_modifier_committed ?companion_profile)
      )
  )
  (:action apply_affinity_and_mark_profile_stage
    :parameters (?companion_profile - companion_profile ?affinity_material - affinity_material ?gating_npc_or_actor - gating_npc_or_actor ?staged_asset - staged_asset ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (profile_materials_attached ?companion_profile)
        (profile_affinity_attached ?companion_profile ?affinity_material)
        (unlockable_entity_has_gating_npc ?companion_profile ?gating_npc_or_actor)
        (profile_staged_asset_link ?companion_profile ?staged_asset)
        (staged_asset_bundle_link ?staged_asset ?reward_bundle_entry)
        (not
          (reward_bundle_phase_b_ready ?reward_bundle_entry)
        )
        (not
          (profile_stage_one_complete ?companion_profile)
        )
      )
    :effect (profile_stage_one_complete ?companion_profile)
  )
  (:action apply_affinity_and_mark_profile_stage_alt
    :parameters (?companion_profile - companion_profile ?affinity_material - affinity_material ?gating_npc_or_actor - gating_npc_or_actor ?staged_asset - staged_asset ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (profile_materials_attached ?companion_profile)
        (profile_affinity_attached ?companion_profile ?affinity_material)
        (unlockable_entity_has_gating_npc ?companion_profile ?gating_npc_or_actor)
        (profile_staged_asset_link ?companion_profile ?staged_asset)
        (staged_asset_bundle_link ?staged_asset ?reward_bundle_entry)
        (reward_bundle_phase_b_ready ?reward_bundle_entry)
        (not
          (profile_stage_one_complete ?companion_profile)
        )
      )
    :effect (profile_stage_one_complete ?companion_profile)
  )
  (:action apply_unique_requirement_and_mark_prefinal
    :parameters (?companion_profile - companion_profile ?unique_requirement_item - unique_requirement_item ?staged_asset - staged_asset ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (profile_stage_one_complete ?companion_profile)
        (profile_unique_requirement_attached ?companion_profile ?unique_requirement_item)
        (profile_staged_asset_link ?companion_profile ?staged_asset)
        (staged_asset_bundle_link ?staged_asset ?reward_bundle_entry)
        (not
          (reward_bundle_phase_a_ready ?reward_bundle_entry)
        )
        (not
          (reward_bundle_phase_b_ready ?reward_bundle_entry)
        )
        (not
          (profile_pre_finalization_marker ?companion_profile)
        )
      )
    :effect (profile_pre_finalization_marker ?companion_profile)
  )
  (:action apply_unique_and_stage_profile
    :parameters (?companion_profile - companion_profile ?unique_requirement_item - unique_requirement_item ?staged_asset - staged_asset ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (profile_stage_one_complete ?companion_profile)
        (profile_unique_requirement_attached ?companion_profile ?unique_requirement_item)
        (profile_staged_asset_link ?companion_profile ?staged_asset)
        (staged_asset_bundle_link ?staged_asset ?reward_bundle_entry)
        (reward_bundle_phase_a_ready ?reward_bundle_entry)
        (not
          (reward_bundle_phase_b_ready ?reward_bundle_entry)
        )
        (not
          (profile_pre_finalization_marker ?companion_profile)
        )
      )
    :effect
      (and
        (profile_pre_finalization_marker ?companion_profile)
        (profile_finalization_stage_b ?companion_profile)
      )
  )
  (:action apply_unique_and_mark_profile_variant
    :parameters (?companion_profile - companion_profile ?unique_requirement_item - unique_requirement_item ?staged_asset - staged_asset ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (profile_stage_one_complete ?companion_profile)
        (profile_unique_requirement_attached ?companion_profile ?unique_requirement_item)
        (profile_staged_asset_link ?companion_profile ?staged_asset)
        (staged_asset_bundle_link ?staged_asset ?reward_bundle_entry)
        (not
          (reward_bundle_phase_a_ready ?reward_bundle_entry)
        )
        (reward_bundle_phase_b_ready ?reward_bundle_entry)
        (not
          (profile_pre_finalization_marker ?companion_profile)
        )
      )
    :effect
      (and
        (profile_pre_finalization_marker ?companion_profile)
        (profile_finalization_stage_b ?companion_profile)
      )
  )
  (:action apply_unique_and_finalize_profile_variant
    :parameters (?companion_profile - companion_profile ?unique_requirement_item - unique_requirement_item ?staged_asset - staged_asset ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (profile_stage_one_complete ?companion_profile)
        (profile_unique_requirement_attached ?companion_profile ?unique_requirement_item)
        (profile_staged_asset_link ?companion_profile ?staged_asset)
        (staged_asset_bundle_link ?staged_asset ?reward_bundle_entry)
        (reward_bundle_phase_a_ready ?reward_bundle_entry)
        (reward_bundle_phase_b_ready ?reward_bundle_entry)
        (not
          (profile_pre_finalization_marker ?companion_profile)
        )
      )
    :effect
      (and
        (profile_pre_finalization_marker ?companion_profile)
        (profile_finalization_stage_b ?companion_profile)
      )
  )
  (:action finalize_profile_simple_unlock
    :parameters (?companion_profile - companion_profile)
    :precondition
      (and
        (profile_pre_finalization_marker ?companion_profile)
        (not
          (profile_finalization_stage_b ?companion_profile)
        )
        (not
          (profile_finalization_committed ?companion_profile)
        )
      )
    :effect
      (and
        (profile_finalization_committed ?companion_profile)
        (unlockable_entity_granted ?companion_profile)
      )
  )
  (:action attach_promotion_to_profile
    :parameters (?companion_profile - companion_profile ?promotion_token - promotion_token)
    :precondition
      (and
        (profile_pre_finalization_marker ?companion_profile)
        (profile_finalization_stage_b ?companion_profile)
        (promotion_token_available ?promotion_token)
      )
    :effect
      (and
        (profile_promotion_attached ?companion_profile ?promotion_token)
        (not
          (promotion_token_available ?promotion_token)
        )
      )
  )
  (:action complete_profile_packaging
    :parameters (?companion_profile - companion_profile ?primary_unlock_node - primary_unlock_node ?secondary_unlock_node - secondary_unlock_node ?task_objective - task_objective ?promotion_token - promotion_token)
    :precondition
      (and
        (profile_pre_finalization_marker ?companion_profile)
        (profile_finalization_stage_b ?companion_profile)
        (profile_promotion_attached ?companion_profile ?promotion_token)
        (profile_link_primary_node ?companion_profile ?primary_unlock_node)
        (profile_link_secondary_node ?companion_profile ?secondary_unlock_node)
        (primary_node_stage_completed ?primary_unlock_node)
        (secondary_node_stage_completed ?secondary_unlock_node)
        (unlockable_entity_has_objective ?companion_profile ?task_objective)
        (not
          (profile_packaging_confirmed ?companion_profile)
        )
      )
    :effect (profile_packaging_confirmed ?companion_profile)
  )
  (:action finalize_profile_unlock_with_packaging
    :parameters (?companion_profile - companion_profile)
    :precondition
      (and
        (profile_pre_finalization_marker ?companion_profile)
        (profile_packaging_confirmed ?companion_profile)
        (not
          (profile_finalization_committed ?companion_profile)
        )
      )
    :effect
      (and
        (profile_finalization_committed ?companion_profile)
        (unlockable_entity_granted ?companion_profile)
      )
  )
  (:action activate_special_requirement_flow
    :parameters (?companion_profile - companion_profile ?special_requirement - special_requirement ?task_objective - task_objective)
    :precondition
      (and
        (unlockable_entity_ready ?companion_profile)
        (unlockable_entity_has_objective ?companion_profile ?task_objective)
        (special_requirement_available ?special_requirement)
        (profile_has_special_requirement ?companion_profile ?special_requirement)
        (not
          (profile_special_unlocked ?companion_profile)
        )
      )
    :effect
      (and
        (profile_special_unlocked ?companion_profile)
        (not
          (special_requirement_available ?special_requirement)
        )
      )
  )
  (:action prepare_profile_for_special_requirement
    :parameters (?companion_profile - companion_profile ?gating_npc_or_actor - gating_npc_or_actor)
    :precondition
      (and
        (profile_special_unlocked ?companion_profile)
        (unlockable_entity_has_gating_npc ?companion_profile ?gating_npc_or_actor)
        (not
          (profile_special_prep_done ?companion_profile)
        )
      )
    :effect (profile_special_prep_done ?companion_profile)
  )
  (:action apply_unique_item_for_special_flow
    :parameters (?companion_profile - companion_profile ?unique_requirement_item - unique_requirement_item)
    :precondition
      (and
        (profile_special_prep_done ?companion_profile)
        (profile_unique_requirement_attached ?companion_profile ?unique_requirement_item)
        (not
          (profile_special_ready_for_finalize ?companion_profile)
        )
      )
    :effect (profile_special_ready_for_finalize ?companion_profile)
  )
  (:action finalize_profile_unlock_via_special_flow
    :parameters (?companion_profile - companion_profile)
    :precondition
      (and
        (profile_special_ready_for_finalize ?companion_profile)
        (not
          (profile_finalization_committed ?companion_profile)
        )
      )
    :effect
      (and
        (profile_finalization_committed ?companion_profile)
        (unlockable_entity_granted ?companion_profile)
      )
  )
  (:action grant_unlock_on_primary_node
    :parameters (?primary_unlock_node - primary_unlock_node ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (primary_node_marked ?primary_unlock_node)
        (primary_node_stage_completed ?primary_unlock_node)
        (reward_bundle_ready ?reward_bundle_entry)
        (reward_bundle_asset_commit_ready ?reward_bundle_entry)
        (not
          (unlockable_entity_granted ?primary_unlock_node)
        )
      )
    :effect (unlockable_entity_granted ?primary_unlock_node)
  )
  (:action grant_unlock_on_secondary_node
    :parameters (?secondary_unlock_node - secondary_unlock_node ?reward_bundle_entry - reward_bundle_entry)
    :precondition
      (and
        (secondary_node_marked ?secondary_unlock_node)
        (secondary_node_stage_completed ?secondary_unlock_node)
        (reward_bundle_ready ?reward_bundle_entry)
        (reward_bundle_asset_commit_ready ?reward_bundle_entry)
        (not
          (unlockable_entity_granted ?secondary_unlock_node)
        )
      )
    :effect (unlockable_entity_granted ?secondary_unlock_node)
  )
  (:action bind_credential_to_unlockable_entity
    :parameters (?unlockable_entity_root - unlockable_entity_root ?companion_credential - companion_credential ?task_objective - task_objective)
    :precondition
      (and
        (unlockable_entity_granted ?unlockable_entity_root)
        (unlockable_entity_has_objective ?unlockable_entity_root ?task_objective)
        (companion_credential_available ?companion_credential)
        (not
          (unlockable_entity_credential_applied ?unlockable_entity_root)
        )
      )
    :effect
      (and
        (unlockable_entity_credential_applied ?unlockable_entity_root)
        (unlockable_entity_credential_bound ?unlockable_entity_root ?companion_credential)
        (not
          (companion_credential_available ?companion_credential)
        )
      )
  )
  (:action finalize_and_unlock_primary_node
    :parameters (?primary_unlock_node - primary_unlock_node ?unlock_token - unlock_token ?companion_credential - companion_credential)
    :precondition
      (and
        (unlockable_entity_credential_applied ?primary_unlock_node)
        (unlockable_entity_has_unlock_token ?primary_unlock_node ?unlock_token)
        (unlockable_entity_credential_bound ?primary_unlock_node ?companion_credential)
        (not
          (unlockable_entity_completed ?primary_unlock_node)
        )
      )
    :effect
      (and
        (unlockable_entity_completed ?primary_unlock_node)
        (unlock_token_available ?unlock_token)
        (companion_credential_available ?companion_credential)
      )
  )
  (:action finalize_and_unlock_secondary_node
    :parameters (?secondary_unlock_node - secondary_unlock_node ?unlock_token - unlock_token ?companion_credential - companion_credential)
    :precondition
      (and
        (unlockable_entity_credential_applied ?secondary_unlock_node)
        (unlockable_entity_has_unlock_token ?secondary_unlock_node ?unlock_token)
        (unlockable_entity_credential_bound ?secondary_unlock_node ?companion_credential)
        (not
          (unlockable_entity_completed ?secondary_unlock_node)
        )
      )
    :effect
      (and
        (unlockable_entity_completed ?secondary_unlock_node)
        (unlock_token_available ?unlock_token)
        (companion_credential_available ?companion_credential)
      )
  )
  (:action finalize_and_unlock_profile
    :parameters (?companion_profile - companion_profile ?unlock_token - unlock_token ?companion_credential - companion_credential)
    :precondition
      (and
        (unlockable_entity_credential_applied ?companion_profile)
        (unlockable_entity_has_unlock_token ?companion_profile ?unlock_token)
        (unlockable_entity_credential_bound ?companion_profile ?companion_credential)
        (not
          (unlockable_entity_completed ?companion_profile)
        )
      )
    :effect
      (and
        (unlockable_entity_completed ?companion_profile)
        (unlock_token_available ?unlock_token)
        (companion_credential_available ?companion_credential)
      )
  )
)

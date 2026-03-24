(define (domain objective_ordering_campaign)
  (:requirements :strips :typing :negative-preconditions)
  (:types game_entity - object resource_type - game_entity asset_type - game_entity structural_type - game_entity objective_category - game_entity objective - objective_category unlock_token - resource_type action_type - resource_type supporting_npc - resource_type special_modifier - resource_type upgrade - resource_type checkpoint_token - resource_type reward - resource_type story_key - resource_type consumable_item - asset_type optional_challenge - asset_type plot_token - asset_type path_variant_a - structural_type path_variant_b - structural_type mission_package - structural_type tiered_objective - objective meta_objective - objective mission_slot_a - tiered_objective mission_slot_b - tiered_objective campaign_node - meta_objective)

  (:predicates
    (mission_entity_active ?objective - objective)
    (mission_entity_ready ?objective - objective)
    (mission_entity_unlocked ?objective - objective)
    (mission_entity_completed ?objective - objective)
    (mission_entity_completion_flag ?objective - objective)
    (propagation_ready ?objective - objective)
    (unlock_token_available ?unlock_token - unlock_token)
    (mission_entity_assigned_unlock_token ?objective - objective ?unlock_token - unlock_token)
    (action_available ?action_type - action_type)
    (mission_entity_assigned_action ?objective - objective ?action_type - action_type)
    (npc_available ?supporting_npc - supporting_npc)
    (mission_entity_assigned_npc ?objective - objective ?supporting_npc - supporting_npc)
    (consumable_available ?consumable_item - consumable_item)
    (slot_a_consumable_assigned ?mission_slot_a - mission_slot_a ?consumable_item - consumable_item)
    (slot_b_consumable_assigned ?mission_slot_b - mission_slot_b ?consumable_item - consumable_item)
    (slot_a_assigned_path ?mission_slot_a - mission_slot_a ?path_variant_a - path_variant_a)
    (path_variant_a_ready ?path_variant_a - path_variant_a)
    (path_variant_a_consumed ?path_variant_a - path_variant_a)
    (mission_slot_a_confirmed ?mission_slot_a - mission_slot_a)
    (slot_b_assigned_path ?mission_slot_b - mission_slot_b ?path_variant_b - path_variant_b)
    (path_variant_b_ready ?path_variant_b - path_variant_b)
    (path_variant_b_consumed ?path_variant_b - path_variant_b)
    (mission_slot_b_confirmed ?mission_slot_b - mission_slot_b)
    (mission_package_unassembled ?mission_package - mission_package)
    (mission_package_ready ?mission_package - mission_package)
    (package_includes_path_a ?mission_package - mission_package ?path_variant_a - path_variant_a)
    (package_includes_path_b ?mission_package - mission_package ?path_variant_b - path_variant_b)
    (package_flag_a ?mission_package - mission_package)
    (package_flag_b ?mission_package - mission_package)
    (package_validated ?mission_package - mission_package)
    (node_contains_slot_a ?campaign_node - campaign_node ?mission_slot_a - mission_slot_a)
    (node_contains_slot_b ?campaign_node - campaign_node ?mission_slot_b - mission_slot_b)
    (node_contains_package ?campaign_node - campaign_node ?mission_package - mission_package)
    (optional_challenge_available ?optional_challenge - optional_challenge)
    (node_has_optional_challenge ?campaign_node - campaign_node ?optional_challenge - optional_challenge)
    (optional_challenge_active ?optional_challenge - optional_challenge)
    (challenge_assigned_to_package ?optional_challenge - optional_challenge ?mission_package - mission_package)
    (node_optional_unlocked ?campaign_node - campaign_node)
    (node_challenge_unlocked ?campaign_node - campaign_node)
    (node_ready_for_finalization ?campaign_node - campaign_node)
    (node_has_special_modifier ?campaign_node - campaign_node)
    (node_modifier_applied ?campaign_node - campaign_node)
    (node_ready_for_upgrades ?campaign_node - campaign_node)
    (node_precompleted ?campaign_node - campaign_node)
    (plot_token_available ?plot_token - plot_token)
    (node_has_plot_token ?campaign_node - campaign_node ?plot_token - plot_token)
    (node_plot_engaged ?campaign_node - campaign_node)
    (node_plot_processed ?campaign_node - campaign_node)
    (node_plot_resolved ?campaign_node - campaign_node)
    (special_modifier_available ?special_modifier - special_modifier)
    (node_assigned_special_modifier ?campaign_node - campaign_node ?special_modifier - special_modifier)
    (upgrade_available ?upgrade - upgrade)
    (node_attached_upgrade ?campaign_node - campaign_node ?upgrade - upgrade)
    (reward_available ?reward - reward)
    (node_assigned_reward ?campaign_node - campaign_node ?reward - reward)
    (story_key_available ?story_key - story_key)
    (node_assigned_story_key ?campaign_node - campaign_node ?story_key - story_key)
    (checkpoint_token_available ?checkpoint_token - checkpoint_token)
    (mission_entity_assigned_checkpoint ?objective - objective ?checkpoint_token - checkpoint_token)
    (mission_slot_a_ready ?mission_slot_a - mission_slot_a)
    (mission_slot_b_ready ?mission_slot_b - mission_slot_b)
    (mission_entity_marked_complete ?campaign_node - campaign_node)
  )
  (:action activate_mission_entity
    :parameters (?objective - objective)
    :precondition
      (and
        (not
          (mission_entity_active ?objective)
        )
        (not
          (mission_entity_completed ?objective)
        )
      )
    :effect (mission_entity_active ?objective)
  )
  (:action unlock_mission_entity_with_token
    :parameters (?objective - objective ?unlock_token - unlock_token)
    :precondition
      (and
        (mission_entity_active ?objective)
        (not
          (mission_entity_unlocked ?objective)
        )
        (unlock_token_available ?unlock_token)
      )
    :effect
      (and
        (mission_entity_unlocked ?objective)
        (mission_entity_assigned_unlock_token ?objective ?unlock_token)
        (not
          (unlock_token_available ?unlock_token)
        )
      )
  )
  (:action assign_action_to_mission_entity
    :parameters (?objective - objective ?action_type - action_type)
    :precondition
      (and
        (mission_entity_active ?objective)
        (mission_entity_unlocked ?objective)
        (action_available ?action_type)
      )
    :effect
      (and
        (mission_entity_assigned_action ?objective ?action_type)
        (not
          (action_available ?action_type)
        )
      )
  )
  (:action confirm_mission_entity_ready
    :parameters (?objective - objective ?action_type - action_type)
    :precondition
      (and
        (mission_entity_active ?objective)
        (mission_entity_unlocked ?objective)
        (mission_entity_assigned_action ?objective ?action_type)
        (not
          (mission_entity_ready ?objective)
        )
      )
    :effect (mission_entity_ready ?objective)
  )
  (:action unassign_action_from_mission_entity
    :parameters (?objective - objective ?action_type - action_type)
    :precondition
      (and
        (mission_entity_assigned_action ?objective ?action_type)
      )
    :effect
      (and
        (action_available ?action_type)
        (not
          (mission_entity_assigned_action ?objective ?action_type)
        )
      )
  )
  (:action assign_npc_to_mission_entity
    :parameters (?objective - objective ?supporting_npc - supporting_npc)
    :precondition
      (and
        (mission_entity_ready ?objective)
        (npc_available ?supporting_npc)
      )
    :effect
      (and
        (mission_entity_assigned_npc ?objective ?supporting_npc)
        (not
          (npc_available ?supporting_npc)
        )
      )
  )
  (:action unassign_npc_from_mission_entity
    :parameters (?objective - objective ?supporting_npc - supporting_npc)
    :precondition
      (and
        (mission_entity_assigned_npc ?objective ?supporting_npc)
      )
    :effect
      (and
        (npc_available ?supporting_npc)
        (not
          (mission_entity_assigned_npc ?objective ?supporting_npc)
        )
      )
  )
  (:action assign_reward_to_node
    :parameters (?campaign_node - campaign_node ?reward - reward)
    :precondition
      (and
        (mission_entity_ready ?campaign_node)
        (reward_available ?reward)
      )
    :effect
      (and
        (node_assigned_reward ?campaign_node ?reward)
        (not
          (reward_available ?reward)
        )
      )
  )
  (:action detach_reward_from_node
    :parameters (?campaign_node - campaign_node ?reward - reward)
    :precondition
      (and
        (node_assigned_reward ?campaign_node ?reward)
      )
    :effect
      (and
        (reward_available ?reward)
        (not
          (node_assigned_reward ?campaign_node ?reward)
        )
      )
  )
  (:action assign_story_key_to_node
    :parameters (?campaign_node - campaign_node ?story_key - story_key)
    :precondition
      (and
        (mission_entity_ready ?campaign_node)
        (story_key_available ?story_key)
      )
    :effect
      (and
        (node_assigned_story_key ?campaign_node ?story_key)
        (not
          (story_key_available ?story_key)
        )
      )
  )
  (:action unassign_story_key_from_node
    :parameters (?campaign_node - campaign_node ?story_key - story_key)
    :precondition
      (and
        (node_assigned_story_key ?campaign_node ?story_key)
      )
    :effect
      (and
        (story_key_available ?story_key)
        (not
          (node_assigned_story_key ?campaign_node ?story_key)
        )
      )
  )
  (:action activate_path_variant_a
    :parameters (?mission_slot_a - mission_slot_a ?path_variant_a - path_variant_a ?action_type - action_type)
    :precondition
      (and
        (mission_entity_ready ?mission_slot_a)
        (mission_entity_assigned_action ?mission_slot_a ?action_type)
        (slot_a_assigned_path ?mission_slot_a ?path_variant_a)
        (not
          (path_variant_a_ready ?path_variant_a)
        )
        (not
          (path_variant_a_consumed ?path_variant_a)
        )
      )
    :effect (path_variant_a_ready ?path_variant_a)
  )
  (:action finalize_mission_slot_a
    :parameters (?mission_slot_a - mission_slot_a ?path_variant_a - path_variant_a ?supporting_npc - supporting_npc)
    :precondition
      (and
        (mission_entity_ready ?mission_slot_a)
        (mission_entity_assigned_npc ?mission_slot_a ?supporting_npc)
        (slot_a_assigned_path ?mission_slot_a ?path_variant_a)
        (path_variant_a_ready ?path_variant_a)
        (not
          (mission_slot_a_ready ?mission_slot_a)
        )
      )
    :effect
      (and
        (mission_slot_a_ready ?mission_slot_a)
        (mission_slot_a_confirmed ?mission_slot_a)
      )
  )
  (:action consume_item_for_mission_slot_a
    :parameters (?mission_slot_a - mission_slot_a ?path_variant_a - path_variant_a ?consumable_item - consumable_item)
    :precondition
      (and
        (mission_entity_ready ?mission_slot_a)
        (slot_a_assigned_path ?mission_slot_a ?path_variant_a)
        (consumable_available ?consumable_item)
        (not
          (mission_slot_a_ready ?mission_slot_a)
        )
      )
    :effect
      (and
        (path_variant_a_consumed ?path_variant_a)
        (mission_slot_a_ready ?mission_slot_a)
        (slot_a_consumable_assigned ?mission_slot_a ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action resolve_mission_slot_a
    :parameters (?mission_slot_a - mission_slot_a ?path_variant_a - path_variant_a ?action_type - action_type ?consumable_item - consumable_item)
    :precondition
      (and
        (mission_entity_ready ?mission_slot_a)
        (mission_entity_assigned_action ?mission_slot_a ?action_type)
        (slot_a_assigned_path ?mission_slot_a ?path_variant_a)
        (path_variant_a_consumed ?path_variant_a)
        (slot_a_consumable_assigned ?mission_slot_a ?consumable_item)
        (not
          (mission_slot_a_confirmed ?mission_slot_a)
        )
      )
    :effect
      (and
        (path_variant_a_ready ?path_variant_a)
        (mission_slot_a_confirmed ?mission_slot_a)
        (consumable_available ?consumable_item)
        (not
          (slot_a_consumable_assigned ?mission_slot_a ?consumable_item)
        )
      )
  )
  (:action activate_path_variant_b
    :parameters (?mission_slot_b - mission_slot_b ?path_variant_b - path_variant_b ?action_type - action_type)
    :precondition
      (and
        (mission_entity_ready ?mission_slot_b)
        (mission_entity_assigned_action ?mission_slot_b ?action_type)
        (slot_b_assigned_path ?mission_slot_b ?path_variant_b)
        (not
          (path_variant_b_ready ?path_variant_b)
        )
        (not
          (path_variant_b_consumed ?path_variant_b)
        )
      )
    :effect (path_variant_b_ready ?path_variant_b)
  )
  (:action finalize_mission_slot_b
    :parameters (?mission_slot_b - mission_slot_b ?path_variant_b - path_variant_b ?supporting_npc - supporting_npc)
    :precondition
      (and
        (mission_entity_ready ?mission_slot_b)
        (mission_entity_assigned_npc ?mission_slot_b ?supporting_npc)
        (slot_b_assigned_path ?mission_slot_b ?path_variant_b)
        (path_variant_b_ready ?path_variant_b)
        (not
          (mission_slot_b_ready ?mission_slot_b)
        )
      )
    :effect
      (and
        (mission_slot_b_ready ?mission_slot_b)
        (mission_slot_b_confirmed ?mission_slot_b)
      )
  )
  (:action consume_item_for_mission_slot_b
    :parameters (?mission_slot_b - mission_slot_b ?path_variant_b - path_variant_b ?consumable_item - consumable_item)
    :precondition
      (and
        (mission_entity_ready ?mission_slot_b)
        (slot_b_assigned_path ?mission_slot_b ?path_variant_b)
        (consumable_available ?consumable_item)
        (not
          (mission_slot_b_ready ?mission_slot_b)
        )
      )
    :effect
      (and
        (path_variant_b_consumed ?path_variant_b)
        (mission_slot_b_ready ?mission_slot_b)
        (slot_b_consumable_assigned ?mission_slot_b ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action resolve_mission_slot_b
    :parameters (?mission_slot_b - mission_slot_b ?path_variant_b - path_variant_b ?action_type - action_type ?consumable_item - consumable_item)
    :precondition
      (and
        (mission_entity_ready ?mission_slot_b)
        (mission_entity_assigned_action ?mission_slot_b ?action_type)
        (slot_b_assigned_path ?mission_slot_b ?path_variant_b)
        (path_variant_b_consumed ?path_variant_b)
        (slot_b_consumable_assigned ?mission_slot_b ?consumable_item)
        (not
          (mission_slot_b_confirmed ?mission_slot_b)
        )
      )
    :effect
      (and
        (path_variant_b_ready ?path_variant_b)
        (mission_slot_b_confirmed ?mission_slot_b)
        (consumable_available ?consumable_item)
        (not
          (slot_b_consumable_assigned ?mission_slot_b ?consumable_item)
        )
      )
  )
  (:action assemble_mission_package
    :parameters (?mission_slot_a - mission_slot_a ?mission_slot_b - mission_slot_b ?path_variant_a - path_variant_a ?path_variant_b - path_variant_b ?mission_package - mission_package)
    :precondition
      (and
        (mission_slot_a_ready ?mission_slot_a)
        (mission_slot_b_ready ?mission_slot_b)
        (slot_a_assigned_path ?mission_slot_a ?path_variant_a)
        (slot_b_assigned_path ?mission_slot_b ?path_variant_b)
        (path_variant_a_ready ?path_variant_a)
        (path_variant_b_ready ?path_variant_b)
        (mission_slot_a_confirmed ?mission_slot_a)
        (mission_slot_b_confirmed ?mission_slot_b)
        (mission_package_unassembled ?mission_package)
      )
    :effect
      (and
        (mission_package_ready ?mission_package)
        (package_includes_path_a ?mission_package ?path_variant_a)
        (package_includes_path_b ?mission_package ?path_variant_b)
        (not
          (mission_package_unassembled ?mission_package)
        )
      )
  )
  (:action assemble_mission_package_variant_a
    :parameters (?mission_slot_a - mission_slot_a ?mission_slot_b - mission_slot_b ?path_variant_a - path_variant_a ?path_variant_b - path_variant_b ?mission_package - mission_package)
    :precondition
      (and
        (mission_slot_a_ready ?mission_slot_a)
        (mission_slot_b_ready ?mission_slot_b)
        (slot_a_assigned_path ?mission_slot_a ?path_variant_a)
        (slot_b_assigned_path ?mission_slot_b ?path_variant_b)
        (path_variant_a_consumed ?path_variant_a)
        (path_variant_b_ready ?path_variant_b)
        (not
          (mission_slot_a_confirmed ?mission_slot_a)
        )
        (mission_slot_b_confirmed ?mission_slot_b)
        (mission_package_unassembled ?mission_package)
      )
    :effect
      (and
        (mission_package_ready ?mission_package)
        (package_includes_path_a ?mission_package ?path_variant_a)
        (package_includes_path_b ?mission_package ?path_variant_b)
        (package_flag_a ?mission_package)
        (not
          (mission_package_unassembled ?mission_package)
        )
      )
  )
  (:action assemble_mission_package_variant_b
    :parameters (?mission_slot_a - mission_slot_a ?mission_slot_b - mission_slot_b ?path_variant_a - path_variant_a ?path_variant_b - path_variant_b ?mission_package - mission_package)
    :precondition
      (and
        (mission_slot_a_ready ?mission_slot_a)
        (mission_slot_b_ready ?mission_slot_b)
        (slot_a_assigned_path ?mission_slot_a ?path_variant_a)
        (slot_b_assigned_path ?mission_slot_b ?path_variant_b)
        (path_variant_a_ready ?path_variant_a)
        (path_variant_b_consumed ?path_variant_b)
        (mission_slot_a_confirmed ?mission_slot_a)
        (not
          (mission_slot_b_confirmed ?mission_slot_b)
        )
        (mission_package_unassembled ?mission_package)
      )
    :effect
      (and
        (mission_package_ready ?mission_package)
        (package_includes_path_a ?mission_package ?path_variant_a)
        (package_includes_path_b ?mission_package ?path_variant_b)
        (package_flag_b ?mission_package)
        (not
          (mission_package_unassembled ?mission_package)
        )
      )
  )
  (:action assemble_mission_package_full
    :parameters (?mission_slot_a - mission_slot_a ?mission_slot_b - mission_slot_b ?path_variant_a - path_variant_a ?path_variant_b - path_variant_b ?mission_package - mission_package)
    :precondition
      (and
        (mission_slot_a_ready ?mission_slot_a)
        (mission_slot_b_ready ?mission_slot_b)
        (slot_a_assigned_path ?mission_slot_a ?path_variant_a)
        (slot_b_assigned_path ?mission_slot_b ?path_variant_b)
        (path_variant_a_consumed ?path_variant_a)
        (path_variant_b_consumed ?path_variant_b)
        (not
          (mission_slot_a_confirmed ?mission_slot_a)
        )
        (not
          (mission_slot_b_confirmed ?mission_slot_b)
        )
        (mission_package_unassembled ?mission_package)
      )
    :effect
      (and
        (mission_package_ready ?mission_package)
        (package_includes_path_a ?mission_package ?path_variant_a)
        (package_includes_path_b ?mission_package ?path_variant_b)
        (package_flag_a ?mission_package)
        (package_flag_b ?mission_package)
        (not
          (mission_package_unassembled ?mission_package)
        )
      )
  )
  (:action validate_mission_package
    :parameters (?mission_package - mission_package ?mission_slot_a - mission_slot_a ?action_type - action_type)
    :precondition
      (and
        (mission_package_ready ?mission_package)
        (mission_slot_a_ready ?mission_slot_a)
        (mission_entity_assigned_action ?mission_slot_a ?action_type)
        (not
          (package_validated ?mission_package)
        )
      )
    :effect (package_validated ?mission_package)
  )
  (:action activate_optional_challenge_for_package
    :parameters (?campaign_node - campaign_node ?optional_challenge - optional_challenge ?mission_package - mission_package)
    :precondition
      (and
        (mission_entity_ready ?campaign_node)
        (node_contains_package ?campaign_node ?mission_package)
        (node_has_optional_challenge ?campaign_node ?optional_challenge)
        (optional_challenge_available ?optional_challenge)
        (mission_package_ready ?mission_package)
        (package_validated ?mission_package)
        (not
          (optional_challenge_active ?optional_challenge)
        )
      )
    :effect
      (and
        (optional_challenge_active ?optional_challenge)
        (challenge_assigned_to_package ?optional_challenge ?mission_package)
        (not
          (optional_challenge_available ?optional_challenge)
        )
      )
  )
  (:action unlock_node_optional_content
    :parameters (?campaign_node - campaign_node ?optional_challenge - optional_challenge ?mission_package - mission_package ?action_type - action_type)
    :precondition
      (and
        (mission_entity_ready ?campaign_node)
        (node_has_optional_challenge ?campaign_node ?optional_challenge)
        (optional_challenge_active ?optional_challenge)
        (challenge_assigned_to_package ?optional_challenge ?mission_package)
        (mission_entity_assigned_action ?campaign_node ?action_type)
        (not
          (package_flag_a ?mission_package)
        )
        (not
          (node_optional_unlocked ?campaign_node)
        )
      )
    :effect (node_optional_unlocked ?campaign_node)
  )
  (:action assign_special_modifier_to_node
    :parameters (?campaign_node - campaign_node ?special_modifier - special_modifier)
    :precondition
      (and
        (mission_entity_ready ?campaign_node)
        (special_modifier_available ?special_modifier)
        (not
          (node_has_special_modifier ?campaign_node)
        )
      )
    :effect
      (and
        (node_has_special_modifier ?campaign_node)
        (node_assigned_special_modifier ?campaign_node ?special_modifier)
        (not
          (special_modifier_available ?special_modifier)
        )
      )
  )
  (:action apply_special_modifier_with_challenge
    :parameters (?campaign_node - campaign_node ?optional_challenge - optional_challenge ?mission_package - mission_package ?action_type - action_type ?special_modifier - special_modifier)
    :precondition
      (and
        (mission_entity_ready ?campaign_node)
        (node_has_optional_challenge ?campaign_node ?optional_challenge)
        (optional_challenge_active ?optional_challenge)
        (challenge_assigned_to_package ?optional_challenge ?mission_package)
        (mission_entity_assigned_action ?campaign_node ?action_type)
        (package_flag_a ?mission_package)
        (node_has_special_modifier ?campaign_node)
        (node_assigned_special_modifier ?campaign_node ?special_modifier)
        (not
          (node_optional_unlocked ?campaign_node)
        )
      )
    :effect
      (and
        (node_optional_unlocked ?campaign_node)
        (node_modifier_applied ?campaign_node)
      )
  )
  (:action progress_node_optional_challenge
    :parameters (?campaign_node - campaign_node ?reward - reward ?supporting_npc - supporting_npc ?optional_challenge - optional_challenge ?mission_package - mission_package)
    :precondition
      (and
        (node_optional_unlocked ?campaign_node)
        (node_assigned_reward ?campaign_node ?reward)
        (mission_entity_assigned_npc ?campaign_node ?supporting_npc)
        (node_has_optional_challenge ?campaign_node ?optional_challenge)
        (challenge_assigned_to_package ?optional_challenge ?mission_package)
        (not
          (package_flag_b ?mission_package)
        )
        (not
          (node_challenge_unlocked ?campaign_node)
        )
      )
    :effect (node_challenge_unlocked ?campaign_node)
  )
  (:action progress_node_optional_challenge_variant
    :parameters (?campaign_node - campaign_node ?reward - reward ?supporting_npc - supporting_npc ?optional_challenge - optional_challenge ?mission_package - mission_package)
    :precondition
      (and
        (node_optional_unlocked ?campaign_node)
        (node_assigned_reward ?campaign_node ?reward)
        (mission_entity_assigned_npc ?campaign_node ?supporting_npc)
        (node_has_optional_challenge ?campaign_node ?optional_challenge)
        (challenge_assigned_to_package ?optional_challenge ?mission_package)
        (package_flag_b ?mission_package)
        (not
          (node_challenge_unlocked ?campaign_node)
        )
      )
    :effect (node_challenge_unlocked ?campaign_node)
  )
  (:action prepare_node_for_finalization
    :parameters (?campaign_node - campaign_node ?story_key - story_key ?optional_challenge - optional_challenge ?mission_package - mission_package)
    :precondition
      (and
        (node_challenge_unlocked ?campaign_node)
        (node_assigned_story_key ?campaign_node ?story_key)
        (node_has_optional_challenge ?campaign_node ?optional_challenge)
        (challenge_assigned_to_package ?optional_challenge ?mission_package)
        (not
          (package_flag_a ?mission_package)
        )
        (not
          (package_flag_b ?mission_package)
        )
        (not
          (node_ready_for_finalization ?campaign_node)
        )
      )
    :effect (node_ready_for_finalization ?campaign_node)
  )
  (:action prepare_node_for_finalization_with_package_flag_a
    :parameters (?campaign_node - campaign_node ?story_key - story_key ?optional_challenge - optional_challenge ?mission_package - mission_package)
    :precondition
      (and
        (node_challenge_unlocked ?campaign_node)
        (node_assigned_story_key ?campaign_node ?story_key)
        (node_has_optional_challenge ?campaign_node ?optional_challenge)
        (challenge_assigned_to_package ?optional_challenge ?mission_package)
        (package_flag_a ?mission_package)
        (not
          (package_flag_b ?mission_package)
        )
        (not
          (node_ready_for_finalization ?campaign_node)
        )
      )
    :effect
      (and
        (node_ready_for_finalization ?campaign_node)
        (node_ready_for_upgrades ?campaign_node)
      )
  )
  (:action prepare_node_for_finalization_with_package_flag_b
    :parameters (?campaign_node - campaign_node ?story_key - story_key ?optional_challenge - optional_challenge ?mission_package - mission_package)
    :precondition
      (and
        (node_challenge_unlocked ?campaign_node)
        (node_assigned_story_key ?campaign_node ?story_key)
        (node_has_optional_challenge ?campaign_node ?optional_challenge)
        (challenge_assigned_to_package ?optional_challenge ?mission_package)
        (not
          (package_flag_a ?mission_package)
        )
        (package_flag_b ?mission_package)
        (not
          (node_ready_for_finalization ?campaign_node)
        )
      )
    :effect
      (and
        (node_ready_for_finalization ?campaign_node)
        (node_ready_for_upgrades ?campaign_node)
      )
  )
  (:action prepare_node_for_finalization_with_all_package_flags
    :parameters (?campaign_node - campaign_node ?story_key - story_key ?optional_challenge - optional_challenge ?mission_package - mission_package)
    :precondition
      (and
        (node_challenge_unlocked ?campaign_node)
        (node_assigned_story_key ?campaign_node ?story_key)
        (node_has_optional_challenge ?campaign_node ?optional_challenge)
        (challenge_assigned_to_package ?optional_challenge ?mission_package)
        (package_flag_a ?mission_package)
        (package_flag_b ?mission_package)
        (not
          (node_ready_for_finalization ?campaign_node)
        )
      )
    :effect
      (and
        (node_ready_for_finalization ?campaign_node)
        (node_ready_for_upgrades ?campaign_node)
      )
  )
  (:action finalize_campaign_node
    :parameters (?campaign_node - campaign_node)
    :precondition
      (and
        (node_ready_for_finalization ?campaign_node)
        (not
          (node_ready_for_upgrades ?campaign_node)
        )
        (not
          (mission_entity_marked_complete ?campaign_node)
        )
      )
    :effect
      (and
        (mission_entity_marked_complete ?campaign_node)
        (mission_entity_completion_flag ?campaign_node)
      )
  )
  (:action attach_upgrade_to_node
    :parameters (?campaign_node - campaign_node ?upgrade - upgrade)
    :precondition
      (and
        (node_ready_for_finalization ?campaign_node)
        (node_ready_for_upgrades ?campaign_node)
        (upgrade_available ?upgrade)
      )
    :effect
      (and
        (node_attached_upgrade ?campaign_node ?upgrade)
        (not
          (upgrade_available ?upgrade)
        )
      )
  )
  (:action apply_upgrades_and_mark_node_precompleted
    :parameters (?campaign_node - campaign_node ?mission_slot_a - mission_slot_a ?mission_slot_b - mission_slot_b ?action_type - action_type ?upgrade - upgrade)
    :precondition
      (and
        (node_ready_for_finalization ?campaign_node)
        (node_ready_for_upgrades ?campaign_node)
        (node_attached_upgrade ?campaign_node ?upgrade)
        (node_contains_slot_a ?campaign_node ?mission_slot_a)
        (node_contains_slot_b ?campaign_node ?mission_slot_b)
        (mission_slot_a_confirmed ?mission_slot_a)
        (mission_slot_b_confirmed ?mission_slot_b)
        (mission_entity_assigned_action ?campaign_node ?action_type)
        (not
          (node_precompleted ?campaign_node)
        )
      )
    :effect (node_precompleted ?campaign_node)
  )
  (:action complete_campaign_node
    :parameters (?campaign_node - campaign_node)
    :precondition
      (and
        (node_ready_for_finalization ?campaign_node)
        (node_precompleted ?campaign_node)
        (not
          (mission_entity_marked_complete ?campaign_node)
        )
      )
    :effect
      (and
        (mission_entity_marked_complete ?campaign_node)
        (mission_entity_completion_flag ?campaign_node)
      )
  )
  (:action engage_plot_token_for_node
    :parameters (?campaign_node - campaign_node ?plot_token - plot_token ?action_type - action_type)
    :precondition
      (and
        (mission_entity_ready ?campaign_node)
        (mission_entity_assigned_action ?campaign_node ?action_type)
        (plot_token_available ?plot_token)
        (node_has_plot_token ?campaign_node ?plot_token)
        (not
          (node_plot_engaged ?campaign_node)
        )
      )
    :effect
      (and
        (node_plot_engaged ?campaign_node)
        (not
          (plot_token_available ?plot_token)
        )
      )
  )
  (:action process_node_plot
    :parameters (?campaign_node - campaign_node ?supporting_npc - supporting_npc)
    :precondition
      (and
        (node_plot_engaged ?campaign_node)
        (mission_entity_assigned_npc ?campaign_node ?supporting_npc)
        (not
          (node_plot_processed ?campaign_node)
        )
      )
    :effect (node_plot_processed ?campaign_node)
  )
  (:action resolve_node_story_key_post_plot
    :parameters (?campaign_node - campaign_node ?story_key - story_key)
    :precondition
      (and
        (node_plot_processed ?campaign_node)
        (node_assigned_story_key ?campaign_node ?story_key)
        (not
          (node_plot_resolved ?campaign_node)
        )
      )
    :effect (node_plot_resolved ?campaign_node)
  )
  (:action complete_node_after_plot
    :parameters (?campaign_node - campaign_node)
    :precondition
      (and
        (node_plot_resolved ?campaign_node)
        (not
          (mission_entity_marked_complete ?campaign_node)
        )
      )
    :effect
      (and
        (mission_entity_marked_complete ?campaign_node)
        (mission_entity_completion_flag ?campaign_node)
      )
  )
  (:action propagate_completion_to_mission_slot_a
    :parameters (?mission_slot_a - mission_slot_a ?mission_package - mission_package)
    :precondition
      (and
        (mission_slot_a_ready ?mission_slot_a)
        (mission_slot_a_confirmed ?mission_slot_a)
        (mission_package_ready ?mission_package)
        (package_validated ?mission_package)
        (not
          (mission_entity_completion_flag ?mission_slot_a)
        )
      )
    :effect (mission_entity_completion_flag ?mission_slot_a)
  )
  (:action propagate_completion_to_mission_slot_b
    :parameters (?mission_slot_b - mission_slot_b ?mission_package - mission_package)
    :precondition
      (and
        (mission_slot_b_ready ?mission_slot_b)
        (mission_slot_b_confirmed ?mission_slot_b)
        (mission_package_ready ?mission_package)
        (package_validated ?mission_package)
        (not
          (mission_entity_completion_flag ?mission_slot_b)
        )
      )
    :effect (mission_entity_completion_flag ?mission_slot_b)
  )
  (:action consume_checkpoint_and_mark_propagation_for_mission_entity
    :parameters (?objective - objective ?checkpoint_token - checkpoint_token ?action_type - action_type)
    :precondition
      (and
        (mission_entity_completion_flag ?objective)
        (mission_entity_assigned_action ?objective ?action_type)
        (checkpoint_token_available ?checkpoint_token)
        (not
          (propagation_ready ?objective)
        )
      )
    :effect
      (and
        (propagation_ready ?objective)
        (mission_entity_assigned_checkpoint ?objective ?checkpoint_token)
        (not
          (checkpoint_token_available ?checkpoint_token)
        )
      )
  )
  (:action propagate_completion_to_slot_a
    :parameters (?mission_slot_a - mission_slot_a ?unlock_token - unlock_token ?checkpoint_token - checkpoint_token)
    :precondition
      (and
        (propagation_ready ?mission_slot_a)
        (mission_entity_assigned_unlock_token ?mission_slot_a ?unlock_token)
        (mission_entity_assigned_checkpoint ?mission_slot_a ?checkpoint_token)
        (not
          (mission_entity_completed ?mission_slot_a)
        )
      )
    :effect
      (and
        (mission_entity_completed ?mission_slot_a)
        (unlock_token_available ?unlock_token)
        (checkpoint_token_available ?checkpoint_token)
      )
  )
  (:action propagate_completion_to_slot_b
    :parameters (?mission_slot_b - mission_slot_b ?unlock_token - unlock_token ?checkpoint_token - checkpoint_token)
    :precondition
      (and
        (propagation_ready ?mission_slot_b)
        (mission_entity_assigned_unlock_token ?mission_slot_b ?unlock_token)
        (mission_entity_assigned_checkpoint ?mission_slot_b ?checkpoint_token)
        (not
          (mission_entity_completed ?mission_slot_b)
        )
      )
    :effect
      (and
        (mission_entity_completed ?mission_slot_b)
        (unlock_token_available ?unlock_token)
        (checkpoint_token_available ?checkpoint_token)
      )
  )
  (:action propagate_completion_to_node
    :parameters (?campaign_node - campaign_node ?unlock_token - unlock_token ?checkpoint_token - checkpoint_token)
    :precondition
      (and
        (propagation_ready ?campaign_node)
        (mission_entity_assigned_unlock_token ?campaign_node ?unlock_token)
        (mission_entity_assigned_checkpoint ?campaign_node ?checkpoint_token)
        (not
          (mission_entity_completed ?campaign_node)
        )
      )
    :effect
      (and
        (mission_entity_completed ?campaign_node)
        (unlock_token_available ?unlock_token)
        (checkpoint_token_available ?checkpoint_token)
      )
  )
)

(define (domain mission_reward_driven_progression)
  (:requirements :strips :typing :negative-preconditions)
  (:types asset_group - object marker_group - object component_group - object mission_root - object mission - mission_root reward_option - asset_group player_choice_token - asset_group modifier_token - asset_group feature_tag - asset_group upgrade_token - asset_group progression_marker - asset_group attachment_token - asset_group confirmation_token - asset_group consumable_resource - marker_group resource_slot - marker_group trait_token - marker_group branch_marker - component_group variant_marker - component_group constructed_reward - component_group mission_branch_group - mission mission_profile_group - mission mission_branch - mission_branch_group mission_variant - mission_branch_group mission_profile - mission_profile_group)
  (:predicates
    (mission_available ?mission - mission)
    (entity_active ?mission - mission)
    (mission_reward_selected ?mission - mission)
    (entity_completed ?mission - mission)
    (entity_claimable ?mission - mission)
    (entity_confirmed ?mission - mission)
    (reward_option_available ?reward_option - reward_option)
    (entity_reward_assigned ?mission - mission ?reward_option - reward_option)
    (player_choice_token_available ?player_choice_token - player_choice_token)
    (entity_bound_choice_token ?mission - mission ?player_choice_token - player_choice_token)
    (modifier_token_available ?modifier_token - modifier_token)
    (mission_profile_has_modifier ?mission - mission ?modifier_token - modifier_token)
    (consumable_resource_available ?consumable_resource - consumable_resource)
    (mission_branch_allocated_resource ?mission_branch - mission_branch ?consumable_resource - consumable_resource)
    (mission_variant_allocated_resource ?mission_variant - mission_variant ?consumable_resource - consumable_resource)
    (mission_branch_has_marker ?mission_branch - mission_branch ?branch_marker - branch_marker)
    (branch_marker_primed ?branch_marker - branch_marker)
    (branch_marker_allocated ?branch_marker - branch_marker)
    (mission_branch_resolved ?mission_branch - mission_branch)
    (mission_variant_has_marker ?mission_variant - mission_variant ?variant_marker - variant_marker)
    (variant_marker_primed ?variant_marker - variant_marker)
    (variant_marker_allocated ?variant_marker - variant_marker)
    (mission_variant_resolved ?mission_variant - mission_variant)
    (constructed_reward_uninitialized ?constructed_reward - constructed_reward)
    (constructed_reward_created ?constructed_reward - constructed_reward)
    (constructed_reward_has_branch_marker ?constructed_reward - constructed_reward ?branch_marker - branch_marker)
    (constructed_reward_has_variant_marker ?constructed_reward - constructed_reward ?variant_marker - variant_marker)
    (constructed_reward_branch_flag ?constructed_reward - constructed_reward)
    (constructed_reward_variant_flag ?constructed_reward - constructed_reward)
    (constructed_reward_matured ?constructed_reward - constructed_reward)
    (mission_profile_links_branch ?mission_profile - mission_profile ?mission_branch - mission_branch)
    (mission_profile_links_variant ?mission_profile - mission_profile ?mission_variant - mission_variant)
    (mission_profile_links_constructed_reward ?mission_profile - mission_profile ?constructed_reward - constructed_reward)
    (resource_slot_available ?resource_slot - resource_slot)
    (mission_profile_has_resource_slot ?mission_profile - mission_profile ?resource_slot - resource_slot)
    (resource_slot_filled ?resource_slot - resource_slot)
    (resource_slot_attached_to_reward ?resource_slot - resource_slot ?constructed_reward - constructed_reward)
    (mission_profile_attachment_stage1 ?mission_profile - mission_profile)
    (mission_profile_attachment_stage2 ?mission_profile - mission_profile)
    (mission_profile_attachment_stage3 ?mission_profile - mission_profile)
    (mission_profile_feature_attached ?mission_profile - mission_profile)
    (mission_profile_feature_path_ready ?mission_profile - mission_profile)
    (mission_profile_ready_for_upgrade ?mission_profile - mission_profile)
    (mission_profile_prereqs_validated ?mission_profile - mission_profile)
    (trait_token_available ?trait_token - trait_token)
    (mission_profile_has_trait ?mission_profile - mission_profile ?trait_token - trait_token)
    (mission_profile_trait_attached ?mission_profile - mission_profile)
    (mission_profile_trait_step2 ?mission_profile - mission_profile)
    (mission_profile_trait_confirmed ?mission_profile - mission_profile)
    (feature_tag_available ?feature_tag - feature_tag)
    (mission_profile_has_feature ?mission_profile - mission_profile ?feature_tag - feature_tag)
    (upgrade_token_available ?upgrade_token - upgrade_token)
    (mission_profile_has_upgrade ?mission_profile - mission_profile ?upgrade_token - upgrade_token)
    (attachment_token_available ?attachment_token - attachment_token)
    (mission_profile_has_attachment ?mission_profile - mission_profile ?attachment_token - attachment_token)
    (confirmation_token_available ?confirmation_token - confirmation_token)
    (mission_profile_has_confirmation ?mission_profile - mission_profile ?confirmation_token - confirmation_token)
    (progression_marker_available ?progression_marker - progression_marker)
    (mission_has_progression_marker ?mission - mission ?progression_marker - progression_marker)
    (mission_branch_ready ?mission_branch - mission_branch)
    (mission_variant_ready ?mission_variant - mission_variant)
    (mission_profile_finalized ?mission_profile - mission_profile)
  )
  (:action set_mission_available
    :parameters (?mission - mission)
    :precondition
      (and
        (not
          (mission_available ?mission)
        )
        (not
          (entity_completed ?mission)
        )
      )
    :effect (mission_available ?mission)
  )
  (:action select_reward_option
    :parameters (?mission - mission ?reward_option - reward_option)
    :precondition
      (and
        (mission_available ?mission)
        (not
          (mission_reward_selected ?mission)
        )
        (reward_option_available ?reward_option)
      )
    :effect
      (and
        (mission_reward_selected ?mission)
        (entity_reward_assigned ?mission ?reward_option)
        (not
          (reward_option_available ?reward_option)
        )
      )
  )
  (:action bind_choice_token_to_mission
    :parameters (?mission - mission ?player_choice_token - player_choice_token)
    :precondition
      (and
        (mission_available ?mission)
        (mission_reward_selected ?mission)
        (player_choice_token_available ?player_choice_token)
      )
    :effect
      (and
        (entity_bound_choice_token ?mission ?player_choice_token)
        (not
          (player_choice_token_available ?player_choice_token)
        )
      )
  )
  (:action attach_choice_to_mission_profile
    :parameters (?mission - mission ?player_choice_token - player_choice_token)
    :precondition
      (and
        (mission_available ?mission)
        (mission_reward_selected ?mission)
        (entity_bound_choice_token ?mission ?player_choice_token)
        (not
          (entity_active ?mission)
        )
      )
    :effect (entity_active ?mission)
  )
  (:action release_choice_token
    :parameters (?mission - mission ?player_choice_token - player_choice_token)
    :precondition
      (and
        (entity_bound_choice_token ?mission ?player_choice_token)
      )
    :effect
      (and
        (player_choice_token_available ?player_choice_token)
        (not
          (entity_bound_choice_token ?mission ?player_choice_token)
        )
      )
  )
  (:action attach_modifier_to_mission_profile
    :parameters (?mission - mission ?modifier_token - modifier_token)
    :precondition
      (and
        (entity_active ?mission)
        (modifier_token_available ?modifier_token)
      )
    :effect
      (and
        (mission_profile_has_modifier ?mission ?modifier_token)
        (not
          (modifier_token_available ?modifier_token)
        )
      )
  )
  (:action detach_modifier_from_mission_profile
    :parameters (?mission - mission ?modifier_token - modifier_token)
    :precondition
      (and
        (mission_profile_has_modifier ?mission ?modifier_token)
      )
    :effect
      (and
        (modifier_token_available ?modifier_token)
        (not
          (mission_profile_has_modifier ?mission ?modifier_token)
        )
      )
  )
  (:action attach_attachment_token_to_mission_profile
    :parameters (?mission_profile - mission_profile ?attachment_token - attachment_token)
    :precondition
      (and
        (entity_active ?mission_profile)
        (attachment_token_available ?attachment_token)
      )
    :effect
      (and
        (mission_profile_has_attachment ?mission_profile ?attachment_token)
        (not
          (attachment_token_available ?attachment_token)
        )
      )
  )
  (:action detach_attachment_token_from_mission_profile
    :parameters (?mission_profile - mission_profile ?attachment_token - attachment_token)
    :precondition
      (and
        (mission_profile_has_attachment ?mission_profile ?attachment_token)
      )
    :effect
      (and
        (attachment_token_available ?attachment_token)
        (not
          (mission_profile_has_attachment ?mission_profile ?attachment_token)
        )
      )
  )
  (:action attach_confirmation_token_to_mission_profile
    :parameters (?mission_profile - mission_profile ?confirmation_token - confirmation_token)
    :precondition
      (and
        (entity_active ?mission_profile)
        (confirmation_token_available ?confirmation_token)
      )
    :effect
      (and
        (mission_profile_has_confirmation ?mission_profile ?confirmation_token)
        (not
          (confirmation_token_available ?confirmation_token)
        )
      )
  )
  (:action release_confirmation_token_from_mission_profile
    :parameters (?mission_profile - mission_profile ?confirmation_token - confirmation_token)
    :precondition
      (and
        (mission_profile_has_confirmation ?mission_profile ?confirmation_token)
      )
    :effect
      (and
        (confirmation_token_available ?confirmation_token)
        (not
          (mission_profile_has_confirmation ?mission_profile ?confirmation_token)
        )
      )
  )
  (:action prime_branch_marker
    :parameters (?mission_branch - mission_branch ?branch_marker - branch_marker ?player_choice_token - player_choice_token)
    :precondition
      (and
        (entity_active ?mission_branch)
        (entity_bound_choice_token ?mission_branch ?player_choice_token)
        (mission_branch_has_marker ?mission_branch ?branch_marker)
        (not
          (branch_marker_primed ?branch_marker)
        )
        (not
          (branch_marker_allocated ?branch_marker)
        )
      )
    :effect (branch_marker_primed ?branch_marker)
  )
  (:action resolve_branch_with_modifier
    :parameters (?mission_branch - mission_branch ?branch_marker - branch_marker ?modifier_token - modifier_token)
    :precondition
      (and
        (entity_active ?mission_branch)
        (mission_profile_has_modifier ?mission_branch ?modifier_token)
        (mission_branch_has_marker ?mission_branch ?branch_marker)
        (branch_marker_primed ?branch_marker)
        (not
          (mission_branch_ready ?mission_branch)
        )
      )
    :effect
      (and
        (mission_branch_ready ?mission_branch)
        (mission_branch_resolved ?mission_branch)
      )
  )
  (:action apply_consumable_to_branch_marker
    :parameters (?mission_branch - mission_branch ?branch_marker - branch_marker ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_active ?mission_branch)
        (mission_branch_has_marker ?mission_branch ?branch_marker)
        (consumable_resource_available ?consumable_resource)
        (not
          (mission_branch_ready ?mission_branch)
        )
      )
    :effect
      (and
        (branch_marker_allocated ?branch_marker)
        (mission_branch_ready ?mission_branch)
        (mission_branch_allocated_resource ?mission_branch ?consumable_resource)
        (not
          (consumable_resource_available ?consumable_resource)
        )
      )
  )
  (:action finalize_branch_marker_allocation
    :parameters (?mission_branch - mission_branch ?branch_marker - branch_marker ?player_choice_token - player_choice_token ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_active ?mission_branch)
        (entity_bound_choice_token ?mission_branch ?player_choice_token)
        (mission_branch_has_marker ?mission_branch ?branch_marker)
        (branch_marker_allocated ?branch_marker)
        (mission_branch_allocated_resource ?mission_branch ?consumable_resource)
        (not
          (mission_branch_resolved ?mission_branch)
        )
      )
    :effect
      (and
        (branch_marker_primed ?branch_marker)
        (mission_branch_resolved ?mission_branch)
        (consumable_resource_available ?consumable_resource)
        (not
          (mission_branch_allocated_resource ?mission_branch ?consumable_resource)
        )
      )
  )
  (:action prime_variant_marker
    :parameters (?mission_variant - mission_variant ?variant_marker - variant_marker ?player_choice_token - player_choice_token)
    :precondition
      (and
        (entity_active ?mission_variant)
        (entity_bound_choice_token ?mission_variant ?player_choice_token)
        (mission_variant_has_marker ?mission_variant ?variant_marker)
        (not
          (variant_marker_primed ?variant_marker)
        )
        (not
          (variant_marker_allocated ?variant_marker)
        )
      )
    :effect (variant_marker_primed ?variant_marker)
  )
  (:action resolve_variant_with_modifier
    :parameters (?mission_variant - mission_variant ?variant_marker - variant_marker ?modifier_token - modifier_token)
    :precondition
      (and
        (entity_active ?mission_variant)
        (mission_profile_has_modifier ?mission_variant ?modifier_token)
        (mission_variant_has_marker ?mission_variant ?variant_marker)
        (variant_marker_primed ?variant_marker)
        (not
          (mission_variant_ready ?mission_variant)
        )
      )
    :effect
      (and
        (mission_variant_ready ?mission_variant)
        (mission_variant_resolved ?mission_variant)
      )
  )
  (:action apply_consumable_to_variant_marker
    :parameters (?mission_variant - mission_variant ?variant_marker - variant_marker ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_active ?mission_variant)
        (mission_variant_has_marker ?mission_variant ?variant_marker)
        (consumable_resource_available ?consumable_resource)
        (not
          (mission_variant_ready ?mission_variant)
        )
      )
    :effect
      (and
        (variant_marker_allocated ?variant_marker)
        (mission_variant_ready ?mission_variant)
        (mission_variant_allocated_resource ?mission_variant ?consumable_resource)
        (not
          (consumable_resource_available ?consumable_resource)
        )
      )
  )
  (:action finalize_variant_marker_allocation
    :parameters (?mission_variant - mission_variant ?variant_marker - variant_marker ?player_choice_token - player_choice_token ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_active ?mission_variant)
        (entity_bound_choice_token ?mission_variant ?player_choice_token)
        (mission_variant_has_marker ?mission_variant ?variant_marker)
        (variant_marker_allocated ?variant_marker)
        (mission_variant_allocated_resource ?mission_variant ?consumable_resource)
        (not
          (mission_variant_resolved ?mission_variant)
        )
      )
    :effect
      (and
        (variant_marker_primed ?variant_marker)
        (mission_variant_resolved ?mission_variant)
        (consumable_resource_available ?consumable_resource)
        (not
          (mission_variant_allocated_resource ?mission_variant ?consumable_resource)
        )
      )
  )
  (:action authorize_constructed_reward
    :parameters (?mission_branch - mission_branch ?mission_variant - mission_variant ?branch_marker - branch_marker ?variant_marker - variant_marker ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_branch_ready ?mission_branch)
        (mission_variant_ready ?mission_variant)
        (mission_branch_has_marker ?mission_branch ?branch_marker)
        (mission_variant_has_marker ?mission_variant ?variant_marker)
        (branch_marker_primed ?branch_marker)
        (variant_marker_primed ?variant_marker)
        (mission_branch_resolved ?mission_branch)
        (mission_variant_resolved ?mission_variant)
        (constructed_reward_uninitialized ?constructed_reward)
      )
    :effect
      (and
        (constructed_reward_created ?constructed_reward)
        (constructed_reward_has_branch_marker ?constructed_reward ?branch_marker)
        (constructed_reward_has_variant_marker ?constructed_reward ?variant_marker)
        (not
          (constructed_reward_uninitialized ?constructed_reward)
        )
      )
  )
  (:action authorize_constructed_reward_with_branch_bonus
    :parameters (?mission_branch - mission_branch ?mission_variant - mission_variant ?branch_marker - branch_marker ?variant_marker - variant_marker ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_branch_ready ?mission_branch)
        (mission_variant_ready ?mission_variant)
        (mission_branch_has_marker ?mission_branch ?branch_marker)
        (mission_variant_has_marker ?mission_variant ?variant_marker)
        (branch_marker_allocated ?branch_marker)
        (variant_marker_primed ?variant_marker)
        (not
          (mission_branch_resolved ?mission_branch)
        )
        (mission_variant_resolved ?mission_variant)
        (constructed_reward_uninitialized ?constructed_reward)
      )
    :effect
      (and
        (constructed_reward_created ?constructed_reward)
        (constructed_reward_has_branch_marker ?constructed_reward ?branch_marker)
        (constructed_reward_has_variant_marker ?constructed_reward ?variant_marker)
        (constructed_reward_branch_flag ?constructed_reward)
        (not
          (constructed_reward_uninitialized ?constructed_reward)
        )
      )
  )
  (:action authorize_constructed_reward_with_variant_bonus
    :parameters (?mission_branch - mission_branch ?mission_variant - mission_variant ?branch_marker - branch_marker ?variant_marker - variant_marker ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_branch_ready ?mission_branch)
        (mission_variant_ready ?mission_variant)
        (mission_branch_has_marker ?mission_branch ?branch_marker)
        (mission_variant_has_marker ?mission_variant ?variant_marker)
        (branch_marker_primed ?branch_marker)
        (variant_marker_allocated ?variant_marker)
        (mission_branch_resolved ?mission_branch)
        (not
          (mission_variant_resolved ?mission_variant)
        )
        (constructed_reward_uninitialized ?constructed_reward)
      )
    :effect
      (and
        (constructed_reward_created ?constructed_reward)
        (constructed_reward_has_branch_marker ?constructed_reward ?branch_marker)
        (constructed_reward_has_variant_marker ?constructed_reward ?variant_marker)
        (constructed_reward_variant_flag ?constructed_reward)
        (not
          (constructed_reward_uninitialized ?constructed_reward)
        )
      )
  )
  (:action authorize_constructed_reward_with_branch_and_variant_bonus
    :parameters (?mission_branch - mission_branch ?mission_variant - mission_variant ?branch_marker - branch_marker ?variant_marker - variant_marker ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_branch_ready ?mission_branch)
        (mission_variant_ready ?mission_variant)
        (mission_branch_has_marker ?mission_branch ?branch_marker)
        (mission_variant_has_marker ?mission_variant ?variant_marker)
        (branch_marker_allocated ?branch_marker)
        (variant_marker_allocated ?variant_marker)
        (not
          (mission_branch_resolved ?mission_branch)
        )
        (not
          (mission_variant_resolved ?mission_variant)
        )
        (constructed_reward_uninitialized ?constructed_reward)
      )
    :effect
      (and
        (constructed_reward_created ?constructed_reward)
        (constructed_reward_has_branch_marker ?constructed_reward ?branch_marker)
        (constructed_reward_has_variant_marker ?constructed_reward ?variant_marker)
        (constructed_reward_branch_flag ?constructed_reward)
        (constructed_reward_variant_flag ?constructed_reward)
        (not
          (constructed_reward_uninitialized ?constructed_reward)
        )
      )
  )
  (:action mature_constructed_reward
    :parameters (?constructed_reward - constructed_reward ?mission_branch - mission_branch ?player_choice_token - player_choice_token)
    :precondition
      (and
        (constructed_reward_created ?constructed_reward)
        (mission_branch_ready ?mission_branch)
        (entity_bound_choice_token ?mission_branch ?player_choice_token)
        (not
          (constructed_reward_matured ?constructed_reward)
        )
      )
    :effect (constructed_reward_matured ?constructed_reward)
  )
  (:action populate_resource_slot_for_constructed_reward
    :parameters (?mission_profile - mission_profile ?resource_slot - resource_slot ?constructed_reward - constructed_reward)
    :precondition
      (and
        (entity_active ?mission_profile)
        (mission_profile_links_constructed_reward ?mission_profile ?constructed_reward)
        (mission_profile_has_resource_slot ?mission_profile ?resource_slot)
        (resource_slot_available ?resource_slot)
        (constructed_reward_created ?constructed_reward)
        (constructed_reward_matured ?constructed_reward)
        (not
          (resource_slot_filled ?resource_slot)
        )
      )
    :effect
      (and
        (resource_slot_filled ?resource_slot)
        (resource_slot_attached_to_reward ?resource_slot ?constructed_reward)
        (not
          (resource_slot_available ?resource_slot)
        )
      )
  )
  (:action complete_profile_attachment_stage1
    :parameters (?mission_profile - mission_profile ?resource_slot - resource_slot ?constructed_reward - constructed_reward ?player_choice_token - player_choice_token)
    :precondition
      (and
        (entity_active ?mission_profile)
        (mission_profile_has_resource_slot ?mission_profile ?resource_slot)
        (resource_slot_filled ?resource_slot)
        (resource_slot_attached_to_reward ?resource_slot ?constructed_reward)
        (entity_bound_choice_token ?mission_profile ?player_choice_token)
        (not
          (constructed_reward_branch_flag ?constructed_reward)
        )
        (not
          (mission_profile_attachment_stage1 ?mission_profile)
        )
      )
    :effect (mission_profile_attachment_stage1 ?mission_profile)
  )
  (:action attach_feature_tag_to_mission_profile
    :parameters (?mission_profile - mission_profile ?feature_tag - feature_tag)
    :precondition
      (and
        (entity_active ?mission_profile)
        (feature_tag_available ?feature_tag)
        (not
          (mission_profile_feature_attached ?mission_profile)
        )
      )
    :effect
      (and
        (mission_profile_feature_attached ?mission_profile)
        (mission_profile_has_feature ?mission_profile ?feature_tag)
        (not
          (feature_tag_available ?feature_tag)
        )
      )
  )
  (:action advance_feature_attachment_chain_on_profile
    :parameters (?mission_profile - mission_profile ?resource_slot - resource_slot ?constructed_reward - constructed_reward ?player_choice_token - player_choice_token ?feature_tag - feature_tag)
    :precondition
      (and
        (entity_active ?mission_profile)
        (mission_profile_has_resource_slot ?mission_profile ?resource_slot)
        (resource_slot_filled ?resource_slot)
        (resource_slot_attached_to_reward ?resource_slot ?constructed_reward)
        (entity_bound_choice_token ?mission_profile ?player_choice_token)
        (constructed_reward_branch_flag ?constructed_reward)
        (mission_profile_feature_attached ?mission_profile)
        (mission_profile_has_feature ?mission_profile ?feature_tag)
        (not
          (mission_profile_attachment_stage1 ?mission_profile)
        )
      )
    :effect
      (and
        (mission_profile_attachment_stage1 ?mission_profile)
        (mission_profile_feature_path_ready ?mission_profile)
      )
  )
  (:action advance_profile_attachment_chain_stage2
    :parameters (?mission_profile - mission_profile ?attachment_token - attachment_token ?modifier_token - modifier_token ?resource_slot - resource_slot ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_profile_attachment_stage1 ?mission_profile)
        (mission_profile_has_attachment ?mission_profile ?attachment_token)
        (mission_profile_has_modifier ?mission_profile ?modifier_token)
        (mission_profile_has_resource_slot ?mission_profile ?resource_slot)
        (resource_slot_attached_to_reward ?resource_slot ?constructed_reward)
        (not
          (constructed_reward_variant_flag ?constructed_reward)
        )
        (not
          (mission_profile_attachment_stage2 ?mission_profile)
        )
      )
    :effect (mission_profile_attachment_stage2 ?mission_profile)
  )
  (:action alternate_advance_profile_attachment_chain_stage2
    :parameters (?mission_profile - mission_profile ?attachment_token - attachment_token ?modifier_token - modifier_token ?resource_slot - resource_slot ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_profile_attachment_stage1 ?mission_profile)
        (mission_profile_has_attachment ?mission_profile ?attachment_token)
        (mission_profile_has_modifier ?mission_profile ?modifier_token)
        (mission_profile_has_resource_slot ?mission_profile ?resource_slot)
        (resource_slot_attached_to_reward ?resource_slot ?constructed_reward)
        (constructed_reward_variant_flag ?constructed_reward)
        (not
          (mission_profile_attachment_stage2 ?mission_profile)
        )
      )
    :effect (mission_profile_attachment_stage2 ?mission_profile)
  )
  (:action start_profile_attachment_stage3
    :parameters (?mission_profile - mission_profile ?confirmation_token - confirmation_token ?resource_slot - resource_slot ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_profile_attachment_stage2 ?mission_profile)
        (mission_profile_has_confirmation ?mission_profile ?confirmation_token)
        (mission_profile_has_resource_slot ?mission_profile ?resource_slot)
        (resource_slot_attached_to_reward ?resource_slot ?constructed_reward)
        (not
          (constructed_reward_branch_flag ?constructed_reward)
        )
        (not
          (constructed_reward_variant_flag ?constructed_reward)
        )
        (not
          (mission_profile_attachment_stage3 ?mission_profile)
        )
      )
    :effect (mission_profile_attachment_stage3 ?mission_profile)
  )
  (:action finalize_profile_attachment_stage3_with_upgrade
    :parameters (?mission_profile - mission_profile ?confirmation_token - confirmation_token ?resource_slot - resource_slot ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_profile_attachment_stage2 ?mission_profile)
        (mission_profile_has_confirmation ?mission_profile ?confirmation_token)
        (mission_profile_has_resource_slot ?mission_profile ?resource_slot)
        (resource_slot_attached_to_reward ?resource_slot ?constructed_reward)
        (constructed_reward_branch_flag ?constructed_reward)
        (not
          (constructed_reward_variant_flag ?constructed_reward)
        )
        (not
          (mission_profile_attachment_stage3 ?mission_profile)
        )
      )
    :effect
      (and
        (mission_profile_attachment_stage3 ?mission_profile)
        (mission_profile_ready_for_upgrade ?mission_profile)
      )
  )
  (:action finalize_profile_attachment_stage3_alternative
    :parameters (?mission_profile - mission_profile ?confirmation_token - confirmation_token ?resource_slot - resource_slot ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_profile_attachment_stage2 ?mission_profile)
        (mission_profile_has_confirmation ?mission_profile ?confirmation_token)
        (mission_profile_has_resource_slot ?mission_profile ?resource_slot)
        (resource_slot_attached_to_reward ?resource_slot ?constructed_reward)
        (not
          (constructed_reward_branch_flag ?constructed_reward)
        )
        (constructed_reward_variant_flag ?constructed_reward)
        (not
          (mission_profile_attachment_stage3 ?mission_profile)
        )
      )
    :effect
      (and
        (mission_profile_attachment_stage3 ?mission_profile)
        (mission_profile_ready_for_upgrade ?mission_profile)
      )
  )
  (:action finalize_profile_attachment_stage3_combined
    :parameters (?mission_profile - mission_profile ?confirmation_token - confirmation_token ?resource_slot - resource_slot ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_profile_attachment_stage2 ?mission_profile)
        (mission_profile_has_confirmation ?mission_profile ?confirmation_token)
        (mission_profile_has_resource_slot ?mission_profile ?resource_slot)
        (resource_slot_attached_to_reward ?resource_slot ?constructed_reward)
        (constructed_reward_branch_flag ?constructed_reward)
        (constructed_reward_variant_flag ?constructed_reward)
        (not
          (mission_profile_attachment_stage3 ?mission_profile)
        )
      )
    :effect
      (and
        (mission_profile_attachment_stage3 ?mission_profile)
        (mission_profile_ready_for_upgrade ?mission_profile)
      )
  )
  (:action finalize_mission_profile
    :parameters (?mission_profile - mission_profile)
    :precondition
      (and
        (mission_profile_attachment_stage3 ?mission_profile)
        (not
          (mission_profile_ready_for_upgrade ?mission_profile)
        )
        (not
          (mission_profile_finalized ?mission_profile)
        )
      )
    :effect
      (and
        (mission_profile_finalized ?mission_profile)
        (entity_claimable ?mission_profile)
      )
  )
  (:action attach_upgrade_to_mission_profile
    :parameters (?mission_profile - mission_profile ?upgrade_token - upgrade_token)
    :precondition
      (and
        (mission_profile_attachment_stage3 ?mission_profile)
        (mission_profile_ready_for_upgrade ?mission_profile)
        (upgrade_token_available ?upgrade_token)
      )
    :effect
      (and
        (mission_profile_has_upgrade ?mission_profile ?upgrade_token)
        (not
          (upgrade_token_available ?upgrade_token)
        )
      )
  )
  (:action validate_mission_profile_prerequisites
    :parameters (?mission_profile - mission_profile ?mission_branch - mission_branch ?mission_variant - mission_variant ?player_choice_token - player_choice_token ?upgrade_token - upgrade_token)
    :precondition
      (and
        (mission_profile_attachment_stage3 ?mission_profile)
        (mission_profile_ready_for_upgrade ?mission_profile)
        (mission_profile_has_upgrade ?mission_profile ?upgrade_token)
        (mission_profile_links_branch ?mission_profile ?mission_branch)
        (mission_profile_links_variant ?mission_profile ?mission_variant)
        (mission_branch_resolved ?mission_branch)
        (mission_variant_resolved ?mission_variant)
        (entity_bound_choice_token ?mission_profile ?player_choice_token)
        (not
          (mission_profile_prereqs_validated ?mission_profile)
        )
      )
    :effect (mission_profile_prereqs_validated ?mission_profile)
  )
  (:action finalize_validated_mission_profile
    :parameters (?mission_profile - mission_profile)
    :precondition
      (and
        (mission_profile_attachment_stage3 ?mission_profile)
        (mission_profile_prereqs_validated ?mission_profile)
        (not
          (mission_profile_finalized ?mission_profile)
        )
      )
    :effect
      (and
        (mission_profile_finalized ?mission_profile)
        (entity_claimable ?mission_profile)
      )
  )
  (:action start_special_trait_attachment
    :parameters (?mission_profile - mission_profile ?trait_token - trait_token ?player_choice_token - player_choice_token)
    :precondition
      (and
        (entity_active ?mission_profile)
        (entity_bound_choice_token ?mission_profile ?player_choice_token)
        (trait_token_available ?trait_token)
        (mission_profile_has_trait ?mission_profile ?trait_token)
        (not
          (mission_profile_trait_attached ?mission_profile)
        )
      )
    :effect
      (and
        (mission_profile_trait_attached ?mission_profile)
        (not
          (trait_token_available ?trait_token)
        )
      )
  )
  (:action apply_trait_attachment
    :parameters (?mission_profile - mission_profile ?modifier_token - modifier_token)
    :precondition
      (and
        (mission_profile_trait_attached ?mission_profile)
        (mission_profile_has_modifier ?mission_profile ?modifier_token)
        (not
          (mission_profile_trait_step2 ?mission_profile)
        )
      )
    :effect (mission_profile_trait_step2 ?mission_profile)
  )
  (:action confirm_trait_attachment
    :parameters (?mission_profile - mission_profile ?confirmation_token - confirmation_token)
    :precondition
      (and
        (mission_profile_trait_step2 ?mission_profile)
        (mission_profile_has_confirmation ?mission_profile ?confirmation_token)
        (not
          (mission_profile_trait_confirmed ?mission_profile)
        )
      )
    :effect (mission_profile_trait_confirmed ?mission_profile)
  )
  (:action finalize_trait_attachment_profile
    :parameters (?mission_profile - mission_profile)
    :precondition
      (and
        (mission_profile_trait_confirmed ?mission_profile)
        (not
          (mission_profile_finalized ?mission_profile)
        )
      )
    :effect
      (and
        (mission_profile_finalized ?mission_profile)
        (entity_claimable ?mission_profile)
      )
  )
  (:action claim_constructed_reward_for_branch
    :parameters (?mission_branch - mission_branch ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_branch_ready ?mission_branch)
        (mission_branch_resolved ?mission_branch)
        (constructed_reward_created ?constructed_reward)
        (constructed_reward_matured ?constructed_reward)
        (not
          (entity_claimable ?mission_branch)
        )
      )
    :effect (entity_claimable ?mission_branch)
  )
  (:action claim_constructed_reward_for_variant
    :parameters (?mission_variant - mission_variant ?constructed_reward - constructed_reward)
    :precondition
      (and
        (mission_variant_ready ?mission_variant)
        (mission_variant_resolved ?mission_variant)
        (constructed_reward_created ?constructed_reward)
        (constructed_reward_matured ?constructed_reward)
        (not
          (entity_claimable ?mission_variant)
        )
      )
    :effect (entity_claimable ?mission_variant)
  )
  (:action confirm_claim_and_apply_progression_marker
    :parameters (?mission - mission ?progression_marker - progression_marker ?player_choice_token - player_choice_token)
    :precondition
      (and
        (entity_claimable ?mission)
        (entity_bound_choice_token ?mission ?player_choice_token)
        (progression_marker_available ?progression_marker)
        (not
          (entity_confirmed ?mission)
        )
      )
    :effect
      (and
        (entity_confirmed ?mission)
        (mission_has_progression_marker ?mission ?progression_marker)
        (not
          (progression_marker_available ?progression_marker)
        )
      )
  )
  (:action complete_mission_branch
    :parameters (?mission_branch - mission_branch ?reward_option - reward_option ?progression_marker - progression_marker)
    :precondition
      (and
        (entity_confirmed ?mission_branch)
        (entity_reward_assigned ?mission_branch ?reward_option)
        (mission_has_progression_marker ?mission_branch ?progression_marker)
        (not
          (entity_completed ?mission_branch)
        )
      )
    :effect
      (and
        (entity_completed ?mission_branch)
        (reward_option_available ?reward_option)
        (progression_marker_available ?progression_marker)
      )
  )
  (:action complete_mission_variant
    :parameters (?mission_variant - mission_variant ?reward_option - reward_option ?progression_marker - progression_marker)
    :precondition
      (and
        (entity_confirmed ?mission_variant)
        (entity_reward_assigned ?mission_variant ?reward_option)
        (mission_has_progression_marker ?mission_variant ?progression_marker)
        (not
          (entity_completed ?mission_variant)
        )
      )
    :effect
      (and
        (entity_completed ?mission_variant)
        (reward_option_available ?reward_option)
        (progression_marker_available ?progression_marker)
      )
  )
  (:action complete_mission_profile
    :parameters (?mission_profile - mission_profile ?reward_option - reward_option ?progression_marker - progression_marker)
    :precondition
      (and
        (entity_confirmed ?mission_profile)
        (entity_reward_assigned ?mission_profile ?reward_option)
        (mission_has_progression_marker ?mission_profile ?progression_marker)
        (not
          (entity_completed ?mission_profile)
        )
      )
    :effect
      (and
        (entity_completed ?mission_profile)
        (reward_option_available ?reward_option)
        (progression_marker_available ?progression_marker)
      )
  )
)

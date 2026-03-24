(define (domain faction_reputation_gate_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object gameplay_asset - entity supply_asset - entity region_asset - entity domain_root - entity progress_node - domain_root contribution_token - gameplay_asset consumable_resource - gameplay_asset npc_contact - gameplay_asset policy_module - gameplay_asset certification_badge - gameplay_asset reputation_badge - gameplay_asset limited_offer - gameplay_asset key_resource - gameplay_asset commodity_item - supply_asset blueprint_document - supply_asset quest_chip - supply_asset region_flag_a - region_asset region_flag_b - region_asset gate_mechanism - region_asset node_group_a - progress_node node_group_b - progress_node outpost_node - node_group_a squad_node - node_group_a faction_branch - node_group_b)

  (:predicates
    (node_registered ?progress_node - progress_node)
    (node_prepared ?progress_node - progress_node)
    (node_token_present ?progress_node - progress_node)
    (node_advanced ?progress_node - progress_node)
    (milestone_awarded ?progress_node - progress_node)
    (reputation_committed ?progress_node - progress_node)
    (token_available ?contribution_token - contribution_token)
    (node_token_assigned ?progress_node - progress_node ?contribution_token - contribution_token)
    (resource_available ?consumable_resource - consumable_resource)
    (node_resource_assigned ?progress_node - progress_node ?consumable_resource - consumable_resource)
    (npc_available ?npc_contact - npc_contact)
    (node_npc_assigned ?progress_node - progress_node ?npc_contact - npc_contact)
    (commodity_available ?commodity_item - commodity_item)
    (outpost_commodity_assigned ?outpost - outpost_node ?commodity_item - commodity_item)
    (squad_commodity_assigned ?squad - squad_node ?commodity_item - commodity_item)
    (outpost_flag_a_link ?outpost - outpost_node ?region_flag_a - region_flag_a)
    (region_flag_a_set ?region_flag_a - region_flag_a)
    (region_flag_a_staged ?region_flag_a - region_flag_a)
    (outpost_contribution_confirmed ?outpost - outpost_node)
    (squad_flag_b_link ?squad - squad_node ?region_flag_b - region_flag_b)
    (region_flag_b_set ?region_flag_b - region_flag_b)
    (region_flag_b_staged ?region_flag_b - region_flag_b)
    (squad_contribution_confirmed ?squad - squad_node)
    (gate_registered ?gate - gate_mechanism)
    (gate_activation_started ?gate - gate_mechanism)
    (gate_linked_flag_a ?gate - gate_mechanism ?region_flag_a - region_flag_a)
    (gate_linked_flag_b ?gate - gate_mechanism ?region_flag_b - region_flag_b)
    (gate_variant_a ?gate - gate_mechanism)
    (gate_variant_b ?gate - gate_mechanism)
    (gate_ready ?gate - gate_mechanism)
    (branch_has_outpost ?faction_branch - faction_branch ?outpost - outpost_node)
    (branch_has_squad ?faction_branch - faction_branch ?squad - squad_node)
    (branch_gate_link ?faction_branch - faction_branch ?gate - gate_mechanism)
    (blueprint_available ?blueprint - blueprint_document)
    (branch_blueprint_attached ?faction_branch - faction_branch ?blueprint - blueprint_document)
    (blueprint_used ?blueprint - blueprint_document)
    (blueprint_installed_on_gate ?blueprint - blueprint_document ?gate - gate_mechanism)
    (branch_integration_ready ?faction_branch - faction_branch)
    (branch_staged_verification ?faction_branch - faction_branch)
    (branch_core_verified ?faction_branch - faction_branch)
    (policy_consumed ?faction_branch - faction_branch)
    (branch_policy_variant_enabled ?faction_branch - faction_branch)
    (branch_policy_variant_applied ?faction_branch - faction_branch)
    (branch_reward_committed ?faction_branch - faction_branch)
    (quest_chip_available ?quest_chip - quest_chip)
    (branch_quest_chip_attached ?faction_branch - faction_branch ?quest_chip - quest_chip)
    (branch_quest_chip_engaged ?faction_branch - faction_branch)
    (branch_quest_chip_staged ?faction_branch - faction_branch)
    (branch_quest_chip_finalized ?faction_branch - faction_branch)
    (policy_module_available ?policy_module - policy_module)
    (branch_policy_assigned ?faction_branch - faction_branch ?policy_module - policy_module)
    (certification_badge_available ?certification_badge - certification_badge)
    (branch_certification_assigned ?faction_branch - faction_branch ?certification_badge - certification_badge)
    (limited_offer_available ?limited_offer - limited_offer)
    (branch_limited_offer_assigned ?faction_branch - faction_branch ?limited_offer - limited_offer)
    (key_resource_available ?key_resource - key_resource)
    (branch_key_assigned ?faction_branch - faction_branch ?key_resource - key_resource)
    (reputation_badge_available ?reputation_badge - reputation_badge)
    (node_reputation_link ?progress_node - progress_node ?reputation_badge - reputation_badge)
    (outpost_stage_marked ?outpost - outpost_node)
    (squad_stage_marked ?squad - squad_node)
    (branch_milestone_finalized ?faction_branch - faction_branch)
  )
  (:action register_progress_node
    :parameters (?progress_node - progress_node)
    :precondition
      (and
        (not
          (node_registered ?progress_node)
        )
        (not
          (node_advanced ?progress_node)
        )
      )
    :effect (node_registered ?progress_node)
  )
  (:action assign_token_to_node
    :parameters (?progress_node - progress_node ?contribution_token - contribution_token)
    :precondition
      (and
        (node_registered ?progress_node)
        (not
          (node_token_present ?progress_node)
        )
        (token_available ?contribution_token)
      )
    :effect
      (and
        (node_token_present ?progress_node)
        (node_token_assigned ?progress_node ?contribution_token)
        (not
          (token_available ?contribution_token)
        )
      )
  )
  (:action attach_resource_to_node
    :parameters (?progress_node - progress_node ?consumable_resource - consumable_resource)
    :precondition
      (and
        (node_registered ?progress_node)
        (node_token_present ?progress_node)
        (resource_available ?consumable_resource)
      )
    :effect
      (and
        (node_resource_assigned ?progress_node ?consumable_resource)
        (not
          (resource_available ?consumable_resource)
        )
      )
  )
  (:action mark_node_prepared
    :parameters (?progress_node - progress_node ?consumable_resource - consumable_resource)
    :precondition
      (and
        (node_registered ?progress_node)
        (node_token_present ?progress_node)
        (node_resource_assigned ?progress_node ?consumable_resource)
        (not
          (node_prepared ?progress_node)
        )
      )
    :effect (node_prepared ?progress_node)
  )
  (:action release_resource_from_node
    :parameters (?progress_node - progress_node ?consumable_resource - consumable_resource)
    :precondition
      (and
        (node_resource_assigned ?progress_node ?consumable_resource)
      )
    :effect
      (and
        (resource_available ?consumable_resource)
        (not
          (node_resource_assigned ?progress_node ?consumable_resource)
        )
      )
  )
  (:action assign_npc_to_node
    :parameters (?progress_node - progress_node ?npc_contact - npc_contact)
    :precondition
      (and
        (node_prepared ?progress_node)
        (npc_available ?npc_contact)
      )
    :effect
      (and
        (node_npc_assigned ?progress_node ?npc_contact)
        (not
          (npc_available ?npc_contact)
        )
      )
  )
  (:action unassign_npc_from_node
    :parameters (?progress_node - progress_node ?npc_contact - npc_contact)
    :precondition
      (and
        (node_npc_assigned ?progress_node ?npc_contact)
      )
    :effect
      (and
        (npc_available ?npc_contact)
        (not
          (node_npc_assigned ?progress_node ?npc_contact)
        )
      )
  )
  (:action assign_limited_offer_to_branch
    :parameters (?faction_branch - faction_branch ?limited_offer - limited_offer)
    :precondition
      (and
        (node_prepared ?faction_branch)
        (limited_offer_available ?limited_offer)
      )
    :effect
      (and
        (branch_limited_offer_assigned ?faction_branch ?limited_offer)
        (not
          (limited_offer_available ?limited_offer)
        )
      )
  )
  (:action revoke_limited_offer_from_branch
    :parameters (?faction_branch - faction_branch ?limited_offer - limited_offer)
    :precondition
      (and
        (branch_limited_offer_assigned ?faction_branch ?limited_offer)
      )
    :effect
      (and
        (limited_offer_available ?limited_offer)
        (not
          (branch_limited_offer_assigned ?faction_branch ?limited_offer)
        )
      )
  )
  (:action assign_key_to_branch
    :parameters (?faction_branch - faction_branch ?key_resource - key_resource)
    :precondition
      (and
        (node_prepared ?faction_branch)
        (key_resource_available ?key_resource)
      )
    :effect
      (and
        (branch_key_assigned ?faction_branch ?key_resource)
        (not
          (key_resource_available ?key_resource)
        )
      )
  )
  (:action revoke_key_from_branch
    :parameters (?faction_branch - faction_branch ?key_resource - key_resource)
    :precondition
      (and
        (branch_key_assigned ?faction_branch ?key_resource)
      )
    :effect
      (and
        (key_resource_available ?key_resource)
        (not
          (branch_key_assigned ?faction_branch ?key_resource)
        )
      )
  )
  (:action set_flag_a_for_outpost
    :parameters (?outpost - outpost_node ?region_flag_a - region_flag_a ?consumable_resource - consumable_resource)
    :precondition
      (and
        (node_prepared ?outpost)
        (node_resource_assigned ?outpost ?consumable_resource)
        (outpost_flag_a_link ?outpost ?region_flag_a)
        (not
          (region_flag_a_set ?region_flag_a)
        )
        (not
          (region_flag_a_staged ?region_flag_a)
        )
      )
    :effect (region_flag_a_set ?region_flag_a)
  )
  (:action confirm_outpost_flag_a
    :parameters (?outpost - outpost_node ?region_flag_a - region_flag_a ?npc_contact - npc_contact)
    :precondition
      (and
        (node_prepared ?outpost)
        (node_npc_assigned ?outpost ?npc_contact)
        (outpost_flag_a_link ?outpost ?region_flag_a)
        (region_flag_a_set ?region_flag_a)
        (not
          (outpost_stage_marked ?outpost)
        )
      )
    :effect
      (and
        (outpost_stage_marked ?outpost)
        (outpost_contribution_confirmed ?outpost)
      )
  )
  (:action assign_commodity_to_outpost_flag_a
    :parameters (?outpost - outpost_node ?region_flag_a - region_flag_a ?commodity_item - commodity_item)
    :precondition
      (and
        (node_prepared ?outpost)
        (outpost_flag_a_link ?outpost ?region_flag_a)
        (commodity_available ?commodity_item)
        (not
          (outpost_stage_marked ?outpost)
        )
      )
    :effect
      (and
        (region_flag_a_staged ?region_flag_a)
        (outpost_stage_marked ?outpost)
        (outpost_commodity_assigned ?outpost ?commodity_item)
        (not
          (commodity_available ?commodity_item)
        )
      )
  )
  (:action finalize_outpost_flag_a
    :parameters (?outpost - outpost_node ?region_flag_a - region_flag_a ?consumable_resource - consumable_resource ?commodity_item - commodity_item)
    :precondition
      (and
        (node_prepared ?outpost)
        (node_resource_assigned ?outpost ?consumable_resource)
        (outpost_flag_a_link ?outpost ?region_flag_a)
        (region_flag_a_staged ?region_flag_a)
        (outpost_commodity_assigned ?outpost ?commodity_item)
        (not
          (outpost_contribution_confirmed ?outpost)
        )
      )
    :effect
      (and
        (region_flag_a_set ?region_flag_a)
        (outpost_contribution_confirmed ?outpost)
        (commodity_available ?commodity_item)
        (not
          (outpost_commodity_assigned ?outpost ?commodity_item)
        )
      )
  )
  (:action set_flag_b_for_squad
    :parameters (?squad - squad_node ?region_flag_b - region_flag_b ?consumable_resource - consumable_resource)
    :precondition
      (and
        (node_prepared ?squad)
        (node_resource_assigned ?squad ?consumable_resource)
        (squad_flag_b_link ?squad ?region_flag_b)
        (not
          (region_flag_b_set ?region_flag_b)
        )
        (not
          (region_flag_b_staged ?region_flag_b)
        )
      )
    :effect (region_flag_b_set ?region_flag_b)
  )
  (:action confirm_squad_flag_b
    :parameters (?squad - squad_node ?region_flag_b - region_flag_b ?npc_contact - npc_contact)
    :precondition
      (and
        (node_prepared ?squad)
        (node_npc_assigned ?squad ?npc_contact)
        (squad_flag_b_link ?squad ?region_flag_b)
        (region_flag_b_set ?region_flag_b)
        (not
          (squad_stage_marked ?squad)
        )
      )
    :effect
      (and
        (squad_stage_marked ?squad)
        (squad_contribution_confirmed ?squad)
      )
  )
  (:action assign_commodity_to_squad_flag_b
    :parameters (?squad - squad_node ?region_flag_b - region_flag_b ?commodity_item - commodity_item)
    :precondition
      (and
        (node_prepared ?squad)
        (squad_flag_b_link ?squad ?region_flag_b)
        (commodity_available ?commodity_item)
        (not
          (squad_stage_marked ?squad)
        )
      )
    :effect
      (and
        (region_flag_b_staged ?region_flag_b)
        (squad_stage_marked ?squad)
        (squad_commodity_assigned ?squad ?commodity_item)
        (not
          (commodity_available ?commodity_item)
        )
      )
  )
  (:action finalize_squad_flag_b
    :parameters (?squad - squad_node ?region_flag_b - region_flag_b ?consumable_resource - consumable_resource ?commodity_item - commodity_item)
    :precondition
      (and
        (node_prepared ?squad)
        (node_resource_assigned ?squad ?consumable_resource)
        (squad_flag_b_link ?squad ?region_flag_b)
        (region_flag_b_staged ?region_flag_b)
        (squad_commodity_assigned ?squad ?commodity_item)
        (not
          (squad_contribution_confirmed ?squad)
        )
      )
    :effect
      (and
        (region_flag_b_set ?region_flag_b)
        (squad_contribution_confirmed ?squad)
        (commodity_available ?commodity_item)
        (not
          (squad_commodity_assigned ?squad ?commodity_item)
        )
      )
  )
  (:action start_gate_activation_variant_1
    :parameters (?outpost - outpost_node ?squad - squad_node ?region_flag_a - region_flag_a ?region_flag_b - region_flag_b ?gate - gate_mechanism)
    :precondition
      (and
        (outpost_stage_marked ?outpost)
        (squad_stage_marked ?squad)
        (outpost_flag_a_link ?outpost ?region_flag_a)
        (squad_flag_b_link ?squad ?region_flag_b)
        (region_flag_a_set ?region_flag_a)
        (region_flag_b_set ?region_flag_b)
        (outpost_contribution_confirmed ?outpost)
        (squad_contribution_confirmed ?squad)
        (gate_registered ?gate)
      )
    :effect
      (and
        (gate_activation_started ?gate)
        (gate_linked_flag_a ?gate ?region_flag_a)
        (gate_linked_flag_b ?gate ?region_flag_b)
        (not
          (gate_registered ?gate)
        )
      )
  )
  (:action start_gate_activation_variant_2
    :parameters (?outpost - outpost_node ?squad - squad_node ?region_flag_a - region_flag_a ?region_flag_b - region_flag_b ?gate - gate_mechanism)
    :precondition
      (and
        (outpost_stage_marked ?outpost)
        (squad_stage_marked ?squad)
        (outpost_flag_a_link ?outpost ?region_flag_a)
        (squad_flag_b_link ?squad ?region_flag_b)
        (region_flag_a_staged ?region_flag_a)
        (region_flag_b_set ?region_flag_b)
        (not
          (outpost_contribution_confirmed ?outpost)
        )
        (squad_contribution_confirmed ?squad)
        (gate_registered ?gate)
      )
    :effect
      (and
        (gate_activation_started ?gate)
        (gate_linked_flag_a ?gate ?region_flag_a)
        (gate_linked_flag_b ?gate ?region_flag_b)
        (gate_variant_a ?gate)
        (not
          (gate_registered ?gate)
        )
      )
  )
  (:action start_gate_activation_variant_3
    :parameters (?outpost - outpost_node ?squad - squad_node ?region_flag_a - region_flag_a ?region_flag_b - region_flag_b ?gate - gate_mechanism)
    :precondition
      (and
        (outpost_stage_marked ?outpost)
        (squad_stage_marked ?squad)
        (outpost_flag_a_link ?outpost ?region_flag_a)
        (squad_flag_b_link ?squad ?region_flag_b)
        (region_flag_a_set ?region_flag_a)
        (region_flag_b_staged ?region_flag_b)
        (outpost_contribution_confirmed ?outpost)
        (not
          (squad_contribution_confirmed ?squad)
        )
        (gate_registered ?gate)
      )
    :effect
      (and
        (gate_activation_started ?gate)
        (gate_linked_flag_a ?gate ?region_flag_a)
        (gate_linked_flag_b ?gate ?region_flag_b)
        (gate_variant_b ?gate)
        (not
          (gate_registered ?gate)
        )
      )
  )
  (:action start_gate_activation_variant_4
    :parameters (?outpost - outpost_node ?squad - squad_node ?region_flag_a - region_flag_a ?region_flag_b - region_flag_b ?gate - gate_mechanism)
    :precondition
      (and
        (outpost_stage_marked ?outpost)
        (squad_stage_marked ?squad)
        (outpost_flag_a_link ?outpost ?region_flag_a)
        (squad_flag_b_link ?squad ?region_flag_b)
        (region_flag_a_staged ?region_flag_a)
        (region_flag_b_staged ?region_flag_b)
        (not
          (outpost_contribution_confirmed ?outpost)
        )
        (not
          (squad_contribution_confirmed ?squad)
        )
        (gate_registered ?gate)
      )
    :effect
      (and
        (gate_activation_started ?gate)
        (gate_linked_flag_a ?gate ?region_flag_a)
        (gate_linked_flag_b ?gate ?region_flag_b)
        (gate_variant_a ?gate)
        (gate_variant_b ?gate)
        (not
          (gate_registered ?gate)
        )
      )
  )
  (:action finalize_gate_readiness
    :parameters (?gate - gate_mechanism ?outpost - outpost_node ?consumable_resource - consumable_resource)
    :precondition
      (and
        (gate_activation_started ?gate)
        (outpost_stage_marked ?outpost)
        (node_resource_assigned ?outpost ?consumable_resource)
        (not
          (gate_ready ?gate)
        )
      )
    :effect (gate_ready ?gate)
  )
  (:action install_blueprint_on_gate
    :parameters (?faction_branch - faction_branch ?blueprint - blueprint_document ?gate - gate_mechanism)
    :precondition
      (and
        (node_prepared ?faction_branch)
        (branch_gate_link ?faction_branch ?gate)
        (branch_blueprint_attached ?faction_branch ?blueprint)
        (blueprint_available ?blueprint)
        (gate_activation_started ?gate)
        (gate_ready ?gate)
        (not
          (blueprint_used ?blueprint)
        )
      )
    :effect
      (and
        (blueprint_used ?blueprint)
        (blueprint_installed_on_gate ?blueprint ?gate)
        (not
          (blueprint_available ?blueprint)
        )
      )
  )
  (:action complete_blueprint_integration
    :parameters (?faction_branch - faction_branch ?blueprint - blueprint_document ?gate - gate_mechanism ?consumable_resource - consumable_resource)
    :precondition
      (and
        (node_prepared ?faction_branch)
        (branch_blueprint_attached ?faction_branch ?blueprint)
        (blueprint_used ?blueprint)
        (blueprint_installed_on_gate ?blueprint ?gate)
        (node_resource_assigned ?faction_branch ?consumable_resource)
        (not
          (gate_variant_a ?gate)
        )
        (not
          (branch_integration_ready ?faction_branch)
        )
      )
    :effect (branch_integration_ready ?faction_branch)
  )
  (:action apply_policy_module_to_branch
    :parameters (?faction_branch - faction_branch ?policy_module - policy_module)
    :precondition
      (and
        (node_prepared ?faction_branch)
        (policy_module_available ?policy_module)
        (not
          (policy_consumed ?faction_branch)
        )
      )
    :effect
      (and
        (policy_consumed ?faction_branch)
        (branch_policy_assigned ?faction_branch ?policy_module)
        (not
          (policy_module_available ?policy_module)
        )
      )
  )
  (:action apply_policy_and_enable_branch_variant
    :parameters (?faction_branch - faction_branch ?blueprint - blueprint_document ?gate - gate_mechanism ?consumable_resource - consumable_resource ?policy_module - policy_module)
    :precondition
      (and
        (node_prepared ?faction_branch)
        (branch_blueprint_attached ?faction_branch ?blueprint)
        (blueprint_used ?blueprint)
        (blueprint_installed_on_gate ?blueprint ?gate)
        (node_resource_assigned ?faction_branch ?consumable_resource)
        (gate_variant_a ?gate)
        (policy_consumed ?faction_branch)
        (branch_policy_assigned ?faction_branch ?policy_module)
        (not
          (branch_integration_ready ?faction_branch)
        )
      )
    :effect
      (and
        (branch_integration_ready ?faction_branch)
        (branch_policy_variant_enabled ?faction_branch)
      )
  )
  (:action verify_branch_offers_stage1
    :parameters (?faction_branch - faction_branch ?limited_offer - limited_offer ?npc_contact - npc_contact ?blueprint - blueprint_document ?gate - gate_mechanism)
    :precondition
      (and
        (branch_integration_ready ?faction_branch)
        (branch_limited_offer_assigned ?faction_branch ?limited_offer)
        (node_npc_assigned ?faction_branch ?npc_contact)
        (branch_blueprint_attached ?faction_branch ?blueprint)
        (blueprint_installed_on_gate ?blueprint ?gate)
        (not
          (gate_variant_b ?gate)
        )
        (not
          (branch_staged_verification ?faction_branch)
        )
      )
    :effect (branch_staged_verification ?faction_branch)
  )
  (:action verify_branch_offers_stage2
    :parameters (?faction_branch - faction_branch ?limited_offer - limited_offer ?npc_contact - npc_contact ?blueprint - blueprint_document ?gate - gate_mechanism)
    :precondition
      (and
        (branch_integration_ready ?faction_branch)
        (branch_limited_offer_assigned ?faction_branch ?limited_offer)
        (node_npc_assigned ?faction_branch ?npc_contact)
        (branch_blueprint_attached ?faction_branch ?blueprint)
        (blueprint_installed_on_gate ?blueprint ?gate)
        (gate_variant_b ?gate)
        (not
          (branch_staged_verification ?faction_branch)
        )
      )
    :effect (branch_staged_verification ?faction_branch)
  )
  (:action finalize_branch_key_verification
    :parameters (?faction_branch - faction_branch ?key_resource - key_resource ?blueprint - blueprint_document ?gate - gate_mechanism)
    :precondition
      (and
        (branch_staged_verification ?faction_branch)
        (branch_key_assigned ?faction_branch ?key_resource)
        (branch_blueprint_attached ?faction_branch ?blueprint)
        (blueprint_installed_on_gate ?blueprint ?gate)
        (not
          (gate_variant_a ?gate)
        )
        (not
          (gate_variant_b ?gate)
        )
        (not
          (branch_core_verified ?faction_branch)
        )
      )
    :effect (branch_core_verified ?faction_branch)
  )
  (:action finalize_branch_key_verification_with_variant_a
    :parameters (?faction_branch - faction_branch ?key_resource - key_resource ?blueprint - blueprint_document ?gate - gate_mechanism)
    :precondition
      (and
        (branch_staged_verification ?faction_branch)
        (branch_key_assigned ?faction_branch ?key_resource)
        (branch_blueprint_attached ?faction_branch ?blueprint)
        (blueprint_installed_on_gate ?blueprint ?gate)
        (gate_variant_a ?gate)
        (not
          (gate_variant_b ?gate)
        )
        (not
          (branch_core_verified ?faction_branch)
        )
      )
    :effect
      (and
        (branch_core_verified ?faction_branch)
        (branch_policy_variant_applied ?faction_branch)
      )
  )
  (:action finalize_branch_key_verification_with_variant_b
    :parameters (?faction_branch - faction_branch ?key_resource - key_resource ?blueprint - blueprint_document ?gate - gate_mechanism)
    :precondition
      (and
        (branch_staged_verification ?faction_branch)
        (branch_key_assigned ?faction_branch ?key_resource)
        (branch_blueprint_attached ?faction_branch ?blueprint)
        (blueprint_installed_on_gate ?blueprint ?gate)
        (not
          (gate_variant_a ?gate)
        )
        (gate_variant_b ?gate)
        (not
          (branch_core_verified ?faction_branch)
        )
      )
    :effect
      (and
        (branch_core_verified ?faction_branch)
        (branch_policy_variant_applied ?faction_branch)
      )
  )
  (:action finalize_branch_key_verification_with_variants
    :parameters (?faction_branch - faction_branch ?key_resource - key_resource ?blueprint - blueprint_document ?gate - gate_mechanism)
    :precondition
      (and
        (branch_staged_verification ?faction_branch)
        (branch_key_assigned ?faction_branch ?key_resource)
        (branch_blueprint_attached ?faction_branch ?blueprint)
        (blueprint_installed_on_gate ?blueprint ?gate)
        (gate_variant_a ?gate)
        (gate_variant_b ?gate)
        (not
          (branch_core_verified ?faction_branch)
        )
      )
    :effect
      (and
        (branch_core_verified ?faction_branch)
        (branch_policy_variant_applied ?faction_branch)
      )
  )
  (:action award_branch_milestone
    :parameters (?faction_branch - faction_branch)
    :precondition
      (and
        (branch_core_verified ?faction_branch)
        (not
          (branch_policy_variant_applied ?faction_branch)
        )
        (not
          (branch_milestone_finalized ?faction_branch)
        )
      )
    :effect
      (and
        (branch_milestone_finalized ?faction_branch)
        (milestone_awarded ?faction_branch)
      )
  )
  (:action attach_certification_to_branch
    :parameters (?faction_branch - faction_branch ?certification_badge - certification_badge)
    :precondition
      (and
        (branch_core_verified ?faction_branch)
        (branch_policy_variant_applied ?faction_branch)
        (certification_badge_available ?certification_badge)
      )
    :effect
      (and
        (branch_certification_assigned ?faction_branch ?certification_badge)
        (not
          (certification_badge_available ?certification_badge)
        )
      )
  )
  (:action verify_and_commit_branch_reward
    :parameters (?faction_branch - faction_branch ?outpost - outpost_node ?squad - squad_node ?consumable_resource - consumable_resource ?certification_badge - certification_badge)
    :precondition
      (and
        (branch_core_verified ?faction_branch)
        (branch_policy_variant_applied ?faction_branch)
        (branch_certification_assigned ?faction_branch ?certification_badge)
        (branch_has_outpost ?faction_branch ?outpost)
        (branch_has_squad ?faction_branch ?squad)
        (outpost_contribution_confirmed ?outpost)
        (squad_contribution_confirmed ?squad)
        (node_resource_assigned ?faction_branch ?consumable_resource)
        (not
          (branch_reward_committed ?faction_branch)
        )
      )
    :effect (branch_reward_committed ?faction_branch)
  )
  (:action finalize_and_award_branch_milestone
    :parameters (?faction_branch - faction_branch)
    :precondition
      (and
        (branch_core_verified ?faction_branch)
        (branch_reward_committed ?faction_branch)
        (not
          (branch_milestone_finalized ?faction_branch)
        )
      )
    :effect
      (and
        (branch_milestone_finalized ?faction_branch)
        (milestone_awarded ?faction_branch)
      )
  )
  (:action apply_quest_chip_to_branch
    :parameters (?faction_branch - faction_branch ?quest_chip - quest_chip ?consumable_resource - consumable_resource)
    :precondition
      (and
        (node_prepared ?faction_branch)
        (node_resource_assigned ?faction_branch ?consumable_resource)
        (quest_chip_available ?quest_chip)
        (branch_quest_chip_attached ?faction_branch ?quest_chip)
        (not
          (branch_quest_chip_engaged ?faction_branch)
        )
      )
    :effect
      (and
        (branch_quest_chip_engaged ?faction_branch)
        (not
          (quest_chip_available ?quest_chip)
        )
      )
  )
  (:action stage_branch_quest_modifier
    :parameters (?faction_branch - faction_branch ?npc_contact - npc_contact)
    :precondition
      (and
        (branch_quest_chip_engaged ?faction_branch)
        (node_npc_assigned ?faction_branch ?npc_contact)
        (not
          (branch_quest_chip_staged ?faction_branch)
        )
      )
    :effect (branch_quest_chip_staged ?faction_branch)
  )
  (:action finalize_branch_quest_modifier_with_key
    :parameters (?faction_branch - faction_branch ?key_resource - key_resource)
    :precondition
      (and
        (branch_quest_chip_staged ?faction_branch)
        (branch_key_assigned ?faction_branch ?key_resource)
        (not
          (branch_quest_chip_finalized ?faction_branch)
        )
      )
    :effect (branch_quest_chip_finalized ?faction_branch)
  )
  (:action award_branch_milestone_from_modifier
    :parameters (?faction_branch - faction_branch)
    :precondition
      (and
        (branch_quest_chip_finalized ?faction_branch)
        (not
          (branch_milestone_finalized ?faction_branch)
        )
      )
    :effect
      (and
        (branch_milestone_finalized ?faction_branch)
        (milestone_awarded ?faction_branch)
      )
  )
  (:action commit_outpost_reward
    :parameters (?outpost - outpost_node ?gate - gate_mechanism)
    :precondition
      (and
        (outpost_stage_marked ?outpost)
        (outpost_contribution_confirmed ?outpost)
        (gate_activation_started ?gate)
        (gate_ready ?gate)
        (not
          (milestone_awarded ?outpost)
        )
      )
    :effect (milestone_awarded ?outpost)
  )
  (:action commit_squad_reward
    :parameters (?squad - squad_node ?gate - gate_mechanism)
    :precondition
      (and
        (squad_stage_marked ?squad)
        (squad_contribution_confirmed ?squad)
        (gate_activation_started ?gate)
        (gate_ready ?gate)
        (not
          (milestone_awarded ?squad)
        )
      )
    :effect (milestone_awarded ?squad)
  )
  (:action commit_reputation_to_node
    :parameters (?progress_node - progress_node ?reputation_badge - reputation_badge ?consumable_resource - consumable_resource)
    :precondition
      (and
        (milestone_awarded ?progress_node)
        (node_resource_assigned ?progress_node ?consumable_resource)
        (reputation_badge_available ?reputation_badge)
        (not
          (reputation_committed ?progress_node)
        )
      )
    :effect
      (and
        (reputation_committed ?progress_node)
        (node_reputation_link ?progress_node ?reputation_badge)
        (not
          (reputation_badge_available ?reputation_badge)
        )
      )
  )
  (:action finalize_outpost_advancement
    :parameters (?outpost - outpost_node ?contribution_token - contribution_token ?reputation_badge - reputation_badge)
    :precondition
      (and
        (reputation_committed ?outpost)
        (node_token_assigned ?outpost ?contribution_token)
        (node_reputation_link ?outpost ?reputation_badge)
        (not
          (node_advanced ?outpost)
        )
      )
    :effect
      (and
        (node_advanced ?outpost)
        (token_available ?contribution_token)
        (reputation_badge_available ?reputation_badge)
      )
  )
  (:action finalize_squad_advancement
    :parameters (?squad - squad_node ?contribution_token - contribution_token ?reputation_badge - reputation_badge)
    :precondition
      (and
        (reputation_committed ?squad)
        (node_token_assigned ?squad ?contribution_token)
        (node_reputation_link ?squad ?reputation_badge)
        (not
          (node_advanced ?squad)
        )
      )
    :effect
      (and
        (node_advanced ?squad)
        (token_available ?contribution_token)
        (reputation_badge_available ?reputation_badge)
      )
  )
  (:action finalize_branch_advancement
    :parameters (?faction_branch - faction_branch ?contribution_token - contribution_token ?reputation_badge - reputation_badge)
    :precondition
      (and
        (reputation_committed ?faction_branch)
        (node_token_assigned ?faction_branch ?contribution_token)
        (node_reputation_link ?faction_branch ?reputation_badge)
        (not
          (node_advanced ?faction_branch)
        )
      )
    :effect
      (and
        (node_advanced ?faction_branch)
        (token_available ?contribution_token)
        (reputation_badge_available ?reputation_badge)
      )
  )
)

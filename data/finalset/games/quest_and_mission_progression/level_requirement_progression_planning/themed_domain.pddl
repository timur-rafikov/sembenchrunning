(define (domain level_requirement_progression_planning_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_category - object item_category - object flag_category - object entity_group - object progression_node - entity_group unlock_key - domain_category objective_type - domain_category gatekeeper - domain_category side_objective - domain_category scenario_variant - domain_category level_gate_token - domain_category mechanic_resource - domain_category conditional_trigger - domain_category consumable_item - item_category asset - item_category narrative_trigger - item_category requirement_checkpoint_a - flag_category requirement_checkpoint_b - flag_category stage - flag_category track_group - progression_node mission_group - progression_node primary_track_node - track_group secondary_track_node - track_group mission - mission_group)
  (:predicates
    (progression_node_active ?progression_node - progression_node)
    (progression_node_validated ?progression_node - progression_node)
    (progression_node_assigned ?progression_node - progression_node)
    (progression_node_completed ?progression_node - progression_node)
    (progression_marked ?progression_node - progression_node)
    (node_gate_token_bound ?progression_node - progression_node)
    (unlock_key_available ?unlock_key - unlock_key)
    (node_bound_unlock_key ?progression_node - progression_node ?unlock_key - unlock_key)
    (objective_available ?objective_type - objective_type)
    (node_has_objective ?progression_node - progression_node ?objective_type - objective_type)
    (gatekeeper_available ?gatekeeper - gatekeeper)
    (node_bound_gatekeeper ?progression_node - progression_node ?gatekeeper - gatekeeper)
    (consumable_available ?consumable_item - consumable_item)
    (primary_node_consumable_assigned ?primary_track_node - primary_track_node ?consumable_item - consumable_item)
    (secondary_node_consumable_assigned ?secondary_track_node - secondary_track_node ?consumable_item - consumable_item)
    (primary_node_has_checkpoint_a ?primary_track_node - primary_track_node ?requirement_checkpoint_a - requirement_checkpoint_a)
    (checkpoint_a_resolved ?requirement_checkpoint_a - requirement_checkpoint_a)
    (checkpoint_a_marked_by_item ?requirement_checkpoint_a - requirement_checkpoint_a)
    (primary_node_checkpoint_confirmed ?primary_track_node - primary_track_node)
    (secondary_node_has_checkpoint_b ?secondary_track_node - secondary_track_node ?requirement_checkpoint_b - requirement_checkpoint_b)
    (checkpoint_b_resolved ?requirement_checkpoint_b - requirement_checkpoint_b)
    (checkpoint_b_marked_by_item ?requirement_checkpoint_b - requirement_checkpoint_b)
    (secondary_node_checkpoint_confirmed ?secondary_track_node - secondary_track_node)
    (stage_available ?stage - stage)
    (stage_ready ?stage - stage)
    (stage_has_checkpoint_a ?stage - stage ?requirement_checkpoint_a - requirement_checkpoint_a)
    (stage_has_checkpoint_b ?stage - stage ?requirement_checkpoint_b - requirement_checkpoint_b)
    (stage_variant_a_enabled ?stage - stage)
    (stage_variant_b_enabled ?stage - stage)
    (stage_ready_for_assets ?stage - stage)
    (mission_associated_primary_node ?mission - mission ?primary_track_node - primary_track_node)
    (mission_associated_secondary_node ?mission - mission ?secondary_track_node - secondary_track_node)
    (mission_has_stage ?mission - mission ?stage - stage)
    (asset_available ?asset - asset)
    (mission_bound_asset ?mission - mission ?asset - asset)
    (asset_activated ?asset - asset)
    (asset_assigned_to_stage ?asset - asset ?stage - stage)
    (mission_variant_prepared ?mission - mission)
    (mission_variant_applied ?mission - mission)
    (mission_variant_validated ?mission - mission)
    (mission_side_objective_active ?mission - mission)
    (mission_side_option_enabled ?mission - mission)
    (mission_variant_resources_attached ?mission - mission)
    (mission_ready_for_finalization ?mission - mission)
    (narrative_trigger_available ?narrative_trigger - narrative_trigger)
    (mission_bound_narrative_trigger ?mission - mission ?narrative_trigger - narrative_trigger)
    (mission_narrative_condition_active ?mission - mission)
    (mission_narrative_step_ready ?mission - mission)
    (mission_narrative_validated ?mission - mission)
    (side_objective_available ?side_objective - side_objective)
    (mission_has_side_objective ?mission - mission ?side_objective - side_objective)
    (scenario_variant_available ?scenario_variant - scenario_variant)
    (mission_has_variant_resource ?mission - mission ?scenario_variant - scenario_variant)
    (mechanic_resource_available ?mechanic_resource - mechanic_resource)
    (mission_has_mechanic_resource ?mission - mission ?mechanic_resource - mechanic_resource)
    (conditional_trigger_available ?conditional_trigger - conditional_trigger)
    (mission_has_conditional_trigger ?mission - mission ?conditional_trigger - conditional_trigger)
    (level_gate_token_available ?level_gate_token - level_gate_token)
    (node_bound_level_gate_token ?progression_node - progression_node ?level_gate_token - level_gate_token)
    (primary_node_checkpoint_engaged ?primary_track_node - primary_track_node)
    (secondary_node_checkpoint_engaged ?secondary_track_node - secondary_track_node)
    (mission_finalized ?mission - mission)
  )
  (:action activate_progression_node
    :parameters (?progression_node - progression_node)
    :precondition
      (and
        (not
          (progression_node_active ?progression_node)
        )
        (not
          (progression_node_completed ?progression_node)
        )
      )
    :effect (progression_node_active ?progression_node)
  )
  (:action assign_unlock_key_to_node
    :parameters (?progression_node - progression_node ?unlock_key - unlock_key)
    :precondition
      (and
        (progression_node_active ?progression_node)
        (not
          (progression_node_assigned ?progression_node)
        )
        (unlock_key_available ?unlock_key)
      )
    :effect
      (and
        (progression_node_assigned ?progression_node)
        (node_bound_unlock_key ?progression_node ?unlock_key)
        (not
          (unlock_key_available ?unlock_key)
        )
      )
  )
  (:action assign_objective_to_node
    :parameters (?progression_node - progression_node ?objective_type - objective_type)
    :precondition
      (and
        (progression_node_active ?progression_node)
        (progression_node_assigned ?progression_node)
        (objective_available ?objective_type)
      )
    :effect
      (and
        (node_has_objective ?progression_node ?objective_type)
        (not
          (objective_available ?objective_type)
        )
      )
  )
  (:action validate_node_objective
    :parameters (?progression_node - progression_node ?objective_type - objective_type)
    :precondition
      (and
        (progression_node_active ?progression_node)
        (progression_node_assigned ?progression_node)
        (node_has_objective ?progression_node ?objective_type)
        (not
          (progression_node_validated ?progression_node)
        )
      )
    :effect (progression_node_validated ?progression_node)
  )
  (:action release_objective_assignment
    :parameters (?progression_node - progression_node ?objective_type - objective_type)
    :precondition
      (and
        (node_has_objective ?progression_node ?objective_type)
      )
    :effect
      (and
        (objective_available ?objective_type)
        (not
          (node_has_objective ?progression_node ?objective_type)
        )
      )
  )
  (:action bind_gatekeeper_to_node
    :parameters (?progression_node - progression_node ?gatekeeper - gatekeeper)
    :precondition
      (and
        (progression_node_validated ?progression_node)
        (gatekeeper_available ?gatekeeper)
      )
    :effect
      (and
        (node_bound_gatekeeper ?progression_node ?gatekeeper)
        (not
          (gatekeeper_available ?gatekeeper)
        )
      )
  )
  (:action release_gatekeeper_from_node
    :parameters (?progression_node - progression_node ?gatekeeper - gatekeeper)
    :precondition
      (and
        (node_bound_gatekeeper ?progression_node ?gatekeeper)
      )
    :effect
      (and
        (gatekeeper_available ?gatekeeper)
        (not
          (node_bound_gatekeeper ?progression_node ?gatekeeper)
        )
      )
  )
  (:action attach_mechanic_resource_to_mission
    :parameters (?mission - mission ?mechanic_resource - mechanic_resource)
    :precondition
      (and
        (progression_node_validated ?mission)
        (mechanic_resource_available ?mechanic_resource)
      )
    :effect
      (and
        (mission_has_mechanic_resource ?mission ?mechanic_resource)
        (not
          (mechanic_resource_available ?mechanic_resource)
        )
      )
  )
  (:action detach_mechanic_from_mission
    :parameters (?mission - mission ?mechanic_resource - mechanic_resource)
    :precondition
      (and
        (mission_has_mechanic_resource ?mission ?mechanic_resource)
      )
    :effect
      (and
        (mechanic_resource_available ?mechanic_resource)
        (not
          (mission_has_mechanic_resource ?mission ?mechanic_resource)
        )
      )
  )
  (:action attach_conditional_trigger_to_mission
    :parameters (?mission - mission ?conditional_trigger - conditional_trigger)
    :precondition
      (and
        (progression_node_validated ?mission)
        (conditional_trigger_available ?conditional_trigger)
      )
    :effect
      (and
        (mission_has_conditional_trigger ?mission ?conditional_trigger)
        (not
          (conditional_trigger_available ?conditional_trigger)
        )
      )
  )
  (:action detach_conditional_trigger_from_mission
    :parameters (?mission - mission ?conditional_trigger - conditional_trigger)
    :precondition
      (and
        (mission_has_conditional_trigger ?mission ?conditional_trigger)
      )
    :effect
      (and
        (conditional_trigger_available ?conditional_trigger)
        (not
          (mission_has_conditional_trigger ?mission ?conditional_trigger)
        )
      )
  )
  (:action resolve_primary_checkpoint
    :parameters (?primary_track_node - primary_track_node ?requirement_checkpoint_a - requirement_checkpoint_a ?objective_type - objective_type)
    :precondition
      (and
        (progression_node_validated ?primary_track_node)
        (node_has_objective ?primary_track_node ?objective_type)
        (primary_node_has_checkpoint_a ?primary_track_node ?requirement_checkpoint_a)
        (not
          (checkpoint_a_resolved ?requirement_checkpoint_a)
        )
        (not
          (checkpoint_a_marked_by_item ?requirement_checkpoint_a)
        )
      )
    :effect (checkpoint_a_resolved ?requirement_checkpoint_a)
  )
  (:action process_primary_checkpoint_with_gatekeeper
    :parameters (?primary_track_node - primary_track_node ?requirement_checkpoint_a - requirement_checkpoint_a ?gatekeeper - gatekeeper)
    :precondition
      (and
        (progression_node_validated ?primary_track_node)
        (node_bound_gatekeeper ?primary_track_node ?gatekeeper)
        (primary_node_has_checkpoint_a ?primary_track_node ?requirement_checkpoint_a)
        (checkpoint_a_resolved ?requirement_checkpoint_a)
        (not
          (primary_node_checkpoint_engaged ?primary_track_node)
        )
      )
    :effect
      (and
        (primary_node_checkpoint_engaged ?primary_track_node)
        (primary_node_checkpoint_confirmed ?primary_track_node)
      )
  )
  (:action consume_item_for_primary_checkpoint
    :parameters (?primary_track_node - primary_track_node ?requirement_checkpoint_a - requirement_checkpoint_a ?consumable_item - consumable_item)
    :precondition
      (and
        (progression_node_validated ?primary_track_node)
        (primary_node_has_checkpoint_a ?primary_track_node ?requirement_checkpoint_a)
        (consumable_available ?consumable_item)
        (not
          (primary_node_checkpoint_engaged ?primary_track_node)
        )
      )
    :effect
      (and
        (checkpoint_a_marked_by_item ?requirement_checkpoint_a)
        (primary_node_checkpoint_engaged ?primary_track_node)
        (primary_node_consumable_assigned ?primary_track_node ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action finalize_primary_checkpoint
    :parameters (?primary_track_node - primary_track_node ?requirement_checkpoint_a - requirement_checkpoint_a ?objective_type - objective_type ?consumable_item - consumable_item)
    :precondition
      (and
        (progression_node_validated ?primary_track_node)
        (node_has_objective ?primary_track_node ?objective_type)
        (primary_node_has_checkpoint_a ?primary_track_node ?requirement_checkpoint_a)
        (checkpoint_a_marked_by_item ?requirement_checkpoint_a)
        (primary_node_consumable_assigned ?primary_track_node ?consumable_item)
        (not
          (primary_node_checkpoint_confirmed ?primary_track_node)
        )
      )
    :effect
      (and
        (checkpoint_a_resolved ?requirement_checkpoint_a)
        (primary_node_checkpoint_confirmed ?primary_track_node)
        (consumable_available ?consumable_item)
        (not
          (primary_node_consumable_assigned ?primary_track_node ?consumable_item)
        )
      )
  )
  (:action resolve_secondary_checkpoint
    :parameters (?secondary_track_node - secondary_track_node ?requirement_checkpoint_b - requirement_checkpoint_b ?objective_type - objective_type)
    :precondition
      (and
        (progression_node_validated ?secondary_track_node)
        (node_has_objective ?secondary_track_node ?objective_type)
        (secondary_node_has_checkpoint_b ?secondary_track_node ?requirement_checkpoint_b)
        (not
          (checkpoint_b_resolved ?requirement_checkpoint_b)
        )
        (not
          (checkpoint_b_marked_by_item ?requirement_checkpoint_b)
        )
      )
    :effect (checkpoint_b_resolved ?requirement_checkpoint_b)
  )
  (:action process_secondary_checkpoint_with_gatekeeper
    :parameters (?secondary_track_node - secondary_track_node ?requirement_checkpoint_b - requirement_checkpoint_b ?gatekeeper - gatekeeper)
    :precondition
      (and
        (progression_node_validated ?secondary_track_node)
        (node_bound_gatekeeper ?secondary_track_node ?gatekeeper)
        (secondary_node_has_checkpoint_b ?secondary_track_node ?requirement_checkpoint_b)
        (checkpoint_b_resolved ?requirement_checkpoint_b)
        (not
          (secondary_node_checkpoint_engaged ?secondary_track_node)
        )
      )
    :effect
      (and
        (secondary_node_checkpoint_engaged ?secondary_track_node)
        (secondary_node_checkpoint_confirmed ?secondary_track_node)
      )
  )
  (:action consume_item_for_secondary_checkpoint
    :parameters (?secondary_track_node - secondary_track_node ?requirement_checkpoint_b - requirement_checkpoint_b ?consumable_item - consumable_item)
    :precondition
      (and
        (progression_node_validated ?secondary_track_node)
        (secondary_node_has_checkpoint_b ?secondary_track_node ?requirement_checkpoint_b)
        (consumable_available ?consumable_item)
        (not
          (secondary_node_checkpoint_engaged ?secondary_track_node)
        )
      )
    :effect
      (and
        (checkpoint_b_marked_by_item ?requirement_checkpoint_b)
        (secondary_node_checkpoint_engaged ?secondary_track_node)
        (secondary_node_consumable_assigned ?secondary_track_node ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action finalize_secondary_checkpoint
    :parameters (?secondary_track_node - secondary_track_node ?requirement_checkpoint_b - requirement_checkpoint_b ?objective_type - objective_type ?consumable_item - consumable_item)
    :precondition
      (and
        (progression_node_validated ?secondary_track_node)
        (node_has_objective ?secondary_track_node ?objective_type)
        (secondary_node_has_checkpoint_b ?secondary_track_node ?requirement_checkpoint_b)
        (checkpoint_b_marked_by_item ?requirement_checkpoint_b)
        (secondary_node_consumable_assigned ?secondary_track_node ?consumable_item)
        (not
          (secondary_node_checkpoint_confirmed ?secondary_track_node)
        )
      )
    :effect
      (and
        (checkpoint_b_resolved ?requirement_checkpoint_b)
        (secondary_node_checkpoint_confirmed ?secondary_track_node)
        (consumable_available ?consumable_item)
        (not
          (secondary_node_consumable_assigned ?secondary_track_node ?consumable_item)
        )
      )
  )
  (:action compose_stage_from_checkpoints
    :parameters (?primary_track_node - primary_track_node ?secondary_track_node - secondary_track_node ?requirement_checkpoint_a - requirement_checkpoint_a ?requirement_checkpoint_b - requirement_checkpoint_b ?stage - stage)
    :precondition
      (and
        (primary_node_checkpoint_engaged ?primary_track_node)
        (secondary_node_checkpoint_engaged ?secondary_track_node)
        (primary_node_has_checkpoint_a ?primary_track_node ?requirement_checkpoint_a)
        (secondary_node_has_checkpoint_b ?secondary_track_node ?requirement_checkpoint_b)
        (checkpoint_a_resolved ?requirement_checkpoint_a)
        (checkpoint_b_resolved ?requirement_checkpoint_b)
        (primary_node_checkpoint_confirmed ?primary_track_node)
        (secondary_node_checkpoint_confirmed ?secondary_track_node)
        (stage_available ?stage)
      )
    :effect
      (and
        (stage_ready ?stage)
        (stage_has_checkpoint_a ?stage ?requirement_checkpoint_a)
        (stage_has_checkpoint_b ?stage ?requirement_checkpoint_b)
        (not
          (stage_available ?stage)
        )
      )
  )
  (:action compose_stage_variant_a
    :parameters (?primary_track_node - primary_track_node ?secondary_track_node - secondary_track_node ?requirement_checkpoint_a - requirement_checkpoint_a ?requirement_checkpoint_b - requirement_checkpoint_b ?stage - stage)
    :precondition
      (and
        (primary_node_checkpoint_engaged ?primary_track_node)
        (secondary_node_checkpoint_engaged ?secondary_track_node)
        (primary_node_has_checkpoint_a ?primary_track_node ?requirement_checkpoint_a)
        (secondary_node_has_checkpoint_b ?secondary_track_node ?requirement_checkpoint_b)
        (checkpoint_a_marked_by_item ?requirement_checkpoint_a)
        (checkpoint_b_resolved ?requirement_checkpoint_b)
        (not
          (primary_node_checkpoint_confirmed ?primary_track_node)
        )
        (secondary_node_checkpoint_confirmed ?secondary_track_node)
        (stage_available ?stage)
      )
    :effect
      (and
        (stage_ready ?stage)
        (stage_has_checkpoint_a ?stage ?requirement_checkpoint_a)
        (stage_has_checkpoint_b ?stage ?requirement_checkpoint_b)
        (stage_variant_a_enabled ?stage)
        (not
          (stage_available ?stage)
        )
      )
  )
  (:action compose_stage_variant_b
    :parameters (?primary_track_node - primary_track_node ?secondary_track_node - secondary_track_node ?requirement_checkpoint_a - requirement_checkpoint_a ?requirement_checkpoint_b - requirement_checkpoint_b ?stage - stage)
    :precondition
      (and
        (primary_node_checkpoint_engaged ?primary_track_node)
        (secondary_node_checkpoint_engaged ?secondary_track_node)
        (primary_node_has_checkpoint_a ?primary_track_node ?requirement_checkpoint_a)
        (secondary_node_has_checkpoint_b ?secondary_track_node ?requirement_checkpoint_b)
        (checkpoint_a_resolved ?requirement_checkpoint_a)
        (checkpoint_b_marked_by_item ?requirement_checkpoint_b)
        (primary_node_checkpoint_confirmed ?primary_track_node)
        (not
          (secondary_node_checkpoint_confirmed ?secondary_track_node)
        )
        (stage_available ?stage)
      )
    :effect
      (and
        (stage_ready ?stage)
        (stage_has_checkpoint_a ?stage ?requirement_checkpoint_a)
        (stage_has_checkpoint_b ?stage ?requirement_checkpoint_b)
        (stage_variant_b_enabled ?stage)
        (not
          (stage_available ?stage)
        )
      )
  )
  (:action compose_stage_variant_both
    :parameters (?primary_track_node - primary_track_node ?secondary_track_node - secondary_track_node ?requirement_checkpoint_a - requirement_checkpoint_a ?requirement_checkpoint_b - requirement_checkpoint_b ?stage - stage)
    :precondition
      (and
        (primary_node_checkpoint_engaged ?primary_track_node)
        (secondary_node_checkpoint_engaged ?secondary_track_node)
        (primary_node_has_checkpoint_a ?primary_track_node ?requirement_checkpoint_a)
        (secondary_node_has_checkpoint_b ?secondary_track_node ?requirement_checkpoint_b)
        (checkpoint_a_marked_by_item ?requirement_checkpoint_a)
        (checkpoint_b_marked_by_item ?requirement_checkpoint_b)
        (not
          (primary_node_checkpoint_confirmed ?primary_track_node)
        )
        (not
          (secondary_node_checkpoint_confirmed ?secondary_track_node)
        )
        (stage_available ?stage)
      )
    :effect
      (and
        (stage_ready ?stage)
        (stage_has_checkpoint_a ?stage ?requirement_checkpoint_a)
        (stage_has_checkpoint_b ?stage ?requirement_checkpoint_b)
        (stage_variant_a_enabled ?stage)
        (stage_variant_b_enabled ?stage)
        (not
          (stage_available ?stage)
        )
      )
  )
  (:action validate_stage_for_assets
    :parameters (?stage - stage ?primary_track_node - primary_track_node ?objective_type - objective_type)
    :precondition
      (and
        (stage_ready ?stage)
        (primary_node_checkpoint_engaged ?primary_track_node)
        (node_has_objective ?primary_track_node ?objective_type)
        (not
          (stage_ready_for_assets ?stage)
        )
      )
    :effect (stage_ready_for_assets ?stage)
  )
  (:action activate_asset_and_bind_to_stage
    :parameters (?mission - mission ?asset - asset ?stage - stage)
    :precondition
      (and
        (progression_node_validated ?mission)
        (mission_has_stage ?mission ?stage)
        (mission_bound_asset ?mission ?asset)
        (asset_available ?asset)
        (stage_ready ?stage)
        (stage_ready_for_assets ?stage)
        (not
          (asset_activated ?asset)
        )
      )
    :effect
      (and
        (asset_activated ?asset)
        (asset_assigned_to_stage ?asset ?stage)
        (not
          (asset_available ?asset)
        )
      )
  )
  (:action bind_asset_and_prepare_mission_variant
    :parameters (?mission - mission ?asset - asset ?stage - stage ?objective_type - objective_type)
    :precondition
      (and
        (progression_node_validated ?mission)
        (mission_bound_asset ?mission ?asset)
        (asset_activated ?asset)
        (asset_assigned_to_stage ?asset ?stage)
        (node_has_objective ?mission ?objective_type)
        (not
          (stage_variant_a_enabled ?stage)
        )
        (not
          (mission_variant_prepared ?mission)
        )
      )
    :effect (mission_variant_prepared ?mission)
  )
  (:action enable_side_objective
    :parameters (?mission - mission ?side_objective - side_objective)
    :precondition
      (and
        (progression_node_validated ?mission)
        (side_objective_available ?side_objective)
        (not
          (mission_side_objective_active ?mission)
        )
      )
    :effect
      (and
        (mission_side_objective_active ?mission)
        (mission_has_side_objective ?mission ?side_objective)
        (not
          (side_objective_available ?side_objective)
        )
      )
  )
  (:action apply_side_objective_to_mission
    :parameters (?mission - mission ?asset - asset ?stage - stage ?objective_type - objective_type ?side_objective - side_objective)
    :precondition
      (and
        (progression_node_validated ?mission)
        (mission_bound_asset ?mission ?asset)
        (asset_activated ?asset)
        (asset_assigned_to_stage ?asset ?stage)
        (node_has_objective ?mission ?objective_type)
        (stage_variant_a_enabled ?stage)
        (mission_side_objective_active ?mission)
        (mission_has_side_objective ?mission ?side_objective)
        (not
          (mission_variant_prepared ?mission)
        )
      )
    :effect
      (and
        (mission_variant_prepared ?mission)
        (mission_side_option_enabled ?mission)
      )
  )
  (:action apply_scenario_variant_path_a
    :parameters (?mission - mission ?mechanic_resource - mechanic_resource ?gatekeeper - gatekeeper ?asset - asset ?stage - stage)
    :precondition
      (and
        (mission_variant_prepared ?mission)
        (mission_has_mechanic_resource ?mission ?mechanic_resource)
        (node_bound_gatekeeper ?mission ?gatekeeper)
        (mission_bound_asset ?mission ?asset)
        (asset_assigned_to_stage ?asset ?stage)
        (not
          (stage_variant_b_enabled ?stage)
        )
        (not
          (mission_variant_applied ?mission)
        )
      )
    :effect (mission_variant_applied ?mission)
  )
  (:action apply_scenario_variant_path_b
    :parameters (?mission - mission ?mechanic_resource - mechanic_resource ?gatekeeper - gatekeeper ?asset - asset ?stage - stage)
    :precondition
      (and
        (mission_variant_prepared ?mission)
        (mission_has_mechanic_resource ?mission ?mechanic_resource)
        (node_bound_gatekeeper ?mission ?gatekeeper)
        (mission_bound_asset ?mission ?asset)
        (asset_assigned_to_stage ?asset ?stage)
        (stage_variant_b_enabled ?stage)
        (not
          (mission_variant_applied ?mission)
        )
      )
    :effect (mission_variant_applied ?mission)
  )
  (:action activate_variant_step_alpha
    :parameters (?mission - mission ?conditional_trigger - conditional_trigger ?asset - asset ?stage - stage)
    :precondition
      (and
        (mission_variant_applied ?mission)
        (mission_has_conditional_trigger ?mission ?conditional_trigger)
        (mission_bound_asset ?mission ?asset)
        (asset_assigned_to_stage ?asset ?stage)
        (not
          (stage_variant_a_enabled ?stage)
        )
        (not
          (stage_variant_b_enabled ?stage)
        )
        (not
          (mission_variant_validated ?mission)
        )
      )
    :effect (mission_variant_validated ?mission)
  )
  (:action activate_variant_step_alpha_with_resources
    :parameters (?mission - mission ?conditional_trigger - conditional_trigger ?asset - asset ?stage - stage)
    :precondition
      (and
        (mission_variant_applied ?mission)
        (mission_has_conditional_trigger ?mission ?conditional_trigger)
        (mission_bound_asset ?mission ?asset)
        (asset_assigned_to_stage ?asset ?stage)
        (stage_variant_a_enabled ?stage)
        (not
          (stage_variant_b_enabled ?stage)
        )
        (not
          (mission_variant_validated ?mission)
        )
      )
    :effect
      (and
        (mission_variant_validated ?mission)
        (mission_variant_resources_attached ?mission)
      )
  )
  (:action activate_variant_step_beta
    :parameters (?mission - mission ?conditional_trigger - conditional_trigger ?asset - asset ?stage - stage)
    :precondition
      (and
        (mission_variant_applied ?mission)
        (mission_has_conditional_trigger ?mission ?conditional_trigger)
        (mission_bound_asset ?mission ?asset)
        (asset_assigned_to_stage ?asset ?stage)
        (not
          (stage_variant_a_enabled ?stage)
        )
        (stage_variant_b_enabled ?stage)
        (not
          (mission_variant_validated ?mission)
        )
      )
    :effect
      (and
        (mission_variant_validated ?mission)
        (mission_variant_resources_attached ?mission)
      )
  )
  (:action activate_variant_step_beta_with_resources
    :parameters (?mission - mission ?conditional_trigger - conditional_trigger ?asset - asset ?stage - stage)
    :precondition
      (and
        (mission_variant_applied ?mission)
        (mission_has_conditional_trigger ?mission ?conditional_trigger)
        (mission_bound_asset ?mission ?asset)
        (asset_assigned_to_stage ?asset ?stage)
        (stage_variant_a_enabled ?stage)
        (stage_variant_b_enabled ?stage)
        (not
          (mission_variant_validated ?mission)
        )
      )
    :effect
      (and
        (mission_variant_validated ?mission)
        (mission_variant_resources_attached ?mission)
      )
  )
  (:action finalize_mission_checkpoint
    :parameters (?mission - mission)
    :precondition
      (and
        (mission_variant_validated ?mission)
        (not
          (mission_variant_resources_attached ?mission)
        )
        (not
          (mission_finalized ?mission)
        )
      )
    :effect
      (and
        (mission_finalized ?mission)
        (progression_marked ?mission)
      )
  )
  (:action attach_scenario_variant_resource
    :parameters (?mission - mission ?scenario_variant - scenario_variant)
    :precondition
      (and
        (mission_variant_validated ?mission)
        (mission_variant_resources_attached ?mission)
        (scenario_variant_available ?scenario_variant)
      )
    :effect
      (and
        (mission_has_variant_resource ?mission ?scenario_variant)
        (not
          (scenario_variant_available ?scenario_variant)
        )
      )
  )
  (:action validate_mission_for_deployment
    :parameters (?mission - mission ?primary_track_node - primary_track_node ?secondary_track_node - secondary_track_node ?objective_type - objective_type ?scenario_variant - scenario_variant)
    :precondition
      (and
        (mission_variant_validated ?mission)
        (mission_variant_resources_attached ?mission)
        (mission_has_variant_resource ?mission ?scenario_variant)
        (mission_associated_primary_node ?mission ?primary_track_node)
        (mission_associated_secondary_node ?mission ?secondary_track_node)
        (primary_node_checkpoint_confirmed ?primary_track_node)
        (secondary_node_checkpoint_confirmed ?secondary_track_node)
        (node_has_objective ?mission ?objective_type)
        (not
          (mission_ready_for_finalization ?mission)
        )
      )
    :effect (mission_ready_for_finalization ?mission)
  )
  (:action finalize_mission_deployment
    :parameters (?mission - mission)
    :precondition
      (and
        (mission_variant_validated ?mission)
        (mission_ready_for_finalization ?mission)
        (not
          (mission_finalized ?mission)
        )
      )
    :effect
      (and
        (mission_finalized ?mission)
        (progression_marked ?mission)
      )
  )
  (:action activate_narrative_trigger_on_mission
    :parameters (?mission - mission ?narrative_trigger - narrative_trigger ?objective_type - objective_type)
    :precondition
      (and
        (progression_node_validated ?mission)
        (node_has_objective ?mission ?objective_type)
        (narrative_trigger_available ?narrative_trigger)
        (mission_bound_narrative_trigger ?mission ?narrative_trigger)
        (not
          (mission_narrative_condition_active ?mission)
        )
      )
    :effect
      (and
        (mission_narrative_condition_active ?mission)
        (not
          (narrative_trigger_available ?narrative_trigger)
        )
      )
  )
  (:action progress_narrative_step
    :parameters (?mission - mission ?gatekeeper - gatekeeper)
    :precondition
      (and
        (mission_narrative_condition_active ?mission)
        (node_bound_gatekeeper ?mission ?gatekeeper)
        (not
          (mission_narrative_step_ready ?mission)
        )
      )
    :effect (mission_narrative_step_ready ?mission)
  )
  (:action confirm_narrative_trigger_with_condition
    :parameters (?mission - mission ?conditional_trigger - conditional_trigger)
    :precondition
      (and
        (mission_narrative_step_ready ?mission)
        (mission_has_conditional_trigger ?mission ?conditional_trigger)
        (not
          (mission_narrative_validated ?mission)
        )
      )
    :effect (mission_narrative_validated ?mission)
  )
  (:action finalize_mission_via_narrative
    :parameters (?mission - mission)
    :precondition
      (and
        (mission_narrative_validated ?mission)
        (not
          (mission_finalized ?mission)
        )
      )
    :effect
      (and
        (mission_finalized ?mission)
        (progression_marked ?mission)
      )
  )
  (:action apply_advancement_to_primary_node
    :parameters (?primary_track_node - primary_track_node ?stage - stage)
    :precondition
      (and
        (primary_node_checkpoint_engaged ?primary_track_node)
        (primary_node_checkpoint_confirmed ?primary_track_node)
        (stage_ready ?stage)
        (stage_ready_for_assets ?stage)
        (not
          (progression_marked ?primary_track_node)
        )
      )
    :effect (progression_marked ?primary_track_node)
  )
  (:action apply_advancement_to_secondary_node
    :parameters (?secondary_track_node - secondary_track_node ?stage - stage)
    :precondition
      (and
        (secondary_node_checkpoint_engaged ?secondary_track_node)
        (secondary_node_checkpoint_confirmed ?secondary_track_node)
        (stage_ready ?stage)
        (stage_ready_for_assets ?stage)
        (not
          (progression_marked ?secondary_track_node)
        )
      )
    :effect (progression_marked ?secondary_track_node)
  )
  (:action consume_level_gate_token_on_node
    :parameters (?progression_node - progression_node ?level_gate_token - level_gate_token ?objective_type - objective_type)
    :precondition
      (and
        (progression_marked ?progression_node)
        (node_has_objective ?progression_node ?objective_type)
        (level_gate_token_available ?level_gate_token)
        (not
          (node_gate_token_bound ?progression_node)
        )
      )
    :effect
      (and
        (node_gate_token_bound ?progression_node)
        (node_bound_level_gate_token ?progression_node ?level_gate_token)
        (not
          (level_gate_token_available ?level_gate_token)
        )
      )
  )
  (:action release_unlock_key_for_primary_node
    :parameters (?primary_track_node - primary_track_node ?unlock_key - unlock_key ?level_gate_token - level_gate_token)
    :precondition
      (and
        (node_gate_token_bound ?primary_track_node)
        (node_bound_unlock_key ?primary_track_node ?unlock_key)
        (node_bound_level_gate_token ?primary_track_node ?level_gate_token)
        (not
          (progression_node_completed ?primary_track_node)
        )
      )
    :effect
      (and
        (progression_node_completed ?primary_track_node)
        (unlock_key_available ?unlock_key)
        (level_gate_token_available ?level_gate_token)
      )
  )
  (:action release_unlock_key_for_secondary_node
    :parameters (?secondary_track_node - secondary_track_node ?unlock_key - unlock_key ?level_gate_token - level_gate_token)
    :precondition
      (and
        (node_gate_token_bound ?secondary_track_node)
        (node_bound_unlock_key ?secondary_track_node ?unlock_key)
        (node_bound_level_gate_token ?secondary_track_node ?level_gate_token)
        (not
          (progression_node_completed ?secondary_track_node)
        )
      )
    :effect
      (and
        (progression_node_completed ?secondary_track_node)
        (unlock_key_available ?unlock_key)
        (level_gate_token_available ?level_gate_token)
      )
  )
  (:action release_unlock_key_for_mission
    :parameters (?mission - mission ?unlock_key - unlock_key ?level_gate_token - level_gate_token)
    :precondition
      (and
        (node_gate_token_bound ?mission)
        (node_bound_unlock_key ?mission ?unlock_key)
        (node_bound_level_gate_token ?mission ?level_gate_token)
        (not
          (progression_node_completed ?mission)
        )
      )
    :effect
      (and
        (progression_node_completed ?mission)
        (unlock_key_available ?unlock_key)
        (level_gate_token_available ?level_gate_token)
      )
  )
)

(define (domain stealth_objective_progression_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types actor_resource - object resource_supertype - object item_entity - object objective_root - object objective - objective_root unlock_token - actor_resource capability - actor_resource interactable - actor_resource modifier_bonus - actor_resource checkpoint_bonus - actor_resource gating_flag - actor_resource optional_condition - actor_resource variant_tag - actor_resource consumable_resource - resource_supertype reward_node - resource_supertype mission_tag - resource_supertype area_zone - item_entity route_pattern - item_entity progression_package - item_entity atomic_objective - objective mission_objective_group - objective infiltration_objective - atomic_objective exfiltration_objective - atomic_objective mission_instance - mission_objective_group)
  (:predicates
    (task_registered ?objective - objective)
    (task_activated ?objective - objective)
    (task_token_bound ?objective - objective)
    (task_completed ?objective - objective)
    (task_completion_mark ?objective - objective)
    (task_ready ?objective - objective)
    (unlock_token_available ?unlock_token - unlock_token)
    (task_bound_unlock_token ?objective - objective ?unlock_token - unlock_token)
    (capability_available ?capability - capability)
    (task_assigned_capability ?objective - objective ?capability - capability)
    (interactable_available ?interactable - interactable)
    (task_bound_interactable ?objective - objective ?interactable - interactable)
    (consumable_available ?consumable_resource - consumable_resource)
    (infiltration_consumable_bound ?infiltration_objective - infiltration_objective ?consumable_resource - consumable_resource)
    (exfiltration_consumable_bound ?exfiltration_objective - exfiltration_objective ?consumable_resource - consumable_resource)
    (infiltration_zone_association ?infiltration_objective - infiltration_objective ?area_zone - area_zone)
    (zone_primary_signal ?area_zone - area_zone)
    (zone_secondary_signal ?area_zone - area_zone)
    (infiltration_ready_flag ?infiltration_objective - infiltration_objective)
    (exfiltration_route_assignment ?exfiltration_objective - exfiltration_objective ?route_pattern - route_pattern)
    (route_primary_signal ?route_pattern - route_pattern)
    (route_secondary_signal ?route_pattern - route_pattern)
    (exfiltration_ready_flag ?exfiltration_objective - exfiltration_objective)
    (package_available ?progression_package - progression_package)
    (package_active ?progression_package - progression_package)
    (package_bound_zone ?progression_package - progression_package ?area_zone - area_zone)
    (package_bound_route ?progression_package - progression_package ?route_pattern - route_pattern)
    (package_ready_flag_a ?progression_package - progression_package)
    (package_ready_flag_b ?progression_package - progression_package)
    (package_sealed ?progression_package - progression_package)
    (mission_contains_infiltration ?mission_instance - mission_instance ?infiltration_objective - infiltration_objective)
    (mission_contains_exfiltration ?mission_instance - mission_instance ?exfiltration_objective - exfiltration_objective)
    (mission_assigned_package ?mission_instance - mission_instance ?progression_package - progression_package)
    (reward_available ?reward_node - reward_node)
    (mission_contains_reward ?mission_instance - mission_instance ?reward_node - reward_node)
    (reward_collected ?reward_node - reward_node)
    (reward_bound_package ?reward_node - reward_node ?progression_package - progression_package)
    (mission_stage_reward_registered ?mission_instance - mission_instance)
    (mission_stage_reward_validated ?mission_instance - mission_instance)
    (mission_stage_ready ?mission_instance - mission_instance)
    (mission_modifier_attached ?mission_instance - mission_instance)
    (mission_modifier_stage ?mission_instance - mission_instance)
    (mission_reward_approved ?mission_instance - mission_instance)
    (mission_checkpoint_unlocked ?mission_instance - mission_instance)
    (mission_tag_available ?mission_tag - mission_tag)
    (mission_has_tag ?mission_instance - mission_instance ?mission_tag - mission_tag)
    (mission_stage_tagged ?mission_instance - mission_instance)
    (mission_interact_stage_one_completed ?mission_instance - mission_instance)
    (mission_variant_ready ?mission_instance - mission_instance)
    (modifier_available ?modifier_bonus - modifier_bonus)
    (mission_has_modifier ?mission_instance - mission_instance ?modifier_bonus - modifier_bonus)
    (checkpoint_available ?checkpoint_bonus - checkpoint_bonus)
    (mission_has_checkpoint ?mission_instance - mission_instance ?checkpoint_bonus - checkpoint_bonus)
    (optional_condition_available ?optional_condition - optional_condition)
    (mission_has_optional_condition ?mission_instance - mission_instance ?optional_condition - optional_condition)
    (variant_available ?variant_tag - variant_tag)
    (mission_has_variant ?mission_instance - mission_instance ?variant_tag - variant_tag)
    (gating_flag_available ?gating_flag - gating_flag)
    (task_gating_flag_bound ?objective - objective ?gating_flag - gating_flag)
    (infiltration_checkpoint_flag ?infiltration_objective - infiltration_objective)
    (exfiltration_checkpoint_flag ?exfiltration_objective - exfiltration_objective)
    (mission_finalized ?mission_instance - mission_instance)
  )
  (:action register_objective
    :parameters (?objective - objective)
    :precondition
      (and
        (not
          (task_registered ?objective)
        )
        (not
          (task_completed ?objective)
        )
      )
    :effect (task_registered ?objective)
  )
  (:action assign_unlock_token_to_objective
    :parameters (?objective - objective ?unlock_token - unlock_token)
    :precondition
      (and
        (task_registered ?objective)
        (not
          (task_token_bound ?objective)
        )
        (unlock_token_available ?unlock_token)
      )
    :effect
      (and
        (task_token_bound ?objective)
        (task_bound_unlock_token ?objective ?unlock_token)
        (not
          (unlock_token_available ?unlock_token)
        )
      )
  )
  (:action assign_capability_to_objective
    :parameters (?objective - objective ?capability - capability)
    :precondition
      (and
        (task_registered ?objective)
        (task_token_bound ?objective)
        (capability_available ?capability)
      )
    :effect
      (and
        (task_assigned_capability ?objective ?capability)
        (not
          (capability_available ?capability)
        )
      )
  )
  (:action confirm_objective_activation
    :parameters (?objective - objective ?capability - capability)
    :precondition
      (and
        (task_registered ?objective)
        (task_token_bound ?objective)
        (task_assigned_capability ?objective ?capability)
        (not
          (task_activated ?objective)
        )
      )
    :effect (task_activated ?objective)
  )
  (:action revoke_capability_from_objective
    :parameters (?objective - objective ?capability - capability)
    :precondition
      (and
        (task_assigned_capability ?objective ?capability)
      )
    :effect
      (and
        (capability_available ?capability)
        (not
          (task_assigned_capability ?objective ?capability)
        )
      )
  )
  (:action bind_interactable_to_objective
    :parameters (?objective - objective ?interactable - interactable)
    :precondition
      (and
        (task_activated ?objective)
        (interactable_available ?interactable)
      )
    :effect
      (and
        (task_bound_interactable ?objective ?interactable)
        (not
          (interactable_available ?interactable)
        )
      )
  )
  (:action release_interactable_from_objective
    :parameters (?objective - objective ?interactable - interactable)
    :precondition
      (and
        (task_bound_interactable ?objective ?interactable)
      )
    :effect
      (and
        (interactable_available ?interactable)
        (not
          (task_bound_interactable ?objective ?interactable)
        )
      )
  )
  (:action attach_optional_condition_to_mission
    :parameters (?mission_instance - mission_instance ?optional_condition - optional_condition)
    :precondition
      (and
        (task_activated ?mission_instance)
        (optional_condition_available ?optional_condition)
      )
    :effect
      (and
        (mission_has_optional_condition ?mission_instance ?optional_condition)
        (not
          (optional_condition_available ?optional_condition)
        )
      )
  )
  (:action detach_optional_condition_from_mission
    :parameters (?mission_instance - mission_instance ?optional_condition - optional_condition)
    :precondition
      (and
        (mission_has_optional_condition ?mission_instance ?optional_condition)
      )
    :effect
      (and
        (optional_condition_available ?optional_condition)
        (not
          (mission_has_optional_condition ?mission_instance ?optional_condition)
        )
      )
  )
  (:action attach_variant_to_mission
    :parameters (?mission_instance - mission_instance ?variant_tag - variant_tag)
    :precondition
      (and
        (task_activated ?mission_instance)
        (variant_available ?variant_tag)
      )
    :effect
      (and
        (mission_has_variant ?mission_instance ?variant_tag)
        (not
          (variant_available ?variant_tag)
        )
      )
  )
  (:action detach_variant_from_mission
    :parameters (?mission_instance - mission_instance ?variant_tag - variant_tag)
    :precondition
      (and
        (mission_has_variant ?mission_instance ?variant_tag)
      )
    :effect
      (and
        (variant_available ?variant_tag)
        (not
          (mission_has_variant ?mission_instance ?variant_tag)
        )
      )
  )
  (:action prime_zone_for_infiltration
    :parameters (?infiltration_objective - infiltration_objective ?area_zone - area_zone ?capability - capability)
    :precondition
      (and
        (task_activated ?infiltration_objective)
        (task_assigned_capability ?infiltration_objective ?capability)
        (infiltration_zone_association ?infiltration_objective ?area_zone)
        (not
          (zone_primary_signal ?area_zone)
        )
        (not
          (zone_secondary_signal ?area_zone)
        )
      )
    :effect (zone_primary_signal ?area_zone)
  )
  (:action confirm_infiltration_zone_with_interactable
    :parameters (?infiltration_objective - infiltration_objective ?area_zone - area_zone ?interactable - interactable)
    :precondition
      (and
        (task_activated ?infiltration_objective)
        (task_bound_interactable ?infiltration_objective ?interactable)
        (infiltration_zone_association ?infiltration_objective ?area_zone)
        (zone_primary_signal ?area_zone)
        (not
          (infiltration_checkpoint_flag ?infiltration_objective)
        )
      )
    :effect
      (and
        (infiltration_checkpoint_flag ?infiltration_objective)
        (infiltration_ready_flag ?infiltration_objective)
      )
  )
  (:action apply_consumable_to_zone_for_infiltration
    :parameters (?infiltration_objective - infiltration_objective ?area_zone - area_zone ?consumable_resource - consumable_resource)
    :precondition
      (and
        (task_activated ?infiltration_objective)
        (infiltration_zone_association ?infiltration_objective ?area_zone)
        (consumable_available ?consumable_resource)
        (not
          (infiltration_checkpoint_flag ?infiltration_objective)
        )
      )
    :effect
      (and
        (zone_secondary_signal ?area_zone)
        (infiltration_checkpoint_flag ?infiltration_objective)
        (infiltration_consumable_bound ?infiltration_objective ?consumable_resource)
        (not
          (consumable_available ?consumable_resource)
        )
      )
  )
  (:action finalize_infiltration_zone_preparation
    :parameters (?infiltration_objective - infiltration_objective ?area_zone - area_zone ?capability - capability ?consumable_resource - consumable_resource)
    :precondition
      (and
        (task_activated ?infiltration_objective)
        (task_assigned_capability ?infiltration_objective ?capability)
        (infiltration_zone_association ?infiltration_objective ?area_zone)
        (zone_secondary_signal ?area_zone)
        (infiltration_consumable_bound ?infiltration_objective ?consumable_resource)
        (not
          (infiltration_ready_flag ?infiltration_objective)
        )
      )
    :effect
      (and
        (zone_primary_signal ?area_zone)
        (infiltration_ready_flag ?infiltration_objective)
        (consumable_available ?consumable_resource)
        (not
          (infiltration_consumable_bound ?infiltration_objective ?consumable_resource)
        )
      )
  )
  (:action prime_route_for_exfiltration
    :parameters (?exfiltration_objective - exfiltration_objective ?route_pattern - route_pattern ?capability - capability)
    :precondition
      (and
        (task_activated ?exfiltration_objective)
        (task_assigned_capability ?exfiltration_objective ?capability)
        (exfiltration_route_assignment ?exfiltration_objective ?route_pattern)
        (not
          (route_primary_signal ?route_pattern)
        )
        (not
          (route_secondary_signal ?route_pattern)
        )
      )
    :effect (route_primary_signal ?route_pattern)
  )
  (:action confirm_exfiltration_route_with_interactable
    :parameters (?exfiltration_objective - exfiltration_objective ?route_pattern - route_pattern ?interactable - interactable)
    :precondition
      (and
        (task_activated ?exfiltration_objective)
        (task_bound_interactable ?exfiltration_objective ?interactable)
        (exfiltration_route_assignment ?exfiltration_objective ?route_pattern)
        (route_primary_signal ?route_pattern)
        (not
          (exfiltration_checkpoint_flag ?exfiltration_objective)
        )
      )
    :effect
      (and
        (exfiltration_checkpoint_flag ?exfiltration_objective)
        (exfiltration_ready_flag ?exfiltration_objective)
      )
  )
  (:action apply_consumable_to_route_for_exfiltration
    :parameters (?exfiltration_objective - exfiltration_objective ?route_pattern - route_pattern ?consumable_resource - consumable_resource)
    :precondition
      (and
        (task_activated ?exfiltration_objective)
        (exfiltration_route_assignment ?exfiltration_objective ?route_pattern)
        (consumable_available ?consumable_resource)
        (not
          (exfiltration_checkpoint_flag ?exfiltration_objective)
        )
      )
    :effect
      (and
        (route_secondary_signal ?route_pattern)
        (exfiltration_checkpoint_flag ?exfiltration_objective)
        (exfiltration_consumable_bound ?exfiltration_objective ?consumable_resource)
        (not
          (consumable_available ?consumable_resource)
        )
      )
  )
  (:action finalize_exfiltration_route_preparation
    :parameters (?exfiltration_objective - exfiltration_objective ?route_pattern - route_pattern ?capability - capability ?consumable_resource - consumable_resource)
    :precondition
      (and
        (task_activated ?exfiltration_objective)
        (task_assigned_capability ?exfiltration_objective ?capability)
        (exfiltration_route_assignment ?exfiltration_objective ?route_pattern)
        (route_secondary_signal ?route_pattern)
        (exfiltration_consumable_bound ?exfiltration_objective ?consumable_resource)
        (not
          (exfiltration_ready_flag ?exfiltration_objective)
        )
      )
    :effect
      (and
        (route_primary_signal ?route_pattern)
        (exfiltration_ready_flag ?exfiltration_objective)
        (consumable_available ?consumable_resource)
        (not
          (exfiltration_consumable_bound ?exfiltration_objective ?consumable_resource)
        )
      )
  )
  (:action assemble_progression_package
    :parameters (?infiltration_objective - infiltration_objective ?exfiltration_objective - exfiltration_objective ?area_zone - area_zone ?route_pattern - route_pattern ?progression_package - progression_package)
    :precondition
      (and
        (infiltration_checkpoint_flag ?infiltration_objective)
        (exfiltration_checkpoint_flag ?exfiltration_objective)
        (infiltration_zone_association ?infiltration_objective ?area_zone)
        (exfiltration_route_assignment ?exfiltration_objective ?route_pattern)
        (zone_primary_signal ?area_zone)
        (route_primary_signal ?route_pattern)
        (infiltration_ready_flag ?infiltration_objective)
        (exfiltration_ready_flag ?exfiltration_objective)
        (package_available ?progression_package)
      )
    :effect
      (and
        (package_active ?progression_package)
        (package_bound_zone ?progression_package ?area_zone)
        (package_bound_route ?progression_package ?route_pattern)
        (not
          (package_available ?progression_package)
        )
      )
  )
  (:action assemble_progression_package_with_zone_secondary
    :parameters (?infiltration_objective - infiltration_objective ?exfiltration_objective - exfiltration_objective ?area_zone - area_zone ?route_pattern - route_pattern ?progression_package - progression_package)
    :precondition
      (and
        (infiltration_checkpoint_flag ?infiltration_objective)
        (exfiltration_checkpoint_flag ?exfiltration_objective)
        (infiltration_zone_association ?infiltration_objective ?area_zone)
        (exfiltration_route_assignment ?exfiltration_objective ?route_pattern)
        (zone_secondary_signal ?area_zone)
        (route_primary_signal ?route_pattern)
        (not
          (infiltration_ready_flag ?infiltration_objective)
        )
        (exfiltration_ready_flag ?exfiltration_objective)
        (package_available ?progression_package)
      )
    :effect
      (and
        (package_active ?progression_package)
        (package_bound_zone ?progression_package ?area_zone)
        (package_bound_route ?progression_package ?route_pattern)
        (package_ready_flag_a ?progression_package)
        (not
          (package_available ?progression_package)
        )
      )
  )
  (:action assemble_progression_package_with_route_secondary
    :parameters (?infiltration_objective - infiltration_objective ?exfiltration_objective - exfiltration_objective ?area_zone - area_zone ?route_pattern - route_pattern ?progression_package - progression_package)
    :precondition
      (and
        (infiltration_checkpoint_flag ?infiltration_objective)
        (exfiltration_checkpoint_flag ?exfiltration_objective)
        (infiltration_zone_association ?infiltration_objective ?area_zone)
        (exfiltration_route_assignment ?exfiltration_objective ?route_pattern)
        (zone_primary_signal ?area_zone)
        (route_secondary_signal ?route_pattern)
        (infiltration_ready_flag ?infiltration_objective)
        (not
          (exfiltration_ready_flag ?exfiltration_objective)
        )
        (package_available ?progression_package)
      )
    :effect
      (and
        (package_active ?progression_package)
        (package_bound_zone ?progression_package ?area_zone)
        (package_bound_route ?progression_package ?route_pattern)
        (package_ready_flag_b ?progression_package)
        (not
          (package_available ?progression_package)
        )
      )
  )
  (:action assemble_full_progression_package
    :parameters (?infiltration_objective - infiltration_objective ?exfiltration_objective - exfiltration_objective ?area_zone - area_zone ?route_pattern - route_pattern ?progression_package - progression_package)
    :precondition
      (and
        (infiltration_checkpoint_flag ?infiltration_objective)
        (exfiltration_checkpoint_flag ?exfiltration_objective)
        (infiltration_zone_association ?infiltration_objective ?area_zone)
        (exfiltration_route_assignment ?exfiltration_objective ?route_pattern)
        (zone_secondary_signal ?area_zone)
        (route_secondary_signal ?route_pattern)
        (not
          (infiltration_ready_flag ?infiltration_objective)
        )
        (not
          (exfiltration_ready_flag ?exfiltration_objective)
        )
        (package_available ?progression_package)
      )
    :effect
      (and
        (package_active ?progression_package)
        (package_bound_zone ?progression_package ?area_zone)
        (package_bound_route ?progression_package ?route_pattern)
        (package_ready_flag_a ?progression_package)
        (package_ready_flag_b ?progression_package)
        (not
          (package_available ?progression_package)
        )
      )
  )
  (:action seal_progression_package
    :parameters (?progression_package - progression_package ?infiltration_objective - infiltration_objective ?capability - capability)
    :precondition
      (and
        (package_active ?progression_package)
        (infiltration_checkpoint_flag ?infiltration_objective)
        (task_assigned_capability ?infiltration_objective ?capability)
        (not
          (package_sealed ?progression_package)
        )
      )
    :effect (package_sealed ?progression_package)
  )
  (:action register_reward_to_mission_package
    :parameters (?mission_instance - mission_instance ?reward_node - reward_node ?progression_package - progression_package)
    :precondition
      (and
        (task_activated ?mission_instance)
        (mission_assigned_package ?mission_instance ?progression_package)
        (mission_contains_reward ?mission_instance ?reward_node)
        (reward_available ?reward_node)
        (package_active ?progression_package)
        (package_sealed ?progression_package)
        (not
          (reward_collected ?reward_node)
        )
      )
    :effect
      (and
        (reward_collected ?reward_node)
        (reward_bound_package ?reward_node ?progression_package)
        (not
          (reward_available ?reward_node)
        )
      )
  )
  (:action validate_reward_for_mission
    :parameters (?mission_instance - mission_instance ?reward_node - reward_node ?progression_package - progression_package ?capability - capability)
    :precondition
      (and
        (task_activated ?mission_instance)
        (mission_contains_reward ?mission_instance ?reward_node)
        (reward_collected ?reward_node)
        (reward_bound_package ?reward_node ?progression_package)
        (task_assigned_capability ?mission_instance ?capability)
        (not
          (package_ready_flag_a ?progression_package)
        )
        (not
          (mission_stage_reward_registered ?mission_instance)
        )
      )
    :effect (mission_stage_reward_registered ?mission_instance)
  )
  (:action attach_modifier_to_mission
    :parameters (?mission_instance - mission_instance ?modifier_bonus - modifier_bonus)
    :precondition
      (and
        (task_activated ?mission_instance)
        (modifier_available ?modifier_bonus)
        (not
          (mission_modifier_attached ?mission_instance)
        )
      )
    :effect
      (and
        (mission_modifier_attached ?mission_instance)
        (mission_has_modifier ?mission_instance ?modifier_bonus)
        (not
          (modifier_available ?modifier_bonus)
        )
      )
  )
  (:action activate_reward_stage_with_modifier
    :parameters (?mission_instance - mission_instance ?reward_node - reward_node ?progression_package - progression_package ?capability - capability ?modifier_bonus - modifier_bonus)
    :precondition
      (and
        (task_activated ?mission_instance)
        (mission_contains_reward ?mission_instance ?reward_node)
        (reward_collected ?reward_node)
        (reward_bound_package ?reward_node ?progression_package)
        (task_assigned_capability ?mission_instance ?capability)
        (package_ready_flag_a ?progression_package)
        (mission_modifier_attached ?mission_instance)
        (mission_has_modifier ?mission_instance ?modifier_bonus)
        (not
          (mission_stage_reward_registered ?mission_instance)
        )
      )
    :effect
      (and
        (mission_stage_reward_registered ?mission_instance)
        (mission_modifier_stage ?mission_instance)
      )
  )
  (:action validate_reward_stage_requirements
    :parameters (?mission_instance - mission_instance ?optional_condition - optional_condition ?interactable - interactable ?reward_node - reward_node ?progression_package - progression_package)
    :precondition
      (and
        (mission_stage_reward_registered ?mission_instance)
        (mission_has_optional_condition ?mission_instance ?optional_condition)
        (task_bound_interactable ?mission_instance ?interactable)
        (mission_contains_reward ?mission_instance ?reward_node)
        (reward_bound_package ?reward_node ?progression_package)
        (not
          (package_ready_flag_b ?progression_package)
        )
        (not
          (mission_stage_reward_validated ?mission_instance)
        )
      )
    :effect (mission_stage_reward_validated ?mission_instance)
  )
  (:action validate_reward_stage_alternate
    :parameters (?mission_instance - mission_instance ?optional_condition - optional_condition ?interactable - interactable ?reward_node - reward_node ?progression_package - progression_package)
    :precondition
      (and
        (mission_stage_reward_registered ?mission_instance)
        (mission_has_optional_condition ?mission_instance ?optional_condition)
        (task_bound_interactable ?mission_instance ?interactable)
        (mission_contains_reward ?mission_instance ?reward_node)
        (reward_bound_package ?reward_node ?progression_package)
        (package_ready_flag_b ?progression_package)
        (not
          (mission_stage_reward_validated ?mission_instance)
        )
      )
    :effect (mission_stage_reward_validated ?mission_instance)
  )
  (:action activate_mission_stage_variant
    :parameters (?mission_instance - mission_instance ?variant_tag - variant_tag ?reward_node - reward_node ?progression_package - progression_package)
    :precondition
      (and
        (mission_stage_reward_validated ?mission_instance)
        (mission_has_variant ?mission_instance ?variant_tag)
        (mission_contains_reward ?mission_instance ?reward_node)
        (reward_bound_package ?reward_node ?progression_package)
        (not
          (package_ready_flag_a ?progression_package)
        )
        (not
          (package_ready_flag_b ?progression_package)
        )
        (not
          (mission_stage_ready ?mission_instance)
        )
      )
    :effect (mission_stage_ready ?mission_instance)
  )
  (:action activate_variant_and_tag_mission_stage
    :parameters (?mission_instance - mission_instance ?variant_tag - variant_tag ?reward_node - reward_node ?progression_package - progression_package)
    :precondition
      (and
        (mission_stage_reward_validated ?mission_instance)
        (mission_has_variant ?mission_instance ?variant_tag)
        (mission_contains_reward ?mission_instance ?reward_node)
        (reward_bound_package ?reward_node ?progression_package)
        (package_ready_flag_a ?progression_package)
        (not
          (package_ready_flag_b ?progression_package)
        )
        (not
          (mission_stage_ready ?mission_instance)
        )
      )
    :effect
      (and
        (mission_stage_ready ?mission_instance)
        (mission_reward_approved ?mission_instance)
      )
  )
  (:action activate_variant_and_tag_mission_stage_b
    :parameters (?mission_instance - mission_instance ?variant_tag - variant_tag ?reward_node - reward_node ?progression_package - progression_package)
    :precondition
      (and
        (mission_stage_reward_validated ?mission_instance)
        (mission_has_variant ?mission_instance ?variant_tag)
        (mission_contains_reward ?mission_instance ?reward_node)
        (reward_bound_package ?reward_node ?progression_package)
        (not
          (package_ready_flag_a ?progression_package)
        )
        (package_ready_flag_b ?progression_package)
        (not
          (mission_stage_ready ?mission_instance)
        )
      )
    :effect
      (and
        (mission_stage_ready ?mission_instance)
        (mission_reward_approved ?mission_instance)
      )
  )
  (:action activate_variant_and_tag_mission_stage_full
    :parameters (?mission_instance - mission_instance ?variant_tag - variant_tag ?reward_node - reward_node ?progression_package - progression_package)
    :precondition
      (and
        (mission_stage_reward_validated ?mission_instance)
        (mission_has_variant ?mission_instance ?variant_tag)
        (mission_contains_reward ?mission_instance ?reward_node)
        (reward_bound_package ?reward_node ?progression_package)
        (package_ready_flag_a ?progression_package)
        (package_ready_flag_b ?progression_package)
        (not
          (mission_stage_ready ?mission_instance)
        )
      )
    :effect
      (and
        (mission_stage_ready ?mission_instance)
        (mission_reward_approved ?mission_instance)
      )
  )
  (:action mark_mission_stage_for_completion
    :parameters (?mission_instance - mission_instance)
    :precondition
      (and
        (mission_stage_ready ?mission_instance)
        (not
          (mission_reward_approved ?mission_instance)
        )
        (not
          (mission_finalized ?mission_instance)
        )
      )
    :effect
      (and
        (mission_finalized ?mission_instance)
        (task_completion_mark ?mission_instance)
      )
  )
  (:action attach_checkpoint_bonus
    :parameters (?mission_instance - mission_instance ?checkpoint_bonus - checkpoint_bonus)
    :precondition
      (and
        (mission_stage_ready ?mission_instance)
        (mission_reward_approved ?mission_instance)
        (checkpoint_available ?checkpoint_bonus)
      )
    :effect
      (and
        (mission_has_checkpoint ?mission_instance ?checkpoint_bonus)
        (not
          (checkpoint_available ?checkpoint_bonus)
        )
      )
  )
  (:action verify_mission_stage_objective_requirements
    :parameters (?mission_instance - mission_instance ?infiltration_objective - infiltration_objective ?exfiltration_objective - exfiltration_objective ?capability - capability ?checkpoint_bonus - checkpoint_bonus)
    :precondition
      (and
        (mission_stage_ready ?mission_instance)
        (mission_reward_approved ?mission_instance)
        (mission_has_checkpoint ?mission_instance ?checkpoint_bonus)
        (mission_contains_infiltration ?mission_instance ?infiltration_objective)
        (mission_contains_exfiltration ?mission_instance ?exfiltration_objective)
        (infiltration_ready_flag ?infiltration_objective)
        (exfiltration_ready_flag ?exfiltration_objective)
        (task_assigned_capability ?mission_instance ?capability)
        (not
          (mission_checkpoint_unlocked ?mission_instance)
        )
      )
    :effect (mission_checkpoint_unlocked ?mission_instance)
  )
  (:action finalize_mission_stage
    :parameters (?mission_instance - mission_instance)
    :precondition
      (and
        (mission_stage_ready ?mission_instance)
        (mission_checkpoint_unlocked ?mission_instance)
        (not
          (mission_finalized ?mission_instance)
        )
      )
    :effect
      (and
        (mission_finalized ?mission_instance)
        (task_completion_mark ?mission_instance)
      )
  )
  (:action activate_tagged_mission_flow
    :parameters (?mission_instance - mission_instance ?mission_tag - mission_tag ?capability - capability)
    :precondition
      (and
        (task_activated ?mission_instance)
        (task_assigned_capability ?mission_instance ?capability)
        (mission_tag_available ?mission_tag)
        (mission_has_tag ?mission_instance ?mission_tag)
        (not
          (mission_stage_tagged ?mission_instance)
        )
      )
    :effect
      (and
        (mission_stage_tagged ?mission_instance)
        (not
          (mission_tag_available ?mission_tag)
        )
      )
  )
  (:action progress_tagged_flow_via_interactable
    :parameters (?mission_instance - mission_instance ?interactable - interactable)
    :precondition
      (and
        (mission_stage_tagged ?mission_instance)
        (task_bound_interactable ?mission_instance ?interactable)
        (not
          (mission_interact_stage_one_completed ?mission_instance)
        )
      )
    :effect (mission_interact_stage_one_completed ?mission_instance)
  )
  (:action activate_variant_stage_after_interact
    :parameters (?mission_instance - mission_instance ?variant_tag - variant_tag)
    :precondition
      (and
        (mission_interact_stage_one_completed ?mission_instance)
        (mission_has_variant ?mission_instance ?variant_tag)
        (not
          (mission_variant_ready ?mission_instance)
        )
      )
    :effect (mission_variant_ready ?mission_instance)
  )
  (:action complete_tagged_mission_stage
    :parameters (?mission_instance - mission_instance)
    :precondition
      (and
        (mission_variant_ready ?mission_instance)
        (not
          (mission_finalized ?mission_instance)
        )
      )
    :effect
      (and
        (mission_finalized ?mission_instance)
        (task_completion_mark ?mission_instance)
      )
  )
  (:action finalize_infiltration_objective
    :parameters (?infiltration_objective - infiltration_objective ?progression_package - progression_package)
    :precondition
      (and
        (infiltration_checkpoint_flag ?infiltration_objective)
        (infiltration_ready_flag ?infiltration_objective)
        (package_active ?progression_package)
        (package_sealed ?progression_package)
        (not
          (task_completion_mark ?infiltration_objective)
        )
      )
    :effect (task_completion_mark ?infiltration_objective)
  )
  (:action finalize_exfiltration_objective
    :parameters (?exfiltration_objective - exfiltration_objective ?progression_package - progression_package)
    :precondition
      (and
        (exfiltration_checkpoint_flag ?exfiltration_objective)
        (exfiltration_ready_flag ?exfiltration_objective)
        (package_active ?progression_package)
        (package_sealed ?progression_package)
        (not
          (task_completion_mark ?exfiltration_objective)
        )
      )
    :effect (task_completion_mark ?exfiltration_objective)
  )
  (:action prime_objective_with_gating_flag
    :parameters (?objective - objective ?gating_flag - gating_flag ?capability - capability)
    :precondition
      (and
        (task_completion_mark ?objective)
        (task_assigned_capability ?objective ?capability)
        (gating_flag_available ?gating_flag)
        (not
          (task_ready ?objective)
        )
      )
    :effect
      (and
        (task_ready ?objective)
        (task_gating_flag_bound ?objective ?gating_flag)
        (not
          (gating_flag_available ?gating_flag)
        )
      )
  )
  (:action finalize_objective_and_release_token
    :parameters (?infiltration_objective - infiltration_objective ?unlock_token - unlock_token ?gating_flag - gating_flag)
    :precondition
      (and
        (task_ready ?infiltration_objective)
        (task_bound_unlock_token ?infiltration_objective ?unlock_token)
        (task_gating_flag_bound ?infiltration_objective ?gating_flag)
        (not
          (task_completed ?infiltration_objective)
        )
      )
    :effect
      (and
        (task_completed ?infiltration_objective)
        (unlock_token_available ?unlock_token)
        (gating_flag_available ?gating_flag)
      )
  )
  (:action finalize_exfiltration_and_release_token
    :parameters (?exfiltration_objective - exfiltration_objective ?unlock_token - unlock_token ?gating_flag - gating_flag)
    :precondition
      (and
        (task_ready ?exfiltration_objective)
        (task_bound_unlock_token ?exfiltration_objective ?unlock_token)
        (task_gating_flag_bound ?exfiltration_objective ?gating_flag)
        (not
          (task_completed ?exfiltration_objective)
        )
      )
    :effect
      (and
        (task_completed ?exfiltration_objective)
        (unlock_token_available ?unlock_token)
        (gating_flag_available ?gating_flag)
      )
  )
  (:action finalize_mission_and_release_token
    :parameters (?mission_instance - mission_instance ?unlock_token - unlock_token ?gating_flag - gating_flag)
    :precondition
      (and
        (task_ready ?mission_instance)
        (task_bound_unlock_token ?mission_instance ?unlock_token)
        (task_gating_flag_bound ?mission_instance ?gating_flag)
        (not
          (task_completed ?mission_instance)
        )
      )
    :effect
      (and
        (task_completed ?mission_instance)
        (unlock_token_available ?unlock_token)
        (gating_flag_available ?gating_flag)
      )
  )
)

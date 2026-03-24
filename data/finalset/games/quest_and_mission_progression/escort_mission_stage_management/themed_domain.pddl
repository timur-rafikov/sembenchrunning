(define (domain escort_mission_stage_management)
  (:requirements :strips :typing :negative-preconditions)
  (:types role_type - object item_category - object map_element_category - object stage_category - object stage - stage_category escort_asset - role_type objective_condition - role_type support_npc - role_type optional_modifier - role_type bonus_objective - role_type mission_tag - role_type resource_type_a - role_type resource_type_b - role_type resource_token - item_category deliverable_item - item_category condition_trigger_a - item_category checkpoint - map_element_category checkpoint_variant - map_element_category stage_token - map_element_category stage_group - stage stage_variant_group - stage primary_segment - stage_group secondary_segment - stage_group stage_instance - stage_variant_group)
  (:predicates
    (stage_registered ?stage - stage)
    (stage_validated ?stage - stage)
    (stage_has_asset ?stage - stage)
    (stage_completed ?stage - stage)
    (completion_ready ?stage - stage)
    (completion_tagged ?stage - stage)
    (escort_asset_available ?escort_asset - escort_asset)
    (stage_assigned_asset ?stage - stage ?escort_asset - escort_asset)
    (objective_condition_available ?objective_condition - objective_condition)
    (stage_objective_assigned ?stage - stage ?objective_condition - objective_condition)
    (support_npc_available ?support_npc - support_npc)
    (stage_assigned_npc ?stage - stage ?support_npc - support_npc)
    (resource_token_available ?resource_token - resource_token)
    (primary_segment_assigned_resource ?primary_segment - primary_segment ?resource_token - resource_token)
    (secondary_segment_assigned_resource ?secondary_segment - secondary_segment ?resource_token - resource_token)
    (primary_segment_checkpoint ?primary_segment - primary_segment ?checkpoint - checkpoint)
    (checkpoint_triggered ?checkpoint - checkpoint)
    (checkpoint_secured ?checkpoint - checkpoint)
    (primary_segment_ready ?primary_segment - primary_segment)
    (secondary_segment_checkpoint ?secondary_segment - secondary_segment ?checkpoint_variant - checkpoint_variant)
    (checkpoint_variant_triggered ?checkpoint_variant - checkpoint_variant)
    (checkpoint_variant_secured ?checkpoint_variant - checkpoint_variant)
    (secondary_segment_ready ?secondary_segment - secondary_segment)
    (stage_token_available ?stage_token - stage_token)
    (stage_token_assembled ?stage_token - stage_token)
    (stage_token_has_checkpoint ?stage_token - stage_token ?checkpoint - checkpoint)
    (stage_token_has_checkpoint_variant ?stage_token - stage_token ?checkpoint_variant - checkpoint_variant)
    (stage_token_variant_a ?stage_token - stage_token)
    (stage_token_variant_b ?stage_token - stage_token)
    (stage_token_validated ?stage_token - stage_token)
    (instance_has_primary_segment ?stage_instance - stage_instance ?primary_segment - primary_segment)
    (instance_has_secondary_segment ?stage_instance - stage_instance ?secondary_segment - secondary_segment)
    (instance_has_stage_token ?stage_instance - stage_instance ?stage_token - stage_token)
    (deliverable_available ?deliverable_item - deliverable_item)
    (instance_requires_deliverable ?stage_instance - stage_instance ?deliverable_item - deliverable_item)
    (deliverable_processed ?deliverable_item - deliverable_item)
    (deliverable_bound_to_stage_token ?deliverable_item - deliverable_item ?stage_token - stage_token)
    (instance_modifier_attached ?stage_instance - stage_instance)
    (instance_modifier_confirmed ?stage_instance - stage_instance)
    (instance_modifier_finalized ?stage_instance - stage_instance)
    (instance_optional_modifier_attached ?stage_instance - stage_instance)
    (instance_optional_modifier_confirmed ?stage_instance - stage_instance)
    (instance_ready_for_final_stage ?stage_instance - stage_instance)
    (instance_final_checks_passed ?stage_instance - stage_instance)
    (trigger_condition_available ?condition_trigger_a - condition_trigger_a)
    (instance_associated_trigger ?stage_instance - stage_instance ?condition_trigger_a - condition_trigger_a)
    (instance_trigger_unlocked ?stage_instance - stage_instance)
    (conditional_sequence_active ?stage_instance - stage_instance)
    (conditional_sequence_ready ?stage_instance - stage_instance)
    (optional_modifier_available ?optional_modifier - optional_modifier)
    (instance_optional_modifier_assigned ?stage_instance - stage_instance ?optional_modifier - optional_modifier)
    (bonus_objective_available ?bonus_objective - bonus_objective)
    (instance_assigned_bonus_objective ?stage_instance - stage_instance ?bonus_objective - bonus_objective)
    (resource_type_a_available ?resource_type_a - resource_type_a)
    (instance_assigned_resource_type_a ?stage_instance - stage_instance ?resource_type_a - resource_type_a)
    (resource_type_b_available ?resource_type_b - resource_type_b)
    (instance_assigned_resource_type_b ?stage_instance - stage_instance ?resource_type_b - resource_type_b)
    (mission_tag_available ?mission_tag - mission_tag)
    (stage_assigned_tag ?stage - stage ?mission_tag - mission_tag)
    (primary_segment_engaged ?primary_segment - primary_segment)
    (secondary_segment_engaged ?secondary_segment - secondary_segment)
    (instance_finalized ?stage_instance - stage_instance)
  )
  (:action register_stage
    :parameters (?stage - stage)
    :precondition
      (and
        (not
          (stage_registered ?stage)
        )
        (not
          (stage_completed ?stage)
        )
      )
    :effect (stage_registered ?stage)
  )
  (:action assign_escort_asset_to_stage
    :parameters (?stage - stage ?escort_asset - escort_asset)
    :precondition
      (and
        (stage_registered ?stage)
        (not
          (stage_has_asset ?stage)
        )
        (escort_asset_available ?escort_asset)
      )
    :effect
      (and
        (stage_has_asset ?stage)
        (stage_assigned_asset ?stage ?escort_asset)
        (not
          (escort_asset_available ?escort_asset)
        )
      )
  )
  (:action attach_objective_to_stage
    :parameters (?stage - stage ?objective_condition - objective_condition)
    :precondition
      (and
        (stage_registered ?stage)
        (stage_has_asset ?stage)
        (objective_condition_available ?objective_condition)
      )
    :effect
      (and
        (stage_objective_assigned ?stage ?objective_condition)
        (not
          (objective_condition_available ?objective_condition)
        )
      )
  )
  (:action confirm_stage_objective
    :parameters (?stage - stage ?objective_condition - objective_condition)
    :precondition
      (and
        (stage_registered ?stage)
        (stage_has_asset ?stage)
        (stage_objective_assigned ?stage ?objective_condition)
        (not
          (stage_validated ?stage)
        )
      )
    :effect (stage_validated ?stage)
  )
  (:action rollback_stage_objective_binding
    :parameters (?stage - stage ?objective_condition - objective_condition)
    :precondition
      (and
        (stage_objective_assigned ?stage ?objective_condition)
      )
    :effect
      (and
        (objective_condition_available ?objective_condition)
        (not
          (stage_objective_assigned ?stage ?objective_condition)
        )
      )
  )
  (:action attach_support_npc_to_stage
    :parameters (?stage - stage ?support_npc - support_npc)
    :precondition
      (and
        (stage_validated ?stage)
        (support_npc_available ?support_npc)
      )
    :effect
      (and
        (stage_assigned_npc ?stage ?support_npc)
        (not
          (support_npc_available ?support_npc)
        )
      )
  )
  (:action detach_support_npc_from_stage
    :parameters (?stage - stage ?support_npc - support_npc)
    :precondition
      (and
        (stage_assigned_npc ?stage ?support_npc)
      )
    :effect
      (and
        (support_npc_available ?support_npc)
        (not
          (stage_assigned_npc ?stage ?support_npc)
        )
      )
  )
  (:action assign_resource_a_to_instance
    :parameters (?stage_instance - stage_instance ?resource_type_a - resource_type_a)
    :precondition
      (and
        (stage_validated ?stage_instance)
        (resource_type_a_available ?resource_type_a)
      )
    :effect
      (and
        (instance_assigned_resource_type_a ?stage_instance ?resource_type_a)
        (not
          (resource_type_a_available ?resource_type_a)
        )
      )
  )
  (:action unassign_resource_a_from_instance
    :parameters (?stage_instance - stage_instance ?resource_type_a - resource_type_a)
    :precondition
      (and
        (instance_assigned_resource_type_a ?stage_instance ?resource_type_a)
      )
    :effect
      (and
        (resource_type_a_available ?resource_type_a)
        (not
          (instance_assigned_resource_type_a ?stage_instance ?resource_type_a)
        )
      )
  )
  (:action assign_resource_b_to_instance
    :parameters (?stage_instance - stage_instance ?resource_type_b - resource_type_b)
    :precondition
      (and
        (stage_validated ?stage_instance)
        (resource_type_b_available ?resource_type_b)
      )
    :effect
      (and
        (instance_assigned_resource_type_b ?stage_instance ?resource_type_b)
        (not
          (resource_type_b_available ?resource_type_b)
        )
      )
  )
  (:action unassign_resource_b_from_instance
    :parameters (?stage_instance - stage_instance ?resource_type_b - resource_type_b)
    :precondition
      (and
        (instance_assigned_resource_type_b ?stage_instance ?resource_type_b)
      )
    :effect
      (and
        (resource_type_b_available ?resource_type_b)
        (not
          (instance_assigned_resource_type_b ?stage_instance ?resource_type_b)
        )
      )
  )
  (:action activate_checkpoint_for_primary_segment
    :parameters (?primary_segment - primary_segment ?checkpoint - checkpoint ?objective_condition - objective_condition)
    :precondition
      (and
        (stage_validated ?primary_segment)
        (stage_objective_assigned ?primary_segment ?objective_condition)
        (primary_segment_checkpoint ?primary_segment ?checkpoint)
        (not
          (checkpoint_triggered ?checkpoint)
        )
        (not
          (checkpoint_secured ?checkpoint)
        )
      )
    :effect (checkpoint_triggered ?checkpoint)
  )
  (:action engage_primary_segment_with_support
    :parameters (?primary_segment - primary_segment ?checkpoint - checkpoint ?support_npc - support_npc)
    :precondition
      (and
        (stage_validated ?primary_segment)
        (stage_assigned_npc ?primary_segment ?support_npc)
        (primary_segment_checkpoint ?primary_segment ?checkpoint)
        (checkpoint_triggered ?checkpoint)
        (not
          (primary_segment_engaged ?primary_segment)
        )
      )
    :effect
      (and
        (primary_segment_engaged ?primary_segment)
        (primary_segment_ready ?primary_segment)
      )
  )
  (:action assign_resource_token_to_primary_segment
    :parameters (?primary_segment - primary_segment ?checkpoint - checkpoint ?resource_token - resource_token)
    :precondition
      (and
        (stage_validated ?primary_segment)
        (primary_segment_checkpoint ?primary_segment ?checkpoint)
        (resource_token_available ?resource_token)
        (not
          (primary_segment_engaged ?primary_segment)
        )
      )
    :effect
      (and
        (checkpoint_secured ?checkpoint)
        (primary_segment_engaged ?primary_segment)
        (primary_segment_assigned_resource ?primary_segment ?resource_token)
        (not
          (resource_token_available ?resource_token)
        )
      )
  )
  (:action process_primary_segment_checkpoint_and_resource
    :parameters (?primary_segment - primary_segment ?checkpoint - checkpoint ?objective_condition - objective_condition ?resource_token - resource_token)
    :precondition
      (and
        (stage_validated ?primary_segment)
        (stage_objective_assigned ?primary_segment ?objective_condition)
        (primary_segment_checkpoint ?primary_segment ?checkpoint)
        (checkpoint_secured ?checkpoint)
        (primary_segment_assigned_resource ?primary_segment ?resource_token)
        (not
          (primary_segment_ready ?primary_segment)
        )
      )
    :effect
      (and
        (checkpoint_triggered ?checkpoint)
        (primary_segment_ready ?primary_segment)
        (resource_token_available ?resource_token)
        (not
          (primary_segment_assigned_resource ?primary_segment ?resource_token)
        )
      )
  )
  (:action activate_checkpoint_for_secondary_segment
    :parameters (?secondary_segment - secondary_segment ?checkpoint_variant - checkpoint_variant ?objective_condition - objective_condition)
    :precondition
      (and
        (stage_validated ?secondary_segment)
        (stage_objective_assigned ?secondary_segment ?objective_condition)
        (secondary_segment_checkpoint ?secondary_segment ?checkpoint_variant)
        (not
          (checkpoint_variant_triggered ?checkpoint_variant)
        )
        (not
          (checkpoint_variant_secured ?checkpoint_variant)
        )
      )
    :effect (checkpoint_variant_triggered ?checkpoint_variant)
  )
  (:action engage_secondary_segment_with_support
    :parameters (?secondary_segment - secondary_segment ?checkpoint_variant - checkpoint_variant ?support_npc - support_npc)
    :precondition
      (and
        (stage_validated ?secondary_segment)
        (stage_assigned_npc ?secondary_segment ?support_npc)
        (secondary_segment_checkpoint ?secondary_segment ?checkpoint_variant)
        (checkpoint_variant_triggered ?checkpoint_variant)
        (not
          (secondary_segment_engaged ?secondary_segment)
        )
      )
    :effect
      (and
        (secondary_segment_engaged ?secondary_segment)
        (secondary_segment_ready ?secondary_segment)
      )
  )
  (:action assign_resource_token_to_secondary_segment
    :parameters (?secondary_segment - secondary_segment ?checkpoint_variant - checkpoint_variant ?resource_token - resource_token)
    :precondition
      (and
        (stage_validated ?secondary_segment)
        (secondary_segment_checkpoint ?secondary_segment ?checkpoint_variant)
        (resource_token_available ?resource_token)
        (not
          (secondary_segment_engaged ?secondary_segment)
        )
      )
    :effect
      (and
        (checkpoint_variant_secured ?checkpoint_variant)
        (secondary_segment_engaged ?secondary_segment)
        (secondary_segment_assigned_resource ?secondary_segment ?resource_token)
        (not
          (resource_token_available ?resource_token)
        )
      )
  )
  (:action process_secondary_segment_checkpoint_and_resource
    :parameters (?secondary_segment - secondary_segment ?checkpoint_variant - checkpoint_variant ?objective_condition - objective_condition ?resource_token - resource_token)
    :precondition
      (and
        (stage_validated ?secondary_segment)
        (stage_objective_assigned ?secondary_segment ?objective_condition)
        (secondary_segment_checkpoint ?secondary_segment ?checkpoint_variant)
        (checkpoint_variant_secured ?checkpoint_variant)
        (secondary_segment_assigned_resource ?secondary_segment ?resource_token)
        (not
          (secondary_segment_ready ?secondary_segment)
        )
      )
    :effect
      (and
        (checkpoint_variant_triggered ?checkpoint_variant)
        (secondary_segment_ready ?secondary_segment)
        (resource_token_available ?resource_token)
        (not
          (secondary_segment_assigned_resource ?secondary_segment ?resource_token)
        )
      )
  )
  (:action assemble_stage_token
    :parameters (?primary_segment - primary_segment ?secondary_segment - secondary_segment ?checkpoint - checkpoint ?checkpoint_variant - checkpoint_variant ?stage_token - stage_token)
    :precondition
      (and
        (primary_segment_engaged ?primary_segment)
        (secondary_segment_engaged ?secondary_segment)
        (primary_segment_checkpoint ?primary_segment ?checkpoint)
        (secondary_segment_checkpoint ?secondary_segment ?checkpoint_variant)
        (checkpoint_triggered ?checkpoint)
        (checkpoint_variant_triggered ?checkpoint_variant)
        (primary_segment_ready ?primary_segment)
        (secondary_segment_ready ?secondary_segment)
        (stage_token_available ?stage_token)
      )
    :effect
      (and
        (stage_token_assembled ?stage_token)
        (stage_token_has_checkpoint ?stage_token ?checkpoint)
        (stage_token_has_checkpoint_variant ?stage_token ?checkpoint_variant)
        (not
          (stage_token_available ?stage_token)
        )
      )
  )
  (:action assemble_stage_token_variant_a
    :parameters (?primary_segment - primary_segment ?secondary_segment - secondary_segment ?checkpoint - checkpoint ?checkpoint_variant - checkpoint_variant ?stage_token - stage_token)
    :precondition
      (and
        (primary_segment_engaged ?primary_segment)
        (secondary_segment_engaged ?secondary_segment)
        (primary_segment_checkpoint ?primary_segment ?checkpoint)
        (secondary_segment_checkpoint ?secondary_segment ?checkpoint_variant)
        (checkpoint_secured ?checkpoint)
        (checkpoint_variant_triggered ?checkpoint_variant)
        (not
          (primary_segment_ready ?primary_segment)
        )
        (secondary_segment_ready ?secondary_segment)
        (stage_token_available ?stage_token)
      )
    :effect
      (and
        (stage_token_assembled ?stage_token)
        (stage_token_has_checkpoint ?stage_token ?checkpoint)
        (stage_token_has_checkpoint_variant ?stage_token ?checkpoint_variant)
        (stage_token_variant_a ?stage_token)
        (not
          (stage_token_available ?stage_token)
        )
      )
  )
  (:action assemble_stage_token_variant_b
    :parameters (?primary_segment - primary_segment ?secondary_segment - secondary_segment ?checkpoint - checkpoint ?checkpoint_variant - checkpoint_variant ?stage_token - stage_token)
    :precondition
      (and
        (primary_segment_engaged ?primary_segment)
        (secondary_segment_engaged ?secondary_segment)
        (primary_segment_checkpoint ?primary_segment ?checkpoint)
        (secondary_segment_checkpoint ?secondary_segment ?checkpoint_variant)
        (checkpoint_triggered ?checkpoint)
        (checkpoint_variant_secured ?checkpoint_variant)
        (primary_segment_ready ?primary_segment)
        (not
          (secondary_segment_ready ?secondary_segment)
        )
        (stage_token_available ?stage_token)
      )
    :effect
      (and
        (stage_token_assembled ?stage_token)
        (stage_token_has_checkpoint ?stage_token ?checkpoint)
        (stage_token_has_checkpoint_variant ?stage_token ?checkpoint_variant)
        (stage_token_variant_b ?stage_token)
        (not
          (stage_token_available ?stage_token)
        )
      )
  )
  (:action assemble_stage_token_variant_ab
    :parameters (?primary_segment - primary_segment ?secondary_segment - secondary_segment ?checkpoint - checkpoint ?checkpoint_variant - checkpoint_variant ?stage_token - stage_token)
    :precondition
      (and
        (primary_segment_engaged ?primary_segment)
        (secondary_segment_engaged ?secondary_segment)
        (primary_segment_checkpoint ?primary_segment ?checkpoint)
        (secondary_segment_checkpoint ?secondary_segment ?checkpoint_variant)
        (checkpoint_secured ?checkpoint)
        (checkpoint_variant_secured ?checkpoint_variant)
        (not
          (primary_segment_ready ?primary_segment)
        )
        (not
          (secondary_segment_ready ?secondary_segment)
        )
        (stage_token_available ?stage_token)
      )
    :effect
      (and
        (stage_token_assembled ?stage_token)
        (stage_token_has_checkpoint ?stage_token ?checkpoint)
        (stage_token_has_checkpoint_variant ?stage_token ?checkpoint_variant)
        (stage_token_variant_a ?stage_token)
        (stage_token_variant_b ?stage_token)
        (not
          (stage_token_available ?stage_token)
        )
      )
  )
  (:action validate_stage_token
    :parameters (?stage_token - stage_token ?primary_segment - primary_segment ?objective_condition - objective_condition)
    :precondition
      (and
        (stage_token_assembled ?stage_token)
        (primary_segment_engaged ?primary_segment)
        (stage_objective_assigned ?primary_segment ?objective_condition)
        (not
          (stage_token_validated ?stage_token)
        )
      )
    :effect (stage_token_validated ?stage_token)
  )
  (:action register_deliverable_on_instance
    :parameters (?stage_instance - stage_instance ?deliverable_item - deliverable_item ?stage_token - stage_token)
    :precondition
      (and
        (stage_validated ?stage_instance)
        (instance_has_stage_token ?stage_instance ?stage_token)
        (instance_requires_deliverable ?stage_instance ?deliverable_item)
        (deliverable_available ?deliverable_item)
        (stage_token_assembled ?stage_token)
        (stage_token_validated ?stage_token)
        (not
          (deliverable_processed ?deliverable_item)
        )
      )
    :effect
      (and
        (deliverable_processed ?deliverable_item)
        (deliverable_bound_to_stage_token ?deliverable_item ?stage_token)
        (not
          (deliverable_available ?deliverable_item)
        )
      )
  )
  (:action verify_deliverable_for_instance
    :parameters (?stage_instance - stage_instance ?deliverable_item - deliverable_item ?stage_token - stage_token ?objective_condition - objective_condition)
    :precondition
      (and
        (stage_validated ?stage_instance)
        (instance_requires_deliverable ?stage_instance ?deliverable_item)
        (deliverable_processed ?deliverable_item)
        (deliverable_bound_to_stage_token ?deliverable_item ?stage_token)
        (stage_objective_assigned ?stage_instance ?objective_condition)
        (not
          (stage_token_variant_a ?stage_token)
        )
        (not
          (instance_modifier_attached ?stage_instance)
        )
      )
    :effect (instance_modifier_attached ?stage_instance)
  )
  (:action attach_optional_modifier_to_instance
    :parameters (?stage_instance - stage_instance ?optional_modifier - optional_modifier)
    :precondition
      (and
        (stage_validated ?stage_instance)
        (optional_modifier_available ?optional_modifier)
        (not
          (instance_optional_modifier_attached ?stage_instance)
        )
      )
    :effect
      (and
        (instance_optional_modifier_attached ?stage_instance)
        (instance_optional_modifier_assigned ?stage_instance ?optional_modifier)
        (not
          (optional_modifier_available ?optional_modifier)
        )
      )
  )
  (:action apply_optional_modifier_with_token
    :parameters (?stage_instance - stage_instance ?deliverable_item - deliverable_item ?stage_token - stage_token ?objective_condition - objective_condition ?optional_modifier - optional_modifier)
    :precondition
      (and
        (stage_validated ?stage_instance)
        (instance_requires_deliverable ?stage_instance ?deliverable_item)
        (deliverable_processed ?deliverable_item)
        (deliverable_bound_to_stage_token ?deliverable_item ?stage_token)
        (stage_objective_assigned ?stage_instance ?objective_condition)
        (stage_token_variant_a ?stage_token)
        (instance_optional_modifier_attached ?stage_instance)
        (instance_optional_modifier_assigned ?stage_instance ?optional_modifier)
        (not
          (instance_modifier_attached ?stage_instance)
        )
      )
    :effect
      (and
        (instance_modifier_attached ?stage_instance)
        (instance_optional_modifier_confirmed ?stage_instance)
      )
  )
  (:action advance_optional_modifier_stage
    :parameters (?stage_instance - stage_instance ?resource_type_a - resource_type_a ?support_npc - support_npc ?deliverable_item - deliverable_item ?stage_token - stage_token)
    :precondition
      (and
        (instance_modifier_attached ?stage_instance)
        (instance_assigned_resource_type_a ?stage_instance ?resource_type_a)
        (stage_assigned_npc ?stage_instance ?support_npc)
        (instance_requires_deliverable ?stage_instance ?deliverable_item)
        (deliverable_bound_to_stage_token ?deliverable_item ?stage_token)
        (not
          (stage_token_variant_b ?stage_token)
        )
        (not
          (instance_modifier_confirmed ?stage_instance)
        )
      )
    :effect (instance_modifier_confirmed ?stage_instance)
  )
  (:action complete_optional_modifier_stage
    :parameters (?stage_instance - stage_instance ?resource_type_a - resource_type_a ?support_npc - support_npc ?deliverable_item - deliverable_item ?stage_token - stage_token)
    :precondition
      (and
        (instance_modifier_attached ?stage_instance)
        (instance_assigned_resource_type_a ?stage_instance ?resource_type_a)
        (stage_assigned_npc ?stage_instance ?support_npc)
        (instance_requires_deliverable ?stage_instance ?deliverable_item)
        (deliverable_bound_to_stage_token ?deliverable_item ?stage_token)
        (stage_token_variant_b ?stage_token)
        (not
          (instance_modifier_confirmed ?stage_instance)
        )
      )
    :effect (instance_modifier_confirmed ?stage_instance)
  )
  (:action enable_modifier_finalization_phase_one
    :parameters (?stage_instance - stage_instance ?resource_type_b - resource_type_b ?deliverable_item - deliverable_item ?stage_token - stage_token)
    :precondition
      (and
        (instance_modifier_confirmed ?stage_instance)
        (instance_assigned_resource_type_b ?stage_instance ?resource_type_b)
        (instance_requires_deliverable ?stage_instance ?deliverable_item)
        (deliverable_bound_to_stage_token ?deliverable_item ?stage_token)
        (not
          (stage_token_variant_a ?stage_token)
        )
        (not
          (stage_token_variant_b ?stage_token)
        )
        (not
          (instance_modifier_finalized ?stage_instance)
        )
      )
    :effect (instance_modifier_finalized ?stage_instance)
  )
  (:action enable_modifier_finalization_phase_two
    :parameters (?stage_instance - stage_instance ?resource_type_b - resource_type_b ?deliverable_item - deliverable_item ?stage_token - stage_token)
    :precondition
      (and
        (instance_modifier_confirmed ?stage_instance)
        (instance_assigned_resource_type_b ?stage_instance ?resource_type_b)
        (instance_requires_deliverable ?stage_instance ?deliverable_item)
        (deliverable_bound_to_stage_token ?deliverable_item ?stage_token)
        (stage_token_variant_a ?stage_token)
        (not
          (stage_token_variant_b ?stage_token)
        )
        (not
          (instance_modifier_finalized ?stage_instance)
        )
      )
    :effect
      (and
        (instance_modifier_finalized ?stage_instance)
        (instance_ready_for_final_stage ?stage_instance)
      )
  )
  (:action enable_modifier_finalization_phase_three
    :parameters (?stage_instance - stage_instance ?resource_type_b - resource_type_b ?deliverable_item - deliverable_item ?stage_token - stage_token)
    :precondition
      (and
        (instance_modifier_confirmed ?stage_instance)
        (instance_assigned_resource_type_b ?stage_instance ?resource_type_b)
        (instance_requires_deliverable ?stage_instance ?deliverable_item)
        (deliverable_bound_to_stage_token ?deliverable_item ?stage_token)
        (not
          (stage_token_variant_a ?stage_token)
        )
        (stage_token_variant_b ?stage_token)
        (not
          (instance_modifier_finalized ?stage_instance)
        )
      )
    :effect
      (and
        (instance_modifier_finalized ?stage_instance)
        (instance_ready_for_final_stage ?stage_instance)
      )
  )
  (:action enable_modifier_finalization_phase_four
    :parameters (?stage_instance - stage_instance ?resource_type_b - resource_type_b ?deliverable_item - deliverable_item ?stage_token - stage_token)
    :precondition
      (and
        (instance_modifier_confirmed ?stage_instance)
        (instance_assigned_resource_type_b ?stage_instance ?resource_type_b)
        (instance_requires_deliverable ?stage_instance ?deliverable_item)
        (deliverable_bound_to_stage_token ?deliverable_item ?stage_token)
        (stage_token_variant_a ?stage_token)
        (stage_token_variant_b ?stage_token)
        (not
          (instance_modifier_finalized ?stage_instance)
        )
      )
    :effect
      (and
        (instance_modifier_finalized ?stage_instance)
        (instance_ready_for_final_stage ?stage_instance)
      )
  )
  (:action apply_finalization_precheck
    :parameters (?stage_instance - stage_instance)
    :precondition
      (and
        (instance_modifier_finalized ?stage_instance)
        (not
          (instance_ready_for_final_stage ?stage_instance)
        )
        (not
          (instance_finalized ?stage_instance)
        )
      )
    :effect
      (and
        (instance_finalized ?stage_instance)
        (completion_ready ?stage_instance)
      )
  )
  (:action attach_bonus_objective_to_instance
    :parameters (?stage_instance - stage_instance ?bonus_objective - bonus_objective)
    :precondition
      (and
        (instance_modifier_finalized ?stage_instance)
        (instance_ready_for_final_stage ?stage_instance)
        (bonus_objective_available ?bonus_objective)
      )
    :effect
      (and
        (instance_assigned_bonus_objective ?stage_instance ?bonus_objective)
        (not
          (bonus_objective_available ?bonus_objective)
        )
      )
  )
  (:action perform_instance_final_checks
    :parameters (?stage_instance - stage_instance ?primary_segment - primary_segment ?secondary_segment - secondary_segment ?objective_condition - objective_condition ?bonus_objective - bonus_objective)
    :precondition
      (and
        (instance_modifier_finalized ?stage_instance)
        (instance_ready_for_final_stage ?stage_instance)
        (instance_assigned_bonus_objective ?stage_instance ?bonus_objective)
        (instance_has_primary_segment ?stage_instance ?primary_segment)
        (instance_has_secondary_segment ?stage_instance ?secondary_segment)
        (primary_segment_ready ?primary_segment)
        (secondary_segment_ready ?secondary_segment)
        (stage_objective_assigned ?stage_instance ?objective_condition)
        (not
          (instance_final_checks_passed ?stage_instance)
        )
      )
    :effect (instance_final_checks_passed ?stage_instance)
  )
  (:action confirm_instance_finalization
    :parameters (?stage_instance - stage_instance)
    :precondition
      (and
        (instance_modifier_finalized ?stage_instance)
        (instance_final_checks_passed ?stage_instance)
        (not
          (instance_finalized ?stage_instance)
        )
      )
    :effect
      (and
        (instance_finalized ?stage_instance)
        (completion_ready ?stage_instance)
      )
  )
  (:action unlock_conditional_sequence_with_trigger
    :parameters (?stage_instance - stage_instance ?condition_trigger_a - condition_trigger_a ?objective_condition - objective_condition)
    :precondition
      (and
        (stage_validated ?stage_instance)
        (stage_objective_assigned ?stage_instance ?objective_condition)
        (trigger_condition_available ?condition_trigger_a)
        (instance_associated_trigger ?stage_instance ?condition_trigger_a)
        (not
          (instance_trigger_unlocked ?stage_instance)
        )
      )
    :effect
      (and
        (instance_trigger_unlocked ?stage_instance)
        (not
          (trigger_condition_available ?condition_trigger_a)
        )
      )
  )
  (:action activate_conditional_sequence_step
    :parameters (?stage_instance - stage_instance ?support_npc - support_npc)
    :precondition
      (and
        (instance_trigger_unlocked ?stage_instance)
        (stage_assigned_npc ?stage_instance ?support_npc)
        (not
          (conditional_sequence_active ?stage_instance)
        )
      )
    :effect (conditional_sequence_active ?stage_instance)
  )
  (:action confirm_conditional_sequence_resource_check
    :parameters (?stage_instance - stage_instance ?resource_type_b - resource_type_b)
    :precondition
      (and
        (conditional_sequence_active ?stage_instance)
        (instance_assigned_resource_type_b ?stage_instance ?resource_type_b)
        (not
          (conditional_sequence_ready ?stage_instance)
        )
      )
    :effect (conditional_sequence_ready ?stage_instance)
  )
  (:action finalize_conditional_sequence
    :parameters (?stage_instance - stage_instance)
    :precondition
      (and
        (conditional_sequence_ready ?stage_instance)
        (not
          (instance_finalized ?stage_instance)
        )
      )
    :effect
      (and
        (instance_finalized ?stage_instance)
        (completion_ready ?stage_instance)
      )
  )
  (:action mark_primary_segment_completion
    :parameters (?primary_segment - primary_segment ?stage_token - stage_token)
    :precondition
      (and
        (primary_segment_engaged ?primary_segment)
        (primary_segment_ready ?primary_segment)
        (stage_token_assembled ?stage_token)
        (stage_token_validated ?stage_token)
        (not
          (completion_ready ?primary_segment)
        )
      )
    :effect (completion_ready ?primary_segment)
  )
  (:action mark_secondary_segment_completion
    :parameters (?secondary_segment - secondary_segment ?stage_token - stage_token)
    :precondition
      (and
        (secondary_segment_engaged ?secondary_segment)
        (secondary_segment_ready ?secondary_segment)
        (stage_token_assembled ?stage_token)
        (stage_token_validated ?stage_token)
        (not
          (completion_ready ?secondary_segment)
        )
      )
    :effect (completion_ready ?secondary_segment)
  )
  (:action assign_mission_tag_to_stage
    :parameters (?stage - stage ?mission_tag - mission_tag ?objective_condition - objective_condition)
    :precondition
      (and
        (completion_ready ?stage)
        (stage_objective_assigned ?stage ?objective_condition)
        (mission_tag_available ?mission_tag)
        (not
          (completion_tagged ?stage)
        )
      )
    :effect
      (and
        (completion_tagged ?stage)
        (stage_assigned_tag ?stage ?mission_tag)
        (not
          (mission_tag_available ?mission_tag)
        )
      )
  )
  (:action finalize_primary_segment_completion_with_tag
    :parameters (?primary_segment - primary_segment ?escort_asset - escort_asset ?mission_tag - mission_tag)
    :precondition
      (and
        (completion_tagged ?primary_segment)
        (stage_assigned_asset ?primary_segment ?escort_asset)
        (stage_assigned_tag ?primary_segment ?mission_tag)
        (not
          (stage_completed ?primary_segment)
        )
      )
    :effect
      (and
        (stage_completed ?primary_segment)
        (escort_asset_available ?escort_asset)
        (mission_tag_available ?mission_tag)
      )
  )
  (:action finalize_secondary_segment_completion_with_tag
    :parameters (?secondary_segment - secondary_segment ?escort_asset - escort_asset ?mission_tag - mission_tag)
    :precondition
      (and
        (completion_tagged ?secondary_segment)
        (stage_assigned_asset ?secondary_segment ?escort_asset)
        (stage_assigned_tag ?secondary_segment ?mission_tag)
        (not
          (stage_completed ?secondary_segment)
        )
      )
    :effect
      (and
        (stage_completed ?secondary_segment)
        (escort_asset_available ?escort_asset)
        (mission_tag_available ?mission_tag)
      )
  )
  (:action finalize_instance_completion_with_tag
    :parameters (?stage_instance - stage_instance ?escort_asset - escort_asset ?mission_tag - mission_tag)
    :precondition
      (and
        (completion_tagged ?stage_instance)
        (stage_assigned_asset ?stage_instance ?escort_asset)
        (stage_assigned_tag ?stage_instance ?mission_tag)
        (not
          (stage_completed ?stage_instance)
        )
      )
    :effect
      (and
        (stage_completed ?stage_instance)
        (escort_asset_available ?escort_asset)
        (mission_tag_available ?mission_tag)
      )
  )
)

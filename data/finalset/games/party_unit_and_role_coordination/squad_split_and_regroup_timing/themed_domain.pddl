(define (domain squad_split_and_regroup)
  (:requirements :strips :typing :negative-preconditions)
  (:types aux_resource_category - object assignable_resource - object spatial_marker - object squad_entity - object squad_member - squad_entity controller_token - aux_resource_category engagement_task - aux_resource_category support_action - aux_resource_category configuration_choice - aux_resource_category specialization_slot - aux_resource_category timing_token - aux_resource_category equipment_unit - aux_resource_category conditional_modifier - aux_resource_category consumable_item - assignable_resource staged_asset - assignable_resource strategy_card - assignable_resource anchor_point_a - spatial_marker anchor_point_b - spatial_marker regroup_beacon - spatial_marker subgroup_role - squad_member controller_role_group - squad_member subgroup_a_member - subgroup_role subgroup_b_member - subgroup_role squad_controller - controller_role_group)
  (:predicates
    (member_registered ?member - squad_member)
    (participant_committed ?member - squad_member)
    (member_has_controller_binding ?member - squad_member)
    (entity_ready_for_regroup ?member - squad_member)
    (readiness_committed ?member - squad_member)
    (timing_committed ?member - squad_member)
    (controller_token_available ?controller_token - controller_token)
    (bound_to_controller_token ?member - squad_member ?controller_token - controller_token)
    (task_available ?task - engagement_task)
    (assigned_task ?member - squad_member ?task - engagement_task)
    (support_action_available ?support_action - support_action)
    (assigned_support_action ?member - squad_member ?support_action - support_action)
    (consumable_available ?consumable_item - consumable_item)
    (member_a_has_consumable ?member_a - subgroup_a_member ?consumable_item - consumable_item)
    (member_b_has_consumable ?member_b - subgroup_b_member ?consumable_item - consumable_item)
    (member_a_linked_anchor ?member_a - subgroup_a_member ?anchor_a - anchor_point_a)
    (anchor_a_proposed ?anchor_a - anchor_point_a)
    (anchor_a_consumable_attached ?anchor_a - anchor_point_a)
    (member_a_local_ready ?member_a - subgroup_a_member)
    (member_b_linked_anchor ?member_b - subgroup_b_member ?anchor_b - anchor_point_b)
    (anchor_b_proposed ?anchor_b - anchor_point_b)
    (anchor_b_consumable_attached ?anchor_b - anchor_point_b)
    (member_b_local_ready ?member_b - subgroup_b_member)
    (beacon_available ?regroup_beacon - regroup_beacon)
    (beacon_activated ?regroup_beacon - regroup_beacon)
    (beacon_link_anchor_a ?regroup_beacon - regroup_beacon ?anchor_a - anchor_point_a)
    (beacon_link_anchor_b ?regroup_beacon - regroup_beacon ?anchor_b - anchor_point_b)
    (beacon_option_anchor_a ?regroup_beacon - regroup_beacon)
    (beacon_option_anchor_b ?regroup_beacon - regroup_beacon)
    (beacon_locked ?regroup_beacon - regroup_beacon)
    (controller_assigned_member_a ?controller - squad_controller ?member_a - subgroup_a_member)
    (controller_assigned_member_b ?controller - squad_controller ?member_b - subgroup_b_member)
    (controller_linked_beacon ?controller - squad_controller ?regroup_beacon - regroup_beacon)
    (staged_asset_available ?staged_asset - staged_asset)
    (controller_has_staged_asset ?controller - squad_controller ?staged_asset - staged_asset)
    (staged_asset_reserved ?staged_asset - staged_asset)
    (staged_asset_linked_beacon ?staged_asset - staged_asset ?regroup_beacon - regroup_beacon)
    (controller_staging_confirmed ?controller - squad_controller)
    (controller_asset_verified ?controller - squad_controller)
    (controller_finalization_in_progress ?controller - squad_controller)
    (controller_config_selected ?controller - squad_controller)
    (controller_config_applied ?controller - squad_controller)
    (controller_config_confirmed ?controller - squad_controller)
    (controller_ready_for_commit ?controller - squad_controller)
    (strategy_card_available ?strategy_card - strategy_card)
    (controller_has_strategy_card ?controller - squad_controller ?strategy_card - strategy_card)
    (controller_strategy_selected ?controller - squad_controller)
    (controller_config_step_completed ?controller - squad_controller)
    (controller_final_step_completed ?controller - squad_controller)
    (configuration_choice_available ?configuration_choice - configuration_choice)
    (controller_has_configuration_choice ?controller - squad_controller ?configuration_choice - configuration_choice)
    (specialization_slot_available ?specialization_slot - specialization_slot)
    (controller_assigned_specialization ?controller - squad_controller ?specialization_slot - specialization_slot)
    (equipment_unit_available ?equipment_unit - equipment_unit)
    (controller_has_equipment_unit ?controller - squad_controller ?equipment_unit - equipment_unit)
    (conditional_modifier_available ?conditional_modifier - conditional_modifier)
    (controller_has_conditional_modifier ?controller - squad_controller ?conditional_modifier - conditional_modifier)
    (timing_token_available ?timing_token - timing_token)
    (assigned_timing_token ?member - squad_member ?timing_token - timing_token)
    (member_a_prepared ?member_a - subgroup_a_member)
    (member_b_prepared ?member_b - subgroup_b_member)
    (controller_finalized ?controller - squad_controller)
  )
  (:action register_member
    :parameters (?member - squad_member)
    :precondition
      (and
        (not
          (member_registered ?member)
        )
        (not
          (entity_ready_for_regroup ?member)
        )
      )
    :effect (member_registered ?member)
  )
  (:action assign_controller_token
    :parameters (?member - squad_member ?controller_token - controller_token)
    :precondition
      (and
        (member_registered ?member)
        (not
          (member_has_controller_binding ?member)
        )
        (controller_token_available ?controller_token)
      )
    :effect
      (and
        (member_has_controller_binding ?member)
        (bound_to_controller_token ?member ?controller_token)
        (not
          (controller_token_available ?controller_token)
        )
      )
  )
  (:action assign_engagement_task
    :parameters (?member - squad_member ?task - engagement_task)
    :precondition
      (and
        (member_registered ?member)
        (member_has_controller_binding ?member)
        (task_available ?task)
      )
    :effect
      (and
        (assigned_task ?member ?task)
        (not
          (task_available ?task)
        )
      )
  )
  (:action confirm_task_assignment
    :parameters (?member - squad_member ?task - engagement_task)
    :precondition
      (and
        (member_registered ?member)
        (member_has_controller_binding ?member)
        (assigned_task ?member ?task)
        (not
          (participant_committed ?member)
        )
      )
    :effect (participant_committed ?member)
  )
  (:action release_task_assignment
    :parameters (?member - squad_member ?task - engagement_task)
    :precondition
      (and
        (assigned_task ?member ?task)
      )
    :effect
      (and
        (task_available ?task)
        (not
          (assigned_task ?member ?task)
        )
      )
  )
  (:action assign_support_action
    :parameters (?member - squad_member ?support_action - support_action)
    :precondition
      (and
        (participant_committed ?member)
        (support_action_available ?support_action)
      )
    :effect
      (and
        (assigned_support_action ?member ?support_action)
        (not
          (support_action_available ?support_action)
        )
      )
  )
  (:action release_support_action
    :parameters (?member - squad_member ?support_action - support_action)
    :precondition
      (and
        (assigned_support_action ?member ?support_action)
      )
    :effect
      (and
        (support_action_available ?support_action)
        (not
          (assigned_support_action ?member ?support_action)
        )
      )
  )
  (:action controller_claim_equipment
    :parameters (?controller - squad_controller ?equipment_unit - equipment_unit)
    :precondition
      (and
        (participant_committed ?controller)
        (equipment_unit_available ?equipment_unit)
      )
    :effect
      (and
        (controller_has_equipment_unit ?controller ?equipment_unit)
        (not
          (equipment_unit_available ?equipment_unit)
        )
      )
  )
  (:action controller_release_equipment
    :parameters (?controller - squad_controller ?equipment_unit - equipment_unit)
    :precondition
      (and
        (controller_has_equipment_unit ?controller ?equipment_unit)
      )
    :effect
      (and
        (equipment_unit_available ?equipment_unit)
        (not
          (controller_has_equipment_unit ?controller ?equipment_unit)
        )
      )
  )
  (:action controller_claim_modifier
    :parameters (?controller - squad_controller ?conditional_modifier - conditional_modifier)
    :precondition
      (and
        (participant_committed ?controller)
        (conditional_modifier_available ?conditional_modifier)
      )
    :effect
      (and
        (controller_has_conditional_modifier ?controller ?conditional_modifier)
        (not
          (conditional_modifier_available ?conditional_modifier)
        )
      )
  )
  (:action controller_release_modifier
    :parameters (?controller - squad_controller ?conditional_modifier - conditional_modifier)
    :precondition
      (and
        (controller_has_conditional_modifier ?controller ?conditional_modifier)
      )
    :effect
      (and
        (conditional_modifier_available ?conditional_modifier)
        (not
          (controller_has_conditional_modifier ?controller ?conditional_modifier)
        )
      )
  )
  (:action propose_anchor_a
    :parameters (?member_a - subgroup_a_member ?anchor_a - anchor_point_a ?task - engagement_task)
    :precondition
      (and
        (participant_committed ?member_a)
        (assigned_task ?member_a ?task)
        (member_a_linked_anchor ?member_a ?anchor_a)
        (not
          (anchor_a_proposed ?anchor_a)
        )
        (not
          (anchor_a_consumable_attached ?anchor_a)
        )
      )
    :effect (anchor_a_proposed ?anchor_a)
  )
  (:action attach_support_to_member_a
    :parameters (?member_a - subgroup_a_member ?anchor_a - anchor_point_a ?support_action - support_action)
    :precondition
      (and
        (participant_committed ?member_a)
        (assigned_support_action ?member_a ?support_action)
        (member_a_linked_anchor ?member_a ?anchor_a)
        (anchor_a_proposed ?anchor_a)
        (not
          (member_a_prepared ?member_a)
        )
      )
    :effect
      (and
        (member_a_prepared ?member_a)
        (member_a_local_ready ?member_a)
      )
  )
  (:action use_consumable_for_member_a
    :parameters (?member_a - subgroup_a_member ?anchor_a - anchor_point_a ?consumable_item - consumable_item)
    :precondition
      (and
        (participant_committed ?member_a)
        (member_a_linked_anchor ?member_a ?anchor_a)
        (consumable_available ?consumable_item)
        (not
          (member_a_prepared ?member_a)
        )
      )
    :effect
      (and
        (anchor_a_consumable_attached ?anchor_a)
        (member_a_prepared ?member_a)
        (member_a_has_consumable ?member_a ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action finalize_member_a_anchor
    :parameters (?member_a - subgroup_a_member ?anchor_a - anchor_point_a ?task - engagement_task ?consumable_item - consumable_item)
    :precondition
      (and
        (participant_committed ?member_a)
        (assigned_task ?member_a ?task)
        (member_a_linked_anchor ?member_a ?anchor_a)
        (anchor_a_consumable_attached ?anchor_a)
        (member_a_has_consumable ?member_a ?consumable_item)
        (not
          (member_a_local_ready ?member_a)
        )
      )
    :effect
      (and
        (anchor_a_proposed ?anchor_a)
        (member_a_local_ready ?member_a)
        (consumable_available ?consumable_item)
        (not
          (member_a_has_consumable ?member_a ?consumable_item)
        )
      )
  )
  (:action propose_anchor_b
    :parameters (?member_b - subgroup_b_member ?anchor_b - anchor_point_b ?task - engagement_task)
    :precondition
      (and
        (participant_committed ?member_b)
        (assigned_task ?member_b ?task)
        (member_b_linked_anchor ?member_b ?anchor_b)
        (not
          (anchor_b_proposed ?anchor_b)
        )
        (not
          (anchor_b_consumable_attached ?anchor_b)
        )
      )
    :effect (anchor_b_proposed ?anchor_b)
  )
  (:action attach_support_to_member_b
    :parameters (?member_b - subgroup_b_member ?anchor_b - anchor_point_b ?support_action - support_action)
    :precondition
      (and
        (participant_committed ?member_b)
        (assigned_support_action ?member_b ?support_action)
        (member_b_linked_anchor ?member_b ?anchor_b)
        (anchor_b_proposed ?anchor_b)
        (not
          (member_b_prepared ?member_b)
        )
      )
    :effect
      (and
        (member_b_prepared ?member_b)
        (member_b_local_ready ?member_b)
      )
  )
  (:action use_consumable_for_member_b
    :parameters (?member_b - subgroup_b_member ?anchor_b - anchor_point_b ?consumable_item - consumable_item)
    :precondition
      (and
        (participant_committed ?member_b)
        (member_b_linked_anchor ?member_b ?anchor_b)
        (consumable_available ?consumable_item)
        (not
          (member_b_prepared ?member_b)
        )
      )
    :effect
      (and
        (anchor_b_consumable_attached ?anchor_b)
        (member_b_prepared ?member_b)
        (member_b_has_consumable ?member_b ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action finalize_member_b_anchor
    :parameters (?member_b - subgroup_b_member ?anchor_b - anchor_point_b ?task - engagement_task ?consumable_item - consumable_item)
    :precondition
      (and
        (participant_committed ?member_b)
        (assigned_task ?member_b ?task)
        (member_b_linked_anchor ?member_b ?anchor_b)
        (anchor_b_consumable_attached ?anchor_b)
        (member_b_has_consumable ?member_b ?consumable_item)
        (not
          (member_b_local_ready ?member_b)
        )
      )
    :effect
      (and
        (anchor_b_proposed ?anchor_b)
        (member_b_local_ready ?member_b)
        (consumable_available ?consumable_item)
        (not
          (member_b_has_consumable ?member_b ?consumable_item)
        )
      )
  )
  (:action activate_regroup_beacon
    :parameters (?member_a - subgroup_a_member ?member_b - subgroup_b_member ?anchor_a - anchor_point_a ?anchor_b - anchor_point_b ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (member_a_prepared ?member_a)
        (member_b_prepared ?member_b)
        (member_a_linked_anchor ?member_a ?anchor_a)
        (member_b_linked_anchor ?member_b ?anchor_b)
        (anchor_a_proposed ?anchor_a)
        (anchor_b_proposed ?anchor_b)
        (member_a_local_ready ?member_a)
        (member_b_local_ready ?member_b)
        (beacon_available ?regroup_beacon)
      )
    :effect
      (and
        (beacon_activated ?regroup_beacon)
        (beacon_link_anchor_a ?regroup_beacon ?anchor_a)
        (beacon_link_anchor_b ?regroup_beacon ?anchor_b)
        (not
          (beacon_available ?regroup_beacon)
        )
      )
  )
  (:action activate_regroup_beacon_option_a
    :parameters (?member_a - subgroup_a_member ?member_b - subgroup_b_member ?anchor_a - anchor_point_a ?anchor_b - anchor_point_b ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (member_a_prepared ?member_a)
        (member_b_prepared ?member_b)
        (member_a_linked_anchor ?member_a ?anchor_a)
        (member_b_linked_anchor ?member_b ?anchor_b)
        (anchor_a_consumable_attached ?anchor_a)
        (anchor_b_proposed ?anchor_b)
        (not
          (member_a_local_ready ?member_a)
        )
        (member_b_local_ready ?member_b)
        (beacon_available ?regroup_beacon)
      )
    :effect
      (and
        (beacon_activated ?regroup_beacon)
        (beacon_link_anchor_a ?regroup_beacon ?anchor_a)
        (beacon_link_anchor_b ?regroup_beacon ?anchor_b)
        (beacon_option_anchor_a ?regroup_beacon)
        (not
          (beacon_available ?regroup_beacon)
        )
      )
  )
  (:action activate_regroup_beacon_option_b
    :parameters (?member_a - subgroup_a_member ?member_b - subgroup_b_member ?anchor_a - anchor_point_a ?anchor_b - anchor_point_b ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (member_a_prepared ?member_a)
        (member_b_prepared ?member_b)
        (member_a_linked_anchor ?member_a ?anchor_a)
        (member_b_linked_anchor ?member_b ?anchor_b)
        (anchor_a_proposed ?anchor_a)
        (anchor_b_consumable_attached ?anchor_b)
        (member_a_local_ready ?member_a)
        (not
          (member_b_local_ready ?member_b)
        )
        (beacon_available ?regroup_beacon)
      )
    :effect
      (and
        (beacon_activated ?regroup_beacon)
        (beacon_link_anchor_a ?regroup_beacon ?anchor_a)
        (beacon_link_anchor_b ?regroup_beacon ?anchor_b)
        (beacon_option_anchor_b ?regroup_beacon)
        (not
          (beacon_available ?regroup_beacon)
        )
      )
  )
  (:action activate_regroup_beacon_both_options
    :parameters (?member_a - subgroup_a_member ?member_b - subgroup_b_member ?anchor_a - anchor_point_a ?anchor_b - anchor_point_b ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (member_a_prepared ?member_a)
        (member_b_prepared ?member_b)
        (member_a_linked_anchor ?member_a ?anchor_a)
        (member_b_linked_anchor ?member_b ?anchor_b)
        (anchor_a_consumable_attached ?anchor_a)
        (anchor_b_consumable_attached ?anchor_b)
        (not
          (member_a_local_ready ?member_a)
        )
        (not
          (member_b_local_ready ?member_b)
        )
        (beacon_available ?regroup_beacon)
      )
    :effect
      (and
        (beacon_activated ?regroup_beacon)
        (beacon_link_anchor_a ?regroup_beacon ?anchor_a)
        (beacon_link_anchor_b ?regroup_beacon ?anchor_b)
        (beacon_option_anchor_a ?regroup_beacon)
        (beacon_option_anchor_b ?regroup_beacon)
        (not
          (beacon_available ?regroup_beacon)
        )
      )
  )
  (:action lock_regroup_beacon
    :parameters (?regroup_beacon - regroup_beacon ?member_a - subgroup_a_member ?task - engagement_task)
    :precondition
      (and
        (beacon_activated ?regroup_beacon)
        (member_a_prepared ?member_a)
        (assigned_task ?member_a ?task)
        (not
          (beacon_locked ?regroup_beacon)
        )
      )
    :effect (beacon_locked ?regroup_beacon)
  )
  (:action reserve_staged_asset_for_beacon
    :parameters (?controller - squad_controller ?staged_asset - staged_asset ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (participant_committed ?controller)
        (controller_linked_beacon ?controller ?regroup_beacon)
        (controller_has_staged_asset ?controller ?staged_asset)
        (staged_asset_available ?staged_asset)
        (beacon_activated ?regroup_beacon)
        (beacon_locked ?regroup_beacon)
        (not
          (staged_asset_reserved ?staged_asset)
        )
      )
    :effect
      (and
        (staged_asset_reserved ?staged_asset)
        (staged_asset_linked_beacon ?staged_asset ?regroup_beacon)
        (not
          (staged_asset_available ?staged_asset)
        )
      )
  )
  (:action confirm_staged_asset_reservation
    :parameters (?controller - squad_controller ?staged_asset - staged_asset ?regroup_beacon - regroup_beacon ?task - engagement_task)
    :precondition
      (and
        (participant_committed ?controller)
        (controller_has_staged_asset ?controller ?staged_asset)
        (staged_asset_reserved ?staged_asset)
        (staged_asset_linked_beacon ?staged_asset ?regroup_beacon)
        (assigned_task ?controller ?task)
        (not
          (beacon_option_anchor_a ?regroup_beacon)
        )
        (not
          (controller_staging_confirmed ?controller)
        )
      )
    :effect (controller_staging_confirmed ?controller)
  )
  (:action controller_select_configuration_choice
    :parameters (?controller - squad_controller ?configuration_choice - configuration_choice)
    :precondition
      (and
        (participant_committed ?controller)
        (configuration_choice_available ?configuration_choice)
        (not
          (controller_config_selected ?controller)
        )
      )
    :effect
      (and
        (controller_config_selected ?controller)
        (controller_has_configuration_choice ?controller ?configuration_choice)
        (not
          (configuration_choice_available ?configuration_choice)
        )
      )
  )
  (:action apply_configuration_with_staged_asset
    :parameters (?controller - squad_controller ?staged_asset - staged_asset ?regroup_beacon - regroup_beacon ?task - engagement_task ?configuration_choice - configuration_choice)
    :precondition
      (and
        (participant_committed ?controller)
        (controller_has_staged_asset ?controller ?staged_asset)
        (staged_asset_reserved ?staged_asset)
        (staged_asset_linked_beacon ?staged_asset ?regroup_beacon)
        (assigned_task ?controller ?task)
        (beacon_option_anchor_a ?regroup_beacon)
        (controller_config_selected ?controller)
        (controller_has_configuration_choice ?controller ?configuration_choice)
        (not
          (controller_staging_confirmed ?controller)
        )
      )
    :effect
      (and
        (controller_staging_confirmed ?controller)
        (controller_config_applied ?controller)
      )
  )
  (:action prepare_controller_with_equipment_option_a
    :parameters (?controller - squad_controller ?equipment_unit - equipment_unit ?support_action - support_action ?staged_asset - staged_asset ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (controller_staging_confirmed ?controller)
        (controller_has_equipment_unit ?controller ?equipment_unit)
        (assigned_support_action ?controller ?support_action)
        (controller_has_staged_asset ?controller ?staged_asset)
        (staged_asset_linked_beacon ?staged_asset ?regroup_beacon)
        (not
          (beacon_option_anchor_b ?regroup_beacon)
        )
        (not
          (controller_asset_verified ?controller)
        )
      )
    :effect (controller_asset_verified ?controller)
  )
  (:action prepare_controller_with_equipment_option_b
    :parameters (?controller - squad_controller ?equipment_unit - equipment_unit ?support_action - support_action ?staged_asset - staged_asset ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (controller_staging_confirmed ?controller)
        (controller_has_equipment_unit ?controller ?equipment_unit)
        (assigned_support_action ?controller ?support_action)
        (controller_has_staged_asset ?controller ?staged_asset)
        (staged_asset_linked_beacon ?staged_asset ?regroup_beacon)
        (beacon_option_anchor_b ?regroup_beacon)
        (not
          (controller_asset_verified ?controller)
        )
      )
    :effect (controller_asset_verified ?controller)
  )
  (:action begin_controller_finalization
    :parameters (?controller - squad_controller ?conditional_modifier - conditional_modifier ?staged_asset - staged_asset ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (controller_asset_verified ?controller)
        (controller_has_conditional_modifier ?controller ?conditional_modifier)
        (controller_has_staged_asset ?controller ?staged_asset)
        (staged_asset_linked_beacon ?staged_asset ?regroup_beacon)
        (not
          (beacon_option_anchor_a ?regroup_beacon)
        )
        (not
          (beacon_option_anchor_b ?regroup_beacon)
        )
        (not
          (controller_finalization_in_progress ?controller)
        )
      )
    :effect (controller_finalization_in_progress ?controller)
  )
  (:action begin_controller_finalization_with_option_a
    :parameters (?controller - squad_controller ?conditional_modifier - conditional_modifier ?staged_asset - staged_asset ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (controller_asset_verified ?controller)
        (controller_has_conditional_modifier ?controller ?conditional_modifier)
        (controller_has_staged_asset ?controller ?staged_asset)
        (staged_asset_linked_beacon ?staged_asset ?regroup_beacon)
        (beacon_option_anchor_a ?regroup_beacon)
        (not
          (beacon_option_anchor_b ?regroup_beacon)
        )
        (not
          (controller_finalization_in_progress ?controller)
        )
      )
    :effect
      (and
        (controller_finalization_in_progress ?controller)
        (controller_config_confirmed ?controller)
      )
  )
  (:action begin_controller_finalization_with_option_b
    :parameters (?controller - squad_controller ?conditional_modifier - conditional_modifier ?staged_asset - staged_asset ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (controller_asset_verified ?controller)
        (controller_has_conditional_modifier ?controller ?conditional_modifier)
        (controller_has_staged_asset ?controller ?staged_asset)
        (staged_asset_linked_beacon ?staged_asset ?regroup_beacon)
        (not
          (beacon_option_anchor_a ?regroup_beacon)
        )
        (beacon_option_anchor_b ?regroup_beacon)
        (not
          (controller_finalization_in_progress ?controller)
        )
      )
    :effect
      (and
        (controller_finalization_in_progress ?controller)
        (controller_config_confirmed ?controller)
      )
  )
  (:action begin_controller_finalization_with_both_options
    :parameters (?controller - squad_controller ?conditional_modifier - conditional_modifier ?staged_asset - staged_asset ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (controller_asset_verified ?controller)
        (controller_has_conditional_modifier ?controller ?conditional_modifier)
        (controller_has_staged_asset ?controller ?staged_asset)
        (staged_asset_linked_beacon ?staged_asset ?regroup_beacon)
        (beacon_option_anchor_a ?regroup_beacon)
        (beacon_option_anchor_b ?regroup_beacon)
        (not
          (controller_finalization_in_progress ?controller)
        )
      )
    :effect
      (and
        (controller_finalization_in_progress ?controller)
        (controller_config_confirmed ?controller)
      )
  )
  (:action finalize_controller
    :parameters (?controller - squad_controller)
    :precondition
      (and
        (controller_finalization_in_progress ?controller)
        (not
          (controller_config_confirmed ?controller)
        )
        (not
          (controller_finalized ?controller)
        )
      )
    :effect
      (and
        (controller_finalized ?controller)
        (readiness_committed ?controller)
      )
  )
  (:action assign_specialization_to_controller
    :parameters (?controller - squad_controller ?specialization_slot - specialization_slot)
    :precondition
      (and
        (controller_finalization_in_progress ?controller)
        (controller_config_confirmed ?controller)
        (specialization_slot_available ?specialization_slot)
      )
    :effect
      (and
        (controller_assigned_specialization ?controller ?specialization_slot)
        (not
          (specialization_slot_available ?specialization_slot)
        )
      )
  )
  (:action apply_controller_final_configuration
    :parameters (?controller - squad_controller ?member_a - subgroup_a_member ?member_b - subgroup_b_member ?task - engagement_task ?specialization_slot - specialization_slot)
    :precondition
      (and
        (controller_finalization_in_progress ?controller)
        (controller_config_confirmed ?controller)
        (controller_assigned_specialization ?controller ?specialization_slot)
        (controller_assigned_member_a ?controller ?member_a)
        (controller_assigned_member_b ?controller ?member_b)
        (member_a_local_ready ?member_a)
        (member_b_local_ready ?member_b)
        (assigned_task ?controller ?task)
        (not
          (controller_ready_for_commit ?controller)
        )
      )
    :effect (controller_ready_for_commit ?controller)
  )
  (:action commit_controller_finalization
    :parameters (?controller - squad_controller)
    :precondition
      (and
        (controller_finalization_in_progress ?controller)
        (controller_ready_for_commit ?controller)
        (not
          (controller_finalized ?controller)
        )
      )
    :effect
      (and
        (controller_finalized ?controller)
        (readiness_committed ?controller)
      )
  )
  (:action select_strategy_card_for_controller
    :parameters (?controller - squad_controller ?strategy_card - strategy_card ?task - engagement_task)
    :precondition
      (and
        (participant_committed ?controller)
        (assigned_task ?controller ?task)
        (strategy_card_available ?strategy_card)
        (controller_has_strategy_card ?controller ?strategy_card)
        (not
          (controller_strategy_selected ?controller)
        )
      )
    :effect
      (and
        (controller_strategy_selected ?controller)
        (not
          (strategy_card_available ?strategy_card)
        )
      )
  )
  (:action assign_support_after_strategy
    :parameters (?controller - squad_controller ?support_action - support_action)
    :precondition
      (and
        (controller_strategy_selected ?controller)
        (assigned_support_action ?controller ?support_action)
        (not
          (controller_config_step_completed ?controller)
        )
      )
    :effect (controller_config_step_completed ?controller)
  )
  (:action apply_conditional_modifier_to_controller
    :parameters (?controller - squad_controller ?conditional_modifier - conditional_modifier)
    :precondition
      (and
        (controller_config_step_completed ?controller)
        (controller_has_conditional_modifier ?controller ?conditional_modifier)
        (not
          (controller_final_step_completed ?controller)
        )
      )
    :effect (controller_final_step_completed ?controller)
  )
  (:action finalize_controller_strategy
    :parameters (?controller - squad_controller)
    :precondition
      (and
        (controller_final_step_completed ?controller)
        (not
          (controller_finalized ?controller)
        )
      )
    :effect
      (and
        (controller_finalized ?controller)
        (readiness_committed ?controller)
      )
  )
  (:action commit_member_a_readiness
    :parameters (?member_a - subgroup_a_member ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (member_a_prepared ?member_a)
        (member_a_local_ready ?member_a)
        (beacon_activated ?regroup_beacon)
        (beacon_locked ?regroup_beacon)
        (not
          (readiness_committed ?member_a)
        )
      )
    :effect (readiness_committed ?member_a)
  )
  (:action commit_member_b_readiness
    :parameters (?member_b - subgroup_b_member ?regroup_beacon - regroup_beacon)
    :precondition
      (and
        (member_b_prepared ?member_b)
        (member_b_local_ready ?member_b)
        (beacon_activated ?regroup_beacon)
        (beacon_locked ?regroup_beacon)
        (not
          (readiness_committed ?member_b)
        )
      )
    :effect (readiness_committed ?member_b)
  )
  (:action commit_member_timing_choice
    :parameters (?member - squad_member ?timing_token - timing_token ?task - engagement_task)
    :precondition
      (and
        (readiness_committed ?member)
        (assigned_task ?member ?task)
        (timing_token_available ?timing_token)
        (not
          (timing_committed ?member)
        )
      )
    :effect
      (and
        (timing_committed ?member)
        (assigned_timing_token ?member ?timing_token)
        (not
          (timing_token_available ?timing_token)
        )
      )
  )
  (:action finalize_member_a_and_release_resources
    :parameters (?member_a - subgroup_a_member ?controller_token - controller_token ?timing_token - timing_token)
    :precondition
      (and
        (timing_committed ?member_a)
        (bound_to_controller_token ?member_a ?controller_token)
        (assigned_timing_token ?member_a ?timing_token)
        (not
          (entity_ready_for_regroup ?member_a)
        )
      )
    :effect
      (and
        (entity_ready_for_regroup ?member_a)
        (controller_token_available ?controller_token)
        (timing_token_available ?timing_token)
      )
  )
  (:action finalize_member_b_and_release_resources
    :parameters (?member_b - subgroup_b_member ?controller_token - controller_token ?timing_token - timing_token)
    :precondition
      (and
        (timing_committed ?member_b)
        (bound_to_controller_token ?member_b ?controller_token)
        (assigned_timing_token ?member_b ?timing_token)
        (not
          (entity_ready_for_regroup ?member_b)
        )
      )
    :effect
      (and
        (entity_ready_for_regroup ?member_b)
        (controller_token_available ?controller_token)
        (timing_token_available ?timing_token)
      )
  )
  (:action finalize_controller_and_release_resources
    :parameters (?controller - squad_controller ?controller_token - controller_token ?timing_token - timing_token)
    :precondition
      (and
        (timing_committed ?controller)
        (bound_to_controller_token ?controller ?controller_token)
        (assigned_timing_token ?controller ?timing_token)
        (not
          (entity_ready_for_regroup ?controller)
        )
      )
    :effect
      (and
        (entity_ready_for_regroup ?controller)
        (controller_token_available ?controller_token)
        (timing_token_available ?timing_token)
      )
  )
)

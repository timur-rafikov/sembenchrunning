(define (domain broken_equipment_emergency_reconfiguration)
  (:requirements :strips :typing :negative-preconditions)
  (:types equipment_group_label - object component_family - object item_family - object domain_category - object mission_asset - domain_category component_slot - equipment_group_label spare_part - equipment_group_label repair_tool - equipment_group_label module_token - equipment_group_label skill_token - equipment_group_label priority_marker - equipment_group_label special_module - equipment_group_label patch_bundle - equipment_group_label consumable_resource - component_family resource_pool - component_family mission_modifier - component_family damage_signature - item_family repair_task - item_family repair_kit - item_family asset_slot_type - mission_asset agent_profile_type - mission_asset vehicle_unit - asset_slot_type infantry_unit - asset_slot_type configurable_agent - agent_profile_type)
  (:predicates
    (failure_detected ?mission_asset - mission_asset)
    (repair_task_active ?mission_asset - mission_asset)
    (diagnostic_ticket_open ?mission_asset - mission_asset)
    (asset_operational ?mission_asset - mission_asset)
    (ready_for_deployment ?mission_asset - mission_asset)
    (repair_finalized ?mission_asset - mission_asset)
    (slot_available ?component_slot - component_slot)
    (asset_slot_assigned ?mission_asset - mission_asset ?component_slot - component_slot)
    (spare_available ?spare_part - spare_part)
    (spare_allocated ?mission_asset - mission_asset ?spare_part - spare_part)
    (tool_available ?repair_tool - repair_tool)
    (tool_allocated ?mission_asset - mission_asset ?repair_tool - repair_tool)
    (consumable_available ?consumable_resource - consumable_resource)
    (vehicle_resource_allocated ?vehicle_unit - vehicle_unit ?consumable_resource - consumable_resource)
    (infantry_resource_allocated ?infantry_unit - infantry_unit ?consumable_resource - consumable_resource)
    (vehicle_has_signature ?vehicle_unit - vehicle_unit ?damage_signature - damage_signature)
    (signature_reserved ?damage_signature - damage_signature)
    (signature_committed ?damage_signature - damage_signature)
    (vehicle_prep_complete ?vehicle_unit - vehicle_unit)
    (unit_task_assigned ?infantry_unit - infantry_unit ?repair_task - repair_task)
    (task_reserved ?repair_task - repair_task)
    (task_committed ?repair_task - repair_task)
    (unit_prep_complete ?infantry_unit - infantry_unit)
    (kit_available ?repair_kit - repair_kit)
    (kit_prepared ?repair_kit - repair_kit)
    (kit_linked_signature ?repair_kit - repair_kit ?damage_signature - damage_signature)
    (kit_assigned_task ?repair_kit - repair_kit ?repair_task - repair_task)
    (kit_integrity_checked ?repair_kit - repair_kit)
    (kit_compliance_checked ?repair_kit - repair_kit)
    (kit_ready_for_delivery ?repair_kit - repair_kit)
    (agent_assigned_to_vehicle ?configurable_agent - configurable_agent ?vehicle_unit - vehicle_unit)
    (agent_assigned_to_unit ?configurable_agent - configurable_agent ?infantry_unit - infantry_unit)
    (agent_has_assigned_kit ?configurable_agent - configurable_agent ?repair_kit - repair_kit)
    (resource_pool_available ?resource_pool - resource_pool)
    (agent_linked_to_pool ?configurable_agent - configurable_agent ?resource_pool - resource_pool)
    (resource_pool_reserved ?resource_pool - resource_pool)
    (pool_contains_kit ?resource_pool - resource_pool ?repair_kit - repair_kit)
    (agent_pool_ready ?configurable_agent - configurable_agent)
    (module_staged ?configurable_agent - configurable_agent)
    (module_integration_ready ?configurable_agent - configurable_agent)
    (module_tagged ?configurable_agent - configurable_agent)
    (module_tag_confirmed ?configurable_agent - configurable_agent)
    (module_requires_skill ?configurable_agent - configurable_agent)
    (integration_complete ?configurable_agent - configurable_agent)
    (modifier_available ?mission_modifier - mission_modifier)
    (agent_has_modifier ?configurable_agent - configurable_agent ?mission_modifier - mission_modifier)
    (modifier_staged ?configurable_agent - configurable_agent)
    (modifier_stage_confirmed ?configurable_agent - configurable_agent)
    (modifier_installed ?configurable_agent - configurable_agent)
    (module_token_available ?module_token - module_token)
    (agent_has_module_token ?configurable_agent - configurable_agent ?module_token - module_token)
    (skill_token_available ?skill_token - skill_token)
    (agent_has_skill_token ?configurable_agent - configurable_agent ?skill_token - skill_token)
    (special_module_available ?special_module - special_module)
    (agent_has_special_module ?configurable_agent - configurable_agent ?special_module - special_module)
    (patch_bundle_available ?patch_bundle - patch_bundle)
    (agent_has_patch_bundle ?configurable_agent - configurable_agent ?patch_bundle - patch_bundle)
    (priority_marker_available ?priority_marker - priority_marker)
    (asset_has_priority_marker ?mission_asset - mission_asset ?priority_marker - priority_marker)
    (vehicle_ready ?vehicle_unit - vehicle_unit)
    (infantry_ready ?infantry_unit - infantry_unit)
    (integration_verified ?configurable_agent - configurable_agent)
  )
  (:action report_failure
    :parameters (?mission_asset - mission_asset)
    :precondition
      (and
        (not
          (failure_detected ?mission_asset)
        )
        (not
          (asset_operational ?mission_asset)
        )
      )
    :effect (failure_detected ?mission_asset)
  )
  (:action open_diagnostic_ticket
    :parameters (?mission_asset - mission_asset ?component_slot - component_slot)
    :precondition
      (and
        (failure_detected ?mission_asset)
        (not
          (diagnostic_ticket_open ?mission_asset)
        )
        (slot_available ?component_slot)
      )
    :effect
      (and
        (diagnostic_ticket_open ?mission_asset)
        (asset_slot_assigned ?mission_asset ?component_slot)
        (not
          (slot_available ?component_slot)
        )
      )
  )
  (:action allocate_spare_part
    :parameters (?mission_asset - mission_asset ?spare_part - spare_part)
    :precondition
      (and
        (failure_detected ?mission_asset)
        (diagnostic_ticket_open ?mission_asset)
        (spare_available ?spare_part)
      )
    :effect
      (and
        (spare_allocated ?mission_asset ?spare_part)
        (not
          (spare_available ?spare_part)
        )
      )
  )
  (:action activate_repair_task
    :parameters (?mission_asset - mission_asset ?spare_part - spare_part)
    :precondition
      (and
        (failure_detected ?mission_asset)
        (diagnostic_ticket_open ?mission_asset)
        (spare_allocated ?mission_asset ?spare_part)
        (not
          (repair_task_active ?mission_asset)
        )
      )
    :effect (repair_task_active ?mission_asset)
  )
  (:action return_spare_part
    :parameters (?mission_asset - mission_asset ?spare_part - spare_part)
    :precondition
      (and
        (spare_allocated ?mission_asset ?spare_part)
      )
    :effect
      (and
        (spare_available ?spare_part)
        (not
          (spare_allocated ?mission_asset ?spare_part)
        )
      )
  )
  (:action allocate_tool_to_asset
    :parameters (?mission_asset - mission_asset ?repair_tool - repair_tool)
    :precondition
      (and
        (repair_task_active ?mission_asset)
        (tool_available ?repair_tool)
      )
    :effect
      (and
        (tool_allocated ?mission_asset ?repair_tool)
        (not
          (tool_available ?repair_tool)
        )
      )
  )
  (:action release_tool_from_asset
    :parameters (?mission_asset - mission_asset ?repair_tool - repair_tool)
    :precondition
      (and
        (tool_allocated ?mission_asset ?repair_tool)
      )
    :effect
      (and
        (tool_available ?repair_tool)
        (not
          (tool_allocated ?mission_asset ?repair_tool)
        )
      )
  )
  (:action assign_special_module_to_agent
    :parameters (?configurable_agent - configurable_agent ?special_module - special_module)
    :precondition
      (and
        (repair_task_active ?configurable_agent)
        (special_module_available ?special_module)
      )
    :effect
      (and
        (agent_has_special_module ?configurable_agent ?special_module)
        (not
          (special_module_available ?special_module)
        )
      )
  )
  (:action unassign_special_module_from_agent
    :parameters (?configurable_agent - configurable_agent ?special_module - special_module)
    :precondition
      (and
        (agent_has_special_module ?configurable_agent ?special_module)
      )
    :effect
      (and
        (special_module_available ?special_module)
        (not
          (agent_has_special_module ?configurable_agent ?special_module)
        )
      )
  )
  (:action assign_patch_bundle_to_agent
    :parameters (?configurable_agent - configurable_agent ?patch_bundle - patch_bundle)
    :precondition
      (and
        (repair_task_active ?configurable_agent)
        (patch_bundle_available ?patch_bundle)
      )
    :effect
      (and
        (agent_has_patch_bundle ?configurable_agent ?patch_bundle)
        (not
          (patch_bundle_available ?patch_bundle)
        )
      )
  )
  (:action remove_patch_bundle_from_agent
    :parameters (?configurable_agent - configurable_agent ?patch_bundle - patch_bundle)
    :precondition
      (and
        (agent_has_patch_bundle ?configurable_agent ?patch_bundle)
      )
    :effect
      (and
        (patch_bundle_available ?patch_bundle)
        (not
          (agent_has_patch_bundle ?configurable_agent ?patch_bundle)
        )
      )
  )
  (:action reserve_damage_signature
    :parameters (?vehicle_unit - vehicle_unit ?damage_signature - damage_signature ?spare_part - spare_part)
    :precondition
      (and
        (repair_task_active ?vehicle_unit)
        (spare_allocated ?vehicle_unit ?spare_part)
        (vehicle_has_signature ?vehicle_unit ?damage_signature)
        (not
          (signature_reserved ?damage_signature)
        )
        (not
          (signature_committed ?damage_signature)
        )
      )
    :effect (signature_reserved ?damage_signature)
  )
  (:action apply_tool_validation
    :parameters (?vehicle_unit - vehicle_unit ?damage_signature - damage_signature ?repair_tool - repair_tool)
    :precondition
      (and
        (repair_task_active ?vehicle_unit)
        (tool_allocated ?vehicle_unit ?repair_tool)
        (vehicle_has_signature ?vehicle_unit ?damage_signature)
        (signature_reserved ?damage_signature)
        (not
          (vehicle_ready ?vehicle_unit)
        )
      )
    :effect
      (and
        (vehicle_ready ?vehicle_unit)
        (vehicle_prep_complete ?vehicle_unit)
      )
  )
  (:action consume_resource_for_vehicle
    :parameters (?vehicle_unit - vehicle_unit ?damage_signature - damage_signature ?consumable_resource - consumable_resource)
    :precondition
      (and
        (repair_task_active ?vehicle_unit)
        (vehicle_has_signature ?vehicle_unit ?damage_signature)
        (consumable_available ?consumable_resource)
        (not
          (vehicle_ready ?vehicle_unit)
        )
      )
    :effect
      (and
        (signature_committed ?damage_signature)
        (vehicle_ready ?vehicle_unit)
        (vehicle_resource_allocated ?vehicle_unit ?consumable_resource)
        (not
          (consumable_available ?consumable_resource)
        )
      )
  )
  (:action finalize_vehicle_preparation
    :parameters (?vehicle_unit - vehicle_unit ?damage_signature - damage_signature ?spare_part - spare_part ?consumable_resource - consumable_resource)
    :precondition
      (and
        (repair_task_active ?vehicle_unit)
        (spare_allocated ?vehicle_unit ?spare_part)
        (vehicle_has_signature ?vehicle_unit ?damage_signature)
        (signature_committed ?damage_signature)
        (vehicle_resource_allocated ?vehicle_unit ?consumable_resource)
        (not
          (vehicle_prep_complete ?vehicle_unit)
        )
      )
    :effect
      (and
        (signature_reserved ?damage_signature)
        (vehicle_prep_complete ?vehicle_unit)
        (consumable_available ?consumable_resource)
        (not
          (vehicle_resource_allocated ?vehicle_unit ?consumable_resource)
        )
      )
  )
  (:action reserve_repair_task_for_unit
    :parameters (?infantry_unit - infantry_unit ?repair_task - repair_task ?spare_part - spare_part)
    :precondition
      (and
        (repair_task_active ?infantry_unit)
        (spare_allocated ?infantry_unit ?spare_part)
        (unit_task_assigned ?infantry_unit ?repair_task)
        (not
          (task_reserved ?repair_task)
        )
        (not
          (task_committed ?repair_task)
        )
      )
    :effect (task_reserved ?repair_task)
  )
  (:action allocate_tool_to_unit
    :parameters (?infantry_unit - infantry_unit ?repair_task - repair_task ?repair_tool - repair_tool)
    :precondition
      (and
        (repair_task_active ?infantry_unit)
        (tool_allocated ?infantry_unit ?repair_tool)
        (unit_task_assigned ?infantry_unit ?repair_task)
        (task_reserved ?repair_task)
        (not
          (infantry_ready ?infantry_unit)
        )
      )
    :effect
      (and
        (infantry_ready ?infantry_unit)
        (unit_prep_complete ?infantry_unit)
      )
  )
  (:action consume_resource_for_unit
    :parameters (?infantry_unit - infantry_unit ?repair_task - repair_task ?consumable_resource - consumable_resource)
    :precondition
      (and
        (repair_task_active ?infantry_unit)
        (unit_task_assigned ?infantry_unit ?repair_task)
        (consumable_available ?consumable_resource)
        (not
          (infantry_ready ?infantry_unit)
        )
      )
    :effect
      (and
        (task_committed ?repair_task)
        (infantry_ready ?infantry_unit)
        (infantry_resource_allocated ?infantry_unit ?consumable_resource)
        (not
          (consumable_available ?consumable_resource)
        )
      )
  )
  (:action finalize_unit_preparation
    :parameters (?infantry_unit - infantry_unit ?repair_task - repair_task ?spare_part - spare_part ?consumable_resource - consumable_resource)
    :precondition
      (and
        (repair_task_active ?infantry_unit)
        (spare_allocated ?infantry_unit ?spare_part)
        (unit_task_assigned ?infantry_unit ?repair_task)
        (task_committed ?repair_task)
        (infantry_resource_allocated ?infantry_unit ?consumable_resource)
        (not
          (unit_prep_complete ?infantry_unit)
        )
      )
    :effect
      (and
        (task_reserved ?repair_task)
        (unit_prep_complete ?infantry_unit)
        (consumable_available ?consumable_resource)
        (not
          (infantry_resource_allocated ?infantry_unit ?consumable_resource)
        )
      )
  )
  (:action assemble_repair_kit
    :parameters (?vehicle_unit - vehicle_unit ?infantry_unit - infantry_unit ?damage_signature - damage_signature ?repair_task - repair_task ?repair_kit - repair_kit)
    :precondition
      (and
        (vehicle_ready ?vehicle_unit)
        (infantry_ready ?infantry_unit)
        (vehicle_has_signature ?vehicle_unit ?damage_signature)
        (unit_task_assigned ?infantry_unit ?repair_task)
        (signature_reserved ?damage_signature)
        (task_reserved ?repair_task)
        (vehicle_prep_complete ?vehicle_unit)
        (unit_prep_complete ?infantry_unit)
        (kit_available ?repair_kit)
      )
    :effect
      (and
        (kit_prepared ?repair_kit)
        (kit_linked_signature ?repair_kit ?damage_signature)
        (kit_assigned_task ?repair_kit ?repair_task)
        (not
          (kit_available ?repair_kit)
        )
      )
  )
  (:action assemble_kit_with_integrity_check
    :parameters (?vehicle_unit - vehicle_unit ?infantry_unit - infantry_unit ?damage_signature - damage_signature ?repair_task - repair_task ?repair_kit - repair_kit)
    :precondition
      (and
        (vehicle_ready ?vehicle_unit)
        (infantry_ready ?infantry_unit)
        (vehicle_has_signature ?vehicle_unit ?damage_signature)
        (unit_task_assigned ?infantry_unit ?repair_task)
        (signature_committed ?damage_signature)
        (task_reserved ?repair_task)
        (not
          (vehicle_prep_complete ?vehicle_unit)
        )
        (unit_prep_complete ?infantry_unit)
        (kit_available ?repair_kit)
      )
    :effect
      (and
        (kit_prepared ?repair_kit)
        (kit_linked_signature ?repair_kit ?damage_signature)
        (kit_assigned_task ?repair_kit ?repair_task)
        (kit_integrity_checked ?repair_kit)
        (not
          (kit_available ?repair_kit)
        )
      )
  )
  (:action assemble_kit_with_compliance_check
    :parameters (?vehicle_unit - vehicle_unit ?infantry_unit - infantry_unit ?damage_signature - damage_signature ?repair_task - repair_task ?repair_kit - repair_kit)
    :precondition
      (and
        (vehicle_ready ?vehicle_unit)
        (infantry_ready ?infantry_unit)
        (vehicle_has_signature ?vehicle_unit ?damage_signature)
        (unit_task_assigned ?infantry_unit ?repair_task)
        (signature_reserved ?damage_signature)
        (task_committed ?repair_task)
        (vehicle_prep_complete ?vehicle_unit)
        (not
          (unit_prep_complete ?infantry_unit)
        )
        (kit_available ?repair_kit)
      )
    :effect
      (and
        (kit_prepared ?repair_kit)
        (kit_linked_signature ?repair_kit ?damage_signature)
        (kit_assigned_task ?repair_kit ?repair_task)
        (kit_compliance_checked ?repair_kit)
        (not
          (kit_available ?repair_kit)
        )
      )
  )
  (:action assemble_fully_verified_kit
    :parameters (?vehicle_unit - vehicle_unit ?infantry_unit - infantry_unit ?damage_signature - damage_signature ?repair_task - repair_task ?repair_kit - repair_kit)
    :precondition
      (and
        (vehicle_ready ?vehicle_unit)
        (infantry_ready ?infantry_unit)
        (vehicle_has_signature ?vehicle_unit ?damage_signature)
        (unit_task_assigned ?infantry_unit ?repair_task)
        (signature_committed ?damage_signature)
        (task_committed ?repair_task)
        (not
          (vehicle_prep_complete ?vehicle_unit)
        )
        (not
          (unit_prep_complete ?infantry_unit)
        )
        (kit_available ?repair_kit)
      )
    :effect
      (and
        (kit_prepared ?repair_kit)
        (kit_linked_signature ?repair_kit ?damage_signature)
        (kit_assigned_task ?repair_kit ?repair_task)
        (kit_integrity_checked ?repair_kit)
        (kit_compliance_checked ?repair_kit)
        (not
          (kit_available ?repair_kit)
        )
      )
  )
  (:action mark_kit_ready_for_delivery
    :parameters (?repair_kit - repair_kit ?vehicle_unit - vehicle_unit ?spare_part - spare_part)
    :precondition
      (and
        (kit_prepared ?repair_kit)
        (vehicle_ready ?vehicle_unit)
        (spare_allocated ?vehicle_unit ?spare_part)
        (not
          (kit_ready_for_delivery ?repair_kit)
        )
      )
    :effect (kit_ready_for_delivery ?repair_kit)
  )
  (:action reserve_resource_pool
    :parameters (?configurable_agent - configurable_agent ?resource_pool - resource_pool ?repair_kit - repair_kit)
    :precondition
      (and
        (repair_task_active ?configurable_agent)
        (agent_has_assigned_kit ?configurable_agent ?repair_kit)
        (agent_linked_to_pool ?configurable_agent ?resource_pool)
        (resource_pool_available ?resource_pool)
        (kit_prepared ?repair_kit)
        (kit_ready_for_delivery ?repair_kit)
        (not
          (resource_pool_reserved ?resource_pool)
        )
      )
    :effect
      (and
        (resource_pool_reserved ?resource_pool)
        (pool_contains_kit ?resource_pool ?repair_kit)
        (not
          (resource_pool_available ?resource_pool)
        )
      )
  )
  (:action register_agent_pool
    :parameters (?configurable_agent - configurable_agent ?resource_pool - resource_pool ?repair_kit - repair_kit ?spare_part - spare_part)
    :precondition
      (and
        (repair_task_active ?configurable_agent)
        (agent_linked_to_pool ?configurable_agent ?resource_pool)
        (resource_pool_reserved ?resource_pool)
        (pool_contains_kit ?resource_pool ?repair_kit)
        (spare_allocated ?configurable_agent ?spare_part)
        (not
          (kit_integrity_checked ?repair_kit)
        )
        (not
          (agent_pool_ready ?configurable_agent)
        )
      )
    :effect (agent_pool_ready ?configurable_agent)
  )
  (:action assign_module_token_to_agent
    :parameters (?configurable_agent - configurable_agent ?module_token - module_token)
    :precondition
      (and
        (repair_task_active ?configurable_agent)
        (module_token_available ?module_token)
        (not
          (module_tagged ?configurable_agent)
        )
      )
    :effect
      (and
        (module_tagged ?configurable_agent)
        (agent_has_module_token ?configurable_agent ?module_token)
        (not
          (module_token_available ?module_token)
        )
      )
  )
  (:action prepare_tagged_module
    :parameters (?configurable_agent - configurable_agent ?resource_pool - resource_pool ?repair_kit - repair_kit ?spare_part - spare_part ?module_token - module_token)
    :precondition
      (and
        (repair_task_active ?configurable_agent)
        (agent_linked_to_pool ?configurable_agent ?resource_pool)
        (resource_pool_reserved ?resource_pool)
        (pool_contains_kit ?resource_pool ?repair_kit)
        (spare_allocated ?configurable_agent ?spare_part)
        (kit_integrity_checked ?repair_kit)
        (module_tagged ?configurable_agent)
        (agent_has_module_token ?configurable_agent ?module_token)
        (not
          (agent_pool_ready ?configurable_agent)
        )
      )
    :effect
      (and
        (agent_pool_ready ?configurable_agent)
        (module_tag_confirmed ?configurable_agent)
      )
  )
  (:action initiate_module_installation
    :parameters (?configurable_agent - configurable_agent ?special_module - special_module ?repair_tool - repair_tool ?resource_pool - resource_pool ?repair_kit - repair_kit)
    :precondition
      (and
        (agent_pool_ready ?configurable_agent)
        (agent_has_special_module ?configurable_agent ?special_module)
        (tool_allocated ?configurable_agent ?repair_tool)
        (agent_linked_to_pool ?configurable_agent ?resource_pool)
        (pool_contains_kit ?resource_pool ?repair_kit)
        (not
          (kit_compliance_checked ?repair_kit)
        )
        (not
          (module_staged ?configurable_agent)
        )
      )
    :effect (module_staged ?configurable_agent)
  )
  (:action complete_module_installation
    :parameters (?configurable_agent - configurable_agent ?special_module - special_module ?repair_tool - repair_tool ?resource_pool - resource_pool ?repair_kit - repair_kit)
    :precondition
      (and
        (agent_pool_ready ?configurable_agent)
        (agent_has_special_module ?configurable_agent ?special_module)
        (tool_allocated ?configurable_agent ?repair_tool)
        (agent_linked_to_pool ?configurable_agent ?resource_pool)
        (pool_contains_kit ?resource_pool ?repair_kit)
        (kit_compliance_checked ?repair_kit)
        (not
          (module_staged ?configurable_agent)
        )
      )
    :effect (module_staged ?configurable_agent)
  )
  (:action apply_patch_and_stage_integration
    :parameters (?configurable_agent - configurable_agent ?patch_bundle - patch_bundle ?resource_pool - resource_pool ?repair_kit - repair_kit)
    :precondition
      (and
        (module_staged ?configurable_agent)
        (agent_has_patch_bundle ?configurable_agent ?patch_bundle)
        (agent_linked_to_pool ?configurable_agent ?resource_pool)
        (pool_contains_kit ?resource_pool ?repair_kit)
        (not
          (kit_integrity_checked ?repair_kit)
        )
        (not
          (kit_compliance_checked ?repair_kit)
        )
        (not
          (module_integration_ready ?configurable_agent)
        )
      )
    :effect (module_integration_ready ?configurable_agent)
  )
  (:action apply_patch_and_require_skill
    :parameters (?configurable_agent - configurable_agent ?patch_bundle - patch_bundle ?resource_pool - resource_pool ?repair_kit - repair_kit)
    :precondition
      (and
        (module_staged ?configurable_agent)
        (agent_has_patch_bundle ?configurable_agent ?patch_bundle)
        (agent_linked_to_pool ?configurable_agent ?resource_pool)
        (pool_contains_kit ?resource_pool ?repair_kit)
        (kit_integrity_checked ?repair_kit)
        (not
          (kit_compliance_checked ?repair_kit)
        )
        (not
          (module_integration_ready ?configurable_agent)
        )
      )
    :effect
      (and
        (module_integration_ready ?configurable_agent)
        (module_requires_skill ?configurable_agent)
      )
  )
  (:action apply_patch_with_optional_skill
    :parameters (?configurable_agent - configurable_agent ?patch_bundle - patch_bundle ?resource_pool - resource_pool ?repair_kit - repair_kit)
    :precondition
      (and
        (module_staged ?configurable_agent)
        (agent_has_patch_bundle ?configurable_agent ?patch_bundle)
        (agent_linked_to_pool ?configurable_agent ?resource_pool)
        (pool_contains_kit ?resource_pool ?repair_kit)
        (not
          (kit_integrity_checked ?repair_kit)
        )
        (kit_compliance_checked ?repair_kit)
        (not
          (module_integration_ready ?configurable_agent)
        )
      )
    :effect
      (and
        (module_integration_ready ?configurable_agent)
        (module_requires_skill ?configurable_agent)
      )
  )
  (:action apply_patch_and_mark_additional_checks
    :parameters (?configurable_agent - configurable_agent ?patch_bundle - patch_bundle ?resource_pool - resource_pool ?repair_kit - repair_kit)
    :precondition
      (and
        (module_staged ?configurable_agent)
        (agent_has_patch_bundle ?configurable_agent ?patch_bundle)
        (agent_linked_to_pool ?configurable_agent ?resource_pool)
        (pool_contains_kit ?resource_pool ?repair_kit)
        (kit_integrity_checked ?repair_kit)
        (kit_compliance_checked ?repair_kit)
        (not
          (module_integration_ready ?configurable_agent)
        )
      )
    :effect
      (and
        (module_integration_ready ?configurable_agent)
        (module_requires_skill ?configurable_agent)
      )
  )
  (:action finalize_integration_without_skill
    :parameters (?configurable_agent - configurable_agent)
    :precondition
      (and
        (module_integration_ready ?configurable_agent)
        (not
          (module_requires_skill ?configurable_agent)
        )
        (not
          (integration_verified ?configurable_agent)
        )
      )
    :effect
      (and
        (integration_verified ?configurable_agent)
        (ready_for_deployment ?configurable_agent)
      )
  )
  (:action assign_skill_token_to_agent
    :parameters (?configurable_agent - configurable_agent ?skill_token - skill_token)
    :precondition
      (and
        (module_integration_ready ?configurable_agent)
        (module_requires_skill ?configurable_agent)
        (skill_token_available ?skill_token)
      )
    :effect
      (and
        (agent_has_skill_token ?configurable_agent ?skill_token)
        (not
          (skill_token_available ?skill_token)
        )
      )
  )
  (:action validate_agent_integration
    :parameters (?configurable_agent - configurable_agent ?vehicle_unit - vehicle_unit ?infantry_unit - infantry_unit ?spare_part - spare_part ?skill_token - skill_token)
    :precondition
      (and
        (module_integration_ready ?configurable_agent)
        (module_requires_skill ?configurable_agent)
        (agent_has_skill_token ?configurable_agent ?skill_token)
        (agent_assigned_to_vehicle ?configurable_agent ?vehicle_unit)
        (agent_assigned_to_unit ?configurable_agent ?infantry_unit)
        (vehicle_prep_complete ?vehicle_unit)
        (unit_prep_complete ?infantry_unit)
        (spare_allocated ?configurable_agent ?spare_part)
        (not
          (integration_complete ?configurable_agent)
        )
      )
    :effect (integration_complete ?configurable_agent)
  )
  (:action finalize_agent_integration
    :parameters (?configurable_agent - configurable_agent)
    :precondition
      (and
        (module_integration_ready ?configurable_agent)
        (integration_complete ?configurable_agent)
        (not
          (integration_verified ?configurable_agent)
        )
      )
    :effect
      (and
        (integration_verified ?configurable_agent)
        (ready_for_deployment ?configurable_agent)
      )
  )
  (:action stage_optional_modifier
    :parameters (?configurable_agent - configurable_agent ?mission_modifier - mission_modifier ?spare_part - spare_part)
    :precondition
      (and
        (repair_task_active ?configurable_agent)
        (spare_allocated ?configurable_agent ?spare_part)
        (modifier_available ?mission_modifier)
        (agent_has_modifier ?configurable_agent ?mission_modifier)
        (not
          (modifier_staged ?configurable_agent)
        )
      )
    :effect
      (and
        (modifier_staged ?configurable_agent)
        (not
          (modifier_available ?mission_modifier)
        )
      )
  )
  (:action confirm_modifier_stage
    :parameters (?configurable_agent - configurable_agent ?repair_tool - repair_tool)
    :precondition
      (and
        (modifier_staged ?configurable_agent)
        (tool_allocated ?configurable_agent ?repair_tool)
        (not
          (modifier_stage_confirmed ?configurable_agent)
        )
      )
    :effect (modifier_stage_confirmed ?configurable_agent)
  )
  (:action apply_modifier_patch
    :parameters (?configurable_agent - configurable_agent ?patch_bundle - patch_bundle)
    :precondition
      (and
        (modifier_stage_confirmed ?configurable_agent)
        (agent_has_patch_bundle ?configurable_agent ?patch_bundle)
        (not
          (modifier_installed ?configurable_agent)
        )
      )
    :effect (modifier_installed ?configurable_agent)
  )
  (:action finalize_modifier_installation
    :parameters (?configurable_agent - configurable_agent)
    :precondition
      (and
        (modifier_installed ?configurable_agent)
        (not
          (integration_verified ?configurable_agent)
        )
      )
    :effect
      (and
        (integration_verified ?configurable_agent)
        (ready_for_deployment ?configurable_agent)
      )
  )
  (:action finalize_vehicle_redeployment
    :parameters (?vehicle_unit - vehicle_unit ?repair_kit - repair_kit)
    :precondition
      (and
        (vehicle_ready ?vehicle_unit)
        (vehicle_prep_complete ?vehicle_unit)
        (kit_prepared ?repair_kit)
        (kit_ready_for_delivery ?repair_kit)
        (not
          (ready_for_deployment ?vehicle_unit)
        )
      )
    :effect (ready_for_deployment ?vehicle_unit)
  )
  (:action finalize_unit_redeployment
    :parameters (?infantry_unit - infantry_unit ?repair_kit - repair_kit)
    :precondition
      (and
        (infantry_ready ?infantry_unit)
        (unit_prep_complete ?infantry_unit)
        (kit_prepared ?repair_kit)
        (kit_ready_for_delivery ?repair_kit)
        (not
          (ready_for_deployment ?infantry_unit)
        )
      )
    :effect (ready_for_deployment ?infantry_unit)
  )
  (:action apply_priority_marker_to_asset
    :parameters (?mission_asset - mission_asset ?priority_marker - priority_marker ?spare_part - spare_part)
    :precondition
      (and
        (ready_for_deployment ?mission_asset)
        (spare_allocated ?mission_asset ?spare_part)
        (priority_marker_available ?priority_marker)
        (not
          (repair_finalized ?mission_asset)
        )
      )
    :effect
      (and
        (repair_finalized ?mission_asset)
        (asset_has_priority_marker ?mission_asset ?priority_marker)
        (not
          (priority_marker_available ?priority_marker)
        )
      )
  )
  (:action complete_vehicle_redeployment
    :parameters (?vehicle_unit - vehicle_unit ?component_slot - component_slot ?priority_marker - priority_marker)
    :precondition
      (and
        (repair_finalized ?vehicle_unit)
        (asset_slot_assigned ?vehicle_unit ?component_slot)
        (asset_has_priority_marker ?vehicle_unit ?priority_marker)
        (not
          (asset_operational ?vehicle_unit)
        )
      )
    :effect
      (and
        (asset_operational ?vehicle_unit)
        (slot_available ?component_slot)
        (priority_marker_available ?priority_marker)
      )
  )
  (:action complete_unit_redeployment
    :parameters (?infantry_unit - infantry_unit ?component_slot - component_slot ?priority_marker - priority_marker)
    :precondition
      (and
        (repair_finalized ?infantry_unit)
        (asset_slot_assigned ?infantry_unit ?component_slot)
        (asset_has_priority_marker ?infantry_unit ?priority_marker)
        (not
          (asset_operational ?infantry_unit)
        )
      )
    :effect
      (and
        (asset_operational ?infantry_unit)
        (slot_available ?component_slot)
        (priority_marker_available ?priority_marker)
      )
  )
  (:action complete_agent_redeployment
    :parameters (?configurable_agent - configurable_agent ?component_slot - component_slot ?priority_marker - priority_marker)
    :precondition
      (and
        (repair_finalized ?configurable_agent)
        (asset_slot_assigned ?configurable_agent ?component_slot)
        (asset_has_priority_marker ?configurable_agent ?priority_marker)
        (not
          (asset_operational ?configurable_agent)
        )
      )
    :effect
      (and
        (asset_operational ?configurable_agent)
        (slot_available ?component_slot)
        (priority_marker_available ?priority_marker)
      )
  )
)

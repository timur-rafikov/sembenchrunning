(define (domain stash_to_active_inventory_rotation)
  (:requirements :strips :typing :negative-preconditions)
  (:types item - object module - object material - object inventory_entity - object item_entry - inventory_entity stash_item - item item_type - item tool - item cosmetic_modifier - item special_component - item preservation_kit - item repair_kit - item power_core - item consumable_resource - module upgrade_module - module objective_tag - module primary_material - material secondary_material - material prepared_item - material equipment_slot_group - item_entry loadout_group - item_entry primary_slot - equipment_slot_group secondary_slot - equipment_slot_group loadout - loadout_group)
  (:predicates
    (entity_claimed ?item_entry - item_entry)
    (entity_staged ?item_entry - item_entry)
    (entity_reserved ?item_entry - item_entry)
    (activated ?item_entry - item_entry)
    (entity_ready_for_activation ?item_entry - item_entry)
    (entity_activation_marked ?item_entry - item_entry)
    (in_stash ?stash_item - stash_item)
    (entity_reserved_from_stash ?item_entry - item_entry ?stash_item - stash_item)
    (item_type_available ?item_type - item_type)
    (entity_assigned_type ?item_entry - item_entry ?item_type - item_type)
    (tool_available ?tool - tool)
    (entity_has_tool ?item_entry - item_entry ?tool - tool)
    (consumable_available ?consumable_resource - consumable_resource)
    (primary_slot_consumable_allocated ?primary_slot - primary_slot ?consumable_resource - consumable_resource)
    (secondary_slot_consumable_allocated ?secondary_slot - secondary_slot ?consumable_resource - consumable_resource)
    (primary_slot_material_reserved ?primary_slot - primary_slot ?primary_material - primary_material)
    (primary_material_prepared ?primary_material - primary_material)
    (primary_material_locked ?primary_material - primary_material)
    (primary_slot_material_confirmed ?primary_slot - primary_slot)
    (secondary_slot_material_reserved ?secondary_slot - secondary_slot ?secondary_material - secondary_material)
    (secondary_material_prepared ?secondary_material - secondary_material)
    (secondary_material_locked ?secondary_material - secondary_material)
    (secondary_slot_material_confirmed ?secondary_slot - secondary_slot)
    (prepared_item_available ?prepared_item - prepared_item)
    (prepared_item_assembled ?prepared_item - prepared_item)
    (prepared_item_has_primary_material ?prepared_item - prepared_item ?primary_material - primary_material)
    (prepared_item_has_secondary_material ?prepared_item - prepared_item ?secondary_material - secondary_material)
    (prepared_item_primary_consumed ?prepared_item - prepared_item)
    (prepared_item_secondary_consumed ?prepared_item - prepared_item)
    (prepared_item_validated ?prepared_item - prepared_item)
    (loadout_has_primary_slot ?loadout - loadout ?primary_slot - primary_slot)
    (loadout_has_secondary_slot ?loadout - loadout ?secondary_slot - secondary_slot)
    (loadout_has_prepared_item ?loadout - loadout ?prepared_item - prepared_item)
    (upgrade_module_available ?upgrade_module - upgrade_module)
    (loadout_has_upgrade_module ?loadout - loadout ?upgrade_module - upgrade_module)
    (upgrade_module_installed ?upgrade_module - upgrade_module)
    (upgrade_module_attached_to_prepared_item ?upgrade_module - upgrade_module ?prepared_item - prepared_item)
    (loadout_integration_ready ?loadout - loadout)
    (loadout_integration_confirmed ?loadout - loadout)
    (loadout_ready_for_finalization ?loadout - loadout)
    (cosmetic_attached ?loadout - loadout)
    (integration_stage_two_completed ?loadout - loadout)
    (special_component_marked_for_attachment ?loadout - loadout)
    (loadout_components_verified ?loadout - loadout)
    (objective_tag_available ?objective_tag - objective_tag)
    (loadout_has_objective_tag ?loadout - loadout ?objective_tag - objective_tag)
    (objective_tag_bound ?loadout - loadout)
    (objective_tag_processed ?loadout - loadout)
    (objective_tag_finalized ?loadout - loadout)
    (cosmetic_available ?cosmetic_modifier - cosmetic_modifier)
    (loadout_has_cosmetic ?loadout - loadout ?cosmetic_modifier - cosmetic_modifier)
    (special_component_available ?special_component - special_component)
    (loadout_has_special_component ?loadout - loadout ?special_component - special_component)
    (repair_kit_available ?repair_kit - repair_kit)
    (loadout_has_repair_kit ?loadout - loadout ?repair_kit - repair_kit)
    (power_core_available ?power_core - power_core)
    (loadout_has_power_core ?loadout - loadout ?power_core - power_core)
    (preservation_kit_available ?preservation_kit - preservation_kit)
    (entity_bound_to_preservation_kit ?item_entry - item_entry ?preservation_kit - preservation_kit)
    (primary_slot_ready ?primary_slot - primary_slot)
    (secondary_slot_ready ?secondary_slot - secondary_slot)
    (finalized ?loadout - loadout)
  )
  (:action claim_item_for_staging
    :parameters (?item_entry - item_entry)
    :precondition
      (and
        (not
          (entity_claimed ?item_entry)
        )
        (not
          (activated ?item_entry)
        )
      )
    :effect (entity_claimed ?item_entry)
  )
  (:action reserve_stash_item_for_entry
    :parameters (?item_entry - item_entry ?stash_item - stash_item)
    :precondition
      (and
        (entity_claimed ?item_entry)
        (not
          (entity_reserved ?item_entry)
        )
        (in_stash ?stash_item)
      )
    :effect
      (and
        (entity_reserved ?item_entry)
        (entity_reserved_from_stash ?item_entry ?stash_item)
        (not
          (in_stash ?stash_item)
        )
      )
  )
  (:action assign_item_type_to_entry
    :parameters (?item_entry - item_entry ?item_type - item_type)
    :precondition
      (and
        (entity_claimed ?item_entry)
        (entity_reserved ?item_entry)
        (item_type_available ?item_type)
      )
    :effect
      (and
        (entity_assigned_type ?item_entry ?item_type)
        (not
          (item_type_available ?item_type)
        )
      )
  )
  (:action mark_entry_ready
    :parameters (?item_entry - item_entry ?item_type - item_type)
    :precondition
      (and
        (entity_claimed ?item_entry)
        (entity_reserved ?item_entry)
        (entity_assigned_type ?item_entry ?item_type)
        (not
          (entity_staged ?item_entry)
        )
      )
    :effect (entity_staged ?item_entry)
  )
  (:action release_item_type_from_entry
    :parameters (?item_entry - item_entry ?item_type - item_type)
    :precondition
      (and
        (entity_assigned_type ?item_entry ?item_type)
      )
    :effect
      (and
        (item_type_available ?item_type)
        (not
          (entity_assigned_type ?item_entry ?item_type)
        )
      )
  )
  (:action attach_tool_to_entry
    :parameters (?item_entry - item_entry ?tool - tool)
    :precondition
      (and
        (entity_staged ?item_entry)
        (tool_available ?tool)
      )
    :effect
      (and
        (entity_has_tool ?item_entry ?tool)
        (not
          (tool_available ?tool)
        )
      )
  )
  (:action release_tool_from_entry
    :parameters (?item_entry - item_entry ?tool - tool)
    :precondition
      (and
        (entity_has_tool ?item_entry ?tool)
      )
    :effect
      (and
        (tool_available ?tool)
        (not
          (entity_has_tool ?item_entry ?tool)
        )
      )
  )
  (:action apply_repair_kit_to_loadout
    :parameters (?loadout - loadout ?repair_kit - repair_kit)
    :precondition
      (and
        (entity_staged ?loadout)
        (repair_kit_available ?repair_kit)
      )
    :effect
      (and
        (loadout_has_repair_kit ?loadout ?repair_kit)
        (not
          (repair_kit_available ?repair_kit)
        )
      )
  )
  (:action remove_repair_kit_from_loadout
    :parameters (?loadout - loadout ?repair_kit - repair_kit)
    :precondition
      (and
        (loadout_has_repair_kit ?loadout ?repair_kit)
      )
    :effect
      (and
        (repair_kit_available ?repair_kit)
        (not
          (loadout_has_repair_kit ?loadout ?repair_kit)
        )
      )
  )
  (:action install_power_core_on_loadout
    :parameters (?loadout - loadout ?power_core - power_core)
    :precondition
      (and
        (entity_staged ?loadout)
        (power_core_available ?power_core)
      )
    :effect
      (and
        (loadout_has_power_core ?loadout ?power_core)
        (not
          (power_core_available ?power_core)
        )
      )
  )
  (:action remove_power_core_from_loadout
    :parameters (?loadout - loadout ?power_core - power_core)
    :precondition
      (and
        (loadout_has_power_core ?loadout ?power_core)
      )
    :effect
      (and
        (power_core_available ?power_core)
        (not
          (loadout_has_power_core ?loadout ?power_core)
        )
      )
  )
  (:action mark_primary_material_for_slot
    :parameters (?primary_slot - primary_slot ?primary_material - primary_material ?item_type - item_type)
    :precondition
      (and
        (entity_staged ?primary_slot)
        (entity_assigned_type ?primary_slot ?item_type)
        (primary_slot_material_reserved ?primary_slot ?primary_material)
        (not
          (primary_material_prepared ?primary_material)
        )
        (not
          (primary_material_locked ?primary_material)
        )
      )
    :effect (primary_material_prepared ?primary_material)
  )
  (:action confirm_primary_material_with_tool
    :parameters (?primary_slot - primary_slot ?primary_material - primary_material ?tool - tool)
    :precondition
      (and
        (entity_staged ?primary_slot)
        (entity_has_tool ?primary_slot ?tool)
        (primary_slot_material_reserved ?primary_slot ?primary_material)
        (primary_material_prepared ?primary_material)
        (not
          (primary_slot_ready ?primary_slot)
        )
      )
    :effect
      (and
        (primary_slot_ready ?primary_slot)
        (primary_slot_material_confirmed ?primary_slot)
      )
  )
  (:action allocate_consumable_to_primary_slot
    :parameters (?primary_slot - primary_slot ?primary_material - primary_material ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_staged ?primary_slot)
        (primary_slot_material_reserved ?primary_slot ?primary_material)
        (consumable_available ?consumable_resource)
        (not
          (primary_slot_ready ?primary_slot)
        )
      )
    :effect
      (and
        (primary_material_locked ?primary_material)
        (primary_slot_ready ?primary_slot)
        (primary_slot_consumable_allocated ?primary_slot ?consumable_resource)
        (not
          (consumable_available ?consumable_resource)
        )
      )
  )
  (:action finalize_primary_material_allocation
    :parameters (?primary_slot - primary_slot ?primary_material - primary_material ?item_type - item_type ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_staged ?primary_slot)
        (entity_assigned_type ?primary_slot ?item_type)
        (primary_slot_material_reserved ?primary_slot ?primary_material)
        (primary_material_locked ?primary_material)
        (primary_slot_consumable_allocated ?primary_slot ?consumable_resource)
        (not
          (primary_slot_material_confirmed ?primary_slot)
        )
      )
    :effect
      (and
        (primary_material_prepared ?primary_material)
        (primary_slot_material_confirmed ?primary_slot)
        (consumable_available ?consumable_resource)
        (not
          (primary_slot_consumable_allocated ?primary_slot ?consumable_resource)
        )
      )
  )
  (:action mark_secondary_material_for_slot
    :parameters (?secondary_slot - secondary_slot ?secondary_material - secondary_material ?item_type - item_type)
    :precondition
      (and
        (entity_staged ?secondary_slot)
        (entity_assigned_type ?secondary_slot ?item_type)
        (secondary_slot_material_reserved ?secondary_slot ?secondary_material)
        (not
          (secondary_material_prepared ?secondary_material)
        )
        (not
          (secondary_material_locked ?secondary_material)
        )
      )
    :effect (secondary_material_prepared ?secondary_material)
  )
  (:action confirm_secondary_material_with_tool
    :parameters (?secondary_slot - secondary_slot ?secondary_material - secondary_material ?tool - tool)
    :precondition
      (and
        (entity_staged ?secondary_slot)
        (entity_has_tool ?secondary_slot ?tool)
        (secondary_slot_material_reserved ?secondary_slot ?secondary_material)
        (secondary_material_prepared ?secondary_material)
        (not
          (secondary_slot_ready ?secondary_slot)
        )
      )
    :effect
      (and
        (secondary_slot_ready ?secondary_slot)
        (secondary_slot_material_confirmed ?secondary_slot)
      )
  )
  (:action allocate_consumable_to_secondary_slot
    :parameters (?secondary_slot - secondary_slot ?secondary_material - secondary_material ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_staged ?secondary_slot)
        (secondary_slot_material_reserved ?secondary_slot ?secondary_material)
        (consumable_available ?consumable_resource)
        (not
          (secondary_slot_ready ?secondary_slot)
        )
      )
    :effect
      (and
        (secondary_material_locked ?secondary_material)
        (secondary_slot_ready ?secondary_slot)
        (secondary_slot_consumable_allocated ?secondary_slot ?consumable_resource)
        (not
          (consumable_available ?consumable_resource)
        )
      )
  )
  (:action finalize_secondary_material_allocation
    :parameters (?secondary_slot - secondary_slot ?secondary_material - secondary_material ?item_type - item_type ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_staged ?secondary_slot)
        (entity_assigned_type ?secondary_slot ?item_type)
        (secondary_slot_material_reserved ?secondary_slot ?secondary_material)
        (secondary_material_locked ?secondary_material)
        (secondary_slot_consumable_allocated ?secondary_slot ?consumable_resource)
        (not
          (secondary_slot_material_confirmed ?secondary_slot)
        )
      )
    :effect
      (and
        (secondary_material_prepared ?secondary_material)
        (secondary_slot_material_confirmed ?secondary_slot)
        (consumable_available ?consumable_resource)
        (not
          (secondary_slot_consumable_allocated ?secondary_slot ?consumable_resource)
        )
      )
  )
  (:action assemble_prepared_item
    :parameters (?primary_slot - primary_slot ?secondary_slot - secondary_slot ?primary_material - primary_material ?secondary_material - secondary_material ?prepared_item - prepared_item)
    :precondition
      (and
        (primary_slot_ready ?primary_slot)
        (secondary_slot_ready ?secondary_slot)
        (primary_slot_material_reserved ?primary_slot ?primary_material)
        (secondary_slot_material_reserved ?secondary_slot ?secondary_material)
        (primary_material_prepared ?primary_material)
        (secondary_material_prepared ?secondary_material)
        (primary_slot_material_confirmed ?primary_slot)
        (secondary_slot_material_confirmed ?secondary_slot)
        (prepared_item_available ?prepared_item)
      )
    :effect
      (and
        (prepared_item_assembled ?prepared_item)
        (prepared_item_has_primary_material ?prepared_item ?primary_material)
        (prepared_item_has_secondary_material ?prepared_item ?secondary_material)
        (not
          (prepared_item_available ?prepared_item)
        )
      )
  )
  (:action assemble_prepared_item_primary_consumed
    :parameters (?primary_slot - primary_slot ?secondary_slot - secondary_slot ?primary_material - primary_material ?secondary_material - secondary_material ?prepared_item - prepared_item)
    :precondition
      (and
        (primary_slot_ready ?primary_slot)
        (secondary_slot_ready ?secondary_slot)
        (primary_slot_material_reserved ?primary_slot ?primary_material)
        (secondary_slot_material_reserved ?secondary_slot ?secondary_material)
        (primary_material_locked ?primary_material)
        (secondary_material_prepared ?secondary_material)
        (not
          (primary_slot_material_confirmed ?primary_slot)
        )
        (secondary_slot_material_confirmed ?secondary_slot)
        (prepared_item_available ?prepared_item)
      )
    :effect
      (and
        (prepared_item_assembled ?prepared_item)
        (prepared_item_has_primary_material ?prepared_item ?primary_material)
        (prepared_item_has_secondary_material ?prepared_item ?secondary_material)
        (prepared_item_primary_consumed ?prepared_item)
        (not
          (prepared_item_available ?prepared_item)
        )
      )
  )
  (:action assemble_prepared_item_secondary_consumed
    :parameters (?primary_slot - primary_slot ?secondary_slot - secondary_slot ?primary_material - primary_material ?secondary_material - secondary_material ?prepared_item - prepared_item)
    :precondition
      (and
        (primary_slot_ready ?primary_slot)
        (secondary_slot_ready ?secondary_slot)
        (primary_slot_material_reserved ?primary_slot ?primary_material)
        (secondary_slot_material_reserved ?secondary_slot ?secondary_material)
        (primary_material_prepared ?primary_material)
        (secondary_material_locked ?secondary_material)
        (primary_slot_material_confirmed ?primary_slot)
        (not
          (secondary_slot_material_confirmed ?secondary_slot)
        )
        (prepared_item_available ?prepared_item)
      )
    :effect
      (and
        (prepared_item_assembled ?prepared_item)
        (prepared_item_has_primary_material ?prepared_item ?primary_material)
        (prepared_item_has_secondary_material ?prepared_item ?secondary_material)
        (prepared_item_secondary_consumed ?prepared_item)
        (not
          (prepared_item_available ?prepared_item)
        )
      )
  )
  (:action assemble_prepared_item_both_consumed
    :parameters (?primary_slot - primary_slot ?secondary_slot - secondary_slot ?primary_material - primary_material ?secondary_material - secondary_material ?prepared_item - prepared_item)
    :precondition
      (and
        (primary_slot_ready ?primary_slot)
        (secondary_slot_ready ?secondary_slot)
        (primary_slot_material_reserved ?primary_slot ?primary_material)
        (secondary_slot_material_reserved ?secondary_slot ?secondary_material)
        (primary_material_locked ?primary_material)
        (secondary_material_locked ?secondary_material)
        (not
          (primary_slot_material_confirmed ?primary_slot)
        )
        (not
          (secondary_slot_material_confirmed ?secondary_slot)
        )
        (prepared_item_available ?prepared_item)
      )
    :effect
      (and
        (prepared_item_assembled ?prepared_item)
        (prepared_item_has_primary_material ?prepared_item ?primary_material)
        (prepared_item_has_secondary_material ?prepared_item ?secondary_material)
        (prepared_item_primary_consumed ?prepared_item)
        (prepared_item_secondary_consumed ?prepared_item)
        (not
          (prepared_item_available ?prepared_item)
        )
      )
  )
  (:action validate_prepared_item
    :parameters (?prepared_item - prepared_item ?primary_slot - primary_slot ?item_type - item_type)
    :precondition
      (and
        (prepared_item_assembled ?prepared_item)
        (primary_slot_ready ?primary_slot)
        (entity_assigned_type ?primary_slot ?item_type)
        (not
          (prepared_item_validated ?prepared_item)
        )
      )
    :effect (prepared_item_validated ?prepared_item)
  )
  (:action attach_upgrade_module_to_loadout
    :parameters (?loadout - loadout ?upgrade_module - upgrade_module ?prepared_item - prepared_item)
    :precondition
      (and
        (entity_staged ?loadout)
        (loadout_has_prepared_item ?loadout ?prepared_item)
        (loadout_has_upgrade_module ?loadout ?upgrade_module)
        (upgrade_module_available ?upgrade_module)
        (prepared_item_assembled ?prepared_item)
        (prepared_item_validated ?prepared_item)
        (not
          (upgrade_module_installed ?upgrade_module)
        )
      )
    :effect
      (and
        (upgrade_module_installed ?upgrade_module)
        (upgrade_module_attached_to_prepared_item ?upgrade_module ?prepared_item)
        (not
          (upgrade_module_available ?upgrade_module)
        )
      )
  )
  (:action prepare_loadout_for_module_integration
    :parameters (?loadout - loadout ?upgrade_module - upgrade_module ?prepared_item - prepared_item ?item_type - item_type)
    :precondition
      (and
        (entity_staged ?loadout)
        (loadout_has_upgrade_module ?loadout ?upgrade_module)
        (upgrade_module_installed ?upgrade_module)
        (upgrade_module_attached_to_prepared_item ?upgrade_module ?prepared_item)
        (entity_assigned_type ?loadout ?item_type)
        (not
          (prepared_item_primary_consumed ?prepared_item)
        )
        (not
          (loadout_integration_ready ?loadout)
        )
      )
    :effect (loadout_integration_ready ?loadout)
  )
  (:action attach_cosmetic_to_loadout
    :parameters (?loadout - loadout ?cosmetic_modifier - cosmetic_modifier)
    :precondition
      (and
        (entity_staged ?loadout)
        (cosmetic_available ?cosmetic_modifier)
        (not
          (cosmetic_attached ?loadout)
        )
      )
    :effect
      (and
        (cosmetic_attached ?loadout)
        (loadout_has_cosmetic ?loadout ?cosmetic_modifier)
        (not
          (cosmetic_available ?cosmetic_modifier)
        )
      )
  )
  (:action integrate_module_and_cosmetic
    :parameters (?loadout - loadout ?upgrade_module - upgrade_module ?prepared_item - prepared_item ?item_type - item_type ?cosmetic_modifier - cosmetic_modifier)
    :precondition
      (and
        (entity_staged ?loadout)
        (loadout_has_upgrade_module ?loadout ?upgrade_module)
        (upgrade_module_installed ?upgrade_module)
        (upgrade_module_attached_to_prepared_item ?upgrade_module ?prepared_item)
        (entity_assigned_type ?loadout ?item_type)
        (prepared_item_primary_consumed ?prepared_item)
        (cosmetic_attached ?loadout)
        (loadout_has_cosmetic ?loadout ?cosmetic_modifier)
        (not
          (loadout_integration_ready ?loadout)
        )
      )
    :effect
      (and
        (loadout_integration_ready ?loadout)
        (integration_stage_two_completed ?loadout)
      )
  )
  (:action confirm_module_integration_without_secondary_consumption
    :parameters (?loadout - loadout ?repair_kit - repair_kit ?tool - tool ?upgrade_module - upgrade_module ?prepared_item - prepared_item)
    :precondition
      (and
        (loadout_integration_ready ?loadout)
        (loadout_has_repair_kit ?loadout ?repair_kit)
        (entity_has_tool ?loadout ?tool)
        (loadout_has_upgrade_module ?loadout ?upgrade_module)
        (upgrade_module_attached_to_prepared_item ?upgrade_module ?prepared_item)
        (not
          (prepared_item_secondary_consumed ?prepared_item)
        )
        (not
          (loadout_integration_confirmed ?loadout)
        )
      )
    :effect (loadout_integration_confirmed ?loadout)
  )
  (:action confirm_module_integration_with_secondary_consumption
    :parameters (?loadout - loadout ?repair_kit - repair_kit ?tool - tool ?upgrade_module - upgrade_module ?prepared_item - prepared_item)
    :precondition
      (and
        (loadout_integration_ready ?loadout)
        (loadout_has_repair_kit ?loadout ?repair_kit)
        (entity_has_tool ?loadout ?tool)
        (loadout_has_upgrade_module ?loadout ?upgrade_module)
        (upgrade_module_attached_to_prepared_item ?upgrade_module ?prepared_item)
        (prepared_item_secondary_consumed ?prepared_item)
        (not
          (loadout_integration_confirmed ?loadout)
        )
      )
    :effect (loadout_integration_confirmed ?loadout)
  )
  (:action finalize_module_integration
    :parameters (?loadout - loadout ?power_core - power_core ?upgrade_module - upgrade_module ?prepared_item - prepared_item)
    :precondition
      (and
        (loadout_integration_confirmed ?loadout)
        (loadout_has_power_core ?loadout ?power_core)
        (loadout_has_upgrade_module ?loadout ?upgrade_module)
        (upgrade_module_attached_to_prepared_item ?upgrade_module ?prepared_item)
        (not
          (prepared_item_primary_consumed ?prepared_item)
        )
        (not
          (prepared_item_secondary_consumed ?prepared_item)
        )
        (not
          (loadout_ready_for_finalization ?loadout)
        )
      )
    :effect (loadout_ready_for_finalization ?loadout)
  )
  (:action finalize_module_integration_with_cosmetic
    :parameters (?loadout - loadout ?power_core - power_core ?upgrade_module - upgrade_module ?prepared_item - prepared_item)
    :precondition
      (and
        (loadout_integration_confirmed ?loadout)
        (loadout_has_power_core ?loadout ?power_core)
        (loadout_has_upgrade_module ?loadout ?upgrade_module)
        (upgrade_module_attached_to_prepared_item ?upgrade_module ?prepared_item)
        (prepared_item_primary_consumed ?prepared_item)
        (not
          (prepared_item_secondary_consumed ?prepared_item)
        )
        (not
          (loadout_ready_for_finalization ?loadout)
        )
      )
    :effect
      (and
        (loadout_ready_for_finalization ?loadout)
        (special_component_marked_for_attachment ?loadout)
      )
  )
  (:action finalize_module_integration_with_variant
    :parameters (?loadout - loadout ?power_core - power_core ?upgrade_module - upgrade_module ?prepared_item - prepared_item)
    :precondition
      (and
        (loadout_integration_confirmed ?loadout)
        (loadout_has_power_core ?loadout ?power_core)
        (loadout_has_upgrade_module ?loadout ?upgrade_module)
        (upgrade_module_attached_to_prepared_item ?upgrade_module ?prepared_item)
        (not
          (prepared_item_primary_consumed ?prepared_item)
        )
        (prepared_item_secondary_consumed ?prepared_item)
        (not
          (loadout_ready_for_finalization ?loadout)
        )
      )
    :effect
      (and
        (loadout_ready_for_finalization ?loadout)
        (special_component_marked_for_attachment ?loadout)
      )
  )
  (:action finalize_module_integration_full
    :parameters (?loadout - loadout ?power_core - power_core ?upgrade_module - upgrade_module ?prepared_item - prepared_item)
    :precondition
      (and
        (loadout_integration_confirmed ?loadout)
        (loadout_has_power_core ?loadout ?power_core)
        (loadout_has_upgrade_module ?loadout ?upgrade_module)
        (upgrade_module_attached_to_prepared_item ?upgrade_module ?prepared_item)
        (prepared_item_primary_consumed ?prepared_item)
        (prepared_item_secondary_consumed ?prepared_item)
        (not
          (loadout_ready_for_finalization ?loadout)
        )
      )
    :effect
      (and
        (loadout_ready_for_finalization ?loadout)
        (special_component_marked_for_attachment ?loadout)
      )
  )
  (:action finalize_loadout_without_component
    :parameters (?loadout - loadout)
    :precondition
      (and
        (loadout_ready_for_finalization ?loadout)
        (not
          (special_component_marked_for_attachment ?loadout)
        )
        (not
          (finalized ?loadout)
        )
      )
    :effect
      (and
        (finalized ?loadout)
        (entity_ready_for_activation ?loadout)
      )
  )
  (:action attach_special_component_to_loadout
    :parameters (?loadout - loadout ?special_component - special_component)
    :precondition
      (and
        (loadout_ready_for_finalization ?loadout)
        (special_component_marked_for_attachment ?loadout)
        (special_component_available ?special_component)
      )
    :effect
      (and
        (loadout_has_special_component ?loadout ?special_component)
        (not
          (special_component_available ?special_component)
        )
      )
  )
  (:action verify_and_lock_loadout_components
    :parameters (?loadout - loadout ?primary_slot - primary_slot ?secondary_slot - secondary_slot ?item_type - item_type ?special_component - special_component)
    :precondition
      (and
        (loadout_ready_for_finalization ?loadout)
        (special_component_marked_for_attachment ?loadout)
        (loadout_has_special_component ?loadout ?special_component)
        (loadout_has_primary_slot ?loadout ?primary_slot)
        (loadout_has_secondary_slot ?loadout ?secondary_slot)
        (primary_slot_material_confirmed ?primary_slot)
        (secondary_slot_material_confirmed ?secondary_slot)
        (entity_assigned_type ?loadout ?item_type)
        (not
          (loadout_components_verified ?loadout)
        )
      )
    :effect (loadout_components_verified ?loadout)
  )
  (:action finalize_verified_loadout
    :parameters (?loadout - loadout)
    :precondition
      (and
        (loadout_ready_for_finalization ?loadout)
        (loadout_components_verified ?loadout)
        (not
          (finalized ?loadout)
        )
      )
    :effect
      (and
        (finalized ?loadout)
        (entity_ready_for_activation ?loadout)
      )
  )
  (:action bind_objective_tag_to_loadout
    :parameters (?loadout - loadout ?objective_tag - objective_tag ?item_type - item_type)
    :precondition
      (and
        (entity_staged ?loadout)
        (entity_assigned_type ?loadout ?item_type)
        (objective_tag_available ?objective_tag)
        (loadout_has_objective_tag ?loadout ?objective_tag)
        (not
          (objective_tag_bound ?loadout)
        )
      )
    :effect
      (and
        (objective_tag_bound ?loadout)
        (not
          (objective_tag_available ?objective_tag)
        )
      )
  )
  (:action apply_tool_to_bound_objective
    :parameters (?loadout - loadout ?tool - tool)
    :precondition
      (and
        (objective_tag_bound ?loadout)
        (entity_has_tool ?loadout ?tool)
        (not
          (objective_tag_processed ?loadout)
        )
      )
    :effect (objective_tag_processed ?loadout)
  )
  (:action attach_power_core_for_objective
    :parameters (?loadout - loadout ?power_core - power_core)
    :precondition
      (and
        (objective_tag_processed ?loadout)
        (loadout_has_power_core ?loadout ?power_core)
        (not
          (objective_tag_finalized ?loadout)
        )
      )
    :effect (objective_tag_finalized ?loadout)
  )
  (:action finalize_loadout_with_objective
    :parameters (?loadout - loadout)
    :precondition
      (and
        (objective_tag_finalized ?loadout)
        (not
          (finalized ?loadout)
        )
      )
    :effect
      (and
        (finalized ?loadout)
        (entity_ready_for_activation ?loadout)
      )
  )
  (:action activate_prepared_item_in_primary_slot
    :parameters (?primary_slot - primary_slot ?prepared_item - prepared_item)
    :precondition
      (and
        (primary_slot_ready ?primary_slot)
        (primary_slot_material_confirmed ?primary_slot)
        (prepared_item_assembled ?prepared_item)
        (prepared_item_validated ?prepared_item)
        (not
          (entity_ready_for_activation ?primary_slot)
        )
      )
    :effect (entity_ready_for_activation ?primary_slot)
  )
  (:action activate_prepared_item_in_secondary_slot
    :parameters (?secondary_slot - secondary_slot ?prepared_item - prepared_item)
    :precondition
      (and
        (secondary_slot_ready ?secondary_slot)
        (secondary_slot_material_confirmed ?secondary_slot)
        (prepared_item_assembled ?prepared_item)
        (prepared_item_validated ?prepared_item)
        (not
          (entity_ready_for_activation ?secondary_slot)
        )
      )
    :effect (entity_ready_for_activation ?secondary_slot)
  )
  (:action apply_preservation_kit_to_item
    :parameters (?item_entry - item_entry ?preservation_kit - preservation_kit ?item_type - item_type)
    :precondition
      (and
        (entity_ready_for_activation ?item_entry)
        (entity_assigned_type ?item_entry ?item_type)
        (preservation_kit_available ?preservation_kit)
        (not
          (entity_activation_marked ?item_entry)
        )
      )
    :effect
      (and
        (entity_activation_marked ?item_entry)
        (entity_bound_to_preservation_kit ?item_entry ?preservation_kit)
        (not
          (preservation_kit_available ?preservation_kit)
        )
      )
  )
  (:action activate_primary_slot_from_stash
    :parameters (?primary_slot - primary_slot ?stash_item - stash_item ?preservation_kit - preservation_kit)
    :precondition
      (and
        (entity_activation_marked ?primary_slot)
        (entity_reserved_from_stash ?primary_slot ?stash_item)
        (entity_bound_to_preservation_kit ?primary_slot ?preservation_kit)
        (not
          (activated ?primary_slot)
        )
      )
    :effect
      (and
        (activated ?primary_slot)
        (in_stash ?stash_item)
        (preservation_kit_available ?preservation_kit)
      )
  )
  (:action activate_secondary_slot_from_stash
    :parameters (?secondary_slot - secondary_slot ?stash_item - stash_item ?preservation_kit - preservation_kit)
    :precondition
      (and
        (entity_activation_marked ?secondary_slot)
        (entity_reserved_from_stash ?secondary_slot ?stash_item)
        (entity_bound_to_preservation_kit ?secondary_slot ?preservation_kit)
        (not
          (activated ?secondary_slot)
        )
      )
    :effect
      (and
        (activated ?secondary_slot)
        (in_stash ?stash_item)
        (preservation_kit_available ?preservation_kit)
      )
  )
  (:action activate_loadout_from_stash
    :parameters (?loadout - loadout ?stash_item - stash_item ?preservation_kit - preservation_kit)
    :precondition
      (and
        (entity_activation_marked ?loadout)
        (entity_reserved_from_stash ?loadout ?stash_item)
        (entity_bound_to_preservation_kit ?loadout ?preservation_kit)
        (not
          (activated ?loadout)
        )
      )
    :effect
      (and
        (activated ?loadout)
        (in_stash ?stash_item)
        (preservation_kit_available ?preservation_kit)
      )
  )
)

(define (domain consumable_stockpile_preservation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types equipment_category - object consumable_category - object container_category - object stockpile_class - object stockpile_unit - stockpile_class resource_token - equipment_category consumable_requirement - equipment_category tool - equipment_category special_module - equipment_category stability_agent - equipment_category preservation_supply - equipment_category maintenance_part - equipment_category maintenance_kit - equipment_category preservation_material - consumable_category component - consumable_category authorization_token - consumable_category storage_condition_a - container_category storage_condition_b - container_category container_unit - container_category consumable_grouping - stockpile_unit station_grouping - stockpile_unit consumable_batch_a - consumable_grouping consumable_batch_b - consumable_grouping maintenance_station - station_grouping)
  (:predicates
    (unit_registered ?stockpile_unit - stockpile_unit)
    (ready_for_tooling ?stockpile_unit - stockpile_unit)
    (preservation_unit_has_resource_token ?stockpile_unit - stockpile_unit)
    (preservation_completed ?stockpile_unit - stockpile_unit)
    (ready_for_activation ?stockpile_unit - stockpile_unit)
    (preservation_activated ?stockpile_unit - stockpile_unit)
    (resource_token_available ?resource_token - resource_token)
    (preservation_unit_assigned_resource_token ?stockpile_unit - stockpile_unit ?resource_token - resource_token)
    (requirement_available ?consumable_requirement - consumable_requirement)
    (unit_bound_requirement ?stockpile_unit - stockpile_unit ?consumable_requirement - consumable_requirement)
    (tool_available ?tool - tool)
    (unit_assigned_tool ?stockpile_unit - stockpile_unit ?tool - tool)
    (preservation_material_available ?preservation_material - preservation_material)
    (batch_a_has_preservation_material ?consumable_batch_a - consumable_batch_a ?preservation_material - preservation_material)
    (batch_b_has_preservation_material ?consumable_batch_b - consumable_batch_b ?preservation_material - preservation_material)
    (batch_a_assigned_condition_a ?consumable_batch_a - consumable_batch_a ?storage_condition_a - storage_condition_a)
    (condition_a_reserved_tool ?storage_condition_a - storage_condition_a)
    (condition_a_reserved_material ?storage_condition_a - storage_condition_a)
    (batch_a_ready_for_sealing ?consumable_batch_a - consumable_batch_a)
    (batch_b_assigned_condition_b ?consumable_batch_b - consumable_batch_b ?storage_condition_b - storage_condition_b)
    (condition_b_reserved_tool ?storage_condition_b - storage_condition_b)
    (condition_b_reserved_material ?storage_condition_b - storage_condition_b)
    (batch_b_ready_for_sealing ?consumable_batch_b - consumable_batch_b)
    (container_available ?container_unit - container_unit)
    (container_claimed ?container_unit - container_unit)
    (container_has_condition_a ?container_unit - container_unit ?storage_condition_a - storage_condition_a)
    (container_has_condition_b ?container_unit - container_unit ?storage_condition_b - storage_condition_b)
    (container_seal_feature_a ?container_unit - container_unit)
    (container_seal_feature_b ?container_unit - container_unit)
    (container_sealed ?container_unit - container_unit)
    (station_assigned_batch_a ?maintenance_station - maintenance_station ?consumable_batch_a - consumable_batch_a)
    (station_assigned_batch_b ?maintenance_station - maintenance_station ?consumable_batch_b - consumable_batch_b)
    (station_assigned_container ?maintenance_station - maintenance_station ?container_unit - container_unit)
    (component_available ?component - component)
    (station_has_component ?maintenance_station - maintenance_station ?component - component)
    (component_installed ?component - component)
    (component_installed_in_container ?component - component ?container_unit - container_unit)
    (station_components_attached ?maintenance_station - maintenance_station)
    (station_prepared_for_kit_installation ?maintenance_station - maintenance_station)
    (station_certified_intermediate ?maintenance_station - maintenance_station)
    (station_module_attached ?maintenance_station - maintenance_station)
    (station_module_configured ?maintenance_station - maintenance_station)
    (station_has_stability_agent ?maintenance_station - maintenance_station)
    (station_assembly_finalized ?maintenance_station - maintenance_station)
    (authorization_token_available ?authorization_token - authorization_token)
    (station_has_authorization ?maintenance_station - maintenance_station ?authorization_token - authorization_token)
    (station_authorized ?maintenance_station - maintenance_station)
    (station_authorization_locked ?maintenance_station - maintenance_station)
    (station_authorization_confirmed ?maintenance_station - maintenance_station)
    (module_available ?special_module - special_module)
    (station_installed_module ?maintenance_station - maintenance_station ?special_module - special_module)
    (stability_agent_available ?stability_agent - stability_agent)
    (station_has_stability_agent_installed ?maintenance_station - maintenance_station ?stability_agent - stability_agent)
    (maintenance_part_available ?maintenance_part - maintenance_part)
    (station_has_maintenance_part ?maintenance_station - maintenance_station ?maintenance_part - maintenance_part)
    (maintenance_kit_available ?maintenance_kit - maintenance_kit)
    (station_has_maintenance_kit ?maintenance_station - maintenance_station ?maintenance_kit - maintenance_kit)
    (preservation_supply_available ?preservation_supply - preservation_supply)
    (unit_has_preservation_supply ?stockpile_unit - stockpile_unit ?preservation_supply - preservation_supply)
    (batch_a_condition_prepared ?consumable_batch_a - consumable_batch_a)
    (batch_b_condition_prepared ?consumable_batch_b - consumable_batch_b)
    (station_committed ?maintenance_station - maintenance_station)
  )
  (:action register_stockpile_unit
    :parameters (?stockpile_unit - stockpile_unit)
    :precondition
      (and
        (not
          (unit_registered ?stockpile_unit)
        )
        (not
          (preservation_completed ?stockpile_unit)
        )
      )
    :effect (unit_registered ?stockpile_unit)
  )
  (:action assign_resource_token_to_unit
    :parameters (?stockpile_unit - stockpile_unit ?resource_token - resource_token)
    :precondition
      (and
        (unit_registered ?stockpile_unit)
        (not
          (preservation_unit_has_resource_token ?stockpile_unit)
        )
        (resource_token_available ?resource_token)
      )
    :effect
      (and
        (preservation_unit_has_resource_token ?stockpile_unit)
        (preservation_unit_assigned_resource_token ?stockpile_unit ?resource_token)
        (not
          (resource_token_available ?resource_token)
        )
      )
  )
  (:action assign_requirement_to_unit
    :parameters (?stockpile_unit - stockpile_unit ?consumable_requirement - consumable_requirement)
    :precondition
      (and
        (unit_registered ?stockpile_unit)
        (preservation_unit_has_resource_token ?stockpile_unit)
        (requirement_available ?consumable_requirement)
      )
    :effect
      (and
        (unit_bound_requirement ?stockpile_unit ?consumable_requirement)
        (not
          (requirement_available ?consumable_requirement)
        )
      )
  )
  (:action prepare_unit_for_tool_assignment
    :parameters (?stockpile_unit - stockpile_unit ?consumable_requirement - consumable_requirement)
    :precondition
      (and
        (unit_registered ?stockpile_unit)
        (preservation_unit_has_resource_token ?stockpile_unit)
        (unit_bound_requirement ?stockpile_unit ?consumable_requirement)
        (not
          (ready_for_tooling ?stockpile_unit)
        )
      )
    :effect (ready_for_tooling ?stockpile_unit)
  )
  (:action release_requirement_from_unit
    :parameters (?stockpile_unit - stockpile_unit ?consumable_requirement - consumable_requirement)
    :precondition
      (and
        (unit_bound_requirement ?stockpile_unit ?consumable_requirement)
      )
    :effect
      (and
        (requirement_available ?consumable_requirement)
        (not
          (unit_bound_requirement ?stockpile_unit ?consumable_requirement)
        )
      )
  )
  (:action assign_tool_to_unit
    :parameters (?stockpile_unit - stockpile_unit ?tool - tool)
    :precondition
      (and
        (ready_for_tooling ?stockpile_unit)
        (tool_available ?tool)
      )
    :effect
      (and
        (unit_assigned_tool ?stockpile_unit ?tool)
        (not
          (tool_available ?tool)
        )
      )
  )
  (:action release_tool_from_unit
    :parameters (?stockpile_unit - stockpile_unit ?tool - tool)
    :precondition
      (and
        (unit_assigned_tool ?stockpile_unit ?tool)
      )
    :effect
      (and
        (tool_available ?tool)
        (not
          (unit_assigned_tool ?stockpile_unit ?tool)
        )
      )
  )
  (:action mount_maintenance_part_on_station
    :parameters (?maintenance_station - maintenance_station ?maintenance_part - maintenance_part)
    :precondition
      (and
        (ready_for_tooling ?maintenance_station)
        (maintenance_part_available ?maintenance_part)
      )
    :effect
      (and
        (station_has_maintenance_part ?maintenance_station ?maintenance_part)
        (not
          (maintenance_part_available ?maintenance_part)
        )
      )
  )
  (:action unmount_maintenance_part_from_station
    :parameters (?maintenance_station - maintenance_station ?maintenance_part - maintenance_part)
    :precondition
      (and
        (station_has_maintenance_part ?maintenance_station ?maintenance_part)
      )
    :effect
      (and
        (maintenance_part_available ?maintenance_part)
        (not
          (station_has_maintenance_part ?maintenance_station ?maintenance_part)
        )
      )
  )
  (:action mount_maintenance_kit_on_station
    :parameters (?maintenance_station - maintenance_station ?maintenance_kit - maintenance_kit)
    :precondition
      (and
        (ready_for_tooling ?maintenance_station)
        (maintenance_kit_available ?maintenance_kit)
      )
    :effect
      (and
        (station_has_maintenance_kit ?maintenance_station ?maintenance_kit)
        (not
          (maintenance_kit_available ?maintenance_kit)
        )
      )
  )
  (:action unmount_maintenance_kit_from_station
    :parameters (?maintenance_station - maintenance_station ?maintenance_kit - maintenance_kit)
    :precondition
      (and
        (station_has_maintenance_kit ?maintenance_station ?maintenance_kit)
      )
    :effect
      (and
        (maintenance_kit_available ?maintenance_kit)
        (not
          (station_has_maintenance_kit ?maintenance_station ?maintenance_kit)
        )
      )
  )
  (:action reserve_storage_condition_a_for_batch
    :parameters (?consumable_batch_a - consumable_batch_a ?storage_condition_a - storage_condition_a ?consumable_requirement - consumable_requirement)
    :precondition
      (and
        (ready_for_tooling ?consumable_batch_a)
        (unit_bound_requirement ?consumable_batch_a ?consumable_requirement)
        (batch_a_assigned_condition_a ?consumable_batch_a ?storage_condition_a)
        (not
          (condition_a_reserved_tool ?storage_condition_a)
        )
        (not
          (condition_a_reserved_material ?storage_condition_a)
        )
      )
    :effect (condition_a_reserved_tool ?storage_condition_a)
  )
  (:action prepare_batch_a_with_tool
    :parameters (?consumable_batch_a - consumable_batch_a ?storage_condition_a - storage_condition_a ?tool - tool)
    :precondition
      (and
        (ready_for_tooling ?consumable_batch_a)
        (unit_assigned_tool ?consumable_batch_a ?tool)
        (batch_a_assigned_condition_a ?consumable_batch_a ?storage_condition_a)
        (condition_a_reserved_tool ?storage_condition_a)
        (not
          (batch_a_condition_prepared ?consumable_batch_a)
        )
      )
    :effect
      (and
        (batch_a_condition_prepared ?consumable_batch_a)
        (batch_a_ready_for_sealing ?consumable_batch_a)
      )
  )
  (:action prepare_batch_a_with_preservation_material
    :parameters (?consumable_batch_a - consumable_batch_a ?storage_condition_a - storage_condition_a ?preservation_material - preservation_material)
    :precondition
      (and
        (ready_for_tooling ?consumable_batch_a)
        (batch_a_assigned_condition_a ?consumable_batch_a ?storage_condition_a)
        (preservation_material_available ?preservation_material)
        (not
          (batch_a_condition_prepared ?consumable_batch_a)
        )
      )
    :effect
      (and
        (condition_a_reserved_material ?storage_condition_a)
        (batch_a_condition_prepared ?consumable_batch_a)
        (batch_a_has_preservation_material ?consumable_batch_a ?preservation_material)
        (not
          (preservation_material_available ?preservation_material)
        )
      )
  )
  (:action finalize_batch_a_condition_with_material
    :parameters (?consumable_batch_a - consumable_batch_a ?storage_condition_a - storage_condition_a ?consumable_requirement - consumable_requirement ?preservation_material - preservation_material)
    :precondition
      (and
        (ready_for_tooling ?consumable_batch_a)
        (unit_bound_requirement ?consumable_batch_a ?consumable_requirement)
        (batch_a_assigned_condition_a ?consumable_batch_a ?storage_condition_a)
        (condition_a_reserved_material ?storage_condition_a)
        (batch_a_has_preservation_material ?consumable_batch_a ?preservation_material)
        (not
          (batch_a_ready_for_sealing ?consumable_batch_a)
        )
      )
    :effect
      (and
        (condition_a_reserved_tool ?storage_condition_a)
        (batch_a_ready_for_sealing ?consumable_batch_a)
        (preservation_material_available ?preservation_material)
        (not
          (batch_a_has_preservation_material ?consumable_batch_a ?preservation_material)
        )
      )
  )
  (:action reserve_storage_condition_b_for_batch
    :parameters (?consumable_batch_b - consumable_batch_b ?storage_condition_b - storage_condition_b ?consumable_requirement - consumable_requirement)
    :precondition
      (and
        (ready_for_tooling ?consumable_batch_b)
        (unit_bound_requirement ?consumable_batch_b ?consumable_requirement)
        (batch_b_assigned_condition_b ?consumable_batch_b ?storage_condition_b)
        (not
          (condition_b_reserved_tool ?storage_condition_b)
        )
        (not
          (condition_b_reserved_material ?storage_condition_b)
        )
      )
    :effect (condition_b_reserved_tool ?storage_condition_b)
  )
  (:action prepare_batch_b_with_tool
    :parameters (?consumable_batch_b - consumable_batch_b ?storage_condition_b - storage_condition_b ?tool - tool)
    :precondition
      (and
        (ready_for_tooling ?consumable_batch_b)
        (unit_assigned_tool ?consumable_batch_b ?tool)
        (batch_b_assigned_condition_b ?consumable_batch_b ?storage_condition_b)
        (condition_b_reserved_tool ?storage_condition_b)
        (not
          (batch_b_condition_prepared ?consumable_batch_b)
        )
      )
    :effect
      (and
        (batch_b_condition_prepared ?consumable_batch_b)
        (batch_b_ready_for_sealing ?consumable_batch_b)
      )
  )
  (:action prepare_batch_b_with_preservation_material
    :parameters (?consumable_batch_b - consumable_batch_b ?storage_condition_b - storage_condition_b ?preservation_material - preservation_material)
    :precondition
      (and
        (ready_for_tooling ?consumable_batch_b)
        (batch_b_assigned_condition_b ?consumable_batch_b ?storage_condition_b)
        (preservation_material_available ?preservation_material)
        (not
          (batch_b_condition_prepared ?consumable_batch_b)
        )
      )
    :effect
      (and
        (condition_b_reserved_material ?storage_condition_b)
        (batch_b_condition_prepared ?consumable_batch_b)
        (batch_b_has_preservation_material ?consumable_batch_b ?preservation_material)
        (not
          (preservation_material_available ?preservation_material)
        )
      )
  )
  (:action finalize_batch_b_condition_with_material
    :parameters (?consumable_batch_b - consumable_batch_b ?storage_condition_b - storage_condition_b ?consumable_requirement - consumable_requirement ?preservation_material - preservation_material)
    :precondition
      (and
        (ready_for_tooling ?consumable_batch_b)
        (unit_bound_requirement ?consumable_batch_b ?consumable_requirement)
        (batch_b_assigned_condition_b ?consumable_batch_b ?storage_condition_b)
        (condition_b_reserved_material ?storage_condition_b)
        (batch_b_has_preservation_material ?consumable_batch_b ?preservation_material)
        (not
          (batch_b_ready_for_sealing ?consumable_batch_b)
        )
      )
    :effect
      (and
        (condition_b_reserved_tool ?storage_condition_b)
        (batch_b_ready_for_sealing ?consumable_batch_b)
        (preservation_material_available ?preservation_material)
        (not
          (batch_b_has_preservation_material ?consumable_batch_b ?preservation_material)
        )
      )
  )
  (:action prepare_container_with_conditions
    :parameters (?consumable_batch_a - consumable_batch_a ?consumable_batch_b - consumable_batch_b ?storage_condition_a - storage_condition_a ?storage_condition_b - storage_condition_b ?container_unit - container_unit)
    :precondition
      (and
        (batch_a_condition_prepared ?consumable_batch_a)
        (batch_b_condition_prepared ?consumable_batch_b)
        (batch_a_assigned_condition_a ?consumable_batch_a ?storage_condition_a)
        (batch_b_assigned_condition_b ?consumable_batch_b ?storage_condition_b)
        (condition_a_reserved_tool ?storage_condition_a)
        (condition_b_reserved_tool ?storage_condition_b)
        (batch_a_ready_for_sealing ?consumable_batch_a)
        (batch_b_ready_for_sealing ?consumable_batch_b)
        (container_available ?container_unit)
      )
    :effect
      (and
        (container_claimed ?container_unit)
        (container_has_condition_a ?container_unit ?storage_condition_a)
        (container_has_condition_b ?container_unit ?storage_condition_b)
        (not
          (container_available ?container_unit)
        )
      )
  )
  (:action configure_container_with_seal_feature_a
    :parameters (?consumable_batch_a - consumable_batch_a ?consumable_batch_b - consumable_batch_b ?storage_condition_a - storage_condition_a ?storage_condition_b - storage_condition_b ?container_unit - container_unit)
    :precondition
      (and
        (batch_a_condition_prepared ?consumable_batch_a)
        (batch_b_condition_prepared ?consumable_batch_b)
        (batch_a_assigned_condition_a ?consumable_batch_a ?storage_condition_a)
        (batch_b_assigned_condition_b ?consumable_batch_b ?storage_condition_b)
        (condition_a_reserved_material ?storage_condition_a)
        (condition_b_reserved_tool ?storage_condition_b)
        (not
          (batch_a_ready_for_sealing ?consumable_batch_a)
        )
        (batch_b_ready_for_sealing ?consumable_batch_b)
        (container_available ?container_unit)
      )
    :effect
      (and
        (container_claimed ?container_unit)
        (container_has_condition_a ?container_unit ?storage_condition_a)
        (container_has_condition_b ?container_unit ?storage_condition_b)
        (container_seal_feature_a ?container_unit)
        (not
          (container_available ?container_unit)
        )
      )
  )
  (:action configure_container_with_seal_feature_b
    :parameters (?consumable_batch_a - consumable_batch_a ?consumable_batch_b - consumable_batch_b ?storage_condition_a - storage_condition_a ?storage_condition_b - storage_condition_b ?container_unit - container_unit)
    :precondition
      (and
        (batch_a_condition_prepared ?consumable_batch_a)
        (batch_b_condition_prepared ?consumable_batch_b)
        (batch_a_assigned_condition_a ?consumable_batch_a ?storage_condition_a)
        (batch_b_assigned_condition_b ?consumable_batch_b ?storage_condition_b)
        (condition_a_reserved_tool ?storage_condition_a)
        (condition_b_reserved_material ?storage_condition_b)
        (batch_a_ready_for_sealing ?consumable_batch_a)
        (not
          (batch_b_ready_for_sealing ?consumable_batch_b)
        )
        (container_available ?container_unit)
      )
    :effect
      (and
        (container_claimed ?container_unit)
        (container_has_condition_a ?container_unit ?storage_condition_a)
        (container_has_condition_b ?container_unit ?storage_condition_b)
        (container_seal_feature_b ?container_unit)
        (not
          (container_available ?container_unit)
        )
      )
  )
  (:action configure_container_with_seal_features_ab
    :parameters (?consumable_batch_a - consumable_batch_a ?consumable_batch_b - consumable_batch_b ?storage_condition_a - storage_condition_a ?storage_condition_b - storage_condition_b ?container_unit - container_unit)
    :precondition
      (and
        (batch_a_condition_prepared ?consumable_batch_a)
        (batch_b_condition_prepared ?consumable_batch_b)
        (batch_a_assigned_condition_a ?consumable_batch_a ?storage_condition_a)
        (batch_b_assigned_condition_b ?consumable_batch_b ?storage_condition_b)
        (condition_a_reserved_material ?storage_condition_a)
        (condition_b_reserved_material ?storage_condition_b)
        (not
          (batch_a_ready_for_sealing ?consumable_batch_a)
        )
        (not
          (batch_b_ready_for_sealing ?consumable_batch_b)
        )
        (container_available ?container_unit)
      )
    :effect
      (and
        (container_claimed ?container_unit)
        (container_has_condition_a ?container_unit ?storage_condition_a)
        (container_has_condition_b ?container_unit ?storage_condition_b)
        (container_seal_feature_a ?container_unit)
        (container_seal_feature_b ?container_unit)
        (not
          (container_available ?container_unit)
        )
      )
  )
  (:action seal_container
    :parameters (?container_unit - container_unit ?consumable_batch_a - consumable_batch_a ?consumable_requirement - consumable_requirement)
    :precondition
      (and
        (container_claimed ?container_unit)
        (batch_a_condition_prepared ?consumable_batch_a)
        (unit_bound_requirement ?consumable_batch_a ?consumable_requirement)
        (not
          (container_sealed ?container_unit)
        )
      )
    :effect (container_sealed ?container_unit)
  )
  (:action mount_component_into_container
    :parameters (?maintenance_station - maintenance_station ?component - component ?container_unit - container_unit)
    :precondition
      (and
        (ready_for_tooling ?maintenance_station)
        (station_assigned_container ?maintenance_station ?container_unit)
        (station_has_component ?maintenance_station ?component)
        (component_available ?component)
        (container_claimed ?container_unit)
        (container_sealed ?container_unit)
        (not
          (component_installed ?component)
        )
      )
    :effect
      (and
        (component_installed ?component)
        (component_installed_in_container ?component ?container_unit)
        (not
          (component_available ?component)
        )
      )
  )
  (:action finalize_component_mount_on_station
    :parameters (?maintenance_station - maintenance_station ?component - component ?container_unit - container_unit ?consumable_requirement - consumable_requirement)
    :precondition
      (and
        (ready_for_tooling ?maintenance_station)
        (station_has_component ?maintenance_station ?component)
        (component_installed ?component)
        (component_installed_in_container ?component ?container_unit)
        (unit_bound_requirement ?maintenance_station ?consumable_requirement)
        (not
          (container_seal_feature_a ?container_unit)
        )
        (not
          (station_components_attached ?maintenance_station)
        )
      )
    :effect (station_components_attached ?maintenance_station)
  )
  (:action install_optional_module_on_station
    :parameters (?maintenance_station - maintenance_station ?special_module - special_module)
    :precondition
      (and
        (ready_for_tooling ?maintenance_station)
        (module_available ?special_module)
        (not
          (station_module_attached ?maintenance_station)
        )
      )
    :effect
      (and
        (station_module_attached ?maintenance_station)
        (station_installed_module ?maintenance_station ?special_module)
        (not
          (module_available ?special_module)
        )
      )
  )
  (:action finish_station_component_module_configuration
    :parameters (?maintenance_station - maintenance_station ?component - component ?container_unit - container_unit ?consumable_requirement - consumable_requirement ?special_module - special_module)
    :precondition
      (and
        (ready_for_tooling ?maintenance_station)
        (station_has_component ?maintenance_station ?component)
        (component_installed ?component)
        (component_installed_in_container ?component ?container_unit)
        (unit_bound_requirement ?maintenance_station ?consumable_requirement)
        (container_seal_feature_a ?container_unit)
        (station_module_attached ?maintenance_station)
        (station_installed_module ?maintenance_station ?special_module)
        (not
          (station_components_attached ?maintenance_station)
        )
      )
    :effect
      (and
        (station_components_attached ?maintenance_station)
        (station_module_configured ?maintenance_station)
      )
  )
  (:action stage_station_for_kit_installation_no_container_feature
    :parameters (?maintenance_station - maintenance_station ?maintenance_part - maintenance_part ?tool - tool ?component - component ?container_unit - container_unit)
    :precondition
      (and
        (station_components_attached ?maintenance_station)
        (station_has_maintenance_part ?maintenance_station ?maintenance_part)
        (unit_assigned_tool ?maintenance_station ?tool)
        (station_has_component ?maintenance_station ?component)
        (component_installed_in_container ?component ?container_unit)
        (not
          (container_seal_feature_b ?container_unit)
        )
        (not
          (station_prepared_for_kit_installation ?maintenance_station)
        )
      )
    :effect (station_prepared_for_kit_installation ?maintenance_station)
  )
  (:action stage_station_for_kit_installation_with_container_feature
    :parameters (?maintenance_station - maintenance_station ?maintenance_part - maintenance_part ?tool - tool ?component - component ?container_unit - container_unit)
    :precondition
      (and
        (station_components_attached ?maintenance_station)
        (station_has_maintenance_part ?maintenance_station ?maintenance_part)
        (unit_assigned_tool ?maintenance_station ?tool)
        (station_has_component ?maintenance_station ?component)
        (component_installed_in_container ?component ?container_unit)
        (container_seal_feature_b ?container_unit)
        (not
          (station_prepared_for_kit_installation ?maintenance_station)
        )
      )
    :effect (station_prepared_for_kit_installation ?maintenance_station)
  )
  (:action apply_maintenance_kit_and_certify_station
    :parameters (?maintenance_station - maintenance_station ?maintenance_kit - maintenance_kit ?component - component ?container_unit - container_unit)
    :precondition
      (and
        (station_prepared_for_kit_installation ?maintenance_station)
        (station_has_maintenance_kit ?maintenance_station ?maintenance_kit)
        (station_has_component ?maintenance_station ?component)
        (component_installed_in_container ?component ?container_unit)
        (not
          (container_seal_feature_a ?container_unit)
        )
        (not
          (container_seal_feature_b ?container_unit)
        )
        (not
          (station_certified_intermediate ?maintenance_station)
        )
      )
    :effect (station_certified_intermediate ?maintenance_station)
  )
  (:action apply_maintenance_kit_and_certify_station_with_feature_a
    :parameters (?maintenance_station - maintenance_station ?maintenance_kit - maintenance_kit ?component - component ?container_unit - container_unit)
    :precondition
      (and
        (station_prepared_for_kit_installation ?maintenance_station)
        (station_has_maintenance_kit ?maintenance_station ?maintenance_kit)
        (station_has_component ?maintenance_station ?component)
        (component_installed_in_container ?component ?container_unit)
        (container_seal_feature_a ?container_unit)
        (not
          (container_seal_feature_b ?container_unit)
        )
        (not
          (station_certified_intermediate ?maintenance_station)
        )
      )
    :effect
      (and
        (station_certified_intermediate ?maintenance_station)
        (station_has_stability_agent ?maintenance_station)
      )
  )
  (:action apply_maintenance_kit_and_certify_station_with_feature_b
    :parameters (?maintenance_station - maintenance_station ?maintenance_kit - maintenance_kit ?component - component ?container_unit - container_unit)
    :precondition
      (and
        (station_prepared_for_kit_installation ?maintenance_station)
        (station_has_maintenance_kit ?maintenance_station ?maintenance_kit)
        (station_has_component ?maintenance_station ?component)
        (component_installed_in_container ?component ?container_unit)
        (not
          (container_seal_feature_a ?container_unit)
        )
        (container_seal_feature_b ?container_unit)
        (not
          (station_certified_intermediate ?maintenance_station)
        )
      )
    :effect
      (and
        (station_certified_intermediate ?maintenance_station)
        (station_has_stability_agent ?maintenance_station)
      )
  )
  (:action apply_maintenance_kit_and_certify_station_with_features_ab
    :parameters (?maintenance_station - maintenance_station ?maintenance_kit - maintenance_kit ?component - component ?container_unit - container_unit)
    :precondition
      (and
        (station_prepared_for_kit_installation ?maintenance_station)
        (station_has_maintenance_kit ?maintenance_station ?maintenance_kit)
        (station_has_component ?maintenance_station ?component)
        (component_installed_in_container ?component ?container_unit)
        (container_seal_feature_a ?container_unit)
        (container_seal_feature_b ?container_unit)
        (not
          (station_certified_intermediate ?maintenance_station)
        )
      )
    :effect
      (and
        (station_certified_intermediate ?maintenance_station)
        (station_has_stability_agent ?maintenance_station)
      )
  )
  (:action commit_station_and_mark_ready
    :parameters (?maintenance_station - maintenance_station)
    :precondition
      (and
        (station_certified_intermediate ?maintenance_station)
        (not
          (station_has_stability_agent ?maintenance_station)
        )
        (not
          (station_committed ?maintenance_station)
        )
      )
    :effect
      (and
        (station_committed ?maintenance_station)
        (ready_for_activation ?maintenance_station)
      )
  )
  (:action install_stability_agent_on_station
    :parameters (?maintenance_station - maintenance_station ?stability_agent - stability_agent)
    :precondition
      (and
        (station_certified_intermediate ?maintenance_station)
        (station_has_stability_agent ?maintenance_station)
        (stability_agent_available ?stability_agent)
      )
    :effect
      (and
        (station_has_stability_agent_installed ?maintenance_station ?stability_agent)
        (not
          (stability_agent_available ?stability_agent)
        )
      )
  )
  (:action finalize_station_assembly
    :parameters (?maintenance_station - maintenance_station ?consumable_batch_a - consumable_batch_a ?consumable_batch_b - consumable_batch_b ?consumable_requirement - consumable_requirement ?stability_agent - stability_agent)
    :precondition
      (and
        (station_certified_intermediate ?maintenance_station)
        (station_has_stability_agent ?maintenance_station)
        (station_has_stability_agent_installed ?maintenance_station ?stability_agent)
        (station_assigned_batch_a ?maintenance_station ?consumable_batch_a)
        (station_assigned_batch_b ?maintenance_station ?consumable_batch_b)
        (batch_a_ready_for_sealing ?consumable_batch_a)
        (batch_b_ready_for_sealing ?consumable_batch_b)
        (unit_bound_requirement ?maintenance_station ?consumable_requirement)
        (not
          (station_assembly_finalized ?maintenance_station)
        )
      )
    :effect (station_assembly_finalized ?maintenance_station)
  )
  (:action finalize_station_commitment
    :parameters (?maintenance_station - maintenance_station)
    :precondition
      (and
        (station_certified_intermediate ?maintenance_station)
        (station_assembly_finalized ?maintenance_station)
        (not
          (station_committed ?maintenance_station)
        )
      )
    :effect
      (and
        (station_committed ?maintenance_station)
        (ready_for_activation ?maintenance_station)
      )
  )
  (:action authorize_station_with_token
    :parameters (?maintenance_station - maintenance_station ?authorization_token - authorization_token ?consumable_requirement - consumable_requirement)
    :precondition
      (and
        (ready_for_tooling ?maintenance_station)
        (unit_bound_requirement ?maintenance_station ?consumable_requirement)
        (authorization_token_available ?authorization_token)
        (station_has_authorization ?maintenance_station ?authorization_token)
        (not
          (station_authorized ?maintenance_station)
        )
      )
    :effect
      (and
        (station_authorized ?maintenance_station)
        (not
          (authorization_token_available ?authorization_token)
        )
      )
  )
  (:action lock_station_authorization_for_tool
    :parameters (?maintenance_station - maintenance_station ?tool - tool)
    :precondition
      (and
        (station_authorized ?maintenance_station)
        (unit_assigned_tool ?maintenance_station ?tool)
        (not
          (station_authorization_locked ?maintenance_station)
        )
      )
    :effect (station_authorization_locked ?maintenance_station)
  )
  (:action confirm_station_authorization_with_kit
    :parameters (?maintenance_station - maintenance_station ?maintenance_kit - maintenance_kit)
    :precondition
      (and
        (station_authorization_locked ?maintenance_station)
        (station_has_maintenance_kit ?maintenance_station ?maintenance_kit)
        (not
          (station_authorization_confirmed ?maintenance_station)
        )
      )
    :effect (station_authorization_confirmed ?maintenance_station)
  )
  (:action finalize_authorized_station_commitment
    :parameters (?maintenance_station - maintenance_station)
    :precondition
      (and
        (station_authorization_confirmed ?maintenance_station)
        (not
          (station_committed ?maintenance_station)
        )
      )
    :effect
      (and
        (station_committed ?maintenance_station)
        (ready_for_activation ?maintenance_station)
      )
  )
  (:action certify_batch_a_for_preservation
    :parameters (?consumable_batch_a - consumable_batch_a ?container_unit - container_unit)
    :precondition
      (and
        (batch_a_condition_prepared ?consumable_batch_a)
        (batch_a_ready_for_sealing ?consumable_batch_a)
        (container_claimed ?container_unit)
        (container_sealed ?container_unit)
        (not
          (ready_for_activation ?consumable_batch_a)
        )
      )
    :effect (ready_for_activation ?consumable_batch_a)
  )
  (:action certify_batch_b_for_preservation
    :parameters (?consumable_batch_b - consumable_batch_b ?container_unit - container_unit)
    :precondition
      (and
        (batch_b_condition_prepared ?consumable_batch_b)
        (batch_b_ready_for_sealing ?consumable_batch_b)
        (container_claimed ?container_unit)
        (container_sealed ?container_unit)
        (not
          (ready_for_activation ?consumable_batch_b)
        )
      )
    :effect (ready_for_activation ?consumable_batch_b)
  )
  (:action activate_preservation_on_unit
    :parameters (?stockpile_unit - stockpile_unit ?preservation_supply - preservation_supply ?consumable_requirement - consumable_requirement)
    :precondition
      (and
        (ready_for_activation ?stockpile_unit)
        (unit_bound_requirement ?stockpile_unit ?consumable_requirement)
        (preservation_supply_available ?preservation_supply)
        (not
          (preservation_activated ?stockpile_unit)
        )
      )
    :effect
      (and
        (preservation_activated ?stockpile_unit)
        (unit_has_preservation_supply ?stockpile_unit ?preservation_supply)
        (not
          (preservation_supply_available ?preservation_supply)
        )
      )
  )
  (:action finalize_preservation_for_batch_a
    :parameters (?consumable_batch_a - consumable_batch_a ?resource_token - resource_token ?preservation_supply - preservation_supply)
    :precondition
      (and
        (preservation_activated ?consumable_batch_a)
        (preservation_unit_assigned_resource_token ?consumable_batch_a ?resource_token)
        (unit_has_preservation_supply ?consumable_batch_a ?preservation_supply)
        (not
          (preservation_completed ?consumable_batch_a)
        )
      )
    :effect
      (and
        (preservation_completed ?consumable_batch_a)
        (resource_token_available ?resource_token)
        (preservation_supply_available ?preservation_supply)
      )
  )
  (:action finalize_preservation_for_batch_b
    :parameters (?consumable_batch_b - consumable_batch_b ?resource_token - resource_token ?preservation_supply - preservation_supply)
    :precondition
      (and
        (preservation_activated ?consumable_batch_b)
        (preservation_unit_assigned_resource_token ?consumable_batch_b ?resource_token)
        (unit_has_preservation_supply ?consumable_batch_b ?preservation_supply)
        (not
          (preservation_completed ?consumable_batch_b)
        )
      )
    :effect
      (and
        (preservation_completed ?consumable_batch_b)
        (resource_token_available ?resource_token)
        (preservation_supply_available ?preservation_supply)
      )
  )
  (:action finalize_preservation_for_station
    :parameters (?maintenance_station - maintenance_station ?resource_token - resource_token ?preservation_supply - preservation_supply)
    :precondition
      (and
        (preservation_activated ?maintenance_station)
        (preservation_unit_assigned_resource_token ?maintenance_station ?resource_token)
        (unit_has_preservation_supply ?maintenance_station ?preservation_supply)
        (not
          (preservation_completed ?maintenance_station)
        )
      )
    :effect
      (and
        (preservation_completed ?maintenance_station)
        (resource_token_available ?resource_token)
        (preservation_supply_available ?preservation_supply)
      )
  )
)

(define (domain map_hazard_expansion_route_repair_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types mobile_asset_class - object equipment_class - object resource_class - object location_class - object map_location - location_class repair_team - mobile_asset_class tool_kit - mobile_asset_class specialist_unit - mobile_asset_class upgrade_module - mobile_asset_class mission_modifier - mobile_asset_class continuation_token - mobile_asset_class vehicle_attachment - mobile_asset_class specialist_module - mobile_asset_class supply_pack - equipment_class repair_component - equipment_class mission_intel - equipment_class route_feature - resource_class alt_route_feature - resource_class vehicle_platform - resource_class primary_segment_class - map_location alternate_segment_class - map_location primary_route_segment - primary_segment_class alternate_route_segment - primary_segment_class team_command - alternate_segment_class)
  (:predicates
    (location_scouted ?map_location - map_location)
    (command_available_at_location ?map_location - map_location)
    (assigned_primary ?map_location - map_location)
    (route_restored_at_location ?map_location - map_location)
    (progress_saved_at_location ?map_location - map_location)
    (recovery_ready_at_location ?map_location - map_location)
    (team_idle ?repair_team - repair_team)
    (team_assigned_to_location ?map_location - map_location ?repair_team - repair_team)
    (tool_available ?tool_kit - tool_kit)
    (tool_deployed ?map_location - map_location ?tool_kit - tool_kit)
    (specialist_idle ?specialist_unit - specialist_unit)
    (specialist_assigned ?map_location - map_location ?specialist_unit - specialist_unit)
    (supply_available ?supply_pack - supply_pack)
    (supply_loaded ?primary_route_segment - primary_route_segment ?supply_pack - supply_pack)
    (supply_attached_to_segment ?alternate_route_segment - alternate_route_segment ?supply_pack - supply_pack)
    (segment_has_feature ?primary_route_segment - primary_route_segment ?route_feature - route_feature)
    (feature_marked ?route_feature - route_feature)
    (feature_stabilized ?route_feature - route_feature)
    (segment_secured ?primary_route_segment - primary_route_segment)
    (altsegment_has_feature ?alternate_route_segment - alternate_route_segment ?alt_route_feature - alt_route_feature)
    (alt_feature_marked ?alt_route_feature - alt_route_feature)
    (alt_feature_stabilized ?alt_route_feature - alt_route_feature)
    (alt_segment_secured ?alternate_route_segment - alternate_route_segment)
    (vehicle_idle ?vehicle_platform - vehicle_platform)
    (vehicle_deployed ?vehicle_platform - vehicle_platform)
    (vehicle_linked_to_feature ?vehicle_platform - vehicle_platform ?route_feature - route_feature)
    (vehicle_linked_to_altfeature ?vehicle_platform - vehicle_platform ?alt_route_feature - alt_route_feature)
    (vehicle_has_attachment_a ?vehicle_platform - vehicle_platform)
    (vehicle_has_attachment_b ?vehicle_platform - vehicle_platform)
    (vehicle_activation_confirmed ?vehicle_platform - vehicle_platform)
    (command_controls_primary_segment ?team_command - team_command ?primary_route_segment - primary_route_segment)
    (command_controls_alt_segment ?team_command - team_command ?alternate_route_segment - alternate_route_segment)
    (command_assigned_vehicle ?team_command - team_command ?vehicle_platform - vehicle_platform)
    (component_available ?repair_component - repair_component)
    (command_owns_component ?team_command - team_command ?repair_component - repair_component)
    (component_installed ?repair_component - repair_component)
    (component_attached_to_vehicle ?repair_component - repair_component ?vehicle_platform - vehicle_platform)
    (command_prepared_for_execution ?team_command - team_command)
    (command_ready_for_attachments ?team_command - team_command)
    (command_has_module_flag ?team_command - team_command)
    (upgrade_applied_step1 ?team_command - team_command)
    (upgrade_applied_step2 ?team_command - team_command)
    (module_confirmed ?team_command - team_command)
    (execution_committed ?team_command - team_command)
    (intel_available ?mission_intel - mission_intel)
    (intel_bound_to_command ?team_command - team_command ?mission_intel - mission_intel)
    (intel_activated ?team_command - team_command)
    (intel_step_ready ?team_command - team_command)
    (intel_applied_final ?team_command - team_command)
    (upgrade_module_available ?upgrade_module - upgrade_module)
    (upgrade_module_assigned ?team_command - team_command ?upgrade_module - upgrade_module)
    (mission_modifier_available ?mission_modifier - mission_modifier)
    (mission_modifier_assigned ?team_command - team_command ?mission_modifier - mission_modifier)
    (attachment_available ?vehicle_attachment - vehicle_attachment)
    (attachment_installed_on_command ?team_command - team_command ?vehicle_attachment - vehicle_attachment)
    (specialist_module_available ?specialist_module - specialist_module)
    (specialist_module_assigned ?team_command - team_command ?specialist_module - specialist_module)
    (continuation_token_available ?continuation_token - continuation_token)
    (continuation_token_bound ?map_location - map_location ?continuation_token - continuation_token)
    (segment_ready_flag ?primary_route_segment - primary_route_segment)
    (alt_segment_ready_flag ?alternate_route_segment - alternate_route_segment)
    (command_finalized ?team_command - team_command)
  )
  (:action scout_location
    :parameters (?map_location - map_location)
    :precondition
      (and
        (not
          (location_scouted ?map_location)
        )
        (not
          (route_restored_at_location ?map_location)
        )
      )
    :effect (location_scouted ?map_location)
  )
  (:action assign_repair_team_to_location
    :parameters (?map_location - map_location ?repair_team - repair_team)
    :precondition
      (and
        (location_scouted ?map_location)
        (not
          (assigned_primary ?map_location)
        )
        (team_idle ?repair_team)
      )
    :effect
      (and
        (assigned_primary ?map_location)
        (team_assigned_to_location ?map_location ?repair_team)
        (not
          (team_idle ?repair_team)
        )
      )
  )
  (:action deploy_tool_to_location
    :parameters (?map_location - map_location ?tool_kit - tool_kit)
    :precondition
      (and
        (location_scouted ?map_location)
        (assigned_primary ?map_location)
        (tool_available ?tool_kit)
      )
    :effect
      (and
        (tool_deployed ?map_location ?tool_kit)
        (not
          (tool_available ?tool_kit)
        )
      )
  )
  (:action establish_command_at_location
    :parameters (?map_location - map_location ?tool_kit - tool_kit)
    :precondition
      (and
        (location_scouted ?map_location)
        (assigned_primary ?map_location)
        (tool_deployed ?map_location ?tool_kit)
        (not
          (command_available_at_location ?map_location)
        )
      )
    :effect (command_available_at_location ?map_location)
  )
  (:action return_tool_to_inventory
    :parameters (?map_location - map_location ?tool_kit - tool_kit)
    :precondition
      (and
        (tool_deployed ?map_location ?tool_kit)
      )
    :effect
      (and
        (tool_available ?tool_kit)
        (not
          (tool_deployed ?map_location ?tool_kit)
        )
      )
  )
  (:action assign_specialist_to_location
    :parameters (?map_location - map_location ?specialist_unit - specialist_unit)
    :precondition
      (and
        (command_available_at_location ?map_location)
        (specialist_idle ?specialist_unit)
      )
    :effect
      (and
        (specialist_assigned ?map_location ?specialist_unit)
        (not
          (specialist_idle ?specialist_unit)
        )
      )
  )
  (:action release_specialist_from_location
    :parameters (?map_location - map_location ?specialist_unit - specialist_unit)
    :precondition
      (and
        (specialist_assigned ?map_location ?specialist_unit)
      )
    :effect
      (and
        (specialist_idle ?specialist_unit)
        (not
          (specialist_assigned ?map_location ?specialist_unit)
        )
      )
  )
  (:action install_attachment_on_command
    :parameters (?team_command - team_command ?vehicle_attachment - vehicle_attachment)
    :precondition
      (and
        (command_available_at_location ?team_command)
        (attachment_available ?vehicle_attachment)
      )
    :effect
      (and
        (attachment_installed_on_command ?team_command ?vehicle_attachment)
        (not
          (attachment_available ?vehicle_attachment)
        )
      )
  )
  (:action remove_attachment_from_command
    :parameters (?team_command - team_command ?vehicle_attachment - vehicle_attachment)
    :precondition
      (and
        (attachment_installed_on_command ?team_command ?vehicle_attachment)
      )
    :effect
      (and
        (attachment_available ?vehicle_attachment)
        (not
          (attachment_installed_on_command ?team_command ?vehicle_attachment)
        )
      )
  )
  (:action assign_specialist_module_to_command
    :parameters (?team_command - team_command ?specialist_module - specialist_module)
    :precondition
      (and
        (command_available_at_location ?team_command)
        (specialist_module_available ?specialist_module)
      )
    :effect
      (and
        (specialist_module_assigned ?team_command ?specialist_module)
        (not
          (specialist_module_available ?specialist_module)
        )
      )
  )
  (:action remove_specialist_module_from_command
    :parameters (?team_command - team_command ?specialist_module - specialist_module)
    :precondition
      (and
        (specialist_module_assigned ?team_command ?specialist_module)
      )
    :effect
      (and
        (specialist_module_available ?specialist_module)
        (not
          (specialist_module_assigned ?team_command ?specialist_module)
        )
      )
  )
  (:action mark_route_feature
    :parameters (?primary_route_segment - primary_route_segment ?route_feature - route_feature ?tool_kit - tool_kit)
    :precondition
      (and
        (command_available_at_location ?primary_route_segment)
        (tool_deployed ?primary_route_segment ?tool_kit)
        (segment_has_feature ?primary_route_segment ?route_feature)
        (not
          (feature_marked ?route_feature)
        )
        (not
          (feature_stabilized ?route_feature)
        )
      )
    :effect (feature_marked ?route_feature)
  )
  (:action stabilize_segment_with_specialist
    :parameters (?primary_route_segment - primary_route_segment ?route_feature - route_feature ?specialist_unit - specialist_unit)
    :precondition
      (and
        (command_available_at_location ?primary_route_segment)
        (specialist_assigned ?primary_route_segment ?specialist_unit)
        (segment_has_feature ?primary_route_segment ?route_feature)
        (feature_marked ?route_feature)
        (not
          (segment_ready_flag ?primary_route_segment)
        )
      )
    :effect
      (and
        (segment_ready_flag ?primary_route_segment)
        (segment_secured ?primary_route_segment)
      )
  )
  (:action deploy_supply_to_feature
    :parameters (?primary_route_segment - primary_route_segment ?route_feature - route_feature ?supply_pack - supply_pack)
    :precondition
      (and
        (command_available_at_location ?primary_route_segment)
        (segment_has_feature ?primary_route_segment ?route_feature)
        (supply_available ?supply_pack)
        (not
          (segment_ready_flag ?primary_route_segment)
        )
      )
    :effect
      (and
        (feature_stabilized ?route_feature)
        (segment_ready_flag ?primary_route_segment)
        (supply_loaded ?primary_route_segment ?supply_pack)
        (not
          (supply_available ?supply_pack)
        )
      )
  )
  (:action finalize_feature_stabilization
    :parameters (?primary_route_segment - primary_route_segment ?route_feature - route_feature ?tool_kit - tool_kit ?supply_pack - supply_pack)
    :precondition
      (and
        (command_available_at_location ?primary_route_segment)
        (tool_deployed ?primary_route_segment ?tool_kit)
        (segment_has_feature ?primary_route_segment ?route_feature)
        (feature_stabilized ?route_feature)
        (supply_loaded ?primary_route_segment ?supply_pack)
        (not
          (segment_secured ?primary_route_segment)
        )
      )
    :effect
      (and
        (feature_marked ?route_feature)
        (segment_secured ?primary_route_segment)
        (supply_available ?supply_pack)
        (not
          (supply_loaded ?primary_route_segment ?supply_pack)
        )
      )
  )
  (:action mark_alt_route_feature
    :parameters (?alternate_route_segment - alternate_route_segment ?alt_route_feature - alt_route_feature ?tool_kit - tool_kit)
    :precondition
      (and
        (command_available_at_location ?alternate_route_segment)
        (tool_deployed ?alternate_route_segment ?tool_kit)
        (altsegment_has_feature ?alternate_route_segment ?alt_route_feature)
        (not
          (alt_feature_marked ?alt_route_feature)
        )
        (not
          (alt_feature_stabilized ?alt_route_feature)
        )
      )
    :effect (alt_feature_marked ?alt_route_feature)
  )
  (:action stabilize_alt_segment_with_specialist
    :parameters (?alternate_route_segment - alternate_route_segment ?alt_route_feature - alt_route_feature ?specialist_unit - specialist_unit)
    :precondition
      (and
        (command_available_at_location ?alternate_route_segment)
        (specialist_assigned ?alternate_route_segment ?specialist_unit)
        (altsegment_has_feature ?alternate_route_segment ?alt_route_feature)
        (alt_feature_marked ?alt_route_feature)
        (not
          (alt_segment_ready_flag ?alternate_route_segment)
        )
      )
    :effect
      (and
        (alt_segment_ready_flag ?alternate_route_segment)
        (alt_segment_secured ?alternate_route_segment)
      )
  )
  (:action deploy_supply_to_alt_feature
    :parameters (?alternate_route_segment - alternate_route_segment ?alt_route_feature - alt_route_feature ?supply_pack - supply_pack)
    :precondition
      (and
        (command_available_at_location ?alternate_route_segment)
        (altsegment_has_feature ?alternate_route_segment ?alt_route_feature)
        (supply_available ?supply_pack)
        (not
          (alt_segment_ready_flag ?alternate_route_segment)
        )
      )
    :effect
      (and
        (alt_feature_stabilized ?alt_route_feature)
        (alt_segment_ready_flag ?alternate_route_segment)
        (supply_attached_to_segment ?alternate_route_segment ?supply_pack)
        (not
          (supply_available ?supply_pack)
        )
      )
  )
  (:action finalize_alt_feature_stabilization
    :parameters (?alternate_route_segment - alternate_route_segment ?alt_route_feature - alt_route_feature ?tool_kit - tool_kit ?supply_pack - supply_pack)
    :precondition
      (and
        (command_available_at_location ?alternate_route_segment)
        (tool_deployed ?alternate_route_segment ?tool_kit)
        (altsegment_has_feature ?alternate_route_segment ?alt_route_feature)
        (alt_feature_stabilized ?alt_route_feature)
        (supply_attached_to_segment ?alternate_route_segment ?supply_pack)
        (not
          (alt_segment_secured ?alternate_route_segment)
        )
      )
    :effect
      (and
        (alt_feature_marked ?alt_route_feature)
        (alt_segment_secured ?alternate_route_segment)
        (supply_available ?supply_pack)
        (not
          (supply_attached_to_segment ?alternate_route_segment ?supply_pack)
        )
      )
  )
  (:action deploy_vehicle_and_link_features
    :parameters (?primary_route_segment - primary_route_segment ?alternate_route_segment - alternate_route_segment ?route_feature - route_feature ?alt_route_feature - alt_route_feature ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (segment_ready_flag ?primary_route_segment)
        (alt_segment_ready_flag ?alternate_route_segment)
        (segment_has_feature ?primary_route_segment ?route_feature)
        (altsegment_has_feature ?alternate_route_segment ?alt_route_feature)
        (feature_marked ?route_feature)
        (alt_feature_marked ?alt_route_feature)
        (segment_secured ?primary_route_segment)
        (alt_segment_secured ?alternate_route_segment)
        (vehicle_idle ?vehicle_platform)
      )
    :effect
      (and
        (vehicle_deployed ?vehicle_platform)
        (vehicle_linked_to_feature ?vehicle_platform ?route_feature)
        (vehicle_linked_to_altfeature ?vehicle_platform ?alt_route_feature)
        (not
          (vehicle_idle ?vehicle_platform)
        )
      )
  )
  (:action deploy_vehicle_with_attachment_a
    :parameters (?primary_route_segment - primary_route_segment ?alternate_route_segment - alternate_route_segment ?route_feature - route_feature ?alt_route_feature - alt_route_feature ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (segment_ready_flag ?primary_route_segment)
        (alt_segment_ready_flag ?alternate_route_segment)
        (segment_has_feature ?primary_route_segment ?route_feature)
        (altsegment_has_feature ?alternate_route_segment ?alt_route_feature)
        (feature_stabilized ?route_feature)
        (alt_feature_marked ?alt_route_feature)
        (not
          (segment_secured ?primary_route_segment)
        )
        (alt_segment_secured ?alternate_route_segment)
        (vehicle_idle ?vehicle_platform)
      )
    :effect
      (and
        (vehicle_deployed ?vehicle_platform)
        (vehicle_linked_to_feature ?vehicle_platform ?route_feature)
        (vehicle_linked_to_altfeature ?vehicle_platform ?alt_route_feature)
        (vehicle_has_attachment_a ?vehicle_platform)
        (not
          (vehicle_idle ?vehicle_platform)
        )
      )
  )
  (:action deploy_vehicle_with_attachment_b
    :parameters (?primary_route_segment - primary_route_segment ?alternate_route_segment - alternate_route_segment ?route_feature - route_feature ?alt_route_feature - alt_route_feature ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (segment_ready_flag ?primary_route_segment)
        (alt_segment_ready_flag ?alternate_route_segment)
        (segment_has_feature ?primary_route_segment ?route_feature)
        (altsegment_has_feature ?alternate_route_segment ?alt_route_feature)
        (feature_marked ?route_feature)
        (alt_feature_stabilized ?alt_route_feature)
        (segment_secured ?primary_route_segment)
        (not
          (alt_segment_secured ?alternate_route_segment)
        )
        (vehicle_idle ?vehicle_platform)
      )
    :effect
      (and
        (vehicle_deployed ?vehicle_platform)
        (vehicle_linked_to_feature ?vehicle_platform ?route_feature)
        (vehicle_linked_to_altfeature ?vehicle_platform ?alt_route_feature)
        (vehicle_has_attachment_b ?vehicle_platform)
        (not
          (vehicle_idle ?vehicle_platform)
        )
      )
  )
  (:action deploy_vehicle_with_attachments_ab
    :parameters (?primary_route_segment - primary_route_segment ?alternate_route_segment - alternate_route_segment ?route_feature - route_feature ?alt_route_feature - alt_route_feature ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (segment_ready_flag ?primary_route_segment)
        (alt_segment_ready_flag ?alternate_route_segment)
        (segment_has_feature ?primary_route_segment ?route_feature)
        (altsegment_has_feature ?alternate_route_segment ?alt_route_feature)
        (feature_stabilized ?route_feature)
        (alt_feature_stabilized ?alt_route_feature)
        (not
          (segment_secured ?primary_route_segment)
        )
        (not
          (alt_segment_secured ?alternate_route_segment)
        )
        (vehicle_idle ?vehicle_platform)
      )
    :effect
      (and
        (vehicle_deployed ?vehicle_platform)
        (vehicle_linked_to_feature ?vehicle_platform ?route_feature)
        (vehicle_linked_to_altfeature ?vehicle_platform ?alt_route_feature)
        (vehicle_has_attachment_a ?vehicle_platform)
        (vehicle_has_attachment_b ?vehicle_platform)
        (not
          (vehicle_idle ?vehicle_platform)
        )
      )
  )
  (:action confirm_vehicle_activation
    :parameters (?vehicle_platform - vehicle_platform ?primary_route_segment - primary_route_segment ?tool_kit - tool_kit)
    :precondition
      (and
        (vehicle_deployed ?vehicle_platform)
        (segment_ready_flag ?primary_route_segment)
        (tool_deployed ?primary_route_segment ?tool_kit)
        (not
          (vehicle_activation_confirmed ?vehicle_platform)
        )
      )
    :effect (vehicle_activation_confirmed ?vehicle_platform)
  )
  (:action prepare_and_attach_component
    :parameters (?team_command - team_command ?repair_component - repair_component ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (command_available_at_location ?team_command)
        (command_assigned_vehicle ?team_command ?vehicle_platform)
        (command_owns_component ?team_command ?repair_component)
        (component_available ?repair_component)
        (vehicle_deployed ?vehicle_platform)
        (vehicle_activation_confirmed ?vehicle_platform)
        (not
          (component_installed ?repair_component)
        )
      )
    :effect
      (and
        (component_installed ?repair_component)
        (component_attached_to_vehicle ?repair_component ?vehicle_platform)
        (not
          (component_available ?repair_component)
        )
      )
  )
  (:action prepare_command_for_execution
    :parameters (?team_command - team_command ?repair_component - repair_component ?vehicle_platform - vehicle_platform ?tool_kit - tool_kit)
    :precondition
      (and
        (command_available_at_location ?team_command)
        (command_owns_component ?team_command ?repair_component)
        (component_installed ?repair_component)
        (component_attached_to_vehicle ?repair_component ?vehicle_platform)
        (tool_deployed ?team_command ?tool_kit)
        (not
          (vehicle_has_attachment_a ?vehicle_platform)
        )
        (not
          (command_prepared_for_execution ?team_command)
        )
      )
    :effect (command_prepared_for_execution ?team_command)
  )
  (:action assign_upgrade_module_to_command
    :parameters (?team_command - team_command ?upgrade_module - upgrade_module)
    :precondition
      (and
        (command_available_at_location ?team_command)
        (upgrade_module_available ?upgrade_module)
        (not
          (upgrade_applied_step1 ?team_command)
        )
      )
    :effect
      (and
        (upgrade_applied_step1 ?team_command)
        (upgrade_module_assigned ?team_command ?upgrade_module)
        (not
          (upgrade_module_available ?upgrade_module)
        )
      )
  )
  (:action apply_upgrade_and_stage2
    :parameters (?team_command - team_command ?repair_component - repair_component ?vehicle_platform - vehicle_platform ?tool_kit - tool_kit ?upgrade_module - upgrade_module)
    :precondition
      (and
        (command_available_at_location ?team_command)
        (command_owns_component ?team_command ?repair_component)
        (component_installed ?repair_component)
        (component_attached_to_vehicle ?repair_component ?vehicle_platform)
        (tool_deployed ?team_command ?tool_kit)
        (vehicle_has_attachment_a ?vehicle_platform)
        (upgrade_applied_step1 ?team_command)
        (upgrade_module_assigned ?team_command ?upgrade_module)
        (not
          (command_prepared_for_execution ?team_command)
        )
      )
    :effect
      (and
        (command_prepared_for_execution ?team_command)
        (upgrade_applied_step2 ?team_command)
      )
  )
  (:action ready_command_for_attachments
    :parameters (?team_command - team_command ?vehicle_attachment - vehicle_attachment ?specialist_unit - specialist_unit ?repair_component - repair_component ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (command_prepared_for_execution ?team_command)
        (attachment_installed_on_command ?team_command ?vehicle_attachment)
        (specialist_assigned ?team_command ?specialist_unit)
        (command_owns_component ?team_command ?repair_component)
        (component_attached_to_vehicle ?repair_component ?vehicle_platform)
        (not
          (vehicle_has_attachment_b ?vehicle_platform)
        )
        (not
          (command_ready_for_attachments ?team_command)
        )
      )
    :effect (command_ready_for_attachments ?team_command)
  )
  (:action ready_command_for_attachments_confirm
    :parameters (?team_command - team_command ?vehicle_attachment - vehicle_attachment ?specialist_unit - specialist_unit ?repair_component - repair_component ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (command_prepared_for_execution ?team_command)
        (attachment_installed_on_command ?team_command ?vehicle_attachment)
        (specialist_assigned ?team_command ?specialist_unit)
        (command_owns_component ?team_command ?repair_component)
        (component_attached_to_vehicle ?repair_component ?vehicle_platform)
        (vehicle_has_attachment_b ?vehicle_platform)
        (not
          (command_ready_for_attachments ?team_command)
        )
      )
    :effect (command_ready_for_attachments ?team_command)
  )
  (:action flag_command_modules
    :parameters (?team_command - team_command ?specialist_module - specialist_module ?repair_component - repair_component ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (command_ready_for_attachments ?team_command)
        (specialist_module_assigned ?team_command ?specialist_module)
        (command_owns_component ?team_command ?repair_component)
        (component_attached_to_vehicle ?repair_component ?vehicle_platform)
        (not
          (vehicle_has_attachment_a ?vehicle_platform)
        )
        (not
          (vehicle_has_attachment_b ?vehicle_platform)
        )
        (not
          (command_has_module_flag ?team_command)
        )
      )
    :effect (command_has_module_flag ?team_command)
  )
  (:action flag_and_confirm_module_installation
    :parameters (?team_command - team_command ?specialist_module - specialist_module ?repair_component - repair_component ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (command_ready_for_attachments ?team_command)
        (specialist_module_assigned ?team_command ?specialist_module)
        (command_owns_component ?team_command ?repair_component)
        (component_attached_to_vehicle ?repair_component ?vehicle_platform)
        (vehicle_has_attachment_a ?vehicle_platform)
        (not
          (vehicle_has_attachment_b ?vehicle_platform)
        )
        (not
          (command_has_module_flag ?team_command)
        )
      )
    :effect
      (and
        (command_has_module_flag ?team_command)
        (module_confirmed ?team_command)
      )
  )
  (:action flag_and_confirm_module_installation_alt
    :parameters (?team_command - team_command ?specialist_module - specialist_module ?repair_component - repair_component ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (command_ready_for_attachments ?team_command)
        (specialist_module_assigned ?team_command ?specialist_module)
        (command_owns_component ?team_command ?repair_component)
        (component_attached_to_vehicle ?repair_component ?vehicle_platform)
        (not
          (vehicle_has_attachment_a ?vehicle_platform)
        )
        (vehicle_has_attachment_b ?vehicle_platform)
        (not
          (command_has_module_flag ?team_command)
        )
      )
    :effect
      (and
        (command_has_module_flag ?team_command)
        (module_confirmed ?team_command)
      )
  )
  (:action flag_and_confirm_module_installation_full
    :parameters (?team_command - team_command ?specialist_module - specialist_module ?repair_component - repair_component ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (command_ready_for_attachments ?team_command)
        (specialist_module_assigned ?team_command ?specialist_module)
        (command_owns_component ?team_command ?repair_component)
        (component_attached_to_vehicle ?repair_component ?vehicle_platform)
        (vehicle_has_attachment_a ?vehicle_platform)
        (vehicle_has_attachment_b ?vehicle_platform)
        (not
          (command_has_module_flag ?team_command)
        )
      )
    :effect
      (and
        (command_has_module_flag ?team_command)
        (module_confirmed ?team_command)
      )
  )
  (:action finalize_command_and_save_progress
    :parameters (?team_command - team_command)
    :precondition
      (and
        (command_has_module_flag ?team_command)
        (not
          (module_confirmed ?team_command)
        )
        (not
          (command_finalized ?team_command)
        )
      )
    :effect
      (and
        (command_finalized ?team_command)
        (progress_saved_at_location ?team_command)
      )
  )
  (:action assign_mission_modifier_to_command
    :parameters (?team_command - team_command ?mission_modifier - mission_modifier)
    :precondition
      (and
        (command_has_module_flag ?team_command)
        (module_confirmed ?team_command)
        (mission_modifier_available ?mission_modifier)
      )
    :effect
      (and
        (mission_modifier_assigned ?team_command ?mission_modifier)
        (not
          (mission_modifier_available ?mission_modifier)
        )
      )
  )
  (:action commit_execution_for_command
    :parameters (?team_command - team_command ?primary_route_segment - primary_route_segment ?alternate_route_segment - alternate_route_segment ?tool_kit - tool_kit ?mission_modifier - mission_modifier)
    :precondition
      (and
        (command_has_module_flag ?team_command)
        (module_confirmed ?team_command)
        (mission_modifier_assigned ?team_command ?mission_modifier)
        (command_controls_primary_segment ?team_command ?primary_route_segment)
        (command_controls_alt_segment ?team_command ?alternate_route_segment)
        (segment_secured ?primary_route_segment)
        (alt_segment_secured ?alternate_route_segment)
        (tool_deployed ?team_command ?tool_kit)
        (not
          (execution_committed ?team_command)
        )
      )
    :effect (execution_committed ?team_command)
  )
  (:action finalize_command_execution
    :parameters (?team_command - team_command)
    :precondition
      (and
        (command_has_module_flag ?team_command)
        (execution_committed ?team_command)
        (not
          (command_finalized ?team_command)
        )
      )
    :effect
      (and
        (command_finalized ?team_command)
        (progress_saved_at_location ?team_command)
      )
  )
  (:action activate_intel_on_command
    :parameters (?team_command - team_command ?mission_intel - mission_intel ?tool_kit - tool_kit)
    :precondition
      (and
        (command_available_at_location ?team_command)
        (tool_deployed ?team_command ?tool_kit)
        (intel_available ?mission_intel)
        (intel_bound_to_command ?team_command ?mission_intel)
        (not
          (intel_activated ?team_command)
        )
      )
    :effect
      (and
        (intel_activated ?team_command)
        (not
          (intel_available ?mission_intel)
        )
      )
  )
  (:action prepare_command_after_intel
    :parameters (?team_command - team_command ?specialist_unit - specialist_unit)
    :precondition
      (and
        (intel_activated ?team_command)
        (specialist_assigned ?team_command ?specialist_unit)
        (not
          (intel_step_ready ?team_command)
        )
      )
    :effect (intel_step_ready ?team_command)
  )
  (:action apply_final_intel_to_command
    :parameters (?team_command - team_command ?specialist_module - specialist_module)
    :precondition
      (and
        (intel_step_ready ?team_command)
        (specialist_module_assigned ?team_command ?specialist_module)
        (not
          (intel_applied_final ?team_command)
        )
      )
    :effect (intel_applied_final ?team_command)
  )
  (:action finalize_intel_and_save_progress
    :parameters (?team_command - team_command)
    :precondition
      (and
        (intel_applied_final ?team_command)
        (not
          (command_finalized ?team_command)
        )
      )
    :effect
      (and
        (command_finalized ?team_command)
        (progress_saved_at_location ?team_command)
      )
  )
  (:action record_segment_progress
    :parameters (?primary_route_segment - primary_route_segment ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (segment_ready_flag ?primary_route_segment)
        (segment_secured ?primary_route_segment)
        (vehicle_deployed ?vehicle_platform)
        (vehicle_activation_confirmed ?vehicle_platform)
        (not
          (progress_saved_at_location ?primary_route_segment)
        )
      )
    :effect (progress_saved_at_location ?primary_route_segment)
  )
  (:action record_alt_segment_progress
    :parameters (?alternate_route_segment - alternate_route_segment ?vehicle_platform - vehicle_platform)
    :precondition
      (and
        (alt_segment_ready_flag ?alternate_route_segment)
        (alt_segment_secured ?alternate_route_segment)
        (vehicle_deployed ?vehicle_platform)
        (vehicle_activation_confirmed ?vehicle_platform)
        (not
          (progress_saved_at_location ?alternate_route_segment)
        )
      )
    :effect (progress_saved_at_location ?alternate_route_segment)
  )
  (:action consume_continuation_token_for_recovery
    :parameters (?map_location - map_location ?continuation_token - continuation_token ?tool_kit - tool_kit)
    :precondition
      (and
        (progress_saved_at_location ?map_location)
        (tool_deployed ?map_location ?tool_kit)
        (continuation_token_available ?continuation_token)
        (not
          (recovery_ready_at_location ?map_location)
        )
      )
    :effect
      (and
        (recovery_ready_at_location ?map_location)
        (continuation_token_bound ?map_location ?continuation_token)
        (not
          (continuation_token_available ?continuation_token)
        )
      )
  )
  (:action restore_primary_segment_with_team
    :parameters (?primary_route_segment - primary_route_segment ?repair_team - repair_team ?continuation_token - continuation_token)
    :precondition
      (and
        (recovery_ready_at_location ?primary_route_segment)
        (team_assigned_to_location ?primary_route_segment ?repair_team)
        (continuation_token_bound ?primary_route_segment ?continuation_token)
        (not
          (route_restored_at_location ?primary_route_segment)
        )
      )
    :effect
      (and
        (route_restored_at_location ?primary_route_segment)
        (team_idle ?repair_team)
        (continuation_token_available ?continuation_token)
      )
  )
  (:action restore_alternate_segment_with_team
    :parameters (?alternate_route_segment - alternate_route_segment ?repair_team - repair_team ?continuation_token - continuation_token)
    :precondition
      (and
        (recovery_ready_at_location ?alternate_route_segment)
        (team_assigned_to_location ?alternate_route_segment ?repair_team)
        (continuation_token_bound ?alternate_route_segment ?continuation_token)
        (not
          (route_restored_at_location ?alternate_route_segment)
        )
      )
    :effect
      (and
        (route_restored_at_location ?alternate_route_segment)
        (team_idle ?repair_team)
        (continuation_token_available ?continuation_token)
      )
  )
  (:action restore_command_with_team
    :parameters (?team_command - team_command ?repair_team - repair_team ?continuation_token - continuation_token)
    :precondition
      (and
        (recovery_ready_at_location ?team_command)
        (team_assigned_to_location ?team_command ?repair_team)
        (continuation_token_bound ?team_command ?continuation_token)
        (not
          (route_restored_at_location ?team_command)
        )
      )
    :effect
      (and
        (route_restored_at_location ?team_command)
        (team_idle ?repair_team)
        (continuation_token_available ?continuation_token)
      )
  )
)

(define (domain legendary_blueprint_component_reservation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types base_object - object equipment_category - base_object resource_category - base_object slot_category - base_object design_registry - base_object reservation_subject - design_registry component_type - equipment_category binding_token - equipment_category special_tool - equipment_category special_enhancement - equipment_category stabilizer_module - equipment_category preservation_token - equipment_category calibration_gem - equipment_category quality_seal - equipment_category consumable_material - resource_category assembly_subcomponent - resource_category special_pattern - resource_category component_slot - slot_category module_slot - slot_category reserved_component - slot_category personnel_category - reservation_subject station_category - reservation_subject primary_crafter - personnel_category secondary_crafter - personnel_category crafting_station - station_category)

  (:predicates
    (reservation_prepared ?legendary_blueprint - reservation_subject)
    (binding_confirmed ?legendary_blueprint - reservation_subject)
    (reservation_component_assigned ?legendary_blueprint - reservation_subject)
    (entity_reservation_confirmed ?legendary_blueprint - reservation_subject)
    (ready_for_finalization_flag ?legendary_blueprint - reservation_subject)
    (preservation_applied ?legendary_blueprint - reservation_subject)
    (component_available ?component_type - component_type)
    (reservation_assigned_component_type ?legendary_blueprint - reservation_subject ?component_type - component_type)
    (binding_token_available ?binding_token - binding_token)
    (bound_to_token ?legendary_blueprint - reservation_subject ?binding_token - binding_token)
    (special_tool_available ?special_tool - special_tool)
    (reservation_tool_attached ?legendary_blueprint - reservation_subject ?special_tool - special_tool)
    (consumable_available ?consumable_material - consumable_material)
    (primary_material_reserved ?primary_crafter - primary_crafter ?consumable_material - consumable_material)
    (secondary_material_reserved ?secondary_crafter - secondary_crafter ?consumable_material - consumable_material)
    (primary_slot_assigned ?primary_crafter - primary_crafter ?component_slot - component_slot)
    (component_slot_tentative_reserved ?component_slot - component_slot)
    (component_slot_confirmed_reserved ?component_slot - component_slot)
    (primary_material_confirmed ?primary_crafter - primary_crafter)
    (secondary_slot_assigned ?secondary_crafter - secondary_crafter ?module_slot - module_slot)
    (module_slot_tentative_reserved ?module_slot - module_slot)
    (module_slot_confirmed_reserved ?module_slot - module_slot)
    (secondary_material_confirmed ?secondary_crafter - secondary_crafter)
    (component_candidate_available ?reserved_component - reserved_component)
    (reserved_component_created ?reserved_component - reserved_component)
    (reserved_component_slot_linked ?reserved_component - reserved_component ?component_slot - component_slot)
    (reserved_component_module_linked ?reserved_component - reserved_component ?module_slot - module_slot)
    (reserved_component_stage_1_flag ?reserved_component - reserved_component)
    (reserved_component_stage_2_flag ?reserved_component - reserved_component)
    (reserved_component_ready_for_subassembly ?reserved_component - reserved_component)
    (station_primary_link ?crafting_station - crafting_station ?primary_crafter - primary_crafter)
    (station_secondary_link ?crafting_station - crafting_station ?secondary_crafter - secondary_crafter)
    (station_reserved_component_link ?crafting_station - crafting_station ?reserved_component - reserved_component)
    (assembly_subcomponent_available ?assembly_subcomponent - assembly_subcomponent)
    (station_subcomponent_link ?crafting_station - crafting_station ?assembly_subcomponent - assembly_subcomponent)
    (assembly_subcomponent_engaged ?assembly_subcomponent - assembly_subcomponent)
    (subcomponent_attached_to_reserved_component ?assembly_subcomponent - assembly_subcomponent ?reserved_component - reserved_component)
    (station_subcomponent_active ?crafting_station - crafting_station)
    (station_subcomponent_processed ?crafting_station - crafting_station)
    (station_ready_for_finalization ?crafting_station - crafting_station)
    (station_enhancement_engaged ?crafting_station - crafting_station)
    (station_enhancement_flag ?crafting_station - crafting_station)
    (station_finalization_enabled ?crafting_station - crafting_station)
    (station_final_checks_completed ?crafting_station - crafting_station)
    (special_pattern_available ?special_pattern - special_pattern)
    (station_has_special_pattern ?crafting_station - crafting_station ?special_pattern - special_pattern)
    (station_pattern_reserved ?crafting_station - crafting_station)
    (station_pattern_applied ?crafting_station - crafting_station)
    (station_quality_seal_stage_applied ?crafting_station - crafting_station)
    (special_enhancement_available ?special_enhancement - special_enhancement)
    (station_enhancement_link ?crafting_station - crafting_station ?special_enhancement - special_enhancement)
    (stabilizer_module_available ?stabilizer_module - stabilizer_module)
    (station_stabilizer_link ?crafting_station - crafting_station ?stabilizer_module - stabilizer_module)
    (calibration_gem_available ?calibration_gem - calibration_gem)
    (station_calibration_attached ?crafting_station - crafting_station ?calibration_gem - calibration_gem)
    (quality_seal_available ?quality_seal - quality_seal)
    (station_quality_seal_attached ?crafting_station - crafting_station ?quality_seal - quality_seal)
    (preservation_token_available ?preservation_token - preservation_token)
    (reservation_preservation_link ?legendary_blueprint - reservation_subject ?preservation_token - preservation_token)
    (primary_crafter_ready ?primary_crafter - primary_crafter)
    (secondary_crafter_ready ?secondary_crafter - secondary_crafter)
    (station_deployment_complete ?crafting_station - crafting_station)
  )
  (:action prepare_reservation
    :parameters (?legendary_blueprint - reservation_subject)
    :precondition
      (and
        (not
          (reservation_prepared ?legendary_blueprint)
        )
        (not
          (entity_reservation_confirmed ?legendary_blueprint)
        )
      )
    :effect (reservation_prepared ?legendary_blueprint)
  )
  (:action assign_component_type_to_reservation
    :parameters (?legendary_blueprint - reservation_subject ?component_type - component_type)
    :precondition
      (and
        (reservation_prepared ?legendary_blueprint)
        (not
          (reservation_component_assigned ?legendary_blueprint)
        )
        (component_available ?component_type)
      )
    :effect
      (and
        (reservation_component_assigned ?legendary_blueprint)
        (reservation_assigned_component_type ?legendary_blueprint ?component_type)
        (not
          (component_available ?component_type)
        )
      )
  )
  (:action bind_token_to_reservation
    :parameters (?legendary_blueprint - reservation_subject ?binding_token - binding_token)
    :precondition
      (and
        (reservation_prepared ?legendary_blueprint)
        (reservation_component_assigned ?legendary_blueprint)
        (binding_token_available ?binding_token)
      )
    :effect
      (and
        (bound_to_token ?legendary_blueprint ?binding_token)
        (not
          (binding_token_available ?binding_token)
        )
      )
  )
  (:action confirm_reservation_binding
    :parameters (?legendary_blueprint - reservation_subject ?binding_token - binding_token)
    :precondition
      (and
        (reservation_prepared ?legendary_blueprint)
        (reservation_component_assigned ?legendary_blueprint)
        (bound_to_token ?legendary_blueprint ?binding_token)
        (not
          (binding_confirmed ?legendary_blueprint)
        )
      )
    :effect (binding_confirmed ?legendary_blueprint)
  )
  (:action release_binding_token_from_reservation
    :parameters (?legendary_blueprint - reservation_subject ?binding_token - binding_token)
    :precondition
      (and
        (bound_to_token ?legendary_blueprint ?binding_token)
      )
    :effect
      (and
        (binding_token_available ?binding_token)
        (not
          (bound_to_token ?legendary_blueprint ?binding_token)
        )
      )
  )
  (:action attach_special_tool_to_reservation
    :parameters (?legendary_blueprint - reservation_subject ?special_tool - special_tool)
    :precondition
      (and
        (binding_confirmed ?legendary_blueprint)
        (special_tool_available ?special_tool)
      )
    :effect
      (and
        (reservation_tool_attached ?legendary_blueprint ?special_tool)
        (not
          (special_tool_available ?special_tool)
        )
      )
  )
  (:action detach_special_tool_from_reservation
    :parameters (?legendary_blueprint - reservation_subject ?special_tool - special_tool)
    :precondition
      (and
        (reservation_tool_attached ?legendary_blueprint ?special_tool)
      )
    :effect
      (and
        (special_tool_available ?special_tool)
        (not
          (reservation_tool_attached ?legendary_blueprint ?special_tool)
        )
      )
  )
  (:action attach_calibration_gem_to_station
    :parameters (?crafting_station - crafting_station ?calibration_gem - calibration_gem)
    :precondition
      (and
        (binding_confirmed ?crafting_station)
        (calibration_gem_available ?calibration_gem)
      )
    :effect
      (and
        (station_calibration_attached ?crafting_station ?calibration_gem)
        (not
          (calibration_gem_available ?calibration_gem)
        )
      )
  )
  (:action detach_calibration_gem_from_station
    :parameters (?crafting_station - crafting_station ?calibration_gem - calibration_gem)
    :precondition
      (and
        (station_calibration_attached ?crafting_station ?calibration_gem)
      )
    :effect
      (and
        (calibration_gem_available ?calibration_gem)
        (not
          (station_calibration_attached ?crafting_station ?calibration_gem)
        )
      )
  )
  (:action attach_quality_seal_to_station
    :parameters (?crafting_station - crafting_station ?quality_seal - quality_seal)
    :precondition
      (and
        (binding_confirmed ?crafting_station)
        (quality_seal_available ?quality_seal)
      )
    :effect
      (and
        (station_quality_seal_attached ?crafting_station ?quality_seal)
        (not
          (quality_seal_available ?quality_seal)
        )
      )
  )
  (:action detach_quality_seal_from_station
    :parameters (?crafting_station - crafting_station ?quality_seal - quality_seal)
    :precondition
      (and
        (station_quality_seal_attached ?crafting_station ?quality_seal)
      )
    :effect
      (and
        (quality_seal_available ?quality_seal)
        (not
          (station_quality_seal_attached ?crafting_station ?quality_seal)
        )
      )
  )
  (:action primary_reserve_slot_tentative
    :parameters (?primary_crafter - primary_crafter ?component_slot - component_slot ?binding_token - binding_token)
    :precondition
      (and
        (binding_confirmed ?primary_crafter)
        (bound_to_token ?primary_crafter ?binding_token)
        (primary_slot_assigned ?primary_crafter ?component_slot)
        (not
          (component_slot_tentative_reserved ?component_slot)
        )
        (not
          (component_slot_confirmed_reserved ?component_slot)
        )
      )
    :effect (component_slot_tentative_reserved ?component_slot)
  )
  (:action primary_confirm_slot_with_tool
    :parameters (?primary_crafter - primary_crafter ?component_slot - component_slot ?special_tool - special_tool)
    :precondition
      (and
        (binding_confirmed ?primary_crafter)
        (reservation_tool_attached ?primary_crafter ?special_tool)
        (primary_slot_assigned ?primary_crafter ?component_slot)
        (component_slot_tentative_reserved ?component_slot)
        (not
          (primary_crafter_ready ?primary_crafter)
        )
      )
    :effect
      (and
        (primary_crafter_ready ?primary_crafter)
        (primary_material_confirmed ?primary_crafter)
      )
  )
  (:action primary_lock_material_to_slot
    :parameters (?primary_crafter - primary_crafter ?component_slot - component_slot ?consumable_material - consumable_material)
    :precondition
      (and
        (binding_confirmed ?primary_crafter)
        (primary_slot_assigned ?primary_crafter ?component_slot)
        (consumable_available ?consumable_material)
        (not
          (primary_crafter_ready ?primary_crafter)
        )
      )
    :effect
      (and
        (component_slot_confirmed_reserved ?component_slot)
        (primary_crafter_ready ?primary_crafter)
        (primary_material_reserved ?primary_crafter ?consumable_material)
        (not
          (consumable_available ?consumable_material)
        )
      )
  )
  (:action primary_complete_slot_reservation
    :parameters (?primary_crafter - primary_crafter ?component_slot - component_slot ?binding_token - binding_token ?consumable_material - consumable_material)
    :precondition
      (and
        (binding_confirmed ?primary_crafter)
        (bound_to_token ?primary_crafter ?binding_token)
        (primary_slot_assigned ?primary_crafter ?component_slot)
        (component_slot_confirmed_reserved ?component_slot)
        (primary_material_reserved ?primary_crafter ?consumable_material)
        (not
          (primary_material_confirmed ?primary_crafter)
        )
      )
    :effect
      (and
        (component_slot_tentative_reserved ?component_slot)
        (primary_material_confirmed ?primary_crafter)
        (consumable_available ?consumable_material)
        (not
          (primary_material_reserved ?primary_crafter ?consumable_material)
        )
      )
  )
  (:action secondary_reserve_module_slot_tentative
    :parameters (?secondary_crafter - secondary_crafter ?module_slot - module_slot ?binding_token - binding_token)
    :precondition
      (and
        (binding_confirmed ?secondary_crafter)
        (bound_to_token ?secondary_crafter ?binding_token)
        (secondary_slot_assigned ?secondary_crafter ?module_slot)
        (not
          (module_slot_tentative_reserved ?module_slot)
        )
        (not
          (module_slot_confirmed_reserved ?module_slot)
        )
      )
    :effect (module_slot_tentative_reserved ?module_slot)
  )
  (:action secondary_confirm_slot_with_tool
    :parameters (?secondary_crafter - secondary_crafter ?module_slot - module_slot ?special_tool - special_tool)
    :precondition
      (and
        (binding_confirmed ?secondary_crafter)
        (reservation_tool_attached ?secondary_crafter ?special_tool)
        (secondary_slot_assigned ?secondary_crafter ?module_slot)
        (module_slot_tentative_reserved ?module_slot)
        (not
          (secondary_crafter_ready ?secondary_crafter)
        )
      )
    :effect
      (and
        (secondary_crafter_ready ?secondary_crafter)
        (secondary_material_confirmed ?secondary_crafter)
      )
  )
  (:action secondary_lock_material_to_module
    :parameters (?secondary_crafter - secondary_crafter ?module_slot - module_slot ?consumable_material - consumable_material)
    :precondition
      (and
        (binding_confirmed ?secondary_crafter)
        (secondary_slot_assigned ?secondary_crafter ?module_slot)
        (consumable_available ?consumable_material)
        (not
          (secondary_crafter_ready ?secondary_crafter)
        )
      )
    :effect
      (and
        (module_slot_confirmed_reserved ?module_slot)
        (secondary_crafter_ready ?secondary_crafter)
        (secondary_material_reserved ?secondary_crafter ?consumable_material)
        (not
          (consumable_available ?consumable_material)
        )
      )
  )
  (:action secondary_complete_module_reservation
    :parameters (?secondary_crafter - secondary_crafter ?module_slot - module_slot ?binding_token - binding_token ?consumable_material - consumable_material)
    :precondition
      (and
        (binding_confirmed ?secondary_crafter)
        (bound_to_token ?secondary_crafter ?binding_token)
        (secondary_slot_assigned ?secondary_crafter ?module_slot)
        (module_slot_confirmed_reserved ?module_slot)
        (secondary_material_reserved ?secondary_crafter ?consumable_material)
        (not
          (secondary_material_confirmed ?secondary_crafter)
        )
      )
    :effect
      (and
        (module_slot_tentative_reserved ?module_slot)
        (secondary_material_confirmed ?secondary_crafter)
        (consumable_available ?consumable_material)
        (not
          (secondary_material_reserved ?secondary_crafter ?consumable_material)
        )
      )
  )
  (:action create_reserved_component_candidate
    :parameters (?primary_crafter - primary_crafter ?secondary_crafter - secondary_crafter ?component_slot - component_slot ?module_slot - module_slot ?reserved_component - reserved_component)
    :precondition
      (and
        (primary_crafter_ready ?primary_crafter)
        (secondary_crafter_ready ?secondary_crafter)
        (primary_slot_assigned ?primary_crafter ?component_slot)
        (secondary_slot_assigned ?secondary_crafter ?module_slot)
        (component_slot_tentative_reserved ?component_slot)
        (module_slot_tentative_reserved ?module_slot)
        (primary_material_confirmed ?primary_crafter)
        (secondary_material_confirmed ?secondary_crafter)
        (component_candidate_available ?reserved_component)
      )
    :effect
      (and
        (reserved_component_created ?reserved_component)
        (reserved_component_slot_linked ?reserved_component ?component_slot)
        (reserved_component_module_linked ?reserved_component ?module_slot)
        (not
          (component_candidate_available ?reserved_component)
        )
      )
  )
  (:action create_reserved_component_candidate_stage1
    :parameters (?primary_crafter - primary_crafter ?secondary_crafter - secondary_crafter ?component_slot - component_slot ?module_slot - module_slot ?reserved_component - reserved_component)
    :precondition
      (and
        (primary_crafter_ready ?primary_crafter)
        (secondary_crafter_ready ?secondary_crafter)
        (primary_slot_assigned ?primary_crafter ?component_slot)
        (secondary_slot_assigned ?secondary_crafter ?module_slot)
        (component_slot_confirmed_reserved ?component_slot)
        (module_slot_tentative_reserved ?module_slot)
        (not
          (primary_material_confirmed ?primary_crafter)
        )
        (secondary_material_confirmed ?secondary_crafter)
        (component_candidate_available ?reserved_component)
      )
    :effect
      (and
        (reserved_component_created ?reserved_component)
        (reserved_component_slot_linked ?reserved_component ?component_slot)
        (reserved_component_module_linked ?reserved_component ?module_slot)
        (reserved_component_stage_1_flag ?reserved_component)
        (not
          (component_candidate_available ?reserved_component)
        )
      )
  )
  (:action create_reserved_component_candidate_stage2
    :parameters (?primary_crafter - primary_crafter ?secondary_crafter - secondary_crafter ?component_slot - component_slot ?module_slot - module_slot ?reserved_component - reserved_component)
    :precondition
      (and
        (primary_crafter_ready ?primary_crafter)
        (secondary_crafter_ready ?secondary_crafter)
        (primary_slot_assigned ?primary_crafter ?component_slot)
        (secondary_slot_assigned ?secondary_crafter ?module_slot)
        (component_slot_tentative_reserved ?component_slot)
        (module_slot_confirmed_reserved ?module_slot)
        (primary_material_confirmed ?primary_crafter)
        (not
          (secondary_material_confirmed ?secondary_crafter)
        )
        (component_candidate_available ?reserved_component)
      )
    :effect
      (and
        (reserved_component_created ?reserved_component)
        (reserved_component_slot_linked ?reserved_component ?component_slot)
        (reserved_component_module_linked ?reserved_component ?module_slot)
        (reserved_component_stage_2_flag ?reserved_component)
        (not
          (component_candidate_available ?reserved_component)
        )
      )
  )
  (:action create_reserved_component_candidate_full
    :parameters (?primary_crafter - primary_crafter ?secondary_crafter - secondary_crafter ?component_slot - component_slot ?module_slot - module_slot ?reserved_component - reserved_component)
    :precondition
      (and
        (primary_crafter_ready ?primary_crafter)
        (secondary_crafter_ready ?secondary_crafter)
        (primary_slot_assigned ?primary_crafter ?component_slot)
        (secondary_slot_assigned ?secondary_crafter ?module_slot)
        (component_slot_confirmed_reserved ?component_slot)
        (module_slot_confirmed_reserved ?module_slot)
        (not
          (primary_material_confirmed ?primary_crafter)
        )
        (not
          (secondary_material_confirmed ?secondary_crafter)
        )
        (component_candidate_available ?reserved_component)
      )
    :effect
      (and
        (reserved_component_created ?reserved_component)
        (reserved_component_slot_linked ?reserved_component ?component_slot)
        (reserved_component_module_linked ?reserved_component ?module_slot)
        (reserved_component_stage_1_flag ?reserved_component)
        (reserved_component_stage_2_flag ?reserved_component)
        (not
          (component_candidate_available ?reserved_component)
        )
      )
  )
  (:action mark_component_ready_for_subassembly
    :parameters (?reserved_component - reserved_component ?primary_crafter - primary_crafter ?binding_token - binding_token)
    :precondition
      (and
        (reserved_component_created ?reserved_component)
        (primary_crafter_ready ?primary_crafter)
        (bound_to_token ?primary_crafter ?binding_token)
        (not
          (reserved_component_ready_for_subassembly ?reserved_component)
        )
      )
    :effect (reserved_component_ready_for_subassembly ?reserved_component)
  )
  (:action bind_subcomponent_to_reserved_component
    :parameters (?crafting_station - crafting_station ?assembly_subcomponent - assembly_subcomponent ?reserved_component - reserved_component)
    :precondition
      (and
        (binding_confirmed ?crafting_station)
        (station_reserved_component_link ?crafting_station ?reserved_component)
        (station_subcomponent_link ?crafting_station ?assembly_subcomponent)
        (assembly_subcomponent_available ?assembly_subcomponent)
        (reserved_component_created ?reserved_component)
        (reserved_component_ready_for_subassembly ?reserved_component)
        (not
          (assembly_subcomponent_engaged ?assembly_subcomponent)
        )
      )
    :effect
      (and
        (assembly_subcomponent_engaged ?assembly_subcomponent)
        (subcomponent_attached_to_reserved_component ?assembly_subcomponent ?reserved_component)
        (not
          (assembly_subcomponent_available ?assembly_subcomponent)
        )
      )
  )
  (:action process_subcomponent_on_station
    :parameters (?crafting_station - crafting_station ?assembly_subcomponent - assembly_subcomponent ?reserved_component - reserved_component ?binding_token - binding_token)
    :precondition
      (and
        (binding_confirmed ?crafting_station)
        (station_subcomponent_link ?crafting_station ?assembly_subcomponent)
        (assembly_subcomponent_engaged ?assembly_subcomponent)
        (subcomponent_attached_to_reserved_component ?assembly_subcomponent ?reserved_component)
        (bound_to_token ?crafting_station ?binding_token)
        (not
          (reserved_component_stage_1_flag ?reserved_component)
        )
        (not
          (station_subcomponent_active ?crafting_station)
        )
      )
    :effect (station_subcomponent_active ?crafting_station)
  )
  (:action attach_special_enhancement_to_station
    :parameters (?crafting_station - crafting_station ?special_enhancement - special_enhancement)
    :precondition
      (and
        (binding_confirmed ?crafting_station)
        (special_enhancement_available ?special_enhancement)
        (not
          (station_enhancement_engaged ?crafting_station)
        )
      )
    :effect
      (and
        (station_enhancement_engaged ?crafting_station)
        (station_enhancement_link ?crafting_station ?special_enhancement)
        (not
          (special_enhancement_available ?special_enhancement)
        )
      )
  )
  (:action process_subcomponent_with_enhancement
    :parameters (?crafting_station - crafting_station ?assembly_subcomponent - assembly_subcomponent ?reserved_component - reserved_component ?binding_token - binding_token ?special_enhancement - special_enhancement)
    :precondition
      (and
        (binding_confirmed ?crafting_station)
        (station_subcomponent_link ?crafting_station ?assembly_subcomponent)
        (assembly_subcomponent_engaged ?assembly_subcomponent)
        (subcomponent_attached_to_reserved_component ?assembly_subcomponent ?reserved_component)
        (bound_to_token ?crafting_station ?binding_token)
        (reserved_component_stage_1_flag ?reserved_component)
        (station_enhancement_engaged ?crafting_station)
        (station_enhancement_link ?crafting_station ?special_enhancement)
        (not
          (station_subcomponent_active ?crafting_station)
        )
      )
    :effect
      (and
        (station_subcomponent_active ?crafting_station)
        (station_enhancement_flag ?crafting_station)
      )
  )
  (:action apply_calibration_and_tool_on_station
    :parameters (?crafting_station - crafting_station ?calibration_gem - calibration_gem ?special_tool - special_tool ?assembly_subcomponent - assembly_subcomponent ?reserved_component - reserved_component)
    :precondition
      (and
        (station_subcomponent_active ?crafting_station)
        (station_calibration_attached ?crafting_station ?calibration_gem)
        (reservation_tool_attached ?crafting_station ?special_tool)
        (station_subcomponent_link ?crafting_station ?assembly_subcomponent)
        (subcomponent_attached_to_reserved_component ?assembly_subcomponent ?reserved_component)
        (not
          (reserved_component_stage_2_flag ?reserved_component)
        )
        (not
          (station_subcomponent_processed ?crafting_station)
        )
      )
    :effect (station_subcomponent_processed ?crafting_station)
  )
  (:action complete_calibration_stage_on_station
    :parameters (?crafting_station - crafting_station ?calibration_gem - calibration_gem ?special_tool - special_tool ?assembly_subcomponent - assembly_subcomponent ?reserved_component - reserved_component)
    :precondition
      (and
        (station_subcomponent_active ?crafting_station)
        (station_calibration_attached ?crafting_station ?calibration_gem)
        (reservation_tool_attached ?crafting_station ?special_tool)
        (station_subcomponent_link ?crafting_station ?assembly_subcomponent)
        (subcomponent_attached_to_reserved_component ?assembly_subcomponent ?reserved_component)
        (reserved_component_stage_2_flag ?reserved_component)
        (not
          (station_subcomponent_processed ?crafting_station)
        )
      )
    :effect (station_subcomponent_processed ?crafting_station)
  )
  (:action apply_quality_seal_stage_one
    :parameters (?crafting_station - crafting_station ?quality_seal - quality_seal ?assembly_subcomponent - assembly_subcomponent ?reserved_component - reserved_component)
    :precondition
      (and
        (station_subcomponent_processed ?crafting_station)
        (station_quality_seal_attached ?crafting_station ?quality_seal)
        (station_subcomponent_link ?crafting_station ?assembly_subcomponent)
        (subcomponent_attached_to_reserved_component ?assembly_subcomponent ?reserved_component)
        (not
          (reserved_component_stage_1_flag ?reserved_component)
        )
        (not
          (reserved_component_stage_2_flag ?reserved_component)
        )
        (not
          (station_ready_for_finalization ?crafting_station)
        )
      )
    :effect (station_ready_for_finalization ?crafting_station)
  )
  (:action apply_quality_seal_and_enable_finalization
    :parameters (?crafting_station - crafting_station ?quality_seal - quality_seal ?assembly_subcomponent - assembly_subcomponent ?reserved_component - reserved_component)
    :precondition
      (and
        (station_subcomponent_processed ?crafting_station)
        (station_quality_seal_attached ?crafting_station ?quality_seal)
        (station_subcomponent_link ?crafting_station ?assembly_subcomponent)
        (subcomponent_attached_to_reserved_component ?assembly_subcomponent ?reserved_component)
        (reserved_component_stage_1_flag ?reserved_component)
        (not
          (reserved_component_stage_2_flag ?reserved_component)
        )
        (not
          (station_ready_for_finalization ?crafting_station)
        )
      )
    :effect
      (and
        (station_ready_for_finalization ?crafting_station)
        (station_finalization_enabled ?crafting_station)
      )
  )
  (:action apply_quality_seal_and_flag_finalization
    :parameters (?crafting_station - crafting_station ?quality_seal - quality_seal ?assembly_subcomponent - assembly_subcomponent ?reserved_component - reserved_component)
    :precondition
      (and
        (station_subcomponent_processed ?crafting_station)
        (station_quality_seal_attached ?crafting_station ?quality_seal)
        (station_subcomponent_link ?crafting_station ?assembly_subcomponent)
        (subcomponent_attached_to_reserved_component ?assembly_subcomponent ?reserved_component)
        (not
          (reserved_component_stage_1_flag ?reserved_component)
        )
        (reserved_component_stage_2_flag ?reserved_component)
        (not
          (station_ready_for_finalization ?crafting_station)
        )
      )
    :effect
      (and
        (station_ready_for_finalization ?crafting_station)
        (station_finalization_enabled ?crafting_station)
      )
  )
  (:action apply_quality_seal_complete
    :parameters (?crafting_station - crafting_station ?quality_seal - quality_seal ?assembly_subcomponent - assembly_subcomponent ?reserved_component - reserved_component)
    :precondition
      (and
        (station_subcomponent_processed ?crafting_station)
        (station_quality_seal_attached ?crafting_station ?quality_seal)
        (station_subcomponent_link ?crafting_station ?assembly_subcomponent)
        (subcomponent_attached_to_reserved_component ?assembly_subcomponent ?reserved_component)
        (reserved_component_stage_1_flag ?reserved_component)
        (reserved_component_stage_2_flag ?reserved_component)
        (not
          (station_ready_for_finalization ?crafting_station)
        )
      )
    :effect
      (and
        (station_ready_for_finalization ?crafting_station)
        (station_finalization_enabled ?crafting_station)
      )
  )
  (:action finalize_reserved_component_on_station
    :parameters (?crafting_station - crafting_station)
    :precondition
      (and
        (station_ready_for_finalization ?crafting_station)
        (not
          (station_finalization_enabled ?crafting_station)
        )
        (not
          (station_deployment_complete ?crafting_station)
        )
      )
    :effect
      (and
        (station_deployment_complete ?crafting_station)
        (ready_for_finalization_flag ?crafting_station)
      )
  )
  (:action attach_stabilizer_module_to_station
    :parameters (?crafting_station - crafting_station ?stabilizer_module - stabilizer_module)
    :precondition
      (and
        (station_ready_for_finalization ?crafting_station)
        (station_finalization_enabled ?crafting_station)
        (stabilizer_module_available ?stabilizer_module)
      )
    :effect
      (and
        (station_stabilizer_link ?crafting_station ?stabilizer_module)
        (not
          (stabilizer_module_available ?stabilizer_module)
        )
      )
  )
  (:action perform_final_assembly_checks_on_station
    :parameters (?crafting_station - crafting_station ?primary_crafter - primary_crafter ?secondary_crafter - secondary_crafter ?binding_token - binding_token ?stabilizer_module - stabilizer_module)
    :precondition
      (and
        (station_ready_for_finalization ?crafting_station)
        (station_finalization_enabled ?crafting_station)
        (station_stabilizer_link ?crafting_station ?stabilizer_module)
        (station_primary_link ?crafting_station ?primary_crafter)
        (station_secondary_link ?crafting_station ?secondary_crafter)
        (primary_material_confirmed ?primary_crafter)
        (secondary_material_confirmed ?secondary_crafter)
        (bound_to_token ?crafting_station ?binding_token)
        (not
          (station_final_checks_completed ?crafting_station)
        )
      )
    :effect (station_final_checks_completed ?crafting_station)
  )
  (:action finalize_and_deploy_component
    :parameters (?crafting_station - crafting_station)
    :precondition
      (and
        (station_ready_for_finalization ?crafting_station)
        (station_final_checks_completed ?crafting_station)
        (not
          (station_deployment_complete ?crafting_station)
        )
      )
    :effect
      (and
        (station_deployment_complete ?crafting_station)
        (ready_for_finalization_flag ?crafting_station)
      )
  )
  (:action reserve_special_pattern_on_station
    :parameters (?crafting_station - crafting_station ?special_pattern - special_pattern ?binding_token - binding_token)
    :precondition
      (and
        (binding_confirmed ?crafting_station)
        (bound_to_token ?crafting_station ?binding_token)
        (special_pattern_available ?special_pattern)
        (station_has_special_pattern ?crafting_station ?special_pattern)
        (not
          (station_pattern_reserved ?crafting_station)
        )
      )
    :effect
      (and
        (station_pattern_reserved ?crafting_station)
        (not
          (special_pattern_available ?special_pattern)
        )
      )
  )
  (:action apply_tool_for_pattern
    :parameters (?crafting_station - crafting_station ?special_tool - special_tool)
    :precondition
      (and
        (station_pattern_reserved ?crafting_station)
        (reservation_tool_attached ?crafting_station ?special_tool)
        (not
          (station_pattern_applied ?crafting_station)
        )
      )
    :effect (station_pattern_applied ?crafting_station)
  )
  (:action apply_quality_seal_post_pattern
    :parameters (?crafting_station - crafting_station ?quality_seal - quality_seal)
    :precondition
      (and
        (station_pattern_applied ?crafting_station)
        (station_quality_seal_attached ?crafting_station ?quality_seal)
        (not
          (station_quality_seal_stage_applied ?crafting_station)
        )
      )
    :effect (station_quality_seal_stage_applied ?crafting_station)
  )
  (:action finalize_after_pattern
    :parameters (?crafting_station - crafting_station)
    :precondition
      (and
        (station_quality_seal_stage_applied ?crafting_station)
        (not
          (station_deployment_complete ?crafting_station)
        )
      )
    :effect
      (and
        (station_deployment_complete ?crafting_station)
        (ready_for_finalization_flag ?crafting_station)
      )
  )
  (:action primary_mark_ready_for_finalization
    :parameters (?primary_crafter - primary_crafter ?reserved_component - reserved_component)
    :precondition
      (and
        (primary_crafter_ready ?primary_crafter)
        (primary_material_confirmed ?primary_crafter)
        (reserved_component_created ?reserved_component)
        (reserved_component_ready_for_subassembly ?reserved_component)
        (not
          (ready_for_finalization_flag ?primary_crafter)
        )
      )
    :effect (ready_for_finalization_flag ?primary_crafter)
  )
  (:action secondary_mark_ready_for_finalization
    :parameters (?secondary_crafter - secondary_crafter ?reserved_component - reserved_component)
    :precondition
      (and
        (secondary_crafter_ready ?secondary_crafter)
        (secondary_material_confirmed ?secondary_crafter)
        (reserved_component_created ?reserved_component)
        (reserved_component_ready_for_subassembly ?reserved_component)
        (not
          (ready_for_finalization_flag ?secondary_crafter)
        )
      )
    :effect (ready_for_finalization_flag ?secondary_crafter)
  )
  (:action apply_preservation_token_to_reservation
    :parameters (?legendary_blueprint - reservation_subject ?preservation_token - preservation_token ?binding_token - binding_token)
    :precondition
      (and
        (ready_for_finalization_flag ?legendary_blueprint)
        (bound_to_token ?legendary_blueprint ?binding_token)
        (preservation_token_available ?preservation_token)
        (not
          (preservation_applied ?legendary_blueprint)
        )
      )
    :effect
      (and
        (preservation_applied ?legendary_blueprint)
        (reservation_preservation_link ?legendary_blueprint ?preservation_token)
        (not
          (preservation_token_available ?preservation_token)
        )
      )
  )
  (:action confirm_reservation_on_primary_with_preservation
    :parameters (?primary_crafter - primary_crafter ?component_type - component_type ?preservation_token - preservation_token)
    :precondition
      (and
        (preservation_applied ?primary_crafter)
        (reservation_assigned_component_type ?primary_crafter ?component_type)
        (reservation_preservation_link ?primary_crafter ?preservation_token)
        (not
          (entity_reservation_confirmed ?primary_crafter)
        )
      )
    :effect
      (and
        (entity_reservation_confirmed ?primary_crafter)
        (component_available ?component_type)
        (preservation_token_available ?preservation_token)
      )
  )
  (:action confirm_reservation_on_secondary_with_preservation
    :parameters (?secondary_crafter - secondary_crafter ?component_type - component_type ?preservation_token - preservation_token)
    :precondition
      (and
        (preservation_applied ?secondary_crafter)
        (reservation_assigned_component_type ?secondary_crafter ?component_type)
        (reservation_preservation_link ?secondary_crafter ?preservation_token)
        (not
          (entity_reservation_confirmed ?secondary_crafter)
        )
      )
    :effect
      (and
        (entity_reservation_confirmed ?secondary_crafter)
        (component_available ?component_type)
        (preservation_token_available ?preservation_token)
      )
  )
  (:action confirm_reservation_on_station_with_preservation
    :parameters (?crafting_station - crafting_station ?component_type - component_type ?preservation_token - preservation_token)
    :precondition
      (and
        (preservation_applied ?crafting_station)
        (reservation_assigned_component_type ?crafting_station ?component_type)
        (reservation_preservation_link ?crafting_station ?preservation_token)
        (not
          (entity_reservation_confirmed ?crafting_station)
        )
      )
    :effect
      (and
        (entity_reservation_confirmed ?crafting_station)
        (component_available ?component_type)
        (preservation_token_available ?preservation_token)
      )
  )
)

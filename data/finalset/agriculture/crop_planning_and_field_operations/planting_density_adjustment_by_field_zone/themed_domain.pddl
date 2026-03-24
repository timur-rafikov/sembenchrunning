(define (domain planting_density_adjustment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object asset_class - object temporal_class - object farm_unit - object land_unit - farm_unit seed_equipment - resource_category crop_variety - resource_category operator - resource_category equipment_calibration - resource_category fertilizer_plan - resource_category season_slot - resource_category irrigation_plan - resource_category yield_target - resource_category seed_batch - asset_class seeding_rate_profile - asset_class field_history_record - asset_class soil_condition - temporal_class operation_window - temporal_class planting_job - temporal_class field_zone_class - land_unit prescription_class - land_unit field_zone - field_zone_class field_strip - field_zone_class planting_prescription - prescription_class)
  (:predicates
    (planting_unit_registered ?land_unit - land_unit)
    (planting_unit_ready_for_prescription ?land_unit - land_unit)
    (planting_unit_equipment_assigned ?land_unit - land_unit)
    (released_for_planting ?land_unit - land_unit)
    (finalized_for_execution ?land_unit - land_unit)
    (signoff_recorded ?land_unit - land_unit)
    (seed_equipment_available ?seed_equipment - seed_equipment)
    (planting_unit_equipment_binding ?land_unit - land_unit ?seed_equipment - seed_equipment)
    (crop_variety_available ?crop_variety_var - crop_variety)
    (planting_unit_assigned_variety ?land_unit - land_unit ?crop_variety_var - crop_variety)
    (operator_available ?operator - operator)
    (planting_unit_operator_assigned ?land_unit - land_unit ?operator - operator)
    (seed_batch_available ?seed_batch - seed_batch)
    (field_zone_seed_batch_binding ?field_zone_var - field_zone ?seed_batch - seed_batch)
    (field_strip_seed_batch_binding ?field_strip_var - field_strip ?seed_batch - seed_batch)
    (field_zone_soil_condition_binding ?field_zone_var - field_zone ?soil_condition - soil_condition)
    (soil_condition_flagged ?soil_condition - soil_condition)
    (soil_condition_allocated ?soil_condition - soil_condition)
    (field_zone_flagged ?field_zone_var - field_zone)
    (field_strip_operation_window_binding ?field_strip_var - field_strip ?operation_window - operation_window)
    (operation_window_flagged ?operation_window - operation_window)
    (operation_window_allocated ?operation_window - operation_window)
    (field_strip_flagged ?field_strip_var - field_strip)
    (planting_job_slot_available ?planting_job - planting_job)
    (planting_job_created ?planting_job - planting_job)
    (planting_job_soil_condition_binding ?planting_job - planting_job ?soil_condition - soil_condition)
    (planting_job_operation_window_binding ?planting_job - planting_job ?operation_window - operation_window)
    (planting_job_requires_irrigation ?planting_job - planting_job)
    (planting_job_requires_fertilizer ?planting_job - planting_job)
    (planting_job_profile_ready ?planting_job - planting_job)
    (prescription_field_zone_binding ?planting_prescription - planting_prescription ?field_zone_var - field_zone)
    (prescription_field_strip_binding ?planting_prescription - planting_prescription ?field_strip_var - field_strip)
    (prescription_assigned_to_job ?planting_prescription - planting_prescription ?planting_job - planting_job)
    (seeding_rate_profile_available ?seeding_rate_profile - seeding_rate_profile)
    (prescription_has_seeding_rate_profile ?planting_prescription - planting_prescription ?seeding_rate_profile - seeding_rate_profile)
    (seeding_rate_profile_allocated ?seeding_rate_profile - seeding_rate_profile)
    (seeding_rate_profile_assigned_to_job ?seeding_rate_profile - seeding_rate_profile ?planting_job - planting_job)
    (prescription_calibrated ?planting_prescription - planting_prescription)
    (prescription_materials_validated ?planting_prescription - planting_prescription)
    (prescription_ready_for_finalization ?planting_prescription - planting_prescription)
    (calibration_attached ?planting_prescription - planting_prescription)
    (calibration_verified ?planting_prescription - planting_prescription)
    (prescription_fertilizer_required ?planting_prescription - planting_prescription)
    (prescription_materials_and_calibration_bound ?planting_prescription - planting_prescription)
    (field_history_available ?field_history_record - field_history_record)
    (prescription_field_history_binding ?planting_prescription - planting_prescription ?field_history_record - field_history_record)
    (field_history_attached ?planting_prescription - planting_prescription)
    (prescription_history_validated ?planting_prescription - planting_prescription)
    (prescription_yield_target_validated ?planting_prescription - planting_prescription)
    (equipment_calibration_available ?equipment_calibration - equipment_calibration)
    (prescription_calibration_binding ?planting_prescription - planting_prescription ?equipment_calibration - equipment_calibration)
    (fertilizer_plan_available ?fertilizer_plan_var - fertilizer_plan)
    (prescription_fertilizer_binding ?planting_prescription - planting_prescription ?fertilizer_plan_var - fertilizer_plan)
    (irrigation_plan_available ?irrigation_plan - irrigation_plan)
    (prescription_irrigation_binding ?planting_prescription - planting_prescription ?irrigation_plan - irrigation_plan)
    (yield_target_available ?yield_target - yield_target)
    (prescription_yield_target_binding ?planting_prescription - planting_prescription ?yield_target - yield_target)
    (season_slot_available ?season_slot - season_slot)
    (planting_unit_season_slot_binding ?land_unit - land_unit ?season_slot - season_slot)
    (field_zone_ready ?field_zone_var - field_zone)
    (field_strip_ready ?field_strip_var - field_strip)
    (prescription_approved ?planting_prescription - planting_prescription)
  )
  (:action register_land_unit
    :parameters (?land_unit - land_unit)
    :precondition
      (and
        (not
          (planting_unit_registered ?land_unit)
        )
        (not
          (released_for_planting ?land_unit)
        )
      )
    :effect (planting_unit_registered ?land_unit)
  )
  (:action assign_seed_equipment_to_land_unit
    :parameters (?land_unit - land_unit ?seed_equipment - seed_equipment)
    :precondition
      (and
        (planting_unit_registered ?land_unit)
        (not
          (planting_unit_equipment_assigned ?land_unit)
        )
        (seed_equipment_available ?seed_equipment)
      )
    :effect
      (and
        (planting_unit_equipment_assigned ?land_unit)
        (planting_unit_equipment_binding ?land_unit ?seed_equipment)
        (not
          (seed_equipment_available ?seed_equipment)
        )
      )
  )
  (:action assign_crop_variety_to_land_unit
    :parameters (?land_unit - land_unit ?crop_variety_var - crop_variety)
    :precondition
      (and
        (planting_unit_registered ?land_unit)
        (planting_unit_equipment_assigned ?land_unit)
        (crop_variety_available ?crop_variety_var)
      )
    :effect
      (and
        (planting_unit_assigned_variety ?land_unit ?crop_variety_var)
        (not
          (crop_variety_available ?crop_variety_var)
        )
      )
  )
  (:action mark_land_unit_ready_for_prescription
    :parameters (?land_unit - land_unit ?crop_variety_var - crop_variety)
    :precondition
      (and
        (planting_unit_registered ?land_unit)
        (planting_unit_equipment_assigned ?land_unit)
        (planting_unit_assigned_variety ?land_unit ?crop_variety_var)
        (not
          (planting_unit_ready_for_prescription ?land_unit)
        )
      )
    :effect (planting_unit_ready_for_prescription ?land_unit)
  )
  (:action unassign_crop_variety_from_land_unit
    :parameters (?land_unit - land_unit ?crop_variety_var - crop_variety)
    :precondition
      (and
        (planting_unit_assigned_variety ?land_unit ?crop_variety_var)
      )
    :effect
      (and
        (crop_variety_available ?crop_variety_var)
        (not
          (planting_unit_assigned_variety ?land_unit ?crop_variety_var)
        )
      )
  )
  (:action assign_operator_to_land_unit
    :parameters (?land_unit - land_unit ?operator - operator)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?land_unit)
        (operator_available ?operator)
      )
    :effect
      (and
        (planting_unit_operator_assigned ?land_unit ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action release_operator_from_land_unit
    :parameters (?land_unit - land_unit ?operator - operator)
    :precondition
      (and
        (planting_unit_operator_assigned ?land_unit ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (planting_unit_operator_assigned ?land_unit ?operator)
        )
      )
  )
  (:action allocate_irrigation_plan_to_prescription
    :parameters (?planting_prescription - planting_prescription ?irrigation_plan - irrigation_plan)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?planting_prescription)
        (irrigation_plan_available ?irrigation_plan)
      )
    :effect
      (and
        (prescription_irrigation_binding ?planting_prescription ?irrigation_plan)
        (not
          (irrigation_plan_available ?irrigation_plan)
        )
      )
  )
  (:action release_irrigation_plan_from_prescription
    :parameters (?planting_prescription - planting_prescription ?irrigation_plan - irrigation_plan)
    :precondition
      (and
        (prescription_irrigation_binding ?planting_prescription ?irrigation_plan)
      )
    :effect
      (and
        (irrigation_plan_available ?irrigation_plan)
        (not
          (prescription_irrigation_binding ?planting_prescription ?irrigation_plan)
        )
      )
  )
  (:action allocate_yield_target_to_prescription
    :parameters (?planting_prescription - planting_prescription ?yield_target - yield_target)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?planting_prescription)
        (yield_target_available ?yield_target)
      )
    :effect
      (and
        (prescription_yield_target_binding ?planting_prescription ?yield_target)
        (not
          (yield_target_available ?yield_target)
        )
      )
  )
  (:action release_yield_target_from_prescription
    :parameters (?planting_prescription - planting_prescription ?yield_target - yield_target)
    :precondition
      (and
        (prescription_yield_target_binding ?planting_prescription ?yield_target)
      )
    :effect
      (and
        (yield_target_available ?yield_target)
        (not
          (prescription_yield_target_binding ?planting_prescription ?yield_target)
        )
      )
  )
  (:action evaluate_and_flag_soil_condition
    :parameters (?field_zone_var - field_zone ?soil_condition - soil_condition ?crop_variety_var - crop_variety)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?field_zone_var)
        (planting_unit_assigned_variety ?field_zone_var ?crop_variety_var)
        (field_zone_soil_condition_binding ?field_zone_var ?soil_condition)
        (not
          (soil_condition_flagged ?soil_condition)
        )
        (not
          (soil_condition_allocated ?soil_condition)
        )
      )
    :effect (soil_condition_flagged ?soil_condition)
  )
  (:action flag_zone_for_operation
    :parameters (?field_zone_var - field_zone ?soil_condition - soil_condition ?operator - operator)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?field_zone_var)
        (planting_unit_operator_assigned ?field_zone_var ?operator)
        (field_zone_soil_condition_binding ?field_zone_var ?soil_condition)
        (soil_condition_flagged ?soil_condition)
        (not
          (field_zone_ready ?field_zone_var)
        )
      )
    :effect
      (and
        (field_zone_ready ?field_zone_var)
        (field_zone_flagged ?field_zone_var)
      )
  )
  (:action allocate_seed_batch_to_zone
    :parameters (?field_zone_var - field_zone ?soil_condition - soil_condition ?seed_batch - seed_batch)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?field_zone_var)
        (field_zone_soil_condition_binding ?field_zone_var ?soil_condition)
        (seed_batch_available ?seed_batch)
        (not
          (field_zone_ready ?field_zone_var)
        )
      )
    :effect
      (and
        (soil_condition_allocated ?soil_condition)
        (field_zone_ready ?field_zone_var)
        (field_zone_seed_batch_binding ?field_zone_var ?seed_batch)
        (not
          (seed_batch_available ?seed_batch)
        )
      )
  )
  (:action apply_seed_batch_to_zone
    :parameters (?field_zone_var - field_zone ?soil_condition - soil_condition ?crop_variety_var - crop_variety ?seed_batch - seed_batch)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?field_zone_var)
        (planting_unit_assigned_variety ?field_zone_var ?crop_variety_var)
        (field_zone_soil_condition_binding ?field_zone_var ?soil_condition)
        (soil_condition_allocated ?soil_condition)
        (field_zone_seed_batch_binding ?field_zone_var ?seed_batch)
        (not
          (field_zone_flagged ?field_zone_var)
        )
      )
    :effect
      (and
        (soil_condition_flagged ?soil_condition)
        (field_zone_flagged ?field_zone_var)
        (seed_batch_available ?seed_batch)
        (not
          (field_zone_seed_batch_binding ?field_zone_var ?seed_batch)
        )
      )
  )
  (:action evaluate_operation_window_for_strip
    :parameters (?field_strip_var - field_strip ?operation_window - operation_window ?crop_variety_var - crop_variety)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?field_strip_var)
        (planting_unit_assigned_variety ?field_strip_var ?crop_variety_var)
        (field_strip_operation_window_binding ?field_strip_var ?operation_window)
        (not
          (operation_window_flagged ?operation_window)
        )
        (not
          (operation_window_allocated ?operation_window)
        )
      )
    :effect (operation_window_flagged ?operation_window)
  )
  (:action flag_strip_for_operation
    :parameters (?field_strip_var - field_strip ?operation_window - operation_window ?operator - operator)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?field_strip_var)
        (planting_unit_operator_assigned ?field_strip_var ?operator)
        (field_strip_operation_window_binding ?field_strip_var ?operation_window)
        (operation_window_flagged ?operation_window)
        (not
          (field_strip_ready ?field_strip_var)
        )
      )
    :effect
      (and
        (field_strip_ready ?field_strip_var)
        (field_strip_flagged ?field_strip_var)
      )
  )
  (:action allocate_seed_batch_to_strip
    :parameters (?field_strip_var - field_strip ?operation_window - operation_window ?seed_batch - seed_batch)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?field_strip_var)
        (field_strip_operation_window_binding ?field_strip_var ?operation_window)
        (seed_batch_available ?seed_batch)
        (not
          (field_strip_ready ?field_strip_var)
        )
      )
    :effect
      (and
        (operation_window_allocated ?operation_window)
        (field_strip_ready ?field_strip_var)
        (field_strip_seed_batch_binding ?field_strip_var ?seed_batch)
        (not
          (seed_batch_available ?seed_batch)
        )
      )
  )
  (:action apply_seed_batch_to_strip
    :parameters (?field_strip_var - field_strip ?operation_window - operation_window ?crop_variety_var - crop_variety ?seed_batch - seed_batch)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?field_strip_var)
        (planting_unit_assigned_variety ?field_strip_var ?crop_variety_var)
        (field_strip_operation_window_binding ?field_strip_var ?operation_window)
        (operation_window_allocated ?operation_window)
        (field_strip_seed_batch_binding ?field_strip_var ?seed_batch)
        (not
          (field_strip_flagged ?field_strip_var)
        )
      )
    :effect
      (and
        (operation_window_flagged ?operation_window)
        (field_strip_flagged ?field_strip_var)
        (seed_batch_available ?seed_batch)
        (not
          (field_strip_seed_batch_binding ?field_strip_var ?seed_batch)
        )
      )
  )
  (:action compose_planting_job_standard
    :parameters (?field_zone_var - field_zone ?field_strip_var - field_strip ?soil_condition - soil_condition ?operation_window - operation_window ?planting_job - planting_job)
    :precondition
      (and
        (field_zone_ready ?field_zone_var)
        (field_strip_ready ?field_strip_var)
        (field_zone_soil_condition_binding ?field_zone_var ?soil_condition)
        (field_strip_operation_window_binding ?field_strip_var ?operation_window)
        (soil_condition_flagged ?soil_condition)
        (operation_window_flagged ?operation_window)
        (field_zone_flagged ?field_zone_var)
        (field_strip_flagged ?field_strip_var)
        (planting_job_slot_available ?planting_job)
      )
    :effect
      (and
        (planting_job_created ?planting_job)
        (planting_job_soil_condition_binding ?planting_job ?soil_condition)
        (planting_job_operation_window_binding ?planting_job ?operation_window)
        (not
          (planting_job_slot_available ?planting_job)
        )
      )
  )
  (:action compose_planting_job_irrigation_required
    :parameters (?field_zone_var - field_zone ?field_strip_var - field_strip ?soil_condition - soil_condition ?operation_window - operation_window ?planting_job - planting_job)
    :precondition
      (and
        (field_zone_ready ?field_zone_var)
        (field_strip_ready ?field_strip_var)
        (field_zone_soil_condition_binding ?field_zone_var ?soil_condition)
        (field_strip_operation_window_binding ?field_strip_var ?operation_window)
        (soil_condition_allocated ?soil_condition)
        (operation_window_flagged ?operation_window)
        (not
          (field_zone_flagged ?field_zone_var)
        )
        (field_strip_flagged ?field_strip_var)
        (planting_job_slot_available ?planting_job)
      )
    :effect
      (and
        (planting_job_created ?planting_job)
        (planting_job_soil_condition_binding ?planting_job ?soil_condition)
        (planting_job_operation_window_binding ?planting_job ?operation_window)
        (planting_job_requires_irrigation ?planting_job)
        (not
          (planting_job_slot_available ?planting_job)
        )
      )
  )
  (:action compose_planting_job_fertilizer_required
    :parameters (?field_zone_var - field_zone ?field_strip_var - field_strip ?soil_condition - soil_condition ?operation_window - operation_window ?planting_job - planting_job)
    :precondition
      (and
        (field_zone_ready ?field_zone_var)
        (field_strip_ready ?field_strip_var)
        (field_zone_soil_condition_binding ?field_zone_var ?soil_condition)
        (field_strip_operation_window_binding ?field_strip_var ?operation_window)
        (soil_condition_flagged ?soil_condition)
        (operation_window_allocated ?operation_window)
        (field_zone_flagged ?field_zone_var)
        (not
          (field_strip_flagged ?field_strip_var)
        )
        (planting_job_slot_available ?planting_job)
      )
    :effect
      (and
        (planting_job_created ?planting_job)
        (planting_job_soil_condition_binding ?planting_job ?soil_condition)
        (planting_job_operation_window_binding ?planting_job ?operation_window)
        (planting_job_requires_fertilizer ?planting_job)
        (not
          (planting_job_slot_available ?planting_job)
        )
      )
  )
  (:action compose_planting_job_with_irrigation_and_fertilizer
    :parameters (?field_zone_var - field_zone ?field_strip_var - field_strip ?soil_condition - soil_condition ?operation_window - operation_window ?planting_job - planting_job)
    :precondition
      (and
        (field_zone_ready ?field_zone_var)
        (field_strip_ready ?field_strip_var)
        (field_zone_soil_condition_binding ?field_zone_var ?soil_condition)
        (field_strip_operation_window_binding ?field_strip_var ?operation_window)
        (soil_condition_allocated ?soil_condition)
        (operation_window_allocated ?operation_window)
        (not
          (field_zone_flagged ?field_zone_var)
        )
        (not
          (field_strip_flagged ?field_strip_var)
        )
        (planting_job_slot_available ?planting_job)
      )
    :effect
      (and
        (planting_job_created ?planting_job)
        (planting_job_soil_condition_binding ?planting_job ?soil_condition)
        (planting_job_operation_window_binding ?planting_job ?operation_window)
        (planting_job_requires_irrigation ?planting_job)
        (planting_job_requires_fertilizer ?planting_job)
        (not
          (planting_job_slot_available ?planting_job)
        )
      )
  )
  (:action activate_planting_job
    :parameters (?planting_job - planting_job ?field_zone_var - field_zone ?crop_variety_var - crop_variety)
    :precondition
      (and
        (planting_job_created ?planting_job)
        (field_zone_ready ?field_zone_var)
        (planting_unit_assigned_variety ?field_zone_var ?crop_variety_var)
        (not
          (planting_job_profile_ready ?planting_job)
        )
      )
    :effect (planting_job_profile_ready ?planting_job)
  )
  (:action bind_seeding_rate_profile_to_job
    :parameters (?planting_prescription - planting_prescription ?seeding_rate_profile - seeding_rate_profile ?planting_job - planting_job)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?planting_prescription)
        (prescription_assigned_to_job ?planting_prescription ?planting_job)
        (prescription_has_seeding_rate_profile ?planting_prescription ?seeding_rate_profile)
        (seeding_rate_profile_available ?seeding_rate_profile)
        (planting_job_created ?planting_job)
        (planting_job_profile_ready ?planting_job)
        (not
          (seeding_rate_profile_allocated ?seeding_rate_profile)
        )
      )
    :effect
      (and
        (seeding_rate_profile_allocated ?seeding_rate_profile)
        (seeding_rate_profile_assigned_to_job ?seeding_rate_profile ?planting_job)
        (not
          (seeding_rate_profile_available ?seeding_rate_profile)
        )
      )
  )
  (:action lock_prescription_without_irrigation
    :parameters (?planting_prescription - planting_prescription ?seeding_rate_profile - seeding_rate_profile ?planting_job - planting_job ?crop_variety_var - crop_variety)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?planting_prescription)
        (prescription_has_seeding_rate_profile ?planting_prescription ?seeding_rate_profile)
        (seeding_rate_profile_allocated ?seeding_rate_profile)
        (seeding_rate_profile_assigned_to_job ?seeding_rate_profile ?planting_job)
        (planting_unit_assigned_variety ?planting_prescription ?crop_variety_var)
        (not
          (planting_job_requires_irrigation ?planting_job)
        )
        (not
          (prescription_calibrated ?planting_prescription)
        )
      )
    :effect (prescription_calibrated ?planting_prescription)
  )
  (:action attach_equipment_calibration_to_prescription
    :parameters (?planting_prescription - planting_prescription ?equipment_calibration - equipment_calibration)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?planting_prescription)
        (equipment_calibration_available ?equipment_calibration)
        (not
          (calibration_attached ?planting_prescription)
        )
      )
    :effect
      (and
        (calibration_attached ?planting_prescription)
        (prescription_calibration_binding ?planting_prescription ?equipment_calibration)
        (not
          (equipment_calibration_available ?equipment_calibration)
        )
      )
  )
  (:action finalize_prescription_with_calibration
    :parameters (?planting_prescription - planting_prescription ?seeding_rate_profile - seeding_rate_profile ?planting_job - planting_job ?crop_variety_var - crop_variety ?equipment_calibration - equipment_calibration)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?planting_prescription)
        (prescription_has_seeding_rate_profile ?planting_prescription ?seeding_rate_profile)
        (seeding_rate_profile_allocated ?seeding_rate_profile)
        (seeding_rate_profile_assigned_to_job ?seeding_rate_profile ?planting_job)
        (planting_unit_assigned_variety ?planting_prescription ?crop_variety_var)
        (planting_job_requires_irrigation ?planting_job)
        (calibration_attached ?planting_prescription)
        (prescription_calibration_binding ?planting_prescription ?equipment_calibration)
        (not
          (prescription_calibrated ?planting_prescription)
        )
      )
    :effect
      (and
        (prescription_calibrated ?planting_prescription)
        (calibration_verified ?planting_prescription)
      )
  )
  (:action validate_prescription_materials_step_1
    :parameters (?planting_prescription - planting_prescription ?irrigation_plan - irrigation_plan ?operator - operator ?seeding_rate_profile - seeding_rate_profile ?planting_job - planting_job)
    :precondition
      (and
        (prescription_calibrated ?planting_prescription)
        (prescription_irrigation_binding ?planting_prescription ?irrigation_plan)
        (planting_unit_operator_assigned ?planting_prescription ?operator)
        (prescription_has_seeding_rate_profile ?planting_prescription ?seeding_rate_profile)
        (seeding_rate_profile_assigned_to_job ?seeding_rate_profile ?planting_job)
        (not
          (planting_job_requires_fertilizer ?planting_job)
        )
        (not
          (prescription_materials_validated ?planting_prescription)
        )
      )
    :effect (prescription_materials_validated ?planting_prescription)
  )
  (:action validate_prescription_materials_step_2
    :parameters (?planting_prescription - planting_prescription ?irrigation_plan - irrigation_plan ?operator - operator ?seeding_rate_profile - seeding_rate_profile ?planting_job - planting_job)
    :precondition
      (and
        (prescription_calibrated ?planting_prescription)
        (prescription_irrigation_binding ?planting_prescription ?irrigation_plan)
        (planting_unit_operator_assigned ?planting_prescription ?operator)
        (prescription_has_seeding_rate_profile ?planting_prescription ?seeding_rate_profile)
        (seeding_rate_profile_assigned_to_job ?seeding_rate_profile ?planting_job)
        (planting_job_requires_fertilizer ?planting_job)
        (not
          (prescription_materials_validated ?planting_prescription)
        )
      )
    :effect (prescription_materials_validated ?planting_prescription)
  )
  (:action apply_yield_target_and_mark_ready
    :parameters (?planting_prescription - planting_prescription ?yield_target - yield_target ?seeding_rate_profile - seeding_rate_profile ?planting_job - planting_job)
    :precondition
      (and
        (prescription_materials_validated ?planting_prescription)
        (prescription_yield_target_binding ?planting_prescription ?yield_target)
        (prescription_has_seeding_rate_profile ?planting_prescription ?seeding_rate_profile)
        (seeding_rate_profile_assigned_to_job ?seeding_rate_profile ?planting_job)
        (not
          (planting_job_requires_irrigation ?planting_job)
        )
        (not
          (planting_job_requires_fertilizer ?planting_job)
        )
        (not
          (prescription_ready_for_finalization ?planting_prescription)
        )
      )
    :effect (prescription_ready_for_finalization ?planting_prescription)
  )
  (:action apply_yield_target_and_mark_with_fertilizer_option_a
    :parameters (?planting_prescription - planting_prescription ?yield_target - yield_target ?seeding_rate_profile - seeding_rate_profile ?planting_job - planting_job)
    :precondition
      (and
        (prescription_materials_validated ?planting_prescription)
        (prescription_yield_target_binding ?planting_prescription ?yield_target)
        (prescription_has_seeding_rate_profile ?planting_prescription ?seeding_rate_profile)
        (seeding_rate_profile_assigned_to_job ?seeding_rate_profile ?planting_job)
        (planting_job_requires_irrigation ?planting_job)
        (not
          (planting_job_requires_fertilizer ?planting_job)
        )
        (not
          (prescription_ready_for_finalization ?planting_prescription)
        )
      )
    :effect
      (and
        (prescription_ready_for_finalization ?planting_prescription)
        (prescription_fertilizer_required ?planting_prescription)
      )
  )
  (:action apply_yield_target_and_mark_with_fertilizer_option_b
    :parameters (?planting_prescription - planting_prescription ?yield_target - yield_target ?seeding_rate_profile - seeding_rate_profile ?planting_job - planting_job)
    :precondition
      (and
        (prescription_materials_validated ?planting_prescription)
        (prescription_yield_target_binding ?planting_prescription ?yield_target)
        (prescription_has_seeding_rate_profile ?planting_prescription ?seeding_rate_profile)
        (seeding_rate_profile_assigned_to_job ?seeding_rate_profile ?planting_job)
        (not
          (planting_job_requires_irrigation ?planting_job)
        )
        (planting_job_requires_fertilizer ?planting_job)
        (not
          (prescription_ready_for_finalization ?planting_prescription)
        )
      )
    :effect
      (and
        (prescription_ready_for_finalization ?planting_prescription)
        (prescription_fertilizer_required ?planting_prescription)
      )
  )
  (:action apply_yield_target_and_mark_with_fertilizer_option_c
    :parameters (?planting_prescription - planting_prescription ?yield_target - yield_target ?seeding_rate_profile - seeding_rate_profile ?planting_job - planting_job)
    :precondition
      (and
        (prescription_materials_validated ?planting_prescription)
        (prescription_yield_target_binding ?planting_prescription ?yield_target)
        (prescription_has_seeding_rate_profile ?planting_prescription ?seeding_rate_profile)
        (seeding_rate_profile_assigned_to_job ?seeding_rate_profile ?planting_job)
        (planting_job_requires_irrigation ?planting_job)
        (planting_job_requires_fertilizer ?planting_job)
        (not
          (prescription_ready_for_finalization ?planting_prescription)
        )
      )
    :effect
      (and
        (prescription_ready_for_finalization ?planting_prescription)
        (prescription_fertilizer_required ?planting_prescription)
      )
  )
  (:action finalize_prescription
    :parameters (?planting_prescription - planting_prescription)
    :precondition
      (and
        (prescription_ready_for_finalization ?planting_prescription)
        (not
          (prescription_fertilizer_required ?planting_prescription)
        )
        (not
          (prescription_approved ?planting_prescription)
        )
      )
    :effect
      (and
        (prescription_approved ?planting_prescription)
        (finalized_for_execution ?planting_prescription)
      )
  )
  (:action bind_fertilizer_plan_to_prescription
    :parameters (?planting_prescription - planting_prescription ?fertilizer_plan_var - fertilizer_plan)
    :precondition
      (and
        (prescription_ready_for_finalization ?planting_prescription)
        (prescription_fertilizer_required ?planting_prescription)
        (fertilizer_plan_available ?fertilizer_plan_var)
      )
    :effect
      (and
        (prescription_fertilizer_binding ?planting_prescription ?fertilizer_plan_var)
        (not
          (fertilizer_plan_available ?fertilizer_plan_var)
        )
      )
  )
  (:action validate_prescription_assembly
    :parameters (?planting_prescription - planting_prescription ?field_zone_var - field_zone ?field_strip_var - field_strip ?crop_variety_var - crop_variety ?fertilizer_plan_var - fertilizer_plan)
    :precondition
      (and
        (prescription_ready_for_finalization ?planting_prescription)
        (prescription_fertilizer_required ?planting_prescription)
        (prescription_fertilizer_binding ?planting_prescription ?fertilizer_plan_var)
        (prescription_field_zone_binding ?planting_prescription ?field_zone_var)
        (prescription_field_strip_binding ?planting_prescription ?field_strip_var)
        (field_zone_flagged ?field_zone_var)
        (field_strip_flagged ?field_strip_var)
        (planting_unit_assigned_variety ?planting_prescription ?crop_variety_var)
        (not
          (prescription_materials_and_calibration_bound ?planting_prescription)
        )
      )
    :effect (prescription_materials_and_calibration_bound ?planting_prescription)
  )
  (:action release_prescription_for_execution
    :parameters (?planting_prescription - planting_prescription)
    :precondition
      (and
        (prescription_ready_for_finalization ?planting_prescription)
        (prescription_materials_and_calibration_bound ?planting_prescription)
        (not
          (prescription_approved ?planting_prescription)
        )
      )
    :effect
      (and
        (prescription_approved ?planting_prescription)
        (finalized_for_execution ?planting_prescription)
      )
  )
  (:action attach_field_history_to_prescription
    :parameters (?planting_prescription - planting_prescription ?field_history_record - field_history_record ?crop_variety_var - crop_variety)
    :precondition
      (and
        (planting_unit_ready_for_prescription ?planting_prescription)
        (planting_unit_assigned_variety ?planting_prescription ?crop_variety_var)
        (field_history_available ?field_history_record)
        (prescription_field_history_binding ?planting_prescription ?field_history_record)
        (not
          (field_history_attached ?planting_prescription)
        )
      )
    :effect
      (and
        (field_history_attached ?planting_prescription)
        (not
          (field_history_available ?field_history_record)
        )
      )
  )
  (:action authorize_operator_for_prescription
    :parameters (?planting_prescription - planting_prescription ?operator - operator)
    :precondition
      (and
        (field_history_attached ?planting_prescription)
        (planting_unit_operator_assigned ?planting_prescription ?operator)
        (not
          (prescription_history_validated ?planting_prescription)
        )
      )
    :effect (prescription_history_validated ?planting_prescription)
  )
  (:action authorize_yield_target_for_prescription
    :parameters (?planting_prescription - planting_prescription ?yield_target - yield_target)
    :precondition
      (and
        (prescription_history_validated ?planting_prescription)
        (prescription_yield_target_binding ?planting_prescription ?yield_target)
        (not
          (prescription_yield_target_validated ?planting_prescription)
        )
      )
    :effect (prescription_yield_target_validated ?planting_prescription)
  )
  (:action finalize_operator_validation
    :parameters (?planting_prescription - planting_prescription)
    :precondition
      (and
        (prescription_yield_target_validated ?planting_prescription)
        (not
          (prescription_approved ?planting_prescription)
        )
      )
    :effect
      (and
        (prescription_approved ?planting_prescription)
        (finalized_for_execution ?planting_prescription)
      )
  )
  (:action signoff_zone_execution
    :parameters (?field_zone_var - field_zone ?planting_job - planting_job)
    :precondition
      (and
        (field_zone_ready ?field_zone_var)
        (field_zone_flagged ?field_zone_var)
        (planting_job_created ?planting_job)
        (planting_job_profile_ready ?planting_job)
        (not
          (finalized_for_execution ?field_zone_var)
        )
      )
    :effect (finalized_for_execution ?field_zone_var)
  )
  (:action signoff_strip_execution
    :parameters (?field_strip_var - field_strip ?planting_job - planting_job)
    :precondition
      (and
        (field_strip_ready ?field_strip_var)
        (field_strip_flagged ?field_strip_var)
        (planting_job_created ?planting_job)
        (planting_job_profile_ready ?planting_job)
        (not
          (finalized_for_execution ?field_strip_var)
        )
      )
    :effect (finalized_for_execution ?field_strip_var)
  )
  (:action signoff_land_unit_and_assign_season_slot
    :parameters (?land_unit - land_unit ?season_slot - season_slot ?crop_variety_var - crop_variety)
    :precondition
      (and
        (finalized_for_execution ?land_unit)
        (planting_unit_assigned_variety ?land_unit ?crop_variety_var)
        (season_slot_available ?season_slot)
        (not
          (signoff_recorded ?land_unit)
        )
      )
    :effect
      (and
        (signoff_recorded ?land_unit)
        (planting_unit_season_slot_binding ?land_unit ?season_slot)
        (not
          (season_slot_available ?season_slot)
        )
      )
  )
  (:action release_zone_for_planting
    :parameters (?field_zone_var - field_zone ?seed_equipment - seed_equipment ?season_slot - season_slot)
    :precondition
      (and
        (signoff_recorded ?field_zone_var)
        (planting_unit_equipment_binding ?field_zone_var ?seed_equipment)
        (planting_unit_season_slot_binding ?field_zone_var ?season_slot)
        (not
          (released_for_planting ?field_zone_var)
        )
      )
    :effect
      (and
        (released_for_planting ?field_zone_var)
        (seed_equipment_available ?seed_equipment)
        (season_slot_available ?season_slot)
      )
  )
  (:action release_strip_for_planting
    :parameters (?field_strip_var - field_strip ?seed_equipment - seed_equipment ?season_slot - season_slot)
    :precondition
      (and
        (signoff_recorded ?field_strip_var)
        (planting_unit_equipment_binding ?field_strip_var ?seed_equipment)
        (planting_unit_season_slot_binding ?field_strip_var ?season_slot)
        (not
          (released_for_planting ?field_strip_var)
        )
      )
    :effect
      (and
        (released_for_planting ?field_strip_var)
        (seed_equipment_available ?seed_equipment)
        (season_slot_available ?season_slot)
      )
  )
  (:action release_prescription_for_planting
    :parameters (?planting_prescription - planting_prescription ?seed_equipment - seed_equipment ?season_slot - season_slot)
    :precondition
      (and
        (signoff_recorded ?planting_prescription)
        (planting_unit_equipment_binding ?planting_prescription ?seed_equipment)
        (planting_unit_season_slot_binding ?planting_prescription ?season_slot)
        (not
          (released_for_planting ?planting_prescription)
        )
      )
    :effect
      (and
        (released_for_planting ?planting_prescription)
        (seed_equipment_available ?seed_equipment)
        (season_slot_available ?season_slot)
      )
  )
)

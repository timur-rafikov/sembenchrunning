(define (domain staggered_planting_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource - object material_type - object time_window_type - object domain_category - object field_unit - domain_category machinery_unit - operational_resource seed_variety - operational_resource technician - operational_resource processing_resource - operational_resource quality_test_kit - operational_resource logistics_asset - operational_resource nutrient_treatment - operational_resource inspection_slot - operational_resource input_material - material_type storage_unit - material_type certification_document - material_type planting_window - time_window_type irrigation_window - time_window_type harvest_lot - time_window_type planting_cohort_type - field_unit cohort_type_alt - field_unit early_planting_cohort - planting_cohort_type late_planting_cohort - planting_cohort_type field_season_plan - cohort_type_alt)
  (:predicates
    (field_registered ?field_unit - field_unit)
    (plan_confirmed ?field_unit - field_unit)
    (seeding_reserved ?field_unit - field_unit)
    (finalized ?field_unit - field_unit)
    (ready_for_dispatch ?field_unit - field_unit)
    (delivery_assigned ?field_unit - field_unit)
    (machinery_available ?machinery_unit - machinery_unit)
    (machinery_assigned ?field_unit - field_unit ?machinery_unit - machinery_unit)
    (seed_variety_available ?seed_variety - seed_variety)
    (seed_assigned ?field_unit - field_unit ?seed_variety - seed_variety)
    (technician_available ?technician - technician)
    (technician_assigned ?field_unit - field_unit ?technician - technician)
    (input_material_available ?input_material - input_material)
    (early_cohort_input_assigned ?early_cohort - early_planting_cohort ?input_material - input_material)
    (late_cohort_input_assigned ?late_cohort - late_planting_cohort ?input_material - input_material)
    (early_cohort_planting_window_assigned ?early_cohort - early_planting_cohort ?planting_window - planting_window)
    (planting_window_reserved ?planting_window - planting_window)
    (planting_window_inputs_applied ?planting_window - planting_window)
    (early_cohort_ready ?early_cohort - early_planting_cohort)
    (late_cohort_irrigation_window_assigned ?late_cohort - late_planting_cohort ?irrigation_window - irrigation_window)
    (irrigation_window_reserved ?irrigation_window - irrigation_window)
    (irrigation_window_inputs_applied ?irrigation_window - irrigation_window)
    (late_cohort_ready ?late_cohort - late_planting_cohort)
    (harvest_lot_unallocated ?harvest_lot - harvest_lot)
    (harvest_lot_created ?harvest_lot - harvest_lot)
    (harvest_lot_planting_window_link ?harvest_lot - harvest_lot ?planting_window - planting_window)
    (harvest_lot_irrigation_window_link ?harvest_lot - harvest_lot ?irrigation_window - irrigation_window)
    (harvest_lot_contains_early_cohort ?harvest_lot - harvest_lot)
    (harvest_lot_contains_late_cohort ?harvest_lot - harvest_lot)
    (harvest_lot_ready_for_storage ?harvest_lot - harvest_lot)
    (plan_has_early_cohort ?field_season_plan - field_season_plan ?early_cohort - early_planting_cohort)
    (plan_has_late_cohort ?field_season_plan - field_season_plan ?late_cohort - late_planting_cohort)
    (plan_linked_harvest_lot ?field_season_plan - field_season_plan ?harvest_lot - harvest_lot)
    (storage_unit_available ?storage_unit - storage_unit)
    (plan_assigned_storage ?field_season_plan - field_season_plan ?storage_unit - storage_unit)
    (storage_unit_in_use ?storage_unit - storage_unit)
    (storage_contains_harvest_lot ?storage_unit - storage_unit ?harvest_lot - harvest_lot)
    (processing_ready ?field_season_plan - field_season_plan)
    (treatment_executed ?field_season_plan - field_season_plan)
    (processing_complete ?field_season_plan - field_season_plan)
    (plan_processing_resource_reserved ?field_season_plan - field_season_plan)
    (processing_resource_prepared ?field_season_plan - field_season_plan)
    (qc_ready ?field_season_plan - field_season_plan)
    (processing_signoff_done ?field_season_plan - field_season_plan)
    (certification_document_available ?certification_document - certification_document)
    (plan_has_certification_document ?field_season_plan - field_season_plan ?certification_document - certification_document)
    (certification_attached ?field_season_plan - field_season_plan)
    (inspection_prepared ?field_season_plan - field_season_plan)
    (inspection_completed ?field_season_plan - field_season_plan)
    (processing_resource_available ?processing_resource - processing_resource)
    (plan_assigned_processing_resource ?field_season_plan - field_season_plan ?processing_resource - processing_resource)
    (quality_test_kit_available ?quality_test_kit - quality_test_kit)
    (plan_quality_testkit_assigned ?field_season_plan - field_season_plan ?quality_test_kit - quality_test_kit)
    (nutrient_treatment_available ?nutrient_treatment - nutrient_treatment)
    (plan_nutrient_treatment_assigned ?field_season_plan - field_season_plan ?nutrient_treatment - nutrient_treatment)
    (inspection_slot_available ?inspection_slot - inspection_slot)
    (plan_inspection_slot_assigned ?field_season_plan - field_season_plan ?inspection_slot - inspection_slot)
    (logistics_asset_available ?logistics_asset - logistics_asset)
    (logistics_assigned_to_unit ?field_unit - field_unit ?logistics_asset - logistics_asset)
    (early_cohort_prepared ?early_cohort - early_planting_cohort)
    (late_cohort_prepared ?late_cohort - late_planting_cohort)
    (plan_processed_and_marked ?field_season_plan - field_season_plan)
  )
  (:action register_field
    :parameters (?field_unit - field_unit)
    :precondition
      (and
        (not
          (field_registered ?field_unit)
        )
        (not
          (finalized ?field_unit)
        )
      )
    :effect (field_registered ?field_unit)
  )
  (:action allocate_machinery_for_seeding
    :parameters (?field_unit - field_unit ?machinery_unit - machinery_unit)
    :precondition
      (and
        (field_registered ?field_unit)
        (not
          (seeding_reserved ?field_unit)
        )
        (machinery_available ?machinery_unit)
      )
    :effect
      (and
        (seeding_reserved ?field_unit)
        (machinery_assigned ?field_unit ?machinery_unit)
        (not
          (machinery_available ?machinery_unit)
        )
      )
  )
  (:action assign_seed_to_field
    :parameters (?field_unit - field_unit ?seed_variety - seed_variety)
    :precondition
      (and
        (field_registered ?field_unit)
        (seeding_reserved ?field_unit)
        (seed_variety_available ?seed_variety)
      )
    :effect
      (and
        (seed_assigned ?field_unit ?seed_variety)
        (not
          (seed_variety_available ?seed_variety)
        )
      )
  )
  (:action confirm_field_plan
    :parameters (?field_unit - field_unit ?seed_variety - seed_variety)
    :precondition
      (and
        (field_registered ?field_unit)
        (seeding_reserved ?field_unit)
        (seed_assigned ?field_unit ?seed_variety)
        (not
          (plan_confirmed ?field_unit)
        )
      )
    :effect (plan_confirmed ?field_unit)
  )
  (:action release_seed_assignment
    :parameters (?field_unit - field_unit ?seed_variety - seed_variety)
    :precondition
      (and
        (seed_assigned ?field_unit ?seed_variety)
      )
    :effect
      (and
        (seed_variety_available ?seed_variety)
        (not
          (seed_assigned ?field_unit ?seed_variety)
        )
      )
  )
  (:action assign_technician_to_field
    :parameters (?field_unit - field_unit ?technician - technician)
    :precondition
      (and
        (plan_confirmed ?field_unit)
        (technician_available ?technician)
      )
    :effect
      (and
        (technician_assigned ?field_unit ?technician)
        (not
          (technician_available ?technician)
        )
      )
  )
  (:action release_technician_from_field
    :parameters (?field_unit - field_unit ?technician - technician)
    :precondition
      (and
        (technician_assigned ?field_unit ?technician)
      )
    :effect
      (and
        (technician_available ?technician)
        (not
          (technician_assigned ?field_unit ?technician)
        )
      )
  )
  (:action assign_nutrient_treatment_to_plan
    :parameters (?field_season_plan - field_season_plan ?nutrient_treatment - nutrient_treatment)
    :precondition
      (and
        (plan_confirmed ?field_season_plan)
        (nutrient_treatment_available ?nutrient_treatment)
      )
    :effect
      (and
        (plan_nutrient_treatment_assigned ?field_season_plan ?nutrient_treatment)
        (not
          (nutrient_treatment_available ?nutrient_treatment)
        )
      )
  )
  (:action release_nutrient_treatment_from_plan
    :parameters (?field_season_plan - field_season_plan ?nutrient_treatment - nutrient_treatment)
    :precondition
      (and
        (plan_nutrient_treatment_assigned ?field_season_plan ?nutrient_treatment)
      )
    :effect
      (and
        (nutrient_treatment_available ?nutrient_treatment)
        (not
          (plan_nutrient_treatment_assigned ?field_season_plan ?nutrient_treatment)
        )
      )
  )
  (:action assign_inspection_slot_to_plan
    :parameters (?field_season_plan - field_season_plan ?inspection_slot - inspection_slot)
    :precondition
      (and
        (plan_confirmed ?field_season_plan)
        (inspection_slot_available ?inspection_slot)
      )
    :effect
      (and
        (plan_inspection_slot_assigned ?field_season_plan ?inspection_slot)
        (not
          (inspection_slot_available ?inspection_slot)
        )
      )
  )
  (:action release_inspection_slot_from_plan
    :parameters (?field_season_plan - field_season_plan ?inspection_slot - inspection_slot)
    :precondition
      (and
        (plan_inspection_slot_assigned ?field_season_plan ?inspection_slot)
      )
    :effect
      (and
        (inspection_slot_available ?inspection_slot)
        (not
          (plan_inspection_slot_assigned ?field_season_plan ?inspection_slot)
        )
      )
  )
  (:action reserve_planting_window_for_cohort
    :parameters (?early_cohort - early_planting_cohort ?planting_window - planting_window ?seed_variety - seed_variety)
    :precondition
      (and
        (plan_confirmed ?early_cohort)
        (seed_assigned ?early_cohort ?seed_variety)
        (early_cohort_planting_window_assigned ?early_cohort ?planting_window)
        (not
          (planting_window_reserved ?planting_window)
        )
        (not
          (planting_window_inputs_applied ?planting_window)
        )
      )
    :effect (planting_window_reserved ?planting_window)
  )
  (:action execute_cohort_planting
    :parameters (?early_cohort - early_planting_cohort ?planting_window - planting_window ?technician - technician)
    :precondition
      (and
        (plan_confirmed ?early_cohort)
        (technician_assigned ?early_cohort ?technician)
        (early_cohort_planting_window_assigned ?early_cohort ?planting_window)
        (planting_window_reserved ?planting_window)
        (not
          (early_cohort_prepared ?early_cohort)
        )
      )
    :effect
      (and
        (early_cohort_prepared ?early_cohort)
        (early_cohort_ready ?early_cohort)
      )
  )
  (:action apply_input_to_cohort
    :parameters (?early_cohort - early_planting_cohort ?planting_window - planting_window ?input_material - input_material)
    :precondition
      (and
        (plan_confirmed ?early_cohort)
        (early_cohort_planting_window_assigned ?early_cohort ?planting_window)
        (input_material_available ?input_material)
        (not
          (early_cohort_prepared ?early_cohort)
        )
      )
    :effect
      (and
        (planting_window_inputs_applied ?planting_window)
        (early_cohort_prepared ?early_cohort)
        (early_cohort_input_assigned ?early_cohort ?input_material)
        (not
          (input_material_available ?input_material)
        )
      )
  )
  (:action confirm_cohort_input_and_mark_ready
    :parameters (?early_cohort - early_planting_cohort ?planting_window - planting_window ?seed_variety - seed_variety ?input_material - input_material)
    :precondition
      (and
        (plan_confirmed ?early_cohort)
        (seed_assigned ?early_cohort ?seed_variety)
        (early_cohort_planting_window_assigned ?early_cohort ?planting_window)
        (planting_window_inputs_applied ?planting_window)
        (early_cohort_input_assigned ?early_cohort ?input_material)
        (not
          (early_cohort_ready ?early_cohort)
        )
      )
    :effect
      (and
        (planting_window_reserved ?planting_window)
        (early_cohort_ready ?early_cohort)
        (input_material_available ?input_material)
        (not
          (early_cohort_input_assigned ?early_cohort ?input_material)
        )
      )
  )
  (:action reserve_irrigation_window_for_cohort
    :parameters (?late_cohort - late_planting_cohort ?irrigation_window - irrigation_window ?seed_variety - seed_variety)
    :precondition
      (and
        (plan_confirmed ?late_cohort)
        (seed_assigned ?late_cohort ?seed_variety)
        (late_cohort_irrigation_window_assigned ?late_cohort ?irrigation_window)
        (not
          (irrigation_window_reserved ?irrigation_window)
        )
        (not
          (irrigation_window_inputs_applied ?irrigation_window)
        )
      )
    :effect (irrigation_window_reserved ?irrigation_window)
  )
  (:action execute_cohort_irrigation
    :parameters (?late_cohort - late_planting_cohort ?irrigation_window - irrigation_window ?technician - technician)
    :precondition
      (and
        (plan_confirmed ?late_cohort)
        (technician_assigned ?late_cohort ?technician)
        (late_cohort_irrigation_window_assigned ?late_cohort ?irrigation_window)
        (irrigation_window_reserved ?irrigation_window)
        (not
          (late_cohort_prepared ?late_cohort)
        )
      )
    :effect
      (and
        (late_cohort_prepared ?late_cohort)
        (late_cohort_ready ?late_cohort)
      )
  )
  (:action apply_input_to_late_cohort
    :parameters (?late_cohort - late_planting_cohort ?irrigation_window - irrigation_window ?input_material - input_material)
    :precondition
      (and
        (plan_confirmed ?late_cohort)
        (late_cohort_irrigation_window_assigned ?late_cohort ?irrigation_window)
        (input_material_available ?input_material)
        (not
          (late_cohort_prepared ?late_cohort)
        )
      )
    :effect
      (and
        (irrigation_window_inputs_applied ?irrigation_window)
        (late_cohort_prepared ?late_cohort)
        (late_cohort_input_assigned ?late_cohort ?input_material)
        (not
          (input_material_available ?input_material)
        )
      )
  )
  (:action confirm_late_cohort_input_and_mark_ready
    :parameters (?late_cohort - late_planting_cohort ?irrigation_window - irrigation_window ?seed_variety - seed_variety ?input_material - input_material)
    :precondition
      (and
        (plan_confirmed ?late_cohort)
        (seed_assigned ?late_cohort ?seed_variety)
        (late_cohort_irrigation_window_assigned ?late_cohort ?irrigation_window)
        (irrigation_window_inputs_applied ?irrigation_window)
        (late_cohort_input_assigned ?late_cohort ?input_material)
        (not
          (late_cohort_ready ?late_cohort)
        )
      )
    :effect
      (and
        (irrigation_window_reserved ?irrigation_window)
        (late_cohort_ready ?late_cohort)
        (input_material_available ?input_material)
        (not
          (late_cohort_input_assigned ?late_cohort ?input_material)
        )
      )
  )
  (:action assemble_harvest_lot
    :parameters (?early_cohort - early_planting_cohort ?late_cohort - late_planting_cohort ?planting_window - planting_window ?irrigation_window - irrigation_window ?harvest_lot - harvest_lot)
    :precondition
      (and
        (early_cohort_prepared ?early_cohort)
        (late_cohort_prepared ?late_cohort)
        (early_cohort_planting_window_assigned ?early_cohort ?planting_window)
        (late_cohort_irrigation_window_assigned ?late_cohort ?irrigation_window)
        (planting_window_reserved ?planting_window)
        (irrigation_window_reserved ?irrigation_window)
        (early_cohort_ready ?early_cohort)
        (late_cohort_ready ?late_cohort)
        (harvest_lot_unallocated ?harvest_lot)
      )
    :effect
      (and
        (harvest_lot_created ?harvest_lot)
        (harvest_lot_planting_window_link ?harvest_lot ?planting_window)
        (harvest_lot_irrigation_window_link ?harvest_lot ?irrigation_window)
        (not
          (harvest_lot_unallocated ?harvest_lot)
        )
      )
  )
  (:action assemble_harvest_lot_mark_early_included
    :parameters (?early_cohort - early_planting_cohort ?late_cohort - late_planting_cohort ?planting_window - planting_window ?irrigation_window - irrigation_window ?harvest_lot - harvest_lot)
    :precondition
      (and
        (early_cohort_prepared ?early_cohort)
        (late_cohort_prepared ?late_cohort)
        (early_cohort_planting_window_assigned ?early_cohort ?planting_window)
        (late_cohort_irrigation_window_assigned ?late_cohort ?irrigation_window)
        (planting_window_inputs_applied ?planting_window)
        (irrigation_window_reserved ?irrigation_window)
        (not
          (early_cohort_ready ?early_cohort)
        )
        (late_cohort_ready ?late_cohort)
        (harvest_lot_unallocated ?harvest_lot)
      )
    :effect
      (and
        (harvest_lot_created ?harvest_lot)
        (harvest_lot_planting_window_link ?harvest_lot ?planting_window)
        (harvest_lot_irrigation_window_link ?harvest_lot ?irrigation_window)
        (harvest_lot_contains_early_cohort ?harvest_lot)
        (not
          (harvest_lot_unallocated ?harvest_lot)
        )
      )
  )
  (:action assemble_harvest_lot_mark_late_included
    :parameters (?early_cohort - early_planting_cohort ?late_cohort - late_planting_cohort ?planting_window - planting_window ?irrigation_window - irrigation_window ?harvest_lot - harvest_lot)
    :precondition
      (and
        (early_cohort_prepared ?early_cohort)
        (late_cohort_prepared ?late_cohort)
        (early_cohort_planting_window_assigned ?early_cohort ?planting_window)
        (late_cohort_irrigation_window_assigned ?late_cohort ?irrigation_window)
        (planting_window_reserved ?planting_window)
        (irrigation_window_inputs_applied ?irrigation_window)
        (early_cohort_ready ?early_cohort)
        (not
          (late_cohort_ready ?late_cohort)
        )
        (harvest_lot_unallocated ?harvest_lot)
      )
    :effect
      (and
        (harvest_lot_created ?harvest_lot)
        (harvest_lot_planting_window_link ?harvest_lot ?planting_window)
        (harvest_lot_irrigation_window_link ?harvest_lot ?irrigation_window)
        (harvest_lot_contains_late_cohort ?harvest_lot)
        (not
          (harvest_lot_unallocated ?harvest_lot)
        )
      )
  )
  (:action assemble_harvest_lot_with_both_cohorts
    :parameters (?early_cohort - early_planting_cohort ?late_cohort - late_planting_cohort ?planting_window - planting_window ?irrigation_window - irrigation_window ?harvest_lot - harvest_lot)
    :precondition
      (and
        (early_cohort_prepared ?early_cohort)
        (late_cohort_prepared ?late_cohort)
        (early_cohort_planting_window_assigned ?early_cohort ?planting_window)
        (late_cohort_irrigation_window_assigned ?late_cohort ?irrigation_window)
        (planting_window_inputs_applied ?planting_window)
        (irrigation_window_inputs_applied ?irrigation_window)
        (not
          (early_cohort_ready ?early_cohort)
        )
        (not
          (late_cohort_ready ?late_cohort)
        )
        (harvest_lot_unallocated ?harvest_lot)
      )
    :effect
      (and
        (harvest_lot_created ?harvest_lot)
        (harvest_lot_planting_window_link ?harvest_lot ?planting_window)
        (harvest_lot_irrigation_window_link ?harvest_lot ?irrigation_window)
        (harvest_lot_contains_early_cohort ?harvest_lot)
        (harvest_lot_contains_late_cohort ?harvest_lot)
        (not
          (harvest_lot_unallocated ?harvest_lot)
        )
      )
  )
  (:action mark_harvest_lot_ready_for_storage
    :parameters (?harvest_lot - harvest_lot ?early_cohort - early_planting_cohort ?seed_variety - seed_variety)
    :precondition
      (and
        (harvest_lot_created ?harvest_lot)
        (early_cohort_prepared ?early_cohort)
        (seed_assigned ?early_cohort ?seed_variety)
        (not
          (harvest_lot_ready_for_storage ?harvest_lot)
        )
      )
    :effect (harvest_lot_ready_for_storage ?harvest_lot)
  )
  (:action allocate_storage_for_harvest_lot
    :parameters (?field_season_plan - field_season_plan ?storage_unit - storage_unit ?harvest_lot - harvest_lot)
    :precondition
      (and
        (plan_confirmed ?field_season_plan)
        (plan_linked_harvest_lot ?field_season_plan ?harvest_lot)
        (plan_assigned_storage ?field_season_plan ?storage_unit)
        (storage_unit_available ?storage_unit)
        (harvest_lot_created ?harvest_lot)
        (harvest_lot_ready_for_storage ?harvest_lot)
        (not
          (storage_unit_in_use ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_in_use ?storage_unit)
        (storage_contains_harvest_lot ?storage_unit ?harvest_lot)
        (not
          (storage_unit_available ?storage_unit)
        )
      )
  )
  (:action mark_plan_processing_ready
    :parameters (?field_season_plan - field_season_plan ?storage_unit - storage_unit ?harvest_lot - harvest_lot ?seed_variety - seed_variety)
    :precondition
      (and
        (plan_confirmed ?field_season_plan)
        (plan_assigned_storage ?field_season_plan ?storage_unit)
        (storage_unit_in_use ?storage_unit)
        (storage_contains_harvest_lot ?storage_unit ?harvest_lot)
        (seed_assigned ?field_season_plan ?seed_variety)
        (not
          (harvest_lot_contains_early_cohort ?harvest_lot)
        )
        (not
          (processing_ready ?field_season_plan)
        )
      )
    :effect (processing_ready ?field_season_plan)
  )
  (:action assign_processing_resource_to_plan
    :parameters (?field_season_plan - field_season_plan ?processing_resource - processing_resource)
    :precondition
      (and
        (plan_confirmed ?field_season_plan)
        (processing_resource_available ?processing_resource)
        (not
          (plan_processing_resource_reserved ?field_season_plan)
        )
      )
    :effect
      (and
        (plan_processing_resource_reserved ?field_season_plan)
        (plan_assigned_processing_resource ?field_season_plan ?processing_resource)
        (not
          (processing_resource_available ?processing_resource)
        )
      )
  )
  (:action stage_processing_for_plan
    :parameters (?field_season_plan - field_season_plan ?storage_unit - storage_unit ?harvest_lot - harvest_lot ?seed_variety - seed_variety ?processing_resource - processing_resource)
    :precondition
      (and
        (plan_confirmed ?field_season_plan)
        (plan_assigned_storage ?field_season_plan ?storage_unit)
        (storage_unit_in_use ?storage_unit)
        (storage_contains_harvest_lot ?storage_unit ?harvest_lot)
        (seed_assigned ?field_season_plan ?seed_variety)
        (harvest_lot_contains_early_cohort ?harvest_lot)
        (plan_processing_resource_reserved ?field_season_plan)
        (plan_assigned_processing_resource ?field_season_plan ?processing_resource)
        (not
          (processing_ready ?field_season_plan)
        )
      )
    :effect
      (and
        (processing_ready ?field_season_plan)
        (processing_resource_prepared ?field_season_plan)
      )
  )
  (:action execute_assigned_nutrient_treatment
    :parameters (?field_season_plan - field_season_plan ?nutrient_treatment - nutrient_treatment ?technician - technician ?storage_unit - storage_unit ?harvest_lot - harvest_lot)
    :precondition
      (and
        (processing_ready ?field_season_plan)
        (plan_nutrient_treatment_assigned ?field_season_plan ?nutrient_treatment)
        (technician_assigned ?field_season_plan ?technician)
        (plan_assigned_storage ?field_season_plan ?storage_unit)
        (storage_contains_harvest_lot ?storage_unit ?harvest_lot)
        (not
          (harvest_lot_contains_late_cohort ?harvest_lot)
        )
        (not
          (treatment_executed ?field_season_plan)
        )
      )
    :effect (treatment_executed ?field_season_plan)
  )
  (:action confirm_nutrient_treatment_execution
    :parameters (?field_season_plan - field_season_plan ?nutrient_treatment - nutrient_treatment ?technician - technician ?storage_unit - storage_unit ?harvest_lot - harvest_lot)
    :precondition
      (and
        (processing_ready ?field_season_plan)
        (plan_nutrient_treatment_assigned ?field_season_plan ?nutrient_treatment)
        (technician_assigned ?field_season_plan ?technician)
        (plan_assigned_storage ?field_season_plan ?storage_unit)
        (storage_contains_harvest_lot ?storage_unit ?harvest_lot)
        (harvest_lot_contains_late_cohort ?harvest_lot)
        (not
          (treatment_executed ?field_season_plan)
        )
      )
    :effect (treatment_executed ?field_season_plan)
  )
  (:action complete_processing_stage
    :parameters (?field_season_plan - field_season_plan ?inspection_slot - inspection_slot ?storage_unit - storage_unit ?harvest_lot - harvest_lot)
    :precondition
      (and
        (treatment_executed ?field_season_plan)
        (plan_inspection_slot_assigned ?field_season_plan ?inspection_slot)
        (plan_assigned_storage ?field_season_plan ?storage_unit)
        (storage_contains_harvest_lot ?storage_unit ?harvest_lot)
        (not
          (harvest_lot_contains_early_cohort ?harvest_lot)
        )
        (not
          (harvest_lot_contains_late_cohort ?harvest_lot)
        )
        (not
          (processing_complete ?field_season_plan)
        )
      )
    :effect (processing_complete ?field_season_plan)
  )
  (:action complete_processing_and_mark_for_qc
    :parameters (?field_season_plan - field_season_plan ?inspection_slot - inspection_slot ?storage_unit - storage_unit ?harvest_lot - harvest_lot)
    :precondition
      (and
        (treatment_executed ?field_season_plan)
        (plan_inspection_slot_assigned ?field_season_plan ?inspection_slot)
        (plan_assigned_storage ?field_season_plan ?storage_unit)
        (storage_contains_harvest_lot ?storage_unit ?harvest_lot)
        (harvest_lot_contains_early_cohort ?harvest_lot)
        (not
          (harvest_lot_contains_late_cohort ?harvest_lot)
        )
        (not
          (processing_complete ?field_season_plan)
        )
      )
    :effect
      (and
        (processing_complete ?field_season_plan)
        (qc_ready ?field_season_plan)
      )
  )
  (:action complete_processing_and_mark_for_qc_variant
    :parameters (?field_season_plan - field_season_plan ?inspection_slot - inspection_slot ?storage_unit - storage_unit ?harvest_lot - harvest_lot)
    :precondition
      (and
        (treatment_executed ?field_season_plan)
        (plan_inspection_slot_assigned ?field_season_plan ?inspection_slot)
        (plan_assigned_storage ?field_season_plan ?storage_unit)
        (storage_contains_harvest_lot ?storage_unit ?harvest_lot)
        (not
          (harvest_lot_contains_early_cohort ?harvest_lot)
        )
        (harvest_lot_contains_late_cohort ?harvest_lot)
        (not
          (processing_complete ?field_season_plan)
        )
      )
    :effect
      (and
        (processing_complete ?field_season_plan)
        (qc_ready ?field_season_plan)
      )
  )
  (:action complete_processing_and_mark_for_qc_alternate
    :parameters (?field_season_plan - field_season_plan ?inspection_slot - inspection_slot ?storage_unit - storage_unit ?harvest_lot - harvest_lot)
    :precondition
      (and
        (treatment_executed ?field_season_plan)
        (plan_inspection_slot_assigned ?field_season_plan ?inspection_slot)
        (plan_assigned_storage ?field_season_plan ?storage_unit)
        (storage_contains_harvest_lot ?storage_unit ?harvest_lot)
        (harvest_lot_contains_early_cohort ?harvest_lot)
        (harvest_lot_contains_late_cohort ?harvest_lot)
        (not
          (processing_complete ?field_season_plan)
        )
      )
    :effect
      (and
        (processing_complete ?field_season_plan)
        (qc_ready ?field_season_plan)
      )
  )
  (:action finalize_plan_mark_ready_for_dispatch
    :parameters (?field_season_plan - field_season_plan)
    :precondition
      (and
        (processing_complete ?field_season_plan)
        (not
          (qc_ready ?field_season_plan)
        )
        (not
          (plan_processed_and_marked ?field_season_plan)
        )
      )
    :effect
      (and
        (plan_processed_and_marked ?field_season_plan)
        (ready_for_dispatch ?field_season_plan)
      )
  )
  (:action assign_quality_test_kit_to_plan
    :parameters (?field_season_plan - field_season_plan ?quality_test_kit - quality_test_kit)
    :precondition
      (and
        (processing_complete ?field_season_plan)
        (qc_ready ?field_season_plan)
        (quality_test_kit_available ?quality_test_kit)
      )
    :effect
      (and
        (plan_quality_testkit_assigned ?field_season_plan ?quality_test_kit)
        (not
          (quality_test_kit_available ?quality_test_kit)
        )
      )
  )
  (:action complete_qc_and_finalize_processing
    :parameters (?field_season_plan - field_season_plan ?early_cohort - early_planting_cohort ?late_cohort - late_planting_cohort ?seed_variety - seed_variety ?quality_test_kit - quality_test_kit)
    :precondition
      (and
        (processing_complete ?field_season_plan)
        (qc_ready ?field_season_plan)
        (plan_quality_testkit_assigned ?field_season_plan ?quality_test_kit)
        (plan_has_early_cohort ?field_season_plan ?early_cohort)
        (plan_has_late_cohort ?field_season_plan ?late_cohort)
        (early_cohort_ready ?early_cohort)
        (late_cohort_ready ?late_cohort)
        (seed_assigned ?field_season_plan ?seed_variety)
        (not
          (processing_signoff_done ?field_season_plan)
        )
      )
    :effect (processing_signoff_done ?field_season_plan)
  )
  (:action confirm_finalization_and_mark_ready
    :parameters (?field_season_plan - field_season_plan)
    :precondition
      (and
        (processing_complete ?field_season_plan)
        (processing_signoff_done ?field_season_plan)
        (not
          (plan_processed_and_marked ?field_season_plan)
        )
      )
    :effect
      (and
        (plan_processed_and_marked ?field_season_plan)
        (ready_for_dispatch ?field_season_plan)
      )
  )
  (:action attach_certification_document_to_plan
    :parameters (?field_season_plan - field_season_plan ?certification_document - certification_document ?seed_variety - seed_variety)
    :precondition
      (and
        (plan_confirmed ?field_season_plan)
        (seed_assigned ?field_season_plan ?seed_variety)
        (certification_document_available ?certification_document)
        (plan_has_certification_document ?field_season_plan ?certification_document)
        (not
          (certification_attached ?field_season_plan)
        )
      )
    :effect
      (and
        (certification_attached ?field_season_plan)
        (not
          (certification_document_available ?certification_document)
        )
      )
  )
  (:action prepare_plan_for_inspection
    :parameters (?field_season_plan - field_season_plan ?technician - technician)
    :precondition
      (and
        (certification_attached ?field_season_plan)
        (technician_assigned ?field_season_plan ?technician)
        (not
          (inspection_prepared ?field_season_plan)
        )
      )
    :effect (inspection_prepared ?field_season_plan)
  )
  (:action perform_inspection_on_plan
    :parameters (?field_season_plan - field_season_plan ?inspection_slot - inspection_slot)
    :precondition
      (and
        (inspection_prepared ?field_season_plan)
        (plan_inspection_slot_assigned ?field_season_plan ?inspection_slot)
        (not
          (inspection_completed ?field_season_plan)
        )
      )
    :effect (inspection_completed ?field_season_plan)
  )
  (:action finalize_inspection_and_mark_ready
    :parameters (?field_season_plan - field_season_plan)
    :precondition
      (and
        (inspection_completed ?field_season_plan)
        (not
          (plan_processed_and_marked ?field_season_plan)
        )
      )
    :effect
      (and
        (plan_processed_and_marked ?field_season_plan)
        (ready_for_dispatch ?field_season_plan)
      )
  )
  (:action mark_early_cohort_ready_for_dispatch
    :parameters (?early_cohort - early_planting_cohort ?harvest_lot - harvest_lot)
    :precondition
      (and
        (early_cohort_prepared ?early_cohort)
        (early_cohort_ready ?early_cohort)
        (harvest_lot_created ?harvest_lot)
        (harvest_lot_ready_for_storage ?harvest_lot)
        (not
          (ready_for_dispatch ?early_cohort)
        )
      )
    :effect (ready_for_dispatch ?early_cohort)
  )
  (:action mark_late_cohort_ready_for_dispatch
    :parameters (?late_cohort - late_planting_cohort ?harvest_lot - harvest_lot)
    :precondition
      (and
        (late_cohort_prepared ?late_cohort)
        (late_cohort_ready ?late_cohort)
        (harvest_lot_created ?harvest_lot)
        (harvest_lot_ready_for_storage ?harvest_lot)
        (not
          (ready_for_dispatch ?late_cohort)
        )
      )
    :effect (ready_for_dispatch ?late_cohort)
  )
  (:action assign_logistics_asset_to_unit
    :parameters (?field_unit - field_unit ?logistics_asset - logistics_asset ?seed_variety - seed_variety)
    :precondition
      (and
        (ready_for_dispatch ?field_unit)
        (seed_assigned ?field_unit ?seed_variety)
        (logistics_asset_available ?logistics_asset)
        (not
          (delivery_assigned ?field_unit)
        )
      )
    :effect
      (and
        (delivery_assigned ?field_unit)
        (logistics_assigned_to_unit ?field_unit ?logistics_asset)
        (not
          (logistics_asset_available ?logistics_asset)
        )
      )
  )
  (:action complete_delivery_for_early_cohort
    :parameters (?early_cohort - early_planting_cohort ?machinery_unit - machinery_unit ?logistics_asset - logistics_asset)
    :precondition
      (and
        (delivery_assigned ?early_cohort)
        (machinery_assigned ?early_cohort ?machinery_unit)
        (logistics_assigned_to_unit ?early_cohort ?logistics_asset)
        (not
          (finalized ?early_cohort)
        )
      )
    :effect
      (and
        (finalized ?early_cohort)
        (machinery_available ?machinery_unit)
        (logistics_asset_available ?logistics_asset)
      )
  )
  (:action complete_delivery_for_late_cohort
    :parameters (?late_cohort - late_planting_cohort ?machinery_unit - machinery_unit ?logistics_asset - logistics_asset)
    :precondition
      (and
        (delivery_assigned ?late_cohort)
        (machinery_assigned ?late_cohort ?machinery_unit)
        (logistics_assigned_to_unit ?late_cohort ?logistics_asset)
        (not
          (finalized ?late_cohort)
        )
      )
    :effect
      (and
        (finalized ?late_cohort)
        (machinery_available ?machinery_unit)
        (logistics_asset_available ?logistics_asset)
      )
  )
  (:action complete_delivery_for_field_plan
    :parameters (?field_season_plan - field_season_plan ?machinery_unit - machinery_unit ?logistics_asset - logistics_asset)
    :precondition
      (and
        (delivery_assigned ?field_season_plan)
        (machinery_assigned ?field_season_plan ?machinery_unit)
        (logistics_assigned_to_unit ?field_season_plan ?logistics_asset)
        (not
          (finalized ?field_season_plan)
        )
      )
    :effect
      (and
        (finalized ?field_season_plan)
        (machinery_available ?machinery_unit)
        (logistics_asset_available ?logistics_asset)
      )
  )
)

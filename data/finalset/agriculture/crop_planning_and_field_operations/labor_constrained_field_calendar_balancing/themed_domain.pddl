(define (domain labor_constrained_field_calendar_balancing)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object temporal_category - object logistics_category - object management_unit_base - object management_unit - management_unit_base crew_availability_token - resource_category operation_type - resource_category equipment_unit - resource_category certification_record - resource_category inspection_slot - resource_category labor_slot - resource_category material_type - resource_category application_method - resource_category input_material_batch - temporal_category crop_lot - temporal_category regulatory_permit - temporal_category primary_time_window - logistics_category secondary_time_window - logistics_category work_package - logistics_category management_unit_subtype_a - management_unit management_unit_subtype_b - management_unit primary_crew - management_unit_subtype_a secondary_crew - management_unit_subtype_a operation_bundle - management_unit_subtype_b)
  (:predicates
    (marked_for_planning ?management_unit - management_unit)
    (operation_confirmed ?management_unit - management_unit)
    (crew_allocated ?management_unit - management_unit)
    (assignment_closed ?management_unit - management_unit)
    (completed ?management_unit - management_unit)
    (labor_assigned ?management_unit - management_unit)
    (availability_token_active ?crew_availability_token - crew_availability_token)
    (has_availability_token ?management_unit - management_unit ?crew_availability_token - crew_availability_token)
    (operation_type_available ?operation_type - operation_type)
    (unit_operation_reserved ?management_unit - management_unit ?operation_type - operation_type)
    (equipment_available ?equipment_unit - equipment_unit)
    (unit_has_equipment ?management_unit - management_unit ?equipment_unit - equipment_unit)
    (input_batch_available ?input_material_batch - input_material_batch)
    (primary_crew_has_input_batch ?primary_crew - primary_crew ?input_material_batch - input_material_batch)
    (secondary_crew_has_input_batch ?secondary_crew - secondary_crew ?input_material_batch - input_material_batch)
    (primary_crew_has_time_window ?primary_crew - primary_crew ?primary_time_window - primary_time_window)
    (primary_window_prepared ?primary_time_window - primary_time_window)
    (primary_window_input_ready ?primary_time_window - primary_time_window)
    (primary_crew_ready ?primary_crew - primary_crew)
    (secondary_crew_has_time_window ?secondary_crew - secondary_crew ?secondary_time_window - secondary_time_window)
    (secondary_window_prepared ?secondary_time_window - secondary_time_window)
    (secondary_window_input_ready ?secondary_time_window - secondary_time_window)
    (secondary_crew_ready ?secondary_crew - secondary_crew)
    (work_package_available ?work_package - work_package)
    (work_package_ready ?work_package - work_package)
    (work_package_has_primary_window ?work_package - work_package ?primary_time_window - primary_time_window)
    (work_package_has_secondary_window ?work_package - work_package ?secondary_time_window - secondary_time_window)
    (work_package_flag_primary ?work_package - work_package)
    (work_package_flag_secondary ?work_package - work_package)
    (work_package_claimed_for_processing ?work_package - work_package)
    (bundle_has_primary_crew ?operation_bundle - operation_bundle ?primary_crew - primary_crew)
    (bundle_has_secondary_crew ?operation_bundle - operation_bundle ?secondary_crew - secondary_crew)
    (bundle_assigned_work_package ?operation_bundle - operation_bundle ?work_package - work_package)
    (crop_lot_available ?crop_lot - crop_lot)
    (bundle_has_crop_lot ?operation_bundle - operation_bundle ?crop_lot - crop_lot)
    (crop_lot_committed ?crop_lot - crop_lot)
    (crop_lot_assigned_to_package ?crop_lot - crop_lot ?work_package - work_package)
    (bundle_material_prepared ?operation_bundle - operation_bundle)
    (bundle_material_staged ?operation_bundle - operation_bundle)
    (bundle_ready_for_finalization ?operation_bundle - operation_bundle)
    (bundle_certification_attached ?operation_bundle - operation_bundle)
    (bundle_certification_confirmed ?operation_bundle - operation_bundle)
    (bundle_checks_passed ?operation_bundle - operation_bundle)
    (bundle_inspected ?operation_bundle - operation_bundle)
    (permit_available ?regulatory_permit - regulatory_permit)
    (bundle_has_permit ?operation_bundle - operation_bundle ?regulatory_permit - regulatory_permit)
    (bundle_permit_claimed ?operation_bundle - operation_bundle)
    (bundle_equipment_verified ?operation_bundle - operation_bundle)
    (bundle_method_verified ?operation_bundle - operation_bundle)
    (certification_available ?certification_record - certification_record)
    (bundle_has_certification ?operation_bundle - operation_bundle ?certification_record - certification_record)
    (inspection_slot_available ?inspection_slot - inspection_slot)
    (bundle_has_inspection_slot ?operation_bundle - operation_bundle ?inspection_slot - inspection_slot)
    (material_type_available ?material_type - material_type)
    (bundle_has_material_type ?operation_bundle - operation_bundle ?material_type - material_type)
    (application_method_available ?application_method - application_method)
    (bundle_has_application_method ?operation_bundle - operation_bundle ?application_method - application_method)
    (labor_slot_available ?labor_slot - labor_slot)
    (has_labor_slot ?management_unit - management_unit ?labor_slot - labor_slot)
    (primary_crew_locked ?primary_crew - primary_crew)
    (secondary_crew_locked ?secondary_crew - secondary_crew)
    (bundle_finalized ?operation_bundle - operation_bundle)
  )
  (:action mark_unit_for_planning
    :parameters (?management_unit - management_unit)
    :precondition
      (and
        (not
          (marked_for_planning ?management_unit)
        )
        (not
          (assignment_closed ?management_unit)
        )
      )
    :effect (marked_for_planning ?management_unit)
  )
  (:action assign_availability_token_to_unit
    :parameters (?management_unit - management_unit ?crew_availability_token - crew_availability_token)
    :precondition
      (and
        (marked_for_planning ?management_unit)
        (not
          (crew_allocated ?management_unit)
        )
        (availability_token_active ?crew_availability_token)
      )
    :effect
      (and
        (crew_allocated ?management_unit)
        (has_availability_token ?management_unit ?crew_availability_token)
        (not
          (availability_token_active ?crew_availability_token)
        )
      )
  )
  (:action reserve_operation_type
    :parameters (?management_unit - management_unit ?operation_type - operation_type)
    :precondition
      (and
        (marked_for_planning ?management_unit)
        (crew_allocated ?management_unit)
        (operation_type_available ?operation_type)
      )
    :effect
      (and
        (unit_operation_reserved ?management_unit ?operation_type)
        (not
          (operation_type_available ?operation_type)
        )
      )
  )
  (:action confirm_unit_operation
    :parameters (?management_unit - management_unit ?operation_type - operation_type)
    :precondition
      (and
        (marked_for_planning ?management_unit)
        (crew_allocated ?management_unit)
        (unit_operation_reserved ?management_unit ?operation_type)
        (not
          (operation_confirmed ?management_unit)
        )
      )
    :effect (operation_confirmed ?management_unit)
  )
  (:action release_operation_type
    :parameters (?management_unit - management_unit ?operation_type - operation_type)
    :precondition
      (and
        (unit_operation_reserved ?management_unit ?operation_type)
      )
    :effect
      (and
        (operation_type_available ?operation_type)
        (not
          (unit_operation_reserved ?management_unit ?operation_type)
        )
      )
  )
  (:action checkout_equipment
    :parameters (?management_unit - management_unit ?equipment_unit - equipment_unit)
    :precondition
      (and
        (operation_confirmed ?management_unit)
        (equipment_available ?equipment_unit)
      )
    :effect
      (and
        (unit_has_equipment ?management_unit ?equipment_unit)
        (not
          (equipment_available ?equipment_unit)
        )
      )
  )
  (:action return_equipment
    :parameters (?management_unit - management_unit ?equipment_unit - equipment_unit)
    :precondition
      (and
        (unit_has_equipment ?management_unit ?equipment_unit)
      )
    :effect
      (and
        (equipment_available ?equipment_unit)
        (not
          (unit_has_equipment ?management_unit ?equipment_unit)
        )
      )
  )
  (:action attach_material_type_to_bundle
    :parameters (?operation_bundle - operation_bundle ?material_type - material_type)
    :precondition
      (and
        (operation_confirmed ?operation_bundle)
        (material_type_available ?material_type)
      )
    :effect
      (and
        (bundle_has_material_type ?operation_bundle ?material_type)
        (not
          (material_type_available ?material_type)
        )
      )
  )
  (:action detach_material_type_from_bundle
    :parameters (?operation_bundle - operation_bundle ?material_type - material_type)
    :precondition
      (and
        (bundle_has_material_type ?operation_bundle ?material_type)
      )
    :effect
      (and
        (material_type_available ?material_type)
        (not
          (bundle_has_material_type ?operation_bundle ?material_type)
        )
      )
  )
  (:action attach_application_method_to_bundle
    :parameters (?operation_bundle - operation_bundle ?application_method - application_method)
    :precondition
      (and
        (operation_confirmed ?operation_bundle)
        (application_method_available ?application_method)
      )
    :effect
      (and
        (bundle_has_application_method ?operation_bundle ?application_method)
        (not
          (application_method_available ?application_method)
        )
      )
  )
  (:action detach_application_method_from_bundle
    :parameters (?operation_bundle - operation_bundle ?application_method - application_method)
    :precondition
      (and
        (bundle_has_application_method ?operation_bundle ?application_method)
      )
    :effect
      (and
        (application_method_available ?application_method)
        (not
          (bundle_has_application_method ?operation_bundle ?application_method)
        )
      )
  )
  (:action prepare_primary_window
    :parameters (?primary_crew - primary_crew ?primary_time_window - primary_time_window ?operation_type - operation_type)
    :precondition
      (and
        (operation_confirmed ?primary_crew)
        (unit_operation_reserved ?primary_crew ?operation_type)
        (primary_crew_has_time_window ?primary_crew ?primary_time_window)
        (not
          (primary_window_prepared ?primary_time_window)
        )
        (not
          (primary_window_input_ready ?primary_time_window)
        )
      )
    :effect (primary_window_prepared ?primary_time_window)
  )
  (:action assign_equipment_and_mark_primary_crew_ready
    :parameters (?primary_crew - primary_crew ?primary_time_window - primary_time_window ?equipment_unit - equipment_unit)
    :precondition
      (and
        (operation_confirmed ?primary_crew)
        (unit_has_equipment ?primary_crew ?equipment_unit)
        (primary_crew_has_time_window ?primary_crew ?primary_time_window)
        (primary_window_prepared ?primary_time_window)
        (not
          (primary_crew_locked ?primary_crew)
        )
      )
    :effect
      (and
        (primary_crew_locked ?primary_crew)
        (primary_crew_ready ?primary_crew)
      )
  )
  (:action assign_input_and_flag_primary_window
    :parameters (?primary_crew - primary_crew ?primary_time_window - primary_time_window ?input_material_batch - input_material_batch)
    :precondition
      (and
        (operation_confirmed ?primary_crew)
        (primary_crew_has_time_window ?primary_crew ?primary_time_window)
        (input_batch_available ?input_material_batch)
        (not
          (primary_crew_locked ?primary_crew)
        )
      )
    :effect
      (and
        (primary_window_input_ready ?primary_time_window)
        (primary_crew_locked ?primary_crew)
        (primary_crew_has_input_batch ?primary_crew ?input_material_batch)
        (not
          (input_batch_available ?input_material_batch)
        )
      )
  )
  (:action process_primary_window_with_input
    :parameters (?primary_crew - primary_crew ?primary_time_window - primary_time_window ?operation_type - operation_type ?input_material_batch - input_material_batch)
    :precondition
      (and
        (operation_confirmed ?primary_crew)
        (unit_operation_reserved ?primary_crew ?operation_type)
        (primary_crew_has_time_window ?primary_crew ?primary_time_window)
        (primary_window_input_ready ?primary_time_window)
        (primary_crew_has_input_batch ?primary_crew ?input_material_batch)
        (not
          (primary_crew_ready ?primary_crew)
        )
      )
    :effect
      (and
        (primary_window_prepared ?primary_time_window)
        (primary_crew_ready ?primary_crew)
        (input_batch_available ?input_material_batch)
        (not
          (primary_crew_has_input_batch ?primary_crew ?input_material_batch)
        )
      )
  )
  (:action prepare_secondary_window
    :parameters (?secondary_crew - secondary_crew ?secondary_time_window - secondary_time_window ?operation_type - operation_type)
    :precondition
      (and
        (operation_confirmed ?secondary_crew)
        (unit_operation_reserved ?secondary_crew ?operation_type)
        (secondary_crew_has_time_window ?secondary_crew ?secondary_time_window)
        (not
          (secondary_window_prepared ?secondary_time_window)
        )
        (not
          (secondary_window_input_ready ?secondary_time_window)
        )
      )
    :effect (secondary_window_prepared ?secondary_time_window)
  )
  (:action assign_equipment_and_mark_secondary_crew_ready
    :parameters (?secondary_crew - secondary_crew ?secondary_time_window - secondary_time_window ?equipment_unit - equipment_unit)
    :precondition
      (and
        (operation_confirmed ?secondary_crew)
        (unit_has_equipment ?secondary_crew ?equipment_unit)
        (secondary_crew_has_time_window ?secondary_crew ?secondary_time_window)
        (secondary_window_prepared ?secondary_time_window)
        (not
          (secondary_crew_locked ?secondary_crew)
        )
      )
    :effect
      (and
        (secondary_crew_locked ?secondary_crew)
        (secondary_crew_ready ?secondary_crew)
      )
  )
  (:action assign_input_to_secondary_crew
    :parameters (?secondary_crew - secondary_crew ?secondary_time_window - secondary_time_window ?input_material_batch - input_material_batch)
    :precondition
      (and
        (operation_confirmed ?secondary_crew)
        (secondary_crew_has_time_window ?secondary_crew ?secondary_time_window)
        (input_batch_available ?input_material_batch)
        (not
          (secondary_crew_locked ?secondary_crew)
        )
      )
    :effect
      (and
        (secondary_window_input_ready ?secondary_time_window)
        (secondary_crew_locked ?secondary_crew)
        (secondary_crew_has_input_batch ?secondary_crew ?input_material_batch)
        (not
          (input_batch_available ?input_material_batch)
        )
      )
  )
  (:action process_secondary_window_with_input
    :parameters (?secondary_crew - secondary_crew ?secondary_time_window - secondary_time_window ?operation_type - operation_type ?input_material_batch - input_material_batch)
    :precondition
      (and
        (operation_confirmed ?secondary_crew)
        (unit_operation_reserved ?secondary_crew ?operation_type)
        (secondary_crew_has_time_window ?secondary_crew ?secondary_time_window)
        (secondary_window_input_ready ?secondary_time_window)
        (secondary_crew_has_input_batch ?secondary_crew ?input_material_batch)
        (not
          (secondary_crew_ready ?secondary_crew)
        )
      )
    :effect
      (and
        (secondary_window_prepared ?secondary_time_window)
        (secondary_crew_ready ?secondary_crew)
        (input_batch_available ?input_material_batch)
        (not
          (secondary_crew_has_input_batch ?secondary_crew ?input_material_batch)
        )
      )
  )
  (:action assemble_work_package_both_windows_prepared
    :parameters (?primary_crew - primary_crew ?secondary_crew - secondary_crew ?primary_time_window - primary_time_window ?secondary_time_window - secondary_time_window ?work_package - work_package)
    :precondition
      (and
        (primary_crew_locked ?primary_crew)
        (secondary_crew_locked ?secondary_crew)
        (primary_crew_has_time_window ?primary_crew ?primary_time_window)
        (secondary_crew_has_time_window ?secondary_crew ?secondary_time_window)
        (primary_window_prepared ?primary_time_window)
        (secondary_window_prepared ?secondary_time_window)
        (primary_crew_ready ?primary_crew)
        (secondary_crew_ready ?secondary_crew)
        (work_package_available ?work_package)
      )
    :effect
      (and
        (work_package_ready ?work_package)
        (work_package_has_primary_window ?work_package ?primary_time_window)
        (work_package_has_secondary_window ?work_package ?secondary_time_window)
        (not
          (work_package_available ?work_package)
        )
      )
  )
  (:action assemble_work_package_primary_input_secondary_prepared
    :parameters (?primary_crew - primary_crew ?secondary_crew - secondary_crew ?primary_time_window - primary_time_window ?secondary_time_window - secondary_time_window ?work_package - work_package)
    :precondition
      (and
        (primary_crew_locked ?primary_crew)
        (secondary_crew_locked ?secondary_crew)
        (primary_crew_has_time_window ?primary_crew ?primary_time_window)
        (secondary_crew_has_time_window ?secondary_crew ?secondary_time_window)
        (primary_window_input_ready ?primary_time_window)
        (secondary_window_prepared ?secondary_time_window)
        (not
          (primary_crew_ready ?primary_crew)
        )
        (secondary_crew_ready ?secondary_crew)
        (work_package_available ?work_package)
      )
    :effect
      (and
        (work_package_ready ?work_package)
        (work_package_has_primary_window ?work_package ?primary_time_window)
        (work_package_has_secondary_window ?work_package ?secondary_time_window)
        (work_package_flag_primary ?work_package)
        (not
          (work_package_available ?work_package)
        )
      )
  )
  (:action assemble_work_package_primary_prepared_secondary_input
    :parameters (?primary_crew - primary_crew ?secondary_crew - secondary_crew ?primary_time_window - primary_time_window ?secondary_time_window - secondary_time_window ?work_package - work_package)
    :precondition
      (and
        (primary_crew_locked ?primary_crew)
        (secondary_crew_locked ?secondary_crew)
        (primary_crew_has_time_window ?primary_crew ?primary_time_window)
        (secondary_crew_has_time_window ?secondary_crew ?secondary_time_window)
        (primary_window_prepared ?primary_time_window)
        (secondary_window_input_ready ?secondary_time_window)
        (primary_crew_ready ?primary_crew)
        (not
          (secondary_crew_ready ?secondary_crew)
        )
        (work_package_available ?work_package)
      )
    :effect
      (and
        (work_package_ready ?work_package)
        (work_package_has_primary_window ?work_package ?primary_time_window)
        (work_package_has_secondary_window ?work_package ?secondary_time_window)
        (work_package_flag_secondary ?work_package)
        (not
          (work_package_available ?work_package)
        )
      )
  )
  (:action assemble_work_package_both_windows_input_ready
    :parameters (?primary_crew - primary_crew ?secondary_crew - secondary_crew ?primary_time_window - primary_time_window ?secondary_time_window - secondary_time_window ?work_package - work_package)
    :precondition
      (and
        (primary_crew_locked ?primary_crew)
        (secondary_crew_locked ?secondary_crew)
        (primary_crew_has_time_window ?primary_crew ?primary_time_window)
        (secondary_crew_has_time_window ?secondary_crew ?secondary_time_window)
        (primary_window_input_ready ?primary_time_window)
        (secondary_window_input_ready ?secondary_time_window)
        (not
          (primary_crew_ready ?primary_crew)
        )
        (not
          (secondary_crew_ready ?secondary_crew)
        )
        (work_package_available ?work_package)
      )
    :effect
      (and
        (work_package_ready ?work_package)
        (work_package_has_primary_window ?work_package ?primary_time_window)
        (work_package_has_secondary_window ?work_package ?secondary_time_window)
        (work_package_flag_primary ?work_package)
        (work_package_flag_secondary ?work_package)
        (not
          (work_package_available ?work_package)
        )
      )
  )
  (:action claim_work_package_for_processing
    :parameters (?work_package - work_package ?primary_crew - primary_crew ?operation_type - operation_type)
    :precondition
      (and
        (work_package_ready ?work_package)
        (primary_crew_locked ?primary_crew)
        (unit_operation_reserved ?primary_crew ?operation_type)
        (not
          (work_package_claimed_for_processing ?work_package)
        )
      )
    :effect (work_package_claimed_for_processing ?work_package)
  )
  (:action bind_crop_lot_to_bundle
    :parameters (?operation_bundle - operation_bundle ?crop_lot - crop_lot ?work_package - work_package)
    :precondition
      (and
        (operation_confirmed ?operation_bundle)
        (bundle_assigned_work_package ?operation_bundle ?work_package)
        (bundle_has_crop_lot ?operation_bundle ?crop_lot)
        (crop_lot_available ?crop_lot)
        (work_package_ready ?work_package)
        (work_package_claimed_for_processing ?work_package)
        (not
          (crop_lot_committed ?crop_lot)
        )
      )
    :effect
      (and
        (crop_lot_committed ?crop_lot)
        (crop_lot_assigned_to_package ?crop_lot ?work_package)
        (not
          (crop_lot_available ?crop_lot)
        )
      )
  )
  (:action stage_bundle_material
    :parameters (?operation_bundle - operation_bundle ?crop_lot - crop_lot ?work_package - work_package ?operation_type - operation_type)
    :precondition
      (and
        (operation_confirmed ?operation_bundle)
        (bundle_has_crop_lot ?operation_bundle ?crop_lot)
        (crop_lot_committed ?crop_lot)
        (crop_lot_assigned_to_package ?crop_lot ?work_package)
        (unit_operation_reserved ?operation_bundle ?operation_type)
        (not
          (work_package_flag_primary ?work_package)
        )
        (not
          (bundle_material_prepared ?operation_bundle)
        )
      )
    :effect (bundle_material_prepared ?operation_bundle)
  )
  (:action apply_certification_to_bundle
    :parameters (?operation_bundle - operation_bundle ?certification_record - certification_record)
    :precondition
      (and
        (operation_confirmed ?operation_bundle)
        (certification_available ?certification_record)
        (not
          (bundle_certification_attached ?operation_bundle)
        )
      )
    :effect
      (and
        (bundle_certification_attached ?operation_bundle)
        (bundle_has_certification ?operation_bundle ?certification_record)
        (not
          (certification_available ?certification_record)
        )
      )
  )
  (:action finalize_bundle_certification_and_material_prep
    :parameters (?operation_bundle - operation_bundle ?crop_lot - crop_lot ?work_package - work_package ?operation_type - operation_type ?certification_record - certification_record)
    :precondition
      (and
        (operation_confirmed ?operation_bundle)
        (bundle_has_crop_lot ?operation_bundle ?crop_lot)
        (crop_lot_committed ?crop_lot)
        (crop_lot_assigned_to_package ?crop_lot ?work_package)
        (unit_operation_reserved ?operation_bundle ?operation_type)
        (work_package_flag_primary ?work_package)
        (bundle_certification_attached ?operation_bundle)
        (bundle_has_certification ?operation_bundle ?certification_record)
        (not
          (bundle_material_prepared ?operation_bundle)
        )
      )
    :effect
      (and
        (bundle_material_prepared ?operation_bundle)
        (bundle_certification_confirmed ?operation_bundle)
      )
  )
  (:action stage_bundle_for_application_variant1
    :parameters (?operation_bundle - operation_bundle ?material_type - material_type ?equipment_unit - equipment_unit ?crop_lot - crop_lot ?work_package - work_package)
    :precondition
      (and
        (bundle_material_prepared ?operation_bundle)
        (bundle_has_material_type ?operation_bundle ?material_type)
        (unit_has_equipment ?operation_bundle ?equipment_unit)
        (bundle_has_crop_lot ?operation_bundle ?crop_lot)
        (crop_lot_assigned_to_package ?crop_lot ?work_package)
        (not
          (work_package_flag_secondary ?work_package)
        )
        (not
          (bundle_material_staged ?operation_bundle)
        )
      )
    :effect (bundle_material_staged ?operation_bundle)
  )
  (:action stage_bundle_for_application_variant2
    :parameters (?operation_bundle - operation_bundle ?material_type - material_type ?equipment_unit - equipment_unit ?crop_lot - crop_lot ?work_package - work_package)
    :precondition
      (and
        (bundle_material_prepared ?operation_bundle)
        (bundle_has_material_type ?operation_bundle ?material_type)
        (unit_has_equipment ?operation_bundle ?equipment_unit)
        (bundle_has_crop_lot ?operation_bundle ?crop_lot)
        (crop_lot_assigned_to_package ?crop_lot ?work_package)
        (work_package_flag_secondary ?work_package)
        (not
          (bundle_material_staged ?operation_bundle)
        )
      )
    :effect (bundle_material_staged ?operation_bundle)
  )
  (:action prepare_bundle_for_method_application
    :parameters (?operation_bundle - operation_bundle ?application_method - application_method ?crop_lot - crop_lot ?work_package - work_package)
    :precondition
      (and
        (bundle_material_staged ?operation_bundle)
        (bundle_has_application_method ?operation_bundle ?application_method)
        (bundle_has_crop_lot ?operation_bundle ?crop_lot)
        (crop_lot_assigned_to_package ?crop_lot ?work_package)
        (not
          (work_package_flag_primary ?work_package)
        )
        (not
          (work_package_flag_secondary ?work_package)
        )
        (not
          (bundle_ready_for_finalization ?operation_bundle)
        )
      )
    :effect (bundle_ready_for_finalization ?operation_bundle)
  )
  (:action prepare_bundle_and_attach_checks
    :parameters (?operation_bundle - operation_bundle ?application_method - application_method ?crop_lot - crop_lot ?work_package - work_package)
    :precondition
      (and
        (bundle_material_staged ?operation_bundle)
        (bundle_has_application_method ?operation_bundle ?application_method)
        (bundle_has_crop_lot ?operation_bundle ?crop_lot)
        (crop_lot_assigned_to_package ?crop_lot ?work_package)
        (work_package_flag_primary ?work_package)
        (not
          (work_package_flag_secondary ?work_package)
        )
        (not
          (bundle_ready_for_finalization ?operation_bundle)
        )
      )
    :effect
      (and
        (bundle_ready_for_finalization ?operation_bundle)
        (bundle_checks_passed ?operation_bundle)
      )
  )
  (:action prepare_bundle_and_attach_checks_variant2
    :parameters (?operation_bundle - operation_bundle ?application_method - application_method ?crop_lot - crop_lot ?work_package - work_package)
    :precondition
      (and
        (bundle_material_staged ?operation_bundle)
        (bundle_has_application_method ?operation_bundle ?application_method)
        (bundle_has_crop_lot ?operation_bundle ?crop_lot)
        (crop_lot_assigned_to_package ?crop_lot ?work_package)
        (not
          (work_package_flag_primary ?work_package)
        )
        (work_package_flag_secondary ?work_package)
        (not
          (bundle_ready_for_finalization ?operation_bundle)
        )
      )
    :effect
      (and
        (bundle_ready_for_finalization ?operation_bundle)
        (bundle_checks_passed ?operation_bundle)
      )
  )
  (:action prepare_bundle_and_attach_checks_variant3
    :parameters (?operation_bundle - operation_bundle ?application_method - application_method ?crop_lot - crop_lot ?work_package - work_package)
    :precondition
      (and
        (bundle_material_staged ?operation_bundle)
        (bundle_has_application_method ?operation_bundle ?application_method)
        (bundle_has_crop_lot ?operation_bundle ?crop_lot)
        (crop_lot_assigned_to_package ?crop_lot ?work_package)
        (work_package_flag_primary ?work_package)
        (work_package_flag_secondary ?work_package)
        (not
          (bundle_ready_for_finalization ?operation_bundle)
        )
      )
    :effect
      (and
        (bundle_ready_for_finalization ?operation_bundle)
        (bundle_checks_passed ?operation_bundle)
      )
  )
  (:action finalize_bundle_without_checks
    :parameters (?operation_bundle - operation_bundle)
    :precondition
      (and
        (bundle_ready_for_finalization ?operation_bundle)
        (not
          (bundle_checks_passed ?operation_bundle)
        )
        (not
          (bundle_finalized ?operation_bundle)
        )
      )
    :effect
      (and
        (bundle_finalized ?operation_bundle)
        (completed ?operation_bundle)
      )
  )
  (:action assign_inspection_slot_to_bundle
    :parameters (?operation_bundle - operation_bundle ?inspection_slot - inspection_slot)
    :precondition
      (and
        (bundle_ready_for_finalization ?operation_bundle)
        (bundle_checks_passed ?operation_bundle)
        (inspection_slot_available ?inspection_slot)
      )
    :effect
      (and
        (bundle_has_inspection_slot ?operation_bundle ?inspection_slot)
        (not
          (inspection_slot_available ?inspection_slot)
        )
      )
  )
  (:action lock_bundle_after_final_checks
    :parameters (?operation_bundle - operation_bundle ?primary_crew - primary_crew ?secondary_crew - secondary_crew ?operation_type - operation_type ?inspection_slot - inspection_slot)
    :precondition
      (and
        (bundle_ready_for_finalization ?operation_bundle)
        (bundle_checks_passed ?operation_bundle)
        (bundle_has_inspection_slot ?operation_bundle ?inspection_slot)
        (bundle_has_primary_crew ?operation_bundle ?primary_crew)
        (bundle_has_secondary_crew ?operation_bundle ?secondary_crew)
        (primary_crew_ready ?primary_crew)
        (secondary_crew_ready ?secondary_crew)
        (unit_operation_reserved ?operation_bundle ?operation_type)
        (not
          (bundle_inspected ?operation_bundle)
        )
      )
    :effect (bundle_inspected ?operation_bundle)
  )
  (:action finalize_bundle_with_checks
    :parameters (?operation_bundle - operation_bundle)
    :precondition
      (and
        (bundle_ready_for_finalization ?operation_bundle)
        (bundle_inspected ?operation_bundle)
        (not
          (bundle_finalized ?operation_bundle)
        )
      )
    :effect
      (and
        (bundle_finalized ?operation_bundle)
        (completed ?operation_bundle)
      )
  )
  (:action claim_permit_for_bundle
    :parameters (?operation_bundle - operation_bundle ?regulatory_permit - regulatory_permit ?operation_type - operation_type)
    :precondition
      (and
        (operation_confirmed ?operation_bundle)
        (unit_operation_reserved ?operation_bundle ?operation_type)
        (permit_available ?regulatory_permit)
        (bundle_has_permit ?operation_bundle ?regulatory_permit)
        (not
          (bundle_permit_claimed ?operation_bundle)
        )
      )
    :effect
      (and
        (bundle_permit_claimed ?operation_bundle)
        (not
          (permit_available ?regulatory_permit)
        )
      )
  )
  (:action verify_equipment_for_permitted_bundle
    :parameters (?operation_bundle - operation_bundle ?equipment_unit - equipment_unit)
    :precondition
      (and
        (bundle_permit_claimed ?operation_bundle)
        (unit_has_equipment ?operation_bundle ?equipment_unit)
        (not
          (bundle_equipment_verified ?operation_bundle)
        )
      )
    :effect (bundle_equipment_verified ?operation_bundle)
  )
  (:action attach_method_after_permit
    :parameters (?operation_bundle - operation_bundle ?application_method - application_method)
    :precondition
      (and
        (bundle_equipment_verified ?operation_bundle)
        (bundle_has_application_method ?operation_bundle ?application_method)
        (not
          (bundle_method_verified ?operation_bundle)
        )
      )
    :effect (bundle_method_verified ?operation_bundle)
  )
  (:action finalize_bundle_with_permit
    :parameters (?operation_bundle - operation_bundle)
    :precondition
      (and
        (bundle_method_verified ?operation_bundle)
        (not
          (bundle_finalized ?operation_bundle)
        )
      )
    :effect
      (and
        (bundle_finalized ?operation_bundle)
        (completed ?operation_bundle)
      )
  )
  (:action complete_primary_crew_task
    :parameters (?primary_crew - primary_crew ?work_package - work_package)
    :precondition
      (and
        (primary_crew_locked ?primary_crew)
        (primary_crew_ready ?primary_crew)
        (work_package_ready ?work_package)
        (work_package_claimed_for_processing ?work_package)
        (not
          (completed ?primary_crew)
        )
      )
    :effect (completed ?primary_crew)
  )
  (:action complete_secondary_crew_task
    :parameters (?secondary_crew - secondary_crew ?work_package - work_package)
    :precondition
      (and
        (secondary_crew_locked ?secondary_crew)
        (secondary_crew_ready ?secondary_crew)
        (work_package_ready ?work_package)
        (work_package_claimed_for_processing ?work_package)
        (not
          (completed ?secondary_crew)
        )
      )
    :effect (completed ?secondary_crew)
  )
  (:action allocate_labor_slot_to_unit
    :parameters (?management_unit - management_unit ?labor_slot - labor_slot ?operation_type - operation_type)
    :precondition
      (and
        (completed ?management_unit)
        (unit_operation_reserved ?management_unit ?operation_type)
        (labor_slot_available ?labor_slot)
        (not
          (labor_assigned ?management_unit)
        )
      )
    :effect
      (and
        (labor_assigned ?management_unit)
        (has_labor_slot ?management_unit ?labor_slot)
        (not
          (labor_slot_available ?labor_slot)
        )
      )
  )
  (:action close_assignment_for_primary_crew
    :parameters (?primary_crew - primary_crew ?crew_availability_token - crew_availability_token ?labor_slot - labor_slot)
    :precondition
      (and
        (labor_assigned ?primary_crew)
        (has_availability_token ?primary_crew ?crew_availability_token)
        (has_labor_slot ?primary_crew ?labor_slot)
        (not
          (assignment_closed ?primary_crew)
        )
      )
    :effect
      (and
        (assignment_closed ?primary_crew)
        (availability_token_active ?crew_availability_token)
        (labor_slot_available ?labor_slot)
      )
  )
  (:action close_assignment_for_secondary_crew
    :parameters (?secondary_crew - secondary_crew ?crew_availability_token - crew_availability_token ?labor_slot - labor_slot)
    :precondition
      (and
        (labor_assigned ?secondary_crew)
        (has_availability_token ?secondary_crew ?crew_availability_token)
        (has_labor_slot ?secondary_crew ?labor_slot)
        (not
          (assignment_closed ?secondary_crew)
        )
      )
    :effect
      (and
        (assignment_closed ?secondary_crew)
        (availability_token_active ?crew_availability_token)
        (labor_slot_available ?labor_slot)
      )
  )
  (:action close_assignment_for_bundle
    :parameters (?operation_bundle - operation_bundle ?crew_availability_token - crew_availability_token ?labor_slot - labor_slot)
    :precondition
      (and
        (labor_assigned ?operation_bundle)
        (has_availability_token ?operation_bundle ?crew_availability_token)
        (has_labor_slot ?operation_bundle ?labor_slot)
        (not
          (assignment_closed ?operation_bundle)
        )
      )
    :effect
      (and
        (assignment_closed ?operation_bundle)
        (availability_token_active ?crew_availability_token)
        (labor_slot_available ?labor_slot)
      )
  )
)

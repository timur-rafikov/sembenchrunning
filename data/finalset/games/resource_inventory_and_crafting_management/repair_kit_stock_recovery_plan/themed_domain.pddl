(define (domain repair_kit_stock_recovery_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object material_category - object facility_component_category - object asset_category - object facility_asset - asset_category supplier_unit - resource_category part_type - resource_category technician - resource_category label_token - resource_category priority_tag - resource_category preservative_cell - resource_category calibration_module - resource_category inspection_document - resource_category consumable_part - material_category component_batch - material_category access_code - material_category depot_bay - facility_component_category field_bay - facility_component_category repair_kit_unit - facility_component_category depot_role - facility_asset field_role - facility_asset depot - depot_role field_team - depot_role workshop - field_role)
  (:predicates
    (asset_registered ?asset - facility_asset)
    (asset_accepted ?asset - facility_asset)
    (asset_supplier_reserved ?asset - facility_asset)
    (asset_restocked ?asset - facility_asset)
    (asset_ready_for_finalization ?asset - facility_asset)
    (asset_preservative_applied ?asset - facility_asset)
    (supplier_available ?supplier_unit - supplier_unit)
    (asset_has_supplier ?asset - facility_asset ?supplier_unit - supplier_unit)
    (part_available ?part_type - part_type)
    (asset_part_allocated ?asset - facility_asset ?part_type - part_type)
    (technician_available ?technician - technician)
    (asset_has_technician ?asset - facility_asset ?technician - technician)
    (consumable_available ?consumable_part - consumable_part)
    (depot_consumable_reserved ?depot - depot ?consumable_part - consumable_part)
    (field_consumable_reserved ?field_team - field_team ?consumable_part - consumable_part)
    (depot_has_bay ?depot - depot ?depot_bay - depot_bay)
    (depot_bay_prepared ?depot_bay - depot_bay)
    (depot_bay_consumable_reserved ?depot_bay - depot_bay)
    (depot_staging_confirmed ?depot - depot)
    (field_has_bay ?field_team - field_team ?field_bay - field_bay)
    (field_bay_prepared ?field_bay - field_bay)
    (field_bay_consumable_reserved ?field_bay - field_bay)
    (field_staging_confirmed ?field_team - field_team)
    (kit_unconfigured ?repair_kit_unit - repair_kit_unit)
    (kit_marked_for_assembly ?repair_kit_unit - repair_kit_unit)
    (kit_staged_in_depot_bay ?repair_kit_unit - repair_kit_unit ?depot_bay - depot_bay)
    (kit_staged_in_field_bay ?repair_kit_unit - repair_kit_unit ?field_bay - field_bay)
    (kit_depot_slot_flag ?repair_kit_unit - repair_kit_unit)
    (kit_field_slot_flag ?repair_kit_unit - repair_kit_unit)
    (kit_qc_ready ?repair_kit_unit - repair_kit_unit)
    (workshop_depot_link ?workshop - workshop ?depot - depot)
    (workshop_field_link ?workshop - workshop ?field_team - field_team)
    (workshop_can_assemble_kit ?workshop - workshop ?repair_kit_unit - repair_kit_unit)
    (batch_available ?component_batch - component_batch)
    (workshop_has_batch ?workshop - workshop ?component_batch - component_batch)
    (batch_intake_committed ?component_batch - component_batch)
    (batch_bound_to_kit ?component_batch - component_batch ?repair_kit_unit - repair_kit_unit)
    (workshop_intake_complete ?workshop - workshop)
    (workshop_binding_complete ?workshop - workshop)
    (workshop_certified ?workshop - workshop)
    (workshop_label_attached ?workshop - workshop)
    (workshop_label_verified ?workshop - workshop)
    (workshop_priority_tagged ?workshop - workshop)
    (workshop_final_checks_passed ?workshop - workshop)
    (access_code_available ?access_code - access_code)
    (workshop_has_access_code ?workshop - workshop ?access_code - access_code)
    (workshop_authorized ?workshop - workshop)
    (workshop_authorization_verified ?workshop - workshop)
    (workshop_inspection_assigned ?workshop - workshop)
    (label_available ?label_token - label_token)
    (workshop_has_label ?workshop - workshop ?label_token - label_token)
    (priority_tag_available ?priority_tag - priority_tag)
    (workshop_priority_attached ?workshop - workshop ?priority_tag - priority_tag)
    (calibration_module_available ?calibration_module - calibration_module)
    (workshop_calibration_bound ?workshop - workshop ?calibration_module - calibration_module)
    (inspection_document_available ?inspection_document - inspection_document)
    (workshop_inspection_bound ?workshop - workshop ?inspection_document - inspection_document)
    (preservative_available ?preservative_cell - preservative_cell)
    (asset_preservative_bound ?asset - facility_asset ?preservative_cell - preservative_cell)
    (depot_hold_active ?depot - depot)
    (field_hold_active ?field_team - field_team)
    (workshop_marked_ready ?workshop - workshop)
  )
  (:action register_asset
    :parameters (?asset - facility_asset)
    :precondition
      (and
        (not
          (asset_registered ?asset)
        )
        (not
          (asset_restocked ?asset)
        )
      )
    :effect (asset_registered ?asset)
  )
  (:action reserve_supplier_for_asset
    :parameters (?asset - facility_asset ?supplier_unit - supplier_unit)
    :precondition
      (and
        (asset_registered ?asset)
        (not
          (asset_supplier_reserved ?asset)
        )
        (supplier_available ?supplier_unit)
      )
    :effect
      (and
        (asset_supplier_reserved ?asset)
        (asset_has_supplier ?asset ?supplier_unit)
        (not
          (supplier_available ?supplier_unit)
        )
      )
  )
  (:action allocate_part_to_asset
    :parameters (?asset - facility_asset ?part_type - part_type)
    :precondition
      (and
        (asset_registered ?asset)
        (asset_supplier_reserved ?asset)
        (part_available ?part_type)
      )
    :effect
      (and
        (asset_part_allocated ?asset ?part_type)
        (not
          (part_available ?part_type)
        )
      )
  )
  (:action confirm_part_allocation
    :parameters (?asset - facility_asset ?part_type - part_type)
    :precondition
      (and
        (asset_registered ?asset)
        (asset_supplier_reserved ?asset)
        (asset_part_allocated ?asset ?part_type)
        (not
          (asset_accepted ?asset)
        )
      )
    :effect (asset_accepted ?asset)
  )
  (:action release_allocated_part
    :parameters (?asset - facility_asset ?part_type - part_type)
    :precondition
      (and
        (asset_part_allocated ?asset ?part_type)
      )
    :effect
      (and
        (part_available ?part_type)
        (not
          (asset_part_allocated ?asset ?part_type)
        )
      )
  )
  (:action assign_technician_to_asset
    :parameters (?asset - facility_asset ?technician - technician)
    :precondition
      (and
        (asset_accepted ?asset)
        (technician_available ?technician)
      )
    :effect
      (and
        (asset_has_technician ?asset ?technician)
        (not
          (technician_available ?technician)
        )
      )
  )
  (:action unassign_technician_from_asset
    :parameters (?asset - facility_asset ?technician - technician)
    :precondition
      (and
        (asset_has_technician ?asset ?technician)
      )
    :effect
      (and
        (technician_available ?technician)
        (not
          (asset_has_technician ?asset ?technician)
        )
      )
  )
  (:action bind_calibration_module_to_workshop
    :parameters (?workshop - workshop ?calibration_module - calibration_module)
    :precondition
      (and
        (asset_accepted ?workshop)
        (calibration_module_available ?calibration_module)
      )
    :effect
      (and
        (workshop_calibration_bound ?workshop ?calibration_module)
        (not
          (calibration_module_available ?calibration_module)
        )
      )
  )
  (:action release_calibration_module_from_workshop
    :parameters (?workshop - workshop ?calibration_module - calibration_module)
    :precondition
      (and
        (workshop_calibration_bound ?workshop ?calibration_module)
      )
    :effect
      (and
        (calibration_module_available ?calibration_module)
        (not
          (workshop_calibration_bound ?workshop ?calibration_module)
        )
      )
  )
  (:action bind_inspection_document_to_workshop
    :parameters (?workshop - workshop ?inspection_document - inspection_document)
    :precondition
      (and
        (asset_accepted ?workshop)
        (inspection_document_available ?inspection_document)
      )
    :effect
      (and
        (workshop_inspection_bound ?workshop ?inspection_document)
        (not
          (inspection_document_available ?inspection_document)
        )
      )
  )
  (:action release_inspection_document_from_workshop
    :parameters (?workshop - workshop ?inspection_document - inspection_document)
    :precondition
      (and
        (workshop_inspection_bound ?workshop ?inspection_document)
      )
    :effect
      (and
        (inspection_document_available ?inspection_document)
        (not
          (workshop_inspection_bound ?workshop ?inspection_document)
        )
      )
  )
  (:action prepare_depot_bay
    :parameters (?depot - depot ?depot_bay - depot_bay ?part_type - part_type)
    :precondition
      (and
        (asset_accepted ?depot)
        (asset_part_allocated ?depot ?part_type)
        (depot_has_bay ?depot ?depot_bay)
        (not
          (depot_bay_prepared ?depot_bay)
        )
        (not
          (depot_bay_consumable_reserved ?depot_bay)
        )
      )
    :effect (depot_bay_prepared ?depot_bay)
  )
  (:action confirm_depot_staging
    :parameters (?depot - depot ?depot_bay - depot_bay ?technician - technician)
    :precondition
      (and
        (asset_accepted ?depot)
        (asset_has_technician ?depot ?technician)
        (depot_has_bay ?depot ?depot_bay)
        (depot_bay_prepared ?depot_bay)
        (not
          (depot_hold_active ?depot)
        )
      )
    :effect
      (and
        (depot_hold_active ?depot)
        (depot_staging_confirmed ?depot)
      )
  )
  (:action reserve_consumable_for_depot_bay
    :parameters (?depot - depot ?depot_bay - depot_bay ?consumable_part - consumable_part)
    :precondition
      (and
        (asset_accepted ?depot)
        (depot_has_bay ?depot ?depot_bay)
        (consumable_available ?consumable_part)
        (not
          (depot_hold_active ?depot)
        )
      )
    :effect
      (and
        (depot_bay_consumable_reserved ?depot_bay)
        (depot_hold_active ?depot)
        (depot_consumable_reserved ?depot ?consumable_part)
        (not
          (consumable_available ?consumable_part)
        )
      )
  )
  (:action finalize_depot_bay_preparation
    :parameters (?depot - depot ?depot_bay - depot_bay ?part_type - part_type ?consumable_part - consumable_part)
    :precondition
      (and
        (asset_accepted ?depot)
        (asset_part_allocated ?depot ?part_type)
        (depot_has_bay ?depot ?depot_bay)
        (depot_bay_consumable_reserved ?depot_bay)
        (depot_consumable_reserved ?depot ?consumable_part)
        (not
          (depot_staging_confirmed ?depot)
        )
      )
    :effect
      (and
        (depot_bay_prepared ?depot_bay)
        (depot_staging_confirmed ?depot)
        (consumable_available ?consumable_part)
        (not
          (depot_consumable_reserved ?depot ?consumable_part)
        )
      )
  )
  (:action prepare_field_bay
    :parameters (?field_team - field_team ?field_bay - field_bay ?part_type - part_type)
    :precondition
      (and
        (asset_accepted ?field_team)
        (asset_part_allocated ?field_team ?part_type)
        (field_has_bay ?field_team ?field_bay)
        (not
          (field_bay_prepared ?field_bay)
        )
        (not
          (field_bay_consumable_reserved ?field_bay)
        )
      )
    :effect (field_bay_prepared ?field_bay)
  )
  (:action confirm_field_staging
    :parameters (?field_team - field_team ?field_bay - field_bay ?technician - technician)
    :precondition
      (and
        (asset_accepted ?field_team)
        (asset_has_technician ?field_team ?technician)
        (field_has_bay ?field_team ?field_bay)
        (field_bay_prepared ?field_bay)
        (not
          (field_hold_active ?field_team)
        )
      )
    :effect
      (and
        (field_hold_active ?field_team)
        (field_staging_confirmed ?field_team)
      )
  )
  (:action reserve_consumable_for_field_bay
    :parameters (?field_team - field_team ?field_bay - field_bay ?consumable_part - consumable_part)
    :precondition
      (and
        (asset_accepted ?field_team)
        (field_has_bay ?field_team ?field_bay)
        (consumable_available ?consumable_part)
        (not
          (field_hold_active ?field_team)
        )
      )
    :effect
      (and
        (field_bay_consumable_reserved ?field_bay)
        (field_hold_active ?field_team)
        (field_consumable_reserved ?field_team ?consumable_part)
        (not
          (consumable_available ?consumable_part)
        )
      )
  )
  (:action finalize_field_bay_preparation
    :parameters (?field_team - field_team ?field_bay - field_bay ?part_type - part_type ?consumable_part - consumable_part)
    :precondition
      (and
        (asset_accepted ?field_team)
        (asset_part_allocated ?field_team ?part_type)
        (field_has_bay ?field_team ?field_bay)
        (field_bay_consumable_reserved ?field_bay)
        (field_consumable_reserved ?field_team ?consumable_part)
        (not
          (field_staging_confirmed ?field_team)
        )
      )
    :effect
      (and
        (field_bay_prepared ?field_bay)
        (field_staging_confirmed ?field_team)
        (consumable_available ?consumable_part)
        (not
          (field_consumable_reserved ?field_team ?consumable_part)
        )
      )
  )
  (:action initialize_kit_assembly
    :parameters (?depot - depot ?field_team - field_team ?depot_bay - depot_bay ?field_bay - field_bay ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (depot_hold_active ?depot)
        (field_hold_active ?field_team)
        (depot_has_bay ?depot ?depot_bay)
        (field_has_bay ?field_team ?field_bay)
        (depot_bay_prepared ?depot_bay)
        (field_bay_prepared ?field_bay)
        (depot_staging_confirmed ?depot)
        (field_staging_confirmed ?field_team)
        (kit_unconfigured ?repair_kit_unit)
      )
    :effect
      (and
        (kit_marked_for_assembly ?repair_kit_unit)
        (kit_staged_in_depot_bay ?repair_kit_unit ?depot_bay)
        (kit_staged_in_field_bay ?repair_kit_unit ?field_bay)
        (not
          (kit_unconfigured ?repair_kit_unit)
        )
      )
  )
  (:action initialize_kit_with_depot_slot
    :parameters (?depot - depot ?field_team - field_team ?depot_bay - depot_bay ?field_bay - field_bay ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (depot_hold_active ?depot)
        (field_hold_active ?field_team)
        (depot_has_bay ?depot ?depot_bay)
        (field_has_bay ?field_team ?field_bay)
        (depot_bay_consumable_reserved ?depot_bay)
        (field_bay_prepared ?field_bay)
        (not
          (depot_staging_confirmed ?depot)
        )
        (field_staging_confirmed ?field_team)
        (kit_unconfigured ?repair_kit_unit)
      )
    :effect
      (and
        (kit_marked_for_assembly ?repair_kit_unit)
        (kit_staged_in_depot_bay ?repair_kit_unit ?depot_bay)
        (kit_staged_in_field_bay ?repair_kit_unit ?field_bay)
        (kit_depot_slot_flag ?repair_kit_unit)
        (not
          (kit_unconfigured ?repair_kit_unit)
        )
      )
  )
  (:action initialize_kit_with_field_slot
    :parameters (?depot - depot ?field_team - field_team ?depot_bay - depot_bay ?field_bay - field_bay ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (depot_hold_active ?depot)
        (field_hold_active ?field_team)
        (depot_has_bay ?depot ?depot_bay)
        (field_has_bay ?field_team ?field_bay)
        (depot_bay_prepared ?depot_bay)
        (field_bay_consumable_reserved ?field_bay)
        (depot_staging_confirmed ?depot)
        (not
          (field_staging_confirmed ?field_team)
        )
        (kit_unconfigured ?repair_kit_unit)
      )
    :effect
      (and
        (kit_marked_for_assembly ?repair_kit_unit)
        (kit_staged_in_depot_bay ?repair_kit_unit ?depot_bay)
        (kit_staged_in_field_bay ?repair_kit_unit ?field_bay)
        (kit_field_slot_flag ?repair_kit_unit)
        (not
          (kit_unconfigured ?repair_kit_unit)
        )
      )
  )
  (:action initialize_kit_with_depot_and_field_slots
    :parameters (?depot - depot ?field_team - field_team ?depot_bay - depot_bay ?field_bay - field_bay ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (depot_hold_active ?depot)
        (field_hold_active ?field_team)
        (depot_has_bay ?depot ?depot_bay)
        (field_has_bay ?field_team ?field_bay)
        (depot_bay_consumable_reserved ?depot_bay)
        (field_bay_consumable_reserved ?field_bay)
        (not
          (depot_staging_confirmed ?depot)
        )
        (not
          (field_staging_confirmed ?field_team)
        )
        (kit_unconfigured ?repair_kit_unit)
      )
    :effect
      (and
        (kit_marked_for_assembly ?repair_kit_unit)
        (kit_staged_in_depot_bay ?repair_kit_unit ?depot_bay)
        (kit_staged_in_field_bay ?repair_kit_unit ?field_bay)
        (kit_depot_slot_flag ?repair_kit_unit)
        (kit_field_slot_flag ?repair_kit_unit)
        (not
          (kit_unconfigured ?repair_kit_unit)
        )
      )
  )
  (:action mark_kit_qc_ready
    :parameters (?repair_kit_unit - repair_kit_unit ?depot - depot ?part_type - part_type)
    :precondition
      (and
        (kit_marked_for_assembly ?repair_kit_unit)
        (depot_hold_active ?depot)
        (asset_part_allocated ?depot ?part_type)
        (not
          (kit_qc_ready ?repair_kit_unit)
        )
      )
    :effect (kit_qc_ready ?repair_kit_unit)
  )
  (:action workshop_bind_batch_to_kit
    :parameters (?workshop - workshop ?component_batch - component_batch ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (asset_accepted ?workshop)
        (workshop_can_assemble_kit ?workshop ?repair_kit_unit)
        (workshop_has_batch ?workshop ?component_batch)
        (batch_available ?component_batch)
        (kit_marked_for_assembly ?repair_kit_unit)
        (kit_qc_ready ?repair_kit_unit)
        (not
          (batch_intake_committed ?component_batch)
        )
      )
    :effect
      (and
        (batch_intake_committed ?component_batch)
        (batch_bound_to_kit ?component_batch ?repair_kit_unit)
        (not
          (batch_available ?component_batch)
        )
      )
  )
  (:action process_batch_in_workshop
    :parameters (?workshop - workshop ?component_batch - component_batch ?repair_kit_unit - repair_kit_unit ?part_type - part_type)
    :precondition
      (and
        (asset_accepted ?workshop)
        (workshop_has_batch ?workshop ?component_batch)
        (batch_intake_committed ?component_batch)
        (batch_bound_to_kit ?component_batch ?repair_kit_unit)
        (asset_part_allocated ?workshop ?part_type)
        (not
          (kit_depot_slot_flag ?repair_kit_unit)
        )
        (not
          (workshop_intake_complete ?workshop)
        )
      )
    :effect (workshop_intake_complete ?workshop)
  )
  (:action attach_label_to_workshop
    :parameters (?workshop - workshop ?label_token - label_token)
    :precondition
      (and
        (asset_accepted ?workshop)
        (label_available ?label_token)
        (not
          (workshop_label_attached ?workshop)
        )
      )
    :effect
      (and
        (workshop_label_attached ?workshop)
        (workshop_has_label ?workshop ?label_token)
        (not
          (label_available ?label_token)
        )
      )
  )
  (:action apply_label_and_verify
    :parameters (?workshop - workshop ?component_batch - component_batch ?repair_kit_unit - repair_kit_unit ?part_type - part_type ?label_token - label_token)
    :precondition
      (and
        (asset_accepted ?workshop)
        (workshop_has_batch ?workshop ?component_batch)
        (batch_intake_committed ?component_batch)
        (batch_bound_to_kit ?component_batch ?repair_kit_unit)
        (asset_part_allocated ?workshop ?part_type)
        (kit_depot_slot_flag ?repair_kit_unit)
        (workshop_label_attached ?workshop)
        (workshop_has_label ?workshop ?label_token)
        (not
          (workshop_intake_complete ?workshop)
        )
      )
    :effect
      (and
        (workshop_intake_complete ?workshop)
        (workshop_label_verified ?workshop)
      )
  )
  (:action apply_calibration_and_bind_components
    :parameters (?workshop - workshop ?calibration_module - calibration_module ?technician - technician ?component_batch - component_batch ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (workshop_intake_complete ?workshop)
        (workshop_calibration_bound ?workshop ?calibration_module)
        (asset_has_technician ?workshop ?technician)
        (workshop_has_batch ?workshop ?component_batch)
        (batch_bound_to_kit ?component_batch ?repair_kit_unit)
        (not
          (kit_field_slot_flag ?repair_kit_unit)
        )
        (not
          (workshop_binding_complete ?workshop)
        )
      )
    :effect (workshop_binding_complete ?workshop)
  )
  (:action apply_calibration_and_finalize_binding
    :parameters (?workshop - workshop ?calibration_module - calibration_module ?technician - technician ?component_batch - component_batch ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (workshop_intake_complete ?workshop)
        (workshop_calibration_bound ?workshop ?calibration_module)
        (asset_has_technician ?workshop ?technician)
        (workshop_has_batch ?workshop ?component_batch)
        (batch_bound_to_kit ?component_batch ?repair_kit_unit)
        (kit_field_slot_flag ?repair_kit_unit)
        (not
          (workshop_binding_complete ?workshop)
        )
      )
    :effect (workshop_binding_complete ?workshop)
  )
  (:action certify_workshop_after_inspection
    :parameters (?workshop - workshop ?inspection_document - inspection_document ?component_batch - component_batch ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (workshop_binding_complete ?workshop)
        (workshop_inspection_bound ?workshop ?inspection_document)
        (workshop_has_batch ?workshop ?component_batch)
        (batch_bound_to_kit ?component_batch ?repair_kit_unit)
        (not
          (kit_depot_slot_flag ?repair_kit_unit)
        )
        (not
          (kit_field_slot_flag ?repair_kit_unit)
        )
        (not
          (workshop_certified ?workshop)
        )
      )
    :effect (workshop_certified ?workshop)
  )
  (:action certify_and_apply_priority_tag
    :parameters (?workshop - workshop ?inspection_document - inspection_document ?component_batch - component_batch ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (workshop_binding_complete ?workshop)
        (workshop_inspection_bound ?workshop ?inspection_document)
        (workshop_has_batch ?workshop ?component_batch)
        (batch_bound_to_kit ?component_batch ?repair_kit_unit)
        (kit_depot_slot_flag ?repair_kit_unit)
        (not
          (kit_field_slot_flag ?repair_kit_unit)
        )
        (not
          (workshop_certified ?workshop)
        )
      )
    :effect
      (and
        (workshop_certified ?workshop)
        (workshop_priority_tagged ?workshop)
      )
  )
  (:action certify_and_apply_priority_tag_variant
    :parameters (?workshop - workshop ?inspection_document - inspection_document ?component_batch - component_batch ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (workshop_binding_complete ?workshop)
        (workshop_inspection_bound ?workshop ?inspection_document)
        (workshop_has_batch ?workshop ?component_batch)
        (batch_bound_to_kit ?component_batch ?repair_kit_unit)
        (not
          (kit_depot_slot_flag ?repair_kit_unit)
        )
        (kit_field_slot_flag ?repair_kit_unit)
        (not
          (workshop_certified ?workshop)
        )
      )
    :effect
      (and
        (workshop_certified ?workshop)
        (workshop_priority_tagged ?workshop)
      )
  )
  (:action certify_and_apply_priority_tag_full
    :parameters (?workshop - workshop ?inspection_document - inspection_document ?component_batch - component_batch ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (workshop_binding_complete ?workshop)
        (workshop_inspection_bound ?workshop ?inspection_document)
        (workshop_has_batch ?workshop ?component_batch)
        (batch_bound_to_kit ?component_batch ?repair_kit_unit)
        (kit_depot_slot_flag ?repair_kit_unit)
        (kit_field_slot_flag ?repair_kit_unit)
        (not
          (workshop_certified ?workshop)
        )
      )
    :effect
      (and
        (workshop_certified ?workshop)
        (workshop_priority_tagged ?workshop)
      )
  )
  (:action mark_workshop_ready
    :parameters (?workshop - workshop)
    :precondition
      (and
        (workshop_certified ?workshop)
        (not
          (workshop_priority_tagged ?workshop)
        )
        (not
          (workshop_marked_ready ?workshop)
        )
      )
    :effect
      (and
        (workshop_marked_ready ?workshop)
        (asset_ready_for_finalization ?workshop)
      )
  )
  (:action attach_priority_tag_to_workshop
    :parameters (?workshop - workshop ?priority_tag - priority_tag)
    :precondition
      (and
        (workshop_certified ?workshop)
        (workshop_priority_tagged ?workshop)
        (priority_tag_available ?priority_tag)
      )
    :effect
      (and
        (workshop_priority_attached ?workshop ?priority_tag)
        (not
          (priority_tag_available ?priority_tag)
        )
      )
  )
  (:action complete_workshop_final_checks
    :parameters (?workshop - workshop ?depot - depot ?field_team - field_team ?part_type - part_type ?priority_tag - priority_tag)
    :precondition
      (and
        (workshop_certified ?workshop)
        (workshop_priority_tagged ?workshop)
        (workshop_priority_attached ?workshop ?priority_tag)
        (workshop_depot_link ?workshop ?depot)
        (workshop_field_link ?workshop ?field_team)
        (depot_staging_confirmed ?depot)
        (field_staging_confirmed ?field_team)
        (asset_part_allocated ?workshop ?part_type)
        (not
          (workshop_final_checks_passed ?workshop)
        )
      )
    :effect (workshop_final_checks_passed ?workshop)
  )
  (:action finalize_workshop_and_mark_ready
    :parameters (?workshop - workshop)
    :precondition
      (and
        (workshop_certified ?workshop)
        (workshop_final_checks_passed ?workshop)
        (not
          (workshop_marked_ready ?workshop)
        )
      )
    :effect
      (and
        (workshop_marked_ready ?workshop)
        (asset_ready_for_finalization ?workshop)
      )
  )
  (:action authorize_workshop_with_access_code
    :parameters (?workshop - workshop ?access_code - access_code ?part_type - part_type)
    :precondition
      (and
        (asset_accepted ?workshop)
        (asset_part_allocated ?workshop ?part_type)
        (access_code_available ?access_code)
        (workshop_has_access_code ?workshop ?access_code)
        (not
          (workshop_authorized ?workshop)
        )
      )
    :effect
      (and
        (workshop_authorized ?workshop)
        (not
          (access_code_available ?access_code)
        )
      )
  )
  (:action verify_access_code
    :parameters (?workshop - workshop ?technician - technician)
    :precondition
      (and
        (workshop_authorized ?workshop)
        (asset_has_technician ?workshop ?technician)
        (not
          (workshop_authorization_verified ?workshop)
        )
      )
    :effect (workshop_authorization_verified ?workshop)
  )
  (:action assign_inspection_to_workshop
    :parameters (?workshop - workshop ?inspection_document - inspection_document)
    :precondition
      (and
        (workshop_authorization_verified ?workshop)
        (workshop_inspection_bound ?workshop ?inspection_document)
        (not
          (workshop_inspection_assigned ?workshop)
        )
      )
    :effect (workshop_inspection_assigned ?workshop)
  )
  (:action finalize_workshop_after_inspection
    :parameters (?workshop - workshop)
    :precondition
      (and
        (workshop_inspection_assigned ?workshop)
        (not
          (workshop_marked_ready ?workshop)
        )
      )
    :effect
      (and
        (workshop_marked_ready ?workshop)
        (asset_ready_for_finalization ?workshop)
      )
  )
  (:action mark_depot_ready_for_finalization
    :parameters (?depot - depot ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (depot_hold_active ?depot)
        (depot_staging_confirmed ?depot)
        (kit_marked_for_assembly ?repair_kit_unit)
        (kit_qc_ready ?repair_kit_unit)
        (not
          (asset_ready_for_finalization ?depot)
        )
      )
    :effect (asset_ready_for_finalization ?depot)
  )
  (:action mark_field_ready_for_finalization
    :parameters (?field_team - field_team ?repair_kit_unit - repair_kit_unit)
    :precondition
      (and
        (field_hold_active ?field_team)
        (field_staging_confirmed ?field_team)
        (kit_marked_for_assembly ?repair_kit_unit)
        (kit_qc_ready ?repair_kit_unit)
        (not
          (asset_ready_for_finalization ?field_team)
        )
      )
    :effect (asset_ready_for_finalization ?field_team)
  )
  (:action apply_preservative_to_asset
    :parameters (?asset - facility_asset ?preservative_cell - preservative_cell ?part_type - part_type)
    :precondition
      (and
        (asset_ready_for_finalization ?asset)
        (asset_part_allocated ?asset ?part_type)
        (preservative_available ?preservative_cell)
        (not
          (asset_preservative_applied ?asset)
        )
      )
    :effect
      (and
        (asset_preservative_applied ?asset)
        (asset_preservative_bound ?asset ?preservative_cell)
        (not
          (preservative_available ?preservative_cell)
        )
      )
  )
  (:action finalize_depot_restock_and_release_resources
    :parameters (?depot - depot ?supplier_unit - supplier_unit ?preservative_cell - preservative_cell)
    :precondition
      (and
        (asset_preservative_applied ?depot)
        (asset_has_supplier ?depot ?supplier_unit)
        (asset_preservative_bound ?depot ?preservative_cell)
        (not
          (asset_restocked ?depot)
        )
      )
    :effect
      (and
        (asset_restocked ?depot)
        (supplier_available ?supplier_unit)
        (preservative_available ?preservative_cell)
      )
  )
  (:action finalize_field_restock_and_release_resources
    :parameters (?field_team - field_team ?supplier_unit - supplier_unit ?preservative_cell - preservative_cell)
    :precondition
      (and
        (asset_preservative_applied ?field_team)
        (asset_has_supplier ?field_team ?supplier_unit)
        (asset_preservative_bound ?field_team ?preservative_cell)
        (not
          (asset_restocked ?field_team)
        )
      )
    :effect
      (and
        (asset_restocked ?field_team)
        (supplier_available ?supplier_unit)
        (preservative_available ?preservative_cell)
      )
  )
  (:action finalize_workshop_restock_and_release_resources
    :parameters (?workshop - workshop ?supplier_unit - supplier_unit ?preservative_cell - preservative_cell)
    :precondition
      (and
        (asset_preservative_applied ?workshop)
        (asset_has_supplier ?workshop ?supplier_unit)
        (asset_preservative_bound ?workshop ?preservative_cell)
        (not
          (asset_restocked ?workshop)
        )
      )
    :effect
      (and
        (asset_restocked ?workshop)
        (supplier_available ?supplier_unit)
        (preservative_available ?preservative_cell)
      )
  )
)

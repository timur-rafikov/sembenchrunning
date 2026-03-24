(define (domain packaging_line_batch_slot_allocation)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object resource_subcategory - object equipment_category - object abstract_entity_type - object processable_entity - abstract_entity_type line_slot - resource_category product_variant - resource_category equipment_unit - resource_category label_set - resource_category document_template - resource_category release_document - resource_category component_batch - resource_category qa_approval_record - resource_category material_kit - resource_subcategory inspection_tool - resource_subcategory quality_hold_tag - resource_subcategory equipment_position - equipment_category station_position - equipment_category packaging_run_record - equipment_category batch_subtype - processable_entity line_subtype - processable_entity primary_batch - batch_subtype secondary_batch - batch_subtype packaging_line - line_subtype)
  (:predicates
    (batch_record_registered ?processable_entity - processable_entity)
    (entity_staged ?processable_entity - processable_entity)
    (slot_booking_confirmed ?processable_entity - processable_entity)
    (resource_allocated_or_locked ?processable_entity - processable_entity)
    (execution_readiness_flag ?processable_entity - processable_entity)
    (documentation_attached ?processable_entity - processable_entity)
    (slot_available ?line_slot - line_slot)
    (batch_assigned_to_slot ?processable_entity - processable_entity ?line_slot - line_slot)
    (operator_available_for_product_variant ?product_variant_var - product_variant)
    (batch_assigned_product_variant ?processable_entity - processable_entity ?product_variant_var - product_variant)
    (equipment_unit_available ?operator - equipment_unit)
    (equipment_allocated_to_entity ?processable_entity - processable_entity ?operator - equipment_unit)
    (material_kit_available ?material_kit - material_kit)
    (material_assigned_to_line ?primary_batch_var - primary_batch ?material_kit - material_kit)
    (material_assigned_to_station ?secondary_batch_var - secondary_batch ?material_kit - material_kit)
    (slot_equipment_link ?primary_batch_var - primary_batch ?equipment_position - equipment_position)
    (equipment_staged ?equipment_position - equipment_position)
    (equipment_validated ?equipment_position - equipment_position)
    (slot_verified ?primary_batch_var - primary_batch)
    (station_equipment_link ?secondary_batch_var - secondary_batch ?station_position - station_position)
    (station_staged ?station_position - station_position)
    (station_validated ?station_position - station_position)
    (station_verified ?secondary_batch_var - secondary_batch)
    (run_token_available ?packaging_run_record - packaging_run_record)
    (run_token_reserved ?packaging_run_record - packaging_run_record)
    (run_assigned_to_equipment ?packaging_run_record - packaging_run_record ?equipment_position - equipment_position)
    (run_assigned_to_station ?packaging_run_record - packaging_run_record ?station_position - station_position)
    (run_quality_flag_pending ?packaging_run_record - packaging_run_record)
    (run_label_flag_pending ?packaging_run_record - packaging_run_record)
    (run_confirmed_for_execution ?packaging_run_record - packaging_run_record)
    (line_supports_primary_batch ?packaging_line - packaging_line ?primary_batch_var - primary_batch)
    (line_supports_secondary_batch ?packaging_line - packaging_line ?secondary_batch_var - secondary_batch)
    (line_linked_to_run_record ?packaging_line - packaging_line ?packaging_run_record - packaging_run_record)
    (inspection_tool_available ?inspection_tool - inspection_tool)
    (line_has_inspection_tool ?packaging_line - packaging_line ?inspection_tool - inspection_tool)
    (inspection_tool_in_use ?inspection_tool - inspection_tool)
    (inspection_tool_linked_to_run ?inspection_tool - inspection_tool ?packaging_run_record - packaging_run_record)
    (line_packaging_prepared ?packaging_line - packaging_line)
    (line_execution_authorized ?packaging_line - packaging_line)
    (packaging_checks_complete ?packaging_line - packaging_line)
    (label_set_assigned ?packaging_line - packaging_line)
    (label_set_applied ?packaging_line - packaging_line)
    (additional_checks_passed ?packaging_line - packaging_line)
    (final_packaging_ready ?packaging_line - packaging_line)
    (special_hold_present ?quality_hold_tag - quality_hold_tag)
    (line_hold_association ?packaging_line - packaging_line ?quality_hold_tag - quality_hold_tag)
    (hold_acknowledged ?packaging_line - packaging_line)
    (hold_cleared_step ?packaging_line - packaging_line)
    (hold_cleared ?packaging_line - packaging_line)
    (label_set_available ?label_set - label_set)
    (label_set_reserved ?packaging_line - packaging_line ?label_set - label_set)
    (template_available ?document_template_var - document_template)
    (template_bound_to_line ?packaging_line - packaging_line ?document_template_var - document_template)
    (component_material_available ?component_batch - component_batch)
    (component_reserved_to_line ?packaging_line - packaging_line ?component_batch - component_batch)
    (approval_authority_available ?qa_approval_record - qa_approval_record)
    (approval_bound_to_line ?packaging_line - packaging_line ?qa_approval_record - qa_approval_record)
    (release_document_available ?release_document - release_document)
    (release_document_bound_to_batch ?processable_entity - processable_entity ?release_document - release_document)
    (slot_checkin_completed ?primary_batch_var - primary_batch)
    (station_checkin_completed ?secondary_batch_var - secondary_batch)
    (final_release_recorded ?packaging_line - packaging_line)
  )
  (:action register_batch_record
    :parameters (?processable_entity - processable_entity)
    :precondition
      (and
        (not
          (batch_record_registered ?processable_entity)
        )
        (not
          (resource_allocated_or_locked ?processable_entity)
        )
      )
    :effect (batch_record_registered ?processable_entity)
  )
  (:action reserve_line_slot_for_batch
    :parameters (?processable_entity - processable_entity ?line_slot - line_slot)
    :precondition
      (and
        (batch_record_registered ?processable_entity)
        (not
          (slot_booking_confirmed ?processable_entity)
        )
        (slot_available ?line_slot)
      )
    :effect
      (and
        (slot_booking_confirmed ?processable_entity)
        (batch_assigned_to_slot ?processable_entity ?line_slot)
        (not
          (slot_available ?line_slot)
        )
      )
  )
  (:action assign_product_variant_to_batch_and_allocate_operator
    :parameters (?processable_entity - processable_entity ?product_variant_var - product_variant)
    :precondition
      (and
        (batch_record_registered ?processable_entity)
        (slot_booking_confirmed ?processable_entity)
        (operator_available_for_product_variant ?product_variant_var)
      )
    :effect
      (and
        (batch_assigned_product_variant ?processable_entity ?product_variant_var)
        (not
          (operator_available_for_product_variant ?product_variant_var)
        )
      )
  )
  (:action stage_batch_for_processing
    :parameters (?processable_entity - processable_entity ?product_variant_var - product_variant)
    :precondition
      (and
        (batch_record_registered ?processable_entity)
        (slot_booking_confirmed ?processable_entity)
        (batch_assigned_product_variant ?processable_entity ?product_variant_var)
        (not
          (entity_staged ?processable_entity)
        )
      )
    :effect (entity_staged ?processable_entity)
  )
  (:action unassign_operator_from_batch
    :parameters (?processable_entity - processable_entity ?product_variant_var - product_variant)
    :precondition
      (and
        (batch_assigned_product_variant ?processable_entity ?product_variant_var)
      )
    :effect
      (and
        (operator_available_for_product_variant ?product_variant_var)
        (not
          (batch_assigned_product_variant ?processable_entity ?product_variant_var)
        )
      )
  )
  (:action allocate_equipment_to_entity
    :parameters (?processable_entity - processable_entity ?operator - equipment_unit)
    :precondition
      (and
        (entity_staged ?processable_entity)
        (equipment_unit_available ?operator)
      )
    :effect
      (and
        (equipment_allocated_to_entity ?processable_entity ?operator)
        (not
          (equipment_unit_available ?operator)
        )
      )
  )
  (:action release_equipment_from_entity
    :parameters (?processable_entity - processable_entity ?operator - equipment_unit)
    :precondition
      (and
        (equipment_allocated_to_entity ?processable_entity ?operator)
      )
    :effect
      (and
        (equipment_unit_available ?operator)
        (not
          (equipment_allocated_to_entity ?processable_entity ?operator)
        )
      )
  )
  (:action reserve_component_batch_to_line
    :parameters (?packaging_line - packaging_line ?component_batch - component_batch)
    :precondition
      (and
        (entity_staged ?packaging_line)
        (component_material_available ?component_batch)
      )
    :effect
      (and
        (component_reserved_to_line ?packaging_line ?component_batch)
        (not
          (component_material_available ?component_batch)
        )
      )
  )
  (:action release_component_batch_from_line
    :parameters (?packaging_line - packaging_line ?component_batch - component_batch)
    :precondition
      (and
        (component_reserved_to_line ?packaging_line ?component_batch)
      )
    :effect
      (and
        (component_material_available ?component_batch)
        (not
          (component_reserved_to_line ?packaging_line ?component_batch)
        )
      )
  )
  (:action bind_qa_approval_to_line
    :parameters (?packaging_line - packaging_line ?qa_approval_record - qa_approval_record)
    :precondition
      (and
        (entity_staged ?packaging_line)
        (approval_authority_available ?qa_approval_record)
      )
    :effect
      (and
        (approval_bound_to_line ?packaging_line ?qa_approval_record)
        (not
          (approval_authority_available ?qa_approval_record)
        )
      )
  )
  (:action unbind_qa_approval_from_line
    :parameters (?packaging_line - packaging_line ?qa_approval_record - qa_approval_record)
    :precondition
      (and
        (approval_bound_to_line ?packaging_line ?qa_approval_record)
      )
    :effect
      (and
        (approval_authority_available ?qa_approval_record)
        (not
          (approval_bound_to_line ?packaging_line ?qa_approval_record)
        )
      )
  )
  (:action stage_equipment_for_batch_slot
    :parameters (?primary_batch_var - primary_batch ?equipment_position - equipment_position ?product_variant_var - product_variant)
    :precondition
      (and
        (entity_staged ?primary_batch_var)
        (batch_assigned_product_variant ?primary_batch_var ?product_variant_var)
        (slot_equipment_link ?primary_batch_var ?equipment_position)
        (not
          (equipment_staged ?equipment_position)
        )
        (not
          (equipment_validated ?equipment_position)
        )
      )
    :effect (equipment_staged ?equipment_position)
  )
  (:action complete_slot_checkin_with_operator
    :parameters (?primary_batch_var - primary_batch ?equipment_position - equipment_position ?operator - equipment_unit)
    :precondition
      (and
        (entity_staged ?primary_batch_var)
        (equipment_allocated_to_entity ?primary_batch_var ?operator)
        (slot_equipment_link ?primary_batch_var ?equipment_position)
        (equipment_staged ?equipment_position)
        (not
          (slot_checkin_completed ?primary_batch_var)
        )
      )
    :effect
      (and
        (slot_checkin_completed ?primary_batch_var)
        (slot_verified ?primary_batch_var)
      )
  )
  (:action validate_equipment_and_assign_material_kit
    :parameters (?primary_batch_var - primary_batch ?equipment_position - equipment_position ?material_kit - material_kit)
    :precondition
      (and
        (entity_staged ?primary_batch_var)
        (slot_equipment_link ?primary_batch_var ?equipment_position)
        (material_kit_available ?material_kit)
        (not
          (slot_checkin_completed ?primary_batch_var)
        )
      )
    :effect
      (and
        (equipment_validated ?equipment_position)
        (slot_checkin_completed ?primary_batch_var)
        (material_assigned_to_line ?primary_batch_var ?material_kit)
        (not
          (material_kit_available ?material_kit)
        )
      )
  )
  (:action verify_slot_and_return_material_kit
    :parameters (?primary_batch_var - primary_batch ?equipment_position - equipment_position ?product_variant_var - product_variant ?material_kit - material_kit)
    :precondition
      (and
        (entity_staged ?primary_batch_var)
        (batch_assigned_product_variant ?primary_batch_var ?product_variant_var)
        (slot_equipment_link ?primary_batch_var ?equipment_position)
        (equipment_validated ?equipment_position)
        (material_assigned_to_line ?primary_batch_var ?material_kit)
        (not
          (slot_verified ?primary_batch_var)
        )
      )
    :effect
      (and
        (equipment_staged ?equipment_position)
        (slot_verified ?primary_batch_var)
        (material_kit_available ?material_kit)
        (not
          (material_assigned_to_line ?primary_batch_var ?material_kit)
        )
      )
  )
  (:action stage_station_for_secondary_batch
    :parameters (?secondary_batch_var - secondary_batch ?station_position - station_position ?product_variant_var - product_variant)
    :precondition
      (and
        (entity_staged ?secondary_batch_var)
        (batch_assigned_product_variant ?secondary_batch_var ?product_variant_var)
        (station_equipment_link ?secondary_batch_var ?station_position)
        (not
          (station_staged ?station_position)
        )
        (not
          (station_validated ?station_position)
        )
      )
    :effect (station_staged ?station_position)
  )
  (:action complete_station_checkin_with_operator
    :parameters (?secondary_batch_var - secondary_batch ?station_position - station_position ?operator - equipment_unit)
    :precondition
      (and
        (entity_staged ?secondary_batch_var)
        (equipment_allocated_to_entity ?secondary_batch_var ?operator)
        (station_equipment_link ?secondary_batch_var ?station_position)
        (station_staged ?station_position)
        (not
          (station_checkin_completed ?secondary_batch_var)
        )
      )
    :effect
      (and
        (station_checkin_completed ?secondary_batch_var)
        (station_verified ?secondary_batch_var)
      )
  )
  (:action validate_station_and_assign_material_kit
    :parameters (?secondary_batch_var - secondary_batch ?station_position - station_position ?material_kit - material_kit)
    :precondition
      (and
        (entity_staged ?secondary_batch_var)
        (station_equipment_link ?secondary_batch_var ?station_position)
        (material_kit_available ?material_kit)
        (not
          (station_checkin_completed ?secondary_batch_var)
        )
      )
    :effect
      (and
        (station_validated ?station_position)
        (station_checkin_completed ?secondary_batch_var)
        (material_assigned_to_station ?secondary_batch_var ?material_kit)
        (not
          (material_kit_available ?material_kit)
        )
      )
  )
  (:action verify_station_and_return_material_kit
    :parameters (?secondary_batch_var - secondary_batch ?station_position - station_position ?product_variant_var - product_variant ?material_kit - material_kit)
    :precondition
      (and
        (entity_staged ?secondary_batch_var)
        (batch_assigned_product_variant ?secondary_batch_var ?product_variant_var)
        (station_equipment_link ?secondary_batch_var ?station_position)
        (station_validated ?station_position)
        (material_assigned_to_station ?secondary_batch_var ?material_kit)
        (not
          (station_verified ?secondary_batch_var)
        )
      )
    :effect
      (and
        (station_staged ?station_position)
        (station_verified ?secondary_batch_var)
        (material_kit_available ?material_kit)
        (not
          (material_assigned_to_station ?secondary_batch_var ?material_kit)
        )
      )
  )
  (:action reserve_run_token_and_assign_run
    :parameters (?primary_batch_var - primary_batch ?secondary_batch_var - secondary_batch ?equipment_position - equipment_position ?station_position - station_position ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (slot_checkin_completed ?primary_batch_var)
        (station_checkin_completed ?secondary_batch_var)
        (slot_equipment_link ?primary_batch_var ?equipment_position)
        (station_equipment_link ?secondary_batch_var ?station_position)
        (equipment_staged ?equipment_position)
        (station_staged ?station_position)
        (slot_verified ?primary_batch_var)
        (station_verified ?secondary_batch_var)
        (run_token_available ?packaging_run_record)
      )
    :effect
      (and
        (run_token_reserved ?packaging_run_record)
        (run_assigned_to_equipment ?packaging_run_record ?equipment_position)
        (run_assigned_to_station ?packaging_run_record ?station_position)
        (not
          (run_token_available ?packaging_run_record)
        )
      )
  )
  (:action reserve_run_token_with_quality_pending
    :parameters (?primary_batch_var - primary_batch ?secondary_batch_var - secondary_batch ?equipment_position - equipment_position ?station_position - station_position ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (slot_checkin_completed ?primary_batch_var)
        (station_checkin_completed ?secondary_batch_var)
        (slot_equipment_link ?primary_batch_var ?equipment_position)
        (station_equipment_link ?secondary_batch_var ?station_position)
        (equipment_validated ?equipment_position)
        (station_staged ?station_position)
        (not
          (slot_verified ?primary_batch_var)
        )
        (station_verified ?secondary_batch_var)
        (run_token_available ?packaging_run_record)
      )
    :effect
      (and
        (run_token_reserved ?packaging_run_record)
        (run_assigned_to_equipment ?packaging_run_record ?equipment_position)
        (run_assigned_to_station ?packaging_run_record ?station_position)
        (run_quality_flag_pending ?packaging_run_record)
        (not
          (run_token_available ?packaging_run_record)
        )
      )
  )
  (:action reserve_run_token_with_label_pending
    :parameters (?primary_batch_var - primary_batch ?secondary_batch_var - secondary_batch ?equipment_position - equipment_position ?station_position - station_position ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (slot_checkin_completed ?primary_batch_var)
        (station_checkin_completed ?secondary_batch_var)
        (slot_equipment_link ?primary_batch_var ?equipment_position)
        (station_equipment_link ?secondary_batch_var ?station_position)
        (equipment_staged ?equipment_position)
        (station_validated ?station_position)
        (slot_verified ?primary_batch_var)
        (not
          (station_verified ?secondary_batch_var)
        )
        (run_token_available ?packaging_run_record)
      )
    :effect
      (and
        (run_token_reserved ?packaging_run_record)
        (run_assigned_to_equipment ?packaging_run_record ?equipment_position)
        (run_assigned_to_station ?packaging_run_record ?station_position)
        (run_label_flag_pending ?packaging_run_record)
        (not
          (run_token_available ?packaging_run_record)
        )
      )
  )
  (:action reserve_run_token_with_quality_and_label_pending
    :parameters (?primary_batch_var - primary_batch ?secondary_batch_var - secondary_batch ?equipment_position - equipment_position ?station_position - station_position ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (slot_checkin_completed ?primary_batch_var)
        (station_checkin_completed ?secondary_batch_var)
        (slot_equipment_link ?primary_batch_var ?equipment_position)
        (station_equipment_link ?secondary_batch_var ?station_position)
        (equipment_validated ?equipment_position)
        (station_validated ?station_position)
        (not
          (slot_verified ?primary_batch_var)
        )
        (not
          (station_verified ?secondary_batch_var)
        )
        (run_token_available ?packaging_run_record)
      )
    :effect
      (and
        (run_token_reserved ?packaging_run_record)
        (run_assigned_to_equipment ?packaging_run_record ?equipment_position)
        (run_assigned_to_station ?packaging_run_record ?station_position)
        (run_quality_flag_pending ?packaging_run_record)
        (run_label_flag_pending ?packaging_run_record)
        (not
          (run_token_available ?packaging_run_record)
        )
      )
  )
  (:action confirm_run_for_execution
    :parameters (?packaging_run_record - packaging_run_record ?primary_batch_var - primary_batch ?product_variant_var - product_variant)
    :precondition
      (and
        (run_token_reserved ?packaging_run_record)
        (slot_checkin_completed ?primary_batch_var)
        (batch_assigned_product_variant ?primary_batch_var ?product_variant_var)
        (not
          (run_confirmed_for_execution ?packaging_run_record)
        )
      )
    :effect (run_confirmed_for_execution ?packaging_run_record)
  )
  (:action assign_inspection_tool_to_run
    :parameters (?packaging_line - packaging_line ?inspection_tool - inspection_tool ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (entity_staged ?packaging_line)
        (line_linked_to_run_record ?packaging_line ?packaging_run_record)
        (line_has_inspection_tool ?packaging_line ?inspection_tool)
        (inspection_tool_available ?inspection_tool)
        (run_token_reserved ?packaging_run_record)
        (run_confirmed_for_execution ?packaging_run_record)
        (not
          (inspection_tool_in_use ?inspection_tool)
        )
      )
    :effect
      (and
        (inspection_tool_in_use ?inspection_tool)
        (inspection_tool_linked_to_run ?inspection_tool ?packaging_run_record)
        (not
          (inspection_tool_available ?inspection_tool)
        )
      )
  )
  (:action prepare_line_for_packaging
    :parameters (?packaging_line - packaging_line ?inspection_tool - inspection_tool ?packaging_run_record - packaging_run_record ?product_variant_var - product_variant)
    :precondition
      (and
        (entity_staged ?packaging_line)
        (line_has_inspection_tool ?packaging_line ?inspection_tool)
        (inspection_tool_in_use ?inspection_tool)
        (inspection_tool_linked_to_run ?inspection_tool ?packaging_run_record)
        (batch_assigned_product_variant ?packaging_line ?product_variant_var)
        (not
          (run_quality_flag_pending ?packaging_run_record)
        )
        (not
          (line_packaging_prepared ?packaging_line)
        )
      )
    :effect (line_packaging_prepared ?packaging_line)
  )
  (:action reserve_label_set_for_line
    :parameters (?packaging_line - packaging_line ?label_set - label_set)
    :precondition
      (and
        (entity_staged ?packaging_line)
        (label_set_available ?label_set)
        (not
          (label_set_assigned ?packaging_line)
        )
      )
    :effect
      (and
        (label_set_assigned ?packaging_line)
        (label_set_reserved ?packaging_line ?label_set)
        (not
          (label_set_available ?label_set)
        )
      )
  )
  (:action apply_label_set_and_prepare_line
    :parameters (?packaging_line - packaging_line ?inspection_tool - inspection_tool ?packaging_run_record - packaging_run_record ?product_variant_var - product_variant ?label_set - label_set)
    :precondition
      (and
        (entity_staged ?packaging_line)
        (line_has_inspection_tool ?packaging_line ?inspection_tool)
        (inspection_tool_in_use ?inspection_tool)
        (inspection_tool_linked_to_run ?inspection_tool ?packaging_run_record)
        (batch_assigned_product_variant ?packaging_line ?product_variant_var)
        (run_quality_flag_pending ?packaging_run_record)
        (label_set_assigned ?packaging_line)
        (label_set_reserved ?packaging_line ?label_set)
        (not
          (line_packaging_prepared ?packaging_line)
        )
      )
    :effect
      (and
        (line_packaging_prepared ?packaging_line)
        (label_set_applied ?packaging_line)
      )
  )
  (:action authorize_line_execution_without_label_flag
    :parameters (?packaging_line - packaging_line ?component_batch - component_batch ?operator - equipment_unit ?inspection_tool - inspection_tool ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (line_packaging_prepared ?packaging_line)
        (component_reserved_to_line ?packaging_line ?component_batch)
        (equipment_allocated_to_entity ?packaging_line ?operator)
        (line_has_inspection_tool ?packaging_line ?inspection_tool)
        (inspection_tool_linked_to_run ?inspection_tool ?packaging_run_record)
        (not
          (run_label_flag_pending ?packaging_run_record)
        )
        (not
          (line_execution_authorized ?packaging_line)
        )
      )
    :effect (line_execution_authorized ?packaging_line)
  )
  (:action authorize_line_execution_with_label_flag
    :parameters (?packaging_line - packaging_line ?component_batch - component_batch ?operator - equipment_unit ?inspection_tool - inspection_tool ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (line_packaging_prepared ?packaging_line)
        (component_reserved_to_line ?packaging_line ?component_batch)
        (equipment_allocated_to_entity ?packaging_line ?operator)
        (line_has_inspection_tool ?packaging_line ?inspection_tool)
        (inspection_tool_linked_to_run ?inspection_tool ?packaging_run_record)
        (run_label_flag_pending ?packaging_run_record)
        (not
          (line_execution_authorized ?packaging_line)
        )
      )
    :effect (line_execution_authorized ?packaging_line)
  )
  (:action complete_packaging_checks
    :parameters (?packaging_line - packaging_line ?qa_approval_record - qa_approval_record ?inspection_tool - inspection_tool ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (line_execution_authorized ?packaging_line)
        (approval_bound_to_line ?packaging_line ?qa_approval_record)
        (line_has_inspection_tool ?packaging_line ?inspection_tool)
        (inspection_tool_linked_to_run ?inspection_tool ?packaging_run_record)
        (not
          (run_quality_flag_pending ?packaging_run_record)
        )
        (not
          (run_label_flag_pending ?packaging_run_record)
        )
        (not
          (packaging_checks_complete ?packaging_line)
        )
      )
    :effect (packaging_checks_complete ?packaging_line)
  )
  (:action complete_packaging_checks_with_additional_verification
    :parameters (?packaging_line - packaging_line ?qa_approval_record - qa_approval_record ?inspection_tool - inspection_tool ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (line_execution_authorized ?packaging_line)
        (approval_bound_to_line ?packaging_line ?qa_approval_record)
        (line_has_inspection_tool ?packaging_line ?inspection_tool)
        (inspection_tool_linked_to_run ?inspection_tool ?packaging_run_record)
        (run_quality_flag_pending ?packaging_run_record)
        (not
          (run_label_flag_pending ?packaging_run_record)
        )
        (not
          (packaging_checks_complete ?packaging_line)
        )
      )
    :effect
      (and
        (packaging_checks_complete ?packaging_line)
        (additional_checks_passed ?packaging_line)
      )
  )
  (:action complete_packaging_checks_with_label_verification
    :parameters (?packaging_line - packaging_line ?qa_approval_record - qa_approval_record ?inspection_tool - inspection_tool ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (line_execution_authorized ?packaging_line)
        (approval_bound_to_line ?packaging_line ?qa_approval_record)
        (line_has_inspection_tool ?packaging_line ?inspection_tool)
        (inspection_tool_linked_to_run ?inspection_tool ?packaging_run_record)
        (not
          (run_quality_flag_pending ?packaging_run_record)
        )
        (run_label_flag_pending ?packaging_run_record)
        (not
          (packaging_checks_complete ?packaging_line)
        )
      )
    :effect
      (and
        (packaging_checks_complete ?packaging_line)
        (additional_checks_passed ?packaging_line)
      )
  )
  (:action complete_packaging_checks_with_quality_and_label_verification
    :parameters (?packaging_line - packaging_line ?qa_approval_record - qa_approval_record ?inspection_tool - inspection_tool ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (line_execution_authorized ?packaging_line)
        (approval_bound_to_line ?packaging_line ?qa_approval_record)
        (line_has_inspection_tool ?packaging_line ?inspection_tool)
        (inspection_tool_linked_to_run ?inspection_tool ?packaging_run_record)
        (run_quality_flag_pending ?packaging_run_record)
        (run_label_flag_pending ?packaging_run_record)
        (not
          (packaging_checks_complete ?packaging_line)
        )
      )
    :effect
      (and
        (packaging_checks_complete ?packaging_line)
        (additional_checks_passed ?packaging_line)
      )
  )
  (:action finalize_release_and_mark_execution_ready
    :parameters (?packaging_line - packaging_line)
    :precondition
      (and
        (packaging_checks_complete ?packaging_line)
        (not
          (additional_checks_passed ?packaging_line)
        )
        (not
          (final_release_recorded ?packaging_line)
        )
      )
    :effect
      (and
        (final_release_recorded ?packaging_line)
        (execution_readiness_flag ?packaging_line)
      )
  )
  (:action bind_document_template_to_line
    :parameters (?packaging_line - packaging_line ?document_template_var - document_template)
    :precondition
      (and
        (packaging_checks_complete ?packaging_line)
        (additional_checks_passed ?packaging_line)
        (template_available ?document_template_var)
      )
    :effect
      (and
        (template_bound_to_line ?packaging_line ?document_template_var)
        (not
          (template_available ?document_template_var)
        )
      )
  )
  (:action confirm_final_packaging_readiness
    :parameters (?packaging_line - packaging_line ?primary_batch_var - primary_batch ?secondary_batch_var - secondary_batch ?product_variant_var - product_variant ?document_template_var - document_template)
    :precondition
      (and
        (packaging_checks_complete ?packaging_line)
        (additional_checks_passed ?packaging_line)
        (template_bound_to_line ?packaging_line ?document_template_var)
        (line_supports_primary_batch ?packaging_line ?primary_batch_var)
        (line_supports_secondary_batch ?packaging_line ?secondary_batch_var)
        (slot_verified ?primary_batch_var)
        (station_verified ?secondary_batch_var)
        (batch_assigned_product_variant ?packaging_line ?product_variant_var)
        (not
          (final_packaging_ready ?packaging_line)
        )
      )
    :effect (final_packaging_ready ?packaging_line)
  )
  (:action finalize_release_and_mark_execution_ready_for_prepared_line
    :parameters (?packaging_line - packaging_line)
    :precondition
      (and
        (packaging_checks_complete ?packaging_line)
        (final_packaging_ready ?packaging_line)
        (not
          (final_release_recorded ?packaging_line)
        )
      )
    :effect
      (and
        (final_release_recorded ?packaging_line)
        (execution_readiness_flag ?packaging_line)
      )
  )
  (:action acknowledge_line_hold
    :parameters (?packaging_line - packaging_line ?quality_hold_tag - quality_hold_tag ?product_variant_var - product_variant)
    :precondition
      (and
        (entity_staged ?packaging_line)
        (batch_assigned_product_variant ?packaging_line ?product_variant_var)
        (special_hold_present ?quality_hold_tag)
        (line_hold_association ?packaging_line ?quality_hold_tag)
        (not
          (hold_acknowledged ?packaging_line)
        )
      )
    :effect
      (and
        (hold_acknowledged ?packaging_line)
        (not
          (special_hold_present ?quality_hold_tag)
        )
      )
  )
  (:action record_hold_clearance_step
    :parameters (?packaging_line - packaging_line ?operator - equipment_unit)
    :precondition
      (and
        (hold_acknowledged ?packaging_line)
        (equipment_allocated_to_entity ?packaging_line ?operator)
        (not
          (hold_cleared_step ?packaging_line)
        )
      )
    :effect (hold_cleared_step ?packaging_line)
  )
  (:action clear_hold
    :parameters (?packaging_line - packaging_line ?qa_approval_record - qa_approval_record)
    :precondition
      (and
        (hold_cleared_step ?packaging_line)
        (approval_bound_to_line ?packaging_line ?qa_approval_record)
        (not
          (hold_cleared ?packaging_line)
        )
      )
    :effect (hold_cleared ?packaging_line)
  )
  (:action finalize_hold_clearance_and_mark_execution_ready
    :parameters (?packaging_line - packaging_line)
    :precondition
      (and
        (hold_cleared ?packaging_line)
        (not
          (final_release_recorded ?packaging_line)
        )
      )
    :effect
      (and
        (final_release_recorded ?packaging_line)
        (execution_readiness_flag ?packaging_line)
      )
  )
  (:action mark_primary_batch_ready_for_execution
    :parameters (?primary_batch_var - primary_batch ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (slot_checkin_completed ?primary_batch_var)
        (slot_verified ?primary_batch_var)
        (run_token_reserved ?packaging_run_record)
        (run_confirmed_for_execution ?packaging_run_record)
        (not
          (execution_readiness_flag ?primary_batch_var)
        )
      )
    :effect (execution_readiness_flag ?primary_batch_var)
  )
  (:action mark_secondary_batch_ready_for_execution
    :parameters (?secondary_batch_var - secondary_batch ?packaging_run_record - packaging_run_record)
    :precondition
      (and
        (station_checkin_completed ?secondary_batch_var)
        (station_verified ?secondary_batch_var)
        (run_token_reserved ?packaging_run_record)
        (run_confirmed_for_execution ?packaging_run_record)
        (not
          (execution_readiness_flag ?secondary_batch_var)
        )
      )
    :effect (execution_readiness_flag ?secondary_batch_var)
  )
  (:action attach_release_document_to_batch
    :parameters (?processable_entity - processable_entity ?release_document - release_document ?product_variant_var - product_variant)
    :precondition
      (and
        (execution_readiness_flag ?processable_entity)
        (batch_assigned_product_variant ?processable_entity ?product_variant_var)
        (release_document_available ?release_document)
        (not
          (documentation_attached ?processable_entity)
        )
      )
    :effect
      (and
        (documentation_attached ?processable_entity)
        (release_document_bound_to_batch ?processable_entity ?release_document)
        (not
          (release_document_available ?release_document)
        )
      )
  )
  (:action finalize_allocation_and_release_slot
    :parameters (?primary_batch_var - primary_batch ?line_slot - line_slot ?release_document - release_document)
    :precondition
      (and
        (documentation_attached ?primary_batch_var)
        (batch_assigned_to_slot ?primary_batch_var ?line_slot)
        (release_document_bound_to_batch ?primary_batch_var ?release_document)
        (not
          (resource_allocated_or_locked ?primary_batch_var)
        )
      )
    :effect
      (and
        (resource_allocated_or_locked ?primary_batch_var)
        (slot_available ?line_slot)
        (release_document_available ?release_document)
      )
  )
  (:action finalize_allocation_for_secondary_batch_and_release_slot
    :parameters (?secondary_batch_var - secondary_batch ?line_slot - line_slot ?release_document - release_document)
    :precondition
      (and
        (documentation_attached ?secondary_batch_var)
        (batch_assigned_to_slot ?secondary_batch_var ?line_slot)
        (release_document_bound_to_batch ?secondary_batch_var ?release_document)
        (not
          (resource_allocated_or_locked ?secondary_batch_var)
        )
      )
    :effect
      (and
        (resource_allocated_or_locked ?secondary_batch_var)
        (slot_available ?line_slot)
        (release_document_available ?release_document)
      )
  )
  (:action finalize_allocation_for_line_and_release_slot
    :parameters (?packaging_line - packaging_line ?line_slot - line_slot ?release_document - release_document)
    :precondition
      (and
        (documentation_attached ?packaging_line)
        (batch_assigned_to_slot ?packaging_line ?line_slot)
        (release_document_bound_to_batch ?packaging_line ?release_document)
        (not
          (resource_allocated_or_locked ?packaging_line)
        )
      )
    :effect
      (and
        (resource_allocated_or_locked ?packaging_line)
        (slot_available ?line_slot)
        (release_document_available ?release_document)
      )
  )
)

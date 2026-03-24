(define (domain warehouse_serial_lot_inventory_control)
  (:requirements :strips :typing :negative-preconditions)
  (:types physical_object - object asset_category - physical_object location_category - physical_object personnel_category - physical_object inventory_class - physical_object inventory_record - inventory_class inbound_shipment_unit - asset_category product_sku - asset_category equipment_unit - asset_category label_template - asset_category work_batch - asset_category lot_or_serial_id - asset_category special_instruction_tag - asset_category traceability_token - asset_category consumable_or_packaging - location_category container_slot - location_category document_certificate - location_category location_equipment_binding - personnel_category location_picker_binding - personnel_category handling_unit - personnel_category location_group - inventory_record location_subgroup - inventory_record reserve_location - location_group pick_location - location_group work_task - location_subgroup)

  (:predicates
    (inventory_received ?inventory_unit - inventory_record)
    (record_ready_for_putaway ?inventory_unit - inventory_record)
    (inbound_allocated ?inventory_unit - inventory_record)
    (finalized ?inventory_unit - inventory_record)
    (record_available_for_serial_assignment ?inventory_unit - inventory_record)
    (record_lot_or_serial_attached ?inventory_unit - inventory_record)
    (inbound_shipment_unit_available ?inbound_shipment_unit - inbound_shipment_unit)
    (record_assigned_to_inbound_shipment ?inventory_unit - inventory_record ?inbound_shipment_unit - inbound_shipment_unit)
    (sku_available ?product_sku - product_sku)
    (record_has_sku ?inventory_unit - inventory_record ?product_sku - product_sku)
    (equipment_available ?equipment_unit - equipment_unit)
    (record_assigned_to_equipment ?inventory_unit - inventory_record ?equipment_unit - equipment_unit)
    (consumable_available ?consumable_or_packaging - consumable_or_packaging)
    (consumable_assigned_to_location ?reserve_location - reserve_location ?consumable_or_packaging - consumable_or_packaging)
    (consumable_assigned_to_pick_location ?pick_location - pick_location ?consumable_or_packaging - consumable_or_packaging)
    (location_has_equipment_binding ?reserve_location - reserve_location ?location_equipment_binding - location_equipment_binding)
    (equipment_staged ?location_equipment_binding - location_equipment_binding)
    (equipment_ready ?location_equipment_binding - location_equipment_binding)
    (reserve_location_ready ?reserve_location - reserve_location)
    (pick_location_picker_binding ?pick_location - pick_location ?location_picker_binding - location_picker_binding)
    (picker_staged ?location_picker_binding - location_picker_binding)
    (picker_ready ?location_picker_binding - location_picker_binding)
    (pick_location_ready ?pick_location - pick_location)
    (handling_unit_available_for_assembly ?handling_unit - handling_unit)
    (handling_unit_in_progress ?handling_unit - handling_unit)
    (handling_unit_equipment_bound ?handling_unit - handling_unit ?location_equipment_binding - location_equipment_binding)
    (handling_unit_picker_bound ?handling_unit - handling_unit ?location_picker_binding - location_picker_binding)
    (handling_unit_equipment_verified ?handling_unit - handling_unit)
    (handling_unit_picker_verified ?handling_unit - handling_unit)
    (handling_unit_ready_for_slotting ?handling_unit - handling_unit)
    (task_source_location ?work_task - work_task ?reserve_location - reserve_location)
    (task_destination_location ?work_task - work_task ?pick_location - pick_location)
    (task_assigned_handling_unit ?work_task - work_task ?handling_unit - handling_unit)
    (container_slot_available ?container_slot - container_slot)
    (task_assigned_container_slot ?work_task - work_task ?container_slot - container_slot)
    (container_slot_occupied ?container_slot - container_slot)
    (container_slot_assigned_to_handling_unit ?container_slot - container_slot ?handling_unit - handling_unit)
    (task_slotting_finalized ?work_task - work_task)
    (task_label_applied ?work_task - work_task)
    (task_ready_for_finalization ?work_task - work_task)
    (task_has_label_type ?work_task - work_task)
    (task_label_printed ?work_task - work_task)
    (task_has_document_attachment ?work_task - work_task)
    (task_contents_finalized ?work_task - work_task)
    (document_available ?document_certificate - document_certificate)
    (task_document_assigned ?work_task - work_task ?document_certificate - document_certificate)
    (task_document_bound_flag ?work_task - work_task)
    (task_equipment_assigned ?work_task - work_task)
    (task_ready_for_completion ?work_task - work_task)
    (label_template_available ?label_template - label_template)
    (task_label_template_assigned ?work_task - work_task ?label_template - label_template)
    (work_batch_available ?work_batch - work_batch)
    (task_has_work_batch ?work_task - work_task ?work_batch - work_batch)
    (special_instruction_tag_available ?special_instruction_tag - special_instruction_tag)
    (task_has_special_instruction ?work_task - work_task ?special_instruction_tag - special_instruction_tag)
    (traceability_token_available ?traceability_token - traceability_token)
    (task_has_traceability_token ?work_task - work_task ?traceability_token - traceability_token)
    (lot_or_serial_id_available ?lot_or_serial_id - lot_or_serial_id)
    (record_has_lot_or_serial_id ?inventory_unit - inventory_record ?lot_or_serial_id - lot_or_serial_id)
    (reserve_location_marked ?reserve_location - reserve_location)
    (pick_location_marked ?pick_location - pick_location)
    (task_closed ?work_task - work_task)
  )
  (:action record_inventory_receipt
    :parameters (?inventory_unit - inventory_record)
    :precondition
      (and
        (not
          (inventory_received ?inventory_unit)
        )
        (not
          (finalized ?inventory_unit)
        )
      )
    :effect (inventory_received ?inventory_unit)
  )
  (:action allocate_inventory_to_inbound_unit
    :parameters (?inventory_unit - inventory_record ?inbound_shipment_unit - inbound_shipment_unit)
    :precondition
      (and
        (inventory_received ?inventory_unit)
        (not
          (inbound_allocated ?inventory_unit)
        )
        (inbound_shipment_unit_available ?inbound_shipment_unit)
      )
    :effect
      (and
        (inbound_allocated ?inventory_unit)
        (record_assigned_to_inbound_shipment ?inventory_unit ?inbound_shipment_unit)
        (not
          (inbound_shipment_unit_available ?inbound_shipment_unit)
        )
      )
  )
  (:action inspect_and_verify_sku
    :parameters (?inventory_unit - inventory_record ?product_sku - product_sku)
    :precondition
      (and
        (inventory_received ?inventory_unit)
        (inbound_allocated ?inventory_unit)
        (sku_available ?product_sku)
      )
    :effect
      (and
        (record_has_sku ?inventory_unit ?product_sku)
        (not
          (sku_available ?product_sku)
        )
      )
  )
  (:action approve_inspection_and_release_for_putaway
    :parameters (?inventory_unit - inventory_record ?product_sku - product_sku)
    :precondition
      (and
        (inventory_received ?inventory_unit)
        (inbound_allocated ?inventory_unit)
        (record_has_sku ?inventory_unit ?product_sku)
        (not
          (record_ready_for_putaway ?inventory_unit)
        )
      )
    :effect (record_ready_for_putaway ?inventory_unit)
  )
  (:action release_sku_resource
    :parameters (?inventory_unit - inventory_record ?product_sku - product_sku)
    :precondition
      (and
        (record_has_sku ?inventory_unit ?product_sku)
      )
    :effect
      (and
        (sku_available ?product_sku)
        (not
          (record_has_sku ?inventory_unit ?product_sku)
        )
      )
  )
  (:action assign_equipment_to_inventory_unit
    :parameters (?inventory_unit - inventory_record ?equipment_unit - equipment_unit)
    :precondition
      (and
        (record_ready_for_putaway ?inventory_unit)
        (equipment_available ?equipment_unit)
      )
    :effect
      (and
        (record_assigned_to_equipment ?inventory_unit ?equipment_unit)
        (not
          (equipment_available ?equipment_unit)
        )
      )
  )
  (:action unassign_equipment_from_inventory_unit
    :parameters (?inventory_unit - inventory_record ?equipment_unit - equipment_unit)
    :precondition
      (and
        (record_assigned_to_equipment ?inventory_unit ?equipment_unit)
      )
    :effect
      (and
        (equipment_available ?equipment_unit)
        (not
          (record_assigned_to_equipment ?inventory_unit ?equipment_unit)
        )
      )
  )
  (:action attach_special_instruction_to_task
    :parameters (?work_task - work_task ?special_instruction_tag - special_instruction_tag)
    :precondition
      (and
        (record_ready_for_putaway ?work_task)
        (special_instruction_tag_available ?special_instruction_tag)
      )
    :effect
      (and
        (task_has_special_instruction ?work_task ?special_instruction_tag)
        (not
          (special_instruction_tag_available ?special_instruction_tag)
        )
      )
  )
  (:action detach_special_instruction_from_task
    :parameters (?work_task - work_task ?special_instruction_tag - special_instruction_tag)
    :precondition
      (and
        (task_has_special_instruction ?work_task ?special_instruction_tag)
      )
    :effect
      (and
        (special_instruction_tag_available ?special_instruction_tag)
        (not
          (task_has_special_instruction ?work_task ?special_instruction_tag)
        )
      )
  )
  (:action attach_traceability_token_to_task
    :parameters (?work_task - work_task ?traceability_token - traceability_token)
    :precondition
      (and
        (record_ready_for_putaway ?work_task)
        (traceability_token_available ?traceability_token)
      )
    :effect
      (and
        (task_has_traceability_token ?work_task ?traceability_token)
        (not
          (traceability_token_available ?traceability_token)
        )
      )
  )
  (:action detach_traceability_token_from_task
    :parameters (?work_task - work_task ?traceability_token - traceability_token)
    :precondition
      (and
        (task_has_traceability_token ?work_task ?traceability_token)
      )
    :effect
      (and
        (traceability_token_available ?traceability_token)
        (not
          (task_has_traceability_token ?work_task ?traceability_token)
        )
      )
  )
  (:action stage_equipment_at_reserve_location
    :parameters (?reserve_location - reserve_location ?location_equipment_binding - location_equipment_binding ?product_sku - product_sku)
    :precondition
      (and
        (record_ready_for_putaway ?reserve_location)
        (record_has_sku ?reserve_location ?product_sku)
        (location_has_equipment_binding ?reserve_location ?location_equipment_binding)
        (not
          (equipment_staged ?location_equipment_binding)
        )
        (not
          (equipment_ready ?location_equipment_binding)
        )
      )
    :effect (equipment_staged ?location_equipment_binding)
  )
  (:action reserve_location_lock_for_putaway
    :parameters (?reserve_location - reserve_location ?location_equipment_binding - location_equipment_binding ?equipment_unit - equipment_unit)
    :precondition
      (and
        (record_ready_for_putaway ?reserve_location)
        (record_assigned_to_equipment ?reserve_location ?equipment_unit)
        (location_has_equipment_binding ?reserve_location ?location_equipment_binding)
        (equipment_staged ?location_equipment_binding)
        (not
          (reserve_location_marked ?reserve_location)
        )
      )
    :effect
      (and
        (reserve_location_marked ?reserve_location)
        (reserve_location_ready ?reserve_location)
      )
  )
  (:action apply_consumable_and_mark_location_for_putaway
    :parameters (?reserve_location - reserve_location ?location_equipment_binding - location_equipment_binding ?consumable_or_packaging - consumable_or_packaging)
    :precondition
      (and
        (record_ready_for_putaway ?reserve_location)
        (location_has_equipment_binding ?reserve_location ?location_equipment_binding)
        (consumable_available ?consumable_or_packaging)
        (not
          (reserve_location_marked ?reserve_location)
        )
      )
    :effect
      (and
        (equipment_ready ?location_equipment_binding)
        (reserve_location_marked ?reserve_location)
        (consumable_assigned_to_location ?reserve_location ?consumable_or_packaging)
        (not
          (consumable_available ?consumable_or_packaging)
        )
      )
  )
  (:action complete_consumable_cycle_at_reserve_location
    :parameters (?reserve_location - reserve_location ?location_equipment_binding - location_equipment_binding ?product_sku - product_sku ?consumable_or_packaging - consumable_or_packaging)
    :precondition
      (and
        (record_ready_for_putaway ?reserve_location)
        (record_has_sku ?reserve_location ?product_sku)
        (location_has_equipment_binding ?reserve_location ?location_equipment_binding)
        (equipment_ready ?location_equipment_binding)
        (consumable_assigned_to_location ?reserve_location ?consumable_or_packaging)
        (not
          (reserve_location_ready ?reserve_location)
        )
      )
    :effect
      (and
        (equipment_staged ?location_equipment_binding)
        (reserve_location_ready ?reserve_location)
        (consumable_available ?consumable_or_packaging)
        (not
          (consumable_assigned_to_location ?reserve_location ?consumable_or_packaging)
        )
      )
  )
  (:action stage_picker_at_pick_location
    :parameters (?pick_location - pick_location ?location_picker_binding - location_picker_binding ?product_sku - product_sku)
    :precondition
      (and
        (record_ready_for_putaway ?pick_location)
        (record_has_sku ?pick_location ?product_sku)
        (pick_location_picker_binding ?pick_location ?location_picker_binding)
        (not
          (picker_staged ?location_picker_binding)
        )
        (not
          (picker_ready ?location_picker_binding)
        )
      )
    :effect (picker_staged ?location_picker_binding)
  )
  (:action confirm_picker_assignment_and_mark_pick_location
    :parameters (?pick_location - pick_location ?location_picker_binding - location_picker_binding ?equipment_unit - equipment_unit)
    :precondition
      (and
        (record_ready_for_putaway ?pick_location)
        (record_assigned_to_equipment ?pick_location ?equipment_unit)
        (pick_location_picker_binding ?pick_location ?location_picker_binding)
        (picker_staged ?location_picker_binding)
        (not
          (pick_location_marked ?pick_location)
        )
      )
    :effect
      (and
        (pick_location_marked ?pick_location)
        (pick_location_ready ?pick_location)
      )
  )
  (:action apply_consumable_and_reserve_pick_location
    :parameters (?pick_location - pick_location ?location_picker_binding - location_picker_binding ?consumable_or_packaging - consumable_or_packaging)
    :precondition
      (and
        (record_ready_for_putaway ?pick_location)
        (pick_location_picker_binding ?pick_location ?location_picker_binding)
        (consumable_available ?consumable_or_packaging)
        (not
          (pick_location_marked ?pick_location)
        )
      )
    :effect
      (and
        (picker_ready ?location_picker_binding)
        (pick_location_marked ?pick_location)
        (consumable_assigned_to_pick_location ?pick_location ?consumable_or_packaging)
        (not
          (consumable_available ?consumable_or_packaging)
        )
      )
  )
  (:action complete_pick_preparation_and_release_consumable
    :parameters (?pick_location - pick_location ?location_picker_binding - location_picker_binding ?product_sku - product_sku ?consumable_or_packaging - consumable_or_packaging)
    :precondition
      (and
        (record_ready_for_putaway ?pick_location)
        (record_has_sku ?pick_location ?product_sku)
        (pick_location_picker_binding ?pick_location ?location_picker_binding)
        (picker_ready ?location_picker_binding)
        (consumable_assigned_to_pick_location ?pick_location ?consumable_or_packaging)
        (not
          (pick_location_ready ?pick_location)
        )
      )
    :effect
      (and
        (picker_staged ?location_picker_binding)
        (pick_location_ready ?pick_location)
        (consumable_available ?consumable_or_packaging)
        (not
          (consumable_assigned_to_pick_location ?pick_location ?consumable_or_packaging)
        )
      )
  )
  (:action initialize_handling_unit_assembly
    :parameters (?reserve_location - reserve_location ?pick_location - pick_location ?location_equipment_binding - location_equipment_binding ?location_picker_binding - location_picker_binding ?handling_unit - handling_unit)
    :precondition
      (and
        (reserve_location_marked ?reserve_location)
        (pick_location_marked ?pick_location)
        (location_has_equipment_binding ?reserve_location ?location_equipment_binding)
        (pick_location_picker_binding ?pick_location ?location_picker_binding)
        (equipment_staged ?location_equipment_binding)
        (picker_staged ?location_picker_binding)
        (reserve_location_ready ?reserve_location)
        (pick_location_ready ?pick_location)
        (handling_unit_available_for_assembly ?handling_unit)
      )
    :effect
      (and
        (handling_unit_in_progress ?handling_unit)
        (handling_unit_equipment_bound ?handling_unit ?location_equipment_binding)
        (handling_unit_picker_bound ?handling_unit ?location_picker_binding)
        (not
          (handling_unit_available_for_assembly ?handling_unit)
        )
      )
  )
  (:action initialize_handling_unit_assembly_with_equipment_verification
    :parameters (?reserve_location - reserve_location ?pick_location - pick_location ?location_equipment_binding - location_equipment_binding ?location_picker_binding - location_picker_binding ?handling_unit - handling_unit)
    :precondition
      (and
        (reserve_location_marked ?reserve_location)
        (pick_location_marked ?pick_location)
        (location_has_equipment_binding ?reserve_location ?location_equipment_binding)
        (pick_location_picker_binding ?pick_location ?location_picker_binding)
        (equipment_ready ?location_equipment_binding)
        (picker_staged ?location_picker_binding)
        (not
          (reserve_location_ready ?reserve_location)
        )
        (pick_location_ready ?pick_location)
        (handling_unit_available_for_assembly ?handling_unit)
      )
    :effect
      (and
        (handling_unit_in_progress ?handling_unit)
        (handling_unit_equipment_bound ?handling_unit ?location_equipment_binding)
        (handling_unit_picker_bound ?handling_unit ?location_picker_binding)
        (handling_unit_equipment_verified ?handling_unit)
        (not
          (handling_unit_available_for_assembly ?handling_unit)
        )
      )
  )
  (:action initialize_handling_unit_assembly_with_picker_verification
    :parameters (?reserve_location - reserve_location ?pick_location - pick_location ?location_equipment_binding - location_equipment_binding ?location_picker_binding - location_picker_binding ?handling_unit - handling_unit)
    :precondition
      (and
        (reserve_location_marked ?reserve_location)
        (pick_location_marked ?pick_location)
        (location_has_equipment_binding ?reserve_location ?location_equipment_binding)
        (pick_location_picker_binding ?pick_location ?location_picker_binding)
        (equipment_staged ?location_equipment_binding)
        (picker_ready ?location_picker_binding)
        (reserve_location_ready ?reserve_location)
        (not
          (pick_location_ready ?pick_location)
        )
        (handling_unit_available_for_assembly ?handling_unit)
      )
    :effect
      (and
        (handling_unit_in_progress ?handling_unit)
        (handling_unit_equipment_bound ?handling_unit ?location_equipment_binding)
        (handling_unit_picker_bound ?handling_unit ?location_picker_binding)
        (handling_unit_picker_verified ?handling_unit)
        (not
          (handling_unit_available_for_assembly ?handling_unit)
        )
      )
  )
  (:action initialize_handling_unit_assembly_with_full_verification
    :parameters (?reserve_location - reserve_location ?pick_location - pick_location ?location_equipment_binding - location_equipment_binding ?location_picker_binding - location_picker_binding ?handling_unit - handling_unit)
    :precondition
      (and
        (reserve_location_marked ?reserve_location)
        (pick_location_marked ?pick_location)
        (location_has_equipment_binding ?reserve_location ?location_equipment_binding)
        (pick_location_picker_binding ?pick_location ?location_picker_binding)
        (equipment_ready ?location_equipment_binding)
        (picker_ready ?location_picker_binding)
        (not
          (reserve_location_ready ?reserve_location)
        )
        (not
          (pick_location_ready ?pick_location)
        )
        (handling_unit_available_for_assembly ?handling_unit)
      )
    :effect
      (and
        (handling_unit_in_progress ?handling_unit)
        (handling_unit_equipment_bound ?handling_unit ?location_equipment_binding)
        (handling_unit_picker_bound ?handling_unit ?location_picker_binding)
        (handling_unit_equipment_verified ?handling_unit)
        (handling_unit_picker_verified ?handling_unit)
        (not
          (handling_unit_available_for_assembly ?handling_unit)
        )
      )
  )
  (:action mark_handling_unit_ready_for_slotting
    :parameters (?handling_unit - handling_unit ?reserve_location - reserve_location ?product_sku - product_sku)
    :precondition
      (and
        (handling_unit_in_progress ?handling_unit)
        (reserve_location_marked ?reserve_location)
        (record_has_sku ?reserve_location ?product_sku)
        (not
          (handling_unit_ready_for_slotting ?handling_unit)
        )
      )
    :effect (handling_unit_ready_for_slotting ?handling_unit)
  )
  (:action bind_container_slot_to_handling_unit
    :parameters (?work_task - work_task ?container_slot - container_slot ?handling_unit - handling_unit)
    :precondition
      (and
        (record_ready_for_putaway ?work_task)
        (task_assigned_handling_unit ?work_task ?handling_unit)
        (task_assigned_container_slot ?work_task ?container_slot)
        (container_slot_available ?container_slot)
        (handling_unit_in_progress ?handling_unit)
        (handling_unit_ready_for_slotting ?handling_unit)
        (not
          (container_slot_occupied ?container_slot)
        )
      )
    :effect
      (and
        (container_slot_occupied ?container_slot)
        (container_slot_assigned_to_handling_unit ?container_slot ?handling_unit)
        (not
          (container_slot_available ?container_slot)
        )
      )
  )
  (:action finalize_slotting_for_task
    :parameters (?work_task - work_task ?container_slot - container_slot ?handling_unit - handling_unit ?product_sku - product_sku)
    :precondition
      (and
        (record_ready_for_putaway ?work_task)
        (task_assigned_container_slot ?work_task ?container_slot)
        (container_slot_occupied ?container_slot)
        (container_slot_assigned_to_handling_unit ?container_slot ?handling_unit)
        (record_has_sku ?work_task ?product_sku)
        (not
          (handling_unit_equipment_verified ?handling_unit)
        )
        (not
          (task_slotting_finalized ?work_task)
        )
      )
    :effect (task_slotting_finalized ?work_task)
  )
  (:action assign_label_template_to_task
    :parameters (?work_task - work_task ?label_template - label_template)
    :precondition
      (and
        (record_ready_for_putaway ?work_task)
        (label_template_available ?label_template)
        (not
          (task_has_label_type ?work_task)
        )
      )
    :effect
      (and
        (task_has_label_type ?work_task)
        (task_label_template_assigned ?work_task ?label_template)
        (not
          (label_template_available ?label_template)
        )
      )
  )
  (:action apply_label_template_and_mark_task
    :parameters (?work_task - work_task ?container_slot - container_slot ?handling_unit - handling_unit ?product_sku - product_sku ?label_template - label_template)
    :precondition
      (and
        (record_ready_for_putaway ?work_task)
        (task_assigned_container_slot ?work_task ?container_slot)
        (container_slot_occupied ?container_slot)
        (container_slot_assigned_to_handling_unit ?container_slot ?handling_unit)
        (record_has_sku ?work_task ?product_sku)
        (handling_unit_equipment_verified ?handling_unit)
        (task_has_label_type ?work_task)
        (task_label_template_assigned ?work_task ?label_template)
        (not
          (task_slotting_finalized ?work_task)
        )
      )
    :effect
      (and
        (task_slotting_finalized ?work_task)
        (task_label_printed ?work_task)
      )
  )
  (:action apply_instruction_and_mark_task_labeled
    :parameters (?work_task - work_task ?special_instruction_tag - special_instruction_tag ?equipment_unit - equipment_unit ?container_slot - container_slot ?handling_unit - handling_unit)
    :precondition
      (and
        (task_slotting_finalized ?work_task)
        (task_has_special_instruction ?work_task ?special_instruction_tag)
        (record_assigned_to_equipment ?work_task ?equipment_unit)
        (task_assigned_container_slot ?work_task ?container_slot)
        (container_slot_assigned_to_handling_unit ?container_slot ?handling_unit)
        (not
          (handling_unit_picker_verified ?handling_unit)
        )
        (not
          (task_label_applied ?work_task)
        )
      )
    :effect (task_label_applied ?work_task)
  )
  (:action confirm_instruction_and_mark_task_labeled
    :parameters (?work_task - work_task ?special_instruction_tag - special_instruction_tag ?equipment_unit - equipment_unit ?container_slot - container_slot ?handling_unit - handling_unit)
    :precondition
      (and
        (task_slotting_finalized ?work_task)
        (task_has_special_instruction ?work_task ?special_instruction_tag)
        (record_assigned_to_equipment ?work_task ?equipment_unit)
        (task_assigned_container_slot ?work_task ?container_slot)
        (container_slot_assigned_to_handling_unit ?container_slot ?handling_unit)
        (handling_unit_picker_verified ?handling_unit)
        (not
          (task_label_applied ?work_task)
        )
      )
    :effect (task_label_applied ?work_task)
  )
  (:action prepare_task_for_finalization_with_traceability_token
    :parameters (?work_task - work_task ?traceability_token - traceability_token ?container_slot - container_slot ?handling_unit - handling_unit)
    :precondition
      (and
        (task_label_applied ?work_task)
        (task_has_traceability_token ?work_task ?traceability_token)
        (task_assigned_container_slot ?work_task ?container_slot)
        (container_slot_assigned_to_handling_unit ?container_slot ?handling_unit)
        (not
          (handling_unit_equipment_verified ?handling_unit)
        )
        (not
          (handling_unit_picker_verified ?handling_unit)
        )
        (not
          (task_ready_for_finalization ?work_task)
        )
      )
    :effect (task_ready_for_finalization ?work_task)
  )
  (:action prepare_task_for_finalization_and_attach_document_marker
    :parameters (?work_task - work_task ?traceability_token - traceability_token ?container_slot - container_slot ?handling_unit - handling_unit)
    :precondition
      (and
        (task_label_applied ?work_task)
        (task_has_traceability_token ?work_task ?traceability_token)
        (task_assigned_container_slot ?work_task ?container_slot)
        (container_slot_assigned_to_handling_unit ?container_slot ?handling_unit)
        (handling_unit_equipment_verified ?handling_unit)
        (not
          (handling_unit_picker_verified ?handling_unit)
        )
        (not
          (task_ready_for_finalization ?work_task)
        )
      )
    :effect
      (and
        (task_ready_for_finalization ?work_task)
        (task_has_document_attachment ?work_task)
      )
  )
  (:action verify_task_and_attach_document_marker
    :parameters (?work_task - work_task ?traceability_token - traceability_token ?container_slot - container_slot ?handling_unit - handling_unit)
    :precondition
      (and
        (task_label_applied ?work_task)
        (task_has_traceability_token ?work_task ?traceability_token)
        (task_assigned_container_slot ?work_task ?container_slot)
        (container_slot_assigned_to_handling_unit ?container_slot ?handling_unit)
        (not
          (handling_unit_equipment_verified ?handling_unit)
        )
        (handling_unit_picker_verified ?handling_unit)
        (not
          (task_ready_for_finalization ?work_task)
        )
      )
    :effect
      (and
        (task_ready_for_finalization ?work_task)
        (task_has_document_attachment ?work_task)
      )
  )
  (:action finalize_task_preparation_with_full_verification
    :parameters (?work_task - work_task ?traceability_token - traceability_token ?container_slot - container_slot ?handling_unit - handling_unit)
    :precondition
      (and
        (task_label_applied ?work_task)
        (task_has_traceability_token ?work_task ?traceability_token)
        (task_assigned_container_slot ?work_task ?container_slot)
        (container_slot_assigned_to_handling_unit ?container_slot ?handling_unit)
        (handling_unit_equipment_verified ?handling_unit)
        (handling_unit_picker_verified ?handling_unit)
        (not
          (task_ready_for_finalization ?work_task)
        )
      )
    :effect
      (and
        (task_ready_for_finalization ?work_task)
        (task_has_document_attachment ?work_task)
      )
  )
  (:action close_work_task_and_publish_availability
    :parameters (?work_task - work_task)
    :precondition
      (and
        (task_ready_for_finalization ?work_task)
        (not
          (task_has_document_attachment ?work_task)
        )
        (not
          (task_closed ?work_task)
        )
      )
    :effect
      (and
        (task_closed ?work_task)
        (record_available_for_serial_assignment ?work_task)
      )
  )
  (:action assign_priority_batch_to_task
    :parameters (?work_task - work_task ?work_batch - work_batch)
    :precondition
      (and
        (task_ready_for_finalization ?work_task)
        (task_has_document_attachment ?work_task)
        (work_batch_available ?work_batch)
      )
    :effect
      (and
        (task_has_work_batch ?work_task ?work_batch)
        (not
          (work_batch_available ?work_batch)
        )
      )
  )
  (:action execute_task_and_finalize_contents
    :parameters (?work_task - work_task ?reserve_location - reserve_location ?pick_location - pick_location ?product_sku - product_sku ?work_batch - work_batch)
    :precondition
      (and
        (task_ready_for_finalization ?work_task)
        (task_has_document_attachment ?work_task)
        (task_has_work_batch ?work_task ?work_batch)
        (task_source_location ?work_task ?reserve_location)
        (task_destination_location ?work_task ?pick_location)
        (reserve_location_ready ?reserve_location)
        (pick_location_ready ?pick_location)
        (record_has_sku ?work_task ?product_sku)
        (not
          (task_contents_finalized ?work_task)
        )
      )
    :effect (task_contents_finalized ?work_task)
  )
  (:action finalize_task_and_update_availability
    :parameters (?work_task - work_task)
    :precondition
      (and
        (task_ready_for_finalization ?work_task)
        (task_contents_finalized ?work_task)
        (not
          (task_closed ?work_task)
        )
      )
    :effect
      (and
        (task_closed ?work_task)
        (record_available_for_serial_assignment ?work_task)
      )
  )
  (:action attach_document_to_task
    :parameters (?work_task - work_task ?document_certificate - document_certificate ?product_sku - product_sku)
    :precondition
      (and
        (record_ready_for_putaway ?work_task)
        (record_has_sku ?work_task ?product_sku)
        (document_available ?document_certificate)
        (task_document_assigned ?work_task ?document_certificate)
        (not
          (task_document_bound_flag ?work_task)
        )
      )
    :effect
      (and
        (task_document_bound_flag ?work_task)
        (not
          (document_available ?document_certificate)
        )
      )
  )
  (:action assign_equipment_to_task
    :parameters (?work_task - work_task ?equipment_unit - equipment_unit)
    :precondition
      (and
        (task_document_bound_flag ?work_task)
        (record_assigned_to_equipment ?work_task ?equipment_unit)
        (not
          (task_equipment_assigned ?work_task)
        )
      )
    :effect (task_equipment_assigned ?work_task)
  )
  (:action approve_task_for_completion_with_traceability_token
    :parameters (?work_task - work_task ?traceability_token - traceability_token)
    :precondition
      (and
        (task_equipment_assigned ?work_task)
        (task_has_traceability_token ?work_task ?traceability_token)
        (not
          (task_ready_for_completion ?work_task)
        )
      )
    :effect (task_ready_for_completion ?work_task)
  )
  (:action complete_task_and_update_availability
    :parameters (?work_task - work_task)
    :precondition
      (and
        (task_ready_for_completion ?work_task)
        (not
          (task_closed ?work_task)
        )
      )
    :effect
      (and
        (task_closed ?work_task)
        (record_available_for_serial_assignment ?work_task)
      )
  )
  (:action finalize_location_record_with_handling_unit
    :parameters (?reserve_location - reserve_location ?handling_unit - handling_unit)
    :precondition
      (and
        (reserve_location_marked ?reserve_location)
        (reserve_location_ready ?reserve_location)
        (handling_unit_in_progress ?handling_unit)
        (handling_unit_ready_for_slotting ?handling_unit)
        (not
          (record_available_for_serial_assignment ?reserve_location)
        )
      )
    :effect (record_available_for_serial_assignment ?reserve_location)
  )
  (:action finalize_pick_location_record_with_handling_unit
    :parameters (?pick_location - pick_location ?handling_unit - handling_unit)
    :precondition
      (and
        (pick_location_marked ?pick_location)
        (pick_location_ready ?pick_location)
        (handling_unit_in_progress ?handling_unit)
        (handling_unit_ready_for_slotting ?handling_unit)
        (not
          (record_available_for_serial_assignment ?pick_location)
        )
      )
    :effect (record_available_for_serial_assignment ?pick_location)
  )
  (:action attach_lot_or_serial_id_to_inventory_unit
    :parameters (?inventory_unit - inventory_record ?lot_or_serial_id - lot_or_serial_id ?product_sku - product_sku)
    :precondition
      (and
        (record_available_for_serial_assignment ?inventory_unit)
        (record_has_sku ?inventory_unit ?product_sku)
        (lot_or_serial_id_available ?lot_or_serial_id)
        (not
          (record_lot_or_serial_attached ?inventory_unit)
        )
      )
    :effect
      (and
        (record_lot_or_serial_attached ?inventory_unit)
        (record_has_lot_or_serial_id ?inventory_unit ?lot_or_serial_id)
        (not
          (lot_or_serial_id_available ?lot_or_serial_id)
        )
      )
  )
  (:action complete_putaway_and_release_inbound_shipment_unit
    :parameters (?reserve_location - reserve_location ?inbound_shipment_unit - inbound_shipment_unit ?lot_or_serial_id - lot_or_serial_id)
    :precondition
      (and
        (record_lot_or_serial_attached ?reserve_location)
        (record_assigned_to_inbound_shipment ?reserve_location ?inbound_shipment_unit)
        (record_has_lot_or_serial_id ?reserve_location ?lot_or_serial_id)
        (not
          (finalized ?reserve_location)
        )
      )
    :effect
      (and
        (finalized ?reserve_location)
        (inbound_shipment_unit_available ?inbound_shipment_unit)
        (lot_or_serial_id_available ?lot_or_serial_id)
      )
  )
  (:action complete_putaway_and_release_inbound_for_pick_location
    :parameters (?pick_location - pick_location ?inbound_shipment_unit - inbound_shipment_unit ?lot_or_serial_id - lot_or_serial_id)
    :precondition
      (and
        (record_lot_or_serial_attached ?pick_location)
        (record_assigned_to_inbound_shipment ?pick_location ?inbound_shipment_unit)
        (record_has_lot_or_serial_id ?pick_location ?lot_or_serial_id)
        (not
          (finalized ?pick_location)
        )
      )
    :effect
      (and
        (finalized ?pick_location)
        (inbound_shipment_unit_available ?inbound_shipment_unit)
        (lot_or_serial_id_available ?lot_or_serial_id)
      )
  )
  (:action complete_putaway_and_release_inbound_for_task
    :parameters (?work_task - work_task ?inbound_shipment_unit - inbound_shipment_unit ?lot_or_serial_id - lot_or_serial_id)
    :precondition
      (and
        (record_lot_or_serial_attached ?work_task)
        (record_assigned_to_inbound_shipment ?work_task ?inbound_shipment_unit)
        (record_has_lot_or_serial_id ?work_task ?lot_or_serial_id)
        (not
          (finalized ?work_task)
        )
      )
    :effect
      (and
        (finalized ?work_task)
        (inbound_shipment_unit_available ?inbound_shipment_unit)
        (lot_or_serial_id_available ?lot_or_serial_id)
      )
  )
)

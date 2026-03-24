(define (domain warehouse_inventory_reconciliation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource - object item_grouping - object location_supertype - object inventory_supertype - object inventory_record - inventory_supertype count_equipment - resource counter_operator - resource material_handler - resource label_type - resource inspection_checklist - resource adjustment_reason - resource inspection_device - resource authorization_token - resource count_ticket - item_grouping inventory_lot - item_grouping approver - item_grouping count_zone - location_supertype pick_zone - location_supertype transfer_tote - location_supertype location_record_group - inventory_record reconciliation_batch - inventory_record source_location - location_record_group target_location - location_record_group reconciliation_record - reconciliation_batch)
  (:predicates
    (count_session_open ?inventory_record - inventory_record)
    (count_verified ?inventory_record - inventory_record)
    (equipment_assigned ?inventory_record - inventory_record)
    (record_reconciled ?inventory_record - inventory_record)
    (ready_for_adjustment ?inventory_record - inventory_record)
    (adjustment_applied ?inventory_record - inventory_record)
    (equipment_available ?count_equipment - count_equipment)
    (equipment_assigned_to_record ?inventory_record - inventory_record ?count_equipment - count_equipment)
    (counter_available ?counter_operator - counter_operator)
    (counter_assigned_to_record ?inventory_record - inventory_record ?counter_operator - counter_operator)
    (handler_available ?material_handler - material_handler)
    (handler_assigned_to_record ?inventory_record - inventory_record ?material_handler - material_handler)
    (count_ticket_available ?count_ticket - count_ticket)
    (count_ticket_assigned_to_source_location ?source_location - source_location ?count_ticket - count_ticket)
    (count_ticket_assigned_to_target_location ?target_location - target_location ?count_ticket - count_ticket)
    (location_in_count_zone ?source_location - source_location ?count_zone - count_zone)
    (zone_marked_for_source ?count_zone - count_zone)
    (zone_marked_for_target ?count_zone - count_zone)
    (source_location_staged ?source_location - source_location)
    (target_location_in_pick_zone ?target_location - target_location ?pick_zone - pick_zone)
    (pick_zone_marked ?pick_zone - pick_zone)
    (pick_zone_secondary_marked ?pick_zone - pick_zone)
    (target_location_staged ?target_location - target_location)
    (tote_available ?transfer_tote - transfer_tote)
    (tote_staged ?transfer_tote - transfer_tote)
    (tote_assigned_to_count_zone ?transfer_tote - transfer_tote ?count_zone - count_zone)
    (tote_assigned_to_pick_zone ?transfer_tote - transfer_tote ?pick_zone - pick_zone)
    (tote_needs_labeling ?transfer_tote - transfer_tote)
    (tote_needs_signoff ?transfer_tote - transfer_tote)
    (tote_qc_cleared ?transfer_tote - transfer_tote)
    (reconciliation_record_assigned_source_location ?reconciliation_record - reconciliation_record ?source_location - source_location)
    (reconciliation_record_assigned_target_location ?reconciliation_record - reconciliation_record ?target_location - target_location)
    (reconciliation_record_assigned_tote ?reconciliation_record - reconciliation_record ?transfer_tote - transfer_tote)
    (lot_available ?inventory_lot - inventory_lot)
    (reconciliation_record_has_lot ?reconciliation_record - reconciliation_record ?inventory_lot - inventory_lot)
    (lot_tagged ?inventory_lot - inventory_lot)
    (lot_assigned_to_tote ?inventory_lot - inventory_lot ?transfer_tote - transfer_tote)
    (reconciliation_record_ready_for_labeling ?reconciliation_record - reconciliation_record)
    (reconciliation_record_ready_for_assessment ?reconciliation_record - reconciliation_record)
    (reconciliation_record_needs_approval ?reconciliation_record - reconciliation_record)
    (reconciliation_record_label_assigned ?reconciliation_record - reconciliation_record)
    (reconciliation_record_label_applied ?reconciliation_record - reconciliation_record)
    (reconciliation_record_ready_for_checklist ?reconciliation_record - reconciliation_record)
    (reconciliation_record_qc_completed ?reconciliation_record - reconciliation_record)
    (approver_available ?approver - approver)
    (reconciliation_record_assigned_approver ?reconciliation_record - reconciliation_record ?approver - approver)
    (reconciliation_record_has_pending_approval ?reconciliation_record - reconciliation_record)
    (reconciliation_record_approval_in_progress ?reconciliation_record - reconciliation_record)
    (reconciliation_record_authorized ?reconciliation_record - reconciliation_record)
    (label_type_available ?label_type - label_type)
    (reconciliation_record_label_type_assigned ?reconciliation_record - reconciliation_record ?label_type - label_type)
    (checklist_available ?inspection_checklist - inspection_checklist)
    (reconciliation_record_assigned_checklist ?reconciliation_record - reconciliation_record ?inspection_checklist - inspection_checklist)
    (inspection_device_available ?inspection_device - inspection_device)
    (reconciliation_record_assigned_device ?reconciliation_record - reconciliation_record ?inspection_device - inspection_device)
    (authorization_token_available ?authorization_token - authorization_token)
    (reconciliation_record_assigned_auth_token ?reconciliation_record - reconciliation_record ?authorization_token - authorization_token)
    (adjustment_reason_available ?adjustment_reason - adjustment_reason)
    (inventory_record_has_adjustment_reason ?inventory_record - inventory_record ?adjustment_reason - adjustment_reason)
    (source_location_prepared ?source_location - source_location)
    (target_location_prepared ?target_location - target_location)
    (reconciliation_record_released ?reconciliation_record - reconciliation_record)
  )
  (:action initiate_count_session
    :parameters (?inventory_record - inventory_record)
    :precondition
      (and
        (not
          (count_session_open ?inventory_record)
        )
        (not
          (record_reconciled ?inventory_record)
        )
      )
    :effect (count_session_open ?inventory_record)
  )
  (:action assign_equipment_to_inventory_record
    :parameters (?inventory_record - inventory_record ?count_equipment - count_equipment)
    :precondition
      (and
        (count_session_open ?inventory_record)
        (not
          (equipment_assigned ?inventory_record)
        )
        (equipment_available ?count_equipment)
      )
    :effect
      (and
        (equipment_assigned ?inventory_record)
        (equipment_assigned_to_record ?inventory_record ?count_equipment)
        (not
          (equipment_available ?count_equipment)
        )
      )
  )
  (:action assign_counter_to_inventory_record
    :parameters (?inventory_record - inventory_record ?counter_operator - counter_operator)
    :precondition
      (and
        (count_session_open ?inventory_record)
        (equipment_assigned ?inventory_record)
        (counter_available ?counter_operator)
      )
    :effect
      (and
        (counter_assigned_to_record ?inventory_record ?counter_operator)
        (not
          (counter_available ?counter_operator)
        )
      )
  )
  (:action verify_count_for_inventory_record
    :parameters (?inventory_record - inventory_record ?counter_operator - counter_operator)
    :precondition
      (and
        (count_session_open ?inventory_record)
        (equipment_assigned ?inventory_record)
        (counter_assigned_to_record ?inventory_record ?counter_operator)
        (not
          (count_verified ?inventory_record)
        )
      )
    :effect (count_verified ?inventory_record)
  )
  (:action unassign_counter_from_record
    :parameters (?inventory_record - inventory_record ?counter_operator - counter_operator)
    :precondition
      (and
        (counter_assigned_to_record ?inventory_record ?counter_operator)
      )
    :effect
      (and
        (counter_available ?counter_operator)
        (not
          (counter_assigned_to_record ?inventory_record ?counter_operator)
        )
      )
  )
  (:action assign_handler_to_verified_record
    :parameters (?inventory_record - inventory_record ?material_handler - material_handler)
    :precondition
      (and
        (count_verified ?inventory_record)
        (handler_available ?material_handler)
      )
    :effect
      (and
        (handler_assigned_to_record ?inventory_record ?material_handler)
        (not
          (handler_available ?material_handler)
        )
      )
  )
  (:action unassign_handler_from_record
    :parameters (?inventory_record - inventory_record ?material_handler - material_handler)
    :precondition
      (and
        (handler_assigned_to_record ?inventory_record ?material_handler)
      )
    :effect
      (and
        (handler_available ?material_handler)
        (not
          (handler_assigned_to_record ?inventory_record ?material_handler)
        )
      )
  )
  (:action allocate_inspection_device_to_reconciliation_record
    :parameters (?reconciliation_record - reconciliation_record ?inspection_device - inspection_device)
    :precondition
      (and
        (count_verified ?reconciliation_record)
        (inspection_device_available ?inspection_device)
      )
    :effect
      (and
        (reconciliation_record_assigned_device ?reconciliation_record ?inspection_device)
        (not
          (inspection_device_available ?inspection_device)
        )
      )
  )
  (:action release_inspection_device_from_reconciliation_record
    :parameters (?reconciliation_record - reconciliation_record ?inspection_device - inspection_device)
    :precondition
      (and
        (reconciliation_record_assigned_device ?reconciliation_record ?inspection_device)
      )
    :effect
      (and
        (inspection_device_available ?inspection_device)
        (not
          (reconciliation_record_assigned_device ?reconciliation_record ?inspection_device)
        )
      )
  )
  (:action allocate_authorization_token_to_reconciliation_record
    :parameters (?reconciliation_record - reconciliation_record ?authorization_token - authorization_token)
    :precondition
      (and
        (count_verified ?reconciliation_record)
        (authorization_token_available ?authorization_token)
      )
    :effect
      (and
        (reconciliation_record_assigned_auth_token ?reconciliation_record ?authorization_token)
        (not
          (authorization_token_available ?authorization_token)
        )
      )
  )
  (:action release_authorization_token_from_reconciliation_record
    :parameters (?reconciliation_record - reconciliation_record ?authorization_token - authorization_token)
    :precondition
      (and
        (reconciliation_record_assigned_auth_token ?reconciliation_record ?authorization_token)
      )
    :effect
      (and
        (authorization_token_available ?authorization_token)
        (not
          (reconciliation_record_assigned_auth_token ?reconciliation_record ?authorization_token)
        )
      )
  )
  (:action mark_count_zone_for_source
    :parameters (?source_location - source_location ?count_zone - count_zone ?counter_operator - counter_operator)
    :precondition
      (and
        (count_verified ?source_location)
        (counter_assigned_to_record ?source_location ?counter_operator)
        (location_in_count_zone ?source_location ?count_zone)
        (not
          (zone_marked_for_source ?count_zone)
        )
        (not
          (zone_marked_for_target ?count_zone)
        )
      )
    :effect (zone_marked_for_source ?count_zone)
  )
  (:action stage_source_location_for_transfer
    :parameters (?source_location - source_location ?count_zone - count_zone ?material_handler - material_handler)
    :precondition
      (and
        (count_verified ?source_location)
        (handler_assigned_to_record ?source_location ?material_handler)
        (location_in_count_zone ?source_location ?count_zone)
        (zone_marked_for_source ?count_zone)
        (not
          (source_location_prepared ?source_location)
        )
      )
    :effect
      (and
        (source_location_prepared ?source_location)
        (source_location_staged ?source_location)
      )
  )
  (:action assign_count_ticket_and_stage_source_location
    :parameters (?source_location - source_location ?count_zone - count_zone ?count_ticket - count_ticket)
    :precondition
      (and
        (count_verified ?source_location)
        (location_in_count_zone ?source_location ?count_zone)
        (count_ticket_available ?count_ticket)
        (not
          (source_location_prepared ?source_location)
        )
      )
    :effect
      (and
        (zone_marked_for_target ?count_zone)
        (source_location_prepared ?source_location)
        (count_ticket_assigned_to_source_location ?source_location ?count_ticket)
        (not
          (count_ticket_available ?count_ticket)
        )
      )
  )
  (:action finalize_ticket_and_mark_source_location
    :parameters (?source_location - source_location ?count_zone - count_zone ?counter_operator - counter_operator ?count_ticket - count_ticket)
    :precondition
      (and
        (count_verified ?source_location)
        (counter_assigned_to_record ?source_location ?counter_operator)
        (location_in_count_zone ?source_location ?count_zone)
        (zone_marked_for_target ?count_zone)
        (count_ticket_assigned_to_source_location ?source_location ?count_ticket)
        (not
          (source_location_staged ?source_location)
        )
      )
    :effect
      (and
        (zone_marked_for_source ?count_zone)
        (source_location_staged ?source_location)
        (count_ticket_available ?count_ticket)
        (not
          (count_ticket_assigned_to_source_location ?source_location ?count_ticket)
        )
      )
  )
  (:action mark_pick_zone_for_target_location
    :parameters (?target_location - target_location ?pick_zone - pick_zone ?counter_operator - counter_operator)
    :precondition
      (and
        (count_verified ?target_location)
        (counter_assigned_to_record ?target_location ?counter_operator)
        (target_location_in_pick_zone ?target_location ?pick_zone)
        (not
          (pick_zone_marked ?pick_zone)
        )
        (not
          (pick_zone_secondary_marked ?pick_zone)
        )
      )
    :effect (pick_zone_marked ?pick_zone)
  )
  (:action stage_target_location_for_transfer
    :parameters (?target_location - target_location ?pick_zone - pick_zone ?material_handler - material_handler)
    :precondition
      (and
        (count_verified ?target_location)
        (handler_assigned_to_record ?target_location ?material_handler)
        (target_location_in_pick_zone ?target_location ?pick_zone)
        (pick_zone_marked ?pick_zone)
        (not
          (target_location_prepared ?target_location)
        )
      )
    :effect
      (and
        (target_location_prepared ?target_location)
        (target_location_staged ?target_location)
      )
  )
  (:action assign_ticket_to_target_location
    :parameters (?target_location - target_location ?pick_zone - pick_zone ?count_ticket - count_ticket)
    :precondition
      (and
        (count_verified ?target_location)
        (target_location_in_pick_zone ?target_location ?pick_zone)
        (count_ticket_available ?count_ticket)
        (not
          (target_location_prepared ?target_location)
        )
      )
    :effect
      (and
        (pick_zone_secondary_marked ?pick_zone)
        (target_location_prepared ?target_location)
        (count_ticket_assigned_to_target_location ?target_location ?count_ticket)
        (not
          (count_ticket_available ?count_ticket)
        )
      )
  )
  (:action finalize_ticket_and_mark_target_location
    :parameters (?target_location - target_location ?pick_zone - pick_zone ?counter_operator - counter_operator ?count_ticket - count_ticket)
    :precondition
      (and
        (count_verified ?target_location)
        (counter_assigned_to_record ?target_location ?counter_operator)
        (target_location_in_pick_zone ?target_location ?pick_zone)
        (pick_zone_secondary_marked ?pick_zone)
        (count_ticket_assigned_to_target_location ?target_location ?count_ticket)
        (not
          (target_location_staged ?target_location)
        )
      )
    :effect
      (and
        (pick_zone_marked ?pick_zone)
        (target_location_staged ?target_location)
        (count_ticket_available ?count_ticket)
        (not
          (count_ticket_assigned_to_target_location ?target_location ?count_ticket)
        )
      )
  )
  (:action assemble_and_stage_transfer_tote
    :parameters (?source_location - source_location ?target_location - target_location ?count_zone - count_zone ?pick_zone - pick_zone ?transfer_tote - transfer_tote)
    :precondition
      (and
        (source_location_prepared ?source_location)
        (target_location_prepared ?target_location)
        (location_in_count_zone ?source_location ?count_zone)
        (target_location_in_pick_zone ?target_location ?pick_zone)
        (zone_marked_for_source ?count_zone)
        (pick_zone_marked ?pick_zone)
        (source_location_staged ?source_location)
        (target_location_staged ?target_location)
        (tote_available ?transfer_tote)
      )
    :effect
      (and
        (tote_staged ?transfer_tote)
        (tote_assigned_to_count_zone ?transfer_tote ?count_zone)
        (tote_assigned_to_pick_zone ?transfer_tote ?pick_zone)
        (not
          (tote_available ?transfer_tote)
        )
      )
  )
  (:action stage_transfer_tote_with_label_requirement
    :parameters (?source_location - source_location ?target_location - target_location ?count_zone - count_zone ?pick_zone - pick_zone ?transfer_tote - transfer_tote)
    :precondition
      (and
        (source_location_prepared ?source_location)
        (target_location_prepared ?target_location)
        (location_in_count_zone ?source_location ?count_zone)
        (target_location_in_pick_zone ?target_location ?pick_zone)
        (zone_marked_for_target ?count_zone)
        (pick_zone_marked ?pick_zone)
        (not
          (source_location_staged ?source_location)
        )
        (target_location_staged ?target_location)
        (tote_available ?transfer_tote)
      )
    :effect
      (and
        (tote_staged ?transfer_tote)
        (tote_assigned_to_count_zone ?transfer_tote ?count_zone)
        (tote_assigned_to_pick_zone ?transfer_tote ?pick_zone)
        (tote_needs_labeling ?transfer_tote)
        (not
          (tote_available ?transfer_tote)
        )
      )
  )
  (:action stage_transfer_tote_with_signoff_requirement
    :parameters (?source_location - source_location ?target_location - target_location ?count_zone - count_zone ?pick_zone - pick_zone ?transfer_tote - transfer_tote)
    :precondition
      (and
        (source_location_prepared ?source_location)
        (target_location_prepared ?target_location)
        (location_in_count_zone ?source_location ?count_zone)
        (target_location_in_pick_zone ?target_location ?pick_zone)
        (zone_marked_for_source ?count_zone)
        (pick_zone_secondary_marked ?pick_zone)
        (source_location_staged ?source_location)
        (not
          (target_location_staged ?target_location)
        )
        (tote_available ?transfer_tote)
      )
    :effect
      (and
        (tote_staged ?transfer_tote)
        (tote_assigned_to_count_zone ?transfer_tote ?count_zone)
        (tote_assigned_to_pick_zone ?transfer_tote ?pick_zone)
        (tote_needs_signoff ?transfer_tote)
        (not
          (tote_available ?transfer_tote)
        )
      )
  )
  (:action stage_transfer_tote_with_label_and_signoff
    :parameters (?source_location - source_location ?target_location - target_location ?count_zone - count_zone ?pick_zone - pick_zone ?transfer_tote - transfer_tote)
    :precondition
      (and
        (source_location_prepared ?source_location)
        (target_location_prepared ?target_location)
        (location_in_count_zone ?source_location ?count_zone)
        (target_location_in_pick_zone ?target_location ?pick_zone)
        (zone_marked_for_target ?count_zone)
        (pick_zone_secondary_marked ?pick_zone)
        (not
          (source_location_staged ?source_location)
        )
        (not
          (target_location_staged ?target_location)
        )
        (tote_available ?transfer_tote)
      )
    :effect
      (and
        (tote_staged ?transfer_tote)
        (tote_assigned_to_count_zone ?transfer_tote ?count_zone)
        (tote_assigned_to_pick_zone ?transfer_tote ?pick_zone)
        (tote_needs_labeling ?transfer_tote)
        (tote_needs_signoff ?transfer_tote)
        (not
          (tote_available ?transfer_tote)
        )
      )
  )
  (:action mark_tote_qc_cleared
    :parameters (?transfer_tote - transfer_tote ?source_location - source_location ?counter_operator - counter_operator)
    :precondition
      (and
        (tote_staged ?transfer_tote)
        (source_location_prepared ?source_location)
        (counter_assigned_to_record ?source_location ?counter_operator)
        (not
          (tote_qc_cleared ?transfer_tote)
        )
      )
    :effect (tote_qc_cleared ?transfer_tote)
  )
  (:action associate_lot_with_tote
    :parameters (?reconciliation_record - reconciliation_record ?inventory_lot - inventory_lot ?transfer_tote - transfer_tote)
    :precondition
      (and
        (count_verified ?reconciliation_record)
        (reconciliation_record_assigned_tote ?reconciliation_record ?transfer_tote)
        (reconciliation_record_has_lot ?reconciliation_record ?inventory_lot)
        (lot_available ?inventory_lot)
        (tote_staged ?transfer_tote)
        (tote_qc_cleared ?transfer_tote)
        (not
          (lot_tagged ?inventory_lot)
        )
      )
    :effect
      (and
        (lot_tagged ?inventory_lot)
        (lot_assigned_to_tote ?inventory_lot ?transfer_tote)
        (not
          (lot_available ?inventory_lot)
        )
      )
  )
  (:action mark_reconciliation_record_ready_for_tote_processing
    :parameters (?reconciliation_record - reconciliation_record ?inventory_lot - inventory_lot ?transfer_tote - transfer_tote ?counter_operator - counter_operator)
    :precondition
      (and
        (count_verified ?reconciliation_record)
        (reconciliation_record_has_lot ?reconciliation_record ?inventory_lot)
        (lot_tagged ?inventory_lot)
        (lot_assigned_to_tote ?inventory_lot ?transfer_tote)
        (counter_assigned_to_record ?reconciliation_record ?counter_operator)
        (not
          (tote_needs_labeling ?transfer_tote)
        )
        (not
          (reconciliation_record_ready_for_labeling ?reconciliation_record)
        )
      )
    :effect (reconciliation_record_ready_for_labeling ?reconciliation_record)
  )
  (:action assign_label_type_to_reconciliation_record
    :parameters (?reconciliation_record - reconciliation_record ?label_type - label_type)
    :precondition
      (and
        (count_verified ?reconciliation_record)
        (label_type_available ?label_type)
        (not
          (reconciliation_record_label_assigned ?reconciliation_record)
        )
      )
    :effect
      (and
        (reconciliation_record_label_assigned ?reconciliation_record)
        (reconciliation_record_label_type_assigned ?reconciliation_record ?label_type)
        (not
          (label_type_available ?label_type)
        )
      )
  )
  (:action apply_label_and_mark_reconciliation_record
    :parameters (?reconciliation_record - reconciliation_record ?inventory_lot - inventory_lot ?transfer_tote - transfer_tote ?counter_operator - counter_operator ?label_type - label_type)
    :precondition
      (and
        (count_verified ?reconciliation_record)
        (reconciliation_record_has_lot ?reconciliation_record ?inventory_lot)
        (lot_tagged ?inventory_lot)
        (lot_assigned_to_tote ?inventory_lot ?transfer_tote)
        (counter_assigned_to_record ?reconciliation_record ?counter_operator)
        (tote_needs_labeling ?transfer_tote)
        (reconciliation_record_label_assigned ?reconciliation_record)
        (reconciliation_record_label_type_assigned ?reconciliation_record ?label_type)
        (not
          (reconciliation_record_ready_for_labeling ?reconciliation_record)
        )
      )
    :effect
      (and
        (reconciliation_record_ready_for_labeling ?reconciliation_record)
        (reconciliation_record_label_applied ?reconciliation_record)
      )
  )
  (:action mark_reconciliation_record_ready_for_assessment
    :parameters (?reconciliation_record - reconciliation_record ?inspection_device - inspection_device ?material_handler - material_handler ?inventory_lot - inventory_lot ?transfer_tote - transfer_tote)
    :precondition
      (and
        (reconciliation_record_ready_for_labeling ?reconciliation_record)
        (reconciliation_record_assigned_device ?reconciliation_record ?inspection_device)
        (handler_assigned_to_record ?reconciliation_record ?material_handler)
        (reconciliation_record_has_lot ?reconciliation_record ?inventory_lot)
        (lot_assigned_to_tote ?inventory_lot ?transfer_tote)
        (not
          (tote_needs_signoff ?transfer_tote)
        )
        (not
          (reconciliation_record_ready_for_assessment ?reconciliation_record)
        )
      )
    :effect (reconciliation_record_ready_for_assessment ?reconciliation_record)
  )
  (:action confirm_reconciliation_record_assessment
    :parameters (?reconciliation_record - reconciliation_record ?inspection_device - inspection_device ?material_handler - material_handler ?inventory_lot - inventory_lot ?transfer_tote - transfer_tote)
    :precondition
      (and
        (reconciliation_record_ready_for_labeling ?reconciliation_record)
        (reconciliation_record_assigned_device ?reconciliation_record ?inspection_device)
        (handler_assigned_to_record ?reconciliation_record ?material_handler)
        (reconciliation_record_has_lot ?reconciliation_record ?inventory_lot)
        (lot_assigned_to_tote ?inventory_lot ?transfer_tote)
        (tote_needs_signoff ?transfer_tote)
        (not
          (reconciliation_record_ready_for_assessment ?reconciliation_record)
        )
      )
    :effect (reconciliation_record_ready_for_assessment ?reconciliation_record)
  )
  (:action escalate_reconciliation_record_for_authorization_request
    :parameters (?reconciliation_record - reconciliation_record ?authorization_token - authorization_token ?inventory_lot - inventory_lot ?transfer_tote - transfer_tote)
    :precondition
      (and
        (reconciliation_record_ready_for_assessment ?reconciliation_record)
        (reconciliation_record_assigned_auth_token ?reconciliation_record ?authorization_token)
        (reconciliation_record_has_lot ?reconciliation_record ?inventory_lot)
        (lot_assigned_to_tote ?inventory_lot ?transfer_tote)
        (not
          (tote_needs_labeling ?transfer_tote)
        )
        (not
          (tote_needs_signoff ?transfer_tote)
        )
        (not
          (reconciliation_record_needs_approval ?reconciliation_record)
        )
      )
    :effect (reconciliation_record_needs_approval ?reconciliation_record)
  )
  (:action conditionally_escalate_reconciliation_record_with_label
    :parameters (?reconciliation_record - reconciliation_record ?authorization_token - authorization_token ?inventory_lot - inventory_lot ?transfer_tote - transfer_tote)
    :precondition
      (and
        (reconciliation_record_ready_for_assessment ?reconciliation_record)
        (reconciliation_record_assigned_auth_token ?reconciliation_record ?authorization_token)
        (reconciliation_record_has_lot ?reconciliation_record ?inventory_lot)
        (lot_assigned_to_tote ?inventory_lot ?transfer_tote)
        (tote_needs_labeling ?transfer_tote)
        (not
          (tote_needs_signoff ?transfer_tote)
        )
        (not
          (reconciliation_record_needs_approval ?reconciliation_record)
        )
      )
    :effect
      (and
        (reconciliation_record_needs_approval ?reconciliation_record)
        (reconciliation_record_ready_for_checklist ?reconciliation_record)
      )
  )
  (:action escalate_reconciliation_record_with_alternate_conditions
    :parameters (?reconciliation_record - reconciliation_record ?authorization_token - authorization_token ?inventory_lot - inventory_lot ?transfer_tote - transfer_tote)
    :precondition
      (and
        (reconciliation_record_ready_for_assessment ?reconciliation_record)
        (reconciliation_record_assigned_auth_token ?reconciliation_record ?authorization_token)
        (reconciliation_record_has_lot ?reconciliation_record ?inventory_lot)
        (lot_assigned_to_tote ?inventory_lot ?transfer_tote)
        (not
          (tote_needs_labeling ?transfer_tote)
        )
        (tote_needs_signoff ?transfer_tote)
        (not
          (reconciliation_record_needs_approval ?reconciliation_record)
        )
      )
    :effect
      (and
        (reconciliation_record_needs_approval ?reconciliation_record)
        (reconciliation_record_ready_for_checklist ?reconciliation_record)
      )
  )
  (:action escalate_reconciliation_record_with_full_conditions
    :parameters (?reconciliation_record - reconciliation_record ?authorization_token - authorization_token ?inventory_lot - inventory_lot ?transfer_tote - transfer_tote)
    :precondition
      (and
        (reconciliation_record_ready_for_assessment ?reconciliation_record)
        (reconciliation_record_assigned_auth_token ?reconciliation_record ?authorization_token)
        (reconciliation_record_has_lot ?reconciliation_record ?inventory_lot)
        (lot_assigned_to_tote ?inventory_lot ?transfer_tote)
        (tote_needs_labeling ?transfer_tote)
        (tote_needs_signoff ?transfer_tote)
        (not
          (reconciliation_record_needs_approval ?reconciliation_record)
        )
      )
    :effect
      (and
        (reconciliation_record_needs_approval ?reconciliation_record)
        (reconciliation_record_ready_for_checklist ?reconciliation_record)
      )
  )
  (:action finalize_reconciliation_record_labeling_and_mark_ready
    :parameters (?reconciliation_record - reconciliation_record)
    :precondition
      (and
        (reconciliation_record_needs_approval ?reconciliation_record)
        (not
          (reconciliation_record_ready_for_checklist ?reconciliation_record)
        )
        (not
          (reconciliation_record_released ?reconciliation_record)
        )
      )
    :effect
      (and
        (reconciliation_record_released ?reconciliation_record)
        (ready_for_adjustment ?reconciliation_record)
      )
  )
  (:action assign_checklist_to_reconciliation_record
    :parameters (?reconciliation_record - reconciliation_record ?inspection_checklist - inspection_checklist)
    :precondition
      (and
        (reconciliation_record_needs_approval ?reconciliation_record)
        (reconciliation_record_ready_for_checklist ?reconciliation_record)
        (checklist_available ?inspection_checklist)
      )
    :effect
      (and
        (reconciliation_record_assigned_checklist ?reconciliation_record ?inspection_checklist)
        (not
          (checklist_available ?inspection_checklist)
        )
      )
  )
  (:action perform_final_quality_checks
    :parameters (?reconciliation_record - reconciliation_record ?source_location - source_location ?target_location - target_location ?counter_operator - counter_operator ?inspection_checklist - inspection_checklist)
    :precondition
      (and
        (reconciliation_record_needs_approval ?reconciliation_record)
        (reconciliation_record_ready_for_checklist ?reconciliation_record)
        (reconciliation_record_assigned_checklist ?reconciliation_record ?inspection_checklist)
        (reconciliation_record_assigned_source_location ?reconciliation_record ?source_location)
        (reconciliation_record_assigned_target_location ?reconciliation_record ?target_location)
        (source_location_staged ?source_location)
        (target_location_staged ?target_location)
        (counter_assigned_to_record ?reconciliation_record ?counter_operator)
        (not
          (reconciliation_record_qc_completed ?reconciliation_record)
        )
      )
    :effect (reconciliation_record_qc_completed ?reconciliation_record)
  )
  (:action release_reconciliation_record_after_final_checks
    :parameters (?reconciliation_record - reconciliation_record)
    :precondition
      (and
        (reconciliation_record_needs_approval ?reconciliation_record)
        (reconciliation_record_qc_completed ?reconciliation_record)
        (not
          (reconciliation_record_released ?reconciliation_record)
        )
      )
    :effect
      (and
        (reconciliation_record_released ?reconciliation_record)
        (ready_for_adjustment ?reconciliation_record)
      )
  )
  (:action request_reconciliation_record_approval_from_approver
    :parameters (?reconciliation_record - reconciliation_record ?approver - approver ?counter_operator - counter_operator)
    :precondition
      (and
        (count_verified ?reconciliation_record)
        (counter_assigned_to_record ?reconciliation_record ?counter_operator)
        (approver_available ?approver)
        (reconciliation_record_assigned_approver ?reconciliation_record ?approver)
        (not
          (reconciliation_record_has_pending_approval ?reconciliation_record)
        )
      )
    :effect
      (and
        (reconciliation_record_has_pending_approval ?reconciliation_record)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action mark_reconciliation_record_approval_in_progress
    :parameters (?reconciliation_record - reconciliation_record ?material_handler - material_handler)
    :precondition
      (and
        (reconciliation_record_has_pending_approval ?reconciliation_record)
        (handler_assigned_to_record ?reconciliation_record ?material_handler)
        (not
          (reconciliation_record_approval_in_progress ?reconciliation_record)
        )
      )
    :effect (reconciliation_record_approval_in_progress ?reconciliation_record)
  )
  (:action authorize_reconciliation_record_with_token
    :parameters (?reconciliation_record - reconciliation_record ?authorization_token - authorization_token)
    :precondition
      (and
        (reconciliation_record_approval_in_progress ?reconciliation_record)
        (reconciliation_record_assigned_auth_token ?reconciliation_record ?authorization_token)
        (not
          (reconciliation_record_authorized ?reconciliation_record)
        )
      )
    :effect (reconciliation_record_authorized ?reconciliation_record)
  )
  (:action release_reconciliation_record_after_authorization
    :parameters (?reconciliation_record - reconciliation_record)
    :precondition
      (and
        (reconciliation_record_authorized ?reconciliation_record)
        (not
          (reconciliation_record_released ?reconciliation_record)
        )
      )
    :effect
      (and
        (reconciliation_record_released ?reconciliation_record)
        (ready_for_adjustment ?reconciliation_record)
      )
  )
  (:action release_source_location_after_tote_processing
    :parameters (?source_location - source_location ?transfer_tote - transfer_tote)
    :precondition
      (and
        (source_location_prepared ?source_location)
        (source_location_staged ?source_location)
        (tote_staged ?transfer_tote)
        (tote_qc_cleared ?transfer_tote)
        (not
          (ready_for_adjustment ?source_location)
        )
      )
    :effect (ready_for_adjustment ?source_location)
  )
  (:action release_target_location_after_tote_processing
    :parameters (?target_location - target_location ?transfer_tote - transfer_tote)
    :precondition
      (and
        (target_location_prepared ?target_location)
        (target_location_staged ?target_location)
        (tote_staged ?transfer_tote)
        (tote_qc_cleared ?transfer_tote)
        (not
          (ready_for_adjustment ?target_location)
        )
      )
    :effect (ready_for_adjustment ?target_location)
  )
  (:action record_adjustment_on_inventory_record
    :parameters (?inventory_record - inventory_record ?adjustment_reason - adjustment_reason ?counter_operator - counter_operator)
    :precondition
      (and
        (ready_for_adjustment ?inventory_record)
        (counter_assigned_to_record ?inventory_record ?counter_operator)
        (adjustment_reason_available ?adjustment_reason)
        (not
          (adjustment_applied ?inventory_record)
        )
      )
    :effect
      (and
        (adjustment_applied ?inventory_record)
        (inventory_record_has_adjustment_reason ?inventory_record ?adjustment_reason)
        (not
          (adjustment_reason_available ?adjustment_reason)
        )
      )
  )
  (:action finalize_reconciliation_for_source_location
    :parameters (?source_location - source_location ?count_equipment - count_equipment ?adjustment_reason - adjustment_reason)
    :precondition
      (and
        (adjustment_applied ?source_location)
        (equipment_assigned_to_record ?source_location ?count_equipment)
        (inventory_record_has_adjustment_reason ?source_location ?adjustment_reason)
        (not
          (record_reconciled ?source_location)
        )
      )
    :effect
      (and
        (record_reconciled ?source_location)
        (equipment_available ?count_equipment)
        (adjustment_reason_available ?adjustment_reason)
      )
  )
  (:action finalize_reconciliation_for_target_location
    :parameters (?target_location - target_location ?count_equipment - count_equipment ?adjustment_reason - adjustment_reason)
    :precondition
      (and
        (adjustment_applied ?target_location)
        (equipment_assigned_to_record ?target_location ?count_equipment)
        (inventory_record_has_adjustment_reason ?target_location ?adjustment_reason)
        (not
          (record_reconciled ?target_location)
        )
      )
    :effect
      (and
        (record_reconciled ?target_location)
        (equipment_available ?count_equipment)
        (adjustment_reason_available ?adjustment_reason)
      )
  )
  (:action finalize_reconciliation_for_reconciliation_record
    :parameters (?reconciliation_record - reconciliation_record ?count_equipment - count_equipment ?adjustment_reason - adjustment_reason)
    :precondition
      (and
        (adjustment_applied ?reconciliation_record)
        (equipment_assigned_to_record ?reconciliation_record ?count_equipment)
        (inventory_record_has_adjustment_reason ?reconciliation_record ?adjustment_reason)
        (not
          (record_reconciled ?reconciliation_record)
        )
      )
    :effect
      (and
        (record_reconciled ?reconciliation_record)
        (equipment_available ?count_equipment)
        (adjustment_reason_available ?adjustment_reason)
      )
  )
)

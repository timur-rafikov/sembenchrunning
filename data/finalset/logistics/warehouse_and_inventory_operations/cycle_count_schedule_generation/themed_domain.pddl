(define (domain cycle_count_schedule_generation)
  (:requirements :strips :typing :negative-preconditions)
  (:types schedule_component_base - object inventory_component_base - object area_base - object location_base - object count_target - location_base operator - schedule_component_base operator_shift - schedule_component_base verifier - schedule_component_base location_label - schedule_component_base count_protocol - schedule_component_base audit_token - schedule_component_base quality_check_type - schedule_component_base approval_token - schedule_component_base count_device - inventory_component_base inventory_item - inventory_component_base approver_role - inventory_component_base zone - area_base subzone - area_base count_batch - area_base location_unit - count_target schedule_container - count_target count_location - location_unit alternate_count_location - location_unit schedule_entry - schedule_container)
  (:predicates
    (count_target_flagged ?location_group - count_target)
    (count_target_scheduled ?location_group - count_target)
    (count_target_operator_allocated ?location_group - count_target)
    (count_finalized ?location_group - count_target)
    (ready_for_count ?location_group - count_target)
    (count_submitted ?location_group - count_target)
    (operator_available ?operator - operator)
    (assigned_operator ?location_group - count_target ?operator - operator)
    (operator_shift_available ?time_slot - operator_shift)
    (assigned_shift ?location_group - count_target ?time_slot - operator_shift)
    (verifier_available ?verifier - verifier)
    (assigned_verifier ?location_group - count_target ?verifier - verifier)
    (device_available ?count_device - count_device)
    (location_assigned_device ?count_location - count_location ?count_device - count_device)
    (alt_location_assigned_device ?alternate_count_location - alternate_count_location ?count_device - count_device)
    (located_in_zone ?count_location - count_location ?zone - zone)
    (zone_prepared ?zone - zone)
    (zone_device_staged ?zone - zone)
    (count_location_prepared ?count_location - count_location)
    (alt_location_assigned_subzone ?alternate_count_location - alternate_count_location ?subzone - subzone)
    (subzone_prepared ?subzone - subzone)
    (subzone_device_staged ?subzone - subzone)
    (alt_count_location_prepared ?alternate_count_location - alternate_count_location)
    (count_batch_open ?count_batch - count_batch)
    (count_batch_prepared ?count_batch - count_batch)
    (batch_assigned_zone ?count_batch - count_batch ?zone - zone)
    (batch_assigned_subzone ?count_batch - count_batch ?subzone - subzone)
    (batch_needs_quality_check ?count_batch - count_batch)
    (batch_needs_approval ?count_batch - count_batch)
    (batch_ready_for_item_selection ?count_batch - count_batch)
    (entry_includes_location ?schedule_entry - schedule_entry ?count_location - count_location)
    (entry_includes_alt_location ?schedule_entry - schedule_entry ?alternate_count_location - alternate_count_location)
    (entry_includes_batch ?schedule_entry - schedule_entry ?count_batch - count_batch)
    (inventory_item_available ?inventory_item - inventory_item)
    (entry_includes_item ?schedule_entry - schedule_entry ?inventory_item - inventory_item)
    (inventory_item_staged ?inventory_item - inventory_item)
    (item_assigned_to_batch ?inventory_item - inventory_item ?count_batch - count_batch)
    (entry_prepared ?schedule_entry - schedule_entry)
    (entry_checked ?schedule_entry - schedule_entry)
    (entry_ready ?schedule_entry - schedule_entry)
    (label_attached ?schedule_entry - schedule_entry)
    (entry_label_verified ?schedule_entry - schedule_entry)
    (protocol_attached ?schedule_entry - schedule_entry)
    (entry_checks_complete ?schedule_entry - schedule_entry)
    (approver_available ?approver_role - approver_role)
    (entry_assigned_approver ?schedule_entry - schedule_entry ?approver_role - approver_role)
    (approval_assigned ?schedule_entry - schedule_entry)
    (approval_requested ?schedule_entry - schedule_entry)
    (approval_granted ?schedule_entry - schedule_entry)
    (location_label_available ?location_label - location_label)
    (entry_assigned_label ?schedule_entry - schedule_entry ?location_label - location_label)
    (protocol_available ?count_protocol - count_protocol)
    (entry_assigned_protocol ?schedule_entry - schedule_entry ?count_protocol - count_protocol)
    (quality_check_available ?quality_check_type - quality_check_type)
    (entry_assigned_quality_check ?schedule_entry - schedule_entry ?quality_check_type - quality_check_type)
    (approval_token_available ?approval_token - approval_token)
    (entry_assigned_approval_token ?schedule_entry - schedule_entry ?approval_token - approval_token)
    (audit_token_available ?audit_token - audit_token)
    (location_assigned_audit_token ?location_group - count_target ?audit_token - audit_token)
    (location_staged_for_batch ?count_location - count_location)
    (alt_location_staged_for_batch ?alternate_count_location - alternate_count_location)
    (entry_execution_mark ?schedule_entry - schedule_entry)
  )
  (:action flag_location_group
    :parameters (?location_group - count_target)
    :precondition
      (and
        (not
          (count_target_flagged ?location_group)
        )
        (not
          (count_finalized ?location_group)
        )
      )
    :effect (count_target_flagged ?location_group)
  )
  (:action assign_operator_to_group
    :parameters (?location_group - count_target ?operator - operator)
    :precondition
      (and
        (count_target_flagged ?location_group)
        (not
          (count_target_operator_allocated ?location_group)
        )
        (operator_available ?operator)
      )
    :effect
      (and
        (count_target_operator_allocated ?location_group)
        (assigned_operator ?location_group ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action assign_time_slot_to_group
    :parameters (?location_group - count_target ?time_slot - operator_shift)
    :precondition
      (and
        (count_target_flagged ?location_group)
        (count_target_operator_allocated ?location_group)
        (operator_shift_available ?time_slot)
      )
    :effect
      (and
        (assigned_shift ?location_group ?time_slot)
        (not
          (operator_shift_available ?time_slot)
        )
      )
  )
  (:action confirm_group_schedule
    :parameters (?location_group - count_target ?time_slot - operator_shift)
    :precondition
      (and
        (count_target_flagged ?location_group)
        (count_target_operator_allocated ?location_group)
        (assigned_shift ?location_group ?time_slot)
        (not
          (count_target_scheduled ?location_group)
        )
      )
    :effect (count_target_scheduled ?location_group)
  )
  (:action release_time_slot_from_group
    :parameters (?location_group - count_target ?time_slot - operator_shift)
    :precondition
      (and
        (assigned_shift ?location_group ?time_slot)
      )
    :effect
      (and
        (operator_shift_available ?time_slot)
        (not
          (assigned_shift ?location_group ?time_slot)
        )
      )
  )
  (:action assign_verifier_to_group
    :parameters (?location_group - count_target ?verifier - verifier)
    :precondition
      (and
        (count_target_scheduled ?location_group)
        (verifier_available ?verifier)
      )
    :effect
      (and
        (assigned_verifier ?location_group ?verifier)
        (not
          (verifier_available ?verifier)
        )
      )
  )
  (:action unassign_verifier_from_group
    :parameters (?location_group - count_target ?verifier - verifier)
    :precondition
      (and
        (assigned_verifier ?location_group ?verifier)
      )
    :effect
      (and
        (verifier_available ?verifier)
        (not
          (assigned_verifier ?location_group ?verifier)
        )
      )
  )
  (:action attach_quality_check_to_entry
    :parameters (?schedule_entry - schedule_entry ?quality_check_type - quality_check_type)
    :precondition
      (and
        (count_target_scheduled ?schedule_entry)
        (quality_check_available ?quality_check_type)
      )
    :effect
      (and
        (entry_assigned_quality_check ?schedule_entry ?quality_check_type)
        (not
          (quality_check_available ?quality_check_type)
        )
      )
  )
  (:action remove_quality_check_from_entry
    :parameters (?schedule_entry - schedule_entry ?quality_check_type - quality_check_type)
    :precondition
      (and
        (entry_assigned_quality_check ?schedule_entry ?quality_check_type)
      )
    :effect
      (and
        (quality_check_available ?quality_check_type)
        (not
          (entry_assigned_quality_check ?schedule_entry ?quality_check_type)
        )
      )
  )
  (:action attach_approval_token_to_entry
    :parameters (?schedule_entry - schedule_entry ?approval_token - approval_token)
    :precondition
      (and
        (count_target_scheduled ?schedule_entry)
        (approval_token_available ?approval_token)
      )
    :effect
      (and
        (entry_assigned_approval_token ?schedule_entry ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action remove_approval_token_from_entry
    :parameters (?schedule_entry - schedule_entry ?approval_token - approval_token)
    :precondition
      (and
        (entry_assigned_approval_token ?schedule_entry ?approval_token)
      )
    :effect
      (and
        (approval_token_available ?approval_token)
        (not
          (entry_assigned_approval_token ?schedule_entry ?approval_token)
        )
      )
  )
  (:action prepare_zone_for_location_count
    :parameters (?count_location - count_location ?zone - zone ?time_slot - operator_shift)
    :precondition
      (and
        (count_target_scheduled ?count_location)
        (assigned_shift ?count_location ?time_slot)
        (located_in_zone ?count_location ?zone)
        (not
          (zone_prepared ?zone)
        )
        (not
          (zone_device_staged ?zone)
        )
      )
    :effect (zone_prepared ?zone)
  )
  (:action verify_and_stage_location
    :parameters (?count_location - count_location ?zone - zone ?verifier - verifier)
    :precondition
      (and
        (count_target_scheduled ?count_location)
        (assigned_verifier ?count_location ?verifier)
        (located_in_zone ?count_location ?zone)
        (zone_prepared ?zone)
        (not
          (location_staged_for_batch ?count_location)
        )
      )
    :effect
      (and
        (location_staged_for_batch ?count_location)
        (count_location_prepared ?count_location)
      )
  )
  (:action allocate_device_to_location
    :parameters (?count_location - count_location ?zone - zone ?count_device - count_device)
    :precondition
      (and
        (count_target_scheduled ?count_location)
        (located_in_zone ?count_location ?zone)
        (device_available ?count_device)
        (not
          (location_staged_for_batch ?count_location)
        )
      )
    :effect
      (and
        (zone_device_staged ?zone)
        (location_staged_for_batch ?count_location)
        (location_assigned_device ?count_location ?count_device)
        (not
          (device_available ?count_device)
        )
      )
  )
  (:action finalize_device_staging_for_location
    :parameters (?count_location - count_location ?zone - zone ?time_slot - operator_shift ?count_device - count_device)
    :precondition
      (and
        (count_target_scheduled ?count_location)
        (assigned_shift ?count_location ?time_slot)
        (located_in_zone ?count_location ?zone)
        (zone_device_staged ?zone)
        (location_assigned_device ?count_location ?count_device)
        (not
          (count_location_prepared ?count_location)
        )
      )
    :effect
      (and
        (zone_prepared ?zone)
        (count_location_prepared ?count_location)
        (device_available ?count_device)
        (not
          (location_assigned_device ?count_location ?count_device)
        )
      )
  )
  (:action prepare_subzone_for_alt_location
    :parameters (?alternate_count_location - alternate_count_location ?subzone - subzone ?time_slot - operator_shift)
    :precondition
      (and
        (count_target_scheduled ?alternate_count_location)
        (assigned_shift ?alternate_count_location ?time_slot)
        (alt_location_assigned_subzone ?alternate_count_location ?subzone)
        (not
          (subzone_prepared ?subzone)
        )
        (not
          (subzone_device_staged ?subzone)
        )
      )
    :effect (subzone_prepared ?subzone)
  )
  (:action verify_and_stage_alt_location
    :parameters (?alternate_count_location - alternate_count_location ?subzone - subzone ?verifier - verifier)
    :precondition
      (and
        (count_target_scheduled ?alternate_count_location)
        (assigned_verifier ?alternate_count_location ?verifier)
        (alt_location_assigned_subzone ?alternate_count_location ?subzone)
        (subzone_prepared ?subzone)
        (not
          (alt_location_staged_for_batch ?alternate_count_location)
        )
      )
    :effect
      (and
        (alt_location_staged_for_batch ?alternate_count_location)
        (alt_count_location_prepared ?alternate_count_location)
      )
  )
  (:action allocate_device_to_alt_location
    :parameters (?alternate_count_location - alternate_count_location ?subzone - subzone ?count_device - count_device)
    :precondition
      (and
        (count_target_scheduled ?alternate_count_location)
        (alt_location_assigned_subzone ?alternate_count_location ?subzone)
        (device_available ?count_device)
        (not
          (alt_location_staged_for_batch ?alternate_count_location)
        )
      )
    :effect
      (and
        (subzone_device_staged ?subzone)
        (alt_location_staged_for_batch ?alternate_count_location)
        (alt_location_assigned_device ?alternate_count_location ?count_device)
        (not
          (device_available ?count_device)
        )
      )
  )
  (:action finalize_device_staging_for_alt_location
    :parameters (?alternate_count_location - alternate_count_location ?subzone - subzone ?time_slot - operator_shift ?count_device - count_device)
    :precondition
      (and
        (count_target_scheduled ?alternate_count_location)
        (assigned_shift ?alternate_count_location ?time_slot)
        (alt_location_assigned_subzone ?alternate_count_location ?subzone)
        (subzone_device_staged ?subzone)
        (alt_location_assigned_device ?alternate_count_location ?count_device)
        (not
          (alt_count_location_prepared ?alternate_count_location)
        )
      )
    :effect
      (and
        (subzone_prepared ?subzone)
        (alt_count_location_prepared ?alternate_count_location)
        (device_available ?count_device)
        (not
          (alt_location_assigned_device ?alternate_count_location ?count_device)
        )
      )
  )
  (:action assemble_count_batch_basic
    :parameters (?count_location - count_location ?alternate_count_location - alternate_count_location ?zone - zone ?subzone - subzone ?count_batch - count_batch)
    :precondition
      (and
        (location_staged_for_batch ?count_location)
        (alt_location_staged_for_batch ?alternate_count_location)
        (located_in_zone ?count_location ?zone)
        (alt_location_assigned_subzone ?alternate_count_location ?subzone)
        (zone_prepared ?zone)
        (subzone_prepared ?subzone)
        (count_location_prepared ?count_location)
        (alt_count_location_prepared ?alternate_count_location)
        (count_batch_open ?count_batch)
      )
    :effect
      (and
        (count_batch_prepared ?count_batch)
        (batch_assigned_zone ?count_batch ?zone)
        (batch_assigned_subzone ?count_batch ?subzone)
        (not
          (count_batch_open ?count_batch)
        )
      )
  )
  (:action assemble_count_batch_with_quality_flag
    :parameters (?count_location - count_location ?alternate_count_location - alternate_count_location ?zone - zone ?subzone - subzone ?count_batch - count_batch)
    :precondition
      (and
        (location_staged_for_batch ?count_location)
        (alt_location_staged_for_batch ?alternate_count_location)
        (located_in_zone ?count_location ?zone)
        (alt_location_assigned_subzone ?alternate_count_location ?subzone)
        (zone_device_staged ?zone)
        (subzone_prepared ?subzone)
        (not
          (count_location_prepared ?count_location)
        )
        (alt_count_location_prepared ?alternate_count_location)
        (count_batch_open ?count_batch)
      )
    :effect
      (and
        (count_batch_prepared ?count_batch)
        (batch_assigned_zone ?count_batch ?zone)
        (batch_assigned_subzone ?count_batch ?subzone)
        (batch_needs_quality_check ?count_batch)
        (not
          (count_batch_open ?count_batch)
        )
      )
  )
  (:action assemble_count_batch_with_approval_flag
    :parameters (?count_location - count_location ?alternate_count_location - alternate_count_location ?zone - zone ?subzone - subzone ?count_batch - count_batch)
    :precondition
      (and
        (location_staged_for_batch ?count_location)
        (alt_location_staged_for_batch ?alternate_count_location)
        (located_in_zone ?count_location ?zone)
        (alt_location_assigned_subzone ?alternate_count_location ?subzone)
        (zone_prepared ?zone)
        (subzone_device_staged ?subzone)
        (count_location_prepared ?count_location)
        (not
          (alt_count_location_prepared ?alternate_count_location)
        )
        (count_batch_open ?count_batch)
      )
    :effect
      (and
        (count_batch_prepared ?count_batch)
        (batch_assigned_zone ?count_batch ?zone)
        (batch_assigned_subzone ?count_batch ?subzone)
        (batch_needs_approval ?count_batch)
        (not
          (count_batch_open ?count_batch)
        )
      )
  )
  (:action assemble_count_batch_with_quality_and_approval
    :parameters (?count_location - count_location ?alternate_count_location - alternate_count_location ?zone - zone ?subzone - subzone ?count_batch - count_batch)
    :precondition
      (and
        (location_staged_for_batch ?count_location)
        (alt_location_staged_for_batch ?alternate_count_location)
        (located_in_zone ?count_location ?zone)
        (alt_location_assigned_subzone ?alternate_count_location ?subzone)
        (zone_device_staged ?zone)
        (subzone_device_staged ?subzone)
        (not
          (count_location_prepared ?count_location)
        )
        (not
          (alt_count_location_prepared ?alternate_count_location)
        )
        (count_batch_open ?count_batch)
      )
    :effect
      (and
        (count_batch_prepared ?count_batch)
        (batch_assigned_zone ?count_batch ?zone)
        (batch_assigned_subzone ?count_batch ?subzone)
        (batch_needs_quality_check ?count_batch)
        (batch_needs_approval ?count_batch)
        (not
          (count_batch_open ?count_batch)
        )
      )
  )
  (:action finalize_batch_for_item_selection
    :parameters (?count_batch - count_batch ?count_location - count_location ?time_slot - operator_shift)
    :precondition
      (and
        (count_batch_prepared ?count_batch)
        (location_staged_for_batch ?count_location)
        (assigned_shift ?count_location ?time_slot)
        (not
          (batch_ready_for_item_selection ?count_batch)
        )
      )
    :effect (batch_ready_for_item_selection ?count_batch)
  )
  (:action stage_inventory_item_to_batch
    :parameters (?schedule_entry - schedule_entry ?inventory_item - inventory_item ?count_batch - count_batch)
    :precondition
      (and
        (count_target_scheduled ?schedule_entry)
        (entry_includes_batch ?schedule_entry ?count_batch)
        (entry_includes_item ?schedule_entry ?inventory_item)
        (inventory_item_available ?inventory_item)
        (count_batch_prepared ?count_batch)
        (batch_ready_for_item_selection ?count_batch)
        (not
          (inventory_item_staged ?inventory_item)
        )
      )
    :effect
      (and
        (inventory_item_staged ?inventory_item)
        (item_assigned_to_batch ?inventory_item ?count_batch)
        (not
          (inventory_item_available ?inventory_item)
        )
      )
  )
  (:action prepare_entry_items_for_count
    :parameters (?schedule_entry - schedule_entry ?inventory_item - inventory_item ?count_batch - count_batch ?time_slot - operator_shift)
    :precondition
      (and
        (count_target_scheduled ?schedule_entry)
        (entry_includes_item ?schedule_entry ?inventory_item)
        (inventory_item_staged ?inventory_item)
        (item_assigned_to_batch ?inventory_item ?count_batch)
        (assigned_shift ?schedule_entry ?time_slot)
        (not
          (batch_needs_quality_check ?count_batch)
        )
        (not
          (entry_prepared ?schedule_entry)
        )
      )
    :effect (entry_prepared ?schedule_entry)
  )
  (:action assign_label_to_entry
    :parameters (?schedule_entry - schedule_entry ?location_label - location_label)
    :precondition
      (and
        (count_target_scheduled ?schedule_entry)
        (location_label_available ?location_label)
        (not
          (label_attached ?schedule_entry)
        )
      )
    :effect
      (and
        (label_attached ?schedule_entry)
        (entry_assigned_label ?schedule_entry ?location_label)
        (not
          (location_label_available ?location_label)
        )
      )
  )
  (:action finalize_label_and_prepare_entry
    :parameters (?schedule_entry - schedule_entry ?inventory_item - inventory_item ?count_batch - count_batch ?time_slot - operator_shift ?location_label - location_label)
    :precondition
      (and
        (count_target_scheduled ?schedule_entry)
        (entry_includes_item ?schedule_entry ?inventory_item)
        (inventory_item_staged ?inventory_item)
        (item_assigned_to_batch ?inventory_item ?count_batch)
        (assigned_shift ?schedule_entry ?time_slot)
        (batch_needs_quality_check ?count_batch)
        (label_attached ?schedule_entry)
        (entry_assigned_label ?schedule_entry ?location_label)
        (not
          (entry_prepared ?schedule_entry)
        )
      )
    :effect
      (and
        (entry_prepared ?schedule_entry)
        (entry_label_verified ?schedule_entry)
      )
  )
  (:action apply_quality_check_to_entry
    :parameters (?schedule_entry - schedule_entry ?quality_check_type - quality_check_type ?verifier - verifier ?inventory_item - inventory_item ?count_batch - count_batch)
    :precondition
      (and
        (entry_prepared ?schedule_entry)
        (entry_assigned_quality_check ?schedule_entry ?quality_check_type)
        (assigned_verifier ?schedule_entry ?verifier)
        (entry_includes_item ?schedule_entry ?inventory_item)
        (item_assigned_to_batch ?inventory_item ?count_batch)
        (not
          (batch_needs_approval ?count_batch)
        )
        (not
          (entry_checked ?schedule_entry)
        )
      )
    :effect (entry_checked ?schedule_entry)
  )
  (:action confirm_quality_check_on_entry
    :parameters (?schedule_entry - schedule_entry ?quality_check_type - quality_check_type ?verifier - verifier ?inventory_item - inventory_item ?count_batch - count_batch)
    :precondition
      (and
        (entry_prepared ?schedule_entry)
        (entry_assigned_quality_check ?schedule_entry ?quality_check_type)
        (assigned_verifier ?schedule_entry ?verifier)
        (entry_includes_item ?schedule_entry ?inventory_item)
        (item_assigned_to_batch ?inventory_item ?count_batch)
        (batch_needs_approval ?count_batch)
        (not
          (entry_checked ?schedule_entry)
        )
      )
    :effect (entry_checked ?schedule_entry)
  )
  (:action initiate_approval_for_entry
    :parameters (?schedule_entry - schedule_entry ?approval_token - approval_token ?inventory_item - inventory_item ?count_batch - count_batch)
    :precondition
      (and
        (entry_checked ?schedule_entry)
        (entry_assigned_approval_token ?schedule_entry ?approval_token)
        (entry_includes_item ?schedule_entry ?inventory_item)
        (item_assigned_to_batch ?inventory_item ?count_batch)
        (not
          (batch_needs_quality_check ?count_batch)
        )
        (not
          (batch_needs_approval ?count_batch)
        )
        (not
          (entry_ready ?schedule_entry)
        )
      )
    :effect (entry_ready ?schedule_entry)
  )
  (:action attach_protocol_and_mark_entry_ready
    :parameters (?schedule_entry - schedule_entry ?approval_token - approval_token ?inventory_item - inventory_item ?count_batch - count_batch)
    :precondition
      (and
        (entry_checked ?schedule_entry)
        (entry_assigned_approval_token ?schedule_entry ?approval_token)
        (entry_includes_item ?schedule_entry ?inventory_item)
        (item_assigned_to_batch ?inventory_item ?count_batch)
        (batch_needs_quality_check ?count_batch)
        (not
          (batch_needs_approval ?count_batch)
        )
        (not
          (entry_ready ?schedule_entry)
        )
      )
    :effect
      (and
        (entry_ready ?schedule_entry)
        (protocol_attached ?schedule_entry)
      )
  )
  (:action attach_protocol_and_mark_entry_ready_secondary
    :parameters (?schedule_entry - schedule_entry ?approval_token - approval_token ?inventory_item - inventory_item ?count_batch - count_batch)
    :precondition
      (and
        (entry_checked ?schedule_entry)
        (entry_assigned_approval_token ?schedule_entry ?approval_token)
        (entry_includes_item ?schedule_entry ?inventory_item)
        (item_assigned_to_batch ?inventory_item ?count_batch)
        (not
          (batch_needs_quality_check ?count_batch)
        )
        (batch_needs_approval ?count_batch)
        (not
          (entry_ready ?schedule_entry)
        )
      )
    :effect
      (and
        (entry_ready ?schedule_entry)
        (protocol_attached ?schedule_entry)
      )
  )
  (:action attach_protocol_and_mark_entry_ready_complete
    :parameters (?schedule_entry - schedule_entry ?approval_token - approval_token ?inventory_item - inventory_item ?count_batch - count_batch)
    :precondition
      (and
        (entry_checked ?schedule_entry)
        (entry_assigned_approval_token ?schedule_entry ?approval_token)
        (entry_includes_item ?schedule_entry ?inventory_item)
        (item_assigned_to_batch ?inventory_item ?count_batch)
        (batch_needs_quality_check ?count_batch)
        (batch_needs_approval ?count_batch)
        (not
          (entry_ready ?schedule_entry)
        )
      )
    :effect
      (and
        (entry_ready ?schedule_entry)
        (protocol_attached ?schedule_entry)
      )
  )
  (:action mark_entry_ready_for_execution
    :parameters (?schedule_entry - schedule_entry)
    :precondition
      (and
        (entry_ready ?schedule_entry)
        (not
          (protocol_attached ?schedule_entry)
        )
        (not
          (entry_execution_mark ?schedule_entry)
        )
      )
    :effect
      (and
        (entry_execution_mark ?schedule_entry)
        (ready_for_count ?schedule_entry)
      )
  )
  (:action assign_protocol_to_entry
    :parameters (?schedule_entry - schedule_entry ?count_protocol - count_protocol)
    :precondition
      (and
        (entry_ready ?schedule_entry)
        (protocol_attached ?schedule_entry)
        (protocol_available ?count_protocol)
      )
    :effect
      (and
        (entry_assigned_protocol ?schedule_entry ?count_protocol)
        (not
          (protocol_available ?count_protocol)
        )
      )
  )
  (:action execute_quality_checks_for_entry
    :parameters (?schedule_entry - schedule_entry ?count_location - count_location ?alternate_count_location - alternate_count_location ?time_slot - operator_shift ?count_protocol - count_protocol)
    :precondition
      (and
        (entry_ready ?schedule_entry)
        (protocol_attached ?schedule_entry)
        (entry_assigned_protocol ?schedule_entry ?count_protocol)
        (entry_includes_location ?schedule_entry ?count_location)
        (entry_includes_alt_location ?schedule_entry ?alternate_count_location)
        (count_location_prepared ?count_location)
        (alt_count_location_prepared ?alternate_count_location)
        (assigned_shift ?schedule_entry ?time_slot)
        (not
          (entry_checks_complete ?schedule_entry)
        )
      )
    :effect (entry_checks_complete ?schedule_entry)
  )
  (:action finalize_entry_post_checks
    :parameters (?schedule_entry - schedule_entry)
    :precondition
      (and
        (entry_ready ?schedule_entry)
        (entry_checks_complete ?schedule_entry)
        (not
          (entry_execution_mark ?schedule_entry)
        )
      )
    :effect
      (and
        (entry_execution_mark ?schedule_entry)
        (ready_for_count ?schedule_entry)
      )
  )
  (:action assign_approver_to_entry
    :parameters (?schedule_entry - schedule_entry ?approver_role - approver_role ?time_slot - operator_shift)
    :precondition
      (and
        (count_target_scheduled ?schedule_entry)
        (assigned_shift ?schedule_entry ?time_slot)
        (approver_available ?approver_role)
        (entry_assigned_approver ?schedule_entry ?approver_role)
        (not
          (approval_assigned ?schedule_entry)
        )
      )
    :effect
      (and
        (approval_assigned ?schedule_entry)
        (not
          (approver_available ?approver_role)
        )
      )
  )
  (:action request_approval_for_entry
    :parameters (?schedule_entry - schedule_entry ?verifier - verifier)
    :precondition
      (and
        (approval_assigned ?schedule_entry)
        (assigned_verifier ?schedule_entry ?verifier)
        (not
          (approval_requested ?schedule_entry)
        )
      )
    :effect (approval_requested ?schedule_entry)
  )
  (:action grant_approval_for_entry
    :parameters (?schedule_entry - schedule_entry ?approval_token - approval_token)
    :precondition
      (and
        (approval_requested ?schedule_entry)
        (entry_assigned_approval_token ?schedule_entry ?approval_token)
        (not
          (approval_granted ?schedule_entry)
        )
      )
    :effect (approval_granted ?schedule_entry)
  )
  (:action finalize_entry_after_approval
    :parameters (?schedule_entry - schedule_entry)
    :precondition
      (and
        (approval_granted ?schedule_entry)
        (not
          (entry_execution_mark ?schedule_entry)
        )
      )
    :effect
      (and
        (entry_execution_mark ?schedule_entry)
        (ready_for_count ?schedule_entry)
      )
  )
  (:action mark_location_ready_for_count
    :parameters (?count_location - count_location ?count_batch - count_batch)
    :precondition
      (and
        (location_staged_for_batch ?count_location)
        (count_location_prepared ?count_location)
        (count_batch_prepared ?count_batch)
        (batch_ready_for_item_selection ?count_batch)
        (not
          (ready_for_count ?count_location)
        )
      )
    :effect (ready_for_count ?count_location)
  )
  (:action mark_alt_location_ready_for_count
    :parameters (?alternate_count_location - alternate_count_location ?count_batch - count_batch)
    :precondition
      (and
        (alt_location_staged_for_batch ?alternate_count_location)
        (alt_count_location_prepared ?alternate_count_location)
        (count_batch_prepared ?count_batch)
        (batch_ready_for_item_selection ?count_batch)
        (not
          (ready_for_count ?alternate_count_location)
        )
      )
    :effect (ready_for_count ?alternate_count_location)
  )
  (:action submit_count_for_location
    :parameters (?location_group - count_target ?audit_token - audit_token ?time_slot - operator_shift)
    :precondition
      (and
        (ready_for_count ?location_group)
        (assigned_shift ?location_group ?time_slot)
        (audit_token_available ?audit_token)
        (not
          (count_submitted ?location_group)
        )
      )
    :effect
      (and
        (count_submitted ?location_group)
        (location_assigned_audit_token ?location_group ?audit_token)
        (not
          (audit_token_available ?audit_token)
        )
      )
  )
  (:action finalize_count_and_release_operator
    :parameters (?count_location - count_location ?operator - operator ?audit_token - audit_token)
    :precondition
      (and
        (count_submitted ?count_location)
        (assigned_operator ?count_location ?operator)
        (location_assigned_audit_token ?count_location ?audit_token)
        (not
          (count_finalized ?count_location)
        )
      )
    :effect
      (and
        (count_finalized ?count_location)
        (operator_available ?operator)
        (audit_token_available ?audit_token)
      )
  )
  (:action finalize_count_and_release_operator_for_alt_location
    :parameters (?alternate_count_location - alternate_count_location ?operator - operator ?audit_token - audit_token)
    :precondition
      (and
        (count_submitted ?alternate_count_location)
        (assigned_operator ?alternate_count_location ?operator)
        (location_assigned_audit_token ?alternate_count_location ?audit_token)
        (not
          (count_finalized ?alternate_count_location)
        )
      )
    :effect
      (and
        (count_finalized ?alternate_count_location)
        (operator_available ?operator)
        (audit_token_available ?audit_token)
      )
  )
  (:action finalize_count_and_release_operator_for_entry
    :parameters (?schedule_entry - schedule_entry ?operator - operator ?audit_token - audit_token)
    :precondition
      (and
        (count_submitted ?schedule_entry)
        (assigned_operator ?schedule_entry ?operator)
        (location_assigned_audit_token ?schedule_entry ?audit_token)
        (not
          (count_finalized ?schedule_entry)
        )
      )
    :effect
      (and
        (count_finalized ?schedule_entry)
        (operator_available ?operator)
        (audit_token_available ?audit_token)
      )
  )
)

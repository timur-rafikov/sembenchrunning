(define (domain zone_to_zone_internal_transfer_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_type - object storage_asset_type - object bin_transport_type - object transfer_request_root - object transfer_request - transfer_request_root material_handling_unit - resource_type sku - resource_type workstation - resource_type special_handling_code - resource_type packing_instruction - resource_type time_slot - resource_type equipment_tag - resource_type shift_assignment - resource_type inventory_unit - storage_asset_type storage_slot - storage_asset_type operator_certification - storage_asset_type source_bin - bin_transport_type destination_bin - bin_transport_type transport_unit - bin_transport_type zone_role_group - transfer_request zone_role_group_2 - transfer_request source_zone - zone_role_group destination_zone - zone_role_group transfer_job - zone_role_group_2)
  (:predicates
    (transfer_created ?transfer_request - transfer_request)
    (validated_for_transfer ?transfer_request - transfer_request)
    (transfer_mhu_reserved ?transfer_request - transfer_request)
    (commitment_for_transfer ?transfer_request - transfer_request)
    (ready_for_scheduling ?transfer_request - transfer_request)
    (scheduled_for_transfer ?transfer_request - transfer_request)
    (mhu_available ?material_handling_unit - material_handling_unit)
    (assigned_mhu_for_transfer ?transfer_request - transfer_request ?material_handling_unit - material_handling_unit)
    (sku_available ?sku - sku)
    (sku_reserved_for_transfer ?transfer_request - transfer_request ?sku - sku)
    (workstation_available ?workstation - workstation)
    (assigned_workstation_for_transfer ?transfer_request - transfer_request ?workstation - workstation)
    (inventory_unit_available ?inventory_unit - inventory_unit)
    (source_zone_reserved_inventory_unit ?source_zone - source_zone ?inventory_unit - inventory_unit)
    (destination_zone_reserved_inventory_unit ?destination_zone - destination_zone ?inventory_unit - inventory_unit)
    (source_zone_assigned_bin ?source_zone - source_zone ?source_bin - source_bin)
    (source_bin_reserved ?source_bin - source_bin)
    (source_bin_staged ?source_bin - source_bin)
    (source_zone_ready ?source_zone - source_zone)
    (destination_zone_assigned_bin ?destination_zone - destination_zone ?destination_bin - destination_bin)
    (destination_bin_reserved ?destination_bin - destination_bin)
    (destination_bin_staged ?destination_bin - destination_bin)
    (destination_zone_ready ?destination_zone - destination_zone)
    (transport_unit_available ?transport_unit - transport_unit)
    (transport_unit_reserved ?transport_unit - transport_unit)
    (transport_unit_assigned_source_bin ?transport_unit - transport_unit ?source_bin - source_bin)
    (transport_unit_assigned_destination_bin ?transport_unit - transport_unit ?destination_bin - destination_bin)
    (transport_unit_tagged_source ?transport_unit - transport_unit)
    (transport_unit_tagged_destination ?transport_unit - transport_unit)
    (transport_unit_verified ?transport_unit - transport_unit)
    (transfer_job_assigned_source_zone ?transfer_job - transfer_job ?source_zone - source_zone)
    (transfer_job_assigned_destination_zone ?transfer_job - transfer_job ?destination_zone - destination_zone)
    (transfer_job_assigned_transport_unit ?transfer_job - transfer_job ?transport_unit - transport_unit)
    (storage_slot_available ?storage_slot - storage_slot)
    (transfer_job_assigned_storage_slot ?transfer_job - transfer_job ?storage_slot - storage_slot)
    (storage_slot_reserved ?storage_slot - storage_slot)
    (storage_slot_contains_transport_unit ?storage_slot - storage_slot ?transport_unit - transport_unit)
    (transfer_job_ready_for_loading ?transfer_job - transfer_job)
    (transfer_job_loaded ?transfer_job - transfer_job)
    (transfer_job_ready_for_reconciliation ?transfer_job - transfer_job)
    (transfer_job_has_special_handling ?transfer_job - transfer_job)
    (transfer_job_special_handling_applied ?transfer_job - transfer_job)
    (transfer_job_equipment_attached ?transfer_job - transfer_job)
    (transfer_job_resources_committed ?transfer_job - transfer_job)
    (operator_certification_available ?operator_certification - operator_certification)
    (transfer_job_assigned_operator_certification ?transfer_job - transfer_job ?operator_certification - operator_certification)
    (transfer_job_authorized ?transfer_job - transfer_job)
    (transfer_job_workstation_prepared ?transfer_job - transfer_job)
    (transfer_job_shift_assigned ?transfer_job - transfer_job)
    (special_handling_code_available ?special_handling_code - special_handling_code)
    (transfer_job_assigned_special_handling ?transfer_job - transfer_job ?special_handling_code - special_handling_code)
    (packing_instruction_available ?packing_instruction - packing_instruction)
    (transfer_job_assigned_packing_instruction ?transfer_job - transfer_job ?packing_instruction - packing_instruction)
    (equipment_tag_available ?equipment_tag - equipment_tag)
    (transfer_job_assigned_equipment_tag ?transfer_job - transfer_job ?equipment_tag - equipment_tag)
    (shift_assignment_available ?shift_assignment - shift_assignment)
    (transfer_job_assigned_shift ?transfer_job - transfer_job ?shift_assignment - shift_assignment)
    (time_slot_available ?time_slot - time_slot)
    (assigned_time_slot_for_transfer ?transfer_request - transfer_request ?time_slot - time_slot)
    (source_zone_staged ?source_zone - source_zone)
    (destination_zone_staged ?destination_zone - destination_zone)
    (transfer_job_reconciled ?transfer_job - transfer_job)
  )
  (:action create_transfer_request
    :parameters (?transfer_request - transfer_request)
    :precondition
      (and
        (not
          (transfer_created ?transfer_request)
        )
        (not
          (commitment_for_transfer ?transfer_request)
        )
      )
    :effect (transfer_created ?transfer_request)
  )
  (:action assign_mhu_to_transfer_request
    :parameters (?transfer_request - transfer_request ?material_handling_unit - material_handling_unit)
    :precondition
      (and
        (transfer_created ?transfer_request)
        (not
          (transfer_mhu_reserved ?transfer_request)
        )
        (mhu_available ?material_handling_unit)
      )
    :effect
      (and
        (transfer_mhu_reserved ?transfer_request)
        (assigned_mhu_for_transfer ?transfer_request ?material_handling_unit)
        (not
          (mhu_available ?material_handling_unit)
        )
      )
  )
  (:action reserve_sku_for_transfer_request
    :parameters (?transfer_request - transfer_request ?sku - sku)
    :precondition
      (and
        (transfer_created ?transfer_request)
        (transfer_mhu_reserved ?transfer_request)
        (sku_available ?sku)
      )
    :effect
      (and
        (sku_reserved_for_transfer ?transfer_request ?sku)
        (not
          (sku_available ?sku)
        )
      )
  )
  (:action validate_transfer_request
    :parameters (?transfer_request - transfer_request ?sku - sku)
    :precondition
      (and
        (transfer_created ?transfer_request)
        (transfer_mhu_reserved ?transfer_request)
        (sku_reserved_for_transfer ?transfer_request ?sku)
        (not
          (validated_for_transfer ?transfer_request)
        )
      )
    :effect (validated_for_transfer ?transfer_request)
  )
  (:action release_sku_reservation
    :parameters (?transfer_request - transfer_request ?sku - sku)
    :precondition
      (and
        (sku_reserved_for_transfer ?transfer_request ?sku)
      )
    :effect
      (and
        (sku_available ?sku)
        (not
          (sku_reserved_for_transfer ?transfer_request ?sku)
        )
      )
  )
  (:action assign_workstation_to_transfer_request
    :parameters (?transfer_request - transfer_request ?workstation - workstation)
    :precondition
      (and
        (validated_for_transfer ?transfer_request)
        (workstation_available ?workstation)
      )
    :effect
      (and
        (assigned_workstation_for_transfer ?transfer_request ?workstation)
        (not
          (workstation_available ?workstation)
        )
      )
  )
  (:action release_workstation_from_transfer_request
    :parameters (?transfer_request - transfer_request ?workstation - workstation)
    :precondition
      (and
        (assigned_workstation_for_transfer ?transfer_request ?workstation)
      )
    :effect
      (and
        (workstation_available ?workstation)
        (not
          (assigned_workstation_for_transfer ?transfer_request ?workstation)
        )
      )
  )
  (:action attach_equipment_tag_to_transfer_job
    :parameters (?transfer_job - transfer_job ?equipment_tag - equipment_tag)
    :precondition
      (and
        (validated_for_transfer ?transfer_job)
        (equipment_tag_available ?equipment_tag)
      )
    :effect
      (and
        (transfer_job_assigned_equipment_tag ?transfer_job ?equipment_tag)
        (not
          (equipment_tag_available ?equipment_tag)
        )
      )
  )
  (:action detach_equipment_tag_from_transfer_job
    :parameters (?transfer_job - transfer_job ?equipment_tag - equipment_tag)
    :precondition
      (and
        (transfer_job_assigned_equipment_tag ?transfer_job ?equipment_tag)
      )
    :effect
      (and
        (equipment_tag_available ?equipment_tag)
        (not
          (transfer_job_assigned_equipment_tag ?transfer_job ?equipment_tag)
        )
      )
  )
  (:action assign_shift_to_transfer_job
    :parameters (?transfer_job - transfer_job ?shift_assignment - shift_assignment)
    :precondition
      (and
        (validated_for_transfer ?transfer_job)
        (shift_assignment_available ?shift_assignment)
      )
    :effect
      (and
        (transfer_job_assigned_shift ?transfer_job ?shift_assignment)
        (not
          (shift_assignment_available ?shift_assignment)
        )
      )
  )
  (:action unassign_shift_from_transfer_job
    :parameters (?transfer_job - transfer_job ?shift_assignment - shift_assignment)
    :precondition
      (and
        (transfer_job_assigned_shift ?transfer_job ?shift_assignment)
      )
    :effect
      (and
        (shift_assignment_available ?shift_assignment)
        (not
          (transfer_job_assigned_shift ?transfer_job ?shift_assignment)
        )
      )
  )
  (:action reserve_source_bin_for_transfer
    :parameters (?source_zone - source_zone ?source_bin - source_bin ?sku - sku)
    :precondition
      (and
        (validated_for_transfer ?source_zone)
        (sku_reserved_for_transfer ?source_zone ?sku)
        (source_zone_assigned_bin ?source_zone ?source_bin)
        (not
          (source_bin_reserved ?source_bin)
        )
        (not
          (source_bin_staged ?source_bin)
        )
      )
    :effect (source_bin_reserved ?source_bin)
  )
  (:action prepare_source_zone_for_pick
    :parameters (?source_zone - source_zone ?source_bin - source_bin ?workstation - workstation)
    :precondition
      (and
        (validated_for_transfer ?source_zone)
        (assigned_workstation_for_transfer ?source_zone ?workstation)
        (source_zone_assigned_bin ?source_zone ?source_bin)
        (source_bin_reserved ?source_bin)
        (not
          (source_zone_staged ?source_zone)
        )
      )
    :effect
      (and
        (source_zone_staged ?source_zone)
        (source_zone_ready ?source_zone)
      )
  )
  (:action stage_inventory_unit_in_source_bin
    :parameters (?source_zone - source_zone ?source_bin - source_bin ?inventory_unit - inventory_unit)
    :precondition
      (and
        (validated_for_transfer ?source_zone)
        (source_zone_assigned_bin ?source_zone ?source_bin)
        (inventory_unit_available ?inventory_unit)
        (not
          (source_zone_staged ?source_zone)
        )
      )
    :effect
      (and
        (source_bin_staged ?source_bin)
        (source_zone_staged ?source_zone)
        (source_zone_reserved_inventory_unit ?source_zone ?inventory_unit)
        (not
          (inventory_unit_available ?inventory_unit)
        )
      )
  )
  (:action finalize_inventory_pick_from_source_bin
    :parameters (?source_zone - source_zone ?source_bin - source_bin ?sku - sku ?inventory_unit - inventory_unit)
    :precondition
      (and
        (validated_for_transfer ?source_zone)
        (sku_reserved_for_transfer ?source_zone ?sku)
        (source_zone_assigned_bin ?source_zone ?source_bin)
        (source_bin_staged ?source_bin)
        (source_zone_reserved_inventory_unit ?source_zone ?inventory_unit)
        (not
          (source_zone_ready ?source_zone)
        )
      )
    :effect
      (and
        (source_bin_reserved ?source_bin)
        (source_zone_ready ?source_zone)
        (inventory_unit_available ?inventory_unit)
        (not
          (source_zone_reserved_inventory_unit ?source_zone ?inventory_unit)
        )
      )
  )
  (:action reserve_destination_bin_for_transfer
    :parameters (?destination_zone - destination_zone ?destination_bin - destination_bin ?sku - sku)
    :precondition
      (and
        (validated_for_transfer ?destination_zone)
        (sku_reserved_for_transfer ?destination_zone ?sku)
        (destination_zone_assigned_bin ?destination_zone ?destination_bin)
        (not
          (destination_bin_reserved ?destination_bin)
        )
        (not
          (destination_bin_staged ?destination_bin)
        )
      )
    :effect (destination_bin_reserved ?destination_bin)
  )
  (:action prepare_destination_zone_for_put
    :parameters (?destination_zone - destination_zone ?destination_bin - destination_bin ?workstation - workstation)
    :precondition
      (and
        (validated_for_transfer ?destination_zone)
        (assigned_workstation_for_transfer ?destination_zone ?workstation)
        (destination_zone_assigned_bin ?destination_zone ?destination_bin)
        (destination_bin_reserved ?destination_bin)
        (not
          (destination_zone_staged ?destination_zone)
        )
      )
    :effect
      (and
        (destination_zone_staged ?destination_zone)
        (destination_zone_ready ?destination_zone)
      )
  )
  (:action stage_inventory_unit_in_destination_bin
    :parameters (?destination_zone - destination_zone ?destination_bin - destination_bin ?inventory_unit - inventory_unit)
    :precondition
      (and
        (validated_for_transfer ?destination_zone)
        (destination_zone_assigned_bin ?destination_zone ?destination_bin)
        (inventory_unit_available ?inventory_unit)
        (not
          (destination_zone_staged ?destination_zone)
        )
      )
    :effect
      (and
        (destination_bin_staged ?destination_bin)
        (destination_zone_staged ?destination_zone)
        (destination_zone_reserved_inventory_unit ?destination_zone ?inventory_unit)
        (not
          (inventory_unit_available ?inventory_unit)
        )
      )
  )
  (:action finalize_inventory_put_in_destination_bin
    :parameters (?destination_zone - destination_zone ?destination_bin - destination_bin ?sku - sku ?inventory_unit - inventory_unit)
    :precondition
      (and
        (validated_for_transfer ?destination_zone)
        (sku_reserved_for_transfer ?destination_zone ?sku)
        (destination_zone_assigned_bin ?destination_zone ?destination_bin)
        (destination_bin_staged ?destination_bin)
        (destination_zone_reserved_inventory_unit ?destination_zone ?inventory_unit)
        (not
          (destination_zone_ready ?destination_zone)
        )
      )
    :effect
      (and
        (destination_bin_reserved ?destination_bin)
        (destination_zone_ready ?destination_zone)
        (inventory_unit_available ?inventory_unit)
        (not
          (destination_zone_reserved_inventory_unit ?destination_zone ?inventory_unit)
        )
      )
  )
  (:action assign_and_pair_transport_unit_with_bins
    :parameters (?source_zone - source_zone ?destination_zone - destination_zone ?source_bin - source_bin ?destination_bin - destination_bin ?transport_unit - transport_unit)
    :precondition
      (and
        (source_zone_staged ?source_zone)
        (destination_zone_staged ?destination_zone)
        (source_zone_assigned_bin ?source_zone ?source_bin)
        (destination_zone_assigned_bin ?destination_zone ?destination_bin)
        (source_bin_reserved ?source_bin)
        (destination_bin_reserved ?destination_bin)
        (source_zone_ready ?source_zone)
        (destination_zone_ready ?destination_zone)
        (transport_unit_available ?transport_unit)
      )
    :effect
      (and
        (transport_unit_reserved ?transport_unit)
        (transport_unit_assigned_source_bin ?transport_unit ?source_bin)
        (transport_unit_assigned_destination_bin ?transport_unit ?destination_bin)
        (not
          (transport_unit_available ?transport_unit)
        )
      )
  )
  (:action stage_transport_unit_with_source_tag
    :parameters (?source_zone - source_zone ?destination_zone - destination_zone ?source_bin - source_bin ?destination_bin - destination_bin ?transport_unit - transport_unit)
    :precondition
      (and
        (source_zone_staged ?source_zone)
        (destination_zone_staged ?destination_zone)
        (source_zone_assigned_bin ?source_zone ?source_bin)
        (destination_zone_assigned_bin ?destination_zone ?destination_bin)
        (source_bin_staged ?source_bin)
        (destination_bin_reserved ?destination_bin)
        (not
          (source_zone_ready ?source_zone)
        )
        (destination_zone_ready ?destination_zone)
        (transport_unit_available ?transport_unit)
      )
    :effect
      (and
        (transport_unit_reserved ?transport_unit)
        (transport_unit_assigned_source_bin ?transport_unit ?source_bin)
        (transport_unit_assigned_destination_bin ?transport_unit ?destination_bin)
        (transport_unit_tagged_source ?transport_unit)
        (not
          (transport_unit_available ?transport_unit)
        )
      )
  )
  (:action stage_transport_unit_with_destination_tag
    :parameters (?source_zone - source_zone ?destination_zone - destination_zone ?source_bin - source_bin ?destination_bin - destination_bin ?transport_unit - transport_unit)
    :precondition
      (and
        (source_zone_staged ?source_zone)
        (destination_zone_staged ?destination_zone)
        (source_zone_assigned_bin ?source_zone ?source_bin)
        (destination_zone_assigned_bin ?destination_zone ?destination_bin)
        (source_bin_reserved ?source_bin)
        (destination_bin_staged ?destination_bin)
        (source_zone_ready ?source_zone)
        (not
          (destination_zone_ready ?destination_zone)
        )
        (transport_unit_available ?transport_unit)
      )
    :effect
      (and
        (transport_unit_reserved ?transport_unit)
        (transport_unit_assigned_source_bin ?transport_unit ?source_bin)
        (transport_unit_assigned_destination_bin ?transport_unit ?destination_bin)
        (transport_unit_tagged_destination ?transport_unit)
        (not
          (transport_unit_available ?transport_unit)
        )
      )
  )
  (:action stage_transport_unit_with_both_tags
    :parameters (?source_zone - source_zone ?destination_zone - destination_zone ?source_bin - source_bin ?destination_bin - destination_bin ?transport_unit - transport_unit)
    :precondition
      (and
        (source_zone_staged ?source_zone)
        (destination_zone_staged ?destination_zone)
        (source_zone_assigned_bin ?source_zone ?source_bin)
        (destination_zone_assigned_bin ?destination_zone ?destination_bin)
        (source_bin_staged ?source_bin)
        (destination_bin_staged ?destination_bin)
        (not
          (source_zone_ready ?source_zone)
        )
        (not
          (destination_zone_ready ?destination_zone)
        )
        (transport_unit_available ?transport_unit)
      )
    :effect
      (and
        (transport_unit_reserved ?transport_unit)
        (transport_unit_assigned_source_bin ?transport_unit ?source_bin)
        (transport_unit_assigned_destination_bin ?transport_unit ?destination_bin)
        (transport_unit_tagged_source ?transport_unit)
        (transport_unit_tagged_destination ?transport_unit)
        (not
          (transport_unit_available ?transport_unit)
        )
      )
  )
  (:action verify_transport_unit_at_source
    :parameters (?transport_unit - transport_unit ?source_zone - source_zone ?sku - sku)
    :precondition
      (and
        (transport_unit_reserved ?transport_unit)
        (source_zone_staged ?source_zone)
        (sku_reserved_for_transfer ?source_zone ?sku)
        (not
          (transport_unit_verified ?transport_unit)
        )
      )
    :effect (transport_unit_verified ?transport_unit)
  )
  (:action reserve_storage_slot_and_assign_transport_unit
    :parameters (?transfer_job - transfer_job ?storage_slot - storage_slot ?transport_unit - transport_unit)
    :precondition
      (and
        (validated_for_transfer ?transfer_job)
        (transfer_job_assigned_transport_unit ?transfer_job ?transport_unit)
        (transfer_job_assigned_storage_slot ?transfer_job ?storage_slot)
        (storage_slot_available ?storage_slot)
        (transport_unit_reserved ?transport_unit)
        (transport_unit_verified ?transport_unit)
        (not
          (storage_slot_reserved ?storage_slot)
        )
      )
    :effect
      (and
        (storage_slot_reserved ?storage_slot)
        (storage_slot_contains_transport_unit ?storage_slot ?transport_unit)
        (not
          (storage_slot_available ?storage_slot)
        )
      )
  )
  (:action allocate_storage_slot_for_transfer_job
    :parameters (?transfer_job - transfer_job ?storage_slot - storage_slot ?transport_unit - transport_unit ?sku - sku)
    :precondition
      (and
        (validated_for_transfer ?transfer_job)
        (transfer_job_assigned_storage_slot ?transfer_job ?storage_slot)
        (storage_slot_reserved ?storage_slot)
        (storage_slot_contains_transport_unit ?storage_slot ?transport_unit)
        (sku_reserved_for_transfer ?transfer_job ?sku)
        (not
          (transport_unit_tagged_source ?transport_unit)
        )
        (not
          (transfer_job_ready_for_loading ?transfer_job)
        )
      )
    :effect (transfer_job_ready_for_loading ?transfer_job)
  )
  (:action assign_special_handling_code_to_transfer_job
    :parameters (?transfer_job - transfer_job ?special_handling_code - special_handling_code)
    :precondition
      (and
        (validated_for_transfer ?transfer_job)
        (special_handling_code_available ?special_handling_code)
        (not
          (transfer_job_has_special_handling ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_has_special_handling ?transfer_job)
        (transfer_job_assigned_special_handling ?transfer_job ?special_handling_code)
        (not
          (special_handling_code_available ?special_handling_code)
        )
      )
  )
  (:action apply_special_handling_and_mark_transfer_job
    :parameters (?transfer_job - transfer_job ?storage_slot - storage_slot ?transport_unit - transport_unit ?sku - sku ?special_handling_code - special_handling_code)
    :precondition
      (and
        (validated_for_transfer ?transfer_job)
        (transfer_job_assigned_storage_slot ?transfer_job ?storage_slot)
        (storage_slot_reserved ?storage_slot)
        (storage_slot_contains_transport_unit ?storage_slot ?transport_unit)
        (sku_reserved_for_transfer ?transfer_job ?sku)
        (transport_unit_tagged_source ?transport_unit)
        (transfer_job_has_special_handling ?transfer_job)
        (transfer_job_assigned_special_handling ?transfer_job ?special_handling_code)
        (not
          (transfer_job_ready_for_loading ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_ready_for_loading ?transfer_job)
        (transfer_job_special_handling_applied ?transfer_job)
      )
  )
  (:action begin_load_sequence_for_transfer_job
    :parameters (?transfer_job - transfer_job ?equipment_tag - equipment_tag ?workstation - workstation ?storage_slot - storage_slot ?transport_unit - transport_unit)
    :precondition
      (and
        (transfer_job_ready_for_loading ?transfer_job)
        (transfer_job_assigned_equipment_tag ?transfer_job ?equipment_tag)
        (assigned_workstation_for_transfer ?transfer_job ?workstation)
        (transfer_job_assigned_storage_slot ?transfer_job ?storage_slot)
        (storage_slot_contains_transport_unit ?storage_slot ?transport_unit)
        (not
          (transport_unit_tagged_destination ?transport_unit)
        )
        (not
          (transfer_job_loaded ?transfer_job)
        )
      )
    :effect (transfer_job_loaded ?transfer_job)
  )
  (:action begin_load_sequence_for_transfer_job_with_destination_tag
    :parameters (?transfer_job - transfer_job ?equipment_tag - equipment_tag ?workstation - workstation ?storage_slot - storage_slot ?transport_unit - transport_unit)
    :precondition
      (and
        (transfer_job_ready_for_loading ?transfer_job)
        (transfer_job_assigned_equipment_tag ?transfer_job ?equipment_tag)
        (assigned_workstation_for_transfer ?transfer_job ?workstation)
        (transfer_job_assigned_storage_slot ?transfer_job ?storage_slot)
        (storage_slot_contains_transport_unit ?storage_slot ?transport_unit)
        (transport_unit_tagged_destination ?transport_unit)
        (not
          (transfer_job_loaded ?transfer_job)
        )
      )
    :effect (transfer_job_loaded ?transfer_job)
  )
  (:action complete_load_and_verify_transfer_job
    :parameters (?transfer_job - transfer_job ?shift_assignment - shift_assignment ?storage_slot - storage_slot ?transport_unit - transport_unit)
    :precondition
      (and
        (transfer_job_loaded ?transfer_job)
        (transfer_job_assigned_shift ?transfer_job ?shift_assignment)
        (transfer_job_assigned_storage_slot ?transfer_job ?storage_slot)
        (storage_slot_contains_transport_unit ?storage_slot ?transport_unit)
        (not
          (transport_unit_tagged_source ?transport_unit)
        )
        (not
          (transport_unit_tagged_destination ?transport_unit)
        )
        (not
          (transfer_job_ready_for_reconciliation ?transfer_job)
        )
      )
    :effect (transfer_job_ready_for_reconciliation ?transfer_job)
  )
  (:action complete_load_and_attach_equipment_to_transfer_job
    :parameters (?transfer_job - transfer_job ?shift_assignment - shift_assignment ?storage_slot - storage_slot ?transport_unit - transport_unit)
    :precondition
      (and
        (transfer_job_loaded ?transfer_job)
        (transfer_job_assigned_shift ?transfer_job ?shift_assignment)
        (transfer_job_assigned_storage_slot ?transfer_job ?storage_slot)
        (storage_slot_contains_transport_unit ?storage_slot ?transport_unit)
        (transport_unit_tagged_source ?transport_unit)
        (not
          (transport_unit_tagged_destination ?transport_unit)
        )
        (not
          (transfer_job_ready_for_reconciliation ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_ready_for_reconciliation ?transfer_job)
        (transfer_job_equipment_attached ?transfer_job)
      )
  )
  (:action finalize_load_and_attach_equipment_to_transfer_job
    :parameters (?transfer_job - transfer_job ?shift_assignment - shift_assignment ?storage_slot - storage_slot ?transport_unit - transport_unit)
    :precondition
      (and
        (transfer_job_loaded ?transfer_job)
        (transfer_job_assigned_shift ?transfer_job ?shift_assignment)
        (transfer_job_assigned_storage_slot ?transfer_job ?storage_slot)
        (storage_slot_contains_transport_unit ?storage_slot ?transport_unit)
        (not
          (transport_unit_tagged_source ?transport_unit)
        )
        (transport_unit_tagged_destination ?transport_unit)
        (not
          (transfer_job_ready_for_reconciliation ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_ready_for_reconciliation ?transfer_job)
        (transfer_job_equipment_attached ?transfer_job)
      )
  )
  (:action complete_final_load_and_attach_equipment_to_transfer_job
    :parameters (?transfer_job - transfer_job ?shift_assignment - shift_assignment ?storage_slot - storage_slot ?transport_unit - transport_unit)
    :precondition
      (and
        (transfer_job_loaded ?transfer_job)
        (transfer_job_assigned_shift ?transfer_job ?shift_assignment)
        (transfer_job_assigned_storage_slot ?transfer_job ?storage_slot)
        (storage_slot_contains_transport_unit ?storage_slot ?transport_unit)
        (transport_unit_tagged_source ?transport_unit)
        (transport_unit_tagged_destination ?transport_unit)
        (not
          (transfer_job_ready_for_reconciliation ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_ready_for_reconciliation ?transfer_job)
        (transfer_job_equipment_attached ?transfer_job)
      )
  )
  (:action mark_transfer_job_ready_for_reconciliation
    :parameters (?transfer_job - transfer_job)
    :precondition
      (and
        (transfer_job_ready_for_reconciliation ?transfer_job)
        (not
          (transfer_job_equipment_attached ?transfer_job)
        )
        (not
          (transfer_job_reconciled ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_reconciled ?transfer_job)
        (ready_for_scheduling ?transfer_job)
      )
  )
  (:action assign_packing_instruction_to_transfer_job
    :parameters (?transfer_job - transfer_job ?packing_instruction - packing_instruction)
    :precondition
      (and
        (transfer_job_ready_for_reconciliation ?transfer_job)
        (transfer_job_equipment_attached ?transfer_job)
        (packing_instruction_available ?packing_instruction)
      )
    :effect
      (and
        (transfer_job_assigned_packing_instruction ?transfer_job ?packing_instruction)
        (not
          (packing_instruction_available ?packing_instruction)
        )
      )
  )
  (:action commit_transfer_job_resources
    :parameters (?transfer_job - transfer_job ?source_zone - source_zone ?destination_zone - destination_zone ?sku - sku ?packing_instruction - packing_instruction)
    :precondition
      (and
        (transfer_job_ready_for_reconciliation ?transfer_job)
        (transfer_job_equipment_attached ?transfer_job)
        (transfer_job_assigned_packing_instruction ?transfer_job ?packing_instruction)
        (transfer_job_assigned_source_zone ?transfer_job ?source_zone)
        (transfer_job_assigned_destination_zone ?transfer_job ?destination_zone)
        (source_zone_ready ?source_zone)
        (destination_zone_ready ?destination_zone)
        (sku_reserved_for_transfer ?transfer_job ?sku)
        (not
          (transfer_job_resources_committed ?transfer_job)
        )
      )
    :effect (transfer_job_resources_committed ?transfer_job)
  )
  (:action finalize_transfer_job_and_mark_ready
    :parameters (?transfer_job - transfer_job)
    :precondition
      (and
        (transfer_job_ready_for_reconciliation ?transfer_job)
        (transfer_job_resources_committed ?transfer_job)
        (not
          (transfer_job_reconciled ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_reconciled ?transfer_job)
        (ready_for_scheduling ?transfer_job)
      )
  )
  (:action authorize_transfer_job_with_operator_certification
    :parameters (?transfer_job - transfer_job ?operator_certification - operator_certification ?sku - sku)
    :precondition
      (and
        (validated_for_transfer ?transfer_job)
        (sku_reserved_for_transfer ?transfer_job ?sku)
        (operator_certification_available ?operator_certification)
        (transfer_job_assigned_operator_certification ?transfer_job ?operator_certification)
        (not
          (transfer_job_authorized ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_authorized ?transfer_job)
        (not
          (operator_certification_available ?operator_certification)
        )
      )
  )
  (:action prepare_workstation_for_transfer_job
    :parameters (?transfer_job - transfer_job ?workstation - workstation)
    :precondition
      (and
        (transfer_job_authorized ?transfer_job)
        (assigned_workstation_for_transfer ?transfer_job ?workstation)
        (not
          (transfer_job_workstation_prepared ?transfer_job)
        )
      )
    :effect (transfer_job_workstation_prepared ?transfer_job)
  )
  (:action confirm_shift_assignment_for_transfer_job
    :parameters (?transfer_job - transfer_job ?shift_assignment - shift_assignment)
    :precondition
      (and
        (transfer_job_workstation_prepared ?transfer_job)
        (transfer_job_assigned_shift ?transfer_job ?shift_assignment)
        (not
          (transfer_job_shift_assigned ?transfer_job)
        )
      )
    :effect (transfer_job_shift_assigned ?transfer_job)
  )
  (:action finalize_workstation_authorization_for_transfer_job
    :parameters (?transfer_job - transfer_job)
    :precondition
      (and
        (transfer_job_shift_assigned ?transfer_job)
        (not
          (transfer_job_reconciled ?transfer_job)
        )
      )
    :effect
      (and
        (transfer_job_reconciled ?transfer_job)
        (ready_for_scheduling ?transfer_job)
      )
  )
  (:action complete_source_zone_handoff
    :parameters (?source_zone - source_zone ?transport_unit - transport_unit)
    :precondition
      (and
        (source_zone_staged ?source_zone)
        (source_zone_ready ?source_zone)
        (transport_unit_reserved ?transport_unit)
        (transport_unit_verified ?transport_unit)
        (not
          (ready_for_scheduling ?source_zone)
        )
      )
    :effect (ready_for_scheduling ?source_zone)
  )
  (:action complete_destination_zone_handoff
    :parameters (?destination_zone - destination_zone ?transport_unit - transport_unit)
    :precondition
      (and
        (destination_zone_staged ?destination_zone)
        (destination_zone_ready ?destination_zone)
        (transport_unit_reserved ?transport_unit)
        (transport_unit_verified ?transport_unit)
        (not
          (ready_for_scheduling ?destination_zone)
        )
      )
    :effect (ready_for_scheduling ?destination_zone)
  )
  (:action schedule_transfer_request
    :parameters (?transfer_request - transfer_request ?time_slot - time_slot ?sku - sku)
    :precondition
      (and
        (ready_for_scheduling ?transfer_request)
        (sku_reserved_for_transfer ?transfer_request ?sku)
        (time_slot_available ?time_slot)
        (not
          (scheduled_for_transfer ?transfer_request)
        )
      )
    :effect
      (and
        (scheduled_for_transfer ?transfer_request)
        (assigned_time_slot_for_transfer ?transfer_request ?time_slot)
        (not
          (time_slot_available ?time_slot)
        )
      )
  )
  (:action finalize_source_zone_transfer
    :parameters (?source_zone - source_zone ?material_handling_unit - material_handling_unit ?time_slot - time_slot)
    :precondition
      (and
        (scheduled_for_transfer ?source_zone)
        (assigned_mhu_for_transfer ?source_zone ?material_handling_unit)
        (assigned_time_slot_for_transfer ?source_zone ?time_slot)
        (not
          (commitment_for_transfer ?source_zone)
        )
      )
    :effect
      (and
        (commitment_for_transfer ?source_zone)
        (mhu_available ?material_handling_unit)
        (time_slot_available ?time_slot)
      )
  )
  (:action finalize_destination_zone_transfer
    :parameters (?destination_zone - destination_zone ?material_handling_unit - material_handling_unit ?time_slot - time_slot)
    :precondition
      (and
        (scheduled_for_transfer ?destination_zone)
        (assigned_mhu_for_transfer ?destination_zone ?material_handling_unit)
        (assigned_time_slot_for_transfer ?destination_zone ?time_slot)
        (not
          (commitment_for_transfer ?destination_zone)
        )
      )
    :effect
      (and
        (commitment_for_transfer ?destination_zone)
        (mhu_available ?material_handling_unit)
        (time_slot_available ?time_slot)
      )
  )
  (:action finalize_transfer_job_and_release_resources
    :parameters (?transfer_job - transfer_job ?material_handling_unit - material_handling_unit ?time_slot - time_slot)
    :precondition
      (and
        (scheduled_for_transfer ?transfer_job)
        (assigned_mhu_for_transfer ?transfer_job ?material_handling_unit)
        (assigned_time_slot_for_transfer ?transfer_job ?time_slot)
        (not
          (commitment_for_transfer ?transfer_job)
        )
      )
    :effect
      (and
        (commitment_for_transfer ?transfer_job)
        (mhu_available ?material_handling_unit)
        (time_slot_available ?time_slot)
      )
  )
)

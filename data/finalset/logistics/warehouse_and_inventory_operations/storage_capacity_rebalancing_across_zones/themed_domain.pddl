(define (domain warehouse_storage_rebalancing)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object resource - entity item_class - entity slot_class - entity zone_class - entity zone - zone_class move_request - resource sku - resource operator - resource storage_policy - resource load_profile - resource rebalance_batch - resource handling_constraint - resource maintenance_tag - resource inventory_unit - item_class pallet_identifier - item_class audit_token - item_class source_slot - slot_class destination_slot - slot_class carrier - slot_class zone_role - zone storage_group - zone source_zone - zone_role destination_zone - zone_role storage_unit - storage_group)

  (:predicates
    (location_registered ?zone - zone)
    (location_ready ?zone - zone)
    (location_reserved ?zone - zone)
    (location_rebalanced ?zone - zone)
    (operation_completed ?zone - zone)
    (location_authorized_for_transfer ?zone - zone)
    (move_request_available ?move_request - move_request)
    (location_assigned_move_request ?zone - zone ?move_request - move_request)
    (sku_available ?sku - sku)
    (location_has_sku_reservation ?zone - zone ?sku - sku)
    (operator_available ?operator - operator)
    (operator_assigned_to_location ?zone - zone ?operator - operator)
    (inventory_unit_available ?inventory_unit - inventory_unit)
    (inventory_staged_at_source ?source_zone - source_zone ?inventory_unit - inventory_unit)
    (inventory_staged_at_destination ?destination_zone - destination_zone ?inventory_unit - inventory_unit)
    (location_has_source_slot ?source_zone - source_zone ?source_slot - source_slot)
    (source_slot_prepared ?source_slot - source_slot)
    (source_slot_staged ?source_slot - source_slot)
    (source_zone_ready_for_loading ?source_zone - source_zone)
    (destination_zone_has_slot ?destination_zone - destination_zone ?destination_slot - destination_slot)
    (destination_slot_prepared ?destination_slot - destination_slot)
    (destination_slot_staged ?destination_slot - destination_slot)
    (destination_zone_ready_for_loading ?destination_zone - destination_zone)
    (carrier_available ?carrier - carrier)
    (carrier_staged ?carrier - carrier)
    (carrier_assigned_to_source_slot ?carrier - carrier ?source_slot - source_slot)
    (carrier_assigned_to_destination_slot ?carrier - carrier ?destination_slot - destination_slot)
    (carrier_has_source_assignment ?carrier - carrier)
    (carrier_has_destination_assignment ?carrier - carrier)
    (carrier_load_confirmed ?carrier - carrier)
    (storage_unit_in_source_zone ?storage_unit - storage_unit ?source_zone - source_zone)
    (storage_unit_in_destination_zone ?storage_unit - storage_unit ?destination_zone - destination_zone)
    (storage_unit_linked_to_carrier ?storage_unit - storage_unit ?carrier - carrier)
    (pallet_id_available ?pallet_identifier - pallet_identifier)
    (storage_unit_has_pallet_id ?storage_unit - storage_unit ?pallet_identifier - pallet_identifier)
    (pallet_id_applied ?pallet_identifier - pallet_identifier)
    (pallet_id_assigned_to_carrier ?pallet_identifier - pallet_identifier ?carrier - carrier)
    (storage_unit_label_applied ?storage_unit - storage_unit)
    (storage_unit_load_verified ?storage_unit - storage_unit)
    (storage_unit_prepared_for_execution ?storage_unit - storage_unit)
    (storage_unit_policy_applied ?storage_unit - storage_unit)
    (storage_unit_policy_verified ?storage_unit - storage_unit)
    (load_profile_applied_to_storage_unit ?storage_unit - storage_unit)
    (storage_unit_loading_executed ?storage_unit - storage_unit)
    (audit_token_available ?audit_token - audit_token)
    (audit_token_associated_with_storage_unit ?storage_unit - storage_unit ?audit_token - audit_token)
    (storage_unit_audit_verified ?storage_unit - storage_unit)
    (storage_unit_authorization_granted ?storage_unit - storage_unit)
    (storage_unit_authorization_confirmed ?storage_unit - storage_unit)
    (storage_policy_available ?storage_policy - storage_policy)
    (storage_unit_has_storage_policy ?storage_unit - storage_unit ?storage_policy - storage_policy)
    (load_profile_available ?load_profile - load_profile)
    (storage_unit_has_load_profile ?storage_unit - storage_unit ?load_profile - load_profile)
    (handling_constraint_available ?handling_constraint - handling_constraint)
    (storage_unit_has_handling_constraint ?storage_unit - storage_unit ?handling_constraint - handling_constraint)
    (maintenance_tag_available ?maintenance_tag - maintenance_tag)
    (storage_unit_has_maintenance_tag ?storage_unit - storage_unit ?maintenance_tag - maintenance_tag)
    (rebalance_batch_available ?rebalance_batch - rebalance_batch)
    (location_assigned_to_rebalance_batch ?zone - zone ?rebalance_batch - rebalance_batch)
    (source_zone_prepared ?source_zone - source_zone)
    (destination_zone_prepared ?destination_zone - destination_zone)
    (storage_unit_verified ?storage_unit - storage_unit)
  )
  (:action initialize_location
    :parameters (?zone - zone)
    :precondition
      (and
        (not
          (location_registered ?zone)
        )
        (not
          (location_rebalanced ?zone)
        )
      )
    :effect (location_registered ?zone)
  )
  (:action assign_move_request_to_location
    :parameters (?zone - zone ?move_request - move_request)
    :precondition
      (and
        (location_registered ?zone)
        (not
          (location_reserved ?zone)
        )
        (move_request_available ?move_request)
      )
    :effect
      (and
        (location_reserved ?zone)
        (location_assigned_move_request ?zone ?move_request)
        (not
          (move_request_available ?move_request)
        )
      )
  )
  (:action reserve_sku_for_location
    :parameters (?zone - zone ?sku - sku)
    :precondition
      (and
        (location_registered ?zone)
        (location_reserved ?zone)
        (sku_available ?sku)
      )
    :effect
      (and
        (location_has_sku_reservation ?zone ?sku)
        (not
          (sku_available ?sku)
        )
      )
  )
  (:action confirm_location_reservation
    :parameters (?zone - zone ?sku - sku)
    :precondition
      (and
        (location_registered ?zone)
        (location_reserved ?zone)
        (location_has_sku_reservation ?zone ?sku)
        (not
          (location_ready ?zone)
        )
      )
    :effect (location_ready ?zone)
  )
  (:action release_location_sku_reservation
    :parameters (?zone - zone ?sku - sku)
    :precondition
      (and
        (location_has_sku_reservation ?zone ?sku)
      )
    :effect
      (and
        (sku_available ?sku)
        (not
          (location_has_sku_reservation ?zone ?sku)
        )
      )
  )
  (:action assign_operator_to_location
    :parameters (?zone - zone ?operator - operator)
    :precondition
      (and
        (location_ready ?zone)
        (operator_available ?operator)
      )
    :effect
      (and
        (operator_assigned_to_location ?zone ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action release_operator_from_location
    :parameters (?zone - zone ?operator - operator)
    :precondition
      (and
        (operator_assigned_to_location ?zone ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (operator_assigned_to_location ?zone ?operator)
        )
      )
  )
  (:action apply_handling_constraint_to_storage_unit
    :parameters (?storage_unit - storage_unit ?handling_constraint - handling_constraint)
    :precondition
      (and
        (location_ready ?storage_unit)
        (handling_constraint_available ?handling_constraint)
      )
    :effect
      (and
        (storage_unit_has_handling_constraint ?storage_unit ?handling_constraint)
        (not
          (handling_constraint_available ?handling_constraint)
        )
      )
  )
  (:action release_handling_constraint_from_storage_unit
    :parameters (?storage_unit - storage_unit ?handling_constraint - handling_constraint)
    :precondition
      (and
        (storage_unit_has_handling_constraint ?storage_unit ?handling_constraint)
      )
    :effect
      (and
        (handling_constraint_available ?handling_constraint)
        (not
          (storage_unit_has_handling_constraint ?storage_unit ?handling_constraint)
        )
      )
  )
  (:action assign_maintenance_tag_to_storage_unit
    :parameters (?storage_unit - storage_unit ?maintenance_tag - maintenance_tag)
    :precondition
      (and
        (location_ready ?storage_unit)
        (maintenance_tag_available ?maintenance_tag)
      )
    :effect
      (and
        (storage_unit_has_maintenance_tag ?storage_unit ?maintenance_tag)
        (not
          (maintenance_tag_available ?maintenance_tag)
        )
      )
  )
  (:action release_maintenance_tag_from_storage_unit
    :parameters (?storage_unit - storage_unit ?maintenance_tag - maintenance_tag)
    :precondition
      (and
        (storage_unit_has_maintenance_tag ?storage_unit ?maintenance_tag)
      )
    :effect
      (and
        (maintenance_tag_available ?maintenance_tag)
        (not
          (storage_unit_has_maintenance_tag ?storage_unit ?maintenance_tag)
        )
      )
  )
  (:action prepare_source_slot
    :parameters (?source_zone - source_zone ?source_slot - source_slot ?sku - sku)
    :precondition
      (and
        (location_ready ?source_zone)
        (location_has_sku_reservation ?source_zone ?sku)
        (location_has_source_slot ?source_zone ?source_slot)
        (not
          (source_slot_prepared ?source_slot)
        )
        (not
          (source_slot_staged ?source_slot)
        )
      )
    :effect (source_slot_prepared ?source_slot)
  )
  (:action confirm_source_slot_preparation
    :parameters (?source_zone - source_zone ?source_slot - source_slot ?operator - operator)
    :precondition
      (and
        (location_ready ?source_zone)
        (operator_assigned_to_location ?source_zone ?operator)
        (location_has_source_slot ?source_zone ?source_slot)
        (source_slot_prepared ?source_slot)
        (not
          (source_zone_prepared ?source_zone)
        )
      )
    :effect
      (and
        (source_zone_prepared ?source_zone)
        (source_zone_ready_for_loading ?source_zone)
      )
  )
  (:action stage_inventory_unit_at_source_slot
    :parameters (?source_zone - source_zone ?source_slot - source_slot ?inventory_unit - inventory_unit)
    :precondition
      (and
        (location_ready ?source_zone)
        (location_has_source_slot ?source_zone ?source_slot)
        (inventory_unit_available ?inventory_unit)
        (not
          (source_zone_prepared ?source_zone)
        )
      )
    :effect
      (and
        (source_slot_staged ?source_slot)
        (source_zone_prepared ?source_zone)
        (inventory_staged_at_source ?source_zone ?inventory_unit)
        (not
          (inventory_unit_available ?inventory_unit)
        )
      )
  )
  (:action confirm_inventory_staged_at_source_slot
    :parameters (?source_zone - source_zone ?source_slot - source_slot ?sku - sku ?inventory_unit - inventory_unit)
    :precondition
      (and
        (location_ready ?source_zone)
        (location_has_sku_reservation ?source_zone ?sku)
        (location_has_source_slot ?source_zone ?source_slot)
        (source_slot_staged ?source_slot)
        (inventory_staged_at_source ?source_zone ?inventory_unit)
        (not
          (source_zone_ready_for_loading ?source_zone)
        )
      )
    :effect
      (and
        (source_slot_prepared ?source_slot)
        (source_zone_ready_for_loading ?source_zone)
        (inventory_unit_available ?inventory_unit)
        (not
          (inventory_staged_at_source ?source_zone ?inventory_unit)
        )
      )
  )
  (:action prepare_destination_slot
    :parameters (?destination_zone - destination_zone ?destination_slot - destination_slot ?sku - sku)
    :precondition
      (and
        (location_ready ?destination_zone)
        (location_has_sku_reservation ?destination_zone ?sku)
        (destination_zone_has_slot ?destination_zone ?destination_slot)
        (not
          (destination_slot_prepared ?destination_slot)
        )
        (not
          (destination_slot_staged ?destination_slot)
        )
      )
    :effect (destination_slot_prepared ?destination_slot)
  )
  (:action confirm_destination_slot_preparation
    :parameters (?destination_zone - destination_zone ?destination_slot - destination_slot ?operator - operator)
    :precondition
      (and
        (location_ready ?destination_zone)
        (operator_assigned_to_location ?destination_zone ?operator)
        (destination_zone_has_slot ?destination_zone ?destination_slot)
        (destination_slot_prepared ?destination_slot)
        (not
          (destination_zone_prepared ?destination_zone)
        )
      )
    :effect
      (and
        (destination_zone_prepared ?destination_zone)
        (destination_zone_ready_for_loading ?destination_zone)
      )
  )
  (:action stage_inventory_unit_at_destination_slot
    :parameters (?destination_zone - destination_zone ?destination_slot - destination_slot ?inventory_unit - inventory_unit)
    :precondition
      (and
        (location_ready ?destination_zone)
        (destination_zone_has_slot ?destination_zone ?destination_slot)
        (inventory_unit_available ?inventory_unit)
        (not
          (destination_zone_prepared ?destination_zone)
        )
      )
    :effect
      (and
        (destination_slot_staged ?destination_slot)
        (destination_zone_prepared ?destination_zone)
        (inventory_staged_at_destination ?destination_zone ?inventory_unit)
        (not
          (inventory_unit_available ?inventory_unit)
        )
      )
  )
  (:action confirm_inventory_staged_at_destination_slot
    :parameters (?destination_zone - destination_zone ?destination_slot - destination_slot ?sku - sku ?inventory_unit - inventory_unit)
    :precondition
      (and
        (location_ready ?destination_zone)
        (location_has_sku_reservation ?destination_zone ?sku)
        (destination_zone_has_slot ?destination_zone ?destination_slot)
        (destination_slot_staged ?destination_slot)
        (inventory_staged_at_destination ?destination_zone ?inventory_unit)
        (not
          (destination_zone_ready_for_loading ?destination_zone)
        )
      )
    :effect
      (and
        (destination_slot_prepared ?destination_slot)
        (destination_zone_ready_for_loading ?destination_zone)
        (inventory_unit_available ?inventory_unit)
        (not
          (inventory_staged_at_destination ?destination_zone ?inventory_unit)
        )
      )
  )
  (:action stage_carrier_for_transfer
    :parameters (?source_zone - source_zone ?destination_zone - destination_zone ?source_slot - source_slot ?destination_slot - destination_slot ?carrier - carrier)
    :precondition
      (and
        (source_zone_prepared ?source_zone)
        (destination_zone_prepared ?destination_zone)
        (location_has_source_slot ?source_zone ?source_slot)
        (destination_zone_has_slot ?destination_zone ?destination_slot)
        (source_slot_prepared ?source_slot)
        (destination_slot_prepared ?destination_slot)
        (source_zone_ready_for_loading ?source_zone)
        (destination_zone_ready_for_loading ?destination_zone)
        (carrier_available ?carrier)
      )
    :effect
      (and
        (carrier_staged ?carrier)
        (carrier_assigned_to_source_slot ?carrier ?source_slot)
        (carrier_assigned_to_destination_slot ?carrier ?destination_slot)
        (not
          (carrier_available ?carrier)
        )
      )
  )
  (:action stage_carrier_and_flag_source_assignment
    :parameters (?source_zone - source_zone ?destination_zone - destination_zone ?source_slot - source_slot ?destination_slot - destination_slot ?carrier - carrier)
    :precondition
      (and
        (source_zone_prepared ?source_zone)
        (destination_zone_prepared ?destination_zone)
        (location_has_source_slot ?source_zone ?source_slot)
        (destination_zone_has_slot ?destination_zone ?destination_slot)
        (source_slot_staged ?source_slot)
        (destination_slot_prepared ?destination_slot)
        (not
          (source_zone_ready_for_loading ?source_zone)
        )
        (destination_zone_ready_for_loading ?destination_zone)
        (carrier_available ?carrier)
      )
    :effect
      (and
        (carrier_staged ?carrier)
        (carrier_assigned_to_source_slot ?carrier ?source_slot)
        (carrier_assigned_to_destination_slot ?carrier ?destination_slot)
        (carrier_has_source_assignment ?carrier)
        (not
          (carrier_available ?carrier)
        )
      )
  )
  (:action stage_carrier_and_flag_destination_assignment
    :parameters (?source_zone - source_zone ?destination_zone - destination_zone ?source_slot - source_slot ?destination_slot - destination_slot ?carrier - carrier)
    :precondition
      (and
        (source_zone_prepared ?source_zone)
        (destination_zone_prepared ?destination_zone)
        (location_has_source_slot ?source_zone ?source_slot)
        (destination_zone_has_slot ?destination_zone ?destination_slot)
        (source_slot_prepared ?source_slot)
        (destination_slot_staged ?destination_slot)
        (source_zone_ready_for_loading ?source_zone)
        (not
          (destination_zone_ready_for_loading ?destination_zone)
        )
        (carrier_available ?carrier)
      )
    :effect
      (and
        (carrier_staged ?carrier)
        (carrier_assigned_to_source_slot ?carrier ?source_slot)
        (carrier_assigned_to_destination_slot ?carrier ?destination_slot)
        (carrier_has_destination_assignment ?carrier)
        (not
          (carrier_available ?carrier)
        )
      )
  )
  (:action stage_carrier_with_both_assignments
    :parameters (?source_zone - source_zone ?destination_zone - destination_zone ?source_slot - source_slot ?destination_slot - destination_slot ?carrier - carrier)
    :precondition
      (and
        (source_zone_prepared ?source_zone)
        (destination_zone_prepared ?destination_zone)
        (location_has_source_slot ?source_zone ?source_slot)
        (destination_zone_has_slot ?destination_zone ?destination_slot)
        (source_slot_staged ?source_slot)
        (destination_slot_staged ?destination_slot)
        (not
          (source_zone_ready_for_loading ?source_zone)
        )
        (not
          (destination_zone_ready_for_loading ?destination_zone)
        )
        (carrier_available ?carrier)
      )
    :effect
      (and
        (carrier_staged ?carrier)
        (carrier_assigned_to_source_slot ?carrier ?source_slot)
        (carrier_assigned_to_destination_slot ?carrier ?destination_slot)
        (carrier_has_source_assignment ?carrier)
        (carrier_has_destination_assignment ?carrier)
        (not
          (carrier_available ?carrier)
        )
      )
  )
  (:action confirm_carrier_load_ready
    :parameters (?carrier - carrier ?source_zone - source_zone ?sku - sku)
    :precondition
      (and
        (carrier_staged ?carrier)
        (source_zone_prepared ?source_zone)
        (location_has_sku_reservation ?source_zone ?sku)
        (not
          (carrier_load_confirmed ?carrier)
        )
      )
    :effect (carrier_load_confirmed ?carrier)
  )
  (:action apply_pallet_identifier_to_storage_unit
    :parameters (?storage_unit - storage_unit ?pallet_identifier - pallet_identifier ?carrier - carrier)
    :precondition
      (and
        (location_ready ?storage_unit)
        (storage_unit_linked_to_carrier ?storage_unit ?carrier)
        (storage_unit_has_pallet_id ?storage_unit ?pallet_identifier)
        (pallet_id_available ?pallet_identifier)
        (carrier_staged ?carrier)
        (carrier_load_confirmed ?carrier)
        (not
          (pallet_id_applied ?pallet_identifier)
        )
      )
    :effect
      (and
        (pallet_id_applied ?pallet_identifier)
        (pallet_id_assigned_to_carrier ?pallet_identifier ?carrier)
        (not
          (pallet_id_available ?pallet_identifier)
        )
      )
  )
  (:action confirm_pallet_label_linkage
    :parameters (?storage_unit - storage_unit ?pallet_identifier - pallet_identifier ?carrier - carrier ?sku - sku)
    :precondition
      (and
        (location_ready ?storage_unit)
        (storage_unit_has_pallet_id ?storage_unit ?pallet_identifier)
        (pallet_id_applied ?pallet_identifier)
        (pallet_id_assigned_to_carrier ?pallet_identifier ?carrier)
        (location_has_sku_reservation ?storage_unit ?sku)
        (not
          (carrier_has_source_assignment ?carrier)
        )
        (not
          (storage_unit_label_applied ?storage_unit)
        )
      )
    :effect (storage_unit_label_applied ?storage_unit)
  )
  (:action apply_storage_policy_to_storage_unit
    :parameters (?storage_unit - storage_unit ?storage_policy - storage_policy)
    :precondition
      (and
        (location_ready ?storage_unit)
        (storage_policy_available ?storage_policy)
        (not
          (storage_unit_policy_applied ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_policy_applied ?storage_unit)
        (storage_unit_has_storage_policy ?storage_unit ?storage_policy)
        (not
          (storage_policy_available ?storage_policy)
        )
      )
  )
  (:action finalize_pallet_and_policy_assignment
    :parameters (?storage_unit - storage_unit ?pallet_identifier - pallet_identifier ?carrier - carrier ?sku - sku ?storage_policy - storage_policy)
    :precondition
      (and
        (location_ready ?storage_unit)
        (storage_unit_has_pallet_id ?storage_unit ?pallet_identifier)
        (pallet_id_applied ?pallet_identifier)
        (pallet_id_assigned_to_carrier ?pallet_identifier ?carrier)
        (location_has_sku_reservation ?storage_unit ?sku)
        (carrier_has_source_assignment ?carrier)
        (storage_unit_policy_applied ?storage_unit)
        (storage_unit_has_storage_policy ?storage_unit ?storage_policy)
        (not
          (storage_unit_label_applied ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_label_applied ?storage_unit)
        (storage_unit_policy_verified ?storage_unit)
      )
  )
  (:action verify_load_with_handling_constraint
    :parameters (?storage_unit - storage_unit ?handling_constraint - handling_constraint ?operator - operator ?pallet_identifier - pallet_identifier ?carrier - carrier)
    :precondition
      (and
        (storage_unit_label_applied ?storage_unit)
        (storage_unit_has_handling_constraint ?storage_unit ?handling_constraint)
        (operator_assigned_to_location ?storage_unit ?operator)
        (storage_unit_has_pallet_id ?storage_unit ?pallet_identifier)
        (pallet_id_assigned_to_carrier ?pallet_identifier ?carrier)
        (not
          (carrier_has_destination_assignment ?carrier)
        )
        (not
          (storage_unit_load_verified ?storage_unit)
        )
      )
    :effect (storage_unit_load_verified ?storage_unit)
  )
  (:action confirm_load_verification
    :parameters (?storage_unit - storage_unit ?handling_constraint - handling_constraint ?operator - operator ?pallet_identifier - pallet_identifier ?carrier - carrier)
    :precondition
      (and
        (storage_unit_label_applied ?storage_unit)
        (storage_unit_has_handling_constraint ?storage_unit ?handling_constraint)
        (operator_assigned_to_location ?storage_unit ?operator)
        (storage_unit_has_pallet_id ?storage_unit ?pallet_identifier)
        (pallet_id_assigned_to_carrier ?pallet_identifier ?carrier)
        (carrier_has_destination_assignment ?carrier)
        (not
          (storage_unit_load_verified ?storage_unit)
        )
      )
    :effect (storage_unit_load_verified ?storage_unit)
  )
  (:action mark_storage_unit_ready_after_maintenance_check
    :parameters (?storage_unit - storage_unit ?maintenance_tag - maintenance_tag ?pallet_identifier - pallet_identifier ?carrier - carrier)
    :precondition
      (and
        (storage_unit_load_verified ?storage_unit)
        (storage_unit_has_maintenance_tag ?storage_unit ?maintenance_tag)
        (storage_unit_has_pallet_id ?storage_unit ?pallet_identifier)
        (pallet_id_assigned_to_carrier ?pallet_identifier ?carrier)
        (not
          (carrier_has_source_assignment ?carrier)
        )
        (not
          (carrier_has_destination_assignment ?carrier)
        )
        (not
          (storage_unit_prepared_for_execution ?storage_unit)
        )
      )
    :effect (storage_unit_prepared_for_execution ?storage_unit)
  )
  (:action apply_load_profile_and_mark_ready
    :parameters (?storage_unit - storage_unit ?maintenance_tag - maintenance_tag ?pallet_identifier - pallet_identifier ?carrier - carrier)
    :precondition
      (and
        (storage_unit_load_verified ?storage_unit)
        (storage_unit_has_maintenance_tag ?storage_unit ?maintenance_tag)
        (storage_unit_has_pallet_id ?storage_unit ?pallet_identifier)
        (pallet_id_assigned_to_carrier ?pallet_identifier ?carrier)
        (carrier_has_source_assignment ?carrier)
        (not
          (carrier_has_destination_assignment ?carrier)
        )
        (not
          (storage_unit_prepared_for_execution ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_prepared_for_execution ?storage_unit)
        (load_profile_applied_to_storage_unit ?storage_unit)
      )
  )
  (:action confirm_load_profile_and_ready
    :parameters (?storage_unit - storage_unit ?maintenance_tag - maintenance_tag ?pallet_identifier - pallet_identifier ?carrier - carrier)
    :precondition
      (and
        (storage_unit_load_verified ?storage_unit)
        (storage_unit_has_maintenance_tag ?storage_unit ?maintenance_tag)
        (storage_unit_has_pallet_id ?storage_unit ?pallet_identifier)
        (pallet_id_assigned_to_carrier ?pallet_identifier ?carrier)
        (not
          (carrier_has_source_assignment ?carrier)
        )
        (carrier_has_destination_assignment ?carrier)
        (not
          (storage_unit_prepared_for_execution ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_prepared_for_execution ?storage_unit)
        (load_profile_applied_to_storage_unit ?storage_unit)
      )
  )
  (:action finalize_load_profile_and_ready
    :parameters (?storage_unit - storage_unit ?maintenance_tag - maintenance_tag ?pallet_identifier - pallet_identifier ?carrier - carrier)
    :precondition
      (and
        (storage_unit_load_verified ?storage_unit)
        (storage_unit_has_maintenance_tag ?storage_unit ?maintenance_tag)
        (storage_unit_has_pallet_id ?storage_unit ?pallet_identifier)
        (pallet_id_assigned_to_carrier ?pallet_identifier ?carrier)
        (carrier_has_source_assignment ?carrier)
        (carrier_has_destination_assignment ?carrier)
        (not
          (storage_unit_prepared_for_execution ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_prepared_for_execution ?storage_unit)
        (load_profile_applied_to_storage_unit ?storage_unit)
      )
  )
  (:action finalize_storage_unit_execution
    :parameters (?storage_unit - storage_unit)
    :precondition
      (and
        (storage_unit_prepared_for_execution ?storage_unit)
        (not
          (load_profile_applied_to_storage_unit ?storage_unit)
        )
        (not
          (storage_unit_verified ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_verified ?storage_unit)
        (operation_completed ?storage_unit)
      )
  )
  (:action assign_load_profile_to_storage_unit
    :parameters (?storage_unit - storage_unit ?load_profile - load_profile)
    :precondition
      (and
        (storage_unit_prepared_for_execution ?storage_unit)
        (load_profile_applied_to_storage_unit ?storage_unit)
        (load_profile_available ?load_profile)
      )
    :effect
      (and
        (storage_unit_has_load_profile ?storage_unit ?load_profile)
        (not
          (load_profile_available ?load_profile)
        )
      )
  )
  (:action execute_storage_unit_loading_procedure
    :parameters (?storage_unit - storage_unit ?source_zone - source_zone ?destination_zone - destination_zone ?sku - sku ?load_profile - load_profile)
    :precondition
      (and
        (storage_unit_prepared_for_execution ?storage_unit)
        (load_profile_applied_to_storage_unit ?storage_unit)
        (storage_unit_has_load_profile ?storage_unit ?load_profile)
        (storage_unit_in_source_zone ?storage_unit ?source_zone)
        (storage_unit_in_destination_zone ?storage_unit ?destination_zone)
        (source_zone_ready_for_loading ?source_zone)
        (destination_zone_ready_for_loading ?destination_zone)
        (location_has_sku_reservation ?storage_unit ?sku)
        (not
          (storage_unit_loading_executed ?storage_unit)
        )
      )
    :effect (storage_unit_loading_executed ?storage_unit)
  )
  (:action confirm_storage_unit_load_completion
    :parameters (?storage_unit - storage_unit)
    :precondition
      (and
        (storage_unit_prepared_for_execution ?storage_unit)
        (storage_unit_loading_executed ?storage_unit)
        (not
          (storage_unit_verified ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_verified ?storage_unit)
        (operation_completed ?storage_unit)
      )
  )
  (:action associate_audit_token_with_storage_unit
    :parameters (?storage_unit - storage_unit ?audit_token - audit_token ?sku - sku)
    :precondition
      (and
        (location_ready ?storage_unit)
        (location_has_sku_reservation ?storage_unit ?sku)
        (audit_token_available ?audit_token)
        (audit_token_associated_with_storage_unit ?storage_unit ?audit_token)
        (not
          (storage_unit_audit_verified ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_audit_verified ?storage_unit)
        (not
          (audit_token_available ?audit_token)
        )
      )
  )
  (:action authorize_storage_unit_with_operator
    :parameters (?storage_unit - storage_unit ?operator - operator)
    :precondition
      (and
        (storage_unit_audit_verified ?storage_unit)
        (operator_assigned_to_location ?storage_unit ?operator)
        (not
          (storage_unit_authorization_granted ?storage_unit)
        )
      )
    :effect (storage_unit_authorization_granted ?storage_unit)
  )
  (:action confirm_storage_unit_authorization_post_maintenance
    :parameters (?storage_unit - storage_unit ?maintenance_tag - maintenance_tag)
    :precondition
      (and
        (storage_unit_authorization_granted ?storage_unit)
        (storage_unit_has_maintenance_tag ?storage_unit ?maintenance_tag)
        (not
          (storage_unit_authorization_confirmed ?storage_unit)
        )
      )
    :effect (storage_unit_authorization_confirmed ?storage_unit)
  )
  (:action finalize_storage_unit_authorization
    :parameters (?storage_unit - storage_unit)
    :precondition
      (and
        (storage_unit_authorization_confirmed ?storage_unit)
        (not
          (storage_unit_verified ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_verified ?storage_unit)
        (operation_completed ?storage_unit)
      )
  )
  (:action complete_source_location_transfer
    :parameters (?source_zone - source_zone ?carrier - carrier)
    :precondition
      (and
        (source_zone_prepared ?source_zone)
        (source_zone_ready_for_loading ?source_zone)
        (carrier_staged ?carrier)
        (carrier_load_confirmed ?carrier)
        (not
          (operation_completed ?source_zone)
        )
      )
    :effect (operation_completed ?source_zone)
  )
  (:action complete_destination_location_transfer
    :parameters (?destination_zone - destination_zone ?carrier - carrier)
    :precondition
      (and
        (destination_zone_prepared ?destination_zone)
        (destination_zone_ready_for_loading ?destination_zone)
        (carrier_staged ?carrier)
        (carrier_load_confirmed ?carrier)
        (not
          (operation_completed ?destination_zone)
        )
      )
    :effect (operation_completed ?destination_zone)
  )
  (:action authorize_location_for_rebalance_batch
    :parameters (?zone - zone ?rebalance_batch - rebalance_batch ?sku - sku)
    :precondition
      (and
        (operation_completed ?zone)
        (location_has_sku_reservation ?zone ?sku)
        (rebalance_batch_available ?rebalance_batch)
        (not
          (location_authorized_for_transfer ?zone)
        )
      )
    :effect
      (and
        (location_authorized_for_transfer ?zone)
        (location_assigned_to_rebalance_batch ?zone ?rebalance_batch)
        (not
          (rebalance_batch_available ?rebalance_batch)
        )
      )
  )
  (:action finalize_rebalance_and_release_request
    :parameters (?source_zone - source_zone ?move_request - move_request ?rebalance_batch - rebalance_batch)
    :precondition
      (and
        (location_authorized_for_transfer ?source_zone)
        (location_assigned_move_request ?source_zone ?move_request)
        (location_assigned_to_rebalance_batch ?source_zone ?rebalance_batch)
        (not
          (location_rebalanced ?source_zone)
        )
      )
    :effect
      (and
        (location_rebalanced ?source_zone)
        (move_request_available ?move_request)
        (rebalance_batch_available ?rebalance_batch)
      )
  )
  (:action finalize_rebalance_and_release_request_for_destination
    :parameters (?destination_zone - destination_zone ?move_request - move_request ?rebalance_batch - rebalance_batch)
    :precondition
      (and
        (location_authorized_for_transfer ?destination_zone)
        (location_assigned_move_request ?destination_zone ?move_request)
        (location_assigned_to_rebalance_batch ?destination_zone ?rebalance_batch)
        (not
          (location_rebalanced ?destination_zone)
        )
      )
    :effect
      (and
        (location_rebalanced ?destination_zone)
        (move_request_available ?move_request)
        (rebalance_batch_available ?rebalance_batch)
      )
  )
  (:action finalize_storage_unit_rebalance_and_release_request
    :parameters (?storage_unit - storage_unit ?move_request - move_request ?rebalance_batch - rebalance_batch)
    :precondition
      (and
        (location_authorized_for_transfer ?storage_unit)
        (location_assigned_move_request ?storage_unit ?move_request)
        (location_assigned_to_rebalance_batch ?storage_unit ?rebalance_batch)
        (not
          (location_rebalanced ?storage_unit)
        )
      )
    :effect
      (and
        (location_rebalanced ?storage_unit)
        (move_request_available ?move_request)
        (rebalance_batch_available ?rebalance_batch)
      )
  )
)

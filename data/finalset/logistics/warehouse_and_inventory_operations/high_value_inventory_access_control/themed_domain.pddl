(define (domain high_value_inventory_access_control)
  (:requirements :strips :typing :negative-preconditions)
  (:types equipment_group - object location_component_group - object asset_attribute_group - object inventory_node_group - object tracked_entity - inventory_node_group transfer_tray - equipment_group handheld_scanner - equipment_group material_handling_equipment - equipment_group credential_token - equipment_group shipment_label - equipment_group asset_tag - equipment_group seal_type - equipment_group approval_code - equipment_group tamper_seal - location_component_group storage_slot - location_component_group supervisor_id - location_component_group source_location - asset_attribute_group destination_location - asset_attribute_group secure_container - asset_attribute_group inventory_subclass - tracked_entity inventory_subclass_b - tracked_entity picker - inventory_subclass packer - inventory_subclass security_officer - inventory_subclass_b)
  (:predicates
    (receipt_logged ?inventory_entity - tracked_entity)
    (initial_record_finalized ?inventory_entity - tracked_entity)
    (tray_assignment_flag ?inventory_entity - tracked_entity)
    (handler_released ?inventory_entity - tracked_entity)
    (manifest_verified ?inventory_entity - tracked_entity)
    (approval_granted ?inventory_entity - tracked_entity)
    (tray_available ?transfer_tray - transfer_tray)
    (assigned_to_transfer_tray ?inventory_entity - tracked_entity ?transfer_tray - transfer_tray)
    (scanner_available ?handheld_scanner - handheld_scanner)
    (scanner_assigned ?inventory_entity - tracked_entity ?handheld_scanner - handheld_scanner)
    (mhe_available ?material_handling_equipment - material_handling_equipment)
    (mhe_assigned ?inventory_entity - tracked_entity ?material_handling_equipment - material_handling_equipment)
    (tamper_seal_available ?tamper_seal - tamper_seal)
    (seal_assigned_to_picker ?picker - picker ?tamper_seal - tamper_seal)
    (seal_assigned_to_packer ?packer - packer ?tamper_seal - tamper_seal)
    (assigned_source_location ?picker - picker ?source_location - source_location)
    (source_location_staged ?source_location - source_location)
    (source_location_reserved ?source_location - source_location)
    (picker_staging_complete ?picker - picker)
    (assigned_destination_location ?packer - packer ?destination_location - destination_location)
    (destination_location_staged ?destination_location - destination_location)
    (destination_location_reserved ?destination_location - destination_location)
    (packer_staging_complete ?packer - packer)
    (container_available ?secure_container - secure_container)
    (container_claimed ?secure_container - secure_container)
    (container_assigned_source ?secure_container - secure_container ?source_location - source_location)
    (container_assigned_destination ?secure_container - secure_container ?destination_location - destination_location)
    (container_ready_from_source ?secure_container - secure_container)
    (container_ready_from_destination ?secure_container - secure_container)
    (container_inspected ?secure_container - secure_container)
    (officer_assigned_picker ?security_officer - security_officer ?picker - picker)
    (officer_assigned_packer ?security_officer - security_officer ?packer - packer)
    (officer_assigned_container ?security_officer - security_officer ?secure_container - secure_container)
    (storage_slot_available ?storage_slot - storage_slot)
    (officer_assigned_slot ?security_officer - security_officer ?storage_slot - storage_slot)
    (storage_slot_reserved ?storage_slot - storage_slot)
    (slot_assigned_to_container ?storage_slot - storage_slot ?secure_container - secure_container)
    (officer_verification_complete ?security_officer - security_officer)
    (officer_ready_for_approval ?security_officer - security_officer)
    (officer_manifest_prepared ?security_officer - security_officer)
    (officer_has_credential_token ?security_officer - security_officer)
    (officer_slot_confirmed ?security_officer - security_officer)
    (officer_has_label ?security_officer - security_officer)
    (officer_checklist_complete ?security_officer - security_officer)
    (supervisor_id_available ?supervisor_id - supervisor_id)
    (officer_assigned_supervisor_id ?security_officer - security_officer ?supervisor_id - supervisor_id)
    (officer_supervisor_verified ?security_officer - security_officer)
    (officer_authenticated ?security_officer - security_officer)
    (officer_supervisor_approved ?security_officer - security_officer)
    (credential_token_available ?credential_token - credential_token)
    (officer_assigned_token ?security_officer - security_officer ?credential_token - credential_token)
    (label_available ?shipment_label - shipment_label)
    (officer_assigned_label ?security_officer - security_officer ?shipment_label - shipment_label)
    (seal_type_available ?seal_type - seal_type)
    (officer_assigned_seal_type ?security_officer - security_officer ?seal_type - seal_type)
    (approval_code_available ?approval_code - approval_code)
    (officer_assigned_approval_code ?security_officer - security_officer ?approval_code - approval_code)
    (asset_tag_available ?asset_tag - asset_tag)
    (asset_tag_assigned ?inventory_entity - tracked_entity ?asset_tag - asset_tag)
    (picker_ready ?picker - picker)
    (packer_ready ?packer - packer)
    (release_recorded ?security_officer - security_officer)
  )
  (:action register_receipt
    :parameters (?inventory_entity - tracked_entity)
    :precondition
      (and
        (not
          (receipt_logged ?inventory_entity)
        )
        (not
          (handler_released ?inventory_entity)
        )
      )
    :effect (receipt_logged ?inventory_entity)
  )
  (:action allocate_transfer_tray
    :parameters (?inventory_entity - tracked_entity ?transfer_tray - transfer_tray)
    :precondition
      (and
        (receipt_logged ?inventory_entity)
        (not
          (tray_assignment_flag ?inventory_entity)
        )
        (tray_available ?transfer_tray)
      )
    :effect
      (and
        (tray_assignment_flag ?inventory_entity)
        (assigned_to_transfer_tray ?inventory_entity ?transfer_tray)
        (not
          (tray_available ?transfer_tray)
        )
      )
  )
  (:action assign_scanner_to_entity
    :parameters (?inventory_entity - tracked_entity ?handheld_scanner - handheld_scanner)
    :precondition
      (and
        (receipt_logged ?inventory_entity)
        (tray_assignment_flag ?inventory_entity)
        (scanner_available ?handheld_scanner)
      )
    :effect
      (and
        (scanner_assigned ?inventory_entity ?handheld_scanner)
        (not
          (scanner_available ?handheld_scanner)
        )
      )
  )
  (:action complete_initial_inventory_record
    :parameters (?inventory_entity - tracked_entity ?handheld_scanner - handheld_scanner)
    :precondition
      (and
        (receipt_logged ?inventory_entity)
        (tray_assignment_flag ?inventory_entity)
        (scanner_assigned ?inventory_entity ?handheld_scanner)
        (not
          (initial_record_finalized ?inventory_entity)
        )
      )
    :effect (initial_record_finalized ?inventory_entity)
  )
  (:action return_scanner
    :parameters (?inventory_entity - tracked_entity ?handheld_scanner - handheld_scanner)
    :precondition
      (and
        (scanner_assigned ?inventory_entity ?handheld_scanner)
      )
    :effect
      (and
        (scanner_available ?handheld_scanner)
        (not
          (scanner_assigned ?inventory_entity ?handheld_scanner)
        )
      )
  )
  (:action assign_mhe_to_entity
    :parameters (?inventory_entity - tracked_entity ?material_handling_equipment - material_handling_equipment)
    :precondition
      (and
        (initial_record_finalized ?inventory_entity)
        (mhe_available ?material_handling_equipment)
      )
    :effect
      (and
        (mhe_assigned ?inventory_entity ?material_handling_equipment)
        (not
          (mhe_available ?material_handling_equipment)
        )
      )
  )
  (:action return_mhe
    :parameters (?inventory_entity - tracked_entity ?material_handling_equipment - material_handling_equipment)
    :precondition
      (and
        (mhe_assigned ?inventory_entity ?material_handling_equipment)
      )
    :effect
      (and
        (mhe_available ?material_handling_equipment)
        (not
          (mhe_assigned ?inventory_entity ?material_handling_equipment)
        )
      )
  )
  (:action provision_seal_type_to_officer
    :parameters (?security_officer - security_officer ?seal_type - seal_type)
    :precondition
      (and
        (initial_record_finalized ?security_officer)
        (seal_type_available ?seal_type)
      )
    :effect
      (and
        (officer_assigned_seal_type ?security_officer ?seal_type)
        (not
          (seal_type_available ?seal_type)
        )
      )
  )
  (:action reclaim_seal_type
    :parameters (?security_officer - security_officer ?seal_type - seal_type)
    :precondition
      (and
        (officer_assigned_seal_type ?security_officer ?seal_type)
      )
    :effect
      (and
        (seal_type_available ?seal_type)
        (not
          (officer_assigned_seal_type ?security_officer ?seal_type)
        )
      )
  )
  (:action assign_approval_code_to_officer
    :parameters (?security_officer - security_officer ?approval_code - approval_code)
    :precondition
      (and
        (initial_record_finalized ?security_officer)
        (approval_code_available ?approval_code)
      )
    :effect
      (and
        (officer_assigned_approval_code ?security_officer ?approval_code)
        (not
          (approval_code_available ?approval_code)
        )
      )
  )
  (:action reclaim_approval_code
    :parameters (?security_officer - security_officer ?approval_code - approval_code)
    :precondition
      (and
        (officer_assigned_approval_code ?security_officer ?approval_code)
      )
    :effect
      (and
        (approval_code_available ?approval_code)
        (not
          (officer_assigned_approval_code ?security_officer ?approval_code)
        )
      )
  )
  (:action stage_source_location
    :parameters (?picker - picker ?source_location - source_location ?handheld_scanner - handheld_scanner)
    :precondition
      (and
        (initial_record_finalized ?picker)
        (scanner_assigned ?picker ?handheld_scanner)
        (assigned_source_location ?picker ?source_location)
        (not
          (source_location_staged ?source_location)
        )
        (not
          (source_location_reserved ?source_location)
        )
      )
    :effect (source_location_staged ?source_location)
  )
  (:action prepare_picker_for_pick
    :parameters (?picker - picker ?source_location - source_location ?material_handling_equipment - material_handling_equipment)
    :precondition
      (and
        (initial_record_finalized ?picker)
        (mhe_assigned ?picker ?material_handling_equipment)
        (assigned_source_location ?picker ?source_location)
        (source_location_staged ?source_location)
        (not
          (picker_ready ?picker)
        )
      )
    :effect
      (and
        (picker_ready ?picker)
        (picker_staging_complete ?picker)
      )
  )
  (:action reserve_source_and_assign_seal
    :parameters (?picker - picker ?source_location - source_location ?tamper_seal - tamper_seal)
    :precondition
      (and
        (initial_record_finalized ?picker)
        (assigned_source_location ?picker ?source_location)
        (tamper_seal_available ?tamper_seal)
        (not
          (picker_ready ?picker)
        )
      )
    :effect
      (and
        (source_location_reserved ?source_location)
        (picker_ready ?picker)
        (seal_assigned_to_picker ?picker ?tamper_seal)
        (not
          (tamper_seal_available ?tamper_seal)
        )
      )
  )
  (:action picker_complete_pick_and_return_seal
    :parameters (?picker - picker ?source_location - source_location ?handheld_scanner - handheld_scanner ?tamper_seal - tamper_seal)
    :precondition
      (and
        (initial_record_finalized ?picker)
        (scanner_assigned ?picker ?handheld_scanner)
        (assigned_source_location ?picker ?source_location)
        (source_location_reserved ?source_location)
        (seal_assigned_to_picker ?picker ?tamper_seal)
        (not
          (picker_staging_complete ?picker)
        )
      )
    :effect
      (and
        (source_location_staged ?source_location)
        (picker_staging_complete ?picker)
        (tamper_seal_available ?tamper_seal)
        (not
          (seal_assigned_to_picker ?picker ?tamper_seal)
        )
      )
  )
  (:action stage_destination_location
    :parameters (?packer - packer ?destination_location - destination_location ?handheld_scanner - handheld_scanner)
    :precondition
      (and
        (initial_record_finalized ?packer)
        (scanner_assigned ?packer ?handheld_scanner)
        (assigned_destination_location ?packer ?destination_location)
        (not
          (destination_location_staged ?destination_location)
        )
        (not
          (destination_location_reserved ?destination_location)
        )
      )
    :effect (destination_location_staged ?destination_location)
  )
  (:action prepare_packer_for_pack
    :parameters (?packer - packer ?destination_location - destination_location ?material_handling_equipment - material_handling_equipment)
    :precondition
      (and
        (initial_record_finalized ?packer)
        (mhe_assigned ?packer ?material_handling_equipment)
        (assigned_destination_location ?packer ?destination_location)
        (destination_location_staged ?destination_location)
        (not
          (packer_ready ?packer)
        )
      )
    :effect
      (and
        (packer_ready ?packer)
        (packer_staging_complete ?packer)
      )
  )
  (:action assign_seal_to_packer_and_reserve_destination
    :parameters (?packer - packer ?destination_location - destination_location ?tamper_seal - tamper_seal)
    :precondition
      (and
        (initial_record_finalized ?packer)
        (assigned_destination_location ?packer ?destination_location)
        (tamper_seal_available ?tamper_seal)
        (not
          (packer_ready ?packer)
        )
      )
    :effect
      (and
        (destination_location_reserved ?destination_location)
        (packer_ready ?packer)
        (seal_assigned_to_packer ?packer ?tamper_seal)
        (not
          (tamper_seal_available ?tamper_seal)
        )
      )
  )
  (:action packer_complete_pack_and_return_seal
    :parameters (?packer - packer ?destination_location - destination_location ?handheld_scanner - handheld_scanner ?tamper_seal - tamper_seal)
    :precondition
      (and
        (initial_record_finalized ?packer)
        (scanner_assigned ?packer ?handheld_scanner)
        (assigned_destination_location ?packer ?destination_location)
        (destination_location_reserved ?destination_location)
        (seal_assigned_to_packer ?packer ?tamper_seal)
        (not
          (packer_staging_complete ?packer)
        )
      )
    :effect
      (and
        (destination_location_staged ?destination_location)
        (packer_staging_complete ?packer)
        (tamper_seal_available ?tamper_seal)
        (not
          (seal_assigned_to_packer ?packer ?tamper_seal)
        )
      )
  )
  (:action consolidate_into_container_from_staged_locations
    :parameters (?picker - picker ?packer - packer ?source_location - source_location ?destination_location - destination_location ?secure_container - secure_container)
    :precondition
      (and
        (picker_ready ?picker)
        (packer_ready ?packer)
        (assigned_source_location ?picker ?source_location)
        (assigned_destination_location ?packer ?destination_location)
        (source_location_staged ?source_location)
        (destination_location_staged ?destination_location)
        (picker_staging_complete ?picker)
        (packer_staging_complete ?packer)
        (container_available ?secure_container)
      )
    :effect
      (and
        (container_claimed ?secure_container)
        (container_assigned_source ?secure_container ?source_location)
        (container_assigned_destination ?secure_container ?destination_location)
        (not
          (container_available ?secure_container)
        )
      )
  )
  (:action consolidate_into_container_with_source_reserved
    :parameters (?picker - picker ?packer - packer ?source_location - source_location ?destination_location - destination_location ?secure_container - secure_container)
    :precondition
      (and
        (picker_ready ?picker)
        (packer_ready ?packer)
        (assigned_source_location ?picker ?source_location)
        (assigned_destination_location ?packer ?destination_location)
        (source_location_reserved ?source_location)
        (destination_location_staged ?destination_location)
        (not
          (picker_staging_complete ?picker)
        )
        (packer_staging_complete ?packer)
        (container_available ?secure_container)
      )
    :effect
      (and
        (container_claimed ?secure_container)
        (container_assigned_source ?secure_container ?source_location)
        (container_assigned_destination ?secure_container ?destination_location)
        (container_ready_from_source ?secure_container)
        (not
          (container_available ?secure_container)
        )
      )
  )
  (:action consolidate_into_container_with_destination_reserved
    :parameters (?picker - picker ?packer - packer ?source_location - source_location ?destination_location - destination_location ?secure_container - secure_container)
    :precondition
      (and
        (picker_ready ?picker)
        (packer_ready ?packer)
        (assigned_source_location ?picker ?source_location)
        (assigned_destination_location ?packer ?destination_location)
        (source_location_staged ?source_location)
        (destination_location_reserved ?destination_location)
        (picker_staging_complete ?picker)
        (not
          (packer_staging_complete ?packer)
        )
        (container_available ?secure_container)
      )
    :effect
      (and
        (container_claimed ?secure_container)
        (container_assigned_source ?secure_container ?source_location)
        (container_assigned_destination ?secure_container ?destination_location)
        (container_ready_from_destination ?secure_container)
        (not
          (container_available ?secure_container)
        )
      )
  )
  (:action consolidate_into_container_both_sides_reserved
    :parameters (?picker - picker ?packer - packer ?source_location - source_location ?destination_location - destination_location ?secure_container - secure_container)
    :precondition
      (and
        (picker_ready ?picker)
        (packer_ready ?packer)
        (assigned_source_location ?picker ?source_location)
        (assigned_destination_location ?packer ?destination_location)
        (source_location_reserved ?source_location)
        (destination_location_reserved ?destination_location)
        (not
          (picker_staging_complete ?picker)
        )
        (not
          (packer_staging_complete ?packer)
        )
        (container_available ?secure_container)
      )
    :effect
      (and
        (container_claimed ?secure_container)
        (container_assigned_source ?secure_container ?source_location)
        (container_assigned_destination ?secure_container ?destination_location)
        (container_ready_from_source ?secure_container)
        (container_ready_from_destination ?secure_container)
        (not
          (container_available ?secure_container)
        )
      )
  )
  (:action inspect_container
    :parameters (?secure_container - secure_container ?picker - picker ?handheld_scanner - handheld_scanner)
    :precondition
      (and
        (container_claimed ?secure_container)
        (picker_ready ?picker)
        (scanner_assigned ?picker ?handheld_scanner)
        (not
          (container_inspected ?secure_container)
        )
      )
    :effect (container_inspected ?secure_container)
  )
  (:action reserve_storage_slot_for_container
    :parameters (?security_officer - security_officer ?storage_slot - storage_slot ?secure_container - secure_container)
    :precondition
      (and
        (initial_record_finalized ?security_officer)
        (officer_assigned_container ?security_officer ?secure_container)
        (officer_assigned_slot ?security_officer ?storage_slot)
        (storage_slot_available ?storage_slot)
        (container_claimed ?secure_container)
        (container_inspected ?secure_container)
        (not
          (storage_slot_reserved ?storage_slot)
        )
      )
    :effect
      (and
        (storage_slot_reserved ?storage_slot)
        (slot_assigned_to_container ?storage_slot ?secure_container)
        (not
          (storage_slot_available ?storage_slot)
        )
      )
  )
  (:action confirm_slot_assignment_by_officer
    :parameters (?security_officer - security_officer ?storage_slot - storage_slot ?secure_container - secure_container ?handheld_scanner - handheld_scanner)
    :precondition
      (and
        (initial_record_finalized ?security_officer)
        (officer_assigned_slot ?security_officer ?storage_slot)
        (storage_slot_reserved ?storage_slot)
        (slot_assigned_to_container ?storage_slot ?secure_container)
        (scanner_assigned ?security_officer ?handheld_scanner)
        (not
          (container_ready_from_source ?secure_container)
        )
        (not
          (officer_verification_complete ?security_officer)
        )
      )
    :effect (officer_verification_complete ?security_officer)
  )
  (:action assign_credential_token_to_officer
    :parameters (?security_officer - security_officer ?credential_token - credential_token)
    :precondition
      (and
        (initial_record_finalized ?security_officer)
        (credential_token_available ?credential_token)
        (not
          (officer_has_credential_token ?security_officer)
        )
      )
    :effect
      (and
        (officer_has_credential_token ?security_officer)
        (officer_assigned_token ?security_officer ?credential_token)
        (not
          (credential_token_available ?credential_token)
        )
      )
  )
  (:action officer_verify_container_and_confirm_slot
    :parameters (?security_officer - security_officer ?storage_slot - storage_slot ?secure_container - secure_container ?handheld_scanner - handheld_scanner ?credential_token - credential_token)
    :precondition
      (and
        (initial_record_finalized ?security_officer)
        (officer_assigned_slot ?security_officer ?storage_slot)
        (storage_slot_reserved ?storage_slot)
        (slot_assigned_to_container ?storage_slot ?secure_container)
        (scanner_assigned ?security_officer ?handheld_scanner)
        (container_ready_from_source ?secure_container)
        (officer_has_credential_token ?security_officer)
        (officer_assigned_token ?security_officer ?credential_token)
        (not
          (officer_verification_complete ?security_officer)
        )
      )
    :effect
      (and
        (officer_verification_complete ?security_officer)
        (officer_slot_confirmed ?security_officer)
      )
  )
  (:action officer_apply_seal
    :parameters (?security_officer - security_officer ?seal_type - seal_type ?material_handling_equipment - material_handling_equipment ?storage_slot - storage_slot ?secure_container - secure_container)
    :precondition
      (and
        (officer_verification_complete ?security_officer)
        (officer_assigned_seal_type ?security_officer ?seal_type)
        (mhe_assigned ?security_officer ?material_handling_equipment)
        (officer_assigned_slot ?security_officer ?storage_slot)
        (slot_assigned_to_container ?storage_slot ?secure_container)
        (not
          (container_ready_from_destination ?secure_container)
        )
        (not
          (officer_ready_for_approval ?security_officer)
        )
      )
    :effect (officer_ready_for_approval ?security_officer)
  )
  (:action officer_apply_seal_alternate
    :parameters (?security_officer - security_officer ?seal_type - seal_type ?material_handling_equipment - material_handling_equipment ?storage_slot - storage_slot ?secure_container - secure_container)
    :precondition
      (and
        (officer_verification_complete ?security_officer)
        (officer_assigned_seal_type ?security_officer ?seal_type)
        (mhe_assigned ?security_officer ?material_handling_equipment)
        (officer_assigned_slot ?security_officer ?storage_slot)
        (slot_assigned_to_container ?storage_slot ?secure_container)
        (container_ready_from_destination ?secure_container)
        (not
          (officer_ready_for_approval ?security_officer)
        )
      )
    :effect (officer_ready_for_approval ?security_officer)
  )
  (:action officer_prepare_manifest
    :parameters (?security_officer - security_officer ?approval_code - approval_code ?storage_slot - storage_slot ?secure_container - secure_container)
    :precondition
      (and
        (officer_ready_for_approval ?security_officer)
        (officer_assigned_approval_code ?security_officer ?approval_code)
        (officer_assigned_slot ?security_officer ?storage_slot)
        (slot_assigned_to_container ?storage_slot ?secure_container)
        (not
          (container_ready_from_source ?secure_container)
        )
        (not
          (container_ready_from_destination ?secure_container)
        )
        (not
          (officer_manifest_prepared ?security_officer)
        )
      )
    :effect (officer_manifest_prepared ?security_officer)
  )
  (:action officer_finalize_manifest_with_label_and_slot_flag
    :parameters (?security_officer - security_officer ?approval_code - approval_code ?storage_slot - storage_slot ?secure_container - secure_container)
    :precondition
      (and
        (officer_ready_for_approval ?security_officer)
        (officer_assigned_approval_code ?security_officer ?approval_code)
        (officer_assigned_slot ?security_officer ?storage_slot)
        (slot_assigned_to_container ?storage_slot ?secure_container)
        (container_ready_from_source ?secure_container)
        (not
          (container_ready_from_destination ?secure_container)
        )
        (not
          (officer_manifest_prepared ?security_officer)
        )
      )
    :effect
      (and
        (officer_manifest_prepared ?security_officer)
        (officer_has_label ?security_officer)
      )
  )
  (:action officer_finalize_manifest_with_label_and_slot_flag_alt1
    :parameters (?security_officer - security_officer ?approval_code - approval_code ?storage_slot - storage_slot ?secure_container - secure_container)
    :precondition
      (and
        (officer_ready_for_approval ?security_officer)
        (officer_assigned_approval_code ?security_officer ?approval_code)
        (officer_assigned_slot ?security_officer ?storage_slot)
        (slot_assigned_to_container ?storage_slot ?secure_container)
        (not
          (container_ready_from_source ?secure_container)
        )
        (container_ready_from_destination ?secure_container)
        (not
          (officer_manifest_prepared ?security_officer)
        )
      )
    :effect
      (and
        (officer_manifest_prepared ?security_officer)
        (officer_has_label ?security_officer)
      )
  )
  (:action officer_finalize_manifest_with_label_and_slot_flag_alt2
    :parameters (?security_officer - security_officer ?approval_code - approval_code ?storage_slot - storage_slot ?secure_container - secure_container)
    :precondition
      (and
        (officer_ready_for_approval ?security_officer)
        (officer_assigned_approval_code ?security_officer ?approval_code)
        (officer_assigned_slot ?security_officer ?storage_slot)
        (slot_assigned_to_container ?storage_slot ?secure_container)
        (container_ready_from_source ?secure_container)
        (container_ready_from_destination ?secure_container)
        (not
          (officer_manifest_prepared ?security_officer)
        )
      )
    :effect
      (and
        (officer_manifest_prepared ?security_officer)
        (officer_has_label ?security_officer)
      )
  )
  (:action officer_record_release
    :parameters (?security_officer - security_officer)
    :precondition
      (and
        (officer_manifest_prepared ?security_officer)
        (not
          (officer_has_label ?security_officer)
        )
        (not
          (release_recorded ?security_officer)
        )
      )
    :effect
      (and
        (release_recorded ?security_officer)
        (manifest_verified ?security_officer)
      )
  )
  (:action officer_assign_label
    :parameters (?security_officer - security_officer ?shipment_label - shipment_label)
    :precondition
      (and
        (officer_manifest_prepared ?security_officer)
        (officer_has_label ?security_officer)
        (label_available ?shipment_label)
      )
    :effect
      (and
        (officer_assigned_label ?security_officer ?shipment_label)
        (not
          (label_available ?shipment_label)
        )
      )
  )
  (:action officer_complete_verification_checklist
    :parameters (?security_officer - security_officer ?picker - picker ?packer - packer ?handheld_scanner - handheld_scanner ?shipment_label - shipment_label)
    :precondition
      (and
        (officer_manifest_prepared ?security_officer)
        (officer_has_label ?security_officer)
        (officer_assigned_label ?security_officer ?shipment_label)
        (officer_assigned_picker ?security_officer ?picker)
        (officer_assigned_packer ?security_officer ?packer)
        (picker_staging_complete ?picker)
        (packer_staging_complete ?packer)
        (scanner_assigned ?security_officer ?handheld_scanner)
        (not
          (officer_checklist_complete ?security_officer)
        )
      )
    :effect (officer_checklist_complete ?security_officer)
  )
  (:action officer_finalize_release
    :parameters (?security_officer - security_officer)
    :precondition
      (and
        (officer_manifest_prepared ?security_officer)
        (officer_checklist_complete ?security_officer)
        (not
          (release_recorded ?security_officer)
        )
      )
    :effect
      (and
        (release_recorded ?security_officer)
        (manifest_verified ?security_officer)
      )
  )
  (:action officer_verify_supervisor_id
    :parameters (?security_officer - security_officer ?supervisor_id - supervisor_id ?handheld_scanner - handheld_scanner)
    :precondition
      (and
        (initial_record_finalized ?security_officer)
        (scanner_assigned ?security_officer ?handheld_scanner)
        (supervisor_id_available ?supervisor_id)
        (officer_assigned_supervisor_id ?security_officer ?supervisor_id)
        (not
          (officer_supervisor_verified ?security_officer)
        )
      )
    :effect
      (and
        (officer_supervisor_verified ?security_officer)
        (not
          (supervisor_id_available ?supervisor_id)
        )
      )
  )
  (:action officer_establish_authentication
    :parameters (?security_officer - security_officer ?material_handling_equipment - material_handling_equipment)
    :precondition
      (and
        (officer_supervisor_verified ?security_officer)
        (mhe_assigned ?security_officer ?material_handling_equipment)
        (not
          (officer_authenticated ?security_officer)
        )
      )
    :effect (officer_authenticated ?security_officer)
  )
  (:action officer_record_supervisor_approval
    :parameters (?security_officer - security_officer ?approval_code - approval_code)
    :precondition
      (and
        (officer_authenticated ?security_officer)
        (officer_assigned_approval_code ?security_officer ?approval_code)
        (not
          (officer_supervisor_approved ?security_officer)
        )
      )
    :effect (officer_supervisor_approved ?security_officer)
  )
  (:action officer_finalize_supervisor_approval
    :parameters (?security_officer - security_officer)
    :precondition
      (and
        (officer_supervisor_approved ?security_officer)
        (not
          (release_recorded ?security_officer)
        )
      )
    :effect
      (and
        (release_recorded ?security_officer)
        (manifest_verified ?security_officer)
      )
  )
  (:action release_picker
    :parameters (?picker - picker ?secure_container - secure_container)
    :precondition
      (and
        (picker_ready ?picker)
        (picker_staging_complete ?picker)
        (container_claimed ?secure_container)
        (container_inspected ?secure_container)
        (not
          (manifest_verified ?picker)
        )
      )
    :effect (manifest_verified ?picker)
  )
  (:action release_packer
    :parameters (?packer - packer ?secure_container - secure_container)
    :precondition
      (and
        (packer_ready ?packer)
        (packer_staging_complete ?packer)
        (container_claimed ?secure_container)
        (container_inspected ?secure_container)
        (not
          (manifest_verified ?packer)
        )
      )
    :effect (manifest_verified ?packer)
  )
  (:action assign_asset_tag_and_grant_approval
    :parameters (?inventory_entity - tracked_entity ?asset_tag - asset_tag ?handheld_scanner - handheld_scanner)
    :precondition
      (and
        (manifest_verified ?inventory_entity)
        (scanner_assigned ?inventory_entity ?handheld_scanner)
        (asset_tag_available ?asset_tag)
        (not
          (approval_granted ?inventory_entity)
        )
      )
    :effect
      (and
        (approval_granted ?inventory_entity)
        (asset_tag_assigned ?inventory_entity ?asset_tag)
        (not
          (asset_tag_available ?asset_tag)
        )
      )
  )
  (:action release_picker_and_return_equipment
    :parameters (?picker - picker ?transfer_tray - transfer_tray ?asset_tag - asset_tag)
    :precondition
      (and
        (approval_granted ?picker)
        (assigned_to_transfer_tray ?picker ?transfer_tray)
        (asset_tag_assigned ?picker ?asset_tag)
        (not
          (handler_released ?picker)
        )
      )
    :effect
      (and
        (handler_released ?picker)
        (tray_available ?transfer_tray)
        (asset_tag_available ?asset_tag)
      )
  )
  (:action release_packer_and_return_equipment
    :parameters (?packer - packer ?transfer_tray - transfer_tray ?asset_tag - asset_tag)
    :precondition
      (and
        (approval_granted ?packer)
        (assigned_to_transfer_tray ?packer ?transfer_tray)
        (asset_tag_assigned ?packer ?asset_tag)
        (not
          (handler_released ?packer)
        )
      )
    :effect
      (and
        (handler_released ?packer)
        (tray_available ?transfer_tray)
        (asset_tag_available ?asset_tag)
      )
  )
  (:action release_officer_and_return_equipment
    :parameters (?security_officer - security_officer ?transfer_tray - transfer_tray ?asset_tag - asset_tag)
    :precondition
      (and
        (approval_granted ?security_officer)
        (assigned_to_transfer_tray ?security_officer ?transfer_tray)
        (asset_tag_assigned ?security_officer ?asset_tag)
        (not
          (handler_released ?security_officer)
        )
      )
    :effect
      (and
        (handler_released ?security_officer)
        (tray_available ?transfer_tray)
        (asset_tag_available ?asset_tag)
      )
  )
)

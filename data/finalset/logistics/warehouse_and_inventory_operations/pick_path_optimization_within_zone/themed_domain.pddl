(define (domain warehouse_pick_path_zone)
  (:requirements :strips :typing :negative-preconditions)
  (:types storage_resource_meta - object location_resource_meta - object aux_resource_meta - object task_category - object pick_entity - task_category pick_trolley - storage_resource_meta sku_product - storage_resource_meta pack_station - storage_resource_meta staging_slot - storage_resource_meta packing_kit - storage_resource_meta container_label - storage_resource_meta weigh_scale - storage_resource_meta qc_station - storage_resource_meta inventory_unit - location_resource_meta storage_bin - location_resource_meta priority_tag - location_resource_meta pick_face_type_a - aux_resource_meta pick_face_type_b - aux_resource_meta pick_batch_manifest - aux_resource_meta picker_category - pick_entity zone_category - pick_entity human_picker - picker_category automated_picker - picker_category pick_zone - zone_category)
  (:predicates
    (pick_entity_created ?pick_task - pick_entity)
    (pick_entity_ready ?pick_task - pick_entity)
    (pick_entity_trolley_assignment ?pick_task - pick_entity)
    (pick_entity_processing_completed ?pick_task - pick_entity)
    (pick_entity_handoff_registered ?pick_task - pick_entity)
    (pick_entity_bound_to_container ?pick_task - pick_entity)
    (trolley_available ?pick_trolley - pick_trolley)
    (pick_entity_assigned_to_trolley ?pick_task - pick_entity ?pick_trolley - pick_trolley)
    (sku_available ?sku_product - sku_product)
    (pick_entity_assigned_sku ?pick_task - pick_entity ?sku_product - sku_product)
    (pack_station_available ?pack_station - pack_station)
    (pick_entity_assigned_to_pack_station ?pick_task - pick_entity ?pack_station - pack_station)
    (inventory_available ?inventory_unit - inventory_unit)
    (picker_reserved_inventory ?human_picker - human_picker ?inventory_unit - inventory_unit)
    (automated_picker_reserved_inventory ?automated_picker - automated_picker ?inventory_unit - inventory_unit)
    (picker_assigned_to_pick_face_a ?human_picker - human_picker ?pick_face_type_a - pick_face_type_a)
    (pick_face_a_reserved ?pick_face_type_a - pick_face_type_a)
    (pick_face_a_inventory_allocated ?pick_face_type_a - pick_face_type_a)
    (picker_confirmed_pick_complete ?human_picker - human_picker)
    (automated_picker_assigned_to_pick_face_b ?automated_picker - automated_picker ?pick_face_type_b - pick_face_type_b)
    (pick_face_b_reserved ?pick_face_type_b - pick_face_type_b)
    (pick_face_b_inventory_allocated ?pick_face_type_b - pick_face_type_b)
    (automated_picker_confirmed_pick_complete ?automated_picker - automated_picker)
    (manifest_unbound ?pick_batch_manifest - pick_batch_manifest)
    (manifest_bound ?pick_batch_manifest - pick_batch_manifest)
    (manifest_has_pick_face_a ?pick_batch_manifest - pick_batch_manifest ?pick_face_type_a - pick_face_type_a)
    (manifest_has_pick_face_b ?pick_batch_manifest - pick_batch_manifest ?pick_face_type_b - pick_face_type_b)
    (manifest_requires_weight_check ?pick_batch_manifest - pick_batch_manifest)
    (manifest_requires_qc_check ?pick_batch_manifest - pick_batch_manifest)
    (manifest_weight_verified ?pick_batch_manifest - pick_batch_manifest)
    (zone_assigned_human_picker ?pick_zone - pick_zone ?human_picker - human_picker)
    (zone_assigned_automated_picker ?pick_zone - pick_zone ?automated_picker - automated_picker)
    (zone_assigned_manifest ?pick_zone - pick_zone ?pick_batch_manifest - pick_batch_manifest)
    (storage_bin_available ?storage_bin - storage_bin)
    (zone_has_storage_bin ?pick_zone - pick_zone ?storage_bin - storage_bin)
    (storage_bin_locked ?storage_bin - storage_bin)
    (storage_bin_assigned_to_manifest ?storage_bin - storage_bin ?pick_batch_manifest - pick_batch_manifest)
    (zone_resources_locked ?pick_zone - pick_zone)
    (zone_prepared ?pick_zone - pick_zone)
    (zone_execution_ready ?pick_zone - pick_zone)
    (zone_has_staging_slot ?pick_zone - pick_zone)
    (zone_staging_prepared ?pick_zone - pick_zone)
    (zone_packing_kit_allocated ?pick_zone - pick_zone)
    (zone_execution_committed ?pick_zone - pick_zone)
    (priority_tag_available ?priority_tag - priority_tag)
    (zone_assigned_priority_tag ?pick_zone - pick_zone ?priority_tag - priority_tag)
    (zone_priority_applied ?pick_zone - pick_zone)
    (zone_priority_acknowledged ?pick_zone - pick_zone)
    (zone_priority_processed ?pick_zone - pick_zone)
    (staging_slot_available ?staging_slot - staging_slot)
    (zone_assigned_staging_slot ?pick_zone - pick_zone ?staging_slot - staging_slot)
    (packing_kit_available ?packing_kit - packing_kit)
    (zone_assigned_packing_kit ?pick_zone - pick_zone ?packing_kit - packing_kit)
    (weigh_scale_available ?weigh_scale - weigh_scale)
    (zone_assigned_weigh_scale ?pick_zone - pick_zone ?weigh_scale - weigh_scale)
    (qc_station_available ?qc_station - qc_station)
    (zone_assigned_qc_station ?pick_zone - pick_zone ?qc_station - qc_station)
    (container_label_available ?container_label - container_label)
    (pick_entity_assigned_container_label ?pick_task - pick_entity ?container_label - container_label)
    (human_picker_ready_for_batch ?human_picker - human_picker)
    (automated_picker_ready_for_batch ?automated_picker - automated_picker)
    (zone_finalized ?pick_zone - pick_zone)
  )
  (:action create_pick_task
    :parameters (?pick_task - pick_entity)
    :precondition
      (and
        (not
          (pick_entity_created ?pick_task)
        )
        (not
          (pick_entity_processing_completed ?pick_task)
        )
      )
    :effect (pick_entity_created ?pick_task)
  )
  (:action assign_task_to_trolley
    :parameters (?pick_task - pick_entity ?pick_trolley - pick_trolley)
    :precondition
      (and
        (pick_entity_created ?pick_task)
        (not
          (pick_entity_trolley_assignment ?pick_task)
        )
        (trolley_available ?pick_trolley)
      )
    :effect
      (and
        (pick_entity_trolley_assignment ?pick_task)
        (pick_entity_assigned_to_trolley ?pick_task ?pick_trolley)
        (not
          (trolley_available ?pick_trolley)
        )
      )
  )
  (:action allocate_sku_to_task
    :parameters (?pick_task - pick_entity ?sku_product - sku_product)
    :precondition
      (and
        (pick_entity_created ?pick_task)
        (pick_entity_trolley_assignment ?pick_task)
        (sku_available ?sku_product)
      )
    :effect
      (and
        (pick_entity_assigned_sku ?pick_task ?sku_product)
        (not
          (sku_available ?sku_product)
        )
      )
  )
  (:action mark_task_ready
    :parameters (?pick_task - pick_entity ?sku_product - sku_product)
    :precondition
      (and
        (pick_entity_created ?pick_task)
        (pick_entity_trolley_assignment ?pick_task)
        (pick_entity_assigned_sku ?pick_task ?sku_product)
        (not
          (pick_entity_ready ?pick_task)
        )
      )
    :effect (pick_entity_ready ?pick_task)
  )
  (:action unassign_sku_from_task
    :parameters (?pick_task - pick_entity ?sku_product - sku_product)
    :precondition
      (and
        (pick_entity_assigned_sku ?pick_task ?sku_product)
      )
    :effect
      (and
        (sku_available ?sku_product)
        (not
          (pick_entity_assigned_sku ?pick_task ?sku_product)
        )
      )
  )
  (:action assign_pack_station_to_task
    :parameters (?pick_task - pick_entity ?pack_station - pack_station)
    :precondition
      (and
        (pick_entity_ready ?pick_task)
        (pack_station_available ?pack_station)
      )
    :effect
      (and
        (pick_entity_assigned_to_pack_station ?pick_task ?pack_station)
        (not
          (pack_station_available ?pack_station)
        )
      )
  )
  (:action release_pack_station_from_task
    :parameters (?pick_task - pick_entity ?pack_station - pack_station)
    :precondition
      (and
        (pick_entity_assigned_to_pack_station ?pick_task ?pack_station)
      )
    :effect
      (and
        (pack_station_available ?pack_station)
        (not
          (pick_entity_assigned_to_pack_station ?pick_task ?pack_station)
        )
      )
  )
  (:action assign_weigh_scale_to_zone
    :parameters (?pick_zone - pick_zone ?weigh_scale - weigh_scale)
    :precondition
      (and
        (pick_entity_ready ?pick_zone)
        (weigh_scale_available ?weigh_scale)
      )
    :effect
      (and
        (zone_assigned_weigh_scale ?pick_zone ?weigh_scale)
        (not
          (weigh_scale_available ?weigh_scale)
        )
      )
  )
  (:action release_weigh_scale_from_zone
    :parameters (?pick_zone - pick_zone ?weigh_scale - weigh_scale)
    :precondition
      (and
        (zone_assigned_weigh_scale ?pick_zone ?weigh_scale)
      )
    :effect
      (and
        (weigh_scale_available ?weigh_scale)
        (not
          (zone_assigned_weigh_scale ?pick_zone ?weigh_scale)
        )
      )
  )
  (:action assign_qc_station_to_zone
    :parameters (?pick_zone - pick_zone ?qc_station - qc_station)
    :precondition
      (and
        (pick_entity_ready ?pick_zone)
        (qc_station_available ?qc_station)
      )
    :effect
      (and
        (zone_assigned_qc_station ?pick_zone ?qc_station)
        (not
          (qc_station_available ?qc_station)
        )
      )
  )
  (:action release_qc_station_from_zone
    :parameters (?pick_zone - pick_zone ?qc_station - qc_station)
    :precondition
      (and
        (zone_assigned_qc_station ?pick_zone ?qc_station)
      )
    :effect
      (and
        (qc_station_available ?qc_station)
        (not
          (zone_assigned_qc_station ?pick_zone ?qc_station)
        )
      )
  )
  (:action reserve_pick_face_a
    :parameters (?human_picker - human_picker ?pick_face_type_a - pick_face_type_a ?sku_product - sku_product)
    :precondition
      (and
        (pick_entity_ready ?human_picker)
        (pick_entity_assigned_sku ?human_picker ?sku_product)
        (picker_assigned_to_pick_face_a ?human_picker ?pick_face_type_a)
        (not
          (pick_face_a_reserved ?pick_face_type_a)
        )
        (not
          (pick_face_a_inventory_allocated ?pick_face_type_a)
        )
      )
    :effect (pick_face_a_reserved ?pick_face_type_a)
  )
  (:action confirm_reservation_for_picker
    :parameters (?human_picker - human_picker ?pick_face_type_a - pick_face_type_a ?pack_station - pack_station)
    :precondition
      (and
        (pick_entity_ready ?human_picker)
        (pick_entity_assigned_to_pack_station ?human_picker ?pack_station)
        (picker_assigned_to_pick_face_a ?human_picker ?pick_face_type_a)
        (pick_face_a_reserved ?pick_face_type_a)
        (not
          (human_picker_ready_for_batch ?human_picker)
        )
      )
    :effect
      (and
        (human_picker_ready_for_batch ?human_picker)
        (picker_confirmed_pick_complete ?human_picker)
      )
  )
  (:action allocate_inventory_to_picker_and_mark_pick_face
    :parameters (?human_picker - human_picker ?pick_face_type_a - pick_face_type_a ?inventory_unit - inventory_unit)
    :precondition
      (and
        (pick_entity_ready ?human_picker)
        (picker_assigned_to_pick_face_a ?human_picker ?pick_face_type_a)
        (inventory_available ?inventory_unit)
        (not
          (human_picker_ready_for_batch ?human_picker)
        )
      )
    :effect
      (and
        (pick_face_a_inventory_allocated ?pick_face_type_a)
        (human_picker_ready_for_batch ?human_picker)
        (picker_reserved_inventory ?human_picker ?inventory_unit)
        (not
          (inventory_available ?inventory_unit)
        )
      )
  )
  (:action finalize_inventory_allocation_for_picker
    :parameters (?human_picker - human_picker ?pick_face_type_a - pick_face_type_a ?sku_product - sku_product ?inventory_unit - inventory_unit)
    :precondition
      (and
        (pick_entity_ready ?human_picker)
        (pick_entity_assigned_sku ?human_picker ?sku_product)
        (picker_assigned_to_pick_face_a ?human_picker ?pick_face_type_a)
        (pick_face_a_inventory_allocated ?pick_face_type_a)
        (picker_reserved_inventory ?human_picker ?inventory_unit)
        (not
          (picker_confirmed_pick_complete ?human_picker)
        )
      )
    :effect
      (and
        (pick_face_a_reserved ?pick_face_type_a)
        (picker_confirmed_pick_complete ?human_picker)
        (inventory_available ?inventory_unit)
        (not
          (picker_reserved_inventory ?human_picker ?inventory_unit)
        )
      )
  )
  (:action reserve_pick_face_b
    :parameters (?automated_picker - automated_picker ?pick_face_type_b - pick_face_type_b ?sku_product - sku_product)
    :precondition
      (and
        (pick_entity_ready ?automated_picker)
        (pick_entity_assigned_sku ?automated_picker ?sku_product)
        (automated_picker_assigned_to_pick_face_b ?automated_picker ?pick_face_type_b)
        (not
          (pick_face_b_reserved ?pick_face_type_b)
        )
        (not
          (pick_face_b_inventory_allocated ?pick_face_type_b)
        )
      )
    :effect (pick_face_b_reserved ?pick_face_type_b)
  )
  (:action confirm_reservation_for_automated_picker
    :parameters (?automated_picker - automated_picker ?pick_face_type_b - pick_face_type_b ?pack_station - pack_station)
    :precondition
      (and
        (pick_entity_ready ?automated_picker)
        (pick_entity_assigned_to_pack_station ?automated_picker ?pack_station)
        (automated_picker_assigned_to_pick_face_b ?automated_picker ?pick_face_type_b)
        (pick_face_b_reserved ?pick_face_type_b)
        (not
          (automated_picker_ready_for_batch ?automated_picker)
        )
      )
    :effect
      (and
        (automated_picker_ready_for_batch ?automated_picker)
        (automated_picker_confirmed_pick_complete ?automated_picker)
      )
  )
  (:action allocate_inventory_to_automated_picker
    :parameters (?automated_picker - automated_picker ?pick_face_type_b - pick_face_type_b ?inventory_unit - inventory_unit)
    :precondition
      (and
        (pick_entity_ready ?automated_picker)
        (automated_picker_assigned_to_pick_face_b ?automated_picker ?pick_face_type_b)
        (inventory_available ?inventory_unit)
        (not
          (automated_picker_ready_for_batch ?automated_picker)
        )
      )
    :effect
      (and
        (pick_face_b_inventory_allocated ?pick_face_type_b)
        (automated_picker_ready_for_batch ?automated_picker)
        (automated_picker_reserved_inventory ?automated_picker ?inventory_unit)
        (not
          (inventory_available ?inventory_unit)
        )
      )
  )
  (:action finalize_inventory_allocation_for_automated_picker
    :parameters (?automated_picker - automated_picker ?pick_face_type_b - pick_face_type_b ?sku_product - sku_product ?inventory_unit - inventory_unit)
    :precondition
      (and
        (pick_entity_ready ?automated_picker)
        (pick_entity_assigned_sku ?automated_picker ?sku_product)
        (automated_picker_assigned_to_pick_face_b ?automated_picker ?pick_face_type_b)
        (pick_face_b_inventory_allocated ?pick_face_type_b)
        (automated_picker_reserved_inventory ?automated_picker ?inventory_unit)
        (not
          (automated_picker_confirmed_pick_complete ?automated_picker)
        )
      )
    :effect
      (and
        (pick_face_b_reserved ?pick_face_type_b)
        (automated_picker_confirmed_pick_complete ?automated_picker)
        (inventory_available ?inventory_unit)
        (not
          (automated_picker_reserved_inventory ?automated_picker ?inventory_unit)
        )
      )
  )
  (:action assemble_manifest
    :parameters (?human_picker - human_picker ?automated_picker - automated_picker ?pick_face_type_a - pick_face_type_a ?pick_face_type_b - pick_face_type_b ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (human_picker_ready_for_batch ?human_picker)
        (automated_picker_ready_for_batch ?automated_picker)
        (picker_assigned_to_pick_face_a ?human_picker ?pick_face_type_a)
        (automated_picker_assigned_to_pick_face_b ?automated_picker ?pick_face_type_b)
        (pick_face_a_reserved ?pick_face_type_a)
        (pick_face_b_reserved ?pick_face_type_b)
        (picker_confirmed_pick_complete ?human_picker)
        (automated_picker_confirmed_pick_complete ?automated_picker)
        (manifest_unbound ?pick_batch_manifest)
      )
    :effect
      (and
        (manifest_bound ?pick_batch_manifest)
        (manifest_has_pick_face_a ?pick_batch_manifest ?pick_face_type_a)
        (manifest_has_pick_face_b ?pick_batch_manifest ?pick_face_type_b)
        (not
          (manifest_unbound ?pick_batch_manifest)
        )
      )
  )
  (:action assemble_manifest_with_weight_check
    :parameters (?human_picker - human_picker ?automated_picker - automated_picker ?pick_face_type_a - pick_face_type_a ?pick_face_type_b - pick_face_type_b ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (human_picker_ready_for_batch ?human_picker)
        (automated_picker_ready_for_batch ?automated_picker)
        (picker_assigned_to_pick_face_a ?human_picker ?pick_face_type_a)
        (automated_picker_assigned_to_pick_face_b ?automated_picker ?pick_face_type_b)
        (pick_face_a_inventory_allocated ?pick_face_type_a)
        (pick_face_b_reserved ?pick_face_type_b)
        (not
          (picker_confirmed_pick_complete ?human_picker)
        )
        (automated_picker_confirmed_pick_complete ?automated_picker)
        (manifest_unbound ?pick_batch_manifest)
      )
    :effect
      (and
        (manifest_bound ?pick_batch_manifest)
        (manifest_has_pick_face_a ?pick_batch_manifest ?pick_face_type_a)
        (manifest_has_pick_face_b ?pick_batch_manifest ?pick_face_type_b)
        (manifest_requires_weight_check ?pick_batch_manifest)
        (not
          (manifest_unbound ?pick_batch_manifest)
        )
      )
  )
  (:action assemble_manifest_with_qc_check
    :parameters (?human_picker - human_picker ?automated_picker - automated_picker ?pick_face_type_a - pick_face_type_a ?pick_face_type_b - pick_face_type_b ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (human_picker_ready_for_batch ?human_picker)
        (automated_picker_ready_for_batch ?automated_picker)
        (picker_assigned_to_pick_face_a ?human_picker ?pick_face_type_a)
        (automated_picker_assigned_to_pick_face_b ?automated_picker ?pick_face_type_b)
        (pick_face_a_reserved ?pick_face_type_a)
        (pick_face_b_inventory_allocated ?pick_face_type_b)
        (picker_confirmed_pick_complete ?human_picker)
        (not
          (automated_picker_confirmed_pick_complete ?automated_picker)
        )
        (manifest_unbound ?pick_batch_manifest)
      )
    :effect
      (and
        (manifest_bound ?pick_batch_manifest)
        (manifest_has_pick_face_a ?pick_batch_manifest ?pick_face_type_a)
        (manifest_has_pick_face_b ?pick_batch_manifest ?pick_face_type_b)
        (manifest_requires_qc_check ?pick_batch_manifest)
        (not
          (manifest_unbound ?pick_batch_manifest)
        )
      )
  )
  (:action assemble_manifest_with_weight_and_qc_checks
    :parameters (?human_picker - human_picker ?automated_picker - automated_picker ?pick_face_type_a - pick_face_type_a ?pick_face_type_b - pick_face_type_b ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (human_picker_ready_for_batch ?human_picker)
        (automated_picker_ready_for_batch ?automated_picker)
        (picker_assigned_to_pick_face_a ?human_picker ?pick_face_type_a)
        (automated_picker_assigned_to_pick_face_b ?automated_picker ?pick_face_type_b)
        (pick_face_a_inventory_allocated ?pick_face_type_a)
        (pick_face_b_inventory_allocated ?pick_face_type_b)
        (not
          (picker_confirmed_pick_complete ?human_picker)
        )
        (not
          (automated_picker_confirmed_pick_complete ?automated_picker)
        )
        (manifest_unbound ?pick_batch_manifest)
      )
    :effect
      (and
        (manifest_bound ?pick_batch_manifest)
        (manifest_has_pick_face_a ?pick_batch_manifest ?pick_face_type_a)
        (manifest_has_pick_face_b ?pick_batch_manifest ?pick_face_type_b)
        (manifest_requires_weight_check ?pick_batch_manifest)
        (manifest_requires_qc_check ?pick_batch_manifest)
        (not
          (manifest_unbound ?pick_batch_manifest)
        )
      )
  )
  (:action verify_manifest_weight
    :parameters (?pick_batch_manifest - pick_batch_manifest ?human_picker - human_picker ?sku_product - sku_product)
    :precondition
      (and
        (manifest_bound ?pick_batch_manifest)
        (human_picker_ready_for_batch ?human_picker)
        (pick_entity_assigned_sku ?human_picker ?sku_product)
        (not
          (manifest_weight_verified ?pick_batch_manifest)
        )
      )
    :effect (manifest_weight_verified ?pick_batch_manifest)
  )
  (:action lock_storage_bin_to_manifest
    :parameters (?pick_zone - pick_zone ?storage_bin - storage_bin ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (pick_entity_ready ?pick_zone)
        (zone_assigned_manifest ?pick_zone ?pick_batch_manifest)
        (zone_has_storage_bin ?pick_zone ?storage_bin)
        (storage_bin_available ?storage_bin)
        (manifest_bound ?pick_batch_manifest)
        (manifest_weight_verified ?pick_batch_manifest)
        (not
          (storage_bin_locked ?storage_bin)
        )
      )
    :effect
      (and
        (storage_bin_locked ?storage_bin)
        (storage_bin_assigned_to_manifest ?storage_bin ?pick_batch_manifest)
        (not
          (storage_bin_available ?storage_bin)
        )
      )
  )
  (:action lock_zone_resources_for_manifest
    :parameters (?pick_zone - pick_zone ?storage_bin - storage_bin ?pick_batch_manifest - pick_batch_manifest ?sku_product - sku_product)
    :precondition
      (and
        (pick_entity_ready ?pick_zone)
        (zone_has_storage_bin ?pick_zone ?storage_bin)
        (storage_bin_locked ?storage_bin)
        (storage_bin_assigned_to_manifest ?storage_bin ?pick_batch_manifest)
        (pick_entity_assigned_sku ?pick_zone ?sku_product)
        (not
          (manifest_requires_weight_check ?pick_batch_manifest)
        )
        (not
          (zone_resources_locked ?pick_zone)
        )
      )
    :effect (zone_resources_locked ?pick_zone)
  )
  (:action assign_staging_slot_to_zone
    :parameters (?pick_zone - pick_zone ?staging_slot - staging_slot)
    :precondition
      (and
        (pick_entity_ready ?pick_zone)
        (staging_slot_available ?staging_slot)
        (not
          (zone_has_staging_slot ?pick_zone)
        )
      )
    :effect
      (and
        (zone_has_staging_slot ?pick_zone)
        (zone_assigned_staging_slot ?pick_zone ?staging_slot)
        (not
          (staging_slot_available ?staging_slot)
        )
      )
  )
  (:action prepare_zone_staging_and_resources
    :parameters (?pick_zone - pick_zone ?storage_bin - storage_bin ?pick_batch_manifest - pick_batch_manifest ?sku_product - sku_product ?staging_slot - staging_slot)
    :precondition
      (and
        (pick_entity_ready ?pick_zone)
        (zone_has_storage_bin ?pick_zone ?storage_bin)
        (storage_bin_locked ?storage_bin)
        (storage_bin_assigned_to_manifest ?storage_bin ?pick_batch_manifest)
        (pick_entity_assigned_sku ?pick_zone ?sku_product)
        (manifest_requires_weight_check ?pick_batch_manifest)
        (zone_has_staging_slot ?pick_zone)
        (zone_assigned_staging_slot ?pick_zone ?staging_slot)
        (not
          (zone_resources_locked ?pick_zone)
        )
      )
    :effect
      (and
        (zone_resources_locked ?pick_zone)
        (zone_staging_prepared ?pick_zone)
      )
  )
  (:action prepare_zone_with_weigh_scale_no_qc
    :parameters (?pick_zone - pick_zone ?weigh_scale - weigh_scale ?pack_station - pack_station ?storage_bin - storage_bin ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (zone_resources_locked ?pick_zone)
        (zone_assigned_weigh_scale ?pick_zone ?weigh_scale)
        (pick_entity_assigned_to_pack_station ?pick_zone ?pack_station)
        (zone_has_storage_bin ?pick_zone ?storage_bin)
        (storage_bin_assigned_to_manifest ?storage_bin ?pick_batch_manifest)
        (not
          (manifest_requires_qc_check ?pick_batch_manifest)
        )
        (not
          (zone_prepared ?pick_zone)
        )
      )
    :effect (zone_prepared ?pick_zone)
  )
  (:action prepare_zone_with_weigh_scale_with_qc
    :parameters (?pick_zone - pick_zone ?weigh_scale - weigh_scale ?pack_station - pack_station ?storage_bin - storage_bin ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (zone_resources_locked ?pick_zone)
        (zone_assigned_weigh_scale ?pick_zone ?weigh_scale)
        (pick_entity_assigned_to_pack_station ?pick_zone ?pack_station)
        (zone_has_storage_bin ?pick_zone ?storage_bin)
        (storage_bin_assigned_to_manifest ?storage_bin ?pick_batch_manifest)
        (manifest_requires_qc_check ?pick_batch_manifest)
        (not
          (zone_prepared ?pick_zone)
        )
      )
    :effect (zone_prepared ?pick_zone)
  )
  (:action configure_zone_without_weight_or_qc
    :parameters (?pick_zone - pick_zone ?qc_station - qc_station ?storage_bin - storage_bin ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (zone_prepared ?pick_zone)
        (zone_assigned_qc_station ?pick_zone ?qc_station)
        (zone_has_storage_bin ?pick_zone ?storage_bin)
        (storage_bin_assigned_to_manifest ?storage_bin ?pick_batch_manifest)
        (not
          (manifest_requires_weight_check ?pick_batch_manifest)
        )
        (not
          (manifest_requires_qc_check ?pick_batch_manifest)
        )
        (not
          (zone_execution_ready ?pick_zone)
        )
      )
    :effect (zone_execution_ready ?pick_zone)
  )
  (:action configure_zone_with_weight_check
    :parameters (?pick_zone - pick_zone ?qc_station - qc_station ?storage_bin - storage_bin ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (zone_prepared ?pick_zone)
        (zone_assigned_qc_station ?pick_zone ?qc_station)
        (zone_has_storage_bin ?pick_zone ?storage_bin)
        (storage_bin_assigned_to_manifest ?storage_bin ?pick_batch_manifest)
        (manifest_requires_weight_check ?pick_batch_manifest)
        (not
          (manifest_requires_qc_check ?pick_batch_manifest)
        )
        (not
          (zone_execution_ready ?pick_zone)
        )
      )
    :effect
      (and
        (zone_execution_ready ?pick_zone)
        (zone_packing_kit_allocated ?pick_zone)
      )
  )
  (:action configure_zone_with_qc_check
    :parameters (?pick_zone - pick_zone ?qc_station - qc_station ?storage_bin - storage_bin ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (zone_prepared ?pick_zone)
        (zone_assigned_qc_station ?pick_zone ?qc_station)
        (zone_has_storage_bin ?pick_zone ?storage_bin)
        (storage_bin_assigned_to_manifest ?storage_bin ?pick_batch_manifest)
        (not
          (manifest_requires_weight_check ?pick_batch_manifest)
        )
        (manifest_requires_qc_check ?pick_batch_manifest)
        (not
          (zone_execution_ready ?pick_zone)
        )
      )
    :effect
      (and
        (zone_execution_ready ?pick_zone)
        (zone_packing_kit_allocated ?pick_zone)
      )
  )
  (:action configure_zone_with_weight_and_qc_checks
    :parameters (?pick_zone - pick_zone ?qc_station - qc_station ?storage_bin - storage_bin ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (zone_prepared ?pick_zone)
        (zone_assigned_qc_station ?pick_zone ?qc_station)
        (zone_has_storage_bin ?pick_zone ?storage_bin)
        (storage_bin_assigned_to_manifest ?storage_bin ?pick_batch_manifest)
        (manifest_requires_weight_check ?pick_batch_manifest)
        (manifest_requires_qc_check ?pick_batch_manifest)
        (not
          (zone_execution_ready ?pick_zone)
        )
      )
    :effect
      (and
        (zone_execution_ready ?pick_zone)
        (zone_packing_kit_allocated ?pick_zone)
      )
  )
  (:action register_zone_handoff
    :parameters (?pick_zone - pick_zone)
    :precondition
      (and
        (zone_execution_ready ?pick_zone)
        (not
          (zone_packing_kit_allocated ?pick_zone)
        )
        (not
          (zone_finalized ?pick_zone)
        )
      )
    :effect
      (and
        (zone_finalized ?pick_zone)
        (pick_entity_handoff_registered ?pick_zone)
      )
  )
  (:action assign_packing_kit_to_zone
    :parameters (?pick_zone - pick_zone ?packing_kit - packing_kit)
    :precondition
      (and
        (zone_execution_ready ?pick_zone)
        (zone_packing_kit_allocated ?pick_zone)
        (packing_kit_available ?packing_kit)
      )
    :effect
      (and
        (zone_assigned_packing_kit ?pick_zone ?packing_kit)
        (not
          (packing_kit_available ?packing_kit)
        )
      )
  )
  (:action commit_zone_execution
    :parameters (?pick_zone - pick_zone ?human_picker - human_picker ?automated_picker - automated_picker ?sku_product - sku_product ?packing_kit - packing_kit)
    :precondition
      (and
        (zone_execution_ready ?pick_zone)
        (zone_packing_kit_allocated ?pick_zone)
        (zone_assigned_packing_kit ?pick_zone ?packing_kit)
        (zone_assigned_human_picker ?pick_zone ?human_picker)
        (zone_assigned_automated_picker ?pick_zone ?automated_picker)
        (picker_confirmed_pick_complete ?human_picker)
        (automated_picker_confirmed_pick_complete ?automated_picker)
        (pick_entity_assigned_sku ?pick_zone ?sku_product)
        (not
          (zone_execution_committed ?pick_zone)
        )
      )
    :effect (zone_execution_committed ?pick_zone)
  )
  (:action finalize_zone_and_register_handoff
    :parameters (?pick_zone - pick_zone)
    :precondition
      (and
        (zone_execution_ready ?pick_zone)
        (zone_execution_committed ?pick_zone)
        (not
          (zone_finalized ?pick_zone)
        )
      )
    :effect
      (and
        (zone_finalized ?pick_zone)
        (pick_entity_handoff_registered ?pick_zone)
      )
  )
  (:action apply_priority_tag_to_zone
    :parameters (?pick_zone - pick_zone ?priority_tag - priority_tag ?sku_product - sku_product)
    :precondition
      (and
        (pick_entity_ready ?pick_zone)
        (pick_entity_assigned_sku ?pick_zone ?sku_product)
        (priority_tag_available ?priority_tag)
        (zone_assigned_priority_tag ?pick_zone ?priority_tag)
        (not
          (zone_priority_applied ?pick_zone)
        )
      )
    :effect
      (and
        (zone_priority_applied ?pick_zone)
        (not
          (priority_tag_available ?priority_tag)
        )
      )
  )
  (:action acknowledge_priority_at_pack_station
    :parameters (?pick_zone - pick_zone ?pack_station - pack_station)
    :precondition
      (and
        (zone_priority_applied ?pick_zone)
        (pick_entity_assigned_to_pack_station ?pick_zone ?pack_station)
        (not
          (zone_priority_acknowledged ?pick_zone)
        )
      )
    :effect (zone_priority_acknowledged ?pick_zone)
  )
  (:action mark_priority_processed_by_qc
    :parameters (?pick_zone - pick_zone ?qc_station - qc_station)
    :precondition
      (and
        (zone_priority_acknowledged ?pick_zone)
        (zone_assigned_qc_station ?pick_zone ?qc_station)
        (not
          (zone_priority_processed ?pick_zone)
        )
      )
    :effect (zone_priority_processed ?pick_zone)
  )
  (:action finalize_priority_and_register_handoff
    :parameters (?pick_zone - pick_zone)
    :precondition
      (and
        (zone_priority_processed ?pick_zone)
        (not
          (zone_finalized ?pick_zone)
        )
      )
    :effect
      (and
        (zone_finalized ?pick_zone)
        (pick_entity_handoff_registered ?pick_zone)
      )
  )
  (:action hand_off_picker_manifest
    :parameters (?human_picker - human_picker ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (human_picker_ready_for_batch ?human_picker)
        (picker_confirmed_pick_complete ?human_picker)
        (manifest_bound ?pick_batch_manifest)
        (manifest_weight_verified ?pick_batch_manifest)
        (not
          (pick_entity_handoff_registered ?human_picker)
        )
      )
    :effect (pick_entity_handoff_registered ?human_picker)
  )
  (:action hand_off_automated_picker_manifest
    :parameters (?automated_picker - automated_picker ?pick_batch_manifest - pick_batch_manifest)
    :precondition
      (and
        (automated_picker_ready_for_batch ?automated_picker)
        (automated_picker_confirmed_pick_complete ?automated_picker)
        (manifest_bound ?pick_batch_manifest)
        (manifest_weight_verified ?pick_batch_manifest)
        (not
          (pick_entity_handoff_registered ?automated_picker)
        )
      )
    :effect (pick_entity_handoff_registered ?automated_picker)
  )
  (:action bind_task_to_container
    :parameters (?pick_task - pick_entity ?container_label - container_label ?sku_product - sku_product)
    :precondition
      (and
        (pick_entity_handoff_registered ?pick_task)
        (pick_entity_assigned_sku ?pick_task ?sku_product)
        (container_label_available ?container_label)
        (not
          (pick_entity_bound_to_container ?pick_task)
        )
      )
    :effect
      (and
        (pick_entity_bound_to_container ?pick_task)
        (pick_entity_assigned_container_label ?pick_task ?container_label)
        (not
          (container_label_available ?container_label)
        )
      )
  )
  (:action complete_handoff_and_release_trolley
    :parameters (?human_picker - human_picker ?pick_trolley - pick_trolley ?container_label - container_label)
    :precondition
      (and
        (pick_entity_bound_to_container ?human_picker)
        (pick_entity_assigned_to_trolley ?human_picker ?pick_trolley)
        (pick_entity_assigned_container_label ?human_picker ?container_label)
        (not
          (pick_entity_processing_completed ?human_picker)
        )
      )
    :effect
      (and
        (pick_entity_processing_completed ?human_picker)
        (trolley_available ?pick_trolley)
        (container_label_available ?container_label)
      )
  )
  (:action complete_handoff_automated_and_release_trolley
    :parameters (?automated_picker - automated_picker ?pick_trolley - pick_trolley ?container_label - container_label)
    :precondition
      (and
        (pick_entity_bound_to_container ?automated_picker)
        (pick_entity_assigned_to_trolley ?automated_picker ?pick_trolley)
        (pick_entity_assigned_container_label ?automated_picker ?container_label)
        (not
          (pick_entity_processing_completed ?automated_picker)
        )
      )
    :effect
      (and
        (pick_entity_processing_completed ?automated_picker)
        (trolley_available ?pick_trolley)
        (container_label_available ?container_label)
      )
  )
  (:action complete_handoff_zone_and_release_trolley
    :parameters (?pick_zone - pick_zone ?pick_trolley - pick_trolley ?container_label - container_label)
    :precondition
      (and
        (pick_entity_bound_to_container ?pick_zone)
        (pick_entity_assigned_to_trolley ?pick_zone ?pick_trolley)
        (pick_entity_assigned_container_label ?pick_zone ?container_label)
        (not
          (pick_entity_processing_completed ?pick_zone)
        )
      )
    :effect
      (and
        (pick_entity_processing_completed ?pick_zone)
        (trolley_available ?pick_trolley)
        (container_label_available ?container_label)
      )
  )
)

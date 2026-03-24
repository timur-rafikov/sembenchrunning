(define (domain cartonization_pick_pack_flow_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types physical_object - object warehouse_resource - physical_object inventory_class - physical_object storage_bin_type - physical_object work_unit_root - physical_object work_unit - work_unit_root carton_supply_slot - warehouse_resource sku - warehouse_resource operator - warehouse_resource dimension_profile - warehouse_resource seal_type - warehouse_resource carton_identifier - warehouse_resource packaging_material - warehouse_resource shipping_authorization - warehouse_resource pickable_unit - inventory_class label_template - inventory_class verification_token - inventory_class pick_slot_a - storage_bin_type pick_slot_b - storage_bin_type carton - storage_bin_type work_unit_group_a - work_unit work_unit_group_b - work_unit pick_face_a - work_unit_group_a pick_face_b - work_unit_group_a pack_station - work_unit_group_b)

  (:predicates
    (work_unit_registered ?work_entity - work_unit)
    (work_unit_ready_for_packing ?work_entity - work_unit)
    (work_unit_carton_supply_allocated ?work_entity - work_unit)
    (work_unit_cartonized ?work_entity - work_unit)
    (completion_marker ?work_entity - work_unit)
    (work_unit_serialized ?work_entity - work_unit)
    (carton_supply_available ?carton_supply_slot - carton_supply_slot)
    (work_unit_allocated_carton_supply_slot ?work_entity - work_unit ?carton_supply_slot - carton_supply_slot)
    (sku_available ?sku - sku)
    (work_unit_has_sku ?work_entity - work_unit ?sku - sku)
    (operator_available ?operator - operator)
    (work_unit_assigned_operator ?work_entity - work_unit ?operator - operator)
    (pickable_unit_available ?pickable_unit - pickable_unit)
    (pick_face_a_reserved_unit ?pick_face_a - pick_face_a ?pickable_unit - pickable_unit)
    (pick_face_b_assigned_unit ?pick_face_b - pick_face_b ?pickable_unit - pickable_unit)
    (pick_face_a_has_slot ?pick_face_a - pick_face_a ?pick_slot_a - pick_slot_a)
    (pick_slot_a_selected ?pick_slot_a - pick_slot_a)
    (pick_slot_a_reserved ?pick_slot_a - pick_slot_a)
    (pick_face_a_pick_confirmed ?pick_face_a - pick_face_a)
    (pick_face_b_has_slot ?pick_face_b - pick_face_b ?pick_slot_b - pick_slot_b)
    (pick_slot_b_selected ?pick_slot_b - pick_slot_b)
    (pick_slot_b_reserved ?pick_slot_b - pick_slot_b)
    (pick_face_b_pick_confirmed ?pick_face_b - pick_face_b)
    (carton_available ?carton - carton)
    (carton_in_use ?carton - carton)
    (carton_linked_pick_slot_a ?carton - carton ?pick_slot_a - pick_slot_a)
    (carton_linked_pick_slot_b ?carton - carton ?pick_slot_b - pick_slot_b)
    (carton_weight_verified ?carton - carton)
    (carton_dimension_verified ?carton - carton)
    (carton_contents_verified ?carton - carton)
    (pack_station_assigned_pick_face_a ?pack_station - pack_station ?pick_face_a - pick_face_a)
    (pack_station_assigned_pick_face_b ?pack_station - pack_station ?pick_face_b - pick_face_b)
    (pack_station_has_carton ?pack_station - pack_station ?carton - carton)
    (label_template_available ?label_template - label_template)
    (pack_station_assigned_label_template ?pack_station - pack_station ?label_template - label_template)
    (label_template_in_use ?label_template - label_template)
    (label_template_applied_to_carton ?label_template - label_template ?carton - carton)
    (pack_station_labeling_ready ?pack_station - pack_station)
    (pack_station_packaging_prepared ?pack_station - pack_station)
    (pack_station_authorized ?pack_station - pack_station)
    (pack_station_dimension_selected ?pack_station - pack_station)
    (pack_station_dimension_check_passed ?pack_station - pack_station)
    (pack_station_qc_completed ?pack_station - pack_station)
    (pack_station_finalized ?pack_station - pack_station)
    (verification_token_available ?verification_token - verification_token)
    (pack_station_assigned_verification_token ?pack_station - pack_station ?verification_token - verification_token)
    (pack_station_verification_marked ?pack_station - pack_station)
    (pack_station_operator_verified ?pack_station - pack_station)
    (pack_station_shipping_authorization_confirmed ?pack_station - pack_station)
    (dimension_profile_available ?dimension_profile - dimension_profile)
    (pack_station_assigned_dimension_profile ?pack_station - pack_station ?dimension_profile - dimension_profile)
    (seal_type_available ?seal_type - seal_type)
    (pack_station_assigned_seal_type ?pack_station - pack_station ?seal_type - seal_type)
    (packaging_material_available ?packaging_material - packaging_material)
    (pack_station_assigned_packaging_material ?pack_station - pack_station ?packaging_material - packaging_material)
    (shipping_authorization_available ?shipping_authorization - shipping_authorization)
    (pack_station_assigned_shipping_authorization ?pack_station - pack_station ?shipping_authorization - shipping_authorization)
    (carton_identifier_available ?carton_identifier - carton_identifier)
    (work_unit_assigned_carton_identifier ?work_entity - work_unit ?carton_identifier - carton_identifier)
    (pick_face_a_ready ?pick_face_a - pick_face_a)
    (pick_face_b_ready ?pick_face_b - pick_face_b)
    (pack_station_released ?pack_station - pack_station)
  )
  (:action register_work_entity
    :parameters (?work_entity - work_unit)
    :precondition
      (and
        (not
          (work_unit_registered ?work_entity)
        )
        (not
          (work_unit_cartonized ?work_entity)
        )
      )
    :effect (work_unit_registered ?work_entity)
  )
  (:action allocate_carton_supply_to_work_entity
    :parameters (?work_entity - work_unit ?carton_supply_slot - carton_supply_slot)
    :precondition
      (and
        (work_unit_registered ?work_entity)
        (not
          (work_unit_carton_supply_allocated ?work_entity)
        )
        (carton_supply_available ?carton_supply_slot)
      )
    :effect
      (and
        (work_unit_carton_supply_allocated ?work_entity)
        (work_unit_allocated_carton_supply_slot ?work_entity ?carton_supply_slot)
        (not
          (carton_supply_available ?carton_supply_slot)
        )
      )
  )
  (:action assign_sku_to_work_entity
    :parameters (?work_entity - work_unit ?sku - sku)
    :precondition
      (and
        (work_unit_registered ?work_entity)
        (work_unit_carton_supply_allocated ?work_entity)
        (sku_available ?sku)
      )
    :effect
      (and
        (work_unit_has_sku ?work_entity ?sku)
        (not
          (sku_available ?sku)
        )
      )
  )
  (:action set_work_entity_ready_for_packing
    :parameters (?work_entity - work_unit ?sku - sku)
    :precondition
      (and
        (work_unit_registered ?work_entity)
        (work_unit_carton_supply_allocated ?work_entity)
        (work_unit_has_sku ?work_entity ?sku)
        (not
          (work_unit_ready_for_packing ?work_entity)
        )
      )
    :effect (work_unit_ready_for_packing ?work_entity)
  )
  (:action release_sku_from_work_entity
    :parameters (?work_entity - work_unit ?sku - sku)
    :precondition
      (and
        (work_unit_has_sku ?work_entity ?sku)
      )
    :effect
      (and
        (sku_available ?sku)
        (not
          (work_unit_has_sku ?work_entity ?sku)
        )
      )
  )
  (:action assign_operator_to_work_entity
    :parameters (?work_entity - work_unit ?operator - operator)
    :precondition
      (and
        (work_unit_ready_for_packing ?work_entity)
        (operator_available ?operator)
      )
    :effect
      (and
        (work_unit_assigned_operator ?work_entity ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action unassign_operator_from_work_entity
    :parameters (?work_entity - work_unit ?operator - operator)
    :precondition
      (and
        (work_unit_assigned_operator ?work_entity ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (work_unit_assigned_operator ?work_entity ?operator)
        )
      )
  )
  (:action assign_packaging_to_pack_station
    :parameters (?pack_station - pack_station ?packaging_material - packaging_material)
    :precondition
      (and
        (work_unit_ready_for_packing ?pack_station)
        (packaging_material_available ?packaging_material)
      )
    :effect
      (and
        (pack_station_assigned_packaging_material ?pack_station ?packaging_material)
        (not
          (packaging_material_available ?packaging_material)
        )
      )
  )
  (:action unassign_packaging_from_pack_station
    :parameters (?pack_station - pack_station ?packaging_material - packaging_material)
    :precondition
      (and
        (pack_station_assigned_packaging_material ?pack_station ?packaging_material)
      )
    :effect
      (and
        (packaging_material_available ?packaging_material)
        (not
          (pack_station_assigned_packaging_material ?pack_station ?packaging_material)
        )
      )
  )
  (:action assign_shipping_authorization_to_pack_station
    :parameters (?pack_station - pack_station ?shipping_authorization - shipping_authorization)
    :precondition
      (and
        (work_unit_ready_for_packing ?pack_station)
        (shipping_authorization_available ?shipping_authorization)
      )
    :effect
      (and
        (pack_station_assigned_shipping_authorization ?pack_station ?shipping_authorization)
        (not
          (shipping_authorization_available ?shipping_authorization)
        )
      )
  )
  (:action unassign_shipping_authorization_from_pack_station
    :parameters (?pack_station - pack_station ?shipping_authorization - shipping_authorization)
    :precondition
      (and
        (pack_station_assigned_shipping_authorization ?pack_station ?shipping_authorization)
      )
    :effect
      (and
        (shipping_authorization_available ?shipping_authorization)
        (not
          (pack_station_assigned_shipping_authorization ?pack_station ?shipping_authorization)
        )
      )
  )
  (:action select_pick_slot_a_for_consolidation
    :parameters (?pick_face_a - pick_face_a ?pick_slot_a - pick_slot_a ?sku - sku)
    :precondition
      (and
        (work_unit_ready_for_packing ?pick_face_a)
        (work_unit_has_sku ?pick_face_a ?sku)
        (pick_face_a_has_slot ?pick_face_a ?pick_slot_a)
        (not
          (pick_slot_a_selected ?pick_slot_a)
        )
        (not
          (pick_slot_a_reserved ?pick_slot_a)
        )
      )
    :effect (pick_slot_a_selected ?pick_slot_a)
  )
  (:action activate_pick_face_a_for_cartonization
    :parameters (?pick_face_a - pick_face_a ?pick_slot_a - pick_slot_a ?operator - operator)
    :precondition
      (and
        (work_unit_ready_for_packing ?pick_face_a)
        (work_unit_assigned_operator ?pick_face_a ?operator)
        (pick_face_a_has_slot ?pick_face_a ?pick_slot_a)
        (pick_slot_a_selected ?pick_slot_a)
        (not
          (pick_face_a_ready ?pick_face_a)
        )
      )
    :effect
      (and
        (pick_face_a_ready ?pick_face_a)
        (pick_face_a_pick_confirmed ?pick_face_a)
      )
  )
  (:action reserve_pickable_unit_on_pick_face_a
    :parameters (?pick_face_a - pick_face_a ?pick_slot_a - pick_slot_a ?pickable_unit - pickable_unit)
    :precondition
      (and
        (work_unit_ready_for_packing ?pick_face_a)
        (pick_face_a_has_slot ?pick_face_a ?pick_slot_a)
        (pickable_unit_available ?pickable_unit)
        (not
          (pick_face_a_ready ?pick_face_a)
        )
      )
    :effect
      (and
        (pick_slot_a_reserved ?pick_slot_a)
        (pick_face_a_ready ?pick_face_a)
        (pick_face_a_reserved_unit ?pick_face_a ?pickable_unit)
        (not
          (pickable_unit_available ?pickable_unit)
        )
      )
  )
  (:action execute_pick_from_pick_face_a
    :parameters (?pick_face_a - pick_face_a ?pick_slot_a - pick_slot_a ?sku - sku ?pickable_unit - pickable_unit)
    :precondition
      (and
        (work_unit_ready_for_packing ?pick_face_a)
        (work_unit_has_sku ?pick_face_a ?sku)
        (pick_face_a_has_slot ?pick_face_a ?pick_slot_a)
        (pick_slot_a_reserved ?pick_slot_a)
        (pick_face_a_reserved_unit ?pick_face_a ?pickable_unit)
        (not
          (pick_face_a_pick_confirmed ?pick_face_a)
        )
      )
    :effect
      (and
        (pick_slot_a_selected ?pick_slot_a)
        (pick_face_a_pick_confirmed ?pick_face_a)
        (pickable_unit_available ?pickable_unit)
        (not
          (pick_face_a_reserved_unit ?pick_face_a ?pickable_unit)
        )
      )
  )
  (:action select_pick_slot_b_for_consolidation
    :parameters (?pick_face_b - pick_face_b ?pick_slot_b - pick_slot_b ?sku - sku)
    :precondition
      (and
        (work_unit_ready_for_packing ?pick_face_b)
        (work_unit_has_sku ?pick_face_b ?sku)
        (pick_face_b_has_slot ?pick_face_b ?pick_slot_b)
        (not
          (pick_slot_b_selected ?pick_slot_b)
        )
        (not
          (pick_slot_b_reserved ?pick_slot_b)
        )
      )
    :effect (pick_slot_b_selected ?pick_slot_b)
  )
  (:action activate_pick_face_b_for_cartonization
    :parameters (?pick_face_b - pick_face_b ?pick_slot_b - pick_slot_b ?operator - operator)
    :precondition
      (and
        (work_unit_ready_for_packing ?pick_face_b)
        (work_unit_assigned_operator ?pick_face_b ?operator)
        (pick_face_b_has_slot ?pick_face_b ?pick_slot_b)
        (pick_slot_b_selected ?pick_slot_b)
        (not
          (pick_face_b_ready ?pick_face_b)
        )
      )
    :effect
      (and
        (pick_face_b_ready ?pick_face_b)
        (pick_face_b_pick_confirmed ?pick_face_b)
      )
  )
  (:action reserve_pickable_unit_on_pick_face_b
    :parameters (?pick_face_b - pick_face_b ?pick_slot_b - pick_slot_b ?pickable_unit - pickable_unit)
    :precondition
      (and
        (work_unit_ready_for_packing ?pick_face_b)
        (pick_face_b_has_slot ?pick_face_b ?pick_slot_b)
        (pickable_unit_available ?pickable_unit)
        (not
          (pick_face_b_ready ?pick_face_b)
        )
      )
    :effect
      (and
        (pick_slot_b_reserved ?pick_slot_b)
        (pick_face_b_ready ?pick_face_b)
        (pick_face_b_assigned_unit ?pick_face_b ?pickable_unit)
        (not
          (pickable_unit_available ?pickable_unit)
        )
      )
  )
  (:action execute_pick_from_pick_face_b
    :parameters (?pick_face_b - pick_face_b ?pick_slot_b - pick_slot_b ?sku - sku ?pickable_unit - pickable_unit)
    :precondition
      (and
        (work_unit_ready_for_packing ?pick_face_b)
        (work_unit_has_sku ?pick_face_b ?sku)
        (pick_face_b_has_slot ?pick_face_b ?pick_slot_b)
        (pick_slot_b_reserved ?pick_slot_b)
        (pick_face_b_assigned_unit ?pick_face_b ?pickable_unit)
        (not
          (pick_face_b_pick_confirmed ?pick_face_b)
        )
      )
    :effect
      (and
        (pick_slot_b_selected ?pick_slot_b)
        (pick_face_b_pick_confirmed ?pick_face_b)
        (pickable_unit_available ?pickable_unit)
        (not
          (pick_face_b_assigned_unit ?pick_face_b ?pickable_unit)
        )
      )
  )
  (:action assign_carton_to_pick_slots
    :parameters (?pick_face_a - pick_face_a ?pick_face_b - pick_face_b ?pick_slot_a - pick_slot_a ?pick_slot_b - pick_slot_b ?carton - carton)
    :precondition
      (and
        (pick_face_a_ready ?pick_face_a)
        (pick_face_b_ready ?pick_face_b)
        (pick_face_a_has_slot ?pick_face_a ?pick_slot_a)
        (pick_face_b_has_slot ?pick_face_b ?pick_slot_b)
        (pick_slot_a_selected ?pick_slot_a)
        (pick_slot_b_selected ?pick_slot_b)
        (pick_face_a_pick_confirmed ?pick_face_a)
        (pick_face_b_pick_confirmed ?pick_face_b)
        (carton_available ?carton)
      )
    :effect
      (and
        (carton_in_use ?carton)
        (carton_linked_pick_slot_a ?carton ?pick_slot_a)
        (carton_linked_pick_slot_b ?carton ?pick_slot_b)
        (not
          (carton_available ?carton)
        )
      )
  )
  (:action assign_carton_with_weight_check
    :parameters (?pick_face_a - pick_face_a ?pick_face_b - pick_face_b ?pick_slot_a - pick_slot_a ?pick_slot_b - pick_slot_b ?carton - carton)
    :precondition
      (and
        (pick_face_a_ready ?pick_face_a)
        (pick_face_b_ready ?pick_face_b)
        (pick_face_a_has_slot ?pick_face_a ?pick_slot_a)
        (pick_face_b_has_slot ?pick_face_b ?pick_slot_b)
        (pick_slot_a_reserved ?pick_slot_a)
        (pick_slot_b_selected ?pick_slot_b)
        (not
          (pick_face_a_pick_confirmed ?pick_face_a)
        )
        (pick_face_b_pick_confirmed ?pick_face_b)
        (carton_available ?carton)
      )
    :effect
      (and
        (carton_in_use ?carton)
        (carton_linked_pick_slot_a ?carton ?pick_slot_a)
        (carton_linked_pick_slot_b ?carton ?pick_slot_b)
        (carton_weight_verified ?carton)
        (not
          (carton_available ?carton)
        )
      )
  )
  (:action assign_carton_with_dimension_check
    :parameters (?pick_face_a - pick_face_a ?pick_face_b - pick_face_b ?pick_slot_a - pick_slot_a ?pick_slot_b - pick_slot_b ?carton - carton)
    :precondition
      (and
        (pick_face_a_ready ?pick_face_a)
        (pick_face_b_ready ?pick_face_b)
        (pick_face_a_has_slot ?pick_face_a ?pick_slot_a)
        (pick_face_b_has_slot ?pick_face_b ?pick_slot_b)
        (pick_slot_a_selected ?pick_slot_a)
        (pick_slot_b_reserved ?pick_slot_b)
        (pick_face_a_pick_confirmed ?pick_face_a)
        (not
          (pick_face_b_pick_confirmed ?pick_face_b)
        )
        (carton_available ?carton)
      )
    :effect
      (and
        (carton_in_use ?carton)
        (carton_linked_pick_slot_a ?carton ?pick_slot_a)
        (carton_linked_pick_slot_b ?carton ?pick_slot_b)
        (carton_dimension_verified ?carton)
        (not
          (carton_available ?carton)
        )
      )
  )
  (:action assign_carton_with_weight_and_dimension_checks
    :parameters (?pick_face_a - pick_face_a ?pick_face_b - pick_face_b ?pick_slot_a - pick_slot_a ?pick_slot_b - pick_slot_b ?carton - carton)
    :precondition
      (and
        (pick_face_a_ready ?pick_face_a)
        (pick_face_b_ready ?pick_face_b)
        (pick_face_a_has_slot ?pick_face_a ?pick_slot_a)
        (pick_face_b_has_slot ?pick_face_b ?pick_slot_b)
        (pick_slot_a_reserved ?pick_slot_a)
        (pick_slot_b_reserved ?pick_slot_b)
        (not
          (pick_face_a_pick_confirmed ?pick_face_a)
        )
        (not
          (pick_face_b_pick_confirmed ?pick_face_b)
        )
        (carton_available ?carton)
      )
    :effect
      (and
        (carton_in_use ?carton)
        (carton_linked_pick_slot_a ?carton ?pick_slot_a)
        (carton_linked_pick_slot_b ?carton ?pick_slot_b)
        (carton_weight_verified ?carton)
        (carton_dimension_verified ?carton)
        (not
          (carton_available ?carton)
        )
      )
  )
  (:action verify_carton_contents_from_pick_face_a
    :parameters (?carton - carton ?pick_face_a - pick_face_a ?sku - sku)
    :precondition
      (and
        (carton_in_use ?carton)
        (pick_face_a_ready ?pick_face_a)
        (work_unit_has_sku ?pick_face_a ?sku)
        (not
          (carton_contents_verified ?carton)
        )
      )
    :effect (carton_contents_verified ?carton)
  )
  (:action apply_label_template_to_carton
    :parameters (?pack_station - pack_station ?label_template - label_template ?carton - carton)
    :precondition
      (and
        (work_unit_ready_for_packing ?pack_station)
        (pack_station_has_carton ?pack_station ?carton)
        (pack_station_assigned_label_template ?pack_station ?label_template)
        (label_template_available ?label_template)
        (carton_in_use ?carton)
        (carton_contents_verified ?carton)
        (not
          (label_template_in_use ?label_template)
        )
      )
    :effect
      (and
        (label_template_in_use ?label_template)
        (label_template_applied_to_carton ?label_template ?carton)
        (not
          (label_template_available ?label_template)
        )
      )
  )
  (:action prepare_pack_station_for_labeling
    :parameters (?pack_station - pack_station ?label_template - label_template ?carton - carton ?sku - sku)
    :precondition
      (and
        (work_unit_ready_for_packing ?pack_station)
        (pack_station_assigned_label_template ?pack_station ?label_template)
        (label_template_in_use ?label_template)
        (label_template_applied_to_carton ?label_template ?carton)
        (work_unit_has_sku ?pack_station ?sku)
        (not
          (carton_weight_verified ?carton)
        )
        (not
          (pack_station_labeling_ready ?pack_station)
        )
      )
    :effect (pack_station_labeling_ready ?pack_station)
  )
  (:action assign_dimension_profile_to_pack_station
    :parameters (?pack_station - pack_station ?dimension_profile - dimension_profile)
    :precondition
      (and
        (work_unit_ready_for_packing ?pack_station)
        (dimension_profile_available ?dimension_profile)
        (not
          (pack_station_dimension_selected ?pack_station)
        )
      )
    :effect
      (and
        (pack_station_dimension_selected ?pack_station)
        (pack_station_assigned_dimension_profile ?pack_station ?dimension_profile)
        (not
          (dimension_profile_available ?dimension_profile)
        )
      )
  )
  (:action prepare_pack_station_dimension_and_labeling
    :parameters (?pack_station - pack_station ?label_template - label_template ?carton - carton ?sku - sku ?dimension_profile - dimension_profile)
    :precondition
      (and
        (work_unit_ready_for_packing ?pack_station)
        (pack_station_assigned_label_template ?pack_station ?label_template)
        (label_template_in_use ?label_template)
        (label_template_applied_to_carton ?label_template ?carton)
        (work_unit_has_sku ?pack_station ?sku)
        (carton_weight_verified ?carton)
        (pack_station_dimension_selected ?pack_station)
        (pack_station_assigned_dimension_profile ?pack_station ?dimension_profile)
        (not
          (pack_station_labeling_ready ?pack_station)
        )
      )
    :effect
      (and
        (pack_station_labeling_ready ?pack_station)
        (pack_station_dimension_check_passed ?pack_station)
      )
  )
  (:action apply_packaging_material_to_pack_station
    :parameters (?pack_station - pack_station ?packaging_material - packaging_material ?operator - operator ?label_template - label_template ?carton - carton)
    :precondition
      (and
        (pack_station_labeling_ready ?pack_station)
        (pack_station_assigned_packaging_material ?pack_station ?packaging_material)
        (work_unit_assigned_operator ?pack_station ?operator)
        (pack_station_assigned_label_template ?pack_station ?label_template)
        (label_template_applied_to_carton ?label_template ?carton)
        (not
          (carton_dimension_verified ?carton)
        )
        (not
          (pack_station_packaging_prepared ?pack_station)
        )
      )
    :effect (pack_station_packaging_prepared ?pack_station)
  )
  (:action apply_packaging_material_to_pack_station_confirm
    :parameters (?pack_station - pack_station ?packaging_material - packaging_material ?operator - operator ?label_template - label_template ?carton - carton)
    :precondition
      (and
        (pack_station_labeling_ready ?pack_station)
        (pack_station_assigned_packaging_material ?pack_station ?packaging_material)
        (work_unit_assigned_operator ?pack_station ?operator)
        (pack_station_assigned_label_template ?pack_station ?label_template)
        (label_template_applied_to_carton ?label_template ?carton)
        (carton_dimension_verified ?carton)
        (not
          (pack_station_packaging_prepared ?pack_station)
        )
      )
    :effect (pack_station_packaging_prepared ?pack_station)
  )
  (:action authorize_pack_station_for_shipping
    :parameters (?pack_station - pack_station ?shipping_authorization - shipping_authorization ?label_template - label_template ?carton - carton)
    :precondition
      (and
        (pack_station_packaging_prepared ?pack_station)
        (pack_station_assigned_shipping_authorization ?pack_station ?shipping_authorization)
        (pack_station_assigned_label_template ?pack_station ?label_template)
        (label_template_applied_to_carton ?label_template ?carton)
        (not
          (carton_weight_verified ?carton)
        )
        (not
          (carton_dimension_verified ?carton)
        )
        (not
          (pack_station_authorized ?pack_station)
        )
      )
    :effect (pack_station_authorized ?pack_station)
  )
  (:action authorize_and_qc_pack_station
    :parameters (?pack_station - pack_station ?shipping_authorization - shipping_authorization ?label_template - label_template ?carton - carton)
    :precondition
      (and
        (pack_station_packaging_prepared ?pack_station)
        (pack_station_assigned_shipping_authorization ?pack_station ?shipping_authorization)
        (pack_station_assigned_label_template ?pack_station ?label_template)
        (label_template_applied_to_carton ?label_template ?carton)
        (carton_weight_verified ?carton)
        (not
          (carton_dimension_verified ?carton)
        )
        (not
          (pack_station_authorized ?pack_station)
        )
      )
    :effect
      (and
        (pack_station_authorized ?pack_station)
        (pack_station_qc_completed ?pack_station)
      )
  )
  (:action authorize_and_qc_pack_station_alt
    :parameters (?pack_station - pack_station ?shipping_authorization - shipping_authorization ?label_template - label_template ?carton - carton)
    :precondition
      (and
        (pack_station_packaging_prepared ?pack_station)
        (pack_station_assigned_shipping_authorization ?pack_station ?shipping_authorization)
        (pack_station_assigned_label_template ?pack_station ?label_template)
        (label_template_applied_to_carton ?label_template ?carton)
        (not
          (carton_weight_verified ?carton)
        )
        (carton_dimension_verified ?carton)
        (not
          (pack_station_authorized ?pack_station)
        )
      )
    :effect
      (and
        (pack_station_authorized ?pack_station)
        (pack_station_qc_completed ?pack_station)
      )
  )
  (:action authorize_and_qc_pack_station_all
    :parameters (?pack_station - pack_station ?shipping_authorization - shipping_authorization ?label_template - label_template ?carton - carton)
    :precondition
      (and
        (pack_station_packaging_prepared ?pack_station)
        (pack_station_assigned_shipping_authorization ?pack_station ?shipping_authorization)
        (pack_station_assigned_label_template ?pack_station ?label_template)
        (label_template_applied_to_carton ?label_template ?carton)
        (carton_weight_verified ?carton)
        (carton_dimension_verified ?carton)
        (not
          (pack_station_authorized ?pack_station)
        )
      )
    :effect
      (and
        (pack_station_authorized ?pack_station)
        (pack_station_qc_completed ?pack_station)
      )
  )
  (:action finalize_pack_station
    :parameters (?pack_station - pack_station)
    :precondition
      (and
        (pack_station_authorized ?pack_station)
        (not
          (pack_station_qc_completed ?pack_station)
        )
        (not
          (pack_station_released ?pack_station)
        )
      )
    :effect
      (and
        (pack_station_released ?pack_station)
        (completion_marker ?pack_station)
      )
  )
  (:action assign_seal_type_to_pack_station
    :parameters (?pack_station - pack_station ?seal_type - seal_type)
    :precondition
      (and
        (pack_station_authorized ?pack_station)
        (pack_station_qc_completed ?pack_station)
        (seal_type_available ?seal_type)
      )
    :effect
      (and
        (pack_station_assigned_seal_type ?pack_station ?seal_type)
        (not
          (seal_type_available ?seal_type)
        )
      )
  )
  (:action complete_pack_station_preparation_for_release
    :parameters (?pack_station - pack_station ?pick_face_a - pick_face_a ?pick_face_b - pick_face_b ?sku - sku ?seal_type - seal_type)
    :precondition
      (and
        (pack_station_authorized ?pack_station)
        (pack_station_qc_completed ?pack_station)
        (pack_station_assigned_seal_type ?pack_station ?seal_type)
        (pack_station_assigned_pick_face_a ?pack_station ?pick_face_a)
        (pack_station_assigned_pick_face_b ?pack_station ?pick_face_b)
        (pick_face_a_pick_confirmed ?pick_face_a)
        (pick_face_b_pick_confirmed ?pick_face_b)
        (work_unit_has_sku ?pack_station ?sku)
        (not
          (pack_station_finalized ?pack_station)
        )
      )
    :effect (pack_station_finalized ?pack_station)
  )
  (:action release_pack_station
    :parameters (?pack_station - pack_station)
    :precondition
      (and
        (pack_station_authorized ?pack_station)
        (pack_station_finalized ?pack_station)
        (not
          (pack_station_released ?pack_station)
        )
      )
    :effect
      (and
        (pack_station_released ?pack_station)
        (completion_marker ?pack_station)
      )
  )
  (:action assign_verification_token_to_pack_station
    :parameters (?pack_station - pack_station ?verification_token - verification_token ?sku - sku)
    :precondition
      (and
        (work_unit_ready_for_packing ?pack_station)
        (work_unit_has_sku ?pack_station ?sku)
        (verification_token_available ?verification_token)
        (pack_station_assigned_verification_token ?pack_station ?verification_token)
        (not
          (pack_station_verification_marked ?pack_station)
        )
      )
    :effect
      (and
        (pack_station_verification_marked ?pack_station)
        (not
          (verification_token_available ?verification_token)
        )
      )
  )
  (:action perform_operator_verification_at_pack_station
    :parameters (?pack_station - pack_station ?operator - operator)
    :precondition
      (and
        (pack_station_verification_marked ?pack_station)
        (work_unit_assigned_operator ?pack_station ?operator)
        (not
          (pack_station_operator_verified ?pack_station)
        )
      )
    :effect (pack_station_operator_verified ?pack_station)
  )
  (:action confirm_shipping_authorization_at_pack_station
    :parameters (?pack_station - pack_station ?shipping_authorization - shipping_authorization)
    :precondition
      (and
        (pack_station_operator_verified ?pack_station)
        (pack_station_assigned_shipping_authorization ?pack_station ?shipping_authorization)
        (not
          (pack_station_shipping_authorization_confirmed ?pack_station)
        )
      )
    :effect (pack_station_shipping_authorization_confirmed ?pack_station)
  )
  (:action finalize_pack_station_with_authorization
    :parameters (?pack_station - pack_station)
    :precondition
      (and
        (pack_station_shipping_authorization_confirmed ?pack_station)
        (not
          (pack_station_released ?pack_station)
        )
      )
    :effect
      (and
        (pack_station_released ?pack_station)
        (completion_marker ?pack_station)
      )
  )
  (:action complete_pick_face_a_task
    :parameters (?pick_face_a - pick_face_a ?carton - carton)
    :precondition
      (and
        (pick_face_a_ready ?pick_face_a)
        (pick_face_a_pick_confirmed ?pick_face_a)
        (carton_in_use ?carton)
        (carton_contents_verified ?carton)
        (not
          (completion_marker ?pick_face_a)
        )
      )
    :effect (completion_marker ?pick_face_a)
  )
  (:action complete_pick_face_b_task
    :parameters (?pick_face_b - pick_face_b ?carton - carton)
    :precondition
      (and
        (pick_face_b_ready ?pick_face_b)
        (pick_face_b_pick_confirmed ?pick_face_b)
        (carton_in_use ?carton)
        (carton_contents_verified ?carton)
        (not
          (completion_marker ?pick_face_b)
        )
      )
    :effect (completion_marker ?pick_face_b)
  )
  (:action assign_carton_identifier_to_work_entity
    :parameters (?work_entity - work_unit ?carton_identifier - carton_identifier ?sku - sku)
    :precondition
      (and
        (completion_marker ?work_entity)
        (work_unit_has_sku ?work_entity ?sku)
        (carton_identifier_available ?carton_identifier)
        (not
          (work_unit_serialized ?work_entity)
        )
      )
    :effect
      (and
        (work_unit_serialized ?work_entity)
        (work_unit_assigned_carton_identifier ?work_entity ?carton_identifier)
        (not
          (carton_identifier_available ?carton_identifier)
        )
      )
  )
  (:action finalize_cartonization_from_pick_face_a
    :parameters (?pick_face_a - pick_face_a ?carton_supply_slot - carton_supply_slot ?carton_identifier - carton_identifier)
    :precondition
      (and
        (work_unit_serialized ?pick_face_a)
        (work_unit_allocated_carton_supply_slot ?pick_face_a ?carton_supply_slot)
        (work_unit_assigned_carton_identifier ?pick_face_a ?carton_identifier)
        (not
          (work_unit_cartonized ?pick_face_a)
        )
      )
    :effect
      (and
        (work_unit_cartonized ?pick_face_a)
        (carton_supply_available ?carton_supply_slot)
        (carton_identifier_available ?carton_identifier)
      )
  )
  (:action finalize_cartonization_from_pick_face_b
    :parameters (?pick_face_b - pick_face_b ?carton_supply_slot - carton_supply_slot ?carton_identifier - carton_identifier)
    :precondition
      (and
        (work_unit_serialized ?pick_face_b)
        (work_unit_allocated_carton_supply_slot ?pick_face_b ?carton_supply_slot)
        (work_unit_assigned_carton_identifier ?pick_face_b ?carton_identifier)
        (not
          (work_unit_cartonized ?pick_face_b)
        )
      )
    :effect
      (and
        (work_unit_cartonized ?pick_face_b)
        (carton_supply_available ?carton_supply_slot)
        (carton_identifier_available ?carton_identifier)
      )
  )
  (:action finalize_cartonization_at_pack_station
    :parameters (?pack_station - pack_station ?carton_supply_slot - carton_supply_slot ?carton_identifier - carton_identifier)
    :precondition
      (and
        (work_unit_serialized ?pack_station)
        (work_unit_allocated_carton_supply_slot ?pack_station ?carton_supply_slot)
        (work_unit_assigned_carton_identifier ?pack_station ?carton_identifier)
        (not
          (work_unit_cartonized ?pack_station)
        )
      )
    :effect
      (and
        (work_unit_cartonized ?pack_station)
        (carton_supply_available ?carton_supply_slot)
        (carton_identifier_available ?carton_identifier)
      )
  )
)

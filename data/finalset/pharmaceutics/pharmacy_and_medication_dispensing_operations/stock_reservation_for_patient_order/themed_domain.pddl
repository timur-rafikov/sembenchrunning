(define (domain pharmacy_stock_reservation)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object pharmacy_resource_category - domain_object clinical_resource_category - domain_object operational_resource_category - domain_object order_root - domain_object order_entity - order_root inventory_unit - pharmacy_resource_category clinical_check_resource - pharmacy_resource_category authorizing_pharmacist - pharmacy_resource_category auxiliary_label - pharmacy_resource_category outbound_instruction_template - pharmacy_resource_category patient_instruction - pharmacy_resource_category lot_information - pharmacy_resource_category clinical_approval_record - pharmacy_resource_category packaging_material - clinical_resource_category packaging_component - clinical_resource_category insurance_authorization_record - clinical_resource_category storage_location - operational_resource_category packaging_station - operational_resource_category medication_package - operational_resource_category order_group - order_entity order_subgroup - order_entity patient_order - order_group prescription_line - order_group dispensing_task - order_subgroup)

  (:predicates
    (order_registered ?order - order_entity)
    (clinical_review_completed ?order - order_entity)
    (order_has_reservation ?order - order_entity)
    (stock_released ?order - order_entity)
    (ready_for_authorization ?order - order_entity)
    (dispense_authorization_granted ?order - order_entity)
    (inventory_available ?inventory_unit - inventory_unit)
    (order_reserved_inventory ?order - order_entity ?inventory_unit - inventory_unit)
    (clinical_resource_available ?clinical_resource - clinical_check_resource)
    (order_assigned_clinical_resource ?order - order_entity ?clinical_resource - clinical_check_resource)
    (pharmacist_available ?pharmacist - authorizing_pharmacist)
    (order_assigned_pharmacist ?order - order_entity ?pharmacist - authorizing_pharmacist)
    (packaging_material_available ?packaging_material - packaging_material)
    (patient_order_assigned_packaging_material ?patient_order - patient_order ?packaging_material - packaging_material)
    (prescription_line_assigned_packaging_material ?prescription_line - prescription_line ?packaging_material - packaging_material)
    (order_assigned_storage_location ?patient_order - patient_order ?storage_location - storage_location)
    (storage_location_earmarked_for_pick ?storage_location - storage_location)
    (storage_location_material_selected ?storage_location - storage_location)
    (patient_order_pick_confirmed ?patient_order - patient_order)
    (prescription_line_assigned_packaging_station ?prescription_line - prescription_line ?packaging_station - packaging_station)
    (packaging_station_marked ?packaging_station - packaging_station)
    (packaging_station_material_assigned ?packaging_station - packaging_station)
    (prescription_line_ready_for_packaging ?prescription_line - prescription_line)
    (medication_package_creation_slot_available ?medication_package - medication_package)
    (medication_package_created ?medication_package - medication_package)
    (medication_package_assigned_storage_location ?medication_package - medication_package ?storage_location - storage_location)
    (medication_package_assigned_packaging_station ?medication_package - medication_package ?packaging_station - packaging_station)
    (medication_package_requires_auxiliary_label ?medication_package - medication_package)
    (medication_package_requires_insurance_verification ?medication_package - medication_package)
    (medication_package_confirmed ?medication_package - medication_package)
    (dispensing_task_assigned_to_patient_order ?dispensing_task - dispensing_task ?patient_order - patient_order)
    (dispensing_task_assigned_to_prescription_line ?dispensing_task - dispensing_task ?prescription_line - prescription_line)
    (dispensing_task_associated_with_package ?dispensing_task - dispensing_task ?medication_package - medication_package)
    (packaging_component_available ?packaging_component - packaging_component)
    (dispensing_task_attached_component ?dispensing_task - dispensing_task ?packaging_component - packaging_component)
    (packaging_component_attached ?packaging_component - packaging_component)
    (component_attached_to_package ?packaging_component - packaging_component ?medication_package - medication_package)
    (dispensing_task_lot_verified ?dispensing_task - dispensing_task)
    (dispensing_task_component_verified ?dispensing_task - dispensing_task)
    (dispensing_task_ready_for_final_verification ?dispensing_task - dispensing_task)
    (auxiliary_label_attached ?dispensing_task - dispensing_task)
    (auxiliary_label_verified ?dispensing_task - dispensing_task)
    (dispensing_task_requires_outbound_instruction ?dispensing_task - dispensing_task)
    (dispensing_task_quality_verified ?dispensing_task - dispensing_task)
    (insurance_authorization_available ?insurance_authorization - insurance_authorization_record)
    (dispensing_task_insurance_authorization_link ?dispensing_task - dispensing_task ?insurance_authorization - insurance_authorization_record)
    (task_claimed_insurance_authorization ?dispensing_task - dispensing_task)
    (insurance_authorization_confirmed_for_task ?dispensing_task - dispensing_task)
    (insurance_authorization_verified_for_task ?dispensing_task - dispensing_task)
    (auxiliary_label_available ?auxiliary_label - auxiliary_label)
    (dispensing_task_auxiliary_label_assigned ?dispensing_task - dispensing_task ?auxiliary_label - auxiliary_label)
    (instruction_template_available ?instruction_template - outbound_instruction_template)
    (dispensing_task_assigned_instruction_template ?dispensing_task - dispensing_task ?instruction_template - outbound_instruction_template)
    (lot_information_available ?lot_information - lot_information)
    (dispensing_task_assigned_lot_information ?dispensing_task - dispensing_task ?lot_information - lot_information)
    (clinical_approval_available ?clinical_approval - clinical_approval_record)
    (dispensing_task_assigned_clinical_approval ?dispensing_task - dispensing_task ?clinical_approval - clinical_approval_record)
    (patient_instruction_available ?patient_instruction - patient_instruction)
    (order_associated_patient_instruction ?order - order_entity ?patient_instruction - patient_instruction)
    (order_pick_in_progress ?patient_order - patient_order)
    (prescription_line_pick_in_progress ?prescription_line - prescription_line)
    (dispensing_task_finalized ?dispensing_task - dispensing_task)
  )
  (:action register_order
    :parameters (?order - order_entity)
    :precondition
      (and
        (not
          (order_registered ?order)
        )
        (not
          (stock_released ?order)
        )
      )
    :effect (order_registered ?order)
  )
  (:action reserve_inventory_for_order
    :parameters (?order - order_entity ?inventory_unit - inventory_unit)
    :precondition
      (and
        (order_registered ?order)
        (not
          (order_has_reservation ?order)
        )
        (inventory_available ?inventory_unit)
      )
    :effect
      (and
        (order_has_reservation ?order)
        (order_reserved_inventory ?order ?inventory_unit)
        (not
          (inventory_available ?inventory_unit)
        )
      )
  )
  (:action allocate_clinical_resource_to_order
    :parameters (?order - order_entity ?clinical_resource - clinical_check_resource)
    :precondition
      (and
        (order_registered ?order)
        (order_has_reservation ?order)
        (clinical_resource_available ?clinical_resource)
      )
    :effect
      (and
        (order_assigned_clinical_resource ?order ?clinical_resource)
        (not
          (clinical_resource_available ?clinical_resource)
        )
      )
  )
  (:action complete_clinical_review_for_order
    :parameters (?order - order_entity ?clinical_resource - clinical_check_resource)
    :precondition
      (and
        (order_registered ?order)
        (order_has_reservation ?order)
        (order_assigned_clinical_resource ?order ?clinical_resource)
        (not
          (clinical_review_completed ?order)
        )
      )
    :effect (clinical_review_completed ?order)
  )
  (:action release_clinical_resource_from_order
    :parameters (?order - order_entity ?clinical_resource - clinical_check_resource)
    :precondition
      (and
        (order_assigned_clinical_resource ?order ?clinical_resource)
      )
    :effect
      (and
        (clinical_resource_available ?clinical_resource)
        (not
          (order_assigned_clinical_resource ?order ?clinical_resource)
        )
      )
  )
  (:action assign_pharmacist_to_order
    :parameters (?order - order_entity ?pharmacist - authorizing_pharmacist)
    :precondition
      (and
        (clinical_review_completed ?order)
        (pharmacist_available ?pharmacist)
      )
    :effect
      (and
        (order_assigned_pharmacist ?order ?pharmacist)
        (not
          (pharmacist_available ?pharmacist)
        )
      )
  )
  (:action release_pharmacist_from_order
    :parameters (?order - order_entity ?pharmacist - authorizing_pharmacist)
    :precondition
      (and
        (order_assigned_pharmacist ?order ?pharmacist)
      )
    :effect
      (and
        (pharmacist_available ?pharmacist)
        (not
          (order_assigned_pharmacist ?order ?pharmacist)
        )
      )
  )
  (:action assign_lot_information_to_task
    :parameters (?dispensing_task - dispensing_task ?lot_information - lot_information)
    :precondition
      (and
        (clinical_review_completed ?dispensing_task)
        (lot_information_available ?lot_information)
      )
    :effect
      (and
        (dispensing_task_assigned_lot_information ?dispensing_task ?lot_information)
        (not
          (lot_information_available ?lot_information)
        )
      )
  )
  (:action release_lot_information_from_task
    :parameters (?dispensing_task - dispensing_task ?lot_information - lot_information)
    :precondition
      (and
        (dispensing_task_assigned_lot_information ?dispensing_task ?lot_information)
      )
    :effect
      (and
        (lot_information_available ?lot_information)
        (not
          (dispensing_task_assigned_lot_information ?dispensing_task ?lot_information)
        )
      )
  )
  (:action assign_clinical_approval_to_task
    :parameters (?dispensing_task - dispensing_task ?clinical_approval - clinical_approval_record)
    :precondition
      (and
        (clinical_review_completed ?dispensing_task)
        (clinical_approval_available ?clinical_approval)
      )
    :effect
      (and
        (dispensing_task_assigned_clinical_approval ?dispensing_task ?clinical_approval)
        (not
          (clinical_approval_available ?clinical_approval)
        )
      )
  )
  (:action release_clinical_approval_from_task
    :parameters (?dispensing_task - dispensing_task ?clinical_approval - clinical_approval_record)
    :precondition
      (and
        (dispensing_task_assigned_clinical_approval ?dispensing_task ?clinical_approval)
      )
    :effect
      (and
        (clinical_approval_available ?clinical_approval)
        (not
          (dispensing_task_assigned_clinical_approval ?dispensing_task ?clinical_approval)
        )
      )
  )
  (:action plan_pick_at_storage_location
    :parameters (?patient_order - patient_order ?storage_location - storage_location ?clinical_resource - clinical_check_resource)
    :precondition
      (and
        (clinical_review_completed ?patient_order)
        (order_assigned_clinical_resource ?patient_order ?clinical_resource)
        (order_assigned_storage_location ?patient_order ?storage_location)
        (not
          (storage_location_earmarked_for_pick ?storage_location)
        )
        (not
          (storage_location_material_selected ?storage_location)
        )
      )
    :effect (storage_location_earmarked_for_pick ?storage_location)
  )
  (:action confirm_pick_assignment_by_pharmacist
    :parameters (?patient_order - patient_order ?storage_location - storage_location ?pharmacist - authorizing_pharmacist)
    :precondition
      (and
        (clinical_review_completed ?patient_order)
        (order_assigned_pharmacist ?patient_order ?pharmacist)
        (order_assigned_storage_location ?patient_order ?storage_location)
        (storage_location_earmarked_for_pick ?storage_location)
        (not
          (order_pick_in_progress ?patient_order)
        )
      )
    :effect
      (and
        (order_pick_in_progress ?patient_order)
        (patient_order_pick_confirmed ?patient_order)
      )
  )
  (:action select_packaging_material_at_location
    :parameters (?patient_order - patient_order ?storage_location - storage_location ?packaging_material - packaging_material)
    :precondition
      (and
        (clinical_review_completed ?patient_order)
        (order_assigned_storage_location ?patient_order ?storage_location)
        (packaging_material_available ?packaging_material)
        (not
          (order_pick_in_progress ?patient_order)
        )
      )
    :effect
      (and
        (storage_location_material_selected ?storage_location)
        (order_pick_in_progress ?patient_order)
        (patient_order_assigned_packaging_material ?patient_order ?packaging_material)
        (not
          (packaging_material_available ?packaging_material)
        )
      )
  )
  (:action confirm_material_selection_for_order
    :parameters (?patient_order - patient_order ?storage_location - storage_location ?clinical_resource - clinical_check_resource ?packaging_material - packaging_material)
    :precondition
      (and
        (clinical_review_completed ?patient_order)
        (order_assigned_clinical_resource ?patient_order ?clinical_resource)
        (order_assigned_storage_location ?patient_order ?storage_location)
        (storage_location_material_selected ?storage_location)
        (patient_order_assigned_packaging_material ?patient_order ?packaging_material)
        (not
          (patient_order_pick_confirmed ?patient_order)
        )
      )
    :effect
      (and
        (storage_location_earmarked_for_pick ?storage_location)
        (patient_order_pick_confirmed ?patient_order)
        (packaging_material_available ?packaging_material)
        (not
          (patient_order_assigned_packaging_material ?patient_order ?packaging_material)
        )
      )
  )
  (:action plan_pick_for_packaging_station
    :parameters (?prescription_line - prescription_line ?packaging_station - packaging_station ?clinical_resource - clinical_check_resource)
    :precondition
      (and
        (clinical_review_completed ?prescription_line)
        (order_assigned_clinical_resource ?prescription_line ?clinical_resource)
        (prescription_line_assigned_packaging_station ?prescription_line ?packaging_station)
        (not
          (packaging_station_marked ?packaging_station)
        )
        (not
          (packaging_station_material_assigned ?packaging_station)
        )
      )
    :effect (packaging_station_marked ?packaging_station)
  )
  (:action confirm_packaging_station_assignment
    :parameters (?prescription_line - prescription_line ?packaging_station - packaging_station ?pharmacist - authorizing_pharmacist)
    :precondition
      (and
        (clinical_review_completed ?prescription_line)
        (order_assigned_pharmacist ?prescription_line ?pharmacist)
        (prescription_line_assigned_packaging_station ?prescription_line ?packaging_station)
        (packaging_station_marked ?packaging_station)
        (not
          (prescription_line_pick_in_progress ?prescription_line)
        )
      )
    :effect
      (and
        (prescription_line_pick_in_progress ?prescription_line)
        (prescription_line_ready_for_packaging ?prescription_line)
      )
  )
  (:action assign_packaging_material_to_prescription_line
    :parameters (?prescription_line - prescription_line ?packaging_station - packaging_station ?packaging_material - packaging_material)
    :precondition
      (and
        (clinical_review_completed ?prescription_line)
        (prescription_line_assigned_packaging_station ?prescription_line ?packaging_station)
        (packaging_material_available ?packaging_material)
        (not
          (prescription_line_pick_in_progress ?prescription_line)
        )
      )
    :effect
      (and
        (packaging_station_material_assigned ?packaging_station)
        (prescription_line_pick_in_progress ?prescription_line)
        (prescription_line_assigned_packaging_material ?prescription_line ?packaging_material)
        (not
          (packaging_material_available ?packaging_material)
        )
      )
  )
  (:action confirm_line_material_selection
    :parameters (?prescription_line - prescription_line ?packaging_station - packaging_station ?clinical_resource - clinical_check_resource ?packaging_material - packaging_material)
    :precondition
      (and
        (clinical_review_completed ?prescription_line)
        (order_assigned_clinical_resource ?prescription_line ?clinical_resource)
        (prescription_line_assigned_packaging_station ?prescription_line ?packaging_station)
        (packaging_station_material_assigned ?packaging_station)
        (prescription_line_assigned_packaging_material ?prescription_line ?packaging_material)
        (not
          (prescription_line_ready_for_packaging ?prescription_line)
        )
      )
    :effect
      (and
        (packaging_station_marked ?packaging_station)
        (prescription_line_ready_for_packaging ?prescription_line)
        (packaging_material_available ?packaging_material)
        (not
          (prescription_line_assigned_packaging_material ?prescription_line ?packaging_material)
        )
      )
  )
  (:action create_medication_package
    :parameters (?patient_order - patient_order ?prescription_line - prescription_line ?storage_location - storage_location ?packaging_station - packaging_station ?medication_package - medication_package)
    :precondition
      (and
        (order_pick_in_progress ?patient_order)
        (prescription_line_pick_in_progress ?prescription_line)
        (order_assigned_storage_location ?patient_order ?storage_location)
        (prescription_line_assigned_packaging_station ?prescription_line ?packaging_station)
        (storage_location_earmarked_for_pick ?storage_location)
        (packaging_station_marked ?packaging_station)
        (patient_order_pick_confirmed ?patient_order)
        (prescription_line_ready_for_packaging ?prescription_line)
        (medication_package_creation_slot_available ?medication_package)
      )
    :effect
      (and
        (medication_package_created ?medication_package)
        (medication_package_assigned_storage_location ?medication_package ?storage_location)
        (medication_package_assigned_packaging_station ?medication_package ?packaging_station)
        (not
          (medication_package_creation_slot_available ?medication_package)
        )
      )
  )
  (:action create_medication_package_pending_components
    :parameters (?patient_order - patient_order ?prescription_line - prescription_line ?storage_location - storage_location ?packaging_station - packaging_station ?medication_package - medication_package)
    :precondition
      (and
        (order_pick_in_progress ?patient_order)
        (prescription_line_pick_in_progress ?prescription_line)
        (order_assigned_storage_location ?patient_order ?storage_location)
        (prescription_line_assigned_packaging_station ?prescription_line ?packaging_station)
        (storage_location_material_selected ?storage_location)
        (packaging_station_marked ?packaging_station)
        (not
          (patient_order_pick_confirmed ?patient_order)
        )
        (prescription_line_ready_for_packaging ?prescription_line)
        (medication_package_creation_slot_available ?medication_package)
      )
    :effect
      (and
        (medication_package_created ?medication_package)
        (medication_package_assigned_storage_location ?medication_package ?storage_location)
        (medication_package_assigned_packaging_station ?medication_package ?packaging_station)
        (medication_package_requires_auxiliary_label ?medication_package)
        (not
          (medication_package_creation_slot_available ?medication_package)
        )
      )
  )
  (:action create_medication_package_pending_auxiliary_label
    :parameters (?patient_order - patient_order ?prescription_line - prescription_line ?storage_location - storage_location ?packaging_station - packaging_station ?medication_package - medication_package)
    :precondition
      (and
        (order_pick_in_progress ?patient_order)
        (prescription_line_pick_in_progress ?prescription_line)
        (order_assigned_storage_location ?patient_order ?storage_location)
        (prescription_line_assigned_packaging_station ?prescription_line ?packaging_station)
        (storage_location_earmarked_for_pick ?storage_location)
        (packaging_station_material_assigned ?packaging_station)
        (patient_order_pick_confirmed ?patient_order)
        (not
          (prescription_line_ready_for_packaging ?prescription_line)
        )
        (medication_package_creation_slot_available ?medication_package)
      )
    :effect
      (and
        (medication_package_created ?medication_package)
        (medication_package_assigned_storage_location ?medication_package ?storage_location)
        (medication_package_assigned_packaging_station ?medication_package ?packaging_station)
        (medication_package_requires_insurance_verification ?medication_package)
        (not
          (medication_package_creation_slot_available ?medication_package)
        )
      )
  )
  (:action create_medication_package_pending_all_components
    :parameters (?patient_order - patient_order ?prescription_line - prescription_line ?storage_location - storage_location ?packaging_station - packaging_station ?medication_package - medication_package)
    :precondition
      (and
        (order_pick_in_progress ?patient_order)
        (prescription_line_pick_in_progress ?prescription_line)
        (order_assigned_storage_location ?patient_order ?storage_location)
        (prescription_line_assigned_packaging_station ?prescription_line ?packaging_station)
        (storage_location_material_selected ?storage_location)
        (packaging_station_material_assigned ?packaging_station)
        (not
          (patient_order_pick_confirmed ?patient_order)
        )
        (not
          (prescription_line_ready_for_packaging ?prescription_line)
        )
        (medication_package_creation_slot_available ?medication_package)
      )
    :effect
      (and
        (medication_package_created ?medication_package)
        (medication_package_assigned_storage_location ?medication_package ?storage_location)
        (medication_package_assigned_packaging_station ?medication_package ?packaging_station)
        (medication_package_requires_auxiliary_label ?medication_package)
        (medication_package_requires_insurance_verification ?medication_package)
        (not
          (medication_package_creation_slot_available ?medication_package)
        )
      )
  )
  (:action confirm_package_ready_at_station
    :parameters (?medication_package - medication_package ?patient_order - patient_order ?clinical_resource - clinical_check_resource)
    :precondition
      (and
        (medication_package_created ?medication_package)
        (order_pick_in_progress ?patient_order)
        (order_assigned_clinical_resource ?patient_order ?clinical_resource)
        (not
          (medication_package_confirmed ?medication_package)
        )
      )
    :effect (medication_package_confirmed ?medication_package)
  )
  (:action attach_packaging_component_to_task
    :parameters (?dispensing_task - dispensing_task ?packaging_component - packaging_component ?medication_package - medication_package)
    :precondition
      (and
        (clinical_review_completed ?dispensing_task)
        (dispensing_task_associated_with_package ?dispensing_task ?medication_package)
        (dispensing_task_attached_component ?dispensing_task ?packaging_component)
        (packaging_component_available ?packaging_component)
        (medication_package_created ?medication_package)
        (medication_package_confirmed ?medication_package)
        (not
          (packaging_component_attached ?packaging_component)
        )
      )
    :effect
      (and
        (packaging_component_attached ?packaging_component)
        (component_attached_to_package ?packaging_component ?medication_package)
        (not
          (packaging_component_available ?packaging_component)
        )
      )
  )
  (:action verify_packaging_component_and_mark_task
    :parameters (?dispensing_task - dispensing_task ?packaging_component - packaging_component ?medication_package - medication_package ?clinical_resource - clinical_check_resource)
    :precondition
      (and
        (clinical_review_completed ?dispensing_task)
        (dispensing_task_attached_component ?dispensing_task ?packaging_component)
        (packaging_component_attached ?packaging_component)
        (component_attached_to_package ?packaging_component ?medication_package)
        (order_assigned_clinical_resource ?dispensing_task ?clinical_resource)
        (not
          (medication_package_requires_auxiliary_label ?medication_package)
        )
        (not
          (dispensing_task_lot_verified ?dispensing_task)
        )
      )
    :effect (dispensing_task_lot_verified ?dispensing_task)
  )
  (:action assign_auxiliary_label_to_task
    :parameters (?dispensing_task - dispensing_task ?auxiliary_label - auxiliary_label)
    :precondition
      (and
        (clinical_review_completed ?dispensing_task)
        (auxiliary_label_available ?auxiliary_label)
        (not
          (auxiliary_label_attached ?dispensing_task)
        )
      )
    :effect
      (and
        (auxiliary_label_attached ?dispensing_task)
        (dispensing_task_auxiliary_label_assigned ?dispensing_task ?auxiliary_label)
        (not
          (auxiliary_label_available ?auxiliary_label)
        )
      )
  )
  (:action attach_auxiliary_label_and_verify_component
    :parameters (?dispensing_task - dispensing_task ?packaging_component - packaging_component ?medication_package - medication_package ?clinical_resource - clinical_check_resource ?auxiliary_label - auxiliary_label)
    :precondition
      (and
        (clinical_review_completed ?dispensing_task)
        (dispensing_task_attached_component ?dispensing_task ?packaging_component)
        (packaging_component_attached ?packaging_component)
        (component_attached_to_package ?packaging_component ?medication_package)
        (order_assigned_clinical_resource ?dispensing_task ?clinical_resource)
        (medication_package_requires_auxiliary_label ?medication_package)
        (auxiliary_label_attached ?dispensing_task)
        (dispensing_task_auxiliary_label_assigned ?dispensing_task ?auxiliary_label)
        (not
          (dispensing_task_lot_verified ?dispensing_task)
        )
      )
    :effect
      (and
        (dispensing_task_lot_verified ?dispensing_task)
        (auxiliary_label_verified ?dispensing_task)
      )
  )
  (:action finalize_component_attachment_with_lot_and_pharmacist_check
    :parameters (?dispensing_task - dispensing_task ?lot_information - lot_information ?pharmacist - authorizing_pharmacist ?packaging_component - packaging_component ?medication_package - medication_package)
    :precondition
      (and
        (dispensing_task_lot_verified ?dispensing_task)
        (dispensing_task_assigned_lot_information ?dispensing_task ?lot_information)
        (order_assigned_pharmacist ?dispensing_task ?pharmacist)
        (dispensing_task_attached_component ?dispensing_task ?packaging_component)
        (component_attached_to_package ?packaging_component ?medication_package)
        (not
          (medication_package_requires_insurance_verification ?medication_package)
        )
        (not
          (dispensing_task_component_verified ?dispensing_task)
        )
      )
    :effect (dispensing_task_component_verified ?dispensing_task)
  )
  (:action finalize_component_attachment_with_lot_and_pharmacist_review
    :parameters (?dispensing_task - dispensing_task ?lot_information - lot_information ?pharmacist - authorizing_pharmacist ?packaging_component - packaging_component ?medication_package - medication_package)
    :precondition
      (and
        (dispensing_task_lot_verified ?dispensing_task)
        (dispensing_task_assigned_lot_information ?dispensing_task ?lot_information)
        (order_assigned_pharmacist ?dispensing_task ?pharmacist)
        (dispensing_task_attached_component ?dispensing_task ?packaging_component)
        (component_attached_to_package ?packaging_component ?medication_package)
        (medication_package_requires_insurance_verification ?medication_package)
        (not
          (dispensing_task_component_verified ?dispensing_task)
        )
      )
    :effect (dispensing_task_component_verified ?dispensing_task)
  )
  (:action start_clinical_approval_verification
    :parameters (?dispensing_task - dispensing_task ?clinical_approval - clinical_approval_record ?packaging_component - packaging_component ?medication_package - medication_package)
    :precondition
      (and
        (dispensing_task_component_verified ?dispensing_task)
        (dispensing_task_assigned_clinical_approval ?dispensing_task ?clinical_approval)
        (dispensing_task_attached_component ?dispensing_task ?packaging_component)
        (component_attached_to_package ?packaging_component ?medication_package)
        (not
          (medication_package_requires_auxiliary_label ?medication_package)
        )
        (not
          (medication_package_requires_insurance_verification ?medication_package)
        )
        (not
          (dispensing_task_ready_for_final_verification ?dispensing_task)
        )
      )
    :effect (dispensing_task_ready_for_final_verification ?dispensing_task)
  )
  (:action complete_clinical_approval_and_mark_components
    :parameters (?dispensing_task - dispensing_task ?clinical_approval - clinical_approval_record ?packaging_component - packaging_component ?medication_package - medication_package)
    :precondition
      (and
        (dispensing_task_component_verified ?dispensing_task)
        (dispensing_task_assigned_clinical_approval ?dispensing_task ?clinical_approval)
        (dispensing_task_attached_component ?dispensing_task ?packaging_component)
        (component_attached_to_package ?packaging_component ?medication_package)
        (medication_package_requires_auxiliary_label ?medication_package)
        (not
          (medication_package_requires_insurance_verification ?medication_package)
        )
        (not
          (dispensing_task_ready_for_final_verification ?dispensing_task)
        )
      )
    :effect
      (and
        (dispensing_task_ready_for_final_verification ?dispensing_task)
        (dispensing_task_requires_outbound_instruction ?dispensing_task)
      )
  )
  (:action complete_clinical_approval_secondary_flow
    :parameters (?dispensing_task - dispensing_task ?clinical_approval - clinical_approval_record ?packaging_component - packaging_component ?medication_package - medication_package)
    :precondition
      (and
        (dispensing_task_component_verified ?dispensing_task)
        (dispensing_task_assigned_clinical_approval ?dispensing_task ?clinical_approval)
        (dispensing_task_attached_component ?dispensing_task ?packaging_component)
        (component_attached_to_package ?packaging_component ?medication_package)
        (not
          (medication_package_requires_auxiliary_label ?medication_package)
        )
        (medication_package_requires_insurance_verification ?medication_package)
        (not
          (dispensing_task_ready_for_final_verification ?dispensing_task)
        )
      )
    :effect
      (and
        (dispensing_task_ready_for_final_verification ?dispensing_task)
        (dispensing_task_requires_outbound_instruction ?dispensing_task)
      )
  )
  (:action complete_clinical_approval_final_flow
    :parameters (?dispensing_task - dispensing_task ?clinical_approval - clinical_approval_record ?packaging_component - packaging_component ?medication_package - medication_package)
    :precondition
      (and
        (dispensing_task_component_verified ?dispensing_task)
        (dispensing_task_assigned_clinical_approval ?dispensing_task ?clinical_approval)
        (dispensing_task_attached_component ?dispensing_task ?packaging_component)
        (component_attached_to_package ?packaging_component ?medication_package)
        (medication_package_requires_auxiliary_label ?medication_package)
        (medication_package_requires_insurance_verification ?medication_package)
        (not
          (dispensing_task_ready_for_final_verification ?dispensing_task)
        )
      )
    :effect
      (and
        (dispensing_task_ready_for_final_verification ?dispensing_task)
        (dispensing_task_requires_outbound_instruction ?dispensing_task)
      )
  )
  (:action perform_final_task_verification
    :parameters (?dispensing_task - dispensing_task)
    :precondition
      (and
        (dispensing_task_ready_for_final_verification ?dispensing_task)
        (not
          (dispensing_task_requires_outbound_instruction ?dispensing_task)
        )
        (not
          (dispensing_task_finalized ?dispensing_task)
        )
      )
    :effect
      (and
        (dispensing_task_finalized ?dispensing_task)
        (ready_for_authorization ?dispensing_task)
      )
  )
  (:action attach_instruction_template_to_task
    :parameters (?dispensing_task - dispensing_task ?instruction_template - outbound_instruction_template)
    :precondition
      (and
        (dispensing_task_ready_for_final_verification ?dispensing_task)
        (dispensing_task_requires_outbound_instruction ?dispensing_task)
        (instruction_template_available ?instruction_template)
      )
    :effect
      (and
        (dispensing_task_assigned_instruction_template ?dispensing_task ?instruction_template)
        (not
          (instruction_template_available ?instruction_template)
        )
      )
  )
  (:action perform_final_verification_checks
    :parameters (?dispensing_task - dispensing_task ?patient_order - patient_order ?prescription_line - prescription_line ?clinical_resource - clinical_check_resource ?instruction_template - outbound_instruction_template)
    :precondition
      (and
        (dispensing_task_ready_for_final_verification ?dispensing_task)
        (dispensing_task_requires_outbound_instruction ?dispensing_task)
        (dispensing_task_assigned_instruction_template ?dispensing_task ?instruction_template)
        (dispensing_task_assigned_to_patient_order ?dispensing_task ?patient_order)
        (dispensing_task_assigned_to_prescription_line ?dispensing_task ?prescription_line)
        (patient_order_pick_confirmed ?patient_order)
        (prescription_line_ready_for_packaging ?prescription_line)
        (order_assigned_clinical_resource ?dispensing_task ?clinical_resource)
        (not
          (dispensing_task_quality_verified ?dispensing_task)
        )
      )
    :effect (dispensing_task_quality_verified ?dispensing_task)
  )
  (:action finalize_dispensing_task
    :parameters (?dispensing_task - dispensing_task)
    :precondition
      (and
        (dispensing_task_ready_for_final_verification ?dispensing_task)
        (dispensing_task_quality_verified ?dispensing_task)
        (not
          (dispensing_task_finalized ?dispensing_task)
        )
      )
    :effect
      (and
        (dispensing_task_finalized ?dispensing_task)
        (ready_for_authorization ?dispensing_task)
      )
  )
  (:action claim_insurance_authorization_for_task
    :parameters (?dispensing_task - dispensing_task ?insurance_authorization - insurance_authorization_record ?clinical_resource - clinical_check_resource)
    :precondition
      (and
        (clinical_review_completed ?dispensing_task)
        (order_assigned_clinical_resource ?dispensing_task ?clinical_resource)
        (insurance_authorization_available ?insurance_authorization)
        (dispensing_task_insurance_authorization_link ?dispensing_task ?insurance_authorization)
        (not
          (task_claimed_insurance_authorization ?dispensing_task)
        )
      )
    :effect
      (and
        (task_claimed_insurance_authorization ?dispensing_task)
        (not
          (insurance_authorization_available ?insurance_authorization)
        )
      )
  )
  (:action confirm_insurance_authorization_with_pharmacist
    :parameters (?dispensing_task - dispensing_task ?pharmacist - authorizing_pharmacist)
    :precondition
      (and
        (task_claimed_insurance_authorization ?dispensing_task)
        (order_assigned_pharmacist ?dispensing_task ?pharmacist)
        (not
          (insurance_authorization_confirmed_for_task ?dispensing_task)
        )
      )
    :effect (insurance_authorization_confirmed_for_task ?dispensing_task)
  )
  (:action record_clinical_approval_for_task
    :parameters (?dispensing_task - dispensing_task ?clinical_approval - clinical_approval_record)
    :precondition
      (and
        (insurance_authorization_confirmed_for_task ?dispensing_task)
        (dispensing_task_assigned_clinical_approval ?dispensing_task ?clinical_approval)
        (not
          (insurance_authorization_verified_for_task ?dispensing_task)
        )
      )
    :effect (insurance_authorization_verified_for_task ?dispensing_task)
  )
  (:action finalize_after_insurance_authorization
    :parameters (?dispensing_task - dispensing_task)
    :precondition
      (and
        (insurance_authorization_verified_for_task ?dispensing_task)
        (not
          (dispensing_task_finalized ?dispensing_task)
        )
      )
    :effect
      (and
        (dispensing_task_finalized ?dispensing_task)
        (ready_for_authorization ?dispensing_task)
      )
  )
  (:action mark_order_ready_for_instruction_generation
    :parameters (?patient_order - patient_order ?medication_package - medication_package)
    :precondition
      (and
        (order_pick_in_progress ?patient_order)
        (patient_order_pick_confirmed ?patient_order)
        (medication_package_created ?medication_package)
        (medication_package_confirmed ?medication_package)
        (not
          (ready_for_authorization ?patient_order)
        )
      )
    :effect (ready_for_authorization ?patient_order)
  )
  (:action mark_prescription_line_ready_for_instruction_generation
    :parameters (?prescription_line - prescription_line ?medication_package - medication_package)
    :precondition
      (and
        (prescription_line_pick_in_progress ?prescription_line)
        (prescription_line_ready_for_packaging ?prescription_line)
        (medication_package_created ?medication_package)
        (medication_package_confirmed ?medication_package)
        (not
          (ready_for_authorization ?prescription_line)
        )
      )
    :effect (ready_for_authorization ?prescription_line)
  )
  (:action generate_patient_instruction_and_authorize_dispense
    :parameters (?order - order_entity ?patient_instruction - patient_instruction ?clinical_resource - clinical_check_resource)
    :precondition
      (and
        (ready_for_authorization ?order)
        (order_assigned_clinical_resource ?order ?clinical_resource)
        (patient_instruction_available ?patient_instruction)
        (not
          (dispense_authorization_granted ?order)
        )
      )
    :effect
      (and
        (dispense_authorization_granted ?order)
        (order_associated_patient_instruction ?order ?patient_instruction)
        (not
          (patient_instruction_available ?patient_instruction)
        )
      )
  )
  (:action finalize_dispense_and_update_inventory_for_order
    :parameters (?patient_order - patient_order ?inventory_unit - inventory_unit ?patient_instruction - patient_instruction)
    :precondition
      (and
        (dispense_authorization_granted ?patient_order)
        (order_reserved_inventory ?patient_order ?inventory_unit)
        (order_associated_patient_instruction ?patient_order ?patient_instruction)
        (not
          (stock_released ?patient_order)
        )
      )
    :effect
      (and
        (stock_released ?patient_order)
        (inventory_available ?inventory_unit)
        (patient_instruction_available ?patient_instruction)
      )
  )
  (:action finalize_dispense_and_update_inventory_for_line
    :parameters (?prescription_line - prescription_line ?inventory_unit - inventory_unit ?patient_instruction - patient_instruction)
    :precondition
      (and
        (dispense_authorization_granted ?prescription_line)
        (order_reserved_inventory ?prescription_line ?inventory_unit)
        (order_associated_patient_instruction ?prescription_line ?patient_instruction)
        (not
          (stock_released ?prescription_line)
        )
      )
    :effect
      (and
        (stock_released ?prescription_line)
        (inventory_available ?inventory_unit)
        (patient_instruction_available ?patient_instruction)
      )
  )
  (:action finalize_dispense_and_update_inventory_for_task
    :parameters (?dispensing_task - dispensing_task ?inventory_unit - inventory_unit ?patient_instruction - patient_instruction)
    :precondition
      (and
        (dispense_authorization_granted ?dispensing_task)
        (order_reserved_inventory ?dispensing_task ?inventory_unit)
        (order_associated_patient_instruction ?dispensing_task ?patient_instruction)
        (not
          (stock_released ?dispensing_task)
        )
      )
    :effect
      (and
        (stock_released ?dispensing_task)
        (inventory_available ?inventory_unit)
        (patient_instruction_available ?patient_instruction)
      )
  )
)

(define (domain cold_storage_medicine_dispense_readiness)
  (:requirements :strips :typing :negative-preconditions)
  (:types inventory_asset - object component_resource_group - object logistics_resource_group - object order_category - object medication_order - order_category drug_product - inventory_asset selected_drug_variant - inventory_asset pharmacy_technician - inventory_asset safety_check_item - inventory_asset patient_instruction_template - inventory_asset release_authorization_token - inventory_asset packaging_device - inventory_asset temperature_monitoring_device - inventory_asset substitution_option - component_resource_group package_label_template - component_resource_group clinical_priority_code - component_resource_group cold_storage_slot - logistics_resource_group fulfillment_slot - logistics_resource_group dispensing_container - logistics_resource_group order_patient_group - medication_order order_dispense_group - medication_order refrigerated_medication_order - order_patient_group frozen_medication_order - order_patient_group dispense_batch - order_dispense_group)
  (:predicates
    (order_registered ?medication_order - medication_order)
    (medication_selection_confirmed ?medication_order - medication_order)
    (product_allocated ?medication_order - medication_order)
    (order_ready_for_release ?medication_order - medication_order)
    (order_final_verification_complete ?medication_order - medication_order)
    (order_authorized ?medication_order - medication_order)
    (product_available ?drug_product - drug_product)
    (order_allocated_product ?medication_order - medication_order ?drug_product - drug_product)
    (variant_available ?selected_drug_variant - selected_drug_variant)
    (order_selected_variant ?medication_order - medication_order ?selected_drug_variant - selected_drug_variant)
    (staff_available ?staff_member - pharmacy_technician)
    (order_assigned_to_staff ?medication_order - medication_order ?staff_member - pharmacy_technician)
    (substitution_option_available ?substitution_option - substitution_option)
    (refrigerated_order_substitution_assigned ?refrigerated_medication_order - refrigerated_medication_order ?substitution_option - substitution_option)
    (frozen_order_substitution_assigned ?frozen_medication_order - frozen_medication_order ?substitution_option - substitution_option)
    (order_assigned_cold_slot ?refrigerated_medication_order - refrigerated_medication_order ?cold_storage_slot - cold_storage_slot)
    (cold_slot_reserved ?cold_storage_slot - cold_storage_slot)
    (cold_slot_reserved_for_substitution ?cold_storage_slot - cold_storage_slot)
    (refrigerated_slot_confirmed ?refrigerated_medication_order - refrigerated_medication_order)
    (order_assigned_fulfillment_slot ?frozen_medication_order - frozen_medication_order ?fulfillment_slot - fulfillment_slot)
    (fulfillment_slot_reserved ?fulfillment_slot - fulfillment_slot)
    (fulfillment_slot_reserved_for_substitution ?fulfillment_slot - fulfillment_slot)
    (frozen_slot_confirmed ?frozen_medication_order - frozen_medication_order)
    (dispensing_container_available ?dispensing_container - dispensing_container)
    (dispensing_container_staged ?dispensing_container - dispensing_container)
    (dispensing_container_assigned_to_cold_slot ?dispensing_container - dispensing_container ?cold_storage_slot - cold_storage_slot)
    (dispensing_container_assigned_to_fulfillment_slot ?dispensing_container - dispensing_container ?fulfillment_slot - fulfillment_slot)
    (dispensing_container_requires_safety_check ?dispensing_container - dispensing_container)
    (dispensing_container_alternate_packaging_route ?dispensing_container - dispensing_container)
    (dispensing_container_ready_for_labeling ?dispensing_container - dispensing_container)
    (batch_contains_refrigerated_order ?dispense_batch - dispense_batch ?refrigerated_medication_order - refrigerated_medication_order)
    (batch_contains_frozen_order ?dispense_batch - dispense_batch ?frozen_medication_order - frozen_medication_order)
    (batch_assigned_container ?dispense_batch - dispense_batch ?dispensing_container - dispensing_container)
    (label_template_available ?package_label_template - package_label_template)
    (batch_assigned_label_template ?dispense_batch - dispense_batch ?package_label_template - package_label_template)
    (label_template_staged ?package_label_template - package_label_template)
    (label_template_assigned_to_dispensing_container ?package_label_template - package_label_template ?dispensing_container - dispensing_container)
    (packaging_device_assigned ?dispense_batch - dispense_batch)
    (packaging_operation_performed ?dispense_batch - dispense_batch)
    (packaging_steps_completed ?dispense_batch - dispense_batch)
    (safety_check_assigned_to_batch ?dispense_batch - dispense_batch)
    (safety_check_completed_for_batch ?dispense_batch - dispense_batch)
    (labeling_complete_for_batch ?dispense_batch - dispense_batch)
    (packaging_qc_passed ?dispense_batch - dispense_batch)
    (priority_code_available ?clinical_priority_code - clinical_priority_code)
    (batch_assigned_priority_code ?dispense_batch - dispense_batch ?clinical_priority_code - clinical_priority_code)
    (priority_applied_to_batch ?dispense_batch - dispense_batch)
    (priority_handling_confirmed ?dispense_batch - dispense_batch)
    (temperature_monitoring_attached ?dispense_batch - dispense_batch)
    (safety_check_item_available ?safety_check_item - safety_check_item)
    (batch_assigned_safety_check_item ?dispense_batch - dispense_batch ?safety_check_item - safety_check_item)
    (instruction_template_available ?patient_instruction_template - patient_instruction_template)
    (batch_assigned_instruction_template ?dispense_batch - dispense_batch ?patient_instruction_template - patient_instruction_template)
    (packaging_device_available ?packaging_device - packaging_device)
    (batch_has_packaging_device_bound ?dispense_batch - dispense_batch ?packaging_device - packaging_device)
    (temperature_monitoring_device_available ?temperature_monitoring_device - temperature_monitoring_device)
    (batch_has_temperature_monitor_bound ?dispense_batch - dispense_batch ?temperature_monitoring_device - temperature_monitoring_device)
    (release_authorization_token_available ?release_authorization_token - release_authorization_token)
    (order_assigned_release_authorization ?medication_order - medication_order ?release_authorization_token - release_authorization_token)
    (refrigerated_order_packaging_ready ?refrigerated_medication_order - refrigerated_medication_order)
    (frozen_order_packaging_ready ?frozen_medication_order - frozen_medication_order)
    (batch_finalized_for_release ?dispense_batch - dispense_batch)
  )
  (:action register_medication_order
    :parameters (?medication_order - medication_order)
    :precondition
      (and
        (not
          (order_registered ?medication_order)
        )
        (not
          (order_ready_for_release ?medication_order)
        )
      )
    :effect (order_registered ?medication_order)
  )
  (:action allocate_drug_product_to_order
    :parameters (?medication_order - medication_order ?drug_product - drug_product)
    :precondition
      (and
        (order_registered ?medication_order)
        (not
          (product_allocated ?medication_order)
        )
        (product_available ?drug_product)
      )
    :effect
      (and
        (product_allocated ?medication_order)
        (order_allocated_product ?medication_order ?drug_product)
        (not
          (product_available ?drug_product)
        )
      )
  )
  (:action select_drug_variant_for_order
    :parameters (?medication_order - medication_order ?selected_drug_variant - selected_drug_variant)
    :precondition
      (and
        (order_registered ?medication_order)
        (product_allocated ?medication_order)
        (variant_available ?selected_drug_variant)
      )
    :effect
      (and
        (order_selected_variant ?medication_order ?selected_drug_variant)
        (not
          (variant_available ?selected_drug_variant)
        )
      )
  )
  (:action confirm_medication_selection_for_order
    :parameters (?medication_order - medication_order ?selected_drug_variant - selected_drug_variant)
    :precondition
      (and
        (order_registered ?medication_order)
        (product_allocated ?medication_order)
        (order_selected_variant ?medication_order ?selected_drug_variant)
        (not
          (medication_selection_confirmed ?medication_order)
        )
      )
    :effect (medication_selection_confirmed ?medication_order)
  )
  (:action revert_selected_drug_variant_for_order
    :parameters (?medication_order - medication_order ?selected_drug_variant - selected_drug_variant)
    :precondition
      (and
        (order_selected_variant ?medication_order ?selected_drug_variant)
      )
    :effect
      (and
        (variant_available ?selected_drug_variant)
        (not
          (order_selected_variant ?medication_order ?selected_drug_variant)
        )
      )
  )
  (:action assign_staff_verifier_to_order
    :parameters (?medication_order - medication_order ?staff_member - pharmacy_technician)
    :precondition
      (and
        (medication_selection_confirmed ?medication_order)
        (staff_available ?staff_member)
      )
    :effect
      (and
        (order_assigned_to_staff ?medication_order ?staff_member)
        (not
          (staff_available ?staff_member)
        )
      )
  )
  (:action unassign_staff_verifier_from_order
    :parameters (?medication_order - medication_order ?staff_member - pharmacy_technician)
    :precondition
      (and
        (order_assigned_to_staff ?medication_order ?staff_member)
      )
    :effect
      (and
        (staff_available ?staff_member)
        (not
          (order_assigned_to_staff ?medication_order ?staff_member)
        )
      )
  )
  (:action bind_packaging_device_to_batch
    :parameters (?dispense_batch - dispense_batch ?packaging_device - packaging_device)
    :precondition
      (and
        (medication_selection_confirmed ?dispense_batch)
        (packaging_device_available ?packaging_device)
      )
    :effect
      (and
        (batch_has_packaging_device_bound ?dispense_batch ?packaging_device)
        (not
          (packaging_device_available ?packaging_device)
        )
      )
  )
  (:action unbind_packaging_device_from_batch
    :parameters (?dispense_batch - dispense_batch ?packaging_device - packaging_device)
    :precondition
      (and
        (batch_has_packaging_device_bound ?dispense_batch ?packaging_device)
      )
    :effect
      (and
        (packaging_device_available ?packaging_device)
        (not
          (batch_has_packaging_device_bound ?dispense_batch ?packaging_device)
        )
      )
  )
  (:action bind_temperature_monitor_to_batch
    :parameters (?dispense_batch - dispense_batch ?temperature_monitoring_device - temperature_monitoring_device)
    :precondition
      (and
        (medication_selection_confirmed ?dispense_batch)
        (temperature_monitoring_device_available ?temperature_monitoring_device)
      )
    :effect
      (and
        (batch_has_temperature_monitor_bound ?dispense_batch ?temperature_monitoring_device)
        (not
          (temperature_monitoring_device_available ?temperature_monitoring_device)
        )
      )
  )
  (:action unbind_temperature_monitor_from_batch
    :parameters (?dispense_batch - dispense_batch ?temperature_monitoring_device - temperature_monitoring_device)
    :precondition
      (and
        (batch_has_temperature_monitor_bound ?dispense_batch ?temperature_monitoring_device)
      )
    :effect
      (and
        (temperature_monitoring_device_available ?temperature_monitoring_device)
        (not
          (batch_has_temperature_monitor_bound ?dispense_batch ?temperature_monitoring_device)
        )
      )
  )
  (:action reserve_cold_storage_slot_for_order
    :parameters (?refrigerated_medication_order - refrigerated_medication_order ?cold_storage_slot - cold_storage_slot ?selected_drug_variant - selected_drug_variant)
    :precondition
      (and
        (medication_selection_confirmed ?refrigerated_medication_order)
        (order_selected_variant ?refrigerated_medication_order ?selected_drug_variant)
        (order_assigned_cold_slot ?refrigerated_medication_order ?cold_storage_slot)
        (not
          (cold_slot_reserved ?cold_storage_slot)
        )
        (not
          (cold_slot_reserved_for_substitution ?cold_storage_slot)
        )
      )
    :effect (cold_slot_reserved ?cold_storage_slot)
  )
  (:action staff_confirm_cold_storage_reservation
    :parameters (?refrigerated_medication_order - refrigerated_medication_order ?cold_storage_slot - cold_storage_slot ?staff_member - pharmacy_technician)
    :precondition
      (and
        (medication_selection_confirmed ?refrigerated_medication_order)
        (order_assigned_to_staff ?refrigerated_medication_order ?staff_member)
        (order_assigned_cold_slot ?refrigerated_medication_order ?cold_storage_slot)
        (cold_slot_reserved ?cold_storage_slot)
        (not
          (refrigerated_order_packaging_ready ?refrigerated_medication_order)
        )
      )
    :effect
      (and
        (refrigerated_order_packaging_ready ?refrigerated_medication_order)
        (refrigerated_slot_confirmed ?refrigerated_medication_order)
      )
  )
  (:action assign_substitution_and_mark_slot
    :parameters (?refrigerated_medication_order - refrigerated_medication_order ?cold_storage_slot - cold_storage_slot ?substitution_option - substitution_option)
    :precondition
      (and
        (medication_selection_confirmed ?refrigerated_medication_order)
        (order_assigned_cold_slot ?refrigerated_medication_order ?cold_storage_slot)
        (substitution_option_available ?substitution_option)
        (not
          (refrigerated_order_packaging_ready ?refrigerated_medication_order)
        )
      )
    :effect
      (and
        (cold_slot_reserved_for_substitution ?cold_storage_slot)
        (refrigerated_order_packaging_ready ?refrigerated_medication_order)
        (refrigerated_order_substitution_assigned ?refrigerated_medication_order ?substitution_option)
        (not
          (substitution_option_available ?substitution_option)
        )
      )
  )
  (:action apply_substitution_and_confirm_slot
    :parameters (?refrigerated_medication_order - refrigerated_medication_order ?cold_storage_slot - cold_storage_slot ?selected_drug_variant - selected_drug_variant ?substitution_option - substitution_option)
    :precondition
      (and
        (medication_selection_confirmed ?refrigerated_medication_order)
        (order_selected_variant ?refrigerated_medication_order ?selected_drug_variant)
        (order_assigned_cold_slot ?refrigerated_medication_order ?cold_storage_slot)
        (cold_slot_reserved_for_substitution ?cold_storage_slot)
        (refrigerated_order_substitution_assigned ?refrigerated_medication_order ?substitution_option)
        (not
          (refrigerated_slot_confirmed ?refrigerated_medication_order)
        )
      )
    :effect
      (and
        (cold_slot_reserved ?cold_storage_slot)
        (refrigerated_slot_confirmed ?refrigerated_medication_order)
        (substitution_option_available ?substitution_option)
        (not
          (refrigerated_order_substitution_assigned ?refrigerated_medication_order ?substitution_option)
        )
      )
  )
  (:action reserve_fulfillment_slot_for_frozen_order
    :parameters (?frozen_medication_order - frozen_medication_order ?fulfillment_slot - fulfillment_slot ?selected_drug_variant - selected_drug_variant)
    :precondition
      (and
        (medication_selection_confirmed ?frozen_medication_order)
        (order_selected_variant ?frozen_medication_order ?selected_drug_variant)
        (order_assigned_fulfillment_slot ?frozen_medication_order ?fulfillment_slot)
        (not
          (fulfillment_slot_reserved ?fulfillment_slot)
        )
        (not
          (fulfillment_slot_reserved_for_substitution ?fulfillment_slot)
        )
      )
    :effect (fulfillment_slot_reserved ?fulfillment_slot)
  )
  (:action staff_confirm_fulfillment_reservation
    :parameters (?frozen_medication_order - frozen_medication_order ?fulfillment_slot - fulfillment_slot ?staff_member - pharmacy_technician)
    :precondition
      (and
        (medication_selection_confirmed ?frozen_medication_order)
        (order_assigned_to_staff ?frozen_medication_order ?staff_member)
        (order_assigned_fulfillment_slot ?frozen_medication_order ?fulfillment_slot)
        (fulfillment_slot_reserved ?fulfillment_slot)
        (not
          (frozen_order_packaging_ready ?frozen_medication_order)
        )
      )
    :effect
      (and
        (frozen_order_packaging_ready ?frozen_medication_order)
        (frozen_slot_confirmed ?frozen_medication_order)
      )
  )
  (:action assign_substitution_to_fulfillment
    :parameters (?frozen_medication_order - frozen_medication_order ?fulfillment_slot - fulfillment_slot ?substitution_option - substitution_option)
    :precondition
      (and
        (medication_selection_confirmed ?frozen_medication_order)
        (order_assigned_fulfillment_slot ?frozen_medication_order ?fulfillment_slot)
        (substitution_option_available ?substitution_option)
        (not
          (frozen_order_packaging_ready ?frozen_medication_order)
        )
      )
    :effect
      (and
        (fulfillment_slot_reserved_for_substitution ?fulfillment_slot)
        (frozen_order_packaging_ready ?frozen_medication_order)
        (frozen_order_substitution_assigned ?frozen_medication_order ?substitution_option)
        (not
          (substitution_option_available ?substitution_option)
        )
      )
  )
  (:action apply_substitution_and_confirm_fulfillment
    :parameters (?frozen_medication_order - frozen_medication_order ?fulfillment_slot - fulfillment_slot ?selected_drug_variant - selected_drug_variant ?substitution_option - substitution_option)
    :precondition
      (and
        (medication_selection_confirmed ?frozen_medication_order)
        (order_selected_variant ?frozen_medication_order ?selected_drug_variant)
        (order_assigned_fulfillment_slot ?frozen_medication_order ?fulfillment_slot)
        (fulfillment_slot_reserved_for_substitution ?fulfillment_slot)
        (frozen_order_substitution_assigned ?frozen_medication_order ?substitution_option)
        (not
          (frozen_slot_confirmed ?frozen_medication_order)
        )
      )
    :effect
      (and
        (fulfillment_slot_reserved ?fulfillment_slot)
        (frozen_slot_confirmed ?frozen_medication_order)
        (substitution_option_available ?substitution_option)
        (not
          (frozen_order_substitution_assigned ?frozen_medication_order ?substitution_option)
        )
      )
  )
  (:action allocate_container_and_bind_slots_for_batch
    :parameters (?refrigerated_medication_order - refrigerated_medication_order ?frozen_medication_order - frozen_medication_order ?cold_storage_slot - cold_storage_slot ?fulfillment_slot - fulfillment_slot ?dispensing_container - dispensing_container)
    :precondition
      (and
        (refrigerated_order_packaging_ready ?refrigerated_medication_order)
        (frozen_order_packaging_ready ?frozen_medication_order)
        (order_assigned_cold_slot ?refrigerated_medication_order ?cold_storage_slot)
        (order_assigned_fulfillment_slot ?frozen_medication_order ?fulfillment_slot)
        (cold_slot_reserved ?cold_storage_slot)
        (fulfillment_slot_reserved ?fulfillment_slot)
        (refrigerated_slot_confirmed ?refrigerated_medication_order)
        (frozen_slot_confirmed ?frozen_medication_order)
        (dispensing_container_available ?dispensing_container)
      )
    :effect
      (and
        (dispensing_container_staged ?dispensing_container)
        (dispensing_container_assigned_to_cold_slot ?dispensing_container ?cold_storage_slot)
        (dispensing_container_assigned_to_fulfillment_slot ?dispensing_container ?fulfillment_slot)
        (not
          (dispensing_container_available ?dispensing_container)
        )
      )
  )
  (:action allocate_container_with_safety_check_route
    :parameters (?refrigerated_medication_order - refrigerated_medication_order ?frozen_medication_order - frozen_medication_order ?cold_storage_slot - cold_storage_slot ?fulfillment_slot - fulfillment_slot ?dispensing_container - dispensing_container)
    :precondition
      (and
        (refrigerated_order_packaging_ready ?refrigerated_medication_order)
        (frozen_order_packaging_ready ?frozen_medication_order)
        (order_assigned_cold_slot ?refrigerated_medication_order ?cold_storage_slot)
        (order_assigned_fulfillment_slot ?frozen_medication_order ?fulfillment_slot)
        (cold_slot_reserved_for_substitution ?cold_storage_slot)
        (fulfillment_slot_reserved ?fulfillment_slot)
        (not
          (refrigerated_slot_confirmed ?refrigerated_medication_order)
        )
        (frozen_slot_confirmed ?frozen_medication_order)
        (dispensing_container_available ?dispensing_container)
      )
    :effect
      (and
        (dispensing_container_staged ?dispensing_container)
        (dispensing_container_assigned_to_cold_slot ?dispensing_container ?cold_storage_slot)
        (dispensing_container_assigned_to_fulfillment_slot ?dispensing_container ?fulfillment_slot)
        (dispensing_container_requires_safety_check ?dispensing_container)
        (not
          (dispensing_container_available ?dispensing_container)
        )
      )
  )
  (:action allocate_container_with_alternate_packaging_route
    :parameters (?refrigerated_medication_order - refrigerated_medication_order ?frozen_medication_order - frozen_medication_order ?cold_storage_slot - cold_storage_slot ?fulfillment_slot - fulfillment_slot ?dispensing_container - dispensing_container)
    :precondition
      (and
        (refrigerated_order_packaging_ready ?refrigerated_medication_order)
        (frozen_order_packaging_ready ?frozen_medication_order)
        (order_assigned_cold_slot ?refrigerated_medication_order ?cold_storage_slot)
        (order_assigned_fulfillment_slot ?frozen_medication_order ?fulfillment_slot)
        (cold_slot_reserved ?cold_storage_slot)
        (fulfillment_slot_reserved_for_substitution ?fulfillment_slot)
        (refrigerated_slot_confirmed ?refrigerated_medication_order)
        (not
          (frozen_slot_confirmed ?frozen_medication_order)
        )
        (dispensing_container_available ?dispensing_container)
      )
    :effect
      (and
        (dispensing_container_staged ?dispensing_container)
        (dispensing_container_assigned_to_cold_slot ?dispensing_container ?cold_storage_slot)
        (dispensing_container_assigned_to_fulfillment_slot ?dispensing_container ?fulfillment_slot)
        (dispensing_container_alternate_packaging_route ?dispensing_container)
        (not
          (dispensing_container_available ?dispensing_container)
        )
      )
  )
  (:action allocate_container_with_combined_packaging_routes
    :parameters (?refrigerated_medication_order - refrigerated_medication_order ?frozen_medication_order - frozen_medication_order ?cold_storage_slot - cold_storage_slot ?fulfillment_slot - fulfillment_slot ?dispensing_container - dispensing_container)
    :precondition
      (and
        (refrigerated_order_packaging_ready ?refrigerated_medication_order)
        (frozen_order_packaging_ready ?frozen_medication_order)
        (order_assigned_cold_slot ?refrigerated_medication_order ?cold_storage_slot)
        (order_assigned_fulfillment_slot ?frozen_medication_order ?fulfillment_slot)
        (cold_slot_reserved_for_substitution ?cold_storage_slot)
        (fulfillment_slot_reserved_for_substitution ?fulfillment_slot)
        (not
          (refrigerated_slot_confirmed ?refrigerated_medication_order)
        )
        (not
          (frozen_slot_confirmed ?frozen_medication_order)
        )
        (dispensing_container_available ?dispensing_container)
      )
    :effect
      (and
        (dispensing_container_staged ?dispensing_container)
        (dispensing_container_assigned_to_cold_slot ?dispensing_container ?cold_storage_slot)
        (dispensing_container_assigned_to_fulfillment_slot ?dispensing_container ?fulfillment_slot)
        (dispensing_container_requires_safety_check ?dispensing_container)
        (dispensing_container_alternate_packaging_route ?dispensing_container)
        (not
          (dispensing_container_available ?dispensing_container)
        )
      )
  )
  (:action mark_container_ready_for_labeling
    :parameters (?dispensing_container - dispensing_container ?refrigerated_medication_order - refrigerated_medication_order ?selected_drug_variant - selected_drug_variant)
    :precondition
      (and
        (dispensing_container_staged ?dispensing_container)
        (refrigerated_order_packaging_ready ?refrigerated_medication_order)
        (order_selected_variant ?refrigerated_medication_order ?selected_drug_variant)
        (not
          (dispensing_container_ready_for_labeling ?dispensing_container)
        )
      )
    :effect (dispensing_container_ready_for_labeling ?dispensing_container)
  )
  (:action stage_label_template_to_batch
    :parameters (?dispense_batch - dispense_batch ?package_label_template - package_label_template ?dispensing_container - dispensing_container)
    :precondition
      (and
        (medication_selection_confirmed ?dispense_batch)
        (batch_assigned_container ?dispense_batch ?dispensing_container)
        (batch_assigned_label_template ?dispense_batch ?package_label_template)
        (label_template_available ?package_label_template)
        (dispensing_container_staged ?dispensing_container)
        (dispensing_container_ready_for_labeling ?dispensing_container)
        (not
          (label_template_staged ?package_label_template)
        )
      )
    :effect
      (and
        (label_template_staged ?package_label_template)
        (label_template_assigned_to_dispensing_container ?package_label_template ?dispensing_container)
        (not
          (label_template_available ?package_label_template)
        )
      )
  )
  (:action assign_packaging_device_to_batch
    :parameters (?dispense_batch - dispense_batch ?package_label_template - package_label_template ?dispensing_container - dispensing_container ?selected_drug_variant - selected_drug_variant)
    :precondition
      (and
        (medication_selection_confirmed ?dispense_batch)
        (batch_assigned_label_template ?dispense_batch ?package_label_template)
        (label_template_staged ?package_label_template)
        (label_template_assigned_to_dispensing_container ?package_label_template ?dispensing_container)
        (order_selected_variant ?dispense_batch ?selected_drug_variant)
        (not
          (dispensing_container_requires_safety_check ?dispensing_container)
        )
        (not
          (packaging_device_assigned ?dispense_batch)
        )
      )
    :effect (packaging_device_assigned ?dispense_batch)
  )
  (:action assign_safety_check_item_to_batch
    :parameters (?dispense_batch - dispense_batch ?safety_check_item - safety_check_item)
    :precondition
      (and
        (medication_selection_confirmed ?dispense_batch)
        (safety_check_item_available ?safety_check_item)
        (not
          (safety_check_assigned_to_batch ?dispense_batch)
        )
      )
    :effect
      (and
        (safety_check_assigned_to_batch ?dispense_batch)
        (batch_assigned_safety_check_item ?dispense_batch ?safety_check_item)
        (not
          (safety_check_item_available ?safety_check_item)
        )
      )
  )
  (:action apply_safety_check_and_assign_packaging_device
    :parameters (?dispense_batch - dispense_batch ?package_label_template - package_label_template ?dispensing_container - dispensing_container ?selected_drug_variant - selected_drug_variant ?safety_check_item - safety_check_item)
    :precondition
      (and
        (medication_selection_confirmed ?dispense_batch)
        (batch_assigned_label_template ?dispense_batch ?package_label_template)
        (label_template_staged ?package_label_template)
        (label_template_assigned_to_dispensing_container ?package_label_template ?dispensing_container)
        (order_selected_variant ?dispense_batch ?selected_drug_variant)
        (dispensing_container_requires_safety_check ?dispensing_container)
        (safety_check_assigned_to_batch ?dispense_batch)
        (batch_assigned_safety_check_item ?dispense_batch ?safety_check_item)
        (not
          (packaging_device_assigned ?dispense_batch)
        )
      )
    :effect
      (and
        (packaging_device_assigned ?dispense_batch)
        (safety_check_completed_for_batch ?dispense_batch)
      )
  )
  (:action execute_packaging_operation_variant_a
    :parameters (?dispense_batch - dispense_batch ?packaging_device - packaging_device ?staff_member - pharmacy_technician ?package_label_template - package_label_template ?dispensing_container - dispensing_container)
    :precondition
      (and
        (packaging_device_assigned ?dispense_batch)
        (batch_has_packaging_device_bound ?dispense_batch ?packaging_device)
        (order_assigned_to_staff ?dispense_batch ?staff_member)
        (batch_assigned_label_template ?dispense_batch ?package_label_template)
        (label_template_assigned_to_dispensing_container ?package_label_template ?dispensing_container)
        (not
          (dispensing_container_alternate_packaging_route ?dispensing_container)
        )
        (not
          (packaging_operation_performed ?dispense_batch)
        )
      )
    :effect (packaging_operation_performed ?dispense_batch)
  )
  (:action execute_packaging_operation_variant_b
    :parameters (?dispense_batch - dispense_batch ?packaging_device - packaging_device ?staff_member - pharmacy_technician ?package_label_template - package_label_template ?dispensing_container - dispensing_container)
    :precondition
      (and
        (packaging_device_assigned ?dispense_batch)
        (batch_has_packaging_device_bound ?dispense_batch ?packaging_device)
        (order_assigned_to_staff ?dispense_batch ?staff_member)
        (batch_assigned_label_template ?dispense_batch ?package_label_template)
        (label_template_assigned_to_dispensing_container ?package_label_template ?dispensing_container)
        (dispensing_container_alternate_packaging_route ?dispensing_container)
        (not
          (packaging_operation_performed ?dispense_batch)
        )
      )
    :effect (packaging_operation_performed ?dispense_batch)
  )
  (:action finalize_packaging_with_temperature_monitor_variant_a
    :parameters (?dispense_batch - dispense_batch ?temperature_monitoring_device - temperature_monitoring_device ?package_label_template - package_label_template ?dispensing_container - dispensing_container)
    :precondition
      (and
        (packaging_operation_performed ?dispense_batch)
        (batch_has_temperature_monitor_bound ?dispense_batch ?temperature_monitoring_device)
        (batch_assigned_label_template ?dispense_batch ?package_label_template)
        (label_template_assigned_to_dispensing_container ?package_label_template ?dispensing_container)
        (not
          (dispensing_container_requires_safety_check ?dispensing_container)
        )
        (not
          (dispensing_container_alternate_packaging_route ?dispensing_container)
        )
        (not
          (packaging_steps_completed ?dispense_batch)
        )
      )
    :effect (packaging_steps_completed ?dispense_batch)
  )
  (:action finalize_packaging_with_temperature_monitor_variant_b
    :parameters (?dispense_batch - dispense_batch ?temperature_monitoring_device - temperature_monitoring_device ?package_label_template - package_label_template ?dispensing_container - dispensing_container)
    :precondition
      (and
        (packaging_operation_performed ?dispense_batch)
        (batch_has_temperature_monitor_bound ?dispense_batch ?temperature_monitoring_device)
        (batch_assigned_label_template ?dispense_batch ?package_label_template)
        (label_template_assigned_to_dispensing_container ?package_label_template ?dispensing_container)
        (dispensing_container_requires_safety_check ?dispensing_container)
        (not
          (dispensing_container_alternate_packaging_route ?dispensing_container)
        )
        (not
          (packaging_steps_completed ?dispense_batch)
        )
      )
    :effect
      (and
        (packaging_steps_completed ?dispense_batch)
        (labeling_complete_for_batch ?dispense_batch)
      )
  )
  (:action finalize_packaging_with_temperature_monitor_variant_c
    :parameters (?dispense_batch - dispense_batch ?temperature_monitoring_device - temperature_monitoring_device ?package_label_template - package_label_template ?dispensing_container - dispensing_container)
    :precondition
      (and
        (packaging_operation_performed ?dispense_batch)
        (batch_has_temperature_monitor_bound ?dispense_batch ?temperature_monitoring_device)
        (batch_assigned_label_template ?dispense_batch ?package_label_template)
        (label_template_assigned_to_dispensing_container ?package_label_template ?dispensing_container)
        (not
          (dispensing_container_requires_safety_check ?dispensing_container)
        )
        (dispensing_container_alternate_packaging_route ?dispensing_container)
        (not
          (packaging_steps_completed ?dispense_batch)
        )
      )
    :effect
      (and
        (packaging_steps_completed ?dispense_batch)
        (labeling_complete_for_batch ?dispense_batch)
      )
  )
  (:action finalize_packaging_with_temperature_monitor_variant_d
    :parameters (?dispense_batch - dispense_batch ?temperature_monitoring_device - temperature_monitoring_device ?package_label_template - package_label_template ?dispensing_container - dispensing_container)
    :precondition
      (and
        (packaging_operation_performed ?dispense_batch)
        (batch_has_temperature_monitor_bound ?dispense_batch ?temperature_monitoring_device)
        (batch_assigned_label_template ?dispense_batch ?package_label_template)
        (label_template_assigned_to_dispensing_container ?package_label_template ?dispensing_container)
        (dispensing_container_requires_safety_check ?dispensing_container)
        (dispensing_container_alternate_packaging_route ?dispensing_container)
        (not
          (packaging_steps_completed ?dispense_batch)
        )
      )
    :effect
      (and
        (packaging_steps_completed ?dispense_batch)
        (labeling_complete_for_batch ?dispense_batch)
      )
  )
  (:action finalize_batch_and_mark_release_pending
    :parameters (?dispense_batch - dispense_batch)
    :precondition
      (and
        (packaging_steps_completed ?dispense_batch)
        (not
          (labeling_complete_for_batch ?dispense_batch)
        )
        (not
          (batch_finalized_for_release ?dispense_batch)
        )
      )
    :effect
      (and
        (batch_finalized_for_release ?dispense_batch)
        (order_final_verification_complete ?dispense_batch)
      )
  )
  (:action attach_instruction_template_to_batch
    :parameters (?dispense_batch - dispense_batch ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (packaging_steps_completed ?dispense_batch)
        (labeling_complete_for_batch ?dispense_batch)
        (instruction_template_available ?patient_instruction_template)
      )
    :effect
      (and
        (batch_assigned_instruction_template ?dispense_batch ?patient_instruction_template)
        (not
          (instruction_template_available ?patient_instruction_template)
        )
      )
  )
  (:action perform_final_assembly_and_qc
    :parameters (?dispense_batch - dispense_batch ?refrigerated_medication_order - refrigerated_medication_order ?frozen_medication_order - frozen_medication_order ?selected_drug_variant - selected_drug_variant ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (packaging_steps_completed ?dispense_batch)
        (labeling_complete_for_batch ?dispense_batch)
        (batch_assigned_instruction_template ?dispense_batch ?patient_instruction_template)
        (batch_contains_refrigerated_order ?dispense_batch ?refrigerated_medication_order)
        (batch_contains_frozen_order ?dispense_batch ?frozen_medication_order)
        (refrigerated_slot_confirmed ?refrigerated_medication_order)
        (frozen_slot_confirmed ?frozen_medication_order)
        (order_selected_variant ?dispense_batch ?selected_drug_variant)
        (not
          (packaging_qc_passed ?dispense_batch)
        )
      )
    :effect (packaging_qc_passed ?dispense_batch)
  )
  (:action finalize_batch_after_qc
    :parameters (?dispense_batch - dispense_batch)
    :precondition
      (and
        (packaging_steps_completed ?dispense_batch)
        (packaging_qc_passed ?dispense_batch)
        (not
          (batch_finalized_for_release ?dispense_batch)
        )
      )
    :effect
      (and
        (batch_finalized_for_release ?dispense_batch)
        (order_final_verification_complete ?dispense_batch)
      )
  )
  (:action apply_clinical_priority_code_to_batch
    :parameters (?dispense_batch - dispense_batch ?clinical_priority_code - clinical_priority_code ?selected_drug_variant - selected_drug_variant)
    :precondition
      (and
        (medication_selection_confirmed ?dispense_batch)
        (order_selected_variant ?dispense_batch ?selected_drug_variant)
        (priority_code_available ?clinical_priority_code)
        (batch_assigned_priority_code ?dispense_batch ?clinical_priority_code)
        (not
          (priority_applied_to_batch ?dispense_batch)
        )
      )
    :effect
      (and
        (priority_applied_to_batch ?dispense_batch)
        (not
          (priority_code_available ?clinical_priority_code)
        )
      )
  )
  (:action confirm_priority_handling
    :parameters (?dispense_batch - dispense_batch ?staff_member - pharmacy_technician)
    :precondition
      (and
        (priority_applied_to_batch ?dispense_batch)
        (order_assigned_to_staff ?dispense_batch ?staff_member)
        (not
          (priority_handling_confirmed ?dispense_batch)
        )
      )
    :effect (priority_handling_confirmed ?dispense_batch)
  )
  (:action attach_temperature_monitor_for_priority_handling
    :parameters (?dispense_batch - dispense_batch ?temperature_monitoring_device - temperature_monitoring_device)
    :precondition
      (and
        (priority_handling_confirmed ?dispense_batch)
        (batch_has_temperature_monitor_bound ?dispense_batch ?temperature_monitoring_device)
        (not
          (temperature_monitoring_attached ?dispense_batch)
        )
      )
    :effect (temperature_monitoring_attached ?dispense_batch)
  )
  (:action finalize_priority_and_mark_batch_ready
    :parameters (?dispense_batch - dispense_batch)
    :precondition
      (and
        (temperature_monitoring_attached ?dispense_batch)
        (not
          (batch_finalized_for_release ?dispense_batch)
        )
      )
    :effect
      (and
        (batch_finalized_for_release ?dispense_batch)
        (order_final_verification_complete ?dispense_batch)
      )
  )
  (:action mark_refrigerated_order_final_check_complete
    :parameters (?refrigerated_medication_order - refrigerated_medication_order ?dispensing_container - dispensing_container)
    :precondition
      (and
        (refrigerated_order_packaging_ready ?refrigerated_medication_order)
        (refrigerated_slot_confirmed ?refrigerated_medication_order)
        (dispensing_container_staged ?dispensing_container)
        (dispensing_container_ready_for_labeling ?dispensing_container)
        (not
          (order_final_verification_complete ?refrigerated_medication_order)
        )
      )
    :effect (order_final_verification_complete ?refrigerated_medication_order)
  )
  (:action mark_frozen_order_final_check_complete
    :parameters (?frozen_medication_order - frozen_medication_order ?dispensing_container - dispensing_container)
    :precondition
      (and
        (frozen_order_packaging_ready ?frozen_medication_order)
        (frozen_slot_confirmed ?frozen_medication_order)
        (dispensing_container_staged ?dispensing_container)
        (dispensing_container_ready_for_labeling ?dispensing_container)
        (not
          (order_final_verification_complete ?frozen_medication_order)
        )
      )
    :effect (order_final_verification_complete ?frozen_medication_order)
  )
  (:action apply_release_authorization_to_order
    :parameters (?medication_order - medication_order ?release_authorization_token - release_authorization_token ?selected_drug_variant - selected_drug_variant)
    :precondition
      (and
        (order_final_verification_complete ?medication_order)
        (order_selected_variant ?medication_order ?selected_drug_variant)
        (release_authorization_token_available ?release_authorization_token)
        (not
          (order_authorized ?medication_order)
        )
      )
    :effect
      (and
        (order_authorized ?medication_order)
        (order_assigned_release_authorization ?medication_order ?release_authorization_token)
        (not
          (release_authorization_token_available ?release_authorization_token)
        )
      )
  )
  (:action authorize_and_release_refrigerated_order
    :parameters (?refrigerated_medication_order - refrigerated_medication_order ?drug_product - drug_product ?release_authorization_token - release_authorization_token)
    :precondition
      (and
        (order_authorized ?refrigerated_medication_order)
        (order_allocated_product ?refrigerated_medication_order ?drug_product)
        (order_assigned_release_authorization ?refrigerated_medication_order ?release_authorization_token)
        (not
          (order_ready_for_release ?refrigerated_medication_order)
        )
      )
    :effect
      (and
        (order_ready_for_release ?refrigerated_medication_order)
        (product_available ?drug_product)
        (release_authorization_token_available ?release_authorization_token)
      )
  )
  (:action authorize_and_release_frozen_order
    :parameters (?frozen_medication_order - frozen_medication_order ?drug_product - drug_product ?release_authorization_token - release_authorization_token)
    :precondition
      (and
        (order_authorized ?frozen_medication_order)
        (order_allocated_product ?frozen_medication_order ?drug_product)
        (order_assigned_release_authorization ?frozen_medication_order ?release_authorization_token)
        (not
          (order_ready_for_release ?frozen_medication_order)
        )
      )
    :effect
      (and
        (order_ready_for_release ?frozen_medication_order)
        (product_available ?drug_product)
        (release_authorization_token_available ?release_authorization_token)
      )
  )
  (:action authorize_and_release_batch
    :parameters (?dispense_batch - dispense_batch ?drug_product - drug_product ?release_authorization_token - release_authorization_token)
    :precondition
      (and
        (order_authorized ?dispense_batch)
        (order_allocated_product ?dispense_batch ?drug_product)
        (order_assigned_release_authorization ?dispense_batch ?release_authorization_token)
        (not
          (order_ready_for_release ?dispense_batch)
        )
      )
    :effect
      (and
        (order_ready_for_release ?dispense_batch)
        (product_available ?drug_product)
        (release_authorization_token_available ?release_authorization_token)
      )
  )
)

(define (domain pharmaceutics_discharge_medication_supply_preparation)
  (:requirements :strips :typing :negative-preconditions)
  (:types pharmacy_resource - object product_material - object packaging_component - object prescription_order - object discharge_work_item - prescription_order pharmacist - pharmacy_resource medication_product - pharmacy_resource prescriber - pharmacy_resource special_handling_code - pharmacy_resource auxiliary_supply - pharmacy_resource counseling_material - pharmacy_resource verification_checkpoint - pharmacy_resource clinical_intervention - pharmacy_resource packaging_material - product_material patient_instruction_template - product_material prior_authorization_document - product_material dosage_form - packaging_component label_template - packaging_component medication_package - packaging_component dispensing_line - discharge_work_item pharmacist_case - discharge_work_item dispensing_technician_task - dispensing_line dispensing_robot_task - dispensing_line medication_supply_case - pharmacist_case)
  (:predicates
    (discharge_prescription_registered ?discharge_work_item - discharge_work_item)
    (entity_pharmacist_review_complete ?discharge_work_item - discharge_work_item)
    (entity_pharmacist_assigned ?discharge_work_item - discharge_work_item)
    (entity_released_for_discharge ?discharge_work_item - discharge_work_item)
    (entity_ready_for_finalization ?discharge_work_item - discharge_work_item)
    (entity_instructions_generated ?discharge_work_item - discharge_work_item)
    (pharmacist_available ?pharmacist - pharmacist)
    (entity_assigned_pharmacist ?discharge_work_item - discharge_work_item ?pharmacist - pharmacist)
    (medication_product_available ?medication_product - medication_product)
    (entity_selected_medication_product ?discharge_work_item - discharge_work_item ?medication_product - medication_product)
    (prescriber_available ?prescriber - prescriber)
    (entity_authorization_request ?discharge_work_item - discharge_work_item ?prescriber - prescriber)
    (packaging_material_available ?packaging_material - packaging_material)
    (technician_task_assigned_packaging_material ?dispensing_technician_task - dispensing_technician_task ?packaging_material - packaging_material)
    (robot_task_assigned_packaging_material ?dispensing_robot_task - dispensing_robot_task ?packaging_material - packaging_material)
    (technician_task_assigned_dosage_form ?dispensing_technician_task - dispensing_technician_task ?dosage_form - dosage_form)
    (dosage_form_reserved ?dosage_form - dosage_form)
    (dosage_form_prepared_for_packaging ?dosage_form - dosage_form)
    (technician_task_ready_for_assembly ?dispensing_technician_task - dispensing_technician_task)
    (robot_task_assigned_label_template ?dispensing_robot_task - dispensing_robot_task ?label_template - label_template)
    (label_template_reserved ?label_template - label_template)
    (label_template_prepared_for_packaging ?label_template - label_template)
    (robot_task_ready_for_assembly ?dispensing_robot_task - dispensing_robot_task)
    (package_slot_available ?medication_package - medication_package)
    (medication_package_activated ?medication_package - medication_package)
    (medication_package_contains_dosage_form ?medication_package - medication_package ?dosage_form - dosage_form)
    (medication_package_has_label_template ?medication_package - medication_package ?label_template - label_template)
    (medication_package_flag_dosage_prepared ?medication_package - medication_package)
    (medication_package_flag_label_prepared ?medication_package - medication_package)
    (medication_package_activated_for_dispense ?medication_package - medication_package)
    (case_has_technician_task ?medication_supply_case - medication_supply_case ?dispensing_technician_task - dispensing_technician_task)
    (case_has_robot_task ?medication_supply_case - medication_supply_case ?dispensing_robot_task - dispensing_robot_task)
    (case_has_package ?medication_supply_case - medication_supply_case ?medication_package - medication_package)
    (instruction_template_available ?patient_instruction_template - patient_instruction_template)
    (case_assigned_instruction_template ?medication_supply_case - medication_supply_case ?patient_instruction_template - patient_instruction_template)
    (instruction_template_attached_to_case ?patient_instruction_template - patient_instruction_template)
    (instruction_template_attached_to_package ?patient_instruction_template - patient_instruction_template ?medication_package - medication_package)
    (case_ready_for_ancillary_processing ?medication_supply_case - medication_supply_case)
    (case_clinical_checks_completed ?medication_supply_case - medication_supply_case)
    (case_administrative_checks_completed ?medication_supply_case - medication_supply_case)
    (case_special_handling_marked ?medication_supply_case - medication_supply_case)
    (case_special_handling_confirmed ?medication_supply_case - medication_supply_case)
    (case_ready_for_final_checks ?medication_supply_case - medication_supply_case)
    (case_final_verification_completed ?medication_supply_case - medication_supply_case)
    (prior_authorization_document_available ?prior_authorization_document - prior_authorization_document)
    (case_has_prior_authorization_document ?medication_supply_case - medication_supply_case ?prior_authorization_document - prior_authorization_document)
    (prior_authorization_applied_to_case ?medication_supply_case - medication_supply_case)
    (prior_authorization_confirmed ?medication_supply_case - medication_supply_case)
    (prior_authorization_verified ?medication_supply_case - medication_supply_case)
    (special_handling_code_available ?special_handling_code - special_handling_code)
    (case_has_special_handling_code ?medication_supply_case - medication_supply_case ?special_handling_code - special_handling_code)
    (auxiliary_supply_available ?auxiliary_supply - auxiliary_supply)
    (case_includes_auxiliary_supply ?medication_supply_case - medication_supply_case ?auxiliary_supply - auxiliary_supply)
    (verification_checkpoint_available ?verification_checkpoint - verification_checkpoint)
    (case_assigned_verification_checkpoint ?medication_supply_case - medication_supply_case ?verification_checkpoint - verification_checkpoint)
    (clinical_intervention_available ?clinical_intervention - clinical_intervention)
    (case_assigned_clinical_intervention ?medication_supply_case - medication_supply_case ?clinical_intervention - clinical_intervention)
    (counseling_material_available ?counseling_material - counseling_material)
    (entity_assigned_counseling_material ?discharge_work_item - discharge_work_item ?counseling_material - counseling_material)
    (technician_task_allocated ?dispensing_technician_task - dispensing_technician_task)
    (robot_task_allocated ?dispensing_robot_task - dispensing_robot_task)
    (case_finalized ?medication_supply_case - medication_supply_case)
  )
  (:action register_discharge_prescription
    :parameters (?discharge_work_item - discharge_work_item)
    :precondition
      (and
        (not
          (discharge_prescription_registered ?discharge_work_item)
        )
        (not
          (entity_released_for_discharge ?discharge_work_item)
        )
      )
    :effect (discharge_prescription_registered ?discharge_work_item)
  )
  (:action assign_pharmacist_to_prescription
    :parameters (?discharge_work_item - discharge_work_item ?pharmacist - pharmacist)
    :precondition
      (and
        (discharge_prescription_registered ?discharge_work_item)
        (not
          (entity_pharmacist_assigned ?discharge_work_item)
        )
        (pharmacist_available ?pharmacist)
      )
    :effect
      (and
        (entity_pharmacist_assigned ?discharge_work_item)
        (entity_assigned_pharmacist ?discharge_work_item ?pharmacist)
        (not
          (pharmacist_available ?pharmacist)
        )
      )
  )
  (:action assign_medication_product_to_prescription
    :parameters (?discharge_work_item - discharge_work_item ?medication_product - medication_product)
    :precondition
      (and
        (discharge_prescription_registered ?discharge_work_item)
        (entity_pharmacist_assigned ?discharge_work_item)
        (medication_product_available ?medication_product)
      )
    :effect
      (and
        (entity_selected_medication_product ?discharge_work_item ?medication_product)
        (not
          (medication_product_available ?medication_product)
        )
      )
  )
  (:action finalize_product_selection_for_prescription
    :parameters (?discharge_work_item - discharge_work_item ?medication_product - medication_product)
    :precondition
      (and
        (discharge_prescription_registered ?discharge_work_item)
        (entity_pharmacist_assigned ?discharge_work_item)
        (entity_selected_medication_product ?discharge_work_item ?medication_product)
        (not
          (entity_pharmacist_review_complete ?discharge_work_item)
        )
      )
    :effect (entity_pharmacist_review_complete ?discharge_work_item)
  )
  (:action release_medication_product_from_prescription
    :parameters (?discharge_work_item - discharge_work_item ?medication_product - medication_product)
    :precondition
      (and
        (entity_selected_medication_product ?discharge_work_item ?medication_product)
      )
    :effect
      (and
        (medication_product_available ?medication_product)
        (not
          (entity_selected_medication_product ?discharge_work_item ?medication_product)
        )
      )
  )
  (:action send_prescriber_authorization_request
    :parameters (?discharge_work_item - discharge_work_item ?prescriber - prescriber)
    :precondition
      (and
        (entity_pharmacist_review_complete ?discharge_work_item)
        (prescriber_available ?prescriber)
      )
    :effect
      (and
        (entity_authorization_request ?discharge_work_item ?prescriber)
        (not
          (prescriber_available ?prescriber)
        )
      )
  )
  (:action receive_prescriber_authorization_response
    :parameters (?discharge_work_item - discharge_work_item ?prescriber - prescriber)
    :precondition
      (and
        (entity_authorization_request ?discharge_work_item ?prescriber)
      )
    :effect
      (and
        (prescriber_available ?prescriber)
        (not
          (entity_authorization_request ?discharge_work_item ?prescriber)
        )
      )
  )
  (:action assign_verification_checkpoint_to_case
    :parameters (?medication_supply_case - medication_supply_case ?verification_checkpoint - verification_checkpoint)
    :precondition
      (and
        (entity_pharmacist_review_complete ?medication_supply_case)
        (verification_checkpoint_available ?verification_checkpoint)
      )
    :effect
      (and
        (case_assigned_verification_checkpoint ?medication_supply_case ?verification_checkpoint)
        (not
          (verification_checkpoint_available ?verification_checkpoint)
        )
      )
  )
  (:action unassign_verification_checkpoint_from_case
    :parameters (?medication_supply_case - medication_supply_case ?verification_checkpoint - verification_checkpoint)
    :precondition
      (and
        (case_assigned_verification_checkpoint ?medication_supply_case ?verification_checkpoint)
      )
    :effect
      (and
        (verification_checkpoint_available ?verification_checkpoint)
        (not
          (case_assigned_verification_checkpoint ?medication_supply_case ?verification_checkpoint)
        )
      )
  )
  (:action assign_clinical_intervention_to_case
    :parameters (?medication_supply_case - medication_supply_case ?clinical_intervention - clinical_intervention)
    :precondition
      (and
        (entity_pharmacist_review_complete ?medication_supply_case)
        (clinical_intervention_available ?clinical_intervention)
      )
    :effect
      (and
        (case_assigned_clinical_intervention ?medication_supply_case ?clinical_intervention)
        (not
          (clinical_intervention_available ?clinical_intervention)
        )
      )
  )
  (:action unassign_clinical_intervention_from_case
    :parameters (?medication_supply_case - medication_supply_case ?clinical_intervention - clinical_intervention)
    :precondition
      (and
        (case_assigned_clinical_intervention ?medication_supply_case ?clinical_intervention)
      )
    :effect
      (and
        (clinical_intervention_available ?clinical_intervention)
        (not
          (case_assigned_clinical_intervention ?medication_supply_case ?clinical_intervention)
        )
      )
  )
  (:action technician_reserve_dosage_form_for_task
    :parameters (?dispensing_technician_task - dispensing_technician_task ?dosage_form - dosage_form ?medication_product - medication_product)
    :precondition
      (and
        (entity_pharmacist_review_complete ?dispensing_technician_task)
        (entity_selected_medication_product ?dispensing_technician_task ?medication_product)
        (technician_task_assigned_dosage_form ?dispensing_technician_task ?dosage_form)
        (not
          (dosage_form_reserved ?dosage_form)
        )
        (not
          (dosage_form_prepared_for_packaging ?dosage_form)
        )
      )
    :effect (dosage_form_reserved ?dosage_form)
  )
  (:action technician_confirm_prescriber_and_mark_ready
    :parameters (?dispensing_technician_task - dispensing_technician_task ?dosage_form - dosage_form ?prescriber - prescriber)
    :precondition
      (and
        (entity_pharmacist_review_complete ?dispensing_technician_task)
        (entity_authorization_request ?dispensing_technician_task ?prescriber)
        (technician_task_assigned_dosage_form ?dispensing_technician_task ?dosage_form)
        (dosage_form_reserved ?dosage_form)
        (not
          (technician_task_allocated ?dispensing_technician_task)
        )
      )
    :effect
      (and
        (technician_task_allocated ?dispensing_technician_task)
        (technician_task_ready_for_assembly ?dispensing_technician_task)
      )
  )
  (:action technician_allocate_packaging_material
    :parameters (?dispensing_technician_task - dispensing_technician_task ?dosage_form - dosage_form ?packaging_material - packaging_material)
    :precondition
      (and
        (entity_pharmacist_review_complete ?dispensing_technician_task)
        (technician_task_assigned_dosage_form ?dispensing_technician_task ?dosage_form)
        (packaging_material_available ?packaging_material)
        (not
          (technician_task_allocated ?dispensing_technician_task)
        )
      )
    :effect
      (and
        (dosage_form_prepared_for_packaging ?dosage_form)
        (technician_task_allocated ?dispensing_technician_task)
        (technician_task_assigned_packaging_material ?dispensing_technician_task ?packaging_material)
        (not
          (packaging_material_available ?packaging_material)
        )
      )
  )
  (:action technician_finalize_packaging_allocation
    :parameters (?dispensing_technician_task - dispensing_technician_task ?dosage_form - dosage_form ?medication_product - medication_product ?packaging_material - packaging_material)
    :precondition
      (and
        (entity_pharmacist_review_complete ?dispensing_technician_task)
        (entity_selected_medication_product ?dispensing_technician_task ?medication_product)
        (technician_task_assigned_dosage_form ?dispensing_technician_task ?dosage_form)
        (dosage_form_prepared_for_packaging ?dosage_form)
        (technician_task_assigned_packaging_material ?dispensing_technician_task ?packaging_material)
        (not
          (technician_task_ready_for_assembly ?dispensing_technician_task)
        )
      )
    :effect
      (and
        (dosage_form_reserved ?dosage_form)
        (technician_task_ready_for_assembly ?dispensing_technician_task)
        (packaging_material_available ?packaging_material)
        (not
          (technician_task_assigned_packaging_material ?dispensing_technician_task ?packaging_material)
        )
      )
  )
  (:action robot_reserve_label_template_for_task
    :parameters (?dispensing_robot_task - dispensing_robot_task ?label_template - label_template ?medication_product - medication_product)
    :precondition
      (and
        (entity_pharmacist_review_complete ?dispensing_robot_task)
        (entity_selected_medication_product ?dispensing_robot_task ?medication_product)
        (robot_task_assigned_label_template ?dispensing_robot_task ?label_template)
        (not
          (label_template_reserved ?label_template)
        )
        (not
          (label_template_prepared_for_packaging ?label_template)
        )
      )
    :effect (label_template_reserved ?label_template)
  )
  (:action robot_confirm_prescriber_and_mark_ready
    :parameters (?dispensing_robot_task - dispensing_robot_task ?label_template - label_template ?prescriber - prescriber)
    :precondition
      (and
        (entity_pharmacist_review_complete ?dispensing_robot_task)
        (entity_authorization_request ?dispensing_robot_task ?prescriber)
        (robot_task_assigned_label_template ?dispensing_robot_task ?label_template)
        (label_template_reserved ?label_template)
        (not
          (robot_task_allocated ?dispensing_robot_task)
        )
      )
    :effect
      (and
        (robot_task_allocated ?dispensing_robot_task)
        (robot_task_ready_for_assembly ?dispensing_robot_task)
      )
  )
  (:action robot_allocate_packaging_material
    :parameters (?dispensing_robot_task - dispensing_robot_task ?label_template - label_template ?packaging_material - packaging_material)
    :precondition
      (and
        (entity_pharmacist_review_complete ?dispensing_robot_task)
        (robot_task_assigned_label_template ?dispensing_robot_task ?label_template)
        (packaging_material_available ?packaging_material)
        (not
          (robot_task_allocated ?dispensing_robot_task)
        )
      )
    :effect
      (and
        (label_template_prepared_for_packaging ?label_template)
        (robot_task_allocated ?dispensing_robot_task)
        (robot_task_assigned_packaging_material ?dispensing_robot_task ?packaging_material)
        (not
          (packaging_material_available ?packaging_material)
        )
      )
  )
  (:action robot_finalize_packaging_allocation
    :parameters (?dispensing_robot_task - dispensing_robot_task ?label_template - label_template ?medication_product - medication_product ?packaging_material - packaging_material)
    :precondition
      (and
        (entity_pharmacist_review_complete ?dispensing_robot_task)
        (entity_selected_medication_product ?dispensing_robot_task ?medication_product)
        (robot_task_assigned_label_template ?dispensing_robot_task ?label_template)
        (label_template_prepared_for_packaging ?label_template)
        (robot_task_assigned_packaging_material ?dispensing_robot_task ?packaging_material)
        (not
          (robot_task_ready_for_assembly ?dispensing_robot_task)
        )
      )
    :effect
      (and
        (label_template_reserved ?label_template)
        (robot_task_ready_for_assembly ?dispensing_robot_task)
        (packaging_material_available ?packaging_material)
        (not
          (robot_task_assigned_packaging_material ?dispensing_robot_task ?packaging_material)
        )
      )
  )
  (:action assemble_medication_package_base
    :parameters (?dispensing_technician_task - dispensing_technician_task ?dispensing_robot_task - dispensing_robot_task ?dosage_form - dosage_form ?label_template - label_template ?medication_package - medication_package)
    :precondition
      (and
        (technician_task_allocated ?dispensing_technician_task)
        (robot_task_allocated ?dispensing_robot_task)
        (technician_task_assigned_dosage_form ?dispensing_technician_task ?dosage_form)
        (robot_task_assigned_label_template ?dispensing_robot_task ?label_template)
        (dosage_form_reserved ?dosage_form)
        (label_template_reserved ?label_template)
        (technician_task_ready_for_assembly ?dispensing_technician_task)
        (robot_task_ready_for_assembly ?dispensing_robot_task)
        (package_slot_available ?medication_package)
      )
    :effect
      (and
        (medication_package_activated ?medication_package)
        (medication_package_contains_dosage_form ?medication_package ?dosage_form)
        (medication_package_has_label_template ?medication_package ?label_template)
        (not
          (package_slot_available ?medication_package)
        )
      )
  )
  (:action assemble_medication_package_with_tech_prepared_dosage
    :parameters (?dispensing_technician_task - dispensing_technician_task ?dispensing_robot_task - dispensing_robot_task ?dosage_form - dosage_form ?label_template - label_template ?medication_package - medication_package)
    :precondition
      (and
        (technician_task_allocated ?dispensing_technician_task)
        (robot_task_allocated ?dispensing_robot_task)
        (technician_task_assigned_dosage_form ?dispensing_technician_task ?dosage_form)
        (robot_task_assigned_label_template ?dispensing_robot_task ?label_template)
        (dosage_form_prepared_for_packaging ?dosage_form)
        (label_template_reserved ?label_template)
        (not
          (technician_task_ready_for_assembly ?dispensing_technician_task)
        )
        (robot_task_ready_for_assembly ?dispensing_robot_task)
        (package_slot_available ?medication_package)
      )
    :effect
      (and
        (medication_package_activated ?medication_package)
        (medication_package_contains_dosage_form ?medication_package ?dosage_form)
        (medication_package_has_label_template ?medication_package ?label_template)
        (medication_package_flag_dosage_prepared ?medication_package)
        (not
          (package_slot_available ?medication_package)
        )
      )
  )
  (:action assemble_medication_package_with_label_prepared
    :parameters (?dispensing_technician_task - dispensing_technician_task ?dispensing_robot_task - dispensing_robot_task ?dosage_form - dosage_form ?label_template - label_template ?medication_package - medication_package)
    :precondition
      (and
        (technician_task_allocated ?dispensing_technician_task)
        (robot_task_allocated ?dispensing_robot_task)
        (technician_task_assigned_dosage_form ?dispensing_technician_task ?dosage_form)
        (robot_task_assigned_label_template ?dispensing_robot_task ?label_template)
        (dosage_form_reserved ?dosage_form)
        (label_template_prepared_for_packaging ?label_template)
        (technician_task_ready_for_assembly ?dispensing_technician_task)
        (not
          (robot_task_ready_for_assembly ?dispensing_robot_task)
        )
        (package_slot_available ?medication_package)
      )
    :effect
      (and
        (medication_package_activated ?medication_package)
        (medication_package_contains_dosage_form ?medication_package ?dosage_form)
        (medication_package_has_label_template ?medication_package ?label_template)
        (medication_package_flag_label_prepared ?medication_package)
        (not
          (package_slot_available ?medication_package)
        )
      )
  )
  (:action assemble_medication_package_with_both_preparations
    :parameters (?dispensing_technician_task - dispensing_technician_task ?dispensing_robot_task - dispensing_robot_task ?dosage_form - dosage_form ?label_template - label_template ?medication_package - medication_package)
    :precondition
      (and
        (technician_task_allocated ?dispensing_technician_task)
        (robot_task_allocated ?dispensing_robot_task)
        (technician_task_assigned_dosage_form ?dispensing_technician_task ?dosage_form)
        (robot_task_assigned_label_template ?dispensing_robot_task ?label_template)
        (dosage_form_prepared_for_packaging ?dosage_form)
        (label_template_prepared_for_packaging ?label_template)
        (not
          (technician_task_ready_for_assembly ?dispensing_technician_task)
        )
        (not
          (robot_task_ready_for_assembly ?dispensing_robot_task)
        )
        (package_slot_available ?medication_package)
      )
    :effect
      (and
        (medication_package_activated ?medication_package)
        (medication_package_contains_dosage_form ?medication_package ?dosage_form)
        (medication_package_has_label_template ?medication_package ?label_template)
        (medication_package_flag_dosage_prepared ?medication_package)
        (medication_package_flag_label_prepared ?medication_package)
        (not
          (package_slot_available ?medication_package)
        )
      )
  )
  (:action activate_medication_package_for_dispense
    :parameters (?medication_package - medication_package ?dispensing_technician_task - dispensing_technician_task ?medication_product - medication_product)
    :precondition
      (and
        (medication_package_activated ?medication_package)
        (technician_task_allocated ?dispensing_technician_task)
        (entity_selected_medication_product ?dispensing_technician_task ?medication_product)
        (not
          (medication_package_activated_for_dispense ?medication_package)
        )
      )
    :effect (medication_package_activated_for_dispense ?medication_package)
  )
  (:action attach_instruction_template_to_case_and_package
    :parameters (?medication_supply_case - medication_supply_case ?patient_instruction_template - patient_instruction_template ?medication_package - medication_package)
    :precondition
      (and
        (entity_pharmacist_review_complete ?medication_supply_case)
        (case_has_package ?medication_supply_case ?medication_package)
        (case_assigned_instruction_template ?medication_supply_case ?patient_instruction_template)
        (instruction_template_available ?patient_instruction_template)
        (medication_package_activated ?medication_package)
        (medication_package_activated_for_dispense ?medication_package)
        (not
          (instruction_template_attached_to_case ?patient_instruction_template)
        )
      )
    :effect
      (and
        (instruction_template_attached_to_case ?patient_instruction_template)
        (instruction_template_attached_to_package ?patient_instruction_template ?medication_package)
        (not
          (instruction_template_available ?patient_instruction_template)
        )
      )
  )
  (:action confirm_instruction_and_mark_case_ready
    :parameters (?medication_supply_case - medication_supply_case ?patient_instruction_template - patient_instruction_template ?medication_package - medication_package ?medication_product - medication_product)
    :precondition
      (and
        (entity_pharmacist_review_complete ?medication_supply_case)
        (case_assigned_instruction_template ?medication_supply_case ?patient_instruction_template)
        (instruction_template_attached_to_case ?patient_instruction_template)
        (instruction_template_attached_to_package ?patient_instruction_template ?medication_package)
        (entity_selected_medication_product ?medication_supply_case ?medication_product)
        (not
          (medication_package_flag_dosage_prepared ?medication_package)
        )
        (not
          (case_ready_for_ancillary_processing ?medication_supply_case)
        )
      )
    :effect (case_ready_for_ancillary_processing ?medication_supply_case)
  )
  (:action apply_special_handling_code_to_case
    :parameters (?medication_supply_case - medication_supply_case ?special_handling_code - special_handling_code)
    :precondition
      (and
        (entity_pharmacist_review_complete ?medication_supply_case)
        (special_handling_code_available ?special_handling_code)
        (not
          (case_special_handling_marked ?medication_supply_case)
        )
      )
    :effect
      (and
        (case_special_handling_marked ?medication_supply_case)
        (case_has_special_handling_code ?medication_supply_case ?special_handling_code)
        (not
          (special_handling_code_available ?special_handling_code)
        )
      )
  )
  (:action process_special_handling_and_confirm_on_case
    :parameters (?medication_supply_case - medication_supply_case ?patient_instruction_template - patient_instruction_template ?medication_package - medication_package ?medication_product - medication_product ?special_handling_code - special_handling_code)
    :precondition
      (and
        (entity_pharmacist_review_complete ?medication_supply_case)
        (case_assigned_instruction_template ?medication_supply_case ?patient_instruction_template)
        (instruction_template_attached_to_case ?patient_instruction_template)
        (instruction_template_attached_to_package ?patient_instruction_template ?medication_package)
        (entity_selected_medication_product ?medication_supply_case ?medication_product)
        (medication_package_flag_dosage_prepared ?medication_package)
        (case_special_handling_marked ?medication_supply_case)
        (case_has_special_handling_code ?medication_supply_case ?special_handling_code)
        (not
          (case_ready_for_ancillary_processing ?medication_supply_case)
        )
      )
    :effect
      (and
        (case_ready_for_ancillary_processing ?medication_supply_case)
        (case_special_handling_confirmed ?medication_supply_case)
      )
  )
  (:action perform_clinical_verification_variant_a
    :parameters (?medication_supply_case - medication_supply_case ?verification_checkpoint - verification_checkpoint ?prescriber - prescriber ?patient_instruction_template - patient_instruction_template ?medication_package - medication_package)
    :precondition
      (and
        (case_ready_for_ancillary_processing ?medication_supply_case)
        (case_assigned_verification_checkpoint ?medication_supply_case ?verification_checkpoint)
        (entity_authorization_request ?medication_supply_case ?prescriber)
        (case_assigned_instruction_template ?medication_supply_case ?patient_instruction_template)
        (instruction_template_attached_to_package ?patient_instruction_template ?medication_package)
        (not
          (medication_package_flag_label_prepared ?medication_package)
        )
        (not
          (case_clinical_checks_completed ?medication_supply_case)
        )
      )
    :effect (case_clinical_checks_completed ?medication_supply_case)
  )
  (:action perform_clinical_verification_variant_b
    :parameters (?medication_supply_case - medication_supply_case ?verification_checkpoint - verification_checkpoint ?prescriber - prescriber ?patient_instruction_template - patient_instruction_template ?medication_package - medication_package)
    :precondition
      (and
        (case_ready_for_ancillary_processing ?medication_supply_case)
        (case_assigned_verification_checkpoint ?medication_supply_case ?verification_checkpoint)
        (entity_authorization_request ?medication_supply_case ?prescriber)
        (case_assigned_instruction_template ?medication_supply_case ?patient_instruction_template)
        (instruction_template_attached_to_package ?patient_instruction_template ?medication_package)
        (medication_package_flag_label_prepared ?medication_package)
        (not
          (case_clinical_checks_completed ?medication_supply_case)
        )
      )
    :effect (case_clinical_checks_completed ?medication_supply_case)
  )
  (:action complete_administrative_checks_variant_a
    :parameters (?medication_supply_case - medication_supply_case ?clinical_intervention - clinical_intervention ?patient_instruction_template - patient_instruction_template ?medication_package - medication_package)
    :precondition
      (and
        (case_clinical_checks_completed ?medication_supply_case)
        (case_assigned_clinical_intervention ?medication_supply_case ?clinical_intervention)
        (case_assigned_instruction_template ?medication_supply_case ?patient_instruction_template)
        (instruction_template_attached_to_package ?patient_instruction_template ?medication_package)
        (not
          (medication_package_flag_dosage_prepared ?medication_package)
        )
        (not
          (medication_package_flag_label_prepared ?medication_package)
        )
        (not
          (case_administrative_checks_completed ?medication_supply_case)
        )
      )
    :effect (case_administrative_checks_completed ?medication_supply_case)
  )
  (:action complete_administrative_checks_variant_b
    :parameters (?medication_supply_case - medication_supply_case ?clinical_intervention - clinical_intervention ?patient_instruction_template - patient_instruction_template ?medication_package - medication_package)
    :precondition
      (and
        (case_clinical_checks_completed ?medication_supply_case)
        (case_assigned_clinical_intervention ?medication_supply_case ?clinical_intervention)
        (case_assigned_instruction_template ?medication_supply_case ?patient_instruction_template)
        (instruction_template_attached_to_package ?patient_instruction_template ?medication_package)
        (medication_package_flag_dosage_prepared ?medication_package)
        (not
          (medication_package_flag_label_prepared ?medication_package)
        )
        (not
          (case_administrative_checks_completed ?medication_supply_case)
        )
      )
    :effect
      (and
        (case_administrative_checks_completed ?medication_supply_case)
        (case_ready_for_final_checks ?medication_supply_case)
      )
  )
  (:action complete_administrative_checks_variant_c
    :parameters (?medication_supply_case - medication_supply_case ?clinical_intervention - clinical_intervention ?patient_instruction_template - patient_instruction_template ?medication_package - medication_package)
    :precondition
      (and
        (case_clinical_checks_completed ?medication_supply_case)
        (case_assigned_clinical_intervention ?medication_supply_case ?clinical_intervention)
        (case_assigned_instruction_template ?medication_supply_case ?patient_instruction_template)
        (instruction_template_attached_to_package ?patient_instruction_template ?medication_package)
        (not
          (medication_package_flag_dosage_prepared ?medication_package)
        )
        (medication_package_flag_label_prepared ?medication_package)
        (not
          (case_administrative_checks_completed ?medication_supply_case)
        )
      )
    :effect
      (and
        (case_administrative_checks_completed ?medication_supply_case)
        (case_ready_for_final_checks ?medication_supply_case)
      )
  )
  (:action complete_administrative_checks_variant_d
    :parameters (?medication_supply_case - medication_supply_case ?clinical_intervention - clinical_intervention ?patient_instruction_template - patient_instruction_template ?medication_package - medication_package)
    :precondition
      (and
        (case_clinical_checks_completed ?medication_supply_case)
        (case_assigned_clinical_intervention ?medication_supply_case ?clinical_intervention)
        (case_assigned_instruction_template ?medication_supply_case ?patient_instruction_template)
        (instruction_template_attached_to_package ?patient_instruction_template ?medication_package)
        (medication_package_flag_dosage_prepared ?medication_package)
        (medication_package_flag_label_prepared ?medication_package)
        (not
          (case_administrative_checks_completed ?medication_supply_case)
        )
      )
    :effect
      (and
        (case_administrative_checks_completed ?medication_supply_case)
        (case_ready_for_final_checks ?medication_supply_case)
      )
  )
  (:action flag_case_for_final_verification
    :parameters (?medication_supply_case - medication_supply_case)
    :precondition
      (and
        (case_administrative_checks_completed ?medication_supply_case)
        (not
          (case_ready_for_final_checks ?medication_supply_case)
        )
        (not
          (case_finalized ?medication_supply_case)
        )
      )
    :effect
      (and
        (case_finalized ?medication_supply_case)
        (entity_ready_for_finalization ?medication_supply_case)
      )
  )
  (:action attach_auxiliary_supply_to_case
    :parameters (?medication_supply_case - medication_supply_case ?auxiliary_supply - auxiliary_supply)
    :precondition
      (and
        (case_administrative_checks_completed ?medication_supply_case)
        (case_ready_for_final_checks ?medication_supply_case)
        (auxiliary_supply_available ?auxiliary_supply)
      )
    :effect
      (and
        (case_includes_auxiliary_supply ?medication_supply_case ?auxiliary_supply)
        (not
          (auxiliary_supply_available ?auxiliary_supply)
        )
      )
  )
  (:action perform_final_verification_and_lock_case
    :parameters (?medication_supply_case - medication_supply_case ?dispensing_technician_task - dispensing_technician_task ?dispensing_robot_task - dispensing_robot_task ?medication_product - medication_product ?auxiliary_supply - auxiliary_supply)
    :precondition
      (and
        (case_administrative_checks_completed ?medication_supply_case)
        (case_ready_for_final_checks ?medication_supply_case)
        (case_includes_auxiliary_supply ?medication_supply_case ?auxiliary_supply)
        (case_has_technician_task ?medication_supply_case ?dispensing_technician_task)
        (case_has_robot_task ?medication_supply_case ?dispensing_robot_task)
        (technician_task_ready_for_assembly ?dispensing_technician_task)
        (robot_task_ready_for_assembly ?dispensing_robot_task)
        (entity_selected_medication_product ?medication_supply_case ?medication_product)
        (not
          (case_final_verification_completed ?medication_supply_case)
        )
      )
    :effect (case_final_verification_completed ?medication_supply_case)
  )
  (:action finalize_case_after_verification
    :parameters (?medication_supply_case - medication_supply_case)
    :precondition
      (and
        (case_administrative_checks_completed ?medication_supply_case)
        (case_final_verification_completed ?medication_supply_case)
        (not
          (case_finalized ?medication_supply_case)
        )
      )
    :effect
      (and
        (case_finalized ?medication_supply_case)
        (entity_ready_for_finalization ?medication_supply_case)
      )
  )
  (:action apply_prior_authorization_document_to_case
    :parameters (?medication_supply_case - medication_supply_case ?prior_authorization_document - prior_authorization_document ?medication_product - medication_product)
    :precondition
      (and
        (entity_pharmacist_review_complete ?medication_supply_case)
        (entity_selected_medication_product ?medication_supply_case ?medication_product)
        (prior_authorization_document_available ?prior_authorization_document)
        (case_has_prior_authorization_document ?medication_supply_case ?prior_authorization_document)
        (not
          (prior_authorization_applied_to_case ?medication_supply_case)
        )
      )
    :effect
      (and
        (prior_authorization_applied_to_case ?medication_supply_case)
        (not
          (prior_authorization_document_available ?prior_authorization_document)
        )
      )
  )
  (:action confirm_prior_authorization_on_case
    :parameters (?medication_supply_case - medication_supply_case ?prescriber - prescriber)
    :precondition
      (and
        (prior_authorization_applied_to_case ?medication_supply_case)
        (entity_authorization_request ?medication_supply_case ?prescriber)
        (not
          (prior_authorization_confirmed ?medication_supply_case)
        )
      )
    :effect (prior_authorization_confirmed ?medication_supply_case)
  )
  (:action record_clinical_intervention_completion
    :parameters (?medication_supply_case - medication_supply_case ?clinical_intervention - clinical_intervention)
    :precondition
      (and
        (prior_authorization_confirmed ?medication_supply_case)
        (case_assigned_clinical_intervention ?medication_supply_case ?clinical_intervention)
        (not
          (prior_authorization_verified ?medication_supply_case)
        )
      )
    :effect (prior_authorization_verified ?medication_supply_case)
  )
  (:action finalize_case_post_prior_authorization
    :parameters (?medication_supply_case - medication_supply_case)
    :precondition
      (and
        (prior_authorization_verified ?medication_supply_case)
        (not
          (case_finalized ?medication_supply_case)
        )
      )
    :effect
      (and
        (case_finalized ?medication_supply_case)
        (entity_ready_for_finalization ?medication_supply_case)
      )
  )
  (:action mark_technician_task_ready_for_finalization
    :parameters (?dispensing_technician_task - dispensing_technician_task ?medication_package - medication_package)
    :precondition
      (and
        (technician_task_allocated ?dispensing_technician_task)
        (technician_task_ready_for_assembly ?dispensing_technician_task)
        (medication_package_activated ?medication_package)
        (medication_package_activated_for_dispense ?medication_package)
        (not
          (entity_ready_for_finalization ?dispensing_technician_task)
        )
      )
    :effect (entity_ready_for_finalization ?dispensing_technician_task)
  )
  (:action mark_robot_task_ready_for_finalization
    :parameters (?dispensing_robot_task - dispensing_robot_task ?medication_package - medication_package)
    :precondition
      (and
        (robot_task_allocated ?dispensing_robot_task)
        (robot_task_ready_for_assembly ?dispensing_robot_task)
        (medication_package_activated ?medication_package)
        (medication_package_activated_for_dispense ?medication_package)
        (not
          (entity_ready_for_finalization ?dispensing_robot_task)
        )
      )
    :effect (entity_ready_for_finalization ?dispensing_robot_task)
  )
  (:action generate_patient_instructions_and_assign_counseling
    :parameters (?discharge_work_item - discharge_work_item ?counseling_material - counseling_material ?medication_product - medication_product)
    :precondition
      (and
        (entity_ready_for_finalization ?discharge_work_item)
        (entity_selected_medication_product ?discharge_work_item ?medication_product)
        (counseling_material_available ?counseling_material)
        (not
          (entity_instructions_generated ?discharge_work_item)
        )
      )
    :effect
      (and
        (entity_instructions_generated ?discharge_work_item)
        (entity_assigned_counseling_material ?discharge_work_item ?counseling_material)
        (not
          (counseling_material_available ?counseling_material)
        )
      )
  )
  (:action release_technician_task_after_instruction_assignment
    :parameters (?dispensing_technician_task - dispensing_technician_task ?pharmacist - pharmacist ?counseling_material - counseling_material)
    :precondition
      (and
        (entity_instructions_generated ?dispensing_technician_task)
        (entity_assigned_pharmacist ?dispensing_technician_task ?pharmacist)
        (entity_assigned_counseling_material ?dispensing_technician_task ?counseling_material)
        (not
          (entity_released_for_discharge ?dispensing_technician_task)
        )
      )
    :effect
      (and
        (entity_released_for_discharge ?dispensing_technician_task)
        (pharmacist_available ?pharmacist)
        (counseling_material_available ?counseling_material)
      )
  )
  (:action release_robot_task_after_instruction_assignment
    :parameters (?dispensing_robot_task - dispensing_robot_task ?pharmacist - pharmacist ?counseling_material - counseling_material)
    :precondition
      (and
        (entity_instructions_generated ?dispensing_robot_task)
        (entity_assigned_pharmacist ?dispensing_robot_task ?pharmacist)
        (entity_assigned_counseling_material ?dispensing_robot_task ?counseling_material)
        (not
          (entity_released_for_discharge ?dispensing_robot_task)
        )
      )
    :effect
      (and
        (entity_released_for_discharge ?dispensing_robot_task)
        (pharmacist_available ?pharmacist)
        (counseling_material_available ?counseling_material)
      )
  )
  (:action release_case_after_instruction_assignment
    :parameters (?medication_supply_case - medication_supply_case ?pharmacist - pharmacist ?counseling_material - counseling_material)
    :precondition
      (and
        (entity_instructions_generated ?medication_supply_case)
        (entity_assigned_pharmacist ?medication_supply_case ?pharmacist)
        (entity_assigned_counseling_material ?medication_supply_case ?counseling_material)
        (not
          (entity_released_for_discharge ?medication_supply_case)
        )
      )
    :effect
      (and
        (entity_released_for_discharge ?medication_supply_case)
        (pharmacist_available ?pharmacist)
        (counseling_material_available ?counseling_material)
      )
  )
)

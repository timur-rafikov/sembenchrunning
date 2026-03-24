(define (domain pharmaceutics_partial_fill_and_completion_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_entity_type - object item_and_resource_category - object label_and_unit_category - object order_grouping - object prescription_order - order_grouping medication_product - domain_entity_type dosage_instruction - domain_entity_type pharmacy_staff - domain_entity_type auxiliary_item_type - domain_entity_type special_handling_option - domain_entity_type patient_instruction_template - domain_entity_type compound_ingredient - domain_entity_type insurance_authorization_token - domain_entity_type packaging_material_type - item_and_resource_category packaging_material_instance - item_and_resource_category clinical_authorization_token - item_and_resource_category label_template_variant - label_and_unit_category auxiliary_label_variant - label_and_unit_category package_unit - label_and_unit_category prescription_subtype_initial - prescription_order prescription_subtype_subsequent - prescription_order initial_fill_segment - prescription_subtype_initial subsequent_fill_segment - prescription_subtype_initial dispensing_job - prescription_subtype_subsequent)
  (:predicates
    (order_received ?prescription_order - prescription_order)
    (entity_reviewed ?prescription_order - prescription_order)
    (product_selected_for_prescription ?prescription_order - prescription_order)
    (entity_finalized ?prescription_order - prescription_order)
    (ready_for_release ?prescription_order - prescription_order)
    (completion_planned_for_order ?prescription_order - prescription_order)
    (product_available ?medication_product - medication_product)
    (order_assigned_product ?prescription_order - prescription_order ?medication_product - medication_product)
    (dosage_instruction_available ?dosage_instruction - dosage_instruction)
    (assigned_dosage_instruction ?prescription_order - prescription_order ?dosage_instruction - dosage_instruction)
    (pharmacy_staff_available ?pharmacy_staff - pharmacy_staff)
    (assigned_pharmacy_staff ?prescription_order - prescription_order ?pharmacy_staff - pharmacy_staff)
    (packaging_material_type_available ?packaging_material_type - packaging_material_type)
    (allocated_packaging_type_initial_segment ?initial_fill_segment - initial_fill_segment ?packaging_material_type - packaging_material_type)
    (allocated_packaging_type_subsequent_segment ?subsequent_fill_segment - subsequent_fill_segment ?packaging_material_type - packaging_material_type)
    (segment_label_template_link ?initial_fill_segment - initial_fill_segment ?label_template_variant - label_template_variant)
    (label_template_reserved ?label_template_variant - label_template_variant)
    (label_template_assigned ?label_template_variant - label_template_variant)
    (initial_segment_ready ?initial_fill_segment - initial_fill_segment)
    (segment_aux_label_link ?subsequent_fill_segment - subsequent_fill_segment ?auxiliary_label_variant - auxiliary_label_variant)
    (aux_label_reserved ?auxiliary_label_variant - auxiliary_label_variant)
    (aux_label_assigned ?auxiliary_label_variant - auxiliary_label_variant)
    (subsequent_segment_ready ?subsequent_fill_segment - subsequent_fill_segment)
    (package_unit_available ?package_unit - package_unit)
    (package_unit_reserved ?package_unit - package_unit)
    (package_unit_has_label_template ?package_unit - package_unit ?label_template_variant - label_template_variant)
    (package_unit_has_aux_label ?package_unit - package_unit ?auxiliary_label_variant - auxiliary_label_variant)
    (package_unit_marked_partial_release ?package_unit - package_unit)
    (package_unit_marked_completion_release ?package_unit - package_unit)
    (package_unit_finalized ?package_unit - package_unit)
    (job_includes_initial_segment ?dispensing_job - dispensing_job ?initial_fill_segment - initial_fill_segment)
    (job_includes_subsequent_segment ?dispensing_job - dispensing_job ?subsequent_fill_segment - subsequent_fill_segment)
    (job_assigned_package_unit ?dispensing_job - dispensing_job ?package_unit - package_unit)
    (packaging_material_instance_available ?packaging_material_instance - packaging_material_instance)
    (job_allocated_packaging_material_instance ?dispensing_job - dispensing_job ?packaging_material_instance - packaging_material_instance)
    (packaging_material_instance_reserved ?packaging_material_instance - packaging_material_instance)
    (packaging_material_instance_assigned_to_package ?packaging_material_instance - packaging_material_instance ?package_unit - package_unit)
    (compound_allocation_completed ?dispensing_job - dispensing_job)
    (materials_verified_for_job ?dispensing_job - dispensing_job)
    (assembly_inspection_passed ?dispensing_job - dispensing_job)
    (auxiliary_item_reserved_for_job ?dispensing_job - dispensing_job)
    (auxiliary_item_attached_to_job ?dispensing_job - dispensing_job)
    (job_flagged_for_special_handling ?dispensing_job - dispensing_job)
    (final_quality_checks_passed ?dispensing_job - dispensing_job)
    (clinical_authorization_available ?clinical_authorization_token - clinical_authorization_token)
    (job_has_clinical_authorization ?dispensing_job - dispensing_job ?clinical_authorization_token - clinical_authorization_token)
    (clinical_authorization_attached ?dispensing_job - dispensing_job)
    (clinical_authorization_confirmed ?dispensing_job - dispensing_job)
    (clinical_authorization_finalized ?dispensing_job - dispensing_job)
    (auxiliary_item_type_available ?auxiliary_item_type - auxiliary_item_type)
    (auxiliary_item_assigned_to_job ?dispensing_job - dispensing_job ?auxiliary_item_type - auxiliary_item_type)
    (special_handling_option_available ?special_handling_option - special_handling_option)
    (job_assigned_special_handling_option ?dispensing_job - dispensing_job ?special_handling_option - special_handling_option)
    (compound_ingredient_available ?compound_ingredient - compound_ingredient)
    (job_reserved_compound_ingredient ?dispensing_job - dispensing_job ?compound_ingredient - compound_ingredient)
    (insurance_authorization_available ?insurance_authorization_token - insurance_authorization_token)
    (job_has_insurance_authorization ?dispensing_job - dispensing_job ?insurance_authorization_token - insurance_authorization_token)
    (patient_instruction_template_available ?patient_instruction_template - patient_instruction_template)
    (order_assigned_instruction_template ?prescription_order - prescription_order ?patient_instruction_template - patient_instruction_template)
    (initial_segment_marked_ready ?initial_fill_segment - initial_fill_segment)
    (subsequent_segment_marked_ready ?subsequent_fill_segment - subsequent_fill_segment)
    (job_release_logged ?dispensing_job - dispensing_job)
  )
  (:action register_prescription_intake
    :parameters (?prescription_order - prescription_order)
    :precondition
      (and
        (not
          (order_received ?prescription_order)
        )
        (not
          (entity_finalized ?prescription_order)
        )
      )
    :effect (order_received ?prescription_order)
  )
  (:action select_and_reserve_medication_product
    :parameters (?prescription_order - prescription_order ?medication_product - medication_product)
    :precondition
      (and
        (order_received ?prescription_order)
        (not
          (product_selected_for_prescription ?prescription_order)
        )
        (product_available ?medication_product)
      )
    :effect
      (and
        (product_selected_for_prescription ?prescription_order)
        (order_assigned_product ?prescription_order ?medication_product)
        (not
          (product_available ?medication_product)
        )
      )
  )
  (:action assign_dosage_instruction_to_prescription
    :parameters (?prescription_order - prescription_order ?dosage_instruction - dosage_instruction)
    :precondition
      (and
        (order_received ?prescription_order)
        (product_selected_for_prescription ?prescription_order)
        (dosage_instruction_available ?dosage_instruction)
      )
    :effect
      (and
        (assigned_dosage_instruction ?prescription_order ?dosage_instruction)
        (not
          (dosage_instruction_available ?dosage_instruction)
        )
      )
  )
  (:action complete_prescription_review
    :parameters (?prescription_order - prescription_order ?dosage_instruction - dosage_instruction)
    :precondition
      (and
        (order_received ?prescription_order)
        (product_selected_for_prescription ?prescription_order)
        (assigned_dosage_instruction ?prescription_order ?dosage_instruction)
        (not
          (entity_reviewed ?prescription_order)
        )
      )
    :effect (entity_reviewed ?prescription_order)
  )
  (:action release_assigned_dosage_instruction
    :parameters (?prescription_order - prescription_order ?dosage_instruction - dosage_instruction)
    :precondition
      (and
        (assigned_dosage_instruction ?prescription_order ?dosage_instruction)
      )
    :effect
      (and
        (dosage_instruction_available ?dosage_instruction)
        (not
          (assigned_dosage_instruction ?prescription_order ?dosage_instruction)
        )
      )
  )
  (:action assign_pharmacy_staff_to_prescription
    :parameters (?prescription_order - prescription_order ?pharmacy_staff - pharmacy_staff)
    :precondition
      (and
        (entity_reviewed ?prescription_order)
        (pharmacy_staff_available ?pharmacy_staff)
      )
    :effect
      (and
        (assigned_pharmacy_staff ?prescription_order ?pharmacy_staff)
        (not
          (pharmacy_staff_available ?pharmacy_staff)
        )
      )
  )
  (:action unassign_pharmacy_staff_from_prescription
    :parameters (?prescription_order - prescription_order ?pharmacy_staff - pharmacy_staff)
    :precondition
      (and
        (assigned_pharmacy_staff ?prescription_order ?pharmacy_staff)
      )
    :effect
      (and
        (pharmacy_staff_available ?pharmacy_staff)
        (not
          (assigned_pharmacy_staff ?prescription_order ?pharmacy_staff)
        )
      )
  )
  (:action reserve_compound_ingredient_for_job
    :parameters (?dispensing_job - dispensing_job ?compound_ingredient - compound_ingredient)
    :precondition
      (and
        (entity_reviewed ?dispensing_job)
        (compound_ingredient_available ?compound_ingredient)
      )
    :effect
      (and
        (job_reserved_compound_ingredient ?dispensing_job ?compound_ingredient)
        (not
          (compound_ingredient_available ?compound_ingredient)
        )
      )
  )
  (:action release_compound_ingredient_from_job
    :parameters (?dispensing_job - dispensing_job ?compound_ingredient - compound_ingredient)
    :precondition
      (and
        (job_reserved_compound_ingredient ?dispensing_job ?compound_ingredient)
      )
    :effect
      (and
        (compound_ingredient_available ?compound_ingredient)
        (not
          (job_reserved_compound_ingredient ?dispensing_job ?compound_ingredient)
        )
      )
  )
  (:action reserve_insurance_authorization_for_job
    :parameters (?dispensing_job - dispensing_job ?insurance_authorization_token - insurance_authorization_token)
    :precondition
      (and
        (entity_reviewed ?dispensing_job)
        (insurance_authorization_available ?insurance_authorization_token)
      )
    :effect
      (and
        (job_has_insurance_authorization ?dispensing_job ?insurance_authorization_token)
        (not
          (insurance_authorization_available ?insurance_authorization_token)
        )
      )
  )
  (:action release_insurance_authorization_from_job
    :parameters (?dispensing_job - dispensing_job ?insurance_authorization_token - insurance_authorization_token)
    :precondition
      (and
        (job_has_insurance_authorization ?dispensing_job ?insurance_authorization_token)
      )
    :effect
      (and
        (insurance_authorization_available ?insurance_authorization_token)
        (not
          (job_has_insurance_authorization ?dispensing_job ?insurance_authorization_token)
        )
      )
  )
  (:action reserve_label_template_for_initial_fill
    :parameters (?initial_fill_segment - initial_fill_segment ?label_template_variant - label_template_variant ?dosage_instruction - dosage_instruction)
    :precondition
      (and
        (entity_reviewed ?initial_fill_segment)
        (assigned_dosage_instruction ?initial_fill_segment ?dosage_instruction)
        (segment_label_template_link ?initial_fill_segment ?label_template_variant)
        (not
          (label_template_reserved ?label_template_variant)
        )
        (not
          (label_template_assigned ?label_template_variant)
        )
      )
    :effect (label_template_reserved ?label_template_variant)
  )
  (:action assign_staff_and_mark_initial_segment_ready
    :parameters (?initial_fill_segment - initial_fill_segment ?label_template_variant - label_template_variant ?pharmacy_staff - pharmacy_staff)
    :precondition
      (and
        (entity_reviewed ?initial_fill_segment)
        (assigned_pharmacy_staff ?initial_fill_segment ?pharmacy_staff)
        (segment_label_template_link ?initial_fill_segment ?label_template_variant)
        (label_template_reserved ?label_template_variant)
        (not
          (initial_segment_marked_ready ?initial_fill_segment)
        )
      )
    :effect
      (and
        (initial_segment_marked_ready ?initial_fill_segment)
        (initial_segment_ready ?initial_fill_segment)
      )
  )
  (:action allocate_packaging_and_mark_label_for_initial_fill
    :parameters (?initial_fill_segment - initial_fill_segment ?label_template_variant - label_template_variant ?packaging_material_type - packaging_material_type)
    :precondition
      (and
        (entity_reviewed ?initial_fill_segment)
        (segment_label_template_link ?initial_fill_segment ?label_template_variant)
        (packaging_material_type_available ?packaging_material_type)
        (not
          (initial_segment_marked_ready ?initial_fill_segment)
        )
      )
    :effect
      (and
        (label_template_assigned ?label_template_variant)
        (initial_segment_marked_ready ?initial_fill_segment)
        (allocated_packaging_type_initial_segment ?initial_fill_segment ?packaging_material_type)
        (not
          (packaging_material_type_available ?packaging_material_type)
        )
      )
  )
  (:action process_initial_fill_label_and_packaging
    :parameters (?initial_fill_segment - initial_fill_segment ?label_template_variant - label_template_variant ?dosage_instruction - dosage_instruction ?packaging_material_type - packaging_material_type)
    :precondition
      (and
        (entity_reviewed ?initial_fill_segment)
        (assigned_dosage_instruction ?initial_fill_segment ?dosage_instruction)
        (segment_label_template_link ?initial_fill_segment ?label_template_variant)
        (label_template_assigned ?label_template_variant)
        (allocated_packaging_type_initial_segment ?initial_fill_segment ?packaging_material_type)
        (not
          (initial_segment_ready ?initial_fill_segment)
        )
      )
    :effect
      (and
        (label_template_reserved ?label_template_variant)
        (initial_segment_ready ?initial_fill_segment)
        (packaging_material_type_available ?packaging_material_type)
        (not
          (allocated_packaging_type_initial_segment ?initial_fill_segment ?packaging_material_type)
        )
      )
  )
  (:action reserve_aux_label_for_subsequent_fill
    :parameters (?subsequent_fill_segment - subsequent_fill_segment ?auxiliary_label_variant - auxiliary_label_variant ?dosage_instruction - dosage_instruction)
    :precondition
      (and
        (entity_reviewed ?subsequent_fill_segment)
        (assigned_dosage_instruction ?subsequent_fill_segment ?dosage_instruction)
        (segment_aux_label_link ?subsequent_fill_segment ?auxiliary_label_variant)
        (not
          (aux_label_reserved ?auxiliary_label_variant)
        )
        (not
          (aux_label_assigned ?auxiliary_label_variant)
        )
      )
    :effect (aux_label_reserved ?auxiliary_label_variant)
  )
  (:action assign_staff_and_mark_subsequent_segment_ready
    :parameters (?subsequent_fill_segment - subsequent_fill_segment ?auxiliary_label_variant - auxiliary_label_variant ?pharmacy_staff - pharmacy_staff)
    :precondition
      (and
        (entity_reviewed ?subsequent_fill_segment)
        (assigned_pharmacy_staff ?subsequent_fill_segment ?pharmacy_staff)
        (segment_aux_label_link ?subsequent_fill_segment ?auxiliary_label_variant)
        (aux_label_reserved ?auxiliary_label_variant)
        (not
          (subsequent_segment_marked_ready ?subsequent_fill_segment)
        )
      )
    :effect
      (and
        (subsequent_segment_marked_ready ?subsequent_fill_segment)
        (subsequent_segment_ready ?subsequent_fill_segment)
      )
  )
  (:action allocate_packaging_and_mark_aux_label_for_subsequent_fill
    :parameters (?subsequent_fill_segment - subsequent_fill_segment ?auxiliary_label_variant - auxiliary_label_variant ?packaging_material_type - packaging_material_type)
    :precondition
      (and
        (entity_reviewed ?subsequent_fill_segment)
        (segment_aux_label_link ?subsequent_fill_segment ?auxiliary_label_variant)
        (packaging_material_type_available ?packaging_material_type)
        (not
          (subsequent_segment_marked_ready ?subsequent_fill_segment)
        )
      )
    :effect
      (and
        (aux_label_assigned ?auxiliary_label_variant)
        (subsequent_segment_marked_ready ?subsequent_fill_segment)
        (allocated_packaging_type_subsequent_segment ?subsequent_fill_segment ?packaging_material_type)
        (not
          (packaging_material_type_available ?packaging_material_type)
        )
      )
  )
  (:action process_subsequent_fill_label_and_packaging
    :parameters (?subsequent_fill_segment - subsequent_fill_segment ?auxiliary_label_variant - auxiliary_label_variant ?dosage_instruction - dosage_instruction ?packaging_material_type - packaging_material_type)
    :precondition
      (and
        (entity_reviewed ?subsequent_fill_segment)
        (assigned_dosage_instruction ?subsequent_fill_segment ?dosage_instruction)
        (segment_aux_label_link ?subsequent_fill_segment ?auxiliary_label_variant)
        (aux_label_assigned ?auxiliary_label_variant)
        (allocated_packaging_type_subsequent_segment ?subsequent_fill_segment ?packaging_material_type)
        (not
          (subsequent_segment_ready ?subsequent_fill_segment)
        )
      )
    :effect
      (and
        (aux_label_reserved ?auxiliary_label_variant)
        (subsequent_segment_ready ?subsequent_fill_segment)
        (packaging_material_type_available ?packaging_material_type)
        (not
          (allocated_packaging_type_subsequent_segment ?subsequent_fill_segment ?packaging_material_type)
        )
      )
  )
  (:action assemble_package_unit_standard
    :parameters (?initial_fill_segment - initial_fill_segment ?subsequent_fill_segment - subsequent_fill_segment ?label_template_variant - label_template_variant ?auxiliary_label_variant - auxiliary_label_variant ?package_unit - package_unit)
    :precondition
      (and
        (initial_segment_marked_ready ?initial_fill_segment)
        (subsequent_segment_marked_ready ?subsequent_fill_segment)
        (segment_label_template_link ?initial_fill_segment ?label_template_variant)
        (segment_aux_label_link ?subsequent_fill_segment ?auxiliary_label_variant)
        (label_template_reserved ?label_template_variant)
        (aux_label_reserved ?auxiliary_label_variant)
        (initial_segment_ready ?initial_fill_segment)
        (subsequent_segment_ready ?subsequent_fill_segment)
        (package_unit_available ?package_unit)
      )
    :effect
      (and
        (package_unit_reserved ?package_unit)
        (package_unit_has_label_template ?package_unit ?label_template_variant)
        (package_unit_has_aux_label ?package_unit ?auxiliary_label_variant)
        (not
          (package_unit_available ?package_unit)
        )
      )
  )
  (:action assemble_package_unit_with_partial_marker
    :parameters (?initial_fill_segment - initial_fill_segment ?subsequent_fill_segment - subsequent_fill_segment ?label_template_variant - label_template_variant ?auxiliary_label_variant - auxiliary_label_variant ?package_unit - package_unit)
    :precondition
      (and
        (initial_segment_marked_ready ?initial_fill_segment)
        (subsequent_segment_marked_ready ?subsequent_fill_segment)
        (segment_label_template_link ?initial_fill_segment ?label_template_variant)
        (segment_aux_label_link ?subsequent_fill_segment ?auxiliary_label_variant)
        (label_template_assigned ?label_template_variant)
        (aux_label_reserved ?auxiliary_label_variant)
        (not
          (initial_segment_ready ?initial_fill_segment)
        )
        (subsequent_segment_ready ?subsequent_fill_segment)
        (package_unit_available ?package_unit)
      )
    :effect
      (and
        (package_unit_reserved ?package_unit)
        (package_unit_has_label_template ?package_unit ?label_template_variant)
        (package_unit_has_aux_label ?package_unit ?auxiliary_label_variant)
        (package_unit_marked_partial_release ?package_unit)
        (not
          (package_unit_available ?package_unit)
        )
      )
  )
  (:action assemble_package_unit_with_completion_marker
    :parameters (?initial_fill_segment - initial_fill_segment ?subsequent_fill_segment - subsequent_fill_segment ?label_template_variant - label_template_variant ?auxiliary_label_variant - auxiliary_label_variant ?package_unit - package_unit)
    :precondition
      (and
        (initial_segment_marked_ready ?initial_fill_segment)
        (subsequent_segment_marked_ready ?subsequent_fill_segment)
        (segment_label_template_link ?initial_fill_segment ?label_template_variant)
        (segment_aux_label_link ?subsequent_fill_segment ?auxiliary_label_variant)
        (label_template_reserved ?label_template_variant)
        (aux_label_assigned ?auxiliary_label_variant)
        (initial_segment_ready ?initial_fill_segment)
        (not
          (subsequent_segment_ready ?subsequent_fill_segment)
        )
        (package_unit_available ?package_unit)
      )
    :effect
      (and
        (package_unit_reserved ?package_unit)
        (package_unit_has_label_template ?package_unit ?label_template_variant)
        (package_unit_has_aux_label ?package_unit ?auxiliary_label_variant)
        (package_unit_marked_completion_release ?package_unit)
        (not
          (package_unit_available ?package_unit)
        )
      )
  )
  (:action assemble_package_unit_with_partial_and_completion_markers
    :parameters (?initial_fill_segment - initial_fill_segment ?subsequent_fill_segment - subsequent_fill_segment ?label_template_variant - label_template_variant ?auxiliary_label_variant - auxiliary_label_variant ?package_unit - package_unit)
    :precondition
      (and
        (initial_segment_marked_ready ?initial_fill_segment)
        (subsequent_segment_marked_ready ?subsequent_fill_segment)
        (segment_label_template_link ?initial_fill_segment ?label_template_variant)
        (segment_aux_label_link ?subsequent_fill_segment ?auxiliary_label_variant)
        (label_template_assigned ?label_template_variant)
        (aux_label_assigned ?auxiliary_label_variant)
        (not
          (initial_segment_ready ?initial_fill_segment)
        )
        (not
          (subsequent_segment_ready ?subsequent_fill_segment)
        )
        (package_unit_available ?package_unit)
      )
    :effect
      (and
        (package_unit_reserved ?package_unit)
        (package_unit_has_label_template ?package_unit ?label_template_variant)
        (package_unit_has_aux_label ?package_unit ?auxiliary_label_variant)
        (package_unit_marked_partial_release ?package_unit)
        (package_unit_marked_completion_release ?package_unit)
        (not
          (package_unit_available ?package_unit)
        )
      )
  )
  (:action finalize_package_unit
    :parameters (?package_unit - package_unit ?initial_fill_segment - initial_fill_segment ?dosage_instruction - dosage_instruction)
    :precondition
      (and
        (package_unit_reserved ?package_unit)
        (initial_segment_marked_ready ?initial_fill_segment)
        (assigned_dosage_instruction ?initial_fill_segment ?dosage_instruction)
        (not
          (package_unit_finalized ?package_unit)
        )
      )
    :effect (package_unit_finalized ?package_unit)
  )
  (:action reserve_packaging_material_instance_for_job
    :parameters (?dispensing_job - dispensing_job ?packaging_material_instance - packaging_material_instance ?package_unit - package_unit)
    :precondition
      (and
        (entity_reviewed ?dispensing_job)
        (job_assigned_package_unit ?dispensing_job ?package_unit)
        (job_allocated_packaging_material_instance ?dispensing_job ?packaging_material_instance)
        (packaging_material_instance_available ?packaging_material_instance)
        (package_unit_reserved ?package_unit)
        (package_unit_finalized ?package_unit)
        (not
          (packaging_material_instance_reserved ?packaging_material_instance)
        )
      )
    :effect
      (and
        (packaging_material_instance_reserved ?packaging_material_instance)
        (packaging_material_instance_assigned_to_package ?packaging_material_instance ?package_unit)
        (not
          (packaging_material_instance_available ?packaging_material_instance)
        )
      )
  )
  (:action confirm_packaging_and_mark_job
    :parameters (?dispensing_job - dispensing_job ?packaging_material_instance - packaging_material_instance ?package_unit - package_unit ?dosage_instruction - dosage_instruction)
    :precondition
      (and
        (entity_reviewed ?dispensing_job)
        (job_allocated_packaging_material_instance ?dispensing_job ?packaging_material_instance)
        (packaging_material_instance_reserved ?packaging_material_instance)
        (packaging_material_instance_assigned_to_package ?packaging_material_instance ?package_unit)
        (assigned_dosage_instruction ?dispensing_job ?dosage_instruction)
        (not
          (package_unit_marked_partial_release ?package_unit)
        )
        (not
          (compound_allocation_completed ?dispensing_job)
        )
      )
    :effect (compound_allocation_completed ?dispensing_job)
  )
  (:action reserve_auxiliary_item_for_job
    :parameters (?dispensing_job - dispensing_job ?auxiliary_item_type - auxiliary_item_type)
    :precondition
      (and
        (entity_reviewed ?dispensing_job)
        (auxiliary_item_type_available ?auxiliary_item_type)
        (not
          (auxiliary_item_reserved_for_job ?dispensing_job)
        )
      )
    :effect
      (and
        (auxiliary_item_reserved_for_job ?dispensing_job)
        (auxiliary_item_assigned_to_job ?dispensing_job ?auxiliary_item_type)
        (not
          (auxiliary_item_type_available ?auxiliary_item_type)
        )
      )
  )
  (:action attach_auxiliary_item_and_mark_job
    :parameters (?dispensing_job - dispensing_job ?packaging_material_instance - packaging_material_instance ?package_unit - package_unit ?dosage_instruction - dosage_instruction ?auxiliary_item_type - auxiliary_item_type)
    :precondition
      (and
        (entity_reviewed ?dispensing_job)
        (job_allocated_packaging_material_instance ?dispensing_job ?packaging_material_instance)
        (packaging_material_instance_reserved ?packaging_material_instance)
        (packaging_material_instance_assigned_to_package ?packaging_material_instance ?package_unit)
        (assigned_dosage_instruction ?dispensing_job ?dosage_instruction)
        (package_unit_marked_partial_release ?package_unit)
        (auxiliary_item_reserved_for_job ?dispensing_job)
        (auxiliary_item_assigned_to_job ?dispensing_job ?auxiliary_item_type)
        (not
          (compound_allocation_completed ?dispensing_job)
        )
      )
    :effect
      (and
        (compound_allocation_completed ?dispensing_job)
        (auxiliary_item_attached_to_job ?dispensing_job)
      )
  )
  (:action allocate_compound_ingredient_for_job
    :parameters (?dispensing_job - dispensing_job ?compound_ingredient - compound_ingredient ?pharmacy_staff - pharmacy_staff ?packaging_material_instance - packaging_material_instance ?package_unit - package_unit)
    :precondition
      (and
        (compound_allocation_completed ?dispensing_job)
        (job_reserved_compound_ingredient ?dispensing_job ?compound_ingredient)
        (assigned_pharmacy_staff ?dispensing_job ?pharmacy_staff)
        (job_allocated_packaging_material_instance ?dispensing_job ?packaging_material_instance)
        (packaging_material_instance_assigned_to_package ?packaging_material_instance ?package_unit)
        (not
          (package_unit_marked_completion_release ?package_unit)
        )
        (not
          (materials_verified_for_job ?dispensing_job)
        )
      )
    :effect (materials_verified_for_job ?dispensing_job)
  )
  (:action allocate_compound_ingredient_for_job_path_b
    :parameters (?dispensing_job - dispensing_job ?compound_ingredient - compound_ingredient ?pharmacy_staff - pharmacy_staff ?packaging_material_instance - packaging_material_instance ?package_unit - package_unit)
    :precondition
      (and
        (compound_allocation_completed ?dispensing_job)
        (job_reserved_compound_ingredient ?dispensing_job ?compound_ingredient)
        (assigned_pharmacy_staff ?dispensing_job ?pharmacy_staff)
        (job_allocated_packaging_material_instance ?dispensing_job ?packaging_material_instance)
        (packaging_material_instance_assigned_to_package ?packaging_material_instance ?package_unit)
        (package_unit_marked_completion_release ?package_unit)
        (not
          (materials_verified_for_job ?dispensing_job)
        )
      )
    :effect (materials_verified_for_job ?dispensing_job)
  )
  (:action perform_assembly_inspection_for_job
    :parameters (?dispensing_job - dispensing_job ?insurance_authorization_token - insurance_authorization_token ?packaging_material_instance - packaging_material_instance ?package_unit - package_unit)
    :precondition
      (and
        (materials_verified_for_job ?dispensing_job)
        (job_has_insurance_authorization ?dispensing_job ?insurance_authorization_token)
        (job_allocated_packaging_material_instance ?dispensing_job ?packaging_material_instance)
        (packaging_material_instance_assigned_to_package ?packaging_material_instance ?package_unit)
        (not
          (package_unit_marked_partial_release ?package_unit)
        )
        (not
          (package_unit_marked_completion_release ?package_unit)
        )
        (not
          (assembly_inspection_passed ?dispensing_job)
        )
      )
    :effect (assembly_inspection_passed ?dispensing_job)
  )
  (:action perform_assembly_inspection_and_flag_for_handling
    :parameters (?dispensing_job - dispensing_job ?insurance_authorization_token - insurance_authorization_token ?packaging_material_instance - packaging_material_instance ?package_unit - package_unit)
    :precondition
      (and
        (materials_verified_for_job ?dispensing_job)
        (job_has_insurance_authorization ?dispensing_job ?insurance_authorization_token)
        (job_allocated_packaging_material_instance ?dispensing_job ?packaging_material_instance)
        (packaging_material_instance_assigned_to_package ?packaging_material_instance ?package_unit)
        (package_unit_marked_partial_release ?package_unit)
        (not
          (package_unit_marked_completion_release ?package_unit)
        )
        (not
          (assembly_inspection_passed ?dispensing_job)
        )
      )
    :effect
      (and
        (assembly_inspection_passed ?dispensing_job)
        (job_flagged_for_special_handling ?dispensing_job)
      )
  )
  (:action perform_alternate_inspection_and_flag
    :parameters (?dispensing_job - dispensing_job ?insurance_authorization_token - insurance_authorization_token ?packaging_material_instance - packaging_material_instance ?package_unit - package_unit)
    :precondition
      (and
        (materials_verified_for_job ?dispensing_job)
        (job_has_insurance_authorization ?dispensing_job ?insurance_authorization_token)
        (job_allocated_packaging_material_instance ?dispensing_job ?packaging_material_instance)
        (packaging_material_instance_assigned_to_package ?packaging_material_instance ?package_unit)
        (not
          (package_unit_marked_partial_release ?package_unit)
        )
        (package_unit_marked_completion_release ?package_unit)
        (not
          (assembly_inspection_passed ?dispensing_job)
        )
      )
    :effect
      (and
        (assembly_inspection_passed ?dispensing_job)
        (job_flagged_for_special_handling ?dispensing_job)
      )
  )
  (:action perform_combined_inspection_and_flag
    :parameters (?dispensing_job - dispensing_job ?insurance_authorization_token - insurance_authorization_token ?packaging_material_instance - packaging_material_instance ?package_unit - package_unit)
    :precondition
      (and
        (materials_verified_for_job ?dispensing_job)
        (job_has_insurance_authorization ?dispensing_job ?insurance_authorization_token)
        (job_allocated_packaging_material_instance ?dispensing_job ?packaging_material_instance)
        (packaging_material_instance_assigned_to_package ?packaging_material_instance ?package_unit)
        (package_unit_marked_partial_release ?package_unit)
        (package_unit_marked_completion_release ?package_unit)
        (not
          (assembly_inspection_passed ?dispensing_job)
        )
      )
    :effect
      (and
        (assembly_inspection_passed ?dispensing_job)
        (job_flagged_for_special_handling ?dispensing_job)
      )
  )
  (:action log_job_release_and_mark_ready
    :parameters (?dispensing_job - dispensing_job)
    :precondition
      (and
        (assembly_inspection_passed ?dispensing_job)
        (not
          (job_flagged_for_special_handling ?dispensing_job)
        )
        (not
          (job_release_logged ?dispensing_job)
        )
      )
    :effect
      (and
        (job_release_logged ?dispensing_job)
        (ready_for_release ?dispensing_job)
      )
  )
  (:action assign_special_handling_to_job
    :parameters (?dispensing_job - dispensing_job ?special_handling_option - special_handling_option)
    :precondition
      (and
        (assembly_inspection_passed ?dispensing_job)
        (job_flagged_for_special_handling ?dispensing_job)
        (special_handling_option_available ?special_handling_option)
      )
    :effect
      (and
        (job_assigned_special_handling_option ?dispensing_job ?special_handling_option)
        (not
          (special_handling_option_available ?special_handling_option)
        )
      )
  )
  (:action complete_job_pre_release_checks
    :parameters (?dispensing_job - dispensing_job ?initial_fill_segment - initial_fill_segment ?subsequent_fill_segment - subsequent_fill_segment ?dosage_instruction - dosage_instruction ?special_handling_option - special_handling_option)
    :precondition
      (and
        (assembly_inspection_passed ?dispensing_job)
        (job_flagged_for_special_handling ?dispensing_job)
        (job_assigned_special_handling_option ?dispensing_job ?special_handling_option)
        (job_includes_initial_segment ?dispensing_job ?initial_fill_segment)
        (job_includes_subsequent_segment ?dispensing_job ?subsequent_fill_segment)
        (initial_segment_ready ?initial_fill_segment)
        (subsequent_segment_ready ?subsequent_fill_segment)
        (assigned_dosage_instruction ?dispensing_job ?dosage_instruction)
        (not
          (final_quality_checks_passed ?dispensing_job)
        )
      )
    :effect (final_quality_checks_passed ?dispensing_job)
  )
  (:action log_job_release_after_checks
    :parameters (?dispensing_job - dispensing_job)
    :precondition
      (and
        (assembly_inspection_passed ?dispensing_job)
        (final_quality_checks_passed ?dispensing_job)
        (not
          (job_release_logged ?dispensing_job)
        )
      )
    :effect
      (and
        (job_release_logged ?dispensing_job)
        (ready_for_release ?dispensing_job)
      )
  )
  (:action apply_clinical_authorization_to_job
    :parameters (?dispensing_job - dispensing_job ?clinical_authorization_token - clinical_authorization_token ?dosage_instruction - dosage_instruction)
    :precondition
      (and
        (entity_reviewed ?dispensing_job)
        (assigned_dosage_instruction ?dispensing_job ?dosage_instruction)
        (clinical_authorization_available ?clinical_authorization_token)
        (job_has_clinical_authorization ?dispensing_job ?clinical_authorization_token)
        (not
          (clinical_authorization_attached ?dispensing_job)
        )
      )
    :effect
      (and
        (clinical_authorization_attached ?dispensing_job)
        (not
          (clinical_authorization_available ?clinical_authorization_token)
        )
      )
  )
  (:action acknowledge_clinical_authorization_by_staff
    :parameters (?dispensing_job - dispensing_job ?pharmacy_staff - pharmacy_staff)
    :precondition
      (and
        (clinical_authorization_attached ?dispensing_job)
        (assigned_pharmacy_staff ?dispensing_job ?pharmacy_staff)
        (not
          (clinical_authorization_confirmed ?dispensing_job)
        )
      )
    :effect (clinical_authorization_confirmed ?dispensing_job)
  )
  (:action confirm_insurance_authorization_for_job
    :parameters (?dispensing_job - dispensing_job ?insurance_authorization_token - insurance_authorization_token)
    :precondition
      (and
        (clinical_authorization_confirmed ?dispensing_job)
        (job_has_insurance_authorization ?dispensing_job ?insurance_authorization_token)
        (not
          (clinical_authorization_finalized ?dispensing_job)
        )
      )
    :effect (clinical_authorization_finalized ?dispensing_job)
  )
  (:action log_authorization_and_mark_release_ready
    :parameters (?dispensing_job - dispensing_job)
    :precondition
      (and
        (clinical_authorization_finalized ?dispensing_job)
        (not
          (job_release_logged ?dispensing_job)
        )
      )
    :effect
      (and
        (job_release_logged ?dispensing_job)
        (ready_for_release ?dispensing_job)
      )
  )
  (:action mark_initial_segment_ready_for_release
    :parameters (?initial_fill_segment - initial_fill_segment ?package_unit - package_unit)
    :precondition
      (and
        (initial_segment_marked_ready ?initial_fill_segment)
        (initial_segment_ready ?initial_fill_segment)
        (package_unit_reserved ?package_unit)
        (package_unit_finalized ?package_unit)
        (not
          (ready_for_release ?initial_fill_segment)
        )
      )
    :effect (ready_for_release ?initial_fill_segment)
  )
  (:action mark_subsequent_segment_ready_for_release
    :parameters (?subsequent_fill_segment - subsequent_fill_segment ?package_unit - package_unit)
    :precondition
      (and
        (subsequent_segment_marked_ready ?subsequent_fill_segment)
        (subsequent_segment_ready ?subsequent_fill_segment)
        (package_unit_reserved ?package_unit)
        (package_unit_finalized ?package_unit)
        (not
          (ready_for_release ?subsequent_fill_segment)
        )
      )
    :effect (ready_for_release ?subsequent_fill_segment)
  )
  (:action generate_and_assign_patient_instructions
    :parameters (?prescription_order - prescription_order ?patient_instruction_template - patient_instruction_template ?dosage_instruction - dosage_instruction)
    :precondition
      (and
        (ready_for_release ?prescription_order)
        (assigned_dosage_instruction ?prescription_order ?dosage_instruction)
        (patient_instruction_template_available ?patient_instruction_template)
        (not
          (completion_planned_for_order ?prescription_order)
        )
      )
    :effect
      (and
        (completion_planned_for_order ?prescription_order)
        (order_assigned_instruction_template ?prescription_order ?patient_instruction_template)
        (not
          (patient_instruction_template_available ?patient_instruction_template)
        )
      )
  )
  (:action complete_initial_fill_segment_and_return_resources
    :parameters (?initial_fill_segment - initial_fill_segment ?medication_product - medication_product ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (completion_planned_for_order ?initial_fill_segment)
        (order_assigned_product ?initial_fill_segment ?medication_product)
        (order_assigned_instruction_template ?initial_fill_segment ?patient_instruction_template)
        (not
          (entity_finalized ?initial_fill_segment)
        )
      )
    :effect
      (and
        (entity_finalized ?initial_fill_segment)
        (product_available ?medication_product)
        (patient_instruction_template_available ?patient_instruction_template)
      )
  )
  (:action complete_subsequent_fill_segment_and_return_resources
    :parameters (?subsequent_fill_segment - subsequent_fill_segment ?medication_product - medication_product ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (completion_planned_for_order ?subsequent_fill_segment)
        (order_assigned_product ?subsequent_fill_segment ?medication_product)
        (order_assigned_instruction_template ?subsequent_fill_segment ?patient_instruction_template)
        (not
          (entity_finalized ?subsequent_fill_segment)
        )
      )
    :effect
      (and
        (entity_finalized ?subsequent_fill_segment)
        (product_available ?medication_product)
        (patient_instruction_template_available ?patient_instruction_template)
      )
  )
  (:action complete_dispensing_job_and_return_resources
    :parameters (?dispensing_job - dispensing_job ?medication_product - medication_product ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (completion_planned_for_order ?dispensing_job)
        (order_assigned_product ?dispensing_job ?medication_product)
        (order_assigned_instruction_template ?dispensing_job ?patient_instruction_template)
        (not
          (entity_finalized ?dispensing_job)
        )
      )
    :effect
      (and
        (entity_finalized ?dispensing_job)
        (product_available ?medication_product)
        (patient_instruction_template_available ?patient_instruction_template)
      )
  )
)

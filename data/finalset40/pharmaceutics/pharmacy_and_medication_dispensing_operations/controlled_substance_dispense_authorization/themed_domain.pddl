(define (domain controlled_substance_dispense_authorization)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_group - object inventory_element_group - object labeling_element_group - object prescription_root - object pharmacy_entity - prescription_root authorization_token - resource_group drug_product - resource_group review_station - resource_group special_handling_instruction - resource_group patient_instruction_template - resource_group patient_profile - resource_group compound_batch - resource_group regulatory_flag - resource_group packaging_component - inventory_element_group auxiliary_label - inventory_element_group clinical_check_item - inventory_element_group controlled_stock_bin - labeling_element_group label_template - labeling_element_group medication_package - labeling_element_group technician_role_subtype - pharmacy_entity dispense_record_root - pharmacy_entity pharmacy_technician - technician_role_subtype pharmacist - technician_role_subtype dispense_record - dispense_record_root)
  (:predicates
    (prescription_intake_recorded ?prescription - pharmacy_entity)
    (entity_clinically_verified ?prescription - pharmacy_entity)
    (authorization_attached ?prescription - pharmacy_entity)
    (entity_dispense_authorized ?prescription - pharmacy_entity)
    (entity_verification_complete ?prescription - pharmacy_entity)
    (entity_dispense_authorization_created ?prescription - pharmacy_entity)
    (authorization_token_available ?authorization_token - authorization_token)
    (auth_token_linked_to_entity ?prescription - pharmacy_entity ?authorization_token - authorization_token)
    (drug_product_available ?drug_product - drug_product)
    (entity_assigned_product ?prescription - pharmacy_entity ?drug_product - drug_product)
    (review_station_available ?review_station - review_station)
    (review_station_assigned ?prescription - pharmacy_entity ?review_station - review_station)
    (packaging_component_available ?packaging_component - packaging_component)
    (component_reserved_for_technician ?pharmacy_technician - pharmacy_technician ?packaging_component - packaging_component)
    (component_reserved_for_pharmacist ?pharmacist - pharmacist ?packaging_component - packaging_component)
    (stock_bin_selected ?pharmacy_technician - pharmacy_technician ?controlled_stock_bin - controlled_stock_bin)
    (primary_stock_bin_selected ?controlled_stock_bin - controlled_stock_bin)
    (alternate_stock_bin_selected ?controlled_stock_bin - controlled_stock_bin)
    (technician_stock_verified ?pharmacy_technician - pharmacy_technician)
    (label_template_linked_to_pharmacist ?pharmacist - pharmacist ?label_template - label_template)
    (label_template_selected ?label_template - label_template)
    (label_template_alternate_selected ?label_template - label_template)
    (pharmacist_stock_verified ?pharmacist - pharmacist)
    (medication_package_available ?medication_package - medication_package)
    (medication_package_reserved ?medication_package - medication_package)
    (package_assigned_stock_bin ?medication_package - medication_package ?controlled_stock_bin - controlled_stock_bin)
    (package_assigned_label_template ?medication_package - medication_package ?label_template - label_template)
    (package_requires_auxiliary_label ?medication_package - medication_package)
    (package_requires_special_handling ?medication_package - medication_package)
    (package_ready_for_auxiliary_attachment ?medication_package - medication_package)
    (dispense_record_assigned_technician ?dispense_record - dispense_record ?pharmacy_technician - pharmacy_technician)
    (dispense_record_assigned_pharmacist ?dispense_record - dispense_record ?pharmacist - pharmacist)
    (dispense_record_assigned_package ?dispense_record - dispense_record ?medication_package - medication_package)
    (auxiliary_label_available ?auxiliary_label - auxiliary_label)
    (auxiliary_label_linked_to_record ?dispense_record - dispense_record ?auxiliary_label - auxiliary_label)
    (auxiliary_label_attached ?auxiliary_label - auxiliary_label)
    (auxiliary_label_attached_to_package ?auxiliary_label - auxiliary_label ?medication_package - medication_package)
    (dispense_record_materials_ready ?dispense_record - dispense_record)
    (dispense_record_assembly_completed ?dispense_record - dispense_record)
    (clinical_checklist_initiated ?dispense_record - dispense_record)
    (special_handling_assigned ?dispense_record - dispense_record)
    (special_handling_confirmed ?dispense_record - dispense_record)
    (patient_instruction_binding_required ?dispense_record - dispense_record)
    (multidisciplinary_verification_completed ?dispense_record - dispense_record)
    (clinical_check_item_available ?clinical_check_item - clinical_check_item)
    (clinical_check_item_linked_to_record ?dispense_record - dispense_record ?clinical_check_item - clinical_check_item)
    (clinical_check_assigned ?dispense_record - dispense_record)
    (clinical_check_in_progress ?dispense_record - dispense_record)
    (clinical_check_completed ?dispense_record - dispense_record)
    (special_handling_instruction_available ?special_handling_instruction - special_handling_instruction)
    (special_handling_instruction_linked_to_record ?dispense_record - dispense_record ?special_handling_instruction - special_handling_instruction)
    (patient_instruction_template_available ?patient_instruction_template - patient_instruction_template)
    (patient_instruction_template_attached_to_record ?dispense_record - dispense_record ?patient_instruction_template - patient_instruction_template)
    (compound_batch_available ?compound_batch - compound_batch)
    (compound_batch_assigned_to_record ?dispense_record - dispense_record ?compound_batch - compound_batch)
    (regulatory_flag_available ?regulatory_flag - regulatory_flag)
    (regulatory_flag_attached ?dispense_record - dispense_record ?regulatory_flag - regulatory_flag)
    (patient_profile_available ?patient_profile - patient_profile)
    (patient_profile_linked ?prescription - pharmacy_entity ?patient_profile - patient_profile)
    (technician_packaging_ready ?pharmacy_technician - pharmacy_technician)
    (pharmacist_packaging_ready ?pharmacist - pharmacist)
    (dispense_record_finalized ?dispense_record - dispense_record)
  )
  (:action record_pharmacy_entity_intake
    :parameters (?prescription - pharmacy_entity)
    :precondition
      (and
        (not
          (prescription_intake_recorded ?prescription)
        )
        (not
          (entity_dispense_authorized ?prescription)
        )
      )
    :effect (prescription_intake_recorded ?prescription)
  )
  (:action assign_authorization_token_to_pharmacy_entity
    :parameters (?prescription - pharmacy_entity ?authorization_token - authorization_token)
    :precondition
      (and
        (prescription_intake_recorded ?prescription)
        (not
          (authorization_attached ?prescription)
        )
        (authorization_token_available ?authorization_token)
      )
    :effect
      (and
        (authorization_attached ?prescription)
        (auth_token_linked_to_entity ?prescription ?authorization_token)
        (not
          (authorization_token_available ?authorization_token)
        )
      )
  )
  (:action assign_drug_product_to_pharmacy_entity
    :parameters (?prescription - pharmacy_entity ?drug_product - drug_product)
    :precondition
      (and
        (prescription_intake_recorded ?prescription)
        (authorization_attached ?prescription)
        (drug_product_available ?drug_product)
      )
    :effect
      (and
        (entity_assigned_product ?prescription ?drug_product)
        (not
          (drug_product_available ?drug_product)
        )
      )
  )
  (:action mark_pharmacy_entity_clinically_verified
    :parameters (?prescription - pharmacy_entity ?drug_product - drug_product)
    :precondition
      (and
        (prescription_intake_recorded ?prescription)
        (authorization_attached ?prescription)
        (entity_assigned_product ?prescription ?drug_product)
        (not
          (entity_clinically_verified ?prescription)
        )
      )
    :effect (entity_clinically_verified ?prescription)
  )
  (:action revert_drug_product_assignment_from_pharmacy_entity
    :parameters (?prescription - pharmacy_entity ?drug_product - drug_product)
    :precondition
      (and
        (entity_assigned_product ?prescription ?drug_product)
      )
    :effect
      (and
        (drug_product_available ?drug_product)
        (not
          (entity_assigned_product ?prescription ?drug_product)
        )
      )
  )
  (:action assign_review_station_to_pharmacy_entity
    :parameters (?prescription - pharmacy_entity ?review_station - review_station)
    :precondition
      (and
        (entity_clinically_verified ?prescription)
        (review_station_available ?review_station)
      )
    :effect
      (and
        (review_station_assigned ?prescription ?review_station)
        (not
          (review_station_available ?review_station)
        )
      )
  )
  (:action unassign_review_station_from_pharmacy_entity
    :parameters (?prescription - pharmacy_entity ?review_station - review_station)
    :precondition
      (and
        (review_station_assigned ?prescription ?review_station)
      )
    :effect
      (and
        (review_station_available ?review_station)
        (not
          (review_station_assigned ?prescription ?review_station)
        )
      )
  )
  (:action reserve_compound_batch_for_dispense
    :parameters (?dispense_record - dispense_record ?compound_batch - compound_batch)
    :precondition
      (and
        (entity_clinically_verified ?dispense_record)
        (compound_batch_available ?compound_batch)
      )
    :effect
      (and
        (compound_batch_assigned_to_record ?dispense_record ?compound_batch)
        (not
          (compound_batch_available ?compound_batch)
        )
      )
  )
  (:action release_compound_batch_from_dispense
    :parameters (?dispense_record - dispense_record ?compound_batch - compound_batch)
    :precondition
      (and
        (compound_batch_assigned_to_record ?dispense_record ?compound_batch)
      )
    :effect
      (and
        (compound_batch_available ?compound_batch)
        (not
          (compound_batch_assigned_to_record ?dispense_record ?compound_batch)
        )
      )
  )
  (:action attach_regulatory_flag_to_dispense_record
    :parameters (?dispense_record - dispense_record ?regulatory_flag - regulatory_flag)
    :precondition
      (and
        (entity_clinically_verified ?dispense_record)
        (regulatory_flag_available ?regulatory_flag)
      )
    :effect
      (and
        (regulatory_flag_attached ?dispense_record ?regulatory_flag)
        (not
          (regulatory_flag_available ?regulatory_flag)
        )
      )
  )
  (:action detach_regulatory_flag_from_dispense_record
    :parameters (?dispense_record - dispense_record ?regulatory_flag - regulatory_flag)
    :precondition
      (and
        (regulatory_flag_attached ?dispense_record ?regulatory_flag)
      )
    :effect
      (and
        (regulatory_flag_available ?regulatory_flag)
        (not
          (regulatory_flag_attached ?dispense_record ?regulatory_flag)
        )
      )
  )
  (:action select_primary_stock_bin_for_technician
    :parameters (?pharmacy_technician - pharmacy_technician ?controlled_stock_bin - controlled_stock_bin ?drug_product - drug_product)
    :precondition
      (and
        (entity_clinically_verified ?pharmacy_technician)
        (entity_assigned_product ?pharmacy_technician ?drug_product)
        (stock_bin_selected ?pharmacy_technician ?controlled_stock_bin)
        (not
          (primary_stock_bin_selected ?controlled_stock_bin)
        )
        (not
          (alternate_stock_bin_selected ?controlled_stock_bin)
        )
      )
    :effect (primary_stock_bin_selected ?controlled_stock_bin)
  )
  (:action confirm_stock_pick_by_technician
    :parameters (?pharmacy_technician - pharmacy_technician ?controlled_stock_bin - controlled_stock_bin ?review_station - review_station)
    :precondition
      (and
        (entity_clinically_verified ?pharmacy_technician)
        (review_station_assigned ?pharmacy_technician ?review_station)
        (stock_bin_selected ?pharmacy_technician ?controlled_stock_bin)
        (primary_stock_bin_selected ?controlled_stock_bin)
        (not
          (technician_packaging_ready ?pharmacy_technician)
        )
      )
    :effect
      (and
        (technician_packaging_ready ?pharmacy_technician)
        (technician_stock_verified ?pharmacy_technician)
      )
  )
  (:action assign_packaging_component_and_flag_alternate_bin
    :parameters (?pharmacy_technician - pharmacy_technician ?controlled_stock_bin - controlled_stock_bin ?packaging_component - packaging_component)
    :precondition
      (and
        (entity_clinically_verified ?pharmacy_technician)
        (stock_bin_selected ?pharmacy_technician ?controlled_stock_bin)
        (packaging_component_available ?packaging_component)
        (not
          (technician_packaging_ready ?pharmacy_technician)
        )
      )
    :effect
      (and
        (alternate_stock_bin_selected ?controlled_stock_bin)
        (technician_packaging_ready ?pharmacy_technician)
        (component_reserved_for_technician ?pharmacy_technician ?packaging_component)
        (not
          (packaging_component_available ?packaging_component)
        )
      )
  )
  (:action finalize_substitution_and_restore_component
    :parameters (?pharmacy_technician - pharmacy_technician ?controlled_stock_bin - controlled_stock_bin ?drug_product - drug_product ?packaging_component - packaging_component)
    :precondition
      (and
        (entity_clinically_verified ?pharmacy_technician)
        (entity_assigned_product ?pharmacy_technician ?drug_product)
        (stock_bin_selected ?pharmacy_technician ?controlled_stock_bin)
        (alternate_stock_bin_selected ?controlled_stock_bin)
        (component_reserved_for_technician ?pharmacy_technician ?packaging_component)
        (not
          (technician_stock_verified ?pharmacy_technician)
        )
      )
    :effect
      (and
        (primary_stock_bin_selected ?controlled_stock_bin)
        (technician_stock_verified ?pharmacy_technician)
        (packaging_component_available ?packaging_component)
        (not
          (component_reserved_for_technician ?pharmacy_technician ?packaging_component)
        )
      )
  )
  (:action select_primary_label_template_by_pharmacist
    :parameters (?pharmacist - pharmacist ?label_template - label_template ?drug_product - drug_product)
    :precondition
      (and
        (entity_clinically_verified ?pharmacist)
        (entity_assigned_product ?pharmacist ?drug_product)
        (label_template_linked_to_pharmacist ?pharmacist ?label_template)
        (not
          (label_template_selected ?label_template)
        )
        (not
          (label_template_alternate_selected ?label_template)
        )
      )
    :effect (label_template_selected ?label_template)
  )
  (:action confirm_label_template_and_mark_pharmacist_ready
    :parameters (?pharmacist - pharmacist ?label_template - label_template ?review_station - review_station)
    :precondition
      (and
        (entity_clinically_verified ?pharmacist)
        (review_station_assigned ?pharmacist ?review_station)
        (label_template_linked_to_pharmacist ?pharmacist ?label_template)
        (label_template_selected ?label_template)
        (not
          (pharmacist_packaging_ready ?pharmacist)
        )
      )
    :effect
      (and
        (pharmacist_packaging_ready ?pharmacist)
        (pharmacist_stock_verified ?pharmacist)
      )
  )
  (:action reserve_component_and_select_alternate_label_by_pharmacist
    :parameters (?pharmacist - pharmacist ?label_template - label_template ?packaging_component - packaging_component)
    :precondition
      (and
        (entity_clinically_verified ?pharmacist)
        (label_template_linked_to_pharmacist ?pharmacist ?label_template)
        (packaging_component_available ?packaging_component)
        (not
          (pharmacist_packaging_ready ?pharmacist)
        )
      )
    :effect
      (and
        (label_template_alternate_selected ?label_template)
        (pharmacist_packaging_ready ?pharmacist)
        (component_reserved_for_pharmacist ?pharmacist ?packaging_component)
        (not
          (packaging_component_available ?packaging_component)
        )
      )
  )
  (:action finalize_pharmacist_substitution
    :parameters (?pharmacist - pharmacist ?label_template - label_template ?drug_product - drug_product ?packaging_component - packaging_component)
    :precondition
      (and
        (entity_clinically_verified ?pharmacist)
        (entity_assigned_product ?pharmacist ?drug_product)
        (label_template_linked_to_pharmacist ?pharmacist ?label_template)
        (label_template_alternate_selected ?label_template)
        (component_reserved_for_pharmacist ?pharmacist ?packaging_component)
        (not
          (pharmacist_stock_verified ?pharmacist)
        )
      )
    :effect
      (and
        (label_template_selected ?label_template)
        (pharmacist_stock_verified ?pharmacist)
        (packaging_component_available ?packaging_component)
        (not
          (component_reserved_for_pharmacist ?pharmacist ?packaging_component)
        )
      )
  )
  (:action select_and_reserve_medication_package
    :parameters (?pharmacy_technician - pharmacy_technician ?pharmacist - pharmacist ?controlled_stock_bin - controlled_stock_bin ?label_template - label_template ?medication_package - medication_package)
    :precondition
      (and
        (technician_packaging_ready ?pharmacy_technician)
        (pharmacist_packaging_ready ?pharmacist)
        (stock_bin_selected ?pharmacy_technician ?controlled_stock_bin)
        (label_template_linked_to_pharmacist ?pharmacist ?label_template)
        (primary_stock_bin_selected ?controlled_stock_bin)
        (label_template_selected ?label_template)
        (technician_stock_verified ?pharmacy_technician)
        (pharmacist_stock_verified ?pharmacist)
        (medication_package_available ?medication_package)
      )
    :effect
      (and
        (medication_package_reserved ?medication_package)
        (package_assigned_stock_bin ?medication_package ?controlled_stock_bin)
        (package_assigned_label_template ?medication_package ?label_template)
        (not
          (medication_package_available ?medication_package)
        )
      )
  )
  (:action select_and_reserve_medication_package_with_auxiliary_label
    :parameters (?pharmacy_technician - pharmacy_technician ?pharmacist - pharmacist ?controlled_stock_bin - controlled_stock_bin ?label_template - label_template ?medication_package - medication_package)
    :precondition
      (and
        (technician_packaging_ready ?pharmacy_technician)
        (pharmacist_packaging_ready ?pharmacist)
        (stock_bin_selected ?pharmacy_technician ?controlled_stock_bin)
        (label_template_linked_to_pharmacist ?pharmacist ?label_template)
        (alternate_stock_bin_selected ?controlled_stock_bin)
        (label_template_selected ?label_template)
        (not
          (technician_stock_verified ?pharmacy_technician)
        )
        (pharmacist_stock_verified ?pharmacist)
        (medication_package_available ?medication_package)
      )
    :effect
      (and
        (medication_package_reserved ?medication_package)
        (package_assigned_stock_bin ?medication_package ?controlled_stock_bin)
        (package_assigned_label_template ?medication_package ?label_template)
        (package_requires_auxiliary_label ?medication_package)
        (not
          (medication_package_available ?medication_package)
        )
      )
  )
  (:action select_and_reserve_medication_package_with_alternate_label
    :parameters (?pharmacy_technician - pharmacy_technician ?pharmacist - pharmacist ?controlled_stock_bin - controlled_stock_bin ?label_template - label_template ?medication_package - medication_package)
    :precondition
      (and
        (technician_packaging_ready ?pharmacy_technician)
        (pharmacist_packaging_ready ?pharmacist)
        (stock_bin_selected ?pharmacy_technician ?controlled_stock_bin)
        (label_template_linked_to_pharmacist ?pharmacist ?label_template)
        (primary_stock_bin_selected ?controlled_stock_bin)
        (label_template_alternate_selected ?label_template)
        (technician_stock_verified ?pharmacy_technician)
        (not
          (pharmacist_stock_verified ?pharmacist)
        )
        (medication_package_available ?medication_package)
      )
    :effect
      (and
        (medication_package_reserved ?medication_package)
        (package_assigned_stock_bin ?medication_package ?controlled_stock_bin)
        (package_assigned_label_template ?medication_package ?label_template)
        (package_requires_special_handling ?medication_package)
        (not
          (medication_package_available ?medication_package)
        )
      )
  )
  (:action select_and_reserve_medication_package_with_both_auxiliary_and_alternate_labels
    :parameters (?pharmacy_technician - pharmacy_technician ?pharmacist - pharmacist ?controlled_stock_bin - controlled_stock_bin ?label_template - label_template ?medication_package - medication_package)
    :precondition
      (and
        (technician_packaging_ready ?pharmacy_technician)
        (pharmacist_packaging_ready ?pharmacist)
        (stock_bin_selected ?pharmacy_technician ?controlled_stock_bin)
        (label_template_linked_to_pharmacist ?pharmacist ?label_template)
        (alternate_stock_bin_selected ?controlled_stock_bin)
        (label_template_alternate_selected ?label_template)
        (not
          (technician_stock_verified ?pharmacy_technician)
        )
        (not
          (pharmacist_stock_verified ?pharmacist)
        )
        (medication_package_available ?medication_package)
      )
    :effect
      (and
        (medication_package_reserved ?medication_package)
        (package_assigned_stock_bin ?medication_package ?controlled_stock_bin)
        (package_assigned_label_template ?medication_package ?label_template)
        (package_requires_auxiliary_label ?medication_package)
        (package_requires_special_handling ?medication_package)
        (not
          (medication_package_available ?medication_package)
        )
      )
  )
  (:action confirm_package_ready_for_assembly
    :parameters (?medication_package - medication_package ?pharmacy_technician - pharmacy_technician ?drug_product - drug_product)
    :precondition
      (and
        (medication_package_reserved ?medication_package)
        (technician_packaging_ready ?pharmacy_technician)
        (entity_assigned_product ?pharmacy_technician ?drug_product)
        (not
          (package_ready_for_auxiliary_attachment ?medication_package)
        )
      )
    :effect (package_ready_for_auxiliary_attachment ?medication_package)
  )
  (:action attach_auxiliary_label_to_package_and_record
    :parameters (?dispense_record - dispense_record ?auxiliary_label - auxiliary_label ?medication_package - medication_package)
    :precondition
      (and
        (entity_clinically_verified ?dispense_record)
        (dispense_record_assigned_package ?dispense_record ?medication_package)
        (auxiliary_label_linked_to_record ?dispense_record ?auxiliary_label)
        (auxiliary_label_available ?auxiliary_label)
        (medication_package_reserved ?medication_package)
        (package_ready_for_auxiliary_attachment ?medication_package)
        (not
          (auxiliary_label_attached ?auxiliary_label)
        )
      )
    :effect
      (and
        (auxiliary_label_attached ?auxiliary_label)
        (auxiliary_label_attached_to_package ?auxiliary_label ?medication_package)
        (not
          (auxiliary_label_available ?auxiliary_label)
        )
      )
  )
  (:action verify_auxiliary_materials_and_mark_record_ready
    :parameters (?dispense_record - dispense_record ?auxiliary_label - auxiliary_label ?medication_package - medication_package ?drug_product - drug_product)
    :precondition
      (and
        (entity_clinically_verified ?dispense_record)
        (auxiliary_label_linked_to_record ?dispense_record ?auxiliary_label)
        (auxiliary_label_attached ?auxiliary_label)
        (auxiliary_label_attached_to_package ?auxiliary_label ?medication_package)
        (entity_assigned_product ?dispense_record ?drug_product)
        (not
          (package_requires_auxiliary_label ?medication_package)
        )
        (not
          (dispense_record_materials_ready ?dispense_record)
        )
      )
    :effect (dispense_record_materials_ready ?dispense_record)
  )
  (:action assign_special_handling_instruction_to_record
    :parameters (?dispense_record - dispense_record ?special_handling_instruction - special_handling_instruction)
    :precondition
      (and
        (entity_clinically_verified ?dispense_record)
        (special_handling_instruction_available ?special_handling_instruction)
        (not
          (special_handling_assigned ?dispense_record)
        )
      )
    :effect
      (and
        (special_handling_assigned ?dispense_record)
        (special_handling_instruction_linked_to_record ?dispense_record ?special_handling_instruction)
        (not
          (special_handling_instruction_available ?special_handling_instruction)
        )
      )
  )
  (:action attach_special_handling_and_confirm
    :parameters (?dispense_record - dispense_record ?auxiliary_label - auxiliary_label ?medication_package - medication_package ?drug_product - drug_product ?special_handling_instruction - special_handling_instruction)
    :precondition
      (and
        (entity_clinically_verified ?dispense_record)
        (auxiliary_label_linked_to_record ?dispense_record ?auxiliary_label)
        (auxiliary_label_attached ?auxiliary_label)
        (auxiliary_label_attached_to_package ?auxiliary_label ?medication_package)
        (entity_assigned_product ?dispense_record ?drug_product)
        (package_requires_auxiliary_label ?medication_package)
        (special_handling_assigned ?dispense_record)
        (special_handling_instruction_linked_to_record ?dispense_record ?special_handling_instruction)
        (not
          (dispense_record_materials_ready ?dispense_record)
        )
      )
    :effect
      (and
        (dispense_record_materials_ready ?dispense_record)
        (special_handling_confirmed ?dispense_record)
      )
  )
  (:action complete_compound_batch_and_mark_assembly_ready
    :parameters (?dispense_record - dispense_record ?compound_batch - compound_batch ?review_station - review_station ?auxiliary_label - auxiliary_label ?medication_package - medication_package)
    :precondition
      (and
        (dispense_record_materials_ready ?dispense_record)
        (compound_batch_assigned_to_record ?dispense_record ?compound_batch)
        (review_station_assigned ?dispense_record ?review_station)
        (auxiliary_label_linked_to_record ?dispense_record ?auxiliary_label)
        (auxiliary_label_attached_to_package ?auxiliary_label ?medication_package)
        (not
          (package_requires_special_handling ?medication_package)
        )
        (not
          (dispense_record_assembly_completed ?dispense_record)
        )
      )
    :effect (dispense_record_assembly_completed ?dispense_record)
  )
  (:action complete_compound_batch_and_mark_assembly_ready_with_auxiliary_requirement
    :parameters (?dispense_record - dispense_record ?compound_batch - compound_batch ?review_station - review_station ?auxiliary_label - auxiliary_label ?medication_package - medication_package)
    :precondition
      (and
        (dispense_record_materials_ready ?dispense_record)
        (compound_batch_assigned_to_record ?dispense_record ?compound_batch)
        (review_station_assigned ?dispense_record ?review_station)
        (auxiliary_label_linked_to_record ?dispense_record ?auxiliary_label)
        (auxiliary_label_attached_to_package ?auxiliary_label ?medication_package)
        (package_requires_special_handling ?medication_package)
        (not
          (dispense_record_assembly_completed ?dispense_record)
        )
      )
    :effect (dispense_record_assembly_completed ?dispense_record)
  )
  (:action initiate_clinical_checklist
    :parameters (?dispense_record - dispense_record ?regulatory_flag - regulatory_flag ?auxiliary_label - auxiliary_label ?medication_package - medication_package)
    :precondition
      (and
        (dispense_record_assembly_completed ?dispense_record)
        (regulatory_flag_attached ?dispense_record ?regulatory_flag)
        (auxiliary_label_linked_to_record ?dispense_record ?auxiliary_label)
        (auxiliary_label_attached_to_package ?auxiliary_label ?medication_package)
        (not
          (package_requires_auxiliary_label ?medication_package)
        )
        (not
          (package_requires_special_handling ?medication_package)
        )
        (not
          (clinical_checklist_initiated ?dispense_record)
        )
      )
    :effect (clinical_checklist_initiated ?dispense_record)
  )
  (:action initiate_clinical_checklist_with_instruction_binding_required
    :parameters (?dispense_record - dispense_record ?regulatory_flag - regulatory_flag ?auxiliary_label - auxiliary_label ?medication_package - medication_package)
    :precondition
      (and
        (dispense_record_assembly_completed ?dispense_record)
        (regulatory_flag_attached ?dispense_record ?regulatory_flag)
        (auxiliary_label_linked_to_record ?dispense_record ?auxiliary_label)
        (auxiliary_label_attached_to_package ?auxiliary_label ?medication_package)
        (package_requires_auxiliary_label ?medication_package)
        (not
          (package_requires_special_handling ?medication_package)
        )
        (not
          (clinical_checklist_initiated ?dispense_record)
        )
      )
    :effect
      (and
        (clinical_checklist_initiated ?dispense_record)
        (patient_instruction_binding_required ?dispense_record)
      )
  )
  (:action initiate_clinical_checklist_with_secondary_requirements
    :parameters (?dispense_record - dispense_record ?regulatory_flag - regulatory_flag ?auxiliary_label - auxiliary_label ?medication_package - medication_package)
    :precondition
      (and
        (dispense_record_assembly_completed ?dispense_record)
        (regulatory_flag_attached ?dispense_record ?regulatory_flag)
        (auxiliary_label_linked_to_record ?dispense_record ?auxiliary_label)
        (auxiliary_label_attached_to_package ?auxiliary_label ?medication_package)
        (not
          (package_requires_auxiliary_label ?medication_package)
        )
        (package_requires_special_handling ?medication_package)
        (not
          (clinical_checklist_initiated ?dispense_record)
        )
      )
    :effect
      (and
        (clinical_checklist_initiated ?dispense_record)
        (patient_instruction_binding_required ?dispense_record)
      )
  )
  (:action initiate_clinical_checklist_with_all_requirements
    :parameters (?dispense_record - dispense_record ?regulatory_flag - regulatory_flag ?auxiliary_label - auxiliary_label ?medication_package - medication_package)
    :precondition
      (and
        (dispense_record_assembly_completed ?dispense_record)
        (regulatory_flag_attached ?dispense_record ?regulatory_flag)
        (auxiliary_label_linked_to_record ?dispense_record ?auxiliary_label)
        (auxiliary_label_attached_to_package ?auxiliary_label ?medication_package)
        (package_requires_auxiliary_label ?medication_package)
        (package_requires_special_handling ?medication_package)
        (not
          (clinical_checklist_initiated ?dispense_record)
        )
      )
    :effect
      (and
        (clinical_checklist_initiated ?dispense_record)
        (patient_instruction_binding_required ?dispense_record)
      )
  )
  (:action complete_verification_without_instruction_binding
    :parameters (?dispense_record - dispense_record)
    :precondition
      (and
        (clinical_checklist_initiated ?dispense_record)
        (not
          (patient_instruction_binding_required ?dispense_record)
        )
        (not
          (dispense_record_finalized ?dispense_record)
        )
      )
    :effect
      (and
        (dispense_record_finalized ?dispense_record)
        (entity_verification_complete ?dispense_record)
      )
  )
  (:action attach_patient_instruction_template_to_record
    :parameters (?dispense_record - dispense_record ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (clinical_checklist_initiated ?dispense_record)
        (patient_instruction_binding_required ?dispense_record)
        (patient_instruction_template_available ?patient_instruction_template)
      )
    :effect
      (and
        (patient_instruction_template_attached_to_record ?dispense_record ?patient_instruction_template)
        (not
          (patient_instruction_template_available ?patient_instruction_template)
        )
      )
  )
  (:action complete_multidisciplinary_verification
    :parameters (?dispense_record - dispense_record ?pharmacy_technician - pharmacy_technician ?pharmacist - pharmacist ?drug_product - drug_product ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (clinical_checklist_initiated ?dispense_record)
        (patient_instruction_binding_required ?dispense_record)
        (patient_instruction_template_attached_to_record ?dispense_record ?patient_instruction_template)
        (dispense_record_assigned_technician ?dispense_record ?pharmacy_technician)
        (dispense_record_assigned_pharmacist ?dispense_record ?pharmacist)
        (technician_stock_verified ?pharmacy_technician)
        (pharmacist_stock_verified ?pharmacist)
        (entity_assigned_product ?dispense_record ?drug_product)
        (not
          (multidisciplinary_verification_completed ?dispense_record)
        )
      )
    :effect (multidisciplinary_verification_completed ?dispense_record)
  )
  (:action complete_verification_with_final_checks
    :parameters (?dispense_record - dispense_record)
    :precondition
      (and
        (clinical_checklist_initiated ?dispense_record)
        (multidisciplinary_verification_completed ?dispense_record)
        (not
          (dispense_record_finalized ?dispense_record)
        )
      )
    :effect
      (and
        (dispense_record_finalized ?dispense_record)
        (entity_verification_complete ?dispense_record)
      )
  )
  (:action record_clinical_check_item_for_record
    :parameters (?dispense_record - dispense_record ?clinical_check_item - clinical_check_item ?drug_product - drug_product)
    :precondition
      (and
        (entity_clinically_verified ?dispense_record)
        (entity_assigned_product ?dispense_record ?drug_product)
        (clinical_check_item_available ?clinical_check_item)
        (clinical_check_item_linked_to_record ?dispense_record ?clinical_check_item)
        (not
          (clinical_check_assigned ?dispense_record)
        )
      )
    :effect
      (and
        (clinical_check_assigned ?dispense_record)
        (not
          (clinical_check_item_available ?clinical_check_item)
        )
      )
  )
  (:action start_clinical_check_in_review_station
    :parameters (?dispense_record - dispense_record ?review_station - review_station)
    :precondition
      (and
        (clinical_check_assigned ?dispense_record)
        (review_station_assigned ?dispense_record ?review_station)
        (not
          (clinical_check_in_progress ?dispense_record)
        )
      )
    :effect (clinical_check_in_progress ?dispense_record)
  )
  (:action complete_clinical_check
    :parameters (?dispense_record - dispense_record ?regulatory_flag - regulatory_flag)
    :precondition
      (and
        (clinical_check_in_progress ?dispense_record)
        (regulatory_flag_attached ?dispense_record ?regulatory_flag)
        (not
          (clinical_check_completed ?dispense_record)
        )
      )
    :effect (clinical_check_completed ?dispense_record)
  )
  (:action finalize_clinical_check_and_mark_ready
    :parameters (?dispense_record - dispense_record)
    :precondition
      (and
        (clinical_check_completed ?dispense_record)
        (not
          (dispense_record_finalized ?dispense_record)
        )
      )
    :effect
      (and
        (dispense_record_finalized ?dispense_record)
        (entity_verification_complete ?dispense_record)
      )
  )
  (:action technician_signoff_mark_record_ready
    :parameters (?pharmacy_technician - pharmacy_technician ?medication_package - medication_package)
    :precondition
      (and
        (technician_packaging_ready ?pharmacy_technician)
        (technician_stock_verified ?pharmacy_technician)
        (medication_package_reserved ?medication_package)
        (package_ready_for_auxiliary_attachment ?medication_package)
        (not
          (entity_verification_complete ?pharmacy_technician)
        )
      )
    :effect (entity_verification_complete ?pharmacy_technician)
  )
  (:action pharmacist_signoff_mark_record_ready
    :parameters (?pharmacist - pharmacist ?medication_package - medication_package)
    :precondition
      (and
        (pharmacist_packaging_ready ?pharmacist)
        (pharmacist_stock_verified ?pharmacist)
        (medication_package_reserved ?medication_package)
        (package_ready_for_auxiliary_attachment ?medication_package)
        (not
          (entity_verification_complete ?pharmacist)
        )
      )
    :effect (entity_verification_complete ?pharmacist)
  )
  (:action create_dispense_authorization_for_pharmacy_entity
    :parameters (?prescription - pharmacy_entity ?patient_profile - patient_profile ?drug_product - drug_product)
    :precondition
      (and
        (entity_verification_complete ?prescription)
        (entity_assigned_product ?prescription ?drug_product)
        (patient_profile_available ?patient_profile)
        (not
          (entity_dispense_authorization_created ?prescription)
        )
      )
    :effect
      (and
        (entity_dispense_authorization_created ?prescription)
        (patient_profile_linked ?prescription ?patient_profile)
        (not
          (patient_profile_available ?patient_profile)
        )
      )
  )
  (:action technician_execute_final_authorization
    :parameters (?pharmacy_technician - pharmacy_technician ?authorization_token - authorization_token ?patient_profile - patient_profile)
    :precondition
      (and
        (entity_dispense_authorization_created ?pharmacy_technician)
        (auth_token_linked_to_entity ?pharmacy_technician ?authorization_token)
        (patient_profile_linked ?pharmacy_technician ?patient_profile)
        (not
          (entity_dispense_authorized ?pharmacy_technician)
        )
      )
    :effect
      (and
        (entity_dispense_authorized ?pharmacy_technician)
        (authorization_token_available ?authorization_token)
        (patient_profile_available ?patient_profile)
      )
  )
  (:action pharmacist_execute_final_authorization
    :parameters (?pharmacist - pharmacist ?authorization_token - authorization_token ?patient_profile - patient_profile)
    :precondition
      (and
        (entity_dispense_authorization_created ?pharmacist)
        (auth_token_linked_to_entity ?pharmacist ?authorization_token)
        (patient_profile_linked ?pharmacist ?patient_profile)
        (not
          (entity_dispense_authorized ?pharmacist)
        )
      )
    :effect
      (and
        (entity_dispense_authorized ?pharmacist)
        (authorization_token_available ?authorization_token)
        (patient_profile_available ?patient_profile)
      )
  )
  (:action record_execute_final_authorization
    :parameters (?dispense_record - dispense_record ?authorization_token - authorization_token ?patient_profile - patient_profile)
    :precondition
      (and
        (entity_dispense_authorization_created ?dispense_record)
        (auth_token_linked_to_entity ?dispense_record ?authorization_token)
        (patient_profile_linked ?dispense_record ?patient_profile)
        (not
          (entity_dispense_authorized ?dispense_record)
        )
      )
    :effect
      (and
        (entity_dispense_authorized ?dispense_record)
        (authorization_token_available ?authorization_token)
        (patient_profile_available ?patient_profile)
      )
  )
)

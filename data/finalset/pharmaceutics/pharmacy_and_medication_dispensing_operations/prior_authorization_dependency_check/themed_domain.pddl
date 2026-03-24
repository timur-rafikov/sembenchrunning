(define (domain pharmacy_prior_authorization_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types pharmacy_resource - object resource_role - object material_role - object fulfillment_root - object fulfillment_request - fulfillment_root payer_profile - pharmacy_resource medication_product - pharmacy_resource clinical_reviewer - pharmacy_resource auxiliary_item_template - pharmacy_resource patient_instruction_template - pharmacy_resource prior_authorization_document - pharmacy_resource dispense_device - pharmacy_resource regulatory_document - pharmacy_resource substitution_option - resource_role package_component - resource_role clinical_approval_document - resource_role authorization_condition_a - material_role authorization_condition_b - material_role fulfillment_package - material_role fulfillment_subgroup - fulfillment_request fulfillment_subgroup_b - fulfillment_request technician_fulfillment_task - fulfillment_subgroup pharmacist_fulfillment_task - fulfillment_subgroup packaging_workorder - fulfillment_subgroup_b)
  (:predicates
    (fulfillment_registered ?prescription_request - fulfillment_request)
    (fulfillment_ready_for_review ?prescription_request - fulfillment_request)
    (fulfillment_payer_attached ?prescription_request - fulfillment_request)
    (fulfillment_dispense_authorized ?prescription_request - fulfillment_request)
    (fulfillment_ready_for_dispense ?prescription_request - fulfillment_request)
    (prior_authorization_present ?prescription_request - fulfillment_request)
    (payer_profile_available ?payer_profile - payer_profile)
    (fulfillment_linked_to_payer ?prescription_request - fulfillment_request ?payer_profile - payer_profile)
    (medication_product_available ?medication_product - medication_product)
    (product_resolved_for_fulfillment ?prescription_request - fulfillment_request ?medication_product - medication_product)
    (clinical_reviewer_available ?clinical_reviewer - clinical_reviewer)
    (fulfillment_assigned_reviewer ?prescription_request - fulfillment_request ?clinical_reviewer - clinical_reviewer)
    (substitution_option_available ?substitution_option - substitution_option)
    (technician_selected_substitution ?technician_fulfillment_task - technician_fulfillment_task ?substitution_option - substitution_option)
    (pharmacist_selected_substitution ?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?substitution_option - substitution_option)
    (technician_task_has_authorization_condition_a ?technician_fulfillment_task - technician_fulfillment_task ?authorization_condition_a - authorization_condition_a)
    (authorization_condition_a_flagged ?authorization_condition_a - authorization_condition_a)
    (authorization_condition_a_substitution_pending ?authorization_condition_a - authorization_condition_a)
    (technician_substitution_confirmed ?technician_fulfillment_task - technician_fulfillment_task)
    (pharmacist_task_has_authorization_condition_b ?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?authorization_condition_b - authorization_condition_b)
    (authorization_condition_b_flagged ?authorization_condition_b - authorization_condition_b)
    (authorization_condition_b_substitution_pending ?authorization_condition_b - authorization_condition_b)
    (pharmacist_substitution_confirmed ?pharmacist_fulfillment_task - pharmacist_fulfillment_task)
    (fulfillment_package_available ?fulfillment_package - fulfillment_package)
    (fulfillment_package_reserved ?fulfillment_package - fulfillment_package)
    (package_linked_to_auth_condition_a ?fulfillment_package - fulfillment_package ?authorization_condition_a - authorization_condition_a)
    (package_linked_to_auth_condition_b ?fulfillment_package - fulfillment_package ?authorization_condition_b - authorization_condition_b)
    (package_needs_auxiliary_item ?fulfillment_package - fulfillment_package)
    (package_needs_device_allocation ?fulfillment_package - fulfillment_package)
    (package_device_assigned ?fulfillment_package - fulfillment_package)
    (workorder_linked_technician_task ?packaging_workorder - packaging_workorder ?technician_fulfillment_task - technician_fulfillment_task)
    (workorder_linked_pharmacist_task ?packaging_workorder - packaging_workorder ?pharmacist_fulfillment_task - pharmacist_fulfillment_task)
    (workorder_contains_package ?packaging_workorder - packaging_workorder ?fulfillment_package - fulfillment_package)
    (package_component_available ?package_component - package_component)
    (workorder_requires_component ?packaging_workorder - packaging_workorder ?package_component - package_component)
    (package_component_attached ?package_component - package_component)
    (component_bound_to_package ?package_component - package_component ?fulfillment_package - fulfillment_package)
    (workorder_device_assigned ?packaging_workorder - packaging_workorder)
    (workorder_device_verified ?packaging_workorder - packaging_workorder)
    (workorder_evidence_attached ?packaging_workorder - packaging_workorder)
    (auxiliary_item_reserved_for_workorder ?packaging_workorder - packaging_workorder)
    (auxiliary_item_attached_to_workorder ?packaging_workorder - packaging_workorder)
    (workorder_instructions_ready ?packaging_workorder - packaging_workorder)
    (workorder_checks_complete ?packaging_workorder - packaging_workorder)
    (clinical_approval_document_available ?clinical_approval_document - clinical_approval_document)
    (workorder_linked_clinical_approval_document ?packaging_workorder - packaging_workorder ?clinical_approval_document - clinical_approval_document)
    (workorder_clinical_approval_claimed ?packaging_workorder - packaging_workorder)
    (workorder_clinical_approval_applied ?packaging_workorder - packaging_workorder)
    (workorder_clinical_approval_confirmed ?packaging_workorder - packaging_workorder)
    (auxiliary_item_template_available ?auxiliary_item_template - auxiliary_item_template)
    (workorder_linked_auxiliary_template ?packaging_workorder - packaging_workorder ?auxiliary_item_template - auxiliary_item_template)
    (patient_instruction_template_available ?patient_instruction_template - patient_instruction_template)
    (workorder_linked_patient_instruction_template ?packaging_workorder - packaging_workorder ?patient_instruction_template - patient_instruction_template)
    (dispense_device_available ?dispense_device - dispense_device)
    (workorder_linked_dispense_device ?packaging_workorder - packaging_workorder ?dispense_device - dispense_device)
    (regulatory_document_available ?regulatory_document - regulatory_document)
    (workorder_linked_regulatory_document ?packaging_workorder - packaging_workorder ?regulatory_document - regulatory_document)
    (prior_authorization_document_available ?prior_authorization_document - prior_authorization_document)
    (fulfillment_linked_to_prior_authorization_document ?prescription_request - fulfillment_request ?prior_authorization_document - prior_authorization_document)
    (technician_task_validated ?technician_fulfillment_task - technician_fulfillment_task)
    (pharmacist_task_validated ?pharmacist_fulfillment_task - pharmacist_fulfillment_task)
    (workorder_finalized ?packaging_workorder - packaging_workorder)
  )
  (:action register_prescription_request
    :parameters (?prescription_request - fulfillment_request)
    :precondition
      (and
        (not
          (fulfillment_registered ?prescription_request)
        )
        (not
          (fulfillment_dispense_authorized ?prescription_request)
        )
      )
    :effect (fulfillment_registered ?prescription_request)
  )
  (:action attach_payer_profile_to_prescription
    :parameters (?prescription_request - fulfillment_request ?payer_profile - payer_profile)
    :precondition
      (and
        (fulfillment_registered ?prescription_request)
        (not
          (fulfillment_payer_attached ?prescription_request)
        )
        (payer_profile_available ?payer_profile)
      )
    :effect
      (and
        (fulfillment_payer_attached ?prescription_request)
        (fulfillment_linked_to_payer ?prescription_request ?payer_profile)
        (not
          (payer_profile_available ?payer_profile)
        )
      )
  )
  (:action resolve_medication_for_prescription
    :parameters (?prescription_request - fulfillment_request ?medication_product - medication_product)
    :precondition
      (and
        (fulfillment_registered ?prescription_request)
        (fulfillment_payer_attached ?prescription_request)
        (medication_product_available ?medication_product)
      )
    :effect
      (and
        (product_resolved_for_fulfillment ?prescription_request ?medication_product)
        (not
          (medication_product_available ?medication_product)
        )
      )
  )
  (:action mark_prescription_ready_for_review
    :parameters (?prescription_request - fulfillment_request ?medication_product - medication_product)
    :precondition
      (and
        (fulfillment_registered ?prescription_request)
        (fulfillment_payer_attached ?prescription_request)
        (product_resolved_for_fulfillment ?prescription_request ?medication_product)
        (not
          (fulfillment_ready_for_review ?prescription_request)
        )
      )
    :effect (fulfillment_ready_for_review ?prescription_request)
  )
  (:action unreserve_medication_product
    :parameters (?prescription_request - fulfillment_request ?medication_product - medication_product)
    :precondition
      (and
        (product_resolved_for_fulfillment ?prescription_request ?medication_product)
      )
    :effect
      (and
        (medication_product_available ?medication_product)
        (not
          (product_resolved_for_fulfillment ?prescription_request ?medication_product)
        )
      )
  )
  (:action assign_clinical_reviewer_to_prescription
    :parameters (?prescription_request - fulfillment_request ?clinical_reviewer - clinical_reviewer)
    :precondition
      (and
        (fulfillment_ready_for_review ?prescription_request)
        (clinical_reviewer_available ?clinical_reviewer)
      )
    :effect
      (and
        (fulfillment_assigned_reviewer ?prescription_request ?clinical_reviewer)
        (not
          (clinical_reviewer_available ?clinical_reviewer)
        )
      )
  )
  (:action release_clinical_reviewer_from_prescription
    :parameters (?prescription_request - fulfillment_request ?clinical_reviewer - clinical_reviewer)
    :precondition
      (and
        (fulfillment_assigned_reviewer ?prescription_request ?clinical_reviewer)
      )
    :effect
      (and
        (clinical_reviewer_available ?clinical_reviewer)
        (not
          (fulfillment_assigned_reviewer ?prescription_request ?clinical_reviewer)
        )
      )
  )
  (:action assign_dispense_device_to_workorder
    :parameters (?packaging_workorder - packaging_workorder ?dispense_device - dispense_device)
    :precondition
      (and
        (fulfillment_ready_for_review ?packaging_workorder)
        (dispense_device_available ?dispense_device)
      )
    :effect
      (and
        (workorder_linked_dispense_device ?packaging_workorder ?dispense_device)
        (not
          (dispense_device_available ?dispense_device)
        )
      )
  )
  (:action release_dispense_device_from_workorder
    :parameters (?packaging_workorder - packaging_workorder ?dispense_device - dispense_device)
    :precondition
      (and
        (workorder_linked_dispense_device ?packaging_workorder ?dispense_device)
      )
    :effect
      (and
        (dispense_device_available ?dispense_device)
        (not
          (workorder_linked_dispense_device ?packaging_workorder ?dispense_device)
        )
      )
  )
  (:action attach_regulatory_document_to_workorder
    :parameters (?packaging_workorder - packaging_workorder ?regulatory_document - regulatory_document)
    :precondition
      (and
        (fulfillment_ready_for_review ?packaging_workorder)
        (regulatory_document_available ?regulatory_document)
      )
    :effect
      (and
        (workorder_linked_regulatory_document ?packaging_workorder ?regulatory_document)
        (not
          (regulatory_document_available ?regulatory_document)
        )
      )
  )
  (:action detach_regulatory_document_from_workorder
    :parameters (?packaging_workorder - packaging_workorder ?regulatory_document - regulatory_document)
    :precondition
      (and
        (workorder_linked_regulatory_document ?packaging_workorder ?regulatory_document)
      )
    :effect
      (and
        (regulatory_document_available ?regulatory_document)
        (not
          (workorder_linked_regulatory_document ?packaging_workorder ?regulatory_document)
        )
      )
  )
  (:action detect_authorization_condition_a_on_technician_task
    :parameters (?technician_fulfillment_task - technician_fulfillment_task ?authorization_condition_a - authorization_condition_a ?medication_product - medication_product)
    :precondition
      (and
        (fulfillment_ready_for_review ?technician_fulfillment_task)
        (product_resolved_for_fulfillment ?technician_fulfillment_task ?medication_product)
        (technician_task_has_authorization_condition_a ?technician_fulfillment_task ?authorization_condition_a)
        (not
          (authorization_condition_a_flagged ?authorization_condition_a)
        )
        (not
          (authorization_condition_a_substitution_pending ?authorization_condition_a)
        )
      )
    :effect (authorization_condition_a_flagged ?authorization_condition_a)
  )
  (:action confirm_authorization_condition_a_on_technician_task
    :parameters (?technician_fulfillment_task - technician_fulfillment_task ?authorization_condition_a - authorization_condition_a ?clinical_reviewer - clinical_reviewer)
    :precondition
      (and
        (fulfillment_ready_for_review ?technician_fulfillment_task)
        (fulfillment_assigned_reviewer ?technician_fulfillment_task ?clinical_reviewer)
        (technician_task_has_authorization_condition_a ?technician_fulfillment_task ?authorization_condition_a)
        (authorization_condition_a_flagged ?authorization_condition_a)
        (not
          (technician_task_validated ?technician_fulfillment_task)
        )
      )
    :effect
      (and
        (technician_task_validated ?technician_fulfillment_task)
        (technician_substitution_confirmed ?technician_fulfillment_task)
      )
  )
  (:action apply_substitution_option_on_technician_task
    :parameters (?technician_fulfillment_task - technician_fulfillment_task ?authorization_condition_a - authorization_condition_a ?substitution_option - substitution_option)
    :precondition
      (and
        (fulfillment_ready_for_review ?technician_fulfillment_task)
        (technician_task_has_authorization_condition_a ?technician_fulfillment_task ?authorization_condition_a)
        (substitution_option_available ?substitution_option)
        (not
          (technician_task_validated ?technician_fulfillment_task)
        )
      )
    :effect
      (and
        (authorization_condition_a_substitution_pending ?authorization_condition_a)
        (technician_task_validated ?technician_fulfillment_task)
        (technician_selected_substitution ?technician_fulfillment_task ?substitution_option)
        (not
          (substitution_option_available ?substitution_option)
        )
      )
  )
  (:action finalize_substitution_on_technician_task
    :parameters (?technician_fulfillment_task - technician_fulfillment_task ?authorization_condition_a - authorization_condition_a ?medication_product - medication_product ?substitution_option - substitution_option)
    :precondition
      (and
        (fulfillment_ready_for_review ?technician_fulfillment_task)
        (product_resolved_for_fulfillment ?technician_fulfillment_task ?medication_product)
        (technician_task_has_authorization_condition_a ?technician_fulfillment_task ?authorization_condition_a)
        (authorization_condition_a_substitution_pending ?authorization_condition_a)
        (technician_selected_substitution ?technician_fulfillment_task ?substitution_option)
        (not
          (technician_substitution_confirmed ?technician_fulfillment_task)
        )
      )
    :effect
      (and
        (authorization_condition_a_flagged ?authorization_condition_a)
        (technician_substitution_confirmed ?technician_fulfillment_task)
        (substitution_option_available ?substitution_option)
        (not
          (technician_selected_substitution ?technician_fulfillment_task ?substitution_option)
        )
      )
  )
  (:action detect_authorization_condition_b_on_pharmacist_task
    :parameters (?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?authorization_condition_b - authorization_condition_b ?medication_product - medication_product)
    :precondition
      (and
        (fulfillment_ready_for_review ?pharmacist_fulfillment_task)
        (product_resolved_for_fulfillment ?pharmacist_fulfillment_task ?medication_product)
        (pharmacist_task_has_authorization_condition_b ?pharmacist_fulfillment_task ?authorization_condition_b)
        (not
          (authorization_condition_b_flagged ?authorization_condition_b)
        )
        (not
          (authorization_condition_b_substitution_pending ?authorization_condition_b)
        )
      )
    :effect (authorization_condition_b_flagged ?authorization_condition_b)
  )
  (:action confirm_authorization_condition_b_on_pharmacist_task
    :parameters (?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?authorization_condition_b - authorization_condition_b ?clinical_reviewer - clinical_reviewer)
    :precondition
      (and
        (fulfillment_ready_for_review ?pharmacist_fulfillment_task)
        (fulfillment_assigned_reviewer ?pharmacist_fulfillment_task ?clinical_reviewer)
        (pharmacist_task_has_authorization_condition_b ?pharmacist_fulfillment_task ?authorization_condition_b)
        (authorization_condition_b_flagged ?authorization_condition_b)
        (not
          (pharmacist_task_validated ?pharmacist_fulfillment_task)
        )
      )
    :effect
      (and
        (pharmacist_task_validated ?pharmacist_fulfillment_task)
        (pharmacist_substitution_confirmed ?pharmacist_fulfillment_task)
      )
  )
  (:action apply_substitution_option_on_pharmacist_task
    :parameters (?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?authorization_condition_b - authorization_condition_b ?substitution_option - substitution_option)
    :precondition
      (and
        (fulfillment_ready_for_review ?pharmacist_fulfillment_task)
        (pharmacist_task_has_authorization_condition_b ?pharmacist_fulfillment_task ?authorization_condition_b)
        (substitution_option_available ?substitution_option)
        (not
          (pharmacist_task_validated ?pharmacist_fulfillment_task)
        )
      )
    :effect
      (and
        (authorization_condition_b_substitution_pending ?authorization_condition_b)
        (pharmacist_task_validated ?pharmacist_fulfillment_task)
        (pharmacist_selected_substitution ?pharmacist_fulfillment_task ?substitution_option)
        (not
          (substitution_option_available ?substitution_option)
        )
      )
  )
  (:action finalize_substitution_on_pharmacist_task
    :parameters (?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?authorization_condition_b - authorization_condition_b ?medication_product - medication_product ?substitution_option - substitution_option)
    :precondition
      (and
        (fulfillment_ready_for_review ?pharmacist_fulfillment_task)
        (product_resolved_for_fulfillment ?pharmacist_fulfillment_task ?medication_product)
        (pharmacist_task_has_authorization_condition_b ?pharmacist_fulfillment_task ?authorization_condition_b)
        (authorization_condition_b_substitution_pending ?authorization_condition_b)
        (pharmacist_selected_substitution ?pharmacist_fulfillment_task ?substitution_option)
        (not
          (pharmacist_substitution_confirmed ?pharmacist_fulfillment_task)
        )
      )
    :effect
      (and
        (authorization_condition_b_flagged ?authorization_condition_b)
        (pharmacist_substitution_confirmed ?pharmacist_fulfillment_task)
        (substitution_option_available ?substitution_option)
        (not
          (pharmacist_selected_substitution ?pharmacist_fulfillment_task ?substitution_option)
        )
      )
  )
  (:action assemble_fulfillment_package_from_tasks
    :parameters (?technician_fulfillment_task - technician_fulfillment_task ?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?authorization_condition_a - authorization_condition_a ?authorization_condition_b - authorization_condition_b ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (technician_task_validated ?technician_fulfillment_task)
        (pharmacist_task_validated ?pharmacist_fulfillment_task)
        (technician_task_has_authorization_condition_a ?technician_fulfillment_task ?authorization_condition_a)
        (pharmacist_task_has_authorization_condition_b ?pharmacist_fulfillment_task ?authorization_condition_b)
        (authorization_condition_a_flagged ?authorization_condition_a)
        (authorization_condition_b_flagged ?authorization_condition_b)
        (technician_substitution_confirmed ?technician_fulfillment_task)
        (pharmacist_substitution_confirmed ?pharmacist_fulfillment_task)
        (fulfillment_package_available ?fulfillment_package)
      )
    :effect
      (and
        (fulfillment_package_reserved ?fulfillment_package)
        (package_linked_to_auth_condition_a ?fulfillment_package ?authorization_condition_a)
        (package_linked_to_auth_condition_b ?fulfillment_package ?authorization_condition_b)
        (not
          (fulfillment_package_available ?fulfillment_package)
        )
      )
  )
  (:action assemble_fulfillment_package_with_auxiliary_item_marker
    :parameters (?technician_fulfillment_task - technician_fulfillment_task ?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?authorization_condition_a - authorization_condition_a ?authorization_condition_b - authorization_condition_b ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (technician_task_validated ?technician_fulfillment_task)
        (pharmacist_task_validated ?pharmacist_fulfillment_task)
        (technician_task_has_authorization_condition_a ?technician_fulfillment_task ?authorization_condition_a)
        (pharmacist_task_has_authorization_condition_b ?pharmacist_fulfillment_task ?authorization_condition_b)
        (authorization_condition_a_substitution_pending ?authorization_condition_a)
        (authorization_condition_b_flagged ?authorization_condition_b)
        (not
          (technician_substitution_confirmed ?technician_fulfillment_task)
        )
        (pharmacist_substitution_confirmed ?pharmacist_fulfillment_task)
        (fulfillment_package_available ?fulfillment_package)
      )
    :effect
      (and
        (fulfillment_package_reserved ?fulfillment_package)
        (package_linked_to_auth_condition_a ?fulfillment_package ?authorization_condition_a)
        (package_linked_to_auth_condition_b ?fulfillment_package ?authorization_condition_b)
        (package_needs_auxiliary_item ?fulfillment_package)
        (not
          (fulfillment_package_available ?fulfillment_package)
        )
      )
  )
  (:action assemble_fulfillment_package_with_instruction_marker
    :parameters (?technician_fulfillment_task - technician_fulfillment_task ?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?authorization_condition_a - authorization_condition_a ?authorization_condition_b - authorization_condition_b ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (technician_task_validated ?technician_fulfillment_task)
        (pharmacist_task_validated ?pharmacist_fulfillment_task)
        (technician_task_has_authorization_condition_a ?technician_fulfillment_task ?authorization_condition_a)
        (pharmacist_task_has_authorization_condition_b ?pharmacist_fulfillment_task ?authorization_condition_b)
        (authorization_condition_a_flagged ?authorization_condition_a)
        (authorization_condition_b_substitution_pending ?authorization_condition_b)
        (technician_substitution_confirmed ?technician_fulfillment_task)
        (not
          (pharmacist_substitution_confirmed ?pharmacist_fulfillment_task)
        )
        (fulfillment_package_available ?fulfillment_package)
      )
    :effect
      (and
        (fulfillment_package_reserved ?fulfillment_package)
        (package_linked_to_auth_condition_a ?fulfillment_package ?authorization_condition_a)
        (package_linked_to_auth_condition_b ?fulfillment_package ?authorization_condition_b)
        (package_needs_device_allocation ?fulfillment_package)
        (not
          (fulfillment_package_available ?fulfillment_package)
        )
      )
  )
  (:action assemble_fulfillment_package_with_all_markers
    :parameters (?technician_fulfillment_task - technician_fulfillment_task ?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?authorization_condition_a - authorization_condition_a ?authorization_condition_b - authorization_condition_b ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (technician_task_validated ?technician_fulfillment_task)
        (pharmacist_task_validated ?pharmacist_fulfillment_task)
        (technician_task_has_authorization_condition_a ?technician_fulfillment_task ?authorization_condition_a)
        (pharmacist_task_has_authorization_condition_b ?pharmacist_fulfillment_task ?authorization_condition_b)
        (authorization_condition_a_substitution_pending ?authorization_condition_a)
        (authorization_condition_b_substitution_pending ?authorization_condition_b)
        (not
          (technician_substitution_confirmed ?technician_fulfillment_task)
        )
        (not
          (pharmacist_substitution_confirmed ?pharmacist_fulfillment_task)
        )
        (fulfillment_package_available ?fulfillment_package)
      )
    :effect
      (and
        (fulfillment_package_reserved ?fulfillment_package)
        (package_linked_to_auth_condition_a ?fulfillment_package ?authorization_condition_a)
        (package_linked_to_auth_condition_b ?fulfillment_package ?authorization_condition_b)
        (package_needs_auxiliary_item ?fulfillment_package)
        (package_needs_device_allocation ?fulfillment_package)
        (not
          (fulfillment_package_available ?fulfillment_package)
        )
      )
  )
  (:action assign_device_to_fulfillment_package
    :parameters (?fulfillment_package - fulfillment_package ?technician_fulfillment_task - technician_fulfillment_task ?medication_product - medication_product)
    :precondition
      (and
        (fulfillment_package_reserved ?fulfillment_package)
        (technician_task_validated ?technician_fulfillment_task)
        (product_resolved_for_fulfillment ?technician_fulfillment_task ?medication_product)
        (not
          (package_device_assigned ?fulfillment_package)
        )
      )
    :effect (package_device_assigned ?fulfillment_package)
  )
  (:action attach_package_component_to_workorder
    :parameters (?packaging_workorder - packaging_workorder ?package_component - package_component ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (fulfillment_ready_for_review ?packaging_workorder)
        (workorder_contains_package ?packaging_workorder ?fulfillment_package)
        (workorder_requires_component ?packaging_workorder ?package_component)
        (package_component_available ?package_component)
        (fulfillment_package_reserved ?fulfillment_package)
        (package_device_assigned ?fulfillment_package)
        (not
          (package_component_attached ?package_component)
        )
      )
    :effect
      (and
        (package_component_attached ?package_component)
        (component_bound_to_package ?package_component ?fulfillment_package)
        (not
          (package_component_available ?package_component)
        )
      )
  )
  (:action verify_package_component_and_mark_workorder
    :parameters (?packaging_workorder - packaging_workorder ?package_component - package_component ?fulfillment_package - fulfillment_package ?medication_product - medication_product)
    :precondition
      (and
        (fulfillment_ready_for_review ?packaging_workorder)
        (workorder_requires_component ?packaging_workorder ?package_component)
        (package_component_attached ?package_component)
        (component_bound_to_package ?package_component ?fulfillment_package)
        (product_resolved_for_fulfillment ?packaging_workorder ?medication_product)
        (not
          (package_needs_auxiliary_item ?fulfillment_package)
        )
        (not
          (workorder_device_assigned ?packaging_workorder)
        )
      )
    :effect (workorder_device_assigned ?packaging_workorder)
  )
  (:action reserve_auxiliary_item_template_for_workorder
    :parameters (?packaging_workorder - packaging_workorder ?auxiliary_item_template - auxiliary_item_template)
    :precondition
      (and
        (fulfillment_ready_for_review ?packaging_workorder)
        (auxiliary_item_template_available ?auxiliary_item_template)
        (not
          (auxiliary_item_reserved_for_workorder ?packaging_workorder)
        )
      )
    :effect
      (and
        (auxiliary_item_reserved_for_workorder ?packaging_workorder)
        (workorder_linked_auxiliary_template ?packaging_workorder ?auxiliary_item_template)
        (not
          (auxiliary_item_template_available ?auxiliary_item_template)
        )
      )
  )
  (:action attach_auxiliary_item_template_to_workorder
    :parameters (?packaging_workorder - packaging_workorder ?package_component - package_component ?fulfillment_package - fulfillment_package ?medication_product - medication_product ?auxiliary_item_template - auxiliary_item_template)
    :precondition
      (and
        (fulfillment_ready_for_review ?packaging_workorder)
        (workorder_requires_component ?packaging_workorder ?package_component)
        (package_component_attached ?package_component)
        (component_bound_to_package ?package_component ?fulfillment_package)
        (product_resolved_for_fulfillment ?packaging_workorder ?medication_product)
        (package_needs_auxiliary_item ?fulfillment_package)
        (auxiliary_item_reserved_for_workorder ?packaging_workorder)
        (workorder_linked_auxiliary_template ?packaging_workorder ?auxiliary_item_template)
        (not
          (workorder_device_assigned ?packaging_workorder)
        )
      )
    :effect
      (and
        (workorder_device_assigned ?packaging_workorder)
        (auxiliary_item_attached_to_workorder ?packaging_workorder)
      )
  )
  (:action allocate_and_verify_device_for_workorder_path_a
    :parameters (?packaging_workorder - packaging_workorder ?dispense_device - dispense_device ?clinical_reviewer - clinical_reviewer ?package_component - package_component ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (workorder_device_assigned ?packaging_workorder)
        (workorder_linked_dispense_device ?packaging_workorder ?dispense_device)
        (fulfillment_assigned_reviewer ?packaging_workorder ?clinical_reviewer)
        (workorder_requires_component ?packaging_workorder ?package_component)
        (component_bound_to_package ?package_component ?fulfillment_package)
        (not
          (package_needs_device_allocation ?fulfillment_package)
        )
        (not
          (workorder_device_verified ?packaging_workorder)
        )
      )
    :effect (workorder_device_verified ?packaging_workorder)
  )
  (:action allocate_and_verify_device_for_workorder_path_b
    :parameters (?packaging_workorder - packaging_workorder ?dispense_device - dispense_device ?clinical_reviewer - clinical_reviewer ?package_component - package_component ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (workorder_device_assigned ?packaging_workorder)
        (workorder_linked_dispense_device ?packaging_workorder ?dispense_device)
        (fulfillment_assigned_reviewer ?packaging_workorder ?clinical_reviewer)
        (workorder_requires_component ?packaging_workorder ?package_component)
        (component_bound_to_package ?package_component ?fulfillment_package)
        (package_needs_device_allocation ?fulfillment_package)
        (not
          (workorder_device_verified ?packaging_workorder)
        )
      )
    :effect (workorder_device_verified ?packaging_workorder)
  )
  (:action apply_regulatory_document_to_workorder_path_a
    :parameters (?packaging_workorder - packaging_workorder ?regulatory_document - regulatory_document ?package_component - package_component ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (workorder_device_verified ?packaging_workorder)
        (workorder_linked_regulatory_document ?packaging_workorder ?regulatory_document)
        (workorder_requires_component ?packaging_workorder ?package_component)
        (component_bound_to_package ?package_component ?fulfillment_package)
        (not
          (package_needs_auxiliary_item ?fulfillment_package)
        )
        (not
          (package_needs_device_allocation ?fulfillment_package)
        )
        (not
          (workorder_evidence_attached ?packaging_workorder)
        )
      )
    :effect (workorder_evidence_attached ?packaging_workorder)
  )
  (:action apply_regulatory_document_to_workorder_and_attach_instruction
    :parameters (?packaging_workorder - packaging_workorder ?regulatory_document - regulatory_document ?package_component - package_component ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (workorder_device_verified ?packaging_workorder)
        (workorder_linked_regulatory_document ?packaging_workorder ?regulatory_document)
        (workorder_requires_component ?packaging_workorder ?package_component)
        (component_bound_to_package ?package_component ?fulfillment_package)
        (package_needs_auxiliary_item ?fulfillment_package)
        (not
          (package_needs_device_allocation ?fulfillment_package)
        )
        (not
          (workorder_evidence_attached ?packaging_workorder)
        )
      )
    :effect
      (and
        (workorder_evidence_attached ?packaging_workorder)
        (workorder_instructions_ready ?packaging_workorder)
      )
  )
  (:action apply_regulatory_document_to_workorder_path_b
    :parameters (?packaging_workorder - packaging_workorder ?regulatory_document - regulatory_document ?package_component - package_component ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (workorder_device_verified ?packaging_workorder)
        (workorder_linked_regulatory_document ?packaging_workorder ?regulatory_document)
        (workorder_requires_component ?packaging_workorder ?package_component)
        (component_bound_to_package ?package_component ?fulfillment_package)
        (not
          (package_needs_auxiliary_item ?fulfillment_package)
        )
        (package_needs_device_allocation ?fulfillment_package)
        (not
          (workorder_evidence_attached ?packaging_workorder)
        )
      )
    :effect
      (and
        (workorder_evidence_attached ?packaging_workorder)
        (workorder_instructions_ready ?packaging_workorder)
      )
  )
  (:action apply_regulatory_document_to_workorder_with_all_flags
    :parameters (?packaging_workorder - packaging_workorder ?regulatory_document - regulatory_document ?package_component - package_component ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (workorder_device_verified ?packaging_workorder)
        (workorder_linked_regulatory_document ?packaging_workorder ?regulatory_document)
        (workorder_requires_component ?packaging_workorder ?package_component)
        (component_bound_to_package ?package_component ?fulfillment_package)
        (package_needs_auxiliary_item ?fulfillment_package)
        (package_needs_device_allocation ?fulfillment_package)
        (not
          (workorder_evidence_attached ?packaging_workorder)
        )
      )
    :effect
      (and
        (workorder_evidence_attached ?packaging_workorder)
        (workorder_instructions_ready ?packaging_workorder)
      )
  )
  (:action finalize_workorder_and_mark_ready
    :parameters (?packaging_workorder - packaging_workorder)
    :precondition
      (and
        (workorder_evidence_attached ?packaging_workorder)
        (not
          (workorder_instructions_ready ?packaging_workorder)
        )
        (not
          (workorder_finalized ?packaging_workorder)
        )
      )
    :effect
      (and
        (workorder_finalized ?packaging_workorder)
        (fulfillment_ready_for_dispense ?packaging_workorder)
      )
  )
  (:action attach_patient_instruction_template_to_workorder
    :parameters (?packaging_workorder - packaging_workorder ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (workorder_evidence_attached ?packaging_workorder)
        (workorder_instructions_ready ?packaging_workorder)
        (patient_instruction_template_available ?patient_instruction_template)
      )
    :effect
      (and
        (workorder_linked_patient_instruction_template ?packaging_workorder ?patient_instruction_template)
        (not
          (patient_instruction_template_available ?patient_instruction_template)
        )
      )
  )
  (:action complete_workorder_verification_checks
    :parameters (?packaging_workorder - packaging_workorder ?technician_fulfillment_task - technician_fulfillment_task ?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?medication_product - medication_product ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (workorder_evidence_attached ?packaging_workorder)
        (workorder_instructions_ready ?packaging_workorder)
        (workorder_linked_patient_instruction_template ?packaging_workorder ?patient_instruction_template)
        (workorder_linked_technician_task ?packaging_workorder ?technician_fulfillment_task)
        (workorder_linked_pharmacist_task ?packaging_workorder ?pharmacist_fulfillment_task)
        (technician_substitution_confirmed ?technician_fulfillment_task)
        (pharmacist_substitution_confirmed ?pharmacist_fulfillment_task)
        (product_resolved_for_fulfillment ?packaging_workorder ?medication_product)
        (not
          (workorder_checks_complete ?packaging_workorder)
        )
      )
    :effect (workorder_checks_complete ?packaging_workorder)
  )
  (:action release_verified_workorder
    :parameters (?packaging_workorder - packaging_workorder)
    :precondition
      (and
        (workorder_evidence_attached ?packaging_workorder)
        (workorder_checks_complete ?packaging_workorder)
        (not
          (workorder_finalized ?packaging_workorder)
        )
      )
    :effect
      (and
        (workorder_finalized ?packaging_workorder)
        (fulfillment_ready_for_dispense ?packaging_workorder)
      )
  )
  (:action claim_clinical_approval_document_for_workorder
    :parameters (?packaging_workorder - packaging_workorder ?clinical_approval_document - clinical_approval_document ?medication_product - medication_product)
    :precondition
      (and
        (fulfillment_ready_for_review ?packaging_workorder)
        (product_resolved_for_fulfillment ?packaging_workorder ?medication_product)
        (clinical_approval_document_available ?clinical_approval_document)
        (workorder_linked_clinical_approval_document ?packaging_workorder ?clinical_approval_document)
        (not
          (workorder_clinical_approval_claimed ?packaging_workorder)
        )
      )
    :effect
      (and
        (workorder_clinical_approval_claimed ?packaging_workorder)
        (not
          (clinical_approval_document_available ?clinical_approval_document)
        )
      )
  )
  (:action apply_clinical_approval_to_workorder
    :parameters (?packaging_workorder - packaging_workorder ?clinical_reviewer - clinical_reviewer)
    :precondition
      (and
        (workorder_clinical_approval_claimed ?packaging_workorder)
        (fulfillment_assigned_reviewer ?packaging_workorder ?clinical_reviewer)
        (not
          (workorder_clinical_approval_applied ?packaging_workorder)
        )
      )
    :effect (workorder_clinical_approval_applied ?packaging_workorder)
  )
  (:action confirm_clinical_approval_on_workorder
    :parameters (?packaging_workorder - packaging_workorder ?regulatory_document - regulatory_document)
    :precondition
      (and
        (workorder_clinical_approval_applied ?packaging_workorder)
        (workorder_linked_regulatory_document ?packaging_workorder ?regulatory_document)
        (not
          (workorder_clinical_approval_confirmed ?packaging_workorder)
        )
      )
    :effect (workorder_clinical_approval_confirmed ?packaging_workorder)
  )
  (:action release_workorder_after_clinical_approval
    :parameters (?packaging_workorder - packaging_workorder)
    :precondition
      (and
        (workorder_clinical_approval_confirmed ?packaging_workorder)
        (not
          (workorder_finalized ?packaging_workorder)
        )
      )
    :effect
      (and
        (workorder_finalized ?packaging_workorder)
        (fulfillment_ready_for_dispense ?packaging_workorder)
      )
  )
  (:action release_technician_task_for_dispense
    :parameters (?technician_fulfillment_task - technician_fulfillment_task ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (technician_task_validated ?technician_fulfillment_task)
        (technician_substitution_confirmed ?technician_fulfillment_task)
        (fulfillment_package_reserved ?fulfillment_package)
        (package_device_assigned ?fulfillment_package)
        (not
          (fulfillment_ready_for_dispense ?technician_fulfillment_task)
        )
      )
    :effect (fulfillment_ready_for_dispense ?technician_fulfillment_task)
  )
  (:action release_pharmacist_task_for_dispense
    :parameters (?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?fulfillment_package - fulfillment_package)
    :precondition
      (and
        (pharmacist_task_validated ?pharmacist_fulfillment_task)
        (pharmacist_substitution_confirmed ?pharmacist_fulfillment_task)
        (fulfillment_package_reserved ?fulfillment_package)
        (package_device_assigned ?fulfillment_package)
        (not
          (fulfillment_ready_for_dispense ?pharmacist_fulfillment_task)
        )
      )
    :effect (fulfillment_ready_for_dispense ?pharmacist_fulfillment_task)
  )
  (:action generate_prior_authorization_document_for_prescription
    :parameters (?prescription_request - fulfillment_request ?prior_authorization_document - prior_authorization_document ?medication_product - medication_product)
    :precondition
      (and
        (fulfillment_ready_for_dispense ?prescription_request)
        (product_resolved_for_fulfillment ?prescription_request ?medication_product)
        (prior_authorization_document_available ?prior_authorization_document)
        (not
          (prior_authorization_present ?prescription_request)
        )
      )
    :effect
      (and
        (prior_authorization_present ?prescription_request)
        (fulfillment_linked_to_prior_authorization_document ?prescription_request ?prior_authorization_document)
        (not
          (prior_authorization_document_available ?prior_authorization_document)
        )
      )
  )
  (:action process_payer_response_for_technician_task
    :parameters (?technician_fulfillment_task - technician_fulfillment_task ?payer_profile - payer_profile ?prior_authorization_document - prior_authorization_document)
    :precondition
      (and
        (prior_authorization_present ?technician_fulfillment_task)
        (fulfillment_linked_to_payer ?technician_fulfillment_task ?payer_profile)
        (fulfillment_linked_to_prior_authorization_document ?technician_fulfillment_task ?prior_authorization_document)
        (not
          (fulfillment_dispense_authorized ?technician_fulfillment_task)
        )
      )
    :effect
      (and
        (fulfillment_dispense_authorized ?technician_fulfillment_task)
        (payer_profile_available ?payer_profile)
        (prior_authorization_document_available ?prior_authorization_document)
      )
  )
  (:action process_payer_response_for_pharmacist_task
    :parameters (?pharmacist_fulfillment_task - pharmacist_fulfillment_task ?payer_profile - payer_profile ?prior_authorization_document - prior_authorization_document)
    :precondition
      (and
        (prior_authorization_present ?pharmacist_fulfillment_task)
        (fulfillment_linked_to_payer ?pharmacist_fulfillment_task ?payer_profile)
        (fulfillment_linked_to_prior_authorization_document ?pharmacist_fulfillment_task ?prior_authorization_document)
        (not
          (fulfillment_dispense_authorized ?pharmacist_fulfillment_task)
        )
      )
    :effect
      (and
        (fulfillment_dispense_authorized ?pharmacist_fulfillment_task)
        (payer_profile_available ?payer_profile)
        (prior_authorization_document_available ?prior_authorization_document)
      )
  )
  (:action process_payer_response_for_workorder
    :parameters (?packaging_workorder - packaging_workorder ?payer_profile - payer_profile ?prior_authorization_document - prior_authorization_document)
    :precondition
      (and
        (prior_authorization_present ?packaging_workorder)
        (fulfillment_linked_to_payer ?packaging_workorder ?payer_profile)
        (fulfillment_linked_to_prior_authorization_document ?packaging_workorder ?prior_authorization_document)
        (not
          (fulfillment_dispense_authorized ?packaging_workorder)
        )
      )
    :effect
      (and
        (fulfillment_dispense_authorized ?packaging_workorder)
        (payer_profile_available ?payer_profile)
        (prior_authorization_document_available ?prior_authorization_document)
      )
  )
)

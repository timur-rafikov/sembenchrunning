(define (domain pharmacy_returned_medication_disposition)
  (:requirements :strips :typing :negative-preconditions)
  (:types generic_object - object pharmacy_resource_class - generic_object medication_option_class - generic_object packaging_class - generic_object case_container_class - generic_object returned_medication_case - case_container_class storage_location_or_bin - pharmacy_resource_class medication_product - pharmacy_resource_class authorizing_pharmacist_credential - pharmacy_resource_class auxiliary_material - pharmacy_resource_class fulfillment_channel - pharmacy_resource_class patient_instruction_template - pharmacy_resource_class clinical_check_record - pharmacy_resource_class prescriber_authorization - pharmacy_resource_class substitution_option - medication_option_class container_or_unit_of_use - medication_option_class payer_prior_authorization_record - medication_option_class handling_category_flag - packaging_class labeling_template - packaging_class final_package - packaging_class returned_case_subclass - returned_medication_case returned_case_subclass_alt - returned_medication_case technician_task_instance - returned_case_subclass pharmacist_task_instance - returned_case_subclass dispensing_job - returned_case_subclass_alt)

  (:predicates
    (work_item_registered ?returned_medication_case - returned_medication_case)
    (work_item_ready_for_clinical_review ?returned_medication_case - returned_medication_case)
    (work_item_staged ?returned_medication_case - returned_medication_case)
    (work_item_disposition_finalized ?returned_medication_case - returned_medication_case)
    (ready_for_instruction_generation ?returned_medication_case - returned_medication_case)
    (patient_instructions_attached ?returned_medication_case - returned_medication_case)
    (storage_bin_available ?storage_location_or_bin - storage_location_or_bin)
    (allocated_to_storage_bin ?returned_medication_case - returned_medication_case ?storage_location_or_bin - storage_location_or_bin)
    (product_available ?medication_product - medication_product)
    (work_item_assigned_product ?returned_medication_case - returned_medication_case ?medication_product - medication_product)
    (pharmacist_credential_available ?authorizing_pharmacist_credential - authorizing_pharmacist_credential)
    (work_item_assigned_credential ?returned_medication_case - returned_medication_case ?authorizing_pharmacist_credential - authorizing_pharmacist_credential)
    (substitution_option_available ?substitution_option - substitution_option)
    (task_assigned_substitution_option ?technician_task_instance - technician_task_instance ?substitution_option - substitution_option)
    (pharmacist_assigned_substitution_option ?pharmacist_task_instance - pharmacist_task_instance ?substitution_option - substitution_option)
    (task_assigned_handling_flag ?technician_task_instance - technician_task_instance ?handling_category_flag - handling_category_flag)
    (handling_flag_acknowledged ?handling_category_flag - handling_category_flag)
    (handling_flag_requires_substitution ?handling_category_flag - handling_category_flag)
    (task_preparation_completed ?technician_task_instance - technician_task_instance)
    (pharmacist_assigned_label_template ?pharmacist_task_instance - pharmacist_task_instance ?labeling_template - labeling_template)
    (labeling_template_selected ?labeling_template - labeling_template)
    (labeling_template_reserved ?labeling_template - labeling_template)
    (pharmacist_authorization_completed ?pharmacist_task_instance - pharmacist_task_instance)
    (package_slot_available ?final_package - final_package)
    (package_created ?final_package - final_package)
    (package_assigned_handling_flag ?final_package - final_package ?handling_category_flag - handling_category_flag)
    (package_assigned_label_template ?final_package - final_package ?labeling_template - labeling_template)
    (package_includes_auxiliary_material_a ?final_package - final_package)
    (package_includes_auxiliary_material_b ?final_package - final_package)
    (package_labeling_finalized ?final_package - final_package)
    (job_assigned_technician_task ?dispensing_job - dispensing_job ?technician_task_instance - technician_task_instance)
    (job_assigned_pharmacist_task ?dispensing_job - dispensing_job ?pharmacist_task_instance - pharmacist_task_instance)
    (job_assigned_package ?dispensing_job - dispensing_job ?final_package - final_package)
    (container_available ?container_or_unit_of_use - container_or_unit_of_use)
    (job_allowed_container ?dispensing_job - dispensing_job ?container_or_unit_of_use - container_or_unit_of_use)
    (container_allocated ?container_or_unit_of_use - container_or_unit_of_use)
    (container_assigned_to_package ?container_or_unit_of_use - container_or_unit_of_use ?final_package - final_package)
    (job_open_for_auxiliary_selection ?dispensing_job - dispensing_job)
    (job_auxiliary_materials_reserved ?dispensing_job - dispensing_job)
    (job_ready_for_verification ?dispensing_job - dispensing_job)
    (auxiliary_material_reserved_for_job ?dispensing_job - dispensing_job)
    (auxiliary_material_attachment_recorded ?dispensing_job - dispensing_job)
    (auxiliary_materials_attached ?dispensing_job - dispensing_job)
    (pharmacist_verification_performed ?dispensing_job - dispensing_job)
    (payer_prior_authorization_available ?payer_prior_authorization_record - payer_prior_authorization_record)
    (job_assigned_prior_authorization ?dispensing_job - dispensing_job ?payer_prior_authorization_record - payer_prior_authorization_record)
    (prior_authorization_recorded_for_job ?dispensing_job - dispensing_job)
    (prior_authorization_validated_for_job ?dispensing_job - dispensing_job)
    (prior_authorization_verified_for_job ?dispensing_job - dispensing_job)
    (auxiliary_material_available ?auxiliary_material - auxiliary_material)
    (job_assigned_auxiliary_material ?dispensing_job - dispensing_job ?auxiliary_material - auxiliary_material)
    (fulfillment_channel_available ?fulfillment_channel - fulfillment_channel)
    (job_assigned_fulfillment_channel ?dispensing_job - dispensing_job ?fulfillment_channel - fulfillment_channel)
    (clinical_check_record_available ?clinical_check_record - clinical_check_record)
    (job_assigned_clinical_check_record ?dispensing_job - dispensing_job ?clinical_check_record - clinical_check_record)
    (prescriber_authorization_available ?prescriber_authorization - prescriber_authorization)
    (job_assigned_prescriber_authorization ?dispensing_job - dispensing_job ?prescriber_authorization - prescriber_authorization)
    (patient_instruction_template_available ?patient_instruction_template - patient_instruction_template)
    (work_item_assigned_instruction_template ?returned_medication_case - returned_medication_case ?patient_instruction_template - patient_instruction_template)
    (technician_task_ready ?technician_task_instance - technician_task_instance)
    (pharmacist_task_ready ?pharmacist_task_instance - pharmacist_task_instance)
    (verification_signoff_recorded ?dispensing_job - dispensing_job)
  )
  (:action register_returned_medication_case
    :parameters (?returned_medication_case - returned_medication_case)
    :precondition
      (and
        (not
          (work_item_registered ?returned_medication_case)
        )
        (not
          (work_item_disposition_finalized ?returned_medication_case)
        )
      )
    :effect (work_item_registered ?returned_medication_case)
  )
  (:action stage_case_to_storage_bin
    :parameters (?returned_medication_case - returned_medication_case ?storage_location_or_bin - storage_location_or_bin)
    :precondition
      (and
        (work_item_registered ?returned_medication_case)
        (not
          (work_item_staged ?returned_medication_case)
        )
        (storage_bin_available ?storage_location_or_bin)
      )
    :effect
      (and
        (work_item_staged ?returned_medication_case)
        (allocated_to_storage_bin ?returned_medication_case ?storage_location_or_bin)
        (not
          (storage_bin_available ?storage_location_or_bin)
        )
      )
  )
  (:action assign_product_to_case_for_check
    :parameters (?returned_medication_case - returned_medication_case ?medication_product - medication_product)
    :precondition
      (and
        (work_item_registered ?returned_medication_case)
        (work_item_staged ?returned_medication_case)
        (product_available ?medication_product)
      )
    :effect
      (and
        (work_item_assigned_product ?returned_medication_case ?medication_product)
        (not
          (product_available ?medication_product)
        )
      )
  )
  (:action mark_case_ready_for_clinical_review
    :parameters (?returned_medication_case - returned_medication_case ?medication_product - medication_product)
    :precondition
      (and
        (work_item_registered ?returned_medication_case)
        (work_item_staged ?returned_medication_case)
        (work_item_assigned_product ?returned_medication_case ?medication_product)
        (not
          (work_item_ready_for_clinical_review ?returned_medication_case)
        )
      )
    :effect (work_item_ready_for_clinical_review ?returned_medication_case)
  )
  (:action unassign_product_from_case
    :parameters (?returned_medication_case - returned_medication_case ?medication_product - medication_product)
    :precondition
      (and
        (work_item_assigned_product ?returned_medication_case ?medication_product)
      )
    :effect
      (and
        (product_available ?medication_product)
        (not
          (work_item_assigned_product ?returned_medication_case ?medication_product)
        )
      )
  )
  (:action assign_pharmacist_credential_to_case
    :parameters (?returned_medication_case - returned_medication_case ?authorizing_pharmacist_credential - authorizing_pharmacist_credential)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?returned_medication_case)
        (pharmacist_credential_available ?authorizing_pharmacist_credential)
      )
    :effect
      (and
        (work_item_assigned_credential ?returned_medication_case ?authorizing_pharmacist_credential)
        (not
          (pharmacist_credential_available ?authorizing_pharmacist_credential)
        )
      )
  )
  (:action release_pharmacist_credential_from_case
    :parameters (?returned_medication_case - returned_medication_case ?authorizing_pharmacist_credential - authorizing_pharmacist_credential)
    :precondition
      (and
        (work_item_assigned_credential ?returned_medication_case ?authorizing_pharmacist_credential)
      )
    :effect
      (and
        (pharmacist_credential_available ?authorizing_pharmacist_credential)
        (not
          (work_item_assigned_credential ?returned_medication_case ?authorizing_pharmacist_credential)
        )
      )
  )
  (:action assign_clinical_check_to_job
    :parameters (?dispensing_job - dispensing_job ?clinical_check_record - clinical_check_record)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?dispensing_job)
        (clinical_check_record_available ?clinical_check_record)
      )
    :effect
      (and
        (job_assigned_clinical_check_record ?dispensing_job ?clinical_check_record)
        (not
          (clinical_check_record_available ?clinical_check_record)
        )
      )
  )
  (:action release_clinical_check_from_job
    :parameters (?dispensing_job - dispensing_job ?clinical_check_record - clinical_check_record)
    :precondition
      (and
        (job_assigned_clinical_check_record ?dispensing_job ?clinical_check_record)
      )
    :effect
      (and
        (clinical_check_record_available ?clinical_check_record)
        (not
          (job_assigned_clinical_check_record ?dispensing_job ?clinical_check_record)
        )
      )
  )
  (:action assign_prescriber_authorization_to_job
    :parameters (?dispensing_job - dispensing_job ?prescriber_authorization - prescriber_authorization)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?dispensing_job)
        (prescriber_authorization_available ?prescriber_authorization)
      )
    :effect
      (and
        (job_assigned_prescriber_authorization ?dispensing_job ?prescriber_authorization)
        (not
          (prescriber_authorization_available ?prescriber_authorization)
        )
      )
  )
  (:action release_prescriber_authorization_from_job
    :parameters (?dispensing_job - dispensing_job ?prescriber_authorization - prescriber_authorization)
    :precondition
      (and
        (job_assigned_prescriber_authorization ?dispensing_job ?prescriber_authorization)
      )
    :effect
      (and
        (prescriber_authorization_available ?prescriber_authorization)
        (not
          (job_assigned_prescriber_authorization ?dispensing_job ?prescriber_authorization)
        )
      )
  )
  (:action acknowledge_handling_flag_for_task
    :parameters (?technician_task_instance - technician_task_instance ?handling_category_flag - handling_category_flag ?medication_product - medication_product)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?technician_task_instance)
        (work_item_assigned_product ?technician_task_instance ?medication_product)
        (task_assigned_handling_flag ?technician_task_instance ?handling_category_flag)
        (not
          (handling_flag_acknowledged ?handling_category_flag)
        )
        (not
          (handling_flag_requires_substitution ?handling_category_flag)
        )
      )
    :effect (handling_flag_acknowledged ?handling_category_flag)
  )
  (:action apply_credential_and_mark_technician_prepared
    :parameters (?technician_task_instance - technician_task_instance ?handling_category_flag - handling_category_flag ?authorizing_pharmacist_credential - authorizing_pharmacist_credential)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?technician_task_instance)
        (work_item_assigned_credential ?technician_task_instance ?authorizing_pharmacist_credential)
        (task_assigned_handling_flag ?technician_task_instance ?handling_category_flag)
        (handling_flag_acknowledged ?handling_category_flag)
        (not
          (technician_task_ready ?technician_task_instance)
        )
      )
    :effect
      (and
        (technician_task_ready ?technician_task_instance)
        (task_preparation_completed ?technician_task_instance)
      )
  )
  (:action allocate_substitution_and_mark_technician_ready
    :parameters (?technician_task_instance - technician_task_instance ?handling_category_flag - handling_category_flag ?substitution_option - substitution_option)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?technician_task_instance)
        (task_assigned_handling_flag ?technician_task_instance ?handling_category_flag)
        (substitution_option_available ?substitution_option)
        (not
          (technician_task_ready ?technician_task_instance)
        )
      )
    :effect
      (and
        (handling_flag_requires_substitution ?handling_category_flag)
        (technician_task_ready ?technician_task_instance)
        (task_assigned_substitution_option ?technician_task_instance ?substitution_option)
        (not
          (substitution_option_available ?substitution_option)
        )
      )
  )
  (:action finalize_substitution_allocation
    :parameters (?technician_task_instance - technician_task_instance ?handling_category_flag - handling_category_flag ?medication_product - medication_product ?substitution_option - substitution_option)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?technician_task_instance)
        (work_item_assigned_product ?technician_task_instance ?medication_product)
        (task_assigned_handling_flag ?technician_task_instance ?handling_category_flag)
        (handling_flag_requires_substitution ?handling_category_flag)
        (task_assigned_substitution_option ?technician_task_instance ?substitution_option)
        (not
          (task_preparation_completed ?technician_task_instance)
        )
      )
    :effect
      (and
        (handling_flag_acknowledged ?handling_category_flag)
        (task_preparation_completed ?technician_task_instance)
        (substitution_option_available ?substitution_option)
        (not
          (task_assigned_substitution_option ?technician_task_instance ?substitution_option)
        )
      )
  )
  (:action select_label_template_for_pharmacist_task
    :parameters (?pharmacist_task_instance - pharmacist_task_instance ?labeling_template - labeling_template ?medication_product - medication_product)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?pharmacist_task_instance)
        (work_item_assigned_product ?pharmacist_task_instance ?medication_product)
        (pharmacist_assigned_label_template ?pharmacist_task_instance ?labeling_template)
        (not
          (labeling_template_selected ?labeling_template)
        )
        (not
          (labeling_template_reserved ?labeling_template)
        )
      )
    :effect (labeling_template_selected ?labeling_template)
  )
  (:action assign_credential_and_mark_pharmacist_ready
    :parameters (?pharmacist_task_instance - pharmacist_task_instance ?labeling_template - labeling_template ?authorizing_pharmacist_credential - authorizing_pharmacist_credential)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?pharmacist_task_instance)
        (work_item_assigned_credential ?pharmacist_task_instance ?authorizing_pharmacist_credential)
        (pharmacist_assigned_label_template ?pharmacist_task_instance ?labeling_template)
        (labeling_template_selected ?labeling_template)
        (not
          (pharmacist_task_ready ?pharmacist_task_instance)
        )
      )
    :effect
      (and
        (pharmacist_task_ready ?pharmacist_task_instance)
        (pharmacist_authorization_completed ?pharmacist_task_instance)
      )
  )
  (:action assign_substitution_option_and_mark_pharmacist_ready
    :parameters (?pharmacist_task_instance - pharmacist_task_instance ?labeling_template - labeling_template ?substitution_option - substitution_option)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?pharmacist_task_instance)
        (pharmacist_assigned_label_template ?pharmacist_task_instance ?labeling_template)
        (substitution_option_available ?substitution_option)
        (not
          (pharmacist_task_ready ?pharmacist_task_instance)
        )
      )
    :effect
      (and
        (labeling_template_reserved ?labeling_template)
        (pharmacist_task_ready ?pharmacist_task_instance)
        (pharmacist_assigned_substitution_option ?pharmacist_task_instance ?substitution_option)
        (not
          (substitution_option_available ?substitution_option)
        )
      )
  )
  (:action finalize_pharmacist_substitution_allocation
    :parameters (?pharmacist_task_instance - pharmacist_task_instance ?labeling_template - labeling_template ?medication_product - medication_product ?substitution_option - substitution_option)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?pharmacist_task_instance)
        (work_item_assigned_product ?pharmacist_task_instance ?medication_product)
        (pharmacist_assigned_label_template ?pharmacist_task_instance ?labeling_template)
        (labeling_template_reserved ?labeling_template)
        (pharmacist_assigned_substitution_option ?pharmacist_task_instance ?substitution_option)
        (not
          (pharmacist_authorization_completed ?pharmacist_task_instance)
        )
      )
    :effect
      (and
        (labeling_template_selected ?labeling_template)
        (pharmacist_authorization_completed ?pharmacist_task_instance)
        (substitution_option_available ?substitution_option)
        (not
          (pharmacist_assigned_substitution_option ?pharmacist_task_instance ?substitution_option)
        )
      )
  )
  (:action assemble_package_standard
    :parameters (?technician_task_instance - technician_task_instance ?pharmacist_task_instance - pharmacist_task_instance ?handling_category_flag - handling_category_flag ?labeling_template - labeling_template ?final_package - final_package)
    :precondition
      (and
        (technician_task_ready ?technician_task_instance)
        (pharmacist_task_ready ?pharmacist_task_instance)
        (task_assigned_handling_flag ?technician_task_instance ?handling_category_flag)
        (pharmacist_assigned_label_template ?pharmacist_task_instance ?labeling_template)
        (handling_flag_acknowledged ?handling_category_flag)
        (labeling_template_selected ?labeling_template)
        (task_preparation_completed ?technician_task_instance)
        (pharmacist_authorization_completed ?pharmacist_task_instance)
        (package_slot_available ?final_package)
      )
    :effect
      (and
        (package_created ?final_package)
        (package_assigned_handling_flag ?final_package ?handling_category_flag)
        (package_assigned_label_template ?final_package ?labeling_template)
        (not
          (package_slot_available ?final_package)
        )
      )
  )
  (:action assemble_package_with_auxiliary_material
    :parameters (?technician_task_instance - technician_task_instance ?pharmacist_task_instance - pharmacist_task_instance ?handling_category_flag - handling_category_flag ?labeling_template - labeling_template ?final_package - final_package)
    :precondition
      (and
        (technician_task_ready ?technician_task_instance)
        (pharmacist_task_ready ?pharmacist_task_instance)
        (task_assigned_handling_flag ?technician_task_instance ?handling_category_flag)
        (pharmacist_assigned_label_template ?pharmacist_task_instance ?labeling_template)
        (handling_flag_requires_substitution ?handling_category_flag)
        (labeling_template_selected ?labeling_template)
        (not
          (task_preparation_completed ?technician_task_instance)
        )
        (pharmacist_authorization_completed ?pharmacist_task_instance)
        (package_slot_available ?final_package)
      )
    :effect
      (and
        (package_created ?final_package)
        (package_assigned_handling_flag ?final_package ?handling_category_flag)
        (package_assigned_label_template ?final_package ?labeling_template)
        (package_includes_auxiliary_material_a ?final_package)
        (not
          (package_slot_available ?final_package)
        )
      )
  )
  (:action assemble_package_variant_b
    :parameters (?technician_task_instance - technician_task_instance ?pharmacist_task_instance - pharmacist_task_instance ?handling_category_flag - handling_category_flag ?labeling_template - labeling_template ?final_package - final_package)
    :precondition
      (and
        (technician_task_ready ?technician_task_instance)
        (pharmacist_task_ready ?pharmacist_task_instance)
        (task_assigned_handling_flag ?technician_task_instance ?handling_category_flag)
        (pharmacist_assigned_label_template ?pharmacist_task_instance ?labeling_template)
        (handling_flag_acknowledged ?handling_category_flag)
        (labeling_template_reserved ?labeling_template)
        (task_preparation_completed ?technician_task_instance)
        (not
          (pharmacist_authorization_completed ?pharmacist_task_instance)
        )
        (package_slot_available ?final_package)
      )
    :effect
      (and
        (package_created ?final_package)
        (package_assigned_handling_flag ?final_package ?handling_category_flag)
        (package_assigned_label_template ?final_package ?labeling_template)
        (package_includes_auxiliary_material_b ?final_package)
        (not
          (package_slot_available ?final_package)
        )
      )
  )
  (:action assemble_package_variant_c
    :parameters (?technician_task_instance - technician_task_instance ?pharmacist_task_instance - pharmacist_task_instance ?handling_category_flag - handling_category_flag ?labeling_template - labeling_template ?final_package - final_package)
    :precondition
      (and
        (technician_task_ready ?technician_task_instance)
        (pharmacist_task_ready ?pharmacist_task_instance)
        (task_assigned_handling_flag ?technician_task_instance ?handling_category_flag)
        (pharmacist_assigned_label_template ?pharmacist_task_instance ?labeling_template)
        (handling_flag_requires_substitution ?handling_category_flag)
        (labeling_template_reserved ?labeling_template)
        (not
          (task_preparation_completed ?technician_task_instance)
        )
        (not
          (pharmacist_authorization_completed ?pharmacist_task_instance)
        )
        (package_slot_available ?final_package)
      )
    :effect
      (and
        (package_created ?final_package)
        (package_assigned_handling_flag ?final_package ?handling_category_flag)
        (package_assigned_label_template ?final_package ?labeling_template)
        (package_includes_auxiliary_material_a ?final_package)
        (package_includes_auxiliary_material_b ?final_package)
        (not
          (package_slot_available ?final_package)
        )
      )
  )
  (:action finalize_package_labeling
    :parameters (?final_package - final_package ?technician_task_instance - technician_task_instance ?medication_product - medication_product)
    :precondition
      (and
        (package_created ?final_package)
        (technician_task_ready ?technician_task_instance)
        (work_item_assigned_product ?technician_task_instance ?medication_product)
        (not
          (package_labeling_finalized ?final_package)
        )
      )
    :effect (package_labeling_finalized ?final_package)
  )
  (:action allocate_container_to_package
    :parameters (?dispensing_job - dispensing_job ?container_or_unit_of_use - container_or_unit_of_use ?final_package - final_package)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?dispensing_job)
        (job_assigned_package ?dispensing_job ?final_package)
        (job_allowed_container ?dispensing_job ?container_or_unit_of_use)
        (container_available ?container_or_unit_of_use)
        (package_created ?final_package)
        (package_labeling_finalized ?final_package)
        (not
          (container_allocated ?container_or_unit_of_use)
        )
      )
    :effect
      (and
        (container_allocated ?container_or_unit_of_use)
        (container_assigned_to_package ?container_or_unit_of_use ?final_package)
        (not
          (container_available ?container_or_unit_of_use)
        )
      )
  )
  (:action prepare_job_for_auxiliary_attachment
    :parameters (?dispensing_job - dispensing_job ?container_or_unit_of_use - container_or_unit_of_use ?final_package - final_package ?medication_product - medication_product)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?dispensing_job)
        (job_allowed_container ?dispensing_job ?container_or_unit_of_use)
        (container_allocated ?container_or_unit_of_use)
        (container_assigned_to_package ?container_or_unit_of_use ?final_package)
        (work_item_assigned_product ?dispensing_job ?medication_product)
        (not
          (package_includes_auxiliary_material_a ?final_package)
        )
        (not
          (job_open_for_auxiliary_selection ?dispensing_job)
        )
      )
    :effect (job_open_for_auxiliary_selection ?dispensing_job)
  )
  (:action reserve_auxiliary_material_for_job
    :parameters (?dispensing_job - dispensing_job ?auxiliary_material - auxiliary_material)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?dispensing_job)
        (auxiliary_material_available ?auxiliary_material)
        (not
          (auxiliary_material_reserved_for_job ?dispensing_job)
        )
      )
    :effect
      (and
        (auxiliary_material_reserved_for_job ?dispensing_job)
        (job_assigned_auxiliary_material ?dispensing_job ?auxiliary_material)
        (not
          (auxiliary_material_available ?auxiliary_material)
        )
      )
  )
  (:action attach_auxiliary_material_to_job
    :parameters (?dispensing_job - dispensing_job ?container_or_unit_of_use - container_or_unit_of_use ?final_package - final_package ?medication_product - medication_product ?auxiliary_material - auxiliary_material)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?dispensing_job)
        (job_allowed_container ?dispensing_job ?container_or_unit_of_use)
        (container_allocated ?container_or_unit_of_use)
        (container_assigned_to_package ?container_or_unit_of_use ?final_package)
        (work_item_assigned_product ?dispensing_job ?medication_product)
        (package_includes_auxiliary_material_a ?final_package)
        (auxiliary_material_reserved_for_job ?dispensing_job)
        (job_assigned_auxiliary_material ?dispensing_job ?auxiliary_material)
        (not
          (job_open_for_auxiliary_selection ?dispensing_job)
        )
      )
    :effect
      (and
        (job_open_for_auxiliary_selection ?dispensing_job)
        (auxiliary_material_attachment_recorded ?dispensing_job)
      )
  )
  (:action assign_clinical_check_and_reserve_materials_v1
    :parameters (?dispensing_job - dispensing_job ?clinical_check_record - clinical_check_record ?authorizing_pharmacist_credential - authorizing_pharmacist_credential ?container_or_unit_of_use - container_or_unit_of_use ?final_package - final_package)
    :precondition
      (and
        (job_open_for_auxiliary_selection ?dispensing_job)
        (job_assigned_clinical_check_record ?dispensing_job ?clinical_check_record)
        (work_item_assigned_credential ?dispensing_job ?authorizing_pharmacist_credential)
        (job_allowed_container ?dispensing_job ?container_or_unit_of_use)
        (container_assigned_to_package ?container_or_unit_of_use ?final_package)
        (not
          (package_includes_auxiliary_material_b ?final_package)
        )
        (not
          (job_auxiliary_materials_reserved ?dispensing_job)
        )
      )
    :effect (job_auxiliary_materials_reserved ?dispensing_job)
  )
  (:action assign_clinical_check_and_reserve_materials_v2
    :parameters (?dispensing_job - dispensing_job ?clinical_check_record - clinical_check_record ?authorizing_pharmacist_credential - authorizing_pharmacist_credential ?container_or_unit_of_use - container_or_unit_of_use ?final_package - final_package)
    :precondition
      (and
        (job_open_for_auxiliary_selection ?dispensing_job)
        (job_assigned_clinical_check_record ?dispensing_job ?clinical_check_record)
        (work_item_assigned_credential ?dispensing_job ?authorizing_pharmacist_credential)
        (job_allowed_container ?dispensing_job ?container_or_unit_of_use)
        (container_assigned_to_package ?container_or_unit_of_use ?final_package)
        (package_includes_auxiliary_material_b ?final_package)
        (not
          (job_auxiliary_materials_reserved ?dispensing_job)
        )
      )
    :effect (job_auxiliary_materials_reserved ?dispensing_job)
  )
  (:action apply_prescriber_authorization_and_mark_ready_v1
    :parameters (?dispensing_job - dispensing_job ?prescriber_authorization - prescriber_authorization ?container_or_unit_of_use - container_or_unit_of_use ?final_package - final_package)
    :precondition
      (and
        (job_auxiliary_materials_reserved ?dispensing_job)
        (job_assigned_prescriber_authorization ?dispensing_job ?prescriber_authorization)
        (job_allowed_container ?dispensing_job ?container_or_unit_of_use)
        (container_assigned_to_package ?container_or_unit_of_use ?final_package)
        (not
          (package_includes_auxiliary_material_a ?final_package)
        )
        (not
          (package_includes_auxiliary_material_b ?final_package)
        )
        (not
          (job_ready_for_verification ?dispensing_job)
        )
      )
    :effect (job_ready_for_verification ?dispensing_job)
  )
  (:action apply_prescriber_authorization_and_mark_ready_v2
    :parameters (?dispensing_job - dispensing_job ?prescriber_authorization - prescriber_authorization ?container_or_unit_of_use - container_or_unit_of_use ?final_package - final_package)
    :precondition
      (and
        (job_auxiliary_materials_reserved ?dispensing_job)
        (job_assigned_prescriber_authorization ?dispensing_job ?prescriber_authorization)
        (job_allowed_container ?dispensing_job ?container_or_unit_of_use)
        (container_assigned_to_package ?container_or_unit_of_use ?final_package)
        (package_includes_auxiliary_material_a ?final_package)
        (not
          (package_includes_auxiliary_material_b ?final_package)
        )
        (not
          (job_ready_for_verification ?dispensing_job)
        )
      )
    :effect
      (and
        (job_ready_for_verification ?dispensing_job)
        (auxiliary_materials_attached ?dispensing_job)
      )
  )
  (:action apply_prescriber_authorization_and_mark_ready_v3
    :parameters (?dispensing_job - dispensing_job ?prescriber_authorization - prescriber_authorization ?container_or_unit_of_use - container_or_unit_of_use ?final_package - final_package)
    :precondition
      (and
        (job_auxiliary_materials_reserved ?dispensing_job)
        (job_assigned_prescriber_authorization ?dispensing_job ?prescriber_authorization)
        (job_allowed_container ?dispensing_job ?container_or_unit_of_use)
        (container_assigned_to_package ?container_or_unit_of_use ?final_package)
        (not
          (package_includes_auxiliary_material_a ?final_package)
        )
        (package_includes_auxiliary_material_b ?final_package)
        (not
          (job_ready_for_verification ?dispensing_job)
        )
      )
    :effect
      (and
        (job_ready_for_verification ?dispensing_job)
        (auxiliary_materials_attached ?dispensing_job)
      )
  )
  (:action apply_prescriber_authorization_and_mark_ready_v4
    :parameters (?dispensing_job - dispensing_job ?prescriber_authorization - prescriber_authorization ?container_or_unit_of_use - container_or_unit_of_use ?final_package - final_package)
    :precondition
      (and
        (job_auxiliary_materials_reserved ?dispensing_job)
        (job_assigned_prescriber_authorization ?dispensing_job ?prescriber_authorization)
        (job_allowed_container ?dispensing_job ?container_or_unit_of_use)
        (container_assigned_to_package ?container_or_unit_of_use ?final_package)
        (package_includes_auxiliary_material_a ?final_package)
        (package_includes_auxiliary_material_b ?final_package)
        (not
          (job_ready_for_verification ?dispensing_job)
        )
      )
    :effect
      (and
        (job_ready_for_verification ?dispensing_job)
        (auxiliary_materials_attached ?dispensing_job)
      )
  )
  (:action record_verification_and_mark_ready_v1
    :parameters (?dispensing_job - dispensing_job)
    :precondition
      (and
        (job_ready_for_verification ?dispensing_job)
        (not
          (auxiliary_materials_attached ?dispensing_job)
        )
        (not
          (verification_signoff_recorded ?dispensing_job)
        )
      )
    :effect
      (and
        (verification_signoff_recorded ?dispensing_job)
        (ready_for_instruction_generation ?dispensing_job)
      )
  )
  (:action attach_fulfillment_channel_and_record
    :parameters (?dispensing_job - dispensing_job ?fulfillment_channel - fulfillment_channel)
    :precondition
      (and
        (job_ready_for_verification ?dispensing_job)
        (auxiliary_materials_attached ?dispensing_job)
        (fulfillment_channel_available ?fulfillment_channel)
      )
    :effect
      (and
        (job_assigned_fulfillment_channel ?dispensing_job ?fulfillment_channel)
        (not
          (fulfillment_channel_available ?fulfillment_channel)
        )
      )
  )
  (:action perform_pharmacist_verification_and_mark_job
    :parameters (?dispensing_job - dispensing_job ?technician_task_instance - technician_task_instance ?pharmacist_task_instance - pharmacist_task_instance ?medication_product - medication_product ?fulfillment_channel - fulfillment_channel)
    :precondition
      (and
        (job_ready_for_verification ?dispensing_job)
        (auxiliary_materials_attached ?dispensing_job)
        (job_assigned_fulfillment_channel ?dispensing_job ?fulfillment_channel)
        (job_assigned_technician_task ?dispensing_job ?technician_task_instance)
        (job_assigned_pharmacist_task ?dispensing_job ?pharmacist_task_instance)
        (task_preparation_completed ?technician_task_instance)
        (pharmacist_authorization_completed ?pharmacist_task_instance)
        (work_item_assigned_product ?dispensing_job ?medication_product)
        (not
          (pharmacist_verification_performed ?dispensing_job)
        )
      )
    :effect (pharmacist_verification_performed ?dispensing_job)
  )
  (:action finalize_verification_and_mark_ready_v2
    :parameters (?dispensing_job - dispensing_job)
    :precondition
      (and
        (job_ready_for_verification ?dispensing_job)
        (pharmacist_verification_performed ?dispensing_job)
        (not
          (verification_signoff_recorded ?dispensing_job)
        )
      )
    :effect
      (and
        (verification_signoff_recorded ?dispensing_job)
        (ready_for_instruction_generation ?dispensing_job)
      )
  )
  (:action claim_prior_authorization_for_job
    :parameters (?dispensing_job - dispensing_job ?payer_prior_authorization_record - payer_prior_authorization_record ?medication_product - medication_product)
    :precondition
      (and
        (work_item_ready_for_clinical_review ?dispensing_job)
        (work_item_assigned_product ?dispensing_job ?medication_product)
        (payer_prior_authorization_available ?payer_prior_authorization_record)
        (job_assigned_prior_authorization ?dispensing_job ?payer_prior_authorization_record)
        (not
          (prior_authorization_recorded_for_job ?dispensing_job)
        )
      )
    :effect
      (and
        (prior_authorization_recorded_for_job ?dispensing_job)
        (not
          (payer_prior_authorization_available ?payer_prior_authorization_record)
        )
      )
  )
  (:action mark_job_prior_authorization_materials_ready
    :parameters (?dispensing_job - dispensing_job ?authorizing_pharmacist_credential - authorizing_pharmacist_credential)
    :precondition
      (and
        (prior_authorization_recorded_for_job ?dispensing_job)
        (work_item_assigned_credential ?dispensing_job ?authorizing_pharmacist_credential)
        (not
          (prior_authorization_validated_for_job ?dispensing_job)
        )
      )
    :effect (prior_authorization_validated_for_job ?dispensing_job)
  )
  (:action record_prescriber_authorization_verification
    :parameters (?dispensing_job - dispensing_job ?prescriber_authorization - prescriber_authorization)
    :precondition
      (and
        (prior_authorization_validated_for_job ?dispensing_job)
        (job_assigned_prescriber_authorization ?dispensing_job ?prescriber_authorization)
        (not
          (prior_authorization_verified_for_job ?dispensing_job)
        )
      )
    :effect (prior_authorization_verified_for_job ?dispensing_job)
  )
  (:action finalize_prior_authorization_and_mark_ready
    :parameters (?dispensing_job - dispensing_job)
    :precondition
      (and
        (prior_authorization_verified_for_job ?dispensing_job)
        (not
          (verification_signoff_recorded ?dispensing_job)
        )
      )
    :effect
      (and
        (verification_signoff_recorded ?dispensing_job)
        (ready_for_instruction_generation ?dispensing_job)
      )
  )
  (:action finalize_task_release_for_technician
    :parameters (?technician_task_instance - technician_task_instance ?final_package - final_package)
    :precondition
      (and
        (technician_task_ready ?technician_task_instance)
        (task_preparation_completed ?technician_task_instance)
        (package_created ?final_package)
        (package_labeling_finalized ?final_package)
        (not
          (ready_for_instruction_generation ?technician_task_instance)
        )
      )
    :effect (ready_for_instruction_generation ?technician_task_instance)
  )
  (:action finalize_task_release_for_pharmacist
    :parameters (?pharmacist_task_instance - pharmacist_task_instance ?final_package - final_package)
    :precondition
      (and
        (pharmacist_task_ready ?pharmacist_task_instance)
        (pharmacist_authorization_completed ?pharmacist_task_instance)
        (package_created ?final_package)
        (package_labeling_finalized ?final_package)
        (not
          (ready_for_instruction_generation ?pharmacist_task_instance)
        )
      )
    :effect (ready_for_instruction_generation ?pharmacist_task_instance)
  )
  (:action attach_patient_instructions_to_case
    :parameters (?returned_medication_case - returned_medication_case ?patient_instruction_template - patient_instruction_template ?medication_product - medication_product)
    :precondition
      (and
        (ready_for_instruction_generation ?returned_medication_case)
        (work_item_assigned_product ?returned_medication_case ?medication_product)
        (patient_instruction_template_available ?patient_instruction_template)
        (not
          (patient_instructions_attached ?returned_medication_case)
        )
      )
    :effect
      (and
        (patient_instructions_attached ?returned_medication_case)
        (work_item_assigned_instruction_template ?returned_medication_case ?patient_instruction_template)
        (not
          (patient_instruction_template_available ?patient_instruction_template)
        )
      )
  )
  (:action finalize_disposition_and_release_technician_task
    :parameters (?technician_task_instance - technician_task_instance ?storage_location_or_bin - storage_location_or_bin ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (patient_instructions_attached ?technician_task_instance)
        (allocated_to_storage_bin ?technician_task_instance ?storage_location_or_bin)
        (work_item_assigned_instruction_template ?technician_task_instance ?patient_instruction_template)
        (not
          (work_item_disposition_finalized ?technician_task_instance)
        )
      )
    :effect
      (and
        (work_item_disposition_finalized ?technician_task_instance)
        (storage_bin_available ?storage_location_or_bin)
        (patient_instruction_template_available ?patient_instruction_template)
      )
  )
  (:action finalize_disposition_and_release_pharmacist_task
    :parameters (?pharmacist_task_instance - pharmacist_task_instance ?storage_location_or_bin - storage_location_or_bin ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (patient_instructions_attached ?pharmacist_task_instance)
        (allocated_to_storage_bin ?pharmacist_task_instance ?storage_location_or_bin)
        (work_item_assigned_instruction_template ?pharmacist_task_instance ?patient_instruction_template)
        (not
          (work_item_disposition_finalized ?pharmacist_task_instance)
        )
      )
    :effect
      (and
        (work_item_disposition_finalized ?pharmacist_task_instance)
        (storage_bin_available ?storage_location_or_bin)
        (patient_instruction_template_available ?patient_instruction_template)
      )
  )
  (:action finalize_disposition_and_release_job
    :parameters (?dispensing_job - dispensing_job ?storage_location_or_bin - storage_location_or_bin ?patient_instruction_template - patient_instruction_template)
    :precondition
      (and
        (patient_instructions_attached ?dispensing_job)
        (allocated_to_storage_bin ?dispensing_job ?storage_location_or_bin)
        (work_item_assigned_instruction_template ?dispensing_job ?patient_instruction_template)
        (not
          (work_item_disposition_finalized ?dispensing_job)
        )
      )
    :effect
      (and
        (work_item_disposition_finalized ?dispensing_job)
        (storage_bin_available ?storage_location_or_bin)
        (patient_instruction_template_available ?patient_instruction_template)
      )
  )
)

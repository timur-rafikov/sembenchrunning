(define (domain pharmaceutics_yield_loss_batch_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object document_category - object process_slot_category - object manufacturing_entity_class - object batch - manufacturing_entity_class production_line - resource_category operator - resource_category qualified_specialist - resource_category approval_token - resource_category assay_kit - resource_category yield_loss_response_document - resource_category calibration_certificate - resource_category qa_signatory - resource_category consumable_material - document_category in_process_sample - document_category deviation_report - document_category upstream_processing_slot - process_slot_category downstream_processing_slot - process_slot_category processing_order - process_slot_category unit_operation_category - batch record_group - batch upstream_unit_operation - unit_operation_category downstream_unit_operation - unit_operation_category batch_production_record - record_group)
  (:predicates
    (batch_initialized ?batch - batch)
    (entity_in_execution ?batch - batch)
    (production_line_assigned ?batch - batch)
    (mitigation_assigned_to_entity ?batch - batch)
    (entity_released ?batch - batch)
    (yield_loss_document_attached_to_entity ?batch - batch)
    (production_line_available ?production_line - production_line)
    (allocated_to_production_line ?batch - batch ?production_line - production_line)
    (operator_available ?operator_credential - operator)
    (operator_assigned_to_entity ?batch - batch ?operator_credential - operator)
    (qualified_specialist_available ?qualified_specialist - qualified_specialist)
    (specialist_assigned_to_entity ?batch - batch ?qualified_specialist - qualified_specialist)
    (consumable_available ?consumable_material - consumable_material)
    (material_allocated_upstream ?upstream_unit - upstream_unit_operation ?consumable_material - consumable_material)
    (material_allocated_downstream ?downstream_unit - downstream_unit_operation ?consumable_material - consumable_material)
    (upstream_unit_bound_to_slot ?upstream_unit - upstream_unit_operation ?upstream_slot - upstream_processing_slot)
    (upstream_slot_ready ?upstream_slot - upstream_processing_slot)
    (upstream_slot_material_loaded ?upstream_slot - upstream_processing_slot)
    (upstream_unit_ready_for_transfer ?upstream_unit - upstream_unit_operation)
    (downstream_unit_bound_to_slot ?downstream_unit - downstream_unit_operation ?downstream_slot - downstream_processing_slot)
    (downstream_slot_ready ?downstream_slot - downstream_processing_slot)
    (downstream_slot_material_loaded ?downstream_slot - downstream_processing_slot)
    (downstream_unit_ready_for_transfer ?downstream_unit - downstream_unit_operation)
    (processing_order_available ?processing_order - processing_order)
    (processing_order_active ?processing_order - processing_order)
    (processing_order_bound_to_upstream_slot ?processing_order - processing_order ?upstream_slot - upstream_processing_slot)
    (processing_order_bound_to_downstream_slot ?processing_order - processing_order ?downstream_slot - downstream_processing_slot)
    (processing_order_upstream_confirmed ?processing_order - processing_order)
    (processing_order_downstream_confirmed ?processing_order - processing_order)
    (processing_order_transfer_completed ?processing_order - processing_order)
    (record_linked_to_upstream_unit ?batch_production_record - batch_production_record ?upstream_unit - upstream_unit_operation)
    (record_linked_to_downstream_unit ?batch_production_record - batch_production_record ?downstream_unit - downstream_unit_operation)
    (record_linked_to_order ?batch_production_record - batch_production_record ?processing_order - processing_order)
    (sample_available ?in_process_sample - in_process_sample)
    (record_contains_sample ?batch_production_record - batch_production_record ?in_process_sample - in_process_sample)
    (sample_registered ?in_process_sample - in_process_sample)
    (sample_attached_to_order ?in_process_sample - in_process_sample ?processing_order - processing_order)
    (record_ready_for_analysis ?batch_production_record - batch_production_record)
    (analysis_result_attached ?batch_production_record - batch_production_record)
    (qa_review_completed ?batch_production_record - batch_production_record)
    (approval_token_applied ?batch_production_record - batch_production_record)
    (approval_flag_set ?batch_production_record - batch_production_record)
    (certificate_attached ?batch_production_record - batch_production_record)
    (final_checks_completed ?batch_production_record - batch_production_record)
    (deviation_report_available ?deviation_report - deviation_report)
    (record_linked_to_deviation ?batch_production_record - batch_production_record ?deviation_report - deviation_report)
    (deviation_attached ?batch_production_record - batch_production_record)
    (deviation_review_initiated ?batch_production_record - batch_production_record)
    (deviation_review_completed ?batch_production_record - batch_production_record)
    (approval_token_available ?approval_token - approval_token)
    (approval_token_attached_to_record ?batch_production_record - batch_production_record ?approval_token - approval_token)
    (assay_kit_available ?assay_kit - assay_kit)
    (assay_attached_to_record ?batch_production_record - batch_production_record ?assay_kit - assay_kit)
    (certificate_available ?calibration_certificate - calibration_certificate)
    (certificate_attached_to_record ?batch_production_record - batch_production_record ?calibration_certificate - calibration_certificate)
    (qa_signatory_available ?qa_signatory - qa_signatory)
    (qa_signatory_attached_to_record ?batch_production_record - batch_production_record ?qa_signatory - qa_signatory)
    (yield_loss_doc_available ?yield_loss_response_document - yield_loss_response_document)
    (yield_loss_document_linked_to_entity ?batch - batch ?yield_loss_response_document - yield_loss_response_document)
    (upstream_unit_prepared ?upstream_unit - upstream_unit_operation)
    (downstream_unit_prepared ?downstream_unit - downstream_unit_operation)
    (record_finalized ?batch_production_record - batch_production_record)
  )
  (:action initialize_batch
    :parameters (?batch - batch)
    :precondition
      (and
        (not
          (batch_initialized ?batch)
        )
        (not
          (mitigation_assigned_to_entity ?batch)
        )
      )
    :effect (batch_initialized ?batch)
  )
  (:action assign_production_line_to_batch
    :parameters (?batch - batch ?production_line - production_line)
    :precondition
      (and
        (batch_initialized ?batch)
        (not
          (production_line_assigned ?batch)
        )
        (production_line_available ?production_line)
      )
    :effect
      (and
        (production_line_assigned ?batch)
        (allocated_to_production_line ?batch ?production_line)
        (not
          (production_line_available ?production_line)
        )
      )
  )
  (:action assign_operator_to_batch
    :parameters (?batch - batch ?operator_credential - operator)
    :precondition
      (and
        (batch_initialized ?batch)
        (production_line_assigned ?batch)
        (operator_available ?operator_credential)
      )
    :effect
      (and
        (operator_assigned_to_entity ?batch ?operator_credential)
        (not
          (operator_available ?operator_credential)
        )
      )
  )
  (:action open_batch_production_record
    :parameters (?batch - batch ?operator_credential - operator)
    :precondition
      (and
        (batch_initialized ?batch)
        (production_line_assigned ?batch)
        (operator_assigned_to_entity ?batch ?operator_credential)
        (not
          (entity_in_execution ?batch)
        )
      )
    :effect (entity_in_execution ?batch)
  )
  (:action release_operator_from_batch
    :parameters (?batch - batch ?operator_credential - operator)
    :precondition
      (and
        (operator_assigned_to_entity ?batch ?operator_credential)
      )
    :effect
      (and
        (operator_available ?operator_credential)
        (not
          (operator_assigned_to_entity ?batch ?operator_credential)
        )
      )
  )
  (:action assign_support_specialist_to_batch
    :parameters (?batch - batch ?qualified_specialist - qualified_specialist)
    :precondition
      (and
        (entity_in_execution ?batch)
        (qualified_specialist_available ?qualified_specialist)
      )
    :effect
      (and
        (specialist_assigned_to_entity ?batch ?qualified_specialist)
        (not
          (qualified_specialist_available ?qualified_specialist)
        )
      )
  )
  (:action release_support_specialist_from_batch
    :parameters (?batch - batch ?qualified_specialist - qualified_specialist)
    :precondition
      (and
        (specialist_assigned_to_entity ?batch ?qualified_specialist)
      )
    :effect
      (and
        (qualified_specialist_available ?qualified_specialist)
        (not
          (specialist_assigned_to_entity ?batch ?qualified_specialist)
        )
      )
  )
  (:action attach_certificate_to_record
    :parameters (?batch_production_record - batch_production_record ?calibration_certificate - calibration_certificate)
    :precondition
      (and
        (entity_in_execution ?batch_production_record)
        (certificate_available ?calibration_certificate)
      )
    :effect
      (and
        (certificate_attached_to_record ?batch_production_record ?calibration_certificate)
        (not
          (certificate_available ?calibration_certificate)
        )
      )
  )
  (:action detach_certificate_from_record
    :parameters (?batch_production_record - batch_production_record ?calibration_certificate - calibration_certificate)
    :precondition
      (and
        (certificate_attached_to_record ?batch_production_record ?calibration_certificate)
      )
    :effect
      (and
        (certificate_available ?calibration_certificate)
        (not
          (certificate_attached_to_record ?batch_production_record ?calibration_certificate)
        )
      )
  )
  (:action attach_qa_signatory_to_record
    :parameters (?batch_production_record - batch_production_record ?qa_signatory - qa_signatory)
    :precondition
      (and
        (entity_in_execution ?batch_production_record)
        (qa_signatory_available ?qa_signatory)
      )
    :effect
      (and
        (qa_signatory_attached_to_record ?batch_production_record ?qa_signatory)
        (not
          (qa_signatory_available ?qa_signatory)
        )
      )
  )
  (:action detach_qa_signatory_from_record
    :parameters (?batch_production_record - batch_production_record ?qa_signatory - qa_signatory)
    :precondition
      (and
        (qa_signatory_attached_to_record ?batch_production_record ?qa_signatory)
      )
    :effect
      (and
        (qa_signatory_available ?qa_signatory)
        (not
          (qa_signatory_attached_to_record ?batch_production_record ?qa_signatory)
        )
      )
  )
  (:action prepare_upstream_slot_for_processing
    :parameters (?upstream_unit - upstream_unit_operation ?upstream_slot - upstream_processing_slot ?operator_credential - operator)
    :precondition
      (and
        (entity_in_execution ?upstream_unit)
        (operator_assigned_to_entity ?upstream_unit ?operator_credential)
        (upstream_unit_bound_to_slot ?upstream_unit ?upstream_slot)
        (not
          (upstream_slot_ready ?upstream_slot)
        )
        (not
          (upstream_slot_material_loaded ?upstream_slot)
        )
      )
    :effect (upstream_slot_ready ?upstream_slot)
  )
  (:action apply_specialist_intervention_upstream
    :parameters (?upstream_unit - upstream_unit_operation ?upstream_slot - upstream_processing_slot ?qualified_specialist - qualified_specialist)
    :precondition
      (and
        (entity_in_execution ?upstream_unit)
        (specialist_assigned_to_entity ?upstream_unit ?qualified_specialist)
        (upstream_unit_bound_to_slot ?upstream_unit ?upstream_slot)
        (upstream_slot_ready ?upstream_slot)
        (not
          (upstream_unit_prepared ?upstream_unit)
        )
      )
    :effect
      (and
        (upstream_unit_prepared ?upstream_unit)
        (upstream_unit_ready_for_transfer ?upstream_unit)
      )
  )
  (:action load_consumable_into_upstream_slot
    :parameters (?upstream_unit - upstream_unit_operation ?upstream_slot - upstream_processing_slot ?consumable_material - consumable_material)
    :precondition
      (and
        (entity_in_execution ?upstream_unit)
        (upstream_unit_bound_to_slot ?upstream_unit ?upstream_slot)
        (consumable_available ?consumable_material)
        (not
          (upstream_unit_prepared ?upstream_unit)
        )
      )
    :effect
      (and
        (upstream_slot_material_loaded ?upstream_slot)
        (upstream_unit_prepared ?upstream_unit)
        (material_allocated_upstream ?upstream_unit ?consumable_material)
        (not
          (consumable_available ?consumable_material)
        )
      )
  )
  (:action process_consumable_on_upstream_slot
    :parameters (?upstream_unit - upstream_unit_operation ?upstream_slot - upstream_processing_slot ?operator_credential - operator ?consumable_material - consumable_material)
    :precondition
      (and
        (entity_in_execution ?upstream_unit)
        (operator_assigned_to_entity ?upstream_unit ?operator_credential)
        (upstream_unit_bound_to_slot ?upstream_unit ?upstream_slot)
        (upstream_slot_material_loaded ?upstream_slot)
        (material_allocated_upstream ?upstream_unit ?consumable_material)
        (not
          (upstream_unit_ready_for_transfer ?upstream_unit)
        )
      )
    :effect
      (and
        (upstream_slot_ready ?upstream_slot)
        (upstream_unit_ready_for_transfer ?upstream_unit)
        (consumable_available ?consumable_material)
        (not
          (material_allocated_upstream ?upstream_unit ?consumable_material)
        )
      )
  )
  (:action prepare_downstream_slot_for_processing
    :parameters (?downstream_unit - downstream_unit_operation ?downstream_slot - downstream_processing_slot ?operator_credential - operator)
    :precondition
      (and
        (entity_in_execution ?downstream_unit)
        (operator_assigned_to_entity ?downstream_unit ?operator_credential)
        (downstream_unit_bound_to_slot ?downstream_unit ?downstream_slot)
        (not
          (downstream_slot_ready ?downstream_slot)
        )
        (not
          (downstream_slot_material_loaded ?downstream_slot)
        )
      )
    :effect (downstream_slot_ready ?downstream_slot)
  )
  (:action apply_specialist_intervention_downstream
    :parameters (?downstream_unit - downstream_unit_operation ?downstream_slot - downstream_processing_slot ?qualified_specialist - qualified_specialist)
    :precondition
      (and
        (entity_in_execution ?downstream_unit)
        (specialist_assigned_to_entity ?downstream_unit ?qualified_specialist)
        (downstream_unit_bound_to_slot ?downstream_unit ?downstream_slot)
        (downstream_slot_ready ?downstream_slot)
        (not
          (downstream_unit_prepared ?downstream_unit)
        )
      )
    :effect
      (and
        (downstream_unit_prepared ?downstream_unit)
        (downstream_unit_ready_for_transfer ?downstream_unit)
      )
  )
  (:action load_consumable_into_downstream_slot
    :parameters (?downstream_unit - downstream_unit_operation ?downstream_slot - downstream_processing_slot ?consumable_material - consumable_material)
    :precondition
      (and
        (entity_in_execution ?downstream_unit)
        (downstream_unit_bound_to_slot ?downstream_unit ?downstream_slot)
        (consumable_available ?consumable_material)
        (not
          (downstream_unit_prepared ?downstream_unit)
        )
      )
    :effect
      (and
        (downstream_slot_material_loaded ?downstream_slot)
        (downstream_unit_prepared ?downstream_unit)
        (material_allocated_downstream ?downstream_unit ?consumable_material)
        (not
          (consumable_available ?consumable_material)
        )
      )
  )
  (:action process_consumable_on_downstream_slot
    :parameters (?downstream_unit - downstream_unit_operation ?downstream_slot - downstream_processing_slot ?operator_credential - operator ?consumable_material - consumable_material)
    :precondition
      (and
        (entity_in_execution ?downstream_unit)
        (operator_assigned_to_entity ?downstream_unit ?operator_credential)
        (downstream_unit_bound_to_slot ?downstream_unit ?downstream_slot)
        (downstream_slot_material_loaded ?downstream_slot)
        (material_allocated_downstream ?downstream_unit ?consumable_material)
        (not
          (downstream_unit_ready_for_transfer ?downstream_unit)
        )
      )
    :effect
      (and
        (downstream_slot_ready ?downstream_slot)
        (downstream_unit_ready_for_transfer ?downstream_unit)
        (consumable_available ?consumable_material)
        (not
          (material_allocated_downstream ?downstream_unit ?consumable_material)
        )
      )
  )
  (:action create_processing_order_and_bind_slots
    :parameters (?upstream_unit - upstream_unit_operation ?downstream_unit - downstream_unit_operation ?upstream_slot - upstream_processing_slot ?downstream_slot - downstream_processing_slot ?processing_order - processing_order)
    :precondition
      (and
        (upstream_unit_prepared ?upstream_unit)
        (downstream_unit_prepared ?downstream_unit)
        (upstream_unit_bound_to_slot ?upstream_unit ?upstream_slot)
        (downstream_unit_bound_to_slot ?downstream_unit ?downstream_slot)
        (upstream_slot_ready ?upstream_slot)
        (downstream_slot_ready ?downstream_slot)
        (upstream_unit_ready_for_transfer ?upstream_unit)
        (downstream_unit_ready_for_transfer ?downstream_unit)
        (processing_order_available ?processing_order)
      )
    :effect
      (and
        (processing_order_active ?processing_order)
        (processing_order_bound_to_upstream_slot ?processing_order ?upstream_slot)
        (processing_order_bound_to_downstream_slot ?processing_order ?downstream_slot)
        (not
          (processing_order_available ?processing_order)
        )
      )
  )
  (:action create_processing_order_with_upstream_loaded
    :parameters (?upstream_unit - upstream_unit_operation ?downstream_unit - downstream_unit_operation ?upstream_slot - upstream_processing_slot ?downstream_slot - downstream_processing_slot ?processing_order - processing_order)
    :precondition
      (and
        (upstream_unit_prepared ?upstream_unit)
        (downstream_unit_prepared ?downstream_unit)
        (upstream_unit_bound_to_slot ?upstream_unit ?upstream_slot)
        (downstream_unit_bound_to_slot ?downstream_unit ?downstream_slot)
        (upstream_slot_material_loaded ?upstream_slot)
        (downstream_slot_ready ?downstream_slot)
        (not
          (upstream_unit_ready_for_transfer ?upstream_unit)
        )
        (downstream_unit_ready_for_transfer ?downstream_unit)
        (processing_order_available ?processing_order)
      )
    :effect
      (and
        (processing_order_active ?processing_order)
        (processing_order_bound_to_upstream_slot ?processing_order ?upstream_slot)
        (processing_order_bound_to_downstream_slot ?processing_order ?downstream_slot)
        (processing_order_upstream_confirmed ?processing_order)
        (not
          (processing_order_available ?processing_order)
        )
      )
  )
  (:action create_processing_order_with_downstream_loaded
    :parameters (?upstream_unit - upstream_unit_operation ?downstream_unit - downstream_unit_operation ?upstream_slot - upstream_processing_slot ?downstream_slot - downstream_processing_slot ?processing_order - processing_order)
    :precondition
      (and
        (upstream_unit_prepared ?upstream_unit)
        (downstream_unit_prepared ?downstream_unit)
        (upstream_unit_bound_to_slot ?upstream_unit ?upstream_slot)
        (downstream_unit_bound_to_slot ?downstream_unit ?downstream_slot)
        (upstream_slot_ready ?upstream_slot)
        (downstream_slot_material_loaded ?downstream_slot)
        (upstream_unit_ready_for_transfer ?upstream_unit)
        (not
          (downstream_unit_ready_for_transfer ?downstream_unit)
        )
        (processing_order_available ?processing_order)
      )
    :effect
      (and
        (processing_order_active ?processing_order)
        (processing_order_bound_to_upstream_slot ?processing_order ?upstream_slot)
        (processing_order_bound_to_downstream_slot ?processing_order ?downstream_slot)
        (processing_order_downstream_confirmed ?processing_order)
        (not
          (processing_order_available ?processing_order)
        )
      )
  )
  (:action create_processing_order_with_both_loaded
    :parameters (?upstream_unit - upstream_unit_operation ?downstream_unit - downstream_unit_operation ?upstream_slot - upstream_processing_slot ?downstream_slot - downstream_processing_slot ?processing_order - processing_order)
    :precondition
      (and
        (upstream_unit_prepared ?upstream_unit)
        (downstream_unit_prepared ?downstream_unit)
        (upstream_unit_bound_to_slot ?upstream_unit ?upstream_slot)
        (downstream_unit_bound_to_slot ?downstream_unit ?downstream_slot)
        (upstream_slot_material_loaded ?upstream_slot)
        (downstream_slot_material_loaded ?downstream_slot)
        (not
          (upstream_unit_ready_for_transfer ?upstream_unit)
        )
        (not
          (downstream_unit_ready_for_transfer ?downstream_unit)
        )
        (processing_order_available ?processing_order)
      )
    :effect
      (and
        (processing_order_active ?processing_order)
        (processing_order_bound_to_upstream_slot ?processing_order ?upstream_slot)
        (processing_order_bound_to_downstream_slot ?processing_order ?downstream_slot)
        (processing_order_upstream_confirmed ?processing_order)
        (processing_order_downstream_confirmed ?processing_order)
        (not
          (processing_order_available ?processing_order)
        )
      )
  )
  (:action execute_processing_order_transfer
    :parameters (?processing_order - processing_order ?upstream_unit - upstream_unit_operation ?operator_credential - operator)
    :precondition
      (and
        (processing_order_active ?processing_order)
        (upstream_unit_prepared ?upstream_unit)
        (operator_assigned_to_entity ?upstream_unit ?operator_credential)
        (not
          (processing_order_transfer_completed ?processing_order)
        )
      )
    :effect (processing_order_transfer_completed ?processing_order)
  )
  (:action register_sample_and_attach_to_record
    :parameters (?batch_production_record - batch_production_record ?in_process_sample - in_process_sample ?processing_order - processing_order)
    :precondition
      (and
        (entity_in_execution ?batch_production_record)
        (record_linked_to_order ?batch_production_record ?processing_order)
        (record_contains_sample ?batch_production_record ?in_process_sample)
        (sample_available ?in_process_sample)
        (processing_order_active ?processing_order)
        (processing_order_transfer_completed ?processing_order)
        (not
          (sample_registered ?in_process_sample)
        )
      )
    :effect
      (and
        (sample_registered ?in_process_sample)
        (sample_attached_to_order ?in_process_sample ?processing_order)
        (not
          (sample_available ?in_process_sample)
        )
      )
  )
  (:action validate_sample_and_mark_record_ready
    :parameters (?batch_production_record - batch_production_record ?in_process_sample - in_process_sample ?processing_order - processing_order ?operator_credential - operator)
    :precondition
      (and
        (entity_in_execution ?batch_production_record)
        (record_contains_sample ?batch_production_record ?in_process_sample)
        (sample_registered ?in_process_sample)
        (sample_attached_to_order ?in_process_sample ?processing_order)
        (operator_assigned_to_entity ?batch_production_record ?operator_credential)
        (not
          (processing_order_upstream_confirmed ?processing_order)
        )
        (not
          (record_ready_for_analysis ?batch_production_record)
        )
      )
    :effect (record_ready_for_analysis ?batch_production_record)
  )
  (:action apply_approval_token_to_record
    :parameters (?batch_production_record - batch_production_record ?approval_token - approval_token)
    :precondition
      (and
        (entity_in_execution ?batch_production_record)
        (approval_token_available ?approval_token)
        (not
          (approval_token_applied ?batch_production_record)
        )
      )
    :effect
      (and
        (approval_token_applied ?batch_production_record)
        (approval_token_attached_to_record ?batch_production_record ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action process_approval_and_mark_record_ready
    :parameters (?batch_production_record - batch_production_record ?in_process_sample - in_process_sample ?processing_order - processing_order ?operator_credential - operator ?approval_token - approval_token)
    :precondition
      (and
        (entity_in_execution ?batch_production_record)
        (record_contains_sample ?batch_production_record ?in_process_sample)
        (sample_registered ?in_process_sample)
        (sample_attached_to_order ?in_process_sample ?processing_order)
        (operator_assigned_to_entity ?batch_production_record ?operator_credential)
        (processing_order_upstream_confirmed ?processing_order)
        (approval_token_applied ?batch_production_record)
        (approval_token_attached_to_record ?batch_production_record ?approval_token)
        (not
          (record_ready_for_analysis ?batch_production_record)
        )
      )
    :effect
      (and
        (record_ready_for_analysis ?batch_production_record)
        (approval_flag_set ?batch_production_record)
      )
  )
  (:action attach_certificate_and_queue_analysis_result
    :parameters (?batch_production_record - batch_production_record ?calibration_certificate - calibration_certificate ?qualified_specialist - qualified_specialist ?in_process_sample - in_process_sample ?processing_order - processing_order)
    :precondition
      (and
        (record_ready_for_analysis ?batch_production_record)
        (certificate_attached_to_record ?batch_production_record ?calibration_certificate)
        (specialist_assigned_to_entity ?batch_production_record ?qualified_specialist)
        (record_contains_sample ?batch_production_record ?in_process_sample)
        (sample_attached_to_order ?in_process_sample ?processing_order)
        (not
          (processing_order_downstream_confirmed ?processing_order)
        )
        (not
          (analysis_result_attached ?batch_production_record)
        )
      )
    :effect (analysis_result_attached ?batch_production_record)
  )
  (:action attach_certificate_and_queue_analysis_result_variant
    :parameters (?batch_production_record - batch_production_record ?calibration_certificate - calibration_certificate ?qualified_specialist - qualified_specialist ?in_process_sample - in_process_sample ?processing_order - processing_order)
    :precondition
      (and
        (record_ready_for_analysis ?batch_production_record)
        (certificate_attached_to_record ?batch_production_record ?calibration_certificate)
        (specialist_assigned_to_entity ?batch_production_record ?qualified_specialist)
        (record_contains_sample ?batch_production_record ?in_process_sample)
        (sample_attached_to_order ?in_process_sample ?processing_order)
        (processing_order_downstream_confirmed ?processing_order)
        (not
          (analysis_result_attached ?batch_production_record)
        )
      )
    :effect (analysis_result_attached ?batch_production_record)
  )
  (:action apply_qa_signatory_and_mark
    :parameters (?batch_production_record - batch_production_record ?qa_signatory - qa_signatory ?in_process_sample - in_process_sample ?processing_order - processing_order)
    :precondition
      (and
        (analysis_result_attached ?batch_production_record)
        (qa_signatory_attached_to_record ?batch_production_record ?qa_signatory)
        (record_contains_sample ?batch_production_record ?in_process_sample)
        (sample_attached_to_order ?in_process_sample ?processing_order)
        (not
          (processing_order_upstream_confirmed ?processing_order)
        )
        (not
          (processing_order_downstream_confirmed ?processing_order)
        )
        (not
          (qa_review_completed ?batch_production_record)
        )
      )
    :effect (qa_review_completed ?batch_production_record)
  )
  (:action apply_qa_signatory_and_attach_certificate
    :parameters (?batch_production_record - batch_production_record ?qa_signatory - qa_signatory ?in_process_sample - in_process_sample ?processing_order - processing_order)
    :precondition
      (and
        (analysis_result_attached ?batch_production_record)
        (qa_signatory_attached_to_record ?batch_production_record ?qa_signatory)
        (record_contains_sample ?batch_production_record ?in_process_sample)
        (sample_attached_to_order ?in_process_sample ?processing_order)
        (processing_order_upstream_confirmed ?processing_order)
        (not
          (processing_order_downstream_confirmed ?processing_order)
        )
        (not
          (qa_review_completed ?batch_production_record)
        )
      )
    :effect
      (and
        (qa_review_completed ?batch_production_record)
        (certificate_attached ?batch_production_record)
      )
  )
  (:action apply_qa_signature_alternate_path
    :parameters (?batch_production_record - batch_production_record ?qa_signatory - qa_signatory ?in_process_sample - in_process_sample ?processing_order - processing_order)
    :precondition
      (and
        (analysis_result_attached ?batch_production_record)
        (qa_signatory_attached_to_record ?batch_production_record ?qa_signatory)
        (record_contains_sample ?batch_production_record ?in_process_sample)
        (sample_attached_to_order ?in_process_sample ?processing_order)
        (not
          (processing_order_upstream_confirmed ?processing_order)
        )
        (processing_order_downstream_confirmed ?processing_order)
        (not
          (qa_review_completed ?batch_production_record)
        )
      )
    :effect
      (and
        (qa_review_completed ?batch_production_record)
        (certificate_attached ?batch_production_record)
      )
  )
  (:action apply_qa_signature_combined_path
    :parameters (?batch_production_record - batch_production_record ?qa_signatory - qa_signatory ?in_process_sample - in_process_sample ?processing_order - processing_order)
    :precondition
      (and
        (analysis_result_attached ?batch_production_record)
        (qa_signatory_attached_to_record ?batch_production_record ?qa_signatory)
        (record_contains_sample ?batch_production_record ?in_process_sample)
        (sample_attached_to_order ?in_process_sample ?processing_order)
        (processing_order_upstream_confirmed ?processing_order)
        (processing_order_downstream_confirmed ?processing_order)
        (not
          (qa_review_completed ?batch_production_record)
        )
      )
    :effect
      (and
        (qa_review_completed ?batch_production_record)
        (certificate_attached ?batch_production_record)
      )
  )
  (:action finalize_bpr_from_analysis
    :parameters (?batch_production_record - batch_production_record)
    :precondition
      (and
        (qa_review_completed ?batch_production_record)
        (not
          (certificate_attached ?batch_production_record)
        )
        (not
          (record_finalized ?batch_production_record)
        )
      )
    :effect
      (and
        (record_finalized ?batch_production_record)
        (entity_released ?batch_production_record)
      )
  )
  (:action attach_assay_kit_to_record
    :parameters (?batch_production_record - batch_production_record ?assay_kit - assay_kit)
    :precondition
      (and
        (qa_review_completed ?batch_production_record)
        (certificate_attached ?batch_production_record)
        (assay_kit_available ?assay_kit)
      )
    :effect
      (and
        (assay_attached_to_record ?batch_production_record ?assay_kit)
        (not
          (assay_kit_available ?assay_kit)
        )
      )
  )
  (:action verify_record_and_mark_for_release
    :parameters (?batch_production_record - batch_production_record ?upstream_unit - upstream_unit_operation ?downstream_unit - downstream_unit_operation ?operator_credential - operator ?assay_kit - assay_kit)
    :precondition
      (and
        (qa_review_completed ?batch_production_record)
        (certificate_attached ?batch_production_record)
        (assay_attached_to_record ?batch_production_record ?assay_kit)
        (record_linked_to_upstream_unit ?batch_production_record ?upstream_unit)
        (record_linked_to_downstream_unit ?batch_production_record ?downstream_unit)
        (upstream_unit_ready_for_transfer ?upstream_unit)
        (downstream_unit_ready_for_transfer ?downstream_unit)
        (operator_assigned_to_entity ?batch_production_record ?operator_credential)
        (not
          (final_checks_completed ?batch_production_record)
        )
      )
    :effect (final_checks_completed ?batch_production_record)
  )
  (:action finalize_and_release_bpr
    :parameters (?batch_production_record - batch_production_record)
    :precondition
      (and
        (qa_review_completed ?batch_production_record)
        (final_checks_completed ?batch_production_record)
        (not
          (record_finalized ?batch_production_record)
        )
      )
    :effect
      (and
        (record_finalized ?batch_production_record)
        (entity_released ?batch_production_record)
      )
  )
  (:action attach_deviation_report_to_record
    :parameters (?batch_production_record - batch_production_record ?deviation_report - deviation_report ?operator_credential - operator)
    :precondition
      (and
        (entity_in_execution ?batch_production_record)
        (operator_assigned_to_entity ?batch_production_record ?operator_credential)
        (deviation_report_available ?deviation_report)
        (record_linked_to_deviation ?batch_production_record ?deviation_report)
        (not
          (deviation_attached ?batch_production_record)
        )
      )
    :effect
      (and
        (deviation_attached ?batch_production_record)
        (not
          (deviation_report_available ?deviation_report)
        )
      )
  )
  (:action initiate_deviation_review
    :parameters (?batch_production_record - batch_production_record ?qualified_specialist - qualified_specialist)
    :precondition
      (and
        (deviation_attached ?batch_production_record)
        (specialist_assigned_to_entity ?batch_production_record ?qualified_specialist)
        (not
          (deviation_review_initiated ?batch_production_record)
        )
      )
    :effect (deviation_review_initiated ?batch_production_record)
  )
  (:action apply_deviation_qa_signature
    :parameters (?batch_production_record - batch_production_record ?qa_signatory - qa_signatory)
    :precondition
      (and
        (deviation_review_initiated ?batch_production_record)
        (qa_signatory_attached_to_record ?batch_production_record ?qa_signatory)
        (not
          (deviation_review_completed ?batch_production_record)
        )
      )
    :effect (deviation_review_completed ?batch_production_record)
  )
  (:action finalize_deviation_and_release_record
    :parameters (?batch_production_record - batch_production_record)
    :precondition
      (and
        (deviation_review_completed ?batch_production_record)
        (not
          (record_finalized ?batch_production_record)
        )
      )
    :effect
      (and
        (record_finalized ?batch_production_record)
        (entity_released ?batch_production_record)
      )
  )
  (:action release_upstream_unit
    :parameters (?upstream_unit - upstream_unit_operation ?processing_order - processing_order)
    :precondition
      (and
        (upstream_unit_prepared ?upstream_unit)
        (upstream_unit_ready_for_transfer ?upstream_unit)
        (processing_order_active ?processing_order)
        (processing_order_transfer_completed ?processing_order)
        (not
          (entity_released ?upstream_unit)
        )
      )
    :effect (entity_released ?upstream_unit)
  )
  (:action release_downstream_unit
    :parameters (?downstream_unit - downstream_unit_operation ?processing_order - processing_order)
    :precondition
      (and
        (downstream_unit_prepared ?downstream_unit)
        (downstream_unit_ready_for_transfer ?downstream_unit)
        (processing_order_active ?processing_order)
        (processing_order_transfer_completed ?processing_order)
        (not
          (entity_released ?downstream_unit)
        )
      )
    :effect (entity_released ?downstream_unit)
  )
  (:action register_yield_loss_for_batch
    :parameters (?batch - batch ?yield_loss_response_document - yield_loss_response_document ?operator_credential - operator)
    :precondition
      (and
        (entity_released ?batch)
        (operator_assigned_to_entity ?batch ?operator_credential)
        (yield_loss_doc_available ?yield_loss_response_document)
        (not
          (yield_loss_document_attached_to_entity ?batch)
        )
      )
    :effect
      (and
        (yield_loss_document_attached_to_entity ?batch)
        (yield_loss_document_linked_to_entity ?batch ?yield_loss_response_document)
        (not
          (yield_loss_doc_available ?yield_loss_response_document)
        )
      )
  )
  (:action assign_mitigation_to_upstream_unit
    :parameters (?upstream_unit - upstream_unit_operation ?production_line - production_line ?yield_loss_response_document - yield_loss_response_document)
    :precondition
      (and
        (yield_loss_document_attached_to_entity ?upstream_unit)
        (allocated_to_production_line ?upstream_unit ?production_line)
        (yield_loss_document_linked_to_entity ?upstream_unit ?yield_loss_response_document)
        (not
          (mitigation_assigned_to_entity ?upstream_unit)
        )
      )
    :effect
      (and
        (mitigation_assigned_to_entity ?upstream_unit)
        (production_line_available ?production_line)
        (yield_loss_doc_available ?yield_loss_response_document)
      )
  )
  (:action assign_mitigation_to_downstream_unit
    :parameters (?downstream_unit - downstream_unit_operation ?production_line - production_line ?yield_loss_response_document - yield_loss_response_document)
    :precondition
      (and
        (yield_loss_document_attached_to_entity ?downstream_unit)
        (allocated_to_production_line ?downstream_unit ?production_line)
        (yield_loss_document_linked_to_entity ?downstream_unit ?yield_loss_response_document)
        (not
          (mitigation_assigned_to_entity ?downstream_unit)
        )
      )
    :effect
      (and
        (mitigation_assigned_to_entity ?downstream_unit)
        (production_line_available ?production_line)
        (yield_loss_doc_available ?yield_loss_response_document)
      )
  )
  (:action assign_mitigation_to_record
    :parameters (?batch_production_record - batch_production_record ?production_line - production_line ?yield_loss_response_document - yield_loss_response_document)
    :precondition
      (and
        (yield_loss_document_attached_to_entity ?batch_production_record)
        (allocated_to_production_line ?batch_production_record ?production_line)
        (yield_loss_document_linked_to_entity ?batch_production_record ?yield_loss_response_document)
        (not
          (mitigation_assigned_to_entity ?batch_production_record)
        )
      )
    :effect
      (and
        (mitigation_assigned_to_entity ?batch_production_record)
        (production_line_available ?production_line)
        (yield_loss_doc_available ?yield_loss_response_document)
      )
  )
)

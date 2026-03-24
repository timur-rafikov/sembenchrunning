(define (domain pharm_batch_release_readiness)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object production_resource - entity line_resource - entity document_resource - entity batch_category - entity batch - batch_category line_slot - production_resource process_step - production_resource operator - production_resource regulatory_document - production_resource signatory - production_resource release_form - production_resource calibration_certificate - production_resource environmental_record - production_resource material_lot - line_resource quality_sample - line_resource validation_record - line_resource equipment - document_resource packaging_line - document_resource batch_record - document_resource manufacturing_unit - batch packaging_unit - batch bulk_batch - manufacturing_unit packaging_batch - manufacturing_unit release_unit - packaging_unit)

  (:predicates
    (production_item_initiated ?batch - batch)
    (production_item_stage_completed ?batch - batch)
    (production_item_scheduled ?batch - batch)
    (production_item_released ?batch - batch)
    (qa_approved ?batch - batch)
    (release_form_attached ?batch - batch)
    (line_slot_available ?line_slot - line_slot)
    (production_item_assigned_to_line_slot ?batch - batch ?line_slot - line_slot)
    (process_step_available ?process_step - process_step)
    (production_item_assigned_to_process_step ?batch - batch ?process_step - process_step)
    (operator_available ?operator - operator)
    (production_item_assigned_operator ?batch - batch ?operator - operator)
    (material_lot_available ?material_lot - material_lot)
    (bulk_batch_has_material_lot ?bulk_batch - bulk_batch ?material_lot - material_lot)
    (packaging_batch_has_material_lot ?packaging_batch - packaging_batch ?material_lot - material_lot)
    (bulk_batch_assigned_equipment ?bulk_batch - bulk_batch ?equipment - equipment)
    (equipment_prepared ?equipment - equipment)
    (equipment_material_staged ?equipment - equipment)
    (bulk_batch_equipment_verified ?bulk_batch - bulk_batch)
    (packaging_batch_assigned_to_line ?packaging_batch - packaging_batch ?packaging_line - packaging_line)
    (packaging_line_prepared ?packaging_line - packaging_line)
    (packaging_line_material_staged ?packaging_line - packaging_line)
    (packaging_batch_line_verified ?packaging_batch - packaging_batch)
    (batch_record_unpopulated ?batch_record - batch_record)
    (batch_record_populated ?batch_record - batch_record)
    (batch_record_linked_equipment ?batch_record - batch_record ?equipment - equipment)
    (batch_record_linked_packaging_line ?batch_record - batch_record ?packaging_line - packaging_line)
    (batch_record_equipment_section_completed ?batch_record - batch_record)
    (batch_record_packaging_section_completed ?batch_record - batch_record)
    (batch_record_qc_section_completed ?batch_record - batch_record)
    (release_unit_includes_bulk_batch ?release_unit - release_unit ?bulk_batch - bulk_batch)
    (release_unit_includes_packaging_batch ?release_unit - release_unit ?packaging_batch - packaging_batch)
    (release_unit_has_batch_record ?release_unit - release_unit ?batch_record - batch_record)
    (quality_sample_available ?quality_sample - quality_sample)
    (release_unit_linked_quality_sample ?release_unit - release_unit ?quality_sample - quality_sample)
    (quality_sample_registered ?quality_sample - quality_sample)
    (quality_sample_linked_to_record ?quality_sample - quality_sample ?batch_record - batch_record)
    (release_unit_certificate_attached ?release_unit - release_unit)
    (release_unit_evidence_reviewed ?release_unit - release_unit)
    (release_unit_ready_for_final_review ?release_unit - release_unit)
    (regulatory_document_attached ?release_unit - release_unit)
    (regulatory_document_reviewed ?release_unit - release_unit)
    (release_unit_signoff_section_present ?release_unit - release_unit)
    (release_unit_final_checks_completed ?release_unit - release_unit)
    (validation_record_available ?validation_record - validation_record)
    (release_unit_linked_validation_record ?release_unit - release_unit ?validation_record - validation_record)
    (release_unit_validation_attached ?release_unit - release_unit)
    (release_unit_validation_verified ?release_unit - release_unit)
    (release_unit_environmental_review_completed ?release_unit - release_unit)
    (regulatory_document_available ?regulatory_document - regulatory_document)
    (release_unit_linked_regulatory_document ?release_unit - release_unit ?regulatory_document - regulatory_document)
    (signatory_available ?signatory - signatory)
    (release_unit_linked_signatory ?release_unit - release_unit ?signatory - signatory)
    (calibration_certificate_available ?calibration_certificate - calibration_certificate)
    (release_unit_linked_calibration_certificate ?release_unit - release_unit ?calibration_certificate - calibration_certificate)
    (environmental_record_available ?environmental_record - environmental_record)
    (release_unit_linked_environmental_record ?release_unit - release_unit ?environmental_record - environmental_record)
    (release_form_available ?release_form - release_form)
    (production_item_linked_release_form ?batch - batch ?release_form - release_form)
    (bulk_batch_resources_ready ?bulk_batch - bulk_batch)
    (packaging_batch_resources_ready ?packaging_batch - packaging_batch)
    (release_unit_finalized ?release_unit - release_unit)
  )
  (:action initialize_batch
    :parameters (?batch - batch)
    :precondition
      (and
        (not
          (production_item_initiated ?batch)
        )
        (not
          (production_item_released ?batch)
        )
      )
    :effect (production_item_initiated ?batch)
  )
  (:action schedule_batch_on_line_slot
    :parameters (?batch - batch ?line_slot - line_slot)
    :precondition
      (and
        (production_item_initiated ?batch)
        (not
          (production_item_scheduled ?batch)
        )
        (line_slot_available ?line_slot)
      )
    :effect
      (and
        (production_item_scheduled ?batch)
        (production_item_assigned_to_line_slot ?batch ?line_slot)
        (not
          (line_slot_available ?line_slot)
        )
      )
  )
  (:action assign_process_step_to_batch
    :parameters (?batch - batch ?process_step - process_step)
    :precondition
      (and
        (production_item_initiated ?batch)
        (production_item_scheduled ?batch)
        (process_step_available ?process_step)
      )
    :effect
      (and
        (production_item_assigned_to_process_step ?batch ?process_step)
        (not
          (process_step_available ?process_step)
        )
      )
  )
  (:action complete_batch_process_step
    :parameters (?batch - batch ?process_step - process_step)
    :precondition
      (and
        (production_item_initiated ?batch)
        (production_item_scheduled ?batch)
        (production_item_assigned_to_process_step ?batch ?process_step)
        (not
          (production_item_stage_completed ?batch)
        )
      )
    :effect (production_item_stage_completed ?batch)
  )
  (:action release_process_step_assignment
    :parameters (?batch - batch ?process_step - process_step)
    :precondition
      (and
        (production_item_assigned_to_process_step ?batch ?process_step)
      )
    :effect
      (and
        (process_step_available ?process_step)
        (not
          (production_item_assigned_to_process_step ?batch ?process_step)
        )
      )
  )
  (:action assign_operator_to_batch
    :parameters (?batch - batch ?operator - operator)
    :precondition
      (and
        (production_item_stage_completed ?batch)
        (operator_available ?operator)
      )
    :effect
      (and
        (production_item_assigned_operator ?batch ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action release_operator_from_batch
    :parameters (?batch - batch ?operator - operator)
    :precondition
      (and
        (production_item_assigned_operator ?batch ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (production_item_assigned_operator ?batch ?operator)
        )
      )
  )
  (:action attach_calibration_certificate_to_release_unit
    :parameters (?release_unit - release_unit ?calibration_certificate - calibration_certificate)
    :precondition
      (and
        (production_item_stage_completed ?release_unit)
        (calibration_certificate_available ?calibration_certificate)
      )
    :effect
      (and
        (release_unit_linked_calibration_certificate ?release_unit ?calibration_certificate)
        (not
          (calibration_certificate_available ?calibration_certificate)
        )
      )
  )
  (:action detach_calibration_certificate_from_release_unit
    :parameters (?release_unit - release_unit ?calibration_certificate - calibration_certificate)
    :precondition
      (and
        (release_unit_linked_calibration_certificate ?release_unit ?calibration_certificate)
      )
    :effect
      (and
        (calibration_certificate_available ?calibration_certificate)
        (not
          (release_unit_linked_calibration_certificate ?release_unit ?calibration_certificate)
        )
      )
  )
  (:action attach_environmental_record_to_release_unit
    :parameters (?release_unit - release_unit ?environmental_record - environmental_record)
    :precondition
      (and
        (production_item_stage_completed ?release_unit)
        (environmental_record_available ?environmental_record)
      )
    :effect
      (and
        (release_unit_linked_environmental_record ?release_unit ?environmental_record)
        (not
          (environmental_record_available ?environmental_record)
        )
      )
  )
  (:action detach_environmental_record_from_release_unit
    :parameters (?release_unit - release_unit ?environmental_record - environmental_record)
    :precondition
      (and
        (release_unit_linked_environmental_record ?release_unit ?environmental_record)
      )
    :effect
      (and
        (environmental_record_available ?environmental_record)
        (not
          (release_unit_linked_environmental_record ?release_unit ?environmental_record)
        )
      )
  )
  (:action prepare_equipment_for_bulk_batch
    :parameters (?bulk_batch - bulk_batch ?equipment - equipment ?process_step - process_step)
    :precondition
      (and
        (production_item_stage_completed ?bulk_batch)
        (production_item_assigned_to_process_step ?bulk_batch ?process_step)
        (bulk_batch_assigned_equipment ?bulk_batch ?equipment)
        (not
          (equipment_prepared ?equipment)
        )
        (not
          (equipment_material_staged ?equipment)
        )
      )
    :effect (equipment_prepared ?equipment)
  )
  (:action confirm_equipment_and_operator_ready_for_bulk_batch
    :parameters (?bulk_batch - bulk_batch ?equipment - equipment ?operator - operator)
    :precondition
      (and
        (production_item_stage_completed ?bulk_batch)
        (production_item_assigned_operator ?bulk_batch ?operator)
        (bulk_batch_assigned_equipment ?bulk_batch ?equipment)
        (equipment_prepared ?equipment)
        (not
          (bulk_batch_resources_ready ?bulk_batch)
        )
      )
    :effect
      (and
        (bulk_batch_resources_ready ?bulk_batch)
        (bulk_batch_equipment_verified ?bulk_batch)
      )
  )
  (:action stage_material_on_equipment_for_bulk_batch
    :parameters (?bulk_batch - bulk_batch ?equipment - equipment ?material_lot - material_lot)
    :precondition
      (and
        (production_item_stage_completed ?bulk_batch)
        (bulk_batch_assigned_equipment ?bulk_batch ?equipment)
        (material_lot_available ?material_lot)
        (not
          (bulk_batch_resources_ready ?bulk_batch)
        )
      )
    :effect
      (and
        (equipment_material_staged ?equipment)
        (bulk_batch_resources_ready ?bulk_batch)
        (bulk_batch_has_material_lot ?bulk_batch ?material_lot)
        (not
          (material_lot_available ?material_lot)
        )
      )
  )
  (:action execute_material_staging_and_verify_equipment_for_bulk_batch
    :parameters (?bulk_batch - bulk_batch ?equipment - equipment ?process_step - process_step ?material_lot - material_lot)
    :precondition
      (and
        (production_item_stage_completed ?bulk_batch)
        (production_item_assigned_to_process_step ?bulk_batch ?process_step)
        (bulk_batch_assigned_equipment ?bulk_batch ?equipment)
        (equipment_material_staged ?equipment)
        (bulk_batch_has_material_lot ?bulk_batch ?material_lot)
        (not
          (bulk_batch_equipment_verified ?bulk_batch)
        )
      )
    :effect
      (and
        (equipment_prepared ?equipment)
        (bulk_batch_equipment_verified ?bulk_batch)
        (material_lot_available ?material_lot)
        (not
          (bulk_batch_has_material_lot ?bulk_batch ?material_lot)
        )
      )
  )
  (:action prepare_packaging_line_for_packaging_batch
    :parameters (?packaging_batch - packaging_batch ?packaging_line - packaging_line ?process_step - process_step)
    :precondition
      (and
        (production_item_stage_completed ?packaging_batch)
        (production_item_assigned_to_process_step ?packaging_batch ?process_step)
        (packaging_batch_assigned_to_line ?packaging_batch ?packaging_line)
        (not
          (packaging_line_prepared ?packaging_line)
        )
        (not
          (packaging_line_material_staged ?packaging_line)
        )
      )
    :effect (packaging_line_prepared ?packaging_line)
  )
  (:action confirm_packaging_line_and_operator_ready_for_packaging_batch
    :parameters (?packaging_batch - packaging_batch ?packaging_line - packaging_line ?operator - operator)
    :precondition
      (and
        (production_item_stage_completed ?packaging_batch)
        (production_item_assigned_operator ?packaging_batch ?operator)
        (packaging_batch_assigned_to_line ?packaging_batch ?packaging_line)
        (packaging_line_prepared ?packaging_line)
        (not
          (packaging_batch_resources_ready ?packaging_batch)
        )
      )
    :effect
      (and
        (packaging_batch_resources_ready ?packaging_batch)
        (packaging_batch_line_verified ?packaging_batch)
      )
  )
  (:action stage_material_on_packaging_line_for_packaging_batch
    :parameters (?packaging_batch - packaging_batch ?packaging_line - packaging_line ?material_lot - material_lot)
    :precondition
      (and
        (production_item_stage_completed ?packaging_batch)
        (packaging_batch_assigned_to_line ?packaging_batch ?packaging_line)
        (material_lot_available ?material_lot)
        (not
          (packaging_batch_resources_ready ?packaging_batch)
        )
      )
    :effect
      (and
        (packaging_line_material_staged ?packaging_line)
        (packaging_batch_resources_ready ?packaging_batch)
        (packaging_batch_has_material_lot ?packaging_batch ?material_lot)
        (not
          (material_lot_available ?material_lot)
        )
      )
  )
  (:action execute_material_staging_and_verify_packaging_line
    :parameters (?packaging_batch - packaging_batch ?packaging_line - packaging_line ?process_step - process_step ?material_lot - material_lot)
    :precondition
      (and
        (production_item_stage_completed ?packaging_batch)
        (production_item_assigned_to_process_step ?packaging_batch ?process_step)
        (packaging_batch_assigned_to_line ?packaging_batch ?packaging_line)
        (packaging_line_material_staged ?packaging_line)
        (packaging_batch_has_material_lot ?packaging_batch ?material_lot)
        (not
          (packaging_batch_line_verified ?packaging_batch)
        )
      )
    :effect
      (and
        (packaging_line_prepared ?packaging_line)
        (packaging_batch_line_verified ?packaging_batch)
        (material_lot_available ?material_lot)
        (not
          (packaging_batch_has_material_lot ?packaging_batch ?material_lot)
        )
      )
  )
  (:action assemble_batch_record_from_line_and_equipment_assignments
    :parameters (?bulk_batch - bulk_batch ?packaging_batch - packaging_batch ?equipment - equipment ?packaging_line - packaging_line ?batch_record - batch_record)
    :precondition
      (and
        (bulk_batch_resources_ready ?bulk_batch)
        (packaging_batch_resources_ready ?packaging_batch)
        (bulk_batch_assigned_equipment ?bulk_batch ?equipment)
        (packaging_batch_assigned_to_line ?packaging_batch ?packaging_line)
        (equipment_prepared ?equipment)
        (packaging_line_prepared ?packaging_line)
        (bulk_batch_equipment_verified ?bulk_batch)
        (packaging_batch_line_verified ?packaging_batch)
        (batch_record_unpopulated ?batch_record)
      )
    :effect
      (and
        (batch_record_populated ?batch_record)
        (batch_record_linked_equipment ?batch_record ?equipment)
        (batch_record_linked_packaging_line ?batch_record ?packaging_line)
        (not
          (batch_record_unpopulated ?batch_record)
        )
      )
  )
  (:action assemble_batch_record_with_equipment_material_staged
    :parameters (?bulk_batch - bulk_batch ?packaging_batch - packaging_batch ?equipment - equipment ?packaging_line - packaging_line ?batch_record - batch_record)
    :precondition
      (and
        (bulk_batch_resources_ready ?bulk_batch)
        (packaging_batch_resources_ready ?packaging_batch)
        (bulk_batch_assigned_equipment ?bulk_batch ?equipment)
        (packaging_batch_assigned_to_line ?packaging_batch ?packaging_line)
        (equipment_material_staged ?equipment)
        (packaging_line_prepared ?packaging_line)
        (not
          (bulk_batch_equipment_verified ?bulk_batch)
        )
        (packaging_batch_line_verified ?packaging_batch)
        (batch_record_unpopulated ?batch_record)
      )
    :effect
      (and
        (batch_record_populated ?batch_record)
        (batch_record_linked_equipment ?batch_record ?equipment)
        (batch_record_linked_packaging_line ?batch_record ?packaging_line)
        (batch_record_equipment_section_completed ?batch_record)
        (not
          (batch_record_unpopulated ?batch_record)
        )
      )
  )
  (:action assemble_batch_record_with_packaging_material_staged
    :parameters (?bulk_batch - bulk_batch ?packaging_batch - packaging_batch ?equipment - equipment ?packaging_line - packaging_line ?batch_record - batch_record)
    :precondition
      (and
        (bulk_batch_resources_ready ?bulk_batch)
        (packaging_batch_resources_ready ?packaging_batch)
        (bulk_batch_assigned_equipment ?bulk_batch ?equipment)
        (packaging_batch_assigned_to_line ?packaging_batch ?packaging_line)
        (equipment_prepared ?equipment)
        (packaging_line_material_staged ?packaging_line)
        (bulk_batch_equipment_verified ?bulk_batch)
        (not
          (packaging_batch_line_verified ?packaging_batch)
        )
        (batch_record_unpopulated ?batch_record)
      )
    :effect
      (and
        (batch_record_populated ?batch_record)
        (batch_record_linked_equipment ?batch_record ?equipment)
        (batch_record_linked_packaging_line ?batch_record ?packaging_line)
        (batch_record_packaging_section_completed ?batch_record)
        (not
          (batch_record_unpopulated ?batch_record)
        )
      )
  )
  (:action assemble_batch_record_with_both_materials_staged
    :parameters (?bulk_batch - bulk_batch ?packaging_batch - packaging_batch ?equipment - equipment ?packaging_line - packaging_line ?batch_record - batch_record)
    :precondition
      (and
        (bulk_batch_resources_ready ?bulk_batch)
        (packaging_batch_resources_ready ?packaging_batch)
        (bulk_batch_assigned_equipment ?bulk_batch ?equipment)
        (packaging_batch_assigned_to_line ?packaging_batch ?packaging_line)
        (equipment_material_staged ?equipment)
        (packaging_line_material_staged ?packaging_line)
        (not
          (bulk_batch_equipment_verified ?bulk_batch)
        )
        (not
          (packaging_batch_line_verified ?packaging_batch)
        )
        (batch_record_unpopulated ?batch_record)
      )
    :effect
      (and
        (batch_record_populated ?batch_record)
        (batch_record_linked_equipment ?batch_record ?equipment)
        (batch_record_linked_packaging_line ?batch_record ?packaging_line)
        (batch_record_equipment_section_completed ?batch_record)
        (batch_record_packaging_section_completed ?batch_record)
        (not
          (batch_record_unpopulated ?batch_record)
        )
      )
  )
  (:action finalize_batch_record_qc_section
    :parameters (?batch_record - batch_record ?bulk_batch - bulk_batch ?process_step - process_step)
    :precondition
      (and
        (batch_record_populated ?batch_record)
        (bulk_batch_resources_ready ?bulk_batch)
        (production_item_assigned_to_process_step ?bulk_batch ?process_step)
        (not
          (batch_record_qc_section_completed ?batch_record)
        )
      )
    :effect (batch_record_qc_section_completed ?batch_record)
  )
  (:action attach_quality_sample_to_release_unit_and_record
    :parameters (?release_unit - release_unit ?quality_sample - quality_sample ?batch_record - batch_record)
    :precondition
      (and
        (production_item_stage_completed ?release_unit)
        (release_unit_has_batch_record ?release_unit ?batch_record)
        (release_unit_linked_quality_sample ?release_unit ?quality_sample)
        (quality_sample_available ?quality_sample)
        (batch_record_populated ?batch_record)
        (batch_record_qc_section_completed ?batch_record)
        (not
          (quality_sample_registered ?quality_sample)
        )
      )
    :effect
      (and
        (quality_sample_registered ?quality_sample)
        (quality_sample_linked_to_record ?quality_sample ?batch_record)
        (not
          (quality_sample_available ?quality_sample)
        )
      )
  )
  (:action process_quality_sample_and_mark_release_unit
    :parameters (?release_unit - release_unit ?quality_sample - quality_sample ?batch_record - batch_record ?process_step - process_step)
    :precondition
      (and
        (production_item_stage_completed ?release_unit)
        (release_unit_linked_quality_sample ?release_unit ?quality_sample)
        (quality_sample_registered ?quality_sample)
        (quality_sample_linked_to_record ?quality_sample ?batch_record)
        (production_item_assigned_to_process_step ?release_unit ?process_step)
        (not
          (batch_record_equipment_section_completed ?batch_record)
        )
        (not
          (release_unit_certificate_attached ?release_unit)
        )
      )
    :effect (release_unit_certificate_attached ?release_unit)
  )
  (:action attach_regulatory_document_to_release_unit
    :parameters (?release_unit - release_unit ?regulatory_document - regulatory_document)
    :precondition
      (and
        (production_item_stage_completed ?release_unit)
        (regulatory_document_available ?regulatory_document)
        (not
          (regulatory_document_attached ?release_unit)
        )
      )
    :effect
      (and
        (regulatory_document_attached ?release_unit)
        (release_unit_linked_regulatory_document ?release_unit ?regulatory_document)
        (not
          (regulatory_document_available ?regulatory_document)
        )
      )
  )
  (:action review_regulatory_document_and_update_release_unit
    :parameters (?release_unit - release_unit ?quality_sample - quality_sample ?batch_record - batch_record ?process_step - process_step ?regulatory_document - regulatory_document)
    :precondition
      (and
        (production_item_stage_completed ?release_unit)
        (release_unit_linked_quality_sample ?release_unit ?quality_sample)
        (quality_sample_registered ?quality_sample)
        (quality_sample_linked_to_record ?quality_sample ?batch_record)
        (production_item_assigned_to_process_step ?release_unit ?process_step)
        (batch_record_equipment_section_completed ?batch_record)
        (regulatory_document_attached ?release_unit)
        (release_unit_linked_regulatory_document ?release_unit ?regulatory_document)
        (not
          (release_unit_certificate_attached ?release_unit)
        )
      )
    :effect
      (and
        (release_unit_certificate_attached ?release_unit)
        (regulatory_document_reviewed ?release_unit)
      )
  )
  (:action conduct_calibration_certificate_review_for_release_unit
    :parameters (?release_unit - release_unit ?calibration_certificate - calibration_certificate ?operator - operator ?quality_sample - quality_sample ?batch_record - batch_record)
    :precondition
      (and
        (release_unit_certificate_attached ?release_unit)
        (release_unit_linked_calibration_certificate ?release_unit ?calibration_certificate)
        (production_item_assigned_operator ?release_unit ?operator)
        (release_unit_linked_quality_sample ?release_unit ?quality_sample)
        (quality_sample_linked_to_record ?quality_sample ?batch_record)
        (not
          (batch_record_packaging_section_completed ?batch_record)
        )
        (not
          (release_unit_evidence_reviewed ?release_unit)
        )
      )
    :effect (release_unit_evidence_reviewed ?release_unit)
  )
  (:action confirm_calibration_certificate_review_for_release_unit
    :parameters (?release_unit - release_unit ?calibration_certificate - calibration_certificate ?operator - operator ?quality_sample - quality_sample ?batch_record - batch_record)
    :precondition
      (and
        (release_unit_certificate_attached ?release_unit)
        (release_unit_linked_calibration_certificate ?release_unit ?calibration_certificate)
        (production_item_assigned_operator ?release_unit ?operator)
        (release_unit_linked_quality_sample ?release_unit ?quality_sample)
        (quality_sample_linked_to_record ?quality_sample ?batch_record)
        (batch_record_packaging_section_completed ?batch_record)
        (not
          (release_unit_evidence_reviewed ?release_unit)
        )
      )
    :effect (release_unit_evidence_reviewed ?release_unit)
  )
  (:action link_environmental_record_and_prepare_release_unit_for_review
    :parameters (?release_unit - release_unit ?environmental_record - environmental_record ?quality_sample - quality_sample ?batch_record - batch_record)
    :precondition
      (and
        (release_unit_evidence_reviewed ?release_unit)
        (release_unit_linked_environmental_record ?release_unit ?environmental_record)
        (release_unit_linked_quality_sample ?release_unit ?quality_sample)
        (quality_sample_linked_to_record ?quality_sample ?batch_record)
        (not
          (batch_record_equipment_section_completed ?batch_record)
        )
        (not
          (batch_record_packaging_section_completed ?batch_record)
        )
        (not
          (release_unit_ready_for_final_review ?release_unit)
        )
      )
    :effect (release_unit_ready_for_final_review ?release_unit)
  )
  (:action link_environmental_record_and_prepare_signoff
    :parameters (?release_unit - release_unit ?environmental_record - environmental_record ?quality_sample - quality_sample ?batch_record - batch_record)
    :precondition
      (and
        (release_unit_evidence_reviewed ?release_unit)
        (release_unit_linked_environmental_record ?release_unit ?environmental_record)
        (release_unit_linked_quality_sample ?release_unit ?quality_sample)
        (quality_sample_linked_to_record ?quality_sample ?batch_record)
        (batch_record_equipment_section_completed ?batch_record)
        (not
          (batch_record_packaging_section_completed ?batch_record)
        )
        (not
          (release_unit_ready_for_final_review ?release_unit)
        )
      )
    :effect
      (and
        (release_unit_ready_for_final_review ?release_unit)
        (release_unit_signoff_section_present ?release_unit)
      )
  )
  (:action finalize_environmental_review_variant
    :parameters (?release_unit - release_unit ?environmental_record - environmental_record ?quality_sample - quality_sample ?batch_record - batch_record)
    :precondition
      (and
        (release_unit_evidence_reviewed ?release_unit)
        (release_unit_linked_environmental_record ?release_unit ?environmental_record)
        (release_unit_linked_quality_sample ?release_unit ?quality_sample)
        (quality_sample_linked_to_record ?quality_sample ?batch_record)
        (not
          (batch_record_equipment_section_completed ?batch_record)
        )
        (batch_record_packaging_section_completed ?batch_record)
        (not
          (release_unit_ready_for_final_review ?release_unit)
        )
      )
    :effect
      (and
        (release_unit_ready_for_final_review ?release_unit)
        (release_unit_signoff_section_present ?release_unit)
      )
  )
  (:action finalize_environmental_review_combined
    :parameters (?release_unit - release_unit ?environmental_record - environmental_record ?quality_sample - quality_sample ?batch_record - batch_record)
    :precondition
      (and
        (release_unit_evidence_reviewed ?release_unit)
        (release_unit_linked_environmental_record ?release_unit ?environmental_record)
        (release_unit_linked_quality_sample ?release_unit ?quality_sample)
        (quality_sample_linked_to_record ?quality_sample ?batch_record)
        (batch_record_equipment_section_completed ?batch_record)
        (batch_record_packaging_section_completed ?batch_record)
        (not
          (release_unit_ready_for_final_review ?release_unit)
        )
      )
    :effect
      (and
        (release_unit_ready_for_final_review ?release_unit)
        (release_unit_signoff_section_present ?release_unit)
      )
  )
  (:action finalize_release_unit_as_qa_approved
    :parameters (?release_unit - release_unit)
    :precondition
      (and
        (release_unit_ready_for_final_review ?release_unit)
        (not
          (release_unit_signoff_section_present ?release_unit)
        )
        (not
          (release_unit_finalized ?release_unit)
        )
      )
    :effect
      (and
        (release_unit_finalized ?release_unit)
        (qa_approved ?release_unit)
      )
  )
  (:action attach_signatory_to_release_unit
    :parameters (?release_unit - release_unit ?signatory - signatory)
    :precondition
      (and
        (release_unit_ready_for_final_review ?release_unit)
        (release_unit_signoff_section_present ?release_unit)
        (signatory_available ?signatory)
      )
    :effect
      (and
        (release_unit_linked_signatory ?release_unit ?signatory)
        (not
          (signatory_available ?signatory)
        )
      )
  )
  (:action complete_release_unit_signature_and_finalize_checks
    :parameters (?release_unit - release_unit ?bulk_batch - bulk_batch ?packaging_batch - packaging_batch ?process_step - process_step ?signatory - signatory)
    :precondition
      (and
        (release_unit_ready_for_final_review ?release_unit)
        (release_unit_signoff_section_present ?release_unit)
        (release_unit_linked_signatory ?release_unit ?signatory)
        (release_unit_includes_bulk_batch ?release_unit ?bulk_batch)
        (release_unit_includes_packaging_batch ?release_unit ?packaging_batch)
        (bulk_batch_equipment_verified ?bulk_batch)
        (packaging_batch_line_verified ?packaging_batch)
        (production_item_assigned_to_process_step ?release_unit ?process_step)
        (not
          (release_unit_final_checks_completed ?release_unit)
        )
      )
    :effect (release_unit_final_checks_completed ?release_unit)
  )
  (:action finalize_release_unit_with_checks
    :parameters (?release_unit - release_unit)
    :precondition
      (and
        (release_unit_ready_for_final_review ?release_unit)
        (release_unit_final_checks_completed ?release_unit)
        (not
          (release_unit_finalized ?release_unit)
        )
      )
    :effect
      (and
        (release_unit_finalized ?release_unit)
        (qa_approved ?release_unit)
      )
  )
  (:action attach_validation_record_to_release_unit
    :parameters (?release_unit - release_unit ?validation_record - validation_record ?process_step - process_step)
    :precondition
      (and
        (production_item_stage_completed ?release_unit)
        (production_item_assigned_to_process_step ?release_unit ?process_step)
        (validation_record_available ?validation_record)
        (release_unit_linked_validation_record ?release_unit ?validation_record)
        (not
          (release_unit_validation_attached ?release_unit)
        )
      )
    :effect
      (and
        (release_unit_validation_attached ?release_unit)
        (not
          (validation_record_available ?validation_record)
        )
      )
  )
  (:action perform_validation_operational_review
    :parameters (?release_unit - release_unit ?operator - operator)
    :precondition
      (and
        (release_unit_validation_attached ?release_unit)
        (production_item_assigned_operator ?release_unit ?operator)
        (not
          (release_unit_validation_verified ?release_unit)
        )
      )
    :effect (release_unit_validation_verified ?release_unit)
  )
  (:action verify_environmental_record_for_release_unit
    :parameters (?release_unit - release_unit ?environmental_record - environmental_record)
    :precondition
      (and
        (release_unit_validation_verified ?release_unit)
        (release_unit_linked_environmental_record ?release_unit ?environmental_record)
        (not
          (release_unit_environmental_review_completed ?release_unit)
        )
      )
    :effect (release_unit_environmental_review_completed ?release_unit)
  )
  (:action finalize_release_unit_after_environmental_review
    :parameters (?release_unit - release_unit)
    :precondition
      (and
        (release_unit_environmental_review_completed ?release_unit)
        (not
          (release_unit_finalized ?release_unit)
        )
      )
    :effect
      (and
        (release_unit_finalized ?release_unit)
        (qa_approved ?release_unit)
      )
  )
  (:action mark_bulk_batch_qa_approved
    :parameters (?bulk_batch - bulk_batch ?batch_record - batch_record)
    :precondition
      (and
        (bulk_batch_resources_ready ?bulk_batch)
        (bulk_batch_equipment_verified ?bulk_batch)
        (batch_record_populated ?batch_record)
        (batch_record_qc_section_completed ?batch_record)
        (not
          (qa_approved ?bulk_batch)
        )
      )
    :effect (qa_approved ?bulk_batch)
  )
  (:action mark_packaging_batch_qa_approved
    :parameters (?packaging_batch - packaging_batch ?batch_record - batch_record)
    :precondition
      (and
        (packaging_batch_resources_ready ?packaging_batch)
        (packaging_batch_line_verified ?packaging_batch)
        (batch_record_populated ?batch_record)
        (batch_record_qc_section_completed ?batch_record)
        (not
          (qa_approved ?packaging_batch)
        )
      )
    :effect (qa_approved ?packaging_batch)
  )
  (:action attach_release_form_to_batch
    :parameters (?batch - batch ?release_form - release_form ?process_step - process_step)
    :precondition
      (and
        (qa_approved ?batch)
        (production_item_assigned_to_process_step ?batch ?process_step)
        (release_form_available ?release_form)
        (not
          (release_form_attached ?batch)
        )
      )
    :effect
      (and
        (release_form_attached ?batch)
        (production_item_linked_release_form ?batch ?release_form)
        (not
          (release_form_available ?release_form)
        )
      )
  )
  (:action complete_bulk_batch_release_and_free_resources
    :parameters (?bulk_batch - bulk_batch ?line_slot - line_slot ?release_form - release_form)
    :precondition
      (and
        (release_form_attached ?bulk_batch)
        (production_item_assigned_to_line_slot ?bulk_batch ?line_slot)
        (production_item_linked_release_form ?bulk_batch ?release_form)
        (not
          (production_item_released ?bulk_batch)
        )
      )
    :effect
      (and
        (production_item_released ?bulk_batch)
        (line_slot_available ?line_slot)
        (release_form_available ?release_form)
      )
  )
  (:action complete_packaging_batch_release_and_free_resources
    :parameters (?packaging_batch - packaging_batch ?line_slot - line_slot ?release_form - release_form)
    :precondition
      (and
        (release_form_attached ?packaging_batch)
        (production_item_assigned_to_line_slot ?packaging_batch ?line_slot)
        (production_item_linked_release_form ?packaging_batch ?release_form)
        (not
          (production_item_released ?packaging_batch)
        )
      )
    :effect
      (and
        (production_item_released ?packaging_batch)
        (line_slot_available ?line_slot)
        (release_form_available ?release_form)
      )
  )
  (:action complete_release_unit_release_and_free_resources
    :parameters (?release_unit - release_unit ?line_slot - line_slot ?release_form - release_form)
    :precondition
      (and
        (release_form_attached ?release_unit)
        (production_item_assigned_to_line_slot ?release_unit ?line_slot)
        (production_item_linked_release_form ?release_unit ?release_form)
        (not
          (production_item_released ?release_unit)
        )
      )
    :effect
      (and
        (production_item_released ?release_unit)
        (line_slot_available ?line_slot)
        (release_form_available ?release_form)
      )
  )
)

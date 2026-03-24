(define (domain commercial_invoice_data_validation)
  (:requirements :strips :typing :negative-preconditions)
  (:types personnel_resource_group - object technical_resource_group - object document_type_group - object case_root - object commercial_invoice_validation_case - case_root broker - personnel_resource_group automated_classifier_service - personnel_resource_group compliance_reviewer - personnel_resource_group regulation_reference - personnel_resource_group submission_channel - personnel_resource_group permit - personnel_resource_group license_record - personnel_resource_group risk_rule - personnel_resource_group supporting_document - technical_resource_group regulatory_certificate - technical_resource_group trade_agreement_reference - technical_resource_group line_item - document_type_group tariff_decision_record - document_type_group submission_package - document_type_group shipment_case_group - commercial_invoice_validation_case filing_group - commercial_invoice_validation_case export_shipment_case - shipment_case_group import_shipment_case - shipment_case_group customs_entry_draft - filing_group)
  (:predicates
    (case_open ?validation_case - commercial_invoice_validation_case)
    (case_has_entry_draft ?validation_case - commercial_invoice_validation_case)
    (case_broker_assigned_flag ?validation_case - commercial_invoice_validation_case)
    (case_finalized ?validation_case - commercial_invoice_validation_case)
    (case_submission_ready ?validation_case - commercial_invoice_validation_case)
    (case_has_permit ?validation_case - commercial_invoice_validation_case)
    (broker_available ?broker - broker)
    (case_assigned_broker ?validation_case - commercial_invoice_validation_case ?broker - broker)
    (classifier_available ?classifier_service - automated_classifier_service)
    (case_classified_by ?validation_case - commercial_invoice_validation_case ?classifier_service - automated_classifier_service)
    (reviewer_available ?compliance_reviewer - compliance_reviewer)
    (case_assigned_reviewer ?validation_case - commercial_invoice_validation_case ?compliance_reviewer - compliance_reviewer)
    (supporting_document_available ?supporting_document - supporting_document)
    (export_case_has_supporting_document ?export_case - export_shipment_case ?supporting_document - supporting_document)
    (import_case_has_supporting_document ?import_case - import_shipment_case ?supporting_document - supporting_document)
    (export_case_has_line_item ?export_case - export_shipment_case ?line_item - line_item)
    (line_item_validated ?line_item - line_item)
    (line_item_document_attached ?line_item - line_item)
    (export_case_line_ready ?export_case - export_shipment_case)
    (import_case_has_tariff_decision ?import_case - import_shipment_case ?tariff_decision - tariff_decision_record)
    (tariff_decision_validated ?tariff_decision - tariff_decision_record)
    (tariff_decision_document_attached ?tariff_decision - tariff_decision_record)
    (import_case_line_ready ?import_case - import_shipment_case)
    (submission_package_available ?submission_package - submission_package)
    (submission_package_selected ?submission_package - submission_package)
    (submission_package_contains_line_item ?submission_package - submission_package ?line_item - line_item)
    (submission_package_contains_tariff_decision ?submission_package - submission_package ?tariff_decision - tariff_decision_record)
    (submission_package_pending_documents ?submission_package - submission_package)
    (submission_package_pending_tariff_checks ?submission_package - submission_package)
    (submission_package_locked ?submission_package - submission_package)
    (entry_draft_for_export_case ?entry_draft - customs_entry_draft ?export_case - export_shipment_case)
    (entry_draft_for_import_case ?entry_draft - customs_entry_draft ?import_case - import_shipment_case)
    (entry_draft_linked_submission_package ?entry_draft - customs_entry_draft ?submission_package - submission_package)
    (regulatory_certificate_available ?regulatory_certificate - regulatory_certificate)
    (entry_draft_has_certificate ?entry_draft - customs_entry_draft ?regulatory_certificate - regulatory_certificate)
    (regulatory_certificate_consumed ?regulatory_certificate - regulatory_certificate)
    (regulatory_certificate_attached_to_submission ?regulatory_certificate - regulatory_certificate ?submission_package - submission_package)
    (entry_draft_validated ?entry_draft - customs_entry_draft)
    (entry_draft_license_applied ?entry_draft - customs_entry_draft)
    (entry_draft_risk_assessed ?entry_draft - customs_entry_draft)
    (entry_draft_regulation_reference_applied ?entry_draft - customs_entry_draft)
    (entry_draft_regulation_confirmed ?entry_draft - customs_entry_draft)
    (entry_draft_trade_agreement_applied ?entry_draft - customs_entry_draft)
    (entry_draft_authorized ?entry_draft - customs_entry_draft)
    (trade_agreement_reference_available ?trade_agreement_reference - trade_agreement_reference)
    (entry_draft_has_trade_agreement_reference ?entry_draft - customs_entry_draft ?trade_agreement_reference - trade_agreement_reference)
    (entry_draft_trade_agreement_confirmed ?entry_draft - customs_entry_draft)
    (entry_draft_reviewer_assigned ?entry_draft - customs_entry_draft)
    (entry_draft_risk_rule_applied ?entry_draft - customs_entry_draft)
    (regulation_reference_available ?regulation_reference - regulation_reference)
    (entry_draft_has_regulation_reference ?entry_draft - customs_entry_draft ?regulation_reference - regulation_reference)
    (submission_channel_available ?submission_channel - submission_channel)
    (entry_draft_has_submission_channel ?entry_draft - customs_entry_draft ?submission_channel - submission_channel)
    (license_record_available ?license_record - license_record)
    (entry_draft_has_license_record ?entry_draft - customs_entry_draft ?license_record - license_record)
    (risk_rule_available ?risk_rule - risk_rule)
    (entry_draft_has_risk_rule ?entry_draft - customs_entry_draft ?risk_rule - risk_rule)
    (permit_available ?permit - permit)
    (case_attached_permit ?validation_case - commercial_invoice_validation_case ?permit - permit)
    (export_case_lines_processed_flag ?export_case - export_shipment_case)
    (import_case_lines_processed_flag ?import_case - import_shipment_case)
    (entry_draft_locked ?entry_draft - customs_entry_draft)
  )
  (:action create_validation_case
    :parameters (?validation_case - commercial_invoice_validation_case)
    :precondition
      (and
        (not
          (case_open ?validation_case)
        )
        (not
          (case_finalized ?validation_case)
        )
      )
    :effect (case_open ?validation_case)
  )
  (:action assign_broker_to_case
    :parameters (?validation_case - commercial_invoice_validation_case ?broker - broker)
    :precondition
      (and
        (case_open ?validation_case)
        (not
          (case_broker_assigned_flag ?validation_case)
        )
        (broker_available ?broker)
      )
    :effect
      (and
        (case_broker_assigned_flag ?validation_case)
        (case_assigned_broker ?validation_case ?broker)
        (not
          (broker_available ?broker)
        )
      )
  )
  (:action classify_case_with_service
    :parameters (?validation_case - commercial_invoice_validation_case ?classifier_service - automated_classifier_service)
    :precondition
      (and
        (case_open ?validation_case)
        (case_broker_assigned_flag ?validation_case)
        (classifier_available ?classifier_service)
      )
    :effect
      (and
        (case_classified_by ?validation_case ?classifier_service)
        (not
          (classifier_available ?classifier_service)
        )
      )
  )
  (:action apply_classification_to_case
    :parameters (?validation_case - commercial_invoice_validation_case ?classifier_service - automated_classifier_service)
    :precondition
      (and
        (case_open ?validation_case)
        (case_broker_assigned_flag ?validation_case)
        (case_classified_by ?validation_case ?classifier_service)
        (not
          (case_has_entry_draft ?validation_case)
        )
      )
    :effect (case_has_entry_draft ?validation_case)
  )
  (:action release_classifier_from_case
    :parameters (?validation_case - commercial_invoice_validation_case ?classifier_service - automated_classifier_service)
    :precondition
      (and
        (case_classified_by ?validation_case ?classifier_service)
      )
    :effect
      (and
        (classifier_available ?classifier_service)
        (not
          (case_classified_by ?validation_case ?classifier_service)
        )
      )
  )
  (:action assign_reviewer_to_case
    :parameters (?validation_case - commercial_invoice_validation_case ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (case_has_entry_draft ?validation_case)
        (reviewer_available ?compliance_reviewer)
      )
    :effect
      (and
        (case_assigned_reviewer ?validation_case ?compliance_reviewer)
        (not
          (reviewer_available ?compliance_reviewer)
        )
      )
  )
  (:action unassign_reviewer_from_case
    :parameters (?validation_case - commercial_invoice_validation_case ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (case_assigned_reviewer ?validation_case ?compliance_reviewer)
      )
    :effect
      (and
        (reviewer_available ?compliance_reviewer)
        (not
          (case_assigned_reviewer ?validation_case ?compliance_reviewer)
        )
      )
  )
  (:action attach_license_record_to_entry_draft
    :parameters (?entry_draft - customs_entry_draft ?license_record - license_record)
    :precondition
      (and
        (case_has_entry_draft ?entry_draft)
        (license_record_available ?license_record)
      )
    :effect
      (and
        (entry_draft_has_license_record ?entry_draft ?license_record)
        (not
          (license_record_available ?license_record)
        )
      )
  )
  (:action release_license_record
    :parameters (?entry_draft - customs_entry_draft ?license_record - license_record)
    :precondition
      (and
        (entry_draft_has_license_record ?entry_draft ?license_record)
      )
    :effect
      (and
        (license_record_available ?license_record)
        (not
          (entry_draft_has_license_record ?entry_draft ?license_record)
        )
      )
  )
  (:action attach_risk_rule_to_entry_draft
    :parameters (?entry_draft - customs_entry_draft ?risk_rule - risk_rule)
    :precondition
      (and
        (case_has_entry_draft ?entry_draft)
        (risk_rule_available ?risk_rule)
      )
    :effect
      (and
        (entry_draft_has_risk_rule ?entry_draft ?risk_rule)
        (not
          (risk_rule_available ?risk_rule)
        )
      )
  )
  (:action detach_risk_rule_from_entry_draft
    :parameters (?entry_draft - customs_entry_draft ?risk_rule - risk_rule)
    :precondition
      (and
        (entry_draft_has_risk_rule ?entry_draft ?risk_rule)
      )
    :effect
      (and
        (risk_rule_available ?risk_rule)
        (not
          (entry_draft_has_risk_rule ?entry_draft ?risk_rule)
        )
      )
  )
  (:action start_export_line_validation
    :parameters (?export_case - export_shipment_case ?line_item - line_item ?classifier_service - automated_classifier_service)
    :precondition
      (and
        (case_has_entry_draft ?export_case)
        (case_classified_by ?export_case ?classifier_service)
        (export_case_has_line_item ?export_case ?line_item)
        (not
          (line_item_validated ?line_item)
        )
        (not
          (line_item_document_attached ?line_item)
        )
      )
    :effect (line_item_validated ?line_item)
  )
  (:action review_export_line_and_mark_case
    :parameters (?export_case - export_shipment_case ?line_item - line_item ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (case_has_entry_draft ?export_case)
        (case_assigned_reviewer ?export_case ?compliance_reviewer)
        (export_case_has_line_item ?export_case ?line_item)
        (line_item_validated ?line_item)
        (not
          (export_case_lines_processed_flag ?export_case)
        )
      )
    :effect
      (and
        (export_case_lines_processed_flag ?export_case)
        (export_case_line_ready ?export_case)
      )
  )
  (:action attach_supporting_document_to_export_case
    :parameters (?export_case - export_shipment_case ?line_item - line_item ?supporting_document - supporting_document)
    :precondition
      (and
        (case_has_entry_draft ?export_case)
        (export_case_has_line_item ?export_case ?line_item)
        (supporting_document_available ?supporting_document)
        (not
          (export_case_lines_processed_flag ?export_case)
        )
      )
    :effect
      (and
        (line_item_document_attached ?line_item)
        (export_case_lines_processed_flag ?export_case)
        (export_case_has_supporting_document ?export_case ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_export_line_validation
    :parameters (?export_case - export_shipment_case ?line_item - line_item ?classifier_service - automated_classifier_service ?supporting_document - supporting_document)
    :precondition
      (and
        (case_has_entry_draft ?export_case)
        (case_classified_by ?export_case ?classifier_service)
        (export_case_has_line_item ?export_case ?line_item)
        (line_item_document_attached ?line_item)
        (export_case_has_supporting_document ?export_case ?supporting_document)
        (not
          (export_case_line_ready ?export_case)
        )
      )
    :effect
      (and
        (line_item_validated ?line_item)
        (export_case_line_ready ?export_case)
        (supporting_document_available ?supporting_document)
        (not
          (export_case_has_supporting_document ?export_case ?supporting_document)
        )
      )
  )
  (:action start_import_line_validation
    :parameters (?import_case - import_shipment_case ?tariff_decision - tariff_decision_record ?classifier_service - automated_classifier_service)
    :precondition
      (and
        (case_has_entry_draft ?import_case)
        (case_classified_by ?import_case ?classifier_service)
        (import_case_has_tariff_decision ?import_case ?tariff_decision)
        (not
          (tariff_decision_validated ?tariff_decision)
        )
        (not
          (tariff_decision_document_attached ?tariff_decision)
        )
      )
    :effect (tariff_decision_validated ?tariff_decision)
  )
  (:action review_import_line_and_mark_case
    :parameters (?import_case - import_shipment_case ?tariff_decision - tariff_decision_record ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (case_has_entry_draft ?import_case)
        (case_assigned_reviewer ?import_case ?compliance_reviewer)
        (import_case_has_tariff_decision ?import_case ?tariff_decision)
        (tariff_decision_validated ?tariff_decision)
        (not
          (import_case_lines_processed_flag ?import_case)
        )
      )
    :effect
      (and
        (import_case_lines_processed_flag ?import_case)
        (import_case_line_ready ?import_case)
      )
  )
  (:action attach_supporting_document_to_import_case
    :parameters (?import_case - import_shipment_case ?tariff_decision - tariff_decision_record ?supporting_document - supporting_document)
    :precondition
      (and
        (case_has_entry_draft ?import_case)
        (import_case_has_tariff_decision ?import_case ?tariff_decision)
        (supporting_document_available ?supporting_document)
        (not
          (import_case_lines_processed_flag ?import_case)
        )
      )
    :effect
      (and
        (tariff_decision_document_attached ?tariff_decision)
        (import_case_lines_processed_flag ?import_case)
        (import_case_has_supporting_document ?import_case ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_import_line_validation
    :parameters (?import_case - import_shipment_case ?tariff_decision - tariff_decision_record ?classifier_service - automated_classifier_service ?supporting_document - supporting_document)
    :precondition
      (and
        (case_has_entry_draft ?import_case)
        (case_classified_by ?import_case ?classifier_service)
        (import_case_has_tariff_decision ?import_case ?tariff_decision)
        (tariff_decision_document_attached ?tariff_decision)
        (import_case_has_supporting_document ?import_case ?supporting_document)
        (not
          (import_case_line_ready ?import_case)
        )
      )
    :effect
      (and
        (tariff_decision_validated ?tariff_decision)
        (import_case_line_ready ?import_case)
        (supporting_document_available ?supporting_document)
        (not
          (import_case_has_supporting_document ?import_case ?supporting_document)
        )
      )
  )
  (:action assemble_submission_package_standard
    :parameters (?export_case - export_shipment_case ?import_case - import_shipment_case ?line_item - line_item ?tariff_decision - tariff_decision_record ?submission_package - submission_package)
    :precondition
      (and
        (export_case_lines_processed_flag ?export_case)
        (import_case_lines_processed_flag ?import_case)
        (export_case_has_line_item ?export_case ?line_item)
        (import_case_has_tariff_decision ?import_case ?tariff_decision)
        (line_item_validated ?line_item)
        (tariff_decision_validated ?tariff_decision)
        (export_case_line_ready ?export_case)
        (import_case_line_ready ?import_case)
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_selected ?submission_package)
        (submission_package_contains_line_item ?submission_package ?line_item)
        (submission_package_contains_tariff_decision ?submission_package ?tariff_decision)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_requires_docs
    :parameters (?export_case - export_shipment_case ?import_case - import_shipment_case ?line_item - line_item ?tariff_decision - tariff_decision_record ?submission_package - submission_package)
    :precondition
      (and
        (export_case_lines_processed_flag ?export_case)
        (import_case_lines_processed_flag ?import_case)
        (export_case_has_line_item ?export_case ?line_item)
        (import_case_has_tariff_decision ?import_case ?tariff_decision)
        (line_item_document_attached ?line_item)
        (tariff_decision_validated ?tariff_decision)
        (not
          (export_case_line_ready ?export_case)
        )
        (import_case_line_ready ?import_case)
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_selected ?submission_package)
        (submission_package_contains_line_item ?submission_package ?line_item)
        (submission_package_contains_tariff_decision ?submission_package ?tariff_decision)
        (submission_package_pending_documents ?submission_package)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_requires_tariff_checks
    :parameters (?export_case - export_shipment_case ?import_case - import_shipment_case ?line_item - line_item ?tariff_decision - tariff_decision_record ?submission_package - submission_package)
    :precondition
      (and
        (export_case_lines_processed_flag ?export_case)
        (import_case_lines_processed_flag ?import_case)
        (export_case_has_line_item ?export_case ?line_item)
        (import_case_has_tariff_decision ?import_case ?tariff_decision)
        (line_item_validated ?line_item)
        (tariff_decision_document_attached ?tariff_decision)
        (export_case_line_ready ?export_case)
        (not
          (import_case_line_ready ?import_case)
        )
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_selected ?submission_package)
        (submission_package_contains_line_item ?submission_package ?line_item)
        (submission_package_contains_tariff_decision ?submission_package ?tariff_decision)
        (submission_package_pending_tariff_checks ?submission_package)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action assemble_submission_package_requires_docs_and_tariff_checks
    :parameters (?export_case - export_shipment_case ?import_case - import_shipment_case ?line_item - line_item ?tariff_decision - tariff_decision_record ?submission_package - submission_package)
    :precondition
      (and
        (export_case_lines_processed_flag ?export_case)
        (import_case_lines_processed_flag ?import_case)
        (export_case_has_line_item ?export_case ?line_item)
        (import_case_has_tariff_decision ?import_case ?tariff_decision)
        (line_item_document_attached ?line_item)
        (tariff_decision_document_attached ?tariff_decision)
        (not
          (export_case_line_ready ?export_case)
        )
        (not
          (import_case_line_ready ?import_case)
        )
        (submission_package_available ?submission_package)
      )
    :effect
      (and
        (submission_package_selected ?submission_package)
        (submission_package_contains_line_item ?submission_package ?line_item)
        (submission_package_contains_tariff_decision ?submission_package ?tariff_decision)
        (submission_package_pending_documents ?submission_package)
        (submission_package_pending_tariff_checks ?submission_package)
        (not
          (submission_package_available ?submission_package)
        )
      )
  )
  (:action lock_submission_package
    :parameters (?submission_package - submission_package ?export_case - export_shipment_case ?classifier_service - automated_classifier_service)
    :precondition
      (and
        (submission_package_selected ?submission_package)
        (export_case_lines_processed_flag ?export_case)
        (case_classified_by ?export_case ?classifier_service)
        (not
          (submission_package_locked ?submission_package)
        )
      )
    :effect (submission_package_locked ?submission_package)
  )
  (:action attach_regulatory_certificate_to_submission_package
    :parameters (?entry_draft - customs_entry_draft ?regulatory_certificate - regulatory_certificate ?submission_package - submission_package)
    :precondition
      (and
        (case_has_entry_draft ?entry_draft)
        (entry_draft_linked_submission_package ?entry_draft ?submission_package)
        (entry_draft_has_certificate ?entry_draft ?regulatory_certificate)
        (regulatory_certificate_available ?regulatory_certificate)
        (submission_package_selected ?submission_package)
        (submission_package_locked ?submission_package)
        (not
          (regulatory_certificate_consumed ?regulatory_certificate)
        )
      )
    :effect
      (and
        (regulatory_certificate_consumed ?regulatory_certificate)
        (regulatory_certificate_attached_to_submission ?regulatory_certificate ?submission_package)
        (not
          (regulatory_certificate_available ?regulatory_certificate)
        )
      )
  )
  (:action mark_entry_draft_validated
    :parameters (?entry_draft - customs_entry_draft ?regulatory_certificate - regulatory_certificate ?submission_package - submission_package ?classifier_service - automated_classifier_service)
    :precondition
      (and
        (case_has_entry_draft ?entry_draft)
        (entry_draft_has_certificate ?entry_draft ?regulatory_certificate)
        (regulatory_certificate_consumed ?regulatory_certificate)
        (regulatory_certificate_attached_to_submission ?regulatory_certificate ?submission_package)
        (case_classified_by ?entry_draft ?classifier_service)
        (not
          (submission_package_pending_documents ?submission_package)
        )
        (not
          (entry_draft_validated ?entry_draft)
        )
      )
    :effect (entry_draft_validated ?entry_draft)
  )
  (:action attach_regulation_reference_to_entry_draft
    :parameters (?entry_draft - customs_entry_draft ?regulation_reference - regulation_reference)
    :precondition
      (and
        (case_has_entry_draft ?entry_draft)
        (regulation_reference_available ?regulation_reference)
        (not
          (entry_draft_regulation_reference_applied ?entry_draft)
        )
      )
    :effect
      (and
        (entry_draft_regulation_reference_applied ?entry_draft)
        (entry_draft_has_regulation_reference ?entry_draft ?regulation_reference)
        (not
          (regulation_reference_available ?regulation_reference)
        )
      )
  )
  (:action apply_regulation_reference_to_entry_draft
    :parameters (?entry_draft - customs_entry_draft ?regulatory_certificate - regulatory_certificate ?submission_package - submission_package ?classifier_service - automated_classifier_service ?regulation_reference - regulation_reference)
    :precondition
      (and
        (case_has_entry_draft ?entry_draft)
        (entry_draft_has_certificate ?entry_draft ?regulatory_certificate)
        (regulatory_certificate_consumed ?regulatory_certificate)
        (regulatory_certificate_attached_to_submission ?regulatory_certificate ?submission_package)
        (case_classified_by ?entry_draft ?classifier_service)
        (submission_package_pending_documents ?submission_package)
        (entry_draft_regulation_reference_applied ?entry_draft)
        (entry_draft_has_regulation_reference ?entry_draft ?regulation_reference)
        (not
          (entry_draft_validated ?entry_draft)
        )
      )
    :effect
      (and
        (entry_draft_validated ?entry_draft)
        (entry_draft_regulation_confirmed ?entry_draft)
      )
  )
  (:action apply_license_to_entry_draft
    :parameters (?entry_draft - customs_entry_draft ?license_record - license_record ?compliance_reviewer - compliance_reviewer ?regulatory_certificate - regulatory_certificate ?submission_package - submission_package)
    :precondition
      (and
        (entry_draft_validated ?entry_draft)
        (entry_draft_has_license_record ?entry_draft ?license_record)
        (case_assigned_reviewer ?entry_draft ?compliance_reviewer)
        (entry_draft_has_certificate ?entry_draft ?regulatory_certificate)
        (regulatory_certificate_attached_to_submission ?regulatory_certificate ?submission_package)
        (not
          (submission_package_pending_tariff_checks ?submission_package)
        )
        (not
          (entry_draft_license_applied ?entry_draft)
        )
      )
    :effect (entry_draft_license_applied ?entry_draft)
  )
  (:action apply_license_to_entry_draft_with_package_pending
    :parameters (?entry_draft - customs_entry_draft ?license_record - license_record ?compliance_reviewer - compliance_reviewer ?regulatory_certificate - regulatory_certificate ?submission_package - submission_package)
    :precondition
      (and
        (entry_draft_validated ?entry_draft)
        (entry_draft_has_license_record ?entry_draft ?license_record)
        (case_assigned_reviewer ?entry_draft ?compliance_reviewer)
        (entry_draft_has_certificate ?entry_draft ?regulatory_certificate)
        (regulatory_certificate_attached_to_submission ?regulatory_certificate ?submission_package)
        (submission_package_pending_tariff_checks ?submission_package)
        (not
          (entry_draft_license_applied ?entry_draft)
        )
      )
    :effect (entry_draft_license_applied ?entry_draft)
  )
  (:action apply_risk_rule_to_entry_draft
    :parameters (?entry_draft - customs_entry_draft ?risk_rule - risk_rule ?regulatory_certificate - regulatory_certificate ?submission_package - submission_package)
    :precondition
      (and
        (entry_draft_license_applied ?entry_draft)
        (entry_draft_has_risk_rule ?entry_draft ?risk_rule)
        (entry_draft_has_certificate ?entry_draft ?regulatory_certificate)
        (regulatory_certificate_attached_to_submission ?regulatory_certificate ?submission_package)
        (not
          (submission_package_pending_documents ?submission_package)
        )
        (not
          (submission_package_pending_tariff_checks ?submission_package)
        )
        (not
          (entry_draft_risk_assessed ?entry_draft)
        )
      )
    :effect (entry_draft_risk_assessed ?entry_draft)
  )
  (:action apply_risk_rule_to_entry_draft_with_package_pending
    :parameters (?entry_draft - customs_entry_draft ?risk_rule - risk_rule ?regulatory_certificate - regulatory_certificate ?submission_package - submission_package)
    :precondition
      (and
        (entry_draft_license_applied ?entry_draft)
        (entry_draft_has_risk_rule ?entry_draft ?risk_rule)
        (entry_draft_has_certificate ?entry_draft ?regulatory_certificate)
        (regulatory_certificate_attached_to_submission ?regulatory_certificate ?submission_package)
        (submission_package_pending_documents ?submission_package)
        (not
          (submission_package_pending_tariff_checks ?submission_package)
        )
        (not
          (entry_draft_risk_assessed ?entry_draft)
        )
      )
    :effect
      (and
        (entry_draft_risk_assessed ?entry_draft)
        (entry_draft_trade_agreement_applied ?entry_draft)
      )
  )
  (:action apply_risk_rule_to_entry_draft_variant
    :parameters (?entry_draft - customs_entry_draft ?risk_rule - risk_rule ?regulatory_certificate - regulatory_certificate ?submission_package - submission_package)
    :precondition
      (and
        (entry_draft_license_applied ?entry_draft)
        (entry_draft_has_risk_rule ?entry_draft ?risk_rule)
        (entry_draft_has_certificate ?entry_draft ?regulatory_certificate)
        (regulatory_certificate_attached_to_submission ?regulatory_certificate ?submission_package)
        (not
          (submission_package_pending_documents ?submission_package)
        )
        (submission_package_pending_tariff_checks ?submission_package)
        (not
          (entry_draft_risk_assessed ?entry_draft)
        )
      )
    :effect
      (and
        (entry_draft_risk_assessed ?entry_draft)
        (entry_draft_trade_agreement_applied ?entry_draft)
      )
  )
  (:action apply_risk_rule_to_entry_draft_variant2
    :parameters (?entry_draft - customs_entry_draft ?risk_rule - risk_rule ?regulatory_certificate - regulatory_certificate ?submission_package - submission_package)
    :precondition
      (and
        (entry_draft_license_applied ?entry_draft)
        (entry_draft_has_risk_rule ?entry_draft ?risk_rule)
        (entry_draft_has_certificate ?entry_draft ?regulatory_certificate)
        (regulatory_certificate_attached_to_submission ?regulatory_certificate ?submission_package)
        (submission_package_pending_documents ?submission_package)
        (submission_package_pending_tariff_checks ?submission_package)
        (not
          (entry_draft_risk_assessed ?entry_draft)
        )
      )
    :effect
      (and
        (entry_draft_risk_assessed ?entry_draft)
        (entry_draft_trade_agreement_applied ?entry_draft)
      )
  )
  (:action lock_entry_draft_and_flag_case_submission_ready
    :parameters (?entry_draft - customs_entry_draft)
    :precondition
      (and
        (entry_draft_risk_assessed ?entry_draft)
        (not
          (entry_draft_trade_agreement_applied ?entry_draft)
        )
        (not
          (entry_draft_locked ?entry_draft)
        )
      )
    :effect
      (and
        (entry_draft_locked ?entry_draft)
        (case_submission_ready ?entry_draft)
      )
  )
  (:action attach_submission_channel_to_entry_draft
    :parameters (?entry_draft - customs_entry_draft ?submission_channel - submission_channel)
    :precondition
      (and
        (entry_draft_risk_assessed ?entry_draft)
        (entry_draft_trade_agreement_applied ?entry_draft)
        (submission_channel_available ?submission_channel)
      )
    :effect
      (and
        (entry_draft_has_submission_channel ?entry_draft ?submission_channel)
        (not
          (submission_channel_available ?submission_channel)
        )
      )
  )
  (:action authorize_entry_draft_for_submission
    :parameters (?entry_draft - customs_entry_draft ?export_case - export_shipment_case ?import_case - import_shipment_case ?classifier_service - automated_classifier_service ?submission_channel - submission_channel)
    :precondition
      (and
        (entry_draft_risk_assessed ?entry_draft)
        (entry_draft_trade_agreement_applied ?entry_draft)
        (entry_draft_has_submission_channel ?entry_draft ?submission_channel)
        (entry_draft_for_export_case ?entry_draft ?export_case)
        (entry_draft_for_import_case ?entry_draft ?import_case)
        (export_case_line_ready ?export_case)
        (import_case_line_ready ?import_case)
        (case_classified_by ?entry_draft ?classifier_service)
        (not
          (entry_draft_authorized ?entry_draft)
        )
      )
    :effect (entry_draft_authorized ?entry_draft)
  )
  (:action finalize_entry_draft_and_set_case_submission_ready
    :parameters (?entry_draft - customs_entry_draft)
    :precondition
      (and
        (entry_draft_risk_assessed ?entry_draft)
        (entry_draft_authorized ?entry_draft)
        (not
          (entry_draft_locked ?entry_draft)
        )
      )
    :effect
      (and
        (entry_draft_locked ?entry_draft)
        (case_submission_ready ?entry_draft)
      )
  )
  (:action apply_trade_agreement_to_entry_draft
    :parameters (?entry_draft - customs_entry_draft ?trade_agreement_reference - trade_agreement_reference ?classifier_service - automated_classifier_service)
    :precondition
      (and
        (case_has_entry_draft ?entry_draft)
        (case_classified_by ?entry_draft ?classifier_service)
        (trade_agreement_reference_available ?trade_agreement_reference)
        (entry_draft_has_trade_agreement_reference ?entry_draft ?trade_agreement_reference)
        (not
          (entry_draft_trade_agreement_confirmed ?entry_draft)
        )
      )
    :effect
      (and
        (entry_draft_trade_agreement_confirmed ?entry_draft)
        (not
          (trade_agreement_reference_available ?trade_agreement_reference)
        )
      )
  )
  (:action assign_reviewer_to_entry_draft
    :parameters (?entry_draft - customs_entry_draft ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (entry_draft_trade_agreement_confirmed ?entry_draft)
        (case_assigned_reviewer ?entry_draft ?compliance_reviewer)
        (not
          (entry_draft_reviewer_assigned ?entry_draft)
        )
      )
    :effect (entry_draft_reviewer_assigned ?entry_draft)
  )
  (:action apply_risk_rule_during_draft_review
    :parameters (?entry_draft - customs_entry_draft ?risk_rule - risk_rule)
    :precondition
      (and
        (entry_draft_reviewer_assigned ?entry_draft)
        (entry_draft_has_risk_rule ?entry_draft ?risk_rule)
        (not
          (entry_draft_risk_rule_applied ?entry_draft)
        )
      )
    :effect (entry_draft_risk_rule_applied ?entry_draft)
  )
  (:action finalize_entry_draft_post_review_and_flag_case
    :parameters (?entry_draft - customs_entry_draft)
    :precondition
      (and
        (entry_draft_risk_rule_applied ?entry_draft)
        (not
          (entry_draft_locked ?entry_draft)
        )
      )
    :effect
      (and
        (entry_draft_locked ?entry_draft)
        (case_submission_ready ?entry_draft)
      )
  )
  (:action finalize_export_case
    :parameters (?export_case - export_shipment_case ?submission_package - submission_package)
    :precondition
      (and
        (export_case_lines_processed_flag ?export_case)
        (export_case_line_ready ?export_case)
        (submission_package_selected ?submission_package)
        (submission_package_locked ?submission_package)
        (not
          (case_submission_ready ?export_case)
        )
      )
    :effect (case_submission_ready ?export_case)
  )
  (:action finalize_import_case
    :parameters (?import_case - import_shipment_case ?submission_package - submission_package)
    :precondition
      (and
        (import_case_lines_processed_flag ?import_case)
        (import_case_line_ready ?import_case)
        (submission_package_selected ?submission_package)
        (submission_package_locked ?submission_package)
        (not
          (case_submission_ready ?import_case)
        )
      )
    :effect (case_submission_ready ?import_case)
  )
  (:action attach_permit_to_case
    :parameters (?validation_case - commercial_invoice_validation_case ?permit - permit ?classifier_service - automated_classifier_service)
    :precondition
      (and
        (case_submission_ready ?validation_case)
        (case_classified_by ?validation_case ?classifier_service)
        (permit_available ?permit)
        (not
          (case_has_permit ?validation_case)
        )
      )
    :effect
      (and
        (case_has_permit ?validation_case)
        (case_attached_permit ?validation_case ?permit)
        (not
          (permit_available ?permit)
        )
      )
  )
  (:action finalize_export_case_and_release_resources
    :parameters (?export_case - export_shipment_case ?broker - broker ?permit - permit)
    :precondition
      (and
        (case_has_permit ?export_case)
        (case_assigned_broker ?export_case ?broker)
        (case_attached_permit ?export_case ?permit)
        (not
          (case_finalized ?export_case)
        )
      )
    :effect
      (and
        (case_finalized ?export_case)
        (broker_available ?broker)
        (permit_available ?permit)
      )
  )
  (:action finalize_import_case_and_release_resources
    :parameters (?import_case - import_shipment_case ?broker - broker ?permit - permit)
    :precondition
      (and
        (case_has_permit ?import_case)
        (case_assigned_broker ?import_case ?broker)
        (case_attached_permit ?import_case ?permit)
        (not
          (case_finalized ?import_case)
        )
      )
    :effect
      (and
        (case_finalized ?import_case)
        (broker_available ?broker)
        (permit_available ?permit)
      )
  )
  (:action finalize_entry_draft_and_release_resources
    :parameters (?entry_draft - customs_entry_draft ?broker - broker ?permit - permit)
    :precondition
      (and
        (case_has_permit ?entry_draft)
        (case_assigned_broker ?entry_draft ?broker)
        (case_attached_permit ?entry_draft ?permit)
        (not
          (case_finalized ?entry_draft)
        )
      )
    :effect
      (and
        (case_finalized ?entry_draft)
        (broker_available ?broker)
        (permit_available ?permit)
      )
  )
)

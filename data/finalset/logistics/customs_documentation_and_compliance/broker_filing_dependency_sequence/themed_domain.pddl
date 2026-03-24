(define (domain broker_filing_dependency_sequence_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object filing_resource - entity document_type_role - entity location_role - entity broker_filing_domain - entity trade_case - broker_filing_domain broker_agent - filing_resource commodity_classifier_service - filing_resource validation_service - filing_resource document_template - filing_resource additional_credential - filing_resource regulatory_permit_reference - filing_resource special_clearance_code - filing_resource inspection_certificate - filing_resource supporting_document - document_type_role permit_or_certificate - document_type_role priority_marker - document_type_role clearance_channel - location_role entry_point - location_role submission_package - location_role movement_group - trade_case filing_group - trade_case export_movement - movement_group import_movement - movement_group broker_submission_job - filing_group)

  (:predicates
    (case_created ?trade_case - trade_case)
    (classification_confirmed ?trade_case - trade_case)
    (broker_engaged ?trade_case - trade_case)
    (filed ?trade_case - trade_case)
    (ready_for_clearance ?trade_case - trade_case)
    (compliance_validated ?trade_case - trade_case)
    (broker_available ?broker_agent - broker_agent)
    (case_assigned_to_broker ?trade_case - trade_case ?broker_agent - broker_agent)
    (classifier_available ?commodity_classifier_service - commodity_classifier_service)
    (classification_assignment ?trade_case - trade_case ?commodity_classifier_service - commodity_classifier_service)
    (validator_available ?validation_service - validation_service)
    (validation_assignment ?trade_case - trade_case ?validation_service - validation_service)
    (document_available ?supporting_document - supporting_document)
    (export_movement_attached_document ?export_movement - export_movement ?supporting_document - supporting_document)
    (import_movement_attached_document ?import_movement - import_movement ?supporting_document - supporting_document)
    (movement_assigned_channel ?export_movement - export_movement ?clearance_channel - clearance_channel)
    (channel_ready ?clearance_channel - clearance_channel)
    (channel_documentation_attached ?clearance_channel - clearance_channel)
    (export_movement_ready_for_submission ?export_movement - export_movement)
    (movement_assigned_entry_point ?import_movement - import_movement ?entry_point - entry_point)
    (entry_point_ready ?entry_point - entry_point)
    (entry_point_documentation_attached ?entry_point - entry_point)
    (import_movement_ready_for_submission ?import_movement - import_movement)
    (package_available_for_assembly ?submission_package - submission_package)
    (package_prepared ?submission_package - submission_package)
    (package_assigned_to_channel ?submission_package - submission_package ?clearance_channel - clearance_channel)
    (package_assigned_to_entry_point ?submission_package - submission_package ?entry_point - entry_point)
    (package_includes_channel_documents ?submission_package - submission_package)
    (package_includes_entry_documents ?submission_package - submission_package)
    (package_ready_for_attachment_processing ?submission_package - submission_package)
    (job_linked_to_export_movement ?broker_submission_job - broker_submission_job ?export_movement - export_movement)
    (job_linked_to_import_movement ?broker_submission_job - broker_submission_job ?import_movement - import_movement)
    (job_linked_to_package ?broker_submission_job - broker_submission_job ?submission_package - submission_package)
    (permit_available ?permit_or_certificate - permit_or_certificate)
    (job_attached_permit ?broker_submission_job - broker_submission_job ?permit_or_certificate - permit_or_certificate)
    (permit_attached ?permit_or_certificate - permit_or_certificate)
    (permit_attached_to_package ?permit_or_certificate - permit_or_certificate ?submission_package - submission_package)
    (job_endorsement_initiated ?broker_submission_job - broker_submission_job)
    (job_endorsement_recorded ?broker_submission_job - broker_submission_job)
    (job_approval_requested ?broker_submission_job - broker_submission_job)
    (job_template_bound ?broker_submission_job - broker_submission_job)
    (job_template_applied ?broker_submission_job - broker_submission_job)
    (job_credentials_bound ?broker_submission_job - broker_submission_job)
    (job_checks_completed ?broker_submission_job - broker_submission_job)
    (priority_marker_available ?priority_marker - priority_marker)
    (job_has_priority_marker ?broker_submission_job - broker_submission_job ?priority_marker - priority_marker)
    (job_priority_recorded ?broker_submission_job - broker_submission_job)
    (job_template_verified ?broker_submission_job - broker_submission_job)
    (inspection_certificate_attached ?broker_submission_job - broker_submission_job)
    (template_available ?document_template - document_template)
    (job_attached_template ?broker_submission_job - broker_submission_job ?document_template - document_template)
    (credential_available ?additional_credential - additional_credential)
    (job_bound_credential ?broker_submission_job - broker_submission_job ?additional_credential - additional_credential)
    (special_clearance_code_available ?special_clearance_code - special_clearance_code)
    (job_attached_special_clearance_code ?broker_submission_job - broker_submission_job ?special_clearance_code - special_clearance_code)
    (inspection_certificate_available ?inspection_certificate - inspection_certificate)
    (inspection_certificate_assigned ?broker_submission_job - broker_submission_job ?inspection_certificate - inspection_certificate)
    (permit_reference_available ?regulatory_permit_reference - regulatory_permit_reference)
    (case_linked_permit_reference ?trade_case - trade_case ?regulatory_permit_reference - regulatory_permit_reference)
    (export_movement_processed ?export_movement - export_movement)
    (import_movement_processed ?import_movement - import_movement)
    (submission_job_finalized ?broker_submission_job - broker_submission_job)
  )
  (:action create_trade_case
    :parameters (?trade_case - trade_case)
    :precondition
      (and
        (not
          (case_created ?trade_case)
        )
        (not
          (filed ?trade_case)
        )
      )
    :effect (case_created ?trade_case)
  )
  (:action assign_broker_to_case
    :parameters (?trade_case - trade_case ?broker_agent - broker_agent)
    :precondition
      (and
        (case_created ?trade_case)
        (not
          (broker_engaged ?trade_case)
        )
        (broker_available ?broker_agent)
      )
    :effect
      (and
        (broker_engaged ?trade_case)
        (case_assigned_to_broker ?trade_case ?broker_agent)
        (not
          (broker_available ?broker_agent)
        )
      )
  )
  (:action request_commodity_classification
    :parameters (?trade_case - trade_case ?commodity_classifier_service - commodity_classifier_service)
    :precondition
      (and
        (case_created ?trade_case)
        (broker_engaged ?trade_case)
        (classifier_available ?commodity_classifier_service)
      )
    :effect
      (and
        (classification_assignment ?trade_case ?commodity_classifier_service)
        (not
          (classifier_available ?commodity_classifier_service)
        )
      )
  )
  (:action confirm_commodity_classification
    :parameters (?trade_case - trade_case ?commodity_classifier_service - commodity_classifier_service)
    :precondition
      (and
        (case_created ?trade_case)
        (broker_engaged ?trade_case)
        (classification_assignment ?trade_case ?commodity_classifier_service)
        (not
          (classification_confirmed ?trade_case)
        )
      )
    :effect (classification_confirmed ?trade_case)
  )
  (:action release_commodity_classifier
    :parameters (?trade_case - trade_case ?commodity_classifier_service - commodity_classifier_service)
    :precondition
      (and
        (classification_assignment ?trade_case ?commodity_classifier_service)
      )
    :effect
      (and
        (classifier_available ?commodity_classifier_service)
        (not
          (classification_assignment ?trade_case ?commodity_classifier_service)
        )
      )
  )
  (:action invoke_validation_service
    :parameters (?trade_case - trade_case ?validation_service - validation_service)
    :precondition
      (and
        (classification_confirmed ?trade_case)
        (validator_available ?validation_service)
      )
    :effect
      (and
        (validation_assignment ?trade_case ?validation_service)
        (not
          (validator_available ?validation_service)
        )
      )
  )
  (:action release_validation_service
    :parameters (?trade_case - trade_case ?validation_service - validation_service)
    :precondition
      (and
        (validation_assignment ?trade_case ?validation_service)
      )
    :effect
      (and
        (validator_available ?validation_service)
        (not
          (validation_assignment ?trade_case ?validation_service)
        )
      )
  )
  (:action attach_special_clearance_code_to_job
    :parameters (?broker_submission_job - broker_submission_job ?special_clearance_code - special_clearance_code)
    :precondition
      (and
        (classification_confirmed ?broker_submission_job)
        (special_clearance_code_available ?special_clearance_code)
      )
    :effect
      (and
        (job_attached_special_clearance_code ?broker_submission_job ?special_clearance_code)
        (not
          (special_clearance_code_available ?special_clearance_code)
        )
      )
  )
  (:action detach_special_clearance_code_from_job
    :parameters (?broker_submission_job - broker_submission_job ?special_clearance_code - special_clearance_code)
    :precondition
      (and
        (job_attached_special_clearance_code ?broker_submission_job ?special_clearance_code)
      )
    :effect
      (and
        (special_clearance_code_available ?special_clearance_code)
        (not
          (job_attached_special_clearance_code ?broker_submission_job ?special_clearance_code)
        )
      )
  )
  (:action attach_inspection_certificate_to_job
    :parameters (?broker_submission_job - broker_submission_job ?inspection_certificate - inspection_certificate)
    :precondition
      (and
        (classification_confirmed ?broker_submission_job)
        (inspection_certificate_available ?inspection_certificate)
      )
    :effect
      (and
        (inspection_certificate_assigned ?broker_submission_job ?inspection_certificate)
        (not
          (inspection_certificate_available ?inspection_certificate)
        )
      )
  )
  (:action detach_inspection_certificate_from_job
    :parameters (?broker_submission_job - broker_submission_job ?inspection_certificate - inspection_certificate)
    :precondition
      (and
        (inspection_certificate_assigned ?broker_submission_job ?inspection_certificate)
      )
    :effect
      (and
        (inspection_certificate_available ?inspection_certificate)
        (not
          (inspection_certificate_assigned ?broker_submission_job ?inspection_certificate)
        )
      )
  )
  (:action assess_channel_readiness
    :parameters (?export_movement - export_movement ?clearance_channel - clearance_channel ?commodity_classifier_service - commodity_classifier_service)
    :precondition
      (and
        (classification_confirmed ?export_movement)
        (classification_assignment ?export_movement ?commodity_classifier_service)
        (movement_assigned_channel ?export_movement ?clearance_channel)
        (not
          (channel_ready ?clearance_channel)
        )
        (not
          (channel_documentation_attached ?clearance_channel)
        )
      )
    :effect (channel_ready ?clearance_channel)
  )
  (:action confirm_channel_validation_for_movement
    :parameters (?export_movement - export_movement ?clearance_channel - clearance_channel ?validation_service - validation_service)
    :precondition
      (and
        (classification_confirmed ?export_movement)
        (validation_assignment ?export_movement ?validation_service)
        (movement_assigned_channel ?export_movement ?clearance_channel)
        (channel_ready ?clearance_channel)
        (not
          (export_movement_processed ?export_movement)
        )
      )
    :effect
      (and
        (export_movement_processed ?export_movement)
        (export_movement_ready_for_submission ?export_movement)
      )
  )
  (:action attach_supporting_document_to_export_movement
    :parameters (?export_movement - export_movement ?clearance_channel - clearance_channel ?supporting_document - supporting_document)
    :precondition
      (and
        (classification_confirmed ?export_movement)
        (movement_assigned_channel ?export_movement ?clearance_channel)
        (document_available ?supporting_document)
        (not
          (export_movement_processed ?export_movement)
        )
      )
    :effect
      (and
        (channel_documentation_attached ?clearance_channel)
        (export_movement_processed ?export_movement)
        (export_movement_attached_document ?export_movement ?supporting_document)
        (not
          (document_available ?supporting_document)
        )
      )
  )
  (:action finalize_export_movement_document_status
    :parameters (?export_movement - export_movement ?clearance_channel - clearance_channel ?commodity_classifier_service - commodity_classifier_service ?supporting_document - supporting_document)
    :precondition
      (and
        (classification_confirmed ?export_movement)
        (classification_assignment ?export_movement ?commodity_classifier_service)
        (movement_assigned_channel ?export_movement ?clearance_channel)
        (channel_documentation_attached ?clearance_channel)
        (export_movement_attached_document ?export_movement ?supporting_document)
        (not
          (export_movement_ready_for_submission ?export_movement)
        )
      )
    :effect
      (and
        (channel_ready ?clearance_channel)
        (export_movement_ready_for_submission ?export_movement)
        (document_available ?supporting_document)
        (not
          (export_movement_attached_document ?export_movement ?supporting_document)
        )
      )
  )
  (:action assess_entry_point_readiness
    :parameters (?import_movement - import_movement ?entry_point - entry_point ?commodity_classifier_service - commodity_classifier_service)
    :precondition
      (and
        (classification_confirmed ?import_movement)
        (classification_assignment ?import_movement ?commodity_classifier_service)
        (movement_assigned_entry_point ?import_movement ?entry_point)
        (not
          (entry_point_ready ?entry_point)
        )
        (not
          (entry_point_documentation_attached ?entry_point)
        )
      )
    :effect (entry_point_ready ?entry_point)
  )
  (:action confirm_entry_point_validation_for_movement
    :parameters (?import_movement - import_movement ?entry_point - entry_point ?validation_service - validation_service)
    :precondition
      (and
        (classification_confirmed ?import_movement)
        (validation_assignment ?import_movement ?validation_service)
        (movement_assigned_entry_point ?import_movement ?entry_point)
        (entry_point_ready ?entry_point)
        (not
          (import_movement_processed ?import_movement)
        )
      )
    :effect
      (and
        (import_movement_processed ?import_movement)
        (import_movement_ready_for_submission ?import_movement)
      )
  )
  (:action attach_supporting_document_to_import_movement
    :parameters (?import_movement - import_movement ?entry_point - entry_point ?supporting_document - supporting_document)
    :precondition
      (and
        (classification_confirmed ?import_movement)
        (movement_assigned_entry_point ?import_movement ?entry_point)
        (document_available ?supporting_document)
        (not
          (import_movement_processed ?import_movement)
        )
      )
    :effect
      (and
        (entry_point_documentation_attached ?entry_point)
        (import_movement_processed ?import_movement)
        (import_movement_attached_document ?import_movement ?supporting_document)
        (not
          (document_available ?supporting_document)
        )
      )
  )
  (:action finalize_import_movement_document_status
    :parameters (?import_movement - import_movement ?entry_point - entry_point ?commodity_classifier_service - commodity_classifier_service ?supporting_document - supporting_document)
    :precondition
      (and
        (classification_confirmed ?import_movement)
        (classification_assignment ?import_movement ?commodity_classifier_service)
        (movement_assigned_entry_point ?import_movement ?entry_point)
        (entry_point_documentation_attached ?entry_point)
        (import_movement_attached_document ?import_movement ?supporting_document)
        (not
          (import_movement_ready_for_submission ?import_movement)
        )
      )
    :effect
      (and
        (entry_point_ready ?entry_point)
        (import_movement_ready_for_submission ?import_movement)
        (document_available ?supporting_document)
        (not
          (import_movement_attached_document ?import_movement ?supporting_document)
        )
      )
  )
  (:action assemble_submission_package
    :parameters (?export_movement - export_movement ?import_movement - import_movement ?clearance_channel - clearance_channel ?entry_point - entry_point ?submission_package - submission_package)
    :precondition
      (and
        (export_movement_processed ?export_movement)
        (import_movement_processed ?import_movement)
        (movement_assigned_channel ?export_movement ?clearance_channel)
        (movement_assigned_entry_point ?import_movement ?entry_point)
        (channel_ready ?clearance_channel)
        (entry_point_ready ?entry_point)
        (export_movement_ready_for_submission ?export_movement)
        (import_movement_ready_for_submission ?import_movement)
        (package_available_for_assembly ?submission_package)
      )
    :effect
      (and
        (package_prepared ?submission_package)
        (package_assigned_to_channel ?submission_package ?clearance_channel)
        (package_assigned_to_entry_point ?submission_package ?entry_point)
        (not
          (package_available_for_assembly ?submission_package)
        )
      )
  )
  (:action assemble_package_with_channel_documents
    :parameters (?export_movement - export_movement ?import_movement - import_movement ?clearance_channel - clearance_channel ?entry_point - entry_point ?submission_package - submission_package)
    :precondition
      (and
        (export_movement_processed ?export_movement)
        (import_movement_processed ?import_movement)
        (movement_assigned_channel ?export_movement ?clearance_channel)
        (movement_assigned_entry_point ?import_movement ?entry_point)
        (channel_documentation_attached ?clearance_channel)
        (entry_point_ready ?entry_point)
        (not
          (export_movement_ready_for_submission ?export_movement)
        )
        (import_movement_ready_for_submission ?import_movement)
        (package_available_for_assembly ?submission_package)
      )
    :effect
      (and
        (package_prepared ?submission_package)
        (package_assigned_to_channel ?submission_package ?clearance_channel)
        (package_assigned_to_entry_point ?submission_package ?entry_point)
        (package_includes_channel_documents ?submission_package)
        (not
          (package_available_for_assembly ?submission_package)
        )
      )
  )
  (:action assemble_package_with_entry_documents
    :parameters (?export_movement - export_movement ?import_movement - import_movement ?clearance_channel - clearance_channel ?entry_point - entry_point ?submission_package - submission_package)
    :precondition
      (and
        (export_movement_processed ?export_movement)
        (import_movement_processed ?import_movement)
        (movement_assigned_channel ?export_movement ?clearance_channel)
        (movement_assigned_entry_point ?import_movement ?entry_point)
        (channel_ready ?clearance_channel)
        (entry_point_documentation_attached ?entry_point)
        (export_movement_ready_for_submission ?export_movement)
        (not
          (import_movement_ready_for_submission ?import_movement)
        )
        (package_available_for_assembly ?submission_package)
      )
    :effect
      (and
        (package_prepared ?submission_package)
        (package_assigned_to_channel ?submission_package ?clearance_channel)
        (package_assigned_to_entry_point ?submission_package ?entry_point)
        (package_includes_entry_documents ?submission_package)
        (not
          (package_available_for_assembly ?submission_package)
        )
      )
  )
  (:action assemble_package_with_channel_and_entry_documents
    :parameters (?export_movement - export_movement ?import_movement - import_movement ?clearance_channel - clearance_channel ?entry_point - entry_point ?submission_package - submission_package)
    :precondition
      (and
        (export_movement_processed ?export_movement)
        (import_movement_processed ?import_movement)
        (movement_assigned_channel ?export_movement ?clearance_channel)
        (movement_assigned_entry_point ?import_movement ?entry_point)
        (channel_documentation_attached ?clearance_channel)
        (entry_point_documentation_attached ?entry_point)
        (not
          (export_movement_ready_for_submission ?export_movement)
        )
        (not
          (import_movement_ready_for_submission ?import_movement)
        )
        (package_available_for_assembly ?submission_package)
      )
    :effect
      (and
        (package_prepared ?submission_package)
        (package_assigned_to_channel ?submission_package ?clearance_channel)
        (package_assigned_to_entry_point ?submission_package ?entry_point)
        (package_includes_channel_documents ?submission_package)
        (package_includes_entry_documents ?submission_package)
        (not
          (package_available_for_assembly ?submission_package)
        )
      )
  )
  (:action finalize_package_for_attachment_processing
    :parameters (?submission_package - submission_package ?export_movement - export_movement ?commodity_classifier_service - commodity_classifier_service)
    :precondition
      (and
        (package_prepared ?submission_package)
        (export_movement_processed ?export_movement)
        (classification_assignment ?export_movement ?commodity_classifier_service)
        (not
          (package_ready_for_attachment_processing ?submission_package)
        )
      )
    :effect (package_ready_for_attachment_processing ?submission_package)
  )
  (:action attach_permit_to_package
    :parameters (?broker_submission_job - broker_submission_job ?permit_or_certificate - permit_or_certificate ?submission_package - submission_package)
    :precondition
      (and
        (classification_confirmed ?broker_submission_job)
        (job_linked_to_package ?broker_submission_job ?submission_package)
        (job_attached_permit ?broker_submission_job ?permit_or_certificate)
        (permit_available ?permit_or_certificate)
        (package_prepared ?submission_package)
        (package_ready_for_attachment_processing ?submission_package)
        (not
          (permit_attached ?permit_or_certificate)
        )
      )
    :effect
      (and
        (permit_attached ?permit_or_certificate)
        (permit_attached_to_package ?permit_or_certificate ?submission_package)
        (not
          (permit_available ?permit_or_certificate)
        )
      )
  )
  (:action initiate_job_endorsement
    :parameters (?broker_submission_job - broker_submission_job ?permit_or_certificate - permit_or_certificate ?submission_package - submission_package ?commodity_classifier_service - commodity_classifier_service)
    :precondition
      (and
        (classification_confirmed ?broker_submission_job)
        (job_attached_permit ?broker_submission_job ?permit_or_certificate)
        (permit_attached ?permit_or_certificate)
        (permit_attached_to_package ?permit_or_certificate ?submission_package)
        (classification_assignment ?broker_submission_job ?commodity_classifier_service)
        (not
          (package_includes_channel_documents ?submission_package)
        )
        (not
          (job_endorsement_initiated ?broker_submission_job)
        )
      )
    :effect (job_endorsement_initiated ?broker_submission_job)
  )
  (:action attach_document_template_to_job
    :parameters (?broker_submission_job - broker_submission_job ?document_template - document_template)
    :precondition
      (and
        (classification_confirmed ?broker_submission_job)
        (template_available ?document_template)
        (not
          (job_template_bound ?broker_submission_job)
        )
      )
    :effect
      (and
        (job_template_bound ?broker_submission_job)
        (job_attached_template ?broker_submission_job ?document_template)
        (not
          (template_available ?document_template)
        )
      )
  )
  (:action apply_template_and_start_endorsement
    :parameters (?broker_submission_job - broker_submission_job ?permit_or_certificate - permit_or_certificate ?submission_package - submission_package ?commodity_classifier_service - commodity_classifier_service ?document_template - document_template)
    :precondition
      (and
        (classification_confirmed ?broker_submission_job)
        (job_attached_permit ?broker_submission_job ?permit_or_certificate)
        (permit_attached ?permit_or_certificate)
        (permit_attached_to_package ?permit_or_certificate ?submission_package)
        (classification_assignment ?broker_submission_job ?commodity_classifier_service)
        (package_includes_channel_documents ?submission_package)
        (job_template_bound ?broker_submission_job)
        (job_attached_template ?broker_submission_job ?document_template)
        (not
          (job_endorsement_initiated ?broker_submission_job)
        )
      )
    :effect
      (and
        (job_endorsement_initiated ?broker_submission_job)
        (job_template_applied ?broker_submission_job)
      )
  )
  (:action endorse_job_with_special_clearance
    :parameters (?broker_submission_job - broker_submission_job ?special_clearance_code - special_clearance_code ?validation_service - validation_service ?permit_or_certificate - permit_or_certificate ?submission_package - submission_package)
    :precondition
      (and
        (job_endorsement_initiated ?broker_submission_job)
        (job_attached_special_clearance_code ?broker_submission_job ?special_clearance_code)
        (validation_assignment ?broker_submission_job ?validation_service)
        (job_attached_permit ?broker_submission_job ?permit_or_certificate)
        (permit_attached_to_package ?permit_or_certificate ?submission_package)
        (not
          (package_includes_entry_documents ?submission_package)
        )
        (not
          (job_endorsement_recorded ?broker_submission_job)
        )
      )
    :effect (job_endorsement_recorded ?broker_submission_job)
  )
  (:action confirm_endorsement_with_special_clearance
    :parameters (?broker_submission_job - broker_submission_job ?special_clearance_code - special_clearance_code ?validation_service - validation_service ?permit_or_certificate - permit_or_certificate ?submission_package - submission_package)
    :precondition
      (and
        (job_endorsement_initiated ?broker_submission_job)
        (job_attached_special_clearance_code ?broker_submission_job ?special_clearance_code)
        (validation_assignment ?broker_submission_job ?validation_service)
        (job_attached_permit ?broker_submission_job ?permit_or_certificate)
        (permit_attached_to_package ?permit_or_certificate ?submission_package)
        (package_includes_entry_documents ?submission_package)
        (not
          (job_endorsement_recorded ?broker_submission_job)
        )
      )
    :effect (job_endorsement_recorded ?broker_submission_job)
  )
  (:action request_job_approval_initial
    :parameters (?broker_submission_job - broker_submission_job ?inspection_certificate - inspection_certificate ?permit_or_certificate - permit_or_certificate ?submission_package - submission_package)
    :precondition
      (and
        (job_endorsement_recorded ?broker_submission_job)
        (inspection_certificate_assigned ?broker_submission_job ?inspection_certificate)
        (job_attached_permit ?broker_submission_job ?permit_or_certificate)
        (permit_attached_to_package ?permit_or_certificate ?submission_package)
        (not
          (package_includes_channel_documents ?submission_package)
        )
        (not
          (package_includes_entry_documents ?submission_package)
        )
        (not
          (job_approval_requested ?broker_submission_job)
        )
      )
    :effect (job_approval_requested ?broker_submission_job)
  )
  (:action request_job_approval_and_bind_credentials
    :parameters (?broker_submission_job - broker_submission_job ?inspection_certificate - inspection_certificate ?permit_or_certificate - permit_or_certificate ?submission_package - submission_package)
    :precondition
      (and
        (job_endorsement_recorded ?broker_submission_job)
        (inspection_certificate_assigned ?broker_submission_job ?inspection_certificate)
        (job_attached_permit ?broker_submission_job ?permit_or_certificate)
        (permit_attached_to_package ?permit_or_certificate ?submission_package)
        (package_includes_channel_documents ?submission_package)
        (not
          (package_includes_entry_documents ?submission_package)
        )
        (not
          (job_approval_requested ?broker_submission_job)
        )
      )
    :effect
      (and
        (job_approval_requested ?broker_submission_job)
        (job_credentials_bound ?broker_submission_job)
      )
  )
  (:action request_job_approval_and_bind_credentials_alt
    :parameters (?broker_submission_job - broker_submission_job ?inspection_certificate - inspection_certificate ?permit_or_certificate - permit_or_certificate ?submission_package - submission_package)
    :precondition
      (and
        (job_endorsement_recorded ?broker_submission_job)
        (inspection_certificate_assigned ?broker_submission_job ?inspection_certificate)
        (job_attached_permit ?broker_submission_job ?permit_or_certificate)
        (permit_attached_to_package ?permit_or_certificate ?submission_package)
        (not
          (package_includes_channel_documents ?submission_package)
        )
        (package_includes_entry_documents ?submission_package)
        (not
          (job_approval_requested ?broker_submission_job)
        )
      )
    :effect
      (and
        (job_approval_requested ?broker_submission_job)
        (job_credentials_bound ?broker_submission_job)
      )
  )
  (:action request_job_approval_and_bind_credentials_final
    :parameters (?broker_submission_job - broker_submission_job ?inspection_certificate - inspection_certificate ?permit_or_certificate - permit_or_certificate ?submission_package - submission_package)
    :precondition
      (and
        (job_endorsement_recorded ?broker_submission_job)
        (inspection_certificate_assigned ?broker_submission_job ?inspection_certificate)
        (job_attached_permit ?broker_submission_job ?permit_or_certificate)
        (permit_attached_to_package ?permit_or_certificate ?submission_package)
        (package_includes_channel_documents ?submission_package)
        (package_includes_entry_documents ?submission_package)
        (not
          (job_approval_requested ?broker_submission_job)
        )
      )
    :effect
      (and
        (job_approval_requested ?broker_submission_job)
        (job_credentials_bound ?broker_submission_job)
      )
  )
  (:action approve_and_finalize_submission_job
    :parameters (?broker_submission_job - broker_submission_job)
    :precondition
      (and
        (job_approval_requested ?broker_submission_job)
        (not
          (job_credentials_bound ?broker_submission_job)
        )
        (not
          (submission_job_finalized ?broker_submission_job)
        )
      )
    :effect
      (and
        (submission_job_finalized ?broker_submission_job)
        (ready_for_clearance ?broker_submission_job)
      )
  )
  (:action attach_additional_credential_to_job
    :parameters (?broker_submission_job - broker_submission_job ?additional_credential - additional_credential)
    :precondition
      (and
        (job_approval_requested ?broker_submission_job)
        (job_credentials_bound ?broker_submission_job)
        (credential_available ?additional_credential)
      )
    :effect
      (and
        (job_bound_credential ?broker_submission_job ?additional_credential)
        (not
          (credential_available ?additional_credential)
        )
      )
  )
  (:action perform_multistage_verification
    :parameters (?broker_submission_job - broker_submission_job ?export_movement - export_movement ?import_movement - import_movement ?commodity_classifier_service - commodity_classifier_service ?additional_credential - additional_credential)
    :precondition
      (and
        (job_approval_requested ?broker_submission_job)
        (job_credentials_bound ?broker_submission_job)
        (job_bound_credential ?broker_submission_job ?additional_credential)
        (job_linked_to_export_movement ?broker_submission_job ?export_movement)
        (job_linked_to_import_movement ?broker_submission_job ?import_movement)
        (export_movement_ready_for_submission ?export_movement)
        (import_movement_ready_for_submission ?import_movement)
        (classification_assignment ?broker_submission_job ?commodity_classifier_service)
        (not
          (job_checks_completed ?broker_submission_job)
        )
      )
    :effect (job_checks_completed ?broker_submission_job)
  )
  (:action confirm_job_approval_and_finalize
    :parameters (?broker_submission_job - broker_submission_job)
    :precondition
      (and
        (job_approval_requested ?broker_submission_job)
        (job_checks_completed ?broker_submission_job)
        (not
          (submission_job_finalized ?broker_submission_job)
        )
      )
    :effect
      (and
        (submission_job_finalized ?broker_submission_job)
        (ready_for_clearance ?broker_submission_job)
      )
  )
  (:action apply_priority_marker_to_job
    :parameters (?broker_submission_job - broker_submission_job ?priority_marker - priority_marker ?commodity_classifier_service - commodity_classifier_service)
    :precondition
      (and
        (classification_confirmed ?broker_submission_job)
        (classification_assignment ?broker_submission_job ?commodity_classifier_service)
        (priority_marker_available ?priority_marker)
        (job_has_priority_marker ?broker_submission_job ?priority_marker)
        (not
          (job_priority_recorded ?broker_submission_job)
        )
      )
    :effect
      (and
        (job_priority_recorded ?broker_submission_job)
        (not
          (priority_marker_available ?priority_marker)
        )
      )
  )
  (:action verify_job_template_binding
    :parameters (?broker_submission_job - broker_submission_job ?validation_service - validation_service)
    :precondition
      (and
        (job_priority_recorded ?broker_submission_job)
        (validation_assignment ?broker_submission_job ?validation_service)
        (not
          (job_template_verified ?broker_submission_job)
        )
      )
    :effect (job_template_verified ?broker_submission_job)
  )
  (:action attach_inspection_certificate_to_job_for_verification
    :parameters (?broker_submission_job - broker_submission_job ?inspection_certificate - inspection_certificate)
    :precondition
      (and
        (job_template_verified ?broker_submission_job)
        (inspection_certificate_assigned ?broker_submission_job ?inspection_certificate)
        (not
          (inspection_certificate_attached ?broker_submission_job)
        )
      )
    :effect (inspection_certificate_attached ?broker_submission_job)
  )
  (:action finalize_job_after_inspection
    :parameters (?broker_submission_job - broker_submission_job)
    :precondition
      (and
        (inspection_certificate_attached ?broker_submission_job)
        (not
          (submission_job_finalized ?broker_submission_job)
        )
      )
    :effect
      (and
        (submission_job_finalized ?broker_submission_job)
        (ready_for_clearance ?broker_submission_job)
      )
  )
  (:action finalize_export_movement_for_filing
    :parameters (?export_movement - export_movement ?submission_package - submission_package)
    :precondition
      (and
        (export_movement_processed ?export_movement)
        (export_movement_ready_for_submission ?export_movement)
        (package_prepared ?submission_package)
        (package_ready_for_attachment_processing ?submission_package)
        (not
          (ready_for_clearance ?export_movement)
        )
      )
    :effect (ready_for_clearance ?export_movement)
  )
  (:action finalize_import_movement_for_filing
    :parameters (?import_movement - import_movement ?submission_package - submission_package)
    :precondition
      (and
        (import_movement_processed ?import_movement)
        (import_movement_ready_for_submission ?import_movement)
        (package_prepared ?submission_package)
        (package_ready_for_attachment_processing ?submission_package)
        (not
          (ready_for_clearance ?import_movement)
        )
      )
    :effect (ready_for_clearance ?import_movement)
  )
  (:action bind_permit_reference_to_case
    :parameters (?trade_case - trade_case ?regulatory_permit_reference - regulatory_permit_reference ?commodity_classifier_service - commodity_classifier_service)
    :precondition
      (and
        (ready_for_clearance ?trade_case)
        (classification_assignment ?trade_case ?commodity_classifier_service)
        (permit_reference_available ?regulatory_permit_reference)
        (not
          (compliance_validated ?trade_case)
        )
      )
    :effect
      (and
        (compliance_validated ?trade_case)
        (case_linked_permit_reference ?trade_case ?regulatory_permit_reference)
        (not
          (permit_reference_available ?regulatory_permit_reference)
        )
      )
  )
  (:action file_export_movement
    :parameters (?export_movement - export_movement ?broker_agent - broker_agent ?regulatory_permit_reference - regulatory_permit_reference)
    :precondition
      (and
        (compliance_validated ?export_movement)
        (case_assigned_to_broker ?export_movement ?broker_agent)
        (case_linked_permit_reference ?export_movement ?regulatory_permit_reference)
        (not
          (filed ?export_movement)
        )
      )
    :effect
      (and
        (filed ?export_movement)
        (broker_available ?broker_agent)
        (permit_reference_available ?regulatory_permit_reference)
      )
  )
  (:action file_import_movement
    :parameters (?import_movement - import_movement ?broker_agent - broker_agent ?regulatory_permit_reference - regulatory_permit_reference)
    :precondition
      (and
        (compliance_validated ?import_movement)
        (case_assigned_to_broker ?import_movement ?broker_agent)
        (case_linked_permit_reference ?import_movement ?regulatory_permit_reference)
        (not
          (filed ?import_movement)
        )
      )
    :effect
      (and
        (filed ?import_movement)
        (broker_available ?broker_agent)
        (permit_reference_available ?regulatory_permit_reference)
      )
  )
  (:action file_submission_job
    :parameters (?broker_submission_job - broker_submission_job ?broker_agent - broker_agent ?regulatory_permit_reference - regulatory_permit_reference)
    :precondition
      (and
        (compliance_validated ?broker_submission_job)
        (case_assigned_to_broker ?broker_submission_job ?broker_agent)
        (case_linked_permit_reference ?broker_submission_job ?regulatory_permit_reference)
        (not
          (filed ?broker_submission_job)
        )
      )
    :effect
      (and
        (filed ?broker_submission_job)
        (broker_available ?broker_agent)
        (permit_reference_available ?regulatory_permit_reference)
      )
  )
)

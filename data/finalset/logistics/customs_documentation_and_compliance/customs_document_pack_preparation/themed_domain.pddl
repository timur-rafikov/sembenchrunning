(define (domain customs_document_pack_preparation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types case_entity - object regulatory_data - object permit_data - object case_root - object trade_case - case_root customs_broker - case_entity regulatory_source - case_entity compliance_reviewer - case_entity insurance_policy - case_entity payment_evidence - case_entity permit_application - case_entity certificate_document - case_entity regulatory_approval - case_entity supporting_document - regulatory_data attachment_artifact - regulatory_data special_authorization - regulatory_data classification_record - permit_data permit_record - permit_data submission_record - permit_data export_segment - trade_case import_segment - trade_case exporter - export_segment export_segment_importer - export_segment document_pack - import_segment)
  (:predicates
    (case_created ?trade_case - trade_case)
    (classification_validated ?trade_case - trade_case)
    (case_broker_assigned ?trade_case - trade_case)
    (ready_for_clearance ?trade_case - trade_case)
    (approved_for_submission ?trade_case - trade_case)
    (case_authorized_for_submission ?trade_case - trade_case)
    (broker_available ?broker - customs_broker)
    (case_assigned_broker ?trade_case - trade_case ?broker - customs_broker)
    (regulatory_source_available ?regulatory_source - regulatory_source)
    (bound_to_regulatory_source ?trade_case - trade_case ?regulatory_source - regulatory_source)
    (reviewer_available ?compliance_reviewer - compliance_reviewer)
    (case_assigned_reviewer ?trade_case - trade_case ?compliance_reviewer - compliance_reviewer)
    (supporting_document_available ?supporting_document - supporting_document)
    (exporter_attached_document ?exporter - exporter ?supporting_document - supporting_document)
    (importer_attached_document ?importer - export_segment_importer ?supporting_document - supporting_document)
    (exporter_classification_assigned ?exporter - exporter ?classification_record - classification_record)
    (classification_reserved ?classification_record - classification_record)
    (classification_document_attached ?classification_record - classification_record)
    (exporter_classification_confirmed ?exporter - exporter)
    (importer_permit_requirement ?importer - export_segment_importer ?permit_record - permit_record)
    (permit_reserved ?permit_record - permit_record)
    (permit_document_attached ?permit_record - permit_record)
    (importer_classification_confirmed ?importer - export_segment_importer)
    (submission_slot_available ?submission_record - submission_record)
    (submission_assembled ?submission_record - submission_record)
    (submission_includes_classification ?submission_record - submission_record ?classification_record - classification_record)
    (submission_includes_permit ?submission_record - submission_record ?permit_record - permit_record)
    (submission_includes_certificate ?submission_record - submission_record)
    (submission_includes_insurance ?submission_record - submission_record)
    (submission_qc_passed ?submission_record - submission_record)
    (pack_linked_exporter ?document_pack - document_pack ?exporter - exporter)
    (pack_linked_importer ?document_pack - document_pack ?importer - export_segment_importer)
    (pack_linked_submission ?document_pack - document_pack ?submission_record - submission_record)
    (attachment_available ?attachment - attachment_artifact)
    (pack_has_attachment ?document_pack - document_pack ?attachment - attachment_artifact)
    (attachment_committed ?attachment - attachment_artifact)
    (attachment_linked_submission ?attachment - attachment_artifact ?submission_record - submission_record)
    (pack_prevalidation_done ?document_pack - document_pack)
    (pack_attachments_verified ?document_pack - document_pack)
    (pack_certification_initiated ?document_pack - document_pack)
    (pack_insurance_attached ?document_pack - document_pack)
    (pack_review_stage2_complete ?document_pack - document_pack)
    (pack_endorsed ?document_pack - document_pack)
    (pack_final_checks_passed ?document_pack - document_pack)
    (special_authorization_available ?special_authorization - special_authorization)
    (pack_has_special_authorization ?document_pack - document_pack ?special_authorization - special_authorization)
    (pack_special_authorization_applied ?document_pack - document_pack)
    (pack_special_authorization_verified ?document_pack - document_pack)
    (pack_special_authorization_certified ?document_pack - document_pack)
    (insurance_policy_available ?insurance_policy - insurance_policy)
    (pack_linked_insurance ?document_pack - document_pack ?insurance_policy - insurance_policy)
    (payment_evidence_available ?payment_evidence - payment_evidence)
    (pack_linked_payment_evidence ?document_pack - document_pack ?payment_evidence - payment_evidence)
    (certificate_available ?certificate_document - certificate_document)
    (pack_linked_certificate ?document_pack - document_pack ?certificate_document - certificate_document)
    (regulatory_approval_available ?regulatory_approval - regulatory_approval)
    (pack_linked_regulatory_approval ?document_pack - document_pack ?regulatory_approval - regulatory_approval)
    (permit_application_available ?permit_application - permit_application)
    (case_linked_permit_application ?trade_case - trade_case ?permit_application - permit_application)
    (exporter_ready_for_submission ?exporter - exporter)
    (importer_ready_for_submission ?importer - export_segment_importer)
    (pack_finalization_completed ?document_pack - document_pack)
  )
  (:action create_trade_case
    :parameters (?trade_case - trade_case)
    :precondition
      (and
        (not
          (case_created ?trade_case)
        )
        (not
          (ready_for_clearance ?trade_case)
        )
      )
    :effect (case_created ?trade_case)
  )
  (:action assign_broker_to_case
    :parameters (?trade_case - trade_case ?broker - customs_broker)
    :precondition
      (and
        (case_created ?trade_case)
        (not
          (case_broker_assigned ?trade_case)
        )
        (broker_available ?broker)
      )
    :effect
      (and
        (case_broker_assigned ?trade_case)
        (case_assigned_broker ?trade_case ?broker)
        (not
          (broker_available ?broker)
        )
      )
  )
  (:action bind_regulatory_source_to_case
    :parameters (?trade_case - trade_case ?regulatory_source - regulatory_source)
    :precondition
      (and
        (case_created ?trade_case)
        (case_broker_assigned ?trade_case)
        (regulatory_source_available ?regulatory_source)
      )
    :effect
      (and
        (bound_to_regulatory_source ?trade_case ?regulatory_source)
        (not
          (regulatory_source_available ?regulatory_source)
        )
      )
  )
  (:action validate_classification_for_case
    :parameters (?trade_case - trade_case ?regulatory_source - regulatory_source)
    :precondition
      (and
        (case_created ?trade_case)
        (case_broker_assigned ?trade_case)
        (bound_to_regulatory_source ?trade_case ?regulatory_source)
        (not
          (classification_validated ?trade_case)
        )
      )
    :effect (classification_validated ?trade_case)
  )
  (:action release_regulatory_source_from_case
    :parameters (?trade_case - trade_case ?regulatory_source - regulatory_source)
    :precondition
      (and
        (bound_to_regulatory_source ?trade_case ?regulatory_source)
      )
    :effect
      (and
        (regulatory_source_available ?regulatory_source)
        (not
          (bound_to_regulatory_source ?trade_case ?regulatory_source)
        )
      )
  )
  (:action assign_compliance_reviewer
    :parameters (?trade_case - trade_case ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (classification_validated ?trade_case)
        (reviewer_available ?compliance_reviewer)
      )
    :effect
      (and
        (case_assigned_reviewer ?trade_case ?compliance_reviewer)
        (not
          (reviewer_available ?compliance_reviewer)
        )
      )
  )
  (:action release_compliance_reviewer
    :parameters (?trade_case - trade_case ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (case_assigned_reviewer ?trade_case ?compliance_reviewer)
      )
    :effect
      (and
        (reviewer_available ?compliance_reviewer)
        (not
          (case_assigned_reviewer ?trade_case ?compliance_reviewer)
        )
      )
  )
  (:action attach_certificate_to_pack
    :parameters (?document_pack - document_pack ?certificate_document - certificate_document)
    :precondition
      (and
        (classification_validated ?document_pack)
        (certificate_available ?certificate_document)
      )
    :effect
      (and
        (pack_linked_certificate ?document_pack ?certificate_document)
        (not
          (certificate_available ?certificate_document)
        )
      )
  )
  (:action detach_certificate_from_pack
    :parameters (?document_pack - document_pack ?certificate_document - certificate_document)
    :precondition
      (and
        (pack_linked_certificate ?document_pack ?certificate_document)
      )
    :effect
      (and
        (certificate_available ?certificate_document)
        (not
          (pack_linked_certificate ?document_pack ?certificate_document)
        )
      )
  )
  (:action attach_regulatory_approval_to_pack
    :parameters (?document_pack - document_pack ?regulatory_approval - regulatory_approval)
    :precondition
      (and
        (classification_validated ?document_pack)
        (regulatory_approval_available ?regulatory_approval)
      )
    :effect
      (and
        (pack_linked_regulatory_approval ?document_pack ?regulatory_approval)
        (not
          (regulatory_approval_available ?regulatory_approval)
        )
      )
  )
  (:action detach_regulatory_approval_from_pack
    :parameters (?document_pack - document_pack ?regulatory_approval - regulatory_approval)
    :precondition
      (and
        (pack_linked_regulatory_approval ?document_pack ?regulatory_approval)
      )
    :effect
      (and
        (regulatory_approval_available ?regulatory_approval)
        (not
          (pack_linked_regulatory_approval ?document_pack ?regulatory_approval)
        )
      )
  )
  (:action reserve_classification_for_exporter
    :parameters (?exporter - exporter ?classification_record - classification_record ?regulatory_source - regulatory_source)
    :precondition
      (and
        (classification_validated ?exporter)
        (bound_to_regulatory_source ?exporter ?regulatory_source)
        (exporter_classification_assigned ?exporter ?classification_record)
        (not
          (classification_reserved ?classification_record)
        )
        (not
          (classification_document_attached ?classification_record)
        )
      )
    :effect (classification_reserved ?classification_record)
  )
  (:action review_classification_for_exporter
    :parameters (?exporter - exporter ?classification_record - classification_record ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (classification_validated ?exporter)
        (case_assigned_reviewer ?exporter ?compliance_reviewer)
        (exporter_classification_assigned ?exporter ?classification_record)
        (classification_reserved ?classification_record)
        (not
          (exporter_ready_for_submission ?exporter)
        )
      )
    :effect
      (and
        (exporter_ready_for_submission ?exporter)
        (exporter_classification_confirmed ?exporter)
      )
  )
  (:action attach_supporting_document_for_exporter
    :parameters (?exporter - exporter ?classification_record - classification_record ?supporting_document - supporting_document)
    :precondition
      (and
        (classification_validated ?exporter)
        (exporter_classification_assigned ?exporter ?classification_record)
        (supporting_document_available ?supporting_document)
        (not
          (exporter_ready_for_submission ?exporter)
        )
      )
    :effect
      (and
        (classification_document_attached ?classification_record)
        (exporter_ready_for_submission ?exporter)
        (exporter_attached_document ?exporter ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_exporter_classification
    :parameters (?exporter - exporter ?classification_record - classification_record ?regulatory_source - regulatory_source ?supporting_document - supporting_document)
    :precondition
      (and
        (classification_validated ?exporter)
        (bound_to_regulatory_source ?exporter ?regulatory_source)
        (exporter_classification_assigned ?exporter ?classification_record)
        (classification_document_attached ?classification_record)
        (exporter_attached_document ?exporter ?supporting_document)
        (not
          (exporter_classification_confirmed ?exporter)
        )
      )
    :effect
      (and
        (classification_reserved ?classification_record)
        (exporter_classification_confirmed ?exporter)
        (supporting_document_available ?supporting_document)
        (not
          (exporter_attached_document ?exporter ?supporting_document)
        )
      )
  )
  (:action reserve_permit_for_importer
    :parameters (?importer - export_segment_importer ?permit_record - permit_record ?regulatory_source - regulatory_source)
    :precondition
      (and
        (classification_validated ?importer)
        (bound_to_regulatory_source ?importer ?regulatory_source)
        (importer_permit_requirement ?importer ?permit_record)
        (not
          (permit_reserved ?permit_record)
        )
        (not
          (permit_document_attached ?permit_record)
        )
      )
    :effect (permit_reserved ?permit_record)
  )
  (:action review_permit_for_importer
    :parameters (?importer - export_segment_importer ?permit_record - permit_record ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (classification_validated ?importer)
        (case_assigned_reviewer ?importer ?compliance_reviewer)
        (importer_permit_requirement ?importer ?permit_record)
        (permit_reserved ?permit_record)
        (not
          (importer_ready_for_submission ?importer)
        )
      )
    :effect
      (and
        (importer_ready_for_submission ?importer)
        (importer_classification_confirmed ?importer)
      )
  )
  (:action attach_supporting_document_for_importer
    :parameters (?importer - export_segment_importer ?permit_record - permit_record ?supporting_document - supporting_document)
    :precondition
      (and
        (classification_validated ?importer)
        (importer_permit_requirement ?importer ?permit_record)
        (supporting_document_available ?supporting_document)
        (not
          (importer_ready_for_submission ?importer)
        )
      )
    :effect
      (and
        (permit_document_attached ?permit_record)
        (importer_ready_for_submission ?importer)
        (importer_attached_document ?importer ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_importer_permit
    :parameters (?importer - export_segment_importer ?permit_record - permit_record ?regulatory_source - regulatory_source ?supporting_document - supporting_document)
    :precondition
      (and
        (classification_validated ?importer)
        (bound_to_regulatory_source ?importer ?regulatory_source)
        (importer_permit_requirement ?importer ?permit_record)
        (permit_document_attached ?permit_record)
        (importer_attached_document ?importer ?supporting_document)
        (not
          (importer_classification_confirmed ?importer)
        )
      )
    :effect
      (and
        (permit_reserved ?permit_record)
        (importer_classification_confirmed ?importer)
        (supporting_document_available ?supporting_document)
        (not
          (importer_attached_document ?importer ?supporting_document)
        )
      )
  )
  (:action assemble_submission_record
    :parameters (?exporter - exporter ?importer - export_segment_importer ?classification_record - classification_record ?permit_record - permit_record ?submission_record - submission_record)
    :precondition
      (and
        (exporter_ready_for_submission ?exporter)
        (importer_ready_for_submission ?importer)
        (exporter_classification_assigned ?exporter ?classification_record)
        (importer_permit_requirement ?importer ?permit_record)
        (classification_reserved ?classification_record)
        (permit_reserved ?permit_record)
        (exporter_classification_confirmed ?exporter)
        (importer_classification_confirmed ?importer)
        (submission_slot_available ?submission_record)
      )
    :effect
      (and
        (submission_assembled ?submission_record)
        (submission_includes_classification ?submission_record ?classification_record)
        (submission_includes_permit ?submission_record ?permit_record)
        (not
          (submission_slot_available ?submission_record)
        )
      )
  )
  (:action prepare_submission_with_certificate
    :parameters (?exporter - exporter ?importer - export_segment_importer ?classification_record - classification_record ?permit_record - permit_record ?submission_record - submission_record)
    :precondition
      (and
        (exporter_ready_for_submission ?exporter)
        (importer_ready_for_submission ?importer)
        (exporter_classification_assigned ?exporter ?classification_record)
        (importer_permit_requirement ?importer ?permit_record)
        (classification_document_attached ?classification_record)
        (permit_reserved ?permit_record)
        (not
          (exporter_classification_confirmed ?exporter)
        )
        (importer_classification_confirmed ?importer)
        (submission_slot_available ?submission_record)
      )
    :effect
      (and
        (submission_assembled ?submission_record)
        (submission_includes_classification ?submission_record ?classification_record)
        (submission_includes_permit ?submission_record ?permit_record)
        (submission_includes_certificate ?submission_record)
        (not
          (submission_slot_available ?submission_record)
        )
      )
  )
  (:action prepare_submission_with_insurance
    :parameters (?exporter - exporter ?importer - export_segment_importer ?classification_record - classification_record ?permit_record - permit_record ?submission_record - submission_record)
    :precondition
      (and
        (exporter_ready_for_submission ?exporter)
        (importer_ready_for_submission ?importer)
        (exporter_classification_assigned ?exporter ?classification_record)
        (importer_permit_requirement ?importer ?permit_record)
        (classification_reserved ?classification_record)
        (permit_document_attached ?permit_record)
        (exporter_classification_confirmed ?exporter)
        (not
          (importer_classification_confirmed ?importer)
        )
        (submission_slot_available ?submission_record)
      )
    :effect
      (and
        (submission_assembled ?submission_record)
        (submission_includes_classification ?submission_record ?classification_record)
        (submission_includes_permit ?submission_record ?permit_record)
        (submission_includes_insurance ?submission_record)
        (not
          (submission_slot_available ?submission_record)
        )
      )
  )
  (:action prepare_submission_with_certificate_and_insurance
    :parameters (?exporter - exporter ?importer - export_segment_importer ?classification_record - classification_record ?permit_record - permit_record ?submission_record - submission_record)
    :precondition
      (and
        (exporter_ready_for_submission ?exporter)
        (importer_ready_for_submission ?importer)
        (exporter_classification_assigned ?exporter ?classification_record)
        (importer_permit_requirement ?importer ?permit_record)
        (classification_document_attached ?classification_record)
        (permit_document_attached ?permit_record)
        (not
          (exporter_classification_confirmed ?exporter)
        )
        (not
          (importer_classification_confirmed ?importer)
        )
        (submission_slot_available ?submission_record)
      )
    :effect
      (and
        (submission_assembled ?submission_record)
        (submission_includes_classification ?submission_record ?classification_record)
        (submission_includes_permit ?submission_record ?permit_record)
        (submission_includes_certificate ?submission_record)
        (submission_includes_insurance ?submission_record)
        (not
          (submission_slot_available ?submission_record)
        )
      )
  )
  (:action validate_submission_qc
    :parameters (?submission_record - submission_record ?exporter - exporter ?regulatory_source - regulatory_source)
    :precondition
      (and
        (submission_assembled ?submission_record)
        (exporter_ready_for_submission ?exporter)
        (bound_to_regulatory_source ?exporter ?regulatory_source)
        (not
          (submission_qc_passed ?submission_record)
        )
      )
    :effect (submission_qc_passed ?submission_record)
  )
  (:action commit_attachment_to_submission
    :parameters (?document_pack - document_pack ?attachment - attachment_artifact ?submission_record - submission_record)
    :precondition
      (and
        (classification_validated ?document_pack)
        (pack_linked_submission ?document_pack ?submission_record)
        (pack_has_attachment ?document_pack ?attachment)
        (attachment_available ?attachment)
        (submission_assembled ?submission_record)
        (submission_qc_passed ?submission_record)
        (not
          (attachment_committed ?attachment)
        )
      )
    :effect
      (and
        (attachment_committed ?attachment)
        (attachment_linked_submission ?attachment ?submission_record)
        (not
          (attachment_available ?attachment)
        )
      )
  )
  (:action perform_pack_prevalidation
    :parameters (?document_pack - document_pack ?attachment - attachment_artifact ?submission_record - submission_record ?regulatory_source - regulatory_source)
    :precondition
      (and
        (classification_validated ?document_pack)
        (pack_has_attachment ?document_pack ?attachment)
        (attachment_committed ?attachment)
        (attachment_linked_submission ?attachment ?submission_record)
        (bound_to_regulatory_source ?document_pack ?regulatory_source)
        (not
          (submission_includes_certificate ?submission_record)
        )
        (not
          (pack_prevalidation_done ?document_pack)
        )
      )
    :effect (pack_prevalidation_done ?document_pack)
  )
  (:action attach_insurance_to_pack
    :parameters (?document_pack - document_pack ?insurance_policy - insurance_policy)
    :precondition
      (and
        (classification_validated ?document_pack)
        (insurance_policy_available ?insurance_policy)
        (not
          (pack_insurance_attached ?document_pack)
        )
      )
    :effect
      (and
        (pack_insurance_attached ?document_pack)
        (pack_linked_insurance ?document_pack ?insurance_policy)
        (not
          (insurance_policy_available ?insurance_policy)
        )
      )
  )
  (:action verify_pack_attachments_and_insurance
    :parameters (?document_pack - document_pack ?attachment - attachment_artifact ?submission_record - submission_record ?regulatory_source - regulatory_source ?insurance_policy - insurance_policy)
    :precondition
      (and
        (classification_validated ?document_pack)
        (pack_has_attachment ?document_pack ?attachment)
        (attachment_committed ?attachment)
        (attachment_linked_submission ?attachment ?submission_record)
        (bound_to_regulatory_source ?document_pack ?regulatory_source)
        (submission_includes_certificate ?submission_record)
        (pack_insurance_attached ?document_pack)
        (pack_linked_insurance ?document_pack ?insurance_policy)
        (not
          (pack_prevalidation_done ?document_pack)
        )
      )
    :effect
      (and
        (pack_prevalidation_done ?document_pack)
        (pack_review_stage2_complete ?document_pack)
      )
  )
  (:action verify_pack_certification_path_a
    :parameters (?document_pack - document_pack ?certificate_document - certificate_document ?compliance_reviewer - compliance_reviewer ?attachment - attachment_artifact ?submission_record - submission_record)
    :precondition
      (and
        (pack_prevalidation_done ?document_pack)
        (pack_linked_certificate ?document_pack ?certificate_document)
        (case_assigned_reviewer ?document_pack ?compliance_reviewer)
        (pack_has_attachment ?document_pack ?attachment)
        (attachment_linked_submission ?attachment ?submission_record)
        (not
          (submission_includes_insurance ?submission_record)
        )
        (not
          (pack_attachments_verified ?document_pack)
        )
      )
    :effect (pack_attachments_verified ?document_pack)
  )
  (:action verify_pack_certification_path_b
    :parameters (?document_pack - document_pack ?certificate_document - certificate_document ?compliance_reviewer - compliance_reviewer ?attachment - attachment_artifact ?submission_record - submission_record)
    :precondition
      (and
        (pack_prevalidation_done ?document_pack)
        (pack_linked_certificate ?document_pack ?certificate_document)
        (case_assigned_reviewer ?document_pack ?compliance_reviewer)
        (pack_has_attachment ?document_pack ?attachment)
        (attachment_linked_submission ?attachment ?submission_record)
        (submission_includes_insurance ?submission_record)
        (not
          (pack_attachments_verified ?document_pack)
        )
      )
    :effect (pack_attachments_verified ?document_pack)
  )
  (:action initiate_pack_certification
    :parameters (?document_pack - document_pack ?regulatory_approval - regulatory_approval ?attachment - attachment_artifact ?submission_record - submission_record)
    :precondition
      (and
        (pack_attachments_verified ?document_pack)
        (pack_linked_regulatory_approval ?document_pack ?regulatory_approval)
        (pack_has_attachment ?document_pack ?attachment)
        (attachment_linked_submission ?attachment ?submission_record)
        (not
          (submission_includes_certificate ?submission_record)
        )
        (not
          (submission_includes_insurance ?submission_record)
        )
        (not
          (pack_certification_initiated ?document_pack)
        )
      )
    :effect (pack_certification_initiated ?document_pack)
  )
  (:action advance_pack_certification_with_endorsement
    :parameters (?document_pack - document_pack ?regulatory_approval - regulatory_approval ?attachment - attachment_artifact ?submission_record - submission_record)
    :precondition
      (and
        (pack_attachments_verified ?document_pack)
        (pack_linked_regulatory_approval ?document_pack ?regulatory_approval)
        (pack_has_attachment ?document_pack ?attachment)
        (attachment_linked_submission ?attachment ?submission_record)
        (submission_includes_certificate ?submission_record)
        (not
          (submission_includes_insurance ?submission_record)
        )
        (not
          (pack_certification_initiated ?document_pack)
        )
      )
    :effect
      (and
        (pack_certification_initiated ?document_pack)
        (pack_endorsed ?document_pack)
      )
  )
  (:action advance_pack_certification_with_insurance
    :parameters (?document_pack - document_pack ?regulatory_approval - regulatory_approval ?attachment - attachment_artifact ?submission_record - submission_record)
    :precondition
      (and
        (pack_attachments_verified ?document_pack)
        (pack_linked_regulatory_approval ?document_pack ?regulatory_approval)
        (pack_has_attachment ?document_pack ?attachment)
        (attachment_linked_submission ?attachment ?submission_record)
        (not
          (submission_includes_certificate ?submission_record)
        )
        (submission_includes_insurance ?submission_record)
        (not
          (pack_certification_initiated ?document_pack)
        )
      )
    :effect
      (and
        (pack_certification_initiated ?document_pack)
        (pack_endorsed ?document_pack)
      )
  )
  (:action complete_pack_certification
    :parameters (?document_pack - document_pack ?regulatory_approval - regulatory_approval ?attachment - attachment_artifact ?submission_record - submission_record)
    :precondition
      (and
        (pack_attachments_verified ?document_pack)
        (pack_linked_regulatory_approval ?document_pack ?regulatory_approval)
        (pack_has_attachment ?document_pack ?attachment)
        (attachment_linked_submission ?attachment ?submission_record)
        (submission_includes_certificate ?submission_record)
        (submission_includes_insurance ?submission_record)
        (not
          (pack_certification_initiated ?document_pack)
        )
      )
    :effect
      (and
        (pack_certification_initiated ?document_pack)
        (pack_endorsed ?document_pack)
      )
  )
  (:action finalize_pack_and_mark_approved
    :parameters (?document_pack - document_pack)
    :precondition
      (and
        (pack_certification_initiated ?document_pack)
        (not
          (pack_endorsed ?document_pack)
        )
        (not
          (pack_finalization_completed ?document_pack)
        )
      )
    :effect
      (and
        (pack_finalization_completed ?document_pack)
        (approved_for_submission ?document_pack)
      )
  )
  (:action add_payment_evidence_to_pack
    :parameters (?document_pack - document_pack ?payment_evidence - payment_evidence)
    :precondition
      (and
        (pack_certification_initiated ?document_pack)
        (pack_endorsed ?document_pack)
        (payment_evidence_available ?payment_evidence)
      )
    :effect
      (and
        (pack_linked_payment_evidence ?document_pack ?payment_evidence)
        (not
          (payment_evidence_available ?payment_evidence)
        )
      )
  )
  (:action approve_pack_for_submission
    :parameters (?document_pack - document_pack ?exporter - exporter ?importer - export_segment_importer ?regulatory_source - regulatory_source ?payment_evidence - payment_evidence)
    :precondition
      (and
        (pack_certification_initiated ?document_pack)
        (pack_endorsed ?document_pack)
        (pack_linked_payment_evidence ?document_pack ?payment_evidence)
        (pack_linked_exporter ?document_pack ?exporter)
        (pack_linked_importer ?document_pack ?importer)
        (exporter_classification_confirmed ?exporter)
        (importer_classification_confirmed ?importer)
        (bound_to_regulatory_source ?document_pack ?regulatory_source)
        (not
          (pack_final_checks_passed ?document_pack)
        )
      )
    :effect (pack_final_checks_passed ?document_pack)
  )
  (:action finalize_pack_post_approval
    :parameters (?document_pack - document_pack)
    :precondition
      (and
        (pack_certification_initiated ?document_pack)
        (pack_final_checks_passed ?document_pack)
        (not
          (pack_finalization_completed ?document_pack)
        )
      )
    :effect
      (and
        (pack_finalization_completed ?document_pack)
        (approved_for_submission ?document_pack)
      )
  )
  (:action apply_special_authorization_to_pack
    :parameters (?document_pack - document_pack ?special_authorization - special_authorization ?regulatory_source - regulatory_source)
    :precondition
      (and
        (classification_validated ?document_pack)
        (bound_to_regulatory_source ?document_pack ?regulatory_source)
        (special_authorization_available ?special_authorization)
        (pack_has_special_authorization ?document_pack ?special_authorization)
        (not
          (pack_special_authorization_applied ?document_pack)
        )
      )
    :effect
      (and
        (pack_special_authorization_applied ?document_pack)
        (not
          (special_authorization_available ?special_authorization)
        )
      )
  )
  (:action verify_special_authorization
    :parameters (?document_pack - document_pack ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (pack_special_authorization_applied ?document_pack)
        (case_assigned_reviewer ?document_pack ?compliance_reviewer)
        (not
          (pack_special_authorization_verified ?document_pack)
        )
      )
    :effect (pack_special_authorization_verified ?document_pack)
  )
  (:action apply_regulatory_approval_to_pack
    :parameters (?document_pack - document_pack ?regulatory_approval - regulatory_approval)
    :precondition
      (and
        (pack_special_authorization_verified ?document_pack)
        (pack_linked_regulatory_approval ?document_pack ?regulatory_approval)
        (not
          (pack_special_authorization_certified ?document_pack)
        )
      )
    :effect (pack_special_authorization_certified ?document_pack)
  )
  (:action finalize_special_authorization_for_pack
    :parameters (?document_pack - document_pack)
    :precondition
      (and
        (pack_special_authorization_certified ?document_pack)
        (not
          (pack_finalization_completed ?document_pack)
        )
      )
    :effect
      (and
        (pack_finalization_completed ?document_pack)
        (approved_for_submission ?document_pack)
      )
  )
  (:action finalize_export_segment
    :parameters (?exporter - exporter ?submission_record - submission_record)
    :precondition
      (and
        (exporter_ready_for_submission ?exporter)
        (exporter_classification_confirmed ?exporter)
        (submission_assembled ?submission_record)
        (submission_qc_passed ?submission_record)
        (not
          (approved_for_submission ?exporter)
        )
      )
    :effect (approved_for_submission ?exporter)
  )
  (:action finalize_import_segment
    :parameters (?importer - export_segment_importer ?submission_record - submission_record)
    :precondition
      (and
        (importer_ready_for_submission ?importer)
        (importer_classification_confirmed ?importer)
        (submission_assembled ?submission_record)
        (submission_qc_passed ?submission_record)
        (not
          (approved_for_submission ?importer)
        )
      )
    :effect (approved_for_submission ?importer)
  )
  (:action link_permit_application_and_authorize_case
    :parameters (?trade_case - trade_case ?permit_application - permit_application ?regulatory_source - regulatory_source)
    :precondition
      (and
        (approved_for_submission ?trade_case)
        (bound_to_regulatory_source ?trade_case ?regulatory_source)
        (permit_application_available ?permit_application)
        (not
          (case_authorized_for_submission ?trade_case)
        )
      )
    :effect
      (and
        (case_authorized_for_submission ?trade_case)
        (case_linked_permit_application ?trade_case ?permit_application)
        (not
          (permit_application_available ?permit_application)
        )
      )
  )
  (:action finalize_case_export_segment_and_release_broker
    :parameters (?exporter - exporter ?broker - customs_broker ?permit_application - permit_application)
    :precondition
      (and
        (case_authorized_for_submission ?exporter)
        (case_assigned_broker ?exporter ?broker)
        (case_linked_permit_application ?exporter ?permit_application)
        (not
          (ready_for_clearance ?exporter)
        )
      )
    :effect
      (and
        (ready_for_clearance ?exporter)
        (broker_available ?broker)
        (permit_application_available ?permit_application)
      )
  )
  (:action finalize_case_import_segment_and_release_broker
    :parameters (?importer - export_segment_importer ?broker - customs_broker ?permit_application - permit_application)
    :precondition
      (and
        (case_authorized_for_submission ?importer)
        (case_assigned_broker ?importer ?broker)
        (case_linked_permit_application ?importer ?permit_application)
        (not
          (ready_for_clearance ?importer)
        )
      )
    :effect
      (and
        (ready_for_clearance ?importer)
        (broker_available ?broker)
        (permit_application_available ?permit_application)
      )
  )
  (:action finalize_case_pack_segment_and_release_broker
    :parameters (?document_pack - document_pack ?broker - customs_broker ?permit_application - permit_application)
    :precondition
      (and
        (case_authorized_for_submission ?document_pack)
        (case_assigned_broker ?document_pack ?broker)
        (case_linked_permit_application ?document_pack ?permit_application)
        (not
          (ready_for_clearance ?document_pack)
        )
      )
    :effect
      (and
        (ready_for_clearance ?document_pack)
        (broker_available ?broker)
        (permit_application_available ?permit_application)
      )
  )
)

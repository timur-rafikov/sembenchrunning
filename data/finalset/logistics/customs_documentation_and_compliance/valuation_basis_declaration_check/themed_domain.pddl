(define (domain valuation_basis_compliance_workflow)
  (:requirements :strips :typing :negative-preconditions)
  (:types world_object - object compliance_resource - world_object documentation_resource - world_object compliance_artifact - world_object compliance_subject_base - world_object compliance_subject - compliance_subject_base customs_broker_token - compliance_resource classification_reference - compliance_resource permit_document - compliance_resource condition_code - compliance_resource payment_receipt - compliance_resource valuation_basis_record - compliance_resource evidence_document - compliance_resource authority_verification_token - compliance_resource supporting_document - documentation_resource attachment - documentation_resource registry_flag - documentation_resource consignment_valuation_issue - compliance_artifact line_item_valuation_issue - compliance_artifact submission_packet - compliance_artifact shipment_component_group - compliance_subject processing_group - compliance_subject consignment - shipment_component_group line_item - shipment_component_group processing_case - processing_group)

  (:predicates
    (compliance_subject_registered ?compliance_subject_var - compliance_subject)
    (review_ready ?compliance_subject_var - compliance_subject)
    (customs_broker_token_assigned ?compliance_subject_var - compliance_subject)
    (customs_clearance_completed ?compliance_subject_var - compliance_subject)
    (clearance_ready_for_release ?compliance_subject_var - compliance_subject)
    (valuation_basis_approved_for_clearance ?compliance_subject_var - compliance_subject)
    (customs_broker_token_available ?customs_broker_token_var - customs_broker_token)
    (customs_broker_token_assignment ?compliance_subject_var - compliance_subject ?customs_broker_token_var - customs_broker_token)
    (classification_reference_available ?classification_reference_var - classification_reference)
    (classification_reference_link ?compliance_subject_var - compliance_subject ?classification_reference_var - classification_reference)
    (permit_document_available ?permit_document_var - permit_document)
    (permit_document_link ?compliance_subject_var - compliance_subject ?permit_document_var - permit_document)
    (supporting_document_available ?supporting_document_var - supporting_document)
    (consignment_supporting_document_link ?consignment_var - consignment ?supporting_document_var - supporting_document)
    (line_item_supporting_document_link ?line_item_var - line_item ?supporting_document_var - supporting_document)
    (consignment_issue_link ?consignment_var - consignment ?consignment_issue_var - consignment_valuation_issue)
    (consignment_issue_flagged ?consignment_issue_var - consignment_valuation_issue)
    (consignment_issue_documented ?consignment_issue_var - consignment_valuation_issue)
    (consignment_review_complete ?consignment_var - consignment)
    (line_item_issue_link ?line_item_var - line_item ?line_item_issue_var - line_item_valuation_issue)
    (line_item_issue_flagged ?line_item_issue_var - line_item_valuation_issue)
    (line_item_issue_documented ?line_item_issue_var - line_item_valuation_issue)
    (line_item_review_complete ?line_item_var - line_item)
    (submission_packet_available ?submission_packet_var - submission_packet)
    (submission_packet_composed ?submission_packet_var - submission_packet)
    (submission_packet_consignment_issue_link ?submission_packet_var - submission_packet ?consignment_issue_var - consignment_valuation_issue)
    (submission_packet_line_item_issue_link ?submission_packet_var - submission_packet ?line_item_issue_var - line_item_valuation_issue)
    (consignment_issue_support_attached ?submission_packet_var - submission_packet)
    (line_item_issue_support_attached ?submission_packet_var - submission_packet)
    (submission_packet_finalized ?submission_packet_var - submission_packet)
    (case_consignment_link ?processing_case_var - processing_case ?consignment_var - consignment)
    (case_line_item_link ?processing_case_var - processing_case ?line_item_var - line_item)
    (case_submission_packet_link ?processing_case_var - processing_case ?submission_packet_var - submission_packet)
    (attachment_available ?attachment_var - attachment)
    (case_attachment_link ?processing_case_var - processing_case ?attachment_var - attachment)
    (attachment_integrated ?attachment_var - attachment)
    (attachment_packet_link ?attachment_var - attachment ?submission_packet_var - submission_packet)
    (case_document_bundle_ready ?processing_case_var - processing_case)
    (case_evidence_recorded ?processing_case_var - processing_case)
    (case_verification_progressed ?processing_case_var - processing_case)
    (condition_code_applied ?processing_case_var - processing_case)
    (condition_code_validated ?processing_case_var - processing_case)
    (case_reconciliation_complete ?processing_case_var - processing_case)
    (case_clearance_ready ?processing_case_var - processing_case)
    (registry_flag_available ?registry_flag_var - registry_flag)
    (case_registry_flag_link ?processing_case_var - processing_case ?registry_flag_var - registry_flag)
    (registry_crosscheck_complete ?processing_case_var - processing_case)
    (permit_crosscheck_complete ?processing_case_var - processing_case)
    (authority_crosscheck_complete ?processing_case_var - processing_case)
    (condition_code_available ?condition_code_var - condition_code)
    (case_condition_code_link ?processing_case_var - processing_case ?condition_code_var - condition_code)
    (payment_receipt_available ?payment_receipt_var - payment_receipt)
    (case_payment_receipt_link ?processing_case_var - processing_case ?payment_receipt_var - payment_receipt)
    (evidence_document_available ?evidence_document_var - evidence_document)
    (case_evidence_document_link ?processing_case_var - processing_case ?evidence_document_var - evidence_document)
    (authority_verification_token_available ?authority_verification_token_var - authority_verification_token)
    (case_authority_verification_token_link ?processing_case_var - processing_case ?authority_verification_token_var - authority_verification_token)
    (valuation_basis_record_available ?valuation_basis_record_var - valuation_basis_record)
    (valuation_basis_record_link ?compliance_subject_var - compliance_subject ?valuation_basis_record_var - valuation_basis_record)
    (consignment_document_reviewed ?consignment_var - consignment)
    (line_item_document_reviewed ?line_item_var - line_item)
    (case_endorsed ?processing_case_var - processing_case)
  )
  (:action register_compliance_subject
    :parameters (?compliance_subject_var - compliance_subject)
    :precondition
      (and
        (not
          (compliance_subject_registered ?compliance_subject_var)
        )
        (not
          (customs_clearance_completed ?compliance_subject_var)
        )
      )
    :effect (compliance_subject_registered ?compliance_subject_var)
  )
  (:action assign_customs_broker_token
    :parameters (?compliance_subject_var - compliance_subject ?customs_broker_token_var - customs_broker_token)
    :precondition
      (and
        (compliance_subject_registered ?compliance_subject_var)
        (not
          (customs_broker_token_assigned ?compliance_subject_var)
        )
        (customs_broker_token_available ?customs_broker_token_var)
      )
    :effect
      (and
        (customs_broker_token_assigned ?compliance_subject_var)
        (customs_broker_token_assignment ?compliance_subject_var ?customs_broker_token_var)
        (not
          (customs_broker_token_available ?customs_broker_token_var)
        )
      )
  )
  (:action attach_classification_reference
    :parameters (?compliance_subject_var - compliance_subject ?classification_reference_var - classification_reference)
    :precondition
      (and
        (compliance_subject_registered ?compliance_subject_var)
        (customs_broker_token_assigned ?compliance_subject_var)
        (classification_reference_available ?classification_reference_var)
      )
    :effect
      (and
        (classification_reference_link ?compliance_subject_var ?classification_reference_var)
        (not
          (classification_reference_available ?classification_reference_var)
        )
      )
  )
  (:action validate_classification_reference
    :parameters (?compliance_subject_var - compliance_subject ?classification_reference_var - classification_reference)
    :precondition
      (and
        (compliance_subject_registered ?compliance_subject_var)
        (customs_broker_token_assigned ?compliance_subject_var)
        (classification_reference_link ?compliance_subject_var ?classification_reference_var)
        (not
          (review_ready ?compliance_subject_var)
        )
      )
    :effect (review_ready ?compliance_subject_var)
  )
  (:action retract_classification_reference
    :parameters (?compliance_subject_var - compliance_subject ?classification_reference_var - classification_reference)
    :precondition
      (and
        (classification_reference_link ?compliance_subject_var ?classification_reference_var)
      )
    :effect
      (and
        (classification_reference_available ?classification_reference_var)
        (not
          (classification_reference_link ?compliance_subject_var ?classification_reference_var)
        )
      )
  )
  (:action attach_permit_document
    :parameters (?compliance_subject_var - compliance_subject ?permit_document_var - permit_document)
    :precondition
      (and
        (review_ready ?compliance_subject_var)
        (permit_document_available ?permit_document_var)
      )
    :effect
      (and
        (permit_document_link ?compliance_subject_var ?permit_document_var)
        (not
          (permit_document_available ?permit_document_var)
        )
      )
  )
  (:action release_permit_document
    :parameters (?compliance_subject_var - compliance_subject ?permit_document_var - permit_document)
    :precondition
      (and
        (permit_document_link ?compliance_subject_var ?permit_document_var)
      )
    :effect
      (and
        (permit_document_available ?permit_document_var)
        (not
          (permit_document_link ?compliance_subject_var ?permit_document_var)
        )
      )
  )
  (:action attach_evidence_document
    :parameters (?processing_case_var - processing_case ?evidence_document_var - evidence_document)
    :precondition
      (and
        (review_ready ?processing_case_var)
        (evidence_document_available ?evidence_document_var)
      )
    :effect
      (and
        (case_evidence_document_link ?processing_case_var ?evidence_document_var)
        (not
          (evidence_document_available ?evidence_document_var)
        )
      )
  )
  (:action release_evidence_document
    :parameters (?processing_case_var - processing_case ?evidence_document_var - evidence_document)
    :precondition
      (and
        (case_evidence_document_link ?processing_case_var ?evidence_document_var)
      )
    :effect
      (and
        (evidence_document_available ?evidence_document_var)
        (not
          (case_evidence_document_link ?processing_case_var ?evidence_document_var)
        )
      )
  )
  (:action attach_authority_verification_token
    :parameters (?processing_case_var - processing_case ?authority_verification_token_var - authority_verification_token)
    :precondition
      (and
        (review_ready ?processing_case_var)
        (authority_verification_token_available ?authority_verification_token_var)
      )
    :effect
      (and
        (case_authority_verification_token_link ?processing_case_var ?authority_verification_token_var)
        (not
          (authority_verification_token_available ?authority_verification_token_var)
        )
      )
  )
  (:action release_authority_verification_token
    :parameters (?processing_case_var - processing_case ?authority_verification_token_var - authority_verification_token)
    :precondition
      (and
        (case_authority_verification_token_link ?processing_case_var ?authority_verification_token_var)
      )
    :effect
      (and
        (authority_verification_token_available ?authority_verification_token_var)
        (not
          (case_authority_verification_token_link ?processing_case_var ?authority_verification_token_var)
        )
      )
  )
  (:action flag_consignment_valuation_issue
    :parameters (?consignment_var - consignment ?consignment_issue_var - consignment_valuation_issue ?classification_reference_var - classification_reference)
    :precondition
      (and
        (review_ready ?consignment_var)
        (classification_reference_link ?consignment_var ?classification_reference_var)
        (consignment_issue_link ?consignment_var ?consignment_issue_var)
        (not
          (consignment_issue_flagged ?consignment_issue_var)
        )
        (not
          (consignment_issue_documented ?consignment_issue_var)
        )
      )
    :effect (consignment_issue_flagged ?consignment_issue_var)
  )
  (:action confirm_consignment_review
    :parameters (?consignment_var - consignment ?consignment_issue_var - consignment_valuation_issue ?permit_document_var - permit_document)
    :precondition
      (and
        (review_ready ?consignment_var)
        (permit_document_link ?consignment_var ?permit_document_var)
        (consignment_issue_link ?consignment_var ?consignment_issue_var)
        (consignment_issue_flagged ?consignment_issue_var)
        (not
          (consignment_document_reviewed ?consignment_var)
        )
      )
    :effect
      (and
        (consignment_document_reviewed ?consignment_var)
        (consignment_review_complete ?consignment_var)
      )
  )
  (:action attach_consignment_support_document
    :parameters (?consignment_var - consignment ?consignment_issue_var - consignment_valuation_issue ?supporting_document_var - supporting_document)
    :precondition
      (and
        (review_ready ?consignment_var)
        (consignment_issue_link ?consignment_var ?consignment_issue_var)
        (supporting_document_available ?supporting_document_var)
        (not
          (consignment_document_reviewed ?consignment_var)
        )
      )
    :effect
      (and
        (consignment_issue_documented ?consignment_issue_var)
        (consignment_document_reviewed ?consignment_var)
        (consignment_supporting_document_link ?consignment_var ?supporting_document_var)
        (not
          (supporting_document_available ?supporting_document_var)
        )
      )
  )
  (:action reconcile_consignment_review
    :parameters (?consignment_var - consignment ?consignment_issue_var - consignment_valuation_issue ?classification_reference_var - classification_reference ?supporting_document_var - supporting_document)
    :precondition
      (and
        (review_ready ?consignment_var)
        (classification_reference_link ?consignment_var ?classification_reference_var)
        (consignment_issue_link ?consignment_var ?consignment_issue_var)
        (consignment_issue_documented ?consignment_issue_var)
        (consignment_supporting_document_link ?consignment_var ?supporting_document_var)
        (not
          (consignment_review_complete ?consignment_var)
        )
      )
    :effect
      (and
        (consignment_issue_flagged ?consignment_issue_var)
        (consignment_review_complete ?consignment_var)
        (supporting_document_available ?supporting_document_var)
        (not
          (consignment_supporting_document_link ?consignment_var ?supporting_document_var)
        )
      )
  )
  (:action flag_line_item_valuation_issue
    :parameters (?line_item_var - line_item ?line_item_issue_var - line_item_valuation_issue ?classification_reference_var - classification_reference)
    :precondition
      (and
        (review_ready ?line_item_var)
        (classification_reference_link ?line_item_var ?classification_reference_var)
        (line_item_issue_link ?line_item_var ?line_item_issue_var)
        (not
          (line_item_issue_flagged ?line_item_issue_var)
        )
        (not
          (line_item_issue_documented ?line_item_issue_var)
        )
      )
    :effect (line_item_issue_flagged ?line_item_issue_var)
  )
  (:action confirm_line_item_review
    :parameters (?line_item_var - line_item ?line_item_issue_var - line_item_valuation_issue ?permit_document_var - permit_document)
    :precondition
      (and
        (review_ready ?line_item_var)
        (permit_document_link ?line_item_var ?permit_document_var)
        (line_item_issue_link ?line_item_var ?line_item_issue_var)
        (line_item_issue_flagged ?line_item_issue_var)
        (not
          (line_item_document_reviewed ?line_item_var)
        )
      )
    :effect
      (and
        (line_item_document_reviewed ?line_item_var)
        (line_item_review_complete ?line_item_var)
      )
  )
  (:action attach_line_item_support_document
    :parameters (?line_item_var - line_item ?line_item_issue_var - line_item_valuation_issue ?supporting_document_var - supporting_document)
    :precondition
      (and
        (review_ready ?line_item_var)
        (line_item_issue_link ?line_item_var ?line_item_issue_var)
        (supporting_document_available ?supporting_document_var)
        (not
          (line_item_document_reviewed ?line_item_var)
        )
      )
    :effect
      (and
        (line_item_issue_documented ?line_item_issue_var)
        (line_item_document_reviewed ?line_item_var)
        (line_item_supporting_document_link ?line_item_var ?supporting_document_var)
        (not
          (supporting_document_available ?supporting_document_var)
        )
      )
  )
  (:action reconcile_line_item_review
    :parameters (?line_item_var - line_item ?line_item_issue_var - line_item_valuation_issue ?classification_reference_var - classification_reference ?supporting_document_var - supporting_document)
    :precondition
      (and
        (review_ready ?line_item_var)
        (classification_reference_link ?line_item_var ?classification_reference_var)
        (line_item_issue_link ?line_item_var ?line_item_issue_var)
        (line_item_issue_documented ?line_item_issue_var)
        (line_item_supporting_document_link ?line_item_var ?supporting_document_var)
        (not
          (line_item_review_complete ?line_item_var)
        )
      )
    :effect
      (and
        (line_item_issue_flagged ?line_item_issue_var)
        (line_item_review_complete ?line_item_var)
        (supporting_document_available ?supporting_document_var)
        (not
          (line_item_supporting_document_link ?line_item_var ?supporting_document_var)
        )
      )
  )
  (:action compose_submission_packet_baseline
    :parameters (?consignment_var - consignment ?line_item_var - line_item ?consignment_issue_var - consignment_valuation_issue ?line_item_issue_var - line_item_valuation_issue ?submission_packet_var - submission_packet)
    :precondition
      (and
        (consignment_document_reviewed ?consignment_var)
        (line_item_document_reviewed ?line_item_var)
        (consignment_issue_link ?consignment_var ?consignment_issue_var)
        (line_item_issue_link ?line_item_var ?line_item_issue_var)
        (consignment_issue_flagged ?consignment_issue_var)
        (line_item_issue_flagged ?line_item_issue_var)
        (consignment_review_complete ?consignment_var)
        (line_item_review_complete ?line_item_var)
        (submission_packet_available ?submission_packet_var)
      )
    :effect
      (and
        (submission_packet_composed ?submission_packet_var)
        (submission_packet_consignment_issue_link ?submission_packet_var ?consignment_issue_var)
        (submission_packet_line_item_issue_link ?submission_packet_var ?line_item_issue_var)
        (not
          (submission_packet_available ?submission_packet_var)
        )
      )
  )
  (:action compose_submission_packet_with_consignment_support
    :parameters (?consignment_var - consignment ?line_item_var - line_item ?consignment_issue_var - consignment_valuation_issue ?line_item_issue_var - line_item_valuation_issue ?submission_packet_var - submission_packet)
    :precondition
      (and
        (consignment_document_reviewed ?consignment_var)
        (line_item_document_reviewed ?line_item_var)
        (consignment_issue_link ?consignment_var ?consignment_issue_var)
        (line_item_issue_link ?line_item_var ?line_item_issue_var)
        (consignment_issue_documented ?consignment_issue_var)
        (line_item_issue_flagged ?line_item_issue_var)
        (not
          (consignment_review_complete ?consignment_var)
        )
        (line_item_review_complete ?line_item_var)
        (submission_packet_available ?submission_packet_var)
      )
    :effect
      (and
        (submission_packet_composed ?submission_packet_var)
        (submission_packet_consignment_issue_link ?submission_packet_var ?consignment_issue_var)
        (submission_packet_line_item_issue_link ?submission_packet_var ?line_item_issue_var)
        (consignment_issue_support_attached ?submission_packet_var)
        (not
          (submission_packet_available ?submission_packet_var)
        )
      )
  )
  (:action compose_submission_packet_with_line_item_support
    :parameters (?consignment_var - consignment ?line_item_var - line_item ?consignment_issue_var - consignment_valuation_issue ?line_item_issue_var - line_item_valuation_issue ?submission_packet_var - submission_packet)
    :precondition
      (and
        (consignment_document_reviewed ?consignment_var)
        (line_item_document_reviewed ?line_item_var)
        (consignment_issue_link ?consignment_var ?consignment_issue_var)
        (line_item_issue_link ?line_item_var ?line_item_issue_var)
        (consignment_issue_flagged ?consignment_issue_var)
        (line_item_issue_documented ?line_item_issue_var)
        (consignment_review_complete ?consignment_var)
        (not
          (line_item_review_complete ?line_item_var)
        )
        (submission_packet_available ?submission_packet_var)
      )
    :effect
      (and
        (submission_packet_composed ?submission_packet_var)
        (submission_packet_consignment_issue_link ?submission_packet_var ?consignment_issue_var)
        (submission_packet_line_item_issue_link ?submission_packet_var ?line_item_issue_var)
        (line_item_issue_support_attached ?submission_packet_var)
        (not
          (submission_packet_available ?submission_packet_var)
        )
      )
  )
  (:action compose_submission_packet_with_full_support
    :parameters (?consignment_var - consignment ?line_item_var - line_item ?consignment_issue_var - consignment_valuation_issue ?line_item_issue_var - line_item_valuation_issue ?submission_packet_var - submission_packet)
    :precondition
      (and
        (consignment_document_reviewed ?consignment_var)
        (line_item_document_reviewed ?line_item_var)
        (consignment_issue_link ?consignment_var ?consignment_issue_var)
        (line_item_issue_link ?line_item_var ?line_item_issue_var)
        (consignment_issue_documented ?consignment_issue_var)
        (line_item_issue_documented ?line_item_issue_var)
        (not
          (consignment_review_complete ?consignment_var)
        )
        (not
          (line_item_review_complete ?line_item_var)
        )
        (submission_packet_available ?submission_packet_var)
      )
    :effect
      (and
        (submission_packet_composed ?submission_packet_var)
        (submission_packet_consignment_issue_link ?submission_packet_var ?consignment_issue_var)
        (submission_packet_line_item_issue_link ?submission_packet_var ?line_item_issue_var)
        (consignment_issue_support_attached ?submission_packet_var)
        (line_item_issue_support_attached ?submission_packet_var)
        (not
          (submission_packet_available ?submission_packet_var)
        )
      )
  )
  (:action finalize_submission_packet
    :parameters (?submission_packet_var - submission_packet ?consignment_var - consignment ?classification_reference_var - classification_reference)
    :precondition
      (and
        (submission_packet_composed ?submission_packet_var)
        (consignment_document_reviewed ?consignment_var)
        (classification_reference_link ?consignment_var ?classification_reference_var)
        (not
          (submission_packet_finalized ?submission_packet_var)
        )
      )
    :effect (submission_packet_finalized ?submission_packet_var)
  )
  (:action stage_attachment_for_case_review
    :parameters (?processing_case_var - processing_case ?attachment_var - attachment ?submission_packet_var - submission_packet)
    :precondition
      (and
        (review_ready ?processing_case_var)
        (case_submission_packet_link ?processing_case_var ?submission_packet_var)
        (case_attachment_link ?processing_case_var ?attachment_var)
        (attachment_available ?attachment_var)
        (submission_packet_composed ?submission_packet_var)
        (submission_packet_finalized ?submission_packet_var)
        (not
          (attachment_integrated ?attachment_var)
        )
      )
    :effect
      (and
        (attachment_integrated ?attachment_var)
        (attachment_packet_link ?attachment_var ?submission_packet_var)
        (not
          (attachment_available ?attachment_var)
        )
      )
  )
  (:action confirm_case_attachment_bundle
    :parameters (?processing_case_var - processing_case ?attachment_var - attachment ?submission_packet_var - submission_packet ?classification_reference_var - classification_reference)
    :precondition
      (and
        (review_ready ?processing_case_var)
        (case_attachment_link ?processing_case_var ?attachment_var)
        (attachment_integrated ?attachment_var)
        (attachment_packet_link ?attachment_var ?submission_packet_var)
        (classification_reference_link ?processing_case_var ?classification_reference_var)
        (not
          (consignment_issue_support_attached ?submission_packet_var)
        )
        (not
          (case_document_bundle_ready ?processing_case_var)
        )
      )
    :effect (case_document_bundle_ready ?processing_case_var)
  )
  (:action apply_condition_code
    :parameters (?processing_case_var - processing_case ?condition_code_var - condition_code)
    :precondition
      (and
        (review_ready ?processing_case_var)
        (condition_code_available ?condition_code_var)
        (not
          (condition_code_applied ?processing_case_var)
        )
      )
    :effect
      (and
        (condition_code_applied ?processing_case_var)
        (case_condition_code_link ?processing_case_var ?condition_code_var)
        (not
          (condition_code_available ?condition_code_var)
        )
      )
  )
  (:action validate_condition_code
    :parameters (?processing_case_var - processing_case ?attachment_var - attachment ?submission_packet_var - submission_packet ?classification_reference_var - classification_reference ?condition_code_var - condition_code)
    :precondition
      (and
        (review_ready ?processing_case_var)
        (case_attachment_link ?processing_case_var ?attachment_var)
        (attachment_integrated ?attachment_var)
        (attachment_packet_link ?attachment_var ?submission_packet_var)
        (classification_reference_link ?processing_case_var ?classification_reference_var)
        (consignment_issue_support_attached ?submission_packet_var)
        (condition_code_applied ?processing_case_var)
        (case_condition_code_link ?processing_case_var ?condition_code_var)
        (not
          (case_document_bundle_ready ?processing_case_var)
        )
      )
    :effect
      (and
        (case_document_bundle_ready ?processing_case_var)
        (condition_code_validated ?processing_case_var)
      )
  )
  (:action record_case_evidence
    :parameters (?processing_case_var - processing_case ?evidence_document_var - evidence_document ?permit_document_var - permit_document ?attachment_var - attachment ?submission_packet_var - submission_packet)
    :precondition
      (and
        (case_document_bundle_ready ?processing_case_var)
        (case_evidence_document_link ?processing_case_var ?evidence_document_var)
        (permit_document_link ?processing_case_var ?permit_document_var)
        (case_attachment_link ?processing_case_var ?attachment_var)
        (attachment_packet_link ?attachment_var ?submission_packet_var)
        (not
          (line_item_issue_support_attached ?submission_packet_var)
        )
        (not
          (case_evidence_recorded ?processing_case_var)
        )
      )
    :effect (case_evidence_recorded ?processing_case_var)
  )
  (:action confirm_case_evidence
    :parameters (?processing_case_var - processing_case ?evidence_document_var - evidence_document ?permit_document_var - permit_document ?attachment_var - attachment ?submission_packet_var - submission_packet)
    :precondition
      (and
        (case_document_bundle_ready ?processing_case_var)
        (case_evidence_document_link ?processing_case_var ?evidence_document_var)
        (permit_document_link ?processing_case_var ?permit_document_var)
        (case_attachment_link ?processing_case_var ?attachment_var)
        (attachment_packet_link ?attachment_var ?submission_packet_var)
        (line_item_issue_support_attached ?submission_packet_var)
        (not
          (case_evidence_recorded ?processing_case_var)
        )
      )
    :effect (case_evidence_recorded ?processing_case_var)
  )
  (:action progress_case_verification_step_one
    :parameters (?processing_case_var - processing_case ?authority_verification_token_var - authority_verification_token ?attachment_var - attachment ?submission_packet_var - submission_packet)
    :precondition
      (and
        (case_evidence_recorded ?processing_case_var)
        (case_authority_verification_token_link ?processing_case_var ?authority_verification_token_var)
        (case_attachment_link ?processing_case_var ?attachment_var)
        (attachment_packet_link ?attachment_var ?submission_packet_var)
        (not
          (consignment_issue_support_attached ?submission_packet_var)
        )
        (not
          (line_item_issue_support_attached ?submission_packet_var)
        )
        (not
          (case_verification_progressed ?processing_case_var)
        )
      )
    :effect (case_verification_progressed ?processing_case_var)
  )
  (:action progress_case_verification_step_two
    :parameters (?processing_case_var - processing_case ?authority_verification_token_var - authority_verification_token ?attachment_var - attachment ?submission_packet_var - submission_packet)
    :precondition
      (and
        (case_evidence_recorded ?processing_case_var)
        (case_authority_verification_token_link ?processing_case_var ?authority_verification_token_var)
        (case_attachment_link ?processing_case_var ?attachment_var)
        (attachment_packet_link ?attachment_var ?submission_packet_var)
        (consignment_issue_support_attached ?submission_packet_var)
        (not
          (line_item_issue_support_attached ?submission_packet_var)
        )
        (not
          (case_verification_progressed ?processing_case_var)
        )
      )
    :effect
      (and
        (case_verification_progressed ?processing_case_var)
        (case_reconciliation_complete ?processing_case_var)
      )
  )
  (:action progress_case_verification_step_three
    :parameters (?processing_case_var - processing_case ?authority_verification_token_var - authority_verification_token ?attachment_var - attachment ?submission_packet_var - submission_packet)
    :precondition
      (and
        (case_evidence_recorded ?processing_case_var)
        (case_authority_verification_token_link ?processing_case_var ?authority_verification_token_var)
        (case_attachment_link ?processing_case_var ?attachment_var)
        (attachment_packet_link ?attachment_var ?submission_packet_var)
        (not
          (consignment_issue_support_attached ?submission_packet_var)
        )
        (line_item_issue_support_attached ?submission_packet_var)
        (not
          (case_verification_progressed ?processing_case_var)
        )
      )
    :effect
      (and
        (case_verification_progressed ?processing_case_var)
        (case_reconciliation_complete ?processing_case_var)
      )
  )
  (:action progress_case_verification_step_four
    :parameters (?processing_case_var - processing_case ?authority_verification_token_var - authority_verification_token ?attachment_var - attachment ?submission_packet_var - submission_packet)
    :precondition
      (and
        (case_evidence_recorded ?processing_case_var)
        (case_authority_verification_token_link ?processing_case_var ?authority_verification_token_var)
        (case_attachment_link ?processing_case_var ?attachment_var)
        (attachment_packet_link ?attachment_var ?submission_packet_var)
        (consignment_issue_support_attached ?submission_packet_var)
        (line_item_issue_support_attached ?submission_packet_var)
        (not
          (case_verification_progressed ?processing_case_var)
        )
      )
    :effect
      (and
        (case_verification_progressed ?processing_case_var)
        (case_reconciliation_complete ?processing_case_var)
      )
  )
  (:action endorse_case_review
    :parameters (?processing_case_var - processing_case)
    :precondition
      (and
        (case_verification_progressed ?processing_case_var)
        (not
          (case_reconciliation_complete ?processing_case_var)
        )
        (not
          (case_endorsed ?processing_case_var)
        )
      )
    :effect
      (and
        (case_endorsed ?processing_case_var)
        (clearance_ready_for_release ?processing_case_var)
      )
  )
  (:action attach_payment_receipt
    :parameters (?processing_case_var - processing_case ?payment_receipt_var - payment_receipt)
    :precondition
      (and
        (case_verification_progressed ?processing_case_var)
        (case_reconciliation_complete ?processing_case_var)
        (payment_receipt_available ?payment_receipt_var)
      )
    :effect
      (and
        (case_payment_receipt_link ?processing_case_var ?payment_receipt_var)
        (not
          (payment_receipt_available ?payment_receipt_var)
        )
      )
  )
  (:action complete_case_reconciliation
    :parameters (?processing_case_var - processing_case ?consignment_var - consignment ?line_item_var - line_item ?classification_reference_var - classification_reference ?payment_receipt_var - payment_receipt)
    :precondition
      (and
        (case_verification_progressed ?processing_case_var)
        (case_reconciliation_complete ?processing_case_var)
        (case_payment_receipt_link ?processing_case_var ?payment_receipt_var)
        (case_consignment_link ?processing_case_var ?consignment_var)
        (case_line_item_link ?processing_case_var ?line_item_var)
        (consignment_review_complete ?consignment_var)
        (line_item_review_complete ?line_item_var)
        (classification_reference_link ?processing_case_var ?classification_reference_var)
        (not
          (case_clearance_ready ?processing_case_var)
        )
      )
    :effect (case_clearance_ready ?processing_case_var)
  )
  (:action finalize_case_endorsement
    :parameters (?processing_case_var - processing_case)
    :precondition
      (and
        (case_verification_progressed ?processing_case_var)
        (case_clearance_ready ?processing_case_var)
        (not
          (case_endorsed ?processing_case_var)
        )
      )
    :effect
      (and
        (case_endorsed ?processing_case_var)
        (clearance_ready_for_release ?processing_case_var)
      )
  )
  (:action register_registry_flag
    :parameters (?processing_case_var - processing_case ?registry_flag_var - registry_flag ?classification_reference_var - classification_reference)
    :precondition
      (and
        (review_ready ?processing_case_var)
        (classification_reference_link ?processing_case_var ?classification_reference_var)
        (registry_flag_available ?registry_flag_var)
        (case_registry_flag_link ?processing_case_var ?registry_flag_var)
        (not
          (registry_crosscheck_complete ?processing_case_var)
        )
      )
    :effect
      (and
        (registry_crosscheck_complete ?processing_case_var)
        (not
          (registry_flag_available ?registry_flag_var)
        )
      )
  )
  (:action confirm_permit_crosscheck
    :parameters (?processing_case_var - processing_case ?permit_document_var - permit_document)
    :precondition
      (and
        (registry_crosscheck_complete ?processing_case_var)
        (permit_document_link ?processing_case_var ?permit_document_var)
        (not
          (permit_crosscheck_complete ?processing_case_var)
        )
      )
    :effect (permit_crosscheck_complete ?processing_case_var)
  )
  (:action confirm_authority_crosscheck
    :parameters (?processing_case_var - processing_case ?authority_verification_token_var - authority_verification_token)
    :precondition
      (and
        (permit_crosscheck_complete ?processing_case_var)
        (case_authority_verification_token_link ?processing_case_var ?authority_verification_token_var)
        (not
          (authority_crosscheck_complete ?processing_case_var)
        )
      )
    :effect (authority_crosscheck_complete ?processing_case_var)
  )
  (:action issue_case_endorsement
    :parameters (?processing_case_var - processing_case)
    :precondition
      (and
        (authority_crosscheck_complete ?processing_case_var)
        (not
          (case_endorsed ?processing_case_var)
        )
      )
    :effect
      (and
        (case_endorsed ?processing_case_var)
        (clearance_ready_for_release ?processing_case_var)
      )
  )
  (:action endorse_consignment_clearance
    :parameters (?consignment_var - consignment ?submission_packet_var - submission_packet)
    :precondition
      (and
        (consignment_document_reviewed ?consignment_var)
        (consignment_review_complete ?consignment_var)
        (submission_packet_composed ?submission_packet_var)
        (submission_packet_finalized ?submission_packet_var)
        (not
          (clearance_ready_for_release ?consignment_var)
        )
      )
    :effect (clearance_ready_for_release ?consignment_var)
  )
  (:action endorse_line_item_clearance
    :parameters (?line_item_var - line_item ?submission_packet_var - submission_packet)
    :precondition
      (and
        (line_item_document_reviewed ?line_item_var)
        (line_item_review_complete ?line_item_var)
        (submission_packet_composed ?submission_packet_var)
        (submission_packet_finalized ?submission_packet_var)
        (not
          (clearance_ready_for_release ?line_item_var)
        )
      )
    :effect (clearance_ready_for_release ?line_item_var)
  )
  (:action approve_valuation_basis
    :parameters (?compliance_subject_var - compliance_subject ?valuation_basis_record_var - valuation_basis_record ?classification_reference_var - classification_reference)
    :precondition
      (and
        (clearance_ready_for_release ?compliance_subject_var)
        (classification_reference_link ?compliance_subject_var ?classification_reference_var)
        (valuation_basis_record_available ?valuation_basis_record_var)
        (not
          (valuation_basis_approved_for_clearance ?compliance_subject_var)
        )
      )
    :effect
      (and
        (valuation_basis_approved_for_clearance ?compliance_subject_var)
        (valuation_basis_record_link ?compliance_subject_var ?valuation_basis_record_var)
        (not
          (valuation_basis_record_available ?valuation_basis_record_var)
        )
      )
  )
  (:action grant_clearance_to_consignment
    :parameters (?consignment_var - consignment ?customs_broker_token_var - customs_broker_token ?valuation_basis_record_var - valuation_basis_record)
    :precondition
      (and
        (valuation_basis_approved_for_clearance ?consignment_var)
        (customs_broker_token_assignment ?consignment_var ?customs_broker_token_var)
        (valuation_basis_record_link ?consignment_var ?valuation_basis_record_var)
        (not
          (customs_clearance_completed ?consignment_var)
        )
      )
    :effect
      (and
        (customs_clearance_completed ?consignment_var)
        (customs_broker_token_available ?customs_broker_token_var)
        (valuation_basis_record_available ?valuation_basis_record_var)
      )
  )
  (:action grant_clearance_to_line_item
    :parameters (?line_item_var - line_item ?customs_broker_token_var - customs_broker_token ?valuation_basis_record_var - valuation_basis_record)
    :precondition
      (and
        (valuation_basis_approved_for_clearance ?line_item_var)
        (customs_broker_token_assignment ?line_item_var ?customs_broker_token_var)
        (valuation_basis_record_link ?line_item_var ?valuation_basis_record_var)
        (not
          (customs_clearance_completed ?line_item_var)
        )
      )
    :effect
      (and
        (customs_clearance_completed ?line_item_var)
        (customs_broker_token_available ?customs_broker_token_var)
        (valuation_basis_record_available ?valuation_basis_record_var)
      )
  )
  (:action grant_clearance_to_processing_case
    :parameters (?processing_case_var - processing_case ?customs_broker_token_var - customs_broker_token ?valuation_basis_record_var - valuation_basis_record)
    :precondition
      (and
        (valuation_basis_approved_for_clearance ?processing_case_var)
        (customs_broker_token_assignment ?processing_case_var ?customs_broker_token_var)
        (valuation_basis_record_link ?processing_case_var ?valuation_basis_record_var)
        (not
          (customs_clearance_completed ?processing_case_var)
        )
      )
    :effect
      (and
        (customs_clearance_completed ?processing_case_var)
        (customs_broker_token_available ?customs_broker_token_var)
        (valuation_basis_record_available ?valuation_basis_record_var)
      )
  )
)

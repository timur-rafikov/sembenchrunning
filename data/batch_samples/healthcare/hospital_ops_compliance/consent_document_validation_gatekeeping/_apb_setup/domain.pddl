(define (domain hospital_consent_validation)
  (:requirements :strips :typing :negative-preconditions)
  (:types consent_case - object clinical_reviewer - object validation_method - object legal_reviewer - object attending_physician - object clinical_specialist - object document_source - object external_witness - object approval_authority - object clinical_clerk - object supporting_document - object patient_representative - object governance_channel - object ethics_committee_channel - governance_channel risk_committee_channel - governance_channel inpatient_consent_case - consent_case outpatient_consent_case - consent_case)
  (:predicates
    (consent_case_open ?consent_case - consent_case)
    (assigned_reviewer ?consent_case - consent_case ?clinical_reviewer - clinical_reviewer)
    (has_reviewer_assigned ?consent_case - consent_case)
    (initial_verification_completed ?consent_case - consent_case)
    (signatures_verified ?consent_case - consent_case)
    (assigned_attending ?consent_case - consent_case ?attending_physician - attending_physician)
    (assigned_legal_reviewer ?consent_case - consent_case ?legal_reviewer - legal_reviewer)
    (assigned_clinical_specialist ?consent_case - consent_case ?clinical_specialist - clinical_specialist)
    (assigned_patient_representative ?consent_case - consent_case ?patient_representative - patient_representative)
    (applied_validation_method ?consent_case - consent_case ?validation_method - validation_method)
    (validation_result_recorded ?consent_case - consent_case)
    (committee_approval_recorded ?consent_case - consent_case)
    (approval_authority_request_pending ?consent_case - consent_case)
    (case_finalized ?consent_case - consent_case)
    (escalation_required ?consent_case - consent_case)
    (finalization_ready ?consent_case - consent_case)
    (default_approval_authority_for_case ?consent_case - consent_case ?approval_authority - approval_authority)
    (approval_authority_approval_recorded ?consent_case - consent_case ?approval_authority - approval_authority)
    (intake_recorded ?consent_case - consent_case)
    (reviewer_available ?clinical_reviewer - clinical_reviewer)
    (validation_method_available ?validation_method - validation_method)
    (attending_available ?attending_physician - attending_physician)
    (legal_reviewer_available ?legal_reviewer - legal_reviewer)
    (clinical_specialist_available ?clinical_specialist - clinical_specialist)
    (document_source_available ?document_source - document_source)
    (external_witness_available ?external_witness - external_witness)
    (approval_authority_available ?approval_authority - approval_authority)
    (clinical_clerk_available ?clinical_clerk - clinical_clerk)
    (supporting_document_available ?supporting_document - supporting_document)
    (patient_representative_available ?patient_representative - patient_representative)
    (reviewer_eligible ?consent_case - consent_case ?clinical_reviewer - clinical_reviewer)
    (validation_method_applicable ?consent_case - consent_case ?validation_method - validation_method)
    (attending_applicable_to_case ?consent_case - consent_case ?attending_physician - attending_physician)
    (legal_reviewer_applicable ?consent_case - consent_case ?legal_reviewer - legal_reviewer)
    (clinical_specialist_applicable ?consent_case - consent_case ?clinical_specialist - clinical_specialist)
    (supporting_document_applicable ?consent_case - consent_case ?supporting_document - supporting_document)
    (patient_representative_applicable ?consent_case - consent_case ?patient_representative - patient_representative)
    (governance_channel_applicable ?consent_case - consent_case ?governance_channel - governance_channel)
    (approval_authority_linked_to_case ?consent_case - consent_case ?approval_authority - approval_authority)
    (is_inpatient_case ?consent_case - consent_case)
    (is_outpatient_case ?consent_case - consent_case)
    (bound_document_source ?consent_case - consent_case ?document_source - document_source)
    (requires_additional_review ?consent_case - consent_case)
    (approval_authority_applicable ?consent_case - consent_case ?approval_authority - approval_authority)
  )
  (:action open_consent_case
    :parameters (?consent_case - consent_case)
    :precondition
      (and
        (not
          (consent_case_open ?consent_case)
        )
        (not
          (case_finalized ?consent_case)
        )
      )
    :effect
      (and
        (consent_case_open ?consent_case)
      )
  )
  (:action assign_clinical_reviewer
    :parameters (?consent_case - consent_case ?clinical_reviewer - clinical_reviewer)
    :precondition
      (and
        (consent_case_open ?consent_case)
        (reviewer_available ?clinical_reviewer)
        (reviewer_eligible ?consent_case ?clinical_reviewer)
        (not
          (has_reviewer_assigned ?consent_case)
        )
      )
    :effect
      (and
        (assigned_reviewer ?consent_case ?clinical_reviewer)
        (has_reviewer_assigned ?consent_case)
        (not
          (reviewer_available ?clinical_reviewer)
        )
      )
  )
  (:action release_clinical_reviewer
    :parameters (?consent_case - consent_case ?clinical_reviewer - clinical_reviewer)
    :precondition
      (and
        (assigned_reviewer ?consent_case ?clinical_reviewer)
        (not
          (validation_result_recorded ?consent_case)
        )
        (not
          (committee_approval_recorded ?consent_case)
        )
      )
    :effect
      (and
        (not
          (assigned_reviewer ?consent_case ?clinical_reviewer)
        )
        (not
          (has_reviewer_assigned ?consent_case)
        )
        (not
          (initial_verification_completed ?consent_case)
        )
        (not
          (signatures_verified ?consent_case)
        )
        (not
          (escalation_required ?consent_case)
        )
        (not
          (finalization_ready ?consent_case)
        )
        (not
          (requires_additional_review ?consent_case)
        )
        (reviewer_available ?clinical_reviewer)
      )
  )
  (:action bind_document_source
    :parameters (?consent_case - consent_case ?document_source - document_source)
    :precondition
      (and
        (consent_case_open ?consent_case)
        (document_source_available ?document_source)
      )
    :effect
      (and
        (bound_document_source ?consent_case ?document_source)
        (not
          (document_source_available ?document_source)
        )
      )
  )
  (:action unbind_document_source
    :parameters (?consent_case - consent_case ?document_source - document_source)
    :precondition
      (and
        (bound_document_source ?consent_case ?document_source)
      )
    :effect
      (and
        (document_source_available ?document_source)
        (not
          (bound_document_source ?consent_case ?document_source)
        )
      )
  )
  (:action complete_initial_verification_from_source
    :parameters (?consent_case - consent_case ?document_source - document_source)
    :precondition
      (and
        (consent_case_open ?consent_case)
        (has_reviewer_assigned ?consent_case)
        (bound_document_source ?consent_case ?document_source)
        (not
          (initial_verification_completed ?consent_case)
        )
      )
    :effect
      (and
        (initial_verification_completed ?consent_case)
      )
  )
  (:action record_external_witness_verification
    :parameters (?consent_case - consent_case ?external_witness - external_witness)
    :precondition
      (and
        (consent_case_open ?consent_case)
        (has_reviewer_assigned ?consent_case)
        (external_witness_available ?external_witness)
        (not
          (initial_verification_completed ?consent_case)
        )
      )
    :effect
      (and
        (initial_verification_completed ?consent_case)
        (escalation_required ?consent_case)
        (not
          (external_witness_available ?external_witness)
        )
      )
  )
  (:action clerk_verify_signatures
    :parameters (?consent_case - consent_case ?document_source - document_source ?clinical_clerk - clinical_clerk)
    :precondition
      (and
        (initial_verification_completed ?consent_case)
        (has_reviewer_assigned ?consent_case)
        (bound_document_source ?consent_case ?document_source)
        (clinical_clerk_available ?clinical_clerk)
        (not
          (signatures_verified ?consent_case)
        )
      )
    :effect
      (and
        (signatures_verified ?consent_case)
        (not
          (escalation_required ?consent_case)
        )
      )
  )
  (:action clerk_verify_signatures_with_authority
    :parameters (?consent_case - consent_case ?approval_authority - approval_authority)
    :precondition
      (and
        (has_reviewer_assigned ?consent_case)
        (approval_authority_approval_recorded ?consent_case ?approval_authority)
        (not
          (signatures_verified ?consent_case)
        )
      )
    :effect
      (and
        (signatures_verified ?consent_case)
        (not
          (escalation_required ?consent_case)
        )
      )
  )
  (:action assign_attending
    :parameters (?consent_case - consent_case ?attending_physician - attending_physician)
    :precondition
      (and
        (consent_case_open ?consent_case)
        (attending_available ?attending_physician)
        (attending_applicable_to_case ?consent_case ?attending_physician)
      )
    :effect
      (and
        (assigned_attending ?consent_case ?attending_physician)
        (not
          (attending_available ?attending_physician)
        )
      )
  )
  (:action release_attending
    :parameters (?consent_case - consent_case ?attending_physician - attending_physician)
    :precondition
      (and
        (assigned_attending ?consent_case ?attending_physician)
      )
    :effect
      (and
        (attending_available ?attending_physician)
        (not
          (assigned_attending ?consent_case ?attending_physician)
        )
      )
  )
  (:action assign_legal_reviewer
    :parameters (?consent_case - consent_case ?legal_reviewer - legal_reviewer)
    :precondition
      (and
        (consent_case_open ?consent_case)
        (legal_reviewer_available ?legal_reviewer)
        (legal_reviewer_applicable ?consent_case ?legal_reviewer)
      )
    :effect
      (and
        (assigned_legal_reviewer ?consent_case ?legal_reviewer)
        (not
          (legal_reviewer_available ?legal_reviewer)
        )
      )
  )
  (:action release_legal_reviewer
    :parameters (?consent_case - consent_case ?legal_reviewer - legal_reviewer)
    :precondition
      (and
        (assigned_legal_reviewer ?consent_case ?legal_reviewer)
      )
    :effect
      (and
        (legal_reviewer_available ?legal_reviewer)
        (not
          (assigned_legal_reviewer ?consent_case ?legal_reviewer)
        )
      )
  )
  (:action assign_clinical_specialist
    :parameters (?consent_case - consent_case ?clinical_specialist - clinical_specialist)
    :precondition
      (and
        (consent_case_open ?consent_case)
        (clinical_specialist_available ?clinical_specialist)
        (clinical_specialist_applicable ?consent_case ?clinical_specialist)
      )
    :effect
      (and
        (assigned_clinical_specialist ?consent_case ?clinical_specialist)
        (not
          (clinical_specialist_available ?clinical_specialist)
        )
      )
  )
  (:action release_clinical_specialist
    :parameters (?consent_case - consent_case ?clinical_specialist - clinical_specialist)
    :precondition
      (and
        (assigned_clinical_specialist ?consent_case ?clinical_specialist)
      )
    :effect
      (and
        (clinical_specialist_available ?clinical_specialist)
        (not
          (assigned_clinical_specialist ?consent_case ?clinical_specialist)
        )
      )
  )
  (:action assign_patient_representative
    :parameters (?consent_case - consent_case ?patient_representative - patient_representative)
    :precondition
      (and
        (consent_case_open ?consent_case)
        (patient_representative_available ?patient_representative)
        (patient_representative_applicable ?consent_case ?patient_representative)
      )
    :effect
      (and
        (assigned_patient_representative ?consent_case ?patient_representative)
        (not
          (patient_representative_available ?patient_representative)
        )
      )
  )
  (:action release_patient_representative
    :parameters (?consent_case - consent_case ?patient_representative - patient_representative)
    :precondition
      (and
        (assigned_patient_representative ?consent_case ?patient_representative)
      )
    :effect
      (and
        (patient_representative_available ?patient_representative)
        (not
          (assigned_patient_representative ?consent_case ?patient_representative)
        )
      )
  )
  (:action execute_validation_method_clinical_path
    :parameters (?consent_case - consent_case ?validation_method - validation_method ?attending_physician - attending_physician ?legal_reviewer - legal_reviewer)
    :precondition
      (and
        (has_reviewer_assigned ?consent_case)
        (assigned_attending ?consent_case ?attending_physician)
        (assigned_legal_reviewer ?consent_case ?legal_reviewer)
        (validation_method_available ?validation_method)
        (validation_method_applicable ?consent_case ?validation_method)
        (not
          (validation_result_recorded ?consent_case)
        )
      )
    :effect
      (and
        (applied_validation_method ?consent_case ?validation_method)
        (validation_result_recorded ?consent_case)
        (not
          (validation_method_available ?validation_method)
        )
      )
  )
  (:action execute_validation_method_specialist_path
    :parameters (?consent_case - consent_case ?validation_method - validation_method ?clinical_specialist - clinical_specialist ?supporting_document - supporting_document)
    :precondition
      (and
        (has_reviewer_assigned ?consent_case)
        (assigned_clinical_specialist ?consent_case ?clinical_specialist)
        (supporting_document_available ?supporting_document)
        (validation_method_available ?validation_method)
        (validation_method_applicable ?consent_case ?validation_method)
        (supporting_document_applicable ?consent_case ?supporting_document)
        (not
          (validation_result_recorded ?consent_case)
        )
      )
    :effect
      (and
        (applied_validation_method ?consent_case ?validation_method)
        (validation_result_recorded ?consent_case)
        (requires_additional_review ?consent_case)
        (escalation_required ?consent_case)
        (not
          (validation_method_available ?validation_method)
        )
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action consolidate_validation_results
    :parameters (?consent_case - consent_case ?attending_physician - attending_physician ?legal_reviewer - legal_reviewer)
    :precondition
      (and
        (validation_result_recorded ?consent_case)
        (requires_additional_review ?consent_case)
        (assigned_attending ?consent_case ?attending_physician)
        (assigned_legal_reviewer ?consent_case ?legal_reviewer)
      )
    :effect
      (and
        (not
          (requires_additional_review ?consent_case)
        )
        (not
          (escalation_required ?consent_case)
        )
      )
  )
  (:action submit_to_ethics_committee
    :parameters (?consent_case - consent_case ?attending_physician - attending_physician ?legal_reviewer - legal_reviewer ?ethics_committee_channel - ethics_committee_channel)
    :precondition
      (and
        (signatures_verified ?consent_case)
        (validation_result_recorded ?consent_case)
        (assigned_attending ?consent_case ?attending_physician)
        (assigned_legal_reviewer ?consent_case ?legal_reviewer)
        (governance_channel_applicable ?consent_case ?ethics_committee_channel)
        (not
          (escalation_required ?consent_case)
        )
        (not
          (committee_approval_recorded ?consent_case)
        )
      )
    :effect
      (and
        (committee_approval_recorded ?consent_case)
      )
  )
  (:action submit_to_risk_committee
    :parameters (?consent_case - consent_case ?clinical_specialist - clinical_specialist ?patient_representative - patient_representative ?risk_committee_channel - risk_committee_channel)
    :precondition
      (and
        (signatures_verified ?consent_case)
        (validation_result_recorded ?consent_case)
        (assigned_clinical_specialist ?consent_case ?clinical_specialist)
        (assigned_patient_representative ?consent_case ?patient_representative)
        (governance_channel_applicable ?consent_case ?risk_committee_channel)
        (not
          (committee_approval_recorded ?consent_case)
        )
      )
    :effect
      (and
        (committee_approval_recorded ?consent_case)
        (escalation_required ?consent_case)
      )
  )
  (:action record_committee_approval_and_prepare_finalization
    :parameters (?consent_case - consent_case ?attending_physician - attending_physician ?legal_reviewer - legal_reviewer)
    :precondition
      (and
        (committee_approval_recorded ?consent_case)
        (escalation_required ?consent_case)
        (assigned_attending ?consent_case ?attending_physician)
        (assigned_legal_reviewer ?consent_case ?legal_reviewer)
      )
    :effect
      (and
        (finalization_ready ?consent_case)
        (not
          (escalation_required ?consent_case)
        )
        (not
          (signatures_verified ?consent_case)
        )
        (not
          (requires_additional_review ?consent_case)
        )
      )
  )
  (:action perform_clerk_reverification
    :parameters (?consent_case - consent_case ?document_source - document_source ?clinical_clerk - clinical_clerk)
    :precondition
      (and
        (finalization_ready ?consent_case)
        (committee_approval_recorded ?consent_case)
        (has_reviewer_assigned ?consent_case)
        (bound_document_source ?consent_case ?document_source)
        (clinical_clerk_available ?clinical_clerk)
        (not
          (signatures_verified ?consent_case)
        )
      )
    :effect
      (and
        (signatures_verified ?consent_case)
      )
  )
  (:action mark_authority_request_pending_from_source
    :parameters (?consent_case - consent_case ?document_source - document_source)
    :precondition
      (and
        (committee_approval_recorded ?consent_case)
        (signatures_verified ?consent_case)
        (not
          (escalation_required ?consent_case)
        )
        (bound_document_source ?consent_case ?document_source)
        (not
          (approval_authority_request_pending ?consent_case)
        )
      )
    :effect
      (and
        (approval_authority_request_pending ?consent_case)
      )
  )
  (:action request_witness_verification
    :parameters (?consent_case - consent_case ?external_witness - external_witness)
    :precondition
      (and
        (committee_approval_recorded ?consent_case)
        (signatures_verified ?consent_case)
        (not
          (escalation_required ?consent_case)
        )
        (external_witness_available ?external_witness)
        (not
          (approval_authority_request_pending ?consent_case)
        )
      )
    :effect
      (and
        (approval_authority_request_pending ?consent_case)
        (not
          (external_witness_available ?external_witness)
        )
      )
  )
  (:action link_approval_authority_to_case
    :parameters (?consent_case - consent_case ?approval_authority - approval_authority)
    :precondition
      (and
        (approval_authority_request_pending ?consent_case)
        (approval_authority_available ?approval_authority)
        (approval_authority_applicable ?consent_case ?approval_authority)
      )
    :effect
      (and
        (approval_authority_linked_to_case ?consent_case ?approval_authority)
        (not
          (approval_authority_available ?approval_authority)
        )
      )
  )
  (:action propagate_authority_approval
    :parameters (?outpatient_consent_case - outpatient_consent_case ?inpatient_consent_case - inpatient_consent_case ?approval_authority - approval_authority)
    :precondition
      (and
        (consent_case_open ?outpatient_consent_case)
        (is_outpatient_case ?outpatient_consent_case)
        (default_approval_authority_for_case ?outpatient_consent_case ?approval_authority)
        (approval_authority_linked_to_case ?inpatient_consent_case ?approval_authority)
        (not
          (approval_authority_approval_recorded ?outpatient_consent_case ?approval_authority)
        )
      )
    :effect
      (and
        (approval_authority_approval_recorded ?outpatient_consent_case ?approval_authority)
      )
  )
  (:action record_intake_completion
    :parameters (?consent_case - consent_case ?document_source - document_source ?clinical_clerk - clinical_clerk)
    :precondition
      (and
        (consent_case_open ?consent_case)
        (is_outpatient_case ?consent_case)
        (signatures_verified ?consent_case)
        (approval_authority_request_pending ?consent_case)
        (bound_document_source ?consent_case ?document_source)
        (clinical_clerk_available ?clinical_clerk)
        (not
          (intake_recorded ?consent_case)
        )
      )
    :effect
      (and
        (intake_recorded ?consent_case)
      )
  )
  (:action finalize_inpatient_case
    :parameters (?consent_case - consent_case)
    :precondition
      (and
        (is_inpatient_case ?consent_case)
        (consent_case_open ?consent_case)
        (has_reviewer_assigned ?consent_case)
        (validation_result_recorded ?consent_case)
        (committee_approval_recorded ?consent_case)
        (approval_authority_request_pending ?consent_case)
        (signatures_verified ?consent_case)
        (not
          (case_finalized ?consent_case)
        )
      )
    :effect
      (and
        (case_finalized ?consent_case)
      )
  )
  (:action finalize_case_with_authority
    :parameters (?consent_case - consent_case ?approval_authority - approval_authority)
    :precondition
      (and
        (is_outpatient_case ?consent_case)
        (consent_case_open ?consent_case)
        (has_reviewer_assigned ?consent_case)
        (validation_result_recorded ?consent_case)
        (committee_approval_recorded ?consent_case)
        (approval_authority_request_pending ?consent_case)
        (signatures_verified ?consent_case)
        (approval_authority_approval_recorded ?consent_case ?approval_authority)
        (not
          (case_finalized ?consent_case)
        )
      )
    :effect
      (and
        (case_finalized ?consent_case)
      )
  )
  (:action finalize_case_with_intake_record
    :parameters (?consent_case - consent_case)
    :precondition
      (and
        (is_outpatient_case ?consent_case)
        (consent_case_open ?consent_case)
        (has_reviewer_assigned ?consent_case)
        (validation_result_recorded ?consent_case)
        (committee_approval_recorded ?consent_case)
        (approval_authority_request_pending ?consent_case)
        (signatures_verified ?consent_case)
        (intake_recorded ?consent_case)
        (not
          (case_finalized ?consent_case)
        )
      )
    :effect
      (and
        (case_finalized ?consent_case)
      )
  )
)

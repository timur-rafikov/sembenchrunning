(define (domain medical_prescription_carry_authorization_check)
  (:requirements :strips :typing :negative-preconditions)
  (:types document_class - object regulation_class - object evidence_class - object case_file_class - object travel_case - case_file_class issuing_authority - document_class medical_prescription - document_class supporting_document - document_class exemption_permit_type - document_class fare_exception_profile - document_class medication_declaration - document_class dosage_form - document_class regulatory_reference - document_class medication_type - regulation_class medical_certificate - regulation_class exemption_document - regulation_class origin_regulation - evidence_class destination_regulation - evidence_class authorization_record - evidence_class departure_profile_class - travel_case agent_role_class - travel_case outbound_traveler_profile - departure_profile_class inbound_traveler_profile - departure_profile_class agent - agent_role_class)
  (:predicates
    (record_registered ?travel_case - travel_case)
    (documents_verified ?travel_case - travel_case)
    (has_issuing_authority ?travel_case - travel_case)
    (authorization_request_recorded ?travel_case - travel_case)
    (authorization_issued ?travel_case - travel_case)
    (agent_approval_recorded ?travel_case - travel_case)
    (trusted_issuing_authority ?issuing_authority - issuing_authority)
    (linked_issuing_authority ?travel_case - travel_case ?issuing_authority - issuing_authority)
    (prescription_available ?medical_prescription - medical_prescription)
    (prescription_linked ?travel_case - travel_case ?medical_prescription - medical_prescription)
    (supporting_document_available ?supporting_document - supporting_document)
    (supporting_document_linked ?travel_case - travel_case ?supporting_document - supporting_document)
    (medication_type_available ?medication_type - medication_type)
    (outbound_profile_medication_type_linked ?outbound_traveler_profile - outbound_traveler_profile ?medication_type - medication_type)
    (inbound_profile_medication_type_linked ?inbound_traveler_profile - inbound_traveler_profile ?medication_type - medication_type)
    (profile_origin_regulation_linked ?outbound_traveler_profile - outbound_traveler_profile ?origin_regulation - origin_regulation)
    (origin_regulation_cleared ?origin_regulation - origin_regulation)
    (origin_regulation_restricted ?origin_regulation - origin_regulation)
    (origin_clearance_confirmed ?outbound_traveler_profile - outbound_traveler_profile)
    (profile_destination_regulation_linked ?inbound_traveler_profile - inbound_traveler_profile ?destination_regulation - destination_regulation)
    (destination_regulation_cleared ?destination_regulation - destination_regulation)
    (destination_regulation_restricted ?destination_regulation - destination_regulation)
    (inbound_profile_clearance_confirmed ?inbound_traveler_profile - inbound_traveler_profile)
    (authorization_record_draft ?authorization_record - authorization_record)
    (authorization_record_prepared ?authorization_record - authorization_record)
    (auth_record_origin_regulation_linked ?authorization_record - authorization_record ?origin_regulation - origin_regulation)
    (auth_record_destination_regulation_linked ?authorization_record - authorization_record ?destination_regulation - destination_regulation)
    (auth_record_includes_origin_evidence ?authorization_record - authorization_record)
    (auth_record_includes_destination_evidence ?authorization_record - authorization_record)
    (auth_record_ready ?authorization_record - authorization_record)
    (agent_assigned_outbound_profile ?agent - agent ?outbound_traveler_profile - outbound_traveler_profile)
    (agent_assigned_inbound_profile ?agent - agent ?inbound_traveler_profile - inbound_traveler_profile)
    (agent_manages_authorization_record ?agent - agent ?authorization_record - authorization_record)
    (medical_certificate_available ?medical_certificate - medical_certificate)
    (agent_has_medical_certificate ?agent - agent ?medical_certificate - medical_certificate)
    (medical_certificate_consumed ?medical_certificate - medical_certificate)
    (medical_certificate_linked_to_auth_record ?medical_certificate - medical_certificate ?authorization_record - authorization_record)
    (agent_evidence_ready ?agent - agent)
    (agent_reviewed_case ?agent - agent)
    (agent_ready_for_approval ?agent - agent)
    (agent_has_exemption_request ?agent - agent)
    (agent_exemption_confirmed ?agent - agent)
    (agent_exemption_documented ?agent - agent)
    (agent_checks_completed ?agent - agent)
    (exemption_document_available ?exemption_document - exemption_document)
    (agent_exemption_document_linked ?agent - agent ?exemption_document - exemption_document)
    (agent_exemption_acknowledged ?agent - agent)
    (agent_exemption_verified ?agent - agent)
    (agent_exemption_finalized ?agent - agent)
    (exemption_permit_type_available ?exemption_permit_type - exemption_permit_type)
    (agent_exemption_permit_type_linked ?agent - agent ?exemption_permit_type - exemption_permit_type)
    (fare_exception_profile_available ?fare_exception_profile - fare_exception_profile)
    (agent_fare_exception_profile_linked ?agent - agent ?fare_exception_profile - fare_exception_profile)
    (dosage_form_available ?dosage_form - dosage_form)
    (agent_dosage_form_linked ?agent - agent ?dosage_form - dosage_form)
    (regulatory_reference_available ?regulatory_reference - regulatory_reference)
    (agent_regulatory_reference_linked ?agent - agent ?regulatory_reference - regulatory_reference)
    (medication_declaration_available ?medication_declaration - medication_declaration)
    (medication_declaration_linked ?travel_case - travel_case ?medication_declaration - medication_declaration)
    (outbound_profile_precheck_completed ?outbound_traveler_profile - outbound_traveler_profile)
    (inbound_profile_precheck_completed ?inbound_traveler_profile - inbound_traveler_profile)
    (agent_authorized_to_issue ?agent - agent)
  )
  (:action create_travel_case
    :parameters (?travel_case - travel_case)
    :precondition
      (and
        (not
          (record_registered ?travel_case)
        )
        (not
          (authorization_request_recorded ?travel_case)
        )
      )
    :effect (record_registered ?travel_case)
  )
  (:action attach_issuing_authority
    :parameters (?travel_case - travel_case ?issuing_authority - issuing_authority)
    :precondition
      (and
        (record_registered ?travel_case)
        (not
          (has_issuing_authority ?travel_case)
        )
        (trusted_issuing_authority ?issuing_authority)
      )
    :effect
      (and
        (has_issuing_authority ?travel_case)
        (linked_issuing_authority ?travel_case ?issuing_authority)
        (not
          (trusted_issuing_authority ?issuing_authority)
        )
      )
  )
  (:action attach_medical_prescription
    :parameters (?travel_case - travel_case ?medical_prescription - medical_prescription)
    :precondition
      (and
        (record_registered ?travel_case)
        (has_issuing_authority ?travel_case)
        (prescription_available ?medical_prescription)
      )
    :effect
      (and
        (prescription_linked ?travel_case ?medical_prescription)
        (not
          (prescription_available ?medical_prescription)
        )
      )
  )
  (:action validate_case_documents
    :parameters (?travel_case - travel_case ?medical_prescription - medical_prescription)
    :precondition
      (and
        (record_registered ?travel_case)
        (has_issuing_authority ?travel_case)
        (prescription_linked ?travel_case ?medical_prescription)
        (not
          (documents_verified ?travel_case)
        )
      )
    :effect (documents_verified ?travel_case)
  )
  (:action unlink_prescription
    :parameters (?travel_case - travel_case ?medical_prescription - medical_prescription)
    :precondition
      (and
        (prescription_linked ?travel_case ?medical_prescription)
      )
    :effect
      (and
        (prescription_available ?medical_prescription)
        (not
          (prescription_linked ?travel_case ?medical_prescription)
        )
      )
  )
  (:action attach_supporting_document
    :parameters (?travel_case - travel_case ?supporting_document - supporting_document)
    :precondition
      (and
        (documents_verified ?travel_case)
        (supporting_document_available ?supporting_document)
      )
    :effect
      (and
        (supporting_document_linked ?travel_case ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action unlink_supporting_document
    :parameters (?travel_case - travel_case ?supporting_document - supporting_document)
    :precondition
      (and
        (supporting_document_linked ?travel_case ?supporting_document)
      )
    :effect
      (and
        (supporting_document_available ?supporting_document)
        (not
          (supporting_document_linked ?travel_case ?supporting_document)
        )
      )
  )
  (:action attach_dosage_form_to_agent
    :parameters (?agent - agent ?dosage_form - dosage_form)
    :precondition
      (and
        (documents_verified ?agent)
        (dosage_form_available ?dosage_form)
      )
    :effect
      (and
        (agent_dosage_form_linked ?agent ?dosage_form)
        (not
          (dosage_form_available ?dosage_form)
        )
      )
  )
  (:action detach_dosage_form_from_agent
    :parameters (?agent - agent ?dosage_form - dosage_form)
    :precondition
      (and
        (agent_dosage_form_linked ?agent ?dosage_form)
      )
    :effect
      (and
        (dosage_form_available ?dosage_form)
        (not
          (agent_dosage_form_linked ?agent ?dosage_form)
        )
      )
  )
  (:action attach_regulatory_reference_to_agent
    :parameters (?agent - agent ?regulatory_reference - regulatory_reference)
    :precondition
      (and
        (documents_verified ?agent)
        (regulatory_reference_available ?regulatory_reference)
      )
    :effect
      (and
        (agent_regulatory_reference_linked ?agent ?regulatory_reference)
        (not
          (regulatory_reference_available ?regulatory_reference)
        )
      )
  )
  (:action detach_regulatory_reference_from_agent
    :parameters (?agent - agent ?regulatory_reference - regulatory_reference)
    :precondition
      (and
        (agent_regulatory_reference_linked ?agent ?regulatory_reference)
      )
    :effect
      (and
        (regulatory_reference_available ?regulatory_reference)
        (not
          (agent_regulatory_reference_linked ?agent ?regulatory_reference)
        )
      )
  )
  (:action match_origin_regulation
    :parameters (?outbound_traveler_profile - outbound_traveler_profile ?origin_regulation - origin_regulation ?medical_prescription - medical_prescription)
    :precondition
      (and
        (documents_verified ?outbound_traveler_profile)
        (prescription_linked ?outbound_traveler_profile ?medical_prescription)
        (profile_origin_regulation_linked ?outbound_traveler_profile ?origin_regulation)
        (not
          (origin_regulation_cleared ?origin_regulation)
        )
        (not
          (origin_regulation_restricted ?origin_regulation)
        )
      )
    :effect (origin_regulation_cleared ?origin_regulation)
  )
  (:action apply_origin_regulation_with_supporting_document
    :parameters (?outbound_traveler_profile - outbound_traveler_profile ?origin_regulation - origin_regulation ?supporting_document - supporting_document)
    :precondition
      (and
        (documents_verified ?outbound_traveler_profile)
        (supporting_document_linked ?outbound_traveler_profile ?supporting_document)
        (profile_origin_regulation_linked ?outbound_traveler_profile ?origin_regulation)
        (origin_regulation_cleared ?origin_regulation)
        (not
          (outbound_profile_precheck_completed ?outbound_traveler_profile)
        )
      )
    :effect
      (and
        (outbound_profile_precheck_completed ?outbound_traveler_profile)
        (origin_clearance_confirmed ?outbound_traveler_profile)
      )
  )
  (:action apply_origin_regulation_with_medication_type
    :parameters (?outbound_traveler_profile - outbound_traveler_profile ?origin_regulation - origin_regulation ?medication_type - medication_type)
    :precondition
      (and
        (documents_verified ?outbound_traveler_profile)
        (profile_origin_regulation_linked ?outbound_traveler_profile ?origin_regulation)
        (medication_type_available ?medication_type)
        (not
          (outbound_profile_precheck_completed ?outbound_traveler_profile)
        )
      )
    :effect
      (and
        (origin_regulation_restricted ?origin_regulation)
        (outbound_profile_precheck_completed ?outbound_traveler_profile)
        (outbound_profile_medication_type_linked ?outbound_traveler_profile ?medication_type)
        (not
          (medication_type_available ?medication_type)
        )
      )
  )
  (:action finalize_origin_regulation_outcome
    :parameters (?outbound_traveler_profile - outbound_traveler_profile ?origin_regulation - origin_regulation ?medical_prescription - medical_prescription ?medication_type - medication_type)
    :precondition
      (and
        (documents_verified ?outbound_traveler_profile)
        (prescription_linked ?outbound_traveler_profile ?medical_prescription)
        (profile_origin_regulation_linked ?outbound_traveler_profile ?origin_regulation)
        (origin_regulation_restricted ?origin_regulation)
        (outbound_profile_medication_type_linked ?outbound_traveler_profile ?medication_type)
        (not
          (origin_clearance_confirmed ?outbound_traveler_profile)
        )
      )
    :effect
      (and
        (origin_regulation_cleared ?origin_regulation)
        (origin_clearance_confirmed ?outbound_traveler_profile)
        (medication_type_available ?medication_type)
        (not
          (outbound_profile_medication_type_linked ?outbound_traveler_profile ?medication_type)
        )
      )
  )
  (:action evaluate_destination_regulation
    :parameters (?inbound_traveler_profile - inbound_traveler_profile ?destination_regulation - destination_regulation ?medical_prescription - medical_prescription)
    :precondition
      (and
        (documents_verified ?inbound_traveler_profile)
        (prescription_linked ?inbound_traveler_profile ?medical_prescription)
        (profile_destination_regulation_linked ?inbound_traveler_profile ?destination_regulation)
        (not
          (destination_regulation_cleared ?destination_regulation)
        )
        (not
          (destination_regulation_restricted ?destination_regulation)
        )
      )
    :effect (destination_regulation_cleared ?destination_regulation)
  )
  (:action apply_destination_regulation_with_document
    :parameters (?inbound_traveler_profile - inbound_traveler_profile ?destination_regulation - destination_regulation ?supporting_document - supporting_document)
    :precondition
      (and
        (documents_verified ?inbound_traveler_profile)
        (supporting_document_linked ?inbound_traveler_profile ?supporting_document)
        (profile_destination_regulation_linked ?inbound_traveler_profile ?destination_regulation)
        (destination_regulation_cleared ?destination_regulation)
        (not
          (inbound_profile_precheck_completed ?inbound_traveler_profile)
        )
      )
    :effect
      (and
        (inbound_profile_precheck_completed ?inbound_traveler_profile)
        (inbound_profile_clearance_confirmed ?inbound_traveler_profile)
      )
  )
  (:action apply_destination_regulation_with_medication_type
    :parameters (?inbound_traveler_profile - inbound_traveler_profile ?destination_regulation - destination_regulation ?medication_type - medication_type)
    :precondition
      (and
        (documents_verified ?inbound_traveler_profile)
        (profile_destination_regulation_linked ?inbound_traveler_profile ?destination_regulation)
        (medication_type_available ?medication_type)
        (not
          (inbound_profile_precheck_completed ?inbound_traveler_profile)
        )
      )
    :effect
      (and
        (destination_regulation_restricted ?destination_regulation)
        (inbound_profile_precheck_completed ?inbound_traveler_profile)
        (inbound_profile_medication_type_linked ?inbound_traveler_profile ?medication_type)
        (not
          (medication_type_available ?medication_type)
        )
      )
  )
  (:action finalize_destination_regulation_outcome
    :parameters (?inbound_traveler_profile - inbound_traveler_profile ?destination_regulation - destination_regulation ?medical_prescription - medical_prescription ?medication_type - medication_type)
    :precondition
      (and
        (documents_verified ?inbound_traveler_profile)
        (prescription_linked ?inbound_traveler_profile ?medical_prescription)
        (profile_destination_regulation_linked ?inbound_traveler_profile ?destination_regulation)
        (destination_regulation_restricted ?destination_regulation)
        (inbound_profile_medication_type_linked ?inbound_traveler_profile ?medication_type)
        (not
          (inbound_profile_clearance_confirmed ?inbound_traveler_profile)
        )
      )
    :effect
      (and
        (destination_regulation_cleared ?destination_regulation)
        (inbound_profile_clearance_confirmed ?inbound_traveler_profile)
        (medication_type_available ?medication_type)
        (not
          (inbound_profile_medication_type_linked ?inbound_traveler_profile ?medication_type)
        )
      )
  )
  (:action assemble_authorization_record
    :parameters (?outbound_traveler_profile - outbound_traveler_profile ?inbound_traveler_profile - inbound_traveler_profile ?origin_regulation - origin_regulation ?destination_regulation - destination_regulation ?authorization_record - authorization_record)
    :precondition
      (and
        (outbound_profile_precheck_completed ?outbound_traveler_profile)
        (inbound_profile_precheck_completed ?inbound_traveler_profile)
        (profile_origin_regulation_linked ?outbound_traveler_profile ?origin_regulation)
        (profile_destination_regulation_linked ?inbound_traveler_profile ?destination_regulation)
        (origin_regulation_cleared ?origin_regulation)
        (destination_regulation_cleared ?destination_regulation)
        (origin_clearance_confirmed ?outbound_traveler_profile)
        (inbound_profile_clearance_confirmed ?inbound_traveler_profile)
        (authorization_record_draft ?authorization_record)
      )
    :effect
      (and
        (authorization_record_prepared ?authorization_record)
        (auth_record_origin_regulation_linked ?authorization_record ?origin_regulation)
        (auth_record_destination_regulation_linked ?authorization_record ?destination_regulation)
        (not
          (authorization_record_draft ?authorization_record)
        )
      )
  )
  (:action assemble_authorization_record_origin_path
    :parameters (?outbound_traveler_profile - outbound_traveler_profile ?inbound_traveler_profile - inbound_traveler_profile ?origin_regulation - origin_regulation ?destination_regulation - destination_regulation ?authorization_record - authorization_record)
    :precondition
      (and
        (outbound_profile_precheck_completed ?outbound_traveler_profile)
        (inbound_profile_precheck_completed ?inbound_traveler_profile)
        (profile_origin_regulation_linked ?outbound_traveler_profile ?origin_regulation)
        (profile_destination_regulation_linked ?inbound_traveler_profile ?destination_regulation)
        (origin_regulation_restricted ?origin_regulation)
        (destination_regulation_cleared ?destination_regulation)
        (not
          (origin_clearance_confirmed ?outbound_traveler_profile)
        )
        (inbound_profile_clearance_confirmed ?inbound_traveler_profile)
        (authorization_record_draft ?authorization_record)
      )
    :effect
      (and
        (authorization_record_prepared ?authorization_record)
        (auth_record_origin_regulation_linked ?authorization_record ?origin_regulation)
        (auth_record_destination_regulation_linked ?authorization_record ?destination_regulation)
        (auth_record_includes_origin_evidence ?authorization_record)
        (not
          (authorization_record_draft ?authorization_record)
        )
      )
  )
  (:action assemble_authorization_record_destination_path
    :parameters (?outbound_traveler_profile - outbound_traveler_profile ?inbound_traveler_profile - inbound_traveler_profile ?origin_regulation - origin_regulation ?destination_regulation - destination_regulation ?authorization_record - authorization_record)
    :precondition
      (and
        (outbound_profile_precheck_completed ?outbound_traveler_profile)
        (inbound_profile_precheck_completed ?inbound_traveler_profile)
        (profile_origin_regulation_linked ?outbound_traveler_profile ?origin_regulation)
        (profile_destination_regulation_linked ?inbound_traveler_profile ?destination_regulation)
        (origin_regulation_cleared ?origin_regulation)
        (destination_regulation_restricted ?destination_regulation)
        (origin_clearance_confirmed ?outbound_traveler_profile)
        (not
          (inbound_profile_clearance_confirmed ?inbound_traveler_profile)
        )
        (authorization_record_draft ?authorization_record)
      )
    :effect
      (and
        (authorization_record_prepared ?authorization_record)
        (auth_record_origin_regulation_linked ?authorization_record ?origin_regulation)
        (auth_record_destination_regulation_linked ?authorization_record ?destination_regulation)
        (auth_record_includes_destination_evidence ?authorization_record)
        (not
          (authorization_record_draft ?authorization_record)
        )
      )
  )
  (:action assemble_authorization_record_both_paths
    :parameters (?outbound_traveler_profile - outbound_traveler_profile ?inbound_traveler_profile - inbound_traveler_profile ?origin_regulation - origin_regulation ?destination_regulation - destination_regulation ?authorization_record - authorization_record)
    :precondition
      (and
        (outbound_profile_precheck_completed ?outbound_traveler_profile)
        (inbound_profile_precheck_completed ?inbound_traveler_profile)
        (profile_origin_regulation_linked ?outbound_traveler_profile ?origin_regulation)
        (profile_destination_regulation_linked ?inbound_traveler_profile ?destination_regulation)
        (origin_regulation_restricted ?origin_regulation)
        (destination_regulation_restricted ?destination_regulation)
        (not
          (origin_clearance_confirmed ?outbound_traveler_profile)
        )
        (not
          (inbound_profile_clearance_confirmed ?inbound_traveler_profile)
        )
        (authorization_record_draft ?authorization_record)
      )
    :effect
      (and
        (authorization_record_prepared ?authorization_record)
        (auth_record_origin_regulation_linked ?authorization_record ?origin_regulation)
        (auth_record_destination_regulation_linked ?authorization_record ?destination_regulation)
        (auth_record_includes_origin_evidence ?authorization_record)
        (auth_record_includes_destination_evidence ?authorization_record)
        (not
          (authorization_record_draft ?authorization_record)
        )
      )
  )
  (:action mark_auth_record_ready_for_certificate_processing
    :parameters (?authorization_record - authorization_record ?outbound_traveler_profile - outbound_traveler_profile ?medical_prescription - medical_prescription)
    :precondition
      (and
        (authorization_record_prepared ?authorization_record)
        (outbound_profile_precheck_completed ?outbound_traveler_profile)
        (prescription_linked ?outbound_traveler_profile ?medical_prescription)
        (not
          (auth_record_ready ?authorization_record)
        )
      )
    :effect (auth_record_ready ?authorization_record)
  )
  (:action consume_medical_certificate
    :parameters (?agent - agent ?medical_certificate - medical_certificate ?authorization_record - authorization_record)
    :precondition
      (and
        (documents_verified ?agent)
        (agent_manages_authorization_record ?agent ?authorization_record)
        (agent_has_medical_certificate ?agent ?medical_certificate)
        (medical_certificate_available ?medical_certificate)
        (authorization_record_prepared ?authorization_record)
        (auth_record_ready ?authorization_record)
        (not
          (medical_certificate_consumed ?medical_certificate)
        )
      )
    :effect
      (and
        (medical_certificate_consumed ?medical_certificate)
        (medical_certificate_linked_to_auth_record ?medical_certificate ?authorization_record)
        (not
          (medical_certificate_available ?medical_certificate)
        )
      )
  )
  (:action verify_certificate_for_agent
    :parameters (?agent - agent ?medical_certificate - medical_certificate ?authorization_record - authorization_record ?medical_prescription - medical_prescription)
    :precondition
      (and
        (documents_verified ?agent)
        (agent_has_medical_certificate ?agent ?medical_certificate)
        (medical_certificate_consumed ?medical_certificate)
        (medical_certificate_linked_to_auth_record ?medical_certificate ?authorization_record)
        (prescription_linked ?agent ?medical_prescription)
        (not
          (auth_record_includes_origin_evidence ?authorization_record)
        )
        (not
          (agent_evidence_ready ?agent)
        )
      )
    :effect (agent_evidence_ready ?agent)
  )
  (:action attach_exemption_permit_type
    :parameters (?agent - agent ?exemption_permit_type - exemption_permit_type)
    :precondition
      (and
        (documents_verified ?agent)
        (exemption_permit_type_available ?exemption_permit_type)
        (not
          (agent_has_exemption_request ?agent)
        )
      )
    :effect
      (and
        (agent_has_exemption_request ?agent)
        (agent_exemption_permit_type_linked ?agent ?exemption_permit_type)
        (not
          (exemption_permit_type_available ?exemption_permit_type)
        )
      )
  )
  (:action process_certificate_with_exemption
    :parameters (?agent - agent ?medical_certificate - medical_certificate ?authorization_record - authorization_record ?medical_prescription - medical_prescription ?exemption_permit_type - exemption_permit_type)
    :precondition
      (and
        (documents_verified ?agent)
        (agent_has_medical_certificate ?agent ?medical_certificate)
        (medical_certificate_consumed ?medical_certificate)
        (medical_certificate_linked_to_auth_record ?medical_certificate ?authorization_record)
        (prescription_linked ?agent ?medical_prescription)
        (auth_record_includes_origin_evidence ?authorization_record)
        (agent_has_exemption_request ?agent)
        (agent_exemption_permit_type_linked ?agent ?exemption_permit_type)
        (not
          (agent_evidence_ready ?agent)
        )
      )
    :effect
      (and
        (agent_evidence_ready ?agent)
        (agent_exemption_confirmed ?agent)
      )
  )
  (:action agent_attach_dosage_evidence
    :parameters (?agent - agent ?dosage_form - dosage_form ?supporting_document - supporting_document ?medical_certificate - medical_certificate ?authorization_record - authorization_record)
    :precondition
      (and
        (agent_evidence_ready ?agent)
        (agent_dosage_form_linked ?agent ?dosage_form)
        (supporting_document_linked ?agent ?supporting_document)
        (agent_has_medical_certificate ?agent ?medical_certificate)
        (medical_certificate_linked_to_auth_record ?medical_certificate ?authorization_record)
        (not
          (auth_record_includes_destination_evidence ?authorization_record)
        )
        (not
          (agent_reviewed_case ?agent)
        )
      )
    :effect (agent_reviewed_case ?agent)
  )
  (:action agent_attach_dosage_evidence_alternate
    :parameters (?agent - agent ?dosage_form - dosage_form ?supporting_document - supporting_document ?medical_certificate - medical_certificate ?authorization_record - authorization_record)
    :precondition
      (and
        (agent_evidence_ready ?agent)
        (agent_dosage_form_linked ?agent ?dosage_form)
        (supporting_document_linked ?agent ?supporting_document)
        (agent_has_medical_certificate ?agent ?medical_certificate)
        (medical_certificate_linked_to_auth_record ?medical_certificate ?authorization_record)
        (auth_record_includes_destination_evidence ?authorization_record)
        (not
          (agent_reviewed_case ?agent)
        )
      )
    :effect (agent_reviewed_case ?agent)
  )
  (:action advance_agent_to_review_stage
    :parameters (?agent - agent ?regulatory_reference - regulatory_reference ?medical_certificate - medical_certificate ?authorization_record - authorization_record)
    :precondition
      (and
        (agent_reviewed_case ?agent)
        (agent_regulatory_reference_linked ?agent ?regulatory_reference)
        (agent_has_medical_certificate ?agent ?medical_certificate)
        (medical_certificate_linked_to_auth_record ?medical_certificate ?authorization_record)
        (not
          (auth_record_includes_origin_evidence ?authorization_record)
        )
        (not
          (auth_record_includes_destination_evidence ?authorization_record)
        )
        (not
          (agent_ready_for_approval ?agent)
        )
      )
    :effect (agent_ready_for_approval ?agent)
  )
  (:action advance_agent_with_regulatory_reference
    :parameters (?agent - agent ?regulatory_reference - regulatory_reference ?medical_certificate - medical_certificate ?authorization_record - authorization_record)
    :precondition
      (and
        (agent_reviewed_case ?agent)
        (agent_regulatory_reference_linked ?agent ?regulatory_reference)
        (agent_has_medical_certificate ?agent ?medical_certificate)
        (medical_certificate_linked_to_auth_record ?medical_certificate ?authorization_record)
        (auth_record_includes_origin_evidence ?authorization_record)
        (not
          (auth_record_includes_destination_evidence ?authorization_record)
        )
        (not
          (agent_ready_for_approval ?agent)
        )
      )
    :effect
      (and
        (agent_ready_for_approval ?agent)
        (agent_exemption_documented ?agent)
      )
  )
  (:action advance_agent_alternate_review
    :parameters (?agent - agent ?regulatory_reference - regulatory_reference ?medical_certificate - medical_certificate ?authorization_record - authorization_record)
    :precondition
      (and
        (agent_reviewed_case ?agent)
        (agent_regulatory_reference_linked ?agent ?regulatory_reference)
        (agent_has_medical_certificate ?agent ?medical_certificate)
        (medical_certificate_linked_to_auth_record ?medical_certificate ?authorization_record)
        (not
          (auth_record_includes_origin_evidence ?authorization_record)
        )
        (auth_record_includes_destination_evidence ?authorization_record)
        (not
          (agent_ready_for_approval ?agent)
        )
      )
    :effect
      (and
        (agent_ready_for_approval ?agent)
        (agent_exemption_documented ?agent)
      )
  )
  (:action advance_agent_full_review
    :parameters (?agent - agent ?regulatory_reference - regulatory_reference ?medical_certificate - medical_certificate ?authorization_record - authorization_record)
    :precondition
      (and
        (agent_reviewed_case ?agent)
        (agent_regulatory_reference_linked ?agent ?regulatory_reference)
        (agent_has_medical_certificate ?agent ?medical_certificate)
        (medical_certificate_linked_to_auth_record ?medical_certificate ?authorization_record)
        (auth_record_includes_origin_evidence ?authorization_record)
        (auth_record_includes_destination_evidence ?authorization_record)
        (not
          (agent_ready_for_approval ?agent)
        )
      )
    :effect
      (and
        (agent_ready_for_approval ?agent)
        (agent_exemption_documented ?agent)
      )
  )
  (:action agent_mark_authorized_to_issue
    :parameters (?agent - agent)
    :precondition
      (and
        (agent_ready_for_approval ?agent)
        (not
          (agent_exemption_documented ?agent)
        )
        (not
          (agent_authorized_to_issue ?agent)
        )
      )
    :effect
      (and
        (agent_authorized_to_issue ?agent)
        (authorization_issued ?agent)
      )
  )
  (:action attach_fare_exception_profile_to_agent
    :parameters (?agent - agent ?fare_exception_profile - fare_exception_profile)
    :precondition
      (and
        (agent_ready_for_approval ?agent)
        (agent_exemption_documented ?agent)
        (fare_exception_profile_available ?fare_exception_profile)
      )
    :effect
      (and
        (agent_fare_exception_profile_linked ?agent ?fare_exception_profile)
        (not
          (fare_exception_profile_available ?fare_exception_profile)
        )
      )
  )
  (:action finalize_agent_checks_for_case
    :parameters (?agent - agent ?outbound_traveler_profile - outbound_traveler_profile ?inbound_traveler_profile - inbound_traveler_profile ?medical_prescription - medical_prescription ?fare_exception_profile - fare_exception_profile)
    :precondition
      (and
        (agent_ready_for_approval ?agent)
        (agent_exemption_documented ?agent)
        (agent_fare_exception_profile_linked ?agent ?fare_exception_profile)
        (agent_assigned_outbound_profile ?agent ?outbound_traveler_profile)
        (agent_assigned_inbound_profile ?agent ?inbound_traveler_profile)
        (origin_clearance_confirmed ?outbound_traveler_profile)
        (inbound_profile_clearance_confirmed ?inbound_traveler_profile)
        (prescription_linked ?agent ?medical_prescription)
        (not
          (agent_checks_completed ?agent)
        )
      )
    :effect (agent_checks_completed ?agent)
  )
  (:action issue_agent_authorization
    :parameters (?agent - agent)
    :precondition
      (and
        (agent_ready_for_approval ?agent)
        (agent_checks_completed ?agent)
        (not
          (agent_authorized_to_issue ?agent)
        )
      )
    :effect
      (and
        (agent_authorized_to_issue ?agent)
        (authorization_issued ?agent)
      )
  )
  (:action apply_exemption_document_to_agent
    :parameters (?agent - agent ?exemption_document - exemption_document ?medical_prescription - medical_prescription)
    :precondition
      (and
        (documents_verified ?agent)
        (prescription_linked ?agent ?medical_prescription)
        (exemption_document_available ?exemption_document)
        (agent_exemption_document_linked ?agent ?exemption_document)
        (not
          (agent_exemption_acknowledged ?agent)
        )
      )
    :effect
      (and
        (agent_exemption_acknowledged ?agent)
        (not
          (exemption_document_available ?exemption_document)
        )
      )
  )
  (:action verify_exemption_supporting_document
    :parameters (?agent - agent ?supporting_document - supporting_document)
    :precondition
      (and
        (agent_exemption_acknowledged ?agent)
        (supporting_document_linked ?agent ?supporting_document)
        (not
          (agent_exemption_verified ?agent)
        )
      )
    :effect (agent_exemption_verified ?agent)
  )
  (:action finalize_exemption_verification
    :parameters (?agent - agent ?regulatory_reference - regulatory_reference)
    :precondition
      (and
        (agent_exemption_verified ?agent)
        (agent_regulatory_reference_linked ?agent ?regulatory_reference)
        (not
          (agent_exemption_finalized ?agent)
        )
      )
    :effect (agent_exemption_finalized ?agent)
  )
  (:action finalize_agent_exemption_approval
    :parameters (?agent - agent)
    :precondition
      (and
        (agent_exemption_finalized ?agent)
        (not
          (agent_authorized_to_issue ?agent)
        )
      )
    :effect
      (and
        (agent_authorized_to_issue ?agent)
        (authorization_issued ?agent)
      )
  )
  (:action grant_authorization_to_outbound_profile
    :parameters (?outbound_traveler_profile - outbound_traveler_profile ?authorization_record - authorization_record)
    :precondition
      (and
        (outbound_profile_precheck_completed ?outbound_traveler_profile)
        (origin_clearance_confirmed ?outbound_traveler_profile)
        (authorization_record_prepared ?authorization_record)
        (auth_record_ready ?authorization_record)
        (not
          (authorization_issued ?outbound_traveler_profile)
        )
      )
    :effect (authorization_issued ?outbound_traveler_profile)
  )
  (:action grant_authorization_to_inbound_profile
    :parameters (?inbound_traveler_profile - inbound_traveler_profile ?authorization_record - authorization_record)
    :precondition
      (and
        (inbound_profile_precheck_completed ?inbound_traveler_profile)
        (inbound_profile_clearance_confirmed ?inbound_traveler_profile)
        (authorization_record_prepared ?authorization_record)
        (auth_record_ready ?authorization_record)
        (not
          (authorization_issued ?inbound_traveler_profile)
        )
      )
    :effect (authorization_issued ?inbound_traveler_profile)
  )
  (:action attach_medication_declaration_and_finalize_case
    :parameters (?travel_case - travel_case ?medication_declaration - medication_declaration ?medical_prescription - medical_prescription)
    :precondition
      (and
        (authorization_issued ?travel_case)
        (prescription_linked ?travel_case ?medical_prescription)
        (medication_declaration_available ?medication_declaration)
        (not
          (agent_approval_recorded ?travel_case)
        )
      )
    :effect
      (and
        (agent_approval_recorded ?travel_case)
        (medication_declaration_linked ?travel_case ?medication_declaration)
        (not
          (medication_declaration_available ?medication_declaration)
        )
      )
  )
  (:action submit_authorization_request_from_outbound_profile
    :parameters (?outbound_traveler_profile - outbound_traveler_profile ?issuing_authority - issuing_authority ?medication_declaration - medication_declaration)
    :precondition
      (and
        (agent_approval_recorded ?outbound_traveler_profile)
        (linked_issuing_authority ?outbound_traveler_profile ?issuing_authority)
        (medication_declaration_linked ?outbound_traveler_profile ?medication_declaration)
        (not
          (authorization_request_recorded ?outbound_traveler_profile)
        )
      )
    :effect
      (and
        (authorization_request_recorded ?outbound_traveler_profile)
        (trusted_issuing_authority ?issuing_authority)
        (medication_declaration_available ?medication_declaration)
      )
  )
  (:action submit_authorization_request_from_inbound_profile
    :parameters (?inbound_traveler_profile - inbound_traveler_profile ?issuing_authority - issuing_authority ?medication_declaration - medication_declaration)
    :precondition
      (and
        (agent_approval_recorded ?inbound_traveler_profile)
        (linked_issuing_authority ?inbound_traveler_profile ?issuing_authority)
        (medication_declaration_linked ?inbound_traveler_profile ?medication_declaration)
        (not
          (authorization_request_recorded ?inbound_traveler_profile)
        )
      )
    :effect
      (and
        (authorization_request_recorded ?inbound_traveler_profile)
        (trusted_issuing_authority ?issuing_authority)
        (medication_declaration_available ?medication_declaration)
      )
  )
  (:action agent_submit_authorization_request
    :parameters (?agent - agent ?issuing_authority - issuing_authority ?medication_declaration - medication_declaration)
    :precondition
      (and
        (agent_approval_recorded ?agent)
        (linked_issuing_authority ?agent ?issuing_authority)
        (medication_declaration_linked ?agent ?medication_declaration)
        (not
          (authorization_request_recorded ?agent)
        )
      )
    :effect
      (and
        (authorization_request_recorded ?agent)
        (trusted_issuing_authority ?issuing_authority)
        (medication_declaration_available ?medication_declaration)
      )
  )
)

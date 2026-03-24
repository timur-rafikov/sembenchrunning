(define (domain entry_rule_sequence_validation)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource - object document_kind - object requirement_category - object case_container - object entry_case - case_container document_resource - operational_resource policy_rule - operational_resource verifier_agent - operational_resource travel_purpose - operational_resource traveler_attribute - operational_resource issuance_token_type - operational_resource health_credential_type - operational_resource supporting_evidence_type - operational_resource evidence_document - document_kind supporting_document_type - document_kind country_ruleset - document_kind requirement_set - requirement_category admission_category - requirement_category entry_package - requirement_category traveler_profile_group - entry_case processing_context - entry_case primary_profile - traveler_profile_group secondary_profile - traveler_profile_group processor - processing_context)
  (:predicates
    (case_created ?entry_case - entry_case)
    (rule_interpreted ?entry_case - entry_case)
    (case_document_attached ?entry_case - entry_case)
    (entry_validation_confirmed ?entry_case - entry_case)
    (clearance_granted ?entry_case - entry_case)
    (case_eligibility_confirmed ?entry_case - entry_case)
    (document_resource_available ?document_resource - document_resource)
    (case_has_document_resource ?entry_case - entry_case ?document_resource - document_resource)
    (policy_rule_available ?policy_rule - policy_rule)
    (case_linked_policy_rule ?entry_case - entry_case ?policy_rule - policy_rule)
    (verifier_available ?verifier_agent - verifier_agent)
    (case_assigned_verifier ?entry_case - entry_case ?verifier_agent - verifier_agent)
    (evidence_document_available ?evidence_document - evidence_document)
    (primary_profile_evidence_link ?primary_profile - primary_profile ?evidence_document - evidence_document)
    (secondary_profile_evidence_link ?secondary_profile - secondary_profile ?evidence_document - evidence_document)
    (profile_requirementset_link ?primary_profile - primary_profile ?requirement_set - requirement_set)
    (requirement_set_activated ?requirement_set - requirement_set)
    (requirement_set_evidence_present ?requirement_set - requirement_set)
    (primary_profile_requirements_met ?primary_profile - primary_profile)
    (secondary_profile_admission_category ?secondary_profile - secondary_profile ?admission_category - admission_category)
    (admission_category_marked ?admission_category - admission_category)
    (admission_category_evidence_present ?admission_category - admission_category)
    (secondary_profile_requirements_met ?secondary_profile - secondary_profile)
    (entry_package_template_available ?entry_package - entry_package)
    (entry_package_created ?entry_package - entry_package)
    (entry_package_requirementset_link ?entry_package - entry_package ?requirement_set - requirement_set)
    (entry_package_admission_category_link ?entry_package - entry_package ?admission_category - admission_category)
    (entry_package_flag_condition1 ?entry_package - entry_package)
    (entry_package_flag_condition2 ?entry_package - entry_package)
    (entry_package_validated ?entry_package - entry_package)
    (processor_assigned_primary_profile ?processor - processor ?primary_profile - primary_profile)
    (processor_assigned_secondary_profile ?processor - processor ?secondary_profile - secondary_profile)
    (processor_assigned_entry_package ?processor - processor ?entry_package - entry_package)
    (supporting_doc_type_available ?supporting_doc_type - supporting_document_type)
    (processor_supporting_doc_type_link ?processor - processor ?supporting_doc_type - supporting_document_type)
    (supporting_doc_type_consumed ?supporting_doc_type - supporting_document_type)
    (supporting_doc_type_linked_to_package ?supporting_doc_type - supporting_document_type ?entry_package - entry_package)
    (processor_supporting_docs_verified ?processor - processor)
    (processor_credentials_verified ?processor - processor)
    (processor_endorsement_ready ?processor - processor)
    (processor_purpose_attached ?processor - processor)
    (processor_purpose_confirmed ?processor - processor)
    (processor_ready_for_finalization ?processor - processor)
    (processor_combined_verification_applied ?processor - processor)
    (country_ruleset_available ?country_ruleset - country_ruleset)
    (processor_country_ruleset_link ?processor - processor ?country_ruleset - country_ruleset)
    (processor_country_approved ?processor - processor)
    (processor_purpose_authorized ?processor - processor)
    (processor_purpose_endorsement_confirmed ?processor - processor)
    (travel_purpose_available ?travel_purpose - travel_purpose)
    (processor_travel_purpose_link ?processor - processor ?travel_purpose - travel_purpose)
    (traveler_attribute_available ?traveler_attribute - traveler_attribute)
    (processor_traveler_attribute_link ?processor - processor ?traveler_attribute - traveler_attribute)
    (health_credential_available ?health_credential_type - health_credential_type)
    (processor_assigned_health_credential ?processor - processor ?health_credential_type - health_credential_type)
    (supporting_evidence_type_available ?supporting_evidence_type - supporting_evidence_type)
    (processor_assigned_supporting_evidence ?processor - processor ?supporting_evidence_type - supporting_evidence_type)
    (issuance_token_type_available ?issuance_token_type - issuance_token_type)
    (case_issuance_token_link ?entry_case - entry_case ?issuance_token_type - issuance_token_type)
    (primary_profile_processing_started ?primary_profile - primary_profile)
    (secondary_profile_processing_started ?secondary_profile - secondary_profile)
    (processor_finalized ?processor - processor)
  )
  (:action initialize_entry_case
    :parameters (?entry_case - entry_case)
    :precondition
      (and
        (not
          (case_created ?entry_case)
        )
        (not
          (entry_validation_confirmed ?entry_case)
        )
      )
    :effect (case_created ?entry_case)
  )
  (:action attach_document_resource_to_case
    :parameters (?entry_case - entry_case ?document_resource - document_resource)
    :precondition
      (and
        (case_created ?entry_case)
        (not
          (case_document_attached ?entry_case)
        )
        (document_resource_available ?document_resource)
      )
    :effect
      (and
        (case_document_attached ?entry_case)
        (case_has_document_resource ?entry_case ?document_resource)
        (not
          (document_resource_available ?document_resource)
        )
      )
  )
  (:action link_policy_rule_to_case
    :parameters (?entry_case - entry_case ?policy_rule - policy_rule)
    :precondition
      (and
        (case_created ?entry_case)
        (case_document_attached ?entry_case)
        (policy_rule_available ?policy_rule)
      )
    :effect
      (and
        (case_linked_policy_rule ?entry_case ?policy_rule)
        (not
          (policy_rule_available ?policy_rule)
        )
      )
  )
  (:action interpret_policy_rule_for_case
    :parameters (?entry_case - entry_case ?policy_rule - policy_rule)
    :precondition
      (and
        (case_created ?entry_case)
        (case_document_attached ?entry_case)
        (case_linked_policy_rule ?entry_case ?policy_rule)
        (not
          (rule_interpreted ?entry_case)
        )
      )
    :effect (rule_interpreted ?entry_case)
  )
  (:action return_policy_rule_to_pool
    :parameters (?entry_case - entry_case ?policy_rule - policy_rule)
    :precondition
      (and
        (case_linked_policy_rule ?entry_case ?policy_rule)
      )
    :effect
      (and
        (policy_rule_available ?policy_rule)
        (not
          (case_linked_policy_rule ?entry_case ?policy_rule)
        )
      )
  )
  (:action assign_verifier_to_case
    :parameters (?entry_case - entry_case ?verifier_agent - verifier_agent)
    :precondition
      (and
        (rule_interpreted ?entry_case)
        (verifier_available ?verifier_agent)
      )
    :effect
      (and
        (case_assigned_verifier ?entry_case ?verifier_agent)
        (not
          (verifier_available ?verifier_agent)
        )
      )
  )
  (:action release_verifier_from_case
    :parameters (?entry_case - entry_case ?verifier_agent - verifier_agent)
    :precondition
      (and
        (case_assigned_verifier ?entry_case ?verifier_agent)
      )
    :effect
      (and
        (verifier_available ?verifier_agent)
        (not
          (case_assigned_verifier ?entry_case ?verifier_agent)
        )
      )
  )
  (:action assign_health_credential_to_processor
    :parameters (?processor - processor ?health_credential_type - health_credential_type)
    :precondition
      (and
        (rule_interpreted ?processor)
        (health_credential_available ?health_credential_type)
      )
    :effect
      (and
        (processor_assigned_health_credential ?processor ?health_credential_type)
        (not
          (health_credential_available ?health_credential_type)
        )
      )
  )
  (:action release_health_credential_from_processor
    :parameters (?processor - processor ?health_credential_type - health_credential_type)
    :precondition
      (and
        (processor_assigned_health_credential ?processor ?health_credential_type)
      )
    :effect
      (and
        (health_credential_available ?health_credential_type)
        (not
          (processor_assigned_health_credential ?processor ?health_credential_type)
        )
      )
  )
  (:action assign_supporting_evidence_to_processor
    :parameters (?processor - processor ?supporting_evidence_type - supporting_evidence_type)
    :precondition
      (and
        (rule_interpreted ?processor)
        (supporting_evidence_type_available ?supporting_evidence_type)
      )
    :effect
      (and
        (processor_assigned_supporting_evidence ?processor ?supporting_evidence_type)
        (not
          (supporting_evidence_type_available ?supporting_evidence_type)
        )
      )
  )
  (:action release_supporting_evidence_from_processor
    :parameters (?processor - processor ?supporting_evidence_type - supporting_evidence_type)
    :precondition
      (and
        (processor_assigned_supporting_evidence ?processor ?supporting_evidence_type)
      )
    :effect
      (and
        (supporting_evidence_type_available ?supporting_evidence_type)
        (not
          (processor_assigned_supporting_evidence ?processor ?supporting_evidence_type)
        )
      )
  )
  (:action activate_requirement_set_for_primary_profile
    :parameters (?primary_profile - primary_profile ?requirement_set - requirement_set ?policy_rule - policy_rule)
    :precondition
      (and
        (rule_interpreted ?primary_profile)
        (case_linked_policy_rule ?primary_profile ?policy_rule)
        (profile_requirementset_link ?primary_profile ?requirement_set)
        (not
          (requirement_set_activated ?requirement_set)
        )
        (not
          (requirement_set_evidence_present ?requirement_set)
        )
      )
    :effect (requirement_set_activated ?requirement_set)
  )
  (:action apply_verifier_findings_to_primary_profile
    :parameters (?primary_profile - primary_profile ?requirement_set - requirement_set ?verifier_agent - verifier_agent)
    :precondition
      (and
        (rule_interpreted ?primary_profile)
        (case_assigned_verifier ?primary_profile ?verifier_agent)
        (profile_requirementset_link ?primary_profile ?requirement_set)
        (requirement_set_activated ?requirement_set)
        (not
          (primary_profile_processing_started ?primary_profile)
        )
      )
    :effect
      (and
        (primary_profile_processing_started ?primary_profile)
        (primary_profile_requirements_met ?primary_profile)
      )
  )
  (:action attach_evidence_to_primary_profile
    :parameters (?primary_profile - primary_profile ?requirement_set - requirement_set ?evidence_document - evidence_document)
    :precondition
      (and
        (rule_interpreted ?primary_profile)
        (profile_requirementset_link ?primary_profile ?requirement_set)
        (evidence_document_available ?evidence_document)
        (not
          (primary_profile_processing_started ?primary_profile)
        )
      )
    :effect
      (and
        (requirement_set_evidence_present ?requirement_set)
        (primary_profile_processing_started ?primary_profile)
        (primary_profile_evidence_link ?primary_profile ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action finalize_primary_profile_requirement
    :parameters (?primary_profile - primary_profile ?requirement_set - requirement_set ?policy_rule - policy_rule ?evidence_document - evidence_document)
    :precondition
      (and
        (rule_interpreted ?primary_profile)
        (case_linked_policy_rule ?primary_profile ?policy_rule)
        (profile_requirementset_link ?primary_profile ?requirement_set)
        (requirement_set_evidence_present ?requirement_set)
        (primary_profile_evidence_link ?primary_profile ?evidence_document)
        (not
          (primary_profile_requirements_met ?primary_profile)
        )
      )
    :effect
      (and
        (requirement_set_activated ?requirement_set)
        (primary_profile_requirements_met ?primary_profile)
        (evidence_document_available ?evidence_document)
        (not
          (primary_profile_evidence_link ?primary_profile ?evidence_document)
        )
      )
  )
  (:action activate_requirement_set_for_secondary_profile
    :parameters (?secondary_profile - secondary_profile ?admission_category - admission_category ?policy_rule - policy_rule)
    :precondition
      (and
        (rule_interpreted ?secondary_profile)
        (case_linked_policy_rule ?secondary_profile ?policy_rule)
        (secondary_profile_admission_category ?secondary_profile ?admission_category)
        (not
          (admission_category_marked ?admission_category)
        )
        (not
          (admission_category_evidence_present ?admission_category)
        )
      )
    :effect (admission_category_marked ?admission_category)
  )
  (:action apply_verifier_findings_to_secondary_profile
    :parameters (?secondary_profile - secondary_profile ?admission_category - admission_category ?verifier_agent - verifier_agent)
    :precondition
      (and
        (rule_interpreted ?secondary_profile)
        (case_assigned_verifier ?secondary_profile ?verifier_agent)
        (secondary_profile_admission_category ?secondary_profile ?admission_category)
        (admission_category_marked ?admission_category)
        (not
          (secondary_profile_processing_started ?secondary_profile)
        )
      )
    :effect
      (and
        (secondary_profile_processing_started ?secondary_profile)
        (secondary_profile_requirements_met ?secondary_profile)
      )
  )
  (:action attach_evidence_to_secondary_profile
    :parameters (?secondary_profile - secondary_profile ?admission_category - admission_category ?evidence_document - evidence_document)
    :precondition
      (and
        (rule_interpreted ?secondary_profile)
        (secondary_profile_admission_category ?secondary_profile ?admission_category)
        (evidence_document_available ?evidence_document)
        (not
          (secondary_profile_processing_started ?secondary_profile)
        )
      )
    :effect
      (and
        (admission_category_evidence_present ?admission_category)
        (secondary_profile_processing_started ?secondary_profile)
        (secondary_profile_evidence_link ?secondary_profile ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action finalize_secondary_profile_requirement
    :parameters (?secondary_profile - secondary_profile ?admission_category - admission_category ?policy_rule - policy_rule ?evidence_document - evidence_document)
    :precondition
      (and
        (rule_interpreted ?secondary_profile)
        (case_linked_policy_rule ?secondary_profile ?policy_rule)
        (secondary_profile_admission_category ?secondary_profile ?admission_category)
        (admission_category_evidence_present ?admission_category)
        (secondary_profile_evidence_link ?secondary_profile ?evidence_document)
        (not
          (secondary_profile_requirements_met ?secondary_profile)
        )
      )
    :effect
      (and
        (admission_category_marked ?admission_category)
        (secondary_profile_requirements_met ?secondary_profile)
        (evidence_document_available ?evidence_document)
        (not
          (secondary_profile_evidence_link ?secondary_profile ?evidence_document)
        )
      )
  )
  (:action assemble_entry_package
    :parameters (?primary_profile - primary_profile ?secondary_profile - secondary_profile ?requirement_set - requirement_set ?admission_category - admission_category ?entry_package - entry_package)
    :precondition
      (and
        (primary_profile_processing_started ?primary_profile)
        (secondary_profile_processing_started ?secondary_profile)
        (profile_requirementset_link ?primary_profile ?requirement_set)
        (secondary_profile_admission_category ?secondary_profile ?admission_category)
        (requirement_set_activated ?requirement_set)
        (admission_category_marked ?admission_category)
        (primary_profile_requirements_met ?primary_profile)
        (secondary_profile_requirements_met ?secondary_profile)
        (entry_package_template_available ?entry_package)
      )
    :effect
      (and
        (entry_package_created ?entry_package)
        (entry_package_requirementset_link ?entry_package ?requirement_set)
        (entry_package_admission_category_link ?entry_package ?admission_category)
        (not
          (entry_package_template_available ?entry_package)
        )
      )
  )
  (:action assemble_entry_package_with_evidence_flag
    :parameters (?primary_profile - primary_profile ?secondary_profile - secondary_profile ?requirement_set - requirement_set ?admission_category - admission_category ?entry_package - entry_package)
    :precondition
      (and
        (primary_profile_processing_started ?primary_profile)
        (secondary_profile_processing_started ?secondary_profile)
        (profile_requirementset_link ?primary_profile ?requirement_set)
        (secondary_profile_admission_category ?secondary_profile ?admission_category)
        (requirement_set_evidence_present ?requirement_set)
        (admission_category_marked ?admission_category)
        (not
          (primary_profile_requirements_met ?primary_profile)
        )
        (secondary_profile_requirements_met ?secondary_profile)
        (entry_package_template_available ?entry_package)
      )
    :effect
      (and
        (entry_package_created ?entry_package)
        (entry_package_requirementset_link ?entry_package ?requirement_set)
        (entry_package_admission_category_link ?entry_package ?admission_category)
        (entry_package_flag_condition1 ?entry_package)
        (not
          (entry_package_template_available ?entry_package)
        )
      )
  )
  (:action assemble_entry_package_with_alternate_flag
    :parameters (?primary_profile - primary_profile ?secondary_profile - secondary_profile ?requirement_set - requirement_set ?admission_category - admission_category ?entry_package - entry_package)
    :precondition
      (and
        (primary_profile_processing_started ?primary_profile)
        (secondary_profile_processing_started ?secondary_profile)
        (profile_requirementset_link ?primary_profile ?requirement_set)
        (secondary_profile_admission_category ?secondary_profile ?admission_category)
        (requirement_set_activated ?requirement_set)
        (admission_category_evidence_present ?admission_category)
        (primary_profile_requirements_met ?primary_profile)
        (not
          (secondary_profile_requirements_met ?secondary_profile)
        )
        (entry_package_template_available ?entry_package)
      )
    :effect
      (and
        (entry_package_created ?entry_package)
        (entry_package_requirementset_link ?entry_package ?requirement_set)
        (entry_package_admission_category_link ?entry_package ?admission_category)
        (entry_package_flag_condition2 ?entry_package)
        (not
          (entry_package_template_available ?entry_package)
        )
      )
  )
  (:action assemble_entry_package_with_combined_flags
    :parameters (?primary_profile - primary_profile ?secondary_profile - secondary_profile ?requirement_set - requirement_set ?admission_category - admission_category ?entry_package - entry_package)
    :precondition
      (and
        (primary_profile_processing_started ?primary_profile)
        (secondary_profile_processing_started ?secondary_profile)
        (profile_requirementset_link ?primary_profile ?requirement_set)
        (secondary_profile_admission_category ?secondary_profile ?admission_category)
        (requirement_set_evidence_present ?requirement_set)
        (admission_category_evidence_present ?admission_category)
        (not
          (primary_profile_requirements_met ?primary_profile)
        )
        (not
          (secondary_profile_requirements_met ?secondary_profile)
        )
        (entry_package_template_available ?entry_package)
      )
    :effect
      (and
        (entry_package_created ?entry_package)
        (entry_package_requirementset_link ?entry_package ?requirement_set)
        (entry_package_admission_category_link ?entry_package ?admission_category)
        (entry_package_flag_condition1 ?entry_package)
        (entry_package_flag_condition2 ?entry_package)
        (not
          (entry_package_template_available ?entry_package)
        )
      )
  )
  (:action validate_entry_package
    :parameters (?entry_package - entry_package ?primary_profile - primary_profile ?policy_rule - policy_rule)
    :precondition
      (and
        (entry_package_created ?entry_package)
        (primary_profile_processing_started ?primary_profile)
        (case_linked_policy_rule ?primary_profile ?policy_rule)
        (not
          (entry_package_validated ?entry_package)
        )
      )
    :effect (entry_package_validated ?entry_package)
  )
  (:action consume_supporting_doc_type_for_processor
    :parameters (?processor - processor ?supporting_doc_type - supporting_document_type ?entry_package - entry_package)
    :precondition
      (and
        (rule_interpreted ?processor)
        (processor_assigned_entry_package ?processor ?entry_package)
        (processor_supporting_doc_type_link ?processor ?supporting_doc_type)
        (supporting_doc_type_available ?supporting_doc_type)
        (entry_package_created ?entry_package)
        (entry_package_validated ?entry_package)
        (not
          (supporting_doc_type_consumed ?supporting_doc_type)
        )
      )
    :effect
      (and
        (supporting_doc_type_consumed ?supporting_doc_type)
        (supporting_doc_type_linked_to_package ?supporting_doc_type ?entry_package)
        (not
          (supporting_doc_type_available ?supporting_doc_type)
        )
      )
  )
  (:action confirm_supporting_documents_for_processor
    :parameters (?processor - processor ?supporting_doc_type - supporting_document_type ?entry_package - entry_package ?policy_rule - policy_rule)
    :precondition
      (and
        (rule_interpreted ?processor)
        (processor_supporting_doc_type_link ?processor ?supporting_doc_type)
        (supporting_doc_type_consumed ?supporting_doc_type)
        (supporting_doc_type_linked_to_package ?supporting_doc_type ?entry_package)
        (case_linked_policy_rule ?processor ?policy_rule)
        (not
          (entry_package_flag_condition1 ?entry_package)
        )
        (not
          (processor_supporting_docs_verified ?processor)
        )
      )
    :effect (processor_supporting_docs_verified ?processor)
  )
  (:action assign_travel_purpose_to_processor
    :parameters (?processor - processor ?travel_purpose - travel_purpose)
    :precondition
      (and
        (rule_interpreted ?processor)
        (travel_purpose_available ?travel_purpose)
        (not
          (processor_purpose_attached ?processor)
        )
      )
    :effect
      (and
        (processor_purpose_attached ?processor)
        (processor_travel_purpose_link ?processor ?travel_purpose)
        (not
          (travel_purpose_available ?travel_purpose)
        )
      )
  )
  (:action advance_processor_purpose_workflow
    :parameters (?processor - processor ?supporting_doc_type - supporting_document_type ?entry_package - entry_package ?policy_rule - policy_rule ?travel_purpose - travel_purpose)
    :precondition
      (and
        (rule_interpreted ?processor)
        (processor_supporting_doc_type_link ?processor ?supporting_doc_type)
        (supporting_doc_type_consumed ?supporting_doc_type)
        (supporting_doc_type_linked_to_package ?supporting_doc_type ?entry_package)
        (case_linked_policy_rule ?processor ?policy_rule)
        (entry_package_flag_condition1 ?entry_package)
        (processor_purpose_attached ?processor)
        (processor_travel_purpose_link ?processor ?travel_purpose)
        (not
          (processor_supporting_docs_verified ?processor)
        )
      )
    :effect
      (and
        (processor_supporting_docs_verified ?processor)
        (processor_purpose_confirmed ?processor)
      )
  )
  (:action verify_processor_credentials_path_a
    :parameters (?processor - processor ?health_credential_type - health_credential_type ?verifier_agent - verifier_agent ?supporting_doc_type - supporting_document_type ?entry_package - entry_package)
    :precondition
      (and
        (processor_supporting_docs_verified ?processor)
        (processor_assigned_health_credential ?processor ?health_credential_type)
        (case_assigned_verifier ?processor ?verifier_agent)
        (processor_supporting_doc_type_link ?processor ?supporting_doc_type)
        (supporting_doc_type_linked_to_package ?supporting_doc_type ?entry_package)
        (not
          (entry_package_flag_condition2 ?entry_package)
        )
        (not
          (processor_credentials_verified ?processor)
        )
      )
    :effect (processor_credentials_verified ?processor)
  )
  (:action verify_processor_credentials_path_b
    :parameters (?processor - processor ?health_credential_type - health_credential_type ?verifier_agent - verifier_agent ?supporting_doc_type - supporting_document_type ?entry_package - entry_package)
    :precondition
      (and
        (processor_supporting_docs_verified ?processor)
        (processor_assigned_health_credential ?processor ?health_credential_type)
        (case_assigned_verifier ?processor ?verifier_agent)
        (processor_supporting_doc_type_link ?processor ?supporting_doc_type)
        (supporting_doc_type_linked_to_package ?supporting_doc_type ?entry_package)
        (entry_package_flag_condition2 ?entry_package)
        (not
          (processor_credentials_verified ?processor)
        )
      )
    :effect (processor_credentials_verified ?processor)
  )
  (:action prepare_processor_for_endorsement_part1
    :parameters (?processor - processor ?supporting_evidence_type - supporting_evidence_type ?supporting_doc_type - supporting_document_type ?entry_package - entry_package)
    :precondition
      (and
        (processor_credentials_verified ?processor)
        (processor_assigned_supporting_evidence ?processor ?supporting_evidence_type)
        (processor_supporting_doc_type_link ?processor ?supporting_doc_type)
        (supporting_doc_type_linked_to_package ?supporting_doc_type ?entry_package)
        (not
          (entry_package_flag_condition1 ?entry_package)
        )
        (not
          (entry_package_flag_condition2 ?entry_package)
        )
        (not
          (processor_endorsement_ready ?processor)
        )
      )
    :effect (processor_endorsement_ready ?processor)
  )
  (:action prepare_processor_for_endorsement_part2
    :parameters (?processor - processor ?supporting_evidence_type - supporting_evidence_type ?supporting_doc_type - supporting_document_type ?entry_package - entry_package)
    :precondition
      (and
        (processor_credentials_verified ?processor)
        (processor_assigned_supporting_evidence ?processor ?supporting_evidence_type)
        (processor_supporting_doc_type_link ?processor ?supporting_doc_type)
        (supporting_doc_type_linked_to_package ?supporting_doc_type ?entry_package)
        (entry_package_flag_condition1 ?entry_package)
        (not
          (entry_package_flag_condition2 ?entry_package)
        )
        (not
          (processor_endorsement_ready ?processor)
        )
      )
    :effect
      (and
        (processor_endorsement_ready ?processor)
        (processor_ready_for_finalization ?processor)
      )
  )
  (:action prepare_processor_for_endorsement_part3
    :parameters (?processor - processor ?supporting_evidence_type - supporting_evidence_type ?supporting_doc_type - supporting_document_type ?entry_package - entry_package)
    :precondition
      (and
        (processor_credentials_verified ?processor)
        (processor_assigned_supporting_evidence ?processor ?supporting_evidence_type)
        (processor_supporting_doc_type_link ?processor ?supporting_doc_type)
        (supporting_doc_type_linked_to_package ?supporting_doc_type ?entry_package)
        (not
          (entry_package_flag_condition1 ?entry_package)
        )
        (entry_package_flag_condition2 ?entry_package)
        (not
          (processor_endorsement_ready ?processor)
        )
      )
    :effect
      (and
        (processor_endorsement_ready ?processor)
        (processor_ready_for_finalization ?processor)
      )
  )
  (:action prepare_processor_for_endorsement_part4
    :parameters (?processor - processor ?supporting_evidence_type - supporting_evidence_type ?supporting_doc_type - supporting_document_type ?entry_package - entry_package)
    :precondition
      (and
        (processor_credentials_verified ?processor)
        (processor_assigned_supporting_evidence ?processor ?supporting_evidence_type)
        (processor_supporting_doc_type_link ?processor ?supporting_doc_type)
        (supporting_doc_type_linked_to_package ?supporting_doc_type ?entry_package)
        (entry_package_flag_condition1 ?entry_package)
        (entry_package_flag_condition2 ?entry_package)
        (not
          (processor_endorsement_ready ?processor)
        )
      )
    :effect
      (and
        (processor_endorsement_ready ?processor)
        (processor_ready_for_finalization ?processor)
      )
  )
  (:action finalize_processor_clearance
    :parameters (?processor - processor)
    :precondition
      (and
        (processor_endorsement_ready ?processor)
        (not
          (processor_ready_for_finalization ?processor)
        )
        (not
          (processor_finalized ?processor)
        )
      )
    :effect
      (and
        (processor_finalized ?processor)
        (clearance_granted ?processor)
      )
  )
  (:action assign_traveler_attribute_to_processor
    :parameters (?processor - processor ?traveler_attribute - traveler_attribute)
    :precondition
      (and
        (processor_endorsement_ready ?processor)
        (processor_ready_for_finalization ?processor)
        (traveler_attribute_available ?traveler_attribute)
      )
    :effect
      (and
        (processor_traveler_attribute_link ?processor ?traveler_attribute)
        (not
          (traveler_attribute_available ?traveler_attribute)
        )
      )
  )
  (:action combine_processor_evidence_and_finalize
    :parameters (?processor - processor ?primary_profile - primary_profile ?secondary_profile - secondary_profile ?policy_rule - policy_rule ?traveler_attribute - traveler_attribute)
    :precondition
      (and
        (processor_endorsement_ready ?processor)
        (processor_ready_for_finalization ?processor)
        (processor_traveler_attribute_link ?processor ?traveler_attribute)
        (processor_assigned_primary_profile ?processor ?primary_profile)
        (processor_assigned_secondary_profile ?processor ?secondary_profile)
        (primary_profile_requirements_met ?primary_profile)
        (secondary_profile_requirements_met ?secondary_profile)
        (case_linked_policy_rule ?processor ?policy_rule)
        (not
          (processor_combined_verification_applied ?processor)
        )
      )
    :effect (processor_combined_verification_applied ?processor)
  )
  (:action complete_processor_finalization
    :parameters (?processor - processor)
    :precondition
      (and
        (processor_endorsement_ready ?processor)
        (processor_combined_verification_applied ?processor)
        (not
          (processor_finalized ?processor)
        )
      )
    :effect
      (and
        (processor_finalized ?processor)
        (clearance_granted ?processor)
      )
  )
  (:action apply_country_ruleset_authorization
    :parameters (?processor - processor ?country_ruleset - country_ruleset ?policy_rule - policy_rule)
    :precondition
      (and
        (rule_interpreted ?processor)
        (case_linked_policy_rule ?processor ?policy_rule)
        (country_ruleset_available ?country_ruleset)
        (processor_country_ruleset_link ?processor ?country_ruleset)
        (not
          (processor_country_approved ?processor)
        )
      )
    :effect
      (and
        (processor_country_approved ?processor)
        (not
          (country_ruleset_available ?country_ruleset)
        )
      )
  )
  (:action apply_purpose_authorization
    :parameters (?processor - processor ?verifier_agent - verifier_agent)
    :precondition
      (and
        (processor_country_approved ?processor)
        (case_assigned_verifier ?processor ?verifier_agent)
        (not
          (processor_purpose_authorized ?processor)
        )
      )
    :effect (processor_purpose_authorized ?processor)
  )
  (:action apply_supporting_evidence_endorsement
    :parameters (?processor - processor ?supporting_evidence_type - supporting_evidence_type)
    :precondition
      (and
        (processor_purpose_authorized ?processor)
        (processor_assigned_supporting_evidence ?processor ?supporting_evidence_type)
        (not
          (processor_purpose_endorsement_confirmed ?processor)
        )
      )
    :effect (processor_purpose_endorsement_confirmed ?processor)
  )
  (:action finalize_purpose_endorsement_and_grant_clearance
    :parameters (?processor - processor)
    :precondition
      (and
        (processor_purpose_endorsement_confirmed ?processor)
        (not
          (processor_finalized ?processor)
        )
      )
    :effect
      (and
        (processor_finalized ?processor)
        (clearance_granted ?processor)
      )
  )
  (:action issue_clearance_to_primary_profile
    :parameters (?primary_profile - primary_profile ?entry_package - entry_package)
    :precondition
      (and
        (primary_profile_processing_started ?primary_profile)
        (primary_profile_requirements_met ?primary_profile)
        (entry_package_created ?entry_package)
        (entry_package_validated ?entry_package)
        (not
          (clearance_granted ?primary_profile)
        )
      )
    :effect (clearance_granted ?primary_profile)
  )
  (:action issue_clearance_to_secondary_profile
    :parameters (?secondary_profile - secondary_profile ?entry_package - entry_package)
    :precondition
      (and
        (secondary_profile_processing_started ?secondary_profile)
        (secondary_profile_requirements_met ?secondary_profile)
        (entry_package_created ?entry_package)
        (entry_package_validated ?entry_package)
        (not
          (clearance_granted ?secondary_profile)
        )
      )
    :effect (clearance_granted ?secondary_profile)
  )
  (:action confirm_case_eligibility_and_issue_token
    :parameters (?entry_case - entry_case ?issuance_token_type - issuance_token_type ?policy_rule - policy_rule)
    :precondition
      (and
        (clearance_granted ?entry_case)
        (case_linked_policy_rule ?entry_case ?policy_rule)
        (issuance_token_type_available ?issuance_token_type)
        (not
          (case_eligibility_confirmed ?entry_case)
        )
      )
    :effect
      (and
        (case_eligibility_confirmed ?entry_case)
        (case_issuance_token_link ?entry_case ?issuance_token_type)
        (not
          (issuance_token_type_available ?issuance_token_type)
        )
      )
  )
  (:action finalize_primary_profile_entry
    :parameters (?primary_profile - primary_profile ?document_resource - document_resource ?issuance_token_type - issuance_token_type)
    :precondition
      (and
        (case_eligibility_confirmed ?primary_profile)
        (case_has_document_resource ?primary_profile ?document_resource)
        (case_issuance_token_link ?primary_profile ?issuance_token_type)
        (not
          (entry_validation_confirmed ?primary_profile)
        )
      )
    :effect
      (and
        (entry_validation_confirmed ?primary_profile)
        (document_resource_available ?document_resource)
        (issuance_token_type_available ?issuance_token_type)
      )
  )
  (:action finalize_secondary_profile_entry
    :parameters (?secondary_profile - secondary_profile ?document_resource - document_resource ?issuance_token_type - issuance_token_type)
    :precondition
      (and
        (case_eligibility_confirmed ?secondary_profile)
        (case_has_document_resource ?secondary_profile ?document_resource)
        (case_issuance_token_link ?secondary_profile ?issuance_token_type)
        (not
          (entry_validation_confirmed ?secondary_profile)
        )
      )
    :effect
      (and
        (entry_validation_confirmed ?secondary_profile)
        (document_resource_available ?document_resource)
        (issuance_token_type_available ?issuance_token_type)
      )
  )
  (:action finalize_processor_entry
    :parameters (?processor - processor ?document_resource - document_resource ?issuance_token_type - issuance_token_type)
    :precondition
      (and
        (case_eligibility_confirmed ?processor)
        (case_has_document_resource ?processor ?document_resource)
        (case_issuance_token_link ?processor ?issuance_token_type)
        (not
          (entry_validation_confirmed ?processor)
        )
      )
    :effect
      (and
        (entry_validation_confirmed ?processor)
        (document_resource_available ?document_resource)
        (issuance_token_type_available ?issuance_token_type)
      )
  )
)

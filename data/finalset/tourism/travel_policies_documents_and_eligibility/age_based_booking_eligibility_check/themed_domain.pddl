(define (domain age_based_booking_eligibility)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object document_category - entity rule_category - entity role_category - entity case_category - entity eligibility_case - case_category document_type - document_category age_rule - document_category verifier_agent - document_category policy_modifier - document_category consent_form - document_category evidence_instance - document_category medical_exemption - document_category policy_exception - document_category supporting_document - rule_category document_template - rule_category guardian_consent - rule_category age_requirement_profile - role_category fare_category - role_category fare_component - role_category traveler_role - eligibility_case evaluation_component - eligibility_case primary_traveler - traveler_role accompanying_traveler - traveler_role evaluation_session - evaluation_component)

  (:predicates
    (case_initialized ?eligibility_case - eligibility_case)
    (entity_under_evaluation ?eligibility_case - eligibility_case)
    (documents_declared ?eligibility_case - eligibility_case)
    (entity_eligibility_recorded ?eligibility_case - eligibility_case)
    (entity_eligible ?eligibility_case - eligibility_case)
    (entity_verified ?eligibility_case - eligibility_case)
    (document_type_available ?document_type - document_type)
    (entity_document_binding ?eligibility_case - eligibility_case ?document_type - document_type)
    (age_rule_available ?age_rule - age_rule)
    (subject_age_rule_binding ?eligibility_case - eligibility_case ?age_rule - age_rule)
    (verifier_available ?verifier_agent - verifier_agent)
    (entity_verifier_assigned ?eligibility_case - eligibility_case ?verifier_agent - verifier_agent)
    (supporting_document_available ?supporting_document - supporting_document)
    (traveler_supporting_document_binding ?primary_traveler - primary_traveler ?supporting_document - supporting_document)
    (accompanying_supporting_document_binding ?accompanying_traveler - accompanying_traveler ?supporting_document - supporting_document)
    (traveler_age_requirement_profile ?primary_traveler - primary_traveler ?age_requirement_profile - age_requirement_profile)
    (age_requirement_profile_verified ?age_requirement_profile - age_requirement_profile)
    (age_requirement_evidence_linked ?age_requirement_profile - age_requirement_profile)
    (traveler_age_requirement_met ?primary_traveler - primary_traveler)
    (accompanying_fare_binding ?accompanying_traveler - accompanying_traveler ?fare_category - fare_category)
    (fare_category_verified ?fare_category - fare_category)
    (fare_category_evidence_linked ?fare_category - fare_category)
    (accompanying_requirements_met ?accompanying_traveler - accompanying_traveler)
    (fare_component_available ?fare_component - fare_component)
    (fare_component_ready ?fare_component - fare_component)
    (fare_component_age_profile_binding ?fare_component - fare_component ?age_requirement_profile - age_requirement_profile)
    (fare_component_fare_category_binding ?fare_component - fare_component ?fare_category - fare_category)
    (fare_component_requires_policy_modifier ?fare_component - fare_component)
    (fare_component_allows_policy_exception ?fare_component - fare_component)
    (fare_component_document_binding_ready ?fare_component - fare_component)
    (session_primary_traveler_binding ?evaluation_session - evaluation_session ?primary_traveler - primary_traveler)
    (session_accompanying_traveler_binding ?evaluation_session - evaluation_session ?accompanying_traveler - accompanying_traveler)
    (session_fare_component_binding ?evaluation_session - evaluation_session ?fare_component - fare_component)
    (document_template_available ?document_template - document_template)
    (session_has_template_binding ?evaluation_session - evaluation_session ?document_template - document_template)
    (document_template_validated ?document_template - document_template)
    (document_template_component_binding ?document_template - document_template ?fare_component - fare_component)
    (session_document_verified ?evaluation_session - evaluation_session)
    (session_exemption_applied ?evaluation_session - evaluation_session)
    (session_ready_for_finalization ?evaluation_session - evaluation_session)
    (policy_modifier_applied ?evaluation_session - evaluation_session)
    (session_policy_modifier_bound ?evaluation_session - evaluation_session)
    (session_modifier_confirmed ?evaluation_session - evaluation_session)
    (session_final_checks_completed ?evaluation_session - evaluation_session)
    (guardian_consent_available ?guardian_consent - guardian_consent)
    (session_guardian_consent_binding ?evaluation_session - evaluation_session ?guardian_consent - guardian_consent)
    (guardian_consent_linked ?evaluation_session - evaluation_session)
    (guardian_consent_verified ?evaluation_session - evaluation_session)
    (guardian_consent_accepted ?evaluation_session - evaluation_session)
    (policy_modifier_available ?policy_modifier - policy_modifier)
    (session_policy_modifier_binding ?evaluation_session - evaluation_session ?policy_modifier - policy_modifier)
    (consent_form_available ?consent_form - consent_form)
    (session_consent_form_binding ?evaluation_session - evaluation_session ?consent_form - consent_form)
    (medical_exemption_available ?medical_exemption - medical_exemption)
    (session_medical_exemption_binding ?evaluation_session - evaluation_session ?medical_exemption - medical_exemption)
    (policy_exception_available ?policy_exception - policy_exception)
    (session_policy_exception_binding ?evaluation_session - evaluation_session ?policy_exception - policy_exception)
    (evidence_instance_available ?evidence_instance - evidence_instance)
    (entity_evidence_binding ?eligibility_case - eligibility_case ?evidence_instance - evidence_instance)
    (traveler_ready_for_assembly ?primary_traveler - primary_traveler)
    (accompanying_traveler_ready_for_assembly ?accompanying_traveler - accompanying_traveler)
    (session_finalized ?evaluation_session - evaluation_session)
  )
  (:action initialize_subject_case
    :parameters (?eligibility_case - eligibility_case)
    :precondition
      (and
        (not
          (case_initialized ?eligibility_case)
        )
        (not
          (entity_eligibility_recorded ?eligibility_case)
        )
      )
    :effect (case_initialized ?eligibility_case)
  )
  (:action attach_document_type_to_subject
    :parameters (?eligibility_case - eligibility_case ?document_type - document_type)
    :precondition
      (and
        (case_initialized ?eligibility_case)
        (not
          (documents_declared ?eligibility_case)
        )
        (document_type_available ?document_type)
      )
    :effect
      (and
        (documents_declared ?eligibility_case)
        (entity_document_binding ?eligibility_case ?document_type)
        (not
          (document_type_available ?document_type)
        )
      )
  )
  (:action bind_subject_to_age_rule
    :parameters (?eligibility_case - eligibility_case ?age_rule - age_rule)
    :precondition
      (and
        (case_initialized ?eligibility_case)
        (documents_declared ?eligibility_case)
        (age_rule_available ?age_rule)
      )
    :effect
      (and
        (subject_age_rule_binding ?eligibility_case ?age_rule)
        (not
          (age_rule_available ?age_rule)
        )
      )
  )
  (:action activate_case_for_evaluation
    :parameters (?eligibility_case - eligibility_case ?age_rule - age_rule)
    :precondition
      (and
        (case_initialized ?eligibility_case)
        (documents_declared ?eligibility_case)
        (subject_age_rule_binding ?eligibility_case ?age_rule)
        (not
          (entity_under_evaluation ?eligibility_case)
        )
      )
    :effect (entity_under_evaluation ?eligibility_case)
  )
  (:action retract_subject_age_rule_binding
    :parameters (?eligibility_case - eligibility_case ?age_rule - age_rule)
    :precondition
      (and
        (subject_age_rule_binding ?eligibility_case ?age_rule)
      )
    :effect
      (and
        (age_rule_available ?age_rule)
        (not
          (subject_age_rule_binding ?eligibility_case ?age_rule)
        )
      )
  )
  (:action assign_verifier_to_case
    :parameters (?eligibility_case - eligibility_case ?verifier_agent - verifier_agent)
    :precondition
      (and
        (entity_under_evaluation ?eligibility_case)
        (verifier_available ?verifier_agent)
      )
    :effect
      (and
        (entity_verifier_assigned ?eligibility_case ?verifier_agent)
        (not
          (verifier_available ?verifier_agent)
        )
      )
  )
  (:action unassign_verifier_from_case
    :parameters (?eligibility_case - eligibility_case ?verifier_agent - verifier_agent)
    :precondition
      (and
        (entity_verifier_assigned ?eligibility_case ?verifier_agent)
      )
    :effect
      (and
        (verifier_available ?verifier_agent)
        (not
          (entity_verifier_assigned ?eligibility_case ?verifier_agent)
        )
      )
  )
  (:action apply_medical_exemption_to_session
    :parameters (?evaluation_session - evaluation_session ?medical_exemption - medical_exemption)
    :precondition
      (and
        (entity_under_evaluation ?evaluation_session)
        (medical_exemption_available ?medical_exemption)
      )
    :effect
      (and
        (session_medical_exemption_binding ?evaluation_session ?medical_exemption)
        (not
          (medical_exemption_available ?medical_exemption)
        )
      )
  )
  (:action retract_medical_exemption_from_session
    :parameters (?evaluation_session - evaluation_session ?medical_exemption - medical_exemption)
    :precondition
      (and
        (session_medical_exemption_binding ?evaluation_session ?medical_exemption)
      )
    :effect
      (and
        (medical_exemption_available ?medical_exemption)
        (not
          (session_medical_exemption_binding ?evaluation_session ?medical_exemption)
        )
      )
  )
  (:action apply_policy_exception_to_session
    :parameters (?evaluation_session - evaluation_session ?policy_exception - policy_exception)
    :precondition
      (and
        (entity_under_evaluation ?evaluation_session)
        (policy_exception_available ?policy_exception)
      )
    :effect
      (and
        (session_policy_exception_binding ?evaluation_session ?policy_exception)
        (not
          (policy_exception_available ?policy_exception)
        )
      )
  )
  (:action retract_policy_exception_from_session
    :parameters (?evaluation_session - evaluation_session ?policy_exception - policy_exception)
    :precondition
      (and
        (session_policy_exception_binding ?evaluation_session ?policy_exception)
      )
    :effect
      (and
        (policy_exception_available ?policy_exception)
        (not
          (session_policy_exception_binding ?evaluation_session ?policy_exception)
        )
      )
  )
  (:action evaluate_age_requirement_for_traveler
    :parameters (?primary_traveler - primary_traveler ?age_requirement_profile - age_requirement_profile ?age_rule - age_rule)
    :precondition
      (and
        (entity_under_evaluation ?primary_traveler)
        (subject_age_rule_binding ?primary_traveler ?age_rule)
        (traveler_age_requirement_profile ?primary_traveler ?age_requirement_profile)
        (not
          (age_requirement_profile_verified ?age_requirement_profile)
        )
        (not
          (age_requirement_evidence_linked ?age_requirement_profile)
        )
      )
    :effect (age_requirement_profile_verified ?age_requirement_profile)
  )
  (:action record_verifier_confirmation
    :parameters (?primary_traveler - primary_traveler ?age_requirement_profile - age_requirement_profile ?verifier_agent - verifier_agent)
    :precondition
      (and
        (entity_under_evaluation ?primary_traveler)
        (entity_verifier_assigned ?primary_traveler ?verifier_agent)
        (traveler_age_requirement_profile ?primary_traveler ?age_requirement_profile)
        (age_requirement_profile_verified ?age_requirement_profile)
        (not
          (traveler_ready_for_assembly ?primary_traveler)
        )
      )
    :effect
      (and
        (traveler_ready_for_assembly ?primary_traveler)
        (traveler_age_requirement_met ?primary_traveler)
      )
  )
  (:action attach_supporting_document
    :parameters (?primary_traveler - primary_traveler ?age_requirement_profile - age_requirement_profile ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_under_evaluation ?primary_traveler)
        (traveler_age_requirement_profile ?primary_traveler ?age_requirement_profile)
        (supporting_document_available ?supporting_document)
        (not
          (traveler_ready_for_assembly ?primary_traveler)
        )
      )
    :effect
      (and
        (age_requirement_evidence_linked ?age_requirement_profile)
        (traveler_ready_for_assembly ?primary_traveler)
        (traveler_supporting_document_binding ?primary_traveler ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_traveler_age_requirement
    :parameters (?primary_traveler - primary_traveler ?age_requirement_profile - age_requirement_profile ?age_rule - age_rule ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_under_evaluation ?primary_traveler)
        (subject_age_rule_binding ?primary_traveler ?age_rule)
        (traveler_age_requirement_profile ?primary_traveler ?age_requirement_profile)
        (age_requirement_evidence_linked ?age_requirement_profile)
        (traveler_supporting_document_binding ?primary_traveler ?supporting_document)
        (not
          (traveler_age_requirement_met ?primary_traveler)
        )
      )
    :effect
      (and
        (age_requirement_profile_verified ?age_requirement_profile)
        (traveler_age_requirement_met ?primary_traveler)
        (supporting_document_available ?supporting_document)
        (not
          (traveler_supporting_document_binding ?primary_traveler ?supporting_document)
        )
      )
  )
  (:action evaluate_accompanying_traveler_requirement
    :parameters (?accompanying_traveler - accompanying_traveler ?fare_category - fare_category ?age_rule - age_rule)
    :precondition
      (and
        (entity_under_evaluation ?accompanying_traveler)
        (subject_age_rule_binding ?accompanying_traveler ?age_rule)
        (accompanying_fare_binding ?accompanying_traveler ?fare_category)
        (not
          (fare_category_verified ?fare_category)
        )
        (not
          (fare_category_evidence_linked ?fare_category)
        )
      )
    :effect (fare_category_verified ?fare_category)
  )
  (:action record_accompanying_verifier_confirmation
    :parameters (?accompanying_traveler - accompanying_traveler ?fare_category - fare_category ?verifier_agent - verifier_agent)
    :precondition
      (and
        (entity_under_evaluation ?accompanying_traveler)
        (entity_verifier_assigned ?accompanying_traveler ?verifier_agent)
        (accompanying_fare_binding ?accompanying_traveler ?fare_category)
        (fare_category_verified ?fare_category)
        (not
          (accompanying_traveler_ready_for_assembly ?accompanying_traveler)
        )
      )
    :effect
      (and
        (accompanying_traveler_ready_for_assembly ?accompanying_traveler)
        (accompanying_requirements_met ?accompanying_traveler)
      )
  )
  (:action attach_supporting_document_accompanying
    :parameters (?accompanying_traveler - accompanying_traveler ?fare_category - fare_category ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_under_evaluation ?accompanying_traveler)
        (accompanying_fare_binding ?accompanying_traveler ?fare_category)
        (supporting_document_available ?supporting_document)
        (not
          (accompanying_traveler_ready_for_assembly ?accompanying_traveler)
        )
      )
    :effect
      (and
        (fare_category_evidence_linked ?fare_category)
        (accompanying_traveler_ready_for_assembly ?accompanying_traveler)
        (accompanying_supporting_document_binding ?accompanying_traveler ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_accompanying_traveler_age_requirement
    :parameters (?accompanying_traveler - accompanying_traveler ?fare_category - fare_category ?age_rule - age_rule ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_under_evaluation ?accompanying_traveler)
        (subject_age_rule_binding ?accompanying_traveler ?age_rule)
        (accompanying_fare_binding ?accompanying_traveler ?fare_category)
        (fare_category_evidence_linked ?fare_category)
        (accompanying_supporting_document_binding ?accompanying_traveler ?supporting_document)
        (not
          (accompanying_requirements_met ?accompanying_traveler)
        )
      )
    :effect
      (and
        (fare_category_verified ?fare_category)
        (accompanying_requirements_met ?accompanying_traveler)
        (supporting_document_available ?supporting_document)
        (not
          (accompanying_supporting_document_binding ?accompanying_traveler ?supporting_document)
        )
      )
  )
  (:action assemble_fare_component_basic
    :parameters (?primary_traveler - primary_traveler ?accompanying_traveler - accompanying_traveler ?age_requirement_profile - age_requirement_profile ?fare_category - fare_category ?fare_component - fare_component)
    :precondition
      (and
        (traveler_ready_for_assembly ?primary_traveler)
        (accompanying_traveler_ready_for_assembly ?accompanying_traveler)
        (traveler_age_requirement_profile ?primary_traveler ?age_requirement_profile)
        (accompanying_fare_binding ?accompanying_traveler ?fare_category)
        (age_requirement_profile_verified ?age_requirement_profile)
        (fare_category_verified ?fare_category)
        (traveler_age_requirement_met ?primary_traveler)
        (accompanying_requirements_met ?accompanying_traveler)
        (fare_component_available ?fare_component)
      )
    :effect
      (and
        (fare_component_ready ?fare_component)
        (fare_component_age_profile_binding ?fare_component ?age_requirement_profile)
        (fare_component_fare_category_binding ?fare_component ?fare_category)
        (not
          (fare_component_available ?fare_component)
        )
      )
  )
  (:action assemble_fare_component_with_modifier
    :parameters (?primary_traveler - primary_traveler ?accompanying_traveler - accompanying_traveler ?age_requirement_profile - age_requirement_profile ?fare_category - fare_category ?fare_component - fare_component)
    :precondition
      (and
        (traveler_ready_for_assembly ?primary_traveler)
        (accompanying_traveler_ready_for_assembly ?accompanying_traveler)
        (traveler_age_requirement_profile ?primary_traveler ?age_requirement_profile)
        (accompanying_fare_binding ?accompanying_traveler ?fare_category)
        (age_requirement_evidence_linked ?age_requirement_profile)
        (fare_category_verified ?fare_category)
        (not
          (traveler_age_requirement_met ?primary_traveler)
        )
        (accompanying_requirements_met ?accompanying_traveler)
        (fare_component_available ?fare_component)
      )
    :effect
      (and
        (fare_component_ready ?fare_component)
        (fare_component_age_profile_binding ?fare_component ?age_requirement_profile)
        (fare_component_fare_category_binding ?fare_component ?fare_category)
        (fare_component_requires_policy_modifier ?fare_component)
        (not
          (fare_component_available ?fare_component)
        )
      )
  )
  (:action assemble_fare_component_with_exception
    :parameters (?primary_traveler - primary_traveler ?accompanying_traveler - accompanying_traveler ?age_requirement_profile - age_requirement_profile ?fare_category - fare_category ?fare_component - fare_component)
    :precondition
      (and
        (traveler_ready_for_assembly ?primary_traveler)
        (accompanying_traveler_ready_for_assembly ?accompanying_traveler)
        (traveler_age_requirement_profile ?primary_traveler ?age_requirement_profile)
        (accompanying_fare_binding ?accompanying_traveler ?fare_category)
        (age_requirement_profile_verified ?age_requirement_profile)
        (fare_category_evidence_linked ?fare_category)
        (traveler_age_requirement_met ?primary_traveler)
        (not
          (accompanying_requirements_met ?accompanying_traveler)
        )
        (fare_component_available ?fare_component)
      )
    :effect
      (and
        (fare_component_ready ?fare_component)
        (fare_component_age_profile_binding ?fare_component ?age_requirement_profile)
        (fare_component_fare_category_binding ?fare_component ?fare_category)
        (fare_component_allows_policy_exception ?fare_component)
        (not
          (fare_component_available ?fare_component)
        )
      )
  )
  (:action assemble_fare_component_with_modifier_and_exception
    :parameters (?primary_traveler - primary_traveler ?accompanying_traveler - accompanying_traveler ?age_requirement_profile - age_requirement_profile ?fare_category - fare_category ?fare_component - fare_component)
    :precondition
      (and
        (traveler_ready_for_assembly ?primary_traveler)
        (accompanying_traveler_ready_for_assembly ?accompanying_traveler)
        (traveler_age_requirement_profile ?primary_traveler ?age_requirement_profile)
        (accompanying_fare_binding ?accompanying_traveler ?fare_category)
        (age_requirement_evidence_linked ?age_requirement_profile)
        (fare_category_evidence_linked ?fare_category)
        (not
          (traveler_age_requirement_met ?primary_traveler)
        )
        (not
          (accompanying_requirements_met ?accompanying_traveler)
        )
        (fare_component_available ?fare_component)
      )
    :effect
      (and
        (fare_component_ready ?fare_component)
        (fare_component_age_profile_binding ?fare_component ?age_requirement_profile)
        (fare_component_fare_category_binding ?fare_component ?fare_category)
        (fare_component_requires_policy_modifier ?fare_component)
        (fare_component_allows_policy_exception ?fare_component)
        (not
          (fare_component_available ?fare_component)
        )
      )
  )
  (:action prepare_fare_component_for_document_binding
    :parameters (?fare_component - fare_component ?primary_traveler - primary_traveler ?age_rule - age_rule)
    :precondition
      (and
        (fare_component_ready ?fare_component)
        (traveler_ready_for_assembly ?primary_traveler)
        (subject_age_rule_binding ?primary_traveler ?age_rule)
        (not
          (fare_component_document_binding_ready ?fare_component)
        )
      )
    :effect (fare_component_document_binding_ready ?fare_component)
  )
  (:action bind_document_template
    :parameters (?evaluation_session - evaluation_session ?document_template - document_template ?fare_component - fare_component)
    :precondition
      (and
        (entity_under_evaluation ?evaluation_session)
        (session_fare_component_binding ?evaluation_session ?fare_component)
        (session_has_template_binding ?evaluation_session ?document_template)
        (document_template_available ?document_template)
        (fare_component_ready ?fare_component)
        (fare_component_document_binding_ready ?fare_component)
        (not
          (document_template_validated ?document_template)
        )
      )
    :effect
      (and
        (document_template_validated ?document_template)
        (document_template_component_binding ?document_template ?fare_component)
        (not
          (document_template_available ?document_template)
        )
      )
  )
  (:action validate_document_template
    :parameters (?evaluation_session - evaluation_session ?document_template - document_template ?fare_component - fare_component ?age_rule - age_rule)
    :precondition
      (and
        (entity_under_evaluation ?evaluation_session)
        (session_has_template_binding ?evaluation_session ?document_template)
        (document_template_validated ?document_template)
        (document_template_component_binding ?document_template ?fare_component)
        (subject_age_rule_binding ?evaluation_session ?age_rule)
        (not
          (fare_component_requires_policy_modifier ?fare_component)
        )
        (not
          (session_document_verified ?evaluation_session)
        )
      )
    :effect (session_document_verified ?evaluation_session)
  )
  (:action assign_policy_modifier_to_session
    :parameters (?evaluation_session - evaluation_session ?policy_modifier - policy_modifier)
    :precondition
      (and
        (entity_under_evaluation ?evaluation_session)
        (policy_modifier_available ?policy_modifier)
        (not
          (policy_modifier_applied ?evaluation_session)
        )
      )
    :effect
      (and
        (policy_modifier_applied ?evaluation_session)
        (session_policy_modifier_binding ?evaluation_session ?policy_modifier)
        (not
          (policy_modifier_available ?policy_modifier)
        )
      )
  )
  (:action apply_policy_modifier_and_validate_template
    :parameters (?evaluation_session - evaluation_session ?document_template - document_template ?fare_component - fare_component ?age_rule - age_rule ?policy_modifier - policy_modifier)
    :precondition
      (and
        (entity_under_evaluation ?evaluation_session)
        (session_has_template_binding ?evaluation_session ?document_template)
        (document_template_validated ?document_template)
        (document_template_component_binding ?document_template ?fare_component)
        (subject_age_rule_binding ?evaluation_session ?age_rule)
        (fare_component_requires_policy_modifier ?fare_component)
        (policy_modifier_applied ?evaluation_session)
        (session_policy_modifier_binding ?evaluation_session ?policy_modifier)
        (not
          (session_document_verified ?evaluation_session)
        )
      )
    :effect
      (and
        (session_document_verified ?evaluation_session)
        (session_policy_modifier_bound ?evaluation_session)
      )
  )
  (:action apply_medical_exemption_and_mark
    :parameters (?evaluation_session - evaluation_session ?medical_exemption - medical_exemption ?verifier_agent - verifier_agent ?document_template - document_template ?fare_component - fare_component)
    :precondition
      (and
        (session_document_verified ?evaluation_session)
        (session_medical_exemption_binding ?evaluation_session ?medical_exemption)
        (entity_verifier_assigned ?evaluation_session ?verifier_agent)
        (session_has_template_binding ?evaluation_session ?document_template)
        (document_template_component_binding ?document_template ?fare_component)
        (not
          (fare_component_allows_policy_exception ?fare_component)
        )
        (not
          (session_exemption_applied ?evaluation_session)
        )
      )
    :effect (session_exemption_applied ?evaluation_session)
  )
  (:action apply_medical_exemption_for_variant
    :parameters (?evaluation_session - evaluation_session ?medical_exemption - medical_exemption ?verifier_agent - verifier_agent ?document_template - document_template ?fare_component - fare_component)
    :precondition
      (and
        (session_document_verified ?evaluation_session)
        (session_medical_exemption_binding ?evaluation_session ?medical_exemption)
        (entity_verifier_assigned ?evaluation_session ?verifier_agent)
        (session_has_template_binding ?evaluation_session ?document_template)
        (document_template_component_binding ?document_template ?fare_component)
        (fare_component_allows_policy_exception ?fare_component)
        (not
          (session_exemption_applied ?evaluation_session)
        )
      )
    :effect (session_exemption_applied ?evaluation_session)
  )
  (:action apply_policy_exception
    :parameters (?evaluation_session - evaluation_session ?policy_exception - policy_exception ?document_template - document_template ?fare_component - fare_component)
    :precondition
      (and
        (session_exemption_applied ?evaluation_session)
        (session_policy_exception_binding ?evaluation_session ?policy_exception)
        (session_has_template_binding ?evaluation_session ?document_template)
        (document_template_component_binding ?document_template ?fare_component)
        (not
          (fare_component_requires_policy_modifier ?fare_component)
        )
        (not
          (fare_component_allows_policy_exception ?fare_component)
        )
        (not
          (session_ready_for_finalization ?evaluation_session)
        )
      )
    :effect (session_ready_for_finalization ?evaluation_session)
  )
  (:action apply_policy_exception_with_modifier
    :parameters (?evaluation_session - evaluation_session ?policy_exception - policy_exception ?document_template - document_template ?fare_component - fare_component)
    :precondition
      (and
        (session_exemption_applied ?evaluation_session)
        (session_policy_exception_binding ?evaluation_session ?policy_exception)
        (session_has_template_binding ?evaluation_session ?document_template)
        (document_template_component_binding ?document_template ?fare_component)
        (fare_component_requires_policy_modifier ?fare_component)
        (not
          (fare_component_allows_policy_exception ?fare_component)
        )
        (not
          (session_ready_for_finalization ?evaluation_session)
        )
      )
    :effect
      (and
        (session_ready_for_finalization ?evaluation_session)
        (session_modifier_confirmed ?evaluation_session)
      )
  )
  (:action apply_policy_exception_variant
    :parameters (?evaluation_session - evaluation_session ?policy_exception - policy_exception ?document_template - document_template ?fare_component - fare_component)
    :precondition
      (and
        (session_exemption_applied ?evaluation_session)
        (session_policy_exception_binding ?evaluation_session ?policy_exception)
        (session_has_template_binding ?evaluation_session ?document_template)
        (document_template_component_binding ?document_template ?fare_component)
        (not
          (fare_component_requires_policy_modifier ?fare_component)
        )
        (fare_component_allows_policy_exception ?fare_component)
        (not
          (session_ready_for_finalization ?evaluation_session)
        )
      )
    :effect
      (and
        (session_ready_for_finalization ?evaluation_session)
        (session_modifier_confirmed ?evaluation_session)
      )
  )
  (:action apply_policy_exception_with_modifier_and_flag
    :parameters (?evaluation_session - evaluation_session ?policy_exception - policy_exception ?document_template - document_template ?fare_component - fare_component)
    :precondition
      (and
        (session_exemption_applied ?evaluation_session)
        (session_policy_exception_binding ?evaluation_session ?policy_exception)
        (session_has_template_binding ?evaluation_session ?document_template)
        (document_template_component_binding ?document_template ?fare_component)
        (fare_component_requires_policy_modifier ?fare_component)
        (fare_component_allows_policy_exception ?fare_component)
        (not
          (session_ready_for_finalization ?evaluation_session)
        )
      )
    :effect
      (and
        (session_ready_for_finalization ?evaluation_session)
        (session_modifier_confirmed ?evaluation_session)
      )
  )
  (:action finalize_session_without_modifier
    :parameters (?evaluation_session - evaluation_session)
    :precondition
      (and
        (session_ready_for_finalization ?evaluation_session)
        (not
          (session_modifier_confirmed ?evaluation_session)
        )
        (not
          (session_finalized ?evaluation_session)
        )
      )
    :effect
      (and
        (session_finalized ?evaluation_session)
        (entity_eligible ?evaluation_session)
      )
  )
  (:action attach_consent_form
    :parameters (?evaluation_session - evaluation_session ?consent_form - consent_form)
    :precondition
      (and
        (session_ready_for_finalization ?evaluation_session)
        (session_modifier_confirmed ?evaluation_session)
        (consent_form_available ?consent_form)
      )
    :effect
      (and
        (session_consent_form_binding ?evaluation_session ?consent_form)
        (not
          (consent_form_available ?consent_form)
        )
      )
  )
  (:action final_checks_and_mark_session
    :parameters (?evaluation_session - evaluation_session ?primary_traveler - primary_traveler ?accompanying_traveler - accompanying_traveler ?age_rule - age_rule ?consent_form - consent_form)
    :precondition
      (and
        (session_ready_for_finalization ?evaluation_session)
        (session_modifier_confirmed ?evaluation_session)
        (session_consent_form_binding ?evaluation_session ?consent_form)
        (session_primary_traveler_binding ?evaluation_session ?primary_traveler)
        (session_accompanying_traveler_binding ?evaluation_session ?accompanying_traveler)
        (traveler_age_requirement_met ?primary_traveler)
        (accompanying_requirements_met ?accompanying_traveler)
        (subject_age_rule_binding ?evaluation_session ?age_rule)
        (not
          (session_final_checks_completed ?evaluation_session)
        )
      )
    :effect (session_final_checks_completed ?evaluation_session)
  )
  (:action finalize_session_with_checks
    :parameters (?evaluation_session - evaluation_session)
    :precondition
      (and
        (session_ready_for_finalization ?evaluation_session)
        (session_final_checks_completed ?evaluation_session)
        (not
          (session_finalized ?evaluation_session)
        )
      )
    :effect
      (and
        (session_finalized ?evaluation_session)
        (entity_eligible ?evaluation_session)
      )
  )
  (:action link_guardian_consent_to_session
    :parameters (?evaluation_session - evaluation_session ?guardian_consent - guardian_consent ?age_rule - age_rule)
    :precondition
      (and
        (entity_under_evaluation ?evaluation_session)
        (subject_age_rule_binding ?evaluation_session ?age_rule)
        (guardian_consent_available ?guardian_consent)
        (session_guardian_consent_binding ?evaluation_session ?guardian_consent)
        (not
          (guardian_consent_linked ?evaluation_session)
        )
      )
    :effect
      (and
        (guardian_consent_linked ?evaluation_session)
        (not
          (guardian_consent_available ?guardian_consent)
        )
      )
  )
  (:action verify_guardian_consent
    :parameters (?evaluation_session - evaluation_session ?verifier_agent - verifier_agent)
    :precondition
      (and
        (guardian_consent_linked ?evaluation_session)
        (entity_verifier_assigned ?evaluation_session ?verifier_agent)
        (not
          (guardian_consent_verified ?evaluation_session)
        )
      )
    :effect (guardian_consent_verified ?evaluation_session)
  )
  (:action verify_policy_exception
    :parameters (?evaluation_session - evaluation_session ?policy_exception - policy_exception)
    :precondition
      (and
        (guardian_consent_verified ?evaluation_session)
        (session_policy_exception_binding ?evaluation_session ?policy_exception)
        (not
          (guardian_consent_accepted ?evaluation_session)
        )
      )
    :effect (guardian_consent_accepted ?evaluation_session)
  )
  (:action finalize_session_after_guardian_consent
    :parameters (?evaluation_session - evaluation_session)
    :precondition
      (and
        (guardian_consent_accepted ?evaluation_session)
        (not
          (session_finalized ?evaluation_session)
        )
      )
    :effect
      (and
        (session_finalized ?evaluation_session)
        (entity_eligible ?evaluation_session)
      )
  )
  (:action persist_traveler_eligibility
    :parameters (?primary_traveler - primary_traveler ?fare_component - fare_component)
    :precondition
      (and
        (traveler_ready_for_assembly ?primary_traveler)
        (traveler_age_requirement_met ?primary_traveler)
        (fare_component_ready ?fare_component)
        (fare_component_document_binding_ready ?fare_component)
        (not
          (entity_eligible ?primary_traveler)
        )
      )
    :effect (entity_eligible ?primary_traveler)
  )
  (:action persist_accompanying_eligibility
    :parameters (?accompanying_traveler - accompanying_traveler ?fare_component - fare_component)
    :precondition
      (and
        (accompanying_traveler_ready_for_assembly ?accompanying_traveler)
        (accompanying_requirements_met ?accompanying_traveler)
        (fare_component_ready ?fare_component)
        (fare_component_document_binding_ready ?fare_component)
        (not
          (entity_eligible ?accompanying_traveler)
        )
      )
    :effect (entity_eligible ?accompanying_traveler)
  )
  (:action record_evidence_for_case
    :parameters (?eligibility_case - eligibility_case ?evidence_instance - evidence_instance ?age_rule - age_rule)
    :precondition
      (and
        (entity_eligible ?eligibility_case)
        (subject_age_rule_binding ?eligibility_case ?age_rule)
        (evidence_instance_available ?evidence_instance)
        (not
          (entity_verified ?eligibility_case)
        )
      )
    :effect
      (and
        (entity_verified ?eligibility_case)
        (entity_evidence_binding ?eligibility_case ?evidence_instance)
        (not
          (evidence_instance_available ?evidence_instance)
        )
      )
  )
  (:action finalize_traveler_eligibility_and_release_document
    :parameters (?primary_traveler - primary_traveler ?document_type - document_type ?evidence_instance - evidence_instance)
    :precondition
      (and
        (entity_verified ?primary_traveler)
        (entity_document_binding ?primary_traveler ?document_type)
        (entity_evidence_binding ?primary_traveler ?evidence_instance)
        (not
          (entity_eligibility_recorded ?primary_traveler)
        )
      )
    :effect
      (and
        (entity_eligibility_recorded ?primary_traveler)
        (document_type_available ?document_type)
        (evidence_instance_available ?evidence_instance)
      )
  )
  (:action persist_accompanying_eligibility_and_release_document
    :parameters (?accompanying_traveler - accompanying_traveler ?document_type - document_type ?evidence_instance - evidence_instance)
    :precondition
      (and
        (entity_verified ?accompanying_traveler)
        (entity_document_binding ?accompanying_traveler ?document_type)
        (entity_evidence_binding ?accompanying_traveler ?evidence_instance)
        (not
          (entity_eligibility_recorded ?accompanying_traveler)
        )
      )
    :effect
      (and
        (entity_eligibility_recorded ?accompanying_traveler)
        (document_type_available ?document_type)
        (evidence_instance_available ?evidence_instance)
      )
  )
  (:action finalize_session_and_release_document
    :parameters (?evaluation_session - evaluation_session ?document_type - document_type ?evidence_instance - evidence_instance)
    :precondition
      (and
        (entity_verified ?evaluation_session)
        (entity_document_binding ?evaluation_session ?document_type)
        (entity_evidence_binding ?evaluation_session ?evidence_instance)
        (not
          (entity_eligibility_recorded ?evaluation_session)
        )
      )
    :effect
      (and
        (entity_eligibility_recorded ?evaluation_session)
        (document_type_available ?document_type)
        (evidence_instance_available ?evidence_instance)
      )
  )
)

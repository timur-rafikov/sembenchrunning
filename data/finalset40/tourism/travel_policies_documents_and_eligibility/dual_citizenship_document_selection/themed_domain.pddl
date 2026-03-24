(define (domain tourism_dual_citizenship_document_selection_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object domain_component - domain_object regulation_category - domain_object document_category - domain_object case_root - domain_object case_record - case_root document_source_option - domain_component regulation - domain_component verification_step - domain_component consular_response_type - domain_component policy_preference - domain_component evidence_item_type - domain_component fee_category - domain_component special_authorization - domain_component supporting_document_type - regulation_category document_instance - regulation_category exception_reason - regulation_category entry_requirement_primary - document_category entry_requirement_secondary - document_category document_package_option - document_category citizenship_profile - case_record traveler_profile_group - case_record primary_citizenship_profile - citizenship_profile secondary_citizenship_profile - citizenship_profile traveler_variant - traveler_profile_group)

  (:predicates
    (entity_initialized ?case_record - case_record)
    (entity_rules_applied ?case_record - case_record)
    (entity_source_selected ?case_record - case_record)
    (approval_propagated ?case_record - case_record)
    (eligibility_confirmed ?case_record - case_record)
    (eligibility_committed ?case_record - case_record)
    (source_available ?document_source_option - document_source_option)
    (entity_linked_to_source ?case_record - case_record ?document_source_option - document_source_option)
    (regulation_available ?regulation - regulation)
    (entity_assigned_regulation ?case_record - case_record ?regulation - regulation)
    (verification_step_available ?verification_step - verification_step)
    (entity_assigned_verification_step ?case_record - case_record ?verification_step - verification_step)
    (supporting_document_available ?supporting_document_type - supporting_document_type)
    (primary_profile_assigned_supporting_document ?primary_citizenship_profile - primary_citizenship_profile ?supporting_document_type - supporting_document_type)
    (secondary_profile_assigned_supporting_document ?secondary_citizenship_profile - secondary_citizenship_profile ?supporting_document_type - supporting_document_type)
    (primary_profile_has_requirement_set ?primary_citizenship_profile - primary_citizenship_profile ?entry_requirement_primary - entry_requirement_primary)
    (primary_requirement_flagged ?entry_requirement_primary - entry_requirement_primary)
    (primary_requirement_satisfied ?entry_requirement_primary - entry_requirement_primary)
    (primary_profile_requirements_met ?primary_citizenship_profile - primary_citizenship_profile)
    (secondary_profile_has_requirement_set ?secondary_citizenship_profile - secondary_citizenship_profile ?entry_requirement_secondary - entry_requirement_secondary)
    (secondary_requirement_flagged ?entry_requirement_secondary - entry_requirement_secondary)
    (secondary_requirement_satisfied ?entry_requirement_secondary - entry_requirement_secondary)
    (secondary_profile_requirements_met ?secondary_citizenship_profile - secondary_citizenship_profile)
    (package_option_available ?document_package_option - document_package_option)
    (package_option_generated ?document_package_option - document_package_option)
    (package_covers_primary_requirement ?document_package_option - document_package_option ?entry_requirement_primary - entry_requirement_primary)
    (package_covers_secondary_requirement ?document_package_option - document_package_option ?entry_requirement_secondary - entry_requirement_secondary)
    (package_flag_primary_condition ?document_package_option - document_package_option)
    (package_flag_secondary_condition ?document_package_option - document_package_option)
    (package_locked ?document_package_option - document_package_option)
    (variant_links_primary_profile ?traveler_variant - traveler_variant ?primary_citizenship_profile - primary_citizenship_profile)
    (variant_links_secondary_profile ?traveler_variant - traveler_variant ?secondary_citizenship_profile - secondary_citizenship_profile)
    (variant_has_package_option ?traveler_variant - traveler_variant ?document_package_option - document_package_option)
    (document_instance_available ?document_instance - document_instance)
    (variant_has_document_instance ?traveler_variant - traveler_variant ?document_instance - document_instance)
    (document_instance_assigned ?document_instance - document_instance)
    (document_instance_assigned_to_package ?document_instance - document_instance ?document_package_option - document_package_option)
    (variant_document_assignment_confirmed ?traveler_variant - traveler_variant)
    (consular_response_received ?traveler_variant - traveler_variant)
    (variant_ready_for_adjudication ?traveler_variant - traveler_variant)
    (consular_request_made ?traveler_variant - traveler_variant)
    (variant_consular_response_applied ?traveler_variant - traveler_variant)
    (variant_preferences_attached ?traveler_variant - traveler_variant)
    (variant_adjudication_ready ?traveler_variant - traveler_variant)
    (exception_reason_available ?exception_reason - exception_reason)
    (variant_assigned_exception_reason ?traveler_variant - traveler_variant ?exception_reason - exception_reason)
    (variant_exception_flag ?traveler_variant - traveler_variant)
    (variant_exception_step_recorded ?traveler_variant - traveler_variant)
    (variant_exception_finalization_ready ?traveler_variant - traveler_variant)
    (consular_response_type_available ?consular_response_type - consular_response_type)
    (variant_assigned_consular_response_type ?traveler_variant - traveler_variant ?consular_response_type - consular_response_type)
    (policy_preference_available ?policy_preference - policy_preference)
    (variant_assigned_policy_preference ?traveler_variant - traveler_variant ?policy_preference - policy_preference)
    (fee_category_available ?fee_category - fee_category)
    (variant_assigned_fee_category ?traveler_variant - traveler_variant ?fee_category - fee_category)
    (special_authorization_available ?special_authorization - special_authorization)
    (variant_assigned_special_authorization ?traveler_variant - traveler_variant ?special_authorization - special_authorization)
    (evidence_item_available ?evidence_item_type - evidence_item_type)
    (entity_has_evidence_item ?case_record - case_record ?evidence_item_type - evidence_item_type)
    (primary_profile_preliminary_matched ?primary_citizenship_profile - primary_citizenship_profile)
    (secondary_profile_preliminary_matched ?secondary_citizenship_profile - secondary_citizenship_profile)
    (variant_finalized ?traveler_variant - traveler_variant)
  )
  (:action initialize_case_record
    :parameters (?case_record - case_record)
    :precondition
      (and
        (not
          (entity_initialized ?case_record)
        )
        (not
          (approval_propagated ?case_record)
        )
      )
    :effect (entity_initialized ?case_record)
  )
  (:action select_document_source_for_case
    :parameters (?case_record - case_record ?document_source_option - document_source_option)
    :precondition
      (and
        (entity_initialized ?case_record)
        (not
          (entity_source_selected ?case_record)
        )
        (source_available ?document_source_option)
      )
    :effect
      (and
        (entity_source_selected ?case_record)
        (entity_linked_to_source ?case_record ?document_source_option)
        (not
          (source_available ?document_source_option)
        )
      )
  )
  (:action assign_regulation_to_case
    :parameters (?case_record - case_record ?regulation - regulation)
    :precondition
      (and
        (entity_initialized ?case_record)
        (entity_source_selected ?case_record)
        (regulation_available ?regulation)
      )
    :effect
      (and
        (entity_assigned_regulation ?case_record ?regulation)
        (not
          (regulation_available ?regulation)
        )
      )
  )
  (:action mark_regulation_applied_to_case
    :parameters (?case_record - case_record ?regulation - regulation)
    :precondition
      (and
        (entity_initialized ?case_record)
        (entity_source_selected ?case_record)
        (entity_assigned_regulation ?case_record ?regulation)
        (not
          (entity_rules_applied ?case_record)
        )
      )
    :effect (entity_rules_applied ?case_record)
  )
  (:action release_regulation_from_case
    :parameters (?case_record - case_record ?regulation - regulation)
    :precondition
      (and
        (entity_assigned_regulation ?case_record ?regulation)
      )
    :effect
      (and
        (regulation_available ?regulation)
        (not
          (entity_assigned_regulation ?case_record ?regulation)
        )
      )
  )
  (:action attach_verification_step_to_case
    :parameters (?case_record - case_record ?verification_step - verification_step)
    :precondition
      (and
        (entity_rules_applied ?case_record)
        (verification_step_available ?verification_step)
      )
    :effect
      (and
        (entity_assigned_verification_step ?case_record ?verification_step)
        (not
          (verification_step_available ?verification_step)
        )
      )
  )
  (:action deselect_verification_step_for_case
    :parameters (?case_record - case_record ?verification_step - verification_step)
    :precondition
      (and
        (entity_assigned_verification_step ?case_record ?verification_step)
      )
    :effect
      (and
        (verification_step_available ?verification_step)
        (not
          (entity_assigned_verification_step ?case_record ?verification_step)
        )
      )
  )
  (:action attach_fee_category_to_variant
    :parameters (?traveler_variant - traveler_variant ?fee_category - fee_category)
    :precondition
      (and
        (entity_rules_applied ?traveler_variant)
        (fee_category_available ?fee_category)
      )
    :effect
      (and
        (variant_assigned_fee_category ?traveler_variant ?fee_category)
        (not
          (fee_category_available ?fee_category)
        )
      )
  )
  (:action detach_fee_category_from_variant
    :parameters (?traveler_variant - traveler_variant ?fee_category - fee_category)
    :precondition
      (and
        (variant_assigned_fee_category ?traveler_variant ?fee_category)
      )
    :effect
      (and
        (fee_category_available ?fee_category)
        (not
          (variant_assigned_fee_category ?traveler_variant ?fee_category)
        )
      )
  )
  (:action attach_special_authorization_to_variant
    :parameters (?traveler_variant - traveler_variant ?special_authorization - special_authorization)
    :precondition
      (and
        (entity_rules_applied ?traveler_variant)
        (special_authorization_available ?special_authorization)
      )
    :effect
      (and
        (variant_assigned_special_authorization ?traveler_variant ?special_authorization)
        (not
          (special_authorization_available ?special_authorization)
        )
      )
  )
  (:action detach_special_authorization_from_variant
    :parameters (?traveler_variant - traveler_variant ?special_authorization - special_authorization)
    :precondition
      (and
        (variant_assigned_special_authorization ?traveler_variant ?special_authorization)
      )
    :effect
      (and
        (special_authorization_available ?special_authorization)
        (not
          (variant_assigned_special_authorization ?traveler_variant ?special_authorization)
        )
      )
  )
  (:action discover_primary_requirement_set
    :parameters (?primary_citizenship_profile - primary_citizenship_profile ?entry_requirement_primary - entry_requirement_primary ?regulation - regulation)
    :precondition
      (and
        (entity_rules_applied ?primary_citizenship_profile)
        (entity_assigned_regulation ?primary_citizenship_profile ?regulation)
        (primary_profile_has_requirement_set ?primary_citizenship_profile ?entry_requirement_primary)
        (not
          (primary_requirement_flagged ?entry_requirement_primary)
        )
        (not
          (primary_requirement_satisfied ?entry_requirement_primary)
        )
      )
    :effect (primary_requirement_flagged ?entry_requirement_primary)
  )
  (:action evaluate_primary_profile_requirement_match
    :parameters (?primary_citizenship_profile - primary_citizenship_profile ?entry_requirement_primary - entry_requirement_primary ?verification_step - verification_step)
    :precondition
      (and
        (entity_rules_applied ?primary_citizenship_profile)
        (entity_assigned_verification_step ?primary_citizenship_profile ?verification_step)
        (primary_profile_has_requirement_set ?primary_citizenship_profile ?entry_requirement_primary)
        (primary_requirement_flagged ?entry_requirement_primary)
        (not
          (primary_profile_preliminary_matched ?primary_citizenship_profile)
        )
      )
    :effect
      (and
        (primary_profile_preliminary_matched ?primary_citizenship_profile)
        (primary_profile_requirements_met ?primary_citizenship_profile)
      )
  )
  (:action assign_supporting_document_to_primary_profile_requirement
    :parameters (?primary_citizenship_profile - primary_citizenship_profile ?entry_requirement_primary - entry_requirement_primary ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (entity_rules_applied ?primary_citizenship_profile)
        (primary_profile_has_requirement_set ?primary_citizenship_profile ?entry_requirement_primary)
        (supporting_document_available ?supporting_document_type)
        (not
          (primary_profile_preliminary_matched ?primary_citizenship_profile)
        )
      )
    :effect
      (and
        (primary_requirement_satisfied ?entry_requirement_primary)
        (primary_profile_preliminary_matched ?primary_citizenship_profile)
        (primary_profile_assigned_supporting_document ?primary_citizenship_profile ?supporting_document_type)
        (not
          (supporting_document_available ?supporting_document_type)
        )
      )
  )
  (:action apply_supporting_document_to_primary_requirement
    :parameters (?primary_citizenship_profile - primary_citizenship_profile ?entry_requirement_primary - entry_requirement_primary ?regulation - regulation ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (entity_rules_applied ?primary_citizenship_profile)
        (entity_assigned_regulation ?primary_citizenship_profile ?regulation)
        (primary_profile_has_requirement_set ?primary_citizenship_profile ?entry_requirement_primary)
        (primary_requirement_satisfied ?entry_requirement_primary)
        (primary_profile_assigned_supporting_document ?primary_citizenship_profile ?supporting_document_type)
        (not
          (primary_profile_requirements_met ?primary_citizenship_profile)
        )
      )
    :effect
      (and
        (primary_requirement_flagged ?entry_requirement_primary)
        (primary_profile_requirements_met ?primary_citizenship_profile)
        (supporting_document_available ?supporting_document_type)
        (not
          (primary_profile_assigned_supporting_document ?primary_citizenship_profile ?supporting_document_type)
        )
      )
  )
  (:action discover_secondary_requirement_set
    :parameters (?secondary_citizenship_profile - secondary_citizenship_profile ?entry_requirement_secondary - entry_requirement_secondary ?regulation - regulation)
    :precondition
      (and
        (entity_rules_applied ?secondary_citizenship_profile)
        (entity_assigned_regulation ?secondary_citizenship_profile ?regulation)
        (secondary_profile_has_requirement_set ?secondary_citizenship_profile ?entry_requirement_secondary)
        (not
          (secondary_requirement_flagged ?entry_requirement_secondary)
        )
        (not
          (secondary_requirement_satisfied ?entry_requirement_secondary)
        )
      )
    :effect (secondary_requirement_flagged ?entry_requirement_secondary)
  )
  (:action evaluate_secondary_profile_requirement_match
    :parameters (?secondary_citizenship_profile - secondary_citizenship_profile ?entry_requirement_secondary - entry_requirement_secondary ?verification_step - verification_step)
    :precondition
      (and
        (entity_rules_applied ?secondary_citizenship_profile)
        (entity_assigned_verification_step ?secondary_citizenship_profile ?verification_step)
        (secondary_profile_has_requirement_set ?secondary_citizenship_profile ?entry_requirement_secondary)
        (secondary_requirement_flagged ?entry_requirement_secondary)
        (not
          (secondary_profile_preliminary_matched ?secondary_citizenship_profile)
        )
      )
    :effect
      (and
        (secondary_profile_preliminary_matched ?secondary_citizenship_profile)
        (secondary_profile_requirements_met ?secondary_citizenship_profile)
      )
  )
  (:action assign_supporting_document_to_secondary_profile_requirement
    :parameters (?secondary_citizenship_profile - secondary_citizenship_profile ?entry_requirement_secondary - entry_requirement_secondary ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (entity_rules_applied ?secondary_citizenship_profile)
        (secondary_profile_has_requirement_set ?secondary_citizenship_profile ?entry_requirement_secondary)
        (supporting_document_available ?supporting_document_type)
        (not
          (secondary_profile_preliminary_matched ?secondary_citizenship_profile)
        )
      )
    :effect
      (and
        (secondary_requirement_satisfied ?entry_requirement_secondary)
        (secondary_profile_preliminary_matched ?secondary_citizenship_profile)
        (secondary_profile_assigned_supporting_document ?secondary_citizenship_profile ?supporting_document_type)
        (not
          (supporting_document_available ?supporting_document_type)
        )
      )
  )
  (:action apply_supporting_document_to_secondary_requirement
    :parameters (?secondary_citizenship_profile - secondary_citizenship_profile ?entry_requirement_secondary - entry_requirement_secondary ?regulation - regulation ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (entity_rules_applied ?secondary_citizenship_profile)
        (entity_assigned_regulation ?secondary_citizenship_profile ?regulation)
        (secondary_profile_has_requirement_set ?secondary_citizenship_profile ?entry_requirement_secondary)
        (secondary_requirement_satisfied ?entry_requirement_secondary)
        (secondary_profile_assigned_supporting_document ?secondary_citizenship_profile ?supporting_document_type)
        (not
          (secondary_profile_requirements_met ?secondary_citizenship_profile)
        )
      )
    :effect
      (and
        (secondary_requirement_flagged ?entry_requirement_secondary)
        (secondary_profile_requirements_met ?secondary_citizenship_profile)
        (supporting_document_available ?supporting_document_type)
        (not
          (secondary_profile_assigned_supporting_document ?secondary_citizenship_profile ?supporting_document_type)
        )
      )
  )
  (:action generate_document_package_option
    :parameters (?primary_citizenship_profile - primary_citizenship_profile ?secondary_citizenship_profile - secondary_citizenship_profile ?entry_requirement_primary - entry_requirement_primary ?entry_requirement_secondary - entry_requirement_secondary ?document_package_option - document_package_option)
    :precondition
      (and
        (primary_profile_preliminary_matched ?primary_citizenship_profile)
        (secondary_profile_preliminary_matched ?secondary_citizenship_profile)
        (primary_profile_has_requirement_set ?primary_citizenship_profile ?entry_requirement_primary)
        (secondary_profile_has_requirement_set ?secondary_citizenship_profile ?entry_requirement_secondary)
        (primary_requirement_flagged ?entry_requirement_primary)
        (secondary_requirement_flagged ?entry_requirement_secondary)
        (primary_profile_requirements_met ?primary_citizenship_profile)
        (secondary_profile_requirements_met ?secondary_citizenship_profile)
        (package_option_available ?document_package_option)
      )
    :effect
      (and
        (package_option_generated ?document_package_option)
        (package_covers_primary_requirement ?document_package_option ?entry_requirement_primary)
        (package_covers_secondary_requirement ?document_package_option ?entry_requirement_secondary)
        (not
          (package_option_available ?document_package_option)
        )
      )
  )
  (:action generate_document_package_option_with_primary_condition
    :parameters (?primary_citizenship_profile - primary_citizenship_profile ?secondary_citizenship_profile - secondary_citizenship_profile ?entry_requirement_primary - entry_requirement_primary ?entry_requirement_secondary - entry_requirement_secondary ?document_package_option - document_package_option)
    :precondition
      (and
        (primary_profile_preliminary_matched ?primary_citizenship_profile)
        (secondary_profile_preliminary_matched ?secondary_citizenship_profile)
        (primary_profile_has_requirement_set ?primary_citizenship_profile ?entry_requirement_primary)
        (secondary_profile_has_requirement_set ?secondary_citizenship_profile ?entry_requirement_secondary)
        (primary_requirement_satisfied ?entry_requirement_primary)
        (secondary_requirement_flagged ?entry_requirement_secondary)
        (not
          (primary_profile_requirements_met ?primary_citizenship_profile)
        )
        (secondary_profile_requirements_met ?secondary_citizenship_profile)
        (package_option_available ?document_package_option)
      )
    :effect
      (and
        (package_option_generated ?document_package_option)
        (package_covers_primary_requirement ?document_package_option ?entry_requirement_primary)
        (package_covers_secondary_requirement ?document_package_option ?entry_requirement_secondary)
        (package_flag_primary_condition ?document_package_option)
        (not
          (package_option_available ?document_package_option)
        )
      )
  )
  (:action generate_document_package_option_with_secondary_condition
    :parameters (?primary_citizenship_profile - primary_citizenship_profile ?secondary_citizenship_profile - secondary_citizenship_profile ?entry_requirement_primary - entry_requirement_primary ?entry_requirement_secondary - entry_requirement_secondary ?document_package_option - document_package_option)
    :precondition
      (and
        (primary_profile_preliminary_matched ?primary_citizenship_profile)
        (secondary_profile_preliminary_matched ?secondary_citizenship_profile)
        (primary_profile_has_requirement_set ?primary_citizenship_profile ?entry_requirement_primary)
        (secondary_profile_has_requirement_set ?secondary_citizenship_profile ?entry_requirement_secondary)
        (primary_requirement_flagged ?entry_requirement_primary)
        (secondary_requirement_satisfied ?entry_requirement_secondary)
        (primary_profile_requirements_met ?primary_citizenship_profile)
        (not
          (secondary_profile_requirements_met ?secondary_citizenship_profile)
        )
        (package_option_available ?document_package_option)
      )
    :effect
      (and
        (package_option_generated ?document_package_option)
        (package_covers_primary_requirement ?document_package_option ?entry_requirement_primary)
        (package_covers_secondary_requirement ?document_package_option ?entry_requirement_secondary)
        (package_flag_secondary_condition ?document_package_option)
        (not
          (package_option_available ?document_package_option)
        )
      )
  )
  (:action generate_document_package_option_with_both_conditions
    :parameters (?primary_citizenship_profile - primary_citizenship_profile ?secondary_citizenship_profile - secondary_citizenship_profile ?entry_requirement_primary - entry_requirement_primary ?entry_requirement_secondary - entry_requirement_secondary ?document_package_option - document_package_option)
    :precondition
      (and
        (primary_profile_preliminary_matched ?primary_citizenship_profile)
        (secondary_profile_preliminary_matched ?secondary_citizenship_profile)
        (primary_profile_has_requirement_set ?primary_citizenship_profile ?entry_requirement_primary)
        (secondary_profile_has_requirement_set ?secondary_citizenship_profile ?entry_requirement_secondary)
        (primary_requirement_satisfied ?entry_requirement_primary)
        (secondary_requirement_satisfied ?entry_requirement_secondary)
        (not
          (primary_profile_requirements_met ?primary_citizenship_profile)
        )
        (not
          (secondary_profile_requirements_met ?secondary_citizenship_profile)
        )
        (package_option_available ?document_package_option)
      )
    :effect
      (and
        (package_option_generated ?document_package_option)
        (package_covers_primary_requirement ?document_package_option ?entry_requirement_primary)
        (package_covers_secondary_requirement ?document_package_option ?entry_requirement_secondary)
        (package_flag_primary_condition ?document_package_option)
        (package_flag_secondary_condition ?document_package_option)
        (not
          (package_option_available ?document_package_option)
        )
      )
  )
  (:action lock_package_option_with_primary_requirement
    :parameters (?document_package_option - document_package_option ?primary_citizenship_profile - primary_citizenship_profile ?regulation - regulation)
    :precondition
      (and
        (package_option_generated ?document_package_option)
        (primary_profile_preliminary_matched ?primary_citizenship_profile)
        (entity_assigned_regulation ?primary_citizenship_profile ?regulation)
        (not
          (package_locked ?document_package_option)
        )
      )
    :effect (package_locked ?document_package_option)
  )
  (:action assign_document_instance_to_package
    :parameters (?traveler_variant - traveler_variant ?document_instance - document_instance ?document_package_option - document_package_option)
    :precondition
      (and
        (entity_rules_applied ?traveler_variant)
        (variant_has_package_option ?traveler_variant ?document_package_option)
        (variant_has_document_instance ?traveler_variant ?document_instance)
        (document_instance_available ?document_instance)
        (package_option_generated ?document_package_option)
        (package_locked ?document_package_option)
        (not
          (document_instance_assigned ?document_instance)
        )
      )
    :effect
      (and
        (document_instance_assigned ?document_instance)
        (document_instance_assigned_to_package ?document_instance ?document_package_option)
        (not
          (document_instance_available ?document_instance)
        )
      )
  )
  (:action confirm_document_assignment_for_variant
    :parameters (?traveler_variant - traveler_variant ?document_instance - document_instance ?document_package_option - document_package_option ?regulation - regulation)
    :precondition
      (and
        (entity_rules_applied ?traveler_variant)
        (variant_has_document_instance ?traveler_variant ?document_instance)
        (document_instance_assigned ?document_instance)
        (document_instance_assigned_to_package ?document_instance ?document_package_option)
        (entity_assigned_regulation ?traveler_variant ?regulation)
        (not
          (package_flag_primary_condition ?document_package_option)
        )
        (not
          (variant_document_assignment_confirmed ?traveler_variant)
        )
      )
    :effect (variant_document_assignment_confirmed ?traveler_variant)
  )
  (:action request_consular_response_for_variant
    :parameters (?traveler_variant - traveler_variant ?consular_response_type - consular_response_type)
    :precondition
      (and
        (entity_rules_applied ?traveler_variant)
        (consular_response_type_available ?consular_response_type)
        (not
          (consular_request_made ?traveler_variant)
        )
      )
    :effect
      (and
        (consular_request_made ?traveler_variant)
        (variant_assigned_consular_response_type ?traveler_variant ?consular_response_type)
        (not
          (consular_response_type_available ?consular_response_type)
        )
      )
  )
  (:action apply_consular_response_to_variant
    :parameters (?traveler_variant - traveler_variant ?document_instance - document_instance ?document_package_option - document_package_option ?regulation - regulation ?consular_response_type - consular_response_type)
    :precondition
      (and
        (entity_rules_applied ?traveler_variant)
        (variant_has_document_instance ?traveler_variant ?document_instance)
        (document_instance_assigned ?document_instance)
        (document_instance_assigned_to_package ?document_instance ?document_package_option)
        (entity_assigned_regulation ?traveler_variant ?regulation)
        (package_flag_primary_condition ?document_package_option)
        (consular_request_made ?traveler_variant)
        (variant_assigned_consular_response_type ?traveler_variant ?consular_response_type)
        (not
          (variant_document_assignment_confirmed ?traveler_variant)
        )
      )
    :effect
      (and
        (variant_document_assignment_confirmed ?traveler_variant)
        (variant_consular_response_applied ?traveler_variant)
      )
  )
  (:action apply_consular_response_with_fee_and_document
    :parameters (?traveler_variant - traveler_variant ?fee_category - fee_category ?verification_step - verification_step ?document_instance - document_instance ?document_package_option - document_package_option)
    :precondition
      (and
        (variant_document_assignment_confirmed ?traveler_variant)
        (variant_assigned_fee_category ?traveler_variant ?fee_category)
        (entity_assigned_verification_step ?traveler_variant ?verification_step)
        (variant_has_document_instance ?traveler_variant ?document_instance)
        (document_instance_assigned_to_package ?document_instance ?document_package_option)
        (not
          (package_flag_secondary_condition ?document_package_option)
        )
        (not
          (consular_response_received ?traveler_variant)
        )
      )
    :effect (consular_response_received ?traveler_variant)
  )
  (:action apply_consular_response_with_fee_and_document_alternate
    :parameters (?traveler_variant - traveler_variant ?fee_category - fee_category ?verification_step - verification_step ?document_instance - document_instance ?document_package_option - document_package_option)
    :precondition
      (and
        (variant_document_assignment_confirmed ?traveler_variant)
        (variant_assigned_fee_category ?traveler_variant ?fee_category)
        (entity_assigned_verification_step ?traveler_variant ?verification_step)
        (variant_has_document_instance ?traveler_variant ?document_instance)
        (document_instance_assigned_to_package ?document_instance ?document_package_option)
        (package_flag_secondary_condition ?document_package_option)
        (not
          (consular_response_received ?traveler_variant)
        )
      )
    :effect (consular_response_received ?traveler_variant)
  )
  (:action apply_special_authorization_stage1
    :parameters (?traveler_variant - traveler_variant ?special_authorization - special_authorization ?document_instance - document_instance ?document_package_option - document_package_option)
    :precondition
      (and
        (consular_response_received ?traveler_variant)
        (variant_assigned_special_authorization ?traveler_variant ?special_authorization)
        (variant_has_document_instance ?traveler_variant ?document_instance)
        (document_instance_assigned_to_package ?document_instance ?document_package_option)
        (not
          (package_flag_primary_condition ?document_package_option)
        )
        (not
          (package_flag_secondary_condition ?document_package_option)
        )
        (not
          (variant_ready_for_adjudication ?traveler_variant)
        )
      )
    :effect (variant_ready_for_adjudication ?traveler_variant)
  )
  (:action apply_special_authorization_stage2
    :parameters (?traveler_variant - traveler_variant ?special_authorization - special_authorization ?document_instance - document_instance ?document_package_option - document_package_option)
    :precondition
      (and
        (consular_response_received ?traveler_variant)
        (variant_assigned_special_authorization ?traveler_variant ?special_authorization)
        (variant_has_document_instance ?traveler_variant ?document_instance)
        (document_instance_assigned_to_package ?document_instance ?document_package_option)
        (package_flag_primary_condition ?document_package_option)
        (not
          (package_flag_secondary_condition ?document_package_option)
        )
        (not
          (variant_ready_for_adjudication ?traveler_variant)
        )
      )
    :effect
      (and
        (variant_ready_for_adjudication ?traveler_variant)
        (variant_preferences_attached ?traveler_variant)
      )
  )
  (:action apply_special_authorization_stage3
    :parameters (?traveler_variant - traveler_variant ?special_authorization - special_authorization ?document_instance - document_instance ?document_package_option - document_package_option)
    :precondition
      (and
        (consular_response_received ?traveler_variant)
        (variant_assigned_special_authorization ?traveler_variant ?special_authorization)
        (variant_has_document_instance ?traveler_variant ?document_instance)
        (document_instance_assigned_to_package ?document_instance ?document_package_option)
        (not
          (package_flag_primary_condition ?document_package_option)
        )
        (package_flag_secondary_condition ?document_package_option)
        (not
          (variant_ready_for_adjudication ?traveler_variant)
        )
      )
    :effect
      (and
        (variant_ready_for_adjudication ?traveler_variant)
        (variant_preferences_attached ?traveler_variant)
      )
  )
  (:action apply_special_authorization_stage4
    :parameters (?traveler_variant - traveler_variant ?special_authorization - special_authorization ?document_instance - document_instance ?document_package_option - document_package_option)
    :precondition
      (and
        (consular_response_received ?traveler_variant)
        (variant_assigned_special_authorization ?traveler_variant ?special_authorization)
        (variant_has_document_instance ?traveler_variant ?document_instance)
        (document_instance_assigned_to_package ?document_instance ?document_package_option)
        (package_flag_primary_condition ?document_package_option)
        (package_flag_secondary_condition ?document_package_option)
        (not
          (variant_ready_for_adjudication ?traveler_variant)
        )
      )
    :effect
      (and
        (variant_ready_for_adjudication ?traveler_variant)
        (variant_preferences_attached ?traveler_variant)
      )
  )
  (:action finalize_variant_adjudication
    :parameters (?traveler_variant - traveler_variant)
    :precondition
      (and
        (variant_ready_for_adjudication ?traveler_variant)
        (not
          (variant_preferences_attached ?traveler_variant)
        )
        (not
          (variant_finalized ?traveler_variant)
        )
      )
    :effect
      (and
        (variant_finalized ?traveler_variant)
        (eligibility_confirmed ?traveler_variant)
      )
  )
  (:action attach_policy_preference_to_variant
    :parameters (?traveler_variant - traveler_variant ?policy_preference - policy_preference)
    :precondition
      (and
        (variant_ready_for_adjudication ?traveler_variant)
        (variant_preferences_attached ?traveler_variant)
        (policy_preference_available ?policy_preference)
      )
    :effect
      (and
        (variant_assigned_policy_preference ?traveler_variant ?policy_preference)
        (not
          (policy_preference_available ?policy_preference)
        )
      )
  )
  (:action complete_variant_adjudication_with_preferences
    :parameters (?traveler_variant - traveler_variant ?primary_citizenship_profile - primary_citizenship_profile ?secondary_citizenship_profile - secondary_citizenship_profile ?regulation - regulation ?policy_preference - policy_preference)
    :precondition
      (and
        (variant_ready_for_adjudication ?traveler_variant)
        (variant_preferences_attached ?traveler_variant)
        (variant_assigned_policy_preference ?traveler_variant ?policy_preference)
        (variant_links_primary_profile ?traveler_variant ?primary_citizenship_profile)
        (variant_links_secondary_profile ?traveler_variant ?secondary_citizenship_profile)
        (primary_profile_requirements_met ?primary_citizenship_profile)
        (secondary_profile_requirements_met ?secondary_citizenship_profile)
        (entity_assigned_regulation ?traveler_variant ?regulation)
        (not
          (variant_adjudication_ready ?traveler_variant)
        )
      )
    :effect (variant_adjudication_ready ?traveler_variant)
  )
  (:action finalize_variant_adjudication_after_adjudication_ready
    :parameters (?traveler_variant - traveler_variant)
    :precondition
      (and
        (variant_ready_for_adjudication ?traveler_variant)
        (variant_adjudication_ready ?traveler_variant)
        (not
          (variant_finalized ?traveler_variant)
        )
      )
    :effect
      (and
        (variant_finalized ?traveler_variant)
        (eligibility_confirmed ?traveler_variant)
      )
  )
  (:action initiate_exception_handling_for_variant
    :parameters (?traveler_variant - traveler_variant ?exception_reason - exception_reason ?regulation - regulation)
    :precondition
      (and
        (entity_rules_applied ?traveler_variant)
        (entity_assigned_regulation ?traveler_variant ?regulation)
        (exception_reason_available ?exception_reason)
        (variant_assigned_exception_reason ?traveler_variant ?exception_reason)
        (not
          (variant_exception_flag ?traveler_variant)
        )
      )
    :effect
      (and
        (variant_exception_flag ?traveler_variant)
        (not
          (exception_reason_available ?exception_reason)
        )
      )
  )
  (:action apply_exception_verification_step
    :parameters (?traveler_variant - traveler_variant ?verification_step - verification_step)
    :precondition
      (and
        (variant_exception_flag ?traveler_variant)
        (entity_assigned_verification_step ?traveler_variant ?verification_step)
        (not
          (variant_exception_step_recorded ?traveler_variant)
        )
      )
    :effect (variant_exception_step_recorded ?traveler_variant)
  )
  (:action apply_special_authorization_in_exception_flow
    :parameters (?traveler_variant - traveler_variant ?special_authorization - special_authorization)
    :precondition
      (and
        (variant_exception_step_recorded ?traveler_variant)
        (variant_assigned_special_authorization ?traveler_variant ?special_authorization)
        (not
          (variant_exception_finalization_ready ?traveler_variant)
        )
      )
    :effect (variant_exception_finalization_ready ?traveler_variant)
  )
  (:action finalize_exception_branch_for_variant
    :parameters (?traveler_variant - traveler_variant)
    :precondition
      (and
        (variant_exception_finalization_ready ?traveler_variant)
        (not
          (variant_finalized ?traveler_variant)
        )
      )
    :effect
      (and
        (variant_finalized ?traveler_variant)
        (eligibility_confirmed ?traveler_variant)
      )
  )
  (:action grant_final_eligibility_to_primary_profile
    :parameters (?primary_citizenship_profile - primary_citizenship_profile ?document_package_option - document_package_option)
    :precondition
      (and
        (primary_profile_preliminary_matched ?primary_citizenship_profile)
        (primary_profile_requirements_met ?primary_citizenship_profile)
        (package_option_generated ?document_package_option)
        (package_locked ?document_package_option)
        (not
          (eligibility_confirmed ?primary_citizenship_profile)
        )
      )
    :effect (eligibility_confirmed ?primary_citizenship_profile)
  )
  (:action grant_final_eligibility_to_secondary_profile
    :parameters (?secondary_citizenship_profile - secondary_citizenship_profile ?document_package_option - document_package_option)
    :precondition
      (and
        (secondary_profile_preliminary_matched ?secondary_citizenship_profile)
        (secondary_profile_requirements_met ?secondary_citizenship_profile)
        (package_option_generated ?document_package_option)
        (package_locked ?document_package_option)
        (not
          (eligibility_confirmed ?secondary_citizenship_profile)
        )
      )
    :effect (eligibility_confirmed ?secondary_citizenship_profile)
  )
  (:action apply_evidence_to_case_record
    :parameters (?case_record - case_record ?evidence_item_type - evidence_item_type ?regulation - regulation)
    :precondition
      (and
        (eligibility_confirmed ?case_record)
        (entity_assigned_regulation ?case_record ?regulation)
        (evidence_item_available ?evidence_item_type)
        (not
          (eligibility_committed ?case_record)
        )
      )
    :effect
      (and
        (eligibility_committed ?case_record)
        (entity_has_evidence_item ?case_record ?evidence_item_type)
        (not
          (evidence_item_available ?evidence_item_type)
        )
      )
  )
  (:action propagate_primary_profile_approval
    :parameters (?primary_citizenship_profile - primary_citizenship_profile ?document_source_option - document_source_option ?evidence_item_type - evidence_item_type)
    :precondition
      (and
        (eligibility_committed ?primary_citizenship_profile)
        (entity_linked_to_source ?primary_citizenship_profile ?document_source_option)
        (entity_has_evidence_item ?primary_citizenship_profile ?evidence_item_type)
        (not
          (approval_propagated ?primary_citizenship_profile)
        )
      )
    :effect
      (and
        (approval_propagated ?primary_citizenship_profile)
        (source_available ?document_source_option)
        (evidence_item_available ?evidence_item_type)
      )
  )
  (:action propagate_secondary_profile_approval
    :parameters (?secondary_citizenship_profile - secondary_citizenship_profile ?document_source_option - document_source_option ?evidence_item_type - evidence_item_type)
    :precondition
      (and
        (eligibility_committed ?secondary_citizenship_profile)
        (entity_linked_to_source ?secondary_citizenship_profile ?document_source_option)
        (entity_has_evidence_item ?secondary_citizenship_profile ?evidence_item_type)
        (not
          (approval_propagated ?secondary_citizenship_profile)
        )
      )
    :effect
      (and
        (approval_propagated ?secondary_citizenship_profile)
        (source_available ?document_source_option)
        (evidence_item_available ?evidence_item_type)
      )
  )
  (:action propagate_variant_approval
    :parameters (?traveler_variant - traveler_variant ?document_source_option - document_source_option ?evidence_item_type - evidence_item_type)
    :precondition
      (and
        (eligibility_committed ?traveler_variant)
        (entity_linked_to_source ?traveler_variant ?document_source_option)
        (entity_has_evidence_item ?traveler_variant ?evidence_item_type)
        (not
          (approval_propagated ?traveler_variant)
        )
      )
    :effect
      (and
        (approval_propagated ?traveler_variant)
        (source_available ?document_source_option)
        (evidence_item_available ?evidence_item_type)
      )
  )
)

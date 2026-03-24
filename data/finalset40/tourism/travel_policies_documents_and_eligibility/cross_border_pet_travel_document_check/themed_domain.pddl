(define (domain cross_border_pet_travel_policy)
  (:requirements :strips :typing :negative-preconditions)
  (:types administrative_resource - object evidence_resource - object requirement_profile - object case_family - object pet_travel_case - case_family document_source - administrative_resource regulatory_rule - administrative_resource verifier_role - administrative_resource special_permit_type - administrative_resource fee_option - administrative_resource notification_token - administrative_resource authority_credential_type - administrative_resource exception_category - administrative_resource supporting_document_type - evidence_resource evidence_item - evidence_resource special_condition_token - evidence_resource origin_requirement_profile - requirement_profile destination_requirement_profile - requirement_profile assessment_outcome_record - requirement_profile case_party_group - pet_travel_case application_record_group - pet_travel_case pet_owner_profile - case_party_group handler_profile - case_party_group application_record - application_record_group)
  (:predicates
    (record_registered ?pet_travel_case - pet_travel_case)
    (record_active ?pet_travel_case - pet_travel_case)
    (document_linked ?pet_travel_case - pet_travel_case)
    (cleared_for_travel ?pet_travel_case - pet_travel_case)
    (ready_for_final_check ?pet_travel_case - pet_travel_case)
    (pre_final_conditions_met ?pet_travel_case - pet_travel_case)
    (document_source_available ?document_source - document_source)
    (record_document_reference ?pet_travel_case - pet_travel_case ?document_source - document_source)
    (rule_available ?regulatory_rule - regulatory_rule)
    (record_rule_link ?pet_travel_case - pet_travel_case ?regulatory_rule - regulatory_rule)
    (verifier_available ?verifier_role - verifier_role)
    (record_verifier_assignment ?pet_travel_case - pet_travel_case ?verifier_role - verifier_role)
    (supporting_document_available ?supporting_document_type - supporting_document_type)
    (owner_document_link ?pet_owner_profile - pet_owner_profile ?supporting_document_type - supporting_document_type)
    (handler_document_link ?handler_profile - handler_profile ?supporting_document_type - supporting_document_type)
    (party_requirement_link_origin ?pet_owner_profile - pet_owner_profile ?origin_requirement_profile - origin_requirement_profile)
    (origin_verification_flag ?origin_requirement_profile - origin_requirement_profile)
    (origin_pending_flag ?origin_requirement_profile - origin_requirement_profile)
    (owner_origin_verified ?pet_owner_profile - pet_owner_profile)
    (party_requirement_link_destination ?handler_profile - handler_profile ?destination_requirement_profile - destination_requirement_profile)
    (destination_verification_flag ?destination_requirement_profile - destination_requirement_profile)
    (destination_pending_flag ?destination_requirement_profile - destination_requirement_profile)
    (handler_destination_verified ?handler_profile - handler_profile)
    (assessment_ticket_available ?assessment_outcome_record - assessment_outcome_record)
    (assessment_created ?assessment_outcome_record - assessment_outcome_record)
    (assessment_links_origin ?assessment_outcome_record - assessment_outcome_record ?origin_requirement_profile - origin_requirement_profile)
    (assessment_links_destination ?assessment_outcome_record - assessment_outcome_record ?destination_requirement_profile - destination_requirement_profile)
    (assessment_flag_special_condition_a ?assessment_outcome_record - assessment_outcome_record)
    (assessment_flag_special_condition_b ?assessment_outcome_record - assessment_outcome_record)
    (assessment_locked ?assessment_outcome_record - assessment_outcome_record)
    (application_to_owner_link ?application_record - application_record ?pet_owner_profile - pet_owner_profile)
    (application_to_handler_link ?application_record - application_record ?handler_profile - handler_profile)
    (application_to_assessment_link ?application_record - application_record ?assessment_outcome_record - assessment_outcome_record)
    (evidence_item_available ?evidence_item - evidence_item)
    (application_evidence_link ?application_record - application_record ?evidence_item - evidence_item)
    (evidence_consumed ?evidence_item - evidence_item)
    (evidence_to_assessment_link ?evidence_item - evidence_item ?assessment_outcome_record - assessment_outcome_record)
    (evaluator_stage_one_complete ?application_record - application_record)
    (evaluator_stage_two_complete ?application_record - application_record)
    (evaluator_ready_for_signoff ?application_record - application_record)
    (special_permit_available ?application_record - application_record)
    (special_permit_applied ?application_record - application_record)
    (credentials_attached ?application_record - application_record)
    (final_signoff_complete ?application_record - application_record)
    (special_condition_token_available ?special_condition_token - special_condition_token)
    (application_special_condition_link ?application_record - application_record ?special_condition_token - special_condition_token)
    (special_condition_awaiting_processing ?application_record - application_record)
    (special_condition_verified_by_verifier ?application_record - application_record)
    (special_condition_ready_for_signoff ?application_record - application_record)
    (permit_type_available ?special_permit_type - special_permit_type)
    (application_permit_link ?application_record - application_record ?special_permit_type - special_permit_type)
    (fee_option_available ?fee_option - fee_option)
    (application_fee_selected ?application_record - application_record ?fee_option - fee_option)
    (authority_credential_available ?authority_credential_type - authority_credential_type)
    (application_credential_link ?application_record - application_record ?authority_credential_type - authority_credential_type)
    (exception_category_available ?exception_category - exception_category)
    (application_exception_link ?application_record - application_record ?exception_category - exception_category)
    (notification_token_available ?notification_token - notification_token)
    (record_notification_link ?pet_travel_case - pet_travel_case ?notification_token - notification_token)
    (owner_ready_flags_combined ?pet_owner_profile - pet_owner_profile)
    (handler_ready_flags_combined ?handler_profile - handler_profile)
    (application_marked_complete ?application_record - application_record)
  )
  (:action register_pet_travel_case
    :parameters (?pet_travel_case - pet_travel_case)
    :precondition
      (and
        (not
          (record_registered ?pet_travel_case)
        )
        (not
          (cleared_for_travel ?pet_travel_case)
        )
      )
    :effect (record_registered ?pet_travel_case)
  )
  (:action assign_document_source_to_case
    :parameters (?pet_travel_case - pet_travel_case ?document_source - document_source)
    :precondition
      (and
        (record_registered ?pet_travel_case)
        (not
          (document_linked ?pet_travel_case)
        )
        (document_source_available ?document_source)
      )
    :effect
      (and
        (document_linked ?pet_travel_case)
        (record_document_reference ?pet_travel_case ?document_source)
        (not
          (document_source_available ?document_source)
        )
      )
  )
  (:action apply_regulatory_rule_to_case
    :parameters (?pet_travel_case - pet_travel_case ?regulatory_rule - regulatory_rule)
    :precondition
      (and
        (record_registered ?pet_travel_case)
        (document_linked ?pet_travel_case)
        (rule_available ?regulatory_rule)
      )
    :effect
      (and
        (record_rule_link ?pet_travel_case ?regulatory_rule)
        (not
          (rule_available ?regulatory_rule)
        )
      )
  )
  (:action activate_case_after_rule_application
    :parameters (?pet_travel_case - pet_travel_case ?regulatory_rule - regulatory_rule)
    :precondition
      (and
        (record_registered ?pet_travel_case)
        (document_linked ?pet_travel_case)
        (record_rule_link ?pet_travel_case ?regulatory_rule)
        (not
          (record_active ?pet_travel_case)
        )
      )
    :effect (record_active ?pet_travel_case)
  )
  (:action release_regulatory_rule_from_case
    :parameters (?pet_travel_case - pet_travel_case ?regulatory_rule - regulatory_rule)
    :precondition
      (and
        (record_rule_link ?pet_travel_case ?regulatory_rule)
      )
    :effect
      (and
        (rule_available ?regulatory_rule)
        (not
          (record_rule_link ?pet_travel_case ?regulatory_rule)
        )
      )
  )
  (:action assign_verifier_to_case
    :parameters (?pet_travel_case - pet_travel_case ?verifier_role - verifier_role)
    :precondition
      (and
        (record_active ?pet_travel_case)
        (verifier_available ?verifier_role)
      )
    :effect
      (and
        (record_verifier_assignment ?pet_travel_case ?verifier_role)
        (not
          (verifier_available ?verifier_role)
        )
      )
  )
  (:action release_verifier_from_case
    :parameters (?pet_travel_case - pet_travel_case ?verifier_role - verifier_role)
    :precondition
      (and
        (record_verifier_assignment ?pet_travel_case ?verifier_role)
      )
    :effect
      (and
        (verifier_available ?verifier_role)
        (not
          (record_verifier_assignment ?pet_travel_case ?verifier_role)
        )
      )
  )
  (:action link_authority_credential_to_application
    :parameters (?application_record - application_record ?authority_credential_type - authority_credential_type)
    :precondition
      (and
        (record_active ?application_record)
        (authority_credential_available ?authority_credential_type)
      )
    :effect
      (and
        (application_credential_link ?application_record ?authority_credential_type)
        (not
          (authority_credential_available ?authority_credential_type)
        )
      )
  )
  (:action unlink_authority_credential_from_application
    :parameters (?application_record - application_record ?authority_credential_type - authority_credential_type)
    :precondition
      (and
        (application_credential_link ?application_record ?authority_credential_type)
      )
    :effect
      (and
        (authority_credential_available ?authority_credential_type)
        (not
          (application_credential_link ?application_record ?authority_credential_type)
        )
      )
  )
  (:action link_exception_to_application
    :parameters (?application_record - application_record ?exception_category - exception_category)
    :precondition
      (and
        (record_active ?application_record)
        (exception_category_available ?exception_category)
      )
    :effect
      (and
        (application_exception_link ?application_record ?exception_category)
        (not
          (exception_category_available ?exception_category)
        )
      )
  )
  (:action unlink_exception_from_application
    :parameters (?application_record - application_record ?exception_category - exception_category)
    :precondition
      (and
        (application_exception_link ?application_record ?exception_category)
      )
    :effect
      (and
        (exception_category_available ?exception_category)
        (not
          (application_exception_link ?application_record ?exception_category)
        )
      )
  )
  (:action verify_origin_requirement_for_owner
    :parameters (?pet_owner_profile - pet_owner_profile ?origin_requirement_profile - origin_requirement_profile ?regulatory_rule - regulatory_rule)
    :precondition
      (and
        (record_active ?pet_owner_profile)
        (record_rule_link ?pet_owner_profile ?regulatory_rule)
        (party_requirement_link_origin ?pet_owner_profile ?origin_requirement_profile)
        (not
          (origin_verification_flag ?origin_requirement_profile)
        )
        (not
          (origin_pending_flag ?origin_requirement_profile)
        )
      )
    :effect (origin_verification_flag ?origin_requirement_profile)
  )
  (:action confirm_owner_origin_verification
    :parameters (?pet_owner_profile - pet_owner_profile ?origin_requirement_profile - origin_requirement_profile ?verifier_role - verifier_role)
    :precondition
      (and
        (record_active ?pet_owner_profile)
        (record_verifier_assignment ?pet_owner_profile ?verifier_role)
        (party_requirement_link_origin ?pet_owner_profile ?origin_requirement_profile)
        (origin_verification_flag ?origin_requirement_profile)
        (not
          (owner_ready_flags_combined ?pet_owner_profile)
        )
      )
    :effect
      (and
        (owner_ready_flags_combined ?pet_owner_profile)
        (owner_origin_verified ?pet_owner_profile)
      )
  )
  (:action submit_supporting_document_for_owner_origin_verification
    :parameters (?pet_owner_profile - pet_owner_profile ?origin_requirement_profile - origin_requirement_profile ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (record_active ?pet_owner_profile)
        (party_requirement_link_origin ?pet_owner_profile ?origin_requirement_profile)
        (supporting_document_available ?supporting_document_type)
        (not
          (owner_ready_flags_combined ?pet_owner_profile)
        )
      )
    :effect
      (and
        (origin_pending_flag ?origin_requirement_profile)
        (owner_ready_flags_combined ?pet_owner_profile)
        (owner_document_link ?pet_owner_profile ?supporting_document_type)
        (not
          (supporting_document_available ?supporting_document_type)
        )
      )
  )
  (:action finalize_owner_origin_verification_with_evidence
    :parameters (?pet_owner_profile - pet_owner_profile ?origin_requirement_profile - origin_requirement_profile ?regulatory_rule - regulatory_rule ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (record_active ?pet_owner_profile)
        (record_rule_link ?pet_owner_profile ?regulatory_rule)
        (party_requirement_link_origin ?pet_owner_profile ?origin_requirement_profile)
        (origin_pending_flag ?origin_requirement_profile)
        (owner_document_link ?pet_owner_profile ?supporting_document_type)
        (not
          (owner_origin_verified ?pet_owner_profile)
        )
      )
    :effect
      (and
        (origin_verification_flag ?origin_requirement_profile)
        (owner_origin_verified ?pet_owner_profile)
        (supporting_document_available ?supporting_document_type)
        (not
          (owner_document_link ?pet_owner_profile ?supporting_document_type)
        )
      )
  )
  (:action verify_destination_requirement_for_handler
    :parameters (?handler_profile - handler_profile ?destination_requirement_profile - destination_requirement_profile ?regulatory_rule - regulatory_rule)
    :precondition
      (and
        (record_active ?handler_profile)
        (record_rule_link ?handler_profile ?regulatory_rule)
        (party_requirement_link_destination ?handler_profile ?destination_requirement_profile)
        (not
          (destination_verification_flag ?destination_requirement_profile)
        )
        (not
          (destination_pending_flag ?destination_requirement_profile)
        )
      )
    :effect (destination_verification_flag ?destination_requirement_profile)
  )
  (:action confirm_handler_destination_verification
    :parameters (?handler_profile - handler_profile ?destination_requirement_profile - destination_requirement_profile ?verifier_role - verifier_role)
    :precondition
      (and
        (record_active ?handler_profile)
        (record_verifier_assignment ?handler_profile ?verifier_role)
        (party_requirement_link_destination ?handler_profile ?destination_requirement_profile)
        (destination_verification_flag ?destination_requirement_profile)
        (not
          (handler_ready_flags_combined ?handler_profile)
        )
      )
    :effect
      (and
        (handler_ready_flags_combined ?handler_profile)
        (handler_destination_verified ?handler_profile)
      )
  )
  (:action submit_supporting_document_for_handler_destination_verification
    :parameters (?handler_profile - handler_profile ?destination_requirement_profile - destination_requirement_profile ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (record_active ?handler_profile)
        (party_requirement_link_destination ?handler_profile ?destination_requirement_profile)
        (supporting_document_available ?supporting_document_type)
        (not
          (handler_ready_flags_combined ?handler_profile)
        )
      )
    :effect
      (and
        (destination_pending_flag ?destination_requirement_profile)
        (handler_ready_flags_combined ?handler_profile)
        (handler_document_link ?handler_profile ?supporting_document_type)
        (not
          (supporting_document_available ?supporting_document_type)
        )
      )
  )
  (:action finalize_handler_destination_verification_with_evidence
    :parameters (?handler_profile - handler_profile ?destination_requirement_profile - destination_requirement_profile ?regulatory_rule - regulatory_rule ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (record_active ?handler_profile)
        (record_rule_link ?handler_profile ?regulatory_rule)
        (party_requirement_link_destination ?handler_profile ?destination_requirement_profile)
        (destination_pending_flag ?destination_requirement_profile)
        (handler_document_link ?handler_profile ?supporting_document_type)
        (not
          (handler_destination_verified ?handler_profile)
        )
      )
    :effect
      (and
        (destination_verification_flag ?destination_requirement_profile)
        (handler_destination_verified ?handler_profile)
        (supporting_document_available ?supporting_document_type)
        (not
          (handler_document_link ?handler_profile ?supporting_document_type)
        )
      )
  )
  (:action create_assessment_from_verifications
    :parameters (?pet_owner_profile - pet_owner_profile ?handler_profile - handler_profile ?origin_requirement_profile - origin_requirement_profile ?destination_requirement_profile - destination_requirement_profile ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (owner_ready_flags_combined ?pet_owner_profile)
        (handler_ready_flags_combined ?handler_profile)
        (party_requirement_link_origin ?pet_owner_profile ?origin_requirement_profile)
        (party_requirement_link_destination ?handler_profile ?destination_requirement_profile)
        (origin_verification_flag ?origin_requirement_profile)
        (destination_verification_flag ?destination_requirement_profile)
        (owner_origin_verified ?pet_owner_profile)
        (handler_destination_verified ?handler_profile)
        (assessment_ticket_available ?assessment_outcome_record)
      )
    :effect
      (and
        (assessment_created ?assessment_outcome_record)
        (assessment_links_origin ?assessment_outcome_record ?origin_requirement_profile)
        (assessment_links_destination ?assessment_outcome_record ?destination_requirement_profile)
        (not
          (assessment_ticket_available ?assessment_outcome_record)
        )
      )
  )
  (:action create_assessment_with_special_condition_a
    :parameters (?pet_owner_profile - pet_owner_profile ?handler_profile - handler_profile ?origin_requirement_profile - origin_requirement_profile ?destination_requirement_profile - destination_requirement_profile ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (owner_ready_flags_combined ?pet_owner_profile)
        (handler_ready_flags_combined ?handler_profile)
        (party_requirement_link_origin ?pet_owner_profile ?origin_requirement_profile)
        (party_requirement_link_destination ?handler_profile ?destination_requirement_profile)
        (origin_pending_flag ?origin_requirement_profile)
        (destination_verification_flag ?destination_requirement_profile)
        (not
          (owner_origin_verified ?pet_owner_profile)
        )
        (handler_destination_verified ?handler_profile)
        (assessment_ticket_available ?assessment_outcome_record)
      )
    :effect
      (and
        (assessment_created ?assessment_outcome_record)
        (assessment_links_origin ?assessment_outcome_record ?origin_requirement_profile)
        (assessment_links_destination ?assessment_outcome_record ?destination_requirement_profile)
        (assessment_flag_special_condition_a ?assessment_outcome_record)
        (not
          (assessment_ticket_available ?assessment_outcome_record)
        )
      )
  )
  (:action create_assessment_with_special_condition_b
    :parameters (?pet_owner_profile - pet_owner_profile ?handler_profile - handler_profile ?origin_requirement_profile - origin_requirement_profile ?destination_requirement_profile - destination_requirement_profile ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (owner_ready_flags_combined ?pet_owner_profile)
        (handler_ready_flags_combined ?handler_profile)
        (party_requirement_link_origin ?pet_owner_profile ?origin_requirement_profile)
        (party_requirement_link_destination ?handler_profile ?destination_requirement_profile)
        (origin_verification_flag ?origin_requirement_profile)
        (destination_pending_flag ?destination_requirement_profile)
        (owner_origin_verified ?pet_owner_profile)
        (not
          (handler_destination_verified ?handler_profile)
        )
        (assessment_ticket_available ?assessment_outcome_record)
      )
    :effect
      (and
        (assessment_created ?assessment_outcome_record)
        (assessment_links_origin ?assessment_outcome_record ?origin_requirement_profile)
        (assessment_links_destination ?assessment_outcome_record ?destination_requirement_profile)
        (assessment_flag_special_condition_b ?assessment_outcome_record)
        (not
          (assessment_ticket_available ?assessment_outcome_record)
        )
      )
  )
  (:action create_assessment_with_both_special_conditions
    :parameters (?pet_owner_profile - pet_owner_profile ?handler_profile - handler_profile ?origin_requirement_profile - origin_requirement_profile ?destination_requirement_profile - destination_requirement_profile ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (owner_ready_flags_combined ?pet_owner_profile)
        (handler_ready_flags_combined ?handler_profile)
        (party_requirement_link_origin ?pet_owner_profile ?origin_requirement_profile)
        (party_requirement_link_destination ?handler_profile ?destination_requirement_profile)
        (origin_pending_flag ?origin_requirement_profile)
        (destination_pending_flag ?destination_requirement_profile)
        (not
          (owner_origin_verified ?pet_owner_profile)
        )
        (not
          (handler_destination_verified ?handler_profile)
        )
        (assessment_ticket_available ?assessment_outcome_record)
      )
    :effect
      (and
        (assessment_created ?assessment_outcome_record)
        (assessment_links_origin ?assessment_outcome_record ?origin_requirement_profile)
        (assessment_links_destination ?assessment_outcome_record ?destination_requirement_profile)
        (assessment_flag_special_condition_a ?assessment_outcome_record)
        (assessment_flag_special_condition_b ?assessment_outcome_record)
        (not
          (assessment_ticket_available ?assessment_outcome_record)
        )
      )
  )
  (:action lock_assessment_for_review
    :parameters (?assessment_outcome_record - assessment_outcome_record ?pet_owner_profile - pet_owner_profile ?regulatory_rule - regulatory_rule)
    :precondition
      (and
        (assessment_created ?assessment_outcome_record)
        (owner_ready_flags_combined ?pet_owner_profile)
        (record_rule_link ?pet_owner_profile ?regulatory_rule)
        (not
          (assessment_locked ?assessment_outcome_record)
        )
      )
    :effect (assessment_locked ?assessment_outcome_record)
  )
  (:action consume_and_link_evidence_to_assessment
    :parameters (?application_record - application_record ?evidence_item - evidence_item ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (record_active ?application_record)
        (application_to_assessment_link ?application_record ?assessment_outcome_record)
        (application_evidence_link ?application_record ?evidence_item)
        (evidence_item_available ?evidence_item)
        (assessment_created ?assessment_outcome_record)
        (assessment_locked ?assessment_outcome_record)
        (not
          (evidence_consumed ?evidence_item)
        )
      )
    :effect
      (and
        (evidence_consumed ?evidence_item)
        (evidence_to_assessment_link ?evidence_item ?assessment_outcome_record)
        (not
          (evidence_item_available ?evidence_item)
        )
      )
  )
  (:action advance_evaluator_stage_one
    :parameters (?application_record - application_record ?evidence_item - evidence_item ?assessment_outcome_record - assessment_outcome_record ?regulatory_rule - regulatory_rule)
    :precondition
      (and
        (record_active ?application_record)
        (application_evidence_link ?application_record ?evidence_item)
        (evidence_consumed ?evidence_item)
        (evidence_to_assessment_link ?evidence_item ?assessment_outcome_record)
        (record_rule_link ?application_record ?regulatory_rule)
        (not
          (assessment_flag_special_condition_a ?assessment_outcome_record)
        )
        (not
          (evaluator_stage_one_complete ?application_record)
        )
      )
    :effect (evaluator_stage_one_complete ?application_record)
  )
  (:action assign_special_permit_to_application
    :parameters (?application_record - application_record ?special_permit_type - special_permit_type)
    :precondition
      (and
        (record_active ?application_record)
        (permit_type_available ?special_permit_type)
        (not
          (special_permit_available ?application_record)
        )
      )
    :effect
      (and
        (special_permit_available ?application_record)
        (application_permit_link ?application_record ?special_permit_type)
        (not
          (permit_type_available ?special_permit_type)
        )
      )
  )
  (:action apply_special_permit_and_mark_application
    :parameters (?application_record - application_record ?evidence_item - evidence_item ?assessment_outcome_record - assessment_outcome_record ?regulatory_rule - regulatory_rule ?special_permit_type - special_permit_type)
    :precondition
      (and
        (record_active ?application_record)
        (application_evidence_link ?application_record ?evidence_item)
        (evidence_consumed ?evidence_item)
        (evidence_to_assessment_link ?evidence_item ?assessment_outcome_record)
        (record_rule_link ?application_record ?regulatory_rule)
        (assessment_flag_special_condition_a ?assessment_outcome_record)
        (special_permit_available ?application_record)
        (application_permit_link ?application_record ?special_permit_type)
        (not
          (evaluator_stage_one_complete ?application_record)
        )
      )
    :effect
      (and
        (evaluator_stage_one_complete ?application_record)
        (special_permit_applied ?application_record)
      )
  )
  (:action advance_evaluator_stage_two_without_assessment_flag
    :parameters (?application_record - application_record ?authority_credential_type - authority_credential_type ?verifier_role - verifier_role ?evidence_item - evidence_item ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (evaluator_stage_one_complete ?application_record)
        (application_credential_link ?application_record ?authority_credential_type)
        (record_verifier_assignment ?application_record ?verifier_role)
        (application_evidence_link ?application_record ?evidence_item)
        (evidence_to_assessment_link ?evidence_item ?assessment_outcome_record)
        (not
          (assessment_flag_special_condition_b ?assessment_outcome_record)
        )
        (not
          (evaluator_stage_two_complete ?application_record)
        )
      )
    :effect (evaluator_stage_two_complete ?application_record)
  )
  (:action advance_evaluator_stage_two_with_assessment_flag
    :parameters (?application_record - application_record ?authority_credential_type - authority_credential_type ?verifier_role - verifier_role ?evidence_item - evidence_item ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (evaluator_stage_one_complete ?application_record)
        (application_credential_link ?application_record ?authority_credential_type)
        (record_verifier_assignment ?application_record ?verifier_role)
        (application_evidence_link ?application_record ?evidence_item)
        (evidence_to_assessment_link ?evidence_item ?assessment_outcome_record)
        (assessment_flag_special_condition_b ?assessment_outcome_record)
        (not
          (evaluator_stage_two_complete ?application_record)
        )
      )
    :effect (evaluator_stage_two_complete ?application_record)
  )
  (:action prepare_application_for_signoff
    :parameters (?application_record - application_record ?exception_category - exception_category ?evidence_item - evidence_item ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (evaluator_stage_two_complete ?application_record)
        (application_exception_link ?application_record ?exception_category)
        (application_evidence_link ?application_record ?evidence_item)
        (evidence_to_assessment_link ?evidence_item ?assessment_outcome_record)
        (not
          (assessment_flag_special_condition_a ?assessment_outcome_record)
        )
        (not
          (assessment_flag_special_condition_b ?assessment_outcome_record)
        )
        (not
          (evaluator_ready_for_signoff ?application_record)
        )
      )
    :effect (evaluator_ready_for_signoff ?application_record)
  )
  (:action prepare_application_for_signoff_with_condition_a
    :parameters (?application_record - application_record ?exception_category - exception_category ?evidence_item - evidence_item ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (evaluator_stage_two_complete ?application_record)
        (application_exception_link ?application_record ?exception_category)
        (application_evidence_link ?application_record ?evidence_item)
        (evidence_to_assessment_link ?evidence_item ?assessment_outcome_record)
        (assessment_flag_special_condition_a ?assessment_outcome_record)
        (not
          (assessment_flag_special_condition_b ?assessment_outcome_record)
        )
        (not
          (evaluator_ready_for_signoff ?application_record)
        )
      )
    :effect
      (and
        (evaluator_ready_for_signoff ?application_record)
        (credentials_attached ?application_record)
      )
  )
  (:action prepare_application_for_signoff_with_condition_b
    :parameters (?application_record - application_record ?exception_category - exception_category ?evidence_item - evidence_item ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (evaluator_stage_two_complete ?application_record)
        (application_exception_link ?application_record ?exception_category)
        (application_evidence_link ?application_record ?evidence_item)
        (evidence_to_assessment_link ?evidence_item ?assessment_outcome_record)
        (not
          (assessment_flag_special_condition_a ?assessment_outcome_record)
        )
        (assessment_flag_special_condition_b ?assessment_outcome_record)
        (not
          (evaluator_ready_for_signoff ?application_record)
        )
      )
    :effect
      (and
        (evaluator_ready_for_signoff ?application_record)
        (credentials_attached ?application_record)
      )
  )
  (:action prepare_application_for_signoff_with_both_conditions
    :parameters (?application_record - application_record ?exception_category - exception_category ?evidence_item - evidence_item ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (evaluator_stage_two_complete ?application_record)
        (application_exception_link ?application_record ?exception_category)
        (application_evidence_link ?application_record ?evidence_item)
        (evidence_to_assessment_link ?evidence_item ?assessment_outcome_record)
        (assessment_flag_special_condition_a ?assessment_outcome_record)
        (assessment_flag_special_condition_b ?assessment_outcome_record)
        (not
          (evaluator_ready_for_signoff ?application_record)
        )
      )
    :effect
      (and
        (evaluator_ready_for_signoff ?application_record)
        (credentials_attached ?application_record)
      )
  )
  (:action mark_application_ready_for_final_check
    :parameters (?application_record - application_record)
    :precondition
      (and
        (evaluator_ready_for_signoff ?application_record)
        (not
          (credentials_attached ?application_record)
        )
        (not
          (application_marked_complete ?application_record)
        )
      )
    :effect
      (and
        (application_marked_complete ?application_record)
        (ready_for_final_check ?application_record)
      )
  )
  (:action attach_fee_option_to_application
    :parameters (?application_record - application_record ?fee_option - fee_option)
    :precondition
      (and
        (evaluator_ready_for_signoff ?application_record)
        (credentials_attached ?application_record)
        (fee_option_available ?fee_option)
      )
    :effect
      (and
        (application_fee_selected ?application_record ?fee_option)
        (not
          (fee_option_available ?fee_option)
        )
      )
  )
  (:action complete_final_evaluator_review
    :parameters (?application_record - application_record ?pet_owner_profile - pet_owner_profile ?handler_profile - handler_profile ?regulatory_rule - regulatory_rule ?fee_option - fee_option)
    :precondition
      (and
        (evaluator_ready_for_signoff ?application_record)
        (credentials_attached ?application_record)
        (application_fee_selected ?application_record ?fee_option)
        (application_to_owner_link ?application_record ?pet_owner_profile)
        (application_to_handler_link ?application_record ?handler_profile)
        (owner_origin_verified ?pet_owner_profile)
        (handler_destination_verified ?handler_profile)
        (record_rule_link ?application_record ?regulatory_rule)
        (not
          (final_signoff_complete ?application_record)
        )
      )
    :effect (final_signoff_complete ?application_record)
  )
  (:action finalize_application_and_mark_ready_for_issuance
    :parameters (?application_record - application_record)
    :precondition
      (and
        (evaluator_ready_for_signoff ?application_record)
        (final_signoff_complete ?application_record)
        (not
          (application_marked_complete ?application_record)
        )
      )
    :effect
      (and
        (application_marked_complete ?application_record)
        (ready_for_final_check ?application_record)
      )
  )
  (:action apply_special_condition_token_to_application
    :parameters (?application_record - application_record ?special_condition_token - special_condition_token ?regulatory_rule - regulatory_rule)
    :precondition
      (and
        (record_active ?application_record)
        (record_rule_link ?application_record ?regulatory_rule)
        (special_condition_token_available ?special_condition_token)
        (application_special_condition_link ?application_record ?special_condition_token)
        (not
          (special_condition_awaiting_processing ?application_record)
        )
      )
    :effect
      (and
        (special_condition_awaiting_processing ?application_record)
        (not
          (special_condition_token_available ?special_condition_token)
        )
      )
  )
  (:action verify_special_condition_by_verifier
    :parameters (?application_record - application_record ?verifier_role - verifier_role)
    :precondition
      (and
        (special_condition_awaiting_processing ?application_record)
        (record_verifier_assignment ?application_record ?verifier_role)
        (not
          (special_condition_verified_by_verifier ?application_record)
        )
      )
    :effect (special_condition_verified_by_verifier ?application_record)
  )
  (:action prepare_special_condition_for_signoff
    :parameters (?application_record - application_record ?exception_category - exception_category)
    :precondition
      (and
        (special_condition_verified_by_verifier ?application_record)
        (application_exception_link ?application_record ?exception_category)
        (not
          (special_condition_ready_for_signoff ?application_record)
        )
      )
    :effect (special_condition_ready_for_signoff ?application_record)
  )
  (:action finalize_special_condition_and_mark_application_ready
    :parameters (?application_record - application_record)
    :precondition
      (and
        (special_condition_ready_for_signoff ?application_record)
        (not
          (application_marked_complete ?application_record)
        )
      )
    :effect
      (and
        (application_marked_complete ?application_record)
        (ready_for_final_check ?application_record)
      )
  )
  (:action mark_owner_ready_for_final_check
    :parameters (?pet_owner_profile - pet_owner_profile ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (owner_ready_flags_combined ?pet_owner_profile)
        (owner_origin_verified ?pet_owner_profile)
        (assessment_created ?assessment_outcome_record)
        (assessment_locked ?assessment_outcome_record)
        (not
          (ready_for_final_check ?pet_owner_profile)
        )
      )
    :effect (ready_for_final_check ?pet_owner_profile)
  )
  (:action mark_handler_ready_for_final_check
    :parameters (?handler_profile - handler_profile ?assessment_outcome_record - assessment_outcome_record)
    :precondition
      (and
        (handler_ready_flags_combined ?handler_profile)
        (handler_destination_verified ?handler_profile)
        (assessment_created ?assessment_outcome_record)
        (assessment_locked ?assessment_outcome_record)
        (not
          (ready_for_final_check ?handler_profile)
        )
      )
    :effect (ready_for_final_check ?handler_profile)
  )
  (:action attach_notification_and_mark_pre_final_conditions
    :parameters (?pet_travel_case - pet_travel_case ?notification_token - notification_token ?regulatory_rule - regulatory_rule)
    :precondition
      (and
        (ready_for_final_check ?pet_travel_case)
        (record_rule_link ?pet_travel_case ?regulatory_rule)
        (notification_token_available ?notification_token)
        (not
          (pre_final_conditions_met ?pet_travel_case)
        )
      )
    :effect
      (and
        (pre_final_conditions_met ?pet_travel_case)
        (record_notification_link ?pet_travel_case ?notification_token)
        (not
          (notification_token_available ?notification_token)
        )
      )
  )
  (:action finalize_owner_clearance_and_release_document_source
    :parameters (?pet_owner_profile - pet_owner_profile ?document_source - document_source ?notification_token - notification_token)
    :precondition
      (and
        (pre_final_conditions_met ?pet_owner_profile)
        (record_document_reference ?pet_owner_profile ?document_source)
        (record_notification_link ?pet_owner_profile ?notification_token)
        (not
          (cleared_for_travel ?pet_owner_profile)
        )
      )
    :effect
      (and
        (cleared_for_travel ?pet_owner_profile)
        (document_source_available ?document_source)
        (notification_token_available ?notification_token)
      )
  )
  (:action finalize_handler_clearance_and_release_document_source
    :parameters (?handler_profile - handler_profile ?document_source - document_source ?notification_token - notification_token)
    :precondition
      (and
        (pre_final_conditions_met ?handler_profile)
        (record_document_reference ?handler_profile ?document_source)
        (record_notification_link ?handler_profile ?notification_token)
        (not
          (cleared_for_travel ?handler_profile)
        )
      )
    :effect
      (and
        (cleared_for_travel ?handler_profile)
        (document_source_available ?document_source)
        (notification_token_available ?notification_token)
      )
  )
  (:action finalize_application_clearance_and_release_document_source
    :parameters (?application_record - application_record ?document_source - document_source ?notification_token - notification_token)
    :precondition
      (and
        (pre_final_conditions_met ?application_record)
        (record_document_reference ?application_record ?document_source)
        (record_notification_link ?application_record ?notification_token)
        (not
          (cleared_for_travel ?application_record)
        )
      )
    :effect
      (and
        (cleared_for_travel ?application_record)
        (document_source_available ?document_source)
        (notification_token_available ?notification_token)
      )
  )
)

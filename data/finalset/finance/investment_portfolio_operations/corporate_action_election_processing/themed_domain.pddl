(define (domain corporate_action_election_processing)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_entity - object domain_category - domain_entity resource_type - domain_entity instruction_component - domain_entity notice_base - domain_entity notice_entity - notice_base service_agent - domain_category election_option - domain_category agent_instruction_profile - domain_category regulatory_flag - domain_category settlement_option - domain_category settlement_reference - domain_category compliance_rule - domain_category approval_token - domain_category election_ballot - resource_type supporting_document - resource_type authorization_credential - resource_type event_attribute - instruction_component allocation_key - instruction_component instruction_packet - instruction_component holding_scope - notice_entity case_scope - notice_entity client_holding - holding_scope subaccount_holding - holding_scope processing_case - case_scope)

  (:predicates
    (processing_case_created ?corporate_action_notice - notice_entity)
    (election_confirmed ?corporate_action_notice - notice_entity)
    (agent_assignment_recorded ?corporate_action_notice - notice_entity)
    (election_applied ?corporate_action_notice - notice_entity)
    (ready_for_application ?corporate_action_notice - notice_entity)
    (application_authorized_for_entity ?corporate_action_notice - notice_entity)
    (agent_available ?service_agent - service_agent)
    (agent_assigned ?corporate_action_notice - notice_entity ?service_agent - service_agent)
    (election_option_available ?election_option - election_option)
    (election_option_selected ?corporate_action_notice - notice_entity ?election_option - election_option)
    (instruction_profile_available ?agent_instruction_profile - agent_instruction_profile)
    (instruction_profile_assigned ?corporate_action_notice - notice_entity ?agent_instruction_profile - agent_instruction_profile)
    (election_ballot_available ?election_ballot - election_ballot)
    (ballot_assigned_to_holding ?client_holding - client_holding ?election_ballot - election_ballot)
    (ballot_assigned_to_subaccount ?subaccount_holding - subaccount_holding ?election_ballot - election_ballot)
    (holding_attribute_match ?client_holding - client_holding ?event_attribute - event_attribute)
    (event_attribute_claimed ?event_attribute - event_attribute)
    (event_attribute_reserved ?event_attribute - event_attribute)
    (holding_entitlement_confirmed ?client_holding - client_holding)
    (subaccount_allocation_key ?subaccount_holding - subaccount_holding ?allocation_key - allocation_key)
    (allocation_key_locked ?allocation_key - allocation_key)
    (allocation_key_flagged ?allocation_key - allocation_key)
    (subaccount_entitlement_confirmed ?subaccount_holding - subaccount_holding)
    (instruction_packet_available ?instruction_packet - instruction_packet)
    (instruction_packet_created ?instruction_packet - instruction_packet)
    (instruction_packet_attribute_linked ?instruction_packet - instruction_packet ?event_attribute - event_attribute)
    (instruction_packet_allocation_assigned ?instruction_packet - instruction_packet ?allocation_key - allocation_key)
    (instruction_packet_requires_approval ?instruction_packet - instruction_packet)
    (instruction_packet_requires_compliance_review ?instruction_packet - instruction_packet)
    (instruction_packet_validated ?instruction_packet - instruction_packet)
    (case_includes_client_holding ?processing_case - processing_case ?client_holding - client_holding)
    (case_includes_subaccount ?processing_case - processing_case ?subaccount_holding - subaccount_holding)
    (case_includes_instruction_packet ?processing_case - processing_case ?instruction_packet - instruction_packet)
    (supporting_document_available ?supporting_document - supporting_document)
    (case_has_supporting_document ?processing_case - processing_case ?supporting_document - supporting_document)
    (supporting_document_attached ?supporting_document - supporting_document)
    (document_linked_to_packet ?supporting_document - supporting_document ?instruction_packet - instruction_packet)
    (case_validated_for_submission ?processing_case - processing_case)
    (case_submitted ?processing_case - processing_case)
    (case_approved_for_posting ?processing_case - processing_case)
    (regulatory_flag_applied ?processing_case - processing_case)
    (case_regulatory_check_complete ?processing_case - processing_case)
    (case_has_approvals ?processing_case - processing_case)
    (case_final_compliance_checked ?processing_case - processing_case)
    (authorization_credential_available ?authorization_credential - authorization_credential)
    (case_has_authorization_credential ?processing_case - processing_case ?authorization_credential - authorization_credential)
    (case_authorized_by_credential ?processing_case - processing_case)
    (case_in_approval_step ?processing_case - processing_case)
    (case_approval_obtained ?processing_case - processing_case)
    (regulatory_flag_available ?regulatory_flag - regulatory_flag)
    (case_has_regulatory_flag ?processing_case - processing_case ?regulatory_flag - regulatory_flag)
    (settlement_option_available ?settlement_option - settlement_option)
    (case_settlement_option_assigned ?processing_case - processing_case ?settlement_option - settlement_option)
    (compliance_rule_available ?compliance_rule - compliance_rule)
    (case_has_compliance_rule ?processing_case - processing_case ?compliance_rule - compliance_rule)
    (approval_token_available ?approval_token - approval_token)
    (case_has_approval_token ?processing_case - processing_case ?approval_token - approval_token)
    (settlement_reference_available ?settlement_reference - settlement_reference)
    (settlement_reference_associated ?corporate_action_notice - notice_entity ?settlement_reference - settlement_reference)
    (holding_assessed_for_instruction ?client_holding - client_holding)
    (subaccount_assessed_for_instruction ?subaccount_holding - subaccount_holding)
    (case_posting_recorded ?processing_case - processing_case)
  )
  (:action create_processing_case_for_notice
    :parameters (?corporate_action_notice - notice_entity)
    :precondition
      (and
        (not
          (processing_case_created ?corporate_action_notice)
        )
        (not
          (election_applied ?corporate_action_notice)
        )
      )
    :effect (processing_case_created ?corporate_action_notice)
  )
  (:action assign_service_agent_to_notice
    :parameters (?corporate_action_notice - notice_entity ?service_agent - service_agent)
    :precondition
      (and
        (processing_case_created ?corporate_action_notice)
        (not
          (agent_assignment_recorded ?corporate_action_notice)
        )
        (agent_available ?service_agent)
      )
    :effect
      (and
        (agent_assignment_recorded ?corporate_action_notice)
        (agent_assigned ?corporate_action_notice ?service_agent)
        (not
          (agent_available ?service_agent)
        )
      )
  )
  (:action reserve_election_option_for_notice
    :parameters (?corporate_action_notice - notice_entity ?election_option - election_option)
    :precondition
      (and
        (processing_case_created ?corporate_action_notice)
        (agent_assignment_recorded ?corporate_action_notice)
        (election_option_available ?election_option)
      )
    :effect
      (and
        (election_option_selected ?corporate_action_notice ?election_option)
        (not
          (election_option_available ?election_option)
        )
      )
  )
  (:action finalize_election_for_notice
    :parameters (?corporate_action_notice - notice_entity ?election_option - election_option)
    :precondition
      (and
        (processing_case_created ?corporate_action_notice)
        (agent_assignment_recorded ?corporate_action_notice)
        (election_option_selected ?corporate_action_notice ?election_option)
        (not
          (election_confirmed ?corporate_action_notice)
        )
      )
    :effect (election_confirmed ?corporate_action_notice)
  )
  (:action release_reserved_election_option
    :parameters (?corporate_action_notice - notice_entity ?election_option - election_option)
    :precondition
      (and
        (election_option_selected ?corporate_action_notice ?election_option)
      )
    :effect
      (and
        (election_option_available ?election_option)
        (not
          (election_option_selected ?corporate_action_notice ?election_option)
        )
      )
  )
  (:action assign_instruction_profile_to_notice
    :parameters (?corporate_action_notice - notice_entity ?agent_instruction_profile - agent_instruction_profile)
    :precondition
      (and
        (election_confirmed ?corporate_action_notice)
        (instruction_profile_available ?agent_instruction_profile)
      )
    :effect
      (and
        (instruction_profile_assigned ?corporate_action_notice ?agent_instruction_profile)
        (not
          (instruction_profile_available ?agent_instruction_profile)
        )
      )
  )
  (:action release_instruction_profile_from_notice
    :parameters (?corporate_action_notice - notice_entity ?agent_instruction_profile - agent_instruction_profile)
    :precondition
      (and
        (instruction_profile_assigned ?corporate_action_notice ?agent_instruction_profile)
      )
    :effect
      (and
        (instruction_profile_available ?agent_instruction_profile)
        (not
          (instruction_profile_assigned ?corporate_action_notice ?agent_instruction_profile)
        )
      )
  )
  (:action attach_compliance_rule_to_case
    :parameters (?processing_case - processing_case ?compliance_rule - compliance_rule)
    :precondition
      (and
        (election_confirmed ?processing_case)
        (compliance_rule_available ?compliance_rule)
      )
    :effect
      (and
        (case_has_compliance_rule ?processing_case ?compliance_rule)
        (not
          (compliance_rule_available ?compliance_rule)
        )
      )
  )
  (:action detach_compliance_rule_from_case
    :parameters (?processing_case - processing_case ?compliance_rule - compliance_rule)
    :precondition
      (and
        (case_has_compliance_rule ?processing_case ?compliance_rule)
      )
    :effect
      (and
        (compliance_rule_available ?compliance_rule)
        (not
          (case_has_compliance_rule ?processing_case ?compliance_rule)
        )
      )
  )
  (:action attach_approval_token_to_case
    :parameters (?processing_case - processing_case ?approval_token - approval_token)
    :precondition
      (and
        (election_confirmed ?processing_case)
        (approval_token_available ?approval_token)
      )
    :effect
      (and
        (case_has_approval_token ?processing_case ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action detach_approval_token_from_case
    :parameters (?processing_case - processing_case ?approval_token - approval_token)
    :precondition
      (and
        (case_has_approval_token ?processing_case ?approval_token)
      )
    :effect
      (and
        (approval_token_available ?approval_token)
        (not
          (case_has_approval_token ?processing_case ?approval_token)
        )
      )
  )
  (:action claim_event_attribute_for_holding
    :parameters (?client_holding - client_holding ?event_attribute - event_attribute ?election_option - election_option)
    :precondition
      (and
        (election_confirmed ?client_holding)
        (election_option_selected ?client_holding ?election_option)
        (holding_attribute_match ?client_holding ?event_attribute)
        (not
          (event_attribute_claimed ?event_attribute)
        )
        (not
          (event_attribute_reserved ?event_attribute)
        )
      )
    :effect (event_attribute_claimed ?event_attribute)
  )
  (:action apply_instruction_profile_to_holding
    :parameters (?client_holding - client_holding ?event_attribute - event_attribute ?agent_instruction_profile - agent_instruction_profile)
    :precondition
      (and
        (election_confirmed ?client_holding)
        (instruction_profile_assigned ?client_holding ?agent_instruction_profile)
        (holding_attribute_match ?client_holding ?event_attribute)
        (event_attribute_claimed ?event_attribute)
        (not
          (holding_assessed_for_instruction ?client_holding)
        )
      )
    :effect
      (and
        (holding_assessed_for_instruction ?client_holding)
        (holding_entitlement_confirmed ?client_holding)
      )
  )
  (:action assign_ballot_to_holding
    :parameters (?client_holding - client_holding ?event_attribute - event_attribute ?election_ballot - election_ballot)
    :precondition
      (and
        (election_confirmed ?client_holding)
        (holding_attribute_match ?client_holding ?event_attribute)
        (election_ballot_available ?election_ballot)
        (not
          (holding_assessed_for_instruction ?client_holding)
        )
      )
    :effect
      (and
        (event_attribute_reserved ?event_attribute)
        (holding_assessed_for_instruction ?client_holding)
        (ballot_assigned_to_holding ?client_holding ?election_ballot)
        (not
          (election_ballot_available ?election_ballot)
        )
      )
  )
  (:action confirm_ballot_allocation_for_holding
    :parameters (?client_holding - client_holding ?event_attribute - event_attribute ?election_option - election_option ?election_ballot - election_ballot)
    :precondition
      (and
        (election_confirmed ?client_holding)
        (election_option_selected ?client_holding ?election_option)
        (holding_attribute_match ?client_holding ?event_attribute)
        (event_attribute_reserved ?event_attribute)
        (ballot_assigned_to_holding ?client_holding ?election_ballot)
        (not
          (holding_entitlement_confirmed ?client_holding)
        )
      )
    :effect
      (and
        (event_attribute_claimed ?event_attribute)
        (holding_entitlement_confirmed ?client_holding)
        (election_ballot_available ?election_ballot)
        (not
          (ballot_assigned_to_holding ?client_holding ?election_ballot)
        )
      )
  )
  (:action reserve_allocation_key_for_subaccount
    :parameters (?subaccount_holding - subaccount_holding ?allocation_key - allocation_key ?election_option - election_option)
    :precondition
      (and
        (election_confirmed ?subaccount_holding)
        (election_option_selected ?subaccount_holding ?election_option)
        (subaccount_allocation_key ?subaccount_holding ?allocation_key)
        (not
          (allocation_key_locked ?allocation_key)
        )
        (not
          (allocation_key_flagged ?allocation_key)
        )
      )
    :effect (allocation_key_locked ?allocation_key)
  )
  (:action apply_instruction_profile_to_subaccount
    :parameters (?subaccount_holding - subaccount_holding ?allocation_key - allocation_key ?agent_instruction_profile - agent_instruction_profile)
    :precondition
      (and
        (election_confirmed ?subaccount_holding)
        (instruction_profile_assigned ?subaccount_holding ?agent_instruction_profile)
        (subaccount_allocation_key ?subaccount_holding ?allocation_key)
        (allocation_key_locked ?allocation_key)
        (not
          (subaccount_assessed_for_instruction ?subaccount_holding)
        )
      )
    :effect
      (and
        (subaccount_assessed_for_instruction ?subaccount_holding)
        (subaccount_entitlement_confirmed ?subaccount_holding)
      )
  )
  (:action assign_ballot_to_subaccount
    :parameters (?subaccount_holding - subaccount_holding ?allocation_key - allocation_key ?election_ballot - election_ballot)
    :precondition
      (and
        (election_confirmed ?subaccount_holding)
        (subaccount_allocation_key ?subaccount_holding ?allocation_key)
        (election_ballot_available ?election_ballot)
        (not
          (subaccount_assessed_for_instruction ?subaccount_holding)
        )
      )
    :effect
      (and
        (allocation_key_flagged ?allocation_key)
        (subaccount_assessed_for_instruction ?subaccount_holding)
        (ballot_assigned_to_subaccount ?subaccount_holding ?election_ballot)
        (not
          (election_ballot_available ?election_ballot)
        )
      )
  )
  (:action confirm_ballot_allocation_for_subaccount
    :parameters (?subaccount_holding - subaccount_holding ?allocation_key - allocation_key ?election_option - election_option ?election_ballot - election_ballot)
    :precondition
      (and
        (election_confirmed ?subaccount_holding)
        (election_option_selected ?subaccount_holding ?election_option)
        (subaccount_allocation_key ?subaccount_holding ?allocation_key)
        (allocation_key_flagged ?allocation_key)
        (ballot_assigned_to_subaccount ?subaccount_holding ?election_ballot)
        (not
          (subaccount_entitlement_confirmed ?subaccount_holding)
        )
      )
    :effect
      (and
        (allocation_key_locked ?allocation_key)
        (subaccount_entitlement_confirmed ?subaccount_holding)
        (election_ballot_available ?election_ballot)
        (not
          (ballot_assigned_to_subaccount ?subaccount_holding ?election_ballot)
        )
      )
  )
  (:action assemble_instruction_packet
    :parameters (?client_holding - client_holding ?subaccount_holding - subaccount_holding ?event_attribute - event_attribute ?allocation_key - allocation_key ?instruction_packet - instruction_packet)
    :precondition
      (and
        (holding_assessed_for_instruction ?client_holding)
        (subaccount_assessed_for_instruction ?subaccount_holding)
        (holding_attribute_match ?client_holding ?event_attribute)
        (subaccount_allocation_key ?subaccount_holding ?allocation_key)
        (event_attribute_claimed ?event_attribute)
        (allocation_key_locked ?allocation_key)
        (holding_entitlement_confirmed ?client_holding)
        (subaccount_entitlement_confirmed ?subaccount_holding)
        (instruction_packet_available ?instruction_packet)
      )
    :effect
      (and
        (instruction_packet_created ?instruction_packet)
        (instruction_packet_attribute_linked ?instruction_packet ?event_attribute)
        (instruction_packet_allocation_assigned ?instruction_packet ?allocation_key)
        (not
          (instruction_packet_available ?instruction_packet)
        )
      )
  )
  (:action assemble_instruction_packet_with_approval_flag
    :parameters (?client_holding - client_holding ?subaccount_holding - subaccount_holding ?event_attribute - event_attribute ?allocation_key - allocation_key ?instruction_packet - instruction_packet)
    :precondition
      (and
        (holding_assessed_for_instruction ?client_holding)
        (subaccount_assessed_for_instruction ?subaccount_holding)
        (holding_attribute_match ?client_holding ?event_attribute)
        (subaccount_allocation_key ?subaccount_holding ?allocation_key)
        (event_attribute_reserved ?event_attribute)
        (allocation_key_locked ?allocation_key)
        (not
          (holding_entitlement_confirmed ?client_holding)
        )
        (subaccount_entitlement_confirmed ?subaccount_holding)
        (instruction_packet_available ?instruction_packet)
      )
    :effect
      (and
        (instruction_packet_created ?instruction_packet)
        (instruction_packet_attribute_linked ?instruction_packet ?event_attribute)
        (instruction_packet_allocation_assigned ?instruction_packet ?allocation_key)
        (instruction_packet_requires_approval ?instruction_packet)
        (not
          (instruction_packet_available ?instruction_packet)
        )
      )
  )
  (:action assemble_instruction_packet_with_review_flag
    :parameters (?client_holding - client_holding ?subaccount_holding - subaccount_holding ?event_attribute - event_attribute ?allocation_key - allocation_key ?instruction_packet - instruction_packet)
    :precondition
      (and
        (holding_assessed_for_instruction ?client_holding)
        (subaccount_assessed_for_instruction ?subaccount_holding)
        (holding_attribute_match ?client_holding ?event_attribute)
        (subaccount_allocation_key ?subaccount_holding ?allocation_key)
        (event_attribute_claimed ?event_attribute)
        (allocation_key_flagged ?allocation_key)
        (holding_entitlement_confirmed ?client_holding)
        (not
          (subaccount_entitlement_confirmed ?subaccount_holding)
        )
        (instruction_packet_available ?instruction_packet)
      )
    :effect
      (and
        (instruction_packet_created ?instruction_packet)
        (instruction_packet_attribute_linked ?instruction_packet ?event_attribute)
        (instruction_packet_allocation_assigned ?instruction_packet ?allocation_key)
        (instruction_packet_requires_compliance_review ?instruction_packet)
        (not
          (instruction_packet_available ?instruction_packet)
        )
      )
  )
  (:action assemble_instruction_packet_with_all_flags
    :parameters (?client_holding - client_holding ?subaccount_holding - subaccount_holding ?event_attribute - event_attribute ?allocation_key - allocation_key ?instruction_packet - instruction_packet)
    :precondition
      (and
        (holding_assessed_for_instruction ?client_holding)
        (subaccount_assessed_for_instruction ?subaccount_holding)
        (holding_attribute_match ?client_holding ?event_attribute)
        (subaccount_allocation_key ?subaccount_holding ?allocation_key)
        (event_attribute_reserved ?event_attribute)
        (allocation_key_flagged ?allocation_key)
        (not
          (holding_entitlement_confirmed ?client_holding)
        )
        (not
          (subaccount_entitlement_confirmed ?subaccount_holding)
        )
        (instruction_packet_available ?instruction_packet)
      )
    :effect
      (and
        (instruction_packet_created ?instruction_packet)
        (instruction_packet_attribute_linked ?instruction_packet ?event_attribute)
        (instruction_packet_allocation_assigned ?instruction_packet ?allocation_key)
        (instruction_packet_requires_approval ?instruction_packet)
        (instruction_packet_requires_compliance_review ?instruction_packet)
        (not
          (instruction_packet_available ?instruction_packet)
        )
      )
  )
  (:action mark_instruction_packet_ready_for_validation
    :parameters (?instruction_packet - instruction_packet ?client_holding - client_holding ?election_option - election_option)
    :precondition
      (and
        (instruction_packet_created ?instruction_packet)
        (holding_assessed_for_instruction ?client_holding)
        (election_option_selected ?client_holding ?election_option)
        (not
          (instruction_packet_validated ?instruction_packet)
        )
      )
    :effect (instruction_packet_validated ?instruction_packet)
  )
  (:action attach_supporting_document_to_packet
    :parameters (?processing_case - processing_case ?supporting_document - supporting_document ?instruction_packet - instruction_packet)
    :precondition
      (and
        (election_confirmed ?processing_case)
        (case_includes_instruction_packet ?processing_case ?instruction_packet)
        (case_has_supporting_document ?processing_case ?supporting_document)
        (supporting_document_available ?supporting_document)
        (instruction_packet_created ?instruction_packet)
        (instruction_packet_validated ?instruction_packet)
        (not
          (supporting_document_attached ?supporting_document)
        )
      )
    :effect
      (and
        (supporting_document_attached ?supporting_document)
        (document_linked_to_packet ?supporting_document ?instruction_packet)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action validate_case_documentation
    :parameters (?processing_case - processing_case ?supporting_document - supporting_document ?instruction_packet - instruction_packet ?election_option - election_option)
    :precondition
      (and
        (election_confirmed ?processing_case)
        (case_has_supporting_document ?processing_case ?supporting_document)
        (supporting_document_attached ?supporting_document)
        (document_linked_to_packet ?supporting_document ?instruction_packet)
        (election_option_selected ?processing_case ?election_option)
        (not
          (instruction_packet_requires_approval ?instruction_packet)
        )
        (not
          (case_validated_for_submission ?processing_case)
        )
      )
    :effect (case_validated_for_submission ?processing_case)
  )
  (:action apply_regulatory_flag_to_case
    :parameters (?processing_case - processing_case ?regulatory_flag - regulatory_flag)
    :precondition
      (and
        (election_confirmed ?processing_case)
        (regulatory_flag_available ?regulatory_flag)
        (not
          (regulatory_flag_applied ?processing_case)
        )
      )
    :effect
      (and
        (regulatory_flag_applied ?processing_case)
        (case_has_regulatory_flag ?processing_case ?regulatory_flag)
        (not
          (regulatory_flag_available ?regulatory_flag)
        )
      )
  )
  (:action finalize_regulatory_attachment
    :parameters (?processing_case - processing_case ?supporting_document - supporting_document ?instruction_packet - instruction_packet ?election_option - election_option ?regulatory_flag - regulatory_flag)
    :precondition
      (and
        (election_confirmed ?processing_case)
        (case_has_supporting_document ?processing_case ?supporting_document)
        (supporting_document_attached ?supporting_document)
        (document_linked_to_packet ?supporting_document ?instruction_packet)
        (election_option_selected ?processing_case ?election_option)
        (instruction_packet_requires_approval ?instruction_packet)
        (regulatory_flag_applied ?processing_case)
        (case_has_regulatory_flag ?processing_case ?regulatory_flag)
        (not
          (case_validated_for_submission ?processing_case)
        )
      )
    :effect
      (and
        (case_validated_for_submission ?processing_case)
        (case_regulatory_check_complete ?processing_case)
      )
  )
  (:action submit_case_for_agent_processing
    :parameters (?processing_case - processing_case ?compliance_rule - compliance_rule ?agent_instruction_profile - agent_instruction_profile ?supporting_document - supporting_document ?instruction_packet - instruction_packet)
    :precondition
      (and
        (case_validated_for_submission ?processing_case)
        (case_has_compliance_rule ?processing_case ?compliance_rule)
        (instruction_profile_assigned ?processing_case ?agent_instruction_profile)
        (case_has_supporting_document ?processing_case ?supporting_document)
        (document_linked_to_packet ?supporting_document ?instruction_packet)
        (not
          (instruction_packet_requires_compliance_review ?instruction_packet)
        )
        (not
          (case_submitted ?processing_case)
        )
      )
    :effect (case_submitted ?processing_case)
  )
  (:action submit_case_for_agent_processing_with_packet_flag
    :parameters (?processing_case - processing_case ?compliance_rule - compliance_rule ?agent_instruction_profile - agent_instruction_profile ?supporting_document - supporting_document ?instruction_packet - instruction_packet)
    :precondition
      (and
        (case_validated_for_submission ?processing_case)
        (case_has_compliance_rule ?processing_case ?compliance_rule)
        (instruction_profile_assigned ?processing_case ?agent_instruction_profile)
        (case_has_supporting_document ?processing_case ?supporting_document)
        (document_linked_to_packet ?supporting_document ?instruction_packet)
        (instruction_packet_requires_compliance_review ?instruction_packet)
        (not
          (case_submitted ?processing_case)
        )
      )
    :effect (case_submitted ?processing_case)
  )
  (:action advance_case_to_approval_stage
    :parameters (?processing_case - processing_case ?approval_token - approval_token ?supporting_document - supporting_document ?instruction_packet - instruction_packet)
    :precondition
      (and
        (case_submitted ?processing_case)
        (case_has_approval_token ?processing_case ?approval_token)
        (case_has_supporting_document ?processing_case ?supporting_document)
        (document_linked_to_packet ?supporting_document ?instruction_packet)
        (not
          (instruction_packet_requires_approval ?instruction_packet)
        )
        (not
          (instruction_packet_requires_compliance_review ?instruction_packet)
        )
        (not
          (case_approved_for_posting ?processing_case)
        )
      )
    :effect (case_approved_for_posting ?processing_case)
  )
  (:action advance_case_with_authorizations
    :parameters (?processing_case - processing_case ?approval_token - approval_token ?supporting_document - supporting_document ?instruction_packet - instruction_packet)
    :precondition
      (and
        (case_submitted ?processing_case)
        (case_has_approval_token ?processing_case ?approval_token)
        (case_has_supporting_document ?processing_case ?supporting_document)
        (document_linked_to_packet ?supporting_document ?instruction_packet)
        (instruction_packet_requires_approval ?instruction_packet)
        (not
          (instruction_packet_requires_compliance_review ?instruction_packet)
        )
        (not
          (case_approved_for_posting ?processing_case)
        )
      )
    :effect
      (and
        (case_approved_for_posting ?processing_case)
        (case_has_approvals ?processing_case)
      )
  )
  (:action advance_case_and_set_authorizations
    :parameters (?processing_case - processing_case ?approval_token - approval_token ?supporting_document - supporting_document ?instruction_packet - instruction_packet)
    :precondition
      (and
        (case_submitted ?processing_case)
        (case_has_approval_token ?processing_case ?approval_token)
        (case_has_supporting_document ?processing_case ?supporting_document)
        (document_linked_to_packet ?supporting_document ?instruction_packet)
        (not
          (instruction_packet_requires_approval ?instruction_packet)
        )
        (instruction_packet_requires_compliance_review ?instruction_packet)
        (not
          (case_approved_for_posting ?processing_case)
        )
      )
    :effect
      (and
        (case_approved_for_posting ?processing_case)
        (case_has_approvals ?processing_case)
      )
  )
  (:action finalize_case_authorizations
    :parameters (?processing_case - processing_case ?approval_token - approval_token ?supporting_document - supporting_document ?instruction_packet - instruction_packet)
    :precondition
      (and
        (case_submitted ?processing_case)
        (case_has_approval_token ?processing_case ?approval_token)
        (case_has_supporting_document ?processing_case ?supporting_document)
        (document_linked_to_packet ?supporting_document ?instruction_packet)
        (instruction_packet_requires_approval ?instruction_packet)
        (instruction_packet_requires_compliance_review ?instruction_packet)
        (not
          (case_approved_for_posting ?processing_case)
        )
      )
    :effect
      (and
        (case_approved_for_posting ?processing_case)
        (case_has_approvals ?processing_case)
      )
  )
  (:action post_case_for_application
    :parameters (?processing_case - processing_case)
    :precondition
      (and
        (case_approved_for_posting ?processing_case)
        (not
          (case_has_approvals ?processing_case)
        )
        (not
          (case_posting_recorded ?processing_case)
        )
      )
    :effect
      (and
        (case_posting_recorded ?processing_case)
        (ready_for_application ?processing_case)
      )
  )
  (:action assign_settlement_option_to_case
    :parameters (?processing_case - processing_case ?settlement_option - settlement_option)
    :precondition
      (and
        (case_approved_for_posting ?processing_case)
        (case_has_approvals ?processing_case)
        (settlement_option_available ?settlement_option)
      )
    :effect
      (and
        (case_settlement_option_assigned ?processing_case ?settlement_option)
        (not
          (settlement_option_available ?settlement_option)
        )
      )
  )
  (:action perform_final_compliance_checks
    :parameters (?processing_case - processing_case ?client_holding - client_holding ?subaccount_holding - subaccount_holding ?election_option - election_option ?settlement_option - settlement_option)
    :precondition
      (and
        (case_approved_for_posting ?processing_case)
        (case_has_approvals ?processing_case)
        (case_settlement_option_assigned ?processing_case ?settlement_option)
        (case_includes_client_holding ?processing_case ?client_holding)
        (case_includes_subaccount ?processing_case ?subaccount_holding)
        (holding_entitlement_confirmed ?client_holding)
        (subaccount_entitlement_confirmed ?subaccount_holding)
        (election_option_selected ?processing_case ?election_option)
        (not
          (case_final_compliance_checked ?processing_case)
        )
      )
    :effect (case_final_compliance_checked ?processing_case)
  )
  (:action finalize_case_posting
    :parameters (?processing_case - processing_case)
    :precondition
      (and
        (case_approved_for_posting ?processing_case)
        (case_final_compliance_checked ?processing_case)
        (not
          (case_posting_recorded ?processing_case)
        )
      )
    :effect
      (and
        (case_posting_recorded ?processing_case)
        (ready_for_application ?processing_case)
      )
  )
  (:action attach_authorization_credential_to_case
    :parameters (?processing_case - processing_case ?authorization_credential - authorization_credential ?election_option - election_option)
    :precondition
      (and
        (election_confirmed ?processing_case)
        (election_option_selected ?processing_case ?election_option)
        (authorization_credential_available ?authorization_credential)
        (case_has_authorization_credential ?processing_case ?authorization_credential)
        (not
          (case_authorized_by_credential ?processing_case)
        )
      )
    :effect
      (and
        (case_authorized_by_credential ?processing_case)
        (not
          (authorization_credential_available ?authorization_credential)
        )
      )
  )
  (:action initiate_case_approval
    :parameters (?processing_case - processing_case ?agent_instruction_profile - agent_instruction_profile)
    :precondition
      (and
        (case_authorized_by_credential ?processing_case)
        (instruction_profile_assigned ?processing_case ?agent_instruction_profile)
        (not
          (case_in_approval_step ?processing_case)
        )
      )
    :effect (case_in_approval_step ?processing_case)
  )
  (:action apply_approval_token_to_case
    :parameters (?processing_case - processing_case ?approval_token - approval_token)
    :precondition
      (and
        (case_in_approval_step ?processing_case)
        (case_has_approval_token ?processing_case ?approval_token)
        (not
          (case_approval_obtained ?processing_case)
        )
      )
    :effect (case_approval_obtained ?processing_case)
  )
  (:action finalize_case_approval
    :parameters (?processing_case - processing_case)
    :precondition
      (and
        (case_approval_obtained ?processing_case)
        (not
          (case_posting_recorded ?processing_case)
        )
      )
    :effect
      (and
        (case_posting_recorded ?processing_case)
        (ready_for_application ?processing_case)
      )
  )
  (:action post_holding_for_application
    :parameters (?client_holding - client_holding ?instruction_packet - instruction_packet)
    :precondition
      (and
        (holding_assessed_for_instruction ?client_holding)
        (holding_entitlement_confirmed ?client_holding)
        (instruction_packet_created ?instruction_packet)
        (instruction_packet_validated ?instruction_packet)
        (not
          (ready_for_application ?client_holding)
        )
      )
    :effect (ready_for_application ?client_holding)
  )
  (:action post_subaccount_for_application
    :parameters (?subaccount_holding - subaccount_holding ?instruction_packet - instruction_packet)
    :precondition
      (and
        (subaccount_assessed_for_instruction ?subaccount_holding)
        (subaccount_entitlement_confirmed ?subaccount_holding)
        (instruction_packet_created ?instruction_packet)
        (instruction_packet_validated ?instruction_packet)
        (not
          (ready_for_application ?subaccount_holding)
        )
      )
    :effect (ready_for_application ?subaccount_holding)
  )
  (:action authorize_election_application
    :parameters (?corporate_action_notice - notice_entity ?settlement_reference - settlement_reference ?election_option - election_option)
    :precondition
      (and
        (ready_for_application ?corporate_action_notice)
        (election_option_selected ?corporate_action_notice ?election_option)
        (settlement_reference_available ?settlement_reference)
        (not
          (application_authorized_for_entity ?corporate_action_notice)
        )
      )
    :effect
      (and
        (application_authorized_for_entity ?corporate_action_notice)
        (settlement_reference_associated ?corporate_action_notice ?settlement_reference)
        (not
          (settlement_reference_available ?settlement_reference)
        )
      )
  )
  (:action apply_election_to_holding
    :parameters (?client_holding - client_holding ?service_agent - service_agent ?settlement_reference - settlement_reference)
    :precondition
      (and
        (application_authorized_for_entity ?client_holding)
        (agent_assigned ?client_holding ?service_agent)
        (settlement_reference_associated ?client_holding ?settlement_reference)
        (not
          (election_applied ?client_holding)
        )
      )
    :effect
      (and
        (election_applied ?client_holding)
        (agent_available ?service_agent)
        (settlement_reference_available ?settlement_reference)
      )
  )
  (:action apply_election_to_subaccount
    :parameters (?subaccount_holding - subaccount_holding ?service_agent - service_agent ?settlement_reference - settlement_reference)
    :precondition
      (and
        (application_authorized_for_entity ?subaccount_holding)
        (agent_assigned ?subaccount_holding ?service_agent)
        (settlement_reference_associated ?subaccount_holding ?settlement_reference)
        (not
          (election_applied ?subaccount_holding)
        )
      )
    :effect
      (and
        (election_applied ?subaccount_holding)
        (agent_available ?service_agent)
        (settlement_reference_available ?settlement_reference)
      )
  )
  (:action apply_election_to_case
    :parameters (?processing_case - processing_case ?service_agent - service_agent ?settlement_reference - settlement_reference)
    :precondition
      (and
        (application_authorized_for_entity ?processing_case)
        (agent_assigned ?processing_case ?service_agent)
        (settlement_reference_associated ?processing_case ?settlement_reference)
        (not
          (election_applied ?processing_case)
        )
      )
    :effect
      (and
        (election_applied ?processing_case)
        (agent_available ?service_agent)
        (settlement_reference_available ?settlement_reference)
      )
  )
)

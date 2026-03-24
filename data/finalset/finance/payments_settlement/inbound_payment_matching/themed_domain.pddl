(define (domain inbound_payment_matching)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object support_entity - entity reference_entity - entity channel_entity - entity domain_root - entity inbound_payment_instruction - domain_root processing_resource - support_entity payment_message - support_entity verification_operator - support_entity regulatory_flag - support_entity settlement_preference - support_entity routing_profile - support_entity authorization_token - support_entity compliance_document - support_entity match_attribute - reference_entity match_key - reference_entity external_reference - reference_entity debit_settlement_channel - channel_entity credit_settlement_channel - channel_entity settlement_instruction - channel_entity ledger_leg_type - inbound_payment_instruction matching_session_type - inbound_payment_instruction debit_leg - ledger_leg_type credit_leg - ledger_leg_type matching_session - matching_session_type)

  (:predicates
    (entity_registered ?inbound_payment_instruction - inbound_payment_instruction)
    (entity_validated ?inbound_payment_instruction - inbound_payment_instruction)
    (processing_assigned ?inbound_payment_instruction - inbound_payment_instruction)
    (released_for_settlement ?inbound_payment_instruction - inbound_payment_instruction)
    (ready_for_settlement ?inbound_payment_instruction - inbound_payment_instruction)
    (release_authorized ?inbound_payment_instruction - inbound_payment_instruction)
    (resource_available ?processing_resource - processing_resource)
    (assigned_to_processing_resource ?inbound_payment_instruction - inbound_payment_instruction ?processing_resource - processing_resource)
    (message_available ?payment_message - payment_message)
    (entity_has_message ?inbound_payment_instruction - inbound_payment_instruction ?payment_message - payment_message)
    (operator_available ?verification_operator - verification_operator)
    (assigned_verification_operator ?inbound_payment_instruction - inbound_payment_instruction ?verification_operator - verification_operator)
    (match_attribute_available ?match_attribute - match_attribute)
    (debit_leg_has_match_attribute ?debit_leg - debit_leg ?match_attribute - match_attribute)
    (credit_leg_has_match_attribute ?credit_leg - credit_leg ?match_attribute - match_attribute)
    (debit_leg_channel_candidate ?debit_leg - debit_leg ?debit_settlement_channel - debit_settlement_channel)
    (debit_channel_selected ?debit_settlement_channel - debit_settlement_channel)
    (debit_channel_attribute_flag ?debit_settlement_channel - debit_settlement_channel)
    (debit_leg_channel_confirmed ?debit_leg - debit_leg)
    (credit_leg_channel_candidate ?credit_leg - credit_leg ?credit_settlement_channel - credit_settlement_channel)
    (credit_channel_selected ?credit_settlement_channel - credit_settlement_channel)
    (credit_channel_attribute_flag ?credit_settlement_channel - credit_settlement_channel)
    (credit_leg_channel_confirmed ?credit_leg - credit_leg)
    (settlement_instruction_pending ?settlement_instruction - settlement_instruction)
    (settlement_instruction_ready ?settlement_instruction - settlement_instruction)
    (entity_bound_to_debit_channel ?settlement_instruction - settlement_instruction ?debit_settlement_channel - debit_settlement_channel)
    (entity_bound_to_credit_channel ?settlement_instruction - settlement_instruction ?credit_settlement_channel - credit_settlement_channel)
    (entity_debit_attribute_flag ?settlement_instruction - settlement_instruction)
    (entity_credit_attribute_flag ?settlement_instruction - settlement_instruction)
    (settlement_instruction_validated ?settlement_instruction - settlement_instruction)
    (session_has_debit_leg ?matching_session - matching_session ?debit_leg - debit_leg)
    (session_has_credit_leg ?matching_session - matching_session ?credit_leg - credit_leg)
    (session_has_settlement_instruction ?matching_session - matching_session ?settlement_instruction - settlement_instruction)
    (match_key_available ?match_key - match_key)
    (session_has_match_key ?matching_session - matching_session ?match_key - match_key)
    (match_key_bound ?match_key - match_key)
    (match_key_bound_to_instruction ?match_key - match_key ?settlement_instruction - settlement_instruction)
    (session_documents_bound ?matching_session - matching_session)
    (session_enriched_for_compliance ?matching_session - matching_session)
    (session_compliance_cleared ?matching_session - matching_session)
    (session_regulatory_flag_pending ?matching_session - matching_session)
    (session_regulatory_flag_applied ?matching_session - matching_session)
    (session_eligible_for_preference ?matching_session - matching_session)
    (session_ready_for_final_decision ?matching_session - matching_session)
    (external_reference_available ?external_reference - external_reference)
    (session_has_external_reference ?matching_session - matching_session ?external_reference - external_reference)
    (session_external_reference_validated ?matching_session - matching_session)
    (session_operator_confirmed_for_reference ?matching_session - matching_session)
    (session_reference_compliance_attached ?matching_session - matching_session)
    (regulatory_flag_available ?regulatory_flag - regulatory_flag)
    (session_regulatory_flag_assigned ?matching_session - matching_session ?regulatory_flag - regulatory_flag)
    (settlement_preference_available ?settlement_preference - settlement_preference)
    (session_has_settlement_preference ?matching_session - matching_session ?settlement_preference - settlement_preference)
    (authorization_token_available ?authorization_token - authorization_token)
    (session_has_authorization_token ?matching_session - matching_session ?authorization_token - authorization_token)
    (compliance_document_available ?compliance_document - compliance_document)
    (session_has_compliance_document ?matching_session - matching_session ?compliance_document - compliance_document)
    (routing_profile_available ?routing_profile - routing_profile)
    (entity_has_routing_profile ?inbound_payment_instruction - inbound_payment_instruction ?routing_profile - routing_profile)
    (debit_leg_ready ?debit_leg - debit_leg)
    (credit_leg_ready ?credit_leg - credit_leg)
    (session_committed ?matching_session - matching_session)
  )
  (:action receive_and_register_instruction
    :parameters (?inbound_payment_instruction - inbound_payment_instruction)
    :precondition
      (and
        (not
          (entity_registered ?inbound_payment_instruction)
        )
        (not
          (released_for_settlement ?inbound_payment_instruction)
        )
      )
    :effect (entity_registered ?inbound_payment_instruction)
  )
  (:action assign_processing_resource
    :parameters (?inbound_payment_instruction - inbound_payment_instruction ?processing_resource - processing_resource)
    :precondition
      (and
        (entity_registered ?inbound_payment_instruction)
        (not
          (processing_assigned ?inbound_payment_instruction)
        )
        (resource_available ?processing_resource)
      )
    :effect
      (and
        (processing_assigned ?inbound_payment_instruction)
        (assigned_to_processing_resource ?inbound_payment_instruction ?processing_resource)
        (not
          (resource_available ?processing_resource)
        )
      )
  )
  (:action extract_and_attach_payment_message
    :parameters (?inbound_payment_instruction - inbound_payment_instruction ?payment_message - payment_message)
    :precondition
      (and
        (entity_registered ?inbound_payment_instruction)
        (processing_assigned ?inbound_payment_instruction)
        (message_available ?payment_message)
      )
    :effect
      (and
        (entity_has_message ?inbound_payment_instruction ?payment_message)
        (not
          (message_available ?payment_message)
        )
      )
  )
  (:action validate_instruction_message
    :parameters (?inbound_payment_instruction - inbound_payment_instruction ?payment_message - payment_message)
    :precondition
      (and
        (entity_registered ?inbound_payment_instruction)
        (processing_assigned ?inbound_payment_instruction)
        (entity_has_message ?inbound_payment_instruction ?payment_message)
        (not
          (entity_validated ?inbound_payment_instruction)
        )
      )
    :effect (entity_validated ?inbound_payment_instruction)
  )
  (:action release_payment_message
    :parameters (?inbound_payment_instruction - inbound_payment_instruction ?payment_message - payment_message)
    :precondition
      (and
        (entity_has_message ?inbound_payment_instruction ?payment_message)
      )
    :effect
      (and
        (message_available ?payment_message)
        (not
          (entity_has_message ?inbound_payment_instruction ?payment_message)
        )
      )
  )
  (:action assign_verification_operator
    :parameters (?inbound_payment_instruction - inbound_payment_instruction ?verification_operator - verification_operator)
    :precondition
      (and
        (entity_validated ?inbound_payment_instruction)
        (operator_available ?verification_operator)
      )
    :effect
      (and
        (assigned_verification_operator ?inbound_payment_instruction ?verification_operator)
        (not
          (operator_available ?verification_operator)
        )
      )
  )
  (:action release_verification_operator
    :parameters (?inbound_payment_instruction - inbound_payment_instruction ?verification_operator - verification_operator)
    :precondition
      (and
        (assigned_verification_operator ?inbound_payment_instruction ?verification_operator)
      )
    :effect
      (and
        (operator_available ?verification_operator)
        (not
          (assigned_verification_operator ?inbound_payment_instruction ?verification_operator)
        )
      )
  )
  (:action assign_authorization_token_to_session
    :parameters (?matching_session - matching_session ?authorization_token - authorization_token)
    :precondition
      (and
        (entity_validated ?matching_session)
        (authorization_token_available ?authorization_token)
      )
    :effect
      (and
        (session_has_authorization_token ?matching_session ?authorization_token)
        (not
          (authorization_token_available ?authorization_token)
        )
      )
  )
  (:action release_authorization_token
    :parameters (?matching_session - matching_session ?authorization_token - authorization_token)
    :precondition
      (and
        (session_has_authorization_token ?matching_session ?authorization_token)
      )
    :effect
      (and
        (authorization_token_available ?authorization_token)
        (not
          (session_has_authorization_token ?matching_session ?authorization_token)
        )
      )
  )
  (:action attach_compliance_document_to_session
    :parameters (?matching_session - matching_session ?compliance_document - compliance_document)
    :precondition
      (and
        (entity_validated ?matching_session)
        (compliance_document_available ?compliance_document)
      )
    :effect
      (and
        (session_has_compliance_document ?matching_session ?compliance_document)
        (not
          (compliance_document_available ?compliance_document)
        )
      )
  )
  (:action release_compliance_document
    :parameters (?matching_session - matching_session ?compliance_document - compliance_document)
    :precondition
      (and
        (session_has_compliance_document ?matching_session ?compliance_document)
      )
    :effect
      (and
        (compliance_document_available ?compliance_document)
        (not
          (session_has_compliance_document ?matching_session ?compliance_document)
        )
      )
  )
  (:action discover_debit_channel
    :parameters (?debit_leg - debit_leg ?debit_settlement_channel - debit_settlement_channel ?payment_message - payment_message)
    :precondition
      (and
        (entity_validated ?debit_leg)
        (entity_has_message ?debit_leg ?payment_message)
        (debit_leg_channel_candidate ?debit_leg ?debit_settlement_channel)
        (not
          (debit_channel_selected ?debit_settlement_channel)
        )
        (not
          (debit_channel_attribute_flag ?debit_settlement_channel)
        )
      )
    :effect (debit_channel_selected ?debit_settlement_channel)
  )
  (:action confirm_debit_channel_with_operator
    :parameters (?debit_leg - debit_leg ?debit_settlement_channel - debit_settlement_channel ?verification_operator - verification_operator)
    :precondition
      (and
        (entity_validated ?debit_leg)
        (assigned_verification_operator ?debit_leg ?verification_operator)
        (debit_leg_channel_candidate ?debit_leg ?debit_settlement_channel)
        (debit_channel_selected ?debit_settlement_channel)
        (not
          (debit_leg_ready ?debit_leg)
        )
      )
    :effect
      (and
        (debit_leg_ready ?debit_leg)
        (debit_leg_channel_confirmed ?debit_leg)
      )
  )
  (:action apply_match_attribute_to_debit_leg
    :parameters (?debit_leg - debit_leg ?debit_settlement_channel - debit_settlement_channel ?match_attribute - match_attribute)
    :precondition
      (and
        (entity_validated ?debit_leg)
        (debit_leg_channel_candidate ?debit_leg ?debit_settlement_channel)
        (match_attribute_available ?match_attribute)
        (not
          (debit_leg_ready ?debit_leg)
        )
      )
    :effect
      (and
        (debit_channel_attribute_flag ?debit_settlement_channel)
        (debit_leg_ready ?debit_leg)
        (debit_leg_has_match_attribute ?debit_leg ?match_attribute)
        (not
          (match_attribute_available ?match_attribute)
        )
      )
  )
  (:action finalize_debit_channel_selection
    :parameters (?debit_leg - debit_leg ?debit_settlement_channel - debit_settlement_channel ?payment_message - payment_message ?match_attribute - match_attribute)
    :precondition
      (and
        (entity_validated ?debit_leg)
        (entity_has_message ?debit_leg ?payment_message)
        (debit_leg_channel_candidate ?debit_leg ?debit_settlement_channel)
        (debit_channel_attribute_flag ?debit_settlement_channel)
        (debit_leg_has_match_attribute ?debit_leg ?match_attribute)
        (not
          (debit_leg_channel_confirmed ?debit_leg)
        )
      )
    :effect
      (and
        (debit_channel_selected ?debit_settlement_channel)
        (debit_leg_channel_confirmed ?debit_leg)
        (match_attribute_available ?match_attribute)
        (not
          (debit_leg_has_match_attribute ?debit_leg ?match_attribute)
        )
      )
  )
  (:action discover_credit_channel
    :parameters (?credit_leg - credit_leg ?credit_settlement_channel - credit_settlement_channel ?payment_message - payment_message)
    :precondition
      (and
        (entity_validated ?credit_leg)
        (entity_has_message ?credit_leg ?payment_message)
        (credit_leg_channel_candidate ?credit_leg ?credit_settlement_channel)
        (not
          (credit_channel_selected ?credit_settlement_channel)
        )
        (not
          (credit_channel_attribute_flag ?credit_settlement_channel)
        )
      )
    :effect (credit_channel_selected ?credit_settlement_channel)
  )
  (:action confirm_credit_channel_with_operator
    :parameters (?credit_leg - credit_leg ?credit_settlement_channel - credit_settlement_channel ?verification_operator - verification_operator)
    :precondition
      (and
        (entity_validated ?credit_leg)
        (assigned_verification_operator ?credit_leg ?verification_operator)
        (credit_leg_channel_candidate ?credit_leg ?credit_settlement_channel)
        (credit_channel_selected ?credit_settlement_channel)
        (not
          (credit_leg_ready ?credit_leg)
        )
      )
    :effect
      (and
        (credit_leg_ready ?credit_leg)
        (credit_leg_channel_confirmed ?credit_leg)
      )
  )
  (:action apply_match_attribute_to_credit_leg
    :parameters (?credit_leg - credit_leg ?credit_settlement_channel - credit_settlement_channel ?match_attribute - match_attribute)
    :precondition
      (and
        (entity_validated ?credit_leg)
        (credit_leg_channel_candidate ?credit_leg ?credit_settlement_channel)
        (match_attribute_available ?match_attribute)
        (not
          (credit_leg_ready ?credit_leg)
        )
      )
    :effect
      (and
        (credit_channel_attribute_flag ?credit_settlement_channel)
        (credit_leg_ready ?credit_leg)
        (credit_leg_has_match_attribute ?credit_leg ?match_attribute)
        (not
          (match_attribute_available ?match_attribute)
        )
      )
  )
  (:action finalize_credit_channel_selection
    :parameters (?credit_leg - credit_leg ?credit_settlement_channel - credit_settlement_channel ?payment_message - payment_message ?match_attribute - match_attribute)
    :precondition
      (and
        (entity_validated ?credit_leg)
        (entity_has_message ?credit_leg ?payment_message)
        (credit_leg_channel_candidate ?credit_leg ?credit_settlement_channel)
        (credit_channel_attribute_flag ?credit_settlement_channel)
        (credit_leg_has_match_attribute ?credit_leg ?match_attribute)
        (not
          (credit_leg_channel_confirmed ?credit_leg)
        )
      )
    :effect
      (and
        (credit_channel_selected ?credit_settlement_channel)
        (credit_leg_channel_confirmed ?credit_leg)
        (match_attribute_available ?match_attribute)
        (not
          (credit_leg_has_match_attribute ?credit_leg ?match_attribute)
        )
      )
  )
  (:action assemble_settlement_instruction_standard
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_settlement_channel - debit_settlement_channel ?credit_settlement_channel - credit_settlement_channel ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (debit_leg_ready ?debit_leg)
        (credit_leg_ready ?credit_leg)
        (debit_leg_channel_candidate ?debit_leg ?debit_settlement_channel)
        (credit_leg_channel_candidate ?credit_leg ?credit_settlement_channel)
        (debit_channel_selected ?debit_settlement_channel)
        (credit_channel_selected ?credit_settlement_channel)
        (debit_leg_channel_confirmed ?debit_leg)
        (credit_leg_channel_confirmed ?credit_leg)
        (settlement_instruction_pending ?settlement_instruction)
      )
    :effect
      (and
        (settlement_instruction_ready ?settlement_instruction)
        (entity_bound_to_debit_channel ?settlement_instruction ?debit_settlement_channel)
        (entity_bound_to_credit_channel ?settlement_instruction ?credit_settlement_channel)
        (not
          (settlement_instruction_pending ?settlement_instruction)
        )
      )
  )
  (:action assemble_settlement_instruction_with_debit_attribute
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_settlement_channel - debit_settlement_channel ?credit_settlement_channel - credit_settlement_channel ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (debit_leg_ready ?debit_leg)
        (credit_leg_ready ?credit_leg)
        (debit_leg_channel_candidate ?debit_leg ?debit_settlement_channel)
        (credit_leg_channel_candidate ?credit_leg ?credit_settlement_channel)
        (debit_channel_attribute_flag ?debit_settlement_channel)
        (credit_channel_selected ?credit_settlement_channel)
        (not
          (debit_leg_channel_confirmed ?debit_leg)
        )
        (credit_leg_channel_confirmed ?credit_leg)
        (settlement_instruction_pending ?settlement_instruction)
      )
    :effect
      (and
        (settlement_instruction_ready ?settlement_instruction)
        (entity_bound_to_debit_channel ?settlement_instruction ?debit_settlement_channel)
        (entity_bound_to_credit_channel ?settlement_instruction ?credit_settlement_channel)
        (entity_debit_attribute_flag ?settlement_instruction)
        (not
          (settlement_instruction_pending ?settlement_instruction)
        )
      )
  )
  (:action assemble_settlement_instruction_with_credit_attribute
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_settlement_channel - debit_settlement_channel ?credit_settlement_channel - credit_settlement_channel ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (debit_leg_ready ?debit_leg)
        (credit_leg_ready ?credit_leg)
        (debit_leg_channel_candidate ?debit_leg ?debit_settlement_channel)
        (credit_leg_channel_candidate ?credit_leg ?credit_settlement_channel)
        (debit_channel_selected ?debit_settlement_channel)
        (credit_channel_attribute_flag ?credit_settlement_channel)
        (debit_leg_channel_confirmed ?debit_leg)
        (not
          (credit_leg_channel_confirmed ?credit_leg)
        )
        (settlement_instruction_pending ?settlement_instruction)
      )
    :effect
      (and
        (settlement_instruction_ready ?settlement_instruction)
        (entity_bound_to_debit_channel ?settlement_instruction ?debit_settlement_channel)
        (entity_bound_to_credit_channel ?settlement_instruction ?credit_settlement_channel)
        (entity_credit_attribute_flag ?settlement_instruction)
        (not
          (settlement_instruction_pending ?settlement_instruction)
        )
      )
  )
  (:action assemble_settlement_instruction_with_both_attributes
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_settlement_channel - debit_settlement_channel ?credit_settlement_channel - credit_settlement_channel ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (debit_leg_ready ?debit_leg)
        (credit_leg_ready ?credit_leg)
        (debit_leg_channel_candidate ?debit_leg ?debit_settlement_channel)
        (credit_leg_channel_candidate ?credit_leg ?credit_settlement_channel)
        (debit_channel_attribute_flag ?debit_settlement_channel)
        (credit_channel_attribute_flag ?credit_settlement_channel)
        (not
          (debit_leg_channel_confirmed ?debit_leg)
        )
        (not
          (credit_leg_channel_confirmed ?credit_leg)
        )
        (settlement_instruction_pending ?settlement_instruction)
      )
    :effect
      (and
        (settlement_instruction_ready ?settlement_instruction)
        (entity_bound_to_debit_channel ?settlement_instruction ?debit_settlement_channel)
        (entity_bound_to_credit_channel ?settlement_instruction ?credit_settlement_channel)
        (entity_debit_attribute_flag ?settlement_instruction)
        (entity_credit_attribute_flag ?settlement_instruction)
        (not
          (settlement_instruction_pending ?settlement_instruction)
        )
      )
  )
  (:action validate_settlement_instruction
    :parameters (?settlement_instruction - settlement_instruction ?debit_leg - debit_leg ?payment_message - payment_message)
    :precondition
      (and
        (settlement_instruction_ready ?settlement_instruction)
        (debit_leg_ready ?debit_leg)
        (entity_has_message ?debit_leg ?payment_message)
        (not
          (settlement_instruction_validated ?settlement_instruction)
        )
      )
    :effect (settlement_instruction_validated ?settlement_instruction)
  )
  (:action bind_match_key_and_documents
    :parameters (?matching_session - matching_session ?match_key - match_key ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (entity_validated ?matching_session)
        (session_has_settlement_instruction ?matching_session ?settlement_instruction)
        (session_has_match_key ?matching_session ?match_key)
        (match_key_available ?match_key)
        (settlement_instruction_ready ?settlement_instruction)
        (settlement_instruction_validated ?settlement_instruction)
        (not
          (match_key_bound ?match_key)
        )
      )
    :effect
      (and
        (match_key_bound ?match_key)
        (match_key_bound_to_instruction ?match_key ?settlement_instruction)
        (not
          (match_key_available ?match_key)
        )
      )
  )
  (:action finalize_document_binding_on_session
    :parameters (?matching_session - matching_session ?match_key - match_key ?settlement_instruction - settlement_instruction ?payment_message - payment_message)
    :precondition
      (and
        (entity_validated ?matching_session)
        (session_has_match_key ?matching_session ?match_key)
        (match_key_bound ?match_key)
        (match_key_bound_to_instruction ?match_key ?settlement_instruction)
        (entity_has_message ?matching_session ?payment_message)
        (not
          (entity_debit_attribute_flag ?settlement_instruction)
        )
        (not
          (session_documents_bound ?matching_session)
        )
      )
    :effect (session_documents_bound ?matching_session)
  )
  (:action attach_regulatory_flag_to_session
    :parameters (?matching_session - matching_session ?regulatory_flag - regulatory_flag)
    :precondition
      (and
        (entity_validated ?matching_session)
        (regulatory_flag_available ?regulatory_flag)
        (not
          (session_regulatory_flag_pending ?matching_session)
        )
      )
    :effect
      (and
        (session_regulatory_flag_pending ?matching_session)
        (session_regulatory_flag_assigned ?matching_session ?regulatory_flag)
        (not
          (regulatory_flag_available ?regulatory_flag)
        )
      )
  )
  (:action apply_regulatory_flag_and_bind_documents
    :parameters (?matching_session - matching_session ?match_key - match_key ?settlement_instruction - settlement_instruction ?payment_message - payment_message ?regulatory_flag - regulatory_flag)
    :precondition
      (and
        (entity_validated ?matching_session)
        (session_has_match_key ?matching_session ?match_key)
        (match_key_bound ?match_key)
        (match_key_bound_to_instruction ?match_key ?settlement_instruction)
        (entity_has_message ?matching_session ?payment_message)
        (entity_debit_attribute_flag ?settlement_instruction)
        (session_regulatory_flag_pending ?matching_session)
        (session_regulatory_flag_assigned ?matching_session ?regulatory_flag)
        (not
          (session_documents_bound ?matching_session)
        )
      )
    :effect
      (and
        (session_documents_bound ?matching_session)
        (session_regulatory_flag_applied ?matching_session)
      )
  )
  (:action enrich_session_with_authorization_and_operator
    :parameters (?matching_session - matching_session ?authorization_token - authorization_token ?verification_operator - verification_operator ?match_key - match_key ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (session_documents_bound ?matching_session)
        (session_has_authorization_token ?matching_session ?authorization_token)
        (assigned_verification_operator ?matching_session ?verification_operator)
        (session_has_match_key ?matching_session ?match_key)
        (match_key_bound_to_instruction ?match_key ?settlement_instruction)
        (not
          (entity_credit_attribute_flag ?settlement_instruction)
        )
        (not
          (session_enriched_for_compliance ?matching_session)
        )
      )
    :effect (session_enriched_for_compliance ?matching_session)
  )
  (:action enrich_session_with_authorization_and_operator_alternate
    :parameters (?matching_session - matching_session ?authorization_token - authorization_token ?verification_operator - verification_operator ?match_key - match_key ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (session_documents_bound ?matching_session)
        (session_has_authorization_token ?matching_session ?authorization_token)
        (assigned_verification_operator ?matching_session ?verification_operator)
        (session_has_match_key ?matching_session ?match_key)
        (match_key_bound_to_instruction ?match_key ?settlement_instruction)
        (entity_credit_attribute_flag ?settlement_instruction)
        (not
          (session_enriched_for_compliance ?matching_session)
        )
      )
    :effect (session_enriched_for_compliance ?matching_session)
  )
  (:action apply_compliance_document_for_session
    :parameters (?matching_session - matching_session ?compliance_document - compliance_document ?match_key - match_key ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (session_enriched_for_compliance ?matching_session)
        (session_has_compliance_document ?matching_session ?compliance_document)
        (session_has_match_key ?matching_session ?match_key)
        (match_key_bound_to_instruction ?match_key ?settlement_instruction)
        (not
          (entity_debit_attribute_flag ?settlement_instruction)
        )
        (not
          (entity_credit_attribute_flag ?settlement_instruction)
        )
        (not
          (session_compliance_cleared ?matching_session)
        )
      )
    :effect (session_compliance_cleared ?matching_session)
  )
  (:action apply_compliance_and_mark_preference_eligible
    :parameters (?matching_session - matching_session ?compliance_document - compliance_document ?match_key - match_key ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (session_enriched_for_compliance ?matching_session)
        (session_has_compliance_document ?matching_session ?compliance_document)
        (session_has_match_key ?matching_session ?match_key)
        (match_key_bound_to_instruction ?match_key ?settlement_instruction)
        (entity_debit_attribute_flag ?settlement_instruction)
        (not
          (entity_credit_attribute_flag ?settlement_instruction)
        )
        (not
          (session_compliance_cleared ?matching_session)
        )
      )
    :effect
      (and
        (session_compliance_cleared ?matching_session)
        (session_eligible_for_preference ?matching_session)
      )
  )
  (:action apply_compliance_and_mark_preference_eligible_alt
    :parameters (?matching_session - matching_session ?compliance_document - compliance_document ?match_key - match_key ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (session_enriched_for_compliance ?matching_session)
        (session_has_compliance_document ?matching_session ?compliance_document)
        (session_has_match_key ?matching_session ?match_key)
        (match_key_bound_to_instruction ?match_key ?settlement_instruction)
        (not
          (entity_debit_attribute_flag ?settlement_instruction)
        )
        (entity_credit_attribute_flag ?settlement_instruction)
        (not
          (session_compliance_cleared ?matching_session)
        )
      )
    :effect
      (and
        (session_compliance_cleared ?matching_session)
        (session_eligible_for_preference ?matching_session)
      )
  )
  (:action apply_compliance_and_mark_preference_eligible_both
    :parameters (?matching_session - matching_session ?compliance_document - compliance_document ?match_key - match_key ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (session_enriched_for_compliance ?matching_session)
        (session_has_compliance_document ?matching_session ?compliance_document)
        (session_has_match_key ?matching_session ?match_key)
        (match_key_bound_to_instruction ?match_key ?settlement_instruction)
        (entity_debit_attribute_flag ?settlement_instruction)
        (entity_credit_attribute_flag ?settlement_instruction)
        (not
          (session_compliance_cleared ?matching_session)
        )
      )
    :effect
      (and
        (session_compliance_cleared ?matching_session)
        (session_eligible_for_preference ?matching_session)
      )
  )
  (:action commit_session_and_mark_ready
    :parameters (?matching_session - matching_session)
    :precondition
      (and
        (session_compliance_cleared ?matching_session)
        (not
          (session_eligible_for_preference ?matching_session)
        )
        (not
          (session_committed ?matching_session)
        )
      )
    :effect
      (and
        (session_committed ?matching_session)
        (ready_for_settlement ?matching_session)
      )
  )
  (:action attach_settlement_preference_to_session
    :parameters (?matching_session - matching_session ?settlement_preference - settlement_preference)
    :precondition
      (and
        (session_compliance_cleared ?matching_session)
        (session_eligible_for_preference ?matching_session)
        (settlement_preference_available ?settlement_preference)
      )
    :effect
      (and
        (session_has_settlement_preference ?matching_session ?settlement_preference)
        (not
          (settlement_preference_available ?settlement_preference)
        )
      )
  )
  (:action proceed_session_to_decision
    :parameters (?matching_session - matching_session ?debit_leg - debit_leg ?credit_leg - credit_leg ?payment_message - payment_message ?settlement_preference - settlement_preference)
    :precondition
      (and
        (session_compliance_cleared ?matching_session)
        (session_eligible_for_preference ?matching_session)
        (session_has_settlement_preference ?matching_session ?settlement_preference)
        (session_has_debit_leg ?matching_session ?debit_leg)
        (session_has_credit_leg ?matching_session ?credit_leg)
        (debit_leg_channel_confirmed ?debit_leg)
        (credit_leg_channel_confirmed ?credit_leg)
        (entity_has_message ?matching_session ?payment_message)
        (not
          (session_ready_for_final_decision ?matching_session)
        )
      )
    :effect (session_ready_for_final_decision ?matching_session)
  )
  (:action finalize_session_and_mark_ready
    :parameters (?matching_session - matching_session)
    :precondition
      (and
        (session_compliance_cleared ?matching_session)
        (session_ready_for_final_decision ?matching_session)
        (not
          (session_committed ?matching_session)
        )
      )
    :effect
      (and
        (session_committed ?matching_session)
        (ready_for_settlement ?matching_session)
      )
  )
  (:action validate_external_reference_for_session
    :parameters (?matching_session - matching_session ?external_reference - external_reference ?payment_message - payment_message)
    :precondition
      (and
        (entity_validated ?matching_session)
        (entity_has_message ?matching_session ?payment_message)
        (external_reference_available ?external_reference)
        (session_has_external_reference ?matching_session ?external_reference)
        (not
          (session_external_reference_validated ?matching_session)
        )
      )
    :effect
      (and
        (session_external_reference_validated ?matching_session)
        (not
          (external_reference_available ?external_reference)
        )
      )
  )
  (:action assign_operator_for_reference_check
    :parameters (?matching_session - matching_session ?verification_operator - verification_operator)
    :precondition
      (and
        (session_external_reference_validated ?matching_session)
        (assigned_verification_operator ?matching_session ?verification_operator)
        (not
          (session_operator_confirmed_for_reference ?matching_session)
        )
      )
    :effect (session_operator_confirmed_for_reference ?matching_session)
  )
  (:action attach_compliance_document_for_reference_check
    :parameters (?matching_session - matching_session ?compliance_document - compliance_document)
    :precondition
      (and
        (session_operator_confirmed_for_reference ?matching_session)
        (session_has_compliance_document ?matching_session ?compliance_document)
        (not
          (session_reference_compliance_attached ?matching_session)
        )
      )
    :effect (session_reference_compliance_attached ?matching_session)
  )
  (:action finalize_reference_check_and_mark_ready
    :parameters (?matching_session - matching_session)
    :precondition
      (and
        (session_reference_compliance_attached ?matching_session)
        (not
          (session_committed ?matching_session)
        )
      )
    :effect
      (and
        (session_committed ?matching_session)
        (ready_for_settlement ?matching_session)
      )
  )
  (:action finalize_debit_leg
    :parameters (?debit_leg - debit_leg ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (debit_leg_ready ?debit_leg)
        (debit_leg_channel_confirmed ?debit_leg)
        (settlement_instruction_ready ?settlement_instruction)
        (settlement_instruction_validated ?settlement_instruction)
        (not
          (ready_for_settlement ?debit_leg)
        )
      )
    :effect (ready_for_settlement ?debit_leg)
  )
  (:action finalize_credit_leg
    :parameters (?credit_leg - credit_leg ?settlement_instruction - settlement_instruction)
    :precondition
      (and
        (credit_leg_ready ?credit_leg)
        (credit_leg_channel_confirmed ?credit_leg)
        (settlement_instruction_ready ?settlement_instruction)
        (settlement_instruction_validated ?settlement_instruction)
        (not
          (ready_for_settlement ?credit_leg)
        )
      )
    :effect (ready_for_settlement ?credit_leg)
  )
  (:action authorize_release_to_routing_profile
    :parameters (?inbound_payment_instruction - inbound_payment_instruction ?routing_profile - routing_profile ?payment_message - payment_message)
    :precondition
      (and
        (ready_for_settlement ?inbound_payment_instruction)
        (entity_has_message ?inbound_payment_instruction ?payment_message)
        (routing_profile_available ?routing_profile)
        (not
          (release_authorized ?inbound_payment_instruction)
        )
      )
    :effect
      (and
        (release_authorized ?inbound_payment_instruction)
        (entity_has_routing_profile ?inbound_payment_instruction ?routing_profile)
        (not
          (routing_profile_available ?routing_profile)
        )
      )
  )
  (:action release_debit_leg_for_settlement
    :parameters (?debit_leg - debit_leg ?processing_resource - processing_resource ?routing_profile - routing_profile)
    :precondition
      (and
        (release_authorized ?debit_leg)
        (assigned_to_processing_resource ?debit_leg ?processing_resource)
        (entity_has_routing_profile ?debit_leg ?routing_profile)
        (not
          (released_for_settlement ?debit_leg)
        )
      )
    :effect
      (and
        (released_for_settlement ?debit_leg)
        (resource_available ?processing_resource)
        (routing_profile_available ?routing_profile)
      )
  )
  (:action release_credit_leg_for_settlement
    :parameters (?credit_leg - credit_leg ?processing_resource - processing_resource ?routing_profile - routing_profile)
    :precondition
      (and
        (release_authorized ?credit_leg)
        (assigned_to_processing_resource ?credit_leg ?processing_resource)
        (entity_has_routing_profile ?credit_leg ?routing_profile)
        (not
          (released_for_settlement ?credit_leg)
        )
      )
    :effect
      (and
        (released_for_settlement ?credit_leg)
        (resource_available ?processing_resource)
        (routing_profile_available ?routing_profile)
      )
  )
  (:action release_session_for_settlement
    :parameters (?matching_session - matching_session ?processing_resource - processing_resource ?routing_profile - routing_profile)
    :precondition
      (and
        (release_authorized ?matching_session)
        (assigned_to_processing_resource ?matching_session ?processing_resource)
        (entity_has_routing_profile ?matching_session ?routing_profile)
        (not
          (released_for_settlement ?matching_session)
        )
      )
    :effect
      (and
        (released_for_settlement ?matching_session)
        (resource_available ?processing_resource)
        (routing_profile_available ?routing_profile)
      )
  )
)

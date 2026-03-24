(define (domain reservation_record_merging_and_cleanup_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object service_resource - entity document_or_token - entity matching_key_group - entity resource_asset - entity reservation_record - resource_asset supplier_channel - service_resource inventory_option - service_resource supplier_account - service_resource feature_profile - service_resource consolidation_policy - service_resource audit_record - service_resource payment_authorization - service_resource verification_token - service_resource merge_candidate_entry - document_or_token supporting_document - document_or_token external_reference_id - document_or_token matching_key_local - matching_key_group matching_key_external - matching_key_group merge_proposal - matching_key_group reservation_role - reservation_record consolidation_session_type - reservation_record primary_reservation - reservation_role secondary_reservation - reservation_role consolidation_session_record - consolidation_session_type)

  (:predicates
    (record_tentative ?reservation_record - reservation_record)
    (record_confirmed ?reservation_record - reservation_record)
    (supplier_hold_placed ?reservation_record - reservation_record)
    (record_finalized ?reservation_record - reservation_record)
    (propagation_authorized ?reservation_record - reservation_record)
    (merge_token_active ?reservation_record - reservation_record)
    (supplier_channel_available ?supplier_channel - supplier_channel)
    (record_supplier_link ?reservation_record - reservation_record ?supplier_channel - supplier_channel)
    (inventory_option_available ?inventory_option - inventory_option)
    (record_selected_option ?reservation_record - reservation_record ?inventory_option - inventory_option)
    (supplier_account_available ?supplier_account - supplier_account)
    (record_supplier_account_link ?reservation_record - reservation_record ?supplier_account - supplier_account)
    (merge_candidate_available ?merge_candidate_entry - merge_candidate_entry)
    (primary_reservation_candidate_binding ?primary_reservation - primary_reservation ?merge_candidate_entry - merge_candidate_entry)
    (secondary_reservation_candidate_binding ?secondary_reservation - secondary_reservation ?merge_candidate_entry - merge_candidate_entry)
    (record_local_key_binding ?primary_reservation - primary_reservation ?matching_key_local - matching_key_local)
    (matching_key_local_identified ?matching_key_local - matching_key_local)
    (matching_key_local_bound ?matching_key_local - matching_key_local)
    (primary_local_key_confirmed ?primary_reservation - primary_reservation)
    (record_external_key_binding ?secondary_reservation - secondary_reservation ?matching_key_external - matching_key_external)
    (matching_key_external_identified ?matching_key_external - matching_key_external)
    (matching_key_external_bound ?matching_key_external - matching_key_external)
    (secondary_external_key_confirmed ?secondary_reservation - secondary_reservation)
    (merge_proposal_draft ?merge_proposal - merge_proposal)
    (merge_proposal_active ?merge_proposal - merge_proposal)
    (proposal_local_key_binding ?merge_proposal - merge_proposal ?matching_key_local - matching_key_local)
    (proposal_external_key_binding ?merge_proposal - merge_proposal ?matching_key_external - matching_key_external)
    (proposal_local_evidence_flag ?merge_proposal - merge_proposal)
    (proposal_external_evidence_flag ?merge_proposal - merge_proposal)
    (proposal_option_confirmed ?merge_proposal - merge_proposal)
    (consolidation_session_record_primary_binding ?consolidation_session_record - consolidation_session_record ?primary_reservation - primary_reservation)
    (consolidation_session_record_secondary_binding ?consolidation_session_record - consolidation_session_record ?secondary_reservation - secondary_reservation)
    (consolidation_session_record_proposal_binding ?consolidation_session_record - consolidation_session_record ?merge_proposal - merge_proposal)
    (supporting_document_unassigned ?supporting_document - supporting_document)
    (consolidation_session_record_document_attachment ?consolidation_session_record - consolidation_session_record ?supporting_document - supporting_document)
    (supporting_document_attached ?supporting_document - supporting_document)
    (document_proposal_binding ?supporting_document - supporting_document ?merge_proposal - merge_proposal)
    (consolidation_session_record_validated ?consolidation_session_record - consolidation_session_record)
    (consolidation_session_record_policy_evidence_flag ?consolidation_session_record - consolidation_session_record)
    (consolidation_session_record_commit_candidate ?consolidation_session_record - consolidation_session_record)
    (consolidation_session_record_feature_bound ?consolidation_session_record - consolidation_session_record)
    (consolidation_session_record_feature_context_set ?consolidation_session_record - consolidation_session_record)
    (consolidation_session_record_verification_mark ?consolidation_session_record - consolidation_session_record)
    (consolidation_session_record_evidence_confirmed ?consolidation_session_record - consolidation_session_record)
    (external_reference_available ?external_reference_id - external_reference_id)
    (consolidation_session_record_external_reference_binding ?consolidation_session_record - consolidation_session_record ?external_reference_id - external_reference_id)
    (consolidation_session_record_external_reference_confirmed ?consolidation_session_record - consolidation_session_record)
    (consolidation_session_record_external_review_stage_one ?consolidation_session_record - consolidation_session_record)
    (consolidation_session_record_external_review_stage_two ?consolidation_session_record - consolidation_session_record)
    (feature_profile_available ?feature_profile - feature_profile)
    (consolidation_session_record_feature_binding ?consolidation_session_record - consolidation_session_record ?feature_profile - feature_profile)
    (consolidation_policy_available ?consolidation_policy - consolidation_policy)
    (consolidation_session_record_policy_binding ?consolidation_session_record - consolidation_session_record ?consolidation_policy - consolidation_policy)
    (payment_authorization_available ?payment_authorization - payment_authorization)
    (consolidation_session_record_payment_authorization_binding ?consolidation_session_record - consolidation_session_record ?payment_authorization - payment_authorization)
    (verification_token_available ?verification_token - verification_token)
    (consolidation_session_record_verification_token_binding ?consolidation_session_record - consolidation_session_record ?verification_token - verification_token)
    (audit_record_available ?audit_record - audit_record)
    (record_audit_binding ?reservation_record - reservation_record ?audit_record - audit_record)
    (primary_reservation_ready ?primary_reservation - primary_reservation)
    (secondary_reservation_ready ?secondary_reservation - secondary_reservation)
    (consolidation_commit_marker ?consolidation_session_record - consolidation_session_record)
  )
  (:action initialize_reservation_record
    :parameters (?reservation_record - reservation_record)
    :precondition
      (and
        (not
          (record_tentative ?reservation_record)
        )
        (not
          (record_finalized ?reservation_record)
        )
      )
    :effect (record_tentative ?reservation_record)
  )
  (:action select_option_and_place_supplier_hold
    :parameters (?reservation_record - reservation_record ?supplier_channel - supplier_channel)
    :precondition
      (and
        (record_tentative ?reservation_record)
        (not
          (supplier_hold_placed ?reservation_record)
        )
        (supplier_channel_available ?supplier_channel)
      )
    :effect
      (and
        (supplier_hold_placed ?reservation_record)
        (record_supplier_link ?reservation_record ?supplier_channel)
        (not
          (supplier_channel_available ?supplier_channel)
        )
      )
  )
  (:action confirm_option_with_inventory
    :parameters (?reservation_record - reservation_record ?inventory_option - inventory_option)
    :precondition
      (and
        (record_tentative ?reservation_record)
        (supplier_hold_placed ?reservation_record)
        (inventory_option_available ?inventory_option)
      )
    :effect
      (and
        (record_selected_option ?reservation_record ?inventory_option)
        (not
          (inventory_option_available ?inventory_option)
        )
      )
  )
  (:action confirm_reservation_option
    :parameters (?reservation_record - reservation_record ?inventory_option - inventory_option)
    :precondition
      (and
        (record_tentative ?reservation_record)
        (supplier_hold_placed ?reservation_record)
        (record_selected_option ?reservation_record ?inventory_option)
        (not
          (record_confirmed ?reservation_record)
        )
      )
    :effect (record_confirmed ?reservation_record)
  )
  (:action release_option_hold
    :parameters (?reservation_record - reservation_record ?inventory_option - inventory_option)
    :precondition
      (and
        (record_selected_option ?reservation_record ?inventory_option)
      )
    :effect
      (and
        (inventory_option_available ?inventory_option)
        (not
          (record_selected_option ?reservation_record ?inventory_option)
        )
      )
  )
  (:action attach_supplier_account_to_reservation
    :parameters (?reservation_record - reservation_record ?supplier_account - supplier_account)
    :precondition
      (and
        (record_confirmed ?reservation_record)
        (supplier_account_available ?supplier_account)
      )
    :effect
      (and
        (record_supplier_account_link ?reservation_record ?supplier_account)
        (not
          (supplier_account_available ?supplier_account)
        )
      )
  )
  (:action detach_supplier_account_from_reservation
    :parameters (?reservation_record - reservation_record ?supplier_account - supplier_account)
    :precondition
      (and
        (record_supplier_account_link ?reservation_record ?supplier_account)
      )
    :effect
      (and
        (supplier_account_available ?supplier_account)
        (not
          (record_supplier_account_link ?reservation_record ?supplier_account)
        )
      )
  )
  (:action bind_payment_authorization_to_consolidation_session_record
    :parameters (?consolidation_session_record - consolidation_session_record ?payment_authorization - payment_authorization)
    :precondition
      (and
        (record_confirmed ?consolidation_session_record)
        (payment_authorization_available ?payment_authorization)
      )
    :effect
      (and
        (consolidation_session_record_payment_authorization_binding ?consolidation_session_record ?payment_authorization)
        (not
          (payment_authorization_available ?payment_authorization)
        )
      )
  )
  (:action unbind_payment_authorization_from_consolidation_session_record
    :parameters (?consolidation_session_record - consolidation_session_record ?payment_authorization - payment_authorization)
    :precondition
      (and
        (consolidation_session_record_payment_authorization_binding ?consolidation_session_record ?payment_authorization)
      )
    :effect
      (and
        (payment_authorization_available ?payment_authorization)
        (not
          (consolidation_session_record_payment_authorization_binding ?consolidation_session_record ?payment_authorization)
        )
      )
  )
  (:action bind_verification_token_to_consolidation_session_record
    :parameters (?consolidation_session_record - consolidation_session_record ?verification_token - verification_token)
    :precondition
      (and
        (record_confirmed ?consolidation_session_record)
        (verification_token_available ?verification_token)
      )
    :effect
      (and
        (consolidation_session_record_verification_token_binding ?consolidation_session_record ?verification_token)
        (not
          (verification_token_available ?verification_token)
        )
      )
  )
  (:action unbind_verification_token_from_consolidation_session_record
    :parameters (?consolidation_session_record - consolidation_session_record ?verification_token - verification_token)
    :precondition
      (and
        (consolidation_session_record_verification_token_binding ?consolidation_session_record ?verification_token)
      )
    :effect
      (and
        (verification_token_available ?verification_token)
        (not
          (consolidation_session_record_verification_token_binding ?consolidation_session_record ?verification_token)
        )
      )
  )
  (:action identify_local_matching_key_for_primary_reservation
    :parameters (?primary_reservation - primary_reservation ?matching_key_local - matching_key_local ?inventory_option - inventory_option)
    :precondition
      (and
        (record_confirmed ?primary_reservation)
        (record_selected_option ?primary_reservation ?inventory_option)
        (record_local_key_binding ?primary_reservation ?matching_key_local)
        (not
          (matching_key_local_identified ?matching_key_local)
        )
        (not
          (matching_key_local_bound ?matching_key_local)
        )
      )
    :effect (matching_key_local_identified ?matching_key_local)
  )
  (:action confirm_primary_local_key_with_supplier_account
    :parameters (?primary_reservation - primary_reservation ?matching_key_local - matching_key_local ?supplier_account - supplier_account)
    :precondition
      (and
        (record_confirmed ?primary_reservation)
        (record_supplier_account_link ?primary_reservation ?supplier_account)
        (record_local_key_binding ?primary_reservation ?matching_key_local)
        (matching_key_local_identified ?matching_key_local)
        (not
          (primary_reservation_ready ?primary_reservation)
        )
      )
    :effect
      (and
        (primary_reservation_ready ?primary_reservation)
        (primary_local_key_confirmed ?primary_reservation)
      )
  )
  (:action assign_candidate_entry_to_primary_reservation
    :parameters (?primary_reservation - primary_reservation ?matching_key_local - matching_key_local ?merge_candidate_entry - merge_candidate_entry)
    :precondition
      (and
        (record_confirmed ?primary_reservation)
        (record_local_key_binding ?primary_reservation ?matching_key_local)
        (merge_candidate_available ?merge_candidate_entry)
        (not
          (primary_reservation_ready ?primary_reservation)
        )
      )
    :effect
      (and
        (matching_key_local_bound ?matching_key_local)
        (primary_reservation_ready ?primary_reservation)
        (primary_reservation_candidate_binding ?primary_reservation ?merge_candidate_entry)
        (not
          (merge_candidate_available ?merge_candidate_entry)
        )
      )
  )
  (:action finalize_primary_candidate_local_key
    :parameters (?primary_reservation - primary_reservation ?matching_key_local - matching_key_local ?inventory_option - inventory_option ?merge_candidate_entry - merge_candidate_entry)
    :precondition
      (and
        (record_confirmed ?primary_reservation)
        (record_selected_option ?primary_reservation ?inventory_option)
        (record_local_key_binding ?primary_reservation ?matching_key_local)
        (matching_key_local_bound ?matching_key_local)
        (primary_reservation_candidate_binding ?primary_reservation ?merge_candidate_entry)
        (not
          (primary_local_key_confirmed ?primary_reservation)
        )
      )
    :effect
      (and
        (matching_key_local_identified ?matching_key_local)
        (primary_local_key_confirmed ?primary_reservation)
        (merge_candidate_available ?merge_candidate_entry)
        (not
          (primary_reservation_candidate_binding ?primary_reservation ?merge_candidate_entry)
        )
      )
  )
  (:action identify_external_matching_key_for_reservation
    :parameters (?secondary_reservation - secondary_reservation ?matching_key_external - matching_key_external ?inventory_option - inventory_option)
    :precondition
      (and
        (record_confirmed ?secondary_reservation)
        (record_selected_option ?secondary_reservation ?inventory_option)
        (record_external_key_binding ?secondary_reservation ?matching_key_external)
        (not
          (matching_key_external_identified ?matching_key_external)
        )
        (not
          (matching_key_external_bound ?matching_key_external)
        )
      )
    :effect (matching_key_external_identified ?matching_key_external)
  )
  (:action confirm_secondary_reservation_external_match_with_supplier_account
    :parameters (?secondary_reservation - secondary_reservation ?matching_key_external - matching_key_external ?supplier_account - supplier_account)
    :precondition
      (and
        (record_confirmed ?secondary_reservation)
        (record_supplier_account_link ?secondary_reservation ?supplier_account)
        (record_external_key_binding ?secondary_reservation ?matching_key_external)
        (matching_key_external_identified ?matching_key_external)
        (not
          (secondary_reservation_ready ?secondary_reservation)
        )
      )
    :effect
      (and
        (secondary_reservation_ready ?secondary_reservation)
        (secondary_external_key_confirmed ?secondary_reservation)
      )
  )
  (:action assign_candidate_entry_to_secondary_reservation
    :parameters (?secondary_reservation - secondary_reservation ?matching_key_external - matching_key_external ?merge_candidate_entry - merge_candidate_entry)
    :precondition
      (and
        (record_confirmed ?secondary_reservation)
        (record_external_key_binding ?secondary_reservation ?matching_key_external)
        (merge_candidate_available ?merge_candidate_entry)
        (not
          (secondary_reservation_ready ?secondary_reservation)
        )
      )
    :effect
      (and
        (matching_key_external_bound ?matching_key_external)
        (secondary_reservation_ready ?secondary_reservation)
        (secondary_reservation_candidate_binding ?secondary_reservation ?merge_candidate_entry)
        (not
          (merge_candidate_available ?merge_candidate_entry)
        )
      )
  )
  (:action finalize_secondary_candidate_external_key
    :parameters (?secondary_reservation - secondary_reservation ?matching_key_external - matching_key_external ?inventory_option - inventory_option ?merge_candidate_entry - merge_candidate_entry)
    :precondition
      (and
        (record_confirmed ?secondary_reservation)
        (record_selected_option ?secondary_reservation ?inventory_option)
        (record_external_key_binding ?secondary_reservation ?matching_key_external)
        (matching_key_external_bound ?matching_key_external)
        (secondary_reservation_candidate_binding ?secondary_reservation ?merge_candidate_entry)
        (not
          (secondary_external_key_confirmed ?secondary_reservation)
        )
      )
    :effect
      (and
        (matching_key_external_identified ?matching_key_external)
        (secondary_external_key_confirmed ?secondary_reservation)
        (merge_candidate_available ?merge_candidate_entry)
        (not
          (secondary_reservation_candidate_binding ?secondary_reservation ?merge_candidate_entry)
        )
      )
  )
  (:action create_merge_proposal_full_evidence
    :parameters (?primary_reservation - primary_reservation ?secondary_reservation - secondary_reservation ?matching_key_local - matching_key_local ?matching_key_external - matching_key_external ?merge_proposal - merge_proposal)
    :precondition
      (and
        (primary_reservation_ready ?primary_reservation)
        (secondary_reservation_ready ?secondary_reservation)
        (record_local_key_binding ?primary_reservation ?matching_key_local)
        (record_external_key_binding ?secondary_reservation ?matching_key_external)
        (matching_key_local_identified ?matching_key_local)
        (matching_key_external_identified ?matching_key_external)
        (primary_local_key_confirmed ?primary_reservation)
        (secondary_external_key_confirmed ?secondary_reservation)
        (merge_proposal_draft ?merge_proposal)
      )
    :effect
      (and
        (merge_proposal_active ?merge_proposal)
        (proposal_local_key_binding ?merge_proposal ?matching_key_local)
        (proposal_external_key_binding ?merge_proposal ?matching_key_external)
        (not
          (merge_proposal_draft ?merge_proposal)
        )
      )
  )
  (:action create_merge_proposal_local_evidence
    :parameters (?primary_reservation - primary_reservation ?secondary_reservation - secondary_reservation ?matching_key_local - matching_key_local ?matching_key_external - matching_key_external ?merge_proposal - merge_proposal)
    :precondition
      (and
        (primary_reservation_ready ?primary_reservation)
        (secondary_reservation_ready ?secondary_reservation)
        (record_local_key_binding ?primary_reservation ?matching_key_local)
        (record_external_key_binding ?secondary_reservation ?matching_key_external)
        (matching_key_local_bound ?matching_key_local)
        (matching_key_external_identified ?matching_key_external)
        (not
          (primary_local_key_confirmed ?primary_reservation)
        )
        (secondary_external_key_confirmed ?secondary_reservation)
        (merge_proposal_draft ?merge_proposal)
      )
    :effect
      (and
        (merge_proposal_active ?merge_proposal)
        (proposal_local_key_binding ?merge_proposal ?matching_key_local)
        (proposal_external_key_binding ?merge_proposal ?matching_key_external)
        (proposal_local_evidence_flag ?merge_proposal)
        (not
          (merge_proposal_draft ?merge_proposal)
        )
      )
  )
  (:action create_merge_proposal_external_evidence
    :parameters (?primary_reservation - primary_reservation ?secondary_reservation - secondary_reservation ?matching_key_local - matching_key_local ?matching_key_external - matching_key_external ?merge_proposal - merge_proposal)
    :precondition
      (and
        (primary_reservation_ready ?primary_reservation)
        (secondary_reservation_ready ?secondary_reservation)
        (record_local_key_binding ?primary_reservation ?matching_key_local)
        (record_external_key_binding ?secondary_reservation ?matching_key_external)
        (matching_key_local_identified ?matching_key_local)
        (matching_key_external_bound ?matching_key_external)
        (primary_local_key_confirmed ?primary_reservation)
        (not
          (secondary_external_key_confirmed ?secondary_reservation)
        )
        (merge_proposal_draft ?merge_proposal)
      )
    :effect
      (and
        (merge_proposal_active ?merge_proposal)
        (proposal_local_key_binding ?merge_proposal ?matching_key_local)
        (proposal_external_key_binding ?merge_proposal ?matching_key_external)
        (proposal_external_evidence_flag ?merge_proposal)
        (not
          (merge_proposal_draft ?merge_proposal)
        )
      )
  )
  (:action create_merge_proposal_mixed_evidence
    :parameters (?primary_reservation - primary_reservation ?secondary_reservation - secondary_reservation ?matching_key_local - matching_key_local ?matching_key_external - matching_key_external ?merge_proposal - merge_proposal)
    :precondition
      (and
        (primary_reservation_ready ?primary_reservation)
        (secondary_reservation_ready ?secondary_reservation)
        (record_local_key_binding ?primary_reservation ?matching_key_local)
        (record_external_key_binding ?secondary_reservation ?matching_key_external)
        (matching_key_local_bound ?matching_key_local)
        (matching_key_external_bound ?matching_key_external)
        (not
          (primary_local_key_confirmed ?primary_reservation)
        )
        (not
          (secondary_external_key_confirmed ?secondary_reservation)
        )
        (merge_proposal_draft ?merge_proposal)
      )
    :effect
      (and
        (merge_proposal_active ?merge_proposal)
        (proposal_local_key_binding ?merge_proposal ?matching_key_local)
        (proposal_external_key_binding ?merge_proposal ?matching_key_external)
        (proposal_local_evidence_flag ?merge_proposal)
        (proposal_external_evidence_flag ?merge_proposal)
        (not
          (merge_proposal_draft ?merge_proposal)
        )
      )
  )
  (:action confirm_merge_proposal_option
    :parameters (?merge_proposal - merge_proposal ?primary_reservation - primary_reservation ?inventory_option - inventory_option)
    :precondition
      (and
        (merge_proposal_active ?merge_proposal)
        (primary_reservation_ready ?primary_reservation)
        (record_selected_option ?primary_reservation ?inventory_option)
        (not
          (proposal_option_confirmed ?merge_proposal)
        )
      )
    :effect (proposal_option_confirmed ?merge_proposal)
  )
  (:action attach_supporting_document_to_consolidation_session_record_and_proposal
    :parameters (?consolidation_session_record - consolidation_session_record ?supporting_document - supporting_document ?merge_proposal - merge_proposal)
    :precondition
      (and
        (record_confirmed ?consolidation_session_record)
        (consolidation_session_record_proposal_binding ?consolidation_session_record ?merge_proposal)
        (consolidation_session_record_document_attachment ?consolidation_session_record ?supporting_document)
        (supporting_document_unassigned ?supporting_document)
        (merge_proposal_active ?merge_proposal)
        (proposal_option_confirmed ?merge_proposal)
        (not
          (supporting_document_attached ?supporting_document)
        )
      )
    :effect
      (and
        (supporting_document_attached ?supporting_document)
        (document_proposal_binding ?supporting_document ?merge_proposal)
        (not
          (supporting_document_unassigned ?supporting_document)
        )
      )
  )
  (:action validate_supporting_document_for_proposal
    :parameters (?consolidation_session_record - consolidation_session_record ?supporting_document - supporting_document ?merge_proposal - merge_proposal ?inventory_option - inventory_option)
    :precondition
      (and
        (record_confirmed ?consolidation_session_record)
        (consolidation_session_record_document_attachment ?consolidation_session_record ?supporting_document)
        (supporting_document_attached ?supporting_document)
        (document_proposal_binding ?supporting_document ?merge_proposal)
        (record_selected_option ?consolidation_session_record ?inventory_option)
        (not
          (proposal_local_evidence_flag ?merge_proposal)
        )
        (not
          (consolidation_session_record_validated ?consolidation_session_record)
        )
      )
    :effect (consolidation_session_record_validated ?consolidation_session_record)
  )
  (:action bind_feature_profile_to_consolidation_session_record
    :parameters (?consolidation_session_record - consolidation_session_record ?feature_profile - feature_profile)
    :precondition
      (and
        (record_confirmed ?consolidation_session_record)
        (feature_profile_available ?feature_profile)
        (not
          (consolidation_session_record_feature_bound ?consolidation_session_record)
        )
      )
    :effect
      (and
        (consolidation_session_record_feature_bound ?consolidation_session_record)
        (consolidation_session_record_feature_binding ?consolidation_session_record ?feature_profile)
        (not
          (feature_profile_available ?feature_profile)
        )
      )
  )
  (:action apply_feature_profile_and_validate_consolidation_session_record
    :parameters (?consolidation_session_record - consolidation_session_record ?supporting_document - supporting_document ?merge_proposal - merge_proposal ?inventory_option - inventory_option ?feature_profile - feature_profile)
    :precondition
      (and
        (record_confirmed ?consolidation_session_record)
        (consolidation_session_record_document_attachment ?consolidation_session_record ?supporting_document)
        (supporting_document_attached ?supporting_document)
        (document_proposal_binding ?supporting_document ?merge_proposal)
        (record_selected_option ?consolidation_session_record ?inventory_option)
        (proposal_local_evidence_flag ?merge_proposal)
        (consolidation_session_record_feature_bound ?consolidation_session_record)
        (consolidation_session_record_feature_binding ?consolidation_session_record ?feature_profile)
        (not
          (consolidation_session_record_validated ?consolidation_session_record)
        )
      )
    :effect
      (and
        (consolidation_session_record_validated ?consolidation_session_record)
        (consolidation_session_record_feature_context_set ?consolidation_session_record)
      )
  )
  (:action apply_policy_checks_with_payment_and_supplier
    :parameters (?consolidation_session_record - consolidation_session_record ?payment_authorization - payment_authorization ?supplier_account - supplier_account ?supporting_document - supporting_document ?merge_proposal - merge_proposal)
    :precondition
      (and
        (consolidation_session_record_validated ?consolidation_session_record)
        (consolidation_session_record_payment_authorization_binding ?consolidation_session_record ?payment_authorization)
        (record_supplier_account_link ?consolidation_session_record ?supplier_account)
        (consolidation_session_record_document_attachment ?consolidation_session_record ?supporting_document)
        (document_proposal_binding ?supporting_document ?merge_proposal)
        (not
          (proposal_external_evidence_flag ?merge_proposal)
        )
        (not
          (consolidation_session_record_policy_evidence_flag ?consolidation_session_record)
        )
      )
    :effect (consolidation_session_record_policy_evidence_flag ?consolidation_session_record)
  )
  (:action reapply_policy_checks_with_payment_and_supplier
    :parameters (?consolidation_session_record - consolidation_session_record ?payment_authorization - payment_authorization ?supplier_account - supplier_account ?supporting_document - supporting_document ?merge_proposal - merge_proposal)
    :precondition
      (and
        (consolidation_session_record_validated ?consolidation_session_record)
        (consolidation_session_record_payment_authorization_binding ?consolidation_session_record ?payment_authorization)
        (record_supplier_account_link ?consolidation_session_record ?supplier_account)
        (consolidation_session_record_document_attachment ?consolidation_session_record ?supporting_document)
        (document_proposal_binding ?supporting_document ?merge_proposal)
        (proposal_external_evidence_flag ?merge_proposal)
        (not
          (consolidation_session_record_policy_evidence_flag ?consolidation_session_record)
        )
      )
    :effect (consolidation_session_record_policy_evidence_flag ?consolidation_session_record)
  )
  (:action evaluate_verification_token_and_stage_commit
    :parameters (?consolidation_session_record - consolidation_session_record ?verification_token - verification_token ?supporting_document - supporting_document ?merge_proposal - merge_proposal)
    :precondition
      (and
        (consolidation_session_record_policy_evidence_flag ?consolidation_session_record)
        (consolidation_session_record_verification_token_binding ?consolidation_session_record ?verification_token)
        (consolidation_session_record_document_attachment ?consolidation_session_record ?supporting_document)
        (document_proposal_binding ?supporting_document ?merge_proposal)
        (not
          (proposal_local_evidence_flag ?merge_proposal)
        )
        (not
          (proposal_external_evidence_flag ?merge_proposal)
        )
        (not
          (consolidation_session_record_commit_candidate ?consolidation_session_record)
        )
      )
    :effect (consolidation_session_record_commit_candidate ?consolidation_session_record)
  )
  (:action evaluate_verification_token_and_stage_commit_with_marker
    :parameters (?consolidation_session_record - consolidation_session_record ?verification_token - verification_token ?supporting_document - supporting_document ?merge_proposal - merge_proposal)
    :precondition
      (and
        (consolidation_session_record_policy_evidence_flag ?consolidation_session_record)
        (consolidation_session_record_verification_token_binding ?consolidation_session_record ?verification_token)
        (consolidation_session_record_document_attachment ?consolidation_session_record ?supporting_document)
        (document_proposal_binding ?supporting_document ?merge_proposal)
        (proposal_local_evidence_flag ?merge_proposal)
        (not
          (proposal_external_evidence_flag ?merge_proposal)
        )
        (not
          (consolidation_session_record_commit_candidate ?consolidation_session_record)
        )
      )
    :effect
      (and
        (consolidation_session_record_commit_candidate ?consolidation_session_record)
        (consolidation_session_record_verification_mark ?consolidation_session_record)
      )
  )
  (:action evaluate_verification_token_and_stage_commit_alternate1
    :parameters (?consolidation_session_record - consolidation_session_record ?verification_token - verification_token ?supporting_document - supporting_document ?merge_proposal - merge_proposal)
    :precondition
      (and
        (consolidation_session_record_policy_evidence_flag ?consolidation_session_record)
        (consolidation_session_record_verification_token_binding ?consolidation_session_record ?verification_token)
        (consolidation_session_record_document_attachment ?consolidation_session_record ?supporting_document)
        (document_proposal_binding ?supporting_document ?merge_proposal)
        (not
          (proposal_local_evidence_flag ?merge_proposal)
        )
        (proposal_external_evidence_flag ?merge_proposal)
        (not
          (consolidation_session_record_commit_candidate ?consolidation_session_record)
        )
      )
    :effect
      (and
        (consolidation_session_record_commit_candidate ?consolidation_session_record)
        (consolidation_session_record_verification_mark ?consolidation_session_record)
      )
  )
  (:action evaluate_verification_token_and_stage_commit_alternate2
    :parameters (?consolidation_session_record - consolidation_session_record ?verification_token - verification_token ?supporting_document - supporting_document ?merge_proposal - merge_proposal)
    :precondition
      (and
        (consolidation_session_record_policy_evidence_flag ?consolidation_session_record)
        (consolidation_session_record_verification_token_binding ?consolidation_session_record ?verification_token)
        (consolidation_session_record_document_attachment ?consolidation_session_record ?supporting_document)
        (document_proposal_binding ?supporting_document ?merge_proposal)
        (proposal_local_evidence_flag ?merge_proposal)
        (proposal_external_evidence_flag ?merge_proposal)
        (not
          (consolidation_session_record_commit_candidate ?consolidation_session_record)
        )
      )
    :effect
      (and
        (consolidation_session_record_commit_candidate ?consolidation_session_record)
        (consolidation_session_record_verification_mark ?consolidation_session_record)
      )
  )
  (:action commit_consolidation_and_authorize_propagation
    :parameters (?consolidation_session_record - consolidation_session_record)
    :precondition
      (and
        (consolidation_session_record_commit_candidate ?consolidation_session_record)
        (not
          (consolidation_session_record_verification_mark ?consolidation_session_record)
        )
        (not
          (consolidation_commit_marker ?consolidation_session_record)
        )
      )
    :effect
      (and
        (consolidation_commit_marker ?consolidation_session_record)
        (propagation_authorized ?consolidation_session_record)
      )
  )
  (:action attach_consolidation_policy_to_consolidation_session_record
    :parameters (?consolidation_session_record - consolidation_session_record ?consolidation_policy - consolidation_policy)
    :precondition
      (and
        (consolidation_session_record_commit_candidate ?consolidation_session_record)
        (consolidation_session_record_verification_mark ?consolidation_session_record)
        (consolidation_policy_available ?consolidation_policy)
      )
    :effect
      (and
        (consolidation_session_record_policy_binding ?consolidation_session_record ?consolidation_policy)
        (not
          (consolidation_policy_available ?consolidation_policy)
        )
      )
  )
  (:action conduct_policy_and_payment_verification
    :parameters (?consolidation_session_record - consolidation_session_record ?primary_reservation - primary_reservation ?secondary_reservation - secondary_reservation ?inventory_option - inventory_option ?consolidation_policy - consolidation_policy)
    :precondition
      (and
        (consolidation_session_record_commit_candidate ?consolidation_session_record)
        (consolidation_session_record_verification_mark ?consolidation_session_record)
        (consolidation_session_record_policy_binding ?consolidation_session_record ?consolidation_policy)
        (consolidation_session_record_primary_binding ?consolidation_session_record ?primary_reservation)
        (consolidation_session_record_secondary_binding ?consolidation_session_record ?secondary_reservation)
        (primary_local_key_confirmed ?primary_reservation)
        (secondary_external_key_confirmed ?secondary_reservation)
        (record_selected_option ?consolidation_session_record ?inventory_option)
        (not
          (consolidation_session_record_evidence_confirmed ?consolidation_session_record)
        )
      )
    :effect (consolidation_session_record_evidence_confirmed ?consolidation_session_record)
  )
  (:action commit_consolidation_and_authorize_propagation_with_confirmation
    :parameters (?consolidation_session_record - consolidation_session_record)
    :precondition
      (and
        (consolidation_session_record_commit_candidate ?consolidation_session_record)
        (consolidation_session_record_evidence_confirmed ?consolidation_session_record)
        (not
          (consolidation_commit_marker ?consolidation_session_record)
        )
      )
    :effect
      (and
        (consolidation_commit_marker ?consolidation_session_record)
        (propagation_authorized ?consolidation_session_record)
      )
  )
  (:action bind_external_reference_and_mark_consolidation_session_record_for_review
    :parameters (?consolidation_session_record - consolidation_session_record ?external_reference_id - external_reference_id ?inventory_option - inventory_option)
    :precondition
      (and
        (record_confirmed ?consolidation_session_record)
        (record_selected_option ?consolidation_session_record ?inventory_option)
        (external_reference_available ?external_reference_id)
        (consolidation_session_record_external_reference_binding ?consolidation_session_record ?external_reference_id)
        (not
          (consolidation_session_record_external_reference_confirmed ?consolidation_session_record)
        )
      )
    :effect
      (and
        (consolidation_session_record_external_reference_confirmed ?consolidation_session_record)
        (not
          (external_reference_available ?external_reference_id)
        )
      )
  )
  (:action stage_external_reference_review_step_one
    :parameters (?consolidation_session_record - consolidation_session_record ?supplier_account - supplier_account)
    :precondition
      (and
        (consolidation_session_record_external_reference_confirmed ?consolidation_session_record)
        (record_supplier_account_link ?consolidation_session_record ?supplier_account)
        (not
          (consolidation_session_record_external_review_stage_one ?consolidation_session_record)
        )
      )
    :effect (consolidation_session_record_external_review_stage_one ?consolidation_session_record)
  )
  (:action complete_external_reference_review_with_token
    :parameters (?consolidation_session_record - consolidation_session_record ?verification_token - verification_token)
    :precondition
      (and
        (consolidation_session_record_external_review_stage_one ?consolidation_session_record)
        (consolidation_session_record_verification_token_binding ?consolidation_session_record ?verification_token)
        (not
          (consolidation_session_record_external_review_stage_two ?consolidation_session_record)
        )
      )
    :effect (consolidation_session_record_external_review_stage_two ?consolidation_session_record)
  )
  (:action finalize_external_reference_review_and_authorize_propagation
    :parameters (?consolidation_session_record - consolidation_session_record)
    :precondition
      (and
        (consolidation_session_record_external_review_stage_two ?consolidation_session_record)
        (not
          (consolidation_commit_marker ?consolidation_session_record)
        )
      )
    :effect
      (and
        (consolidation_commit_marker ?consolidation_session_record)
        (propagation_authorized ?consolidation_session_record)
      )
  )
  (:action propagate_finalization_to_primary_record
    :parameters (?primary_reservation - primary_reservation ?merge_proposal - merge_proposal)
    :precondition
      (and
        (primary_reservation_ready ?primary_reservation)
        (primary_local_key_confirmed ?primary_reservation)
        (merge_proposal_active ?merge_proposal)
        (proposal_option_confirmed ?merge_proposal)
        (not
          (propagation_authorized ?primary_reservation)
        )
      )
    :effect (propagation_authorized ?primary_reservation)
  )
  (:action propagate_finalization_to_secondary_record
    :parameters (?secondary_reservation - secondary_reservation ?merge_proposal - merge_proposal)
    :precondition
      (and
        (secondary_reservation_ready ?secondary_reservation)
        (secondary_external_key_confirmed ?secondary_reservation)
        (merge_proposal_active ?merge_proposal)
        (proposal_option_confirmed ?merge_proposal)
        (not
          (propagation_authorized ?secondary_reservation)
        )
      )
    :effect (propagation_authorized ?secondary_reservation)
  )
  (:action create_merge_token_for_reservation
    :parameters (?reservation_record - reservation_record ?audit_record - audit_record ?inventory_option - inventory_option)
    :precondition
      (and
        (propagation_authorized ?reservation_record)
        (record_selected_option ?reservation_record ?inventory_option)
        (audit_record_available ?audit_record)
        (not
          (merge_token_active ?reservation_record)
        )
      )
    :effect
      (and
        (merge_token_active ?reservation_record)
        (record_audit_binding ?reservation_record ?audit_record)
        (not
          (audit_record_available ?audit_record)
        )
      )
  )
  (:action finalize_primary_reservation_and_release_resources
    :parameters (?primary_reservation - primary_reservation ?supplier_channel - supplier_channel ?audit_record - audit_record)
    :precondition
      (and
        (merge_token_active ?primary_reservation)
        (record_supplier_link ?primary_reservation ?supplier_channel)
        (record_audit_binding ?primary_reservation ?audit_record)
        (not
          (record_finalized ?primary_reservation)
        )
      )
    :effect
      (and
        (record_finalized ?primary_reservation)
        (supplier_channel_available ?supplier_channel)
        (audit_record_available ?audit_record)
      )
  )
  (:action finalize_secondary_reservation_and_release_resources
    :parameters (?secondary_reservation - secondary_reservation ?supplier_channel - supplier_channel ?audit_record - audit_record)
    :precondition
      (and
        (merge_token_active ?secondary_reservation)
        (record_supplier_link ?secondary_reservation ?supplier_channel)
        (record_audit_binding ?secondary_reservation ?audit_record)
        (not
          (record_finalized ?secondary_reservation)
        )
      )
    :effect
      (and
        (record_finalized ?secondary_reservation)
        (supplier_channel_available ?supplier_channel)
        (audit_record_available ?audit_record)
      )
  )
  (:action finalize_record_and_release_resources
    :parameters (?consolidation_session_record - consolidation_session_record ?supplier_channel - supplier_channel ?audit_record - audit_record)
    :precondition
      (and
        (merge_token_active ?consolidation_session_record)
        (record_supplier_link ?consolidation_session_record ?supplier_channel)
        (record_audit_binding ?consolidation_session_record ?audit_record)
        (not
          (record_finalized ?consolidation_session_record)
        )
      )
    :effect
      (and
        (record_finalized ?consolidation_session_record)
        (supplier_channel_available ?supplier_channel)
        (audit_record_available ?audit_record)
      )
  )
)

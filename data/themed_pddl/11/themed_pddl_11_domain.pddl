(define (domain finance_reconciliation_backoffice)
  (:requirements :strips :typing :negative-preconditions)
  (:types reconciliation_case - object ledger_entry - object posting_batch - object external_confirmation - object trade_leg - object settlement_event - object evidence_attachment - object third_party_feed_item - object approval_token - object operator_identity - object compliance_document - object counterparty_reference - object index_reference - object escalation_bucket - index_reference exception_category - index_reference related_case - reconciliation_case parent_case - reconciliation_case)
  (:predicates
    (third_party_feed_item_available ?third_party_feed_item - third_party_feed_item)
    (case_to_confirmation ?reconciliation_case - reconciliation_case ?external_confirmation - external_confirmation)
    (ready_for_final_evidence_collection ?reconciliation_case - reconciliation_case)
    (assigned_ledger_entry ?reconciliation_case - reconciliation_case ?ledger_entry - ledger_entry)
    (case_index_reference_link ?reconciliation_case - reconciliation_case ?index_reference - index_reference)
    (settlement_event_available ?settlement_event - settlement_event)
    (external_confirmation_available ?external_confirmation - external_confirmation)
    (case_possible_counterparty ?reconciliation_case - reconciliation_case ?counterparty_reference - counterparty_reference)
    (case_closed ?reconciliation_case - reconciliation_case)
    (closure_eligible_primary ?reconciliation_case - reconciliation_case)
    (case_possible_ledger_candidate ?reconciliation_case - reconciliation_case ?ledger_entry - ledger_entry)
    (posting_batch_available ?posting_batch - posting_batch)
    (compliance_document_available ?compliance_document - compliance_document)
    (attachment_available ?evidence_attachment - evidence_attachment)
    (verification_flag ?reconciliation_case - reconciliation_case)
    (case_possible_confirmation ?reconciliation_case - reconciliation_case ?external_confirmation - external_confirmation)
    (case_to_counterparty ?reconciliation_case - reconciliation_case ?counterparty_reference - counterparty_reference)
    (case_to_posting_batch ?reconciliation_case - reconciliation_case ?posting_batch - posting_batch)
    (ready_for_resolution ?reconciliation_case - reconciliation_case)
    (case_possible_settlement ?reconciliation_case - reconciliation_case ?settlement_event - settlement_event)
    (counterparty_reference_available ?counterparty_reference - counterparty_reference)
    (closure_eligible_secondary ?reconciliation_case - reconciliation_case)
    (case_validated ?reconciliation_case - reconciliation_case)
    (case_possible_trade_leg ?reconciliation_case - reconciliation_case ?trade_leg - trade_leg)
    (case_to_trade_leg ?reconciliation_case - reconciliation_case ?trade_leg - trade_leg)
    (under_additional_review_flag ?reconciliation_case - reconciliation_case)
    (case_attachment_link ?reconciliation_case - reconciliation_case ?evidence_attachment - evidence_attachment)
    (operator_attestation_flag ?reconciliation_case - reconciliation_case)
    (case_possible_compliance_doc ?reconciliation_case - reconciliation_case ?compliance_document - compliance_document)
    (case_active ?reconciliation_case - reconciliation_case)
    (ledger_entry_available ?ledger_entry - ledger_entry)
    (case_assignment_flag ?reconciliation_case - reconciliation_case)
    (operator_available ?operator_identity - operator_identity)
    (approval_token_available ?approval_token - approval_token)
    (case_to_settlement ?reconciliation_case - reconciliation_case ?settlement_event - settlement_event)
    (related_case_linked_approval_token ?reconciliation_case - reconciliation_case ?approval_token - approval_token)
    (case_evidence_verified ?reconciliation_case - reconciliation_case)
    (attachment_attested ?reconciliation_case - reconciliation_case)
    (case_routed_for_approval ?reconciliation_case - reconciliation_case ?approval_token - approval_token)
    (trade_leg_available ?trade_leg - trade_leg)
    (case_linked_approval_token ?reconciliation_case - reconciliation_case ?approval_token - approval_token)
    (case_possible_posting_batch ?reconciliation_case - reconciliation_case ?posting_batch - posting_batch)
    (escalation_flag ?reconciliation_case - reconciliation_case)
    (case_approval_consumed ?reconciliation_case - reconciliation_case ?approval_token - approval_token)
  )
  (:action release_counterparty_reservation
    :parameters (?reconciliation_case - reconciliation_case ?counterparty_reference - counterparty_reference)
    :precondition
      (and
        (case_to_counterparty ?reconciliation_case ?counterparty_reference)
      )
    :effect
      (and
        (counterparty_reference_available ?counterparty_reference)
        (not
          (case_to_counterparty ?reconciliation_case ?counterparty_reference)
        )
      )
  )
  (:action mark_ready_and_escalate
    :parameters (?reconciliation_case - reconciliation_case ?settlement_event - settlement_event ?counterparty_reference - counterparty_reference ?exception_category - exception_category)
    :precondition
      (and
        (not
          (ready_for_resolution ?reconciliation_case)
        )
        (verification_flag ?reconciliation_case)
        (case_validated ?reconciliation_case)
        (case_to_counterparty ?reconciliation_case ?counterparty_reference)
        (case_index_reference_link ?reconciliation_case ?exception_category)
        (case_to_settlement ?reconciliation_case ?settlement_event)
      )
    :effect
      (and
        (escalation_flag ?reconciliation_case)
        (ready_for_resolution ?reconciliation_case)
      )
  )
  (:action close_case_via_primary_route
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_validated ?reconciliation_case)
        (case_assignment_flag ?reconciliation_case)
        (verification_flag ?reconciliation_case)
        (case_active ?reconciliation_case)
        (attachment_attested ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
        (closure_eligible_primary ?reconciliation_case)
        (ready_for_resolution ?reconciliation_case)
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action clear_additional_review_flag
    :parameters (?reconciliation_case - reconciliation_case ?trade_leg - trade_leg ?external_confirmation - external_confirmation)
    :precondition
      (and
        (verification_flag ?reconciliation_case)
        (under_additional_review_flag ?reconciliation_case)
        (case_to_trade_leg ?reconciliation_case ?trade_leg)
        (case_to_confirmation ?reconciliation_case ?external_confirmation)
      )
    :effect
      (and
        (not
          (under_additional_review_flag ?reconciliation_case)
        )
        (not
          (escalation_flag ?reconciliation_case)
        )
      )
  )
  (:action attach_evidence
    :parameters (?reconciliation_case - reconciliation_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (attachment_available ?evidence_attachment)
        (case_active ?reconciliation_case)
      )
    :effect
      (and
        (not
          (attachment_available ?evidence_attachment)
        )
        (case_attachment_link ?reconciliation_case ?evidence_attachment)
      )
  )
  (:action mark_ready_for_resolution
    :parameters (?reconciliation_case - reconciliation_case ?trade_leg - trade_leg ?external_confirmation - external_confirmation ?escalation_bucket - escalation_bucket)
    :precondition
      (and
        (case_index_reference_link ?reconciliation_case ?escalation_bucket)
        (case_validated ?reconciliation_case)
        (not
          (escalation_flag ?reconciliation_case)
        )
        (case_to_trade_leg ?reconciliation_case ?trade_leg)
        (verification_flag ?reconciliation_case)
        (case_to_confirmation ?reconciliation_case ?external_confirmation)
        (not
          (ready_for_resolution ?reconciliation_case)
        )
      )
    :effect
      (and
        (ready_for_resolution ?reconciliation_case)
      )
  )
  (:action validate_case_with_approval_token
    :parameters (?reconciliation_case - reconciliation_case ?approval_token - approval_token)
    :precondition
      (and
        (case_assignment_flag ?reconciliation_case)
        (case_approval_consumed ?reconciliation_case ?approval_token)
        (not
          (case_validated ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_validated ?reconciliation_case)
        (not
          (escalation_flag ?reconciliation_case)
        )
      )
  )
  (:action reserve_settlement_event_for_case
    :parameters (?reconciliation_case - reconciliation_case ?settlement_event - settlement_event)
    :precondition
      (and
        (case_possible_settlement ?reconciliation_case ?settlement_event)
        (case_active ?reconciliation_case)
        (settlement_event_available ?settlement_event)
      )
    :effect
      (and
        (case_to_settlement ?reconciliation_case ?settlement_event)
        (not
          (settlement_event_available ?settlement_event)
        )
      )
  )
  (:action reserve_trade_leg_for_case
    :parameters (?reconciliation_case - reconciliation_case ?trade_leg - trade_leg)
    :precondition
      (and
        (case_active ?reconciliation_case)
        (trade_leg_available ?trade_leg)
        (case_possible_trade_leg ?reconciliation_case ?trade_leg)
      )
    :effect
      (and
        (not
          (trade_leg_available ?trade_leg)
        )
        (case_to_trade_leg ?reconciliation_case ?trade_leg)
      )
  )
  (:action release_settlement_event_reservation
    :parameters (?reconciliation_case - reconciliation_case ?settlement_event - settlement_event)
    :precondition
      (and
        (case_to_settlement ?reconciliation_case ?settlement_event)
      )
    :effect
      (and
        (settlement_event_available ?settlement_event)
        (not
          (case_to_settlement ?reconciliation_case ?settlement_event)
        )
      )
  )
  (:action release_external_confirmation_reservation
    :parameters (?reconciliation_case - reconciliation_case ?external_confirmation - external_confirmation)
    :precondition
      (and
        (case_to_confirmation ?reconciliation_case ?external_confirmation)
      )
    :effect
      (and
        (external_confirmation_available ?external_confirmation)
        (not
          (case_to_confirmation ?reconciliation_case ?external_confirmation)
        )
      )
  )
  (:action route_for_approval
    :parameters (?reconciliation_case - reconciliation_case ?approval_token - approval_token)
    :precondition
      (and
        (attachment_attested ?reconciliation_case)
        (approval_token_available ?approval_token)
        (case_routed_for_approval ?reconciliation_case ?approval_token)
      )
    :effect
      (and
        (related_case_linked_approval_token ?reconciliation_case ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action reserve_external_confirmation_for_case
    :parameters (?reconciliation_case - reconciliation_case ?external_confirmation - external_confirmation)
    :precondition
      (and
        (case_active ?reconciliation_case)
        (external_confirmation_available ?external_confirmation)
        (case_possible_confirmation ?reconciliation_case ?external_confirmation)
      )
    :effect
      (and
        (case_to_confirmation ?reconciliation_case ?external_confirmation)
        (not
          (external_confirmation_available ?external_confirmation)
        )
      )
  )
  (:action validate_with_posting_batch_and_legs
    :parameters (?reconciliation_case - reconciliation_case ?posting_batch - posting_batch ?trade_leg - trade_leg ?external_confirmation - external_confirmation)
    :precondition
      (and
        (case_assignment_flag ?reconciliation_case)
        (posting_batch_available ?posting_batch)
        (case_possible_posting_batch ?reconciliation_case ?posting_batch)
        (not
          (verification_flag ?reconciliation_case)
        )
        (case_to_confirmation ?reconciliation_case ?external_confirmation)
        (case_to_trade_leg ?reconciliation_case ?trade_leg)
      )
    :effect
      (and
        (case_to_posting_batch ?reconciliation_case ?posting_batch)
        (not
          (posting_batch_available ?posting_batch)
        )
        (verification_flag ?reconciliation_case)
      )
  )
  (:action finalize_resolution_and_prepare_hold
    :parameters (?reconciliation_case - reconciliation_case ?trade_leg - trade_leg ?external_confirmation - external_confirmation)
    :precondition
      (and
        (case_to_trade_leg ?reconciliation_case ?trade_leg)
        (ready_for_resolution ?reconciliation_case)
        (case_to_confirmation ?reconciliation_case ?external_confirmation)
        (escalation_flag ?reconciliation_case)
      )
    :effect
      (and
        (not
          (under_additional_review_flag ?reconciliation_case)
        )
        (not
          (escalation_flag ?reconciliation_case)
        )
        (not
          (case_validated ?reconciliation_case)
        )
        (ready_for_final_evidence_collection ?reconciliation_case)
      )
  )
  (:action detach_evidence
    :parameters (?reconciliation_case - reconciliation_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (case_attachment_link ?reconciliation_case ?evidence_attachment)
      )
    :effect
      (and
        (attachment_available ?evidence_attachment)
        (not
          (case_attachment_link ?reconciliation_case ?evidence_attachment)
        )
      )
  )
  (:action operator_attach_evidence
    :parameters (?reconciliation_case - reconciliation_case ?evidence_attachment - evidence_attachment ?operator_identity - operator_identity)
    :precondition
      (and
        (not
          (case_validated ?reconciliation_case)
        )
        (case_assignment_flag ?reconciliation_case)
        (operator_available ?operator_identity)
        (case_attachment_link ?reconciliation_case ?evidence_attachment)
        (case_evidence_verified ?reconciliation_case)
      )
    :effect
      (and
        (not
          (escalation_flag ?reconciliation_case)
        )
        (case_validated ?reconciliation_case)
      )
  )
  (:action close_case_with_operator_attestation
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_active ?reconciliation_case)
        (closure_eligible_secondary ?reconciliation_case)
        (operator_attestation_flag ?reconciliation_case)
        (case_assignment_flag ?reconciliation_case)
        (case_validated ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
        (attachment_attested ?reconciliation_case)
        (verification_flag ?reconciliation_case)
        (ready_for_resolution ?reconciliation_case)
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action operator_attest_evidence
    :parameters (?reconciliation_case - reconciliation_case ?evidence_attachment - evidence_attachment ?operator_identity - operator_identity)
    :precondition
      (and
        (case_validated ?reconciliation_case)
        (operator_available ?operator_identity)
        (not
          (operator_attestation_flag ?reconciliation_case)
        )
        (attachment_attested ?reconciliation_case)
        (case_active ?reconciliation_case)
        (closure_eligible_secondary ?reconciliation_case)
        (case_attachment_link ?reconciliation_case ?evidence_attachment)
      )
    :effect
      (and
        (operator_attestation_flag ?reconciliation_case)
      )
  )
  (:action release_trade_leg_reservation
    :parameters (?reconciliation_case - reconciliation_case ?trade_leg - trade_leg)
    :precondition
      (and
        (case_to_trade_leg ?reconciliation_case ?trade_leg)
      )
    :effect
      (and
        (trade_leg_available ?trade_leg)
        (not
          (case_to_trade_leg ?reconciliation_case ?trade_leg)
        )
      )
  )
  (:action reserve_counterparty_for_case
    :parameters (?reconciliation_case - reconciliation_case ?counterparty_reference - counterparty_reference)
    :precondition
      (and
        (counterparty_reference_available ?counterparty_reference)
        (case_active ?reconciliation_case)
        (case_possible_counterparty ?reconciliation_case ?counterparty_reference)
      )
    :effect
      (and
        (case_to_counterparty ?reconciliation_case ?counterparty_reference)
        (not
          (counterparty_reference_available ?counterparty_reference)
        )
      )
  )
  (:action activate_reconciliation_case
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (not
          (case_active ?reconciliation_case)
        )
        (not
          (case_closed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_active ?reconciliation_case)
      )
  )
  (:action verify_evidence_via_feed_item
    :parameters (?reconciliation_case - reconciliation_case ?third_party_feed_item - third_party_feed_item)
    :precondition
      (and
        (not
          (case_evidence_verified ?reconciliation_case)
        )
        (case_active ?reconciliation_case)
        (third_party_feed_item_available ?third_party_feed_item)
        (case_assignment_flag ?reconciliation_case)
      )
    :effect
      (and
        (escalation_flag ?reconciliation_case)
        (not
          (third_party_feed_item_available ?third_party_feed_item)
        )
        (case_evidence_verified ?reconciliation_case)
      )
  )
  (:action validate_with_settlement_and_compliance
    :parameters (?reconciliation_case - reconciliation_case ?posting_batch - posting_batch ?settlement_event - settlement_event ?compliance_document - compliance_document)
    :precondition
      (and
        (compliance_document_available ?compliance_document)
        (case_possible_compliance_doc ?reconciliation_case ?compliance_document)
        (not
          (verification_flag ?reconciliation_case)
        )
        (case_assignment_flag ?reconciliation_case)
        (posting_batch_available ?posting_batch)
        (case_possible_posting_batch ?reconciliation_case ?posting_batch)
        (case_to_settlement ?reconciliation_case ?settlement_event)
      )
    :effect
      (and
        (case_to_posting_batch ?reconciliation_case ?posting_batch)
        (not
          (compliance_document_available ?compliance_document)
        )
        (under_additional_review_flag ?reconciliation_case)
        (not
          (posting_batch_available ?posting_batch)
        )
        (escalation_flag ?reconciliation_case)
        (verification_flag ?reconciliation_case)
      )
  )
  (:action attest_attachment_from_feed
    :parameters (?reconciliation_case - reconciliation_case ?third_party_feed_item - third_party_feed_item)
    :precondition
      (and
        (third_party_feed_item_available ?third_party_feed_item)
        (not
          (escalation_flag ?reconciliation_case)
        )
        (case_validated ?reconciliation_case)
        (ready_for_resolution ?reconciliation_case)
        (not
          (attachment_attested ?reconciliation_case)
        )
      )
    :effect
      (and
        (attachment_attested ?reconciliation_case)
        (not
          (third_party_feed_item_available ?third_party_feed_item)
        )
      )
  )
  (:action release_ledger_entry_reservation
    :parameters (?reconciliation_case - reconciliation_case ?ledger_entry - ledger_entry)
    :precondition
      (and
        (assigned_ledger_entry ?reconciliation_case ?ledger_entry)
        (not
          (ready_for_resolution ?reconciliation_case)
        )
        (not
          (verification_flag ?reconciliation_case)
        )
      )
    :effect
      (and
        (not
          (assigned_ledger_entry ?reconciliation_case ?ledger_entry)
        )
        (ledger_entry_available ?ledger_entry)
        (not
          (case_assignment_flag ?reconciliation_case)
        )
        (not
          (case_evidence_verified ?reconciliation_case)
        )
        (not
          (ready_for_final_evidence_collection ?reconciliation_case)
        )
        (not
          (case_validated ?reconciliation_case)
        )
        (not
          (under_additional_review_flag ?reconciliation_case)
        )
        (not
          (escalation_flag ?reconciliation_case)
        )
      )
  )
  (:action attest_attachment
    :parameters (?reconciliation_case - reconciliation_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (not
          (attachment_attested ?reconciliation_case)
        )
        (case_attachment_link ?reconciliation_case ?evidence_attachment)
        (case_validated ?reconciliation_case)
        (ready_for_resolution ?reconciliation_case)
        (not
          (escalation_flag ?reconciliation_case)
        )
      )
    :effect
      (and
        (attachment_attested ?reconciliation_case)
      )
  )
  (:action close_case_with_approval
    :parameters (?reconciliation_case - reconciliation_case ?approval_token - approval_token)
    :precondition
      (and
        (attachment_attested ?reconciliation_case)
        (ready_for_resolution ?reconciliation_case)
        (verification_flag ?reconciliation_case)
        (case_approval_consumed ?reconciliation_case ?approval_token)
        (case_validated ?reconciliation_case)
        (case_assignment_flag ?reconciliation_case)
        (case_active ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
        (closure_eligible_secondary ?reconciliation_case)
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action verify_evidence_via_attachment
    :parameters (?reconciliation_case - reconciliation_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (case_active ?reconciliation_case)
        (case_assignment_flag ?reconciliation_case)
        (not
          (case_evidence_verified ?reconciliation_case)
        )
        (case_attachment_link ?reconciliation_case ?evidence_attachment)
      )
    :effect
      (and
        (case_evidence_verified ?reconciliation_case)
      )
  )
  (:action reserve_ledger_entry_for_case
    :parameters (?reconciliation_case - reconciliation_case ?ledger_entry - ledger_entry)
    :precondition
      (and
        (not
          (case_assignment_flag ?reconciliation_case)
        )
        (case_active ?reconciliation_case)
        (ledger_entry_available ?ledger_entry)
        (case_possible_ledger_candidate ?reconciliation_case ?ledger_entry)
      )
    :effect
      (and
        (case_assignment_flag ?reconciliation_case)
        (not
          (ledger_entry_available ?ledger_entry)
        )
        (assigned_ledger_entry ?reconciliation_case ?ledger_entry)
      )
  )
  (:action reapply_evidence_collection
    :parameters (?reconciliation_case - reconciliation_case ?evidence_attachment - evidence_attachment ?operator_identity - operator_identity)
    :precondition
      (and
        (case_assignment_flag ?reconciliation_case)
        (not
          (case_validated ?reconciliation_case)
        )
        (case_attachment_link ?reconciliation_case ?evidence_attachment)
        (ready_for_resolution ?reconciliation_case)
        (operator_available ?operator_identity)
        (ready_for_final_evidence_collection ?reconciliation_case)
      )
    :effect
      (and
        (case_validated ?reconciliation_case)
      )
  )
  (:action consume_approval_for_parent_and_related
    :parameters (?parent_case - parent_case ?related_case - related_case ?approval_token - approval_token)
    :precondition
      (and
        (case_active ?parent_case)
        (related_case_linked_approval_token ?related_case ?approval_token)
        (closure_eligible_secondary ?parent_case)
        (not
          (case_approval_consumed ?parent_case ?approval_token)
        )
        (case_linked_approval_token ?parent_case ?approval_token)
      )
    :effect
      (and
        (case_approval_consumed ?parent_case ?approval_token)
      )
  )
)

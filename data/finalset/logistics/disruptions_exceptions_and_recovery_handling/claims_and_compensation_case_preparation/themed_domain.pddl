(define (domain logistics_claims_compensation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types claims_resource - object document_group - object route_asset_group - object case_root - object logistics_claim_case - case_root field_assessor - claims_resource evidence_document - claims_resource external_expert - claims_resource policy_clause - claims_resource settlement_option - claims_resource compensation_scheme - claims_resource financial_account - claims_resource legal_review_record - claims_resource supporting_item - document_group evidence_bundle - document_group authorisation_token - document_group origin_route_segment - route_asset_group destination_route_segment - route_asset_group claim_package - route_asset_group transport_party_role - logistics_claim_case administrative_party_role - logistics_claim_case carrier - transport_party_role forwarder - transport_party_role claims_specialist - administrative_party_role)
  (:predicates
    (case_registered ?claim_case - logistics_claim_case)
    (case_intake_completed ?claim_case - logistics_claim_case)
    (assessor_assigned ?claim_case - logistics_claim_case)
    (case_settlement_executed ?claim_case - logistics_claim_case)
    (case_approved_for_settlement ?claim_case - logistics_claim_case)
    (case_compensation_initiated ?claim_case - logistics_claim_case)
    (assessor_available ?assessor - field_assessor)
    (case_assessor_assignment ?claim_case - logistics_claim_case ?assessor - field_assessor)
    (evidence_doc_available ?evidence_doc - evidence_document)
    (case_evidence_link ?claim_case - logistics_claim_case ?evidence_doc - evidence_document)
    (external_expert_available ?external_expert - external_expert)
    (case_external_expert_assignment ?claim_case - logistics_claim_case ?external_expert - external_expert)
    (supporting_item_available ?supporting_item - supporting_item)
    (carrier_supporting_item_link ?carrier - carrier ?supporting_item - supporting_item)
    (forwarder_supporting_item_link ?forwarder - forwarder ?supporting_item - supporting_item)
    (carrier_assigned_origin_segment ?carrier - carrier ?origin_segment - origin_route_segment)
    (origin_segment_confirmed ?origin_segment - origin_route_segment)
    (origin_segment_support_attached ?origin_segment - origin_route_segment)
    (carrier_verified ?carrier - carrier)
    (forwarder_assigned_destination_segment ?forwarder - forwarder ?destination_segment - destination_route_segment)
    (destination_segment_confirmed ?destination_segment - destination_route_segment)
    (destination_segment_support_attached ?destination_segment - destination_route_segment)
    (forwarder_verified ?forwarder - forwarder)
    (claim_package_draft ?claim_package - claim_package)
    (claim_package_ready ?claim_package - claim_package)
    (claim_package_origin_link ?claim_package - claim_package ?origin_segment - origin_route_segment)
    (claim_package_destination_link ?claim_package - claim_package ?destination_segment - destination_route_segment)
    (claim_package_origin_verified ?claim_package - claim_package)
    (claim_package_destination_verified ?claim_package - claim_package)
    (claim_package_validated ?claim_package - claim_package)
    (specialist_assigned_carrier ?claims_specialist - claims_specialist ?carrier - carrier)
    (specialist_assigned_forwarder ?claims_specialist - claims_specialist ?forwarder - forwarder)
    (specialist_assigned_package ?claims_specialist - claims_specialist ?claim_package - claim_package)
    (evidence_bundle_available ?evidence_bundle - evidence_bundle)
    (specialist_assigned_evidence_bundle ?claims_specialist - claims_specialist ?evidence_bundle - evidence_bundle)
    (evidence_bundle_attached ?evidence_bundle - evidence_bundle)
    (evidence_bundle_in_package ?evidence_bundle - evidence_bundle ?claim_package - claim_package)
    (specialist_documents_verified ?claims_specialist - claims_specialist)
    (specialist_documents_reviewed ?claims_specialist - claims_specialist)
    (specialist_legal_review_cleared ?claims_specialist - claims_specialist)
    (policy_clause_attached ?claims_specialist - claims_specialist)
    (policy_clause_verified ?claims_specialist - claims_specialist)
    (settlement_option_applicable ?claims_specialist - claims_specialist)
    (specialist_finalized ?claims_specialist - claims_specialist)
    (authorisation_token_available ?authorisation_token - authorisation_token)
    (specialist_has_authorisation_token ?claims_specialist - claims_specialist ?authorisation_token - authorisation_token)
    (specialist_authorisation_token_locked ?claims_specialist - claims_specialist)
    (specialist_authorisation_validated ?claims_specialist - claims_specialist)
    (specialist_authorisation_confirmed ?claims_specialist - claims_specialist)
    (policy_clause_available ?policy_clause - policy_clause)
    (specialist_policy_clause_link ?claims_specialist - claims_specialist ?policy_clause - policy_clause)
    (settlement_option_available ?settlement_option - settlement_option)
    (specialist_settlement_option_link ?claims_specialist - claims_specialist ?settlement_option - settlement_option)
    (financial_account_available ?financial_account - financial_account)
    (specialist_financial_account_link ?claims_specialist - claims_specialist ?financial_account - financial_account)
    (legal_review_available ?legal_review - legal_review_record)
    (specialist_legal_review_link ?claims_specialist - claims_specialist ?legal_review - legal_review_record)
    (compensation_scheme_available ?compensation_scheme - compensation_scheme)
    (case_compensation_scheme_link ?claim_case - logistics_claim_case ?compensation_scheme - compensation_scheme)
    (carrier_ready ?carrier - carrier)
    (forwarder_ready ?forwarder - forwarder)
    (final_signoff_recorded ?claims_specialist - claims_specialist)
  )
  (:action register_claim_case
    :parameters (?claim_case - logistics_claim_case)
    :precondition
      (and
        (not
          (case_registered ?claim_case)
        )
        (not
          (case_settlement_executed ?claim_case)
        )
      )
    :effect (case_registered ?claim_case)
  )
  (:action assign_assessor
    :parameters (?claim_case - logistics_claim_case ?assessor - field_assessor)
    :precondition
      (and
        (case_registered ?claim_case)
        (not
          (assessor_assigned ?claim_case)
        )
        (assessor_available ?assessor)
      )
    :effect
      (and
        (assessor_assigned ?claim_case)
        (case_assessor_assignment ?claim_case ?assessor)
        (not
          (assessor_available ?assessor)
        )
      )
  )
  (:action attach_evidence_document
    :parameters (?claim_case - logistics_claim_case ?evidence_doc - evidence_document)
    :precondition
      (and
        (case_registered ?claim_case)
        (assessor_assigned ?claim_case)
        (evidence_doc_available ?evidence_doc)
      )
    :effect
      (and
        (case_evidence_link ?claim_case ?evidence_doc)
        (not
          (evidence_doc_available ?evidence_doc)
        )
      )
  )
  (:action finalize_case_intake
    :parameters (?claim_case - logistics_claim_case ?evidence_doc - evidence_document)
    :precondition
      (and
        (case_registered ?claim_case)
        (assessor_assigned ?claim_case)
        (case_evidence_link ?claim_case ?evidence_doc)
        (not
          (case_intake_completed ?claim_case)
        )
      )
    :effect (case_intake_completed ?claim_case)
  )
  (:action release_evidence_document
    :parameters (?claim_case - logistics_claim_case ?evidence_doc - evidence_document)
    :precondition
      (and
        (case_evidence_link ?claim_case ?evidence_doc)
      )
    :effect
      (and
        (evidence_doc_available ?evidence_doc)
        (not
          (case_evidence_link ?claim_case ?evidence_doc)
        )
      )
  )
  (:action assign_external_expert
    :parameters (?claim_case - logistics_claim_case ?external_expert - external_expert)
    :precondition
      (and
        (case_intake_completed ?claim_case)
        (external_expert_available ?external_expert)
      )
    :effect
      (and
        (case_external_expert_assignment ?claim_case ?external_expert)
        (not
          (external_expert_available ?external_expert)
        )
      )
  )
  (:action release_external_expert
    :parameters (?claim_case - logistics_claim_case ?external_expert - external_expert)
    :precondition
      (and
        (case_external_expert_assignment ?claim_case ?external_expert)
      )
    :effect
      (and
        (external_expert_available ?external_expert)
        (not
          (case_external_expert_assignment ?claim_case ?external_expert)
        )
      )
  )
  (:action link_financial_account_to_specialist
    :parameters (?claims_specialist - claims_specialist ?financial_account - financial_account)
    :precondition
      (and
        (case_intake_completed ?claims_specialist)
        (financial_account_available ?financial_account)
      )
    :effect
      (and
        (specialist_financial_account_link ?claims_specialist ?financial_account)
        (not
          (financial_account_available ?financial_account)
        )
      )
  )
  (:action unlink_financial_account_from_specialist
    :parameters (?claims_specialist - claims_specialist ?financial_account - financial_account)
    :precondition
      (and
        (specialist_financial_account_link ?claims_specialist ?financial_account)
      )
    :effect
      (and
        (financial_account_available ?financial_account)
        (not
          (specialist_financial_account_link ?claims_specialist ?financial_account)
        )
      )
  )
  (:action attach_legal_review_record
    :parameters (?claims_specialist - claims_specialist ?legal_review - legal_review_record)
    :precondition
      (and
        (case_intake_completed ?claims_specialist)
        (legal_review_available ?legal_review)
      )
    :effect
      (and
        (specialist_legal_review_link ?claims_specialist ?legal_review)
        (not
          (legal_review_available ?legal_review)
        )
      )
  )
  (:action detach_legal_review_record
    :parameters (?claims_specialist - claims_specialist ?legal_review - legal_review_record)
    :precondition
      (and
        (specialist_legal_review_link ?claims_specialist ?legal_review)
      )
    :effect
      (and
        (legal_review_available ?legal_review)
        (not
          (specialist_legal_review_link ?claims_specialist ?legal_review)
        )
      )
  )
  (:action reserve_origin_segment_for_carrier
    :parameters (?carrier - carrier ?origin_segment - origin_route_segment ?evidence_doc - evidence_document)
    :precondition
      (and
        (case_intake_completed ?carrier)
        (case_evidence_link ?carrier ?evidence_doc)
        (carrier_assigned_origin_segment ?carrier ?origin_segment)
        (not
          (origin_segment_confirmed ?origin_segment)
        )
        (not
          (origin_segment_support_attached ?origin_segment)
        )
      )
    :effect (origin_segment_confirmed ?origin_segment)
  )
  (:action confirm_origin_with_expert
    :parameters (?carrier - carrier ?origin_segment - origin_route_segment ?external_expert - external_expert)
    :precondition
      (and
        (case_intake_completed ?carrier)
        (case_external_expert_assignment ?carrier ?external_expert)
        (carrier_assigned_origin_segment ?carrier ?origin_segment)
        (origin_segment_confirmed ?origin_segment)
        (not
          (carrier_ready ?carrier)
        )
      )
    :effect
      (and
        (carrier_ready ?carrier)
        (carrier_verified ?carrier)
      )
  )
  (:action attach_supporting_item_to_origin
    :parameters (?carrier - carrier ?origin_segment - origin_route_segment ?supporting_item - supporting_item)
    :precondition
      (and
        (case_intake_completed ?carrier)
        (carrier_assigned_origin_segment ?carrier ?origin_segment)
        (supporting_item_available ?supporting_item)
        (not
          (carrier_ready ?carrier)
        )
      )
    :effect
      (and
        (origin_segment_support_attached ?origin_segment)
        (carrier_ready ?carrier)
        (carrier_supporting_item_link ?carrier ?supporting_item)
        (not
          (supporting_item_available ?supporting_item)
        )
      )
  )
  (:action finalize_origin_verification
    :parameters (?carrier - carrier ?origin_segment - origin_route_segment ?evidence_doc - evidence_document ?supporting_item - supporting_item)
    :precondition
      (and
        (case_intake_completed ?carrier)
        (case_evidence_link ?carrier ?evidence_doc)
        (carrier_assigned_origin_segment ?carrier ?origin_segment)
        (origin_segment_support_attached ?origin_segment)
        (carrier_supporting_item_link ?carrier ?supporting_item)
        (not
          (carrier_verified ?carrier)
        )
      )
    :effect
      (and
        (origin_segment_confirmed ?origin_segment)
        (carrier_verified ?carrier)
        (supporting_item_available ?supporting_item)
        (not
          (carrier_supporting_item_link ?carrier ?supporting_item)
        )
      )
  )
  (:action reserve_destination_segment_for_forwarder
    :parameters (?forwarder - forwarder ?destination_segment - destination_route_segment ?evidence_doc - evidence_document)
    :precondition
      (and
        (case_intake_completed ?forwarder)
        (case_evidence_link ?forwarder ?evidence_doc)
        (forwarder_assigned_destination_segment ?forwarder ?destination_segment)
        (not
          (destination_segment_confirmed ?destination_segment)
        )
        (not
          (destination_segment_support_attached ?destination_segment)
        )
      )
    :effect (destination_segment_confirmed ?destination_segment)
  )
  (:action confirm_destination_with_expert
    :parameters (?forwarder - forwarder ?destination_segment - destination_route_segment ?external_expert - external_expert)
    :precondition
      (and
        (case_intake_completed ?forwarder)
        (case_external_expert_assignment ?forwarder ?external_expert)
        (forwarder_assigned_destination_segment ?forwarder ?destination_segment)
        (destination_segment_confirmed ?destination_segment)
        (not
          (forwarder_ready ?forwarder)
        )
      )
    :effect
      (and
        (forwarder_ready ?forwarder)
        (forwarder_verified ?forwarder)
      )
  )
  (:action attach_supporting_item_to_destination
    :parameters (?forwarder - forwarder ?destination_segment - destination_route_segment ?supporting_item - supporting_item)
    :precondition
      (and
        (case_intake_completed ?forwarder)
        (forwarder_assigned_destination_segment ?forwarder ?destination_segment)
        (supporting_item_available ?supporting_item)
        (not
          (forwarder_ready ?forwarder)
        )
      )
    :effect
      (and
        (destination_segment_support_attached ?destination_segment)
        (forwarder_ready ?forwarder)
        (forwarder_supporting_item_link ?forwarder ?supporting_item)
        (not
          (supporting_item_available ?supporting_item)
        )
      )
  )
  (:action finalize_destination_verification
    :parameters (?forwarder - forwarder ?destination_segment - destination_route_segment ?evidence_doc - evidence_document ?supporting_item - supporting_item)
    :precondition
      (and
        (case_intake_completed ?forwarder)
        (case_evidence_link ?forwarder ?evidence_doc)
        (forwarder_assigned_destination_segment ?forwarder ?destination_segment)
        (destination_segment_support_attached ?destination_segment)
        (forwarder_supporting_item_link ?forwarder ?supporting_item)
        (not
          (forwarder_verified ?forwarder)
        )
      )
    :effect
      (and
        (destination_segment_confirmed ?destination_segment)
        (forwarder_verified ?forwarder)
        (supporting_item_available ?supporting_item)
        (not
          (forwarder_supporting_item_link ?forwarder ?supporting_item)
        )
      )
  )
  (:action assemble_claim_package_standard
    :parameters (?carrier - carrier ?forwarder - forwarder ?origin_segment - origin_route_segment ?destination_segment - destination_route_segment ?claim_package - claim_package)
    :precondition
      (and
        (carrier_ready ?carrier)
        (forwarder_ready ?forwarder)
        (carrier_assigned_origin_segment ?carrier ?origin_segment)
        (forwarder_assigned_destination_segment ?forwarder ?destination_segment)
        (origin_segment_confirmed ?origin_segment)
        (destination_segment_confirmed ?destination_segment)
        (carrier_verified ?carrier)
        (forwarder_verified ?forwarder)
        (claim_package_draft ?claim_package)
      )
    :effect
      (and
        (claim_package_ready ?claim_package)
        (claim_package_origin_link ?claim_package ?origin_segment)
        (claim_package_destination_link ?claim_package ?destination_segment)
        (not
          (claim_package_draft ?claim_package)
        )
      )
  )
  (:action assemble_claim_package_with_origin_support
    :parameters (?carrier - carrier ?forwarder - forwarder ?origin_segment - origin_route_segment ?destination_segment - destination_route_segment ?claim_package - claim_package)
    :precondition
      (and
        (carrier_ready ?carrier)
        (forwarder_ready ?forwarder)
        (carrier_assigned_origin_segment ?carrier ?origin_segment)
        (forwarder_assigned_destination_segment ?forwarder ?destination_segment)
        (origin_segment_support_attached ?origin_segment)
        (destination_segment_confirmed ?destination_segment)
        (not
          (carrier_verified ?carrier)
        )
        (forwarder_verified ?forwarder)
        (claim_package_draft ?claim_package)
      )
    :effect
      (and
        (claim_package_ready ?claim_package)
        (claim_package_origin_link ?claim_package ?origin_segment)
        (claim_package_destination_link ?claim_package ?destination_segment)
        (claim_package_origin_verified ?claim_package)
        (not
          (claim_package_draft ?claim_package)
        )
      )
  )
  (:action assemble_claim_package_with_destination_support
    :parameters (?carrier - carrier ?forwarder - forwarder ?origin_segment - origin_route_segment ?destination_segment - destination_route_segment ?claim_package - claim_package)
    :precondition
      (and
        (carrier_ready ?carrier)
        (forwarder_ready ?forwarder)
        (carrier_assigned_origin_segment ?carrier ?origin_segment)
        (forwarder_assigned_destination_segment ?forwarder ?destination_segment)
        (origin_segment_confirmed ?origin_segment)
        (destination_segment_support_attached ?destination_segment)
        (carrier_verified ?carrier)
        (not
          (forwarder_verified ?forwarder)
        )
        (claim_package_draft ?claim_package)
      )
    :effect
      (and
        (claim_package_ready ?claim_package)
        (claim_package_origin_link ?claim_package ?origin_segment)
        (claim_package_destination_link ?claim_package ?destination_segment)
        (claim_package_destination_verified ?claim_package)
        (not
          (claim_package_draft ?claim_package)
        )
      )
  )
  (:action assemble_claim_package_with_full_support
    :parameters (?carrier - carrier ?forwarder - forwarder ?origin_segment - origin_route_segment ?destination_segment - destination_route_segment ?claim_package - claim_package)
    :precondition
      (and
        (carrier_ready ?carrier)
        (forwarder_ready ?forwarder)
        (carrier_assigned_origin_segment ?carrier ?origin_segment)
        (forwarder_assigned_destination_segment ?forwarder ?destination_segment)
        (origin_segment_support_attached ?origin_segment)
        (destination_segment_support_attached ?destination_segment)
        (not
          (carrier_verified ?carrier)
        )
        (not
          (forwarder_verified ?forwarder)
        )
        (claim_package_draft ?claim_package)
      )
    :effect
      (and
        (claim_package_ready ?claim_package)
        (claim_package_origin_link ?claim_package ?origin_segment)
        (claim_package_destination_link ?claim_package ?destination_segment)
        (claim_package_origin_verified ?claim_package)
        (claim_package_destination_verified ?claim_package)
        (not
          (claim_package_draft ?claim_package)
        )
      )
  )
  (:action validate_claim_package
    :parameters (?claim_package - claim_package ?carrier - carrier ?evidence_doc - evidence_document)
    :precondition
      (and
        (claim_package_ready ?claim_package)
        (carrier_ready ?carrier)
        (case_evidence_link ?carrier ?evidence_doc)
        (not
          (claim_package_validated ?claim_package)
        )
      )
    :effect (claim_package_validated ?claim_package)
  )
  (:action specialist_attach_evidence_bundle
    :parameters (?claims_specialist - claims_specialist ?evidence_bundle - evidence_bundle ?claim_package - claim_package)
    :precondition
      (and
        (case_intake_completed ?claims_specialist)
        (specialist_assigned_package ?claims_specialist ?claim_package)
        (specialist_assigned_evidence_bundle ?claims_specialist ?evidence_bundle)
        (evidence_bundle_available ?evidence_bundle)
        (claim_package_ready ?claim_package)
        (claim_package_validated ?claim_package)
        (not
          (evidence_bundle_attached ?evidence_bundle)
        )
      )
    :effect
      (and
        (evidence_bundle_attached ?evidence_bundle)
        (evidence_bundle_in_package ?evidence_bundle ?claim_package)
        (not
          (evidence_bundle_available ?evidence_bundle)
        )
      )
  )
  (:action specialist_verify_documentation_initial
    :parameters (?claims_specialist - claims_specialist ?evidence_bundle - evidence_bundle ?claim_package - claim_package ?evidence_doc - evidence_document)
    :precondition
      (and
        (case_intake_completed ?claims_specialist)
        (specialist_assigned_evidence_bundle ?claims_specialist ?evidence_bundle)
        (evidence_bundle_attached ?evidence_bundle)
        (evidence_bundle_in_package ?evidence_bundle ?claim_package)
        (case_evidence_link ?claims_specialist ?evidence_doc)
        (not
          (claim_package_origin_verified ?claim_package)
        )
        (not
          (specialist_documents_verified ?claims_specialist)
        )
      )
    :effect (specialist_documents_verified ?claims_specialist)
  )
  (:action specialist_attach_policy_clause
    :parameters (?claims_specialist - claims_specialist ?policy_clause - policy_clause)
    :precondition
      (and
        (case_intake_completed ?claims_specialist)
        (policy_clause_available ?policy_clause)
        (not
          (policy_clause_attached ?claims_specialist)
        )
      )
    :effect
      (and
        (policy_clause_attached ?claims_specialist)
        (specialist_policy_clause_link ?claims_specialist ?policy_clause)
        (not
          (policy_clause_available ?policy_clause)
        )
      )
  )
  (:action specialist_verify_policy_and_documents
    :parameters (?claims_specialist - claims_specialist ?evidence_bundle - evidence_bundle ?claim_package - claim_package ?evidence_doc - evidence_document ?policy_clause - policy_clause)
    :precondition
      (and
        (case_intake_completed ?claims_specialist)
        (specialist_assigned_evidence_bundle ?claims_specialist ?evidence_bundle)
        (evidence_bundle_attached ?evidence_bundle)
        (evidence_bundle_in_package ?evidence_bundle ?claim_package)
        (case_evidence_link ?claims_specialist ?evidence_doc)
        (claim_package_origin_verified ?claim_package)
        (policy_clause_attached ?claims_specialist)
        (specialist_policy_clause_link ?claims_specialist ?policy_clause)
        (not
          (specialist_documents_verified ?claims_specialist)
        )
      )
    :effect
      (and
        (specialist_documents_verified ?claims_specialist)
        (policy_clause_verified ?claims_specialist)
      )
  )
  (:action specialist_initiate_legal_review_variant_a
    :parameters (?claims_specialist - claims_specialist ?financial_account - financial_account ?external_expert - external_expert ?evidence_bundle - evidence_bundle ?claim_package - claim_package)
    :precondition
      (and
        (specialist_documents_verified ?claims_specialist)
        (specialist_financial_account_link ?claims_specialist ?financial_account)
        (case_external_expert_assignment ?claims_specialist ?external_expert)
        (specialist_assigned_evidence_bundle ?claims_specialist ?evidence_bundle)
        (evidence_bundle_in_package ?evidence_bundle ?claim_package)
        (not
          (claim_package_destination_verified ?claim_package)
        )
        (not
          (specialist_documents_reviewed ?claims_specialist)
        )
      )
    :effect (specialist_documents_reviewed ?claims_specialist)
  )
  (:action specialist_initiate_legal_review_variant_b
    :parameters (?claims_specialist - claims_specialist ?financial_account - financial_account ?external_expert - external_expert ?evidence_bundle - evidence_bundle ?claim_package - claim_package)
    :precondition
      (and
        (specialist_documents_verified ?claims_specialist)
        (specialist_financial_account_link ?claims_specialist ?financial_account)
        (case_external_expert_assignment ?claims_specialist ?external_expert)
        (specialist_assigned_evidence_bundle ?claims_specialist ?evidence_bundle)
        (evidence_bundle_in_package ?evidence_bundle ?claim_package)
        (claim_package_destination_verified ?claim_package)
        (not
          (specialist_documents_reviewed ?claims_specialist)
        )
      )
    :effect (specialist_documents_reviewed ?claims_specialist)
  )
  (:action finalize_legal_review_unverified
    :parameters (?claims_specialist - claims_specialist ?legal_review - legal_review_record ?evidence_bundle - evidence_bundle ?claim_package - claim_package)
    :precondition
      (and
        (specialist_documents_reviewed ?claims_specialist)
        (specialist_legal_review_link ?claims_specialist ?legal_review)
        (specialist_assigned_evidence_bundle ?claims_specialist ?evidence_bundle)
        (evidence_bundle_in_package ?evidence_bundle ?claim_package)
        (not
          (claim_package_origin_verified ?claim_package)
        )
        (not
          (claim_package_destination_verified ?claim_package)
        )
        (not
          (specialist_legal_review_cleared ?claims_specialist)
        )
      )
    :effect (specialist_legal_review_cleared ?claims_specialist)
  )
  (:action finalize_legal_review_origin_verified
    :parameters (?claims_specialist - claims_specialist ?legal_review - legal_review_record ?evidence_bundle - evidence_bundle ?claim_package - claim_package)
    :precondition
      (and
        (specialist_documents_reviewed ?claims_specialist)
        (specialist_legal_review_link ?claims_specialist ?legal_review)
        (specialist_assigned_evidence_bundle ?claims_specialist ?evidence_bundle)
        (evidence_bundle_in_package ?evidence_bundle ?claim_package)
        (claim_package_origin_verified ?claim_package)
        (not
          (claim_package_destination_verified ?claim_package)
        )
        (not
          (specialist_legal_review_cleared ?claims_specialist)
        )
      )
    :effect
      (and
        (specialist_legal_review_cleared ?claims_specialist)
        (settlement_option_applicable ?claims_specialist)
      )
  )
  (:action finalize_legal_review_destination_verified
    :parameters (?claims_specialist - claims_specialist ?legal_review - legal_review_record ?evidence_bundle - evidence_bundle ?claim_package - claim_package)
    :precondition
      (and
        (specialist_documents_reviewed ?claims_specialist)
        (specialist_legal_review_link ?claims_specialist ?legal_review)
        (specialist_assigned_evidence_bundle ?claims_specialist ?evidence_bundle)
        (evidence_bundle_in_package ?evidence_bundle ?claim_package)
        (not
          (claim_package_origin_verified ?claim_package)
        )
        (claim_package_destination_verified ?claim_package)
        (not
          (specialist_legal_review_cleared ?claims_specialist)
        )
      )
    :effect
      (and
        (specialist_legal_review_cleared ?claims_specialist)
        (settlement_option_applicable ?claims_specialist)
      )
  )
  (:action finalize_legal_review_both_verified
    :parameters (?claims_specialist - claims_specialist ?legal_review - legal_review_record ?evidence_bundle - evidence_bundle ?claim_package - claim_package)
    :precondition
      (and
        (specialist_documents_reviewed ?claims_specialist)
        (specialist_legal_review_link ?claims_specialist ?legal_review)
        (specialist_assigned_evidence_bundle ?claims_specialist ?evidence_bundle)
        (evidence_bundle_in_package ?evidence_bundle ?claim_package)
        (claim_package_origin_verified ?claim_package)
        (claim_package_destination_verified ?claim_package)
        (not
          (specialist_legal_review_cleared ?claims_specialist)
        )
      )
    :effect
      (and
        (specialist_legal_review_cleared ?claims_specialist)
        (settlement_option_applicable ?claims_specialist)
      )
  )
  (:action record_specialist_signoff
    :parameters (?claims_specialist - claims_specialist)
    :precondition
      (and
        (specialist_legal_review_cleared ?claims_specialist)
        (not
          (settlement_option_applicable ?claims_specialist)
        )
        (not
          (final_signoff_recorded ?claims_specialist)
        )
      )
    :effect
      (and
        (final_signoff_recorded ?claims_specialist)
        (case_approved_for_settlement ?claims_specialist)
      )
  )
  (:action specialist_attach_settlement_option
    :parameters (?claims_specialist - claims_specialist ?settlement_option - settlement_option)
    :precondition
      (and
        (specialist_legal_review_cleared ?claims_specialist)
        (settlement_option_applicable ?claims_specialist)
        (settlement_option_available ?settlement_option)
      )
    :effect
      (and
        (specialist_settlement_option_link ?claims_specialist ?settlement_option)
        (not
          (settlement_option_available ?settlement_option)
        )
      )
  )
  (:action specialist_prepare_for_final_approval
    :parameters (?claims_specialist - claims_specialist ?carrier - carrier ?forwarder - forwarder ?evidence_doc - evidence_document ?settlement_option - settlement_option)
    :precondition
      (and
        (specialist_legal_review_cleared ?claims_specialist)
        (settlement_option_applicable ?claims_specialist)
        (specialist_settlement_option_link ?claims_specialist ?settlement_option)
        (specialist_assigned_carrier ?claims_specialist ?carrier)
        (specialist_assigned_forwarder ?claims_specialist ?forwarder)
        (carrier_verified ?carrier)
        (forwarder_verified ?forwarder)
        (case_evidence_link ?claims_specialist ?evidence_doc)
        (not
          (specialist_finalized ?claims_specialist)
        )
      )
    :effect (specialist_finalized ?claims_specialist)
  )
  (:action finalize_specialist_signoff
    :parameters (?claims_specialist - claims_specialist)
    :precondition
      (and
        (specialist_legal_review_cleared ?claims_specialist)
        (specialist_finalized ?claims_specialist)
        (not
          (final_signoff_recorded ?claims_specialist)
        )
      )
    :effect
      (and
        (final_signoff_recorded ?claims_specialist)
        (case_approved_for_settlement ?claims_specialist)
      )
  )
  (:action specialist_reserve_authorisation_token
    :parameters (?claims_specialist - claims_specialist ?authorisation_token - authorisation_token ?evidence_doc - evidence_document)
    :precondition
      (and
        (case_intake_completed ?claims_specialist)
        (case_evidence_link ?claims_specialist ?evidence_doc)
        (authorisation_token_available ?authorisation_token)
        (specialist_has_authorisation_token ?claims_specialist ?authorisation_token)
        (not
          (specialist_authorisation_token_locked ?claims_specialist)
        )
      )
    :effect
      (and
        (specialist_authorisation_token_locked ?claims_specialist)
        (not
          (authorisation_token_available ?authorisation_token)
        )
      )
  )
  (:action process_authorisation
    :parameters (?claims_specialist - claims_specialist ?external_expert - external_expert)
    :precondition
      (and
        (specialist_authorisation_token_locked ?claims_specialist)
        (case_external_expert_assignment ?claims_specialist ?external_expert)
        (not
          (specialist_authorisation_validated ?claims_specialist)
        )
      )
    :effect (specialist_authorisation_validated ?claims_specialist)
  )
  (:action confirm_authorisation
    :parameters (?claims_specialist - claims_specialist ?legal_review - legal_review_record)
    :precondition
      (and
        (specialist_authorisation_validated ?claims_specialist)
        (specialist_legal_review_link ?claims_specialist ?legal_review)
        (not
          (specialist_authorisation_confirmed ?claims_specialist)
        )
      )
    :effect (specialist_authorisation_confirmed ?claims_specialist)
  )
  (:action finalize_authorisation_signoff
    :parameters (?claims_specialist - claims_specialist)
    :precondition
      (and
        (specialist_authorisation_confirmed ?claims_specialist)
        (not
          (final_signoff_recorded ?claims_specialist)
        )
      )
    :effect
      (and
        (final_signoff_recorded ?claims_specialist)
        (case_approved_for_settlement ?claims_specialist)
      )
  )
  (:action carrier_mark_approved
    :parameters (?carrier - carrier ?claim_package - claim_package)
    :precondition
      (and
        (carrier_ready ?carrier)
        (carrier_verified ?carrier)
        (claim_package_ready ?claim_package)
        (claim_package_validated ?claim_package)
        (not
          (case_approved_for_settlement ?carrier)
        )
      )
    :effect (case_approved_for_settlement ?carrier)
  )
  (:action forwarder_mark_approved
    :parameters (?forwarder - forwarder ?claim_package - claim_package)
    :precondition
      (and
        (forwarder_ready ?forwarder)
        (forwarder_verified ?forwarder)
        (claim_package_ready ?claim_package)
        (claim_package_validated ?claim_package)
        (not
          (case_approved_for_settlement ?forwarder)
        )
      )
    :effect (case_approved_for_settlement ?forwarder)
  )
  (:action initiate_compensation_request
    :parameters (?claim_case - logistics_claim_case ?compensation_scheme - compensation_scheme ?evidence_doc - evidence_document)
    :precondition
      (and
        (case_approved_for_settlement ?claim_case)
        (case_evidence_link ?claim_case ?evidence_doc)
        (compensation_scheme_available ?compensation_scheme)
        (not
          (case_compensation_initiated ?claim_case)
        )
      )
    :effect
      (and
        (case_compensation_initiated ?claim_case)
        (case_compensation_scheme_link ?claim_case ?compensation_scheme)
        (not
          (compensation_scheme_available ?compensation_scheme)
        )
      )
  )
  (:action execute_settlement_for_carrier
    :parameters (?carrier - carrier ?assessor - field_assessor ?compensation_scheme - compensation_scheme)
    :precondition
      (and
        (case_compensation_initiated ?carrier)
        (case_assessor_assignment ?carrier ?assessor)
        (case_compensation_scheme_link ?carrier ?compensation_scheme)
        (not
          (case_settlement_executed ?carrier)
        )
      )
    :effect
      (and
        (case_settlement_executed ?carrier)
        (assessor_available ?assessor)
        (compensation_scheme_available ?compensation_scheme)
      )
  )
  (:action execute_settlement_for_forwarder
    :parameters (?forwarder - forwarder ?assessor - field_assessor ?compensation_scheme - compensation_scheme)
    :precondition
      (and
        (case_compensation_initiated ?forwarder)
        (case_assessor_assignment ?forwarder ?assessor)
        (case_compensation_scheme_link ?forwarder ?compensation_scheme)
        (not
          (case_settlement_executed ?forwarder)
        )
      )
    :effect
      (and
        (case_settlement_executed ?forwarder)
        (assessor_available ?assessor)
        (compensation_scheme_available ?compensation_scheme)
      )
  )
  (:action execute_settlement_for_specialist
    :parameters (?claims_specialist - claims_specialist ?assessor - field_assessor ?compensation_scheme - compensation_scheme)
    :precondition
      (and
        (case_compensation_initiated ?claims_specialist)
        (case_assessor_assignment ?claims_specialist ?assessor)
        (case_compensation_scheme_link ?claims_specialist ?compensation_scheme)
        (not
          (case_settlement_executed ?claims_specialist)
        )
      )
    :effect
      (and
        (case_settlement_executed ?claims_specialist)
        (assessor_available ?assessor)
        (compensation_scheme_available ?compensation_scheme)
      )
  )
)

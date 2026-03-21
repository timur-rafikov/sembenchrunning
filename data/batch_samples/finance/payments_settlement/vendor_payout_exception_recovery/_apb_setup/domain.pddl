(define (domain vendor_payout_exception_recovery_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object payout_case - entity funding_source_account - entity settlement_rail - entity beneficiary_account - entity internal_ledger_account - entity external_liquidity_pool - entity payment_instruction - entity third_party_receipt - entity execution_profile - entity compliance_credential - entity clearing_reference - entity alternative_rail_option - entity operational_policy - entity retry_policy - operational_policy settlement_policy - operational_policy automated_case_variant - payout_case operator_case_variant - payout_case)

  (:predicates
    (case_open ?payout_case - payout_case)
    (case_funding_reservation ?payout_case - payout_case ?funding_source_account - funding_source_account)
    (case_funding_attached ?payout_case - payout_case)
    (case_instruction_authorized ?payout_case - payout_case)
    (case_instruction_cleared ?payout_case - payout_case)
    (case_internal_ledger_reserved ?payout_case - payout_case ?internal_ledger_account - internal_ledger_account)
    (case_beneficiary_reserved ?payout_case - payout_case ?beneficiary_account - beneficiary_account)
    (case_external_liquidity_reserved ?payout_case - payout_case ?external_liquidity_pool - external_liquidity_pool)
    (case_alternative_rail_reserved ?payout_case - payout_case ?alternative_rail_option - alternative_rail_option)
    (case_selected_settlement_rail ?payout_case - payout_case ?settlement_rail - settlement_rail)
    (case_execution_planned ?payout_case - payout_case)
    (case_approval_granted ?payout_case - payout_case)
    (case_instruction_marked_for_execution ?payout_case - payout_case)
    (case_finalized ?payout_case - payout_case)
    (case_third_party_receipt_recorded ?payout_case - payout_case)
    (case_execution_in_progress ?payout_case - payout_case)
    (operator_variant_execution_profile ?payout_case - payout_case ?execution_profile - execution_profile)
    (case_bound_execution_profile ?payout_case - payout_case ?execution_profile - execution_profile)
    (case_staged_for_execution ?payout_case - payout_case)
    (funding_source_available ?funding_source_account - funding_source_account)
    (settlement_rail_available ?settlement_rail - settlement_rail)
    (internal_ledger_available ?internal_ledger_account - internal_ledger_account)
    (beneficiary_account_available ?beneficiary_account - beneficiary_account)
    (external_liquidity_available ?external_liquidity_pool - external_liquidity_pool)
    (payment_instruction_available ?payment_instruction - payment_instruction)
    (third_party_receipt_available ?third_party_receipt - third_party_receipt)
    (execution_profile_available ?execution_profile - execution_profile)
    (compliance_credential_available ?compliance_credential - compliance_credential)
    (clearing_reference_available ?clearing_reference - clearing_reference)
    (alternative_rail_option_available ?alternative_rail_option - alternative_rail_option)
    (case_funding_compatible ?payout_case - payout_case ?funding_source_account - funding_source_account)
    (case_rail_compatible ?payout_case - payout_case ?settlement_rail - settlement_rail)
    (case_internal_ledger_compatible ?payout_case - payout_case ?internal_ledger_account - internal_ledger_account)
    (case_beneficiary_compatible ?payout_case - payout_case ?beneficiary_account - beneficiary_account)
    (case_external_liquidity_compatible ?payout_case - payout_case ?external_liquidity_pool - external_liquidity_pool)
    (case_clearing_reference_compatible ?payout_case - payout_case ?clearing_reference - clearing_reference)
    (case_alternative_rail_compatible ?payout_case - payout_case ?alternative_rail_option - alternative_rail_option)
    (case_policy_applicable ?payout_case - payout_case ?operational_policy - operational_policy)
    (automated_variant_execution_profile ?payout_case - payout_case ?execution_profile - execution_profile)
    (case_has_automated_variant ?payout_case - payout_case)
    (case_has_operator_variant ?payout_case - payout_case)
    (case_instruction_reserved ?payout_case - payout_case ?payment_instruction - payment_instruction)
    (case_requires_reconciliation ?payout_case - payout_case)
    (case_execution_profile_binding ?payout_case - payout_case ?execution_profile - execution_profile)
  )
  (:action open_payout_recovery_case
    :parameters (?payout_case - payout_case)
    :precondition
      (and
        (not
          (case_open ?payout_case)
        )
        (not
          (case_finalized ?payout_case)
        )
      )
    :effect
      (and
        (case_open ?payout_case)
      )
  )
  (:action attach_funding_source_to_case
    :parameters (?payout_case - payout_case ?funding_source_account - funding_source_account)
    :precondition
      (and
        (case_open ?payout_case)
        (funding_source_available ?funding_source_account)
        (case_funding_compatible ?payout_case ?funding_source_account)
        (not
          (case_funding_attached ?payout_case)
        )
      )
    :effect
      (and
        (case_funding_reservation ?payout_case ?funding_source_account)
        (case_funding_attached ?payout_case)
        (not
          (funding_source_available ?funding_source_account)
        )
      )
  )
  (:action release_funding_from_case
    :parameters (?payout_case - payout_case ?funding_source_account - funding_source_account)
    :precondition
      (and
        (case_funding_reservation ?payout_case ?funding_source_account)
        (not
          (case_execution_planned ?payout_case)
        )
        (not
          (case_approval_granted ?payout_case)
        )
      )
    :effect
      (and
        (not
          (case_funding_reservation ?payout_case ?funding_source_account)
        )
        (not
          (case_funding_attached ?payout_case)
        )
        (not
          (case_instruction_authorized ?payout_case)
        )
        (not
          (case_instruction_cleared ?payout_case)
        )
        (not
          (case_third_party_receipt_recorded ?payout_case)
        )
        (not
          (case_execution_in_progress ?payout_case)
        )
        (not
          (case_requires_reconciliation ?payout_case)
        )
        (funding_source_available ?funding_source_account)
      )
  )
  (:action reserve_payment_instruction_for_case
    :parameters (?payout_case - payout_case ?payment_instruction - payment_instruction)
    :precondition
      (and
        (case_open ?payout_case)
        (payment_instruction_available ?payment_instruction)
      )
    :effect
      (and
        (case_instruction_reserved ?payout_case ?payment_instruction)
        (not
          (payment_instruction_available ?payment_instruction)
        )
      )
  )
  (:action release_payment_instruction_from_case
    :parameters (?payout_case - payout_case ?payment_instruction - payment_instruction)
    :precondition
      (and
        (case_instruction_reserved ?payout_case ?payment_instruction)
      )
    :effect
      (and
        (payment_instruction_available ?payment_instruction)
        (not
          (case_instruction_reserved ?payout_case ?payment_instruction)
        )
      )
  )
  (:action authorize_payment_instruction_for_case
    :parameters (?payout_case - payout_case ?payment_instruction - payment_instruction)
    :precondition
      (and
        (case_open ?payout_case)
        (case_funding_attached ?payout_case)
        (case_instruction_reserved ?payout_case ?payment_instruction)
        (not
          (case_instruction_authorized ?payout_case)
        )
      )
    :effect
      (and
        (case_instruction_authorized ?payout_case)
      )
  )
  (:action authorize_instruction_with_third_party_receipt
    :parameters (?payout_case - payout_case ?third_party_receipt - third_party_receipt)
    :precondition
      (and
        (case_open ?payout_case)
        (case_funding_attached ?payout_case)
        (third_party_receipt_available ?third_party_receipt)
        (not
          (case_instruction_authorized ?payout_case)
        )
      )
    :effect
      (and
        (case_instruction_authorized ?payout_case)
        (case_third_party_receipt_recorded ?payout_case)
        (not
          (third_party_receipt_available ?third_party_receipt)
        )
      )
  )
  (:action confirm_instruction_with_compliance_credential
    :parameters (?payout_case - payout_case ?payment_instruction - payment_instruction ?compliance_credential - compliance_credential)
    :precondition
      (and
        (case_instruction_authorized ?payout_case)
        (case_funding_attached ?payout_case)
        (case_instruction_reserved ?payout_case ?payment_instruction)
        (compliance_credential_available ?compliance_credential)
        (not
          (case_instruction_cleared ?payout_case)
        )
      )
    :effect
      (and
        (case_instruction_cleared ?payout_case)
        (not
          (case_third_party_receipt_recorded ?payout_case)
        )
      )
  )
  (:action confirm_instruction_via_execution_profile
    :parameters (?payout_case - payout_case ?execution_profile - execution_profile)
    :precondition
      (and
        (case_funding_attached ?payout_case)
        (case_bound_execution_profile ?payout_case ?execution_profile)
        (not
          (case_instruction_cleared ?payout_case)
        )
      )
    :effect
      (and
        (case_instruction_cleared ?payout_case)
        (not
          (case_third_party_receipt_recorded ?payout_case)
        )
      )
  )
  (:action reserve_internal_ledger_for_case
    :parameters (?payout_case - payout_case ?internal_ledger_account - internal_ledger_account)
    :precondition
      (and
        (case_open ?payout_case)
        (internal_ledger_available ?internal_ledger_account)
        (case_internal_ledger_compatible ?payout_case ?internal_ledger_account)
      )
    :effect
      (and
        (case_internal_ledger_reserved ?payout_case ?internal_ledger_account)
        (not
          (internal_ledger_available ?internal_ledger_account)
        )
      )
  )
  (:action release_internal_ledger_from_case
    :parameters (?payout_case - payout_case ?internal_ledger_account - internal_ledger_account)
    :precondition
      (and
        (case_internal_ledger_reserved ?payout_case ?internal_ledger_account)
      )
    :effect
      (and
        (internal_ledger_available ?internal_ledger_account)
        (not
          (case_internal_ledger_reserved ?payout_case ?internal_ledger_account)
        )
      )
  )
  (:action reserve_beneficiary_account_for_case
    :parameters (?payout_case - payout_case ?beneficiary_account - beneficiary_account)
    :precondition
      (and
        (case_open ?payout_case)
        (beneficiary_account_available ?beneficiary_account)
        (case_beneficiary_compatible ?payout_case ?beneficiary_account)
      )
    :effect
      (and
        (case_beneficiary_reserved ?payout_case ?beneficiary_account)
        (not
          (beneficiary_account_available ?beneficiary_account)
        )
      )
  )
  (:action release_beneficiary_account_from_case
    :parameters (?payout_case - payout_case ?beneficiary_account - beneficiary_account)
    :precondition
      (and
        (case_beneficiary_reserved ?payout_case ?beneficiary_account)
      )
    :effect
      (and
        (beneficiary_account_available ?beneficiary_account)
        (not
          (case_beneficiary_reserved ?payout_case ?beneficiary_account)
        )
      )
  )
  (:action reserve_external_liquidity_for_case
    :parameters (?payout_case - payout_case ?external_liquidity_pool - external_liquidity_pool)
    :precondition
      (and
        (case_open ?payout_case)
        (external_liquidity_available ?external_liquidity_pool)
        (case_external_liquidity_compatible ?payout_case ?external_liquidity_pool)
      )
    :effect
      (and
        (case_external_liquidity_reserved ?payout_case ?external_liquidity_pool)
        (not
          (external_liquidity_available ?external_liquidity_pool)
        )
      )
  )
  (:action release_external_liquidity_from_case
    :parameters (?payout_case - payout_case ?external_liquidity_pool - external_liquidity_pool)
    :precondition
      (and
        (case_external_liquidity_reserved ?payout_case ?external_liquidity_pool)
      )
    :effect
      (and
        (external_liquidity_available ?external_liquidity_pool)
        (not
          (case_external_liquidity_reserved ?payout_case ?external_liquidity_pool)
        )
      )
  )
  (:action reserve_alternative_rail_option_for_case
    :parameters (?payout_case - payout_case ?alternative_rail_option - alternative_rail_option)
    :precondition
      (and
        (case_open ?payout_case)
        (alternative_rail_option_available ?alternative_rail_option)
        (case_alternative_rail_compatible ?payout_case ?alternative_rail_option)
      )
    :effect
      (and
        (case_alternative_rail_reserved ?payout_case ?alternative_rail_option)
        (not
          (alternative_rail_option_available ?alternative_rail_option)
        )
      )
  )
  (:action release_alternative_rail_option_from_case
    :parameters (?payout_case - payout_case ?alternative_rail_option - alternative_rail_option)
    :precondition
      (and
        (case_alternative_rail_reserved ?payout_case ?alternative_rail_option)
      )
    :effect
      (and
        (alternative_rail_option_available ?alternative_rail_option)
        (not
          (case_alternative_rail_reserved ?payout_case ?alternative_rail_option)
        )
      )
  )
  (:action plan_execution_with_settlement_rail
    :parameters (?payout_case - payout_case ?settlement_rail - settlement_rail ?internal_ledger_account - internal_ledger_account ?beneficiary_account - beneficiary_account)
    :precondition
      (and
        (case_funding_attached ?payout_case)
        (case_internal_ledger_reserved ?payout_case ?internal_ledger_account)
        (case_beneficiary_reserved ?payout_case ?beneficiary_account)
        (settlement_rail_available ?settlement_rail)
        (case_rail_compatible ?payout_case ?settlement_rail)
        (not
          (case_execution_planned ?payout_case)
        )
      )
    :effect
      (and
        (case_selected_settlement_rail ?payout_case ?settlement_rail)
        (case_execution_planned ?payout_case)
        (not
          (settlement_rail_available ?settlement_rail)
        )
      )
  )
  (:action plan_execution_with_clearing_pathway
    :parameters (?payout_case - payout_case ?settlement_rail - settlement_rail ?external_liquidity_pool - external_liquidity_pool ?clearing_reference - clearing_reference)
    :precondition
      (and
        (case_funding_attached ?payout_case)
        (case_external_liquidity_reserved ?payout_case ?external_liquidity_pool)
        (clearing_reference_available ?clearing_reference)
        (settlement_rail_available ?settlement_rail)
        (case_rail_compatible ?payout_case ?settlement_rail)
        (case_clearing_reference_compatible ?payout_case ?clearing_reference)
        (not
          (case_execution_planned ?payout_case)
        )
      )
    :effect
      (and
        (case_selected_settlement_rail ?payout_case ?settlement_rail)
        (case_execution_planned ?payout_case)
        (case_requires_reconciliation ?payout_case)
        (case_third_party_receipt_recorded ?payout_case)
        (not
          (settlement_rail_available ?settlement_rail)
        )
        (not
          (clearing_reference_available ?clearing_reference)
        )
      )
  )
  (:action apply_settlement_policies_to_case
    :parameters (?payout_case - payout_case ?internal_ledger_account - internal_ledger_account ?beneficiary_account - beneficiary_account)
    :precondition
      (and
        (case_execution_planned ?payout_case)
        (case_requires_reconciliation ?payout_case)
        (case_internal_ledger_reserved ?payout_case ?internal_ledger_account)
        (case_beneficiary_reserved ?payout_case ?beneficiary_account)
      )
    :effect
      (and
        (not
          (case_requires_reconciliation ?payout_case)
        )
        (not
          (case_third_party_receipt_recorded ?payout_case)
        )
      )
  )
  (:action approve_and_stage_execution
    :parameters (?payout_case - payout_case ?internal_ledger_account - internal_ledger_account ?beneficiary_account - beneficiary_account ?retry_policy - retry_policy)
    :precondition
      (and
        (case_instruction_cleared ?payout_case)
        (case_execution_planned ?payout_case)
        (case_internal_ledger_reserved ?payout_case ?internal_ledger_account)
        (case_beneficiary_reserved ?payout_case ?beneficiary_account)
        (case_policy_applicable ?payout_case ?retry_policy)
        (not
          (case_third_party_receipt_recorded ?payout_case)
        )
        (not
          (case_approval_granted ?payout_case)
        )
      )
    :effect
      (and
        (case_approval_granted ?payout_case)
      )
  )
  (:action grant_approval_with_policies
    :parameters (?payout_case - payout_case ?external_liquidity_pool - external_liquidity_pool ?alternative_rail_option - alternative_rail_option ?settlement_policy - settlement_policy)
    :precondition
      (and
        (case_instruction_cleared ?payout_case)
        (case_execution_planned ?payout_case)
        (case_external_liquidity_reserved ?payout_case ?external_liquidity_pool)
        (case_alternative_rail_reserved ?payout_case ?alternative_rail_option)
        (case_policy_applicable ?payout_case ?settlement_policy)
        (not
          (case_approval_granted ?payout_case)
        )
      )
    :effect
      (and
        (case_approval_granted ?payout_case)
        (case_third_party_receipt_recorded ?payout_case)
      )
  )
  (:action commence_execution_for_case
    :parameters (?payout_case - payout_case ?internal_ledger_account - internal_ledger_account ?beneficiary_account - beneficiary_account)
    :precondition
      (and
        (case_approval_granted ?payout_case)
        (case_third_party_receipt_recorded ?payout_case)
        (case_internal_ledger_reserved ?payout_case ?internal_ledger_account)
        (case_beneficiary_reserved ?payout_case ?beneficiary_account)
      )
    :effect
      (and
        (case_execution_in_progress ?payout_case)
        (not
          (case_third_party_receipt_recorded ?payout_case)
        )
        (not
          (case_instruction_cleared ?payout_case)
        )
        (not
          (case_requires_reconciliation ?payout_case)
        )
      )
  )
  (:action reconcile_instruction_with_credential
    :parameters (?payout_case - payout_case ?payment_instruction - payment_instruction ?compliance_credential - compliance_credential)
    :precondition
      (and
        (case_execution_in_progress ?payout_case)
        (case_approval_granted ?payout_case)
        (case_funding_attached ?payout_case)
        (case_instruction_reserved ?payout_case ?payment_instruction)
        (compliance_credential_available ?compliance_credential)
        (not
          (case_instruction_cleared ?payout_case)
        )
      )
    :effect
      (and
        (case_instruction_cleared ?payout_case)
      )
  )
  (:action mark_instruction_ready_for_execution
    :parameters (?payout_case - payout_case ?payment_instruction - payment_instruction)
    :precondition
      (and
        (case_approval_granted ?payout_case)
        (case_instruction_cleared ?payout_case)
        (not
          (case_third_party_receipt_recorded ?payout_case)
        )
        (case_instruction_reserved ?payout_case ?payment_instruction)
        (not
          (case_instruction_marked_for_execution ?payout_case)
        )
      )
    :effect
      (and
        (case_instruction_marked_for_execution ?payout_case)
      )
  )
  (:action mark_instruction_ready_with_third_party_receipt
    :parameters (?payout_case - payout_case ?third_party_receipt - third_party_receipt)
    :precondition
      (and
        (case_approval_granted ?payout_case)
        (case_instruction_cleared ?payout_case)
        (not
          (case_third_party_receipt_recorded ?payout_case)
        )
        (third_party_receipt_available ?third_party_receipt)
        (not
          (case_instruction_marked_for_execution ?payout_case)
        )
      )
    :effect
      (and
        (case_instruction_marked_for_execution ?payout_case)
        (not
          (third_party_receipt_available ?third_party_receipt)
        )
      )
  )
  (:action bind_execution_profile_to_case_variant
    :parameters (?payout_case - payout_case ?execution_profile - execution_profile)
    :precondition
      (and
        (case_instruction_marked_for_execution ?payout_case)
        (execution_profile_available ?execution_profile)
        (case_execution_profile_binding ?payout_case ?execution_profile)
      )
    :effect
      (and
        (automated_variant_execution_profile ?payout_case ?execution_profile)
        (not
          (execution_profile_available ?execution_profile)
        )
      )
  )
  (:action bind_execution_profile_via_variants
    :parameters (?operator_case_variant - operator_case_variant ?automated_case_variant - automated_case_variant ?execution_profile - execution_profile)
    :precondition
      (and
        (case_open ?operator_case_variant)
        (case_has_operator_variant ?operator_case_variant)
        (operator_variant_execution_profile ?operator_case_variant ?execution_profile)
        (automated_variant_execution_profile ?automated_case_variant ?execution_profile)
        (not
          (case_bound_execution_profile ?operator_case_variant ?execution_profile)
        )
      )
    :effect
      (and
        (case_bound_execution_profile ?operator_case_variant ?execution_profile)
      )
  )
  (:action stage_case_for_execution
    :parameters (?payout_case - payout_case ?payment_instruction - payment_instruction ?compliance_credential - compliance_credential)
    :precondition
      (and
        (case_open ?payout_case)
        (case_has_operator_variant ?payout_case)
        (case_instruction_cleared ?payout_case)
        (case_instruction_marked_for_execution ?payout_case)
        (case_instruction_reserved ?payout_case ?payment_instruction)
        (compliance_credential_available ?compliance_credential)
        (not
          (case_staged_for_execution ?payout_case)
        )
      )
    :effect
      (and
        (case_staged_for_execution ?payout_case)
      )
  )
  (:action finalize_case_settlement
    :parameters (?payout_case - payout_case)
    :precondition
      (and
        (case_has_automated_variant ?payout_case)
        (case_open ?payout_case)
        (case_funding_attached ?payout_case)
        (case_execution_planned ?payout_case)
        (case_approval_granted ?payout_case)
        (case_instruction_marked_for_execution ?payout_case)
        (case_instruction_cleared ?payout_case)
        (not
          (case_finalized ?payout_case)
        )
      )
    :effect
      (and
        (case_finalized ?payout_case)
      )
  )
  (:action finalize_case_settlement_with_bound_profile
    :parameters (?payout_case - payout_case ?execution_profile - execution_profile)
    :precondition
      (and
        (case_has_operator_variant ?payout_case)
        (case_open ?payout_case)
        (case_funding_attached ?payout_case)
        (case_execution_planned ?payout_case)
        (case_approval_granted ?payout_case)
        (case_instruction_marked_for_execution ?payout_case)
        (case_instruction_cleared ?payout_case)
        (case_bound_execution_profile ?payout_case ?execution_profile)
        (not
          (case_finalized ?payout_case)
        )
      )
    :effect
      (and
        (case_finalized ?payout_case)
      )
  )
  (:action finalize_case_settlement_post_verification
    :parameters (?payout_case - payout_case)
    :precondition
      (and
        (case_has_operator_variant ?payout_case)
        (case_open ?payout_case)
        (case_funding_attached ?payout_case)
        (case_execution_planned ?payout_case)
        (case_approval_granted ?payout_case)
        (case_instruction_marked_for_execution ?payout_case)
        (case_instruction_cleared ?payout_case)
        (case_staged_for_execution ?payout_case)
        (not
          (case_finalized ?payout_case)
        )
      )
    :effect
      (and
        (case_finalized ?payout_case)
      )
  )
)

(define (domain card_dispute_payout_resolution_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types dispute_case - object payout_rail - object settlement_schedule - object acquirer_account - object liquidity_bucket - object card_network - object external_refund_account - object manual_approval_token - object payout_instruction_template - object compliance_record - object clearing_reference - object beneficiary_account - object routing_profile - object merchant_routing_profile - routing_profile issuer_routing_profile - routing_profile dispute_case_internal - dispute_case dispute_case_external - dispute_case)
  (:predicates
    (manual_approval_token_available ?manual_approval_token - manual_approval_token)
    (case_bound_acquirer_account ?dispute_case - dispute_case ?acquirer_account - acquirer_account)
    (case_authorization_finalized ?dispute_case - dispute_case)
    (case_assigned_rail ?dispute_case - dispute_case ?payout_rail - payout_rail)
    (case_routing_profile ?dispute_case - dispute_case ?routing_profile - routing_profile)
    (card_network_available ?card_network - card_network)
    (acquirer_account_available ?acquirer_account - acquirer_account)
    (case_allowed_beneficiary_account ?dispute_case - dispute_case ?beneficiary_account - beneficiary_account)
    (case_finalized ?dispute_case - dispute_case)
    (case_is_internal ?dispute_case - dispute_case)
    (case_supported_rail ?dispute_case - dispute_case ?payout_rail - payout_rail)
    (schedule_available ?settlement_schedule - settlement_schedule)
    (clearing_reference_available ?clearing_reference - clearing_reference)
    (external_refund_account_available ?external_refund_account - external_refund_account)
    (case_execution_plan_committed ?dispute_case - dispute_case)
    (case_allowed_acquirer_account ?dispute_case - dispute_case ?acquirer_account - acquirer_account)
    (case_bound_beneficiary_account ?dispute_case - dispute_case ?beneficiary_account - beneficiary_account)
    (case_scheduled_for_settlement ?dispute_case - dispute_case ?settlement_schedule - settlement_schedule)
    (case_authorization_verified ?dispute_case - dispute_case)
    (case_allowed_card_network ?dispute_case - dispute_case ?card_network - card_network)
    (beneficiary_account_available ?beneficiary_account - beneficiary_account)
    (case_is_external ?dispute_case - dispute_case)
    (case_compliance_verified ?dispute_case - dispute_case)
    (case_allowed_liquidity_bucket ?dispute_case - dispute_case ?liquidity_bucket - liquidity_bucket)
    (case_reserved_liquidity ?dispute_case - dispute_case ?liquidity_bucket - liquidity_bucket)
    (clearing_required_flag ?dispute_case - dispute_case)
    (case_bound_external_refund_account ?dispute_case - dispute_case ?external_refund_account - external_refund_account)
    (case_finalization_acknowledged ?dispute_case - dispute_case)
    (case_allowed_clearing_reference ?dispute_case - dispute_case ?clearing_reference - clearing_reference)
    (case_registered ?dispute_case - dispute_case)
    (payout_rail_available ?payout_rail - payout_rail)
    (case_rail_allocation_committed ?dispute_case - dispute_case)
    (compliance_record_available ?compliance_record - compliance_record)
    (template_available ?payout_instruction_template - payout_instruction_template)
    (case_bound_card_network ?dispute_case - dispute_case ?card_network - card_network)
    (case_internal_case_template_bound ?dispute_case - dispute_case ?payout_instruction_template - payout_instruction_template)
    (case_refund_account_confirmed ?dispute_case - dispute_case)
    (case_refund_account_finalized ?dispute_case - dispute_case)
    (internal_case_template_applicable ?dispute_case - dispute_case ?payout_instruction_template - payout_instruction_template)
    (liquidity_bucket_available ?liquidity_bucket - liquidity_bucket)
    (case_template_link_external ?dispute_case - dispute_case ?payout_instruction_template - payout_instruction_template)
    (case_supported_schedule ?dispute_case - dispute_case ?settlement_schedule - settlement_schedule)
    (case_approval_token_present ?dispute_case - dispute_case)
    (case_template_binding_confirmed ?dispute_case - dispute_case ?payout_instruction_template - payout_instruction_template)
  )
  (:action release_beneficiary_account
    :parameters (?dispute_case - dispute_case ?beneficiary_account - beneficiary_account)
    :precondition
      (and
        (case_bound_beneficiary_account ?dispute_case ?beneficiary_account)
      )
    :effect
      (and
        (beneficiary_account_available ?beneficiary_account)
        (not
          (case_bound_beneficiary_account ?dispute_case ?beneficiary_account)
        )
      )
  )
  (:action compute_authorization_with_routing
    :parameters (?dispute_case - dispute_case ?card_network - card_network ?beneficiary_account - beneficiary_account ?issuer_routing_profile - issuer_routing_profile)
    :precondition
      (and
        (not
          (case_authorization_verified ?dispute_case)
        )
        (case_execution_plan_committed ?dispute_case)
        (case_compliance_verified ?dispute_case)
        (case_bound_beneficiary_account ?dispute_case ?beneficiary_account)
        (case_routing_profile ?dispute_case ?issuer_routing_profile)
        (case_bound_card_network ?dispute_case ?card_network)
      )
    :effect
      (and
        (case_approval_token_present ?dispute_case)
        (case_authorization_verified ?dispute_case)
      )
  )
  (:action finalize_settlement
    :parameters (?dispute_case - dispute_case)
    :precondition
      (and
        (case_compliance_verified ?dispute_case)
        (case_rail_allocation_committed ?dispute_case)
        (case_execution_plan_committed ?dispute_case)
        (case_registered ?dispute_case)
        (case_refund_account_finalized ?dispute_case)
        (not
          (case_finalized ?dispute_case)
        )
        (case_is_internal ?dispute_case)
        (case_authorization_verified ?dispute_case)
      )
    :effect
      (and
        (case_finalized ?dispute_case)
      )
  )
  (:action reconcile_execution_plan
    :parameters (?dispute_case - dispute_case ?liquidity_bucket - liquidity_bucket ?acquirer_account - acquirer_account)
    :precondition
      (and
        (case_execution_plan_committed ?dispute_case)
        (clearing_required_flag ?dispute_case)
        (case_reserved_liquidity ?dispute_case ?liquidity_bucket)
        (case_bound_acquirer_account ?dispute_case ?acquirer_account)
      )
    :effect
      (and
        (not
          (clearing_required_flag ?dispute_case)
        )
        (not
          (case_approval_token_present ?dispute_case)
        )
      )
  )
  (:action reserve_external_refund_account
    :parameters (?dispute_case - dispute_case ?external_refund_account - external_refund_account)
    :precondition
      (and
        (external_refund_account_available ?external_refund_account)
        (case_registered ?dispute_case)
      )
    :effect
      (and
        (not
          (external_refund_account_available ?external_refund_account)
        )
        (case_bound_external_refund_account ?dispute_case ?external_refund_account)
      )
  )
  (:action compute_authorization
    :parameters (?dispute_case - dispute_case ?liquidity_bucket - liquidity_bucket ?acquirer_account - acquirer_account ?merchant_routing_profile - merchant_routing_profile)
    :precondition
      (and
        (case_routing_profile ?dispute_case ?merchant_routing_profile)
        (case_compliance_verified ?dispute_case)
        (not
          (case_approval_token_present ?dispute_case)
        )
        (case_reserved_liquidity ?dispute_case ?liquidity_bucket)
        (case_execution_plan_committed ?dispute_case)
        (case_bound_acquirer_account ?dispute_case ?acquirer_account)
        (not
          (case_authorization_verified ?dispute_case)
        )
      )
    :effect
      (and
        (case_authorization_verified ?dispute_case)
      )
  )
  (:action verify_compliance_using_template
    :parameters (?dispute_case - dispute_case ?payout_instruction_template - payout_instruction_template)
    :precondition
      (and
        (case_rail_allocation_committed ?dispute_case)
        (case_template_binding_confirmed ?dispute_case ?payout_instruction_template)
        (not
          (case_compliance_verified ?dispute_case)
        )
      )
    :effect
      (and
        (case_compliance_verified ?dispute_case)
        (not
          (case_approval_token_present ?dispute_case)
        )
      )
  )
  (:action bind_card_network
    :parameters (?dispute_case - dispute_case ?card_network - card_network)
    :precondition
      (and
        (case_allowed_card_network ?dispute_case ?card_network)
        (case_registered ?dispute_case)
        (card_network_available ?card_network)
      )
    :effect
      (and
        (case_bound_card_network ?dispute_case ?card_network)
        (not
          (card_network_available ?card_network)
        )
      )
  )
  (:action reserve_liquidity_bucket
    :parameters (?dispute_case - dispute_case ?liquidity_bucket - liquidity_bucket)
    :precondition
      (and
        (case_registered ?dispute_case)
        (liquidity_bucket_available ?liquidity_bucket)
        (case_allowed_liquidity_bucket ?dispute_case ?liquidity_bucket)
      )
    :effect
      (and
        (not
          (liquidity_bucket_available ?liquidity_bucket)
        )
        (case_reserved_liquidity ?dispute_case ?liquidity_bucket)
      )
  )
  (:action release_card_network
    :parameters (?dispute_case - dispute_case ?card_network - card_network)
    :precondition
      (and
        (case_bound_card_network ?dispute_case ?card_network)
      )
    :effect
      (and
        (card_network_available ?card_network)
        (not
          (case_bound_card_network ?dispute_case ?card_network)
        )
      )
  )
  (:action release_acquirer_account
    :parameters (?dispute_case - dispute_case ?acquirer_account - acquirer_account)
    :precondition
      (and
        (case_bound_acquirer_account ?dispute_case ?acquirer_account)
      )
    :effect
      (and
        (acquirer_account_available ?acquirer_account)
        (not
          (case_bound_acquirer_account ?dispute_case ?acquirer_account)
        )
      )
  )
  (:action bind_template_to_case
    :parameters (?dispute_case - dispute_case ?payout_instruction_template - payout_instruction_template)
    :precondition
      (and
        (case_refund_account_finalized ?dispute_case)
        (template_available ?payout_instruction_template)
        (internal_case_template_applicable ?dispute_case ?payout_instruction_template)
      )
    :effect
      (and
        (case_internal_case_template_bound ?dispute_case ?payout_instruction_template)
        (not
          (template_available ?payout_instruction_template)
        )
      )
  )
  (:action bind_acquirer_account
    :parameters (?dispute_case - dispute_case ?acquirer_account - acquirer_account)
    :precondition
      (and
        (case_registered ?dispute_case)
        (acquirer_account_available ?acquirer_account)
        (case_allowed_acquirer_account ?dispute_case ?acquirer_account)
      )
    :effect
      (and
        (case_bound_acquirer_account ?dispute_case ?acquirer_account)
        (not
          (acquirer_account_available ?acquirer_account)
        )
      )
  )
  (:action prepare_settlement_schedule
    :parameters (?dispute_case - dispute_case ?settlement_schedule - settlement_schedule ?liquidity_bucket - liquidity_bucket ?acquirer_account - acquirer_account)
    :precondition
      (and
        (case_rail_allocation_committed ?dispute_case)
        (schedule_available ?settlement_schedule)
        (case_supported_schedule ?dispute_case ?settlement_schedule)
        (not
          (case_execution_plan_committed ?dispute_case)
        )
        (case_bound_acquirer_account ?dispute_case ?acquirer_account)
        (case_reserved_liquidity ?dispute_case ?liquidity_bucket)
      )
    :effect
      (and
        (case_scheduled_for_settlement ?dispute_case ?settlement_schedule)
        (not
          (schedule_available ?settlement_schedule)
        )
        (case_execution_plan_committed ?dispute_case)
      )
  )
  (:action finalize_authorization
    :parameters (?dispute_case - dispute_case ?liquidity_bucket - liquidity_bucket ?acquirer_account - acquirer_account)
    :precondition
      (and
        (case_reserved_liquidity ?dispute_case ?liquidity_bucket)
        (case_authorization_verified ?dispute_case)
        (case_bound_acquirer_account ?dispute_case ?acquirer_account)
        (case_approval_token_present ?dispute_case)
      )
    :effect
      (and
        (not
          (clearing_required_flag ?dispute_case)
        )
        (not
          (case_approval_token_present ?dispute_case)
        )
        (not
          (case_compliance_verified ?dispute_case)
        )
        (case_authorization_finalized ?dispute_case)
      )
  )
  (:action release_external_refund_account
    :parameters (?dispute_case - dispute_case ?external_refund_account - external_refund_account)
    :precondition
      (and
        (case_bound_external_refund_account ?dispute_case ?external_refund_account)
      )
    :effect
      (and
        (external_refund_account_available ?external_refund_account)
        (not
          (case_bound_external_refund_account ?dispute_case ?external_refund_account)
        )
      )
  )
  (:action apply_compliance_record
    :parameters (?dispute_case - dispute_case ?external_refund_account - external_refund_account ?compliance_record - compliance_record)
    :precondition
      (and
        (not
          (case_compliance_verified ?dispute_case)
        )
        (case_rail_allocation_committed ?dispute_case)
        (compliance_record_available ?compliance_record)
        (case_bound_external_refund_account ?dispute_case ?external_refund_account)
        (case_refund_account_confirmed ?dispute_case)
      )
    :effect
      (and
        (not
          (case_approval_token_present ?dispute_case)
        )
        (case_compliance_verified ?dispute_case)
      )
  )
  (:action finalize_settlement_with_acknowledgement
    :parameters (?dispute_case - dispute_case)
    :precondition
      (and
        (case_registered ?dispute_case)
        (case_is_external ?dispute_case)
        (case_finalization_acknowledged ?dispute_case)
        (case_rail_allocation_committed ?dispute_case)
        (case_compliance_verified ?dispute_case)
        (not
          (case_finalized ?dispute_case)
        )
        (case_refund_account_finalized ?dispute_case)
        (case_execution_plan_committed ?dispute_case)
        (case_authorization_verified ?dispute_case)
      )
    :effect
      (and
        (case_finalized ?dispute_case)
      )
  )
  (:action acknowledge_finalization
    :parameters (?dispute_case - dispute_case ?external_refund_account - external_refund_account ?compliance_record - compliance_record)
    :precondition
      (and
        (case_compliance_verified ?dispute_case)
        (compliance_record_available ?compliance_record)
        (not
          (case_finalization_acknowledged ?dispute_case)
        )
        (case_refund_account_finalized ?dispute_case)
        (case_registered ?dispute_case)
        (case_is_external ?dispute_case)
        (case_bound_external_refund_account ?dispute_case ?external_refund_account)
      )
    :effect
      (and
        (case_finalization_acknowledged ?dispute_case)
      )
  )
  (:action release_liquidity_bucket
    :parameters (?dispute_case - dispute_case ?liquidity_bucket - liquidity_bucket)
    :precondition
      (and
        (case_reserved_liquidity ?dispute_case ?liquidity_bucket)
      )
    :effect
      (and
        (liquidity_bucket_available ?liquidity_bucket)
        (not
          (case_reserved_liquidity ?dispute_case ?liquidity_bucket)
        )
      )
  )
  (:action bind_beneficiary_account
    :parameters (?dispute_case - dispute_case ?beneficiary_account - beneficiary_account)
    :precondition
      (and
        (beneficiary_account_available ?beneficiary_account)
        (case_registered ?dispute_case)
        (case_allowed_beneficiary_account ?dispute_case ?beneficiary_account)
      )
    :effect
      (and
        (case_bound_beneficiary_account ?dispute_case ?beneficiary_account)
        (not
          (beneficiary_account_available ?beneficiary_account)
        )
      )
  )
  (:action register_dispute_case
    :parameters (?dispute_case - dispute_case)
    :precondition
      (and
        (not
          (case_registered ?dispute_case)
        )
        (not
          (case_finalized ?dispute_case)
        )
      )
    :effect
      (and
        (case_registered ?dispute_case)
      )
  )
  (:action consume_manual_approval_token
    :parameters (?dispute_case - dispute_case ?manual_approval_token - manual_approval_token)
    :precondition
      (and
        (not
          (case_refund_account_confirmed ?dispute_case)
        )
        (case_registered ?dispute_case)
        (manual_approval_token_available ?manual_approval_token)
        (case_rail_allocation_committed ?dispute_case)
      )
    :effect
      (and
        (case_approval_token_present ?dispute_case)
        (not
          (manual_approval_token_available ?manual_approval_token)
        )
        (case_refund_account_confirmed ?dispute_case)
      )
  )
  (:action prepare_settlement_schedule_with_clearing
    :parameters (?dispute_case - dispute_case ?settlement_schedule - settlement_schedule ?card_network - card_network ?clearing_reference - clearing_reference)
    :precondition
      (and
        (clearing_reference_available ?clearing_reference)
        (case_allowed_clearing_reference ?dispute_case ?clearing_reference)
        (not
          (case_execution_plan_committed ?dispute_case)
        )
        (case_rail_allocation_committed ?dispute_case)
        (schedule_available ?settlement_schedule)
        (case_supported_schedule ?dispute_case ?settlement_schedule)
        (case_bound_card_network ?dispute_case ?card_network)
      )
    :effect
      (and
        (case_scheduled_for_settlement ?dispute_case ?settlement_schedule)
        (not
          (clearing_reference_available ?clearing_reference)
        )
        (clearing_required_flag ?dispute_case)
        (not
          (schedule_available ?settlement_schedule)
        )
        (case_approval_token_present ?dispute_case)
        (case_execution_plan_committed ?dispute_case)
      )
  )
  (:action consume_manual_token_and_mark_final
    :parameters (?dispute_case - dispute_case ?manual_approval_token - manual_approval_token)
    :precondition
      (and
        (manual_approval_token_available ?manual_approval_token)
        (not
          (case_approval_token_present ?dispute_case)
        )
        (case_compliance_verified ?dispute_case)
        (case_authorization_verified ?dispute_case)
        (not
          (case_refund_account_finalized ?dispute_case)
        )
      )
    :effect
      (and
        (case_refund_account_finalized ?dispute_case)
        (not
          (manual_approval_token_available ?manual_approval_token)
        )
      )
  )
  (:action release_payout_rail
    :parameters (?dispute_case - dispute_case ?payout_rail - payout_rail)
    :precondition
      (and
        (case_assigned_rail ?dispute_case ?payout_rail)
        (not
          (case_authorization_verified ?dispute_case)
        )
        (not
          (case_execution_plan_committed ?dispute_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned_rail ?dispute_case ?payout_rail)
        )
        (payout_rail_available ?payout_rail)
        (not
          (case_rail_allocation_committed ?dispute_case)
        )
        (not
          (case_refund_account_confirmed ?dispute_case)
        )
        (not
          (case_authorization_finalized ?dispute_case)
        )
        (not
          (case_compliance_verified ?dispute_case)
        )
        (not
          (clearing_required_flag ?dispute_case)
        )
        (not
          (case_approval_token_present ?dispute_case)
        )
      )
  )
  (:action mark_refund_account_finalized
    :parameters (?dispute_case - dispute_case ?external_refund_account - external_refund_account)
    :precondition
      (and
        (not
          (case_refund_account_finalized ?dispute_case)
        )
        (case_bound_external_refund_account ?dispute_case ?external_refund_account)
        (case_compliance_verified ?dispute_case)
        (case_authorization_verified ?dispute_case)
        (not
          (case_approval_token_present ?dispute_case)
        )
      )
    :effect
      (and
        (case_refund_account_finalized ?dispute_case)
      )
  )
  (:action finalize_settlement_with_template_binding
    :parameters (?dispute_case - dispute_case ?payout_instruction_template - payout_instruction_template)
    :precondition
      (and
        (case_refund_account_finalized ?dispute_case)
        (case_authorization_verified ?dispute_case)
        (case_execution_plan_committed ?dispute_case)
        (case_template_binding_confirmed ?dispute_case ?payout_instruction_template)
        (case_compliance_verified ?dispute_case)
        (case_rail_allocation_committed ?dispute_case)
        (case_registered ?dispute_case)
        (not
          (case_finalized ?dispute_case)
        )
        (case_is_external ?dispute_case)
      )
    :effect
      (and
        (case_finalized ?dispute_case)
      )
  )
  (:action confirm_refund_account_binding
    :parameters (?dispute_case - dispute_case ?external_refund_account - external_refund_account)
    :precondition
      (and
        (case_registered ?dispute_case)
        (case_rail_allocation_committed ?dispute_case)
        (not
          (case_refund_account_confirmed ?dispute_case)
        )
        (case_bound_external_refund_account ?dispute_case ?external_refund_account)
      )
    :effect
      (and
        (case_refund_account_confirmed ?dispute_case)
      )
  )
  (:action assign_payout_rail
    :parameters (?dispute_case - dispute_case ?payout_rail - payout_rail)
    :precondition
      (and
        (not
          (case_rail_allocation_committed ?dispute_case)
        )
        (case_registered ?dispute_case)
        (payout_rail_available ?payout_rail)
        (case_supported_rail ?dispute_case ?payout_rail)
      )
    :effect
      (and
        (case_rail_allocation_committed ?dispute_case)
        (not
          (payout_rail_available ?payout_rail)
        )
        (case_assigned_rail ?dispute_case ?payout_rail)
      )
  )
  (:action apply_compliance_and_confirm
    :parameters (?dispute_case - dispute_case ?external_refund_account - external_refund_account ?compliance_record - compliance_record)
    :precondition
      (and
        (case_rail_allocation_committed ?dispute_case)
        (not
          (case_compliance_verified ?dispute_case)
        )
        (case_bound_external_refund_account ?dispute_case ?external_refund_account)
        (case_authorization_verified ?dispute_case)
        (compliance_record_available ?compliance_record)
        (case_authorization_finalized ?dispute_case)
      )
    :effect
      (and
        (case_compliance_verified ?dispute_case)
      )
  )
  (:action confirm_template_binding
    :parameters (?external_case_id - dispute_case_external ?internal_case_id - dispute_case_internal ?payout_instruction_template - payout_instruction_template)
    :precondition
      (and
        (case_registered ?external_case_id)
        (case_internal_case_template_bound ?internal_case_id ?payout_instruction_template)
        (case_is_external ?external_case_id)
        (not
          (case_template_binding_confirmed ?external_case_id ?payout_instruction_template)
        )
        (case_template_link_external ?external_case_id ?payout_instruction_template)
      )
    :effect
      (and
        (case_template_binding_confirmed ?external_case_id ?payout_instruction_template)
      )
  )
)

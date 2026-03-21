(define (domain rtp_fallback_channel_switching_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types payment_case - object funding_rail_option - object settlement_rail_option - object beneficiary_endpoint - object payer_funding_account - object correspondent_bank - object immediate_payment_channel - object non_instant_switch_service - object settlement_window - object authentication_credential - object liquidity_reserve_token - object alternative_network - object routing_policy - object timeout_profile - routing_policy retry_policy - routing_policy originating_payment_case - payment_case beneficiary_payment_case - payment_case)
  (:predicates
    (non_instant_switch_available ?non_instant_switch - non_instant_switch_service)
    (beneficiary_endpoint_reserved ?payment_case - payment_case ?beneficiary_endpoint - beneficiary_endpoint)
    (execution_committed ?payment_case - payment_case)
    (funding_assigned ?payment_case - payment_case ?funding_rail - funding_rail_option)
    (routing_policy_association ?payment_case - payment_case ?routing_policy_bucket - routing_policy)
    (correspondent_available ?correspondent_bank - correspondent_bank)
    (beneficiary_endpoint_available ?beneficiary_endpoint - beneficiary_endpoint)
    (alternative_network_compatible ?payment_case - payment_case ?alternative_network - alternative_network)
    (settlement_committed ?payment_case - payment_case)
    (is_originating_case ?payment_case - payment_case)
    (funding_compatible ?payment_case - payment_case ?funding_rail - funding_rail_option)
    (settlement_rail_available ?settlement_rail - settlement_rail_option)
    (liquidity_reserve_available ?liquidity_reserve - liquidity_reserve_token)
    (immediate_channel_available ?immediate_channel - immediate_payment_channel)
    (settlement_allocated ?payment_case - payment_case)
    (beneficiary_endpoint_compatible ?payment_case - payment_case ?beneficiary_endpoint - beneficiary_endpoint)
    (alternative_network_reserved ?payment_case - payment_case ?alternative_network - alternative_network)
    (settlement_rail_committed ?payment_case - payment_case ?settlement_rail - settlement_rail_option)
    (policy_approved ?payment_case - payment_case)
    (correspondent_compatible ?payment_case - payment_case ?correspondent_bank - correspondent_bank)
    (alternative_network_available ?alternative_network - alternative_network)
    (is_beneficiary_case ?payment_case - payment_case)
    (channel_authenticated ?payment_case - payment_case)
    (payer_account_compatible ?payment_case - payment_case ?payer_account - payer_funding_account)
    (payer_account_reserved ?payment_case - payment_case ?payer_account - payer_funding_account)
    (requires_additional_settlement_checks ?payment_case - payment_case)
    (immediate_channel_assigned ?payment_case - payment_case ?immediate_channel - immediate_payment_channel)
    (external_confirmation_received ?payment_case - payment_case)
    (liquidity_reserve_compatible ?payment_case - payment_case ?liquidity_reserve - liquidity_reserve_token)
    (registered ?payment_case - payment_case)
    (funding_rail_available ?funding_rail - funding_rail_option)
    (funding_reserved ?payment_case - payment_case)
    (authentication_credential_available ?credential - authentication_credential)
    (settlement_window_available ?settlement_window - settlement_window)
    (correspondent_reserved ?payment_case - payment_case ?correspondent_bank - correspondent_bank)
    (window_scheduled ?payment_case - payment_case ?settlement_window - settlement_window)
    (channel_selected ?payment_case - payment_case)
    (execution_authorized ?payment_case - payment_case)
    (window_compatible ?payment_case - payment_case ?settlement_window - settlement_window)
    (payer_account_available ?payer_account - payer_funding_account)
    (window_eligible ?payment_case - payment_case ?settlement_window - settlement_window)
    (settlement_compatible ?payment_case - payment_case ?settlement_rail - settlement_rail_option)
    (fallback_marked ?payment_case - payment_case)
    (window_bound ?payment_case - payment_case ?settlement_window - settlement_window)
  )
  (:action release_alternative_network
    :parameters (?payment_case - payment_case ?alternative_network - alternative_network)
    :precondition
      (and
        (alternative_network_reserved ?payment_case ?alternative_network)
      )
    :effect
      (and
        (alternative_network_available ?alternative_network)
        (not
          (alternative_network_reserved ?payment_case ?alternative_network)
        )
      )
  )
  (:action approve_routing_policy_with_retry
    :parameters (?payment_case - payment_case ?correspondent_bank - correspondent_bank ?alternative_network - alternative_network ?retry_policy - retry_policy)
    :precondition
      (and
        (not
          (policy_approved ?payment_case)
        )
        (settlement_allocated ?payment_case)
        (channel_authenticated ?payment_case)
        (alternative_network_reserved ?payment_case ?alternative_network)
        (routing_policy_association ?payment_case ?retry_policy)
        (correspondent_reserved ?payment_case ?correspondent_bank)
      )
    :effect
      (and
        (fallback_marked ?payment_case)
        (policy_approved ?payment_case)
      )
  )
  (:action finalize_settlement_for_case
    :parameters (?payment_case - payment_case)
    :precondition
      (and
        (channel_authenticated ?payment_case)
        (funding_reserved ?payment_case)
        (settlement_allocated ?payment_case)
        (registered ?payment_case)
        (execution_authorized ?payment_case)
        (not
          (settlement_committed ?payment_case)
        )
        (is_originating_case ?payment_case)
        (policy_approved ?payment_case)
      )
    :effect
      (and
        (settlement_committed ?payment_case)
      )
  )
  (:action clear_additional_checks
    :parameters (?payment_case - payment_case ?payer_account - payer_funding_account ?beneficiary_endpoint - beneficiary_endpoint)
    :precondition
      (and
        (settlement_allocated ?payment_case)
        (requires_additional_settlement_checks ?payment_case)
        (payer_account_reserved ?payment_case ?payer_account)
        (beneficiary_endpoint_reserved ?payment_case ?beneficiary_endpoint)
      )
    :effect
      (and
        (not
          (requires_additional_settlement_checks ?payment_case)
        )
        (not
          (fallback_marked ?payment_case)
        )
      )
  )
  (:action reserve_immediate_channel
    :parameters (?payment_case - payment_case ?immediate_channel - immediate_payment_channel)
    :precondition
      (and
        (immediate_channel_available ?immediate_channel)
        (registered ?payment_case)
      )
    :effect
      (and
        (not
          (immediate_channel_available ?immediate_channel)
        )
        (immediate_channel_assigned ?payment_case ?immediate_channel)
      )
  )
  (:action approve_routing_policy
    :parameters (?payment_case - payment_case ?payer_account - payer_funding_account ?beneficiary_endpoint - beneficiary_endpoint ?timeout_profile - timeout_profile)
    :precondition
      (and
        (routing_policy_association ?payment_case ?timeout_profile)
        (channel_authenticated ?payment_case)
        (not
          (fallback_marked ?payment_case)
        )
        (payer_account_reserved ?payment_case ?payer_account)
        (settlement_allocated ?payment_case)
        (beneficiary_endpoint_reserved ?payment_case ?beneficiary_endpoint)
        (not
          (policy_approved ?payment_case)
        )
      )
    :effect
      (and
        (policy_approved ?payment_case)
      )
  )
  (:action authenticate_for_settlement_window
    :parameters (?payment_case - payment_case ?settlement_window - settlement_window)
    :precondition
      (and
        (funding_reserved ?payment_case)
        (window_bound ?payment_case ?settlement_window)
        (not
          (channel_authenticated ?payment_case)
        )
      )
    :effect
      (and
        (channel_authenticated ?payment_case)
        (not
          (fallback_marked ?payment_case)
        )
      )
  )
  (:action reserve_correspondent_bank
    :parameters (?payment_case - payment_case ?correspondent_bank - correspondent_bank)
    :precondition
      (and
        (correspondent_compatible ?payment_case ?correspondent_bank)
        (registered ?payment_case)
        (correspondent_available ?correspondent_bank)
      )
    :effect
      (and
        (correspondent_reserved ?payment_case ?correspondent_bank)
        (not
          (correspondent_available ?correspondent_bank)
        )
      )
  )
  (:action reserve_payer_account
    :parameters (?payment_case - payment_case ?payer_account - payer_funding_account)
    :precondition
      (and
        (registered ?payment_case)
        (payer_account_available ?payer_account)
        (payer_account_compatible ?payment_case ?payer_account)
      )
    :effect
      (and
        (not
          (payer_account_available ?payer_account)
        )
        (payer_account_reserved ?payment_case ?payer_account)
      )
  )
  (:action release_correspondent_bank
    :parameters (?payment_case - payment_case ?correspondent_bank - correspondent_bank)
    :precondition
      (and
        (correspondent_reserved ?payment_case ?correspondent_bank)
      )
    :effect
      (and
        (correspondent_available ?correspondent_bank)
        (not
          (correspondent_reserved ?payment_case ?correspondent_bank)
        )
      )
  )
  (:action release_beneficiary_endpoint
    :parameters (?payment_case - payment_case ?beneficiary_endpoint - beneficiary_endpoint)
    :precondition
      (and
        (beneficiary_endpoint_reserved ?payment_case ?beneficiary_endpoint)
      )
    :effect
      (and
        (beneficiary_endpoint_available ?beneficiary_endpoint)
        (not
          (beneficiary_endpoint_reserved ?payment_case ?beneficiary_endpoint)
        )
      )
  )
  (:action schedule_case_for_window
    :parameters (?payment_case - payment_case ?settlement_window - settlement_window)
    :precondition
      (and
        (execution_authorized ?payment_case)
        (settlement_window_available ?settlement_window)
        (window_compatible ?payment_case ?settlement_window)
      )
    :effect
      (and
        (window_scheduled ?payment_case ?settlement_window)
        (not
          (settlement_window_available ?settlement_window)
        )
      )
  )
  (:action reserve_beneficiary_endpoint
    :parameters (?payment_case - payment_case ?beneficiary_endpoint - beneficiary_endpoint)
    :precondition
      (and
        (registered ?payment_case)
        (beneficiary_endpoint_available ?beneficiary_endpoint)
        (beneficiary_endpoint_compatible ?payment_case ?beneficiary_endpoint)
      )
    :effect
      (and
        (beneficiary_endpoint_reserved ?payment_case ?beneficiary_endpoint)
        (not
          (beneficiary_endpoint_available ?beneficiary_endpoint)
        )
      )
  )
  (:action allocate_settlement_rail
    :parameters (?payment_case - payment_case ?settlement_rail - settlement_rail_option ?payer_account - payer_funding_account ?beneficiary_endpoint - beneficiary_endpoint)
    :precondition
      (and
        (funding_reserved ?payment_case)
        (settlement_rail_available ?settlement_rail)
        (settlement_compatible ?payment_case ?settlement_rail)
        (not
          (settlement_allocated ?payment_case)
        )
        (beneficiary_endpoint_reserved ?payment_case ?beneficiary_endpoint)
        (payer_account_reserved ?payment_case ?payer_account)
      )
    :effect
      (and
        (settlement_rail_committed ?payment_case ?settlement_rail)
        (not
          (settlement_rail_available ?settlement_rail)
        )
        (settlement_allocated ?payment_case)
      )
  )
  (:action commit_execution_ready
    :parameters (?payment_case - payment_case ?payer_account - payer_funding_account ?beneficiary_endpoint - beneficiary_endpoint)
    :precondition
      (and
        (payer_account_reserved ?payment_case ?payer_account)
        (policy_approved ?payment_case)
        (beneficiary_endpoint_reserved ?payment_case ?beneficiary_endpoint)
        (fallback_marked ?payment_case)
      )
    :effect
      (and
        (not
          (requires_additional_settlement_checks ?payment_case)
        )
        (not
          (fallback_marked ?payment_case)
        )
        (not
          (channel_authenticated ?payment_case)
        )
        (execution_committed ?payment_case)
      )
  )
  (:action release_immediate_channel
    :parameters (?payment_case - payment_case ?immediate_channel - immediate_payment_channel)
    :precondition
      (and
        (immediate_channel_assigned ?payment_case ?immediate_channel)
      )
    :effect
      (and
        (immediate_channel_available ?immediate_channel)
        (not
          (immediate_channel_assigned ?payment_case ?immediate_channel)
        )
      )
  )
  (:action authenticate_channel
    :parameters (?payment_case - payment_case ?immediate_channel - immediate_payment_channel ?credential - authentication_credential)
    :precondition
      (and
        (not
          (channel_authenticated ?payment_case)
        )
        (funding_reserved ?payment_case)
        (authentication_credential_available ?credential)
        (immediate_channel_assigned ?payment_case ?immediate_channel)
        (channel_selected ?payment_case)
      )
    :effect
      (and
        (not
          (fallback_marked ?payment_case)
        )
        (channel_authenticated ?payment_case)
      )
  )
  (:action finalize_settlement_with_confirmation
    :parameters (?payment_case - payment_case)
    :precondition
      (and
        (registered ?payment_case)
        (is_beneficiary_case ?payment_case)
        (external_confirmation_received ?payment_case)
        (funding_reserved ?payment_case)
        (channel_authenticated ?payment_case)
        (not
          (settlement_committed ?payment_case)
        )
        (execution_authorized ?payment_case)
        (settlement_allocated ?payment_case)
        (policy_approved ?payment_case)
      )
    :effect
      (and
        (settlement_committed ?payment_case)
      )
  )
  (:action confirm_external_execution
    :parameters (?payment_case - payment_case ?immediate_channel - immediate_payment_channel ?credential - authentication_credential)
    :precondition
      (and
        (channel_authenticated ?payment_case)
        (authentication_credential_available ?credential)
        (not
          (external_confirmation_received ?payment_case)
        )
        (execution_authorized ?payment_case)
        (registered ?payment_case)
        (is_beneficiary_case ?payment_case)
        (immediate_channel_assigned ?payment_case ?immediate_channel)
      )
    :effect
      (and
        (external_confirmation_received ?payment_case)
      )
  )
  (:action release_payer_account
    :parameters (?payment_case - payment_case ?payer_account - payer_funding_account)
    :precondition
      (and
        (payer_account_reserved ?payment_case ?payer_account)
      )
    :effect
      (and
        (payer_account_available ?payer_account)
        (not
          (payer_account_reserved ?payment_case ?payer_account)
        )
      )
  )
  (:action reserve_alternative_network
    :parameters (?payment_case - payment_case ?alternative_network - alternative_network)
    :precondition
      (and
        (alternative_network_available ?alternative_network)
        (registered ?payment_case)
        (alternative_network_compatible ?payment_case ?alternative_network)
      )
    :effect
      (and
        (alternative_network_reserved ?payment_case ?alternative_network)
        (not
          (alternative_network_available ?alternative_network)
        )
      )
  )
  (:action register_payment_case
    :parameters (?payment_case - payment_case)
    :precondition
      (and
        (not
          (registered ?payment_case)
        )
        (not
          (settlement_committed ?payment_case)
        )
      )
    :effect
      (and
        (registered ?payment_case)
      )
  )
  (:action select_non_instant_switch
    :parameters (?payment_case - payment_case ?non_instant_switch - non_instant_switch_service)
    :precondition
      (and
        (not
          (channel_selected ?payment_case)
        )
        (registered ?payment_case)
        (non_instant_switch_available ?non_instant_switch)
        (funding_reserved ?payment_case)
      )
    :effect
      (and
        (fallback_marked ?payment_case)
        (not
          (non_instant_switch_available ?non_instant_switch)
        )
        (channel_selected ?payment_case)
      )
  )
  (:action allocate_settlement_with_correspondent
    :parameters (?payment_case - payment_case ?settlement_rail - settlement_rail_option ?correspondent_bank - correspondent_bank ?liquidity_reserve - liquidity_reserve_token)
    :precondition
      (and
        (liquidity_reserve_available ?liquidity_reserve)
        (liquidity_reserve_compatible ?payment_case ?liquidity_reserve)
        (not
          (settlement_allocated ?payment_case)
        )
        (funding_reserved ?payment_case)
        (settlement_rail_available ?settlement_rail)
        (settlement_compatible ?payment_case ?settlement_rail)
        (correspondent_reserved ?payment_case ?correspondent_bank)
      )
    :effect
      (and
        (settlement_rail_committed ?payment_case ?settlement_rail)
        (not
          (liquidity_reserve_available ?liquidity_reserve)
        )
        (requires_additional_settlement_checks ?payment_case)
        (not
          (settlement_rail_available ?settlement_rail)
        )
        (fallback_marked ?payment_case)
        (settlement_allocated ?payment_case)
      )
  )
  (:action mark_execution_authorized_for_switch
    :parameters (?payment_case - payment_case ?non_instant_switch - non_instant_switch_service)
    :precondition
      (and
        (non_instant_switch_available ?non_instant_switch)
        (not
          (fallback_marked ?payment_case)
        )
        (channel_authenticated ?payment_case)
        (policy_approved ?payment_case)
        (not
          (execution_authorized ?payment_case)
        )
      )
    :effect
      (and
        (execution_authorized ?payment_case)
        (not
          (non_instant_switch_available ?non_instant_switch)
        )
      )
  )
  (:action release_funding_rail
    :parameters (?payment_case - payment_case ?funding_rail - funding_rail_option)
    :precondition
      (and
        (funding_assigned ?payment_case ?funding_rail)
        (not
          (policy_approved ?payment_case)
        )
        (not
          (settlement_allocated ?payment_case)
        )
      )
    :effect
      (and
        (not
          (funding_assigned ?payment_case ?funding_rail)
        )
        (funding_rail_available ?funding_rail)
        (not
          (funding_reserved ?payment_case)
        )
        (not
          (channel_selected ?payment_case)
        )
        (not
          (execution_committed ?payment_case)
        )
        (not
          (channel_authenticated ?payment_case)
        )
        (not
          (requires_additional_settlement_checks ?payment_case)
        )
        (not
          (fallback_marked ?payment_case)
        )
      )
  )
  (:action mark_execution_authorized_for_channel
    :parameters (?payment_case - payment_case ?immediate_channel - immediate_payment_channel)
    :precondition
      (and
        (not
          (execution_authorized ?payment_case)
        )
        (immediate_channel_assigned ?payment_case ?immediate_channel)
        (channel_authenticated ?payment_case)
        (policy_approved ?payment_case)
        (not
          (fallback_marked ?payment_case)
        )
      )
    :effect
      (and
        (execution_authorized ?payment_case)
      )
  )
  (:action finalize_settlement_with_window
    :parameters (?payment_case - payment_case ?settlement_window - settlement_window)
    :precondition
      (and
        (execution_authorized ?payment_case)
        (policy_approved ?payment_case)
        (settlement_allocated ?payment_case)
        (window_bound ?payment_case ?settlement_window)
        (channel_authenticated ?payment_case)
        (funding_reserved ?payment_case)
        (registered ?payment_case)
        (not
          (settlement_committed ?payment_case)
        )
        (is_beneficiary_case ?payment_case)
      )
    :effect
      (and
        (settlement_committed ?payment_case)
      )
  )
  (:action select_immediate_channel
    :parameters (?payment_case - payment_case ?immediate_channel - immediate_payment_channel)
    :precondition
      (and
        (registered ?payment_case)
        (funding_reserved ?payment_case)
        (not
          (channel_selected ?payment_case)
        )
        (immediate_channel_assigned ?payment_case ?immediate_channel)
      )
    :effect
      (and
        (channel_selected ?payment_case)
      )
  )
  (:action assign_funding_rail
    :parameters (?payment_case - payment_case ?funding_rail - funding_rail_option)
    :precondition
      (and
        (not
          (funding_reserved ?payment_case)
        )
        (registered ?payment_case)
        (funding_rail_available ?funding_rail)
        (funding_compatible ?payment_case ?funding_rail)
      )
    :effect
      (and
        (funding_reserved ?payment_case)
        (not
          (funding_rail_available ?funding_rail)
        )
        (funding_assigned ?payment_case ?funding_rail)
      )
  )
  (:action authenticate_and_prepare_channel
    :parameters (?payment_case - payment_case ?immediate_channel - immediate_payment_channel ?credential - authentication_credential)
    :precondition
      (and
        (funding_reserved ?payment_case)
        (not
          (channel_authenticated ?payment_case)
        )
        (immediate_channel_assigned ?payment_case ?immediate_channel)
        (policy_approved ?payment_case)
        (authentication_credential_available ?credential)
        (execution_committed ?payment_case)
      )
    :effect
      (and
        (channel_authenticated ?payment_case)
      )
  )
  (:action bind_window_for_beneficiary_and_origin
    :parameters (?beneficiary_case - beneficiary_payment_case ?originating_case - originating_payment_case ?settlement_window - settlement_window)
    :precondition
      (and
        (registered ?beneficiary_case)
        (window_scheduled ?originating_case ?settlement_window)
        (is_beneficiary_case ?beneficiary_case)
        (not
          (window_bound ?beneficiary_case ?settlement_window)
        )
        (window_eligible ?beneficiary_case ?settlement_window)
      )
    :effect
      (and
        (window_bound ?beneficiary_case ?settlement_window)
      )
  )
)

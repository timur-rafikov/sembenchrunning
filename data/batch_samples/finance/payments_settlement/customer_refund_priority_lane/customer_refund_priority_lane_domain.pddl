(define (domain payments_refund_priority_lane_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object refund_case - entity source_account - entity currency - entity payment_rail - entity liquidity_bucket - entity settlement_service - entity payment_gateway - entity external_processor - entity settlement_window - entity operator_credential - entity prefund_receipt - entity payout_channel - entity routing_profile - entity priority_token - routing_profile fallback_token - routing_profile linked_refund_case - refund_case primary_refund_case - refund_case)

  (:predicates
    (case_registered ?refund_case - refund_case)
    (case_assigned_source_account ?refund_case - refund_case ?source_account - source_account)
    (case_source_account_assigned_flag ?refund_case - refund_case)
    (case_gateway_confirmed ?refund_case - refund_case)
    (case_operator_authorized ?refund_case - refund_case)
    (case_liquidity_assigned ?refund_case - refund_case ?liquidity_bucket - liquidity_bucket)
    (case_rail_assigned ?refund_case - refund_case ?payment_rail - payment_rail)
    (case_settlement_service_assigned ?refund_case - refund_case ?settlement_service - settlement_service)
    (case_payout_channel_assigned ?refund_case - refund_case ?payout_channel - payout_channel)
    (case_currency_set ?refund_case - refund_case ?currency - currency)
    (case_clearing_ready ?refund_case - refund_case)
    (case_routing_confirmed ?refund_case - refund_case)
    (case_invocation_pending ?refund_case - refund_case)
    (case_settled ?refund_case - refund_case)
    (case_processor_engagement_flag ?refund_case - refund_case)
    (case_execution_ready ?refund_case - refund_case)
    (case_settlement_window_candidate ?refund_case - refund_case ?settlement_window - settlement_window)
    (case_settlement_window_reserved ?refund_case - refund_case ?settlement_window - settlement_window)
    (case_gateway_invocation_published ?refund_case - refund_case)
    (account_available ?source_account - source_account)
    (currency_supported ?currency - currency)
    (liquidity_available ?liquidity_bucket - liquidity_bucket)
    (rail_available ?payment_rail - payment_rail)
    (settlement_service_available ?settlement_service - settlement_service)
    (gateway_available ?payment_gateway - payment_gateway)
    (processor_available ?external_processor - external_processor)
    (settlement_window_available ?settlement_window - settlement_window)
    (operator_credential_valid ?operator_credential - operator_credential)
    (prefund_receipt_valid ?prefund_receipt - prefund_receipt)
    (payout_channel_available ?payout_channel - payout_channel)
    (case_account_eligible ?refund_case - refund_case ?source_account - source_account)
    (case_currency_eligible ?refund_case - refund_case ?currency - currency)
    (case_liquidity_eligible ?refund_case - refund_case ?liquidity_bucket - liquidity_bucket)
    (case_rail_eligible ?refund_case - refund_case ?payment_rail - payment_rail)
    (case_settlement_service_eligible ?refund_case - refund_case ?settlement_service - settlement_service)
    (case_prefund_receipt_eligible ?refund_case - refund_case ?prefund_receipt - prefund_receipt)
    (case_payout_channel_eligible ?refund_case - refund_case ?payout_channel - payout_channel)
    (case_routing_profile_assigned ?refund_case - refund_case ?routing_profile - routing_profile)
    (case_linked_window_candidate ?refund_case - refund_case ?settlement_window - settlement_window)
    (case_linked_handle ?refund_case - refund_case)
    (case_primary_handle ?refund_case - refund_case)
    (case_gateway_reservation ?refund_case - refund_case ?payment_gateway - payment_gateway)
    (case_prefund_confirmed ?refund_case - refund_case)
    (case_settlement_window_allowed ?refund_case - refund_case ?settlement_window - settlement_window)
  )
  (:action initiate_refund_case
    :parameters (?refund_case - refund_case)
    :precondition
      (and
        (not
          (case_registered ?refund_case)
        )
        (not
          (case_settled ?refund_case)
        )
      )
    :effect
      (and
        (case_registered ?refund_case)
      )
  )
  (:action claim_source_account
    :parameters (?refund_case - refund_case ?source_account - source_account)
    :precondition
      (and
        (case_registered ?refund_case)
        (account_available ?source_account)
        (case_account_eligible ?refund_case ?source_account)
        (not
          (case_source_account_assigned_flag ?refund_case)
        )
      )
    :effect
      (and
        (case_assigned_source_account ?refund_case ?source_account)
        (case_source_account_assigned_flag ?refund_case)
        (not
          (account_available ?source_account)
        )
      )
  )
  (:action release_source_account
    :parameters (?refund_case - refund_case ?source_account - source_account)
    :precondition
      (and
        (case_assigned_source_account ?refund_case ?source_account)
        (not
          (case_clearing_ready ?refund_case)
        )
        (not
          (case_routing_confirmed ?refund_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned_source_account ?refund_case ?source_account)
        )
        (not
          (case_source_account_assigned_flag ?refund_case)
        )
        (not
          (case_gateway_confirmed ?refund_case)
        )
        (not
          (case_operator_authorized ?refund_case)
        )
        (not
          (case_processor_engagement_flag ?refund_case)
        )
        (not
          (case_execution_ready ?refund_case)
        )
        (not
          (case_prefund_confirmed ?refund_case)
        )
        (account_available ?source_account)
      )
  )
  (:action reserve_payment_gateway
    :parameters (?refund_case - refund_case ?payment_gateway - payment_gateway)
    :precondition
      (and
        (case_registered ?refund_case)
        (gateway_available ?payment_gateway)
      )
    :effect
      (and
        (case_gateway_reservation ?refund_case ?payment_gateway)
        (not
          (gateway_available ?payment_gateway)
        )
      )
  )
  (:action release_payment_gateway_reservation
    :parameters (?refund_case - refund_case ?payment_gateway - payment_gateway)
    :precondition
      (and
        (case_gateway_reservation ?refund_case ?payment_gateway)
      )
    :effect
      (and
        (gateway_available ?payment_gateway)
        (not
          (case_gateway_reservation ?refund_case ?payment_gateway)
        )
      )
  )
  (:action confirm_gateway_for_case
    :parameters (?refund_case - refund_case ?payment_gateway - payment_gateway)
    :precondition
      (and
        (case_registered ?refund_case)
        (case_source_account_assigned_flag ?refund_case)
        (case_gateway_reservation ?refund_case ?payment_gateway)
        (not
          (case_gateway_confirmed ?refund_case)
        )
      )
    :effect
      (and
        (case_gateway_confirmed ?refund_case)
      )
  )
  (:action onboard_external_processor
    :parameters (?refund_case - refund_case ?external_processor - external_processor)
    :precondition
      (and
        (case_registered ?refund_case)
        (case_source_account_assigned_flag ?refund_case)
        (processor_available ?external_processor)
        (not
          (case_gateway_confirmed ?refund_case)
        )
      )
    :effect
      (and
        (case_gateway_confirmed ?refund_case)
        (case_processor_engagement_flag ?refund_case)
        (not
          (processor_available ?external_processor)
        )
      )
  )
  (:action authorize_operator_for_case
    :parameters (?refund_case - refund_case ?payment_gateway - payment_gateway ?operator_credential - operator_credential)
    :precondition
      (and
        (case_gateway_confirmed ?refund_case)
        (case_source_account_assigned_flag ?refund_case)
        (case_gateway_reservation ?refund_case ?payment_gateway)
        (operator_credential_valid ?operator_credential)
        (not
          (case_operator_authorized ?refund_case)
        )
      )
    :effect
      (and
        (case_operator_authorized ?refund_case)
        (not
          (case_processor_engagement_flag ?refund_case)
        )
      )
  )
  (:action reserve_settlement_window
    :parameters (?refund_case - refund_case ?settlement_window - settlement_window)
    :precondition
      (and
        (case_source_account_assigned_flag ?refund_case)
        (case_settlement_window_reserved ?refund_case ?settlement_window)
        (not
          (case_operator_authorized ?refund_case)
        )
      )
    :effect
      (and
        (case_operator_authorized ?refund_case)
        (not
          (case_processor_engagement_flag ?refund_case)
        )
      )
  )
  (:action reserve_liquidity_bucket
    :parameters (?refund_case - refund_case ?liquidity_bucket - liquidity_bucket)
    :precondition
      (and
        (case_registered ?refund_case)
        (liquidity_available ?liquidity_bucket)
        (case_liquidity_eligible ?refund_case ?liquidity_bucket)
      )
    :effect
      (and
        (case_liquidity_assigned ?refund_case ?liquidity_bucket)
        (not
          (liquidity_available ?liquidity_bucket)
        )
      )
  )
  (:action release_liquidity_bucket
    :parameters (?refund_case - refund_case ?liquidity_bucket - liquidity_bucket)
    :precondition
      (and
        (case_liquidity_assigned ?refund_case ?liquidity_bucket)
      )
    :effect
      (and
        (liquidity_available ?liquidity_bucket)
        (not
          (case_liquidity_assigned ?refund_case ?liquidity_bucket)
        )
      )
  )
  (:action reserve_payment_rail
    :parameters (?refund_case - refund_case ?payment_rail - payment_rail)
    :precondition
      (and
        (case_registered ?refund_case)
        (rail_available ?payment_rail)
        (case_rail_eligible ?refund_case ?payment_rail)
      )
    :effect
      (and
        (case_rail_assigned ?refund_case ?payment_rail)
        (not
          (rail_available ?payment_rail)
        )
      )
  )
  (:action release_payment_rail
    :parameters (?refund_case - refund_case ?payment_rail - payment_rail)
    :precondition
      (and
        (case_rail_assigned ?refund_case ?payment_rail)
      )
    :effect
      (and
        (rail_available ?payment_rail)
        (not
          (case_rail_assigned ?refund_case ?payment_rail)
        )
      )
  )
  (:action reserve_settlement_service
    :parameters (?refund_case - refund_case ?settlement_service - settlement_service)
    :precondition
      (and
        (case_registered ?refund_case)
        (settlement_service_available ?settlement_service)
        (case_settlement_service_eligible ?refund_case ?settlement_service)
      )
    :effect
      (and
        (case_settlement_service_assigned ?refund_case ?settlement_service)
        (not
          (settlement_service_available ?settlement_service)
        )
      )
  )
  (:action release_settlement_service
    :parameters (?refund_case - refund_case ?settlement_service - settlement_service)
    :precondition
      (and
        (case_settlement_service_assigned ?refund_case ?settlement_service)
      )
    :effect
      (and
        (settlement_service_available ?settlement_service)
        (not
          (case_settlement_service_assigned ?refund_case ?settlement_service)
        )
      )
  )
  (:action reserve_payout_channel
    :parameters (?refund_case - refund_case ?payout_channel - payout_channel)
    :precondition
      (and
        (case_registered ?refund_case)
        (payout_channel_available ?payout_channel)
        (case_payout_channel_eligible ?refund_case ?payout_channel)
      )
    :effect
      (and
        (case_payout_channel_assigned ?refund_case ?payout_channel)
        (not
          (payout_channel_available ?payout_channel)
        )
      )
  )
  (:action release_payout_channel
    :parameters (?refund_case - refund_case ?payout_channel - payout_channel)
    :precondition
      (and
        (case_payout_channel_assigned ?refund_case ?payout_channel)
      )
    :effect
      (and
        (payout_channel_available ?payout_channel)
        (not
          (case_payout_channel_assigned ?refund_case ?payout_channel)
        )
      )
  )
  (:action compute_routing_and_prepare_clearing
    :parameters (?refund_case - refund_case ?currency - currency ?liquidity_bucket - liquidity_bucket ?payment_rail - payment_rail)
    :precondition
      (and
        (case_source_account_assigned_flag ?refund_case)
        (case_liquidity_assigned ?refund_case ?liquidity_bucket)
        (case_rail_assigned ?refund_case ?payment_rail)
        (currency_supported ?currency)
        (case_currency_eligible ?refund_case ?currency)
        (not
          (case_clearing_ready ?refund_case)
        )
      )
    :effect
      (and
        (case_currency_set ?refund_case ?currency)
        (case_clearing_ready ?refund_case)
        (not
          (currency_supported ?currency)
        )
      )
  )
  (:action compute_routing_with_settlement_service
    :parameters (?refund_case - refund_case ?currency - currency ?settlement_service - settlement_service ?prefund_receipt - prefund_receipt)
    :precondition
      (and
        (case_source_account_assigned_flag ?refund_case)
        (case_settlement_service_assigned ?refund_case ?settlement_service)
        (prefund_receipt_valid ?prefund_receipt)
        (currency_supported ?currency)
        (case_currency_eligible ?refund_case ?currency)
        (case_prefund_receipt_eligible ?refund_case ?prefund_receipt)
        (not
          (case_clearing_ready ?refund_case)
        )
      )
    :effect
      (and
        (case_currency_set ?refund_case ?currency)
        (case_clearing_ready ?refund_case)
        (case_prefund_confirmed ?refund_case)
        (case_processor_engagement_flag ?refund_case)
        (not
          (currency_supported ?currency)
        )
        (not
          (prefund_receipt_valid ?prefund_receipt)
        )
      )
  )
  (:action finalize_clearing_flags
    :parameters (?refund_case - refund_case ?liquidity_bucket - liquidity_bucket ?payment_rail - payment_rail)
    :precondition
      (and
        (case_clearing_ready ?refund_case)
        (case_prefund_confirmed ?refund_case)
        (case_liquidity_assigned ?refund_case ?liquidity_bucket)
        (case_rail_assigned ?refund_case ?payment_rail)
      )
    :effect
      (and
        (not
          (case_prefund_confirmed ?refund_case)
        )
        (not
          (case_processor_engagement_flag ?refund_case)
        )
      )
  )
  (:action apply_execution_priority
    :parameters (?refund_case - refund_case ?liquidity_bucket - liquidity_bucket ?payment_rail - payment_rail ?priority_token - priority_token)
    :precondition
      (and
        (case_operator_authorized ?refund_case)
        (case_clearing_ready ?refund_case)
        (case_liquidity_assigned ?refund_case ?liquidity_bucket)
        (case_rail_assigned ?refund_case ?payment_rail)
        (case_routing_profile_assigned ?refund_case ?priority_token)
        (not
          (case_processor_engagement_flag ?refund_case)
        )
        (not
          (case_routing_confirmed ?refund_case)
        )
      )
    :effect
      (and
        (case_routing_confirmed ?refund_case)
      )
  )
  (:action apply_fallback_routing
    :parameters (?refund_case - refund_case ?settlement_service - settlement_service ?payout_channel - payout_channel ?fallback_token - fallback_token)
    :precondition
      (and
        (case_operator_authorized ?refund_case)
        (case_clearing_ready ?refund_case)
        (case_settlement_service_assigned ?refund_case ?settlement_service)
        (case_payout_channel_assigned ?refund_case ?payout_channel)
        (case_routing_profile_assigned ?refund_case ?fallback_token)
        (not
          (case_routing_confirmed ?refund_case)
        )
      )
    :effect
      (and
        (case_routing_confirmed ?refund_case)
        (case_processor_engagement_flag ?refund_case)
      )
  )
  (:action transition_to_execution_ready
    :parameters (?refund_case - refund_case ?liquidity_bucket - liquidity_bucket ?payment_rail - payment_rail)
    :precondition
      (and
        (case_routing_confirmed ?refund_case)
        (case_processor_engagement_flag ?refund_case)
        (case_liquidity_assigned ?refund_case ?liquidity_bucket)
        (case_rail_assigned ?refund_case ?payment_rail)
      )
    :effect
      (and
        (case_execution_ready ?refund_case)
        (not
          (case_processor_engagement_flag ?refund_case)
        )
        (not
          (case_operator_authorized ?refund_case)
        )
        (not
          (case_prefund_confirmed ?refund_case)
        )
      )
  )
  (:action operator_authorize_for_execution
    :parameters (?refund_case - refund_case ?payment_gateway - payment_gateway ?operator_credential - operator_credential)
    :precondition
      (and
        (case_execution_ready ?refund_case)
        (case_routing_confirmed ?refund_case)
        (case_source_account_assigned_flag ?refund_case)
        (case_gateway_reservation ?refund_case ?payment_gateway)
        (operator_credential_valid ?operator_credential)
        (not
          (case_operator_authorized ?refund_case)
        )
      )
    :effect
      (and
        (case_operator_authorized ?refund_case)
      )
  )
  (:action mark_gateway_invocation_candidate
    :parameters (?refund_case - refund_case ?payment_gateway - payment_gateway)
    :precondition
      (and
        (case_routing_confirmed ?refund_case)
        (case_operator_authorized ?refund_case)
        (not
          (case_processor_engagement_flag ?refund_case)
        )
        (case_gateway_reservation ?refund_case ?payment_gateway)
        (not
          (case_invocation_pending ?refund_case)
        )
      )
    :effect
      (and
        (case_invocation_pending ?refund_case)
      )
  )
  (:action mark_processor_gateway_invocation_candidate
    :parameters (?refund_case - refund_case ?external_processor - external_processor)
    :precondition
      (and
        (case_routing_confirmed ?refund_case)
        (case_operator_authorized ?refund_case)
        (not
          (case_processor_engagement_flag ?refund_case)
        )
        (processor_available ?external_processor)
        (not
          (case_invocation_pending ?refund_case)
        )
      )
    :effect
      (and
        (case_invocation_pending ?refund_case)
        (not
          (processor_available ?external_processor)
        )
      )
  )
  (:action assign_settlement_window_for_execution
    :parameters (?refund_case - refund_case ?settlement_window - settlement_window)
    :precondition
      (and
        (case_invocation_pending ?refund_case)
        (settlement_window_available ?settlement_window)
        (case_settlement_window_allowed ?refund_case ?settlement_window)
      )
    :effect
      (and
        (case_linked_window_candidate ?refund_case ?settlement_window)
        (not
          (settlement_window_available ?settlement_window)
        )
      )
  )
  (:action reserve_linked_case_settlement_window
    :parameters (?primary_refund_case - primary_refund_case ?linked_refund_case - linked_refund_case ?settlement_window - settlement_window)
    :precondition
      (and
        (case_registered ?primary_refund_case)
        (case_primary_handle ?primary_refund_case)
        (case_settlement_window_candidate ?primary_refund_case ?settlement_window)
        (case_linked_window_candidate ?linked_refund_case ?settlement_window)
        (not
          (case_settlement_window_reserved ?primary_refund_case ?settlement_window)
        )
      )
    :effect
      (and
        (case_settlement_window_reserved ?primary_refund_case ?settlement_window)
      )
  )
  (:action publish_gateway_invocation
    :parameters (?refund_case - refund_case ?payment_gateway - payment_gateway ?operator_credential - operator_credential)
    :precondition
      (and
        (case_registered ?refund_case)
        (case_primary_handle ?refund_case)
        (case_operator_authorized ?refund_case)
        (case_invocation_pending ?refund_case)
        (case_gateway_reservation ?refund_case ?payment_gateway)
        (operator_credential_valid ?operator_credential)
        (not
          (case_gateway_invocation_published ?refund_case)
        )
      )
    :effect
      (and
        (case_gateway_invocation_published ?refund_case)
      )
  )
  (:action finalize_settlement_for_linked_case
    :parameters (?refund_case - refund_case)
    :precondition
      (and
        (case_linked_handle ?refund_case)
        (case_registered ?refund_case)
        (case_source_account_assigned_flag ?refund_case)
        (case_clearing_ready ?refund_case)
        (case_routing_confirmed ?refund_case)
        (case_invocation_pending ?refund_case)
        (case_operator_authorized ?refund_case)
        (not
          (case_settled ?refund_case)
        )
      )
    :effect
      (and
        (case_settled ?refund_case)
      )
  )
  (:action finalize_settlement_for_case_with_window
    :parameters (?refund_case - refund_case ?settlement_window - settlement_window)
    :precondition
      (and
        (case_primary_handle ?refund_case)
        (case_registered ?refund_case)
        (case_source_account_assigned_flag ?refund_case)
        (case_clearing_ready ?refund_case)
        (case_routing_confirmed ?refund_case)
        (case_invocation_pending ?refund_case)
        (case_operator_authorized ?refund_case)
        (case_settlement_window_reserved ?refund_case ?settlement_window)
        (not
          (case_settled ?refund_case)
        )
      )
    :effect
      (and
        (case_settled ?refund_case)
      )
  )
  (:action finalize_settlement_for_case_with_invocation
    :parameters (?refund_case - refund_case)
    :precondition
      (and
        (case_primary_handle ?refund_case)
        (case_registered ?refund_case)
        (case_source_account_assigned_flag ?refund_case)
        (case_clearing_ready ?refund_case)
        (case_routing_confirmed ?refund_case)
        (case_invocation_pending ?refund_case)
        (case_operator_authorized ?refund_case)
        (case_gateway_invocation_published ?refund_case)
        (not
          (case_settled ?refund_case)
        )
      )
    :effect
      (and
        (case_settled ?refund_case)
      )
  )
)

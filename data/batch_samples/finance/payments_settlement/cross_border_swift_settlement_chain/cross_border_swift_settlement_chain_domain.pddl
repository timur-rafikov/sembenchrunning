(define (domain cross_border_swift_settlement_chain_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object settlement_case - domain_object originating_ledger - domain_object settlement_rail - domain_object beneficiary_correspondent - domain_object currency - domain_object nostro_account - domain_object communication_channel - domain_object approval_token - domain_object correspondent_endpoint - domain_object validation_service - domain_object liquidity_reserve_slot - domain_object currency_route - domain_object routing_profile - domain_object routing_profile_domestic - routing_profile routing_profile_international - routing_profile outgoing_case - settlement_case incoming_case - settlement_case)

  (:predicates
    (case_registered ?settlement_case - settlement_case)
    (case_allocated_originating_ledger ?settlement_case - settlement_case ?originating_ledger - originating_ledger)
    (case_originating_ledger_allocated ?settlement_case - settlement_case)
    (case_communication_channel_ready ?settlement_case - settlement_case)
    (case_validated ?settlement_case - settlement_case)
    (case_currency_reserved ?settlement_case - settlement_case ?currency - currency)
    (case_correspondent_reserved ?settlement_case - settlement_case ?beneficiary_correspondent - beneficiary_correspondent)
    (case_nostro_reserved ?settlement_case - settlement_case ?nostro_account - nostro_account)
    (case_currency_route_assigned ?settlement_case - settlement_case ?currency_route - currency_route)
    (case_assigned_rail ?settlement_case - settlement_case ?settlement_rail - settlement_rail)
    (case_execution_scheduled ?settlement_case - settlement_case)
    (case_approval_recorded ?settlement_case - settlement_case)
    (case_ready_for_posting ?settlement_case - settlement_case)
    (case_finalized ?settlement_case - settlement_case)
    (case_approval_flag ?settlement_case - settlement_case)
    (case_authorized ?settlement_case - settlement_case)
    (incoming_case_endpoint_allowed ?settlement_case - settlement_case ?correspondent_endpoint - correspondent_endpoint)
    (incoming_case_endpoint_bound ?settlement_case - settlement_case ?correspondent_endpoint - correspondent_endpoint)
    (case_routing_confirmed ?settlement_case - settlement_case)
    (originating_ledger_available ?originating_ledger - originating_ledger)
    (settlement_rail_available ?settlement_rail - settlement_rail)
    (currency_available ?currency - currency)
    (correspondent_available ?beneficiary_correspondent - beneficiary_correspondent)
    (nostro_account_available ?nostro_account - nostro_account)
    (communication_channel_available ?communication_channel - communication_channel)
    (approval_token_available ?approval_token - approval_token)
    (correspondent_endpoint_available ?correspondent_endpoint - correspondent_endpoint)
    (validation_service_available ?validation_service - validation_service)
    (liquidity_reserve_available ?liquidity_reserve_slot - liquidity_reserve_slot)
    (currency_route_available ?currency_route - currency_route)
    (case_originating_ledger_allowed ?settlement_case - settlement_case ?originating_ledger - originating_ledger)
    (case_settlement_rail_allowed ?settlement_case - settlement_case ?settlement_rail - settlement_rail)
    (case_currency_allowed ?settlement_case - settlement_case ?currency - currency)
    (case_correspondent_allowed ?settlement_case - settlement_case ?beneficiary_correspondent - beneficiary_correspondent)
    (case_nostro_allowed ?settlement_case - settlement_case ?nostro_account - nostro_account)
    (case_liquidity_slot_allowed ?settlement_case - settlement_case ?liquidity_reserve_slot - liquidity_reserve_slot)
    (case_currency_route_allowed ?settlement_case - settlement_case ?currency_route - currency_route)
    (case_routing_profile_assigned ?settlement_case - settlement_case ?routing_profile - routing_profile)
    (outgoing_case_endpoint_bound ?settlement_case - settlement_case ?correspondent_endpoint - correspondent_endpoint)
    (case_outgoing ?settlement_case - settlement_case)
    (case_incoming ?settlement_case - settlement_case)
    (case_communication_channel_bound ?settlement_case - settlement_case ?communication_channel - communication_channel)
    (case_post_execution_flag ?settlement_case - settlement_case)
    (outgoing_case_endpoint_allowed ?settlement_case - settlement_case ?correspondent_endpoint - correspondent_endpoint)
  )
  (:action create_settlement_case
    :parameters (?settlement_case - settlement_case)
    :precondition
      (and
        (not
          (case_registered ?settlement_case)
        )
        (not
          (case_finalized ?settlement_case)
        )
      )
    :effect
      (and
        (case_registered ?settlement_case)
      )
  )
  (:action allocate_originating_ledger
    :parameters (?settlement_case - settlement_case ?originating_ledger - originating_ledger)
    :precondition
      (and
        (case_registered ?settlement_case)
        (originating_ledger_available ?originating_ledger)
        (case_originating_ledger_allowed ?settlement_case ?originating_ledger)
        (not
          (case_originating_ledger_allocated ?settlement_case)
        )
      )
    :effect
      (and
        (case_allocated_originating_ledger ?settlement_case ?originating_ledger)
        (case_originating_ledger_allocated ?settlement_case)
        (not
          (originating_ledger_available ?originating_ledger)
        )
      )
  )
  (:action release_originating_ledger
    :parameters (?settlement_case - settlement_case ?originating_ledger - originating_ledger)
    :precondition
      (and
        (case_allocated_originating_ledger ?settlement_case ?originating_ledger)
        (not
          (case_execution_scheduled ?settlement_case)
        )
        (not
          (case_approval_recorded ?settlement_case)
        )
      )
    :effect
      (and
        (not
          (case_allocated_originating_ledger ?settlement_case ?originating_ledger)
        )
        (not
          (case_originating_ledger_allocated ?settlement_case)
        )
        (not
          (case_communication_channel_ready ?settlement_case)
        )
        (not
          (case_validated ?settlement_case)
        )
        (not
          (case_approval_flag ?settlement_case)
        )
        (not
          (case_authorized ?settlement_case)
        )
        (not
          (case_post_execution_flag ?settlement_case)
        )
        (originating_ledger_available ?originating_ledger)
      )
  )
  (:action bind_communication_channel
    :parameters (?settlement_case - settlement_case ?communication_channel - communication_channel)
    :precondition
      (and
        (case_registered ?settlement_case)
        (communication_channel_available ?communication_channel)
      )
    :effect
      (and
        (case_communication_channel_bound ?settlement_case ?communication_channel)
        (not
          (communication_channel_available ?communication_channel)
        )
      )
  )
  (:action unbind_communication_channel
    :parameters (?settlement_case - settlement_case ?communication_channel - communication_channel)
    :precondition
      (and
        (case_communication_channel_bound ?settlement_case ?communication_channel)
      )
    :effect
      (and
        (communication_channel_available ?communication_channel)
        (not
          (case_communication_channel_bound ?settlement_case ?communication_channel)
        )
      )
  )
  (:action confirm_channel_binding
    :parameters (?settlement_case - settlement_case ?communication_channel - communication_channel)
    :precondition
      (and
        (case_registered ?settlement_case)
        (case_originating_ledger_allocated ?settlement_case)
        (case_communication_channel_bound ?settlement_case ?communication_channel)
        (not
          (case_communication_channel_ready ?settlement_case)
        )
      )
    :effect
      (and
        (case_communication_channel_ready ?settlement_case)
      )
  )
  (:action apply_approval_and_mark_channel
    :parameters (?settlement_case - settlement_case ?approval_token - approval_token)
    :precondition
      (and
        (case_registered ?settlement_case)
        (case_originating_ledger_allocated ?settlement_case)
        (approval_token_available ?approval_token)
        (not
          (case_communication_channel_ready ?settlement_case)
        )
      )
    :effect
      (and
        (case_communication_channel_ready ?settlement_case)
        (case_approval_flag ?settlement_case)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action run_validation_service
    :parameters (?settlement_case - settlement_case ?communication_channel - communication_channel ?validation_service - validation_service)
    :precondition
      (and
        (case_communication_channel_ready ?settlement_case)
        (case_originating_ledger_allocated ?settlement_case)
        (case_communication_channel_bound ?settlement_case ?communication_channel)
        (validation_service_available ?validation_service)
        (not
          (case_validated ?settlement_case)
        )
      )
    :effect
      (and
        (case_validated ?settlement_case)
        (not
          (case_approval_flag ?settlement_case)
        )
      )
  )
  (:action run_endpoint_validation
    :parameters (?settlement_case - settlement_case ?correspondent_endpoint - correspondent_endpoint)
    :precondition
      (and
        (case_originating_ledger_allocated ?settlement_case)
        (incoming_case_endpoint_bound ?settlement_case ?correspondent_endpoint)
        (not
          (case_validated ?settlement_case)
        )
      )
    :effect
      (and
        (case_validated ?settlement_case)
        (not
          (case_approval_flag ?settlement_case)
        )
      )
  )
  (:action reserve_currency_for_case
    :parameters (?settlement_case - settlement_case ?currency - currency)
    :precondition
      (and
        (case_registered ?settlement_case)
        (currency_available ?currency)
        (case_currency_allowed ?settlement_case ?currency)
      )
    :effect
      (and
        (case_currency_reserved ?settlement_case ?currency)
        (not
          (currency_available ?currency)
        )
      )
  )
  (:action release_currency_for_case
    :parameters (?settlement_case - settlement_case ?currency - currency)
    :precondition
      (and
        (case_currency_reserved ?settlement_case ?currency)
      )
    :effect
      (and
        (currency_available ?currency)
        (not
          (case_currency_reserved ?settlement_case ?currency)
        )
      )
  )
  (:action reserve_beneficiary_correspondent
    :parameters (?settlement_case - settlement_case ?beneficiary_correspondent - beneficiary_correspondent)
    :precondition
      (and
        (case_registered ?settlement_case)
        (correspondent_available ?beneficiary_correspondent)
        (case_correspondent_allowed ?settlement_case ?beneficiary_correspondent)
      )
    :effect
      (and
        (case_correspondent_reserved ?settlement_case ?beneficiary_correspondent)
        (not
          (correspondent_available ?beneficiary_correspondent)
        )
      )
  )
  (:action release_beneficiary_correspondent
    :parameters (?settlement_case - settlement_case ?beneficiary_correspondent - beneficiary_correspondent)
    :precondition
      (and
        (case_correspondent_reserved ?settlement_case ?beneficiary_correspondent)
      )
    :effect
      (and
        (correspondent_available ?beneficiary_correspondent)
        (not
          (case_correspondent_reserved ?settlement_case ?beneficiary_correspondent)
        )
      )
  )
  (:action reserve_nostro_account
    :parameters (?settlement_case - settlement_case ?nostro_account - nostro_account)
    :precondition
      (and
        (case_registered ?settlement_case)
        (nostro_account_available ?nostro_account)
        (case_nostro_allowed ?settlement_case ?nostro_account)
      )
    :effect
      (and
        (case_nostro_reserved ?settlement_case ?nostro_account)
        (not
          (nostro_account_available ?nostro_account)
        )
      )
  )
  (:action release_nostro_account
    :parameters (?settlement_case - settlement_case ?nostro_account - nostro_account)
    :precondition
      (and
        (case_nostro_reserved ?settlement_case ?nostro_account)
      )
    :effect
      (and
        (nostro_account_available ?nostro_account)
        (not
          (case_nostro_reserved ?settlement_case ?nostro_account)
        )
      )
  )
  (:action reserve_currency_route
    :parameters (?settlement_case - settlement_case ?currency_route - currency_route)
    :precondition
      (and
        (case_registered ?settlement_case)
        (currency_route_available ?currency_route)
        (case_currency_route_allowed ?settlement_case ?currency_route)
      )
    :effect
      (and
        (case_currency_route_assigned ?settlement_case ?currency_route)
        (not
          (currency_route_available ?currency_route)
        )
      )
  )
  (:action release_currency_route
    :parameters (?settlement_case - settlement_case ?currency_route - currency_route)
    :precondition
      (and
        (case_currency_route_assigned ?settlement_case ?currency_route)
      )
    :effect
      (and
        (currency_route_available ?currency_route)
        (not
          (case_currency_route_assigned ?settlement_case ?currency_route)
        )
      )
  )
  (:action schedule_execution_on_rail
    :parameters (?settlement_case - settlement_case ?settlement_rail - settlement_rail ?currency - currency ?beneficiary_correspondent - beneficiary_correspondent)
    :precondition
      (and
        (case_originating_ledger_allocated ?settlement_case)
        (case_currency_reserved ?settlement_case ?currency)
        (case_correspondent_reserved ?settlement_case ?beneficiary_correspondent)
        (settlement_rail_available ?settlement_rail)
        (case_settlement_rail_allowed ?settlement_case ?settlement_rail)
        (not
          (case_execution_scheduled ?settlement_case)
        )
      )
    :effect
      (and
        (case_assigned_rail ?settlement_case ?settlement_rail)
        (case_execution_scheduled ?settlement_case)
        (not
          (settlement_rail_available ?settlement_rail)
        )
      )
  )
  (:action schedule_execution_with_liquidity
    :parameters (?settlement_case - settlement_case ?settlement_rail - settlement_rail ?nostro_account - nostro_account ?liquidity_reserve_slot - liquidity_reserve_slot)
    :precondition
      (and
        (case_originating_ledger_allocated ?settlement_case)
        (case_nostro_reserved ?settlement_case ?nostro_account)
        (liquidity_reserve_available ?liquidity_reserve_slot)
        (settlement_rail_available ?settlement_rail)
        (case_settlement_rail_allowed ?settlement_case ?settlement_rail)
        (case_liquidity_slot_allowed ?settlement_case ?liquidity_reserve_slot)
        (not
          (case_execution_scheduled ?settlement_case)
        )
      )
    :effect
      (and
        (case_assigned_rail ?settlement_case ?settlement_rail)
        (case_execution_scheduled ?settlement_case)
        (case_post_execution_flag ?settlement_case)
        (case_approval_flag ?settlement_case)
        (not
          (settlement_rail_available ?settlement_rail)
        )
        (not
          (liquidity_reserve_available ?liquidity_reserve_slot)
        )
      )
  )
  (:action record_validation_and_block
    :parameters (?settlement_case - settlement_case ?currency - currency ?beneficiary_correspondent - beneficiary_correspondent)
    :precondition
      (and
        (case_execution_scheduled ?settlement_case)
        (case_post_execution_flag ?settlement_case)
        (case_currency_reserved ?settlement_case ?currency)
        (case_correspondent_reserved ?settlement_case ?beneficiary_correspondent)
      )
    :effect
      (and
        (not
          (case_post_execution_flag ?settlement_case)
        )
        (not
          (case_approval_flag ?settlement_case)
        )
      )
  )
  (:action capture_manual_approval
    :parameters (?settlement_case - settlement_case ?currency - currency ?beneficiary_correspondent - beneficiary_correspondent ?routing_profile_domestic - routing_profile_domestic)
    :precondition
      (and
        (case_validated ?settlement_case)
        (case_execution_scheduled ?settlement_case)
        (case_currency_reserved ?settlement_case ?currency)
        (case_correspondent_reserved ?settlement_case ?beneficiary_correspondent)
        (case_routing_profile_assigned ?settlement_case ?routing_profile_domestic)
        (not
          (case_approval_flag ?settlement_case)
        )
        (not
          (case_approval_recorded ?settlement_case)
        )
      )
    :effect
      (and
        (case_approval_recorded ?settlement_case)
      )
  )
  (:action capture_compliance_and_approval
    :parameters (?settlement_case - settlement_case ?nostro_account - nostro_account ?currency_route - currency_route ?routing_profile_international - routing_profile_international)
    :precondition
      (and
        (case_validated ?settlement_case)
        (case_execution_scheduled ?settlement_case)
        (case_nostro_reserved ?settlement_case ?nostro_account)
        (case_currency_route_assigned ?settlement_case ?currency_route)
        (case_routing_profile_assigned ?settlement_case ?routing_profile_international)
        (not
          (case_approval_recorded ?settlement_case)
        )
      )
    :effect
      (and
        (case_approval_recorded ?settlement_case)
        (case_approval_flag ?settlement_case)
      )
  )
  (:action authorize_settlement
    :parameters (?settlement_case - settlement_case ?currency - currency ?beneficiary_correspondent - beneficiary_correspondent)
    :precondition
      (and
        (case_approval_recorded ?settlement_case)
        (case_approval_flag ?settlement_case)
        (case_currency_reserved ?settlement_case ?currency)
        (case_correspondent_reserved ?settlement_case ?beneficiary_correspondent)
      )
    :effect
      (and
        (case_authorized ?settlement_case)
        (not
          (case_approval_flag ?settlement_case)
        )
        (not
          (case_validated ?settlement_case)
        )
        (not
          (case_post_execution_flag ?settlement_case)
        )
      )
  )
  (:action post_execution_update_after_authorization
    :parameters (?settlement_case - settlement_case ?communication_channel - communication_channel ?validation_service - validation_service)
    :precondition
      (and
        (case_authorized ?settlement_case)
        (case_approval_recorded ?settlement_case)
        (case_originating_ledger_allocated ?settlement_case)
        (case_communication_channel_bound ?settlement_case ?communication_channel)
        (validation_service_available ?validation_service)
        (not
          (case_validated ?settlement_case)
        )
      )
    :effect
      (and
        (case_validated ?settlement_case)
      )
  )
  (:action mark_ready_for_posting
    :parameters (?settlement_case - settlement_case ?communication_channel - communication_channel)
    :precondition
      (and
        (case_approval_recorded ?settlement_case)
        (case_validated ?settlement_case)
        (not
          (case_approval_flag ?settlement_case)
        )
        (case_communication_channel_bound ?settlement_case ?communication_channel)
        (not
          (case_ready_for_posting ?settlement_case)
        )
      )
    :effect
      (and
        (case_ready_for_posting ?settlement_case)
      )
  )
  (:action mark_ready_for_posting_with_manual_approval
    :parameters (?settlement_case - settlement_case ?approval_token - approval_token)
    :precondition
      (and
        (case_approval_recorded ?settlement_case)
        (case_validated ?settlement_case)
        (not
          (case_approval_flag ?settlement_case)
        )
        (approval_token_available ?approval_token)
        (not
          (case_ready_for_posting ?settlement_case)
        )
      )
    :effect
      (and
        (case_ready_for_posting ?settlement_case)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action bind_outgoing_case_to_endpoint
    :parameters (?settlement_case - settlement_case ?correspondent_endpoint - correspondent_endpoint)
    :precondition
      (and
        (case_ready_for_posting ?settlement_case)
        (correspondent_endpoint_available ?correspondent_endpoint)
        (outgoing_case_endpoint_allowed ?settlement_case ?correspondent_endpoint)
      )
    :effect
      (and
        (outgoing_case_endpoint_bound ?settlement_case ?correspondent_endpoint)
        (not
          (correspondent_endpoint_available ?correspondent_endpoint)
        )
      )
  )
  (:action bind_incoming_to_outgoing_endpoint
    :parameters (?incoming_case - incoming_case ?outgoing_case - outgoing_case ?correspondent_endpoint - correspondent_endpoint)
    :precondition
      (and
        (case_registered ?incoming_case)
        (case_incoming ?incoming_case)
        (incoming_case_endpoint_allowed ?incoming_case ?correspondent_endpoint)
        (outgoing_case_endpoint_bound ?outgoing_case ?correspondent_endpoint)
        (not
          (incoming_case_endpoint_bound ?incoming_case ?correspondent_endpoint)
        )
      )
    :effect
      (and
        (incoming_case_endpoint_bound ?incoming_case ?correspondent_endpoint)
      )
  )
  (:action set_routing_processing_flag
    :parameters (?settlement_case - settlement_case ?communication_channel - communication_channel ?validation_service - validation_service)
    :precondition
      (and
        (case_registered ?settlement_case)
        (case_incoming ?settlement_case)
        (case_validated ?settlement_case)
        (case_ready_for_posting ?settlement_case)
        (case_communication_channel_bound ?settlement_case ?communication_channel)
        (validation_service_available ?validation_service)
        (not
          (case_routing_confirmed ?settlement_case)
        )
      )
    :effect
      (and
        (case_routing_confirmed ?settlement_case)
      )
  )
  (:action finalize_outgoing_case
    :parameters (?settlement_case - settlement_case)
    :precondition
      (and
        (case_outgoing ?settlement_case)
        (case_registered ?settlement_case)
        (case_originating_ledger_allocated ?settlement_case)
        (case_execution_scheduled ?settlement_case)
        (case_approval_recorded ?settlement_case)
        (case_ready_for_posting ?settlement_case)
        (case_validated ?settlement_case)
        (not
          (case_finalized ?settlement_case)
        )
      )
    :effect
      (and
        (case_finalized ?settlement_case)
      )
  )
  (:action finalize_case_with_endpoint
    :parameters (?settlement_case - settlement_case ?correspondent_endpoint - correspondent_endpoint)
    :precondition
      (and
        (case_incoming ?settlement_case)
        (case_registered ?settlement_case)
        (case_originating_ledger_allocated ?settlement_case)
        (case_execution_scheduled ?settlement_case)
        (case_approval_recorded ?settlement_case)
        (case_ready_for_posting ?settlement_case)
        (case_validated ?settlement_case)
        (incoming_case_endpoint_bound ?settlement_case ?correspondent_endpoint)
        (not
          (case_finalized ?settlement_case)
        )
      )
    :effect
      (and
        (case_finalized ?settlement_case)
      )
  )
  (:action finalize_incoming_case
    :parameters (?settlement_case - settlement_case)
    :precondition
      (and
        (case_incoming ?settlement_case)
        (case_registered ?settlement_case)
        (case_originating_ledger_allocated ?settlement_case)
        (case_execution_scheduled ?settlement_case)
        (case_approval_recorded ?settlement_case)
        (case_ready_for_posting ?settlement_case)
        (case_validated ?settlement_case)
        (case_routing_confirmed ?settlement_case)
        (not
          (case_finalized ?settlement_case)
        )
      )
    :effect
      (and
        (case_finalized ?settlement_case)
      )
  )
)

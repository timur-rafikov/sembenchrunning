(define (domain ach_batch_orchestration)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object ach_batch - entity funding_account - entity settlement_window - entity beneficiary_bank - entity originating_bank - entity alternate_rail - entity nacha_file_resource - entity authorization_credential - entity destination_rail - entity clearing_operator - entity reserve_token - entity clearing_channel - entity liquidity_provider_group - entity liquidity_provider_primary - liquidity_provider_group liquidity_provider_secondary - liquidity_provider_group scheduled_batch - ach_batch ad_hoc_batch - ach_batch)

  (:predicates
    (batch_registered ?ach_batch - ach_batch)
    (batch_allocated_to_funding_account ?ach_batch - ach_batch ?funding_account - funding_account)
    (batch_funding_hold ?ach_batch - ach_batch)
    (batch_routing_locked ?ach_batch - ach_batch)
    (batch_operator_validated ?ach_batch - ach_batch)
    (batch_reserved_originating_bank ?ach_batch - ach_batch ?originating_bank - originating_bank)
    (batch_reserved_beneficiary_bank ?ach_batch - ach_batch ?beneficiary_bank - beneficiary_bank)
    (batch_reserved_alternate_rail ?ach_batch - ach_batch ?alternate_rail - alternate_rail)
    (batch_reserved_clearing_channel ?ach_batch - ach_batch ?clearing_channel - clearing_channel)
    (batch_scheduled_in_window ?ach_batch - ach_batch ?settlement_window - settlement_window)
    (batch_scheduling_confirmed ?ach_batch - ach_batch)
    (batch_liquidity_cleared ?ach_batch - ach_batch)
    (batch_ready_for_rail_binding ?ach_batch - ach_batch)
    (batch_finalized ?ach_batch - ach_batch)
    (batch_operator_pending ?ach_batch - ach_batch)
    (batch_ready_for_execution ?ach_batch - ach_batch)
    (batch_eligible_destination_rail ?ach_batch - ach_batch ?destination_rail - destination_rail)
    (batch_bound_to_destination_rail ?ach_batch - ach_batch ?destination_rail - destination_rail)
    (batch_pre_execution_confirmed ?ach_batch - ach_batch)
    (funding_account_available ?funding_account - funding_account)
    (settlement_window_available ?settlement_window - settlement_window)
    (originating_bank_available ?originating_bank - originating_bank)
    (beneficiary_bank_available ?beneficiary_bank - beneficiary_bank)
    (alternate_rail_available ?alternate_rail - alternate_rail)
    (file_resource_available ?nacha_file_resource - nacha_file_resource)
    (authorization_credential_available ?authorization_credential - authorization_credential)
    (destination_rail_available ?destination_rail - destination_rail)
    (clearing_operator_available ?clearing_operator - clearing_operator)
    (reserve_token_available ?reserve_token - reserve_token)
    (clearing_channel_available ?clearing_channel - clearing_channel)
    (eligible_funding_account_for_batch ?ach_batch - ach_batch ?funding_account - funding_account)
    (batch_eligible_settlement_window ?ach_batch - ach_batch ?settlement_window - settlement_window)
    (batch_eligible_originating_bank ?ach_batch - ach_batch ?originating_bank - originating_bank)
    (batch_eligible_beneficiary_bank ?ach_batch - ach_batch ?beneficiary_bank - beneficiary_bank)
    (batch_eligible_alternate_rail ?ach_batch - ach_batch ?alternate_rail - alternate_rail)
    (batch_eligible_reserve_token ?ach_batch - ach_batch ?reserve_token - reserve_token)
    (batch_eligible_clearing_channel ?ach_batch - ach_batch ?clearing_channel - clearing_channel)
    (batch_linked_liquidity_provider_group ?ach_batch - ach_batch ?liquidity_provider_group - liquidity_provider_group)
    (batch_destination_rail_selected ?ach_batch - ach_batch ?destination_rail - destination_rail)
    (batch_eligible_for_finalization ?ach_batch - ach_batch)
    (batch_ad_hoc_flag ?ach_batch - ach_batch)
    (batch_has_file_resource ?ach_batch - ach_batch ?nacha_file_resource - nacha_file_resource)
    (batch_additional_checks_required ?ach_batch - ach_batch)
    (batch_to_destination_rail_mapping ?ach_batch - ach_batch ?destination_rail - destination_rail)
  )
  (:action register_batch
    :parameters (?ach_batch - ach_batch)
    :precondition
      (and
        (not
          (batch_registered ?ach_batch)
        )
        (not
          (batch_finalized ?ach_batch)
        )
      )
    :effect
      (and
        (batch_registered ?ach_batch)
      )
  )
  (:action reserve_funding_for_batch
    :parameters (?ach_batch - ach_batch ?funding_account - funding_account)
    :precondition
      (and
        (batch_registered ?ach_batch)
        (funding_account_available ?funding_account)
        (eligible_funding_account_for_batch ?ach_batch ?funding_account)
        (not
          (batch_funding_hold ?ach_batch)
        )
      )
    :effect
      (and
        (batch_allocated_to_funding_account ?ach_batch ?funding_account)
        (batch_funding_hold ?ach_batch)
        (not
          (funding_account_available ?funding_account)
        )
      )
  )
  (:action release_funding_from_batch
    :parameters (?ach_batch - ach_batch ?funding_account - funding_account)
    :precondition
      (and
        (batch_allocated_to_funding_account ?ach_batch ?funding_account)
        (not
          (batch_scheduling_confirmed ?ach_batch)
        )
        (not
          (batch_liquidity_cleared ?ach_batch)
        )
      )
    :effect
      (and
        (not
          (batch_allocated_to_funding_account ?ach_batch ?funding_account)
        )
        (not
          (batch_funding_hold ?ach_batch)
        )
        (not
          (batch_routing_locked ?ach_batch)
        )
        (not
          (batch_operator_validated ?ach_batch)
        )
        (not
          (batch_operator_pending ?ach_batch)
        )
        (not
          (batch_ready_for_execution ?ach_batch)
        )
        (not
          (batch_additional_checks_required ?ach_batch)
        )
        (funding_account_available ?funding_account)
      )
  )
  (:action attach_file_resource
    :parameters (?ach_batch - ach_batch ?nacha_file_resource - nacha_file_resource)
    :precondition
      (and
        (batch_registered ?ach_batch)
        (file_resource_available ?nacha_file_resource)
      )
    :effect
      (and
        (batch_has_file_resource ?ach_batch ?nacha_file_resource)
        (not
          (file_resource_available ?nacha_file_resource)
        )
      )
  )
  (:action detach_file_resource
    :parameters (?ach_batch - ach_batch ?nacha_file_resource - nacha_file_resource)
    :precondition
      (and
        (batch_has_file_resource ?ach_batch ?nacha_file_resource)
      )
    :effect
      (and
        (file_resource_available ?nacha_file_resource)
        (not
          (batch_has_file_resource ?ach_batch ?nacha_file_resource)
        )
      )
  )
  (:action lock_batch_routing
    :parameters (?ach_batch - ach_batch ?nacha_file_resource - nacha_file_resource)
    :precondition
      (and
        (batch_registered ?ach_batch)
        (batch_funding_hold ?ach_batch)
        (batch_has_file_resource ?ach_batch ?nacha_file_resource)
        (not
          (batch_routing_locked ?ach_batch)
        )
      )
    :effect
      (and
        (batch_routing_locked ?ach_batch)
      )
  )
  (:action apply_authorization_credential
    :parameters (?ach_batch - ach_batch ?authorization_credential - authorization_credential)
    :precondition
      (and
        (batch_registered ?ach_batch)
        (batch_funding_hold ?ach_batch)
        (authorization_credential_available ?authorization_credential)
        (not
          (batch_routing_locked ?ach_batch)
        )
      )
    :effect
      (and
        (batch_routing_locked ?ach_batch)
        (batch_operator_pending ?ach_batch)
        (not
          (authorization_credential_available ?authorization_credential)
        )
      )
  )
  (:action operator_validate_batch
    :parameters (?ach_batch - ach_batch ?nacha_file_resource - nacha_file_resource ?clearing_operator - clearing_operator)
    :precondition
      (and
        (batch_routing_locked ?ach_batch)
        (batch_funding_hold ?ach_batch)
        (batch_has_file_resource ?ach_batch ?nacha_file_resource)
        (clearing_operator_available ?clearing_operator)
        (not
          (batch_operator_validated ?ach_batch)
        )
      )
    :effect
      (and
        (batch_operator_validated ?ach_batch)
        (not
          (batch_operator_pending ?ach_batch)
        )
      )
  )
  (:action operator_validate_rail_binding
    :parameters (?ach_batch - ach_batch ?destination_rail - destination_rail)
    :precondition
      (and
        (batch_funding_hold ?ach_batch)
        (batch_bound_to_destination_rail ?ach_batch ?destination_rail)
        (not
          (batch_operator_validated ?ach_batch)
        )
      )
    :effect
      (and
        (batch_operator_validated ?ach_batch)
        (not
          (batch_operator_pending ?ach_batch)
        )
      )
  )
  (:action reserve_originating_bank_for_batch
    :parameters (?ach_batch - ach_batch ?originating_bank - originating_bank)
    :precondition
      (and
        (batch_registered ?ach_batch)
        (originating_bank_available ?originating_bank)
        (batch_eligible_originating_bank ?ach_batch ?originating_bank)
      )
    :effect
      (and
        (batch_reserved_originating_bank ?ach_batch ?originating_bank)
        (not
          (originating_bank_available ?originating_bank)
        )
      )
  )
  (:action release_originating_bank_reservation
    :parameters (?ach_batch - ach_batch ?originating_bank - originating_bank)
    :precondition
      (and
        (batch_reserved_originating_bank ?ach_batch ?originating_bank)
      )
    :effect
      (and
        (originating_bank_available ?originating_bank)
        (not
          (batch_reserved_originating_bank ?ach_batch ?originating_bank)
        )
      )
  )
  (:action reserve_beneficiary_bank_for_batch
    :parameters (?ach_batch - ach_batch ?beneficiary_bank - beneficiary_bank)
    :precondition
      (and
        (batch_registered ?ach_batch)
        (beneficiary_bank_available ?beneficiary_bank)
        (batch_eligible_beneficiary_bank ?ach_batch ?beneficiary_bank)
      )
    :effect
      (and
        (batch_reserved_beneficiary_bank ?ach_batch ?beneficiary_bank)
        (not
          (beneficiary_bank_available ?beneficiary_bank)
        )
      )
  )
  (:action release_beneficiary_bank_reservation
    :parameters (?ach_batch - ach_batch ?beneficiary_bank - beneficiary_bank)
    :precondition
      (and
        (batch_reserved_beneficiary_bank ?ach_batch ?beneficiary_bank)
      )
    :effect
      (and
        (beneficiary_bank_available ?beneficiary_bank)
        (not
          (batch_reserved_beneficiary_bank ?ach_batch ?beneficiary_bank)
        )
      )
  )
  (:action reserve_alternate_rail_for_batch
    :parameters (?ach_batch - ach_batch ?alternate_rail - alternate_rail)
    :precondition
      (and
        (batch_registered ?ach_batch)
        (alternate_rail_available ?alternate_rail)
        (batch_eligible_alternate_rail ?ach_batch ?alternate_rail)
      )
    :effect
      (and
        (batch_reserved_alternate_rail ?ach_batch ?alternate_rail)
        (not
          (alternate_rail_available ?alternate_rail)
        )
      )
  )
  (:action release_alternate_rail_reservation
    :parameters (?ach_batch - ach_batch ?alternate_rail - alternate_rail)
    :precondition
      (and
        (batch_reserved_alternate_rail ?ach_batch ?alternate_rail)
      )
    :effect
      (and
        (alternate_rail_available ?alternate_rail)
        (not
          (batch_reserved_alternate_rail ?ach_batch ?alternate_rail)
        )
      )
  )
  (:action reserve_clearing_channel_for_batch
    :parameters (?ach_batch - ach_batch ?clearing_channel - clearing_channel)
    :precondition
      (and
        (batch_registered ?ach_batch)
        (clearing_channel_available ?clearing_channel)
        (batch_eligible_clearing_channel ?ach_batch ?clearing_channel)
      )
    :effect
      (and
        (batch_reserved_clearing_channel ?ach_batch ?clearing_channel)
        (not
          (clearing_channel_available ?clearing_channel)
        )
      )
  )
  (:action release_clearing_channel_reservation
    :parameters (?ach_batch - ach_batch ?clearing_channel - clearing_channel)
    :precondition
      (and
        (batch_reserved_clearing_channel ?ach_batch ?clearing_channel)
      )
    :effect
      (and
        (clearing_channel_available ?clearing_channel)
        (not
          (batch_reserved_clearing_channel ?ach_batch ?clearing_channel)
        )
      )
  )
  (:action schedule_batch_into_window
    :parameters (?ach_batch - ach_batch ?settlement_window - settlement_window ?originating_bank - originating_bank ?beneficiary_bank - beneficiary_bank)
    :precondition
      (and
        (batch_funding_hold ?ach_batch)
        (batch_reserved_originating_bank ?ach_batch ?originating_bank)
        (batch_reserved_beneficiary_bank ?ach_batch ?beneficiary_bank)
        (settlement_window_available ?settlement_window)
        (batch_eligible_settlement_window ?ach_batch ?settlement_window)
        (not
          (batch_scheduling_confirmed ?ach_batch)
        )
      )
    :effect
      (and
        (batch_scheduled_in_window ?ach_batch ?settlement_window)
        (batch_scheduling_confirmed ?ach_batch)
        (not
          (settlement_window_available ?settlement_window)
        )
      )
  )
  (:action schedule_batch_with_reserve_token
    :parameters (?ach_batch - ach_batch ?settlement_window - settlement_window ?alternate_rail - alternate_rail ?reserve_token - reserve_token)
    :precondition
      (and
        (batch_funding_hold ?ach_batch)
        (batch_reserved_alternate_rail ?ach_batch ?alternate_rail)
        (reserve_token_available ?reserve_token)
        (settlement_window_available ?settlement_window)
        (batch_eligible_settlement_window ?ach_batch ?settlement_window)
        (batch_eligible_reserve_token ?ach_batch ?reserve_token)
        (not
          (batch_scheduling_confirmed ?ach_batch)
        )
      )
    :effect
      (and
        (batch_scheduled_in_window ?ach_batch ?settlement_window)
        (batch_scheduling_confirmed ?ach_batch)
        (batch_additional_checks_required ?ach_batch)
        (batch_operator_pending ?ach_batch)
        (not
          (settlement_window_available ?settlement_window)
        )
        (not
          (reserve_token_available ?reserve_token)
        )
      )
  )
  (:action clear_compliance_liquidity_checks
    :parameters (?ach_batch - ach_batch ?originating_bank - originating_bank ?beneficiary_bank - beneficiary_bank)
    :precondition
      (and
        (batch_scheduling_confirmed ?ach_batch)
        (batch_additional_checks_required ?ach_batch)
        (batch_reserved_originating_bank ?ach_batch ?originating_bank)
        (batch_reserved_beneficiary_bank ?ach_batch ?beneficiary_bank)
      )
    :effect
      (and
        (not
          (batch_additional_checks_required ?ach_batch)
        )
        (not
          (batch_operator_pending ?ach_batch)
        )
      )
  )
  (:action approve_batch_liquidity_authorization
    :parameters (?ach_batch - ach_batch ?originating_bank - originating_bank ?beneficiary_bank - beneficiary_bank ?liquidity_provider_primary - liquidity_provider_primary)
    :precondition
      (and
        (batch_operator_validated ?ach_batch)
        (batch_scheduling_confirmed ?ach_batch)
        (batch_reserved_originating_bank ?ach_batch ?originating_bank)
        (batch_reserved_beneficiary_bank ?ach_batch ?beneficiary_bank)
        (batch_linked_liquidity_provider_group ?ach_batch ?liquidity_provider_primary)
        (not
          (batch_operator_pending ?ach_batch)
        )
        (not
          (batch_liquidity_cleared ?ach_batch)
        )
      )
    :effect
      (and
        (batch_liquidity_cleared ?ach_batch)
      )
  )
  (:action approve_batch_secondary_liquidity_authorization
    :parameters (?ach_batch - ach_batch ?alternate_rail - alternate_rail ?clearing_channel - clearing_channel ?liquidity_provider_secondary - liquidity_provider_secondary)
    :precondition
      (and
        (batch_operator_validated ?ach_batch)
        (batch_scheduling_confirmed ?ach_batch)
        (batch_reserved_alternate_rail ?ach_batch ?alternate_rail)
        (batch_reserved_clearing_channel ?ach_batch ?clearing_channel)
        (batch_linked_liquidity_provider_group ?ach_batch ?liquidity_provider_secondary)
        (not
          (batch_liquidity_cleared ?ach_batch)
        )
      )
    :effect
      (and
        (batch_liquidity_cleared ?ach_batch)
        (batch_operator_pending ?ach_batch)
      )
  )
  (:action finalize_batch_liquidity_checks
    :parameters (?ach_batch - ach_batch ?originating_bank - originating_bank ?beneficiary_bank - beneficiary_bank)
    :precondition
      (and
        (batch_liquidity_cleared ?ach_batch)
        (batch_operator_pending ?ach_batch)
        (batch_reserved_originating_bank ?ach_batch ?originating_bank)
        (batch_reserved_beneficiary_bank ?ach_batch ?beneficiary_bank)
      )
    :effect
      (and
        (batch_ready_for_execution ?ach_batch)
        (not
          (batch_operator_pending ?ach_batch)
        )
        (not
          (batch_operator_validated ?ach_batch)
        )
        (not
          (batch_additional_checks_required ?ach_batch)
        )
      )
  )
  (:action operator_revalidate_batch
    :parameters (?ach_batch - ach_batch ?nacha_file_resource - nacha_file_resource ?clearing_operator - clearing_operator)
    :precondition
      (and
        (batch_ready_for_execution ?ach_batch)
        (batch_liquidity_cleared ?ach_batch)
        (batch_funding_hold ?ach_batch)
        (batch_has_file_resource ?ach_batch ?nacha_file_resource)
        (clearing_operator_available ?clearing_operator)
        (not
          (batch_operator_validated ?ach_batch)
        )
      )
    :effect
      (and
        (batch_operator_validated ?ach_batch)
      )
  )
  (:action mark_batch_ready_for_rail_binding
    :parameters (?ach_batch - ach_batch ?nacha_file_resource - nacha_file_resource)
    :precondition
      (and
        (batch_liquidity_cleared ?ach_batch)
        (batch_operator_validated ?ach_batch)
        (not
          (batch_operator_pending ?ach_batch)
        )
        (batch_has_file_resource ?ach_batch ?nacha_file_resource)
        (not
          (batch_ready_for_rail_binding ?ach_batch)
        )
      )
    :effect
      (and
        (batch_ready_for_rail_binding ?ach_batch)
      )
  )
  (:action apply_credential_to_mark_ready
    :parameters (?ach_batch - ach_batch ?authorization_credential - authorization_credential)
    :precondition
      (and
        (batch_liquidity_cleared ?ach_batch)
        (batch_operator_validated ?ach_batch)
        (not
          (batch_operator_pending ?ach_batch)
        )
        (authorization_credential_available ?authorization_credential)
        (not
          (batch_ready_for_rail_binding ?ach_batch)
        )
      )
    :effect
      (and
        (batch_ready_for_rail_binding ?ach_batch)
        (not
          (authorization_credential_available ?authorization_credential)
        )
      )
  )
  (:action bind_batch_to_destination_rail
    :parameters (?ach_batch - ach_batch ?destination_rail - destination_rail)
    :precondition
      (and
        (batch_ready_for_rail_binding ?ach_batch)
        (destination_rail_available ?destination_rail)
        (batch_to_destination_rail_mapping ?ach_batch ?destination_rail)
      )
    :effect
      (and
        (batch_destination_rail_selected ?ach_batch ?destination_rail)
        (not
          (destination_rail_available ?destination_rail)
        )
      )
  )
  (:action bind_ad_hoc_and_scheduled_batch_to_rail
    :parameters (?ad_hoc_batch - ad_hoc_batch ?scheduled_batch - scheduled_batch ?destination_rail - destination_rail)
    :precondition
      (and
        (batch_registered ?ad_hoc_batch)
        (batch_ad_hoc_flag ?ad_hoc_batch)
        (batch_eligible_destination_rail ?ad_hoc_batch ?destination_rail)
        (batch_destination_rail_selected ?scheduled_batch ?destination_rail)
        (not
          (batch_bound_to_destination_rail ?ad_hoc_batch ?destination_rail)
        )
      )
    :effect
      (and
        (batch_bound_to_destination_rail ?ad_hoc_batch ?destination_rail)
      )
  )
  (:action confirm_pre_execution_gate
    :parameters (?ach_batch - ach_batch ?nacha_file_resource - nacha_file_resource ?clearing_operator - clearing_operator)
    :precondition
      (and
        (batch_registered ?ach_batch)
        (batch_ad_hoc_flag ?ach_batch)
        (batch_operator_validated ?ach_batch)
        (batch_ready_for_rail_binding ?ach_batch)
        (batch_has_file_resource ?ach_batch ?nacha_file_resource)
        (clearing_operator_available ?clearing_operator)
        (not
          (batch_pre_execution_confirmed ?ach_batch)
        )
      )
    :effect
      (and
        (batch_pre_execution_confirmed ?ach_batch)
      )
  )
  (:action finalize_batch
    :parameters (?ach_batch - ach_batch)
    :precondition
      (and
        (batch_eligible_for_finalization ?ach_batch)
        (batch_registered ?ach_batch)
        (batch_funding_hold ?ach_batch)
        (batch_scheduling_confirmed ?ach_batch)
        (batch_liquidity_cleared ?ach_batch)
        (batch_ready_for_rail_binding ?ach_batch)
        (batch_operator_validated ?ach_batch)
        (not
          (batch_finalized ?ach_batch)
        )
      )
    :effect
      (and
        (batch_finalized ?ach_batch)
      )
  )
  (:action finalize_batch_with_rail
    :parameters (?ach_batch - ach_batch ?destination_rail - destination_rail)
    :precondition
      (and
        (batch_ad_hoc_flag ?ach_batch)
        (batch_registered ?ach_batch)
        (batch_funding_hold ?ach_batch)
        (batch_scheduling_confirmed ?ach_batch)
        (batch_liquidity_cleared ?ach_batch)
        (batch_ready_for_rail_binding ?ach_batch)
        (batch_operator_validated ?ach_batch)
        (batch_bound_to_destination_rail ?ach_batch ?destination_rail)
        (not
          (batch_finalized ?ach_batch)
        )
      )
    :effect
      (and
        (batch_finalized ?ach_batch)
      )
  )
  (:action finalize_ad_hoc_batch
    :parameters (?ach_batch - ach_batch)
    :precondition
      (and
        (batch_ad_hoc_flag ?ach_batch)
        (batch_registered ?ach_batch)
        (batch_funding_hold ?ach_batch)
        (batch_scheduling_confirmed ?ach_batch)
        (batch_liquidity_cleared ?ach_batch)
        (batch_ready_for_rail_binding ?ach_batch)
        (batch_operator_validated ?ach_batch)
        (batch_pre_execution_confirmed ?ach_batch)
        (not
          (batch_finalized ?ach_batch)
        )
      )
    :effect
      (and
        (batch_finalized ?ach_batch)
      )
  )
)

(define (domain treasury_internal_transfer_netting_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types netting_batch - object payment_instruction - object settlement_rail - object receiving_account - object sending_account - object funding_account - object routing_rule - object approval_token - object execution_window - object clearing_agent - object external_settlement_service - object instrument - object priority_group - object priority_group_a - priority_group priority_group_b - priority_group netting_batch_primary - netting_batch netting_batch_secondary - netting_batch)
  (:predicates
    (approval_token_available ?approval_token - approval_token)
    (assigned_receiving_account ?netting_batch - netting_batch ?receiving_account - receiving_account)
    (execution_ready_flag ?netting_batch - netting_batch)
    (instruction_attached ?netting_batch - netting_batch ?payment_instruction - payment_instruction)
    (batch_priority_group ?netting_batch - netting_batch ?priority_profile - priority_group)
    (funding_account_available ?funding_account - funding_account)
    (receiving_account_available ?receiving_account - receiving_account)
    (batch_instrument_eligible ?netting_batch - netting_batch ?instrument - instrument)
    (batch_released ?netting_batch - netting_batch)
    (is_primary_batch ?netting_batch - netting_batch)
    (instruction_eligible_for_batch ?netting_batch - netting_batch ?payment_instruction - payment_instruction)
    (rail_available ?settlement_rail - settlement_rail)
    (external_service_available ?external_settlement_service - external_settlement_service)
    (routing_rule_available ?routing_rule - routing_rule)
    (batch_composed ?netting_batch - netting_batch)
    (batch_receiving_account_eligible ?netting_batch - netting_batch ?receiving_account - receiving_account)
    (assigned_instrument ?netting_batch - netting_batch ?instrument - instrument)
    (composed_settlement_on_rail ?netting_batch - netting_batch ?settlement_rail - settlement_rail)
    (pre_settlement_approved ?netting_batch - netting_batch)
    (batch_funding_account_eligible ?netting_batch - netting_batch ?funding_account - funding_account)
    (instrument_available ?instrument - instrument)
    (is_secondary_batch ?netting_batch - netting_batch)
    (batch_validated ?netting_batch - netting_batch)
    (batch_sending_account_eligible ?netting_batch - netting_batch ?sending_account - sending_account)
    (assigned_sending_account ?netting_batch - netting_batch ?sending_account - sending_account)
    (external_service_bound ?netting_batch - netting_batch)
    (routing_rule_assigned ?netting_batch - netting_batch ?routing_rule - routing_rule)
    (operator_notification_sent ?netting_batch - netting_batch)
    (batch_external_service_eligible ?netting_batch - netting_batch ?external_settlement_service - external_settlement_service)
    (batch_initialized ?netting_batch - netting_batch)
    (instruction_available ?payment_instruction - payment_instruction)
    (batch_has_instructions ?netting_batch - netting_batch)
    (clearing_agent_available ?clearing_agent - clearing_agent)
    (window_slot_available ?execution_window - execution_window)
    (assigned_funding_account ?netting_batch - netting_batch ?funding_account - funding_account)
    (primary_window_assigned ?netting_batch - netting_batch ?execution_window - execution_window)
    (routing_assigned ?netting_batch - netting_batch)
    (operator_assigned ?netting_batch - netting_batch)
    (batch_window_compatible ?netting_batch - netting_batch ?execution_window - execution_window)
    (sending_account_available ?sending_account - sending_account)
    (secondary_window_candidate ?netting_batch - netting_batch ?execution_window - execution_window)
    (batch_rail_compatible ?netting_batch - netting_batch ?settlement_rail - settlement_rail)
    (funding_hold_flag ?netting_batch - netting_batch)
    (secondary_window_confirmed ?netting_batch - netting_batch ?execution_window - execution_window)
  )
  (:action unbind_instrument_from_batch
    :parameters (?netting_batch - netting_batch ?instrument - instrument)
    :precondition
      (and
        (assigned_instrument ?netting_batch ?instrument)
      )
    :effect
      (and
        (instrument_available ?instrument)
        (not
          (assigned_instrument ?netting_batch ?instrument)
        )
      )
  )
  (:action set_pre_settlement_approval_with_priority
    :parameters (?netting_batch - netting_batch ?funding_account - funding_account ?instrument - instrument ?priority_group_b - priority_group_b)
    :precondition
      (and
        (not
          (pre_settlement_approved ?netting_batch)
        )
        (batch_composed ?netting_batch)
        (batch_validated ?netting_batch)
        (assigned_instrument ?netting_batch ?instrument)
        (batch_priority_group ?netting_batch ?priority_group_b)
        (assigned_funding_account ?netting_batch ?funding_account)
      )
    :effect
      (and
        (funding_hold_flag ?netting_batch)
        (pre_settlement_approved ?netting_batch)
      )
  )
  (:action finalize_and_release_batch
    :parameters (?netting_batch - netting_batch)
    :precondition
      (and
        (batch_validated ?netting_batch)
        (batch_has_instructions ?netting_batch)
        (batch_composed ?netting_batch)
        (batch_initialized ?netting_batch)
        (operator_assigned ?netting_batch)
        (not
          (batch_released ?netting_batch)
        )
        (is_primary_batch ?netting_batch)
        (pre_settlement_approved ?netting_batch)
      )
    :effect
      (and
        (batch_released ?netting_batch)
      )
  )
  (:action clear_pre_settlement_checks
    :parameters (?netting_batch - netting_batch ?sending_account - sending_account ?receiving_account - receiving_account)
    :precondition
      (and
        (batch_composed ?netting_batch)
        (external_service_bound ?netting_batch)
        (assigned_sending_account ?netting_batch ?sending_account)
        (assigned_receiving_account ?netting_batch ?receiving_account)
      )
    :effect
      (and
        (not
          (external_service_bound ?netting_batch)
        )
        (not
          (funding_hold_flag ?netting_batch)
        )
      )
  )
  (:action assign_routing_rule_to_batch
    :parameters (?netting_batch - netting_batch ?routing_rule - routing_rule)
    :precondition
      (and
        (routing_rule_available ?routing_rule)
        (batch_initialized ?netting_batch)
      )
    :effect
      (and
        (not
          (routing_rule_available ?routing_rule)
        )
        (routing_rule_assigned ?netting_batch ?routing_rule)
      )
  )
  (:action set_pre_settlement_approval
    :parameters (?netting_batch - netting_batch ?sending_account - sending_account ?receiving_account - receiving_account ?priority_group_a - priority_group_a)
    :precondition
      (and
        (batch_priority_group ?netting_batch ?priority_group_a)
        (batch_validated ?netting_batch)
        (not
          (funding_hold_flag ?netting_batch)
        )
        (assigned_sending_account ?netting_batch ?sending_account)
        (batch_composed ?netting_batch)
        (assigned_receiving_account ?netting_batch ?receiving_account)
        (not
          (pre_settlement_approved ?netting_batch)
        )
      )
    :effect
      (and
        (pre_settlement_approved ?netting_batch)
      )
  )
  (:action release_via_execution_window
    :parameters (?netting_batch - netting_batch ?execution_window - execution_window)
    :precondition
      (and
        (batch_has_instructions ?netting_batch)
        (secondary_window_confirmed ?netting_batch ?execution_window)
        (not
          (batch_validated ?netting_batch)
        )
      )
    :effect
      (and
        (batch_validated ?netting_batch)
        (not
          (funding_hold_flag ?netting_batch)
        )
      )
  )
  (:action bind_funding_account_to_batch
    :parameters (?netting_batch - netting_batch ?funding_account - funding_account)
    :precondition
      (and
        (batch_funding_account_eligible ?netting_batch ?funding_account)
        (batch_initialized ?netting_batch)
        (funding_account_available ?funding_account)
      )
    :effect
      (and
        (assigned_funding_account ?netting_batch ?funding_account)
        (not
          (funding_account_available ?funding_account)
        )
      )
  )
  (:action bind_sending_account_to_batch
    :parameters (?netting_batch - netting_batch ?sending_account - sending_account)
    :precondition
      (and
        (batch_initialized ?netting_batch)
        (sending_account_available ?sending_account)
        (batch_sending_account_eligible ?netting_batch ?sending_account)
      )
    :effect
      (and
        (not
          (sending_account_available ?sending_account)
        )
        (assigned_sending_account ?netting_batch ?sending_account)
      )
  )
  (:action unbind_funding_account_from_batch
    :parameters (?netting_batch - netting_batch ?funding_account - funding_account)
    :precondition
      (and
        (assigned_funding_account ?netting_batch ?funding_account)
      )
    :effect
      (and
        (funding_account_available ?funding_account)
        (not
          (assigned_funding_account ?netting_batch ?funding_account)
        )
      )
  )
  (:action unbind_receiving_account_from_batch
    :parameters (?netting_batch - netting_batch ?receiving_account - receiving_account)
    :precondition
      (and
        (assigned_receiving_account ?netting_batch ?receiving_account)
      )
    :effect
      (and
        (receiving_account_available ?receiving_account)
        (not
          (assigned_receiving_account ?netting_batch ?receiving_account)
        )
      )
  )
  (:action schedule_primary_batch_window_assignment
    :parameters (?netting_batch - netting_batch ?execution_window - execution_window)
    :precondition
      (and
        (operator_assigned ?netting_batch)
        (window_slot_available ?execution_window)
        (batch_window_compatible ?netting_batch ?execution_window)
      )
    :effect
      (and
        (primary_window_assigned ?netting_batch ?execution_window)
        (not
          (window_slot_available ?execution_window)
        )
      )
  )
  (:action bind_receiving_account_to_batch
    :parameters (?netting_batch - netting_batch ?receiving_account - receiving_account)
    :precondition
      (and
        (batch_initialized ?netting_batch)
        (receiving_account_available ?receiving_account)
        (batch_receiving_account_eligible ?netting_batch ?receiving_account)
      )
    :effect
      (and
        (assigned_receiving_account ?netting_batch ?receiving_account)
        (not
          (receiving_account_available ?receiving_account)
        )
      )
  )
  (:action compose_settlement_for_rail
    :parameters (?netting_batch - netting_batch ?settlement_rail - settlement_rail ?sending_account - sending_account ?receiving_account - receiving_account)
    :precondition
      (and
        (batch_has_instructions ?netting_batch)
        (rail_available ?settlement_rail)
        (batch_rail_compatible ?netting_batch ?settlement_rail)
        (not
          (batch_composed ?netting_batch)
        )
        (assigned_receiving_account ?netting_batch ?receiving_account)
        (assigned_sending_account ?netting_batch ?sending_account)
      )
    :effect
      (and
        (composed_settlement_on_rail ?netting_batch ?settlement_rail)
        (not
          (rail_available ?settlement_rail)
        )
        (batch_composed ?netting_batch)
      )
  )
  (:action progress_to_execution_ready
    :parameters (?netting_batch - netting_batch ?sending_account - sending_account ?receiving_account - receiving_account)
    :precondition
      (and
        (assigned_sending_account ?netting_batch ?sending_account)
        (pre_settlement_approved ?netting_batch)
        (assigned_receiving_account ?netting_batch ?receiving_account)
        (funding_hold_flag ?netting_batch)
      )
    :effect
      (and
        (not
          (external_service_bound ?netting_batch)
        )
        (not
          (funding_hold_flag ?netting_batch)
        )
        (not
          (batch_validated ?netting_batch)
        )
        (execution_ready_flag ?netting_batch)
      )
  )
  (:action revoke_routing_rule_from_batch
    :parameters (?netting_batch - netting_batch ?routing_rule - routing_rule)
    :precondition
      (and
        (routing_rule_assigned ?netting_batch ?routing_rule)
      )
    :effect
      (and
        (routing_rule_available ?routing_rule)
        (not
          (routing_rule_assigned ?netting_batch ?routing_rule)
        )
      )
  )
  (:action apply_clearing_agent_validation
    :parameters (?netting_batch - netting_batch ?routing_rule - routing_rule ?clearing_agent - clearing_agent)
    :precondition
      (and
        (not
          (batch_validated ?netting_batch)
        )
        (batch_has_instructions ?netting_batch)
        (clearing_agent_available ?clearing_agent)
        (routing_rule_assigned ?netting_batch ?routing_rule)
        (routing_assigned ?netting_batch)
      )
    :effect
      (and
        (not
          (funding_hold_flag ?netting_batch)
        )
        (batch_validated ?netting_batch)
      )
  )
  (:action finalize_and_release_batch_after_operator_notification
    :parameters (?netting_batch - netting_batch)
    :precondition
      (and
        (batch_initialized ?netting_batch)
        (is_secondary_batch ?netting_batch)
        (operator_notification_sent ?netting_batch)
        (batch_has_instructions ?netting_batch)
        (batch_validated ?netting_batch)
        (not
          (batch_released ?netting_batch)
        )
        (operator_assigned ?netting_batch)
        (batch_composed ?netting_batch)
        (pre_settlement_approved ?netting_batch)
      )
    :effect
      (and
        (batch_released ?netting_batch)
      )
  )
  (:action notify_operator_for_routing
    :parameters (?netting_batch - netting_batch ?routing_rule - routing_rule ?clearing_agent - clearing_agent)
    :precondition
      (and
        (batch_validated ?netting_batch)
        (clearing_agent_available ?clearing_agent)
        (not
          (operator_notification_sent ?netting_batch)
        )
        (operator_assigned ?netting_batch)
        (batch_initialized ?netting_batch)
        (is_secondary_batch ?netting_batch)
        (routing_rule_assigned ?netting_batch ?routing_rule)
      )
    :effect
      (and
        (operator_notification_sent ?netting_batch)
      )
  )
  (:action unbind_sending_account_from_batch
    :parameters (?netting_batch - netting_batch ?sending_account - sending_account)
    :precondition
      (and
        (assigned_sending_account ?netting_batch ?sending_account)
      )
    :effect
      (and
        (sending_account_available ?sending_account)
        (not
          (assigned_sending_account ?netting_batch ?sending_account)
        )
      )
  )
  (:action bind_instrument_to_batch
    :parameters (?netting_batch - netting_batch ?instrument - instrument)
    :precondition
      (and
        (instrument_available ?instrument)
        (batch_initialized ?netting_batch)
        (batch_instrument_eligible ?netting_batch ?instrument)
      )
    :effect
      (and
        (assigned_instrument ?netting_batch ?instrument)
        (not
          (instrument_available ?instrument)
        )
      )
  )
  (:action initialize_batch
    :parameters (?netting_batch - netting_batch)
    :precondition
      (and
        (not
          (batch_initialized ?netting_batch)
        )
        (not
          (batch_released ?netting_batch)
        )
      )
    :effect
      (and
        (batch_initialized ?netting_batch)
      )
  )
  (:action apply_approval_token
    :parameters (?netting_batch - netting_batch ?approval_token - approval_token)
    :precondition
      (and
        (not
          (routing_assigned ?netting_batch)
        )
        (batch_initialized ?netting_batch)
        (approval_token_available ?approval_token)
        (batch_has_instructions ?netting_batch)
      )
    :effect
      (and
        (funding_hold_flag ?netting_batch)
        (not
          (approval_token_available ?approval_token)
        )
        (routing_assigned ?netting_batch)
      )
  )
  (:action compose_settlement_with_external_service
    :parameters (?netting_batch - netting_batch ?settlement_rail - settlement_rail ?funding_account - funding_account ?external_settlement_service - external_settlement_service)
    :precondition
      (and
        (external_service_available ?external_settlement_service)
        (batch_external_service_eligible ?netting_batch ?external_settlement_service)
        (not
          (batch_composed ?netting_batch)
        )
        (batch_has_instructions ?netting_batch)
        (rail_available ?settlement_rail)
        (batch_rail_compatible ?netting_batch ?settlement_rail)
        (assigned_funding_account ?netting_batch ?funding_account)
      )
    :effect
      (and
        (composed_settlement_on_rail ?netting_batch ?settlement_rail)
        (not
          (external_service_available ?external_settlement_service)
        )
        (external_service_bound ?netting_batch)
        (not
          (rail_available ?settlement_rail)
        )
        (funding_hold_flag ?netting_batch)
        (batch_composed ?netting_batch)
      )
  )
  (:action consume_approval_token_and_mark_operator
    :parameters (?netting_batch - netting_batch ?approval_token - approval_token)
    :precondition
      (and
        (approval_token_available ?approval_token)
        (not
          (funding_hold_flag ?netting_batch)
        )
        (batch_validated ?netting_batch)
        (pre_settlement_approved ?netting_batch)
        (not
          (operator_assigned ?netting_batch)
        )
      )
    :effect
      (and
        (operator_assigned ?netting_batch)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action detach_instruction_from_batch
    :parameters (?netting_batch - netting_batch ?payment_instruction - payment_instruction)
    :precondition
      (and
        (instruction_attached ?netting_batch ?payment_instruction)
        (not
          (pre_settlement_approved ?netting_batch)
        )
        (not
          (batch_composed ?netting_batch)
        )
      )
    :effect
      (and
        (not
          (instruction_attached ?netting_batch ?payment_instruction)
        )
        (instruction_available ?payment_instruction)
        (not
          (batch_has_instructions ?netting_batch)
        )
        (not
          (routing_assigned ?netting_batch)
        )
        (not
          (execution_ready_flag ?netting_batch)
        )
        (not
          (batch_validated ?netting_batch)
        )
        (not
          (external_service_bound ?netting_batch)
        )
        (not
          (funding_hold_flag ?netting_batch)
        )
      )
  )
  (:action mark_operator_assigned
    :parameters (?netting_batch - netting_batch ?routing_rule - routing_rule)
    :precondition
      (and
        (not
          (operator_assigned ?netting_batch)
        )
        (routing_rule_assigned ?netting_batch ?routing_rule)
        (batch_validated ?netting_batch)
        (pre_settlement_approved ?netting_batch)
        (not
          (funding_hold_flag ?netting_batch)
        )
      )
    :effect
      (and
        (operator_assigned ?netting_batch)
      )
  )
  (:action finalize_and_release_batch_with_execution_window
    :parameters (?netting_batch - netting_batch ?execution_window - execution_window)
    :precondition
      (and
        (operator_assigned ?netting_batch)
        (pre_settlement_approved ?netting_batch)
        (batch_composed ?netting_batch)
        (secondary_window_confirmed ?netting_batch ?execution_window)
        (batch_validated ?netting_batch)
        (batch_has_instructions ?netting_batch)
        (batch_initialized ?netting_batch)
        (not
          (batch_released ?netting_batch)
        )
        (is_secondary_batch ?netting_batch)
      )
    :effect
      (and
        (batch_released ?netting_batch)
      )
  )
  (:action confirm_routing_assignment
    :parameters (?netting_batch - netting_batch ?routing_rule - routing_rule)
    :precondition
      (and
        (batch_initialized ?netting_batch)
        (batch_has_instructions ?netting_batch)
        (not
          (routing_assigned ?netting_batch)
        )
        (routing_rule_assigned ?netting_batch ?routing_rule)
      )
    :effect
      (and
        (routing_assigned ?netting_batch)
      )
  )
  (:action attach_instruction_to_batch
    :parameters (?netting_batch - netting_batch ?payment_instruction - payment_instruction)
    :precondition
      (and
        (not
          (batch_has_instructions ?netting_batch)
        )
        (batch_initialized ?netting_batch)
        (instruction_available ?payment_instruction)
        (instruction_eligible_for_batch ?netting_batch ?payment_instruction)
      )
    :effect
      (and
        (batch_has_instructions ?netting_batch)
        (not
          (instruction_available ?payment_instruction)
        )
        (instruction_attached ?netting_batch ?payment_instruction)
      )
  )
  (:action reapply_clearing_agent_validation_post_approval
    :parameters (?netting_batch - netting_batch ?routing_rule - routing_rule ?clearing_agent - clearing_agent)
    :precondition
      (and
        (batch_has_instructions ?netting_batch)
        (not
          (batch_validated ?netting_batch)
        )
        (routing_rule_assigned ?netting_batch ?routing_rule)
        (pre_settlement_approved ?netting_batch)
        (clearing_agent_available ?clearing_agent)
        (execution_ready_flag ?netting_batch)
      )
    :effect
      (and
        (batch_validated ?netting_batch)
      )
  )
  (:action confirm_secondary_batch_window_assignment
    :parameters (?netting_batch_secondary - netting_batch_secondary ?netting_batch_primary - netting_batch_primary ?execution_window - execution_window)
    :precondition
      (and
        (batch_initialized ?netting_batch_secondary)
        (primary_window_assigned ?netting_batch_primary ?execution_window)
        (is_secondary_batch ?netting_batch_secondary)
        (not
          (secondary_window_confirmed ?netting_batch_secondary ?execution_window)
        )
        (secondary_window_candidate ?netting_batch_secondary ?execution_window)
      )
    :effect
      (and
        (secondary_window_confirmed ?netting_batch_secondary ?execution_window)
      )
  )
)

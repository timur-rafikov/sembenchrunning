(define (domain same_day_wire_release_control_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types payment_instruction - entity payer_account - entity execution_slot - entity routing_option - entity liquidity_reserve - entity funding_agent - entity release_manifest - entity operator_authorization_token - entity settlement_rail - entity file_validator - entity fx_service - entity correspondent_code - entity participant_profile - entity clearing_member_profile - participant_profile settlement_member_profile - participant_profile originating_node - payment_instruction responding_node - payment_instruction)
  (:predicates
    (operator_token_available ?operator_authorization_token - operator_authorization_token)
    (instruction_routing_assigned ?payment_instruction - payment_instruction ?routing_option - routing_option)
    (instruction_finalized ?payment_instruction - payment_instruction)
    (instruction_assigned_account ?payment_instruction - payment_instruction ?payer_account - payer_account)
    (instruction_participant_profile_binding ?payment_instruction - payment_instruction ?participant_profile - participant_profile)
    (funding_agent_available ?funding_agent - funding_agent)
    (routing_option_available ?routing_option - routing_option)
    (instruction_correspondent_compatible ?payment_instruction - payment_instruction ?correspondent_code - correspondent_code)
    (instruction_final_released ?payment_instruction - payment_instruction)
    (originating_node_active ?payment_instruction - payment_instruction)
    (instruction_account_compatible ?payment_instruction - payment_instruction ?payer_account - payer_account)
    (execution_slot_available ?execution_slot - execution_slot)
    (fx_service_available ?fx_service - fx_service)
    (manifest_available ?release_manifest - release_manifest)
    (instruction_scheduled_flag ?payment_instruction - payment_instruction)
    (instruction_routing_compatible ?payment_instruction - payment_instruction ?routing_option - routing_option)
    (instruction_correspondent_assigned ?payment_instruction - payment_instruction ?correspondent_code - correspondent_code)
    (instruction_scheduled_on_slot ?payment_instruction - payment_instruction ?execution_slot - execution_slot)
    (instruction_consolidated ?payment_instruction - payment_instruction)
    (instruction_funding_compatible ?payment_instruction - payment_instruction ?funding_agent - funding_agent)
    (correspondent_code_available ?correspondent_code - correspondent_code)
    (responding_node_active ?payment_instruction - payment_instruction)
    (instruction_validated ?payment_instruction - payment_instruction)
    (instruction_liquidity_compatible ?payment_instruction - payment_instruction ?liquidity_reserve - liquidity_reserve)
    (instruction_liquidity_reserved ?payment_instruction - payment_instruction ?liquidity_reserve - liquidity_reserve)
    (instruction_fx_applied ?payment_instruction - payment_instruction)
    (instruction_manifest_assigned ?payment_instruction - payment_instruction ?release_manifest - release_manifest)
    (instruction_ready_for_release ?payment_instruction - payment_instruction)
    (instruction_fx_compatible ?payment_instruction - payment_instruction ?fx_service - fx_service)
    (instruction_registered ?payment_instruction - payment_instruction)
    (payer_account_available ?payer_account - payer_account)
    (instruction_account_reserved ?payment_instruction - payment_instruction)
    (file_validator_available ?file_validator - file_validator)
    (settlement_rail_available ?settlement_rail - settlement_rail)
    (instruction_funding_assigned ?payment_instruction - payment_instruction ?funding_agent - funding_agent)
    (instruction_committed_to_rail ?payment_instruction - payment_instruction ?settlement_rail - settlement_rail)
    (manifest_validation_confirmed ?payment_instruction - payment_instruction)
    (instruction_manifest_ready ?payment_instruction - payment_instruction)
    (instruction_rail_compatible ?payment_instruction - payment_instruction ?settlement_rail - settlement_rail)
    (liquidity_reserve_available ?liquidity_reserve - liquidity_reserve)
    (instruction_allowed_on_rail ?payment_instruction - payment_instruction ?settlement_rail - settlement_rail)
    (instruction_slot_compatible ?payment_instruction - payment_instruction ?execution_slot - execution_slot)
    (operator_override_flag ?payment_instruction - payment_instruction)
    (instruction_rail_bound ?payment_instruction - payment_instruction ?settlement_rail - settlement_rail)
  )
  (:action release_correspondent
    :parameters (?payment_instruction - payment_instruction ?correspondent_code - correspondent_code)
    :precondition
      (and
        (instruction_correspondent_assigned ?payment_instruction ?correspondent_code)
      )
    :effect
      (and
        (correspondent_code_available ?correspondent_code)
        (not
          (instruction_correspondent_assigned ?payment_instruction ?correspondent_code)
        )
      )
  )
  (:action grant_consolidation_with_funding
    :parameters (?payment_instruction - payment_instruction ?funding_agent - funding_agent ?correspondent_code - correspondent_code ?settlement_member_profile - settlement_member_profile)
    :precondition
      (and
        (not
          (instruction_consolidated ?payment_instruction)
        )
        (instruction_scheduled_flag ?payment_instruction)
        (instruction_validated ?payment_instruction)
        (instruction_correspondent_assigned ?payment_instruction ?correspondent_code)
        (instruction_participant_profile_binding ?payment_instruction ?settlement_member_profile)
        (instruction_funding_assigned ?payment_instruction ?funding_agent)
      )
    :effect
      (and
        (operator_override_flag ?payment_instruction)
        (instruction_consolidated ?payment_instruction)
      )
  )
  (:action finalize_and_trigger_release
    :parameters (?payment_instruction - payment_instruction)
    :precondition
      (and
        (instruction_validated ?payment_instruction)
        (instruction_account_reserved ?payment_instruction)
        (instruction_scheduled_flag ?payment_instruction)
        (instruction_registered ?payment_instruction)
        (instruction_manifest_ready ?payment_instruction)
        (not
          (instruction_final_released ?payment_instruction)
        )
        (originating_node_active ?payment_instruction)
        (instruction_consolidated ?payment_instruction)
      )
    :effect
      (and
        (instruction_final_released ?payment_instruction)
      )
  )
  (:action consolidate_preexecution
    :parameters (?payment_instruction - payment_instruction ?liquidity_reserve - liquidity_reserve ?routing_option - routing_option)
    :precondition
      (and
        (instruction_scheduled_flag ?payment_instruction)
        (instruction_fx_applied ?payment_instruction)
        (instruction_liquidity_reserved ?payment_instruction ?liquidity_reserve)
        (instruction_routing_assigned ?payment_instruction ?routing_option)
      )
    :effect
      (and
        (not
          (instruction_fx_applied ?payment_instruction)
        )
        (not
          (operator_override_flag ?payment_instruction)
        )
      )
  )
  (:action attach_manifest
    :parameters (?payment_instruction - payment_instruction ?release_manifest - release_manifest)
    :precondition
      (and
        (manifest_available ?release_manifest)
        (instruction_registered ?payment_instruction)
      )
    :effect
      (and
        (not
          (manifest_available ?release_manifest)
        )
        (instruction_manifest_assigned ?payment_instruction ?release_manifest)
      )
  )
  (:action grant_consolidation
    :parameters (?payment_instruction - payment_instruction ?liquidity_reserve - liquidity_reserve ?routing_option - routing_option ?clearing_member_profile - clearing_member_profile)
    :precondition
      (and
        (instruction_participant_profile_binding ?payment_instruction ?clearing_member_profile)
        (instruction_validated ?payment_instruction)
        (not
          (operator_override_flag ?payment_instruction)
        )
        (instruction_liquidity_reserved ?payment_instruction ?liquidity_reserve)
        (instruction_scheduled_flag ?payment_instruction)
        (instruction_routing_assigned ?payment_instruction ?routing_option)
        (not
          (instruction_consolidated ?payment_instruction)
        )
      )
    :effect
      (and
        (instruction_consolidated ?payment_instruction)
      )
  )
  (:action rail_acceptance_validate
    :parameters (?payment_instruction - payment_instruction ?settlement_rail - settlement_rail)
    :precondition
      (and
        (instruction_account_reserved ?payment_instruction)
        (instruction_rail_bound ?payment_instruction ?settlement_rail)
        (not
          (instruction_validated ?payment_instruction)
        )
      )
    :effect
      (and
        (instruction_validated ?payment_instruction)
        (not
          (operator_override_flag ?payment_instruction)
        )
      )
  )
  (:action reserve_funding_agent
    :parameters (?payment_instruction - payment_instruction ?funding_agent - funding_agent)
    :precondition
      (and
        (instruction_funding_compatible ?payment_instruction ?funding_agent)
        (instruction_registered ?payment_instruction)
        (funding_agent_available ?funding_agent)
      )
    :effect
      (and
        (instruction_funding_assigned ?payment_instruction ?funding_agent)
        (not
          (funding_agent_available ?funding_agent)
        )
      )
  )
  (:action reserve_liquidity
    :parameters (?payment_instruction - payment_instruction ?liquidity_reserve - liquidity_reserve)
    :precondition
      (and
        (instruction_registered ?payment_instruction)
        (liquidity_reserve_available ?liquidity_reserve)
        (instruction_liquidity_compatible ?payment_instruction ?liquidity_reserve)
      )
    :effect
      (and
        (not
          (liquidity_reserve_available ?liquidity_reserve)
        )
        (instruction_liquidity_reserved ?payment_instruction ?liquidity_reserve)
      )
  )
  (:action release_funding_agent
    :parameters (?payment_instruction - payment_instruction ?funding_agent - funding_agent)
    :precondition
      (and
        (instruction_funding_assigned ?payment_instruction ?funding_agent)
      )
    :effect
      (and
        (funding_agent_available ?funding_agent)
        (not
          (instruction_funding_assigned ?payment_instruction ?funding_agent)
        )
      )
  )
  (:action release_routing
    :parameters (?payment_instruction - payment_instruction ?routing_option - routing_option)
    :precondition
      (and
        (instruction_routing_assigned ?payment_instruction ?routing_option)
      )
    :effect
      (and
        (routing_option_available ?routing_option)
        (not
          (instruction_routing_assigned ?payment_instruction ?routing_option)
        )
      )
  )
  (:action commit_to_rail
    :parameters (?payment_instruction - payment_instruction ?settlement_rail - settlement_rail)
    :precondition
      (and
        (instruction_manifest_ready ?payment_instruction)
        (settlement_rail_available ?settlement_rail)
        (instruction_rail_compatible ?payment_instruction ?settlement_rail)
      )
    :effect
      (and
        (instruction_committed_to_rail ?payment_instruction ?settlement_rail)
        (not
          (settlement_rail_available ?settlement_rail)
        )
      )
  )
  (:action reserve_routing
    :parameters (?payment_instruction - payment_instruction ?routing_option - routing_option)
    :precondition
      (and
        (instruction_registered ?payment_instruction)
        (routing_option_available ?routing_option)
        (instruction_routing_compatible ?payment_instruction ?routing_option)
      )
    :effect
      (and
        (instruction_routing_assigned ?payment_instruction ?routing_option)
        (not
          (routing_option_available ?routing_option)
        )
      )
  )
  (:action schedule_execution_slot
    :parameters (?payment_instruction - payment_instruction ?execution_slot - execution_slot ?liquidity_reserve - liquidity_reserve ?routing_option - routing_option)
    :precondition
      (and
        (instruction_account_reserved ?payment_instruction)
        (execution_slot_available ?execution_slot)
        (instruction_slot_compatible ?payment_instruction ?execution_slot)
        (not
          (instruction_scheduled_flag ?payment_instruction)
        )
        (instruction_routing_assigned ?payment_instruction ?routing_option)
        (instruction_liquidity_reserved ?payment_instruction ?liquidity_reserve)
      )
    :effect
      (and
        (instruction_scheduled_on_slot ?payment_instruction ?execution_slot)
        (not
          (execution_slot_available ?execution_slot)
        )
        (instruction_scheduled_flag ?payment_instruction)
      )
  )
  (:action apply_final_authorization
    :parameters (?payment_instruction - payment_instruction ?liquidity_reserve - liquidity_reserve ?routing_option - routing_option)
    :precondition
      (and
        (instruction_liquidity_reserved ?payment_instruction ?liquidity_reserve)
        (instruction_consolidated ?payment_instruction)
        (instruction_routing_assigned ?payment_instruction ?routing_option)
        (operator_override_flag ?payment_instruction)
      )
    :effect
      (and
        (not
          (instruction_fx_applied ?payment_instruction)
        )
        (not
          (operator_override_flag ?payment_instruction)
        )
        (not
          (instruction_validated ?payment_instruction)
        )
        (instruction_finalized ?payment_instruction)
      )
  )
  (:action detach_manifest
    :parameters (?payment_instruction - payment_instruction ?release_manifest - release_manifest)
    :precondition
      (and
        (instruction_manifest_assigned ?payment_instruction ?release_manifest)
      )
    :effect
      (and
        (manifest_available ?release_manifest)
        (not
          (instruction_manifest_assigned ?payment_instruction ?release_manifest)
        )
      )
  )
  (:action file_validate_instruction
    :parameters (?payment_instruction - payment_instruction ?release_manifest - release_manifest ?file_validator - file_validator)
    :precondition
      (and
        (not
          (instruction_validated ?payment_instruction)
        )
        (instruction_account_reserved ?payment_instruction)
        (file_validator_available ?file_validator)
        (instruction_manifest_assigned ?payment_instruction ?release_manifest)
        (manifest_validation_confirmed ?payment_instruction)
      )
    :effect
      (and
        (not
          (operator_override_flag ?payment_instruction)
        )
        (instruction_validated ?payment_instruction)
      )
  )
  (:action finalize_with_manifest_release
    :parameters (?payment_instruction - payment_instruction)
    :precondition
      (and
        (instruction_registered ?payment_instruction)
        (responding_node_active ?payment_instruction)
        (instruction_ready_for_release ?payment_instruction)
        (instruction_account_reserved ?payment_instruction)
        (instruction_validated ?payment_instruction)
        (not
          (instruction_final_released ?payment_instruction)
        )
        (instruction_manifest_ready ?payment_instruction)
        (instruction_scheduled_flag ?payment_instruction)
        (instruction_consolidated ?payment_instruction)
      )
    :effect
      (and
        (instruction_final_released ?payment_instruction)
      )
  )
  (:action mark_ready_for_release
    :parameters (?payment_instruction - payment_instruction ?release_manifest - release_manifest ?file_validator - file_validator)
    :precondition
      (and
        (instruction_validated ?payment_instruction)
        (file_validator_available ?file_validator)
        (not
          (instruction_ready_for_release ?payment_instruction)
        )
        (instruction_manifest_ready ?payment_instruction)
        (instruction_registered ?payment_instruction)
        (responding_node_active ?payment_instruction)
        (instruction_manifest_assigned ?payment_instruction ?release_manifest)
      )
    :effect
      (and
        (instruction_ready_for_release ?payment_instruction)
      )
  )
  (:action release_liquidity
    :parameters (?payment_instruction - payment_instruction ?liquidity_reserve - liquidity_reserve)
    :precondition
      (and
        (instruction_liquidity_reserved ?payment_instruction ?liquidity_reserve)
      )
    :effect
      (and
        (liquidity_reserve_available ?liquidity_reserve)
        (not
          (instruction_liquidity_reserved ?payment_instruction ?liquidity_reserve)
        )
      )
  )
  (:action reserve_correspondent
    :parameters (?payment_instruction - payment_instruction ?correspondent_code - correspondent_code)
    :precondition
      (and
        (correspondent_code_available ?correspondent_code)
        (instruction_registered ?payment_instruction)
        (instruction_correspondent_compatible ?payment_instruction ?correspondent_code)
      )
    :effect
      (and
        (instruction_correspondent_assigned ?payment_instruction ?correspondent_code)
        (not
          (correspondent_code_available ?correspondent_code)
        )
      )
  )
  (:action create_instruction
    :parameters (?payment_instruction - payment_instruction)
    :precondition
      (and
        (not
          (instruction_registered ?payment_instruction)
        )
        (not
          (instruction_final_released ?payment_instruction)
        )
      )
    :effect
      (and
        (instruction_registered ?payment_instruction)
      )
  )
  (:action operator_approve
    :parameters (?payment_instruction - payment_instruction ?operator_authorization_token - operator_authorization_token)
    :precondition
      (and
        (not
          (manifest_validation_confirmed ?payment_instruction)
        )
        (instruction_registered ?payment_instruction)
        (operator_token_available ?operator_authorization_token)
        (instruction_account_reserved ?payment_instruction)
      )
    :effect
      (and
        (operator_override_flag ?payment_instruction)
        (not
          (operator_token_available ?operator_authorization_token)
        )
        (manifest_validation_confirmed ?payment_instruction)
      )
  )
  (:action schedule_execution_with_fx
    :parameters (?payment_instruction - payment_instruction ?execution_slot - execution_slot ?funding_agent - funding_agent ?fx_service - fx_service)
    :precondition
      (and
        (fx_service_available ?fx_service)
        (instruction_fx_compatible ?payment_instruction ?fx_service)
        (not
          (instruction_scheduled_flag ?payment_instruction)
        )
        (instruction_account_reserved ?payment_instruction)
        (execution_slot_available ?execution_slot)
        (instruction_slot_compatible ?payment_instruction ?execution_slot)
        (instruction_funding_assigned ?payment_instruction ?funding_agent)
      )
    :effect
      (and
        (instruction_scheduled_on_slot ?payment_instruction ?execution_slot)
        (not
          (fx_service_available ?fx_service)
        )
        (instruction_fx_applied ?payment_instruction)
        (not
          (execution_slot_available ?execution_slot)
        )
        (operator_override_flag ?payment_instruction)
        (instruction_scheduled_flag ?payment_instruction)
      )
  )
  (:action authorize_with_operator_token
    :parameters (?payment_instruction - payment_instruction ?operator_authorization_token - operator_authorization_token)
    :precondition
      (and
        (operator_token_available ?operator_authorization_token)
        (not
          (operator_override_flag ?payment_instruction)
        )
        (instruction_validated ?payment_instruction)
        (instruction_consolidated ?payment_instruction)
        (not
          (instruction_manifest_ready ?payment_instruction)
        )
      )
    :effect
      (and
        (instruction_manifest_ready ?payment_instruction)
        (not
          (operator_token_available ?operator_authorization_token)
        )
      )
  )
  (:action deallocate_payer_account
    :parameters (?payment_instruction - payment_instruction ?payer_account - payer_account)
    :precondition
      (and
        (instruction_assigned_account ?payment_instruction ?payer_account)
        (not
          (instruction_consolidated ?payment_instruction)
        )
        (not
          (instruction_scheduled_flag ?payment_instruction)
        )
      )
    :effect
      (and
        (not
          (instruction_assigned_account ?payment_instruction ?payer_account)
        )
        (payer_account_available ?payer_account)
        (not
          (instruction_account_reserved ?payment_instruction)
        )
        (not
          (manifest_validation_confirmed ?payment_instruction)
        )
        (not
          (instruction_finalized ?payment_instruction)
        )
        (not
          (instruction_validated ?payment_instruction)
        )
        (not
          (instruction_fx_applied ?payment_instruction)
        )
        (not
          (operator_override_flag ?payment_instruction)
        )
      )
  )
  (:action mark_manifest_ready
    :parameters (?payment_instruction - payment_instruction ?release_manifest - release_manifest)
    :precondition
      (and
        (not
          (instruction_manifest_ready ?payment_instruction)
        )
        (instruction_manifest_assigned ?payment_instruction ?release_manifest)
        (instruction_validated ?payment_instruction)
        (instruction_consolidated ?payment_instruction)
        (not
          (operator_override_flag ?payment_instruction)
        )
      )
    :effect
      (and
        (instruction_manifest_ready ?payment_instruction)
      )
  )
  (:action finalize_with_rail_binding
    :parameters (?payment_instruction - payment_instruction ?settlement_rail - settlement_rail)
    :precondition
      (and
        (instruction_manifest_ready ?payment_instruction)
        (instruction_consolidated ?payment_instruction)
        (instruction_scheduled_flag ?payment_instruction)
        (instruction_rail_bound ?payment_instruction ?settlement_rail)
        (instruction_validated ?payment_instruction)
        (instruction_account_reserved ?payment_instruction)
        (instruction_registered ?payment_instruction)
        (not
          (instruction_final_released ?payment_instruction)
        )
        (responding_node_active ?payment_instruction)
      )
    :effect
      (and
        (instruction_final_released ?payment_instruction)
      )
  )
  (:action confirm_manifest_association
    :parameters (?payment_instruction - payment_instruction ?release_manifest - release_manifest)
    :precondition
      (and
        (instruction_registered ?payment_instruction)
        (instruction_account_reserved ?payment_instruction)
        (not
          (manifest_validation_confirmed ?payment_instruction)
        )
        (instruction_manifest_assigned ?payment_instruction ?release_manifest)
      )
    :effect
      (and
        (manifest_validation_confirmed ?payment_instruction)
      )
  )
  (:action allocate_payer_account
    :parameters (?payment_instruction - payment_instruction ?payer_account - payer_account)
    :precondition
      (and
        (not
          (instruction_account_reserved ?payment_instruction)
        )
        (instruction_registered ?payment_instruction)
        (payer_account_available ?payer_account)
        (instruction_account_compatible ?payment_instruction ?payer_account)
      )
    :effect
      (and
        (instruction_account_reserved ?payment_instruction)
        (not
          (payer_account_available ?payer_account)
        )
        (instruction_assigned_account ?payment_instruction ?payer_account)
      )
  )
  (:action reapply_validation
    :parameters (?payment_instruction - payment_instruction ?release_manifest - release_manifest ?file_validator - file_validator)
    :precondition
      (and
        (instruction_account_reserved ?payment_instruction)
        (not
          (instruction_validated ?payment_instruction)
        )
        (instruction_manifest_assigned ?payment_instruction ?release_manifest)
        (instruction_consolidated ?payment_instruction)
        (file_validator_available ?file_validator)
        (instruction_finalized ?payment_instruction)
      )
    :effect
      (and
        (instruction_validated ?payment_instruction)
      )
  )
  (:action bind_interparty_rail
    :parameters (?responding_party_node - responding_node ?originating_party_node - originating_node ?settlement_rail - settlement_rail)
    :precondition
      (and
        (instruction_registered ?responding_party_node)
        (instruction_committed_to_rail ?originating_party_node ?settlement_rail)
        (responding_node_active ?responding_party_node)
        (not
          (instruction_rail_bound ?responding_party_node ?settlement_rail)
        )
        (instruction_allowed_on_rail ?responding_party_node ?settlement_rail)
      )
    :effect
      (and
        (instruction_rail_bound ?responding_party_node ?settlement_rail)
      )
  )
)

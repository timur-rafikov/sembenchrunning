(define (domain treasury_liquidity_priority_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types object_root - object resource_type_root - object_root source_category_root - object_root instruction_component_root - object_root obligation_group - object_root funding_subject - obligation_group liquidity_source - resource_type_root incoming_cash_flow - resource_type_root payment_channel - resource_type_root approval_token - resource_type_root execution_profile - resource_type_root source_priority_profile - resource_type_root transfer_method - resource_type_root compliance_check - resource_type_root buffer_account - source_category_root funding_pool - source_category_root override_token - source_category_root primary_source_id - instruction_component_root secondary_source_id - instruction_component_root funding_instruction - instruction_component_root entity_group_primary - funding_subject entity_group_secondary - funding_subject entity_account_primary - entity_group_primary entity_account_secondary - entity_group_primary treasury_agent - entity_group_secondary)

  (:predicates
    (subject_detected ?settlement_obligation - funding_subject)
    (eligible_for_funding ?settlement_obligation - funding_subject)
    (subject_source_reserved ?settlement_obligation - funding_subject)
    (funding_settled ?settlement_obligation - funding_subject)
    (funding_confirmed_for_subject ?settlement_obligation - funding_subject)
    (funding_allocated_for_subject ?settlement_obligation - funding_subject)
    (source_available ?liquidity_source - liquidity_source)
    (assigned_liquidity_source ?settlement_obligation - funding_subject ?liquidity_source - liquidity_source)
    (incoming_flow_available ?incoming_cash_flow - incoming_cash_flow)
    (inflow_attached_to_subject ?settlement_obligation - funding_subject ?incoming_cash_flow - incoming_cash_flow)
    (channel_available ?payment_channel - payment_channel)
    (channel_reserved_for_subject ?settlement_obligation - funding_subject ?payment_channel - payment_channel)
    (buffer_available ?buffer_account - buffer_account)
    (primary_buffer_assigned ?entity_account_primary - entity_account_primary ?buffer_account - buffer_account)
    (secondary_buffer_assigned ?entity_account_secondary - entity_account_secondary ?buffer_account - buffer_account)
    (primary_source_assigned ?entity_account_primary - entity_account_primary ?primary_source_id - primary_source_id)
    (primary_source_ready ?primary_source_id - primary_source_id)
    (primary_source_buffer_engaged ?primary_source_id - primary_source_id)
    (primary_source_confirmed ?entity_account_primary - entity_account_primary)
    (secondary_source_assigned ?entity_account_secondary - entity_account_secondary ?secondary_source_id - secondary_source_id)
    (secondary_source_ready ?secondary_source_id - secondary_source_id)
    (secondary_source_buffer_engaged ?secondary_source_id - secondary_source_id)
    (secondary_source_confirmed ?entity_account_secondary - entity_account_secondary)
    (instruction_created ?funding_instruction - funding_instruction)
    (instruction_ready ?funding_instruction - funding_instruction)
    (instruction_primary_source_set ?funding_instruction - funding_instruction ?primary_source_id - primary_source_id)
    (instruction_secondary_source_set ?funding_instruction - funding_instruction ?secondary_source_id - secondary_source_id)
    (instruction_special_handling_flag ?funding_instruction - funding_instruction)
    (instruction_additional_approval_flag ?funding_instruction - funding_instruction)
    (instruction_timing_activated ?funding_instruction - funding_instruction)
    (agent_primary_account_link ?treasury_agent - treasury_agent ?entity_account_primary - entity_account_primary)
    (agent_secondary_account_link ?treasury_agent - treasury_agent ?entity_account_secondary - entity_account_secondary)
    (agent_assigned_instruction ?treasury_agent - treasury_agent ?funding_instruction - funding_instruction)
    (funding_pool_available ?funding_pool - funding_pool)
    (agent_assigned_pool ?treasury_agent - treasury_agent ?funding_pool - funding_pool)
    (funding_pool_locked ?funding_pool - funding_pool)
    (pool_assigned_to_instruction ?funding_pool - funding_pool ?funding_instruction - funding_instruction)
    (agent_validated ?treasury_agent - treasury_agent)
    (agent_approved ?treasury_agent - treasury_agent)
    (agent_execution_ready ?treasury_agent - treasury_agent)
    (agent_approval_assigned ?treasury_agent - treasury_agent)
    (agent_pool_assignment_confirmed ?treasury_agent - treasury_agent)
    (agent_profile_configured ?treasury_agent - treasury_agent)
    (agent_transfer_method_validated ?treasury_agent - treasury_agent)
    (override_token_available ?override_token - override_token)
    (agent_override_linked ?treasury_agent - treasury_agent ?override_token - override_token)
    (override_applied ?treasury_agent - treasury_agent)
    (approval_granted ?treasury_agent - treasury_agent)
    (approval_recorded ?treasury_agent - treasury_agent)
    (approval_token_available ?approval_token - approval_token)
    (agent_approval_token_assigned ?treasury_agent - treasury_agent ?approval_token - approval_token)
    (execution_profile_available ?execution_profile - execution_profile)
    (agent_execution_profile_assigned ?treasury_agent - treasury_agent ?execution_profile - execution_profile)
    (transfer_method_available ?transfer_method - transfer_method)
    (agent_transfer_method_assigned ?treasury_agent - treasury_agent ?transfer_method - transfer_method)
    (compliance_check_available ?compliance_check - compliance_check)
    (agent_compliance_linked ?treasury_agent - treasury_agent ?compliance_check - compliance_check)
    (source_priority_profile_available ?source_priority_profile - source_priority_profile)
    (subject_assigned_priority_profile ?settlement_obligation - funding_subject ?source_priority_profile - source_priority_profile)
    (primary_ready_flag ?entity_account_primary - entity_account_primary)
    (secondary_ready_flag ?entity_account_secondary - entity_account_secondary)
    (agent_locked_for_execution ?treasury_agent - treasury_agent)
  )
  (:action register_obligation
    :parameters (?settlement_obligation - funding_subject)
    :precondition
      (and
        (not
          (subject_detected ?settlement_obligation)
        )
        (not
          (funding_settled ?settlement_obligation)
        )
      )
    :effect (subject_detected ?settlement_obligation)
  )
  (:action reserve_source_for_obligation
    :parameters (?settlement_obligation - funding_subject ?liquidity_source - liquidity_source)
    :precondition
      (and
        (subject_detected ?settlement_obligation)
        (not
          (subject_source_reserved ?settlement_obligation)
        )
        (source_available ?liquidity_source)
      )
    :effect
      (and
        (subject_source_reserved ?settlement_obligation)
        (assigned_liquidity_source ?settlement_obligation ?liquidity_source)
        (not
          (source_available ?liquidity_source)
        )
      )
  )
  (:action attach_incoming_flow
    :parameters (?settlement_obligation - funding_subject ?incoming_cash_flow - incoming_cash_flow)
    :precondition
      (and
        (subject_detected ?settlement_obligation)
        (subject_source_reserved ?settlement_obligation)
        (incoming_flow_available ?incoming_cash_flow)
      )
    :effect
      (and
        (inflow_attached_to_subject ?settlement_obligation ?incoming_cash_flow)
        (not
          (incoming_flow_available ?incoming_cash_flow)
        )
      )
  )
  (:action mark_obligation_eligible
    :parameters (?settlement_obligation - funding_subject ?incoming_cash_flow - incoming_cash_flow)
    :precondition
      (and
        (subject_detected ?settlement_obligation)
        (subject_source_reserved ?settlement_obligation)
        (inflow_attached_to_subject ?settlement_obligation ?incoming_cash_flow)
        (not
          (eligible_for_funding ?settlement_obligation)
        )
      )
    :effect (eligible_for_funding ?settlement_obligation)
  )
  (:action release_incoming_flow
    :parameters (?settlement_obligation - funding_subject ?incoming_cash_flow - incoming_cash_flow)
    :precondition
      (and
        (inflow_attached_to_subject ?settlement_obligation ?incoming_cash_flow)
      )
    :effect
      (and
        (incoming_flow_available ?incoming_cash_flow)
        (not
          (inflow_attached_to_subject ?settlement_obligation ?incoming_cash_flow)
        )
      )
  )
  (:action reserve_payment_channel
    :parameters (?settlement_obligation - funding_subject ?payment_channel - payment_channel)
    :precondition
      (and
        (eligible_for_funding ?settlement_obligation)
        (channel_available ?payment_channel)
      )
    :effect
      (and
        (channel_reserved_for_subject ?settlement_obligation ?payment_channel)
        (not
          (channel_available ?payment_channel)
        )
      )
  )
  (:action release_payment_channel
    :parameters (?settlement_obligation - funding_subject ?payment_channel - payment_channel)
    :precondition
      (and
        (channel_reserved_for_subject ?settlement_obligation ?payment_channel)
      )
    :effect
      (and
        (channel_available ?payment_channel)
        (not
          (channel_reserved_for_subject ?settlement_obligation ?payment_channel)
        )
      )
  )
  (:action assign_transfer_method_to_agent
    :parameters (?treasury_agent - treasury_agent ?transfer_method - transfer_method)
    :precondition
      (and
        (eligible_for_funding ?treasury_agent)
        (transfer_method_available ?transfer_method)
      )
    :effect
      (and
        (agent_transfer_method_assigned ?treasury_agent ?transfer_method)
        (not
          (transfer_method_available ?transfer_method)
        )
      )
  )
  (:action release_transfer_method_from_agent
    :parameters (?treasury_agent - treasury_agent ?transfer_method - transfer_method)
    :precondition
      (and
        (agent_transfer_method_assigned ?treasury_agent ?transfer_method)
      )
    :effect
      (and
        (transfer_method_available ?transfer_method)
        (not
          (agent_transfer_method_assigned ?treasury_agent ?transfer_method)
        )
      )
  )
  (:action assign_compliance_check_to_agent
    :parameters (?treasury_agent - treasury_agent ?compliance_check - compliance_check)
    :precondition
      (and
        (eligible_for_funding ?treasury_agent)
        (compliance_check_available ?compliance_check)
      )
    :effect
      (and
        (agent_compliance_linked ?treasury_agent ?compliance_check)
        (not
          (compliance_check_available ?compliance_check)
        )
      )
  )
  (:action release_compliance_check_from_agent
    :parameters (?treasury_agent - treasury_agent ?compliance_check - compliance_check)
    :precondition
      (and
        (agent_compliance_linked ?treasury_agent ?compliance_check)
      )
    :effect
      (and
        (compliance_check_available ?compliance_check)
        (not
          (agent_compliance_linked ?treasury_agent ?compliance_check)
        )
      )
  )
  (:action evaluate_primary_source
    :parameters (?entity_account_primary - entity_account_primary ?primary_source_id - primary_source_id ?incoming_cash_flow - incoming_cash_flow)
    :precondition
      (and
        (eligible_for_funding ?entity_account_primary)
        (inflow_attached_to_subject ?entity_account_primary ?incoming_cash_flow)
        (primary_source_assigned ?entity_account_primary ?primary_source_id)
        (not
          (primary_source_ready ?primary_source_id)
        )
        (not
          (primary_source_buffer_engaged ?primary_source_id)
        )
      )
    :effect (primary_source_ready ?primary_source_id)
  )
  (:action confirm_primary_source_with_channel
    :parameters (?entity_account_primary - entity_account_primary ?primary_source_id - primary_source_id ?payment_channel - payment_channel)
    :precondition
      (and
        (eligible_for_funding ?entity_account_primary)
        (channel_reserved_for_subject ?entity_account_primary ?payment_channel)
        (primary_source_assigned ?entity_account_primary ?primary_source_id)
        (primary_source_ready ?primary_source_id)
        (not
          (primary_ready_flag ?entity_account_primary)
        )
      )
    :effect
      (and
        (primary_ready_flag ?entity_account_primary)
        (primary_source_confirmed ?entity_account_primary)
      )
  )
  (:action engage_primary_buffer
    :parameters (?entity_account_primary - entity_account_primary ?primary_source_id - primary_source_id ?buffer_account - buffer_account)
    :precondition
      (and
        (eligible_for_funding ?entity_account_primary)
        (primary_source_assigned ?entity_account_primary ?primary_source_id)
        (buffer_available ?buffer_account)
        (not
          (primary_ready_flag ?entity_account_primary)
        )
      )
    :effect
      (and
        (primary_source_buffer_engaged ?primary_source_id)
        (primary_ready_flag ?entity_account_primary)
        (primary_buffer_assigned ?entity_account_primary ?buffer_account)
        (not
          (buffer_available ?buffer_account)
        )
      )
  )
  (:action finalize_primary_source_evaluation
    :parameters (?entity_account_primary - entity_account_primary ?primary_source_id - primary_source_id ?incoming_cash_flow - incoming_cash_flow ?buffer_account - buffer_account)
    :precondition
      (and
        (eligible_for_funding ?entity_account_primary)
        (inflow_attached_to_subject ?entity_account_primary ?incoming_cash_flow)
        (primary_source_assigned ?entity_account_primary ?primary_source_id)
        (primary_source_buffer_engaged ?primary_source_id)
        (primary_buffer_assigned ?entity_account_primary ?buffer_account)
        (not
          (primary_source_confirmed ?entity_account_primary)
        )
      )
    :effect
      (and
        (primary_source_ready ?primary_source_id)
        (primary_source_confirmed ?entity_account_primary)
        (buffer_available ?buffer_account)
        (not
          (primary_buffer_assigned ?entity_account_primary ?buffer_account)
        )
      )
  )
  (:action evaluate_secondary_source
    :parameters (?entity_account_secondary - entity_account_secondary ?secondary_source_id - secondary_source_id ?incoming_cash_flow - incoming_cash_flow)
    :precondition
      (and
        (eligible_for_funding ?entity_account_secondary)
        (inflow_attached_to_subject ?entity_account_secondary ?incoming_cash_flow)
        (secondary_source_assigned ?entity_account_secondary ?secondary_source_id)
        (not
          (secondary_source_ready ?secondary_source_id)
        )
        (not
          (secondary_source_buffer_engaged ?secondary_source_id)
        )
      )
    :effect (secondary_source_ready ?secondary_source_id)
  )
  (:action confirm_secondary_source_with_channel
    :parameters (?entity_account_secondary - entity_account_secondary ?secondary_source_id - secondary_source_id ?payment_channel - payment_channel)
    :precondition
      (and
        (eligible_for_funding ?entity_account_secondary)
        (channel_reserved_for_subject ?entity_account_secondary ?payment_channel)
        (secondary_source_assigned ?entity_account_secondary ?secondary_source_id)
        (secondary_source_ready ?secondary_source_id)
        (not
          (secondary_ready_flag ?entity_account_secondary)
        )
      )
    :effect
      (and
        (secondary_ready_flag ?entity_account_secondary)
        (secondary_source_confirmed ?entity_account_secondary)
      )
  )
  (:action engage_secondary_buffer
    :parameters (?entity_account_secondary - entity_account_secondary ?secondary_source_id - secondary_source_id ?buffer_account - buffer_account)
    :precondition
      (and
        (eligible_for_funding ?entity_account_secondary)
        (secondary_source_assigned ?entity_account_secondary ?secondary_source_id)
        (buffer_available ?buffer_account)
        (not
          (secondary_ready_flag ?entity_account_secondary)
        )
      )
    :effect
      (and
        (secondary_source_buffer_engaged ?secondary_source_id)
        (secondary_ready_flag ?entity_account_secondary)
        (secondary_buffer_assigned ?entity_account_secondary ?buffer_account)
        (not
          (buffer_available ?buffer_account)
        )
      )
  )
  (:action finalize_secondary_source_evaluation
    :parameters (?entity_account_secondary - entity_account_secondary ?secondary_source_id - secondary_source_id ?incoming_cash_flow - incoming_cash_flow ?buffer_account - buffer_account)
    :precondition
      (and
        (eligible_for_funding ?entity_account_secondary)
        (inflow_attached_to_subject ?entity_account_secondary ?incoming_cash_flow)
        (secondary_source_assigned ?entity_account_secondary ?secondary_source_id)
        (secondary_source_buffer_engaged ?secondary_source_id)
        (secondary_buffer_assigned ?entity_account_secondary ?buffer_account)
        (not
          (secondary_source_confirmed ?entity_account_secondary)
        )
      )
    :effect
      (and
        (secondary_source_ready ?secondary_source_id)
        (secondary_source_confirmed ?entity_account_secondary)
        (buffer_available ?buffer_account)
        (not
          (secondary_buffer_assigned ?entity_account_secondary ?buffer_account)
        )
      )
  )
  (:action compose_instruction_standard
    :parameters (?entity_account_primary - entity_account_primary ?entity_account_secondary - entity_account_secondary ?primary_source_id - primary_source_id ?secondary_source_id - secondary_source_id ?funding_instruction - funding_instruction)
    :precondition
      (and
        (primary_ready_flag ?entity_account_primary)
        (secondary_ready_flag ?entity_account_secondary)
        (primary_source_assigned ?entity_account_primary ?primary_source_id)
        (secondary_source_assigned ?entity_account_secondary ?secondary_source_id)
        (primary_source_ready ?primary_source_id)
        (secondary_source_ready ?secondary_source_id)
        (primary_source_confirmed ?entity_account_primary)
        (secondary_source_confirmed ?entity_account_secondary)
        (instruction_created ?funding_instruction)
      )
    :effect
      (and
        (instruction_ready ?funding_instruction)
        (instruction_primary_source_set ?funding_instruction ?primary_source_id)
        (instruction_secondary_source_set ?funding_instruction ?secondary_source_id)
        (not
          (instruction_created ?funding_instruction)
        )
      )
  )
  (:action compose_instruction_with_special_handling
    :parameters (?entity_account_primary - entity_account_primary ?entity_account_secondary - entity_account_secondary ?primary_source_id - primary_source_id ?secondary_source_id - secondary_source_id ?funding_instruction - funding_instruction)
    :precondition
      (and
        (primary_ready_flag ?entity_account_primary)
        (secondary_ready_flag ?entity_account_secondary)
        (primary_source_assigned ?entity_account_primary ?primary_source_id)
        (secondary_source_assigned ?entity_account_secondary ?secondary_source_id)
        (primary_source_buffer_engaged ?primary_source_id)
        (secondary_source_ready ?secondary_source_id)
        (not
          (primary_source_confirmed ?entity_account_primary)
        )
        (secondary_source_confirmed ?entity_account_secondary)
        (instruction_created ?funding_instruction)
      )
    :effect
      (and
        (instruction_ready ?funding_instruction)
        (instruction_primary_source_set ?funding_instruction ?primary_source_id)
        (instruction_secondary_source_set ?funding_instruction ?secondary_source_id)
        (instruction_special_handling_flag ?funding_instruction)
        (not
          (instruction_created ?funding_instruction)
        )
      )
  )
  (:action compose_instruction_with_additional_approval
    :parameters (?entity_account_primary - entity_account_primary ?entity_account_secondary - entity_account_secondary ?primary_source_id - primary_source_id ?secondary_source_id - secondary_source_id ?funding_instruction - funding_instruction)
    :precondition
      (and
        (primary_ready_flag ?entity_account_primary)
        (secondary_ready_flag ?entity_account_secondary)
        (primary_source_assigned ?entity_account_primary ?primary_source_id)
        (secondary_source_assigned ?entity_account_secondary ?secondary_source_id)
        (primary_source_ready ?primary_source_id)
        (secondary_source_buffer_engaged ?secondary_source_id)
        (primary_source_confirmed ?entity_account_primary)
        (not
          (secondary_source_confirmed ?entity_account_secondary)
        )
        (instruction_created ?funding_instruction)
      )
    :effect
      (and
        (instruction_ready ?funding_instruction)
        (instruction_primary_source_set ?funding_instruction ?primary_source_id)
        (instruction_secondary_source_set ?funding_instruction ?secondary_source_id)
        (instruction_additional_approval_flag ?funding_instruction)
        (not
          (instruction_created ?funding_instruction)
        )
      )
  )
  (:action compose_instruction_special_and_approval
    :parameters (?entity_account_primary - entity_account_primary ?entity_account_secondary - entity_account_secondary ?primary_source_id - primary_source_id ?secondary_source_id - secondary_source_id ?funding_instruction - funding_instruction)
    :precondition
      (and
        (primary_ready_flag ?entity_account_primary)
        (secondary_ready_flag ?entity_account_secondary)
        (primary_source_assigned ?entity_account_primary ?primary_source_id)
        (secondary_source_assigned ?entity_account_secondary ?secondary_source_id)
        (primary_source_buffer_engaged ?primary_source_id)
        (secondary_source_buffer_engaged ?secondary_source_id)
        (not
          (primary_source_confirmed ?entity_account_primary)
        )
        (not
          (secondary_source_confirmed ?entity_account_secondary)
        )
        (instruction_created ?funding_instruction)
      )
    :effect
      (and
        (instruction_ready ?funding_instruction)
        (instruction_primary_source_set ?funding_instruction ?primary_source_id)
        (instruction_secondary_source_set ?funding_instruction ?secondary_source_id)
        (instruction_special_handling_flag ?funding_instruction)
        (instruction_additional_approval_flag ?funding_instruction)
        (not
          (instruction_created ?funding_instruction)
        )
      )
  )
  (:action activate_instruction_timing
    :parameters (?funding_instruction - funding_instruction ?entity_account_primary - entity_account_primary ?incoming_cash_flow - incoming_cash_flow)
    :precondition
      (and
        (instruction_ready ?funding_instruction)
        (primary_ready_flag ?entity_account_primary)
        (inflow_attached_to_subject ?entity_account_primary ?incoming_cash_flow)
        (not
          (instruction_timing_activated ?funding_instruction)
        )
      )
    :effect (instruction_timing_activated ?funding_instruction)
  )
  (:action lock_pool_and_assign_to_instruction
    :parameters (?treasury_agent - treasury_agent ?funding_pool - funding_pool ?funding_instruction - funding_instruction)
    :precondition
      (and
        (eligible_for_funding ?treasury_agent)
        (agent_assigned_instruction ?treasury_agent ?funding_instruction)
        (agent_assigned_pool ?treasury_agent ?funding_pool)
        (funding_pool_available ?funding_pool)
        (instruction_ready ?funding_instruction)
        (instruction_timing_activated ?funding_instruction)
        (not
          (funding_pool_locked ?funding_pool)
        )
      )
    :effect
      (and
        (funding_pool_locked ?funding_pool)
        (pool_assigned_to_instruction ?funding_pool ?funding_instruction)
        (not
          (funding_pool_available ?funding_pool)
        )
      )
  )
  (:action validate_agent_for_instruction
    :parameters (?treasury_agent - treasury_agent ?funding_pool - funding_pool ?funding_instruction - funding_instruction ?incoming_cash_flow - incoming_cash_flow)
    :precondition
      (and
        (eligible_for_funding ?treasury_agent)
        (agent_assigned_pool ?treasury_agent ?funding_pool)
        (funding_pool_locked ?funding_pool)
        (pool_assigned_to_instruction ?funding_pool ?funding_instruction)
        (inflow_attached_to_subject ?treasury_agent ?incoming_cash_flow)
        (not
          (instruction_special_handling_flag ?funding_instruction)
        )
        (not
          (agent_validated ?treasury_agent)
        )
      )
    :effect (agent_validated ?treasury_agent)
  )
  (:action assign_approval_token_to_agent
    :parameters (?treasury_agent - treasury_agent ?approval_token - approval_token)
    :precondition
      (and
        (eligible_for_funding ?treasury_agent)
        (approval_token_available ?approval_token)
        (not
          (agent_approval_assigned ?treasury_agent)
        )
      )
    :effect
      (and
        (agent_approval_assigned ?treasury_agent)
        (agent_approval_token_assigned ?treasury_agent ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action confirm_agent_pool_assignment
    :parameters (?treasury_agent - treasury_agent ?funding_pool - funding_pool ?funding_instruction - funding_instruction ?incoming_cash_flow - incoming_cash_flow ?approval_token - approval_token)
    :precondition
      (and
        (eligible_for_funding ?treasury_agent)
        (agent_assigned_pool ?treasury_agent ?funding_pool)
        (funding_pool_locked ?funding_pool)
        (pool_assigned_to_instruction ?funding_pool ?funding_instruction)
        (inflow_attached_to_subject ?treasury_agent ?incoming_cash_flow)
        (instruction_special_handling_flag ?funding_instruction)
        (agent_approval_assigned ?treasury_agent)
        (agent_approval_token_assigned ?treasury_agent ?approval_token)
        (not
          (agent_validated ?treasury_agent)
        )
      )
    :effect
      (and
        (agent_validated ?treasury_agent)
        (agent_pool_assignment_confirmed ?treasury_agent)
      )
  )
  (:action apply_transfer_method_approval
    :parameters (?treasury_agent - treasury_agent ?transfer_method - transfer_method ?payment_channel - payment_channel ?funding_pool - funding_pool ?funding_instruction - funding_instruction)
    :precondition
      (and
        (agent_validated ?treasury_agent)
        (agent_transfer_method_assigned ?treasury_agent ?transfer_method)
        (channel_reserved_for_subject ?treasury_agent ?payment_channel)
        (agent_assigned_pool ?treasury_agent ?funding_pool)
        (pool_assigned_to_instruction ?funding_pool ?funding_instruction)
        (not
          (instruction_additional_approval_flag ?funding_instruction)
        )
        (not
          (agent_approved ?treasury_agent)
        )
      )
    :effect (agent_approved ?treasury_agent)
  )
  (:action confirm_transfer_method_approval
    :parameters (?treasury_agent - treasury_agent ?transfer_method - transfer_method ?payment_channel - payment_channel ?funding_pool - funding_pool ?funding_instruction - funding_instruction)
    :precondition
      (and
        (agent_validated ?treasury_agent)
        (agent_transfer_method_assigned ?treasury_agent ?transfer_method)
        (channel_reserved_for_subject ?treasury_agent ?payment_channel)
        (agent_assigned_pool ?treasury_agent ?funding_pool)
        (pool_assigned_to_instruction ?funding_pool ?funding_instruction)
        (instruction_additional_approval_flag ?funding_instruction)
        (not
          (agent_approved ?treasury_agent)
        )
      )
    :effect (agent_approved ?treasury_agent)
  )
  (:action authorize_agent_after_compliance
    :parameters (?treasury_agent - treasury_agent ?compliance_check - compliance_check ?funding_pool - funding_pool ?funding_instruction - funding_instruction)
    :precondition
      (and
        (agent_approved ?treasury_agent)
        (agent_compliance_linked ?treasury_agent ?compliance_check)
        (agent_assigned_pool ?treasury_agent ?funding_pool)
        (pool_assigned_to_instruction ?funding_pool ?funding_instruction)
        (not
          (instruction_special_handling_flag ?funding_instruction)
        )
        (not
          (instruction_additional_approval_flag ?funding_instruction)
        )
        (not
          (agent_execution_ready ?treasury_agent)
        )
      )
    :effect (agent_execution_ready ?treasury_agent)
  )
  (:action authorize_agent_and_register_profile
    :parameters (?treasury_agent - treasury_agent ?compliance_check - compliance_check ?funding_pool - funding_pool ?funding_instruction - funding_instruction)
    :precondition
      (and
        (agent_approved ?treasury_agent)
        (agent_compliance_linked ?treasury_agent ?compliance_check)
        (agent_assigned_pool ?treasury_agent ?funding_pool)
        (pool_assigned_to_instruction ?funding_pool ?funding_instruction)
        (instruction_special_handling_flag ?funding_instruction)
        (not
          (instruction_additional_approval_flag ?funding_instruction)
        )
        (not
          (agent_execution_ready ?treasury_agent)
        )
      )
    :effect
      (and
        (agent_execution_ready ?treasury_agent)
        (agent_profile_configured ?treasury_agent)
      )
  )
  (:action authorize_agent_and_register_profile_variant1
    :parameters (?treasury_agent - treasury_agent ?compliance_check - compliance_check ?funding_pool - funding_pool ?funding_instruction - funding_instruction)
    :precondition
      (and
        (agent_approved ?treasury_agent)
        (agent_compliance_linked ?treasury_agent ?compliance_check)
        (agent_assigned_pool ?treasury_agent ?funding_pool)
        (pool_assigned_to_instruction ?funding_pool ?funding_instruction)
        (not
          (instruction_special_handling_flag ?funding_instruction)
        )
        (instruction_additional_approval_flag ?funding_instruction)
        (not
          (agent_execution_ready ?treasury_agent)
        )
      )
    :effect
      (and
        (agent_execution_ready ?treasury_agent)
        (agent_profile_configured ?treasury_agent)
      )
  )
  (:action authorize_agent_and_register_profile_variant2
    :parameters (?treasury_agent - treasury_agent ?compliance_check - compliance_check ?funding_pool - funding_pool ?funding_instruction - funding_instruction)
    :precondition
      (and
        (agent_approved ?treasury_agent)
        (agent_compliance_linked ?treasury_agent ?compliance_check)
        (agent_assigned_pool ?treasury_agent ?funding_pool)
        (pool_assigned_to_instruction ?funding_pool ?funding_instruction)
        (instruction_special_handling_flag ?funding_instruction)
        (instruction_additional_approval_flag ?funding_instruction)
        (not
          (agent_execution_ready ?treasury_agent)
        )
      )
    :effect
      (and
        (agent_execution_ready ?treasury_agent)
        (agent_profile_configured ?treasury_agent)
      )
  )
  (:action finalize_agent_readiness
    :parameters (?treasury_agent - treasury_agent)
    :precondition
      (and
        (agent_execution_ready ?treasury_agent)
        (not
          (agent_profile_configured ?treasury_agent)
        )
        (not
          (agent_locked_for_execution ?treasury_agent)
        )
      )
    :effect
      (and
        (agent_locked_for_execution ?treasury_agent)
        (funding_confirmed_for_subject ?treasury_agent)
      )
  )
  (:action assign_execution_profile_to_agent
    :parameters (?treasury_agent - treasury_agent ?execution_profile - execution_profile)
    :precondition
      (and
        (agent_execution_ready ?treasury_agent)
        (agent_profile_configured ?treasury_agent)
        (execution_profile_available ?execution_profile)
      )
    :effect
      (and
        (agent_execution_profile_assigned ?treasury_agent ?execution_profile)
        (not
          (execution_profile_available ?execution_profile)
        )
      )
  )
  (:action authorize_agent_for_execution
    :parameters (?treasury_agent - treasury_agent ?entity_account_primary - entity_account_primary ?entity_account_secondary - entity_account_secondary ?incoming_cash_flow - incoming_cash_flow ?execution_profile - execution_profile)
    :precondition
      (and
        (agent_execution_ready ?treasury_agent)
        (agent_profile_configured ?treasury_agent)
        (agent_execution_profile_assigned ?treasury_agent ?execution_profile)
        (agent_primary_account_link ?treasury_agent ?entity_account_primary)
        (agent_secondary_account_link ?treasury_agent ?entity_account_secondary)
        (primary_source_confirmed ?entity_account_primary)
        (secondary_source_confirmed ?entity_account_secondary)
        (inflow_attached_to_subject ?treasury_agent ?incoming_cash_flow)
        (not
          (agent_transfer_method_validated ?treasury_agent)
        )
      )
    :effect (agent_transfer_method_validated ?treasury_agent)
  )
  (:action confirm_agent_authorization
    :parameters (?treasury_agent - treasury_agent)
    :precondition
      (and
        (agent_execution_ready ?treasury_agent)
        (agent_transfer_method_validated ?treasury_agent)
        (not
          (agent_locked_for_execution ?treasury_agent)
        )
      )
    :effect
      (and
        (agent_locked_for_execution ?treasury_agent)
        (funding_confirmed_for_subject ?treasury_agent)
      )
  )
  (:action apply_override_token_to_agent
    :parameters (?treasury_agent - treasury_agent ?override_token - override_token ?incoming_cash_flow - incoming_cash_flow)
    :precondition
      (and
        (eligible_for_funding ?treasury_agent)
        (inflow_attached_to_subject ?treasury_agent ?incoming_cash_flow)
        (override_token_available ?override_token)
        (agent_override_linked ?treasury_agent ?override_token)
        (not
          (override_applied ?treasury_agent)
        )
      )
    :effect
      (and
        (override_applied ?treasury_agent)
        (not
          (override_token_available ?override_token)
        )
      )
  )
  (:action grant_approval_to_agent
    :parameters (?treasury_agent - treasury_agent ?payment_channel - payment_channel)
    :precondition
      (and
        (override_applied ?treasury_agent)
        (channel_reserved_for_subject ?treasury_agent ?payment_channel)
        (not
          (approval_granted ?treasury_agent)
        )
      )
    :effect (approval_granted ?treasury_agent)
  )
  (:action record_approval_with_compliance
    :parameters (?treasury_agent - treasury_agent ?compliance_check - compliance_check)
    :precondition
      (and
        (approval_granted ?treasury_agent)
        (agent_compliance_linked ?treasury_agent ?compliance_check)
        (not
          (approval_recorded ?treasury_agent)
        )
      )
    :effect (approval_recorded ?treasury_agent)
  )
  (:action finalize_approval_and_mark_agent_executable
    :parameters (?treasury_agent - treasury_agent)
    :precondition
      (and
        (approval_recorded ?treasury_agent)
        (not
          (agent_locked_for_execution ?treasury_agent)
        )
      )
    :effect
      (and
        (agent_locked_for_execution ?treasury_agent)
        (funding_confirmed_for_subject ?treasury_agent)
      )
  )
  (:action execute_funding_for_primary_account
    :parameters (?entity_account_primary - entity_account_primary ?funding_instruction - funding_instruction)
    :precondition
      (and
        (primary_ready_flag ?entity_account_primary)
        (primary_source_confirmed ?entity_account_primary)
        (instruction_ready ?funding_instruction)
        (instruction_timing_activated ?funding_instruction)
        (not
          (funding_confirmed_for_subject ?entity_account_primary)
        )
      )
    :effect (funding_confirmed_for_subject ?entity_account_primary)
  )
  (:action execute_funding_for_secondary_account
    :parameters (?entity_account_secondary - entity_account_secondary ?funding_instruction - funding_instruction)
    :precondition
      (and
        (secondary_ready_flag ?entity_account_secondary)
        (secondary_source_confirmed ?entity_account_secondary)
        (instruction_ready ?funding_instruction)
        (instruction_timing_activated ?funding_instruction)
        (not
          (funding_confirmed_for_subject ?entity_account_secondary)
        )
      )
    :effect (funding_confirmed_for_subject ?entity_account_secondary)
  )
  (:action record_funding_and_attach_priority_profile
    :parameters (?settlement_obligation - funding_subject ?source_priority_profile - source_priority_profile ?incoming_cash_flow - incoming_cash_flow)
    :precondition
      (and
        (funding_confirmed_for_subject ?settlement_obligation)
        (inflow_attached_to_subject ?settlement_obligation ?incoming_cash_flow)
        (source_priority_profile_available ?source_priority_profile)
        (not
          (funding_allocated_for_subject ?settlement_obligation)
        )
      )
    :effect
      (and
        (funding_allocated_for_subject ?settlement_obligation)
        (subject_assigned_priority_profile ?settlement_obligation ?source_priority_profile)
        (not
          (source_priority_profile_available ?source_priority_profile)
        )
      )
  )
  (:action finalize_entity_funding_and_reserve_source
    :parameters (?entity_account_primary - entity_account_primary ?liquidity_source - liquidity_source ?source_priority_profile - source_priority_profile)
    :precondition
      (and
        (funding_allocated_for_subject ?entity_account_primary)
        (assigned_liquidity_source ?entity_account_primary ?liquidity_source)
        (subject_assigned_priority_profile ?entity_account_primary ?source_priority_profile)
        (not
          (funding_settled ?entity_account_primary)
        )
      )
    :effect
      (and
        (funding_settled ?entity_account_primary)
        (source_available ?liquidity_source)
        (source_priority_profile_available ?source_priority_profile)
      )
  )
  (:action finalize_secondary_funding_and_reserve_source
    :parameters (?entity_account_secondary - entity_account_secondary ?liquidity_source - liquidity_source ?source_priority_profile - source_priority_profile)
    :precondition
      (and
        (funding_allocated_for_subject ?entity_account_secondary)
        (assigned_liquidity_source ?entity_account_secondary ?liquidity_source)
        (subject_assigned_priority_profile ?entity_account_secondary ?source_priority_profile)
        (not
          (funding_settled ?entity_account_secondary)
        )
      )
    :effect
      (and
        (funding_settled ?entity_account_secondary)
        (source_available ?liquidity_source)
        (source_priority_profile_available ?source_priority_profile)
      )
  )
  (:action finalize_agent_funding_and_reserve_source
    :parameters (?treasury_agent - treasury_agent ?liquidity_source - liquidity_source ?source_priority_profile - source_priority_profile)
    :precondition
      (and
        (funding_allocated_for_subject ?treasury_agent)
        (assigned_liquidity_source ?treasury_agent ?liquidity_source)
        (subject_assigned_priority_profile ?treasury_agent ?source_priority_profile)
        (not
          (funding_settled ?treasury_agent)
        )
      )
    :effect
      (and
        (funding_settled ?treasury_agent)
        (source_available ?liquidity_source)
        (source_priority_profile_available ?source_priority_profile)
      )
  )
)

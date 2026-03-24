(define (domain benchmark_tracking_error_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types execution_resource_group - object operational_entity - object order_component_group - object mandate_container - object mandate - mandate_container execution_algorithm - execution_resource_group trade_signal - execution_resource_group trader - execution_resource_group liquidity_constraint - execution_resource_group pricing_model - execution_resource_group rebalancing_reason - execution_resource_group risk_parameter - execution_resource_group post_trade_pool_entry - execution_resource_group security - operational_entity settlement_instruction - operational_entity compliance_check - operational_entity execution_venue - order_component_group execution_tactic - order_component_group order - order_component_group portfolio_bucket - mandate transition_set - mandate source_bucket - portfolio_bucket target_bucket - portfolio_bucket transition_plan - transition_set)
  (:predicates
    (mandate_registered ?mandate - mandate)
    (entity_validated ?mandate - mandate)
    (entity_has_algorithm ?mandate - mandate)
    (finalized ?mandate - mandate)
    (approved ?mandate - mandate)
    (entity_post_trade_assigned ?mandate - mandate)
    (execution_algorithm_available ?execution_algorithm - execution_algorithm)
    (entity_assigned_algorithm ?mandate - mandate ?execution_algorithm - execution_algorithm)
    (trade_signal_available ?trade_signal_var - trade_signal)
    (entity_linked_signal ?mandate - mandate ?trade_signal_var - trade_signal)
    (trader_available ?trader - trader)
    (entity_assigned_trader ?mandate - mandate ?trader - trader)
    (security_available ?security - security)
    (source_bucket_has_security ?source_bucket_var - source_bucket ?security - security)
    (target_bucket_has_security ?target_bucket_var - target_bucket ?security - security)
    (source_bucket_venue_candidate ?source_bucket_var - source_bucket ?execution_venue - execution_venue)
    (venue_primary_selected ?execution_venue - execution_venue)
    (venue_secondary_selected ?execution_venue - execution_venue)
    (source_bucket_ready_for_ordering ?source_bucket_var - source_bucket)
    (target_bucket_tactic_candidate ?target_bucket_var - target_bucket ?execution_tactic - execution_tactic)
    (tactic_primary_selected ?execution_tactic - execution_tactic)
    (tactic_secondary_selected ?execution_tactic - execution_tactic)
    (target_bucket_ready_for_ordering ?target_bucket_var - target_bucket)
    (order_pending_construction ?order - order)
    (order_constructed ?order - order)
    (order_bound_to_venue ?order - order ?execution_venue - execution_venue)
    (order_bound_to_tactic ?order - order ?execution_tactic - execution_tactic)
    (order_secondary_venue_flag ?order - order)
    (order_secondary_tactic_flag ?order - order)
    (order_ready_for_settlement ?order - order)
    (transition_includes_source_bucket ?transition_plan - transition_plan ?source_bucket_var - source_bucket)
    (transition_includes_target_bucket ?transition_plan - transition_plan ?target_bucket_var - target_bucket)
    (transition_includes_order ?transition_plan - transition_plan ?order - order)
    (settlement_instruction_available ?settlement_instruction - settlement_instruction)
    (transition_has_settlement_instruction ?transition_plan - transition_plan ?settlement_instruction - settlement_instruction)
    (settlement_instruction_consumed ?settlement_instruction - settlement_instruction)
    (settlement_instruction_bound_to_order ?settlement_instruction - settlement_instruction ?order - order)
    (transition_settlement_ready ?transition_plan - transition_plan)
    (plan_risk_parameter_attached ?transition_plan - transition_plan)
    (post_trade_pool_attached ?transition_plan - transition_plan)
    (plan_liquidity_constraint_attached ?transition_plan - transition_plan)
    (plan_liquidity_constraint_confirmed ?transition_plan - transition_plan)
    (post_trade_pool_confirmed ?transition_plan - transition_plan)
    (transition_plan_ready_for_approval ?transition_plan - transition_plan)
    (compliance_check_available ?compliance_check - compliance_check)
    (plan_attached_compliance_check ?transition_plan - transition_plan ?compliance_check - compliance_check)
    (compliance_attached_to_plan ?transition_plan - transition_plan)
    (compliance_review_started ?transition_plan - transition_plan)
    (compliance_approval_passed ?transition_plan - transition_plan)
    (liquidity_constraint_available ?liquidity_constraint - liquidity_constraint)
    (plan_attached_liquidity_constraint ?transition_plan - transition_plan ?liquidity_constraint - liquidity_constraint)
    (pricing_model_available ?pricing_model_var - pricing_model)
    (plan_attached_pricing_model ?transition_plan - transition_plan ?pricing_model_var - pricing_model)
    (risk_parameter_available ?risk_parameter - risk_parameter)
    (plan_attached_risk_parameter ?transition_plan - transition_plan ?risk_parameter - risk_parameter)
    (post_trade_pool_entry_available ?post_trade_pool_entry - post_trade_pool_entry)
    (plan_attached_post_trade_pool_entry ?transition_plan - transition_plan ?post_trade_pool_entry - post_trade_pool_entry)
    (rebalancing_reason_available ?rebalancing_reason - rebalancing_reason)
    (entity_assigned_rebalancing_reason ?mandate - mandate ?rebalancing_reason - rebalancing_reason)
    (source_bucket_reserved ?source_bucket_var - source_bucket)
    (target_bucket_reserved ?target_bucket_var - target_bucket)
    (plan_approval_recorded ?transition_plan - transition_plan)
  )
  (:action register_mandate
    :parameters (?mandate - mandate)
    :precondition
      (and
        (not
          (mandate_registered ?mandate)
        )
        (not
          (finalized ?mandate)
        )
      )
    :effect (mandate_registered ?mandate)
  )
  (:action assign_execution_algorithm_to_mandate
    :parameters (?mandate - mandate ?execution_algorithm - execution_algorithm)
    :precondition
      (and
        (mandate_registered ?mandate)
        (not
          (entity_has_algorithm ?mandate)
        )
        (execution_algorithm_available ?execution_algorithm)
      )
    :effect
      (and
        (entity_has_algorithm ?mandate)
        (entity_assigned_algorithm ?mandate ?execution_algorithm)
        (not
          (execution_algorithm_available ?execution_algorithm)
        )
      )
  )
  (:action link_trade_signal_to_mandate
    :parameters (?mandate - mandate ?trade_signal_var - trade_signal)
    :precondition
      (and
        (mandate_registered ?mandate)
        (entity_has_algorithm ?mandate)
        (trade_signal_available ?trade_signal_var)
      )
    :effect
      (and
        (entity_linked_signal ?mandate ?trade_signal_var)
        (not
          (trade_signal_available ?trade_signal_var)
        )
      )
  )
  (:action validate_mandate_for_transition
    :parameters (?mandate - mandate ?trade_signal_var - trade_signal)
    :precondition
      (and
        (mandate_registered ?mandate)
        (entity_has_algorithm ?mandate)
        (entity_linked_signal ?mandate ?trade_signal_var)
        (not
          (entity_validated ?mandate)
        )
      )
    :effect (entity_validated ?mandate)
  )
  (:action unlink_trade_signal_from_mandate
    :parameters (?mandate - mandate ?trade_signal_var - trade_signal)
    :precondition
      (and
        (entity_linked_signal ?mandate ?trade_signal_var)
      )
    :effect
      (and
        (trade_signal_available ?trade_signal_var)
        (not
          (entity_linked_signal ?mandate ?trade_signal_var)
        )
      )
  )
  (:action assign_trader_to_mandate
    :parameters (?mandate - mandate ?trader - trader)
    :precondition
      (and
        (entity_validated ?mandate)
        (trader_available ?trader)
      )
    :effect
      (and
        (entity_assigned_trader ?mandate ?trader)
        (not
          (trader_available ?trader)
        )
      )
  )
  (:action unassign_trader_from_mandate
    :parameters (?mandate - mandate ?trader - trader)
    :precondition
      (and
        (entity_assigned_trader ?mandate ?trader)
      )
    :effect
      (and
        (trader_available ?trader)
        (not
          (entity_assigned_trader ?mandate ?trader)
        )
      )
  )
  (:action attach_risk_parameter_to_transition_plan
    :parameters (?transition_plan - transition_plan ?risk_parameter - risk_parameter)
    :precondition
      (and
        (entity_validated ?transition_plan)
        (risk_parameter_available ?risk_parameter)
      )
    :effect
      (and
        (plan_attached_risk_parameter ?transition_plan ?risk_parameter)
        (not
          (risk_parameter_available ?risk_parameter)
        )
      )
  )
  (:action detach_risk_parameter_from_transition_plan
    :parameters (?transition_plan - transition_plan ?risk_parameter - risk_parameter)
    :precondition
      (and
        (plan_attached_risk_parameter ?transition_plan ?risk_parameter)
      )
    :effect
      (and
        (risk_parameter_available ?risk_parameter)
        (not
          (plan_attached_risk_parameter ?transition_plan ?risk_parameter)
        )
      )
  )
  (:action attach_post_trade_pool_entry_to_transition_plan
    :parameters (?transition_plan - transition_plan ?post_trade_pool_entry - post_trade_pool_entry)
    :precondition
      (and
        (entity_validated ?transition_plan)
        (post_trade_pool_entry_available ?post_trade_pool_entry)
      )
    :effect
      (and
        (plan_attached_post_trade_pool_entry ?transition_plan ?post_trade_pool_entry)
        (not
          (post_trade_pool_entry_available ?post_trade_pool_entry)
        )
      )
  )
  (:action detach_post_trade_pool_entry_from_transition_plan
    :parameters (?transition_plan - transition_plan ?post_trade_pool_entry - post_trade_pool_entry)
    :precondition
      (and
        (plan_attached_post_trade_pool_entry ?transition_plan ?post_trade_pool_entry)
      )
    :effect
      (and
        (post_trade_pool_entry_available ?post_trade_pool_entry)
        (not
          (plan_attached_post_trade_pool_entry ?transition_plan ?post_trade_pool_entry)
        )
      )
  )
  (:action nominate_execution_venue_for_source_bucket
    :parameters (?source_bucket_var - source_bucket ?execution_venue - execution_venue ?trade_signal_var - trade_signal)
    :precondition
      (and
        (entity_validated ?source_bucket_var)
        (entity_linked_signal ?source_bucket_var ?trade_signal_var)
        (source_bucket_venue_candidate ?source_bucket_var ?execution_venue)
        (not
          (venue_primary_selected ?execution_venue)
        )
        (not
          (venue_secondary_selected ?execution_venue)
        )
      )
    :effect (venue_primary_selected ?execution_venue)
  )
  (:action confirm_venue_with_trader_for_source_bucket
    :parameters (?source_bucket_var - source_bucket ?execution_venue - execution_venue ?trader - trader)
    :precondition
      (and
        (entity_validated ?source_bucket_var)
        (entity_assigned_trader ?source_bucket_var ?trader)
        (source_bucket_venue_candidate ?source_bucket_var ?execution_venue)
        (venue_primary_selected ?execution_venue)
        (not
          (source_bucket_reserved ?source_bucket_var)
        )
      )
    :effect
      (and
        (source_bucket_reserved ?source_bucket_var)
        (source_bucket_ready_for_ordering ?source_bucket_var)
      )
  )
  (:action assign_security_to_source_bucket_and_reserve_venue
    :parameters (?source_bucket_var - source_bucket ?execution_venue - execution_venue ?security - security)
    :precondition
      (and
        (entity_validated ?source_bucket_var)
        (source_bucket_venue_candidate ?source_bucket_var ?execution_venue)
        (security_available ?security)
        (not
          (source_bucket_reserved ?source_bucket_var)
        )
      )
    :effect
      (and
        (venue_secondary_selected ?execution_venue)
        (source_bucket_reserved ?source_bucket_var)
        (source_bucket_has_security ?source_bucket_var ?security)
        (not
          (security_available ?security)
        )
      )
  )
  (:action finalize_venue_and_security_for_source_bucket
    :parameters (?source_bucket_var - source_bucket ?execution_venue - execution_venue ?trade_signal_var - trade_signal ?security - security)
    :precondition
      (and
        (entity_validated ?source_bucket_var)
        (entity_linked_signal ?source_bucket_var ?trade_signal_var)
        (source_bucket_venue_candidate ?source_bucket_var ?execution_venue)
        (venue_secondary_selected ?execution_venue)
        (source_bucket_has_security ?source_bucket_var ?security)
        (not
          (source_bucket_ready_for_ordering ?source_bucket_var)
        )
      )
    :effect
      (and
        (venue_primary_selected ?execution_venue)
        (source_bucket_ready_for_ordering ?source_bucket_var)
        (security_available ?security)
        (not
          (source_bucket_has_security ?source_bucket_var ?security)
        )
      )
  )
  (:action nominate_execution_tactic_for_target_bucket
    :parameters (?target_bucket_var - target_bucket ?execution_tactic - execution_tactic ?trade_signal_var - trade_signal)
    :precondition
      (and
        (entity_validated ?target_bucket_var)
        (entity_linked_signal ?target_bucket_var ?trade_signal_var)
        (target_bucket_tactic_candidate ?target_bucket_var ?execution_tactic)
        (not
          (tactic_primary_selected ?execution_tactic)
        )
        (not
          (tactic_secondary_selected ?execution_tactic)
        )
      )
    :effect (tactic_primary_selected ?execution_tactic)
  )
  (:action confirm_tactic_with_trader_for_target_bucket
    :parameters (?target_bucket_var - target_bucket ?execution_tactic - execution_tactic ?trader - trader)
    :precondition
      (and
        (entity_validated ?target_bucket_var)
        (entity_assigned_trader ?target_bucket_var ?trader)
        (target_bucket_tactic_candidate ?target_bucket_var ?execution_tactic)
        (tactic_primary_selected ?execution_tactic)
        (not
          (target_bucket_reserved ?target_bucket_var)
        )
      )
    :effect
      (and
        (target_bucket_reserved ?target_bucket_var)
        (target_bucket_ready_for_ordering ?target_bucket_var)
      )
  )
  (:action assign_security_to_target_bucket_and_reserve_tactic
    :parameters (?target_bucket_var - target_bucket ?execution_tactic - execution_tactic ?security - security)
    :precondition
      (and
        (entity_validated ?target_bucket_var)
        (target_bucket_tactic_candidate ?target_bucket_var ?execution_tactic)
        (security_available ?security)
        (not
          (target_bucket_reserved ?target_bucket_var)
        )
      )
    :effect
      (and
        (tactic_secondary_selected ?execution_tactic)
        (target_bucket_reserved ?target_bucket_var)
        (target_bucket_has_security ?target_bucket_var ?security)
        (not
          (security_available ?security)
        )
      )
  )
  (:action finalize_tactic_and_security_for_target_bucket
    :parameters (?target_bucket_var - target_bucket ?execution_tactic - execution_tactic ?trade_signal_var - trade_signal ?security - security)
    :precondition
      (and
        (entity_validated ?target_bucket_var)
        (entity_linked_signal ?target_bucket_var ?trade_signal_var)
        (target_bucket_tactic_candidate ?target_bucket_var ?execution_tactic)
        (tactic_secondary_selected ?execution_tactic)
        (target_bucket_has_security ?target_bucket_var ?security)
        (not
          (target_bucket_ready_for_ordering ?target_bucket_var)
        )
      )
    :effect
      (and
        (tactic_primary_selected ?execution_tactic)
        (target_bucket_ready_for_ordering ?target_bucket_var)
        (security_available ?security)
        (not
          (target_bucket_has_security ?target_bucket_var ?security)
        )
      )
  )
  (:action construct_order_for_transition
    :parameters (?source_bucket_var - source_bucket ?target_bucket_var - target_bucket ?execution_venue - execution_venue ?execution_tactic - execution_tactic ?order - order)
    :precondition
      (and
        (source_bucket_reserved ?source_bucket_var)
        (target_bucket_reserved ?target_bucket_var)
        (source_bucket_venue_candidate ?source_bucket_var ?execution_venue)
        (target_bucket_tactic_candidate ?target_bucket_var ?execution_tactic)
        (venue_primary_selected ?execution_venue)
        (tactic_primary_selected ?execution_tactic)
        (source_bucket_ready_for_ordering ?source_bucket_var)
        (target_bucket_ready_for_ordering ?target_bucket_var)
        (order_pending_construction ?order)
      )
    :effect
      (and
        (order_constructed ?order)
        (order_bound_to_venue ?order ?execution_venue)
        (order_bound_to_tactic ?order ?execution_tactic)
        (not
          (order_pending_construction ?order)
        )
      )
  )
  (:action construct_order_with_secondary_venue
    :parameters (?source_bucket_var - source_bucket ?target_bucket_var - target_bucket ?execution_venue - execution_venue ?execution_tactic - execution_tactic ?order - order)
    :precondition
      (and
        (source_bucket_reserved ?source_bucket_var)
        (target_bucket_reserved ?target_bucket_var)
        (source_bucket_venue_candidate ?source_bucket_var ?execution_venue)
        (target_bucket_tactic_candidate ?target_bucket_var ?execution_tactic)
        (venue_secondary_selected ?execution_venue)
        (tactic_primary_selected ?execution_tactic)
        (not
          (source_bucket_ready_for_ordering ?source_bucket_var)
        )
        (target_bucket_ready_for_ordering ?target_bucket_var)
        (order_pending_construction ?order)
      )
    :effect
      (and
        (order_constructed ?order)
        (order_bound_to_venue ?order ?execution_venue)
        (order_bound_to_tactic ?order ?execution_tactic)
        (order_secondary_venue_flag ?order)
        (not
          (order_pending_construction ?order)
        )
      )
  )
  (:action construct_order_with_secondary_tactic
    :parameters (?source_bucket_var - source_bucket ?target_bucket_var - target_bucket ?execution_venue - execution_venue ?execution_tactic - execution_tactic ?order - order)
    :precondition
      (and
        (source_bucket_reserved ?source_bucket_var)
        (target_bucket_reserved ?target_bucket_var)
        (source_bucket_venue_candidate ?source_bucket_var ?execution_venue)
        (target_bucket_tactic_candidate ?target_bucket_var ?execution_tactic)
        (venue_primary_selected ?execution_venue)
        (tactic_secondary_selected ?execution_tactic)
        (source_bucket_ready_for_ordering ?source_bucket_var)
        (not
          (target_bucket_ready_for_ordering ?target_bucket_var)
        )
        (order_pending_construction ?order)
      )
    :effect
      (and
        (order_constructed ?order)
        (order_bound_to_venue ?order ?execution_venue)
        (order_bound_to_tactic ?order ?execution_tactic)
        (order_secondary_tactic_flag ?order)
        (not
          (order_pending_construction ?order)
        )
      )
  )
  (:action construct_order_with_both_secondary_flags
    :parameters (?source_bucket_var - source_bucket ?target_bucket_var - target_bucket ?execution_venue - execution_venue ?execution_tactic - execution_tactic ?order - order)
    :precondition
      (and
        (source_bucket_reserved ?source_bucket_var)
        (target_bucket_reserved ?target_bucket_var)
        (source_bucket_venue_candidate ?source_bucket_var ?execution_venue)
        (target_bucket_tactic_candidate ?target_bucket_var ?execution_tactic)
        (venue_secondary_selected ?execution_venue)
        (tactic_secondary_selected ?execution_tactic)
        (not
          (source_bucket_ready_for_ordering ?source_bucket_var)
        )
        (not
          (target_bucket_ready_for_ordering ?target_bucket_var)
        )
        (order_pending_construction ?order)
      )
    :effect
      (and
        (order_constructed ?order)
        (order_bound_to_venue ?order ?execution_venue)
        (order_bound_to_tactic ?order ?execution_tactic)
        (order_secondary_venue_flag ?order)
        (order_secondary_tactic_flag ?order)
        (not
          (order_pending_construction ?order)
        )
      )
  )
  (:action mark_order_ready_for_settlement
    :parameters (?order - order ?source_bucket_var - source_bucket ?trade_signal_var - trade_signal)
    :precondition
      (and
        (order_constructed ?order)
        (source_bucket_reserved ?source_bucket_var)
        (entity_linked_signal ?source_bucket_var ?trade_signal_var)
        (not
          (order_ready_for_settlement ?order)
        )
      )
    :effect (order_ready_for_settlement ?order)
  )
  (:action bind_settlement_instruction_to_order
    :parameters (?transition_plan - transition_plan ?settlement_instruction - settlement_instruction ?order - order)
    :precondition
      (and
        (entity_validated ?transition_plan)
        (transition_includes_order ?transition_plan ?order)
        (transition_has_settlement_instruction ?transition_plan ?settlement_instruction)
        (settlement_instruction_available ?settlement_instruction)
        (order_constructed ?order)
        (order_ready_for_settlement ?order)
        (not
          (settlement_instruction_consumed ?settlement_instruction)
        )
      )
    :effect
      (and
        (settlement_instruction_consumed ?settlement_instruction)
        (settlement_instruction_bound_to_order ?settlement_instruction ?order)
        (not
          (settlement_instruction_available ?settlement_instruction)
        )
      )
  )
  (:action confirm_transition_plan_settlement_ready
    :parameters (?transition_plan - transition_plan ?settlement_instruction - settlement_instruction ?order - order ?trade_signal_var - trade_signal)
    :precondition
      (and
        (entity_validated ?transition_plan)
        (transition_has_settlement_instruction ?transition_plan ?settlement_instruction)
        (settlement_instruction_consumed ?settlement_instruction)
        (settlement_instruction_bound_to_order ?settlement_instruction ?order)
        (entity_linked_signal ?transition_plan ?trade_signal_var)
        (not
          (order_secondary_venue_flag ?order)
        )
        (not
          (transition_settlement_ready ?transition_plan)
        )
      )
    :effect (transition_settlement_ready ?transition_plan)
  )
  (:action attach_liquidity_constraint_to_transition_plan
    :parameters (?transition_plan - transition_plan ?liquidity_constraint - liquidity_constraint)
    :precondition
      (and
        (entity_validated ?transition_plan)
        (liquidity_constraint_available ?liquidity_constraint)
        (not
          (plan_liquidity_constraint_attached ?transition_plan)
        )
      )
    :effect
      (and
        (plan_liquidity_constraint_attached ?transition_plan)
        (plan_attached_liquidity_constraint ?transition_plan ?liquidity_constraint)
        (not
          (liquidity_constraint_available ?liquidity_constraint)
        )
      )
  )
  (:action confirm_liquidity_and_mark_settlement_ready_for_plan
    :parameters (?transition_plan - transition_plan ?settlement_instruction - settlement_instruction ?order - order ?trade_signal_var - trade_signal ?liquidity_constraint - liquidity_constraint)
    :precondition
      (and
        (entity_validated ?transition_plan)
        (transition_has_settlement_instruction ?transition_plan ?settlement_instruction)
        (settlement_instruction_consumed ?settlement_instruction)
        (settlement_instruction_bound_to_order ?settlement_instruction ?order)
        (entity_linked_signal ?transition_plan ?trade_signal_var)
        (order_secondary_venue_flag ?order)
        (plan_liquidity_constraint_attached ?transition_plan)
        (plan_attached_liquidity_constraint ?transition_plan ?liquidity_constraint)
        (not
          (transition_settlement_ready ?transition_plan)
        )
      )
    :effect
      (and
        (transition_settlement_ready ?transition_plan)
        (plan_liquidity_constraint_confirmed ?transition_plan)
      )
  )
  (:action acknowledge_risk_parameter_on_plan
    :parameters (?transition_plan - transition_plan ?risk_parameter - risk_parameter ?trader - trader ?settlement_instruction - settlement_instruction ?order - order)
    :precondition
      (and
        (transition_settlement_ready ?transition_plan)
        (plan_attached_risk_parameter ?transition_plan ?risk_parameter)
        (entity_assigned_trader ?transition_plan ?trader)
        (transition_has_settlement_instruction ?transition_plan ?settlement_instruction)
        (settlement_instruction_bound_to_order ?settlement_instruction ?order)
        (not
          (order_secondary_tactic_flag ?order)
        )
        (not
          (plan_risk_parameter_attached ?transition_plan)
        )
      )
    :effect (plan_risk_parameter_attached ?transition_plan)
  )
  (:action acknowledge_risk_parameter_on_plan_secondary
    :parameters (?transition_plan - transition_plan ?risk_parameter - risk_parameter ?trader - trader ?settlement_instruction - settlement_instruction ?order - order)
    :precondition
      (and
        (transition_settlement_ready ?transition_plan)
        (plan_attached_risk_parameter ?transition_plan ?risk_parameter)
        (entity_assigned_trader ?transition_plan ?trader)
        (transition_has_settlement_instruction ?transition_plan ?settlement_instruction)
        (settlement_instruction_bound_to_order ?settlement_instruction ?order)
        (order_secondary_tactic_flag ?order)
        (not
          (plan_risk_parameter_attached ?transition_plan)
        )
      )
    :effect (plan_risk_parameter_attached ?transition_plan)
  )
  (:action attach_post_trade_pool_to_plan
    :parameters (?transition_plan - transition_plan ?post_trade_pool_entry - post_trade_pool_entry ?settlement_instruction - settlement_instruction ?order - order)
    :precondition
      (and
        (plan_risk_parameter_attached ?transition_plan)
        (plan_attached_post_trade_pool_entry ?transition_plan ?post_trade_pool_entry)
        (transition_has_settlement_instruction ?transition_plan ?settlement_instruction)
        (settlement_instruction_bound_to_order ?settlement_instruction ?order)
        (not
          (order_secondary_venue_flag ?order)
        )
        (not
          (order_secondary_tactic_flag ?order)
        )
        (not
          (post_trade_pool_attached ?transition_plan)
        )
      )
    :effect (post_trade_pool_attached ?transition_plan)
  )
  (:action confirm_post_trade_pool_and_set_confirmed_flag
    :parameters (?transition_plan - transition_plan ?post_trade_pool_entry - post_trade_pool_entry ?settlement_instruction - settlement_instruction ?order - order)
    :precondition
      (and
        (plan_risk_parameter_attached ?transition_plan)
        (plan_attached_post_trade_pool_entry ?transition_plan ?post_trade_pool_entry)
        (transition_has_settlement_instruction ?transition_plan ?settlement_instruction)
        (settlement_instruction_bound_to_order ?settlement_instruction ?order)
        (order_secondary_venue_flag ?order)
        (not
          (order_secondary_tactic_flag ?order)
        )
        (not
          (post_trade_pool_attached ?transition_plan)
        )
      )
    :effect
      (and
        (post_trade_pool_attached ?transition_plan)
        (post_trade_pool_confirmed ?transition_plan)
      )
  )
  (:action confirm_post_trade_pool_and_set_confirmed_flag_alternate
    :parameters (?transition_plan - transition_plan ?post_trade_pool_entry - post_trade_pool_entry ?settlement_instruction - settlement_instruction ?order - order)
    :precondition
      (and
        (plan_risk_parameter_attached ?transition_plan)
        (plan_attached_post_trade_pool_entry ?transition_plan ?post_trade_pool_entry)
        (transition_has_settlement_instruction ?transition_plan ?settlement_instruction)
        (settlement_instruction_bound_to_order ?settlement_instruction ?order)
        (not
          (order_secondary_venue_flag ?order)
        )
        (order_secondary_tactic_flag ?order)
        (not
          (post_trade_pool_attached ?transition_plan)
        )
      )
    :effect
      (and
        (post_trade_pool_attached ?transition_plan)
        (post_trade_pool_confirmed ?transition_plan)
      )
  )
  (:action confirm_post_trade_pool_and_set_confirmed_flag_all
    :parameters (?transition_plan - transition_plan ?post_trade_pool_entry - post_trade_pool_entry ?settlement_instruction - settlement_instruction ?order - order)
    :precondition
      (and
        (plan_risk_parameter_attached ?transition_plan)
        (plan_attached_post_trade_pool_entry ?transition_plan ?post_trade_pool_entry)
        (transition_has_settlement_instruction ?transition_plan ?settlement_instruction)
        (settlement_instruction_bound_to_order ?settlement_instruction ?order)
        (order_secondary_venue_flag ?order)
        (order_secondary_tactic_flag ?order)
        (not
          (post_trade_pool_attached ?transition_plan)
        )
      )
    :effect
      (and
        (post_trade_pool_attached ?transition_plan)
        (post_trade_pool_confirmed ?transition_plan)
      )
  )
  (:action record_transition_plan_approval
    :parameters (?transition_plan - transition_plan)
    :precondition
      (and
        (post_trade_pool_attached ?transition_plan)
        (not
          (post_trade_pool_confirmed ?transition_plan)
        )
        (not
          (plan_approval_recorded ?transition_plan)
        )
      )
    :effect
      (and
        (plan_approval_recorded ?transition_plan)
        (approved ?transition_plan)
      )
  )
  (:action attach_pricing_model_to_plan
    :parameters (?transition_plan - transition_plan ?pricing_model_var - pricing_model)
    :precondition
      (and
        (post_trade_pool_attached ?transition_plan)
        (post_trade_pool_confirmed ?transition_plan)
        (pricing_model_available ?pricing_model_var)
      )
    :effect
      (and
        (plan_attached_pricing_model ?transition_plan ?pricing_model_var)
        (not
          (pricing_model_available ?pricing_model_var)
        )
      )
  )
  (:action request_approval_for_transition_plan
    :parameters (?transition_plan - transition_plan ?source_bucket_var - source_bucket ?target_bucket_var - target_bucket ?trade_signal_var - trade_signal ?pricing_model_var - pricing_model)
    :precondition
      (and
        (post_trade_pool_attached ?transition_plan)
        (post_trade_pool_confirmed ?transition_plan)
        (plan_attached_pricing_model ?transition_plan ?pricing_model_var)
        (transition_includes_source_bucket ?transition_plan ?source_bucket_var)
        (transition_includes_target_bucket ?transition_plan ?target_bucket_var)
        (source_bucket_ready_for_ordering ?source_bucket_var)
        (target_bucket_ready_for_ordering ?target_bucket_var)
        (entity_linked_signal ?transition_plan ?trade_signal_var)
        (not
          (transition_plan_ready_for_approval ?transition_plan)
        )
      )
    :effect (transition_plan_ready_for_approval ?transition_plan)
  )
  (:action finalize_plan_after_approval
    :parameters (?transition_plan - transition_plan)
    :precondition
      (and
        (post_trade_pool_attached ?transition_plan)
        (transition_plan_ready_for_approval ?transition_plan)
        (not
          (plan_approval_recorded ?transition_plan)
        )
      )
    :effect
      (and
        (plan_approval_recorded ?transition_plan)
        (approved ?transition_plan)
      )
  )
  (:action attach_compliance_check_to_plan
    :parameters (?transition_plan - transition_plan ?compliance_check - compliance_check ?trade_signal_var - trade_signal)
    :precondition
      (and
        (entity_validated ?transition_plan)
        (entity_linked_signal ?transition_plan ?trade_signal_var)
        (compliance_check_available ?compliance_check)
        (plan_attached_compliance_check ?transition_plan ?compliance_check)
        (not
          (compliance_attached_to_plan ?transition_plan)
        )
      )
    :effect
      (and
        (compliance_attached_to_plan ?transition_plan)
        (not
          (compliance_check_available ?compliance_check)
        )
      )
  )
  (:action start_compliance_review
    :parameters (?transition_plan - transition_plan ?trader - trader)
    :precondition
      (and
        (compliance_attached_to_plan ?transition_plan)
        (entity_assigned_trader ?transition_plan ?trader)
        (not
          (compliance_review_started ?transition_plan)
        )
      )
    :effect (compliance_review_started ?transition_plan)
  )
  (:action pass_compliance_review
    :parameters (?transition_plan - transition_plan ?post_trade_pool_entry - post_trade_pool_entry)
    :precondition
      (and
        (compliance_review_started ?transition_plan)
        (plan_attached_post_trade_pool_entry ?transition_plan ?post_trade_pool_entry)
        (not
          (compliance_approval_passed ?transition_plan)
        )
      )
    :effect (compliance_approval_passed ?transition_plan)
  )
  (:action finalize_plan_after_compliance
    :parameters (?transition_plan - transition_plan)
    :precondition
      (and
        (compliance_approval_passed ?transition_plan)
        (not
          (plan_approval_recorded ?transition_plan)
        )
      )
    :effect
      (and
        (plan_approval_recorded ?transition_plan)
        (approved ?transition_plan)
      )
  )
  (:action approve_source_bucket_for_allocation
    :parameters (?source_bucket_var - source_bucket ?order - order)
    :precondition
      (and
        (source_bucket_reserved ?source_bucket_var)
        (source_bucket_ready_for_ordering ?source_bucket_var)
        (order_constructed ?order)
        (order_ready_for_settlement ?order)
        (not
          (approved ?source_bucket_var)
        )
      )
    :effect (approved ?source_bucket_var)
  )
  (:action approve_target_bucket_for_allocation
    :parameters (?target_bucket_var - target_bucket ?order - order)
    :precondition
      (and
        (target_bucket_reserved ?target_bucket_var)
        (target_bucket_ready_for_ordering ?target_bucket_var)
        (order_constructed ?order)
        (order_ready_for_settlement ?order)
        (not
          (approved ?target_bucket_var)
        )
      )
    :effect (approved ?target_bucket_var)
  )
  (:action assign_post_trade_to_mandate
    :parameters (?mandate - mandate ?rebalancing_reason - rebalancing_reason ?trade_signal_var - trade_signal)
    :precondition
      (and
        (approved ?mandate)
        (entity_linked_signal ?mandate ?trade_signal_var)
        (rebalancing_reason_available ?rebalancing_reason)
        (not
          (entity_post_trade_assigned ?mandate)
        )
      )
    :effect
      (and
        (entity_post_trade_assigned ?mandate)
        (entity_assigned_rebalancing_reason ?mandate ?rebalancing_reason)
        (not
          (rebalancing_reason_available ?rebalancing_reason)
        )
      )
  )
  (:action finalize_bucket_post_trade_and_release_algorithm
    :parameters (?source_bucket_var - source_bucket ?execution_algorithm - execution_algorithm ?rebalancing_reason - rebalancing_reason)
    :precondition
      (and
        (entity_post_trade_assigned ?source_bucket_var)
        (entity_assigned_algorithm ?source_bucket_var ?execution_algorithm)
        (entity_assigned_rebalancing_reason ?source_bucket_var ?rebalancing_reason)
        (not
          (finalized ?source_bucket_var)
        )
      )
    :effect
      (and
        (finalized ?source_bucket_var)
        (execution_algorithm_available ?execution_algorithm)
        (rebalancing_reason_available ?rebalancing_reason)
      )
  )
  (:action finalize_target_bucket_post_trade_and_release_algorithm
    :parameters (?target_bucket_var - target_bucket ?execution_algorithm - execution_algorithm ?rebalancing_reason - rebalancing_reason)
    :precondition
      (and
        (entity_post_trade_assigned ?target_bucket_var)
        (entity_assigned_algorithm ?target_bucket_var ?execution_algorithm)
        (entity_assigned_rebalancing_reason ?target_bucket_var ?rebalancing_reason)
        (not
          (finalized ?target_bucket_var)
        )
      )
    :effect
      (and
        (finalized ?target_bucket_var)
        (execution_algorithm_available ?execution_algorithm)
        (rebalancing_reason_available ?rebalancing_reason)
      )
  )
  (:action finalize_transition_plan_post_trade_and_release_algorithm
    :parameters (?transition_plan - transition_plan ?execution_algorithm - execution_algorithm ?rebalancing_reason - rebalancing_reason)
    :precondition
      (and
        (entity_post_trade_assigned ?transition_plan)
        (entity_assigned_algorithm ?transition_plan ?execution_algorithm)
        (entity_assigned_rebalancing_reason ?transition_plan ?rebalancing_reason)
        (not
          (finalized ?transition_plan)
        )
      )
    :effect
      (and
        (finalized ?transition_plan)
        (execution_algorithm_available ?execution_algorithm)
        (rebalancing_reason_available ?rebalancing_reason)
      )
  )
)

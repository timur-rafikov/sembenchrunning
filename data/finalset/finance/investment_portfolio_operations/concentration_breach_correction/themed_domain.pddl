(define (domain concentration_breach_correction_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types workflow_resource - object process_resource - object trade_component - object mandate_case_root - object case_root - mandate_case_root remediation_instrument - workflow_resource security_candidate - workflow_resource execution_agent - workflow_resource execution_strategy - workflow_resource allocation_model - workflow_resource trade_reference - workflow_resource compliance_approver - workflow_resource risk_approver - workflow_resource allocation_lot - process_resource settlement_instruction - process_resource portfolio_approver - process_resource sell_leg_slot - trade_component buy_leg_slot - trade_component trade_ticket - trade_component account_group_a - case_root account_group_b - case_root primary_account - account_group_a secondary_account - account_group_a execution_order - account_group_b)
  (:predicates
    (breach_case_created ?breach_case - case_root)
    (candidate_validated ?breach_case - case_root)
    (case_instrument_selected ?breach_case - case_root)
    (remediation_assigned ?breach_case - case_root)
    (final_assignment_recorded ?breach_case - case_root)
    (trade_reference_attached ?breach_case - case_root)
    (remediation_instrument_available ?remediation_instrument - remediation_instrument)
    (case_has_remediation_instrument ?breach_case - case_root ?remediation_instrument - remediation_instrument)
    (security_candidate_available ?security_candidate - security_candidate)
    (has_candidate_security ?breach_case - case_root ?security_candidate - security_candidate)
    (execution_agent_available ?execution_agent - execution_agent)
    (assigned_execution_agent ?breach_case - case_root ?execution_agent - execution_agent)
    (allocation_lot_available ?allocation_lot - allocation_lot)
    (primary_account_allocated_lot ?primary_account - primary_account ?allocation_lot - allocation_lot)
    (secondary_account_allocated_lot ?secondary_account - secondary_account ?allocation_lot - allocation_lot)
    (account_has_sell_leg_slot ?primary_account - primary_account ?sell_leg - sell_leg_slot)
    (sell_leg_reserved ?sell_leg - sell_leg_slot)
    (sell_leg_allocated ?sell_leg - sell_leg_slot)
    (primary_account_sell_confirmed ?primary_account - primary_account)
    (account_has_buy_leg_slot ?secondary_account - secondary_account ?buy_leg - buy_leg_slot)
    (buy_leg_reserved ?buy_leg - buy_leg_slot)
    (buy_leg_allocated ?buy_leg - buy_leg_slot)
    (secondary_account_buy_confirmed ?secondary_account - secondary_account)
    (trade_ticket_available ?trade_ticket - trade_ticket)
    (trade_ticket_created ?trade_ticket - trade_ticket)
    (trade_ticket_has_sell_leg ?trade_ticket - trade_ticket ?sell_leg - sell_leg_slot)
    (trade_ticket_has_buy_leg ?trade_ticket - trade_ticket ?buy_leg - buy_leg_slot)
    (trade_ticket_sell_leg_confirmed ?trade_ticket - trade_ticket)
    (trade_ticket_buy_leg_confirmed ?trade_ticket - trade_ticket)
    (trade_ticket_ready ?trade_ticket - trade_ticket)
    (execution_order_has_primary_account ?execution_order - execution_order ?primary_account - primary_account)
    (execution_order_has_secondary_account ?execution_order - execution_order ?secondary_account - secondary_account)
    (execution_order_has_trade_ticket ?execution_order - execution_order ?trade_ticket - trade_ticket)
    (settlement_instruction_available ?settlement_instruction - settlement_instruction)
    (execution_order_has_settlement_instruction ?execution_order - execution_order ?settlement_instruction - settlement_instruction)
    (settlement_instruction_locked ?settlement_instruction - settlement_instruction)
    (settlement_instruction_for_trade_ticket ?settlement_instruction - settlement_instruction ?trade_ticket - trade_ticket)
    (execution_order_settlement_assigned ?execution_order - execution_order)
    (order_has_compliance_approval ?execution_order - execution_order)
    (order_approvals_completed ?execution_order - execution_order)
    (execution_strategy_attached ?execution_order - execution_order)
    (execution_strategy_configured ?execution_order - execution_order)
    (portfolio_approval_collected ?execution_order - execution_order)
    (order_allocation_ready ?execution_order - execution_order)
    (portfolio_approver_available ?portfolio_approver - portfolio_approver)
    (execution_order_has_portfolio_approver ?execution_order - execution_order ?portfolio_approver - portfolio_approver)
    (portfolio_approver_reserved ?execution_order - execution_order)
    (portfolio_approval_confirmed ?execution_order - execution_order)
    (risk_approval_confirmed ?execution_order - execution_order)
    (execution_strategy_available ?execution_strategy - execution_strategy)
    (execution_order_has_strategy ?execution_order - execution_order ?execution_strategy - execution_strategy)
    (allocation_model_available ?allocation_model - allocation_model)
    (execution_order_has_allocation_model ?execution_order - execution_order ?allocation_model - allocation_model)
    (compliance_approver_available ?compliance_approver - compliance_approver)
    (execution_order_has_compliance_approval ?execution_order - execution_order ?compliance_approver - compliance_approver)
    (risk_approver_available ?risk_approver - risk_approver)
    (execution_order_has_risk_approval ?execution_order - execution_order ?risk_approver - risk_approver)
    (trade_reference_available ?trade_reference - trade_reference)
    (case_has_trade_reference ?breach_case - case_root ?trade_reference - trade_reference)
    (primary_account_ready_for_ticket ?primary_account - primary_account)
    (secondary_account_ready_for_ticket ?secondary_account - secondary_account)
    (execution_order_booking_completed ?execution_order - execution_order)
  )
  (:action create_concentration_breach_case
    :parameters (?breach_case - case_root)
    :precondition
      (and
        (not
          (breach_case_created ?breach_case)
        )
        (not
          (remediation_assigned ?breach_case)
        )
      )
    :effect (breach_case_created ?breach_case)
  )
  (:action assign_remediation_instrument_to_case
    :parameters (?breach_case - case_root ?remediation_instrument - remediation_instrument)
    :precondition
      (and
        (breach_case_created ?breach_case)
        (not
          (case_instrument_selected ?breach_case)
        )
        (remediation_instrument_available ?remediation_instrument)
      )
    :effect
      (and
        (case_instrument_selected ?breach_case)
        (case_has_remediation_instrument ?breach_case ?remediation_instrument)
        (not
          (remediation_instrument_available ?remediation_instrument)
        )
      )
  )
  (:action attach_security_candidate_to_case
    :parameters (?breach_case - case_root ?security_candidate - security_candidate)
    :precondition
      (and
        (breach_case_created ?breach_case)
        (case_instrument_selected ?breach_case)
        (security_candidate_available ?security_candidate)
      )
    :effect
      (and
        (has_candidate_security ?breach_case ?security_candidate)
        (not
          (security_candidate_available ?security_candidate)
        )
      )
  )
  (:action validate_candidate_security_for_case
    :parameters (?breach_case - case_root ?security_candidate - security_candidate)
    :precondition
      (and
        (breach_case_created ?breach_case)
        (case_instrument_selected ?breach_case)
        (has_candidate_security ?breach_case ?security_candidate)
        (not
          (candidate_validated ?breach_case)
        )
      )
    :effect (candidate_validated ?breach_case)
  )
  (:action unassign_candidate_security_from_case
    :parameters (?breach_case - case_root ?security_candidate - security_candidate)
    :precondition
      (and
        (has_candidate_security ?breach_case ?security_candidate)
      )
    :effect
      (and
        (security_candidate_available ?security_candidate)
        (not
          (has_candidate_security ?breach_case ?security_candidate)
        )
      )
  )
  (:action reserve_execution_agent_for_case
    :parameters (?breach_case - case_root ?execution_agent - execution_agent)
    :precondition
      (and
        (candidate_validated ?breach_case)
        (execution_agent_available ?execution_agent)
      )
    :effect
      (and
        (assigned_execution_agent ?breach_case ?execution_agent)
        (not
          (execution_agent_available ?execution_agent)
        )
      )
  )
  (:action release_execution_agent_from_case
    :parameters (?breach_case - case_root ?execution_agent - execution_agent)
    :precondition
      (and
        (assigned_execution_agent ?breach_case ?execution_agent)
      )
    :effect
      (and
        (execution_agent_available ?execution_agent)
        (not
          (assigned_execution_agent ?breach_case ?execution_agent)
        )
      )
  )
  (:action assign_compliance_approver_to_order
    :parameters (?execution_order - execution_order ?compliance_approver - compliance_approver)
    :precondition
      (and
        (candidate_validated ?execution_order)
        (compliance_approver_available ?compliance_approver)
      )
    :effect
      (and
        (execution_order_has_compliance_approval ?execution_order ?compliance_approver)
        (not
          (compliance_approver_available ?compliance_approver)
        )
      )
  )
  (:action release_compliance_approver_from_order
    :parameters (?execution_order - execution_order ?compliance_approver - compliance_approver)
    :precondition
      (and
        (execution_order_has_compliance_approval ?execution_order ?compliance_approver)
      )
    :effect
      (and
        (compliance_approver_available ?compliance_approver)
        (not
          (execution_order_has_compliance_approval ?execution_order ?compliance_approver)
        )
      )
  )
  (:action assign_risk_approver_to_order
    :parameters (?execution_order - execution_order ?risk_approver - risk_approver)
    :precondition
      (and
        (candidate_validated ?execution_order)
        (risk_approver_available ?risk_approver)
      )
    :effect
      (and
        (execution_order_has_risk_approval ?execution_order ?risk_approver)
        (not
          (risk_approver_available ?risk_approver)
        )
      )
  )
  (:action release_risk_approver_from_order
    :parameters (?execution_order - execution_order ?risk_approver - risk_approver)
    :precondition
      (and
        (execution_order_has_risk_approval ?execution_order ?risk_approver)
      )
    :effect
      (and
        (risk_approver_available ?risk_approver)
        (not
          (execution_order_has_risk_approval ?execution_order ?risk_approver)
        )
      )
  )
  (:action reserve_sell_leg_slot_for_primary_account
    :parameters (?primary_account - primary_account ?sell_leg - sell_leg_slot ?security_candidate - security_candidate)
    :precondition
      (and
        (candidate_validated ?primary_account)
        (has_candidate_security ?primary_account ?security_candidate)
        (account_has_sell_leg_slot ?primary_account ?sell_leg)
        (not
          (sell_leg_reserved ?sell_leg)
        )
        (not
          (sell_leg_allocated ?sell_leg)
        )
      )
    :effect (sell_leg_reserved ?sell_leg)
  )
  (:action confirm_sell_leg_and_mark_primary_account
    :parameters (?primary_account - primary_account ?sell_leg - sell_leg_slot ?execution_agent - execution_agent)
    :precondition
      (and
        (candidate_validated ?primary_account)
        (assigned_execution_agent ?primary_account ?execution_agent)
        (account_has_sell_leg_slot ?primary_account ?sell_leg)
        (sell_leg_reserved ?sell_leg)
        (not
          (primary_account_ready_for_ticket ?primary_account)
        )
      )
    :effect
      (and
        (primary_account_ready_for_ticket ?primary_account)
        (primary_account_sell_confirmed ?primary_account)
      )
  )
  (:action allocate_allocation_lot_to_primary_account
    :parameters (?primary_account - primary_account ?sell_leg - sell_leg_slot ?allocation_lot - allocation_lot)
    :precondition
      (and
        (candidate_validated ?primary_account)
        (account_has_sell_leg_slot ?primary_account ?sell_leg)
        (allocation_lot_available ?allocation_lot)
        (not
          (primary_account_ready_for_ticket ?primary_account)
        )
      )
    :effect
      (and
        (sell_leg_allocated ?sell_leg)
        (primary_account_ready_for_ticket ?primary_account)
        (primary_account_allocated_lot ?primary_account ?allocation_lot)
        (not
          (allocation_lot_available ?allocation_lot)
        )
      )
  )
  (:action finalize_primary_account_sell_allocation
    :parameters (?primary_account - primary_account ?sell_leg - sell_leg_slot ?security_candidate - security_candidate ?allocation_lot - allocation_lot)
    :precondition
      (and
        (candidate_validated ?primary_account)
        (has_candidate_security ?primary_account ?security_candidate)
        (account_has_sell_leg_slot ?primary_account ?sell_leg)
        (sell_leg_allocated ?sell_leg)
        (primary_account_allocated_lot ?primary_account ?allocation_lot)
        (not
          (primary_account_sell_confirmed ?primary_account)
        )
      )
    :effect
      (and
        (sell_leg_reserved ?sell_leg)
        (primary_account_sell_confirmed ?primary_account)
        (allocation_lot_available ?allocation_lot)
        (not
          (primary_account_allocated_lot ?primary_account ?allocation_lot)
        )
      )
  )
  (:action reserve_buy_leg_slot_for_secondary_account
    :parameters (?secondary_account - secondary_account ?buy_leg - buy_leg_slot ?security_candidate - security_candidate)
    :precondition
      (and
        (candidate_validated ?secondary_account)
        (has_candidate_security ?secondary_account ?security_candidate)
        (account_has_buy_leg_slot ?secondary_account ?buy_leg)
        (not
          (buy_leg_reserved ?buy_leg)
        )
        (not
          (buy_leg_allocated ?buy_leg)
        )
      )
    :effect (buy_leg_reserved ?buy_leg)
  )
  (:action confirm_buy_leg_and_lock_secondary_account
    :parameters (?secondary_account - secondary_account ?buy_leg - buy_leg_slot ?execution_agent - execution_agent)
    :precondition
      (and
        (candidate_validated ?secondary_account)
        (assigned_execution_agent ?secondary_account ?execution_agent)
        (account_has_buy_leg_slot ?secondary_account ?buy_leg)
        (buy_leg_reserved ?buy_leg)
        (not
          (secondary_account_ready_for_ticket ?secondary_account)
        )
      )
    :effect
      (and
        (secondary_account_ready_for_ticket ?secondary_account)
        (secondary_account_buy_confirmed ?secondary_account)
      )
  )
  (:action allocate_allocation_lot_to_secondary_account
    :parameters (?secondary_account - secondary_account ?buy_leg - buy_leg_slot ?allocation_lot - allocation_lot)
    :precondition
      (and
        (candidate_validated ?secondary_account)
        (account_has_buy_leg_slot ?secondary_account ?buy_leg)
        (allocation_lot_available ?allocation_lot)
        (not
          (secondary_account_ready_for_ticket ?secondary_account)
        )
      )
    :effect
      (and
        (buy_leg_allocated ?buy_leg)
        (secondary_account_ready_for_ticket ?secondary_account)
        (secondary_account_allocated_lot ?secondary_account ?allocation_lot)
        (not
          (allocation_lot_available ?allocation_lot)
        )
      )
  )
  (:action finalize_secondary_account_buy_allocation
    :parameters (?secondary_account - secondary_account ?buy_leg - buy_leg_slot ?security_candidate - security_candidate ?allocation_lot - allocation_lot)
    :precondition
      (and
        (candidate_validated ?secondary_account)
        (has_candidate_security ?secondary_account ?security_candidate)
        (account_has_buy_leg_slot ?secondary_account ?buy_leg)
        (buy_leg_allocated ?buy_leg)
        (secondary_account_allocated_lot ?secondary_account ?allocation_lot)
        (not
          (secondary_account_buy_confirmed ?secondary_account)
        )
      )
    :effect
      (and
        (buy_leg_reserved ?buy_leg)
        (secondary_account_buy_confirmed ?secondary_account)
        (allocation_lot_available ?allocation_lot)
        (not
          (secondary_account_allocated_lot ?secondary_account ?allocation_lot)
        )
      )
  )
  (:action construct_trade_ticket_from_reserved_legs
    :parameters (?primary_account - primary_account ?secondary_account - secondary_account ?sell_leg - sell_leg_slot ?buy_leg - buy_leg_slot ?trade_ticket - trade_ticket)
    :precondition
      (and
        (primary_account_ready_for_ticket ?primary_account)
        (secondary_account_ready_for_ticket ?secondary_account)
        (account_has_sell_leg_slot ?primary_account ?sell_leg)
        (account_has_buy_leg_slot ?secondary_account ?buy_leg)
        (sell_leg_reserved ?sell_leg)
        (buy_leg_reserved ?buy_leg)
        (primary_account_sell_confirmed ?primary_account)
        (secondary_account_buy_confirmed ?secondary_account)
        (trade_ticket_available ?trade_ticket)
      )
    :effect
      (and
        (trade_ticket_created ?trade_ticket)
        (trade_ticket_has_sell_leg ?trade_ticket ?sell_leg)
        (trade_ticket_has_buy_leg ?trade_ticket ?buy_leg)
        (not
          (trade_ticket_available ?trade_ticket)
        )
      )
  )
  (:action construct_trade_ticket_include_sell_allocated
    :parameters (?primary_account - primary_account ?secondary_account - secondary_account ?sell_leg - sell_leg_slot ?buy_leg - buy_leg_slot ?trade_ticket - trade_ticket)
    :precondition
      (and
        (primary_account_ready_for_ticket ?primary_account)
        (secondary_account_ready_for_ticket ?secondary_account)
        (account_has_sell_leg_slot ?primary_account ?sell_leg)
        (account_has_buy_leg_slot ?secondary_account ?buy_leg)
        (sell_leg_allocated ?sell_leg)
        (buy_leg_reserved ?buy_leg)
        (not
          (primary_account_sell_confirmed ?primary_account)
        )
        (secondary_account_buy_confirmed ?secondary_account)
        (trade_ticket_available ?trade_ticket)
      )
    :effect
      (and
        (trade_ticket_created ?trade_ticket)
        (trade_ticket_has_sell_leg ?trade_ticket ?sell_leg)
        (trade_ticket_has_buy_leg ?trade_ticket ?buy_leg)
        (trade_ticket_sell_leg_confirmed ?trade_ticket)
        (not
          (trade_ticket_available ?trade_ticket)
        )
      )
  )
  (:action construct_trade_ticket_include_buy_allocated
    :parameters (?primary_account - primary_account ?secondary_account - secondary_account ?sell_leg - sell_leg_slot ?buy_leg - buy_leg_slot ?trade_ticket - trade_ticket)
    :precondition
      (and
        (primary_account_ready_for_ticket ?primary_account)
        (secondary_account_ready_for_ticket ?secondary_account)
        (account_has_sell_leg_slot ?primary_account ?sell_leg)
        (account_has_buy_leg_slot ?secondary_account ?buy_leg)
        (sell_leg_reserved ?sell_leg)
        (buy_leg_allocated ?buy_leg)
        (primary_account_sell_confirmed ?primary_account)
        (not
          (secondary_account_buy_confirmed ?secondary_account)
        )
        (trade_ticket_available ?trade_ticket)
      )
    :effect
      (and
        (trade_ticket_created ?trade_ticket)
        (trade_ticket_has_sell_leg ?trade_ticket ?sell_leg)
        (trade_ticket_has_buy_leg ?trade_ticket ?buy_leg)
        (trade_ticket_buy_leg_confirmed ?trade_ticket)
        (not
          (trade_ticket_available ?trade_ticket)
        )
      )
  )
  (:action construct_trade_ticket_include_both_allocated
    :parameters (?primary_account - primary_account ?secondary_account - secondary_account ?sell_leg - sell_leg_slot ?buy_leg - buy_leg_slot ?trade_ticket - trade_ticket)
    :precondition
      (and
        (primary_account_ready_for_ticket ?primary_account)
        (secondary_account_ready_for_ticket ?secondary_account)
        (account_has_sell_leg_slot ?primary_account ?sell_leg)
        (account_has_buy_leg_slot ?secondary_account ?buy_leg)
        (sell_leg_allocated ?sell_leg)
        (buy_leg_allocated ?buy_leg)
        (not
          (primary_account_sell_confirmed ?primary_account)
        )
        (not
          (secondary_account_buy_confirmed ?secondary_account)
        )
        (trade_ticket_available ?trade_ticket)
      )
    :effect
      (and
        (trade_ticket_created ?trade_ticket)
        (trade_ticket_has_sell_leg ?trade_ticket ?sell_leg)
        (trade_ticket_has_buy_leg ?trade_ticket ?buy_leg)
        (trade_ticket_sell_leg_confirmed ?trade_ticket)
        (trade_ticket_buy_leg_confirmed ?trade_ticket)
        (not
          (trade_ticket_available ?trade_ticket)
        )
      )
  )
  (:action mark_trade_ticket_ready_for_settlement
    :parameters (?trade_ticket - trade_ticket ?primary_account - primary_account ?security_candidate - security_candidate)
    :precondition
      (and
        (trade_ticket_created ?trade_ticket)
        (primary_account_ready_for_ticket ?primary_account)
        (has_candidate_security ?primary_account ?security_candidate)
        (not
          (trade_ticket_ready ?trade_ticket)
        )
      )
    :effect (trade_ticket_ready ?trade_ticket)
  )
  (:action reserve_settlement_instruction_for_order
    :parameters (?execution_order - execution_order ?settlement_instruction - settlement_instruction ?trade_ticket - trade_ticket)
    :precondition
      (and
        (candidate_validated ?execution_order)
        (execution_order_has_trade_ticket ?execution_order ?trade_ticket)
        (execution_order_has_settlement_instruction ?execution_order ?settlement_instruction)
        (settlement_instruction_available ?settlement_instruction)
        (trade_ticket_created ?trade_ticket)
        (trade_ticket_ready ?trade_ticket)
        (not
          (settlement_instruction_locked ?settlement_instruction)
        )
      )
    :effect
      (and
        (settlement_instruction_locked ?settlement_instruction)
        (settlement_instruction_for_trade_ticket ?settlement_instruction ?trade_ticket)
        (not
          (settlement_instruction_available ?settlement_instruction)
        )
      )
  )
  (:action lock_settlement_instruction_for_order
    :parameters (?execution_order - execution_order ?settlement_instruction - settlement_instruction ?trade_ticket - trade_ticket ?security_candidate - security_candidate)
    :precondition
      (and
        (candidate_validated ?execution_order)
        (execution_order_has_settlement_instruction ?execution_order ?settlement_instruction)
        (settlement_instruction_locked ?settlement_instruction)
        (settlement_instruction_for_trade_ticket ?settlement_instruction ?trade_ticket)
        (has_candidate_security ?execution_order ?security_candidate)
        (not
          (trade_ticket_sell_leg_confirmed ?trade_ticket)
        )
        (not
          (execution_order_settlement_assigned ?execution_order)
        )
      )
    :effect (execution_order_settlement_assigned ?execution_order)
  )
  (:action attach_execution_strategy_to_order
    :parameters (?execution_order - execution_order ?execution_strategy - execution_strategy)
    :precondition
      (and
        (candidate_validated ?execution_order)
        (execution_strategy_available ?execution_strategy)
        (not
          (execution_strategy_attached ?execution_order)
        )
      )
    :effect
      (and
        (execution_strategy_attached ?execution_order)
        (execution_order_has_strategy ?execution_order ?execution_strategy)
        (not
          (execution_strategy_available ?execution_strategy)
        )
      )
  )
  (:action configure_execution_strategy_and_advance_approval
    :parameters (?execution_order - execution_order ?settlement_instruction - settlement_instruction ?trade_ticket - trade_ticket ?security_candidate - security_candidate ?execution_strategy - execution_strategy)
    :precondition
      (and
        (candidate_validated ?execution_order)
        (execution_order_has_settlement_instruction ?execution_order ?settlement_instruction)
        (settlement_instruction_locked ?settlement_instruction)
        (settlement_instruction_for_trade_ticket ?settlement_instruction ?trade_ticket)
        (has_candidate_security ?execution_order ?security_candidate)
        (trade_ticket_sell_leg_confirmed ?trade_ticket)
        (execution_strategy_attached ?execution_order)
        (execution_order_has_strategy ?execution_order ?execution_strategy)
        (not
          (execution_order_settlement_assigned ?execution_order)
        )
      )
    :effect
      (and
        (execution_order_settlement_assigned ?execution_order)
        (execution_strategy_configured ?execution_order)
      )
  )
  (:action collect_compliance_approval
    :parameters (?execution_order - execution_order ?compliance_approver - compliance_approver ?execution_agent - execution_agent ?settlement_instruction - settlement_instruction ?trade_ticket - trade_ticket)
    :precondition
      (and
        (execution_order_settlement_assigned ?execution_order)
        (execution_order_has_compliance_approval ?execution_order ?compliance_approver)
        (assigned_execution_agent ?execution_order ?execution_agent)
        (execution_order_has_settlement_instruction ?execution_order ?settlement_instruction)
        (settlement_instruction_for_trade_ticket ?settlement_instruction ?trade_ticket)
        (not
          (trade_ticket_buy_leg_confirmed ?trade_ticket)
        )
        (not
          (order_has_compliance_approval ?execution_order)
        )
      )
    :effect (order_has_compliance_approval ?execution_order)
  )
  (:action confirm_compliance_approval
    :parameters (?execution_order - execution_order ?compliance_approver - compliance_approver ?execution_agent - execution_agent ?settlement_instruction - settlement_instruction ?trade_ticket - trade_ticket)
    :precondition
      (and
        (execution_order_settlement_assigned ?execution_order)
        (execution_order_has_compliance_approval ?execution_order ?compliance_approver)
        (assigned_execution_agent ?execution_order ?execution_agent)
        (execution_order_has_settlement_instruction ?execution_order ?settlement_instruction)
        (settlement_instruction_for_trade_ticket ?settlement_instruction ?trade_ticket)
        (trade_ticket_buy_leg_confirmed ?trade_ticket)
        (not
          (order_has_compliance_approval ?execution_order)
        )
      )
    :effect (order_has_compliance_approval ?execution_order)
  )
  (:action collect_risk_approval_and_progress_flow
    :parameters (?execution_order - execution_order ?risk_approver - risk_approver ?settlement_instruction - settlement_instruction ?trade_ticket - trade_ticket)
    :precondition
      (and
        (order_has_compliance_approval ?execution_order)
        (execution_order_has_risk_approval ?execution_order ?risk_approver)
        (execution_order_has_settlement_instruction ?execution_order ?settlement_instruction)
        (settlement_instruction_for_trade_ticket ?settlement_instruction ?trade_ticket)
        (not
          (trade_ticket_sell_leg_confirmed ?trade_ticket)
        )
        (not
          (trade_ticket_buy_leg_confirmed ?trade_ticket)
        )
        (not
          (order_approvals_completed ?execution_order)
        )
      )
    :effect (order_approvals_completed ?execution_order)
  )
  (:action collect_risk_and_record_portfolio_approval
    :parameters (?execution_order - execution_order ?risk_approver - risk_approver ?settlement_instruction - settlement_instruction ?trade_ticket - trade_ticket)
    :precondition
      (and
        (order_has_compliance_approval ?execution_order)
        (execution_order_has_risk_approval ?execution_order ?risk_approver)
        (execution_order_has_settlement_instruction ?execution_order ?settlement_instruction)
        (settlement_instruction_for_trade_ticket ?settlement_instruction ?trade_ticket)
        (trade_ticket_sell_leg_confirmed ?trade_ticket)
        (not
          (trade_ticket_buy_leg_confirmed ?trade_ticket)
        )
        (not
          (order_approvals_completed ?execution_order)
        )
      )
    :effect
      (and
        (order_approvals_completed ?execution_order)
        (portfolio_approval_collected ?execution_order)
      )
  )
  (:action collect_risk_and_record_portfolio_approval_alt
    :parameters (?execution_order - execution_order ?risk_approver - risk_approver ?settlement_instruction - settlement_instruction ?trade_ticket - trade_ticket)
    :precondition
      (and
        (order_has_compliance_approval ?execution_order)
        (execution_order_has_risk_approval ?execution_order ?risk_approver)
        (execution_order_has_settlement_instruction ?execution_order ?settlement_instruction)
        (settlement_instruction_for_trade_ticket ?settlement_instruction ?trade_ticket)
        (not
          (trade_ticket_sell_leg_confirmed ?trade_ticket)
        )
        (trade_ticket_buy_leg_confirmed ?trade_ticket)
        (not
          (order_approvals_completed ?execution_order)
        )
      )
    :effect
      (and
        (order_approvals_completed ?execution_order)
        (portfolio_approval_collected ?execution_order)
      )
  )
  (:action collect_risk_and_record_portfolio_approval_full
    :parameters (?execution_order - execution_order ?risk_approver - risk_approver ?settlement_instruction - settlement_instruction ?trade_ticket - trade_ticket)
    :precondition
      (and
        (order_has_compliance_approval ?execution_order)
        (execution_order_has_risk_approval ?execution_order ?risk_approver)
        (execution_order_has_settlement_instruction ?execution_order ?settlement_instruction)
        (settlement_instruction_for_trade_ticket ?settlement_instruction ?trade_ticket)
        (trade_ticket_sell_leg_confirmed ?trade_ticket)
        (trade_ticket_buy_leg_confirmed ?trade_ticket)
        (not
          (order_approvals_completed ?execution_order)
        )
      )
    :effect
      (and
        (order_approvals_completed ?execution_order)
        (portfolio_approval_collected ?execution_order)
      )
  )
  (:action finalize_allocation_and_record_assignment
    :parameters (?execution_order - execution_order)
    :precondition
      (and
        (order_approvals_completed ?execution_order)
        (not
          (portfolio_approval_collected ?execution_order)
        )
        (not
          (execution_order_booking_completed ?execution_order)
        )
      )
    :effect
      (and
        (execution_order_booking_completed ?execution_order)
        (final_assignment_recorded ?execution_order)
      )
  )
  (:action assign_allocation_model_to_order
    :parameters (?execution_order - execution_order ?allocation_model - allocation_model)
    :precondition
      (and
        (order_approvals_completed ?execution_order)
        (portfolio_approval_collected ?execution_order)
        (allocation_model_available ?allocation_model)
      )
    :effect
      (and
        (execution_order_has_allocation_model ?execution_order ?allocation_model)
        (not
          (allocation_model_available ?allocation_model)
        )
      )
  )
  (:action perform_allocation_and_mark_order
    :parameters (?execution_order - execution_order ?primary_account - primary_account ?secondary_account - secondary_account ?security_candidate - security_candidate ?allocation_model - allocation_model)
    :precondition
      (and
        (order_approvals_completed ?execution_order)
        (portfolio_approval_collected ?execution_order)
        (execution_order_has_allocation_model ?execution_order ?allocation_model)
        (execution_order_has_primary_account ?execution_order ?primary_account)
        (execution_order_has_secondary_account ?execution_order ?secondary_account)
        (primary_account_sell_confirmed ?primary_account)
        (secondary_account_buy_confirmed ?secondary_account)
        (has_candidate_security ?execution_order ?security_candidate)
        (not
          (order_allocation_ready ?execution_order)
        )
      )
    :effect (order_allocation_ready ?execution_order)
  )
  (:action finalize_booking_and_close_order
    :parameters (?execution_order - execution_order)
    :precondition
      (and
        (order_approvals_completed ?execution_order)
        (order_allocation_ready ?execution_order)
        (not
          (execution_order_booking_completed ?execution_order)
        )
      )
    :effect
      (and
        (execution_order_booking_completed ?execution_order)
        (final_assignment_recorded ?execution_order)
      )
  )
  (:action reserve_portfolio_approver_for_order
    :parameters (?execution_order - execution_order ?portfolio_approver - portfolio_approver ?security_candidate - security_candidate)
    :precondition
      (and
        (candidate_validated ?execution_order)
        (has_candidate_security ?execution_order ?security_candidate)
        (portfolio_approver_available ?portfolio_approver)
        (execution_order_has_portfolio_approver ?execution_order ?portfolio_approver)
        (not
          (portfolio_approver_reserved ?execution_order)
        )
      )
    :effect
      (and
        (portfolio_approver_reserved ?execution_order)
        (not
          (portfolio_approver_available ?portfolio_approver)
        )
      )
  )
  (:action confirm_portfolio_approval_on_order
    :parameters (?execution_order - execution_order ?execution_agent - execution_agent)
    :precondition
      (and
        (portfolio_approver_reserved ?execution_order)
        (assigned_execution_agent ?execution_order ?execution_agent)
        (not
          (portfolio_approval_confirmed ?execution_order)
        )
      )
    :effect (portfolio_approval_confirmed ?execution_order)
  )
  (:action confirm_risk_approval_on_order
    :parameters (?execution_order - execution_order ?risk_approver - risk_approver)
    :precondition
      (and
        (portfolio_approval_confirmed ?execution_order)
        (execution_order_has_risk_approval ?execution_order ?risk_approver)
        (not
          (risk_approval_confirmed ?execution_order)
        )
      )
    :effect (risk_approval_confirmed ?execution_order)
  )
  (:action finalize_assignment_after_approvals
    :parameters (?execution_order - execution_order)
    :precondition
      (and
        (risk_approval_confirmed ?execution_order)
        (not
          (execution_order_booking_completed ?execution_order)
        )
      )
    :effect
      (and
        (execution_order_booking_completed ?execution_order)
        (final_assignment_recorded ?execution_order)
      )
  )
  (:action assign_ticket_result_to_primary_account
    :parameters (?primary_account - primary_account ?trade_ticket - trade_ticket)
    :precondition
      (and
        (primary_account_ready_for_ticket ?primary_account)
        (primary_account_sell_confirmed ?primary_account)
        (trade_ticket_created ?trade_ticket)
        (trade_ticket_ready ?trade_ticket)
        (not
          (final_assignment_recorded ?primary_account)
        )
      )
    :effect (final_assignment_recorded ?primary_account)
  )
  (:action assign_ticket_result_to_secondary_account
    :parameters (?secondary_account - secondary_account ?trade_ticket - trade_ticket)
    :precondition
      (and
        (secondary_account_ready_for_ticket ?secondary_account)
        (secondary_account_buy_confirmed ?secondary_account)
        (trade_ticket_created ?trade_ticket)
        (trade_ticket_ready ?trade_ticket)
        (not
          (final_assignment_recorded ?secondary_account)
        )
      )
    :effect (final_assignment_recorded ?secondary_account)
  )
  (:action attach_trade_reference_to_case
    :parameters (?breach_case - case_root ?trade_reference - trade_reference ?security_candidate - security_candidate)
    :precondition
      (and
        (final_assignment_recorded ?breach_case)
        (has_candidate_security ?breach_case ?security_candidate)
        (trade_reference_available ?trade_reference)
        (not
          (trade_reference_attached ?breach_case)
        )
      )
    :effect
      (and
        (trade_reference_attached ?breach_case)
        (case_has_trade_reference ?breach_case ?trade_reference)
        (not
          (trade_reference_available ?trade_reference)
        )
      )
  )
  (:action propagate_remediation_instrument_to_account
    :parameters (?primary_account - primary_account ?remediation_instrument - remediation_instrument ?trade_reference - trade_reference)
    :precondition
      (and
        (trade_reference_attached ?primary_account)
        (case_has_remediation_instrument ?primary_account ?remediation_instrument)
        (case_has_trade_reference ?primary_account ?trade_reference)
        (not
          (remediation_assigned ?primary_account)
        )
      )
    :effect
      (and
        (remediation_assigned ?primary_account)
        (remediation_instrument_available ?remediation_instrument)
        (trade_reference_available ?trade_reference)
      )
  )
  (:action propagate_remediation_instrument_to_secondary_account
    :parameters (?secondary_account - secondary_account ?remediation_instrument - remediation_instrument ?trade_reference - trade_reference)
    :precondition
      (and
        (trade_reference_attached ?secondary_account)
        (case_has_remediation_instrument ?secondary_account ?remediation_instrument)
        (case_has_trade_reference ?secondary_account ?trade_reference)
        (not
          (remediation_assigned ?secondary_account)
        )
      )
    :effect
      (and
        (remediation_assigned ?secondary_account)
        (remediation_instrument_available ?remediation_instrument)
        (trade_reference_available ?trade_reference)
      )
  )
  (:action propagate_remediation_instrument_to_execution_order
    :parameters (?execution_order - execution_order ?remediation_instrument - remediation_instrument ?trade_reference - trade_reference)
    :precondition
      (and
        (trade_reference_attached ?execution_order)
        (case_has_remediation_instrument ?execution_order ?remediation_instrument)
        (case_has_trade_reference ?execution_order ?trade_reference)
        (not
          (remediation_assigned ?execution_order)
        )
      )
    :effect
      (and
        (remediation_assigned ?execution_order)
        (remediation_instrument_available ?remediation_instrument)
        (trade_reference_available ?trade_reference)
      )
  )
)

(define (domain treasury_account_sweep_decisioning)
  (:requirements :strips :typing :negative-preconditions)
  (:types profile_category - object instruction_category - object leg_category - object account_category - object ledger_account - account_category sweep_destination_profile - profile_category cash_position_snapshot - profile_category authorization_profile - profile_category business_constraint - profile_category execution_mode - profile_category timing_profile - profile_category buffer_policy - profile_category compliance_check - profile_category sweep_instruction_template - instruction_category settlement_instruction - instruction_category escalation_policy - instruction_category sweep_leg - leg_category counterparty_leg - leg_category sweep_order - leg_category account_role_group - ledger_account account_processing_group - ledger_account source_account - account_role_group destination_account - account_role_group sweep_engine - account_processing_group)
  (:predicates
    (account_enrolled ?ledger_account - ledger_account)
    (entity_eligible_for_sweep ?ledger_account - ledger_account)
    (has_destination_profile ?ledger_account - ledger_account)
    (relinked_for_next_sweep ?ledger_account - ledger_account)
    (entity_execution_registered ?ledger_account - ledger_account)
    (execution_completed ?ledger_account - ledger_account)
    (destination_profile_available ?sweep_destination_profile - sweep_destination_profile)
    (account_destination_profile_link ?ledger_account - ledger_account ?sweep_destination_profile - sweep_destination_profile)
    (cash_snapshot_available ?cash_position_snapshot - cash_position_snapshot)
    (account_cash_snapshot_link ?ledger_account - ledger_account ?cash_position_snapshot - cash_position_snapshot)
    (authorization_profile_available ?authorization_profile - authorization_profile)
    (account_authorization_link ?ledger_account - ledger_account ?authorization_profile - authorization_profile)
    (sweep_instruction_template_available ?sweep_instruction_template - sweep_instruction_template)
    (source_instruction_template_link ?source_account - source_account ?sweep_instruction_template - sweep_instruction_template)
    (destination_instruction_template_link ?destination_account - destination_account ?sweep_instruction_template - sweep_instruction_template)
    (source_account_sweep_leg_link ?source_account - source_account ?sweep_leg - sweep_leg)
    (sweep_leg_selected ?sweep_leg - sweep_leg)
    (sweep_leg_template_applied ?sweep_leg - sweep_leg)
    (source_account_prioritized ?source_account - source_account)
    (destination_account_counterparty_leg_link ?destination_account - destination_account ?counterparty_leg - counterparty_leg)
    (counterparty_leg_selected ?counterparty_leg - counterparty_leg)
    (counterparty_leg_template_applied ?counterparty_leg - counterparty_leg)
    (destination_account_prioritized ?destination_account - destination_account)
    (sweep_order_open ?sweep_order - sweep_order)
    (sweep_order_assembled ?sweep_order - sweep_order)
    (order_source_leg_link ?sweep_order - sweep_order ?sweep_leg - sweep_leg)
    (order_counterparty_leg_link ?sweep_order - sweep_order ?counterparty_leg - counterparty_leg)
    (order_source_template_flag ?sweep_order - sweep_order)
    (order_destination_template_flag ?sweep_order - sweep_order)
    (order_settlement_ready ?sweep_order - sweep_order)
    (sweep_engine_bound_to_source_account ?sweep_engine - sweep_engine ?source_account - source_account)
    (sweep_engine_bound_to_destination_account ?sweep_engine - sweep_engine ?destination_account - destination_account)
    (sweep_engine_order_link ?sweep_engine - sweep_engine ?sweep_order - sweep_order)
    (settlement_instruction_available ?settlement_instruction - settlement_instruction)
    (engine_settlement_instruction_link ?sweep_engine - sweep_engine ?settlement_instruction - settlement_instruction)
    (settlement_instruction_bound ?settlement_instruction - settlement_instruction)
    (settlement_instruction_order_link ?settlement_instruction - settlement_instruction ?sweep_order - sweep_order)
    (engine_instrument_bound ?sweep_engine - sweep_engine)
    (engine_ready_for_approval ?sweep_engine - sweep_engine)
    (engine_approval_complete ?sweep_engine - sweep_engine)
    (engine_constraint_assigned ?sweep_engine - sweep_engine)
    (engine_business_constraint_applied ?sweep_engine - sweep_engine)
    (engine_escalation_required ?sweep_engine - sweep_engine)
    (engine_final_gate_passed ?sweep_engine - sweep_engine)
    (escalation_policy_available ?escalation_policy - escalation_policy)
    (engine_escalation_policy_link ?sweep_engine - sweep_engine ?escalation_policy - escalation_policy)
    (engine_escalation_attached ?sweep_engine - sweep_engine)
    (engine_escalation_active ?sweep_engine - sweep_engine)
    (engine_escalation_approved ?sweep_engine - sweep_engine)
    (business_constraint_available ?business_constraint - business_constraint)
    (engine_business_constraint_link ?sweep_engine - sweep_engine ?business_constraint - business_constraint)
    (execution_mode_available ?execution_mode - execution_mode)
    (engine_execution_mode_link ?sweep_engine - sweep_engine ?execution_mode - execution_mode)
    (buffer_policy_available ?buffer_policy - buffer_policy)
    (engine_buffer_policy_link ?sweep_engine - sweep_engine ?buffer_policy - buffer_policy)
    (compliance_check_available ?compliance_check - compliance_check)
    (engine_compliance_check_link ?sweep_engine - sweep_engine ?compliance_check - compliance_check)
    (timing_profile_available ?timing_profile - timing_profile)
    (account_timing_profile_link ?ledger_account - ledger_account ?timing_profile - timing_profile)
    (source_account_reserved_for_order ?source_account - source_account)
    (destination_account_reserved_for_order ?destination_account - destination_account)
    (engine_execution_committed ?sweep_engine - sweep_engine)
  )
  (:action enroll_account_for_sweep
    :parameters (?ledger_account - ledger_account)
    :precondition
      (and
        (not
          (account_enrolled ?ledger_account)
        )
        (not
          (relinked_for_next_sweep ?ledger_account)
        )
      )
    :effect (account_enrolled ?ledger_account)
  )
  (:action link_account_to_destination_profile
    :parameters (?ledger_account - ledger_account ?sweep_destination_profile - sweep_destination_profile)
    :precondition
      (and
        (account_enrolled ?ledger_account)
        (not
          (has_destination_profile ?ledger_account)
        )
        (destination_profile_available ?sweep_destination_profile)
      )
    :effect
      (and
        (has_destination_profile ?ledger_account)
        (account_destination_profile_link ?ledger_account ?sweep_destination_profile)
        (not
          (destination_profile_available ?sweep_destination_profile)
        )
      )
  )
  (:action associate_cash_snapshot_with_account
    :parameters (?ledger_account - ledger_account ?cash_position_snapshot - cash_position_snapshot)
    :precondition
      (and
        (account_enrolled ?ledger_account)
        (has_destination_profile ?ledger_account)
        (cash_snapshot_available ?cash_position_snapshot)
      )
    :effect
      (and
        (account_cash_snapshot_link ?ledger_account ?cash_position_snapshot)
        (not
          (cash_snapshot_available ?cash_position_snapshot)
        )
      )
  )
  (:action confirm_account_eligibility
    :parameters (?ledger_account - ledger_account ?cash_position_snapshot - cash_position_snapshot)
    :precondition
      (and
        (account_enrolled ?ledger_account)
        (has_destination_profile ?ledger_account)
        (account_cash_snapshot_link ?ledger_account ?cash_position_snapshot)
        (not
          (entity_eligible_for_sweep ?ledger_account)
        )
      )
    :effect (entity_eligible_for_sweep ?ledger_account)
  )
  (:action release_cash_snapshot
    :parameters (?ledger_account - ledger_account ?cash_position_snapshot - cash_position_snapshot)
    :precondition
      (and
        (account_cash_snapshot_link ?ledger_account ?cash_position_snapshot)
      )
    :effect
      (and
        (cash_snapshot_available ?cash_position_snapshot)
        (not
          (account_cash_snapshot_link ?ledger_account ?cash_position_snapshot)
        )
      )
  )
  (:action attach_authorization_profile_to_account
    :parameters (?ledger_account - ledger_account ?authorization_profile - authorization_profile)
    :precondition
      (and
        (entity_eligible_for_sweep ?ledger_account)
        (authorization_profile_available ?authorization_profile)
      )
    :effect
      (and
        (account_authorization_link ?ledger_account ?authorization_profile)
        (not
          (authorization_profile_available ?authorization_profile)
        )
      )
  )
  (:action detach_authorization_profile_from_account
    :parameters (?ledger_account - ledger_account ?authorization_profile - authorization_profile)
    :precondition
      (and
        (account_authorization_link ?ledger_account ?authorization_profile)
      )
    :effect
      (and
        (authorization_profile_available ?authorization_profile)
        (not
          (account_authorization_link ?ledger_account ?authorization_profile)
        )
      )
  )
  (:action attach_buffer_policy_to_engine
    :parameters (?sweep_engine - sweep_engine ?buffer_policy - buffer_policy)
    :precondition
      (and
        (entity_eligible_for_sweep ?sweep_engine)
        (buffer_policy_available ?buffer_policy)
      )
    :effect
      (and
        (engine_buffer_policy_link ?sweep_engine ?buffer_policy)
        (not
          (buffer_policy_available ?buffer_policy)
        )
      )
  )
  (:action detach_buffer_policy_from_engine
    :parameters (?sweep_engine - sweep_engine ?buffer_policy - buffer_policy)
    :precondition
      (and
        (engine_buffer_policy_link ?sweep_engine ?buffer_policy)
      )
    :effect
      (and
        (buffer_policy_available ?buffer_policy)
        (not
          (engine_buffer_policy_link ?sweep_engine ?buffer_policy)
        )
      )
  )
  (:action attach_compliance_check_to_engine
    :parameters (?sweep_engine - sweep_engine ?compliance_check - compliance_check)
    :precondition
      (and
        (entity_eligible_for_sweep ?sweep_engine)
        (compliance_check_available ?compliance_check)
      )
    :effect
      (and
        (engine_compliance_check_link ?sweep_engine ?compliance_check)
        (not
          (compliance_check_available ?compliance_check)
        )
      )
  )
  (:action detach_compliance_check_from_engine
    :parameters (?sweep_engine - sweep_engine ?compliance_check - compliance_check)
    :precondition
      (and
        (engine_compliance_check_link ?sweep_engine ?compliance_check)
      )
    :effect
      (and
        (compliance_check_available ?compliance_check)
        (not
          (engine_compliance_check_link ?sweep_engine ?compliance_check)
        )
      )
  )
  (:action select_sweep_leg_candidate
    :parameters (?source_account - source_account ?sweep_leg - sweep_leg ?cash_position_snapshot - cash_position_snapshot)
    :precondition
      (and
        (entity_eligible_for_sweep ?source_account)
        (account_cash_snapshot_link ?source_account ?cash_position_snapshot)
        (source_account_sweep_leg_link ?source_account ?sweep_leg)
        (not
          (sweep_leg_selected ?sweep_leg)
        )
        (not
          (sweep_leg_template_applied ?sweep_leg)
        )
      )
    :effect (sweep_leg_selected ?sweep_leg)
  )
  (:action reserve_source_account_for_leg
    :parameters (?source_account - source_account ?sweep_leg - sweep_leg ?authorization_profile - authorization_profile)
    :precondition
      (and
        (entity_eligible_for_sweep ?source_account)
        (account_authorization_link ?source_account ?authorization_profile)
        (source_account_sweep_leg_link ?source_account ?sweep_leg)
        (sweep_leg_selected ?sweep_leg)
        (not
          (source_account_reserved_for_order ?source_account)
        )
      )
    :effect
      (and
        (source_account_reserved_for_order ?source_account)
        (source_account_prioritized ?source_account)
      )
  )
  (:action apply_instruction_template_to_source_leg
    :parameters (?source_account - source_account ?sweep_leg - sweep_leg ?sweep_instruction_template - sweep_instruction_template)
    :precondition
      (and
        (entity_eligible_for_sweep ?source_account)
        (source_account_sweep_leg_link ?source_account ?sweep_leg)
        (sweep_instruction_template_available ?sweep_instruction_template)
        (not
          (source_account_reserved_for_order ?source_account)
        )
      )
    :effect
      (and
        (sweep_leg_template_applied ?sweep_leg)
        (source_account_reserved_for_order ?source_account)
        (source_instruction_template_link ?source_account ?sweep_instruction_template)
        (not
          (sweep_instruction_template_available ?sweep_instruction_template)
        )
      )
  )
  (:action prioritize_source_leg
    :parameters (?source_account - source_account ?sweep_leg - sweep_leg ?cash_position_snapshot - cash_position_snapshot ?sweep_instruction_template - sweep_instruction_template)
    :precondition
      (and
        (entity_eligible_for_sweep ?source_account)
        (account_cash_snapshot_link ?source_account ?cash_position_snapshot)
        (source_account_sweep_leg_link ?source_account ?sweep_leg)
        (sweep_leg_template_applied ?sweep_leg)
        (source_instruction_template_link ?source_account ?sweep_instruction_template)
        (not
          (source_account_prioritized ?source_account)
        )
      )
    :effect
      (and
        (sweep_leg_selected ?sweep_leg)
        (source_account_prioritized ?source_account)
        (sweep_instruction_template_available ?sweep_instruction_template)
        (not
          (source_instruction_template_link ?source_account ?sweep_instruction_template)
        )
      )
  )
  (:action select_counterparty_leg_candidate
    :parameters (?destination_account - destination_account ?counterparty_leg - counterparty_leg ?cash_position_snapshot - cash_position_snapshot)
    :precondition
      (and
        (entity_eligible_for_sweep ?destination_account)
        (account_cash_snapshot_link ?destination_account ?cash_position_snapshot)
        (destination_account_counterparty_leg_link ?destination_account ?counterparty_leg)
        (not
          (counterparty_leg_selected ?counterparty_leg)
        )
        (not
          (counterparty_leg_template_applied ?counterparty_leg)
        )
      )
    :effect (counterparty_leg_selected ?counterparty_leg)
  )
  (:action reserve_destination_account_for_leg
    :parameters (?destination_account - destination_account ?counterparty_leg - counterparty_leg ?authorization_profile - authorization_profile)
    :precondition
      (and
        (entity_eligible_for_sweep ?destination_account)
        (account_authorization_link ?destination_account ?authorization_profile)
        (destination_account_counterparty_leg_link ?destination_account ?counterparty_leg)
        (counterparty_leg_selected ?counterparty_leg)
        (not
          (destination_account_reserved_for_order ?destination_account)
        )
      )
    :effect
      (and
        (destination_account_reserved_for_order ?destination_account)
        (destination_account_prioritized ?destination_account)
      )
  )
  (:action apply_instruction_template_to_destination_leg
    :parameters (?destination_account - destination_account ?counterparty_leg - counterparty_leg ?sweep_instruction_template - sweep_instruction_template)
    :precondition
      (and
        (entity_eligible_for_sweep ?destination_account)
        (destination_account_counterparty_leg_link ?destination_account ?counterparty_leg)
        (sweep_instruction_template_available ?sweep_instruction_template)
        (not
          (destination_account_reserved_for_order ?destination_account)
        )
      )
    :effect
      (and
        (counterparty_leg_template_applied ?counterparty_leg)
        (destination_account_reserved_for_order ?destination_account)
        (destination_instruction_template_link ?destination_account ?sweep_instruction_template)
        (not
          (sweep_instruction_template_available ?sweep_instruction_template)
        )
      )
  )
  (:action prioritize_destination_leg
    :parameters (?destination_account - destination_account ?counterparty_leg - counterparty_leg ?cash_position_snapshot - cash_position_snapshot ?sweep_instruction_template - sweep_instruction_template)
    :precondition
      (and
        (entity_eligible_for_sweep ?destination_account)
        (account_cash_snapshot_link ?destination_account ?cash_position_snapshot)
        (destination_account_counterparty_leg_link ?destination_account ?counterparty_leg)
        (counterparty_leg_template_applied ?counterparty_leg)
        (destination_instruction_template_link ?destination_account ?sweep_instruction_template)
        (not
          (destination_account_prioritized ?destination_account)
        )
      )
    :effect
      (and
        (counterparty_leg_selected ?counterparty_leg)
        (destination_account_prioritized ?destination_account)
        (sweep_instruction_template_available ?sweep_instruction_template)
        (not
          (destination_instruction_template_link ?destination_account ?sweep_instruction_template)
        )
      )
  )
  (:action assemble_sweep_order_from_prioritized_legs
    :parameters (?source_account - source_account ?destination_account - destination_account ?sweep_leg - sweep_leg ?counterparty_leg - counterparty_leg ?sweep_order - sweep_order)
    :precondition
      (and
        (source_account_reserved_for_order ?source_account)
        (destination_account_reserved_for_order ?destination_account)
        (source_account_sweep_leg_link ?source_account ?sweep_leg)
        (destination_account_counterparty_leg_link ?destination_account ?counterparty_leg)
        (sweep_leg_selected ?sweep_leg)
        (counterparty_leg_selected ?counterparty_leg)
        (source_account_prioritized ?source_account)
        (destination_account_prioritized ?destination_account)
        (sweep_order_open ?sweep_order)
      )
    :effect
      (and
        (sweep_order_assembled ?sweep_order)
        (order_source_leg_link ?sweep_order ?sweep_leg)
        (order_counterparty_leg_link ?sweep_order ?counterparty_leg)
        (not
          (sweep_order_open ?sweep_order)
        )
      )
  )
  (:action assemble_sweep_order_source_templated
    :parameters (?source_account - source_account ?destination_account - destination_account ?sweep_leg - sweep_leg ?counterparty_leg - counterparty_leg ?sweep_order - sweep_order)
    :precondition
      (and
        (source_account_reserved_for_order ?source_account)
        (destination_account_reserved_for_order ?destination_account)
        (source_account_sweep_leg_link ?source_account ?sweep_leg)
        (destination_account_counterparty_leg_link ?destination_account ?counterparty_leg)
        (sweep_leg_template_applied ?sweep_leg)
        (counterparty_leg_selected ?counterparty_leg)
        (not
          (source_account_prioritized ?source_account)
        )
        (destination_account_prioritized ?destination_account)
        (sweep_order_open ?sweep_order)
      )
    :effect
      (and
        (sweep_order_assembled ?sweep_order)
        (order_source_leg_link ?sweep_order ?sweep_leg)
        (order_counterparty_leg_link ?sweep_order ?counterparty_leg)
        (order_source_template_flag ?sweep_order)
        (not
          (sweep_order_open ?sweep_order)
        )
      )
  )
  (:action assemble_sweep_order_destination_templated
    :parameters (?source_account - source_account ?destination_account - destination_account ?sweep_leg - sweep_leg ?counterparty_leg - counterparty_leg ?sweep_order - sweep_order)
    :precondition
      (and
        (source_account_reserved_for_order ?source_account)
        (destination_account_reserved_for_order ?destination_account)
        (source_account_sweep_leg_link ?source_account ?sweep_leg)
        (destination_account_counterparty_leg_link ?destination_account ?counterparty_leg)
        (sweep_leg_selected ?sweep_leg)
        (counterparty_leg_template_applied ?counterparty_leg)
        (source_account_prioritized ?source_account)
        (not
          (destination_account_prioritized ?destination_account)
        )
        (sweep_order_open ?sweep_order)
      )
    :effect
      (and
        (sweep_order_assembled ?sweep_order)
        (order_source_leg_link ?sweep_order ?sweep_leg)
        (order_counterparty_leg_link ?sweep_order ?counterparty_leg)
        (order_destination_template_flag ?sweep_order)
        (not
          (sweep_order_open ?sweep_order)
        )
      )
  )
  (:action assemble_sweep_order_both_templated
    :parameters (?source_account - source_account ?destination_account - destination_account ?sweep_leg - sweep_leg ?counterparty_leg - counterparty_leg ?sweep_order - sweep_order)
    :precondition
      (and
        (source_account_reserved_for_order ?source_account)
        (destination_account_reserved_for_order ?destination_account)
        (source_account_sweep_leg_link ?source_account ?sweep_leg)
        (destination_account_counterparty_leg_link ?destination_account ?counterparty_leg)
        (sweep_leg_template_applied ?sweep_leg)
        (counterparty_leg_template_applied ?counterparty_leg)
        (not
          (source_account_prioritized ?source_account)
        )
        (not
          (destination_account_prioritized ?destination_account)
        )
        (sweep_order_open ?sweep_order)
      )
    :effect
      (and
        (sweep_order_assembled ?sweep_order)
        (order_source_leg_link ?sweep_order ?sweep_leg)
        (order_counterparty_leg_link ?sweep_order ?counterparty_leg)
        (order_source_template_flag ?sweep_order)
        (order_destination_template_flag ?sweep_order)
        (not
          (sweep_order_open ?sweep_order)
        )
      )
  )
  (:action confirm_order_settlement_ready
    :parameters (?sweep_order - sweep_order ?source_account - source_account ?cash_position_snapshot - cash_position_snapshot)
    :precondition
      (and
        (sweep_order_assembled ?sweep_order)
        (source_account_reserved_for_order ?source_account)
        (account_cash_snapshot_link ?source_account ?cash_position_snapshot)
        (not
          (order_settlement_ready ?sweep_order)
        )
      )
    :effect (order_settlement_ready ?sweep_order)
  )
  (:action bind_settlement_instruction_to_order
    :parameters (?sweep_engine - sweep_engine ?settlement_instruction - settlement_instruction ?sweep_order - sweep_order)
    :precondition
      (and
        (entity_eligible_for_sweep ?sweep_engine)
        (sweep_engine_order_link ?sweep_engine ?sweep_order)
        (engine_settlement_instruction_link ?sweep_engine ?settlement_instruction)
        (settlement_instruction_available ?settlement_instruction)
        (sweep_order_assembled ?sweep_order)
        (order_settlement_ready ?sweep_order)
        (not
          (settlement_instruction_bound ?settlement_instruction)
        )
      )
    :effect
      (and
        (settlement_instruction_bound ?settlement_instruction)
        (settlement_instruction_order_link ?settlement_instruction ?sweep_order)
        (not
          (settlement_instruction_available ?settlement_instruction)
        )
      )
  )
  (:action bind_instrument_to_engine
    :parameters (?sweep_engine - sweep_engine ?settlement_instruction - settlement_instruction ?sweep_order - sweep_order ?cash_position_snapshot - cash_position_snapshot)
    :precondition
      (and
        (entity_eligible_for_sweep ?sweep_engine)
        (engine_settlement_instruction_link ?sweep_engine ?settlement_instruction)
        (settlement_instruction_bound ?settlement_instruction)
        (settlement_instruction_order_link ?settlement_instruction ?sweep_order)
        (account_cash_snapshot_link ?sweep_engine ?cash_position_snapshot)
        (not
          (order_source_template_flag ?sweep_order)
        )
        (not
          (engine_instrument_bound ?sweep_engine)
        )
      )
    :effect (engine_instrument_bound ?sweep_engine)
  )
  (:action attach_business_constraint_to_engine
    :parameters (?sweep_engine - sweep_engine ?business_constraint - business_constraint)
    :precondition
      (and
        (entity_eligible_for_sweep ?sweep_engine)
        (business_constraint_available ?business_constraint)
        (not
          (engine_constraint_assigned ?sweep_engine)
        )
      )
    :effect
      (and
        (engine_constraint_assigned ?sweep_engine)
        (engine_business_constraint_link ?sweep_engine ?business_constraint)
        (not
          (business_constraint_available ?business_constraint)
        )
      )
  )
  (:action apply_business_constraint_and_bind_instrument
    :parameters (?sweep_engine - sweep_engine ?settlement_instruction - settlement_instruction ?sweep_order - sweep_order ?cash_position_snapshot - cash_position_snapshot ?business_constraint - business_constraint)
    :precondition
      (and
        (entity_eligible_for_sweep ?sweep_engine)
        (engine_settlement_instruction_link ?sweep_engine ?settlement_instruction)
        (settlement_instruction_bound ?settlement_instruction)
        (settlement_instruction_order_link ?settlement_instruction ?sweep_order)
        (account_cash_snapshot_link ?sweep_engine ?cash_position_snapshot)
        (order_source_template_flag ?sweep_order)
        (engine_constraint_assigned ?sweep_engine)
        (engine_business_constraint_link ?sweep_engine ?business_constraint)
        (not
          (engine_instrument_bound ?sweep_engine)
        )
      )
    :effect
      (and
        (engine_instrument_bound ?sweep_engine)
        (engine_business_constraint_applied ?sweep_engine)
      )
  )
  (:action approve_engine_for_execution
    :parameters (?sweep_engine - sweep_engine ?buffer_policy - buffer_policy ?authorization_profile - authorization_profile ?settlement_instruction - settlement_instruction ?sweep_order - sweep_order)
    :precondition
      (and
        (engine_instrument_bound ?sweep_engine)
        (engine_buffer_policy_link ?sweep_engine ?buffer_policy)
        (account_authorization_link ?sweep_engine ?authorization_profile)
        (engine_settlement_instruction_link ?sweep_engine ?settlement_instruction)
        (settlement_instruction_order_link ?settlement_instruction ?sweep_order)
        (not
          (order_destination_template_flag ?sweep_order)
        )
        (not
          (engine_ready_for_approval ?sweep_engine)
        )
      )
    :effect (engine_ready_for_approval ?sweep_engine)
  )
  (:action approve_engine_for_execution_post_flag
    :parameters (?sweep_engine - sweep_engine ?buffer_policy - buffer_policy ?authorization_profile - authorization_profile ?settlement_instruction - settlement_instruction ?sweep_order - sweep_order)
    :precondition
      (and
        (engine_instrument_bound ?sweep_engine)
        (engine_buffer_policy_link ?sweep_engine ?buffer_policy)
        (account_authorization_link ?sweep_engine ?authorization_profile)
        (engine_settlement_instruction_link ?sweep_engine ?settlement_instruction)
        (settlement_instruction_order_link ?settlement_instruction ?sweep_order)
        (order_destination_template_flag ?sweep_order)
        (not
          (engine_ready_for_approval ?sweep_engine)
        )
      )
    :effect (engine_ready_for_approval ?sweep_engine)
  )
  (:action finalize_engine_approval_no_order_flags
    :parameters (?sweep_engine - sweep_engine ?compliance_check - compliance_check ?settlement_instruction - settlement_instruction ?sweep_order - sweep_order)
    :precondition
      (and
        (engine_ready_for_approval ?sweep_engine)
        (engine_compliance_check_link ?sweep_engine ?compliance_check)
        (engine_settlement_instruction_link ?sweep_engine ?settlement_instruction)
        (settlement_instruction_order_link ?settlement_instruction ?sweep_order)
        (not
          (order_source_template_flag ?sweep_order)
        )
        (not
          (order_destination_template_flag ?sweep_order)
        )
        (not
          (engine_approval_complete ?sweep_engine)
        )
      )
    :effect (engine_approval_complete ?sweep_engine)
  )
  (:action finalize_engine_approval_with_source_flag
    :parameters (?sweep_engine - sweep_engine ?compliance_check - compliance_check ?settlement_instruction - settlement_instruction ?sweep_order - sweep_order)
    :precondition
      (and
        (engine_ready_for_approval ?sweep_engine)
        (engine_compliance_check_link ?sweep_engine ?compliance_check)
        (engine_settlement_instruction_link ?sweep_engine ?settlement_instruction)
        (settlement_instruction_order_link ?settlement_instruction ?sweep_order)
        (order_source_template_flag ?sweep_order)
        (not
          (order_destination_template_flag ?sweep_order)
        )
        (not
          (engine_approval_complete ?sweep_engine)
        )
      )
    :effect
      (and
        (engine_approval_complete ?sweep_engine)
        (engine_escalation_required ?sweep_engine)
      )
  )
  (:action finalize_engine_approval_with_destination_flag
    :parameters (?sweep_engine - sweep_engine ?compliance_check - compliance_check ?settlement_instruction - settlement_instruction ?sweep_order - sweep_order)
    :precondition
      (and
        (engine_ready_for_approval ?sweep_engine)
        (engine_compliance_check_link ?sweep_engine ?compliance_check)
        (engine_settlement_instruction_link ?sweep_engine ?settlement_instruction)
        (settlement_instruction_order_link ?settlement_instruction ?sweep_order)
        (not
          (order_source_template_flag ?sweep_order)
        )
        (order_destination_template_flag ?sweep_order)
        (not
          (engine_approval_complete ?sweep_engine)
        )
      )
    :effect
      (and
        (engine_approval_complete ?sweep_engine)
        (engine_escalation_required ?sweep_engine)
      )
  )
  (:action finalize_engine_approval_with_both_flags
    :parameters (?sweep_engine - sweep_engine ?compliance_check - compliance_check ?settlement_instruction - settlement_instruction ?sweep_order - sweep_order)
    :precondition
      (and
        (engine_ready_for_approval ?sweep_engine)
        (engine_compliance_check_link ?sweep_engine ?compliance_check)
        (engine_settlement_instruction_link ?sweep_engine ?settlement_instruction)
        (settlement_instruction_order_link ?settlement_instruction ?sweep_order)
        (order_source_template_flag ?sweep_order)
        (order_destination_template_flag ?sweep_order)
        (not
          (engine_approval_complete ?sweep_engine)
        )
      )
    :effect
      (and
        (engine_approval_complete ?sweep_engine)
        (engine_escalation_required ?sweep_engine)
      )
  )
  (:action commit_and_register_engine_execution
    :parameters (?sweep_engine - sweep_engine)
    :precondition
      (and
        (engine_approval_complete ?sweep_engine)
        (not
          (engine_escalation_required ?sweep_engine)
        )
        (not
          (engine_execution_committed ?sweep_engine)
        )
      )
    :effect
      (and
        (engine_execution_committed ?sweep_engine)
        (entity_execution_registered ?sweep_engine)
      )
  )
  (:action attach_execution_mode_to_engine
    :parameters (?sweep_engine - sweep_engine ?execution_mode - execution_mode)
    :precondition
      (and
        (engine_approval_complete ?sweep_engine)
        (engine_escalation_required ?sweep_engine)
        (execution_mode_available ?execution_mode)
      )
    :effect
      (and
        (engine_execution_mode_link ?sweep_engine ?execution_mode)
        (not
          (execution_mode_available ?execution_mode)
        )
      )
  )
  (:action apply_final_gating_and_mark_engine
    :parameters (?sweep_engine - sweep_engine ?source_account - source_account ?destination_account - destination_account ?cash_position_snapshot - cash_position_snapshot ?execution_mode - execution_mode)
    :precondition
      (and
        (engine_approval_complete ?sweep_engine)
        (engine_escalation_required ?sweep_engine)
        (engine_execution_mode_link ?sweep_engine ?execution_mode)
        (sweep_engine_bound_to_source_account ?sweep_engine ?source_account)
        (sweep_engine_bound_to_destination_account ?sweep_engine ?destination_account)
        (source_account_prioritized ?source_account)
        (destination_account_prioritized ?destination_account)
        (account_cash_snapshot_link ?sweep_engine ?cash_position_snapshot)
        (not
          (engine_final_gate_passed ?sweep_engine)
        )
      )
    :effect (engine_final_gate_passed ?sweep_engine)
  )
  (:action commit_and_register_engine_execution_post_gating
    :parameters (?sweep_engine - sweep_engine)
    :precondition
      (and
        (engine_approval_complete ?sweep_engine)
        (engine_final_gate_passed ?sweep_engine)
        (not
          (engine_execution_committed ?sweep_engine)
        )
      )
    :effect
      (and
        (engine_execution_committed ?sweep_engine)
        (entity_execution_registered ?sweep_engine)
      )
  )
  (:action attach_escalation_policy_to_engine
    :parameters (?sweep_engine - sweep_engine ?escalation_policy - escalation_policy ?cash_position_snapshot - cash_position_snapshot)
    :precondition
      (and
        (entity_eligible_for_sweep ?sweep_engine)
        (account_cash_snapshot_link ?sweep_engine ?cash_position_snapshot)
        (escalation_policy_available ?escalation_policy)
        (engine_escalation_policy_link ?sweep_engine ?escalation_policy)
        (not
          (engine_escalation_attached ?sweep_engine)
        )
      )
    :effect
      (and
        (engine_escalation_attached ?sweep_engine)
        (not
          (escalation_policy_available ?escalation_policy)
        )
      )
  )
  (:action activate_escalation_for_engine
    :parameters (?sweep_engine - sweep_engine ?authorization_profile - authorization_profile)
    :precondition
      (and
        (engine_escalation_attached ?sweep_engine)
        (account_authorization_link ?sweep_engine ?authorization_profile)
        (not
          (engine_escalation_active ?sweep_engine)
        )
      )
    :effect (engine_escalation_active ?sweep_engine)
  )
  (:action approve_escalation_for_engine
    :parameters (?sweep_engine - sweep_engine ?compliance_check - compliance_check)
    :precondition
      (and
        (engine_escalation_active ?sweep_engine)
        (engine_compliance_check_link ?sweep_engine ?compliance_check)
        (not
          (engine_escalation_approved ?sweep_engine)
        )
      )
    :effect (engine_escalation_approved ?sweep_engine)
  )
  (:action commit_and_register_engine_execution_post_escalation
    :parameters (?sweep_engine - sweep_engine)
    :precondition
      (and
        (engine_escalation_approved ?sweep_engine)
        (not
          (engine_execution_committed ?sweep_engine)
        )
      )
    :effect
      (and
        (engine_execution_committed ?sweep_engine)
        (entity_execution_registered ?sweep_engine)
      )
  )
  (:action register_source_account_execution
    :parameters (?source_account - source_account ?sweep_order - sweep_order)
    :precondition
      (and
        (source_account_reserved_for_order ?source_account)
        (source_account_prioritized ?source_account)
        (sweep_order_assembled ?sweep_order)
        (order_settlement_ready ?sweep_order)
        (not
          (entity_execution_registered ?source_account)
        )
      )
    :effect (entity_execution_registered ?source_account)
  )
  (:action register_destination_account_execution
    :parameters (?destination_account - destination_account ?sweep_order - sweep_order)
    :precondition
      (and
        (destination_account_reserved_for_order ?destination_account)
        (destination_account_prioritized ?destination_account)
        (sweep_order_assembled ?sweep_order)
        (order_settlement_ready ?sweep_order)
        (not
          (entity_execution_registered ?destination_account)
        )
      )
    :effect (entity_execution_registered ?destination_account)
  )
  (:action rotate_timing_profile_and_tag_account_post_execution
    :parameters (?ledger_account - ledger_account ?timing_profile - timing_profile ?cash_position_snapshot - cash_position_snapshot)
    :precondition
      (and
        (entity_execution_registered ?ledger_account)
        (account_cash_snapshot_link ?ledger_account ?cash_position_snapshot)
        (timing_profile_available ?timing_profile)
        (not
          (execution_completed ?ledger_account)
        )
      )
    :effect
      (and
        (execution_completed ?ledger_account)
        (account_timing_profile_link ?ledger_account ?timing_profile)
        (not
          (timing_profile_available ?timing_profile)
        )
      )
  )
  (:action relink_source_account_for_next_sweep
    :parameters (?source_account - source_account ?sweep_destination_profile - sweep_destination_profile ?timing_profile - timing_profile)
    :precondition
      (and
        (execution_completed ?source_account)
        (account_destination_profile_link ?source_account ?sweep_destination_profile)
        (account_timing_profile_link ?source_account ?timing_profile)
        (not
          (relinked_for_next_sweep ?source_account)
        )
      )
    :effect
      (and
        (relinked_for_next_sweep ?source_account)
        (destination_profile_available ?sweep_destination_profile)
        (timing_profile_available ?timing_profile)
      )
  )
  (:action relink_destination_account_for_next_sweep
    :parameters (?destination_account - destination_account ?sweep_destination_profile - sweep_destination_profile ?timing_profile - timing_profile)
    :precondition
      (and
        (execution_completed ?destination_account)
        (account_destination_profile_link ?destination_account ?sweep_destination_profile)
        (account_timing_profile_link ?destination_account ?timing_profile)
        (not
          (relinked_for_next_sweep ?destination_account)
        )
      )
    :effect
      (and
        (relinked_for_next_sweep ?destination_account)
        (destination_profile_available ?sweep_destination_profile)
        (timing_profile_available ?timing_profile)
      )
  )
  (:action relink_engine_for_next_sweep
    :parameters (?sweep_engine - sweep_engine ?sweep_destination_profile - sweep_destination_profile ?timing_profile - timing_profile)
    :precondition
      (and
        (execution_completed ?sweep_engine)
        (account_destination_profile_link ?sweep_engine ?sweep_destination_profile)
        (account_timing_profile_link ?sweep_engine ?timing_profile)
        (not
          (relinked_for_next_sweep ?sweep_engine)
        )
      )
    :effect
      (and
        (relinked_for_next_sweep ?sweep_engine)
        (destination_profile_available ?sweep_destination_profile)
        (timing_profile_available ?timing_profile)
      )
  )
)

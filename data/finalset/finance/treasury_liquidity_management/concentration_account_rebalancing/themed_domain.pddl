(define (domain finance_concentration_account_rebalancing)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource - object profile - object transfer_element - object account_base - object account - account_base funding_channel - resource liquidity_rule - resource authorization_role - resource approval_credential - resource execution_profile - resource liquidity_buffer - resource collateral_instrument - resource confirmation_receipt - resource allocation_method - profile schedule_window - profile counterparty - profile debit_leg_template - transfer_element credit_leg_template - transfer_element transfer_instruction - transfer_element operational_account_type - account concentration_account_type - account source_account - operational_account_type target_account - operational_account_type concentration_account - concentration_account_type)
  (:predicates
    (account_enrolled ?account - account)
    (account_configured ?account - account)
    (funding_channel_attachment_flag ?account - account)
    (account_settled ?account - account)
    (reconciliation_completed ?account - account)
    (allocation_applied ?account - account)
    (funding_channel_available ?funding_channel - funding_channel)
    (account_funding_channel ?account - account ?funding_channel - funding_channel)
    (liquidity_rule_available ?liquidity_rule - liquidity_rule)
    (account_liquidity_rule ?account - account ?liquidity_rule - liquidity_rule)
    (authorization_role_available ?authorization_role - authorization_role)
    (account_authorization_role ?account - account ?authorization_role - authorization_role)
    (allocation_method_available ?allocation_method - allocation_method)
    (source_account_allocation_method ?source_account - source_account ?allocation_method - allocation_method)
    (target_account_allocation_method ?target_account - target_account ?allocation_method - allocation_method)
    (source_debit_leg_template ?source_account - source_account ?debit_leg_template - debit_leg_template)
    (debit_leg_selected ?debit_leg_template - debit_leg_template)
    (debit_leg_marked_for_allocation ?debit_leg_template - debit_leg_template)
    (source_account_ready ?source_account - source_account)
    (target_credit_leg_template ?target_account - target_account ?credit_leg_template - credit_leg_template)
    (credit_leg_selected ?credit_leg_template - credit_leg_template)
    (credit_leg_marked_for_allocation ?credit_leg_template - credit_leg_template)
    (target_account_ready ?target_account - target_account)
    (transfer_instruction_available ?transfer_instruction - transfer_instruction)
    (transfer_instruction_staged ?transfer_instruction - transfer_instruction)
    (transfer_instruction_debit_leg ?transfer_instruction - transfer_instruction ?debit_leg_template - debit_leg_template)
    (transfer_instruction_credit_leg ?transfer_instruction - transfer_instruction ?credit_leg_template - credit_leg_template)
    (instruction_debit_allocation ?transfer_instruction - transfer_instruction)
    (instruction_credit_allocation ?transfer_instruction - transfer_instruction)
    (instruction_schedule_reserved ?transfer_instruction - transfer_instruction)
    (account_source_binding ?concentration_account - concentration_account ?source_account - source_account)
    (account_target_binding ?concentration_account - concentration_account ?target_account - target_account)
    (account_instruction_binding ?concentration_account - concentration_account ?transfer_instruction - transfer_instruction)
    (schedule_window_available ?schedule_window - schedule_window)
    (account_schedule_window ?concentration_account - concentration_account ?schedule_window - schedule_window)
    (schedule_window_reserved ?schedule_window - schedule_window)
    (schedule_window_allocated_to_instruction ?schedule_window - schedule_window ?transfer_instruction - transfer_instruction)
    (account_execution_prepared ?concentration_account - concentration_account)
    (account_approval_obtained ?concentration_account - concentration_account)
    (account_execution_locked ?concentration_account - concentration_account)
    (approval_credential_attachment_flag ?concentration_account - concentration_account)
    (approval_credential_attachment_confirmed ?concentration_account - concentration_account)
    (account_execution_profile_reserved ?concentration_account - concentration_account)
    (account_transfer_executed ?concentration_account - concentration_account)
    (counterparty_available ?counterparty - counterparty)
    (account_counterparty ?concentration_account - concentration_account ?counterparty - counterparty)
    (account_fallback_initiated ?concentration_account - concentration_account)
    (account_fallback_authorized ?concentration_account - concentration_account)
    (account_fallback_executed ?concentration_account - concentration_account)
    (approval_credential_available ?approval_credential - approval_credential)
    (approval_credential_bound_to_account ?concentration_account - concentration_account ?approval_credential - approval_credential)
    (execution_profile_available ?execution_profile - execution_profile)
    (account_execution_profile ?concentration_account - concentration_account ?execution_profile - execution_profile)
    (collateral_instrument_available ?collateral_instrument - collateral_instrument)
    (account_collateral ?concentration_account - concentration_account ?collateral_instrument - collateral_instrument)
    (confirmation_receipt_available ?confirmation_receipt - confirmation_receipt)
    (account_confirmation ?concentration_account - concentration_account ?confirmation_receipt - confirmation_receipt)
    (liquidity_buffer_available ?liquidity_buffer - liquidity_buffer)
    (account_liquidity_buffer ?account - account ?liquidity_buffer - liquidity_buffer)
    (source_account_prechecked ?source_account - source_account)
    (target_account_prechecked ?target_account - target_account)
    (account_execution_finalized ?concentration_account - concentration_account)
  )
  (:action register_account_for_concentration
    :parameters (?account - account)
    :precondition
      (and
        (not
          (account_enrolled ?account)
        )
        (not
          (account_settled ?account)
        )
      )
    :effect (account_enrolled ?account)
  )
  (:action assign_funding_channel_to_account
    :parameters (?account - account ?funding_channel - funding_channel)
    :precondition
      (and
        (account_enrolled ?account)
        (not
          (funding_channel_attachment_flag ?account)
        )
        (funding_channel_available ?funding_channel)
      )
    :effect
      (and
        (funding_channel_attachment_flag ?account)
        (account_funding_channel ?account ?funding_channel)
        (not
          (funding_channel_available ?funding_channel)
        )
      )
  )
  (:action bind_liquidity_rule_to_account
    :parameters (?account - account ?liquidity_rule - liquidity_rule)
    :precondition
      (and
        (account_enrolled ?account)
        (funding_channel_attachment_flag ?account)
        (liquidity_rule_available ?liquidity_rule)
      )
    :effect
      (and
        (account_liquidity_rule ?account ?liquidity_rule)
        (not
          (liquidity_rule_available ?liquidity_rule)
        )
      )
  )
  (:action confirm_account_configuration
    :parameters (?account - account ?liquidity_rule - liquidity_rule)
    :precondition
      (and
        (account_enrolled ?account)
        (funding_channel_attachment_flag ?account)
        (account_liquidity_rule ?account ?liquidity_rule)
        (not
          (account_configured ?account)
        )
      )
    :effect (account_configured ?account)
  )
  (:action unbind_liquidity_rule_from_account
    :parameters (?account - account ?liquidity_rule - liquidity_rule)
    :precondition
      (and
        (account_liquidity_rule ?account ?liquidity_rule)
      )
    :effect
      (and
        (liquidity_rule_available ?liquidity_rule)
        (not
          (account_liquidity_rule ?account ?liquidity_rule)
        )
      )
  )
  (:action attach_authorization_role_to_account
    :parameters (?account - account ?authorization_role - authorization_role)
    :precondition
      (and
        (account_configured ?account)
        (authorization_role_available ?authorization_role)
      )
    :effect
      (and
        (account_authorization_role ?account ?authorization_role)
        (not
          (authorization_role_available ?authorization_role)
        )
      )
  )
  (:action detach_authorization_role_from_account
    :parameters (?account - account ?authorization_role - authorization_role)
    :precondition
      (and
        (account_authorization_role ?account ?authorization_role)
      )
    :effect
      (and
        (authorization_role_available ?authorization_role)
        (not
          (account_authorization_role ?account ?authorization_role)
        )
      )
  )
  (:action attach_collateral_to_account
    :parameters (?concentration_account - concentration_account ?collateral_instrument - collateral_instrument)
    :precondition
      (and
        (account_configured ?concentration_account)
        (collateral_instrument_available ?collateral_instrument)
      )
    :effect
      (and
        (account_collateral ?concentration_account ?collateral_instrument)
        (not
          (collateral_instrument_available ?collateral_instrument)
        )
      )
  )
  (:action release_collateral_from_account
    :parameters (?concentration_account - concentration_account ?collateral_instrument - collateral_instrument)
    :precondition
      (and
        (account_collateral ?concentration_account ?collateral_instrument)
      )
    :effect
      (and
        (collateral_instrument_available ?collateral_instrument)
        (not
          (account_collateral ?concentration_account ?collateral_instrument)
        )
      )
  )
  (:action attach_confirmation_receipt_to_account
    :parameters (?concentration_account - concentration_account ?confirmation_receipt - confirmation_receipt)
    :precondition
      (and
        (account_configured ?concentration_account)
        (confirmation_receipt_available ?confirmation_receipt)
      )
    :effect
      (and
        (account_confirmation ?concentration_account ?confirmation_receipt)
        (not
          (confirmation_receipt_available ?confirmation_receipt)
        )
      )
  )
  (:action detach_confirmation_receipt_from_account
    :parameters (?concentration_account - concentration_account ?confirmation_receipt - confirmation_receipt)
    :precondition
      (and
        (account_confirmation ?concentration_account ?confirmation_receipt)
      )
    :effect
      (and
        (confirmation_receipt_available ?confirmation_receipt)
        (not
          (account_confirmation ?concentration_account ?confirmation_receipt)
        )
      )
  )
  (:action select_debit_leg_for_source_account
    :parameters (?source_account - source_account ?debit_leg_template - debit_leg_template ?liquidity_rule - liquidity_rule)
    :precondition
      (and
        (account_configured ?source_account)
        (account_liquidity_rule ?source_account ?liquidity_rule)
        (source_debit_leg_template ?source_account ?debit_leg_template)
        (not
          (debit_leg_selected ?debit_leg_template)
        )
        (not
          (debit_leg_marked_for_allocation ?debit_leg_template)
        )
      )
    :effect (debit_leg_selected ?debit_leg_template)
  )
  (:action precheck_and_mark_source_account_ready
    :parameters (?source_account - source_account ?debit_leg_template - debit_leg_template ?authorization_role - authorization_role)
    :precondition
      (and
        (account_configured ?source_account)
        (account_authorization_role ?source_account ?authorization_role)
        (source_debit_leg_template ?source_account ?debit_leg_template)
        (debit_leg_selected ?debit_leg_template)
        (not
          (source_account_prechecked ?source_account)
        )
      )
    :effect
      (and
        (source_account_prechecked ?source_account)
        (source_account_ready ?source_account)
      )
  )
  (:action assign_allocation_method_to_source_account
    :parameters (?source_account - source_account ?debit_leg_template - debit_leg_template ?allocation_method - allocation_method)
    :precondition
      (and
        (account_configured ?source_account)
        (source_debit_leg_template ?source_account ?debit_leg_template)
        (allocation_method_available ?allocation_method)
        (not
          (source_account_prechecked ?source_account)
        )
      )
    :effect
      (and
        (debit_leg_marked_for_allocation ?debit_leg_template)
        (source_account_prechecked ?source_account)
        (source_account_allocation_method ?source_account ?allocation_method)
        (not
          (allocation_method_available ?allocation_method)
        )
      )
  )
  (:action finalize_source_debit_allocation
    :parameters (?source_account - source_account ?debit_leg_template - debit_leg_template ?liquidity_rule - liquidity_rule ?allocation_method - allocation_method)
    :precondition
      (and
        (account_configured ?source_account)
        (account_liquidity_rule ?source_account ?liquidity_rule)
        (source_debit_leg_template ?source_account ?debit_leg_template)
        (debit_leg_marked_for_allocation ?debit_leg_template)
        (source_account_allocation_method ?source_account ?allocation_method)
        (not
          (source_account_ready ?source_account)
        )
      )
    :effect
      (and
        (debit_leg_selected ?debit_leg_template)
        (source_account_ready ?source_account)
        (allocation_method_available ?allocation_method)
        (not
          (source_account_allocation_method ?source_account ?allocation_method)
        )
      )
  )
  (:action select_credit_leg_for_target_account
    :parameters (?target_account - target_account ?credit_leg_template - credit_leg_template ?liquidity_rule - liquidity_rule)
    :precondition
      (and
        (account_configured ?target_account)
        (account_liquidity_rule ?target_account ?liquidity_rule)
        (target_credit_leg_template ?target_account ?credit_leg_template)
        (not
          (credit_leg_selected ?credit_leg_template)
        )
        (not
          (credit_leg_marked_for_allocation ?credit_leg_template)
        )
      )
    :effect (credit_leg_selected ?credit_leg_template)
  )
  (:action precheck_and_mark_target_account_ready
    :parameters (?target_account - target_account ?credit_leg_template - credit_leg_template ?authorization_role - authorization_role)
    :precondition
      (and
        (account_configured ?target_account)
        (account_authorization_role ?target_account ?authorization_role)
        (target_credit_leg_template ?target_account ?credit_leg_template)
        (credit_leg_selected ?credit_leg_template)
        (not
          (target_account_prechecked ?target_account)
        )
      )
    :effect
      (and
        (target_account_prechecked ?target_account)
        (target_account_ready ?target_account)
      )
  )
  (:action assign_allocation_method_to_target_account
    :parameters (?target_account - target_account ?credit_leg_template - credit_leg_template ?allocation_method - allocation_method)
    :precondition
      (and
        (account_configured ?target_account)
        (target_credit_leg_template ?target_account ?credit_leg_template)
        (allocation_method_available ?allocation_method)
        (not
          (target_account_prechecked ?target_account)
        )
      )
    :effect
      (and
        (credit_leg_marked_for_allocation ?credit_leg_template)
        (target_account_prechecked ?target_account)
        (target_account_allocation_method ?target_account ?allocation_method)
        (not
          (allocation_method_available ?allocation_method)
        )
      )
  )
  (:action finalize_target_credit_allocation
    :parameters (?target_account - target_account ?credit_leg_template - credit_leg_template ?liquidity_rule - liquidity_rule ?allocation_method - allocation_method)
    :precondition
      (and
        (account_configured ?target_account)
        (account_liquidity_rule ?target_account ?liquidity_rule)
        (target_credit_leg_template ?target_account ?credit_leg_template)
        (credit_leg_marked_for_allocation ?credit_leg_template)
        (target_account_allocation_method ?target_account ?allocation_method)
        (not
          (target_account_ready ?target_account)
        )
      )
    :effect
      (and
        (credit_leg_selected ?credit_leg_template)
        (target_account_ready ?target_account)
        (allocation_method_available ?allocation_method)
        (not
          (target_account_allocation_method ?target_account ?allocation_method)
        )
      )
  )
  (:action create_staged_transfer_instruction_standard
    :parameters (?source_account - source_account ?target_account - target_account ?debit_leg_template - debit_leg_template ?credit_leg_template - credit_leg_template ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (source_account_prechecked ?source_account)
        (target_account_prechecked ?target_account)
        (source_debit_leg_template ?source_account ?debit_leg_template)
        (target_credit_leg_template ?target_account ?credit_leg_template)
        (debit_leg_selected ?debit_leg_template)
        (credit_leg_selected ?credit_leg_template)
        (source_account_ready ?source_account)
        (target_account_ready ?target_account)
        (transfer_instruction_available ?transfer_instruction)
      )
    :effect
      (and
        (transfer_instruction_staged ?transfer_instruction)
        (transfer_instruction_debit_leg ?transfer_instruction ?debit_leg_template)
        (transfer_instruction_credit_leg ?transfer_instruction ?credit_leg_template)
        (not
          (transfer_instruction_available ?transfer_instruction)
        )
      )
  )
  (:action create_staged_transfer_instruction_with_debit_mark
    :parameters (?source_account - source_account ?target_account - target_account ?debit_leg_template - debit_leg_template ?credit_leg_template - credit_leg_template ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (source_account_prechecked ?source_account)
        (target_account_prechecked ?target_account)
        (source_debit_leg_template ?source_account ?debit_leg_template)
        (target_credit_leg_template ?target_account ?credit_leg_template)
        (debit_leg_marked_for_allocation ?debit_leg_template)
        (credit_leg_selected ?credit_leg_template)
        (not
          (source_account_ready ?source_account)
        )
        (target_account_ready ?target_account)
        (transfer_instruction_available ?transfer_instruction)
      )
    :effect
      (and
        (transfer_instruction_staged ?transfer_instruction)
        (transfer_instruction_debit_leg ?transfer_instruction ?debit_leg_template)
        (transfer_instruction_credit_leg ?transfer_instruction ?credit_leg_template)
        (instruction_debit_allocation ?transfer_instruction)
        (not
          (transfer_instruction_available ?transfer_instruction)
        )
      )
  )
  (:action create_staged_transfer_instruction_with_credit_mark
    :parameters (?source_account - source_account ?target_account - target_account ?debit_leg_template - debit_leg_template ?credit_leg_template - credit_leg_template ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (source_account_prechecked ?source_account)
        (target_account_prechecked ?target_account)
        (source_debit_leg_template ?source_account ?debit_leg_template)
        (target_credit_leg_template ?target_account ?credit_leg_template)
        (debit_leg_selected ?debit_leg_template)
        (credit_leg_marked_for_allocation ?credit_leg_template)
        (source_account_ready ?source_account)
        (not
          (target_account_ready ?target_account)
        )
        (transfer_instruction_available ?transfer_instruction)
      )
    :effect
      (and
        (transfer_instruction_staged ?transfer_instruction)
        (transfer_instruction_debit_leg ?transfer_instruction ?debit_leg_template)
        (transfer_instruction_credit_leg ?transfer_instruction ?credit_leg_template)
        (instruction_credit_allocation ?transfer_instruction)
        (not
          (transfer_instruction_available ?transfer_instruction)
        )
      )
  )
  (:action create_staged_transfer_instruction_with_both_marks
    :parameters (?source_account - source_account ?target_account - target_account ?debit_leg_template - debit_leg_template ?credit_leg_template - credit_leg_template ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (source_account_prechecked ?source_account)
        (target_account_prechecked ?target_account)
        (source_debit_leg_template ?source_account ?debit_leg_template)
        (target_credit_leg_template ?target_account ?credit_leg_template)
        (debit_leg_marked_for_allocation ?debit_leg_template)
        (credit_leg_marked_for_allocation ?credit_leg_template)
        (not
          (source_account_ready ?source_account)
        )
        (not
          (target_account_ready ?target_account)
        )
        (transfer_instruction_available ?transfer_instruction)
      )
    :effect
      (and
        (transfer_instruction_staged ?transfer_instruction)
        (transfer_instruction_debit_leg ?transfer_instruction ?debit_leg_template)
        (transfer_instruction_credit_leg ?transfer_instruction ?credit_leg_template)
        (instruction_debit_allocation ?transfer_instruction)
        (instruction_credit_allocation ?transfer_instruction)
        (not
          (transfer_instruction_available ?transfer_instruction)
        )
      )
  )
  (:action reserve_schedule_slot_for_instruction
    :parameters (?transfer_instruction - transfer_instruction ?source_account - source_account ?liquidity_rule - liquidity_rule)
    :precondition
      (and
        (transfer_instruction_staged ?transfer_instruction)
        (source_account_prechecked ?source_account)
        (account_liquidity_rule ?source_account ?liquidity_rule)
        (not
          (instruction_schedule_reserved ?transfer_instruction)
        )
      )
    :effect (instruction_schedule_reserved ?transfer_instruction)
  )
  (:action reserve_schedule_window_for_instruction
    :parameters (?concentration_account - concentration_account ?schedule_window - schedule_window ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (account_configured ?concentration_account)
        (account_instruction_binding ?concentration_account ?transfer_instruction)
        (account_schedule_window ?concentration_account ?schedule_window)
        (schedule_window_available ?schedule_window)
        (transfer_instruction_staged ?transfer_instruction)
        (instruction_schedule_reserved ?transfer_instruction)
        (not
          (schedule_window_reserved ?schedule_window)
        )
      )
    :effect
      (and
        (schedule_window_reserved ?schedule_window)
        (schedule_window_allocated_to_instruction ?schedule_window ?transfer_instruction)
        (not
          (schedule_window_available ?schedule_window)
        )
      )
  )
  (:action prepare_execution_for_instruction
    :parameters (?concentration_account - concentration_account ?schedule_window - schedule_window ?transfer_instruction - transfer_instruction ?liquidity_rule - liquidity_rule)
    :precondition
      (and
        (account_configured ?concentration_account)
        (account_schedule_window ?concentration_account ?schedule_window)
        (schedule_window_reserved ?schedule_window)
        (schedule_window_allocated_to_instruction ?schedule_window ?transfer_instruction)
        (account_liquidity_rule ?concentration_account ?liquidity_rule)
        (not
          (instruction_debit_allocation ?transfer_instruction)
        )
        (not
          (account_execution_prepared ?concentration_account)
        )
      )
    :effect (account_execution_prepared ?concentration_account)
  )
  (:action attach_approval_credential_to_account
    :parameters (?concentration_account - concentration_account ?approval_credential - approval_credential)
    :precondition
      (and
        (account_configured ?concentration_account)
        (approval_credential_available ?approval_credential)
        (not
          (approval_credential_attachment_flag ?concentration_account)
        )
      )
    :effect
      (and
        (approval_credential_attachment_flag ?concentration_account)
        (approval_credential_bound_to_account ?concentration_account ?approval_credential)
        (not
          (approval_credential_available ?approval_credential)
        )
      )
  )
  (:action apply_approval_and_prepare_execution
    :parameters (?concentration_account - concentration_account ?schedule_window - schedule_window ?transfer_instruction - transfer_instruction ?liquidity_rule - liquidity_rule ?approval_credential - approval_credential)
    :precondition
      (and
        (account_configured ?concentration_account)
        (account_schedule_window ?concentration_account ?schedule_window)
        (schedule_window_reserved ?schedule_window)
        (schedule_window_allocated_to_instruction ?schedule_window ?transfer_instruction)
        (account_liquidity_rule ?concentration_account ?liquidity_rule)
        (instruction_debit_allocation ?transfer_instruction)
        (approval_credential_attachment_flag ?concentration_account)
        (approval_credential_bound_to_account ?concentration_account ?approval_credential)
        (not
          (account_execution_prepared ?concentration_account)
        )
      )
    :effect
      (and
        (account_execution_prepared ?concentration_account)
        (approval_credential_attachment_confirmed ?concentration_account)
      )
  )
  (:action authorize_execution_with_collateral_primary
    :parameters (?concentration_account - concentration_account ?collateral_instrument - collateral_instrument ?authorization_role - authorization_role ?schedule_window - schedule_window ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (account_execution_prepared ?concentration_account)
        (account_collateral ?concentration_account ?collateral_instrument)
        (account_authorization_role ?concentration_account ?authorization_role)
        (account_schedule_window ?concentration_account ?schedule_window)
        (schedule_window_allocated_to_instruction ?schedule_window ?transfer_instruction)
        (not
          (instruction_credit_allocation ?transfer_instruction)
        )
        (not
          (account_approval_obtained ?concentration_account)
        )
      )
    :effect (account_approval_obtained ?concentration_account)
  )
  (:action authorize_execution_with_collateral_secondary
    :parameters (?concentration_account - concentration_account ?collateral_instrument - collateral_instrument ?authorization_role - authorization_role ?schedule_window - schedule_window ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (account_execution_prepared ?concentration_account)
        (account_collateral ?concentration_account ?collateral_instrument)
        (account_authorization_role ?concentration_account ?authorization_role)
        (account_schedule_window ?concentration_account ?schedule_window)
        (schedule_window_allocated_to_instruction ?schedule_window ?transfer_instruction)
        (instruction_credit_allocation ?transfer_instruction)
        (not
          (account_approval_obtained ?concentration_account)
        )
      )
    :effect (account_approval_obtained ?concentration_account)
  )
  (:action lock_execution_on_confirmation
    :parameters (?concentration_account - concentration_account ?confirmation_receipt - confirmation_receipt ?schedule_window - schedule_window ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (account_approval_obtained ?concentration_account)
        (account_confirmation ?concentration_account ?confirmation_receipt)
        (account_schedule_window ?concentration_account ?schedule_window)
        (schedule_window_allocated_to_instruction ?schedule_window ?transfer_instruction)
        (not
          (instruction_debit_allocation ?transfer_instruction)
        )
        (not
          (instruction_credit_allocation ?transfer_instruction)
        )
        (not
          (account_execution_locked ?concentration_account)
        )
      )
    :effect (account_execution_locked ?concentration_account)
  )
  (:action lock_and_reserve_execution_profile_variant1
    :parameters (?concentration_account - concentration_account ?confirmation_receipt - confirmation_receipt ?schedule_window - schedule_window ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (account_approval_obtained ?concentration_account)
        (account_confirmation ?concentration_account ?confirmation_receipt)
        (account_schedule_window ?concentration_account ?schedule_window)
        (schedule_window_allocated_to_instruction ?schedule_window ?transfer_instruction)
        (instruction_debit_allocation ?transfer_instruction)
        (not
          (instruction_credit_allocation ?transfer_instruction)
        )
        (not
          (account_execution_locked ?concentration_account)
        )
      )
    :effect
      (and
        (account_execution_locked ?concentration_account)
        (account_execution_profile_reserved ?concentration_account)
      )
  )
  (:action lock_and_reserve_execution_profile_variant2
    :parameters (?concentration_account - concentration_account ?confirmation_receipt - confirmation_receipt ?schedule_window - schedule_window ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (account_approval_obtained ?concentration_account)
        (account_confirmation ?concentration_account ?confirmation_receipt)
        (account_schedule_window ?concentration_account ?schedule_window)
        (schedule_window_allocated_to_instruction ?schedule_window ?transfer_instruction)
        (not
          (instruction_debit_allocation ?transfer_instruction)
        )
        (instruction_credit_allocation ?transfer_instruction)
        (not
          (account_execution_locked ?concentration_account)
        )
      )
    :effect
      (and
        (account_execution_locked ?concentration_account)
        (account_execution_profile_reserved ?concentration_account)
      )
  )
  (:action lock_and_reserve_execution_profile_variant3
    :parameters (?concentration_account - concentration_account ?confirmation_receipt - confirmation_receipt ?schedule_window - schedule_window ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (account_approval_obtained ?concentration_account)
        (account_confirmation ?concentration_account ?confirmation_receipt)
        (account_schedule_window ?concentration_account ?schedule_window)
        (schedule_window_allocated_to_instruction ?schedule_window ?transfer_instruction)
        (instruction_debit_allocation ?transfer_instruction)
        (instruction_credit_allocation ?transfer_instruction)
        (not
          (account_execution_locked ?concentration_account)
        )
      )
    :effect
      (and
        (account_execution_locked ?concentration_account)
        (account_execution_profile_reserved ?concentration_account)
      )
  )
  (:action finalize_execution_and_reconcile
    :parameters (?concentration_account - concentration_account)
    :precondition
      (and
        (account_execution_locked ?concentration_account)
        (not
          (account_execution_profile_reserved ?concentration_account)
        )
        (not
          (account_execution_finalized ?concentration_account)
        )
      )
    :effect
      (and
        (account_execution_finalized ?concentration_account)
        (reconciliation_completed ?concentration_account)
      )
  )
  (:action attach_execution_profile_to_account
    :parameters (?concentration_account - concentration_account ?execution_profile - execution_profile)
    :precondition
      (and
        (account_execution_locked ?concentration_account)
        (account_execution_profile_reserved ?concentration_account)
        (execution_profile_available ?execution_profile)
      )
    :effect
      (and
        (account_execution_profile ?concentration_account ?execution_profile)
        (not
          (execution_profile_available ?execution_profile)
        )
      )
  )
  (:action execute_transfers_for_account
    :parameters (?concentration_account - concentration_account ?source_account - source_account ?target_account - target_account ?liquidity_rule - liquidity_rule ?execution_profile - execution_profile)
    :precondition
      (and
        (account_execution_locked ?concentration_account)
        (account_execution_profile_reserved ?concentration_account)
        (account_execution_profile ?concentration_account ?execution_profile)
        (account_source_binding ?concentration_account ?source_account)
        (account_target_binding ?concentration_account ?target_account)
        (source_account_ready ?source_account)
        (target_account_ready ?target_account)
        (account_liquidity_rule ?concentration_account ?liquidity_rule)
        (not
          (account_transfer_executed ?concentration_account)
        )
      )
    :effect (account_transfer_executed ?concentration_account)
  )
  (:action finalize_execution_and_reconcile_posting
    :parameters (?concentration_account - concentration_account)
    :precondition
      (and
        (account_execution_locked ?concentration_account)
        (account_transfer_executed ?concentration_account)
        (not
          (account_execution_finalized ?concentration_account)
        )
      )
    :effect
      (and
        (account_execution_finalized ?concentration_account)
        (reconciliation_completed ?concentration_account)
      )
  )
  (:action initiate_counterparty_fallback
    :parameters (?concentration_account - concentration_account ?counterparty - counterparty ?liquidity_rule - liquidity_rule)
    :precondition
      (and
        (account_configured ?concentration_account)
        (account_liquidity_rule ?concentration_account ?liquidity_rule)
        (counterparty_available ?counterparty)
        (account_counterparty ?concentration_account ?counterparty)
        (not
          (account_fallback_initiated ?concentration_account)
        )
      )
    :effect
      (and
        (account_fallback_initiated ?concentration_account)
        (not
          (counterparty_available ?counterparty)
        )
      )
  )
  (:action authorize_fallback_execution
    :parameters (?concentration_account - concentration_account ?authorization_role - authorization_role)
    :precondition
      (and
        (account_fallback_initiated ?concentration_account)
        (account_authorization_role ?concentration_account ?authorization_role)
        (not
          (account_fallback_authorized ?concentration_account)
        )
      )
    :effect (account_fallback_authorized ?concentration_account)
  )
  (:action execute_fallback_and_capture_confirmation
    :parameters (?concentration_account - concentration_account ?confirmation_receipt - confirmation_receipt)
    :precondition
      (and
        (account_fallback_authorized ?concentration_account)
        (account_confirmation ?concentration_account ?confirmation_receipt)
        (not
          (account_fallback_executed ?concentration_account)
        )
      )
    :effect (account_fallback_executed ?concentration_account)
  )
  (:action finalize_fallback_and_reconcile
    :parameters (?concentration_account - concentration_account)
    :precondition
      (and
        (account_fallback_executed ?concentration_account)
        (not
          (account_execution_finalized ?concentration_account)
        )
      )
    :effect
      (and
        (account_execution_finalized ?concentration_account)
        (reconciliation_completed ?concentration_account)
      )
  )
  (:action confirm_settlement_and_reconcile_source_account
    :parameters (?source_account - source_account ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (source_account_prechecked ?source_account)
        (source_account_ready ?source_account)
        (transfer_instruction_staged ?transfer_instruction)
        (instruction_schedule_reserved ?transfer_instruction)
        (not
          (reconciliation_completed ?source_account)
        )
      )
    :effect (reconciliation_completed ?source_account)
  )
  (:action confirm_settlement_and_reconcile_target_account
    :parameters (?target_account - target_account ?transfer_instruction - transfer_instruction)
    :precondition
      (and
        (target_account_prechecked ?target_account)
        (target_account_ready ?target_account)
        (transfer_instruction_staged ?transfer_instruction)
        (instruction_schedule_reserved ?transfer_instruction)
        (not
          (reconciliation_completed ?target_account)
        )
      )
    :effect (reconciliation_completed ?target_account)
  )
  (:action apply_allocation_and_reserve_buffer
    :parameters (?account - account ?liquidity_buffer - liquidity_buffer ?liquidity_rule - liquidity_rule)
    :precondition
      (and
        (reconciliation_completed ?account)
        (account_liquidity_rule ?account ?liquidity_rule)
        (liquidity_buffer_available ?liquidity_buffer)
        (not
          (allocation_applied ?account)
        )
      )
    :effect
      (and
        (allocation_applied ?account)
        (account_liquidity_buffer ?account ?liquidity_buffer)
        (not
          (liquidity_buffer_available ?liquidity_buffer)
        )
      )
  )
  (:action post_allocation_and_release_channel_from_source
    :parameters (?source_account - source_account ?funding_channel - funding_channel ?liquidity_buffer - liquidity_buffer)
    :precondition
      (and
        (allocation_applied ?source_account)
        (account_funding_channel ?source_account ?funding_channel)
        (account_liquidity_buffer ?source_account ?liquidity_buffer)
        (not
          (account_settled ?source_account)
        )
      )
    :effect
      (and
        (account_settled ?source_account)
        (funding_channel_available ?funding_channel)
        (liquidity_buffer_available ?liquidity_buffer)
      )
  )
  (:action post_allocation_and_release_channel_from_target
    :parameters (?target_account - target_account ?funding_channel - funding_channel ?liquidity_buffer - liquidity_buffer)
    :precondition
      (and
        (allocation_applied ?target_account)
        (account_funding_channel ?target_account ?funding_channel)
        (account_liquidity_buffer ?target_account ?liquidity_buffer)
        (not
          (account_settled ?target_account)
        )
      )
    :effect
      (and
        (account_settled ?target_account)
        (funding_channel_available ?funding_channel)
        (liquidity_buffer_available ?liquidity_buffer)
      )
  )
  (:action post_allocation_and_release_channel_from_account
    :parameters (?concentration_account - concentration_account ?funding_channel - funding_channel ?liquidity_buffer - liquidity_buffer)
    :precondition
      (and
        (allocation_applied ?concentration_account)
        (account_funding_channel ?concentration_account ?funding_channel)
        (account_liquidity_buffer ?concentration_account ?liquidity_buffer)
        (not
          (account_settled ?concentration_account)
        )
      )
    :effect
      (and
        (account_settled ?concentration_account)
        (funding_channel_available ?funding_channel)
        (liquidity_buffer_available ?liquidity_buffer)
      )
  )
)

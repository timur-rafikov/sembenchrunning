(define (domain internal_transfer_booking_and_settlement)
  (:requirements :strips :typing :negative-preconditions)
  (:types instruction_subtype - object resource_subtype - object channel_subtype - object identifier - object payment_instruction - identifier execution_channel_token - instruction_subtype validation_service - instruction_subtype authorizer - instruction_subtype regulatory_check - instruction_subtype fee_profile - instruction_subtype settlement_schedule_slot - instruction_subtype posting_profile - instruction_subtype third_party_confirmation - instruction_subtype manual_remediation_task - resource_subtype settlement_account - resource_subtype correspondent_consent - resource_subtype debit_settlement_channel - channel_subtype credit_settlement_channel - channel_subtype settlement_instruction_message - channel_subtype booking_group - payment_instruction booking_variant - payment_instruction debit_leg - booking_group credit_leg - booking_group settlement_case - booking_variant)
  (:predicates
    (entity_registered ?payment_instruction - payment_instruction)
    (entity_validated ?payment_instruction - payment_instruction)
    (execution_token_assigned ?payment_instruction - payment_instruction)
    (entity_activated_for_settlement ?payment_instruction - payment_instruction)
    (entity_posted_to_ledger ?payment_instruction - payment_instruction)
    (entity_settlement_initiated ?payment_instruction - payment_instruction)
    (execution_token_available ?execution_token - execution_channel_token)
    (entity_has_execution_token ?payment_instruction - payment_instruction ?execution_token - execution_channel_token)
    (validation_service_available ?validation_service - validation_service)
    (entity_assigned_validation_service ?payment_instruction - payment_instruction ?validation_service - validation_service)
    (authorizer_available ?authorizer - authorizer)
    (entity_assigned_authorizer ?payment_instruction - payment_instruction ?authorizer - authorizer)
    (remediation_task_available ?remediation_task - manual_remediation_task)
    (debit_leg_assigned_remediation_task ?debit_leg - debit_leg ?remediation_task - manual_remediation_task)
    (credit_leg_assigned_remediation_task ?credit_leg - credit_leg ?remediation_task - manual_remediation_task)
    (debit_leg_assigned_channel ?debit_leg - debit_leg ?debit_channel - debit_settlement_channel)
    (debit_channel_ready ?debit_channel - debit_settlement_channel)
    (debit_channel_reserved ?debit_channel - debit_settlement_channel)
    (debit_leg_funding_reserved ?debit_leg - debit_leg)
    (credit_leg_assigned_channel ?credit_leg - credit_leg ?credit_channel - credit_settlement_channel)
    (credit_channel_ready ?credit_channel - credit_settlement_channel)
    (credit_channel_reserved ?credit_channel - credit_settlement_channel)
    (credit_leg_funding_reserved ?credit_leg - credit_leg)
    (settlement_message_available ?settlement_message - settlement_instruction_message)
    (settlement_message_assembled ?settlement_message - settlement_instruction_message)
    (message_mapped_to_debit_channel ?settlement_message - settlement_instruction_message ?debit_channel - debit_settlement_channel)
    (message_mapped_to_credit_channel ?settlement_message - settlement_instruction_message ?credit_channel - credit_settlement_channel)
    (message_debit_reserved_flag ?settlement_message - settlement_instruction_message)
    (message_credit_reserved_flag ?settlement_message - settlement_instruction_message)
    (message_ready_for_dispatch ?settlement_message - settlement_instruction_message)
    (case_has_debit_leg ?settlement_case - settlement_case ?debit_leg - debit_leg)
    (case_has_credit_leg ?settlement_case - settlement_case ?credit_leg - credit_leg)
    (case_linked_to_message ?settlement_case - settlement_case ?settlement_message - settlement_instruction_message)
    (settlement_account_available ?settlement_account - settlement_account)
    (case_assigned_account ?settlement_case - settlement_case ?settlement_account - settlement_account)
    (settlement_account_reserved ?settlement_account - settlement_account)
    (settlement_account_reserved_for_message ?settlement_account - settlement_account ?settlement_message - settlement_instruction_message)
    (case_account_reservation_confirmed ?settlement_case - settlement_case)
    (case_posting_profile_bound ?settlement_case - settlement_case)
    (case_ready_for_final_checks ?settlement_case - settlement_case)
    (case_has_regulatory_check ?settlement_case - settlement_case)
    (case_regulatory_check_passed ?settlement_case - settlement_case)
    (case_fee_applicable ?settlement_case - settlement_case)
    (case_posting_authorized ?settlement_case - settlement_case)
    (correspondent_consent_available ?correspondent_consent - correspondent_consent)
    (case_assigned_correspondent_consent ?settlement_case - settlement_case ?correspondent_consent - correspondent_consent)
    (case_consent_attested ?settlement_case - settlement_case)
    (case_authorizer_reserved ?settlement_case - settlement_case)
    (case_third_party_confirmed ?settlement_case - settlement_case)
    (regulatory_check_available ?regulatory_check - regulatory_check)
    (case_assigned_regulatory_check ?settlement_case - settlement_case ?regulatory_check - regulatory_check)
    (fee_profile_available ?fee_profile - fee_profile)
    (case_assigned_fee_profile ?settlement_case - settlement_case ?fee_profile - fee_profile)
    (posting_profile_available ?posting_profile - posting_profile)
    (case_assigned_posting_profile ?settlement_case - settlement_case ?posting_profile - posting_profile)
    (third_party_confirmation_available ?third_party_confirmation - third_party_confirmation)
    (case_assigned_third_party_confirmation ?settlement_case - settlement_case ?third_party_confirmation - third_party_confirmation)
    (settlement_schedule_slot_available ?schedule_slot - settlement_schedule_slot)
    (entity_scheduled ?payment_instruction - payment_instruction ?schedule_slot - settlement_schedule_slot)
    (debit_leg_ready ?debit_leg - debit_leg)
    (credit_leg_ready ?credit_leg - credit_leg)
    (case_finalized ?settlement_case - settlement_case)
  )
  (:action register_payment_instruction
    :parameters (?payment_instruction - payment_instruction)
    :precondition
      (and
        (not
          (entity_registered ?payment_instruction)
        )
        (not
          (entity_activated_for_settlement ?payment_instruction)
        )
      )
    :effect (entity_registered ?payment_instruction)
  )
  (:action assign_execution_token
    :parameters (?payment_instruction - payment_instruction ?execution_token - execution_channel_token)
    :precondition
      (and
        (entity_registered ?payment_instruction)
        (not
          (execution_token_assigned ?payment_instruction)
        )
        (execution_token_available ?execution_token)
      )
    :effect
      (and
        (execution_token_assigned ?payment_instruction)
        (entity_has_execution_token ?payment_instruction ?execution_token)
        (not
          (execution_token_available ?execution_token)
        )
      )
  )
  (:action assign_validation_service
    :parameters (?payment_instruction - payment_instruction ?validation_service - validation_service)
    :precondition
      (and
        (entity_registered ?payment_instruction)
        (execution_token_assigned ?payment_instruction)
        (validation_service_available ?validation_service)
      )
    :effect
      (and
        (entity_assigned_validation_service ?payment_instruction ?validation_service)
        (not
          (validation_service_available ?validation_service)
        )
      )
  )
  (:action complete_validation_for_instruction
    :parameters (?payment_instruction - payment_instruction ?validation_service - validation_service)
    :precondition
      (and
        (entity_registered ?payment_instruction)
        (execution_token_assigned ?payment_instruction)
        (entity_assigned_validation_service ?payment_instruction ?validation_service)
        (not
          (entity_validated ?payment_instruction)
        )
      )
    :effect (entity_validated ?payment_instruction)
  )
  (:action release_validation_service
    :parameters (?payment_instruction - payment_instruction ?validation_service - validation_service)
    :precondition
      (and
        (entity_assigned_validation_service ?payment_instruction ?validation_service)
      )
    :effect
      (and
        (validation_service_available ?validation_service)
        (not
          (entity_assigned_validation_service ?payment_instruction ?validation_service)
        )
      )
  )
  (:action assign_authorizer
    :parameters (?payment_instruction - payment_instruction ?authorizer - authorizer)
    :precondition
      (and
        (entity_validated ?payment_instruction)
        (authorizer_available ?authorizer)
      )
    :effect
      (and
        (entity_assigned_authorizer ?payment_instruction ?authorizer)
        (not
          (authorizer_available ?authorizer)
        )
      )
  )
  (:action release_authorizer
    :parameters (?payment_instruction - payment_instruction ?authorizer - authorizer)
    :precondition
      (and
        (entity_assigned_authorizer ?payment_instruction ?authorizer)
      )
    :effect
      (and
        (authorizer_available ?authorizer)
        (not
          (entity_assigned_authorizer ?payment_instruction ?authorizer)
        )
      )
  )
  (:action attach_posting_profile
    :parameters (?settlement_case - settlement_case ?posting_profile - posting_profile)
    :precondition
      (and
        (entity_validated ?settlement_case)
        (posting_profile_available ?posting_profile)
      )
    :effect
      (and
        (case_assigned_posting_profile ?settlement_case ?posting_profile)
        (not
          (posting_profile_available ?posting_profile)
        )
      )
  )
  (:action release_posting_profile
    :parameters (?settlement_case - settlement_case ?posting_profile - posting_profile)
    :precondition
      (and
        (case_assigned_posting_profile ?settlement_case ?posting_profile)
      )
    :effect
      (and
        (posting_profile_available ?posting_profile)
        (not
          (case_assigned_posting_profile ?settlement_case ?posting_profile)
        )
      )
  )
  (:action attach_third_party_confirmation
    :parameters (?settlement_case - settlement_case ?third_party_confirmation - third_party_confirmation)
    :precondition
      (and
        (entity_validated ?settlement_case)
        (third_party_confirmation_available ?third_party_confirmation)
      )
    :effect
      (and
        (case_assigned_third_party_confirmation ?settlement_case ?third_party_confirmation)
        (not
          (third_party_confirmation_available ?third_party_confirmation)
        )
      )
  )
  (:action release_third_party_confirmation
    :parameters (?settlement_case - settlement_case ?third_party_confirmation - third_party_confirmation)
    :precondition
      (and
        (case_assigned_third_party_confirmation ?settlement_case ?third_party_confirmation)
      )
    :effect
      (and
        (third_party_confirmation_available ?third_party_confirmation)
        (not
          (case_assigned_third_party_confirmation ?settlement_case ?third_party_confirmation)
        )
      )
  )
  (:action mark_debit_channel_ready
    :parameters (?debit_leg - debit_leg ?debit_channel - debit_settlement_channel ?validation_service - validation_service)
    :precondition
      (and
        (entity_validated ?debit_leg)
        (entity_assigned_validation_service ?debit_leg ?validation_service)
        (debit_leg_assigned_channel ?debit_leg ?debit_channel)
        (not
          (debit_channel_ready ?debit_channel)
        )
        (not
          (debit_channel_reserved ?debit_channel)
        )
      )
    :effect (debit_channel_ready ?debit_channel)
  )
  (:action confirm_debit_funding_and_mark_ready
    :parameters (?debit_leg - debit_leg ?debit_channel - debit_settlement_channel ?authorizer - authorizer)
    :precondition
      (and
        (entity_validated ?debit_leg)
        (entity_assigned_authorizer ?debit_leg ?authorizer)
        (debit_leg_assigned_channel ?debit_leg ?debit_channel)
        (debit_channel_ready ?debit_channel)
        (not
          (debit_leg_ready ?debit_leg)
        )
      )
    :effect
      (and
        (debit_leg_ready ?debit_leg)
        (debit_leg_funding_reserved ?debit_leg)
      )
  )
  (:action assign_remediation_task_to_debit_leg
    :parameters (?debit_leg - debit_leg ?debit_channel - debit_settlement_channel ?remediation_task - manual_remediation_task)
    :precondition
      (and
        (entity_validated ?debit_leg)
        (debit_leg_assigned_channel ?debit_leg ?debit_channel)
        (remediation_task_available ?remediation_task)
        (not
          (debit_leg_ready ?debit_leg)
        )
      )
    :effect
      (and
        (debit_channel_reserved ?debit_channel)
        (debit_leg_ready ?debit_leg)
        (debit_leg_assigned_remediation_task ?debit_leg ?remediation_task)
        (not
          (remediation_task_available ?remediation_task)
        )
      )
  )
  (:action finalize_debit_channel_with_remediation
    :parameters (?debit_leg - debit_leg ?debit_channel - debit_settlement_channel ?validation_service - validation_service ?remediation_task - manual_remediation_task)
    :precondition
      (and
        (entity_validated ?debit_leg)
        (entity_assigned_validation_service ?debit_leg ?validation_service)
        (debit_leg_assigned_channel ?debit_leg ?debit_channel)
        (debit_channel_reserved ?debit_channel)
        (debit_leg_assigned_remediation_task ?debit_leg ?remediation_task)
        (not
          (debit_leg_funding_reserved ?debit_leg)
        )
      )
    :effect
      (and
        (debit_channel_ready ?debit_channel)
        (debit_leg_funding_reserved ?debit_leg)
        (remediation_task_available ?remediation_task)
        (not
          (debit_leg_assigned_remediation_task ?debit_leg ?remediation_task)
        )
      )
  )
  (:action mark_credit_channel_ready
    :parameters (?credit_leg - credit_leg ?credit_channel - credit_settlement_channel ?validation_service - validation_service)
    :precondition
      (and
        (entity_validated ?credit_leg)
        (entity_assigned_validation_service ?credit_leg ?validation_service)
        (credit_leg_assigned_channel ?credit_leg ?credit_channel)
        (not
          (credit_channel_ready ?credit_channel)
        )
        (not
          (credit_channel_reserved ?credit_channel)
        )
      )
    :effect (credit_channel_ready ?credit_channel)
  )
  (:action confirm_credit_funding_and_mark_ready
    :parameters (?credit_leg - credit_leg ?credit_channel - credit_settlement_channel ?authorizer - authorizer)
    :precondition
      (and
        (entity_validated ?credit_leg)
        (entity_assigned_authorizer ?credit_leg ?authorizer)
        (credit_leg_assigned_channel ?credit_leg ?credit_channel)
        (credit_channel_ready ?credit_channel)
        (not
          (credit_leg_ready ?credit_leg)
        )
      )
    :effect
      (and
        (credit_leg_ready ?credit_leg)
        (credit_leg_funding_reserved ?credit_leg)
      )
  )
  (:action assign_remediation_task_to_credit_leg
    :parameters (?credit_leg - credit_leg ?credit_channel - credit_settlement_channel ?remediation_task - manual_remediation_task)
    :precondition
      (and
        (entity_validated ?credit_leg)
        (credit_leg_assigned_channel ?credit_leg ?credit_channel)
        (remediation_task_available ?remediation_task)
        (not
          (credit_leg_ready ?credit_leg)
        )
      )
    :effect
      (and
        (credit_channel_reserved ?credit_channel)
        (credit_leg_ready ?credit_leg)
        (credit_leg_assigned_remediation_task ?credit_leg ?remediation_task)
        (not
          (remediation_task_available ?remediation_task)
        )
      )
  )
  (:action finalize_credit_channel_with_remediation
    :parameters (?credit_leg - credit_leg ?credit_channel - credit_settlement_channel ?validation_service - validation_service ?remediation_task - manual_remediation_task)
    :precondition
      (and
        (entity_validated ?credit_leg)
        (entity_assigned_validation_service ?credit_leg ?validation_service)
        (credit_leg_assigned_channel ?credit_leg ?credit_channel)
        (credit_channel_reserved ?credit_channel)
        (credit_leg_assigned_remediation_task ?credit_leg ?remediation_task)
        (not
          (credit_leg_funding_reserved ?credit_leg)
        )
      )
    :effect
      (and
        (credit_channel_ready ?credit_channel)
        (credit_leg_funding_reserved ?credit_leg)
        (remediation_task_available ?remediation_task)
        (not
          (credit_leg_assigned_remediation_task ?credit_leg ?remediation_task)
        )
      )
  )
  (:action assemble_settlement_message_standard
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_channel - debit_settlement_channel ?credit_channel - credit_settlement_channel ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (debit_leg_ready ?debit_leg)
        (credit_leg_ready ?credit_leg)
        (debit_leg_assigned_channel ?debit_leg ?debit_channel)
        (credit_leg_assigned_channel ?credit_leg ?credit_channel)
        (debit_channel_ready ?debit_channel)
        (credit_channel_ready ?credit_channel)
        (debit_leg_funding_reserved ?debit_leg)
        (credit_leg_funding_reserved ?credit_leg)
        (settlement_message_available ?settlement_message)
      )
    :effect
      (and
        (settlement_message_assembled ?settlement_message)
        (message_mapped_to_debit_channel ?settlement_message ?debit_channel)
        (message_mapped_to_credit_channel ?settlement_message ?credit_channel)
        (not
          (settlement_message_available ?settlement_message)
        )
      )
  )
  (:action assemble_settlement_message_debit_reserved
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_channel - debit_settlement_channel ?credit_channel - credit_settlement_channel ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (debit_leg_ready ?debit_leg)
        (credit_leg_ready ?credit_leg)
        (debit_leg_assigned_channel ?debit_leg ?debit_channel)
        (credit_leg_assigned_channel ?credit_leg ?credit_channel)
        (debit_channel_reserved ?debit_channel)
        (credit_channel_ready ?credit_channel)
        (not
          (debit_leg_funding_reserved ?debit_leg)
        )
        (credit_leg_funding_reserved ?credit_leg)
        (settlement_message_available ?settlement_message)
      )
    :effect
      (and
        (settlement_message_assembled ?settlement_message)
        (message_mapped_to_debit_channel ?settlement_message ?debit_channel)
        (message_mapped_to_credit_channel ?settlement_message ?credit_channel)
        (message_debit_reserved_flag ?settlement_message)
        (not
          (settlement_message_available ?settlement_message)
        )
      )
  )
  (:action assemble_settlement_message_credit_reserved
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_channel - debit_settlement_channel ?credit_channel - credit_settlement_channel ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (debit_leg_ready ?debit_leg)
        (credit_leg_ready ?credit_leg)
        (debit_leg_assigned_channel ?debit_leg ?debit_channel)
        (credit_leg_assigned_channel ?credit_leg ?credit_channel)
        (debit_channel_ready ?debit_channel)
        (credit_channel_reserved ?credit_channel)
        (debit_leg_funding_reserved ?debit_leg)
        (not
          (credit_leg_funding_reserved ?credit_leg)
        )
        (settlement_message_available ?settlement_message)
      )
    :effect
      (and
        (settlement_message_assembled ?settlement_message)
        (message_mapped_to_debit_channel ?settlement_message ?debit_channel)
        (message_mapped_to_credit_channel ?settlement_message ?credit_channel)
        (message_credit_reserved_flag ?settlement_message)
        (not
          (settlement_message_available ?settlement_message)
        )
      )
  )
  (:action assemble_settlement_message_both_reserved
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_channel - debit_settlement_channel ?credit_channel - credit_settlement_channel ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (debit_leg_ready ?debit_leg)
        (credit_leg_ready ?credit_leg)
        (debit_leg_assigned_channel ?debit_leg ?debit_channel)
        (credit_leg_assigned_channel ?credit_leg ?credit_channel)
        (debit_channel_reserved ?debit_channel)
        (credit_channel_reserved ?credit_channel)
        (not
          (debit_leg_funding_reserved ?debit_leg)
        )
        (not
          (credit_leg_funding_reserved ?credit_leg)
        )
        (settlement_message_available ?settlement_message)
      )
    :effect
      (and
        (settlement_message_assembled ?settlement_message)
        (message_mapped_to_debit_channel ?settlement_message ?debit_channel)
        (message_mapped_to_credit_channel ?settlement_message ?credit_channel)
        (message_debit_reserved_flag ?settlement_message)
        (message_credit_reserved_flag ?settlement_message)
        (not
          (settlement_message_available ?settlement_message)
        )
      )
  )
  (:action mark_message_dispatch_ready
    :parameters (?settlement_message - settlement_instruction_message ?debit_leg - debit_leg ?validation_service - validation_service)
    :precondition
      (and
        (settlement_message_assembled ?settlement_message)
        (debit_leg_ready ?debit_leg)
        (entity_assigned_validation_service ?debit_leg ?validation_service)
        (not
          (message_ready_for_dispatch ?settlement_message)
        )
      )
    :effect (message_ready_for_dispatch ?settlement_message)
  )
  (:action reserve_settlement_account_for_message
    :parameters (?settlement_case - settlement_case ?settlement_account - settlement_account ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (entity_validated ?settlement_case)
        (case_linked_to_message ?settlement_case ?settlement_message)
        (case_assigned_account ?settlement_case ?settlement_account)
        (settlement_account_available ?settlement_account)
        (settlement_message_assembled ?settlement_message)
        (message_ready_for_dispatch ?settlement_message)
        (not
          (settlement_account_reserved ?settlement_account)
        )
      )
    :effect
      (and
        (settlement_account_reserved ?settlement_account)
        (settlement_account_reserved_for_message ?settlement_account ?settlement_message)
        (not
          (settlement_account_available ?settlement_account)
        )
      )
  )
  (:action confirm_case_account_reservation
    :parameters (?settlement_case - settlement_case ?settlement_account - settlement_account ?settlement_message - settlement_instruction_message ?validation_service - validation_service)
    :precondition
      (and
        (entity_validated ?settlement_case)
        (case_assigned_account ?settlement_case ?settlement_account)
        (settlement_account_reserved ?settlement_account)
        (settlement_account_reserved_for_message ?settlement_account ?settlement_message)
        (entity_assigned_validation_service ?settlement_case ?validation_service)
        (not
          (message_debit_reserved_flag ?settlement_message)
        )
        (not
          (case_account_reservation_confirmed ?settlement_case)
        )
      )
    :effect (case_account_reservation_confirmed ?settlement_case)
  )
  (:action attach_regulatory_check
    :parameters (?settlement_case - settlement_case ?regulatory_check - regulatory_check)
    :precondition
      (and
        (entity_validated ?settlement_case)
        (regulatory_check_available ?regulatory_check)
        (not
          (case_has_regulatory_check ?settlement_case)
        )
      )
    :effect
      (and
        (case_has_regulatory_check ?settlement_case)
        (case_assigned_regulatory_check ?settlement_case ?regulatory_check)
        (not
          (regulatory_check_available ?regulatory_check)
        )
      )
  )
  (:action apply_regulatory_check_and_flag_case
    :parameters (?settlement_case - settlement_case ?settlement_account - settlement_account ?settlement_message - settlement_instruction_message ?validation_service - validation_service ?regulatory_check - regulatory_check)
    :precondition
      (and
        (entity_validated ?settlement_case)
        (case_assigned_account ?settlement_case ?settlement_account)
        (settlement_account_reserved ?settlement_account)
        (settlement_account_reserved_for_message ?settlement_account ?settlement_message)
        (entity_assigned_validation_service ?settlement_case ?validation_service)
        (message_debit_reserved_flag ?settlement_message)
        (case_has_regulatory_check ?settlement_case)
        (case_assigned_regulatory_check ?settlement_case ?regulatory_check)
        (not
          (case_account_reservation_confirmed ?settlement_case)
        )
      )
    :effect
      (and
        (case_account_reservation_confirmed ?settlement_case)
        (case_regulatory_check_passed ?settlement_case)
      )
  )
  (:action attach_posting_profile_and_prepare_case
    :parameters (?settlement_case - settlement_case ?posting_profile - posting_profile ?authorizer - authorizer ?settlement_account - settlement_account ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (case_account_reservation_confirmed ?settlement_case)
        (case_assigned_posting_profile ?settlement_case ?posting_profile)
        (entity_assigned_authorizer ?settlement_case ?authorizer)
        (case_assigned_account ?settlement_case ?settlement_account)
        (settlement_account_reserved_for_message ?settlement_account ?settlement_message)
        (not
          (message_credit_reserved_flag ?settlement_message)
        )
        (not
          (case_posting_profile_bound ?settlement_case)
        )
      )
    :effect (case_posting_profile_bound ?settlement_case)
  )
  (:action attach_posting_profile_and_prepare_case_alternative
    :parameters (?settlement_case - settlement_case ?posting_profile - posting_profile ?authorizer - authorizer ?settlement_account - settlement_account ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (case_account_reservation_confirmed ?settlement_case)
        (case_assigned_posting_profile ?settlement_case ?posting_profile)
        (entity_assigned_authorizer ?settlement_case ?authorizer)
        (case_assigned_account ?settlement_case ?settlement_account)
        (settlement_account_reserved_for_message ?settlement_account ?settlement_message)
        (message_credit_reserved_flag ?settlement_message)
        (not
          (case_posting_profile_bound ?settlement_case)
        )
      )
    :effect (case_posting_profile_bound ?settlement_case)
  )
  (:action finalize_case_for_posting_no_flags
    :parameters (?settlement_case - settlement_case ?third_party_confirmation - third_party_confirmation ?settlement_account - settlement_account ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (case_posting_profile_bound ?settlement_case)
        (case_assigned_third_party_confirmation ?settlement_case ?third_party_confirmation)
        (case_assigned_account ?settlement_case ?settlement_account)
        (settlement_account_reserved_for_message ?settlement_account ?settlement_message)
        (not
          (message_debit_reserved_flag ?settlement_message)
        )
        (not
          (message_credit_reserved_flag ?settlement_message)
        )
        (not
          (case_ready_for_final_checks ?settlement_case)
        )
      )
    :effect (case_ready_for_final_checks ?settlement_case)
  )
  (:action finalize_case_for_posting_with_debit_flag
    :parameters (?settlement_case - settlement_case ?third_party_confirmation - third_party_confirmation ?settlement_account - settlement_account ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (case_posting_profile_bound ?settlement_case)
        (case_assigned_third_party_confirmation ?settlement_case ?third_party_confirmation)
        (case_assigned_account ?settlement_case ?settlement_account)
        (settlement_account_reserved_for_message ?settlement_account ?settlement_message)
        (message_debit_reserved_flag ?settlement_message)
        (not
          (message_credit_reserved_flag ?settlement_message)
        )
        (not
          (case_ready_for_final_checks ?settlement_case)
        )
      )
    :effect
      (and
        (case_ready_for_final_checks ?settlement_case)
        (case_fee_applicable ?settlement_case)
      )
  )
  (:action finalize_case_for_posting_with_credit_flag
    :parameters (?settlement_case - settlement_case ?third_party_confirmation - third_party_confirmation ?settlement_account - settlement_account ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (case_posting_profile_bound ?settlement_case)
        (case_assigned_third_party_confirmation ?settlement_case ?third_party_confirmation)
        (case_assigned_account ?settlement_case ?settlement_account)
        (settlement_account_reserved_for_message ?settlement_account ?settlement_message)
        (not
          (message_debit_reserved_flag ?settlement_message)
        )
        (message_credit_reserved_flag ?settlement_message)
        (not
          (case_ready_for_final_checks ?settlement_case)
        )
      )
    :effect
      (and
        (case_ready_for_final_checks ?settlement_case)
        (case_fee_applicable ?settlement_case)
      )
  )
  (:action finalize_case_for_posting_with_both_flags
    :parameters (?settlement_case - settlement_case ?third_party_confirmation - third_party_confirmation ?settlement_account - settlement_account ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (case_posting_profile_bound ?settlement_case)
        (case_assigned_third_party_confirmation ?settlement_case ?third_party_confirmation)
        (case_assigned_account ?settlement_case ?settlement_account)
        (settlement_account_reserved_for_message ?settlement_account ?settlement_message)
        (message_debit_reserved_flag ?settlement_message)
        (message_credit_reserved_flag ?settlement_message)
        (not
          (case_ready_for_final_checks ?settlement_case)
        )
      )
    :effect
      (and
        (case_ready_for_final_checks ?settlement_case)
        (case_fee_applicable ?settlement_case)
      )
  )
  (:action finalize_and_post_case
    :parameters (?settlement_case - settlement_case)
    :precondition
      (and
        (case_ready_for_final_checks ?settlement_case)
        (not
          (case_fee_applicable ?settlement_case)
        )
        (not
          (case_finalized ?settlement_case)
        )
      )
    :effect
      (and
        (case_finalized ?settlement_case)
        (entity_posted_to_ledger ?settlement_case)
      )
  )
  (:action attach_fee_profile_to_case
    :parameters (?settlement_case - settlement_case ?fee_profile - fee_profile)
    :precondition
      (and
        (case_ready_for_final_checks ?settlement_case)
        (case_fee_applicable ?settlement_case)
        (fee_profile_available ?fee_profile)
      )
    :effect
      (and
        (case_assigned_fee_profile ?settlement_case ?fee_profile)
        (not
          (fee_profile_available ?fee_profile)
        )
      )
  )
  (:action authorize_case_for_posting
    :parameters (?settlement_case - settlement_case ?debit_leg - debit_leg ?credit_leg - credit_leg ?validation_service - validation_service ?fee_profile - fee_profile)
    :precondition
      (and
        (case_ready_for_final_checks ?settlement_case)
        (case_fee_applicable ?settlement_case)
        (case_assigned_fee_profile ?settlement_case ?fee_profile)
        (case_has_debit_leg ?settlement_case ?debit_leg)
        (case_has_credit_leg ?settlement_case ?credit_leg)
        (debit_leg_funding_reserved ?debit_leg)
        (credit_leg_funding_reserved ?credit_leg)
        (entity_assigned_validation_service ?settlement_case ?validation_service)
        (not
          (case_posting_authorized ?settlement_case)
        )
      )
    :effect (case_posting_authorized ?settlement_case)
  )
  (:action complete_case_posting
    :parameters (?settlement_case - settlement_case)
    :precondition
      (and
        (case_ready_for_final_checks ?settlement_case)
        (case_posting_authorized ?settlement_case)
        (not
          (case_finalized ?settlement_case)
        )
      )
    :effect
      (and
        (case_finalized ?settlement_case)
        (entity_posted_to_ledger ?settlement_case)
      )
  )
  (:action attach_correspondent_consent_to_case
    :parameters (?settlement_case - settlement_case ?correspondent_consent - correspondent_consent ?validation_service - validation_service)
    :precondition
      (and
        (entity_validated ?settlement_case)
        (entity_assigned_validation_service ?settlement_case ?validation_service)
        (correspondent_consent_available ?correspondent_consent)
        (case_assigned_correspondent_consent ?settlement_case ?correspondent_consent)
        (not
          (case_consent_attested ?settlement_case)
        )
      )
    :effect
      (and
        (case_consent_attested ?settlement_case)
        (not
          (correspondent_consent_available ?correspondent_consent)
        )
      )
  )
  (:action reserve_authorizer_for_case
    :parameters (?settlement_case - settlement_case ?authorizer - authorizer)
    :precondition
      (and
        (case_consent_attested ?settlement_case)
        (entity_assigned_authorizer ?settlement_case ?authorizer)
        (not
          (case_authorizer_reserved ?settlement_case)
        )
      )
    :effect (case_authorizer_reserved ?settlement_case)
  )
  (:action attach_third_party_confirmation_to_case
    :parameters (?settlement_case - settlement_case ?third_party_confirmation - third_party_confirmation)
    :precondition
      (and
        (case_authorizer_reserved ?settlement_case)
        (case_assigned_third_party_confirmation ?settlement_case ?third_party_confirmation)
        (not
          (case_third_party_confirmed ?settlement_case)
        )
      )
    :effect (case_third_party_confirmed ?settlement_case)
  )
  (:action finalize_confirmation_and_post_case
    :parameters (?settlement_case - settlement_case)
    :precondition
      (and
        (case_third_party_confirmed ?settlement_case)
        (not
          (case_finalized ?settlement_case)
        )
      )
    :effect
      (and
        (case_finalized ?settlement_case)
        (entity_posted_to_ledger ?settlement_case)
      )
  )
  (:action post_debit_leg
    :parameters (?debit_leg - debit_leg ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (debit_leg_ready ?debit_leg)
        (debit_leg_funding_reserved ?debit_leg)
        (settlement_message_assembled ?settlement_message)
        (message_ready_for_dispatch ?settlement_message)
        (not
          (entity_posted_to_ledger ?debit_leg)
        )
      )
    :effect (entity_posted_to_ledger ?debit_leg)
  )
  (:action post_credit_leg
    :parameters (?credit_leg - credit_leg ?settlement_message - settlement_instruction_message)
    :precondition
      (and
        (credit_leg_ready ?credit_leg)
        (credit_leg_funding_reserved ?credit_leg)
        (settlement_message_assembled ?settlement_message)
        (message_ready_for_dispatch ?settlement_message)
        (not
          (entity_posted_to_ledger ?credit_leg)
        )
      )
    :effect (entity_posted_to_ledger ?credit_leg)
  )
  (:action schedule_instruction_for_settlement
    :parameters (?payment_instruction - payment_instruction ?schedule_slot - settlement_schedule_slot ?validation_service - validation_service)
    :precondition
      (and
        (entity_posted_to_ledger ?payment_instruction)
        (entity_assigned_validation_service ?payment_instruction ?validation_service)
        (settlement_schedule_slot_available ?schedule_slot)
        (not
          (entity_settlement_initiated ?payment_instruction)
        )
      )
    :effect
      (and
        (entity_settlement_initiated ?payment_instruction)
        (entity_scheduled ?payment_instruction ?schedule_slot)
        (not
          (settlement_schedule_slot_available ?schedule_slot)
        )
      )
  )
  (:action activate_debit_leg_for_settlement
    :parameters (?debit_leg - debit_leg ?execution_token - execution_channel_token ?schedule_slot - settlement_schedule_slot)
    :precondition
      (and
        (entity_settlement_initiated ?debit_leg)
        (entity_has_execution_token ?debit_leg ?execution_token)
        (entity_scheduled ?debit_leg ?schedule_slot)
        (not
          (entity_activated_for_settlement ?debit_leg)
        )
      )
    :effect
      (and
        (entity_activated_for_settlement ?debit_leg)
        (execution_token_available ?execution_token)
        (settlement_schedule_slot_available ?schedule_slot)
      )
  )
  (:action activate_credit_leg_for_settlement
    :parameters (?credit_leg - credit_leg ?execution_token - execution_channel_token ?schedule_slot - settlement_schedule_slot)
    :precondition
      (and
        (entity_settlement_initiated ?credit_leg)
        (entity_has_execution_token ?credit_leg ?execution_token)
        (entity_scheduled ?credit_leg ?schedule_slot)
        (not
          (entity_activated_for_settlement ?credit_leg)
        )
      )
    :effect
      (and
        (entity_activated_for_settlement ?credit_leg)
        (execution_token_available ?execution_token)
        (settlement_schedule_slot_available ?schedule_slot)
      )
  )
  (:action activate_settlement_case_for_settlement
    :parameters (?settlement_case - settlement_case ?execution_token - execution_channel_token ?schedule_slot - settlement_schedule_slot)
    :precondition
      (and
        (entity_settlement_initiated ?settlement_case)
        (entity_has_execution_token ?settlement_case ?execution_token)
        (entity_scheduled ?settlement_case ?schedule_slot)
        (not
          (entity_activated_for_settlement ?settlement_case)
        )
      )
    :effect
      (and
        (entity_activated_for_settlement ?settlement_case)
        (execution_token_available ?execution_token)
        (settlement_schedule_slot_available ?schedule_slot)
      )
  )
)

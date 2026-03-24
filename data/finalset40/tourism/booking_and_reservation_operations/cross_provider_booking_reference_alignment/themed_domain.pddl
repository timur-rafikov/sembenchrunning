(define (domain cross_provider_booking_reference_alignment)
  (:requirements :strips :typing :negative-preconditions)
  (:types service_type_category - object reference_type_category - object provider_reference_category - object booking_root_type - object booking_intent - booking_root_type provider_offer_slot - service_type_category confirmation_channel_token - service_type_category operator_agent - service_type_category credential - service_type_category passenger_or_customer_profile - service_type_category alignment_token - service_type_category supplier_confirmation_payload - service_type_category vendor_acknowledgement - service_type_category voucher_or_auxiliary_token - reference_type_category customer_manifest - reference_type_category external_vendor_reference - reference_type_category provider_a_reference - provider_reference_category provider_b_reference - provider_reference_category aggregated_cross_provider_record - provider_reference_category booking_subtype_a - booking_intent booking_subtype_b - booking_intent provider_a_booking_record - booking_subtype_a provider_b_booking_record - booking_subtype_a master_orchestrator_booking - booking_subtype_b)
  (:predicates
    (booking_intent_selected ?booking_intent - booking_intent)
    (booking_locally_confirmed ?booking_intent - booking_intent)
    (booking_provisional_hold ?booking_intent - booking_intent)
    (booking_reference_aligned ?booking_intent - booking_intent)
    (booking_ready_for_alignment ?booking_intent - booking_intent)
    (booking_alignment_initialized ?booking_intent - booking_intent)
    (provider_offer_slot_available ?provider_offer_slot - provider_offer_slot)
    (booking_reserved_offer_link ?booking_intent - booking_intent ?provider_offer_slot - provider_offer_slot)
    (confirmation_channel_token_available ?confirmation_channel_token - confirmation_channel_token)
    (booking_confirmation_token_link ?booking_intent - booking_intent ?confirmation_channel_token - confirmation_channel_token)
    (operator_agent_available ?operator_agent - operator_agent)
    (booking_assigned_operator ?booking_intent - booking_intent ?operator_agent - operator_agent)
    (voucher_available ?voucher_or_auxiliary_token - voucher_or_auxiliary_token)
    (provider_a_booking_has_voucher ?provider_a_booking_record - provider_a_booking_record ?voucher_or_auxiliary_token - voucher_or_auxiliary_token)
    (provider_b_booking_has_voucher ?provider_b_booking_record - provider_b_booking_record ?voucher_or_auxiliary_token - voucher_or_auxiliary_token)
    (provider_a_booking_reference_link ?provider_a_booking_record - provider_a_booking_record ?provider_a_reference - provider_a_reference)
    (provider_a_reference_verified ?provider_a_reference - provider_a_reference)
    (provider_a_reference_marked_by_voucher ?provider_a_reference - provider_a_reference)
    (provider_a_booking_validation_confirmed ?provider_a_booking_record - provider_a_booking_record)
    (provider_b_booking_reference_link ?provider_b_booking_record - provider_b_booking_record ?provider_b_reference - provider_b_reference)
    (provider_b_reference_verified ?provider_b_reference - provider_b_reference)
    (provider_b_reference_marked_by_voucher ?provider_b_reference - provider_b_reference)
    (provider_b_booking_validation_confirmed ?provider_b_booking_record - provider_b_booking_record)
    (aggregated_record_slot_available ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    (aggregated_record_created ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    (aggregated_record_links_provider_a_reference ?aggregated_cross_provider_record - aggregated_cross_provider_record ?provider_a_reference - provider_a_reference)
    (aggregated_record_links_provider_b_reference ?aggregated_cross_provider_record - aggregated_cross_provider_record ?provider_b_reference - provider_b_reference)
    (aggregated_record_needs_provider_a_voucher_processing ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    (aggregated_record_needs_provider_b_voucher_processing ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    (aggregated_record_confirmation_path_established ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    (master_booking_links_provider_a ?master_orchestrator_booking - master_orchestrator_booking ?provider_a_booking_record - provider_a_booking_record)
    (master_booking_links_provider_b ?master_orchestrator_booking - master_orchestrator_booking ?provider_b_booking_record - provider_b_booking_record)
    (master_booking_links_aggregated_record ?master_orchestrator_booking - master_orchestrator_booking ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    (customer_manifest_available ?customer_manifest - customer_manifest)
    (master_booking_has_manifest ?master_orchestrator_booking - master_orchestrator_booking ?customer_manifest - customer_manifest)
    (customer_manifest_materialized ?customer_manifest - customer_manifest)
    (customer_manifest_linked_to_aggregated_record ?customer_manifest - customer_manifest ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    (master_booking_ready_for_supplier_processing ?master_orchestrator_booking - master_orchestrator_booking)
    (master_booking_supplier_confirmation_recorded ?master_orchestrator_booking - master_orchestrator_booking)
    (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking - master_orchestrator_booking)
    (master_booking_credential_attached_flag ?master_orchestrator_booking - master_orchestrator_booking)
    (master_booking_enrichment_applied ?master_orchestrator_booking - master_orchestrator_booking)
    (master_booking_requires_additional_enrichment ?master_orchestrator_booking - master_orchestrator_booking)
    (master_booking_enrichment_complete ?master_orchestrator_booking - master_orchestrator_booking)
    (external_vendor_reference_available ?external_vendor_reference - external_vendor_reference)
    (master_booking_has_external_vendor_reference ?master_orchestrator_booking - master_orchestrator_booking ?external_vendor_reference - external_vendor_reference)
    (master_booking_vendor_enrichment_applied ?master_orchestrator_booking - master_orchestrator_booking)
    (master_booking_vendor_operator_assigned ?master_orchestrator_booking - master_orchestrator_booking)
    (master_booking_vendor_acknowledged ?master_orchestrator_booking - master_orchestrator_booking)
    (credential_available ?credential - credential)
    (master_booking_has_credential_link ?master_orchestrator_booking - master_orchestrator_booking ?credential - credential)
    (customer_profile_available ?passenger_or_customer_profile - passenger_or_customer_profile)
    (master_booking_has_customer_profile ?master_orchestrator_booking - master_orchestrator_booking ?passenger_or_customer_profile - passenger_or_customer_profile)
    (supplier_confirmation_payload_available ?supplier_confirmation_payload - supplier_confirmation_payload)
    (master_booking_has_supplier_payload ?master_orchestrator_booking - master_orchestrator_booking ?supplier_confirmation_payload - supplier_confirmation_payload)
    (vendor_acknowledgement_available ?vendor_acknowledgement - vendor_acknowledgement)
    (master_booking_has_vendor_acknowledgement ?master_orchestrator_booking - master_orchestrator_booking ?vendor_acknowledgement - vendor_acknowledgement)
    (alignment_token_available ?alignment_token - alignment_token)
    (booking_alignment_token_link ?booking_intent - booking_intent ?alignment_token - alignment_token)
    (provider_a_validation_ready ?provider_a_booking_record - provider_a_booking_record)
    (provider_b_validation_ready ?provider_b_booking_record - provider_b_booking_record)
    (master_booking_finalization_guard ?master_orchestrator_booking - master_orchestrator_booking)
  )
  (:action select_booking_option
    :parameters (?booking_intent - booking_intent)
    :precondition
      (and
        (not
          (booking_intent_selected ?booking_intent)
        )
        (not
          (booking_reference_aligned ?booking_intent)
        )
      )
    :effect (booking_intent_selected ?booking_intent)
  )
  (:action reserve_provider_offer_slot
    :parameters (?booking_intent - booking_intent ?provider_offer_slot - provider_offer_slot)
    :precondition
      (and
        (booking_intent_selected ?booking_intent)
        (not
          (booking_provisional_hold ?booking_intent)
        )
        (provider_offer_slot_available ?provider_offer_slot)
      )
    :effect
      (and
        (booking_provisional_hold ?booking_intent)
        (booking_reserved_offer_link ?booking_intent ?provider_offer_slot)
        (not
          (provider_offer_slot_available ?provider_offer_slot)
        )
      )
  )
  (:action request_provider_confirmation_token
    :parameters (?booking_intent - booking_intent ?confirmation_channel_token - confirmation_channel_token)
    :precondition
      (and
        (booking_intent_selected ?booking_intent)
        (booking_provisional_hold ?booking_intent)
        (confirmation_channel_token_available ?confirmation_channel_token)
      )
    :effect
      (and
        (booking_confirmation_token_link ?booking_intent ?confirmation_channel_token)
        (not
          (confirmation_channel_token_available ?confirmation_channel_token)
        )
      )
  )
  (:action commit_local_preliminary_confirmation
    :parameters (?booking_intent - booking_intent ?confirmation_channel_token - confirmation_channel_token)
    :precondition
      (and
        (booking_intent_selected ?booking_intent)
        (booking_provisional_hold ?booking_intent)
        (booking_confirmation_token_link ?booking_intent ?confirmation_channel_token)
        (not
          (booking_locally_confirmed ?booking_intent)
        )
      )
    :effect (booking_locally_confirmed ?booking_intent)
  )
  (:action release_confirmation_token
    :parameters (?booking_intent - booking_intent ?confirmation_channel_token - confirmation_channel_token)
    :precondition
      (and
        (booking_confirmation_token_link ?booking_intent ?confirmation_channel_token)
      )
    :effect
      (and
        (confirmation_channel_token_available ?confirmation_channel_token)
        (not
          (booking_confirmation_token_link ?booking_intent ?confirmation_channel_token)
        )
      )
  )
  (:action assign_operator_to_booking
    :parameters (?booking_intent - booking_intent ?operator_agent - operator_agent)
    :precondition
      (and
        (booking_locally_confirmed ?booking_intent)
        (operator_agent_available ?operator_agent)
      )
    :effect
      (and
        (booking_assigned_operator ?booking_intent ?operator_agent)
        (not
          (operator_agent_available ?operator_agent)
        )
      )
  )
  (:action release_operator_assignment
    :parameters (?booking_intent - booking_intent ?operator_agent - operator_agent)
    :precondition
      (and
        (booking_assigned_operator ?booking_intent ?operator_agent)
      )
    :effect
      (and
        (operator_agent_available ?operator_agent)
        (not
          (booking_assigned_operator ?booking_intent ?operator_agent)
        )
      )
  )
  (:action attach_supplier_confirmation_payload
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?supplier_confirmation_payload - supplier_confirmation_payload)
    :precondition
      (and
        (booking_locally_confirmed ?master_orchestrator_booking)
        (supplier_confirmation_payload_available ?supplier_confirmation_payload)
      )
    :effect
      (and
        (master_booking_has_supplier_payload ?master_orchestrator_booking ?supplier_confirmation_payload)
        (not
          (supplier_confirmation_payload_available ?supplier_confirmation_payload)
        )
      )
  )
  (:action detach_supplier_confirmation_payload
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?supplier_confirmation_payload - supplier_confirmation_payload)
    :precondition
      (and
        (master_booking_has_supplier_payload ?master_orchestrator_booking ?supplier_confirmation_payload)
      )
    :effect
      (and
        (supplier_confirmation_payload_available ?supplier_confirmation_payload)
        (not
          (master_booking_has_supplier_payload ?master_orchestrator_booking ?supplier_confirmation_payload)
        )
      )
  )
  (:action attach_vendor_acknowledgement
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?vendor_acknowledgement - vendor_acknowledgement)
    :precondition
      (and
        (booking_locally_confirmed ?master_orchestrator_booking)
        (vendor_acknowledgement_available ?vendor_acknowledgement)
      )
    :effect
      (and
        (master_booking_has_vendor_acknowledgement ?master_orchestrator_booking ?vendor_acknowledgement)
        (not
          (vendor_acknowledgement_available ?vendor_acknowledgement)
        )
      )
  )
  (:action detach_vendor_acknowledgement
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?vendor_acknowledgement - vendor_acknowledgement)
    :precondition
      (and
        (master_booking_has_vendor_acknowledgement ?master_orchestrator_booking ?vendor_acknowledgement)
      )
    :effect
      (and
        (vendor_acknowledgement_available ?vendor_acknowledgement)
        (not
          (master_booking_has_vendor_acknowledgement ?master_orchestrator_booking ?vendor_acknowledgement)
        )
      )
  )
  (:action validate_provider_a_reference
    :parameters (?provider_a_booking_record - provider_a_booking_record ?provider_a_reference - provider_a_reference ?confirmation_channel_token - confirmation_channel_token)
    :precondition
      (and
        (booking_locally_confirmed ?provider_a_booking_record)
        (booking_confirmation_token_link ?provider_a_booking_record ?confirmation_channel_token)
        (provider_a_booking_reference_link ?provider_a_booking_record ?provider_a_reference)
        (not
          (provider_a_reference_verified ?provider_a_reference)
        )
        (not
          (provider_a_reference_marked_by_voucher ?provider_a_reference)
        )
      )
    :effect (provider_a_reference_verified ?provider_a_reference)
  )
  (:action finalize_provider_a_validation
    :parameters (?provider_a_booking_record - provider_a_booking_record ?provider_a_reference - provider_a_reference ?operator_agent - operator_agent)
    :precondition
      (and
        (booking_locally_confirmed ?provider_a_booking_record)
        (booking_assigned_operator ?provider_a_booking_record ?operator_agent)
        (provider_a_booking_reference_link ?provider_a_booking_record ?provider_a_reference)
        (provider_a_reference_verified ?provider_a_reference)
        (not
          (provider_a_validation_ready ?provider_a_booking_record)
        )
      )
    :effect
      (and
        (provider_a_validation_ready ?provider_a_booking_record)
        (provider_a_booking_validation_confirmed ?provider_a_booking_record)
      )
  )
  (:action apply_voucher_to_provider_a_reference
    :parameters (?provider_a_booking_record - provider_a_booking_record ?provider_a_reference - provider_a_reference ?voucher_or_auxiliary_token - voucher_or_auxiliary_token)
    :precondition
      (and
        (booking_locally_confirmed ?provider_a_booking_record)
        (provider_a_booking_reference_link ?provider_a_booking_record ?provider_a_reference)
        (voucher_available ?voucher_or_auxiliary_token)
        (not
          (provider_a_validation_ready ?provider_a_booking_record)
        )
      )
    :effect
      (and
        (provider_a_reference_marked_by_voucher ?provider_a_reference)
        (provider_a_validation_ready ?provider_a_booking_record)
        (provider_a_booking_has_voucher ?provider_a_booking_record ?voucher_or_auxiliary_token)
        (not
          (voucher_available ?voucher_or_auxiliary_token)
        )
      )
  )
  (:action reconcile_provider_a_reference_with_voucher
    :parameters (?provider_a_booking_record - provider_a_booking_record ?provider_a_reference - provider_a_reference ?confirmation_channel_token - confirmation_channel_token ?voucher_or_auxiliary_token - voucher_or_auxiliary_token)
    :precondition
      (and
        (booking_locally_confirmed ?provider_a_booking_record)
        (booking_confirmation_token_link ?provider_a_booking_record ?confirmation_channel_token)
        (provider_a_booking_reference_link ?provider_a_booking_record ?provider_a_reference)
        (provider_a_reference_marked_by_voucher ?provider_a_reference)
        (provider_a_booking_has_voucher ?provider_a_booking_record ?voucher_or_auxiliary_token)
        (not
          (provider_a_booking_validation_confirmed ?provider_a_booking_record)
        )
      )
    :effect
      (and
        (provider_a_reference_verified ?provider_a_reference)
        (provider_a_booking_validation_confirmed ?provider_a_booking_record)
        (voucher_available ?voucher_or_auxiliary_token)
        (not
          (provider_a_booking_has_voucher ?provider_a_booking_record ?voucher_or_auxiliary_token)
        )
      )
  )
  (:action validate_provider_b_reference
    :parameters (?provider_b_booking_record - provider_b_booking_record ?provider_b_reference - provider_b_reference ?confirmation_channel_token - confirmation_channel_token)
    :precondition
      (and
        (booking_locally_confirmed ?provider_b_booking_record)
        (booking_confirmation_token_link ?provider_b_booking_record ?confirmation_channel_token)
        (provider_b_booking_reference_link ?provider_b_booking_record ?provider_b_reference)
        (not
          (provider_b_reference_verified ?provider_b_reference)
        )
        (not
          (provider_b_reference_marked_by_voucher ?provider_b_reference)
        )
      )
    :effect (provider_b_reference_verified ?provider_b_reference)
  )
  (:action finalize_provider_b_validation
    :parameters (?provider_b_booking_record - provider_b_booking_record ?provider_b_reference - provider_b_reference ?operator_agent - operator_agent)
    :precondition
      (and
        (booking_locally_confirmed ?provider_b_booking_record)
        (booking_assigned_operator ?provider_b_booking_record ?operator_agent)
        (provider_b_booking_reference_link ?provider_b_booking_record ?provider_b_reference)
        (provider_b_reference_verified ?provider_b_reference)
        (not
          (provider_b_validation_ready ?provider_b_booking_record)
        )
      )
    :effect
      (and
        (provider_b_validation_ready ?provider_b_booking_record)
        (provider_b_booking_validation_confirmed ?provider_b_booking_record)
      )
  )
  (:action apply_voucher_to_provider_b_reference
    :parameters (?provider_b_booking_record - provider_b_booking_record ?provider_b_reference - provider_b_reference ?voucher_or_auxiliary_token - voucher_or_auxiliary_token)
    :precondition
      (and
        (booking_locally_confirmed ?provider_b_booking_record)
        (provider_b_booking_reference_link ?provider_b_booking_record ?provider_b_reference)
        (voucher_available ?voucher_or_auxiliary_token)
        (not
          (provider_b_validation_ready ?provider_b_booking_record)
        )
      )
    :effect
      (and
        (provider_b_reference_marked_by_voucher ?provider_b_reference)
        (provider_b_validation_ready ?provider_b_booking_record)
        (provider_b_booking_has_voucher ?provider_b_booking_record ?voucher_or_auxiliary_token)
        (not
          (voucher_available ?voucher_or_auxiliary_token)
        )
      )
  )
  (:action reconcile_provider_b_reference_with_voucher
    :parameters (?provider_b_booking_record - provider_b_booking_record ?provider_b_reference - provider_b_reference ?confirmation_channel_token - confirmation_channel_token ?voucher_or_auxiliary_token - voucher_or_auxiliary_token)
    :precondition
      (and
        (booking_locally_confirmed ?provider_b_booking_record)
        (booking_confirmation_token_link ?provider_b_booking_record ?confirmation_channel_token)
        (provider_b_booking_reference_link ?provider_b_booking_record ?provider_b_reference)
        (provider_b_reference_marked_by_voucher ?provider_b_reference)
        (provider_b_booking_has_voucher ?provider_b_booking_record ?voucher_or_auxiliary_token)
        (not
          (provider_b_booking_validation_confirmed ?provider_b_booking_record)
        )
      )
    :effect
      (and
        (provider_b_reference_verified ?provider_b_reference)
        (provider_b_booking_validation_confirmed ?provider_b_booking_record)
        (voucher_available ?voucher_or_auxiliary_token)
        (not
          (provider_b_booking_has_voucher ?provider_b_booking_record ?voucher_or_auxiliary_token)
        )
      )
  )
  (:action create_aggregated_cross_provider_record_standard
    :parameters (?provider_a_booking_record - provider_a_booking_record ?provider_b_booking_record - provider_b_booking_record ?provider_a_reference - provider_a_reference ?provider_b_reference - provider_b_reference ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (provider_a_validation_ready ?provider_a_booking_record)
        (provider_b_validation_ready ?provider_b_booking_record)
        (provider_a_booking_reference_link ?provider_a_booking_record ?provider_a_reference)
        (provider_b_booking_reference_link ?provider_b_booking_record ?provider_b_reference)
        (provider_a_reference_verified ?provider_a_reference)
        (provider_b_reference_verified ?provider_b_reference)
        (provider_a_booking_validation_confirmed ?provider_a_booking_record)
        (provider_b_booking_validation_confirmed ?provider_b_booking_record)
        (aggregated_record_slot_available ?aggregated_cross_provider_record)
      )
    :effect
      (and
        (aggregated_record_created ?aggregated_cross_provider_record)
        (aggregated_record_links_provider_a_reference ?aggregated_cross_provider_record ?provider_a_reference)
        (aggregated_record_links_provider_b_reference ?aggregated_cross_provider_record ?provider_b_reference)
        (not
          (aggregated_record_slot_available ?aggregated_cross_provider_record)
        )
      )
  )
  (:action create_aggregated_cross_provider_record_with_provider_a_voucher
    :parameters (?provider_a_booking_record - provider_a_booking_record ?provider_b_booking_record - provider_b_booking_record ?provider_a_reference - provider_a_reference ?provider_b_reference - provider_b_reference ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (provider_a_validation_ready ?provider_a_booking_record)
        (provider_b_validation_ready ?provider_b_booking_record)
        (provider_a_booking_reference_link ?provider_a_booking_record ?provider_a_reference)
        (provider_b_booking_reference_link ?provider_b_booking_record ?provider_b_reference)
        (provider_a_reference_marked_by_voucher ?provider_a_reference)
        (provider_b_reference_verified ?provider_b_reference)
        (not
          (provider_a_booking_validation_confirmed ?provider_a_booking_record)
        )
        (provider_b_booking_validation_confirmed ?provider_b_booking_record)
        (aggregated_record_slot_available ?aggregated_cross_provider_record)
      )
    :effect
      (and
        (aggregated_record_created ?aggregated_cross_provider_record)
        (aggregated_record_links_provider_a_reference ?aggregated_cross_provider_record ?provider_a_reference)
        (aggregated_record_links_provider_b_reference ?aggregated_cross_provider_record ?provider_b_reference)
        (aggregated_record_needs_provider_a_voucher_processing ?aggregated_cross_provider_record)
        (not
          (aggregated_record_slot_available ?aggregated_cross_provider_record)
        )
      )
  )
  (:action create_aggregated_cross_provider_record_with_provider_b_voucher
    :parameters (?provider_a_booking_record - provider_a_booking_record ?provider_b_booking_record - provider_b_booking_record ?provider_a_reference - provider_a_reference ?provider_b_reference - provider_b_reference ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (provider_a_validation_ready ?provider_a_booking_record)
        (provider_b_validation_ready ?provider_b_booking_record)
        (provider_a_booking_reference_link ?provider_a_booking_record ?provider_a_reference)
        (provider_b_booking_reference_link ?provider_b_booking_record ?provider_b_reference)
        (provider_a_reference_verified ?provider_a_reference)
        (provider_b_reference_marked_by_voucher ?provider_b_reference)
        (provider_a_booking_validation_confirmed ?provider_a_booking_record)
        (not
          (provider_b_booking_validation_confirmed ?provider_b_booking_record)
        )
        (aggregated_record_slot_available ?aggregated_cross_provider_record)
      )
    :effect
      (and
        (aggregated_record_created ?aggregated_cross_provider_record)
        (aggregated_record_links_provider_a_reference ?aggregated_cross_provider_record ?provider_a_reference)
        (aggregated_record_links_provider_b_reference ?aggregated_cross_provider_record ?provider_b_reference)
        (aggregated_record_needs_provider_b_voucher_processing ?aggregated_cross_provider_record)
        (not
          (aggregated_record_slot_available ?aggregated_cross_provider_record)
        )
      )
  )
  (:action create_aggregated_cross_provider_record_with_both_vouchers
    :parameters (?provider_a_booking_record - provider_a_booking_record ?provider_b_booking_record - provider_b_booking_record ?provider_a_reference - provider_a_reference ?provider_b_reference - provider_b_reference ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (provider_a_validation_ready ?provider_a_booking_record)
        (provider_b_validation_ready ?provider_b_booking_record)
        (provider_a_booking_reference_link ?provider_a_booking_record ?provider_a_reference)
        (provider_b_booking_reference_link ?provider_b_booking_record ?provider_b_reference)
        (provider_a_reference_marked_by_voucher ?provider_a_reference)
        (provider_b_reference_marked_by_voucher ?provider_b_reference)
        (not
          (provider_a_booking_validation_confirmed ?provider_a_booking_record)
        )
        (not
          (provider_b_booking_validation_confirmed ?provider_b_booking_record)
        )
        (aggregated_record_slot_available ?aggregated_cross_provider_record)
      )
    :effect
      (and
        (aggregated_record_created ?aggregated_cross_provider_record)
        (aggregated_record_links_provider_a_reference ?aggregated_cross_provider_record ?provider_a_reference)
        (aggregated_record_links_provider_b_reference ?aggregated_cross_provider_record ?provider_b_reference)
        (aggregated_record_needs_provider_a_voucher_processing ?aggregated_cross_provider_record)
        (aggregated_record_needs_provider_b_voucher_processing ?aggregated_cross_provider_record)
        (not
          (aggregated_record_slot_available ?aggregated_cross_provider_record)
        )
      )
  )
  (:action establish_aggregated_record_confirmation_path
    :parameters (?aggregated_cross_provider_record - aggregated_cross_provider_record ?provider_a_booking_record - provider_a_booking_record ?confirmation_channel_token - confirmation_channel_token)
    :precondition
      (and
        (aggregated_record_created ?aggregated_cross_provider_record)
        (provider_a_validation_ready ?provider_a_booking_record)
        (booking_confirmation_token_link ?provider_a_booking_record ?confirmation_channel_token)
        (not
          (aggregated_record_confirmation_path_established ?aggregated_cross_provider_record)
        )
      )
    :effect (aggregated_record_confirmation_path_established ?aggregated_cross_provider_record)
  )
  (:action materialize_customer_manifest
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?customer_manifest - customer_manifest ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (booking_locally_confirmed ?master_orchestrator_booking)
        (master_booking_links_aggregated_record ?master_orchestrator_booking ?aggregated_cross_provider_record)
        (master_booking_has_manifest ?master_orchestrator_booking ?customer_manifest)
        (customer_manifest_available ?customer_manifest)
        (aggregated_record_created ?aggregated_cross_provider_record)
        (aggregated_record_confirmation_path_established ?aggregated_cross_provider_record)
        (not
          (customer_manifest_materialized ?customer_manifest)
        )
      )
    :effect
      (and
        (customer_manifest_materialized ?customer_manifest)
        (customer_manifest_linked_to_aggregated_record ?customer_manifest ?aggregated_cross_provider_record)
        (not
          (customer_manifest_available ?customer_manifest)
        )
      )
  )
  (:action prepare_master_for_supplier_processing
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?customer_manifest - customer_manifest ?aggregated_cross_provider_record - aggregated_cross_provider_record ?confirmation_channel_token - confirmation_channel_token)
    :precondition
      (and
        (booking_locally_confirmed ?master_orchestrator_booking)
        (master_booking_has_manifest ?master_orchestrator_booking ?customer_manifest)
        (customer_manifest_materialized ?customer_manifest)
        (customer_manifest_linked_to_aggregated_record ?customer_manifest ?aggregated_cross_provider_record)
        (booking_confirmation_token_link ?master_orchestrator_booking ?confirmation_channel_token)
        (not
          (aggregated_record_needs_provider_a_voucher_processing ?aggregated_cross_provider_record)
        )
        (not
          (master_booking_ready_for_supplier_processing ?master_orchestrator_booking)
        )
      )
    :effect (master_booking_ready_for_supplier_processing ?master_orchestrator_booking)
  )
  (:action attach_credential_to_master_booking
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?credential - credential)
    :precondition
      (and
        (booking_locally_confirmed ?master_orchestrator_booking)
        (credential_available ?credential)
        (not
          (master_booking_credential_attached_flag ?master_orchestrator_booking)
        )
      )
    :effect
      (and
        (master_booking_credential_attached_flag ?master_orchestrator_booking)
        (master_booking_has_credential_link ?master_orchestrator_booking ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action apply_credential_and_enrich_master_booking
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?customer_manifest - customer_manifest ?aggregated_cross_provider_record - aggregated_cross_provider_record ?confirmation_channel_token - confirmation_channel_token ?credential - credential)
    :precondition
      (and
        (booking_locally_confirmed ?master_orchestrator_booking)
        (master_booking_has_manifest ?master_orchestrator_booking ?customer_manifest)
        (customer_manifest_materialized ?customer_manifest)
        (customer_manifest_linked_to_aggregated_record ?customer_manifest ?aggregated_cross_provider_record)
        (booking_confirmation_token_link ?master_orchestrator_booking ?confirmation_channel_token)
        (aggregated_record_needs_provider_a_voucher_processing ?aggregated_cross_provider_record)
        (master_booking_credential_attached_flag ?master_orchestrator_booking)
        (master_booking_has_credential_link ?master_orchestrator_booking ?credential)
        (not
          (master_booking_ready_for_supplier_processing ?master_orchestrator_booking)
        )
      )
    :effect
      (and
        (master_booking_ready_for_supplier_processing ?master_orchestrator_booking)
        (master_booking_enrichment_applied ?master_orchestrator_booking)
      )
  )
  (:action process_supplier_confirmation_primary
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?supplier_confirmation_payload - supplier_confirmation_payload ?operator_agent - operator_agent ?customer_manifest - customer_manifest ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (master_booking_ready_for_supplier_processing ?master_orchestrator_booking)
        (master_booking_has_supplier_payload ?master_orchestrator_booking ?supplier_confirmation_payload)
        (booking_assigned_operator ?master_orchestrator_booking ?operator_agent)
        (master_booking_has_manifest ?master_orchestrator_booking ?customer_manifest)
        (customer_manifest_linked_to_aggregated_record ?customer_manifest ?aggregated_cross_provider_record)
        (not
          (aggregated_record_needs_provider_b_voucher_processing ?aggregated_cross_provider_record)
        )
        (not
          (master_booking_supplier_confirmation_recorded ?master_orchestrator_booking)
        )
      )
    :effect (master_booking_supplier_confirmation_recorded ?master_orchestrator_booking)
  )
  (:action process_supplier_confirmation_primary_with_voucher
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?supplier_confirmation_payload - supplier_confirmation_payload ?operator_agent - operator_agent ?customer_manifest - customer_manifest ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (master_booking_ready_for_supplier_processing ?master_orchestrator_booking)
        (master_booking_has_supplier_payload ?master_orchestrator_booking ?supplier_confirmation_payload)
        (booking_assigned_operator ?master_orchestrator_booking ?operator_agent)
        (master_booking_has_manifest ?master_orchestrator_booking ?customer_manifest)
        (customer_manifest_linked_to_aggregated_record ?customer_manifest ?aggregated_cross_provider_record)
        (aggregated_record_needs_provider_b_voucher_processing ?aggregated_cross_provider_record)
        (not
          (master_booking_supplier_confirmation_recorded ?master_orchestrator_booking)
        )
      )
    :effect (master_booking_supplier_confirmation_recorded ?master_orchestrator_booking)
  )
  (:action finalize_supplier_confirmation_no_vouchers
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?vendor_acknowledgement - vendor_acknowledgement ?customer_manifest - customer_manifest ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (master_booking_supplier_confirmation_recorded ?master_orchestrator_booking)
        (master_booking_has_vendor_acknowledgement ?master_orchestrator_booking ?vendor_acknowledgement)
        (master_booking_has_manifest ?master_orchestrator_booking ?customer_manifest)
        (customer_manifest_linked_to_aggregated_record ?customer_manifest ?aggregated_cross_provider_record)
        (not
          (aggregated_record_needs_provider_a_voucher_processing ?aggregated_cross_provider_record)
        )
        (not
          (aggregated_record_needs_provider_b_voucher_processing ?aggregated_cross_provider_record)
        )
        (not
          (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        )
      )
    :effect (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
  )
  (:action finalize_supplier_confirmation_with_provider_a_voucher
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?vendor_acknowledgement - vendor_acknowledgement ?customer_manifest - customer_manifest ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (master_booking_supplier_confirmation_recorded ?master_orchestrator_booking)
        (master_booking_has_vendor_acknowledgement ?master_orchestrator_booking ?vendor_acknowledgement)
        (master_booking_has_manifest ?master_orchestrator_booking ?customer_manifest)
        (customer_manifest_linked_to_aggregated_record ?customer_manifest ?aggregated_cross_provider_record)
        (aggregated_record_needs_provider_a_voucher_processing ?aggregated_cross_provider_record)
        (not
          (aggregated_record_needs_provider_b_voucher_processing ?aggregated_cross_provider_record)
        )
        (not
          (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        )
      )
    :effect
      (and
        (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        (master_booking_requires_additional_enrichment ?master_orchestrator_booking)
      )
  )
  (:action finalize_supplier_confirmation_with_provider_b_voucher
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?vendor_acknowledgement - vendor_acknowledgement ?customer_manifest - customer_manifest ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (master_booking_supplier_confirmation_recorded ?master_orchestrator_booking)
        (master_booking_has_vendor_acknowledgement ?master_orchestrator_booking ?vendor_acknowledgement)
        (master_booking_has_manifest ?master_orchestrator_booking ?customer_manifest)
        (customer_manifest_linked_to_aggregated_record ?customer_manifest ?aggregated_cross_provider_record)
        (not
          (aggregated_record_needs_provider_a_voucher_processing ?aggregated_cross_provider_record)
        )
        (aggregated_record_needs_provider_b_voucher_processing ?aggregated_cross_provider_record)
        (not
          (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        )
      )
    :effect
      (and
        (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        (master_booking_requires_additional_enrichment ?master_orchestrator_booking)
      )
  )
  (:action finalize_supplier_confirmation_with_both_vouchers
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?vendor_acknowledgement - vendor_acknowledgement ?customer_manifest - customer_manifest ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (master_booking_supplier_confirmation_recorded ?master_orchestrator_booking)
        (master_booking_has_vendor_acknowledgement ?master_orchestrator_booking ?vendor_acknowledgement)
        (master_booking_has_manifest ?master_orchestrator_booking ?customer_manifest)
        (customer_manifest_linked_to_aggregated_record ?customer_manifest ?aggregated_cross_provider_record)
        (aggregated_record_needs_provider_a_voucher_processing ?aggregated_cross_provider_record)
        (aggregated_record_needs_provider_b_voucher_processing ?aggregated_cross_provider_record)
        (not
          (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        )
      )
    :effect
      (and
        (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        (master_booking_requires_additional_enrichment ?master_orchestrator_booking)
      )
  )
  (:action finalize_master_booking_simple
    :parameters (?master_orchestrator_booking - master_orchestrator_booking)
    :precondition
      (and
        (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        (not
          (master_booking_requires_additional_enrichment ?master_orchestrator_booking)
        )
        (not
          (master_booking_finalization_guard ?master_orchestrator_booking)
        )
      )
    :effect
      (and
        (master_booking_finalization_guard ?master_orchestrator_booking)
        (booking_ready_for_alignment ?master_orchestrator_booking)
      )
  )
  (:action attach_customer_profile_to_master_booking
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?passenger_or_customer_profile - passenger_or_customer_profile)
    :precondition
      (and
        (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        (master_booking_requires_additional_enrichment ?master_orchestrator_booking)
        (customer_profile_available ?passenger_or_customer_profile)
      )
    :effect
      (and
        (master_booking_has_customer_profile ?master_orchestrator_booking ?passenger_or_customer_profile)
        (not
          (customer_profile_available ?passenger_or_customer_profile)
        )
      )
  )
  (:action materialize_and_confirm_provider_records
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?provider_a_booking_record - provider_a_booking_record ?provider_b_booking_record - provider_b_booking_record ?confirmation_channel_token - confirmation_channel_token ?passenger_or_customer_profile - passenger_or_customer_profile)
    :precondition
      (and
        (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        (master_booking_requires_additional_enrichment ?master_orchestrator_booking)
        (master_booking_has_customer_profile ?master_orchestrator_booking ?passenger_or_customer_profile)
        (master_booking_links_provider_a ?master_orchestrator_booking ?provider_a_booking_record)
        (master_booking_links_provider_b ?master_orchestrator_booking ?provider_b_booking_record)
        (provider_a_booking_validation_confirmed ?provider_a_booking_record)
        (provider_b_booking_validation_confirmed ?provider_b_booking_record)
        (booking_confirmation_token_link ?master_orchestrator_booking ?confirmation_channel_token)
        (not
          (master_booking_enrichment_complete ?master_orchestrator_booking)
        )
      )
    :effect (master_booking_enrichment_complete ?master_orchestrator_booking)
  )
  (:action finalize_master_booking_after_enrichment
    :parameters (?master_orchestrator_booking - master_orchestrator_booking)
    :precondition
      (and
        (master_booking_supplier_confirmation_finalized_flag ?master_orchestrator_booking)
        (master_booking_enrichment_complete ?master_orchestrator_booking)
        (not
          (master_booking_finalization_guard ?master_orchestrator_booking)
        )
      )
    :effect
      (and
        (master_booking_finalization_guard ?master_orchestrator_booking)
        (booking_ready_for_alignment ?master_orchestrator_booking)
      )
  )
  (:action apply_external_vendor_reference
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?external_vendor_reference - external_vendor_reference ?confirmation_channel_token - confirmation_channel_token)
    :precondition
      (and
        (booking_locally_confirmed ?master_orchestrator_booking)
        (booking_confirmation_token_link ?master_orchestrator_booking ?confirmation_channel_token)
        (external_vendor_reference_available ?external_vendor_reference)
        (master_booking_has_external_vendor_reference ?master_orchestrator_booking ?external_vendor_reference)
        (not
          (master_booking_vendor_enrichment_applied ?master_orchestrator_booking)
        )
      )
    :effect
      (and
        (master_booking_vendor_enrichment_applied ?master_orchestrator_booking)
        (not
          (external_vendor_reference_available ?external_vendor_reference)
        )
      )
  )
  (:action assign_operator_for_external_vendor_enrichment
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?operator_agent - operator_agent)
    :precondition
      (and
        (master_booking_vendor_enrichment_applied ?master_orchestrator_booking)
        (booking_assigned_operator ?master_orchestrator_booking ?operator_agent)
        (not
          (master_booking_vendor_operator_assigned ?master_orchestrator_booking)
        )
      )
    :effect (master_booking_vendor_operator_assigned ?master_orchestrator_booking)
  )
  (:action acknowledge_vendor_enrichment
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?vendor_acknowledgement - vendor_acknowledgement)
    :precondition
      (and
        (master_booking_vendor_operator_assigned ?master_orchestrator_booking)
        (master_booking_has_vendor_acknowledgement ?master_orchestrator_booking ?vendor_acknowledgement)
        (not
          (master_booking_vendor_acknowledged ?master_orchestrator_booking)
        )
      )
    :effect (master_booking_vendor_acknowledged ?master_orchestrator_booking)
  )
  (:action finalize_master_booking_vendor_enrichment
    :parameters (?master_orchestrator_booking - master_orchestrator_booking)
    :precondition
      (and
        (master_booking_vendor_acknowledged ?master_orchestrator_booking)
        (not
          (master_booking_finalization_guard ?master_orchestrator_booking)
        )
      )
    :effect
      (and
        (master_booking_finalization_guard ?master_orchestrator_booking)
        (booking_ready_for_alignment ?master_orchestrator_booking)
      )
  )
  (:action materialize_provider_a_booking
    :parameters (?provider_a_booking_record - provider_a_booking_record ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (provider_a_validation_ready ?provider_a_booking_record)
        (provider_a_booking_validation_confirmed ?provider_a_booking_record)
        (aggregated_record_created ?aggregated_cross_provider_record)
        (aggregated_record_confirmation_path_established ?aggregated_cross_provider_record)
        (not
          (booking_ready_for_alignment ?provider_a_booking_record)
        )
      )
    :effect (booking_ready_for_alignment ?provider_a_booking_record)
  )
  (:action materialize_provider_b_booking
    :parameters (?provider_b_booking_record - provider_b_booking_record ?aggregated_cross_provider_record - aggregated_cross_provider_record)
    :precondition
      (and
        (provider_b_validation_ready ?provider_b_booking_record)
        (provider_b_booking_validation_confirmed ?provider_b_booking_record)
        (aggregated_record_created ?aggregated_cross_provider_record)
        (aggregated_record_confirmation_path_established ?aggregated_cross_provider_record)
        (not
          (booking_ready_for_alignment ?provider_b_booking_record)
        )
      )
    :effect (booking_ready_for_alignment ?provider_b_booking_record)
  )
  (:action initiate_alignment_with_token
    :parameters (?booking_intent - booking_intent ?alignment_token - alignment_token ?confirmation_channel_token - confirmation_channel_token)
    :precondition
      (and
        (booking_ready_for_alignment ?booking_intent)
        (booking_confirmation_token_link ?booking_intent ?confirmation_channel_token)
        (alignment_token_available ?alignment_token)
        (not
          (booking_alignment_initialized ?booking_intent)
        )
      )
    :effect
      (and
        (booking_alignment_initialized ?booking_intent)
        (booking_alignment_token_link ?booking_intent ?alignment_token)
        (not
          (alignment_token_available ?alignment_token)
        )
      )
  )
  (:action finalize_provider_a_alignment
    :parameters (?provider_a_booking_record - provider_a_booking_record ?provider_offer_slot - provider_offer_slot ?alignment_token - alignment_token)
    :precondition
      (and
        (booking_alignment_initialized ?provider_a_booking_record)
        (booking_reserved_offer_link ?provider_a_booking_record ?provider_offer_slot)
        (booking_alignment_token_link ?provider_a_booking_record ?alignment_token)
        (not
          (booking_reference_aligned ?provider_a_booking_record)
        )
      )
    :effect
      (and
        (booking_reference_aligned ?provider_a_booking_record)
        (provider_offer_slot_available ?provider_offer_slot)
        (alignment_token_available ?alignment_token)
      )
  )
  (:action finalize_provider_b_alignment
    :parameters (?provider_b_booking_record - provider_b_booking_record ?provider_offer_slot - provider_offer_slot ?alignment_token - alignment_token)
    :precondition
      (and
        (booking_alignment_initialized ?provider_b_booking_record)
        (booking_reserved_offer_link ?provider_b_booking_record ?provider_offer_slot)
        (booking_alignment_token_link ?provider_b_booking_record ?alignment_token)
        (not
          (booking_reference_aligned ?provider_b_booking_record)
        )
      )
    :effect
      (and
        (booking_reference_aligned ?provider_b_booking_record)
        (provider_offer_slot_available ?provider_offer_slot)
        (alignment_token_available ?alignment_token)
      )
  )
  (:action finalize_master_booking_alignment
    :parameters (?master_orchestrator_booking - master_orchestrator_booking ?provider_offer_slot - provider_offer_slot ?alignment_token - alignment_token)
    :precondition
      (and
        (booking_alignment_initialized ?master_orchestrator_booking)
        (booking_reserved_offer_link ?master_orchestrator_booking ?provider_offer_slot)
        (booking_alignment_token_link ?master_orchestrator_booking ?alignment_token)
        (not
          (booking_reference_aligned ?master_orchestrator_booking)
        )
      )
    :effect
      (and
        (booking_reference_aligned ?master_orchestrator_booking)
        (provider_offer_slot_available ?provider_offer_slot)
        (alignment_token_available ?alignment_token)
      )
  )
)

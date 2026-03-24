(define (domain tourism_payment_timing_for_reservation_commitment)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object service_resource - entity informational_resource - entity channel_resource - entity reservation_root - entity reservation_option - reservation_root payment_provider - service_resource customer - service_resource booking_agent - service_resource promotion_or_rate_plan - service_resource approval_token - service_resource payment_instrument - service_resource payment_method_token - service_resource settlement_account - service_resource price_component - informational_resource fulfillment_item - informational_resource terms_document - informational_resource supplier_channel - channel_resource distribution_channel - channel_resource booking_record - channel_resource reservation_subgroup - reservation_option reservation_subgroup_alt - reservation_option supplier_reservation_unit - reservation_subgroup channel_reservation_unit - reservation_subgroup booking_process - reservation_subgroup_alt)

  (:predicates
    (reservation_option_selected ?reservation_option - reservation_option)
    (reservation_confirmed ?reservation_option - reservation_option)
    (payment_provider_attached ?reservation_option - reservation_option)
    (reservation_committed ?reservation_option - reservation_option)
    (eligible_for_commitment ?reservation_option - reservation_option)
    (reservation_payment_authorized ?reservation_option - reservation_option)
    (payment_provider_available ?payment_provider - payment_provider)
    (reservation_bound_to_payment_provider ?reservation_option - reservation_option ?payment_provider - payment_provider)
    (customer_available ?customer - customer)
    (reservation_linked_to_customer ?reservation_option - reservation_option ?customer - customer)
    (booking_agent_available ?booking_agent - booking_agent)
    (reservation_assigned_to_agent ?reservation_option - reservation_option ?booking_agent - booking_agent)
    (price_component_available ?price_component - price_component)
    (supplier_unit_price_applied ?supplier_res_unit - supplier_reservation_unit ?price_component - price_component)
    (channel_unit_price_applied ?channel_res_unit - channel_reservation_unit ?price_component - price_component)
    (supplier_unit_mapped_to_supplier_channel ?supplier_res_unit - supplier_reservation_unit ?supplier_channel - supplier_channel)
    (supplier_channel_ready ?supplier_channel - supplier_channel)
    (supplier_channel_price_applied ?supplier_channel - supplier_channel)
    (supplier_unit_inventory_locked ?supplier_res_unit - supplier_reservation_unit)
    (channel_unit_mapped_to_distribution_channel ?channel_res_unit - channel_reservation_unit ?distribution_channel - distribution_channel)
    (distribution_channel_ready ?distribution_channel - distribution_channel)
    (distribution_channel_price_applied ?distribution_channel - distribution_channel)
    (channel_unit_inventory_locked ?channel_res_unit - channel_reservation_unit)
    (booking_record_draft ?booking_record - booking_record)
    (booking_record_initialized ?booking_record - booking_record)
    (booking_record_linked_to_supplier_channel ?booking_record - booking_record ?supplier_channel - supplier_channel)
    (booking_record_linked_to_distribution_channel ?booking_record - booking_record ?distribution_channel - distribution_channel)
    (booking_record_supplier_confirmation_flag ?booking_record - booking_record)
    (booking_record_distribution_confirmation_flag ?booking_record - booking_record)
    (booking_record_ready_for_fulfillment_binding ?booking_record - booking_record)
    (booking_process_includes_supplier_unit ?booking_process - booking_process ?supplier_res_unit - supplier_reservation_unit)
    (booking_process_includes_channel_unit ?booking_process - booking_process ?channel_res_unit - channel_reservation_unit)
    (booking_process_linked_to_booking_record ?booking_process - booking_process ?booking_record - booking_record)
    (fulfillment_item_available ?fulfillment_item - fulfillment_item)
    (booking_process_has_fulfillment_item ?booking_process - booking_process ?fulfillment_item - fulfillment_item)
    (fulfillment_item_bound ?fulfillment_item - fulfillment_item)
    (fulfillment_item_linked_to_booking_record ?fulfillment_item - fulfillment_item ?booking_record - booking_record)
    (booking_process_documentation_attached ?booking_process - booking_process)
    (booking_process_provider_confirmation_ready ?booking_process - booking_process)
    (booking_process_integrity_checked ?booking_process - booking_process)
    (promotion_attached_to_booking_process ?booking_process - booking_process)
    (promotion_verified_for_booking_process ?booking_process - booking_process)
    (approval_required_for_booking_process ?booking_process - booking_process)
    (booking_process_internal_finalization_completed ?booking_process - booking_process)
    (terms_document_available ?terms_document - terms_document)
    (booking_process_bound_to_terms_document ?booking_process - booking_process ?terms_document - terms_document)
    (terms_acknowledged_on_booking_process ?booking_process - booking_process)
    (terms_applied_to_booking_process ?booking_process - booking_process)
    (settlement_account_confirmed_for_booking_process ?booking_process - booking_process)
    (promotion_available ?promotion_rate_plan - promotion_or_rate_plan)
    (booking_process_has_promotion ?booking_process - booking_process ?promotion_rate_plan - promotion_or_rate_plan)
    (approval_token_available ?approval_token - approval_token)
    (booking_process_bound_to_approval_token ?booking_process - booking_process ?approval_token - approval_token)
    (payment_method_token_available ?payment_method_token - payment_method_token)
    (booking_process_bound_to_payment_method_token ?booking_process - booking_process ?payment_method_token - payment_method_token)
    (settlement_account_available ?settlement_account - settlement_account)
    (booking_process_bound_to_settlement_account ?booking_process - booking_process ?settlement_account - settlement_account)
    (payment_instrument_available ?payment_instrument - payment_instrument)
    (reservation_bound_to_payment_instrument ?reservation_option - reservation_option ?payment_instrument - payment_instrument)
    (supplier_unit_ready ?supplier_res_unit - supplier_reservation_unit)
    (channel_unit_ready ?channel_res_unit - channel_reservation_unit)
    (booking_process_persisted ?booking_process - booking_process)
  )
  (:action create_reservation_option
    :parameters (?reservation_option - reservation_option)
    :precondition
      (and
        (not
          (reservation_option_selected ?reservation_option)
        )
        (not
          (reservation_committed ?reservation_option)
        )
      )
    :effect (reservation_option_selected ?reservation_option)
  )
  (:action attach_payment_provider_to_reservation_option
    :parameters (?reservation_option - reservation_option ?payment_provider - payment_provider)
    :precondition
      (and
        (reservation_option_selected ?reservation_option)
        (not
          (payment_provider_attached ?reservation_option)
        )
        (payment_provider_available ?payment_provider)
      )
    :effect
      (and
        (payment_provider_attached ?reservation_option)
        (reservation_bound_to_payment_provider ?reservation_option ?payment_provider)
        (not
          (payment_provider_available ?payment_provider)
        )
      )
  )
  (:action associate_customer_with_reservation_option
    :parameters (?reservation_option - reservation_option ?customer - customer)
    :precondition
      (and
        (reservation_option_selected ?reservation_option)
        (payment_provider_attached ?reservation_option)
        (customer_available ?customer)
      )
    :effect
      (and
        (reservation_linked_to_customer ?reservation_option ?customer)
        (not
          (customer_available ?customer)
        )
      )
  )
  (:action confirm_reservation_option
    :parameters (?reservation_option - reservation_option ?customer - customer)
    :precondition
      (and
        (reservation_option_selected ?reservation_option)
        (payment_provider_attached ?reservation_option)
        (reservation_linked_to_customer ?reservation_option ?customer)
        (not
          (reservation_confirmed ?reservation_option)
        )
      )
    :effect (reservation_confirmed ?reservation_option)
  )
  (:action release_customer_from_reservation_option
    :parameters (?reservation_option - reservation_option ?customer - customer)
    :precondition
      (and
        (reservation_linked_to_customer ?reservation_option ?customer)
      )
    :effect
      (and
        (customer_available ?customer)
        (not
          (reservation_linked_to_customer ?reservation_option ?customer)
        )
      )
  )
  (:action attach_booking_agent_to_reservation
    :parameters (?reservation_option - reservation_option ?booking_agent - booking_agent)
    :precondition
      (and
        (reservation_confirmed ?reservation_option)
        (booking_agent_available ?booking_agent)
      )
    :effect
      (and
        (reservation_assigned_to_agent ?reservation_option ?booking_agent)
        (not
          (booking_agent_available ?booking_agent)
        )
      )
  )
  (:action detach_booking_agent_from_reservation
    :parameters (?reservation_option - reservation_option ?booking_agent - booking_agent)
    :precondition
      (and
        (reservation_assigned_to_agent ?reservation_option ?booking_agent)
      )
    :effect
      (and
        (booking_agent_available ?booking_agent)
        (not
          (reservation_assigned_to_agent ?reservation_option ?booking_agent)
        )
      )
  )
  (:action bind_payment_method_token_to_booking_process
    :parameters (?booking_process - booking_process ?payment_method_token - payment_method_token)
    :precondition
      (and
        (reservation_confirmed ?booking_process)
        (payment_method_token_available ?payment_method_token)
      )
    :effect
      (and
        (booking_process_bound_to_payment_method_token ?booking_process ?payment_method_token)
        (not
          (payment_method_token_available ?payment_method_token)
        )
      )
  )
  (:action unbind_payment_method_token_from_booking_process
    :parameters (?booking_process - booking_process ?payment_method_token - payment_method_token)
    :precondition
      (and
        (booking_process_bound_to_payment_method_token ?booking_process ?payment_method_token)
      )
    :effect
      (and
        (payment_method_token_available ?payment_method_token)
        (not
          (booking_process_bound_to_payment_method_token ?booking_process ?payment_method_token)
        )
      )
  )
  (:action bind_settlement_account_to_booking_process
    :parameters (?booking_process - booking_process ?settlement_account - settlement_account)
    :precondition
      (and
        (reservation_confirmed ?booking_process)
        (settlement_account_available ?settlement_account)
      )
    :effect
      (and
        (booking_process_bound_to_settlement_account ?booking_process ?settlement_account)
        (not
          (settlement_account_available ?settlement_account)
        )
      )
  )
  (:action unbind_settlement_account_from_booking_process
    :parameters (?booking_process - booking_process ?settlement_account - settlement_account)
    :precondition
      (and
        (booking_process_bound_to_settlement_account ?booking_process ?settlement_account)
      )
    :effect
      (and
        (settlement_account_available ?settlement_account)
        (not
          (booking_process_bound_to_settlement_account ?booking_process ?settlement_account)
        )
      )
  )
  (:action signal_supplier_channel_ready
    :parameters (?supplier_res_unit - supplier_reservation_unit ?supplier_channel - supplier_channel ?customer - customer)
    :precondition
      (and
        (reservation_confirmed ?supplier_res_unit)
        (reservation_linked_to_customer ?supplier_res_unit ?customer)
        (supplier_unit_mapped_to_supplier_channel ?supplier_res_unit ?supplier_channel)
        (not
          (supplier_channel_ready ?supplier_channel)
        )
        (not
          (supplier_channel_price_applied ?supplier_channel)
        )
      )
    :effect (supplier_channel_ready ?supplier_channel)
  )
  (:action lock_supplier_inventory
    :parameters (?supplier_res_unit - supplier_reservation_unit ?supplier_channel - supplier_channel ?booking_agent - booking_agent)
    :precondition
      (and
        (reservation_confirmed ?supplier_res_unit)
        (reservation_assigned_to_agent ?supplier_res_unit ?booking_agent)
        (supplier_unit_mapped_to_supplier_channel ?supplier_res_unit ?supplier_channel)
        (supplier_channel_ready ?supplier_channel)
        (not
          (supplier_unit_ready ?supplier_res_unit)
        )
      )
    :effect
      (and
        (supplier_unit_ready ?supplier_res_unit)
        (supplier_unit_inventory_locked ?supplier_res_unit)
      )
  )
  (:action apply_price_component_to_supplier_unit
    :parameters (?supplier_res_unit - supplier_reservation_unit ?supplier_channel - supplier_channel ?price_component - price_component)
    :precondition
      (and
        (reservation_confirmed ?supplier_res_unit)
        (supplier_unit_mapped_to_supplier_channel ?supplier_res_unit ?supplier_channel)
        (price_component_available ?price_component)
        (not
          (supplier_unit_ready ?supplier_res_unit)
        )
      )
    :effect
      (and
        (supplier_channel_price_applied ?supplier_channel)
        (supplier_unit_ready ?supplier_res_unit)
        (supplier_unit_price_applied ?supplier_res_unit ?price_component)
        (not
          (price_component_available ?price_component)
        )
      )
  )
  (:action finalize_supplier_price_binding
    :parameters (?supplier_res_unit - supplier_reservation_unit ?supplier_channel - supplier_channel ?customer - customer ?price_component - price_component)
    :precondition
      (and
        (reservation_confirmed ?supplier_res_unit)
        (reservation_linked_to_customer ?supplier_res_unit ?customer)
        (supplier_unit_mapped_to_supplier_channel ?supplier_res_unit ?supplier_channel)
        (supplier_channel_price_applied ?supplier_channel)
        (supplier_unit_price_applied ?supplier_res_unit ?price_component)
        (not
          (supplier_unit_inventory_locked ?supplier_res_unit)
        )
      )
    :effect
      (and
        (supplier_channel_ready ?supplier_channel)
        (supplier_unit_inventory_locked ?supplier_res_unit)
        (price_component_available ?price_component)
        (not
          (supplier_unit_price_applied ?supplier_res_unit ?price_component)
        )
      )
  )
  (:action signal_distribution_channel_ready
    :parameters (?channel_res_unit - channel_reservation_unit ?distribution_channel - distribution_channel ?customer - customer)
    :precondition
      (and
        (reservation_confirmed ?channel_res_unit)
        (reservation_linked_to_customer ?channel_res_unit ?customer)
        (channel_unit_mapped_to_distribution_channel ?channel_res_unit ?distribution_channel)
        (not
          (distribution_channel_ready ?distribution_channel)
        )
        (not
          (distribution_channel_price_applied ?distribution_channel)
        )
      )
    :effect (distribution_channel_ready ?distribution_channel)
  )
  (:action lock_distribution_channel_inventory
    :parameters (?channel_res_unit - channel_reservation_unit ?distribution_channel - distribution_channel ?booking_agent - booking_agent)
    :precondition
      (and
        (reservation_confirmed ?channel_res_unit)
        (reservation_assigned_to_agent ?channel_res_unit ?booking_agent)
        (channel_unit_mapped_to_distribution_channel ?channel_res_unit ?distribution_channel)
        (distribution_channel_ready ?distribution_channel)
        (not
          (channel_unit_ready ?channel_res_unit)
        )
      )
    :effect
      (and
        (channel_unit_ready ?channel_res_unit)
        (channel_unit_inventory_locked ?channel_res_unit)
      )
  )
  (:action apply_price_component_to_channel_unit
    :parameters (?channel_res_unit - channel_reservation_unit ?distribution_channel - distribution_channel ?price_component - price_component)
    :precondition
      (and
        (reservation_confirmed ?channel_res_unit)
        (channel_unit_mapped_to_distribution_channel ?channel_res_unit ?distribution_channel)
        (price_component_available ?price_component)
        (not
          (channel_unit_ready ?channel_res_unit)
        )
      )
    :effect
      (and
        (distribution_channel_price_applied ?distribution_channel)
        (channel_unit_ready ?channel_res_unit)
        (channel_unit_price_applied ?channel_res_unit ?price_component)
        (not
          (price_component_available ?price_component)
        )
      )
  )
  (:action finalize_channel_price_binding
    :parameters (?channel_res_unit - channel_reservation_unit ?distribution_channel - distribution_channel ?customer - customer ?price_component - price_component)
    :precondition
      (and
        (reservation_confirmed ?channel_res_unit)
        (reservation_linked_to_customer ?channel_res_unit ?customer)
        (channel_unit_mapped_to_distribution_channel ?channel_res_unit ?distribution_channel)
        (distribution_channel_price_applied ?distribution_channel)
        (channel_unit_price_applied ?channel_res_unit ?price_component)
        (not
          (channel_unit_inventory_locked ?channel_res_unit)
        )
      )
    :effect
      (and
        (distribution_channel_ready ?distribution_channel)
        (channel_unit_inventory_locked ?channel_res_unit)
        (price_component_available ?price_component)
        (not
          (channel_unit_price_applied ?channel_res_unit ?price_component)
        )
      )
  )
  (:action assemble_booking_record_candidate
    :parameters (?supplier_res_unit - supplier_reservation_unit ?channel_res_unit - channel_reservation_unit ?supplier_channel - supplier_channel ?distribution_channel - distribution_channel ?booking_record - booking_record)
    :precondition
      (and
        (supplier_unit_ready ?supplier_res_unit)
        (channel_unit_ready ?channel_res_unit)
        (supplier_unit_mapped_to_supplier_channel ?supplier_res_unit ?supplier_channel)
        (channel_unit_mapped_to_distribution_channel ?channel_res_unit ?distribution_channel)
        (supplier_channel_ready ?supplier_channel)
        (distribution_channel_ready ?distribution_channel)
        (supplier_unit_inventory_locked ?supplier_res_unit)
        (channel_unit_inventory_locked ?channel_res_unit)
        (booking_record_draft ?booking_record)
      )
    :effect
      (and
        (booking_record_initialized ?booking_record)
        (booking_record_linked_to_supplier_channel ?booking_record ?supplier_channel)
        (booking_record_linked_to_distribution_channel ?booking_record ?distribution_channel)
        (not
          (booking_record_draft ?booking_record)
        )
      )
  )
  (:action assemble_booking_record_with_supplier_price
    :parameters (?supplier_res_unit - supplier_reservation_unit ?channel_res_unit - channel_reservation_unit ?supplier_channel - supplier_channel ?distribution_channel - distribution_channel ?booking_record - booking_record)
    :precondition
      (and
        (supplier_unit_ready ?supplier_res_unit)
        (channel_unit_ready ?channel_res_unit)
        (supplier_unit_mapped_to_supplier_channel ?supplier_res_unit ?supplier_channel)
        (channel_unit_mapped_to_distribution_channel ?channel_res_unit ?distribution_channel)
        (supplier_channel_price_applied ?supplier_channel)
        (distribution_channel_ready ?distribution_channel)
        (not
          (supplier_unit_inventory_locked ?supplier_res_unit)
        )
        (channel_unit_inventory_locked ?channel_res_unit)
        (booking_record_draft ?booking_record)
      )
    :effect
      (and
        (booking_record_initialized ?booking_record)
        (booking_record_linked_to_supplier_channel ?booking_record ?supplier_channel)
        (booking_record_linked_to_distribution_channel ?booking_record ?distribution_channel)
        (booking_record_supplier_confirmation_flag ?booking_record)
        (not
          (booking_record_draft ?booking_record)
        )
      )
  )
  (:action assemble_booking_record_with_channel_price
    :parameters (?supplier_res_unit - supplier_reservation_unit ?channel_res_unit - channel_reservation_unit ?supplier_channel - supplier_channel ?distribution_channel - distribution_channel ?booking_record - booking_record)
    :precondition
      (and
        (supplier_unit_ready ?supplier_res_unit)
        (channel_unit_ready ?channel_res_unit)
        (supplier_unit_mapped_to_supplier_channel ?supplier_res_unit ?supplier_channel)
        (channel_unit_mapped_to_distribution_channel ?channel_res_unit ?distribution_channel)
        (supplier_channel_ready ?supplier_channel)
        (distribution_channel_price_applied ?distribution_channel)
        (supplier_unit_inventory_locked ?supplier_res_unit)
        (not
          (channel_unit_inventory_locked ?channel_res_unit)
        )
        (booking_record_draft ?booking_record)
      )
    :effect
      (and
        (booking_record_initialized ?booking_record)
        (booking_record_linked_to_supplier_channel ?booking_record ?supplier_channel)
        (booking_record_linked_to_distribution_channel ?booking_record ?distribution_channel)
        (booking_record_distribution_confirmation_flag ?booking_record)
        (not
          (booking_record_draft ?booking_record)
        )
      )
  )
  (:action assemble_booking_record_with_supplier_and_channel_prices
    :parameters (?supplier_res_unit - supplier_reservation_unit ?channel_res_unit - channel_reservation_unit ?supplier_channel - supplier_channel ?distribution_channel - distribution_channel ?booking_record - booking_record)
    :precondition
      (and
        (supplier_unit_ready ?supplier_res_unit)
        (channel_unit_ready ?channel_res_unit)
        (supplier_unit_mapped_to_supplier_channel ?supplier_res_unit ?supplier_channel)
        (channel_unit_mapped_to_distribution_channel ?channel_res_unit ?distribution_channel)
        (supplier_channel_price_applied ?supplier_channel)
        (distribution_channel_price_applied ?distribution_channel)
        (not
          (supplier_unit_inventory_locked ?supplier_res_unit)
        )
        (not
          (channel_unit_inventory_locked ?channel_res_unit)
        )
        (booking_record_draft ?booking_record)
      )
    :effect
      (and
        (booking_record_initialized ?booking_record)
        (booking_record_linked_to_supplier_channel ?booking_record ?supplier_channel)
        (booking_record_linked_to_distribution_channel ?booking_record ?distribution_channel)
        (booking_record_supplier_confirmation_flag ?booking_record)
        (booking_record_distribution_confirmation_flag ?booking_record)
        (not
          (booking_record_draft ?booking_record)
        )
      )
  )
  (:action mark_booking_record_ready_for_fulfillment_binding
    :parameters (?booking_record - booking_record ?supplier_res_unit - supplier_reservation_unit ?customer - customer)
    :precondition
      (and
        (booking_record_initialized ?booking_record)
        (supplier_unit_ready ?supplier_res_unit)
        (reservation_linked_to_customer ?supplier_res_unit ?customer)
        (not
          (booking_record_ready_for_fulfillment_binding ?booking_record)
        )
      )
    :effect (booking_record_ready_for_fulfillment_binding ?booking_record)
  )
  (:action bind_fulfillment_item_documents_to_booking_record
    :parameters (?booking_process - booking_process ?fulfillment_item - fulfillment_item ?booking_record - booking_record)
    :precondition
      (and
        (reservation_confirmed ?booking_process)
        (booking_process_linked_to_booking_record ?booking_process ?booking_record)
        (booking_process_has_fulfillment_item ?booking_process ?fulfillment_item)
        (fulfillment_item_available ?fulfillment_item)
        (booking_record_initialized ?booking_record)
        (booking_record_ready_for_fulfillment_binding ?booking_record)
        (not
          (fulfillment_item_bound ?fulfillment_item)
        )
      )
    :effect
      (and
        (fulfillment_item_bound ?fulfillment_item)
        (fulfillment_item_linked_to_booking_record ?fulfillment_item ?booking_record)
        (not
          (fulfillment_item_available ?fulfillment_item)
        )
      )
  )
  (:action confirm_fulfillment_item_documentation
    :parameters (?booking_process - booking_process ?fulfillment_item - fulfillment_item ?booking_record - booking_record ?customer - customer)
    :precondition
      (and
        (reservation_confirmed ?booking_process)
        (booking_process_has_fulfillment_item ?booking_process ?fulfillment_item)
        (fulfillment_item_bound ?fulfillment_item)
        (fulfillment_item_linked_to_booking_record ?fulfillment_item ?booking_record)
        (reservation_linked_to_customer ?booking_process ?customer)
        (not
          (booking_record_supplier_confirmation_flag ?booking_record)
        )
        (not
          (booking_process_documentation_attached ?booking_process)
        )
      )
    :effect (booking_process_documentation_attached ?booking_process)
  )
  (:action attach_promotion_to_booking_process
    :parameters (?booking_process - booking_process ?promotion_rate_plan - promotion_or_rate_plan)
    :precondition
      (and
        (reservation_confirmed ?booking_process)
        (promotion_available ?promotion_rate_plan)
        (not
          (promotion_attached_to_booking_process ?booking_process)
        )
      )
    :effect
      (and
        (promotion_attached_to_booking_process ?booking_process)
        (booking_process_has_promotion ?booking_process ?promotion_rate_plan)
        (not
          (promotion_available ?promotion_rate_plan)
        )
      )
  )
  (:action attach_and_verify_promotion_for_booking
    :parameters (?booking_process - booking_process ?fulfillment_item - fulfillment_item ?booking_record - booking_record ?customer - customer ?promotion_rate_plan - promotion_or_rate_plan)
    :precondition
      (and
        (reservation_confirmed ?booking_process)
        (booking_process_has_fulfillment_item ?booking_process ?fulfillment_item)
        (fulfillment_item_bound ?fulfillment_item)
        (fulfillment_item_linked_to_booking_record ?fulfillment_item ?booking_record)
        (reservation_linked_to_customer ?booking_process ?customer)
        (booking_record_supplier_confirmation_flag ?booking_record)
        (promotion_attached_to_booking_process ?booking_process)
        (booking_process_has_promotion ?booking_process ?promotion_rate_plan)
        (not
          (booking_process_documentation_attached ?booking_process)
        )
      )
    :effect
      (and
        (booking_process_documentation_attached ?booking_process)
        (promotion_verified_for_booking_process ?booking_process)
      )
  )
  (:action attach_payment_method_token_and_prepare_provider_confirmation
    :parameters (?booking_process - booking_process ?payment_method_token - payment_method_token ?booking_agent - booking_agent ?fulfillment_item - fulfillment_item ?booking_record - booking_record)
    :precondition
      (and
        (booking_process_documentation_attached ?booking_process)
        (booking_process_bound_to_payment_method_token ?booking_process ?payment_method_token)
        (reservation_assigned_to_agent ?booking_process ?booking_agent)
        (booking_process_has_fulfillment_item ?booking_process ?fulfillment_item)
        (fulfillment_item_linked_to_booking_record ?fulfillment_item ?booking_record)
        (not
          (booking_record_distribution_confirmation_flag ?booking_record)
        )
        (not
          (booking_process_provider_confirmation_ready ?booking_process)
        )
      )
    :effect (booking_process_provider_confirmation_ready ?booking_process)
  )
  (:action attach_payment_method_token_and_process
    :parameters (?booking_process - booking_process ?payment_method_token - payment_method_token ?booking_agent - booking_agent ?fulfillment_item - fulfillment_item ?booking_record - booking_record)
    :precondition
      (and
        (booking_process_documentation_attached ?booking_process)
        (booking_process_bound_to_payment_method_token ?booking_process ?payment_method_token)
        (reservation_assigned_to_agent ?booking_process ?booking_agent)
        (booking_process_has_fulfillment_item ?booking_process ?fulfillment_item)
        (fulfillment_item_linked_to_booking_record ?fulfillment_item ?booking_record)
        (booking_record_distribution_confirmation_flag ?booking_record)
        (not
          (booking_process_provider_confirmation_ready ?booking_process)
        )
      )
    :effect (booking_process_provider_confirmation_ready ?booking_process)
  )
  (:action prepare_booking_process_for_final_integrity_check
    :parameters (?booking_process - booking_process ?settlement_account - settlement_account ?fulfillment_item - fulfillment_item ?booking_record - booking_record)
    :precondition
      (and
        (booking_process_provider_confirmation_ready ?booking_process)
        (booking_process_bound_to_settlement_account ?booking_process ?settlement_account)
        (booking_process_has_fulfillment_item ?booking_process ?fulfillment_item)
        (fulfillment_item_linked_to_booking_record ?fulfillment_item ?booking_record)
        (not
          (booking_record_supplier_confirmation_flag ?booking_record)
        )
        (not
          (booking_record_distribution_confirmation_flag ?booking_record)
        )
        (not
          (booking_process_integrity_checked ?booking_process)
        )
      )
    :effect (booking_process_integrity_checked ?booking_process)
  )
  (:action prepare_booking_process_and_require_approval
    :parameters (?booking_process - booking_process ?settlement_account - settlement_account ?fulfillment_item - fulfillment_item ?booking_record - booking_record)
    :precondition
      (and
        (booking_process_provider_confirmation_ready ?booking_process)
        (booking_process_bound_to_settlement_account ?booking_process ?settlement_account)
        (booking_process_has_fulfillment_item ?booking_process ?fulfillment_item)
        (fulfillment_item_linked_to_booking_record ?fulfillment_item ?booking_record)
        (booking_record_supplier_confirmation_flag ?booking_record)
        (not
          (booking_record_distribution_confirmation_flag ?booking_record)
        )
        (not
          (booking_process_integrity_checked ?booking_process)
        )
      )
    :effect
      (and
        (booking_process_integrity_checked ?booking_process)
        (approval_required_for_booking_process ?booking_process)
      )
  )
  (:action prepare_booking_process_with_alternate_confirmations
    :parameters (?booking_process - booking_process ?settlement_account - settlement_account ?fulfillment_item - fulfillment_item ?booking_record - booking_record)
    :precondition
      (and
        (booking_process_provider_confirmation_ready ?booking_process)
        (booking_process_bound_to_settlement_account ?booking_process ?settlement_account)
        (booking_process_has_fulfillment_item ?booking_process ?fulfillment_item)
        (fulfillment_item_linked_to_booking_record ?fulfillment_item ?booking_record)
        (not
          (booking_record_supplier_confirmation_flag ?booking_record)
        )
        (booking_record_distribution_confirmation_flag ?booking_record)
        (not
          (booking_process_integrity_checked ?booking_process)
        )
      )
    :effect
      (and
        (booking_process_integrity_checked ?booking_process)
        (approval_required_for_booking_process ?booking_process)
      )
  )
  (:action prepare_booking_process_complete_confirmations
    :parameters (?booking_process - booking_process ?settlement_account - settlement_account ?fulfillment_item - fulfillment_item ?booking_record - booking_record)
    :precondition
      (and
        (booking_process_provider_confirmation_ready ?booking_process)
        (booking_process_bound_to_settlement_account ?booking_process ?settlement_account)
        (booking_process_has_fulfillment_item ?booking_process ?fulfillment_item)
        (fulfillment_item_linked_to_booking_record ?fulfillment_item ?booking_record)
        (booking_record_supplier_confirmation_flag ?booking_record)
        (booking_record_distribution_confirmation_flag ?booking_record)
        (not
          (booking_process_integrity_checked ?booking_process)
        )
      )
    :effect
      (and
        (booking_process_integrity_checked ?booking_process)
        (approval_required_for_booking_process ?booking_process)
      )
  )
  (:action finalize_booking_without_approval
    :parameters (?booking_process - booking_process)
    :precondition
      (and
        (booking_process_integrity_checked ?booking_process)
        (not
          (approval_required_for_booking_process ?booking_process)
        )
        (not
          (booking_process_persisted ?booking_process)
        )
      )
    :effect
      (and
        (booking_process_persisted ?booking_process)
        (eligible_for_commitment ?booking_process)
      )
  )
  (:action attach_approval_token_to_booking_process
    :parameters (?booking_process - booking_process ?approval_token - approval_token)
    :precondition
      (and
        (booking_process_integrity_checked ?booking_process)
        (approval_required_for_booking_process ?booking_process)
        (approval_token_available ?approval_token)
      )
    :effect
      (and
        (booking_process_bound_to_approval_token ?booking_process ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action run_integrity_checks_and_mark_finalization
    :parameters (?booking_process - booking_process ?supplier_res_unit - supplier_reservation_unit ?channel_res_unit - channel_reservation_unit ?customer - customer ?approval_token - approval_token)
    :precondition
      (and
        (booking_process_integrity_checked ?booking_process)
        (approval_required_for_booking_process ?booking_process)
        (booking_process_bound_to_approval_token ?booking_process ?approval_token)
        (booking_process_includes_supplier_unit ?booking_process ?supplier_res_unit)
        (booking_process_includes_channel_unit ?booking_process ?channel_res_unit)
        (supplier_unit_inventory_locked ?supplier_res_unit)
        (channel_unit_inventory_locked ?channel_res_unit)
        (reservation_linked_to_customer ?booking_process ?customer)
        (not
          (booking_process_internal_finalization_completed ?booking_process)
        )
      )
    :effect (booking_process_internal_finalization_completed ?booking_process)
  )
  (:action finalize_booking_after_internal_checks
    :parameters (?booking_process - booking_process)
    :precondition
      (and
        (booking_process_integrity_checked ?booking_process)
        (booking_process_internal_finalization_completed ?booking_process)
        (not
          (booking_process_persisted ?booking_process)
        )
      )
    :effect
      (and
        (booking_process_persisted ?booking_process)
        (eligible_for_commitment ?booking_process)
      )
  )
  (:action attach_terms_document_acknowledgement_to_booking
    :parameters (?booking_process - booking_process ?terms_document - terms_document ?customer - customer)
    :precondition
      (and
        (reservation_confirmed ?booking_process)
        (reservation_linked_to_customer ?booking_process ?customer)
        (terms_document_available ?terms_document)
        (booking_process_bound_to_terms_document ?booking_process ?terms_document)
        (not
          (terms_acknowledged_on_booking_process ?booking_process)
        )
      )
    :effect
      (and
        (terms_acknowledged_on_booking_process ?booking_process)
        (not
          (terms_document_available ?terms_document)
        )
      )
  )
  (:action apply_terms_to_booking_process
    :parameters (?booking_process - booking_process ?booking_agent - booking_agent)
    :precondition
      (and
        (terms_acknowledged_on_booking_process ?booking_process)
        (reservation_assigned_to_agent ?booking_process ?booking_agent)
        (not
          (terms_applied_to_booking_process ?booking_process)
        )
      )
    :effect (terms_applied_to_booking_process ?booking_process)
  )
  (:action confirm_settlement_account_for_booking
    :parameters (?booking_process - booking_process ?settlement_account - settlement_account)
    :precondition
      (and
        (terms_applied_to_booking_process ?booking_process)
        (booking_process_bound_to_settlement_account ?booking_process ?settlement_account)
        (not
          (settlement_account_confirmed_for_booking_process ?booking_process)
        )
      )
    :effect (settlement_account_confirmed_for_booking_process ?booking_process)
  )
  (:action finalize_booking_after_settlement_confirmation
    :parameters (?booking_process - booking_process)
    :precondition
      (and
        (settlement_account_confirmed_for_booking_process ?booking_process)
        (not
          (booking_process_persisted ?booking_process)
        )
      )
    :effect
      (and
        (booking_process_persisted ?booking_process)
        (eligible_for_commitment ?booking_process)
      )
  )
  (:action capture_payment_for_supplier_unit
    :parameters (?supplier_res_unit - supplier_reservation_unit ?booking_record - booking_record)
    :precondition
      (and
        (supplier_unit_ready ?supplier_res_unit)
        (supplier_unit_inventory_locked ?supplier_res_unit)
        (booking_record_initialized ?booking_record)
        (booking_record_ready_for_fulfillment_binding ?booking_record)
        (not
          (eligible_for_commitment ?supplier_res_unit)
        )
      )
    :effect (eligible_for_commitment ?supplier_res_unit)
  )
  (:action capture_payment_for_channel_unit
    :parameters (?channel_res_unit - channel_reservation_unit ?booking_record - booking_record)
    :precondition
      (and
        (channel_unit_ready ?channel_res_unit)
        (channel_unit_inventory_locked ?channel_res_unit)
        (booking_record_initialized ?booking_record)
        (booking_record_ready_for_fulfillment_binding ?booking_record)
        (not
          (eligible_for_commitment ?channel_res_unit)
        )
      )
    :effect (eligible_for_commitment ?channel_res_unit)
  )
  (:action authorize_reservation_payment_with_instrument
    :parameters (?reservation_option - reservation_option ?payment_instrument - payment_instrument ?customer - customer)
    :precondition
      (and
        (eligible_for_commitment ?reservation_option)
        (reservation_linked_to_customer ?reservation_option ?customer)
        (payment_instrument_available ?payment_instrument)
        (not
          (reservation_payment_authorized ?reservation_option)
        )
      )
    :effect
      (and
        (reservation_payment_authorized ?reservation_option)
        (reservation_bound_to_payment_instrument ?reservation_option ?payment_instrument)
        (not
          (payment_instrument_available ?payment_instrument)
        )
      )
  )
  (:action finalize_supplier_unit_commitment_with_payment_provider
    :parameters (?supplier_res_unit - supplier_reservation_unit ?payment_provider - payment_provider ?payment_instrument - payment_instrument)
    :precondition
      (and
        (reservation_payment_authorized ?supplier_res_unit)
        (reservation_bound_to_payment_provider ?supplier_res_unit ?payment_provider)
        (reservation_bound_to_payment_instrument ?supplier_res_unit ?payment_instrument)
        (not
          (reservation_committed ?supplier_res_unit)
        )
      )
    :effect
      (and
        (reservation_committed ?supplier_res_unit)
        (payment_provider_available ?payment_provider)
        (payment_instrument_available ?payment_instrument)
      )
  )
  (:action finalize_channel_unit_commitment_with_payment_provider
    :parameters (?channel_res_unit - channel_reservation_unit ?payment_provider - payment_provider ?payment_instrument - payment_instrument)
    :precondition
      (and
        (reservation_payment_authorized ?channel_res_unit)
        (reservation_bound_to_payment_provider ?channel_res_unit ?payment_provider)
        (reservation_bound_to_payment_instrument ?channel_res_unit ?payment_instrument)
        (not
          (reservation_committed ?channel_res_unit)
        )
      )
    :effect
      (and
        (reservation_committed ?channel_res_unit)
        (payment_provider_available ?payment_provider)
        (payment_instrument_available ?payment_instrument)
      )
  )
  (:action finalize_booking_process_commitment_with_payment_provider
    :parameters (?booking_process - booking_process ?payment_provider - payment_provider ?payment_instrument - payment_instrument)
    :precondition
      (and
        (reservation_payment_authorized ?booking_process)
        (reservation_bound_to_payment_provider ?booking_process ?payment_provider)
        (reservation_bound_to_payment_instrument ?booking_process ?payment_instrument)
        (not
          (reservation_committed ?booking_process)
        )
      )
    :effect
      (and
        (reservation_committed ?booking_process)
        (payment_provider_available ?payment_provider)
        (payment_instrument_available ?payment_instrument)
      )
  )
)

(define (domain tourism_waitlist_conversion_handling)
  (:requirements :strips :typing :negative-preconditions)
  (:types component_artifact - object issuable_artifact - object supplier_conversion_entity - object booking_entity - object booking_request - booking_entity waitlist_slot - component_artifact passenger_profile - component_artifact seat_proposal - component_artifact authorization_code - component_artifact payment_method - component_artifact confirmation_token - component_artifact ancillary_service - component_artifact supplier_reference - component_artifact fare_component_token - issuable_artifact ticket - issuable_artifact loyalty_voucher - issuable_artifact supplier_inventory_a - supplier_conversion_entity supplier_inventory_b - supplier_conversion_entity conversion_record - supplier_conversion_entity booking_component_group - booking_request consolidated_record_group - booking_request service_component_a - booking_component_group service_component_b - booking_component_group consolidated_booking_record - consolidated_record_group)
  (:predicates
    (booking_request_provisional ?booking_request - booking_request)
    (conversion_eligible_entity ?booking_request - booking_request)
    (waitlist_allocated ?booking_request - booking_request)
    (entity_confirmed ?booking_request - booking_request)
    (ready_for_finalization ?booking_request - booking_request)
    (conversion_committed_entity ?booking_request - booking_request)
    (waitlist_slot_available ?waitlist_slot - waitlist_slot)
    (assigned_waitlist_slot ?booking_request - booking_request ?waitlist_slot - waitlist_slot)
    (passenger_profile_available ?passenger_profile - passenger_profile)
    (assigned_passenger ?booking_request - booking_request ?passenger_profile - passenger_profile)
    (seat_proposal_available ?seat_proposal - seat_proposal)
    (assigned_seat_proposal ?booking_request - booking_request ?seat_proposal - seat_proposal)
    (fare_token_available ?fare_component_token - fare_component_token)
    (service_component_a_assigned_fare_token ?service_component_a - service_component_a ?fare_component_token - fare_component_token)
    (service_component_b_assigned_fare_token ?service_component_b - service_component_b ?fare_component_token - fare_component_token)
    (service_component_a_inventory_ref ?service_component_a - service_component_a ?supplier_inventory_a - supplier_inventory_a)
    (supplier_inventory_a_available ?supplier_inventory_a - supplier_inventory_a)
    (supplier_inventory_a_locked ?supplier_inventory_a - supplier_inventory_a)
    (service_component_a_readiness_confirmed ?service_component_a - service_component_a)
    (service_component_b_inventory_ref ?service_component_b - service_component_b ?supplier_inventory_b - supplier_inventory_b)
    (supplier_inventory_b_available ?supplier_inventory_b - supplier_inventory_b)
    (supplier_inventory_b_locked ?supplier_inventory_b - supplier_inventory_b)
    (service_component_b_readiness_confirmed ?service_component_b - service_component_b)
    (conversion_record_available ?conversion_record - conversion_record)
    (conversion_record_allocated ?conversion_record - conversion_record)
    (conversion_record_links_to_inventory_a ?conversion_record - conversion_record ?supplier_inventory_a - supplier_inventory_a)
    (conversion_record_links_to_inventory_b ?conversion_record - conversion_record ?supplier_inventory_b - supplier_inventory_b)
    (conversion_record_selects_supplier_a ?conversion_record - conversion_record)
    (conversion_record_selects_supplier_b ?conversion_record - conversion_record)
    (conversion_record_ticketing_ready ?conversion_record - conversion_record)
    (consolidated_includes_service_component_a ?consolidated_booking_record - consolidated_booking_record ?service_component_a - service_component_a)
    (consolidated_includes_service_component_b ?consolidated_booking_record - consolidated_booking_record ?service_component_b - service_component_b)
    (consolidated_includes_conversion_record ?consolidated_booking_record - consolidated_booking_record ?conversion_record - conversion_record)
    (ticket_available ?ticket - ticket)
    (consolidated_has_ticket ?consolidated_booking_record - consolidated_booking_record ?ticket - ticket)
    (ticket_issued ?ticket - ticket)
    (ticket_linked_to_conversion ?ticket - ticket ?conversion_record - conversion_record)
    (consolidated_ticketing_processed ?consolidated_booking_record - consolidated_booking_record)
    (consolidated_ready_for_supplier_reference ?consolidated_booking_record - consolidated_booking_record)
    (consolidated_supplier_reference_requested ?consolidated_booking_record - consolidated_booking_record)
    (authorization_attached_flag ?consolidated_booking_record - consolidated_booking_record)
    (authorization_finalized_on_consolidated ?consolidated_booking_record - consolidated_booking_record)
    (supplier_reference_confirmed_on_consolidated ?consolidated_booking_record - consolidated_booking_record)
    (consolidated_final_checks_passed ?consolidated_booking_record - consolidated_booking_record)
    (loyalty_voucher_available ?loyalty_voucher - loyalty_voucher)
    (consolidated_has_loyalty_voucher ?consolidated_booking_record - consolidated_booking_record ?loyalty_voucher - loyalty_voucher)
    (consolidated_loyalty_attached ?consolidated_booking_record - consolidated_booking_record)
    (consolidated_loyalty_authorized ?consolidated_booking_record - consolidated_booking_record)
    (consolidated_loyalty_finalized ?consolidated_booking_record - consolidated_booking_record)
    (authorization_code_available ?authorization_code - authorization_code)
    (consolidated_attached_authorization_code ?consolidated_booking_record - consolidated_booking_record ?authorization_code - authorization_code)
    (payment_method_available ?payment_method - payment_method)
    (consolidated_attached_payment_method ?consolidated_booking_record - consolidated_booking_record ?payment_method - payment_method)
    (ancillary_service_available ?ancillary_service - ancillary_service)
    (consolidated_attached_ancillary_service ?consolidated_booking_record - consolidated_booking_record ?ancillary_service - ancillary_service)
    (supplier_reference_available ?supplier_reference - supplier_reference)
    (consolidated_attached_supplier_reference ?consolidated_booking_record - consolidated_booking_record ?supplier_reference - supplier_reference)
    (confirmation_token_available ?confirmation_token - confirmation_token)
    (assigned_confirmation_token ?booking_request - booking_request ?confirmation_token - confirmation_token)
    (service_component_a_prepared ?service_component_a - service_component_a)
    (service_component_b_prepared ?service_component_b - service_component_b)
    (consolidated_confirmation_recorded ?consolidated_booking_record - consolidated_booking_record)
  )
  (:action create_provisional_booking_request
    :parameters (?booking_request - booking_request)
    :precondition
      (and
        (not
          (booking_request_provisional ?booking_request)
        )
        (not
          (entity_confirmed ?booking_request)
        )
      )
    :effect (booking_request_provisional ?booking_request)
  )
  (:action assign_waitlist_slot_to_booking_request
    :parameters (?booking_request - booking_request ?waitlist_slot - waitlist_slot)
    :precondition
      (and
        (booking_request_provisional ?booking_request)
        (not
          (waitlist_allocated ?booking_request)
        )
        (waitlist_slot_available ?waitlist_slot)
      )
    :effect
      (and
        (waitlist_allocated ?booking_request)
        (assigned_waitlist_slot ?booking_request ?waitlist_slot)
        (not
          (waitlist_slot_available ?waitlist_slot)
        )
      )
  )
  (:action link_passenger_profile_to_booking_request
    :parameters (?booking_request - booking_request ?passenger_profile - passenger_profile)
    :precondition
      (and
        (booking_request_provisional ?booking_request)
        (waitlist_allocated ?booking_request)
        (passenger_profile_available ?passenger_profile)
      )
    :effect
      (and
        (assigned_passenger ?booking_request ?passenger_profile)
        (not
          (passenger_profile_available ?passenger_profile)
        )
      )
  )
  (:action flag_booking_as_conversion_eligible
    :parameters (?booking_request - booking_request ?passenger_profile - passenger_profile)
    :precondition
      (and
        (booking_request_provisional ?booking_request)
        (waitlist_allocated ?booking_request)
        (assigned_passenger ?booking_request ?passenger_profile)
        (not
          (conversion_eligible_entity ?booking_request)
        )
      )
    :effect (conversion_eligible_entity ?booking_request)
  )
  (:action release_passenger_profile_from_booking_request
    :parameters (?booking_request - booking_request ?passenger_profile - passenger_profile)
    :precondition
      (and
        (assigned_passenger ?booking_request ?passenger_profile)
      )
    :effect
      (and
        (passenger_profile_available ?passenger_profile)
        (not
          (assigned_passenger ?booking_request ?passenger_profile)
        )
      )
  )
  (:action assign_seat_proposal_to_booking_request
    :parameters (?booking_request - booking_request ?seat_proposal - seat_proposal)
    :precondition
      (and
        (conversion_eligible_entity ?booking_request)
        (seat_proposal_available ?seat_proposal)
      )
    :effect
      (and
        (assigned_seat_proposal ?booking_request ?seat_proposal)
        (not
          (seat_proposal_available ?seat_proposal)
        )
      )
  )
  (:action release_seat_proposal_from_booking_request
    :parameters (?booking_request - booking_request ?seat_proposal - seat_proposal)
    :precondition
      (and
        (assigned_seat_proposal ?booking_request ?seat_proposal)
      )
    :effect
      (and
        (seat_proposal_available ?seat_proposal)
        (not
          (assigned_seat_proposal ?booking_request ?seat_proposal)
        )
      )
  )
  (:action attach_ancillary_service_to_consolidated_record
    :parameters (?consolidated_booking_record - consolidated_booking_record ?ancillary_service - ancillary_service)
    :precondition
      (and
        (conversion_eligible_entity ?consolidated_booking_record)
        (ancillary_service_available ?ancillary_service)
      )
    :effect
      (and
        (consolidated_attached_ancillary_service ?consolidated_booking_record ?ancillary_service)
        (not
          (ancillary_service_available ?ancillary_service)
        )
      )
  )
  (:action detach_ancillary_service_from_consolidated_record
    :parameters (?consolidated_booking_record - consolidated_booking_record ?ancillary_service - ancillary_service)
    :precondition
      (and
        (consolidated_attached_ancillary_service ?consolidated_booking_record ?ancillary_service)
      )
    :effect
      (and
        (ancillary_service_available ?ancillary_service)
        (not
          (consolidated_attached_ancillary_service ?consolidated_booking_record ?ancillary_service)
        )
      )
  )
  (:action attach_supplier_reference_to_consolidated_record
    :parameters (?consolidated_booking_record - consolidated_booking_record ?supplier_reference - supplier_reference)
    :precondition
      (and
        (conversion_eligible_entity ?consolidated_booking_record)
        (supplier_reference_available ?supplier_reference)
      )
    :effect
      (and
        (consolidated_attached_supplier_reference ?consolidated_booking_record ?supplier_reference)
        (not
          (supplier_reference_available ?supplier_reference)
        )
      )
  )
  (:action detach_supplier_reference_from_consolidated_record
    :parameters (?consolidated_booking_record - consolidated_booking_record ?supplier_reference - supplier_reference)
    :precondition
      (and
        (consolidated_attached_supplier_reference ?consolidated_booking_record ?supplier_reference)
      )
    :effect
      (and
        (supplier_reference_available ?supplier_reference)
        (not
          (consolidated_attached_supplier_reference ?consolidated_booking_record ?supplier_reference)
        )
      )
  )
  (:action mark_supplier_inventory_a_ready_for_component
    :parameters (?service_component_a - service_component_a ?supplier_inventory_a - supplier_inventory_a ?passenger_profile - passenger_profile)
    :precondition
      (and
        (conversion_eligible_entity ?service_component_a)
        (assigned_passenger ?service_component_a ?passenger_profile)
        (service_component_a_inventory_ref ?service_component_a ?supplier_inventory_a)
        (not
          (supplier_inventory_a_available ?supplier_inventory_a)
        )
        (not
          (supplier_inventory_a_locked ?supplier_inventory_a)
        )
      )
    :effect (supplier_inventory_a_available ?supplier_inventory_a)
  )
  (:action confirm_component_a_readiness_with_seat
    :parameters (?service_component_a - service_component_a ?supplier_inventory_a - supplier_inventory_a ?seat_proposal - seat_proposal)
    :precondition
      (and
        (conversion_eligible_entity ?service_component_a)
        (assigned_seat_proposal ?service_component_a ?seat_proposal)
        (service_component_a_inventory_ref ?service_component_a ?supplier_inventory_a)
        (supplier_inventory_a_available ?supplier_inventory_a)
        (not
          (service_component_a_prepared ?service_component_a)
        )
      )
    :effect
      (and
        (service_component_a_prepared ?service_component_a)
        (service_component_a_readiness_confirmed ?service_component_a)
      )
  )
  (:action attach_fare_token_and_lock_inventory_for_component_a
    :parameters (?service_component_a - service_component_a ?supplier_inventory_a - supplier_inventory_a ?fare_component_token - fare_component_token)
    :precondition
      (and
        (conversion_eligible_entity ?service_component_a)
        (service_component_a_inventory_ref ?service_component_a ?supplier_inventory_a)
        (fare_token_available ?fare_component_token)
        (not
          (service_component_a_prepared ?service_component_a)
        )
      )
    :effect
      (and
        (supplier_inventory_a_locked ?supplier_inventory_a)
        (service_component_a_prepared ?service_component_a)
        (service_component_a_assigned_fare_token ?service_component_a ?fare_component_token)
        (not
          (fare_token_available ?fare_component_token)
        )
      )
  )
  (:action complete_component_a_inventory_confirmation_and_release_fare_token
    :parameters (?service_component_a - service_component_a ?supplier_inventory_a - supplier_inventory_a ?passenger_profile - passenger_profile ?fare_component_token - fare_component_token)
    :precondition
      (and
        (conversion_eligible_entity ?service_component_a)
        (assigned_passenger ?service_component_a ?passenger_profile)
        (service_component_a_inventory_ref ?service_component_a ?supplier_inventory_a)
        (supplier_inventory_a_locked ?supplier_inventory_a)
        (service_component_a_assigned_fare_token ?service_component_a ?fare_component_token)
        (not
          (service_component_a_readiness_confirmed ?service_component_a)
        )
      )
    :effect
      (and
        (supplier_inventory_a_available ?supplier_inventory_a)
        (service_component_a_readiness_confirmed ?service_component_a)
        (fare_token_available ?fare_component_token)
        (not
          (service_component_a_assigned_fare_token ?service_component_a ?fare_component_token)
        )
      )
  )
  (:action mark_supplier_inventory_b_ready_for_component
    :parameters (?service_component_b - service_component_b ?supplier_inventory_b - supplier_inventory_b ?passenger_profile - passenger_profile)
    :precondition
      (and
        (conversion_eligible_entity ?service_component_b)
        (assigned_passenger ?service_component_b ?passenger_profile)
        (service_component_b_inventory_ref ?service_component_b ?supplier_inventory_b)
        (not
          (supplier_inventory_b_available ?supplier_inventory_b)
        )
        (not
          (supplier_inventory_b_locked ?supplier_inventory_b)
        )
      )
    :effect (supplier_inventory_b_available ?supplier_inventory_b)
  )
  (:action confirm_component_b_readiness_with_seat
    :parameters (?service_component_b - service_component_b ?supplier_inventory_b - supplier_inventory_b ?seat_proposal - seat_proposal)
    :precondition
      (and
        (conversion_eligible_entity ?service_component_b)
        (assigned_seat_proposal ?service_component_b ?seat_proposal)
        (service_component_b_inventory_ref ?service_component_b ?supplier_inventory_b)
        (supplier_inventory_b_available ?supplier_inventory_b)
        (not
          (service_component_b_prepared ?service_component_b)
        )
      )
    :effect
      (and
        (service_component_b_prepared ?service_component_b)
        (service_component_b_readiness_confirmed ?service_component_b)
      )
  )
  (:action attach_fare_token_and_lock_inventory_for_component_b
    :parameters (?service_component_b - service_component_b ?supplier_inventory_b - supplier_inventory_b ?fare_component_token - fare_component_token)
    :precondition
      (and
        (conversion_eligible_entity ?service_component_b)
        (service_component_b_inventory_ref ?service_component_b ?supplier_inventory_b)
        (fare_token_available ?fare_component_token)
        (not
          (service_component_b_prepared ?service_component_b)
        )
      )
    :effect
      (and
        (supplier_inventory_b_locked ?supplier_inventory_b)
        (service_component_b_prepared ?service_component_b)
        (service_component_b_assigned_fare_token ?service_component_b ?fare_component_token)
        (not
          (fare_token_available ?fare_component_token)
        )
      )
  )
  (:action complete_component_b_inventory_confirmation_and_release_fare_token
    :parameters (?service_component_b - service_component_b ?supplier_inventory_b - supplier_inventory_b ?passenger_profile - passenger_profile ?fare_component_token - fare_component_token)
    :precondition
      (and
        (conversion_eligible_entity ?service_component_b)
        (assigned_passenger ?service_component_b ?passenger_profile)
        (service_component_b_inventory_ref ?service_component_b ?supplier_inventory_b)
        (supplier_inventory_b_locked ?supplier_inventory_b)
        (service_component_b_assigned_fare_token ?service_component_b ?fare_component_token)
        (not
          (service_component_b_readiness_confirmed ?service_component_b)
        )
      )
    :effect
      (and
        (supplier_inventory_b_available ?supplier_inventory_b)
        (service_component_b_readiness_confirmed ?service_component_b)
        (fare_token_available ?fare_component_token)
        (not
          (service_component_b_assigned_fare_token ?service_component_b ?fare_component_token)
        )
      )
  )
  (:action create_conversion_record_for_components
    :parameters (?service_component_a - service_component_a ?service_component_b - service_component_b ?supplier_inventory_a - supplier_inventory_a ?supplier_inventory_b - supplier_inventory_b ?conversion_record - conversion_record)
    :precondition
      (and
        (service_component_a_prepared ?service_component_a)
        (service_component_b_prepared ?service_component_b)
        (service_component_a_inventory_ref ?service_component_a ?supplier_inventory_a)
        (service_component_b_inventory_ref ?service_component_b ?supplier_inventory_b)
        (supplier_inventory_a_available ?supplier_inventory_a)
        (supplier_inventory_b_available ?supplier_inventory_b)
        (service_component_a_readiness_confirmed ?service_component_a)
        (service_component_b_readiness_confirmed ?service_component_b)
        (conversion_record_available ?conversion_record)
      )
    :effect
      (and
        (conversion_record_allocated ?conversion_record)
        (conversion_record_links_to_inventory_a ?conversion_record ?supplier_inventory_a)
        (conversion_record_links_to_inventory_b ?conversion_record ?supplier_inventory_b)
        (not
          (conversion_record_available ?conversion_record)
        )
      )
  )
  (:action create_conversion_record_selecting_supplier_a_preference
    :parameters (?service_component_a - service_component_a ?service_component_b - service_component_b ?supplier_inventory_a - supplier_inventory_a ?supplier_inventory_b - supplier_inventory_b ?conversion_record - conversion_record)
    :precondition
      (and
        (service_component_a_prepared ?service_component_a)
        (service_component_b_prepared ?service_component_b)
        (service_component_a_inventory_ref ?service_component_a ?supplier_inventory_a)
        (service_component_b_inventory_ref ?service_component_b ?supplier_inventory_b)
        (supplier_inventory_a_locked ?supplier_inventory_a)
        (supplier_inventory_b_available ?supplier_inventory_b)
        (not
          (service_component_a_readiness_confirmed ?service_component_a)
        )
        (service_component_b_readiness_confirmed ?service_component_b)
        (conversion_record_available ?conversion_record)
      )
    :effect
      (and
        (conversion_record_allocated ?conversion_record)
        (conversion_record_links_to_inventory_a ?conversion_record ?supplier_inventory_a)
        (conversion_record_links_to_inventory_b ?conversion_record ?supplier_inventory_b)
        (conversion_record_selects_supplier_a ?conversion_record)
        (not
          (conversion_record_available ?conversion_record)
        )
      )
  )
  (:action create_conversion_record_selecting_supplier_b_preference
    :parameters (?service_component_a - service_component_a ?service_component_b - service_component_b ?supplier_inventory_a - supplier_inventory_a ?supplier_inventory_b - supplier_inventory_b ?conversion_record - conversion_record)
    :precondition
      (and
        (service_component_a_prepared ?service_component_a)
        (service_component_b_prepared ?service_component_b)
        (service_component_a_inventory_ref ?service_component_a ?supplier_inventory_a)
        (service_component_b_inventory_ref ?service_component_b ?supplier_inventory_b)
        (supplier_inventory_a_available ?supplier_inventory_a)
        (supplier_inventory_b_locked ?supplier_inventory_b)
        (service_component_a_readiness_confirmed ?service_component_a)
        (not
          (service_component_b_readiness_confirmed ?service_component_b)
        )
        (conversion_record_available ?conversion_record)
      )
    :effect
      (and
        (conversion_record_allocated ?conversion_record)
        (conversion_record_links_to_inventory_a ?conversion_record ?supplier_inventory_a)
        (conversion_record_links_to_inventory_b ?conversion_record ?supplier_inventory_b)
        (conversion_record_selects_supplier_b ?conversion_record)
        (not
          (conversion_record_available ?conversion_record)
        )
      )
  )
  (:action create_conversion_record_selecting_both_suppliers
    :parameters (?service_component_a - service_component_a ?service_component_b - service_component_b ?supplier_inventory_a - supplier_inventory_a ?supplier_inventory_b - supplier_inventory_b ?conversion_record - conversion_record)
    :precondition
      (and
        (service_component_a_prepared ?service_component_a)
        (service_component_b_prepared ?service_component_b)
        (service_component_a_inventory_ref ?service_component_a ?supplier_inventory_a)
        (service_component_b_inventory_ref ?service_component_b ?supplier_inventory_b)
        (supplier_inventory_a_locked ?supplier_inventory_a)
        (supplier_inventory_b_locked ?supplier_inventory_b)
        (not
          (service_component_a_readiness_confirmed ?service_component_a)
        )
        (not
          (service_component_b_readiness_confirmed ?service_component_b)
        )
        (conversion_record_available ?conversion_record)
      )
    :effect
      (and
        (conversion_record_allocated ?conversion_record)
        (conversion_record_links_to_inventory_a ?conversion_record ?supplier_inventory_a)
        (conversion_record_links_to_inventory_b ?conversion_record ?supplier_inventory_b)
        (conversion_record_selects_supplier_a ?conversion_record)
        (conversion_record_selects_supplier_b ?conversion_record)
        (not
          (conversion_record_available ?conversion_record)
        )
      )
  )
  (:action mark_conversion_record_ready_for_ticketing
    :parameters (?conversion_record - conversion_record ?service_component_a - service_component_a ?passenger_profile - passenger_profile)
    :precondition
      (and
        (conversion_record_allocated ?conversion_record)
        (service_component_a_prepared ?service_component_a)
        (assigned_passenger ?service_component_a ?passenger_profile)
        (not
          (conversion_record_ticketing_ready ?conversion_record)
        )
      )
    :effect (conversion_record_ticketing_ready ?conversion_record)
  )
  (:action consume_ticket_and_link_to_conversion_record
    :parameters (?consolidated_booking_record - consolidated_booking_record ?ticket - ticket ?conversion_record - conversion_record)
    :precondition
      (and
        (conversion_eligible_entity ?consolidated_booking_record)
        (consolidated_includes_conversion_record ?consolidated_booking_record ?conversion_record)
        (consolidated_has_ticket ?consolidated_booking_record ?ticket)
        (ticket_available ?ticket)
        (conversion_record_allocated ?conversion_record)
        (conversion_record_ticketing_ready ?conversion_record)
        (not
          (ticket_issued ?ticket)
        )
      )
    :effect
      (and
        (ticket_issued ?ticket)
        (ticket_linked_to_conversion ?ticket ?conversion_record)
        (not
          (ticket_available ?ticket)
        )
      )
  )
  (:action record_ticket_attachment_on_consolidated_record
    :parameters (?consolidated_booking_record - consolidated_booking_record ?ticket - ticket ?conversion_record - conversion_record ?passenger_profile - passenger_profile)
    :precondition
      (and
        (conversion_eligible_entity ?consolidated_booking_record)
        (consolidated_has_ticket ?consolidated_booking_record ?ticket)
        (ticket_issued ?ticket)
        (ticket_linked_to_conversion ?ticket ?conversion_record)
        (assigned_passenger ?consolidated_booking_record ?passenger_profile)
        (not
          (conversion_record_selects_supplier_a ?conversion_record)
        )
        (not
          (consolidated_ticketing_processed ?consolidated_booking_record)
        )
      )
    :effect (consolidated_ticketing_processed ?consolidated_booking_record)
  )
  (:action attach_authorization_code_to_consolidated_record
    :parameters (?consolidated_booking_record - consolidated_booking_record ?authorization_code - authorization_code)
    :precondition
      (and
        (conversion_eligible_entity ?consolidated_booking_record)
        (authorization_code_available ?authorization_code)
        (not
          (authorization_attached_flag ?consolidated_booking_record)
        )
      )
    :effect
      (and
        (authorization_attached_flag ?consolidated_booking_record)
        (consolidated_attached_authorization_code ?consolidated_booking_record ?authorization_code)
        (not
          (authorization_code_available ?authorization_code)
        )
      )
  )
  (:action finalize_authorization_and_mark_consolidated
    :parameters (?consolidated_booking_record - consolidated_booking_record ?ticket - ticket ?conversion_record - conversion_record ?passenger_profile - passenger_profile ?authorization_code - authorization_code)
    :precondition
      (and
        (conversion_eligible_entity ?consolidated_booking_record)
        (consolidated_has_ticket ?consolidated_booking_record ?ticket)
        (ticket_issued ?ticket)
        (ticket_linked_to_conversion ?ticket ?conversion_record)
        (assigned_passenger ?consolidated_booking_record ?passenger_profile)
        (conversion_record_selects_supplier_a ?conversion_record)
        (authorization_attached_flag ?consolidated_booking_record)
        (consolidated_attached_authorization_code ?consolidated_booking_record ?authorization_code)
        (not
          (consolidated_ticketing_processed ?consolidated_booking_record)
        )
      )
    :effect
      (and
        (consolidated_ticketing_processed ?consolidated_booking_record)
        (authorization_finalized_on_consolidated ?consolidated_booking_record)
      )
  )
  (:action request_supplier_reference_stage1
    :parameters (?consolidated_booking_record - consolidated_booking_record ?ancillary_service - ancillary_service ?seat_proposal - seat_proposal ?ticket - ticket ?conversion_record - conversion_record)
    :precondition
      (and
        (consolidated_ticketing_processed ?consolidated_booking_record)
        (consolidated_attached_ancillary_service ?consolidated_booking_record ?ancillary_service)
        (assigned_seat_proposal ?consolidated_booking_record ?seat_proposal)
        (consolidated_has_ticket ?consolidated_booking_record ?ticket)
        (ticket_linked_to_conversion ?ticket ?conversion_record)
        (not
          (conversion_record_selects_supplier_b ?conversion_record)
        )
        (not
          (consolidated_ready_for_supplier_reference ?consolidated_booking_record)
        )
      )
    :effect (consolidated_ready_for_supplier_reference ?consolidated_booking_record)
  )
  (:action request_supplier_reference_stage1_alternate
    :parameters (?consolidated_booking_record - consolidated_booking_record ?ancillary_service - ancillary_service ?seat_proposal - seat_proposal ?ticket - ticket ?conversion_record - conversion_record)
    :precondition
      (and
        (consolidated_ticketing_processed ?consolidated_booking_record)
        (consolidated_attached_ancillary_service ?consolidated_booking_record ?ancillary_service)
        (assigned_seat_proposal ?consolidated_booking_record ?seat_proposal)
        (consolidated_has_ticket ?consolidated_booking_record ?ticket)
        (ticket_linked_to_conversion ?ticket ?conversion_record)
        (conversion_record_selects_supplier_b ?conversion_record)
        (not
          (consolidated_ready_for_supplier_reference ?consolidated_booking_record)
        )
      )
    :effect (consolidated_ready_for_supplier_reference ?consolidated_booking_record)
  )
  (:action request_supplier_reference_stage2
    :parameters (?consolidated_booking_record - consolidated_booking_record ?supplier_reference - supplier_reference ?ticket - ticket ?conversion_record - conversion_record)
    :precondition
      (and
        (consolidated_ready_for_supplier_reference ?consolidated_booking_record)
        (consolidated_attached_supplier_reference ?consolidated_booking_record ?supplier_reference)
        (consolidated_has_ticket ?consolidated_booking_record ?ticket)
        (ticket_linked_to_conversion ?ticket ?conversion_record)
        (not
          (conversion_record_selects_supplier_a ?conversion_record)
        )
        (not
          (conversion_record_selects_supplier_b ?conversion_record)
        )
        (not
          (consolidated_supplier_reference_requested ?consolidated_booking_record)
        )
      )
    :effect (consolidated_supplier_reference_requested ?consolidated_booking_record)
  )
  (:action confirm_supplier_reference_and_mark_confirmed
    :parameters (?consolidated_booking_record - consolidated_booking_record ?supplier_reference - supplier_reference ?ticket - ticket ?conversion_record - conversion_record)
    :precondition
      (and
        (consolidated_ready_for_supplier_reference ?consolidated_booking_record)
        (consolidated_attached_supplier_reference ?consolidated_booking_record ?supplier_reference)
        (consolidated_has_ticket ?consolidated_booking_record ?ticket)
        (ticket_linked_to_conversion ?ticket ?conversion_record)
        (conversion_record_selects_supplier_a ?conversion_record)
        (not
          (conversion_record_selects_supplier_b ?conversion_record)
        )
        (not
          (consolidated_supplier_reference_requested ?consolidated_booking_record)
        )
      )
    :effect
      (and
        (consolidated_supplier_reference_requested ?consolidated_booking_record)
        (supplier_reference_confirmed_on_consolidated ?consolidated_booking_record)
      )
  )
  (:action confirm_supplier_reference_and_mark_confirmed_alternate
    :parameters (?consolidated_booking_record - consolidated_booking_record ?supplier_reference - supplier_reference ?ticket - ticket ?conversion_record - conversion_record)
    :precondition
      (and
        (consolidated_ready_for_supplier_reference ?consolidated_booking_record)
        (consolidated_attached_supplier_reference ?consolidated_booking_record ?supplier_reference)
        (consolidated_has_ticket ?consolidated_booking_record ?ticket)
        (ticket_linked_to_conversion ?ticket ?conversion_record)
        (not
          (conversion_record_selects_supplier_a ?conversion_record)
        )
        (conversion_record_selects_supplier_b ?conversion_record)
        (not
          (consolidated_supplier_reference_requested ?consolidated_booking_record)
        )
      )
    :effect
      (and
        (consolidated_supplier_reference_requested ?consolidated_booking_record)
        (supplier_reference_confirmed_on_consolidated ?consolidated_booking_record)
      )
  )
  (:action confirm_supplier_reference_with_full_flags
    :parameters (?consolidated_booking_record - consolidated_booking_record ?supplier_reference - supplier_reference ?ticket - ticket ?conversion_record - conversion_record)
    :precondition
      (and
        (consolidated_ready_for_supplier_reference ?consolidated_booking_record)
        (consolidated_attached_supplier_reference ?consolidated_booking_record ?supplier_reference)
        (consolidated_has_ticket ?consolidated_booking_record ?ticket)
        (ticket_linked_to_conversion ?ticket ?conversion_record)
        (conversion_record_selects_supplier_a ?conversion_record)
        (conversion_record_selects_supplier_b ?conversion_record)
        (not
          (consolidated_supplier_reference_requested ?consolidated_booking_record)
        )
      )
    :effect
      (and
        (consolidated_supplier_reference_requested ?consolidated_booking_record)
        (supplier_reference_confirmed_on_consolidated ?consolidated_booking_record)
      )
  )
  (:action finalize_consolidated_and_mark_ready
    :parameters (?consolidated_booking_record - consolidated_booking_record)
    :precondition
      (and
        (consolidated_supplier_reference_requested ?consolidated_booking_record)
        (not
          (supplier_reference_confirmed_on_consolidated ?consolidated_booking_record)
        )
        (not
          (consolidated_confirmation_recorded ?consolidated_booking_record)
        )
      )
    :effect
      (and
        (consolidated_confirmation_recorded ?consolidated_booking_record)
        (ready_for_finalization ?consolidated_booking_record)
      )
  )
  (:action attach_payment_method_to_consolidated_record
    :parameters (?consolidated_booking_record - consolidated_booking_record ?payment_method - payment_method)
    :precondition
      (and
        (consolidated_supplier_reference_requested ?consolidated_booking_record)
        (supplier_reference_confirmed_on_consolidated ?consolidated_booking_record)
        (payment_method_available ?payment_method)
      )
    :effect
      (and
        (consolidated_attached_payment_method ?consolidated_booking_record ?payment_method)
        (not
          (payment_method_available ?payment_method)
        )
      )
  )
  (:action perform_consolidated_final_checks
    :parameters (?consolidated_booking_record - consolidated_booking_record ?service_component_a - service_component_a ?service_component_b - service_component_b ?passenger_profile - passenger_profile ?payment_method - payment_method)
    :precondition
      (and
        (consolidated_supplier_reference_requested ?consolidated_booking_record)
        (supplier_reference_confirmed_on_consolidated ?consolidated_booking_record)
        (consolidated_attached_payment_method ?consolidated_booking_record ?payment_method)
        (consolidated_includes_service_component_a ?consolidated_booking_record ?service_component_a)
        (consolidated_includes_service_component_b ?consolidated_booking_record ?service_component_b)
        (service_component_a_readiness_confirmed ?service_component_a)
        (service_component_b_readiness_confirmed ?service_component_b)
        (assigned_passenger ?consolidated_booking_record ?passenger_profile)
        (not
          (consolidated_final_checks_passed ?consolidated_booking_record)
        )
      )
    :effect (consolidated_final_checks_passed ?consolidated_booking_record)
  )
  (:action finalize_consolidated_after_checks
    :parameters (?consolidated_booking_record - consolidated_booking_record)
    :precondition
      (and
        (consolidated_supplier_reference_requested ?consolidated_booking_record)
        (consolidated_final_checks_passed ?consolidated_booking_record)
        (not
          (consolidated_confirmation_recorded ?consolidated_booking_record)
        )
      )
    :effect
      (and
        (consolidated_confirmation_recorded ?consolidated_booking_record)
        (ready_for_finalization ?consolidated_booking_record)
      )
  )
  (:action apply_loyalty_voucher_to_consolidated_record
    :parameters (?consolidated_booking_record - consolidated_booking_record ?loyalty_voucher - loyalty_voucher ?passenger_profile - passenger_profile)
    :precondition
      (and
        (conversion_eligible_entity ?consolidated_booking_record)
        (assigned_passenger ?consolidated_booking_record ?passenger_profile)
        (loyalty_voucher_available ?loyalty_voucher)
        (consolidated_has_loyalty_voucher ?consolidated_booking_record ?loyalty_voucher)
        (not
          (consolidated_loyalty_attached ?consolidated_booking_record)
        )
      )
    :effect
      (and
        (consolidated_loyalty_attached ?consolidated_booking_record)
        (not
          (loyalty_voucher_available ?loyalty_voucher)
        )
      )
  )
  (:action authorize_loyalty_on_consolidated_record
    :parameters (?consolidated_booking_record - consolidated_booking_record ?seat_proposal - seat_proposal)
    :precondition
      (and
        (consolidated_loyalty_attached ?consolidated_booking_record)
        (assigned_seat_proposal ?consolidated_booking_record ?seat_proposal)
        (not
          (consolidated_loyalty_authorized ?consolidated_booking_record)
        )
      )
    :effect (consolidated_loyalty_authorized ?consolidated_booking_record)
  )
  (:action finalize_supplier_reference_for_loyalty
    :parameters (?consolidated_booking_record - consolidated_booking_record ?supplier_reference - supplier_reference)
    :precondition
      (and
        (consolidated_loyalty_authorized ?consolidated_booking_record)
        (consolidated_attached_supplier_reference ?consolidated_booking_record ?supplier_reference)
        (not
          (consolidated_loyalty_finalized ?consolidated_booking_record)
        )
      )
    :effect (consolidated_loyalty_finalized ?consolidated_booking_record)
  )
  (:action finalize_loyalty_flow_and_mark_ready
    :parameters (?consolidated_booking_record - consolidated_booking_record)
    :precondition
      (and
        (consolidated_loyalty_finalized ?consolidated_booking_record)
        (not
          (consolidated_confirmation_recorded ?consolidated_booking_record)
        )
      )
    :effect
      (and
        (consolidated_confirmation_recorded ?consolidated_booking_record)
        (ready_for_finalization ?consolidated_booking_record)
      )
  )
  (:action commit_component_a_to_finalization
    :parameters (?service_component_a - service_component_a ?conversion_record - conversion_record)
    :precondition
      (and
        (service_component_a_prepared ?service_component_a)
        (service_component_a_readiness_confirmed ?service_component_a)
        (conversion_record_allocated ?conversion_record)
        (conversion_record_ticketing_ready ?conversion_record)
        (not
          (ready_for_finalization ?service_component_a)
        )
      )
    :effect (ready_for_finalization ?service_component_a)
  )
  (:action commit_component_b_to_finalization
    :parameters (?service_component_b - service_component_b ?conversion_record - conversion_record)
    :precondition
      (and
        (service_component_b_prepared ?service_component_b)
        (service_component_b_readiness_confirmed ?service_component_b)
        (conversion_record_allocated ?conversion_record)
        (conversion_record_ticketing_ready ?conversion_record)
        (not
          (ready_for_finalization ?service_component_b)
        )
      )
    :effect (ready_for_finalization ?service_component_b)
  )
  (:action consume_confirmation_token_and_commit_booking_request
    :parameters (?booking_request - booking_request ?confirmation_token - confirmation_token ?passenger_profile - passenger_profile)
    :precondition
      (and
        (ready_for_finalization ?booking_request)
        (assigned_passenger ?booking_request ?passenger_profile)
        (confirmation_token_available ?confirmation_token)
        (not
          (conversion_committed_entity ?booking_request)
        )
      )
    :effect
      (and
        (conversion_committed_entity ?booking_request)
        (assigned_confirmation_token ?booking_request ?confirmation_token)
        (not
          (confirmation_token_available ?confirmation_token)
        )
      )
  )
  (:action confirm_component_a_and_reconcile_resources
    :parameters (?service_component_a - service_component_a ?waitlist_slot - waitlist_slot ?confirmation_token - confirmation_token)
    :precondition
      (and
        (conversion_committed_entity ?service_component_a)
        (assigned_waitlist_slot ?service_component_a ?waitlist_slot)
        (assigned_confirmation_token ?service_component_a ?confirmation_token)
        (not
          (entity_confirmed ?service_component_a)
        )
      )
    :effect
      (and
        (entity_confirmed ?service_component_a)
        (waitlist_slot_available ?waitlist_slot)
        (confirmation_token_available ?confirmation_token)
      )
  )
  (:action confirm_component_b_and_reconcile_resources
    :parameters (?service_component_b - service_component_b ?waitlist_slot - waitlist_slot ?confirmation_token - confirmation_token)
    :precondition
      (and
        (conversion_committed_entity ?service_component_b)
        (assigned_waitlist_slot ?service_component_b ?waitlist_slot)
        (assigned_confirmation_token ?service_component_b ?confirmation_token)
        (not
          (entity_confirmed ?service_component_b)
        )
      )
    :effect
      (and
        (entity_confirmed ?service_component_b)
        (waitlist_slot_available ?waitlist_slot)
        (confirmation_token_available ?confirmation_token)
      )
  )
  (:action confirm_consolidated_and_reconcile_resources
    :parameters (?consolidated_booking_record - consolidated_booking_record ?waitlist_slot - waitlist_slot ?confirmation_token - confirmation_token)
    :precondition
      (and
        (conversion_committed_entity ?consolidated_booking_record)
        (assigned_waitlist_slot ?consolidated_booking_record ?waitlist_slot)
        (assigned_confirmation_token ?consolidated_booking_record ?confirmation_token)
        (not
          (entity_confirmed ?consolidated_booking_record)
        )
      )
    :effect
      (and
        (entity_confirmed ?consolidated_booking_record)
        (waitlist_slot_available ?waitlist_slot)
        (confirmation_token_available ?confirmation_token)
      )
  )
)

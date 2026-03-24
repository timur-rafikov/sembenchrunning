(define (domain multimodal_segment_chaining_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource - object location - object asset - object domain_entity - object trip_segment - domain_entity transfer_slot - resource service_option - resource service_provider - resource seat_or_cabin_option - resource ancillary_service - resource time_buffer - resource equipment_request - resource schedule_slot - resource fare_option_location - location passenger_group - location credential - location origin_stop_location - asset destination_stop_location - asset vehicle_unit - asset segment_context_base - trip_segment segment_context_itinerary_parent - trip_segment upstream_segment_context - segment_context_base downstream_segment_context - segment_context_base itinerary_element - segment_context_itinerary_parent)
  (:predicates
    (entity_initialized ?trip_segment - trip_segment)
    (entity_service_confirmed ?trip_segment - trip_segment)
    (transfer_slot_reserved ?trip_segment - trip_segment)
    (entity_confirmed ?trip_segment - trip_segment)
    (ready_for_boarding ?trip_segment - trip_segment)
    (entity_buffer_locked ?trip_segment - trip_segment)
    (transfer_slot_available ?transfer_slot - transfer_slot)
    (entity_has_transfer_slot ?trip_segment - trip_segment ?transfer_slot - transfer_slot)
    (service_option_available ?service_option - service_option)
    (entity_has_service_option ?trip_segment - trip_segment ?service_option - service_option)
    (service_provider_available ?service_provider - service_provider)
    (entity_has_provider ?trip_segment - trip_segment ?service_provider - service_provider)
    (fare_option_available ?fare_option - fare_option_location)
    (upstream_context_has_fare_option ?upstream_segment_context - upstream_segment_context ?fare_option - fare_option_location)
    (downstream_context_has_fare_option ?downstream_segment_context - downstream_segment_context ?fare_option - fare_option_location)
    (upstream_context_origin_stop ?upstream_segment_context - upstream_segment_context ?origin_stop - origin_stop_location)
    (origin_stop_boarding_window_open ?origin_stop - origin_stop_location)
    (origin_stop_fare_reserved ?origin_stop - origin_stop_location)
    (upstream_context_boarding_confirmed ?upstream_segment_context - upstream_segment_context)
    (downstream_context_destination_stop ?downstream_segment_context - downstream_segment_context ?destination_stop - destination_stop_location)
    (destination_stop_alighting_window_open ?destination_stop - destination_stop_location)
    (destination_stop_fare_reserved ?destination_stop - destination_stop_location)
    (downstream_context_alighting_confirmed ?downstream_segment_context - downstream_segment_context)
    (vehicle_unit_available ?vehicle_unit - vehicle_unit)
    (vehicle_unit_reserved ?vehicle_unit - vehicle_unit)
    (vehicle_assigned_origin_stop ?vehicle_unit - vehicle_unit ?origin_stop - origin_stop_location)
    (vehicle_assigned_destination_stop ?vehicle_unit - vehicle_unit ?destination_stop - destination_stop_location)
    (vehicle_origin_boarding_window_set ?vehicle_unit - vehicle_unit)
    (vehicle_destination_alighting_window_set ?vehicle_unit - vehicle_unit)
    (vehicle_boarding_ready ?vehicle_unit - vehicle_unit)
    (itinerary_element_has_upstream_context ?itinerary_element - itinerary_element ?upstream_segment_context - upstream_segment_context)
    (itinerary_element_has_downstream_context ?itinerary_element - itinerary_element ?downstream_segment_context - downstream_segment_context)
    (itinerary_element_assigned_vehicle ?itinerary_element - itinerary_element ?vehicle_unit - vehicle_unit)
    (passenger_group_available ?passenger_group - passenger_group)
    (itinerary_element_has_passenger_group ?itinerary_element - itinerary_element ?passenger_group - passenger_group)
    (passenger_group_assigned ?passenger_group - passenger_group)
    (passenger_group_assigned_to_vehicle ?passenger_group - passenger_group ?vehicle_unit - vehicle_unit)
    (itinerary_manifest_locked ?itinerary_element - itinerary_element)
    (itinerary_options_attached ?itinerary_element - itinerary_element)
    (itinerary_validated ?itinerary_element - itinerary_element)
    (itinerary_seat_option_locked ?itinerary_element - itinerary_element)
    (itinerary_seat_option_confirmed ?itinerary_element - itinerary_element)
    (itinerary_attachments_confirmed ?itinerary_element - itinerary_element)
    (itinerary_boarding_checks_completed ?itinerary_element - itinerary_element)
    (credential_available ?credential - credential)
    (itinerary_has_credential ?itinerary_element - itinerary_element ?credential - credential)
    (itinerary_credential_locked ?itinerary_element - itinerary_element)
    (itinerary_credential_applied ?itinerary_element - itinerary_element)
    (itinerary_credential_validated ?itinerary_element - itinerary_element)
    (seat_option_available ?seat_or_cabin_option - seat_or_cabin_option)
    (itinerary_element_assigned_seat_option ?itinerary_element - itinerary_element ?seat_or_cabin_option - seat_or_cabin_option)
    (ancillary_service_available ?ancillary_service - ancillary_service)
    (itinerary_element_has_ancillary_service ?itinerary_element - itinerary_element ?ancillary_service - ancillary_service)
    (equipment_request_available ?equipment_request - equipment_request)
    (itinerary_element_has_equipment_request ?itinerary_element - itinerary_element ?equipment_request - equipment_request)
    (schedule_slot_available ?schedule_slot - schedule_slot)
    (itinerary_element_assigned_schedule_slot ?itinerary_element - itinerary_element ?schedule_slot - schedule_slot)
    (time_buffer_available ?time_buffer - time_buffer)
    (entity_time_buffer_assigned ?trip_segment - trip_segment ?time_buffer - time_buffer)
    (upstream_context_boarding_ready ?upstream_segment_context - upstream_segment_context)
    (downstream_context_alighting_ready ?downstream_segment_context - downstream_segment_context)
    (itinerary_element_activated ?itinerary_element - itinerary_element)
  )
  (:action create_trip_segment
    :parameters (?trip_segment - trip_segment)
    :precondition
      (and
        (not
          (entity_initialized ?trip_segment)
        )
        (not
          (entity_confirmed ?trip_segment)
        )
      )
    :effect (entity_initialized ?trip_segment)
  )
  (:action assign_transfer_slot_to_segment
    :parameters (?trip_segment - trip_segment ?transfer_slot - transfer_slot)
    :precondition
      (and
        (entity_initialized ?trip_segment)
        (not
          (transfer_slot_reserved ?trip_segment)
        )
        (transfer_slot_available ?transfer_slot)
      )
    :effect
      (and
        (transfer_slot_reserved ?trip_segment)
        (entity_has_transfer_slot ?trip_segment ?transfer_slot)
        (not
          (transfer_slot_available ?transfer_slot)
        )
      )
  )
  (:action assign_service_option_to_segment
    :parameters (?trip_segment - trip_segment ?service_option - service_option)
    :precondition
      (and
        (entity_initialized ?trip_segment)
        (transfer_slot_reserved ?trip_segment)
        (service_option_available ?service_option)
      )
    :effect
      (and
        (entity_has_service_option ?trip_segment ?service_option)
        (not
          (service_option_available ?service_option)
        )
      )
  )
  (:action confirm_segment_service
    :parameters (?trip_segment - trip_segment ?service_option - service_option)
    :precondition
      (and
        (entity_initialized ?trip_segment)
        (transfer_slot_reserved ?trip_segment)
        (entity_has_service_option ?trip_segment ?service_option)
        (not
          (entity_service_confirmed ?trip_segment)
        )
      )
    :effect (entity_service_confirmed ?trip_segment)
  )
  (:action release_service_option_from_segment
    :parameters (?trip_segment - trip_segment ?service_option - service_option)
    :precondition
      (and
        (entity_has_service_option ?trip_segment ?service_option)
      )
    :effect
      (and
        (service_option_available ?service_option)
        (not
          (entity_has_service_option ?trip_segment ?service_option)
        )
      )
  )
  (:action assign_provider_to_segment
    :parameters (?trip_segment - trip_segment ?service_provider - service_provider)
    :precondition
      (and
        (entity_service_confirmed ?trip_segment)
        (service_provider_available ?service_provider)
      )
    :effect
      (and
        (entity_has_provider ?trip_segment ?service_provider)
        (not
          (service_provider_available ?service_provider)
        )
      )
  )
  (:action release_provider_from_segment
    :parameters (?trip_segment - trip_segment ?service_provider - service_provider)
    :precondition
      (and
        (entity_has_provider ?trip_segment ?service_provider)
      )
    :effect
      (and
        (service_provider_available ?service_provider)
        (not
          (entity_has_provider ?trip_segment ?service_provider)
        )
      )
  )
  (:action attach_equipment_request_to_itinerary
    :parameters (?itinerary_element - itinerary_element ?equipment_request - equipment_request)
    :precondition
      (and
        (entity_service_confirmed ?itinerary_element)
        (equipment_request_available ?equipment_request)
      )
    :effect
      (and
        (itinerary_element_has_equipment_request ?itinerary_element ?equipment_request)
        (not
          (equipment_request_available ?equipment_request)
        )
      )
  )
  (:action detach_equipment_request_from_itinerary
    :parameters (?itinerary_element - itinerary_element ?equipment_request - equipment_request)
    :precondition
      (and
        (itinerary_element_has_equipment_request ?itinerary_element ?equipment_request)
      )
    :effect
      (and
        (equipment_request_available ?equipment_request)
        (not
          (itinerary_element_has_equipment_request ?itinerary_element ?equipment_request)
        )
      )
  )
  (:action assign_schedule_slot_to_itinerary
    :parameters (?itinerary_element - itinerary_element ?schedule_slot - schedule_slot)
    :precondition
      (and
        (entity_service_confirmed ?itinerary_element)
        (schedule_slot_available ?schedule_slot)
      )
    :effect
      (and
        (itinerary_element_assigned_schedule_slot ?itinerary_element ?schedule_slot)
        (not
          (schedule_slot_available ?schedule_slot)
        )
      )
  )
  (:action release_schedule_slot_from_itinerary
    :parameters (?itinerary_element - itinerary_element ?schedule_slot - schedule_slot)
    :precondition
      (and
        (itinerary_element_assigned_schedule_slot ?itinerary_element ?schedule_slot)
      )
    :effect
      (and
        (schedule_slot_available ?schedule_slot)
        (not
          (itinerary_element_assigned_schedule_slot ?itinerary_element ?schedule_slot)
        )
      )
  )
  (:action open_origin_boarding_window
    :parameters (?upstream_segment_context - upstream_segment_context ?origin_stop - origin_stop_location ?service_option - service_option)
    :precondition
      (and
        (entity_service_confirmed ?upstream_segment_context)
        (entity_has_service_option ?upstream_segment_context ?service_option)
        (upstream_context_origin_stop ?upstream_segment_context ?origin_stop)
        (not
          (origin_stop_boarding_window_open ?origin_stop)
        )
        (not
          (origin_stop_fare_reserved ?origin_stop)
        )
      )
    :effect (origin_stop_boarding_window_open ?origin_stop)
  )
  (:action confirm_origin_boarding_by_provider
    :parameters (?upstream_segment_context - upstream_segment_context ?origin_stop - origin_stop_location ?service_provider - service_provider)
    :precondition
      (and
        (entity_service_confirmed ?upstream_segment_context)
        (entity_has_provider ?upstream_segment_context ?service_provider)
        (upstream_context_origin_stop ?upstream_segment_context ?origin_stop)
        (origin_stop_boarding_window_open ?origin_stop)
        (not
          (upstream_context_boarding_ready ?upstream_segment_context)
        )
      )
    :effect
      (and
        (upstream_context_boarding_ready ?upstream_segment_context)
        (upstream_context_boarding_confirmed ?upstream_segment_context)
      )
  )
  (:action apply_fare_to_origin_and_prepare_upstream_context
    :parameters (?upstream_segment_context - upstream_segment_context ?origin_stop - origin_stop_location ?fare_option - fare_option_location)
    :precondition
      (and
        (entity_service_confirmed ?upstream_segment_context)
        (upstream_context_origin_stop ?upstream_segment_context ?origin_stop)
        (fare_option_available ?fare_option)
        (not
          (upstream_context_boarding_ready ?upstream_segment_context)
        )
      )
    :effect
      (and
        (origin_stop_fare_reserved ?origin_stop)
        (upstream_context_boarding_ready ?upstream_segment_context)
        (upstream_context_has_fare_option ?upstream_segment_context ?fare_option)
        (not
          (fare_option_available ?fare_option)
        )
      )
  )
  (:action finalize_origin_boarding_with_fare
    :parameters (?upstream_segment_context - upstream_segment_context ?origin_stop - origin_stop_location ?service_option - service_option ?fare_option - fare_option_location)
    :precondition
      (and
        (entity_service_confirmed ?upstream_segment_context)
        (entity_has_service_option ?upstream_segment_context ?service_option)
        (upstream_context_origin_stop ?upstream_segment_context ?origin_stop)
        (origin_stop_fare_reserved ?origin_stop)
        (upstream_context_has_fare_option ?upstream_segment_context ?fare_option)
        (not
          (upstream_context_boarding_confirmed ?upstream_segment_context)
        )
      )
    :effect
      (and
        (origin_stop_boarding_window_open ?origin_stop)
        (upstream_context_boarding_confirmed ?upstream_segment_context)
        (fare_option_available ?fare_option)
        (not
          (upstream_context_has_fare_option ?upstream_segment_context ?fare_option)
        )
      )
  )
  (:action open_destination_alighting_window
    :parameters (?downstream_segment_context - downstream_segment_context ?destination_stop - destination_stop_location ?service_option - service_option)
    :precondition
      (and
        (entity_service_confirmed ?downstream_segment_context)
        (entity_has_service_option ?downstream_segment_context ?service_option)
        (downstream_context_destination_stop ?downstream_segment_context ?destination_stop)
        (not
          (destination_stop_alighting_window_open ?destination_stop)
        )
        (not
          (destination_stop_fare_reserved ?destination_stop)
        )
      )
    :effect (destination_stop_alighting_window_open ?destination_stop)
  )
  (:action confirm_destination_alighting_by_provider
    :parameters (?downstream_segment_context - downstream_segment_context ?destination_stop - destination_stop_location ?service_provider - service_provider)
    :precondition
      (and
        (entity_service_confirmed ?downstream_segment_context)
        (entity_has_provider ?downstream_segment_context ?service_provider)
        (downstream_context_destination_stop ?downstream_segment_context ?destination_stop)
        (destination_stop_alighting_window_open ?destination_stop)
        (not
          (downstream_context_alighting_ready ?downstream_segment_context)
        )
      )
    :effect
      (and
        (downstream_context_alighting_ready ?downstream_segment_context)
        (downstream_context_alighting_confirmed ?downstream_segment_context)
      )
  )
  (:action apply_fare_to_destination_and_prepare_downstream_context
    :parameters (?downstream_segment_context - downstream_segment_context ?destination_stop - destination_stop_location ?fare_option - fare_option_location)
    :precondition
      (and
        (entity_service_confirmed ?downstream_segment_context)
        (downstream_context_destination_stop ?downstream_segment_context ?destination_stop)
        (fare_option_available ?fare_option)
        (not
          (downstream_context_alighting_ready ?downstream_segment_context)
        )
      )
    :effect
      (and
        (destination_stop_fare_reserved ?destination_stop)
        (downstream_context_alighting_ready ?downstream_segment_context)
        (downstream_context_has_fare_option ?downstream_segment_context ?fare_option)
        (not
          (fare_option_available ?fare_option)
        )
      )
  )
  (:action finalize_destination_alighting_with_fare
    :parameters (?downstream_segment_context - downstream_segment_context ?destination_stop - destination_stop_location ?service_option - service_option ?fare_option - fare_option_location)
    :precondition
      (and
        (entity_service_confirmed ?downstream_segment_context)
        (entity_has_service_option ?downstream_segment_context ?service_option)
        (downstream_context_destination_stop ?downstream_segment_context ?destination_stop)
        (destination_stop_fare_reserved ?destination_stop)
        (downstream_context_has_fare_option ?downstream_segment_context ?fare_option)
        (not
          (downstream_context_alighting_confirmed ?downstream_segment_context)
        )
      )
    :effect
      (and
        (destination_stop_alighting_window_open ?destination_stop)
        (downstream_context_alighting_confirmed ?downstream_segment_context)
        (fare_option_available ?fare_option)
        (not
          (downstream_context_has_fare_option ?downstream_segment_context ?fare_option)
        )
      )
  )
  (:action allocate_vehicle_unit_for_chain
    :parameters (?upstream_segment_context - upstream_segment_context ?downstream_segment_context - downstream_segment_context ?origin_stop - origin_stop_location ?destination_stop - destination_stop_location ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (upstream_context_boarding_ready ?upstream_segment_context)
        (downstream_context_alighting_ready ?downstream_segment_context)
        (upstream_context_origin_stop ?upstream_segment_context ?origin_stop)
        (downstream_context_destination_stop ?downstream_segment_context ?destination_stop)
        (origin_stop_boarding_window_open ?origin_stop)
        (destination_stop_alighting_window_open ?destination_stop)
        (upstream_context_boarding_confirmed ?upstream_segment_context)
        (downstream_context_alighting_confirmed ?downstream_segment_context)
        (vehicle_unit_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_unit_reserved ?vehicle_unit)
        (vehicle_assigned_origin_stop ?vehicle_unit ?origin_stop)
        (vehicle_assigned_destination_stop ?vehicle_unit ?destination_stop)
        (not
          (vehicle_unit_available ?vehicle_unit)
        )
      )
  )
  (:action allocate_vehicle_with_origin_window
    :parameters (?upstream_segment_context - upstream_segment_context ?downstream_segment_context - downstream_segment_context ?origin_stop - origin_stop_location ?destination_stop - destination_stop_location ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (upstream_context_boarding_ready ?upstream_segment_context)
        (downstream_context_alighting_ready ?downstream_segment_context)
        (upstream_context_origin_stop ?upstream_segment_context ?origin_stop)
        (downstream_context_destination_stop ?downstream_segment_context ?destination_stop)
        (origin_stop_fare_reserved ?origin_stop)
        (destination_stop_alighting_window_open ?destination_stop)
        (not
          (upstream_context_boarding_confirmed ?upstream_segment_context)
        )
        (downstream_context_alighting_confirmed ?downstream_segment_context)
        (vehicle_unit_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_unit_reserved ?vehicle_unit)
        (vehicle_assigned_origin_stop ?vehicle_unit ?origin_stop)
        (vehicle_assigned_destination_stop ?vehicle_unit ?destination_stop)
        (vehicle_origin_boarding_window_set ?vehicle_unit)
        (not
          (vehicle_unit_available ?vehicle_unit)
        )
      )
  )
  (:action allocate_vehicle_with_destination_window
    :parameters (?upstream_segment_context - upstream_segment_context ?downstream_segment_context - downstream_segment_context ?origin_stop - origin_stop_location ?destination_stop - destination_stop_location ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (upstream_context_boarding_ready ?upstream_segment_context)
        (downstream_context_alighting_ready ?downstream_segment_context)
        (upstream_context_origin_stop ?upstream_segment_context ?origin_stop)
        (downstream_context_destination_stop ?downstream_segment_context ?destination_stop)
        (origin_stop_boarding_window_open ?origin_stop)
        (destination_stop_fare_reserved ?destination_stop)
        (upstream_context_boarding_confirmed ?upstream_segment_context)
        (not
          (downstream_context_alighting_confirmed ?downstream_segment_context)
        )
        (vehicle_unit_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_unit_reserved ?vehicle_unit)
        (vehicle_assigned_origin_stop ?vehicle_unit ?origin_stop)
        (vehicle_assigned_destination_stop ?vehicle_unit ?destination_stop)
        (vehicle_destination_alighting_window_set ?vehicle_unit)
        (not
          (vehicle_unit_available ?vehicle_unit)
        )
      )
  )
  (:action allocate_vehicle_with_both_windows
    :parameters (?upstream_segment_context - upstream_segment_context ?downstream_segment_context - downstream_segment_context ?origin_stop - origin_stop_location ?destination_stop - destination_stop_location ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (upstream_context_boarding_ready ?upstream_segment_context)
        (downstream_context_alighting_ready ?downstream_segment_context)
        (upstream_context_origin_stop ?upstream_segment_context ?origin_stop)
        (downstream_context_destination_stop ?downstream_segment_context ?destination_stop)
        (origin_stop_fare_reserved ?origin_stop)
        (destination_stop_fare_reserved ?destination_stop)
        (not
          (upstream_context_boarding_confirmed ?upstream_segment_context)
        )
        (not
          (downstream_context_alighting_confirmed ?downstream_segment_context)
        )
        (vehicle_unit_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_unit_reserved ?vehicle_unit)
        (vehicle_assigned_origin_stop ?vehicle_unit ?origin_stop)
        (vehicle_assigned_destination_stop ?vehicle_unit ?destination_stop)
        (vehicle_origin_boarding_window_set ?vehicle_unit)
        (vehicle_destination_alighting_window_set ?vehicle_unit)
        (not
          (vehicle_unit_available ?vehicle_unit)
        )
      )
  )
  (:action prepare_vehicle_for_boarding
    :parameters (?vehicle_unit - vehicle_unit ?upstream_segment_context - upstream_segment_context ?service_option - service_option)
    :precondition
      (and
        (vehicle_unit_reserved ?vehicle_unit)
        (upstream_context_boarding_ready ?upstream_segment_context)
        (entity_has_service_option ?upstream_segment_context ?service_option)
        (not
          (vehicle_boarding_ready ?vehicle_unit)
        )
      )
    :effect (vehicle_boarding_ready ?vehicle_unit)
  )
  (:action assign_passenger_group_to_itinerary_and_vehicle
    :parameters (?itinerary_element - itinerary_element ?passenger_group - passenger_group ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (entity_service_confirmed ?itinerary_element)
        (itinerary_element_assigned_vehicle ?itinerary_element ?vehicle_unit)
        (itinerary_element_has_passenger_group ?itinerary_element ?passenger_group)
        (passenger_group_available ?passenger_group)
        (vehicle_unit_reserved ?vehicle_unit)
        (vehicle_boarding_ready ?vehicle_unit)
        (not
          (passenger_group_assigned ?passenger_group)
        )
      )
    :effect
      (and
        (passenger_group_assigned ?passenger_group)
        (passenger_group_assigned_to_vehicle ?passenger_group ?vehicle_unit)
        (not
          (passenger_group_available ?passenger_group)
        )
      )
  )
  (:action lock_itinerary_manifest
    :parameters (?itinerary_element - itinerary_element ?passenger_group - passenger_group ?vehicle_unit - vehicle_unit ?service_option - service_option)
    :precondition
      (and
        (entity_service_confirmed ?itinerary_element)
        (itinerary_element_has_passenger_group ?itinerary_element ?passenger_group)
        (passenger_group_assigned ?passenger_group)
        (passenger_group_assigned_to_vehicle ?passenger_group ?vehicle_unit)
        (entity_has_service_option ?itinerary_element ?service_option)
        (not
          (vehicle_origin_boarding_window_set ?vehicle_unit)
        )
        (not
          (itinerary_manifest_locked ?itinerary_element)
        )
      )
    :effect (itinerary_manifest_locked ?itinerary_element)
  )
  (:action reserve_seat_option_for_itinerary
    :parameters (?itinerary_element - itinerary_element ?seat_or_cabin_option - seat_or_cabin_option)
    :precondition
      (and
        (entity_service_confirmed ?itinerary_element)
        (seat_option_available ?seat_or_cabin_option)
        (not
          (itinerary_seat_option_locked ?itinerary_element)
        )
      )
    :effect
      (and
        (itinerary_seat_option_locked ?itinerary_element)
        (itinerary_element_assigned_seat_option ?itinerary_element ?seat_or_cabin_option)
        (not
          (seat_option_available ?seat_or_cabin_option)
        )
      )
  )
  (:action confirm_seat_and_lock_manifest
    :parameters (?itinerary_element - itinerary_element ?passenger_group - passenger_group ?vehicle_unit - vehicle_unit ?service_option - service_option ?seat_or_cabin_option - seat_or_cabin_option)
    :precondition
      (and
        (entity_service_confirmed ?itinerary_element)
        (itinerary_element_has_passenger_group ?itinerary_element ?passenger_group)
        (passenger_group_assigned ?passenger_group)
        (passenger_group_assigned_to_vehicle ?passenger_group ?vehicle_unit)
        (entity_has_service_option ?itinerary_element ?service_option)
        (vehicle_origin_boarding_window_set ?vehicle_unit)
        (itinerary_seat_option_locked ?itinerary_element)
        (itinerary_element_assigned_seat_option ?itinerary_element ?seat_or_cabin_option)
        (not
          (itinerary_manifest_locked ?itinerary_element)
        )
      )
    :effect
      (and
        (itinerary_manifest_locked ?itinerary_element)
        (itinerary_seat_option_confirmed ?itinerary_element)
      )
  )
  (:action attach_equipment_and_finalize_manifest
    :parameters (?itinerary_element - itinerary_element ?equipment_request - equipment_request ?service_provider - service_provider ?passenger_group - passenger_group ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_manifest_locked ?itinerary_element)
        (itinerary_element_has_equipment_request ?itinerary_element ?equipment_request)
        (entity_has_provider ?itinerary_element ?service_provider)
        (itinerary_element_has_passenger_group ?itinerary_element ?passenger_group)
        (passenger_group_assigned_to_vehicle ?passenger_group ?vehicle_unit)
        (not
          (vehicle_destination_alighting_window_set ?vehicle_unit)
        )
        (not
          (itinerary_options_attached ?itinerary_element)
        )
      )
    :effect (itinerary_options_attached ?itinerary_element)
  )
  (:action attach_equipment_and_finalize_manifest_with_destination_window
    :parameters (?itinerary_element - itinerary_element ?equipment_request - equipment_request ?service_provider - service_provider ?passenger_group - passenger_group ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_manifest_locked ?itinerary_element)
        (itinerary_element_has_equipment_request ?itinerary_element ?equipment_request)
        (entity_has_provider ?itinerary_element ?service_provider)
        (itinerary_element_has_passenger_group ?itinerary_element ?passenger_group)
        (passenger_group_assigned_to_vehicle ?passenger_group ?vehicle_unit)
        (vehicle_destination_alighting_window_set ?vehicle_unit)
        (not
          (itinerary_options_attached ?itinerary_element)
        )
      )
    :effect (itinerary_options_attached ?itinerary_element)
  )
  (:action perform_itinerary_validations
    :parameters (?itinerary_element - itinerary_element ?schedule_slot - schedule_slot ?passenger_group - passenger_group ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_options_attached ?itinerary_element)
        (itinerary_element_assigned_schedule_slot ?itinerary_element ?schedule_slot)
        (itinerary_element_has_passenger_group ?itinerary_element ?passenger_group)
        (passenger_group_assigned_to_vehicle ?passenger_group ?vehicle_unit)
        (not
          (vehicle_origin_boarding_window_set ?vehicle_unit)
        )
        (not
          (vehicle_destination_alighting_window_set ?vehicle_unit)
        )
        (not
          (itinerary_validated ?itinerary_element)
        )
      )
    :effect (itinerary_validated ?itinerary_element)
  )
  (:action perform_itinerary_validations_with_origin_window
    :parameters (?itinerary_element - itinerary_element ?schedule_slot - schedule_slot ?passenger_group - passenger_group ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_options_attached ?itinerary_element)
        (itinerary_element_assigned_schedule_slot ?itinerary_element ?schedule_slot)
        (itinerary_element_has_passenger_group ?itinerary_element ?passenger_group)
        (passenger_group_assigned_to_vehicle ?passenger_group ?vehicle_unit)
        (vehicle_origin_boarding_window_set ?vehicle_unit)
        (not
          (vehicle_destination_alighting_window_set ?vehicle_unit)
        )
        (not
          (itinerary_validated ?itinerary_element)
        )
      )
    :effect
      (and
        (itinerary_validated ?itinerary_element)
        (itinerary_attachments_confirmed ?itinerary_element)
      )
  )
  (:action perform_itinerary_validations_with_destination_window
    :parameters (?itinerary_element - itinerary_element ?schedule_slot - schedule_slot ?passenger_group - passenger_group ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_options_attached ?itinerary_element)
        (itinerary_element_assigned_schedule_slot ?itinerary_element ?schedule_slot)
        (itinerary_element_has_passenger_group ?itinerary_element ?passenger_group)
        (passenger_group_assigned_to_vehicle ?passenger_group ?vehicle_unit)
        (not
          (vehicle_origin_boarding_window_set ?vehicle_unit)
        )
        (vehicle_destination_alighting_window_set ?vehicle_unit)
        (not
          (itinerary_validated ?itinerary_element)
        )
      )
    :effect
      (and
        (itinerary_validated ?itinerary_element)
        (itinerary_attachments_confirmed ?itinerary_element)
      )
  )
  (:action perform_itinerary_validations_with_both_windows
    :parameters (?itinerary_element - itinerary_element ?schedule_slot - schedule_slot ?passenger_group - passenger_group ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (itinerary_options_attached ?itinerary_element)
        (itinerary_element_assigned_schedule_slot ?itinerary_element ?schedule_slot)
        (itinerary_element_has_passenger_group ?itinerary_element ?passenger_group)
        (passenger_group_assigned_to_vehicle ?passenger_group ?vehicle_unit)
        (vehicle_origin_boarding_window_set ?vehicle_unit)
        (vehicle_destination_alighting_window_set ?vehicle_unit)
        (not
          (itinerary_validated ?itinerary_element)
        )
      )
    :effect
      (and
        (itinerary_validated ?itinerary_element)
        (itinerary_attachments_confirmed ?itinerary_element)
      )
  )
  (:action activate_itinerary_element
    :parameters (?itinerary_element - itinerary_element)
    :precondition
      (and
        (itinerary_validated ?itinerary_element)
        (not
          (itinerary_attachments_confirmed ?itinerary_element)
        )
        (not
          (itinerary_element_activated ?itinerary_element)
        )
      )
    :effect
      (and
        (itinerary_element_activated ?itinerary_element)
        (ready_for_boarding ?itinerary_element)
      )
  )
  (:action attach_ancillary_service_to_itinerary
    :parameters (?itinerary_element - itinerary_element ?ancillary_service - ancillary_service)
    :precondition
      (and
        (itinerary_validated ?itinerary_element)
        (itinerary_attachments_confirmed ?itinerary_element)
        (ancillary_service_available ?ancillary_service)
      )
    :effect
      (and
        (itinerary_element_has_ancillary_service ?itinerary_element ?ancillary_service)
        (not
          (ancillary_service_available ?ancillary_service)
        )
      )
  )
  (:action finalize_boarding_manifest
    :parameters (?itinerary_element - itinerary_element ?upstream_segment_context - upstream_segment_context ?downstream_segment_context - downstream_segment_context ?service_option - service_option ?ancillary_service - ancillary_service)
    :precondition
      (and
        (itinerary_validated ?itinerary_element)
        (itinerary_attachments_confirmed ?itinerary_element)
        (itinerary_element_has_ancillary_service ?itinerary_element ?ancillary_service)
        (itinerary_element_has_upstream_context ?itinerary_element ?upstream_segment_context)
        (itinerary_element_has_downstream_context ?itinerary_element ?downstream_segment_context)
        (upstream_context_boarding_confirmed ?upstream_segment_context)
        (downstream_context_alighting_confirmed ?downstream_segment_context)
        (entity_has_service_option ?itinerary_element ?service_option)
        (not
          (itinerary_boarding_checks_completed ?itinerary_element)
        )
      )
    :effect (itinerary_boarding_checks_completed ?itinerary_element)
  )
  (:action authorize_itinerary_activation
    :parameters (?itinerary_element - itinerary_element)
    :precondition
      (and
        (itinerary_validated ?itinerary_element)
        (itinerary_boarding_checks_completed ?itinerary_element)
        (not
          (itinerary_element_activated ?itinerary_element)
        )
      )
    :effect
      (and
        (itinerary_element_activated ?itinerary_element)
        (ready_for_boarding ?itinerary_element)
      )
  )
  (:action lock_itinerary_credential
    :parameters (?itinerary_element - itinerary_element ?credential - credential ?service_option - service_option)
    :precondition
      (and
        (entity_service_confirmed ?itinerary_element)
        (entity_has_service_option ?itinerary_element ?service_option)
        (credential_available ?credential)
        (itinerary_has_credential ?itinerary_element ?credential)
        (not
          (itinerary_credential_locked ?itinerary_element)
        )
      )
    :effect
      (and
        (itinerary_credential_locked ?itinerary_element)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action apply_provider_confirmation
    :parameters (?itinerary_element - itinerary_element ?service_provider - service_provider)
    :precondition
      (and
        (itinerary_credential_locked ?itinerary_element)
        (entity_has_provider ?itinerary_element ?service_provider)
        (not
          (itinerary_credential_applied ?itinerary_element)
        )
      )
    :effect (itinerary_credential_applied ?itinerary_element)
  )
  (:action validate_itinerary_schedule_slot
    :parameters (?itinerary_element - itinerary_element ?schedule_slot - schedule_slot)
    :precondition
      (and
        (itinerary_credential_applied ?itinerary_element)
        (itinerary_element_assigned_schedule_slot ?itinerary_element ?schedule_slot)
        (not
          (itinerary_credential_validated ?itinerary_element)
        )
      )
    :effect (itinerary_credential_validated ?itinerary_element)
  )
  (:action finalize_itinerary_authorization
    :parameters (?itinerary_element - itinerary_element)
    :precondition
      (and
        (itinerary_credential_validated ?itinerary_element)
        (not
          (itinerary_element_activated ?itinerary_element)
        )
      )
    :effect
      (and
        (itinerary_element_activated ?itinerary_element)
        (ready_for_boarding ?itinerary_element)
      )
  )
  (:action allow_upstream_context_boarding
    :parameters (?upstream_segment_context - upstream_segment_context ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (upstream_context_boarding_ready ?upstream_segment_context)
        (upstream_context_boarding_confirmed ?upstream_segment_context)
        (vehicle_unit_reserved ?vehicle_unit)
        (vehicle_boarding_ready ?vehicle_unit)
        (not
          (ready_for_boarding ?upstream_segment_context)
        )
      )
    :effect (ready_for_boarding ?upstream_segment_context)
  )
  (:action allow_downstream_context_boarding
    :parameters (?downstream_segment_context - downstream_segment_context ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (downstream_context_alighting_ready ?downstream_segment_context)
        (downstream_context_alighting_confirmed ?downstream_segment_context)
        (vehicle_unit_reserved ?vehicle_unit)
        (vehicle_boarding_ready ?vehicle_unit)
        (not
          (ready_for_boarding ?downstream_segment_context)
        )
      )
    :effect (ready_for_boarding ?downstream_segment_context)
  )
  (:action reserve_time_buffer_for_segment
    :parameters (?trip_segment - trip_segment ?time_buffer - time_buffer ?service_option - service_option)
    :precondition
      (and
        (ready_for_boarding ?trip_segment)
        (entity_has_service_option ?trip_segment ?service_option)
        (time_buffer_available ?time_buffer)
        (not
          (entity_buffer_locked ?trip_segment)
        )
      )
    :effect
      (and
        (entity_buffer_locked ?trip_segment)
        (entity_time_buffer_assigned ?trip_segment ?time_buffer)
        (not
          (time_buffer_available ?time_buffer)
        )
      )
  )
  (:action confirm_segment_and_release_transfer_slot
    :parameters (?upstream_segment_context - upstream_segment_context ?transfer_slot - transfer_slot ?time_buffer - time_buffer)
    :precondition
      (and
        (entity_buffer_locked ?upstream_segment_context)
        (entity_has_transfer_slot ?upstream_segment_context ?transfer_slot)
        (entity_time_buffer_assigned ?upstream_segment_context ?time_buffer)
        (not
          (entity_confirmed ?upstream_segment_context)
        )
      )
    :effect
      (and
        (entity_confirmed ?upstream_segment_context)
        (transfer_slot_available ?transfer_slot)
        (time_buffer_available ?time_buffer)
      )
  )
  (:action confirm_downstream_context_and_release_transfer_slot
    :parameters (?downstream_segment_context - downstream_segment_context ?transfer_slot - transfer_slot ?time_buffer - time_buffer)
    :precondition
      (and
        (entity_buffer_locked ?downstream_segment_context)
        (entity_has_transfer_slot ?downstream_segment_context ?transfer_slot)
        (entity_time_buffer_assigned ?downstream_segment_context ?time_buffer)
        (not
          (entity_confirmed ?downstream_segment_context)
        )
      )
    :effect
      (and
        (entity_confirmed ?downstream_segment_context)
        (transfer_slot_available ?transfer_slot)
        (time_buffer_available ?time_buffer)
      )
  )
  (:action confirm_itinerary_and_release_transfer_slot
    :parameters (?itinerary_element - itinerary_element ?transfer_slot - transfer_slot ?time_buffer - time_buffer)
    :precondition
      (and
        (entity_buffer_locked ?itinerary_element)
        (entity_has_transfer_slot ?itinerary_element ?transfer_slot)
        (entity_time_buffer_assigned ?itinerary_element ?time_buffer)
        (not
          (entity_confirmed ?itinerary_element)
        )
      )
    :effect
      (and
        (entity_confirmed ?itinerary_element)
        (transfer_slot_available ?transfer_slot)
        (time_buffer_available ?time_buffer)
      )
  )
)

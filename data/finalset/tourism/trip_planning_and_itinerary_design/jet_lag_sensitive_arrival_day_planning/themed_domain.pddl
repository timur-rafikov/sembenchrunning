(define (domain jet_lag_arrival_day_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types planning_entity - object service_category - planning_entity amenities_category - planning_entity local_option_category - planning_entity arrival_day_plan - planning_entity traveler_request - arrival_day_plan transport_option - service_category arrival_time_window - service_category transfer_service - service_category room_feature - service_category special_service - service_category circadian_profile - service_category priority_service - service_category health_recommendation - service_category amenity_option - amenities_category package_component - amenities_category special_request - amenities_category daypart - local_option_category activity_category - local_option_category accommodation_option - local_option_category slot_group - traveler_request template_group - traveler_request itinerary_slot_primary - slot_group itinerary_slot_secondary - slot_group itinerary_template - template_group)

  (:predicates
    (request_registered ?traveler_request - traveler_request)
    (entity_schedule_candidate ?traveler_request - traveler_request)
    (transport_selected ?traveler_request - traveler_request)
    (entity_transport_binding_confirmed ?traveler_request - traveler_request)
    (entity_confirmation_flag ?traveler_request - traveler_request)
    (entity_circadian_profile_applied ?traveler_request - traveler_request)
    (transport_option_available ?transport_option - transport_option)
    (entity_assigned_transport ?traveler_request - traveler_request ?transport_option - transport_option)
    (arrival_window_available ?arrival_time_window - arrival_time_window)
    (entity_has_assigned_arrival_window ?traveler_request - traveler_request ?arrival_time_window - arrival_time_window)
    (transfer_service_available ?transfer_service - transfer_service)
    (entity_assigned_transfer_service ?traveler_request - traveler_request ?transfer_service - transfer_service)
    (amenity_available ?amenity_option - amenity_option)
    (assigned_amenity_primary ?itinerary_slot_primary - itinerary_slot_primary ?amenity_option - amenity_option)
    (assigned_amenity_secondary ?itinerary_slot_secondary - itinerary_slot_secondary ?amenity_option - amenity_option)
    (slot_daypart_compatible ?itinerary_slot_primary - itinerary_slot_primary ?daypart - daypart)
    (daypart_assigned ?daypart - daypart)
    (daypart_secondary_assigned ?daypart - daypart)
    (slot_ready_for_accommodation ?itinerary_slot_primary - itinerary_slot_primary)
    (slot_activity_compatible ?itinerary_slot_secondary - itinerary_slot_secondary ?activity_category - activity_category)
    (activity_assigned ?activity_category - activity_category)
    (activity_secondary_assigned ?activity_category - activity_category)
    (slot_secondary_ready ?itinerary_slot_secondary - itinerary_slot_secondary)
    (accommodation_available ?accommodation_option - accommodation_option)
    (accommodation_reserved ?accommodation_option - accommodation_option)
    (accommodation_daypart_compatible ?accommodation_option - accommodation_option ?daypart - daypart)
    (accommodation_activity_compatible ?accommodation_option - accommodation_option ?activity_category - activity_category)
    (accommodation_feature_primary ?accommodation_option - accommodation_option)
    (accommodation_feature_secondary ?accommodation_option - accommodation_option)
    (accommodation_booking_confirmed ?accommodation_option - accommodation_option)
    (template_includes_primary_slot ?itinerary_template - itinerary_template ?itinerary_slot_primary - itinerary_slot_primary)
    (template_includes_secondary_slot ?itinerary_template - itinerary_template ?itinerary_slot_secondary - itinerary_slot_secondary)
    (template_offers_accommodation ?itinerary_template - itinerary_template ?accommodation_option - accommodation_option)
    (package_component_available ?package_component - package_component)
    (template_includes_package_component ?itinerary_template - itinerary_template ?package_component - package_component)
    (package_component_selected ?package_component - package_component)
    (package_component_for_accommodation ?package_component - package_component ?accommodation_option - accommodation_option)
    (template_component_activated ?itinerary_template - itinerary_template)
    (template_services_allocated ?itinerary_template - itinerary_template)
    (template_ready_for_finalization ?itinerary_template - itinerary_template)
    (template_has_room_feature ?itinerary_template - itinerary_template)
    (template_room_feature_acknowledged ?itinerary_template - itinerary_template)
    (template_services_confirmed ?itinerary_template - itinerary_template)
    (template_components_committed ?itinerary_template - itinerary_template)
    (special_request_available ?special_request - special_request)
    (template_has_special_request ?itinerary_template - itinerary_template ?special_request - special_request)
    (special_request_attached ?itinerary_template - itinerary_template)
    (template_ready_for_special_processing ?itinerary_template - itinerary_template)
    (template_special_request_processed ?itinerary_template - itinerary_template)
    (room_feature_available ?room_feature - room_feature)
    (template_requested_room_feature ?itinerary_template - itinerary_template ?room_feature - room_feature)
    (special_service_available ?special_service - special_service)
    (template_assigned_special_service ?itinerary_template - itinerary_template ?special_service - special_service)
    (priority_service_available ?priority_service - priority_service)
    (template_assigned_priority_service ?itinerary_template - itinerary_template ?priority_service - priority_service)
    (health_recommendation_available ?health_recommendation - health_recommendation)
    (template_assigned_health_recommendation ?itinerary_template - itinerary_template ?health_recommendation - health_recommendation)
    (circadian_profile_available ?circadian_profile - circadian_profile)
    (entity_assigned_circadian_profile ?traveler_request - traveler_request ?circadian_profile - circadian_profile)
    (slot_prepared ?itinerary_slot_primary - itinerary_slot_primary)
    (slot_secondary_prepared ?itinerary_slot_secondary - itinerary_slot_secondary)
    (template_finalized ?itinerary_template - itinerary_template)
  )
  (:action create_planning_instance
    :parameters (?traveler_request - traveler_request)
    :precondition
      (and
        (not
          (request_registered ?traveler_request)
        )
        (not
          (entity_transport_binding_confirmed ?traveler_request)
        )
      )
    :effect (request_registered ?traveler_request)
  )
  (:action select_transport_option
    :parameters (?traveler_request - traveler_request ?transport_option - transport_option)
    :precondition
      (and
        (request_registered ?traveler_request)
        (not
          (transport_selected ?traveler_request)
        )
        (transport_option_available ?transport_option)
      )
    :effect
      (and
        (transport_selected ?traveler_request)
        (entity_assigned_transport ?traveler_request ?transport_option)
        (not
          (transport_option_available ?transport_option)
        )
      )
  )
  (:action assign_arrival_window
    :parameters (?traveler_request - traveler_request ?arrival_time_window - arrival_time_window)
    :precondition
      (and
        (request_registered ?traveler_request)
        (transport_selected ?traveler_request)
        (arrival_window_available ?arrival_time_window)
      )
    :effect
      (and
        (entity_has_assigned_arrival_window ?traveler_request ?arrival_time_window)
        (not
          (arrival_window_available ?arrival_time_window)
        )
      )
  )
  (:action mark_arrival_schedule_candidate
    :parameters (?traveler_request - traveler_request ?arrival_time_window - arrival_time_window)
    :precondition
      (and
        (request_registered ?traveler_request)
        (transport_selected ?traveler_request)
        (entity_has_assigned_arrival_window ?traveler_request ?arrival_time_window)
        (not
          (entity_schedule_candidate ?traveler_request)
        )
      )
    :effect (entity_schedule_candidate ?traveler_request)
  )
  (:action release_arrival_window
    :parameters (?traveler_request - traveler_request ?arrival_time_window - arrival_time_window)
    :precondition
      (and
        (entity_has_assigned_arrival_window ?traveler_request ?arrival_time_window)
      )
    :effect
      (and
        (arrival_window_available ?arrival_time_window)
        (not
          (entity_has_assigned_arrival_window ?traveler_request ?arrival_time_window)
        )
      )
  )
  (:action assign_transfer_service
    :parameters (?traveler_request - traveler_request ?transfer_service - transfer_service)
    :precondition
      (and
        (entity_schedule_candidate ?traveler_request)
        (transfer_service_available ?transfer_service)
      )
    :effect
      (and
        (entity_assigned_transfer_service ?traveler_request ?transfer_service)
        (not
          (transfer_service_available ?transfer_service)
        )
      )
  )
  (:action release_transfer_service
    :parameters (?traveler_request - traveler_request ?transfer_service - transfer_service)
    :precondition
      (and
        (entity_assigned_transfer_service ?traveler_request ?transfer_service)
      )
    :effect
      (and
        (transfer_service_available ?transfer_service)
        (not
          (entity_assigned_transfer_service ?traveler_request ?transfer_service)
        )
      )
  )
  (:action attach_priority_service_to_template
    :parameters (?itinerary_template - itinerary_template ?priority_service - priority_service)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_template)
        (priority_service_available ?priority_service)
      )
    :effect
      (and
        (template_assigned_priority_service ?itinerary_template ?priority_service)
        (not
          (priority_service_available ?priority_service)
        )
      )
  )
  (:action detach_priority_service_from_template
    :parameters (?itinerary_template - itinerary_template ?priority_service - priority_service)
    :precondition
      (and
        (template_assigned_priority_service ?itinerary_template ?priority_service)
      )
    :effect
      (and
        (priority_service_available ?priority_service)
        (not
          (template_assigned_priority_service ?itinerary_template ?priority_service)
        )
      )
  )
  (:action attach_health_recommendation_to_template
    :parameters (?itinerary_template - itinerary_template ?health_recommendation - health_recommendation)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_template)
        (health_recommendation_available ?health_recommendation)
      )
    :effect
      (and
        (template_assigned_health_recommendation ?itinerary_template ?health_recommendation)
        (not
          (health_recommendation_available ?health_recommendation)
        )
      )
  )
  (:action detach_health_recommendation_from_template
    :parameters (?itinerary_template - itinerary_template ?health_recommendation - health_recommendation)
    :precondition
      (and
        (template_assigned_health_recommendation ?itinerary_template ?health_recommendation)
      )
    :effect
      (and
        (health_recommendation_available ?health_recommendation)
        (not
          (template_assigned_health_recommendation ?itinerary_template ?health_recommendation)
        )
      )
  )
  (:action reserve_daypart_for_slot
    :parameters (?itinerary_slot_primary - itinerary_slot_primary ?daypart - daypart ?arrival_time_window - arrival_time_window)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_slot_primary)
        (entity_has_assigned_arrival_window ?itinerary_slot_primary ?arrival_time_window)
        (slot_daypart_compatible ?itinerary_slot_primary ?daypart)
        (not
          (daypart_assigned ?daypart)
        )
        (not
          (daypart_secondary_assigned ?daypart)
        )
      )
    :effect (daypart_assigned ?daypart)
  )
  (:action confirm_slot_with_transfer
    :parameters (?itinerary_slot_primary - itinerary_slot_primary ?daypart - daypart ?transfer_service - transfer_service)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_slot_primary)
        (entity_assigned_transfer_service ?itinerary_slot_primary ?transfer_service)
        (slot_daypart_compatible ?itinerary_slot_primary ?daypart)
        (daypart_assigned ?daypart)
        (not
          (slot_prepared ?itinerary_slot_primary)
        )
      )
    :effect
      (and
        (slot_prepared ?itinerary_slot_primary)
        (slot_ready_for_accommodation ?itinerary_slot_primary)
      )
  )
  (:action allocate_amenity_to_slot
    :parameters (?itinerary_slot_primary - itinerary_slot_primary ?daypart - daypart ?amenity_option - amenity_option)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_slot_primary)
        (slot_daypart_compatible ?itinerary_slot_primary ?daypart)
        (amenity_available ?amenity_option)
        (not
          (slot_prepared ?itinerary_slot_primary)
        )
      )
    :effect
      (and
        (daypart_secondary_assigned ?daypart)
        (slot_prepared ?itinerary_slot_primary)
        (assigned_amenity_primary ?itinerary_slot_primary ?amenity_option)
        (not
          (amenity_available ?amenity_option)
        )
      )
  )
  (:action process_amenity_and_daypart_for_slot
    :parameters (?itinerary_slot_primary - itinerary_slot_primary ?daypart - daypart ?arrival_time_window - arrival_time_window ?amenity_option - amenity_option)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_slot_primary)
        (entity_has_assigned_arrival_window ?itinerary_slot_primary ?arrival_time_window)
        (slot_daypart_compatible ?itinerary_slot_primary ?daypart)
        (daypart_secondary_assigned ?daypart)
        (assigned_amenity_primary ?itinerary_slot_primary ?amenity_option)
        (not
          (slot_ready_for_accommodation ?itinerary_slot_primary)
        )
      )
    :effect
      (and
        (daypart_assigned ?daypart)
        (slot_ready_for_accommodation ?itinerary_slot_primary)
        (amenity_available ?amenity_option)
        (not
          (assigned_amenity_primary ?itinerary_slot_primary ?amenity_option)
        )
      )
  )
  (:action reserve_activity_for_secondary_slot
    :parameters (?itinerary_slot_secondary - itinerary_slot_secondary ?activity_category - activity_category ?arrival_time_window - arrival_time_window)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_slot_secondary)
        (entity_has_assigned_arrival_window ?itinerary_slot_secondary ?arrival_time_window)
        (slot_activity_compatible ?itinerary_slot_secondary ?activity_category)
        (not
          (activity_assigned ?activity_category)
        )
        (not
          (activity_secondary_assigned ?activity_category)
        )
      )
    :effect (activity_assigned ?activity_category)
  )
  (:action confirm_secondary_slot_with_transfer
    :parameters (?itinerary_slot_secondary - itinerary_slot_secondary ?activity_category - activity_category ?transfer_service - transfer_service)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_slot_secondary)
        (entity_assigned_transfer_service ?itinerary_slot_secondary ?transfer_service)
        (slot_activity_compatible ?itinerary_slot_secondary ?activity_category)
        (activity_assigned ?activity_category)
        (not
          (slot_secondary_prepared ?itinerary_slot_secondary)
        )
      )
    :effect
      (and
        (slot_secondary_prepared ?itinerary_slot_secondary)
        (slot_secondary_ready ?itinerary_slot_secondary)
      )
  )
  (:action allocate_amenity_to_secondary_slot
    :parameters (?itinerary_slot_secondary - itinerary_slot_secondary ?activity_category - activity_category ?amenity_option - amenity_option)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_slot_secondary)
        (slot_activity_compatible ?itinerary_slot_secondary ?activity_category)
        (amenity_available ?amenity_option)
        (not
          (slot_secondary_prepared ?itinerary_slot_secondary)
        )
      )
    :effect
      (and
        (activity_secondary_assigned ?activity_category)
        (slot_secondary_prepared ?itinerary_slot_secondary)
        (assigned_amenity_secondary ?itinerary_slot_secondary ?amenity_option)
        (not
          (amenity_available ?amenity_option)
        )
      )
  )
  (:action process_amenity_and_activity_for_secondary_slot
    :parameters (?itinerary_slot_secondary - itinerary_slot_secondary ?activity_category - activity_category ?arrival_time_window - arrival_time_window ?amenity_option - amenity_option)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_slot_secondary)
        (entity_has_assigned_arrival_window ?itinerary_slot_secondary ?arrival_time_window)
        (slot_activity_compatible ?itinerary_slot_secondary ?activity_category)
        (activity_secondary_assigned ?activity_category)
        (assigned_amenity_secondary ?itinerary_slot_secondary ?amenity_option)
        (not
          (slot_secondary_ready ?itinerary_slot_secondary)
        )
      )
    :effect
      (and
        (activity_assigned ?activity_category)
        (slot_secondary_ready ?itinerary_slot_secondary)
        (amenity_available ?amenity_option)
        (not
          (assigned_amenity_secondary ?itinerary_slot_secondary ?amenity_option)
        )
      )
  )
  (:action select_and_reserve_accommodation
    :parameters (?itinerary_slot_primary - itinerary_slot_primary ?itinerary_slot_secondary - itinerary_slot_secondary ?daypart - daypart ?activity_category - activity_category ?accommodation_option - accommodation_option)
    :precondition
      (and
        (slot_prepared ?itinerary_slot_primary)
        (slot_secondary_prepared ?itinerary_slot_secondary)
        (slot_daypart_compatible ?itinerary_slot_primary ?daypart)
        (slot_activity_compatible ?itinerary_slot_secondary ?activity_category)
        (daypart_assigned ?daypart)
        (activity_assigned ?activity_category)
        (slot_ready_for_accommodation ?itinerary_slot_primary)
        (slot_secondary_ready ?itinerary_slot_secondary)
        (accommodation_available ?accommodation_option)
      )
    :effect
      (and
        (accommodation_reserved ?accommodation_option)
        (accommodation_daypart_compatible ?accommodation_option ?daypart)
        (accommodation_activity_compatible ?accommodation_option ?activity_category)
        (not
          (accommodation_available ?accommodation_option)
        )
      )
  )
  (:action reserve_accommodation_with_primary_feature
    :parameters (?itinerary_slot_primary - itinerary_slot_primary ?itinerary_slot_secondary - itinerary_slot_secondary ?daypart - daypart ?activity_category - activity_category ?accommodation_option - accommodation_option)
    :precondition
      (and
        (slot_prepared ?itinerary_slot_primary)
        (slot_secondary_prepared ?itinerary_slot_secondary)
        (slot_daypart_compatible ?itinerary_slot_primary ?daypart)
        (slot_activity_compatible ?itinerary_slot_secondary ?activity_category)
        (daypart_secondary_assigned ?daypart)
        (activity_assigned ?activity_category)
        (not
          (slot_ready_for_accommodation ?itinerary_slot_primary)
        )
        (slot_secondary_ready ?itinerary_slot_secondary)
        (accommodation_available ?accommodation_option)
      )
    :effect
      (and
        (accommodation_reserved ?accommodation_option)
        (accommodation_daypart_compatible ?accommodation_option ?daypart)
        (accommodation_activity_compatible ?accommodation_option ?activity_category)
        (accommodation_feature_primary ?accommodation_option)
        (not
          (accommodation_available ?accommodation_option)
        )
      )
  )
  (:action reserve_accommodation_with_secondary_feature
    :parameters (?itinerary_slot_primary - itinerary_slot_primary ?itinerary_slot_secondary - itinerary_slot_secondary ?daypart - daypart ?activity_category - activity_category ?accommodation_option - accommodation_option)
    :precondition
      (and
        (slot_prepared ?itinerary_slot_primary)
        (slot_secondary_prepared ?itinerary_slot_secondary)
        (slot_daypart_compatible ?itinerary_slot_primary ?daypart)
        (slot_activity_compatible ?itinerary_slot_secondary ?activity_category)
        (daypart_assigned ?daypart)
        (activity_secondary_assigned ?activity_category)
        (slot_ready_for_accommodation ?itinerary_slot_primary)
        (not
          (slot_secondary_ready ?itinerary_slot_secondary)
        )
        (accommodation_available ?accommodation_option)
      )
    :effect
      (and
        (accommodation_reserved ?accommodation_option)
        (accommodation_daypart_compatible ?accommodation_option ?daypart)
        (accommodation_activity_compatible ?accommodation_option ?activity_category)
        (accommodation_feature_secondary ?accommodation_option)
        (not
          (accommodation_available ?accommodation_option)
        )
      )
  )
  (:action reserve_accommodation_with_both_features
    :parameters (?itinerary_slot_primary - itinerary_slot_primary ?itinerary_slot_secondary - itinerary_slot_secondary ?daypart - daypart ?activity_category - activity_category ?accommodation_option - accommodation_option)
    :precondition
      (and
        (slot_prepared ?itinerary_slot_primary)
        (slot_secondary_prepared ?itinerary_slot_secondary)
        (slot_daypart_compatible ?itinerary_slot_primary ?daypart)
        (slot_activity_compatible ?itinerary_slot_secondary ?activity_category)
        (daypart_secondary_assigned ?daypart)
        (activity_secondary_assigned ?activity_category)
        (not
          (slot_ready_for_accommodation ?itinerary_slot_primary)
        )
        (not
          (slot_secondary_ready ?itinerary_slot_secondary)
        )
        (accommodation_available ?accommodation_option)
      )
    :effect
      (and
        (accommodation_reserved ?accommodation_option)
        (accommodation_daypart_compatible ?accommodation_option ?daypart)
        (accommodation_activity_compatible ?accommodation_option ?activity_category)
        (accommodation_feature_primary ?accommodation_option)
        (accommodation_feature_secondary ?accommodation_option)
        (not
          (accommodation_available ?accommodation_option)
        )
      )
  )
  (:action confirm_accommodation_booking
    :parameters (?accommodation_option - accommodation_option ?itinerary_slot_primary - itinerary_slot_primary ?arrival_time_window - arrival_time_window)
    :precondition
      (and
        (accommodation_reserved ?accommodation_option)
        (slot_prepared ?itinerary_slot_primary)
        (entity_has_assigned_arrival_window ?itinerary_slot_primary ?arrival_time_window)
        (not
          (accommodation_booking_confirmed ?accommodation_option)
        )
      )
    :effect (accommodation_booking_confirmed ?accommodation_option)
  )
  (:action attach_package_component_to_template
    :parameters (?itinerary_template - itinerary_template ?package_component - package_component ?accommodation_option - accommodation_option)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_template)
        (template_offers_accommodation ?itinerary_template ?accommodation_option)
        (template_includes_package_component ?itinerary_template ?package_component)
        (package_component_available ?package_component)
        (accommodation_reserved ?accommodation_option)
        (accommodation_booking_confirmed ?accommodation_option)
        (not
          (package_component_selected ?package_component)
        )
      )
    :effect
      (and
        (package_component_selected ?package_component)
        (package_component_for_accommodation ?package_component ?accommodation_option)
        (not
          (package_component_available ?package_component)
        )
      )
  )
  (:action activate_package_component_for_template
    :parameters (?itinerary_template - itinerary_template ?package_component - package_component ?accommodation_option - accommodation_option ?arrival_time_window - arrival_time_window)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_template)
        (template_includes_package_component ?itinerary_template ?package_component)
        (package_component_selected ?package_component)
        (package_component_for_accommodation ?package_component ?accommodation_option)
        (entity_has_assigned_arrival_window ?itinerary_template ?arrival_time_window)
        (not
          (accommodation_feature_primary ?accommodation_option)
        )
        (not
          (template_component_activated ?itinerary_template)
        )
      )
    :effect (template_component_activated ?itinerary_template)
  )
  (:action assign_room_feature_to_template
    :parameters (?itinerary_template - itinerary_template ?room_feature - room_feature)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_template)
        (room_feature_available ?room_feature)
        (not
          (template_has_room_feature ?itinerary_template)
        )
      )
    :effect
      (and
        (template_has_room_feature ?itinerary_template)
        (template_requested_room_feature ?itinerary_template ?room_feature)
        (not
          (room_feature_available ?room_feature)
        )
      )
  )
  (:action apply_room_feature_and_activate_template
    :parameters (?itinerary_template - itinerary_template ?package_component - package_component ?accommodation_option - accommodation_option ?arrival_time_window - arrival_time_window ?room_feature - room_feature)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_template)
        (template_includes_package_component ?itinerary_template ?package_component)
        (package_component_selected ?package_component)
        (package_component_for_accommodation ?package_component ?accommodation_option)
        (entity_has_assigned_arrival_window ?itinerary_template ?arrival_time_window)
        (accommodation_feature_primary ?accommodation_option)
        (template_has_room_feature ?itinerary_template)
        (template_requested_room_feature ?itinerary_template ?room_feature)
        (not
          (template_component_activated ?itinerary_template)
        )
      )
    :effect
      (and
        (template_component_activated ?itinerary_template)
        (template_room_feature_acknowledged ?itinerary_template)
      )
  )
  (:action allocate_priority_service_for_template
    :parameters (?itinerary_template - itinerary_template ?priority_service - priority_service ?transfer_service - transfer_service ?package_component - package_component ?accommodation_option - accommodation_option)
    :precondition
      (and
        (template_component_activated ?itinerary_template)
        (template_assigned_priority_service ?itinerary_template ?priority_service)
        (entity_assigned_transfer_service ?itinerary_template ?transfer_service)
        (template_includes_package_component ?itinerary_template ?package_component)
        (package_component_for_accommodation ?package_component ?accommodation_option)
        (not
          (accommodation_feature_secondary ?accommodation_option)
        )
        (not
          (template_services_allocated ?itinerary_template)
        )
      )
    :effect (template_services_allocated ?itinerary_template)
  )
  (:action allocate_priority_service_variant
    :parameters (?itinerary_template - itinerary_template ?priority_service - priority_service ?transfer_service - transfer_service ?package_component - package_component ?accommodation_option - accommodation_option)
    :precondition
      (and
        (template_component_activated ?itinerary_template)
        (template_assigned_priority_service ?itinerary_template ?priority_service)
        (entity_assigned_transfer_service ?itinerary_template ?transfer_service)
        (template_includes_package_component ?itinerary_template ?package_component)
        (package_component_for_accommodation ?package_component ?accommodation_option)
        (accommodation_feature_secondary ?accommodation_option)
        (not
          (template_services_allocated ?itinerary_template)
        )
      )
    :effect (template_services_allocated ?itinerary_template)
  )
  (:action prepare_template_for_health_recommendation
    :parameters (?itinerary_template - itinerary_template ?health_recommendation - health_recommendation ?package_component - package_component ?accommodation_option - accommodation_option)
    :precondition
      (and
        (template_services_allocated ?itinerary_template)
        (template_assigned_health_recommendation ?itinerary_template ?health_recommendation)
        (template_includes_package_component ?itinerary_template ?package_component)
        (package_component_for_accommodation ?package_component ?accommodation_option)
        (not
          (accommodation_feature_primary ?accommodation_option)
        )
        (not
          (accommodation_feature_secondary ?accommodation_option)
        )
        (not
          (template_ready_for_finalization ?itinerary_template)
        )
      )
    :effect (template_ready_for_finalization ?itinerary_template)
  )
  (:action confirm_health_recommendation_and_services
    :parameters (?itinerary_template - itinerary_template ?health_recommendation - health_recommendation ?package_component - package_component ?accommodation_option - accommodation_option)
    :precondition
      (and
        (template_services_allocated ?itinerary_template)
        (template_assigned_health_recommendation ?itinerary_template ?health_recommendation)
        (template_includes_package_component ?itinerary_template ?package_component)
        (package_component_for_accommodation ?package_component ?accommodation_option)
        (accommodation_feature_primary ?accommodation_option)
        (not
          (accommodation_feature_secondary ?accommodation_option)
        )
        (not
          (template_ready_for_finalization ?itinerary_template)
        )
      )
    :effect
      (and
        (template_ready_for_finalization ?itinerary_template)
        (template_services_confirmed ?itinerary_template)
      )
  )
  (:action confirm_health_recommendation_and_services_alt
    :parameters (?itinerary_template - itinerary_template ?health_recommendation - health_recommendation ?package_component - package_component ?accommodation_option - accommodation_option)
    :precondition
      (and
        (template_services_allocated ?itinerary_template)
        (template_assigned_health_recommendation ?itinerary_template ?health_recommendation)
        (template_includes_package_component ?itinerary_template ?package_component)
        (package_component_for_accommodation ?package_component ?accommodation_option)
        (not
          (accommodation_feature_primary ?accommodation_option)
        )
        (accommodation_feature_secondary ?accommodation_option)
        (not
          (template_ready_for_finalization ?itinerary_template)
        )
      )
    :effect
      (and
        (template_ready_for_finalization ?itinerary_template)
        (template_services_confirmed ?itinerary_template)
      )
  )
  (:action confirm_health_recommendation_and_all_services
    :parameters (?itinerary_template - itinerary_template ?health_recommendation - health_recommendation ?package_component - package_component ?accommodation_option - accommodation_option)
    :precondition
      (and
        (template_services_allocated ?itinerary_template)
        (template_assigned_health_recommendation ?itinerary_template ?health_recommendation)
        (template_includes_package_component ?itinerary_template ?package_component)
        (package_component_for_accommodation ?package_component ?accommodation_option)
        (accommodation_feature_primary ?accommodation_option)
        (accommodation_feature_secondary ?accommodation_option)
        (not
          (template_ready_for_finalization ?itinerary_template)
        )
      )
    :effect
      (and
        (template_ready_for_finalization ?itinerary_template)
        (template_services_confirmed ?itinerary_template)
      )
  )
  (:action finalize_template_confirmation
    :parameters (?itinerary_template - itinerary_template)
    :precondition
      (and
        (template_ready_for_finalization ?itinerary_template)
        (not
          (template_services_confirmed ?itinerary_template)
        )
        (not
          (template_finalized ?itinerary_template)
        )
      )
    :effect
      (and
        (template_finalized ?itinerary_template)
        (entity_confirmation_flag ?itinerary_template)
      )
  )
  (:action attach_special_service_to_template
    :parameters (?itinerary_template - itinerary_template ?special_service - special_service)
    :precondition
      (and
        (template_ready_for_finalization ?itinerary_template)
        (template_services_confirmed ?itinerary_template)
        (special_service_available ?special_service)
      )
    :effect
      (and
        (template_assigned_special_service ?itinerary_template ?special_service)
        (not
          (special_service_available ?special_service)
        )
      )
  )
  (:action finalize_services_for_template_and_slots
    :parameters (?itinerary_template - itinerary_template ?itinerary_slot_primary - itinerary_slot_primary ?itinerary_slot_secondary - itinerary_slot_secondary ?arrival_time_window - arrival_time_window ?special_service - special_service)
    :precondition
      (and
        (template_ready_for_finalization ?itinerary_template)
        (template_services_confirmed ?itinerary_template)
        (template_assigned_special_service ?itinerary_template ?special_service)
        (template_includes_primary_slot ?itinerary_template ?itinerary_slot_primary)
        (template_includes_secondary_slot ?itinerary_template ?itinerary_slot_secondary)
        (slot_ready_for_accommodation ?itinerary_slot_primary)
        (slot_secondary_ready ?itinerary_slot_secondary)
        (entity_has_assigned_arrival_window ?itinerary_template ?arrival_time_window)
        (not
          (template_components_committed ?itinerary_template)
        )
      )
    :effect (template_components_committed ?itinerary_template)
  )
  (:action confirm_template_and_mark_final
    :parameters (?itinerary_template - itinerary_template)
    :precondition
      (and
        (template_ready_for_finalization ?itinerary_template)
        (template_components_committed ?itinerary_template)
        (not
          (template_finalized ?itinerary_template)
        )
      )
    :effect
      (and
        (template_finalized ?itinerary_template)
        (entity_confirmation_flag ?itinerary_template)
      )
  )
  (:action process_special_request_attachment
    :parameters (?itinerary_template - itinerary_template ?special_request - special_request ?arrival_time_window - arrival_time_window)
    :precondition
      (and
        (entity_schedule_candidate ?itinerary_template)
        (entity_has_assigned_arrival_window ?itinerary_template ?arrival_time_window)
        (special_request_available ?special_request)
        (template_has_special_request ?itinerary_template ?special_request)
        (not
          (special_request_attached ?itinerary_template)
        )
      )
    :effect
      (and
        (special_request_attached ?itinerary_template)
        (not
          (special_request_available ?special_request)
        )
      )
  )
  (:action mark_template_ready_for_special_request
    :parameters (?itinerary_template - itinerary_template ?transfer_service - transfer_service)
    :precondition
      (and
        (special_request_attached ?itinerary_template)
        (entity_assigned_transfer_service ?itinerary_template ?transfer_service)
        (not
          (template_ready_for_special_processing ?itinerary_template)
        )
      )
    :effect (template_ready_for_special_processing ?itinerary_template)
  )
  (:action process_special_request_with_health_recommendation
    :parameters (?itinerary_template - itinerary_template ?health_recommendation - health_recommendation)
    :precondition
      (and
        (template_ready_for_special_processing ?itinerary_template)
        (template_assigned_health_recommendation ?itinerary_template ?health_recommendation)
        (not
          (template_special_request_processed ?itinerary_template)
        )
      )
    :effect (template_special_request_processed ?itinerary_template)
  )
  (:action finalize_template_after_special_request
    :parameters (?itinerary_template - itinerary_template)
    :precondition
      (and
        (template_special_request_processed ?itinerary_template)
        (not
          (template_finalized ?itinerary_template)
        )
      )
    :effect
      (and
        (template_finalized ?itinerary_template)
        (entity_confirmation_flag ?itinerary_template)
      )
  )
  (:action confirm_primary_slot
    :parameters (?itinerary_slot_primary - itinerary_slot_primary ?accommodation_option - accommodation_option)
    :precondition
      (and
        (slot_prepared ?itinerary_slot_primary)
        (slot_ready_for_accommodation ?itinerary_slot_primary)
        (accommodation_reserved ?accommodation_option)
        (accommodation_booking_confirmed ?accommodation_option)
        (not
          (entity_confirmation_flag ?itinerary_slot_primary)
        )
      )
    :effect (entity_confirmation_flag ?itinerary_slot_primary)
  )
  (:action confirm_secondary_slot
    :parameters (?itinerary_slot_secondary - itinerary_slot_secondary ?accommodation_option - accommodation_option)
    :precondition
      (and
        (slot_secondary_prepared ?itinerary_slot_secondary)
        (slot_secondary_ready ?itinerary_slot_secondary)
        (accommodation_reserved ?accommodation_option)
        (accommodation_booking_confirmed ?accommodation_option)
        (not
          (entity_confirmation_flag ?itinerary_slot_secondary)
        )
      )
    :effect (entity_confirmation_flag ?itinerary_slot_secondary)
  )
  (:action apply_circadian_profile_to_request
    :parameters (?traveler_request - traveler_request ?circadian_profile - circadian_profile ?arrival_time_window - arrival_time_window)
    :precondition
      (and
        (entity_confirmation_flag ?traveler_request)
        (entity_has_assigned_arrival_window ?traveler_request ?arrival_time_window)
        (circadian_profile_available ?circadian_profile)
        (not
          (entity_circadian_profile_applied ?traveler_request)
        )
      )
    :effect
      (and
        (entity_circadian_profile_applied ?traveler_request)
        (entity_assigned_circadian_profile ?traveler_request ?circadian_profile)
        (not
          (circadian_profile_available ?circadian_profile)
        )
      )
  )
  (:action bind_transport_and_confirm_slot
    :parameters (?itinerary_slot_primary - itinerary_slot_primary ?transport_option - transport_option ?circadian_profile - circadian_profile)
    :precondition
      (and
        (entity_circadian_profile_applied ?itinerary_slot_primary)
        (entity_assigned_transport ?itinerary_slot_primary ?transport_option)
        (entity_assigned_circadian_profile ?itinerary_slot_primary ?circadian_profile)
        (not
          (entity_transport_binding_confirmed ?itinerary_slot_primary)
        )
      )
    :effect
      (and
        (entity_transport_binding_confirmed ?itinerary_slot_primary)
        (transport_option_available ?transport_option)
        (circadian_profile_available ?circadian_profile)
      )
  )
  (:action bind_transport_and_confirm_secondary_slot
    :parameters (?itinerary_slot_secondary - itinerary_slot_secondary ?transport_option - transport_option ?circadian_profile - circadian_profile)
    :precondition
      (and
        (entity_circadian_profile_applied ?itinerary_slot_secondary)
        (entity_assigned_transport ?itinerary_slot_secondary ?transport_option)
        (entity_assigned_circadian_profile ?itinerary_slot_secondary ?circadian_profile)
        (not
          (entity_transport_binding_confirmed ?itinerary_slot_secondary)
        )
      )
    :effect
      (and
        (entity_transport_binding_confirmed ?itinerary_slot_secondary)
        (transport_option_available ?transport_option)
        (circadian_profile_available ?circadian_profile)
      )
  )
  (:action bind_transport_and_confirm_template
    :parameters (?itinerary_template - itinerary_template ?transport_option - transport_option ?circadian_profile - circadian_profile)
    :precondition
      (and
        (entity_circadian_profile_applied ?itinerary_template)
        (entity_assigned_transport ?itinerary_template ?transport_option)
        (entity_assigned_circadian_profile ?itinerary_template ?circadian_profile)
        (not
          (entity_transport_binding_confirmed ?itinerary_template)
        )
      )
    :effect
      (and
        (entity_transport_binding_confirmed ?itinerary_template)
        (transport_option_available ?transport_option)
        (circadian_profile_available ?circadian_profile)
      )
  )
)

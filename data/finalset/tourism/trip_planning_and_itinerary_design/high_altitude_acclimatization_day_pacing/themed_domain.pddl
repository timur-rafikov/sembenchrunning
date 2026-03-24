(define (domain high_altitude_acclimatization_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types service_resource - object resource_item_group - object location_characteristic_group - object itinerary_component - object itinerary_element - itinerary_component transport_option - service_resource time_slot - service_resource personnel_resource - service_resource meal_option - service_resource weather_window - service_resource acclimatization_profile - service_resource medical_supply - service_resource safety_briefing - service_resource consumable_equipment - resource_item_group permit_document - resource_item_group optional_excursion - resource_item_group altitude_zone - location_characteristic_group terrain_class - location_characteristic_group accommodation - location_characteristic_group day_category - itinerary_element day_subcategory - itinerary_element acclimatization_day - day_category activity_day - day_category itinerary_variant - day_subcategory)
  (:predicates
    (itinerary_element_initialized ?itinerary_element - itinerary_element)
    (itinerary_element_prepared ?itinerary_element - itinerary_element)
    (element_transport_reserved ?itinerary_element - itinerary_element)
    (itinerary_element_confirmed ?itinerary_element - itinerary_element)
    (element_ready ?itinerary_element - itinerary_element)
    (acclimatization_profile_assigned ?itinerary_element - itinerary_element)
    (transport_available ?transport_option - transport_option)
    (transport_allocated_to_element ?itinerary_element - itinerary_element ?transport_option - transport_option)
    (time_slot_available ?time_slot - time_slot)
    (time_slot_assigned ?itinerary_element - itinerary_element ?time_slot - time_slot)
    (personnel_available ?personnel_resource - personnel_resource)
    (personnel_assigned_to_element ?itinerary_element - itinerary_element ?personnel_resource - personnel_resource)
    (equipment_available ?consumable_equipment - consumable_equipment)
    (equipment_assigned_to_acclimatization_day ?acclimatization_day - acclimatization_day ?consumable_equipment - consumable_equipment)
    (equipment_assigned_to_activity_day ?activity_day - activity_day ?consumable_equipment - consumable_equipment)
    (day_in_altitude_zone ?acclimatization_day - acclimatization_day ?altitude_zone - altitude_zone)
    (altitude_zone_activated ?altitude_zone - altitude_zone)
    (altitude_zone_equipment_allocated ?altitude_zone - altitude_zone)
    (day_ready_for_accommodation ?acclimatization_day - acclimatization_day)
    (activity_day_in_terrain_class ?activity_day - activity_day ?terrain_class - terrain_class)
    (terrain_class_activated ?terrain_class - terrain_class)
    (terrain_class_equipment_assigned ?terrain_class - terrain_class)
    (activity_day_ready_for_accommodation ?activity_day - activity_day)
    (accommodation_available ?accommodation - accommodation)
    (accommodation_reserved ?accommodation - accommodation)
    (accommodation_at_altitude_zone ?accommodation - accommodation ?altitude_zone - altitude_zone)
    (accommodation_at_terrain_class ?accommodation - accommodation ?terrain_class - terrain_class)
    (accommodation_supports_meals ?accommodation - accommodation)
    (accommodation_supports_medical_storage ?accommodation - accommodation)
    (accommodation_time_slot_confirmed ?accommodation - accommodation)
    (variant_includes_acclimatization_day ?itinerary_variant - itinerary_variant ?acclimatization_day - acclimatization_day)
    (variant_includes_activity_day ?itinerary_variant - itinerary_variant ?activity_day - activity_day)
    (variant_includes_accommodation ?itinerary_variant - itinerary_variant ?accommodation - accommodation)
    (permit_available ?permit_document - permit_document)
    (variant_has_permit_requirement ?itinerary_variant - itinerary_variant ?permit_document - permit_document)
    (permit_attached ?permit_document - permit_document)
    (permit_attached_to_accommodation ?permit_document - permit_document ?accommodation - accommodation)
    (variant_accommodation_validated ?itinerary_variant - itinerary_variant)
    (variant_medical_supplies_allocated ?itinerary_variant - itinerary_variant)
    (variant_safety_briefing_completed ?itinerary_variant - itinerary_variant)
    (variant_has_meal_option ?itinerary_variant - itinerary_variant)
    (variant_meal_validated ?itinerary_variant - itinerary_variant)
    (variant_requires_weather_window ?itinerary_variant - itinerary_variant)
    (variant_components_integrated ?itinerary_variant - itinerary_variant)
    (optional_excursion_available ?optional_excursion - optional_excursion)
    (variant_has_optional_excursion ?itinerary_variant - itinerary_variant ?optional_excursion - optional_excursion)
    (variant_optional_excursion_confirmed ?itinerary_variant - itinerary_variant)
    (variant_excursion_prepared ?itinerary_variant - itinerary_variant)
    (variant_excursion_briefing_completed ?itinerary_variant - itinerary_variant)
    (meal_option_available ?meal_option - meal_option)
    (variant_meal_assigned ?itinerary_variant - itinerary_variant ?meal_option - meal_option)
    (weather_window_available ?weather_window - weather_window)
    (variant_has_weather_window ?itinerary_variant - itinerary_variant ?weather_window - weather_window)
    (medical_supply_available ?medical_supply - medical_supply)
    (medical_supply_assigned_to_variant ?itinerary_variant - itinerary_variant ?medical_supply - medical_supply)
    (safety_briefing_available ?safety_briefing - safety_briefing)
    (safety_briefing_assigned_to_variant ?itinerary_variant - itinerary_variant ?safety_briefing - safety_briefing)
    (acclimatization_profile_available ?acclimatization_profile - acclimatization_profile)
    (element_assigned_acclimatization_profile ?itinerary_element - itinerary_element ?acclimatization_profile - acclimatization_profile)
    (acclimatization_day_allocation_flag ?acclimatization_day - acclimatization_day)
    (activity_day_allocation_flag ?activity_day - activity_day)
    (variant_booked_marker ?itinerary_variant - itinerary_variant)
  )
  (:action initialize_itinerary_element
    :parameters (?itinerary_element - itinerary_element)
    :precondition
      (and
        (not
          (itinerary_element_initialized ?itinerary_element)
        )
        (not
          (itinerary_element_confirmed ?itinerary_element)
        )
      )
    :effect (itinerary_element_initialized ?itinerary_element)
  )
  (:action allocate_transport_to_element
    :parameters (?itinerary_element - itinerary_element ?transport_option - transport_option)
    :precondition
      (and
        (itinerary_element_initialized ?itinerary_element)
        (not
          (element_transport_reserved ?itinerary_element)
        )
        (transport_available ?transport_option)
      )
    :effect
      (and
        (element_transport_reserved ?itinerary_element)
        (transport_allocated_to_element ?itinerary_element ?transport_option)
        (not
          (transport_available ?transport_option)
        )
      )
  )
  (:action assign_time_slot
    :parameters (?itinerary_element - itinerary_element ?time_slot - time_slot)
    :precondition
      (and
        (itinerary_element_initialized ?itinerary_element)
        (element_transport_reserved ?itinerary_element)
        (time_slot_available ?time_slot)
      )
    :effect
      (and
        (time_slot_assigned ?itinerary_element ?time_slot)
        (not
          (time_slot_available ?time_slot)
        )
      )
  )
  (:action finalize_element_preparation
    :parameters (?itinerary_element - itinerary_element ?time_slot - time_slot)
    :precondition
      (and
        (itinerary_element_initialized ?itinerary_element)
        (element_transport_reserved ?itinerary_element)
        (time_slot_assigned ?itinerary_element ?time_slot)
        (not
          (itinerary_element_prepared ?itinerary_element)
        )
      )
    :effect (itinerary_element_prepared ?itinerary_element)
  )
  (:action release_time_slot
    :parameters (?itinerary_element - itinerary_element ?time_slot - time_slot)
    :precondition
      (and
        (time_slot_assigned ?itinerary_element ?time_slot)
      )
    :effect
      (and
        (time_slot_available ?time_slot)
        (not
          (time_slot_assigned ?itinerary_element ?time_slot)
        )
      )
  )
  (:action assign_personnel
    :parameters (?itinerary_element - itinerary_element ?personnel_resource - personnel_resource)
    :precondition
      (and
        (itinerary_element_prepared ?itinerary_element)
        (personnel_available ?personnel_resource)
      )
    :effect
      (and
        (personnel_assigned_to_element ?itinerary_element ?personnel_resource)
        (not
          (personnel_available ?personnel_resource)
        )
      )
  )
  (:action release_personnel
    :parameters (?itinerary_element - itinerary_element ?personnel_resource - personnel_resource)
    :precondition
      (and
        (personnel_assigned_to_element ?itinerary_element ?personnel_resource)
      )
    :effect
      (and
        (personnel_available ?personnel_resource)
        (not
          (personnel_assigned_to_element ?itinerary_element ?personnel_resource)
        )
      )
  )
  (:action assign_medical_supply_to_variant
    :parameters (?itinerary_variant - itinerary_variant ?medical_supply - medical_supply)
    :precondition
      (and
        (itinerary_element_prepared ?itinerary_variant)
        (medical_supply_available ?medical_supply)
      )
    :effect
      (and
        (medical_supply_assigned_to_variant ?itinerary_variant ?medical_supply)
        (not
          (medical_supply_available ?medical_supply)
        )
      )
  )
  (:action release_medical_supply_from_variant
    :parameters (?itinerary_variant - itinerary_variant ?medical_supply - medical_supply)
    :precondition
      (and
        (medical_supply_assigned_to_variant ?itinerary_variant ?medical_supply)
      )
    :effect
      (and
        (medical_supply_available ?medical_supply)
        (not
          (medical_supply_assigned_to_variant ?itinerary_variant ?medical_supply)
        )
      )
  )
  (:action assign_safety_briefing_to_variant
    :parameters (?itinerary_variant - itinerary_variant ?safety_briefing - safety_briefing)
    :precondition
      (and
        (itinerary_element_prepared ?itinerary_variant)
        (safety_briefing_available ?safety_briefing)
      )
    :effect
      (and
        (safety_briefing_assigned_to_variant ?itinerary_variant ?safety_briefing)
        (not
          (safety_briefing_available ?safety_briefing)
        )
      )
  )
  (:action release_safety_briefing
    :parameters (?itinerary_variant - itinerary_variant ?safety_briefing - safety_briefing)
    :precondition
      (and
        (safety_briefing_assigned_to_variant ?itinerary_variant ?safety_briefing)
      )
    :effect
      (and
        (safety_briefing_available ?safety_briefing)
        (not
          (safety_briefing_assigned_to_variant ?itinerary_variant ?safety_briefing)
        )
      )
  )
  (:action activate_altitude_zone_for_day
    :parameters (?acclimatization_day - acclimatization_day ?altitude_zone - altitude_zone ?time_slot - time_slot)
    :precondition
      (and
        (itinerary_element_prepared ?acclimatization_day)
        (time_slot_assigned ?acclimatization_day ?time_slot)
        (day_in_altitude_zone ?acclimatization_day ?altitude_zone)
        (not
          (altitude_zone_activated ?altitude_zone)
        )
        (not
          (altitude_zone_equipment_allocated ?altitude_zone)
        )
      )
    :effect (altitude_zone_activated ?altitude_zone)
  )
  (:action confirm_day_personnel_and_mark_ready
    :parameters (?acclimatization_day - acclimatization_day ?altitude_zone - altitude_zone ?personnel_resource - personnel_resource)
    :precondition
      (and
        (itinerary_element_prepared ?acclimatization_day)
        (personnel_assigned_to_element ?acclimatization_day ?personnel_resource)
        (day_in_altitude_zone ?acclimatization_day ?altitude_zone)
        (altitude_zone_activated ?altitude_zone)
        (not
          (acclimatization_day_allocation_flag ?acclimatization_day)
        )
      )
    :effect
      (and
        (acclimatization_day_allocation_flag ?acclimatization_day)
        (day_ready_for_accommodation ?acclimatization_day)
      )
  )
  (:action allocate_equipment_to_acclimatization_day
    :parameters (?acclimatization_day - acclimatization_day ?altitude_zone - altitude_zone ?consumable_equipment - consumable_equipment)
    :precondition
      (and
        (itinerary_element_prepared ?acclimatization_day)
        (day_in_altitude_zone ?acclimatization_day ?altitude_zone)
        (equipment_available ?consumable_equipment)
        (not
          (acclimatization_day_allocation_flag ?acclimatization_day)
        )
      )
    :effect
      (and
        (altitude_zone_equipment_allocated ?altitude_zone)
        (acclimatization_day_allocation_flag ?acclimatization_day)
        (equipment_assigned_to_acclimatization_day ?acclimatization_day ?consumable_equipment)
        (not
          (equipment_available ?consumable_equipment)
        )
      )
  )
  (:action execute_acclimatization_activity
    :parameters (?acclimatization_day - acclimatization_day ?altitude_zone - altitude_zone ?time_slot - time_slot ?consumable_equipment - consumable_equipment)
    :precondition
      (and
        (itinerary_element_prepared ?acclimatization_day)
        (time_slot_assigned ?acclimatization_day ?time_slot)
        (day_in_altitude_zone ?acclimatization_day ?altitude_zone)
        (altitude_zone_equipment_allocated ?altitude_zone)
        (equipment_assigned_to_acclimatization_day ?acclimatization_day ?consumable_equipment)
        (not
          (day_ready_for_accommodation ?acclimatization_day)
        )
      )
    :effect
      (and
        (altitude_zone_activated ?altitude_zone)
        (day_ready_for_accommodation ?acclimatization_day)
        (equipment_available ?consumable_equipment)
        (not
          (equipment_assigned_to_acclimatization_day ?acclimatization_day ?consumable_equipment)
        )
      )
  )
  (:action activate_terrain_for_activity
    :parameters (?activity_day - activity_day ?terrain_class - terrain_class ?time_slot - time_slot)
    :precondition
      (and
        (itinerary_element_prepared ?activity_day)
        (time_slot_assigned ?activity_day ?time_slot)
        (activity_day_in_terrain_class ?activity_day ?terrain_class)
        (not
          (terrain_class_activated ?terrain_class)
        )
        (not
          (terrain_class_equipment_assigned ?terrain_class)
        )
      )
    :effect (terrain_class_activated ?terrain_class)
  )
  (:action confirm_activity_personnel_and_mark_ready
    :parameters (?activity_day - activity_day ?terrain_class - terrain_class ?personnel_resource - personnel_resource)
    :precondition
      (and
        (itinerary_element_prepared ?activity_day)
        (personnel_assigned_to_element ?activity_day ?personnel_resource)
        (activity_day_in_terrain_class ?activity_day ?terrain_class)
        (terrain_class_activated ?terrain_class)
        (not
          (activity_day_allocation_flag ?activity_day)
        )
      )
    :effect
      (and
        (activity_day_allocation_flag ?activity_day)
        (activity_day_ready_for_accommodation ?activity_day)
      )
  )
  (:action allocate_equipment_to_activity_day
    :parameters (?activity_day - activity_day ?terrain_class - terrain_class ?consumable_equipment - consumable_equipment)
    :precondition
      (and
        (itinerary_element_prepared ?activity_day)
        (activity_day_in_terrain_class ?activity_day ?terrain_class)
        (equipment_available ?consumable_equipment)
        (not
          (activity_day_allocation_flag ?activity_day)
        )
      )
    :effect
      (and
        (terrain_class_equipment_assigned ?terrain_class)
        (activity_day_allocation_flag ?activity_day)
        (equipment_assigned_to_activity_day ?activity_day ?consumable_equipment)
        (not
          (equipment_available ?consumable_equipment)
        )
      )
  )
  (:action execute_activity_and_restore_equipment
    :parameters (?activity_day - activity_day ?terrain_class - terrain_class ?time_slot - time_slot ?consumable_equipment - consumable_equipment)
    :precondition
      (and
        (itinerary_element_prepared ?activity_day)
        (time_slot_assigned ?activity_day ?time_slot)
        (activity_day_in_terrain_class ?activity_day ?terrain_class)
        (terrain_class_equipment_assigned ?terrain_class)
        (equipment_assigned_to_activity_day ?activity_day ?consumable_equipment)
        (not
          (activity_day_ready_for_accommodation ?activity_day)
        )
      )
    :effect
      (and
        (terrain_class_activated ?terrain_class)
        (activity_day_ready_for_accommodation ?activity_day)
        (equipment_available ?consumable_equipment)
        (not
          (equipment_assigned_to_activity_day ?activity_day ?consumable_equipment)
        )
      )
  )
  (:action reserve_accommodation_standard
    :parameters (?acclimatization_day - acclimatization_day ?activity_day - activity_day ?altitude_zone - altitude_zone ?terrain_class - terrain_class ?accommodation - accommodation)
    :precondition
      (and
        (acclimatization_day_allocation_flag ?acclimatization_day)
        (activity_day_allocation_flag ?activity_day)
        (day_in_altitude_zone ?acclimatization_day ?altitude_zone)
        (activity_day_in_terrain_class ?activity_day ?terrain_class)
        (altitude_zone_activated ?altitude_zone)
        (terrain_class_activated ?terrain_class)
        (day_ready_for_accommodation ?acclimatization_day)
        (activity_day_ready_for_accommodation ?activity_day)
        (accommodation_available ?accommodation)
      )
    :effect
      (and
        (accommodation_reserved ?accommodation)
        (accommodation_at_altitude_zone ?accommodation ?altitude_zone)
        (accommodation_at_terrain_class ?accommodation ?terrain_class)
        (not
          (accommodation_available ?accommodation)
        )
      )
  )
  (:action reserve_accommodation_with_meals
    :parameters (?acclimatization_day - acclimatization_day ?activity_day - activity_day ?altitude_zone - altitude_zone ?terrain_class - terrain_class ?accommodation - accommodation)
    :precondition
      (and
        (acclimatization_day_allocation_flag ?acclimatization_day)
        (activity_day_allocation_flag ?activity_day)
        (day_in_altitude_zone ?acclimatization_day ?altitude_zone)
        (activity_day_in_terrain_class ?activity_day ?terrain_class)
        (altitude_zone_equipment_allocated ?altitude_zone)
        (terrain_class_activated ?terrain_class)
        (not
          (day_ready_for_accommodation ?acclimatization_day)
        )
        (activity_day_ready_for_accommodation ?activity_day)
        (accommodation_available ?accommodation)
      )
    :effect
      (and
        (accommodation_reserved ?accommodation)
        (accommodation_at_altitude_zone ?accommodation ?altitude_zone)
        (accommodation_at_terrain_class ?accommodation ?terrain_class)
        (accommodation_supports_meals ?accommodation)
        (not
          (accommodation_available ?accommodation)
        )
      )
  )
  (:action reserve_accommodation_with_medical_storage
    :parameters (?acclimatization_day - acclimatization_day ?activity_day - activity_day ?altitude_zone - altitude_zone ?terrain_class - terrain_class ?accommodation - accommodation)
    :precondition
      (and
        (acclimatization_day_allocation_flag ?acclimatization_day)
        (activity_day_allocation_flag ?activity_day)
        (day_in_altitude_zone ?acclimatization_day ?altitude_zone)
        (activity_day_in_terrain_class ?activity_day ?terrain_class)
        (altitude_zone_activated ?altitude_zone)
        (terrain_class_equipment_assigned ?terrain_class)
        (day_ready_for_accommodation ?acclimatization_day)
        (not
          (activity_day_ready_for_accommodation ?activity_day)
        )
        (accommodation_available ?accommodation)
      )
    :effect
      (and
        (accommodation_reserved ?accommodation)
        (accommodation_at_altitude_zone ?accommodation ?altitude_zone)
        (accommodation_at_terrain_class ?accommodation ?terrain_class)
        (accommodation_supports_medical_storage ?accommodation)
        (not
          (accommodation_available ?accommodation)
        )
      )
  )
  (:action reserve_accommodation_full_service
    :parameters (?acclimatization_day - acclimatization_day ?activity_day - activity_day ?altitude_zone - altitude_zone ?terrain_class - terrain_class ?accommodation - accommodation)
    :precondition
      (and
        (acclimatization_day_allocation_flag ?acclimatization_day)
        (activity_day_allocation_flag ?activity_day)
        (day_in_altitude_zone ?acclimatization_day ?altitude_zone)
        (activity_day_in_terrain_class ?activity_day ?terrain_class)
        (altitude_zone_equipment_allocated ?altitude_zone)
        (terrain_class_equipment_assigned ?terrain_class)
        (not
          (day_ready_for_accommodation ?acclimatization_day)
        )
        (not
          (activity_day_ready_for_accommodation ?activity_day)
        )
        (accommodation_available ?accommodation)
      )
    :effect
      (and
        (accommodation_reserved ?accommodation)
        (accommodation_at_altitude_zone ?accommodation ?altitude_zone)
        (accommodation_at_terrain_class ?accommodation ?terrain_class)
        (accommodation_supports_meals ?accommodation)
        (accommodation_supports_medical_storage ?accommodation)
        (not
          (accommodation_available ?accommodation)
        )
      )
  )
  (:action confirm_accommodation_time_slot
    :parameters (?accommodation - accommodation ?acclimatization_day - acclimatization_day ?time_slot - time_slot)
    :precondition
      (and
        (accommodation_reserved ?accommodation)
        (acclimatization_day_allocation_flag ?acclimatization_day)
        (time_slot_assigned ?acclimatization_day ?time_slot)
        (not
          (accommodation_time_slot_confirmed ?accommodation)
        )
      )
    :effect (accommodation_time_slot_confirmed ?accommodation)
  )
  (:action attach_permit_to_accommodation
    :parameters (?itinerary_variant - itinerary_variant ?permit_document - permit_document ?accommodation - accommodation)
    :precondition
      (and
        (itinerary_element_prepared ?itinerary_variant)
        (variant_includes_accommodation ?itinerary_variant ?accommodation)
        (variant_has_permit_requirement ?itinerary_variant ?permit_document)
        (permit_available ?permit_document)
        (accommodation_reserved ?accommodation)
        (accommodation_time_slot_confirmed ?accommodation)
        (not
          (permit_attached ?permit_document)
        )
      )
    :effect
      (and
        (permit_attached ?permit_document)
        (permit_attached_to_accommodation ?permit_document ?accommodation)
        (not
          (permit_available ?permit_document)
        )
      )
  )
  (:action finalize_accommodation_and_validate_permit
    :parameters (?itinerary_variant - itinerary_variant ?permit_document - permit_document ?accommodation - accommodation ?time_slot - time_slot)
    :precondition
      (and
        (itinerary_element_prepared ?itinerary_variant)
        (variant_has_permit_requirement ?itinerary_variant ?permit_document)
        (permit_attached ?permit_document)
        (permit_attached_to_accommodation ?permit_document ?accommodation)
        (time_slot_assigned ?itinerary_variant ?time_slot)
        (not
          (accommodation_supports_meals ?accommodation)
        )
        (not
          (variant_accommodation_validated ?itinerary_variant)
        )
      )
    :effect (variant_accommodation_validated ?itinerary_variant)
  )
  (:action assign_meal_option_to_variant
    :parameters (?itinerary_variant - itinerary_variant ?meal_option - meal_option)
    :precondition
      (and
        (itinerary_element_prepared ?itinerary_variant)
        (meal_option_available ?meal_option)
        (not
          (variant_has_meal_option ?itinerary_variant)
        )
      )
    :effect
      (and
        (variant_has_meal_option ?itinerary_variant)
        (variant_meal_assigned ?itinerary_variant ?meal_option)
        (not
          (meal_option_available ?meal_option)
        )
      )
  )
  (:action finalize_meal_and_accommodation
    :parameters (?itinerary_variant - itinerary_variant ?permit_document - permit_document ?accommodation - accommodation ?time_slot - time_slot ?meal_option - meal_option)
    :precondition
      (and
        (itinerary_element_prepared ?itinerary_variant)
        (variant_has_permit_requirement ?itinerary_variant ?permit_document)
        (permit_attached ?permit_document)
        (permit_attached_to_accommodation ?permit_document ?accommodation)
        (time_slot_assigned ?itinerary_variant ?time_slot)
        (accommodation_supports_meals ?accommodation)
        (variant_has_meal_option ?itinerary_variant)
        (variant_meal_assigned ?itinerary_variant ?meal_option)
        (not
          (variant_accommodation_validated ?itinerary_variant)
        )
      )
    :effect
      (and
        (variant_accommodation_validated ?itinerary_variant)
        (variant_meal_validated ?itinerary_variant)
      )
  )
  (:action allocate_medical_supply_to_variant_standard
    :parameters (?itinerary_variant - itinerary_variant ?medical_supply - medical_supply ?personnel_resource - personnel_resource ?permit_document - permit_document ?accommodation - accommodation)
    :precondition
      (and
        (variant_accommodation_validated ?itinerary_variant)
        (medical_supply_assigned_to_variant ?itinerary_variant ?medical_supply)
        (personnel_assigned_to_element ?itinerary_variant ?personnel_resource)
        (variant_has_permit_requirement ?itinerary_variant ?permit_document)
        (permit_attached_to_accommodation ?permit_document ?accommodation)
        (not
          (accommodation_supports_medical_storage ?accommodation)
        )
        (not
          (variant_medical_supplies_allocated ?itinerary_variant)
        )
      )
    :effect (variant_medical_supplies_allocated ?itinerary_variant)
  )
  (:action allocate_medical_supply_to_variant_with_accommodation_support
    :parameters (?itinerary_variant - itinerary_variant ?medical_supply - medical_supply ?personnel_resource - personnel_resource ?permit_document - permit_document ?accommodation - accommodation)
    :precondition
      (and
        (variant_accommodation_validated ?itinerary_variant)
        (medical_supply_assigned_to_variant ?itinerary_variant ?medical_supply)
        (personnel_assigned_to_element ?itinerary_variant ?personnel_resource)
        (variant_has_permit_requirement ?itinerary_variant ?permit_document)
        (permit_attached_to_accommodation ?permit_document ?accommodation)
        (accommodation_supports_medical_storage ?accommodation)
        (not
          (variant_medical_supplies_allocated ?itinerary_variant)
        )
      )
    :effect (variant_medical_supplies_allocated ?itinerary_variant)
  )
  (:action schedule_safety_briefing_and_mark_variant
    :parameters (?itinerary_variant - itinerary_variant ?safety_briefing - safety_briefing ?permit_document - permit_document ?accommodation - accommodation)
    :precondition
      (and
        (variant_medical_supplies_allocated ?itinerary_variant)
        (safety_briefing_assigned_to_variant ?itinerary_variant ?safety_briefing)
        (variant_has_permit_requirement ?itinerary_variant ?permit_document)
        (permit_attached_to_accommodation ?permit_document ?accommodation)
        (not
          (accommodation_supports_meals ?accommodation)
        )
        (not
          (accommodation_supports_medical_storage ?accommodation)
        )
        (not
          (variant_safety_briefing_completed ?itinerary_variant)
        )
      )
    :effect (variant_safety_briefing_completed ?itinerary_variant)
  )
  (:action schedule_safety_briefing_with_meal_dependency
    :parameters (?itinerary_variant - itinerary_variant ?safety_briefing - safety_briefing ?permit_document - permit_document ?accommodation - accommodation)
    :precondition
      (and
        (variant_medical_supplies_allocated ?itinerary_variant)
        (safety_briefing_assigned_to_variant ?itinerary_variant ?safety_briefing)
        (variant_has_permit_requirement ?itinerary_variant ?permit_document)
        (permit_attached_to_accommodation ?permit_document ?accommodation)
        (accommodation_supports_meals ?accommodation)
        (not
          (accommodation_supports_medical_storage ?accommodation)
        )
        (not
          (variant_safety_briefing_completed ?itinerary_variant)
        )
      )
    :effect
      (and
        (variant_safety_briefing_completed ?itinerary_variant)
        (variant_requires_weather_window ?itinerary_variant)
      )
  )
  (:action schedule_safety_briefing_with_medical_dependency
    :parameters (?itinerary_variant - itinerary_variant ?safety_briefing - safety_briefing ?permit_document - permit_document ?accommodation - accommodation)
    :precondition
      (and
        (variant_medical_supplies_allocated ?itinerary_variant)
        (safety_briefing_assigned_to_variant ?itinerary_variant ?safety_briefing)
        (variant_has_permit_requirement ?itinerary_variant ?permit_document)
        (permit_attached_to_accommodation ?permit_document ?accommodation)
        (not
          (accommodation_supports_meals ?accommodation)
        )
        (accommodation_supports_medical_storage ?accommodation)
        (not
          (variant_safety_briefing_completed ?itinerary_variant)
        )
      )
    :effect
      (and
        (variant_safety_briefing_completed ?itinerary_variant)
        (variant_requires_weather_window ?itinerary_variant)
      )
  )
  (:action schedule_safety_briefing_with_full_dependencies
    :parameters (?itinerary_variant - itinerary_variant ?safety_briefing - safety_briefing ?permit_document - permit_document ?accommodation - accommodation)
    :precondition
      (and
        (variant_medical_supplies_allocated ?itinerary_variant)
        (safety_briefing_assigned_to_variant ?itinerary_variant ?safety_briefing)
        (variant_has_permit_requirement ?itinerary_variant ?permit_document)
        (permit_attached_to_accommodation ?permit_document ?accommodation)
        (accommodation_supports_meals ?accommodation)
        (accommodation_supports_medical_storage ?accommodation)
        (not
          (variant_safety_briefing_completed ?itinerary_variant)
        )
      )
    :effect
      (and
        (variant_safety_briefing_completed ?itinerary_variant)
        (variant_requires_weather_window ?itinerary_variant)
      )
  )
  (:action lock_variant_and_mark_ready
    :parameters (?itinerary_variant - itinerary_variant)
    :precondition
      (and
        (variant_safety_briefing_completed ?itinerary_variant)
        (not
          (variant_requires_weather_window ?itinerary_variant)
        )
        (not
          (variant_booked_marker ?itinerary_variant)
        )
      )
    :effect
      (and
        (variant_booked_marker ?itinerary_variant)
        (element_ready ?itinerary_variant)
      )
  )
  (:action assign_weather_window_to_variant
    :parameters (?itinerary_variant - itinerary_variant ?weather_window - weather_window)
    :precondition
      (and
        (variant_safety_briefing_completed ?itinerary_variant)
        (variant_requires_weather_window ?itinerary_variant)
        (weather_window_available ?weather_window)
      )
    :effect
      (and
        (variant_has_weather_window ?itinerary_variant ?weather_window)
        (not
          (weather_window_available ?weather_window)
        )
      )
  )
  (:action integrate_variant_components
    :parameters (?itinerary_variant - itinerary_variant ?acclimatization_day - acclimatization_day ?activity_day - activity_day ?time_slot - time_slot ?weather_window - weather_window)
    :precondition
      (and
        (variant_safety_briefing_completed ?itinerary_variant)
        (variant_requires_weather_window ?itinerary_variant)
        (variant_has_weather_window ?itinerary_variant ?weather_window)
        (variant_includes_acclimatization_day ?itinerary_variant ?acclimatization_day)
        (variant_includes_activity_day ?itinerary_variant ?activity_day)
        (day_ready_for_accommodation ?acclimatization_day)
        (activity_day_ready_for_accommodation ?activity_day)
        (time_slot_assigned ?itinerary_variant ?time_slot)
        (not
          (variant_components_integrated ?itinerary_variant)
        )
      )
    :effect (variant_components_integrated ?itinerary_variant)
  )
  (:action lock_variant_after_integration
    :parameters (?itinerary_variant - itinerary_variant)
    :precondition
      (and
        (variant_safety_briefing_completed ?itinerary_variant)
        (variant_components_integrated ?itinerary_variant)
        (not
          (variant_booked_marker ?itinerary_variant)
        )
      )
    :effect
      (and
        (variant_booked_marker ?itinerary_variant)
        (element_ready ?itinerary_variant)
      )
  )
  (:action confirm_optional_excursion_for_variant
    :parameters (?itinerary_variant - itinerary_variant ?optional_excursion - optional_excursion ?time_slot - time_slot)
    :precondition
      (and
        (itinerary_element_prepared ?itinerary_variant)
        (time_slot_assigned ?itinerary_variant ?time_slot)
        (optional_excursion_available ?optional_excursion)
        (variant_has_optional_excursion ?itinerary_variant ?optional_excursion)
        (not
          (variant_optional_excursion_confirmed ?itinerary_variant)
        )
      )
    :effect
      (and
        (variant_optional_excursion_confirmed ?itinerary_variant)
        (not
          (optional_excursion_available ?optional_excursion)
        )
      )
  )
  (:action prepare_excursion_personnel
    :parameters (?itinerary_variant - itinerary_variant ?personnel_resource - personnel_resource)
    :precondition
      (and
        (variant_optional_excursion_confirmed ?itinerary_variant)
        (personnel_assigned_to_element ?itinerary_variant ?personnel_resource)
        (not
          (variant_excursion_prepared ?itinerary_variant)
        )
      )
    :effect (variant_excursion_prepared ?itinerary_variant)
  )
  (:action schedule_excursion_safety_briefing
    :parameters (?itinerary_variant - itinerary_variant ?safety_briefing - safety_briefing)
    :precondition
      (and
        (variant_excursion_prepared ?itinerary_variant)
        (safety_briefing_assigned_to_variant ?itinerary_variant ?safety_briefing)
        (not
          (variant_excursion_briefing_completed ?itinerary_variant)
        )
      )
    :effect (variant_excursion_briefing_completed ?itinerary_variant)
  )
  (:action lock_variant_after_excursion_briefing
    :parameters (?itinerary_variant - itinerary_variant)
    :precondition
      (and
        (variant_excursion_briefing_completed ?itinerary_variant)
        (not
          (variant_booked_marker ?itinerary_variant)
        )
      )
    :effect
      (and
        (variant_booked_marker ?itinerary_variant)
        (element_ready ?itinerary_variant)
      )
  )
  (:action confirm_acclimatization_day_booking
    :parameters (?acclimatization_day - acclimatization_day ?accommodation - accommodation)
    :precondition
      (and
        (acclimatization_day_allocation_flag ?acclimatization_day)
        (day_ready_for_accommodation ?acclimatization_day)
        (accommodation_reserved ?accommodation)
        (accommodation_time_slot_confirmed ?accommodation)
        (not
          (element_ready ?acclimatization_day)
        )
      )
    :effect (element_ready ?acclimatization_day)
  )
  (:action confirm_activity_day_booking
    :parameters (?activity_day - activity_day ?accommodation - accommodation)
    :precondition
      (and
        (activity_day_allocation_flag ?activity_day)
        (activity_day_ready_for_accommodation ?activity_day)
        (accommodation_reserved ?accommodation)
        (accommodation_time_slot_confirmed ?accommodation)
        (not
          (element_ready ?activity_day)
        )
      )
    :effect (element_ready ?activity_day)
  )
  (:action assign_acclimatization_profile_to_element
    :parameters (?itinerary_element - itinerary_element ?acclimatization_profile - acclimatization_profile ?time_slot - time_slot)
    :precondition
      (and
        (element_ready ?itinerary_element)
        (time_slot_assigned ?itinerary_element ?time_slot)
        (acclimatization_profile_available ?acclimatization_profile)
        (not
          (acclimatization_profile_assigned ?itinerary_element)
        )
      )
    :effect
      (and
        (acclimatization_profile_assigned ?itinerary_element)
        (element_assigned_acclimatization_profile ?itinerary_element ?acclimatization_profile)
        (not
          (acclimatization_profile_available ?acclimatization_profile)
        )
      )
  )
  (:action finalize_acclimatization_day_booking
    :parameters (?acclimatization_day - acclimatization_day ?transport_option - transport_option ?acclimatization_profile - acclimatization_profile)
    :precondition
      (and
        (acclimatization_profile_assigned ?acclimatization_day)
        (transport_allocated_to_element ?acclimatization_day ?transport_option)
        (element_assigned_acclimatization_profile ?acclimatization_day ?acclimatization_profile)
        (not
          (itinerary_element_confirmed ?acclimatization_day)
        )
      )
    :effect
      (and
        (itinerary_element_confirmed ?acclimatization_day)
        (transport_available ?transport_option)
        (acclimatization_profile_available ?acclimatization_profile)
      )
  )
  (:action finalize_activity_day_booking
    :parameters (?activity_day - activity_day ?transport_option - transport_option ?acclimatization_profile - acclimatization_profile)
    :precondition
      (and
        (acclimatization_profile_assigned ?activity_day)
        (transport_allocated_to_element ?activity_day ?transport_option)
        (element_assigned_acclimatization_profile ?activity_day ?acclimatization_profile)
        (not
          (itinerary_element_confirmed ?activity_day)
        )
      )
    :effect
      (and
        (itinerary_element_confirmed ?activity_day)
        (transport_available ?transport_option)
        (acclimatization_profile_available ?acclimatization_profile)
      )
  )
  (:action finalize_variant_booking
    :parameters (?itinerary_variant - itinerary_variant ?transport_option - transport_option ?acclimatization_profile - acclimatization_profile)
    :precondition
      (and
        (acclimatization_profile_assigned ?itinerary_variant)
        (transport_allocated_to_element ?itinerary_variant ?transport_option)
        (element_assigned_acclimatization_profile ?itinerary_variant ?acclimatization_profile)
        (not
          (itinerary_element_confirmed ?itinerary_variant)
        )
      )
    :effect
      (and
        (itinerary_element_confirmed ?itinerary_variant)
        (transport_available ?transport_option)
        (acclimatization_profile_available ?acclimatization_profile)
      )
  )
)

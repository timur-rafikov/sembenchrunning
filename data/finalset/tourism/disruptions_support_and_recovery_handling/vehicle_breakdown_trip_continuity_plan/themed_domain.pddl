(define (domain vehicle_breakdown_trip_continuity_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_supertype - object location_supertype - object option_supertype - object case_category - object incident_case - case_category service_provider - resource_supertype communication_channel - resource_supertype field_agent - resource_supertype authorization - resource_supertype compensation_package - resource_supertype payment_method - resource_supertype technical_resource - resource_supertype regulatory_approval - resource_supertype repair_resource - location_supertype payment_token - location_supertype local_partner - location_supertype site_location - option_supertype alternative_site - option_supertype continuity_option - option_supertype vehicle_category_group - incident_case fleet_category_group - incident_case vehicle - vehicle_category_group associated_vehicle_or_party - vehicle_category_group case_handler - fleet_category_group)
  (:predicates
    (case_reported ?incident_case - incident_case)
    (entity_triaged ?incident_case - incident_case)
    (case_has_assigned_provider ?incident_case - incident_case)
    (continuity_restored ?incident_case - incident_case)
    (entity_recovery_executed ?incident_case - incident_case)
    (compensation_issued ?incident_case - incident_case)
    (provider_available ?service_provider - service_provider)
    (provider_assigned_to_entity ?incident_case - incident_case ?service_provider - service_provider)
    (channel_available ?communication_channel - communication_channel)
    (linked_communication_channel ?incident_case - incident_case ?communication_channel - communication_channel)
    (field_agent_available ?field_agent - field_agent)
    (assigned_field_agent ?incident_case - incident_case ?field_agent - field_agent)
    (repair_resource_available ?repair_resource - repair_resource)
    (repair_resource_allocated_to_vehicle ?vehicle - vehicle ?repair_resource - repair_resource)
    (repair_resource_allocated_to_associated ?associated_vehicle_or_party - associated_vehicle_or_party ?repair_resource - repair_resource)
    (vehicle_at_site ?vehicle - vehicle ?site_location - site_location)
    (site_access_confirmed ?site_location - site_location)
    (repair_resource_allocated_to_site ?site_location - site_location)
    (vehicle_assessed ?vehicle - vehicle)
    (associated_linked_alternative_site ?associated_vehicle_or_party - associated_vehicle_or_party ?alternative_site - alternative_site)
    (alternative_site_available ?alternative_site - alternative_site)
    (alternative_site_prepared ?alternative_site - alternative_site)
    (associated_confirmation_obtained ?associated_vehicle_or_party - associated_vehicle_or_party)
    (continuity_option_offered ?continuity_option - continuity_option)
    (continuity_option_reserved ?continuity_option - continuity_option)
    (continuity_option_includes_site ?continuity_option - continuity_option ?site_location - site_location)
    (continuity_option_includes_alternative_site ?continuity_option - continuity_option ?alternative_site - alternative_site)
    (continuity_option_requires_partner_enrichment ?continuity_option - continuity_option)
    (continuity_option_requires_technical_endorsement ?continuity_option - continuity_option)
    (continuity_option_booking_ready ?continuity_option - continuity_option)
    (handler_assigned_vehicle ?case_handler - case_handler ?vehicle - vehicle)
    (handler_assigned_associated ?case_handler - case_handler ?associated_vehicle_or_party - associated_vehicle_or_party)
    (handler_selected_continuity_option ?case_handler - case_handler ?continuity_option - continuity_option)
    (payment_token_available ?payment_token - payment_token)
    (handler_allocated_payment_token ?case_handler - case_handler ?payment_token - payment_token)
    (payment_token_reserved ?payment_token - payment_token)
    (payment_token_linked_to_option ?payment_token - payment_token ?continuity_option - continuity_option)
    (handler_enriched ?case_handler - case_handler)
    (handler_has_technical_endorsement ?case_handler - case_handler)
    (handler_final_checks_completed ?case_handler - case_handler)
    (handler_has_authorization ?case_handler - case_handler)
    (handler_partner_enriched ?case_handler - case_handler)
    (compensation_attached ?case_handler - case_handler)
    (handler_execution_verified ?case_handler - case_handler)
    (local_partner_available ?local_partner - local_partner)
    (handler_linked_local_partner ?case_handler - case_handler ?local_partner - local_partner)
    (handler_partner_engaged ?case_handler - case_handler)
    (partner_action_initiated ?case_handler - case_handler)
    (partner_action_completed ?case_handler - case_handler)
    (authorization_available ?authorization - authorization)
    (handler_has_authorization_token ?case_handler - case_handler ?authorization - authorization)
    (compensation_package_available ?compensation_package - compensation_package)
    (handler_allocated_compensation_package ?case_handler - case_handler ?compensation_package - compensation_package)
    (technical_resource_available ?technical_resource - technical_resource)
    (handler_allocated_technical_resource ?case_handler - case_handler ?technical_resource - technical_resource)
    (regulatory_approval_available ?regulatory_approval - regulatory_approval)
    (handler_allocated_regulatory_approval ?case_handler - case_handler ?regulatory_approval - regulatory_approval)
    (payment_method_available ?payment_method - payment_method)
    (entity_linked_payment_method ?incident_case - incident_case ?payment_method - payment_method)
    (vehicle_ready ?vehicle - vehicle)
    (associated_ready ?associated_vehicle_or_party - associated_vehicle_or_party)
    (handler_ready_to_execute ?case_handler - case_handler)
  )
  (:action create_incident_case
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (not
          (case_reported ?incident_case)
        )
        (not
          (continuity_restored ?incident_case)
        )
      )
    :effect (case_reported ?incident_case)
  )
  (:action assign_service_provider_to_case
    :parameters (?incident_case - incident_case ?service_provider - service_provider)
    :precondition
      (and
        (case_reported ?incident_case)
        (not
          (case_has_assigned_provider ?incident_case)
        )
        (provider_available ?service_provider)
      )
    :effect
      (and
        (case_has_assigned_provider ?incident_case)
        (provider_assigned_to_entity ?incident_case ?service_provider)
        (not
          (provider_available ?service_provider)
        )
      )
  )
  (:action link_case_to_communication_channel
    :parameters (?incident_case - incident_case ?communication_channel - communication_channel)
    :precondition
      (and
        (case_reported ?incident_case)
        (case_has_assigned_provider ?incident_case)
        (channel_available ?communication_channel)
      )
    :effect
      (and
        (linked_communication_channel ?incident_case ?communication_channel)
        (not
          (channel_available ?communication_channel)
        )
      )
  )
  (:action confirm_case_triage
    :parameters (?incident_case - incident_case ?communication_channel - communication_channel)
    :precondition
      (and
        (case_reported ?incident_case)
        (case_has_assigned_provider ?incident_case)
        (linked_communication_channel ?incident_case ?communication_channel)
        (not
          (entity_triaged ?incident_case)
        )
      )
    :effect (entity_triaged ?incident_case)
  )
  (:action release_communication_channel
    :parameters (?incident_case - incident_case ?communication_channel - communication_channel)
    :precondition
      (and
        (linked_communication_channel ?incident_case ?communication_channel)
      )
    :effect
      (and
        (channel_available ?communication_channel)
        (not
          (linked_communication_channel ?incident_case ?communication_channel)
        )
      )
  )
  (:action assign_field_agent_to_case
    :parameters (?incident_case - incident_case ?field_agent - field_agent)
    :precondition
      (and
        (entity_triaged ?incident_case)
        (field_agent_available ?field_agent)
      )
    :effect
      (and
        (assigned_field_agent ?incident_case ?field_agent)
        (not
          (field_agent_available ?field_agent)
        )
      )
  )
  (:action release_field_agent_from_case
    :parameters (?incident_case - incident_case ?field_agent - field_agent)
    :precondition
      (and
        (assigned_field_agent ?incident_case ?field_agent)
      )
    :effect
      (and
        (field_agent_available ?field_agent)
        (not
          (assigned_field_agent ?incident_case ?field_agent)
        )
      )
  )
  (:action allocate_technical_resource_to_handler
    :parameters (?case_handler - case_handler ?technical_resource - technical_resource)
    :precondition
      (and
        (entity_triaged ?case_handler)
        (technical_resource_available ?technical_resource)
      )
    :effect
      (and
        (handler_allocated_technical_resource ?case_handler ?technical_resource)
        (not
          (technical_resource_available ?technical_resource)
        )
      )
  )
  (:action release_technical_resource_from_handler
    :parameters (?case_handler - case_handler ?technical_resource - technical_resource)
    :precondition
      (and
        (handler_allocated_technical_resource ?case_handler ?technical_resource)
      )
    :effect
      (and
        (technical_resource_available ?technical_resource)
        (not
          (handler_allocated_technical_resource ?case_handler ?technical_resource)
        )
      )
  )
  (:action assign_regulatory_approval_to_handler
    :parameters (?case_handler - case_handler ?regulatory_approval - regulatory_approval)
    :precondition
      (and
        (entity_triaged ?case_handler)
        (regulatory_approval_available ?regulatory_approval)
      )
    :effect
      (and
        (handler_allocated_regulatory_approval ?case_handler ?regulatory_approval)
        (not
          (regulatory_approval_available ?regulatory_approval)
        )
      )
  )
  (:action release_regulatory_approval_from_handler
    :parameters (?case_handler - case_handler ?regulatory_approval - regulatory_approval)
    :precondition
      (and
        (handler_allocated_regulatory_approval ?case_handler ?regulatory_approval)
      )
    :effect
      (and
        (regulatory_approval_available ?regulatory_approval)
        (not
          (handler_allocated_regulatory_approval ?case_handler ?regulatory_approval)
        )
      )
  )
  (:action initiate_site_assessment
    :parameters (?vehicle - vehicle ?site_location - site_location ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_triaged ?vehicle)
        (linked_communication_channel ?vehicle ?communication_channel)
        (vehicle_at_site ?vehicle ?site_location)
        (not
          (site_access_confirmed ?site_location)
        )
        (not
          (repair_resource_allocated_to_site ?site_location)
        )
      )
    :effect (site_access_confirmed ?site_location)
  )
  (:action confirm_site_access_and_assess_vehicle
    :parameters (?vehicle - vehicle ?site_location - site_location ?field_agent - field_agent)
    :precondition
      (and
        (entity_triaged ?vehicle)
        (assigned_field_agent ?vehicle ?field_agent)
        (vehicle_at_site ?vehicle ?site_location)
        (site_access_confirmed ?site_location)
        (not
          (vehicle_ready ?vehicle)
        )
      )
    :effect
      (and
        (vehicle_ready ?vehicle)
        (vehicle_assessed ?vehicle)
      )
  )
  (:action allocate_repair_resource_to_vehicle
    :parameters (?vehicle - vehicle ?site_location - site_location ?repair_resource - repair_resource)
    :precondition
      (and
        (entity_triaged ?vehicle)
        (vehicle_at_site ?vehicle ?site_location)
        (repair_resource_available ?repair_resource)
        (not
          (vehicle_ready ?vehicle)
        )
      )
    :effect
      (and
        (repair_resource_allocated_to_site ?site_location)
        (vehicle_ready ?vehicle)
        (repair_resource_allocated_to_vehicle ?vehicle ?repair_resource)
        (not
          (repair_resource_available ?repair_resource)
        )
      )
  )
  (:action execute_resource_allocation_for_vehicle
    :parameters (?vehicle - vehicle ?site_location - site_location ?communication_channel - communication_channel ?repair_resource - repair_resource)
    :precondition
      (and
        (entity_triaged ?vehicle)
        (linked_communication_channel ?vehicle ?communication_channel)
        (vehicle_at_site ?vehicle ?site_location)
        (repair_resource_allocated_to_site ?site_location)
        (repair_resource_allocated_to_vehicle ?vehicle ?repair_resource)
        (not
          (vehicle_assessed ?vehicle)
        )
      )
    :effect
      (and
        (site_access_confirmed ?site_location)
        (vehicle_assessed ?vehicle)
        (repair_resource_available ?repair_resource)
        (not
          (repair_resource_allocated_to_vehicle ?vehicle ?repair_resource)
        )
      )
  )
  (:action initiate_alternative_site_assessment
    :parameters (?associated_vehicle_or_party - associated_vehicle_or_party ?alternative_site - alternative_site ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_triaged ?associated_vehicle_or_party)
        (linked_communication_channel ?associated_vehicle_or_party ?communication_channel)
        (associated_linked_alternative_site ?associated_vehicle_or_party ?alternative_site)
        (not
          (alternative_site_available ?alternative_site)
        )
        (not
          (alternative_site_prepared ?alternative_site)
        )
      )
    :effect (alternative_site_available ?alternative_site)
  )
  (:action assign_field_agent_for_alternative_site
    :parameters (?associated_vehicle_or_party - associated_vehicle_or_party ?alternative_site - alternative_site ?field_agent - field_agent)
    :precondition
      (and
        (entity_triaged ?associated_vehicle_or_party)
        (assigned_field_agent ?associated_vehicle_or_party ?field_agent)
        (associated_linked_alternative_site ?associated_vehicle_or_party ?alternative_site)
        (alternative_site_available ?alternative_site)
        (not
          (associated_ready ?associated_vehicle_or_party)
        )
      )
    :effect
      (and
        (associated_ready ?associated_vehicle_or_party)
        (associated_confirmation_obtained ?associated_vehicle_or_party)
      )
  )
  (:action allocate_repair_resource_to_associated
    :parameters (?associated_vehicle_or_party - associated_vehicle_or_party ?alternative_site - alternative_site ?repair_resource - repair_resource)
    :precondition
      (and
        (entity_triaged ?associated_vehicle_or_party)
        (associated_linked_alternative_site ?associated_vehicle_or_party ?alternative_site)
        (repair_resource_available ?repair_resource)
        (not
          (associated_ready ?associated_vehicle_or_party)
        )
      )
    :effect
      (and
        (alternative_site_prepared ?alternative_site)
        (associated_ready ?associated_vehicle_or_party)
        (repair_resource_allocated_to_associated ?associated_vehicle_or_party ?repair_resource)
        (not
          (repair_resource_available ?repair_resource)
        )
      )
  )
  (:action confirm_associated_resource_allocation
    :parameters (?associated_vehicle_or_party - associated_vehicle_or_party ?alternative_site - alternative_site ?communication_channel - communication_channel ?repair_resource - repair_resource)
    :precondition
      (and
        (entity_triaged ?associated_vehicle_or_party)
        (linked_communication_channel ?associated_vehicle_or_party ?communication_channel)
        (associated_linked_alternative_site ?associated_vehicle_or_party ?alternative_site)
        (alternative_site_prepared ?alternative_site)
        (repair_resource_allocated_to_associated ?associated_vehicle_or_party ?repair_resource)
        (not
          (associated_confirmation_obtained ?associated_vehicle_or_party)
        )
      )
    :effect
      (and
        (alternative_site_available ?alternative_site)
        (associated_confirmation_obtained ?associated_vehicle_or_party)
        (repair_resource_available ?repair_resource)
        (not
          (repair_resource_allocated_to_associated ?associated_vehicle_or_party ?repair_resource)
        )
      )
  )
  (:action consolidate_continuity_option_basic
    :parameters (?vehicle - vehicle ?associated_vehicle_or_party - associated_vehicle_or_party ?site_location - site_location ?alternative_site - alternative_site ?continuity_option - continuity_option)
    :precondition
      (and
        (vehicle_ready ?vehicle)
        (associated_ready ?associated_vehicle_or_party)
        (vehicle_at_site ?vehicle ?site_location)
        (associated_linked_alternative_site ?associated_vehicle_or_party ?alternative_site)
        (site_access_confirmed ?site_location)
        (alternative_site_available ?alternative_site)
        (vehicle_assessed ?vehicle)
        (associated_confirmation_obtained ?associated_vehicle_or_party)
        (continuity_option_offered ?continuity_option)
      )
    :effect
      (and
        (continuity_option_reserved ?continuity_option)
        (continuity_option_includes_site ?continuity_option ?site_location)
        (continuity_option_includes_alternative_site ?continuity_option ?alternative_site)
        (not
          (continuity_option_offered ?continuity_option)
        )
      )
  )
  (:action consolidate_continuity_option_with_authorization_requirement
    :parameters (?vehicle - vehicle ?associated_vehicle_or_party - associated_vehicle_or_party ?site_location - site_location ?alternative_site - alternative_site ?continuity_option - continuity_option)
    :precondition
      (and
        (vehicle_ready ?vehicle)
        (associated_ready ?associated_vehicle_or_party)
        (vehicle_at_site ?vehicle ?site_location)
        (associated_linked_alternative_site ?associated_vehicle_or_party ?alternative_site)
        (repair_resource_allocated_to_site ?site_location)
        (alternative_site_available ?alternative_site)
        (not
          (vehicle_assessed ?vehicle)
        )
        (associated_confirmation_obtained ?associated_vehicle_or_party)
        (continuity_option_offered ?continuity_option)
      )
    :effect
      (and
        (continuity_option_reserved ?continuity_option)
        (continuity_option_includes_site ?continuity_option ?site_location)
        (continuity_option_includes_alternative_site ?continuity_option ?alternative_site)
        (continuity_option_requires_partner_enrichment ?continuity_option)
        (not
          (continuity_option_offered ?continuity_option)
        )
      )
  )
  (:action consolidate_continuity_option_with_technical_requirement
    :parameters (?vehicle - vehicle ?associated_vehicle_or_party - associated_vehicle_or_party ?site_location - site_location ?alternative_site - alternative_site ?continuity_option - continuity_option)
    :precondition
      (and
        (vehicle_ready ?vehicle)
        (associated_ready ?associated_vehicle_or_party)
        (vehicle_at_site ?vehicle ?site_location)
        (associated_linked_alternative_site ?associated_vehicle_or_party ?alternative_site)
        (site_access_confirmed ?site_location)
        (alternative_site_prepared ?alternative_site)
        (vehicle_assessed ?vehicle)
        (not
          (associated_confirmation_obtained ?associated_vehicle_or_party)
        )
        (continuity_option_offered ?continuity_option)
      )
    :effect
      (and
        (continuity_option_reserved ?continuity_option)
        (continuity_option_includes_site ?continuity_option ?site_location)
        (continuity_option_includes_alternative_site ?continuity_option ?alternative_site)
        (continuity_option_requires_technical_endorsement ?continuity_option)
        (not
          (continuity_option_offered ?continuity_option)
        )
      )
  )
  (:action consolidate_continuity_option_with_both_requirements
    :parameters (?vehicle - vehicle ?associated_vehicle_or_party - associated_vehicle_or_party ?site_location - site_location ?alternative_site - alternative_site ?continuity_option - continuity_option)
    :precondition
      (and
        (vehicle_ready ?vehicle)
        (associated_ready ?associated_vehicle_or_party)
        (vehicle_at_site ?vehicle ?site_location)
        (associated_linked_alternative_site ?associated_vehicle_or_party ?alternative_site)
        (repair_resource_allocated_to_site ?site_location)
        (alternative_site_prepared ?alternative_site)
        (not
          (vehicle_assessed ?vehicle)
        )
        (not
          (associated_confirmation_obtained ?associated_vehicle_or_party)
        )
        (continuity_option_offered ?continuity_option)
      )
    :effect
      (and
        (continuity_option_reserved ?continuity_option)
        (continuity_option_includes_site ?continuity_option ?site_location)
        (continuity_option_includes_alternative_site ?continuity_option ?alternative_site)
        (continuity_option_requires_partner_enrichment ?continuity_option)
        (continuity_option_requires_technical_endorsement ?continuity_option)
        (not
          (continuity_option_offered ?continuity_option)
        )
      )
  )
  (:action prepare_booking_and_payment_token
    :parameters (?continuity_option - continuity_option ?vehicle - vehicle ?communication_channel - communication_channel)
    :precondition
      (and
        (continuity_option_reserved ?continuity_option)
        (vehicle_ready ?vehicle)
        (linked_communication_channel ?vehicle ?communication_channel)
        (not
          (continuity_option_booking_ready ?continuity_option)
        )
      )
    :effect (continuity_option_booking_ready ?continuity_option)
  )
  (:action reserve_payment_token_for_option
    :parameters (?case_handler - case_handler ?payment_token - payment_token ?continuity_option - continuity_option)
    :precondition
      (and
        (entity_triaged ?case_handler)
        (handler_selected_continuity_option ?case_handler ?continuity_option)
        (handler_allocated_payment_token ?case_handler ?payment_token)
        (payment_token_available ?payment_token)
        (continuity_option_reserved ?continuity_option)
        (continuity_option_booking_ready ?continuity_option)
        (not
          (payment_token_reserved ?payment_token)
        )
      )
    :effect
      (and
        (payment_token_reserved ?payment_token)
        (payment_token_linked_to_option ?payment_token ?continuity_option)
        (not
          (payment_token_available ?payment_token)
        )
      )
  )
  (:action handler_sign_off_on_payment_token
    :parameters (?case_handler - case_handler ?payment_token - payment_token ?continuity_option - continuity_option ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_triaged ?case_handler)
        (handler_allocated_payment_token ?case_handler ?payment_token)
        (payment_token_reserved ?payment_token)
        (payment_token_linked_to_option ?payment_token ?continuity_option)
        (linked_communication_channel ?case_handler ?communication_channel)
        (not
          (continuity_option_requires_partner_enrichment ?continuity_option)
        )
        (not
          (handler_enriched ?case_handler)
        )
      )
    :effect (handler_enriched ?case_handler)
  )
  (:action assign_authorization_to_handler
    :parameters (?case_handler - case_handler ?authorization - authorization)
    :precondition
      (and
        (entity_triaged ?case_handler)
        (authorization_available ?authorization)
        (not
          (handler_has_authorization ?case_handler)
        )
      )
    :effect
      (and
        (handler_has_authorization ?case_handler)
        (handler_has_authorization_token ?case_handler ?authorization)
        (not
          (authorization_available ?authorization)
        )
      )
  )
  (:action apply_local_partner_enrichment
    :parameters (?case_handler - case_handler ?payment_token - payment_token ?continuity_option - continuity_option ?communication_channel - communication_channel ?authorization - authorization)
    :precondition
      (and
        (entity_triaged ?case_handler)
        (handler_allocated_payment_token ?case_handler ?payment_token)
        (payment_token_reserved ?payment_token)
        (payment_token_linked_to_option ?payment_token ?continuity_option)
        (linked_communication_channel ?case_handler ?communication_channel)
        (continuity_option_requires_partner_enrichment ?continuity_option)
        (handler_has_authorization ?case_handler)
        (handler_has_authorization_token ?case_handler ?authorization)
        (not
          (handler_enriched ?case_handler)
        )
      )
    :effect
      (and
        (handler_enriched ?case_handler)
        (handler_partner_enriched ?case_handler)
      )
  )
  (:action request_technical_endorsement_for_handler
    :parameters (?case_handler - case_handler ?technical_resource - technical_resource ?field_agent - field_agent ?payment_token - payment_token ?continuity_option - continuity_option)
    :precondition
      (and
        (handler_enriched ?case_handler)
        (handler_allocated_technical_resource ?case_handler ?technical_resource)
        (assigned_field_agent ?case_handler ?field_agent)
        (handler_allocated_payment_token ?case_handler ?payment_token)
        (payment_token_linked_to_option ?payment_token ?continuity_option)
        (not
          (continuity_option_requires_technical_endorsement ?continuity_option)
        )
        (not
          (handler_has_technical_endorsement ?case_handler)
        )
      )
    :effect (handler_has_technical_endorsement ?case_handler)
  )
  (:action confirm_technical_endorsement
    :parameters (?case_handler - case_handler ?technical_resource - technical_resource ?field_agent - field_agent ?payment_token - payment_token ?continuity_option - continuity_option)
    :precondition
      (and
        (handler_enriched ?case_handler)
        (handler_allocated_technical_resource ?case_handler ?technical_resource)
        (assigned_field_agent ?case_handler ?field_agent)
        (handler_allocated_payment_token ?case_handler ?payment_token)
        (payment_token_linked_to_option ?payment_token ?continuity_option)
        (continuity_option_requires_technical_endorsement ?continuity_option)
        (not
          (handler_has_technical_endorsement ?case_handler)
        )
      )
    :effect (handler_has_technical_endorsement ?case_handler)
  )
  (:action authorize_and_complete_final_checks_basic
    :parameters (?case_handler - case_handler ?regulatory_approval - regulatory_approval ?payment_token - payment_token ?continuity_option - continuity_option)
    :precondition
      (and
        (handler_has_technical_endorsement ?case_handler)
        (handler_allocated_regulatory_approval ?case_handler ?regulatory_approval)
        (handler_allocated_payment_token ?case_handler ?payment_token)
        (payment_token_linked_to_option ?payment_token ?continuity_option)
        (not
          (continuity_option_requires_partner_enrichment ?continuity_option)
        )
        (not
          (continuity_option_requires_technical_endorsement ?continuity_option)
        )
        (not
          (handler_final_checks_completed ?case_handler)
        )
      )
    :effect (handler_final_checks_completed ?case_handler)
  )
  (:action authorize_and_complete_final_checks_with_partner_enrichment
    :parameters (?case_handler - case_handler ?regulatory_approval - regulatory_approval ?payment_token - payment_token ?continuity_option - continuity_option)
    :precondition
      (and
        (handler_has_technical_endorsement ?case_handler)
        (handler_allocated_regulatory_approval ?case_handler ?regulatory_approval)
        (handler_allocated_payment_token ?case_handler ?payment_token)
        (payment_token_linked_to_option ?payment_token ?continuity_option)
        (continuity_option_requires_partner_enrichment ?continuity_option)
        (not
          (continuity_option_requires_technical_endorsement ?continuity_option)
        )
        (not
          (handler_final_checks_completed ?case_handler)
        )
      )
    :effect
      (and
        (handler_final_checks_completed ?case_handler)
        (compensation_attached ?case_handler)
      )
  )
  (:action authorize_and_complete_final_checks_with_technical_endorsement
    :parameters (?case_handler - case_handler ?regulatory_approval - regulatory_approval ?payment_token - payment_token ?continuity_option - continuity_option)
    :precondition
      (and
        (handler_has_technical_endorsement ?case_handler)
        (handler_allocated_regulatory_approval ?case_handler ?regulatory_approval)
        (handler_allocated_payment_token ?case_handler ?payment_token)
        (payment_token_linked_to_option ?payment_token ?continuity_option)
        (not
          (continuity_option_requires_partner_enrichment ?continuity_option)
        )
        (continuity_option_requires_technical_endorsement ?continuity_option)
        (not
          (handler_final_checks_completed ?case_handler)
        )
      )
    :effect
      (and
        (handler_final_checks_completed ?case_handler)
        (compensation_attached ?case_handler)
      )
  )
  (:action authorize_and_complete_final_checks_with_full_enrichment
    :parameters (?case_handler - case_handler ?regulatory_approval - regulatory_approval ?payment_token - payment_token ?continuity_option - continuity_option)
    :precondition
      (and
        (handler_has_technical_endorsement ?case_handler)
        (handler_allocated_regulatory_approval ?case_handler ?regulatory_approval)
        (handler_allocated_payment_token ?case_handler ?payment_token)
        (payment_token_linked_to_option ?payment_token ?continuity_option)
        (continuity_option_requires_partner_enrichment ?continuity_option)
        (continuity_option_requires_technical_endorsement ?continuity_option)
        (not
          (handler_final_checks_completed ?case_handler)
        )
      )
    :effect
      (and
        (handler_final_checks_completed ?case_handler)
        (compensation_attached ?case_handler)
      )
  )
  (:action mark_handler_ready_for_execution
    :parameters (?case_handler - case_handler)
    :precondition
      (and
        (handler_final_checks_completed ?case_handler)
        (not
          (compensation_attached ?case_handler)
        )
        (not
          (handler_ready_to_execute ?case_handler)
        )
      )
    :effect
      (and
        (handler_ready_to_execute ?case_handler)
        (entity_recovery_executed ?case_handler)
      )
  )
  (:action attach_compensation_package_to_handler
    :parameters (?case_handler - case_handler ?compensation_package - compensation_package)
    :precondition
      (and
        (handler_final_checks_completed ?case_handler)
        (compensation_attached ?case_handler)
        (compensation_package_available ?compensation_package)
      )
    :effect
      (and
        (handler_allocated_compensation_package ?case_handler ?compensation_package)
        (not
          (compensation_package_available ?compensation_package)
        )
      )
  )
  (:action perform_final_case_verification
    :parameters (?case_handler - case_handler ?vehicle - vehicle ?associated_vehicle_or_party - associated_vehicle_or_party ?communication_channel - communication_channel ?compensation_package - compensation_package)
    :precondition
      (and
        (handler_final_checks_completed ?case_handler)
        (compensation_attached ?case_handler)
        (handler_allocated_compensation_package ?case_handler ?compensation_package)
        (handler_assigned_vehicle ?case_handler ?vehicle)
        (handler_assigned_associated ?case_handler ?associated_vehicle_or_party)
        (vehicle_assessed ?vehicle)
        (associated_confirmation_obtained ?associated_vehicle_or_party)
        (linked_communication_channel ?case_handler ?communication_channel)
        (not
          (handler_execution_verified ?case_handler)
        )
      )
    :effect (handler_execution_verified ?case_handler)
  )
  (:action confirm_handler_readiness
    :parameters (?case_handler - case_handler)
    :precondition
      (and
        (handler_final_checks_completed ?case_handler)
        (handler_execution_verified ?case_handler)
        (not
          (handler_ready_to_execute ?case_handler)
        )
      )
    :effect
      (and
        (handler_ready_to_execute ?case_handler)
        (entity_recovery_executed ?case_handler)
      )
  )
  (:action engage_local_partner
    :parameters (?case_handler - case_handler ?local_partner - local_partner ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_triaged ?case_handler)
        (linked_communication_channel ?case_handler ?communication_channel)
        (local_partner_available ?local_partner)
        (handler_linked_local_partner ?case_handler ?local_partner)
        (not
          (handler_partner_engaged ?case_handler)
        )
      )
    :effect
      (and
        (handler_partner_engaged ?case_handler)
        (not
          (local_partner_available ?local_partner)
        )
      )
  )
  (:action initiate_partner_action
    :parameters (?case_handler - case_handler ?field_agent - field_agent)
    :precondition
      (and
        (handler_partner_engaged ?case_handler)
        (assigned_field_agent ?case_handler ?field_agent)
        (not
          (partner_action_initiated ?case_handler)
        )
      )
    :effect (partner_action_initiated ?case_handler)
  )
  (:action confirm_partner_action_completion
    :parameters (?case_handler - case_handler ?regulatory_approval - regulatory_approval)
    :precondition
      (and
        (partner_action_initiated ?case_handler)
        (handler_allocated_regulatory_approval ?case_handler ?regulatory_approval)
        (not
          (partner_action_completed ?case_handler)
        )
      )
    :effect (partner_action_completed ?case_handler)
  )
  (:action finalize_after_partner_action
    :parameters (?case_handler - case_handler)
    :precondition
      (and
        (partner_action_completed ?case_handler)
        (not
          (handler_ready_to_execute ?case_handler)
        )
      )
    :effect
      (and
        (handler_ready_to_execute ?case_handler)
        (entity_recovery_executed ?case_handler)
      )
  )
  (:action execute_recovery_for_vehicle
    :parameters (?vehicle - vehicle ?continuity_option - continuity_option)
    :precondition
      (and
        (vehicle_ready ?vehicle)
        (vehicle_assessed ?vehicle)
        (continuity_option_reserved ?continuity_option)
        (continuity_option_booking_ready ?continuity_option)
        (not
          (entity_recovery_executed ?vehicle)
        )
      )
    :effect (entity_recovery_executed ?vehicle)
  )
  (:action execute_recovery_for_associated
    :parameters (?associated_vehicle_or_party - associated_vehicle_or_party ?continuity_option - continuity_option)
    :precondition
      (and
        (associated_ready ?associated_vehicle_or_party)
        (associated_confirmation_obtained ?associated_vehicle_or_party)
        (continuity_option_reserved ?continuity_option)
        (continuity_option_booking_ready ?continuity_option)
        (not
          (entity_recovery_executed ?associated_vehicle_or_party)
        )
      )
    :effect (entity_recovery_executed ?associated_vehicle_or_party)
  )
  (:action issue_compensation_for_case
    :parameters (?incident_case - incident_case ?payment_method - payment_method ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_recovery_executed ?incident_case)
        (linked_communication_channel ?incident_case ?communication_channel)
        (payment_method_available ?payment_method)
        (not
          (compensation_issued ?incident_case)
        )
      )
    :effect
      (and
        (compensation_issued ?incident_case)
        (entity_linked_payment_method ?incident_case ?payment_method)
        (not
          (payment_method_available ?payment_method)
        )
      )
  )
  (:action finalize_vehicle_recovery_and_release_provider
    :parameters (?vehicle - vehicle ?service_provider - service_provider ?payment_method - payment_method)
    :precondition
      (and
        (compensation_issued ?vehicle)
        (provider_assigned_to_entity ?vehicle ?service_provider)
        (entity_linked_payment_method ?vehicle ?payment_method)
        (not
          (continuity_restored ?vehicle)
        )
      )
    :effect
      (and
        (continuity_restored ?vehicle)
        (provider_available ?service_provider)
        (payment_method_available ?payment_method)
      )
  )
  (:action finalize_associated_recovery_and_release_provider
    :parameters (?associated_vehicle_or_party - associated_vehicle_or_party ?service_provider - service_provider ?payment_method - payment_method)
    :precondition
      (and
        (compensation_issued ?associated_vehicle_or_party)
        (provider_assigned_to_entity ?associated_vehicle_or_party ?service_provider)
        (entity_linked_payment_method ?associated_vehicle_or_party ?payment_method)
        (not
          (continuity_restored ?associated_vehicle_or_party)
        )
      )
    :effect
      (and
        (continuity_restored ?associated_vehicle_or_party)
        (provider_available ?service_provider)
        (payment_method_available ?payment_method)
      )
  )
  (:action finalize_handler_recovery_and_release_provider
    :parameters (?case_handler - case_handler ?service_provider - service_provider ?payment_method - payment_method)
    :precondition
      (and
        (compensation_issued ?case_handler)
        (provider_assigned_to_entity ?case_handler ?service_provider)
        (entity_linked_payment_method ?case_handler ?payment_method)
        (not
          (continuity_restored ?case_handler)
        )
      )
    :effect
      (and
        (continuity_restored ?case_handler)
        (provider_available ?service_provider)
        (payment_method_available ?payment_method)
      )
  )
)

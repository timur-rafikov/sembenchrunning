(define (domain severe_weather_itinerary_revision_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_actor_group - object supporting_resource_group - object logistics_asset_group - object case_class - object disruption_case - case_class frontline_provider - operational_actor_group communication_channel - operational_actor_group on_site_staff - operational_actor_group policy_document - operational_actor_group compensation_option - operational_actor_group compensation_resource - operational_actor_group expert_team - operational_actor_group regulatory_clearance - operational_actor_group service_option - supporting_resource_group voucher_document - supporting_resource_group partner_organization - supporting_resource_group location_option - logistics_asset_group transport_option - logistics_asset_group supplier_confirmation - logistics_asset_group itinerary_component_group - disruption_case administrative_unit - disruption_case itinerary_segment - itinerary_component_group traveler_reservation - itinerary_component_group case_handler - administrative_unit)
  (:predicates
    (entity_opened ?disruption_case - disruption_case)
    (entity_validated ?disruption_case - disruption_case)
    (provider_assigned_flag ?disruption_case - disruption_case)
    (marked_resolved ?disruption_case - disruption_case)
    (action_completed ?disruption_case - disruption_case)
    (compensation_assigned ?disruption_case - disruption_case)
    (provider_available ?frontline_provider - frontline_provider)
    (assigned_provider ?disruption_case - disruption_case ?frontline_provider - frontline_provider)
    (channel_available ?communication_channel - communication_channel)
    (communication_channel_assigned ?disruption_case - disruption_case ?communication_channel - communication_channel)
    (staff_available ?on_site_staff - on_site_staff)
    (assigned_staff ?disruption_case - disruption_case ?on_site_staff - on_site_staff)
    (service_option_available ?service_option - service_option)
    (segment_service_hold ?itinerary_segment - itinerary_segment ?service_option - service_option)
    (reservation_service_hold ?traveler_reservation - traveler_reservation ?service_option - service_option)
    (segment_location_option ?itinerary_segment - itinerary_segment ?location_option - location_option)
    (location_option_selected ?location_option - location_option)
    (location_option_blocked ?location_option - location_option)
    (segment_assessed ?itinerary_segment - itinerary_segment)
    (reservation_transport_option ?traveler_reservation - traveler_reservation ?transport_option - transport_option)
    (transport_option_selected ?transport_option - transport_option)
    (transport_option_blocked ?transport_option - transport_option)
    (reservation_assessed ?traveler_reservation - traveler_reservation)
    (supplier_confirmation_pending ?supplier_confirmation - supplier_confirmation)
    (supplier_confirmation_received ?supplier_confirmation - supplier_confirmation)
    (confirmation_location_link ?supplier_confirmation - supplier_confirmation ?location_option - location_option)
    (confirmation_transport_link ?supplier_confirmation - supplier_confirmation ?transport_option - transport_option)
    (confirmation_has_location ?supplier_confirmation - supplier_confirmation)
    (confirmation_has_transport ?supplier_confirmation - supplier_confirmation)
    (supplier_confirmation_validated ?supplier_confirmation - supplier_confirmation)
    (handler_responsible_for_segment ?case_handler - case_handler ?itinerary_segment - itinerary_segment)
    (handler_responsible_for_reservation ?case_handler - case_handler ?traveler_reservation - traveler_reservation)
    (handler_requested_confirmation ?case_handler - case_handler ?supplier_confirmation - supplier_confirmation)
    (voucher_available ?voucher_document - voucher_document)
    (handler_has_voucher ?case_handler - case_handler ?voucher_document - voucher_document)
    (voucher_issued ?voucher_document - voucher_document)
    (voucher_link_confirmation ?voucher_document - voucher_document ?supplier_confirmation - supplier_confirmation)
    (handler_voucher_checked ?case_handler - case_handler)
    (handler_authorization_requested ?case_handler - case_handler)
    (approval_granted ?case_handler - case_handler)
    (policy_attachment_initiated ?case_handler - case_handler)
    (policy_attachment_finalized ?case_handler - case_handler)
    (policy_applied ?case_handler - case_handler)
    (case_escalated ?case_handler - case_handler)
    (partner_available ?partner_organization - partner_organization)
    (handler_partner_assigned ?case_handler - case_handler ?partner_organization - partner_organization)
    (partner_engagement_initiated ?case_handler - case_handler)
    (partner_clearance_in_progress ?case_handler - case_handler)
    (partner_clearance_obtained ?case_handler - case_handler)
    (policy_document_available ?policy_document - policy_document)
    (handler_policy_link ?case_handler - case_handler ?policy_document - policy_document)
    (compensation_option_available ?compensation_option - compensation_option)
    (handler_compensation_assigned ?case_handler - case_handler ?compensation_option - compensation_option)
    (expert_team_available ?expert_team - expert_team)
    (handler_expert_team_assigned ?case_handler - case_handler ?expert_team - expert_team)
    (regulatory_clearance_available ?regulatory_clearance - regulatory_clearance)
    (handler_regulatory_clearance_assigned ?case_handler - case_handler ?regulatory_clearance - regulatory_clearance)
    (compensation_resource_available ?compensation_resource - compensation_resource)
    (compensation_resource_allocated ?disruption_case - disruption_case ?compensation_resource - compensation_resource)
    (segment_ready_for_consolidation ?itinerary_segment - itinerary_segment)
    (reservation_ready_for_consolidation ?traveler_reservation - traveler_reservation)
    (handler_finalized ?case_handler - case_handler)
  )
  (:action open_disruption_case
    :parameters (?disruption_case - disruption_case)
    :precondition
      (and
        (not
          (entity_opened ?disruption_case)
        )
        (not
          (marked_resolved ?disruption_case)
        )
      )
    :effect (entity_opened ?disruption_case)
  )
  (:action assign_frontline_provider_to_case
    :parameters (?disruption_case - disruption_case ?frontline_provider - frontline_provider)
    :precondition
      (and
        (entity_opened ?disruption_case)
        (not
          (provider_assigned_flag ?disruption_case)
        )
        (provider_available ?frontline_provider)
      )
    :effect
      (and
        (provider_assigned_flag ?disruption_case)
        (assigned_provider ?disruption_case ?frontline_provider)
        (not
          (provider_available ?frontline_provider)
        )
      )
  )
  (:action assign_communication_channel_to_case
    :parameters (?disruption_case - disruption_case ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_opened ?disruption_case)
        (provider_assigned_flag ?disruption_case)
        (channel_available ?communication_channel)
      )
    :effect
      (and
        (communication_channel_assigned ?disruption_case ?communication_channel)
        (not
          (channel_available ?communication_channel)
        )
      )
  )
  (:action validate_disruption_case
    :parameters (?disruption_case - disruption_case ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_opened ?disruption_case)
        (provider_assigned_flag ?disruption_case)
        (communication_channel_assigned ?disruption_case ?communication_channel)
        (not
          (entity_validated ?disruption_case)
        )
      )
    :effect (entity_validated ?disruption_case)
  )
  (:action release_communication_channel_from_case
    :parameters (?disruption_case - disruption_case ?communication_channel - communication_channel)
    :precondition
      (and
        (communication_channel_assigned ?disruption_case ?communication_channel)
      )
    :effect
      (and
        (channel_available ?communication_channel)
        (not
          (communication_channel_assigned ?disruption_case ?communication_channel)
        )
      )
  )
  (:action assign_on_site_staff_to_case
    :parameters (?disruption_case - disruption_case ?on_site_staff - on_site_staff)
    :precondition
      (and
        (entity_validated ?disruption_case)
        (staff_available ?on_site_staff)
      )
    :effect
      (and
        (assigned_staff ?disruption_case ?on_site_staff)
        (not
          (staff_available ?on_site_staff)
        )
      )
  )
  (:action release_on_site_staff_from_case
    :parameters (?disruption_case - disruption_case ?on_site_staff - on_site_staff)
    :precondition
      (and
        (assigned_staff ?disruption_case ?on_site_staff)
      )
    :effect
      (and
        (staff_available ?on_site_staff)
        (not
          (assigned_staff ?disruption_case ?on_site_staff)
        )
      )
  )
  (:action assign_expert_team_to_handler
    :parameters (?case_handler - case_handler ?expert_team - expert_team)
    :precondition
      (and
        (entity_validated ?case_handler)
        (expert_team_available ?expert_team)
      )
    :effect
      (and
        (handler_expert_team_assigned ?case_handler ?expert_team)
        (not
          (expert_team_available ?expert_team)
        )
      )
  )
  (:action release_expert_team_from_handler
    :parameters (?case_handler - case_handler ?expert_team - expert_team)
    :precondition
      (and
        (handler_expert_team_assigned ?case_handler ?expert_team)
      )
    :effect
      (and
        (expert_team_available ?expert_team)
        (not
          (handler_expert_team_assigned ?case_handler ?expert_team)
        )
      )
  )
  (:action assign_regulatory_clearance_to_handler
    :parameters (?case_handler - case_handler ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (entity_validated ?case_handler)
        (regulatory_clearance_available ?regulatory_clearance)
      )
    :effect
      (and
        (handler_regulatory_clearance_assigned ?case_handler ?regulatory_clearance)
        (not
          (regulatory_clearance_available ?regulatory_clearance)
        )
      )
  )
  (:action release_regulatory_clearance_from_handler
    :parameters (?case_handler - case_handler ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (handler_regulatory_clearance_assigned ?case_handler ?regulatory_clearance)
      )
    :effect
      (and
        (regulatory_clearance_available ?regulatory_clearance)
        (not
          (handler_regulatory_clearance_assigned ?case_handler ?regulatory_clearance)
        )
      )
  )
  (:action select_location_option_for_segment
    :parameters (?itinerary_segment - itinerary_segment ?location_option - location_option ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_validated ?itinerary_segment)
        (communication_channel_assigned ?itinerary_segment ?communication_channel)
        (segment_location_option ?itinerary_segment ?location_option)
        (not
          (location_option_selected ?location_option)
        )
        (not
          (location_option_blocked ?location_option)
        )
      )
    :effect (location_option_selected ?location_option)
  )
  (:action confirm_location_option_with_staff
    :parameters (?itinerary_segment - itinerary_segment ?location_option - location_option ?on_site_staff - on_site_staff)
    :precondition
      (and
        (entity_validated ?itinerary_segment)
        (assigned_staff ?itinerary_segment ?on_site_staff)
        (segment_location_option ?itinerary_segment ?location_option)
        (location_option_selected ?location_option)
        (not
          (segment_ready_for_consolidation ?itinerary_segment)
        )
      )
    :effect
      (and
        (segment_ready_for_consolidation ?itinerary_segment)
        (segment_assessed ?itinerary_segment)
      )
  )
  (:action hold_service_option_for_segment
    :parameters (?itinerary_segment - itinerary_segment ?location_option - location_option ?service_option - service_option)
    :precondition
      (and
        (entity_validated ?itinerary_segment)
        (segment_location_option ?itinerary_segment ?location_option)
        (service_option_available ?service_option)
        (not
          (segment_ready_for_consolidation ?itinerary_segment)
        )
      )
    :effect
      (and
        (location_option_blocked ?location_option)
        (segment_ready_for_consolidation ?itinerary_segment)
        (segment_service_hold ?itinerary_segment ?service_option)
        (not
          (service_option_available ?service_option)
        )
      )
  )
  (:action finalize_location_selection_for_segment
    :parameters (?itinerary_segment - itinerary_segment ?location_option - location_option ?communication_channel - communication_channel ?service_option - service_option)
    :precondition
      (and
        (entity_validated ?itinerary_segment)
        (communication_channel_assigned ?itinerary_segment ?communication_channel)
        (segment_location_option ?itinerary_segment ?location_option)
        (location_option_blocked ?location_option)
        (segment_service_hold ?itinerary_segment ?service_option)
        (not
          (segment_assessed ?itinerary_segment)
        )
      )
    :effect
      (and
        (location_option_selected ?location_option)
        (segment_assessed ?itinerary_segment)
        (service_option_available ?service_option)
        (not
          (segment_service_hold ?itinerary_segment ?service_option)
        )
      )
  )
  (:action select_transport_option_for_reservation
    :parameters (?traveler_reservation - traveler_reservation ?transport_option - transport_option ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_validated ?traveler_reservation)
        (communication_channel_assigned ?traveler_reservation ?communication_channel)
        (reservation_transport_option ?traveler_reservation ?transport_option)
        (not
          (transport_option_selected ?transport_option)
        )
        (not
          (transport_option_blocked ?transport_option)
        )
      )
    :effect (transport_option_selected ?transport_option)
  )
  (:action confirm_transport_option_with_staff
    :parameters (?traveler_reservation - traveler_reservation ?transport_option - transport_option ?on_site_staff - on_site_staff)
    :precondition
      (and
        (entity_validated ?traveler_reservation)
        (assigned_staff ?traveler_reservation ?on_site_staff)
        (reservation_transport_option ?traveler_reservation ?transport_option)
        (transport_option_selected ?transport_option)
        (not
          (reservation_ready_for_consolidation ?traveler_reservation)
        )
      )
    :effect
      (and
        (reservation_ready_for_consolidation ?traveler_reservation)
        (reservation_assessed ?traveler_reservation)
      )
  )
  (:action hold_service_option_for_reservation
    :parameters (?traveler_reservation - traveler_reservation ?transport_option - transport_option ?service_option - service_option)
    :precondition
      (and
        (entity_validated ?traveler_reservation)
        (reservation_transport_option ?traveler_reservation ?transport_option)
        (service_option_available ?service_option)
        (not
          (reservation_ready_for_consolidation ?traveler_reservation)
        )
      )
    :effect
      (and
        (transport_option_blocked ?transport_option)
        (reservation_ready_for_consolidation ?traveler_reservation)
        (reservation_service_hold ?traveler_reservation ?service_option)
        (not
          (service_option_available ?service_option)
        )
      )
  )
  (:action finalize_transport_selection_for_reservation
    :parameters (?traveler_reservation - traveler_reservation ?transport_option - transport_option ?communication_channel - communication_channel ?service_option - service_option)
    :precondition
      (and
        (entity_validated ?traveler_reservation)
        (communication_channel_assigned ?traveler_reservation ?communication_channel)
        (reservation_transport_option ?traveler_reservation ?transport_option)
        (transport_option_blocked ?transport_option)
        (reservation_service_hold ?traveler_reservation ?service_option)
        (not
          (reservation_assessed ?traveler_reservation)
        )
      )
    :effect
      (and
        (transport_option_selected ?transport_option)
        (reservation_assessed ?traveler_reservation)
        (service_option_available ?service_option)
        (not
          (reservation_service_hold ?traveler_reservation ?service_option)
        )
      )
  )
  (:action consolidate_supplier_booking_request
    :parameters (?itinerary_segment - itinerary_segment ?traveler_reservation - traveler_reservation ?location_option - location_option ?transport_option - transport_option ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (segment_ready_for_consolidation ?itinerary_segment)
        (reservation_ready_for_consolidation ?traveler_reservation)
        (segment_location_option ?itinerary_segment ?location_option)
        (reservation_transport_option ?traveler_reservation ?transport_option)
        (location_option_selected ?location_option)
        (transport_option_selected ?transport_option)
        (segment_assessed ?itinerary_segment)
        (reservation_assessed ?traveler_reservation)
        (supplier_confirmation_pending ?supplier_confirmation)
      )
    :effect
      (and
        (supplier_confirmation_received ?supplier_confirmation)
        (confirmation_location_link ?supplier_confirmation ?location_option)
        (confirmation_transport_link ?supplier_confirmation ?transport_option)
        (not
          (supplier_confirmation_pending ?supplier_confirmation)
        )
      )
  )
  (:action consolidate_supplier_request_with_location_preference
    :parameters (?itinerary_segment - itinerary_segment ?traveler_reservation - traveler_reservation ?location_option - location_option ?transport_option - transport_option ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (segment_ready_for_consolidation ?itinerary_segment)
        (reservation_ready_for_consolidation ?traveler_reservation)
        (segment_location_option ?itinerary_segment ?location_option)
        (reservation_transport_option ?traveler_reservation ?transport_option)
        (location_option_blocked ?location_option)
        (transport_option_selected ?transport_option)
        (not
          (segment_assessed ?itinerary_segment)
        )
        (reservation_assessed ?traveler_reservation)
        (supplier_confirmation_pending ?supplier_confirmation)
      )
    :effect
      (and
        (supplier_confirmation_received ?supplier_confirmation)
        (confirmation_location_link ?supplier_confirmation ?location_option)
        (confirmation_transport_link ?supplier_confirmation ?transport_option)
        (confirmation_has_location ?supplier_confirmation)
        (not
          (supplier_confirmation_pending ?supplier_confirmation)
        )
      )
  )
  (:action consolidate_supplier_request_with_transport_preference
    :parameters (?itinerary_segment - itinerary_segment ?traveler_reservation - traveler_reservation ?location_option - location_option ?transport_option - transport_option ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (segment_ready_for_consolidation ?itinerary_segment)
        (reservation_ready_for_consolidation ?traveler_reservation)
        (segment_location_option ?itinerary_segment ?location_option)
        (reservation_transport_option ?traveler_reservation ?transport_option)
        (location_option_selected ?location_option)
        (transport_option_blocked ?transport_option)
        (segment_assessed ?itinerary_segment)
        (not
          (reservation_assessed ?traveler_reservation)
        )
        (supplier_confirmation_pending ?supplier_confirmation)
      )
    :effect
      (and
        (supplier_confirmation_received ?supplier_confirmation)
        (confirmation_location_link ?supplier_confirmation ?location_option)
        (confirmation_transport_link ?supplier_confirmation ?transport_option)
        (confirmation_has_transport ?supplier_confirmation)
        (not
          (supplier_confirmation_pending ?supplier_confirmation)
        )
      )
  )
  (:action consolidate_supplier_request_with_full_priority
    :parameters (?itinerary_segment - itinerary_segment ?traveler_reservation - traveler_reservation ?location_option - location_option ?transport_option - transport_option ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (segment_ready_for_consolidation ?itinerary_segment)
        (reservation_ready_for_consolidation ?traveler_reservation)
        (segment_location_option ?itinerary_segment ?location_option)
        (reservation_transport_option ?traveler_reservation ?transport_option)
        (location_option_blocked ?location_option)
        (transport_option_blocked ?transport_option)
        (not
          (segment_assessed ?itinerary_segment)
        )
        (not
          (reservation_assessed ?traveler_reservation)
        )
        (supplier_confirmation_pending ?supplier_confirmation)
      )
    :effect
      (and
        (supplier_confirmation_received ?supplier_confirmation)
        (confirmation_location_link ?supplier_confirmation ?location_option)
        (confirmation_transport_link ?supplier_confirmation ?transport_option)
        (confirmation_has_location ?supplier_confirmation)
        (confirmation_has_transport ?supplier_confirmation)
        (not
          (supplier_confirmation_pending ?supplier_confirmation)
        )
      )
  )
  (:action validate_supplier_confirmation_for_segment
    :parameters (?supplier_confirmation - supplier_confirmation ?itinerary_segment - itinerary_segment ?communication_channel - communication_channel)
    :precondition
      (and
        (supplier_confirmation_received ?supplier_confirmation)
        (segment_ready_for_consolidation ?itinerary_segment)
        (communication_channel_assigned ?itinerary_segment ?communication_channel)
        (not
          (supplier_confirmation_validated ?supplier_confirmation)
        )
      )
    :effect (supplier_confirmation_validated ?supplier_confirmation)
  )
  (:action issue_voucher_for_confirmation
    :parameters (?case_handler - case_handler ?voucher_document - voucher_document ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (entity_validated ?case_handler)
        (handler_requested_confirmation ?case_handler ?supplier_confirmation)
        (handler_has_voucher ?case_handler ?voucher_document)
        (voucher_available ?voucher_document)
        (supplier_confirmation_received ?supplier_confirmation)
        (supplier_confirmation_validated ?supplier_confirmation)
        (not
          (voucher_issued ?voucher_document)
        )
      )
    :effect
      (and
        (voucher_issued ?voucher_document)
        (voucher_link_confirmation ?voucher_document ?supplier_confirmation)
        (not
          (voucher_available ?voucher_document)
        )
      )
  )
  (:action handler_acknowledge_voucher
    :parameters (?case_handler - case_handler ?voucher_document - voucher_document ?supplier_confirmation - supplier_confirmation ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_validated ?case_handler)
        (handler_has_voucher ?case_handler ?voucher_document)
        (voucher_issued ?voucher_document)
        (voucher_link_confirmation ?voucher_document ?supplier_confirmation)
        (communication_channel_assigned ?case_handler ?communication_channel)
        (not
          (confirmation_has_location ?supplier_confirmation)
        )
        (not
          (handler_voucher_checked ?case_handler)
        )
      )
    :effect (handler_voucher_checked ?case_handler)
  )
  (:action attach_policy_document_to_handler
    :parameters (?case_handler - case_handler ?policy_document - policy_document)
    :precondition
      (and
        (entity_validated ?case_handler)
        (policy_document_available ?policy_document)
        (not
          (policy_attachment_initiated ?case_handler)
        )
      )
    :effect
      (and
        (policy_attachment_initiated ?case_handler)
        (handler_policy_link ?case_handler ?policy_document)
        (not
          (policy_document_available ?policy_document)
        )
      )
  )
  (:action apply_policy_and_mark_handler_review
    :parameters (?case_handler - case_handler ?voucher_document - voucher_document ?supplier_confirmation - supplier_confirmation ?communication_channel - communication_channel ?policy_document - policy_document)
    :precondition
      (and
        (entity_validated ?case_handler)
        (handler_has_voucher ?case_handler ?voucher_document)
        (voucher_issued ?voucher_document)
        (voucher_link_confirmation ?voucher_document ?supplier_confirmation)
        (communication_channel_assigned ?case_handler ?communication_channel)
        (confirmation_has_location ?supplier_confirmation)
        (policy_attachment_initiated ?case_handler)
        (handler_policy_link ?case_handler ?policy_document)
        (not
          (handler_voucher_checked ?case_handler)
        )
      )
    :effect
      (and
        (handler_voucher_checked ?case_handler)
        (policy_attachment_finalized ?case_handler)
      )
  )
  (:action request_policy_approval
    :parameters (?case_handler - case_handler ?expert_team - expert_team ?on_site_staff - on_site_staff ?voucher_document - voucher_document ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (handler_voucher_checked ?case_handler)
        (handler_expert_team_assigned ?case_handler ?expert_team)
        (assigned_staff ?case_handler ?on_site_staff)
        (handler_has_voucher ?case_handler ?voucher_document)
        (voucher_link_confirmation ?voucher_document ?supplier_confirmation)
        (not
          (confirmation_has_transport ?supplier_confirmation)
        )
        (not
          (handler_authorization_requested ?case_handler)
        )
      )
    :effect (handler_authorization_requested ?case_handler)
  )
  (:action request_policy_approval_with_voucher
    :parameters (?case_handler - case_handler ?expert_team - expert_team ?on_site_staff - on_site_staff ?voucher_document - voucher_document ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (handler_voucher_checked ?case_handler)
        (handler_expert_team_assigned ?case_handler ?expert_team)
        (assigned_staff ?case_handler ?on_site_staff)
        (handler_has_voucher ?case_handler ?voucher_document)
        (voucher_link_confirmation ?voucher_document ?supplier_confirmation)
        (confirmation_has_transport ?supplier_confirmation)
        (not
          (handler_authorization_requested ?case_handler)
        )
      )
    :effect (handler_authorization_requested ?case_handler)
  )
  (:action grant_policy_approval
    :parameters (?case_handler - case_handler ?regulatory_clearance - regulatory_clearance ?voucher_document - voucher_document ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (handler_authorization_requested ?case_handler)
        (handler_regulatory_clearance_assigned ?case_handler ?regulatory_clearance)
        (handler_has_voucher ?case_handler ?voucher_document)
        (voucher_link_confirmation ?voucher_document ?supplier_confirmation)
        (not
          (confirmation_has_location ?supplier_confirmation)
        )
        (not
          (confirmation_has_transport ?supplier_confirmation)
        )
        (not
          (approval_granted ?case_handler)
        )
      )
    :effect (approval_granted ?case_handler)
  )
  (:action grant_policy_approval_and_apply_policy
    :parameters (?case_handler - case_handler ?regulatory_clearance - regulatory_clearance ?voucher_document - voucher_document ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (handler_authorization_requested ?case_handler)
        (handler_regulatory_clearance_assigned ?case_handler ?regulatory_clearance)
        (handler_has_voucher ?case_handler ?voucher_document)
        (voucher_link_confirmation ?voucher_document ?supplier_confirmation)
        (confirmation_has_location ?supplier_confirmation)
        (not
          (confirmation_has_transport ?supplier_confirmation)
        )
        (not
          (approval_granted ?case_handler)
        )
      )
    :effect
      (and
        (approval_granted ?case_handler)
        (policy_applied ?case_handler)
      )
  )
  (:action grant_policy_approval_and_apply_policy_variant
    :parameters (?case_handler - case_handler ?regulatory_clearance - regulatory_clearance ?voucher_document - voucher_document ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (handler_authorization_requested ?case_handler)
        (handler_regulatory_clearance_assigned ?case_handler ?regulatory_clearance)
        (handler_has_voucher ?case_handler ?voucher_document)
        (voucher_link_confirmation ?voucher_document ?supplier_confirmation)
        (not
          (confirmation_has_location ?supplier_confirmation)
        )
        (confirmation_has_transport ?supplier_confirmation)
        (not
          (approval_granted ?case_handler)
        )
      )
    :effect
      (and
        (approval_granted ?case_handler)
        (policy_applied ?case_handler)
      )
  )
  (:action grant_policy_approval_and_apply_policy_full
    :parameters (?case_handler - case_handler ?regulatory_clearance - regulatory_clearance ?voucher_document - voucher_document ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (handler_authorization_requested ?case_handler)
        (handler_regulatory_clearance_assigned ?case_handler ?regulatory_clearance)
        (handler_has_voucher ?case_handler ?voucher_document)
        (voucher_link_confirmation ?voucher_document ?supplier_confirmation)
        (confirmation_has_location ?supplier_confirmation)
        (confirmation_has_transport ?supplier_confirmation)
        (not
          (approval_granted ?case_handler)
        )
      )
    :effect
      (and
        (approval_granted ?case_handler)
        (policy_applied ?case_handler)
      )
  )
  (:action finalize_handler_task
    :parameters (?case_handler - case_handler)
    :precondition
      (and
        (approval_granted ?case_handler)
        (not
          (policy_applied ?case_handler)
        )
        (not
          (handler_finalized ?case_handler)
        )
      )
    :effect
      (and
        (handler_finalized ?case_handler)
        (action_completed ?case_handler)
      )
  )
  (:action assign_compensation_option_to_handler
    :parameters (?case_handler - case_handler ?compensation_option - compensation_option)
    :precondition
      (and
        (approval_granted ?case_handler)
        (policy_applied ?case_handler)
        (compensation_option_available ?compensation_option)
      )
    :effect
      (and
        (handler_compensation_assigned ?case_handler ?compensation_option)
        (not
          (compensation_option_available ?compensation_option)
        )
      )
  )
  (:action escalate_case_to_senior_handler
    :parameters (?case_handler - case_handler ?itinerary_segment - itinerary_segment ?traveler_reservation - traveler_reservation ?communication_channel - communication_channel ?compensation_option - compensation_option)
    :precondition
      (and
        (approval_granted ?case_handler)
        (policy_applied ?case_handler)
        (handler_compensation_assigned ?case_handler ?compensation_option)
        (handler_responsible_for_segment ?case_handler ?itinerary_segment)
        (handler_responsible_for_reservation ?case_handler ?traveler_reservation)
        (segment_assessed ?itinerary_segment)
        (reservation_assessed ?traveler_reservation)
        (communication_channel_assigned ?case_handler ?communication_channel)
        (not
          (case_escalated ?case_handler)
        )
      )
    :effect (case_escalated ?case_handler)
  )
  (:action finalize_escalation
    :parameters (?case_handler - case_handler)
    :precondition
      (and
        (approval_granted ?case_handler)
        (case_escalated ?case_handler)
        (not
          (handler_finalized ?case_handler)
        )
      )
    :effect
      (and
        (handler_finalized ?case_handler)
        (action_completed ?case_handler)
      )
  )
  (:action initiate_partner_engagement
    :parameters (?case_handler - case_handler ?partner_organization - partner_organization ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_validated ?case_handler)
        (communication_channel_assigned ?case_handler ?communication_channel)
        (partner_available ?partner_organization)
        (handler_partner_assigned ?case_handler ?partner_organization)
        (not
          (partner_engagement_initiated ?case_handler)
        )
      )
    :effect
      (and
        (partner_engagement_initiated ?case_handler)
        (not
          (partner_available ?partner_organization)
        )
      )
  )
  (:action request_partner_clearance
    :parameters (?case_handler - case_handler ?on_site_staff - on_site_staff)
    :precondition
      (and
        (partner_engagement_initiated ?case_handler)
        (assigned_staff ?case_handler ?on_site_staff)
        (not
          (partner_clearance_in_progress ?case_handler)
        )
      )
    :effect (partner_clearance_in_progress ?case_handler)
  )
  (:action confirm_partner_clearance
    :parameters (?case_handler - case_handler ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (partner_clearance_in_progress ?case_handler)
        (handler_regulatory_clearance_assigned ?case_handler ?regulatory_clearance)
        (not
          (partner_clearance_obtained ?case_handler)
        )
      )
    :effect (partner_clearance_obtained ?case_handler)
  )
  (:action finalize_partner_clearance
    :parameters (?case_handler - case_handler)
    :precondition
      (and
        (partner_clearance_obtained ?case_handler)
        (not
          (handler_finalized ?case_handler)
        )
      )
    :effect
      (and
        (handler_finalized ?case_handler)
        (action_completed ?case_handler)
      )
  )
  (:action close_itinerary_segment
    :parameters (?itinerary_segment - itinerary_segment ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (segment_ready_for_consolidation ?itinerary_segment)
        (segment_assessed ?itinerary_segment)
        (supplier_confirmation_received ?supplier_confirmation)
        (supplier_confirmation_validated ?supplier_confirmation)
        (not
          (action_completed ?itinerary_segment)
        )
      )
    :effect (action_completed ?itinerary_segment)
  )
  (:action close_reservation
    :parameters (?traveler_reservation - traveler_reservation ?supplier_confirmation - supplier_confirmation)
    :precondition
      (and
        (reservation_ready_for_consolidation ?traveler_reservation)
        (reservation_assessed ?traveler_reservation)
        (supplier_confirmation_received ?supplier_confirmation)
        (supplier_confirmation_validated ?supplier_confirmation)
        (not
          (action_completed ?traveler_reservation)
        )
      )
    :effect (action_completed ?traveler_reservation)
  )
  (:action allocate_compensation_resource
    :parameters (?disruption_case - disruption_case ?compensation_resource - compensation_resource ?communication_channel - communication_channel)
    :precondition
      (and
        (action_completed ?disruption_case)
        (communication_channel_assigned ?disruption_case ?communication_channel)
        (compensation_resource_available ?compensation_resource)
        (not
          (compensation_assigned ?disruption_case)
        )
      )
    :effect
      (and
        (compensation_assigned ?disruption_case)
        (compensation_resource_allocated ?disruption_case ?compensation_resource)
        (not
          (compensation_resource_available ?compensation_resource)
        )
      )
  )
  (:action finalize_segment_compensation_and_release_provider
    :parameters (?itinerary_segment - itinerary_segment ?frontline_provider - frontline_provider ?compensation_resource - compensation_resource)
    :precondition
      (and
        (compensation_assigned ?itinerary_segment)
        (assigned_provider ?itinerary_segment ?frontline_provider)
        (compensation_resource_allocated ?itinerary_segment ?compensation_resource)
        (not
          (marked_resolved ?itinerary_segment)
        )
      )
    :effect
      (and
        (marked_resolved ?itinerary_segment)
        (provider_available ?frontline_provider)
        (compensation_resource_available ?compensation_resource)
      )
  )
  (:action finalize_reservation_compensation_and_release_provider
    :parameters (?traveler_reservation - traveler_reservation ?frontline_provider - frontline_provider ?compensation_resource - compensation_resource)
    :precondition
      (and
        (compensation_assigned ?traveler_reservation)
        (assigned_provider ?traveler_reservation ?frontline_provider)
        (compensation_resource_allocated ?traveler_reservation ?compensation_resource)
        (not
          (marked_resolved ?traveler_reservation)
        )
      )
    :effect
      (and
        (marked_resolved ?traveler_reservation)
        (provider_available ?frontline_provider)
        (compensation_resource_available ?compensation_resource)
      )
  )
  (:action finalize_handler_compensation_and_release_provider
    :parameters (?case_handler - case_handler ?frontline_provider - frontline_provider ?compensation_resource - compensation_resource)
    :precondition
      (and
        (compensation_assigned ?case_handler)
        (assigned_provider ?case_handler ?frontline_provider)
        (compensation_resource_allocated ?case_handler ?compensation_resource)
        (not
          (marked_resolved ?case_handler)
        )
      )
    :effect
      (and
        (marked_resolved ?case_handler)
        (provider_available ?frontline_provider)
        (compensation_resource_available ?compensation_resource)
      )
  )
)

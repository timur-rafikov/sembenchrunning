(define (domain event_centered_trip_schedule_design_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object allocable_option_category - object scheduling_category - object anchor_category - object event_anchor - anchor_category access_option - resource_category activity_option - resource_category service_provider - resource_category preference_token - resource_category accommodation_option - resource_category event_ticket - resource_category logistics_resource - resource_category temporal_constraint - resource_category add_on_option - allocable_option_category attraction - allocable_option_category special_event_element - allocable_option_category event_day_time_window - scheduling_category buffer_day_time_window - scheduling_category visit_proposal - scheduling_category day_category - event_anchor plan_category - event_anchor event_day - day_category buffer_day - day_category trip_plan - plan_category)
  (:predicates
    (anchor_initialized ?event_anchor - event_anchor)
    (ready_for_planning ?event_anchor - event_anchor)
    (destination_assigned ?event_anchor - event_anchor)
    (access_confirmed ?event_anchor - event_anchor)
    (commitment_marker ?event_anchor - event_anchor)
    (ticket_assigned ?event_anchor - event_anchor)
    (access_option_available ?access_option - access_option)
    (anchor_access_binding ?event_anchor - event_anchor ?access_option - access_option)
    (activity_available ?activity_option - activity_option)
    (anchor_activity_binding ?event_anchor - event_anchor ?activity_option - activity_option)
    (provider_available ?service_provider - service_provider)
    (anchor_provider_binding ?event_anchor - event_anchor ?service_provider - service_provider)
    (add_on_available ?add_on_option - add_on_option)
    (event_day_addon_binding ?event_day - event_day ?add_on_option - add_on_option)
    (buffer_day_addon_binding ?buffer_day - buffer_day ?add_on_option - add_on_option)
    (day_timewindow_member ?event_day - event_day ?event_day_time_window - event_day_time_window)
    (timewindow_ready ?event_day_time_window - event_day_time_window)
    (timewindow_with_addon ?event_day_time_window - event_day_time_window)
    (event_day_visit_assigned ?event_day - event_day)
    (buffer_day_timewindow_member ?buffer_day - buffer_day ?buffer_day_time_window - buffer_day_time_window)
    (buffer_timewindow_ready ?buffer_day_time_window - buffer_day_time_window)
    (buffer_timewindow_with_addon ?buffer_day_time_window - buffer_day_time_window)
    (buffer_day_visit_assigned ?buffer_day - buffer_day)
    (visitproposal_available ?visit_proposal - visit_proposal)
    (visitproposal_committed ?visit_proposal - visit_proposal)
    (visitproposal_to_event_timewindow ?visit_proposal - visit_proposal ?event_day_time_window - event_day_time_window)
    (visitproposal_to_buffer_timewindow ?visit_proposal - visit_proposal ?buffer_day_time_window - buffer_day_time_window)
    (visitproposal_event_addon_flag ?visit_proposal - visit_proposal)
    (visitproposal_buffer_addon_flag ?visit_proposal - visit_proposal)
    (visit_time_locked ?visit_proposal - visit_proposal)
    (plan_to_event_day ?trip_plan - trip_plan ?event_day - event_day)
    (plan_to_buffer_day ?trip_plan - trip_plan ?buffer_day - buffer_day)
    (plan_to_visit_proposal ?trip_plan - trip_plan ?visit_proposal - visit_proposal)
    (attraction_available ?attraction - attraction)
    (plan_to_attraction ?trip_plan - trip_plan ?attraction - attraction)
    (attraction_reserved ?attraction - attraction)
    (attraction_to_visitproposal ?attraction - attraction ?visit_proposal - visit_proposal)
    (plan_resources_allocated ?trip_plan - trip_plan)
    (plan_resources_confirmed ?trip_plan - trip_plan)
    (plan_stage_ready ?trip_plan - trip_plan)
    (preference_attached ?trip_plan - trip_plan)
    (plan_preference_staged ?trip_plan - trip_plan)
    (preferences_applied ?trip_plan - trip_plan)
    (plan_checks_passed ?trip_plan - trip_plan)
    (special_element_available ?special_event_element - special_event_element)
    (plan_to_special_element ?trip_plan - trip_plan ?special_event_element - special_event_element)
    (special_element_attached ?trip_plan - trip_plan)
    (special_element_service_reserved ?trip_plan - trip_plan)
    (special_element_confirmed ?trip_plan - trip_plan)
    (preference_token_available ?preference_token - preference_token)
    (plan_to_preference_binding ?trip_plan - trip_plan ?preference_token - preference_token)
    (accommodation_available ?accommodation_option - accommodation_option)
    (plan_to_accommodation_binding ?trip_plan - trip_plan ?accommodation_option - accommodation_option)
    (logistics_resource_available ?logistics_resource - logistics_resource)
    (plan_logistics_bound ?trip_plan - trip_plan ?logistics_resource - logistics_resource)
    (temporal_constraint_available ?temporal_constraint - temporal_constraint)
    (plan_temporal_constraint_binding ?trip_plan - trip_plan ?temporal_constraint - temporal_constraint)
    (event_ticket_available ?event_ticket - event_ticket)
    (anchor_ticket_binding ?event_anchor - event_anchor ?event_ticket - event_ticket)
    (event_day_resourced ?event_day - event_day)
    (buffer_day_resourced ?buffer_day - buffer_day)
    (plan_finalized ?trip_plan - trip_plan)
  )
  (:action initialize_event_anchor
    :parameters (?event_anchor - event_anchor)
    :precondition
      (and
        (not
          (anchor_initialized ?event_anchor)
        )
        (not
          (access_confirmed ?event_anchor)
        )
      )
    :effect (anchor_initialized ?event_anchor)
  )
  (:action assign_access_option
    :parameters (?event_anchor - event_anchor ?access_option - access_option)
    :precondition
      (and
        (anchor_initialized ?event_anchor)
        (not
          (destination_assigned ?event_anchor)
        )
        (access_option_available ?access_option)
      )
    :effect
      (and
        (destination_assigned ?event_anchor)
        (anchor_access_binding ?event_anchor ?access_option)
        (not
          (access_option_available ?access_option)
        )
      )
  )
  (:action assign_activity_to_anchor
    :parameters (?event_anchor - event_anchor ?activity_option - activity_option)
    :precondition
      (and
        (anchor_initialized ?event_anchor)
        (destination_assigned ?event_anchor)
        (activity_available ?activity_option)
      )
    :effect
      (and
        (anchor_activity_binding ?event_anchor ?activity_option)
        (not
          (activity_available ?activity_option)
        )
      )
  )
  (:action confirm_anchor_planning_ready
    :parameters (?event_anchor - event_anchor ?activity_option - activity_option)
    :precondition
      (and
        (anchor_initialized ?event_anchor)
        (destination_assigned ?event_anchor)
        (anchor_activity_binding ?event_anchor ?activity_option)
        (not
          (ready_for_planning ?event_anchor)
        )
      )
    :effect (ready_for_planning ?event_anchor)
  )
  (:action release_activity_from_anchor
    :parameters (?event_anchor - event_anchor ?activity_option - activity_option)
    :precondition
      (and
        (anchor_activity_binding ?event_anchor ?activity_option)
      )
    :effect
      (and
        (activity_available ?activity_option)
        (not
          (anchor_activity_binding ?event_anchor ?activity_option)
        )
      )
  )
  (:action reserve_provider_for_anchor
    :parameters (?event_anchor - event_anchor ?service_provider - service_provider)
    :precondition
      (and
        (ready_for_planning ?event_anchor)
        (provider_available ?service_provider)
      )
    :effect
      (and
        (anchor_provider_binding ?event_anchor ?service_provider)
        (not
          (provider_available ?service_provider)
        )
      )
  )
  (:action release_provider_from_anchor
    :parameters (?event_anchor - event_anchor ?service_provider - service_provider)
    :precondition
      (and
        (anchor_provider_binding ?event_anchor ?service_provider)
      )
    :effect
      (and
        (provider_available ?service_provider)
        (not
          (anchor_provider_binding ?event_anchor ?service_provider)
        )
      )
  )
  (:action allocate_logistics_to_plan
    :parameters (?trip_plan - trip_plan ?logistics_resource - logistics_resource)
    :precondition
      (and
        (ready_for_planning ?trip_plan)
        (logistics_resource_available ?logistics_resource)
      )
    :effect
      (and
        (plan_logistics_bound ?trip_plan ?logistics_resource)
        (not
          (logistics_resource_available ?logistics_resource)
        )
      )
  )
  (:action release_logistics_from_plan
    :parameters (?trip_plan - trip_plan ?logistics_resource - logistics_resource)
    :precondition
      (and
        (plan_logistics_bound ?trip_plan ?logistics_resource)
      )
    :effect
      (and
        (logistics_resource_available ?logistics_resource)
        (not
          (plan_logistics_bound ?trip_plan ?logistics_resource)
        )
      )
  )
  (:action attach_temporal_constraint_to_plan
    :parameters (?trip_plan - trip_plan ?temporal_constraint - temporal_constraint)
    :precondition
      (and
        (ready_for_planning ?trip_plan)
        (temporal_constraint_available ?temporal_constraint)
      )
    :effect
      (and
        (plan_temporal_constraint_binding ?trip_plan ?temporal_constraint)
        (not
          (temporal_constraint_available ?temporal_constraint)
        )
      )
  )
  (:action detach_temporal_constraint_from_plan
    :parameters (?trip_plan - trip_plan ?temporal_constraint - temporal_constraint)
    :precondition
      (and
        (plan_temporal_constraint_binding ?trip_plan ?temporal_constraint)
      )
    :effect
      (and
        (temporal_constraint_available ?temporal_constraint)
        (not
          (plan_temporal_constraint_binding ?trip_plan ?temporal_constraint)
        )
      )
  )
  (:action mark_event_timewindow_ready
    :parameters (?event_day - event_day ?event_day_time_window - event_day_time_window ?activity_option - activity_option)
    :precondition
      (and
        (ready_for_planning ?event_day)
        (anchor_activity_binding ?event_day ?activity_option)
        (day_timewindow_member ?event_day ?event_day_time_window)
        (not
          (timewindow_ready ?event_day_time_window)
        )
        (not
          (timewindow_with_addon ?event_day_time_window)
        )
      )
    :effect (timewindow_ready ?event_day_time_window)
  )
  (:action reserve_provider_for_event_day
    :parameters (?event_day - event_day ?event_day_time_window - event_day_time_window ?service_provider - service_provider)
    :precondition
      (and
        (ready_for_planning ?event_day)
        (anchor_provider_binding ?event_day ?service_provider)
        (day_timewindow_member ?event_day ?event_day_time_window)
        (timewindow_ready ?event_day_time_window)
        (not
          (event_day_resourced ?event_day)
        )
      )
    :effect
      (and
        (event_day_resourced ?event_day)
        (event_day_visit_assigned ?event_day)
      )
  )
  (:action apply_addon_to_event_day
    :parameters (?event_day - event_day ?event_day_time_window - event_day_time_window ?add_on_option - add_on_option)
    :precondition
      (and
        (ready_for_planning ?event_day)
        (day_timewindow_member ?event_day ?event_day_time_window)
        (add_on_available ?add_on_option)
        (not
          (event_day_resourced ?event_day)
        )
      )
    :effect
      (and
        (timewindow_with_addon ?event_day_time_window)
        (event_day_resourced ?event_day)
        (event_day_addon_binding ?event_day ?add_on_option)
        (not
          (add_on_available ?add_on_option)
        )
      )
  )
  (:action confirm_event_day_visit_with_addon
    :parameters (?event_day - event_day ?event_day_time_window - event_day_time_window ?activity_option - activity_option ?add_on_option - add_on_option)
    :precondition
      (and
        (ready_for_planning ?event_day)
        (anchor_activity_binding ?event_day ?activity_option)
        (day_timewindow_member ?event_day ?event_day_time_window)
        (timewindow_with_addon ?event_day_time_window)
        (event_day_addon_binding ?event_day ?add_on_option)
        (not
          (event_day_visit_assigned ?event_day)
        )
      )
    :effect
      (and
        (timewindow_ready ?event_day_time_window)
        (event_day_visit_assigned ?event_day)
        (add_on_available ?add_on_option)
        (not
          (event_day_addon_binding ?event_day ?add_on_option)
        )
      )
  )
  (:action mark_buffer_timewindow_ready
    :parameters (?buffer_day - buffer_day ?buffer_day_time_window - buffer_day_time_window ?activity_option - activity_option)
    :precondition
      (and
        (ready_for_planning ?buffer_day)
        (anchor_activity_binding ?buffer_day ?activity_option)
        (buffer_day_timewindow_member ?buffer_day ?buffer_day_time_window)
        (not
          (buffer_timewindow_ready ?buffer_day_time_window)
        )
        (not
          (buffer_timewindow_with_addon ?buffer_day_time_window)
        )
      )
    :effect (buffer_timewindow_ready ?buffer_day_time_window)
  )
  (:action reserve_provider_for_buffer_day
    :parameters (?buffer_day - buffer_day ?buffer_day_time_window - buffer_day_time_window ?service_provider - service_provider)
    :precondition
      (and
        (ready_for_planning ?buffer_day)
        (anchor_provider_binding ?buffer_day ?service_provider)
        (buffer_day_timewindow_member ?buffer_day ?buffer_day_time_window)
        (buffer_timewindow_ready ?buffer_day_time_window)
        (not
          (buffer_day_resourced ?buffer_day)
        )
      )
    :effect
      (and
        (buffer_day_resourced ?buffer_day)
        (buffer_day_visit_assigned ?buffer_day)
      )
  )
  (:action apply_addon_to_buffer_day
    :parameters (?buffer_day - buffer_day ?buffer_day_time_window - buffer_day_time_window ?add_on_option - add_on_option)
    :precondition
      (and
        (ready_for_planning ?buffer_day)
        (buffer_day_timewindow_member ?buffer_day ?buffer_day_time_window)
        (add_on_available ?add_on_option)
        (not
          (buffer_day_resourced ?buffer_day)
        )
      )
    :effect
      (and
        (buffer_timewindow_with_addon ?buffer_day_time_window)
        (buffer_day_resourced ?buffer_day)
        (buffer_day_addon_binding ?buffer_day ?add_on_option)
        (not
          (add_on_available ?add_on_option)
        )
      )
  )
  (:action confirm_buffer_day_visit_with_addon
    :parameters (?buffer_day - buffer_day ?buffer_day_time_window - buffer_day_time_window ?activity_option - activity_option ?add_on_option - add_on_option)
    :precondition
      (and
        (ready_for_planning ?buffer_day)
        (anchor_activity_binding ?buffer_day ?activity_option)
        (buffer_day_timewindow_member ?buffer_day ?buffer_day_time_window)
        (buffer_timewindow_with_addon ?buffer_day_time_window)
        (buffer_day_addon_binding ?buffer_day ?add_on_option)
        (not
          (buffer_day_visit_assigned ?buffer_day)
        )
      )
    :effect
      (and
        (buffer_timewindow_ready ?buffer_day_time_window)
        (buffer_day_visit_assigned ?buffer_day)
        (add_on_available ?add_on_option)
        (not
          (buffer_day_addon_binding ?buffer_day ?add_on_option)
        )
      )
  )
  (:action assemble_visit_proposal
    :parameters (?event_day - event_day ?buffer_day - buffer_day ?event_day_time_window - event_day_time_window ?buffer_day_time_window - buffer_day_time_window ?visit_proposal - visit_proposal)
    :precondition
      (and
        (event_day_resourced ?event_day)
        (buffer_day_resourced ?buffer_day)
        (day_timewindow_member ?event_day ?event_day_time_window)
        (buffer_day_timewindow_member ?buffer_day ?buffer_day_time_window)
        (timewindow_ready ?event_day_time_window)
        (buffer_timewindow_ready ?buffer_day_time_window)
        (event_day_visit_assigned ?event_day)
        (buffer_day_visit_assigned ?buffer_day)
        (visitproposal_available ?visit_proposal)
      )
    :effect
      (and
        (visitproposal_committed ?visit_proposal)
        (visitproposal_to_event_timewindow ?visit_proposal ?event_day_time_window)
        (visitproposal_to_buffer_timewindow ?visit_proposal ?buffer_day_time_window)
        (not
          (visitproposal_available ?visit_proposal)
        )
      )
  )
  (:action assemble_visit_proposal_with_event_addon
    :parameters (?event_day - event_day ?buffer_day - buffer_day ?event_day_time_window - event_day_time_window ?buffer_day_time_window - buffer_day_time_window ?visit_proposal - visit_proposal)
    :precondition
      (and
        (event_day_resourced ?event_day)
        (buffer_day_resourced ?buffer_day)
        (day_timewindow_member ?event_day ?event_day_time_window)
        (buffer_day_timewindow_member ?buffer_day ?buffer_day_time_window)
        (timewindow_with_addon ?event_day_time_window)
        (buffer_timewindow_ready ?buffer_day_time_window)
        (not
          (event_day_visit_assigned ?event_day)
        )
        (buffer_day_visit_assigned ?buffer_day)
        (visitproposal_available ?visit_proposal)
      )
    :effect
      (and
        (visitproposal_committed ?visit_proposal)
        (visitproposal_to_event_timewindow ?visit_proposal ?event_day_time_window)
        (visitproposal_to_buffer_timewindow ?visit_proposal ?buffer_day_time_window)
        (visitproposal_event_addon_flag ?visit_proposal)
        (not
          (visitproposal_available ?visit_proposal)
        )
      )
  )
  (:action assemble_visit_proposal_with_buffer_addon
    :parameters (?event_day - event_day ?buffer_day - buffer_day ?event_day_time_window - event_day_time_window ?buffer_day_time_window - buffer_day_time_window ?visit_proposal - visit_proposal)
    :precondition
      (and
        (event_day_resourced ?event_day)
        (buffer_day_resourced ?buffer_day)
        (day_timewindow_member ?event_day ?event_day_time_window)
        (buffer_day_timewindow_member ?buffer_day ?buffer_day_time_window)
        (timewindow_ready ?event_day_time_window)
        (buffer_timewindow_with_addon ?buffer_day_time_window)
        (event_day_visit_assigned ?event_day)
        (not
          (buffer_day_visit_assigned ?buffer_day)
        )
        (visitproposal_available ?visit_proposal)
      )
    :effect
      (and
        (visitproposal_committed ?visit_proposal)
        (visitproposal_to_event_timewindow ?visit_proposal ?event_day_time_window)
        (visitproposal_to_buffer_timewindow ?visit_proposal ?buffer_day_time_window)
        (visitproposal_buffer_addon_flag ?visit_proposal)
        (not
          (visitproposal_available ?visit_proposal)
        )
      )
  )
  (:action assemble_visit_proposal_with_both_addons
    :parameters (?event_day - event_day ?buffer_day - buffer_day ?event_day_time_window - event_day_time_window ?buffer_day_time_window - buffer_day_time_window ?visit_proposal - visit_proposal)
    :precondition
      (and
        (event_day_resourced ?event_day)
        (buffer_day_resourced ?buffer_day)
        (day_timewindow_member ?event_day ?event_day_time_window)
        (buffer_day_timewindow_member ?buffer_day ?buffer_day_time_window)
        (timewindow_with_addon ?event_day_time_window)
        (buffer_timewindow_with_addon ?buffer_day_time_window)
        (not
          (event_day_visit_assigned ?event_day)
        )
        (not
          (buffer_day_visit_assigned ?buffer_day)
        )
        (visitproposal_available ?visit_proposal)
      )
    :effect
      (and
        (visitproposal_committed ?visit_proposal)
        (visitproposal_to_event_timewindow ?visit_proposal ?event_day_time_window)
        (visitproposal_to_buffer_timewindow ?visit_proposal ?buffer_day_time_window)
        (visitproposal_event_addon_flag ?visit_proposal)
        (visitproposal_buffer_addon_flag ?visit_proposal)
        (not
          (visitproposal_available ?visit_proposal)
        )
      )
  )
  (:action lock_visit_time
    :parameters (?visit_proposal - visit_proposal ?event_day - event_day ?activity_option - activity_option)
    :precondition
      (and
        (visitproposal_committed ?visit_proposal)
        (event_day_resourced ?event_day)
        (anchor_activity_binding ?event_day ?activity_option)
        (not
          (visit_time_locked ?visit_proposal)
        )
      )
    :effect (visit_time_locked ?visit_proposal)
  )
  (:action attach_attraction_to_visit_proposal
    :parameters (?trip_plan - trip_plan ?attraction - attraction ?visit_proposal - visit_proposal)
    :precondition
      (and
        (ready_for_planning ?trip_plan)
        (plan_to_visit_proposal ?trip_plan ?visit_proposal)
        (plan_to_attraction ?trip_plan ?attraction)
        (attraction_available ?attraction)
        (visitproposal_committed ?visit_proposal)
        (visit_time_locked ?visit_proposal)
        (not
          (attraction_reserved ?attraction)
        )
      )
    :effect
      (and
        (attraction_reserved ?attraction)
        (attraction_to_visitproposal ?attraction ?visit_proposal)
        (not
          (attraction_available ?attraction)
        )
      )
  )
  (:action confirm_attraction_in_plan
    :parameters (?trip_plan - trip_plan ?attraction - attraction ?visit_proposal - visit_proposal ?activity_option - activity_option)
    :precondition
      (and
        (ready_for_planning ?trip_plan)
        (plan_to_attraction ?trip_plan ?attraction)
        (attraction_reserved ?attraction)
        (attraction_to_visitproposal ?attraction ?visit_proposal)
        (anchor_activity_binding ?trip_plan ?activity_option)
        (not
          (visitproposal_event_addon_flag ?visit_proposal)
        )
        (not
          (plan_resources_allocated ?trip_plan)
        )
      )
    :effect (plan_resources_allocated ?trip_plan)
  )
  (:action attach_preference_to_plan
    :parameters (?trip_plan - trip_plan ?preference_token - preference_token)
    :precondition
      (and
        (ready_for_planning ?trip_plan)
        (preference_token_available ?preference_token)
        (not
          (preference_attached ?trip_plan)
        )
      )
    :effect
      (and
        (preference_attached ?trip_plan)
        (plan_to_preference_binding ?trip_plan ?preference_token)
        (not
          (preference_token_available ?preference_token)
        )
      )
  )
  (:action apply_preference_and_stage_plan
    :parameters (?trip_plan - trip_plan ?attraction - attraction ?visit_proposal - visit_proposal ?activity_option - activity_option ?preference_token - preference_token)
    :precondition
      (and
        (ready_for_planning ?trip_plan)
        (plan_to_attraction ?trip_plan ?attraction)
        (attraction_reserved ?attraction)
        (attraction_to_visitproposal ?attraction ?visit_proposal)
        (anchor_activity_binding ?trip_plan ?activity_option)
        (visitproposal_event_addon_flag ?visit_proposal)
        (preference_attached ?trip_plan)
        (plan_to_preference_binding ?trip_plan ?preference_token)
        (not
          (plan_resources_allocated ?trip_plan)
        )
      )
    :effect
      (and
        (plan_resources_allocated ?trip_plan)
        (plan_preference_staged ?trip_plan)
      )
  )
  (:action reserve_logistics_and_confirm_plan_stage
    :parameters (?trip_plan - trip_plan ?logistics_resource - logistics_resource ?service_provider - service_provider ?attraction - attraction ?visit_proposal - visit_proposal)
    :precondition
      (and
        (plan_resources_allocated ?trip_plan)
        (plan_logistics_bound ?trip_plan ?logistics_resource)
        (anchor_provider_binding ?trip_plan ?service_provider)
        (plan_to_attraction ?trip_plan ?attraction)
        (attraction_to_visitproposal ?attraction ?visit_proposal)
        (not
          (visitproposal_buffer_addon_flag ?visit_proposal)
        )
        (not
          (plan_resources_confirmed ?trip_plan)
        )
      )
    :effect (plan_resources_confirmed ?trip_plan)
  )
  (:action confirm_plan_stage_with_buffer_addon
    :parameters (?trip_plan - trip_plan ?logistics_resource - logistics_resource ?service_provider - service_provider ?attraction - attraction ?visit_proposal - visit_proposal)
    :precondition
      (and
        (plan_resources_allocated ?trip_plan)
        (plan_logistics_bound ?trip_plan ?logistics_resource)
        (anchor_provider_binding ?trip_plan ?service_provider)
        (plan_to_attraction ?trip_plan ?attraction)
        (attraction_to_visitproposal ?attraction ?visit_proposal)
        (visitproposal_buffer_addon_flag ?visit_proposal)
        (not
          (plan_resources_confirmed ?trip_plan)
        )
      )
    :effect (plan_resources_confirmed ?trip_plan)
  )
  (:action mark_plan_stage_ready
    :parameters (?trip_plan - trip_plan ?temporal_constraint - temporal_constraint ?attraction - attraction ?visit_proposal - visit_proposal)
    :precondition
      (and
        (plan_resources_confirmed ?trip_plan)
        (plan_temporal_constraint_binding ?trip_plan ?temporal_constraint)
        (plan_to_attraction ?trip_plan ?attraction)
        (attraction_to_visitproposal ?attraction ?visit_proposal)
        (not
          (visitproposal_event_addon_flag ?visit_proposal)
        )
        (not
          (visitproposal_buffer_addon_flag ?visit_proposal)
        )
        (not
          (plan_stage_ready ?trip_plan)
        )
      )
    :effect (plan_stage_ready ?trip_plan)
  )
  (:action mark_plan_ready_and_apply_preferences
    :parameters (?trip_plan - trip_plan ?temporal_constraint - temporal_constraint ?attraction - attraction ?visit_proposal - visit_proposal)
    :precondition
      (and
        (plan_resources_confirmed ?trip_plan)
        (plan_temporal_constraint_binding ?trip_plan ?temporal_constraint)
        (plan_to_attraction ?trip_plan ?attraction)
        (attraction_to_visitproposal ?attraction ?visit_proposal)
        (visitproposal_event_addon_flag ?visit_proposal)
        (not
          (visitproposal_buffer_addon_flag ?visit_proposal)
        )
        (not
          (plan_stage_ready ?trip_plan)
        )
      )
    :effect
      (and
        (plan_stage_ready ?trip_plan)
        (preferences_applied ?trip_plan)
      )
  )
  (:action mark_plan_ready_and_apply_preferences_buffer
    :parameters (?trip_plan - trip_plan ?temporal_constraint - temporal_constraint ?attraction - attraction ?visit_proposal - visit_proposal)
    :precondition
      (and
        (plan_resources_confirmed ?trip_plan)
        (plan_temporal_constraint_binding ?trip_plan ?temporal_constraint)
        (plan_to_attraction ?trip_plan ?attraction)
        (attraction_to_visitproposal ?attraction ?visit_proposal)
        (not
          (visitproposal_event_addon_flag ?visit_proposal)
        )
        (visitproposal_buffer_addon_flag ?visit_proposal)
        (not
          (plan_stage_ready ?trip_plan)
        )
      )
    :effect
      (and
        (plan_stage_ready ?trip_plan)
        (preferences_applied ?trip_plan)
      )
  )
  (:action mark_plan_ready_and_apply_preferences_both_addons
    :parameters (?trip_plan - trip_plan ?temporal_constraint - temporal_constraint ?attraction - attraction ?visit_proposal - visit_proposal)
    :precondition
      (and
        (plan_resources_confirmed ?trip_plan)
        (plan_temporal_constraint_binding ?trip_plan ?temporal_constraint)
        (plan_to_attraction ?trip_plan ?attraction)
        (attraction_to_visitproposal ?attraction ?visit_proposal)
        (visitproposal_event_addon_flag ?visit_proposal)
        (visitproposal_buffer_addon_flag ?visit_proposal)
        (not
          (plan_stage_ready ?trip_plan)
        )
      )
    :effect
      (and
        (plan_stage_ready ?trip_plan)
        (preferences_applied ?trip_plan)
      )
  )
  (:action finalize_trip_plan
    :parameters (?trip_plan - trip_plan)
    :precondition
      (and
        (plan_stage_ready ?trip_plan)
        (not
          (preferences_applied ?trip_plan)
        )
        (not
          (plan_finalized ?trip_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?trip_plan)
        (commitment_marker ?trip_plan)
      )
  )
  (:action assign_accommodation_to_plan
    :parameters (?trip_plan - trip_plan ?accommodation_option - accommodation_option)
    :precondition
      (and
        (plan_stage_ready ?trip_plan)
        (preferences_applied ?trip_plan)
        (accommodation_available ?accommodation_option)
      )
    :effect
      (and
        (plan_to_accommodation_binding ?trip_plan ?accommodation_option)
        (not
          (accommodation_available ?accommodation_option)
        )
      )
  )
  (:action perform_multiresource_checks
    :parameters (?trip_plan - trip_plan ?event_day - event_day ?buffer_day - buffer_day ?activity_option - activity_option ?accommodation_option - accommodation_option)
    :precondition
      (and
        (plan_stage_ready ?trip_plan)
        (preferences_applied ?trip_plan)
        (plan_to_accommodation_binding ?trip_plan ?accommodation_option)
        (plan_to_event_day ?trip_plan ?event_day)
        (plan_to_buffer_day ?trip_plan ?buffer_day)
        (event_day_visit_assigned ?event_day)
        (buffer_day_visit_assigned ?buffer_day)
        (anchor_activity_binding ?trip_plan ?activity_option)
        (not
          (plan_checks_passed ?trip_plan)
        )
      )
    :effect (plan_checks_passed ?trip_plan)
  )
  (:action finalize_trip_plan_after_checks
    :parameters (?trip_plan - trip_plan)
    :precondition
      (and
        (plan_stage_ready ?trip_plan)
        (plan_checks_passed ?trip_plan)
        (not
          (plan_finalized ?trip_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?trip_plan)
        (commitment_marker ?trip_plan)
      )
  )
  (:action attach_special_element_to_plan
    :parameters (?trip_plan - trip_plan ?special_event_element - special_event_element ?activity_option - activity_option)
    :precondition
      (and
        (ready_for_planning ?trip_plan)
        (anchor_activity_binding ?trip_plan ?activity_option)
        (special_element_available ?special_event_element)
        (plan_to_special_element ?trip_plan ?special_event_element)
        (not
          (special_element_attached ?trip_plan)
        )
      )
    :effect
      (and
        (special_element_attached ?trip_plan)
        (not
          (special_element_available ?special_event_element)
        )
      )
  )
  (:action reserve_service_for_special_element
    :parameters (?trip_plan - trip_plan ?service_provider - service_provider)
    :precondition
      (and
        (special_element_attached ?trip_plan)
        (anchor_provider_binding ?trip_plan ?service_provider)
        (not
          (special_element_service_reserved ?trip_plan)
        )
      )
    :effect (special_element_service_reserved ?trip_plan)
  )
  (:action confirm_special_element
    :parameters (?trip_plan - trip_plan ?temporal_constraint - temporal_constraint)
    :precondition
      (and
        (special_element_service_reserved ?trip_plan)
        (plan_temporal_constraint_binding ?trip_plan ?temporal_constraint)
        (not
          (special_element_confirmed ?trip_plan)
        )
      )
    :effect (special_element_confirmed ?trip_plan)
  )
  (:action finalize_trip_plan_with_special_element
    :parameters (?trip_plan - trip_plan)
    :precondition
      (and
        (special_element_confirmed ?trip_plan)
        (not
          (plan_finalized ?trip_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?trip_plan)
        (commitment_marker ?trip_plan)
      )
  )
  (:action finalize_event_day
    :parameters (?event_day - event_day ?visit_proposal - visit_proposal)
    :precondition
      (and
        (event_day_resourced ?event_day)
        (event_day_visit_assigned ?event_day)
        (visitproposal_committed ?visit_proposal)
        (visit_time_locked ?visit_proposal)
        (not
          (commitment_marker ?event_day)
        )
      )
    :effect (commitment_marker ?event_day)
  )
  (:action finalize_buffer_day
    :parameters (?buffer_day - buffer_day ?visit_proposal - visit_proposal)
    :precondition
      (and
        (buffer_day_resourced ?buffer_day)
        (buffer_day_visit_assigned ?buffer_day)
        (visitproposal_committed ?visit_proposal)
        (visit_time_locked ?visit_proposal)
        (not
          (commitment_marker ?buffer_day)
        )
      )
    :effect (commitment_marker ?buffer_day)
  )
  (:action assign_ticket_to_anchor
    :parameters (?event_anchor - event_anchor ?event_ticket - event_ticket ?activity_option - activity_option)
    :precondition
      (and
        (commitment_marker ?event_anchor)
        (anchor_activity_binding ?event_anchor ?activity_option)
        (event_ticket_available ?event_ticket)
        (not
          (ticket_assigned ?event_anchor)
        )
      )
    :effect
      (and
        (ticket_assigned ?event_anchor)
        (anchor_ticket_binding ?event_anchor ?event_ticket)
        (not
          (event_ticket_available ?event_ticket)
        )
      )
  )
  (:action propagate_ticket_to_event_day
    :parameters (?event_day - event_day ?access_option - access_option ?event_ticket - event_ticket)
    :precondition
      (and
        (ticket_assigned ?event_day)
        (anchor_access_binding ?event_day ?access_option)
        (anchor_ticket_binding ?event_day ?event_ticket)
        (not
          (access_confirmed ?event_day)
        )
      )
    :effect
      (and
        (access_confirmed ?event_day)
        (access_option_available ?access_option)
        (event_ticket_available ?event_ticket)
      )
  )
  (:action propagate_ticket_to_buffer_day
    :parameters (?buffer_day - buffer_day ?access_option - access_option ?event_ticket - event_ticket)
    :precondition
      (and
        (ticket_assigned ?buffer_day)
        (anchor_access_binding ?buffer_day ?access_option)
        (anchor_ticket_binding ?buffer_day ?event_ticket)
        (not
          (access_confirmed ?buffer_day)
        )
      )
    :effect
      (and
        (access_confirmed ?buffer_day)
        (access_option_available ?access_option)
        (event_ticket_available ?event_ticket)
      )
  )
  (:action propagate_ticket_to_plan
    :parameters (?trip_plan - trip_plan ?access_option - access_option ?event_ticket - event_ticket)
    :precondition
      (and
        (ticket_assigned ?trip_plan)
        (anchor_access_binding ?trip_plan ?access_option)
        (anchor_ticket_binding ?trip_plan ?event_ticket)
        (not
          (access_confirmed ?trip_plan)
        )
      )
    :effect
      (and
        (access_confirmed ?trip_plan)
        (access_option_available ?access_option)
        (event_ticket_available ?event_ticket)
      )
  )
)

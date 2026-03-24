(define (domain missed_pickup_recovery_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource - object asset_group - object routing_option_group - object case_root - object pickup_case - case_root vehicle - resource time_window - resource local_operator - resource facility - resource authorization_token - resource evidence_document - resource carrier_option - resource authorization_code - resource consignment - asset_group equipment_set - asset_group escalation_contact - asset_group contingency_route - routing_option_group alternate_route - routing_option_group recovery_shipment - routing_option_group planned_stop - pickup_case task_group - pickup_case origin_stop - planned_stop alternate_stop - planned_stop recovery_case - task_group)
  (:predicates
    (case_registered ?pickup_case - pickup_case)
    (case_confirmed ?pickup_case - pickup_case)
    (case_has_vehicle_assignment ?pickup_case - pickup_case)
    (case_restored ?pickup_case - pickup_case)
    (restoration_verified ?pickup_case - pickup_case)
    (restoration_finalized ?pickup_case - pickup_case)
    (vehicle_available ?vehicle - vehicle)
    (case_assigned_vehicle ?pickup_case - pickup_case ?vehicle - vehicle)
    (time_window_available ?time_window - time_window)
    (case_scheduled_in_time_window ?pickup_case - pickup_case ?time_window - time_window)
    (operator_available ?local_operator - local_operator)
    (case_assigned_operator ?pickup_case - pickup_case ?local_operator - local_operator)
    (consignment_available ?consignment - consignment)
    (origin_stop_assigned_consignment ?origin_stop - origin_stop ?consignment - consignment)
    (alternate_stop_assigned_consignment ?alternate_stop - alternate_stop ?consignment - consignment)
    (stop_contingency_route ?origin_stop - origin_stop ?contingency_route - contingency_route)
    (contingency_route_ready ?contingency_route - contingency_route)
    (contingency_route_staged ?contingency_route - contingency_route)
    (origin_stop_ready ?origin_stop - origin_stop)
    (alternate_stop_candidate_route ?alternate_stop - alternate_stop ?alternate_route - alternate_route)
    (alternate_route_ready ?alternate_route - alternate_route)
    (alternate_route_staged ?alternate_route - alternate_route)
    (alternate_stop_ready ?alternate_stop - alternate_stop)
    (recovery_shipment_available ?recovery_shipment - recovery_shipment)
    (recovery_shipment_allocated ?recovery_shipment - recovery_shipment)
    (shipment_uses_contingency_route ?recovery_shipment - recovery_shipment ?contingency_route - contingency_route)
    (shipment_uses_alternate_route ?recovery_shipment - recovery_shipment ?alternate_route - alternate_route)
    (shipment_contingency_flag ?recovery_shipment - recovery_shipment)
    (shipment_alternate_flag ?recovery_shipment - recovery_shipment)
    (shipment_manifested ?recovery_shipment - recovery_shipment)
    (recovery_case_origin_stop ?recovery_case - recovery_case ?origin_stop - origin_stop)
    (recovery_case_alternate_stop ?recovery_case - recovery_case ?alternate_stop - alternate_stop)
    (recovery_case_includes_shipment ?recovery_case - recovery_case ?recovery_shipment - recovery_shipment)
    (equipment_available ?equipment_set - equipment_set)
    (recovery_case_requires_equipment ?recovery_case - recovery_case ?equipment_set - equipment_set)
    (equipment_reserved ?equipment_set - equipment_set)
    (equipment_allocated_to_shipment ?equipment_set - equipment_set ?recovery_shipment - recovery_shipment)
    (carrier_option_applicable ?recovery_case - recovery_case)
    (carrier_option_committed ?recovery_case - recovery_case)
    (case_authorized ?recovery_case - recovery_case)
    (facility_assigned ?recovery_case - recovery_case)
    (facility_confirmed ?recovery_case - recovery_case)
    (approval_attached ?recovery_case - recovery_case)
    (manifest_completed ?recovery_case - recovery_case)
    (escalation_contact_available ?escalation_contact - escalation_contact)
    (case_has_escalation_contact ?recovery_case - recovery_case ?escalation_contact - escalation_contact)
    (escalation_triggered ?recovery_case - recovery_case)
    (escalation_engaged ?recovery_case - recovery_case)
    (escalation_action_completed ?recovery_case - recovery_case)
    (facility_available ?facility - facility)
    (case_assigned_facility ?recovery_case - recovery_case ?facility - facility)
    (authorization_token_available ?authorization_token - authorization_token)
    (case_assigned_authorization_token ?recovery_case - recovery_case ?authorization_token - authorization_token)
    (carrier_option_available ?carrier_option - carrier_option)
    (case_assigned_carrier_option ?recovery_case - recovery_case ?carrier_option - carrier_option)
    (authorization_code_available ?authorization_code - authorization_code)
    (case_assigned_authorization_code ?recovery_case - recovery_case ?authorization_code - authorization_code)
    (evidence_document_available ?evidence_document - evidence_document)
    (case_linked_evidence ?pickup_case - pickup_case ?evidence_document - evidence_document)
    (stop_prepared_for_shipment ?origin_stop - origin_stop)
    (alternate_stop_prepared_for_shipment ?alternate_stop - alternate_stop)
    (activation_recorded ?recovery_case - recovery_case)
  )
  (:action register_missed_pickup_case
    :parameters (?pickup_case - pickup_case)
    :precondition
      (and
        (not
          (case_registered ?pickup_case)
        )
        (not
          (case_restored ?pickup_case)
        )
      )
    :effect (case_registered ?pickup_case)
  )
  (:action provisionally_assign_vehicle_to_case
    :parameters (?pickup_case - pickup_case ?vehicle - vehicle)
    :precondition
      (and
        (case_registered ?pickup_case)
        (not
          (case_has_vehicle_assignment ?pickup_case)
        )
        (vehicle_available ?vehicle)
      )
    :effect
      (and
        (case_has_vehicle_assignment ?pickup_case)
        (case_assigned_vehicle ?pickup_case ?vehicle)
        (not
          (vehicle_available ?vehicle)
        )
      )
  )
  (:action reserve_time_window_for_case
    :parameters (?pickup_case - pickup_case ?time_window - time_window)
    :precondition
      (and
        (case_registered ?pickup_case)
        (case_has_vehicle_assignment ?pickup_case)
        (time_window_available ?time_window)
      )
    :effect
      (and
        (case_scheduled_in_time_window ?pickup_case ?time_window)
        (not
          (time_window_available ?time_window)
        )
      )
  )
  (:action confirm_time_window_for_case
    :parameters (?pickup_case - pickup_case ?time_window - time_window)
    :precondition
      (and
        (case_registered ?pickup_case)
        (case_has_vehicle_assignment ?pickup_case)
        (case_scheduled_in_time_window ?pickup_case ?time_window)
        (not
          (case_confirmed ?pickup_case)
        )
      )
    :effect (case_confirmed ?pickup_case)
  )
  (:action release_time_window_from_case
    :parameters (?pickup_case - pickup_case ?time_window - time_window)
    :precondition
      (and
        (case_scheduled_in_time_window ?pickup_case ?time_window)
      )
    :effect
      (and
        (time_window_available ?time_window)
        (not
          (case_scheduled_in_time_window ?pickup_case ?time_window)
        )
      )
  )
  (:action assign_local_operator_to_case
    :parameters (?pickup_case - pickup_case ?local_operator - local_operator)
    :precondition
      (and
        (case_confirmed ?pickup_case)
        (operator_available ?local_operator)
      )
    :effect
      (and
        (case_assigned_operator ?pickup_case ?local_operator)
        (not
          (operator_available ?local_operator)
        )
      )
  )
  (:action release_local_operator_from_case
    :parameters (?pickup_case - pickup_case ?local_operator - local_operator)
    :precondition
      (and
        (case_assigned_operator ?pickup_case ?local_operator)
      )
    :effect
      (and
        (operator_available ?local_operator)
        (not
          (case_assigned_operator ?pickup_case ?local_operator)
        )
      )
  )
  (:action assign_carrier_option_to_recovery_case
    :parameters (?recovery_case - recovery_case ?carrier_option - carrier_option)
    :precondition
      (and
        (case_confirmed ?recovery_case)
        (carrier_option_available ?carrier_option)
      )
    :effect
      (and
        (case_assigned_carrier_option ?recovery_case ?carrier_option)
        (not
          (carrier_option_available ?carrier_option)
        )
      )
  )
  (:action release_carrier_option_from_case
    :parameters (?recovery_case - recovery_case ?carrier_option - carrier_option)
    :precondition
      (and
        (case_assigned_carrier_option ?recovery_case ?carrier_option)
      )
    :effect
      (and
        (carrier_option_available ?carrier_option)
        (not
          (case_assigned_carrier_option ?recovery_case ?carrier_option)
        )
      )
  )
  (:action assign_authorization_code_to_recovery_case
    :parameters (?recovery_case - recovery_case ?authorization_code - authorization_code)
    :precondition
      (and
        (case_confirmed ?recovery_case)
        (authorization_code_available ?authorization_code)
      )
    :effect
      (and
        (case_assigned_authorization_code ?recovery_case ?authorization_code)
        (not
          (authorization_code_available ?authorization_code)
        )
      )
  )
  (:action release_authorization_code_from_recovery_case
    :parameters (?recovery_case - recovery_case ?authorization_code - authorization_code)
    :precondition
      (and
        (case_assigned_authorization_code ?recovery_case ?authorization_code)
      )
    :effect
      (and
        (authorization_code_available ?authorization_code)
        (not
          (case_assigned_authorization_code ?recovery_case ?authorization_code)
        )
      )
  )
  (:action flag_contingency_route_for_stop
    :parameters (?origin_stop - origin_stop ?contingency_route - contingency_route ?time_window - time_window)
    :precondition
      (and
        (case_confirmed ?origin_stop)
        (case_scheduled_in_time_window ?origin_stop ?time_window)
        (stop_contingency_route ?origin_stop ?contingency_route)
        (not
          (contingency_route_ready ?contingency_route)
        )
        (not
          (contingency_route_staged ?contingency_route)
        )
      )
    :effect (contingency_route_ready ?contingency_route)
  )
  (:action mark_origin_stop_ready
    :parameters (?origin_stop - origin_stop ?contingency_route - contingency_route ?local_operator - local_operator)
    :precondition
      (and
        (case_confirmed ?origin_stop)
        (case_assigned_operator ?origin_stop ?local_operator)
        (stop_contingency_route ?origin_stop ?contingency_route)
        (contingency_route_ready ?contingency_route)
        (not
          (stop_prepared_for_shipment ?origin_stop)
        )
      )
    :effect
      (and
        (stop_prepared_for_shipment ?origin_stop)
        (origin_stop_ready ?origin_stop)
      )
  )
  (:action stage_contingency_route_and_assign_consignment
    :parameters (?origin_stop - origin_stop ?contingency_route - contingency_route ?consignment - consignment)
    :precondition
      (and
        (case_confirmed ?origin_stop)
        (stop_contingency_route ?origin_stop ?contingency_route)
        (consignment_available ?consignment)
        (not
          (stop_prepared_for_shipment ?origin_stop)
        )
      )
    :effect
      (and
        (contingency_route_staged ?contingency_route)
        (stop_prepared_for_shipment ?origin_stop)
        (origin_stop_assigned_consignment ?origin_stop ?consignment)
        (not
          (consignment_available ?consignment)
        )
      )
  )
  (:action confirm_contingency_route_for_stop
    :parameters (?origin_stop - origin_stop ?contingency_route - contingency_route ?time_window - time_window ?consignment - consignment)
    :precondition
      (and
        (case_confirmed ?origin_stop)
        (case_scheduled_in_time_window ?origin_stop ?time_window)
        (stop_contingency_route ?origin_stop ?contingency_route)
        (contingency_route_staged ?contingency_route)
        (origin_stop_assigned_consignment ?origin_stop ?consignment)
        (not
          (origin_stop_ready ?origin_stop)
        )
      )
    :effect
      (and
        (contingency_route_ready ?contingency_route)
        (origin_stop_ready ?origin_stop)
        (consignment_available ?consignment)
        (not
          (origin_stop_assigned_consignment ?origin_stop ?consignment)
        )
      )
  )
  (:action flag_alternate_route_for_stop
    :parameters (?alternate_stop - alternate_stop ?alternate_route - alternate_route ?time_window - time_window)
    :precondition
      (and
        (case_confirmed ?alternate_stop)
        (case_scheduled_in_time_window ?alternate_stop ?time_window)
        (alternate_stop_candidate_route ?alternate_stop ?alternate_route)
        (not
          (alternate_route_ready ?alternate_route)
        )
        (not
          (alternate_route_staged ?alternate_route)
        )
      )
    :effect (alternate_route_ready ?alternate_route)
  )
  (:action mark_alternate_stop_ready
    :parameters (?alternate_stop - alternate_stop ?alternate_route - alternate_route ?local_operator - local_operator)
    :precondition
      (and
        (case_confirmed ?alternate_stop)
        (case_assigned_operator ?alternate_stop ?local_operator)
        (alternate_stop_candidate_route ?alternate_stop ?alternate_route)
        (alternate_route_ready ?alternate_route)
        (not
          (alternate_stop_prepared_for_shipment ?alternate_stop)
        )
      )
    :effect
      (and
        (alternate_stop_prepared_for_shipment ?alternate_stop)
        (alternate_stop_ready ?alternate_stop)
      )
  )
  (:action stage_alternate_route_and_assign_consignment
    :parameters (?alternate_stop - alternate_stop ?alternate_route - alternate_route ?consignment - consignment)
    :precondition
      (and
        (case_confirmed ?alternate_stop)
        (alternate_stop_candidate_route ?alternate_stop ?alternate_route)
        (consignment_available ?consignment)
        (not
          (alternate_stop_prepared_for_shipment ?alternate_stop)
        )
      )
    :effect
      (and
        (alternate_route_staged ?alternate_route)
        (alternate_stop_prepared_for_shipment ?alternate_stop)
        (alternate_stop_assigned_consignment ?alternate_stop ?consignment)
        (not
          (consignment_available ?consignment)
        )
      )
  )
  (:action confirm_alternate_route_for_stop
    :parameters (?alternate_stop - alternate_stop ?alternate_route - alternate_route ?time_window - time_window ?consignment - consignment)
    :precondition
      (and
        (case_confirmed ?alternate_stop)
        (case_scheduled_in_time_window ?alternate_stop ?time_window)
        (alternate_stop_candidate_route ?alternate_stop ?alternate_route)
        (alternate_route_staged ?alternate_route)
        (alternate_stop_assigned_consignment ?alternate_stop ?consignment)
        (not
          (alternate_stop_ready ?alternate_stop)
        )
      )
    :effect
      (and
        (alternate_route_ready ?alternate_route)
        (alternate_stop_ready ?alternate_stop)
        (consignment_available ?consignment)
        (not
          (alternate_stop_assigned_consignment ?alternate_stop ?consignment)
        )
      )
  )
  (:action assemble_recovery_shipment_standard
    :parameters (?origin_stop - origin_stop ?alternate_stop - alternate_stop ?contingency_route - contingency_route ?alternate_route - alternate_route ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (stop_prepared_for_shipment ?origin_stop)
        (alternate_stop_prepared_for_shipment ?alternate_stop)
        (stop_contingency_route ?origin_stop ?contingency_route)
        (alternate_stop_candidate_route ?alternate_stop ?alternate_route)
        (contingency_route_ready ?contingency_route)
        (alternate_route_ready ?alternate_route)
        (origin_stop_ready ?origin_stop)
        (alternate_stop_ready ?alternate_stop)
        (recovery_shipment_available ?recovery_shipment)
      )
    :effect
      (and
        (recovery_shipment_allocated ?recovery_shipment)
        (shipment_uses_contingency_route ?recovery_shipment ?contingency_route)
        (shipment_uses_alternate_route ?recovery_shipment ?alternate_route)
        (not
          (recovery_shipment_available ?recovery_shipment)
        )
      )
  )
  (:action assemble_recovery_shipment_with_contingency
    :parameters (?origin_stop - origin_stop ?alternate_stop - alternate_stop ?contingency_route - contingency_route ?alternate_route - alternate_route ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (stop_prepared_for_shipment ?origin_stop)
        (alternate_stop_prepared_for_shipment ?alternate_stop)
        (stop_contingency_route ?origin_stop ?contingency_route)
        (alternate_stop_candidate_route ?alternate_stop ?alternate_route)
        (contingency_route_staged ?contingency_route)
        (alternate_route_ready ?alternate_route)
        (not
          (origin_stop_ready ?origin_stop)
        )
        (alternate_stop_ready ?alternate_stop)
        (recovery_shipment_available ?recovery_shipment)
      )
    :effect
      (and
        (recovery_shipment_allocated ?recovery_shipment)
        (shipment_uses_contingency_route ?recovery_shipment ?contingency_route)
        (shipment_uses_alternate_route ?recovery_shipment ?alternate_route)
        (shipment_contingency_flag ?recovery_shipment)
        (not
          (recovery_shipment_available ?recovery_shipment)
        )
      )
  )
  (:action assemble_recovery_shipment_with_alternate
    :parameters (?origin_stop - origin_stop ?alternate_stop - alternate_stop ?contingency_route - contingency_route ?alternate_route - alternate_route ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (stop_prepared_for_shipment ?origin_stop)
        (alternate_stop_prepared_for_shipment ?alternate_stop)
        (stop_contingency_route ?origin_stop ?contingency_route)
        (alternate_stop_candidate_route ?alternate_stop ?alternate_route)
        (contingency_route_ready ?contingency_route)
        (alternate_route_staged ?alternate_route)
        (origin_stop_ready ?origin_stop)
        (not
          (alternate_stop_ready ?alternate_stop)
        )
        (recovery_shipment_available ?recovery_shipment)
      )
    :effect
      (and
        (recovery_shipment_allocated ?recovery_shipment)
        (shipment_uses_contingency_route ?recovery_shipment ?contingency_route)
        (shipment_uses_alternate_route ?recovery_shipment ?alternate_route)
        (shipment_alternate_flag ?recovery_shipment)
        (not
          (recovery_shipment_available ?recovery_shipment)
        )
      )
  )
  (:action assemble_recovery_shipment_with_both_routes
    :parameters (?origin_stop - origin_stop ?alternate_stop - alternate_stop ?contingency_route - contingency_route ?alternate_route - alternate_route ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (stop_prepared_for_shipment ?origin_stop)
        (alternate_stop_prepared_for_shipment ?alternate_stop)
        (stop_contingency_route ?origin_stop ?contingency_route)
        (alternate_stop_candidate_route ?alternate_stop ?alternate_route)
        (contingency_route_staged ?contingency_route)
        (alternate_route_staged ?alternate_route)
        (not
          (origin_stop_ready ?origin_stop)
        )
        (not
          (alternate_stop_ready ?alternate_stop)
        )
        (recovery_shipment_available ?recovery_shipment)
      )
    :effect
      (and
        (recovery_shipment_allocated ?recovery_shipment)
        (shipment_uses_contingency_route ?recovery_shipment ?contingency_route)
        (shipment_uses_alternate_route ?recovery_shipment ?alternate_route)
        (shipment_contingency_flag ?recovery_shipment)
        (shipment_alternate_flag ?recovery_shipment)
        (not
          (recovery_shipment_available ?recovery_shipment)
        )
      )
  )
  (:action manifest_recovery_shipment
    :parameters (?recovery_shipment - recovery_shipment ?origin_stop - origin_stop ?time_window - time_window)
    :precondition
      (and
        (recovery_shipment_allocated ?recovery_shipment)
        (stop_prepared_for_shipment ?origin_stop)
        (case_scheduled_in_time_window ?origin_stop ?time_window)
        (not
          (shipment_manifested ?recovery_shipment)
        )
      )
    :effect (shipment_manifested ?recovery_shipment)
  )
  (:action allocate_equipment_to_shipment
    :parameters (?recovery_case - recovery_case ?equipment_set - equipment_set ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (case_confirmed ?recovery_case)
        (recovery_case_includes_shipment ?recovery_case ?recovery_shipment)
        (recovery_case_requires_equipment ?recovery_case ?equipment_set)
        (equipment_available ?equipment_set)
        (recovery_shipment_allocated ?recovery_shipment)
        (shipment_manifested ?recovery_shipment)
        (not
          (equipment_reserved ?equipment_set)
        )
      )
    :effect
      (and
        (equipment_reserved ?equipment_set)
        (equipment_allocated_to_shipment ?equipment_set ?recovery_shipment)
        (not
          (equipment_available ?equipment_set)
        )
      )
  )
  (:action stage_carrier_option_availability
    :parameters (?recovery_case - recovery_case ?equipment_set - equipment_set ?recovery_shipment - recovery_shipment ?time_window - time_window)
    :precondition
      (and
        (case_confirmed ?recovery_case)
        (recovery_case_requires_equipment ?recovery_case ?equipment_set)
        (equipment_reserved ?equipment_set)
        (equipment_allocated_to_shipment ?equipment_set ?recovery_shipment)
        (case_scheduled_in_time_window ?recovery_case ?time_window)
        (not
          (shipment_contingency_flag ?recovery_shipment)
        )
        (not
          (carrier_option_applicable ?recovery_case)
        )
      )
    :effect (carrier_option_applicable ?recovery_case)
  )
  (:action assign_facility_to_recovery_case
    :parameters (?recovery_case - recovery_case ?facility - facility)
    :precondition
      (and
        (case_confirmed ?recovery_case)
        (facility_available ?facility)
        (not
          (facility_assigned ?recovery_case)
        )
      )
    :effect
      (and
        (facility_assigned ?recovery_case)
        (case_assigned_facility ?recovery_case ?facility)
        (not
          (facility_available ?facility)
        )
      )
  )
  (:action confirm_facility_and_stage_carrier
    :parameters (?recovery_case - recovery_case ?equipment_set - equipment_set ?recovery_shipment - recovery_shipment ?time_window - time_window ?facility - facility)
    :precondition
      (and
        (case_confirmed ?recovery_case)
        (recovery_case_requires_equipment ?recovery_case ?equipment_set)
        (equipment_reserved ?equipment_set)
        (equipment_allocated_to_shipment ?equipment_set ?recovery_shipment)
        (case_scheduled_in_time_window ?recovery_case ?time_window)
        (shipment_contingency_flag ?recovery_shipment)
        (facility_assigned ?recovery_case)
        (case_assigned_facility ?recovery_case ?facility)
        (not
          (carrier_option_applicable ?recovery_case)
        )
      )
    :effect
      (and
        (carrier_option_applicable ?recovery_case)
        (facility_confirmed ?recovery_case)
      )
  )
  (:action commit_carrier_option_primary
    :parameters (?recovery_case - recovery_case ?carrier_option - carrier_option ?local_operator - local_operator ?equipment_set - equipment_set ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (carrier_option_applicable ?recovery_case)
        (case_assigned_carrier_option ?recovery_case ?carrier_option)
        (case_assigned_operator ?recovery_case ?local_operator)
        (recovery_case_requires_equipment ?recovery_case ?equipment_set)
        (equipment_allocated_to_shipment ?equipment_set ?recovery_shipment)
        (not
          (shipment_alternate_flag ?recovery_shipment)
        )
        (not
          (carrier_option_committed ?recovery_case)
        )
      )
    :effect (carrier_option_committed ?recovery_case)
  )
  (:action commit_carrier_option_secondary
    :parameters (?recovery_case - recovery_case ?carrier_option - carrier_option ?local_operator - local_operator ?equipment_set - equipment_set ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (carrier_option_applicable ?recovery_case)
        (case_assigned_carrier_option ?recovery_case ?carrier_option)
        (case_assigned_operator ?recovery_case ?local_operator)
        (recovery_case_requires_equipment ?recovery_case ?equipment_set)
        (equipment_allocated_to_shipment ?equipment_set ?recovery_shipment)
        (shipment_alternate_flag ?recovery_shipment)
        (not
          (carrier_option_committed ?recovery_case)
        )
      )
    :effect (carrier_option_committed ?recovery_case)
  )
  (:action authorize_recovery_case_no_shipment_flags
    :parameters (?recovery_case - recovery_case ?authorization_code - authorization_code ?equipment_set - equipment_set ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (carrier_option_committed ?recovery_case)
        (case_assigned_authorization_code ?recovery_case ?authorization_code)
        (recovery_case_requires_equipment ?recovery_case ?equipment_set)
        (equipment_allocated_to_shipment ?equipment_set ?recovery_shipment)
        (not
          (shipment_contingency_flag ?recovery_shipment)
        )
        (not
          (shipment_alternate_flag ?recovery_shipment)
        )
        (not
          (case_authorized ?recovery_case)
        )
      )
    :effect (case_authorized ?recovery_case)
  )
  (:action authorize_recovery_case_with_contingency_shipment
    :parameters (?recovery_case - recovery_case ?authorization_code - authorization_code ?equipment_set - equipment_set ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (carrier_option_committed ?recovery_case)
        (case_assigned_authorization_code ?recovery_case ?authorization_code)
        (recovery_case_requires_equipment ?recovery_case ?equipment_set)
        (equipment_allocated_to_shipment ?equipment_set ?recovery_shipment)
        (shipment_contingency_flag ?recovery_shipment)
        (not
          (shipment_alternate_flag ?recovery_shipment)
        )
        (not
          (case_authorized ?recovery_case)
        )
      )
    :effect
      (and
        (case_authorized ?recovery_case)
        (approval_attached ?recovery_case)
      )
  )
  (:action authorize_recovery_case_with_alternate_shipment
    :parameters (?recovery_case - recovery_case ?authorization_code - authorization_code ?equipment_set - equipment_set ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (carrier_option_committed ?recovery_case)
        (case_assigned_authorization_code ?recovery_case ?authorization_code)
        (recovery_case_requires_equipment ?recovery_case ?equipment_set)
        (equipment_allocated_to_shipment ?equipment_set ?recovery_shipment)
        (not
          (shipment_contingency_flag ?recovery_shipment)
        )
        (shipment_alternate_flag ?recovery_shipment)
        (not
          (case_authorized ?recovery_case)
        )
      )
    :effect
      (and
        (case_authorized ?recovery_case)
        (approval_attached ?recovery_case)
      )
  )
  (:action authorize_recovery_case_with_both_shipments
    :parameters (?recovery_case - recovery_case ?authorization_code - authorization_code ?equipment_set - equipment_set ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (carrier_option_committed ?recovery_case)
        (case_assigned_authorization_code ?recovery_case ?authorization_code)
        (recovery_case_requires_equipment ?recovery_case ?equipment_set)
        (equipment_allocated_to_shipment ?equipment_set ?recovery_shipment)
        (shipment_contingency_flag ?recovery_shipment)
        (shipment_alternate_flag ?recovery_shipment)
        (not
          (case_authorized ?recovery_case)
        )
      )
    :effect
      (and
        (case_authorized ?recovery_case)
        (approval_attached ?recovery_case)
      )
  )
  (:action activate_recovery_case
    :parameters (?recovery_case - recovery_case)
    :precondition
      (and
        (case_authorized ?recovery_case)
        (not
          (approval_attached ?recovery_case)
        )
        (not
          (activation_recorded ?recovery_case)
        )
      )
    :effect
      (and
        (activation_recorded ?recovery_case)
        (restoration_verified ?recovery_case)
      )
  )
  (:action attach_authorization_token_to_case
    :parameters (?recovery_case - recovery_case ?authorization_token - authorization_token)
    :precondition
      (and
        (case_authorized ?recovery_case)
        (approval_attached ?recovery_case)
        (authorization_token_available ?authorization_token)
      )
    :effect
      (and
        (case_assigned_authorization_token ?recovery_case ?authorization_token)
        (not
          (authorization_token_available ?authorization_token)
        )
      )
  )
  (:action finalize_manifest_and_activate_case
    :parameters (?recovery_case - recovery_case ?origin_stop - origin_stop ?alternate_stop - alternate_stop ?time_window - time_window ?authorization_token - authorization_token)
    :precondition
      (and
        (case_authorized ?recovery_case)
        (approval_attached ?recovery_case)
        (case_assigned_authorization_token ?recovery_case ?authorization_token)
        (recovery_case_origin_stop ?recovery_case ?origin_stop)
        (recovery_case_alternate_stop ?recovery_case ?alternate_stop)
        (origin_stop_ready ?origin_stop)
        (alternate_stop_ready ?alternate_stop)
        (case_scheduled_in_time_window ?recovery_case ?time_window)
        (not
          (manifest_completed ?recovery_case)
        )
      )
    :effect (manifest_completed ?recovery_case)
  )
  (:action record_activation_after_manifest
    :parameters (?recovery_case - recovery_case)
    :precondition
      (and
        (case_authorized ?recovery_case)
        (manifest_completed ?recovery_case)
        (not
          (activation_recorded ?recovery_case)
        )
      )
    :effect
      (and
        (activation_recorded ?recovery_case)
        (restoration_verified ?recovery_case)
      )
  )
  (:action trigger_escalation_contact_for_case
    :parameters (?recovery_case - recovery_case ?escalation_contact - escalation_contact ?time_window - time_window)
    :precondition
      (and
        (case_confirmed ?recovery_case)
        (case_scheduled_in_time_window ?recovery_case ?time_window)
        (escalation_contact_available ?escalation_contact)
        (case_has_escalation_contact ?recovery_case ?escalation_contact)
        (not
          (escalation_triggered ?recovery_case)
        )
      )
    :effect
      (and
        (escalation_triggered ?recovery_case)
        (not
          (escalation_contact_available ?escalation_contact)
        )
      )
  )
  (:action engage_escalation_contact
    :parameters (?recovery_case - recovery_case ?local_operator - local_operator)
    :precondition
      (and
        (escalation_triggered ?recovery_case)
        (case_assigned_operator ?recovery_case ?local_operator)
        (not
          (escalation_engaged ?recovery_case)
        )
      )
    :effect (escalation_engaged ?recovery_case)
  )
  (:action record_escalation_action
    :parameters (?recovery_case - recovery_case ?authorization_code - authorization_code)
    :precondition
      (and
        (escalation_engaged ?recovery_case)
        (case_assigned_authorization_code ?recovery_case ?authorization_code)
        (not
          (escalation_action_completed ?recovery_case)
        )
      )
    :effect (escalation_action_completed ?recovery_case)
  )
  (:action finalize_escalation_and_activate_case
    :parameters (?recovery_case - recovery_case)
    :precondition
      (and
        (escalation_action_completed ?recovery_case)
        (not
          (activation_recorded ?recovery_case)
        )
      )
    :effect
      (and
        (activation_recorded ?recovery_case)
        (restoration_verified ?recovery_case)
      )
  )
  (:action confirm_origin_stop_restoration
    :parameters (?origin_stop - origin_stop ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (stop_prepared_for_shipment ?origin_stop)
        (origin_stop_ready ?origin_stop)
        (recovery_shipment_allocated ?recovery_shipment)
        (shipment_manifested ?recovery_shipment)
        (not
          (restoration_verified ?origin_stop)
        )
      )
    :effect (restoration_verified ?origin_stop)
  )
  (:action confirm_alternate_stop_restoration
    :parameters (?alternate_stop - alternate_stop ?recovery_shipment - recovery_shipment)
    :precondition
      (and
        (alternate_stop_prepared_for_shipment ?alternate_stop)
        (alternate_stop_ready ?alternate_stop)
        (recovery_shipment_allocated ?recovery_shipment)
        (shipment_manifested ?recovery_shipment)
        (not
          (restoration_verified ?alternate_stop)
        )
      )
    :effect (restoration_verified ?alternate_stop)
  )
  (:action finalize_case_and_attach_evidence
    :parameters (?pickup_case - pickup_case ?evidence_document - evidence_document ?time_window - time_window)
    :precondition
      (and
        (restoration_verified ?pickup_case)
        (case_scheduled_in_time_window ?pickup_case ?time_window)
        (evidence_document_available ?evidence_document)
        (not
          (restoration_finalized ?pickup_case)
        )
      )
    :effect
      (and
        (restoration_finalized ?pickup_case)
        (case_linked_evidence ?pickup_case ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action propagate_restoration_and_release_vehicle
    :parameters (?origin_stop - origin_stop ?vehicle - vehicle ?evidence_document - evidence_document)
    :precondition
      (and
        (restoration_finalized ?origin_stop)
        (case_assigned_vehicle ?origin_stop ?vehicle)
        (case_linked_evidence ?origin_stop ?evidence_document)
        (not
          (case_restored ?origin_stop)
        )
      )
    :effect
      (and
        (case_restored ?origin_stop)
        (vehicle_available ?vehicle)
        (evidence_document_available ?evidence_document)
      )
  )
  (:action propagate_restoration_and_release_vehicle_alternate
    :parameters (?alternate_stop - alternate_stop ?vehicle - vehicle ?evidence_document - evidence_document)
    :precondition
      (and
        (restoration_finalized ?alternate_stop)
        (case_assigned_vehicle ?alternate_stop ?vehicle)
        (case_linked_evidence ?alternate_stop ?evidence_document)
        (not
          (case_restored ?alternate_stop)
        )
      )
    :effect
      (and
        (case_restored ?alternate_stop)
        (vehicle_available ?vehicle)
        (evidence_document_available ?evidence_document)
      )
  )
  (:action propagate_restoration_and_release_case_resources
    :parameters (?recovery_case - recovery_case ?vehicle - vehicle ?evidence_document - evidence_document)
    :precondition
      (and
        (restoration_finalized ?recovery_case)
        (case_assigned_vehicle ?recovery_case ?vehicle)
        (case_linked_evidence ?recovery_case ?evidence_document)
        (not
          (case_restored ?recovery_case)
        )
      )
    :effect
      (and
        (case_restored ?recovery_case)
        (vehicle_available ?vehicle)
        (evidence_document_available ?evidence_document)
      )
  )
)

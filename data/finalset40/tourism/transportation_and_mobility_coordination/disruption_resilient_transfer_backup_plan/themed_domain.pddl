(define (domain disruption_resilient_transfer_backup_plan_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types transfer_entity - object transfer_component_type - transfer_entity document_type - transfer_entity resource_type - transfer_entity transfer_container - transfer_entity transfer_request - transfer_container service_option - transfer_component_type schedule_slot - transfer_component_type assistance_resource - transfer_component_type seat_class - transfer_component_type priority_token - transfer_component_type contingency_equipment - transfer_component_type vehicle_assignment_token - transfer_component_type travel_document - transfer_component_type contingency_asset - document_type boarding_pass - document_type voucher_code - document_type arrival_point - resource_type departure_point - resource_type vehicle_unit - resource_type leg_container - transfer_request leg_group - transfer_request inbound_leg - leg_container outbound_leg - leg_container traveler - leg_group)

  (:predicates
    (transfer_entity_registered ?transfer_request - transfer_request)
    (transfer_entity_booking_confirmed ?transfer_request - transfer_request)
    (service_option_selected_for_transfer_entity ?transfer_request - transfer_request)
    (transfer_entity_continuity_restored ?transfer_request - transfer_request)
    (continuity_ready ?transfer_request - transfer_request)
    (transfer_entity_contingency_plan_bound ?transfer_request - transfer_request)
    (service_option_available ?service_option - service_option)
    (service_option_allocated_to_transfer_entity ?transfer_request - transfer_request ?service_option - service_option)
    (schedule_slot_available ?schedule_slot - schedule_slot)
    (schedule_slot_allocated ?transfer_request - transfer_request ?schedule_slot - schedule_slot)
    (assistance_resource_available ?assistance_resource - assistance_resource)
    (assistance_resource_allocated ?transfer_request - transfer_request ?assistance_resource - assistance_resource)
    (contingency_asset_available ?contingency_asset - contingency_asset)
    (inbound_contingency_allocated ?inbound_leg - inbound_leg ?contingency_asset - contingency_asset)
    (outbound_contingency_allocated ?outbound_leg - outbound_leg ?contingency_asset - contingency_asset)
    (inbound_leg_arrival_linked ?inbound_leg - inbound_leg ?arrival_point - arrival_point)
    (arrival_point_ready ?arrival_point - arrival_point)
    (arrival_backup_ready ?arrival_point - arrival_point)
    (inbound_handover_complete ?inbound_leg - inbound_leg)
    (outbound_leg_departure_linked ?outbound_leg - outbound_leg ?departure_point - departure_point)
    (departure_point_ready ?departure_point - departure_point)
    (departure_backup_ready ?departure_point - departure_point)
    (outbound_handover_complete ?outbound_leg - outbound_leg)
    (vehicle_available ?vehicle_unit - vehicle_unit)
    (vehicle_allocated ?vehicle_unit - vehicle_unit)
    (vehicle_arrival_linked ?vehicle_unit - vehicle_unit ?arrival_point - arrival_point)
    (vehicle_departure_linked ?vehicle_unit - vehicle_unit ?departure_point - departure_point)
    (vehicle_inbound_buffered ?vehicle_unit - vehicle_unit)
    (vehicle_outbound_buffered ?vehicle_unit - vehicle_unit)
    (vehicle_arrival_confirmed ?vehicle_unit - vehicle_unit)
    (traveler_inbound_leg_link ?traveler - traveler ?inbound_leg - inbound_leg)
    (traveler_outbound_leg_link ?traveler - traveler ?outbound_leg - outbound_leg)
    (traveler_vehicle_link ?traveler - traveler ?vehicle_unit - vehicle_unit)
    (boarding_pass_available ?boarding_pass - boarding_pass)
    (traveler_boarding_pass_link ?traveler - traveler ?boarding_pass - boarding_pass)
    (boarding_pass_issued ?boarding_pass - boarding_pass)
    (boarding_pass_vehicle_link ?boarding_pass - boarding_pass ?vehicle_unit - vehicle_unit)
    (traveler_boarding_cleared ?traveler - traveler)
    (traveler_checked_in ?traveler - traveler)
    (traveler_transfer_authorized ?traveler - traveler)
    (traveler_seat_class_reserved ?traveler - traveler)
    (seat_class_confirmed ?traveler - traveler)
    (contingency_route_active ?traveler - traveler)
    (continuity_reconciled ?traveler - traveler)
    (voucher_code_available ?voucher_code - voucher_code)
    (traveler_voucher_code_link ?traveler - traveler ?voucher_code - voucher_code)
    (voucher_code_applied ?traveler - traveler)
    (voucher_code_redeemed ?traveler - traveler)
    (traveler_document_verified ?traveler - traveler)
    (seat_class_available ?seat_class - seat_class)
    (traveler_seat_class_link ?traveler - traveler ?seat_class - seat_class)
    (priority_token_available ?priority_token - priority_token)
    (traveler_priority_token_link ?traveler - traveler ?priority_token - priority_token)
    (vehicle_assignment_token_available ?vehicle_assignment_token - vehicle_assignment_token)
    (traveler_vehicle_assignment_token_link ?traveler - traveler ?vehicle_assignment_token - vehicle_assignment_token)
    (travel_document_available ?travel_document - travel_document)
    (traveler_travel_document_link ?traveler - traveler ?travel_document - travel_document)
    (contingency_equipment_available ?contingency_equipment - contingency_equipment)
    (transfer_entity_contingency_equipment_link ?transfer_request - transfer_request ?contingency_equipment - contingency_equipment)
    (inbound_leg_ready ?inbound_leg - inbound_leg)
    (outbound_leg_ready ?outbound_leg - outbound_leg)
    (traveler_transfer_completed ?traveler - traveler)
  )
  (:action register_transfer_request
    :parameters (?transfer_request - transfer_request)
    :precondition
      (and
        (not
          (transfer_entity_registered ?transfer_request)
        )
        (not
          (transfer_entity_continuity_restored ?transfer_request)
        )
      )
    :effect (transfer_entity_registered ?transfer_request)
  )
  (:action select_service_option
    :parameters (?transfer_request - transfer_request ?service_option - service_option)
    :precondition
      (and
        (transfer_entity_registered ?transfer_request)
        (not
          (service_option_selected_for_transfer_entity ?transfer_request)
        )
        (service_option_available ?service_option)
      )
    :effect
      (and
        (service_option_selected_for_transfer_entity ?transfer_request)
        (service_option_allocated_to_transfer_entity ?transfer_request ?service_option)
        (not
          (service_option_available ?service_option)
        )
      )
  )
  (:action reserve_schedule_slot
    :parameters (?transfer_request - transfer_request ?schedule_slot - schedule_slot)
    :precondition
      (and
        (transfer_entity_registered ?transfer_request)
        (service_option_selected_for_transfer_entity ?transfer_request)
        (schedule_slot_available ?schedule_slot)
      )
    :effect
      (and
        (schedule_slot_allocated ?transfer_request ?schedule_slot)
        (not
          (schedule_slot_available ?schedule_slot)
        )
      )
  )
  (:action confirm_schedule_slot
    :parameters (?transfer_request - transfer_request ?schedule_slot - schedule_slot)
    :precondition
      (and
        (transfer_entity_registered ?transfer_request)
        (service_option_selected_for_transfer_entity ?transfer_request)
        (schedule_slot_allocated ?transfer_request ?schedule_slot)
        (not
          (transfer_entity_booking_confirmed ?transfer_request)
        )
      )
    :effect (transfer_entity_booking_confirmed ?transfer_request)
  )
  (:action release_schedule_slot
    :parameters (?transfer_request - transfer_request ?schedule_slot - schedule_slot)
    :precondition
      (and
        (schedule_slot_allocated ?transfer_request ?schedule_slot)
      )
    :effect
      (and
        (schedule_slot_available ?schedule_slot)
        (not
          (schedule_slot_allocated ?transfer_request ?schedule_slot)
        )
      )
  )
  (:action assign_assistance_resource
    :parameters (?transfer_request - transfer_request ?assistance_resource - assistance_resource)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?transfer_request)
        (assistance_resource_available ?assistance_resource)
      )
    :effect
      (and
        (assistance_resource_allocated ?transfer_request ?assistance_resource)
        (not
          (assistance_resource_available ?assistance_resource)
        )
      )
  )
  (:action release_assistance_resource
    :parameters (?transfer_request - transfer_request ?assistance_resource - assistance_resource)
    :precondition
      (and
        (assistance_resource_allocated ?transfer_request ?assistance_resource)
      )
    :effect
      (and
        (assistance_resource_available ?assistance_resource)
        (not
          (assistance_resource_allocated ?transfer_request ?assistance_resource)
        )
      )
  )
  (:action assign_vehicle_assignment_token
    :parameters (?traveler - traveler ?vehicle_assignment_token - vehicle_assignment_token)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?traveler)
        (vehicle_assignment_token_available ?vehicle_assignment_token)
      )
    :effect
      (and
        (traveler_vehicle_assignment_token_link ?traveler ?vehicle_assignment_token)
        (not
          (vehicle_assignment_token_available ?vehicle_assignment_token)
        )
      )
  )
  (:action release_vehicle_assignment_token
    :parameters (?traveler - traveler ?vehicle_assignment_token - vehicle_assignment_token)
    :precondition
      (and
        (traveler_vehicle_assignment_token_link ?traveler ?vehicle_assignment_token)
      )
    :effect
      (and
        (vehicle_assignment_token_available ?vehicle_assignment_token)
        (not
          (traveler_vehicle_assignment_token_link ?traveler ?vehicle_assignment_token)
        )
      )
  )
  (:action issue_travel_document
    :parameters (?traveler - traveler ?travel_document - travel_document)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?traveler)
        (travel_document_available ?travel_document)
      )
    :effect
      (and
        (traveler_travel_document_link ?traveler ?travel_document)
        (not
          (travel_document_available ?travel_document)
        )
      )
  )
  (:action revoke_travel_document
    :parameters (?traveler - traveler ?travel_document - travel_document)
    :precondition
      (and
        (traveler_travel_document_link ?traveler ?travel_document)
      )
    :effect
      (and
        (travel_document_available ?travel_document)
        (not
          (traveler_travel_document_link ?traveler ?travel_document)
        )
      )
  )
  (:action mark_arrival_point_ready
    :parameters (?inbound_leg - inbound_leg ?arrival_point - arrival_point ?schedule_slot - schedule_slot)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?inbound_leg)
        (schedule_slot_allocated ?inbound_leg ?schedule_slot)
        (inbound_leg_arrival_linked ?inbound_leg ?arrival_point)
        (not
          (arrival_point_ready ?arrival_point)
        )
        (not
          (arrival_backup_ready ?arrival_point)
        )
      )
    :effect (arrival_point_ready ?arrival_point)
  )
  (:action secure_inbound_arrival
    :parameters (?inbound_leg - inbound_leg ?arrival_point - arrival_point ?assistance_resource - assistance_resource)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?inbound_leg)
        (assistance_resource_allocated ?inbound_leg ?assistance_resource)
        (inbound_leg_arrival_linked ?inbound_leg ?arrival_point)
        (arrival_point_ready ?arrival_point)
        (not
          (inbound_leg_ready ?inbound_leg)
        )
      )
    :effect
      (and
        (inbound_leg_ready ?inbound_leg)
        (inbound_handover_complete ?inbound_leg)
      )
  )
  (:action stage_inbound_contingency
    :parameters (?inbound_leg - inbound_leg ?arrival_point - arrival_point ?contingency_asset - contingency_asset)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?inbound_leg)
        (inbound_leg_arrival_linked ?inbound_leg ?arrival_point)
        (contingency_asset_available ?contingency_asset)
        (not
          (inbound_leg_ready ?inbound_leg)
        )
      )
    :effect
      (and
        (arrival_backup_ready ?arrival_point)
        (inbound_leg_ready ?inbound_leg)
        (inbound_contingency_allocated ?inbound_leg ?contingency_asset)
        (not
          (contingency_asset_available ?contingency_asset)
        )
      )
  )
  (:action recover_inbound_with_contingency
    :parameters (?inbound_leg - inbound_leg ?arrival_point - arrival_point ?schedule_slot - schedule_slot ?contingency_asset - contingency_asset)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?inbound_leg)
        (schedule_slot_allocated ?inbound_leg ?schedule_slot)
        (inbound_leg_arrival_linked ?inbound_leg ?arrival_point)
        (arrival_backup_ready ?arrival_point)
        (inbound_contingency_allocated ?inbound_leg ?contingency_asset)
        (not
          (inbound_handover_complete ?inbound_leg)
        )
      )
    :effect
      (and
        (arrival_point_ready ?arrival_point)
        (inbound_handover_complete ?inbound_leg)
        (contingency_asset_available ?contingency_asset)
        (not
          (inbound_contingency_allocated ?inbound_leg ?contingency_asset)
        )
      )
  )
  (:action mark_departure_point_ready
    :parameters (?outbound_leg - outbound_leg ?departure_point - departure_point ?schedule_slot - schedule_slot)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?outbound_leg)
        (schedule_slot_allocated ?outbound_leg ?schedule_slot)
        (outbound_leg_departure_linked ?outbound_leg ?departure_point)
        (not
          (departure_point_ready ?departure_point)
        )
        (not
          (departure_backup_ready ?departure_point)
        )
      )
    :effect (departure_point_ready ?departure_point)
  )
  (:action secure_outbound_departure
    :parameters (?outbound_leg - outbound_leg ?departure_point - departure_point ?assistance_resource - assistance_resource)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?outbound_leg)
        (assistance_resource_allocated ?outbound_leg ?assistance_resource)
        (outbound_leg_departure_linked ?outbound_leg ?departure_point)
        (departure_point_ready ?departure_point)
        (not
          (outbound_leg_ready ?outbound_leg)
        )
      )
    :effect
      (and
        (outbound_leg_ready ?outbound_leg)
        (outbound_handover_complete ?outbound_leg)
      )
  )
  (:action stage_outbound_contingency
    :parameters (?outbound_leg - outbound_leg ?departure_point - departure_point ?contingency_asset - contingency_asset)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?outbound_leg)
        (outbound_leg_departure_linked ?outbound_leg ?departure_point)
        (contingency_asset_available ?contingency_asset)
        (not
          (outbound_leg_ready ?outbound_leg)
        )
      )
    :effect
      (and
        (departure_backup_ready ?departure_point)
        (outbound_leg_ready ?outbound_leg)
        (outbound_contingency_allocated ?outbound_leg ?contingency_asset)
        (not
          (contingency_asset_available ?contingency_asset)
        )
      )
  )
  (:action recover_outbound_with_contingency
    :parameters (?outbound_leg - outbound_leg ?departure_point - departure_point ?schedule_slot - schedule_slot ?contingency_asset - contingency_asset)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?outbound_leg)
        (schedule_slot_allocated ?outbound_leg ?schedule_slot)
        (outbound_leg_departure_linked ?outbound_leg ?departure_point)
        (departure_backup_ready ?departure_point)
        (outbound_contingency_allocated ?outbound_leg ?contingency_asset)
        (not
          (outbound_handover_complete ?outbound_leg)
        )
      )
    :effect
      (and
        (departure_point_ready ?departure_point)
        (outbound_handover_complete ?outbound_leg)
        (contingency_asset_available ?contingency_asset)
        (not
          (outbound_contingency_allocated ?outbound_leg ?contingency_asset)
        )
      )
  )
  (:action allocate_vehicle_to_transfer
    :parameters (?inbound_leg - inbound_leg ?outbound_leg - outbound_leg ?arrival_point - arrival_point ?departure_point - departure_point ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (inbound_leg_ready ?inbound_leg)
        (outbound_leg_ready ?outbound_leg)
        (inbound_leg_arrival_linked ?inbound_leg ?arrival_point)
        (outbound_leg_departure_linked ?outbound_leg ?departure_point)
        (arrival_point_ready ?arrival_point)
        (departure_point_ready ?departure_point)
        (inbound_handover_complete ?inbound_leg)
        (outbound_handover_complete ?outbound_leg)
        (vehicle_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_allocated ?vehicle_unit)
        (vehicle_arrival_linked ?vehicle_unit ?arrival_point)
        (vehicle_departure_linked ?vehicle_unit ?departure_point)
        (not
          (vehicle_available ?vehicle_unit)
        )
      )
  )
  (:action allocate_vehicle_with_arrival_contingency
    :parameters (?inbound_leg - inbound_leg ?outbound_leg - outbound_leg ?arrival_point - arrival_point ?departure_point - departure_point ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (inbound_leg_ready ?inbound_leg)
        (outbound_leg_ready ?outbound_leg)
        (inbound_leg_arrival_linked ?inbound_leg ?arrival_point)
        (outbound_leg_departure_linked ?outbound_leg ?departure_point)
        (arrival_backup_ready ?arrival_point)
        (departure_point_ready ?departure_point)
        (not
          (inbound_handover_complete ?inbound_leg)
        )
        (outbound_handover_complete ?outbound_leg)
        (vehicle_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_allocated ?vehicle_unit)
        (vehicle_arrival_linked ?vehicle_unit ?arrival_point)
        (vehicle_departure_linked ?vehicle_unit ?departure_point)
        (vehicle_inbound_buffered ?vehicle_unit)
        (not
          (vehicle_available ?vehicle_unit)
        )
      )
  )
  (:action allocate_vehicle_with_departure_contingency
    :parameters (?inbound_leg - inbound_leg ?outbound_leg - outbound_leg ?arrival_point - arrival_point ?departure_point - departure_point ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (inbound_leg_ready ?inbound_leg)
        (outbound_leg_ready ?outbound_leg)
        (inbound_leg_arrival_linked ?inbound_leg ?arrival_point)
        (outbound_leg_departure_linked ?outbound_leg ?departure_point)
        (arrival_point_ready ?arrival_point)
        (departure_backup_ready ?departure_point)
        (inbound_handover_complete ?inbound_leg)
        (not
          (outbound_handover_complete ?outbound_leg)
        )
        (vehicle_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_allocated ?vehicle_unit)
        (vehicle_arrival_linked ?vehicle_unit ?arrival_point)
        (vehicle_departure_linked ?vehicle_unit ?departure_point)
        (vehicle_outbound_buffered ?vehicle_unit)
        (not
          (vehicle_available ?vehicle_unit)
        )
      )
  )
  (:action allocate_vehicle_with_dual_contingency
    :parameters (?inbound_leg - inbound_leg ?outbound_leg - outbound_leg ?arrival_point - arrival_point ?departure_point - departure_point ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (inbound_leg_ready ?inbound_leg)
        (outbound_leg_ready ?outbound_leg)
        (inbound_leg_arrival_linked ?inbound_leg ?arrival_point)
        (outbound_leg_departure_linked ?outbound_leg ?departure_point)
        (arrival_backup_ready ?arrival_point)
        (departure_backup_ready ?departure_point)
        (not
          (inbound_handover_complete ?inbound_leg)
        )
        (not
          (outbound_handover_complete ?outbound_leg)
        )
        (vehicle_available ?vehicle_unit)
      )
    :effect
      (and
        (vehicle_allocated ?vehicle_unit)
        (vehicle_arrival_linked ?vehicle_unit ?arrival_point)
        (vehicle_departure_linked ?vehicle_unit ?departure_point)
        (vehicle_inbound_buffered ?vehicle_unit)
        (vehicle_outbound_buffered ?vehicle_unit)
        (not
          (vehicle_available ?vehicle_unit)
        )
      )
  )
  (:action confirm_vehicle_arrival
    :parameters (?vehicle_unit - vehicle_unit ?inbound_leg - inbound_leg ?schedule_slot - schedule_slot)
    :precondition
      (and
        (vehicle_allocated ?vehicle_unit)
        (inbound_leg_ready ?inbound_leg)
        (schedule_slot_allocated ?inbound_leg ?schedule_slot)
        (not
          (vehicle_arrival_confirmed ?vehicle_unit)
        )
      )
    :effect (vehicle_arrival_confirmed ?vehicle_unit)
  )
  (:action issue_boarding_pass
    :parameters (?traveler - traveler ?boarding_pass - boarding_pass ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?traveler)
        (traveler_vehicle_link ?traveler ?vehicle_unit)
        (traveler_boarding_pass_link ?traveler ?boarding_pass)
        (boarding_pass_available ?boarding_pass)
        (vehicle_allocated ?vehicle_unit)
        (vehicle_arrival_confirmed ?vehicle_unit)
        (not
          (boarding_pass_issued ?boarding_pass)
        )
      )
    :effect
      (and
        (boarding_pass_issued ?boarding_pass)
        (boarding_pass_vehicle_link ?boarding_pass ?vehicle_unit)
        (not
          (boarding_pass_available ?boarding_pass)
        )
      )
  )
  (:action attach_boarding_pass_to_vehicle
    :parameters (?traveler - traveler ?boarding_pass - boarding_pass ?vehicle_unit - vehicle_unit ?schedule_slot - schedule_slot)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?traveler)
        (traveler_boarding_pass_link ?traveler ?boarding_pass)
        (boarding_pass_issued ?boarding_pass)
        (boarding_pass_vehicle_link ?boarding_pass ?vehicle_unit)
        (schedule_slot_allocated ?traveler ?schedule_slot)
        (not
          (vehicle_inbound_buffered ?vehicle_unit)
        )
        (not
          (traveler_boarding_cleared ?traveler)
        )
      )
    :effect (traveler_boarding_cleared ?traveler)
  )
  (:action assign_seat_class
    :parameters (?traveler - traveler ?seat_class - seat_class)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?traveler)
        (seat_class_available ?seat_class)
        (not
          (traveler_seat_class_reserved ?traveler)
        )
      )
    :effect
      (and
        (traveler_seat_class_reserved ?traveler)
        (traveler_seat_class_link ?traveler ?seat_class)
        (not
          (seat_class_available ?seat_class)
        )
      )
  )
  (:action confirm_seat_class
    :parameters (?traveler - traveler ?boarding_pass - boarding_pass ?vehicle_unit - vehicle_unit ?schedule_slot - schedule_slot ?seat_class - seat_class)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?traveler)
        (traveler_boarding_pass_link ?traveler ?boarding_pass)
        (boarding_pass_issued ?boarding_pass)
        (boarding_pass_vehicle_link ?boarding_pass ?vehicle_unit)
        (schedule_slot_allocated ?traveler ?schedule_slot)
        (vehicle_inbound_buffered ?vehicle_unit)
        (traveler_seat_class_reserved ?traveler)
        (traveler_seat_class_link ?traveler ?seat_class)
        (not
          (traveler_boarding_cleared ?traveler)
        )
      )
    :effect
      (and
        (traveler_boarding_cleared ?traveler)
        (seat_class_confirmed ?traveler)
      )
  )
  (:action process_traveler_check_in_standard
    :parameters (?traveler - traveler ?vehicle_assignment_token - vehicle_assignment_token ?assistance_resource - assistance_resource ?boarding_pass - boarding_pass ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (traveler_boarding_cleared ?traveler)
        (traveler_vehicle_assignment_token_link ?traveler ?vehicle_assignment_token)
        (assistance_resource_allocated ?traveler ?assistance_resource)
        (traveler_boarding_pass_link ?traveler ?boarding_pass)
        (boarding_pass_vehicle_link ?boarding_pass ?vehicle_unit)
        (not
          (vehicle_outbound_buffered ?vehicle_unit)
        )
        (not
          (traveler_checked_in ?traveler)
        )
      )
    :effect (traveler_checked_in ?traveler)
  )
  (:action process_traveler_check_in_buffered
    :parameters (?traveler - traveler ?vehicle_assignment_token - vehicle_assignment_token ?assistance_resource - assistance_resource ?boarding_pass - boarding_pass ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (traveler_boarding_cleared ?traveler)
        (traveler_vehicle_assignment_token_link ?traveler ?vehicle_assignment_token)
        (assistance_resource_allocated ?traveler ?assistance_resource)
        (traveler_boarding_pass_link ?traveler ?boarding_pass)
        (boarding_pass_vehicle_link ?boarding_pass ?vehicle_unit)
        (vehicle_outbound_buffered ?vehicle_unit)
        (not
          (traveler_checked_in ?traveler)
        )
      )
    :effect (traveler_checked_in ?traveler)
  )
  (:action authorize_traveler_transfer_standard
    :parameters (?traveler - traveler ?travel_document - travel_document ?boarding_pass - boarding_pass ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (traveler_checked_in ?traveler)
        (traveler_travel_document_link ?traveler ?travel_document)
        (traveler_boarding_pass_link ?traveler ?boarding_pass)
        (boarding_pass_vehicle_link ?boarding_pass ?vehicle_unit)
        (not
          (vehicle_inbound_buffered ?vehicle_unit)
        )
        (not
          (vehicle_outbound_buffered ?vehicle_unit)
        )
        (not
          (traveler_transfer_authorized ?traveler)
        )
      )
    :effect (traveler_transfer_authorized ?traveler)
  )
  (:action authorize_traveler_transfer_arrival_buffered
    :parameters (?traveler - traveler ?travel_document - travel_document ?boarding_pass - boarding_pass ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (traveler_checked_in ?traveler)
        (traveler_travel_document_link ?traveler ?travel_document)
        (traveler_boarding_pass_link ?traveler ?boarding_pass)
        (boarding_pass_vehicle_link ?boarding_pass ?vehicle_unit)
        (vehicle_inbound_buffered ?vehicle_unit)
        (not
          (vehicle_outbound_buffered ?vehicle_unit)
        )
        (not
          (traveler_transfer_authorized ?traveler)
        )
      )
    :effect
      (and
        (traveler_transfer_authorized ?traveler)
        (contingency_route_active ?traveler)
      )
  )
  (:action authorize_traveler_transfer_departure_buffered
    :parameters (?traveler - traveler ?travel_document - travel_document ?boarding_pass - boarding_pass ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (traveler_checked_in ?traveler)
        (traveler_travel_document_link ?traveler ?travel_document)
        (traveler_boarding_pass_link ?traveler ?boarding_pass)
        (boarding_pass_vehicle_link ?boarding_pass ?vehicle_unit)
        (not
          (vehicle_inbound_buffered ?vehicle_unit)
        )
        (vehicle_outbound_buffered ?vehicle_unit)
        (not
          (traveler_transfer_authorized ?traveler)
        )
      )
    :effect
      (and
        (traveler_transfer_authorized ?traveler)
        (contingency_route_active ?traveler)
      )
  )
  (:action authorize_traveler_transfer_dual_buffered
    :parameters (?traveler - traveler ?travel_document - travel_document ?boarding_pass - boarding_pass ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (traveler_checked_in ?traveler)
        (traveler_travel_document_link ?traveler ?travel_document)
        (traveler_boarding_pass_link ?traveler ?boarding_pass)
        (boarding_pass_vehicle_link ?boarding_pass ?vehicle_unit)
        (vehicle_inbound_buffered ?vehicle_unit)
        (vehicle_outbound_buffered ?vehicle_unit)
        (not
          (traveler_transfer_authorized ?traveler)
        )
      )
    :effect
      (and
        (traveler_transfer_authorized ?traveler)
        (contingency_route_active ?traveler)
      )
  )
  (:action complete_traveler_transfer
    :parameters (?traveler - traveler)
    :precondition
      (and
        (traveler_transfer_authorized ?traveler)
        (not
          (contingency_route_active ?traveler)
        )
        (not
          (traveler_transfer_completed ?traveler)
        )
      )
    :effect
      (and
        (traveler_transfer_completed ?traveler)
        (continuity_ready ?traveler)
      )
  )
  (:action allocate_priority_token_to_traveler
    :parameters (?traveler - traveler ?priority_token - priority_token)
    :precondition
      (and
        (traveler_transfer_authorized ?traveler)
        (contingency_route_active ?traveler)
        (priority_token_available ?priority_token)
      )
    :effect
      (and
        (traveler_priority_token_link ?traveler ?priority_token)
        (not
          (priority_token_available ?priority_token)
        )
      )
  )
  (:action reconcile_traveler_handover_with_priority_token
    :parameters (?traveler - traveler ?inbound_leg - inbound_leg ?outbound_leg - outbound_leg ?schedule_slot - schedule_slot ?priority_token - priority_token)
    :precondition
      (and
        (traveler_transfer_authorized ?traveler)
        (contingency_route_active ?traveler)
        (traveler_priority_token_link ?traveler ?priority_token)
        (traveler_inbound_leg_link ?traveler ?inbound_leg)
        (traveler_outbound_leg_link ?traveler ?outbound_leg)
        (inbound_handover_complete ?inbound_leg)
        (outbound_handover_complete ?outbound_leg)
        (schedule_slot_allocated ?traveler ?schedule_slot)
        (not
          (continuity_reconciled ?traveler)
        )
      )
    :effect (continuity_reconciled ?traveler)
  )
  (:action complete_recovered_traveler_transfer
    :parameters (?traveler - traveler)
    :precondition
      (and
        (traveler_transfer_authorized ?traveler)
        (continuity_reconciled ?traveler)
        (not
          (traveler_transfer_completed ?traveler)
        )
      )
    :effect
      (and
        (traveler_transfer_completed ?traveler)
        (continuity_ready ?traveler)
      )
  )
  (:action validate_voucher
    :parameters (?traveler - traveler ?voucher_code - voucher_code ?schedule_slot - schedule_slot)
    :precondition
      (and
        (transfer_entity_booking_confirmed ?traveler)
        (schedule_slot_allocated ?traveler ?schedule_slot)
        (voucher_code_available ?voucher_code)
        (traveler_voucher_code_link ?traveler ?voucher_code)
        (not
          (voucher_code_applied ?traveler)
        )
      )
    :effect
      (and
        (voucher_code_applied ?traveler)
        (not
          (voucher_code_available ?voucher_code)
        )
      )
  )
  (:action redeem_voucher
    :parameters (?traveler - traveler ?assistance_resource - assistance_resource)
    :precondition
      (and
        (voucher_code_applied ?traveler)
        (assistance_resource_allocated ?traveler ?assistance_resource)
        (not
          (voucher_code_redeemed ?traveler)
        )
      )
    :effect (voucher_code_redeemed ?traveler)
  )
  (:action verify_travel_document
    :parameters (?traveler - traveler ?travel_document - travel_document)
    :precondition
      (and
        (voucher_code_redeemed ?traveler)
        (traveler_travel_document_link ?traveler ?travel_document)
        (not
          (traveler_document_verified ?traveler)
        )
      )
    :effect (traveler_document_verified ?traveler)
  )
  (:action finalize_traveler_continuity
    :parameters (?traveler - traveler)
    :precondition
      (and
        (traveler_document_verified ?traveler)
        (not
          (traveler_transfer_completed ?traveler)
        )
      )
    :effect
      (and
        (traveler_transfer_completed ?traveler)
        (continuity_ready ?traveler)
      )
  )
  (:action complete_inbound_leg_handover
    :parameters (?inbound_leg - inbound_leg ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (inbound_leg_ready ?inbound_leg)
        (inbound_handover_complete ?inbound_leg)
        (vehicle_allocated ?vehicle_unit)
        (vehicle_arrival_confirmed ?vehicle_unit)
        (not
          (continuity_ready ?inbound_leg)
        )
      )
    :effect (continuity_ready ?inbound_leg)
  )
  (:action complete_outbound_leg_handover
    :parameters (?outbound_leg - outbound_leg ?vehicle_unit - vehicle_unit)
    :precondition
      (and
        (outbound_leg_ready ?outbound_leg)
        (outbound_handover_complete ?outbound_leg)
        (vehicle_allocated ?vehicle_unit)
        (vehicle_arrival_confirmed ?vehicle_unit)
        (not
          (continuity_ready ?outbound_leg)
        )
      )
    :effect (continuity_ready ?outbound_leg)
  )
  (:action bind_contingency_equipment_to_transfer
    :parameters (?transfer_request - transfer_request ?contingency_equipment - contingency_equipment ?schedule_slot - schedule_slot)
    :precondition
      (and
        (continuity_ready ?transfer_request)
        (schedule_slot_allocated ?transfer_request ?schedule_slot)
        (contingency_equipment_available ?contingency_equipment)
        (not
          (transfer_entity_contingency_plan_bound ?transfer_request)
        )
      )
    :effect
      (and
        (transfer_entity_contingency_plan_bound ?transfer_request)
        (transfer_entity_contingency_equipment_link ?transfer_request ?contingency_equipment)
        (not
          (contingency_equipment_available ?contingency_equipment)
        )
      )
  )
  (:action deploy_backup_service_to_inbound_leg
    :parameters (?inbound_leg - inbound_leg ?service_option - service_option ?contingency_equipment - contingency_equipment)
    :precondition
      (and
        (transfer_entity_contingency_plan_bound ?inbound_leg)
        (service_option_allocated_to_transfer_entity ?inbound_leg ?service_option)
        (transfer_entity_contingency_equipment_link ?inbound_leg ?contingency_equipment)
        (not
          (transfer_entity_continuity_restored ?inbound_leg)
        )
      )
    :effect
      (and
        (transfer_entity_continuity_restored ?inbound_leg)
        (service_option_available ?service_option)
        (contingency_equipment_available ?contingency_equipment)
      )
  )
  (:action deploy_backup_service_to_outbound_leg
    :parameters (?outbound_leg - outbound_leg ?service_option - service_option ?contingency_equipment - contingency_equipment)
    :precondition
      (and
        (transfer_entity_contingency_plan_bound ?outbound_leg)
        (service_option_allocated_to_transfer_entity ?outbound_leg ?service_option)
        (transfer_entity_contingency_equipment_link ?outbound_leg ?contingency_equipment)
        (not
          (transfer_entity_continuity_restored ?outbound_leg)
        )
      )
    :effect
      (and
        (transfer_entity_continuity_restored ?outbound_leg)
        (service_option_available ?service_option)
        (contingency_equipment_available ?contingency_equipment)
      )
  )
  (:action deploy_backup_service_to_traveler
    :parameters (?traveler - traveler ?service_option - service_option ?contingency_equipment - contingency_equipment)
    :precondition
      (and
        (transfer_entity_contingency_plan_bound ?traveler)
        (service_option_allocated_to_transfer_entity ?traveler ?service_option)
        (transfer_entity_contingency_equipment_link ?traveler ?contingency_equipment)
        (not
          (transfer_entity_continuity_restored ?traveler)
        )
      )
    :effect
      (and
        (transfer_entity_continuity_restored ?traveler)
        (service_option_available ?service_option)
        (contingency_equipment_available ?contingency_equipment)
      )
  )
)

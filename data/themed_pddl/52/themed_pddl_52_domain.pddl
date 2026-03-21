(define (domain telehealth_to_inperson_escalation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types escalation_case - entity telehealth_appointment_slot - entity inperson_appointment_slot - entity clinical_unit_location - entity provider - entity clinical_equipment - entity telehealth_resource_endpoint - entity patient_contact_resource - entity clinical_specialty - entity scheduling_staff - entity diagnostic_service_slot - entity specialist_service - entity team - entity coordination_team - team escalation_team - team telehealth_case_subtype - escalation_case inperson_case_subtype - escalation_case)
  (:predicates
    (contact_resource_available ?patient_contact_resource - patient_contact_resource)
    (case_reserved_location ?escalation_case - escalation_case ?clinical_unit_location - clinical_unit_location)
    (previsit_ready ?escalation_case - escalation_case)
    (case_assigned_telehealth_slot ?escalation_case - escalation_case ?telehealth_appointment_slot - telehealth_appointment_slot)
    (eligible_team_for_case ?escalation_case - escalation_case ?team - team)
    (equipment_available ?clinical_equipment - clinical_equipment)
    (location_available ?clinical_unit_location - clinical_unit_location)
    (eligible_specialist_service_for_case ?escalation_case - escalation_case ?specialist_service - specialist_service)
    (case_closed ?escalation_case - escalation_case)
    (case_is_telehealth_subtype ?escalation_case - escalation_case)
    (eligible_telehealth_slot_for_case ?escalation_case - escalation_case ?telehealth_appointment_slot - telehealth_appointment_slot)
    (inperson_slot_available ?inperson_appointment_slot - inperson_appointment_slot)
    (diagnostic_slot_available ?diagnostic_service_slot - diagnostic_service_slot)
    (telehealth_endpoint_available ?telehealth_resource_endpoint - telehealth_resource_endpoint)
    (inperson_booking_confirmed ?escalation_case - escalation_case)
    (eligible_location_for_case ?escalation_case - escalation_case ?clinical_unit_location - clinical_unit_location)
    (case_reserved_specialist_service ?escalation_case - escalation_case ?specialist_service - specialist_service)
    (case_has_inperson_slot ?escalation_case - escalation_case ?inperson_appointment_slot - inperson_appointment_slot)
    (previsit_coordinated ?escalation_case - escalation_case)
    (eligible_equipment_for_case ?escalation_case - escalation_case ?clinical_equipment - clinical_equipment)
    (specialist_service_available ?specialist_service - specialist_service)
    (case_is_inperson_subtype ?escalation_case - escalation_case)
    (inperson_reservation_pending ?escalation_case - escalation_case)
    (eligible_provider_for_case ?escalation_case - escalation_case ?provider - provider)
    (case_reserved_provider ?escalation_case - escalation_case ?provider - provider)
    (additional_coordination_required ?escalation_case - escalation_case)
    (case_bound_telehealth_endpoint ?escalation_case - escalation_case ?telehealth_resource_endpoint - telehealth_resource_endpoint)
    (telehealth_session_completed ?escalation_case - escalation_case)
    (eligible_diagnostic_slot_for_case ?escalation_case - escalation_case ?diagnostic_service_slot - diagnostic_service_slot)
    (case_open ?escalation_case - escalation_case)
    (telehealth_slot_available ?telehealth_appointment_slot - telehealth_appointment_slot)
    (telehealth_slot_allocated ?escalation_case - escalation_case)
    (scheduling_staff_available ?scheduling_staff - scheduling_staff)
    (specialty_available ?clinical_specialty - clinical_specialty)
    (case_reserved_equipment ?escalation_case - escalation_case ?clinical_equipment - clinical_equipment)
    (case_reserved_specialty ?escalation_case - escalation_case ?clinical_specialty - clinical_specialty)
    (escalation_required ?escalation_case - escalation_case)
    (patient_contact_confirmed ?escalation_case - escalation_case)
    (eligible_specialty_for_case ?escalation_case - escalation_case ?clinical_specialty - clinical_specialty)
    (provider_available ?provider - provider)
    (preferred_specialty_for_subtype ?escalation_case - escalation_case ?clinical_specialty - clinical_specialty)
    (eligible_inperson_slot_for_case ?escalation_case - escalation_case ?inperson_appointment_slot - inperson_appointment_slot)
    (previsit_pending ?escalation_case - escalation_case)
    (specialty_authorized_for_case ?escalation_case - escalation_case ?clinical_specialty - clinical_specialty)
  )
  (:action release_specialist_service_for_case
    :parameters (?escalation_case - escalation_case ?specialist_service - specialist_service)
    :precondition
      (and
        (case_reserved_specialist_service ?escalation_case ?specialist_service)
      )
    :effect
      (and
        (specialist_service_available ?specialist_service)
        (not
          (case_reserved_specialist_service ?escalation_case ?specialist_service)
        )
      )
  )
  (:action assign_escalation_team_and_finalize_previsit
    :parameters (?escalation_case - escalation_case ?clinical_equipment - clinical_equipment ?specialist_service - specialist_service ?escalation_team - escalation_team)
    :precondition
      (and
        (not
          (previsit_coordinated ?escalation_case)
        )
        (inperson_booking_confirmed ?escalation_case)
        (inperson_reservation_pending ?escalation_case)
        (case_reserved_specialist_service ?escalation_case ?specialist_service)
        (eligible_team_for_case ?escalation_case ?escalation_team)
        (case_reserved_equipment ?escalation_case ?clinical_equipment)
      )
    :effect
      (and
        (previsit_pending ?escalation_case)
        (previsit_coordinated ?escalation_case)
      )
  )
  (:action finalize_and_close_case_minimal
    :parameters (?escalation_case - escalation_case)
    :precondition
      (and
        (inperson_reservation_pending ?escalation_case)
        (telehealth_slot_allocated ?escalation_case)
        (inperson_booking_confirmed ?escalation_case)
        (case_open ?escalation_case)
        (patient_contact_confirmed ?escalation_case)
        (not
          (case_closed ?escalation_case)
        )
        (case_is_telehealth_subtype ?escalation_case)
        (previsit_coordinated ?escalation_case)
      )
    :effect
      (and
        (case_closed ?escalation_case)
      )
  )
  (:action clear_additional_coordination_flag
    :parameters (?escalation_case - escalation_case ?provider - provider ?clinical_unit_location - clinical_unit_location)
    :precondition
      (and
        (inperson_booking_confirmed ?escalation_case)
        (additional_coordination_required ?escalation_case)
        (case_reserved_provider ?escalation_case ?provider)
        (case_reserved_location ?escalation_case ?clinical_unit_location)
      )
    :effect
      (and
        (not
          (additional_coordination_required ?escalation_case)
        )
        (not
          (previsit_pending ?escalation_case)
        )
      )
  )
  (:action bind_telehealth_endpoint
    :parameters (?escalation_case - escalation_case ?telehealth_resource_endpoint - telehealth_resource_endpoint)
    :precondition
      (and
        (telehealth_endpoint_available ?telehealth_resource_endpoint)
        (case_open ?escalation_case)
      )
    :effect
      (and
        (not
          (telehealth_endpoint_available ?telehealth_resource_endpoint)
        )
        (case_bound_telehealth_endpoint ?escalation_case ?telehealth_resource_endpoint)
      )
  )
  (:action assign_coordination_team
    :parameters (?escalation_case - escalation_case ?provider - provider ?clinical_unit_location - clinical_unit_location ?coordination_team - coordination_team)
    :precondition
      (and
        (eligible_team_for_case ?escalation_case ?coordination_team)
        (inperson_reservation_pending ?escalation_case)
        (not
          (previsit_pending ?escalation_case)
        )
        (case_reserved_provider ?escalation_case ?provider)
        (inperson_booking_confirmed ?escalation_case)
        (case_reserved_location ?escalation_case ?clinical_unit_location)
        (not
          (previsit_coordinated ?escalation_case)
        )
      )
    :effect
      (and
        (previsit_coordinated ?escalation_case)
      )
  )
  (:action confirm_inperson_reservation_by_specialty
    :parameters (?escalation_case - escalation_case ?clinical_specialty - clinical_specialty)
    :precondition
      (and
        (telehealth_slot_allocated ?escalation_case)
        (specialty_authorized_for_case ?escalation_case ?clinical_specialty)
        (not
          (inperson_reservation_pending ?escalation_case)
        )
      )
    :effect
      (and
        (inperson_reservation_pending ?escalation_case)
        (not
          (previsit_pending ?escalation_case)
        )
      )
  )
  (:action reserve_equipment_for_case
    :parameters (?escalation_case - escalation_case ?clinical_equipment - clinical_equipment)
    :precondition
      (and
        (eligible_equipment_for_case ?escalation_case ?clinical_equipment)
        (case_open ?escalation_case)
        (equipment_available ?clinical_equipment)
      )
    :effect
      (and
        (case_reserved_equipment ?escalation_case ?clinical_equipment)
        (not
          (equipment_available ?clinical_equipment)
        )
      )
  )
  (:action reserve_provider_for_case
    :parameters (?escalation_case - escalation_case ?provider - provider)
    :precondition
      (and
        (case_open ?escalation_case)
        (provider_available ?provider)
        (eligible_provider_for_case ?escalation_case ?provider)
      )
    :effect
      (and
        (not
          (provider_available ?provider)
        )
        (case_reserved_provider ?escalation_case ?provider)
      )
  )
  (:action release_equipment_for_case
    :parameters (?escalation_case - escalation_case ?clinical_equipment - clinical_equipment)
    :precondition
      (and
        (case_reserved_equipment ?escalation_case ?clinical_equipment)
      )
    :effect
      (and
        (equipment_available ?clinical_equipment)
        (not
          (case_reserved_equipment ?escalation_case ?clinical_equipment)
        )
      )
  )
  (:action release_location_for_case
    :parameters (?escalation_case - escalation_case ?clinical_unit_location - clinical_unit_location)
    :precondition
      (and
        (case_reserved_location ?escalation_case ?clinical_unit_location)
      )
    :effect
      (and
        (location_available ?clinical_unit_location)
        (not
          (case_reserved_location ?escalation_case ?clinical_unit_location)
        )
      )
  )
  (:action reserve_clinical_specialty_for_case
    :parameters (?escalation_case - escalation_case ?clinical_specialty - clinical_specialty)
    :precondition
      (and
        (patient_contact_confirmed ?escalation_case)
        (specialty_available ?clinical_specialty)
        (eligible_specialty_for_case ?escalation_case ?clinical_specialty)
      )
    :effect
      (and
        (case_reserved_specialty ?escalation_case ?clinical_specialty)
        (not
          (specialty_available ?clinical_specialty)
        )
      )
  )
  (:action reserve_location_for_case
    :parameters (?escalation_case - escalation_case ?clinical_unit_location - clinical_unit_location)
    :precondition
      (and
        (case_open ?escalation_case)
        (location_available ?clinical_unit_location)
        (eligible_location_for_case ?escalation_case ?clinical_unit_location)
      )
    :effect
      (and
        (case_reserved_location ?escalation_case ?clinical_unit_location)
        (not
          (location_available ?clinical_unit_location)
        )
      )
  )
  (:action create_inperson_appointment
    :parameters (?escalation_case - escalation_case ?inperson_appointment_slot - inperson_appointment_slot ?provider - provider ?clinical_unit_location - clinical_unit_location)
    :precondition
      (and
        (telehealth_slot_allocated ?escalation_case)
        (inperson_slot_available ?inperson_appointment_slot)
        (eligible_inperson_slot_for_case ?escalation_case ?inperson_appointment_slot)
        (not
          (inperson_booking_confirmed ?escalation_case)
        )
        (case_reserved_location ?escalation_case ?clinical_unit_location)
        (case_reserved_provider ?escalation_case ?provider)
      )
    :effect
      (and
        (case_has_inperson_slot ?escalation_case ?inperson_appointment_slot)
        (not
          (inperson_slot_available ?inperson_appointment_slot)
        )
        (inperson_booking_confirmed ?escalation_case)
      )
  )
  (:action complete_previsit_and_mark_ready
    :parameters (?escalation_case - escalation_case ?provider - provider ?clinical_unit_location - clinical_unit_location)
    :precondition
      (and
        (case_reserved_provider ?escalation_case ?provider)
        (previsit_coordinated ?escalation_case)
        (case_reserved_location ?escalation_case ?clinical_unit_location)
        (previsit_pending ?escalation_case)
      )
    :effect
      (and
        (not
          (additional_coordination_required ?escalation_case)
        )
        (not
          (previsit_pending ?escalation_case)
        )
        (not
          (inperson_reservation_pending ?escalation_case)
        )
        (previsit_ready ?escalation_case)
      )
  )
  (:action unbind_telehealth_endpoint
    :parameters (?escalation_case - escalation_case ?telehealth_resource_endpoint - telehealth_resource_endpoint)
    :precondition
      (and
        (case_bound_telehealth_endpoint ?escalation_case ?telehealth_resource_endpoint)
      )
    :effect
      (and
        (telehealth_endpoint_available ?telehealth_resource_endpoint)
        (not
          (case_bound_telehealth_endpoint ?escalation_case ?telehealth_resource_endpoint)
        )
      )
  )
  (:action confirm_inperson_reservation_with_staff
    :parameters (?escalation_case - escalation_case ?telehealth_resource_endpoint - telehealth_resource_endpoint ?scheduling_staff - scheduling_staff)
    :precondition
      (and
        (not
          (inperson_reservation_pending ?escalation_case)
        )
        (telehealth_slot_allocated ?escalation_case)
        (scheduling_staff_available ?scheduling_staff)
        (case_bound_telehealth_endpoint ?escalation_case ?telehealth_resource_endpoint)
        (escalation_required ?escalation_case)
      )
    :effect
      (and
        (not
          (previsit_pending ?escalation_case)
        )
        (inperson_reservation_pending ?escalation_case)
      )
  )
  (:action finalize_and_close_case_with_session
    :parameters (?escalation_case - escalation_case)
    :precondition
      (and
        (case_open ?escalation_case)
        (case_is_inperson_subtype ?escalation_case)
        (telehealth_session_completed ?escalation_case)
        (telehealth_slot_allocated ?escalation_case)
        (inperson_reservation_pending ?escalation_case)
        (not
          (case_closed ?escalation_case)
        )
        (patient_contact_confirmed ?escalation_case)
        (inperson_booking_confirmed ?escalation_case)
        (previsit_coordinated ?escalation_case)
      )
    :effect
      (and
        (case_closed ?escalation_case)
      )
  )
  (:action mark_telehealth_session_completed
    :parameters (?escalation_case - escalation_case ?telehealth_resource_endpoint - telehealth_resource_endpoint ?scheduling_staff - scheduling_staff)
    :precondition
      (and
        (inperson_reservation_pending ?escalation_case)
        (scheduling_staff_available ?scheduling_staff)
        (not
          (telehealth_session_completed ?escalation_case)
        )
        (patient_contact_confirmed ?escalation_case)
        (case_open ?escalation_case)
        (case_is_inperson_subtype ?escalation_case)
        (case_bound_telehealth_endpoint ?escalation_case ?telehealth_resource_endpoint)
      )
    :effect
      (and
        (telehealth_session_completed ?escalation_case)
      )
  )
  (:action release_provider_for_case
    :parameters (?escalation_case - escalation_case ?provider - provider)
    :precondition
      (and
        (case_reserved_provider ?escalation_case ?provider)
      )
    :effect
      (and
        (provider_available ?provider)
        (not
          (case_reserved_provider ?escalation_case ?provider)
        )
      )
  )
  (:action reserve_specialist_service_for_case
    :parameters (?escalation_case - escalation_case ?specialist_service - specialist_service)
    :precondition
      (and
        (specialist_service_available ?specialist_service)
        (case_open ?escalation_case)
        (eligible_specialist_service_for_case ?escalation_case ?specialist_service)
      )
    :effect
      (and
        (case_reserved_specialist_service ?escalation_case ?specialist_service)
        (not
          (specialist_service_available ?specialist_service)
        )
      )
  )
  (:action open_escalation_case
    :parameters (?escalation_case - escalation_case)
    :precondition
      (and
        (not
          (case_open ?escalation_case)
        )
        (not
          (case_closed ?escalation_case)
        )
      )
    :effect
      (and
        (case_open ?escalation_case)
      )
  )
  (:action triage_notify_contact_and_flag_escalation
    :parameters (?escalation_case - escalation_case ?patient_contact_resource - patient_contact_resource)
    :precondition
      (and
        (not
          (escalation_required ?escalation_case)
        )
        (case_open ?escalation_case)
        (contact_resource_available ?patient_contact_resource)
        (telehealth_slot_allocated ?escalation_case)
      )
    :effect
      (and
        (previsit_pending ?escalation_case)
        (not
          (contact_resource_available ?patient_contact_resource)
        )
        (escalation_required ?escalation_case)
      )
  )
  (:action create_inperson_appointment_with_equipment_and_diagnostics
    :parameters (?escalation_case - escalation_case ?inperson_appointment_slot - inperson_appointment_slot ?clinical_equipment - clinical_equipment ?diagnostic_service_slot - diagnostic_service_slot)
    :precondition
      (and
        (diagnostic_slot_available ?diagnostic_service_slot)
        (eligible_diagnostic_slot_for_case ?escalation_case ?diagnostic_service_slot)
        (not
          (inperson_booking_confirmed ?escalation_case)
        )
        (telehealth_slot_allocated ?escalation_case)
        (inperson_slot_available ?inperson_appointment_slot)
        (eligible_inperson_slot_for_case ?escalation_case ?inperson_appointment_slot)
        (case_reserved_equipment ?escalation_case ?clinical_equipment)
      )
    :effect
      (and
        (case_has_inperson_slot ?escalation_case ?inperson_appointment_slot)
        (not
          (diagnostic_slot_available ?diagnostic_service_slot)
        )
        (additional_coordination_required ?escalation_case)
        (not
          (inperson_slot_available ?inperson_appointment_slot)
        )
        (previsit_pending ?escalation_case)
        (inperson_booking_confirmed ?escalation_case)
      )
  )
  (:action confirm_patient_contact_via_channel
    :parameters (?escalation_case - escalation_case ?patient_contact_resource - patient_contact_resource)
    :precondition
      (and
        (contact_resource_available ?patient_contact_resource)
        (not
          (previsit_pending ?escalation_case)
        )
        (inperson_reservation_pending ?escalation_case)
        (previsit_coordinated ?escalation_case)
        (not
          (patient_contact_confirmed ?escalation_case)
        )
      )
    :effect
      (and
        (patient_contact_confirmed ?escalation_case)
        (not
          (contact_resource_available ?patient_contact_resource)
        )
      )
  )
  (:action release_telehealth_slot
    :parameters (?escalation_case - escalation_case ?telehealth_appointment_slot - telehealth_appointment_slot)
    :precondition
      (and
        (case_assigned_telehealth_slot ?escalation_case ?telehealth_appointment_slot)
        (not
          (previsit_coordinated ?escalation_case)
        )
        (not
          (inperson_booking_confirmed ?escalation_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned_telehealth_slot ?escalation_case ?telehealth_appointment_slot)
        )
        (telehealth_slot_available ?telehealth_appointment_slot)
        (not
          (telehealth_slot_allocated ?escalation_case)
        )
        (not
          (escalation_required ?escalation_case)
        )
        (not
          (previsit_ready ?escalation_case)
        )
        (not
          (inperson_reservation_pending ?escalation_case)
        )
        (not
          (additional_coordination_required ?escalation_case)
        )
        (not
          (previsit_pending ?escalation_case)
        )
      )
  )
  (:action confirm_patient_contact_for_session
    :parameters (?escalation_case - escalation_case ?telehealth_resource_endpoint - telehealth_resource_endpoint)
    :precondition
      (and
        (not
          (patient_contact_confirmed ?escalation_case)
        )
        (case_bound_telehealth_endpoint ?escalation_case ?telehealth_resource_endpoint)
        (inperson_reservation_pending ?escalation_case)
        (previsit_coordinated ?escalation_case)
        (not
          (previsit_pending ?escalation_case)
        )
      )
    :effect
      (and
        (patient_contact_confirmed ?escalation_case)
      )
  )
  (:action finalize_and_close_case_with_specialty
    :parameters (?escalation_case - escalation_case ?clinical_specialty - clinical_specialty)
    :precondition
      (and
        (patient_contact_confirmed ?escalation_case)
        (previsit_coordinated ?escalation_case)
        (inperson_booking_confirmed ?escalation_case)
        (specialty_authorized_for_case ?escalation_case ?clinical_specialty)
        (inperson_reservation_pending ?escalation_case)
        (telehealth_slot_allocated ?escalation_case)
        (case_open ?escalation_case)
        (not
          (case_closed ?escalation_case)
        )
        (case_is_inperson_subtype ?escalation_case)
      )
    :effect
      (and
        (case_closed ?escalation_case)
      )
  )
  (:action triage_mark_escalation
    :parameters (?escalation_case - escalation_case ?telehealth_resource_endpoint - telehealth_resource_endpoint)
    :precondition
      (and
        (case_open ?escalation_case)
        (telehealth_slot_allocated ?escalation_case)
        (not
          (escalation_required ?escalation_case)
        )
        (case_bound_telehealth_endpoint ?escalation_case ?telehealth_resource_endpoint)
      )
    :effect
      (and
        (escalation_required ?escalation_case)
      )
  )
  (:action assign_telehealth_slot
    :parameters (?escalation_case - escalation_case ?telehealth_appointment_slot - telehealth_appointment_slot)
    :precondition
      (and
        (not
          (telehealth_slot_allocated ?escalation_case)
        )
        (case_open ?escalation_case)
        (telehealth_slot_available ?telehealth_appointment_slot)
        (eligible_telehealth_slot_for_case ?escalation_case ?telehealth_appointment_slot)
      )
    :effect
      (and
        (telehealth_slot_allocated ?escalation_case)
        (not
          (telehealth_slot_available ?telehealth_appointment_slot)
        )
        (case_assigned_telehealth_slot ?escalation_case ?telehealth_appointment_slot)
      )
  )
  (:action finalize_inperson_reservation_with_staff
    :parameters (?escalation_case - escalation_case ?telehealth_resource_endpoint - telehealth_resource_endpoint ?scheduling_staff - scheduling_staff)
    :precondition
      (and
        (telehealth_slot_allocated ?escalation_case)
        (not
          (inperson_reservation_pending ?escalation_case)
        )
        (case_bound_telehealth_endpoint ?escalation_case ?telehealth_resource_endpoint)
        (previsit_coordinated ?escalation_case)
        (scheduling_staff_available ?scheduling_staff)
        (previsit_ready ?escalation_case)
      )
    :effect
      (and
        (inperson_reservation_pending ?escalation_case)
      )
  )
  (:action authorize_specialty_assignment_by_staff
    :parameters (?inperson_case_subtype - inperson_case_subtype ?telehealth_case_subtype - telehealth_case_subtype ?clinical_specialty - clinical_specialty)
    :precondition
      (and
        (case_open ?inperson_case_subtype)
        (case_reserved_specialty ?telehealth_case_subtype ?clinical_specialty)
        (case_is_inperson_subtype ?inperson_case_subtype)
        (not
          (specialty_authorized_for_case ?inperson_case_subtype ?clinical_specialty)
        )
        (preferred_specialty_for_subtype ?inperson_case_subtype ?clinical_specialty)
      )
    :effect
      (and
        (specialty_authorized_for_case ?inperson_case_subtype ?clinical_specialty)
      )
  )
)

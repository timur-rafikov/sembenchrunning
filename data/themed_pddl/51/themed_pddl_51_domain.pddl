(define (domain specialist_referral_queue_governance)
  (:requirements :strips :typing :negative-preconditions)
  (:types referral_case - object specialist_provider - object clinical_service - object clinic_location - object diagnostic_test - object medical_equipment - object admin_coordinator - object external_partner - object appointment_timeslot - object clinician_availability - object ancillary_resource - object referral_reason - object organizational_unit - object care_pathway_unit - organizational_unit escalation_unit - organizational_unit referral_subtype_a - referral_case referral_subtype_b - referral_case)
  (:predicates
    (external_partner_available ?external_partner - external_partner)
    (location_reserved ?referral_case - referral_case ?clinic_location - clinic_location)
    (appointment_finalized ?referral_case - referral_case)
    (assigned_specialist ?referral_case - referral_case ?specialist_provider - specialist_provider)
    (case_assigned_organizational_unit ?referral_case - referral_case ?organizational_unit - organizational_unit)
    (equipment_available ?medical_equipment - medical_equipment)
    (location_available ?clinic_location - clinic_location)
    (case_has_referral_reason ?referral_case - referral_case ?referral_reason - referral_reason)
    (referral_finalized ?referral_case - referral_case)
    (intake_checks_completed ?referral_case - referral_case)
    (eligible_specialist_for_case ?referral_case - referral_case ?specialist_provider - specialist_provider)
    (service_available ?clinical_service - clinical_service)
    (ancillary_resource_available ?ancillary_resource - ancillary_resource)
    (admin_coordinator_available ?admin_coordinator - admin_coordinator)
    (appointment_confirmed ?referral_case - referral_case)
    (location_required_for_case ?referral_case - referral_case ?clinic_location - clinic_location)
    (referral_reason_allocated ?referral_case - referral_case ?referral_reason - referral_reason)
    (service_appointment_created ?referral_case - referral_case ?clinical_service - clinical_service)
    (clinical_authorization_granted ?referral_case - referral_case)
    (equipment_required_for_case ?referral_case - referral_case ?medical_equipment - medical_equipment)
    (referral_reason_available ?referral_reason - referral_reason)
    (triage_complete ?referral_case - referral_case)
    (clinical_authorization_obtained ?referral_case - referral_case)
    (test_required_for_case ?referral_case - referral_case ?diagnostic_test - diagnostic_test)
    (diagnostic_test_reserved ?referral_case - referral_case ?diagnostic_test - diagnostic_test)
    (escalation_flag ?referral_case - referral_case)
    (admin_coordinator_assigned ?referral_case - referral_case ?admin_coordinator - admin_coordinator)
    (patient_notified_of_appointment ?referral_case - referral_case)
    (ancillary_required_for_case ?referral_case - referral_case ?ancillary_resource - ancillary_resource)
    (referral_registered ?referral_case - referral_case)
    (specialist_available ?specialist_provider - specialist_provider)
    (case_specialist_assigned ?referral_case - referral_case)
    (clinician_shift_available ?clinician_availability - clinician_availability)
    (timeslot_available ?appointment_timeslot - appointment_timeslot)
    (equipment_reserved ?referral_case - referral_case ?medical_equipment - medical_equipment)
    (subtype_timeslot_compatible ?referral_case - referral_case ?appointment_timeslot - appointment_timeslot)
    (admin_coordinator_reserved_flag ?referral_case - referral_case)
    (patient_notification_sent ?referral_case - referral_case)
    (case_timeslot_preference ?referral_case - referral_case ?appointment_timeslot - appointment_timeslot)
    (diagnostic_test_available ?diagnostic_test - diagnostic_test)
    (case_timeslot_candidate ?referral_case - referral_case ?appointment_timeslot - appointment_timeslot)
    (case_service_match ?referral_case - referral_case ?clinical_service - clinical_service)
    (administrative_hold_required ?referral_case - referral_case)
    (case_timeslot_allocated ?referral_case - referral_case ?appointment_timeslot - appointment_timeslot)
  )
  (:action release_referral_reason_from_case
    :parameters (?referral_case - referral_case ?referral_reason - referral_reason)
    :precondition
      (and
        (referral_reason_allocated ?referral_case ?referral_reason)
      )
    :effect
      (and
        (referral_reason_available ?referral_reason)
        (not
          (referral_reason_allocated ?referral_case ?referral_reason)
        )
      )
  )
  (:action grant_authorization_with_escalation_route
    :parameters (?referral_case - referral_case ?medical_equipment - medical_equipment ?referral_reason - referral_reason ?escalation_channel - escalation_unit)
    :precondition
      (and
        (not
          (clinical_authorization_granted ?referral_case)
        )
        (appointment_confirmed ?referral_case)
        (clinical_authorization_obtained ?referral_case)
        (referral_reason_allocated ?referral_case ?referral_reason)
        (case_assigned_organizational_unit ?referral_case ?escalation_channel)
        (equipment_reserved ?referral_case ?medical_equipment)
      )
    :effect
      (and
        (administrative_hold_required ?referral_case)
        (clinical_authorization_granted ?referral_case)
      )
  )
  (:action finalize_referral_case_record
    :parameters (?referral_case - referral_case)
    :precondition
      (and
        (clinical_authorization_obtained ?referral_case)
        (case_specialist_assigned ?referral_case)
        (appointment_confirmed ?referral_case)
        (referral_registered ?referral_case)
        (patient_notification_sent ?referral_case)
        (not
          (referral_finalized ?referral_case)
        )
        (intake_checks_completed ?referral_case)
        (clinical_authorization_granted ?referral_case)
      )
    :effect
      (and
        (referral_finalized ?referral_case)
      )
  )
  (:action resolve_escalation_after_confirmation
    :parameters (?referral_case - referral_case ?diagnostic_test - diagnostic_test ?clinic_location - clinic_location)
    :precondition
      (and
        (appointment_confirmed ?referral_case)
        (escalation_flag ?referral_case)
        (diagnostic_test_reserved ?referral_case ?diagnostic_test)
        (location_reserved ?referral_case ?clinic_location)
      )
    :effect
      (and
        (not
          (escalation_flag ?referral_case)
        )
        (not
          (administrative_hold_required ?referral_case)
        )
      )
  )
  (:action reserve_admin_coordinator
    :parameters (?referral_case - referral_case ?admin_coordinator - admin_coordinator)
    :precondition
      (and
        (admin_coordinator_available ?admin_coordinator)
        (referral_registered ?referral_case)
      )
    :effect
      (and
        (not
          (admin_coordinator_available ?admin_coordinator)
        )
        (admin_coordinator_assigned ?referral_case ?admin_coordinator)
      )
  )
  (:action grant_clinical_authorization
    :parameters (?referral_case - referral_case ?diagnostic_test - diagnostic_test ?clinic_location - clinic_location ?care_pathway_variant - care_pathway_unit)
    :precondition
      (and
        (case_assigned_organizational_unit ?referral_case ?care_pathway_variant)
        (clinical_authorization_obtained ?referral_case)
        (not
          (administrative_hold_required ?referral_case)
        )
        (diagnostic_test_reserved ?referral_case ?diagnostic_test)
        (appointment_confirmed ?referral_case)
        (location_reserved ?referral_case ?clinic_location)
        (not
          (clinical_authorization_granted ?referral_case)
        )
      )
    :effect
      (and
        (clinical_authorization_granted ?referral_case)
      )
  )
  (:action perform_clinical_review_for_timeslot
    :parameters (?referral_case - referral_case ?appointment_timeslot - appointment_timeslot)
    :precondition
      (and
        (case_specialist_assigned ?referral_case)
        (case_timeslot_allocated ?referral_case ?appointment_timeslot)
        (not
          (clinical_authorization_obtained ?referral_case)
        )
      )
    :effect
      (and
        (clinical_authorization_obtained ?referral_case)
        (not
          (administrative_hold_required ?referral_case)
        )
      )
  )
  (:action reserve_medical_equipment
    :parameters (?referral_case - referral_case ?medical_equipment - medical_equipment)
    :precondition
      (and
        (equipment_required_for_case ?referral_case ?medical_equipment)
        (referral_registered ?referral_case)
        (equipment_available ?medical_equipment)
      )
    :effect
      (and
        (equipment_reserved ?referral_case ?medical_equipment)
        (not
          (equipment_available ?medical_equipment)
        )
      )
  )
  (:action reserve_diagnostic_test
    :parameters (?referral_case - referral_case ?diagnostic_test - diagnostic_test)
    :precondition
      (and
        (referral_registered ?referral_case)
        (diagnostic_test_available ?diagnostic_test)
        (test_required_for_case ?referral_case ?diagnostic_test)
      )
    :effect
      (and
        (not
          (diagnostic_test_available ?diagnostic_test)
        )
        (diagnostic_test_reserved ?referral_case ?diagnostic_test)
      )
  )
  (:action release_medical_equipment
    :parameters (?referral_case - referral_case ?medical_equipment - medical_equipment)
    :precondition
      (and
        (equipment_reserved ?referral_case ?medical_equipment)
      )
    :effect
      (and
        (equipment_available ?medical_equipment)
        (not
          (equipment_reserved ?referral_case ?medical_equipment)
        )
      )
  )
  (:action release_location
    :parameters (?referral_case - referral_case ?clinic_location - clinic_location)
    :precondition
      (and
        (location_reserved ?referral_case ?clinic_location)
      )
    :effect
      (and
        (location_available ?clinic_location)
        (not
          (location_reserved ?referral_case ?clinic_location)
        )
      )
  )
  (:action reserve_timeslot_for_case
    :parameters (?referral_case - referral_case ?appointment_timeslot - appointment_timeslot)
    :precondition
      (and
        (patient_notification_sent ?referral_case)
        (timeslot_available ?appointment_timeslot)
        (case_timeslot_preference ?referral_case ?appointment_timeslot)
      )
    :effect
      (and
        (subtype_timeslot_compatible ?referral_case ?appointment_timeslot)
        (not
          (timeslot_available ?appointment_timeslot)
        )
      )
  )
  (:action reserve_location
    :parameters (?referral_case - referral_case ?clinic_location - clinic_location)
    :precondition
      (and
        (referral_registered ?referral_case)
        (location_available ?clinic_location)
        (location_required_for_case ?referral_case ?clinic_location)
      )
    :effect
      (and
        (location_reserved ?referral_case ?clinic_location)
        (not
          (location_available ?clinic_location)
        )
      )
  )
  (:action create_service_appointment
    :parameters (?referral_case - referral_case ?clinical_service - clinical_service ?diagnostic_test - diagnostic_test ?clinic_location - clinic_location)
    :precondition
      (and
        (case_specialist_assigned ?referral_case)
        (service_available ?clinical_service)
        (case_service_match ?referral_case ?clinical_service)
        (not
          (appointment_confirmed ?referral_case)
        )
        (location_reserved ?referral_case ?clinic_location)
        (diagnostic_test_reserved ?referral_case ?diagnostic_test)
      )
    :effect
      (and
        (service_appointment_created ?referral_case ?clinical_service)
        (not
          (service_available ?clinical_service)
        )
        (appointment_confirmed ?referral_case)
      )
  )
  (:action finalize_appointment
    :parameters (?referral_case - referral_case ?diagnostic_test - diagnostic_test ?clinic_location - clinic_location)
    :precondition
      (and
        (diagnostic_test_reserved ?referral_case ?diagnostic_test)
        (clinical_authorization_granted ?referral_case)
        (location_reserved ?referral_case ?clinic_location)
        (administrative_hold_required ?referral_case)
      )
    :effect
      (and
        (not
          (escalation_flag ?referral_case)
        )
        (not
          (administrative_hold_required ?referral_case)
        )
        (not
          (clinical_authorization_obtained ?referral_case)
        )
        (appointment_finalized ?referral_case)
      )
  )
  (:action release_admin_coordinator
    :parameters (?referral_case - referral_case ?admin_coordinator - admin_coordinator)
    :precondition
      (and
        (admin_coordinator_assigned ?referral_case ?admin_coordinator)
      )
    :effect
      (and
        (admin_coordinator_available ?admin_coordinator)
        (not
          (admin_coordinator_assigned ?referral_case ?admin_coordinator)
        )
      )
  )
  (:action perform_clinical_review_with_clinician
    :parameters (?referral_case - referral_case ?admin_coordinator - admin_coordinator ?clinician_availability - clinician_availability)
    :precondition
      (and
        (not
          (clinical_authorization_obtained ?referral_case)
        )
        (case_specialist_assigned ?referral_case)
        (clinician_shift_available ?clinician_availability)
        (admin_coordinator_assigned ?referral_case ?admin_coordinator)
        (admin_coordinator_reserved_flag ?referral_case)
      )
    :effect
      (and
        (not
          (administrative_hold_required ?referral_case)
        )
        (clinical_authorization_obtained ?referral_case)
      )
  )
  (:action finalize_referral_case_after_notification
    :parameters (?referral_case - referral_case)
    :precondition
      (and
        (referral_registered ?referral_case)
        (triage_complete ?referral_case)
        (patient_notified_of_appointment ?referral_case)
        (case_specialist_assigned ?referral_case)
        (clinical_authorization_obtained ?referral_case)
        (not
          (referral_finalized ?referral_case)
        )
        (patient_notification_sent ?referral_case)
        (appointment_confirmed ?referral_case)
        (clinical_authorization_granted ?referral_case)
      )
    :effect
      (and
        (referral_finalized ?referral_case)
      )
  )
  (:action notify_patient_of_appointment
    :parameters (?referral_case - referral_case ?admin_coordinator - admin_coordinator ?clinician_availability - clinician_availability)
    :precondition
      (and
        (clinical_authorization_obtained ?referral_case)
        (clinician_shift_available ?clinician_availability)
        (not
          (patient_notified_of_appointment ?referral_case)
        )
        (patient_notification_sent ?referral_case)
        (referral_registered ?referral_case)
        (triage_complete ?referral_case)
        (admin_coordinator_assigned ?referral_case ?admin_coordinator)
      )
    :effect
      (and
        (patient_notified_of_appointment ?referral_case)
      )
  )
  (:action release_diagnostic_test
    :parameters (?referral_case - referral_case ?diagnostic_test - diagnostic_test)
    :precondition
      (and
        (diagnostic_test_reserved ?referral_case ?diagnostic_test)
      )
    :effect
      (and
        (diagnostic_test_available ?diagnostic_test)
        (not
          (diagnostic_test_reserved ?referral_case ?diagnostic_test)
        )
      )
  )
  (:action allocate_referral_reason_to_case
    :parameters (?referral_case - referral_case ?referral_reason - referral_reason)
    :precondition
      (and
        (referral_reason_available ?referral_reason)
        (referral_registered ?referral_case)
        (case_has_referral_reason ?referral_case ?referral_reason)
      )
    :effect
      (and
        (referral_reason_allocated ?referral_case ?referral_reason)
        (not
          (referral_reason_available ?referral_reason)
        )
      )
  )
  (:action register_referral_case
    :parameters (?referral_case - referral_case)
    :precondition
      (and
        (not
          (referral_registered ?referral_case)
        )
        (not
          (referral_finalized ?referral_case)
        )
      )
    :effect
      (and
        (referral_registered ?referral_case)
      )
  )
  (:action assign_external_partner
    :parameters (?referral_case - referral_case ?external_partner - external_partner)
    :precondition
      (and
        (not
          (admin_coordinator_reserved_flag ?referral_case)
        )
        (referral_registered ?referral_case)
        (external_partner_available ?external_partner)
        (case_specialist_assigned ?referral_case)
      )
    :effect
      (and
        (administrative_hold_required ?referral_case)
        (not
          (external_partner_available ?external_partner)
        )
        (admin_coordinator_reserved_flag ?referral_case)
      )
  )
  (:action create_appointment_with_resources
    :parameters (?referral_case - referral_case ?clinical_service - clinical_service ?medical_equipment - medical_equipment ?ancillary_resource - ancillary_resource)
    :precondition
      (and
        (ancillary_resource_available ?ancillary_resource)
        (ancillary_required_for_case ?referral_case ?ancillary_resource)
        (not
          (appointment_confirmed ?referral_case)
        )
        (case_specialist_assigned ?referral_case)
        (service_available ?clinical_service)
        (case_service_match ?referral_case ?clinical_service)
        (equipment_reserved ?referral_case ?medical_equipment)
      )
    :effect
      (and
        (service_appointment_created ?referral_case ?clinical_service)
        (not
          (ancillary_resource_available ?ancillary_resource)
        )
        (escalation_flag ?referral_case)
        (not
          (service_available ?clinical_service)
        )
        (administrative_hold_required ?referral_case)
        (appointment_confirmed ?referral_case)
      )
  )
  (:action record_patient_notification_sent_via_partner
    :parameters (?referral_case - referral_case ?external_partner - external_partner)
    :precondition
      (and
        (external_partner_available ?external_partner)
        (not
          (administrative_hold_required ?referral_case)
        )
        (clinical_authorization_obtained ?referral_case)
        (clinical_authorization_granted ?referral_case)
        (not
          (patient_notification_sent ?referral_case)
        )
      )
    :effect
      (and
        (patient_notification_sent ?referral_case)
        (not
          (external_partner_available ?external_partner)
        )
      )
  )
  (:action unassign_specialist_from_case
    :parameters (?referral_case - referral_case ?specialist_provider - specialist_provider)
    :precondition
      (and
        (assigned_specialist ?referral_case ?specialist_provider)
        (not
          (clinical_authorization_granted ?referral_case)
        )
        (not
          (appointment_confirmed ?referral_case)
        )
      )
    :effect
      (and
        (not
          (assigned_specialist ?referral_case ?specialist_provider)
        )
        (specialist_available ?specialist_provider)
        (not
          (case_specialist_assigned ?referral_case)
        )
        (not
          (admin_coordinator_reserved_flag ?referral_case)
        )
        (not
          (appointment_finalized ?referral_case)
        )
        (not
          (clinical_authorization_obtained ?referral_case)
        )
        (not
          (escalation_flag ?referral_case)
        )
        (not
          (administrative_hold_required ?referral_case)
        )
      )
  )
  (:action record_patient_notification_sent
    :parameters (?referral_case - referral_case ?admin_coordinator - admin_coordinator)
    :precondition
      (and
        (not
          (patient_notification_sent ?referral_case)
        )
        (admin_coordinator_assigned ?referral_case ?admin_coordinator)
        (clinical_authorization_obtained ?referral_case)
        (clinical_authorization_granted ?referral_case)
        (not
          (administrative_hold_required ?referral_case)
        )
      )
    :effect
      (and
        (patient_notification_sent ?referral_case)
      )
  )
  (:action finalize_referral_case_with_timeslot
    :parameters (?referral_case - referral_case ?appointment_timeslot - appointment_timeslot)
    :precondition
      (and
        (patient_notification_sent ?referral_case)
        (clinical_authorization_granted ?referral_case)
        (appointment_confirmed ?referral_case)
        (case_timeslot_allocated ?referral_case ?appointment_timeslot)
        (clinical_authorization_obtained ?referral_case)
        (case_specialist_assigned ?referral_case)
        (referral_registered ?referral_case)
        (not
          (referral_finalized ?referral_case)
        )
        (triage_complete ?referral_case)
      )
    :effect
      (and
        (referral_finalized ?referral_case)
      )
  )
  (:action confirm_admin_reservation
    :parameters (?referral_case - referral_case ?admin_coordinator - admin_coordinator)
    :precondition
      (and
        (referral_registered ?referral_case)
        (case_specialist_assigned ?referral_case)
        (not
          (admin_coordinator_reserved_flag ?referral_case)
        )
        (admin_coordinator_assigned ?referral_case ?admin_coordinator)
      )
    :effect
      (and
        (admin_coordinator_reserved_flag ?referral_case)
      )
  )
  (:action assign_specialist_to_case
    :parameters (?referral_case - referral_case ?specialist_provider - specialist_provider)
    :precondition
      (and
        (not
          (case_specialist_assigned ?referral_case)
        )
        (referral_registered ?referral_case)
        (specialist_available ?specialist_provider)
        (eligible_specialist_for_case ?referral_case ?specialist_provider)
      )
    :effect
      (and
        (case_specialist_assigned ?referral_case)
        (not
          (specialist_available ?specialist_provider)
        )
        (assigned_specialist ?referral_case ?specialist_provider)
      )
  )
  (:action reconfirm_clinical_authorization
    :parameters (?referral_case - referral_case ?admin_coordinator - admin_coordinator ?clinician_availability - clinician_availability)
    :precondition
      (and
        (case_specialist_assigned ?referral_case)
        (not
          (clinical_authorization_obtained ?referral_case)
        )
        (admin_coordinator_assigned ?referral_case ?admin_coordinator)
        (clinical_authorization_granted ?referral_case)
        (clinician_shift_available ?clinician_availability)
        (appointment_finalized ?referral_case)
      )
    :effect
      (and
        (clinical_authorization_obtained ?referral_case)
      )
  )
  (:action record_clinician_confirmation_for_timeslot
    :parameters (?referral_subtype_b - referral_subtype_b ?referral_subtype_a - referral_subtype_a ?appointment_timeslot - appointment_timeslot)
    :precondition
      (and
        (referral_registered ?referral_subtype_b)
        (subtype_timeslot_compatible ?referral_subtype_a ?appointment_timeslot)
        (triage_complete ?referral_subtype_b)
        (not
          (case_timeslot_allocated ?referral_subtype_b ?appointment_timeslot)
        )
        (case_timeslot_candidate ?referral_subtype_b ?appointment_timeslot)
      )
    :effect
      (and
        (case_timeslot_allocated ?referral_subtype_b ?appointment_timeslot)
      )
  )
)

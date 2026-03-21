(define (domain imaging_lab_coordination_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types care_sequence - object appointment_slot - object imaging_timeslot - object clinical_staff - object laboratory_resource - object imaging_staff - object imaging_device - object patient_prep_resource - object imaging_protocol - object assigned_nurse - object lab_sample_slot - object contrast_agent - object operational_resource - object transport_team - operational_resource escort_service - operational_resource referring_facility_sequence - care_sequence ordering_provider_sequence - care_sequence)
  (:predicates
    (prep_resource_available ?patient_prep_resource - patient_prep_resource)
    (sequence_assigned_clinical_staff ?care_sequence - care_sequence ?clinical_staff - clinical_staff)
    (procedure_finalized ?care_sequence - care_sequence)
    (sequence_assigned_slot ?care_sequence - care_sequence ?appointment_slot - appointment_slot)
    (sequence_operational_resource_needed ?care_sequence - care_sequence ?operational_resource - operational_resource)
    (imaging_staff_available ?imaging_staff - imaging_staff)
    (clinical_staff_available ?clinical_staff - clinical_staff)
    (sequence_contrast_compatible ?care_sequence - care_sequence ?contrast_agent - contrast_agent)
    (sequence_completed ?care_sequence - care_sequence)
    (final_check_required ?care_sequence - care_sequence)
    (sequence_slot_compatible ?care_sequence - care_sequence ?appointment_slot - appointment_slot)
    (imaging_timeslot_available ?imaging_timeslot - imaging_timeslot)
    (lab_sample_slot_available ?lab_sample_slot - lab_sample_slot)
    (device_available ?imaging_device - imaging_device)
    (imaging_acquisition_confirmed ?care_sequence - care_sequence)
    (sequence_clinical_staff_compatible ?care_sequence - care_sequence ?clinical_staff - clinical_staff)
    (sequence_reserved_supply ?care_sequence - care_sequence ?contrast_agent - contrast_agent)
    (sequence_assigned_imaging_timeslot ?care_sequence - care_sequence ?imaging_timeslot - imaging_timeslot)
    (staffing_confirmed ?care_sequence - care_sequence)
    (sequence_imaging_staff_compatible ?care_sequence - care_sequence ?imaging_staff - imaging_staff)
    (contrast_available ?contrast_agent - contrast_agent)
    (referral_confirmed ?care_sequence - care_sequence)
    (preparation_completed ?care_sequence - care_sequence)
    (sequence_lab_resource_compatible ?care_sequence - care_sequence ?laboratory_resource - laboratory_resource)
    (sequence_uses_lab_resource ?care_sequence - care_sequence ?laboratory_resource - laboratory_resource)
    (lab_sample_pending ?care_sequence - care_sequence)
    (sequence_device_reservation ?care_sequence - care_sequence ?imaging_device - imaging_device)
    (escort_or_transport_confirmed ?care_sequence - care_sequence)
    (sequence_lab_sample_slot_compatible ?care_sequence - care_sequence ?lab_sample_slot - lab_sample_slot)
    (sequence_registered ?care_sequence - care_sequence)
    (slot_available ?appointment_slot - appointment_slot)
    (slot_allocated ?care_sequence - care_sequence)
    (assigned_nurse_available ?assigned_nurse - assigned_nurse)
    (protocol_available ?imaging_protocol - imaging_protocol)
    (sequence_uses_imaging_staff ?care_sequence - care_sequence ?imaging_staff - imaging_staff)
    (sequence_facility_supports_protocol ?care_sequence - care_sequence ?imaging_protocol - imaging_protocol)
    (consent_verified ?care_sequence - care_sequence)
    (device_check_completed ?care_sequence - care_sequence)
    (sequence_protocol_link ?care_sequence - care_sequence ?imaging_protocol - imaging_protocol)
    (lab_resource_available ?laboratory_resource - laboratory_resource)
    (sequence_requires_protocol ?care_sequence - care_sequence ?imaging_protocol - imaging_protocol)
    (sequence_timeslot_compatible ?care_sequence - care_sequence ?imaging_timeslot - imaging_timeslot)
    (prep_pending_flag ?care_sequence - care_sequence)
    (protocol_approved_for_sequence ?care_sequence - care_sequence ?imaging_protocol - imaging_protocol)
  )
  (:action release_contrast_supply
    :parameters (?care_sequence - care_sequence ?contrast_agent - contrast_agent)
    :precondition
      (and
        (sequence_reserved_supply ?care_sequence ?contrast_agent)
      )
    :effect
      (and
        (contrast_available ?contrast_agent)
        (not
          (sequence_reserved_supply ?care_sequence ?contrast_agent)
        )
      )
  )
  (:action confirm_staff_and_transport_with_contrast
    :parameters (?care_sequence - care_sequence ?imaging_staff - imaging_staff ?contrast_agent - contrast_agent ?escort_service - escort_service)
    :precondition
      (and
        (not
          (staffing_confirmed ?care_sequence)
        )
        (imaging_acquisition_confirmed ?care_sequence)
        (preparation_completed ?care_sequence)
        (sequence_reserved_supply ?care_sequence ?contrast_agent)
        (sequence_operational_resource_needed ?care_sequence ?escort_service)
        (sequence_uses_imaging_staff ?care_sequence ?imaging_staff)
      )
    :effect
      (and
        (prep_pending_flag ?care_sequence)
        (staffing_confirmed ?care_sequence)
      )
  )
  (:action complete_final_checks_and_close_sequence
    :parameters (?care_sequence - care_sequence)
    :precondition
      (and
        (preparation_completed ?care_sequence)
        (slot_allocated ?care_sequence)
        (imaging_acquisition_confirmed ?care_sequence)
        (sequence_registered ?care_sequence)
        (device_check_completed ?care_sequence)
        (not
          (sequence_completed ?care_sequence)
        )
        (final_check_required ?care_sequence)
        (staffing_confirmed ?care_sequence)
      )
    :effect
      (and
        (sequence_completed ?care_sequence)
      )
  )
  (:action clear_lab_pending_flag_after_acquisition
    :parameters (?care_sequence - care_sequence ?laboratory_resource - laboratory_resource ?clinical_staff - clinical_staff)
    :precondition
      (and
        (imaging_acquisition_confirmed ?care_sequence)
        (lab_sample_pending ?care_sequence)
        (sequence_uses_lab_resource ?care_sequence ?laboratory_resource)
        (sequence_assigned_clinical_staff ?care_sequence ?clinical_staff)
      )
    :effect
      (and
        (not
          (lab_sample_pending ?care_sequence)
        )
        (not
          (prep_pending_flag ?care_sequence)
        )
      )
  )
  (:action reserve_imaging_device
    :parameters (?care_sequence - care_sequence ?imaging_device - imaging_device)
    :precondition
      (and
        (device_available ?imaging_device)
        (sequence_registered ?care_sequence)
      )
    :effect
      (and
        (not
          (device_available ?imaging_device)
        )
        (sequence_device_reservation ?care_sequence ?imaging_device)
      )
  )
  (:action confirm_staff_and_transport_for_post_prep
    :parameters (?care_sequence - care_sequence ?laboratory_resource - laboratory_resource ?clinical_staff - clinical_staff ?transport_team - transport_team)
    :precondition
      (and
        (sequence_operational_resource_needed ?care_sequence ?transport_team)
        (preparation_completed ?care_sequence)
        (not
          (prep_pending_flag ?care_sequence)
        )
        (sequence_uses_lab_resource ?care_sequence ?laboratory_resource)
        (imaging_acquisition_confirmed ?care_sequence)
        (sequence_assigned_clinical_staff ?care_sequence ?clinical_staff)
        (not
          (staffing_confirmed ?care_sequence)
        )
      )
    :effect
      (and
        (staffing_confirmed ?care_sequence)
      )
  )
  (:action apply_protocol_supply_preparation
    :parameters (?care_sequence - care_sequence ?imaging_protocol - imaging_protocol)
    :precondition
      (and
        (slot_allocated ?care_sequence)
        (protocol_approved_for_sequence ?care_sequence ?imaging_protocol)
        (not
          (preparation_completed ?care_sequence)
        )
      )
    :effect
      (and
        (preparation_completed ?care_sequence)
        (not
          (prep_pending_flag ?care_sequence)
        )
      )
  )
  (:action reserve_imaging_staff
    :parameters (?care_sequence - care_sequence ?imaging_staff - imaging_staff)
    :precondition
      (and
        (sequence_imaging_staff_compatible ?care_sequence ?imaging_staff)
        (sequence_registered ?care_sequence)
        (imaging_staff_available ?imaging_staff)
      )
    :effect
      (and
        (sequence_uses_imaging_staff ?care_sequence ?imaging_staff)
        (not
          (imaging_staff_available ?imaging_staff)
        )
      )
  )
  (:action reserve_lab_resource
    :parameters (?care_sequence - care_sequence ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (sequence_registered ?care_sequence)
        (lab_resource_available ?laboratory_resource)
        (sequence_lab_resource_compatible ?care_sequence ?laboratory_resource)
      )
    :effect
      (and
        (not
          (lab_resource_available ?laboratory_resource)
        )
        (sequence_uses_lab_resource ?care_sequence ?laboratory_resource)
      )
  )
  (:action release_imaging_staff
    :parameters (?care_sequence - care_sequence ?imaging_staff - imaging_staff)
    :precondition
      (and
        (sequence_uses_imaging_staff ?care_sequence ?imaging_staff)
      )
    :effect
      (and
        (imaging_staff_available ?imaging_staff)
        (not
          (sequence_uses_imaging_staff ?care_sequence ?imaging_staff)
        )
      )
  )
  (:action release_clinical_staff
    :parameters (?care_sequence - care_sequence ?clinical_staff - clinical_staff)
    :precondition
      (and
        (sequence_assigned_clinical_staff ?care_sequence ?clinical_staff)
      )
    :effect
      (and
        (clinical_staff_available ?clinical_staff)
        (not
          (sequence_assigned_clinical_staff ?care_sequence ?clinical_staff)
        )
      )
  )
  (:action reserve_protocol_timeslot_mapping
    :parameters (?care_sequence - care_sequence ?imaging_protocol - imaging_protocol)
    :precondition
      (and
        (device_check_completed ?care_sequence)
        (protocol_available ?imaging_protocol)
        (sequence_protocol_link ?care_sequence ?imaging_protocol)
      )
    :effect
      (and
        (sequence_facility_supports_protocol ?care_sequence ?imaging_protocol)
        (not
          (protocol_available ?imaging_protocol)
        )
      )
  )
  (:action assign_clinical_staff
    :parameters (?care_sequence - care_sequence ?clinical_staff - clinical_staff)
    :precondition
      (and
        (sequence_registered ?care_sequence)
        (clinical_staff_available ?clinical_staff)
        (sequence_clinical_staff_compatible ?care_sequence ?clinical_staff)
      )
    :effect
      (and
        (sequence_assigned_clinical_staff ?care_sequence ?clinical_staff)
        (not
          (clinical_staff_available ?clinical_staff)
        )
      )
  )
  (:action confirm_imaging_and_timeslot_and_mark_acquisition_ready
    :parameters (?care_sequence - care_sequence ?imaging_timeslot - imaging_timeslot ?laboratory_resource - laboratory_resource ?clinical_staff - clinical_staff)
    :precondition
      (and
        (slot_allocated ?care_sequence)
        (imaging_timeslot_available ?imaging_timeslot)
        (sequence_timeslot_compatible ?care_sequence ?imaging_timeslot)
        (not
          (imaging_acquisition_confirmed ?care_sequence)
        )
        (sequence_assigned_clinical_staff ?care_sequence ?clinical_staff)
        (sequence_uses_lab_resource ?care_sequence ?laboratory_resource)
      )
    :effect
      (and
        (sequence_assigned_imaging_timeslot ?care_sequence ?imaging_timeslot)
        (not
          (imaging_timeslot_available ?imaging_timeslot)
        )
        (imaging_acquisition_confirmed ?care_sequence)
      )
  )
  (:action finalize_procedure_and_clear_pending
    :parameters (?care_sequence - care_sequence ?laboratory_resource - laboratory_resource ?clinical_staff - clinical_staff)
    :precondition
      (and
        (sequence_uses_lab_resource ?care_sequence ?laboratory_resource)
        (staffing_confirmed ?care_sequence)
        (sequence_assigned_clinical_staff ?care_sequence ?clinical_staff)
        (prep_pending_flag ?care_sequence)
      )
    :effect
      (and
        (not
          (lab_sample_pending ?care_sequence)
        )
        (not
          (prep_pending_flag ?care_sequence)
        )
        (not
          (preparation_completed ?care_sequence)
        )
        (procedure_finalized ?care_sequence)
      )
  )
  (:action release_imaging_device_reservation
    :parameters (?care_sequence - care_sequence ?imaging_device - imaging_device)
    :precondition
      (and
        (sequence_device_reservation ?care_sequence ?imaging_device)
      )
    :effect
      (and
        (device_available ?imaging_device)
        (not
          (sequence_device_reservation ?care_sequence ?imaging_device)
        )
      )
  )
  (:action perform_nurse_preparation_step
    :parameters (?care_sequence - care_sequence ?imaging_device - imaging_device ?assigned_nurse - assigned_nurse)
    :precondition
      (and
        (not
          (preparation_completed ?care_sequence)
        )
        (slot_allocated ?care_sequence)
        (assigned_nurse_available ?assigned_nurse)
        (sequence_device_reservation ?care_sequence ?imaging_device)
        (consent_verified ?care_sequence)
      )
    :effect
      (and
        (not
          (prep_pending_flag ?care_sequence)
        )
        (preparation_completed ?care_sequence)
      )
  )
  (:action complete_final_checks_with_escort_and_close_sequence
    :parameters (?care_sequence - care_sequence)
    :precondition
      (and
        (sequence_registered ?care_sequence)
        (referral_confirmed ?care_sequence)
        (escort_or_transport_confirmed ?care_sequence)
        (slot_allocated ?care_sequence)
        (preparation_completed ?care_sequence)
        (not
          (sequence_completed ?care_sequence)
        )
        (device_check_completed ?care_sequence)
        (imaging_acquisition_confirmed ?care_sequence)
        (staffing_confirmed ?care_sequence)
      )
    :effect
      (and
        (sequence_completed ?care_sequence)
      )
  )
  (:action confirm_escort_and_mark_ready
    :parameters (?care_sequence - care_sequence ?imaging_device - imaging_device ?assigned_nurse - assigned_nurse)
    :precondition
      (and
        (preparation_completed ?care_sequence)
        (assigned_nurse_available ?assigned_nurse)
        (not
          (escort_or_transport_confirmed ?care_sequence)
        )
        (device_check_completed ?care_sequence)
        (sequence_registered ?care_sequence)
        (referral_confirmed ?care_sequence)
        (sequence_device_reservation ?care_sequence ?imaging_device)
      )
    :effect
      (and
        (escort_or_transport_confirmed ?care_sequence)
      )
  )
  (:action release_lab_resource_reservation
    :parameters (?care_sequence - care_sequence ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (sequence_uses_lab_resource ?care_sequence ?laboratory_resource)
      )
    :effect
      (and
        (lab_resource_available ?laboratory_resource)
        (not
          (sequence_uses_lab_resource ?care_sequence ?laboratory_resource)
        )
      )
  )
  (:action reserve_contrast_supply
    :parameters (?care_sequence - care_sequence ?contrast_agent - contrast_agent)
    :precondition
      (and
        (contrast_available ?contrast_agent)
        (sequence_registered ?care_sequence)
        (sequence_contrast_compatible ?care_sequence ?contrast_agent)
      )
    :effect
      (and
        (sequence_reserved_supply ?care_sequence ?contrast_agent)
        (not
          (contrast_available ?contrast_agent)
        )
      )
  )
  (:action register_care_sequence
    :parameters (?care_sequence - care_sequence)
    :precondition
      (and
        (not
          (sequence_registered ?care_sequence)
        )
        (not
          (sequence_completed ?care_sequence)
        )
      )
    :effect
      (and
        (sequence_registered ?care_sequence)
      )
  )
  (:action allocate_prep_resource_and_verify_consent
    :parameters (?care_sequence - care_sequence ?patient_prep_resource - patient_prep_resource)
    :precondition
      (and
        (not
          (consent_verified ?care_sequence)
        )
        (sequence_registered ?care_sequence)
        (prep_resource_available ?patient_prep_resource)
        (slot_allocated ?care_sequence)
      )
    :effect
      (and
        (prep_pending_flag ?care_sequence)
        (not
          (prep_resource_available ?patient_prep_resource)
        )
        (consent_verified ?care_sequence)
      )
  )
  (:action coordinate_imaging_with_lab_sample_and_mark_pending
    :parameters (?care_sequence - care_sequence ?imaging_timeslot - imaging_timeslot ?imaging_staff - imaging_staff ?lab_sample_slot - lab_sample_slot)
    :precondition
      (and
        (lab_sample_slot_available ?lab_sample_slot)
        (sequence_lab_sample_slot_compatible ?care_sequence ?lab_sample_slot)
        (not
          (imaging_acquisition_confirmed ?care_sequence)
        )
        (slot_allocated ?care_sequence)
        (imaging_timeslot_available ?imaging_timeslot)
        (sequence_timeslot_compatible ?care_sequence ?imaging_timeslot)
        (sequence_uses_imaging_staff ?care_sequence ?imaging_staff)
      )
    :effect
      (and
        (sequence_assigned_imaging_timeslot ?care_sequence ?imaging_timeslot)
        (not
          (lab_sample_slot_available ?lab_sample_slot)
        )
        (lab_sample_pending ?care_sequence)
        (not
          (imaging_timeslot_available ?imaging_timeslot)
        )
        (prep_pending_flag ?care_sequence)
        (imaging_acquisition_confirmed ?care_sequence)
      )
  )
  (:action mark_device_check_complete_with_prep_resource
    :parameters (?care_sequence - care_sequence ?patient_prep_resource - patient_prep_resource)
    :precondition
      (and
        (prep_resource_available ?patient_prep_resource)
        (not
          (prep_pending_flag ?care_sequence)
        )
        (preparation_completed ?care_sequence)
        (staffing_confirmed ?care_sequence)
        (not
          (device_check_completed ?care_sequence)
        )
      )
    :effect
      (and
        (device_check_completed ?care_sequence)
        (not
          (prep_resource_available ?patient_prep_resource)
        )
      )
  )
  (:action release_appointment_slot_and_reset
    :parameters (?care_sequence - care_sequence ?appointment_slot - appointment_slot)
    :precondition
      (and
        (sequence_assigned_slot ?care_sequence ?appointment_slot)
        (not
          (staffing_confirmed ?care_sequence)
        )
        (not
          (imaging_acquisition_confirmed ?care_sequence)
        )
      )
    :effect
      (and
        (not
          (sequence_assigned_slot ?care_sequence ?appointment_slot)
        )
        (slot_available ?appointment_slot)
        (not
          (slot_allocated ?care_sequence)
        )
        (not
          (consent_verified ?care_sequence)
        )
        (not
          (procedure_finalized ?care_sequence)
        )
        (not
          (preparation_completed ?care_sequence)
        )
        (not
          (lab_sample_pending ?care_sequence)
        )
        (not
          (prep_pending_flag ?care_sequence)
        )
      )
  )
  (:action mark_device_check_complete
    :parameters (?care_sequence - care_sequence ?imaging_device - imaging_device)
    :precondition
      (and
        (not
          (device_check_completed ?care_sequence)
        )
        (sequence_device_reservation ?care_sequence ?imaging_device)
        (preparation_completed ?care_sequence)
        (staffing_confirmed ?care_sequence)
        (not
          (prep_pending_flag ?care_sequence)
        )
      )
    :effect
      (and
        (device_check_completed ?care_sequence)
      )
  )
  (:action complete_final_checks_with_protocol_and_close_sequence
    :parameters (?care_sequence - care_sequence ?imaging_protocol - imaging_protocol)
    :precondition
      (and
        (device_check_completed ?care_sequence)
        (staffing_confirmed ?care_sequence)
        (imaging_acquisition_confirmed ?care_sequence)
        (protocol_approved_for_sequence ?care_sequence ?imaging_protocol)
        (preparation_completed ?care_sequence)
        (slot_allocated ?care_sequence)
        (sequence_registered ?care_sequence)
        (not
          (sequence_completed ?care_sequence)
        )
        (referral_confirmed ?care_sequence)
      )
    :effect
      (and
        (sequence_completed ?care_sequence)
      )
  )
  (:action confirm_device_assignment
    :parameters (?care_sequence - care_sequence ?imaging_device - imaging_device)
    :precondition
      (and
        (sequence_registered ?care_sequence)
        (slot_allocated ?care_sequence)
        (not
          (consent_verified ?care_sequence)
        )
        (sequence_device_reservation ?care_sequence ?imaging_device)
      )
    :effect
      (and
        (consent_verified ?care_sequence)
      )
  )
  (:action assign_appointment_slot
    :parameters (?care_sequence - care_sequence ?appointment_slot - appointment_slot)
    :precondition
      (and
        (not
          (slot_allocated ?care_sequence)
        )
        (sequence_registered ?care_sequence)
        (slot_available ?appointment_slot)
        (sequence_slot_compatible ?care_sequence ?appointment_slot)
      )
    :effect
      (and
        (slot_allocated ?care_sequence)
        (not
          (slot_available ?appointment_slot)
        )
        (sequence_assigned_slot ?care_sequence ?appointment_slot)
      )
  )
  (:action reconfirm_device_and_nurse_before_imaging
    :parameters (?care_sequence - care_sequence ?imaging_device - imaging_device ?assigned_nurse - assigned_nurse)
    :precondition
      (and
        (slot_allocated ?care_sequence)
        (not
          (preparation_completed ?care_sequence)
        )
        (sequence_device_reservation ?care_sequence ?imaging_device)
        (staffing_confirmed ?care_sequence)
        (assigned_nurse_available ?assigned_nurse)
        (procedure_finalized ?care_sequence)
      )
    :effect
      (and
        (preparation_completed ?care_sequence)
      )
  )
  (:action provider_confirm_protocol_for_sequence
    :parameters (?ordering_provider - ordering_provider_sequence ?referring_facility - referring_facility_sequence ?imaging_protocol - imaging_protocol)
    :precondition
      (and
        (sequence_registered ?ordering_provider)
        (sequence_facility_supports_protocol ?referring_facility ?imaging_protocol)
        (referral_confirmed ?ordering_provider)
        (not
          (protocol_approved_for_sequence ?ordering_provider ?imaging_protocol)
        )
        (sequence_requires_protocol ?ordering_provider ?imaging_protocol)
      )
    :effect
      (and
        (protocol_approved_for_sequence ?ordering_provider ?imaging_protocol)
      )
  )
)

(define (domain maternal_care_visit_stitching_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object maternal_visit_case - entity appointment_slot - entity clinical_service - entity clinical_location - entity diagnostic_resource - entity support_service - entity time_slot - entity ancillary_staff - entity specialist_appointment_slot - entity special_equipment - entity lab_sample_slot - entity external_service - entity clinical_staff - entity midwife - clinical_staff obstetrician - clinical_staff prenatal_case_instance - maternal_visit_case postnatal_case_instance - maternal_visit_case)

  (:predicates
    (case_registered ?maternal_visit_case - maternal_visit_case)
    (case_has_appointment_slot ?maternal_visit_case - maternal_visit_case ?appointment_slot - appointment_slot)
    (case_booking_flag ?maternal_visit_case - maternal_visit_case)
    (case_checked_in ?maternal_visit_case - maternal_visit_case)
    (case_initial_assessment_complete ?maternal_visit_case - maternal_visit_case)
    (case_reserved_diagnostic_resource ?maternal_visit_case - maternal_visit_case ?diagnostic_resource - diagnostic_resource)
    (case_reserved_location ?maternal_visit_case - maternal_visit_case ?clinical_location - clinical_location)
    (case_reserved_support_service ?maternal_visit_case - maternal_visit_case ?support_service - support_service)
    (case_reserved_external_service ?maternal_visit_case - maternal_visit_case ?external_service - external_service)
    (case_scheduled_clinical_service ?maternal_visit_case - maternal_visit_case ?clinical_service - clinical_service)
    (case_service_allocated ?maternal_visit_case - maternal_visit_case)
    (case_ready_for_procedure ?maternal_visit_case - maternal_visit_case)
    (case_eligible_for_specialist ?maternal_visit_case - maternal_visit_case)
    (case_completed ?maternal_visit_case - maternal_visit_case)
    (ancillary_assigned ?maternal_visit_case - maternal_visit_case)
    (procedure_completed ?maternal_visit_case - maternal_visit_case)
    (case_to_specialist_slot ?maternal_visit_case - maternal_visit_case ?specialist_appointment_slot - specialist_appointment_slot)
    (case_specialist_slot_confirmed ?maternal_visit_case - maternal_visit_case ?specialist_appointment_slot - specialist_appointment_slot)
    (case_checkin_confirmed ?maternal_visit_case - maternal_visit_case)
    (appointment_slot_available ?appointment_slot - appointment_slot)
    (clinical_service_available ?clinical_service - clinical_service)
    (diagnostic_resource_available ?diagnostic_resource - diagnostic_resource)
    (location_available ?clinical_location - clinical_location)
    (support_service_available ?support_service - support_service)
    (time_slot_available ?time_slot - time_slot)
    (ancillary_staff_available ?ancillary_staff - ancillary_staff)
    (specialist_slot_available ?specialist_appointment_slot - specialist_appointment_slot)
    (equipment_available ?special_equipment - special_equipment)
    (lab_sample_slot_available ?lab_sample_slot - lab_sample_slot)
    (external_service_available ?external_service - external_service)
    (case_allowed_appointment_slot ?maternal_visit_case - maternal_visit_case ?appointment_slot - appointment_slot)
    (case_allowed_clinical_service ?maternal_visit_case - maternal_visit_case ?clinical_service - clinical_service)
    (case_allowed_diagnostic_resource ?maternal_visit_case - maternal_visit_case ?diagnostic_resource - diagnostic_resource)
    (case_allowed_location ?maternal_visit_case - maternal_visit_case ?clinical_location - clinical_location)
    (case_allowed_support_service ?maternal_visit_case - maternal_visit_case ?support_service - support_service)
    (case_allowed_lab_sample_slot ?maternal_visit_case - maternal_visit_case ?lab_sample_slot - lab_sample_slot)
    (case_allowed_external_service ?maternal_visit_case - maternal_visit_case ?external_service - external_service)
    (case_assigned_staff ?maternal_visit_case - maternal_visit_case ?clinical_staff - clinical_staff)
    (case_reserved_specialist_slot ?maternal_visit_case - maternal_visit_case ?specialist_appointment_slot - specialist_appointment_slot)
    (is_prenatal_case ?maternal_visit_case - maternal_visit_case)
    (is_postnatal_case ?maternal_visit_case - maternal_visit_case)
    (case_time_slot_reserved ?maternal_visit_case - maternal_visit_case ?time_slot - time_slot)
    (case_lab_required_flag ?maternal_visit_case - maternal_visit_case)
    (case_allowed_specialist_slot ?maternal_visit_case - maternal_visit_case ?specialist_appointment_slot - specialist_appointment_slot)
  )
  (:action register_maternal_visit_case
    :parameters (?maternal_visit_case - maternal_visit_case)
    :precondition
      (and
        (not
          (case_registered ?maternal_visit_case)
        )
        (not
          (case_completed ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_registered ?maternal_visit_case)
      )
  )
  (:action reserve_appointment_slot_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?appointment_slot - appointment_slot)
    :precondition
      (and
        (case_registered ?maternal_visit_case)
        (appointment_slot_available ?appointment_slot)
        (case_allowed_appointment_slot ?maternal_visit_case ?appointment_slot)
        (not
          (case_booking_flag ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_has_appointment_slot ?maternal_visit_case ?appointment_slot)
        (case_booking_flag ?maternal_visit_case)
        (not
          (appointment_slot_available ?appointment_slot)
        )
      )
  )
  (:action cancel_appointment_slot_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?appointment_slot - appointment_slot)
    :precondition
      (and
        (case_has_appointment_slot ?maternal_visit_case ?appointment_slot)
        (not
          (case_service_allocated ?maternal_visit_case)
        )
        (not
          (case_ready_for_procedure ?maternal_visit_case)
        )
      )
    :effect
      (and
        (not
          (case_has_appointment_slot ?maternal_visit_case ?appointment_slot)
        )
        (not
          (case_booking_flag ?maternal_visit_case)
        )
        (not
          (case_checked_in ?maternal_visit_case)
        )
        (not
          (case_initial_assessment_complete ?maternal_visit_case)
        )
        (not
          (ancillary_assigned ?maternal_visit_case)
        )
        (not
          (procedure_completed ?maternal_visit_case)
        )
        (not
          (case_lab_required_flag ?maternal_visit_case)
        )
        (appointment_slot_available ?appointment_slot)
      )
  )
  (:action reserve_time_slot_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?time_slot - time_slot)
    :precondition
      (and
        (case_registered ?maternal_visit_case)
        (time_slot_available ?time_slot)
      )
    :effect
      (and
        (case_time_slot_reserved ?maternal_visit_case ?time_slot)
        (not
          (time_slot_available ?time_slot)
        )
      )
  )
  (:action release_time_slot_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?time_slot - time_slot)
    :precondition
      (and
        (case_time_slot_reserved ?maternal_visit_case ?time_slot)
      )
    :effect
      (and
        (time_slot_available ?time_slot)
        (not
          (case_time_slot_reserved ?maternal_visit_case ?time_slot)
        )
      )
  )
  (:action confirm_case_checkin_for_time_slot
    :parameters (?maternal_visit_case - maternal_visit_case ?time_slot - time_slot)
    :precondition
      (and
        (case_registered ?maternal_visit_case)
        (case_booking_flag ?maternal_visit_case)
        (case_time_slot_reserved ?maternal_visit_case ?time_slot)
        (not
          (case_checked_in ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_checked_in ?maternal_visit_case)
      )
  )
  (:action assign_ancillary_staff_to_case
    :parameters (?maternal_visit_case - maternal_visit_case ?ancillary_staff - ancillary_staff)
    :precondition
      (and
        (case_registered ?maternal_visit_case)
        (case_booking_flag ?maternal_visit_case)
        (ancillary_staff_available ?ancillary_staff)
        (not
          (case_checked_in ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_checked_in ?maternal_visit_case)
        (ancillary_assigned ?maternal_visit_case)
        (not
          (ancillary_staff_available ?ancillary_staff)
        )
      )
  )
  (:action perform_assessment_with_equipment
    :parameters (?maternal_visit_case - maternal_visit_case ?time_slot - time_slot ?special_equipment - special_equipment)
    :precondition
      (and
        (case_checked_in ?maternal_visit_case)
        (case_booking_flag ?maternal_visit_case)
        (case_time_slot_reserved ?maternal_visit_case ?time_slot)
        (equipment_available ?special_equipment)
        (not
          (case_initial_assessment_complete ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_initial_assessment_complete ?maternal_visit_case)
        (not
          (ancillary_assigned ?maternal_visit_case)
        )
      )
  )
  (:action complete_assessment_with_specialist_slot
    :parameters (?maternal_visit_case - maternal_visit_case ?specialist_appointment_slot - specialist_appointment_slot)
    :precondition
      (and
        (case_booking_flag ?maternal_visit_case)
        (case_specialist_slot_confirmed ?maternal_visit_case ?specialist_appointment_slot)
        (not
          (case_initial_assessment_complete ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_initial_assessment_complete ?maternal_visit_case)
        (not
          (ancillary_assigned ?maternal_visit_case)
        )
      )
  )
  (:action reserve_diagnostic_resource_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?diagnostic_resource - diagnostic_resource)
    :precondition
      (and
        (case_registered ?maternal_visit_case)
        (diagnostic_resource_available ?diagnostic_resource)
        (case_allowed_diagnostic_resource ?maternal_visit_case ?diagnostic_resource)
      )
    :effect
      (and
        (case_reserved_diagnostic_resource ?maternal_visit_case ?diagnostic_resource)
        (not
          (diagnostic_resource_available ?diagnostic_resource)
        )
      )
  )
  (:action release_diagnostic_resource_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?diagnostic_resource - diagnostic_resource)
    :precondition
      (and
        (case_reserved_diagnostic_resource ?maternal_visit_case ?diagnostic_resource)
      )
    :effect
      (and
        (diagnostic_resource_available ?diagnostic_resource)
        (not
          (case_reserved_diagnostic_resource ?maternal_visit_case ?diagnostic_resource)
        )
      )
  )
  (:action reserve_clinical_location_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?clinical_location - clinical_location)
    :precondition
      (and
        (case_registered ?maternal_visit_case)
        (location_available ?clinical_location)
        (case_allowed_location ?maternal_visit_case ?clinical_location)
      )
    :effect
      (and
        (case_reserved_location ?maternal_visit_case ?clinical_location)
        (not
          (location_available ?clinical_location)
        )
      )
  )
  (:action release_clinical_location_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?clinical_location - clinical_location)
    :precondition
      (and
        (case_reserved_location ?maternal_visit_case ?clinical_location)
      )
    :effect
      (and
        (location_available ?clinical_location)
        (not
          (case_reserved_location ?maternal_visit_case ?clinical_location)
        )
      )
  )
  (:action reserve_support_service_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?support_service - support_service)
    :precondition
      (and
        (case_registered ?maternal_visit_case)
        (support_service_available ?support_service)
        (case_allowed_support_service ?maternal_visit_case ?support_service)
      )
    :effect
      (and
        (case_reserved_support_service ?maternal_visit_case ?support_service)
        (not
          (support_service_available ?support_service)
        )
      )
  )
  (:action release_support_service_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?support_service - support_service)
    :precondition
      (and
        (case_reserved_support_service ?maternal_visit_case ?support_service)
      )
    :effect
      (and
        (support_service_available ?support_service)
        (not
          (case_reserved_support_service ?maternal_visit_case ?support_service)
        )
      )
  )
  (:action reserve_external_service_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?external_service - external_service)
    :precondition
      (and
        (case_registered ?maternal_visit_case)
        (external_service_available ?external_service)
        (case_allowed_external_service ?maternal_visit_case ?external_service)
      )
    :effect
      (and
        (case_reserved_external_service ?maternal_visit_case ?external_service)
        (not
          (external_service_available ?external_service)
        )
      )
  )
  (:action release_external_service_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?external_service - external_service)
    :precondition
      (and
        (case_reserved_external_service ?maternal_visit_case ?external_service)
      )
    :effect
      (and
        (external_service_available ?external_service)
        (not
          (case_reserved_external_service ?maternal_visit_case ?external_service)
        )
      )
  )
  (:action schedule_clinical_service_providers_and_resources
    :parameters (?maternal_visit_case - maternal_visit_case ?clinical_service - clinical_service ?diagnostic_resource - diagnostic_resource ?clinical_location - clinical_location)
    :precondition
      (and
        (case_booking_flag ?maternal_visit_case)
        (case_reserved_diagnostic_resource ?maternal_visit_case ?diagnostic_resource)
        (case_reserved_location ?maternal_visit_case ?clinical_location)
        (clinical_service_available ?clinical_service)
        (case_allowed_clinical_service ?maternal_visit_case ?clinical_service)
        (not
          (case_service_allocated ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_scheduled_clinical_service ?maternal_visit_case ?clinical_service)
        (case_service_allocated ?maternal_visit_case)
        (not
          (clinical_service_available ?clinical_service)
        )
      )
  )
  (:action schedule_service_with_support_and_lab
    :parameters (?maternal_visit_case - maternal_visit_case ?clinical_service - clinical_service ?support_service - support_service ?lab_sample_slot - lab_sample_slot)
    :precondition
      (and
        (case_booking_flag ?maternal_visit_case)
        (case_reserved_support_service ?maternal_visit_case ?support_service)
        (lab_sample_slot_available ?lab_sample_slot)
        (clinical_service_available ?clinical_service)
        (case_allowed_clinical_service ?maternal_visit_case ?clinical_service)
        (case_allowed_lab_sample_slot ?maternal_visit_case ?lab_sample_slot)
        (not
          (case_service_allocated ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_scheduled_clinical_service ?maternal_visit_case ?clinical_service)
        (case_service_allocated ?maternal_visit_case)
        (case_lab_required_flag ?maternal_visit_case)
        (ancillary_assigned ?maternal_visit_case)
        (not
          (clinical_service_available ?clinical_service)
        )
        (not
          (lab_sample_slot_available ?lab_sample_slot)
        )
      )
  )
  (:action resolve_lab_requirement
    :parameters (?maternal_visit_case - maternal_visit_case ?diagnostic_resource - diagnostic_resource ?clinical_location - clinical_location)
    :precondition
      (and
        (case_service_allocated ?maternal_visit_case)
        (case_lab_required_flag ?maternal_visit_case)
        (case_reserved_diagnostic_resource ?maternal_visit_case ?diagnostic_resource)
        (case_reserved_location ?maternal_visit_case ?clinical_location)
      )
    :effect
      (and
        (not
          (case_lab_required_flag ?maternal_visit_case)
        )
        (not
          (ancillary_assigned ?maternal_visit_case)
        )
      )
  )
  (:action authorize_procedure_with_midwife
    :parameters (?maternal_visit_case - maternal_visit_case ?diagnostic_resource - diagnostic_resource ?clinical_location - clinical_location ?midwife - midwife)
    :precondition
      (and
        (case_initial_assessment_complete ?maternal_visit_case)
        (case_service_allocated ?maternal_visit_case)
        (case_reserved_diagnostic_resource ?maternal_visit_case ?diagnostic_resource)
        (case_reserved_location ?maternal_visit_case ?clinical_location)
        (case_assigned_staff ?maternal_visit_case ?midwife)
        (not
          (ancillary_assigned ?maternal_visit_case)
        )
        (not
          (case_ready_for_procedure ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_ready_for_procedure ?maternal_visit_case)
      )
  )
  (:action authorize_procedure_with_obstetrician
    :parameters (?maternal_visit_case - maternal_visit_case ?support_service - support_service ?external_service - external_service ?obstetrician - obstetrician)
    :precondition
      (and
        (case_initial_assessment_complete ?maternal_visit_case)
        (case_service_allocated ?maternal_visit_case)
        (case_reserved_support_service ?maternal_visit_case ?support_service)
        (case_reserved_external_service ?maternal_visit_case ?external_service)
        (case_assigned_staff ?maternal_visit_case ?obstetrician)
        (not
          (case_ready_for_procedure ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_ready_for_procedure ?maternal_visit_case)
        (ancillary_assigned ?maternal_visit_case)
      )
  )
  (:action complete_procedure_and_finalize_stage
    :parameters (?maternal_visit_case - maternal_visit_case ?diagnostic_resource - diagnostic_resource ?clinical_location - clinical_location)
    :precondition
      (and
        (case_ready_for_procedure ?maternal_visit_case)
        (ancillary_assigned ?maternal_visit_case)
        (case_reserved_diagnostic_resource ?maternal_visit_case ?diagnostic_resource)
        (case_reserved_location ?maternal_visit_case ?clinical_location)
      )
    :effect
      (and
        (procedure_completed ?maternal_visit_case)
        (not
          (ancillary_assigned ?maternal_visit_case)
        )
        (not
          (case_initial_assessment_complete ?maternal_visit_case)
        )
        (not
          (case_lab_required_flag ?maternal_visit_case)
        )
      )
  )
  (:action reassess_with_time_slot_and_equipment
    :parameters (?maternal_visit_case - maternal_visit_case ?time_slot - time_slot ?special_equipment - special_equipment)
    :precondition
      (and
        (procedure_completed ?maternal_visit_case)
        (case_ready_for_procedure ?maternal_visit_case)
        (case_booking_flag ?maternal_visit_case)
        (case_time_slot_reserved ?maternal_visit_case ?time_slot)
        (equipment_available ?special_equipment)
        (not
          (case_initial_assessment_complete ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_initial_assessment_complete ?maternal_visit_case)
      )
  )
  (:action mark_specialist_referral_ready_via_time_slot
    :parameters (?maternal_visit_case - maternal_visit_case ?time_slot - time_slot)
    :precondition
      (and
        (case_ready_for_procedure ?maternal_visit_case)
        (case_initial_assessment_complete ?maternal_visit_case)
        (not
          (ancillary_assigned ?maternal_visit_case)
        )
        (case_time_slot_reserved ?maternal_visit_case ?time_slot)
        (not
          (case_eligible_for_specialist ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_eligible_for_specialist ?maternal_visit_case)
      )
  )
  (:action mark_specialist_referral_ready_with_ancillary_staff
    :parameters (?maternal_visit_case - maternal_visit_case ?ancillary_staff - ancillary_staff)
    :precondition
      (and
        (case_ready_for_procedure ?maternal_visit_case)
        (case_initial_assessment_complete ?maternal_visit_case)
        (not
          (ancillary_assigned ?maternal_visit_case)
        )
        (ancillary_staff_available ?ancillary_staff)
        (not
          (case_eligible_for_specialist ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_eligible_for_specialist ?maternal_visit_case)
        (not
          (ancillary_staff_available ?ancillary_staff)
        )
      )
  )
  (:action reserve_specialist_appointment_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?specialist_appointment_slot - specialist_appointment_slot)
    :precondition
      (and
        (case_eligible_for_specialist ?maternal_visit_case)
        (specialist_slot_available ?specialist_appointment_slot)
        (case_allowed_specialist_slot ?maternal_visit_case ?specialist_appointment_slot)
      )
    :effect
      (and
        (case_reserved_specialist_slot ?maternal_visit_case ?specialist_appointment_slot)
        (not
          (specialist_slot_available ?specialist_appointment_slot)
        )
      )
  )
  (:action confirm_specialist_slot_for_case_transition
    :parameters (?postnatal_case_instance - postnatal_case_instance ?prenatal_case_instance - prenatal_case_instance ?specialist_appointment_slot - specialist_appointment_slot)
    :precondition
      (and
        (case_registered ?postnatal_case_instance)
        (is_postnatal_case ?postnatal_case_instance)
        (case_to_specialist_slot ?postnatal_case_instance ?specialist_appointment_slot)
        (case_reserved_specialist_slot ?prenatal_case_instance ?specialist_appointment_slot)
        (not
          (case_specialist_slot_confirmed ?postnatal_case_instance ?specialist_appointment_slot)
        )
      )
    :effect
      (and
        (case_specialist_slot_confirmed ?postnatal_case_instance ?specialist_appointment_slot)
      )
  )
  (:action confirm_time_slot_checkin_for_case
    :parameters (?maternal_visit_case - maternal_visit_case ?time_slot - time_slot ?special_equipment - special_equipment)
    :precondition
      (and
        (case_registered ?maternal_visit_case)
        (is_postnatal_case ?maternal_visit_case)
        (case_initial_assessment_complete ?maternal_visit_case)
        (case_eligible_for_specialist ?maternal_visit_case)
        (case_time_slot_reserved ?maternal_visit_case ?time_slot)
        (equipment_available ?special_equipment)
        (not
          (case_checkin_confirmed ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_checkin_confirmed ?maternal_visit_case)
      )
  )
  (:action finalize_case_completion
    :parameters (?maternal_visit_case - maternal_visit_case)
    :precondition
      (and
        (is_prenatal_case ?maternal_visit_case)
        (case_registered ?maternal_visit_case)
        (case_booking_flag ?maternal_visit_case)
        (case_service_allocated ?maternal_visit_case)
        (case_ready_for_procedure ?maternal_visit_case)
        (case_eligible_for_specialist ?maternal_visit_case)
        (case_initial_assessment_complete ?maternal_visit_case)
        (not
          (case_completed ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_completed ?maternal_visit_case)
      )
  )
  (:action finalize_case_completion_with_specialist
    :parameters (?maternal_visit_case - maternal_visit_case ?specialist_appointment_slot - specialist_appointment_slot)
    :precondition
      (and
        (is_postnatal_case ?maternal_visit_case)
        (case_registered ?maternal_visit_case)
        (case_booking_flag ?maternal_visit_case)
        (case_service_allocated ?maternal_visit_case)
        (case_ready_for_procedure ?maternal_visit_case)
        (case_eligible_for_specialist ?maternal_visit_case)
        (case_initial_assessment_complete ?maternal_visit_case)
        (case_specialist_slot_confirmed ?maternal_visit_case ?specialist_appointment_slot)
        (not
          (case_completed ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_completed ?maternal_visit_case)
      )
  )
  (:action finalize_case_completion_with_checkin
    :parameters (?maternal_visit_case - maternal_visit_case)
    :precondition
      (and
        (is_postnatal_case ?maternal_visit_case)
        (case_registered ?maternal_visit_case)
        (case_booking_flag ?maternal_visit_case)
        (case_service_allocated ?maternal_visit_case)
        (case_ready_for_procedure ?maternal_visit_case)
        (case_eligible_for_specialist ?maternal_visit_case)
        (case_initial_assessment_complete ?maternal_visit_case)
        (case_checkin_confirmed ?maternal_visit_case)
        (not
          (case_completed ?maternal_visit_case)
        )
      )
    :effect
      (and
        (case_completed ?maternal_visit_case)
      )
  )
)

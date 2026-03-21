(define (domain ed_triage_routing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object patient - entity triage_staff - entity care_area - entity diagnostic_service - entity clinician - entity specialty_service - entity stretcher - entity registration_kiosk - entity treatment_room - entity porter - entity imaging_equipment - entity consultant - entity bed - entity monitored_bed - bed observation_bed - bed adult_patient - patient pediatric_patient - patient)

  (:predicates
    (patient_registered ?patient - patient)
    (triage_assigned ?patient - patient ?triage_staff - triage_staff)
    (triage_in_progress ?patient - patient)
    (triage_assessment_complete ?patient - patient)
    (ready_for_care_assignment ?patient - patient)
    (clinician_reserved ?patient - patient ?clinician - clinician)
    (diagnostic_reserved ?patient - patient ?diagnostic_service - diagnostic_service)
    (specialty_reserved ?patient - patient ?specialty_service - specialty_service)
    (consultant_reserved ?patient - patient ?consultant - consultant)
    (assigned_to_care_area ?patient - patient ?care_area - care_area)
    (in_treatment ?patient - patient)
    (safety_checks_completed ?patient - patient)
    (bed_prepared ?patient - patient)
    (disposition_finalized ?patient - patient)
    (priority_flag ?patient - patient)
    (ready_for_bed_assignment ?patient - patient)
    (treatment_room_compatible ?patient - patient ?treatment_room - treatment_room)
    (treatment_room_reserved ?patient - patient ?treatment_room - treatment_room)
    (ready_for_disposition ?patient - patient)
    (triage_staff_available ?triage_staff - triage_staff)
    (care_area_available ?care_area - care_area)
    (clinician_available ?clinician - clinician)
    (diagnostic_available ?diagnostic_service - diagnostic_service)
    (specialty_available ?specialty_service - specialty_service)
    (stretcher_available ?stretcher - stretcher)
    (registration_kiosk_available ?registration_kiosk - registration_kiosk)
    (treatment_room_available ?treatment_room - treatment_room)
    (porter_available ?porter - porter)
    (imaging_available ?imaging_equipment - imaging_equipment)
    (consultant_available ?consultant - consultant)
    (triage_staff_compatible ?patient - patient ?triage_staff - triage_staff)
    (care_area_compatible ?patient - patient ?care_area - care_area)
    (clinician_compatible ?patient - patient ?clinician - clinician)
    (diagnostic_compatible ?patient - patient ?diagnostic_service - diagnostic_service)
    (specialty_compatible ?patient - patient ?specialty_service - specialty_service)
    (imaging_compatible ?patient - patient ?imaging_equipment - imaging_equipment)
    (consultant_compatible ?patient - patient ?consultant - consultant)
    (bed_compatible ?patient - patient ?bed - bed)
    (treatment_room_in_use ?patient - patient ?treatment_room - treatment_room)
    (is_adult_patient ?patient - patient)
    (is_pediatric_patient ?patient - patient)
    (stretcher_assigned ?patient - patient ?stretcher - stretcher)
    (escalation_required ?patient - patient)
    (treatment_room_compatible_secondary ?patient - patient ?treatment_room - treatment_room)
  )
  (:action register_patient_arrival
    :parameters (?patient - patient)
    :precondition
      (and
        (not
          (patient_registered ?patient)
        )
        (not
          (disposition_finalized ?patient)
        )
      )
    :effect
      (and
        (patient_registered ?patient)
      )
  )
  (:action assign_triage_staff
    :parameters (?patient - patient ?triage_staff - triage_staff)
    :precondition
      (and
        (patient_registered ?patient)
        (triage_staff_available ?triage_staff)
        (triage_staff_compatible ?patient ?triage_staff)
        (not
          (triage_in_progress ?patient)
        )
      )
    :effect
      (and
        (triage_assigned ?patient ?triage_staff)
        (triage_in_progress ?patient)
        (not
          (triage_staff_available ?triage_staff)
        )
      )
  )
  (:action unassign_triage_staff
    :parameters (?patient - patient ?triage_staff - triage_staff)
    :precondition
      (and
        (triage_assigned ?patient ?triage_staff)
        (not
          (in_treatment ?patient)
        )
        (not
          (safety_checks_completed ?patient)
        )
      )
    :effect
      (and
        (not
          (triage_assigned ?patient ?triage_staff)
        )
        (not
          (triage_in_progress ?patient)
        )
        (not
          (triage_assessment_complete ?patient)
        )
        (not
          (ready_for_care_assignment ?patient)
        )
        (not
          (priority_flag ?patient)
        )
        (not
          (ready_for_bed_assignment ?patient)
        )
        (not
          (escalation_required ?patient)
        )
        (triage_staff_available ?triage_staff)
      )
  )
  (:action allocate_stretcher_to_patient
    :parameters (?patient - patient ?stretcher - stretcher)
    :precondition
      (and
        (patient_registered ?patient)
        (stretcher_available ?stretcher)
      )
    :effect
      (and
        (stretcher_assigned ?patient ?stretcher)
        (not
          (stretcher_available ?stretcher)
        )
      )
  )
  (:action release_stretcher_from_patient
    :parameters (?patient - patient ?stretcher - stretcher)
    :precondition
      (and
        (stretcher_assigned ?patient ?stretcher)
      )
    :effect
      (and
        (stretcher_available ?stretcher)
        (not
          (stretcher_assigned ?patient ?stretcher)
        )
      )
  )
  (:action confirm_triage_assessment_with_stretcher
    :parameters (?patient - patient ?stretcher - stretcher)
    :precondition
      (and
        (patient_registered ?patient)
        (triage_in_progress ?patient)
        (stretcher_assigned ?patient ?stretcher)
        (not
          (triage_assessment_complete ?patient)
        )
      )
    :effect
      (and
        (triage_assessment_complete ?patient)
      )
  )
  (:action mark_triage_assessed_via_kiosk
    :parameters (?patient - patient ?registration_kiosk - registration_kiosk)
    :precondition
      (and
        (patient_registered ?patient)
        (triage_in_progress ?patient)
        (registration_kiosk_available ?registration_kiosk)
        (not
          (triage_assessment_complete ?patient)
        )
      )
    :effect
      (and
        (triage_assessment_complete ?patient)
        (priority_flag ?patient)
        (not
          (registration_kiosk_available ?registration_kiosk)
        )
      )
  )
  (:action request_porter
    :parameters (?patient - patient ?stretcher - stretcher ?porter - porter)
    :precondition
      (and
        (triage_assessment_complete ?patient)
        (triage_in_progress ?patient)
        (stretcher_assigned ?patient ?stretcher)
        (porter_available ?porter)
        (not
          (ready_for_care_assignment ?patient)
        )
      )
    :effect
      (and
        (ready_for_care_assignment ?patient)
        (not
          (priority_flag ?patient)
        )
      )
  )
  (:action mark_ready_for_care_after_room_assignment
    :parameters (?patient - patient ?treatment_room - treatment_room)
    :precondition
      (and
        (triage_in_progress ?patient)
        (treatment_room_reserved ?patient ?treatment_room)
        (not
          (ready_for_care_assignment ?patient)
        )
      )
    :effect
      (and
        (ready_for_care_assignment ?patient)
        (not
          (priority_flag ?patient)
        )
      )
  )
  (:action reserve_clinician
    :parameters (?patient - patient ?clinician - clinician)
    :precondition
      (and
        (patient_registered ?patient)
        (clinician_available ?clinician)
        (clinician_compatible ?patient ?clinician)
      )
    :effect
      (and
        (clinician_reserved ?patient ?clinician)
        (not
          (clinician_available ?clinician)
        )
      )
  )
  (:action release_clinician
    :parameters (?patient - patient ?clinician - clinician)
    :precondition
      (and
        (clinician_reserved ?patient ?clinician)
      )
    :effect
      (and
        (clinician_available ?clinician)
        (not
          (clinician_reserved ?patient ?clinician)
        )
      )
  )
  (:action reserve_diagnostic_service
    :parameters (?patient - patient ?diagnostic_service - diagnostic_service)
    :precondition
      (and
        (patient_registered ?patient)
        (diagnostic_available ?diagnostic_service)
        (diagnostic_compatible ?patient ?diagnostic_service)
      )
    :effect
      (and
        (diagnostic_reserved ?patient ?diagnostic_service)
        (not
          (diagnostic_available ?diagnostic_service)
        )
      )
  )
  (:action release_diagnostic_service
    :parameters (?patient - patient ?diagnostic_service - diagnostic_service)
    :precondition
      (and
        (diagnostic_reserved ?patient ?diagnostic_service)
      )
    :effect
      (and
        (diagnostic_available ?diagnostic_service)
        (not
          (diagnostic_reserved ?patient ?diagnostic_service)
        )
      )
  )
  (:action reserve_specialty_service
    :parameters (?patient - patient ?specialty_service - specialty_service)
    :precondition
      (and
        (patient_registered ?patient)
        (specialty_available ?specialty_service)
        (specialty_compatible ?patient ?specialty_service)
      )
    :effect
      (and
        (specialty_reserved ?patient ?specialty_service)
        (not
          (specialty_available ?specialty_service)
        )
      )
  )
  (:action release_specialty_service
    :parameters (?patient - patient ?specialty_service - specialty_service)
    :precondition
      (and
        (specialty_reserved ?patient ?specialty_service)
      )
    :effect
      (and
        (specialty_available ?specialty_service)
        (not
          (specialty_reserved ?patient ?specialty_service)
        )
      )
  )
  (:action reserve_consultant
    :parameters (?patient - patient ?consultant - consultant)
    :precondition
      (and
        (patient_registered ?patient)
        (consultant_available ?consultant)
        (consultant_compatible ?patient ?consultant)
      )
    :effect
      (and
        (consultant_reserved ?patient ?consultant)
        (not
          (consultant_available ?consultant)
        )
      )
  )
  (:action release_consultant
    :parameters (?patient - patient ?consultant - consultant)
    :precondition
      (and
        (consultant_reserved ?patient ?consultant)
      )
    :effect
      (and
        (consultant_available ?consultant)
        (not
          (consultant_reserved ?patient ?consultant)
        )
      )
  )
  (:action initiate_care_assignment
    :parameters (?patient - patient ?care_area - care_area ?clinician - clinician ?diagnostic_service - diagnostic_service)
    :precondition
      (and
        (triage_in_progress ?patient)
        (clinician_reserved ?patient ?clinician)
        (diagnostic_reserved ?patient ?diagnostic_service)
        (care_area_available ?care_area)
        (care_area_compatible ?patient ?care_area)
        (not
          (in_treatment ?patient)
        )
      )
    :effect
      (and
        (assigned_to_care_area ?patient ?care_area)
        (in_treatment ?patient)
        (not
          (care_area_available ?care_area)
        )
      )
  )
  (:action initiate_care_with_specialty_and_imaging
    :parameters (?patient - patient ?care_area - care_area ?specialty_service - specialty_service ?imaging_equipment - imaging_equipment)
    :precondition
      (and
        (triage_in_progress ?patient)
        (specialty_reserved ?patient ?specialty_service)
        (imaging_available ?imaging_equipment)
        (care_area_available ?care_area)
        (care_area_compatible ?patient ?care_area)
        (imaging_compatible ?patient ?imaging_equipment)
        (not
          (in_treatment ?patient)
        )
      )
    :effect
      (and
        (assigned_to_care_area ?patient ?care_area)
        (in_treatment ?patient)
        (escalation_required ?patient)
        (priority_flag ?patient)
        (not
          (care_area_available ?care_area)
        )
        (not
          (imaging_available ?imaging_equipment)
        )
      )
  )
  (:action clear_escalation_and_priority_flags
    :parameters (?patient - patient ?clinician - clinician ?diagnostic_service - diagnostic_service)
    :precondition
      (and
        (in_treatment ?patient)
        (escalation_required ?patient)
        (clinician_reserved ?patient ?clinician)
        (diagnostic_reserved ?patient ?diagnostic_service)
      )
    :effect
      (and
        (not
          (escalation_required ?patient)
        )
        (not
          (priority_flag ?patient)
        )
      )
  )
  (:action complete_clinical_checks
    :parameters (?patient - patient ?clinician - clinician ?diagnostic_service - diagnostic_service ?monitored_bed - monitored_bed)
    :precondition
      (and
        (ready_for_care_assignment ?patient)
        (in_treatment ?patient)
        (clinician_reserved ?patient ?clinician)
        (diagnostic_reserved ?patient ?diagnostic_service)
        (bed_compatible ?patient ?monitored_bed)
        (not
          (priority_flag ?patient)
        )
        (not
          (safety_checks_completed ?patient)
        )
      )
    :effect
      (and
        (safety_checks_completed ?patient)
      )
  )
  (:action complete_clinical_checks_with_specialty
    :parameters (?patient - patient ?specialty_service - specialty_service ?consultant - consultant ?observation_bed - observation_bed)
    :precondition
      (and
        (ready_for_care_assignment ?patient)
        (in_treatment ?patient)
        (specialty_reserved ?patient ?specialty_service)
        (consultant_reserved ?patient ?consultant)
        (bed_compatible ?patient ?observation_bed)
        (not
          (safety_checks_completed ?patient)
        )
      )
    :effect
      (and
        (safety_checks_completed ?patient)
        (priority_flag ?patient)
      )
  )
  (:action start_disposition_process
    :parameters (?patient - patient ?clinician - clinician ?diagnostic_service - diagnostic_service)
    :precondition
      (and
        (safety_checks_completed ?patient)
        (priority_flag ?patient)
        (clinician_reserved ?patient ?clinician)
        (diagnostic_reserved ?patient ?diagnostic_service)
      )
    :effect
      (and
        (ready_for_bed_assignment ?patient)
        (not
          (priority_flag ?patient)
        )
        (not
          (ready_for_care_assignment ?patient)
        )
        (not
          (escalation_required ?patient)
        )
      )
  )
  (:action prepare_bed_with_porter
    :parameters (?patient - patient ?stretcher - stretcher ?porter - porter)
    :precondition
      (and
        (ready_for_bed_assignment ?patient)
        (safety_checks_completed ?patient)
        (triage_in_progress ?patient)
        (stretcher_assigned ?patient ?stretcher)
        (porter_available ?porter)
        (not
          (ready_for_care_assignment ?patient)
        )
      )
    :effect
      (and
        (ready_for_care_assignment ?patient)
      )
  )
  (:action mark_bed_ready
    :parameters (?patient - patient ?stretcher - stretcher)
    :precondition
      (and
        (safety_checks_completed ?patient)
        (ready_for_care_assignment ?patient)
        (not
          (priority_flag ?patient)
        )
        (stretcher_assigned ?patient ?stretcher)
        (not
          (bed_prepared ?patient)
        )
      )
    :effect
      (and
        (bed_prepared ?patient)
      )
  )
  (:action mark_bed_ready_via_kiosk
    :parameters (?patient - patient ?registration_kiosk - registration_kiosk)
    :precondition
      (and
        (safety_checks_completed ?patient)
        (ready_for_care_assignment ?patient)
        (not
          (priority_flag ?patient)
        )
        (registration_kiosk_available ?registration_kiosk)
        (not
          (bed_prepared ?patient)
        )
      )
    :effect
      (and
        (bed_prepared ?patient)
        (not
          (registration_kiosk_available ?registration_kiosk)
        )
      )
  )
  (:action assign_treatment_room
    :parameters (?patient - patient ?treatment_room - treatment_room)
    :precondition
      (and
        (bed_prepared ?patient)
        (treatment_room_available ?treatment_room)
        (treatment_room_compatible_secondary ?patient ?treatment_room)
      )
    :effect
      (and
        (treatment_room_in_use ?patient ?treatment_room)
        (not
          (treatment_room_available ?treatment_room)
        )
      )
  )
  (:action assign_treatment_room_using_existing_reservation
    :parameters (?pediatric_patient - pediatric_patient ?adult_patient - adult_patient ?treatment_room - treatment_room)
    :precondition
      (and
        (patient_registered ?pediatric_patient)
        (is_pediatric_patient ?pediatric_patient)
        (treatment_room_compatible ?pediatric_patient ?treatment_room)
        (treatment_room_in_use ?adult_patient ?treatment_room)
        (not
          (treatment_room_reserved ?pediatric_patient ?treatment_room)
        )
      )
    :effect
      (and
        (treatment_room_reserved ?pediatric_patient ?treatment_room)
      )
  )
  (:action mark_ready_for_disposition
    :parameters (?patient - patient ?stretcher - stretcher ?porter - porter)
    :precondition
      (and
        (patient_registered ?patient)
        (is_pediatric_patient ?patient)
        (ready_for_care_assignment ?patient)
        (bed_prepared ?patient)
        (stretcher_assigned ?patient ?stretcher)
        (porter_available ?porter)
        (not
          (ready_for_disposition ?patient)
        )
      )
    :effect
      (and
        (ready_for_disposition ?patient)
      )
  )
  (:action finalize_disposition_for_adult
    :parameters (?patient - patient)
    :precondition
      (and
        (is_adult_patient ?patient)
        (patient_registered ?patient)
        (triage_in_progress ?patient)
        (in_treatment ?patient)
        (safety_checks_completed ?patient)
        (bed_prepared ?patient)
        (ready_for_care_assignment ?patient)
        (not
          (disposition_finalized ?patient)
        )
      )
    :effect
      (and
        (disposition_finalized ?patient)
      )
  )
  (:action finalize_disposition_with_room
    :parameters (?patient - patient ?treatment_room - treatment_room)
    :precondition
      (and
        (is_pediatric_patient ?patient)
        (patient_registered ?patient)
        (triage_in_progress ?patient)
        (in_treatment ?patient)
        (safety_checks_completed ?patient)
        (bed_prepared ?patient)
        (ready_for_care_assignment ?patient)
        (treatment_room_reserved ?patient ?treatment_room)
        (not
          (disposition_finalized ?patient)
        )
      )
    :effect
      (and
        (disposition_finalized ?patient)
      )
  )
  (:action finalize_disposition_with_ready_flag
    :parameters (?patient - patient)
    :precondition
      (and
        (is_pediatric_patient ?patient)
        (patient_registered ?patient)
        (triage_in_progress ?patient)
        (in_treatment ?patient)
        (safety_checks_completed ?patient)
        (bed_prepared ?patient)
        (ready_for_care_assignment ?patient)
        (ready_for_disposition ?patient)
        (not
          (disposition_finalized ?patient)
        )
      )
    :effect
      (and
        (disposition_finalized ?patient)
      )
  )
)

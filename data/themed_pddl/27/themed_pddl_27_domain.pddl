(define (domain ed_triage_routing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types patient - entity triage_staff - entity care_area - entity diagnostic_service - entity clinician - entity specialty_service - entity stretcher - entity registration_kiosk - entity treatment_room - entity porter - entity imaging_equipment - entity consultant - entity bed - entity monitored_bed - bed observation_bed - bed adult_patient - patient pediatric_patient - patient)
  (:predicates
    (registration_kiosk_available ?registration_kiosk - registration_kiosk)
    (diagnostic_reserved ?patient - patient ?diagnostic_service - diagnostic_service)
    (ready_for_bed_assignment ?patient - patient)
    (triage_assigned ?patient - patient ?triage_staff - triage_staff)
    (bed_compatible ?patient - patient ?bed - bed)
    (specialty_available ?specialty_service - specialty_service)
    (diagnostic_available ?diagnostic_service - diagnostic_service)
    (consultant_compatible ?patient - patient ?consultant - consultant)
    (disposition_finalized ?patient - patient)
    (is_adult_patient ?patient - patient)
    (triage_staff_compatible ?patient - patient ?triage_staff - triage_staff)
    (care_area_available ?care_area - care_area)
    (imaging_available ?imaging_equipment - imaging_equipment)
    (stretcher_available ?stretcher - stretcher)
    (in_treatment ?patient - patient)
    (diagnostic_compatible ?patient - patient ?diagnostic_service - diagnostic_service)
    (consultant_reserved ?patient - patient ?consultant - consultant)
    (assigned_to_care_area ?patient - patient ?care_area - care_area)
    (safety_checks_completed ?patient - patient)
    (specialty_compatible ?patient - patient ?specialty_service - specialty_service)
    (consultant_available ?consultant - consultant)
    (is_pediatric_patient ?patient - patient)
    (ready_for_care_assignment ?patient - patient)
    (clinician_compatible ?patient - patient ?clinician - clinician)
    (clinician_reserved ?patient - patient ?clinician - clinician)
    (escalation_required ?patient - patient)
    (stretcher_assigned ?patient - patient ?stretcher - stretcher)
    (ready_for_disposition ?patient - patient)
    (imaging_compatible ?patient - patient ?imaging_equipment - imaging_equipment)
    (patient_registered ?patient - patient)
    (triage_staff_available ?triage_staff - triage_staff)
    (triage_in_progress ?patient - patient)
    (porter_available ?porter - porter)
    (treatment_room_available ?treatment_room - treatment_room)
    (specialty_reserved ?patient - patient ?specialty_service - specialty_service)
    (treatment_room_in_use ?patient - patient ?treatment_room - treatment_room)
    (triage_assessment_complete ?patient - patient)
    (bed_prepared ?patient - patient)
    (treatment_room_compatible_secondary ?patient - patient ?treatment_room - treatment_room)
    (clinician_available ?clinician - clinician)
    (treatment_room_compatible ?patient - patient ?treatment_room - treatment_room)
    (care_area_compatible ?patient - patient ?care_area - care_area)
    (priority_flag ?patient - patient)
    (treatment_room_reserved ?patient - patient ?treatment_room - treatment_room)
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
  (:action complete_clinical_checks_with_specialty
    :parameters (?patient - patient ?specialty_service - specialty_service ?consultant - consultant ?observation_bed - observation_bed)
    :precondition
      (and
        (not
          (safety_checks_completed ?patient)
        )
        (in_treatment ?patient)
        (ready_for_care_assignment ?patient)
        (consultant_reserved ?patient ?consultant)
        (bed_compatible ?patient ?observation_bed)
        (specialty_reserved ?patient ?specialty_service)
      )
    :effect
      (and
        (priority_flag ?patient)
        (safety_checks_completed ?patient)
      )
  )
  (:action finalize_disposition_for_adult
    :parameters (?patient - patient)
    :precondition
      (and
        (ready_for_care_assignment ?patient)
        (triage_in_progress ?patient)
        (in_treatment ?patient)
        (patient_registered ?patient)
        (bed_prepared ?patient)
        (not
          (disposition_finalized ?patient)
        )
        (is_adult_patient ?patient)
        (safety_checks_completed ?patient)
      )
    :effect
      (and
        (disposition_finalized ?patient)
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
  (:action allocate_stretcher_to_patient
    :parameters (?patient - patient ?stretcher - stretcher)
    :precondition
      (and
        (stretcher_available ?stretcher)
        (patient_registered ?patient)
      )
    :effect
      (and
        (not
          (stretcher_available ?stretcher)
        )
        (stretcher_assigned ?patient ?stretcher)
      )
  )
  (:action complete_clinical_checks
    :parameters (?patient - patient ?clinician - clinician ?diagnostic_service - diagnostic_service ?monitored_bed - monitored_bed)
    :precondition
      (and
        (bed_compatible ?patient ?monitored_bed)
        (ready_for_care_assignment ?patient)
        (not
          (priority_flag ?patient)
        )
        (clinician_reserved ?patient ?clinician)
        (in_treatment ?patient)
        (diagnostic_reserved ?patient ?diagnostic_service)
        (not
          (safety_checks_completed ?patient)
        )
      )
    :effect
      (and
        (safety_checks_completed ?patient)
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
  (:action reserve_specialty_service
    :parameters (?patient - patient ?specialty_service - specialty_service)
    :precondition
      (and
        (specialty_compatible ?patient ?specialty_service)
        (patient_registered ?patient)
        (specialty_available ?specialty_service)
      )
    :effect
      (and
        (specialty_reserved ?patient ?specialty_service)
        (not
          (specialty_available ?specialty_service)
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
        (not
          (clinician_available ?clinician)
        )
        (clinician_reserved ?patient ?clinician)
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
  (:action initiate_care_assignment
    :parameters (?patient - patient ?care_area - care_area ?clinician - clinician ?diagnostic_service - diagnostic_service)
    :precondition
      (and
        (triage_in_progress ?patient)
        (care_area_available ?care_area)
        (care_area_compatible ?patient ?care_area)
        (not
          (in_treatment ?patient)
        )
        (diagnostic_reserved ?patient ?diagnostic_service)
        (clinician_reserved ?patient ?clinician)
      )
    :effect
      (and
        (assigned_to_care_area ?patient ?care_area)
        (not
          (care_area_available ?care_area)
        )
        (in_treatment ?patient)
      )
  )
  (:action start_disposition_process
    :parameters (?patient - patient ?clinician - clinician ?diagnostic_service - diagnostic_service)
    :precondition
      (and
        (clinician_reserved ?patient ?clinician)
        (safety_checks_completed ?patient)
        (diagnostic_reserved ?patient ?diagnostic_service)
        (priority_flag ?patient)
      )
    :effect
      (and
        (not
          (escalation_required ?patient)
        )
        (not
          (priority_flag ?patient)
        )
        (not
          (ready_for_care_assignment ?patient)
        )
        (ready_for_bed_assignment ?patient)
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
  (:action request_porter
    :parameters (?patient - patient ?stretcher - stretcher ?porter - porter)
    :precondition
      (and
        (not
          (ready_for_care_assignment ?patient)
        )
        (triage_in_progress ?patient)
        (porter_available ?porter)
        (stretcher_assigned ?patient ?stretcher)
        (triage_assessment_complete ?patient)
      )
    :effect
      (and
        (not
          (priority_flag ?patient)
        )
        (ready_for_care_assignment ?patient)
      )
  )
  (:action finalize_disposition_with_ready_flag
    :parameters (?patient - patient)
    :precondition
      (and
        (patient_registered ?patient)
        (is_pediatric_patient ?patient)
        (ready_for_disposition ?patient)
        (triage_in_progress ?patient)
        (ready_for_care_assignment ?patient)
        (not
          (disposition_finalized ?patient)
        )
        (bed_prepared ?patient)
        (in_treatment ?patient)
        (safety_checks_completed ?patient)
      )
    :effect
      (and
        (disposition_finalized ?patient)
      )
  )
  (:action mark_ready_for_disposition
    :parameters (?patient - patient ?stretcher - stretcher ?porter - porter)
    :precondition
      (and
        (ready_for_care_assignment ?patient)
        (porter_available ?porter)
        (not
          (ready_for_disposition ?patient)
        )
        (bed_prepared ?patient)
        (patient_registered ?patient)
        (is_pediatric_patient ?patient)
        (stretcher_assigned ?patient ?stretcher)
      )
    :effect
      (and
        (ready_for_disposition ?patient)
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
  (:action reserve_consultant
    :parameters (?patient - patient ?consultant - consultant)
    :precondition
      (and
        (consultant_available ?consultant)
        (patient_registered ?patient)
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
  (:action mark_triage_assessed_via_kiosk
    :parameters (?patient - patient ?registration_kiosk - registration_kiosk)
    :precondition
      (and
        (not
          (triage_assessment_complete ?patient)
        )
        (patient_registered ?patient)
        (registration_kiosk_available ?registration_kiosk)
        (triage_in_progress ?patient)
      )
    :effect
      (and
        (priority_flag ?patient)
        (not
          (registration_kiosk_available ?registration_kiosk)
        )
        (triage_assessment_complete ?patient)
      )
  )
  (:action initiate_care_with_specialty_and_imaging
    :parameters (?patient - patient ?care_area - care_area ?specialty_service - specialty_service ?imaging_equipment - imaging_equipment)
    :precondition
      (and
        (imaging_available ?imaging_equipment)
        (imaging_compatible ?patient ?imaging_equipment)
        (not
          (in_treatment ?patient)
        )
        (triage_in_progress ?patient)
        (care_area_available ?care_area)
        (care_area_compatible ?patient ?care_area)
        (specialty_reserved ?patient ?specialty_service)
      )
    :effect
      (and
        (assigned_to_care_area ?patient ?care_area)
        (not
          (imaging_available ?imaging_equipment)
        )
        (escalation_required ?patient)
        (not
          (care_area_available ?care_area)
        )
        (priority_flag ?patient)
        (in_treatment ?patient)
      )
  )
  (:action mark_bed_ready_via_kiosk
    :parameters (?patient - patient ?registration_kiosk - registration_kiosk)
    :precondition
      (and
        (registration_kiosk_available ?registration_kiosk)
        (not
          (priority_flag ?patient)
        )
        (ready_for_care_assignment ?patient)
        (safety_checks_completed ?patient)
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
  (:action unassign_triage_staff
    :parameters (?patient - patient ?triage_staff - triage_staff)
    :precondition
      (and
        (triage_assigned ?patient ?triage_staff)
        (not
          (safety_checks_completed ?patient)
        )
        (not
          (in_treatment ?patient)
        )
      )
    :effect
      (and
        (not
          (triage_assigned ?patient ?triage_staff)
        )
        (triage_staff_available ?triage_staff)
        (not
          (triage_in_progress ?patient)
        )
        (not
          (triage_assessment_complete ?patient)
        )
        (not
          (ready_for_bed_assignment ?patient)
        )
        (not
          (ready_for_care_assignment ?patient)
        )
        (not
          (escalation_required ?patient)
        )
        (not
          (priority_flag ?patient)
        )
      )
  )
  (:action mark_bed_ready
    :parameters (?patient - patient ?stretcher - stretcher)
    :precondition
      (and
        (not
          (bed_prepared ?patient)
        )
        (stretcher_assigned ?patient ?stretcher)
        (ready_for_care_assignment ?patient)
        (safety_checks_completed ?patient)
        (not
          (priority_flag ?patient)
        )
      )
    :effect
      (and
        (bed_prepared ?patient)
      )
  )
  (:action finalize_disposition_with_room
    :parameters (?patient - patient ?treatment_room - treatment_room)
    :precondition
      (and
        (bed_prepared ?patient)
        (safety_checks_completed ?patient)
        (in_treatment ?patient)
        (treatment_room_reserved ?patient ?treatment_room)
        (ready_for_care_assignment ?patient)
        (triage_in_progress ?patient)
        (patient_registered ?patient)
        (not
          (disposition_finalized ?patient)
        )
        (is_pediatric_patient ?patient)
      )
    :effect
      (and
        (disposition_finalized ?patient)
      )
  )
  (:action confirm_triage_assessment_with_stretcher
    :parameters (?patient - patient ?stretcher - stretcher)
    :precondition
      (and
        (patient_registered ?patient)
        (triage_in_progress ?patient)
        (not
          (triage_assessment_complete ?patient)
        )
        (stretcher_assigned ?patient ?stretcher)
      )
    :effect
      (and
        (triage_assessment_complete ?patient)
      )
  )
  (:action assign_triage_staff
    :parameters (?patient - patient ?triage_staff - triage_staff)
    :precondition
      (and
        (not
          (triage_in_progress ?patient)
        )
        (patient_registered ?patient)
        (triage_staff_available ?triage_staff)
        (triage_staff_compatible ?patient ?triage_staff)
      )
    :effect
      (and
        (triage_in_progress ?patient)
        (not
          (triage_staff_available ?triage_staff)
        )
        (triage_assigned ?patient ?triage_staff)
      )
  )
  (:action prepare_bed_with_porter
    :parameters (?patient - patient ?stretcher - stretcher ?porter - porter)
    :precondition
      (and
        (triage_in_progress ?patient)
        (not
          (ready_for_care_assignment ?patient)
        )
        (stretcher_assigned ?patient ?stretcher)
        (safety_checks_completed ?patient)
        (porter_available ?porter)
        (ready_for_bed_assignment ?patient)
      )
    :effect
      (and
        (ready_for_care_assignment ?patient)
      )
  )
  (:action assign_treatment_room_using_existing_reservation
    :parameters (?pediatric_patient - pediatric_patient ?adult_patient - adult_patient ?treatment_room - treatment_room)
    :precondition
      (and
        (patient_registered ?pediatric_patient)
        (treatment_room_in_use ?adult_patient ?treatment_room)
        (is_pediatric_patient ?pediatric_patient)
        (not
          (treatment_room_reserved ?pediatric_patient ?treatment_room)
        )
        (treatment_room_compatible ?pediatric_patient ?treatment_room)
      )
    :effect
      (and
        (treatment_room_reserved ?pediatric_patient ?treatment_room)
      )
  )
)

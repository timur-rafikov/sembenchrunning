(define (domain multiclinic_outpatient_slot_allocation)
  (:requirements :strips :typing :negative-preconditions)
  (:types appointment_case - object clinic_slot - object appointment_time_band - object procedure_room - object clinician - object medical_equipment - object telehealth_endpoint - object support_staff - object service_profile - object consent_document - object diagnostic_slot - object lab_resource - object logistics_option - object patient_transport_option - logistics_option visit_mode_option - logistics_option scheduled_followup_case - appointment_case new_patient_case - appointment_case)
  (:predicates
    (case_active ?appointment_case - appointment_case)
    (case_assigned_slot ?appointment_case - appointment_case ?clinic_slot - clinic_slot)
    (case_has_reservation ?appointment_case - appointment_case)
    (case_endpoint_activated ?appointment_case - appointment_case)
    (case_admin_ready ?appointment_case - appointment_case)
    (case_assigned_clinician ?appointment_case - appointment_case ?clinician - clinician)
    (case_assigned_room ?appointment_case - appointment_case ?procedure_room - procedure_room)
    (case_assigned_equipment ?appointment_case - appointment_case ?medical_equipment - medical_equipment)
    (case_assigned_lab_resource ?appointment_case - appointment_case ?lab_resource - lab_resource)
    (case_scheduled_time_band ?appointment_case - appointment_case ?appointment_time_band - appointment_time_band)
    (visit_instance_created ?appointment_case - appointment_case)
    (preparation_verified ?appointment_case - appointment_case)
    (resources_confirmed ?appointment_case - appointment_case)
    (case_confirmed ?appointment_case - appointment_case)
    (support_staff_assigned_flag ?appointment_case - appointment_case)
    (preparation_finalized ?appointment_case - appointment_case)
    (case_service_profile_eligible ?appointment_case - appointment_case ?service_profile - service_profile)
    (case_service_profile_confirmed ?appointment_case - appointment_case ?service_profile - service_profile)
    (documentation_verified ?appointment_case - appointment_case)
    (clinic_slot_available ?clinic_slot - clinic_slot)
    (appointment_time_band_available ?appointment_time_band - appointment_time_band)
    (clinician_available ?clinician - clinician)
    (room_available ?procedure_room - procedure_room)
    (equipment_available ?medical_equipment - medical_equipment)
    (telehealth_endpoint_available ?telehealth_endpoint - telehealth_endpoint)
    (support_staff_available ?support_staff - support_staff)
    (service_profile_available ?service_profile - service_profile)
    (consent_document_available ?consent_document - consent_document)
    (diagnostic_slot_available ?diagnostic_slot - diagnostic_slot)
    (lab_resource_available ?lab_resource - lab_resource)
    (case_slot_eligible ?appointment_case - appointment_case ?clinic_slot - clinic_slot)
    (case_appointment_time_band_eligible ?appointment_case - appointment_case ?appointment_time_band - appointment_time_band)
    (case_clinician_eligible ?appointment_case - appointment_case ?clinician - clinician)
    (case_room_eligible ?appointment_case - appointment_case ?procedure_room - procedure_room)
    (case_equipment_eligible ?appointment_case - appointment_case ?medical_equipment - medical_equipment)
    (case_diagnostic_slot_eligible ?appointment_case - appointment_case ?diagnostic_slot - diagnostic_slot)
    (case_lab_resource_eligible ?appointment_case - appointment_case ?lab_resource - lab_resource)
    (case_logistics_option_eligible ?appointment_case - appointment_case ?patient_transport_option - logistics_option)
    (case_service_profile_assigned ?appointment_case - appointment_case ?service_profile - service_profile)
    (is_followup_case ?appointment_case - appointment_case)
    (is_new_patient_case ?appointment_case - appointment_case)
    (case_endpoint_assigned ?appointment_case - appointment_case ?telehealth_endpoint - telehealth_endpoint)
    (auxiliary_requirement_flag ?appointment_case - appointment_case)
    (case_followup_service_profile_eligible ?appointment_case - appointment_case ?service_profile - service_profile)
  )
  (:action initiate_case
    :parameters (?appointment_case - appointment_case)
    :precondition
      (and
        (not
          (case_active ?appointment_case)
        )
        (not
          (case_confirmed ?appointment_case)
        )
      )
    :effect
      (and
        (case_active ?appointment_case)
      )
  )
  (:action reserve_clinic_slot
    :parameters (?appointment_case - appointment_case ?clinic_slot - clinic_slot)
    :precondition
      (and
        (case_active ?appointment_case)
        (clinic_slot_available ?clinic_slot)
        (case_slot_eligible ?appointment_case ?clinic_slot)
        (not
          (case_has_reservation ?appointment_case)
        )
      )
    :effect
      (and
        (case_assigned_slot ?appointment_case ?clinic_slot)
        (case_has_reservation ?appointment_case)
        (not
          (clinic_slot_available ?clinic_slot)
        )
      )
  )
  (:action release_clinic_reservation
    :parameters (?appointment_case - appointment_case ?clinic_slot - clinic_slot)
    :precondition
      (and
        (case_assigned_slot ?appointment_case ?clinic_slot)
        (not
          (visit_instance_created ?appointment_case)
        )
        (not
          (preparation_verified ?appointment_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned_slot ?appointment_case ?clinic_slot)
        )
        (not
          (case_has_reservation ?appointment_case)
        )
        (not
          (case_endpoint_activated ?appointment_case)
        )
        (not
          (case_admin_ready ?appointment_case)
        )
        (not
          (support_staff_assigned_flag ?appointment_case)
        )
        (not
          (preparation_finalized ?appointment_case)
        )
        (not
          (auxiliary_requirement_flag ?appointment_case)
        )
        (clinic_slot_available ?clinic_slot)
      )
  )
  (:action claim_telehealth_endpoint
    :parameters (?appointment_case - appointment_case ?telehealth_endpoint - telehealth_endpoint)
    :precondition
      (and
        (case_active ?appointment_case)
        (telehealth_endpoint_available ?telehealth_endpoint)
      )
    :effect
      (and
        (case_endpoint_assigned ?appointment_case ?telehealth_endpoint)
        (not
          (telehealth_endpoint_available ?telehealth_endpoint)
        )
      )
  )
  (:action release_telehealth_endpoint
    :parameters (?appointment_case - appointment_case ?telehealth_endpoint - telehealth_endpoint)
    :precondition
      (and
        (case_endpoint_assigned ?appointment_case ?telehealth_endpoint)
      )
    :effect
      (and
        (telehealth_endpoint_available ?telehealth_endpoint)
        (not
          (case_endpoint_assigned ?appointment_case ?telehealth_endpoint)
        )
      )
  )
  (:action activate_endpoint
    :parameters (?appointment_case - appointment_case ?telehealth_endpoint - telehealth_endpoint)
    :precondition
      (and
        (case_active ?appointment_case)
        (case_has_reservation ?appointment_case)
        (case_endpoint_assigned ?appointment_case ?telehealth_endpoint)
        (not
          (case_endpoint_activated ?appointment_case)
        )
      )
    :effect
      (and
        (case_endpoint_activated ?appointment_case)
      )
  )
  (:action assign_support_staff_and_activate_endpoint
    :parameters (?appointment_case - appointment_case ?support_staff - support_staff)
    :precondition
      (and
        (case_active ?appointment_case)
        (case_has_reservation ?appointment_case)
        (support_staff_available ?support_staff)
        (not
          (case_endpoint_activated ?appointment_case)
        )
      )
    :effect
      (and
        (case_endpoint_activated ?appointment_case)
        (support_staff_assigned_flag ?appointment_case)
        (not
          (support_staff_available ?support_staff)
        )
      )
  )
  (:action apply_consent_document
    :parameters (?appointment_case - appointment_case ?telehealth_endpoint - telehealth_endpoint ?consent_document - consent_document)
    :precondition
      (and
        (case_endpoint_activated ?appointment_case)
        (case_has_reservation ?appointment_case)
        (case_endpoint_assigned ?appointment_case ?telehealth_endpoint)
        (consent_document_available ?consent_document)
        (not
          (case_admin_ready ?appointment_case)
        )
      )
    :effect
      (and
        (case_admin_ready ?appointment_case)
        (not
          (support_staff_assigned_flag ?appointment_case)
        )
      )
  )
  (:action apply_service_profile_documentation
    :parameters (?appointment_case - appointment_case ?service_profile - service_profile)
    :precondition
      (and
        (case_has_reservation ?appointment_case)
        (case_service_profile_confirmed ?appointment_case ?service_profile)
        (not
          (case_admin_ready ?appointment_case)
        )
      )
    :effect
      (and
        (case_admin_ready ?appointment_case)
        (not
          (support_staff_assigned_flag ?appointment_case)
        )
      )
  )
  (:action assign_clinician
    :parameters (?appointment_case - appointment_case ?clinician - clinician)
    :precondition
      (and
        (case_active ?appointment_case)
        (clinician_available ?clinician)
        (case_clinician_eligible ?appointment_case ?clinician)
      )
    :effect
      (and
        (case_assigned_clinician ?appointment_case ?clinician)
        (not
          (clinician_available ?clinician)
        )
      )
  )
  (:action release_clinician_assignment
    :parameters (?appointment_case - appointment_case ?clinician - clinician)
    :precondition
      (and
        (case_assigned_clinician ?appointment_case ?clinician)
      )
    :effect
      (and
        (clinician_available ?clinician)
        (not
          (case_assigned_clinician ?appointment_case ?clinician)
        )
      )
  )
  (:action reserve_procedure_room
    :parameters (?appointment_case - appointment_case ?procedure_room - procedure_room)
    :precondition
      (and
        (case_active ?appointment_case)
        (room_available ?procedure_room)
        (case_room_eligible ?appointment_case ?procedure_room)
      )
    :effect
      (and
        (case_assigned_room ?appointment_case ?procedure_room)
        (not
          (room_available ?procedure_room)
        )
      )
  )
  (:action release_procedure_room
    :parameters (?appointment_case - appointment_case ?procedure_room - procedure_room)
    :precondition
      (and
        (case_assigned_room ?appointment_case ?procedure_room)
      )
    :effect
      (and
        (room_available ?procedure_room)
        (not
          (case_assigned_room ?appointment_case ?procedure_room)
        )
      )
  )
  (:action assign_equipment
    :parameters (?appointment_case - appointment_case ?medical_equipment - medical_equipment)
    :precondition
      (and
        (case_active ?appointment_case)
        (equipment_available ?medical_equipment)
        (case_equipment_eligible ?appointment_case ?medical_equipment)
      )
    :effect
      (and
        (case_assigned_equipment ?appointment_case ?medical_equipment)
        (not
          (equipment_available ?medical_equipment)
        )
      )
  )
  (:action release_equipment
    :parameters (?appointment_case - appointment_case ?medical_equipment - medical_equipment)
    :precondition
      (and
        (case_assigned_equipment ?appointment_case ?medical_equipment)
      )
    :effect
      (and
        (equipment_available ?medical_equipment)
        (not
          (case_assigned_equipment ?appointment_case ?medical_equipment)
        )
      )
  )
  (:action assign_lab_resource
    :parameters (?appointment_case - appointment_case ?lab_resource - lab_resource)
    :precondition
      (and
        (case_active ?appointment_case)
        (lab_resource_available ?lab_resource)
        (case_lab_resource_eligible ?appointment_case ?lab_resource)
      )
    :effect
      (and
        (case_assigned_lab_resource ?appointment_case ?lab_resource)
        (not
          (lab_resource_available ?lab_resource)
        )
      )
  )
  (:action release_lab_resource
    :parameters (?appointment_case - appointment_case ?lab_resource - lab_resource)
    :precondition
      (and
        (case_assigned_lab_resource ?appointment_case ?lab_resource)
      )
    :effect
      (and
        (lab_resource_available ?lab_resource)
        (not
          (case_assigned_lab_resource ?appointment_case ?lab_resource)
        )
      )
  )
  (:action create_visit_instance
    :parameters (?appointment_case - appointment_case ?appointment_time_band - appointment_time_band ?clinician - clinician ?procedure_room - procedure_room)
    :precondition
      (and
        (case_has_reservation ?appointment_case)
        (case_assigned_clinician ?appointment_case ?clinician)
        (case_assigned_room ?appointment_case ?procedure_room)
        (appointment_time_band_available ?appointment_time_band)
        (case_appointment_time_band_eligible ?appointment_case ?appointment_time_band)
        (not
          (visit_instance_created ?appointment_case)
        )
      )
    :effect
      (and
        (case_scheduled_time_band ?appointment_case ?appointment_time_band)
        (visit_instance_created ?appointment_case)
        (not
          (appointment_time_band_available ?appointment_time_band)
        )
      )
  )
  (:action create_visit_instance_with_diagnostics
    :parameters (?appointment_case - appointment_case ?appointment_time_band - appointment_time_band ?medical_equipment - medical_equipment ?diagnostic_slot - diagnostic_slot)
    :precondition
      (and
        (case_has_reservation ?appointment_case)
        (case_assigned_equipment ?appointment_case ?medical_equipment)
        (diagnostic_slot_available ?diagnostic_slot)
        (appointment_time_band_available ?appointment_time_band)
        (case_appointment_time_band_eligible ?appointment_case ?appointment_time_band)
        (case_diagnostic_slot_eligible ?appointment_case ?diagnostic_slot)
        (not
          (visit_instance_created ?appointment_case)
        )
      )
    :effect
      (and
        (case_scheduled_time_band ?appointment_case ?appointment_time_band)
        (visit_instance_created ?appointment_case)
        (auxiliary_requirement_flag ?appointment_case)
        (support_staff_assigned_flag ?appointment_case)
        (not
          (appointment_time_band_available ?appointment_time_band)
        )
        (not
          (diagnostic_slot_available ?diagnostic_slot)
        )
      )
  )
  (:action perform_pre_visit_checks
    :parameters (?appointment_case - appointment_case ?clinician - clinician ?procedure_room - procedure_room)
    :precondition
      (and
        (visit_instance_created ?appointment_case)
        (auxiliary_requirement_flag ?appointment_case)
        (case_assigned_clinician ?appointment_case ?clinician)
        (case_assigned_room ?appointment_case ?procedure_room)
      )
    :effect
      (and
        (not
          (auxiliary_requirement_flag ?appointment_case)
        )
        (not
          (support_staff_assigned_flag ?appointment_case)
        )
      )
  )
  (:action finalize_preparation
    :parameters (?appointment_case - appointment_case ?clinician - clinician ?procedure_room - procedure_room ?patient_transport_option - patient_transport_option)
    :precondition
      (and
        (case_admin_ready ?appointment_case)
        (visit_instance_created ?appointment_case)
        (case_assigned_clinician ?appointment_case ?clinician)
        (case_assigned_room ?appointment_case ?procedure_room)
        (case_logistics_option_eligible ?appointment_case ?patient_transport_option)
        (not
          (support_staff_assigned_flag ?appointment_case)
        )
        (not
          (preparation_verified ?appointment_case)
        )
      )
    :effect
      (and
        (preparation_verified ?appointment_case)
      )
  )
  (:action finalize_preparation_with_lab
    :parameters (?appointment_case - appointment_case ?medical_equipment - medical_equipment ?lab_resource - lab_resource ?visit_mode_option - visit_mode_option)
    :precondition
      (and
        (case_admin_ready ?appointment_case)
        (visit_instance_created ?appointment_case)
        (case_assigned_equipment ?appointment_case ?medical_equipment)
        (case_assigned_lab_resource ?appointment_case ?lab_resource)
        (case_logistics_option_eligible ?appointment_case ?visit_mode_option)
        (not
          (preparation_verified ?appointment_case)
        )
      )
    :effect
      (and
        (preparation_verified ?appointment_case)
        (support_staff_assigned_flag ?appointment_case)
      )
  )
  (:action complete_preparation
    :parameters (?appointment_case - appointment_case ?clinician - clinician ?procedure_room - procedure_room)
    :precondition
      (and
        (preparation_verified ?appointment_case)
        (support_staff_assigned_flag ?appointment_case)
        (case_assigned_clinician ?appointment_case ?clinician)
        (case_assigned_room ?appointment_case ?procedure_room)
      )
    :effect
      (and
        (preparation_finalized ?appointment_case)
        (not
          (support_staff_assigned_flag ?appointment_case)
        )
        (not
          (case_admin_ready ?appointment_case)
        )
        (not
          (auxiliary_requirement_flag ?appointment_case)
        )
      )
  )
  (:action reapply_admin_checks
    :parameters (?appointment_case - appointment_case ?telehealth_endpoint - telehealth_endpoint ?consent_document - consent_document)
    :precondition
      (and
        (preparation_finalized ?appointment_case)
        (preparation_verified ?appointment_case)
        (case_has_reservation ?appointment_case)
        (case_endpoint_assigned ?appointment_case ?telehealth_endpoint)
        (consent_document_available ?consent_document)
        (not
          (case_admin_ready ?appointment_case)
        )
      )
    :effect
      (and
        (case_admin_ready ?appointment_case)
      )
  )
  (:action confirm_endpoint_resource
    :parameters (?appointment_case - appointment_case ?telehealth_endpoint - telehealth_endpoint)
    :precondition
      (and
        (preparation_verified ?appointment_case)
        (case_admin_ready ?appointment_case)
        (not
          (support_staff_assigned_flag ?appointment_case)
        )
        (case_endpoint_assigned ?appointment_case ?telehealth_endpoint)
        (not
          (resources_confirmed ?appointment_case)
        )
      )
    :effect
      (and
        (resources_confirmed ?appointment_case)
      )
  )
  (:action confirm_support_staff_assignment
    :parameters (?appointment_case - appointment_case ?support_staff - support_staff)
    :precondition
      (and
        (preparation_verified ?appointment_case)
        (case_admin_ready ?appointment_case)
        (not
          (support_staff_assigned_flag ?appointment_case)
        )
        (support_staff_available ?support_staff)
        (not
          (resources_confirmed ?appointment_case)
        )
      )
    :effect
      (and
        (resources_confirmed ?appointment_case)
        (not
          (support_staff_available ?support_staff)
        )
      )
  )
  (:action confirm_service_profile_assignment
    :parameters (?appointment_case - appointment_case ?service_profile - service_profile)
    :precondition
      (and
        (resources_confirmed ?appointment_case)
        (service_profile_available ?service_profile)
        (case_followup_service_profile_eligible ?appointment_case ?service_profile)
      )
    :effect
      (and
        (case_service_profile_assigned ?appointment_case ?service_profile)
        (not
          (service_profile_available ?service_profile)
        )
      )
  )
  (:action confirm_service_profile_from_followup
    :parameters (?new_patient_case - new_patient_case ?scheduled_followup_case - scheduled_followup_case ?service_profile - service_profile)
    :precondition
      (and
        (case_active ?new_patient_case)
        (is_new_patient_case ?new_patient_case)
        (case_service_profile_eligible ?new_patient_case ?service_profile)
        (case_service_profile_assigned ?scheduled_followup_case ?service_profile)
        (not
          (case_service_profile_confirmed ?new_patient_case ?service_profile)
        )
      )
    :effect
      (and
        (case_service_profile_confirmed ?new_patient_case ?service_profile)
      )
  )
  (:action verify_administrative_documents
    :parameters (?appointment_case - appointment_case ?telehealth_endpoint - telehealth_endpoint ?consent_document - consent_document)
    :precondition
      (and
        (case_active ?appointment_case)
        (is_new_patient_case ?appointment_case)
        (case_admin_ready ?appointment_case)
        (resources_confirmed ?appointment_case)
        (case_endpoint_assigned ?appointment_case ?telehealth_endpoint)
        (consent_document_available ?consent_document)
        (not
          (documentation_verified ?appointment_case)
        )
      )
    :effect
      (and
        (documentation_verified ?appointment_case)
      )
  )
  (:action finalize_case_confirmation_followup
    :parameters (?appointment_case - appointment_case)
    :precondition
      (and
        (is_followup_case ?appointment_case)
        (case_active ?appointment_case)
        (case_has_reservation ?appointment_case)
        (visit_instance_created ?appointment_case)
        (preparation_verified ?appointment_case)
        (resources_confirmed ?appointment_case)
        (case_admin_ready ?appointment_case)
        (not
          (case_confirmed ?appointment_case)
        )
      )
    :effect
      (and
        (case_confirmed ?appointment_case)
      )
  )
  (:action finalize_case_confirmation_with_service_profile
    :parameters (?appointment_case - appointment_case ?service_profile - service_profile)
    :precondition
      (and
        (is_new_patient_case ?appointment_case)
        (case_active ?appointment_case)
        (case_has_reservation ?appointment_case)
        (visit_instance_created ?appointment_case)
        (preparation_verified ?appointment_case)
        (resources_confirmed ?appointment_case)
        (case_admin_ready ?appointment_case)
        (case_service_profile_confirmed ?appointment_case ?service_profile)
        (not
          (case_confirmed ?appointment_case)
        )
      )
    :effect
      (and
        (case_confirmed ?appointment_case)
      )
  )
  (:action finalize_case_confirmation_documented
    :parameters (?appointment_case - appointment_case)
    :precondition
      (and
        (is_new_patient_case ?appointment_case)
        (case_active ?appointment_case)
        (case_has_reservation ?appointment_case)
        (visit_instance_created ?appointment_case)
        (preparation_verified ?appointment_case)
        (resources_confirmed ?appointment_case)
        (case_admin_ready ?appointment_case)
        (documentation_verified ?appointment_case)
        (not
          (case_confirmed ?appointment_case)
        )
      )
    :effect
      (and
        (case_confirmed ?appointment_case)
      )
  )
)

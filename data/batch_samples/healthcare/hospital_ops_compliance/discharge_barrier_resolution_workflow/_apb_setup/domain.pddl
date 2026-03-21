(define (domain discharge_barrier_resolution_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types discharge_case - object care_coordinator - object discharge_destination - object specialty_service - object transport_unit - object home_health_agency - object assistive_equipment - object external_vendor - object clinician - object document_resource - object pharmacy_order - object payer_authorization - object oversight_role_type - object multidisciplinary_reviewer - oversight_role_type authorization_reviewer - oversight_role_type inpatient_record_variant - discharge_case observation_record_variant - discharge_case)
  (:predicates
    (active_case ?discharge_case - discharge_case)
    (coordinator_assigned ?discharge_case - discharge_case ?care_coordinator - care_coordinator)
    (assignment_flag ?discharge_case - discharge_case)
    (service_engaged ?discharge_case - discharge_case)
    (documentation_complete ?discharge_case - discharge_case)
    (transport_allocated ?discharge_case - discharge_case ?transport_unit - transport_unit)
    (specialty_allocated ?discharge_case - discharge_case ?specialty_service - specialty_service)
    (home_health_allocated ?discharge_case - discharge_case ?home_health_agency - home_health_agency)
    (payer_authorization_allocated ?discharge_case - discharge_case ?payer_authorization - payer_authorization)
    (destination_scheduled ?discharge_case - discharge_case ?discharge_destination - discharge_destination)
    (clinical_clearance ?discharge_case - discharge_case)
    (multidisciplinary_signoff ?discharge_case - discharge_case)
    (education_complete ?discharge_case - discharge_case)
    (case_closed ?discharge_case - discharge_case)
    (pending_followup ?discharge_case - discharge_case)
    (ready_for_final_checks ?discharge_case - discharge_case)
    (assigned_clinician ?discharge_case - discharge_case ?clinician_approver - clinician)
    (clinician_approval ?discharge_case - discharge_case ?clinician_approver - clinician)
    (notification_sent ?discharge_case - discharge_case)
    (coordinator_available ?care_coordinator - care_coordinator)
    (destination_available ?discharge_destination - discharge_destination)
    (transport_available ?transport_unit - transport_unit)
    (specialty_available ?specialty_service - specialty_service)
    (home_health_available ?home_health_agency - home_health_agency)
    (equipment_available ?assistive_equipment - assistive_equipment)
    (vendor_available ?external_vendor - external_vendor)
    (clinician_available ?clinician_approver - clinician)
    (document_available ?document_resource - document_resource)
    (pharmacy_order_available ?pharmacy_order - pharmacy_order)
    (payer_authorization_available ?payer_authorization - payer_authorization)
    (coordinator_eligible ?discharge_case - discharge_case ?care_coordinator - care_coordinator)
    (destination_eligible ?discharge_case - discharge_case ?discharge_destination - discharge_destination)
    (transport_eligible ?discharge_case - discharge_case ?transport_unit - transport_unit)
    (specialty_eligible ?discharge_case - discharge_case ?specialty_service - specialty_service)
    (home_health_eligible ?discharge_case - discharge_case ?home_health_agency - home_health_agency)
    (pharmacy_order_linked ?discharge_case - discharge_case ?pharmacy_order - pharmacy_order)
    (payer_authorization_linked ?discharge_case - discharge_case ?payer_authorization - payer_authorization)
    (oversight_assigned ?discharge_case - discharge_case ?oversight_role_type - oversight_role_type)
    (clinician_assigned_to_record ?discharge_case - discharge_case ?clinician_approver - clinician)
    (is_inpatient_record_variant ?discharge_case - discharge_case)
    (is_observation_record_variant ?discharge_case - discharge_case)
    (equipment_allocated ?discharge_case - discharge_case ?assistive_equipment - assistive_equipment)
    (followup_required ?discharge_case - discharge_case)
    (clinician_eligible ?discharge_case - discharge_case ?clinician_approver - clinician)
  )
  (:action open_discharge_case
    :parameters (?discharge_case - discharge_case)
    :precondition
      (and
        (not
          (active_case ?discharge_case)
        )
        (not
          (case_closed ?discharge_case)
        )
      )
    :effect
      (and
        (active_case ?discharge_case)
      )
  )
  (:action assign_care_coordinator
    :parameters (?discharge_case - discharge_case ?care_coordinator - care_coordinator)
    :precondition
      (and
        (active_case ?discharge_case)
        (coordinator_available ?care_coordinator)
        (coordinator_eligible ?discharge_case ?care_coordinator)
        (not
          (assignment_flag ?discharge_case)
        )
      )
    :effect
      (and
        (coordinator_assigned ?discharge_case ?care_coordinator)
        (assignment_flag ?discharge_case)
        (not
          (coordinator_available ?care_coordinator)
        )
      )
  )
  (:action unassign_care_coordinator
    :parameters (?discharge_case - discharge_case ?care_coordinator - care_coordinator)
    :precondition
      (and
        (coordinator_assigned ?discharge_case ?care_coordinator)
        (not
          (clinical_clearance ?discharge_case)
        )
        (not
          (multidisciplinary_signoff ?discharge_case)
        )
      )
    :effect
      (and
        (not
          (coordinator_assigned ?discharge_case ?care_coordinator)
        )
        (not
          (assignment_flag ?discharge_case)
        )
        (not
          (service_engaged ?discharge_case)
        )
        (not
          (documentation_complete ?discharge_case)
        )
        (not
          (pending_followup ?discharge_case)
        )
        (not
          (ready_for_final_checks ?discharge_case)
        )
        (not
          (followup_required ?discharge_case)
        )
        (coordinator_available ?care_coordinator)
      )
  )
  (:action provision_equipment
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment)
    :precondition
      (and
        (active_case ?discharge_case)
        (equipment_available ?assistive_equipment)
      )
    :effect
      (and
        (equipment_allocated ?discharge_case ?assistive_equipment)
        (not
          (equipment_available ?assistive_equipment)
        )
      )
  )
  (:action release_equipment
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment)
    :precondition
      (and
        (equipment_allocated ?discharge_case ?assistive_equipment)
      )
    :effect
      (and
        (equipment_available ?assistive_equipment)
        (not
          (equipment_allocated ?discharge_case ?assistive_equipment)
        )
      )
  )
  (:action confirm_equipment_delivery
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment)
    :precondition
      (and
        (active_case ?discharge_case)
        (assignment_flag ?discharge_case)
        (equipment_allocated ?discharge_case ?assistive_equipment)
        (not
          (service_engaged ?discharge_case)
        )
      )
    :effect
      (and
        (service_engaged ?discharge_case)
      )
  )
  (:action engage_external_vendor
    :parameters (?discharge_case - discharge_case ?external_vendor - external_vendor)
    :precondition
      (and
        (active_case ?discharge_case)
        (assignment_flag ?discharge_case)
        (vendor_available ?external_vendor)
        (not
          (service_engaged ?discharge_case)
        )
      )
    :effect
      (and
        (service_engaged ?discharge_case)
        (pending_followup ?discharge_case)
        (not
          (vendor_available ?external_vendor)
        )
      )
  )
  (:action record_vendor_documentation
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment ?document_resource - document_resource)
    :precondition
      (and
        (service_engaged ?discharge_case)
        (assignment_flag ?discharge_case)
        (equipment_allocated ?discharge_case ?assistive_equipment)
        (document_available ?document_resource)
        (not
          (documentation_complete ?discharge_case)
        )
      )
    :effect
      (and
        (documentation_complete ?discharge_case)
        (not
          (pending_followup ?discharge_case)
        )
      )
  )
  (:action clinician_validate_service
    :parameters (?discharge_case - discharge_case ?clinician_approver - clinician)
    :precondition
      (and
        (assignment_flag ?discharge_case)
        (clinician_approval ?discharge_case ?clinician_approver)
        (not
          (documentation_complete ?discharge_case)
        )
      )
    :effect
      (and
        (documentation_complete ?discharge_case)
        (not
          (pending_followup ?discharge_case)
        )
      )
  )
  (:action reserve_transport
    :parameters (?discharge_case - discharge_case ?transport_unit - transport_unit)
    :precondition
      (and
        (active_case ?discharge_case)
        (transport_available ?transport_unit)
        (transport_eligible ?discharge_case ?transport_unit)
      )
    :effect
      (and
        (transport_allocated ?discharge_case ?transport_unit)
        (not
          (transport_available ?transport_unit)
        )
      )
  )
  (:action release_transport
    :parameters (?discharge_case - discharge_case ?transport_unit - transport_unit)
    :precondition
      (and
        (transport_allocated ?discharge_case ?transport_unit)
      )
    :effect
      (and
        (transport_available ?transport_unit)
        (not
          (transport_allocated ?discharge_case ?transport_unit)
        )
      )
  )
  (:action reserve_specialty_service
    :parameters (?discharge_case - discharge_case ?specialty_service - specialty_service)
    :precondition
      (and
        (active_case ?discharge_case)
        (specialty_available ?specialty_service)
        (specialty_eligible ?discharge_case ?specialty_service)
      )
    :effect
      (and
        (specialty_allocated ?discharge_case ?specialty_service)
        (not
          (specialty_available ?specialty_service)
        )
      )
  )
  (:action release_specialty_service
    :parameters (?discharge_case - discharge_case ?specialty_service - specialty_service)
    :precondition
      (and
        (specialty_allocated ?discharge_case ?specialty_service)
      )
    :effect
      (and
        (specialty_available ?specialty_service)
        (not
          (specialty_allocated ?discharge_case ?specialty_service)
        )
      )
  )
  (:action reserve_home_health
    :parameters (?discharge_case - discharge_case ?home_health_agency - home_health_agency)
    :precondition
      (and
        (active_case ?discharge_case)
        (home_health_available ?home_health_agency)
        (home_health_eligible ?discharge_case ?home_health_agency)
      )
    :effect
      (and
        (home_health_allocated ?discharge_case ?home_health_agency)
        (not
          (home_health_available ?home_health_agency)
        )
      )
  )
  (:action release_home_health
    :parameters (?discharge_case - discharge_case ?home_health_agency - home_health_agency)
    :precondition
      (and
        (home_health_allocated ?discharge_case ?home_health_agency)
      )
    :effect
      (and
        (home_health_available ?home_health_agency)
        (not
          (home_health_allocated ?discharge_case ?home_health_agency)
        )
      )
  )
  (:action request_payer_authorization
    :parameters (?discharge_case - discharge_case ?payer_authorization - payer_authorization)
    :precondition
      (and
        (active_case ?discharge_case)
        (payer_authorization_available ?payer_authorization)
        (payer_authorization_linked ?discharge_case ?payer_authorization)
      )
    :effect
      (and
        (payer_authorization_allocated ?discharge_case ?payer_authorization)
        (not
          (payer_authorization_available ?payer_authorization)
        )
      )
  )
  (:action release_payer_authorization
    :parameters (?discharge_case - discharge_case ?payer_authorization - payer_authorization)
    :precondition
      (and
        (payer_authorization_allocated ?discharge_case ?payer_authorization)
      )
    :effect
      (and
        (payer_authorization_available ?payer_authorization)
        (not
          (payer_authorization_allocated ?discharge_case ?payer_authorization)
        )
      )
  )
  (:action obtain_clinical_clearance_and_schedule
    :parameters (?discharge_case - discharge_case ?discharge_destination - discharge_destination ?transport_unit - transport_unit ?specialty_service - specialty_service)
    :precondition
      (and
        (assignment_flag ?discharge_case)
        (transport_allocated ?discharge_case ?transport_unit)
        (specialty_allocated ?discharge_case ?specialty_service)
        (destination_available ?discharge_destination)
        (destination_eligible ?discharge_case ?discharge_destination)
        (not
          (clinical_clearance ?discharge_case)
        )
      )
    :effect
      (and
        (destination_scheduled ?discharge_case ?discharge_destination)
        (clinical_clearance ?discharge_case)
        (not
          (destination_available ?discharge_destination)
        )
      )
  )
  (:action engage_specialty_and_pharmacy
    :parameters (?discharge_case - discharge_case ?discharge_destination - discharge_destination ?home_health_agency - home_health_agency ?pharmacy_order - pharmacy_order)
    :precondition
      (and
        (assignment_flag ?discharge_case)
        (home_health_allocated ?discharge_case ?home_health_agency)
        (pharmacy_order_available ?pharmacy_order)
        (destination_available ?discharge_destination)
        (destination_eligible ?discharge_case ?discharge_destination)
        (pharmacy_order_linked ?discharge_case ?pharmacy_order)
        (not
          (clinical_clearance ?discharge_case)
        )
      )
    :effect
      (and
        (destination_scheduled ?discharge_case ?discharge_destination)
        (clinical_clearance ?discharge_case)
        (followup_required ?discharge_case)
        (pending_followup ?discharge_case)
        (not
          (destination_available ?discharge_destination)
        )
        (not
          (pharmacy_order_available ?pharmacy_order)
        )
      )
  )
  (:action finalize_destination_placement_checks
    :parameters (?discharge_case - discharge_case ?transport_unit - transport_unit ?specialty_service - specialty_service)
    :precondition
      (and
        (clinical_clearance ?discharge_case)
        (followup_required ?discharge_case)
        (transport_allocated ?discharge_case ?transport_unit)
        (specialty_allocated ?discharge_case ?specialty_service)
      )
    :effect
      (and
        (not
          (followup_required ?discharge_case)
        )
        (not
          (pending_followup ?discharge_case)
        )
      )
  )
  (:action execute_multidisciplinary_signoff_multidisciplinary_reviewer
    :parameters (?discharge_case - discharge_case ?transport_unit - transport_unit ?specialty_service - specialty_service ?care_team_member_typea - multidisciplinary_reviewer)
    :precondition
      (and
        (documentation_complete ?discharge_case)
        (clinical_clearance ?discharge_case)
        (transport_allocated ?discharge_case ?transport_unit)
        (specialty_allocated ?discharge_case ?specialty_service)
        (oversight_assigned ?discharge_case ?care_team_member_typea)
        (not
          (pending_followup ?discharge_case)
        )
        (not
          (multidisciplinary_signoff ?discharge_case)
        )
      )
    :effect
      (and
        (multidisciplinary_signoff ?discharge_case)
      )
  )
  (:action execute_multidisciplinary_signoff_authorization_reviewer
    :parameters (?discharge_case - discharge_case ?home_health_agency - home_health_agency ?payer_authorization - payer_authorization ?care_team_member_typeb - authorization_reviewer)
    :precondition
      (and
        (documentation_complete ?discharge_case)
        (clinical_clearance ?discharge_case)
        (home_health_allocated ?discharge_case ?home_health_agency)
        (payer_authorization_allocated ?discharge_case ?payer_authorization)
        (oversight_assigned ?discharge_case ?care_team_member_typeb)
        (not
          (multidisciplinary_signoff ?discharge_case)
        )
      )
    :effect
      (and
        (multidisciplinary_signoff ?discharge_case)
        (pending_followup ?discharge_case)
      )
  )
  (:action complete_multidisciplinary_signoff
    :parameters (?discharge_case - discharge_case ?transport_unit - transport_unit ?specialty_service - specialty_service)
    :precondition
      (and
        (multidisciplinary_signoff ?discharge_case)
        (pending_followup ?discharge_case)
        (transport_allocated ?discharge_case ?transport_unit)
        (specialty_allocated ?discharge_case ?specialty_service)
      )
    :effect
      (and
        (ready_for_final_checks ?discharge_case)
        (not
          (pending_followup ?discharge_case)
        )
        (not
          (documentation_complete ?discharge_case)
        )
        (not
          (followup_required ?discharge_case)
        )
      )
  )
  (:action revalidate_equipment_after_signoff
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment ?document_resource - document_resource)
    :precondition
      (and
        (ready_for_final_checks ?discharge_case)
        (multidisciplinary_signoff ?discharge_case)
        (assignment_flag ?discharge_case)
        (equipment_allocated ?discharge_case ?assistive_equipment)
        (document_available ?document_resource)
        (not
          (documentation_complete ?discharge_case)
        )
      )
    :effect
      (and
        (documentation_complete ?discharge_case)
      )
  )
  (:action record_patient_education
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment)
    :precondition
      (and
        (multidisciplinary_signoff ?discharge_case)
        (documentation_complete ?discharge_case)
        (not
          (pending_followup ?discharge_case)
        )
        (equipment_allocated ?discharge_case ?assistive_equipment)
        (not
          (education_complete ?discharge_case)
        )
      )
    :effect
      (and
        (education_complete ?discharge_case)
      )
  )
  (:action record_vendor_education
    :parameters (?discharge_case - discharge_case ?external_vendor - external_vendor)
    :precondition
      (and
        (multidisciplinary_signoff ?discharge_case)
        (documentation_complete ?discharge_case)
        (not
          (pending_followup ?discharge_case)
        )
        (vendor_available ?external_vendor)
        (not
          (education_complete ?discharge_case)
        )
      )
    :effect
      (and
        (education_complete ?discharge_case)
        (not
          (vendor_available ?external_vendor)
        )
      )
  )
  (:action request_final_transport_approval
    :parameters (?discharge_case - discharge_case ?clinician_approver - clinician)
    :precondition
      (and
        (education_complete ?discharge_case)
        (clinician_available ?clinician_approver)
        (clinician_eligible ?discharge_case ?clinician_approver)
      )
    :effect
      (and
        (clinician_assigned_to_record ?discharge_case ?clinician_approver)
        (not
          (clinician_available ?clinician_approver)
        )
      )
  )
  (:action provision_clinician_approval_for_transfer
    :parameters (?observation_record_variant - observation_record_variant ?inpatient_record_variant - inpatient_record_variant ?clinician_approver - clinician)
    :precondition
      (and
        (active_case ?observation_record_variant)
        (is_observation_record_variant ?observation_record_variant)
        (assigned_clinician ?observation_record_variant ?clinician_approver)
        (clinician_assigned_to_record ?inpatient_record_variant ?clinician_approver)
        (not
          (clinician_approval ?observation_record_variant ?clinician_approver)
        )
      )
    :effect
      (and
        (clinician_approval ?observation_record_variant ?clinician_approver)
      )
  )
  (:action record_discharge_notification
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment ?document_resource - document_resource)
    :precondition
      (and
        (active_case ?discharge_case)
        (is_observation_record_variant ?discharge_case)
        (documentation_complete ?discharge_case)
        (education_complete ?discharge_case)
        (equipment_allocated ?discharge_case ?assistive_equipment)
        (document_available ?document_resource)
        (not
          (notification_sent ?discharge_case)
        )
      )
    :effect
      (and
        (notification_sent ?discharge_case)
      )
  )
  (:action close_case_final_checks_inpatient
    :parameters (?discharge_case - discharge_case)
    :precondition
      (and
        (is_inpatient_record_variant ?discharge_case)
        (active_case ?discharge_case)
        (assignment_flag ?discharge_case)
        (clinical_clearance ?discharge_case)
        (multidisciplinary_signoff ?discharge_case)
        (education_complete ?discharge_case)
        (documentation_complete ?discharge_case)
        (not
          (case_closed ?discharge_case)
        )
      )
    :effect
      (and
        (case_closed ?discharge_case)
      )
  )
  (:action close_case_final_checks_with_approver
    :parameters (?discharge_case - discharge_case ?clinician_approver - clinician)
    :precondition
      (and
        (is_observation_record_variant ?discharge_case)
        (active_case ?discharge_case)
        (assignment_flag ?discharge_case)
        (clinical_clearance ?discharge_case)
        (multidisciplinary_signoff ?discharge_case)
        (education_complete ?discharge_case)
        (documentation_complete ?discharge_case)
        (clinician_approval ?discharge_case ?clinician_approver)
        (not
          (case_closed ?discharge_case)
        )
      )
    :effect
      (and
        (case_closed ?discharge_case)
      )
  )
  (:action close_case_final_checks_observation
    :parameters (?discharge_case - discharge_case)
    :precondition
      (and
        (is_observation_record_variant ?discharge_case)
        (active_case ?discharge_case)
        (assignment_flag ?discharge_case)
        (clinical_clearance ?discharge_case)
        (multidisciplinary_signoff ?discharge_case)
        (education_complete ?discharge_case)
        (documentation_complete ?discharge_case)
        (notification_sent ?discharge_case)
        (not
          (case_closed ?discharge_case)
        )
      )
    :effect
      (and
        (case_closed ?discharge_case)
      )
  )
)

(define (domain discharge_barrier_resolution_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types discharge_case - object care_coordinator - object discharge_destination - object specialty_service - object transport_unit - object home_health_agency - object assistive_equipment - object external_vendor - object clinician - object document_resource - object pharmacy_order - object payer_authorization - object oversight_role_type - object multidisciplinary_reviewer - oversight_role_type authorization_reviewer - oversight_role_type inpatient_record_variant - discharge_case observation_record_variant - discharge_case)
  (:predicates
    (vendor_available ?external_vendor - external_vendor)
    (specialty_allocated ?discharge_case - discharge_case ?specialty_service - specialty_service)
    (ready_for_final_checks ?discharge_case - discharge_case)
    (coordinator_assigned ?discharge_case - discharge_case ?care_coordinator - care_coordinator)
    (oversight_assigned ?discharge_case - discharge_case ?oversight_role_type - oversight_role_type)
    (home_health_available ?home_health_agency - home_health_agency)
    (specialty_available ?specialty_service - specialty_service)
    (payer_authorization_linked ?discharge_case - discharge_case ?payer_authorization - payer_authorization)
    (case_closed ?discharge_case - discharge_case)
    (is_inpatient_record_variant ?discharge_case - discharge_case)
    (coordinator_eligible ?discharge_case - discharge_case ?care_coordinator - care_coordinator)
    (destination_available ?discharge_destination - discharge_destination)
    (pharmacy_order_available ?pharmacy_order - pharmacy_order)
    (equipment_available ?assistive_equipment - assistive_equipment)
    (clinical_clearance ?discharge_case - discharge_case)
    (specialty_eligible ?discharge_case - discharge_case ?specialty_service - specialty_service)
    (payer_authorization_allocated ?discharge_case - discharge_case ?payer_authorization - payer_authorization)
    (destination_scheduled ?discharge_case - discharge_case ?discharge_destination - discharge_destination)
    (multidisciplinary_signoff ?discharge_case - discharge_case)
    (home_health_eligible ?discharge_case - discharge_case ?home_health_agency - home_health_agency)
    (payer_authorization_available ?payer_authorization - payer_authorization)
    (is_observation_record_variant ?discharge_case - discharge_case)
    (documentation_complete ?discharge_case - discharge_case)
    (transport_eligible ?discharge_case - discharge_case ?transport_unit - transport_unit)
    (transport_allocated ?discharge_case - discharge_case ?transport_unit - transport_unit)
    (followup_required ?discharge_case - discharge_case)
    (equipment_allocated ?discharge_case - discharge_case ?assistive_equipment - assistive_equipment)
    (notification_sent ?discharge_case - discharge_case)
    (pharmacy_order_linked ?discharge_case - discharge_case ?pharmacy_order - pharmacy_order)
    (active_case ?discharge_case - discharge_case)
    (coordinator_available ?care_coordinator - care_coordinator)
    (assignment_flag ?discharge_case - discharge_case)
    (document_available ?document_resource - document_resource)
    (clinician_available ?clinician_approver - clinician)
    (home_health_allocated ?discharge_case - discharge_case ?home_health_agency - home_health_agency)
    (clinician_assigned_to_record ?discharge_case - discharge_case ?clinician_approver - clinician)
    (service_engaged ?discharge_case - discharge_case)
    (education_complete ?discharge_case - discharge_case)
    (clinician_eligible ?discharge_case - discharge_case ?clinician_approver - clinician)
    (transport_available ?transport_unit - transport_unit)
    (assigned_clinician ?discharge_case - discharge_case ?clinician_approver - clinician)
    (destination_eligible ?discharge_case - discharge_case ?discharge_destination - discharge_destination)
    (pending_followup ?discharge_case - discharge_case)
    (clinician_approval ?discharge_case - discharge_case ?clinician_approver - clinician)
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
  (:action execute_multidisciplinary_signoff_authorization_reviewer
    :parameters (?discharge_case - discharge_case ?home_health_agency - home_health_agency ?payer_authorization - payer_authorization ?care_team_member_typeb - authorization_reviewer)
    :precondition
      (and
        (not
          (multidisciplinary_signoff ?discharge_case)
        )
        (clinical_clearance ?discharge_case)
        (documentation_complete ?discharge_case)
        (payer_authorization_allocated ?discharge_case ?payer_authorization)
        (oversight_assigned ?discharge_case ?care_team_member_typeb)
        (home_health_allocated ?discharge_case ?home_health_agency)
      )
    :effect
      (and
        (pending_followup ?discharge_case)
        (multidisciplinary_signoff ?discharge_case)
      )
  )
  (:action close_case_final_checks_inpatient
    :parameters (?discharge_case - discharge_case)
    :precondition
      (and
        (documentation_complete ?discharge_case)
        (assignment_flag ?discharge_case)
        (clinical_clearance ?discharge_case)
        (active_case ?discharge_case)
        (education_complete ?discharge_case)
        (not
          (case_closed ?discharge_case)
        )
        (is_inpatient_record_variant ?discharge_case)
        (multidisciplinary_signoff ?discharge_case)
      )
    :effect
      (and
        (case_closed ?discharge_case)
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
  (:action provision_equipment
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment)
    :precondition
      (and
        (equipment_available ?assistive_equipment)
        (active_case ?discharge_case)
      )
    :effect
      (and
        (not
          (equipment_available ?assistive_equipment)
        )
        (equipment_allocated ?discharge_case ?assistive_equipment)
      )
  )
  (:action execute_multidisciplinary_signoff_multidisciplinary_reviewer
    :parameters (?discharge_case - discharge_case ?transport_unit - transport_unit ?specialty_service - specialty_service ?care_team_member_typea - multidisciplinary_reviewer)
    :precondition
      (and
        (oversight_assigned ?discharge_case ?care_team_member_typea)
        (documentation_complete ?discharge_case)
        (not
          (pending_followup ?discharge_case)
        )
        (transport_allocated ?discharge_case ?transport_unit)
        (clinical_clearance ?discharge_case)
        (specialty_allocated ?discharge_case ?specialty_service)
        (not
          (multidisciplinary_signoff ?discharge_case)
        )
      )
    :effect
      (and
        (multidisciplinary_signoff ?discharge_case)
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
  (:action reserve_home_health
    :parameters (?discharge_case - discharge_case ?home_health_agency - home_health_agency)
    :precondition
      (and
        (home_health_eligible ?discharge_case ?home_health_agency)
        (active_case ?discharge_case)
        (home_health_available ?home_health_agency)
      )
    :effect
      (and
        (home_health_allocated ?discharge_case ?home_health_agency)
        (not
          (home_health_available ?home_health_agency)
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
        (not
          (transport_available ?transport_unit)
        )
        (transport_allocated ?discharge_case ?transport_unit)
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
  (:action obtain_clinical_clearance_and_schedule
    :parameters (?discharge_case - discharge_case ?discharge_destination - discharge_destination ?transport_unit - transport_unit ?specialty_service - specialty_service)
    :precondition
      (and
        (assignment_flag ?discharge_case)
        (destination_available ?discharge_destination)
        (destination_eligible ?discharge_case ?discharge_destination)
        (not
          (clinical_clearance ?discharge_case)
        )
        (specialty_allocated ?discharge_case ?specialty_service)
        (transport_allocated ?discharge_case ?transport_unit)
      )
    :effect
      (and
        (destination_scheduled ?discharge_case ?discharge_destination)
        (not
          (destination_available ?discharge_destination)
        )
        (clinical_clearance ?discharge_case)
      )
  )
  (:action complete_multidisciplinary_signoff
    :parameters (?discharge_case - discharge_case ?transport_unit - transport_unit ?specialty_service - specialty_service)
    :precondition
      (and
        (transport_allocated ?discharge_case ?transport_unit)
        (multidisciplinary_signoff ?discharge_case)
        (specialty_allocated ?discharge_case ?specialty_service)
        (pending_followup ?discharge_case)
      )
    :effect
      (and
        (not
          (followup_required ?discharge_case)
        )
        (not
          (pending_followup ?discharge_case)
        )
        (not
          (documentation_complete ?discharge_case)
        )
        (ready_for_final_checks ?discharge_case)
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
  (:action record_vendor_documentation
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment ?document_resource - document_resource)
    :precondition
      (and
        (not
          (documentation_complete ?discharge_case)
        )
        (assignment_flag ?discharge_case)
        (document_available ?document_resource)
        (equipment_allocated ?discharge_case ?assistive_equipment)
        (service_engaged ?discharge_case)
      )
    :effect
      (and
        (not
          (pending_followup ?discharge_case)
        )
        (documentation_complete ?discharge_case)
      )
  )
  (:action close_case_final_checks_observation
    :parameters (?discharge_case - discharge_case)
    :precondition
      (and
        (active_case ?discharge_case)
        (is_observation_record_variant ?discharge_case)
        (notification_sent ?discharge_case)
        (assignment_flag ?discharge_case)
        (documentation_complete ?discharge_case)
        (not
          (case_closed ?discharge_case)
        )
        (education_complete ?discharge_case)
        (clinical_clearance ?discharge_case)
        (multidisciplinary_signoff ?discharge_case)
      )
    :effect
      (and
        (case_closed ?discharge_case)
      )
  )
  (:action record_discharge_notification
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment ?document_resource - document_resource)
    :precondition
      (and
        (documentation_complete ?discharge_case)
        (document_available ?document_resource)
        (not
          (notification_sent ?discharge_case)
        )
        (education_complete ?discharge_case)
        (active_case ?discharge_case)
        (is_observation_record_variant ?discharge_case)
        (equipment_allocated ?discharge_case ?assistive_equipment)
      )
    :effect
      (and
        (notification_sent ?discharge_case)
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
  (:action request_payer_authorization
    :parameters (?discharge_case - discharge_case ?payer_authorization - payer_authorization)
    :precondition
      (and
        (payer_authorization_available ?payer_authorization)
        (active_case ?discharge_case)
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
  (:action engage_external_vendor
    :parameters (?discharge_case - discharge_case ?external_vendor - external_vendor)
    :precondition
      (and
        (not
          (service_engaged ?discharge_case)
        )
        (active_case ?discharge_case)
        (vendor_available ?external_vendor)
        (assignment_flag ?discharge_case)
      )
    :effect
      (and
        (pending_followup ?discharge_case)
        (not
          (vendor_available ?external_vendor)
        )
        (service_engaged ?discharge_case)
      )
  )
  (:action engage_specialty_and_pharmacy
    :parameters (?discharge_case - discharge_case ?discharge_destination - discharge_destination ?home_health_agency - home_health_agency ?pharmacy_order - pharmacy_order)
    :precondition
      (and
        (pharmacy_order_available ?pharmacy_order)
        (pharmacy_order_linked ?discharge_case ?pharmacy_order)
        (not
          (clinical_clearance ?discharge_case)
        )
        (assignment_flag ?discharge_case)
        (destination_available ?discharge_destination)
        (destination_eligible ?discharge_case ?discharge_destination)
        (home_health_allocated ?discharge_case ?home_health_agency)
      )
    :effect
      (and
        (destination_scheduled ?discharge_case ?discharge_destination)
        (not
          (pharmacy_order_available ?pharmacy_order)
        )
        (followup_required ?discharge_case)
        (not
          (destination_available ?discharge_destination)
        )
        (pending_followup ?discharge_case)
        (clinical_clearance ?discharge_case)
      )
  )
  (:action record_vendor_education
    :parameters (?discharge_case - discharge_case ?external_vendor - external_vendor)
    :precondition
      (and
        (vendor_available ?external_vendor)
        (not
          (pending_followup ?discharge_case)
        )
        (documentation_complete ?discharge_case)
        (multidisciplinary_signoff ?discharge_case)
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
  (:action unassign_care_coordinator
    :parameters (?discharge_case - discharge_case ?care_coordinator - care_coordinator)
    :precondition
      (and
        (coordinator_assigned ?discharge_case ?care_coordinator)
        (not
          (multidisciplinary_signoff ?discharge_case)
        )
        (not
          (clinical_clearance ?discharge_case)
        )
      )
    :effect
      (and
        (not
          (coordinator_assigned ?discharge_case ?care_coordinator)
        )
        (coordinator_available ?care_coordinator)
        (not
          (assignment_flag ?discharge_case)
        )
        (not
          (service_engaged ?discharge_case)
        )
        (not
          (ready_for_final_checks ?discharge_case)
        )
        (not
          (documentation_complete ?discharge_case)
        )
        (not
          (followup_required ?discharge_case)
        )
        (not
          (pending_followup ?discharge_case)
        )
      )
  )
  (:action record_patient_education
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment)
    :precondition
      (and
        (not
          (education_complete ?discharge_case)
        )
        (equipment_allocated ?discharge_case ?assistive_equipment)
        (documentation_complete ?discharge_case)
        (multidisciplinary_signoff ?discharge_case)
        (not
          (pending_followup ?discharge_case)
        )
      )
    :effect
      (and
        (education_complete ?discharge_case)
      )
  )
  (:action close_case_final_checks_with_approver
    :parameters (?discharge_case - discharge_case ?clinician_approver - clinician)
    :precondition
      (and
        (education_complete ?discharge_case)
        (multidisciplinary_signoff ?discharge_case)
        (clinical_clearance ?discharge_case)
        (clinician_approval ?discharge_case ?clinician_approver)
        (documentation_complete ?discharge_case)
        (assignment_flag ?discharge_case)
        (active_case ?discharge_case)
        (not
          (case_closed ?discharge_case)
        )
        (is_observation_record_variant ?discharge_case)
      )
    :effect
      (and
        (case_closed ?discharge_case)
      )
  )
  (:action confirm_equipment_delivery
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment)
    :precondition
      (and
        (active_case ?discharge_case)
        (assignment_flag ?discharge_case)
        (not
          (service_engaged ?discharge_case)
        )
        (equipment_allocated ?discharge_case ?assistive_equipment)
      )
    :effect
      (and
        (service_engaged ?discharge_case)
      )
  )
  (:action assign_care_coordinator
    :parameters (?discharge_case - discharge_case ?care_coordinator - care_coordinator)
    :precondition
      (and
        (not
          (assignment_flag ?discharge_case)
        )
        (active_case ?discharge_case)
        (coordinator_available ?care_coordinator)
        (coordinator_eligible ?discharge_case ?care_coordinator)
      )
    :effect
      (and
        (assignment_flag ?discharge_case)
        (not
          (coordinator_available ?care_coordinator)
        )
        (coordinator_assigned ?discharge_case ?care_coordinator)
      )
  )
  (:action revalidate_equipment_after_signoff
    :parameters (?discharge_case - discharge_case ?assistive_equipment - assistive_equipment ?document_resource - document_resource)
    :precondition
      (and
        (assignment_flag ?discharge_case)
        (not
          (documentation_complete ?discharge_case)
        )
        (equipment_allocated ?discharge_case ?assistive_equipment)
        (multidisciplinary_signoff ?discharge_case)
        (document_available ?document_resource)
        (ready_for_final_checks ?discharge_case)
      )
    :effect
      (and
        (documentation_complete ?discharge_case)
      )
  )
  (:action provision_clinician_approval_for_transfer
    :parameters (?observation_record_variant - observation_record_variant ?inpatient_record_variant - inpatient_record_variant ?clinician_approver - clinician)
    :precondition
      (and
        (active_case ?observation_record_variant)
        (clinician_assigned_to_record ?inpatient_record_variant ?clinician_approver)
        (is_observation_record_variant ?observation_record_variant)
        (not
          (clinician_approval ?observation_record_variant ?clinician_approver)
        )
        (assigned_clinician ?observation_record_variant ?clinician_approver)
      )
    :effect
      (and
        (clinician_approval ?observation_record_variant ?clinician_approver)
      )
  )
)

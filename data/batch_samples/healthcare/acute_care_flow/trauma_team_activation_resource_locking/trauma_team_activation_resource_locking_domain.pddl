(define (domain trauma_team_activation_locking_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types trauma_activation - object treatment_bay - object clinical_role - object monitoring_device - object bedside_nurse - object respiratory_therapist - object bedside_monitor_unit - object notification_device - object imaging_resource - object equipment_technician - object blood_product_unit - object supply_cart - object staff_role_token - object procedural_provider_role - staff_role_token anesthetist_role - staff_role_token external_activation_reference - trauma_activation local_activation_reference - trauma_activation)
  (:predicates
    (activation_active ?activation_instance - trauma_activation)
    (activation_reserved_bay ?activation_instance - trauma_activation ?resource - treatment_bay)
    (activation_resources_locked ?activation_instance - trauma_activation)
    (activation_monitor_assigned ?activation_instance - trauma_activation)
    (activation_equipment_ready ?activation_instance - trauma_activation)
    (activation_reserved_bedside_nurse ?activation_instance - trauma_activation ?resource - bedside_nurse)
    (activation_reserved_monitoring_device ?activation_instance - trauma_activation ?resource - monitoring_device)
    (activation_reserved_respiratory_therapist ?activation_instance - trauma_activation ?resource - respiratory_therapist)
    (activation_reserved_supply_cart ?activation_instance - trauma_activation ?resource - supply_cart)
    (activation_assigned_clinical_role ?activation_instance - trauma_activation ?resource - clinical_role)
    (team_brief_complete ?activation_instance - trauma_activation)
    (procedural_provider_confirmed ?activation_instance - trauma_activation)
    (activation_notification_acknowledged ?activation_instance - trauma_activation)
    (activation_finalized ?activation_instance - trauma_activation)
    (activation_personnel_notified ?activation_instance - trauma_activation)
    (activation_procedure_scheduled ?activation_instance - trauma_activation)
    (activation_imaging_requested ?activation_instance - trauma_activation ?resource - imaging_resource)
    (activation_imaging_confirmed ?activation_instance - trauma_activation ?resource - imaging_resource)
    (equipment_technician_confirmed ?activation_instance - trauma_activation)
    (bay_available ?activation_instance - treatment_bay)
    (clinical_role_available ?activation_instance - clinical_role)
    (bedside_nurse_available ?activation_instance - bedside_nurse)
    (monitoring_device_available ?activation_instance - monitoring_device)
    (respiratory_therapist_available ?activation_instance - respiratory_therapist)
    (bedside_monitor_unit_available ?activation_instance - bedside_monitor_unit)
    (notification_device_available ?activation_instance - notification_device)
    (imaging_resource_available ?activation_instance - imaging_resource)
    (equipment_technician_available ?activation_instance - equipment_technician)
    (blood_product_available ?activation_instance - blood_product_unit)
    (supply_cart_available ?activation_instance - supply_cart)
    (bay_compatible_for_activation ?activation_instance - trauma_activation ?resource - treatment_bay)
    (clinical_role_required_for_activation ?activation_instance - trauma_activation ?resource - clinical_role)
    (bedside_nurse_eligible_for_activation ?activation_instance - trauma_activation ?resource - bedside_nurse)
    (monitoring_device_compatible_for_activation ?activation_instance - trauma_activation ?resource - monitoring_device)
    (respiratory_therapist_eligible_for_activation ?activation_instance - trauma_activation ?resource - respiratory_therapist)
    (blood_product_compatible_for_activation ?activation_instance - trauma_activation ?resource - blood_product_unit)
    (supply_cart_compatible_for_activation ?activation_instance - trauma_activation ?resource - supply_cart)
    (activation_associated_staff_role ?activation_instance - trauma_activation ?resource - staff_role_token)
    (external_activation_imaging_link ?activation_instance - trauma_activation ?resource - imaging_resource)
    (activation_local_coordinator_present ?activation_instance - trauma_activation)
    (activation_remote_coordinator_present ?activation_instance - trauma_activation)
    (activation_assigned_bedside_monitor_unit ?activation_instance - trauma_activation ?resource - bedside_monitor_unit)
    (activation_blood_requested ?activation_instance - trauma_activation)
    (activation_imaging_authorization ?activation_instance - trauma_activation ?resource - imaging_resource)
  )
  (:action register_activation
    :parameters (?activation_instance - trauma_activation)
    :precondition
      (and
        (not
          (activation_active ?activation_instance)
        )
        (not
          (activation_finalized ?activation_instance)
        )
      )
    :effect
      (and
        (activation_active ?activation_instance)
      )
  )
  (:action reserve_treatment_bay
    :parameters (?activation_instance - trauma_activation ?resource - treatment_bay)
    :precondition
      (and
        (activation_active ?activation_instance)
        (bay_available ?resource)
        (bay_compatible_for_activation ?activation_instance ?resource)
        (not
          (activation_resources_locked ?activation_instance)
        )
      )
    :effect
      (and
        (activation_reserved_bay ?activation_instance ?resource)
        (activation_resources_locked ?activation_instance)
        (not
          (bay_available ?resource)
        )
      )
  )
  (:action release_treatment_bay
    :parameters (?activation_instance - trauma_activation ?resource - treatment_bay)
    :precondition
      (and
        (activation_reserved_bay ?activation_instance ?resource)
        (not
          (team_brief_complete ?activation_instance)
        )
        (not
          (procedural_provider_confirmed ?activation_instance)
        )
      )
    :effect
      (and
        (not
          (activation_reserved_bay ?activation_instance ?resource)
        )
        (not
          (activation_resources_locked ?activation_instance)
        )
        (not
          (activation_monitor_assigned ?activation_instance)
        )
        (not
          (activation_equipment_ready ?activation_instance)
        )
        (not
          (activation_personnel_notified ?activation_instance)
        )
        (not
          (activation_procedure_scheduled ?activation_instance)
        )
        (not
          (activation_blood_requested ?activation_instance)
        )
        (bay_available ?resource)
      )
  )
  (:action assign_bedside_monitor_unit
    :parameters (?activation_instance - trauma_activation ?resource - bedside_monitor_unit)
    :precondition
      (and
        (activation_active ?activation_instance)
        (bedside_monitor_unit_available ?resource)
      )
    :effect
      (and
        (activation_assigned_bedside_monitor_unit ?activation_instance ?resource)
        (not
          (bedside_monitor_unit_available ?resource)
        )
      )
  )
  (:action release_bedside_monitor_unit
    :parameters (?activation_instance - trauma_activation ?resource - bedside_monitor_unit)
    :precondition
      (and
        (activation_assigned_bedside_monitor_unit ?activation_instance ?resource)
      )
    :effect
      (and
        (bedside_monitor_unit_available ?resource)
        (not
          (activation_assigned_bedside_monitor_unit ?activation_instance ?resource)
        )
      )
  )
  (:action confirm_monitor_setup
    :parameters (?activation_instance - trauma_activation ?resource - bedside_monitor_unit)
    :precondition
      (and
        (activation_active ?activation_instance)
        (activation_resources_locked ?activation_instance)
        (activation_assigned_bedside_monitor_unit ?activation_instance ?resource)
        (not
          (activation_monitor_assigned ?activation_instance)
        )
      )
    :effect
      (and
        (activation_monitor_assigned ?activation_instance)
      )
  )
  (:action notify_procedural_team
    :parameters (?activation_instance - trauma_activation ?resource - notification_device)
    :precondition
      (and
        (activation_active ?activation_instance)
        (activation_resources_locked ?activation_instance)
        (notification_device_available ?resource)
        (not
          (activation_monitor_assigned ?activation_instance)
        )
      )
    :effect
      (and
        (activation_monitor_assigned ?activation_instance)
        (activation_personnel_notified ?activation_instance)
        (not
          (notification_device_available ?resource)
        )
      )
  )
  (:action technician_prepare_equipment
    :parameters (?activation_instance - trauma_activation ?resource - bedside_monitor_unit ?staff_member - equipment_technician)
    :precondition
      (and
        (activation_monitor_assigned ?activation_instance)
        (activation_resources_locked ?activation_instance)
        (activation_assigned_bedside_monitor_unit ?activation_instance ?resource)
        (equipment_technician_available ?staff_member)
        (not
          (activation_equipment_ready ?activation_instance)
        )
      )
    :effect
      (and
        (activation_equipment_ready ?activation_instance)
        (not
          (activation_personnel_notified ?activation_instance)
        )
      )
  )
  (:action confirm_external_imaging
    :parameters (?activation_instance - trauma_activation ?resource - imaging_resource)
    :precondition
      (and
        (activation_resources_locked ?activation_instance)
        (activation_imaging_confirmed ?activation_instance ?resource)
        (not
          (activation_equipment_ready ?activation_instance)
        )
      )
    :effect
      (and
        (activation_equipment_ready ?activation_instance)
        (not
          (activation_personnel_notified ?activation_instance)
        )
      )
  )
  (:action reserve_bedside_nurse
    :parameters (?activation_instance - trauma_activation ?resource - bedside_nurse)
    :precondition
      (and
        (activation_active ?activation_instance)
        (bedside_nurse_available ?resource)
        (bedside_nurse_eligible_for_activation ?activation_instance ?resource)
      )
    :effect
      (and
        (activation_reserved_bedside_nurse ?activation_instance ?resource)
        (not
          (bedside_nurse_available ?resource)
        )
      )
  )
  (:action release_bedside_nurse
    :parameters (?activation_instance - trauma_activation ?resource - bedside_nurse)
    :precondition
      (and
        (activation_reserved_bedside_nurse ?activation_instance ?resource)
      )
    :effect
      (and
        (bedside_nurse_available ?resource)
        (not
          (activation_reserved_bedside_nurse ?activation_instance ?resource)
        )
      )
  )
  (:action reserve_monitoring_device
    :parameters (?activation_instance - trauma_activation ?resource - monitoring_device)
    :precondition
      (and
        (activation_active ?activation_instance)
        (monitoring_device_available ?resource)
        (monitoring_device_compatible_for_activation ?activation_instance ?resource)
      )
    :effect
      (and
        (activation_reserved_monitoring_device ?activation_instance ?resource)
        (not
          (monitoring_device_available ?resource)
        )
      )
  )
  (:action release_monitoring_device
    :parameters (?activation_instance - trauma_activation ?resource - monitoring_device)
    :precondition
      (and
        (activation_reserved_monitoring_device ?activation_instance ?resource)
      )
    :effect
      (and
        (monitoring_device_available ?resource)
        (not
          (activation_reserved_monitoring_device ?activation_instance ?resource)
        )
      )
  )
  (:action reserve_respiratory_therapist
    :parameters (?activation_instance - trauma_activation ?resource - respiratory_therapist)
    :precondition
      (and
        (activation_active ?activation_instance)
        (respiratory_therapist_available ?resource)
        (respiratory_therapist_eligible_for_activation ?activation_instance ?resource)
      )
    :effect
      (and
        (activation_reserved_respiratory_therapist ?activation_instance ?resource)
        (not
          (respiratory_therapist_available ?resource)
        )
      )
  )
  (:action release_respiratory_therapist
    :parameters (?activation_instance - trauma_activation ?resource - respiratory_therapist)
    :precondition
      (and
        (activation_reserved_respiratory_therapist ?activation_instance ?resource)
      )
    :effect
      (and
        (respiratory_therapist_available ?resource)
        (not
          (activation_reserved_respiratory_therapist ?activation_instance ?resource)
        )
      )
  )
  (:action reserve_supply_cart
    :parameters (?activation_instance - trauma_activation ?resource - supply_cart)
    :precondition
      (and
        (activation_active ?activation_instance)
        (supply_cart_available ?resource)
        (supply_cart_compatible_for_activation ?activation_instance ?resource)
      )
    :effect
      (and
        (activation_reserved_supply_cart ?activation_instance ?resource)
        (not
          (supply_cart_available ?resource)
        )
      )
  )
  (:action release_supply_cart
    :parameters (?activation_instance - trauma_activation ?resource - supply_cart)
    :precondition
      (and
        (activation_reserved_supply_cart ?activation_instance ?resource)
      )
    :effect
      (and
        (supply_cart_available ?resource)
        (not
          (activation_reserved_supply_cart ?activation_instance ?resource)
        )
      )
  )
  (:action assign_clinical_role_for_procedure
    :parameters (?activation_instance - trauma_activation ?resource - clinical_role ?staff_member - bedside_nurse ?role_token - monitoring_device)
    :precondition
      (and
        (activation_resources_locked ?activation_instance)
        (activation_reserved_bedside_nurse ?activation_instance ?staff_member)
        (activation_reserved_monitoring_device ?activation_instance ?role_token)
        (clinical_role_available ?resource)
        (clinical_role_required_for_activation ?activation_instance ?resource)
        (not
          (team_brief_complete ?activation_instance)
        )
      )
    :effect
      (and
        (activation_assigned_clinical_role ?activation_instance ?resource)
        (team_brief_complete ?activation_instance)
        (not
          (clinical_role_available ?resource)
        )
      )
  )
  (:action assemble_team_with_blood
    :parameters (?activation_instance - trauma_activation ?resource - clinical_role ?staff_member - respiratory_therapist ?role_token - blood_product_unit)
    :precondition
      (and
        (activation_resources_locked ?activation_instance)
        (activation_reserved_respiratory_therapist ?activation_instance ?staff_member)
        (blood_product_available ?role_token)
        (clinical_role_available ?resource)
        (clinical_role_required_for_activation ?activation_instance ?resource)
        (blood_product_compatible_for_activation ?activation_instance ?role_token)
        (not
          (team_brief_complete ?activation_instance)
        )
      )
    :effect
      (and
        (activation_assigned_clinical_role ?activation_instance ?resource)
        (team_brief_complete ?activation_instance)
        (activation_blood_requested ?activation_instance)
        (activation_personnel_notified ?activation_instance)
        (not
          (clinical_role_available ?resource)
        )
        (not
          (blood_product_available ?role_token)
        )
      )
  )
  (:action clear_blood_request
    :parameters (?activation_instance - trauma_activation ?resource - bedside_nurse ?staff_member - monitoring_device)
    :precondition
      (and
        (team_brief_complete ?activation_instance)
        (activation_blood_requested ?activation_instance)
        (activation_reserved_bedside_nurse ?activation_instance ?resource)
        (activation_reserved_monitoring_device ?activation_instance ?staff_member)
      )
    :effect
      (and
        (not
          (activation_blood_requested ?activation_instance)
        )
        (not
          (activation_personnel_notified ?activation_instance)
        )
      )
  )
  (:action confirm_procedural_provider
    :parameters (?activation_instance - trauma_activation ?resource - bedside_nurse ?staff_member - monitoring_device ?role_token - procedural_provider_role)
    :precondition
      (and
        (activation_equipment_ready ?activation_instance)
        (team_brief_complete ?activation_instance)
        (activation_reserved_bedside_nurse ?activation_instance ?resource)
        (activation_reserved_monitoring_device ?activation_instance ?staff_member)
        (activation_associated_staff_role ?activation_instance ?role_token)
        (not
          (activation_personnel_notified ?activation_instance)
        )
        (not
          (procedural_provider_confirmed ?activation_instance)
        )
      )
    :effect
      (and
        (procedural_provider_confirmed ?activation_instance)
      )
  )
  (:action confirm_anesthesia_team
    :parameters (?activation_instance - trauma_activation ?resource - respiratory_therapist ?staff_member - supply_cart ?role_token - anesthetist_role)
    :precondition
      (and
        (activation_equipment_ready ?activation_instance)
        (team_brief_complete ?activation_instance)
        (activation_reserved_respiratory_therapist ?activation_instance ?resource)
        (activation_reserved_supply_cart ?activation_instance ?staff_member)
        (activation_associated_staff_role ?activation_instance ?role_token)
        (not
          (procedural_provider_confirmed ?activation_instance)
        )
      )
    :effect
      (and
        (procedural_provider_confirmed ?activation_instance)
        (activation_personnel_notified ?activation_instance)
      )
  )
  (:action begin_procedure
    :parameters (?activation_instance - trauma_activation ?resource - bedside_nurse ?staff_member - monitoring_device)
    :precondition
      (and
        (procedural_provider_confirmed ?activation_instance)
        (activation_personnel_notified ?activation_instance)
        (activation_reserved_bedside_nurse ?activation_instance ?resource)
        (activation_reserved_monitoring_device ?activation_instance ?staff_member)
      )
    :effect
      (and
        (activation_procedure_scheduled ?activation_instance)
        (not
          (activation_personnel_notified ?activation_instance)
        )
        (not
          (activation_equipment_ready ?activation_instance)
        )
        (not
          (activation_blood_requested ?activation_instance)
        )
      )
  )
  (:action technician_prepare_equipment_secondary
    :parameters (?activation_instance - trauma_activation ?resource - bedside_monitor_unit ?staff_member - equipment_technician)
    :precondition
      (and
        (activation_procedure_scheduled ?activation_instance)
        (procedural_provider_confirmed ?activation_instance)
        (activation_resources_locked ?activation_instance)
        (activation_assigned_bedside_monitor_unit ?activation_instance ?resource)
        (equipment_technician_available ?staff_member)
        (not
          (activation_equipment_ready ?activation_instance)
        )
      )
    :effect
      (and
        (activation_equipment_ready ?activation_instance)
      )
  )
  (:action mark_monitoring_check_complete
    :parameters (?activation_instance - trauma_activation ?resource - bedside_monitor_unit)
    :precondition
      (and
        (procedural_provider_confirmed ?activation_instance)
        (activation_equipment_ready ?activation_instance)
        (not
          (activation_personnel_notified ?activation_instance)
        )
        (activation_assigned_bedside_monitor_unit ?activation_instance ?resource)
        (not
          (activation_notification_acknowledged ?activation_instance)
        )
      )
    :effect
      (and
        (activation_notification_acknowledged ?activation_instance)
      )
  )
  (:action acknowledge_notification_device
    :parameters (?activation_instance - trauma_activation ?resource - notification_device)
    :precondition
      (and
        (procedural_provider_confirmed ?activation_instance)
        (activation_equipment_ready ?activation_instance)
        (not
          (activation_personnel_notified ?activation_instance)
        )
        (notification_device_available ?resource)
        (not
          (activation_notification_acknowledged ?activation_instance)
        )
      )
    :effect
      (and
        (activation_notification_acknowledged ?activation_instance)
        (not
          (notification_device_available ?resource)
        )
      )
  )
  (:action reserve_imaging_slot
    :parameters (?activation_instance - trauma_activation ?resource - imaging_resource)
    :precondition
      (and
        (activation_notification_acknowledged ?activation_instance)
        (imaging_resource_available ?resource)
        (activation_imaging_authorization ?activation_instance ?resource)
      )
    :effect
      (and
        (external_activation_imaging_link ?activation_instance ?resource)
        (not
          (imaging_resource_available ?resource)
        )
      )
  )
  (:action link_local_external_imaging
    :parameters (?activation_instance - local_activation_reference ?resource - external_activation_reference ?staff_member - imaging_resource)
    :precondition
      (and
        (activation_active ?activation_instance)
        (activation_remote_coordinator_present ?activation_instance)
        (activation_imaging_requested ?activation_instance ?staff_member)
        (external_activation_imaging_link ?resource ?staff_member)
        (not
          (activation_imaging_confirmed ?activation_instance ?staff_member)
        )
      )
    :effect
      (and
        (activation_imaging_confirmed ?activation_instance ?staff_member)
      )
  )
  (:action confirm_equipment_technician
    :parameters (?activation_instance - trauma_activation ?resource - bedside_monitor_unit ?staff_member - equipment_technician)
    :precondition
      (and
        (activation_active ?activation_instance)
        (activation_remote_coordinator_present ?activation_instance)
        (activation_equipment_ready ?activation_instance)
        (activation_notification_acknowledged ?activation_instance)
        (activation_assigned_bedside_monitor_unit ?activation_instance ?resource)
        (equipment_technician_available ?staff_member)
        (not
          (equipment_technician_confirmed ?activation_instance)
        )
      )
    :effect
      (and
        (equipment_technician_confirmed ?activation_instance)
      )
  )
  (:action finalize_activation_local
    :parameters (?activation_instance - trauma_activation)
    :precondition
      (and
        (activation_local_coordinator_present ?activation_instance)
        (activation_active ?activation_instance)
        (activation_resources_locked ?activation_instance)
        (team_brief_complete ?activation_instance)
        (procedural_provider_confirmed ?activation_instance)
        (activation_notification_acknowledged ?activation_instance)
        (activation_equipment_ready ?activation_instance)
        (not
          (activation_finalized ?activation_instance)
        )
      )
    :effect
      (and
        (activation_finalized ?activation_instance)
      )
  )
  (:action finalize_activation_with_imaging
    :parameters (?activation_instance - trauma_activation ?resource - imaging_resource)
    :precondition
      (and
        (activation_remote_coordinator_present ?activation_instance)
        (activation_active ?activation_instance)
        (activation_resources_locked ?activation_instance)
        (team_brief_complete ?activation_instance)
        (procedural_provider_confirmed ?activation_instance)
        (activation_notification_acknowledged ?activation_instance)
        (activation_equipment_ready ?activation_instance)
        (activation_imaging_confirmed ?activation_instance ?resource)
        (not
          (activation_finalized ?activation_instance)
        )
      )
    :effect
      (and
        (activation_finalized ?activation_instance)
      )
  )
  (:action finalize_activation_with_technician
    :parameters (?activation_instance - trauma_activation)
    :precondition
      (and
        (activation_remote_coordinator_present ?activation_instance)
        (activation_active ?activation_instance)
        (activation_resources_locked ?activation_instance)
        (team_brief_complete ?activation_instance)
        (procedural_provider_confirmed ?activation_instance)
        (activation_notification_acknowledged ?activation_instance)
        (activation_equipment_ready ?activation_instance)
        (equipment_technician_confirmed ?activation_instance)
        (not
          (activation_finalized ?activation_instance)
        )
      )
    :effect
      (and
        (activation_finalized ?activation_instance)
      )
  )
)

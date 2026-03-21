(define (domain infusion_scheduling_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types infusion_visit - object infusion_chair - object treatment_order - object registered_nurse - object medication_prep_resource - object clinical_equipment - object supply_cart - object support_staff - object monitoring_station - object pharmacy_technician - object sterile_prep_area - object medication_batch - object clinical_area - object operational_zone_a - clinical_area operational_zone_b - clinical_area visit_variant_a - infusion_visit visit_variant_b - infusion_visit)
  (:predicates
    (visit_active ?infusion_visit - infusion_visit)
    (assigned_chair ?infusion_visit - infusion_visit ?infusion_chair - infusion_chair)
    (visit_chair_reserved ?infusion_visit - infusion_visit)
    (nurse_assignment_confirmed ?infusion_visit - infusion_visit)
    (medication_ready ?infusion_visit - infusion_visit)
    (allocated_medication_prep_resource ?infusion_visit - infusion_visit ?medication_prep_resource - medication_prep_resource)
    (nurse_assigned_to_visit ?infusion_visit - infusion_visit ?registered_nurse - registered_nurse)
    (allocated_equipment ?infusion_visit - infusion_visit ?clinical_equipment - clinical_equipment)
    (allocated_medication_batch ?infusion_visit - infusion_visit ?medication_batch - medication_batch)
    (assigned_treatment_order ?infusion_visit - infusion_visit ?treatment_order - treatment_order)
    (treatment_started ?infusion_visit - infusion_visit)
    (clinical_checks_completed ?infusion_visit - infusion_visit)
    (cart_staged ?infusion_visit - infusion_visit)
    (visit_finalized ?infusion_visit - infusion_visit)
    (additional_intervention_required ?infusion_visit - infusion_visit)
    (procedure_ready_for_execution ?infusion_visit - infusion_visit)
    (visit_variant_monitoring_preference ?infusion_visit - infusion_visit ?monitoring_station - monitoring_station)
    (monitoring_reserved_for_visit ?infusion_visit - infusion_visit ?monitoring_station - monitoring_station)
    (final_check_complete ?infusion_visit - infusion_visit)
    (chair_available ?infusion_chair - infusion_chair)
    (order_available ?treatment_order - treatment_order)
    (med_prep_resource_available ?medication_prep_resource - medication_prep_resource)
    (nurse_available ?registered_nurse - registered_nurse)
    (equipment_available ?clinical_equipment - clinical_equipment)
    (supply_cart_available ?supply_cart - supply_cart)
    (support_staff_available ?support_staff - support_staff)
    (monitoring_available ?monitoring_station - monitoring_station)
    (pharmacy_tech_available ?pharmacy_technician - pharmacy_technician)
    (sterile_prep_available ?sterile_prep_area - sterile_prep_area)
    (medication_batch_available ?medication_batch - medication_batch)
    (chair_eligible ?infusion_visit - infusion_visit ?infusion_chair - infusion_chair)
    (order_eligible ?infusion_visit - infusion_visit ?treatment_order - treatment_order)
    (med_prep_resource_eligible ?infusion_visit - infusion_visit ?medication_prep_resource - medication_prep_resource)
    (nurse_eligible ?infusion_visit - infusion_visit ?registered_nurse - registered_nurse)
    (equipment_eligible ?infusion_visit - infusion_visit ?clinical_equipment - clinical_equipment)
    (prep_area_eligible ?infusion_visit - infusion_visit ?sterile_prep_area - sterile_prep_area)
    (medication_batch_eligible ?infusion_visit - infusion_visit ?medication_batch - medication_batch)
    (assigned_operational_zone ?infusion_visit - infusion_visit ?clinical_area - clinical_area)
    (assigned_monitoring ?infusion_visit - infusion_visit ?monitoring_station - monitoring_station)
    (visit_variant_a_flag ?infusion_visit - infusion_visit)
    (visit_variant_b_flag ?infusion_visit - infusion_visit)
    (assigned_supply_cart ?infusion_visit - infusion_visit ?supply_cart - supply_cart)
    (pharmacy_return_pending ?infusion_visit - infusion_visit)
    (visit_monitoring_compatibility ?infusion_visit - infusion_visit ?monitoring_station - monitoring_station)
  )
  (:action activate_visit
    :parameters (?infusion_visit - infusion_visit)
    :precondition
      (and
        (not
          (visit_active ?infusion_visit)
        )
        (not
          (visit_finalized ?infusion_visit)
        )
      )
    :effect
      (and
        (visit_active ?infusion_visit)
      )
  )
  (:action assign_chair_to_visit
    :parameters (?infusion_visit - infusion_visit ?infusion_chair - infusion_chair)
    :precondition
      (and
        (visit_active ?infusion_visit)
        (chair_available ?infusion_chair)
        (chair_eligible ?infusion_visit ?infusion_chair)
        (not
          (visit_chair_reserved ?infusion_visit)
        )
      )
    :effect
      (and
        (assigned_chair ?infusion_visit ?infusion_chair)
        (visit_chair_reserved ?infusion_visit)
        (not
          (chair_available ?infusion_chair)
        )
      )
  )
  (:action release_chair_from_visit
    :parameters (?infusion_visit - infusion_visit ?infusion_chair - infusion_chair)
    :precondition
      (and
        (assigned_chair ?infusion_visit ?infusion_chair)
        (not
          (treatment_started ?infusion_visit)
        )
        (not
          (clinical_checks_completed ?infusion_visit)
        )
      )
    :effect
      (and
        (not
          (assigned_chair ?infusion_visit ?infusion_chair)
        )
        (not
          (visit_chair_reserved ?infusion_visit)
        )
        (not
          (nurse_assignment_confirmed ?infusion_visit)
        )
        (not
          (medication_ready ?infusion_visit)
        )
        (not
          (additional_intervention_required ?infusion_visit)
        )
        (not
          (procedure_ready_for_execution ?infusion_visit)
        )
        (not
          (pharmacy_return_pending ?infusion_visit)
        )
        (chair_available ?infusion_chair)
      )
  )
  (:action reserve_supply_cart
    :parameters (?infusion_visit - infusion_visit ?supply_cart - supply_cart)
    :precondition
      (and
        (visit_active ?infusion_visit)
        (supply_cart_available ?supply_cart)
      )
    :effect
      (and
        (assigned_supply_cart ?infusion_visit ?supply_cart)
        (not
          (supply_cart_available ?supply_cart)
        )
      )
  )
  (:action release_supply_cart
    :parameters (?infusion_visit - infusion_visit ?supply_cart - supply_cart)
    :precondition
      (and
        (assigned_supply_cart ?infusion_visit ?supply_cart)
      )
    :effect
      (and
        (supply_cart_available ?supply_cart)
        (not
          (assigned_supply_cart ?infusion_visit ?supply_cart)
        )
      )
  )
  (:action confirm_nurse_presence
    :parameters (?infusion_visit - infusion_visit ?supply_cart - supply_cart)
    :precondition
      (and
        (visit_active ?infusion_visit)
        (visit_chair_reserved ?infusion_visit)
        (assigned_supply_cart ?infusion_visit ?supply_cart)
        (not
          (nurse_assignment_confirmed ?infusion_visit)
        )
      )
    :effect
      (and
        (nurse_assignment_confirmed ?infusion_visit)
      )
  )
  (:action confirm_nurse_assignment_with_support_staff
    :parameters (?infusion_visit - infusion_visit ?support_staff - support_staff)
    :precondition
      (and
        (visit_active ?infusion_visit)
        (visit_chair_reserved ?infusion_visit)
        (support_staff_available ?support_staff)
        (not
          (nurse_assignment_confirmed ?infusion_visit)
        )
      )
    :effect
      (and
        (nurse_assignment_confirmed ?infusion_visit)
        (additional_intervention_required ?infusion_visit)
        (not
          (support_staff_available ?support_staff)
        )
      )
  )
  (:action perform_pharmacy_medication_prep
    :parameters (?infusion_visit - infusion_visit ?supply_cart - supply_cart ?pharmacy_technician - pharmacy_technician)
    :precondition
      (and
        (nurse_assignment_confirmed ?infusion_visit)
        (visit_chair_reserved ?infusion_visit)
        (assigned_supply_cart ?infusion_visit ?supply_cart)
        (pharmacy_tech_available ?pharmacy_technician)
        (not
          (medication_ready ?infusion_visit)
        )
      )
    :effect
      (and
        (medication_ready ?infusion_visit)
        (not
          (additional_intervention_required ?infusion_visit)
        )
      )
  )
  (:action reserve_monitoring_and_mark_med_ready
    :parameters (?infusion_visit - infusion_visit ?monitoring_station - monitoring_station)
    :precondition
      (and
        (visit_chair_reserved ?infusion_visit)
        (monitoring_reserved_for_visit ?infusion_visit ?monitoring_station)
        (not
          (medication_ready ?infusion_visit)
        )
      )
    :effect
      (and
        (medication_ready ?infusion_visit)
        (not
          (additional_intervention_required ?infusion_visit)
        )
      )
  )
  (:action reserve_med_prep_resource
    :parameters (?infusion_visit - infusion_visit ?medication_prep_resource - medication_prep_resource)
    :precondition
      (and
        (visit_active ?infusion_visit)
        (med_prep_resource_available ?medication_prep_resource)
        (med_prep_resource_eligible ?infusion_visit ?medication_prep_resource)
      )
    :effect
      (and
        (allocated_medication_prep_resource ?infusion_visit ?medication_prep_resource)
        (not
          (med_prep_resource_available ?medication_prep_resource)
        )
      )
  )
  (:action release_med_prep_resource
    :parameters (?infusion_visit - infusion_visit ?medication_prep_resource - medication_prep_resource)
    :precondition
      (and
        (allocated_medication_prep_resource ?infusion_visit ?medication_prep_resource)
      )
    :effect
      (and
        (med_prep_resource_available ?medication_prep_resource)
        (not
          (allocated_medication_prep_resource ?infusion_visit ?medication_prep_resource)
        )
      )
  )
  (:action reserve_nurse_for_visit
    :parameters (?infusion_visit - infusion_visit ?registered_nurse - registered_nurse)
    :precondition
      (and
        (visit_active ?infusion_visit)
        (nurse_available ?registered_nurse)
        (nurse_eligible ?infusion_visit ?registered_nurse)
      )
    :effect
      (and
        (nurse_assigned_to_visit ?infusion_visit ?registered_nurse)
        (not
          (nurse_available ?registered_nurse)
        )
      )
  )
  (:action release_nurse_from_visit
    :parameters (?infusion_visit - infusion_visit ?registered_nurse - registered_nurse)
    :precondition
      (and
        (nurse_assigned_to_visit ?infusion_visit ?registered_nurse)
      )
    :effect
      (and
        (nurse_available ?registered_nurse)
        (not
          (nurse_assigned_to_visit ?infusion_visit ?registered_nurse)
        )
      )
  )
  (:action reserve_equipment_for_visit
    :parameters (?infusion_visit - infusion_visit ?clinical_equipment - clinical_equipment)
    :precondition
      (and
        (visit_active ?infusion_visit)
        (equipment_available ?clinical_equipment)
        (equipment_eligible ?infusion_visit ?clinical_equipment)
      )
    :effect
      (and
        (allocated_equipment ?infusion_visit ?clinical_equipment)
        (not
          (equipment_available ?clinical_equipment)
        )
      )
  )
  (:action release_equipment_from_visit
    :parameters (?infusion_visit - infusion_visit ?clinical_equipment - clinical_equipment)
    :precondition
      (and
        (allocated_equipment ?infusion_visit ?clinical_equipment)
      )
    :effect
      (and
        (equipment_available ?clinical_equipment)
        (not
          (allocated_equipment ?infusion_visit ?clinical_equipment)
        )
      )
  )
  (:action reserve_medication_batch_for_visit
    :parameters (?infusion_visit - infusion_visit ?medication_batch - medication_batch)
    :precondition
      (and
        (visit_active ?infusion_visit)
        (medication_batch_available ?medication_batch)
        (medication_batch_eligible ?infusion_visit ?medication_batch)
      )
    :effect
      (and
        (allocated_medication_batch ?infusion_visit ?medication_batch)
        (not
          (medication_batch_available ?medication_batch)
        )
      )
  )
  (:action release_medication_batch_from_visit
    :parameters (?infusion_visit - infusion_visit ?medication_batch - medication_batch)
    :precondition
      (and
        (allocated_medication_batch ?infusion_visit ?medication_batch)
      )
    :effect
      (and
        (medication_batch_available ?medication_batch)
        (not
          (allocated_medication_batch ?infusion_visit ?medication_batch)
        )
      )
  )
  (:action initiate_infusion_procedure_with_order
    :parameters (?infusion_visit - infusion_visit ?treatment_order - treatment_order ?medication_prep_resource - medication_prep_resource ?registered_nurse - registered_nurse)
    :precondition
      (and
        (visit_chair_reserved ?infusion_visit)
        (allocated_medication_prep_resource ?infusion_visit ?medication_prep_resource)
        (nurse_assigned_to_visit ?infusion_visit ?registered_nurse)
        (order_available ?treatment_order)
        (order_eligible ?infusion_visit ?treatment_order)
        (not
          (treatment_started ?infusion_visit)
        )
      )
    :effect
      (and
        (assigned_treatment_order ?infusion_visit ?treatment_order)
        (treatment_started ?infusion_visit)
        (not
          (order_available ?treatment_order)
        )
      )
  )
  (:action initiate_infusion_procedure_with_equipment
    :parameters (?infusion_visit - infusion_visit ?treatment_order - treatment_order ?clinical_equipment - clinical_equipment ?sterile_prep_area - sterile_prep_area)
    :precondition
      (and
        (visit_chair_reserved ?infusion_visit)
        (allocated_equipment ?infusion_visit ?clinical_equipment)
        (sterile_prep_available ?sterile_prep_area)
        (order_available ?treatment_order)
        (order_eligible ?infusion_visit ?treatment_order)
        (prep_area_eligible ?infusion_visit ?sterile_prep_area)
        (not
          (treatment_started ?infusion_visit)
        )
      )
    :effect
      (and
        (assigned_treatment_order ?infusion_visit ?treatment_order)
        (treatment_started ?infusion_visit)
        (pharmacy_return_pending ?infusion_visit)
        (additional_intervention_required ?infusion_visit)
        (not
          (order_available ?treatment_order)
        )
        (not
          (sterile_prep_available ?sterile_prep_area)
        )
      )
  )
  (:action complete_preprocedure_pharmacy_handoff
    :parameters (?infusion_visit - infusion_visit ?medication_prep_resource - medication_prep_resource ?registered_nurse - registered_nurse)
    :precondition
      (and
        (treatment_started ?infusion_visit)
        (pharmacy_return_pending ?infusion_visit)
        (allocated_medication_prep_resource ?infusion_visit ?medication_prep_resource)
        (nurse_assigned_to_visit ?infusion_visit ?registered_nurse)
      )
    :effect
      (and
        (not
          (pharmacy_return_pending ?infusion_visit)
        )
        (not
          (additional_intervention_required ?infusion_visit)
        )
      )
  )
  (:action perform_zone_based_clinical_checks
    :parameters (?infusion_visit - infusion_visit ?medication_prep_resource - medication_prep_resource ?registered_nurse - registered_nurse ?operational_zone_a - operational_zone_a)
    :precondition
      (and
        (medication_ready ?infusion_visit)
        (treatment_started ?infusion_visit)
        (allocated_medication_prep_resource ?infusion_visit ?medication_prep_resource)
        (nurse_assigned_to_visit ?infusion_visit ?registered_nurse)
        (assigned_operational_zone ?infusion_visit ?operational_zone_a)
        (not
          (additional_intervention_required ?infusion_visit)
        )
        (not
          (clinical_checks_completed ?infusion_visit)
        )
      )
    :effect
      (and
        (clinical_checks_completed ?infusion_visit)
      )
  )
  (:action perform_zone_b_checks_with_equipment_and_batch
    :parameters (?infusion_visit - infusion_visit ?clinical_equipment - clinical_equipment ?medication_batch - medication_batch ?operational_zone_b - operational_zone_b)
    :precondition
      (and
        (medication_ready ?infusion_visit)
        (treatment_started ?infusion_visit)
        (allocated_equipment ?infusion_visit ?clinical_equipment)
        (allocated_medication_batch ?infusion_visit ?medication_batch)
        (assigned_operational_zone ?infusion_visit ?operational_zone_b)
        (not
          (clinical_checks_completed ?infusion_visit)
        )
      )
    :effect
      (and
        (clinical_checks_completed ?infusion_visit)
        (additional_intervention_required ?infusion_visit)
      )
  )
  (:action start_treatment_procedure
    :parameters (?infusion_visit - infusion_visit ?medication_prep_resource - medication_prep_resource ?registered_nurse - registered_nurse)
    :precondition
      (and
        (clinical_checks_completed ?infusion_visit)
        (additional_intervention_required ?infusion_visit)
        (allocated_medication_prep_resource ?infusion_visit ?medication_prep_resource)
        (nurse_assigned_to_visit ?infusion_visit ?registered_nurse)
      )
    :effect
      (and
        (procedure_ready_for_execution ?infusion_visit)
        (not
          (additional_intervention_required ?infusion_visit)
        )
        (not
          (medication_ready ?infusion_visit)
        )
        (not
          (pharmacy_return_pending ?infusion_visit)
        )
      )
  )
  (:action perform_pharmacy_staging
    :parameters (?infusion_visit - infusion_visit ?supply_cart - supply_cart ?pharmacy_technician - pharmacy_technician)
    :precondition
      (and
        (procedure_ready_for_execution ?infusion_visit)
        (clinical_checks_completed ?infusion_visit)
        (visit_chair_reserved ?infusion_visit)
        (assigned_supply_cart ?infusion_visit ?supply_cart)
        (pharmacy_tech_available ?pharmacy_technician)
        (not
          (medication_ready ?infusion_visit)
        )
      )
    :effect
      (and
        (medication_ready ?infusion_visit)
      )
  )
  (:action mark_cart_staged
    :parameters (?infusion_visit - infusion_visit ?supply_cart - supply_cart)
    :precondition
      (and
        (clinical_checks_completed ?infusion_visit)
        (medication_ready ?infusion_visit)
        (not
          (additional_intervention_required ?infusion_visit)
        )
        (assigned_supply_cart ?infusion_visit ?supply_cart)
        (not
          (cart_staged ?infusion_visit)
        )
      )
    :effect
      (and
        (cart_staged ?infusion_visit)
      )
  )
  (:action stage_cart_with_support_staff
    :parameters (?infusion_visit - infusion_visit ?support_staff - support_staff)
    :precondition
      (and
        (clinical_checks_completed ?infusion_visit)
        (medication_ready ?infusion_visit)
        (not
          (additional_intervention_required ?infusion_visit)
        )
        (support_staff_available ?support_staff)
        (not
          (cart_staged ?infusion_visit)
        )
      )
    :effect
      (and
        (cart_staged ?infusion_visit)
        (not
          (support_staff_available ?support_staff)
        )
      )
  )
  (:action assign_monitoring_to_visit
    :parameters (?infusion_visit - infusion_visit ?monitoring_station - monitoring_station)
    :precondition
      (and
        (cart_staged ?infusion_visit)
        (monitoring_available ?monitoring_station)
        (visit_monitoring_compatibility ?infusion_visit ?monitoring_station)
      )
    :effect
      (and
        (assigned_monitoring ?infusion_visit ?monitoring_station)
        (not
          (monitoring_available ?monitoring_station)
        )
      )
  )
  (:action reserve_monitoring_for_variant_pairing
    :parameters (?visit_variant_b - visit_variant_b ?visit_variant_a - visit_variant_a ?monitoring_station - monitoring_station)
    :precondition
      (and
        (visit_active ?visit_variant_b)
        (visit_variant_b_flag ?visit_variant_b)
        (visit_variant_monitoring_preference ?visit_variant_b ?monitoring_station)
        (assigned_monitoring ?visit_variant_a ?monitoring_station)
        (not
          (monitoring_reserved_for_visit ?visit_variant_b ?monitoring_station)
        )
      )
    :effect
      (and
        (monitoring_reserved_for_visit ?visit_variant_b ?monitoring_station)
      )
  )
  (:action perform_final_clinical_checks
    :parameters (?infusion_visit - infusion_visit ?supply_cart - supply_cart ?pharmacy_technician - pharmacy_technician)
    :precondition
      (and
        (visit_active ?infusion_visit)
        (visit_variant_b_flag ?infusion_visit)
        (medication_ready ?infusion_visit)
        (cart_staged ?infusion_visit)
        (assigned_supply_cart ?infusion_visit ?supply_cart)
        (pharmacy_tech_available ?pharmacy_technician)
        (not
          (final_check_complete ?infusion_visit)
        )
      )
    :effect
      (and
        (final_check_complete ?infusion_visit)
      )
  )
  (:action finalize_visit_administration
    :parameters (?infusion_visit - infusion_visit)
    :precondition
      (and
        (visit_variant_a_flag ?infusion_visit)
        (visit_active ?infusion_visit)
        (visit_chair_reserved ?infusion_visit)
        (treatment_started ?infusion_visit)
        (clinical_checks_completed ?infusion_visit)
        (cart_staged ?infusion_visit)
        (medication_ready ?infusion_visit)
        (not
          (visit_finalized ?infusion_visit)
        )
      )
    :effect
      (and
        (visit_finalized ?infusion_visit)
      )
  )
  (:action finalize_visit_with_monitoring
    :parameters (?infusion_visit - infusion_visit ?monitoring_station - monitoring_station)
    :precondition
      (and
        (visit_variant_b_flag ?infusion_visit)
        (visit_active ?infusion_visit)
        (visit_chair_reserved ?infusion_visit)
        (treatment_started ?infusion_visit)
        (clinical_checks_completed ?infusion_visit)
        (cart_staged ?infusion_visit)
        (medication_ready ?infusion_visit)
        (monitoring_reserved_for_visit ?infusion_visit ?monitoring_station)
        (not
          (visit_finalized ?infusion_visit)
        )
      )
    :effect
      (and
        (visit_finalized ?infusion_visit)
      )
  )
  (:action finalize_visit_after_final_check
    :parameters (?infusion_visit - infusion_visit)
    :precondition
      (and
        (visit_variant_b_flag ?infusion_visit)
        (visit_active ?infusion_visit)
        (visit_chair_reserved ?infusion_visit)
        (treatment_started ?infusion_visit)
        (clinical_checks_completed ?infusion_visit)
        (cart_staged ?infusion_visit)
        (medication_ready ?infusion_visit)
        (final_check_complete ?infusion_visit)
        (not
          (visit_finalized ?infusion_visit)
        )
      )
    :effect
      (and
        (visit_finalized ?infusion_visit)
      )
  )
)

(define (domain hospital_bed_turnover_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types bed_unit - physical_entity evs_technician - physical_entity charge_nurse - physical_entity cleaning_protocol - physical_entity linen_cart - physical_entity disinfectant_kit - physical_entity cleaning_cart - physical_entity portable_cleaning_kit - physical_entity audit_tablet - physical_entity checklist_form - physical_entity safety_equipment - physical_entity uv_disinfection_unit - physical_entity personnel_group - physical_entity turnover_team_member - personnel_group infection_control_rep - personnel_group bed_subtype_a - bed_unit bed_subtype_b - bed_unit)
  (:predicates
    (portable_cleaning_kit_available ?portable_cleaning_kit - portable_cleaning_kit)
    (cleaning_protocol_applied ?bed_unit - bed_unit ?cleaning_protocol - cleaning_protocol)
    (cleaning_sequence_complete ?bed_unit - bed_unit)
    (evs_assigned ?bed_unit - bed_unit ?evs_technician - evs_technician)
    (turnover_team_link ?bed_unit - bed_unit ?personnel_group - personnel_group)
    (disinfectant_kit_available ?disinfectant_kit - disinfectant_kit)
    (cleaning_protocol_available ?cleaning_protocol - cleaning_protocol)
    (uv_unit_compatible ?bed_unit - bed_unit ?uv_disinfection_unit - uv_disinfection_unit)
    (ready_for_patient ?bed_unit - bed_unit)
    (is_bed_subtype_a ?bed_unit - bed_unit)
    (technician_eligible ?bed_unit - bed_unit ?evs_technician - evs_technician)
    (charge_nurse_available ?charge_nurse - charge_nurse)
    (safety_equipment_available ?safety_equipment - safety_equipment)
    (cleaning_cart_available ?cleaning_cart - cleaning_cart)
    (clinical_signoff_present ?bed_unit - bed_unit)
    (protocol_applicable ?bed_unit - bed_unit ?cleaning_protocol - cleaning_protocol)
    (uv_unit_allocated ?bed_unit - bed_unit ?uv_disinfection_unit - uv_disinfection_unit)
    (clinical_signoff_scheduled ?bed_unit - bed_unit ?charge_nurse - charge_nurse)
    (audit_initiated ?bed_unit - bed_unit)
    (disinfectant_kit_compatible ?bed_unit - bed_unit ?disinfectant_kit - disinfectant_kit)
    (uv_unit_available ?uv_disinfection_unit - uv_disinfection_unit)
    (is_bed_subtype_b ?bed_unit - bed_unit)
    (inspection_completed ?bed_unit - bed_unit)
    (linen_cart_compatible ?bed_unit - bed_unit ?linen_cart - linen_cart)
    (linen_cart_allocated ?bed_unit - bed_unit ?linen_cart - linen_cart)
    (remediation_required_flag ?bed_unit - bed_unit)
    (cleaning_cart_attached ?bed_unit - bed_unit ?cleaning_cart - cleaning_cart)
    (supervisor_signoff_recorded ?bed_unit - bed_unit)
    (safety_equipment_required ?bed_unit - bed_unit ?safety_equipment - safety_equipment)
    (bed_registered ?bed_unit - bed_unit)
    (evs_technician_available ?evs_technician - evs_technician)
    (evs_assignment_active ?bed_unit - bed_unit)
    (checklist_form_available ?checklist_form - checklist_form)
    (audit_tablet_available ?audit_tablet - audit_tablet)
    (disinfectant_kit_allocated ?bed_unit - bed_unit ?disinfectant_kit - disinfectant_kit)
    (tablet_reserved_for_bed ?bed_unit - bed_unit ?audit_tablet - audit_tablet)
    (initial_cleaning_completed ?bed_unit - bed_unit)
    (ready_for_audit ?bed_unit - bed_unit)
    (tablet_pairing_available ?bed_unit - bed_unit ?audit_tablet - audit_tablet)
    (linen_cart_available ?linen_cart - linen_cart)
    (tablet_compatible_with_bed ?bed_unit - bed_unit ?audit_tablet - audit_tablet)
    (charge_nurse_responsible ?bed_unit - bed_unit ?charge_nurse - charge_nurse)
    (portable_cleaning_kit_used ?bed_unit - bed_unit)
    (tablet_assigned ?bed_unit - bed_unit ?audit_tablet - audit_tablet)
  )
  (:action release_uv_unit_from_bed
    :parameters (?bed_unit - bed_unit ?uv_disinfection_unit - uv_disinfection_unit)
    :precondition
      (and
        (uv_unit_allocated ?bed_unit ?uv_disinfection_unit)
      )
    :effect
      (and
        (uv_unit_available ?uv_disinfection_unit)
        (not
          (uv_unit_allocated ?bed_unit ?uv_disinfection_unit)
        )
      )
  )
  (:action initiate_infection_control_governance_audit
    :parameters (?bed_unit - bed_unit ?disinfectant_kit - disinfectant_kit ?uv_disinfection_unit - uv_disinfection_unit ?infection_control_rep - infection_control_rep)
    :precondition
      (and
        (not
          (audit_initiated ?bed_unit)
        )
        (clinical_signoff_present ?bed_unit)
        (inspection_completed ?bed_unit)
        (uv_unit_allocated ?bed_unit ?uv_disinfection_unit)
        (turnover_team_link ?bed_unit ?infection_control_rep)
        (disinfectant_kit_allocated ?bed_unit ?disinfectant_kit)
      )
    :effect
      (and
        (portable_cleaning_kit_used ?bed_unit)
        (audit_initiated ?bed_unit)
      )
  )
  (:action finalize_bed_ready_standard
    :parameters (?bed_unit - bed_unit)
    :precondition
      (and
        (inspection_completed ?bed_unit)
        (evs_assignment_active ?bed_unit)
        (clinical_signoff_present ?bed_unit)
        (bed_registered ?bed_unit)
        (ready_for_audit ?bed_unit)
        (not
          (ready_for_patient ?bed_unit)
        )
        (is_bed_subtype_a ?bed_unit)
        (audit_initiated ?bed_unit)
      )
    :effect
      (and
        (ready_for_patient ?bed_unit)
      )
  )
  (:action resolve_remediation_requirement
    :parameters (?bed_unit - bed_unit ?linen_cart - linen_cart ?cleaning_protocol - cleaning_protocol)
    :precondition
      (and
        (clinical_signoff_present ?bed_unit)
        (remediation_required_flag ?bed_unit)
        (linen_cart_allocated ?bed_unit ?linen_cart)
        (cleaning_protocol_applied ?bed_unit ?cleaning_protocol)
      )
    :effect
      (and
        (not
          (remediation_required_flag ?bed_unit)
        )
        (not
          (portable_cleaning_kit_used ?bed_unit)
        )
      )
  )
  (:action attach_cleaning_cart_to_bed
    :parameters (?bed_unit - bed_unit ?cleaning_cart - cleaning_cart)
    :precondition
      (and
        (cleaning_cart_available ?cleaning_cart)
        (bed_registered ?bed_unit)
      )
    :effect
      (and
        (not
          (cleaning_cart_available ?cleaning_cart)
        )
        (cleaning_cart_attached ?bed_unit ?cleaning_cart)
      )
  )
  (:action initiate_governance_audit
    :parameters (?bed_unit - bed_unit ?linen_cart - linen_cart ?cleaning_protocol - cleaning_protocol ?turnover_team_member - turnover_team_member)
    :precondition
      (and
        (turnover_team_link ?bed_unit ?turnover_team_member)
        (inspection_completed ?bed_unit)
        (not
          (portable_cleaning_kit_used ?bed_unit)
        )
        (linen_cart_allocated ?bed_unit ?linen_cart)
        (clinical_signoff_present ?bed_unit)
        (cleaning_protocol_applied ?bed_unit ?cleaning_protocol)
        (not
          (audit_initiated ?bed_unit)
        )
      )
    :effect
      (and
        (audit_initiated ?bed_unit)
      )
  )
  (:action use_audit_tablet_inspection
    :parameters (?bed_unit - bed_unit ?audit_tablet - audit_tablet)
    :precondition
      (and
        (evs_assignment_active ?bed_unit)
        (tablet_assigned ?bed_unit ?audit_tablet)
        (not
          (inspection_completed ?bed_unit)
        )
      )
    :effect
      (and
        (inspection_completed ?bed_unit)
        (not
          (portable_cleaning_kit_used ?bed_unit)
        )
      )
  )
  (:action allocate_disinfectant_kit_to_bed
    :parameters (?bed_unit - bed_unit ?disinfectant_kit - disinfectant_kit)
    :precondition
      (and
        (disinfectant_kit_compatible ?bed_unit ?disinfectant_kit)
        (bed_registered ?bed_unit)
        (disinfectant_kit_available ?disinfectant_kit)
      )
    :effect
      (and
        (disinfectant_kit_allocated ?bed_unit ?disinfectant_kit)
        (not
          (disinfectant_kit_available ?disinfectant_kit)
        )
      )
  )
  (:action allocate_linen_cart_to_bed
    :parameters (?bed_unit - bed_unit ?linen_cart - linen_cart)
    :precondition
      (and
        (bed_registered ?bed_unit)
        (linen_cart_available ?linen_cart)
        (linen_cart_compatible ?bed_unit ?linen_cart)
      )
    :effect
      (and
        (not
          (linen_cart_available ?linen_cart)
        )
        (linen_cart_allocated ?bed_unit ?linen_cart)
      )
  )
  (:action release_disinfectant_kit_from_bed
    :parameters (?bed_unit - bed_unit ?disinfectant_kit - disinfectant_kit)
    :precondition
      (and
        (disinfectant_kit_allocated ?bed_unit ?disinfectant_kit)
      )
    :effect
      (and
        (disinfectant_kit_available ?disinfectant_kit)
        (not
          (disinfectant_kit_allocated ?bed_unit ?disinfectant_kit)
        )
      )
  )
  (:action release_cleaning_protocol_from_bed
    :parameters (?bed_unit - bed_unit ?cleaning_protocol - cleaning_protocol)
    :precondition
      (and
        (cleaning_protocol_applied ?bed_unit ?cleaning_protocol)
      )
    :effect
      (and
        (cleaning_protocol_available ?cleaning_protocol)
        (not
          (cleaning_protocol_applied ?bed_unit ?cleaning_protocol)
        )
      )
  )
  (:action reserve_audit_tablet_for_bed
    :parameters (?bed_unit - bed_unit ?audit_tablet - audit_tablet)
    :precondition
      (and
        (ready_for_audit ?bed_unit)
        (audit_tablet_available ?audit_tablet)
        (tablet_pairing_available ?bed_unit ?audit_tablet)
      )
    :effect
      (and
        (tablet_reserved_for_bed ?bed_unit ?audit_tablet)
        (not
          (audit_tablet_available ?audit_tablet)
        )
      )
  )
  (:action allocate_cleaning_protocol_to_bed
    :parameters (?bed_unit - bed_unit ?cleaning_protocol - cleaning_protocol)
    :precondition
      (and
        (bed_registered ?bed_unit)
        (cleaning_protocol_available ?cleaning_protocol)
        (protocol_applicable ?bed_unit ?cleaning_protocol)
      )
    :effect
      (and
        (cleaning_protocol_applied ?bed_unit ?cleaning_protocol)
        (not
          (cleaning_protocol_available ?cleaning_protocol)
        )
      )
  )
  (:action assign_charge_nurse_for_signoff
    :parameters (?bed_unit - bed_unit ?charge_nurse - charge_nurse ?linen_cart - linen_cart ?cleaning_protocol - cleaning_protocol)
    :precondition
      (and
        (evs_assignment_active ?bed_unit)
        (charge_nurse_available ?charge_nurse)
        (charge_nurse_responsible ?bed_unit ?charge_nurse)
        (not
          (clinical_signoff_present ?bed_unit)
        )
        (cleaning_protocol_applied ?bed_unit ?cleaning_protocol)
        (linen_cart_allocated ?bed_unit ?linen_cart)
      )
    :effect
      (and
        (clinical_signoff_scheduled ?bed_unit ?charge_nurse)
        (not
          (charge_nurse_available ?charge_nurse)
        )
        (clinical_signoff_present ?bed_unit)
      )
  )
  (:action complete_governance_and_prepare_for_final_check
    :parameters (?bed_unit - bed_unit ?linen_cart - linen_cart ?cleaning_protocol - cleaning_protocol)
    :precondition
      (and
        (linen_cart_allocated ?bed_unit ?linen_cart)
        (audit_initiated ?bed_unit)
        (cleaning_protocol_applied ?bed_unit ?cleaning_protocol)
        (portable_cleaning_kit_used ?bed_unit)
      )
    :effect
      (and
        (not
          (remediation_required_flag ?bed_unit)
        )
        (not
          (portable_cleaning_kit_used ?bed_unit)
        )
        (not
          (inspection_completed ?bed_unit)
        )
        (cleaning_sequence_complete ?bed_unit)
      )
  )
  (:action detach_cleaning_cart_from_bed
    :parameters (?bed_unit - bed_unit ?cleaning_cart - cleaning_cart)
    :precondition
      (and
        (cleaning_cart_attached ?bed_unit ?cleaning_cart)
      )
    :effect
      (and
        (cleaning_cart_available ?cleaning_cart)
        (not
          (cleaning_cart_attached ?bed_unit ?cleaning_cart)
        )
      )
  )
  (:action complete_local_inspection_with_checklist
    :parameters (?bed_unit - bed_unit ?cleaning_cart - cleaning_cart ?checklist_form - checklist_form)
    :precondition
      (and
        (not
          (inspection_completed ?bed_unit)
        )
        (evs_assignment_active ?bed_unit)
        (checklist_form_available ?checklist_form)
        (cleaning_cart_attached ?bed_unit ?cleaning_cart)
        (initial_cleaning_completed ?bed_unit)
      )
    :effect
      (and
        (not
          (portable_cleaning_kit_used ?bed_unit)
        )
        (inspection_completed ?bed_unit)
      )
  )
  (:action finalize_bed_ready_alternate
    :parameters (?bed_unit - bed_unit)
    :precondition
      (and
        (bed_registered ?bed_unit)
        (is_bed_subtype_b ?bed_unit)
        (supervisor_signoff_recorded ?bed_unit)
        (evs_assignment_active ?bed_unit)
        (inspection_completed ?bed_unit)
        (not
          (ready_for_patient ?bed_unit)
        )
        (ready_for_audit ?bed_unit)
        (clinical_signoff_present ?bed_unit)
        (audit_initiated ?bed_unit)
      )
    :effect
      (and
        (ready_for_patient ?bed_unit)
      )
  )
  (:action record_supervisor_signoff_on_bed
    :parameters (?bed_unit - bed_unit ?cleaning_cart - cleaning_cart ?checklist_form - checklist_form)
    :precondition
      (and
        (inspection_completed ?bed_unit)
        (checklist_form_available ?checklist_form)
        (not
          (supervisor_signoff_recorded ?bed_unit)
        )
        (ready_for_audit ?bed_unit)
        (bed_registered ?bed_unit)
        (is_bed_subtype_b ?bed_unit)
        (cleaning_cart_attached ?bed_unit ?cleaning_cart)
      )
    :effect
      (and
        (supervisor_signoff_recorded ?bed_unit)
      )
  )
  (:action release_linen_cart_from_bed
    :parameters (?bed_unit - bed_unit ?linen_cart - linen_cart)
    :precondition
      (and
        (linen_cart_allocated ?bed_unit ?linen_cart)
      )
    :effect
      (and
        (linen_cart_available ?linen_cart)
        (not
          (linen_cart_allocated ?bed_unit ?linen_cart)
        )
      )
  )
  (:action allocate_uv_unit_to_bed
    :parameters (?bed_unit - bed_unit ?uv_disinfection_unit - uv_disinfection_unit)
    :precondition
      (and
        (uv_unit_available ?uv_disinfection_unit)
        (bed_registered ?bed_unit)
        (uv_unit_compatible ?bed_unit ?uv_disinfection_unit)
      )
    :effect
      (and
        (uv_unit_allocated ?bed_unit ?uv_disinfection_unit)
        (not
          (uv_unit_available ?uv_disinfection_unit)
        )
      )
  )
  (:action register_bed_for_turnover
    :parameters (?bed_unit - bed_unit)
    :precondition
      (and
        (not
          (bed_registered ?bed_unit)
        )
        (not
          (ready_for_patient ?bed_unit)
        )
      )
    :effect
      (and
        (bed_registered ?bed_unit)
      )
  )
  (:action use_portable_cleaning_kit
    :parameters (?bed_unit - bed_unit ?portable_cleaning_kit - portable_cleaning_kit)
    :precondition
      (and
        (not
          (initial_cleaning_completed ?bed_unit)
        )
        (bed_registered ?bed_unit)
        (portable_cleaning_kit_available ?portable_cleaning_kit)
        (evs_assignment_active ?bed_unit)
      )
    :effect
      (and
        (portable_cleaning_kit_used ?bed_unit)
        (not
          (portable_cleaning_kit_available ?portable_cleaning_kit)
        )
        (initial_cleaning_completed ?bed_unit)
      )
  )
  (:action perform_infection_control_audit
    :parameters (?bed_unit - bed_unit ?charge_nurse - charge_nurse ?disinfectant_kit - disinfectant_kit ?safety_equipment - safety_equipment)
    :precondition
      (and
        (safety_equipment_available ?safety_equipment)
        (safety_equipment_required ?bed_unit ?safety_equipment)
        (not
          (clinical_signoff_present ?bed_unit)
        )
        (evs_assignment_active ?bed_unit)
        (charge_nurse_available ?charge_nurse)
        (charge_nurse_responsible ?bed_unit ?charge_nurse)
        (disinfectant_kit_allocated ?bed_unit ?disinfectant_kit)
      )
    :effect
      (and
        (clinical_signoff_scheduled ?bed_unit ?charge_nurse)
        (not
          (safety_equipment_available ?safety_equipment)
        )
        (remediation_required_flag ?bed_unit)
        (not
          (charge_nurse_available ?charge_nurse)
        )
        (portable_cleaning_kit_used ?bed_unit)
        (clinical_signoff_present ?bed_unit)
      )
  )
  (:action mark_ready_for_audit_with_portable_kit
    :parameters (?bed_unit - bed_unit ?portable_cleaning_kit - portable_cleaning_kit)
    :precondition
      (and
        (portable_cleaning_kit_available ?portable_cleaning_kit)
        (not
          (portable_cleaning_kit_used ?bed_unit)
        )
        (inspection_completed ?bed_unit)
        (audit_initiated ?bed_unit)
        (not
          (ready_for_audit ?bed_unit)
        )
      )
    :effect
      (and
        (ready_for_audit ?bed_unit)
        (not
          (portable_cleaning_kit_available ?portable_cleaning_kit)
        )
      )
  )
  (:action release_evs_assignment
    :parameters (?bed_unit - bed_unit ?evs_technician - evs_technician)
    :precondition
      (and
        (evs_assigned ?bed_unit ?evs_technician)
        (not
          (audit_initiated ?bed_unit)
        )
        (not
          (clinical_signoff_present ?bed_unit)
        )
      )
    :effect
      (and
        (not
          (evs_assigned ?bed_unit ?evs_technician)
        )
        (evs_technician_available ?evs_technician)
        (not
          (evs_assignment_active ?bed_unit)
        )
        (not
          (initial_cleaning_completed ?bed_unit)
        )
        (not
          (cleaning_sequence_complete ?bed_unit)
        )
        (not
          (inspection_completed ?bed_unit)
        )
        (not
          (remediation_required_flag ?bed_unit)
        )
        (not
          (portable_cleaning_kit_used ?bed_unit)
        )
      )
  )
  (:action mark_ready_for_audit_with_cart
    :parameters (?bed_unit - bed_unit ?cleaning_cart - cleaning_cart)
    :precondition
      (and
        (not
          (ready_for_audit ?bed_unit)
        )
        (cleaning_cart_attached ?bed_unit ?cleaning_cart)
        (inspection_completed ?bed_unit)
        (audit_initiated ?bed_unit)
        (not
          (portable_cleaning_kit_used ?bed_unit)
        )
      )
    :effect
      (and
        (ready_for_audit ?bed_unit)
      )
  )
  (:action finalize_bed_ready_with_tablet
    :parameters (?bed_unit - bed_unit ?audit_tablet - audit_tablet)
    :precondition
      (and
        (ready_for_audit ?bed_unit)
        (audit_initiated ?bed_unit)
        (clinical_signoff_present ?bed_unit)
        (tablet_assigned ?bed_unit ?audit_tablet)
        (inspection_completed ?bed_unit)
        (evs_assignment_active ?bed_unit)
        (bed_registered ?bed_unit)
        (not
          (ready_for_patient ?bed_unit)
        )
        (is_bed_subtype_b ?bed_unit)
      )
    :effect
      (and
        (ready_for_patient ?bed_unit)
      )
  )
  (:action mark_initial_cleaning_completed
    :parameters (?bed_unit - bed_unit ?cleaning_cart - cleaning_cart)
    :precondition
      (and
        (bed_registered ?bed_unit)
        (evs_assignment_active ?bed_unit)
        (not
          (initial_cleaning_completed ?bed_unit)
        )
        (cleaning_cart_attached ?bed_unit ?cleaning_cart)
      )
    :effect
      (and
        (initial_cleaning_completed ?bed_unit)
      )
  )
  (:action assign_evs_technician_to_bed
    :parameters (?bed_unit - bed_unit ?evs_technician - evs_technician)
    :precondition
      (and
        (not
          (evs_assignment_active ?bed_unit)
        )
        (bed_registered ?bed_unit)
        (evs_technician_available ?evs_technician)
        (technician_eligible ?bed_unit ?evs_technician)
      )
    :effect
      (and
        (evs_assignment_active ?bed_unit)
        (not
          (evs_technician_available ?evs_technician)
        )
        (evs_assigned ?bed_unit ?evs_technician)
      )
  )
  (:action perform_followup_local_inspection
    :parameters (?bed_unit - bed_unit ?cleaning_cart - cleaning_cart ?checklist_form - checklist_form)
    :precondition
      (and
        (evs_assignment_active ?bed_unit)
        (not
          (inspection_completed ?bed_unit)
        )
        (cleaning_cart_attached ?bed_unit ?cleaning_cart)
        (audit_initiated ?bed_unit)
        (checklist_form_available ?checklist_form)
        (cleaning_sequence_complete ?bed_unit)
      )
    :effect
      (and
        (inspection_completed ?bed_unit)
      )
  )
  (:action supervisor_assign_reserved_tablet_to_isolation_bed
    :parameters (?bed_subtype_b - bed_subtype_b ?bed_subtype_a - bed_subtype_a ?audit_tablet - audit_tablet)
    :precondition
      (and
        (bed_registered ?bed_subtype_b)
        (tablet_reserved_for_bed ?bed_subtype_a ?audit_tablet)
        (is_bed_subtype_b ?bed_subtype_b)
        (not
          (tablet_assigned ?bed_subtype_b ?audit_tablet)
        )
        (tablet_compatible_with_bed ?bed_subtype_b ?audit_tablet)
      )
    :effect
      (and
        (tablet_assigned ?bed_subtype_b ?audit_tablet)
      )
  )
)

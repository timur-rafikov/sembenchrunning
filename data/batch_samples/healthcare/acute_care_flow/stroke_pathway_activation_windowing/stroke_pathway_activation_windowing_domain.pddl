(define (domain acute_stroke_activation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types patient_case - object transport_unit - object procedure_slot - object imaging_technologist - object stroke_nurse - object critical_care_bed - object telemedicine_link - object on_call_consultant - object intervention_team - object equipment_package - object angiography_room - object medication_kit - object shift_assignment - object intervention_team_shift - shift_assignment anesthesia_team_shift - shift_assignment pre_hospital_patient - patient_case teletriage_patient - patient_case)
  (:predicates
    (case_registered ?case - patient_case)
    (assigned_transport ?case - patient_case ?transport_unit - transport_unit)
    (transport_allocated ?case - patient_case)
    (specialist_engaged ?case - patient_case)
    (case_ready_for_procedure ?case - patient_case)
    (stroke_nurse_assigned ?case - patient_case ?stroke_nurse - stroke_nurse)
    (imaging_technologist_assigned ?case - patient_case ?imaging_technologist - imaging_technologist)
    (bed_assigned ?case - patient_case ?critical_care_bed - critical_care_bed)
    (medication_kit_allocated ?case - patient_case ?medication_kit - medication_kit)
    (procedure_slot_reserved ?case - patient_case ?procedure_slot - procedure_slot)
    (procedure_confirmed ?case - patient_case)
    (preprocedure_checks_completed ?case - patient_case)
    (final_preprocedure_check_completed ?case - patient_case)
    (case_closed ?case - patient_case)
    (requires_additional_preparation ?case - patient_case)
    (intervention_signoff_complete ?case - patient_case)
    (preassigned_intervention_team ?case - patient_case ?intervention_team - intervention_team)
    (intervention_team_notified ?case - patient_case ?intervention_team - intervention_team)
    (patient_transferred_to_intervention_area ?case - patient_case)
    (transport_available ?transport_unit - transport_unit)
    (procedure_slot_available ?procedure_slot - procedure_slot)
    (stroke_nurse_available ?stroke_nurse - stroke_nurse)
    (imaging_technologist_available ?imaging_technologist - imaging_technologist)
    (bed_available ?critical_care_bed - critical_care_bed)
    (telemedicine_link_available ?telemedicine_link - telemedicine_link)
    (consultant_on_call ?on_call_consultant - on_call_consultant)
    (intervention_team_available ?intervention_team - intervention_team)
    (equipment_package_available ?equipment_package - equipment_package)
    (angiography_room_available ?angiography_room - angiography_room)
    (medication_kit_available ?medication_kit - medication_kit)
    (transport_compatible ?case - patient_case ?transport_unit - transport_unit)
    (slot_compatible_with_case ?case - patient_case ?procedure_slot - procedure_slot)
    (stroke_nurse_compatible_with_case ?case - patient_case ?stroke_nurse - stroke_nurse)
    (imaging_technologist_compatible ?case - patient_case ?imaging_technologist - imaging_technologist)
    (bed_suitable_for_case ?case - patient_case ?critical_care_bed - critical_care_bed)
    (angiography_room_suitable ?case - patient_case ?angiography_room - angiography_room)
    (medication_kit_suitable ?case - patient_case ?medication_kit - medication_kit)
    (shift_assignment_compatible ?case - patient_case ?shift_assignment - shift_assignment)
    (intervention_team_assigned ?case - patient_case ?intervention_team - intervention_team)
    (within_activation_window ?case - patient_case)
    (teletriage_entry ?case - patient_case)
    (telemedicine_link_allocated ?case - patient_case ?telemedicine_link - telemedicine_link)
    (imaging_review_complete ?case - patient_case)
    (intervention_team_compatible ?case - patient_case ?intervention_team - intervention_team)
  )
  (:action register_case
    :parameters (?case - patient_case)
    :precondition
      (and
        (not
          (case_registered ?case)
        )
        (not
          (case_closed ?case)
        )
      )
    :effect
      (and
        (case_registered ?case)
      )
  )
  (:action assign_transport
    :parameters (?case - patient_case ?transport_unit - transport_unit)
    :precondition
      (and
        (case_registered ?case)
        (transport_available ?transport_unit)
        (transport_compatible ?case ?transport_unit)
        (not
          (transport_allocated ?case)
        )
      )
    :effect
      (and
        (assigned_transport ?case ?transport_unit)
        (transport_allocated ?case)
        (not
          (transport_available ?transport_unit)
        )
      )
  )
  (:action release_transport
    :parameters (?case - patient_case ?transport_unit - transport_unit)
    :precondition
      (and
        (assigned_transport ?case ?transport_unit)
        (not
          (procedure_confirmed ?case)
        )
        (not
          (preprocedure_checks_completed ?case)
        )
      )
    :effect
      (and
        (not
          (assigned_transport ?case ?transport_unit)
        )
        (not
          (transport_allocated ?case)
        )
        (not
          (specialist_engaged ?case)
        )
        (not
          (case_ready_for_procedure ?case)
        )
        (not
          (requires_additional_preparation ?case)
        )
        (not
          (intervention_signoff_complete ?case)
        )
        (not
          (imaging_review_complete ?case)
        )
        (transport_available ?transport_unit)
      )
  )
  (:action reserve_telemedicine_link
    :parameters (?case - patient_case ?telemedicine_link - telemedicine_link)
    :precondition
      (and
        (case_registered ?case)
        (telemedicine_link_available ?telemedicine_link)
      )
    :effect
      (and
        (telemedicine_link_allocated ?case ?telemedicine_link)
        (not
          (telemedicine_link_available ?telemedicine_link)
        )
      )
  )
  (:action release_telemedicine_link
    :parameters (?case - patient_case ?telemedicine_link - telemedicine_link)
    :precondition
      (and
        (telemedicine_link_allocated ?case ?telemedicine_link)
      )
    :effect
      (and
        (telemedicine_link_available ?telemedicine_link)
        (not
          (telemedicine_link_allocated ?case ?telemedicine_link)
        )
      )
  )
  (:action engage_specialist_via_telemedicine
    :parameters (?case - patient_case ?telemedicine_link - telemedicine_link)
    :precondition
      (and
        (case_registered ?case)
        (transport_allocated ?case)
        (telemedicine_link_allocated ?case ?telemedicine_link)
        (not
          (specialist_engaged ?case)
        )
      )
    :effect
      (and
        (specialist_engaged ?case)
      )
  )
  (:action engage_on_call_consultant
    :parameters (?case - patient_case ?on_call_consultant - on_call_consultant)
    :precondition
      (and
        (case_registered ?case)
        (transport_allocated ?case)
        (consultant_on_call ?on_call_consultant)
        (not
          (specialist_engaged ?case)
        )
      )
    :effect
      (and
        (specialist_engaged ?case)
        (requires_additional_preparation ?case)
        (not
          (consultant_on_call ?on_call_consultant)
        )
      )
  )
  (:action confirm_equipment_and_mark_ready
    :parameters (?case - patient_case ?telemedicine_link - telemedicine_link ?equipment_package - equipment_package)
    :precondition
      (and
        (specialist_engaged ?case)
        (transport_allocated ?case)
        (telemedicine_link_allocated ?case ?telemedicine_link)
        (equipment_package_available ?equipment_package)
        (not
          (case_ready_for_procedure ?case)
        )
      )
    :effect
      (and
        (case_ready_for_procedure ?case)
        (not
          (requires_additional_preparation ?case)
        )
      )
  )
  (:action confirm_procedural_prerequisites_with_team
    :parameters (?case - patient_case ?intervention_team - intervention_team)
    :precondition
      (and
        (transport_allocated ?case)
        (intervention_team_notified ?case ?intervention_team)
        (not
          (case_ready_for_procedure ?case)
        )
      )
    :effect
      (and
        (case_ready_for_procedure ?case)
        (not
          (requires_additional_preparation ?case)
        )
      )
  )
  (:action reserve_nurse
    :parameters (?case - patient_case ?stroke_nurse - stroke_nurse)
    :precondition
      (and
        (case_registered ?case)
        (stroke_nurse_available ?stroke_nurse)
        (stroke_nurse_compatible_with_case ?case ?stroke_nurse)
      )
    :effect
      (and
        (stroke_nurse_assigned ?case ?stroke_nurse)
        (not
          (stroke_nurse_available ?stroke_nurse)
        )
      )
  )
  (:action release_nurse
    :parameters (?case - patient_case ?stroke_nurse - stroke_nurse)
    :precondition
      (and
        (stroke_nurse_assigned ?case ?stroke_nurse)
      )
    :effect
      (and
        (stroke_nurse_available ?stroke_nurse)
        (not
          (stroke_nurse_assigned ?case ?stroke_nurse)
        )
      )
  )
  (:action reserve_imaging_technologist
    :parameters (?case - patient_case ?imaging_technologist - imaging_technologist)
    :precondition
      (and
        (case_registered ?case)
        (imaging_technologist_available ?imaging_technologist)
        (imaging_technologist_compatible ?case ?imaging_technologist)
      )
    :effect
      (and
        (imaging_technologist_assigned ?case ?imaging_technologist)
        (not
          (imaging_technologist_available ?imaging_technologist)
        )
      )
  )
  (:action release_imaging_technologist
    :parameters (?case - patient_case ?imaging_technologist - imaging_technologist)
    :precondition
      (and
        (imaging_technologist_assigned ?case ?imaging_technologist)
      )
    :effect
      (and
        (imaging_technologist_available ?imaging_technologist)
        (not
          (imaging_technologist_assigned ?case ?imaging_technologist)
        )
      )
  )
  (:action reserve_bed
    :parameters (?case - patient_case ?critical_care_bed - critical_care_bed)
    :precondition
      (and
        (case_registered ?case)
        (bed_available ?critical_care_bed)
        (bed_suitable_for_case ?case ?critical_care_bed)
      )
    :effect
      (and
        (bed_assigned ?case ?critical_care_bed)
        (not
          (bed_available ?critical_care_bed)
        )
      )
  )
  (:action release_bed
    :parameters (?case - patient_case ?critical_care_bed - critical_care_bed)
    :precondition
      (and
        (bed_assigned ?case ?critical_care_bed)
      )
    :effect
      (and
        (bed_available ?critical_care_bed)
        (not
          (bed_assigned ?case ?critical_care_bed)
        )
      )
  )
  (:action reserve_medication_kit
    :parameters (?case - patient_case ?medication_kit - medication_kit)
    :precondition
      (and
        (case_registered ?case)
        (medication_kit_available ?medication_kit)
        (medication_kit_suitable ?case ?medication_kit)
      )
    :effect
      (and
        (medication_kit_allocated ?case ?medication_kit)
        (not
          (medication_kit_available ?medication_kit)
        )
      )
  )
  (:action release_medication_kit
    :parameters (?case - patient_case ?medication_kit - medication_kit)
    :precondition
      (and
        (medication_kit_allocated ?case ?medication_kit)
      )
    :effect
      (and
        (medication_kit_available ?medication_kit)
        (not
          (medication_kit_allocated ?case ?medication_kit)
        )
      )
  )
  (:action perform_clinical_assessment_and_schedule
    :parameters (?case - patient_case ?procedure_slot - procedure_slot ?stroke_nurse - stroke_nurse ?imaging_technologist - imaging_technologist)
    :precondition
      (and
        (transport_allocated ?case)
        (stroke_nurse_assigned ?case ?stroke_nurse)
        (imaging_technologist_assigned ?case ?imaging_technologist)
        (procedure_slot_available ?procedure_slot)
        (slot_compatible_with_case ?case ?procedure_slot)
        (not
          (procedure_confirmed ?case)
        )
      )
    :effect
      (and
        (procedure_slot_reserved ?case ?procedure_slot)
        (procedure_confirmed ?case)
        (not
          (procedure_slot_available ?procedure_slot)
        )
      )
  )
  (:action perform_imaging_assessment_and_schedule
    :parameters (?case - patient_case ?procedure_slot - procedure_slot ?critical_care_bed - critical_care_bed ?angiography_room - angiography_room)
    :precondition
      (and
        (transport_allocated ?case)
        (bed_assigned ?case ?critical_care_bed)
        (angiography_room_available ?angiography_room)
        (procedure_slot_available ?procedure_slot)
        (slot_compatible_with_case ?case ?procedure_slot)
        (angiography_room_suitable ?case ?angiography_room)
        (not
          (procedure_confirmed ?case)
        )
      )
    :effect
      (and
        (procedure_slot_reserved ?case ?procedure_slot)
        (procedure_confirmed ?case)
        (imaging_review_complete ?case)
        (requires_additional_preparation ?case)
        (not
          (procedure_slot_available ?procedure_slot)
        )
        (not
          (angiography_room_available ?angiography_room)
        )
      )
  )
  (:action finalize_decision_after_assessment
    :parameters (?case - patient_case ?stroke_nurse - stroke_nurse ?imaging_technologist - imaging_technologist)
    :precondition
      (and
        (procedure_confirmed ?case)
        (imaging_review_complete ?case)
        (stroke_nurse_assigned ?case ?stroke_nurse)
        (imaging_technologist_assigned ?case ?imaging_technologist)
      )
    :effect
      (and
        (not
          (imaging_review_complete ?case)
        )
        (not
          (requires_additional_preparation ?case)
        )
      )
  )
  (:action confirm_team_and_signoff_pathway
    :parameters (?case - patient_case ?stroke_nurse - stroke_nurse ?imaging_technologist - imaging_technologist ?intervention_team_shift - intervention_team_shift)
    :precondition
      (and
        (case_ready_for_procedure ?case)
        (procedure_confirmed ?case)
        (stroke_nurse_assigned ?case ?stroke_nurse)
        (imaging_technologist_assigned ?case ?imaging_technologist)
        (shift_assignment_compatible ?case ?intervention_team_shift)
        (not
          (requires_additional_preparation ?case)
        )
        (not
          (preprocedure_checks_completed ?case)
        )
      )
    :effect
      (and
        (preprocedure_checks_completed ?case)
      )
  )
  (:action confirm_complex_team_and_signoff
    :parameters (?case - patient_case ?critical_care_bed - critical_care_bed ?medication_kit - medication_kit ?anesthesia_team_shift - anesthesia_team_shift)
    :precondition
      (and
        (case_ready_for_procedure ?case)
        (procedure_confirmed ?case)
        (bed_assigned ?case ?critical_care_bed)
        (medication_kit_allocated ?case ?medication_kit)
        (shift_assignment_compatible ?case ?anesthesia_team_shift)
        (not
          (preprocedure_checks_completed ?case)
        )
      )
    :effect
      (and
        (preprocedure_checks_completed ?case)
        (requires_additional_preparation ?case)
      )
  )
  (:action authorize_intervention_and_allocate
    :parameters (?case - patient_case ?stroke_nurse - stroke_nurse ?imaging_technologist - imaging_technologist)
    :precondition
      (and
        (preprocedure_checks_completed ?case)
        (requires_additional_preparation ?case)
        (stroke_nurse_assigned ?case ?stroke_nurse)
        (imaging_technologist_assigned ?case ?imaging_technologist)
      )
    :effect
      (and
        (intervention_signoff_complete ?case)
        (not
          (requires_additional_preparation ?case)
        )
        (not
          (case_ready_for_procedure ?case)
        )
        (not
          (imaging_review_complete ?case)
        )
      )
  )
  (:action prepare_intervention_with_equipment
    :parameters (?case - patient_case ?telemedicine_link - telemedicine_link ?equipment_package - equipment_package)
    :precondition
      (and
        (intervention_signoff_complete ?case)
        (preprocedure_checks_completed ?case)
        (transport_allocated ?case)
        (telemedicine_link_allocated ?case ?telemedicine_link)
        (equipment_package_available ?equipment_package)
        (not
          (case_ready_for_procedure ?case)
        )
      )
    :effect
      (and
        (case_ready_for_procedure ?case)
      )
  )
  (:action complete_final_preprocedure_check_link
    :parameters (?case - patient_case ?telemedicine_link - telemedicine_link)
    :precondition
      (and
        (preprocedure_checks_completed ?case)
        (case_ready_for_procedure ?case)
        (not
          (requires_additional_preparation ?case)
        )
        (telemedicine_link_allocated ?case ?telemedicine_link)
        (not
          (final_preprocedure_check_completed ?case)
        )
      )
    :effect
      (and
        (final_preprocedure_check_completed ?case)
      )
  )
  (:action complete_final_preprocedure_check_consultant
    :parameters (?case - patient_case ?on_call_consultant - on_call_consultant)
    :precondition
      (and
        (preprocedure_checks_completed ?case)
        (case_ready_for_procedure ?case)
        (not
          (requires_additional_preparation ?case)
        )
        (consultant_on_call ?on_call_consultant)
        (not
          (final_preprocedure_check_completed ?case)
        )
      )
    :effect
      (and
        (final_preprocedure_check_completed ?case)
        (not
          (consultant_on_call ?on_call_consultant)
        )
      )
  )
  (:action allocate_intervention_team
    :parameters (?case - patient_case ?intervention_team - intervention_team)
    :precondition
      (and
        (final_preprocedure_check_completed ?case)
        (intervention_team_available ?intervention_team)
        (intervention_team_compatible ?case ?intervention_team)
      )
    :effect
      (and
        (intervention_team_assigned ?case ?intervention_team)
        (not
          (intervention_team_available ?intervention_team)
        )
      )
  )
  (:action notify_intervention_team_teletriage
    :parameters (?teletriage_patient - teletriage_patient ?pre_hospital_patient - pre_hospital_patient ?intervention_team - intervention_team)
    :precondition
      (and
        (case_registered ?teletriage_patient)
        (teletriage_entry ?teletriage_patient)
        (preassigned_intervention_team ?teletriage_patient ?intervention_team)
        (intervention_team_assigned ?pre_hospital_patient ?intervention_team)
        (not
          (intervention_team_notified ?teletriage_patient ?intervention_team)
        )
      )
    :effect
      (and
        (intervention_team_notified ?teletriage_patient ?intervention_team)
      )
  )
  (:action mark_patient_ready_after_teletriage
    :parameters (?case - patient_case ?telemedicine_link - telemedicine_link ?equipment_package - equipment_package)
    :precondition
      (and
        (case_registered ?case)
        (teletriage_entry ?case)
        (case_ready_for_procedure ?case)
        (final_preprocedure_check_completed ?case)
        (telemedicine_link_allocated ?case ?telemedicine_link)
        (equipment_package_available ?equipment_package)
        (not
          (patient_transferred_to_intervention_area ?case)
        )
      )
    :effect
      (and
        (patient_transferred_to_intervention_area ?case)
      )
  )
  (:action close_case_within_window
    :parameters (?case - patient_case)
    :precondition
      (and
        (within_activation_window ?case)
        (case_registered ?case)
        (transport_allocated ?case)
        (procedure_confirmed ?case)
        (preprocedure_checks_completed ?case)
        (final_preprocedure_check_completed ?case)
        (case_ready_for_procedure ?case)
        (not
          (case_closed ?case)
        )
      )
    :effect
      (and
        (case_closed ?case)
      )
  )
  (:action close_case_with_team_notified
    :parameters (?case - patient_case ?intervention_team - intervention_team)
    :precondition
      (and
        (teletriage_entry ?case)
        (case_registered ?case)
        (transport_allocated ?case)
        (procedure_confirmed ?case)
        (preprocedure_checks_completed ?case)
        (final_preprocedure_check_completed ?case)
        (case_ready_for_procedure ?case)
        (intervention_team_notified ?case ?intervention_team)
        (not
          (case_closed ?case)
        )
      )
    :effect
      (and
        (case_closed ?case)
      )
  )
  (:action close_case_after_transfer
    :parameters (?case - patient_case)
    :precondition
      (and
        (teletriage_entry ?case)
        (case_registered ?case)
        (transport_allocated ?case)
        (procedure_confirmed ?case)
        (preprocedure_checks_completed ?case)
        (final_preprocedure_check_completed ?case)
        (case_ready_for_procedure ?case)
        (patient_transferred_to_intervention_area ?case)
        (not
          (case_closed ?case)
        )
      )
    :effect
      (and
        (case_closed ?case)
      )
  )
)

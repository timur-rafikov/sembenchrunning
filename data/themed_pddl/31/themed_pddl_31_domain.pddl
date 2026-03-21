(define (domain psychiatric_safe_room_allocation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types patient_case - object intake_assessor - object psychiatric_evaluator - object restraint_kit - object medication_order_set - object transport_service - object observation_bed - object security_officer - object safe_room - object senior_clinician - object transport_equipment - object isolation_resource - object clinical_team_type - object nursing_team - clinical_team_type psychiatry_team - clinical_team_type triage_patient_case - patient_case bed_management_patient_case - patient_case)
  (:predicates
    (security_officer_available ?security_officer - security_officer)
    (restraint_kit_assigned ?patient_case - patient_case ?restraint_kit - restraint_kit)
    (ready_for_transfer ?patient_case - patient_case)
    (patient_assigned_to_assessor ?patient_case - patient_case ?intake_assessor - intake_assessor)
    (team_available_for_case ?patient_case - patient_case ?clinical_team_type - clinical_team_type)
    (transport_service_available ?transport_service - transport_service)
    (restraint_kit_available ?restraint_kit - restraint_kit)
    (isolation_resource_compatible_with_case ?patient_case - patient_case ?isolation_resource - isolation_resource)
    (admitted_safe_room ?patient_case - patient_case)
    (bed_management_preapproval ?patient_case - patient_case)
    (assessor_eligible_for_case ?patient_case - patient_case ?intake_assessor - intake_assessor)
    (evaluator_available ?psychiatric_evaluator - psychiatric_evaluator)
    (transport_equipment_available ?transport_equipment - transport_equipment)
    (observation_bed_available ?observation_bed - observation_bed)
    (evaluation_authorized ?patient_case - patient_case)
    (restraint_kit_compatible_with_case ?patient_case - patient_case ?restraint_kit - restraint_kit)
    (isolation_resource_assigned ?patient_case - patient_case ?isolation_resource - isolation_resource)
    (evaluator_assigned ?patient_case - patient_case ?psychiatric_evaluator - psychiatric_evaluator)
    (team_confirmed_ready ?patient_case - patient_case)
    (transport_service_compatible_with_case ?patient_case - patient_case ?transport_service - transport_service)
    (isolation_resource_available ?isolation_resource - isolation_resource)
    (bed_management_review ?patient_case - patient_case)
    (clinical_preparation_complete ?patient_case - patient_case)
    (medication_compatible_with_case ?patient_case - patient_case ?medication_order_set - medication_order_set)
    (medication_assigned ?patient_case - patient_case ?medication_order_set - medication_order_set)
    (enhanced_monitoring_required ?patient_case - patient_case)
    (observation_bed_assigned ?patient_case - patient_case ?observation_bed - observation_bed)
    (bed_assignment_staged ?patient_case - patient_case)
    (transport_equipment_compatible_with_case ?patient_case - patient_case ?transport_equipment - transport_equipment)
    (case_registered ?patient_case - patient_case)
    (assessor_available ?intake_assessor - intake_assessor)
    (assessment_in_progress ?patient_case - patient_case)
    (senior_clinician_available ?senior_clinician - senior_clinician)
    (safe_room_available ?safe_room - safe_room)
    (transport_service_assigned ?patient_case - patient_case ?transport_service - transport_service)
    (safe_room_assigned_to_case ?patient_case - patient_case ?safe_room - safe_room)
    (safety_measures_in_place ?patient_case - patient_case)
    (observation_bed_confirmed ?patient_case - patient_case)
    (safe_room_slot_eligible ?patient_case - patient_case ?safe_room - safe_room)
    (medication_available ?medication_order_set - medication_order_set)
    (bed_management_slot_requested ?patient_case - patient_case ?safe_room - safe_room)
    (evaluator_eligible_for_case ?patient_case - patient_case ?psychiatric_evaluator - psychiatric_evaluator)
    (security_on_scene ?patient_case - patient_case)
    (safe_room_allocation_confirmed ?patient_case - patient_case ?safe_room - safe_room)
  )
  (:action release_isolation_resource
    :parameters (?patient_case - patient_case ?isolation_resource - isolation_resource)
    :precondition
      (and
        (isolation_resource_assigned ?patient_case ?isolation_resource)
      )
    :effect
      (and
        (isolation_resource_available ?isolation_resource)
        (not
          (isolation_resource_assigned ?patient_case ?isolation_resource)
        )
      )
  )
  (:action confirm_psychiatry_team_ready_and_set_security
    :parameters (?patient_case - patient_case ?transport_service - transport_service ?isolation_resource - isolation_resource ?psychiatry_team - psychiatry_team)
    :precondition
      (and
        (not
          (team_confirmed_ready ?patient_case)
        )
        (evaluation_authorized ?patient_case)
        (clinical_preparation_complete ?patient_case)
        (isolation_resource_assigned ?patient_case ?isolation_resource)
        (team_available_for_case ?patient_case ?psychiatry_team)
        (transport_service_assigned ?patient_case ?transport_service)
      )
    :effect
      (and
        (security_on_scene ?patient_case)
        (team_confirmed_ready ?patient_case)
      )
  )
  (:action admit_case_via_preapproval
    :parameters (?patient_case - patient_case)
    :precondition
      (and
        (clinical_preparation_complete ?patient_case)
        (assessment_in_progress ?patient_case)
        (evaluation_authorized ?patient_case)
        (case_registered ?patient_case)
        (observation_bed_confirmed ?patient_case)
        (not
          (admitted_safe_room ?patient_case)
        )
        (bed_management_preapproval ?patient_case)
        (team_confirmed_ready ?patient_case)
      )
    :effect
      (and
        (admitted_safe_room ?patient_case)
      )
  )
  (:action finalize_pre_evaluation_coordination
    :parameters (?patient_case - patient_case ?medication_order_set - medication_order_set ?restraint_kit - restraint_kit)
    :precondition
      (and
        (evaluation_authorized ?patient_case)
        (enhanced_monitoring_required ?patient_case)
        (medication_assigned ?patient_case ?medication_order_set)
        (restraint_kit_assigned ?patient_case ?restraint_kit)
      )
    :effect
      (and
        (not
          (enhanced_monitoring_required ?patient_case)
        )
        (not
          (security_on_scene ?patient_case)
        )
      )
  )
  (:action assign_observation_bed
    :parameters (?patient_case - patient_case ?observation_bed - observation_bed)
    :precondition
      (and
        (observation_bed_available ?observation_bed)
        (case_registered ?patient_case)
      )
    :effect
      (and
        (not
          (observation_bed_available ?observation_bed)
        )
        (observation_bed_assigned ?patient_case ?observation_bed)
      )
  )
  (:action confirm_nursing_team_ready
    :parameters (?patient_case - patient_case ?medication_order_set - medication_order_set ?restraint_kit - restraint_kit ?nursing_team - nursing_team)
    :precondition
      (and
        (team_available_for_case ?patient_case ?nursing_team)
        (clinical_preparation_complete ?patient_case)
        (not
          (security_on_scene ?patient_case)
        )
        (medication_assigned ?patient_case ?medication_order_set)
        (evaluation_authorized ?patient_case)
        (restraint_kit_assigned ?patient_case ?restraint_kit)
        (not
          (team_confirmed_ready ?patient_case)
        )
      )
    :effect
      (and
        (team_confirmed_ready ?patient_case)
      )
  )
  (:action confirm_preparation_for_room_assignment
    :parameters (?patient_case - patient_case ?safe_room - safe_room)
    :precondition
      (and
        (assessment_in_progress ?patient_case)
        (safe_room_allocation_confirmed ?patient_case ?safe_room)
        (not
          (clinical_preparation_complete ?patient_case)
        )
      )
    :effect
      (and
        (clinical_preparation_complete ?patient_case)
        (not
          (security_on_scene ?patient_case)
        )
      )
  )
  (:action assign_transport_service
    :parameters (?patient_case - patient_case ?transport_service - transport_service)
    :precondition
      (and
        (transport_service_compatible_with_case ?patient_case ?transport_service)
        (case_registered ?patient_case)
        (transport_service_available ?transport_service)
      )
    :effect
      (and
        (transport_service_assigned ?patient_case ?transport_service)
        (not
          (transport_service_available ?transport_service)
        )
      )
  )
  (:action assign_medication_order_set
    :parameters (?patient_case - patient_case ?medication_order_set - medication_order_set)
    :precondition
      (and
        (case_registered ?patient_case)
        (medication_available ?medication_order_set)
        (medication_compatible_with_case ?patient_case ?medication_order_set)
      )
    :effect
      (and
        (not
          (medication_available ?medication_order_set)
        )
        (medication_assigned ?patient_case ?medication_order_set)
      )
  )
  (:action release_transport_service
    :parameters (?patient_case - patient_case ?transport_service - transport_service)
    :precondition
      (and
        (transport_service_assigned ?patient_case ?transport_service)
      )
    :effect
      (and
        (transport_service_available ?transport_service)
        (not
          (transport_service_assigned ?patient_case ?transport_service)
        )
      )
  )
  (:action release_restraint_kit
    :parameters (?patient_case - patient_case ?restraint_kit - restraint_kit)
    :precondition
      (and
        (restraint_kit_assigned ?patient_case ?restraint_kit)
      )
    :effect
      (and
        (restraint_kit_available ?restraint_kit)
        (not
          (restraint_kit_assigned ?patient_case ?restraint_kit)
        )
      )
  )
  (:action assign_safe_room_slot
    :parameters (?patient_case - patient_case ?safe_room - safe_room)
    :precondition
      (and
        (observation_bed_confirmed ?patient_case)
        (safe_room_available ?safe_room)
        (safe_room_slot_eligible ?patient_case ?safe_room)
      )
    :effect
      (and
        (safe_room_assigned_to_case ?patient_case ?safe_room)
        (not
          (safe_room_available ?safe_room)
        )
      )
  )
  (:action assign_restraint_kit
    :parameters (?patient_case - patient_case ?restraint_kit - restraint_kit)
    :precondition
      (and
        (case_registered ?patient_case)
        (restraint_kit_available ?restraint_kit)
        (restraint_kit_compatible_with_case ?patient_case ?restraint_kit)
      )
    :effect
      (and
        (restraint_kit_assigned ?patient_case ?restraint_kit)
        (not
          (restraint_kit_available ?restraint_kit)
        )
      )
  )
  (:action assign_psychiatric_evaluator_for_evaluation
    :parameters (?patient_case - patient_case ?psychiatric_evaluator - psychiatric_evaluator ?medication_order_set - medication_order_set ?restraint_kit - restraint_kit)
    :precondition
      (and
        (assessment_in_progress ?patient_case)
        (evaluator_available ?psychiatric_evaluator)
        (evaluator_eligible_for_case ?patient_case ?psychiatric_evaluator)
        (not
          (evaluation_authorized ?patient_case)
        )
        (restraint_kit_assigned ?patient_case ?restraint_kit)
        (medication_assigned ?patient_case ?medication_order_set)
      )
    :effect
      (and
        (evaluator_assigned ?patient_case ?psychiatric_evaluator)
        (not
          (evaluator_available ?psychiatric_evaluator)
        )
        (evaluation_authorized ?patient_case)
      )
  )
  (:action prepare_for_transfer
    :parameters (?patient_case - patient_case ?medication_order_set - medication_order_set ?restraint_kit - restraint_kit)
    :precondition
      (and
        (medication_assigned ?patient_case ?medication_order_set)
        (team_confirmed_ready ?patient_case)
        (restraint_kit_assigned ?patient_case ?restraint_kit)
        (security_on_scene ?patient_case)
      )
    :effect
      (and
        (not
          (enhanced_monitoring_required ?patient_case)
        )
        (not
          (security_on_scene ?patient_case)
        )
        (not
          (clinical_preparation_complete ?patient_case)
        )
        (ready_for_transfer ?patient_case)
      )
  )
  (:action release_observation_bed
    :parameters (?patient_case - patient_case ?observation_bed - observation_bed)
    :precondition
      (and
        (observation_bed_assigned ?patient_case ?observation_bed)
      )
    :effect
      (and
        (observation_bed_available ?observation_bed)
        (not
          (observation_bed_assigned ?patient_case ?observation_bed)
        )
      )
  )
  (:action senior_clinician_finalize_preparation
    :parameters (?patient_case - patient_case ?observation_bed - observation_bed ?senior_clinician - senior_clinician)
    :precondition
      (and
        (not
          (clinical_preparation_complete ?patient_case)
        )
        (assessment_in_progress ?patient_case)
        (senior_clinician_available ?senior_clinician)
        (observation_bed_assigned ?patient_case ?observation_bed)
        (safety_measures_in_place ?patient_case)
      )
    :effect
      (and
        (not
          (security_on_scene ?patient_case)
        )
        (clinical_preparation_complete ?patient_case)
      )
  )
  (:action admit_case_via_bed_assignment
    :parameters (?patient_case - patient_case)
    :precondition
      (and
        (case_registered ?patient_case)
        (bed_management_review ?patient_case)
        (bed_assignment_staged ?patient_case)
        (assessment_in_progress ?patient_case)
        (clinical_preparation_complete ?patient_case)
        (not
          (admitted_safe_room ?patient_case)
        )
        (observation_bed_confirmed ?patient_case)
        (evaluation_authorized ?patient_case)
        (team_confirmed_ready ?patient_case)
      )
    :effect
      (and
        (admitted_safe_room ?patient_case)
      )
  )
  (:action mark_bed_management_flag
    :parameters (?patient_case - patient_case ?observation_bed - observation_bed ?senior_clinician - senior_clinician)
    :precondition
      (and
        (clinical_preparation_complete ?patient_case)
        (senior_clinician_available ?senior_clinician)
        (not
          (bed_assignment_staged ?patient_case)
        )
        (observation_bed_confirmed ?patient_case)
        (case_registered ?patient_case)
        (bed_management_review ?patient_case)
        (observation_bed_assigned ?patient_case ?observation_bed)
      )
    :effect
      (and
        (bed_assignment_staged ?patient_case)
      )
  )
  (:action release_medication_order_set
    :parameters (?patient_case - patient_case ?medication_order_set - medication_order_set)
    :precondition
      (and
        (medication_assigned ?patient_case ?medication_order_set)
      )
    :effect
      (and
        (medication_available ?medication_order_set)
        (not
          (medication_assigned ?patient_case ?medication_order_set)
        )
      )
  )
  (:action assign_isolation_resource
    :parameters (?patient_case - patient_case ?isolation_resource - isolation_resource)
    :precondition
      (and
        (isolation_resource_available ?isolation_resource)
        (case_registered ?patient_case)
        (isolation_resource_compatible_with_case ?patient_case ?isolation_resource)
      )
    :effect
      (and
        (isolation_resource_assigned ?patient_case ?isolation_resource)
        (not
          (isolation_resource_available ?isolation_resource)
        )
      )
  )
  (:action register_patient_case
    :parameters (?patient_case - patient_case)
    :precondition
      (and
        (not
          (case_registered ?patient_case)
        )
        (not
          (admitted_safe_room ?patient_case)
        )
      )
    :effect
      (and
        (case_registered ?patient_case)
      )
  )
  (:action assign_security_officer
    :parameters (?patient_case - patient_case ?security_officer - security_officer)
    :precondition
      (and
        (not
          (safety_measures_in_place ?patient_case)
        )
        (case_registered ?patient_case)
        (security_officer_available ?security_officer)
        (assessment_in_progress ?patient_case)
      )
    :effect
      (and
        (security_on_scene ?patient_case)
        (not
          (security_officer_available ?security_officer)
        )
        (safety_measures_in_place ?patient_case)
      )
  )
  (:action assign_evaluator_with_transport_and_resources
    :parameters (?patient_case - patient_case ?psychiatric_evaluator - psychiatric_evaluator ?transport_service - transport_service ?transport_equipment - transport_equipment)
    :precondition
      (and
        (transport_equipment_available ?transport_equipment)
        (transport_equipment_compatible_with_case ?patient_case ?transport_equipment)
        (not
          (evaluation_authorized ?patient_case)
        )
        (assessment_in_progress ?patient_case)
        (evaluator_available ?psychiatric_evaluator)
        (evaluator_eligible_for_case ?patient_case ?psychiatric_evaluator)
        (transport_service_assigned ?patient_case ?transport_service)
      )
    :effect
      (and
        (evaluator_assigned ?patient_case ?psychiatric_evaluator)
        (not
          (transport_equipment_available ?transport_equipment)
        )
        (enhanced_monitoring_required ?patient_case)
        (not
          (evaluator_available ?psychiatric_evaluator)
        )
        (security_on_scene ?patient_case)
        (evaluation_authorized ?patient_case)
      )
  )
  (:action assign_security_for_observation
    :parameters (?patient_case - patient_case ?security_officer - security_officer)
    :precondition
      (and
        (security_officer_available ?security_officer)
        (not
          (security_on_scene ?patient_case)
        )
        (clinical_preparation_complete ?patient_case)
        (team_confirmed_ready ?patient_case)
        (not
          (observation_bed_confirmed ?patient_case)
        )
      )
    :effect
      (and
        (observation_bed_confirmed ?patient_case)
        (not
          (security_officer_available ?security_officer)
        )
      )
  )
  (:action release_intake_assessor
    :parameters (?patient_case - patient_case ?intake_assessor - intake_assessor)
    :precondition
      (and
        (patient_assigned_to_assessor ?patient_case ?intake_assessor)
        (not
          (team_confirmed_ready ?patient_case)
        )
        (not
          (evaluation_authorized ?patient_case)
        )
      )
    :effect
      (and
        (not
          (patient_assigned_to_assessor ?patient_case ?intake_assessor)
        )
        (assessor_available ?intake_assessor)
        (not
          (assessment_in_progress ?patient_case)
        )
        (not
          (safety_measures_in_place ?patient_case)
        )
        (not
          (ready_for_transfer ?patient_case)
        )
        (not
          (clinical_preparation_complete ?patient_case)
        )
        (not
          (enhanced_monitoring_required ?patient_case)
        )
        (not
          (security_on_scene ?patient_case)
        )
      )
  )
  (:action confirm_observation_bed_ready
    :parameters (?patient_case - patient_case ?observation_bed - observation_bed)
    :precondition
      (and
        (not
          (observation_bed_confirmed ?patient_case)
        )
        (observation_bed_assigned ?patient_case ?observation_bed)
        (clinical_preparation_complete ?patient_case)
        (team_confirmed_ready ?patient_case)
        (not
          (security_on_scene ?patient_case)
        )
      )
    :effect
      (and
        (observation_bed_confirmed ?patient_case)
      )
  )
  (:action admit_case_with_room_assignment
    :parameters (?patient_case - patient_case ?safe_room - safe_room)
    :precondition
      (and
        (observation_bed_confirmed ?patient_case)
        (team_confirmed_ready ?patient_case)
        (evaluation_authorized ?patient_case)
        (safe_room_allocation_confirmed ?patient_case ?safe_room)
        (clinical_preparation_complete ?patient_case)
        (assessment_in_progress ?patient_case)
        (case_registered ?patient_case)
        (not
          (admitted_safe_room ?patient_case)
        )
        (bed_management_review ?patient_case)
      )
    :effect
      (and
        (admitted_safe_room ?patient_case)
      )
  )
  (:action confirm_safety_measures_with_bed
    :parameters (?patient_case - patient_case ?observation_bed - observation_bed)
    :precondition
      (and
        (case_registered ?patient_case)
        (assessment_in_progress ?patient_case)
        (not
          (safety_measures_in_place ?patient_case)
        )
        (observation_bed_assigned ?patient_case ?observation_bed)
      )
    :effect
      (and
        (safety_measures_in_place ?patient_case)
      )
  )
  (:action assign_intake_assessor
    :parameters (?patient_case - patient_case ?intake_assessor - intake_assessor)
    :precondition
      (and
        (not
          (assessment_in_progress ?patient_case)
        )
        (case_registered ?patient_case)
        (assessor_available ?intake_assessor)
        (assessor_eligible_for_case ?patient_case ?intake_assessor)
      )
    :effect
      (and
        (assessment_in_progress ?patient_case)
        (not
          (assessor_available ?intake_assessor)
        )
        (patient_assigned_to_assessor ?patient_case ?intake_assessor)
      )
  )
  (:action reconfirm_clinical_preparation
    :parameters (?patient_case - patient_case ?observation_bed - observation_bed ?senior_clinician - senior_clinician)
    :precondition
      (and
        (assessment_in_progress ?patient_case)
        (not
          (clinical_preparation_complete ?patient_case)
        )
        (observation_bed_assigned ?patient_case ?observation_bed)
        (team_confirmed_ready ?patient_case)
        (senior_clinician_available ?senior_clinician)
        (ready_for_transfer ?patient_case)
      )
    :effect
      (and
        (clinical_preparation_complete ?patient_case)
      )
  )
  (:action bed_management_authorize_assignment
    :parameters (?bed_management_officer - bed_management_patient_case ?triage_staff - triage_patient_case ?safe_room - safe_room)
    :precondition
      (and
        (case_registered ?bed_management_officer)
        (safe_room_assigned_to_case ?triage_staff ?safe_room)
        (bed_management_review ?bed_management_officer)
        (not
          (safe_room_allocation_confirmed ?bed_management_officer ?safe_room)
        )
        (bed_management_slot_requested ?bed_management_officer ?safe_room)
      )
    :effect
      (and
        (safe_room_allocation_confirmed ?bed_management_officer ?safe_room)
      )
  )
)

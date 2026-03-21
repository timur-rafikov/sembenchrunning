(define (domain ambulance_handoff_queue_balancing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types physical_object - object patient_episode - physical_object handoff_bay - physical_object treatment_area - physical_object nurse_resource - physical_object physician_resource - physical_object special_equipment - physical_object stretcher_gurney - physical_object paramedic_partner - physical_object consultation_slot - physical_object triage_room - physical_object diagnostic_slot - physical_object bed_type - physical_object clinical_team - physical_object nursing_subteam - clinical_team secondary_clinical_team - clinical_team adult_patient_subtype - patient_episode pediatric_patient_subtype - patient_episode)

  (:predicates
    (awaiting_handoff ?patient_episode - patient_episode)
    (assigned_to_handoff_bay ?patient_episode - patient_episode ?handoff_bay - handoff_bay)
    (handoff_in_progress ?patient_episode - patient_episode)
    (physical_handoff_confirmed ?patient_episode - patient_episode)
    (initial_assessment_completed ?patient_episode - patient_episode)
    (physician_reserved ?patient_episode - patient_episode ?physician_resource - physician_resource)
    (nurse_reserved ?patient_episode - patient_episode ?nurse_resource - nurse_resource)
    (equipment_reserved ?patient_episode - patient_episode ?special_equipment - special_equipment)
    (bed_type_reserved ?patient_episode - patient_episode ?bed_type - bed_type)
    (assigned_treatment_area ?patient_episode - patient_episode ?treatment_area - treatment_area)
    (care_initiated ?patient_episode - patient_episode)
    (team_assignment_confirmed ?patient_episode - patient_episode)
    (handoff_checklist_completed ?patient_episode - patient_episode)
    (handoff_completed ?patient_episode - patient_episode)
    (requires_followup_actions ?patient_episode - patient_episode)
    (ready_for_transition ?patient_episode - patient_episode)
    (eligible_consultation_slot ?patient_episode - patient_episode ?consultation_slot - consultation_slot)
    (consultation_slot_allocated_to_pediatric_episode ?patient_episode - patient_episode ?consultation_slot - consultation_slot)
    (handoff_documentation_completed ?patient_episode - patient_episode)
    (handoff_bay_available ?handoff_bay - handoff_bay)
    (treatment_area_available ?treatment_area - treatment_area)
    (physician_available ?physician_resource - physician_resource)
    (nurse_available ?nurse_resource - nurse_resource)
    (equipment_available ?special_equipment - special_equipment)
    (stretcher_available ?stretcher_gurney - stretcher_gurney)
    (paramedic_available ?paramedic_partner - paramedic_partner)
    (consultation_slot_available ?consultation_slot - consultation_slot)
    (triage_room_available ?triage_room - triage_room)
    (diagnostic_slot_available ?diagnostic_slot - diagnostic_slot)
    (bed_type_available ?bed_type - bed_type)
    (bay_compatible_with_episode ?patient_episode - patient_episode ?handoff_bay - handoff_bay)
    (treatment_area_compatible_with_episode ?patient_episode - patient_episode ?treatment_area - treatment_area)
    (physician_compatible_with_episode ?patient_episode - patient_episode ?physician_resource - physician_resource)
    (nurse_compatible_with_episode ?patient_episode - patient_episode ?nurse_resource - nurse_resource)
    (equipment_compatible_with_episode ?patient_episode - patient_episode ?special_equipment - special_equipment)
    (diagnostic_slot_compatible_with_episode ?patient_episode - patient_episode ?diagnostic_slot - diagnostic_slot)
    (bed_type_compatible_with_episode ?patient_episode - patient_episode ?bed_type - bed_type)
    (clinical_team_eligible_for_episode ?patient_episode - patient_episode ?clinical_team - clinical_team)
    (consultation_slot_assigned_to_episode ?patient_episode - patient_episode ?consultation_slot - consultation_slot)
    (time_sensitive_episode ?patient_episode - patient_episode)
    (pediatric_episode_flag ?patient_episode - patient_episode)
    (stretcher_assigned_to_episode ?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney)
    (bed_assignment_pending ?patient_episode - patient_episode)
    (consultation_slot_compatible ?patient_episode - patient_episode ?consultation_slot - consultation_slot)
  )
  (:action register_episode_arrival
    :parameters (?patient_episode - patient_episode)
    :precondition
      (and
        (not
          (awaiting_handoff ?patient_episode)
        )
        (not
          (handoff_completed ?patient_episode)
        )
      )
    :effect
      (and
        (awaiting_handoff ?patient_episode)
      )
  )
  (:action assign_episode_to_handoff_bay
    :parameters (?patient_episode - patient_episode ?handoff_bay - handoff_bay)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (handoff_bay_available ?handoff_bay)
        (bay_compatible_with_episode ?patient_episode ?handoff_bay)
        (not
          (handoff_in_progress ?patient_episode)
        )
      )
    :effect
      (and
        (assigned_to_handoff_bay ?patient_episode ?handoff_bay)
        (handoff_in_progress ?patient_episode)
        (not
          (handoff_bay_available ?handoff_bay)
        )
      )
  )
  (:action release_bay_assignment
    :parameters (?patient_episode - patient_episode ?handoff_bay - handoff_bay)
    :precondition
      (and
        (assigned_to_handoff_bay ?patient_episode ?handoff_bay)
        (not
          (care_initiated ?patient_episode)
        )
        (not
          (team_assignment_confirmed ?patient_episode)
        )
      )
    :effect
      (and
        (not
          (assigned_to_handoff_bay ?patient_episode ?handoff_bay)
        )
        (not
          (handoff_in_progress ?patient_episode)
        )
        (not
          (physical_handoff_confirmed ?patient_episode)
        )
        (not
          (initial_assessment_completed ?patient_episode)
        )
        (not
          (requires_followup_actions ?patient_episode)
        )
        (not
          (ready_for_transition ?patient_episode)
        )
        (not
          (bed_assignment_pending ?patient_episode)
        )
        (handoff_bay_available ?handoff_bay)
      )
  )
  (:action assign_stretcher_to_episode
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (stretcher_available ?stretcher_gurney)
      )
    :effect
      (and
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
        (not
          (stretcher_available ?stretcher_gurney)
        )
      )
  )
  (:action release_stretcher_from_episode
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney)
    :precondition
      (and
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
      )
    :effect
      (and
        (stretcher_available ?stretcher_gurney)
        (not
          (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
        )
      )
  )
  (:action confirm_physical_handoff
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
        (not
          (physical_handoff_confirmed ?patient_episode)
        )
      )
    :effect
      (and
        (physical_handoff_confirmed ?patient_episode)
      )
  )
  (:action confirm_physical_handoff_with_paramedic
    :parameters (?patient_episode - patient_episode ?paramedic_partner - paramedic_partner)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (paramedic_available ?paramedic_partner)
        (not
          (physical_handoff_confirmed ?patient_episode)
        )
      )
    :effect
      (and
        (physical_handoff_confirmed ?patient_episode)
        (requires_followup_actions ?patient_episode)
        (not
          (paramedic_available ?paramedic_partner)
        )
      )
  )
  (:action complete_triage_in_room
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney ?triage_room - triage_room)
    :precondition
      (and
        (physical_handoff_confirmed ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
        (triage_room_available ?triage_room)
        (not
          (initial_assessment_completed ?patient_episode)
        )
      )
    :effect
      (and
        (initial_assessment_completed ?patient_episode)
        (not
          (requires_followup_actions ?patient_episode)
        )
      )
  )
  (:action complete_triage_with_consultation_slot
    :parameters (?patient_episode - patient_episode ?consultation_slot - consultation_slot)
    :precondition
      (and
        (handoff_in_progress ?patient_episode)
        (consultation_slot_allocated_to_pediatric_episode ?patient_episode ?consultation_slot)
        (not
          (initial_assessment_completed ?patient_episode)
        )
      )
    :effect
      (and
        (initial_assessment_completed ?patient_episode)
        (not
          (requires_followup_actions ?patient_episode)
        )
      )
  )
  (:action reserve_physician_for_episode
    :parameters (?patient_episode - patient_episode ?physician_resource - physician_resource)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (physician_available ?physician_resource)
        (physician_compatible_with_episode ?patient_episode ?physician_resource)
      )
    :effect
      (and
        (physician_reserved ?patient_episode ?physician_resource)
        (not
          (physician_available ?physician_resource)
        )
      )
  )
  (:action release_physician_from_episode
    :parameters (?patient_episode - patient_episode ?physician_resource - physician_resource)
    :precondition
      (and
        (physician_reserved ?patient_episode ?physician_resource)
      )
    :effect
      (and
        (physician_available ?physician_resource)
        (not
          (physician_reserved ?patient_episode ?physician_resource)
        )
      )
  )
  (:action reserve_nurse_for_episode
    :parameters (?patient_episode - patient_episode ?nurse_resource - nurse_resource)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (nurse_available ?nurse_resource)
        (nurse_compatible_with_episode ?patient_episode ?nurse_resource)
      )
    :effect
      (and
        (nurse_reserved ?patient_episode ?nurse_resource)
        (not
          (nurse_available ?nurse_resource)
        )
      )
  )
  (:action release_nurse_from_episode
    :parameters (?patient_episode - patient_episode ?nurse_resource - nurse_resource)
    :precondition
      (and
        (nurse_reserved ?patient_episode ?nurse_resource)
      )
    :effect
      (and
        (nurse_available ?nurse_resource)
        (not
          (nurse_reserved ?patient_episode ?nurse_resource)
        )
      )
  )
  (:action reserve_equipment_for_episode
    :parameters (?patient_episode - patient_episode ?special_equipment - special_equipment)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (equipment_available ?special_equipment)
        (equipment_compatible_with_episode ?patient_episode ?special_equipment)
      )
    :effect
      (and
        (equipment_reserved ?patient_episode ?special_equipment)
        (not
          (equipment_available ?special_equipment)
        )
      )
  )
  (:action release_equipment_from_episode
    :parameters (?patient_episode - patient_episode ?special_equipment - special_equipment)
    :precondition
      (and
        (equipment_reserved ?patient_episode ?special_equipment)
      )
    :effect
      (and
        (equipment_available ?special_equipment)
        (not
          (equipment_reserved ?patient_episode ?special_equipment)
        )
      )
  )
  (:action reserve_bed_type_for_episode
    :parameters (?patient_episode - patient_episode ?bed_type - bed_type)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (bed_type_available ?bed_type)
        (bed_type_compatible_with_episode ?patient_episode ?bed_type)
      )
    :effect
      (and
        (bed_type_reserved ?patient_episode ?bed_type)
        (not
          (bed_type_available ?bed_type)
        )
      )
  )
  (:action release_bed_type_from_episode
    :parameters (?patient_episode - patient_episode ?bed_type - bed_type)
    :precondition
      (and
        (bed_type_reserved ?patient_episode ?bed_type)
      )
    :effect
      (and
        (bed_type_available ?bed_type)
        (not
          (bed_type_reserved ?patient_episode ?bed_type)
        )
      )
  )
  (:action initiate_care_in_treatment_area
    :parameters (?patient_episode - patient_episode ?treatment_area - treatment_area ?physician_resource - physician_resource ?nurse_resource - nurse_resource)
    :precondition
      (and
        (handoff_in_progress ?patient_episode)
        (physician_reserved ?patient_episode ?physician_resource)
        (nurse_reserved ?patient_episode ?nurse_resource)
        (treatment_area_available ?treatment_area)
        (treatment_area_compatible_with_episode ?patient_episode ?treatment_area)
        (not
          (care_initiated ?patient_episode)
        )
      )
    :effect
      (and
        (assigned_treatment_area ?patient_episode ?treatment_area)
        (care_initiated ?patient_episode)
        (not
          (treatment_area_available ?treatment_area)
        )
      )
  )
  (:action initiate_care_with_diagnostics
    :parameters (?patient_episode - patient_episode ?treatment_area - treatment_area ?special_equipment - special_equipment ?diagnostic_slot - diagnostic_slot)
    :precondition
      (and
        (handoff_in_progress ?patient_episode)
        (equipment_reserved ?patient_episode ?special_equipment)
        (diagnostic_slot_available ?diagnostic_slot)
        (treatment_area_available ?treatment_area)
        (treatment_area_compatible_with_episode ?patient_episode ?treatment_area)
        (diagnostic_slot_compatible_with_episode ?patient_episode ?diagnostic_slot)
        (not
          (care_initiated ?patient_episode)
        )
      )
    :effect
      (and
        (assigned_treatment_area ?patient_episode ?treatment_area)
        (care_initiated ?patient_episode)
        (bed_assignment_pending ?patient_episode)
        (requires_followup_actions ?patient_episode)
        (not
          (treatment_area_available ?treatment_area)
        )
        (not
          (diagnostic_slot_available ?diagnostic_slot)
        )
      )
  )
  (:action clear_bed_assignment_pending
    :parameters (?patient_episode - patient_episode ?physician_resource - physician_resource ?nurse_resource - nurse_resource)
    :precondition
      (and
        (care_initiated ?patient_episode)
        (bed_assignment_pending ?patient_episode)
        (physician_reserved ?patient_episode ?physician_resource)
        (nurse_reserved ?patient_episode ?nurse_resource)
      )
    :effect
      (and
        (not
          (bed_assignment_pending ?patient_episode)
        )
        (not
          (requires_followup_actions ?patient_episode)
        )
      )
  )
  (:action assign_clinical_team
    :parameters (?patient_episode - patient_episode ?physician_resource - physician_resource ?nurse_resource - nurse_resource ?nursing_subteam - nursing_subteam)
    :precondition
      (and
        (initial_assessment_completed ?patient_episode)
        (care_initiated ?patient_episode)
        (physician_reserved ?patient_episode ?physician_resource)
        (nurse_reserved ?patient_episode ?nurse_resource)
        (clinical_team_eligible_for_episode ?patient_episode ?nursing_subteam)
        (not
          (requires_followup_actions ?patient_episode)
        )
        (not
          (team_assignment_confirmed ?patient_episode)
        )
      )
    :effect
      (and
        (team_assignment_confirmed ?patient_episode)
      )
  )
  (:action assign_secondary_clinical_team
    :parameters (?patient_episode - patient_episode ?special_equipment - special_equipment ?bed_type - bed_type ?secondary_clinical_team - secondary_clinical_team)
    :precondition
      (and
        (initial_assessment_completed ?patient_episode)
        (care_initiated ?patient_episode)
        (equipment_reserved ?patient_episode ?special_equipment)
        (bed_type_reserved ?patient_episode ?bed_type)
        (clinical_team_eligible_for_episode ?patient_episode ?secondary_clinical_team)
        (not
          (team_assignment_confirmed ?patient_episode)
        )
      )
    :effect
      (and
        (team_assignment_confirmed ?patient_episode)
        (requires_followup_actions ?patient_episode)
      )
  )
  (:action mark_ready_for_transition
    :parameters (?patient_episode - patient_episode ?physician_resource - physician_resource ?nurse_resource - nurse_resource)
    :precondition
      (and
        (team_assignment_confirmed ?patient_episode)
        (requires_followup_actions ?patient_episode)
        (physician_reserved ?patient_episode ?physician_resource)
        (nurse_reserved ?patient_episode ?nurse_resource)
      )
    :effect
      (and
        (ready_for_transition ?patient_episode)
        (not
          (requires_followup_actions ?patient_episode)
        )
        (not
          (initial_assessment_completed ?patient_episode)
        )
        (not
          (bed_assignment_pending ?patient_episode)
        )
      )
  )
  (:action reopen_assessment_with_stretcher
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney ?triage_room - triage_room)
    :precondition
      (and
        (ready_for_transition ?patient_episode)
        (team_assignment_confirmed ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
        (triage_room_available ?triage_room)
        (not
          (initial_assessment_completed ?patient_episode)
        )
      )
    :effect
      (and
        (initial_assessment_completed ?patient_episode)
      )
  )
  (:action complete_handoff_checklist
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney)
    :precondition
      (and
        (team_assignment_confirmed ?patient_episode)
        (initial_assessment_completed ?patient_episode)
        (not
          (requires_followup_actions ?patient_episode)
        )
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
        (not
          (handoff_checklist_completed ?patient_episode)
        )
      )
    :effect
      (and
        (handoff_checklist_completed ?patient_episode)
      )
  )
  (:action complete_handoff_checklist_with_paramedic
    :parameters (?patient_episode - patient_episode ?paramedic_partner - paramedic_partner)
    :precondition
      (and
        (team_assignment_confirmed ?patient_episode)
        (initial_assessment_completed ?patient_episode)
        (not
          (requires_followup_actions ?patient_episode)
        )
        (paramedic_available ?paramedic_partner)
        (not
          (handoff_checklist_completed ?patient_episode)
        )
      )
    :effect
      (and
        (handoff_checklist_completed ?patient_episode)
        (not
          (paramedic_available ?paramedic_partner)
        )
      )
  )
  (:action assign_consultation_slot_to_episode
    :parameters (?patient_episode - patient_episode ?consultation_slot - consultation_slot)
    :precondition
      (and
        (handoff_checklist_completed ?patient_episode)
        (consultation_slot_available ?consultation_slot)
        (consultation_slot_compatible ?patient_episode ?consultation_slot)
      )
    :effect
      (and
        (consultation_slot_assigned_to_episode ?patient_episode ?consultation_slot)
        (not
          (consultation_slot_available ?consultation_slot)
        )
      )
  )
  (:action allocate_consultation_slot_for_pediatric_episode
    :parameters (?pediatric_patient_subtype - pediatric_patient_subtype ?adult_patient_subtype - adult_patient_subtype ?consultation_slot - consultation_slot)
    :precondition
      (and
        (awaiting_handoff ?pediatric_patient_subtype)
        (pediatric_episode_flag ?pediatric_patient_subtype)
        (eligible_consultation_slot ?pediatric_patient_subtype ?consultation_slot)
        (consultation_slot_assigned_to_episode ?adult_patient_subtype ?consultation_slot)
        (not
          (consultation_slot_allocated_to_pediatric_episode ?pediatric_patient_subtype ?consultation_slot)
        )
      )
    :effect
      (and
        (consultation_slot_allocated_to_pediatric_episode ?pediatric_patient_subtype ?consultation_slot)
      )
  )
  (:action complete_handoff_verification
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney ?triage_room - triage_room)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (pediatric_episode_flag ?patient_episode)
        (initial_assessment_completed ?patient_episode)
        (handoff_checklist_completed ?patient_episode)
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
        (triage_room_available ?triage_room)
        (not
          (handoff_documentation_completed ?patient_episode)
        )
      )
    :effect
      (and
        (handoff_documentation_completed ?patient_episode)
      )
  )
  (:action finalize_handoff_for_time_sensitive_episode
    :parameters (?patient_episode - patient_episode)
    :precondition
      (and
        (time_sensitive_episode ?patient_episode)
        (awaiting_handoff ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (care_initiated ?patient_episode)
        (team_assignment_confirmed ?patient_episode)
        (handoff_checklist_completed ?patient_episode)
        (initial_assessment_completed ?patient_episode)
        (not
          (handoff_completed ?patient_episode)
        )
      )
    :effect
      (and
        (handoff_completed ?patient_episode)
      )
  )
  (:action finalize_handoff_with_consultation_slot
    :parameters (?patient_episode - patient_episode ?consultation_slot - consultation_slot)
    :precondition
      (and
        (pediatric_episode_flag ?patient_episode)
        (awaiting_handoff ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (care_initiated ?patient_episode)
        (team_assignment_confirmed ?patient_episode)
        (handoff_checklist_completed ?patient_episode)
        (initial_assessment_completed ?patient_episode)
        (consultation_slot_allocated_to_pediatric_episode ?patient_episode ?consultation_slot)
        (not
          (handoff_completed ?patient_episode)
        )
      )
    :effect
      (and
        (handoff_completed ?patient_episode)
      )
  )
  (:action finalize_handoff_with_documentation
    :parameters (?patient_episode - patient_episode)
    :precondition
      (and
        (pediatric_episode_flag ?patient_episode)
        (awaiting_handoff ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (care_initiated ?patient_episode)
        (team_assignment_confirmed ?patient_episode)
        (handoff_checklist_completed ?patient_episode)
        (initial_assessment_completed ?patient_episode)
        (handoff_documentation_completed ?patient_episode)
        (not
          (handoff_completed ?patient_episode)
        )
      )
    :effect
      (and
        (handoff_completed ?patient_episode)
      )
  )
)

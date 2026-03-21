(define (domain ambulance_handoff_queue_balancing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types patient_episode - physical_object handoff_bay - physical_object treatment_area - physical_object nurse_resource - physical_object physician_resource - physical_object special_equipment - physical_object stretcher_gurney - physical_object paramedic_partner - physical_object consultation_slot - physical_object triage_room - physical_object diagnostic_slot - physical_object bed_type - physical_object clinical_team - physical_object nursing_subteam - clinical_team secondary_clinical_team - clinical_team adult_patient_subtype - patient_episode pediatric_patient_subtype - patient_episode)
  (:predicates
    (paramedic_available ?paramedic_partner - paramedic_partner)
    (nurse_reserved ?patient_episode - patient_episode ?nurse_resource - nurse_resource)
    (ready_for_transition ?patient_episode - patient_episode)
    (assigned_to_handoff_bay ?patient_episode - patient_episode ?handoff_bay - handoff_bay)
    (clinical_team_eligible_for_episode ?patient_episode - patient_episode ?clinical_team - clinical_team)
    (equipment_available ?special_equipment - special_equipment)
    (nurse_available ?nurse_resource - nurse_resource)
    (bed_type_compatible_with_episode ?patient_episode - patient_episode ?bed_type - bed_type)
    (handoff_completed ?patient_episode - patient_episode)
    (time_sensitive_episode ?patient_episode - patient_episode)
    (bay_compatible_with_episode ?patient_episode - patient_episode ?handoff_bay - handoff_bay)
    (treatment_area_available ?treatment_area - treatment_area)
    (diagnostic_slot_available ?diagnostic_slot - diagnostic_slot)
    (stretcher_available ?stretcher_gurney - stretcher_gurney)
    (care_initiated ?patient_episode - patient_episode)
    (nurse_compatible_with_episode ?patient_episode - patient_episode ?nurse_resource - nurse_resource)
    (bed_type_reserved ?patient_episode - patient_episode ?bed_type - bed_type)
    (assigned_treatment_area ?patient_episode - patient_episode ?treatment_area - treatment_area)
    (team_assignment_confirmed ?patient_episode - patient_episode)
    (equipment_compatible_with_episode ?patient_episode - patient_episode ?special_equipment - special_equipment)
    (bed_type_available ?bed_type - bed_type)
    (pediatric_episode_flag ?patient_episode - patient_episode)
    (initial_assessment_completed ?patient_episode - patient_episode)
    (physician_compatible_with_episode ?patient_episode - patient_episode ?physician_resource - physician_resource)
    (physician_reserved ?patient_episode - patient_episode ?physician_resource - physician_resource)
    (bed_assignment_pending ?patient_episode - patient_episode)
    (stretcher_assigned_to_episode ?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney)
    (handoff_documentation_completed ?patient_episode - patient_episode)
    (diagnostic_slot_compatible_with_episode ?patient_episode - patient_episode ?diagnostic_slot - diagnostic_slot)
    (awaiting_handoff ?patient_episode - patient_episode)
    (handoff_bay_available ?handoff_bay - handoff_bay)
    (handoff_in_progress ?patient_episode - patient_episode)
    (triage_room_available ?triage_room - triage_room)
    (consultation_slot_available ?consultation_slot - consultation_slot)
    (equipment_reserved ?patient_episode - patient_episode ?special_equipment - special_equipment)
    (consultation_slot_assigned_to_episode ?patient_episode - patient_episode ?consultation_slot - consultation_slot)
    (physical_handoff_confirmed ?patient_episode - patient_episode)
    (handoff_checklist_completed ?patient_episode - patient_episode)
    (consultation_slot_compatible ?patient_episode - patient_episode ?consultation_slot - consultation_slot)
    (physician_available ?physician_resource - physician_resource)
    (eligible_consultation_slot ?patient_episode - patient_episode ?consultation_slot - consultation_slot)
    (treatment_area_compatible_with_episode ?patient_episode - patient_episode ?treatment_area - treatment_area)
    (requires_followup_actions ?patient_episode - patient_episode)
    (consultation_slot_allocated_to_pediatric_episode ?patient_episode - patient_episode ?consultation_slot - consultation_slot)
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
  (:action assign_secondary_clinical_team
    :parameters (?patient_episode - patient_episode ?special_equipment - special_equipment ?bed_type - bed_type ?secondary_clinical_team - secondary_clinical_team)
    :precondition
      (and
        (not
          (team_assignment_confirmed ?patient_episode)
        )
        (care_initiated ?patient_episode)
        (initial_assessment_completed ?patient_episode)
        (bed_type_reserved ?patient_episode ?bed_type)
        (clinical_team_eligible_for_episode ?patient_episode ?secondary_clinical_team)
        (equipment_reserved ?patient_episode ?special_equipment)
      )
    :effect
      (and
        (requires_followup_actions ?patient_episode)
        (team_assignment_confirmed ?patient_episode)
      )
  )
  (:action finalize_handoff_for_time_sensitive_episode
    :parameters (?patient_episode - patient_episode)
    :precondition
      (and
        (initial_assessment_completed ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (care_initiated ?patient_episode)
        (awaiting_handoff ?patient_episode)
        (handoff_checklist_completed ?patient_episode)
        (not
          (handoff_completed ?patient_episode)
        )
        (time_sensitive_episode ?patient_episode)
        (team_assignment_confirmed ?patient_episode)
      )
    :effect
      (and
        (handoff_completed ?patient_episode)
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
  (:action assign_stretcher_to_episode
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney)
    :precondition
      (and
        (stretcher_available ?stretcher_gurney)
        (awaiting_handoff ?patient_episode)
      )
    :effect
      (and
        (not
          (stretcher_available ?stretcher_gurney)
        )
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
      )
  )
  (:action assign_clinical_team
    :parameters (?patient_episode - patient_episode ?physician_resource - physician_resource ?nurse_resource - nurse_resource ?nursing_subteam - nursing_subteam)
    :precondition
      (and
        (clinical_team_eligible_for_episode ?patient_episode ?nursing_subteam)
        (initial_assessment_completed ?patient_episode)
        (not
          (requires_followup_actions ?patient_episode)
        )
        (physician_reserved ?patient_episode ?physician_resource)
        (care_initiated ?patient_episode)
        (nurse_reserved ?patient_episode ?nurse_resource)
        (not
          (team_assignment_confirmed ?patient_episode)
        )
      )
    :effect
      (and
        (team_assignment_confirmed ?patient_episode)
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
  (:action reserve_equipment_for_episode
    :parameters (?patient_episode - patient_episode ?special_equipment - special_equipment)
    :precondition
      (and
        (equipment_compatible_with_episode ?patient_episode ?special_equipment)
        (awaiting_handoff ?patient_episode)
        (equipment_available ?special_equipment)
      )
    :effect
      (and
        (equipment_reserved ?patient_episode ?special_equipment)
        (not
          (equipment_available ?special_equipment)
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
        (not
          (physician_available ?physician_resource)
        )
        (physician_reserved ?patient_episode ?physician_resource)
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
  (:action initiate_care_in_treatment_area
    :parameters (?patient_episode - patient_episode ?treatment_area - treatment_area ?physician_resource - physician_resource ?nurse_resource - nurse_resource)
    :precondition
      (and
        (handoff_in_progress ?patient_episode)
        (treatment_area_available ?treatment_area)
        (treatment_area_compatible_with_episode ?patient_episode ?treatment_area)
        (not
          (care_initiated ?patient_episode)
        )
        (nurse_reserved ?patient_episode ?nurse_resource)
        (physician_reserved ?patient_episode ?physician_resource)
      )
    :effect
      (and
        (assigned_treatment_area ?patient_episode ?treatment_area)
        (not
          (treatment_area_available ?treatment_area)
        )
        (care_initiated ?patient_episode)
      )
  )
  (:action mark_ready_for_transition
    :parameters (?patient_episode - patient_episode ?physician_resource - physician_resource ?nurse_resource - nurse_resource)
    :precondition
      (and
        (physician_reserved ?patient_episode ?physician_resource)
        (team_assignment_confirmed ?patient_episode)
        (nurse_reserved ?patient_episode ?nurse_resource)
        (requires_followup_actions ?patient_episode)
      )
    :effect
      (and
        (not
          (bed_assignment_pending ?patient_episode)
        )
        (not
          (requires_followup_actions ?patient_episode)
        )
        (not
          (initial_assessment_completed ?patient_episode)
        )
        (ready_for_transition ?patient_episode)
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
  (:action complete_triage_in_room
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney ?triage_room - triage_room)
    :precondition
      (and
        (not
          (initial_assessment_completed ?patient_episode)
        )
        (handoff_in_progress ?patient_episode)
        (triage_room_available ?triage_room)
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
        (physical_handoff_confirmed ?patient_episode)
      )
    :effect
      (and
        (not
          (requires_followup_actions ?patient_episode)
        )
        (initial_assessment_completed ?patient_episode)
      )
  )
  (:action finalize_handoff_with_documentation
    :parameters (?patient_episode - patient_episode)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (pediatric_episode_flag ?patient_episode)
        (handoff_documentation_completed ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (initial_assessment_completed ?patient_episode)
        (not
          (handoff_completed ?patient_episode)
        )
        (handoff_checklist_completed ?patient_episode)
        (care_initiated ?patient_episode)
        (team_assignment_confirmed ?patient_episode)
      )
    :effect
      (and
        (handoff_completed ?patient_episode)
      )
  )
  (:action complete_handoff_verification
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney ?triage_room - triage_room)
    :precondition
      (and
        (initial_assessment_completed ?patient_episode)
        (triage_room_available ?triage_room)
        (not
          (handoff_documentation_completed ?patient_episode)
        )
        (handoff_checklist_completed ?patient_episode)
        (awaiting_handoff ?patient_episode)
        (pediatric_episode_flag ?patient_episode)
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
      )
    :effect
      (and
        (handoff_documentation_completed ?patient_episode)
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
  (:action reserve_bed_type_for_episode
    :parameters (?patient_episode - patient_episode ?bed_type - bed_type)
    :precondition
      (and
        (bed_type_available ?bed_type)
        (awaiting_handoff ?patient_episode)
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
  (:action confirm_physical_handoff_with_paramedic
    :parameters (?patient_episode - patient_episode ?paramedic_partner - paramedic_partner)
    :precondition
      (and
        (not
          (physical_handoff_confirmed ?patient_episode)
        )
        (awaiting_handoff ?patient_episode)
        (paramedic_available ?paramedic_partner)
        (handoff_in_progress ?patient_episode)
      )
    :effect
      (and
        (requires_followup_actions ?patient_episode)
        (not
          (paramedic_available ?paramedic_partner)
        )
        (physical_handoff_confirmed ?patient_episode)
      )
  )
  (:action initiate_care_with_diagnostics
    :parameters (?patient_episode - patient_episode ?treatment_area - treatment_area ?special_equipment - special_equipment ?diagnostic_slot - diagnostic_slot)
    :precondition
      (and
        (diagnostic_slot_available ?diagnostic_slot)
        (diagnostic_slot_compatible_with_episode ?patient_episode ?diagnostic_slot)
        (not
          (care_initiated ?patient_episode)
        )
        (handoff_in_progress ?patient_episode)
        (treatment_area_available ?treatment_area)
        (treatment_area_compatible_with_episode ?patient_episode ?treatment_area)
        (equipment_reserved ?patient_episode ?special_equipment)
      )
    :effect
      (and
        (assigned_treatment_area ?patient_episode ?treatment_area)
        (not
          (diagnostic_slot_available ?diagnostic_slot)
        )
        (bed_assignment_pending ?patient_episode)
        (not
          (treatment_area_available ?treatment_area)
        )
        (requires_followup_actions ?patient_episode)
        (care_initiated ?patient_episode)
      )
  )
  (:action complete_handoff_checklist_with_paramedic
    :parameters (?patient_episode - patient_episode ?paramedic_partner - paramedic_partner)
    :precondition
      (and
        (paramedic_available ?paramedic_partner)
        (not
          (requires_followup_actions ?patient_episode)
        )
        (initial_assessment_completed ?patient_episode)
        (team_assignment_confirmed ?patient_episode)
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
  (:action release_bay_assignment
    :parameters (?patient_episode - patient_episode ?handoff_bay - handoff_bay)
    :precondition
      (and
        (assigned_to_handoff_bay ?patient_episode ?handoff_bay)
        (not
          (team_assignment_confirmed ?patient_episode)
        )
        (not
          (care_initiated ?patient_episode)
        )
      )
    :effect
      (and
        (not
          (assigned_to_handoff_bay ?patient_episode ?handoff_bay)
        )
        (handoff_bay_available ?handoff_bay)
        (not
          (handoff_in_progress ?patient_episode)
        )
        (not
          (physical_handoff_confirmed ?patient_episode)
        )
        (not
          (ready_for_transition ?patient_episode)
        )
        (not
          (initial_assessment_completed ?patient_episode)
        )
        (not
          (bed_assignment_pending ?patient_episode)
        )
        (not
          (requires_followup_actions ?patient_episode)
        )
      )
  )
  (:action complete_handoff_checklist
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney)
    :precondition
      (and
        (not
          (handoff_checklist_completed ?patient_episode)
        )
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
        (initial_assessment_completed ?patient_episode)
        (team_assignment_confirmed ?patient_episode)
        (not
          (requires_followup_actions ?patient_episode)
        )
      )
    :effect
      (and
        (handoff_checklist_completed ?patient_episode)
      )
  )
  (:action finalize_handoff_with_consultation_slot
    :parameters (?patient_episode - patient_episode ?consultation_slot - consultation_slot)
    :precondition
      (and
        (handoff_checklist_completed ?patient_episode)
        (team_assignment_confirmed ?patient_episode)
        (care_initiated ?patient_episode)
        (consultation_slot_allocated_to_pediatric_episode ?patient_episode ?consultation_slot)
        (initial_assessment_completed ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (awaiting_handoff ?patient_episode)
        (not
          (handoff_completed ?patient_episode)
        )
        (pediatric_episode_flag ?patient_episode)
      )
    :effect
      (and
        (handoff_completed ?patient_episode)
      )
  )
  (:action confirm_physical_handoff
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney)
    :precondition
      (and
        (awaiting_handoff ?patient_episode)
        (handoff_in_progress ?patient_episode)
        (not
          (physical_handoff_confirmed ?patient_episode)
        )
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
      )
    :effect
      (and
        (physical_handoff_confirmed ?patient_episode)
      )
  )
  (:action assign_episode_to_handoff_bay
    :parameters (?patient_episode - patient_episode ?handoff_bay - handoff_bay)
    :precondition
      (and
        (not
          (handoff_in_progress ?patient_episode)
        )
        (awaiting_handoff ?patient_episode)
        (handoff_bay_available ?handoff_bay)
        (bay_compatible_with_episode ?patient_episode ?handoff_bay)
      )
    :effect
      (and
        (handoff_in_progress ?patient_episode)
        (not
          (handoff_bay_available ?handoff_bay)
        )
        (assigned_to_handoff_bay ?patient_episode ?handoff_bay)
      )
  )
  (:action reopen_assessment_with_stretcher
    :parameters (?patient_episode - patient_episode ?stretcher_gurney - stretcher_gurney ?triage_room - triage_room)
    :precondition
      (and
        (handoff_in_progress ?patient_episode)
        (not
          (initial_assessment_completed ?patient_episode)
        )
        (stretcher_assigned_to_episode ?patient_episode ?stretcher_gurney)
        (team_assignment_confirmed ?patient_episode)
        (triage_room_available ?triage_room)
        (ready_for_transition ?patient_episode)
      )
    :effect
      (and
        (initial_assessment_completed ?patient_episode)
      )
  )
  (:action allocate_consultation_slot_for_pediatric_episode
    :parameters (?pediatric_patient_subtype - pediatric_patient_subtype ?adult_patient_subtype - adult_patient_subtype ?consultation_slot - consultation_slot)
    :precondition
      (and
        (awaiting_handoff ?pediatric_patient_subtype)
        (consultation_slot_assigned_to_episode ?adult_patient_subtype ?consultation_slot)
        (pediatric_episode_flag ?pediatric_patient_subtype)
        (not
          (consultation_slot_allocated_to_pediatric_episode ?pediatric_patient_subtype ?consultation_slot)
        )
        (eligible_consultation_slot ?pediatric_patient_subtype ?consultation_slot)
      )
    :effect
      (and
        (consultation_slot_allocated_to_pediatric_episode ?pediatric_patient_subtype ?consultation_slot)
      )
  )
)

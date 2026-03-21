(define (domain mass_casualty_tag_and_distribution_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types physical_object - object patient_case - physical_object treatment_space - physical_object clinician - physical_object medical_equipment - physical_object supply_kit - physical_object specialty_team - physical_object stretcher - physical_object triage_tag_device - physical_object receiving_facility - physical_object logistics_staff - physical_object diagnostic_resource - physical_object care_pathway - physical_object transport_option - physical_object ground_transport - transport_option air_transport - transport_option on_scene_patient - patient_case in_hospital_patient - patient_case)

  (:predicates
    (registered_present ?patient_case - patient_case)
    (assigned_treatment_space ?patient_case - patient_case ?treatment_space - treatment_space)
    (reserved_treatment_space ?patient_case - patient_case)
    (pre_transport_preparation_flag ?patient_case - patient_case)
    (staged_for_treatment ?patient_case - patient_case)
    (reserved_supply_kit ?patient_case - patient_case ?supply_kit - supply_kit)
    (reserved_medical_equipment ?patient_case - patient_case ?medical_equipment - medical_equipment)
    (reserved_specialty_team ?patient_case - patient_case ?specialty_team - specialty_team)
    (reserved_care_pathway ?patient_case - patient_case ?care_pathway - care_pathway)
    (assigned_clinician ?patient_case - patient_case ?clinician - clinician)
    (evaluated_flag ?patient_case - patient_case)
    (in_treatment_flag ?patient_case - patient_case)
    (ready_for_transfer_flag ?patient_case - patient_case)
    (finalized_disposition ?patient_case - patient_case)
    (triage_tag_applied ?patient_case - patient_case)
    (treatment_initiated_flag ?patient_case - patient_case)
    (facility_request_eligibility ?patient_case - patient_case ?receiving_facility - receiving_facility)
    (facility_confirmed_acceptance ?patient_case - patient_case ?receiving_facility - receiving_facility)
    (transport_ready_flag ?patient_case - patient_case)
    (treatment_space_available ?treatment_space - treatment_space)
    (clinician_available ?clinician - clinician)
    (supply_kit_available ?supply_kit - supply_kit)
    (medical_equipment_available ?medical_equipment - medical_equipment)
    (specialty_team_available ?specialty_team - specialty_team)
    (stretcher_available ?stretcher - stretcher)
    (triage_tag_available ?triage_tag_device - triage_tag_device)
    (receiving_facility_available ?receiving_facility - receiving_facility)
    (logistics_staff_available ?logistics_staff - logistics_staff)
    (diagnostic_resource_available ?diagnostic_resource - diagnostic_resource)
    (care_pathway_available ?care_pathway - care_pathway)
    (eligible_treatment_space ?patient_case - patient_case ?treatment_space - treatment_space)
    (eligible_clinician ?patient_case - patient_case ?clinician - clinician)
    (eligible_supply_kit ?patient_case - patient_case ?supply_kit - supply_kit)
    (eligible_medical_equipment ?patient_case - patient_case ?medical_equipment - medical_equipment)
    (eligible_specialty_team ?patient_case - patient_case ?specialty_team - specialty_team)
    (eligible_diagnostic_resource ?patient_case - patient_case ?diagnostic_resource - diagnostic_resource)
    (eligible_care_pathway ?patient_case - patient_case ?care_pathway - care_pathway)
    (eligible_transport_option ?patient_case - patient_case ?transport_option - transport_option)
    (reserved_receiving_facility ?patient_case - patient_case ?receiving_facility - receiving_facility)
    (is_on_scene ?patient_case - patient_case)
    (is_in_hospital ?patient_case - patient_case)
    (reserved_stretcher ?patient_case - patient_case ?stretcher - stretcher)
    (awaiting_treatment_authorization ?patient_case - patient_case)
    (on_scene_facility_compatibility ?patient_case - patient_case ?receiving_facility - receiving_facility)
  )
  (:action register_patient_case
    :parameters (?patient_case - patient_case)
    :precondition
      (and
        (not
          (registered_present ?patient_case)
        )
        (not
          (finalized_disposition ?patient_case)
        )
      )
    :effect
      (and
        (registered_present ?patient_case)
      )
  )
  (:action assign_treatment_space
    :parameters (?patient_case - patient_case ?treatment_space - treatment_space)
    :precondition
      (and
        (registered_present ?patient_case)
        (treatment_space_available ?treatment_space)
        (eligible_treatment_space ?patient_case ?treatment_space)
        (not
          (reserved_treatment_space ?patient_case)
        )
      )
    :effect
      (and
        (assigned_treatment_space ?patient_case ?treatment_space)
        (reserved_treatment_space ?patient_case)
        (not
          (treatment_space_available ?treatment_space)
        )
      )
  )
  (:action release_treatment_space
    :parameters (?patient_case - patient_case ?treatment_space - treatment_space)
    :precondition
      (and
        (assigned_treatment_space ?patient_case ?treatment_space)
        (not
          (evaluated_flag ?patient_case)
        )
        (not
          (in_treatment_flag ?patient_case)
        )
      )
    :effect
      (and
        (not
          (assigned_treatment_space ?patient_case ?treatment_space)
        )
        (not
          (reserved_treatment_space ?patient_case)
        )
        (not
          (pre_transport_preparation_flag ?patient_case)
        )
        (not
          (staged_for_treatment ?patient_case)
        )
        (not
          (triage_tag_applied ?patient_case)
        )
        (not
          (treatment_initiated_flag ?patient_case)
        )
        (not
          (awaiting_treatment_authorization ?patient_case)
        )
        (treatment_space_available ?treatment_space)
      )
  )
  (:action reserve_stretcher_for_patient
    :parameters (?patient_case - patient_case ?stretcher - stretcher)
    :precondition
      (and
        (registered_present ?patient_case)
        (stretcher_available ?stretcher)
      )
    :effect
      (and
        (reserved_stretcher ?patient_case ?stretcher)
        (not
          (stretcher_available ?stretcher)
        )
      )
  )
  (:action release_stretcher_reservation
    :parameters (?patient_case - patient_case ?stretcher - stretcher)
    :precondition
      (and
        (reserved_stretcher ?patient_case ?stretcher)
      )
    :effect
      (and
        (stretcher_available ?stretcher)
        (not
          (reserved_stretcher ?patient_case ?stretcher)
        )
      )
  )
  (:action prepare_stretcher_for_transfer
    :parameters (?patient_case - patient_case ?stretcher - stretcher)
    :precondition
      (and
        (registered_present ?patient_case)
        (reserved_treatment_space ?patient_case)
        (reserved_stretcher ?patient_case ?stretcher)
        (not
          (pre_transport_preparation_flag ?patient_case)
        )
      )
    :effect
      (and
        (pre_transport_preparation_flag ?patient_case)
      )
  )
  (:action apply_triage_tag
    :parameters (?patient_case - patient_case ?triage_tag_device - triage_tag_device)
    :precondition
      (and
        (registered_present ?patient_case)
        (reserved_treatment_space ?patient_case)
        (triage_tag_available ?triage_tag_device)
        (not
          (pre_transport_preparation_flag ?patient_case)
        )
      )
    :effect
      (and
        (pre_transport_preparation_flag ?patient_case)
        (triage_tag_applied ?patient_case)
        (not
          (triage_tag_available ?triage_tag_device)
        )
      )
  )
  (:action confirm_stretcher_and_logistics
    :parameters (?patient_case - patient_case ?stretcher - stretcher ?logistics_staff - logistics_staff)
    :precondition
      (and
        (pre_transport_preparation_flag ?patient_case)
        (reserved_treatment_space ?patient_case)
        (reserved_stretcher ?patient_case ?stretcher)
        (logistics_staff_available ?logistics_staff)
        (not
          (staged_for_treatment ?patient_case)
        )
      )
    :effect
      (and
        (staged_for_treatment ?patient_case)
        (not
          (triage_tag_applied ?patient_case)
        )
      )
  )
  (:action confirm_staging_with_receiving_facility
    :parameters (?patient_case - patient_case ?receiving_facility - receiving_facility)
    :precondition
      (and
        (reserved_treatment_space ?patient_case)
        (facility_confirmed_acceptance ?patient_case ?receiving_facility)
        (not
          (staged_for_treatment ?patient_case)
        )
      )
    :effect
      (and
        (staged_for_treatment ?patient_case)
        (not
          (triage_tag_applied ?patient_case)
        )
      )
  )
  (:action reserve_supply_kit
    :parameters (?patient_case - patient_case ?supply_kit - supply_kit)
    :precondition
      (and
        (registered_present ?patient_case)
        (supply_kit_available ?supply_kit)
        (eligible_supply_kit ?patient_case ?supply_kit)
      )
    :effect
      (and
        (reserved_supply_kit ?patient_case ?supply_kit)
        (not
          (supply_kit_available ?supply_kit)
        )
      )
  )
  (:action release_supply_kit
    :parameters (?patient_case - patient_case ?supply_kit - supply_kit)
    :precondition
      (and
        (reserved_supply_kit ?patient_case ?supply_kit)
      )
    :effect
      (and
        (supply_kit_available ?supply_kit)
        (not
          (reserved_supply_kit ?patient_case ?supply_kit)
        )
      )
  )
  (:action reserve_medical_equipment
    :parameters (?patient_case - patient_case ?medical_equipment - medical_equipment)
    :precondition
      (and
        (registered_present ?patient_case)
        (medical_equipment_available ?medical_equipment)
        (eligible_medical_equipment ?patient_case ?medical_equipment)
      )
    :effect
      (and
        (reserved_medical_equipment ?patient_case ?medical_equipment)
        (not
          (medical_equipment_available ?medical_equipment)
        )
      )
  )
  (:action release_medical_equipment
    :parameters (?patient_case - patient_case ?medical_equipment - medical_equipment)
    :precondition
      (and
        (reserved_medical_equipment ?patient_case ?medical_equipment)
      )
    :effect
      (and
        (medical_equipment_available ?medical_equipment)
        (not
          (reserved_medical_equipment ?patient_case ?medical_equipment)
        )
      )
  )
  (:action reserve_specialty_team
    :parameters (?patient_case - patient_case ?specialty_team - specialty_team)
    :precondition
      (and
        (registered_present ?patient_case)
        (specialty_team_available ?specialty_team)
        (eligible_specialty_team ?patient_case ?specialty_team)
      )
    :effect
      (and
        (reserved_specialty_team ?patient_case ?specialty_team)
        (not
          (specialty_team_available ?specialty_team)
        )
      )
  )
  (:action release_specialty_team
    :parameters (?patient_case - patient_case ?specialty_team - specialty_team)
    :precondition
      (and
        (reserved_specialty_team ?patient_case ?specialty_team)
      )
    :effect
      (and
        (specialty_team_available ?specialty_team)
        (not
          (reserved_specialty_team ?patient_case ?specialty_team)
        )
      )
  )
  (:action reserve_care_pathway
    :parameters (?patient_case - patient_case ?care_pathway - care_pathway)
    :precondition
      (and
        (registered_present ?patient_case)
        (care_pathway_available ?care_pathway)
        (eligible_care_pathway ?patient_case ?care_pathway)
      )
    :effect
      (and
        (reserved_care_pathway ?patient_case ?care_pathway)
        (not
          (care_pathway_available ?care_pathway)
        )
      )
  )
  (:action release_care_pathway
    :parameters (?patient_case - patient_case ?care_pathway - care_pathway)
    :precondition
      (and
        (reserved_care_pathway ?patient_case ?care_pathway)
      )
    :effect
      (and
        (care_pathway_available ?care_pathway)
        (not
          (reserved_care_pathway ?patient_case ?care_pathway)
        )
      )
  )
  (:action assign_treatment_episode
    :parameters (?patient_case - patient_case ?clinician - clinician ?supply_kit - supply_kit ?medical_equipment - medical_equipment)
    :precondition
      (and
        (reserved_treatment_space ?patient_case)
        (reserved_supply_kit ?patient_case ?supply_kit)
        (reserved_medical_equipment ?patient_case ?medical_equipment)
        (clinician_available ?clinician)
        (eligible_clinician ?patient_case ?clinician)
        (not
          (evaluated_flag ?patient_case)
        )
      )
    :effect
      (and
        (assigned_clinician ?patient_case ?clinician)
        (evaluated_flag ?patient_case)
        (not
          (clinician_available ?clinician)
        )
      )
  )
  (:action assign_treatment_episode_with_specialty_and_diagnostic
    :parameters (?patient_case - patient_case ?clinician - clinician ?specialty_team - specialty_team ?diagnostic_resource - diagnostic_resource)
    :precondition
      (and
        (reserved_treatment_space ?patient_case)
        (reserved_specialty_team ?patient_case ?specialty_team)
        (diagnostic_resource_available ?diagnostic_resource)
        (clinician_available ?clinician)
        (eligible_clinician ?patient_case ?clinician)
        (eligible_diagnostic_resource ?patient_case ?diagnostic_resource)
        (not
          (evaluated_flag ?patient_case)
        )
      )
    :effect
      (and
        (assigned_clinician ?patient_case ?clinician)
        (evaluated_flag ?patient_case)
        (awaiting_treatment_authorization ?patient_case)
        (triage_tag_applied ?patient_case)
        (not
          (clinician_available ?clinician)
        )
        (not
          (diagnostic_resource_available ?diagnostic_resource)
        )
      )
  )
  (:action authorize_treatment_start
    :parameters (?patient_case - patient_case ?supply_kit - supply_kit ?medical_equipment - medical_equipment)
    :precondition
      (and
        (evaluated_flag ?patient_case)
        (awaiting_treatment_authorization ?patient_case)
        (reserved_supply_kit ?patient_case ?supply_kit)
        (reserved_medical_equipment ?patient_case ?medical_equipment)
      )
    :effect
      (and
        (not
          (awaiting_treatment_authorization ?patient_case)
        )
        (not
          (triage_tag_applied ?patient_case)
        )
      )
  )
  (:action initiate_treatment
    :parameters (?patient_case - patient_case ?supply_kit - supply_kit ?medical_equipment - medical_equipment ?ground_transport - ground_transport)
    :precondition
      (and
        (staged_for_treatment ?patient_case)
        (evaluated_flag ?patient_case)
        (reserved_supply_kit ?patient_case ?supply_kit)
        (reserved_medical_equipment ?patient_case ?medical_equipment)
        (eligible_transport_option ?patient_case ?ground_transport)
        (not
          (triage_tag_applied ?patient_case)
        )
        (not
          (in_treatment_flag ?patient_case)
        )
      )
    :effect
      (and
        (in_treatment_flag ?patient_case)
      )
  )
  (:action initiate_treatment_with_specialty
    :parameters (?patient_case - patient_case ?specialty_team - specialty_team ?care_pathway - care_pathway ?air_transport - air_transport)
    :precondition
      (and
        (staged_for_treatment ?patient_case)
        (evaluated_flag ?patient_case)
        (reserved_specialty_team ?patient_case ?specialty_team)
        (reserved_care_pathway ?patient_case ?care_pathway)
        (eligible_transport_option ?patient_case ?air_transport)
        (not
          (in_treatment_flag ?patient_case)
        )
      )
    :effect
      (and
        (in_treatment_flag ?patient_case)
        (triage_tag_applied ?patient_case)
      )
  )
  (:action finalize_treatment_authorization
    :parameters (?patient_case - patient_case ?supply_kit - supply_kit ?medical_equipment - medical_equipment)
    :precondition
      (and
        (in_treatment_flag ?patient_case)
        (triage_tag_applied ?patient_case)
        (reserved_supply_kit ?patient_case ?supply_kit)
        (reserved_medical_equipment ?patient_case ?medical_equipment)
      )
    :effect
      (and
        (treatment_initiated_flag ?patient_case)
        (not
          (triage_tag_applied ?patient_case)
        )
        (not
          (staged_for_treatment ?patient_case)
        )
        (not
          (awaiting_treatment_authorization ?patient_case)
        )
      )
  )
  (:action reassess_and_restage
    :parameters (?patient_case - patient_case ?stretcher - stretcher ?logistics_staff - logistics_staff)
    :precondition
      (and
        (treatment_initiated_flag ?patient_case)
        (in_treatment_flag ?patient_case)
        (reserved_treatment_space ?patient_case)
        (reserved_stretcher ?patient_case ?stretcher)
        (logistics_staff_available ?logistics_staff)
        (not
          (staged_for_treatment ?patient_case)
        )
      )
    :effect
      (and
        (staged_for_treatment ?patient_case)
      )
  )
  (:action mark_ready_for_transfer_with_stretcher
    :parameters (?patient_case - patient_case ?stretcher - stretcher)
    :precondition
      (and
        (in_treatment_flag ?patient_case)
        (staged_for_treatment ?patient_case)
        (not
          (triage_tag_applied ?patient_case)
        )
        (reserved_stretcher ?patient_case ?stretcher)
        (not
          (ready_for_transfer_flag ?patient_case)
        )
      )
    :effect
      (and
        (ready_for_transfer_flag ?patient_case)
      )
  )
  (:action mark_ready_for_transfer_with_tag
    :parameters (?patient_case - patient_case ?triage_tag_device - triage_tag_device)
    :precondition
      (and
        (in_treatment_flag ?patient_case)
        (staged_for_treatment ?patient_case)
        (not
          (triage_tag_applied ?patient_case)
        )
        (triage_tag_available ?triage_tag_device)
        (not
          (ready_for_transfer_flag ?patient_case)
        )
      )
    :effect
      (and
        (ready_for_transfer_flag ?patient_case)
        (not
          (triage_tag_available ?triage_tag_device)
        )
      )
  )
  (:action reserve_receiving_facility
    :parameters (?patient_case - patient_case ?receiving_facility - receiving_facility)
    :precondition
      (and
        (ready_for_transfer_flag ?patient_case)
        (receiving_facility_available ?receiving_facility)
        (on_scene_facility_compatibility ?patient_case ?receiving_facility)
      )
    :effect
      (and
        (reserved_receiving_facility ?patient_case ?receiving_facility)
        (not
          (receiving_facility_available ?receiving_facility)
        )
      )
  )
  (:action confirm_receiving_facility_acceptance_for_in_hospital_patient
    :parameters (?in_hospital_patient - in_hospital_patient ?on_scene_patient - on_scene_patient ?receiving_facility - receiving_facility)
    :precondition
      (and
        (registered_present ?in_hospital_patient)
        (is_in_hospital ?in_hospital_patient)
        (facility_request_eligibility ?in_hospital_patient ?receiving_facility)
        (reserved_receiving_facility ?on_scene_patient ?receiving_facility)
        (not
          (facility_confirmed_acceptance ?in_hospital_patient ?receiving_facility)
        )
      )
    :effect
      (and
        (facility_confirmed_acceptance ?in_hospital_patient ?receiving_facility)
      )
  )
  (:action mark_ready_for_transport
    :parameters (?patient_case - patient_case ?stretcher - stretcher ?logistics_staff - logistics_staff)
    :precondition
      (and
        (registered_present ?patient_case)
        (is_in_hospital ?patient_case)
        (staged_for_treatment ?patient_case)
        (ready_for_transfer_flag ?patient_case)
        (reserved_stretcher ?patient_case ?stretcher)
        (logistics_staff_available ?logistics_staff)
        (not
          (transport_ready_flag ?patient_case)
        )
      )
    :effect
      (and
        (transport_ready_flag ?patient_case)
      )
  )
  (:action finalize_disposition_no_transfer
    :parameters (?patient_case - patient_case)
    :precondition
      (and
        (is_on_scene ?patient_case)
        (registered_present ?patient_case)
        (reserved_treatment_space ?patient_case)
        (evaluated_flag ?patient_case)
        (in_treatment_flag ?patient_case)
        (ready_for_transfer_flag ?patient_case)
        (staged_for_treatment ?patient_case)
        (not
          (finalized_disposition ?patient_case)
        )
      )
    :effect
      (and
        (finalized_disposition ?patient_case)
      )
  )
  (:action finalize_disposition_with_facility
    :parameters (?patient_case - patient_case ?receiving_facility - receiving_facility)
    :precondition
      (and
        (is_in_hospital ?patient_case)
        (registered_present ?patient_case)
        (reserved_treatment_space ?patient_case)
        (evaluated_flag ?patient_case)
        (in_treatment_flag ?patient_case)
        (ready_for_transfer_flag ?patient_case)
        (staged_for_treatment ?patient_case)
        (facility_confirmed_acceptance ?patient_case ?receiving_facility)
        (not
          (finalized_disposition ?patient_case)
        )
      )
    :effect
      (and
        (finalized_disposition ?patient_case)
      )
  )
  (:action finalize_disposition_with_transport_ready
    :parameters (?patient_case - patient_case)
    :precondition
      (and
        (is_in_hospital ?patient_case)
        (registered_present ?patient_case)
        (reserved_treatment_space ?patient_case)
        (evaluated_flag ?patient_case)
        (in_treatment_flag ?patient_case)
        (ready_for_transfer_flag ?patient_case)
        (staged_for_treatment ?patient_case)
        (transport_ready_flag ?patient_case)
        (not
          (finalized_disposition ?patient_case)
        )
      )
    :effect
      (and
        (finalized_disposition ?patient_case)
      )
  )
)

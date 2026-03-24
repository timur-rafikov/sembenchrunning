(define (domain biosecurity_breach_investigation_and_restriction_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types response_resource - object supply_class - object pathway_class - object domain_entity - object site - domain_entity field_investigator - response_resource sampling_kit - response_resource response_team - response_resource special_authorization - response_resource logistics_asset - response_resource clearance_document - response_resource laboratory_equipment - response_resource specialist_expertise - response_resource consumable_supply - supply_class diagnostic_sample - supply_class regulatory_permit - supply_class contamination_source - pathway_class transmission_pathway - pathway_class response_resource_bundle - pathway_class production_unit - site administrative_unit - site primary_production_unit - production_unit adjacent_production_unit - production_unit response_organization - administrative_unit)
  (:predicates
    (incident_reported ?site - site)
    (entity_breach_confirmed ?site - site)
    (investigation_assigned ?site - site)
    (entity_cleared ?site - site)
    (entity_ready_for_clearance ?site - site)
    (clearance_requested_for_entity ?site - site)
    (investigator_available ?field_investigator - field_investigator)
    (investigator_assigned_to_entity ?site - site ?field_investigator - field_investigator)
    (sampling_kit_available ?sampling_kit - sampling_kit)
    (sampling_kit_assigned_to_entity ?site - site ?sampling_kit - sampling_kit)
    (response_team_available ?response_team - response_team)
    (response_team_assigned_to_entity ?site - site ?response_team - response_team)
    (consumable_available ?consumable_supply - consumable_supply)
    (supply_allocated_to_unit ?primary_production_unit - primary_production_unit ?consumable_supply - consumable_supply)
    (supply_allocated_to_adjacent_unit ?adjacent_production_unit - adjacent_production_unit ?consumable_supply - consumable_supply)
    (unit_linked_to_contamination_source ?primary_production_unit - primary_production_unit ?contamination_source - contamination_source)
    (contamination_source_flagged ?contamination_source - contamination_source)
    (contamination_source_treated ?contamination_source - contamination_source)
    (primary_unit_mitigation_complete ?primary_production_unit - primary_production_unit)
    (adjacent_unit_linked_to_pathway ?adjacent_production_unit - adjacent_production_unit ?transmission_pathway - transmission_pathway)
    (pathway_flagged ?transmission_pathway - transmission_pathway)
    (pathway_treated ?transmission_pathway - transmission_pathway)
    (adjacent_unit_mitigation_complete ?adjacent_production_unit - adjacent_production_unit)
    (resource_bundle_available ?response_resource_bundle - response_resource_bundle)
    (resource_bundle_staged ?response_resource_bundle - response_resource_bundle)
    (resource_bundle_targets_source ?response_resource_bundle - response_resource_bundle ?contamination_source - contamination_source)
    (resource_bundle_targets_pathway ?response_resource_bundle - response_resource_bundle ?transmission_pathway - transmission_pathway)
    (bundle_contains_high_risk_items ?response_resource_bundle - response_resource_bundle)
    (bundle_contains_controlled_items ?response_resource_bundle - response_resource_bundle)
    (bundle_validated ?response_resource_bundle - response_resource_bundle)
    (organization_oversees_primary_unit ?response_organization - response_organization ?primary_production_unit - primary_production_unit)
    (organization_oversees_adjacent_unit ?response_organization - response_organization ?adjacent_production_unit - adjacent_production_unit)
    (organization_has_resource_bundle ?response_organization - response_organization ?response_resource_bundle - response_resource_bundle)
    (sample_available_for_processing ?diagnostic_sample - diagnostic_sample)
    (organization_has_sample ?response_organization - response_organization ?diagnostic_sample - diagnostic_sample)
    (sample_processed ?diagnostic_sample - diagnostic_sample)
    (sample_linked_to_bundle ?diagnostic_sample - diagnostic_sample ?response_resource_bundle - response_resource_bundle)
    (organization_resources_verified ?response_organization - response_organization)
    (organization_specialist_protocol_ready ?response_organization - response_organization)
    (organization_protocols_executed ?response_organization - response_organization)
    (authorization_initiated ?response_organization - response_organization)
    (organization_authorization_validated ?response_organization - response_organization)
    (organization_has_logistics_assigned ?response_organization - response_organization)
    (organization_readiness_check_complete ?response_organization - response_organization)
    (regulatory_permit_available ?regulatory_permit - regulatory_permit)
    (organization_has_permit ?response_organization - response_organization ?regulatory_permit - regulatory_permit)
    (organization_permit_stage1_completed ?response_organization - response_organization)
    (organization_permit_stage2_completed ?response_organization - response_organization)
    (organization_permit_finalized ?response_organization - response_organization)
    (special_authorization_available ?special_authorization - special_authorization)
    (organization_has_authorization ?response_organization - response_organization ?special_authorization - special_authorization)
    (logistics_asset_available ?logistics_asset - logistics_asset)
    (organization_has_logistics_asset ?response_organization - response_organization ?logistics_asset - logistics_asset)
    (laboratory_equipment_available ?laboratory_equipment - laboratory_equipment)
    (organization_allocated_laboratory_equipment ?response_organization - response_organization ?laboratory_equipment - laboratory_equipment)
    (specialist_expertise_available ?specialist_expertise - specialist_expertise)
    (organization_allocated_specialist_expertise ?response_organization - response_organization ?specialist_expertise - specialist_expertise)
    (clearance_document_available ?clearance_document - clearance_document)
    (site_linked_to_clearance_document ?site - site ?clearance_document - clearance_document)
    (primary_unit_prepared ?primary_production_unit - primary_production_unit)
    (adjacent_unit_prepared ?adjacent_production_unit - adjacent_production_unit)
    (organization_certified_for_clearance ?response_organization - response_organization)
  )
  (:action report_suspected_breach
    :parameters (?site - site)
    :precondition
      (and
        (not
          (incident_reported ?site)
        )
        (not
          (entity_cleared ?site)
        )
      )
    :effect (incident_reported ?site)
  )
  (:action assign_investigator_to_site
    :parameters (?site - site ?field_investigator - field_investigator)
    :precondition
      (and
        (incident_reported ?site)
        (not
          (investigation_assigned ?site)
        )
        (investigator_available ?field_investigator)
      )
    :effect
      (and
        (investigation_assigned ?site)
        (investigator_assigned_to_entity ?site ?field_investigator)
        (not
          (investigator_available ?field_investigator)
        )
      )
  )
  (:action collect_diagnostic_sample
    :parameters (?site - site ?sampling_kit - sampling_kit)
    :precondition
      (and
        (incident_reported ?site)
        (investigation_assigned ?site)
        (sampling_kit_available ?sampling_kit)
      )
    :effect
      (and
        (sampling_kit_assigned_to_entity ?site ?sampling_kit)
        (not
          (sampling_kit_available ?sampling_kit)
        )
      )
  )
  (:action confirm_breach_from_sample
    :parameters (?site - site ?sampling_kit - sampling_kit)
    :precondition
      (and
        (incident_reported ?site)
        (investigation_assigned ?site)
        (sampling_kit_assigned_to_entity ?site ?sampling_kit)
        (not
          (entity_breach_confirmed ?site)
        )
      )
    :effect (entity_breach_confirmed ?site)
  )
  (:action return_sampling_kit
    :parameters (?site - site ?sampling_kit - sampling_kit)
    :precondition
      (and
        (sampling_kit_assigned_to_entity ?site ?sampling_kit)
      )
    :effect
      (and
        (sampling_kit_available ?sampling_kit)
        (not
          (sampling_kit_assigned_to_entity ?site ?sampling_kit)
        )
      )
  )
  (:action assign_response_team_to_site
    :parameters (?site - site ?response_team - response_team)
    :precondition
      (and
        (entity_breach_confirmed ?site)
        (response_team_available ?response_team)
      )
    :effect
      (and
        (response_team_assigned_to_entity ?site ?response_team)
        (not
          (response_team_available ?response_team)
        )
      )
  )
  (:action release_response_team_from_site
    :parameters (?site - site ?response_team - response_team)
    :precondition
      (and
        (response_team_assigned_to_entity ?site ?response_team)
      )
    :effect
      (and
        (response_team_available ?response_team)
        (not
          (response_team_assigned_to_entity ?site ?response_team)
        )
      )
  )
  (:action allocate_laboratory_equipment_to_organization
    :parameters (?response_organization - response_organization ?laboratory_equipment - laboratory_equipment)
    :precondition
      (and
        (entity_breach_confirmed ?response_organization)
        (laboratory_equipment_available ?laboratory_equipment)
      )
    :effect
      (and
        (organization_allocated_laboratory_equipment ?response_organization ?laboratory_equipment)
        (not
          (laboratory_equipment_available ?laboratory_equipment)
        )
      )
  )
  (:action release_laboratory_equipment_from_organization
    :parameters (?response_organization - response_organization ?laboratory_equipment - laboratory_equipment)
    :precondition
      (and
        (organization_allocated_laboratory_equipment ?response_organization ?laboratory_equipment)
      )
    :effect
      (and
        (laboratory_equipment_available ?laboratory_equipment)
        (not
          (organization_allocated_laboratory_equipment ?response_organization ?laboratory_equipment)
        )
      )
  )
  (:action allocate_specialist_to_organization
    :parameters (?response_organization - response_organization ?specialist_expertise - specialist_expertise)
    :precondition
      (and
        (entity_breach_confirmed ?response_organization)
        (specialist_expertise_available ?specialist_expertise)
      )
    :effect
      (and
        (organization_allocated_specialist_expertise ?response_organization ?specialist_expertise)
        (not
          (specialist_expertise_available ?specialist_expertise)
        )
      )
  )
  (:action release_specialist_from_organization
    :parameters (?response_organization - response_organization ?specialist_expertise - specialist_expertise)
    :precondition
      (and
        (organization_allocated_specialist_expertise ?response_organization ?specialist_expertise)
      )
    :effect
      (and
        (specialist_expertise_available ?specialist_expertise)
        (not
          (organization_allocated_specialist_expertise ?response_organization ?specialist_expertise)
        )
      )
  )
  (:action flag_contamination_source_for_unit
    :parameters (?primary_production_unit - primary_production_unit ?contamination_source - contamination_source ?sampling_kit - sampling_kit)
    :precondition
      (and
        (entity_breach_confirmed ?primary_production_unit)
        (sampling_kit_assigned_to_entity ?primary_production_unit ?sampling_kit)
        (unit_linked_to_contamination_source ?primary_production_unit ?contamination_source)
        (not
          (contamination_source_flagged ?contamination_source)
        )
        (not
          (contamination_source_treated ?contamination_source)
        )
      )
    :effect (contamination_source_flagged ?contamination_source)
  )
  (:action conduct_primary_unit_assessment_with_team
    :parameters (?primary_production_unit - primary_production_unit ?contamination_source - contamination_source ?response_team - response_team)
    :precondition
      (and
        (entity_breach_confirmed ?primary_production_unit)
        (response_team_assigned_to_entity ?primary_production_unit ?response_team)
        (unit_linked_to_contamination_source ?primary_production_unit ?contamination_source)
        (contamination_source_flagged ?contamination_source)
        (not
          (primary_unit_prepared ?primary_production_unit)
        )
      )
    :effect
      (and
        (primary_unit_prepared ?primary_production_unit)
        (primary_unit_mitigation_complete ?primary_production_unit)
      )
  )
  (:action deploy_consumables_to_primary_unit
    :parameters (?primary_production_unit - primary_production_unit ?contamination_source - contamination_source ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_breach_confirmed ?primary_production_unit)
        (unit_linked_to_contamination_source ?primary_production_unit ?contamination_source)
        (consumable_available ?consumable_supply)
        (not
          (primary_unit_prepared ?primary_production_unit)
        )
      )
    :effect
      (and
        (contamination_source_treated ?contamination_source)
        (primary_unit_prepared ?primary_production_unit)
        (supply_allocated_to_unit ?primary_production_unit ?consumable_supply)
        (not
          (consumable_available ?consumable_supply)
        )
      )
  )
  (:action complete_primary_unit_supply_cycle
    :parameters (?primary_production_unit - primary_production_unit ?contamination_source - contamination_source ?sampling_kit - sampling_kit ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_breach_confirmed ?primary_production_unit)
        (sampling_kit_assigned_to_entity ?primary_production_unit ?sampling_kit)
        (unit_linked_to_contamination_source ?primary_production_unit ?contamination_source)
        (contamination_source_treated ?contamination_source)
        (supply_allocated_to_unit ?primary_production_unit ?consumable_supply)
        (not
          (primary_unit_mitigation_complete ?primary_production_unit)
        )
      )
    :effect
      (and
        (contamination_source_flagged ?contamination_source)
        (primary_unit_mitigation_complete ?primary_production_unit)
        (consumable_available ?consumable_supply)
        (not
          (supply_allocated_to_unit ?primary_production_unit ?consumable_supply)
        )
      )
  )
  (:action flag_transmission_pathway_for_adjacent_unit
    :parameters (?adjacent_production_unit - adjacent_production_unit ?transmission_pathway - transmission_pathway ?sampling_kit - sampling_kit)
    :precondition
      (and
        (entity_breach_confirmed ?adjacent_production_unit)
        (sampling_kit_assigned_to_entity ?adjacent_production_unit ?sampling_kit)
        (adjacent_unit_linked_to_pathway ?adjacent_production_unit ?transmission_pathway)
        (not
          (pathway_flagged ?transmission_pathway)
        )
        (not
          (pathway_treated ?transmission_pathway)
        )
      )
    :effect (pathway_flagged ?transmission_pathway)
  )
  (:action conduct_adjacent_unit_assessment_with_team
    :parameters (?adjacent_production_unit - adjacent_production_unit ?transmission_pathway - transmission_pathway ?response_team - response_team)
    :precondition
      (and
        (entity_breach_confirmed ?adjacent_production_unit)
        (response_team_assigned_to_entity ?adjacent_production_unit ?response_team)
        (adjacent_unit_linked_to_pathway ?adjacent_production_unit ?transmission_pathway)
        (pathway_flagged ?transmission_pathway)
        (not
          (adjacent_unit_prepared ?adjacent_production_unit)
        )
      )
    :effect
      (and
        (adjacent_unit_prepared ?adjacent_production_unit)
        (adjacent_unit_mitigation_complete ?adjacent_production_unit)
      )
  )
  (:action deploy_consumables_to_adjacent_unit
    :parameters (?adjacent_production_unit - adjacent_production_unit ?transmission_pathway - transmission_pathway ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_breach_confirmed ?adjacent_production_unit)
        (adjacent_unit_linked_to_pathway ?adjacent_production_unit ?transmission_pathway)
        (consumable_available ?consumable_supply)
        (not
          (adjacent_unit_prepared ?adjacent_production_unit)
        )
      )
    :effect
      (and
        (pathway_treated ?transmission_pathway)
        (adjacent_unit_prepared ?adjacent_production_unit)
        (supply_allocated_to_adjacent_unit ?adjacent_production_unit ?consumable_supply)
        (not
          (consumable_available ?consumable_supply)
        )
      )
  )
  (:action complete_adjacent_unit_supply_cycle
    :parameters (?adjacent_production_unit - adjacent_production_unit ?transmission_pathway - transmission_pathway ?sampling_kit - sampling_kit ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_breach_confirmed ?adjacent_production_unit)
        (sampling_kit_assigned_to_entity ?adjacent_production_unit ?sampling_kit)
        (adjacent_unit_linked_to_pathway ?adjacent_production_unit ?transmission_pathway)
        (pathway_treated ?transmission_pathway)
        (supply_allocated_to_adjacent_unit ?adjacent_production_unit ?consumable_supply)
        (not
          (adjacent_unit_mitigation_complete ?adjacent_production_unit)
        )
      )
    :effect
      (and
        (pathway_flagged ?transmission_pathway)
        (adjacent_unit_mitigation_complete ?adjacent_production_unit)
        (consumable_available ?consumable_supply)
        (not
          (supply_allocated_to_adjacent_unit ?adjacent_production_unit ?consumable_supply)
        )
      )
  )
  (:action assemble_response_resource_bundle_standard
    :parameters (?primary_production_unit - primary_production_unit ?adjacent_production_unit - adjacent_production_unit ?contamination_source - contamination_source ?transmission_pathway - transmission_pathway ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (primary_unit_prepared ?primary_production_unit)
        (adjacent_unit_prepared ?adjacent_production_unit)
        (unit_linked_to_contamination_source ?primary_production_unit ?contamination_source)
        (adjacent_unit_linked_to_pathway ?adjacent_production_unit ?transmission_pathway)
        (contamination_source_flagged ?contamination_source)
        (pathway_flagged ?transmission_pathway)
        (primary_unit_mitigation_complete ?primary_production_unit)
        (adjacent_unit_mitigation_complete ?adjacent_production_unit)
        (resource_bundle_available ?response_resource_bundle)
      )
    :effect
      (and
        (resource_bundle_staged ?response_resource_bundle)
        (resource_bundle_targets_source ?response_resource_bundle ?contamination_source)
        (resource_bundle_targets_pathway ?response_resource_bundle ?transmission_pathway)
        (not
          (resource_bundle_available ?response_resource_bundle)
        )
      )
  )
  (:action assemble_response_resource_bundle_with_high_risk_items
    :parameters (?primary_production_unit - primary_production_unit ?adjacent_production_unit - adjacent_production_unit ?contamination_source - contamination_source ?transmission_pathway - transmission_pathway ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (primary_unit_prepared ?primary_production_unit)
        (adjacent_unit_prepared ?adjacent_production_unit)
        (unit_linked_to_contamination_source ?primary_production_unit ?contamination_source)
        (adjacent_unit_linked_to_pathway ?adjacent_production_unit ?transmission_pathway)
        (contamination_source_treated ?contamination_source)
        (pathway_flagged ?transmission_pathway)
        (not
          (primary_unit_mitigation_complete ?primary_production_unit)
        )
        (adjacent_unit_mitigation_complete ?adjacent_production_unit)
        (resource_bundle_available ?response_resource_bundle)
      )
    :effect
      (and
        (resource_bundle_staged ?response_resource_bundle)
        (resource_bundle_targets_source ?response_resource_bundle ?contamination_source)
        (resource_bundle_targets_pathway ?response_resource_bundle ?transmission_pathway)
        (bundle_contains_high_risk_items ?response_resource_bundle)
        (not
          (resource_bundle_available ?response_resource_bundle)
        )
      )
  )
  (:action assemble_response_resource_bundle_with_controlled_items
    :parameters (?primary_production_unit - primary_production_unit ?adjacent_production_unit - adjacent_production_unit ?contamination_source - contamination_source ?transmission_pathway - transmission_pathway ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (primary_unit_prepared ?primary_production_unit)
        (adjacent_unit_prepared ?adjacent_production_unit)
        (unit_linked_to_contamination_source ?primary_production_unit ?contamination_source)
        (adjacent_unit_linked_to_pathway ?adjacent_production_unit ?transmission_pathway)
        (contamination_source_flagged ?contamination_source)
        (pathway_treated ?transmission_pathway)
        (primary_unit_mitigation_complete ?primary_production_unit)
        (not
          (adjacent_unit_mitigation_complete ?adjacent_production_unit)
        )
        (resource_bundle_available ?response_resource_bundle)
      )
    :effect
      (and
        (resource_bundle_staged ?response_resource_bundle)
        (resource_bundle_targets_source ?response_resource_bundle ?contamination_source)
        (resource_bundle_targets_pathway ?response_resource_bundle ?transmission_pathway)
        (bundle_contains_controlled_items ?response_resource_bundle)
        (not
          (resource_bundle_available ?response_resource_bundle)
        )
      )
  )
  (:action assemble_response_resource_bundle_full
    :parameters (?primary_production_unit - primary_production_unit ?adjacent_production_unit - adjacent_production_unit ?contamination_source - contamination_source ?transmission_pathway - transmission_pathway ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (primary_unit_prepared ?primary_production_unit)
        (adjacent_unit_prepared ?adjacent_production_unit)
        (unit_linked_to_contamination_source ?primary_production_unit ?contamination_source)
        (adjacent_unit_linked_to_pathway ?adjacent_production_unit ?transmission_pathway)
        (contamination_source_treated ?contamination_source)
        (pathway_treated ?transmission_pathway)
        (not
          (primary_unit_mitigation_complete ?primary_production_unit)
        )
        (not
          (adjacent_unit_mitigation_complete ?adjacent_production_unit)
        )
        (resource_bundle_available ?response_resource_bundle)
      )
    :effect
      (and
        (resource_bundle_staged ?response_resource_bundle)
        (resource_bundle_targets_source ?response_resource_bundle ?contamination_source)
        (resource_bundle_targets_pathway ?response_resource_bundle ?transmission_pathway)
        (bundle_contains_high_risk_items ?response_resource_bundle)
        (bundle_contains_controlled_items ?response_resource_bundle)
        (not
          (resource_bundle_available ?response_resource_bundle)
        )
      )
  )
  (:action validate_bundle_predeployment
    :parameters (?response_resource_bundle - response_resource_bundle ?primary_production_unit - primary_production_unit ?sampling_kit - sampling_kit)
    :precondition
      (and
        (resource_bundle_staged ?response_resource_bundle)
        (primary_unit_prepared ?primary_production_unit)
        (sampling_kit_assigned_to_entity ?primary_production_unit ?sampling_kit)
        (not
          (bundle_validated ?response_resource_bundle)
        )
      )
    :effect (bundle_validated ?response_resource_bundle)
  )
  (:action register_sample_with_organization
    :parameters (?response_organization - response_organization ?diagnostic_sample - diagnostic_sample ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (entity_breach_confirmed ?response_organization)
        (organization_has_resource_bundle ?response_organization ?response_resource_bundle)
        (organization_has_sample ?response_organization ?diagnostic_sample)
        (sample_available_for_processing ?diagnostic_sample)
        (resource_bundle_staged ?response_resource_bundle)
        (bundle_validated ?response_resource_bundle)
        (not
          (sample_processed ?diagnostic_sample)
        )
      )
    :effect
      (and
        (sample_processed ?diagnostic_sample)
        (sample_linked_to_bundle ?diagnostic_sample ?response_resource_bundle)
        (not
          (sample_available_for_processing ?diagnostic_sample)
        )
      )
  )
  (:action process_diagnostic_sample_at_organization
    :parameters (?response_organization - response_organization ?diagnostic_sample - diagnostic_sample ?response_resource_bundle - response_resource_bundle ?sampling_kit - sampling_kit)
    :precondition
      (and
        (entity_breach_confirmed ?response_organization)
        (organization_has_sample ?response_organization ?diagnostic_sample)
        (sample_processed ?diagnostic_sample)
        (sample_linked_to_bundle ?diagnostic_sample ?response_resource_bundle)
        (sampling_kit_assigned_to_entity ?response_organization ?sampling_kit)
        (not
          (bundle_contains_high_risk_items ?response_resource_bundle)
        )
        (not
          (organization_resources_verified ?response_organization)
        )
      )
    :effect (organization_resources_verified ?response_organization)
  )
  (:action assign_special_authorization_to_organization
    :parameters (?response_organization - response_organization ?special_authorization - special_authorization)
    :precondition
      (and
        (entity_breach_confirmed ?response_organization)
        (special_authorization_available ?special_authorization)
        (not
          (authorization_initiated ?response_organization)
        )
      )
    :effect
      (and
        (authorization_initiated ?response_organization)
        (organization_has_authorization ?response_organization ?special_authorization)
        (not
          (special_authorization_available ?special_authorization)
        )
      )
  )
  (:action apply_special_authorization_and_verify_resources
    :parameters (?response_organization - response_organization ?diagnostic_sample - diagnostic_sample ?response_resource_bundle - response_resource_bundle ?sampling_kit - sampling_kit ?special_authorization - special_authorization)
    :precondition
      (and
        (entity_breach_confirmed ?response_organization)
        (organization_has_sample ?response_organization ?diagnostic_sample)
        (sample_processed ?diagnostic_sample)
        (sample_linked_to_bundle ?diagnostic_sample ?response_resource_bundle)
        (sampling_kit_assigned_to_entity ?response_organization ?sampling_kit)
        (bundle_contains_high_risk_items ?response_resource_bundle)
        (authorization_initiated ?response_organization)
        (organization_has_authorization ?response_organization ?special_authorization)
        (not
          (organization_resources_verified ?response_organization)
        )
      )
    :effect
      (and
        (organization_resources_verified ?response_organization)
        (organization_authorization_validated ?response_organization)
      )
  )
  (:action execute_specialized_intervention_with_lab_equipment
    :parameters (?response_organization - response_organization ?laboratory_equipment - laboratory_equipment ?response_team - response_team ?diagnostic_sample - diagnostic_sample ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (organization_resources_verified ?response_organization)
        (organization_allocated_laboratory_equipment ?response_organization ?laboratory_equipment)
        (response_team_assigned_to_entity ?response_organization ?response_team)
        (organization_has_sample ?response_organization ?diagnostic_sample)
        (sample_linked_to_bundle ?diagnostic_sample ?response_resource_bundle)
        (not
          (bundle_contains_controlled_items ?response_resource_bundle)
        )
        (not
          (organization_specialist_protocol_ready ?response_organization)
        )
      )
    :effect (organization_specialist_protocol_ready ?response_organization)
  )
  (:action execute_specialized_intervention_with_controlled_items
    :parameters (?response_organization - response_organization ?laboratory_equipment - laboratory_equipment ?response_team - response_team ?diagnostic_sample - diagnostic_sample ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (organization_resources_verified ?response_organization)
        (organization_allocated_laboratory_equipment ?response_organization ?laboratory_equipment)
        (response_team_assigned_to_entity ?response_organization ?response_team)
        (organization_has_sample ?response_organization ?diagnostic_sample)
        (sample_linked_to_bundle ?diagnostic_sample ?response_resource_bundle)
        (bundle_contains_controlled_items ?response_resource_bundle)
        (not
          (organization_specialist_protocol_ready ?response_organization)
        )
      )
    :effect (organization_specialist_protocol_ready ?response_organization)
  )
  (:action initiate_organization_protocol_with_specialist
    :parameters (?response_organization - response_organization ?specialist_expertise - specialist_expertise ?diagnostic_sample - diagnostic_sample ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (organization_specialist_protocol_ready ?response_organization)
        (organization_allocated_specialist_expertise ?response_organization ?specialist_expertise)
        (organization_has_sample ?response_organization ?diagnostic_sample)
        (sample_linked_to_bundle ?diagnostic_sample ?response_resource_bundle)
        (not
          (bundle_contains_high_risk_items ?response_resource_bundle)
        )
        (not
          (bundle_contains_controlled_items ?response_resource_bundle)
        )
        (not
          (organization_protocols_executed ?response_organization)
        )
      )
    :effect (organization_protocols_executed ?response_organization)
  )
  (:action complete_organization_protocol_with_logistics
    :parameters (?response_organization - response_organization ?specialist_expertise - specialist_expertise ?diagnostic_sample - diagnostic_sample ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (organization_specialist_protocol_ready ?response_organization)
        (organization_allocated_specialist_expertise ?response_organization ?specialist_expertise)
        (organization_has_sample ?response_organization ?diagnostic_sample)
        (sample_linked_to_bundle ?diagnostic_sample ?response_resource_bundle)
        (bundle_contains_high_risk_items ?response_resource_bundle)
        (not
          (bundle_contains_controlled_items ?response_resource_bundle)
        )
        (not
          (organization_protocols_executed ?response_organization)
        )
      )
    :effect
      (and
        (organization_protocols_executed ?response_organization)
        (organization_has_logistics_assigned ?response_organization)
      )
  )
  (:action complete_organization_protocol_variant_b
    :parameters (?response_organization - response_organization ?specialist_expertise - specialist_expertise ?diagnostic_sample - diagnostic_sample ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (organization_specialist_protocol_ready ?response_organization)
        (organization_allocated_specialist_expertise ?response_organization ?specialist_expertise)
        (organization_has_sample ?response_organization ?diagnostic_sample)
        (sample_linked_to_bundle ?diagnostic_sample ?response_resource_bundle)
        (not
          (bundle_contains_high_risk_items ?response_resource_bundle)
        )
        (bundle_contains_controlled_items ?response_resource_bundle)
        (not
          (organization_protocols_executed ?response_organization)
        )
      )
    :effect
      (and
        (organization_protocols_executed ?response_organization)
        (organization_has_logistics_assigned ?response_organization)
      )
  )
  (:action complete_organization_protocol_variant_c
    :parameters (?response_organization - response_organization ?specialist_expertise - specialist_expertise ?diagnostic_sample - diagnostic_sample ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (organization_specialist_protocol_ready ?response_organization)
        (organization_allocated_specialist_expertise ?response_organization ?specialist_expertise)
        (organization_has_sample ?response_organization ?diagnostic_sample)
        (sample_linked_to_bundle ?diagnostic_sample ?response_resource_bundle)
        (bundle_contains_high_risk_items ?response_resource_bundle)
        (bundle_contains_controlled_items ?response_resource_bundle)
        (not
          (organization_protocols_executed ?response_organization)
        )
      )
    :effect
      (and
        (organization_protocols_executed ?response_organization)
        (organization_has_logistics_assigned ?response_organization)
      )
  )
  (:action certify_organization_for_clearance
    :parameters (?response_organization - response_organization)
    :precondition
      (and
        (organization_protocols_executed ?response_organization)
        (not
          (organization_has_logistics_assigned ?response_organization)
        )
        (not
          (organization_certified_for_clearance ?response_organization)
        )
      )
    :effect
      (and
        (organization_certified_for_clearance ?response_organization)
        (entity_ready_for_clearance ?response_organization)
      )
  )
  (:action allocate_logistics_asset_to_organization
    :parameters (?response_organization - response_organization ?logistics_asset - logistics_asset)
    :precondition
      (and
        (organization_protocols_executed ?response_organization)
        (organization_has_logistics_assigned ?response_organization)
        (logistics_asset_available ?logistics_asset)
      )
    :effect
      (and
        (organization_has_logistics_asset ?response_organization ?logistics_asset)
        (not
          (logistics_asset_available ?logistics_asset)
        )
      )
  )
  (:action conduct_organization_final_checks_before_certification
    :parameters (?response_organization - response_organization ?primary_production_unit - primary_production_unit ?adjacent_production_unit - adjacent_production_unit ?sampling_kit - sampling_kit ?logistics_asset - logistics_asset)
    :precondition
      (and
        (organization_protocols_executed ?response_organization)
        (organization_has_logistics_assigned ?response_organization)
        (organization_has_logistics_asset ?response_organization ?logistics_asset)
        (organization_oversees_primary_unit ?response_organization ?primary_production_unit)
        (organization_oversees_adjacent_unit ?response_organization ?adjacent_production_unit)
        (primary_unit_mitigation_complete ?primary_production_unit)
        (adjacent_unit_mitigation_complete ?adjacent_production_unit)
        (sampling_kit_assigned_to_entity ?response_organization ?sampling_kit)
        (not
          (organization_readiness_check_complete ?response_organization)
        )
      )
    :effect (organization_readiness_check_complete ?response_organization)
  )
  (:action finalize_organization_certification
    :parameters (?response_organization - response_organization)
    :precondition
      (and
        (organization_protocols_executed ?response_organization)
        (organization_readiness_check_complete ?response_organization)
        (not
          (organization_certified_for_clearance ?response_organization)
        )
      )
    :effect
      (and
        (organization_certified_for_clearance ?response_organization)
        (entity_ready_for_clearance ?response_organization)
      )
  )
  (:action initiate_regulatory_permit_process
    :parameters (?response_organization - response_organization ?regulatory_permit - regulatory_permit ?sampling_kit - sampling_kit)
    :precondition
      (and
        (entity_breach_confirmed ?response_organization)
        (sampling_kit_assigned_to_entity ?response_organization ?sampling_kit)
        (regulatory_permit_available ?regulatory_permit)
        (organization_has_permit ?response_organization ?regulatory_permit)
        (not
          (organization_permit_stage1_completed ?response_organization)
        )
      )
    :effect
      (and
        (organization_permit_stage1_completed ?response_organization)
        (not
          (regulatory_permit_available ?regulatory_permit)
        )
      )
  )
  (:action advance_permit_stage_two_for_organization
    :parameters (?response_organization - response_organization ?response_team - response_team)
    :precondition
      (and
        (organization_permit_stage1_completed ?response_organization)
        (response_team_assigned_to_entity ?response_organization ?response_team)
        (not
          (organization_permit_stage2_completed ?response_organization)
        )
      )
    :effect (organization_permit_stage2_completed ?response_organization)
  )
  (:action finalize_permit_and_assign_specialist
    :parameters (?response_organization - response_organization ?specialist_expertise - specialist_expertise)
    :precondition
      (and
        (organization_permit_stage2_completed ?response_organization)
        (organization_allocated_specialist_expertise ?response_organization ?specialist_expertise)
        (not
          (organization_permit_finalized ?response_organization)
        )
      )
    :effect (organization_permit_finalized ?response_organization)
  )
  (:action issue_permit_and_certify_organization
    :parameters (?response_organization - response_organization)
    :precondition
      (and
        (organization_permit_finalized ?response_organization)
        (not
          (organization_certified_for_clearance ?response_organization)
        )
      )
    :effect
      (and
        (organization_certified_for_clearance ?response_organization)
        (entity_ready_for_clearance ?response_organization)
      )
  )
  (:action issue_clearance_to_primary_unit
    :parameters (?primary_production_unit - primary_production_unit ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (primary_unit_prepared ?primary_production_unit)
        (primary_unit_mitigation_complete ?primary_production_unit)
        (resource_bundle_staged ?response_resource_bundle)
        (bundle_validated ?response_resource_bundle)
        (not
          (entity_ready_for_clearance ?primary_production_unit)
        )
      )
    :effect (entity_ready_for_clearance ?primary_production_unit)
  )
  (:action issue_clearance_to_adjacent_unit
    :parameters (?adjacent_production_unit - adjacent_production_unit ?response_resource_bundle - response_resource_bundle)
    :precondition
      (and
        (adjacent_unit_prepared ?adjacent_production_unit)
        (adjacent_unit_mitigation_complete ?adjacent_production_unit)
        (resource_bundle_staged ?response_resource_bundle)
        (bundle_validated ?response_resource_bundle)
        (not
          (entity_ready_for_clearance ?adjacent_production_unit)
        )
      )
    :effect (entity_ready_for_clearance ?adjacent_production_unit)
  )
  (:action create_clearance_request_for_site
    :parameters (?site - site ?clearance_document - clearance_document ?sampling_kit - sampling_kit)
    :precondition
      (and
        (entity_ready_for_clearance ?site)
        (sampling_kit_assigned_to_entity ?site ?sampling_kit)
        (clearance_document_available ?clearance_document)
        (not
          (clearance_requested_for_entity ?site)
        )
      )
    :effect
      (and
        (clearance_requested_for_entity ?site)
        (site_linked_to_clearance_document ?site ?clearance_document)
        (not
          (clearance_document_available ?clearance_document)
        )
      )
  )
  (:action apply_clearance_and_release_resources_for_primary_unit
    :parameters (?primary_production_unit - primary_production_unit ?field_investigator - field_investigator ?clearance_document - clearance_document)
    :precondition
      (and
        (clearance_requested_for_entity ?primary_production_unit)
        (investigator_assigned_to_entity ?primary_production_unit ?field_investigator)
        (site_linked_to_clearance_document ?primary_production_unit ?clearance_document)
        (not
          (entity_cleared ?primary_production_unit)
        )
      )
    :effect
      (and
        (entity_cleared ?primary_production_unit)
        (investigator_available ?field_investigator)
        (clearance_document_available ?clearance_document)
      )
  )
  (:action apply_clearance_and_release_resources_for_adjacent_unit
    :parameters (?adjacent_production_unit - adjacent_production_unit ?field_investigator - field_investigator ?clearance_document - clearance_document)
    :precondition
      (and
        (clearance_requested_for_entity ?adjacent_production_unit)
        (investigator_assigned_to_entity ?adjacent_production_unit ?field_investigator)
        (site_linked_to_clearance_document ?adjacent_production_unit ?clearance_document)
        (not
          (entity_cleared ?adjacent_production_unit)
        )
      )
    :effect
      (and
        (entity_cleared ?adjacent_production_unit)
        (investigator_available ?field_investigator)
        (clearance_document_available ?clearance_document)
      )
  )
  (:action apply_clearance_and_release_resources_for_organization
    :parameters (?response_organization - response_organization ?field_investigator - field_investigator ?clearance_document - clearance_document)
    :precondition
      (and
        (clearance_requested_for_entity ?response_organization)
        (investigator_assigned_to_entity ?response_organization ?field_investigator)
        (site_linked_to_clearance_document ?response_organization ?clearance_document)
        (not
          (entity_cleared ?response_organization)
        )
      )
    :effect
      (and
        (entity_cleared ?response_organization)
        (investigator_available ?field_investigator)
        (clearance_document_available ?clearance_document)
      )
  )
)

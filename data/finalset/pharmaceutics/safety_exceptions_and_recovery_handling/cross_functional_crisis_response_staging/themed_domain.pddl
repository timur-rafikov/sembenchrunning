(define (domain pharm_crisis_response_staging)
  (:requirements :strips :typing :negative-preconditions)
  (:types organizational_unit - object resource_category - object event_category - object incident_category - object safety_incident - incident_category response_role - organizational_unit laboratory_sample - organizational_unit containment_asset - organizational_unit external_stakeholder - organizational_unit logistics_resource - organizational_unit communication_template - organizational_unit testing_capability - organizational_unit contract_laboratory - organizational_unit supplier_option - resource_category production_batch - resource_category regulatory_notice - resource_category contaminant_indicator - event_category recall_scope - event_category recall_event - event_category site_group - safety_incident coordination_group - safety_incident manufacturing_site - site_group distribution_site - site_group crisis_coordination_team - coordination_group)
  (:predicates
    (incident_reported ?safety_incident - safety_incident)
    (entity_confirmed ?safety_incident - safety_incident)
    (incident_assigned ?safety_incident - safety_incident)
    (entity_return_to_operation ?safety_incident - safety_incident)
    (operational_signoff_for_entity ?safety_incident - safety_incident)
    (communications_sent_for_entity ?safety_incident - safety_incident)
    (role_available ?response_role - response_role)
    (entity_assigned_role ?safety_incident - safety_incident ?response_role - response_role)
    (sample_available ?laboratory_sample - laboratory_sample)
    (sample_linked_to_entity ?safety_incident - safety_incident ?laboratory_sample - laboratory_sample)
    (containment_asset_available ?containment_asset - containment_asset)
    (entity_has_containment ?safety_incident - safety_incident ?containment_asset - containment_asset)
    (alternate_supplier_available ?supplier_option - supplier_option)
    (manufacturing_site_supplier_option ?manufacturing_site - manufacturing_site ?supplier_option - supplier_option)
    (distribution_site_supplier_option ?distribution_site - distribution_site ?supplier_option - supplier_option)
    (site_contaminant_indicator ?manufacturing_site - manufacturing_site ?contaminant_indicator - contaminant_indicator)
    (indicator_flagged_for_action ?contaminant_indicator - contaminant_indicator)
    (indicator_mitigation_active ?contaminant_indicator - contaminant_indicator)
    (site_mitigation_recorded ?manufacturing_site - manufacturing_site)
    (distribution_recall_scope_assigned ?distribution_site - distribution_site ?recall_scope - recall_scope)
    (recall_scope_ready ?recall_scope - recall_scope)
    (recall_scope_pending ?recall_scope - recall_scope)
    (distribution_site_mitigation_recorded ?distribution_site - distribution_site)
    (recall_event_available ?recall_event - recall_event)
    (recall_event_staged ?recall_event - recall_event)
    (recall_event_has_contaminant ?recall_event - recall_event ?contaminant_indicator - contaminant_indicator)
    (recall_event_applies_to_scope ?recall_event - recall_event ?recall_scope - recall_scope)
    (recall_event_requires_additional_approval ?recall_event - recall_event)
    (recall_event_requires_regulatory_action ?recall_event - recall_event)
    (recall_event_processed ?recall_event - recall_event)
    (team_assigned_to_manufacturing_site ?crisis_coordination_team - crisis_coordination_team ?manufacturing_site - manufacturing_site)
    (team_assigned_to_distribution_site ?crisis_coordination_team - crisis_coordination_team ?distribution_site - distribution_site)
    (team_assigned_to_recall_event ?crisis_coordination_team - crisis_coordination_team ?recall_event - recall_event)
    (production_batch_available ?production_batch - production_batch)
    (team_assigned_to_batch ?crisis_coordination_team - crisis_coordination_team ?production_batch - production_batch)
    (batch_tagged_for_recall ?production_batch - production_batch)
    (batch_linked_to_recall_event ?production_batch - production_batch ?recall_event - recall_event)
    (team_approval_obtained ?crisis_coordination_team - crisis_coordination_team)
    (team_quality_checks_completed ?crisis_coordination_team - crisis_coordination_team)
    (team_ready_for_operational_signoff ?crisis_coordination_team - crisis_coordination_team)
    (team_external_stakeholder_assigned ?crisis_coordination_team - crisis_coordination_team)
    (external_stakeholder_engagement_recorded ?crisis_coordination_team - crisis_coordination_team)
    (logistics_ready ?crisis_coordination_team - crisis_coordination_team)
    (crossfunctional_checklist_completed ?crisis_coordination_team - crisis_coordination_team)
    (regulatory_notice_available ?regulatory_notice - regulatory_notice)
    (team_linked_regulatory_notice ?crisis_coordination_team - crisis_coordination_team ?regulatory_notice - regulatory_notice)
    (regulatory_notice_assigned ?crisis_coordination_team - crisis_coordination_team)
    (regulatory_review_in_progress ?crisis_coordination_team - crisis_coordination_team)
    (regulatory_review_completed ?crisis_coordination_team - crisis_coordination_team)
    (external_stakeholder_available ?external_stakeholder - external_stakeholder)
    (team_assigned_external_stakeholder ?crisis_coordination_team - crisis_coordination_team ?external_stakeholder - external_stakeholder)
    (logistics_resource_available ?logistics_resource - logistics_resource)
    (team_allocated_logistics_resource ?crisis_coordination_team - crisis_coordination_team ?logistics_resource - logistics_resource)
    (testing_capability_available ?testing_capability - testing_capability)
    (team_allocated_testing_capability ?crisis_coordination_team - crisis_coordination_team ?testing_capability - testing_capability)
    (contract_laboratory_available ?contract_laboratory - contract_laboratory)
    (team_allocated_contract_laboratory ?crisis_coordination_team - crisis_coordination_team ?contract_laboratory - contract_laboratory)
    (communication_template_available ?communication_template - communication_template)
    (entity_communication_template_assigned ?safety_incident - safety_incident ?communication_template - communication_template)
    (manufacturing_site_stabilized ?manufacturing_site - manufacturing_site)
    (distribution_site_stabilized ?distribution_site - distribution_site)
    (recovery_signoff_recorded ?crisis_coordination_team - crisis_coordination_team)
  )
  (:action report_safety_incident
    :parameters (?safety_incident - safety_incident)
    :precondition
      (and
        (not
          (incident_reported ?safety_incident)
        )
        (not
          (entity_return_to_operation ?safety_incident)
        )
      )
    :effect (incident_reported ?safety_incident)
  )
  (:action assign_response_role
    :parameters (?safety_incident - safety_incident ?response_role - response_role)
    :precondition
      (and
        (incident_reported ?safety_incident)
        (not
          (incident_assigned ?safety_incident)
        )
        (role_available ?response_role)
      )
    :effect
      (and
        (incident_assigned ?safety_incident)
        (entity_assigned_role ?safety_incident ?response_role)
        (not
          (role_available ?response_role)
        )
      )
  )
  (:action assign_sample_to_incident
    :parameters (?safety_incident - safety_incident ?laboratory_sample - laboratory_sample)
    :precondition
      (and
        (incident_reported ?safety_incident)
        (incident_assigned ?safety_incident)
        (sample_available ?laboratory_sample)
      )
    :effect
      (and
        (sample_linked_to_entity ?safety_incident ?laboratory_sample)
        (not
          (sample_available ?laboratory_sample)
        )
      )
  )
  (:action confirm_incident_after_sample
    :parameters (?safety_incident - safety_incident ?laboratory_sample - laboratory_sample)
    :precondition
      (and
        (incident_reported ?safety_incident)
        (incident_assigned ?safety_incident)
        (sample_linked_to_entity ?safety_incident ?laboratory_sample)
        (not
          (entity_confirmed ?safety_incident)
        )
      )
    :effect (entity_confirmed ?safety_incident)
  )
  (:action release_sample_from_incident
    :parameters (?safety_incident - safety_incident ?laboratory_sample - laboratory_sample)
    :precondition
      (and
        (sample_linked_to_entity ?safety_incident ?laboratory_sample)
      )
    :effect
      (and
        (sample_available ?laboratory_sample)
        (not
          (sample_linked_to_entity ?safety_incident ?laboratory_sample)
        )
      )
  )
  (:action attach_containment_asset_to_incident
    :parameters (?safety_incident - safety_incident ?containment_asset - containment_asset)
    :precondition
      (and
        (entity_confirmed ?safety_incident)
        (containment_asset_available ?containment_asset)
      )
    :effect
      (and
        (entity_has_containment ?safety_incident ?containment_asset)
        (not
          (containment_asset_available ?containment_asset)
        )
      )
  )
  (:action detach_containment_asset_from_incident
    :parameters (?safety_incident - safety_incident ?containment_asset - containment_asset)
    :precondition
      (and
        (entity_has_containment ?safety_incident ?containment_asset)
      )
    :effect
      (and
        (containment_asset_available ?containment_asset)
        (not
          (entity_has_containment ?safety_incident ?containment_asset)
        )
      )
  )
  (:action allocate_testing_capability_to_team
    :parameters (?crisis_coordination_team - crisis_coordination_team ?testing_capability - testing_capability)
    :precondition
      (and
        (entity_confirmed ?crisis_coordination_team)
        (testing_capability_available ?testing_capability)
      )
    :effect
      (and
        (team_allocated_testing_capability ?crisis_coordination_team ?testing_capability)
        (not
          (testing_capability_available ?testing_capability)
        )
      )
  )
  (:action release_testing_capability_from_team
    :parameters (?crisis_coordination_team - crisis_coordination_team ?testing_capability - testing_capability)
    :precondition
      (and
        (team_allocated_testing_capability ?crisis_coordination_team ?testing_capability)
      )
    :effect
      (and
        (testing_capability_available ?testing_capability)
        (not
          (team_allocated_testing_capability ?crisis_coordination_team ?testing_capability)
        )
      )
  )
  (:action allocate_contract_laboratory_to_team
    :parameters (?crisis_coordination_team - crisis_coordination_team ?contract_laboratory - contract_laboratory)
    :precondition
      (and
        (entity_confirmed ?crisis_coordination_team)
        (contract_laboratory_available ?contract_laboratory)
      )
    :effect
      (and
        (team_allocated_contract_laboratory ?crisis_coordination_team ?contract_laboratory)
        (not
          (contract_laboratory_available ?contract_laboratory)
        )
      )
  )
  (:action release_contract_laboratory_from_team
    :parameters (?crisis_coordination_team - crisis_coordination_team ?contract_laboratory - contract_laboratory)
    :precondition
      (and
        (team_allocated_contract_laboratory ?crisis_coordination_team ?contract_laboratory)
      )
    :effect
      (and
        (contract_laboratory_available ?contract_laboratory)
        (not
          (team_allocated_contract_laboratory ?crisis_coordination_team ?contract_laboratory)
        )
      )
  )
  (:action flag_contaminant_indicator_on_site
    :parameters (?manufacturing_site - manufacturing_site ?contaminant_indicator - contaminant_indicator ?laboratory_sample - laboratory_sample)
    :precondition
      (and
        (entity_confirmed ?manufacturing_site)
        (sample_linked_to_entity ?manufacturing_site ?laboratory_sample)
        (site_contaminant_indicator ?manufacturing_site ?contaminant_indicator)
        (not
          (indicator_flagged_for_action ?contaminant_indicator)
        )
        (not
          (indicator_mitigation_active ?contaminant_indicator)
        )
      )
    :effect (indicator_flagged_for_action ?contaminant_indicator)
  )
  (:action apply_containment_and_stabilize_site
    :parameters (?manufacturing_site - manufacturing_site ?contaminant_indicator - contaminant_indicator ?containment_asset - containment_asset)
    :precondition
      (and
        (entity_confirmed ?manufacturing_site)
        (entity_has_containment ?manufacturing_site ?containment_asset)
        (site_contaminant_indicator ?manufacturing_site ?contaminant_indicator)
        (indicator_flagged_for_action ?contaminant_indicator)
        (not
          (manufacturing_site_stabilized ?manufacturing_site)
        )
      )
    :effect
      (and
        (manufacturing_site_stabilized ?manufacturing_site)
        (site_mitigation_recorded ?manufacturing_site)
      )
  )
  (:action allocate_supplier_option_to_site
    :parameters (?manufacturing_site - manufacturing_site ?contaminant_indicator - contaminant_indicator ?supplier_option - supplier_option)
    :precondition
      (and
        (entity_confirmed ?manufacturing_site)
        (site_contaminant_indicator ?manufacturing_site ?contaminant_indicator)
        (alternate_supplier_available ?supplier_option)
        (not
          (manufacturing_site_stabilized ?manufacturing_site)
        )
      )
    :effect
      (and
        (indicator_mitigation_active ?contaminant_indicator)
        (manufacturing_site_stabilized ?manufacturing_site)
        (manufacturing_site_supplier_option ?manufacturing_site ?supplier_option)
        (not
          (alternate_supplier_available ?supplier_option)
        )
      )
  )
  (:action execute_supplier_intervention_and_update_site
    :parameters (?manufacturing_site - manufacturing_site ?contaminant_indicator - contaminant_indicator ?laboratory_sample - laboratory_sample ?supplier_option - supplier_option)
    :precondition
      (and
        (entity_confirmed ?manufacturing_site)
        (sample_linked_to_entity ?manufacturing_site ?laboratory_sample)
        (site_contaminant_indicator ?manufacturing_site ?contaminant_indicator)
        (indicator_mitigation_active ?contaminant_indicator)
        (manufacturing_site_supplier_option ?manufacturing_site ?supplier_option)
        (not
          (site_mitigation_recorded ?manufacturing_site)
        )
      )
    :effect
      (and
        (indicator_flagged_for_action ?contaminant_indicator)
        (site_mitigation_recorded ?manufacturing_site)
        (alternate_supplier_available ?supplier_option)
        (not
          (manufacturing_site_supplier_option ?manufacturing_site ?supplier_option)
        )
      )
  )
  (:action create_recall_scope_for_distribution_node
    :parameters (?distribution_site - distribution_site ?recall_scope - recall_scope ?laboratory_sample - laboratory_sample)
    :precondition
      (and
        (entity_confirmed ?distribution_site)
        (sample_linked_to_entity ?distribution_site ?laboratory_sample)
        (distribution_recall_scope_assigned ?distribution_site ?recall_scope)
        (not
          (recall_scope_ready ?recall_scope)
        )
        (not
          (recall_scope_pending ?recall_scope)
        )
      )
    :effect (recall_scope_ready ?recall_scope)
  )
  (:action allocate_containment_asset_to_distribution_site
    :parameters (?distribution_site - distribution_site ?recall_scope - recall_scope ?containment_asset - containment_asset)
    :precondition
      (and
        (entity_confirmed ?distribution_site)
        (entity_has_containment ?distribution_site ?containment_asset)
        (distribution_recall_scope_assigned ?distribution_site ?recall_scope)
        (recall_scope_ready ?recall_scope)
        (not
          (distribution_site_stabilized ?distribution_site)
        )
      )
    :effect
      (and
        (distribution_site_stabilized ?distribution_site)
        (distribution_site_mitigation_recorded ?distribution_site)
      )
  )
  (:action allocate_supplier_option_to_distribution_site
    :parameters (?distribution_site - distribution_site ?recall_scope - recall_scope ?supplier_option - supplier_option)
    :precondition
      (and
        (entity_confirmed ?distribution_site)
        (distribution_recall_scope_assigned ?distribution_site ?recall_scope)
        (alternate_supplier_available ?supplier_option)
        (not
          (distribution_site_stabilized ?distribution_site)
        )
      )
    :effect
      (and
        (recall_scope_pending ?recall_scope)
        (distribution_site_stabilized ?distribution_site)
        (distribution_site_supplier_option ?distribution_site ?supplier_option)
        (not
          (alternate_supplier_available ?supplier_option)
        )
      )
  )
  (:action execute_supplier_intervention_and_update_distribution_site
    :parameters (?distribution_site - distribution_site ?recall_scope - recall_scope ?laboratory_sample - laboratory_sample ?supplier_option - supplier_option)
    :precondition
      (and
        (entity_confirmed ?distribution_site)
        (sample_linked_to_entity ?distribution_site ?laboratory_sample)
        (distribution_recall_scope_assigned ?distribution_site ?recall_scope)
        (recall_scope_pending ?recall_scope)
        (distribution_site_supplier_option ?distribution_site ?supplier_option)
        (not
          (distribution_site_mitigation_recorded ?distribution_site)
        )
      )
    :effect
      (and
        (recall_scope_ready ?recall_scope)
        (distribution_site_mitigation_recorded ?distribution_site)
        (alternate_supplier_available ?supplier_option)
        (not
          (distribution_site_supplier_option ?distribution_site ?supplier_option)
        )
      )
  )
  (:action stage_recall_event_standard
    :parameters (?manufacturing_site - manufacturing_site ?distribution_site - distribution_site ?contaminant_indicator - contaminant_indicator ?recall_scope - recall_scope ?recall_event - recall_event)
    :precondition
      (and
        (manufacturing_site_stabilized ?manufacturing_site)
        (distribution_site_stabilized ?distribution_site)
        (site_contaminant_indicator ?manufacturing_site ?contaminant_indicator)
        (distribution_recall_scope_assigned ?distribution_site ?recall_scope)
        (indicator_flagged_for_action ?contaminant_indicator)
        (recall_scope_ready ?recall_scope)
        (site_mitigation_recorded ?manufacturing_site)
        (distribution_site_mitigation_recorded ?distribution_site)
        (recall_event_available ?recall_event)
      )
    :effect
      (and
        (recall_event_staged ?recall_event)
        (recall_event_has_contaminant ?recall_event ?contaminant_indicator)
        (recall_event_applies_to_scope ?recall_event ?recall_scope)
        (not
          (recall_event_available ?recall_event)
        )
      )
  )
  (:action stage_recall_event_with_manufacturing_mitigation
    :parameters (?manufacturing_site - manufacturing_site ?distribution_site - distribution_site ?contaminant_indicator - contaminant_indicator ?recall_scope - recall_scope ?recall_event - recall_event)
    :precondition
      (and
        (manufacturing_site_stabilized ?manufacturing_site)
        (distribution_site_stabilized ?distribution_site)
        (site_contaminant_indicator ?manufacturing_site ?contaminant_indicator)
        (distribution_recall_scope_assigned ?distribution_site ?recall_scope)
        (indicator_mitigation_active ?contaminant_indicator)
        (recall_scope_ready ?recall_scope)
        (not
          (site_mitigation_recorded ?manufacturing_site)
        )
        (distribution_site_mitigation_recorded ?distribution_site)
        (recall_event_available ?recall_event)
      )
    :effect
      (and
        (recall_event_staged ?recall_event)
        (recall_event_has_contaminant ?recall_event ?contaminant_indicator)
        (recall_event_applies_to_scope ?recall_event ?recall_scope)
        (recall_event_requires_additional_approval ?recall_event)
        (not
          (recall_event_available ?recall_event)
        )
      )
  )
  (:action stage_recall_event_with_distribution_mitigation
    :parameters (?manufacturing_site - manufacturing_site ?distribution_site - distribution_site ?contaminant_indicator - contaminant_indicator ?recall_scope - recall_scope ?recall_event - recall_event)
    :precondition
      (and
        (manufacturing_site_stabilized ?manufacturing_site)
        (distribution_site_stabilized ?distribution_site)
        (site_contaminant_indicator ?manufacturing_site ?contaminant_indicator)
        (distribution_recall_scope_assigned ?distribution_site ?recall_scope)
        (indicator_flagged_for_action ?contaminant_indicator)
        (recall_scope_pending ?recall_scope)
        (site_mitigation_recorded ?manufacturing_site)
        (not
          (distribution_site_mitigation_recorded ?distribution_site)
        )
        (recall_event_available ?recall_event)
      )
    :effect
      (and
        (recall_event_staged ?recall_event)
        (recall_event_has_contaminant ?recall_event ?contaminant_indicator)
        (recall_event_applies_to_scope ?recall_event ?recall_scope)
        (recall_event_requires_regulatory_action ?recall_event)
        (not
          (recall_event_available ?recall_event)
        )
      )
  )
  (:action stage_recall_event_with_full_mitigation
    :parameters (?manufacturing_site - manufacturing_site ?distribution_site - distribution_site ?contaminant_indicator - contaminant_indicator ?recall_scope - recall_scope ?recall_event - recall_event)
    :precondition
      (and
        (manufacturing_site_stabilized ?manufacturing_site)
        (distribution_site_stabilized ?distribution_site)
        (site_contaminant_indicator ?manufacturing_site ?contaminant_indicator)
        (distribution_recall_scope_assigned ?distribution_site ?recall_scope)
        (indicator_mitigation_active ?contaminant_indicator)
        (recall_scope_pending ?recall_scope)
        (not
          (site_mitigation_recorded ?manufacturing_site)
        )
        (not
          (distribution_site_mitigation_recorded ?distribution_site)
        )
        (recall_event_available ?recall_event)
      )
    :effect
      (and
        (recall_event_staged ?recall_event)
        (recall_event_has_contaminant ?recall_event ?contaminant_indicator)
        (recall_event_applies_to_scope ?recall_event ?recall_scope)
        (recall_event_requires_additional_approval ?recall_event)
        (recall_event_requires_regulatory_action ?recall_event)
        (not
          (recall_event_available ?recall_event)
        )
      )
  )
  (:action process_staged_recall_event
    :parameters (?recall_event - recall_event ?manufacturing_site - manufacturing_site ?laboratory_sample - laboratory_sample)
    :precondition
      (and
        (recall_event_staged ?recall_event)
        (manufacturing_site_stabilized ?manufacturing_site)
        (sample_linked_to_entity ?manufacturing_site ?laboratory_sample)
        (not
          (recall_event_processed ?recall_event)
        )
      )
    :effect (recall_event_processed ?recall_event)
  )
  (:action tag_production_batch_for_recall
    :parameters (?crisis_coordination_team - crisis_coordination_team ?production_batch - production_batch ?recall_event - recall_event)
    :precondition
      (and
        (entity_confirmed ?crisis_coordination_team)
        (team_assigned_to_recall_event ?crisis_coordination_team ?recall_event)
        (team_assigned_to_batch ?crisis_coordination_team ?production_batch)
        (production_batch_available ?production_batch)
        (recall_event_staged ?recall_event)
        (recall_event_processed ?recall_event)
        (not
          (batch_tagged_for_recall ?production_batch)
        )
      )
    :effect
      (and
        (batch_tagged_for_recall ?production_batch)
        (batch_linked_to_recall_event ?production_batch ?recall_event)
        (not
          (production_batch_available ?production_batch)
        )
      )
  )
  (:action obtain_team_approval_for_batch
    :parameters (?crisis_coordination_team - crisis_coordination_team ?production_batch - production_batch ?recall_event - recall_event ?laboratory_sample - laboratory_sample)
    :precondition
      (and
        (entity_confirmed ?crisis_coordination_team)
        (team_assigned_to_batch ?crisis_coordination_team ?production_batch)
        (batch_tagged_for_recall ?production_batch)
        (batch_linked_to_recall_event ?production_batch ?recall_event)
        (sample_linked_to_entity ?crisis_coordination_team ?laboratory_sample)
        (not
          (recall_event_requires_additional_approval ?recall_event)
        )
        (not
          (team_approval_obtained ?crisis_coordination_team)
        )
      )
    :effect (team_approval_obtained ?crisis_coordination_team)
  )
  (:action assign_external_stakeholder_to_team
    :parameters (?crisis_coordination_team - crisis_coordination_team ?external_stakeholder - external_stakeholder)
    :precondition
      (and
        (entity_confirmed ?crisis_coordination_team)
        (external_stakeholder_available ?external_stakeholder)
        (not
          (team_external_stakeholder_assigned ?crisis_coordination_team)
        )
      )
    :effect
      (and
        (team_external_stakeholder_assigned ?crisis_coordination_team)
        (team_assigned_external_stakeholder ?crisis_coordination_team ?external_stakeholder)
        (not
          (external_stakeholder_available ?external_stakeholder)
        )
      )
  )
  (:action engage_external_stakeholder_and_prepare_team
    :parameters (?crisis_coordination_team - crisis_coordination_team ?production_batch - production_batch ?recall_event - recall_event ?laboratory_sample - laboratory_sample ?external_stakeholder - external_stakeholder)
    :precondition
      (and
        (entity_confirmed ?crisis_coordination_team)
        (team_assigned_to_batch ?crisis_coordination_team ?production_batch)
        (batch_tagged_for_recall ?production_batch)
        (batch_linked_to_recall_event ?production_batch ?recall_event)
        (sample_linked_to_entity ?crisis_coordination_team ?laboratory_sample)
        (recall_event_requires_additional_approval ?recall_event)
        (team_external_stakeholder_assigned ?crisis_coordination_team)
        (team_assigned_external_stakeholder ?crisis_coordination_team ?external_stakeholder)
        (not
          (team_approval_obtained ?crisis_coordination_team)
        )
      )
    :effect
      (and
        (team_approval_obtained ?crisis_coordination_team)
        (external_stakeholder_engagement_recorded ?crisis_coordination_team)
      )
  )
  (:action perform_team_testing_and_quality_checks
    :parameters (?crisis_coordination_team - crisis_coordination_team ?testing_capability - testing_capability ?containment_asset - containment_asset ?production_batch - production_batch ?recall_event - recall_event)
    :precondition
      (and
        (team_approval_obtained ?crisis_coordination_team)
        (team_allocated_testing_capability ?crisis_coordination_team ?testing_capability)
        (entity_has_containment ?crisis_coordination_team ?containment_asset)
        (team_assigned_to_batch ?crisis_coordination_team ?production_batch)
        (batch_linked_to_recall_event ?production_batch ?recall_event)
        (not
          (recall_event_requires_regulatory_action ?recall_event)
        )
        (not
          (team_quality_checks_completed ?crisis_coordination_team)
        )
      )
    :effect (team_quality_checks_completed ?crisis_coordination_team)
  )
  (:action perform_team_testing_and_quality_checks_followup
    :parameters (?crisis_coordination_team - crisis_coordination_team ?testing_capability - testing_capability ?containment_asset - containment_asset ?production_batch - production_batch ?recall_event - recall_event)
    :precondition
      (and
        (team_approval_obtained ?crisis_coordination_team)
        (team_allocated_testing_capability ?crisis_coordination_team ?testing_capability)
        (entity_has_containment ?crisis_coordination_team ?containment_asset)
        (team_assigned_to_batch ?crisis_coordination_team ?production_batch)
        (batch_linked_to_recall_event ?production_batch ?recall_event)
        (recall_event_requires_regulatory_action ?recall_event)
        (not
          (team_quality_checks_completed ?crisis_coordination_team)
        )
      )
    :effect (team_quality_checks_completed ?crisis_coordination_team)
  )
  (:action complete_contract_laboratory_testing_and_prepare_signoff
    :parameters (?crisis_coordination_team - crisis_coordination_team ?contract_laboratory - contract_laboratory ?production_batch - production_batch ?recall_event - recall_event)
    :precondition
      (and
        (team_quality_checks_completed ?crisis_coordination_team)
        (team_allocated_contract_laboratory ?crisis_coordination_team ?contract_laboratory)
        (team_assigned_to_batch ?crisis_coordination_team ?production_batch)
        (batch_linked_to_recall_event ?production_batch ?recall_event)
        (not
          (recall_event_requires_additional_approval ?recall_event)
        )
        (not
          (recall_event_requires_regulatory_action ?recall_event)
        )
        (not
          (team_ready_for_operational_signoff ?crisis_coordination_team)
        )
      )
    :effect (team_ready_for_operational_signoff ?crisis_coordination_team)
  )
  (:action complete_contract_laboratory_testing_and_prepare_signoff_with_logistics
    :parameters (?crisis_coordination_team - crisis_coordination_team ?contract_laboratory - contract_laboratory ?production_batch - production_batch ?recall_event - recall_event)
    :precondition
      (and
        (team_quality_checks_completed ?crisis_coordination_team)
        (team_allocated_contract_laboratory ?crisis_coordination_team ?contract_laboratory)
        (team_assigned_to_batch ?crisis_coordination_team ?production_batch)
        (batch_linked_to_recall_event ?production_batch ?recall_event)
        (recall_event_requires_additional_approval ?recall_event)
        (not
          (recall_event_requires_regulatory_action ?recall_event)
        )
        (not
          (team_ready_for_operational_signoff ?crisis_coordination_team)
        )
      )
    :effect
      (and
        (team_ready_for_operational_signoff ?crisis_coordination_team)
        (logistics_ready ?crisis_coordination_team)
      )
  )
  (:action complete_contract_laboratory_testing_and_prepare_signoff_with_regulatory
    :parameters (?crisis_coordination_team - crisis_coordination_team ?contract_laboratory - contract_laboratory ?production_batch - production_batch ?recall_event - recall_event)
    :precondition
      (and
        (team_quality_checks_completed ?crisis_coordination_team)
        (team_allocated_contract_laboratory ?crisis_coordination_team ?contract_laboratory)
        (team_assigned_to_batch ?crisis_coordination_team ?production_batch)
        (batch_linked_to_recall_event ?production_batch ?recall_event)
        (not
          (recall_event_requires_additional_approval ?recall_event)
        )
        (recall_event_requires_regulatory_action ?recall_event)
        (not
          (team_ready_for_operational_signoff ?crisis_coordination_team)
        )
      )
    :effect
      (and
        (team_ready_for_operational_signoff ?crisis_coordination_team)
        (logistics_ready ?crisis_coordination_team)
      )
  )
  (:action complete_contract_laboratory_testing_and_prepare_signoff_full
    :parameters (?crisis_coordination_team - crisis_coordination_team ?contract_laboratory - contract_laboratory ?production_batch - production_batch ?recall_event - recall_event)
    :precondition
      (and
        (team_quality_checks_completed ?crisis_coordination_team)
        (team_allocated_contract_laboratory ?crisis_coordination_team ?contract_laboratory)
        (team_assigned_to_batch ?crisis_coordination_team ?production_batch)
        (batch_linked_to_recall_event ?production_batch ?recall_event)
        (recall_event_requires_additional_approval ?recall_event)
        (recall_event_requires_regulatory_action ?recall_event)
        (not
          (team_ready_for_operational_signoff ?crisis_coordination_team)
        )
      )
    :effect
      (and
        (team_ready_for_operational_signoff ?crisis_coordination_team)
        (logistics_ready ?crisis_coordination_team)
      )
  )
  (:action finalize_team_recovery_signoff
    :parameters (?crisis_coordination_team - crisis_coordination_team)
    :precondition
      (and
        (team_ready_for_operational_signoff ?crisis_coordination_team)
        (not
          (logistics_ready ?crisis_coordination_team)
        )
        (not
          (recovery_signoff_recorded ?crisis_coordination_team)
        )
      )
    :effect
      (and
        (recovery_signoff_recorded ?crisis_coordination_team)
        (operational_signoff_for_entity ?crisis_coordination_team)
      )
  )
  (:action attach_logistics_resource_to_team
    :parameters (?crisis_coordination_team - crisis_coordination_team ?logistics_resource - logistics_resource)
    :precondition
      (and
        (team_ready_for_operational_signoff ?crisis_coordination_team)
        (logistics_ready ?crisis_coordination_team)
        (logistics_resource_available ?logistics_resource)
      )
    :effect
      (and
        (team_allocated_logistics_resource ?crisis_coordination_team ?logistics_resource)
        (not
          (logistics_resource_available ?logistics_resource)
        )
      )
  )
  (:action perform_operational_signoff_and_allocate_resources
    :parameters (?crisis_coordination_team - crisis_coordination_team ?manufacturing_site - manufacturing_site ?distribution_site - distribution_site ?laboratory_sample - laboratory_sample ?logistics_resource - logistics_resource)
    :precondition
      (and
        (team_ready_for_operational_signoff ?crisis_coordination_team)
        (logistics_ready ?crisis_coordination_team)
        (team_allocated_logistics_resource ?crisis_coordination_team ?logistics_resource)
        (team_assigned_to_manufacturing_site ?crisis_coordination_team ?manufacturing_site)
        (team_assigned_to_distribution_site ?crisis_coordination_team ?distribution_site)
        (site_mitigation_recorded ?manufacturing_site)
        (distribution_site_mitigation_recorded ?distribution_site)
        (sample_linked_to_entity ?crisis_coordination_team ?laboratory_sample)
        (not
          (crossfunctional_checklist_completed ?crisis_coordination_team)
        )
      )
    :effect (crossfunctional_checklist_completed ?crisis_coordination_team)
  )
  (:action publish_recovery_signoff
    :parameters (?crisis_coordination_team - crisis_coordination_team)
    :precondition
      (and
        (team_ready_for_operational_signoff ?crisis_coordination_team)
        (crossfunctional_checklist_completed ?crisis_coordination_team)
        (not
          (recovery_signoff_recorded ?crisis_coordination_team)
        )
      )
    :effect
      (and
        (recovery_signoff_recorded ?crisis_coordination_team)
        (operational_signoff_for_entity ?crisis_coordination_team)
      )
  )
  (:action assign_regulatory_notice_to_team
    :parameters (?crisis_coordination_team - crisis_coordination_team ?regulatory_notice - regulatory_notice ?laboratory_sample - laboratory_sample)
    :precondition
      (and
        (entity_confirmed ?crisis_coordination_team)
        (sample_linked_to_entity ?crisis_coordination_team ?laboratory_sample)
        (regulatory_notice_available ?regulatory_notice)
        (team_linked_regulatory_notice ?crisis_coordination_team ?regulatory_notice)
        (not
          (regulatory_notice_assigned ?crisis_coordination_team)
        )
      )
    :effect
      (and
        (regulatory_notice_assigned ?crisis_coordination_team)
        (not
          (regulatory_notice_available ?regulatory_notice)
        )
      )
  )
  (:action start_regulatory_review
    :parameters (?crisis_coordination_team - crisis_coordination_team ?containment_asset - containment_asset)
    :precondition
      (and
        (regulatory_notice_assigned ?crisis_coordination_team)
        (entity_has_containment ?crisis_coordination_team ?containment_asset)
        (not
          (regulatory_review_in_progress ?crisis_coordination_team)
        )
      )
    :effect (regulatory_review_in_progress ?crisis_coordination_team)
  )
  (:action complete_regulatory_review
    :parameters (?crisis_coordination_team - crisis_coordination_team ?contract_laboratory - contract_laboratory)
    :precondition
      (and
        (regulatory_review_in_progress ?crisis_coordination_team)
        (team_allocated_contract_laboratory ?crisis_coordination_team ?contract_laboratory)
        (not
          (regulatory_review_completed ?crisis_coordination_team)
        )
      )
    :effect (regulatory_review_completed ?crisis_coordination_team)
  )
  (:action finalize_regulatory_signoff
    :parameters (?crisis_coordination_team - crisis_coordination_team)
    :precondition
      (and
        (regulatory_review_completed ?crisis_coordination_team)
        (not
          (recovery_signoff_recorded ?crisis_coordination_team)
        )
      )
    :effect
      (and
        (recovery_signoff_recorded ?crisis_coordination_team)
        (operational_signoff_for_entity ?crisis_coordination_team)
      )
  )
  (:action authorize_site_return_to_operation
    :parameters (?manufacturing_site - manufacturing_site ?recall_event - recall_event)
    :precondition
      (and
        (manufacturing_site_stabilized ?manufacturing_site)
        (site_mitigation_recorded ?manufacturing_site)
        (recall_event_staged ?recall_event)
        (recall_event_processed ?recall_event)
        (not
          (operational_signoff_for_entity ?manufacturing_site)
        )
      )
    :effect (operational_signoff_for_entity ?manufacturing_site)
  )
  (:action authorize_distribution_site_return_to_operation
    :parameters (?distribution_site - distribution_site ?recall_event - recall_event)
    :precondition
      (and
        (distribution_site_stabilized ?distribution_site)
        (distribution_site_mitigation_recorded ?distribution_site)
        (recall_event_staged ?recall_event)
        (recall_event_processed ?recall_event)
        (not
          (operational_signoff_for_entity ?distribution_site)
        )
      )
    :effect (operational_signoff_for_entity ?distribution_site)
  )
  (:action dispatch_incident_communications
    :parameters (?safety_incident - safety_incident ?communication_template - communication_template ?laboratory_sample - laboratory_sample)
    :precondition
      (and
        (operational_signoff_for_entity ?safety_incident)
        (sample_linked_to_entity ?safety_incident ?laboratory_sample)
        (communication_template_available ?communication_template)
        (not
          (communications_sent_for_entity ?safety_incident)
        )
      )
    :effect
      (and
        (communications_sent_for_entity ?safety_incident)
        (entity_communication_template_assigned ?safety_incident ?communication_template)
        (not
          (communication_template_available ?communication_template)
        )
      )
  )
  (:action complete_site_recovery_and_release_role
    :parameters (?manufacturing_site - manufacturing_site ?response_role - response_role ?communication_template - communication_template)
    :precondition
      (and
        (communications_sent_for_entity ?manufacturing_site)
        (entity_assigned_role ?manufacturing_site ?response_role)
        (entity_communication_template_assigned ?manufacturing_site ?communication_template)
        (not
          (entity_return_to_operation ?manufacturing_site)
        )
      )
    :effect
      (and
        (entity_return_to_operation ?manufacturing_site)
        (role_available ?response_role)
        (communication_template_available ?communication_template)
      )
  )
  (:action complete_distribution_recovery_and_release_role
    :parameters (?distribution_site - distribution_site ?response_role - response_role ?communication_template - communication_template)
    :precondition
      (and
        (communications_sent_for_entity ?distribution_site)
        (entity_assigned_role ?distribution_site ?response_role)
        (entity_communication_template_assigned ?distribution_site ?communication_template)
        (not
          (entity_return_to_operation ?distribution_site)
        )
      )
    :effect
      (and
        (entity_return_to_operation ?distribution_site)
        (role_available ?response_role)
        (communication_template_available ?communication_template)
      )
  )
  (:action complete_team_recovery_and_release_role
    :parameters (?crisis_coordination_team - crisis_coordination_team ?response_role - response_role ?communication_template - communication_template)
    :precondition
      (and
        (communications_sent_for_entity ?crisis_coordination_team)
        (entity_assigned_role ?crisis_coordination_team ?response_role)
        (entity_communication_template_assigned ?crisis_coordination_team ?communication_template)
        (not
          (entity_return_to_operation ?crisis_coordination_team)
        )
      )
    :effect
      (and
        (entity_return_to_operation ?crisis_coordination_team)
        (role_available ?response_role)
        (communication_template_available ?communication_template)
      )
  )
)

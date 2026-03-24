(define (domain party_composition_selection_for_mission_type)
  (:requirements :strips :typing :negative-preconditions)
  (:types base_object - object role_family - base_object ability_family - base_object asset_family - base_object unit_base_type - base_object unit_candidate - unit_base_type role_token - role_family class_archetype - role_family equipment_bundle - role_family party_marker - role_family synergy_token - role_family deployment_resource - role_family equipment_module - role_family signature_tactic - role_family consumable_resource - ability_family tactic_card - ability_family persona_badge - ability_family encounter_node_a - asset_family encounter_node_b - asset_family assignment_token - asset_family subgroup_slot - unit_candidate party_template - unit_candidate frontline_unit - subgroup_slot ranged_unit - subgroup_slot mission_party - party_template)

  (:predicates
    (candidate_selected ?unit_candidate - unit_candidate)
    (entity_confirmed ?unit_candidate - unit_candidate)
    (role_assigned ?unit_candidate - unit_candidate)
    (deployed ?unit_candidate - unit_candidate)
    (entity_ready_for_deployment ?unit_candidate - unit_candidate)
    (entity_prepared_for_deployment ?unit_candidate - unit_candidate)
    (role_token_available ?role_token - role_token)
    (entity_role_binding ?unit_candidate - unit_candidate ?role_token - role_token)
    (archetype_available ?class_archetype - class_archetype)
    (entity_archetype_binding ?unit_candidate - unit_candidate ?class_archetype - class_archetype)
    (equipment_bundle_available ?equipment_bundle - equipment_bundle)
    (entity_equipment_binding ?unit_candidate - unit_candidate ?equipment_bundle - equipment_bundle)
    (consumable_available ?consumable_resource - consumable_resource)
    (frontline_resource_binding ?frontline_unit - frontline_unit ?consumable_resource - consumable_resource)
    (ranged_resource_binding ?ranged_unit - ranged_unit ?consumable_resource - consumable_resource)
    (frontline_node_link ?frontline_unit - frontline_unit ?encounter_node_a - encounter_node_a)
    (encounter_node_a_claimed ?encounter_node_a - encounter_node_a)
    (encounter_node_a_reserved ?encounter_node_a - encounter_node_a)
    (frontline_contribution_confirmed ?frontline_unit - frontline_unit)
    (ranged_node_link ?ranged_unit - ranged_unit ?encounter_node_b - encounter_node_b)
    (encounter_node_b_claimed ?encounter_node_b - encounter_node_b)
    (encounter_node_b_reserved ?encounter_node_b - encounter_node_b)
    (ranged_contribution_confirmed ?ranged_unit - ranged_unit)
    (assignment_token_available ?assignment_token - assignment_token)
    (assignment_token_assembled ?assignment_token - assignment_token)
    (assignment_token_node_a_link ?assignment_token - assignment_token ?encounter_node_a - encounter_node_a)
    (assignment_token_node_b_link ?assignment_token - assignment_token ?encounter_node_b - encounter_node_b)
    (assignment_token_frontline_resource_flag ?assignment_token - assignment_token)
    (assignment_token_ranged_resource_flag ?assignment_token - assignment_token)
    (assignment_token_validated ?assignment_token - assignment_token)
    (party_has_frontline_slot ?mission_party - mission_party ?frontline_unit - frontline_unit)
    (party_has_ranged_slot ?mission_party - mission_party ?ranged_unit - ranged_unit)
    (party_assignment_link ?mission_party - mission_party ?assignment_token - assignment_token)
    (tactic_card_available ?tactic_card - tactic_card)
    (party_has_tactic_card ?mission_party - mission_party ?tactic_card - tactic_card)
    (tactic_card_used ?tactic_card - tactic_card)
    (tactic_card_bound_to_assignment ?tactic_card - tactic_card ?assignment_token - assignment_token)
    (party_module_authorized ?mission_party - mission_party)
    (party_module_staged ?mission_party - mission_party)
    (party_signature_active ?mission_party - mission_party)
    (party_marker_applied ?mission_party - mission_party)
    (party_marker_authorized ?mission_party - mission_party)
    (party_signature_synergy_ready ?mission_party - mission_party)
    (party_asset_checks_passed ?mission_party - mission_party)
    (persona_badge_available ?persona_badge - persona_badge)
    (party_persona_binding ?mission_party - mission_party ?persona_badge - persona_badge)
    (party_persona_active ?mission_party - mission_party)
    (party_persona_stage1 ?mission_party - mission_party)
    (party_persona_stage2 ?mission_party - mission_party)
    (party_marker_available ?party_marker - party_marker)
    (party_marker_binding ?mission_party - mission_party ?party_marker - party_marker)
    (synergy_token_available ?synergy_token - synergy_token)
    (party_synergy_binding ?mission_party - mission_party ?synergy_token - synergy_token)
    (equipment_module_available ?equipment_module - equipment_module)
    (party_equipment_module_binding ?mission_party - mission_party ?equipment_module - equipment_module)
    (signature_tactic_available ?signature_tactic - signature_tactic)
    (party_signature_binding ?mission_party - mission_party ?signature_tactic - signature_tactic)
    (deployment_resource_available ?deployment_resource - deployment_resource)
    (entity_deployment_resource_binding ?unit_candidate - unit_candidate ?deployment_resource - deployment_resource)
    (frontline_ready ?frontline_unit - frontline_unit)
    (ranged_ready ?ranged_unit - ranged_unit)
    (final_checks_passed ?mission_party - mission_party)
  )
  (:action select_unit_candidate
    :parameters (?unit_candidate - unit_candidate)
    :precondition
      (and
        (not
          (candidate_selected ?unit_candidate)
        )
        (not
          (deployed ?unit_candidate)
        )
      )
    :effect (candidate_selected ?unit_candidate)
  )
  (:action assign_role_to_unit
    :parameters (?unit_candidate - unit_candidate ?role_token - role_token)
    :precondition
      (and
        (candidate_selected ?unit_candidate)
        (not
          (role_assigned ?unit_candidate)
        )
        (role_token_available ?role_token)
      )
    :effect
      (and
        (role_assigned ?unit_candidate)
        (entity_role_binding ?unit_candidate ?role_token)
        (not
          (role_token_available ?role_token)
        )
      )
  )
  (:action assign_archetype_to_unit
    :parameters (?unit_candidate - unit_candidate ?class_archetype - class_archetype)
    :precondition
      (and
        (candidate_selected ?unit_candidate)
        (role_assigned ?unit_candidate)
        (archetype_available ?class_archetype)
      )
    :effect
      (and
        (entity_archetype_binding ?unit_candidate ?class_archetype)
        (not
          (archetype_available ?class_archetype)
        )
      )
  )
  (:action confirm_unit_selection
    :parameters (?unit_candidate - unit_candidate ?class_archetype - class_archetype)
    :precondition
      (and
        (candidate_selected ?unit_candidate)
        (role_assigned ?unit_candidate)
        (entity_archetype_binding ?unit_candidate ?class_archetype)
        (not
          (entity_confirmed ?unit_candidate)
        )
      )
    :effect (entity_confirmed ?unit_candidate)
  )
  (:action release_archetype_from_unit
    :parameters (?unit_candidate - unit_candidate ?class_archetype - class_archetype)
    :precondition
      (and
        (entity_archetype_binding ?unit_candidate ?class_archetype)
      )
    :effect
      (and
        (archetype_available ?class_archetype)
        (not
          (entity_archetype_binding ?unit_candidate ?class_archetype)
        )
      )
  )
  (:action assign_equipment_bundle_to_unit
    :parameters (?unit_candidate - unit_candidate ?equipment_bundle - equipment_bundle)
    :precondition
      (and
        (entity_confirmed ?unit_candidate)
        (equipment_bundle_available ?equipment_bundle)
      )
    :effect
      (and
        (entity_equipment_binding ?unit_candidate ?equipment_bundle)
        (not
          (equipment_bundle_available ?equipment_bundle)
        )
      )
  )
  (:action remove_equipment_bundle_from_unit
    :parameters (?unit_candidate - unit_candidate ?equipment_bundle - equipment_bundle)
    :precondition
      (and
        (entity_equipment_binding ?unit_candidate ?equipment_bundle)
      )
    :effect
      (and
        (equipment_bundle_available ?equipment_bundle)
        (not
          (entity_equipment_binding ?unit_candidate ?equipment_bundle)
        )
      )
  )
  (:action assign_equipment_module_to_party
    :parameters (?mission_party - mission_party ?equipment_module - equipment_module)
    :precondition
      (and
        (entity_confirmed ?mission_party)
        (equipment_module_available ?equipment_module)
      )
    :effect
      (and
        (party_equipment_module_binding ?mission_party ?equipment_module)
        (not
          (equipment_module_available ?equipment_module)
        )
      )
  )
  (:action remove_equipment_module_from_party
    :parameters (?mission_party - mission_party ?equipment_module - equipment_module)
    :precondition
      (and
        (party_equipment_module_binding ?mission_party ?equipment_module)
      )
    :effect
      (and
        (equipment_module_available ?equipment_module)
        (not
          (party_equipment_module_binding ?mission_party ?equipment_module)
        )
      )
  )
  (:action assign_signature_tactic_to_party
    :parameters (?mission_party - mission_party ?signature_tactic - signature_tactic)
    :precondition
      (and
        (entity_confirmed ?mission_party)
        (signature_tactic_available ?signature_tactic)
      )
    :effect
      (and
        (party_signature_binding ?mission_party ?signature_tactic)
        (not
          (signature_tactic_available ?signature_tactic)
        )
      )
  )
  (:action remove_signature_tactic_from_party
    :parameters (?mission_party - mission_party ?signature_tactic - signature_tactic)
    :precondition
      (and
        (party_signature_binding ?mission_party ?signature_tactic)
      )
    :effect
      (and
        (signature_tactic_available ?signature_tactic)
        (not
          (party_signature_binding ?mission_party ?signature_tactic)
        )
      )
  )
  (:action reserve_encounter_node_a_with_frontline
    :parameters (?frontline_unit - frontline_unit ?encounter_node_a - encounter_node_a ?class_archetype - class_archetype)
    :precondition
      (and
        (entity_confirmed ?frontline_unit)
        (entity_archetype_binding ?frontline_unit ?class_archetype)
        (frontline_node_link ?frontline_unit ?encounter_node_a)
        (not
          (encounter_node_a_claimed ?encounter_node_a)
        )
        (not
          (encounter_node_a_reserved ?encounter_node_a)
        )
      )
    :effect (encounter_node_a_claimed ?encounter_node_a)
  )
  (:action confirm_frontline_preparation_with_equipment
    :parameters (?frontline_unit - frontline_unit ?encounter_node_a - encounter_node_a ?equipment_bundle - equipment_bundle)
    :precondition
      (and
        (entity_confirmed ?frontline_unit)
        (entity_equipment_binding ?frontline_unit ?equipment_bundle)
        (frontline_node_link ?frontline_unit ?encounter_node_a)
        (encounter_node_a_claimed ?encounter_node_a)
        (not
          (frontline_ready ?frontline_unit)
        )
      )
    :effect
      (and
        (frontline_ready ?frontline_unit)
        (frontline_contribution_confirmed ?frontline_unit)
      )
  )
  (:action reserve_encounter_node_a_with_resource
    :parameters (?frontline_unit - frontline_unit ?encounter_node_a - encounter_node_a ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_confirmed ?frontline_unit)
        (frontline_node_link ?frontline_unit ?encounter_node_a)
        (consumable_available ?consumable_resource)
        (not
          (frontline_ready ?frontline_unit)
        )
      )
    :effect
      (and
        (encounter_node_a_reserved ?encounter_node_a)
        (frontline_ready ?frontline_unit)
        (frontline_resource_binding ?frontline_unit ?consumable_resource)
        (not
          (consumable_available ?consumable_resource)
        )
      )
  )
  (:action convert_resource_reservation_to_frontline_claim
    :parameters (?frontline_unit - frontline_unit ?encounter_node_a - encounter_node_a ?class_archetype - class_archetype ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_confirmed ?frontline_unit)
        (entity_archetype_binding ?frontline_unit ?class_archetype)
        (frontline_node_link ?frontline_unit ?encounter_node_a)
        (encounter_node_a_reserved ?encounter_node_a)
        (frontline_resource_binding ?frontline_unit ?consumable_resource)
        (not
          (frontline_contribution_confirmed ?frontline_unit)
        )
      )
    :effect
      (and
        (encounter_node_a_claimed ?encounter_node_a)
        (frontline_contribution_confirmed ?frontline_unit)
        (consumable_available ?consumable_resource)
        (not
          (frontline_resource_binding ?frontline_unit ?consumable_resource)
        )
      )
  )
  (:action reserve_encounter_node_b_with_ranged
    :parameters (?ranged_unit - ranged_unit ?encounter_node_b - encounter_node_b ?class_archetype - class_archetype)
    :precondition
      (and
        (entity_confirmed ?ranged_unit)
        (entity_archetype_binding ?ranged_unit ?class_archetype)
        (ranged_node_link ?ranged_unit ?encounter_node_b)
        (not
          (encounter_node_b_claimed ?encounter_node_b)
        )
        (not
          (encounter_node_b_reserved ?encounter_node_b)
        )
      )
    :effect (encounter_node_b_claimed ?encounter_node_b)
  )
  (:action confirm_ranged_preparation_with_equipment
    :parameters (?ranged_unit - ranged_unit ?encounter_node_b - encounter_node_b ?equipment_bundle - equipment_bundle)
    :precondition
      (and
        (entity_confirmed ?ranged_unit)
        (entity_equipment_binding ?ranged_unit ?equipment_bundle)
        (ranged_node_link ?ranged_unit ?encounter_node_b)
        (encounter_node_b_claimed ?encounter_node_b)
        (not
          (ranged_ready ?ranged_unit)
        )
      )
    :effect
      (and
        (ranged_ready ?ranged_unit)
        (ranged_contribution_confirmed ?ranged_unit)
      )
  )
  (:action reserve_encounter_node_b_with_resource
    :parameters (?ranged_unit - ranged_unit ?encounter_node_b - encounter_node_b ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_confirmed ?ranged_unit)
        (ranged_node_link ?ranged_unit ?encounter_node_b)
        (consumable_available ?consumable_resource)
        (not
          (ranged_ready ?ranged_unit)
        )
      )
    :effect
      (and
        (encounter_node_b_reserved ?encounter_node_b)
        (ranged_ready ?ranged_unit)
        (ranged_resource_binding ?ranged_unit ?consumable_resource)
        (not
          (consumable_available ?consumable_resource)
        )
      )
  )
  (:action convert_resource_reservation_to_ranged_claim
    :parameters (?ranged_unit - ranged_unit ?encounter_node_b - encounter_node_b ?class_archetype - class_archetype ?consumable_resource - consumable_resource)
    :precondition
      (and
        (entity_confirmed ?ranged_unit)
        (entity_archetype_binding ?ranged_unit ?class_archetype)
        (ranged_node_link ?ranged_unit ?encounter_node_b)
        (encounter_node_b_reserved ?encounter_node_b)
        (ranged_resource_binding ?ranged_unit ?consumable_resource)
        (not
          (ranged_contribution_confirmed ?ranged_unit)
        )
      )
    :effect
      (and
        (encounter_node_b_claimed ?encounter_node_b)
        (ranged_contribution_confirmed ?ranged_unit)
        (consumable_available ?consumable_resource)
        (not
          (ranged_resource_binding ?ranged_unit ?consumable_resource)
        )
      )
  )
  (:action create_assignment_token_from_contributions
    :parameters (?frontline_unit - frontline_unit ?ranged_unit - ranged_unit ?encounter_node_a - encounter_node_a ?encounter_node_b - encounter_node_b ?assignment_token - assignment_token)
    :precondition
      (and
        (frontline_ready ?frontline_unit)
        (ranged_ready ?ranged_unit)
        (frontline_node_link ?frontline_unit ?encounter_node_a)
        (ranged_node_link ?ranged_unit ?encounter_node_b)
        (encounter_node_a_claimed ?encounter_node_a)
        (encounter_node_b_claimed ?encounter_node_b)
        (frontline_contribution_confirmed ?frontline_unit)
        (ranged_contribution_confirmed ?ranged_unit)
        (assignment_token_available ?assignment_token)
      )
    :effect
      (and
        (assignment_token_assembled ?assignment_token)
        (assignment_token_node_a_link ?assignment_token ?encounter_node_a)
        (assignment_token_node_b_link ?assignment_token ?encounter_node_b)
        (not
          (assignment_token_available ?assignment_token)
        )
      )
  )
  (:action create_assignment_token_with_frontline_resource
    :parameters (?frontline_unit - frontline_unit ?ranged_unit - ranged_unit ?encounter_node_a - encounter_node_a ?encounter_node_b - encounter_node_b ?assignment_token - assignment_token)
    :precondition
      (and
        (frontline_ready ?frontline_unit)
        (ranged_ready ?ranged_unit)
        (frontline_node_link ?frontline_unit ?encounter_node_a)
        (ranged_node_link ?ranged_unit ?encounter_node_b)
        (encounter_node_a_reserved ?encounter_node_a)
        (encounter_node_b_claimed ?encounter_node_b)
        (not
          (frontline_contribution_confirmed ?frontline_unit)
        )
        (ranged_contribution_confirmed ?ranged_unit)
        (assignment_token_available ?assignment_token)
      )
    :effect
      (and
        (assignment_token_assembled ?assignment_token)
        (assignment_token_node_a_link ?assignment_token ?encounter_node_a)
        (assignment_token_node_b_link ?assignment_token ?encounter_node_b)
        (assignment_token_frontline_resource_flag ?assignment_token)
        (not
          (assignment_token_available ?assignment_token)
        )
      )
  )
  (:action create_assignment_token_with_ranged_resource
    :parameters (?frontline_unit - frontline_unit ?ranged_unit - ranged_unit ?encounter_node_a - encounter_node_a ?encounter_node_b - encounter_node_b ?assignment_token - assignment_token)
    :precondition
      (and
        (frontline_ready ?frontline_unit)
        (ranged_ready ?ranged_unit)
        (frontline_node_link ?frontline_unit ?encounter_node_a)
        (ranged_node_link ?ranged_unit ?encounter_node_b)
        (encounter_node_a_claimed ?encounter_node_a)
        (encounter_node_b_reserved ?encounter_node_b)
        (frontline_contribution_confirmed ?frontline_unit)
        (not
          (ranged_contribution_confirmed ?ranged_unit)
        )
        (assignment_token_available ?assignment_token)
      )
    :effect
      (and
        (assignment_token_assembled ?assignment_token)
        (assignment_token_node_a_link ?assignment_token ?encounter_node_a)
        (assignment_token_node_b_link ?assignment_token ?encounter_node_b)
        (assignment_token_ranged_resource_flag ?assignment_token)
        (not
          (assignment_token_available ?assignment_token)
        )
      )
  )
  (:action create_assignment_token_with_both_resources
    :parameters (?frontline_unit - frontline_unit ?ranged_unit - ranged_unit ?encounter_node_a - encounter_node_a ?encounter_node_b - encounter_node_b ?assignment_token - assignment_token)
    :precondition
      (and
        (frontline_ready ?frontline_unit)
        (ranged_ready ?ranged_unit)
        (frontline_node_link ?frontline_unit ?encounter_node_a)
        (ranged_node_link ?ranged_unit ?encounter_node_b)
        (encounter_node_a_reserved ?encounter_node_a)
        (encounter_node_b_reserved ?encounter_node_b)
        (not
          (frontline_contribution_confirmed ?frontline_unit)
        )
        (not
          (ranged_contribution_confirmed ?ranged_unit)
        )
        (assignment_token_available ?assignment_token)
      )
    :effect
      (and
        (assignment_token_assembled ?assignment_token)
        (assignment_token_node_a_link ?assignment_token ?encounter_node_a)
        (assignment_token_node_b_link ?assignment_token ?encounter_node_b)
        (assignment_token_frontline_resource_flag ?assignment_token)
        (assignment_token_ranged_resource_flag ?assignment_token)
        (not
          (assignment_token_available ?assignment_token)
        )
      )
  )
  (:action activate_assignment_token
    :parameters (?assignment_token - assignment_token ?frontline_unit - frontline_unit ?class_archetype - class_archetype)
    :precondition
      (and
        (assignment_token_assembled ?assignment_token)
        (frontline_ready ?frontline_unit)
        (entity_archetype_binding ?frontline_unit ?class_archetype)
        (not
          (assignment_token_validated ?assignment_token)
        )
      )
    :effect (assignment_token_validated ?assignment_token)
  )
  (:action bind_tactic_card_to_assignment_token
    :parameters (?mission_party - mission_party ?tactic_card - tactic_card ?assignment_token - assignment_token)
    :precondition
      (and
        (entity_confirmed ?mission_party)
        (party_assignment_link ?mission_party ?assignment_token)
        (party_has_tactic_card ?mission_party ?tactic_card)
        (tactic_card_available ?tactic_card)
        (assignment_token_assembled ?assignment_token)
        (assignment_token_validated ?assignment_token)
        (not
          (tactic_card_used ?tactic_card)
        )
      )
    :effect
      (and
        (tactic_card_used ?tactic_card)
        (tactic_card_bound_to_assignment ?tactic_card ?assignment_token)
        (not
          (tactic_card_available ?tactic_card)
        )
      )
  )
  (:action authorize_party_for_module_assignment
    :parameters (?mission_party - mission_party ?tactic_card - tactic_card ?assignment_token - assignment_token ?class_archetype - class_archetype)
    :precondition
      (and
        (entity_confirmed ?mission_party)
        (party_has_tactic_card ?mission_party ?tactic_card)
        (tactic_card_used ?tactic_card)
        (tactic_card_bound_to_assignment ?tactic_card ?assignment_token)
        (entity_archetype_binding ?mission_party ?class_archetype)
        (not
          (assignment_token_frontline_resource_flag ?assignment_token)
        )
        (not
          (party_module_authorized ?mission_party)
        )
      )
    :effect (party_module_authorized ?mission_party)
  )
  (:action apply_party_marker
    :parameters (?mission_party - mission_party ?party_marker - party_marker)
    :precondition
      (and
        (entity_confirmed ?mission_party)
        (party_marker_available ?party_marker)
        (not
          (party_marker_applied ?mission_party)
        )
      )
    :effect
      (and
        (party_marker_applied ?mission_party)
        (party_marker_binding ?mission_party ?party_marker)
        (not
          (party_marker_available ?party_marker)
        )
      )
  )
  (:action apply_marker_and_authorize_party
    :parameters (?mission_party - mission_party ?tactic_card - tactic_card ?assignment_token - assignment_token ?class_archetype - class_archetype ?party_marker - party_marker)
    :precondition
      (and
        (entity_confirmed ?mission_party)
        (party_has_tactic_card ?mission_party ?tactic_card)
        (tactic_card_used ?tactic_card)
        (tactic_card_bound_to_assignment ?tactic_card ?assignment_token)
        (entity_archetype_binding ?mission_party ?class_archetype)
        (assignment_token_frontline_resource_flag ?assignment_token)
        (party_marker_applied ?mission_party)
        (party_marker_binding ?mission_party ?party_marker)
        (not
          (party_module_authorized ?mission_party)
        )
      )
    :effect
      (and
        (party_module_authorized ?mission_party)
        (party_marker_authorized ?mission_party)
      )
  )
  (:action stage_party_for_module_application
    :parameters (?mission_party - mission_party ?equipment_module - equipment_module ?equipment_bundle - equipment_bundle ?tactic_card - tactic_card ?assignment_token - assignment_token)
    :precondition
      (and
        (party_module_authorized ?mission_party)
        (party_equipment_module_binding ?mission_party ?equipment_module)
        (entity_equipment_binding ?mission_party ?equipment_bundle)
        (party_has_tactic_card ?mission_party ?tactic_card)
        (tactic_card_bound_to_assignment ?tactic_card ?assignment_token)
        (not
          (assignment_token_ranged_resource_flag ?assignment_token)
        )
        (not
          (party_module_staged ?mission_party)
        )
      )
    :effect (party_module_staged ?mission_party)
  )
  (:action complete_module_application_staging
    :parameters (?mission_party - mission_party ?equipment_module - equipment_module ?equipment_bundle - equipment_bundle ?tactic_card - tactic_card ?assignment_token - assignment_token)
    :precondition
      (and
        (party_module_authorized ?mission_party)
        (party_equipment_module_binding ?mission_party ?equipment_module)
        (entity_equipment_binding ?mission_party ?equipment_bundle)
        (party_has_tactic_card ?mission_party ?tactic_card)
        (tactic_card_bound_to_assignment ?tactic_card ?assignment_token)
        (assignment_token_ranged_resource_flag ?assignment_token)
        (not
          (party_module_staged ?mission_party)
        )
      )
    :effect (party_module_staged ?mission_party)
  )
  (:action enable_party_signature_tactic
    :parameters (?mission_party - mission_party ?signature_tactic - signature_tactic ?tactic_card - tactic_card ?assignment_token - assignment_token)
    :precondition
      (and
        (party_module_staged ?mission_party)
        (party_signature_binding ?mission_party ?signature_tactic)
        (party_has_tactic_card ?mission_party ?tactic_card)
        (tactic_card_bound_to_assignment ?tactic_card ?assignment_token)
        (not
          (assignment_token_frontline_resource_flag ?assignment_token)
        )
        (not
          (assignment_token_ranged_resource_flag ?assignment_token)
        )
        (not
          (party_signature_active ?mission_party)
        )
      )
    :effect (party_signature_active ?mission_party)
  )
  (:action confirm_signature_and_prepare_synergy
    :parameters (?mission_party - mission_party ?signature_tactic - signature_tactic ?tactic_card - tactic_card ?assignment_token - assignment_token)
    :precondition
      (and
        (party_module_staged ?mission_party)
        (party_signature_binding ?mission_party ?signature_tactic)
        (party_has_tactic_card ?mission_party ?tactic_card)
        (tactic_card_bound_to_assignment ?tactic_card ?assignment_token)
        (assignment_token_frontline_resource_flag ?assignment_token)
        (not
          (assignment_token_ranged_resource_flag ?assignment_token)
        )
        (not
          (party_signature_active ?mission_party)
        )
      )
    :effect
      (and
        (party_signature_active ?mission_party)
        (party_signature_synergy_ready ?mission_party)
      )
  )
  (:action confirm_signature_and_prepare_synergy_variant
    :parameters (?mission_party - mission_party ?signature_tactic - signature_tactic ?tactic_card - tactic_card ?assignment_token - assignment_token)
    :precondition
      (and
        (party_module_staged ?mission_party)
        (party_signature_binding ?mission_party ?signature_tactic)
        (party_has_tactic_card ?mission_party ?tactic_card)
        (tactic_card_bound_to_assignment ?tactic_card ?assignment_token)
        (not
          (assignment_token_frontline_resource_flag ?assignment_token)
        )
        (assignment_token_ranged_resource_flag ?assignment_token)
        (not
          (party_signature_active ?mission_party)
        )
      )
    :effect
      (and
        (party_signature_active ?mission_party)
        (party_signature_synergy_ready ?mission_party)
      )
  )
  (:action confirm_signature_and_prepare_synergy_full
    :parameters (?mission_party - mission_party ?signature_tactic - signature_tactic ?tactic_card - tactic_card ?assignment_token - assignment_token)
    :precondition
      (and
        (party_module_staged ?mission_party)
        (party_signature_binding ?mission_party ?signature_tactic)
        (party_has_tactic_card ?mission_party ?tactic_card)
        (tactic_card_bound_to_assignment ?tactic_card ?assignment_token)
        (assignment_token_frontline_resource_flag ?assignment_token)
        (assignment_token_ranged_resource_flag ?assignment_token)
        (not
          (party_signature_active ?mission_party)
        )
      )
    :effect
      (and
        (party_signature_active ?mission_party)
        (party_signature_synergy_ready ?mission_party)
      )
  )
  (:action finalize_party_without_synergy
    :parameters (?mission_party - mission_party)
    :precondition
      (and
        (party_signature_active ?mission_party)
        (not
          (party_signature_synergy_ready ?mission_party)
        )
        (not
          (final_checks_passed ?mission_party)
        )
      )
    :effect
      (and
        (final_checks_passed ?mission_party)
        (entity_ready_for_deployment ?mission_party)
      )
  )
  (:action apply_synergy_to_party
    :parameters (?mission_party - mission_party ?synergy_token - synergy_token)
    :precondition
      (and
        (party_signature_active ?mission_party)
        (party_signature_synergy_ready ?mission_party)
        (synergy_token_available ?synergy_token)
      )
    :effect
      (and
        (party_synergy_binding ?mission_party ?synergy_token)
        (not
          (synergy_token_available ?synergy_token)
        )
      )
  )
  (:action validate_party_assets
    :parameters (?mission_party - mission_party ?frontline_unit - frontline_unit ?ranged_unit - ranged_unit ?class_archetype - class_archetype ?synergy_token - synergy_token)
    :precondition
      (and
        (party_signature_active ?mission_party)
        (party_signature_synergy_ready ?mission_party)
        (party_synergy_binding ?mission_party ?synergy_token)
        (party_has_frontline_slot ?mission_party ?frontline_unit)
        (party_has_ranged_slot ?mission_party ?ranged_unit)
        (frontline_contribution_confirmed ?frontline_unit)
        (ranged_contribution_confirmed ?ranged_unit)
        (entity_archetype_binding ?mission_party ?class_archetype)
        (not
          (party_asset_checks_passed ?mission_party)
        )
      )
    :effect (party_asset_checks_passed ?mission_party)
  )
  (:action finalize_party_after_validation
    :parameters (?mission_party - mission_party)
    :precondition
      (and
        (party_signature_active ?mission_party)
        (party_asset_checks_passed ?mission_party)
        (not
          (final_checks_passed ?mission_party)
        )
      )
    :effect
      (and
        (final_checks_passed ?mission_party)
        (entity_ready_for_deployment ?mission_party)
      )
  )
  (:action activate_persona_for_party
    :parameters (?mission_party - mission_party ?persona_badge - persona_badge ?class_archetype - class_archetype)
    :precondition
      (and
        (entity_confirmed ?mission_party)
        (entity_archetype_binding ?mission_party ?class_archetype)
        (persona_badge_available ?persona_badge)
        (party_persona_binding ?mission_party ?persona_badge)
        (not
          (party_persona_active ?mission_party)
        )
      )
    :effect
      (and
        (party_persona_active ?mission_party)
        (not
          (persona_badge_available ?persona_badge)
        )
      )
  )
  (:action advance_persona_stage
    :parameters (?mission_party - mission_party ?equipment_bundle - equipment_bundle)
    :precondition
      (and
        (party_persona_active ?mission_party)
        (entity_equipment_binding ?mission_party ?equipment_bundle)
        (not
          (party_persona_stage1 ?mission_party)
        )
      )
    :effect (party_persona_stage1 ?mission_party)
  )
  (:action activate_persona_stage_with_signature
    :parameters (?mission_party - mission_party ?signature_tactic - signature_tactic)
    :precondition
      (and
        (party_persona_stage1 ?mission_party)
        (party_signature_binding ?mission_party ?signature_tactic)
        (not
          (party_persona_stage2 ?mission_party)
        )
      )
    :effect (party_persona_stage2 ?mission_party)
  )
  (:action finalize_party_after_persona
    :parameters (?mission_party - mission_party)
    :precondition
      (and
        (party_persona_stage2 ?mission_party)
        (not
          (final_checks_passed ?mission_party)
        )
      )
    :effect
      (and
        (final_checks_passed ?mission_party)
        (entity_ready_for_deployment ?mission_party)
      )
  )
  (:action set_frontline_unit_ready_for_deployment
    :parameters (?frontline_unit - frontline_unit ?assignment_token - assignment_token)
    :precondition
      (and
        (frontline_ready ?frontline_unit)
        (frontline_contribution_confirmed ?frontline_unit)
        (assignment_token_assembled ?assignment_token)
        (assignment_token_validated ?assignment_token)
        (not
          (entity_ready_for_deployment ?frontline_unit)
        )
      )
    :effect (entity_ready_for_deployment ?frontline_unit)
  )
  (:action set_ranged_unit_ready_for_deployment
    :parameters (?ranged_unit - ranged_unit ?assignment_token - assignment_token)
    :precondition
      (and
        (ranged_ready ?ranged_unit)
        (ranged_contribution_confirmed ?ranged_unit)
        (assignment_token_assembled ?assignment_token)
        (assignment_token_validated ?assignment_token)
        (not
          (entity_ready_for_deployment ?ranged_unit)
        )
      )
    :effect (entity_ready_for_deployment ?ranged_unit)
  )
  (:action allocate_deployment_resource_to_unit
    :parameters (?unit_candidate - unit_candidate ?deployment_resource - deployment_resource ?class_archetype - class_archetype)
    :precondition
      (and
        (entity_ready_for_deployment ?unit_candidate)
        (entity_archetype_binding ?unit_candidate ?class_archetype)
        (deployment_resource_available ?deployment_resource)
        (not
          (entity_prepared_for_deployment ?unit_candidate)
        )
      )
    :effect
      (and
        (entity_prepared_for_deployment ?unit_candidate)
        (entity_deployment_resource_binding ?unit_candidate ?deployment_resource)
        (not
          (deployment_resource_available ?deployment_resource)
        )
      )
  )
  (:action deploy_frontline_unit_and_release_resources
    :parameters (?frontline_unit - frontline_unit ?role_token - role_token ?deployment_resource - deployment_resource)
    :precondition
      (and
        (entity_prepared_for_deployment ?frontline_unit)
        (entity_role_binding ?frontline_unit ?role_token)
        (entity_deployment_resource_binding ?frontline_unit ?deployment_resource)
        (not
          (deployed ?frontline_unit)
        )
      )
    :effect
      (and
        (deployed ?frontline_unit)
        (role_token_available ?role_token)
        (deployment_resource_available ?deployment_resource)
      )
  )
  (:action deploy_ranged_unit_and_release_resources
    :parameters (?ranged_unit - ranged_unit ?role_token - role_token ?deployment_resource - deployment_resource)
    :precondition
      (and
        (entity_prepared_for_deployment ?ranged_unit)
        (entity_role_binding ?ranged_unit ?role_token)
        (entity_deployment_resource_binding ?ranged_unit ?deployment_resource)
        (not
          (deployed ?ranged_unit)
        )
      )
    :effect
      (and
        (deployed ?ranged_unit)
        (role_token_available ?role_token)
        (deployment_resource_available ?deployment_resource)
      )
  )
  (:action deploy_party_and_release_resources
    :parameters (?mission_party - mission_party ?role_token - role_token ?deployment_resource - deployment_resource)
    :precondition
      (and
        (entity_prepared_for_deployment ?mission_party)
        (entity_role_binding ?mission_party ?role_token)
        (entity_deployment_resource_binding ?mission_party ?deployment_resource)
        (not
          (deployed ?mission_party)
        )
      )
    :effect
      (and
        (deployed ?mission_party)
        (role_token_available ?role_token)
        (deployment_resource_available ?deployment_resource)
      )
  )
)

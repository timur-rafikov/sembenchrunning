(define (domain feed_supply_shortfall_emergency_response)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object component_category - object asset_category - object site_category - object site - site_category contingency_feed_source - resource_category transport_unit - resource_category response_team - resource_category special_equipment - resource_category recovery_resource - resource_category authorization_document - resource_category quality_test_kit - resource_category certification_record - resource_category supply_package - component_category ingredient_batch - component_category decision_record - component_category feed_component_a - asset_category feed_component_b - asset_category feed_lot - asset_category origin_site_type - site processing_site_type - site farm_site - origin_site_type storage_site - origin_site_type processing_facility - processing_site_type)
  (:predicates
    (incident_reported ?site - site)
    (contingency_received ?site - site)
    (contingency_allocated ?site - site)
    (supply_restored ?site - site)
    (feed_received ?site - site)
    (authorization_granted ?site - site)
    (contingency_feed_source_available ?contingency_feed_source - contingency_feed_source)
    (site_allocated_contingency_source ?site - site ?contingency_feed_source - contingency_feed_source)
    (transport_unit_available ?transport_unit - transport_unit)
    (transport_assigned_to_site ?site - site ?transport_unit - transport_unit)
    (response_team_available ?response_team - response_team)
    (team_deployed_to_site ?site - site ?response_team - response_team)
    (supply_package_available ?supply_package - supply_package)
    (farm_allocated_supply_package ?farm_site - farm_site ?supply_package - supply_package)
    (storage_allocated_supply_package ?storage_site - storage_site ?supply_package - supply_package)
    (farm_has_component_a ?farm_site - farm_site ?feed_component_a - feed_component_a)
    (feed_component_a_prepared ?feed_component_a - feed_component_a)
    (feed_component_a_packaged ?feed_component_a - feed_component_a)
    (farm_ready_for_assembly ?farm_site - farm_site)
    (storage_has_component_b ?storage_site - storage_site ?feed_component_b - feed_component_b)
    (feed_component_b_prepared ?feed_component_b - feed_component_b)
    (feed_component_b_packaged ?feed_component_b - feed_component_b)
    (storage_ready_for_assembly ?storage_site - storage_site)
    (feed_lot_pending ?feed_lot - feed_lot)
    (feed_lot_created ?feed_lot - feed_lot)
    (feed_lot_contains_component_a ?feed_lot - feed_lot ?feed_component_a - feed_component_a)
    (feed_lot_contains_component_b ?feed_lot - feed_lot ?feed_component_b - feed_component_b)
    (feed_lot_rapid ?feed_lot - feed_lot)
    (feed_lot_quality_checked ?feed_lot - feed_lot)
    (feed_lot_processed ?feed_lot - feed_lot)
    (facility_serves_farm ?processing_facility - processing_facility ?farm_site - farm_site)
    (facility_serves_storage ?processing_facility - processing_facility ?storage_site - storage_site)
    (facility_has_feed_lot ?processing_facility - processing_facility ?feed_lot - feed_lot)
    (ingredient_batch_available ?ingredient_batch - ingredient_batch)
    (facility_has_ingredient_batch ?processing_facility - processing_facility ?ingredient_batch - ingredient_batch)
    (ingredient_batch_validated ?ingredient_batch - ingredient_batch)
    (ingredient_batch_allocated_to_lot ?ingredient_batch - ingredient_batch ?feed_lot - feed_lot)
    (facility_ready_for_testing ?processing_facility - processing_facility)
    (facility_testing_completed ?processing_facility - processing_facility)
    (facility_processing_complete ?processing_facility - processing_facility)
    (facility_equipment_allocated ?processing_facility - processing_facility)
    (facility_equipment_engaged ?processing_facility - processing_facility)
    (facility_processing_finalized ?processing_facility - processing_facility)
    (facility_ready_for_distribution ?processing_facility - processing_facility)
    (decision_record_available ?decision_record - decision_record)
    (facility_linked_decision_record ?processing_facility - processing_facility ?decision_record - decision_record)
    (decision_applied_to_facility ?processing_facility - processing_facility)
    (facility_equipment_ready ?processing_facility - processing_facility)
    (facility_certification_ready ?processing_facility - processing_facility)
    (special_equipment_available ?special_equipment - special_equipment)
    (facility_allocated_special_equipment ?processing_facility - processing_facility ?special_equipment - special_equipment)
    (recovery_resource_available ?recovery_resource - recovery_resource)
    (facility_allocated_recovery_resource ?processing_facility - processing_facility ?recovery_resource - recovery_resource)
    (quality_test_kit_available ?quality_test_kit - quality_test_kit)
    (facility_allocated_test_kit ?processing_facility - processing_facility ?quality_test_kit - quality_test_kit)
    (certification_record_available ?certification_record - certification_record)
    (facility_allocated_certification_record ?processing_facility - processing_facility ?certification_record - certification_record)
    (authorization_document_available ?authorization_document - authorization_document)
    (site_linked_authorization_document ?site - site ?authorization_document - authorization_document)
    (farm_inspection_completed ?farm_site - farm_site)
    (storage_inspection_completed ?storage_site - storage_site)
    (facility_finalized ?processing_facility - processing_facility)
  )
  (:action report_feed_shortfall_incident
    :parameters (?site - site)
    :precondition
      (and
        (not
          (incident_reported ?site)
        )
        (not
          (supply_restored ?site)
        )
      )
    :effect (incident_reported ?site)
  )
  (:action allocate_contingency_feed_source_to_site
    :parameters (?site - site ?contingency_feed_source - contingency_feed_source)
    :precondition
      (and
        (incident_reported ?site)
        (not
          (contingency_allocated ?site)
        )
        (contingency_feed_source_available ?contingency_feed_source)
      )
    :effect
      (and
        (contingency_allocated ?site)
        (site_allocated_contingency_source ?site ?contingency_feed_source)
        (not
          (contingency_feed_source_available ?contingency_feed_source)
        )
      )
  )
  (:action assign_transport_unit_to_site
    :parameters (?site - site ?transport_unit - transport_unit)
    :precondition
      (and
        (incident_reported ?site)
        (contingency_allocated ?site)
        (transport_unit_available ?transport_unit)
      )
    :effect
      (and
        (transport_assigned_to_site ?site ?transport_unit)
        (not
          (transport_unit_available ?transport_unit)
        )
      )
  )
  (:action confirm_on_site_receipt
    :parameters (?site - site ?transport_unit - transport_unit)
    :precondition
      (and
        (incident_reported ?site)
        (contingency_allocated ?site)
        (transport_assigned_to_site ?site ?transport_unit)
        (not
          (contingency_received ?site)
        )
      )
    :effect (contingency_received ?site)
  )
  (:action release_transport_unit
    :parameters (?site - site ?transport_unit - transport_unit)
    :precondition
      (and
        (transport_assigned_to_site ?site ?transport_unit)
      )
    :effect
      (and
        (transport_unit_available ?transport_unit)
        (not
          (transport_assigned_to_site ?site ?transport_unit)
        )
      )
  )
  (:action deploy_response_team_to_site
    :parameters (?site - site ?response_team - response_team)
    :precondition
      (and
        (contingency_received ?site)
        (response_team_available ?response_team)
      )
    :effect
      (and
        (team_deployed_to_site ?site ?response_team)
        (not
          (response_team_available ?response_team)
        )
      )
  )
  (:action recall_response_team_from_site
    :parameters (?site - site ?response_team - response_team)
    :precondition
      (and
        (team_deployed_to_site ?site ?response_team)
      )
    :effect
      (and
        (response_team_available ?response_team)
        (not
          (team_deployed_to_site ?site ?response_team)
        )
      )
  )
  (:action assign_quality_test_kit_to_facility
    :parameters (?processing_facility - processing_facility ?quality_test_kit - quality_test_kit)
    :precondition
      (and
        (contingency_received ?processing_facility)
        (quality_test_kit_available ?quality_test_kit)
      )
    :effect
      (and
        (facility_allocated_test_kit ?processing_facility ?quality_test_kit)
        (not
          (quality_test_kit_available ?quality_test_kit)
        )
      )
  )
  (:action release_quality_test_kit_from_facility
    :parameters (?processing_facility - processing_facility ?quality_test_kit - quality_test_kit)
    :precondition
      (and
        (facility_allocated_test_kit ?processing_facility ?quality_test_kit)
      )
    :effect
      (and
        (quality_test_kit_available ?quality_test_kit)
        (not
          (facility_allocated_test_kit ?processing_facility ?quality_test_kit)
        )
      )
  )
  (:action assign_certification_record_to_facility
    :parameters (?processing_facility - processing_facility ?certification_record - certification_record)
    :precondition
      (and
        (contingency_received ?processing_facility)
        (certification_record_available ?certification_record)
      )
    :effect
      (and
        (facility_allocated_certification_record ?processing_facility ?certification_record)
        (not
          (certification_record_available ?certification_record)
        )
      )
  )
  (:action release_certification_record_from_facility
    :parameters (?processing_facility - processing_facility ?certification_record - certification_record)
    :precondition
      (and
        (facility_allocated_certification_record ?processing_facility ?certification_record)
      )
    :effect
      (and
        (certification_record_available ?certification_record)
        (not
          (facility_allocated_certification_record ?processing_facility ?certification_record)
        )
      )
  )
  (:action prepare_feed_component_a_for_farm
    :parameters (?farm_site - farm_site ?feed_component_a - feed_component_a ?transport_unit - transport_unit)
    :precondition
      (and
        (contingency_received ?farm_site)
        (transport_assigned_to_site ?farm_site ?transport_unit)
        (farm_has_component_a ?farm_site ?feed_component_a)
        (not
          (feed_component_a_prepared ?feed_component_a)
        )
        (not
          (feed_component_a_packaged ?feed_component_a)
        )
      )
    :effect (feed_component_a_prepared ?feed_component_a)
  )
  (:action perform_farm_inspection_and_mark_ready
    :parameters (?farm_site - farm_site ?feed_component_a - feed_component_a ?response_team - response_team)
    :precondition
      (and
        (contingency_received ?farm_site)
        (team_deployed_to_site ?farm_site ?response_team)
        (farm_has_component_a ?farm_site ?feed_component_a)
        (feed_component_a_prepared ?feed_component_a)
        (not
          (farm_inspection_completed ?farm_site)
        )
      )
    :effect
      (and
        (farm_inspection_completed ?farm_site)
        (farm_ready_for_assembly ?farm_site)
      )
  )
  (:action allocate_supply_package_to_farm
    :parameters (?farm_site - farm_site ?feed_component_a - feed_component_a ?supply_package - supply_package)
    :precondition
      (and
        (contingency_received ?farm_site)
        (farm_has_component_a ?farm_site ?feed_component_a)
        (supply_package_available ?supply_package)
        (not
          (farm_inspection_completed ?farm_site)
        )
      )
    :effect
      (and
        (feed_component_a_packaged ?feed_component_a)
        (farm_inspection_completed ?farm_site)
        (farm_allocated_supply_package ?farm_site ?supply_package)
        (not
          (supply_package_available ?supply_package)
        )
      )
  )
  (:action finalize_farm_component_preparation
    :parameters (?farm_site - farm_site ?feed_component_a - feed_component_a ?transport_unit - transport_unit ?supply_package - supply_package)
    :precondition
      (and
        (contingency_received ?farm_site)
        (transport_assigned_to_site ?farm_site ?transport_unit)
        (farm_has_component_a ?farm_site ?feed_component_a)
        (feed_component_a_packaged ?feed_component_a)
        (farm_allocated_supply_package ?farm_site ?supply_package)
        (not
          (farm_ready_for_assembly ?farm_site)
        )
      )
    :effect
      (and
        (feed_component_a_prepared ?feed_component_a)
        (farm_ready_for_assembly ?farm_site)
        (supply_package_available ?supply_package)
        (not
          (farm_allocated_supply_package ?farm_site ?supply_package)
        )
      )
  )
  (:action prepare_feed_component_b_for_storage
    :parameters (?storage_site - storage_site ?feed_component_b - feed_component_b ?transport_unit - transport_unit)
    :precondition
      (and
        (contingency_received ?storage_site)
        (transport_assigned_to_site ?storage_site ?transport_unit)
        (storage_has_component_b ?storage_site ?feed_component_b)
        (not
          (feed_component_b_prepared ?feed_component_b)
        )
        (not
          (feed_component_b_packaged ?feed_component_b)
        )
      )
    :effect (feed_component_b_prepared ?feed_component_b)
  )
  (:action perform_storage_inspection_and_mark_ready
    :parameters (?storage_site - storage_site ?feed_component_b - feed_component_b ?response_team - response_team)
    :precondition
      (and
        (contingency_received ?storage_site)
        (team_deployed_to_site ?storage_site ?response_team)
        (storage_has_component_b ?storage_site ?feed_component_b)
        (feed_component_b_prepared ?feed_component_b)
        (not
          (storage_inspection_completed ?storage_site)
        )
      )
    :effect
      (and
        (storage_inspection_completed ?storage_site)
        (storage_ready_for_assembly ?storage_site)
      )
  )
  (:action allocate_supply_package_to_storage
    :parameters (?storage_site - storage_site ?feed_component_b - feed_component_b ?supply_package - supply_package)
    :precondition
      (and
        (contingency_received ?storage_site)
        (storage_has_component_b ?storage_site ?feed_component_b)
        (supply_package_available ?supply_package)
        (not
          (storage_inspection_completed ?storage_site)
        )
      )
    :effect
      (and
        (feed_component_b_packaged ?feed_component_b)
        (storage_inspection_completed ?storage_site)
        (storage_allocated_supply_package ?storage_site ?supply_package)
        (not
          (supply_package_available ?supply_package)
        )
      )
  )
  (:action finalize_storage_component_preparation
    :parameters (?storage_site - storage_site ?feed_component_b - feed_component_b ?transport_unit - transport_unit ?supply_package - supply_package)
    :precondition
      (and
        (contingency_received ?storage_site)
        (transport_assigned_to_site ?storage_site ?transport_unit)
        (storage_has_component_b ?storage_site ?feed_component_b)
        (feed_component_b_packaged ?feed_component_b)
        (storage_allocated_supply_package ?storage_site ?supply_package)
        (not
          (storage_ready_for_assembly ?storage_site)
        )
      )
    :effect
      (and
        (feed_component_b_prepared ?feed_component_b)
        (storage_ready_for_assembly ?storage_site)
        (supply_package_available ?supply_package)
        (not
          (storage_allocated_supply_package ?storage_site ?supply_package)
        )
      )
  )
  (:action assemble_contingency_feed_lot
    :parameters (?farm_site - farm_site ?storage_site - storage_site ?feed_component_a - feed_component_a ?feed_component_b - feed_component_b ?feed_lot - feed_lot)
    :precondition
      (and
        (farm_inspection_completed ?farm_site)
        (storage_inspection_completed ?storage_site)
        (farm_has_component_a ?farm_site ?feed_component_a)
        (storage_has_component_b ?storage_site ?feed_component_b)
        (feed_component_a_prepared ?feed_component_a)
        (feed_component_b_prepared ?feed_component_b)
        (farm_ready_for_assembly ?farm_site)
        (storage_ready_for_assembly ?storage_site)
        (feed_lot_pending ?feed_lot)
      )
    :effect
      (and
        (feed_lot_created ?feed_lot)
        (feed_lot_contains_component_a ?feed_lot ?feed_component_a)
        (feed_lot_contains_component_b ?feed_lot ?feed_component_b)
        (not
          (feed_lot_pending ?feed_lot)
        )
      )
  )
  (:action assemble_contingency_feed_lot_mark_rapid
    :parameters (?farm_site - farm_site ?storage_site - storage_site ?feed_component_a - feed_component_a ?feed_component_b - feed_component_b ?feed_lot - feed_lot)
    :precondition
      (and
        (farm_inspection_completed ?farm_site)
        (storage_inspection_completed ?storage_site)
        (farm_has_component_a ?farm_site ?feed_component_a)
        (storage_has_component_b ?storage_site ?feed_component_b)
        (feed_component_a_packaged ?feed_component_a)
        (feed_component_b_prepared ?feed_component_b)
        (not
          (farm_ready_for_assembly ?farm_site)
        )
        (storage_ready_for_assembly ?storage_site)
        (feed_lot_pending ?feed_lot)
      )
    :effect
      (and
        (feed_lot_created ?feed_lot)
        (feed_lot_contains_component_a ?feed_lot ?feed_component_a)
        (feed_lot_contains_component_b ?feed_lot ?feed_component_b)
        (feed_lot_rapid ?feed_lot)
        (not
          (feed_lot_pending ?feed_lot)
        )
      )
  )
  (:action assemble_contingency_feed_lot_mark_quality_checked
    :parameters (?farm_site - farm_site ?storage_site - storage_site ?feed_component_a - feed_component_a ?feed_component_b - feed_component_b ?feed_lot - feed_lot)
    :precondition
      (and
        (farm_inspection_completed ?farm_site)
        (storage_inspection_completed ?storage_site)
        (farm_has_component_a ?farm_site ?feed_component_a)
        (storage_has_component_b ?storage_site ?feed_component_b)
        (feed_component_a_prepared ?feed_component_a)
        (feed_component_b_packaged ?feed_component_b)
        (farm_ready_for_assembly ?farm_site)
        (not
          (storage_ready_for_assembly ?storage_site)
        )
        (feed_lot_pending ?feed_lot)
      )
    :effect
      (and
        (feed_lot_created ?feed_lot)
        (feed_lot_contains_component_a ?feed_lot ?feed_component_a)
        (feed_lot_contains_component_b ?feed_lot ?feed_component_b)
        (feed_lot_quality_checked ?feed_lot)
        (not
          (feed_lot_pending ?feed_lot)
        )
      )
  )
  (:action assemble_contingency_feed_lot_mark_rapid_and_quality_checked
    :parameters (?farm_site - farm_site ?storage_site - storage_site ?feed_component_a - feed_component_a ?feed_component_b - feed_component_b ?feed_lot - feed_lot)
    :precondition
      (and
        (farm_inspection_completed ?farm_site)
        (storage_inspection_completed ?storage_site)
        (farm_has_component_a ?farm_site ?feed_component_a)
        (storage_has_component_b ?storage_site ?feed_component_b)
        (feed_component_a_packaged ?feed_component_a)
        (feed_component_b_packaged ?feed_component_b)
        (not
          (farm_ready_for_assembly ?farm_site)
        )
        (not
          (storage_ready_for_assembly ?storage_site)
        )
        (feed_lot_pending ?feed_lot)
      )
    :effect
      (and
        (feed_lot_created ?feed_lot)
        (feed_lot_contains_component_a ?feed_lot ?feed_component_a)
        (feed_lot_contains_component_b ?feed_lot ?feed_component_b)
        (feed_lot_rapid ?feed_lot)
        (feed_lot_quality_checked ?feed_lot)
        (not
          (feed_lot_pending ?feed_lot)
        )
      )
  )
  (:action mark_feed_lot_processed
    :parameters (?feed_lot - feed_lot ?farm_site - farm_site ?transport_unit - transport_unit)
    :precondition
      (and
        (feed_lot_created ?feed_lot)
        (farm_inspection_completed ?farm_site)
        (transport_assigned_to_site ?farm_site ?transport_unit)
        (not
          (feed_lot_processed ?feed_lot)
        )
      )
    :effect (feed_lot_processed ?feed_lot)
  )
  (:action validate_and_allocate_ingredient_batch
    :parameters (?processing_facility - processing_facility ?ingredient_batch - ingredient_batch ?feed_lot - feed_lot)
    :precondition
      (and
        (contingency_received ?processing_facility)
        (facility_has_feed_lot ?processing_facility ?feed_lot)
        (facility_has_ingredient_batch ?processing_facility ?ingredient_batch)
        (ingredient_batch_available ?ingredient_batch)
        (feed_lot_created ?feed_lot)
        (feed_lot_processed ?feed_lot)
        (not
          (ingredient_batch_validated ?ingredient_batch)
        )
      )
    :effect
      (and
        (ingredient_batch_validated ?ingredient_batch)
        (ingredient_batch_allocated_to_lot ?ingredient_batch ?feed_lot)
        (not
          (ingredient_batch_available ?ingredient_batch)
        )
      )
  )
  (:action prepare_facility_for_processing
    :parameters (?processing_facility - processing_facility ?ingredient_batch - ingredient_batch ?feed_lot - feed_lot ?transport_unit - transport_unit)
    :precondition
      (and
        (contingency_received ?processing_facility)
        (facility_has_ingredient_batch ?processing_facility ?ingredient_batch)
        (ingredient_batch_validated ?ingredient_batch)
        (ingredient_batch_allocated_to_lot ?ingredient_batch ?feed_lot)
        (transport_assigned_to_site ?processing_facility ?transport_unit)
        (not
          (feed_lot_rapid ?feed_lot)
        )
        (not
          (facility_ready_for_testing ?processing_facility)
        )
      )
    :effect (facility_ready_for_testing ?processing_facility)
  )
  (:action allocate_special_equipment_to_facility
    :parameters (?processing_facility - processing_facility ?special_equipment - special_equipment)
    :precondition
      (and
        (contingency_received ?processing_facility)
        (special_equipment_available ?special_equipment)
        (not
          (facility_equipment_allocated ?processing_facility)
        )
      )
    :effect
      (and
        (facility_equipment_allocated ?processing_facility)
        (facility_allocated_special_equipment ?processing_facility ?special_equipment)
        (not
          (special_equipment_available ?special_equipment)
        )
      )
  )
  (:action engage_equipment_and_prepare_facility
    :parameters (?processing_facility - processing_facility ?ingredient_batch - ingredient_batch ?feed_lot - feed_lot ?transport_unit - transport_unit ?special_equipment - special_equipment)
    :precondition
      (and
        (contingency_received ?processing_facility)
        (facility_has_ingredient_batch ?processing_facility ?ingredient_batch)
        (ingredient_batch_validated ?ingredient_batch)
        (ingredient_batch_allocated_to_lot ?ingredient_batch ?feed_lot)
        (transport_assigned_to_site ?processing_facility ?transport_unit)
        (feed_lot_rapid ?feed_lot)
        (facility_equipment_allocated ?processing_facility)
        (facility_allocated_special_equipment ?processing_facility ?special_equipment)
        (not
          (facility_ready_for_testing ?processing_facility)
        )
      )
    :effect
      (and
        (facility_ready_for_testing ?processing_facility)
        (facility_equipment_engaged ?processing_facility)
      )
  )
  (:action perform_quality_testing_standard
    :parameters (?processing_facility - processing_facility ?quality_test_kit - quality_test_kit ?response_team - response_team ?ingredient_batch - ingredient_batch ?feed_lot - feed_lot)
    :precondition
      (and
        (facility_ready_for_testing ?processing_facility)
        (facility_allocated_test_kit ?processing_facility ?quality_test_kit)
        (team_deployed_to_site ?processing_facility ?response_team)
        (facility_has_ingredient_batch ?processing_facility ?ingredient_batch)
        (ingredient_batch_allocated_to_lot ?ingredient_batch ?feed_lot)
        (not
          (feed_lot_quality_checked ?feed_lot)
        )
        (not
          (facility_testing_completed ?processing_facility)
        )
      )
    :effect (facility_testing_completed ?processing_facility)
  )
  (:action perform_quality_testing_with_quality_flag
    :parameters (?processing_facility - processing_facility ?quality_test_kit - quality_test_kit ?response_team - response_team ?ingredient_batch - ingredient_batch ?feed_lot - feed_lot)
    :precondition
      (and
        (facility_ready_for_testing ?processing_facility)
        (facility_allocated_test_kit ?processing_facility ?quality_test_kit)
        (team_deployed_to_site ?processing_facility ?response_team)
        (facility_has_ingredient_batch ?processing_facility ?ingredient_batch)
        (ingredient_batch_allocated_to_lot ?ingredient_batch ?feed_lot)
        (feed_lot_quality_checked ?feed_lot)
        (not
          (facility_testing_completed ?processing_facility)
        )
      )
    :effect (facility_testing_completed ?processing_facility)
  )
  (:action finalize_certification_standard
    :parameters (?processing_facility - processing_facility ?certification_record - certification_record ?ingredient_batch - ingredient_batch ?feed_lot - feed_lot)
    :precondition
      (and
        (facility_testing_completed ?processing_facility)
        (facility_allocated_certification_record ?processing_facility ?certification_record)
        (facility_has_ingredient_batch ?processing_facility ?ingredient_batch)
        (ingredient_batch_allocated_to_lot ?ingredient_batch ?feed_lot)
        (not
          (feed_lot_rapid ?feed_lot)
        )
        (not
          (feed_lot_quality_checked ?feed_lot)
        )
        (not
          (facility_processing_complete ?processing_facility)
        )
      )
    :effect (facility_processing_complete ?processing_facility)
  )
  (:action finalize_certification_with_rapid_flag
    :parameters (?processing_facility - processing_facility ?certification_record - certification_record ?ingredient_batch - ingredient_batch ?feed_lot - feed_lot)
    :precondition
      (and
        (facility_testing_completed ?processing_facility)
        (facility_allocated_certification_record ?processing_facility ?certification_record)
        (facility_has_ingredient_batch ?processing_facility ?ingredient_batch)
        (ingredient_batch_allocated_to_lot ?ingredient_batch ?feed_lot)
        (feed_lot_rapid ?feed_lot)
        (not
          (feed_lot_quality_checked ?feed_lot)
        )
        (not
          (facility_processing_complete ?processing_facility)
        )
      )
    :effect
      (and
        (facility_processing_complete ?processing_facility)
        (facility_processing_finalized ?processing_facility)
      )
  )
  (:action finalize_certification_with_quality_flag
    :parameters (?processing_facility - processing_facility ?certification_record - certification_record ?ingredient_batch - ingredient_batch ?feed_lot - feed_lot)
    :precondition
      (and
        (facility_testing_completed ?processing_facility)
        (facility_allocated_certification_record ?processing_facility ?certification_record)
        (facility_has_ingredient_batch ?processing_facility ?ingredient_batch)
        (ingredient_batch_allocated_to_lot ?ingredient_batch ?feed_lot)
        (not
          (feed_lot_rapid ?feed_lot)
        )
        (feed_lot_quality_checked ?feed_lot)
        (not
          (facility_processing_complete ?processing_facility)
        )
      )
    :effect
      (and
        (facility_processing_complete ?processing_facility)
        (facility_processing_finalized ?processing_facility)
      )
  )
  (:action finalize_certification_with_rapid_and_quality_flags
    :parameters (?processing_facility - processing_facility ?certification_record - certification_record ?ingredient_batch - ingredient_batch ?feed_lot - feed_lot)
    :precondition
      (and
        (facility_testing_completed ?processing_facility)
        (facility_allocated_certification_record ?processing_facility ?certification_record)
        (facility_has_ingredient_batch ?processing_facility ?ingredient_batch)
        (ingredient_batch_allocated_to_lot ?ingredient_batch ?feed_lot)
        (feed_lot_rapid ?feed_lot)
        (feed_lot_quality_checked ?feed_lot)
        (not
          (facility_processing_complete ?processing_facility)
        )
      )
    :effect
      (and
        (facility_processing_complete ?processing_facility)
        (facility_processing_finalized ?processing_facility)
      )
  )
  (:action record_facility_processing_completion
    :parameters (?processing_facility - processing_facility)
    :precondition
      (and
        (facility_processing_complete ?processing_facility)
        (not
          (facility_processing_finalized ?processing_facility)
        )
        (not
          (facility_finalized ?processing_facility)
        )
      )
    :effect
      (and
        (facility_finalized ?processing_facility)
        (feed_received ?processing_facility)
      )
  )
  (:action assign_recovery_resource_to_facility
    :parameters (?processing_facility - processing_facility ?recovery_resource - recovery_resource)
    :precondition
      (and
        (facility_processing_complete ?processing_facility)
        (facility_processing_finalized ?processing_facility)
        (recovery_resource_available ?recovery_resource)
      )
    :effect
      (and
        (facility_allocated_recovery_resource ?processing_facility ?recovery_resource)
        (not
          (recovery_resource_available ?recovery_resource)
        )
      )
  )
  (:action prepare_facility_for_distribution
    :parameters (?processing_facility - processing_facility ?farm_site - farm_site ?storage_site - storage_site ?transport_unit - transport_unit ?recovery_resource - recovery_resource)
    :precondition
      (and
        (facility_processing_complete ?processing_facility)
        (facility_processing_finalized ?processing_facility)
        (facility_allocated_recovery_resource ?processing_facility ?recovery_resource)
        (facility_serves_farm ?processing_facility ?farm_site)
        (facility_serves_storage ?processing_facility ?storage_site)
        (farm_ready_for_assembly ?farm_site)
        (storage_ready_for_assembly ?storage_site)
        (transport_assigned_to_site ?processing_facility ?transport_unit)
        (not
          (facility_ready_for_distribution ?processing_facility)
        )
      )
    :effect (facility_ready_for_distribution ?processing_facility)
  )
  (:action complete_facility_distribution
    :parameters (?processing_facility - processing_facility)
    :precondition
      (and
        (facility_processing_complete ?processing_facility)
        (facility_ready_for_distribution ?processing_facility)
        (not
          (facility_finalized ?processing_facility)
        )
      )
    :effect
      (and
        (facility_finalized ?processing_facility)
        (feed_received ?processing_facility)
      )
  )
  (:action apply_decision_record_to_facility
    :parameters (?processing_facility - processing_facility ?decision_record - decision_record ?transport_unit - transport_unit)
    :precondition
      (and
        (contingency_received ?processing_facility)
        (transport_assigned_to_site ?processing_facility ?transport_unit)
        (decision_record_available ?decision_record)
        (facility_linked_decision_record ?processing_facility ?decision_record)
        (not
          (decision_applied_to_facility ?processing_facility)
        )
      )
    :effect
      (and
        (decision_applied_to_facility ?processing_facility)
        (not
          (decision_record_available ?decision_record)
        )
      )
  )
  (:action prepare_facility_equipment_with_team
    :parameters (?processing_facility - processing_facility ?response_team - response_team)
    :precondition
      (and
        (decision_applied_to_facility ?processing_facility)
        (team_deployed_to_site ?processing_facility ?response_team)
        (not
          (facility_equipment_ready ?processing_facility)
        )
      )
    :effect (facility_equipment_ready ?processing_facility)
  )
  (:action apply_certification_to_facility
    :parameters (?processing_facility - processing_facility ?certification_record - certification_record)
    :precondition
      (and
        (facility_equipment_ready ?processing_facility)
        (facility_allocated_certification_record ?processing_facility ?certification_record)
        (not
          (facility_certification_ready ?processing_facility)
        )
      )
    :effect (facility_certification_ready ?processing_facility)
  )
  (:action finalize_facility_certification
    :parameters (?processing_facility - processing_facility)
    :precondition
      (and
        (facility_certification_ready ?processing_facility)
        (not
          (facility_finalized ?processing_facility)
        )
      )
    :effect
      (and
        (facility_finalized ?processing_facility)
        (feed_received ?processing_facility)
      )
  )
  (:action deliver_feed_lot_to_farm
    :parameters (?farm_site - farm_site ?feed_lot - feed_lot)
    :precondition
      (and
        (farm_inspection_completed ?farm_site)
        (farm_ready_for_assembly ?farm_site)
        (feed_lot_created ?feed_lot)
        (feed_lot_processed ?feed_lot)
        (not
          (feed_received ?farm_site)
        )
      )
    :effect (feed_received ?farm_site)
  )
  (:action deliver_feed_lot_to_storage
    :parameters (?storage_site - storage_site ?feed_lot - feed_lot)
    :precondition
      (and
        (storage_inspection_completed ?storage_site)
        (storage_ready_for_assembly ?storage_site)
        (feed_lot_created ?feed_lot)
        (feed_lot_processed ?feed_lot)
        (not
          (feed_received ?storage_site)
        )
      )
    :effect (feed_received ?storage_site)
  )
  (:action apply_authorization_document_to_site
    :parameters (?site - site ?authorization_document - authorization_document ?transport_unit - transport_unit)
    :precondition
      (and
        (feed_received ?site)
        (transport_assigned_to_site ?site ?transport_unit)
        (authorization_document_available ?authorization_document)
        (not
          (authorization_granted ?site)
        )
      )
    :effect
      (and
        (authorization_granted ?site)
        (site_linked_authorization_document ?site ?authorization_document)
        (not
          (authorization_document_available ?authorization_document)
        )
      )
  )
  (:action finalize_authorization_and_restore_farm_supply
    :parameters (?farm_site - farm_site ?contingency_feed_source - contingency_feed_source ?authorization_document - authorization_document)
    :precondition
      (and
        (authorization_granted ?farm_site)
        (site_allocated_contingency_source ?farm_site ?contingency_feed_source)
        (site_linked_authorization_document ?farm_site ?authorization_document)
        (not
          (supply_restored ?farm_site)
        )
      )
    :effect
      (and
        (supply_restored ?farm_site)
        (contingency_feed_source_available ?contingency_feed_source)
        (authorization_document_available ?authorization_document)
      )
  )
  (:action finalize_authorization_and_restore_storage_supply
    :parameters (?storage_site - storage_site ?contingency_feed_source - contingency_feed_source ?authorization_document - authorization_document)
    :precondition
      (and
        (authorization_granted ?storage_site)
        (site_allocated_contingency_source ?storage_site ?contingency_feed_source)
        (site_linked_authorization_document ?storage_site ?authorization_document)
        (not
          (supply_restored ?storage_site)
        )
      )
    :effect
      (and
        (supply_restored ?storage_site)
        (contingency_feed_source_available ?contingency_feed_source)
        (authorization_document_available ?authorization_document)
      )
  )
  (:action finalize_authorization_and_restore_facility_supply
    :parameters (?processing_facility - processing_facility ?contingency_feed_source - contingency_feed_source ?authorization_document - authorization_document)
    :precondition
      (and
        (authorization_granted ?processing_facility)
        (site_allocated_contingency_source ?processing_facility ?contingency_feed_source)
        (site_linked_authorization_document ?processing_facility ?authorization_document)
        (not
          (supply_restored ?processing_facility)
        )
      )
    :effect
      (and
        (supply_restored ?processing_facility)
        (contingency_feed_source_available ?contingency_feed_source)
        (authorization_document_available ?authorization_document)
      )
  )
)

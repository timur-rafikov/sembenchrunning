(define (domain cold_storage_failure_salvage_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object storage_asset_category - entity resource_category - entity personnel_category - entity operational_asset - entity lot_record - operational_asset mobile_resource - storage_asset_category operator - storage_asset_category inspector - storage_asset_category permit_document - storage_asset_category processing_protocol - storage_asset_category repair_order - storage_asset_category testing_kit - storage_asset_category external_expert - storage_asset_category supply - resource_category sample - resource_category clearance_token - resource_category conditioning_profile - personnel_category transport_plan - personnel_category salvage_shipment - personnel_category storage_unit_type - lot_record response_unit_type - lot_record primary_cold_storage_unit - storage_unit_type secondary_cold_storage_unit - storage_unit_type response_facility - response_unit_type)

  (:predicates
    (asset_failure_flagged ?lot_record - lot_record)
    (assessed_for_salvage ?lot_record - lot_record)
    (asset_containment_initiated ?lot_record - lot_record)
    (asset_restored_to_service ?lot_record - lot_record)
    (ready_for_recovery ?lot_record - lot_record)
    (ready_for_repair ?lot_record - lot_record)
    (mobile_resource_available ?mobile_resource - mobile_resource)
    (resource_allocated_to_asset ?lot_record - lot_record ?mobile_resource - mobile_resource)
    (operator_available ?operator - operator)
    (operator_assigned_for_sampling ?lot_record - lot_record ?operator - operator)
    (inspector_available ?inspector - inspector)
    (inspector_assigned_to_asset ?lot_record - lot_record ?inspector - inspector)
    (supply_available ?supply - supply)
    (primary_supply_allocated ?primary_unit - primary_cold_storage_unit ?supply - supply)
    (secondary_supply_allocated ?secondary_unit - secondary_cold_storage_unit ?supply - supply)
    (primary_conditioning_linked ?primary_unit - primary_cold_storage_unit ?conditioning_profile - conditioning_profile)
    (conditioning_profile_active ?conditioning_profile - conditioning_profile)
    (conditioning_profile_released ?conditioning_profile - conditioning_profile)
    (primary_unit_staged ?primary_unit - primary_cold_storage_unit)
    (secondary_transport_linked ?secondary_unit - secondary_cold_storage_unit ?transport_profile - transport_plan)
    (transport_profile_active ?transport_profile - transport_plan)
    (transport_profile_released ?transport_profile - transport_plan)
    (secondary_unit_staged ?secondary_unit - secondary_cold_storage_unit)
    (salvage_shipment_available ?salvage_shipment - salvage_shipment)
    (shipment_consolidated ?salvage_shipment - salvage_shipment)
    (shipment_conditioning_linked ?salvage_shipment - salvage_shipment ?conditioning_profile - conditioning_profile)
    (shipment_transport_linked ?salvage_shipment - salvage_shipment ?transport_profile - transport_plan)
    (shipment_condition_verified ?salvage_shipment - salvage_shipment)
    (shipment_route_verified ?salvage_shipment - salvage_shipment)
    (shipment_ready ?salvage_shipment - salvage_shipment)
    (facility_has_primary_unit ?response_facility - response_facility ?primary_unit - primary_cold_storage_unit)
    (facility_has_secondary_unit ?response_facility - response_facility ?secondary_unit - secondary_cold_storage_unit)
    (facility_has_salvage_shipment ?response_facility - response_facility ?salvage_shipment - salvage_shipment)
    (sample_available ?sample - sample)
    (sample_checked_in ?response_facility - response_facility ?sample - sample)
    (sample_prepared ?sample - sample)
    (sample_packaged ?sample - sample ?salvage_shipment - salvage_shipment)
    (processing_ready ?response_facility - response_facility)
    (processing_underway ?response_facility - response_facility)
    (processing_finalized ?response_facility - response_facility)
    (regulatory_review_opened ?response_facility - response_facility)
    (processing_clearance_recorded ?response_facility - response_facility)
    (special_processing_required ?response_facility - response_facility)
    (processing_validated ?response_facility - response_facility)
    (clearance_token_available ?clearance_token - clearance_token)
    (clearance_token_linked ?response_facility - response_facility ?clearance_token - clearance_token)
    (preliminary_clearance_recorded ?response_facility - response_facility)
    (intermediate_clearance_recorded ?response_facility - response_facility)
    (final_clearance_recorded ?response_facility - response_facility)
    (permit_available ?permit_document - permit_document)
    (permit_linked ?response_facility - response_facility ?permit_document - permit_document)
    (processing_protocol_available ?processing_protocol - processing_protocol)
    (processing_protocol_linked ?response_facility - response_facility ?processing_protocol - processing_protocol)
    (testing_kit_available ?testing_kit - testing_kit)
    (testing_kit_linked ?response_facility - response_facility ?testing_kit - testing_kit)
    (external_expert_available ?external_expert - external_expert)
    (external_expert_linked ?response_facility - response_facility ?external_expert - external_expert)
    (repair_order_available ?repair_order - repair_order)
    (repair_order_linked_to_asset ?lot_record - lot_record ?repair_order - repair_order)
    (primary_unit_quarantined ?primary_unit - primary_cold_storage_unit)
    (secondary_unit_quarantined ?secondary_unit - secondary_cold_storage_unit)
    (release_authorized ?response_facility - response_facility)
  )
  (:action flag_failure
    :parameters (?lot_record - lot_record)
    :precondition
      (and
        (not
          (asset_failure_flagged ?lot_record)
        )
        (not
          (asset_restored_to_service ?lot_record)
        )
      )
    :effect (asset_failure_flagged ?lot_record)
  )
  (:action assign_mobile_resource
    :parameters (?lot_record - lot_record ?mobile_resource - mobile_resource)
    :precondition
      (and
        (asset_failure_flagged ?lot_record)
        (not
          (asset_containment_initiated ?lot_record)
        )
        (mobile_resource_available ?mobile_resource)
      )
    :effect
      (and
        (asset_containment_initiated ?lot_record)
        (resource_allocated_to_asset ?lot_record ?mobile_resource)
        (not
          (mobile_resource_available ?mobile_resource)
        )
      )
  )
  (:action assign_sampling_operator
    :parameters (?lot_record - lot_record ?operator - operator)
    :precondition
      (and
        (asset_failure_flagged ?lot_record)
        (asset_containment_initiated ?lot_record)
        (operator_available ?operator)
      )
    :effect
      (and
        (operator_assigned_for_sampling ?lot_record ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action confirm_salvage_assessment
    :parameters (?lot_record - lot_record ?operator - operator)
    :precondition
      (and
        (asset_failure_flagged ?lot_record)
        (asset_containment_initiated ?lot_record)
        (operator_assigned_for_sampling ?lot_record ?operator)
        (not
          (assessed_for_salvage ?lot_record)
        )
      )
    :effect (assessed_for_salvage ?lot_record)
  )
  (:action restore_sampling_operator
    :parameters (?lot_record - lot_record ?operator - operator)
    :precondition
      (and
        (operator_assigned_for_sampling ?lot_record ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (operator_assigned_for_sampling ?lot_record ?operator)
        )
      )
  )
  (:action assign_inspector
    :parameters (?lot_record - lot_record ?inspector - inspector)
    :precondition
      (and
        (assessed_for_salvage ?lot_record)
        (inspector_available ?inspector)
      )
    :effect
      (and
        (inspector_assigned_to_asset ?lot_record ?inspector)
        (not
          (inspector_available ?inspector)
        )
      )
  )
  (:action restore_inspector
    :parameters (?lot_record - lot_record ?inspector - inspector)
    :precondition
      (and
        (inspector_assigned_to_asset ?lot_record ?inspector)
      )
    :effect
      (and
        (inspector_available ?inspector)
        (not
          (inspector_assigned_to_asset ?lot_record ?inspector)
        )
      )
  )
  (:action assign_testing_kit
    :parameters (?response_facility - response_facility ?testing_kit - testing_kit)
    :precondition
      (and
        (assessed_for_salvage ?response_facility)
        (testing_kit_available ?testing_kit)
      )
    :effect
      (and
        (testing_kit_linked ?response_facility ?testing_kit)
        (not
          (testing_kit_available ?testing_kit)
        )
      )
  )
  (:action restore_testing_kit
    :parameters (?response_facility - response_facility ?testing_kit - testing_kit)
    :precondition
      (and
        (testing_kit_linked ?response_facility ?testing_kit)
      )
    :effect
      (and
        (testing_kit_available ?testing_kit)
        (not
          (testing_kit_linked ?response_facility ?testing_kit)
        )
      )
  )
  (:action assign_external_expert
    :parameters (?response_facility - response_facility ?external_expert - external_expert)
    :precondition
      (and
        (assessed_for_salvage ?response_facility)
        (external_expert_available ?external_expert)
      )
    :effect
      (and
        (external_expert_linked ?response_facility ?external_expert)
        (not
          (external_expert_available ?external_expert)
        )
      )
  )
  (:action restore_external_expert
    :parameters (?response_facility - response_facility ?external_expert - external_expert)
    :precondition
      (and
        (external_expert_linked ?response_facility ?external_expert)
      )
    :effect
      (and
        (external_expert_available ?external_expert)
        (not
          (external_expert_linked ?response_facility ?external_expert)
        )
      )
  )
  (:action initiate_primary_conditioning
    :parameters (?primary_unit - primary_cold_storage_unit ?conditioning_profile - conditioning_profile ?operator - operator)
    :precondition
      (and
        (assessed_for_salvage ?primary_unit)
        (operator_assigned_for_sampling ?primary_unit ?operator)
        (primary_conditioning_linked ?primary_unit ?conditioning_profile)
        (not
          (conditioning_profile_active ?conditioning_profile)
        )
        (not
          (conditioning_profile_released ?conditioning_profile)
        )
      )
    :effect (conditioning_profile_active ?conditioning_profile)
  )
  (:action quarantine_primary_unit
    :parameters (?primary_unit - primary_cold_storage_unit ?conditioning_profile - conditioning_profile ?inspector - inspector)
    :precondition
      (and
        (assessed_for_salvage ?primary_unit)
        (inspector_assigned_to_asset ?primary_unit ?inspector)
        (primary_conditioning_linked ?primary_unit ?conditioning_profile)
        (conditioning_profile_active ?conditioning_profile)
        (not
          (primary_unit_quarantined ?primary_unit)
        )
      )
    :effect
      (and
        (primary_unit_quarantined ?primary_unit)
        (primary_unit_staged ?primary_unit)
      )
  )
  (:action allocate_primary_contingency_supply
    :parameters (?primary_unit - primary_cold_storage_unit ?conditioning_profile - conditioning_profile ?supply - supply)
    :precondition
      (and
        (assessed_for_salvage ?primary_unit)
        (primary_conditioning_linked ?primary_unit ?conditioning_profile)
        (supply_available ?supply)
        (not
          (primary_unit_quarantined ?primary_unit)
        )
      )
    :effect
      (and
        (conditioning_profile_released ?conditioning_profile)
        (primary_unit_quarantined ?primary_unit)
        (primary_supply_allocated ?primary_unit ?supply)
        (not
          (supply_available ?supply)
        )
      )
  )
  (:action release_primary_contingency_supply
    :parameters (?primary_unit - primary_cold_storage_unit ?conditioning_profile - conditioning_profile ?operator - operator ?supply - supply)
    :precondition
      (and
        (assessed_for_salvage ?primary_unit)
        (operator_assigned_for_sampling ?primary_unit ?operator)
        (primary_conditioning_linked ?primary_unit ?conditioning_profile)
        (conditioning_profile_released ?conditioning_profile)
        (primary_supply_allocated ?primary_unit ?supply)
        (not
          (primary_unit_staged ?primary_unit)
        )
      )
    :effect
      (and
        (conditioning_profile_active ?conditioning_profile)
        (primary_unit_staged ?primary_unit)
        (supply_available ?supply)
        (not
          (primary_supply_allocated ?primary_unit ?supply)
        )
      )
  )
  (:action initiate_secondary_transport
    :parameters (?secondary_unit - secondary_cold_storage_unit ?transport_profile - transport_plan ?operator - operator)
    :precondition
      (and
        (assessed_for_salvage ?secondary_unit)
        (operator_assigned_for_sampling ?secondary_unit ?operator)
        (secondary_transport_linked ?secondary_unit ?transport_profile)
        (not
          (transport_profile_active ?transport_profile)
        )
        (not
          (transport_profile_released ?transport_profile)
        )
      )
    :effect (transport_profile_active ?transport_profile)
  )
  (:action quarantine_secondary_unit
    :parameters (?secondary_unit - secondary_cold_storage_unit ?transport_profile - transport_plan ?inspector - inspector)
    :precondition
      (and
        (assessed_for_salvage ?secondary_unit)
        (inspector_assigned_to_asset ?secondary_unit ?inspector)
        (secondary_transport_linked ?secondary_unit ?transport_profile)
        (transport_profile_active ?transport_profile)
        (not
          (secondary_unit_quarantined ?secondary_unit)
        )
      )
    :effect
      (and
        (secondary_unit_quarantined ?secondary_unit)
        (secondary_unit_staged ?secondary_unit)
      )
  )
  (:action allocate_secondary_contingency_supply
    :parameters (?secondary_unit - secondary_cold_storage_unit ?transport_profile - transport_plan ?supply - supply)
    :precondition
      (and
        (assessed_for_salvage ?secondary_unit)
        (secondary_transport_linked ?secondary_unit ?transport_profile)
        (supply_available ?supply)
        (not
          (secondary_unit_quarantined ?secondary_unit)
        )
      )
    :effect
      (and
        (transport_profile_released ?transport_profile)
        (secondary_unit_quarantined ?secondary_unit)
        (secondary_supply_allocated ?secondary_unit ?supply)
        (not
          (supply_available ?supply)
        )
      )
  )
  (:action release_secondary_contingency_supply
    :parameters (?secondary_unit - secondary_cold_storage_unit ?transport_profile - transport_plan ?operator - operator ?supply - supply)
    :precondition
      (and
        (assessed_for_salvage ?secondary_unit)
        (operator_assigned_for_sampling ?secondary_unit ?operator)
        (secondary_transport_linked ?secondary_unit ?transport_profile)
        (transport_profile_released ?transport_profile)
        (secondary_supply_allocated ?secondary_unit ?supply)
        (not
          (secondary_unit_staged ?secondary_unit)
        )
      )
    :effect
      (and
        (transport_profile_active ?transport_profile)
        (secondary_unit_staged ?secondary_unit)
        (supply_available ?supply)
        (not
          (secondary_supply_allocated ?secondary_unit ?supply)
        )
      )
  )
  (:action consolidate_salvage_shipment
    :parameters (?primary_unit - primary_cold_storage_unit ?secondary_unit - secondary_cold_storage_unit ?conditioning_profile - conditioning_profile ?transport_profile - transport_plan ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (primary_unit_quarantined ?primary_unit)
        (secondary_unit_quarantined ?secondary_unit)
        (primary_conditioning_linked ?primary_unit ?conditioning_profile)
        (secondary_transport_linked ?secondary_unit ?transport_profile)
        (conditioning_profile_active ?conditioning_profile)
        (transport_profile_active ?transport_profile)
        (primary_unit_staged ?primary_unit)
        (secondary_unit_staged ?secondary_unit)
        (salvage_shipment_available ?salvage_shipment)
      )
    :effect
      (and
        (shipment_consolidated ?salvage_shipment)
        (shipment_conditioning_linked ?salvage_shipment ?conditioning_profile)
        (shipment_transport_linked ?salvage_shipment ?transport_profile)
        (not
          (salvage_shipment_available ?salvage_shipment)
        )
      )
  )
  (:action verify_shipment_conditioning
    :parameters (?primary_unit - primary_cold_storage_unit ?secondary_unit - secondary_cold_storage_unit ?conditioning_profile - conditioning_profile ?transport_profile - transport_plan ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (primary_unit_quarantined ?primary_unit)
        (secondary_unit_quarantined ?secondary_unit)
        (primary_conditioning_linked ?primary_unit ?conditioning_profile)
        (secondary_transport_linked ?secondary_unit ?transport_profile)
        (conditioning_profile_released ?conditioning_profile)
        (transport_profile_active ?transport_profile)
        (not
          (primary_unit_staged ?primary_unit)
        )
        (secondary_unit_staged ?secondary_unit)
        (salvage_shipment_available ?salvage_shipment)
      )
    :effect
      (and
        (shipment_consolidated ?salvage_shipment)
        (shipment_conditioning_linked ?salvage_shipment ?conditioning_profile)
        (shipment_transport_linked ?salvage_shipment ?transport_profile)
        (shipment_condition_verified ?salvage_shipment)
        (not
          (salvage_shipment_available ?salvage_shipment)
        )
      )
  )
  (:action verify_shipment_route
    :parameters (?primary_unit - primary_cold_storage_unit ?secondary_unit - secondary_cold_storage_unit ?conditioning_profile - conditioning_profile ?transport_profile - transport_plan ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (primary_unit_quarantined ?primary_unit)
        (secondary_unit_quarantined ?secondary_unit)
        (primary_conditioning_linked ?primary_unit ?conditioning_profile)
        (secondary_transport_linked ?secondary_unit ?transport_profile)
        (conditioning_profile_active ?conditioning_profile)
        (transport_profile_released ?transport_profile)
        (primary_unit_staged ?primary_unit)
        (not
          (secondary_unit_staged ?secondary_unit)
        )
        (salvage_shipment_available ?salvage_shipment)
      )
    :effect
      (and
        (shipment_consolidated ?salvage_shipment)
        (shipment_conditioning_linked ?salvage_shipment ?conditioning_profile)
        (shipment_transport_linked ?salvage_shipment ?transport_profile)
        (shipment_route_verified ?salvage_shipment)
        (not
          (salvage_shipment_available ?salvage_shipment)
        )
      )
  )
  (:action fully_verify_shipment
    :parameters (?primary_unit - primary_cold_storage_unit ?secondary_unit - secondary_cold_storage_unit ?conditioning_profile - conditioning_profile ?transport_profile - transport_plan ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (primary_unit_quarantined ?primary_unit)
        (secondary_unit_quarantined ?secondary_unit)
        (primary_conditioning_linked ?primary_unit ?conditioning_profile)
        (secondary_transport_linked ?secondary_unit ?transport_profile)
        (conditioning_profile_released ?conditioning_profile)
        (transport_profile_released ?transport_profile)
        (not
          (primary_unit_staged ?primary_unit)
        )
        (not
          (secondary_unit_staged ?secondary_unit)
        )
        (salvage_shipment_available ?salvage_shipment)
      )
    :effect
      (and
        (shipment_consolidated ?salvage_shipment)
        (shipment_conditioning_linked ?salvage_shipment ?conditioning_profile)
        (shipment_transport_linked ?salvage_shipment ?transport_profile)
        (shipment_condition_verified ?salvage_shipment)
        (shipment_route_verified ?salvage_shipment)
        (not
          (salvage_shipment_available ?salvage_shipment)
        )
      )
  )
  (:action authorize_shipment_dispatch
    :parameters (?salvage_shipment - salvage_shipment ?primary_unit - primary_cold_storage_unit ?operator - operator)
    :precondition
      (and
        (shipment_consolidated ?salvage_shipment)
        (primary_unit_quarantined ?primary_unit)
        (operator_assigned_for_sampling ?primary_unit ?operator)
        (not
          (shipment_ready ?salvage_shipment)
        )
      )
    :effect (shipment_ready ?salvage_shipment)
  )
  (:action prepare_sample_for_testing
    :parameters (?response_facility - response_facility ?sample - sample ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (assessed_for_salvage ?response_facility)
        (facility_has_salvage_shipment ?response_facility ?salvage_shipment)
        (sample_checked_in ?response_facility ?sample)
        (sample_available ?sample)
        (shipment_consolidated ?salvage_shipment)
        (shipment_ready ?salvage_shipment)
        (not
          (sample_prepared ?sample)
        )
      )
    :effect
      (and
        (sample_prepared ?sample)
        (sample_packaged ?sample ?salvage_shipment)
        (not
          (sample_available ?sample)
        )
      )
  )
  (:action mark_processing_ready
    :parameters (?response_facility - response_facility ?sample - sample ?salvage_shipment - salvage_shipment ?operator - operator)
    :precondition
      (and
        (assessed_for_salvage ?response_facility)
        (sample_checked_in ?response_facility ?sample)
        (sample_prepared ?sample)
        (sample_packaged ?sample ?salvage_shipment)
        (operator_assigned_for_sampling ?response_facility ?operator)
        (not
          (shipment_condition_verified ?salvage_shipment)
        )
        (not
          (processing_ready ?response_facility)
        )
      )
    :effect (processing_ready ?response_facility)
  )
  (:action begin_regulatory_review
    :parameters (?response_facility - response_facility ?permit_document - permit_document)
    :precondition
      (and
        (assessed_for_salvage ?response_facility)
        (permit_available ?permit_document)
        (not
          (regulatory_review_opened ?response_facility)
        )
      )
    :effect
      (and
        (regulatory_review_opened ?response_facility)
        (permit_linked ?response_facility ?permit_document)
        (not
          (permit_available ?permit_document)
        )
      )
  )
  (:action authorize_processing
    :parameters (?response_facility - response_facility ?sample - sample ?salvage_shipment - salvage_shipment ?operator - operator ?permit_document - permit_document)
    :precondition
      (and
        (assessed_for_salvage ?response_facility)
        (sample_checked_in ?response_facility ?sample)
        (sample_prepared ?sample)
        (sample_packaged ?sample ?salvage_shipment)
        (operator_assigned_for_sampling ?response_facility ?operator)
        (shipment_condition_verified ?salvage_shipment)
        (regulatory_review_opened ?response_facility)
        (permit_linked ?response_facility ?permit_document)
        (not
          (processing_ready ?response_facility)
        )
      )
    :effect
      (and
        (processing_ready ?response_facility)
        (processing_clearance_recorded ?response_facility)
      )
  )
  (:action start_processing_with_condition_hold
    :parameters (?response_facility - response_facility ?testing_kit - testing_kit ?inspector - inspector ?sample - sample ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (processing_ready ?response_facility)
        (testing_kit_linked ?response_facility ?testing_kit)
        (inspector_assigned_to_asset ?response_facility ?inspector)
        (sample_checked_in ?response_facility ?sample)
        (sample_packaged ?sample ?salvage_shipment)
        (not
          (shipment_route_verified ?salvage_shipment)
        )
        (not
          (processing_underway ?response_facility)
        )
      )
    :effect (processing_underway ?response_facility)
  )
  (:action start_processing_with_route_hold
    :parameters (?response_facility - response_facility ?testing_kit - testing_kit ?inspector - inspector ?sample - sample ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (processing_ready ?response_facility)
        (testing_kit_linked ?response_facility ?testing_kit)
        (inspector_assigned_to_asset ?response_facility ?inspector)
        (sample_checked_in ?response_facility ?sample)
        (sample_packaged ?sample ?salvage_shipment)
        (shipment_route_verified ?salvage_shipment)
        (not
          (processing_underway ?response_facility)
        )
      )
    :effect (processing_underway ?response_facility)
  )
  (:action complete_processing_step_a
    :parameters (?response_facility - response_facility ?external_expert - external_expert ?sample - sample ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (processing_underway ?response_facility)
        (external_expert_linked ?response_facility ?external_expert)
        (sample_checked_in ?response_facility ?sample)
        (sample_packaged ?sample ?salvage_shipment)
        (not
          (shipment_condition_verified ?salvage_shipment)
        )
        (not
          (shipment_route_verified ?salvage_shipment)
        )
        (not
          (processing_finalized ?response_facility)
        )
      )
    :effect (processing_finalized ?response_facility)
  )
  (:action complete_processing_step_b
    :parameters (?response_facility - response_facility ?external_expert - external_expert ?sample - sample ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (processing_underway ?response_facility)
        (external_expert_linked ?response_facility ?external_expert)
        (sample_checked_in ?response_facility ?sample)
        (sample_packaged ?sample ?salvage_shipment)
        (shipment_condition_verified ?salvage_shipment)
        (not
          (shipment_route_verified ?salvage_shipment)
        )
        (not
          (processing_finalized ?response_facility)
        )
      )
    :effect
      (and
        (processing_finalized ?response_facility)
        (special_processing_required ?response_facility)
      )
  )
  (:action complete_processing_step_c
    :parameters (?response_facility - response_facility ?external_expert - external_expert ?sample - sample ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (processing_underway ?response_facility)
        (external_expert_linked ?response_facility ?external_expert)
        (sample_checked_in ?response_facility ?sample)
        (sample_packaged ?sample ?salvage_shipment)
        (not
          (shipment_condition_verified ?salvage_shipment)
        )
        (shipment_route_verified ?salvage_shipment)
        (not
          (processing_finalized ?response_facility)
        )
      )
    :effect
      (and
        (processing_finalized ?response_facility)
        (special_processing_required ?response_facility)
      )
  )
  (:action complete_processing_step_d
    :parameters (?response_facility - response_facility ?external_expert - external_expert ?sample - sample ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (processing_underway ?response_facility)
        (external_expert_linked ?response_facility ?external_expert)
        (sample_checked_in ?response_facility ?sample)
        (sample_packaged ?sample ?salvage_shipment)
        (shipment_condition_verified ?salvage_shipment)
        (shipment_route_verified ?salvage_shipment)
        (not
          (processing_finalized ?response_facility)
        )
      )
    :effect
      (and
        (processing_finalized ?response_facility)
        (special_processing_required ?response_facility)
      )
  )
  (:action issue_provisional_release_clearance
    :parameters (?response_facility - response_facility)
    :precondition
      (and
        (processing_finalized ?response_facility)
        (not
          (special_processing_required ?response_facility)
        )
        (not
          (release_authorized ?response_facility)
        )
      )
    :effect
      (and
        (release_authorized ?response_facility)
        (ready_for_recovery ?response_facility)
      )
  )
  (:action assign_processing_protocol
    :parameters (?response_facility - response_facility ?processing_protocol - processing_protocol)
    :precondition
      (and
        (processing_finalized ?response_facility)
        (special_processing_required ?response_facility)
        (processing_protocol_available ?processing_protocol)
      )
    :effect
      (and
        (processing_protocol_linked ?response_facility ?processing_protocol)
        (not
          (processing_protocol_available ?processing_protocol)
        )
      )
  )
  (:action validate_processing_completion
    :parameters (?response_facility - response_facility ?primary_unit - primary_cold_storage_unit ?secondary_unit - secondary_cold_storage_unit ?operator - operator ?processing_protocol - processing_protocol)
    :precondition
      (and
        (processing_finalized ?response_facility)
        (special_processing_required ?response_facility)
        (processing_protocol_linked ?response_facility ?processing_protocol)
        (facility_has_primary_unit ?response_facility ?primary_unit)
        (facility_has_secondary_unit ?response_facility ?secondary_unit)
        (primary_unit_staged ?primary_unit)
        (secondary_unit_staged ?secondary_unit)
        (operator_assigned_for_sampling ?response_facility ?operator)
        (not
          (processing_validated ?response_facility)
        )
      )
    :effect (processing_validated ?response_facility)
  )
  (:action issue_validated_release_clearance
    :parameters (?response_facility - response_facility)
    :precondition
      (and
        (processing_finalized ?response_facility)
        (processing_validated ?response_facility)
        (not
          (release_authorized ?response_facility)
        )
      )
    :effect
      (and
        (release_authorized ?response_facility)
        (ready_for_recovery ?response_facility)
      )
  )
  (:action record_preliminary_clearance
    :parameters (?response_facility - response_facility ?clearance_token - clearance_token ?operator - operator)
    :precondition
      (and
        (assessed_for_salvage ?response_facility)
        (operator_assigned_for_sampling ?response_facility ?operator)
        (clearance_token_available ?clearance_token)
        (clearance_token_linked ?response_facility ?clearance_token)
        (not
          (preliminary_clearance_recorded ?response_facility)
        )
      )
    :effect
      (and
        (preliminary_clearance_recorded ?response_facility)
        (not
          (clearance_token_available ?clearance_token)
        )
      )
  )
  (:action record_intermediate_clearance
    :parameters (?response_facility - response_facility ?inspector - inspector)
    :precondition
      (and
        (preliminary_clearance_recorded ?response_facility)
        (inspector_assigned_to_asset ?response_facility ?inspector)
        (not
          (intermediate_clearance_recorded ?response_facility)
        )
      )
    :effect (intermediate_clearance_recorded ?response_facility)
  )
  (:action record_final_clearance
    :parameters (?response_facility - response_facility ?external_expert - external_expert)
    :precondition
      (and
        (intermediate_clearance_recorded ?response_facility)
        (external_expert_linked ?response_facility ?external_expert)
        (not
          (final_clearance_recorded ?response_facility)
        )
      )
    :effect (final_clearance_recorded ?response_facility)
  )
  (:action finalize_release_authorization
    :parameters (?response_facility - response_facility)
    :precondition
      (and
        (final_clearance_recorded ?response_facility)
        (not
          (release_authorized ?response_facility)
        )
      )
    :effect
      (and
        (release_authorized ?response_facility)
        (ready_for_recovery ?response_facility)
      )
  )
  (:action stage_primary_unit_for_repair
    :parameters (?primary_unit - primary_cold_storage_unit ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (primary_unit_quarantined ?primary_unit)
        (primary_unit_staged ?primary_unit)
        (shipment_consolidated ?salvage_shipment)
        (shipment_ready ?salvage_shipment)
        (not
          (ready_for_recovery ?primary_unit)
        )
      )
    :effect (ready_for_recovery ?primary_unit)
  )
  (:action stage_secondary_unit_for_repair
    :parameters (?secondary_unit - secondary_cold_storage_unit ?salvage_shipment - salvage_shipment)
    :precondition
      (and
        (secondary_unit_quarantined ?secondary_unit)
        (secondary_unit_staged ?secondary_unit)
        (shipment_consolidated ?salvage_shipment)
        (shipment_ready ?salvage_shipment)
        (not
          (ready_for_recovery ?secondary_unit)
        )
      )
    :effect (ready_for_recovery ?secondary_unit)
  )
  (:action attach_repair_order_to_lot
    :parameters (?lot_record - lot_record ?repair_order - repair_order ?operator - operator)
    :precondition
      (and
        (ready_for_recovery ?lot_record)
        (operator_assigned_for_sampling ?lot_record ?operator)
        (repair_order_available ?repair_order)
        (not
          (ready_for_repair ?lot_record)
        )
      )
    :effect
      (and
        (ready_for_repair ?lot_record)
        (repair_order_linked_to_asset ?lot_record ?repair_order)
        (not
          (repair_order_available ?repair_order)
        )
      )
  )
  (:action restore_primary_unit_and_release_resource
    :parameters (?primary_unit - primary_cold_storage_unit ?mobile_resource - mobile_resource ?repair_order - repair_order)
    :precondition
      (and
        (ready_for_repair ?primary_unit)
        (resource_allocated_to_asset ?primary_unit ?mobile_resource)
        (repair_order_linked_to_asset ?primary_unit ?repair_order)
        (not
          (asset_restored_to_service ?primary_unit)
        )
      )
    :effect
      (and
        (asset_restored_to_service ?primary_unit)
        (mobile_resource_available ?mobile_resource)
        (repair_order_available ?repair_order)
      )
  )
  (:action restore_secondary_unit_and_release_resource
    :parameters (?secondary_unit - secondary_cold_storage_unit ?mobile_resource - mobile_resource ?repair_order - repair_order)
    :precondition
      (and
        (ready_for_repair ?secondary_unit)
        (resource_allocated_to_asset ?secondary_unit ?mobile_resource)
        (repair_order_linked_to_asset ?secondary_unit ?repair_order)
        (not
          (asset_restored_to_service ?secondary_unit)
        )
      )
    :effect
      (and
        (asset_restored_to_service ?secondary_unit)
        (mobile_resource_available ?mobile_resource)
        (repair_order_available ?repair_order)
      )
  )
  (:action restore_facility_and_release_resource
    :parameters (?response_facility - response_facility ?mobile_resource - mobile_resource ?repair_order - repair_order)
    :precondition
      (and
        (ready_for_repair ?response_facility)
        (resource_allocated_to_asset ?response_facility ?mobile_resource)
        (repair_order_linked_to_asset ?response_facility ?repair_order)
        (not
          (asset_restored_to_service ?response_facility)
        )
      )
    :effect
      (and
        (asset_restored_to_service ?response_facility)
        (mobile_resource_available ?mobile_resource)
        (repair_order_available ?repair_order)
      )
  )
)

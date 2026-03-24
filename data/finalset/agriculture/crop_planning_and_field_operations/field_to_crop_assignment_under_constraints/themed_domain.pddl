(define (domain field_to_crop_assignment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types farm_entity_category - object temporal_sequence_type - object logistics_quality_type - object field_top_type - object field_parcel - field_top_type crop_variety - farm_entity_category planting_window - farm_entity_category equipment - farm_entity_category contract_specification - farm_entity_category market_destination - farm_entity_category production_season - farm_entity_category primary_product - farm_entity_category regulatory_permit - farm_entity_category agricultural_input_batch - temporal_sequence_type material_lot - temporal_sequence_type contract_identifier - temporal_sequence_type irrigation_window - logistics_quality_type harvest_window - logistics_quality_type operation_batch - logistics_quality_type field_subdivision_type - field_parcel field_subdivision_variant - field_parcel irrigation_subunit - field_subdivision_type harvest_subunit - field_subdivision_type work_order - field_subdivision_variant)
  (:predicates
    (field_enrolled ?field_parcel - field_parcel)
    (work_unit_active ?field_parcel - field_parcel)
    (crop_variety_reserved ?field_parcel - field_parcel)
    (work_unit_assignment_confirmed ?field_parcel - field_parcel)
    (work_unit_operation_executed ?field_parcel - field_parcel)
    (work_unit_season_assigned ?field_parcel - field_parcel)
    (crop_variety_available ?crop_variety - crop_variety)
    (field_has_variety ?field_parcel - field_parcel ?crop_variety - crop_variety)
    (planting_window_available ?planting_window - planting_window)
    (field_planting_window_reserved ?field_parcel - field_parcel ?planting_window - planting_window)
    (equipment_available ?equipment - equipment)
    (work_unit_equipment_assigned ?field_parcel - field_parcel ?equipment - equipment)
    (input_batch_available ?agricultural_input_batch - agricultural_input_batch)
    (irrigation_input_assigned ?irrigation_subunit - irrigation_subunit ?agricultural_input_batch - agricultural_input_batch)
    (harvest_input_assigned ?harvest_subunit - harvest_subunit ?agricultural_input_batch - agricultural_input_batch)
    (irrigation_window_assigned_to_subunit ?irrigation_subunit - irrigation_subunit ?irrigation_window - irrigation_window)
    (irrigation_window_reserved ?irrigation_window - irrigation_window)
    (irrigation_window_prepared ?irrigation_window - irrigation_window)
    (irrigation_operation_completed ?irrigation_subunit - irrigation_subunit)
    (harvest_window_assigned_to_subunit ?harvest_subunit - harvest_subunit ?harvest_window - harvest_window)
    (harvest_window_reserved ?harvest_window - harvest_window)
    (harvest_window_prepared ?harvest_window - harvest_window)
    (harvest_operation_completed ?harvest_subunit - harvest_subunit)
    (operation_batch_available ?operation_batch - operation_batch)
    (operation_batch_prepared ?operation_batch - operation_batch)
    (operation_batch_has_irrigation_window ?operation_batch - operation_batch ?irrigation_window - irrigation_window)
    (operation_batch_has_harvest_window ?operation_batch - operation_batch ?harvest_window - harvest_window)
    (operation_batch_has_pending_irrigation ?operation_batch - operation_batch)
    (operation_batch_has_pending_harvest ?operation_batch - operation_batch)
    (operation_batch_validated ?operation_batch - operation_batch)
    (work_order_has_irrigation_subunit ?work_order - work_order ?irrigation_subunit - irrigation_subunit)
    (work_order_has_harvest_subunit ?work_order - work_order ?harvest_subunit - harvest_subunit)
    (work_order_includes_operation_batch ?work_order - work_order ?operation_batch - operation_batch)
    (material_lot_available ?material_lot - material_lot)
    (work_order_material_lot_assigned ?work_order - work_order ?material_lot - material_lot)
    (material_lot_reserved ?material_lot - material_lot)
    (material_lot_assigned_to_batch ?material_lot - material_lot ?operation_batch - operation_batch)
    (work_order_ready_for_integration ?work_order - work_order)
    (work_order_integration_started ?work_order - work_order)
    (work_order_product_requirements_met ?work_order - work_order)
    (work_order_has_contract_specification ?work_order - work_order)
    (work_order_contract_integration_recorded ?work_order - work_order)
    (work_order_product_attached ?work_order - work_order)
    (work_order_final_checks_passed ?work_order - work_order)
    (contract_identifier_available ?contract_identifier - contract_identifier)
    (work_order_has_contract_identifier ?work_order - work_order ?contract_identifier - contract_identifier)
    (work_order_contract_identifier_assigned ?work_order - work_order)
    (work_order_certification_in_progress ?work_order - work_order)
    (work_order_certification_completed ?work_order - work_order)
    (contract_specification_available ?contract_specification - contract_specification)
    (work_order_contract_spec_assigned ?work_order - work_order ?contract_specification - contract_specification)
    (market_destination_available ?market_destination - market_destination)
    (work_order_market_destination_assigned ?work_order - work_order ?market_destination - market_destination)
    (primary_product_available ?primary_product - primary_product)
    (work_order_primary_product_assigned ?work_order - work_order ?primary_product - primary_product)
    (regulatory_permit_available ?regulatory_permit - regulatory_permit)
    (work_order_permit_attached ?work_order - work_order ?regulatory_permit - regulatory_permit)
    (production_season_available ?production_season - production_season)
    (field_assigned_to_season ?field_parcel - field_parcel ?production_season - production_season)
    (irrigation_subunit_ready ?irrigation_subunit - irrigation_subunit)
    (harvest_subunit_ready ?harvest_subunit - harvest_subunit)
    (work_order_finalized ?work_order - work_order)
  )
  (:action enroll_field_parcel
    :parameters (?field_parcel - field_parcel)
    :precondition
      (and
        (not
          (field_enrolled ?field_parcel)
        )
        (not
          (work_unit_assignment_confirmed ?field_parcel)
        )
      )
    :effect (field_enrolled ?field_parcel)
  )
  (:action reserve_crop_variety_for_field
    :parameters (?field_parcel - field_parcel ?crop_variety - crop_variety)
    :precondition
      (and
        (field_enrolled ?field_parcel)
        (not
          (crop_variety_reserved ?field_parcel)
        )
        (crop_variety_available ?crop_variety)
      )
    :effect
      (and
        (crop_variety_reserved ?field_parcel)
        (field_has_variety ?field_parcel ?crop_variety)
        (not
          (crop_variety_available ?crop_variety)
        )
      )
  )
  (:action assign_planting_window_to_field
    :parameters (?field_parcel - field_parcel ?planting_window - planting_window)
    :precondition
      (and
        (field_enrolled ?field_parcel)
        (crop_variety_reserved ?field_parcel)
        (planting_window_available ?planting_window)
      )
    :effect
      (and
        (field_planting_window_reserved ?field_parcel ?planting_window)
        (not
          (planting_window_available ?planting_window)
        )
      )
  )
  (:action confirm_field_planting
    :parameters (?field_parcel - field_parcel ?planting_window - planting_window)
    :precondition
      (and
        (field_enrolled ?field_parcel)
        (crop_variety_reserved ?field_parcel)
        (field_planting_window_reserved ?field_parcel ?planting_window)
        (not
          (work_unit_active ?field_parcel)
        )
      )
    :effect (work_unit_active ?field_parcel)
  )
  (:action release_planting_window_reservation
    :parameters (?field_parcel - field_parcel ?planting_window - planting_window)
    :precondition
      (and
        (field_planting_window_reserved ?field_parcel ?planting_window)
      )
    :effect
      (and
        (planting_window_available ?planting_window)
        (not
          (field_planting_window_reserved ?field_parcel ?planting_window)
        )
      )
  )
  (:action assign_equipment_to_work_order
    :parameters (?field_parcel - field_parcel ?equipment - equipment)
    :precondition
      (and
        (work_unit_active ?field_parcel)
        (equipment_available ?equipment)
      )
    :effect
      (and
        (work_unit_equipment_assigned ?field_parcel ?equipment)
        (not
          (equipment_available ?equipment)
        )
      )
  )
  (:action release_equipment_from_work_order
    :parameters (?field_parcel - field_parcel ?equipment - equipment)
    :precondition
      (and
        (work_unit_equipment_assigned ?field_parcel ?equipment)
      )
    :effect
      (and
        (equipment_available ?equipment)
        (not
          (work_unit_equipment_assigned ?field_parcel ?equipment)
        )
      )
  )
  (:action attach_primary_product_to_work_order
    :parameters (?work_order - work_order ?primary_product - primary_product)
    :precondition
      (and
        (work_unit_active ?work_order)
        (primary_product_available ?primary_product)
      )
    :effect
      (and
        (work_order_primary_product_assigned ?work_order ?primary_product)
        (not
          (primary_product_available ?primary_product)
        )
      )
  )
  (:action detach_primary_product_from_work_order
    :parameters (?work_order - work_order ?primary_product - primary_product)
    :precondition
      (and
        (work_order_primary_product_assigned ?work_order ?primary_product)
      )
    :effect
      (and
        (primary_product_available ?primary_product)
        (not
          (work_order_primary_product_assigned ?work_order ?primary_product)
        )
      )
  )
  (:action attach_regulatory_permit_to_work_order
    :parameters (?work_order - work_order ?regulatory_permit - regulatory_permit)
    :precondition
      (and
        (work_unit_active ?work_order)
        (regulatory_permit_available ?regulatory_permit)
      )
    :effect
      (and
        (work_order_permit_attached ?work_order ?regulatory_permit)
        (not
          (regulatory_permit_available ?regulatory_permit)
        )
      )
  )
  (:action detach_regulatory_permit_from_work_order
    :parameters (?work_order - work_order ?regulatory_permit - regulatory_permit)
    :precondition
      (and
        (work_order_permit_attached ?work_order ?regulatory_permit)
      )
    :effect
      (and
        (regulatory_permit_available ?regulatory_permit)
        (not
          (work_order_permit_attached ?work_order ?regulatory_permit)
        )
      )
  )
  (:action reserve_irrigation_window_for_subunit
    :parameters (?irrigation_subunit - irrigation_subunit ?irrigation_window - irrigation_window ?planting_window - planting_window)
    :precondition
      (and
        (work_unit_active ?irrigation_subunit)
        (field_planting_window_reserved ?irrigation_subunit ?planting_window)
        (irrigation_window_assigned_to_subunit ?irrigation_subunit ?irrigation_window)
        (not
          (irrigation_window_reserved ?irrigation_window)
        )
        (not
          (irrigation_window_prepared ?irrigation_window)
        )
      )
    :effect (irrigation_window_reserved ?irrigation_window)
  )
  (:action perform_irrigation_operation
    :parameters (?irrigation_subunit - irrigation_subunit ?irrigation_window - irrigation_window ?equipment - equipment)
    :precondition
      (and
        (work_unit_active ?irrigation_subunit)
        (work_unit_equipment_assigned ?irrigation_subunit ?equipment)
        (irrigation_window_assigned_to_subunit ?irrigation_subunit ?irrigation_window)
        (irrigation_window_reserved ?irrigation_window)
        (not
          (irrigation_subunit_ready ?irrigation_subunit)
        )
      )
    :effect
      (and
        (irrigation_subunit_ready ?irrigation_subunit)
        (irrigation_operation_completed ?irrigation_subunit)
      )
  )
  (:action prepare_irrigation_with_input_batch
    :parameters (?irrigation_subunit - irrigation_subunit ?irrigation_window - irrigation_window ?agricultural_input_batch - agricultural_input_batch)
    :precondition
      (and
        (work_unit_active ?irrigation_subunit)
        (irrigation_window_assigned_to_subunit ?irrigation_subunit ?irrigation_window)
        (input_batch_available ?agricultural_input_batch)
        (not
          (irrigation_subunit_ready ?irrigation_subunit)
        )
      )
    :effect
      (and
        (irrigation_window_prepared ?irrigation_window)
        (irrigation_subunit_ready ?irrigation_subunit)
        (irrigation_input_assigned ?irrigation_subunit ?agricultural_input_batch)
        (not
          (input_batch_available ?agricultural_input_batch)
        )
      )
  )
  (:action execute_irrigation_with_input_batch
    :parameters (?irrigation_subunit - irrigation_subunit ?irrigation_window - irrigation_window ?planting_window - planting_window ?agricultural_input_batch - agricultural_input_batch)
    :precondition
      (and
        (work_unit_active ?irrigation_subunit)
        (field_planting_window_reserved ?irrigation_subunit ?planting_window)
        (irrigation_window_assigned_to_subunit ?irrigation_subunit ?irrigation_window)
        (irrigation_window_prepared ?irrigation_window)
        (irrigation_input_assigned ?irrigation_subunit ?agricultural_input_batch)
        (not
          (irrigation_operation_completed ?irrigation_subunit)
        )
      )
    :effect
      (and
        (irrigation_window_reserved ?irrigation_window)
        (irrigation_operation_completed ?irrigation_subunit)
        (input_batch_available ?agricultural_input_batch)
        (not
          (irrigation_input_assigned ?irrigation_subunit ?agricultural_input_batch)
        )
      )
  )
  (:action reserve_harvest_window_for_subunit
    :parameters (?harvest_subunit - harvest_subunit ?harvest_window - harvest_window ?planting_window - planting_window)
    :precondition
      (and
        (work_unit_active ?harvest_subunit)
        (field_planting_window_reserved ?harvest_subunit ?planting_window)
        (harvest_window_assigned_to_subunit ?harvest_subunit ?harvest_window)
        (not
          (harvest_window_reserved ?harvest_window)
        )
        (not
          (harvest_window_prepared ?harvest_window)
        )
      )
    :effect (harvest_window_reserved ?harvest_window)
  )
  (:action assign_equipment_for_harvest
    :parameters (?harvest_subunit - harvest_subunit ?harvest_window - harvest_window ?equipment - equipment)
    :precondition
      (and
        (work_unit_active ?harvest_subunit)
        (work_unit_equipment_assigned ?harvest_subunit ?equipment)
        (harvest_window_assigned_to_subunit ?harvest_subunit ?harvest_window)
        (harvest_window_reserved ?harvest_window)
        (not
          (harvest_subunit_ready ?harvest_subunit)
        )
      )
    :effect
      (and
        (harvest_subunit_ready ?harvest_subunit)
        (harvest_operation_completed ?harvest_subunit)
      )
  )
  (:action prepare_harvest_with_input_batch
    :parameters (?harvest_subunit - harvest_subunit ?harvest_window - harvest_window ?agricultural_input_batch - agricultural_input_batch)
    :precondition
      (and
        (work_unit_active ?harvest_subunit)
        (harvest_window_assigned_to_subunit ?harvest_subunit ?harvest_window)
        (input_batch_available ?agricultural_input_batch)
        (not
          (harvest_subunit_ready ?harvest_subunit)
        )
      )
    :effect
      (and
        (harvest_window_prepared ?harvest_window)
        (harvest_subunit_ready ?harvest_subunit)
        (harvest_input_assigned ?harvest_subunit ?agricultural_input_batch)
        (not
          (input_batch_available ?agricultural_input_batch)
        )
      )
  )
  (:action execute_harvest_with_input_batch
    :parameters (?harvest_subunit - harvest_subunit ?harvest_window - harvest_window ?planting_window - planting_window ?agricultural_input_batch - agricultural_input_batch)
    :precondition
      (and
        (work_unit_active ?harvest_subunit)
        (field_planting_window_reserved ?harvest_subunit ?planting_window)
        (harvest_window_assigned_to_subunit ?harvest_subunit ?harvest_window)
        (harvest_window_prepared ?harvest_window)
        (harvest_input_assigned ?harvest_subunit ?agricultural_input_batch)
        (not
          (harvest_operation_completed ?harvest_subunit)
        )
      )
    :effect
      (and
        (harvest_window_reserved ?harvest_window)
        (harvest_operation_completed ?harvest_subunit)
        (input_batch_available ?agricultural_input_batch)
        (not
          (harvest_input_assigned ?harvest_subunit ?agricultural_input_batch)
        )
      )
  )
  (:action create_operation_batch_from_executed_subunits
    :parameters (?irrigation_subunit - irrigation_subunit ?harvest_subunit - harvest_subunit ?irrigation_window - irrigation_window ?harvest_window - harvest_window ?operation_batch - operation_batch)
    :precondition
      (and
        (irrigation_subunit_ready ?irrigation_subunit)
        (harvest_subunit_ready ?harvest_subunit)
        (irrigation_window_assigned_to_subunit ?irrigation_subunit ?irrigation_window)
        (harvest_window_assigned_to_subunit ?harvest_subunit ?harvest_window)
        (irrigation_window_reserved ?irrigation_window)
        (harvest_window_reserved ?harvest_window)
        (irrigation_operation_completed ?irrigation_subunit)
        (harvest_operation_completed ?harvest_subunit)
        (operation_batch_available ?operation_batch)
      )
    :effect
      (and
        (operation_batch_prepared ?operation_batch)
        (operation_batch_has_irrigation_window ?operation_batch ?irrigation_window)
        (operation_batch_has_harvest_window ?operation_batch ?harvest_window)
        (not
          (operation_batch_available ?operation_batch)
        )
      )
  )
  (:action create_operation_batch_with_prepared_irrigation
    :parameters (?irrigation_subunit - irrigation_subunit ?harvest_subunit - harvest_subunit ?irrigation_window - irrigation_window ?harvest_window - harvest_window ?operation_batch - operation_batch)
    :precondition
      (and
        (irrigation_subunit_ready ?irrigation_subunit)
        (harvest_subunit_ready ?harvest_subunit)
        (irrigation_window_assigned_to_subunit ?irrigation_subunit ?irrigation_window)
        (harvest_window_assigned_to_subunit ?harvest_subunit ?harvest_window)
        (irrigation_window_prepared ?irrigation_window)
        (harvest_window_reserved ?harvest_window)
        (not
          (irrigation_operation_completed ?irrigation_subunit)
        )
        (harvest_operation_completed ?harvest_subunit)
        (operation_batch_available ?operation_batch)
      )
    :effect
      (and
        (operation_batch_prepared ?operation_batch)
        (operation_batch_has_irrigation_window ?operation_batch ?irrigation_window)
        (operation_batch_has_harvest_window ?operation_batch ?harvest_window)
        (operation_batch_has_pending_irrigation ?operation_batch)
        (not
          (operation_batch_available ?operation_batch)
        )
      )
  )
  (:action create_operation_batch_with_prepared_harvest
    :parameters (?irrigation_subunit - irrigation_subunit ?harvest_subunit - harvest_subunit ?irrigation_window - irrigation_window ?harvest_window - harvest_window ?operation_batch - operation_batch)
    :precondition
      (and
        (irrigation_subunit_ready ?irrigation_subunit)
        (harvest_subunit_ready ?harvest_subunit)
        (irrigation_window_assigned_to_subunit ?irrigation_subunit ?irrigation_window)
        (harvest_window_assigned_to_subunit ?harvest_subunit ?harvest_window)
        (irrigation_window_reserved ?irrigation_window)
        (harvest_window_prepared ?harvest_window)
        (irrigation_operation_completed ?irrigation_subunit)
        (not
          (harvest_operation_completed ?harvest_subunit)
        )
        (operation_batch_available ?operation_batch)
      )
    :effect
      (and
        (operation_batch_prepared ?operation_batch)
        (operation_batch_has_irrigation_window ?operation_batch ?irrigation_window)
        (operation_batch_has_harvest_window ?operation_batch ?harvest_window)
        (operation_batch_has_pending_harvest ?operation_batch)
        (not
          (operation_batch_available ?operation_batch)
        )
      )
  )
  (:action create_operation_batch_with_both_prepared
    :parameters (?irrigation_subunit - irrigation_subunit ?harvest_subunit - harvest_subunit ?irrigation_window - irrigation_window ?harvest_window - harvest_window ?operation_batch - operation_batch)
    :precondition
      (and
        (irrigation_subunit_ready ?irrigation_subunit)
        (harvest_subunit_ready ?harvest_subunit)
        (irrigation_window_assigned_to_subunit ?irrigation_subunit ?irrigation_window)
        (harvest_window_assigned_to_subunit ?harvest_subunit ?harvest_window)
        (irrigation_window_prepared ?irrigation_window)
        (harvest_window_prepared ?harvest_window)
        (not
          (irrigation_operation_completed ?irrigation_subunit)
        )
        (not
          (harvest_operation_completed ?harvest_subunit)
        )
        (operation_batch_available ?operation_batch)
      )
    :effect
      (and
        (operation_batch_prepared ?operation_batch)
        (operation_batch_has_irrigation_window ?operation_batch ?irrigation_window)
        (operation_batch_has_harvest_window ?operation_batch ?harvest_window)
        (operation_batch_has_pending_irrigation ?operation_batch)
        (operation_batch_has_pending_harvest ?operation_batch)
        (not
          (operation_batch_available ?operation_batch)
        )
      )
  )
  (:action validate_operation_batch
    :parameters (?operation_batch - operation_batch ?irrigation_subunit - irrigation_subunit ?planting_window - planting_window)
    :precondition
      (and
        (operation_batch_prepared ?operation_batch)
        (irrigation_subunit_ready ?irrigation_subunit)
        (field_planting_window_reserved ?irrigation_subunit ?planting_window)
        (not
          (operation_batch_validated ?operation_batch)
        )
      )
    :effect (operation_batch_validated ?operation_batch)
  )
  (:action assign_material_lot_to_batch
    :parameters (?work_order - work_order ?material_lot - material_lot ?operation_batch - operation_batch)
    :precondition
      (and
        (work_unit_active ?work_order)
        (work_order_includes_operation_batch ?work_order ?operation_batch)
        (work_order_material_lot_assigned ?work_order ?material_lot)
        (material_lot_available ?material_lot)
        (operation_batch_prepared ?operation_batch)
        (operation_batch_validated ?operation_batch)
        (not
          (material_lot_reserved ?material_lot)
        )
      )
    :effect
      (and
        (material_lot_reserved ?material_lot)
        (material_lot_assigned_to_batch ?material_lot ?operation_batch)
        (not
          (material_lot_available ?material_lot)
        )
      )
  )
  (:action mark_work_order_ready_for_integration
    :parameters (?work_order - work_order ?material_lot - material_lot ?operation_batch - operation_batch ?planting_window - planting_window)
    :precondition
      (and
        (work_unit_active ?work_order)
        (work_order_material_lot_assigned ?work_order ?material_lot)
        (material_lot_reserved ?material_lot)
        (material_lot_assigned_to_batch ?material_lot ?operation_batch)
        (field_planting_window_reserved ?work_order ?planting_window)
        (not
          (operation_batch_has_pending_irrigation ?operation_batch)
        )
        (not
          (work_order_ready_for_integration ?work_order)
        )
      )
    :effect (work_order_ready_for_integration ?work_order)
  )
  (:action apply_contract_specification_to_work_order
    :parameters (?work_order - work_order ?contract_specification - contract_specification)
    :precondition
      (and
        (work_unit_active ?work_order)
        (contract_specification_available ?contract_specification)
        (not
          (work_order_has_contract_specification ?work_order)
        )
      )
    :effect
      (and
        (work_order_has_contract_specification ?work_order)
        (work_order_contract_spec_assigned ?work_order ?contract_specification)
        (not
          (contract_specification_available ?contract_specification)
        )
      )
  )
  (:action integrate_contract_attributes_into_work_order
    :parameters (?work_order - work_order ?material_lot - material_lot ?operation_batch - operation_batch ?planting_window - planting_window ?contract_specification - contract_specification)
    :precondition
      (and
        (work_unit_active ?work_order)
        (work_order_material_lot_assigned ?work_order ?material_lot)
        (material_lot_reserved ?material_lot)
        (material_lot_assigned_to_batch ?material_lot ?operation_batch)
        (field_planting_window_reserved ?work_order ?planting_window)
        (operation_batch_has_pending_irrigation ?operation_batch)
        (work_order_has_contract_specification ?work_order)
        (work_order_contract_spec_assigned ?work_order ?contract_specification)
        (not
          (work_order_ready_for_integration ?work_order)
        )
      )
    :effect
      (and
        (work_order_ready_for_integration ?work_order)
        (work_order_contract_integration_recorded ?work_order)
      )
  )
  (:action start_product_integration_for_work_order
    :parameters (?work_order - work_order ?primary_product - primary_product ?equipment - equipment ?material_lot - material_lot ?operation_batch - operation_batch)
    :precondition
      (and
        (work_order_ready_for_integration ?work_order)
        (work_order_primary_product_assigned ?work_order ?primary_product)
        (work_unit_equipment_assigned ?work_order ?equipment)
        (work_order_material_lot_assigned ?work_order ?material_lot)
        (material_lot_assigned_to_batch ?material_lot ?operation_batch)
        (not
          (operation_batch_has_pending_harvest ?operation_batch)
        )
        (not
          (work_order_integration_started ?work_order)
        )
      )
    :effect (work_order_integration_started ?work_order)
  )
  (:action continue_product_integration_for_work_order
    :parameters (?work_order - work_order ?primary_product - primary_product ?equipment - equipment ?material_lot - material_lot ?operation_batch - operation_batch)
    :precondition
      (and
        (work_order_ready_for_integration ?work_order)
        (work_order_primary_product_assigned ?work_order ?primary_product)
        (work_unit_equipment_assigned ?work_order ?equipment)
        (work_order_material_lot_assigned ?work_order ?material_lot)
        (material_lot_assigned_to_batch ?material_lot ?operation_batch)
        (operation_batch_has_pending_harvest ?operation_batch)
        (not
          (work_order_integration_started ?work_order)
        )
      )
    :effect (work_order_integration_started ?work_order)
  )
  (:action apply_permit_to_work_order
    :parameters (?work_order - work_order ?regulatory_permit - regulatory_permit ?material_lot - material_lot ?operation_batch - operation_batch)
    :precondition
      (and
        (work_order_integration_started ?work_order)
        (work_order_permit_attached ?work_order ?regulatory_permit)
        (work_order_material_lot_assigned ?work_order ?material_lot)
        (material_lot_assigned_to_batch ?material_lot ?operation_batch)
        (not
          (operation_batch_has_pending_irrigation ?operation_batch)
        )
        (not
          (operation_batch_has_pending_harvest ?operation_batch)
        )
        (not
          (work_order_product_requirements_met ?work_order)
        )
      )
    :effect (work_order_product_requirements_met ?work_order)
  )
  (:action apply_permit_and_stage_product_attachment
    :parameters (?work_order - work_order ?regulatory_permit - regulatory_permit ?material_lot - material_lot ?operation_batch - operation_batch)
    :precondition
      (and
        (work_order_integration_started ?work_order)
        (work_order_permit_attached ?work_order ?regulatory_permit)
        (work_order_material_lot_assigned ?work_order ?material_lot)
        (material_lot_assigned_to_batch ?material_lot ?operation_batch)
        (operation_batch_has_pending_irrigation ?operation_batch)
        (not
          (operation_batch_has_pending_harvest ?operation_batch)
        )
        (not
          (work_order_product_requirements_met ?work_order)
        )
      )
    :effect
      (and
        (work_order_product_requirements_met ?work_order)
        (work_order_product_attached ?work_order)
      )
  )
  (:action apply_permit_and_stage_product_attachment_variant
    :parameters (?work_order - work_order ?regulatory_permit - regulatory_permit ?material_lot - material_lot ?operation_batch - operation_batch)
    :precondition
      (and
        (work_order_integration_started ?work_order)
        (work_order_permit_attached ?work_order ?regulatory_permit)
        (work_order_material_lot_assigned ?work_order ?material_lot)
        (material_lot_assigned_to_batch ?material_lot ?operation_batch)
        (not
          (operation_batch_has_pending_irrigation ?operation_batch)
        )
        (operation_batch_has_pending_harvest ?operation_batch)
        (not
          (work_order_product_requirements_met ?work_order)
        )
      )
    :effect
      (and
        (work_order_product_requirements_met ?work_order)
        (work_order_product_attached ?work_order)
      )
  )
  (:action apply_permit_and_stage_product_attachment_full
    :parameters (?work_order - work_order ?regulatory_permit - regulatory_permit ?material_lot - material_lot ?operation_batch - operation_batch)
    :precondition
      (and
        (work_order_integration_started ?work_order)
        (work_order_permit_attached ?work_order ?regulatory_permit)
        (work_order_material_lot_assigned ?work_order ?material_lot)
        (material_lot_assigned_to_batch ?material_lot ?operation_batch)
        (operation_batch_has_pending_irrigation ?operation_batch)
        (operation_batch_has_pending_harvest ?operation_batch)
        (not
          (work_order_product_requirements_met ?work_order)
        )
      )
    :effect
      (and
        (work_order_product_requirements_met ?work_order)
        (work_order_product_attached ?work_order)
      )
  )
  (:action finalize_work_order_and_mark_executed
    :parameters (?work_order - work_order)
    :precondition
      (and
        (work_order_product_requirements_met ?work_order)
        (not
          (work_order_product_attached ?work_order)
        )
        (not
          (work_order_finalized ?work_order)
        )
      )
    :effect
      (and
        (work_order_finalized ?work_order)
        (work_unit_operation_executed ?work_order)
      )
  )
  (:action assign_market_destination_to_work_order
    :parameters (?work_order - work_order ?market_destination - market_destination)
    :precondition
      (and
        (work_order_product_requirements_met ?work_order)
        (work_order_product_attached ?work_order)
        (market_destination_available ?market_destination)
      )
    :effect
      (and
        (work_order_market_destination_assigned ?work_order ?market_destination)
        (not
          (market_destination_available ?market_destination)
        )
      )
  )
  (:action perform_final_checks_for_work_order
    :parameters (?work_order - work_order ?irrigation_subunit - irrigation_subunit ?harvest_subunit - harvest_subunit ?planting_window - planting_window ?market_destination - market_destination)
    :precondition
      (and
        (work_order_product_requirements_met ?work_order)
        (work_order_product_attached ?work_order)
        (work_order_market_destination_assigned ?work_order ?market_destination)
        (work_order_has_irrigation_subunit ?work_order ?irrigation_subunit)
        (work_order_has_harvest_subunit ?work_order ?harvest_subunit)
        (irrigation_operation_completed ?irrigation_subunit)
        (harvest_operation_completed ?harvest_subunit)
        (field_planting_window_reserved ?work_order ?planting_window)
        (not
          (work_order_final_checks_passed ?work_order)
        )
      )
    :effect (work_order_final_checks_passed ?work_order)
  )
  (:action close_work_order_and_record_execution
    :parameters (?work_order - work_order)
    :precondition
      (and
        (work_order_product_requirements_met ?work_order)
        (work_order_final_checks_passed ?work_order)
        (not
          (work_order_finalized ?work_order)
        )
      )
    :effect
      (and
        (work_order_finalized ?work_order)
        (work_unit_operation_executed ?work_order)
      )
  )
  (:action assign_contract_identifier_to_work_order
    :parameters (?work_order - work_order ?contract_identifier - contract_identifier ?planting_window - planting_window)
    :precondition
      (and
        (work_unit_active ?work_order)
        (field_planting_window_reserved ?work_order ?planting_window)
        (contract_identifier_available ?contract_identifier)
        (work_order_has_contract_identifier ?work_order ?contract_identifier)
        (not
          (work_order_contract_identifier_assigned ?work_order)
        )
      )
    :effect
      (and
        (work_order_contract_identifier_assigned ?work_order)
        (not
          (contract_identifier_available ?contract_identifier)
        )
      )
  )
  (:action start_certification_process_for_work_order
    :parameters (?work_order - work_order ?equipment - equipment)
    :precondition
      (and
        (work_order_contract_identifier_assigned ?work_order)
        (work_unit_equipment_assigned ?work_order ?equipment)
        (not
          (work_order_certification_in_progress ?work_order)
        )
      )
    :effect (work_order_certification_in_progress ?work_order)
  )
  (:action complete_certification_with_permit
    :parameters (?work_order - work_order ?regulatory_permit - regulatory_permit)
    :precondition
      (and
        (work_order_certification_in_progress ?work_order)
        (work_order_permit_attached ?work_order ?regulatory_permit)
        (not
          (work_order_certification_completed ?work_order)
        )
      )
    :effect (work_order_certification_completed ?work_order)
  )
  (:action finalize_certified_work_order_and_mark_executed
    :parameters (?work_order - work_order)
    :precondition
      (and
        (work_order_certification_completed ?work_order)
        (not
          (work_order_finalized ?work_order)
        )
      )
    :effect
      (and
        (work_order_finalized ?work_order)
        (work_unit_operation_executed ?work_order)
      )
  )
  (:action operator_execute_irrigation_subunit
    :parameters (?irrigation_subunit - irrigation_subunit ?operation_batch - operation_batch)
    :precondition
      (and
        (irrigation_subunit_ready ?irrigation_subunit)
        (irrigation_operation_completed ?irrigation_subunit)
        (operation_batch_prepared ?operation_batch)
        (operation_batch_validated ?operation_batch)
        (not
          (work_unit_operation_executed ?irrigation_subunit)
        )
      )
    :effect (work_unit_operation_executed ?irrigation_subunit)
  )
  (:action operator_execute_harvest_subunit
    :parameters (?harvest_subunit - harvest_subunit ?operation_batch - operation_batch)
    :precondition
      (and
        (harvest_subunit_ready ?harvest_subunit)
        (harvest_operation_completed ?harvest_subunit)
        (operation_batch_prepared ?operation_batch)
        (operation_batch_validated ?operation_batch)
        (not
          (work_unit_operation_executed ?harvest_subunit)
        )
      )
    :effect (work_unit_operation_executed ?harvest_subunit)
  )
  (:action assign_field_to_production_season
    :parameters (?field_parcel - field_parcel ?production_season - production_season ?planting_window - planting_window)
    :precondition
      (and
        (work_unit_operation_executed ?field_parcel)
        (field_planting_window_reserved ?field_parcel ?planting_window)
        (production_season_available ?production_season)
        (not
          (work_unit_season_assigned ?field_parcel)
        )
      )
    :effect
      (and
        (work_unit_season_assigned ?field_parcel)
        (field_assigned_to_season ?field_parcel ?production_season)
        (not
          (production_season_available ?production_season)
        )
      )
  )
  (:action finalize_irrigation_subunit_crop_assignment
    :parameters (?irrigation_subunit - irrigation_subunit ?crop_variety - crop_variety ?production_season - production_season)
    :precondition
      (and
        (work_unit_season_assigned ?irrigation_subunit)
        (field_has_variety ?irrigation_subunit ?crop_variety)
        (field_assigned_to_season ?irrigation_subunit ?production_season)
        (not
          (work_unit_assignment_confirmed ?irrigation_subunit)
        )
      )
    :effect
      (and
        (work_unit_assignment_confirmed ?irrigation_subunit)
        (crop_variety_available ?crop_variety)
        (production_season_available ?production_season)
      )
  )
  (:action finalize_harvest_subunit_crop_assignment
    :parameters (?harvest_subunit - harvest_subunit ?crop_variety - crop_variety ?production_season - production_season)
    :precondition
      (and
        (work_unit_season_assigned ?harvest_subunit)
        (field_has_variety ?harvest_subunit ?crop_variety)
        (field_assigned_to_season ?harvest_subunit ?production_season)
        (not
          (work_unit_assignment_confirmed ?harvest_subunit)
        )
      )
    :effect
      (and
        (work_unit_assignment_confirmed ?harvest_subunit)
        (crop_variety_available ?crop_variety)
        (production_season_available ?production_season)
      )
  )
  (:action finalize_work_order_crop_and_season_assignment
    :parameters (?work_order - work_order ?crop_variety - crop_variety ?production_season - production_season)
    :precondition
      (and
        (work_unit_season_assigned ?work_order)
        (field_has_variety ?work_order ?crop_variety)
        (field_assigned_to_season ?work_order ?production_season)
        (not
          (work_unit_assignment_confirmed ?work_order)
        )
      )
    :effect
      (and
        (work_unit_assignment_confirmed ?work_order)
        (crop_variety_available ?crop_variety)
        (production_season_available ?production_season)
      )
  )
)

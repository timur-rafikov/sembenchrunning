(define (domain agriculture_market_rejection_reprocessing_and_redirect)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_supertype - object test_supply_supertype - object facility_destination_supertype - object lot_supertype - object suspect_unit - lot_supertype handling_resource - resource_supertype test_kit - resource_supertype laboratory - resource_supertype quality_spec - resource_supertype logistics_option - resource_supertype regulatory_document - resource_supertype decontamination_method - resource_supertype lab_protocol - resource_supertype consumable_supply - test_supply_supertype reprocessing_material - test_supply_supertype market_buyer - test_supply_supertype contamination_profile - facility_destination_supertype routing_profile - facility_destination_supertype processing_slot - facility_destination_supertype unit_cluster - suspect_unit distributor_unit_cluster - suspect_unit producer_unit - unit_cluster distributor_unit - unit_cluster incident_response_unit - distributor_unit_cluster)
  (:predicates
    (entity_registered ?entity - suspect_unit)
    (entity_test_result_available ?entity - suspect_unit)
    (entity_containment_reserved ?entity - suspect_unit)
    (entity_released ?entity - suspect_unit)
    (marked_for_finalization ?entity - suspect_unit)
    (authorized_for_release ?entity - suspect_unit)
    (handling_resource_available ?handling_resource - handling_resource)
    (entity_handling_resource_assigned ?entity - suspect_unit ?handling_resource - handling_resource)
    (test_kit_available ?test_kit - test_kit)
    (entity_test_assignment ?entity - suspect_unit ?test_kit - test_kit)
    (laboratory_available ?laboratory - laboratory)
    (entity_laboratory_assigned ?entity - suspect_unit ?laboratory - laboratory)
    (consumable_supply_available ?consumable_supply - consumable_supply)
    (producer_supply_assigned ?producer_unit - producer_unit ?consumable_supply - consumable_supply)
    (distributor_supply_assigned ?distributor_unit - distributor_unit ?consumable_supply - consumable_supply)
    (unit_has_contamination_profile ?producer_unit - producer_unit ?contamination_profile - contamination_profile)
    (profile_ready_for_processing ?contamination_profile - contamination_profile)
    (profile_requires_supply ?contamination_profile - contamination_profile)
    (producer_treatment_confirmed ?producer_unit - producer_unit)
    (distributor_routing_profile_assigned ?distributor_unit - distributor_unit ?routing_profile - routing_profile)
    (routing_profile_prepared ?routing_profile - routing_profile)
    (routing_profile_requires_supply ?routing_profile - routing_profile)
    (distributor_treatment_confirmed ?distributor_unit - distributor_unit)
    (processing_slot_available ?processing_slot - processing_slot)
    (processing_slot_reserved ?processing_slot - processing_slot)
    (processing_slot_assigned_profile ?processing_slot - processing_slot ?contamination_profile - contamination_profile)
    (processing_slot_assigned_routing ?processing_slot - processing_slot ?routing_profile - routing_profile)
    (processing_slot_configured_for_supply_driven_case ?processing_slot - processing_slot)
    (processing_slot_configured_for_routing_driven_case ?processing_slot - processing_slot)
    (processing_slot_commissioned ?processing_slot - processing_slot)
    (response_unit_manages_producer ?response_unit - incident_response_unit ?producer_unit - producer_unit)
    (response_unit_manages_distributor ?response_unit - incident_response_unit ?distributor_unit - distributor_unit)
    (response_unit_assigned_slot ?response_unit - incident_response_unit ?processing_slot - processing_slot)
    (reprocessing_material_available ?reprocessing_material - reprocessing_material)
    (response_unit_material_assigned ?response_unit - incident_response_unit ?reprocessing_material - reprocessing_material)
    (reprocessing_material_reserved ?reprocessing_material - reprocessing_material)
    (reprocessing_material_staged_at_slot ?reprocessing_material - reprocessing_material ?processing_slot - processing_slot)
    (response_unit_staging_confirmed ?response_unit - incident_response_unit)
    (response_unit_treatment_allocated ?response_unit - incident_response_unit)
    (response_unit_treatment_executed ?response_unit - incident_response_unit)
    (response_unit_quality_task_started ?response_unit - incident_response_unit)
    (response_unit_quality_confirmed ?response_unit - incident_response_unit)
    (response_unit_ready_for_logistics_assignment ?response_unit - incident_response_unit)
    (response_unit_processing_complete ?response_unit - incident_response_unit)
    (buyer_available ?buyer - market_buyer)
    (response_unit_buyer_assigned ?response_unit - incident_response_unit ?buyer - market_buyer)
    (response_unit_buyer_engaged ?response_unit - incident_response_unit)
    (response_unit_buyer_lab_request ?response_unit - incident_response_unit)
    (response_unit_buyer_lab_response ?response_unit - incident_response_unit)
    (quality_spec_available ?quality_spec - quality_spec)
    (response_unit_quality_spec_assigned ?response_unit - incident_response_unit ?quality_spec - quality_spec)
    (logistics_option_available ?logistics_option - logistics_option)
    (response_unit_logistics_assigned ?response_unit - incident_response_unit ?logistics_option - logistics_option)
    (decon_method_available ?decontamination_method - decontamination_method)
    (response_unit_decon_method_assigned ?response_unit - incident_response_unit ?decontamination_method - decontamination_method)
    (lab_protocol_available ?lab_protocol - lab_protocol)
    (response_unit_lab_protocol_assigned ?response_unit - incident_response_unit ?lab_protocol - lab_protocol)
    (regulatory_document_available ?regulatory_document - regulatory_document)
    (entity_regulatory_document_assigned ?entity - suspect_unit ?regulatory_document - regulatory_document)
    (producer_unit_ready ?producer_unit - producer_unit)
    (distributor_unit_ready ?distributor_unit - distributor_unit)
    (response_unit_qa_completed ?response_unit - incident_response_unit)
  )
  (:action register_suspect_lot
    :parameters (?entity - suspect_unit)
    :precondition
      (and
        (not
          (entity_registered ?entity)
        )
        (not
          (entity_released ?entity)
        )
      )
    :effect (entity_registered ?entity)
  )
  (:action assign_handling_resource_to_lot
    :parameters (?entity - suspect_unit ?handling_resource - handling_resource)
    :precondition
      (and
        (entity_registered ?entity)
        (not
          (entity_containment_reserved ?entity)
        )
        (handling_resource_available ?handling_resource)
      )
    :effect
      (and
        (entity_containment_reserved ?entity)
        (entity_handling_resource_assigned ?entity ?handling_resource)
        (not
          (handling_resource_available ?handling_resource)
        )
      )
  )
  (:action allocate_test_kit_to_lot
    :parameters (?entity - suspect_unit ?test_kit - test_kit)
    :precondition
      (and
        (entity_registered ?entity)
        (entity_containment_reserved ?entity)
        (test_kit_available ?test_kit)
      )
    :effect
      (and
        (entity_test_assignment ?entity ?test_kit)
        (not
          (test_kit_available ?test_kit)
        )
      )
  )
  (:action finalize_test_result_for_lot
    :parameters (?entity - suspect_unit ?test_kit - test_kit)
    :precondition
      (and
        (entity_registered ?entity)
        (entity_containment_reserved ?entity)
        (entity_test_assignment ?entity ?test_kit)
        (not
          (entity_test_result_available ?entity)
        )
      )
    :effect (entity_test_result_available ?entity)
  )
  (:action release_test_kit_from_lot
    :parameters (?entity - suspect_unit ?test_kit - test_kit)
    :precondition
      (and
        (entity_test_assignment ?entity ?test_kit)
      )
    :effect
      (and
        (test_kit_available ?test_kit)
        (not
          (entity_test_assignment ?entity ?test_kit)
        )
      )
  )
  (:action assign_laboratory_to_lot
    :parameters (?entity - suspect_unit ?laboratory - laboratory)
    :precondition
      (and
        (entity_test_result_available ?entity)
        (laboratory_available ?laboratory)
      )
    :effect
      (and
        (entity_laboratory_assigned ?entity ?laboratory)
        (not
          (laboratory_available ?laboratory)
        )
      )
  )
  (:action release_laboratory_from_lot
    :parameters (?entity - suspect_unit ?laboratory - laboratory)
    :precondition
      (and
        (entity_laboratory_assigned ?entity ?laboratory)
      )
    :effect
      (and
        (laboratory_available ?laboratory)
        (not
          (entity_laboratory_assigned ?entity ?laboratory)
        )
      )
  )
  (:action assign_decontamination_method_to_response_unit
    :parameters (?response_unit - incident_response_unit ?decontamination_method - decontamination_method)
    :precondition
      (and
        (entity_test_result_available ?response_unit)
        (decon_method_available ?decontamination_method)
      )
    :effect
      (and
        (response_unit_decon_method_assigned ?response_unit ?decontamination_method)
        (not
          (decon_method_available ?decontamination_method)
        )
      )
  )
  (:action release_decontamination_method_from_response_unit
    :parameters (?response_unit - incident_response_unit ?decontamination_method - decontamination_method)
    :precondition
      (and
        (response_unit_decon_method_assigned ?response_unit ?decontamination_method)
      )
    :effect
      (and
        (decon_method_available ?decontamination_method)
        (not
          (response_unit_decon_method_assigned ?response_unit ?decontamination_method)
        )
      )
  )
  (:action assign_lab_protocol_to_response_unit
    :parameters (?response_unit - incident_response_unit ?lab_protocol - lab_protocol)
    :precondition
      (and
        (entity_test_result_available ?response_unit)
        (lab_protocol_available ?lab_protocol)
      )
    :effect
      (and
        (response_unit_lab_protocol_assigned ?response_unit ?lab_protocol)
        (not
          (lab_protocol_available ?lab_protocol)
        )
      )
  )
  (:action release_lab_protocol_from_response_unit
    :parameters (?response_unit - incident_response_unit ?lab_protocol - lab_protocol)
    :precondition
      (and
        (response_unit_lab_protocol_assigned ?response_unit ?lab_protocol)
      )
    :effect
      (and
        (lab_protocol_available ?lab_protocol)
        (not
          (response_unit_lab_protocol_assigned ?response_unit ?lab_protocol)
        )
      )
  )
  (:action triage_contamination_profile
    :parameters (?producer_unit - producer_unit ?contamination_profile - contamination_profile ?test_kit - test_kit)
    :precondition
      (and
        (entity_test_result_available ?producer_unit)
        (entity_test_assignment ?producer_unit ?test_kit)
        (unit_has_contamination_profile ?producer_unit ?contamination_profile)
        (not
          (profile_ready_for_processing ?contamination_profile)
        )
        (not
          (profile_requires_supply ?contamination_profile)
        )
      )
    :effect (profile_ready_for_processing ?contamination_profile)
  )
  (:action confirm_producer_treatment_readiness
    :parameters (?producer_unit - producer_unit ?contamination_profile - contamination_profile ?laboratory - laboratory)
    :precondition
      (and
        (entity_test_result_available ?producer_unit)
        (entity_laboratory_assigned ?producer_unit ?laboratory)
        (unit_has_contamination_profile ?producer_unit ?contamination_profile)
        (profile_ready_for_processing ?contamination_profile)
        (not
          (producer_unit_ready ?producer_unit)
        )
      )
    :effect
      (and
        (producer_unit_ready ?producer_unit)
        (producer_treatment_confirmed ?producer_unit)
      )
  )
  (:action assign_supply_to_producer_profile
    :parameters (?producer_unit - producer_unit ?contamination_profile - contamination_profile ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_test_result_available ?producer_unit)
        (unit_has_contamination_profile ?producer_unit ?contamination_profile)
        (consumable_supply_available ?consumable_supply)
        (not
          (producer_unit_ready ?producer_unit)
        )
      )
    :effect
      (and
        (profile_requires_supply ?contamination_profile)
        (producer_unit_ready ?producer_unit)
        (producer_supply_assigned ?producer_unit ?consumable_supply)
        (not
          (consumable_supply_available ?consumable_supply)
        )
      )
  )
  (:action start_producer_profile_treatment
    :parameters (?producer_unit - producer_unit ?contamination_profile - contamination_profile ?test_kit - test_kit ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_test_result_available ?producer_unit)
        (entity_test_assignment ?producer_unit ?test_kit)
        (unit_has_contamination_profile ?producer_unit ?contamination_profile)
        (profile_requires_supply ?contamination_profile)
        (producer_supply_assigned ?producer_unit ?consumable_supply)
        (not
          (producer_treatment_confirmed ?producer_unit)
        )
      )
    :effect
      (and
        (profile_ready_for_processing ?contamination_profile)
        (producer_treatment_confirmed ?producer_unit)
        (consumable_supply_available ?consumable_supply)
        (not
          (producer_supply_assigned ?producer_unit ?consumable_supply)
        )
      )
  )
  (:action triage_distributor_contamination_profile
    :parameters (?distributor_unit - distributor_unit ?routing_profile - routing_profile ?test_kit - test_kit)
    :precondition
      (and
        (entity_test_result_available ?distributor_unit)
        (entity_test_assignment ?distributor_unit ?test_kit)
        (distributor_routing_profile_assigned ?distributor_unit ?routing_profile)
        (not
          (routing_profile_prepared ?routing_profile)
        )
        (not
          (routing_profile_requires_supply ?routing_profile)
        )
      )
    :effect (routing_profile_prepared ?routing_profile)
  )
  (:action confirm_distributor_treatment_readiness
    :parameters (?distributor_unit - distributor_unit ?routing_profile - routing_profile ?laboratory - laboratory)
    :precondition
      (and
        (entity_test_result_available ?distributor_unit)
        (entity_laboratory_assigned ?distributor_unit ?laboratory)
        (distributor_routing_profile_assigned ?distributor_unit ?routing_profile)
        (routing_profile_prepared ?routing_profile)
        (not
          (distributor_unit_ready ?distributor_unit)
        )
      )
    :effect
      (and
        (distributor_unit_ready ?distributor_unit)
        (distributor_treatment_confirmed ?distributor_unit)
      )
  )
  (:action assign_supply_to_distributor_profile
    :parameters (?distributor_unit - distributor_unit ?routing_profile - routing_profile ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_test_result_available ?distributor_unit)
        (distributor_routing_profile_assigned ?distributor_unit ?routing_profile)
        (consumable_supply_available ?consumable_supply)
        (not
          (distributor_unit_ready ?distributor_unit)
        )
      )
    :effect
      (and
        (routing_profile_requires_supply ?routing_profile)
        (distributor_unit_ready ?distributor_unit)
        (distributor_supply_assigned ?distributor_unit ?consumable_supply)
        (not
          (consumable_supply_available ?consumable_supply)
        )
      )
  )
  (:action start_distributor_profile_treatment
    :parameters (?distributor_unit - distributor_unit ?routing_profile - routing_profile ?test_kit - test_kit ?consumable_supply - consumable_supply)
    :precondition
      (and
        (entity_test_result_available ?distributor_unit)
        (entity_test_assignment ?distributor_unit ?test_kit)
        (distributor_routing_profile_assigned ?distributor_unit ?routing_profile)
        (routing_profile_requires_supply ?routing_profile)
        (distributor_supply_assigned ?distributor_unit ?consumable_supply)
        (not
          (distributor_treatment_confirmed ?distributor_unit)
        )
      )
    :effect
      (and
        (routing_profile_prepared ?routing_profile)
        (distributor_treatment_confirmed ?distributor_unit)
        (consumable_supply_available ?consumable_supply)
        (not
          (distributor_supply_assigned ?distributor_unit ?consumable_supply)
        )
      )
  )
  (:action reserve_processing_slot_for_profiles
    :parameters (?producer_unit - producer_unit ?distributor_unit - distributor_unit ?contamination_profile - contamination_profile ?routing_profile - routing_profile ?processing_slot - processing_slot)
    :precondition
      (and
        (producer_unit_ready ?producer_unit)
        (distributor_unit_ready ?distributor_unit)
        (unit_has_contamination_profile ?producer_unit ?contamination_profile)
        (distributor_routing_profile_assigned ?distributor_unit ?routing_profile)
        (profile_ready_for_processing ?contamination_profile)
        (routing_profile_prepared ?routing_profile)
        (producer_treatment_confirmed ?producer_unit)
        (distributor_treatment_confirmed ?distributor_unit)
        (processing_slot_available ?processing_slot)
      )
    :effect
      (and
        (processing_slot_reserved ?processing_slot)
        (processing_slot_assigned_profile ?processing_slot ?contamination_profile)
        (processing_slot_assigned_routing ?processing_slot ?routing_profile)
        (not
          (processing_slot_available ?processing_slot)
        )
      )
  )
  (:action reserve_processing_slot_supply_driven
    :parameters (?producer_unit - producer_unit ?distributor_unit - distributor_unit ?contamination_profile - contamination_profile ?routing_profile - routing_profile ?processing_slot - processing_slot)
    :precondition
      (and
        (producer_unit_ready ?producer_unit)
        (distributor_unit_ready ?distributor_unit)
        (unit_has_contamination_profile ?producer_unit ?contamination_profile)
        (distributor_routing_profile_assigned ?distributor_unit ?routing_profile)
        (profile_requires_supply ?contamination_profile)
        (routing_profile_prepared ?routing_profile)
        (not
          (producer_treatment_confirmed ?producer_unit)
        )
        (distributor_treatment_confirmed ?distributor_unit)
        (processing_slot_available ?processing_slot)
      )
    :effect
      (and
        (processing_slot_reserved ?processing_slot)
        (processing_slot_assigned_profile ?processing_slot ?contamination_profile)
        (processing_slot_assigned_routing ?processing_slot ?routing_profile)
        (processing_slot_configured_for_supply_driven_case ?processing_slot)
        (not
          (processing_slot_available ?processing_slot)
        )
      )
  )
  (:action reserve_processing_slot_routing_driven
    :parameters (?producer_unit - producer_unit ?distributor_unit - distributor_unit ?contamination_profile - contamination_profile ?routing_profile - routing_profile ?processing_slot - processing_slot)
    :precondition
      (and
        (producer_unit_ready ?producer_unit)
        (distributor_unit_ready ?distributor_unit)
        (unit_has_contamination_profile ?producer_unit ?contamination_profile)
        (distributor_routing_profile_assigned ?distributor_unit ?routing_profile)
        (profile_ready_for_processing ?contamination_profile)
        (routing_profile_requires_supply ?routing_profile)
        (producer_treatment_confirmed ?producer_unit)
        (not
          (distributor_treatment_confirmed ?distributor_unit)
        )
        (processing_slot_available ?processing_slot)
      )
    :effect
      (and
        (processing_slot_reserved ?processing_slot)
        (processing_slot_assigned_profile ?processing_slot ?contamination_profile)
        (processing_slot_assigned_routing ?processing_slot ?routing_profile)
        (processing_slot_configured_for_routing_driven_case ?processing_slot)
        (not
          (processing_slot_available ?processing_slot)
        )
      )
  )
  (:action reserve_processing_slot_supply_and_routing
    :parameters (?producer_unit - producer_unit ?distributor_unit - distributor_unit ?contamination_profile - contamination_profile ?routing_profile - routing_profile ?processing_slot - processing_slot)
    :precondition
      (and
        (producer_unit_ready ?producer_unit)
        (distributor_unit_ready ?distributor_unit)
        (unit_has_contamination_profile ?producer_unit ?contamination_profile)
        (distributor_routing_profile_assigned ?distributor_unit ?routing_profile)
        (profile_requires_supply ?contamination_profile)
        (routing_profile_requires_supply ?routing_profile)
        (not
          (producer_treatment_confirmed ?producer_unit)
        )
        (not
          (distributor_treatment_confirmed ?distributor_unit)
        )
        (processing_slot_available ?processing_slot)
      )
    :effect
      (and
        (processing_slot_reserved ?processing_slot)
        (processing_slot_assigned_profile ?processing_slot ?contamination_profile)
        (processing_slot_assigned_routing ?processing_slot ?routing_profile)
        (processing_slot_configured_for_supply_driven_case ?processing_slot)
        (processing_slot_configured_for_routing_driven_case ?processing_slot)
        (not
          (processing_slot_available ?processing_slot)
        )
      )
  )
  (:action commission_processing_slot
    :parameters (?processing_slot - processing_slot ?producer_unit - producer_unit ?test_kit - test_kit)
    :precondition
      (and
        (processing_slot_reserved ?processing_slot)
        (producer_unit_ready ?producer_unit)
        (entity_test_assignment ?producer_unit ?test_kit)
        (not
          (processing_slot_commissioned ?processing_slot)
        )
      )
    :effect (processing_slot_commissioned ?processing_slot)
  )
  (:action stage_material_to_slot
    :parameters (?response_unit - incident_response_unit ?reprocessing_material - reprocessing_material ?processing_slot - processing_slot)
    :precondition
      (and
        (entity_test_result_available ?response_unit)
        (response_unit_assigned_slot ?response_unit ?processing_slot)
        (response_unit_material_assigned ?response_unit ?reprocessing_material)
        (reprocessing_material_available ?reprocessing_material)
        (processing_slot_reserved ?processing_slot)
        (processing_slot_commissioned ?processing_slot)
        (not
          (reprocessing_material_reserved ?reprocessing_material)
        )
      )
    :effect
      (and
        (reprocessing_material_reserved ?reprocessing_material)
        (reprocessing_material_staged_at_slot ?reprocessing_material ?processing_slot)
        (not
          (reprocessing_material_available ?reprocessing_material)
        )
      )
  )
  (:action confirm_material_staging
    :parameters (?response_unit - incident_response_unit ?reprocessing_material - reprocessing_material ?processing_slot - processing_slot ?test_kit - test_kit)
    :precondition
      (and
        (entity_test_result_available ?response_unit)
        (response_unit_material_assigned ?response_unit ?reprocessing_material)
        (reprocessing_material_reserved ?reprocessing_material)
        (reprocessing_material_staged_at_slot ?reprocessing_material ?processing_slot)
        (entity_test_assignment ?response_unit ?test_kit)
        (not
          (processing_slot_configured_for_supply_driven_case ?processing_slot)
        )
        (not
          (response_unit_staging_confirmed ?response_unit)
        )
      )
    :effect (response_unit_staging_confirmed ?response_unit)
  )
  (:action assign_quality_spec_to_response_unit
    :parameters (?response_unit - incident_response_unit ?quality_spec - quality_spec)
    :precondition
      (and
        (entity_test_result_available ?response_unit)
        (quality_spec_available ?quality_spec)
        (not
          (response_unit_quality_task_started ?response_unit)
        )
      )
    :effect
      (and
        (response_unit_quality_task_started ?response_unit)
        (response_unit_quality_spec_assigned ?response_unit ?quality_spec)
        (not
          (quality_spec_available ?quality_spec)
        )
      )
  )
  (:action confirm_quality_spec_and_mark
    :parameters (?response_unit - incident_response_unit ?reprocessing_material - reprocessing_material ?processing_slot - processing_slot ?test_kit - test_kit ?quality_spec - quality_spec)
    :precondition
      (and
        (entity_test_result_available ?response_unit)
        (response_unit_material_assigned ?response_unit ?reprocessing_material)
        (reprocessing_material_reserved ?reprocessing_material)
        (reprocessing_material_staged_at_slot ?reprocessing_material ?processing_slot)
        (entity_test_assignment ?response_unit ?test_kit)
        (processing_slot_configured_for_supply_driven_case ?processing_slot)
        (response_unit_quality_task_started ?response_unit)
        (response_unit_quality_spec_assigned ?response_unit ?quality_spec)
        (not
          (response_unit_staging_confirmed ?response_unit)
        )
      )
    :effect
      (and
        (response_unit_staging_confirmed ?response_unit)
        (response_unit_quality_confirmed ?response_unit)
      )
  )
  (:action allocate_decontamination_method_for_unit
    :parameters (?response_unit - incident_response_unit ?decontamination_method - decontamination_method ?laboratory - laboratory ?reprocessing_material - reprocessing_material ?processing_slot - processing_slot)
    :precondition
      (and
        (response_unit_staging_confirmed ?response_unit)
        (response_unit_decon_method_assigned ?response_unit ?decontamination_method)
        (entity_laboratory_assigned ?response_unit ?laboratory)
        (response_unit_material_assigned ?response_unit ?reprocessing_material)
        (reprocessing_material_staged_at_slot ?reprocessing_material ?processing_slot)
        (not
          (processing_slot_configured_for_routing_driven_case ?processing_slot)
        )
        (not
          (response_unit_treatment_allocated ?response_unit)
        )
      )
    :effect (response_unit_treatment_allocated ?response_unit)
  )
  (:action allocate_decontamination_method_for_unit_slot_flagged
    :parameters (?response_unit - incident_response_unit ?decontamination_method - decontamination_method ?laboratory - laboratory ?reprocessing_material - reprocessing_material ?processing_slot - processing_slot)
    :precondition
      (and
        (response_unit_staging_confirmed ?response_unit)
        (response_unit_decon_method_assigned ?response_unit ?decontamination_method)
        (entity_laboratory_assigned ?response_unit ?laboratory)
        (response_unit_material_assigned ?response_unit ?reprocessing_material)
        (reprocessing_material_staged_at_slot ?reprocessing_material ?processing_slot)
        (processing_slot_configured_for_routing_driven_case ?processing_slot)
        (not
          (response_unit_treatment_allocated ?response_unit)
        )
      )
    :effect (response_unit_treatment_allocated ?response_unit)
  )
  (:action execute_decontamination_run
    :parameters (?response_unit - incident_response_unit ?lab_protocol - lab_protocol ?reprocessing_material - reprocessing_material ?processing_slot - processing_slot)
    :precondition
      (and
        (response_unit_treatment_allocated ?response_unit)
        (response_unit_lab_protocol_assigned ?response_unit ?lab_protocol)
        (response_unit_material_assigned ?response_unit ?reprocessing_material)
        (reprocessing_material_staged_at_slot ?reprocessing_material ?processing_slot)
        (not
          (processing_slot_configured_for_supply_driven_case ?processing_slot)
        )
        (not
          (processing_slot_configured_for_routing_driven_case ?processing_slot)
        )
        (not
          (response_unit_treatment_executed ?response_unit)
        )
      )
    :effect (response_unit_treatment_executed ?response_unit)
  )
  (:action execute_decontamination_run_and_enable_logistics
    :parameters (?response_unit - incident_response_unit ?lab_protocol - lab_protocol ?reprocessing_material - reprocessing_material ?processing_slot - processing_slot)
    :precondition
      (and
        (response_unit_treatment_allocated ?response_unit)
        (response_unit_lab_protocol_assigned ?response_unit ?lab_protocol)
        (response_unit_material_assigned ?response_unit ?reprocessing_material)
        (reprocessing_material_staged_at_slot ?reprocessing_material ?processing_slot)
        (processing_slot_configured_for_supply_driven_case ?processing_slot)
        (not
          (processing_slot_configured_for_routing_driven_case ?processing_slot)
        )
        (not
          (response_unit_treatment_executed ?response_unit)
        )
      )
    :effect
      (and
        (response_unit_treatment_executed ?response_unit)
        (response_unit_ready_for_logistics_assignment ?response_unit)
      )
  )
  (:action execute_decontamination_run_and_enable_logistics_alt
    :parameters (?response_unit - incident_response_unit ?lab_protocol - lab_protocol ?reprocessing_material - reprocessing_material ?processing_slot - processing_slot)
    :precondition
      (and
        (response_unit_treatment_allocated ?response_unit)
        (response_unit_lab_protocol_assigned ?response_unit ?lab_protocol)
        (response_unit_material_assigned ?response_unit ?reprocessing_material)
        (reprocessing_material_staged_at_slot ?reprocessing_material ?processing_slot)
        (not
          (processing_slot_configured_for_supply_driven_case ?processing_slot)
        )
        (processing_slot_configured_for_routing_driven_case ?processing_slot)
        (not
          (response_unit_treatment_executed ?response_unit)
        )
      )
    :effect
      (and
        (response_unit_treatment_executed ?response_unit)
        (response_unit_ready_for_logistics_assignment ?response_unit)
      )
  )
  (:action execute_decontamination_run_and_enable_logistics_both
    :parameters (?response_unit - incident_response_unit ?lab_protocol - lab_protocol ?reprocessing_material - reprocessing_material ?processing_slot - processing_slot)
    :precondition
      (and
        (response_unit_treatment_allocated ?response_unit)
        (response_unit_lab_protocol_assigned ?response_unit ?lab_protocol)
        (response_unit_material_assigned ?response_unit ?reprocessing_material)
        (reprocessing_material_staged_at_slot ?reprocessing_material ?processing_slot)
        (processing_slot_configured_for_supply_driven_case ?processing_slot)
        (processing_slot_configured_for_routing_driven_case ?processing_slot)
        (not
          (response_unit_treatment_executed ?response_unit)
        )
      )
    :effect
      (and
        (response_unit_treatment_executed ?response_unit)
        (response_unit_ready_for_logistics_assignment ?response_unit)
      )
  )
  (:action complete_treatment_and_flag_for_finalization
    :parameters (?response_unit - incident_response_unit)
    :precondition
      (and
        (response_unit_treatment_executed ?response_unit)
        (not
          (response_unit_ready_for_logistics_assignment ?response_unit)
        )
        (not
          (response_unit_qa_completed ?response_unit)
        )
      )
    :effect
      (and
        (response_unit_qa_completed ?response_unit)
        (marked_for_finalization ?response_unit)
      )
  )
  (:action assign_logistics_option_to_response_unit
    :parameters (?response_unit - incident_response_unit ?logistics_option - logistics_option)
    :precondition
      (and
        (response_unit_treatment_executed ?response_unit)
        (response_unit_ready_for_logistics_assignment ?response_unit)
        (logistics_option_available ?logistics_option)
      )
    :effect
      (and
        (response_unit_logistics_assigned ?response_unit ?logistics_option)
        (not
          (logistics_option_available ?logistics_option)
        )
      )
  )
  (:action execute_material_handling_and_confirm
    :parameters (?response_unit - incident_response_unit ?producer_unit - producer_unit ?distributor_unit - distributor_unit ?test_kit - test_kit ?logistics_option - logistics_option)
    :precondition
      (and
        (response_unit_treatment_executed ?response_unit)
        (response_unit_ready_for_logistics_assignment ?response_unit)
        (response_unit_logistics_assigned ?response_unit ?logistics_option)
        (response_unit_manages_producer ?response_unit ?producer_unit)
        (response_unit_manages_distributor ?response_unit ?distributor_unit)
        (producer_treatment_confirmed ?producer_unit)
        (distributor_treatment_confirmed ?distributor_unit)
        (entity_test_assignment ?response_unit ?test_kit)
        (not
          (response_unit_processing_complete ?response_unit)
        )
      )
    :effect (response_unit_processing_complete ?response_unit)
  )
  (:action finalize_processing_and_mark_finalization
    :parameters (?response_unit - incident_response_unit)
    :precondition
      (and
        (response_unit_treatment_executed ?response_unit)
        (response_unit_processing_complete ?response_unit)
        (not
          (response_unit_qa_completed ?response_unit)
        )
      )
    :effect
      (and
        (response_unit_qa_completed ?response_unit)
        (marked_for_finalization ?response_unit)
      )
  )
  (:action engage_buyer_for_response_unit
    :parameters (?response_unit - incident_response_unit ?buyer - market_buyer ?test_kit - test_kit)
    :precondition
      (and
        (entity_test_result_available ?response_unit)
        (entity_test_assignment ?response_unit ?test_kit)
        (buyer_available ?buyer)
        (response_unit_buyer_assigned ?response_unit ?buyer)
        (not
          (response_unit_buyer_engaged ?response_unit)
        )
      )
    :effect
      (and
        (response_unit_buyer_engaged ?response_unit)
        (not
          (buyer_available ?buyer)
        )
      )
  )
  (:action request_buyer_lab_validation
    :parameters (?response_unit - incident_response_unit ?laboratory - laboratory)
    :precondition
      (and
        (response_unit_buyer_engaged ?response_unit)
        (entity_laboratory_assigned ?response_unit ?laboratory)
        (not
          (response_unit_buyer_lab_request ?response_unit)
        )
      )
    :effect (response_unit_buyer_lab_request ?response_unit)
  )
  (:action record_buyer_lab_validation
    :parameters (?response_unit - incident_response_unit ?lab_protocol - lab_protocol)
    :precondition
      (and
        (response_unit_buyer_lab_request ?response_unit)
        (response_unit_lab_protocol_assigned ?response_unit ?lab_protocol)
        (not
          (response_unit_buyer_lab_response ?response_unit)
        )
      )
    :effect (response_unit_buyer_lab_response ?response_unit)
  )
  (:action finalize_buyer_validation_and_mark_for_finalization
    :parameters (?response_unit - incident_response_unit)
    :precondition
      (and
        (response_unit_buyer_lab_response ?response_unit)
        (not
          (response_unit_qa_completed ?response_unit)
        )
      )
    :effect
      (and
        (response_unit_qa_completed ?response_unit)
        (marked_for_finalization ?response_unit)
      )
  )
  (:action mark_producer_finalized
    :parameters (?producer_unit - producer_unit ?processing_slot - processing_slot)
    :precondition
      (and
        (producer_unit_ready ?producer_unit)
        (producer_treatment_confirmed ?producer_unit)
        (processing_slot_reserved ?processing_slot)
        (processing_slot_commissioned ?processing_slot)
        (not
          (marked_for_finalization ?producer_unit)
        )
      )
    :effect (marked_for_finalization ?producer_unit)
  )
  (:action mark_distributor_finalized
    :parameters (?distributor_unit - distributor_unit ?processing_slot - processing_slot)
    :precondition
      (and
        (distributor_unit_ready ?distributor_unit)
        (distributor_treatment_confirmed ?distributor_unit)
        (processing_slot_reserved ?processing_slot)
        (processing_slot_commissioned ?processing_slot)
        (not
          (marked_for_finalization ?distributor_unit)
        )
      )
    :effect (marked_for_finalization ?distributor_unit)
  )
  (:action issue_regulatory_document_to_lot
    :parameters (?entity - suspect_unit ?regulatory_document - regulatory_document ?test_kit - test_kit)
    :precondition
      (and
        (marked_for_finalization ?entity)
        (entity_test_assignment ?entity ?test_kit)
        (regulatory_document_available ?regulatory_document)
        (not
          (authorized_for_release ?entity)
        )
      )
    :effect
      (and
        (authorized_for_release ?entity)
        (entity_regulatory_document_assigned ?entity ?regulatory_document)
        (not
          (regulatory_document_available ?regulatory_document)
        )
      )
  )
  (:action finalize_release_and_return_resources_producer
    :parameters (?producer_unit - producer_unit ?handling_resource - handling_resource ?regulatory_document - regulatory_document)
    :precondition
      (and
        (authorized_for_release ?producer_unit)
        (entity_handling_resource_assigned ?producer_unit ?handling_resource)
        (entity_regulatory_document_assigned ?producer_unit ?regulatory_document)
        (not
          (entity_released ?producer_unit)
        )
      )
    :effect
      (and
        (entity_released ?producer_unit)
        (handling_resource_available ?handling_resource)
        (regulatory_document_available ?regulatory_document)
      )
  )
  (:action finalize_release_and_return_resources_distributor
    :parameters (?distributor_unit - distributor_unit ?handling_resource - handling_resource ?regulatory_document - regulatory_document)
    :precondition
      (and
        (authorized_for_release ?distributor_unit)
        (entity_handling_resource_assigned ?distributor_unit ?handling_resource)
        (entity_regulatory_document_assigned ?distributor_unit ?regulatory_document)
        (not
          (entity_released ?distributor_unit)
        )
      )
    :effect
      (and
        (entity_released ?distributor_unit)
        (handling_resource_available ?handling_resource)
        (regulatory_document_available ?regulatory_document)
      )
  )
  (:action finalize_release_and_return_resources_response_unit
    :parameters (?response_unit - incident_response_unit ?handling_resource - handling_resource ?regulatory_document - regulatory_document)
    :precondition
      (and
        (authorized_for_release ?response_unit)
        (entity_handling_resource_assigned ?response_unit ?handling_resource)
        (entity_regulatory_document_assigned ?response_unit ?regulatory_document)
        (not
          (entity_released ?response_unit)
        )
      )
    :effect
      (and
        (entity_released ?response_unit)
        (handling_resource_available ?handling_resource)
        (regulatory_document_available ?regulatory_document)
      )
  )
)

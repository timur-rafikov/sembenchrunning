(define (domain pharmaceutics_disposal_of_nonconforming_medicinal_stock)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object logistics_resource_group - domain_object documentary_resource_group - domain_object classification_resource_group - domain_object stock_family - domain_object nonconforming_stock_item - stock_family disposal_container_slot - logistics_resource_group laboratory_test_slot - logistics_resource_group quality_inspector - logistics_resource_group environmental_permit - logistics_resource_group neutralisation_kit - logistics_resource_group disposal_certificate_token - logistics_resource_group incineration_facility_slot - logistics_resource_group environmental_clearance_authorization - logistics_resource_group disposal_manifest_document - documentary_resource_group designated_disposal_site - documentary_resource_group regulatory_approval_document - documentary_resource_group hazard_classification - classification_resource_group distribution_cluster_profile - classification_resource_group disposal_shipment - classification_resource_group storage_location_type - nonconforming_stock_item response_agent_type - nonconforming_stock_item local_warehouse - storage_location_type dispensing_site - storage_location_type authorised_disposal_agent - response_agent_type)

  (:predicates
    (item_triaged ?nonconforming_stock_item - nonconforming_stock_item)
    (entity_case_open_for_processing ?nonconforming_stock_item - nonconforming_stock_item)
    (item_has_container_assignment ?nonconforming_stock_item - nonconforming_stock_item)
    (entity_disposal_execution_recorded ?nonconforming_stock_item - nonconforming_stock_item)
    (entity_final_disposal_approval ?nonconforming_stock_item - nonconforming_stock_item)
    (entity_disposal_certificate_issued ?nonconforming_stock_item - nonconforming_stock_item)
    (disposal_container_slot_available ?disposal_container_slot - disposal_container_slot)
    (entity_linked_to_container_slot ?nonconforming_stock_item - nonconforming_stock_item ?disposal_container_slot - disposal_container_slot)
    (laboratory_test_slot_available ?laboratory_test_slot - laboratory_test_slot)
    (entity_linked_to_laboratory_test_slot ?nonconforming_stock_item - nonconforming_stock_item ?laboratory_test_slot - laboratory_test_slot)
    (quality_inspector_available ?quality_inspector - quality_inspector)
    (entity_assigned_to_quality_inspector ?nonconforming_stock_item - nonconforming_stock_item ?quality_inspector - quality_inspector)
    (disposal_manifest_available ?disposal_manifest_document - disposal_manifest_document)
    (warehouse_manifest_attached ?local_warehouse - local_warehouse ?disposal_manifest_document - disposal_manifest_document)
    (dispensing_site_manifest_attached ?dispensing_site - dispensing_site ?disposal_manifest_document - disposal_manifest_document)
    (warehouse_hazard_classification_assigned ?local_warehouse - local_warehouse ?hazard_classification - hazard_classification)
    (hazard_classification_confirmed ?hazard_classification - hazard_classification)
    (hazard_classification_manifest_required ?hazard_classification - hazard_classification)
    (warehouse_quarantine_marked ?local_warehouse - local_warehouse)
    (dispensing_site_assigned_distribution_cluster ?dispensing_site - dispensing_site ?distribution_cluster_profile - distribution_cluster_profile)
    (distribution_cluster_selected ?distribution_cluster_profile - distribution_cluster_profile)
    (distribution_cluster_alternate_selected ?distribution_cluster_profile - distribution_cluster_profile)
    (dispensing_site_quarantine_marked ?dispensing_site - dispensing_site)
    (disposal_shipment_available ?disposal_shipment - disposal_shipment)
    (disposal_shipment_reserved ?disposal_shipment - disposal_shipment)
    (disposal_shipment_linked_hazard_classification ?disposal_shipment - disposal_shipment ?hazard_classification - hazard_classification)
    (disposal_shipment_linked_distribution_cluster ?disposal_shipment - disposal_shipment ?distribution_cluster_profile - distribution_cluster_profile)
    (disposal_shipment_variant_staging_flag ?disposal_shipment - disposal_shipment)
    (disposal_shipment_variant_emergency_flag ?disposal_shipment - disposal_shipment)
    (disposal_shipment_locked_for_execution ?disposal_shipment - disposal_shipment)
    (agent_attached_to_warehouse ?authorised_disposal_agent - authorised_disposal_agent ?local_warehouse - local_warehouse)
    (agent_attached_to_dispensing_site ?authorised_disposal_agent - authorised_disposal_agent ?dispensing_site - dispensing_site)
    (agent_assigned_to_disposal_shipment ?authorised_disposal_agent - authorised_disposal_agent ?disposal_shipment - disposal_shipment)
    (designated_disposal_site_available ?designated_disposal_site - designated_disposal_site)
    (agent_has_designated_disposal_site ?authorised_disposal_agent - authorised_disposal_agent ?designated_disposal_site - designated_disposal_site)
    (designated_disposal_site_reserved ?designated_disposal_site - designated_disposal_site)
    (designated_site_linked_to_disposal_shipment ?designated_disposal_site - designated_disposal_site ?disposal_shipment - disposal_shipment)
    (agent_site_validation_completed ?authorised_disposal_agent - authorised_disposal_agent)
    (agent_incineration_facility_slot_reserved_confirmed ?authorised_disposal_agent - authorised_disposal_agent)
    (agent_environmental_clearance_confirmed ?authorised_disposal_agent - authorised_disposal_agent)
    (agent_environmental_permit_reserved ?authorised_disposal_agent - authorised_disposal_agent)
    (agent_site_authorization_confirmed ?authorised_disposal_agent - authorised_disposal_agent)
    (agent_authorization_documents_attached ?authorised_disposal_agent - authorised_disposal_agent)
    (agent_final_processing_completed ?authorised_disposal_agent - authorised_disposal_agent)
    (regulatory_approval_document_available ?regulatory_approval_document - regulatory_approval_document)
    (agent_has_regulatory_approval ?authorised_disposal_agent - authorised_disposal_agent ?regulatory_approval_document - regulatory_approval_document)
    (agent_regulatory_approval_bound ?authorised_disposal_agent - authorised_disposal_agent)
    (agent_regulatory_condition_met ?authorised_disposal_agent - authorised_disposal_agent)
    (agent_environmental_condition_validated ?authorised_disposal_agent - authorised_disposal_agent)
    (environmental_permit_available ?environmental_permit - environmental_permit)
    (agent_attached_environmental_permit ?authorised_disposal_agent - authorised_disposal_agent ?environmental_permit - environmental_permit)
    (neutralisation_kit_available ?neutralisation_kit - neutralisation_kit)
    (agent_assigned_neutralisation_kit ?authorised_disposal_agent - authorised_disposal_agent ?neutralisation_kit - neutralisation_kit)
    (incineration_facility_slot_available ?incineration_facility_slot - incineration_facility_slot)
    (agent_reserved_incineration_facility_slot ?authorised_disposal_agent - authorised_disposal_agent ?incineration_facility_slot - incineration_facility_slot)
    (environmental_clearance_authorization_available ?environmental_clearance_authorization - environmental_clearance_authorization)
    (agent_reserved_environmental_clearance_authorization ?authorised_disposal_agent - authorised_disposal_agent ?environmental_clearance_authorization - environmental_clearance_authorization)
    (disposal_certificate_token_available ?disposal_certificate_token - disposal_certificate_token)
    (entity_linked_to_disposal_certificate_token ?nonconforming_stock_item - nonconforming_stock_item ?disposal_certificate_token - disposal_certificate_token)
    (warehouse_ready_for_shipment_processing ?local_warehouse - local_warehouse)
    (dispensing_site_ready_for_shipment_processing ?dispensing_site - dispensing_site)
    (agent_final_signoff_logged ?authorised_disposal_agent - authorised_disposal_agent)
  )
  (:action flag_nonconforming_stock_item
    :parameters (?nonconforming_stock_item - nonconforming_stock_item)
    :precondition
      (and
        (not
          (item_triaged ?nonconforming_stock_item)
        )
        (not
          (entity_disposal_execution_recorded ?nonconforming_stock_item)
        )
      )
    :effect (item_triaged ?nonconforming_stock_item)
  )
  (:action assign_disposal_container_slot_to_item
    :parameters (?nonconforming_stock_item - nonconforming_stock_item ?disposal_container_slot - disposal_container_slot)
    :precondition
      (and
        (item_triaged ?nonconforming_stock_item)
        (not
          (item_has_container_assignment ?nonconforming_stock_item)
        )
        (disposal_container_slot_available ?disposal_container_slot)
      )
    :effect
      (and
        (item_has_container_assignment ?nonconforming_stock_item)
        (entity_linked_to_container_slot ?nonconforming_stock_item ?disposal_container_slot)
        (not
          (disposal_container_slot_available ?disposal_container_slot)
        )
      )
  )
  (:action assign_laboratory_test_slot_to_item
    :parameters (?nonconforming_stock_item - nonconforming_stock_item ?laboratory_test_slot - laboratory_test_slot)
    :precondition
      (and
        (item_triaged ?nonconforming_stock_item)
        (item_has_container_assignment ?nonconforming_stock_item)
        (laboratory_test_slot_available ?laboratory_test_slot)
      )
    :effect
      (and
        (entity_linked_to_laboratory_test_slot ?nonconforming_stock_item ?laboratory_test_slot)
        (not
          (laboratory_test_slot_available ?laboratory_test_slot)
        )
      )
  )
  (:action open_investigation_for_item
    :parameters (?nonconforming_stock_item - nonconforming_stock_item ?laboratory_test_slot - laboratory_test_slot)
    :precondition
      (and
        (item_triaged ?nonconforming_stock_item)
        (item_has_container_assignment ?nonconforming_stock_item)
        (entity_linked_to_laboratory_test_slot ?nonconforming_stock_item ?laboratory_test_slot)
        (not
          (entity_case_open_for_processing ?nonconforming_stock_item)
        )
      )
    :effect (entity_case_open_for_processing ?nonconforming_stock_item)
  )
  (:action release_laboratory_test_slot_for_item
    :parameters (?nonconforming_stock_item - nonconforming_stock_item ?laboratory_test_slot - laboratory_test_slot)
    :precondition
      (and
        (entity_linked_to_laboratory_test_slot ?nonconforming_stock_item ?laboratory_test_slot)
      )
    :effect
      (and
        (laboratory_test_slot_available ?laboratory_test_slot)
        (not
          (entity_linked_to_laboratory_test_slot ?nonconforming_stock_item ?laboratory_test_slot)
        )
      )
  )
  (:action assign_quality_inspector_to_item
    :parameters (?nonconforming_stock_item - nonconforming_stock_item ?quality_inspector - quality_inspector)
    :precondition
      (and
        (entity_case_open_for_processing ?nonconforming_stock_item)
        (quality_inspector_available ?quality_inspector)
      )
    :effect
      (and
        (entity_assigned_to_quality_inspector ?nonconforming_stock_item ?quality_inspector)
        (not
          (quality_inspector_available ?quality_inspector)
        )
      )
  )
  (:action release_quality_inspector_from_item
    :parameters (?nonconforming_stock_item - nonconforming_stock_item ?quality_inspector - quality_inspector)
    :precondition
      (and
        (entity_assigned_to_quality_inspector ?nonconforming_stock_item ?quality_inspector)
      )
    :effect
      (and
        (quality_inspector_available ?quality_inspector)
        (not
          (entity_assigned_to_quality_inspector ?nonconforming_stock_item ?quality_inspector)
        )
      )
  )
  (:action reserve_incineration_slot_for_agent
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?incineration_facility_slot - incineration_facility_slot)
    :precondition
      (and
        (entity_case_open_for_processing ?authorised_disposal_agent)
        (incineration_facility_slot_available ?incineration_facility_slot)
      )
    :effect
      (and
        (agent_reserved_incineration_facility_slot ?authorised_disposal_agent ?incineration_facility_slot)
        (not
          (incineration_facility_slot_available ?incineration_facility_slot)
        )
      )
  )
  (:action release_incineration_slot_from_agent
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?incineration_facility_slot - incineration_facility_slot)
    :precondition
      (and
        (agent_reserved_incineration_facility_slot ?authorised_disposal_agent ?incineration_facility_slot)
      )
    :effect
      (and
        (incineration_facility_slot_available ?incineration_facility_slot)
        (not
          (agent_reserved_incineration_facility_slot ?authorised_disposal_agent ?incineration_facility_slot)
        )
      )
  )
  (:action reserve_environmental_clearance_for_agent
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?environmental_clearance_authorization - environmental_clearance_authorization)
    :precondition
      (and
        (entity_case_open_for_processing ?authorised_disposal_agent)
        (environmental_clearance_authorization_available ?environmental_clearance_authorization)
      )
    :effect
      (and
        (agent_reserved_environmental_clearance_authorization ?authorised_disposal_agent ?environmental_clearance_authorization)
        (not
          (environmental_clearance_authorization_available ?environmental_clearance_authorization)
        )
      )
  )
  (:action release_environmental_clearance_from_agent
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?environmental_clearance_authorization - environmental_clearance_authorization)
    :precondition
      (and
        (agent_reserved_environmental_clearance_authorization ?authorised_disposal_agent ?environmental_clearance_authorization)
      )
    :effect
      (and
        (environmental_clearance_authorization_available ?environmental_clearance_authorization)
        (not
          (agent_reserved_environmental_clearance_authorization ?authorised_disposal_agent ?environmental_clearance_authorization)
        )
      )
  )
  (:action confirm_hazard_classification_for_warehouse
    :parameters (?local_warehouse - local_warehouse ?hazard_classification - hazard_classification ?laboratory_test_slot - laboratory_test_slot)
    :precondition
      (and
        (entity_case_open_for_processing ?local_warehouse)
        (entity_linked_to_laboratory_test_slot ?local_warehouse ?laboratory_test_slot)
        (warehouse_hazard_classification_assigned ?local_warehouse ?hazard_classification)
        (not
          (hazard_classification_confirmed ?hazard_classification)
        )
        (not
          (hazard_classification_manifest_required ?hazard_classification)
        )
      )
    :effect (hazard_classification_confirmed ?hazard_classification)
  )
  (:action assign_quarantine_and_mark_warehouse_ready
    :parameters (?local_warehouse - local_warehouse ?hazard_classification - hazard_classification ?quality_inspector - quality_inspector)
    :precondition
      (and
        (entity_case_open_for_processing ?local_warehouse)
        (entity_assigned_to_quality_inspector ?local_warehouse ?quality_inspector)
        (warehouse_hazard_classification_assigned ?local_warehouse ?hazard_classification)
        (hazard_classification_confirmed ?hazard_classification)
        (not
          (warehouse_ready_for_shipment_processing ?local_warehouse)
        )
      )
    :effect
      (and
        (warehouse_ready_for_shipment_processing ?local_warehouse)
        (warehouse_quarantine_marked ?local_warehouse)
      )
  )
  (:action attach_manifest_to_warehouse_and_mark_for_processing
    :parameters (?local_warehouse - local_warehouse ?hazard_classification - hazard_classification ?disposal_manifest_document - disposal_manifest_document)
    :precondition
      (and
        (entity_case_open_for_processing ?local_warehouse)
        (warehouse_hazard_classification_assigned ?local_warehouse ?hazard_classification)
        (disposal_manifest_available ?disposal_manifest_document)
        (not
          (warehouse_ready_for_shipment_processing ?local_warehouse)
        )
      )
    :effect
      (and
        (hazard_classification_manifest_required ?hazard_classification)
        (warehouse_ready_for_shipment_processing ?local_warehouse)
        (warehouse_manifest_attached ?local_warehouse ?disposal_manifest_document)
        (not
          (disposal_manifest_available ?disposal_manifest_document)
        )
      )
  )
  (:action finalize_warehouse_classification_and_restore_manifest
    :parameters (?local_warehouse - local_warehouse ?hazard_classification - hazard_classification ?laboratory_test_slot - laboratory_test_slot ?disposal_manifest_document - disposal_manifest_document)
    :precondition
      (and
        (entity_case_open_for_processing ?local_warehouse)
        (entity_linked_to_laboratory_test_slot ?local_warehouse ?laboratory_test_slot)
        (warehouse_hazard_classification_assigned ?local_warehouse ?hazard_classification)
        (hazard_classification_manifest_required ?hazard_classification)
        (warehouse_manifest_attached ?local_warehouse ?disposal_manifest_document)
        (not
          (warehouse_quarantine_marked ?local_warehouse)
        )
      )
    :effect
      (and
        (hazard_classification_confirmed ?hazard_classification)
        (warehouse_quarantine_marked ?local_warehouse)
        (disposal_manifest_available ?disposal_manifest_document)
        (not
          (warehouse_manifest_attached ?local_warehouse ?disposal_manifest_document)
        )
      )
  )
  (:action confirm_hazard_classification_for_dispensing_site
    :parameters (?dispensing_site - dispensing_site ?distribution_cluster_profile - distribution_cluster_profile ?laboratory_test_slot - laboratory_test_slot)
    :precondition
      (and
        (entity_case_open_for_processing ?dispensing_site)
        (entity_linked_to_laboratory_test_slot ?dispensing_site ?laboratory_test_slot)
        (dispensing_site_assigned_distribution_cluster ?dispensing_site ?distribution_cluster_profile)
        (not
          (distribution_cluster_selected ?distribution_cluster_profile)
        )
        (not
          (distribution_cluster_alternate_selected ?distribution_cluster_profile)
        )
      )
    :effect (distribution_cluster_selected ?distribution_cluster_profile)
  )
  (:action assign_inspector_and_mark_dispensing_quarantine
    :parameters (?dispensing_site - dispensing_site ?distribution_cluster_profile - distribution_cluster_profile ?quality_inspector - quality_inspector)
    :precondition
      (and
        (entity_case_open_for_processing ?dispensing_site)
        (entity_assigned_to_quality_inspector ?dispensing_site ?quality_inspector)
        (dispensing_site_assigned_distribution_cluster ?dispensing_site ?distribution_cluster_profile)
        (distribution_cluster_selected ?distribution_cluster_profile)
        (not
          (dispensing_site_ready_for_shipment_processing ?dispensing_site)
        )
      )
    :effect
      (and
        (dispensing_site_ready_for_shipment_processing ?dispensing_site)
        (dispensing_site_quarantine_marked ?dispensing_site)
      )
  )
  (:action attach_manifest_to_dispensing_site
    :parameters (?dispensing_site - dispensing_site ?distribution_cluster_profile - distribution_cluster_profile ?disposal_manifest_document - disposal_manifest_document)
    :precondition
      (and
        (entity_case_open_for_processing ?dispensing_site)
        (dispensing_site_assigned_distribution_cluster ?dispensing_site ?distribution_cluster_profile)
        (disposal_manifest_available ?disposal_manifest_document)
        (not
          (dispensing_site_ready_for_shipment_processing ?dispensing_site)
        )
      )
    :effect
      (and
        (distribution_cluster_alternate_selected ?distribution_cluster_profile)
        (dispensing_site_ready_for_shipment_processing ?dispensing_site)
        (dispensing_site_manifest_attached ?dispensing_site ?disposal_manifest_document)
        (not
          (disposal_manifest_available ?disposal_manifest_document)
        )
      )
  )
  (:action finalize_dispensing_site_classification_and_restore_manifest
    :parameters (?dispensing_site - dispensing_site ?distribution_cluster_profile - distribution_cluster_profile ?laboratory_test_slot - laboratory_test_slot ?disposal_manifest_document - disposal_manifest_document)
    :precondition
      (and
        (entity_case_open_for_processing ?dispensing_site)
        (entity_linked_to_laboratory_test_slot ?dispensing_site ?laboratory_test_slot)
        (dispensing_site_assigned_distribution_cluster ?dispensing_site ?distribution_cluster_profile)
        (distribution_cluster_alternate_selected ?distribution_cluster_profile)
        (dispensing_site_manifest_attached ?dispensing_site ?disposal_manifest_document)
        (not
          (dispensing_site_quarantine_marked ?dispensing_site)
        )
      )
    :effect
      (and
        (distribution_cluster_selected ?distribution_cluster_profile)
        (dispensing_site_quarantine_marked ?dispensing_site)
        (disposal_manifest_available ?disposal_manifest_document)
        (not
          (dispensing_site_manifest_attached ?dispensing_site ?disposal_manifest_document)
        )
      )
  )
  (:action create_disposal_shipment_primary
    :parameters (?local_warehouse - local_warehouse ?dispensing_site - dispensing_site ?hazard_classification - hazard_classification ?distribution_cluster_profile - distribution_cluster_profile ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (warehouse_ready_for_shipment_processing ?local_warehouse)
        (dispensing_site_ready_for_shipment_processing ?dispensing_site)
        (warehouse_hazard_classification_assigned ?local_warehouse ?hazard_classification)
        (dispensing_site_assigned_distribution_cluster ?dispensing_site ?distribution_cluster_profile)
        (hazard_classification_confirmed ?hazard_classification)
        (distribution_cluster_selected ?distribution_cluster_profile)
        (warehouse_quarantine_marked ?local_warehouse)
        (dispensing_site_quarantine_marked ?dispensing_site)
        (disposal_shipment_available ?disposal_shipment)
      )
    :effect
      (and
        (disposal_shipment_reserved ?disposal_shipment)
        (disposal_shipment_linked_hazard_classification ?disposal_shipment ?hazard_classification)
        (disposal_shipment_linked_distribution_cluster ?disposal_shipment ?distribution_cluster_profile)
        (not
          (disposal_shipment_available ?disposal_shipment)
        )
      )
  )
  (:action create_disposal_shipment_staging_variant
    :parameters (?local_warehouse - local_warehouse ?dispensing_site - dispensing_site ?hazard_classification - hazard_classification ?distribution_cluster_profile - distribution_cluster_profile ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (warehouse_ready_for_shipment_processing ?local_warehouse)
        (dispensing_site_ready_for_shipment_processing ?dispensing_site)
        (warehouse_hazard_classification_assigned ?local_warehouse ?hazard_classification)
        (dispensing_site_assigned_distribution_cluster ?dispensing_site ?distribution_cluster_profile)
        (hazard_classification_manifest_required ?hazard_classification)
        (distribution_cluster_selected ?distribution_cluster_profile)
        (not
          (warehouse_quarantine_marked ?local_warehouse)
        )
        (dispensing_site_quarantine_marked ?dispensing_site)
        (disposal_shipment_available ?disposal_shipment)
      )
    :effect
      (and
        (disposal_shipment_reserved ?disposal_shipment)
        (disposal_shipment_linked_hazard_classification ?disposal_shipment ?hazard_classification)
        (disposal_shipment_linked_distribution_cluster ?disposal_shipment ?distribution_cluster_profile)
        (disposal_shipment_variant_staging_flag ?disposal_shipment)
        (not
          (disposal_shipment_available ?disposal_shipment)
        )
      )
  )
  (:action create_disposal_shipment_emergency_variant
    :parameters (?local_warehouse - local_warehouse ?dispensing_site - dispensing_site ?hazard_classification - hazard_classification ?distribution_cluster_profile - distribution_cluster_profile ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (warehouse_ready_for_shipment_processing ?local_warehouse)
        (dispensing_site_ready_for_shipment_processing ?dispensing_site)
        (warehouse_hazard_classification_assigned ?local_warehouse ?hazard_classification)
        (dispensing_site_assigned_distribution_cluster ?dispensing_site ?distribution_cluster_profile)
        (hazard_classification_confirmed ?hazard_classification)
        (distribution_cluster_alternate_selected ?distribution_cluster_profile)
        (warehouse_quarantine_marked ?local_warehouse)
        (not
          (dispensing_site_quarantine_marked ?dispensing_site)
        )
        (disposal_shipment_available ?disposal_shipment)
      )
    :effect
      (and
        (disposal_shipment_reserved ?disposal_shipment)
        (disposal_shipment_linked_hazard_classification ?disposal_shipment ?hazard_classification)
        (disposal_shipment_linked_distribution_cluster ?disposal_shipment ?distribution_cluster_profile)
        (disposal_shipment_variant_emergency_flag ?disposal_shipment)
        (not
          (disposal_shipment_available ?disposal_shipment)
        )
      )
  )
  (:action create_disposal_shipment_combined_variants
    :parameters (?local_warehouse - local_warehouse ?dispensing_site - dispensing_site ?hazard_classification - hazard_classification ?distribution_cluster_profile - distribution_cluster_profile ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (warehouse_ready_for_shipment_processing ?local_warehouse)
        (dispensing_site_ready_for_shipment_processing ?dispensing_site)
        (warehouse_hazard_classification_assigned ?local_warehouse ?hazard_classification)
        (dispensing_site_assigned_distribution_cluster ?dispensing_site ?distribution_cluster_profile)
        (hazard_classification_manifest_required ?hazard_classification)
        (distribution_cluster_alternate_selected ?distribution_cluster_profile)
        (not
          (warehouse_quarantine_marked ?local_warehouse)
        )
        (not
          (dispensing_site_quarantine_marked ?dispensing_site)
        )
        (disposal_shipment_available ?disposal_shipment)
      )
    :effect
      (and
        (disposal_shipment_reserved ?disposal_shipment)
        (disposal_shipment_linked_hazard_classification ?disposal_shipment ?hazard_classification)
        (disposal_shipment_linked_distribution_cluster ?disposal_shipment ?distribution_cluster_profile)
        (disposal_shipment_variant_staging_flag ?disposal_shipment)
        (disposal_shipment_variant_emergency_flag ?disposal_shipment)
        (not
          (disposal_shipment_available ?disposal_shipment)
        )
      )
  )
  (:action lock_disposal_shipment_for_execution
    :parameters (?disposal_shipment - disposal_shipment ?local_warehouse - local_warehouse ?laboratory_test_slot - laboratory_test_slot)
    :precondition
      (and
        (disposal_shipment_reserved ?disposal_shipment)
        (warehouse_ready_for_shipment_processing ?local_warehouse)
        (entity_linked_to_laboratory_test_slot ?local_warehouse ?laboratory_test_slot)
        (not
          (disposal_shipment_locked_for_execution ?disposal_shipment)
        )
      )
    :effect (disposal_shipment_locked_for_execution ?disposal_shipment)
  )
  (:action reserve_designated_site_and_bind_to_agent
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?designated_disposal_site - designated_disposal_site ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (entity_case_open_for_processing ?authorised_disposal_agent)
        (agent_assigned_to_disposal_shipment ?authorised_disposal_agent ?disposal_shipment)
        (agent_has_designated_disposal_site ?authorised_disposal_agent ?designated_disposal_site)
        (designated_disposal_site_available ?designated_disposal_site)
        (disposal_shipment_reserved ?disposal_shipment)
        (disposal_shipment_locked_for_execution ?disposal_shipment)
        (not
          (designated_disposal_site_reserved ?designated_disposal_site)
        )
      )
    :effect
      (and
        (designated_disposal_site_reserved ?designated_disposal_site)
        (designated_site_linked_to_disposal_shipment ?designated_disposal_site ?disposal_shipment)
        (not
          (designated_disposal_site_available ?designated_disposal_site)
        )
      )
  )
  (:action validate_agent_designated_site_reservation
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?designated_disposal_site - designated_disposal_site ?disposal_shipment - disposal_shipment ?laboratory_test_slot - laboratory_test_slot)
    :precondition
      (and
        (entity_case_open_for_processing ?authorised_disposal_agent)
        (agent_has_designated_disposal_site ?authorised_disposal_agent ?designated_disposal_site)
        (designated_disposal_site_reserved ?designated_disposal_site)
        (designated_site_linked_to_disposal_shipment ?designated_disposal_site ?disposal_shipment)
        (entity_linked_to_laboratory_test_slot ?authorised_disposal_agent ?laboratory_test_slot)
        (not
          (disposal_shipment_variant_staging_flag ?disposal_shipment)
        )
        (not
          (agent_site_validation_completed ?authorised_disposal_agent)
        )
      )
    :effect (agent_site_validation_completed ?authorised_disposal_agent)
  )
  (:action reserve_environmental_permit_and_bind_to_agent
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?environmental_permit - environmental_permit)
    :precondition
      (and
        (entity_case_open_for_processing ?authorised_disposal_agent)
        (environmental_permit_available ?environmental_permit)
        (not
          (agent_environmental_permit_reserved ?authorised_disposal_agent)
        )
      )
    :effect
      (and
        (agent_environmental_permit_reserved ?authorised_disposal_agent)
        (agent_attached_environmental_permit ?authorised_disposal_agent ?environmental_permit)
        (not
          (environmental_permit_available ?environmental_permit)
        )
      )
  )
  (:action authorize_agent_for_designated_site
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?designated_disposal_site - designated_disposal_site ?disposal_shipment - disposal_shipment ?laboratory_test_slot - laboratory_test_slot ?environmental_permit - environmental_permit)
    :precondition
      (and
        (entity_case_open_for_processing ?authorised_disposal_agent)
        (agent_has_designated_disposal_site ?authorised_disposal_agent ?designated_disposal_site)
        (designated_disposal_site_reserved ?designated_disposal_site)
        (designated_site_linked_to_disposal_shipment ?designated_disposal_site ?disposal_shipment)
        (entity_linked_to_laboratory_test_slot ?authorised_disposal_agent ?laboratory_test_slot)
        (disposal_shipment_variant_staging_flag ?disposal_shipment)
        (agent_environmental_permit_reserved ?authorised_disposal_agent)
        (agent_attached_environmental_permit ?authorised_disposal_agent ?environmental_permit)
        (not
          (agent_site_validation_completed ?authorised_disposal_agent)
        )
      )
    :effect
      (and
        (agent_site_validation_completed ?authorised_disposal_agent)
        (agent_site_authorization_confirmed ?authorised_disposal_agent)
      )
  )
  (:action confirm_agent_incineration_slot_reservation_primary
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?incineration_facility_slot - incineration_facility_slot ?quality_inspector - quality_inspector ?designated_disposal_site - designated_disposal_site ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (agent_site_validation_completed ?authorised_disposal_agent)
        (agent_reserved_incineration_facility_slot ?authorised_disposal_agent ?incineration_facility_slot)
        (entity_assigned_to_quality_inspector ?authorised_disposal_agent ?quality_inspector)
        (agent_has_designated_disposal_site ?authorised_disposal_agent ?designated_disposal_site)
        (designated_site_linked_to_disposal_shipment ?designated_disposal_site ?disposal_shipment)
        (not
          (disposal_shipment_variant_emergency_flag ?disposal_shipment)
        )
        (not
          (agent_incineration_facility_slot_reserved_confirmed ?authorised_disposal_agent)
        )
      )
    :effect (agent_incineration_facility_slot_reserved_confirmed ?authorised_disposal_agent)
  )
  (:action confirm_agent_incineration_slot_reservation_secondary
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?incineration_facility_slot - incineration_facility_slot ?quality_inspector - quality_inspector ?designated_disposal_site - designated_disposal_site ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (agent_site_validation_completed ?authorised_disposal_agent)
        (agent_reserved_incineration_facility_slot ?authorised_disposal_agent ?incineration_facility_slot)
        (entity_assigned_to_quality_inspector ?authorised_disposal_agent ?quality_inspector)
        (agent_has_designated_disposal_site ?authorised_disposal_agent ?designated_disposal_site)
        (designated_site_linked_to_disposal_shipment ?designated_disposal_site ?disposal_shipment)
        (disposal_shipment_variant_emergency_flag ?disposal_shipment)
        (not
          (agent_incineration_facility_slot_reserved_confirmed ?authorised_disposal_agent)
        )
      )
    :effect (agent_incineration_facility_slot_reserved_confirmed ?authorised_disposal_agent)
  )
  (:action confirm_agent_environmental_clearance_binding
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?environmental_clearance_authorization - environmental_clearance_authorization ?designated_disposal_site - designated_disposal_site ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (agent_incineration_facility_slot_reserved_confirmed ?authorised_disposal_agent)
        (agent_reserved_environmental_clearance_authorization ?authorised_disposal_agent ?environmental_clearance_authorization)
        (agent_has_designated_disposal_site ?authorised_disposal_agent ?designated_disposal_site)
        (designated_site_linked_to_disposal_shipment ?designated_disposal_site ?disposal_shipment)
        (not
          (disposal_shipment_variant_staging_flag ?disposal_shipment)
        )
        (not
          (disposal_shipment_variant_emergency_flag ?disposal_shipment)
        )
        (not
          (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        )
      )
    :effect (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
  )
  (:action confirm_agent_environmental_clearance_attach_docs_variant_a
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?environmental_clearance_authorization - environmental_clearance_authorization ?designated_disposal_site - designated_disposal_site ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (agent_incineration_facility_slot_reserved_confirmed ?authorised_disposal_agent)
        (agent_reserved_environmental_clearance_authorization ?authorised_disposal_agent ?environmental_clearance_authorization)
        (agent_has_designated_disposal_site ?authorised_disposal_agent ?designated_disposal_site)
        (designated_site_linked_to_disposal_shipment ?designated_disposal_site ?disposal_shipment)
        (disposal_shipment_variant_staging_flag ?disposal_shipment)
        (not
          (disposal_shipment_variant_emergency_flag ?disposal_shipment)
        )
        (not
          (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        )
      )
    :effect
      (and
        (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        (agent_authorization_documents_attached ?authorised_disposal_agent)
      )
  )
  (:action confirm_agent_environmental_clearance_attach_docs_variant_b
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?environmental_clearance_authorization - environmental_clearance_authorization ?designated_disposal_site - designated_disposal_site ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (agent_incineration_facility_slot_reserved_confirmed ?authorised_disposal_agent)
        (agent_reserved_environmental_clearance_authorization ?authorised_disposal_agent ?environmental_clearance_authorization)
        (agent_has_designated_disposal_site ?authorised_disposal_agent ?designated_disposal_site)
        (designated_site_linked_to_disposal_shipment ?designated_disposal_site ?disposal_shipment)
        (not
          (disposal_shipment_variant_staging_flag ?disposal_shipment)
        )
        (disposal_shipment_variant_emergency_flag ?disposal_shipment)
        (not
          (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        )
      )
    :effect
      (and
        (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        (agent_authorization_documents_attached ?authorised_disposal_agent)
      )
  )
  (:action confirm_agent_environmental_clearance_attach_docs_variant_c
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?environmental_clearance_authorization - environmental_clearance_authorization ?designated_disposal_site - designated_disposal_site ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (agent_incineration_facility_slot_reserved_confirmed ?authorised_disposal_agent)
        (agent_reserved_environmental_clearance_authorization ?authorised_disposal_agent ?environmental_clearance_authorization)
        (agent_has_designated_disposal_site ?authorised_disposal_agent ?designated_disposal_site)
        (designated_site_linked_to_disposal_shipment ?designated_disposal_site ?disposal_shipment)
        (disposal_shipment_variant_staging_flag ?disposal_shipment)
        (disposal_shipment_variant_emergency_flag ?disposal_shipment)
        (not
          (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        )
      )
    :effect
      (and
        (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        (agent_authorization_documents_attached ?authorised_disposal_agent)
      )
  )
  (:action record_agent_final_signoff_and_issue_final_approval
    :parameters (?authorised_disposal_agent - authorised_disposal_agent)
    :precondition
      (and
        (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        (not
          (agent_authorization_documents_attached ?authorised_disposal_agent)
        )
        (not
          (agent_final_signoff_logged ?authorised_disposal_agent)
        )
      )
    :effect
      (and
        (agent_final_signoff_logged ?authorised_disposal_agent)
        (entity_final_disposal_approval ?authorised_disposal_agent)
      )
  )
  (:action assign_neutralisation_kit_to_agent
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?neutralisation_kit - neutralisation_kit)
    :precondition
      (and
        (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        (agent_authorization_documents_attached ?authorised_disposal_agent)
        (neutralisation_kit_available ?neutralisation_kit)
      )
    :effect
      (and
        (agent_assigned_neutralisation_kit ?authorised_disposal_agent ?neutralisation_kit)
        (not
          (neutralisation_kit_available ?neutralisation_kit)
        )
      )
  )
  (:action execute_final_processing_checks_and_mark_agent
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?local_warehouse - local_warehouse ?dispensing_site - dispensing_site ?laboratory_test_slot - laboratory_test_slot ?neutralisation_kit - neutralisation_kit)
    :precondition
      (and
        (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        (agent_authorization_documents_attached ?authorised_disposal_agent)
        (agent_assigned_neutralisation_kit ?authorised_disposal_agent ?neutralisation_kit)
        (agent_attached_to_warehouse ?authorised_disposal_agent ?local_warehouse)
        (agent_attached_to_dispensing_site ?authorised_disposal_agent ?dispensing_site)
        (warehouse_quarantine_marked ?local_warehouse)
        (dispensing_site_quarantine_marked ?dispensing_site)
        (entity_linked_to_laboratory_test_slot ?authorised_disposal_agent ?laboratory_test_slot)
        (not
          (agent_final_processing_completed ?authorised_disposal_agent)
        )
      )
    :effect (agent_final_processing_completed ?authorised_disposal_agent)
  )
  (:action finalize_agent_processing_and_record_signoff
    :parameters (?authorised_disposal_agent - authorised_disposal_agent)
    :precondition
      (and
        (agent_environmental_clearance_confirmed ?authorised_disposal_agent)
        (agent_final_processing_completed ?authorised_disposal_agent)
        (not
          (agent_final_signoff_logged ?authorised_disposal_agent)
        )
      )
    :effect
      (and
        (agent_final_signoff_logged ?authorised_disposal_agent)
        (entity_final_disposal_approval ?authorised_disposal_agent)
      )
  )
  (:action bind_regulatory_approval_to_agent
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?regulatory_approval_document - regulatory_approval_document ?laboratory_test_slot - laboratory_test_slot)
    :precondition
      (and
        (entity_case_open_for_processing ?authorised_disposal_agent)
        (entity_linked_to_laboratory_test_slot ?authorised_disposal_agent ?laboratory_test_slot)
        (regulatory_approval_document_available ?regulatory_approval_document)
        (agent_has_regulatory_approval ?authorised_disposal_agent ?regulatory_approval_document)
        (not
          (agent_regulatory_approval_bound ?authorised_disposal_agent)
        )
      )
    :effect
      (and
        (agent_regulatory_approval_bound ?authorised_disposal_agent)
        (not
          (regulatory_approval_document_available ?regulatory_approval_document)
        )
      )
  )
  (:action set_agent_regulatory_condition_met
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?quality_inspector - quality_inspector)
    :precondition
      (and
        (agent_regulatory_approval_bound ?authorised_disposal_agent)
        (entity_assigned_to_quality_inspector ?authorised_disposal_agent ?quality_inspector)
        (not
          (agent_regulatory_condition_met ?authorised_disposal_agent)
        )
      )
    :effect (agent_regulatory_condition_met ?authorised_disposal_agent)
  )
  (:action validate_agent_environmental_condition
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?environmental_clearance_authorization - environmental_clearance_authorization)
    :precondition
      (and
        (agent_regulatory_condition_met ?authorised_disposal_agent)
        (agent_reserved_environmental_clearance_authorization ?authorised_disposal_agent ?environmental_clearance_authorization)
        (not
          (agent_environmental_condition_validated ?authorised_disposal_agent)
        )
      )
    :effect (agent_environmental_condition_validated ?authorised_disposal_agent)
  )
  (:action record_agent_final_signoff_post_environmental_validation
    :parameters (?authorised_disposal_agent - authorised_disposal_agent)
    :precondition
      (and
        (agent_environmental_condition_validated ?authorised_disposal_agent)
        (not
          (agent_final_signoff_logged ?authorised_disposal_agent)
        )
      )
    :effect
      (and
        (agent_final_signoff_logged ?authorised_disposal_agent)
        (entity_final_disposal_approval ?authorised_disposal_agent)
      )
  )
  (:action record_warehouse_disposal_completion
    :parameters (?local_warehouse - local_warehouse ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (warehouse_ready_for_shipment_processing ?local_warehouse)
        (warehouse_quarantine_marked ?local_warehouse)
        (disposal_shipment_reserved ?disposal_shipment)
        (disposal_shipment_locked_for_execution ?disposal_shipment)
        (not
          (entity_final_disposal_approval ?local_warehouse)
        )
      )
    :effect (entity_final_disposal_approval ?local_warehouse)
  )
  (:action record_dispensing_site_disposal_completion
    :parameters (?dispensing_site - dispensing_site ?disposal_shipment - disposal_shipment)
    :precondition
      (and
        (dispensing_site_ready_for_shipment_processing ?dispensing_site)
        (dispensing_site_quarantine_marked ?dispensing_site)
        (disposal_shipment_reserved ?disposal_shipment)
        (disposal_shipment_locked_for_execution ?disposal_shipment)
        (not
          (entity_final_disposal_approval ?dispensing_site)
        )
      )
    :effect (entity_final_disposal_approval ?dispensing_site)
  )
  (:action issue_disposal_certificate_for_item
    :parameters (?nonconforming_stock_item - nonconforming_stock_item ?disposal_certificate_token - disposal_certificate_token ?laboratory_test_slot - laboratory_test_slot)
    :precondition
      (and
        (entity_final_disposal_approval ?nonconforming_stock_item)
        (entity_linked_to_laboratory_test_slot ?nonconforming_stock_item ?laboratory_test_slot)
        (disposal_certificate_token_available ?disposal_certificate_token)
        (not
          (entity_disposal_certificate_issued ?nonconforming_stock_item)
        )
      )
    :effect
      (and
        (entity_disposal_certificate_issued ?nonconforming_stock_item)
        (entity_linked_to_disposal_certificate_token ?nonconforming_stock_item ?disposal_certificate_token)
        (not
          (disposal_certificate_token_available ?disposal_certificate_token)
        )
      )
  )
  (:action execute_disposal_and_release_resources_at_warehouse
    :parameters (?local_warehouse - local_warehouse ?disposal_container_slot - disposal_container_slot ?disposal_certificate_token - disposal_certificate_token)
    :precondition
      (and
        (entity_disposal_certificate_issued ?local_warehouse)
        (entity_linked_to_container_slot ?local_warehouse ?disposal_container_slot)
        (entity_linked_to_disposal_certificate_token ?local_warehouse ?disposal_certificate_token)
        (not
          (entity_disposal_execution_recorded ?local_warehouse)
        )
      )
    :effect
      (and
        (entity_disposal_execution_recorded ?local_warehouse)
        (disposal_container_slot_available ?disposal_container_slot)
        (disposal_certificate_token_available ?disposal_certificate_token)
      )
  )
  (:action execute_disposal_and_release_resources_at_dispensing_site
    :parameters (?dispensing_site - dispensing_site ?disposal_container_slot - disposal_container_slot ?disposal_certificate_token - disposal_certificate_token)
    :precondition
      (and
        (entity_disposal_certificate_issued ?dispensing_site)
        (entity_linked_to_container_slot ?dispensing_site ?disposal_container_slot)
        (entity_linked_to_disposal_certificate_token ?dispensing_site ?disposal_certificate_token)
        (not
          (entity_disposal_execution_recorded ?dispensing_site)
        )
      )
    :effect
      (and
        (entity_disposal_execution_recorded ?dispensing_site)
        (disposal_container_slot_available ?disposal_container_slot)
        (disposal_certificate_token_available ?disposal_certificate_token)
      )
  )
  (:action execute_disposal_and_release_resources_by_agent
    :parameters (?authorised_disposal_agent - authorised_disposal_agent ?disposal_container_slot - disposal_container_slot ?disposal_certificate_token - disposal_certificate_token)
    :precondition
      (and
        (entity_disposal_certificate_issued ?authorised_disposal_agent)
        (entity_linked_to_container_slot ?authorised_disposal_agent ?disposal_container_slot)
        (entity_linked_to_disposal_certificate_token ?authorised_disposal_agent ?disposal_certificate_token)
        (not
          (entity_disposal_execution_recorded ?authorised_disposal_agent)
        )
      )
    :effect
      (and
        (entity_disposal_execution_recorded ?authorised_disposal_agent)
        (disposal_container_slot_available ?disposal_container_slot)
        (disposal_certificate_token_available ?disposal_certificate_token)
      )
  )
)

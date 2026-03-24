(define (domain logistics_shipment_batch_creation)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_class - object item_class - object zone_class - object fulfillment_class - object fulfillment_entity - fulfillment_class carrier_asset - resource_class service_level - resource_class handling_station - resource_class vehicle_type - resource_class equipment_profile - resource_class time_window - resource_class asset_attribute - resource_class compliance_document - resource_class product_sku - item_class parcel_type - item_class routing_tag - item_class origin_zone - zone_class destination_zone - zone_class shipment_batch - zone_class site_role - fulfillment_entity proposal_role - fulfillment_entity origin_site - site_role destination_site - site_role shipment_proposal - proposal_role)
  (:predicates
    (fulfillment_candidate_registered ?fulfillment_entity - fulfillment_entity)
    (fulfillment_candidate_eligible ?fulfillment_entity - fulfillment_entity)
    (assigned_to_carrier ?fulfillment_entity - fulfillment_entity)
    (sourcing_confirmed ?fulfillment_entity - fulfillment_entity)
    (planning_finalized ?fulfillment_entity - fulfillment_entity)
    (ready_for_assignment ?fulfillment_entity - fulfillment_entity)
    (carrier_available ?carrier_asset - carrier_asset)
    (fulfillment_candidate_to_carrier_link ?fulfillment_entity - fulfillment_entity ?carrier_asset - carrier_asset)
    (service_level_available ?service_level - service_level)
    (fulfillment_candidate_service_assoc ?fulfillment_entity - fulfillment_entity ?service_level - service_level)
    (handling_station_available ?handling_station - handling_station)
    (fulfillment_candidate_to_station_link ?fulfillment_entity - fulfillment_entity ?handling_station - handling_station)
    (sku_staged ?product_sku - product_sku)
    (source_inventory_reservation ?origin_site - origin_site ?product_sku - product_sku)
    (destination_inventory_reservation ?destination_site - destination_site ?product_sku - product_sku)
    (origin_zone_capability ?origin_site - origin_site ?origin_zone - origin_zone)
    (origin_zone_locked_for_batch ?origin_zone - origin_zone)
    (origin_zone_claimed ?origin_zone - origin_zone)
    (origin_ready_flag ?origin_site - origin_site)
    (destination_zone_capability ?destination_site - destination_site ?destination_zone - destination_zone)
    (destination_zone_locked_for_batch ?destination_zone - destination_zone)
    (destination_zone_claimed ?destination_zone - destination_zone)
    (destination_ready_flag ?destination_site - destination_site)
    (batch_slot_available ?shipment_batch - shipment_batch)
    (batch_created ?shipment_batch - shipment_batch)
    (batch_to_origin_link ?shipment_batch - shipment_batch ?origin_zone - origin_zone)
    (batch_to_destination_link ?shipment_batch - shipment_batch ?destination_zone - destination_zone)
    (batch_has_origin_volume ?shipment_batch - shipment_batch)
    (batch_has_destination_volume ?shipment_batch - shipment_batch)
    (batch_load_confirmed ?shipment_batch - shipment_batch)
    (proposal_origin_affinity ?shipment_proposal - shipment_proposal ?origin_site - origin_site)
    (proposal_destination_affinity ?shipment_proposal - shipment_proposal ?destination_site - destination_site)
    (proposal_to_batch_link ?shipment_proposal - shipment_proposal ?shipment_batch - shipment_batch)
    (parcel_type_available ?parcel_type - parcel_type)
    (proposal_has_parcel_type ?shipment_proposal - shipment_proposal ?parcel_type - parcel_type)
    (parcel_type_locked ?parcel_type - parcel_type)
    (parcel_to_batch_link ?parcel_type - parcel_type ?shipment_batch - shipment_batch)
    (proposal_validated_for_loading ?shipment_proposal - shipment_proposal)
    (proposal_pending_finalization ?shipment_proposal - shipment_proposal)
    (proposal_ready_for_finalization ?shipment_proposal - shipment_proposal)
    (proposal_has_vehicle_type ?shipment_proposal - shipment_proposal)
    (proposal_vehicle_bound ?shipment_proposal - shipment_proposal)
    (proposal_has_required_attributes ?shipment_proposal - shipment_proposal)
    (proposal_executed_binding ?shipment_proposal - shipment_proposal)
    (routing_tag_available ?routing_tag - routing_tag)
    (proposal_routing_tag_link ?shipment_proposal - shipment_proposal ?routing_tag - routing_tag)
    (proposal_tagged ?shipment_proposal - shipment_proposal)
    (proposal_tag_binding_confirmed ?shipment_proposal - shipment_proposal)
    (proposal_tag_finalized ?shipment_proposal - shipment_proposal)
    (vehicle_type_unassigned ?vehicle_type - vehicle_type)
    (proposal_to_vehicle_type_link ?shipment_proposal - shipment_proposal ?vehicle_type - vehicle_type)
    (equipment_profile_available ?equipment_profile - equipment_profile)
    (proposal_to_equipment_profile_link ?shipment_proposal - shipment_proposal ?equipment_profile - equipment_profile)
    (asset_attribute_available ?asset_attribute - asset_attribute)
    (proposal_to_asset_attribute_link ?shipment_proposal - shipment_proposal ?asset_attribute - asset_attribute)
    (compliance_document_available ?compliance_document - compliance_document)
    (proposal_to_compliance_link ?shipment_proposal - shipment_proposal ?compliance_document - compliance_document)
    (time_window_available ?time_window - time_window)
    (fulfillment_candidate_to_time_window_link ?fulfillment_entity - fulfillment_entity ?time_window - time_window)
    (origin_site_operational ?origin_site - origin_site)
    (destination_site_operational ?destination_site - destination_site)
    (proposal_marked_executed ?shipment_proposal - shipment_proposal)
  )
  (:action register_fulfillment_candidate
    :parameters (?fulfillment_entity - fulfillment_entity)
    :precondition
      (and
        (not
          (fulfillment_candidate_registered ?fulfillment_entity)
        )
        (not
          (sourcing_confirmed ?fulfillment_entity)
        )
      )
    :effect (fulfillment_candidate_registered ?fulfillment_entity)
  )
  (:action assign_fulfillment_to_carrier
    :parameters (?fulfillment_entity - fulfillment_entity ?carrier_asset - carrier_asset)
    :precondition
      (and
        (fulfillment_candidate_registered ?fulfillment_entity)
        (not
          (assigned_to_carrier ?fulfillment_entity)
        )
        (carrier_available ?carrier_asset)
      )
    :effect
      (and
        (assigned_to_carrier ?fulfillment_entity)
        (fulfillment_candidate_to_carrier_link ?fulfillment_entity ?carrier_asset)
        (not
          (carrier_available ?carrier_asset)
        )
      )
  )
  (:action assign_service_level_to_fulfillment
    :parameters (?fulfillment_entity - fulfillment_entity ?service_level - service_level)
    :precondition
      (and
        (fulfillment_candidate_registered ?fulfillment_entity)
        (assigned_to_carrier ?fulfillment_entity)
        (service_level_available ?service_level)
      )
    :effect
      (and
        (fulfillment_candidate_service_assoc ?fulfillment_entity ?service_level)
        (not
          (service_level_available ?service_level)
        )
      )
  )
  (:action mark_fulfillment_eligible
    :parameters (?fulfillment_entity - fulfillment_entity ?service_level - service_level)
    :precondition
      (and
        (fulfillment_candidate_registered ?fulfillment_entity)
        (assigned_to_carrier ?fulfillment_entity)
        (fulfillment_candidate_service_assoc ?fulfillment_entity ?service_level)
        (not
          (fulfillment_candidate_eligible ?fulfillment_entity)
        )
      )
    :effect (fulfillment_candidate_eligible ?fulfillment_entity)
  )
  (:action release_service_level_from_fulfillment
    :parameters (?fulfillment_entity - fulfillment_entity ?service_level - service_level)
    :precondition
      (and
        (fulfillment_candidate_service_assoc ?fulfillment_entity ?service_level)
      )
    :effect
      (and
        (service_level_available ?service_level)
        (not
          (fulfillment_candidate_service_assoc ?fulfillment_entity ?service_level)
        )
      )
  )
  (:action assign_fulfillment_to_handling_station
    :parameters (?fulfillment_entity - fulfillment_entity ?handling_station - handling_station)
    :precondition
      (and
        (fulfillment_candidate_eligible ?fulfillment_entity)
        (handling_station_available ?handling_station)
      )
    :effect
      (and
        (fulfillment_candidate_to_station_link ?fulfillment_entity ?handling_station)
        (not
          (handling_station_available ?handling_station)
        )
      )
  )
  (:action unassign_fulfillment_from_handling_station
    :parameters (?fulfillment_entity - fulfillment_entity ?handling_station - handling_station)
    :precondition
      (and
        (fulfillment_candidate_to_station_link ?fulfillment_entity ?handling_station)
      )
    :effect
      (and
        (handling_station_available ?handling_station)
        (not
          (fulfillment_candidate_to_station_link ?fulfillment_entity ?handling_station)
        )
      )
  )
  (:action bind_asset_attribute_to_proposal
    :parameters (?shipment_proposal - shipment_proposal ?asset_attribute - asset_attribute)
    :precondition
      (and
        (fulfillment_candidate_eligible ?shipment_proposal)
        (asset_attribute_available ?asset_attribute)
      )
    :effect
      (and
        (proposal_to_asset_attribute_link ?shipment_proposal ?asset_attribute)
        (not
          (asset_attribute_available ?asset_attribute)
        )
      )
  )
  (:action release_asset_attribute_from_proposal
    :parameters (?shipment_proposal - shipment_proposal ?asset_attribute - asset_attribute)
    :precondition
      (and
        (proposal_to_asset_attribute_link ?shipment_proposal ?asset_attribute)
      )
    :effect
      (and
        (asset_attribute_available ?asset_attribute)
        (not
          (proposal_to_asset_attribute_link ?shipment_proposal ?asset_attribute)
        )
      )
  )
  (:action bind_compliance_to_proposal
    :parameters (?shipment_proposal - shipment_proposal ?compliance_document - compliance_document)
    :precondition
      (and
        (fulfillment_candidate_eligible ?shipment_proposal)
        (compliance_document_available ?compliance_document)
      )
    :effect
      (and
        (proposal_to_compliance_link ?shipment_proposal ?compliance_document)
        (not
          (compliance_document_available ?compliance_document)
        )
      )
  )
  (:action release_compliance_from_proposal
    :parameters (?shipment_proposal - shipment_proposal ?compliance_document - compliance_document)
    :precondition
      (and
        (proposal_to_compliance_link ?shipment_proposal ?compliance_document)
      )
    :effect
      (and
        (compliance_document_available ?compliance_document)
        (not
          (proposal_to_compliance_link ?shipment_proposal ?compliance_document)
        )
      )
  )
  (:action lock_origin_zone_for_batch
    :parameters (?origin_site - origin_site ?origin_zone - origin_zone ?service_level - service_level)
    :precondition
      (and
        (fulfillment_candidate_eligible ?origin_site)
        (fulfillment_candidate_service_assoc ?origin_site ?service_level)
        (origin_zone_capability ?origin_site ?origin_zone)
        (not
          (origin_zone_locked_for_batch ?origin_zone)
        )
        (not
          (origin_zone_claimed ?origin_zone)
        )
      )
    :effect (origin_zone_locked_for_batch ?origin_zone)
  )
  (:action signal_origin_site_ready
    :parameters (?origin_site - origin_site ?origin_zone - origin_zone ?handling_station - handling_station)
    :precondition
      (and
        (fulfillment_candidate_eligible ?origin_site)
        (fulfillment_candidate_to_station_link ?origin_site ?handling_station)
        (origin_zone_capability ?origin_site ?origin_zone)
        (origin_zone_locked_for_batch ?origin_zone)
        (not
          (origin_site_operational ?origin_site)
        )
      )
    :effect
      (and
        (origin_site_operational ?origin_site)
        (origin_ready_flag ?origin_site)
      )
  )
  (:action claim_origin_zone_and_reserve_sku
    :parameters (?origin_site - origin_site ?origin_zone - origin_zone ?product_sku - product_sku)
    :precondition
      (and
        (fulfillment_candidate_eligible ?origin_site)
        (origin_zone_capability ?origin_site ?origin_zone)
        (sku_staged ?product_sku)
        (not
          (origin_site_operational ?origin_site)
        )
      )
    :effect
      (and
        (origin_zone_claimed ?origin_zone)
        (origin_site_operational ?origin_site)
        (source_inventory_reservation ?origin_site ?product_sku)
        (not
          (sku_staged ?product_sku)
        )
      )
  )
  (:action consolidate_sku_and_lock_origin_zone
    :parameters (?origin_site - origin_site ?origin_zone - origin_zone ?service_level - service_level ?product_sku - product_sku)
    :precondition
      (and
        (fulfillment_candidate_eligible ?origin_site)
        (fulfillment_candidate_service_assoc ?origin_site ?service_level)
        (origin_zone_capability ?origin_site ?origin_zone)
        (origin_zone_claimed ?origin_zone)
        (source_inventory_reservation ?origin_site ?product_sku)
        (not
          (origin_ready_flag ?origin_site)
        )
      )
    :effect
      (and
        (origin_zone_locked_for_batch ?origin_zone)
        (origin_ready_flag ?origin_site)
        (sku_staged ?product_sku)
        (not
          (source_inventory_reservation ?origin_site ?product_sku)
        )
      )
  )
  (:action lock_destination_zone_for_batch
    :parameters (?destination_site - destination_site ?destination_zone - destination_zone ?service_level - service_level)
    :precondition
      (and
        (fulfillment_candidate_eligible ?destination_site)
        (fulfillment_candidate_service_assoc ?destination_site ?service_level)
        (destination_zone_capability ?destination_site ?destination_zone)
        (not
          (destination_zone_locked_for_batch ?destination_zone)
        )
        (not
          (destination_zone_claimed ?destination_zone)
        )
      )
    :effect (destination_zone_locked_for_batch ?destination_zone)
  )
  (:action signal_destination_site_ready
    :parameters (?destination_site - destination_site ?destination_zone - destination_zone ?handling_station - handling_station)
    :precondition
      (and
        (fulfillment_candidate_eligible ?destination_site)
        (fulfillment_candidate_to_station_link ?destination_site ?handling_station)
        (destination_zone_capability ?destination_site ?destination_zone)
        (destination_zone_locked_for_batch ?destination_zone)
        (not
          (destination_site_operational ?destination_site)
        )
      )
    :effect
      (and
        (destination_site_operational ?destination_site)
        (destination_ready_flag ?destination_site)
      )
  )
  (:action claim_destination_zone_and_reserve_sku
    :parameters (?destination_site - destination_site ?destination_zone - destination_zone ?product_sku - product_sku)
    :precondition
      (and
        (fulfillment_candidate_eligible ?destination_site)
        (destination_zone_capability ?destination_site ?destination_zone)
        (sku_staged ?product_sku)
        (not
          (destination_site_operational ?destination_site)
        )
      )
    :effect
      (and
        (destination_zone_claimed ?destination_zone)
        (destination_site_operational ?destination_site)
        (destination_inventory_reservation ?destination_site ?product_sku)
        (not
          (sku_staged ?product_sku)
        )
      )
  )
  (:action consolidate_sku_and_lock_destination_zone
    :parameters (?destination_site - destination_site ?destination_zone - destination_zone ?service_level - service_level ?product_sku - product_sku)
    :precondition
      (and
        (fulfillment_candidate_eligible ?destination_site)
        (fulfillment_candidate_service_assoc ?destination_site ?service_level)
        (destination_zone_capability ?destination_site ?destination_zone)
        (destination_zone_claimed ?destination_zone)
        (destination_inventory_reservation ?destination_site ?product_sku)
        (not
          (destination_ready_flag ?destination_site)
        )
      )
    :effect
      (and
        (destination_zone_locked_for_batch ?destination_zone)
        (destination_ready_flag ?destination_site)
        (sku_staged ?product_sku)
        (not
          (destination_inventory_reservation ?destination_site ?product_sku)
        )
      )
  )
  (:action create_shipment_batch
    :parameters (?origin_site - origin_site ?destination_site - destination_site ?origin_zone - origin_zone ?destination_zone - destination_zone ?shipment_batch - shipment_batch)
    :precondition
      (and
        (origin_site_operational ?origin_site)
        (destination_site_operational ?destination_site)
        (origin_zone_capability ?origin_site ?origin_zone)
        (destination_zone_capability ?destination_site ?destination_zone)
        (origin_zone_locked_for_batch ?origin_zone)
        (destination_zone_locked_for_batch ?destination_zone)
        (origin_ready_flag ?origin_site)
        (destination_ready_flag ?destination_site)
        (batch_slot_available ?shipment_batch)
      )
    :effect
      (and
        (batch_created ?shipment_batch)
        (batch_to_origin_link ?shipment_batch ?origin_zone)
        (batch_to_destination_link ?shipment_batch ?destination_zone)
        (not
          (batch_slot_available ?shipment_batch)
        )
      )
  )
  (:action create_shipment_batch_with_origin_volume
    :parameters (?origin_site - origin_site ?destination_site - destination_site ?origin_zone - origin_zone ?destination_zone - destination_zone ?shipment_batch - shipment_batch)
    :precondition
      (and
        (origin_site_operational ?origin_site)
        (destination_site_operational ?destination_site)
        (origin_zone_capability ?origin_site ?origin_zone)
        (destination_zone_capability ?destination_site ?destination_zone)
        (origin_zone_claimed ?origin_zone)
        (destination_zone_locked_for_batch ?destination_zone)
        (not
          (origin_ready_flag ?origin_site)
        )
        (destination_ready_flag ?destination_site)
        (batch_slot_available ?shipment_batch)
      )
    :effect
      (and
        (batch_created ?shipment_batch)
        (batch_to_origin_link ?shipment_batch ?origin_zone)
        (batch_to_destination_link ?shipment_batch ?destination_zone)
        (batch_has_origin_volume ?shipment_batch)
        (not
          (batch_slot_available ?shipment_batch)
        )
      )
  )
  (:action create_shipment_batch_with_destination_volume
    :parameters (?origin_site - origin_site ?destination_site - destination_site ?origin_zone - origin_zone ?destination_zone - destination_zone ?shipment_batch - shipment_batch)
    :precondition
      (and
        (origin_site_operational ?origin_site)
        (destination_site_operational ?destination_site)
        (origin_zone_capability ?origin_site ?origin_zone)
        (destination_zone_capability ?destination_site ?destination_zone)
        (origin_zone_locked_for_batch ?origin_zone)
        (destination_zone_claimed ?destination_zone)
        (origin_ready_flag ?origin_site)
        (not
          (destination_ready_flag ?destination_site)
        )
        (batch_slot_available ?shipment_batch)
      )
    :effect
      (and
        (batch_created ?shipment_batch)
        (batch_to_origin_link ?shipment_batch ?origin_zone)
        (batch_to_destination_link ?shipment_batch ?destination_zone)
        (batch_has_destination_volume ?shipment_batch)
        (not
          (batch_slot_available ?shipment_batch)
        )
      )
  )
  (:action create_shipment_batch_with_both_volumes
    :parameters (?origin_site - origin_site ?destination_site - destination_site ?origin_zone - origin_zone ?destination_zone - destination_zone ?shipment_batch - shipment_batch)
    :precondition
      (and
        (origin_site_operational ?origin_site)
        (destination_site_operational ?destination_site)
        (origin_zone_capability ?origin_site ?origin_zone)
        (destination_zone_capability ?destination_site ?destination_zone)
        (origin_zone_claimed ?origin_zone)
        (destination_zone_claimed ?destination_zone)
        (not
          (origin_ready_flag ?origin_site)
        )
        (not
          (destination_ready_flag ?destination_site)
        )
        (batch_slot_available ?shipment_batch)
      )
    :effect
      (and
        (batch_created ?shipment_batch)
        (batch_to_origin_link ?shipment_batch ?origin_zone)
        (batch_to_destination_link ?shipment_batch ?destination_zone)
        (batch_has_origin_volume ?shipment_batch)
        (batch_has_destination_volume ?shipment_batch)
        (not
          (batch_slot_available ?shipment_batch)
        )
      )
  )
  (:action confirm_batch_load
    :parameters (?shipment_batch - shipment_batch ?origin_site - origin_site ?service_level - service_level)
    :precondition
      (and
        (batch_created ?shipment_batch)
        (origin_site_operational ?origin_site)
        (fulfillment_candidate_service_assoc ?origin_site ?service_level)
        (not
          (batch_load_confirmed ?shipment_batch)
        )
      )
    :effect (batch_load_confirmed ?shipment_batch)
  )
  (:action reserve_parcel_type_and_bind_to_batch
    :parameters (?shipment_proposal - shipment_proposal ?parcel_type - parcel_type ?shipment_batch - shipment_batch)
    :precondition
      (and
        (fulfillment_candidate_eligible ?shipment_proposal)
        (proposal_to_batch_link ?shipment_proposal ?shipment_batch)
        (proposal_has_parcel_type ?shipment_proposal ?parcel_type)
        (parcel_type_available ?parcel_type)
        (batch_created ?shipment_batch)
        (batch_load_confirmed ?shipment_batch)
        (not
          (parcel_type_locked ?parcel_type)
        )
      )
    :effect
      (and
        (parcel_type_locked ?parcel_type)
        (parcel_to_batch_link ?parcel_type ?shipment_batch)
        (not
          (parcel_type_available ?parcel_type)
        )
      )
  )
  (:action validate_proposal_for_loading
    :parameters (?shipment_proposal - shipment_proposal ?parcel_type - parcel_type ?shipment_batch - shipment_batch ?service_level - service_level)
    :precondition
      (and
        (fulfillment_candidate_eligible ?shipment_proposal)
        (proposal_has_parcel_type ?shipment_proposal ?parcel_type)
        (parcel_type_locked ?parcel_type)
        (parcel_to_batch_link ?parcel_type ?shipment_batch)
        (fulfillment_candidate_service_assoc ?shipment_proposal ?service_level)
        (not
          (batch_has_origin_volume ?shipment_batch)
        )
        (not
          (proposal_validated_for_loading ?shipment_proposal)
        )
      )
    :effect (proposal_validated_for_loading ?shipment_proposal)
  )
  (:action assign_vehicle_type_to_proposal
    :parameters (?shipment_proposal - shipment_proposal ?vehicle_type - vehicle_type)
    :precondition
      (and
        (fulfillment_candidate_eligible ?shipment_proposal)
        (vehicle_type_unassigned ?vehicle_type)
        (not
          (proposal_has_vehicle_type ?shipment_proposal)
        )
      )
    :effect
      (and
        (proposal_has_vehicle_type ?shipment_proposal)
        (proposal_to_vehicle_type_link ?shipment_proposal ?vehicle_type)
        (not
          (vehicle_type_unassigned ?vehicle_type)
        )
      )
  )
  (:action bind_vehicle_type_and_validate_proposal
    :parameters (?shipment_proposal - shipment_proposal ?parcel_type - parcel_type ?shipment_batch - shipment_batch ?service_level - service_level ?vehicle_type - vehicle_type)
    :precondition
      (and
        (fulfillment_candidate_eligible ?shipment_proposal)
        (proposal_has_parcel_type ?shipment_proposal ?parcel_type)
        (parcel_type_locked ?parcel_type)
        (parcel_to_batch_link ?parcel_type ?shipment_batch)
        (fulfillment_candidate_service_assoc ?shipment_proposal ?service_level)
        (batch_has_origin_volume ?shipment_batch)
        (proposal_has_vehicle_type ?shipment_proposal)
        (proposal_to_vehicle_type_link ?shipment_proposal ?vehicle_type)
        (not
          (proposal_validated_for_loading ?shipment_proposal)
        )
      )
    :effect
      (and
        (proposal_validated_for_loading ?shipment_proposal)
        (proposal_vehicle_bound ?shipment_proposal)
      )
  )
  (:action set_proposal_pending_finalization_no_destination_volume
    :parameters (?shipment_proposal - shipment_proposal ?asset_attribute - asset_attribute ?handling_station - handling_station ?parcel_type - parcel_type ?shipment_batch - shipment_batch)
    :precondition
      (and
        (proposal_validated_for_loading ?shipment_proposal)
        (proposal_to_asset_attribute_link ?shipment_proposal ?asset_attribute)
        (fulfillment_candidate_to_station_link ?shipment_proposal ?handling_station)
        (proposal_has_parcel_type ?shipment_proposal ?parcel_type)
        (parcel_to_batch_link ?parcel_type ?shipment_batch)
        (not
          (batch_has_destination_volume ?shipment_batch)
        )
        (not
          (proposal_pending_finalization ?shipment_proposal)
        )
      )
    :effect (proposal_pending_finalization ?shipment_proposal)
  )
  (:action set_proposal_pending_finalization_with_destination_volume
    :parameters (?shipment_proposal - shipment_proposal ?asset_attribute - asset_attribute ?handling_station - handling_station ?parcel_type - parcel_type ?shipment_batch - shipment_batch)
    :precondition
      (and
        (proposal_validated_for_loading ?shipment_proposal)
        (proposal_to_asset_attribute_link ?shipment_proposal ?asset_attribute)
        (fulfillment_candidate_to_station_link ?shipment_proposal ?handling_station)
        (proposal_has_parcel_type ?shipment_proposal ?parcel_type)
        (parcel_to_batch_link ?parcel_type ?shipment_batch)
        (batch_has_destination_volume ?shipment_batch)
        (not
          (proposal_pending_finalization ?shipment_proposal)
        )
      )
    :effect (proposal_pending_finalization ?shipment_proposal)
  )
  (:action prepare_proposal_for_finalization_no_batch_volume
    :parameters (?shipment_proposal - shipment_proposal ?compliance_document - compliance_document ?parcel_type - parcel_type ?shipment_batch - shipment_batch)
    :precondition
      (and
        (proposal_pending_finalization ?shipment_proposal)
        (proposal_to_compliance_link ?shipment_proposal ?compliance_document)
        (proposal_has_parcel_type ?shipment_proposal ?parcel_type)
        (parcel_to_batch_link ?parcel_type ?shipment_batch)
        (not
          (batch_has_origin_volume ?shipment_batch)
        )
        (not
          (batch_has_destination_volume ?shipment_batch)
        )
        (not
          (proposal_ready_for_finalization ?shipment_proposal)
        )
      )
    :effect (proposal_ready_for_finalization ?shipment_proposal)
  )
  (:action prepare_proposal_for_finalization_with_origin_volume
    :parameters (?shipment_proposal - shipment_proposal ?compliance_document - compliance_document ?parcel_type - parcel_type ?shipment_batch - shipment_batch)
    :precondition
      (and
        (proposal_pending_finalization ?shipment_proposal)
        (proposal_to_compliance_link ?shipment_proposal ?compliance_document)
        (proposal_has_parcel_type ?shipment_proposal ?parcel_type)
        (parcel_to_batch_link ?parcel_type ?shipment_batch)
        (batch_has_origin_volume ?shipment_batch)
        (not
          (batch_has_destination_volume ?shipment_batch)
        )
        (not
          (proposal_ready_for_finalization ?shipment_proposal)
        )
      )
    :effect
      (and
        (proposal_ready_for_finalization ?shipment_proposal)
        (proposal_has_required_attributes ?shipment_proposal)
      )
  )
  (:action prepare_proposal_for_finalization_with_destination_volume
    :parameters (?shipment_proposal - shipment_proposal ?compliance_document - compliance_document ?parcel_type - parcel_type ?shipment_batch - shipment_batch)
    :precondition
      (and
        (proposal_pending_finalization ?shipment_proposal)
        (proposal_to_compliance_link ?shipment_proposal ?compliance_document)
        (proposal_has_parcel_type ?shipment_proposal ?parcel_type)
        (parcel_to_batch_link ?parcel_type ?shipment_batch)
        (not
          (batch_has_origin_volume ?shipment_batch)
        )
        (batch_has_destination_volume ?shipment_batch)
        (not
          (proposal_ready_for_finalization ?shipment_proposal)
        )
      )
    :effect
      (and
        (proposal_ready_for_finalization ?shipment_proposal)
        (proposal_has_required_attributes ?shipment_proposal)
      )
  )
  (:action prepare_proposal_for_finalization_with_both_volumes
    :parameters (?shipment_proposal - shipment_proposal ?compliance_document - compliance_document ?parcel_type - parcel_type ?shipment_batch - shipment_batch)
    :precondition
      (and
        (proposal_pending_finalization ?shipment_proposal)
        (proposal_to_compliance_link ?shipment_proposal ?compliance_document)
        (proposal_has_parcel_type ?shipment_proposal ?parcel_type)
        (parcel_to_batch_link ?parcel_type ?shipment_batch)
        (batch_has_origin_volume ?shipment_batch)
        (batch_has_destination_volume ?shipment_batch)
        (not
          (proposal_ready_for_finalization ?shipment_proposal)
        )
      )
    :effect
      (and
        (proposal_ready_for_finalization ?shipment_proposal)
        (proposal_has_required_attributes ?shipment_proposal)
      )
  )
  (:action finalize_proposal_no_required_attributes
    :parameters (?shipment_proposal - shipment_proposal)
    :precondition
      (and
        (proposal_ready_for_finalization ?shipment_proposal)
        (not
          (proposal_has_required_attributes ?shipment_proposal)
        )
        (not
          (proposal_marked_executed ?shipment_proposal)
        )
      )
    :effect
      (and
        (proposal_marked_executed ?shipment_proposal)
        (planning_finalized ?shipment_proposal)
      )
  )
  (:action assign_equipment_profile_to_proposal
    :parameters (?shipment_proposal - shipment_proposal ?equipment_profile - equipment_profile)
    :precondition
      (and
        (proposal_ready_for_finalization ?shipment_proposal)
        (proposal_has_required_attributes ?shipment_proposal)
        (equipment_profile_available ?equipment_profile)
      )
    :effect
      (and
        (proposal_to_equipment_profile_link ?shipment_proposal ?equipment_profile)
        (not
          (equipment_profile_available ?equipment_profile)
        )
      )
  )
  (:action execute_proposal_binding
    :parameters (?shipment_proposal - shipment_proposal ?origin_site - origin_site ?destination_site - destination_site ?service_level - service_level ?equipment_profile - equipment_profile)
    :precondition
      (and
        (proposal_ready_for_finalization ?shipment_proposal)
        (proposal_has_required_attributes ?shipment_proposal)
        (proposal_to_equipment_profile_link ?shipment_proposal ?equipment_profile)
        (proposal_origin_affinity ?shipment_proposal ?origin_site)
        (proposal_destination_affinity ?shipment_proposal ?destination_site)
        (origin_ready_flag ?origin_site)
        (destination_ready_flag ?destination_site)
        (fulfillment_candidate_service_assoc ?shipment_proposal ?service_level)
        (not
          (proposal_executed_binding ?shipment_proposal)
        )
      )
    :effect (proposal_executed_binding ?shipment_proposal)
  )
  (:action finalize_proposal_after_binding
    :parameters (?shipment_proposal - shipment_proposal)
    :precondition
      (and
        (proposal_ready_for_finalization ?shipment_proposal)
        (proposal_executed_binding ?shipment_proposal)
        (not
          (proposal_marked_executed ?shipment_proposal)
        )
      )
    :effect
      (and
        (proposal_marked_executed ?shipment_proposal)
        (planning_finalized ?shipment_proposal)
      )
  )
  (:action assign_routing_tag_to_proposal
    :parameters (?shipment_proposal - shipment_proposal ?routing_tag - routing_tag ?service_level - service_level)
    :precondition
      (and
        (fulfillment_candidate_eligible ?shipment_proposal)
        (fulfillment_candidate_service_assoc ?shipment_proposal ?service_level)
        (routing_tag_available ?routing_tag)
        (proposal_routing_tag_link ?shipment_proposal ?routing_tag)
        (not
          (proposal_tagged ?shipment_proposal)
        )
      )
    :effect
      (and
        (proposal_tagged ?shipment_proposal)
        (not
          (routing_tag_available ?routing_tag)
        )
      )
  )
  (:action confirm_routing_tag_binding
    :parameters (?shipment_proposal - shipment_proposal ?handling_station - handling_station)
    :precondition
      (and
        (proposal_tagged ?shipment_proposal)
        (fulfillment_candidate_to_station_link ?shipment_proposal ?handling_station)
        (not
          (proposal_tag_binding_confirmed ?shipment_proposal)
        )
      )
    :effect (proposal_tag_binding_confirmed ?shipment_proposal)
  )
  (:action finalize_tag_binding
    :parameters (?shipment_proposal - shipment_proposal ?compliance_document - compliance_document)
    :precondition
      (and
        (proposal_tag_binding_confirmed ?shipment_proposal)
        (proposal_to_compliance_link ?shipment_proposal ?compliance_document)
        (not
          (proposal_tag_finalized ?shipment_proposal)
        )
      )
    :effect (proposal_tag_finalized ?shipment_proposal)
  )
  (:action finalize_proposal_after_tag_finalization
    :parameters (?shipment_proposal - shipment_proposal)
    :precondition
      (and
        (proposal_tag_finalized ?shipment_proposal)
        (not
          (proposal_marked_executed ?shipment_proposal)
        )
      )
    :effect
      (and
        (proposal_marked_executed ?shipment_proposal)
        (planning_finalized ?shipment_proposal)
      )
  )
  (:action confirm_origin_site_finalization
    :parameters (?origin_site - origin_site ?shipment_batch - shipment_batch)
    :precondition
      (and
        (origin_site_operational ?origin_site)
        (origin_ready_flag ?origin_site)
        (batch_created ?shipment_batch)
        (batch_load_confirmed ?shipment_batch)
        (not
          (planning_finalized ?origin_site)
        )
      )
    :effect (planning_finalized ?origin_site)
  )
  (:action confirm_destination_site_finalization
    :parameters (?destination_site - destination_site ?shipment_batch - shipment_batch)
    :precondition
      (and
        (destination_site_operational ?destination_site)
        (destination_ready_flag ?destination_site)
        (batch_created ?shipment_batch)
        (batch_load_confirmed ?shipment_batch)
        (not
          (planning_finalized ?destination_site)
        )
      )
    :effect (planning_finalized ?destination_site)
  )
  (:action assign_time_window_to_fulfillment_and_mark_ready
    :parameters (?fulfillment_entity - fulfillment_entity ?time_window - time_window ?service_level - service_level)
    :precondition
      (and
        (planning_finalized ?fulfillment_entity)
        (fulfillment_candidate_service_assoc ?fulfillment_entity ?service_level)
        (time_window_available ?time_window)
        (not
          (ready_for_assignment ?fulfillment_entity)
        )
      )
    :effect
      (and
        (ready_for_assignment ?fulfillment_entity)
        (fulfillment_candidate_to_time_window_link ?fulfillment_entity ?time_window)
        (not
          (time_window_available ?time_window)
        )
      )
  )
  (:action confirm_sourcing_for_origin_and_allocate_carrier
    :parameters (?origin_site - origin_site ?carrier_asset - carrier_asset ?time_window - time_window)
    :precondition
      (and
        (ready_for_assignment ?origin_site)
        (fulfillment_candidate_to_carrier_link ?origin_site ?carrier_asset)
        (fulfillment_candidate_to_time_window_link ?origin_site ?time_window)
        (not
          (sourcing_confirmed ?origin_site)
        )
      )
    :effect
      (and
        (sourcing_confirmed ?origin_site)
        (carrier_available ?carrier_asset)
        (time_window_available ?time_window)
      )
  )
  (:action confirm_sourcing_for_destination_and_allocate_carrier
    :parameters (?destination_site - destination_site ?carrier_asset - carrier_asset ?time_window - time_window)
    :precondition
      (and
        (ready_for_assignment ?destination_site)
        (fulfillment_candidate_to_carrier_link ?destination_site ?carrier_asset)
        (fulfillment_candidate_to_time_window_link ?destination_site ?time_window)
        (not
          (sourcing_confirmed ?destination_site)
        )
      )
    :effect
      (and
        (sourcing_confirmed ?destination_site)
        (carrier_available ?carrier_asset)
        (time_window_available ?time_window)
      )
  )
  (:action confirm_sourcing_for_proposal_and_allocate_carrier
    :parameters (?shipment_proposal - shipment_proposal ?carrier_asset - carrier_asset ?time_window - time_window)
    :precondition
      (and
        (ready_for_assignment ?shipment_proposal)
        (fulfillment_candidate_to_carrier_link ?shipment_proposal ?carrier_asset)
        (fulfillment_candidate_to_time_window_link ?shipment_proposal ?time_window)
        (not
          (sourcing_confirmed ?shipment_proposal)
        )
      )
    :effect
      (and
        (sourcing_confirmed ?shipment_proposal)
        (carrier_available ?carrier_asset)
        (time_window_available ?time_window)
      )
  )
)

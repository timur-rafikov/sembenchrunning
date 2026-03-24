(define (domain warehouse_damaged_stock_segmentation_and_disposition)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource - object asset_class - object segmentation_class - object inventory_entity_class - object stock_unit - inventory_entity_class material_handler - operational_resource inspector - operational_resource warehouse_operator - operational_resource transport_asset - operational_resource handling_profile - operational_resource disposition_order - operational_resource quality_tag - operational_resource inspection_report - operational_resource disposition_tag - asset_class pallet_asset - asset_class approval_token - asset_class damage_category - segmentation_class damage_subcategory - segmentation_class transfer_container - segmentation_class stock_group - stock_unit work_order_group - stock_unit source_location - stock_group destination_location - stock_group work_order - work_order_group)
  (:predicates
    (stock_received ?stock_unit - stock_unit)
    (inspection_cleared ?stock_unit - stock_unit)
    (inspection_requested ?stock_unit - stock_unit)
    (disposition_finalized ?stock_unit - stock_unit)
    (ready_for_disposition ?stock_unit - stock_unit)
    (disposition_assigned ?stock_unit - stock_unit)
    (handler_available ?material_handler - material_handler)
    (assigned_to_handler ?stock_unit - stock_unit ?material_handler - material_handler)
    (inspector_available ?inspector - inspector)
    (assigned_to_inspector ?stock_unit - stock_unit ?inspector - inspector)
    (operator_available ?warehouse_operator - warehouse_operator)
    (assigned_to_operator ?stock_unit - stock_unit ?warehouse_operator - warehouse_operator)
    (disposition_tag_available ?disposition_tag - disposition_tag)
    (source_has_disposition_tag ?source_location - source_location ?disposition_tag - disposition_tag)
    (destination_has_disposition_tag ?destination_location - destination_location ?disposition_tag - disposition_tag)
    (location_assigned_damage_category ?source_location - source_location ?damage_category - damage_category)
    (damage_category_staged ?damage_category - damage_category)
    (damage_category_tagged ?damage_category - damage_category)
    (location_ready_for_consolidation ?source_location - source_location)
    (destination_assigned_damage_subcategory ?destination_location - destination_location ?damage_subcategory - damage_subcategory)
    (damage_subcategory_staged ?damage_subcategory - damage_subcategory)
    (damage_subcategory_tagged ?damage_subcategory - damage_subcategory)
    (destination_ready_for_consolidation ?destination_location - destination_location)
    (container_available ?transfer_container - transfer_container)
    (container_reserved ?transfer_container - transfer_container)
    (container_assigned_damage_category ?transfer_container - transfer_container ?damage_category - damage_category)
    (container_assigned_damage_subcategory ?transfer_container - transfer_container ?damage_subcategory - damage_subcategory)
    (container_needs_handling_profile ?transfer_container - transfer_container)
    (container_needs_transport_asset ?transfer_container - transfer_container)
    (container_sealed ?transfer_container - transfer_container)
    (work_order_assigned_source ?work_order - work_order ?source_location - source_location)
    (work_order_assigned_destination ?work_order - work_order ?destination_location - destination_location)
    (work_order_assigned_container ?work_order - work_order ?transfer_container - transfer_container)
    (pallet_available ?pallet_asset - pallet_asset)
    (work_order_assigned_pallet ?work_order - work_order ?pallet_asset - pallet_asset)
    (pallet_reserved ?pallet_asset - pallet_asset)
    (pallet_assigned_container ?pallet_asset - pallet_asset ?transfer_container - transfer_container)
    (work_order_packaging_prepared ?work_order - work_order)
    (work_order_transport_prepared ?work_order - work_order)
    (work_order_ready_for_finalization ?work_order - work_order)
    (transport_asset_allocated ?work_order - work_order)
    (work_order_transport_stage_recorded ?work_order - work_order)
    (handling_profile_requested ?work_order - work_order)
    (work_order_ready_for_movement ?work_order - work_order)
    (approval_token_available ?approval_token - approval_token)
    (work_order_assigned_approval_token ?work_order - work_order ?approval_token - approval_token)
    (work_order_approved ?work_order - work_order)
    (work_order_approval_recorded ?work_order - work_order)
    (work_order_approval_finalized ?work_order - work_order)
    (transport_asset_available ?transport_asset - transport_asset)
    (work_order_assigned_transport_asset ?work_order - work_order ?transport_asset - transport_asset)
    (handling_profile_available ?handling_profile - handling_profile)
    (work_order_assigned_handling_profile ?work_order - work_order ?handling_profile - handling_profile)
    (quality_tag_available ?quality_tag - quality_tag)
    (work_order_assigned_quality_tag ?work_order - work_order ?quality_tag - quality_tag)
    (inspection_report_available ?inspection_report - inspection_report)
    (work_order_assigned_inspection_report ?work_order - work_order ?inspection_report - inspection_report)
    (disposition_order_available ?disposition_order - disposition_order)
    (assigned_disposition_order ?stock_unit - stock_unit ?disposition_order - disposition_order)
    (location_processing_locked ?source_location - source_location)
    (destination_processing_locked ?destination_location - destination_location)
    (work_order_inventory_reconciled ?work_order - work_order)
  )
  (:action register_stock_receipt
    :parameters (?stock_unit - stock_unit)
    :precondition
      (and
        (not
          (stock_received ?stock_unit)
        )
        (not
          (disposition_finalized ?stock_unit)
        )
      )
    :effect (stock_received ?stock_unit)
  )
  (:action assign_material_handler
    :parameters (?stock_unit - stock_unit ?material_handler - material_handler)
    :precondition
      (and
        (stock_received ?stock_unit)
        (not
          (inspection_requested ?stock_unit)
        )
        (handler_available ?material_handler)
      )
    :effect
      (and
        (inspection_requested ?stock_unit)
        (assigned_to_handler ?stock_unit ?material_handler)
        (not
          (handler_available ?material_handler)
        )
      )
  )
  (:action assign_inspector
    :parameters (?stock_unit - stock_unit ?inspector - inspector)
    :precondition
      (and
        (stock_received ?stock_unit)
        (inspection_requested ?stock_unit)
        (inspector_available ?inspector)
      )
    :effect
      (and
        (assigned_to_inspector ?stock_unit ?inspector)
        (not
          (inspector_available ?inspector)
        )
      )
  )
  (:action finalize_inspection
    :parameters (?stock_unit - stock_unit ?inspector - inspector)
    :precondition
      (and
        (stock_received ?stock_unit)
        (inspection_requested ?stock_unit)
        (assigned_to_inspector ?stock_unit ?inspector)
        (not
          (inspection_cleared ?stock_unit)
        )
      )
    :effect (inspection_cleared ?stock_unit)
  )
  (:action release_inspector
    :parameters (?stock_unit - stock_unit ?inspector - inspector)
    :precondition
      (and
        (assigned_to_inspector ?stock_unit ?inspector)
      )
    :effect
      (and
        (inspector_available ?inspector)
        (not
          (assigned_to_inspector ?stock_unit ?inspector)
        )
      )
  )
  (:action assign_warehouse_operator
    :parameters (?stock_unit - stock_unit ?warehouse_operator - warehouse_operator)
    :precondition
      (and
        (inspection_cleared ?stock_unit)
        (operator_available ?warehouse_operator)
      )
    :effect
      (and
        (assigned_to_operator ?stock_unit ?warehouse_operator)
        (not
          (operator_available ?warehouse_operator)
        )
      )
  )
  (:action release_warehouse_operator
    :parameters (?stock_unit - stock_unit ?warehouse_operator - warehouse_operator)
    :precondition
      (and
        (assigned_to_operator ?stock_unit ?warehouse_operator)
      )
    :effect
      (and
        (operator_available ?warehouse_operator)
        (not
          (assigned_to_operator ?stock_unit ?warehouse_operator)
        )
      )
  )
  (:action assign_quality_tag
    :parameters (?work_order - work_order ?quality_tag - quality_tag)
    :precondition
      (and
        (inspection_cleared ?work_order)
        (quality_tag_available ?quality_tag)
      )
    :effect
      (and
        (work_order_assigned_quality_tag ?work_order ?quality_tag)
        (not
          (quality_tag_available ?quality_tag)
        )
      )
  )
  (:action release_quality_tag
    :parameters (?work_order - work_order ?quality_tag - quality_tag)
    :precondition
      (and
        (work_order_assigned_quality_tag ?work_order ?quality_tag)
      )
    :effect
      (and
        (quality_tag_available ?quality_tag)
        (not
          (work_order_assigned_quality_tag ?work_order ?quality_tag)
        )
      )
  )
  (:action assign_inspection_report
    :parameters (?work_order - work_order ?inspection_report - inspection_report)
    :precondition
      (and
        (inspection_cleared ?work_order)
        (inspection_report_available ?inspection_report)
      )
    :effect
      (and
        (work_order_assigned_inspection_report ?work_order ?inspection_report)
        (not
          (inspection_report_available ?inspection_report)
        )
      )
  )
  (:action release_inspection_report
    :parameters (?work_order - work_order ?inspection_report - inspection_report)
    :precondition
      (and
        (work_order_assigned_inspection_report ?work_order ?inspection_report)
      )
    :effect
      (and
        (inspection_report_available ?inspection_report)
        (not
          (work_order_assigned_inspection_report ?work_order ?inspection_report)
        )
      )
  )
  (:action stage_damage_category
    :parameters (?source_location - source_location ?damage_category - damage_category ?inspector - inspector)
    :precondition
      (and
        (inspection_cleared ?source_location)
        (assigned_to_inspector ?source_location ?inspector)
        (location_assigned_damage_category ?source_location ?damage_category)
        (not
          (damage_category_staged ?damage_category)
        )
        (not
          (damage_category_tagged ?damage_category)
        )
      )
    :effect (damage_category_staged ?damage_category)
  )
  (:action lock_location_for_consolidation
    :parameters (?source_location - source_location ?damage_category - damage_category ?warehouse_operator - warehouse_operator)
    :precondition
      (and
        (inspection_cleared ?source_location)
        (assigned_to_operator ?source_location ?warehouse_operator)
        (location_assigned_damage_category ?source_location ?damage_category)
        (damage_category_staged ?damage_category)
        (not
          (location_processing_locked ?source_location)
        )
      )
    :effect
      (and
        (location_processing_locked ?source_location)
        (location_ready_for_consolidation ?source_location)
      )
  )
  (:action apply_disposition_tag_to_source
    :parameters (?source_location - source_location ?damage_category - damage_category ?disposition_tag - disposition_tag)
    :precondition
      (and
        (inspection_cleared ?source_location)
        (location_assigned_damage_category ?source_location ?damage_category)
        (disposition_tag_available ?disposition_tag)
        (not
          (location_processing_locked ?source_location)
        )
      )
    :effect
      (and
        (damage_category_tagged ?damage_category)
        (location_processing_locked ?source_location)
        (source_has_disposition_tag ?source_location ?disposition_tag)
        (not
          (disposition_tag_available ?disposition_tag)
        )
      )
  )
  (:action confirm_damage_segmentation_on_source
    :parameters (?source_location - source_location ?damage_category - damage_category ?inspector - inspector ?disposition_tag - disposition_tag)
    :precondition
      (and
        (inspection_cleared ?source_location)
        (assigned_to_inspector ?source_location ?inspector)
        (location_assigned_damage_category ?source_location ?damage_category)
        (damage_category_tagged ?damage_category)
        (source_has_disposition_tag ?source_location ?disposition_tag)
        (not
          (location_ready_for_consolidation ?source_location)
        )
      )
    :effect
      (and
        (damage_category_staged ?damage_category)
        (location_ready_for_consolidation ?source_location)
        (disposition_tag_available ?disposition_tag)
        (not
          (source_has_disposition_tag ?source_location ?disposition_tag)
        )
      )
  )
  (:action stage_damage_subcategory
    :parameters (?destination_location - destination_location ?damage_subcategory - damage_subcategory ?inspector - inspector)
    :precondition
      (and
        (inspection_cleared ?destination_location)
        (assigned_to_inspector ?destination_location ?inspector)
        (destination_assigned_damage_subcategory ?destination_location ?damage_subcategory)
        (not
          (damage_subcategory_staged ?damage_subcategory)
        )
        (not
          (damage_subcategory_tagged ?damage_subcategory)
        )
      )
    :effect (damage_subcategory_staged ?damage_subcategory)
  )
  (:action lock_destination_for_consolidation
    :parameters (?destination_location - destination_location ?damage_subcategory - damage_subcategory ?warehouse_operator - warehouse_operator)
    :precondition
      (and
        (inspection_cleared ?destination_location)
        (assigned_to_operator ?destination_location ?warehouse_operator)
        (destination_assigned_damage_subcategory ?destination_location ?damage_subcategory)
        (damage_subcategory_staged ?damage_subcategory)
        (not
          (destination_processing_locked ?destination_location)
        )
      )
    :effect
      (and
        (destination_processing_locked ?destination_location)
        (destination_ready_for_consolidation ?destination_location)
      )
  )
  (:action apply_disposition_tag_to_destination
    :parameters (?destination_location - destination_location ?damage_subcategory - damage_subcategory ?disposition_tag - disposition_tag)
    :precondition
      (and
        (inspection_cleared ?destination_location)
        (destination_assigned_damage_subcategory ?destination_location ?damage_subcategory)
        (disposition_tag_available ?disposition_tag)
        (not
          (destination_processing_locked ?destination_location)
        )
      )
    :effect
      (and
        (damage_subcategory_tagged ?damage_subcategory)
        (destination_processing_locked ?destination_location)
        (destination_has_disposition_tag ?destination_location ?disposition_tag)
        (not
          (disposition_tag_available ?disposition_tag)
        )
      )
  )
  (:action confirm_damage_segmentation_on_destination
    :parameters (?destination_location - destination_location ?damage_subcategory - damage_subcategory ?inspector - inspector ?disposition_tag - disposition_tag)
    :precondition
      (and
        (inspection_cleared ?destination_location)
        (assigned_to_inspector ?destination_location ?inspector)
        (destination_assigned_damage_subcategory ?destination_location ?damage_subcategory)
        (damage_subcategory_tagged ?damage_subcategory)
        (destination_has_disposition_tag ?destination_location ?disposition_tag)
        (not
          (destination_ready_for_consolidation ?destination_location)
        )
      )
    :effect
      (and
        (damage_subcategory_staged ?damage_subcategory)
        (destination_ready_for_consolidation ?destination_location)
        (disposition_tag_available ?disposition_tag)
        (not
          (destination_has_disposition_tag ?destination_location ?disposition_tag)
        )
      )
  )
  (:action prepare_transfer_container
    :parameters (?source_location - source_location ?destination_location - destination_location ?damage_category - damage_category ?damage_subcategory - damage_subcategory ?transfer_container - transfer_container)
    :precondition
      (and
        (location_processing_locked ?source_location)
        (destination_processing_locked ?destination_location)
        (location_assigned_damage_category ?source_location ?damage_category)
        (destination_assigned_damage_subcategory ?destination_location ?damage_subcategory)
        (damage_category_staged ?damage_category)
        (damage_subcategory_staged ?damage_subcategory)
        (location_ready_for_consolidation ?source_location)
        (destination_ready_for_consolidation ?destination_location)
        (container_available ?transfer_container)
      )
    :effect
      (and
        (container_reserved ?transfer_container)
        (container_assigned_damage_category ?transfer_container ?damage_category)
        (container_assigned_damage_subcategory ?transfer_container ?damage_subcategory)
        (not
          (container_available ?transfer_container)
        )
      )
  )
  (:action prepare_container_for_handling
    :parameters (?source_location - source_location ?destination_location - destination_location ?damage_category - damage_category ?damage_subcategory - damage_subcategory ?transfer_container - transfer_container)
    :precondition
      (and
        (location_processing_locked ?source_location)
        (destination_processing_locked ?destination_location)
        (location_assigned_damage_category ?source_location ?damage_category)
        (destination_assigned_damage_subcategory ?destination_location ?damage_subcategory)
        (damage_category_tagged ?damage_category)
        (damage_subcategory_staged ?damage_subcategory)
        (not
          (location_ready_for_consolidation ?source_location)
        )
        (destination_ready_for_consolidation ?destination_location)
        (container_available ?transfer_container)
      )
    :effect
      (and
        (container_reserved ?transfer_container)
        (container_assigned_damage_category ?transfer_container ?damage_category)
        (container_assigned_damage_subcategory ?transfer_container ?damage_subcategory)
        (container_needs_handling_profile ?transfer_container)
        (not
          (container_available ?transfer_container)
        )
      )
  )
  (:action prepare_container_for_transport
    :parameters (?source_location - source_location ?destination_location - destination_location ?damage_category - damage_category ?damage_subcategory - damage_subcategory ?transfer_container - transfer_container)
    :precondition
      (and
        (location_processing_locked ?source_location)
        (destination_processing_locked ?destination_location)
        (location_assigned_damage_category ?source_location ?damage_category)
        (destination_assigned_damage_subcategory ?destination_location ?damage_subcategory)
        (damage_category_staged ?damage_category)
        (damage_subcategory_tagged ?damage_subcategory)
        (location_ready_for_consolidation ?source_location)
        (not
          (destination_ready_for_consolidation ?destination_location)
        )
        (container_available ?transfer_container)
      )
    :effect
      (and
        (container_reserved ?transfer_container)
        (container_assigned_damage_category ?transfer_container ?damage_category)
        (container_assigned_damage_subcategory ?transfer_container ?damage_subcategory)
        (container_needs_transport_asset ?transfer_container)
        (not
          (container_available ?transfer_container)
        )
      )
  )
  (:action stage_container_complete
    :parameters (?source_location - source_location ?destination_location - destination_location ?damage_category - damage_category ?damage_subcategory - damage_subcategory ?transfer_container - transfer_container)
    :precondition
      (and
        (location_processing_locked ?source_location)
        (destination_processing_locked ?destination_location)
        (location_assigned_damage_category ?source_location ?damage_category)
        (destination_assigned_damage_subcategory ?destination_location ?damage_subcategory)
        (damage_category_tagged ?damage_category)
        (damage_subcategory_tagged ?damage_subcategory)
        (not
          (location_ready_for_consolidation ?source_location)
        )
        (not
          (destination_ready_for_consolidation ?destination_location)
        )
        (container_available ?transfer_container)
      )
    :effect
      (and
        (container_reserved ?transfer_container)
        (container_assigned_damage_category ?transfer_container ?damage_category)
        (container_assigned_damage_subcategory ?transfer_container ?damage_subcategory)
        (container_needs_handling_profile ?transfer_container)
        (container_needs_transport_asset ?transfer_container)
        (not
          (container_available ?transfer_container)
        )
      )
  )
  (:action seal_transfer_container
    :parameters (?transfer_container - transfer_container ?source_location - source_location ?inspector - inspector)
    :precondition
      (and
        (container_reserved ?transfer_container)
        (location_processing_locked ?source_location)
        (assigned_to_inspector ?source_location ?inspector)
        (not
          (container_sealed ?transfer_container)
        )
      )
    :effect (container_sealed ?transfer_container)
  )
  (:action assign_pallet_to_work_order
    :parameters (?work_order - work_order ?pallet_asset - pallet_asset ?transfer_container - transfer_container)
    :precondition
      (and
        (inspection_cleared ?work_order)
        (work_order_assigned_container ?work_order ?transfer_container)
        (work_order_assigned_pallet ?work_order ?pallet_asset)
        (pallet_available ?pallet_asset)
        (container_reserved ?transfer_container)
        (container_sealed ?transfer_container)
        (not
          (pallet_reserved ?pallet_asset)
        )
      )
    :effect
      (and
        (pallet_reserved ?pallet_asset)
        (pallet_assigned_container ?pallet_asset ?transfer_container)
        (not
          (pallet_available ?pallet_asset)
        )
      )
  )
  (:action prepare_work_order_packaging
    :parameters (?work_order - work_order ?pallet_asset - pallet_asset ?transfer_container - transfer_container ?inspector - inspector)
    :precondition
      (and
        (inspection_cleared ?work_order)
        (work_order_assigned_pallet ?work_order ?pallet_asset)
        (pallet_reserved ?pallet_asset)
        (pallet_assigned_container ?pallet_asset ?transfer_container)
        (assigned_to_inspector ?work_order ?inspector)
        (not
          (container_needs_handling_profile ?transfer_container)
        )
        (not
          (work_order_packaging_prepared ?work_order)
        )
      )
    :effect (work_order_packaging_prepared ?work_order)
  )
  (:action allocate_transport_asset
    :parameters (?work_order - work_order ?transport_asset - transport_asset)
    :precondition
      (and
        (inspection_cleared ?work_order)
        (transport_asset_available ?transport_asset)
        (not
          (transport_asset_allocated ?work_order)
        )
      )
    :effect
      (and
        (transport_asset_allocated ?work_order)
        (work_order_assigned_transport_asset ?work_order ?transport_asset)
        (not
          (transport_asset_available ?transport_asset)
        )
      )
  )
  (:action attach_transport_asset_and_prepare_packaging
    :parameters (?work_order - work_order ?pallet_asset - pallet_asset ?transfer_container - transfer_container ?inspector - inspector ?transport_asset - transport_asset)
    :precondition
      (and
        (inspection_cleared ?work_order)
        (work_order_assigned_pallet ?work_order ?pallet_asset)
        (pallet_reserved ?pallet_asset)
        (pallet_assigned_container ?pallet_asset ?transfer_container)
        (assigned_to_inspector ?work_order ?inspector)
        (container_needs_handling_profile ?transfer_container)
        (transport_asset_allocated ?work_order)
        (work_order_assigned_transport_asset ?work_order ?transport_asset)
        (not
          (work_order_packaging_prepared ?work_order)
        )
      )
    :effect
      (and
        (work_order_packaging_prepared ?work_order)
        (work_order_transport_stage_recorded ?work_order)
      )
  )
  (:action prepare_work_order_for_transport
    :parameters (?work_order - work_order ?quality_tag - quality_tag ?warehouse_operator - warehouse_operator ?pallet_asset - pallet_asset ?transfer_container - transfer_container)
    :precondition
      (and
        (work_order_packaging_prepared ?work_order)
        (work_order_assigned_quality_tag ?work_order ?quality_tag)
        (assigned_to_operator ?work_order ?warehouse_operator)
        (work_order_assigned_pallet ?work_order ?pallet_asset)
        (pallet_assigned_container ?pallet_asset ?transfer_container)
        (not
          (container_needs_transport_asset ?transfer_container)
        )
        (not
          (work_order_transport_prepared ?work_order)
        )
      )
    :effect (work_order_transport_prepared ?work_order)
  )
  (:action prepare_work_order_for_transport_with_asset
    :parameters (?work_order - work_order ?quality_tag - quality_tag ?warehouse_operator - warehouse_operator ?pallet_asset - pallet_asset ?transfer_container - transfer_container)
    :precondition
      (and
        (work_order_packaging_prepared ?work_order)
        (work_order_assigned_quality_tag ?work_order ?quality_tag)
        (assigned_to_operator ?work_order ?warehouse_operator)
        (work_order_assigned_pallet ?work_order ?pallet_asset)
        (pallet_assigned_container ?pallet_asset ?transfer_container)
        (container_needs_transport_asset ?transfer_container)
        (not
          (work_order_transport_prepared ?work_order)
        )
      )
    :effect (work_order_transport_prepared ?work_order)
  )
  (:action finalize_work_order_packaging
    :parameters (?work_order - work_order ?inspection_report - inspection_report ?pallet_asset - pallet_asset ?transfer_container - transfer_container)
    :precondition
      (and
        (work_order_transport_prepared ?work_order)
        (work_order_assigned_inspection_report ?work_order ?inspection_report)
        (work_order_assigned_pallet ?work_order ?pallet_asset)
        (pallet_assigned_container ?pallet_asset ?transfer_container)
        (not
          (container_needs_handling_profile ?transfer_container)
        )
        (not
          (container_needs_transport_asset ?transfer_container)
        )
        (not
          (work_order_ready_for_finalization ?work_order)
        )
      )
    :effect (work_order_ready_for_finalization ?work_order)
  )
  (:action finalize_work_order_packaging_with_handling_request
    :parameters (?work_order - work_order ?inspection_report - inspection_report ?pallet_asset - pallet_asset ?transfer_container - transfer_container)
    :precondition
      (and
        (work_order_transport_prepared ?work_order)
        (work_order_assigned_inspection_report ?work_order ?inspection_report)
        (work_order_assigned_pallet ?work_order ?pallet_asset)
        (pallet_assigned_container ?pallet_asset ?transfer_container)
        (container_needs_handling_profile ?transfer_container)
        (not
          (container_needs_transport_asset ?transfer_container)
        )
        (not
          (work_order_ready_for_finalization ?work_order)
        )
      )
    :effect
      (and
        (work_order_ready_for_finalization ?work_order)
        (handling_profile_requested ?work_order)
      )
  )
  (:action finalize_work_order_packaging_with_handling_confirmation
    :parameters (?work_order - work_order ?inspection_report - inspection_report ?pallet_asset - pallet_asset ?transfer_container - transfer_container)
    :precondition
      (and
        (work_order_transport_prepared ?work_order)
        (work_order_assigned_inspection_report ?work_order ?inspection_report)
        (work_order_assigned_pallet ?work_order ?pallet_asset)
        (pallet_assigned_container ?pallet_asset ?transfer_container)
        (not
          (container_needs_handling_profile ?transfer_container)
        )
        (container_needs_transport_asset ?transfer_container)
        (not
          (work_order_ready_for_finalization ?work_order)
        )
      )
    :effect
      (and
        (work_order_ready_for_finalization ?work_order)
        (handling_profile_requested ?work_order)
      )
  )
  (:action finalize_work_order_packaging_complete
    :parameters (?work_order - work_order ?inspection_report - inspection_report ?pallet_asset - pallet_asset ?transfer_container - transfer_container)
    :precondition
      (and
        (work_order_transport_prepared ?work_order)
        (work_order_assigned_inspection_report ?work_order ?inspection_report)
        (work_order_assigned_pallet ?work_order ?pallet_asset)
        (pallet_assigned_container ?pallet_asset ?transfer_container)
        (container_needs_handling_profile ?transfer_container)
        (container_needs_transport_asset ?transfer_container)
        (not
          (work_order_ready_for_finalization ?work_order)
        )
      )
    :effect
      (and
        (work_order_ready_for_finalization ?work_order)
        (handling_profile_requested ?work_order)
      )
  )
  (:action complete_work_order_and_mark_ready
    :parameters (?work_order - work_order)
    :precondition
      (and
        (work_order_ready_for_finalization ?work_order)
        (not
          (handling_profile_requested ?work_order)
        )
        (not
          (work_order_inventory_reconciled ?work_order)
        )
      )
    :effect
      (and
        (work_order_inventory_reconciled ?work_order)
        (ready_for_disposition ?work_order)
      )
  )
  (:action assign_handling_profile
    :parameters (?work_order - work_order ?handling_profile - handling_profile)
    :precondition
      (and
        (work_order_ready_for_finalization ?work_order)
        (handling_profile_requested ?work_order)
        (handling_profile_available ?handling_profile)
      )
    :effect
      (and
        (work_order_assigned_handling_profile ?work_order ?handling_profile)
        (not
          (handling_profile_available ?handling_profile)
        )
      )
  )
  (:action authorize_work_order_movement
    :parameters (?work_order - work_order ?source_location - source_location ?destination_location - destination_location ?inspector - inspector ?handling_profile - handling_profile)
    :precondition
      (and
        (work_order_ready_for_finalization ?work_order)
        (handling_profile_requested ?work_order)
        (work_order_assigned_handling_profile ?work_order ?handling_profile)
        (work_order_assigned_source ?work_order ?source_location)
        (work_order_assigned_destination ?work_order ?destination_location)
        (location_ready_for_consolidation ?source_location)
        (destination_ready_for_consolidation ?destination_location)
        (assigned_to_inspector ?work_order ?inspector)
        (not
          (work_order_ready_for_movement ?work_order)
        )
      )
    :effect (work_order_ready_for_movement ?work_order)
  )
  (:action finalize_movement_and_mark_ready
    :parameters (?work_order - work_order)
    :precondition
      (and
        (work_order_ready_for_finalization ?work_order)
        (work_order_ready_for_movement ?work_order)
        (not
          (work_order_inventory_reconciled ?work_order)
        )
      )
    :effect
      (and
        (work_order_inventory_reconciled ?work_order)
        (ready_for_disposition ?work_order)
      )
  )
  (:action apply_approval_token_to_work_order
    :parameters (?work_order - work_order ?approval_token - approval_token ?inspector - inspector)
    :precondition
      (and
        (inspection_cleared ?work_order)
        (assigned_to_inspector ?work_order ?inspector)
        (approval_token_available ?approval_token)
        (work_order_assigned_approval_token ?work_order ?approval_token)
        (not
          (work_order_approved ?work_order)
        )
      )
    :effect
      (and
        (work_order_approved ?work_order)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action record_approval_acknowledgement
    :parameters (?work_order - work_order ?warehouse_operator - warehouse_operator)
    :precondition
      (and
        (work_order_approved ?work_order)
        (assigned_to_operator ?work_order ?warehouse_operator)
        (not
          (work_order_approval_recorded ?work_order)
        )
      )
    :effect (work_order_approval_recorded ?work_order)
  )
  (:action finalize_approval
    :parameters (?work_order - work_order ?inspection_report - inspection_report)
    :precondition
      (and
        (work_order_approval_recorded ?work_order)
        (work_order_assigned_inspection_report ?work_order ?inspection_report)
        (not
          (work_order_approval_finalized ?work_order)
        )
      )
    :effect (work_order_approval_finalized ?work_order)
  )
  (:action finalize_approval_and_mark_ready
    :parameters (?work_order - work_order)
    :precondition
      (and
        (work_order_approval_finalized ?work_order)
        (not
          (work_order_inventory_reconciled ?work_order)
        )
      )
    :effect
      (and
        (work_order_inventory_reconciled ?work_order)
        (ready_for_disposition ?work_order)
      )
  )
  (:action mark_source_ready_for_disposition
    :parameters (?source_location - source_location ?transfer_container - transfer_container)
    :precondition
      (and
        (location_processing_locked ?source_location)
        (location_ready_for_consolidation ?source_location)
        (container_reserved ?transfer_container)
        (container_sealed ?transfer_container)
        (not
          (ready_for_disposition ?source_location)
        )
      )
    :effect (ready_for_disposition ?source_location)
  )
  (:action mark_destination_ready_for_disposition
    :parameters (?destination_location - destination_location ?transfer_container - transfer_container)
    :precondition
      (and
        (destination_processing_locked ?destination_location)
        (destination_ready_for_consolidation ?destination_location)
        (container_reserved ?transfer_container)
        (container_sealed ?transfer_container)
        (not
          (ready_for_disposition ?destination_location)
        )
      )
    :effect (ready_for_disposition ?destination_location)
  )
  (:action create_disposition_order
    :parameters (?stock_unit - stock_unit ?disposition_order - disposition_order ?inspector - inspector)
    :precondition
      (and
        (ready_for_disposition ?stock_unit)
        (assigned_to_inspector ?stock_unit ?inspector)
        (disposition_order_available ?disposition_order)
        (not
          (disposition_assigned ?stock_unit)
        )
      )
    :effect
      (and
        (disposition_assigned ?stock_unit)
        (assigned_disposition_order ?stock_unit ?disposition_order)
        (not
          (disposition_order_available ?disposition_order)
        )
      )
  )
  (:action execute_final_disposition_from_source
    :parameters (?source_location - source_location ?material_handler - material_handler ?disposition_order - disposition_order)
    :precondition
      (and
        (disposition_assigned ?source_location)
        (assigned_to_handler ?source_location ?material_handler)
        (assigned_disposition_order ?source_location ?disposition_order)
        (not
          (disposition_finalized ?source_location)
        )
      )
    :effect
      (and
        (disposition_finalized ?source_location)
        (handler_available ?material_handler)
        (disposition_order_available ?disposition_order)
      )
  )
  (:action execute_final_disposition_from_destination
    :parameters (?destination_location - destination_location ?material_handler - material_handler ?disposition_order - disposition_order)
    :precondition
      (and
        (disposition_assigned ?destination_location)
        (assigned_to_handler ?destination_location ?material_handler)
        (assigned_disposition_order ?destination_location ?disposition_order)
        (not
          (disposition_finalized ?destination_location)
        )
      )
    :effect
      (and
        (disposition_finalized ?destination_location)
        (handler_available ?material_handler)
        (disposition_order_available ?disposition_order)
      )
  )
  (:action execute_final_disposition_for_work_order
    :parameters (?work_order - work_order ?material_handler - material_handler ?disposition_order - disposition_order)
    :precondition
      (and
        (disposition_assigned ?work_order)
        (assigned_to_handler ?work_order ?material_handler)
        (assigned_disposition_order ?work_order ?disposition_order)
        (not
          (disposition_finalized ?work_order)
        )
      )
    :effect
      (and
        (disposition_finalized ?work_order)
        (handler_available ?material_handler)
        (disposition_order_available ?disposition_order)
      )
  )
)

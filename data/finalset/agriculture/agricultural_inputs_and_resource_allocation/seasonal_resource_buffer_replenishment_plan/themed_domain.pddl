(define (domain seasonal_resource_buffer_replenishment_plan)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object resource_category - entity schedule_category - entity order_category - entity operational_target_category - entity operational_target - operational_target_category supply_lot - resource_category inspector - resource_category equipment_unit - resource_category label_record - resource_category packaging_material - resource_category contingency_reserve - resource_category material_batch - resource_category fuel_batch - resource_category consumable_unit - schedule_category container - schedule_category delivery_permit - schedule_category field_resource_slot - order_category livestock_resource_slot - order_category replenishment_order - order_category arable_target_category - operational_target non_arable_target_category - operational_target crop_field - arable_target_category livestock_unit - arable_target_category logistics_hub - non_arable_target_category)

  (:predicates
    (buffer_slot_registered ?operational_target - operational_target)
    (target_ready ?operational_target - operational_target)
    (supply_reserved ?operational_target - operational_target)
    (target_replenished ?operational_target - operational_target)
    (ready_for_dispatch ?operational_target - operational_target)
    (replenishment_recorded ?operational_target - operational_target)
    (supply_lot_available ?supply_lot - supply_lot)
    (supply_allocated_to_target ?operational_target - operational_target ?supply_lot - supply_lot)
    (inspector_available ?inspector - inspector)
    (inspector_assigned_to_target ?operational_target - operational_target ?inspector - inspector)
    (equipment_available ?equipment_unit - equipment_unit)
    (equipment_assigned_to_target ?operational_target - operational_target ?equipment_unit - equipment_unit)
    (consumable_available ?consumable_unit - consumable_unit)
    (field_consumable_assigned ?crop_field - crop_field ?consumable_unit - consumable_unit)
    (livestock_consumable_assigned ?livestock_unit - livestock_unit ?consumable_unit - consumable_unit)
    (field_slot_linked ?crop_field - crop_field ?field_resource_slot - field_resource_slot)
    (field_slot_activated ?field_resource_slot - field_resource_slot)
    (field_slot_staged ?field_resource_slot - field_resource_slot)
    (field_prepared ?crop_field - crop_field)
    (livestock_slot_linked ?livestock_unit - livestock_unit ?livestock_resource_slot - livestock_resource_slot)
    (livestock_slot_activated ?livestock_resource_slot - livestock_resource_slot)
    (livestock_slot_staged ?livestock_resource_slot - livestock_resource_slot)
    (livestock_prepared ?livestock_unit - livestock_unit)
    (order_created ?replenishment_order - replenishment_order)
    (order_staged ?replenishment_order - replenishment_order)
    (order_includes_field_slot ?replenishment_order - replenishment_order ?field_resource_slot - field_resource_slot)
    (order_includes_livestock_slot ?replenishment_order - replenishment_order ?livestock_resource_slot - livestock_resource_slot)
    (order_requires_labeling ?replenishment_order - replenishment_order)
    (order_requires_certification ?replenishment_order - replenishment_order)
    (order_confirmed_for_containerization ?replenishment_order - replenishment_order)
    (hub_serves_field ?logistics_hub - logistics_hub ?crop_field - crop_field)
    (hub_serves_livestock ?logistics_hub - logistics_hub ?livestock_unit - livestock_unit)
    (hub_has_order ?logistics_hub - logistics_hub ?replenishment_order - replenishment_order)
    (container_available ?container - container)
    (hub_has_container ?logistics_hub - logistics_hub ?container - container)
    (container_processed ?container - container)
    (container_assigned_to_order ?container - container ?replenishment_order - replenishment_order)
    (hub_container_prepared ?logistics_hub - logistics_hub)
    (hub_quality_check_complete ?logistics_hub - logistics_hub)
    (hub_qa_verified ?logistics_hub - logistics_hub)
    (hub_label_reserved ?logistics_hub - logistics_hub)
    (hub_label_attached ?logistics_hub - logistics_hub)
    (hub_packaging_assigned ?logistics_hub - logistics_hub)
    (hub_deployment_ready ?logistics_hub - logistics_hub)
    (delivery_permit_available ?delivery_permit - delivery_permit)
    (hub_has_permit ?logistics_hub - logistics_hub ?delivery_permit - delivery_permit)
    (hub_permit_claimed ?logistics_hub - logistics_hub)
    (hub_permit_validated ?logistics_hub - logistics_hub)
    (hub_permit_approved ?logistics_hub - logistics_hub)
    (label_record_available ?label_record - label_record)
    (hub_has_label_record ?logistics_hub - logistics_hub ?label_record - label_record)
    (packaging_material_available ?packaging_material - packaging_material)
    (hub_has_packaging_material ?logistics_hub - logistics_hub ?packaging_material - packaging_material)
    (material_batch_available ?material_batch - material_batch)
    (hub_has_material_batch ?logistics_hub - logistics_hub ?material_batch - material_batch)
    (fuel_batch_available ?fuel_batch - fuel_batch)
    (hub_has_fuel_batch ?logistics_hub - logistics_hub ?fuel_batch - fuel_batch)
    (contingency_reserve_available ?contingency_reserve - contingency_reserve)
    (target_reserved_contingency_link ?operational_target - operational_target ?contingency_reserve - contingency_reserve)
    (field_staging_acknowledged ?crop_field - crop_field)
    (livestock_staging_acknowledged ?livestock_unit - livestock_unit)
    (processing_completed ?logistics_hub - logistics_hub)
  )
  (:action register_buffer_slot
    :parameters (?operational_target - operational_target)
    :precondition
      (and
        (not
          (buffer_slot_registered ?operational_target)
        )
        (not
          (target_replenished ?operational_target)
        )
      )
    :effect (buffer_slot_registered ?operational_target)
  )
  (:action reserve_supply_lot_for_target
    :parameters (?operational_target - operational_target ?supply_lot - supply_lot)
    :precondition
      (and
        (buffer_slot_registered ?operational_target)
        (not
          (supply_reserved ?operational_target)
        )
        (supply_lot_available ?supply_lot)
      )
    :effect
      (and
        (supply_reserved ?operational_target)
        (supply_allocated_to_target ?operational_target ?supply_lot)
        (not
          (supply_lot_available ?supply_lot)
        )
      )
  )
  (:action assign_inspector_to_target
    :parameters (?operational_target - operational_target ?inspector - inspector)
    :precondition
      (and
        (buffer_slot_registered ?operational_target)
        (supply_reserved ?operational_target)
        (inspector_available ?inspector)
      )
    :effect
      (and
        (inspector_assigned_to_target ?operational_target ?inspector)
        (not
          (inspector_available ?inspector)
        )
      )
  )
  (:action verify_inspection_for_target
    :parameters (?operational_target - operational_target ?inspector - inspector)
    :precondition
      (and
        (buffer_slot_registered ?operational_target)
        (supply_reserved ?operational_target)
        (inspector_assigned_to_target ?operational_target ?inspector)
        (not
          (target_ready ?operational_target)
        )
      )
    :effect (target_ready ?operational_target)
  )
  (:action release_inspector_from_target
    :parameters (?operational_target - operational_target ?inspector - inspector)
    :precondition
      (and
        (inspector_assigned_to_target ?operational_target ?inspector)
      )
    :effect
      (and
        (inspector_available ?inspector)
        (not
          (inspector_assigned_to_target ?operational_target ?inspector)
        )
      )
  )
  (:action assign_equipment_to_target
    :parameters (?operational_target - operational_target ?equipment_unit - equipment_unit)
    :precondition
      (and
        (target_ready ?operational_target)
        (equipment_available ?equipment_unit)
      )
    :effect
      (and
        (equipment_assigned_to_target ?operational_target ?equipment_unit)
        (not
          (equipment_available ?equipment_unit)
        )
      )
  )
  (:action release_equipment_from_target
    :parameters (?operational_target - operational_target ?equipment_unit - equipment_unit)
    :precondition
      (and
        (equipment_assigned_to_target ?operational_target ?equipment_unit)
      )
    :effect
      (and
        (equipment_available ?equipment_unit)
        (not
          (equipment_assigned_to_target ?operational_target ?equipment_unit)
        )
      )
  )
  (:action accept_material_batch_at_hub
    :parameters (?logistics_hub - logistics_hub ?material_batch - material_batch)
    :precondition
      (and
        (target_ready ?logistics_hub)
        (material_batch_available ?material_batch)
      )
    :effect
      (and
        (hub_has_material_batch ?logistics_hub ?material_batch)
        (not
          (material_batch_available ?material_batch)
        )
      )
  )
  (:action release_material_batch_from_hub
    :parameters (?logistics_hub - logistics_hub ?material_batch - material_batch)
    :precondition
      (and
        (hub_has_material_batch ?logistics_hub ?material_batch)
      )
    :effect
      (and
        (material_batch_available ?material_batch)
        (not
          (hub_has_material_batch ?logistics_hub ?material_batch)
        )
      )
  )
  (:action accept_fuel_batch_at_hub
    :parameters (?logistics_hub - logistics_hub ?fuel_batch - fuel_batch)
    :precondition
      (and
        (target_ready ?logistics_hub)
        (fuel_batch_available ?fuel_batch)
      )
    :effect
      (and
        (hub_has_fuel_batch ?logistics_hub ?fuel_batch)
        (not
          (fuel_batch_available ?fuel_batch)
        )
      )
  )
  (:action release_fuel_batch_from_hub
    :parameters (?logistics_hub - logistics_hub ?fuel_batch - fuel_batch)
    :precondition
      (and
        (hub_has_fuel_batch ?logistics_hub ?fuel_batch)
      )
    :effect
      (and
        (fuel_batch_available ?fuel_batch)
        (not
          (hub_has_fuel_batch ?logistics_hub ?fuel_batch)
        )
      )
  )
  (:action activate_field_resource_slot
    :parameters (?crop_field - crop_field ?field_resource_slot - field_resource_slot ?inspector - inspector)
    :precondition
      (and
        (target_ready ?crop_field)
        (inspector_assigned_to_target ?crop_field ?inspector)
        (field_slot_linked ?crop_field ?field_resource_slot)
        (not
          (field_slot_activated ?field_resource_slot)
        )
        (not
          (field_slot_staged ?field_resource_slot)
        )
      )
    :effect (field_slot_activated ?field_resource_slot)
  )
  (:action prepare_field_slot_with_equipment
    :parameters (?crop_field - crop_field ?field_resource_slot - field_resource_slot ?equipment_unit - equipment_unit)
    :precondition
      (and
        (target_ready ?crop_field)
        (equipment_assigned_to_target ?crop_field ?equipment_unit)
        (field_slot_linked ?crop_field ?field_resource_slot)
        (field_slot_activated ?field_resource_slot)
        (not
          (field_staging_acknowledged ?crop_field)
        )
      )
    :effect
      (and
        (field_staging_acknowledged ?crop_field)
        (field_prepared ?crop_field)
      )
  )
  (:action stage_consumable_to_field_slot
    :parameters (?crop_field - crop_field ?field_resource_slot - field_resource_slot ?consumable_unit - consumable_unit)
    :precondition
      (and
        (target_ready ?crop_field)
        (field_slot_linked ?crop_field ?field_resource_slot)
        (consumable_available ?consumable_unit)
        (not
          (field_staging_acknowledged ?crop_field)
        )
      )
    :effect
      (and
        (field_slot_staged ?field_resource_slot)
        (field_staging_acknowledged ?crop_field)
        (field_consumable_assigned ?crop_field ?consumable_unit)
        (not
          (consumable_available ?consumable_unit)
        )
      )
  )
  (:action finalize_field_slot_staging
    :parameters (?crop_field - crop_field ?field_resource_slot - field_resource_slot ?inspector - inspector ?consumable_unit - consumable_unit)
    :precondition
      (and
        (target_ready ?crop_field)
        (inspector_assigned_to_target ?crop_field ?inspector)
        (field_slot_linked ?crop_field ?field_resource_slot)
        (field_slot_staged ?field_resource_slot)
        (field_consumable_assigned ?crop_field ?consumable_unit)
        (not
          (field_prepared ?crop_field)
        )
      )
    :effect
      (and
        (field_slot_activated ?field_resource_slot)
        (field_prepared ?crop_field)
        (consumable_available ?consumable_unit)
        (not
          (field_consumable_assigned ?crop_field ?consumable_unit)
        )
      )
  )
  (:action activate_livestock_resource_slot
    :parameters (?livestock_unit - livestock_unit ?livestock_resource_slot - livestock_resource_slot ?inspector - inspector)
    :precondition
      (and
        (target_ready ?livestock_unit)
        (inspector_assigned_to_target ?livestock_unit ?inspector)
        (livestock_slot_linked ?livestock_unit ?livestock_resource_slot)
        (not
          (livestock_slot_activated ?livestock_resource_slot)
        )
        (not
          (livestock_slot_staged ?livestock_resource_slot)
        )
      )
    :effect (livestock_slot_activated ?livestock_resource_slot)
  )
  (:action prepare_livestock_slot_with_equipment
    :parameters (?livestock_unit - livestock_unit ?livestock_resource_slot - livestock_resource_slot ?equipment_unit - equipment_unit)
    :precondition
      (and
        (target_ready ?livestock_unit)
        (equipment_assigned_to_target ?livestock_unit ?equipment_unit)
        (livestock_slot_linked ?livestock_unit ?livestock_resource_slot)
        (livestock_slot_activated ?livestock_resource_slot)
        (not
          (livestock_staging_acknowledged ?livestock_unit)
        )
      )
    :effect
      (and
        (livestock_staging_acknowledged ?livestock_unit)
        (livestock_prepared ?livestock_unit)
      )
  )
  (:action stage_consumable_to_livestock_slot
    :parameters (?livestock_unit - livestock_unit ?livestock_resource_slot - livestock_resource_slot ?consumable_unit - consumable_unit)
    :precondition
      (and
        (target_ready ?livestock_unit)
        (livestock_slot_linked ?livestock_unit ?livestock_resource_slot)
        (consumable_available ?consumable_unit)
        (not
          (livestock_staging_acknowledged ?livestock_unit)
        )
      )
    :effect
      (and
        (livestock_slot_staged ?livestock_resource_slot)
        (livestock_staging_acknowledged ?livestock_unit)
        (livestock_consumable_assigned ?livestock_unit ?consumable_unit)
        (not
          (consumable_available ?consumable_unit)
        )
      )
  )
  (:action finalize_livestock_slot_staging
    :parameters (?livestock_unit - livestock_unit ?livestock_resource_slot - livestock_resource_slot ?inspector - inspector ?consumable_unit - consumable_unit)
    :precondition
      (and
        (target_ready ?livestock_unit)
        (inspector_assigned_to_target ?livestock_unit ?inspector)
        (livestock_slot_linked ?livestock_unit ?livestock_resource_slot)
        (livestock_slot_staged ?livestock_resource_slot)
        (livestock_consumable_assigned ?livestock_unit ?consumable_unit)
        (not
          (livestock_prepared ?livestock_unit)
        )
      )
    :effect
      (and
        (livestock_slot_activated ?livestock_resource_slot)
        (livestock_prepared ?livestock_unit)
        (consumable_available ?consumable_unit)
        (not
          (livestock_consumable_assigned ?livestock_unit ?consumable_unit)
        )
      )
  )
  (:action assemble_replenishment_order_simple
    :parameters (?crop_field - crop_field ?livestock_unit - livestock_unit ?field_resource_slot - field_resource_slot ?livestock_resource_slot - livestock_resource_slot ?replenishment_order - replenishment_order)
    :precondition
      (and
        (field_staging_acknowledged ?crop_field)
        (livestock_staging_acknowledged ?livestock_unit)
        (field_slot_linked ?crop_field ?field_resource_slot)
        (livestock_slot_linked ?livestock_unit ?livestock_resource_slot)
        (field_slot_activated ?field_resource_slot)
        (livestock_slot_activated ?livestock_resource_slot)
        (field_prepared ?crop_field)
        (livestock_prepared ?livestock_unit)
        (order_created ?replenishment_order)
      )
    :effect
      (and
        (order_staged ?replenishment_order)
        (order_includes_field_slot ?replenishment_order ?field_resource_slot)
        (order_includes_livestock_slot ?replenishment_order ?livestock_resource_slot)
        (not
          (order_created ?replenishment_order)
        )
      )
  )
  (:action assemble_replenishment_order_with_labeling
    :parameters (?crop_field - crop_field ?livestock_unit - livestock_unit ?field_resource_slot - field_resource_slot ?livestock_resource_slot - livestock_resource_slot ?replenishment_order - replenishment_order)
    :precondition
      (and
        (field_staging_acknowledged ?crop_field)
        (livestock_staging_acknowledged ?livestock_unit)
        (field_slot_linked ?crop_field ?field_resource_slot)
        (livestock_slot_linked ?livestock_unit ?livestock_resource_slot)
        (field_slot_staged ?field_resource_slot)
        (livestock_slot_activated ?livestock_resource_slot)
        (not
          (field_prepared ?crop_field)
        )
        (livestock_prepared ?livestock_unit)
        (order_created ?replenishment_order)
      )
    :effect
      (and
        (order_staged ?replenishment_order)
        (order_includes_field_slot ?replenishment_order ?field_resource_slot)
        (order_includes_livestock_slot ?replenishment_order ?livestock_resource_slot)
        (order_requires_labeling ?replenishment_order)
        (not
          (order_created ?replenishment_order)
        )
      )
  )
  (:action assemble_replenishment_order_with_certification
    :parameters (?crop_field - crop_field ?livestock_unit - livestock_unit ?field_resource_slot - field_resource_slot ?livestock_resource_slot - livestock_resource_slot ?replenishment_order - replenishment_order)
    :precondition
      (and
        (field_staging_acknowledged ?crop_field)
        (livestock_staging_acknowledged ?livestock_unit)
        (field_slot_linked ?crop_field ?field_resource_slot)
        (livestock_slot_linked ?livestock_unit ?livestock_resource_slot)
        (field_slot_activated ?field_resource_slot)
        (livestock_slot_staged ?livestock_resource_slot)
        (field_prepared ?crop_field)
        (not
          (livestock_prepared ?livestock_unit)
        )
        (order_created ?replenishment_order)
      )
    :effect
      (and
        (order_staged ?replenishment_order)
        (order_includes_field_slot ?replenishment_order ?field_resource_slot)
        (order_includes_livestock_slot ?replenishment_order ?livestock_resource_slot)
        (order_requires_certification ?replenishment_order)
        (not
          (order_created ?replenishment_order)
        )
      )
  )
  (:action assemble_replenishment_order_with_labeling_and_certification
    :parameters (?crop_field - crop_field ?livestock_unit - livestock_unit ?field_resource_slot - field_resource_slot ?livestock_resource_slot - livestock_resource_slot ?replenishment_order - replenishment_order)
    :precondition
      (and
        (field_staging_acknowledged ?crop_field)
        (livestock_staging_acknowledged ?livestock_unit)
        (field_slot_linked ?crop_field ?field_resource_slot)
        (livestock_slot_linked ?livestock_unit ?livestock_resource_slot)
        (field_slot_staged ?field_resource_slot)
        (livestock_slot_staged ?livestock_resource_slot)
        (not
          (field_prepared ?crop_field)
        )
        (not
          (livestock_prepared ?livestock_unit)
        )
        (order_created ?replenishment_order)
      )
    :effect
      (and
        (order_staged ?replenishment_order)
        (order_includes_field_slot ?replenishment_order ?field_resource_slot)
        (order_includes_livestock_slot ?replenishment_order ?livestock_resource_slot)
        (order_requires_labeling ?replenishment_order)
        (order_requires_certification ?replenishment_order)
        (not
          (order_created ?replenishment_order)
        )
      )
  )
  (:action confirm_replenishment_order
    :parameters (?replenishment_order - replenishment_order ?crop_field - crop_field ?inspector - inspector)
    :precondition
      (and
        (order_staged ?replenishment_order)
        (field_staging_acknowledged ?crop_field)
        (inspector_assigned_to_target ?crop_field ?inspector)
        (not
          (order_confirmed_for_containerization ?replenishment_order)
        )
      )
    :effect (order_confirmed_for_containerization ?replenishment_order)
  )
  (:action populate_container_from_hub_inventory
    :parameters (?logistics_hub - logistics_hub ?container - container ?replenishment_order - replenishment_order)
    :precondition
      (and
        (target_ready ?logistics_hub)
        (hub_has_order ?logistics_hub ?replenishment_order)
        (hub_has_container ?logistics_hub ?container)
        (container_available ?container)
        (order_staged ?replenishment_order)
        (order_confirmed_for_containerization ?replenishment_order)
        (not
          (container_processed ?container)
        )
      )
    :effect
      (and
        (container_processed ?container)
        (container_assigned_to_order ?container ?replenishment_order)
        (not
          (container_available ?container)
        )
      )
  )
  (:action process_container_for_hub_qa
    :parameters (?logistics_hub - logistics_hub ?container - container ?replenishment_order - replenishment_order ?inspector - inspector)
    :precondition
      (and
        (target_ready ?logistics_hub)
        (hub_has_container ?logistics_hub ?container)
        (container_processed ?container)
        (container_assigned_to_order ?container ?replenishment_order)
        (inspector_assigned_to_target ?logistics_hub ?inspector)
        (not
          (order_requires_labeling ?replenishment_order)
        )
        (not
          (hub_container_prepared ?logistics_hub)
        )
      )
    :effect (hub_container_prepared ?logistics_hub)
  )
  (:action claim_label_for_hub
    :parameters (?logistics_hub - logistics_hub ?label_record - label_record)
    :precondition
      (and
        (target_ready ?logistics_hub)
        (label_record_available ?label_record)
        (not
          (hub_label_reserved ?logistics_hub)
        )
      )
    :effect
      (and
        (hub_label_reserved ?logistics_hub)
        (hub_has_label_record ?logistics_hub ?label_record)
        (not
          (label_record_available ?label_record)
        )
      )
  )
  (:action attach_label_and_finalize_container
    :parameters (?logistics_hub - logistics_hub ?container - container ?replenishment_order - replenishment_order ?inspector - inspector ?label_record - label_record)
    :precondition
      (and
        (target_ready ?logistics_hub)
        (hub_has_container ?logistics_hub ?container)
        (container_processed ?container)
        (container_assigned_to_order ?container ?replenishment_order)
        (inspector_assigned_to_target ?logistics_hub ?inspector)
        (order_requires_labeling ?replenishment_order)
        (hub_label_reserved ?logistics_hub)
        (hub_has_label_record ?logistics_hub ?label_record)
        (not
          (hub_container_prepared ?logistics_hub)
        )
      )
    :effect
      (and
        (hub_container_prepared ?logistics_hub)
        (hub_label_attached ?logistics_hub)
      )
  )
  (:action perform_quality_check_no_certification
    :parameters (?logistics_hub - logistics_hub ?material_batch - material_batch ?equipment_unit - equipment_unit ?container - container ?replenishment_order - replenishment_order)
    :precondition
      (and
        (hub_container_prepared ?logistics_hub)
        (hub_has_material_batch ?logistics_hub ?material_batch)
        (equipment_assigned_to_target ?logistics_hub ?equipment_unit)
        (hub_has_container ?logistics_hub ?container)
        (container_assigned_to_order ?container ?replenishment_order)
        (not
          (order_requires_certification ?replenishment_order)
        )
        (not
          (hub_quality_check_complete ?logistics_hub)
        )
      )
    :effect (hub_quality_check_complete ?logistics_hub)
  )
  (:action perform_quality_check_with_certification
    :parameters (?logistics_hub - logistics_hub ?material_batch - material_batch ?equipment_unit - equipment_unit ?container - container ?replenishment_order - replenishment_order)
    :precondition
      (and
        (hub_container_prepared ?logistics_hub)
        (hub_has_material_batch ?logistics_hub ?material_batch)
        (equipment_assigned_to_target ?logistics_hub ?equipment_unit)
        (hub_has_container ?logistics_hub ?container)
        (container_assigned_to_order ?container ?replenishment_order)
        (order_requires_certification ?replenishment_order)
        (not
          (hub_quality_check_complete ?logistics_hub)
        )
      )
    :effect (hub_quality_check_complete ?logistics_hub)
  )
  (:action finalize_container_qa_with_fuel_no_label_no_cert
    :parameters (?logistics_hub - logistics_hub ?fuel_batch - fuel_batch ?container - container ?replenishment_order - replenishment_order)
    :precondition
      (and
        (hub_quality_check_complete ?logistics_hub)
        (hub_has_fuel_batch ?logistics_hub ?fuel_batch)
        (hub_has_container ?logistics_hub ?container)
        (container_assigned_to_order ?container ?replenishment_order)
        (not
          (order_requires_labeling ?replenishment_order)
        )
        (not
          (order_requires_certification ?replenishment_order)
        )
        (not
          (hub_qa_verified ?logistics_hub)
        )
      )
    :effect (hub_qa_verified ?logistics_hub)
  )
  (:action finalize_container_qa_with_fuel_label_required_no_cert
    :parameters (?logistics_hub - logistics_hub ?fuel_batch - fuel_batch ?container - container ?replenishment_order - replenishment_order)
    :precondition
      (and
        (hub_quality_check_complete ?logistics_hub)
        (hub_has_fuel_batch ?logistics_hub ?fuel_batch)
        (hub_has_container ?logistics_hub ?container)
        (container_assigned_to_order ?container ?replenishment_order)
        (order_requires_labeling ?replenishment_order)
        (not
          (order_requires_certification ?replenishment_order)
        )
        (not
          (hub_qa_verified ?logistics_hub)
        )
      )
    :effect
      (and
        (hub_qa_verified ?logistics_hub)
        (hub_packaging_assigned ?logistics_hub)
      )
  )
  (:action finalize_container_qa_with_fuel_no_label_cert_required
    :parameters (?logistics_hub - logistics_hub ?fuel_batch - fuel_batch ?container - container ?replenishment_order - replenishment_order)
    :precondition
      (and
        (hub_quality_check_complete ?logistics_hub)
        (hub_has_fuel_batch ?logistics_hub ?fuel_batch)
        (hub_has_container ?logistics_hub ?container)
        (container_assigned_to_order ?container ?replenishment_order)
        (not
          (order_requires_labeling ?replenishment_order)
        )
        (order_requires_certification ?replenishment_order)
        (not
          (hub_qa_verified ?logistics_hub)
        )
      )
    :effect
      (and
        (hub_qa_verified ?logistics_hub)
        (hub_packaging_assigned ?logistics_hub)
      )
  )
  (:action finalize_container_qa_with_fuel_label_required_cert_required
    :parameters (?logistics_hub - logistics_hub ?fuel_batch - fuel_batch ?container - container ?replenishment_order - replenishment_order)
    :precondition
      (and
        (hub_quality_check_complete ?logistics_hub)
        (hub_has_fuel_batch ?logistics_hub ?fuel_batch)
        (hub_has_container ?logistics_hub ?container)
        (container_assigned_to_order ?container ?replenishment_order)
        (order_requires_labeling ?replenishment_order)
        (order_requires_certification ?replenishment_order)
        (not
          (hub_qa_verified ?logistics_hub)
        )
      )
    :effect
      (and
        (hub_qa_verified ?logistics_hub)
        (hub_packaging_assigned ?logistics_hub)
      )
  )
  (:action finalize_hub_processing_initial
    :parameters (?logistics_hub - logistics_hub)
    :precondition
      (and
        (hub_qa_verified ?logistics_hub)
        (not
          (hub_packaging_assigned ?logistics_hub)
        )
        (not
          (processing_completed ?logistics_hub)
        )
      )
    :effect
      (and
        (processing_completed ?logistics_hub)
        (ready_for_dispatch ?logistics_hub)
      )
  )
  (:action allocate_packaging_material_to_hub
    :parameters (?logistics_hub - logistics_hub ?packaging_material - packaging_material)
    :precondition
      (and
        (hub_qa_verified ?logistics_hub)
        (hub_packaging_assigned ?logistics_hub)
        (packaging_material_available ?packaging_material)
      )
    :effect
      (and
        (hub_has_packaging_material ?logistics_hub ?packaging_material)
        (not
          (packaging_material_available ?packaging_material)
        )
      )
  )
  (:action validate_hub_dispatch_conditions
    :parameters (?logistics_hub - logistics_hub ?crop_field - crop_field ?livestock_unit - livestock_unit ?inspector - inspector ?packaging_material - packaging_material)
    :precondition
      (and
        (hub_qa_verified ?logistics_hub)
        (hub_packaging_assigned ?logistics_hub)
        (hub_has_packaging_material ?logistics_hub ?packaging_material)
        (hub_serves_field ?logistics_hub ?crop_field)
        (hub_serves_livestock ?logistics_hub ?livestock_unit)
        (field_prepared ?crop_field)
        (livestock_prepared ?livestock_unit)
        (inspector_assigned_to_target ?logistics_hub ?inspector)
        (not
          (hub_deployment_ready ?logistics_hub)
        )
      )
    :effect (hub_deployment_ready ?logistics_hub)
  )
  (:action finalize_hub_processing_deployment
    :parameters (?logistics_hub - logistics_hub)
    :precondition
      (and
        (hub_qa_verified ?logistics_hub)
        (hub_deployment_ready ?logistics_hub)
        (not
          (processing_completed ?logistics_hub)
        )
      )
    :effect
      (and
        (processing_completed ?logistics_hub)
        (ready_for_dispatch ?logistics_hub)
      )
  )
  (:action claim_delivery_permit_for_hub
    :parameters (?logistics_hub - logistics_hub ?delivery_permit - delivery_permit ?inspector - inspector)
    :precondition
      (and
        (target_ready ?logistics_hub)
        (inspector_assigned_to_target ?logistics_hub ?inspector)
        (delivery_permit_available ?delivery_permit)
        (hub_has_permit ?logistics_hub ?delivery_permit)
        (not
          (hub_permit_claimed ?logistics_hub)
        )
      )
    :effect
      (and
        (hub_permit_claimed ?logistics_hub)
        (not
          (delivery_permit_available ?delivery_permit)
        )
      )
  )
  (:action validate_permit_with_equipment
    :parameters (?logistics_hub - logistics_hub ?equipment_unit - equipment_unit)
    :precondition
      (and
        (hub_permit_claimed ?logistics_hub)
        (equipment_assigned_to_target ?logistics_hub ?equipment_unit)
        (not
          (hub_permit_validated ?logistics_hub)
        )
      )
    :effect (hub_permit_validated ?logistics_hub)
  )
  (:action approve_permit_with_fuel_batch
    :parameters (?logistics_hub - logistics_hub ?fuel_batch - fuel_batch)
    :precondition
      (and
        (hub_permit_validated ?logistics_hub)
        (hub_has_fuel_batch ?logistics_hub ?fuel_batch)
        (not
          (hub_permit_approved ?logistics_hub)
        )
      )
    :effect (hub_permit_approved ?logistics_hub)
  )
  (:action finalize_hub_permit_authorization
    :parameters (?logistics_hub - logistics_hub)
    :precondition
      (and
        (hub_permit_approved ?logistics_hub)
        (not
          (processing_completed ?logistics_hub)
        )
      )
    :effect
      (and
        (processing_completed ?logistics_hub)
        (ready_for_dispatch ?logistics_hub)
      )
  )
  (:action consolidate_dispatch_to_field
    :parameters (?crop_field - crop_field ?replenishment_order - replenishment_order)
    :precondition
      (and
        (field_staging_acknowledged ?crop_field)
        (field_prepared ?crop_field)
        (order_staged ?replenishment_order)
        (order_confirmed_for_containerization ?replenishment_order)
        (not
          (ready_for_dispatch ?crop_field)
        )
      )
    :effect (ready_for_dispatch ?crop_field)
  )
  (:action consolidate_dispatch_to_livestock
    :parameters (?livestock_unit - livestock_unit ?replenishment_order - replenishment_order)
    :precondition
      (and
        (livestock_staging_acknowledged ?livestock_unit)
        (livestock_prepared ?livestock_unit)
        (order_staged ?replenishment_order)
        (order_confirmed_for_containerization ?replenishment_order)
        (not
          (ready_for_dispatch ?livestock_unit)
        )
      )
    :effect (ready_for_dispatch ?livestock_unit)
  )
  (:action apply_replenishment_at_target
    :parameters (?operational_target - operational_target ?contingency_reserve - contingency_reserve ?inspector - inspector)
    :precondition
      (and
        (ready_for_dispatch ?operational_target)
        (inspector_assigned_to_target ?operational_target ?inspector)
        (contingency_reserve_available ?contingency_reserve)
        (not
          (replenishment_recorded ?operational_target)
        )
      )
    :effect
      (and
        (replenishment_recorded ?operational_target)
        (target_reserved_contingency_link ?operational_target ?contingency_reserve)
        (not
          (contingency_reserve_available ?contingency_reserve)
        )
      )
  )
  (:action finalize_target_replenishment_with_supply_lot
    :parameters (?crop_field - crop_field ?supply_lot - supply_lot ?contingency_reserve - contingency_reserve)
    :precondition
      (and
        (replenishment_recorded ?crop_field)
        (supply_allocated_to_target ?crop_field ?supply_lot)
        (target_reserved_contingency_link ?crop_field ?contingency_reserve)
        (not
          (target_replenished ?crop_field)
        )
      )
    :effect
      (and
        (target_replenished ?crop_field)
        (supply_lot_available ?supply_lot)
        (contingency_reserve_available ?contingency_reserve)
      )
  )
  (:action finalize_livestock_replenishment_with_supply_lot
    :parameters (?livestock_unit - livestock_unit ?supply_lot - supply_lot ?contingency_reserve - contingency_reserve)
    :precondition
      (and
        (replenishment_recorded ?livestock_unit)
        (supply_allocated_to_target ?livestock_unit ?supply_lot)
        (target_reserved_contingency_link ?livestock_unit ?contingency_reserve)
        (not
          (target_replenished ?livestock_unit)
        )
      )
    :effect
      (and
        (target_replenished ?livestock_unit)
        (supply_lot_available ?supply_lot)
        (contingency_reserve_available ?contingency_reserve)
      )
  )
  (:action finalize_hub_replenishment_with_supply_lot
    :parameters (?logistics_hub - logistics_hub ?supply_lot - supply_lot ?contingency_reserve - contingency_reserve)
    :precondition
      (and
        (replenishment_recorded ?logistics_hub)
        (supply_allocated_to_target ?logistics_hub ?supply_lot)
        (target_reserved_contingency_link ?logistics_hub ?contingency_reserve)
        (not
          (target_replenished ?logistics_hub)
        )
      )
    :effect
      (and
        (target_replenished ?logistics_hub)
        (supply_lot_available ?supply_lot)
        (contingency_reserve_available ?contingency_reserve)
      )
  )
)

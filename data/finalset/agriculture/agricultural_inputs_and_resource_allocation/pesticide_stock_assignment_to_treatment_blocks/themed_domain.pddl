(define (domain pesticide_stock_assignment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object asset_class - domain_object resource_class - domain_object material_class - domain_object entity_class - domain_object treatment_entity - entity_class equipment_asset - asset_class pesticide_product - asset_class certified_operator - asset_class operational_permit - asset_class monitoring_module - asset_class reserve_stock - asset_class ppe_kit - asset_class pesticide_authorization - asset_class pesticide_container_batch - resource_class mixing_unit - resource_class compliance_document - resource_class application_slot - material_class application_route_segment - material_class pesticide_load_unit - material_class management_unit_group - treatment_entity site_unit_group - treatment_entity field_manager - management_unit_group sprayer_crew - management_unit_group application_site - site_unit_group)

  (:predicates
    (entity_registered ?treatment_entity - treatment_entity)
    (entity_ready ?treatment_entity - treatment_entity)
    (entity_has_equipment ?treatment_entity - treatment_entity)
    (entity_assignment_confirmed ?treatment_entity - treatment_entity)
    (has_assigned_load ?treatment_entity - treatment_entity)
    (entity_ready_for_final_assignment ?treatment_entity - treatment_entity)
    (equipment_available ?equipment_asset - equipment_asset)
    (equipment_allocated_to_entity ?treatment_entity - treatment_entity ?equipment_asset - equipment_asset)
    (pesticide_product_available ?pesticide_product - pesticide_product)
    (pesticide_product_assigned ?treatment_entity - treatment_entity ?pesticide_product - pesticide_product)
    (operator_available ?certified_operator - certified_operator)
    (operator_assigned_to_entity ?treatment_entity - treatment_entity ?certified_operator - certified_operator)
    (container_batch_available ?pesticide_container_batch - pesticide_container_batch)
    (container_allocated_to_manager ?field_manager - field_manager ?pesticide_container_batch - pesticide_container_batch)
    (container_allocated_to_crew ?sprayer_crew - sprayer_crew ?pesticide_container_batch - pesticide_container_batch)
    (slot_assigned_to_management_unit ?field_manager - field_manager ?application_slot - application_slot)
    (slot_ready ?application_slot - application_slot)
    (slot_has_container ?application_slot - application_slot)
    (management_unit_slot_confirmed ?field_manager - field_manager)
    (route_segment_assigned_to_crew ?sprayer_crew - sprayer_crew ?application_route_segment - application_route_segment)
    (route_segment_ready ?application_route_segment - application_route_segment)
    (route_segment_has_container ?application_route_segment - application_route_segment)
    (crew_route_confirmed ?sprayer_crew - sprayer_crew)
    (load_unit_available ?pesticide_load_unit - pesticide_load_unit)
    (load_unit_created ?pesticide_load_unit - pesticide_load_unit)
    (load_unit_assigned_slot ?pesticide_load_unit - pesticide_load_unit ?application_slot - application_slot)
    (load_unit_assigned_route_segment ?pesticide_load_unit - pesticide_load_unit ?application_route_segment - application_route_segment)
    (load_unit_staging_flag ?pesticide_load_unit - pesticide_load_unit)
    (load_unit_secondary_staging_flag ?pesticide_load_unit - pesticide_load_unit)
    (load_unit_mixing_ready ?pesticide_load_unit - pesticide_load_unit)
    (site_managed_by ?application_site - application_site ?field_manager - field_manager)
    (site_assigned_to_crew ?application_site - application_site ?sprayer_crew - sprayer_crew)
    (site_linked_to_load_unit ?application_site - application_site ?pesticide_load_unit - pesticide_load_unit)
    (mixing_unit_available ?mixing_unit - mixing_unit)
    (mixing_unit_assigned_to_site ?application_site - application_site ?mixing_unit - mixing_unit)
    (mixing_unit_in_use ?mixing_unit - mixing_unit)
    (mixing_unit_used_for_load_unit ?mixing_unit - mixing_unit ?pesticide_load_unit - pesticide_load_unit)
    (site_specialization_applied ?application_site - application_site)
    (site_compliance_step1 ?application_site - application_site)
    (site_compliance_step2 ?application_site - application_site)
    (permit_attached_to_site ?application_site - application_site)
    (permit_verified_for_site ?application_site - application_site)
    (site_monitoring_ready ?application_site - application_site)
    (site_monitoring_confirmed ?application_site - application_site)
    (compliance_document_available ?compliance_document - compliance_document)
    (compliance_document_attached_to_site ?application_site - application_site ?compliance_document - compliance_document)
    (site_specialization_approved ?application_site - application_site)
    (site_authorization_attached ?application_site - application_site)
    (site_authorization_confirmed ?application_site - application_site)
    (operational_permit_available ?operational_permit - operational_permit)
    (site_has_operational_permit ?application_site - application_site ?operational_permit - operational_permit)
    (monitoring_module_available ?monitoring_module - monitoring_module)
    (monitoring_module_attached_to_site ?application_site - application_site ?monitoring_module - monitoring_module)
    (ppe_kit_available ?ppe_kit - ppe_kit)
    (ppe_kit_assigned_to_site ?application_site - application_site ?ppe_kit - ppe_kit)
    (pesticide_authorization_available ?pesticide_authorization - pesticide_authorization)
    (pesticide_authorization_attached_to_site ?application_site - application_site ?pesticide_authorization - pesticide_authorization)
    (reserve_stock_available ?reserve_stock - reserve_stock)
    (reserve_stock_allocated_to_entity ?treatment_entity - treatment_entity ?reserve_stock - reserve_stock)
    (manager_slot_locked ?field_manager - field_manager)
    (crew_slot_locked ?sprayer_crew - sprayer_crew)
    (site_activation_recorded ?application_site - application_site)
  )
  (:action register_treatment_entity
    :parameters (?treatment_entity - treatment_entity)
    :precondition
      (and
        (not
          (entity_registered ?treatment_entity)
        )
        (not
          (entity_assignment_confirmed ?treatment_entity)
        )
      )
    :effect (entity_registered ?treatment_entity)
  )
  (:action assign_equipment_to_entity
    :parameters (?treatment_entity - treatment_entity ?equipment_asset - equipment_asset)
    :precondition
      (and
        (entity_registered ?treatment_entity)
        (not
          (entity_has_equipment ?treatment_entity)
        )
        (equipment_available ?equipment_asset)
      )
    :effect
      (and
        (entity_has_equipment ?treatment_entity)
        (equipment_allocated_to_entity ?treatment_entity ?equipment_asset)
        (not
          (equipment_available ?equipment_asset)
        )
      )
  )
  (:action assign_pesticide_product_to_entity
    :parameters (?treatment_entity - treatment_entity ?pesticide_product - pesticide_product)
    :precondition
      (and
        (entity_registered ?treatment_entity)
        (entity_has_equipment ?treatment_entity)
        (pesticide_product_available ?pesticide_product)
      )
    :effect
      (and
        (pesticide_product_assigned ?treatment_entity ?pesticide_product)
        (not
          (pesticide_product_available ?pesticide_product)
        )
      )
  )
  (:action confirm_pesticide_assignment_for_entity
    :parameters (?treatment_entity - treatment_entity ?pesticide_product - pesticide_product)
    :precondition
      (and
        (entity_registered ?treatment_entity)
        (entity_has_equipment ?treatment_entity)
        (pesticide_product_assigned ?treatment_entity ?pesticide_product)
        (not
          (entity_ready ?treatment_entity)
        )
      )
    :effect (entity_ready ?treatment_entity)
  )
  (:action reclaim_pesticide_product_from_entity
    :parameters (?treatment_entity - treatment_entity ?pesticide_product - pesticide_product)
    :precondition
      (and
        (pesticide_product_assigned ?treatment_entity ?pesticide_product)
      )
    :effect
      (and
        (pesticide_product_available ?pesticide_product)
        (not
          (pesticide_product_assigned ?treatment_entity ?pesticide_product)
        )
      )
  )
  (:action assign_certified_operator_to_entity
    :parameters (?treatment_entity - treatment_entity ?certified_operator - certified_operator)
    :precondition
      (and
        (entity_ready ?treatment_entity)
        (operator_available ?certified_operator)
      )
    :effect
      (and
        (operator_assigned_to_entity ?treatment_entity ?certified_operator)
        (not
          (operator_available ?certified_operator)
        )
      )
  )
  (:action release_certified_operator_from_entity
    :parameters (?treatment_entity - treatment_entity ?certified_operator - certified_operator)
    :precondition
      (and
        (operator_assigned_to_entity ?treatment_entity ?certified_operator)
      )
    :effect
      (and
        (operator_available ?certified_operator)
        (not
          (operator_assigned_to_entity ?treatment_entity ?certified_operator)
        )
      )
  )
  (:action assign_ppe_to_site
    :parameters (?application_site - application_site ?ppe_kit - ppe_kit)
    :precondition
      (and
        (entity_ready ?application_site)
        (ppe_kit_available ?ppe_kit)
      )
    :effect
      (and
        (ppe_kit_assigned_to_site ?application_site ?ppe_kit)
        (not
          (ppe_kit_available ?ppe_kit)
        )
      )
  )
  (:action release_ppe_from_site
    :parameters (?application_site - application_site ?ppe_kit - ppe_kit)
    :precondition
      (and
        (ppe_kit_assigned_to_site ?application_site ?ppe_kit)
      )
    :effect
      (and
        (ppe_kit_available ?ppe_kit)
        (not
          (ppe_kit_assigned_to_site ?application_site ?ppe_kit)
        )
      )
  )
  (:action assign_pesticide_authorization_to_site
    :parameters (?application_site - application_site ?pesticide_authorization - pesticide_authorization)
    :precondition
      (and
        (entity_ready ?application_site)
        (pesticide_authorization_available ?pesticide_authorization)
      )
    :effect
      (and
        (pesticide_authorization_attached_to_site ?application_site ?pesticide_authorization)
        (not
          (pesticide_authorization_available ?pesticide_authorization)
        )
      )
  )
  (:action release_pesticide_authorization_from_site
    :parameters (?application_site - application_site ?pesticide_authorization - pesticide_authorization)
    :precondition
      (and
        (pesticide_authorization_attached_to_site ?application_site ?pesticide_authorization)
      )
    :effect
      (and
        (pesticide_authorization_available ?pesticide_authorization)
        (not
          (pesticide_authorization_attached_to_site ?application_site ?pesticide_authorization)
        )
      )
  )
  (:action mark_application_slot_ready
    :parameters (?field_manager - field_manager ?application_slot - application_slot ?pesticide_product - pesticide_product)
    :precondition
      (and
        (entity_ready ?field_manager)
        (pesticide_product_assigned ?field_manager ?pesticide_product)
        (slot_assigned_to_management_unit ?field_manager ?application_slot)
        (not
          (slot_ready ?application_slot)
        )
        (not
          (slot_has_container ?application_slot)
        )
      )
    :effect (slot_ready ?application_slot)
  )
  (:action reserve_slot_for_manager
    :parameters (?field_manager - field_manager ?application_slot - application_slot ?certified_operator - certified_operator)
    :precondition
      (and
        (entity_ready ?field_manager)
        (operator_assigned_to_entity ?field_manager ?certified_operator)
        (slot_assigned_to_management_unit ?field_manager ?application_slot)
        (slot_ready ?application_slot)
        (not
          (manager_slot_locked ?field_manager)
        )
      )
    :effect
      (and
        (manager_slot_locked ?field_manager)
        (management_unit_slot_confirmed ?field_manager)
      )
  )
  (:action assign_container_batch_to_manager_slot
    :parameters (?field_manager - field_manager ?application_slot - application_slot ?pesticide_container_batch - pesticide_container_batch)
    :precondition
      (and
        (entity_ready ?field_manager)
        (slot_assigned_to_management_unit ?field_manager ?application_slot)
        (container_batch_available ?pesticide_container_batch)
        (not
          (manager_slot_locked ?field_manager)
        )
      )
    :effect
      (and
        (slot_has_container ?application_slot)
        (manager_slot_locked ?field_manager)
        (container_allocated_to_manager ?field_manager ?pesticide_container_batch)
        (not
          (container_batch_available ?pesticide_container_batch)
        )
      )
  )
  (:action confirm_container_assignment_for_slot
    :parameters (?field_manager - field_manager ?application_slot - application_slot ?pesticide_product - pesticide_product ?pesticide_container_batch - pesticide_container_batch)
    :precondition
      (and
        (entity_ready ?field_manager)
        (pesticide_product_assigned ?field_manager ?pesticide_product)
        (slot_assigned_to_management_unit ?field_manager ?application_slot)
        (slot_has_container ?application_slot)
        (container_allocated_to_manager ?field_manager ?pesticide_container_batch)
        (not
          (management_unit_slot_confirmed ?field_manager)
        )
      )
    :effect
      (and
        (slot_ready ?application_slot)
        (management_unit_slot_confirmed ?field_manager)
        (container_batch_available ?pesticide_container_batch)
        (not
          (container_allocated_to_manager ?field_manager ?pesticide_container_batch)
        )
      )
  )
  (:action mark_route_segment_ready
    :parameters (?sprayer_crew - sprayer_crew ?application_route_segment - application_route_segment ?pesticide_product - pesticide_product)
    :precondition
      (and
        (entity_ready ?sprayer_crew)
        (pesticide_product_assigned ?sprayer_crew ?pesticide_product)
        (route_segment_assigned_to_crew ?sprayer_crew ?application_route_segment)
        (not
          (route_segment_ready ?application_route_segment)
        )
        (not
          (route_segment_has_container ?application_route_segment)
        )
      )
    :effect (route_segment_ready ?application_route_segment)
  )
  (:action reserve_route_segment_for_crew
    :parameters (?sprayer_crew - sprayer_crew ?application_route_segment - application_route_segment ?certified_operator - certified_operator)
    :precondition
      (and
        (entity_ready ?sprayer_crew)
        (operator_assigned_to_entity ?sprayer_crew ?certified_operator)
        (route_segment_assigned_to_crew ?sprayer_crew ?application_route_segment)
        (route_segment_ready ?application_route_segment)
        (not
          (crew_slot_locked ?sprayer_crew)
        )
      )
    :effect
      (and
        (crew_slot_locked ?sprayer_crew)
        (crew_route_confirmed ?sprayer_crew)
      )
  )
  (:action assign_container_batch_to_crew_route_segment
    :parameters (?sprayer_crew - sprayer_crew ?application_route_segment - application_route_segment ?pesticide_container_batch - pesticide_container_batch)
    :precondition
      (and
        (entity_ready ?sprayer_crew)
        (route_segment_assigned_to_crew ?sprayer_crew ?application_route_segment)
        (container_batch_available ?pesticide_container_batch)
        (not
          (crew_slot_locked ?sprayer_crew)
        )
      )
    :effect
      (and
        (route_segment_has_container ?application_route_segment)
        (crew_slot_locked ?sprayer_crew)
        (container_allocated_to_crew ?sprayer_crew ?pesticide_container_batch)
        (not
          (container_batch_available ?pesticide_container_batch)
        )
      )
  )
  (:action confirm_container_assignment_for_route_segment
    :parameters (?sprayer_crew - sprayer_crew ?application_route_segment - application_route_segment ?pesticide_product - pesticide_product ?pesticide_container_batch - pesticide_container_batch)
    :precondition
      (and
        (entity_ready ?sprayer_crew)
        (pesticide_product_assigned ?sprayer_crew ?pesticide_product)
        (route_segment_assigned_to_crew ?sprayer_crew ?application_route_segment)
        (route_segment_has_container ?application_route_segment)
        (container_allocated_to_crew ?sprayer_crew ?pesticide_container_batch)
        (not
          (crew_route_confirmed ?sprayer_crew)
        )
      )
    :effect
      (and
        (route_segment_ready ?application_route_segment)
        (crew_route_confirmed ?sprayer_crew)
        (container_batch_available ?pesticide_container_batch)
        (not
          (container_allocated_to_crew ?sprayer_crew ?pesticide_container_batch)
        )
      )
  )
  (:action assemble_pesticide_load_unit
    :parameters (?field_manager - field_manager ?sprayer_crew - sprayer_crew ?application_slot - application_slot ?application_route_segment - application_route_segment ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (manager_slot_locked ?field_manager)
        (crew_slot_locked ?sprayer_crew)
        (slot_assigned_to_management_unit ?field_manager ?application_slot)
        (route_segment_assigned_to_crew ?sprayer_crew ?application_route_segment)
        (slot_ready ?application_slot)
        (route_segment_ready ?application_route_segment)
        (management_unit_slot_confirmed ?field_manager)
        (crew_route_confirmed ?sprayer_crew)
        (load_unit_available ?pesticide_load_unit)
      )
    :effect
      (and
        (load_unit_created ?pesticide_load_unit)
        (load_unit_assigned_slot ?pesticide_load_unit ?application_slot)
        (load_unit_assigned_route_segment ?pesticide_load_unit ?application_route_segment)
        (not
          (load_unit_available ?pesticide_load_unit)
        )
      )
  )
  (:action assemble_and_stage_load_unit
    :parameters (?field_manager - field_manager ?sprayer_crew - sprayer_crew ?application_slot - application_slot ?application_route_segment - application_route_segment ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (manager_slot_locked ?field_manager)
        (crew_slot_locked ?sprayer_crew)
        (slot_assigned_to_management_unit ?field_manager ?application_slot)
        (route_segment_assigned_to_crew ?sprayer_crew ?application_route_segment)
        (slot_has_container ?application_slot)
        (route_segment_ready ?application_route_segment)
        (not
          (management_unit_slot_confirmed ?field_manager)
        )
        (crew_route_confirmed ?sprayer_crew)
        (load_unit_available ?pesticide_load_unit)
      )
    :effect
      (and
        (load_unit_created ?pesticide_load_unit)
        (load_unit_assigned_slot ?pesticide_load_unit ?application_slot)
        (load_unit_assigned_route_segment ?pesticide_load_unit ?application_route_segment)
        (load_unit_staging_flag ?pesticide_load_unit)
        (not
          (load_unit_available ?pesticide_load_unit)
        )
      )
  )
  (:action assemble_and_stage_load_unit_secondary
    :parameters (?field_manager - field_manager ?sprayer_crew - sprayer_crew ?application_slot - application_slot ?application_route_segment - application_route_segment ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (manager_slot_locked ?field_manager)
        (crew_slot_locked ?sprayer_crew)
        (slot_assigned_to_management_unit ?field_manager ?application_slot)
        (route_segment_assigned_to_crew ?sprayer_crew ?application_route_segment)
        (slot_ready ?application_slot)
        (route_segment_has_container ?application_route_segment)
        (management_unit_slot_confirmed ?field_manager)
        (not
          (crew_route_confirmed ?sprayer_crew)
        )
        (load_unit_available ?pesticide_load_unit)
      )
    :effect
      (and
        (load_unit_created ?pesticide_load_unit)
        (load_unit_assigned_slot ?pesticide_load_unit ?application_slot)
        (load_unit_assigned_route_segment ?pesticide_load_unit ?application_route_segment)
        (load_unit_secondary_staging_flag ?pesticide_load_unit)
        (not
          (load_unit_available ?pesticide_load_unit)
        )
      )
  )
  (:action assemble_and_stage_load_unit_full_staging
    :parameters (?field_manager - field_manager ?sprayer_crew - sprayer_crew ?application_slot - application_slot ?application_route_segment - application_route_segment ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (manager_slot_locked ?field_manager)
        (crew_slot_locked ?sprayer_crew)
        (slot_assigned_to_management_unit ?field_manager ?application_slot)
        (route_segment_assigned_to_crew ?sprayer_crew ?application_route_segment)
        (slot_has_container ?application_slot)
        (route_segment_has_container ?application_route_segment)
        (not
          (management_unit_slot_confirmed ?field_manager)
        )
        (not
          (crew_route_confirmed ?sprayer_crew)
        )
        (load_unit_available ?pesticide_load_unit)
      )
    :effect
      (and
        (load_unit_created ?pesticide_load_unit)
        (load_unit_assigned_slot ?pesticide_load_unit ?application_slot)
        (load_unit_assigned_route_segment ?pesticide_load_unit ?application_route_segment)
        (load_unit_staging_flag ?pesticide_load_unit)
        (load_unit_secondary_staging_flag ?pesticide_load_unit)
        (not
          (load_unit_available ?pesticide_load_unit)
        )
      )
  )
  (:action mark_load_unit_ready_for_mixing
    :parameters (?pesticide_load_unit - pesticide_load_unit ?field_manager - field_manager ?pesticide_product - pesticide_product)
    :precondition
      (and
        (load_unit_created ?pesticide_load_unit)
        (manager_slot_locked ?field_manager)
        (pesticide_product_assigned ?field_manager ?pesticide_product)
        (not
          (load_unit_mixing_ready ?pesticide_load_unit)
        )
      )
    :effect (load_unit_mixing_ready ?pesticide_load_unit)
  )
  (:action prepare_mixing_unit_for_load
    :parameters (?application_site - application_site ?mixing_unit - mixing_unit ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (entity_ready ?application_site)
        (site_linked_to_load_unit ?application_site ?pesticide_load_unit)
        (mixing_unit_assigned_to_site ?application_site ?mixing_unit)
        (mixing_unit_available ?mixing_unit)
        (load_unit_created ?pesticide_load_unit)
        (load_unit_mixing_ready ?pesticide_load_unit)
        (not
          (mixing_unit_in_use ?mixing_unit)
        )
      )
    :effect
      (and
        (mixing_unit_in_use ?mixing_unit)
        (mixing_unit_used_for_load_unit ?mixing_unit ?pesticide_load_unit)
        (not
          (mixing_unit_available ?mixing_unit)
        )
      )
  )
  (:action activate_site_for_mixing
    :parameters (?application_site - application_site ?mixing_unit - mixing_unit ?pesticide_load_unit - pesticide_load_unit ?pesticide_product - pesticide_product)
    :precondition
      (and
        (entity_ready ?application_site)
        (mixing_unit_assigned_to_site ?application_site ?mixing_unit)
        (mixing_unit_in_use ?mixing_unit)
        (mixing_unit_used_for_load_unit ?mixing_unit ?pesticide_load_unit)
        (pesticide_product_assigned ?application_site ?pesticide_product)
        (not
          (load_unit_staging_flag ?pesticide_load_unit)
        )
        (not
          (site_specialization_applied ?application_site)
        )
      )
    :effect (site_specialization_applied ?application_site)
  )
  (:action attach_operational_permit_to_site
    :parameters (?application_site - application_site ?operational_permit - operational_permit)
    :precondition
      (and
        (entity_ready ?application_site)
        (operational_permit_available ?operational_permit)
        (not
          (permit_attached_to_site ?application_site)
        )
      )
    :effect
      (and
        (permit_attached_to_site ?application_site)
        (site_has_operational_permit ?application_site ?operational_permit)
        (not
          (operational_permit_available ?operational_permit)
        )
      )
  )
  (:action verify_site_permit_and_advance
    :parameters (?application_site - application_site ?mixing_unit - mixing_unit ?pesticide_load_unit - pesticide_load_unit ?pesticide_product - pesticide_product ?operational_permit - operational_permit)
    :precondition
      (and
        (entity_ready ?application_site)
        (mixing_unit_assigned_to_site ?application_site ?mixing_unit)
        (mixing_unit_in_use ?mixing_unit)
        (mixing_unit_used_for_load_unit ?mixing_unit ?pesticide_load_unit)
        (pesticide_product_assigned ?application_site ?pesticide_product)
        (load_unit_staging_flag ?pesticide_load_unit)
        (permit_attached_to_site ?application_site)
        (site_has_operational_permit ?application_site ?operational_permit)
        (not
          (site_specialization_applied ?application_site)
        )
      )
    :effect
      (and
        (site_specialization_applied ?application_site)
        (permit_verified_for_site ?application_site)
      )
  )
  (:action apply_ppe_and_confirm_site_compliance
    :parameters (?application_site - application_site ?ppe_kit - ppe_kit ?certified_operator - certified_operator ?mixing_unit - mixing_unit ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (site_specialization_applied ?application_site)
        (ppe_kit_assigned_to_site ?application_site ?ppe_kit)
        (operator_assigned_to_entity ?application_site ?certified_operator)
        (mixing_unit_assigned_to_site ?application_site ?mixing_unit)
        (mixing_unit_used_for_load_unit ?mixing_unit ?pesticide_load_unit)
        (not
          (load_unit_secondary_staging_flag ?pesticide_load_unit)
        )
        (not
          (site_compliance_step1 ?application_site)
        )
      )
    :effect (site_compliance_step1 ?application_site)
  )
  (:action apply_ppe_and_confirm_site_compliance_secondary
    :parameters (?application_site - application_site ?ppe_kit - ppe_kit ?certified_operator - certified_operator ?mixing_unit - mixing_unit ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (site_specialization_applied ?application_site)
        (ppe_kit_assigned_to_site ?application_site ?ppe_kit)
        (operator_assigned_to_entity ?application_site ?certified_operator)
        (mixing_unit_assigned_to_site ?application_site ?mixing_unit)
        (mixing_unit_used_for_load_unit ?mixing_unit ?pesticide_load_unit)
        (load_unit_secondary_staging_flag ?pesticide_load_unit)
        (not
          (site_compliance_step1 ?application_site)
        )
      )
    :effect (site_compliance_step1 ?application_site)
  )
  (:action confirm_site_authorization_stage_two
    :parameters (?application_site - application_site ?pesticide_authorization - pesticide_authorization ?mixing_unit - mixing_unit ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (site_compliance_step1 ?application_site)
        (pesticide_authorization_attached_to_site ?application_site ?pesticide_authorization)
        (mixing_unit_assigned_to_site ?application_site ?mixing_unit)
        (mixing_unit_used_for_load_unit ?mixing_unit ?pesticide_load_unit)
        (not
          (load_unit_staging_flag ?pesticide_load_unit)
        )
        (not
          (load_unit_secondary_staging_flag ?pesticide_load_unit)
        )
        (not
          (site_compliance_step2 ?application_site)
        )
      )
    :effect (site_compliance_step2 ?application_site)
  )
  (:action confirm_site_authorization_and_mark_monitoring_ready
    :parameters (?application_site - application_site ?pesticide_authorization - pesticide_authorization ?mixing_unit - mixing_unit ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (site_compliance_step1 ?application_site)
        (pesticide_authorization_attached_to_site ?application_site ?pesticide_authorization)
        (mixing_unit_assigned_to_site ?application_site ?mixing_unit)
        (mixing_unit_used_for_load_unit ?mixing_unit ?pesticide_load_unit)
        (load_unit_staging_flag ?pesticide_load_unit)
        (not
          (load_unit_secondary_staging_flag ?pesticide_load_unit)
        )
        (not
          (site_compliance_step2 ?application_site)
        )
      )
    :effect
      (and
        (site_compliance_step2 ?application_site)
        (site_monitoring_ready ?application_site)
      )
  )
  (:action confirm_site_authorization_and_mark_monitoring_ready_alt
    :parameters (?application_site - application_site ?pesticide_authorization - pesticide_authorization ?mixing_unit - mixing_unit ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (site_compliance_step1 ?application_site)
        (pesticide_authorization_attached_to_site ?application_site ?pesticide_authorization)
        (mixing_unit_assigned_to_site ?application_site ?mixing_unit)
        (mixing_unit_used_for_load_unit ?mixing_unit ?pesticide_load_unit)
        (not
          (load_unit_staging_flag ?pesticide_load_unit)
        )
        (load_unit_secondary_staging_flag ?pesticide_load_unit)
        (not
          (site_compliance_step2 ?application_site)
        )
      )
    :effect
      (and
        (site_compliance_step2 ?application_site)
        (site_monitoring_ready ?application_site)
      )
  )
  (:action confirm_site_authorization_and_mark_monitoring_ready_alt2
    :parameters (?application_site - application_site ?pesticide_authorization - pesticide_authorization ?mixing_unit - mixing_unit ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (site_compliance_step1 ?application_site)
        (pesticide_authorization_attached_to_site ?application_site ?pesticide_authorization)
        (mixing_unit_assigned_to_site ?application_site ?mixing_unit)
        (mixing_unit_used_for_load_unit ?mixing_unit ?pesticide_load_unit)
        (load_unit_staging_flag ?pesticide_load_unit)
        (load_unit_secondary_staging_flag ?pesticide_load_unit)
        (not
          (site_compliance_step2 ?application_site)
        )
      )
    :effect
      (and
        (site_compliance_step2 ?application_site)
        (site_monitoring_ready ?application_site)
      )
  )
  (:action finalize_site_activation
    :parameters (?application_site - application_site)
    :precondition
      (and
        (site_compliance_step2 ?application_site)
        (not
          (site_monitoring_ready ?application_site)
        )
        (not
          (site_activation_recorded ?application_site)
        )
      )
    :effect
      (and
        (site_activation_recorded ?application_site)
        (has_assigned_load ?application_site)
      )
  )
  (:action attach_monitoring_module_to_site
    :parameters (?application_site - application_site ?monitoring_module - monitoring_module)
    :precondition
      (and
        (site_compliance_step2 ?application_site)
        (site_monitoring_ready ?application_site)
        (monitoring_module_available ?monitoring_module)
      )
    :effect
      (and
        (monitoring_module_attached_to_site ?application_site ?monitoring_module)
        (not
          (monitoring_module_available ?monitoring_module)
        )
      )
  )
  (:action confirm_monitoring_and_activate_site_operations
    :parameters (?application_site - application_site ?field_manager - field_manager ?sprayer_crew - sprayer_crew ?pesticide_product - pesticide_product ?monitoring_module - monitoring_module)
    :precondition
      (and
        (site_compliance_step2 ?application_site)
        (site_monitoring_ready ?application_site)
        (monitoring_module_attached_to_site ?application_site ?monitoring_module)
        (site_managed_by ?application_site ?field_manager)
        (site_assigned_to_crew ?application_site ?sprayer_crew)
        (management_unit_slot_confirmed ?field_manager)
        (crew_route_confirmed ?sprayer_crew)
        (pesticide_product_assigned ?application_site ?pesticide_product)
        (not
          (site_monitoring_confirmed ?application_site)
        )
      )
    :effect (site_monitoring_confirmed ?application_site)
  )
  (:action finalize_site_activation_post_monitoring
    :parameters (?application_site - application_site)
    :precondition
      (and
        (site_compliance_step2 ?application_site)
        (site_monitoring_confirmed ?application_site)
        (not
          (site_activation_recorded ?application_site)
        )
      )
    :effect
      (and
        (site_activation_recorded ?application_site)
        (has_assigned_load ?application_site)
      )
  )
  (:action apply_compliance_document_to_site
    :parameters (?application_site - application_site ?compliance_document - compliance_document ?pesticide_product - pesticide_product)
    :precondition
      (and
        (entity_ready ?application_site)
        (pesticide_product_assigned ?application_site ?pesticide_product)
        (compliance_document_available ?compliance_document)
        (compliance_document_attached_to_site ?application_site ?compliance_document)
        (not
          (site_specialization_approved ?application_site)
        )
      )
    :effect
      (and
        (site_specialization_approved ?application_site)
        (not
          (compliance_document_available ?compliance_document)
        )
      )
  )
  (:action attach_operator_authorization_step
    :parameters (?application_site - application_site ?certified_operator - certified_operator)
    :precondition
      (and
        (site_specialization_approved ?application_site)
        (operator_assigned_to_entity ?application_site ?certified_operator)
        (not
          (site_authorization_attached ?application_site)
        )
      )
    :effect (site_authorization_attached ?application_site)
  )
  (:action confirm_authorization_stage_for_site
    :parameters (?application_site - application_site ?pesticide_authorization - pesticide_authorization)
    :precondition
      (and
        (site_authorization_attached ?application_site)
        (pesticide_authorization_attached_to_site ?application_site ?pesticide_authorization)
        (not
          (site_authorization_confirmed ?application_site)
        )
      )
    :effect (site_authorization_confirmed ?application_site)
  )
  (:action finalize_site_authorization_activation
    :parameters (?application_site - application_site)
    :precondition
      (and
        (site_authorization_confirmed ?application_site)
        (not
          (site_activation_recorded ?application_site)
        )
      )
    :effect
      (and
        (site_activation_recorded ?application_site)
        (has_assigned_load ?application_site)
      )
  )
  (:action assign_load_to_manager
    :parameters (?field_manager - field_manager ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (manager_slot_locked ?field_manager)
        (management_unit_slot_confirmed ?field_manager)
        (load_unit_created ?pesticide_load_unit)
        (load_unit_mixing_ready ?pesticide_load_unit)
        (not
          (has_assigned_load ?field_manager)
        )
      )
    :effect (has_assigned_load ?field_manager)
  )
  (:action assign_load_to_crew
    :parameters (?sprayer_crew - sprayer_crew ?pesticide_load_unit - pesticide_load_unit)
    :precondition
      (and
        (crew_slot_locked ?sprayer_crew)
        (crew_route_confirmed ?sprayer_crew)
        (load_unit_created ?pesticide_load_unit)
        (load_unit_mixing_ready ?pesticide_load_unit)
        (not
          (has_assigned_load ?sprayer_crew)
        )
      )
    :effect (has_assigned_load ?sprayer_crew)
  )
  (:action allocate_reserve_stock_to_entity
    :parameters (?treatment_entity - treatment_entity ?reserve_stock - reserve_stock ?pesticide_product - pesticide_product)
    :precondition
      (and
        (has_assigned_load ?treatment_entity)
        (pesticide_product_assigned ?treatment_entity ?pesticide_product)
        (reserve_stock_available ?reserve_stock)
        (not
          (entity_ready_for_final_assignment ?treatment_entity)
        )
      )
    :effect
      (and
        (entity_ready_for_final_assignment ?treatment_entity)
        (reserve_stock_allocated_to_entity ?treatment_entity ?reserve_stock)
        (not
          (reserve_stock_available ?reserve_stock)
        )
      )
  )
  (:action finalize_assignment_and_release_equipment
    :parameters (?field_manager - field_manager ?equipment_asset - equipment_asset ?reserve_stock - reserve_stock)
    :precondition
      (and
        (entity_ready_for_final_assignment ?field_manager)
        (equipment_allocated_to_entity ?field_manager ?equipment_asset)
        (reserve_stock_allocated_to_entity ?field_manager ?reserve_stock)
        (not
          (entity_assignment_confirmed ?field_manager)
        )
      )
    :effect
      (and
        (entity_assignment_confirmed ?field_manager)
        (equipment_available ?equipment_asset)
        (reserve_stock_available ?reserve_stock)
      )
  )
  (:action finalize_assignment_and_release_equipment_for_crew
    :parameters (?sprayer_crew - sprayer_crew ?equipment_asset - equipment_asset ?reserve_stock - reserve_stock)
    :precondition
      (and
        (entity_ready_for_final_assignment ?sprayer_crew)
        (equipment_allocated_to_entity ?sprayer_crew ?equipment_asset)
        (reserve_stock_allocated_to_entity ?sprayer_crew ?reserve_stock)
        (not
          (entity_assignment_confirmed ?sprayer_crew)
        )
      )
    :effect
      (and
        (entity_assignment_confirmed ?sprayer_crew)
        (equipment_available ?equipment_asset)
        (reserve_stock_available ?reserve_stock)
      )
  )
  (:action finalize_assignment_and_release_equipment_for_site
    :parameters (?application_site - application_site ?equipment_asset - equipment_asset ?reserve_stock - reserve_stock)
    :precondition
      (and
        (entity_ready_for_final_assignment ?application_site)
        (equipment_allocated_to_entity ?application_site ?equipment_asset)
        (reserve_stock_allocated_to_entity ?application_site ?reserve_stock)
        (not
          (entity_assignment_confirmed ?application_site)
        )
      )
    :effect
      (and
        (entity_assignment_confirmed ?application_site)
        (equipment_available ?equipment_asset)
        (reserve_stock_available ?reserve_stock)
      )
  )
)

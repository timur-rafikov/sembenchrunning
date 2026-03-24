(define (domain pesticide_treatment_window_selection)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_item - object logistics_category_material - object temporal_category_window - object planning_entity_root - object planning_entity - planning_entity_root application_equipment - resource_item pesticide_product - resource_item crew_or_operator - resource_item compliance_document - resource_item regulatory_approval - resource_item schedule_slot - resource_item safety_equipment - resource_item permit - resource_item consumable_item - logistics_category_material material_batch - logistics_category_material site_condition_marker - logistics_category_material weather_window - temporal_category_window time_slot_variant - temporal_category_window application_task - temporal_category_window field_subcategory_primary - planning_entity field_subcategory_plan - planning_entity primary_field_unit - field_subcategory_primary secondary_field_unit - field_subcategory_primary treatment_plan - field_subcategory_plan)
  (:predicates
    (planning_entity_onboarded ?planning_entity - planning_entity)
    (eligible_for_assignment ?planning_entity - planning_entity)
    (equipment_allocated ?planning_entity - planning_entity)
    (application_assigned ?planning_entity - planning_entity)
    (ready_for_execution ?planning_entity - planning_entity)
    (final_approval_granted ?planning_entity - planning_entity)
    (equipment_available ?application_equipment - application_equipment)
    (equipment_assigned_to_entity ?planning_entity - planning_entity ?application_equipment - application_equipment)
    (product_available ?pesticide_product - pesticide_product)
    (product_reserved_for_entity ?planning_entity - planning_entity ?pesticide_product - pesticide_product)
    (crew_available ?crew_or_operator - crew_or_operator)
    (crew_assigned_to_entity ?planning_entity - planning_entity ?crew_or_operator - crew_or_operator)
    (consumable_available ?consumable_item - consumable_item)
    (consumable_reserved_for_primary_field ?primary_field_unit - primary_field_unit ?consumable_item - consumable_item)
    (consumable_reserved_for_secondary_field ?secondary_field_unit - secondary_field_unit ?consumable_item - consumable_item)
    (candidate_window_for_primary_field ?primary_field_unit - primary_field_unit ?weather_window - weather_window)
    (weather_window_proposed ?weather_window - weather_window)
    (weather_window_eligible ?weather_window - weather_window)
    (primary_field_window_confirmed ?primary_field_unit - primary_field_unit)
    (candidate_time_variant_for_secondary_field ?secondary_field_unit - secondary_field_unit ?time_slot_variant - time_slot_variant)
    (time_slot_variant_proposed ?time_slot_variant - time_slot_variant)
    (time_slot_variant_eligible ?time_slot_variant - time_slot_variant)
    (secondary_field_time_variant_confirmed ?secondary_field_unit - secondary_field_unit)
    (task_available_for_staging ?application_task - application_task)
    (task_staged ?application_task - application_task)
    (task_assigned_window ?application_task - application_task ?weather_window - weather_window)
    (task_assigned_time_variant ?application_task - application_task ?time_slot_variant - time_slot_variant)
    (task_requires_compliance_document ?application_task - application_task)
    (task_requires_permit ?application_task - application_task)
    (task_materials_verified ?application_task - application_task)
    (plan_targets_primary_field ?treatment_plan - treatment_plan ?primary_field_unit - primary_field_unit)
    (plan_targets_secondary_field ?treatment_plan - treatment_plan ?secondary_field_unit - secondary_field_unit)
    (plan_associated_with_task ?treatment_plan - treatment_plan ?application_task - application_task)
    (material_batch_available ?material_batch - material_batch)
    (plan_has_material_batch ?treatment_plan - treatment_plan ?material_batch - material_batch)
    (material_batch_staged ?material_batch - material_batch)
    (material_batch_staged_to_task ?material_batch - material_batch ?application_task - application_task)
    (plan_safety_equipment_attached ?treatment_plan - treatment_plan)
    (plan_materials_and_safety_ready ?treatment_plan - treatment_plan)
    (plan_finalization_eligible ?treatment_plan - treatment_plan)
    (compliance_document_attached ?treatment_plan - treatment_plan)
    (compliance_document_verified ?treatment_plan - treatment_plan)
    (regulatory_approval_attached ?treatment_plan - treatment_plan)
    (plan_authorized_by_operations ?treatment_plan - treatment_plan)
    (site_condition_marker_available ?site_condition_marker - site_condition_marker)
    (plan_has_site_condition_marker ?treatment_plan - treatment_plan ?site_condition_marker - site_condition_marker)
    (plan_site_marker_attached ?treatment_plan - treatment_plan)
    (plan_ready_for_permit_validation ?treatment_plan - treatment_plan)
    (plan_permit_verified ?treatment_plan - treatment_plan)
    (compliance_document_available ?compliance_document - compliance_document)
    (plan_has_compliance_document ?treatment_plan - treatment_plan ?compliance_document - compliance_document)
    (regulatory_approval_available ?regulatory_approval - regulatory_approval)
    (plan_has_regulatory_approval ?treatment_plan - treatment_plan ?regulatory_approval - regulatory_approval)
    (safety_equipment_available ?safety_equipment - safety_equipment)
    (plan_has_safety_equipment_reserved ?treatment_plan - treatment_plan ?safety_equipment - safety_equipment)
    (permit_available ?permit - permit)
    (plan_has_permit ?treatment_plan - treatment_plan ?permit - permit)
    (schedule_slot_available ?schedule_slot - schedule_slot)
    (entity_assigned_schedule_slot ?planning_entity - planning_entity ?schedule_slot - schedule_slot)
    (primary_field_ready_for_task ?primary_field_unit - primary_field_unit)
    (secondary_field_ready_for_task ?secondary_field_unit - secondary_field_unit)
    (plan_finalized ?treatment_plan - treatment_plan)
  )
  (:action register_planning_entity
    :parameters (?planning_entity - planning_entity)
    :precondition
      (and
        (not
          (planning_entity_onboarded ?planning_entity)
        )
        (not
          (application_assigned ?planning_entity)
        )
      )
    :effect (planning_entity_onboarded ?planning_entity)
  )
  (:action assign_equipment_to_entity
    :parameters (?planning_entity - planning_entity ?application_equipment - application_equipment)
    :precondition
      (and
        (planning_entity_onboarded ?planning_entity)
        (not
          (equipment_allocated ?planning_entity)
        )
        (equipment_available ?application_equipment)
      )
    :effect
      (and
        (equipment_allocated ?planning_entity)
        (equipment_assigned_to_entity ?planning_entity ?application_equipment)
        (not
          (equipment_available ?application_equipment)
        )
      )
  )
  (:action reserve_product_for_entity
    :parameters (?planning_entity - planning_entity ?pesticide_product - pesticide_product)
    :precondition
      (and
        (planning_entity_onboarded ?planning_entity)
        (equipment_allocated ?planning_entity)
        (product_available ?pesticide_product)
      )
    :effect
      (and
        (product_reserved_for_entity ?planning_entity ?pesticide_product)
        (not
          (product_available ?pesticide_product)
        )
      )
  )
  (:action confirm_product_selection
    :parameters (?planning_entity - planning_entity ?pesticide_product - pesticide_product)
    :precondition
      (and
        (planning_entity_onboarded ?planning_entity)
        (equipment_allocated ?planning_entity)
        (product_reserved_for_entity ?planning_entity ?pesticide_product)
        (not
          (eligible_for_assignment ?planning_entity)
        )
      )
    :effect (eligible_for_assignment ?planning_entity)
  )
  (:action release_product_reservation
    :parameters (?planning_entity - planning_entity ?pesticide_product - pesticide_product)
    :precondition
      (and
        (product_reserved_for_entity ?planning_entity ?pesticide_product)
      )
    :effect
      (and
        (product_available ?pesticide_product)
        (not
          (product_reserved_for_entity ?planning_entity ?pesticide_product)
        )
      )
  )
  (:action assign_crew_to_entity
    :parameters (?planning_entity - planning_entity ?crew_or_operator - crew_or_operator)
    :precondition
      (and
        (eligible_for_assignment ?planning_entity)
        (crew_available ?crew_or_operator)
      )
    :effect
      (and
        (crew_assigned_to_entity ?planning_entity ?crew_or_operator)
        (not
          (crew_available ?crew_or_operator)
        )
      )
  )
  (:action release_crew_from_entity
    :parameters (?planning_entity - planning_entity ?crew_or_operator - crew_or_operator)
    :precondition
      (and
        (crew_assigned_to_entity ?planning_entity ?crew_or_operator)
      )
    :effect
      (and
        (crew_available ?crew_or_operator)
        (not
          (crew_assigned_to_entity ?planning_entity ?crew_or_operator)
        )
      )
  )
  (:action assign_safety_equipment_to_plan
    :parameters (?treatment_plan - treatment_plan ?safety_equipment - safety_equipment)
    :precondition
      (and
        (eligible_for_assignment ?treatment_plan)
        (safety_equipment_available ?safety_equipment)
      )
    :effect
      (and
        (plan_has_safety_equipment_reserved ?treatment_plan ?safety_equipment)
        (not
          (safety_equipment_available ?safety_equipment)
        )
      )
  )
  (:action release_safety_equipment_from_plan
    :parameters (?treatment_plan - treatment_plan ?safety_equipment - safety_equipment)
    :precondition
      (and
        (plan_has_safety_equipment_reserved ?treatment_plan ?safety_equipment)
      )
    :effect
      (and
        (safety_equipment_available ?safety_equipment)
        (not
          (plan_has_safety_equipment_reserved ?treatment_plan ?safety_equipment)
        )
      )
  )
  (:action assign_permit_to_plan
    :parameters (?treatment_plan - treatment_plan ?permit - permit)
    :precondition
      (and
        (eligible_for_assignment ?treatment_plan)
        (permit_available ?permit)
      )
    :effect
      (and
        (plan_has_permit ?treatment_plan ?permit)
        (not
          (permit_available ?permit)
        )
      )
  )
  (:action release_permit_from_plan
    :parameters (?treatment_plan - treatment_plan ?permit - permit)
    :precondition
      (and
        (plan_has_permit ?treatment_plan ?permit)
      )
    :effect
      (and
        (permit_available ?permit)
        (not
          (plan_has_permit ?treatment_plan ?permit)
        )
      )
  )
  (:action identify_weather_window_for_primary_field
    :parameters (?primary_field_unit - primary_field_unit ?weather_window - weather_window ?pesticide_product - pesticide_product)
    :precondition
      (and
        (eligible_for_assignment ?primary_field_unit)
        (product_reserved_for_entity ?primary_field_unit ?pesticide_product)
        (candidate_window_for_primary_field ?primary_field_unit ?weather_window)
        (not
          (weather_window_proposed ?weather_window)
        )
        (not
          (weather_window_eligible ?weather_window)
        )
      )
    :effect (weather_window_proposed ?weather_window)
  )
  (:action confirm_window_and_lock_primary_field
    :parameters (?primary_field_unit - primary_field_unit ?weather_window - weather_window ?crew_or_operator - crew_or_operator)
    :precondition
      (and
        (eligible_for_assignment ?primary_field_unit)
        (crew_assigned_to_entity ?primary_field_unit ?crew_or_operator)
        (candidate_window_for_primary_field ?primary_field_unit ?weather_window)
        (weather_window_proposed ?weather_window)
        (not
          (primary_field_ready_for_task ?primary_field_unit)
        )
      )
    :effect
      (and
        (primary_field_ready_for_task ?primary_field_unit)
        (primary_field_window_confirmed ?primary_field_unit)
      )
  )
  (:action stage_consumable_for_primary_field_window
    :parameters (?primary_field_unit - primary_field_unit ?weather_window - weather_window ?consumable_item - consumable_item)
    :precondition
      (and
        (eligible_for_assignment ?primary_field_unit)
        (candidate_window_for_primary_field ?primary_field_unit ?weather_window)
        (consumable_available ?consumable_item)
        (not
          (primary_field_ready_for_task ?primary_field_unit)
        )
      )
    :effect
      (and
        (weather_window_eligible ?weather_window)
        (primary_field_ready_for_task ?primary_field_unit)
        (consumable_reserved_for_primary_field ?primary_field_unit ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action accept_primary_field_window
    :parameters (?primary_field_unit - primary_field_unit ?weather_window - weather_window ?pesticide_product - pesticide_product ?consumable_item - consumable_item)
    :precondition
      (and
        (eligible_for_assignment ?primary_field_unit)
        (product_reserved_for_entity ?primary_field_unit ?pesticide_product)
        (candidate_window_for_primary_field ?primary_field_unit ?weather_window)
        (weather_window_eligible ?weather_window)
        (consumable_reserved_for_primary_field ?primary_field_unit ?consumable_item)
        (not
          (primary_field_window_confirmed ?primary_field_unit)
        )
      )
    :effect
      (and
        (weather_window_proposed ?weather_window)
        (primary_field_window_confirmed ?primary_field_unit)
        (consumable_available ?consumable_item)
        (not
          (consumable_reserved_for_primary_field ?primary_field_unit ?consumable_item)
        )
      )
  )
  (:action identify_time_variant_for_secondary_field
    :parameters (?secondary_field_unit - secondary_field_unit ?time_slot_variant - time_slot_variant ?pesticide_product - pesticide_product)
    :precondition
      (and
        (eligible_for_assignment ?secondary_field_unit)
        (product_reserved_for_entity ?secondary_field_unit ?pesticide_product)
        (candidate_time_variant_for_secondary_field ?secondary_field_unit ?time_slot_variant)
        (not
          (time_slot_variant_proposed ?time_slot_variant)
        )
        (not
          (time_slot_variant_eligible ?time_slot_variant)
        )
      )
    :effect (time_slot_variant_proposed ?time_slot_variant)
  )
  (:action confirm_time_variant_and_lock_secondary_field
    :parameters (?secondary_field_unit - secondary_field_unit ?time_slot_variant - time_slot_variant ?crew_or_operator - crew_or_operator)
    :precondition
      (and
        (eligible_for_assignment ?secondary_field_unit)
        (crew_assigned_to_entity ?secondary_field_unit ?crew_or_operator)
        (candidate_time_variant_for_secondary_field ?secondary_field_unit ?time_slot_variant)
        (time_slot_variant_proposed ?time_slot_variant)
        (not
          (secondary_field_ready_for_task ?secondary_field_unit)
        )
      )
    :effect
      (and
        (secondary_field_ready_for_task ?secondary_field_unit)
        (secondary_field_time_variant_confirmed ?secondary_field_unit)
      )
  )
  (:action stage_consumable_for_secondary_field_variant
    :parameters (?secondary_field_unit - secondary_field_unit ?time_slot_variant - time_slot_variant ?consumable_item - consumable_item)
    :precondition
      (and
        (eligible_for_assignment ?secondary_field_unit)
        (candidate_time_variant_for_secondary_field ?secondary_field_unit ?time_slot_variant)
        (consumable_available ?consumable_item)
        (not
          (secondary_field_ready_for_task ?secondary_field_unit)
        )
      )
    :effect
      (and
        (time_slot_variant_eligible ?time_slot_variant)
        (secondary_field_ready_for_task ?secondary_field_unit)
        (consumable_reserved_for_secondary_field ?secondary_field_unit ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action accept_secondary_field_time_variant
    :parameters (?secondary_field_unit - secondary_field_unit ?time_slot_variant - time_slot_variant ?pesticide_product - pesticide_product ?consumable_item - consumable_item)
    :precondition
      (and
        (eligible_for_assignment ?secondary_field_unit)
        (product_reserved_for_entity ?secondary_field_unit ?pesticide_product)
        (candidate_time_variant_for_secondary_field ?secondary_field_unit ?time_slot_variant)
        (time_slot_variant_eligible ?time_slot_variant)
        (consumable_reserved_for_secondary_field ?secondary_field_unit ?consumable_item)
        (not
          (secondary_field_time_variant_confirmed ?secondary_field_unit)
        )
      )
    :effect
      (and
        (time_slot_variant_proposed ?time_slot_variant)
        (secondary_field_time_variant_confirmed ?secondary_field_unit)
        (consumable_available ?consumable_item)
        (not
          (consumable_reserved_for_secondary_field ?secondary_field_unit ?consumable_item)
        )
      )
  )
  (:action assemble_application_task
    :parameters (?primary_field_unit - primary_field_unit ?secondary_field_unit - secondary_field_unit ?weather_window - weather_window ?time_slot_variant - time_slot_variant ?application_task - application_task)
    :precondition
      (and
        (primary_field_ready_for_task ?primary_field_unit)
        (secondary_field_ready_for_task ?secondary_field_unit)
        (candidate_window_for_primary_field ?primary_field_unit ?weather_window)
        (candidate_time_variant_for_secondary_field ?secondary_field_unit ?time_slot_variant)
        (weather_window_proposed ?weather_window)
        (time_slot_variant_proposed ?time_slot_variant)
        (primary_field_window_confirmed ?primary_field_unit)
        (secondary_field_time_variant_confirmed ?secondary_field_unit)
        (task_available_for_staging ?application_task)
      )
    :effect
      (and
        (task_staged ?application_task)
        (task_assigned_window ?application_task ?weather_window)
        (task_assigned_time_variant ?application_task ?time_slot_variant)
        (not
          (task_available_for_staging ?application_task)
        )
      )
  )
  (:action assemble_application_task_with_primary_eligible_window
    :parameters (?primary_field_unit - primary_field_unit ?secondary_field_unit - secondary_field_unit ?weather_window - weather_window ?time_slot_variant - time_slot_variant ?application_task - application_task)
    :precondition
      (and
        (primary_field_ready_for_task ?primary_field_unit)
        (secondary_field_ready_for_task ?secondary_field_unit)
        (candidate_window_for_primary_field ?primary_field_unit ?weather_window)
        (candidate_time_variant_for_secondary_field ?secondary_field_unit ?time_slot_variant)
        (weather_window_eligible ?weather_window)
        (time_slot_variant_proposed ?time_slot_variant)
        (not
          (primary_field_window_confirmed ?primary_field_unit)
        )
        (secondary_field_time_variant_confirmed ?secondary_field_unit)
        (task_available_for_staging ?application_task)
      )
    :effect
      (and
        (task_staged ?application_task)
        (task_assigned_window ?application_task ?weather_window)
        (task_assigned_time_variant ?application_task ?time_slot_variant)
        (task_requires_compliance_document ?application_task)
        (not
          (task_available_for_staging ?application_task)
        )
      )
  )
  (:action assemble_application_task_with_secondary_eligible_window
    :parameters (?primary_field_unit - primary_field_unit ?secondary_field_unit - secondary_field_unit ?weather_window - weather_window ?time_slot_variant - time_slot_variant ?application_task - application_task)
    :precondition
      (and
        (primary_field_ready_for_task ?primary_field_unit)
        (secondary_field_ready_for_task ?secondary_field_unit)
        (candidate_window_for_primary_field ?primary_field_unit ?weather_window)
        (candidate_time_variant_for_secondary_field ?secondary_field_unit ?time_slot_variant)
        (weather_window_proposed ?weather_window)
        (time_slot_variant_eligible ?time_slot_variant)
        (primary_field_window_confirmed ?primary_field_unit)
        (not
          (secondary_field_time_variant_confirmed ?secondary_field_unit)
        )
        (task_available_for_staging ?application_task)
      )
    :effect
      (and
        (task_staged ?application_task)
        (task_assigned_window ?application_task ?weather_window)
        (task_assigned_time_variant ?application_task ?time_slot_variant)
        (task_requires_permit ?application_task)
        (not
          (task_available_for_staging ?application_task)
        )
      )
  )
  (:action assemble_application_task_with_both_eligible_windows
    :parameters (?primary_field_unit - primary_field_unit ?secondary_field_unit - secondary_field_unit ?weather_window - weather_window ?time_slot_variant - time_slot_variant ?application_task - application_task)
    :precondition
      (and
        (primary_field_ready_for_task ?primary_field_unit)
        (secondary_field_ready_for_task ?secondary_field_unit)
        (candidate_window_for_primary_field ?primary_field_unit ?weather_window)
        (candidate_time_variant_for_secondary_field ?secondary_field_unit ?time_slot_variant)
        (weather_window_eligible ?weather_window)
        (time_slot_variant_eligible ?time_slot_variant)
        (not
          (primary_field_window_confirmed ?primary_field_unit)
        )
        (not
          (secondary_field_time_variant_confirmed ?secondary_field_unit)
        )
        (task_available_for_staging ?application_task)
      )
    :effect
      (and
        (task_staged ?application_task)
        (task_assigned_window ?application_task ?weather_window)
        (task_assigned_time_variant ?application_task ?time_slot_variant)
        (task_requires_compliance_document ?application_task)
        (task_requires_permit ?application_task)
        (not
          (task_available_for_staging ?application_task)
        )
      )
  )
  (:action verify_task_materials_for_staging
    :parameters (?application_task - application_task ?primary_field_unit - primary_field_unit ?pesticide_product - pesticide_product)
    :precondition
      (and
        (task_staged ?application_task)
        (primary_field_ready_for_task ?primary_field_unit)
        (product_reserved_for_entity ?primary_field_unit ?pesticide_product)
        (not
          (task_materials_verified ?application_task)
        )
      )
    :effect (task_materials_verified ?application_task)
  )
  (:action stage_material_batch_to_task
    :parameters (?treatment_plan - treatment_plan ?material_batch - material_batch ?application_task - application_task)
    :precondition
      (and
        (eligible_for_assignment ?treatment_plan)
        (plan_associated_with_task ?treatment_plan ?application_task)
        (plan_has_material_batch ?treatment_plan ?material_batch)
        (material_batch_available ?material_batch)
        (task_staged ?application_task)
        (task_materials_verified ?application_task)
        (not
          (material_batch_staged ?material_batch)
        )
      )
    :effect
      (and
        (material_batch_staged ?material_batch)
        (material_batch_staged_to_task ?material_batch ?application_task)
        (not
          (material_batch_available ?material_batch)
        )
      )
  )
  (:action confirm_safety_equipment_attachment_to_plan
    :parameters (?treatment_plan - treatment_plan ?material_batch - material_batch ?application_task - application_task ?pesticide_product - pesticide_product)
    :precondition
      (and
        (eligible_for_assignment ?treatment_plan)
        (plan_has_material_batch ?treatment_plan ?material_batch)
        (material_batch_staged ?material_batch)
        (material_batch_staged_to_task ?material_batch ?application_task)
        (product_reserved_for_entity ?treatment_plan ?pesticide_product)
        (not
          (task_requires_compliance_document ?application_task)
        )
        (not
          (plan_safety_equipment_attached ?treatment_plan)
        )
      )
    :effect (plan_safety_equipment_attached ?treatment_plan)
  )
  (:action attach_compliance_document_to_plan
    :parameters (?treatment_plan - treatment_plan ?compliance_document - compliance_document)
    :precondition
      (and
        (eligible_for_assignment ?treatment_plan)
        (compliance_document_available ?compliance_document)
        (not
          (compliance_document_attached ?treatment_plan)
        )
      )
    :effect
      (and
        (compliance_document_attached ?treatment_plan)
        (plan_has_compliance_document ?treatment_plan ?compliance_document)
        (not
          (compliance_document_available ?compliance_document)
        )
      )
  )
  (:action process_compliance_document_for_plan
    :parameters (?treatment_plan - treatment_plan ?material_batch - material_batch ?application_task - application_task ?pesticide_product - pesticide_product ?compliance_document - compliance_document)
    :precondition
      (and
        (eligible_for_assignment ?treatment_plan)
        (plan_has_material_batch ?treatment_plan ?material_batch)
        (material_batch_staged ?material_batch)
        (material_batch_staged_to_task ?material_batch ?application_task)
        (product_reserved_for_entity ?treatment_plan ?pesticide_product)
        (task_requires_compliance_document ?application_task)
        (compliance_document_attached ?treatment_plan)
        (plan_has_compliance_document ?treatment_plan ?compliance_document)
        (not
          (plan_safety_equipment_attached ?treatment_plan)
        )
      )
    :effect
      (and
        (plan_safety_equipment_attached ?treatment_plan)
        (compliance_document_verified ?treatment_plan)
      )
  )
  (:action confirm_safety_and_materials_for_plan
    :parameters (?treatment_plan - treatment_plan ?safety_equipment - safety_equipment ?crew_or_operator - crew_or_operator ?material_batch - material_batch ?application_task - application_task)
    :precondition
      (and
        (plan_safety_equipment_attached ?treatment_plan)
        (plan_has_safety_equipment_reserved ?treatment_plan ?safety_equipment)
        (crew_assigned_to_entity ?treatment_plan ?crew_or_operator)
        (plan_has_material_batch ?treatment_plan ?material_batch)
        (material_batch_staged_to_task ?material_batch ?application_task)
        (not
          (task_requires_permit ?application_task)
        )
        (not
          (plan_materials_and_safety_ready ?treatment_plan)
        )
      )
    :effect (plan_materials_and_safety_ready ?treatment_plan)
  )
  (:action confirm_safety_and_materials_for_plan_alternate
    :parameters (?treatment_plan - treatment_plan ?safety_equipment - safety_equipment ?crew_or_operator - crew_or_operator ?material_batch - material_batch ?application_task - application_task)
    :precondition
      (and
        (plan_safety_equipment_attached ?treatment_plan)
        (plan_has_safety_equipment_reserved ?treatment_plan ?safety_equipment)
        (crew_assigned_to_entity ?treatment_plan ?crew_or_operator)
        (plan_has_material_batch ?treatment_plan ?material_batch)
        (material_batch_staged_to_task ?material_batch ?application_task)
        (task_requires_permit ?application_task)
        (not
          (plan_materials_and_safety_ready ?treatment_plan)
        )
      )
    :effect (plan_materials_and_safety_ready ?treatment_plan)
  )
  (:action mark_plan_eligible_for_finalization
    :parameters (?treatment_plan - treatment_plan ?permit - permit ?material_batch - material_batch ?application_task - application_task)
    :precondition
      (and
        (plan_materials_and_safety_ready ?treatment_plan)
        (plan_has_permit ?treatment_plan ?permit)
        (plan_has_material_batch ?treatment_plan ?material_batch)
        (material_batch_staged_to_task ?material_batch ?application_task)
        (not
          (task_requires_compliance_document ?application_task)
        )
        (not
          (task_requires_permit ?application_task)
        )
        (not
          (plan_finalization_eligible ?treatment_plan)
        )
      )
    :effect (plan_finalization_eligible ?treatment_plan)
  )
  (:action attach_regulatory_approval_and_mark_plan_variant_a
    :parameters (?treatment_plan - treatment_plan ?permit - permit ?material_batch - material_batch ?application_task - application_task)
    :precondition
      (and
        (plan_materials_and_safety_ready ?treatment_plan)
        (plan_has_permit ?treatment_plan ?permit)
        (plan_has_material_batch ?treatment_plan ?material_batch)
        (material_batch_staged_to_task ?material_batch ?application_task)
        (task_requires_compliance_document ?application_task)
        (not
          (task_requires_permit ?application_task)
        )
        (not
          (plan_finalization_eligible ?treatment_plan)
        )
      )
    :effect
      (and
        (plan_finalization_eligible ?treatment_plan)
        (regulatory_approval_attached ?treatment_plan)
      )
  )
  (:action attach_regulatory_approval_and_mark_plan_variant_b
    :parameters (?treatment_plan - treatment_plan ?permit - permit ?material_batch - material_batch ?application_task - application_task)
    :precondition
      (and
        (plan_materials_and_safety_ready ?treatment_plan)
        (plan_has_permit ?treatment_plan ?permit)
        (plan_has_material_batch ?treatment_plan ?material_batch)
        (material_batch_staged_to_task ?material_batch ?application_task)
        (not
          (task_requires_compliance_document ?application_task)
        )
        (task_requires_permit ?application_task)
        (not
          (plan_finalization_eligible ?treatment_plan)
        )
      )
    :effect
      (and
        (plan_finalization_eligible ?treatment_plan)
        (regulatory_approval_attached ?treatment_plan)
      )
  )
  (:action attach_regulatory_approval_and_mark_plan_both_flags
    :parameters (?treatment_plan - treatment_plan ?permit - permit ?material_batch - material_batch ?application_task - application_task)
    :precondition
      (and
        (plan_materials_and_safety_ready ?treatment_plan)
        (plan_has_permit ?treatment_plan ?permit)
        (plan_has_material_batch ?treatment_plan ?material_batch)
        (material_batch_staged_to_task ?material_batch ?application_task)
        (task_requires_compliance_document ?application_task)
        (task_requires_permit ?application_task)
        (not
          (plan_finalization_eligible ?treatment_plan)
        )
      )
    :effect
      (and
        (plan_finalization_eligible ?treatment_plan)
        (regulatory_approval_attached ?treatment_plan)
      )
  )
  (:action finalize_plan_and_mark_ready
    :parameters (?treatment_plan - treatment_plan)
    :precondition
      (and
        (plan_finalization_eligible ?treatment_plan)
        (not
          (regulatory_approval_attached ?treatment_plan)
        )
        (not
          (plan_finalized ?treatment_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?treatment_plan)
        (ready_for_execution ?treatment_plan)
      )
  )
  (:action attach_regulatory_approval_to_plan
    :parameters (?treatment_plan - treatment_plan ?regulatory_approval - regulatory_approval)
    :precondition
      (and
        (plan_finalization_eligible ?treatment_plan)
        (regulatory_approval_attached ?treatment_plan)
        (regulatory_approval_available ?regulatory_approval)
      )
    :effect
      (and
        (plan_has_regulatory_approval ?treatment_plan ?regulatory_approval)
        (not
          (regulatory_approval_available ?regulatory_approval)
        )
      )
  )
  (:action authorize_plan_for_execution
    :parameters (?treatment_plan - treatment_plan ?primary_field_unit - primary_field_unit ?secondary_field_unit - secondary_field_unit ?pesticide_product - pesticide_product ?regulatory_approval - regulatory_approval)
    :precondition
      (and
        (plan_finalization_eligible ?treatment_plan)
        (regulatory_approval_attached ?treatment_plan)
        (plan_has_regulatory_approval ?treatment_plan ?regulatory_approval)
        (plan_targets_primary_field ?treatment_plan ?primary_field_unit)
        (plan_targets_secondary_field ?treatment_plan ?secondary_field_unit)
        (primary_field_window_confirmed ?primary_field_unit)
        (secondary_field_time_variant_confirmed ?secondary_field_unit)
        (product_reserved_for_entity ?treatment_plan ?pesticide_product)
        (not
          (plan_authorized_by_operations ?treatment_plan)
        )
      )
    :effect (plan_authorized_by_operations ?treatment_plan)
  )
  (:action finalize_authorized_plan
    :parameters (?treatment_plan - treatment_plan)
    :precondition
      (and
        (plan_finalization_eligible ?treatment_plan)
        (plan_authorized_by_operations ?treatment_plan)
        (not
          (plan_finalized ?treatment_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?treatment_plan)
        (ready_for_execution ?treatment_plan)
      )
  )
  (:action attach_site_condition_marker_to_plan
    :parameters (?treatment_plan - treatment_plan ?site_condition_marker - site_condition_marker ?pesticide_product - pesticide_product)
    :precondition
      (and
        (eligible_for_assignment ?treatment_plan)
        (product_reserved_for_entity ?treatment_plan ?pesticide_product)
        (site_condition_marker_available ?site_condition_marker)
        (plan_has_site_condition_marker ?treatment_plan ?site_condition_marker)
        (not
          (plan_site_marker_attached ?treatment_plan)
        )
      )
    :effect
      (and
        (plan_site_marker_attached ?treatment_plan)
        (not
          (site_condition_marker_available ?site_condition_marker)
        )
      )
  )
  (:action prepare_plan_for_permit_validation
    :parameters (?treatment_plan - treatment_plan ?crew_or_operator - crew_or_operator)
    :precondition
      (and
        (plan_site_marker_attached ?treatment_plan)
        (crew_assigned_to_entity ?treatment_plan ?crew_or_operator)
        (not
          (plan_ready_for_permit_validation ?treatment_plan)
        )
      )
    :effect (plan_ready_for_permit_validation ?treatment_plan)
  )
  (:action verify_permit_for_plan
    :parameters (?treatment_plan - treatment_plan ?permit - permit)
    :precondition
      (and
        (plan_ready_for_permit_validation ?treatment_plan)
        (plan_has_permit ?treatment_plan ?permit)
        (not
          (plan_permit_verified ?treatment_plan)
        )
      )
    :effect (plan_permit_verified ?treatment_plan)
  )
  (:action finalize_plan_after_permit_verification
    :parameters (?treatment_plan - treatment_plan)
    :precondition
      (and
        (plan_permit_verified ?treatment_plan)
        (not
          (plan_finalized ?treatment_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?treatment_plan)
        (ready_for_execution ?treatment_plan)
      )
  )
  (:action mark_primary_field_ready_for_execution
    :parameters (?primary_field_unit - primary_field_unit ?application_task - application_task)
    :precondition
      (and
        (primary_field_ready_for_task ?primary_field_unit)
        (primary_field_window_confirmed ?primary_field_unit)
        (task_staged ?application_task)
        (task_materials_verified ?application_task)
        (not
          (ready_for_execution ?primary_field_unit)
        )
      )
    :effect (ready_for_execution ?primary_field_unit)
  )
  (:action mark_secondary_field_ready_for_execution
    :parameters (?secondary_field_unit - secondary_field_unit ?application_task - application_task)
    :precondition
      (and
        (secondary_field_ready_for_task ?secondary_field_unit)
        (secondary_field_time_variant_confirmed ?secondary_field_unit)
        (task_staged ?application_task)
        (task_materials_verified ?application_task)
        (not
          (ready_for_execution ?secondary_field_unit)
        )
      )
    :effect (ready_for_execution ?secondary_field_unit)
  )
  (:action authorize_entity_and_assign_schedule_slot
    :parameters (?planning_entity - planning_entity ?schedule_slot - schedule_slot ?pesticide_product - pesticide_product)
    :precondition
      (and
        (ready_for_execution ?planning_entity)
        (product_reserved_for_entity ?planning_entity ?pesticide_product)
        (schedule_slot_available ?schedule_slot)
        (not
          (final_approval_granted ?planning_entity)
        )
      )
    :effect
      (and
        (final_approval_granted ?planning_entity)
        (entity_assigned_schedule_slot ?planning_entity ?schedule_slot)
        (not
          (schedule_slot_available ?schedule_slot)
        )
      )
  )
  (:action commit_primary_field_assignment_and_release_resources
    :parameters (?primary_field_unit - primary_field_unit ?application_equipment - application_equipment ?schedule_slot - schedule_slot)
    :precondition
      (and
        (final_approval_granted ?primary_field_unit)
        (equipment_assigned_to_entity ?primary_field_unit ?application_equipment)
        (entity_assigned_schedule_slot ?primary_field_unit ?schedule_slot)
        (not
          (application_assigned ?primary_field_unit)
        )
      )
    :effect
      (and
        (application_assigned ?primary_field_unit)
        (equipment_available ?application_equipment)
        (schedule_slot_available ?schedule_slot)
      )
  )
  (:action commit_secondary_field_assignment_and_release_resources
    :parameters (?secondary_field_unit - secondary_field_unit ?application_equipment - application_equipment ?schedule_slot - schedule_slot)
    :precondition
      (and
        (final_approval_granted ?secondary_field_unit)
        (equipment_assigned_to_entity ?secondary_field_unit ?application_equipment)
        (entity_assigned_schedule_slot ?secondary_field_unit ?schedule_slot)
        (not
          (application_assigned ?secondary_field_unit)
        )
      )
    :effect
      (and
        (application_assigned ?secondary_field_unit)
        (equipment_available ?application_equipment)
        (schedule_slot_available ?schedule_slot)
      )
  )
  (:action commit_plan_assignment_and_release_resources
    :parameters (?treatment_plan - treatment_plan ?application_equipment - application_equipment ?schedule_slot - schedule_slot)
    :precondition
      (and
        (final_approval_granted ?treatment_plan)
        (equipment_assigned_to_entity ?treatment_plan ?application_equipment)
        (entity_assigned_schedule_slot ?treatment_plan ?schedule_slot)
        (not
          (application_assigned ?treatment_plan)
        )
      )
    :effect
      (and
        (application_assigned ?treatment_plan)
        (equipment_available ?application_equipment)
        (schedule_slot_available ?schedule_slot)
      )
  )
)

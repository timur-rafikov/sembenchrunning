(define (domain drought_response_operation_replanning)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_category - object resource_category - object logistics_category - object domain_unit - object affected_unit - domain_unit water_asset - operational_category assessment_resource - operational_category field_crew - operational_category permit_document - operational_category financial_aid_package - operational_category schedule_slot - operational_category technical_tool - operational_category regulatory_clearance - operational_category consumable_supply - resource_category salvage_plan - resource_category support_asset - resource_category contingency_irrigation_a - logistics_category contingency_irrigation_b - logistics_category mobilization_batch - logistics_category sector_group_a - affected_unit coordinator_group - affected_unit irrigation_sector_a - sector_group_a irrigation_sector_b - sector_group_a response_coordinator - coordinator_group)
  (:predicates
    (drought_incident_registered ?affected_unit - affected_unit)
    (assessment_cleared ?affected_unit - affected_unit)
    (triage_assigned ?affected_unit - affected_unit)
    (unit_replanned ?affected_unit - affected_unit)
    (unit_certified ?affected_unit - affected_unit)
    (unit_authorized ?affected_unit - affected_unit)
    (water_asset_available ?water_asset - water_asset)
    (unit_assigned_water_asset ?affected_unit - affected_unit ?water_asset - water_asset)
    (assessment_resource_available ?assessment_resource - assessment_resource)
    (assessment_assigned_to_unit ?affected_unit - affected_unit ?assessment_resource - assessment_resource)
    (field_crew_available ?field_crew - field_crew)
    (unit_assigned_field_crew ?affected_unit - affected_unit ?field_crew - field_crew)
    (consumable_supply_available ?consumable_supply - consumable_supply)
    (irrigation_sector_a_allocated_supply ?irrigation_sector_a - irrigation_sector_a ?consumable_supply - consumable_supply)
    (irrigation_sector_b_allocated_supply ?irrigation_sector_b - irrigation_sector_b ?consumable_supply - consumable_supply)
    (irrigation_sector_a_contingency_assigned ?irrigation_sector_a - irrigation_sector_a ?contingency_irrigation_a - contingency_irrigation_a)
    (contingency_irrigation_a_initiated ?contingency_irrigation_a - contingency_irrigation_a)
    (contingency_irrigation_a_confirmed ?contingency_irrigation_a - contingency_irrigation_a)
    (irrigation_sector_a_irrigation_commenced ?irrigation_sector_a - irrigation_sector_a)
    (irrigation_sector_b_contingency_assigned ?irrigation_sector_b - irrigation_sector_b ?contingency_irrigation_b - contingency_irrigation_b)
    (contingency_irrigation_b_initiated ?contingency_irrigation_b - contingency_irrigation_b)
    (contingency_irrigation_b_confirmed ?contingency_irrigation_b - contingency_irrigation_b)
    (irrigation_sector_b_irrigation_commenced ?irrigation_sector_b - irrigation_sector_b)
    (mobilization_batch_available ?mobilization_batch - mobilization_batch)
    (mobilization_batch_staged ?mobilization_batch - mobilization_batch)
    (batch_assigned_to_contingency_a ?mobilization_batch - mobilization_batch ?contingency_irrigation_a - contingency_irrigation_a)
    (batch_assigned_to_contingency_b ?mobilization_batch - mobilization_batch ?contingency_irrigation_b - contingency_irrigation_b)
    (mobilization_batch_flag_sector_a ?mobilization_batch - mobilization_batch)
    (mobilization_batch_flag_sector_b ?mobilization_batch - mobilization_batch)
    (mobilization_batch_verified ?mobilization_batch - mobilization_batch)
    (coordinator_assigned_to_sector_a ?response_coordinator - response_coordinator ?irrigation_sector_a - irrigation_sector_a)
    (coordinator_assigned_to_sector_b ?response_coordinator - response_coordinator ?irrigation_sector_b - irrigation_sector_b)
    (coordinator_assigned_mobilization_batch ?response_coordinator - response_coordinator ?mobilization_batch - mobilization_batch)
    (salvage_plan_available ?salvage_plan - salvage_plan)
    (coordinator_has_salvage_plan ?response_coordinator - response_coordinator ?salvage_plan - salvage_plan)
    (salvage_plan_committed ?salvage_plan - salvage_plan)
    (salvage_plan_associated_with_batch ?salvage_plan - salvage_plan ?mobilization_batch - mobilization_batch)
    (coordinator_technical_ready ?response_coordinator - response_coordinator)
    (coordinator_technical_assembled ?response_coordinator - response_coordinator)
    (coordinator_execution_ready ?response_coordinator - response_coordinator)
    (coordinator_permit_attached ?response_coordinator - response_coordinator)
    (coordinator_permit_validated ?response_coordinator - response_coordinator)
    (coordinator_funding_attached ?response_coordinator - response_coordinator)
    (coordinator_execution_completed ?response_coordinator - response_coordinator)
    (support_asset_available ?support_asset - support_asset)
    (coordinator_assigned_support_asset ?response_coordinator - response_coordinator ?support_asset - support_asset)
    (coordinator_has_support_asset ?response_coordinator - response_coordinator)
    (permit_application_submitted ?response_coordinator - response_coordinator)
    (permit_approved ?response_coordinator - response_coordinator)
    (permit_document_available ?permit_document - permit_document)
    (coordinator_linked_permit_document ?response_coordinator - response_coordinator ?permit_document - permit_document)
    (financial_aid_available ?financial_aid_package - financial_aid_package)
    (coordinator_attached_financial_aid ?response_coordinator - response_coordinator ?financial_aid_package - financial_aid_package)
    (technical_tool_available ?technical_tool - technical_tool)
    (coordinator_assigned_technical_tool ?response_coordinator - response_coordinator ?technical_tool - technical_tool)
    (regulatory_clearance_available ?regulatory_clearance - regulatory_clearance)
    (coordinator_assigned_clearance ?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance)
    (schedule_slot_available ?schedule_slot - schedule_slot)
    (unit_assigned_schedule_slot ?affected_unit - affected_unit ?schedule_slot - schedule_slot)
    (irrigation_sector_a_ready ?irrigation_sector_a - irrigation_sector_a)
    (irrigation_sector_b_ready ?irrigation_sector_b - irrigation_sector_b)
    (coordinator_completion_marked ?response_coordinator - response_coordinator)
  )
  (:action register_drought_incident
    :parameters (?affected_unit - affected_unit)
    :precondition
      (and
        (not
          (drought_incident_registered ?affected_unit)
        )
        (not
          (unit_replanned ?affected_unit)
        )
      )
    :effect (drought_incident_registered ?affected_unit)
  )
  (:action assign_water_asset_to_unit
    :parameters (?affected_unit - affected_unit ?water_asset - water_asset)
    :precondition
      (and
        (drought_incident_registered ?affected_unit)
        (not
          (triage_assigned ?affected_unit)
        )
        (water_asset_available ?water_asset)
      )
    :effect
      (and
        (triage_assigned ?affected_unit)
        (unit_assigned_water_asset ?affected_unit ?water_asset)
        (not
          (water_asset_available ?water_asset)
        )
      )
  )
  (:action deploy_assessment_resource
    :parameters (?affected_unit - affected_unit ?assessment_resource - assessment_resource)
    :precondition
      (and
        (drought_incident_registered ?affected_unit)
        (triage_assigned ?affected_unit)
        (assessment_resource_available ?assessment_resource)
      )
    :effect
      (and
        (assessment_assigned_to_unit ?affected_unit ?assessment_resource)
        (not
          (assessment_resource_available ?assessment_resource)
        )
      )
  )
  (:action complete_assessment
    :parameters (?affected_unit - affected_unit ?assessment_resource - assessment_resource)
    :precondition
      (and
        (drought_incident_registered ?affected_unit)
        (triage_assigned ?affected_unit)
        (assessment_assigned_to_unit ?affected_unit ?assessment_resource)
        (not
          (assessment_cleared ?affected_unit)
        )
      )
    :effect (assessment_cleared ?affected_unit)
  )
  (:action release_assessment_resource
    :parameters (?affected_unit - affected_unit ?assessment_resource - assessment_resource)
    :precondition
      (and
        (assessment_assigned_to_unit ?affected_unit ?assessment_resource)
      )
    :effect
      (and
        (assessment_resource_available ?assessment_resource)
        (not
          (assessment_assigned_to_unit ?affected_unit ?assessment_resource)
        )
      )
  )
  (:action assign_field_crew
    :parameters (?affected_unit - affected_unit ?field_crew - field_crew)
    :precondition
      (and
        (assessment_cleared ?affected_unit)
        (field_crew_available ?field_crew)
      )
    :effect
      (and
        (unit_assigned_field_crew ?affected_unit ?field_crew)
        (not
          (field_crew_available ?field_crew)
        )
      )
  )
  (:action release_field_crew
    :parameters (?affected_unit - affected_unit ?field_crew - field_crew)
    :precondition
      (and
        (unit_assigned_field_crew ?affected_unit ?field_crew)
      )
    :effect
      (and
        (field_crew_available ?field_crew)
        (not
          (unit_assigned_field_crew ?affected_unit ?field_crew)
        )
      )
  )
  (:action assign_technical_tool_to_coordinator
    :parameters (?response_coordinator - response_coordinator ?technical_tool - technical_tool)
    :precondition
      (and
        (assessment_cleared ?response_coordinator)
        (technical_tool_available ?technical_tool)
      )
    :effect
      (and
        (coordinator_assigned_technical_tool ?response_coordinator ?technical_tool)
        (not
          (technical_tool_available ?technical_tool)
        )
      )
  )
  (:action release_technical_tool_from_coordinator
    :parameters (?response_coordinator - response_coordinator ?technical_tool - technical_tool)
    :precondition
      (and
        (coordinator_assigned_technical_tool ?response_coordinator ?technical_tool)
      )
    :effect
      (and
        (technical_tool_available ?technical_tool)
        (not
          (coordinator_assigned_technical_tool ?response_coordinator ?technical_tool)
        )
      )
  )
  (:action assign_regulatory_clearance_to_coordinator
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (assessment_cleared ?response_coordinator)
        (regulatory_clearance_available ?regulatory_clearance)
      )
    :effect
      (and
        (coordinator_assigned_clearance ?response_coordinator ?regulatory_clearance)
        (not
          (regulatory_clearance_available ?regulatory_clearance)
        )
      )
  )
  (:action release_regulatory_clearance_from_coordinator
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (coordinator_assigned_clearance ?response_coordinator ?regulatory_clearance)
      )
    :effect
      (and
        (regulatory_clearance_available ?regulatory_clearance)
        (not
          (coordinator_assigned_clearance ?response_coordinator ?regulatory_clearance)
        )
      )
  )
  (:action initiate_contingency_irrigation_a
    :parameters (?irrigation_sector_a - irrigation_sector_a ?contingency_irrigation_a - contingency_irrigation_a ?assessment_resource - assessment_resource)
    :precondition
      (and
        (assessment_cleared ?irrigation_sector_a)
        (assessment_assigned_to_unit ?irrigation_sector_a ?assessment_resource)
        (irrigation_sector_a_contingency_assigned ?irrigation_sector_a ?contingency_irrigation_a)
        (not
          (contingency_irrigation_a_initiated ?contingency_irrigation_a)
        )
        (not
          (contingency_irrigation_a_confirmed ?contingency_irrigation_a)
        )
      )
    :effect (contingency_irrigation_a_initiated ?contingency_irrigation_a)
  )
  (:action activate_contingency_irrigation_a_with_crew
    :parameters (?irrigation_sector_a - irrigation_sector_a ?contingency_irrigation_a - contingency_irrigation_a ?field_crew - field_crew)
    :precondition
      (and
        (assessment_cleared ?irrigation_sector_a)
        (unit_assigned_field_crew ?irrigation_sector_a ?field_crew)
        (irrigation_sector_a_contingency_assigned ?irrigation_sector_a ?contingency_irrigation_a)
        (contingency_irrigation_a_initiated ?contingency_irrigation_a)
        (not
          (irrigation_sector_a_ready ?irrigation_sector_a)
        )
      )
    :effect
      (and
        (irrigation_sector_a_ready ?irrigation_sector_a)
        (irrigation_sector_a_irrigation_commenced ?irrigation_sector_a)
      )
  )
  (:action allocate_consumable_to_contingency_a
    :parameters (?irrigation_sector_a - irrigation_sector_a ?contingency_irrigation_a - contingency_irrigation_a ?consumable_supply - consumable_supply)
    :precondition
      (and
        (assessment_cleared ?irrigation_sector_a)
        (irrigation_sector_a_contingency_assigned ?irrigation_sector_a ?contingency_irrigation_a)
        (consumable_supply_available ?consumable_supply)
        (not
          (irrigation_sector_a_ready ?irrigation_sector_a)
        )
      )
    :effect
      (and
        (contingency_irrigation_a_confirmed ?contingency_irrigation_a)
        (irrigation_sector_a_ready ?irrigation_sector_a)
        (irrigation_sector_a_allocated_supply ?irrigation_sector_a ?consumable_supply)
        (not
          (consumable_supply_available ?consumable_supply)
        )
      )
  )
  (:action execute_contingency_irrigation_a
    :parameters (?irrigation_sector_a - irrigation_sector_a ?contingency_irrigation_a - contingency_irrigation_a ?assessment_resource - assessment_resource ?consumable_supply - consumable_supply)
    :precondition
      (and
        (assessment_cleared ?irrigation_sector_a)
        (assessment_assigned_to_unit ?irrigation_sector_a ?assessment_resource)
        (irrigation_sector_a_contingency_assigned ?irrigation_sector_a ?contingency_irrigation_a)
        (contingency_irrigation_a_confirmed ?contingency_irrigation_a)
        (irrigation_sector_a_allocated_supply ?irrigation_sector_a ?consumable_supply)
        (not
          (irrigation_sector_a_irrigation_commenced ?irrigation_sector_a)
        )
      )
    :effect
      (and
        (contingency_irrigation_a_initiated ?contingency_irrigation_a)
        (irrigation_sector_a_irrigation_commenced ?irrigation_sector_a)
        (consumable_supply_available ?consumable_supply)
        (not
          (irrigation_sector_a_allocated_supply ?irrigation_sector_a ?consumable_supply)
        )
      )
  )
  (:action initiate_contingency_irrigation_b
    :parameters (?irrigation_sector_b - irrigation_sector_b ?contingency_irrigation_b - contingency_irrigation_b ?assessment_resource - assessment_resource)
    :precondition
      (and
        (assessment_cleared ?irrigation_sector_b)
        (assessment_assigned_to_unit ?irrigation_sector_b ?assessment_resource)
        (irrigation_sector_b_contingency_assigned ?irrigation_sector_b ?contingency_irrigation_b)
        (not
          (contingency_irrigation_b_initiated ?contingency_irrigation_b)
        )
        (not
          (contingency_irrigation_b_confirmed ?contingency_irrigation_b)
        )
      )
    :effect (contingency_irrigation_b_initiated ?contingency_irrigation_b)
  )
  (:action activate_contingency_irrigation_b_with_crew
    :parameters (?irrigation_sector_b - irrigation_sector_b ?contingency_irrigation_b - contingency_irrigation_b ?field_crew - field_crew)
    :precondition
      (and
        (assessment_cleared ?irrigation_sector_b)
        (unit_assigned_field_crew ?irrigation_sector_b ?field_crew)
        (irrigation_sector_b_contingency_assigned ?irrigation_sector_b ?contingency_irrigation_b)
        (contingency_irrigation_b_initiated ?contingency_irrigation_b)
        (not
          (irrigation_sector_b_ready ?irrigation_sector_b)
        )
      )
    :effect
      (and
        (irrigation_sector_b_ready ?irrigation_sector_b)
        (irrigation_sector_b_irrigation_commenced ?irrigation_sector_b)
      )
  )
  (:action allocate_consumable_to_contingency_b
    :parameters (?irrigation_sector_b - irrigation_sector_b ?contingency_irrigation_b - contingency_irrigation_b ?consumable_supply - consumable_supply)
    :precondition
      (and
        (assessment_cleared ?irrigation_sector_b)
        (irrigation_sector_b_contingency_assigned ?irrigation_sector_b ?contingency_irrigation_b)
        (consumable_supply_available ?consumable_supply)
        (not
          (irrigation_sector_b_ready ?irrigation_sector_b)
        )
      )
    :effect
      (and
        (contingency_irrigation_b_confirmed ?contingency_irrigation_b)
        (irrigation_sector_b_ready ?irrigation_sector_b)
        (irrigation_sector_b_allocated_supply ?irrigation_sector_b ?consumable_supply)
        (not
          (consumable_supply_available ?consumable_supply)
        )
      )
  )
  (:action execute_contingency_irrigation_b
    :parameters (?irrigation_sector_b - irrigation_sector_b ?contingency_irrigation_b - contingency_irrigation_b ?assessment_resource - assessment_resource ?consumable_supply - consumable_supply)
    :precondition
      (and
        (assessment_cleared ?irrigation_sector_b)
        (assessment_assigned_to_unit ?irrigation_sector_b ?assessment_resource)
        (irrigation_sector_b_contingency_assigned ?irrigation_sector_b ?contingency_irrigation_b)
        (contingency_irrigation_b_confirmed ?contingency_irrigation_b)
        (irrigation_sector_b_allocated_supply ?irrigation_sector_b ?consumable_supply)
        (not
          (irrigation_sector_b_irrigation_commenced ?irrigation_sector_b)
        )
      )
    :effect
      (and
        (contingency_irrigation_b_initiated ?contingency_irrigation_b)
        (irrigation_sector_b_irrigation_commenced ?irrigation_sector_b)
        (consumable_supply_available ?consumable_supply)
        (not
          (irrigation_sector_b_allocated_supply ?irrigation_sector_b ?consumable_supply)
        )
      )
  )
  (:action stage_mobilization_batch
    :parameters (?irrigation_sector_a - irrigation_sector_a ?irrigation_sector_b - irrigation_sector_b ?contingency_irrigation_a - contingency_irrigation_a ?contingency_irrigation_b - contingency_irrigation_b ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (irrigation_sector_a_ready ?irrigation_sector_a)
        (irrigation_sector_b_ready ?irrigation_sector_b)
        (irrigation_sector_a_contingency_assigned ?irrigation_sector_a ?contingency_irrigation_a)
        (irrigation_sector_b_contingency_assigned ?irrigation_sector_b ?contingency_irrigation_b)
        (contingency_irrigation_a_initiated ?contingency_irrigation_a)
        (contingency_irrigation_b_initiated ?contingency_irrigation_b)
        (irrigation_sector_a_irrigation_commenced ?irrigation_sector_a)
        (irrigation_sector_b_irrigation_commenced ?irrigation_sector_b)
        (mobilization_batch_available ?mobilization_batch)
      )
    :effect
      (and
        (mobilization_batch_staged ?mobilization_batch)
        (batch_assigned_to_contingency_a ?mobilization_batch ?contingency_irrigation_a)
        (batch_assigned_to_contingency_b ?mobilization_batch ?contingency_irrigation_b)
        (not
          (mobilization_batch_available ?mobilization_batch)
        )
      )
  )
  (:action stage_mobilization_batch_for_sector_a
    :parameters (?irrigation_sector_a - irrigation_sector_a ?irrigation_sector_b - irrigation_sector_b ?contingency_irrigation_a - contingency_irrigation_a ?contingency_irrigation_b - contingency_irrigation_b ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (irrigation_sector_a_ready ?irrigation_sector_a)
        (irrigation_sector_b_ready ?irrigation_sector_b)
        (irrigation_sector_a_contingency_assigned ?irrigation_sector_a ?contingency_irrigation_a)
        (irrigation_sector_b_contingency_assigned ?irrigation_sector_b ?contingency_irrigation_b)
        (contingency_irrigation_a_confirmed ?contingency_irrigation_a)
        (contingency_irrigation_b_initiated ?contingency_irrigation_b)
        (not
          (irrigation_sector_a_irrigation_commenced ?irrigation_sector_a)
        )
        (irrigation_sector_b_irrigation_commenced ?irrigation_sector_b)
        (mobilization_batch_available ?mobilization_batch)
      )
    :effect
      (and
        (mobilization_batch_staged ?mobilization_batch)
        (batch_assigned_to_contingency_a ?mobilization_batch ?contingency_irrigation_a)
        (batch_assigned_to_contingency_b ?mobilization_batch ?contingency_irrigation_b)
        (mobilization_batch_flag_sector_a ?mobilization_batch)
        (not
          (mobilization_batch_available ?mobilization_batch)
        )
      )
  )
  (:action stage_mobilization_batch_for_sector_b
    :parameters (?irrigation_sector_a - irrigation_sector_a ?irrigation_sector_b - irrigation_sector_b ?contingency_irrigation_a - contingency_irrigation_a ?contingency_irrigation_b - contingency_irrigation_b ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (irrigation_sector_a_ready ?irrigation_sector_a)
        (irrigation_sector_b_ready ?irrigation_sector_b)
        (irrigation_sector_a_contingency_assigned ?irrigation_sector_a ?contingency_irrigation_a)
        (irrigation_sector_b_contingency_assigned ?irrigation_sector_b ?contingency_irrigation_b)
        (contingency_irrigation_a_initiated ?contingency_irrigation_a)
        (contingency_irrigation_b_confirmed ?contingency_irrigation_b)
        (irrigation_sector_a_irrigation_commenced ?irrigation_sector_a)
        (not
          (irrigation_sector_b_irrigation_commenced ?irrigation_sector_b)
        )
        (mobilization_batch_available ?mobilization_batch)
      )
    :effect
      (and
        (mobilization_batch_staged ?mobilization_batch)
        (batch_assigned_to_contingency_a ?mobilization_batch ?contingency_irrigation_a)
        (batch_assigned_to_contingency_b ?mobilization_batch ?contingency_irrigation_b)
        (mobilization_batch_flag_sector_b ?mobilization_batch)
        (not
          (mobilization_batch_available ?mobilization_batch)
        )
      )
  )
  (:action stage_mobilization_batch_for_both_sectors
    :parameters (?irrigation_sector_a - irrigation_sector_a ?irrigation_sector_b - irrigation_sector_b ?contingency_irrigation_a - contingency_irrigation_a ?contingency_irrigation_b - contingency_irrigation_b ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (irrigation_sector_a_ready ?irrigation_sector_a)
        (irrigation_sector_b_ready ?irrigation_sector_b)
        (irrigation_sector_a_contingency_assigned ?irrigation_sector_a ?contingency_irrigation_a)
        (irrigation_sector_b_contingency_assigned ?irrigation_sector_b ?contingency_irrigation_b)
        (contingency_irrigation_a_confirmed ?contingency_irrigation_a)
        (contingency_irrigation_b_confirmed ?contingency_irrigation_b)
        (not
          (irrigation_sector_a_irrigation_commenced ?irrigation_sector_a)
        )
        (not
          (irrigation_sector_b_irrigation_commenced ?irrigation_sector_b)
        )
        (mobilization_batch_available ?mobilization_batch)
      )
    :effect
      (and
        (mobilization_batch_staged ?mobilization_batch)
        (batch_assigned_to_contingency_a ?mobilization_batch ?contingency_irrigation_a)
        (batch_assigned_to_contingency_b ?mobilization_batch ?contingency_irrigation_b)
        (mobilization_batch_flag_sector_a ?mobilization_batch)
        (mobilization_batch_flag_sector_b ?mobilization_batch)
        (not
          (mobilization_batch_available ?mobilization_batch)
        )
      )
  )
  (:action verify_mobilization_batch
    :parameters (?mobilization_batch - mobilization_batch ?irrigation_sector_a - irrigation_sector_a ?assessment_resource - assessment_resource)
    :precondition
      (and
        (mobilization_batch_staged ?mobilization_batch)
        (irrigation_sector_a_ready ?irrigation_sector_a)
        (assessment_assigned_to_unit ?irrigation_sector_a ?assessment_resource)
        (not
          (mobilization_batch_verified ?mobilization_batch)
        )
      )
    :effect (mobilization_batch_verified ?mobilization_batch)
  )
  (:action commit_salvage_plan_to_batch
    :parameters (?response_coordinator - response_coordinator ?salvage_plan - salvage_plan ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (assessment_cleared ?response_coordinator)
        (coordinator_assigned_mobilization_batch ?response_coordinator ?mobilization_batch)
        (coordinator_has_salvage_plan ?response_coordinator ?salvage_plan)
        (salvage_plan_available ?salvage_plan)
        (mobilization_batch_staged ?mobilization_batch)
        (mobilization_batch_verified ?mobilization_batch)
        (not
          (salvage_plan_committed ?salvage_plan)
        )
      )
    :effect
      (and
        (salvage_plan_committed ?salvage_plan)
        (salvage_plan_associated_with_batch ?salvage_plan ?mobilization_batch)
        (not
          (salvage_plan_available ?salvage_plan)
        )
      )
  )
  (:action assemble_technical_resources
    :parameters (?response_coordinator - response_coordinator ?salvage_plan - salvage_plan ?mobilization_batch - mobilization_batch ?assessment_resource - assessment_resource)
    :precondition
      (and
        (assessment_cleared ?response_coordinator)
        (coordinator_has_salvage_plan ?response_coordinator ?salvage_plan)
        (salvage_plan_committed ?salvage_plan)
        (salvage_plan_associated_with_batch ?salvage_plan ?mobilization_batch)
        (assessment_assigned_to_unit ?response_coordinator ?assessment_resource)
        (not
          (mobilization_batch_flag_sector_a ?mobilization_batch)
        )
        (not
          (coordinator_technical_ready ?response_coordinator)
        )
      )
    :effect (coordinator_technical_ready ?response_coordinator)
  )
  (:action attach_permit_document_to_coordinator
    :parameters (?response_coordinator - response_coordinator ?permit_document - permit_document)
    :precondition
      (and
        (assessment_cleared ?response_coordinator)
        (permit_document_available ?permit_document)
        (not
          (coordinator_permit_attached ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_permit_attached ?response_coordinator)
        (coordinator_linked_permit_document ?response_coordinator ?permit_document)
        (not
          (permit_document_available ?permit_document)
        )
      )
  )
  (:action authorize_salvage_plan_with_permit
    :parameters (?response_coordinator - response_coordinator ?salvage_plan - salvage_plan ?mobilization_batch - mobilization_batch ?assessment_resource - assessment_resource ?permit_document - permit_document)
    :precondition
      (and
        (assessment_cleared ?response_coordinator)
        (coordinator_has_salvage_plan ?response_coordinator ?salvage_plan)
        (salvage_plan_committed ?salvage_plan)
        (salvage_plan_associated_with_batch ?salvage_plan ?mobilization_batch)
        (assessment_assigned_to_unit ?response_coordinator ?assessment_resource)
        (mobilization_batch_flag_sector_a ?mobilization_batch)
        (coordinator_permit_attached ?response_coordinator)
        (coordinator_linked_permit_document ?response_coordinator ?permit_document)
        (not
          (coordinator_technical_ready ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_technical_ready ?response_coordinator)
        (coordinator_permit_validated ?response_coordinator)
      )
  )
  (:action deploy_technical_team_for_execution
    :parameters (?response_coordinator - response_coordinator ?technical_tool - technical_tool ?field_crew - field_crew ?salvage_plan - salvage_plan ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (coordinator_technical_ready ?response_coordinator)
        (coordinator_assigned_technical_tool ?response_coordinator ?technical_tool)
        (unit_assigned_field_crew ?response_coordinator ?field_crew)
        (coordinator_has_salvage_plan ?response_coordinator ?salvage_plan)
        (salvage_plan_associated_with_batch ?salvage_plan ?mobilization_batch)
        (not
          (mobilization_batch_flag_sector_b ?mobilization_batch)
        )
        (not
          (coordinator_technical_assembled ?response_coordinator)
        )
      )
    :effect (coordinator_technical_assembled ?response_coordinator)
  )
  (:action deploy_secondary_technical_team
    :parameters (?response_coordinator - response_coordinator ?technical_tool - technical_tool ?field_crew - field_crew ?salvage_plan - salvage_plan ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (coordinator_technical_ready ?response_coordinator)
        (coordinator_assigned_technical_tool ?response_coordinator ?technical_tool)
        (unit_assigned_field_crew ?response_coordinator ?field_crew)
        (coordinator_has_salvage_plan ?response_coordinator ?salvage_plan)
        (salvage_plan_associated_with_batch ?salvage_plan ?mobilization_batch)
        (mobilization_batch_flag_sector_b ?mobilization_batch)
        (not
          (coordinator_technical_assembled ?response_coordinator)
        )
      )
    :effect (coordinator_technical_assembled ?response_coordinator)
  )
  (:action confirm_technical_assembly_and_clearance
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance ?salvage_plan - salvage_plan ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (coordinator_technical_assembled ?response_coordinator)
        (coordinator_assigned_clearance ?response_coordinator ?regulatory_clearance)
        (coordinator_has_salvage_plan ?response_coordinator ?salvage_plan)
        (salvage_plan_associated_with_batch ?salvage_plan ?mobilization_batch)
        (not
          (mobilization_batch_flag_sector_a ?mobilization_batch)
        )
        (not
          (mobilization_batch_flag_sector_b ?mobilization_batch)
        )
        (not
          (coordinator_execution_ready ?response_coordinator)
        )
      )
    :effect (coordinator_execution_ready ?response_coordinator)
  )
  (:action confirm_execution_and_attach_funding
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance ?salvage_plan - salvage_plan ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (coordinator_technical_assembled ?response_coordinator)
        (coordinator_assigned_clearance ?response_coordinator ?regulatory_clearance)
        (coordinator_has_salvage_plan ?response_coordinator ?salvage_plan)
        (salvage_plan_associated_with_batch ?salvage_plan ?mobilization_batch)
        (mobilization_batch_flag_sector_a ?mobilization_batch)
        (not
          (mobilization_batch_flag_sector_b ?mobilization_batch)
        )
        (not
          (coordinator_execution_ready ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_execution_ready ?response_coordinator)
        (coordinator_funding_attached ?response_coordinator)
      )
  )
  (:action confirm_execution_and_attach_funding_variant
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance ?salvage_plan - salvage_plan ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (coordinator_technical_assembled ?response_coordinator)
        (coordinator_assigned_clearance ?response_coordinator ?regulatory_clearance)
        (coordinator_has_salvage_plan ?response_coordinator ?salvage_plan)
        (salvage_plan_associated_with_batch ?salvage_plan ?mobilization_batch)
        (not
          (mobilization_batch_flag_sector_a ?mobilization_batch)
        )
        (mobilization_batch_flag_sector_b ?mobilization_batch)
        (not
          (coordinator_execution_ready ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_execution_ready ?response_coordinator)
        (coordinator_funding_attached ?response_coordinator)
      )
  )
  (:action confirm_execution_and_attach_funding_complete
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance ?salvage_plan - salvage_plan ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (coordinator_technical_assembled ?response_coordinator)
        (coordinator_assigned_clearance ?response_coordinator ?regulatory_clearance)
        (coordinator_has_salvage_plan ?response_coordinator ?salvage_plan)
        (salvage_plan_associated_with_batch ?salvage_plan ?mobilization_batch)
        (mobilization_batch_flag_sector_a ?mobilization_batch)
        (mobilization_batch_flag_sector_b ?mobilization_batch)
        (not
          (coordinator_execution_ready ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_execution_ready ?response_coordinator)
        (coordinator_funding_attached ?response_coordinator)
      )
  )
  (:action certify_coordinator_task
    :parameters (?response_coordinator - response_coordinator)
    :precondition
      (and
        (coordinator_execution_ready ?response_coordinator)
        (not
          (coordinator_funding_attached ?response_coordinator)
        )
        (not
          (coordinator_completion_marked ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_completion_marked ?response_coordinator)
        (unit_certified ?response_coordinator)
      )
  )
  (:action attach_financial_aid
    :parameters (?response_coordinator - response_coordinator ?financial_aid_package - financial_aid_package)
    :precondition
      (and
        (coordinator_execution_ready ?response_coordinator)
        (coordinator_funding_attached ?response_coordinator)
        (financial_aid_available ?financial_aid_package)
      )
    :effect
      (and
        (coordinator_attached_financial_aid ?response_coordinator ?financial_aid_package)
        (not
          (financial_aid_available ?financial_aid_package)
        )
      )
  )
  (:action execute_recovery_operations
    :parameters (?response_coordinator - response_coordinator ?irrigation_sector_a - irrigation_sector_a ?irrigation_sector_b - irrigation_sector_b ?assessment_resource - assessment_resource ?financial_aid_package - financial_aid_package)
    :precondition
      (and
        (coordinator_execution_ready ?response_coordinator)
        (coordinator_funding_attached ?response_coordinator)
        (coordinator_attached_financial_aid ?response_coordinator ?financial_aid_package)
        (coordinator_assigned_to_sector_a ?response_coordinator ?irrigation_sector_a)
        (coordinator_assigned_to_sector_b ?response_coordinator ?irrigation_sector_b)
        (irrigation_sector_a_irrigation_commenced ?irrigation_sector_a)
        (irrigation_sector_b_irrigation_commenced ?irrigation_sector_b)
        (assessment_assigned_to_unit ?response_coordinator ?assessment_resource)
        (not
          (coordinator_execution_completed ?response_coordinator)
        )
      )
    :effect (coordinator_execution_completed ?response_coordinator)
  )
  (:action finalize_coordinator_completion
    :parameters (?response_coordinator - response_coordinator)
    :precondition
      (and
        (coordinator_execution_ready ?response_coordinator)
        (coordinator_execution_completed ?response_coordinator)
        (not
          (coordinator_completion_marked ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_completion_marked ?response_coordinator)
        (unit_certified ?response_coordinator)
      )
  )
  (:action assign_support_asset_to_coordinator
    :parameters (?response_coordinator - response_coordinator ?support_asset - support_asset ?assessment_resource - assessment_resource)
    :precondition
      (and
        (assessment_cleared ?response_coordinator)
        (assessment_assigned_to_unit ?response_coordinator ?assessment_resource)
        (support_asset_available ?support_asset)
        (coordinator_assigned_support_asset ?response_coordinator ?support_asset)
        (not
          (coordinator_has_support_asset ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_has_support_asset ?response_coordinator)
        (not
          (support_asset_available ?support_asset)
        )
      )
  )
  (:action submit_permit_application
    :parameters (?response_coordinator - response_coordinator ?field_crew - field_crew)
    :precondition
      (and
        (coordinator_has_support_asset ?response_coordinator)
        (unit_assigned_field_crew ?response_coordinator ?field_crew)
        (not
          (permit_application_submitted ?response_coordinator)
        )
      )
    :effect (permit_application_submitted ?response_coordinator)
  )
  (:action apply_regulatory_clearance_to_coordinator
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (permit_application_submitted ?response_coordinator)
        (coordinator_assigned_clearance ?response_coordinator ?regulatory_clearance)
        (not
          (permit_approved ?response_coordinator)
        )
      )
    :effect (permit_approved ?response_coordinator)
  )
  (:action certify_permit_and_complete
    :parameters (?response_coordinator - response_coordinator)
    :precondition
      (and
        (permit_approved ?response_coordinator)
        (not
          (coordinator_completion_marked ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_completion_marked ?response_coordinator)
        (unit_certified ?response_coordinator)
      )
  )
  (:action redeploy_resources_to_sector_a
    :parameters (?irrigation_sector_a - irrigation_sector_a ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (irrigation_sector_a_ready ?irrigation_sector_a)
        (irrigation_sector_a_irrigation_commenced ?irrigation_sector_a)
        (mobilization_batch_staged ?mobilization_batch)
        (mobilization_batch_verified ?mobilization_batch)
        (not
          (unit_certified ?irrigation_sector_a)
        )
      )
    :effect (unit_certified ?irrigation_sector_a)
  )
  (:action redeploy_resources_to_sector_b
    :parameters (?irrigation_sector_b - irrigation_sector_b ?mobilization_batch - mobilization_batch)
    :precondition
      (and
        (irrigation_sector_b_ready ?irrigation_sector_b)
        (irrigation_sector_b_irrigation_commenced ?irrigation_sector_b)
        (mobilization_batch_staged ?mobilization_batch)
        (mobilization_batch_verified ?mobilization_batch)
        (not
          (unit_certified ?irrigation_sector_b)
        )
      )
    :effect (unit_certified ?irrigation_sector_b)
  )
  (:action authorize_unit_recovery
    :parameters (?affected_unit - affected_unit ?schedule_slot - schedule_slot ?assessment_resource - assessment_resource)
    :precondition
      (and
        (unit_certified ?affected_unit)
        (assessment_assigned_to_unit ?affected_unit ?assessment_resource)
        (schedule_slot_available ?schedule_slot)
        (not
          (unit_authorized ?affected_unit)
        )
      )
    :effect
      (and
        (unit_authorized ?affected_unit)
        (unit_assigned_schedule_slot ?affected_unit ?schedule_slot)
        (not
          (schedule_slot_available ?schedule_slot)
        )
      )
  )
  (:action finalize_unit_replanning_assign_water_asset_sector_a
    :parameters (?irrigation_sector_a - irrigation_sector_a ?water_asset - water_asset ?schedule_slot - schedule_slot)
    :precondition
      (and
        (unit_authorized ?irrigation_sector_a)
        (unit_assigned_water_asset ?irrigation_sector_a ?water_asset)
        (unit_assigned_schedule_slot ?irrigation_sector_a ?schedule_slot)
        (not
          (unit_replanned ?irrigation_sector_a)
        )
      )
    :effect
      (and
        (unit_replanned ?irrigation_sector_a)
        (water_asset_available ?water_asset)
        (schedule_slot_available ?schedule_slot)
      )
  )
  (:action finalize_unit_replanning_assign_water_asset_sector_b
    :parameters (?irrigation_sector_b - irrigation_sector_b ?water_asset - water_asset ?schedule_slot - schedule_slot)
    :precondition
      (and
        (unit_authorized ?irrigation_sector_b)
        (unit_assigned_water_asset ?irrigation_sector_b ?water_asset)
        (unit_assigned_schedule_slot ?irrigation_sector_b ?schedule_slot)
        (not
          (unit_replanned ?irrigation_sector_b)
        )
      )
    :effect
      (and
        (unit_replanned ?irrigation_sector_b)
        (water_asset_available ?water_asset)
        (schedule_slot_available ?schedule_slot)
      )
  )
  (:action coordinator_finalize_unit_replanning_with_water_asset
    :parameters (?response_coordinator - response_coordinator ?water_asset - water_asset ?schedule_slot - schedule_slot)
    :precondition
      (and
        (unit_authorized ?response_coordinator)
        (unit_assigned_water_asset ?response_coordinator ?water_asset)
        (unit_assigned_schedule_slot ?response_coordinator ?schedule_slot)
        (not
          (unit_replanned ?response_coordinator)
        )
      )
    :effect
      (and
        (unit_replanned ?response_coordinator)
        (water_asset_available ?water_asset)
        (schedule_slot_available ?schedule_slot)
      )
  )
)

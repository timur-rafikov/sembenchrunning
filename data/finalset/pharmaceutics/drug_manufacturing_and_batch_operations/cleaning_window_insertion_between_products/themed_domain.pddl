(define (domain pharmaceutics_cleaning_window_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types auxiliary_resource_category - object document_or_material_category - object zone_category - object processable_entity_root - object processable_entity - processable_entity_root manufacturing_line_unit - auxiliary_resource_category process_stage - auxiliary_resource_category authorized_technician - auxiliary_resource_category component_specification - auxiliary_resource_category consumable_lot - auxiliary_resource_category release_document - auxiliary_resource_category validation_record - auxiliary_resource_category qa_approval_document - auxiliary_resource_category cleaning_agent - document_or_material_category cleaning_protocol_document - document_or_material_category safety_lock_tag - document_or_material_category equipment_zone_upstream - zone_category equipment_zone_downstream - zone_category cleaning_window - zone_category product_batch_category - processable_entity equipment_category - processable_entity preceding_product_batch - product_batch_category subsequent_product_batch - product_batch_category equipment_unit - equipment_category)
  (:predicates
    (scheduled_for_processing ?processable_entity - processable_entity)
    (technician_assignment_pending ?processable_entity - processable_entity)
    (allocated_on_line ?processable_entity - processable_entity)
    (cleared_for_changeover ?processable_entity - processable_entity)
    (handover_completed ?processable_entity - processable_entity)
    (entity_has_release_document ?processable_entity - processable_entity)
    (manufacturing_line_available ?manufacturing_line_unit - manufacturing_line_unit)
    (assigned_to_line ?processable_entity - processable_entity ?manufacturing_line_unit - manufacturing_line_unit)
    (process_stage_available ?process_stage - process_stage)
    (assigned_to_stage ?processable_entity - processable_entity ?process_stage - process_stage)
    (technician_available ?authorized_technician - authorized_technician)
    (technician_assigned ?processable_entity - processable_entity ?authorized_technician - authorized_technician)
    (cleaning_agent_available ?cleaning_agent - cleaning_agent)
    (cleaning_agent_staged_for_preceding_batch ?preceding_product_batch - preceding_product_batch ?cleaning_agent - cleaning_agent)
    (cleaning_agent_staged_for_subsequent_batch ?subsequent_product_batch - subsequent_product_batch ?cleaning_agent - cleaning_agent)
    (assigned_upstream_zone ?preceding_product_batch - preceding_product_batch ?equipment_zone_upstream - equipment_zone_upstream)
    (upstream_zone_tagged ?equipment_zone_upstream - equipment_zone_upstream)
    (upstream_cleaning_agent_applied ?equipment_zone_upstream - equipment_zone_upstream)
    (preceding_batch_prepared ?preceding_product_batch - preceding_product_batch)
    (assigned_downstream_zone ?subsequent_product_batch - subsequent_product_batch ?equipment_zone_downstream - equipment_zone_downstream)
    (downstream_zone_tagged ?equipment_zone_downstream - equipment_zone_downstream)
    (downstream_cleaning_agent_applied ?equipment_zone_downstream - equipment_zone_downstream)
    (subsequent_batch_prepared ?subsequent_product_batch - subsequent_product_batch)
    (cleaning_window_available ?cleaning_window - cleaning_window)
    (cleaning_window_created ?cleaning_window - cleaning_window)
    (cleaning_window_covers_upstream_zone ?cleaning_window - cleaning_window ?equipment_zone_upstream - equipment_zone_upstream)
    (cleaning_window_covers_downstream_zone ?cleaning_window - cleaning_window ?equipment_zone_downstream - equipment_zone_downstream)
    (upstream_component_configuration_required ?cleaning_window - cleaning_window)
    (downstream_component_configuration_required ?cleaning_window - cleaning_window)
    (cleaning_window_activated ?cleaning_window - cleaning_window)
    (equipment_assigned_to_preceding_batch ?equipment_unit - equipment_unit ?preceding_product_batch - preceding_product_batch)
    (equipment_assigned_to_subsequent_batch ?equipment_unit - equipment_unit ?subsequent_product_batch - subsequent_product_batch)
    (equipment_linked_to_cleaning_window ?equipment_unit - equipment_unit ?cleaning_window - cleaning_window)
    (cleaning_protocol_available ?cleaning_protocol - cleaning_protocol_document)
    (protocol_assigned_to_equipment ?equipment_unit - equipment_unit ?cleaning_protocol - cleaning_protocol_document)
    (cleaning_protocol_used ?cleaning_protocol - cleaning_protocol_document)
    (protocol_attached_to_window ?cleaning_protocol - cleaning_protocol_document ?cleaning_window - cleaning_window)
    (protocol_executed_on_equipment ?equipment_unit - equipment_unit)
    (execution_verified ?equipment_unit - equipment_unit)
    (equipment_has_qa_approval ?equipment_unit - equipment_unit)
    (equipment_has_component_specification ?equipment_unit - equipment_unit)
    (component_configuration_applied ?equipment_unit - equipment_unit)
    (equipment_has_validation_record ?equipment_unit - equipment_unit)
    (final_verification_complete ?equipment_unit - equipment_unit)
    (safety_tag_available ?safety_lock_tag - safety_lock_tag)
    (safety_tag_assigned_to_equipment ?equipment_unit - equipment_unit ?safety_lock_tag - safety_lock_tag)
    (equipment_has_safety_lock_tag ?equipment_unit - equipment_unit)
    (lock_verified_by_technician ?equipment_unit - equipment_unit)
    (lock_review_completed ?equipment_unit - equipment_unit)
    (component_spec_available ?component_specification - component_specification)
    (component_spec_attached_to_equipment ?equipment_unit - equipment_unit ?component_specification - component_specification)
    (consumable_available ?consumable_lot - consumable_lot)
    (consumable_staged_for_equipment ?equipment_unit - equipment_unit ?consumable_lot - consumable_lot)
    (validation_record_available ?validation_record - validation_record)
    (validation_record_attached_to_equipment ?equipment_unit - equipment_unit ?validation_record - validation_record)
    (qa_approval_available ?qa_approval_document - qa_approval_document)
    (qa_approval_attached_to_equipment ?equipment_unit - equipment_unit ?qa_approval_document - qa_approval_document)
    (release_document_available ?release_document - release_document)
    (release_document_attached_to_entity ?processable_entity - processable_entity ?release_document - release_document)
    (preceding_batch_ready ?preceding_product_batch - preceding_product_batch)
    (subsequent_batch_ready ?subsequent_product_batch - subsequent_product_batch)
    (handover_record_logged ?equipment_unit - equipment_unit)
  )
  (:action schedule_batch
    :parameters (?processable_entity - processable_entity)
    :precondition
      (and
        (not
          (scheduled_for_processing ?processable_entity)
        )
        (not
          (cleared_for_changeover ?processable_entity)
        )
      )
    :effect (scheduled_for_processing ?processable_entity)
  )
  (:action assign_line_to_batch
    :parameters (?processable_entity - processable_entity ?manufacturing_line_unit - manufacturing_line_unit)
    :precondition
      (and
        (scheduled_for_processing ?processable_entity)
        (not
          (allocated_on_line ?processable_entity)
        )
        (manufacturing_line_available ?manufacturing_line_unit)
      )
    :effect
      (and
        (allocated_on_line ?processable_entity)
        (assigned_to_line ?processable_entity ?manufacturing_line_unit)
        (not
          (manufacturing_line_available ?manufacturing_line_unit)
        )
      )
  )
  (:action assign_process_stage
    :parameters (?processable_entity - processable_entity ?process_stage - process_stage)
    :precondition
      (and
        (scheduled_for_processing ?processable_entity)
        (allocated_on_line ?processable_entity)
        (process_stage_available ?process_stage)
      )
    :effect
      (and
        (assigned_to_stage ?processable_entity ?process_stage)
        (not
          (process_stage_available ?process_stage)
        )
      )
  )
  (:action complete_stage_assignment
    :parameters (?processable_entity - processable_entity ?process_stage - process_stage)
    :precondition
      (and
        (scheduled_for_processing ?processable_entity)
        (allocated_on_line ?processable_entity)
        (assigned_to_stage ?processable_entity ?process_stage)
        (not
          (technician_assignment_pending ?processable_entity)
        )
      )
    :effect (technician_assignment_pending ?processable_entity)
  )
  (:action unassign_process_stage
    :parameters (?processable_entity - processable_entity ?process_stage - process_stage)
    :precondition
      (and
        (assigned_to_stage ?processable_entity ?process_stage)
      )
    :effect
      (and
        (process_stage_available ?process_stage)
        (not
          (assigned_to_stage ?processable_entity ?process_stage)
        )
      )
  )
  (:action assign_technician
    :parameters (?processable_entity - processable_entity ?authorized_technician - authorized_technician)
    :precondition
      (and
        (technician_assignment_pending ?processable_entity)
        (technician_available ?authorized_technician)
      )
    :effect
      (and
        (technician_assigned ?processable_entity ?authorized_technician)
        (not
          (technician_available ?authorized_technician)
        )
      )
  )
  (:action unassign_technician
    :parameters (?processable_entity - processable_entity ?authorized_technician - authorized_technician)
    :precondition
      (and
        (technician_assigned ?processable_entity ?authorized_technician)
      )
    :effect
      (and
        (technician_available ?authorized_technician)
        (not
          (technician_assigned ?processable_entity ?authorized_technician)
        )
      )
  )
  (:action attach_validation_record_to_equipment
    :parameters (?equipment_unit - equipment_unit ?validation_record - validation_record)
    :precondition
      (and
        (technician_assignment_pending ?equipment_unit)
        (validation_record_available ?validation_record)
      )
    :effect
      (and
        (validation_record_attached_to_equipment ?equipment_unit ?validation_record)
        (not
          (validation_record_available ?validation_record)
        )
      )
  )
  (:action detach_validation_record_from_equipment
    :parameters (?equipment_unit - equipment_unit ?validation_record - validation_record)
    :precondition
      (and
        (validation_record_attached_to_equipment ?equipment_unit ?validation_record)
      )
    :effect
      (and
        (validation_record_available ?validation_record)
        (not
          (validation_record_attached_to_equipment ?equipment_unit ?validation_record)
        )
      )
  )
  (:action attach_qa_approval_document
    :parameters (?equipment_unit - equipment_unit ?qa_approval_document - qa_approval_document)
    :precondition
      (and
        (technician_assignment_pending ?equipment_unit)
        (qa_approval_available ?qa_approval_document)
      )
    :effect
      (and
        (qa_approval_attached_to_equipment ?equipment_unit ?qa_approval_document)
        (not
          (qa_approval_available ?qa_approval_document)
        )
      )
  )
  (:action detach_qa_approval_document
    :parameters (?equipment_unit - equipment_unit ?qa_approval_document - qa_approval_document)
    :precondition
      (and
        (qa_approval_attached_to_equipment ?equipment_unit ?qa_approval_document)
      )
    :effect
      (and
        (qa_approval_available ?qa_approval_document)
        (not
          (qa_approval_attached_to_equipment ?equipment_unit ?qa_approval_document)
        )
      )
  )
  (:action isolate_upstream_zone
    :parameters (?preceding_product_batch - preceding_product_batch ?equipment_zone_upstream - equipment_zone_upstream ?process_stage - process_stage)
    :precondition
      (and
        (technician_assignment_pending ?preceding_product_batch)
        (assigned_to_stage ?preceding_product_batch ?process_stage)
        (assigned_upstream_zone ?preceding_product_batch ?equipment_zone_upstream)
        (not
          (upstream_zone_tagged ?equipment_zone_upstream)
        )
        (not
          (upstream_cleaning_agent_applied ?equipment_zone_upstream)
        )
      )
    :effect (upstream_zone_tagged ?equipment_zone_upstream)
  )
  (:action technician_perform_upstream_preparation
    :parameters (?preceding_product_batch - preceding_product_batch ?equipment_zone_upstream - equipment_zone_upstream ?authorized_technician - authorized_technician)
    :precondition
      (and
        (technician_assignment_pending ?preceding_product_batch)
        (technician_assigned ?preceding_product_batch ?authorized_technician)
        (assigned_upstream_zone ?preceding_product_batch ?equipment_zone_upstream)
        (upstream_zone_tagged ?equipment_zone_upstream)
        (not
          (preceding_batch_ready ?preceding_product_batch)
        )
      )
    :effect
      (and
        (preceding_batch_ready ?preceding_product_batch)
        (preceding_batch_prepared ?preceding_product_batch)
      )
  )
  (:action stage_cleaning_agent_for_upstream_batch
    :parameters (?preceding_product_batch - preceding_product_batch ?equipment_zone_upstream - equipment_zone_upstream ?cleaning_agent - cleaning_agent)
    :precondition
      (and
        (technician_assignment_pending ?preceding_product_batch)
        (assigned_upstream_zone ?preceding_product_batch ?equipment_zone_upstream)
        (cleaning_agent_available ?cleaning_agent)
        (not
          (preceding_batch_ready ?preceding_product_batch)
        )
      )
    :effect
      (and
        (upstream_cleaning_agent_applied ?equipment_zone_upstream)
        (preceding_batch_ready ?preceding_product_batch)
        (cleaning_agent_staged_for_preceding_batch ?preceding_product_batch ?cleaning_agent)
        (not
          (cleaning_agent_available ?cleaning_agent)
        )
      )
  )
  (:action execute_upstream_cleaning
    :parameters (?preceding_product_batch - preceding_product_batch ?equipment_zone_upstream - equipment_zone_upstream ?process_stage - process_stage ?cleaning_agent - cleaning_agent)
    :precondition
      (and
        (technician_assignment_pending ?preceding_product_batch)
        (assigned_to_stage ?preceding_product_batch ?process_stage)
        (assigned_upstream_zone ?preceding_product_batch ?equipment_zone_upstream)
        (upstream_cleaning_agent_applied ?equipment_zone_upstream)
        (cleaning_agent_staged_for_preceding_batch ?preceding_product_batch ?cleaning_agent)
        (not
          (preceding_batch_prepared ?preceding_product_batch)
        )
      )
    :effect
      (and
        (upstream_zone_tagged ?equipment_zone_upstream)
        (preceding_batch_prepared ?preceding_product_batch)
        (cleaning_agent_available ?cleaning_agent)
        (not
          (cleaning_agent_staged_for_preceding_batch ?preceding_product_batch ?cleaning_agent)
        )
      )
  )
  (:action isolate_downstream_zone
    :parameters (?subsequent_product_batch - subsequent_product_batch ?equipment_zone_downstream - equipment_zone_downstream ?process_stage - process_stage)
    :precondition
      (and
        (technician_assignment_pending ?subsequent_product_batch)
        (assigned_to_stage ?subsequent_product_batch ?process_stage)
        (assigned_downstream_zone ?subsequent_product_batch ?equipment_zone_downstream)
        (not
          (downstream_zone_tagged ?equipment_zone_downstream)
        )
        (not
          (downstream_cleaning_agent_applied ?equipment_zone_downstream)
        )
      )
    :effect (downstream_zone_tagged ?equipment_zone_downstream)
  )
  (:action technician_perform_downstream_preparation
    :parameters (?subsequent_product_batch - subsequent_product_batch ?equipment_zone_downstream - equipment_zone_downstream ?authorized_technician - authorized_technician)
    :precondition
      (and
        (technician_assignment_pending ?subsequent_product_batch)
        (technician_assigned ?subsequent_product_batch ?authorized_technician)
        (assigned_downstream_zone ?subsequent_product_batch ?equipment_zone_downstream)
        (downstream_zone_tagged ?equipment_zone_downstream)
        (not
          (subsequent_batch_ready ?subsequent_product_batch)
        )
      )
    :effect
      (and
        (subsequent_batch_ready ?subsequent_product_batch)
        (subsequent_batch_prepared ?subsequent_product_batch)
      )
  )
  (:action stage_cleaning_agent_for_subsequent_batch
    :parameters (?subsequent_product_batch - subsequent_product_batch ?equipment_zone_downstream - equipment_zone_downstream ?cleaning_agent - cleaning_agent)
    :precondition
      (and
        (technician_assignment_pending ?subsequent_product_batch)
        (assigned_downstream_zone ?subsequent_product_batch ?equipment_zone_downstream)
        (cleaning_agent_available ?cleaning_agent)
        (not
          (subsequent_batch_ready ?subsequent_product_batch)
        )
      )
    :effect
      (and
        (downstream_cleaning_agent_applied ?equipment_zone_downstream)
        (subsequent_batch_ready ?subsequent_product_batch)
        (cleaning_agent_staged_for_subsequent_batch ?subsequent_product_batch ?cleaning_agent)
        (not
          (cleaning_agent_available ?cleaning_agent)
        )
      )
  )
  (:action execute_downstream_cleaning
    :parameters (?subsequent_product_batch - subsequent_product_batch ?equipment_zone_downstream - equipment_zone_downstream ?process_stage - process_stage ?cleaning_agent - cleaning_agent)
    :precondition
      (and
        (technician_assignment_pending ?subsequent_product_batch)
        (assigned_to_stage ?subsequent_product_batch ?process_stage)
        (assigned_downstream_zone ?subsequent_product_batch ?equipment_zone_downstream)
        (downstream_cleaning_agent_applied ?equipment_zone_downstream)
        (cleaning_agent_staged_for_subsequent_batch ?subsequent_product_batch ?cleaning_agent)
        (not
          (subsequent_batch_prepared ?subsequent_product_batch)
        )
      )
    :effect
      (and
        (downstream_zone_tagged ?equipment_zone_downstream)
        (subsequent_batch_prepared ?subsequent_product_batch)
        (cleaning_agent_available ?cleaning_agent)
        (not
          (cleaning_agent_staged_for_subsequent_batch ?subsequent_product_batch ?cleaning_agent)
        )
      )
  )
  (:action create_cleaning_window
    :parameters (?preceding_product_batch - preceding_product_batch ?subsequent_product_batch - subsequent_product_batch ?equipment_zone_upstream - equipment_zone_upstream ?equipment_zone_downstream - equipment_zone_downstream ?cleaning_window - cleaning_window)
    :precondition
      (and
        (preceding_batch_ready ?preceding_product_batch)
        (subsequent_batch_ready ?subsequent_product_batch)
        (assigned_upstream_zone ?preceding_product_batch ?equipment_zone_upstream)
        (assigned_downstream_zone ?subsequent_product_batch ?equipment_zone_downstream)
        (upstream_zone_tagged ?equipment_zone_upstream)
        (downstream_zone_tagged ?equipment_zone_downstream)
        (preceding_batch_prepared ?preceding_product_batch)
        (subsequent_batch_prepared ?subsequent_product_batch)
        (cleaning_window_available ?cleaning_window)
      )
    :effect
      (and
        (cleaning_window_created ?cleaning_window)
        (cleaning_window_covers_upstream_zone ?cleaning_window ?equipment_zone_upstream)
        (cleaning_window_covers_downstream_zone ?cleaning_window ?equipment_zone_downstream)
        (not
          (cleaning_window_available ?cleaning_window)
        )
      )
  )
  (:action create_cleaning_window_with_upstream_config_requirement
    :parameters (?preceding_product_batch - preceding_product_batch ?subsequent_product_batch - subsequent_product_batch ?equipment_zone_upstream - equipment_zone_upstream ?equipment_zone_downstream - equipment_zone_downstream ?cleaning_window - cleaning_window)
    :precondition
      (and
        (preceding_batch_ready ?preceding_product_batch)
        (subsequent_batch_ready ?subsequent_product_batch)
        (assigned_upstream_zone ?preceding_product_batch ?equipment_zone_upstream)
        (assigned_downstream_zone ?subsequent_product_batch ?equipment_zone_downstream)
        (upstream_cleaning_agent_applied ?equipment_zone_upstream)
        (downstream_zone_tagged ?equipment_zone_downstream)
        (not
          (preceding_batch_prepared ?preceding_product_batch)
        )
        (subsequent_batch_prepared ?subsequent_product_batch)
        (cleaning_window_available ?cleaning_window)
      )
    :effect
      (and
        (cleaning_window_created ?cleaning_window)
        (cleaning_window_covers_upstream_zone ?cleaning_window ?equipment_zone_upstream)
        (cleaning_window_covers_downstream_zone ?cleaning_window ?equipment_zone_downstream)
        (upstream_component_configuration_required ?cleaning_window)
        (not
          (cleaning_window_available ?cleaning_window)
        )
      )
  )
  (:action create_cleaning_window_with_downstream_config_requirement
    :parameters (?preceding_product_batch - preceding_product_batch ?subsequent_product_batch - subsequent_product_batch ?equipment_zone_upstream - equipment_zone_upstream ?equipment_zone_downstream - equipment_zone_downstream ?cleaning_window - cleaning_window)
    :precondition
      (and
        (preceding_batch_ready ?preceding_product_batch)
        (subsequent_batch_ready ?subsequent_product_batch)
        (assigned_upstream_zone ?preceding_product_batch ?equipment_zone_upstream)
        (assigned_downstream_zone ?subsequent_product_batch ?equipment_zone_downstream)
        (upstream_zone_tagged ?equipment_zone_upstream)
        (downstream_cleaning_agent_applied ?equipment_zone_downstream)
        (preceding_batch_prepared ?preceding_product_batch)
        (not
          (subsequent_batch_prepared ?subsequent_product_batch)
        )
        (cleaning_window_available ?cleaning_window)
      )
    :effect
      (and
        (cleaning_window_created ?cleaning_window)
        (cleaning_window_covers_upstream_zone ?cleaning_window ?equipment_zone_upstream)
        (cleaning_window_covers_downstream_zone ?cleaning_window ?equipment_zone_downstream)
        (downstream_component_configuration_required ?cleaning_window)
        (not
          (cleaning_window_available ?cleaning_window)
        )
      )
  )
  (:action create_cleaning_window_with_both_config_requirements
    :parameters (?preceding_product_batch - preceding_product_batch ?subsequent_product_batch - subsequent_product_batch ?equipment_zone_upstream - equipment_zone_upstream ?equipment_zone_downstream - equipment_zone_downstream ?cleaning_window - cleaning_window)
    :precondition
      (and
        (preceding_batch_ready ?preceding_product_batch)
        (subsequent_batch_ready ?subsequent_product_batch)
        (assigned_upstream_zone ?preceding_product_batch ?equipment_zone_upstream)
        (assigned_downstream_zone ?subsequent_product_batch ?equipment_zone_downstream)
        (upstream_cleaning_agent_applied ?equipment_zone_upstream)
        (downstream_cleaning_agent_applied ?equipment_zone_downstream)
        (not
          (preceding_batch_prepared ?preceding_product_batch)
        )
        (not
          (subsequent_batch_prepared ?subsequent_product_batch)
        )
        (cleaning_window_available ?cleaning_window)
      )
    :effect
      (and
        (cleaning_window_created ?cleaning_window)
        (cleaning_window_covers_upstream_zone ?cleaning_window ?equipment_zone_upstream)
        (cleaning_window_covers_downstream_zone ?cleaning_window ?equipment_zone_downstream)
        (upstream_component_configuration_required ?cleaning_window)
        (downstream_component_configuration_required ?cleaning_window)
        (not
          (cleaning_window_available ?cleaning_window)
        )
      )
  )
  (:action activate_cleaning_window
    :parameters (?cleaning_window - cleaning_window ?preceding_product_batch - preceding_product_batch ?process_stage - process_stage)
    :precondition
      (and
        (cleaning_window_created ?cleaning_window)
        (preceding_batch_ready ?preceding_product_batch)
        (assigned_to_stage ?preceding_product_batch ?process_stage)
        (not
          (cleaning_window_activated ?cleaning_window)
        )
      )
    :effect (cleaning_window_activated ?cleaning_window)
  )
  (:action apply_cleaning_protocol
    :parameters (?equipment_unit - equipment_unit ?cleaning_protocol - cleaning_protocol_document ?cleaning_window - cleaning_window)
    :precondition
      (and
        (technician_assignment_pending ?equipment_unit)
        (equipment_linked_to_cleaning_window ?equipment_unit ?cleaning_window)
        (protocol_assigned_to_equipment ?equipment_unit ?cleaning_protocol)
        (cleaning_protocol_available ?cleaning_protocol)
        (cleaning_window_created ?cleaning_window)
        (cleaning_window_activated ?cleaning_window)
        (not
          (cleaning_protocol_used ?cleaning_protocol)
        )
      )
    :effect
      (and
        (cleaning_protocol_used ?cleaning_protocol)
        (protocol_attached_to_window ?cleaning_protocol ?cleaning_window)
        (not
          (cleaning_protocol_available ?cleaning_protocol)
        )
      )
  )
  (:action execute_protocol_on_equipment
    :parameters (?equipment_unit - equipment_unit ?cleaning_protocol - cleaning_protocol_document ?cleaning_window - cleaning_window ?process_stage - process_stage)
    :precondition
      (and
        (technician_assignment_pending ?equipment_unit)
        (protocol_assigned_to_equipment ?equipment_unit ?cleaning_protocol)
        (cleaning_protocol_used ?cleaning_protocol)
        (protocol_attached_to_window ?cleaning_protocol ?cleaning_window)
        (assigned_to_stage ?equipment_unit ?process_stage)
        (not
          (upstream_component_configuration_required ?cleaning_window)
        )
        (not
          (protocol_executed_on_equipment ?equipment_unit)
        )
      )
    :effect (protocol_executed_on_equipment ?equipment_unit)
  )
  (:action attach_component_specification_to_equipment
    :parameters (?equipment_unit - equipment_unit ?component_specification - component_specification)
    :precondition
      (and
        (technician_assignment_pending ?equipment_unit)
        (component_spec_available ?component_specification)
        (not
          (equipment_has_component_specification ?equipment_unit)
        )
      )
    :effect
      (and
        (equipment_has_component_specification ?equipment_unit)
        (component_spec_attached_to_equipment ?equipment_unit ?component_specification)
        (not
          (component_spec_available ?component_specification)
        )
      )
  )
  (:action execute_protocol_with_component_configuration
    :parameters (?equipment_unit - equipment_unit ?cleaning_protocol - cleaning_protocol_document ?cleaning_window - cleaning_window ?process_stage - process_stage ?component_specification - component_specification)
    :precondition
      (and
        (technician_assignment_pending ?equipment_unit)
        (protocol_assigned_to_equipment ?equipment_unit ?cleaning_protocol)
        (cleaning_protocol_used ?cleaning_protocol)
        (protocol_attached_to_window ?cleaning_protocol ?cleaning_window)
        (assigned_to_stage ?equipment_unit ?process_stage)
        (upstream_component_configuration_required ?cleaning_window)
        (equipment_has_component_specification ?equipment_unit)
        (component_spec_attached_to_equipment ?equipment_unit ?component_specification)
        (not
          (protocol_executed_on_equipment ?equipment_unit)
        )
      )
    :effect
      (and
        (protocol_executed_on_equipment ?equipment_unit)
        (component_configuration_applied ?equipment_unit)
      )
  )
  (:action attach_validation_record_standard
    :parameters (?equipment_unit - equipment_unit ?validation_record - validation_record ?authorized_technician - authorized_technician ?cleaning_protocol - cleaning_protocol_document ?cleaning_window - cleaning_window)
    :precondition
      (and
        (protocol_executed_on_equipment ?equipment_unit)
        (validation_record_attached_to_equipment ?equipment_unit ?validation_record)
        (technician_assigned ?equipment_unit ?authorized_technician)
        (protocol_assigned_to_equipment ?equipment_unit ?cleaning_protocol)
        (protocol_attached_to_window ?cleaning_protocol ?cleaning_window)
        (not
          (downstream_component_configuration_required ?cleaning_window)
        )
        (not
          (execution_verified ?equipment_unit)
        )
      )
    :effect (execution_verified ?equipment_unit)
  )
  (:action attach_validation_record_with_downstream_config
    :parameters (?equipment_unit - equipment_unit ?validation_record - validation_record ?authorized_technician - authorized_technician ?cleaning_protocol - cleaning_protocol_document ?cleaning_window - cleaning_window)
    :precondition
      (and
        (protocol_executed_on_equipment ?equipment_unit)
        (validation_record_attached_to_equipment ?equipment_unit ?validation_record)
        (technician_assigned ?equipment_unit ?authorized_technician)
        (protocol_assigned_to_equipment ?equipment_unit ?cleaning_protocol)
        (protocol_attached_to_window ?cleaning_protocol ?cleaning_window)
        (downstream_component_configuration_required ?cleaning_window)
        (not
          (execution_verified ?equipment_unit)
        )
      )
    :effect (execution_verified ?equipment_unit)
  )
  (:action obtain_qa_approval_for_equipment
    :parameters (?equipment_unit - equipment_unit ?qa_approval_document - qa_approval_document ?cleaning_protocol - cleaning_protocol_document ?cleaning_window - cleaning_window)
    :precondition
      (and
        (execution_verified ?equipment_unit)
        (qa_approval_attached_to_equipment ?equipment_unit ?qa_approval_document)
        (protocol_assigned_to_equipment ?equipment_unit ?cleaning_protocol)
        (protocol_attached_to_window ?cleaning_protocol ?cleaning_window)
        (not
          (upstream_component_configuration_required ?cleaning_window)
        )
        (not
          (downstream_component_configuration_required ?cleaning_window)
        )
        (not
          (equipment_has_qa_approval ?equipment_unit)
        )
      )
    :effect (equipment_has_qa_approval ?equipment_unit)
  )
  (:action obtain_qa_approval_with_upstream_config
    :parameters (?equipment_unit - equipment_unit ?qa_approval_document - qa_approval_document ?cleaning_protocol - cleaning_protocol_document ?cleaning_window - cleaning_window)
    :precondition
      (and
        (execution_verified ?equipment_unit)
        (qa_approval_attached_to_equipment ?equipment_unit ?qa_approval_document)
        (protocol_assigned_to_equipment ?equipment_unit ?cleaning_protocol)
        (protocol_attached_to_window ?cleaning_protocol ?cleaning_window)
        (upstream_component_configuration_required ?cleaning_window)
        (not
          (downstream_component_configuration_required ?cleaning_window)
        )
        (not
          (equipment_has_qa_approval ?equipment_unit)
        )
      )
    :effect
      (and
        (equipment_has_qa_approval ?equipment_unit)
        (equipment_has_validation_record ?equipment_unit)
      )
  )
  (:action obtain_qa_approval_with_downstream_config
    :parameters (?equipment_unit - equipment_unit ?qa_approval_document - qa_approval_document ?cleaning_protocol - cleaning_protocol_document ?cleaning_window - cleaning_window)
    :precondition
      (and
        (execution_verified ?equipment_unit)
        (qa_approval_attached_to_equipment ?equipment_unit ?qa_approval_document)
        (protocol_assigned_to_equipment ?equipment_unit ?cleaning_protocol)
        (protocol_attached_to_window ?cleaning_protocol ?cleaning_window)
        (not
          (upstream_component_configuration_required ?cleaning_window)
        )
        (downstream_component_configuration_required ?cleaning_window)
        (not
          (equipment_has_qa_approval ?equipment_unit)
        )
      )
    :effect
      (and
        (equipment_has_qa_approval ?equipment_unit)
        (equipment_has_validation_record ?equipment_unit)
      )
  )
  (:action obtain_qa_approval_with_both_configs
    :parameters (?equipment_unit - equipment_unit ?qa_approval_document - qa_approval_document ?cleaning_protocol - cleaning_protocol_document ?cleaning_window - cleaning_window)
    :precondition
      (and
        (execution_verified ?equipment_unit)
        (qa_approval_attached_to_equipment ?equipment_unit ?qa_approval_document)
        (protocol_assigned_to_equipment ?equipment_unit ?cleaning_protocol)
        (protocol_attached_to_window ?cleaning_protocol ?cleaning_window)
        (upstream_component_configuration_required ?cleaning_window)
        (downstream_component_configuration_required ?cleaning_window)
        (not
          (equipment_has_qa_approval ?equipment_unit)
        )
      )
    :effect
      (and
        (equipment_has_qa_approval ?equipment_unit)
        (equipment_has_validation_record ?equipment_unit)
      )
  )
  (:action finalize_equipment_handover
    :parameters (?equipment_unit - equipment_unit)
    :precondition
      (and
        (equipment_has_qa_approval ?equipment_unit)
        (not
          (equipment_has_validation_record ?equipment_unit)
        )
        (not
          (handover_record_logged ?equipment_unit)
        )
      )
    :effect
      (and
        (handover_record_logged ?equipment_unit)
        (handover_completed ?equipment_unit)
      )
  )
  (:action stage_consumable_for_equipment
    :parameters (?equipment_unit - equipment_unit ?consumable_lot - consumable_lot)
    :precondition
      (and
        (equipment_has_qa_approval ?equipment_unit)
        (equipment_has_validation_record ?equipment_unit)
        (consumable_available ?consumable_lot)
      )
    :effect
      (and
        (consumable_staged_for_equipment ?equipment_unit ?consumable_lot)
        (not
          (consumable_available ?consumable_lot)
        )
      )
  )
  (:action perform_final_verification_pre_handover
    :parameters (?equipment_unit - equipment_unit ?preceding_product_batch - preceding_product_batch ?subsequent_product_batch - subsequent_product_batch ?process_stage - process_stage ?consumable_lot - consumable_lot)
    :precondition
      (and
        (equipment_has_qa_approval ?equipment_unit)
        (equipment_has_validation_record ?equipment_unit)
        (consumable_staged_for_equipment ?equipment_unit ?consumable_lot)
        (equipment_assigned_to_preceding_batch ?equipment_unit ?preceding_product_batch)
        (equipment_assigned_to_subsequent_batch ?equipment_unit ?subsequent_product_batch)
        (preceding_batch_prepared ?preceding_product_batch)
        (subsequent_batch_prepared ?subsequent_product_batch)
        (assigned_to_stage ?equipment_unit ?process_stage)
        (not
          (final_verification_complete ?equipment_unit)
        )
      )
    :effect (final_verification_complete ?equipment_unit)
  )
  (:action finalize_handover_after_final_verification
    :parameters (?equipment_unit - equipment_unit)
    :precondition
      (and
        (equipment_has_qa_approval ?equipment_unit)
        (final_verification_complete ?equipment_unit)
        (not
          (handover_record_logged ?equipment_unit)
        )
      )
    :effect
      (and
        (handover_record_logged ?equipment_unit)
        (handover_completed ?equipment_unit)
      )
  )
  (:action apply_safety_tag_to_equipment
    :parameters (?equipment_unit - equipment_unit ?safety_lock_tag - safety_lock_tag ?process_stage - process_stage)
    :precondition
      (and
        (technician_assignment_pending ?equipment_unit)
        (assigned_to_stage ?equipment_unit ?process_stage)
        (safety_tag_available ?safety_lock_tag)
        (safety_tag_assigned_to_equipment ?equipment_unit ?safety_lock_tag)
        (not
          (equipment_has_safety_lock_tag ?equipment_unit)
        )
      )
    :effect
      (and
        (equipment_has_safety_lock_tag ?equipment_unit)
        (not
          (safety_tag_available ?safety_lock_tag)
        )
      )
  )
  (:action verify_safety_tag_by_technician
    :parameters (?equipment_unit - equipment_unit ?authorized_technician - authorized_technician)
    :precondition
      (and
        (equipment_has_safety_lock_tag ?equipment_unit)
        (technician_assigned ?equipment_unit ?authorized_technician)
        (not
          (lock_verified_by_technician ?equipment_unit)
        )
      )
    :effect (lock_verified_by_technician ?equipment_unit)
  )
  (:action complete_lock_review
    :parameters (?equipment_unit - equipment_unit ?qa_approval_document - qa_approval_document)
    :precondition
      (and
        (lock_verified_by_technician ?equipment_unit)
        (qa_approval_attached_to_equipment ?equipment_unit ?qa_approval_document)
        (not
          (lock_review_completed ?equipment_unit)
        )
      )
    :effect (lock_review_completed ?equipment_unit)
  )
  (:action finalize_handover_after_lock_review
    :parameters (?equipment_unit - equipment_unit)
    :precondition
      (and
        (lock_review_completed ?equipment_unit)
        (not
          (handover_record_logged ?equipment_unit)
        )
      )
    :effect
      (and
        (handover_record_logged ?equipment_unit)
        (handover_completed ?equipment_unit)
      )
  )
  (:action mark_preceding_batch_ready_for_release
    :parameters (?preceding_product_batch - preceding_product_batch ?cleaning_window - cleaning_window)
    :precondition
      (and
        (preceding_batch_ready ?preceding_product_batch)
        (preceding_batch_prepared ?preceding_product_batch)
        (cleaning_window_created ?cleaning_window)
        (cleaning_window_activated ?cleaning_window)
        (not
          (handover_completed ?preceding_product_batch)
        )
      )
    :effect (handover_completed ?preceding_product_batch)
  )
  (:action mark_subsequent_batch_ready_for_release
    :parameters (?subsequent_product_batch - subsequent_product_batch ?cleaning_window - cleaning_window)
    :precondition
      (and
        (subsequent_batch_ready ?subsequent_product_batch)
        (subsequent_batch_prepared ?subsequent_product_batch)
        (cleaning_window_created ?cleaning_window)
        (cleaning_window_activated ?cleaning_window)
        (not
          (handover_completed ?subsequent_product_batch)
        )
      )
    :effect (handover_completed ?subsequent_product_batch)
  )
  (:action attach_release_document_to_entity
    :parameters (?processable_entity - processable_entity ?release_document - release_document ?process_stage - process_stage)
    :precondition
      (and
        (handover_completed ?processable_entity)
        (assigned_to_stage ?processable_entity ?process_stage)
        (release_document_available ?release_document)
        (not
          (entity_has_release_document ?processable_entity)
        )
      )
    :effect
      (and
        (entity_has_release_document ?processable_entity)
        (release_document_attached_to_entity ?processable_entity ?release_document)
        (not
          (release_document_available ?release_document)
        )
      )
  )
  (:action finalize_preceding_batch_and_release_line
    :parameters (?preceding_product_batch - preceding_product_batch ?manufacturing_line_unit - manufacturing_line_unit ?release_document - release_document)
    :precondition
      (and
        (entity_has_release_document ?preceding_product_batch)
        (assigned_to_line ?preceding_product_batch ?manufacturing_line_unit)
        (release_document_attached_to_entity ?preceding_product_batch ?release_document)
        (not
          (cleared_for_changeover ?preceding_product_batch)
        )
      )
    :effect
      (and
        (cleared_for_changeover ?preceding_product_batch)
        (manufacturing_line_available ?manufacturing_line_unit)
        (release_document_available ?release_document)
      )
  )
  (:action finalize_subsequent_batch_and_release_line
    :parameters (?subsequent_product_batch - subsequent_product_batch ?manufacturing_line_unit - manufacturing_line_unit ?release_document - release_document)
    :precondition
      (and
        (entity_has_release_document ?subsequent_product_batch)
        (assigned_to_line ?subsequent_product_batch ?manufacturing_line_unit)
        (release_document_attached_to_entity ?subsequent_product_batch ?release_document)
        (not
          (cleared_for_changeover ?subsequent_product_batch)
        )
      )
    :effect
      (and
        (cleared_for_changeover ?subsequent_product_batch)
        (manufacturing_line_available ?manufacturing_line_unit)
        (release_document_available ?release_document)
      )
  )
  (:action finalize_equipment_and_release_line
    :parameters (?equipment_unit - equipment_unit ?manufacturing_line_unit - manufacturing_line_unit ?release_document - release_document)
    :precondition
      (and
        (entity_has_release_document ?equipment_unit)
        (assigned_to_line ?equipment_unit ?manufacturing_line_unit)
        (release_document_attached_to_entity ?equipment_unit ?release_document)
        (not
          (cleared_for_changeover ?equipment_unit)
        )
      )
    :effect
      (and
        (cleared_for_changeover ?equipment_unit)
        (manufacturing_line_available ?manufacturing_line_unit)
        (release_document_available ?release_document)
      )
  )
)

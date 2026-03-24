(define (domain production_line_changeover)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object document_category - object artifact_category - object production_item_category - object production_entity - production_item_category operator_crew - resource_category process_procedure - resource_category equipment_unit - resource_category qualification_document - resource_category quality_approval_token - resource_category release_document - resource_category setup_kit - resource_category test_protocol - resource_category consumable_document - document_category quality_checklist - document_category certificate - document_category origin_stage_state - artifact_category destination_stage_state - artifact_category changeover_record - artifact_category origin_line_group - production_entity destination_line_group - production_entity origin_line - origin_line_group destination_line - origin_line_group changeover_task - destination_line_group)
  (:predicates
    (initialized ?production_entity - production_entity)
    (configured_for_changeover ?production_entity - production_entity)
    (has_crew ?production_entity - production_entity)
    (released ?production_entity - production_entity)
    (ready_for_release ?production_entity - production_entity)
    (release_applied ?production_entity - production_entity)
    (crew_available ?operator_crew - operator_crew)
    (assigned_crew ?production_entity - production_entity ?operator_crew - operator_crew)
    (procedure_available ?process_procedure - process_procedure)
    (assigned_procedure ?production_entity - production_entity ?process_procedure - process_procedure)
    (equipment_available ?equipment_unit - equipment_unit)
    (assigned_equipment ?production_entity - production_entity ?equipment_unit - equipment_unit)
    (consumable_available ?consumable_item - consumable_document)
    (origin_consumable_allocated ?origin_line - origin_line ?consumable_item - consumable_document)
    (destination_consumable_allocated ?destination_line - destination_line ?consumable_item - consumable_document)
    (origin_line_state_assigned ?origin_line - origin_line ?origin_stage_state - origin_stage_state)
    (origin_stage_ready ?origin_stage_state - origin_stage_state)
    (origin_stage_staged ?origin_stage_state - origin_stage_state)
    (origin_line_ready ?origin_line - origin_line)
    (destination_line_state_assigned ?destination_line - destination_line ?destination_stage_state - destination_stage_state)
    (destination_stage_ready ?destination_stage_state - destination_stage_state)
    (destination_stage_staged ?destination_stage_state - destination_stage_state)
    (destination_line_ready ?destination_line - destination_line)
    (record_draft_available ?changeover_record - changeover_record)
    (record_initiated ?changeover_record - changeover_record)
    (record_linked_origin_stage ?changeover_record - changeover_record ?origin_stage_state - origin_stage_state)
    (record_linked_destination_stage ?changeover_record - changeover_record ?destination_stage_state - destination_stage_state)
    (record_requires_qualification ?changeover_record - changeover_record)
    (record_requires_certificate ?changeover_record - changeover_record)
    (record_ready_for_checklist ?changeover_record - changeover_record)
    (task_assigned_origin_line ?changeover_task - changeover_task ?origin_line - origin_line)
    (task_assigned_destination_line ?changeover_task - changeover_task ?destination_line - destination_line)
    (task_linked_record ?changeover_task - changeover_task ?changeover_record - changeover_record)
    (checklist_available ?quality_checklist - quality_checklist)
    (task_has_checklist ?changeover_task - changeover_task ?quality_checklist - quality_checklist)
    (checklist_completed ?quality_checklist - quality_checklist)
    (checklist_attached_to_record ?quality_checklist - quality_checklist ?changeover_record - changeover_record)
    (task_documentation_assembled ?changeover_task - changeover_task)
    (task_certifications_attached ?changeover_task - changeover_task)
    (inspection_performed ?changeover_task - changeover_task)
    (task_has_qualification_document ?changeover_task - changeover_task)
    (qualification_verified ?changeover_task - changeover_task)
    (inspection_requires_quality_approval ?changeover_task - changeover_task)
    (task_ready_for_signoff ?changeover_task - changeover_task)
    (certificate_available ?certificate - certificate)
    (task_certificate_link ?changeover_task - changeover_task ?certificate - certificate)
    (task_certificate_attached ?changeover_task - changeover_task)
    (certificate_reviewed ?changeover_task - changeover_task)
    (certificate_approval_passed ?changeover_task - changeover_task)
    (qualification_document_available ?qualification_document - qualification_document)
    (task_qualification_document_link ?changeover_task - changeover_task ?qualification_document - qualification_document)
    (approval_token_available ?quality_approval_token - quality_approval_token)
    (task_attached_approval_token ?changeover_task - changeover_task ?quality_approval_token - quality_approval_token)
    (setup_kit_available ?setup_kit - setup_kit)
    (task_attached_setup_kit ?changeover_task - changeover_task ?setup_kit - setup_kit)
    (test_protocol_available ?test_protocol - test_protocol)
    (task_attached_test_protocol ?changeover_task - changeover_task ?test_protocol - test_protocol)
    (release_document_available ?release_document - release_document)
    (attached_release_document ?production_entity - production_entity ?release_document - release_document)
    (origin_line_setup_completed ?origin_line - origin_line)
    (destination_line_setup_completed ?destination_line - destination_line)
    (task_signoff_recorded ?changeover_task - changeover_task)
  )
  (:action initialize_production_entity
    :parameters (?production_entity - production_entity)
    :precondition
      (and
        (not
          (initialized ?production_entity)
        )
        (not
          (released ?production_entity)
        )
      )
    :effect (initialized ?production_entity)
  )
  (:action assign_operator_crew_to_entity
    :parameters (?production_entity - production_entity ?operator_crew - operator_crew)
    :precondition
      (and
        (initialized ?production_entity)
        (not
          (has_crew ?production_entity)
        )
        (crew_available ?operator_crew)
      )
    :effect
      (and
        (has_crew ?production_entity)
        (assigned_crew ?production_entity ?operator_crew)
        (not
          (crew_available ?operator_crew)
        )
      )
  )
  (:action assign_process_procedure_to_entity
    :parameters (?production_entity - production_entity ?process_procedure - process_procedure)
    :precondition
      (and
        (initialized ?production_entity)
        (has_crew ?production_entity)
        (procedure_available ?process_procedure)
      )
    :effect
      (and
        (assigned_procedure ?production_entity ?process_procedure)
        (not
          (procedure_available ?process_procedure)
        )
      )
  )
  (:action finalize_entity_configuration
    :parameters (?production_entity - production_entity ?process_procedure - process_procedure)
    :precondition
      (and
        (initialized ?production_entity)
        (has_crew ?production_entity)
        (assigned_procedure ?production_entity ?process_procedure)
        (not
          (configured_for_changeover ?production_entity)
        )
      )
    :effect (configured_for_changeover ?production_entity)
  )
  (:action unassign_process_procedure_from_entity
    :parameters (?production_entity - production_entity ?process_procedure - process_procedure)
    :precondition
      (and
        (assigned_procedure ?production_entity ?process_procedure)
      )
    :effect
      (and
        (procedure_available ?process_procedure)
        (not
          (assigned_procedure ?production_entity ?process_procedure)
        )
      )
  )
  (:action assign_equipment_to_entity
    :parameters (?production_entity - production_entity ?equipment_unit - equipment_unit)
    :precondition
      (and
        (configured_for_changeover ?production_entity)
        (equipment_available ?equipment_unit)
      )
    :effect
      (and
        (assigned_equipment ?production_entity ?equipment_unit)
        (not
          (equipment_available ?equipment_unit)
        )
      )
  )
  (:action unassign_equipment_from_entity
    :parameters (?production_entity - production_entity ?equipment_unit - equipment_unit)
    :precondition
      (and
        (assigned_equipment ?production_entity ?equipment_unit)
      )
    :effect
      (and
        (equipment_available ?equipment_unit)
        (not
          (assigned_equipment ?production_entity ?equipment_unit)
        )
      )
  )
  (:action assign_setup_kit_to_task
    :parameters (?changeover_task - changeover_task ?setup_kit - setup_kit)
    :precondition
      (and
        (configured_for_changeover ?changeover_task)
        (setup_kit_available ?setup_kit)
      )
    :effect
      (and
        (task_attached_setup_kit ?changeover_task ?setup_kit)
        (not
          (setup_kit_available ?setup_kit)
        )
      )
  )
  (:action release_setup_kit_from_task
    :parameters (?changeover_task - changeover_task ?setup_kit - setup_kit)
    :precondition
      (and
        (task_attached_setup_kit ?changeover_task ?setup_kit)
      )
    :effect
      (and
        (setup_kit_available ?setup_kit)
        (not
          (task_attached_setup_kit ?changeover_task ?setup_kit)
        )
      )
  )
  (:action assign_test_protocol_to_task
    :parameters (?changeover_task - changeover_task ?test_protocol - test_protocol)
    :precondition
      (and
        (configured_for_changeover ?changeover_task)
        (test_protocol_available ?test_protocol)
      )
    :effect
      (and
        (task_attached_test_protocol ?changeover_task ?test_protocol)
        (not
          (test_protocol_available ?test_protocol)
        )
      )
  )
  (:action unassign_test_protocol_from_task
    :parameters (?changeover_task - changeover_task ?test_protocol - test_protocol)
    :precondition
      (and
        (task_attached_test_protocol ?changeover_task ?test_protocol)
      )
    :effect
      (and
        (test_protocol_available ?test_protocol)
        (not
          (task_attached_test_protocol ?changeover_task ?test_protocol)
        )
      )
  )
  (:action prepare_origin_stage
    :parameters (?origin_line - origin_line ?origin_stage_state - origin_stage_state ?process_procedure - process_procedure)
    :precondition
      (and
        (configured_for_changeover ?origin_line)
        (assigned_procedure ?origin_line ?process_procedure)
        (origin_line_state_assigned ?origin_line ?origin_stage_state)
        (not
          (origin_stage_ready ?origin_stage_state)
        )
        (not
          (origin_stage_staged ?origin_stage_state)
        )
      )
    :effect (origin_stage_ready ?origin_stage_state)
  )
  (:action equip_origin_line
    :parameters (?origin_line - origin_line ?origin_stage_state - origin_stage_state ?equipment_unit - equipment_unit)
    :precondition
      (and
        (configured_for_changeover ?origin_line)
        (assigned_equipment ?origin_line ?equipment_unit)
        (origin_line_state_assigned ?origin_line ?origin_stage_state)
        (origin_stage_ready ?origin_stage_state)
        (not
          (origin_line_setup_completed ?origin_line)
        )
      )
    :effect
      (and
        (origin_line_setup_completed ?origin_line)
        (origin_line_ready ?origin_line)
      )
  )
  (:action allocate_consumable_to_origin_stage
    :parameters (?origin_line - origin_line ?origin_stage_state - origin_stage_state ?consumable_item - consumable_document)
    :precondition
      (and
        (configured_for_changeover ?origin_line)
        (origin_line_state_assigned ?origin_line ?origin_stage_state)
        (consumable_available ?consumable_item)
        (not
          (origin_line_setup_completed ?origin_line)
        )
      )
    :effect
      (and
        (origin_stage_staged ?origin_stage_state)
        (origin_line_setup_completed ?origin_line)
        (origin_consumable_allocated ?origin_line ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action complete_origin_stage_processing
    :parameters (?origin_line - origin_line ?origin_stage_state - origin_stage_state ?process_procedure - process_procedure ?consumable_item - consumable_document)
    :precondition
      (and
        (configured_for_changeover ?origin_line)
        (assigned_procedure ?origin_line ?process_procedure)
        (origin_line_state_assigned ?origin_line ?origin_stage_state)
        (origin_stage_staged ?origin_stage_state)
        (origin_consumable_allocated ?origin_line ?consumable_item)
        (not
          (origin_line_ready ?origin_line)
        )
      )
    :effect
      (and
        (origin_stage_ready ?origin_stage_state)
        (origin_line_ready ?origin_line)
        (consumable_available ?consumable_item)
        (not
          (origin_consumable_allocated ?origin_line ?consumable_item)
        )
      )
  )
  (:action prepare_destination_stage
    :parameters (?destination_line - destination_line ?destination_stage_state - destination_stage_state ?process_procedure - process_procedure)
    :precondition
      (and
        (configured_for_changeover ?destination_line)
        (assigned_procedure ?destination_line ?process_procedure)
        (destination_line_state_assigned ?destination_line ?destination_stage_state)
        (not
          (destination_stage_ready ?destination_stage_state)
        )
        (not
          (destination_stage_staged ?destination_stage_state)
        )
      )
    :effect (destination_stage_ready ?destination_stage_state)
  )
  (:action equip_destination_line
    :parameters (?destination_line - destination_line ?destination_stage_state - destination_stage_state ?equipment_unit - equipment_unit)
    :precondition
      (and
        (configured_for_changeover ?destination_line)
        (assigned_equipment ?destination_line ?equipment_unit)
        (destination_line_state_assigned ?destination_line ?destination_stage_state)
        (destination_stage_ready ?destination_stage_state)
        (not
          (destination_line_setup_completed ?destination_line)
        )
      )
    :effect
      (and
        (destination_line_setup_completed ?destination_line)
        (destination_line_ready ?destination_line)
      )
  )
  (:action allocate_consumable_to_destination_stage
    :parameters (?destination_line - destination_line ?destination_stage_state - destination_stage_state ?consumable_item - consumable_document)
    :precondition
      (and
        (configured_for_changeover ?destination_line)
        (destination_line_state_assigned ?destination_line ?destination_stage_state)
        (consumable_available ?consumable_item)
        (not
          (destination_line_setup_completed ?destination_line)
        )
      )
    :effect
      (and
        (destination_stage_staged ?destination_stage_state)
        (destination_line_setup_completed ?destination_line)
        (destination_consumable_allocated ?destination_line ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action complete_destination_stage_processing
    :parameters (?destination_line - destination_line ?destination_stage_state - destination_stage_state ?process_procedure - process_procedure ?consumable_item - consumable_document)
    :precondition
      (and
        (configured_for_changeover ?destination_line)
        (assigned_procedure ?destination_line ?process_procedure)
        (destination_line_state_assigned ?destination_line ?destination_stage_state)
        (destination_stage_staged ?destination_stage_state)
        (destination_consumable_allocated ?destination_line ?consumable_item)
        (not
          (destination_line_ready ?destination_line)
        )
      )
    :effect
      (and
        (destination_stage_ready ?destination_stage_state)
        (destination_line_ready ?destination_line)
        (consumable_available ?consumable_item)
        (not
          (destination_consumable_allocated ?destination_line ?consumable_item)
        )
      )
  )
  (:action create_changeover_record_both_ready
    :parameters (?origin_line - origin_line ?destination_line - destination_line ?origin_stage_state - origin_stage_state ?destination_stage_state - destination_stage_state ?changeover_record - changeover_record)
    :precondition
      (and
        (origin_line_setup_completed ?origin_line)
        (destination_line_setup_completed ?destination_line)
        (origin_line_state_assigned ?origin_line ?origin_stage_state)
        (destination_line_state_assigned ?destination_line ?destination_stage_state)
        (origin_stage_ready ?origin_stage_state)
        (destination_stage_ready ?destination_stage_state)
        (origin_line_ready ?origin_line)
        (destination_line_ready ?destination_line)
        (record_draft_available ?changeover_record)
      )
    :effect
      (and
        (record_initiated ?changeover_record)
        (record_linked_origin_stage ?changeover_record ?origin_stage_state)
        (record_linked_destination_stage ?changeover_record ?destination_stage_state)
        (not
          (record_draft_available ?changeover_record)
        )
      )
  )
  (:action create_changeover_record_origin_staged
    :parameters (?origin_line - origin_line ?destination_line - destination_line ?origin_stage_state - origin_stage_state ?destination_stage_state - destination_stage_state ?changeover_record - changeover_record)
    :precondition
      (and
        (origin_line_setup_completed ?origin_line)
        (destination_line_setup_completed ?destination_line)
        (origin_line_state_assigned ?origin_line ?origin_stage_state)
        (destination_line_state_assigned ?destination_line ?destination_stage_state)
        (origin_stage_staged ?origin_stage_state)
        (destination_stage_ready ?destination_stage_state)
        (not
          (origin_line_ready ?origin_line)
        )
        (destination_line_ready ?destination_line)
        (record_draft_available ?changeover_record)
      )
    :effect
      (and
        (record_initiated ?changeover_record)
        (record_linked_origin_stage ?changeover_record ?origin_stage_state)
        (record_linked_destination_stage ?changeover_record ?destination_stage_state)
        (record_requires_qualification ?changeover_record)
        (not
          (record_draft_available ?changeover_record)
        )
      )
  )
  (:action create_changeover_record_destination_staged
    :parameters (?origin_line - origin_line ?destination_line - destination_line ?origin_stage_state - origin_stage_state ?destination_stage_state - destination_stage_state ?changeover_record - changeover_record)
    :precondition
      (and
        (origin_line_setup_completed ?origin_line)
        (destination_line_setup_completed ?destination_line)
        (origin_line_state_assigned ?origin_line ?origin_stage_state)
        (destination_line_state_assigned ?destination_line ?destination_stage_state)
        (origin_stage_ready ?origin_stage_state)
        (destination_stage_staged ?destination_stage_state)
        (origin_line_ready ?origin_line)
        (not
          (destination_line_ready ?destination_line)
        )
        (record_draft_available ?changeover_record)
      )
    :effect
      (and
        (record_initiated ?changeover_record)
        (record_linked_origin_stage ?changeover_record ?origin_stage_state)
        (record_linked_destination_stage ?changeover_record ?destination_stage_state)
        (record_requires_certificate ?changeover_record)
        (not
          (record_draft_available ?changeover_record)
        )
      )
  )
  (:action create_changeover_record_both_staged
    :parameters (?origin_line - origin_line ?destination_line - destination_line ?origin_stage_state - origin_stage_state ?destination_stage_state - destination_stage_state ?changeover_record - changeover_record)
    :precondition
      (and
        (origin_line_setup_completed ?origin_line)
        (destination_line_setup_completed ?destination_line)
        (origin_line_state_assigned ?origin_line ?origin_stage_state)
        (destination_line_state_assigned ?destination_line ?destination_stage_state)
        (origin_stage_staged ?origin_stage_state)
        (destination_stage_staged ?destination_stage_state)
        (not
          (origin_line_ready ?origin_line)
        )
        (not
          (destination_line_ready ?destination_line)
        )
        (record_draft_available ?changeover_record)
      )
    :effect
      (and
        (record_initiated ?changeover_record)
        (record_linked_origin_stage ?changeover_record ?origin_stage_state)
        (record_linked_destination_stage ?changeover_record ?destination_stage_state)
        (record_requires_qualification ?changeover_record)
        (record_requires_certificate ?changeover_record)
        (not
          (record_draft_available ?changeover_record)
        )
      )
  )
  (:action mark_record_ready_for_checklist
    :parameters (?changeover_record - changeover_record ?origin_line - origin_line ?process_procedure - process_procedure)
    :precondition
      (and
        (record_initiated ?changeover_record)
        (origin_line_setup_completed ?origin_line)
        (assigned_procedure ?origin_line ?process_procedure)
        (not
          (record_ready_for_checklist ?changeover_record)
        )
      )
    :effect (record_ready_for_checklist ?changeover_record)
  )
  (:action complete_and_attach_checklist
    :parameters (?changeover_task - changeover_task ?quality_checklist - quality_checklist ?changeover_record - changeover_record)
    :precondition
      (and
        (configured_for_changeover ?changeover_task)
        (task_linked_record ?changeover_task ?changeover_record)
        (task_has_checklist ?changeover_task ?quality_checklist)
        (checklist_available ?quality_checklist)
        (record_initiated ?changeover_record)
        (record_ready_for_checklist ?changeover_record)
        (not
          (checklist_completed ?quality_checklist)
        )
      )
    :effect
      (and
        (checklist_completed ?quality_checklist)
        (checklist_attached_to_record ?quality_checklist ?changeover_record)
        (not
          (checklist_available ?quality_checklist)
        )
      )
  )
  (:action assemble_task_documentation
    :parameters (?changeover_task - changeover_task ?quality_checklist - quality_checklist ?changeover_record - changeover_record ?process_procedure - process_procedure)
    :precondition
      (and
        (configured_for_changeover ?changeover_task)
        (task_has_checklist ?changeover_task ?quality_checklist)
        (checklist_completed ?quality_checklist)
        (checklist_attached_to_record ?quality_checklist ?changeover_record)
        (assigned_procedure ?changeover_task ?process_procedure)
        (not
          (record_requires_qualification ?changeover_record)
        )
        (not
          (task_documentation_assembled ?changeover_task)
        )
      )
    :effect (task_documentation_assembled ?changeover_task)
  )
  (:action attach_qualification_document_to_task
    :parameters (?changeover_task - changeover_task ?qualification_document - qualification_document)
    :precondition
      (and
        (configured_for_changeover ?changeover_task)
        (qualification_document_available ?qualification_document)
        (not
          (task_has_qualification_document ?changeover_task)
        )
      )
    :effect
      (and
        (task_has_qualification_document ?changeover_task)
        (task_qualification_document_link ?changeover_task ?qualification_document)
        (not
          (qualification_document_available ?qualification_document)
        )
      )
  )
  (:action apply_qualification_document_and_verify
    :parameters (?changeover_task - changeover_task ?quality_checklist - quality_checklist ?changeover_record - changeover_record ?process_procedure - process_procedure ?qualification_document - qualification_document)
    :precondition
      (and
        (configured_for_changeover ?changeover_task)
        (task_has_checklist ?changeover_task ?quality_checklist)
        (checklist_completed ?quality_checklist)
        (checklist_attached_to_record ?quality_checklist ?changeover_record)
        (assigned_procedure ?changeover_task ?process_procedure)
        (record_requires_qualification ?changeover_record)
        (task_has_qualification_document ?changeover_task)
        (task_qualification_document_link ?changeover_task ?qualification_document)
        (not
          (task_documentation_assembled ?changeover_task)
        )
      )
    :effect
      (and
        (task_documentation_assembled ?changeover_task)
        (qualification_verified ?changeover_task)
      )
  )
  (:action attach_certifications_to_task
    :parameters (?changeover_task - changeover_task ?setup_kit - setup_kit ?equipment_unit - equipment_unit ?quality_checklist - quality_checklist ?changeover_record - changeover_record)
    :precondition
      (and
        (task_documentation_assembled ?changeover_task)
        (task_attached_setup_kit ?changeover_task ?setup_kit)
        (assigned_equipment ?changeover_task ?equipment_unit)
        (task_has_checklist ?changeover_task ?quality_checklist)
        (checklist_attached_to_record ?quality_checklist ?changeover_record)
        (not
          (record_requires_certificate ?changeover_record)
        )
        (not
          (task_certifications_attached ?changeover_task)
        )
      )
    :effect (task_certifications_attached ?changeover_task)
  )
  (:action attach_additional_certifications_to_task
    :parameters (?changeover_task - changeover_task ?setup_kit - setup_kit ?equipment_unit - equipment_unit ?quality_checklist - quality_checklist ?changeover_record - changeover_record)
    :precondition
      (and
        (task_documentation_assembled ?changeover_task)
        (task_attached_setup_kit ?changeover_task ?setup_kit)
        (assigned_equipment ?changeover_task ?equipment_unit)
        (task_has_checklist ?changeover_task ?quality_checklist)
        (checklist_attached_to_record ?quality_checklist ?changeover_record)
        (record_requires_certificate ?changeover_record)
        (not
          (task_certifications_attached ?changeover_task)
        )
      )
    :effect (task_certifications_attached ?changeover_task)
  )
  (:action execute_test_protocol
    :parameters (?changeover_task - changeover_task ?test_protocol - test_protocol ?quality_checklist - quality_checklist ?changeover_record - changeover_record)
    :precondition
      (and
        (task_certifications_attached ?changeover_task)
        (task_attached_test_protocol ?changeover_task ?test_protocol)
        (task_has_checklist ?changeover_task ?quality_checklist)
        (checklist_attached_to_record ?quality_checklist ?changeover_record)
        (not
          (record_requires_qualification ?changeover_record)
        )
        (not
          (record_requires_certificate ?changeover_record)
        )
        (not
          (inspection_performed ?changeover_task)
        )
      )
    :effect (inspection_performed ?changeover_task)
  )
  (:action execute_test_protocol_with_qualification_review
    :parameters (?changeover_task - changeover_task ?test_protocol - test_protocol ?quality_checklist - quality_checklist ?changeover_record - changeover_record)
    :precondition
      (and
        (task_certifications_attached ?changeover_task)
        (task_attached_test_protocol ?changeover_task ?test_protocol)
        (task_has_checklist ?changeover_task ?quality_checklist)
        (checklist_attached_to_record ?quality_checklist ?changeover_record)
        (record_requires_qualification ?changeover_record)
        (not
          (record_requires_certificate ?changeover_record)
        )
        (not
          (inspection_performed ?changeover_task)
        )
      )
    :effect
      (and
        (inspection_performed ?changeover_task)
        (inspection_requires_quality_approval ?changeover_task)
      )
  )
  (:action execute_test_protocol_with_certificate_review
    :parameters (?changeover_task - changeover_task ?test_protocol - test_protocol ?quality_checklist - quality_checklist ?changeover_record - changeover_record)
    :precondition
      (and
        (task_certifications_attached ?changeover_task)
        (task_attached_test_protocol ?changeover_task ?test_protocol)
        (task_has_checklist ?changeover_task ?quality_checklist)
        (checklist_attached_to_record ?quality_checklist ?changeover_record)
        (not
          (record_requires_qualification ?changeover_record)
        )
        (record_requires_certificate ?changeover_record)
        (not
          (inspection_performed ?changeover_task)
        )
      )
    :effect
      (and
        (inspection_performed ?changeover_task)
        (inspection_requires_quality_approval ?changeover_task)
      )
  )
  (:action execute_test_protocol_with_qualification_and_certificate_review
    :parameters (?changeover_task - changeover_task ?test_protocol - test_protocol ?quality_checklist - quality_checklist ?changeover_record - changeover_record)
    :precondition
      (and
        (task_certifications_attached ?changeover_task)
        (task_attached_test_protocol ?changeover_task ?test_protocol)
        (task_has_checklist ?changeover_task ?quality_checklist)
        (checklist_attached_to_record ?quality_checklist ?changeover_record)
        (record_requires_qualification ?changeover_record)
        (record_requires_certificate ?changeover_record)
        (not
          (inspection_performed ?changeover_task)
        )
      )
    :effect
      (and
        (inspection_performed ?changeover_task)
        (inspection_requires_quality_approval ?changeover_task)
      )
  )
  (:action finalize_task_signoff
    :parameters (?changeover_task - changeover_task)
    :precondition
      (and
        (inspection_performed ?changeover_task)
        (not
          (inspection_requires_quality_approval ?changeover_task)
        )
        (not
          (task_signoff_recorded ?changeover_task)
        )
      )
    :effect
      (and
        (task_signoff_recorded ?changeover_task)
        (ready_for_release ?changeover_task)
      )
  )
  (:action apply_quality_approval_token_to_task
    :parameters (?changeover_task - changeover_task ?quality_approval_token - quality_approval_token)
    :precondition
      (and
        (inspection_performed ?changeover_task)
        (inspection_requires_quality_approval ?changeover_task)
        (approval_token_available ?quality_approval_token)
      )
    :effect
      (and
        (task_attached_approval_token ?changeover_task ?quality_approval_token)
        (not
          (approval_token_available ?quality_approval_token)
        )
      )
  )
  (:action prepare_task_for_final_signoff
    :parameters (?changeover_task - changeover_task ?origin_line - origin_line ?destination_line - destination_line ?process_procedure - process_procedure ?quality_approval_token - quality_approval_token)
    :precondition
      (and
        (inspection_performed ?changeover_task)
        (inspection_requires_quality_approval ?changeover_task)
        (task_attached_approval_token ?changeover_task ?quality_approval_token)
        (task_assigned_origin_line ?changeover_task ?origin_line)
        (task_assigned_destination_line ?changeover_task ?destination_line)
        (origin_line_ready ?origin_line)
        (destination_line_ready ?destination_line)
        (assigned_procedure ?changeover_task ?process_procedure)
        (not
          (task_ready_for_signoff ?changeover_task)
        )
      )
    :effect (task_ready_for_signoff ?changeover_task)
  )
  (:action complete_task_signoff_after_finalization
    :parameters (?changeover_task - changeover_task)
    :precondition
      (and
        (inspection_performed ?changeover_task)
        (task_ready_for_signoff ?changeover_task)
        (not
          (task_signoff_recorded ?changeover_task)
        )
      )
    :effect
      (and
        (task_signoff_recorded ?changeover_task)
        (ready_for_release ?changeover_task)
      )
  )
  (:action attach_certificate_to_task
    :parameters (?changeover_task - changeover_task ?certificate - certificate ?process_procedure - process_procedure)
    :precondition
      (and
        (configured_for_changeover ?changeover_task)
        (assigned_procedure ?changeover_task ?process_procedure)
        (certificate_available ?certificate)
        (task_certificate_link ?changeover_task ?certificate)
        (not
          (task_certificate_attached ?changeover_task)
        )
      )
    :effect
      (and
        (task_certificate_attached ?changeover_task)
        (not
          (certificate_available ?certificate)
        )
      )
  )
  (:action verify_certificate_with_equipment
    :parameters (?changeover_task - changeover_task ?equipment_unit - equipment_unit)
    :precondition
      (and
        (task_certificate_attached ?changeover_task)
        (assigned_equipment ?changeover_task ?equipment_unit)
        (not
          (certificate_reviewed ?changeover_task)
        )
      )
    :effect (certificate_reviewed ?changeover_task)
  )
  (:action approve_certificate_with_test_protocol
    :parameters (?changeover_task - changeover_task ?test_protocol - test_protocol)
    :precondition
      (and
        (certificate_reviewed ?changeover_task)
        (task_attached_test_protocol ?changeover_task ?test_protocol)
        (not
          (certificate_approval_passed ?changeover_task)
        )
      )
    :effect (certificate_approval_passed ?changeover_task)
  )
  (:action finalize_task_signoff_after_certificate_approval
    :parameters (?changeover_task - changeover_task)
    :precondition
      (and
        (certificate_approval_passed ?changeover_task)
        (not
          (task_signoff_recorded ?changeover_task)
        )
      )
    :effect
      (and
        (task_signoff_recorded ?changeover_task)
        (ready_for_release ?changeover_task)
      )
  )
  (:action release_origin_line
    :parameters (?origin_line - origin_line ?changeover_record - changeover_record)
    :precondition
      (and
        (origin_line_setup_completed ?origin_line)
        (origin_line_ready ?origin_line)
        (record_initiated ?changeover_record)
        (record_ready_for_checklist ?changeover_record)
        (not
          (ready_for_release ?origin_line)
        )
      )
    :effect (ready_for_release ?origin_line)
  )
  (:action release_destination_line
    :parameters (?destination_line - destination_line ?changeover_record - changeover_record)
    :precondition
      (and
        (destination_line_setup_completed ?destination_line)
        (destination_line_ready ?destination_line)
        (record_initiated ?changeover_record)
        (record_ready_for_checklist ?changeover_record)
        (not
          (ready_for_release ?destination_line)
        )
      )
    :effect (ready_for_release ?destination_line)
  )
  (:action apply_release_document_to_entity
    :parameters (?production_entity - production_entity ?release_document - release_document ?process_procedure - process_procedure)
    :precondition
      (and
        (ready_for_release ?production_entity)
        (assigned_procedure ?production_entity ?process_procedure)
        (release_document_available ?release_document)
        (not
          (release_applied ?production_entity)
        )
      )
    :effect
      (and
        (release_applied ?production_entity)
        (attached_release_document ?production_entity ?release_document)
        (not
          (release_document_available ?release_document)
        )
      )
  )
  (:action finalize_release_for_origin_line
    :parameters (?origin_line - origin_line ?operator_crew - operator_crew ?release_document - release_document)
    :precondition
      (and
        (release_applied ?origin_line)
        (assigned_crew ?origin_line ?operator_crew)
        (attached_release_document ?origin_line ?release_document)
        (not
          (released ?origin_line)
        )
      )
    :effect
      (and
        (released ?origin_line)
        (crew_available ?operator_crew)
        (release_document_available ?release_document)
      )
  )
  (:action finalize_release_for_destination_line
    :parameters (?destination_line - destination_line ?operator_crew - operator_crew ?release_document - release_document)
    :precondition
      (and
        (release_applied ?destination_line)
        (assigned_crew ?destination_line ?operator_crew)
        (attached_release_document ?destination_line ?release_document)
        (not
          (released ?destination_line)
        )
      )
    :effect
      (and
        (released ?destination_line)
        (crew_available ?operator_crew)
        (release_document_available ?release_document)
      )
  )
  (:action finalize_release_for_task
    :parameters (?changeover_task - changeover_task ?operator_crew - operator_crew ?release_document - release_document)
    :precondition
      (and
        (release_applied ?changeover_task)
        (assigned_crew ?changeover_task ?operator_crew)
        (attached_release_document ?changeover_task ?release_document)
        (not
          (released ?changeover_task)
        )
      )
    :effect
      (and
        (released ?changeover_task)
        (crew_available ?operator_crew)
        (release_document_available ?release_document)
      )
  )
)

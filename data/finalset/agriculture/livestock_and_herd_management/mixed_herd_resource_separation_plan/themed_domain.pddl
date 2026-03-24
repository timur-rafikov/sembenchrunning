(define (domain mixed_herd_resource_separation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource - object supply_item - object facility_asset - object abstract_holder - object separation_subject - abstract_holder resource_token - operational_resource clinical_procedure - operational_resource handler - operational_resource authorization_document - operational_resource service_slot - operational_resource schedule_slot - operational_resource medication - operational_resource vaccine - operational_resource consumable_supply - supply_item container_label - supply_item consent_form - supply_item facility_origin - facility_asset facility_destination - facility_asset holding_batch - facility_asset subgroup_type - separation_subject plan_entity - separation_subject source_subgroup - subgroup_type target_subgroup - subgroup_type separation_plan - plan_entity)
  (:predicates
    (entity_registered ?entity - separation_subject)
    (cleared_for_processing ?entity - separation_subject)
    (has_resource_token ?entity - separation_subject)
    (separation_completed ?entity - separation_subject)
    (approved_for_execution ?entity - separation_subject)
    (procedure_completed ?entity - separation_subject)
    (resource_available ?resource_token - resource_token)
    (resource_assigned_to_entity ?entity - separation_subject ?resource_token - resource_token)
    (procedure_available ?clinical_procedure - clinical_procedure)
    (procedure_assigned_to_entity ?entity - separation_subject ?clinical_procedure - clinical_procedure)
    (handler_available ?handler - handler)
    (handler_assigned_to_entity ?entity - separation_subject ?handler - handler)
    (supply_available ?consumable_supply - consumable_supply)
    (supply_assigned_to_source ?source_subgroup - source_subgroup ?consumable_supply - consumable_supply)
    (supply_assigned_to_target ?target_subgroup - target_subgroup ?consumable_supply - consumable_supply)
    (subgroup_assigned_origin ?source_subgroup - source_subgroup ?facility_origin - facility_origin)
    (origin_ready ?facility_origin - facility_origin)
    (origin_supply_applied ?facility_origin - facility_origin)
    (source_subgroup_ready ?source_subgroup - source_subgroup)
    (subgroup_assigned_destination ?target_subgroup - target_subgroup ?facility_destination - facility_destination)
    (destination_ready ?facility_destination - facility_destination)
    (destination_supply_applied ?facility_destination - facility_destination)
    (target_subgroup_ready ?target_subgroup - target_subgroup)
    (batch_available ?holding_batch - holding_batch)
    (batch_allocated ?holding_batch - holding_batch)
    (batch_linked_to_origin ?holding_batch - holding_batch ?facility_origin - facility_origin)
    (batch_linked_to_destination ?holding_batch - holding_batch ?facility_destination - facility_destination)
    (batch_origin_supplied ?holding_batch - holding_batch)
    (batch_destination_supplied ?holding_batch - holding_batch)
    (batch_ready_for_labeling ?holding_batch - holding_batch)
    (plan_associated_source_subgroup ?separation_plan - separation_plan ?source_subgroup - source_subgroup)
    (plan_associated_target_subgroup ?separation_plan - separation_plan ?target_subgroup - target_subgroup)
    (plan_associated_batch ?separation_plan - separation_plan ?holding_batch - holding_batch)
    (container_label_available ?container_label - container_label)
    (plan_has_container_label ?separation_plan - separation_plan ?container_label - container_label)
    (container_label_attached ?container_label - container_label)
    (container_label_linked_to_batch ?container_label - container_label ?holding_batch - holding_batch)
    (plan_label_and_supply_confirmed ?separation_plan - separation_plan)
    (plan_medication_allocated ?separation_plan - separation_plan)
    (plan_clinical_confirmed ?separation_plan - separation_plan)
    (plan_authorization_attached ?separation_plan - separation_plan)
    (plan_authorization_validated ?separation_plan - separation_plan)
    (plan_requires_service_slot ?separation_plan - separation_plan)
    (plan_execution_precheck_complete ?separation_plan - separation_plan)
    (consent_form_available ?consent_form - consent_form)
    (plan_has_consent_form ?separation_plan - separation_plan ?consent_form - consent_form)
    (plan_consent_attached ?separation_plan - separation_plan)
    (plan_handler_confirmed ?separation_plan - separation_plan)
    (plan_vaccine_verified ?separation_plan - separation_plan)
    (authorization_document_available ?authorization_document - authorization_document)
    (plan_has_authorization_document ?separation_plan - separation_plan ?authorization_document - authorization_document)
    (service_slot_available ?service_slot - service_slot)
    (plan_allocated_service_slot ?separation_plan - separation_plan ?service_slot - service_slot)
    (medication_available ?medication - medication)
    (medication_reserved_for_plan ?separation_plan - separation_plan ?medication - medication)
    (vaccine_available ?vaccine - vaccine)
    (vaccine_reserved_for_plan ?separation_plan - separation_plan ?vaccine - vaccine)
    (schedule_slot_available ?schedule_slot - schedule_slot)
    (entity_scheduled_in_slot ?entity - separation_subject ?schedule_slot - schedule_slot)
    (source_subgroup_supply_attached ?source_subgroup - source_subgroup)
    (target_subgroup_supply_attached ?target_subgroup - target_subgroup)
    (plan_finalized ?separation_plan - separation_plan)
  )
  (:action register_entity
    :parameters (?entity - separation_subject)
    :precondition
      (and
        (not
          (entity_registered ?entity)
        )
        (not
          (separation_completed ?entity)
        )
      )
    :effect (entity_registered ?entity)
  )
  (:action assign_resource_token_to_entity
    :parameters (?entity - separation_subject ?resource_token - resource_token)
    :precondition
      (and
        (entity_registered ?entity)
        (not
          (has_resource_token ?entity)
        )
        (resource_available ?resource_token)
      )
    :effect
      (and
        (has_resource_token ?entity)
        (resource_assigned_to_entity ?entity ?resource_token)
        (not
          (resource_available ?resource_token)
        )
      )
  )
  (:action assign_procedure_to_entity
    :parameters (?entity - separation_subject ?clinical_procedure - clinical_procedure)
    :precondition
      (and
        (entity_registered ?entity)
        (has_resource_token ?entity)
        (procedure_available ?clinical_procedure)
      )
    :effect
      (and
        (procedure_assigned_to_entity ?entity ?clinical_procedure)
        (not
          (procedure_available ?clinical_procedure)
        )
      )
  )
  (:action confirm_entity_clearance
    :parameters (?entity - separation_subject ?clinical_procedure - clinical_procedure)
    :precondition
      (and
        (entity_registered ?entity)
        (has_resource_token ?entity)
        (procedure_assigned_to_entity ?entity ?clinical_procedure)
        (not
          (cleared_for_processing ?entity)
        )
      )
    :effect (cleared_for_processing ?entity)
  )
  (:action unassign_procedure_from_entity
    :parameters (?entity - separation_subject ?clinical_procedure - clinical_procedure)
    :precondition
      (and
        (procedure_assigned_to_entity ?entity ?clinical_procedure)
      )
    :effect
      (and
        (procedure_available ?clinical_procedure)
        (not
          (procedure_assigned_to_entity ?entity ?clinical_procedure)
        )
      )
  )
  (:action assign_handler_to_entity
    :parameters (?entity - separation_subject ?handler - handler)
    :precondition
      (and
        (cleared_for_processing ?entity)
        (handler_available ?handler)
      )
    :effect
      (and
        (handler_assigned_to_entity ?entity ?handler)
        (not
          (handler_available ?handler)
        )
      )
  )
  (:action unassign_handler_from_entity
    :parameters (?entity - separation_subject ?handler - handler)
    :precondition
      (and
        (handler_assigned_to_entity ?entity ?handler)
      )
    :effect
      (and
        (handler_available ?handler)
        (not
          (handler_assigned_to_entity ?entity ?handler)
        )
      )
  )
  (:action reserve_medication_for_plan
    :parameters (?separation_plan - separation_plan ?medication - medication)
    :precondition
      (and
        (cleared_for_processing ?separation_plan)
        (medication_available ?medication)
      )
    :effect
      (and
        (medication_reserved_for_plan ?separation_plan ?medication)
        (not
          (medication_available ?medication)
        )
      )
  )
  (:action release_medication_from_plan
    :parameters (?separation_plan - separation_plan ?medication - medication)
    :precondition
      (and
        (medication_reserved_for_plan ?separation_plan ?medication)
      )
    :effect
      (and
        (medication_available ?medication)
        (not
          (medication_reserved_for_plan ?separation_plan ?medication)
        )
      )
  )
  (:action reserve_vaccine_for_plan
    :parameters (?separation_plan - separation_plan ?vaccine - vaccine)
    :precondition
      (and
        (cleared_for_processing ?separation_plan)
        (vaccine_available ?vaccine)
      )
    :effect
      (and
        (vaccine_reserved_for_plan ?separation_plan ?vaccine)
        (not
          (vaccine_available ?vaccine)
        )
      )
  )
  (:action release_vaccine_from_plan
    :parameters (?separation_plan - separation_plan ?vaccine - vaccine)
    :precondition
      (and
        (vaccine_reserved_for_plan ?separation_plan ?vaccine)
      )
    :effect
      (and
        (vaccine_available ?vaccine)
        (not
          (vaccine_reserved_for_plan ?separation_plan ?vaccine)
        )
      )
  )
  (:action prepare_origin_facility_for_subgroup
    :parameters (?source_subgroup - source_subgroup ?facility_origin - facility_origin ?clinical_procedure - clinical_procedure)
    :precondition
      (and
        (cleared_for_processing ?source_subgroup)
        (procedure_assigned_to_entity ?source_subgroup ?clinical_procedure)
        (subgroup_assigned_origin ?source_subgroup ?facility_origin)
        (not
          (origin_ready ?facility_origin)
        )
        (not
          (origin_supply_applied ?facility_origin)
        )
      )
    :effect (origin_ready ?facility_origin)
  )
  (:action confirm_source_subgroup_preparation
    :parameters (?source_subgroup - source_subgroup ?facility_origin - facility_origin ?handler - handler)
    :precondition
      (and
        (cleared_for_processing ?source_subgroup)
        (handler_assigned_to_entity ?source_subgroup ?handler)
        (subgroup_assigned_origin ?source_subgroup ?facility_origin)
        (origin_ready ?facility_origin)
        (not
          (source_subgroup_supply_attached ?source_subgroup)
        )
      )
    :effect
      (and
        (source_subgroup_supply_attached ?source_subgroup)
        (source_subgroup_ready ?source_subgroup)
      )
  )
  (:action apply_supply_to_source_subgroup
    :parameters (?source_subgroup - source_subgroup ?facility_origin - facility_origin ?consumable_supply - consumable_supply)
    :precondition
      (and
        (cleared_for_processing ?source_subgroup)
        (subgroup_assigned_origin ?source_subgroup ?facility_origin)
        (supply_available ?consumable_supply)
        (not
          (source_subgroup_supply_attached ?source_subgroup)
        )
      )
    :effect
      (and
        (origin_supply_applied ?facility_origin)
        (source_subgroup_supply_attached ?source_subgroup)
        (supply_assigned_to_source ?source_subgroup ?consumable_supply)
        (not
          (supply_available ?consumable_supply)
        )
      )
  )
  (:action finalize_source_subgroup_supply_application
    :parameters (?source_subgroup - source_subgroup ?facility_origin - facility_origin ?clinical_procedure - clinical_procedure ?consumable_supply - consumable_supply)
    :precondition
      (and
        (cleared_for_processing ?source_subgroup)
        (procedure_assigned_to_entity ?source_subgroup ?clinical_procedure)
        (subgroup_assigned_origin ?source_subgroup ?facility_origin)
        (origin_supply_applied ?facility_origin)
        (supply_assigned_to_source ?source_subgroup ?consumable_supply)
        (not
          (source_subgroup_ready ?source_subgroup)
        )
      )
    :effect
      (and
        (origin_ready ?facility_origin)
        (source_subgroup_ready ?source_subgroup)
        (supply_available ?consumable_supply)
        (not
          (supply_assigned_to_source ?source_subgroup ?consumable_supply)
        )
      )
  )
  (:action prepare_destination_facility_for_subgroup
    :parameters (?target_subgroup - target_subgroup ?facility_destination - facility_destination ?clinical_procedure - clinical_procedure)
    :precondition
      (and
        (cleared_for_processing ?target_subgroup)
        (procedure_assigned_to_entity ?target_subgroup ?clinical_procedure)
        (subgroup_assigned_destination ?target_subgroup ?facility_destination)
        (not
          (destination_ready ?facility_destination)
        )
        (not
          (destination_supply_applied ?facility_destination)
        )
      )
    :effect (destination_ready ?facility_destination)
  )
  (:action confirm_target_subgroup_preparation
    :parameters (?target_subgroup - target_subgroup ?facility_destination - facility_destination ?handler - handler)
    :precondition
      (and
        (cleared_for_processing ?target_subgroup)
        (handler_assigned_to_entity ?target_subgroup ?handler)
        (subgroup_assigned_destination ?target_subgroup ?facility_destination)
        (destination_ready ?facility_destination)
        (not
          (target_subgroup_supply_attached ?target_subgroup)
        )
      )
    :effect
      (and
        (target_subgroup_supply_attached ?target_subgroup)
        (target_subgroup_ready ?target_subgroup)
      )
  )
  (:action apply_supply_to_target_subgroup
    :parameters (?target_subgroup - target_subgroup ?facility_destination - facility_destination ?consumable_supply - consumable_supply)
    :precondition
      (and
        (cleared_for_processing ?target_subgroup)
        (subgroup_assigned_destination ?target_subgroup ?facility_destination)
        (supply_available ?consumable_supply)
        (not
          (target_subgroup_supply_attached ?target_subgroup)
        )
      )
    :effect
      (and
        (destination_supply_applied ?facility_destination)
        (target_subgroup_supply_attached ?target_subgroup)
        (supply_assigned_to_target ?target_subgroup ?consumable_supply)
        (not
          (supply_available ?consumable_supply)
        )
      )
  )
  (:action finalize_target_subgroup_supply_application
    :parameters (?target_subgroup - target_subgroup ?facility_destination - facility_destination ?clinical_procedure - clinical_procedure ?consumable_supply - consumable_supply)
    :precondition
      (and
        (cleared_for_processing ?target_subgroup)
        (procedure_assigned_to_entity ?target_subgroup ?clinical_procedure)
        (subgroup_assigned_destination ?target_subgroup ?facility_destination)
        (destination_supply_applied ?facility_destination)
        (supply_assigned_to_target ?target_subgroup ?consumable_supply)
        (not
          (target_subgroup_ready ?target_subgroup)
        )
      )
    :effect
      (and
        (destination_ready ?facility_destination)
        (target_subgroup_ready ?target_subgroup)
        (supply_available ?consumable_supply)
        (not
          (supply_assigned_to_target ?target_subgroup ?consumable_supply)
        )
      )
  )
  (:action create_and_allocate_holding_batch
    :parameters (?source_subgroup - source_subgroup ?target_subgroup - target_subgroup ?facility_origin - facility_origin ?facility_destination - facility_destination ?holding_batch - holding_batch)
    :precondition
      (and
        (source_subgroup_supply_attached ?source_subgroup)
        (target_subgroup_supply_attached ?target_subgroup)
        (subgroup_assigned_origin ?source_subgroup ?facility_origin)
        (subgroup_assigned_destination ?target_subgroup ?facility_destination)
        (origin_ready ?facility_origin)
        (destination_ready ?facility_destination)
        (source_subgroup_ready ?source_subgroup)
        (target_subgroup_ready ?target_subgroup)
        (batch_available ?holding_batch)
      )
    :effect
      (and
        (batch_allocated ?holding_batch)
        (batch_linked_to_origin ?holding_batch ?facility_origin)
        (batch_linked_to_destination ?holding_batch ?facility_destination)
        (not
          (batch_available ?holding_batch)
        )
      )
  )
  (:action create_and_allocate_holding_batch_origin_supplied
    :parameters (?source_subgroup - source_subgroup ?target_subgroup - target_subgroup ?facility_origin - facility_origin ?facility_destination - facility_destination ?holding_batch - holding_batch)
    :precondition
      (and
        (source_subgroup_supply_attached ?source_subgroup)
        (target_subgroup_supply_attached ?target_subgroup)
        (subgroup_assigned_origin ?source_subgroup ?facility_origin)
        (subgroup_assigned_destination ?target_subgroup ?facility_destination)
        (origin_supply_applied ?facility_origin)
        (destination_ready ?facility_destination)
        (not
          (source_subgroup_ready ?source_subgroup)
        )
        (target_subgroup_ready ?target_subgroup)
        (batch_available ?holding_batch)
      )
    :effect
      (and
        (batch_allocated ?holding_batch)
        (batch_linked_to_origin ?holding_batch ?facility_origin)
        (batch_linked_to_destination ?holding_batch ?facility_destination)
        (batch_origin_supplied ?holding_batch)
        (not
          (batch_available ?holding_batch)
        )
      )
  )
  (:action create_and_allocate_holding_batch_destination_supplied
    :parameters (?source_subgroup - source_subgroup ?target_subgroup - target_subgroup ?facility_origin - facility_origin ?facility_destination - facility_destination ?holding_batch - holding_batch)
    :precondition
      (and
        (source_subgroup_supply_attached ?source_subgroup)
        (target_subgroup_supply_attached ?target_subgroup)
        (subgroup_assigned_origin ?source_subgroup ?facility_origin)
        (subgroup_assigned_destination ?target_subgroup ?facility_destination)
        (origin_ready ?facility_origin)
        (destination_supply_applied ?facility_destination)
        (source_subgroup_ready ?source_subgroup)
        (not
          (target_subgroup_ready ?target_subgroup)
        )
        (batch_available ?holding_batch)
      )
    :effect
      (and
        (batch_allocated ?holding_batch)
        (batch_linked_to_origin ?holding_batch ?facility_origin)
        (batch_linked_to_destination ?holding_batch ?facility_destination)
        (batch_destination_supplied ?holding_batch)
        (not
          (batch_available ?holding_batch)
        )
      )
  )
  (:action create_and_allocate_holding_batch_with_both_supplies
    :parameters (?source_subgroup - source_subgroup ?target_subgroup - target_subgroup ?facility_origin - facility_origin ?facility_destination - facility_destination ?holding_batch - holding_batch)
    :precondition
      (and
        (source_subgroup_supply_attached ?source_subgroup)
        (target_subgroup_supply_attached ?target_subgroup)
        (subgroup_assigned_origin ?source_subgroup ?facility_origin)
        (subgroup_assigned_destination ?target_subgroup ?facility_destination)
        (origin_supply_applied ?facility_origin)
        (destination_supply_applied ?facility_destination)
        (not
          (source_subgroup_ready ?source_subgroup)
        )
        (not
          (target_subgroup_ready ?target_subgroup)
        )
        (batch_available ?holding_batch)
      )
    :effect
      (and
        (batch_allocated ?holding_batch)
        (batch_linked_to_origin ?holding_batch ?facility_origin)
        (batch_linked_to_destination ?holding_batch ?facility_destination)
        (batch_origin_supplied ?holding_batch)
        (batch_destination_supplied ?holding_batch)
        (not
          (batch_available ?holding_batch)
        )
      )
  )
  (:action stage_batch_for_labeling
    :parameters (?holding_batch - holding_batch ?source_subgroup - source_subgroup ?clinical_procedure - clinical_procedure)
    :precondition
      (and
        (batch_allocated ?holding_batch)
        (source_subgroup_supply_attached ?source_subgroup)
        (procedure_assigned_to_entity ?source_subgroup ?clinical_procedure)
        (not
          (batch_ready_for_labeling ?holding_batch)
        )
      )
    :effect (batch_ready_for_labeling ?holding_batch)
  )
  (:action attach_container_label_to_batch
    :parameters (?separation_plan - separation_plan ?container_label - container_label ?holding_batch - holding_batch)
    :precondition
      (and
        (cleared_for_processing ?separation_plan)
        (plan_associated_batch ?separation_plan ?holding_batch)
        (plan_has_container_label ?separation_plan ?container_label)
        (container_label_available ?container_label)
        (batch_allocated ?holding_batch)
        (batch_ready_for_labeling ?holding_batch)
        (not
          (container_label_attached ?container_label)
        )
      )
    :effect
      (and
        (container_label_attached ?container_label)
        (container_label_linked_to_batch ?container_label ?holding_batch)
        (not
          (container_label_available ?container_label)
        )
      )
  )
  (:action confirm_label_binding_for_plan
    :parameters (?separation_plan - separation_plan ?container_label - container_label ?holding_batch - holding_batch ?clinical_procedure - clinical_procedure)
    :precondition
      (and
        (cleared_for_processing ?separation_plan)
        (plan_has_container_label ?separation_plan ?container_label)
        (container_label_attached ?container_label)
        (container_label_linked_to_batch ?container_label ?holding_batch)
        (procedure_assigned_to_entity ?separation_plan ?clinical_procedure)
        (not
          (batch_origin_supplied ?holding_batch)
        )
        (not
          (plan_label_and_supply_confirmed ?separation_plan)
        )
      )
    :effect (plan_label_and_supply_confirmed ?separation_plan)
  )
  (:action attach_authorization_document_to_plan
    :parameters (?separation_plan - separation_plan ?authorization_document - authorization_document)
    :precondition
      (and
        (cleared_for_processing ?separation_plan)
        (authorization_document_available ?authorization_document)
        (not
          (plan_authorization_attached ?separation_plan)
        )
      )
    :effect
      (and
        (plan_authorization_attached ?separation_plan)
        (plan_has_authorization_document ?separation_plan ?authorization_document)
        (not
          (authorization_document_available ?authorization_document)
        )
      )
  )
  (:action process_plan_with_authorization_and_label
    :parameters (?separation_plan - separation_plan ?container_label - container_label ?holding_batch - holding_batch ?clinical_procedure - clinical_procedure ?authorization_document - authorization_document)
    :precondition
      (and
        (cleared_for_processing ?separation_plan)
        (plan_has_container_label ?separation_plan ?container_label)
        (container_label_attached ?container_label)
        (container_label_linked_to_batch ?container_label ?holding_batch)
        (procedure_assigned_to_entity ?separation_plan ?clinical_procedure)
        (batch_origin_supplied ?holding_batch)
        (plan_authorization_attached ?separation_plan)
        (plan_has_authorization_document ?separation_plan ?authorization_document)
        (not
          (plan_label_and_supply_confirmed ?separation_plan)
        )
      )
    :effect
      (and
        (plan_label_and_supply_confirmed ?separation_plan)
        (plan_authorization_validated ?separation_plan)
      )
  )
  (:action confirm_medication_allocation_for_plan
    :parameters (?separation_plan - separation_plan ?medication - medication ?handler - handler ?container_label - container_label ?holding_batch - holding_batch)
    :precondition
      (and
        (plan_label_and_supply_confirmed ?separation_plan)
        (medication_reserved_for_plan ?separation_plan ?medication)
        (handler_assigned_to_entity ?separation_plan ?handler)
        (plan_has_container_label ?separation_plan ?container_label)
        (container_label_linked_to_batch ?container_label ?holding_batch)
        (not
          (batch_destination_supplied ?holding_batch)
        )
        (not
          (plan_medication_allocated ?separation_plan)
        )
      )
    :effect (plan_medication_allocated ?separation_plan)
  )
  (:action confirm_medication_allocation_variant
    :parameters (?separation_plan - separation_plan ?medication - medication ?handler - handler ?container_label - container_label ?holding_batch - holding_batch)
    :precondition
      (and
        (plan_label_and_supply_confirmed ?separation_plan)
        (medication_reserved_for_plan ?separation_plan ?medication)
        (handler_assigned_to_entity ?separation_plan ?handler)
        (plan_has_container_label ?separation_plan ?container_label)
        (container_label_linked_to_batch ?container_label ?holding_batch)
        (batch_destination_supplied ?holding_batch)
        (not
          (plan_medication_allocated ?separation_plan)
        )
      )
    :effect (plan_medication_allocated ?separation_plan)
  )
  (:action confirm_vaccine_allocation_variant_a
    :parameters (?separation_plan - separation_plan ?vaccine - vaccine ?container_label - container_label ?holding_batch - holding_batch)
    :precondition
      (and
        (plan_medication_allocated ?separation_plan)
        (vaccine_reserved_for_plan ?separation_plan ?vaccine)
        (plan_has_container_label ?separation_plan ?container_label)
        (container_label_linked_to_batch ?container_label ?holding_batch)
        (not
          (batch_origin_supplied ?holding_batch)
        )
        (not
          (batch_destination_supplied ?holding_batch)
        )
        (not
          (plan_clinical_confirmed ?separation_plan)
        )
      )
    :effect (plan_clinical_confirmed ?separation_plan)
  )
  (:action confirm_vaccine_and_service_requirement_variant_a
    :parameters (?separation_plan - separation_plan ?vaccine - vaccine ?container_label - container_label ?holding_batch - holding_batch)
    :precondition
      (and
        (plan_medication_allocated ?separation_plan)
        (vaccine_reserved_for_plan ?separation_plan ?vaccine)
        (plan_has_container_label ?separation_plan ?container_label)
        (container_label_linked_to_batch ?container_label ?holding_batch)
        (batch_origin_supplied ?holding_batch)
        (not
          (batch_destination_supplied ?holding_batch)
        )
        (not
          (plan_clinical_confirmed ?separation_plan)
        )
      )
    :effect
      (and
        (plan_clinical_confirmed ?separation_plan)
        (plan_requires_service_slot ?separation_plan)
      )
  )
  (:action confirm_vaccine_and_service_requirement_variant_b
    :parameters (?separation_plan - separation_plan ?vaccine - vaccine ?container_label - container_label ?holding_batch - holding_batch)
    :precondition
      (and
        (plan_medication_allocated ?separation_plan)
        (vaccine_reserved_for_plan ?separation_plan ?vaccine)
        (plan_has_container_label ?separation_plan ?container_label)
        (container_label_linked_to_batch ?container_label ?holding_batch)
        (not
          (batch_origin_supplied ?holding_batch)
        )
        (batch_destination_supplied ?holding_batch)
        (not
          (plan_clinical_confirmed ?separation_plan)
        )
      )
    :effect
      (and
        (plan_clinical_confirmed ?separation_plan)
        (plan_requires_service_slot ?separation_plan)
      )
  )
  (:action confirm_vaccine_and_service_requirement_variant_c
    :parameters (?separation_plan - separation_plan ?vaccine - vaccine ?container_label - container_label ?holding_batch - holding_batch)
    :precondition
      (and
        (plan_medication_allocated ?separation_plan)
        (vaccine_reserved_for_plan ?separation_plan ?vaccine)
        (plan_has_container_label ?separation_plan ?container_label)
        (container_label_linked_to_batch ?container_label ?holding_batch)
        (batch_origin_supplied ?holding_batch)
        (batch_destination_supplied ?holding_batch)
        (not
          (plan_clinical_confirmed ?separation_plan)
        )
      )
    :effect
      (and
        (plan_clinical_confirmed ?separation_plan)
        (plan_requires_service_slot ?separation_plan)
      )
  )
  (:action finalize_plan_without_service_slot
    :parameters (?separation_plan - separation_plan)
    :precondition
      (and
        (plan_clinical_confirmed ?separation_plan)
        (not
          (plan_requires_service_slot ?separation_plan)
        )
        (not
          (plan_finalized ?separation_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?separation_plan)
        (approved_for_execution ?separation_plan)
      )
  )
  (:action reserve_service_slot_for_plan
    :parameters (?separation_plan - separation_plan ?service_slot - service_slot)
    :precondition
      (and
        (plan_clinical_confirmed ?separation_plan)
        (plan_requires_service_slot ?separation_plan)
        (service_slot_available ?service_slot)
      )
    :effect
      (and
        (plan_allocated_service_slot ?separation_plan ?service_slot)
        (not
          (service_slot_available ?service_slot)
        )
      )
  )
  (:action complete_plan_execution_prechecks
    :parameters (?separation_plan - separation_plan ?source_subgroup - source_subgroup ?target_subgroup - target_subgroup ?clinical_procedure - clinical_procedure ?service_slot - service_slot)
    :precondition
      (and
        (plan_clinical_confirmed ?separation_plan)
        (plan_requires_service_slot ?separation_plan)
        (plan_allocated_service_slot ?separation_plan ?service_slot)
        (plan_associated_source_subgroup ?separation_plan ?source_subgroup)
        (plan_associated_target_subgroup ?separation_plan ?target_subgroup)
        (source_subgroup_ready ?source_subgroup)
        (target_subgroup_ready ?target_subgroup)
        (procedure_assigned_to_entity ?separation_plan ?clinical_procedure)
        (not
          (plan_execution_precheck_complete ?separation_plan)
        )
      )
    :effect (plan_execution_precheck_complete ?separation_plan)
  )
  (:action finalize_plan_after_prechecks
    :parameters (?separation_plan - separation_plan)
    :precondition
      (and
        (plan_clinical_confirmed ?separation_plan)
        (plan_execution_precheck_complete ?separation_plan)
        (not
          (plan_finalized ?separation_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?separation_plan)
        (approved_for_execution ?separation_plan)
      )
  )
  (:action attach_consent_form_to_plan
    :parameters (?separation_plan - separation_plan ?consent_form - consent_form ?clinical_procedure - clinical_procedure)
    :precondition
      (and
        (cleared_for_processing ?separation_plan)
        (procedure_assigned_to_entity ?separation_plan ?clinical_procedure)
        (consent_form_available ?consent_form)
        (plan_has_consent_form ?separation_plan ?consent_form)
        (not
          (plan_consent_attached ?separation_plan)
        )
      )
    :effect
      (and
        (plan_consent_attached ?separation_plan)
        (not
          (consent_form_available ?consent_form)
        )
      )
  )
  (:action verify_handler_for_plan_consent
    :parameters (?separation_plan - separation_plan ?handler - handler)
    :precondition
      (and
        (plan_consent_attached ?separation_plan)
        (handler_assigned_to_entity ?separation_plan ?handler)
        (not
          (plan_handler_confirmed ?separation_plan)
        )
      )
    :effect (plan_handler_confirmed ?separation_plan)
  )
  (:action verify_vaccine_administration_for_plan
    :parameters (?separation_plan - separation_plan ?vaccine - vaccine)
    :precondition
      (and
        (plan_handler_confirmed ?separation_plan)
        (vaccine_reserved_for_plan ?separation_plan ?vaccine)
        (not
          (plan_vaccine_verified ?separation_plan)
        )
      )
    :effect (plan_vaccine_verified ?separation_plan)
  )
  (:action finalize_plan_after_vaccine_verification
    :parameters (?separation_plan - separation_plan)
    :precondition
      (and
        (plan_vaccine_verified ?separation_plan)
        (not
          (plan_finalized ?separation_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?separation_plan)
        (approved_for_execution ?separation_plan)
      )
  )
  (:action finalize_source_subgroup_execution
    :parameters (?source_subgroup - source_subgroup ?holding_batch - holding_batch)
    :precondition
      (and
        (source_subgroup_supply_attached ?source_subgroup)
        (source_subgroup_ready ?source_subgroup)
        (batch_allocated ?holding_batch)
        (batch_ready_for_labeling ?holding_batch)
        (not
          (approved_for_execution ?source_subgroup)
        )
      )
    :effect (approved_for_execution ?source_subgroup)
  )
  (:action finalize_target_subgroup_execution
    :parameters (?target_subgroup - target_subgroup ?holding_batch - holding_batch)
    :precondition
      (and
        (target_subgroup_supply_attached ?target_subgroup)
        (target_subgroup_ready ?target_subgroup)
        (batch_allocated ?holding_batch)
        (batch_ready_for_labeling ?holding_batch)
        (not
          (approved_for_execution ?target_subgroup)
        )
      )
    :effect (approved_for_execution ?target_subgroup)
  )
  (:action schedule_procedure_for_entity
    :parameters (?entity - separation_subject ?schedule_slot - schedule_slot ?clinical_procedure - clinical_procedure)
    :precondition
      (and
        (approved_for_execution ?entity)
        (procedure_assigned_to_entity ?entity ?clinical_procedure)
        (schedule_slot_available ?schedule_slot)
        (not
          (procedure_completed ?entity)
        )
      )
    :effect
      (and
        (procedure_completed ?entity)
        (entity_scheduled_in_slot ?entity ?schedule_slot)
        (not
          (schedule_slot_available ?schedule_slot)
        )
      )
  )
  (:action execute_separation_for_source_subgroup
    :parameters (?source_subgroup - source_subgroup ?resource_token - resource_token ?schedule_slot - schedule_slot)
    :precondition
      (and
        (procedure_completed ?source_subgroup)
        (resource_assigned_to_entity ?source_subgroup ?resource_token)
        (entity_scheduled_in_slot ?source_subgroup ?schedule_slot)
        (not
          (separation_completed ?source_subgroup)
        )
      )
    :effect
      (and
        (separation_completed ?source_subgroup)
        (resource_available ?resource_token)
        (schedule_slot_available ?schedule_slot)
      )
  )
  (:action execute_separation_for_target_subgroup
    :parameters (?target_subgroup - target_subgroup ?resource_token - resource_token ?schedule_slot - schedule_slot)
    :precondition
      (and
        (procedure_completed ?target_subgroup)
        (resource_assigned_to_entity ?target_subgroup ?resource_token)
        (entity_scheduled_in_slot ?target_subgroup ?schedule_slot)
        (not
          (separation_completed ?target_subgroup)
        )
      )
    :effect
      (and
        (separation_completed ?target_subgroup)
        (resource_available ?resource_token)
        (schedule_slot_available ?schedule_slot)
      )
  )
  (:action execute_separation_for_plan
    :parameters (?separation_plan - separation_plan ?resource_token - resource_token ?schedule_slot - schedule_slot)
    :precondition
      (and
        (procedure_completed ?separation_plan)
        (resource_assigned_to_entity ?separation_plan ?resource_token)
        (entity_scheduled_in_slot ?separation_plan ?schedule_slot)
        (not
          (separation_completed ?separation_plan)
        )
      )
    :effect
      (and
        (separation_completed ?separation_plan)
        (resource_available ?resource_token)
        (schedule_slot_available ?schedule_slot)
      )
  )
)

(define (domain livestock_transport_readiness)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object zone_resource_category - object asset_type - object entity_category - object identifiable_entity - entity_category load_slot - resource_category weighing_station - resource_category stock_handler - resource_category movement_permit - resource_category vehicle_operator - resource_category identification_tag - resource_category veterinary_kit - resource_category biosecurity_kit - resource_category consumable_item - zone_resource_category cargo_container - zone_resource_category inspection_certificate - zone_resource_category loading_zone_a - asset_type loading_zone_b - asset_type transport_vehicle - asset_type source_group_class - identifiable_entity station_group_class - identifiable_entity source_animal_group - source_group_class receiving_animal_group - source_group_class handling_station - station_group_class)
  (:predicates
    (selected_for_processing ?livestock_entity - identifiable_entity)
    (ready_for_processing ?livestock_entity - identifiable_entity)
    (is_staged ?livestock_entity - identifiable_entity)
    (cleared_for_transport ?livestock_entity - identifiable_entity)
    (released_for_loading ?livestock_entity - identifiable_entity)
    (is_identified ?livestock_entity - identifiable_entity)
    (load_slot_available ?load_slot - load_slot)
    (assigned_load_slot ?livestock_entity - identifiable_entity ?load_slot - load_slot)
    (weighing_station_available ?weighing_station - weighing_station)
    (assigned_weighing_station ?livestock_entity - identifiable_entity ?weighing_station - weighing_station)
    (handler_available ?stock_handler - stock_handler)
    (assigned_handler ?livestock_entity - identifiable_entity ?stock_handler - stock_handler)
    (consumable_available ?consumable_item - consumable_item)
    (consumable_allocated_to_source_group ?source_animal_group - source_animal_group ?consumable_item - consumable_item)
    (consumable_allocated_to_receiving_group ?receiving_animal_group - receiving_animal_group ?consumable_item - consumable_item)
    (group_assigned_to_zone_a ?source_animal_group - source_animal_group ?loading_zone_a - loading_zone_a)
    (zone_a_inspected ?loading_zone_a - loading_zone_a)
    (zone_a_provisioned ?loading_zone_a - loading_zone_a)
    (group_prepared ?source_animal_group - source_animal_group)
    (group_assigned_to_zone_b ?receiving_animal_group - receiving_animal_group ?loading_zone_b - loading_zone_b)
    (zone_b_inspected ?loading_zone_b - loading_zone_b)
    (zone_b_provisioned ?loading_zone_b - loading_zone_b)
    (receiving_group_prepared ?receiving_animal_group - receiving_animal_group)
    (vehicle_available ?transport_vehicle - transport_vehicle)
    (vehicle_configured ?transport_vehicle - transport_vehicle)
    (vehicle_assigned_zone_a ?transport_vehicle - transport_vehicle ?loading_zone_a - loading_zone_a)
    (vehicle_assigned_zone_b ?transport_vehicle - transport_vehicle ?loading_zone_b - loading_zone_b)
    (vehicle_sealed ?transport_vehicle - transport_vehicle)
    (vehicle_inspected ?transport_vehicle - transport_vehicle)
    (vehicle_ready ?transport_vehicle - transport_vehicle)
    (station_assigned_source_group ?handling_station - handling_station ?source_animal_group - source_animal_group)
    (station_assigned_receiving_group ?handling_station - handling_station ?receiving_animal_group - receiving_animal_group)
    (station_linked_to_vehicle ?handling_station - handling_station ?transport_vehicle - transport_vehicle)
    (container_available ?cargo_container - cargo_container)
    (station_has_container ?handling_station - handling_station ?cargo_container - cargo_container)
    (container_allocated ?cargo_container - cargo_container)
    (container_attached_to_vehicle ?cargo_container - cargo_container ?transport_vehicle - transport_vehicle)
    (station_primed ?handling_station - handling_station)
    (veterinary_check_completed ?handling_station - handling_station)
    (station_checks_verified ?handling_station - handling_station)
    (permit_attached ?handling_station - handling_station)
    (permit_verified ?handling_station - handling_station)
    (certificate_verified ?handling_station - handling_station)
    (final_station_approval ?handling_station - handling_station)
    (inspection_certificate_available ?inspection_certificate - inspection_certificate)
    (station_has_certificate ?handling_station - handling_station ?inspection_certificate - inspection_certificate)
    (certificate_applied_to_station ?handling_station - handling_station)
    (certificate_validated ?handling_station - handling_station)
    (certificate_validation_confirmed ?handling_station - handling_station)
    (movement_permit_available ?movement_permit - movement_permit)
    (station_has_permit ?handling_station - handling_station ?movement_permit - movement_permit)
    (operator_available ?vehicle_operator - vehicle_operator)
    (operator_assigned_to_station ?handling_station - handling_station ?vehicle_operator - vehicle_operator)
    (veterinary_kit_available ?veterinary_kit - veterinary_kit)
    (station_has_veterinary_kit ?handling_station - handling_station ?veterinary_kit - veterinary_kit)
    (biosecurity_kit_available ?biosecurity_kit - biosecurity_kit)
    (station_has_biosecurity_kit ?handling_station - handling_station ?biosecurity_kit - biosecurity_kit)
    (identification_tag_available ?identification_tag - identification_tag)
    (assigned_identification_tag ?livestock_entity - identifiable_entity ?identification_tag - identification_tag)
    (source_group_handler_confirmed ?source_animal_group - source_animal_group)
    (receiving_group_handler_confirmed ?receiving_animal_group - receiving_animal_group)
    (station_finalized ?handling_station - handling_station)
  )
  (:action select_animal_for_processing
    :parameters (?livestock_entity - identifiable_entity)
    :precondition
      (and
        (not
          (selected_for_processing ?livestock_entity)
        )
        (not
          (cleared_for_transport ?livestock_entity)
        )
      )
    :effect (selected_for_processing ?livestock_entity)
  )
  (:action assign_load_slot_to_animal
    :parameters (?livestock_entity - identifiable_entity ?load_slot - load_slot)
    :precondition
      (and
        (selected_for_processing ?livestock_entity)
        (not
          (is_staged ?livestock_entity)
        )
        (load_slot_available ?load_slot)
      )
    :effect
      (and
        (is_staged ?livestock_entity)
        (assigned_load_slot ?livestock_entity ?load_slot)
        (not
          (load_slot_available ?load_slot)
        )
      )
  )
  (:action reserve_weighing_station_for_animal
    :parameters (?livestock_entity - identifiable_entity ?weighing_station - weighing_station)
    :precondition
      (and
        (selected_for_processing ?livestock_entity)
        (is_staged ?livestock_entity)
        (weighing_station_available ?weighing_station)
      )
    :effect
      (and
        (assigned_weighing_station ?livestock_entity ?weighing_station)
        (not
          (weighing_station_available ?weighing_station)
        )
      )
  )
  (:action confirm_weighing_and_mark_ready
    :parameters (?livestock_entity - identifiable_entity ?weighing_station - weighing_station)
    :precondition
      (and
        (selected_for_processing ?livestock_entity)
        (is_staged ?livestock_entity)
        (assigned_weighing_station ?livestock_entity ?weighing_station)
        (not
          (ready_for_processing ?livestock_entity)
        )
      )
    :effect (ready_for_processing ?livestock_entity)
  )
  (:action release_weighing_station
    :parameters (?livestock_entity - identifiable_entity ?weighing_station - weighing_station)
    :precondition
      (and
        (assigned_weighing_station ?livestock_entity ?weighing_station)
      )
    :effect
      (and
        (weighing_station_available ?weighing_station)
        (not
          (assigned_weighing_station ?livestock_entity ?weighing_station)
        )
      )
  )
  (:action assign_handler_to_entity
    :parameters (?livestock_entity - identifiable_entity ?stock_handler - stock_handler)
    :precondition
      (and
        (ready_for_processing ?livestock_entity)
        (handler_available ?stock_handler)
      )
    :effect
      (and
        (assigned_handler ?livestock_entity ?stock_handler)
        (not
          (handler_available ?stock_handler)
        )
      )
  )
  (:action release_handler_from_entity
    :parameters (?livestock_entity - identifiable_entity ?stock_handler - stock_handler)
    :precondition
      (and
        (assigned_handler ?livestock_entity ?stock_handler)
      )
    :effect
      (and
        (handler_available ?stock_handler)
        (not
          (assigned_handler ?livestock_entity ?stock_handler)
        )
      )
  )
  (:action attach_veterinary_kit_to_station
    :parameters (?handling_station - handling_station ?veterinary_kit - veterinary_kit)
    :precondition
      (and
        (ready_for_processing ?handling_station)
        (veterinary_kit_available ?veterinary_kit)
      )
    :effect
      (and
        (station_has_veterinary_kit ?handling_station ?veterinary_kit)
        (not
          (veterinary_kit_available ?veterinary_kit)
        )
      )
  )
  (:action detach_veterinary_kit_from_station
    :parameters (?handling_station - handling_station ?veterinary_kit - veterinary_kit)
    :precondition
      (and
        (station_has_veterinary_kit ?handling_station ?veterinary_kit)
      )
    :effect
      (and
        (veterinary_kit_available ?veterinary_kit)
        (not
          (station_has_veterinary_kit ?handling_station ?veterinary_kit)
        )
      )
  )
  (:action attach_biosecurity_kit_to_station
    :parameters (?handling_station - handling_station ?biosecurity_kit - biosecurity_kit)
    :precondition
      (and
        (ready_for_processing ?handling_station)
        (biosecurity_kit_available ?biosecurity_kit)
      )
    :effect
      (and
        (station_has_biosecurity_kit ?handling_station ?biosecurity_kit)
        (not
          (biosecurity_kit_available ?biosecurity_kit)
        )
      )
  )
  (:action detach_biosecurity_kit_from_station
    :parameters (?handling_station - handling_station ?biosecurity_kit - biosecurity_kit)
    :precondition
      (and
        (station_has_biosecurity_kit ?handling_station ?biosecurity_kit)
      )
    :effect
      (and
        (biosecurity_kit_available ?biosecurity_kit)
        (not
          (station_has_biosecurity_kit ?handling_station ?biosecurity_kit)
        )
      )
  )
  (:action inspect_loading_zone_a_for_group
    :parameters (?source_animal_group - source_animal_group ?loading_zone_a - loading_zone_a ?weighing_station - weighing_station)
    :precondition
      (and
        (ready_for_processing ?source_animal_group)
        (assigned_weighing_station ?source_animal_group ?weighing_station)
        (group_assigned_to_zone_a ?source_animal_group ?loading_zone_a)
        (not
          (zone_a_inspected ?loading_zone_a)
        )
        (not
          (zone_a_provisioned ?loading_zone_a)
        )
      )
    :effect (zone_a_inspected ?loading_zone_a)
  )
  (:action confirm_group_handler_and_mark_prepared
    :parameters (?source_animal_group - source_animal_group ?loading_zone_a - loading_zone_a ?stock_handler - stock_handler)
    :precondition
      (and
        (ready_for_processing ?source_animal_group)
        (assigned_handler ?source_animal_group ?stock_handler)
        (group_assigned_to_zone_a ?source_animal_group ?loading_zone_a)
        (zone_a_inspected ?loading_zone_a)
        (not
          (source_group_handler_confirmed ?source_animal_group)
        )
      )
    :effect
      (and
        (source_group_handler_confirmed ?source_animal_group)
        (group_prepared ?source_animal_group)
      )
  )
  (:action provision_consumable_to_group
    :parameters (?source_animal_group - source_animal_group ?loading_zone_a - loading_zone_a ?consumable_item - consumable_item)
    :precondition
      (and
        (ready_for_processing ?source_animal_group)
        (group_assigned_to_zone_a ?source_animal_group ?loading_zone_a)
        (consumable_available ?consumable_item)
        (not
          (source_group_handler_confirmed ?source_animal_group)
        )
      )
    :effect
      (and
        (zone_a_provisioned ?loading_zone_a)
        (source_group_handler_confirmed ?source_animal_group)
        (consumable_allocated_to_source_group ?source_animal_group ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action finalize_group_preparation_zone_a
    :parameters (?source_animal_group - source_animal_group ?loading_zone_a - loading_zone_a ?weighing_station - weighing_station ?consumable_item - consumable_item)
    :precondition
      (and
        (ready_for_processing ?source_animal_group)
        (assigned_weighing_station ?source_animal_group ?weighing_station)
        (group_assigned_to_zone_a ?source_animal_group ?loading_zone_a)
        (zone_a_provisioned ?loading_zone_a)
        (consumable_allocated_to_source_group ?source_animal_group ?consumable_item)
        (not
          (group_prepared ?source_animal_group)
        )
      )
    :effect
      (and
        (zone_a_inspected ?loading_zone_a)
        (group_prepared ?source_animal_group)
        (consumable_available ?consumable_item)
        (not
          (consumable_allocated_to_source_group ?source_animal_group ?consumable_item)
        )
      )
  )
  (:action inspect_loading_zone_b_for_receiving_group
    :parameters (?receiving_animal_group - receiving_animal_group ?loading_zone_b - loading_zone_b ?weighing_station - weighing_station)
    :precondition
      (and
        (ready_for_processing ?receiving_animal_group)
        (assigned_weighing_station ?receiving_animal_group ?weighing_station)
        (group_assigned_to_zone_b ?receiving_animal_group ?loading_zone_b)
        (not
          (zone_b_inspected ?loading_zone_b)
        )
        (not
          (zone_b_provisioned ?loading_zone_b)
        )
      )
    :effect (zone_b_inspected ?loading_zone_b)
  )
  (:action confirm_receiving_group_handler_and_mark_prepared
    :parameters (?receiving_animal_group - receiving_animal_group ?loading_zone_b - loading_zone_b ?stock_handler - stock_handler)
    :precondition
      (and
        (ready_for_processing ?receiving_animal_group)
        (assigned_handler ?receiving_animal_group ?stock_handler)
        (group_assigned_to_zone_b ?receiving_animal_group ?loading_zone_b)
        (zone_b_inspected ?loading_zone_b)
        (not
          (receiving_group_handler_confirmed ?receiving_animal_group)
        )
      )
    :effect
      (and
        (receiving_group_handler_confirmed ?receiving_animal_group)
        (receiving_group_prepared ?receiving_animal_group)
      )
  )
  (:action provision_consumable_to_receiving_group
    :parameters (?receiving_animal_group - receiving_animal_group ?loading_zone_b - loading_zone_b ?consumable_item - consumable_item)
    :precondition
      (and
        (ready_for_processing ?receiving_animal_group)
        (group_assigned_to_zone_b ?receiving_animal_group ?loading_zone_b)
        (consumable_available ?consumable_item)
        (not
          (receiving_group_handler_confirmed ?receiving_animal_group)
        )
      )
    :effect
      (and
        (zone_b_provisioned ?loading_zone_b)
        (receiving_group_handler_confirmed ?receiving_animal_group)
        (consumable_allocated_to_receiving_group ?receiving_animal_group ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action finalize_receiving_group_preparation_zone_b
    :parameters (?receiving_animal_group - receiving_animal_group ?loading_zone_b - loading_zone_b ?weighing_station - weighing_station ?consumable_item - consumable_item)
    :precondition
      (and
        (ready_for_processing ?receiving_animal_group)
        (assigned_weighing_station ?receiving_animal_group ?weighing_station)
        (group_assigned_to_zone_b ?receiving_animal_group ?loading_zone_b)
        (zone_b_provisioned ?loading_zone_b)
        (consumable_allocated_to_receiving_group ?receiving_animal_group ?consumable_item)
        (not
          (receiving_group_prepared ?receiving_animal_group)
        )
      )
    :effect
      (and
        (zone_b_inspected ?loading_zone_b)
        (receiving_group_prepared ?receiving_animal_group)
        (consumable_available ?consumable_item)
        (not
          (consumable_allocated_to_receiving_group ?receiving_animal_group ?consumable_item)
        )
      )
  )
  (:action assign_vehicle_to_groups_and_link_zones
    :parameters (?source_animal_group - source_animal_group ?receiving_animal_group - receiving_animal_group ?loading_zone_a - loading_zone_a ?loading_zone_b - loading_zone_b ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (source_group_handler_confirmed ?source_animal_group)
        (receiving_group_handler_confirmed ?receiving_animal_group)
        (group_assigned_to_zone_a ?source_animal_group ?loading_zone_a)
        (group_assigned_to_zone_b ?receiving_animal_group ?loading_zone_b)
        (zone_a_inspected ?loading_zone_a)
        (zone_b_inspected ?loading_zone_b)
        (group_prepared ?source_animal_group)
        (receiving_group_prepared ?receiving_animal_group)
        (vehicle_available ?transport_vehicle)
      )
    :effect
      (and
        (vehicle_configured ?transport_vehicle)
        (vehicle_assigned_zone_a ?transport_vehicle ?loading_zone_a)
        (vehicle_assigned_zone_b ?transport_vehicle ?loading_zone_b)
        (not
          (vehicle_available ?transport_vehicle)
        )
      )
  )
  (:action assign_vehicle_and_mark_sealed_compartment
    :parameters (?source_animal_group - source_animal_group ?receiving_animal_group - receiving_animal_group ?loading_zone_a - loading_zone_a ?loading_zone_b - loading_zone_b ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (source_group_handler_confirmed ?source_animal_group)
        (receiving_group_handler_confirmed ?receiving_animal_group)
        (group_assigned_to_zone_a ?source_animal_group ?loading_zone_a)
        (group_assigned_to_zone_b ?receiving_animal_group ?loading_zone_b)
        (zone_a_provisioned ?loading_zone_a)
        (zone_b_inspected ?loading_zone_b)
        (not
          (group_prepared ?source_animal_group)
        )
        (receiving_group_prepared ?receiving_animal_group)
        (vehicle_available ?transport_vehicle)
      )
    :effect
      (and
        (vehicle_configured ?transport_vehicle)
        (vehicle_assigned_zone_a ?transport_vehicle ?loading_zone_a)
        (vehicle_assigned_zone_b ?transport_vehicle ?loading_zone_b)
        (vehicle_sealed ?transport_vehicle)
        (not
          (vehicle_available ?transport_vehicle)
        )
      )
  )
  (:action assign_vehicle_and_mark_inspection_variant
    :parameters (?source_animal_group - source_animal_group ?receiving_animal_group - receiving_animal_group ?loading_zone_a - loading_zone_a ?loading_zone_b - loading_zone_b ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (source_group_handler_confirmed ?source_animal_group)
        (receiving_group_handler_confirmed ?receiving_animal_group)
        (group_assigned_to_zone_a ?source_animal_group ?loading_zone_a)
        (group_assigned_to_zone_b ?receiving_animal_group ?loading_zone_b)
        (zone_a_inspected ?loading_zone_a)
        (zone_b_provisioned ?loading_zone_b)
        (group_prepared ?source_animal_group)
        (not
          (receiving_group_prepared ?receiving_animal_group)
        )
        (vehicle_available ?transport_vehicle)
      )
    :effect
      (and
        (vehicle_configured ?transport_vehicle)
        (vehicle_assigned_zone_a ?transport_vehicle ?loading_zone_a)
        (vehicle_assigned_zone_b ?transport_vehicle ?loading_zone_b)
        (vehicle_inspected ?transport_vehicle)
        (not
          (vehicle_available ?transport_vehicle)
        )
      )
  )
  (:action fully_configure_vehicle_for_loading
    :parameters (?source_animal_group - source_animal_group ?receiving_animal_group - receiving_animal_group ?loading_zone_a - loading_zone_a ?loading_zone_b - loading_zone_b ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (source_group_handler_confirmed ?source_animal_group)
        (receiving_group_handler_confirmed ?receiving_animal_group)
        (group_assigned_to_zone_a ?source_animal_group ?loading_zone_a)
        (group_assigned_to_zone_b ?receiving_animal_group ?loading_zone_b)
        (zone_a_provisioned ?loading_zone_a)
        (zone_b_provisioned ?loading_zone_b)
        (not
          (group_prepared ?source_animal_group)
        )
        (not
          (receiving_group_prepared ?receiving_animal_group)
        )
        (vehicle_available ?transport_vehicle)
      )
    :effect
      (and
        (vehicle_configured ?transport_vehicle)
        (vehicle_assigned_zone_a ?transport_vehicle ?loading_zone_a)
        (vehicle_assigned_zone_b ?transport_vehicle ?loading_zone_b)
        (vehicle_sealed ?transport_vehicle)
        (vehicle_inspected ?transport_vehicle)
        (not
          (vehicle_available ?transport_vehicle)
        )
      )
  )
  (:action mark_vehicle_ready_for_loading
    :parameters (?transport_vehicle - transport_vehicle ?source_animal_group - source_animal_group ?weighing_station - weighing_station)
    :precondition
      (and
        (vehicle_configured ?transport_vehicle)
        (source_group_handler_confirmed ?source_animal_group)
        (assigned_weighing_station ?source_animal_group ?weighing_station)
        (not
          (vehicle_ready ?transport_vehicle)
        )
      )
    :effect (vehicle_ready ?transport_vehicle)
  )
  (:action allocate_container_to_station_and_attach_to_vehicle
    :parameters (?handling_station - handling_station ?cargo_container - cargo_container ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (ready_for_processing ?handling_station)
        (station_linked_to_vehicle ?handling_station ?transport_vehicle)
        (station_has_container ?handling_station ?cargo_container)
        (container_available ?cargo_container)
        (vehicle_configured ?transport_vehicle)
        (vehicle_ready ?transport_vehicle)
        (not
          (container_allocated ?cargo_container)
        )
      )
    :effect
      (and
        (container_allocated ?cargo_container)
        (container_attached_to_vehicle ?cargo_container ?transport_vehicle)
        (not
          (container_available ?cargo_container)
        )
      )
  )
  (:action prime_station_with_allocated_container
    :parameters (?handling_station - handling_station ?cargo_container - cargo_container ?transport_vehicle - transport_vehicle ?weighing_station - weighing_station)
    :precondition
      (and
        (ready_for_processing ?handling_station)
        (station_has_container ?handling_station ?cargo_container)
        (container_allocated ?cargo_container)
        (container_attached_to_vehicle ?cargo_container ?transport_vehicle)
        (assigned_weighing_station ?handling_station ?weighing_station)
        (not
          (vehicle_sealed ?transport_vehicle)
        )
        (not
          (station_primed ?handling_station)
        )
      )
    :effect (station_primed ?handling_station)
  )
  (:action attach_movement_permit_to_station
    :parameters (?handling_station - handling_station ?movement_permit - movement_permit)
    :precondition
      (and
        (ready_for_processing ?handling_station)
        (movement_permit_available ?movement_permit)
        (not
          (permit_attached ?handling_station)
        )
      )
    :effect
      (and
        (permit_attached ?handling_station)
        (station_has_permit ?handling_station ?movement_permit)
        (not
          (movement_permit_available ?movement_permit)
        )
      )
  )
  (:action attach_container_permit_and_prime_station
    :parameters (?handling_station - handling_station ?cargo_container - cargo_container ?transport_vehicle - transport_vehicle ?weighing_station - weighing_station ?movement_permit - movement_permit)
    :precondition
      (and
        (ready_for_processing ?handling_station)
        (station_has_container ?handling_station ?cargo_container)
        (container_allocated ?cargo_container)
        (container_attached_to_vehicle ?cargo_container ?transport_vehicle)
        (assigned_weighing_station ?handling_station ?weighing_station)
        (vehicle_sealed ?transport_vehicle)
        (permit_attached ?handling_station)
        (station_has_permit ?handling_station ?movement_permit)
        (not
          (station_primed ?handling_station)
        )
      )
    :effect
      (and
        (station_primed ?handling_station)
        (permit_verified ?handling_station)
      )
  )
  (:action perform_veterinary_inspection_at_station
    :parameters (?handling_station - handling_station ?veterinary_kit - veterinary_kit ?stock_handler - stock_handler ?cargo_container - cargo_container ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (station_primed ?handling_station)
        (station_has_veterinary_kit ?handling_station ?veterinary_kit)
        (assigned_handler ?handling_station ?stock_handler)
        (station_has_container ?handling_station ?cargo_container)
        (container_attached_to_vehicle ?cargo_container ?transport_vehicle)
        (not
          (vehicle_inspected ?transport_vehicle)
        )
        (not
          (veterinary_check_completed ?handling_station)
        )
      )
    :effect (veterinary_check_completed ?handling_station)
  )
  (:action perform_vet_inspection_and_mark
    :parameters (?handling_station - handling_station ?veterinary_kit - veterinary_kit ?stock_handler - stock_handler ?cargo_container - cargo_container ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (station_primed ?handling_station)
        (station_has_veterinary_kit ?handling_station ?veterinary_kit)
        (assigned_handler ?handling_station ?stock_handler)
        (station_has_container ?handling_station ?cargo_container)
        (container_attached_to_vehicle ?cargo_container ?transport_vehicle)
        (vehicle_inspected ?transport_vehicle)
        (not
          (veterinary_check_completed ?handling_station)
        )
      )
    :effect (veterinary_check_completed ?handling_station)
  )
  (:action perform_biosecurity_inspection_and_mark
    :parameters (?handling_station - handling_station ?biosecurity_kit - biosecurity_kit ?cargo_container - cargo_container ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (veterinary_check_completed ?handling_station)
        (station_has_biosecurity_kit ?handling_station ?biosecurity_kit)
        (station_has_container ?handling_station ?cargo_container)
        (container_attached_to_vehicle ?cargo_container ?transport_vehicle)
        (not
          (vehicle_sealed ?transport_vehicle)
        )
        (not
          (vehicle_inspected ?transport_vehicle)
        )
        (not
          (station_checks_verified ?handling_station)
        )
      )
    :effect (station_checks_verified ?handling_station)
  )
  (:action perform_biosecurity_check_and_additional_certificate_variant1
    :parameters (?handling_station - handling_station ?biosecurity_kit - biosecurity_kit ?cargo_container - cargo_container ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (veterinary_check_completed ?handling_station)
        (station_has_biosecurity_kit ?handling_station ?biosecurity_kit)
        (station_has_container ?handling_station ?cargo_container)
        (container_attached_to_vehicle ?cargo_container ?transport_vehicle)
        (vehicle_sealed ?transport_vehicle)
        (not
          (vehicle_inspected ?transport_vehicle)
        )
        (not
          (station_checks_verified ?handling_station)
        )
      )
    :effect
      (and
        (station_checks_verified ?handling_station)
        (certificate_verified ?handling_station)
      )
  )
  (:action perform_biosecurity_check_and_additional_certificate_variant2
    :parameters (?handling_station - handling_station ?biosecurity_kit - biosecurity_kit ?cargo_container - cargo_container ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (veterinary_check_completed ?handling_station)
        (station_has_biosecurity_kit ?handling_station ?biosecurity_kit)
        (station_has_container ?handling_station ?cargo_container)
        (container_attached_to_vehicle ?cargo_container ?transport_vehicle)
        (not
          (vehicle_sealed ?transport_vehicle)
        )
        (vehicle_inspected ?transport_vehicle)
        (not
          (station_checks_verified ?handling_station)
        )
      )
    :effect
      (and
        (station_checks_verified ?handling_station)
        (certificate_verified ?handling_station)
      )
  )
  (:action perform_biosecurity_check_and_additional_certificate_variant3
    :parameters (?handling_station - handling_station ?biosecurity_kit - biosecurity_kit ?cargo_container - cargo_container ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (veterinary_check_completed ?handling_station)
        (station_has_biosecurity_kit ?handling_station ?biosecurity_kit)
        (station_has_container ?handling_station ?cargo_container)
        (container_attached_to_vehicle ?cargo_container ?transport_vehicle)
        (vehicle_sealed ?transport_vehicle)
        (vehicle_inspected ?transport_vehicle)
        (not
          (station_checks_verified ?handling_station)
        )
      )
    :effect
      (and
        (station_checks_verified ?handling_station)
        (certificate_verified ?handling_station)
      )
  )
  (:action finalize_station_checks_and_mark_ready
    :parameters (?handling_station - handling_station)
    :precondition
      (and
        (station_checks_verified ?handling_station)
        (not
          (certificate_verified ?handling_station)
        )
        (not
          (station_finalized ?handling_station)
        )
      )
    :effect
      (and
        (station_finalized ?handling_station)
        (released_for_loading ?handling_station)
      )
  )
  (:action assign_operator_to_station
    :parameters (?handling_station - handling_station ?vehicle_operator - vehicle_operator)
    :precondition
      (and
        (station_checks_verified ?handling_station)
        (certificate_verified ?handling_station)
        (operator_available ?vehicle_operator)
      )
    :effect
      (and
        (operator_assigned_to_station ?handling_station ?vehicle_operator)
        (not
          (operator_available ?vehicle_operator)
        )
      )
  )
  (:action complete_final_station_processing
    :parameters (?handling_station - handling_station ?source_animal_group - source_animal_group ?receiving_animal_group - receiving_animal_group ?weighing_station - weighing_station ?vehicle_operator - vehicle_operator)
    :precondition
      (and
        (station_checks_verified ?handling_station)
        (certificate_verified ?handling_station)
        (operator_assigned_to_station ?handling_station ?vehicle_operator)
        (station_assigned_source_group ?handling_station ?source_animal_group)
        (station_assigned_receiving_group ?handling_station ?receiving_animal_group)
        (group_prepared ?source_animal_group)
        (receiving_group_prepared ?receiving_animal_group)
        (assigned_weighing_station ?handling_station ?weighing_station)
        (not
          (final_station_approval ?handling_station)
        )
      )
    :effect (final_station_approval ?handling_station)
  )
  (:action finalize_and_release_station
    :parameters (?handling_station - handling_station)
    :precondition
      (and
        (station_checks_verified ?handling_station)
        (final_station_approval ?handling_station)
        (not
          (station_finalized ?handling_station)
        )
      )
    :effect
      (and
        (station_finalized ?handling_station)
        (released_for_loading ?handling_station)
      )
  )
  (:action apply_certificate_to_station
    :parameters (?handling_station - handling_station ?inspection_certificate - inspection_certificate ?weighing_station - weighing_station)
    :precondition
      (and
        (ready_for_processing ?handling_station)
        (assigned_weighing_station ?handling_station ?weighing_station)
        (inspection_certificate_available ?inspection_certificate)
        (station_has_certificate ?handling_station ?inspection_certificate)
        (not
          (certificate_applied_to_station ?handling_station)
        )
      )
    :effect
      (and
        (certificate_applied_to_station ?handling_station)
        (not
          (inspection_certificate_available ?inspection_certificate)
        )
      )
  )
  (:action validate_certificate_with_handler
    :parameters (?handling_station - handling_station ?stock_handler - stock_handler)
    :precondition
      (and
        (certificate_applied_to_station ?handling_station)
        (assigned_handler ?handling_station ?stock_handler)
        (not
          (certificate_validated ?handling_station)
        )
      )
    :effect (certificate_validated ?handling_station)
  )
  (:action confirm_biosecurity_validation
    :parameters (?handling_station - handling_station ?biosecurity_kit - biosecurity_kit)
    :precondition
      (and
        (certificate_validated ?handling_station)
        (station_has_biosecurity_kit ?handling_station ?biosecurity_kit)
        (not
          (certificate_validation_confirmed ?handling_station)
        )
      )
    :effect (certificate_validation_confirmed ?handling_station)
  )
  (:action finalize_station_post_certificate
    :parameters (?handling_station - handling_station)
    :precondition
      (and
        (certificate_validation_confirmed ?handling_station)
        (not
          (station_finalized ?handling_station)
        )
      )
    :effect
      (and
        (station_finalized ?handling_station)
        (released_for_loading ?handling_station)
      )
  )
  (:action confirm_source_group_release
    :parameters (?source_animal_group - source_animal_group ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (source_group_handler_confirmed ?source_animal_group)
        (group_prepared ?source_animal_group)
        (vehicle_configured ?transport_vehicle)
        (vehicle_ready ?transport_vehicle)
        (not
          (released_for_loading ?source_animal_group)
        )
      )
    :effect (released_for_loading ?source_animal_group)
  )
  (:action confirm_receiving_group_release
    :parameters (?receiving_animal_group - receiving_animal_group ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (receiving_group_handler_confirmed ?receiving_animal_group)
        (receiving_group_prepared ?receiving_animal_group)
        (vehicle_configured ?transport_vehicle)
        (vehicle_ready ?transport_vehicle)
        (not
          (released_for_loading ?receiving_animal_group)
        )
      )
    :effect (released_for_loading ?receiving_animal_group)
  )
  (:action assign_identification_tag_to_entity
    :parameters (?livestock_entity - identifiable_entity ?identification_tag - identification_tag ?weighing_station - weighing_station)
    :precondition
      (and
        (released_for_loading ?livestock_entity)
        (assigned_weighing_station ?livestock_entity ?weighing_station)
        (identification_tag_available ?identification_tag)
        (not
          (is_identified ?livestock_entity)
        )
      )
    :effect
      (and
        (is_identified ?livestock_entity)
        (assigned_identification_tag ?livestock_entity ?identification_tag)
        (not
          (identification_tag_available ?identification_tag)
        )
      )
  )
  (:action authorize_group_for_transport
    :parameters (?source_animal_group - source_animal_group ?load_slot - load_slot ?identification_tag - identification_tag)
    :precondition
      (and
        (is_identified ?source_animal_group)
        (assigned_load_slot ?source_animal_group ?load_slot)
        (assigned_identification_tag ?source_animal_group ?identification_tag)
        (not
          (cleared_for_transport ?source_animal_group)
        )
      )
    :effect
      (and
        (cleared_for_transport ?source_animal_group)
        (load_slot_available ?load_slot)
        (identification_tag_available ?identification_tag)
      )
  )
  (:action authorize_receiving_group_for_transport
    :parameters (?receiving_animal_group - receiving_animal_group ?load_slot - load_slot ?identification_tag - identification_tag)
    :precondition
      (and
        (is_identified ?receiving_animal_group)
        (assigned_load_slot ?receiving_animal_group ?load_slot)
        (assigned_identification_tag ?receiving_animal_group ?identification_tag)
        (not
          (cleared_for_transport ?receiving_animal_group)
        )
      )
    :effect
      (and
        (cleared_for_transport ?receiving_animal_group)
        (load_slot_available ?load_slot)
        (identification_tag_available ?identification_tag)
      )
  )
  (:action authorize_station_for_transport
    :parameters (?handling_station - handling_station ?load_slot - load_slot ?identification_tag - identification_tag)
    :precondition
      (and
        (is_identified ?handling_station)
        (assigned_load_slot ?handling_station ?load_slot)
        (assigned_identification_tag ?handling_station ?identification_tag)
        (not
          (cleared_for_transport ?handling_station)
        )
      )
    :effect
      (and
        (cleared_for_transport ?handling_station)
        (load_slot_available ?load_slot)
        (identification_tag_available ?identification_tag)
      )
  )
)

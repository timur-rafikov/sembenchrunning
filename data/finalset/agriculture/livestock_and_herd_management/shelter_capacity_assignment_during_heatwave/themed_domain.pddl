(define (domain livestock_shelter_capacity_assignment)
  (:requirements :strips :typing :negative-preconditions)
  (:types ancillary_resource_category - object material_resource_category - object environment_component_category - object shelter_management_root - object shelter_management_entity - shelter_management_root transport_vehicle - ancillary_resource_category entity_id_tag - ancillary_resource_category access_point - ancillary_resource_category shade_structure_type - ancillary_resource_category care_protocol - ancillary_resource_category assignment_token - ancillary_resource_category cooling_equipment - ancillary_resource_category veterinarian - ancillary_resource_category resource_unit - material_resource_category bedding_unit - material_resource_category vaccine_batch - material_resource_category microclimate_zone - environment_component_category ventilation_zone - environment_component_category shelter_bay - environment_component_category management_unit_type - shelter_management_entity facility_unit_type - shelter_management_entity herd_group - management_unit_type herd_subgroup - management_unit_type shelter_unit - facility_unit_type)
  (:predicates
    (intake_registered ?herd_entity - shelter_management_entity)
    (cleared_for_processing ?herd_entity - shelter_management_entity)
    (on_transport ?herd_entity - shelter_management_entity)
    (assignment_confirmed ?herd_entity - shelter_management_entity)
    (ready_to_receive ?herd_entity - shelter_management_entity)
    (assignment_ready ?herd_entity - shelter_management_entity)
    (vehicle_available ?transport_vehicle - transport_vehicle)
    (assigned_to_vehicle ?herd_entity - shelter_management_entity ?transport_vehicle - transport_vehicle)
    (id_tag_available ?animal_id_tag - entity_id_tag)
    (has_id_tag ?herd_entity - shelter_management_entity ?animal_id_tag - entity_id_tag)
    (access_point_available ?access_point - access_point)
    (access_point_assigned ?herd_entity - shelter_management_entity ?access_point - access_point)
    (resource_unit_available ?resource_unit - resource_unit)
    (resource_assigned_to_group ?herd_group - herd_group ?resource_unit - resource_unit)
    (resource_assigned_to_subgroup ?herd_subgroup - herd_subgroup ?resource_unit - resource_unit)
    (group_assigned_microclimate_zone ?herd_group - herd_group ?microclimate_zone - microclimate_zone)
    (microclimate_reserved ?microclimate_zone - microclimate_zone)
    (zone_prepared ?microclimate_zone - microclimate_zone)
    (group_ready ?herd_group - herd_group)
    (subgroup_assigned_ventilation_zone ?herd_subgroup - herd_subgroup ?ventilation_zone - ventilation_zone)
    (ventilation_reserved ?ventilation_zone - ventilation_zone)
    (ventilation_prepared ?ventilation_zone - ventilation_zone)
    (subgroup_ready ?herd_subgroup - herd_subgroup)
    (shelter_bay_available ?shelter_bay - shelter_bay)
    (shelter_bay_reserved ?shelter_bay - shelter_bay)
    (bay_microclimate_link ?shelter_bay - shelter_bay ?microclimate_zone - microclimate_zone)
    (bay_ventilation_link ?shelter_bay - shelter_bay ?ventilation_zone - ventilation_zone)
    (bay_bedding_installed ?shelter_bay - shelter_bay)
    (bay_cooling_provisioned ?shelter_bay - shelter_bay)
    (bay_final_prepared ?shelter_bay - shelter_bay)
    (shelter_unit_linked_group ?shelter_unit - shelter_unit ?herd_group - herd_group)
    (shelter_unit_linked_subgroup ?shelter_unit - shelter_unit ?herd_subgroup - herd_subgroup)
    (shelter_unit_contains_bay ?shelter_unit - shelter_unit ?shelter_bay - shelter_bay)
    (bedding_unit_available ?bedding_unit - bedding_unit)
    (shelter_unit_has_bedding ?shelter_unit - shelter_unit ?bedding_unit - bedding_unit)
    (bedding_assigned ?bedding_unit - bedding_unit)
    (bedding_assigned_to_bay ?bedding_unit - bedding_unit ?shelter_bay - shelter_bay)
    (shelter_unit_bedding_installed ?shelter_unit - shelter_unit)
    (shelter_unit_cooling_installed ?shelter_unit - shelter_unit)
    (health_resource_applied ?shelter_unit - shelter_unit)
    (shade_installed ?shelter_unit - shelter_unit)
    (shade_and_bedding_validated ?shelter_unit - shelter_unit)
    (pre_activation_checks_completed ?shelter_unit - shelter_unit)
    (shelter_unit_activated ?shelter_unit - shelter_unit)
    (vaccine_batch_available ?vaccine_batch - vaccine_batch)
    (shelter_unit_linked_vaccine_batch ?shelter_unit - shelter_unit ?vaccine_batch - vaccine_batch)
    (vaccine_assigned ?shelter_unit - shelter_unit)
    (vaccine_pending_administration ?shelter_unit - shelter_unit)
    (vaccine_administered ?shelter_unit - shelter_unit)
    (shade_structure_available ?shade_structure_type - shade_structure_type)
    (shelter_unit_linked_shade ?shelter_unit - shelter_unit ?shade_structure_type - shade_structure_type)
    (care_protocol_available ?care_protocol - care_protocol)
    (care_protocol_linked ?shelter_unit - shelter_unit ?care_protocol - care_protocol)
    (cooling_equipment_available ?cooling_equipment - cooling_equipment)
    (cooling_equipment_assigned ?shelter_unit - shelter_unit ?cooling_equipment - cooling_equipment)
    (veterinarian_available ?veterinarian - veterinarian)
    (veterinarian_assigned ?shelter_unit - shelter_unit ?veterinarian - veterinarian)
    (assignment_token_available ?assignment_token - assignment_token)
    (entity_linked_assignment_token ?herd_entity - shelter_management_entity ?assignment_token - assignment_token)
    (group_bedded ?herd_group - herd_group)
    (subgroup_bedded ?herd_subgroup - herd_subgroup)
    (shelter_unit_validated ?shelter_unit - shelter_unit)
  )
  (:action register_intake
    :parameters (?herd_entity - shelter_management_entity)
    :precondition
      (and
        (not
          (intake_registered ?herd_entity)
        )
        (not
          (assignment_confirmed ?herd_entity)
        )
      )
    :effect (intake_registered ?herd_entity)
  )
  (:action assign_transport_to_entity
    :parameters (?herd_entity - shelter_management_entity ?transport_vehicle - transport_vehicle)
    :precondition
      (and
        (intake_registered ?herd_entity)
        (not
          (on_transport ?herd_entity)
        )
        (vehicle_available ?transport_vehicle)
      )
    :effect
      (and
        (on_transport ?herd_entity)
        (assigned_to_vehicle ?herd_entity ?transport_vehicle)
        (not
          (vehicle_available ?transport_vehicle)
        )
      )
  )
  (:action attach_id_tag
    :parameters (?herd_entity - shelter_management_entity ?animal_id_tag - entity_id_tag)
    :precondition
      (and
        (intake_registered ?herd_entity)
        (on_transport ?herd_entity)
        (id_tag_available ?animal_id_tag)
      )
    :effect
      (and
        (has_id_tag ?herd_entity ?animal_id_tag)
        (not
          (id_tag_available ?animal_id_tag)
        )
      )
  )
  (:action verify_id_tag
    :parameters (?herd_entity - shelter_management_entity ?animal_id_tag - entity_id_tag)
    :precondition
      (and
        (intake_registered ?herd_entity)
        (on_transport ?herd_entity)
        (has_id_tag ?herd_entity ?animal_id_tag)
        (not
          (cleared_for_processing ?herd_entity)
        )
      )
    :effect (cleared_for_processing ?herd_entity)
  )
  (:action detach_id_tag
    :parameters (?herd_entity - shelter_management_entity ?animal_id_tag - entity_id_tag)
    :precondition
      (and
        (has_id_tag ?herd_entity ?animal_id_tag)
      )
    :effect
      (and
        (id_tag_available ?animal_id_tag)
        (not
          (has_id_tag ?herd_entity ?animal_id_tag)
        )
      )
  )
  (:action assign_access_point_to_entity
    :parameters (?herd_entity - shelter_management_entity ?access_point - access_point)
    :precondition
      (and
        (cleared_for_processing ?herd_entity)
        (access_point_available ?access_point)
      )
    :effect
      (and
        (access_point_assigned ?herd_entity ?access_point)
        (not
          (access_point_available ?access_point)
        )
      )
  )
  (:action release_access_point_from_entity
    :parameters (?herd_entity - shelter_management_entity ?access_point - access_point)
    :precondition
      (and
        (access_point_assigned ?herd_entity ?access_point)
      )
    :effect
      (and
        (access_point_available ?access_point)
        (not
          (access_point_assigned ?herd_entity ?access_point)
        )
      )
  )
  (:action assign_cooling_equipment_to_unit
    :parameters (?shelter_unit - shelter_unit ?cooling_equipment - cooling_equipment)
    :precondition
      (and
        (cleared_for_processing ?shelter_unit)
        (cooling_equipment_available ?cooling_equipment)
      )
    :effect
      (and
        (cooling_equipment_assigned ?shelter_unit ?cooling_equipment)
        (not
          (cooling_equipment_available ?cooling_equipment)
        )
      )
  )
  (:action remove_cooling_equipment_from_unit
    :parameters (?shelter_unit - shelter_unit ?cooling_equipment - cooling_equipment)
    :precondition
      (and
        (cooling_equipment_assigned ?shelter_unit ?cooling_equipment)
      )
    :effect
      (and
        (cooling_equipment_available ?cooling_equipment)
        (not
          (cooling_equipment_assigned ?shelter_unit ?cooling_equipment)
        )
      )
  )
  (:action assign_veterinarian_to_unit
    :parameters (?shelter_unit - shelter_unit ?veterinarian - veterinarian)
    :precondition
      (and
        (cleared_for_processing ?shelter_unit)
        (veterinarian_available ?veterinarian)
      )
    :effect
      (and
        (veterinarian_assigned ?shelter_unit ?veterinarian)
        (not
          (veterinarian_available ?veterinarian)
        )
      )
  )
  (:action release_veterinarian_from_unit
    :parameters (?shelter_unit - shelter_unit ?veterinarian - veterinarian)
    :precondition
      (and
        (veterinarian_assigned ?shelter_unit ?veterinarian)
      )
    :effect
      (and
        (veterinarian_available ?veterinarian)
        (not
          (veterinarian_assigned ?shelter_unit ?veterinarian)
        )
      )
  )
  (:action reserve_microclimate_zone_for_group
    :parameters (?herd_group - herd_group ?microclimate_zone - microclimate_zone ?animal_id_tag - entity_id_tag)
    :precondition
      (and
        (cleared_for_processing ?herd_group)
        (has_id_tag ?herd_group ?animal_id_tag)
        (group_assigned_microclimate_zone ?herd_group ?microclimate_zone)
        (not
          (microclimate_reserved ?microclimate_zone)
        )
        (not
          (zone_prepared ?microclimate_zone)
        )
      )
    :effect (microclimate_reserved ?microclimate_zone)
  )
  (:action assign_handler_and_prepare_group
    :parameters (?herd_group - herd_group ?microclimate_zone - microclimate_zone ?access_point - access_point)
    :precondition
      (and
        (cleared_for_processing ?herd_group)
        (access_point_assigned ?herd_group ?access_point)
        (group_assigned_microclimate_zone ?herd_group ?microclimate_zone)
        (microclimate_reserved ?microclimate_zone)
        (not
          (group_bedded ?herd_group)
        )
      )
    :effect
      (and
        (group_bedded ?herd_group)
        (group_ready ?herd_group)
      )
  )
  (:action allocate_resource_and_prepare_zone
    :parameters (?herd_group - herd_group ?microclimate_zone - microclimate_zone ?resource_unit - resource_unit)
    :precondition
      (and
        (cleared_for_processing ?herd_group)
        (group_assigned_microclimate_zone ?herd_group ?microclimate_zone)
        (resource_unit_available ?resource_unit)
        (not
          (group_bedded ?herd_group)
        )
      )
    :effect
      (and
        (zone_prepared ?microclimate_zone)
        (group_bedded ?herd_group)
        (resource_assigned_to_group ?herd_group ?resource_unit)
        (not
          (resource_unit_available ?resource_unit)
        )
      )
  )
  (:action finalize_bedding_for_group
    :parameters (?herd_group - herd_group ?microclimate_zone - microclimate_zone ?animal_id_tag - entity_id_tag ?resource_unit - resource_unit)
    :precondition
      (and
        (cleared_for_processing ?herd_group)
        (has_id_tag ?herd_group ?animal_id_tag)
        (group_assigned_microclimate_zone ?herd_group ?microclimate_zone)
        (zone_prepared ?microclimate_zone)
        (resource_assigned_to_group ?herd_group ?resource_unit)
        (not
          (group_ready ?herd_group)
        )
      )
    :effect
      (and
        (microclimate_reserved ?microclimate_zone)
        (group_ready ?herd_group)
        (resource_unit_available ?resource_unit)
        (not
          (resource_assigned_to_group ?herd_group ?resource_unit)
        )
      )
  )
  (:action reserve_ventilation_zone_for_subgroup
    :parameters (?herd_subgroup - herd_subgroup ?ventilation_zone - ventilation_zone ?animal_id_tag - entity_id_tag)
    :precondition
      (and
        (cleared_for_processing ?herd_subgroup)
        (has_id_tag ?herd_subgroup ?animal_id_tag)
        (subgroup_assigned_ventilation_zone ?herd_subgroup ?ventilation_zone)
        (not
          (ventilation_reserved ?ventilation_zone)
        )
        (not
          (ventilation_prepared ?ventilation_zone)
        )
      )
    :effect (ventilation_reserved ?ventilation_zone)
  )
  (:action assign_handler_and_prepare_subgroup
    :parameters (?herd_subgroup - herd_subgroup ?ventilation_zone - ventilation_zone ?access_point - access_point)
    :precondition
      (and
        (cleared_for_processing ?herd_subgroup)
        (access_point_assigned ?herd_subgroup ?access_point)
        (subgroup_assigned_ventilation_zone ?herd_subgroup ?ventilation_zone)
        (ventilation_reserved ?ventilation_zone)
        (not
          (subgroup_bedded ?herd_subgroup)
        )
      )
    :effect
      (and
        (subgroup_bedded ?herd_subgroup)
        (subgroup_ready ?herd_subgroup)
      )
  )
  (:action allocate_resource_for_subgroup
    :parameters (?herd_subgroup - herd_subgroup ?ventilation_zone - ventilation_zone ?resource_unit - resource_unit)
    :precondition
      (and
        (cleared_for_processing ?herd_subgroup)
        (subgroup_assigned_ventilation_zone ?herd_subgroup ?ventilation_zone)
        (resource_unit_available ?resource_unit)
        (not
          (subgroup_bedded ?herd_subgroup)
        )
      )
    :effect
      (and
        (ventilation_prepared ?ventilation_zone)
        (subgroup_bedded ?herd_subgroup)
        (resource_assigned_to_subgroup ?herd_subgroup ?resource_unit)
        (not
          (resource_unit_available ?resource_unit)
        )
      )
  )
  (:action finalize_bedding_for_subgroup
    :parameters (?herd_subgroup - herd_subgroup ?ventilation_zone - ventilation_zone ?animal_id_tag - entity_id_tag ?resource_unit - resource_unit)
    :precondition
      (and
        (cleared_for_processing ?herd_subgroup)
        (has_id_tag ?herd_subgroup ?animal_id_tag)
        (subgroup_assigned_ventilation_zone ?herd_subgroup ?ventilation_zone)
        (ventilation_prepared ?ventilation_zone)
        (resource_assigned_to_subgroup ?herd_subgroup ?resource_unit)
        (not
          (subgroup_ready ?herd_subgroup)
        )
      )
    :effect
      (and
        (ventilation_reserved ?ventilation_zone)
        (subgroup_ready ?herd_subgroup)
        (resource_unit_available ?resource_unit)
        (not
          (resource_assigned_to_subgroup ?herd_subgroup ?resource_unit)
        )
      )
  )
  (:action reserve_and_provision_shelter_bay
    :parameters (?herd_group - herd_group ?herd_subgroup - herd_subgroup ?microclimate_zone - microclimate_zone ?ventilation_zone - ventilation_zone ?shelter_bay - shelter_bay)
    :precondition
      (and
        (group_bedded ?herd_group)
        (subgroup_bedded ?herd_subgroup)
        (group_assigned_microclimate_zone ?herd_group ?microclimate_zone)
        (subgroup_assigned_ventilation_zone ?herd_subgroup ?ventilation_zone)
        (microclimate_reserved ?microclimate_zone)
        (ventilation_reserved ?ventilation_zone)
        (group_ready ?herd_group)
        (subgroup_ready ?herd_subgroup)
        (shelter_bay_available ?shelter_bay)
      )
    :effect
      (and
        (shelter_bay_reserved ?shelter_bay)
        (bay_microclimate_link ?shelter_bay ?microclimate_zone)
        (bay_ventilation_link ?shelter_bay ?ventilation_zone)
        (not
          (shelter_bay_available ?shelter_bay)
        )
      )
  )
  (:action reserve_and_provision_bay_with_bedding
    :parameters (?herd_group - herd_group ?herd_subgroup - herd_subgroup ?microclimate_zone - microclimate_zone ?ventilation_zone - ventilation_zone ?shelter_bay - shelter_bay)
    :precondition
      (and
        (group_bedded ?herd_group)
        (subgroup_bedded ?herd_subgroup)
        (group_assigned_microclimate_zone ?herd_group ?microclimate_zone)
        (subgroup_assigned_ventilation_zone ?herd_subgroup ?ventilation_zone)
        (zone_prepared ?microclimate_zone)
        (ventilation_reserved ?ventilation_zone)
        (not
          (group_ready ?herd_group)
        )
        (subgroup_ready ?herd_subgroup)
        (shelter_bay_available ?shelter_bay)
      )
    :effect
      (and
        (shelter_bay_reserved ?shelter_bay)
        (bay_microclimate_link ?shelter_bay ?microclimate_zone)
        (bay_ventilation_link ?shelter_bay ?ventilation_zone)
        (bay_bedding_installed ?shelter_bay)
        (not
          (shelter_bay_available ?shelter_bay)
        )
      )
  )
  (:action reserve_and_provision_bay_with_cooling
    :parameters (?herd_group - herd_group ?herd_subgroup - herd_subgroup ?microclimate_zone - microclimate_zone ?ventilation_zone - ventilation_zone ?shelter_bay - shelter_bay)
    :precondition
      (and
        (group_bedded ?herd_group)
        (subgroup_bedded ?herd_subgroup)
        (group_assigned_microclimate_zone ?herd_group ?microclimate_zone)
        (subgroup_assigned_ventilation_zone ?herd_subgroup ?ventilation_zone)
        (microclimate_reserved ?microclimate_zone)
        (ventilation_prepared ?ventilation_zone)
        (group_ready ?herd_group)
        (not
          (subgroup_ready ?herd_subgroup)
        )
        (shelter_bay_available ?shelter_bay)
      )
    :effect
      (and
        (shelter_bay_reserved ?shelter_bay)
        (bay_microclimate_link ?shelter_bay ?microclimate_zone)
        (bay_ventilation_link ?shelter_bay ?ventilation_zone)
        (bay_cooling_provisioned ?shelter_bay)
        (not
          (shelter_bay_available ?shelter_bay)
        )
      )
  )
  (:action reserve_and_provision_bay_fully_equipped
    :parameters (?herd_group - herd_group ?herd_subgroup - herd_subgroup ?microclimate_zone - microclimate_zone ?ventilation_zone - ventilation_zone ?shelter_bay - shelter_bay)
    :precondition
      (and
        (group_bedded ?herd_group)
        (subgroup_bedded ?herd_subgroup)
        (group_assigned_microclimate_zone ?herd_group ?microclimate_zone)
        (subgroup_assigned_ventilation_zone ?herd_subgroup ?ventilation_zone)
        (zone_prepared ?microclimate_zone)
        (ventilation_prepared ?ventilation_zone)
        (not
          (group_ready ?herd_group)
        )
        (not
          (subgroup_ready ?herd_subgroup)
        )
        (shelter_bay_available ?shelter_bay)
      )
    :effect
      (and
        (shelter_bay_reserved ?shelter_bay)
        (bay_microclimate_link ?shelter_bay ?microclimate_zone)
        (bay_ventilation_link ?shelter_bay ?ventilation_zone)
        (bay_bedding_installed ?shelter_bay)
        (bay_cooling_provisioned ?shelter_bay)
        (not
          (shelter_bay_available ?shelter_bay)
        )
      )
  )
  (:action mark_shelter_bay_prepared
    :parameters (?shelter_bay - shelter_bay ?herd_group - herd_group ?animal_id_tag - entity_id_tag)
    :precondition
      (and
        (shelter_bay_reserved ?shelter_bay)
        (group_bedded ?herd_group)
        (has_id_tag ?herd_group ?animal_id_tag)
        (not
          (bay_final_prepared ?shelter_bay)
        )
      )
    :effect (bay_final_prepared ?shelter_bay)
  )
  (:action assign_bedding_to_bay
    :parameters (?shelter_unit - shelter_unit ?bedding_unit - bedding_unit ?shelter_bay - shelter_bay)
    :precondition
      (and
        (cleared_for_processing ?shelter_unit)
        (shelter_unit_contains_bay ?shelter_unit ?shelter_bay)
        (shelter_unit_has_bedding ?shelter_unit ?bedding_unit)
        (bedding_unit_available ?bedding_unit)
        (shelter_bay_reserved ?shelter_bay)
        (bay_final_prepared ?shelter_bay)
        (not
          (bedding_assigned ?bedding_unit)
        )
      )
    :effect
      (and
        (bedding_assigned ?bedding_unit)
        (bedding_assigned_to_bay ?bedding_unit ?shelter_bay)
        (not
          (bedding_unit_available ?bedding_unit)
        )
      )
  )
  (:action install_bedding_on_unit
    :parameters (?shelter_unit - shelter_unit ?bedding_unit - bedding_unit ?shelter_bay - shelter_bay ?animal_id_tag - entity_id_tag)
    :precondition
      (and
        (cleared_for_processing ?shelter_unit)
        (shelter_unit_has_bedding ?shelter_unit ?bedding_unit)
        (bedding_assigned ?bedding_unit)
        (bedding_assigned_to_bay ?bedding_unit ?shelter_bay)
        (has_id_tag ?shelter_unit ?animal_id_tag)
        (not
          (bay_bedding_installed ?shelter_bay)
        )
        (not
          (shelter_unit_bedding_installed ?shelter_unit)
        )
      )
    :effect (shelter_unit_bedding_installed ?shelter_unit)
  )
  (:action assign_shade_structure_to_unit
    :parameters (?shelter_unit - shelter_unit ?shade_structure_type - shade_structure_type)
    :precondition
      (and
        (cleared_for_processing ?shelter_unit)
        (shade_structure_available ?shade_structure_type)
        (not
          (shade_installed ?shelter_unit)
        )
      )
    :effect
      (and
        (shade_installed ?shelter_unit)
        (shelter_unit_linked_shade ?shelter_unit ?shade_structure_type)
        (not
          (shade_structure_available ?shade_structure_type)
        )
      )
  )
  (:action install_shade_and_validate_unit
    :parameters (?shelter_unit - shelter_unit ?bedding_unit - bedding_unit ?shelter_bay - shelter_bay ?animal_id_tag - entity_id_tag ?shade_structure_type - shade_structure_type)
    :precondition
      (and
        (cleared_for_processing ?shelter_unit)
        (shelter_unit_has_bedding ?shelter_unit ?bedding_unit)
        (bedding_assigned ?bedding_unit)
        (bedding_assigned_to_bay ?bedding_unit ?shelter_bay)
        (has_id_tag ?shelter_unit ?animal_id_tag)
        (bay_bedding_installed ?shelter_bay)
        (shade_installed ?shelter_unit)
        (shelter_unit_linked_shade ?shelter_unit ?shade_structure_type)
        (not
          (shelter_unit_bedding_installed ?shelter_unit)
        )
      )
    :effect
      (and
        (shelter_unit_bedding_installed ?shelter_unit)
        (shade_and_bedding_validated ?shelter_unit)
      )
  )
  (:action install_cooling_and_prepare_unit
    :parameters (?shelter_unit - shelter_unit ?cooling_equipment - cooling_equipment ?access_point - access_point ?bedding_unit - bedding_unit ?shelter_bay - shelter_bay)
    :precondition
      (and
        (shelter_unit_bedding_installed ?shelter_unit)
        (cooling_equipment_assigned ?shelter_unit ?cooling_equipment)
        (access_point_assigned ?shelter_unit ?access_point)
        (shelter_unit_has_bedding ?shelter_unit ?bedding_unit)
        (bedding_assigned_to_bay ?bedding_unit ?shelter_bay)
        (not
          (bay_cooling_provisioned ?shelter_bay)
        )
        (not
          (shelter_unit_cooling_installed ?shelter_unit)
        )
      )
    :effect (shelter_unit_cooling_installed ?shelter_unit)
  )
  (:action install_additional_cooling_and_prepare_unit
    :parameters (?shelter_unit - shelter_unit ?cooling_equipment - cooling_equipment ?access_point - access_point ?bedding_unit - bedding_unit ?shelter_bay - shelter_bay)
    :precondition
      (and
        (shelter_unit_bedding_installed ?shelter_unit)
        (cooling_equipment_assigned ?shelter_unit ?cooling_equipment)
        (access_point_assigned ?shelter_unit ?access_point)
        (shelter_unit_has_bedding ?shelter_unit ?bedding_unit)
        (bedding_assigned_to_bay ?bedding_unit ?shelter_bay)
        (bay_cooling_provisioned ?shelter_bay)
        (not
          (shelter_unit_cooling_installed ?shelter_unit)
        )
      )
    :effect (shelter_unit_cooling_installed ?shelter_unit)
  )
  (:action perform_veterinary_procedure_variant1
    :parameters (?shelter_unit - shelter_unit ?veterinarian - veterinarian ?bedding_unit - bedding_unit ?shelter_bay - shelter_bay)
    :precondition
      (and
        (shelter_unit_cooling_installed ?shelter_unit)
        (veterinarian_assigned ?shelter_unit ?veterinarian)
        (shelter_unit_has_bedding ?shelter_unit ?bedding_unit)
        (bedding_assigned_to_bay ?bedding_unit ?shelter_bay)
        (not
          (bay_bedding_installed ?shelter_bay)
        )
        (not
          (bay_cooling_provisioned ?shelter_bay)
        )
        (not
          (health_resource_applied ?shelter_unit)
        )
      )
    :effect (health_resource_applied ?shelter_unit)
  )
  (:action perform_veterinary_procedure_variant2
    :parameters (?shelter_unit - shelter_unit ?veterinarian - veterinarian ?bedding_unit - bedding_unit ?shelter_bay - shelter_bay)
    :precondition
      (and
        (shelter_unit_cooling_installed ?shelter_unit)
        (veterinarian_assigned ?shelter_unit ?veterinarian)
        (shelter_unit_has_bedding ?shelter_unit ?bedding_unit)
        (bedding_assigned_to_bay ?bedding_unit ?shelter_bay)
        (bay_bedding_installed ?shelter_bay)
        (not
          (bay_cooling_provisioned ?shelter_bay)
        )
        (not
          (health_resource_applied ?shelter_unit)
        )
      )
    :effect
      (and
        (health_resource_applied ?shelter_unit)
        (pre_activation_checks_completed ?shelter_unit)
      )
  )
  (:action perform_veterinary_procedure_variant3
    :parameters (?shelter_unit - shelter_unit ?veterinarian - veterinarian ?bedding_unit - bedding_unit ?shelter_bay - shelter_bay)
    :precondition
      (and
        (shelter_unit_cooling_installed ?shelter_unit)
        (veterinarian_assigned ?shelter_unit ?veterinarian)
        (shelter_unit_has_bedding ?shelter_unit ?bedding_unit)
        (bedding_assigned_to_bay ?bedding_unit ?shelter_bay)
        (not
          (bay_bedding_installed ?shelter_bay)
        )
        (bay_cooling_provisioned ?shelter_bay)
        (not
          (health_resource_applied ?shelter_unit)
        )
      )
    :effect
      (and
        (health_resource_applied ?shelter_unit)
        (pre_activation_checks_completed ?shelter_unit)
      )
  )
  (:action perform_veterinary_procedure_variant4
    :parameters (?shelter_unit - shelter_unit ?veterinarian - veterinarian ?bedding_unit - bedding_unit ?shelter_bay - shelter_bay)
    :precondition
      (and
        (shelter_unit_cooling_installed ?shelter_unit)
        (veterinarian_assigned ?shelter_unit ?veterinarian)
        (shelter_unit_has_bedding ?shelter_unit ?bedding_unit)
        (bedding_assigned_to_bay ?bedding_unit ?shelter_bay)
        (bay_bedding_installed ?shelter_bay)
        (bay_cooling_provisioned ?shelter_bay)
        (not
          (health_resource_applied ?shelter_unit)
        )
      )
    :effect
      (and
        (health_resource_applied ?shelter_unit)
        (pre_activation_checks_completed ?shelter_unit)
      )
  )
  (:action validate_unit_and_mark_ready_for_occupancy
    :parameters (?shelter_unit - shelter_unit)
    :precondition
      (and
        (health_resource_applied ?shelter_unit)
        (not
          (pre_activation_checks_completed ?shelter_unit)
        )
        (not
          (shelter_unit_validated ?shelter_unit)
        )
      )
    :effect
      (and
        (shelter_unit_validated ?shelter_unit)
        (ready_to_receive ?shelter_unit)
      )
  )
  (:action assign_care_protocol_to_unit
    :parameters (?shelter_unit - shelter_unit ?care_protocol - care_protocol)
    :precondition
      (and
        (health_resource_applied ?shelter_unit)
        (pre_activation_checks_completed ?shelter_unit)
        (care_protocol_available ?care_protocol)
      )
    :effect
      (and
        (care_protocol_linked ?shelter_unit ?care_protocol)
        (not
          (care_protocol_available ?care_protocol)
        )
      )
  )
  (:action activate_unit_for_occupancy
    :parameters (?shelter_unit - shelter_unit ?herd_group - herd_group ?herd_subgroup - herd_subgroup ?animal_id_tag - entity_id_tag ?care_protocol - care_protocol)
    :precondition
      (and
        (health_resource_applied ?shelter_unit)
        (pre_activation_checks_completed ?shelter_unit)
        (care_protocol_linked ?shelter_unit ?care_protocol)
        (shelter_unit_linked_group ?shelter_unit ?herd_group)
        (shelter_unit_linked_subgroup ?shelter_unit ?herd_subgroup)
        (group_ready ?herd_group)
        (subgroup_ready ?herd_subgroup)
        (has_id_tag ?shelter_unit ?animal_id_tag)
        (not
          (shelter_unit_activated ?shelter_unit)
        )
      )
    :effect (shelter_unit_activated ?shelter_unit)
  )
  (:action finalize_unit_activation
    :parameters (?shelter_unit - shelter_unit)
    :precondition
      (and
        (health_resource_applied ?shelter_unit)
        (shelter_unit_activated ?shelter_unit)
        (not
          (shelter_unit_validated ?shelter_unit)
        )
      )
    :effect
      (and
        (shelter_unit_validated ?shelter_unit)
        (ready_to_receive ?shelter_unit)
      )
  )
  (:action assign_vaccine_to_unit
    :parameters (?shelter_unit - shelter_unit ?vaccine_batch - vaccine_batch ?animal_id_tag - entity_id_tag)
    :precondition
      (and
        (cleared_for_processing ?shelter_unit)
        (has_id_tag ?shelter_unit ?animal_id_tag)
        (vaccine_batch_available ?vaccine_batch)
        (shelter_unit_linked_vaccine_batch ?shelter_unit ?vaccine_batch)
        (not
          (vaccine_assigned ?shelter_unit)
        )
      )
    :effect
      (and
        (vaccine_assigned ?shelter_unit)
        (not
          (vaccine_batch_available ?vaccine_batch)
        )
      )
  )
  (:action prepare_vaccine_administration
    :parameters (?shelter_unit - shelter_unit ?access_point - access_point)
    :precondition
      (and
        (vaccine_assigned ?shelter_unit)
        (access_point_assigned ?shelter_unit ?access_point)
        (not
          (vaccine_pending_administration ?shelter_unit)
        )
      )
    :effect (vaccine_pending_administration ?shelter_unit)
  )
  (:action administer_vaccine_to_unit
    :parameters (?shelter_unit - shelter_unit ?veterinarian - veterinarian)
    :precondition
      (and
        (vaccine_pending_administration ?shelter_unit)
        (veterinarian_assigned ?shelter_unit ?veterinarian)
        (not
          (vaccine_administered ?shelter_unit)
        )
      )
    :effect (vaccine_administered ?shelter_unit)
  )
  (:action finalize_vaccine_administration
    :parameters (?shelter_unit - shelter_unit)
    :precondition
      (and
        (vaccine_administered ?shelter_unit)
        (not
          (shelter_unit_validated ?shelter_unit)
        )
      )
    :effect
      (and
        (shelter_unit_validated ?shelter_unit)
        (ready_to_receive ?shelter_unit)
      )
  )
  (:action assign_group_to_bay
    :parameters (?herd_group - herd_group ?shelter_bay - shelter_bay)
    :precondition
      (and
        (group_bedded ?herd_group)
        (group_ready ?herd_group)
        (shelter_bay_reserved ?shelter_bay)
        (bay_final_prepared ?shelter_bay)
        (not
          (ready_to_receive ?herd_group)
        )
      )
    :effect (ready_to_receive ?herd_group)
  )
  (:action assign_subgroup_to_bay
    :parameters (?herd_subgroup - herd_subgroup ?shelter_bay - shelter_bay)
    :precondition
      (and
        (subgroup_bedded ?herd_subgroup)
        (subgroup_ready ?herd_subgroup)
        (shelter_bay_reserved ?shelter_bay)
        (bay_final_prepared ?shelter_bay)
        (not
          (ready_to_receive ?herd_subgroup)
        )
      )
    :effect (ready_to_receive ?herd_subgroup)
  )
  (:action assign_assignment_token_to_entity
    :parameters (?herd_entity - shelter_management_entity ?assignment_token - assignment_token ?animal_id_tag - entity_id_tag)
    :precondition
      (and
        (ready_to_receive ?herd_entity)
        (has_id_tag ?herd_entity ?animal_id_tag)
        (assignment_token_available ?assignment_token)
        (not
          (assignment_ready ?herd_entity)
        )
      )
    :effect
      (and
        (assignment_ready ?herd_entity)
        (entity_linked_assignment_token ?herd_entity ?assignment_token)
        (not
          (assignment_token_available ?assignment_token)
        )
      )
  )
  (:action finalize_assignment_and_release_resources
    :parameters (?herd_group - herd_group ?transport_vehicle - transport_vehicle ?assignment_token - assignment_token)
    :precondition
      (and
        (assignment_ready ?herd_group)
        (assigned_to_vehicle ?herd_group ?transport_vehicle)
        (entity_linked_assignment_token ?herd_group ?assignment_token)
        (not
          (assignment_confirmed ?herd_group)
        )
      )
    :effect
      (and
        (assignment_confirmed ?herd_group)
        (vehicle_available ?transport_vehicle)
        (assignment_token_available ?assignment_token)
      )
  )
  (:action finalize_assignment_and_release_resources_subgroup
    :parameters (?herd_subgroup - herd_subgroup ?transport_vehicle - transport_vehicle ?assignment_token - assignment_token)
    :precondition
      (and
        (assignment_ready ?herd_subgroup)
        (assigned_to_vehicle ?herd_subgroup ?transport_vehicle)
        (entity_linked_assignment_token ?herd_subgroup ?assignment_token)
        (not
          (assignment_confirmed ?herd_subgroup)
        )
      )
    :effect
      (and
        (assignment_confirmed ?herd_subgroup)
        (vehicle_available ?transport_vehicle)
        (assignment_token_available ?assignment_token)
      )
  )
  (:action finalize_assignment_and_release_resources_unit
    :parameters (?shelter_unit - shelter_unit ?transport_vehicle - transport_vehicle ?assignment_token - assignment_token)
    :precondition
      (and
        (assignment_ready ?shelter_unit)
        (assigned_to_vehicle ?shelter_unit ?transport_vehicle)
        (entity_linked_assignment_token ?shelter_unit ?assignment_token)
        (not
          (assignment_confirmed ?shelter_unit)
        )
      )
    :effect
      (and
        (assignment_confirmed ?shelter_unit)
        (vehicle_available ?transport_vehicle)
        (assignment_token_available ?assignment_token)
      )
  )
)

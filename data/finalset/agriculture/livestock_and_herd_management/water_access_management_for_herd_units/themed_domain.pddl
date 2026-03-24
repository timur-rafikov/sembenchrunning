(define (domain livestock_water_access_management)
  (:requirements :strips :typing :negative-preconditions)
  (:types stationary_resource - object portable_resource - object patch_or_transport - object herd_management_entity - object herd_unit - herd_management_entity water_point - stationary_resource watering_window - stationary_resource handler - stationary_resource maintenance_tool - stationary_resource resource_ticket - stationary_resource water_quality_kit - stationary_resource medication_pack - stationary_resource sterilization_record - stationary_resource portable_equipment - portable_resource additive_batch - portable_resource authorization_token - portable_resource source_patch - patch_or_transport destination_patch - patch_or_transport water_transport_unit - patch_or_transport cohort_representative_group - herd_unit herd_record_group - herd_unit adult_cohort_representative - cohort_representative_group juvenile_cohort_representative - cohort_representative_group herd_record - herd_record_group)
  (:predicates
    (herd_registered ?herd_unit - herd_unit)
    (entity_watering_authorized ?herd_unit - herd_unit)
    (waterpoint_reserved ?herd_unit - herd_unit)
    (water_access_granted ?herd_unit - herd_unit)
    (entity_hydration_confirmed ?herd_unit - herd_unit)
    (access_approval_issued ?herd_unit - herd_unit)
    (water_point_available ?water_point - water_point)
    (entity_assigned_water_point ?herd_unit - herd_unit ?water_point - water_point)
    (watering_window_available ?watering_window - watering_window)
    (entity_assigned_watering_window ?herd_unit - herd_unit ?watering_window - watering_window)
    (handler_available ?handler - handler)
    (handler_assigned ?herd_unit - herd_unit ?handler - handler)
    (portable_equipment_available ?portable_equipment - portable_equipment)
    (adult_rep_assigned_equipment ?adult_cohort_representative - adult_cohort_representative ?portable_equipment - portable_equipment)
    (juvenile_rep_assigned_equipment ?juvenile_cohort_representative - juvenile_cohort_representative ?portable_equipment - portable_equipment)
    (adult_rep_at_source_patch ?adult_cohort_representative - adult_cohort_representative ?source_patch - source_patch)
    (source_patch_ready ?source_patch - source_patch)
    (source_patch_treated ?source_patch - source_patch)
    (adult_cohort_watered ?adult_cohort_representative - adult_cohort_representative)
    (juvenile_rep_at_destination_patch ?juvenile_cohort_representative - juvenile_cohort_representative ?destination_patch - destination_patch)
    (destination_patch_ready ?destination_patch - destination_patch)
    (destination_patch_treated ?destination_patch - destination_patch)
    (juvenile_cohort_watered ?juvenile_cohort_representative - juvenile_cohort_representative)
    (transport_unit_available ?water_transport_unit - water_transport_unit)
    (transport_unit_prepared ?water_transport_unit - water_transport_unit)
    (transport_unit_assigned_source_patch ?water_transport_unit - water_transport_unit ?source_patch - source_patch)
    (transport_unit_assigned_destination_patch ?water_transport_unit - water_transport_unit ?destination_patch - destination_patch)
    (transport_unit_source_ready ?water_transport_unit - water_transport_unit)
    (transport_unit_destination_ready ?water_transport_unit - water_transport_unit)
    (transport_unit_ready_for_transfer ?water_transport_unit - water_transport_unit)
    (record_has_adult_rep ?herd_operational_record - herd_record ?adult_cohort_representative - adult_cohort_representative)
    (record_has_juvenile_rep ?herd_operational_record - herd_record ?juvenile_cohort_representative - juvenile_cohort_representative)
    (record_has_transport_unit ?herd_operational_record - herd_record ?water_transport_unit - water_transport_unit)
    (additive_batch_available ?additive_batch - additive_batch)
    (record_has_additive_batch ?herd_operational_record - herd_record ?additive_batch - additive_batch)
    (additive_batch_certified ?additive_batch - additive_batch)
    (additive_batch_loaded_on_transport_unit ?additive_batch - additive_batch ?water_transport_unit - water_transport_unit)
    (record_prepared ?herd_operational_record - herd_record)
    (additive_application_recorded ?herd_operational_record - herd_record)
    (inspection_completed ?herd_operational_record - herd_record)
    (maintenance_token_issued ?herd_operational_record - herd_record)
    (inspection_logged ?herd_operational_record - herd_record)
    (inspection_approved ?herd_operational_record - herd_record)
    (watering_event_executed ?herd_operational_record - herd_record)
    (authorization_token_available ?authorization_token - authorization_token)
    (record_has_authorization_token ?herd_operational_record - herd_record ?authorization_token - authorization_token)
    (record_authorized ?herd_operational_record - herd_record)
    (sterilization_scheduled ?herd_operational_record - herd_record)
    (sterilization_completed ?herd_operational_record - herd_record)
    (maintenance_tool_available ?maintenance_tool - maintenance_tool)
    (record_has_maintenance_tool ?herd_operational_record - herd_record ?maintenance_tool - maintenance_tool)
    (resource_ticket_available ?resource_ticket - resource_ticket)
    (record_has_resource_ticket ?herd_operational_record - herd_record ?resource_ticket - resource_ticket)
    (medication_pack_available ?medication_pack - medication_pack)
    (record_has_medication_pack ?herd_operational_record - herd_record ?medication_pack - medication_pack)
    (sterilization_record_available ?sterilization_record - sterilization_record)
    (record_has_sterilization_record ?herd_operational_record - herd_record ?sterilization_record - sterilization_record)
    (water_quality_kit_available ?water_quality_kit - water_quality_kit)
    (herd_assigned_quality_kit ?herd_unit - herd_unit ?water_quality_kit - water_quality_kit)
    (adult_rep_ready ?adult_cohort_representative - adult_cohort_representative)
    (juvenile_rep_ready ?juvenile_cohort_representative - juvenile_cohort_representative)
    (record_finalized ?herd_operational_record - herd_record)
  )
  (:action register_herd_unit
    :parameters (?herd_unit - herd_unit)
    :precondition
      (and
        (not
          (herd_registered ?herd_unit)
        )
        (not
          (water_access_granted ?herd_unit)
        )
      )
    :effect (herd_registered ?herd_unit)
  )
  (:action reserve_water_point_for_herd
    :parameters (?herd_unit - herd_unit ?water_point - water_point)
    :precondition
      (and
        (herd_registered ?herd_unit)
        (not
          (waterpoint_reserved ?herd_unit)
        )
        (water_point_available ?water_point)
      )
    :effect
      (and
        (waterpoint_reserved ?herd_unit)
        (entity_assigned_water_point ?herd_unit ?water_point)
        (not
          (water_point_available ?water_point)
        )
      )
  )
  (:action assign_watering_window
    :parameters (?herd_unit - herd_unit ?watering_window - watering_window)
    :precondition
      (and
        (herd_registered ?herd_unit)
        (waterpoint_reserved ?herd_unit)
        (watering_window_available ?watering_window)
      )
    :effect
      (and
        (entity_assigned_watering_window ?herd_unit ?watering_window)
        (not
          (watering_window_available ?watering_window)
        )
      )
  )
  (:action confirm_watering_event
    :parameters (?herd_unit - herd_unit ?watering_window - watering_window)
    :precondition
      (and
        (herd_registered ?herd_unit)
        (waterpoint_reserved ?herd_unit)
        (entity_assigned_watering_window ?herd_unit ?watering_window)
        (not
          (entity_watering_authorized ?herd_unit)
        )
      )
    :effect (entity_watering_authorized ?herd_unit)
  )
  (:action release_watering_window
    :parameters (?herd_unit - herd_unit ?watering_window - watering_window)
    :precondition
      (and
        (entity_assigned_watering_window ?herd_unit ?watering_window)
      )
    :effect
      (and
        (watering_window_available ?watering_window)
        (not
          (entity_assigned_watering_window ?herd_unit ?watering_window)
        )
      )
  )
  (:action assign_handler_to_herd
    :parameters (?herd_unit - herd_unit ?handler - handler)
    :precondition
      (and
        (entity_watering_authorized ?herd_unit)
        (handler_available ?handler)
      )
    :effect
      (and
        (handler_assigned ?herd_unit ?handler)
        (not
          (handler_available ?handler)
        )
      )
  )
  (:action release_handler_from_herd
    :parameters (?herd_unit - herd_unit ?handler - handler)
    :precondition
      (and
        (handler_assigned ?herd_unit ?handler)
      )
    :effect
      (and
        (handler_available ?handler)
        (not
          (handler_assigned ?herd_unit ?handler)
        )
      )
  )
  (:action assign_medication_pack_to_record
    :parameters (?herd_operational_record - herd_record ?medication_pack - medication_pack)
    :precondition
      (and
        (entity_watering_authorized ?herd_operational_record)
        (medication_pack_available ?medication_pack)
      )
    :effect
      (and
        (record_has_medication_pack ?herd_operational_record ?medication_pack)
        (not
          (medication_pack_available ?medication_pack)
        )
      )
  )
  (:action remove_medication_pack_from_record
    :parameters (?herd_operational_record - herd_record ?medication_pack - medication_pack)
    :precondition
      (and
        (record_has_medication_pack ?herd_operational_record ?medication_pack)
      )
    :effect
      (and
        (medication_pack_available ?medication_pack)
        (not
          (record_has_medication_pack ?herd_operational_record ?medication_pack)
        )
      )
  )
  (:action assign_sterilization_record_to_record
    :parameters (?herd_operational_record - herd_record ?sterilization_record - sterilization_record)
    :precondition
      (and
        (entity_watering_authorized ?herd_operational_record)
        (sterilization_record_available ?sterilization_record)
      )
    :effect
      (and
        (record_has_sterilization_record ?herd_operational_record ?sterilization_record)
        (not
          (sterilization_record_available ?sterilization_record)
        )
      )
  )
  (:action remove_sterilization_record_from_record
    :parameters (?herd_operational_record - herd_record ?sterilization_record - sterilization_record)
    :precondition
      (and
        (record_has_sterilization_record ?herd_operational_record ?sterilization_record)
      )
    :effect
      (and
        (sterilization_record_available ?sterilization_record)
        (not
          (record_has_sterilization_record ?herd_operational_record ?sterilization_record)
        )
      )
  )
  (:action prepare_source_patch_for_adult_cohort
    :parameters (?adult_cohort_representative - adult_cohort_representative ?source_patch - source_patch ?watering_window - watering_window)
    :precondition
      (and
        (entity_watering_authorized ?adult_cohort_representative)
        (entity_assigned_watering_window ?adult_cohort_representative ?watering_window)
        (adult_rep_at_source_patch ?adult_cohort_representative ?source_patch)
        (not
          (source_patch_ready ?source_patch)
        )
        (not
          (source_patch_treated ?source_patch)
        )
      )
    :effect (source_patch_ready ?source_patch)
  )
  (:action finalize_adult_cohort_access_with_handler
    :parameters (?adult_cohort_representative - adult_cohort_representative ?source_patch - source_patch ?handler - handler)
    :precondition
      (and
        (entity_watering_authorized ?adult_cohort_representative)
        (handler_assigned ?adult_cohort_representative ?handler)
        (adult_rep_at_source_patch ?adult_cohort_representative ?source_patch)
        (source_patch_ready ?source_patch)
        (not
          (adult_rep_ready ?adult_cohort_representative)
        )
      )
    :effect
      (and
        (adult_rep_ready ?adult_cohort_representative)
        (adult_cohort_watered ?adult_cohort_representative)
      )
  )
  (:action apply_additive_and_mark_adult_rep_ready
    :parameters (?adult_cohort_representative - adult_cohort_representative ?source_patch - source_patch ?portable_equipment - portable_equipment)
    :precondition
      (and
        (entity_watering_authorized ?adult_cohort_representative)
        (adult_rep_at_source_patch ?adult_cohort_representative ?source_patch)
        (portable_equipment_available ?portable_equipment)
        (not
          (adult_rep_ready ?adult_cohort_representative)
        )
      )
    :effect
      (and
        (source_patch_treated ?source_patch)
        (adult_rep_ready ?adult_cohort_representative)
        (adult_rep_assigned_equipment ?adult_cohort_representative ?portable_equipment)
        (not
          (portable_equipment_available ?portable_equipment)
        )
      )
  )
  (:action complete_adult_cohort_access
    :parameters (?adult_cohort_representative - adult_cohort_representative ?source_patch - source_patch ?watering_window - watering_window ?portable_equipment - portable_equipment)
    :precondition
      (and
        (entity_watering_authorized ?adult_cohort_representative)
        (entity_assigned_watering_window ?adult_cohort_representative ?watering_window)
        (adult_rep_at_source_patch ?adult_cohort_representative ?source_patch)
        (source_patch_treated ?source_patch)
        (adult_rep_assigned_equipment ?adult_cohort_representative ?portable_equipment)
        (not
          (adult_cohort_watered ?adult_cohort_representative)
        )
      )
    :effect
      (and
        (source_patch_ready ?source_patch)
        (adult_cohort_watered ?adult_cohort_representative)
        (portable_equipment_available ?portable_equipment)
        (not
          (adult_rep_assigned_equipment ?adult_cohort_representative ?portable_equipment)
        )
      )
  )
  (:action prepare_destination_patch_for_juvenile_cohort
    :parameters (?juvenile_cohort_representative - juvenile_cohort_representative ?destination_patch - destination_patch ?watering_window - watering_window)
    :precondition
      (and
        (entity_watering_authorized ?juvenile_cohort_representative)
        (entity_assigned_watering_window ?juvenile_cohort_representative ?watering_window)
        (juvenile_rep_at_destination_patch ?juvenile_cohort_representative ?destination_patch)
        (not
          (destination_patch_ready ?destination_patch)
        )
        (not
          (destination_patch_treated ?destination_patch)
        )
      )
    :effect (destination_patch_ready ?destination_patch)
  )
  (:action finalize_juvenile_cohort_access_with_handler
    :parameters (?juvenile_cohort_representative - juvenile_cohort_representative ?destination_patch - destination_patch ?handler - handler)
    :precondition
      (and
        (entity_watering_authorized ?juvenile_cohort_representative)
        (handler_assigned ?juvenile_cohort_representative ?handler)
        (juvenile_rep_at_destination_patch ?juvenile_cohort_representative ?destination_patch)
        (destination_patch_ready ?destination_patch)
        (not
          (juvenile_rep_ready ?juvenile_cohort_representative)
        )
      )
    :effect
      (and
        (juvenile_rep_ready ?juvenile_cohort_representative)
        (juvenile_cohort_watered ?juvenile_cohort_representative)
      )
  )
  (:action apply_additive_and_mark_juvenile_rep_ready
    :parameters (?juvenile_cohort_representative - juvenile_cohort_representative ?destination_patch - destination_patch ?portable_equipment - portable_equipment)
    :precondition
      (and
        (entity_watering_authorized ?juvenile_cohort_representative)
        (juvenile_rep_at_destination_patch ?juvenile_cohort_representative ?destination_patch)
        (portable_equipment_available ?portable_equipment)
        (not
          (juvenile_rep_ready ?juvenile_cohort_representative)
        )
      )
    :effect
      (and
        (destination_patch_treated ?destination_patch)
        (juvenile_rep_ready ?juvenile_cohort_representative)
        (juvenile_rep_assigned_equipment ?juvenile_cohort_representative ?portable_equipment)
        (not
          (portable_equipment_available ?portable_equipment)
        )
      )
  )
  (:action complete_juvenile_cohort_access
    :parameters (?juvenile_cohort_representative - juvenile_cohort_representative ?destination_patch - destination_patch ?watering_window - watering_window ?portable_equipment - portable_equipment)
    :precondition
      (and
        (entity_watering_authorized ?juvenile_cohort_representative)
        (entity_assigned_watering_window ?juvenile_cohort_representative ?watering_window)
        (juvenile_rep_at_destination_patch ?juvenile_cohort_representative ?destination_patch)
        (destination_patch_treated ?destination_patch)
        (juvenile_rep_assigned_equipment ?juvenile_cohort_representative ?portable_equipment)
        (not
          (juvenile_cohort_watered ?juvenile_cohort_representative)
        )
      )
    :effect
      (and
        (destination_patch_ready ?destination_patch)
        (juvenile_cohort_watered ?juvenile_cohort_representative)
        (portable_equipment_available ?portable_equipment)
        (not
          (juvenile_rep_assigned_equipment ?juvenile_cohort_representative ?portable_equipment)
        )
      )
  )
  (:action assemble_transport_unit_and_link_patches
    :parameters (?adult_cohort_representative - adult_cohort_representative ?juvenile_cohort_representative - juvenile_cohort_representative ?source_patch - source_patch ?destination_patch - destination_patch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (adult_rep_ready ?adult_cohort_representative)
        (juvenile_rep_ready ?juvenile_cohort_representative)
        (adult_rep_at_source_patch ?adult_cohort_representative ?source_patch)
        (juvenile_rep_at_destination_patch ?juvenile_cohort_representative ?destination_patch)
        (source_patch_ready ?source_patch)
        (destination_patch_ready ?destination_patch)
        (adult_cohort_watered ?adult_cohort_representative)
        (juvenile_cohort_watered ?juvenile_cohort_representative)
        (transport_unit_available ?water_transport_unit)
      )
    :effect
      (and
        (transport_unit_prepared ?water_transport_unit)
        (transport_unit_assigned_source_patch ?water_transport_unit ?source_patch)
        (transport_unit_assigned_destination_patch ?water_transport_unit ?destination_patch)
        (not
          (transport_unit_available ?water_transport_unit)
        )
      )
  )
  (:action assemble_transport_unit_with_source_treatment
    :parameters (?adult_cohort_representative - adult_cohort_representative ?juvenile_cohort_representative - juvenile_cohort_representative ?source_patch - source_patch ?destination_patch - destination_patch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (adult_rep_ready ?adult_cohort_representative)
        (juvenile_rep_ready ?juvenile_cohort_representative)
        (adult_rep_at_source_patch ?adult_cohort_representative ?source_patch)
        (juvenile_rep_at_destination_patch ?juvenile_cohort_representative ?destination_patch)
        (source_patch_treated ?source_patch)
        (destination_patch_ready ?destination_patch)
        (not
          (adult_cohort_watered ?adult_cohort_representative)
        )
        (juvenile_cohort_watered ?juvenile_cohort_representative)
        (transport_unit_available ?water_transport_unit)
      )
    :effect
      (and
        (transport_unit_prepared ?water_transport_unit)
        (transport_unit_assigned_source_patch ?water_transport_unit ?source_patch)
        (transport_unit_assigned_destination_patch ?water_transport_unit ?destination_patch)
        (transport_unit_source_ready ?water_transport_unit)
        (not
          (transport_unit_available ?water_transport_unit)
        )
      )
  )
  (:action assemble_transport_unit_with_destination_treatment
    :parameters (?adult_cohort_representative - adult_cohort_representative ?juvenile_cohort_representative - juvenile_cohort_representative ?source_patch - source_patch ?destination_patch - destination_patch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (adult_rep_ready ?adult_cohort_representative)
        (juvenile_rep_ready ?juvenile_cohort_representative)
        (adult_rep_at_source_patch ?adult_cohort_representative ?source_patch)
        (juvenile_rep_at_destination_patch ?juvenile_cohort_representative ?destination_patch)
        (source_patch_ready ?source_patch)
        (destination_patch_treated ?destination_patch)
        (adult_cohort_watered ?adult_cohort_representative)
        (not
          (juvenile_cohort_watered ?juvenile_cohort_representative)
        )
        (transport_unit_available ?water_transport_unit)
      )
    :effect
      (and
        (transport_unit_prepared ?water_transport_unit)
        (transport_unit_assigned_source_patch ?water_transport_unit ?source_patch)
        (transport_unit_assigned_destination_patch ?water_transport_unit ?destination_patch)
        (transport_unit_destination_ready ?water_transport_unit)
        (not
          (transport_unit_available ?water_transport_unit)
        )
      )
  )
  (:action assemble_transport_unit_with_full_preparation
    :parameters (?adult_cohort_representative - adult_cohort_representative ?juvenile_cohort_representative - juvenile_cohort_representative ?source_patch - source_patch ?destination_patch - destination_patch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (adult_rep_ready ?adult_cohort_representative)
        (juvenile_rep_ready ?juvenile_cohort_representative)
        (adult_rep_at_source_patch ?adult_cohort_representative ?source_patch)
        (juvenile_rep_at_destination_patch ?juvenile_cohort_representative ?destination_patch)
        (source_patch_treated ?source_patch)
        (destination_patch_treated ?destination_patch)
        (not
          (adult_cohort_watered ?adult_cohort_representative)
        )
        (not
          (juvenile_cohort_watered ?juvenile_cohort_representative)
        )
        (transport_unit_available ?water_transport_unit)
      )
    :effect
      (and
        (transport_unit_prepared ?water_transport_unit)
        (transport_unit_assigned_source_patch ?water_transport_unit ?source_patch)
        (transport_unit_assigned_destination_patch ?water_transport_unit ?destination_patch)
        (transport_unit_source_ready ?water_transport_unit)
        (transport_unit_destination_ready ?water_transport_unit)
        (not
          (transport_unit_available ?water_transport_unit)
        )
      )
  )
  (:action confirm_transport_unit_transfer_ready
    :parameters (?water_transport_unit - water_transport_unit ?adult_cohort_representative - adult_cohort_representative ?watering_window - watering_window)
    :precondition
      (and
        (transport_unit_prepared ?water_transport_unit)
        (adult_rep_ready ?adult_cohort_representative)
        (entity_assigned_watering_window ?adult_cohort_representative ?watering_window)
        (not
          (transport_unit_ready_for_transfer ?water_transport_unit)
        )
      )
    :effect (transport_unit_ready_for_transfer ?water_transport_unit)
  )
  (:action certify_additive_batch_and_load
    :parameters (?herd_operational_record - herd_record ?additive_batch - additive_batch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (entity_watering_authorized ?herd_operational_record)
        (record_has_transport_unit ?herd_operational_record ?water_transport_unit)
        (record_has_additive_batch ?herd_operational_record ?additive_batch)
        (additive_batch_available ?additive_batch)
        (transport_unit_prepared ?water_transport_unit)
        (transport_unit_ready_for_transfer ?water_transport_unit)
        (not
          (additive_batch_certified ?additive_batch)
        )
      )
    :effect
      (and
        (additive_batch_certified ?additive_batch)
        (additive_batch_loaded_on_transport_unit ?additive_batch ?water_transport_unit)
        (not
          (additive_batch_available ?additive_batch)
        )
      )
  )
  (:action activate_record_after_additive_loaded
    :parameters (?herd_operational_record - herd_record ?additive_batch - additive_batch ?water_transport_unit - water_transport_unit ?watering_window - watering_window)
    :precondition
      (and
        (entity_watering_authorized ?herd_operational_record)
        (record_has_additive_batch ?herd_operational_record ?additive_batch)
        (additive_batch_certified ?additive_batch)
        (additive_batch_loaded_on_transport_unit ?additive_batch ?water_transport_unit)
        (entity_assigned_watering_window ?herd_operational_record ?watering_window)
        (not
          (transport_unit_source_ready ?water_transport_unit)
        )
        (not
          (record_prepared ?herd_operational_record)
        )
      )
    :effect (record_prepared ?herd_operational_record)
  )
  (:action issue_maintenance_token_for_record
    :parameters (?herd_operational_record - herd_record ?maintenance_tool - maintenance_tool)
    :precondition
      (and
        (entity_watering_authorized ?herd_operational_record)
        (maintenance_tool_available ?maintenance_tool)
        (not
          (maintenance_token_issued ?herd_operational_record)
        )
      )
    :effect
      (and
        (maintenance_token_issued ?herd_operational_record)
        (record_has_maintenance_tool ?herd_operational_record ?maintenance_tool)
        (not
          (maintenance_tool_available ?maintenance_tool)
        )
      )
  )
  (:action perform_maintenance_inspection
    :parameters (?herd_operational_record - herd_record ?additive_batch - additive_batch ?water_transport_unit - water_transport_unit ?watering_window - watering_window ?maintenance_tool - maintenance_tool)
    :precondition
      (and
        (entity_watering_authorized ?herd_operational_record)
        (record_has_additive_batch ?herd_operational_record ?additive_batch)
        (additive_batch_certified ?additive_batch)
        (additive_batch_loaded_on_transport_unit ?additive_batch ?water_transport_unit)
        (entity_assigned_watering_window ?herd_operational_record ?watering_window)
        (transport_unit_source_ready ?water_transport_unit)
        (maintenance_token_issued ?herd_operational_record)
        (record_has_maintenance_tool ?herd_operational_record ?maintenance_tool)
        (not
          (record_prepared ?herd_operational_record)
        )
      )
    :effect
      (and
        (record_prepared ?herd_operational_record)
        (inspection_logged ?herd_operational_record)
      )
  )
  (:action perform_medication_step
    :parameters (?herd_operational_record - herd_record ?medication_pack - medication_pack ?handler - handler ?additive_batch - additive_batch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (record_prepared ?herd_operational_record)
        (record_has_medication_pack ?herd_operational_record ?medication_pack)
        (handler_assigned ?herd_operational_record ?handler)
        (record_has_additive_batch ?herd_operational_record ?additive_batch)
        (additive_batch_loaded_on_transport_unit ?additive_batch ?water_transport_unit)
        (not
          (transport_unit_destination_ready ?water_transport_unit)
        )
        (not
          (additive_application_recorded ?herd_operational_record)
        )
      )
    :effect (additive_application_recorded ?herd_operational_record)
  )
  (:action perform_medication_followup
    :parameters (?herd_operational_record - herd_record ?medication_pack - medication_pack ?handler - handler ?additive_batch - additive_batch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (record_prepared ?herd_operational_record)
        (record_has_medication_pack ?herd_operational_record ?medication_pack)
        (handler_assigned ?herd_operational_record ?handler)
        (record_has_additive_batch ?herd_operational_record ?additive_batch)
        (additive_batch_loaded_on_transport_unit ?additive_batch ?water_transport_unit)
        (transport_unit_destination_ready ?water_transport_unit)
        (not
          (additive_application_recorded ?herd_operational_record)
        )
      )
    :effect (additive_application_recorded ?herd_operational_record)
  )
  (:action complete_inspection_from_sterilization
    :parameters (?herd_operational_record - herd_record ?sterilization_record - sterilization_record ?additive_batch - additive_batch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (additive_application_recorded ?herd_operational_record)
        (record_has_sterilization_record ?herd_operational_record ?sterilization_record)
        (record_has_additive_batch ?herd_operational_record ?additive_batch)
        (additive_batch_loaded_on_transport_unit ?additive_batch ?water_transport_unit)
        (not
          (transport_unit_source_ready ?water_transport_unit)
        )
        (not
          (transport_unit_destination_ready ?water_transport_unit)
        )
        (not
          (inspection_completed ?herd_operational_record)
        )
      )
    :effect (inspection_completed ?herd_operational_record)
  )
  (:action approve_inspection_and_flag_ticket
    :parameters (?herd_operational_record - herd_record ?sterilization_record - sterilization_record ?additive_batch - additive_batch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (additive_application_recorded ?herd_operational_record)
        (record_has_sterilization_record ?herd_operational_record ?sterilization_record)
        (record_has_additive_batch ?herd_operational_record ?additive_batch)
        (additive_batch_loaded_on_transport_unit ?additive_batch ?water_transport_unit)
        (transport_unit_source_ready ?water_transport_unit)
        (not
          (transport_unit_destination_ready ?water_transport_unit)
        )
        (not
          (inspection_completed ?herd_operational_record)
        )
      )
    :effect
      (and
        (inspection_completed ?herd_operational_record)
        (inspection_approved ?herd_operational_record)
      )
  )
  (:action confirm_inspection_variant_one
    :parameters (?herd_operational_record - herd_record ?sterilization_record - sterilization_record ?additive_batch - additive_batch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (additive_application_recorded ?herd_operational_record)
        (record_has_sterilization_record ?herd_operational_record ?sterilization_record)
        (record_has_additive_batch ?herd_operational_record ?additive_batch)
        (additive_batch_loaded_on_transport_unit ?additive_batch ?water_transport_unit)
        (not
          (transport_unit_source_ready ?water_transport_unit)
        )
        (transport_unit_destination_ready ?water_transport_unit)
        (not
          (inspection_completed ?herd_operational_record)
        )
      )
    :effect
      (and
        (inspection_completed ?herd_operational_record)
        (inspection_approved ?herd_operational_record)
      )
  )
  (:action confirm_inspection_variant_two
    :parameters (?herd_operational_record - herd_record ?sterilization_record - sterilization_record ?additive_batch - additive_batch ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (additive_application_recorded ?herd_operational_record)
        (record_has_sterilization_record ?herd_operational_record ?sterilization_record)
        (record_has_additive_batch ?herd_operational_record ?additive_batch)
        (additive_batch_loaded_on_transport_unit ?additive_batch ?water_transport_unit)
        (transport_unit_source_ready ?water_transport_unit)
        (transport_unit_destination_ready ?water_transport_unit)
        (not
          (inspection_completed ?herd_operational_record)
        )
      )
    :effect
      (and
        (inspection_completed ?herd_operational_record)
        (inspection_approved ?herd_operational_record)
      )
  )
  (:action finalize_record_and_log_hydration
    :parameters (?herd_operational_record - herd_record)
    :precondition
      (and
        (inspection_completed ?herd_operational_record)
        (not
          (inspection_approved ?herd_operational_record)
        )
        (not
          (record_finalized ?herd_operational_record)
        )
      )
    :effect
      (and
        (record_finalized ?herd_operational_record)
        (entity_hydration_confirmed ?herd_operational_record)
      )
  )
  (:action assign_resource_ticket_to_record
    :parameters (?herd_operational_record - herd_record ?resource_ticket - resource_ticket)
    :precondition
      (and
        (inspection_completed ?herd_operational_record)
        (inspection_approved ?herd_operational_record)
        (resource_ticket_available ?resource_ticket)
      )
    :effect
      (and
        (record_has_resource_ticket ?herd_operational_record ?resource_ticket)
        (not
          (resource_ticket_available ?resource_ticket)
        )
      )
  )
  (:action execute_coordinated_watering_event
    :parameters (?herd_operational_record - herd_record ?adult_cohort_representative - adult_cohort_representative ?juvenile_cohort_representative - juvenile_cohort_representative ?watering_window - watering_window ?resource_ticket - resource_ticket)
    :precondition
      (and
        (inspection_completed ?herd_operational_record)
        (inspection_approved ?herd_operational_record)
        (record_has_resource_ticket ?herd_operational_record ?resource_ticket)
        (record_has_adult_rep ?herd_operational_record ?adult_cohort_representative)
        (record_has_juvenile_rep ?herd_operational_record ?juvenile_cohort_representative)
        (adult_cohort_watered ?adult_cohort_representative)
        (juvenile_cohort_watered ?juvenile_cohort_representative)
        (entity_assigned_watering_window ?herd_operational_record ?watering_window)
        (not
          (watering_event_executed ?herd_operational_record)
        )
      )
    :effect (watering_event_executed ?herd_operational_record)
  )
  (:action finalize_watering_event_record
    :parameters (?herd_operational_record - herd_record)
    :precondition
      (and
        (inspection_completed ?herd_operational_record)
        (watering_event_executed ?herd_operational_record)
        (not
          (record_finalized ?herd_operational_record)
        )
      )
    :effect
      (and
        (record_finalized ?herd_operational_record)
        (entity_hydration_confirmed ?herd_operational_record)
      )
  )
  (:action authorize_record_with_token
    :parameters (?herd_operational_record - herd_record ?authorization_token - authorization_token ?watering_window - watering_window)
    :precondition
      (and
        (entity_watering_authorized ?herd_operational_record)
        (entity_assigned_watering_window ?herd_operational_record ?watering_window)
        (authorization_token_available ?authorization_token)
        (record_has_authorization_token ?herd_operational_record ?authorization_token)
        (not
          (record_authorized ?herd_operational_record)
        )
      )
    :effect
      (and
        (record_authorized ?herd_operational_record)
        (not
          (authorization_token_available ?authorization_token)
        )
      )
  )
  (:action schedule_sterilization_for_record
    :parameters (?herd_operational_record - herd_record ?handler - handler)
    :precondition
      (and
        (record_authorized ?herd_operational_record)
        (handler_assigned ?herd_operational_record ?handler)
        (not
          (sterilization_scheduled ?herd_operational_record)
        )
      )
    :effect (sterilization_scheduled ?herd_operational_record)
  )
  (:action perform_sterilization
    :parameters (?herd_operational_record - herd_record ?sterilization_record - sterilization_record)
    :precondition
      (and
        (sterilization_scheduled ?herd_operational_record)
        (record_has_sterilization_record ?herd_operational_record ?sterilization_record)
        (not
          (sterilization_completed ?herd_operational_record)
        )
      )
    :effect (sterilization_completed ?herd_operational_record)
  )
  (:action finalize_record_post_sterilization
    :parameters (?herd_operational_record - herd_record)
    :precondition
      (and
        (sterilization_completed ?herd_operational_record)
        (not
          (record_finalized ?herd_operational_record)
        )
      )
    :effect
      (and
        (record_finalized ?herd_operational_record)
        (entity_hydration_confirmed ?herd_operational_record)
      )
  )
  (:action confirm_adult_rep_hydration
    :parameters (?adult_cohort_representative - adult_cohort_representative ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (adult_rep_ready ?adult_cohort_representative)
        (adult_cohort_watered ?adult_cohort_representative)
        (transport_unit_prepared ?water_transport_unit)
        (transport_unit_ready_for_transfer ?water_transport_unit)
        (not
          (entity_hydration_confirmed ?adult_cohort_representative)
        )
      )
    :effect (entity_hydration_confirmed ?adult_cohort_representative)
  )
  (:action confirm_juvenile_rep_hydration
    :parameters (?juvenile_cohort_representative - juvenile_cohort_representative ?water_transport_unit - water_transport_unit)
    :precondition
      (and
        (juvenile_rep_ready ?juvenile_cohort_representative)
        (juvenile_cohort_watered ?juvenile_cohort_representative)
        (transport_unit_prepared ?water_transport_unit)
        (transport_unit_ready_for_transfer ?water_transport_unit)
        (not
          (entity_hydration_confirmed ?juvenile_cohort_representative)
        )
      )
    :effect (entity_hydration_confirmed ?juvenile_cohort_representative)
  )
  (:action assign_quality_kit_and_issue_approval
    :parameters (?herd_unit - herd_unit ?water_quality_kit - water_quality_kit ?watering_window - watering_window)
    :precondition
      (and
        (entity_hydration_confirmed ?herd_unit)
        (entity_assigned_watering_window ?herd_unit ?watering_window)
        (water_quality_kit_available ?water_quality_kit)
        (not
          (access_approval_issued ?herd_unit)
        )
      )
    :effect
      (and
        (access_approval_issued ?herd_unit)
        (herd_assigned_quality_kit ?herd_unit ?water_quality_kit)
        (not
          (water_quality_kit_available ?water_quality_kit)
        )
      )
  )
  (:action grant_access_to_adult_cohort
    :parameters (?adult_cohort_representative - adult_cohort_representative ?water_point - water_point ?water_quality_kit - water_quality_kit)
    :precondition
      (and
        (access_approval_issued ?adult_cohort_representative)
        (entity_assigned_water_point ?adult_cohort_representative ?water_point)
        (herd_assigned_quality_kit ?adult_cohort_representative ?water_quality_kit)
        (not
          (water_access_granted ?adult_cohort_representative)
        )
      )
    :effect
      (and
        (water_access_granted ?adult_cohort_representative)
        (water_point_available ?water_point)
        (water_quality_kit_available ?water_quality_kit)
      )
  )
  (:action grant_access_to_juvenile_cohort
    :parameters (?juvenile_cohort_representative - juvenile_cohort_representative ?water_point - water_point ?water_quality_kit - water_quality_kit)
    :precondition
      (and
        (access_approval_issued ?juvenile_cohort_representative)
        (entity_assigned_water_point ?juvenile_cohort_representative ?water_point)
        (herd_assigned_quality_kit ?juvenile_cohort_representative ?water_quality_kit)
        (not
          (water_access_granted ?juvenile_cohort_representative)
        )
      )
    :effect
      (and
        (water_access_granted ?juvenile_cohort_representative)
        (water_point_available ?water_point)
        (water_quality_kit_available ?water_quality_kit)
      )
  )
  (:action grant_access_to_record
    :parameters (?herd_operational_record - herd_record ?water_point - water_point ?water_quality_kit - water_quality_kit)
    :precondition
      (and
        (access_approval_issued ?herd_operational_record)
        (entity_assigned_water_point ?herd_operational_record ?water_point)
        (herd_assigned_quality_kit ?herd_operational_record ?water_quality_kit)
        (not
          (water_access_granted ?herd_operational_record)
        )
      )
    :effect
      (and
        (water_access_granted ?herd_operational_record)
        (water_point_available ?water_point)
        (water_quality_kit_available ?water_quality_kit)
      )
  )
)

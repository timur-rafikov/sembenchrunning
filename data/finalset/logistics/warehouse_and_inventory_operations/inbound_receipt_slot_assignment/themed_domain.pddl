(define (domain warehouse_inbound_receipt_slot_assignment)
  (:requirements :strips :typing :negative-preconditions)
  (:types warehouse_resource_type - object equipment_category - object infrastructure_type - object location_supertype - object warehouse_entity_type - location_supertype dock_door - warehouse_resource_type staging_pallet - warehouse_resource_type operator - warehouse_resource_type label_batch - warehouse_resource_type pack_material - warehouse_resource_type inventory_record - warehouse_resource_type inspection_tool - warehouse_resource_type qc_station - warehouse_resource_type tote_or_cart - equipment_category pallet_id_tag - equipment_category authorization_badge - equipment_category forklift_path - infrastructure_type jack_path - infrastructure_type storage_location - infrastructure_type zone_type - warehouse_entity_type aisle_section_type - warehouse_entity_type forklift_team - zone_type pallet_jack_team - zone_type putaway_job - aisle_section_type)
  (:predicates
    (entity_registered ?receipt - warehouse_entity_type)
    (entity_ready_for_putaway ?receipt - warehouse_entity_type)
    (entity_allocated_to_dock ?receipt - warehouse_entity_type)
    (work_completed ?receipt - warehouse_entity_type)
    (entity_putaway_completed ?receipt - warehouse_entity_type)
    (inventory_linked ?receipt - warehouse_entity_type)
    (dock_available ?dock_door - dock_door)
    (entity_assigned_to_dock ?receipt - warehouse_entity_type ?dock_door - dock_door)
    (staging_pallet_available ?staging_pallet - staging_pallet)
    (entity_staged_on_pallet ?receipt - warehouse_entity_type ?staging_pallet - staging_pallet)
    (operator_available ?operator - operator)
    (operator_assigned_to_entity ?receipt - warehouse_entity_type ?operator - operator)
    (tote_available ?tote - tote_or_cart)
    (forklift_team_assigned_tote ?forklift_team - forklift_team ?tote - tote_or_cart)
    (jack_team_assigned_tote ?pallet_jack_team - pallet_jack_team ?tote - tote_or_cart)
    (forklift_team_assigned_path ?forklift_team - forklift_team ?forklift_path - forklift_path)
    (forklift_path_ready ?forklift_path - forklift_path)
    (forklift_path_staged ?forklift_path - forklift_path)
    (forklift_team_ready ?forklift_team - forklift_team)
    (jack_team_assigned_path ?pallet_jack_team - pallet_jack_team ?jack_path - jack_path)
    (jack_path_ready ?jack_path - jack_path)
    (jack_path_staged ?jack_path - jack_path)
    (jack_team_ready ?pallet_jack_team - pallet_jack_team)
    (storage_location_available ?storage_location - storage_location)
    (storage_location_allocated ?storage_location - storage_location)
    (storage_location_assigned_forklift_path ?storage_location - storage_location ?forklift_path - forklift_path)
    (storage_location_assigned_jack_path ?storage_location - storage_location ?jack_path - jack_path)
    (location_requires_forklift_confirmation ?storage_location - storage_location)
    (location_requires_jack_confirmation ?storage_location - storage_location)
    (location_ready_for_binding ?storage_location - storage_location)
    (putaway_job_assigned_forklift_team ?putaway_job - putaway_job ?forklift_team - forklift_team)
    (putaway_job_assigned_jack_team ?putaway_job - putaway_job ?pallet_jack_team - pallet_jack_team)
    (putaway_job_target_location ?putaway_job - putaway_job ?storage_location - storage_location)
    (pallet_tag_available ?pallet_tag - pallet_id_tag)
    (putaway_job_assigned_pallet_tag ?putaway_job - putaway_job ?pallet_tag - pallet_id_tag)
    (pallet_tag_bound ?pallet_tag - pallet_id_tag)
    (pallet_tag_bound_to_location ?pallet_tag - pallet_id_tag ?storage_location - storage_location)
    (putaway_job_validated ?putaway_job - putaway_job)
    (putaway_job_ready_for_qc ?putaway_job - putaway_job)
    (qc_passed ?putaway_job - putaway_job)
    (label_batch_assigned ?putaway_job - putaway_job)
    (label_applied ?putaway_job - putaway_job)
    (packaging_prepared ?putaway_job - putaway_job)
    (putaway_job_executed ?putaway_job - putaway_job)
    (auth_badge_available ?auth_badge - authorization_badge)
    (authorization_badge_assigned_to_job ?putaway_job - putaway_job ?auth_badge - authorization_badge)
    (job_authorized ?putaway_job - putaway_job)
    (authorization_acknowledged ?putaway_job - putaway_job)
    (authorization_completed ?putaway_job - putaway_job)
    (label_batch_available ?label_batch - label_batch)
    (putaway_job_assigned_label_batch ?putaway_job - putaway_job ?label_batch - label_batch)
    (pack_material_available ?pack_material - pack_material)
    (putaway_job_assigned_pack_material ?putaway_job - putaway_job ?pack_material - pack_material)
    (inspection_tool_available ?inspection_tool - inspection_tool)
    (putaway_job_assigned_inspection_tool ?putaway_job - putaway_job ?inspection_tool - inspection_tool)
    (qc_station_available ?qc_station - qc_station)
    (putaway_job_assigned_qc_station ?putaway_job - putaway_job ?qc_station - qc_station)
    (inventory_record_available ?inventory_record - inventory_record)
    (entity_associated_inventory_record ?receipt - warehouse_entity_type ?inventory_record - inventory_record)
    (forklift_team_prepared ?forklift_team - forklift_team)
    (jack_team_prepared ?pallet_jack_team - pallet_jack_team)
    (putaway_job_closed ?putaway_job - putaway_job)
  )
  (:action register_inbound_receipt
    :parameters (?receipt - warehouse_entity_type)
    :precondition
      (and
        (not
          (entity_registered ?receipt)
        )
        (not
          (work_completed ?receipt)
        )
      )
    :effect (entity_registered ?receipt)
  )
  (:action allocate_dock_for_receipt
    :parameters (?receipt - warehouse_entity_type ?dock_door - dock_door)
    :precondition
      (and
        (entity_registered ?receipt)
        (not
          (entity_allocated_to_dock ?receipt)
        )
        (dock_available ?dock_door)
      )
    :effect
      (and
        (entity_allocated_to_dock ?receipt)
        (entity_assigned_to_dock ?receipt ?dock_door)
        (not
          (dock_available ?dock_door)
        )
      )
  )
  (:action stage_receipt_on_pallet
    :parameters (?receipt - warehouse_entity_type ?staging_pallet - staging_pallet)
    :precondition
      (and
        (entity_registered ?receipt)
        (entity_allocated_to_dock ?receipt)
        (staging_pallet_available ?staging_pallet)
      )
    :effect
      (and
        (entity_staged_on_pallet ?receipt ?staging_pallet)
        (not
          (staging_pallet_available ?staging_pallet)
        )
      )
  )
  (:action confirm_initial_inspection
    :parameters (?receipt - warehouse_entity_type ?staging_pallet - staging_pallet)
    :precondition
      (and
        (entity_registered ?receipt)
        (entity_allocated_to_dock ?receipt)
        (entity_staged_on_pallet ?receipt ?staging_pallet)
        (not
          (entity_ready_for_putaway ?receipt)
        )
      )
    :effect (entity_ready_for_putaway ?receipt)
  )
  (:action release_staging_pallet
    :parameters (?receipt - warehouse_entity_type ?staging_pallet - staging_pallet)
    :precondition
      (and
        (entity_staged_on_pallet ?receipt ?staging_pallet)
      )
    :effect
      (and
        (staging_pallet_available ?staging_pallet)
        (not
          (entity_staged_on_pallet ?receipt ?staging_pallet)
        )
      )
  )
  (:action assign_operator_to_receipt
    :parameters (?receipt - warehouse_entity_type ?operator - operator)
    :precondition
      (and
        (entity_ready_for_putaway ?receipt)
        (operator_available ?operator)
      )
    :effect
      (and
        (operator_assigned_to_entity ?receipt ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action release_operator_from_receipt
    :parameters (?receipt - warehouse_entity_type ?operator - operator)
    :precondition
      (and
        (operator_assigned_to_entity ?receipt ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (operator_assigned_to_entity ?receipt ?operator)
        )
      )
  )
  (:action assign_inspection_tool_to_job
    :parameters (?putaway_job - putaway_job ?inspection_tool - inspection_tool)
    :precondition
      (and
        (entity_ready_for_putaway ?putaway_job)
        (inspection_tool_available ?inspection_tool)
      )
    :effect
      (and
        (putaway_job_assigned_inspection_tool ?putaway_job ?inspection_tool)
        (not
          (inspection_tool_available ?inspection_tool)
        )
      )
  )
  (:action release_inspection_tool_from_job
    :parameters (?putaway_job - putaway_job ?inspection_tool - inspection_tool)
    :precondition
      (and
        (putaway_job_assigned_inspection_tool ?putaway_job ?inspection_tool)
      )
    :effect
      (and
        (inspection_tool_available ?inspection_tool)
        (not
          (putaway_job_assigned_inspection_tool ?putaway_job ?inspection_tool)
        )
      )
  )
  (:action assign_qc_station_to_job
    :parameters (?putaway_job - putaway_job ?qc_station - qc_station)
    :precondition
      (and
        (entity_ready_for_putaway ?putaway_job)
        (qc_station_available ?qc_station)
      )
    :effect
      (and
        (putaway_job_assigned_qc_station ?putaway_job ?qc_station)
        (not
          (qc_station_available ?qc_station)
        )
      )
  )
  (:action release_qc_station_from_job
    :parameters (?putaway_job - putaway_job ?qc_station - qc_station)
    :precondition
      (and
        (putaway_job_assigned_qc_station ?putaway_job ?qc_station)
      )
    :effect
      (and
        (qc_station_available ?qc_station)
        (not
          (putaway_job_assigned_qc_station ?putaway_job ?qc_station)
        )
      )
  )
  (:action reserve_forklift_path
    :parameters (?forklift_team - forklift_team ?forklift_path - forklift_path ?staging_pallet - staging_pallet)
    :precondition
      (and
        (entity_ready_for_putaway ?forklift_team)
        (entity_staged_on_pallet ?forklift_team ?staging_pallet)
        (forklift_team_assigned_path ?forklift_team ?forklift_path)
        (not
          (forklift_path_ready ?forklift_path)
        )
        (not
          (forklift_path_staged ?forklift_path)
        )
      )
    :effect (forklift_path_ready ?forklift_path)
  )
  (:action prepare_forklift_team
    :parameters (?forklift_team - forklift_team ?forklift_path - forklift_path ?operator - operator)
    :precondition
      (and
        (entity_ready_for_putaway ?forklift_team)
        (operator_assigned_to_entity ?forklift_team ?operator)
        (forklift_team_assigned_path ?forklift_team ?forklift_path)
        (forklift_path_ready ?forklift_path)
        (not
          (forklift_team_prepared ?forklift_team)
        )
      )
    :effect
      (and
        (forklift_team_prepared ?forklift_team)
        (forklift_team_ready ?forklift_team)
      )
  )
  (:action stage_tote_for_forklift
    :parameters (?forklift_team - forklift_team ?forklift_path - forklift_path ?tote - tote_or_cart)
    :precondition
      (and
        (entity_ready_for_putaway ?forklift_team)
        (forklift_team_assigned_path ?forklift_team ?forklift_path)
        (tote_available ?tote)
        (not
          (forklift_team_prepared ?forklift_team)
        )
      )
    :effect
      (and
        (forklift_path_staged ?forklift_path)
        (forklift_team_prepared ?forklift_team)
        (forklift_team_assigned_tote ?forklift_team ?tote)
        (not
          (tote_available ?tote)
        )
      )
  )
  (:action finalize_forklift_path_staging
    :parameters (?forklift_team - forklift_team ?forklift_path - forklift_path ?staging_pallet - staging_pallet ?tote - tote_or_cart)
    :precondition
      (and
        (entity_ready_for_putaway ?forklift_team)
        (entity_staged_on_pallet ?forklift_team ?staging_pallet)
        (forklift_team_assigned_path ?forklift_team ?forklift_path)
        (forklift_path_staged ?forklift_path)
        (forklift_team_assigned_tote ?forklift_team ?tote)
        (not
          (forklift_team_ready ?forklift_team)
        )
      )
    :effect
      (and
        (forklift_path_ready ?forklift_path)
        (forklift_team_ready ?forklift_team)
        (tote_available ?tote)
        (not
          (forklift_team_assigned_tote ?forklift_team ?tote)
        )
      )
  )
  (:action reserve_jack_path
    :parameters (?pallet_jack_team - pallet_jack_team ?jack_path - jack_path ?staging_pallet - staging_pallet)
    :precondition
      (and
        (entity_ready_for_putaway ?pallet_jack_team)
        (entity_staged_on_pallet ?pallet_jack_team ?staging_pallet)
        (jack_team_assigned_path ?pallet_jack_team ?jack_path)
        (not
          (jack_path_ready ?jack_path)
        )
        (not
          (jack_path_staged ?jack_path)
        )
      )
    :effect (jack_path_ready ?jack_path)
  )
  (:action prepare_jack_team
    :parameters (?pallet_jack_team - pallet_jack_team ?jack_path - jack_path ?operator - operator)
    :precondition
      (and
        (entity_ready_for_putaway ?pallet_jack_team)
        (operator_assigned_to_entity ?pallet_jack_team ?operator)
        (jack_team_assigned_path ?pallet_jack_team ?jack_path)
        (jack_path_ready ?jack_path)
        (not
          (jack_team_prepared ?pallet_jack_team)
        )
      )
    :effect
      (and
        (jack_team_prepared ?pallet_jack_team)
        (jack_team_ready ?pallet_jack_team)
      )
  )
  (:action stage_tote_for_jack
    :parameters (?pallet_jack_team - pallet_jack_team ?jack_path - jack_path ?tote - tote_or_cart)
    :precondition
      (and
        (entity_ready_for_putaway ?pallet_jack_team)
        (jack_team_assigned_path ?pallet_jack_team ?jack_path)
        (tote_available ?tote)
        (not
          (jack_team_prepared ?pallet_jack_team)
        )
      )
    :effect
      (and
        (jack_path_staged ?jack_path)
        (jack_team_prepared ?pallet_jack_team)
        (jack_team_assigned_tote ?pallet_jack_team ?tote)
        (not
          (tote_available ?tote)
        )
      )
  )
  (:action finalize_jack_path_staging
    :parameters (?pallet_jack_team - pallet_jack_team ?jack_path - jack_path ?staging_pallet - staging_pallet ?tote - tote_or_cart)
    :precondition
      (and
        (entity_ready_for_putaway ?pallet_jack_team)
        (entity_staged_on_pallet ?pallet_jack_team ?staging_pallet)
        (jack_team_assigned_path ?pallet_jack_team ?jack_path)
        (jack_path_staged ?jack_path)
        (jack_team_assigned_tote ?pallet_jack_team ?tote)
        (not
          (jack_team_ready ?pallet_jack_team)
        )
      )
    :effect
      (and
        (jack_path_ready ?jack_path)
        (jack_team_ready ?pallet_jack_team)
        (tote_available ?tote)
        (not
          (jack_team_assigned_tote ?pallet_jack_team ?tote)
        )
      )
  )
  (:action allocate_storage_location_forklift_priority
    :parameters (?forklift_team - forklift_team ?pallet_jack_team - pallet_jack_team ?forklift_path - forklift_path ?jack_path - jack_path ?storage_location - storage_location)
    :precondition
      (and
        (forklift_team_prepared ?forklift_team)
        (jack_team_prepared ?pallet_jack_team)
        (forklift_team_assigned_path ?forklift_team ?forklift_path)
        (jack_team_assigned_path ?pallet_jack_team ?jack_path)
        (forklift_path_ready ?forklift_path)
        (jack_path_ready ?jack_path)
        (forklift_team_ready ?forklift_team)
        (jack_team_ready ?pallet_jack_team)
        (storage_location_available ?storage_location)
      )
    :effect
      (and
        (storage_location_allocated ?storage_location)
        (storage_location_assigned_forklift_path ?storage_location ?forklift_path)
        (storage_location_assigned_jack_path ?storage_location ?jack_path)
        (not
          (storage_location_available ?storage_location)
        )
      )
  )
  (:action allocate_storage_location_with_forklift_ready
    :parameters (?forklift_team - forklift_team ?pallet_jack_team - pallet_jack_team ?forklift_path - forklift_path ?jack_path - jack_path ?storage_location - storage_location)
    :precondition
      (and
        (forklift_team_prepared ?forklift_team)
        (jack_team_prepared ?pallet_jack_team)
        (forklift_team_assigned_path ?forklift_team ?forklift_path)
        (jack_team_assigned_path ?pallet_jack_team ?jack_path)
        (forklift_path_staged ?forklift_path)
        (jack_path_ready ?jack_path)
        (not
          (forklift_team_ready ?forklift_team)
        )
        (jack_team_ready ?pallet_jack_team)
        (storage_location_available ?storage_location)
      )
    :effect
      (and
        (storage_location_allocated ?storage_location)
        (storage_location_assigned_forklift_path ?storage_location ?forklift_path)
        (storage_location_assigned_jack_path ?storage_location ?jack_path)
        (location_requires_forklift_confirmation ?storage_location)
        (not
          (storage_location_available ?storage_location)
        )
      )
  )
  (:action allocate_storage_location_with_jack_ready
    :parameters (?forklift_team - forklift_team ?pallet_jack_team - pallet_jack_team ?forklift_path - forklift_path ?jack_path - jack_path ?storage_location - storage_location)
    :precondition
      (and
        (forklift_team_prepared ?forklift_team)
        (jack_team_prepared ?pallet_jack_team)
        (forklift_team_assigned_path ?forklift_team ?forklift_path)
        (jack_team_assigned_path ?pallet_jack_team ?jack_path)
        (forklift_path_ready ?forklift_path)
        (jack_path_staged ?jack_path)
        (forklift_team_ready ?forklift_team)
        (not
          (jack_team_ready ?pallet_jack_team)
        )
        (storage_location_available ?storage_location)
      )
    :effect
      (and
        (storage_location_allocated ?storage_location)
        (storage_location_assigned_forklift_path ?storage_location ?forklift_path)
        (storage_location_assigned_jack_path ?storage_location ?jack_path)
        (location_requires_jack_confirmation ?storage_location)
        (not
          (storage_location_available ?storage_location)
        )
      )
  )
  (:action allocate_storage_location_with_both_ready
    :parameters (?forklift_team - forklift_team ?pallet_jack_team - pallet_jack_team ?forklift_path - forklift_path ?jack_path - jack_path ?storage_location - storage_location)
    :precondition
      (and
        (forklift_team_prepared ?forklift_team)
        (jack_team_prepared ?pallet_jack_team)
        (forklift_team_assigned_path ?forklift_team ?forklift_path)
        (jack_team_assigned_path ?pallet_jack_team ?jack_path)
        (forklift_path_staged ?forklift_path)
        (jack_path_staged ?jack_path)
        (not
          (forklift_team_ready ?forklift_team)
        )
        (not
          (jack_team_ready ?pallet_jack_team)
        )
        (storage_location_available ?storage_location)
      )
    :effect
      (and
        (storage_location_allocated ?storage_location)
        (storage_location_assigned_forklift_path ?storage_location ?forklift_path)
        (storage_location_assigned_jack_path ?storage_location ?jack_path)
        (location_requires_forklift_confirmation ?storage_location)
        (location_requires_jack_confirmation ?storage_location)
        (not
          (storage_location_available ?storage_location)
        )
      )
  )
  (:action mark_location_ready_for_binding
    :parameters (?storage_location - storage_location ?forklift_team - forklift_team ?staging_pallet - staging_pallet)
    :precondition
      (and
        (storage_location_allocated ?storage_location)
        (forklift_team_prepared ?forklift_team)
        (entity_staged_on_pallet ?forklift_team ?staging_pallet)
        (not
          (location_ready_for_binding ?storage_location)
        )
      )
    :effect (location_ready_for_binding ?storage_location)
  )
  (:action assign_pallet_tag_to_location
    :parameters (?putaway_job - putaway_job ?pallet_tag - pallet_id_tag ?storage_location - storage_location)
    :precondition
      (and
        (entity_ready_for_putaway ?putaway_job)
        (putaway_job_target_location ?putaway_job ?storage_location)
        (putaway_job_assigned_pallet_tag ?putaway_job ?pallet_tag)
        (pallet_tag_available ?pallet_tag)
        (storage_location_allocated ?storage_location)
        (location_ready_for_binding ?storage_location)
        (not
          (pallet_tag_bound ?pallet_tag)
        )
      )
    :effect
      (and
        (pallet_tag_bound ?pallet_tag)
        (pallet_tag_bound_to_location ?pallet_tag ?storage_location)
        (not
          (pallet_tag_available ?pallet_tag)
        )
      )
  )
  (:action prepare_job_for_binding
    :parameters (?putaway_job - putaway_job ?pallet_tag - pallet_id_tag ?storage_location - storage_location ?staging_pallet - staging_pallet)
    :precondition
      (and
        (entity_ready_for_putaway ?putaway_job)
        (putaway_job_assigned_pallet_tag ?putaway_job ?pallet_tag)
        (pallet_tag_bound ?pallet_tag)
        (pallet_tag_bound_to_location ?pallet_tag ?storage_location)
        (entity_staged_on_pallet ?putaway_job ?staging_pallet)
        (not
          (location_requires_forklift_confirmation ?storage_location)
        )
        (not
          (putaway_job_validated ?putaway_job)
        )
      )
    :effect (putaway_job_validated ?putaway_job)
  )
  (:action assign_label_batch_to_job
    :parameters (?putaway_job - putaway_job ?label_batch - label_batch)
    :precondition
      (and
        (entity_ready_for_putaway ?putaway_job)
        (label_batch_available ?label_batch)
        (not
          (label_batch_assigned ?putaway_job)
        )
      )
    :effect
      (and
        (label_batch_assigned ?putaway_job)
        (putaway_job_assigned_label_batch ?putaway_job ?label_batch)
        (not
          (label_batch_available ?label_batch)
        )
      )
  )
  (:action apply_label_and_prepare_job
    :parameters (?putaway_job - putaway_job ?pallet_tag - pallet_id_tag ?storage_location - storage_location ?staging_pallet - staging_pallet ?label_batch - label_batch)
    :precondition
      (and
        (entity_ready_for_putaway ?putaway_job)
        (putaway_job_assigned_pallet_tag ?putaway_job ?pallet_tag)
        (pallet_tag_bound ?pallet_tag)
        (pallet_tag_bound_to_location ?pallet_tag ?storage_location)
        (entity_staged_on_pallet ?putaway_job ?staging_pallet)
        (location_requires_forklift_confirmation ?storage_location)
        (label_batch_assigned ?putaway_job)
        (putaway_job_assigned_label_batch ?putaway_job ?label_batch)
        (not
          (putaway_job_validated ?putaway_job)
        )
      )
    :effect
      (and
        (putaway_job_validated ?putaway_job)
        (label_applied ?putaway_job)
      )
  )
  (:action perform_container_validation_phase1
    :parameters (?putaway_job - putaway_job ?inspection_tool - inspection_tool ?operator - operator ?pallet_tag - pallet_id_tag ?storage_location - storage_location)
    :precondition
      (and
        (putaway_job_validated ?putaway_job)
        (putaway_job_assigned_inspection_tool ?putaway_job ?inspection_tool)
        (operator_assigned_to_entity ?putaway_job ?operator)
        (putaway_job_assigned_pallet_tag ?putaway_job ?pallet_tag)
        (pallet_tag_bound_to_location ?pallet_tag ?storage_location)
        (not
          (location_requires_jack_confirmation ?storage_location)
        )
        (not
          (putaway_job_ready_for_qc ?putaway_job)
        )
      )
    :effect (putaway_job_ready_for_qc ?putaway_job)
  )
  (:action perform_container_validation_phase2
    :parameters (?putaway_job - putaway_job ?inspection_tool - inspection_tool ?operator - operator ?pallet_tag - pallet_id_tag ?storage_location - storage_location)
    :precondition
      (and
        (putaway_job_validated ?putaway_job)
        (putaway_job_assigned_inspection_tool ?putaway_job ?inspection_tool)
        (operator_assigned_to_entity ?putaway_job ?operator)
        (putaway_job_assigned_pallet_tag ?putaway_job ?pallet_tag)
        (pallet_tag_bound_to_location ?pallet_tag ?storage_location)
        (location_requires_jack_confirmation ?storage_location)
        (not
          (putaway_job_ready_for_qc ?putaway_job)
        )
      )
    :effect (putaway_job_ready_for_qc ?putaway_job)
  )
  (:action qc_check_pass
    :parameters (?putaway_job - putaway_job ?qc_station - qc_station ?pallet_tag - pallet_id_tag ?storage_location - storage_location)
    :precondition
      (and
        (putaway_job_ready_for_qc ?putaway_job)
        (putaway_job_assigned_qc_station ?putaway_job ?qc_station)
        (putaway_job_assigned_pallet_tag ?putaway_job ?pallet_tag)
        (pallet_tag_bound_to_location ?pallet_tag ?storage_location)
        (not
          (location_requires_forklift_confirmation ?storage_location)
        )
        (not
          (location_requires_jack_confirmation ?storage_location)
        )
        (not
          (qc_passed ?putaway_job)
        )
      )
    :effect (qc_passed ?putaway_job)
  )
  (:action qc_check_pass_and_prepare_packaging
    :parameters (?putaway_job - putaway_job ?qc_station - qc_station ?pallet_tag - pallet_id_tag ?storage_location - storage_location)
    :precondition
      (and
        (putaway_job_ready_for_qc ?putaway_job)
        (putaway_job_assigned_qc_station ?putaway_job ?qc_station)
        (putaway_job_assigned_pallet_tag ?putaway_job ?pallet_tag)
        (pallet_tag_bound_to_location ?pallet_tag ?storage_location)
        (location_requires_forklift_confirmation ?storage_location)
        (not
          (location_requires_jack_confirmation ?storage_location)
        )
        (not
          (qc_passed ?putaway_job)
        )
      )
    :effect
      (and
        (qc_passed ?putaway_job)
        (packaging_prepared ?putaway_job)
      )
  )
  (:action qc_check_pass_and_confirm_packaging
    :parameters (?putaway_job - putaway_job ?qc_station - qc_station ?pallet_tag - pallet_id_tag ?storage_location - storage_location)
    :precondition
      (and
        (putaway_job_ready_for_qc ?putaway_job)
        (putaway_job_assigned_qc_station ?putaway_job ?qc_station)
        (putaway_job_assigned_pallet_tag ?putaway_job ?pallet_tag)
        (pallet_tag_bound_to_location ?pallet_tag ?storage_location)
        (not
          (location_requires_forklift_confirmation ?storage_location)
        )
        (location_requires_jack_confirmation ?storage_location)
        (not
          (qc_passed ?putaway_job)
        )
      )
    :effect
      (and
        (qc_passed ?putaway_job)
        (packaging_prepared ?putaway_job)
      )
  )
  (:action qc_check_pass_and_finalize_packaging
    :parameters (?putaway_job - putaway_job ?qc_station - qc_station ?pallet_tag - pallet_id_tag ?storage_location - storage_location)
    :precondition
      (and
        (putaway_job_ready_for_qc ?putaway_job)
        (putaway_job_assigned_qc_station ?putaway_job ?qc_station)
        (putaway_job_assigned_pallet_tag ?putaway_job ?pallet_tag)
        (pallet_tag_bound_to_location ?pallet_tag ?storage_location)
        (location_requires_forklift_confirmation ?storage_location)
        (location_requires_jack_confirmation ?storage_location)
        (not
          (qc_passed ?putaway_job)
        )
      )
    :effect
      (and
        (qc_passed ?putaway_job)
        (packaging_prepared ?putaway_job)
      )
  )
  (:action finalize_job_and_mark_receipt
    :parameters (?putaway_job - putaway_job)
    :precondition
      (and
        (qc_passed ?putaway_job)
        (not
          (packaging_prepared ?putaway_job)
        )
        (not
          (putaway_job_closed ?putaway_job)
        )
      )
    :effect
      (and
        (putaway_job_closed ?putaway_job)
        (entity_putaway_completed ?putaway_job)
      )
  )
  (:action assign_pack_material_to_job
    :parameters (?putaway_job - putaway_job ?pack_material - pack_material)
    :precondition
      (and
        (qc_passed ?putaway_job)
        (packaging_prepared ?putaway_job)
        (pack_material_available ?pack_material)
      )
    :effect
      (and
        (putaway_job_assigned_pack_material ?putaway_job ?pack_material)
        (not
          (pack_material_available ?pack_material)
        )
      )
  )
  (:action execute_putaway_job
    :parameters (?putaway_job - putaway_job ?forklift_team - forklift_team ?pallet_jack_team - pallet_jack_team ?staging_pallet - staging_pallet ?pack_material - pack_material)
    :precondition
      (and
        (qc_passed ?putaway_job)
        (packaging_prepared ?putaway_job)
        (putaway_job_assigned_pack_material ?putaway_job ?pack_material)
        (putaway_job_assigned_forklift_team ?putaway_job ?forklift_team)
        (putaway_job_assigned_jack_team ?putaway_job ?pallet_jack_team)
        (forklift_team_ready ?forklift_team)
        (jack_team_ready ?pallet_jack_team)
        (entity_staged_on_pallet ?putaway_job ?staging_pallet)
        (not
          (putaway_job_executed ?putaway_job)
        )
      )
    :effect (putaway_job_executed ?putaway_job)
  )
  (:action finalize_putaway_job
    :parameters (?putaway_job - putaway_job)
    :precondition
      (and
        (qc_passed ?putaway_job)
        (putaway_job_executed ?putaway_job)
        (not
          (putaway_job_closed ?putaway_job)
        )
      )
    :effect
      (and
        (putaway_job_closed ?putaway_job)
        (entity_putaway_completed ?putaway_job)
      )
  )
  (:action reserve_authorization_for_job
    :parameters (?putaway_job - putaway_job ?auth_badge - authorization_badge ?staging_pallet - staging_pallet)
    :precondition
      (and
        (entity_ready_for_putaway ?putaway_job)
        (entity_staged_on_pallet ?putaway_job ?staging_pallet)
        (auth_badge_available ?auth_badge)
        (authorization_badge_assigned_to_job ?putaway_job ?auth_badge)
        (not
          (job_authorized ?putaway_job)
        )
      )
    :effect
      (and
        (job_authorized ?putaway_job)
        (not
          (auth_badge_available ?auth_badge)
        )
      )
  )
  (:action acknowledge_authorization
    :parameters (?putaway_job - putaway_job ?operator - operator)
    :precondition
      (and
        (job_authorized ?putaway_job)
        (operator_assigned_to_entity ?putaway_job ?operator)
        (not
          (authorization_acknowledged ?putaway_job)
        )
      )
    :effect (authorization_acknowledged ?putaway_job)
  )
  (:action assign_qc_station_after_authorization
    :parameters (?putaway_job - putaway_job ?qc_station - qc_station)
    :precondition
      (and
        (authorization_acknowledged ?putaway_job)
        (putaway_job_assigned_qc_station ?putaway_job ?qc_station)
        (not
          (authorization_completed ?putaway_job)
        )
      )
    :effect (authorization_completed ?putaway_job)
  )
  (:action finalize_authorized_job
    :parameters (?putaway_job - putaway_job)
    :precondition
      (and
        (authorization_completed ?putaway_job)
        (not
          (putaway_job_closed ?putaway_job)
        )
      )
    :effect
      (and
        (putaway_job_closed ?putaway_job)
        (entity_putaway_completed ?putaway_job)
      )
  )
  (:action confirm_forklift_team_completion
    :parameters (?forklift_team - forklift_team ?storage_location - storage_location)
    :precondition
      (and
        (forklift_team_prepared ?forklift_team)
        (forklift_team_ready ?forklift_team)
        (storage_location_allocated ?storage_location)
        (location_ready_for_binding ?storage_location)
        (not
          (entity_putaway_completed ?forklift_team)
        )
      )
    :effect (entity_putaway_completed ?forklift_team)
  )
  (:action confirm_jack_team_completion
    :parameters (?pallet_jack_team - pallet_jack_team ?storage_location - storage_location)
    :precondition
      (and
        (jack_team_prepared ?pallet_jack_team)
        (jack_team_ready ?pallet_jack_team)
        (storage_location_allocated ?storage_location)
        (location_ready_for_binding ?storage_location)
        (not
          (entity_putaway_completed ?pallet_jack_team)
        )
      )
    :effect (entity_putaway_completed ?pallet_jack_team)
  )
  (:action associate_receipt_with_inventory_record
    :parameters (?receipt - warehouse_entity_type ?inventory_record - inventory_record ?staging_pallet - staging_pallet)
    :precondition
      (and
        (entity_putaway_completed ?receipt)
        (entity_staged_on_pallet ?receipt ?staging_pallet)
        (inventory_record_available ?inventory_record)
        (not
          (inventory_linked ?receipt)
        )
      )
    :effect
      (and
        (inventory_linked ?receipt)
        (entity_associated_inventory_record ?receipt ?inventory_record)
        (not
          (inventory_record_available ?inventory_record)
        )
      )
  )
  (:action finalize_forklift_team_putaway_and_release_dock
    :parameters (?forklift_team - forklift_team ?dock_door - dock_door ?inventory_record - inventory_record)
    :precondition
      (and
        (inventory_linked ?forklift_team)
        (entity_assigned_to_dock ?forklift_team ?dock_door)
        (entity_associated_inventory_record ?forklift_team ?inventory_record)
        (not
          (work_completed ?forklift_team)
        )
      )
    :effect
      (and
        (work_completed ?forklift_team)
        (dock_available ?dock_door)
        (inventory_record_available ?inventory_record)
      )
  )
  (:action finalize_jack_team_putaway_and_release_dock
    :parameters (?pallet_jack_team - pallet_jack_team ?dock_door - dock_door ?inventory_record - inventory_record)
    :precondition
      (and
        (inventory_linked ?pallet_jack_team)
        (entity_assigned_to_dock ?pallet_jack_team ?dock_door)
        (entity_associated_inventory_record ?pallet_jack_team ?inventory_record)
        (not
          (work_completed ?pallet_jack_team)
        )
      )
    :effect
      (and
        (work_completed ?pallet_jack_team)
        (dock_available ?dock_door)
        (inventory_record_available ?inventory_record)
      )
  )
  (:action finalize_job_and_release_dock
    :parameters (?putaway_job - putaway_job ?dock_door - dock_door ?inventory_record - inventory_record)
    :precondition
      (and
        (inventory_linked ?putaway_job)
        (entity_assigned_to_dock ?putaway_job ?dock_door)
        (entity_associated_inventory_record ?putaway_job ?inventory_record)
        (not
          (work_completed ?putaway_job)
        )
      )
    :effect
      (and
        (work_completed ?putaway_job)
        (dock_available ?dock_door)
        (inventory_record_available ?inventory_record)
      )
  )
)

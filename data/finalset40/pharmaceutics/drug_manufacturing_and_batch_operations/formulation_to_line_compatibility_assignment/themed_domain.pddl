(define (domain pharmaceutics_formulation_line_compatibility_assignment)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_family - object artifact_family - object station_family - object batch_family - object batch - batch_family production_line - resource_family formulation_recipe - resource_family equipment_resource - resource_family validation_certificate - resource_family inspection_record - resource_family certificate_of_analysis - resource_family packaging_material_lot - resource_family analytical_method - resource_family material_lot - artifact_family quality_sample - artifact_family approval_document - artifact_family upstream_station - station_family downstream_station - station_family production_unit - station_family batch_variant - batch production_order_family - batch formulation_batch - batch_variant line_batch - batch_variant production_order - production_order_family)
  (:predicates
    (registered ?batch - batch)
    (ready_for_processing ?batch - batch)
    (line_allocated ?batch - batch)
    (released ?batch - batch)
    (ready_for_release ?batch - batch)
    (coa_attached ?batch - batch)
    (line_available ?production_line - production_line)
    (assigned_to_line ?batch - batch ?production_line - production_line)
    (recipe_available ?formulation_recipe - formulation_recipe)
    (assigned_recipe ?batch - batch ?formulation_recipe - formulation_recipe)
    (equipment_available ?equipment_resource - equipment_resource)
    (assigned_equipment ?batch - batch ?equipment_resource - equipment_resource)
    (material_available ?material_lot - material_lot)
    (formulation_material_assigned ?formulation_batch - formulation_batch ?material_lot - material_lot)
    (line_material_assigned ?line_batch - line_batch ?material_lot - material_lot)
    (assigned_to_upstream_station ?formulation_batch - formulation_batch ?upstream_station - upstream_station)
    (upstream_station_signaled ?upstream_station - upstream_station)
    (upstream_station_material_loaded ?upstream_station - upstream_station)
    (formulation_stage_complete ?formulation_batch - formulation_batch)
    (assigned_to_downstream_station ?line_batch - line_batch ?downstream_station - downstream_station)
    (downstream_station_signaled ?downstream_station - downstream_station)
    (downstream_station_material_loaded ?downstream_station - downstream_station)
    (line_stage_complete ?line_batch - line_batch)
    (production_unit_available ?production_unit - production_unit)
    (production_unit_loaded ?production_unit - production_unit)
    (unit_assigned_upstream_station ?production_unit - production_unit ?upstream_station - upstream_station)
    (unit_assigned_downstream_station ?production_unit - production_unit ?downstream_station - downstream_station)
    (unit_passed_upstream_checkpoint ?production_unit - production_unit)
    (unit_passed_downstream_checkpoint ?production_unit - production_unit)
    (unit_marked_for_sampling ?production_unit - production_unit)
    (order_includes_formulation_batch ?production_order - production_order ?formulation_batch - formulation_batch)
    (order_includes_line_batch ?production_order - production_order ?line_batch - line_batch)
    (order_includes_production_unit ?production_order - production_order ?production_unit - production_unit)
    (sample_available ?quality_sample - quality_sample)
    (order_linked_sample ?production_order - production_order ?quality_sample - quality_sample)
    (sample_reserved ?quality_sample - quality_sample)
    (sample_assigned_to_unit ?quality_sample - quality_sample ?production_unit - production_unit)
    (order_sample_registered ?production_order - production_order)
    (order_sample_queued_for_testing ?production_order - production_order)
    (order_quality_checks_started ?production_order - production_order)
    (validation_attached ?production_order - production_order)
    (validation_verified ?production_order - production_order)
    (analysis_results_available ?production_order - production_order)
    (order_ready_for_finalization ?production_order - production_order)
    (approval_document_available ?approval_document - approval_document)
    (order_linked_approval_document ?production_order - production_order ?approval_document - approval_document)
    (order_approval_attached ?production_order - production_order)
    (approval_confirmed ?production_order - production_order)
    (analytical_method_verified ?production_order - production_order)
    (validation_certificate_available ?validation_certificate - validation_certificate)
    (order_linked_validation_certificate ?production_order - production_order ?validation_certificate - validation_certificate)
    (inspection_record_available ?inspection_record - inspection_record)
    (order_linked_inspection_record ?production_order - production_order ?inspection_record - inspection_record)
    (packaging_material_available ?packaging_material_lot - packaging_material_lot)
    (order_linked_packaging_material ?production_order - production_order ?packaging_material_lot - packaging_material_lot)
    (analytical_method_available ?analytical_method - analytical_method)
    (order_linked_analytical_method ?production_order - production_order ?analytical_method - analytical_method)
    (coa_available ?certificate_of_analysis - certificate_of_analysis)
    (linked_coa ?batch - batch ?certificate_of_analysis - certificate_of_analysis)
    (formulation_stage_ready ?formulation_batch - formulation_batch)
    (line_stage_ready ?line_batch - line_batch)
    (finalization_recorded ?production_order - production_order)
  )
  (:action register_batch
    :parameters (?batch - batch)
    :precondition
      (and
        (not
          (registered ?batch)
        )
        (not
          (released ?batch)
        )
      )
    :effect (registered ?batch)
  )
  (:action allocate_line_to_batch
    :parameters (?batch - batch ?production_line - production_line)
    :precondition
      (and
        (registered ?batch)
        (not
          (line_allocated ?batch)
        )
        (line_available ?production_line)
      )
    :effect
      (and
        (line_allocated ?batch)
        (assigned_to_line ?batch ?production_line)
        (not
          (line_available ?production_line)
        )
      )
  )
  (:action assign_formulation_to_batch
    :parameters (?batch - batch ?formulation_recipe - formulation_recipe)
    :precondition
      (and
        (registered ?batch)
        (line_allocated ?batch)
        (recipe_available ?formulation_recipe)
      )
    :effect
      (and
        (assigned_recipe ?batch ?formulation_recipe)
        (not
          (recipe_available ?formulation_recipe)
        )
      )
  )
  (:action finalize_formulation_assignment
    :parameters (?batch - batch ?formulation_recipe - formulation_recipe)
    :precondition
      (and
        (registered ?batch)
        (line_allocated ?batch)
        (assigned_recipe ?batch ?formulation_recipe)
        (not
          (ready_for_processing ?batch)
        )
      )
    :effect (ready_for_processing ?batch)
  )
  (:action release_formulation_recipe
    :parameters (?batch - batch ?formulation_recipe - formulation_recipe)
    :precondition
      (and
        (assigned_recipe ?batch ?formulation_recipe)
      )
    :effect
      (and
        (recipe_available ?formulation_recipe)
        (not
          (assigned_recipe ?batch ?formulation_recipe)
        )
      )
  )
  (:action assign_equipment_to_batch
    :parameters (?batch - batch ?equipment_resource - equipment_resource)
    :precondition
      (and
        (ready_for_processing ?batch)
        (equipment_available ?equipment_resource)
      )
    :effect
      (and
        (assigned_equipment ?batch ?equipment_resource)
        (not
          (equipment_available ?equipment_resource)
        )
      )
  )
  (:action release_equipment_from_batch
    :parameters (?batch - batch ?equipment_resource - equipment_resource)
    :precondition
      (and
        (assigned_equipment ?batch ?equipment_resource)
      )
    :effect
      (and
        (equipment_available ?equipment_resource)
        (not
          (assigned_equipment ?batch ?equipment_resource)
        )
      )
  )
  (:action reserve_packaging_material_for_order
    :parameters (?production_order - production_order ?packaging_material_lot - packaging_material_lot)
    :precondition
      (and
        (ready_for_processing ?production_order)
        (packaging_material_available ?packaging_material_lot)
      )
    :effect
      (and
        (order_linked_packaging_material ?production_order ?packaging_material_lot)
        (not
          (packaging_material_available ?packaging_material_lot)
        )
      )
  )
  (:action release_packaging_material_from_order
    :parameters (?production_order - production_order ?packaging_material_lot - packaging_material_lot)
    :precondition
      (and
        (order_linked_packaging_material ?production_order ?packaging_material_lot)
      )
    :effect
      (and
        (packaging_material_available ?packaging_material_lot)
        (not
          (order_linked_packaging_material ?production_order ?packaging_material_lot)
        )
      )
  )
  (:action reserve_analytical_method_for_order
    :parameters (?production_order - production_order ?analytical_method - analytical_method)
    :precondition
      (and
        (ready_for_processing ?production_order)
        (analytical_method_available ?analytical_method)
      )
    :effect
      (and
        (order_linked_analytical_method ?production_order ?analytical_method)
        (not
          (analytical_method_available ?analytical_method)
        )
      )
  )
  (:action release_analytical_method_from_order
    :parameters (?production_order - production_order ?analytical_method - analytical_method)
    :precondition
      (and
        (order_linked_analytical_method ?production_order ?analytical_method)
      )
    :effect
      (and
        (analytical_method_available ?analytical_method)
        (not
          (order_linked_analytical_method ?production_order ?analytical_method)
        )
      )
  )
  (:action prepare_upstream_station
    :parameters (?formulation_batch - formulation_batch ?upstream_station - upstream_station ?formulation_recipe - formulation_recipe)
    :precondition
      (and
        (ready_for_processing ?formulation_batch)
        (assigned_recipe ?formulation_batch ?formulation_recipe)
        (assigned_to_upstream_station ?formulation_batch ?upstream_station)
        (not
          (upstream_station_signaled ?upstream_station)
        )
        (not
          (upstream_station_material_loaded ?upstream_station)
        )
      )
    :effect (upstream_station_signaled ?upstream_station)
  )
  (:action confirm_formulation_preparation
    :parameters (?formulation_batch - formulation_batch ?upstream_station - upstream_station ?equipment_resource - equipment_resource)
    :precondition
      (and
        (ready_for_processing ?formulation_batch)
        (assigned_equipment ?formulation_batch ?equipment_resource)
        (assigned_to_upstream_station ?formulation_batch ?upstream_station)
        (upstream_station_signaled ?upstream_station)
        (not
          (formulation_stage_ready ?formulation_batch)
        )
      )
    :effect
      (and
        (formulation_stage_ready ?formulation_batch)
        (formulation_stage_complete ?formulation_batch)
      )
  )
  (:action load_material_to_upstream_station
    :parameters (?formulation_batch - formulation_batch ?upstream_station - upstream_station ?material_lot - material_lot)
    :precondition
      (and
        (ready_for_processing ?formulation_batch)
        (assigned_to_upstream_station ?formulation_batch ?upstream_station)
        (material_available ?material_lot)
        (not
          (formulation_stage_ready ?formulation_batch)
        )
      )
    :effect
      (and
        (upstream_station_material_loaded ?upstream_station)
        (formulation_stage_ready ?formulation_batch)
        (formulation_material_assigned ?formulation_batch ?material_lot)
        (not
          (material_available ?material_lot)
        )
      )
  )
  (:action complete_formulation_processing
    :parameters (?formulation_batch - formulation_batch ?upstream_station - upstream_station ?formulation_recipe - formulation_recipe ?material_lot - material_lot)
    :precondition
      (and
        (ready_for_processing ?formulation_batch)
        (assigned_recipe ?formulation_batch ?formulation_recipe)
        (assigned_to_upstream_station ?formulation_batch ?upstream_station)
        (upstream_station_material_loaded ?upstream_station)
        (formulation_material_assigned ?formulation_batch ?material_lot)
        (not
          (formulation_stage_complete ?formulation_batch)
        )
      )
    :effect
      (and
        (upstream_station_signaled ?upstream_station)
        (formulation_stage_complete ?formulation_batch)
        (material_available ?material_lot)
        (not
          (formulation_material_assigned ?formulation_batch ?material_lot)
        )
      )
  )
  (:action prepare_downstream_station
    :parameters (?line_batch - line_batch ?downstream_station - downstream_station ?formulation_recipe - formulation_recipe)
    :precondition
      (and
        (ready_for_processing ?line_batch)
        (assigned_recipe ?line_batch ?formulation_recipe)
        (assigned_to_downstream_station ?line_batch ?downstream_station)
        (not
          (downstream_station_signaled ?downstream_station)
        )
        (not
          (downstream_station_material_loaded ?downstream_station)
        )
      )
    :effect (downstream_station_signaled ?downstream_station)
  )
  (:action confirm_downstream_preparation
    :parameters (?line_batch - line_batch ?downstream_station - downstream_station ?equipment_resource - equipment_resource)
    :precondition
      (and
        (ready_for_processing ?line_batch)
        (assigned_equipment ?line_batch ?equipment_resource)
        (assigned_to_downstream_station ?line_batch ?downstream_station)
        (downstream_station_signaled ?downstream_station)
        (not
          (line_stage_ready ?line_batch)
        )
      )
    :effect
      (and
        (line_stage_ready ?line_batch)
        (line_stage_complete ?line_batch)
      )
  )
  (:action load_material_to_downstream_station
    :parameters (?line_batch - line_batch ?downstream_station - downstream_station ?material_lot - material_lot)
    :precondition
      (and
        (ready_for_processing ?line_batch)
        (assigned_to_downstream_station ?line_batch ?downstream_station)
        (material_available ?material_lot)
        (not
          (line_stage_ready ?line_batch)
        )
      )
    :effect
      (and
        (downstream_station_material_loaded ?downstream_station)
        (line_stage_ready ?line_batch)
        (line_material_assigned ?line_batch ?material_lot)
        (not
          (material_available ?material_lot)
        )
      )
  )
  (:action complete_line_processing
    :parameters (?line_batch - line_batch ?downstream_station - downstream_station ?formulation_recipe - formulation_recipe ?material_lot - material_lot)
    :precondition
      (and
        (ready_for_processing ?line_batch)
        (assigned_recipe ?line_batch ?formulation_recipe)
        (assigned_to_downstream_station ?line_batch ?downstream_station)
        (downstream_station_material_loaded ?downstream_station)
        (line_material_assigned ?line_batch ?material_lot)
        (not
          (line_stage_complete ?line_batch)
        )
      )
    :effect
      (and
        (downstream_station_signaled ?downstream_station)
        (line_stage_complete ?line_batch)
        (material_available ?material_lot)
        (not
          (line_material_assigned ?line_batch ?material_lot)
        )
      )
  )
  (:action unitize_and_load_production_unit
    :parameters (?formulation_batch - formulation_batch ?line_batch - line_batch ?upstream_station - upstream_station ?downstream_station - downstream_station ?production_unit - production_unit)
    :precondition
      (and
        (formulation_stage_ready ?formulation_batch)
        (line_stage_ready ?line_batch)
        (assigned_to_upstream_station ?formulation_batch ?upstream_station)
        (assigned_to_downstream_station ?line_batch ?downstream_station)
        (upstream_station_signaled ?upstream_station)
        (downstream_station_signaled ?downstream_station)
        (formulation_stage_complete ?formulation_batch)
        (line_stage_complete ?line_batch)
        (production_unit_available ?production_unit)
      )
    :effect
      (and
        (production_unit_loaded ?production_unit)
        (unit_assigned_upstream_station ?production_unit ?upstream_station)
        (unit_assigned_downstream_station ?production_unit ?downstream_station)
        (not
          (production_unit_available ?production_unit)
        )
      )
  )
  (:action unitize_and_load_with_upstream_material
    :parameters (?formulation_batch - formulation_batch ?line_batch - line_batch ?upstream_station - upstream_station ?downstream_station - downstream_station ?production_unit - production_unit)
    :precondition
      (and
        (formulation_stage_ready ?formulation_batch)
        (line_stage_ready ?line_batch)
        (assigned_to_upstream_station ?formulation_batch ?upstream_station)
        (assigned_to_downstream_station ?line_batch ?downstream_station)
        (upstream_station_material_loaded ?upstream_station)
        (downstream_station_signaled ?downstream_station)
        (not
          (formulation_stage_complete ?formulation_batch)
        )
        (line_stage_complete ?line_batch)
        (production_unit_available ?production_unit)
      )
    :effect
      (and
        (production_unit_loaded ?production_unit)
        (unit_assigned_upstream_station ?production_unit ?upstream_station)
        (unit_assigned_downstream_station ?production_unit ?downstream_station)
        (unit_passed_upstream_checkpoint ?production_unit)
        (not
          (production_unit_available ?production_unit)
        )
      )
  )
  (:action unitize_and_load_with_downstream_material
    :parameters (?formulation_batch - formulation_batch ?line_batch - line_batch ?upstream_station - upstream_station ?downstream_station - downstream_station ?production_unit - production_unit)
    :precondition
      (and
        (formulation_stage_ready ?formulation_batch)
        (line_stage_ready ?line_batch)
        (assigned_to_upstream_station ?formulation_batch ?upstream_station)
        (assigned_to_downstream_station ?line_batch ?downstream_station)
        (upstream_station_signaled ?upstream_station)
        (downstream_station_material_loaded ?downstream_station)
        (formulation_stage_complete ?formulation_batch)
        (not
          (line_stage_complete ?line_batch)
        )
        (production_unit_available ?production_unit)
      )
    :effect
      (and
        (production_unit_loaded ?production_unit)
        (unit_assigned_upstream_station ?production_unit ?upstream_station)
        (unit_assigned_downstream_station ?production_unit ?downstream_station)
        (unit_passed_downstream_checkpoint ?production_unit)
        (not
          (production_unit_available ?production_unit)
        )
      )
  )
  (:action unitize_and_load_with_both_materials
    :parameters (?formulation_batch - formulation_batch ?line_batch - line_batch ?upstream_station - upstream_station ?downstream_station - downstream_station ?production_unit - production_unit)
    :precondition
      (and
        (formulation_stage_ready ?formulation_batch)
        (line_stage_ready ?line_batch)
        (assigned_to_upstream_station ?formulation_batch ?upstream_station)
        (assigned_to_downstream_station ?line_batch ?downstream_station)
        (upstream_station_material_loaded ?upstream_station)
        (downstream_station_material_loaded ?downstream_station)
        (not
          (formulation_stage_complete ?formulation_batch)
        )
        (not
          (line_stage_complete ?line_batch)
        )
        (production_unit_available ?production_unit)
      )
    :effect
      (and
        (production_unit_loaded ?production_unit)
        (unit_assigned_upstream_station ?production_unit ?upstream_station)
        (unit_assigned_downstream_station ?production_unit ?downstream_station)
        (unit_passed_upstream_checkpoint ?production_unit)
        (unit_passed_downstream_checkpoint ?production_unit)
        (not
          (production_unit_available ?production_unit)
        )
      )
  )
  (:action mark_unit_for_sampling
    :parameters (?production_unit - production_unit ?formulation_batch - formulation_batch ?formulation_recipe - formulation_recipe)
    :precondition
      (and
        (production_unit_loaded ?production_unit)
        (formulation_stage_ready ?formulation_batch)
        (assigned_recipe ?formulation_batch ?formulation_recipe)
        (not
          (unit_marked_for_sampling ?production_unit)
        )
      )
    :effect (unit_marked_for_sampling ?production_unit)
  )
  (:action reserve_quality_sample_for_unit
    :parameters (?production_order - production_order ?quality_sample - quality_sample ?production_unit - production_unit)
    :precondition
      (and
        (ready_for_processing ?production_order)
        (order_includes_production_unit ?production_order ?production_unit)
        (order_linked_sample ?production_order ?quality_sample)
        (sample_available ?quality_sample)
        (production_unit_loaded ?production_unit)
        (unit_marked_for_sampling ?production_unit)
        (not
          (sample_reserved ?quality_sample)
        )
      )
    :effect
      (and
        (sample_reserved ?quality_sample)
        (sample_assigned_to_unit ?quality_sample ?production_unit)
        (not
          (sample_available ?quality_sample)
        )
      )
  )
  (:action register_sample_for_analysis
    :parameters (?production_order - production_order ?quality_sample - quality_sample ?production_unit - production_unit ?formulation_recipe - formulation_recipe)
    :precondition
      (and
        (ready_for_processing ?production_order)
        (order_linked_sample ?production_order ?quality_sample)
        (sample_reserved ?quality_sample)
        (sample_assigned_to_unit ?quality_sample ?production_unit)
        (assigned_recipe ?production_order ?formulation_recipe)
        (not
          (unit_passed_upstream_checkpoint ?production_unit)
        )
        (not
          (order_sample_registered ?production_order)
        )
      )
    :effect (order_sample_registered ?production_order)
  )
  (:action attach_validation_certificate_to_order
    :parameters (?production_order - production_order ?validation_certificate - validation_certificate)
    :precondition
      (and
        (ready_for_processing ?production_order)
        (validation_certificate_available ?validation_certificate)
        (not
          (validation_attached ?production_order)
        )
      )
    :effect
      (and
        (validation_attached ?production_order)
        (order_linked_validation_certificate ?production_order ?validation_certificate)
        (not
          (validation_certificate_available ?validation_certificate)
        )
      )
  )
  (:action verify_validation_certificate
    :parameters (?production_order - production_order ?quality_sample - quality_sample ?production_unit - production_unit ?formulation_recipe - formulation_recipe ?validation_certificate - validation_certificate)
    :precondition
      (and
        (ready_for_processing ?production_order)
        (order_linked_sample ?production_order ?quality_sample)
        (sample_reserved ?quality_sample)
        (sample_assigned_to_unit ?quality_sample ?production_unit)
        (assigned_recipe ?production_order ?formulation_recipe)
        (unit_passed_upstream_checkpoint ?production_unit)
        (validation_attached ?production_order)
        (order_linked_validation_certificate ?production_order ?validation_certificate)
        (not
          (order_sample_registered ?production_order)
        )
      )
    :effect
      (and
        (order_sample_registered ?production_order)
        (validation_verified ?production_order)
      )
  )
  (:action initiate_sample_testing_path_1
    :parameters (?production_order - production_order ?packaging_material_lot - packaging_material_lot ?equipment_resource - equipment_resource ?quality_sample - quality_sample ?production_unit - production_unit)
    :precondition
      (and
        (order_sample_registered ?production_order)
        (order_linked_packaging_material ?production_order ?packaging_material_lot)
        (assigned_equipment ?production_order ?equipment_resource)
        (order_linked_sample ?production_order ?quality_sample)
        (sample_assigned_to_unit ?quality_sample ?production_unit)
        (not
          (unit_passed_downstream_checkpoint ?production_unit)
        )
        (not
          (order_sample_queued_for_testing ?production_order)
        )
      )
    :effect (order_sample_queued_for_testing ?production_order)
  )
  (:action initiate_sample_testing_path_2
    :parameters (?production_order - production_order ?packaging_material_lot - packaging_material_lot ?equipment_resource - equipment_resource ?quality_sample - quality_sample ?production_unit - production_unit)
    :precondition
      (and
        (order_sample_registered ?production_order)
        (order_linked_packaging_material ?production_order ?packaging_material_lot)
        (assigned_equipment ?production_order ?equipment_resource)
        (order_linked_sample ?production_order ?quality_sample)
        (sample_assigned_to_unit ?quality_sample ?production_unit)
        (unit_passed_downstream_checkpoint ?production_unit)
        (not
          (order_sample_queued_for_testing ?production_order)
        )
      )
    :effect (order_sample_queued_for_testing ?production_order)
  )
  (:action start_quality_checks_variant_1
    :parameters (?production_order - production_order ?analytical_method - analytical_method ?quality_sample - quality_sample ?production_unit - production_unit)
    :precondition
      (and
        (order_sample_queued_for_testing ?production_order)
        (order_linked_analytical_method ?production_order ?analytical_method)
        (order_linked_sample ?production_order ?quality_sample)
        (sample_assigned_to_unit ?quality_sample ?production_unit)
        (not
          (unit_passed_upstream_checkpoint ?production_unit)
        )
        (not
          (unit_passed_downstream_checkpoint ?production_unit)
        )
        (not
          (order_quality_checks_started ?production_order)
        )
      )
    :effect (order_quality_checks_started ?production_order)
  )
  (:action start_quality_checks_variant_2
    :parameters (?production_order - production_order ?analytical_method - analytical_method ?quality_sample - quality_sample ?production_unit - production_unit)
    :precondition
      (and
        (order_sample_queued_for_testing ?production_order)
        (order_linked_analytical_method ?production_order ?analytical_method)
        (order_linked_sample ?production_order ?quality_sample)
        (sample_assigned_to_unit ?quality_sample ?production_unit)
        (unit_passed_upstream_checkpoint ?production_unit)
        (not
          (unit_passed_downstream_checkpoint ?production_unit)
        )
        (not
          (order_quality_checks_started ?production_order)
        )
      )
    :effect
      (and
        (order_quality_checks_started ?production_order)
        (analysis_results_available ?production_order)
      )
  )
  (:action start_quality_checks_variant_3
    :parameters (?production_order - production_order ?analytical_method - analytical_method ?quality_sample - quality_sample ?production_unit - production_unit)
    :precondition
      (and
        (order_sample_queued_for_testing ?production_order)
        (order_linked_analytical_method ?production_order ?analytical_method)
        (order_linked_sample ?production_order ?quality_sample)
        (sample_assigned_to_unit ?quality_sample ?production_unit)
        (not
          (unit_passed_upstream_checkpoint ?production_unit)
        )
        (unit_passed_downstream_checkpoint ?production_unit)
        (not
          (order_quality_checks_started ?production_order)
        )
      )
    :effect
      (and
        (order_quality_checks_started ?production_order)
        (analysis_results_available ?production_order)
      )
  )
  (:action start_quality_checks_variant_4
    :parameters (?production_order - production_order ?analytical_method - analytical_method ?quality_sample - quality_sample ?production_unit - production_unit)
    :precondition
      (and
        (order_sample_queued_for_testing ?production_order)
        (order_linked_analytical_method ?production_order ?analytical_method)
        (order_linked_sample ?production_order ?quality_sample)
        (sample_assigned_to_unit ?quality_sample ?production_unit)
        (unit_passed_upstream_checkpoint ?production_unit)
        (unit_passed_downstream_checkpoint ?production_unit)
        (not
          (order_quality_checks_started ?production_order)
        )
      )
    :effect
      (and
        (order_quality_checks_started ?production_order)
        (analysis_results_available ?production_order)
      )
  )
  (:action finalize_production_order_direct
    :parameters (?production_order - production_order)
    :precondition
      (and
        (order_quality_checks_started ?production_order)
        (not
          (analysis_results_available ?production_order)
        )
        (not
          (finalization_recorded ?production_order)
        )
      )
    :effect
      (and
        (finalization_recorded ?production_order)
        (ready_for_release ?production_order)
      )
  )
  (:action attach_inspection_record
    :parameters (?production_order - production_order ?inspection_record - inspection_record)
    :precondition
      (and
        (order_quality_checks_started ?production_order)
        (analysis_results_available ?production_order)
        (inspection_record_available ?inspection_record)
      )
    :effect
      (and
        (order_linked_inspection_record ?production_order ?inspection_record)
        (not
          (inspection_record_available ?inspection_record)
        )
      )
  )
  (:action perform_final_checks_and_mark_ready
    :parameters (?production_order - production_order ?formulation_batch - formulation_batch ?line_batch - line_batch ?formulation_recipe - formulation_recipe ?inspection_record - inspection_record)
    :precondition
      (and
        (order_quality_checks_started ?production_order)
        (analysis_results_available ?production_order)
        (order_linked_inspection_record ?production_order ?inspection_record)
        (order_includes_formulation_batch ?production_order ?formulation_batch)
        (order_includes_line_batch ?production_order ?line_batch)
        (formulation_stage_complete ?formulation_batch)
        (line_stage_complete ?line_batch)
        (assigned_recipe ?production_order ?formulation_recipe)
        (not
          (order_ready_for_finalization ?production_order)
        )
      )
    :effect (order_ready_for_finalization ?production_order)
  )
  (:action finalize_production_order_with_checks
    :parameters (?production_order - production_order)
    :precondition
      (and
        (order_quality_checks_started ?production_order)
        (order_ready_for_finalization ?production_order)
        (not
          (finalization_recorded ?production_order)
        )
      )
    :effect
      (and
        (finalization_recorded ?production_order)
        (ready_for_release ?production_order)
      )
  )
  (:action attach_approval_document_to_order
    :parameters (?production_order - production_order ?approval_document - approval_document ?formulation_recipe - formulation_recipe)
    :precondition
      (and
        (ready_for_processing ?production_order)
        (assigned_recipe ?production_order ?formulation_recipe)
        (approval_document_available ?approval_document)
        (order_linked_approval_document ?production_order ?approval_document)
        (not
          (order_approval_attached ?production_order)
        )
      )
    :effect
      (and
        (order_approval_attached ?production_order)
        (not
          (approval_document_available ?approval_document)
        )
      )
  )
  (:action confirm_approval_and_equipment_assignment
    :parameters (?production_order - production_order ?equipment_resource - equipment_resource)
    :precondition
      (and
        (order_approval_attached ?production_order)
        (assigned_equipment ?production_order ?equipment_resource)
        (not
          (approval_confirmed ?production_order)
        )
      )
    :effect (approval_confirmed ?production_order)
  )
  (:action verify_analytical_method_for_order
    :parameters (?production_order - production_order ?analytical_method - analytical_method)
    :precondition
      (and
        (approval_confirmed ?production_order)
        (order_linked_analytical_method ?production_order ?analytical_method)
        (not
          (analytical_method_verified ?production_order)
        )
      )
    :effect (analytical_method_verified ?production_order)
  )
  (:action finalize_production_order_with_method_verification
    :parameters (?production_order - production_order)
    :precondition
      (and
        (analytical_method_verified ?production_order)
        (not
          (finalization_recorded ?production_order)
        )
      )
    :effect
      (and
        (finalization_recorded ?production_order)
        (ready_for_release ?production_order)
      )
  )
  (:action finalize_formulation_batch
    :parameters (?formulation_batch - formulation_batch ?production_unit - production_unit)
    :precondition
      (and
        (formulation_stage_ready ?formulation_batch)
        (formulation_stage_complete ?formulation_batch)
        (production_unit_loaded ?production_unit)
        (unit_marked_for_sampling ?production_unit)
        (not
          (ready_for_release ?formulation_batch)
        )
      )
    :effect (ready_for_release ?formulation_batch)
  )
  (:action finalize_line_batch
    :parameters (?line_batch - line_batch ?production_unit - production_unit)
    :precondition
      (and
        (line_stage_ready ?line_batch)
        (line_stage_complete ?line_batch)
        (production_unit_loaded ?production_unit)
        (unit_marked_for_sampling ?production_unit)
        (not
          (ready_for_release ?line_batch)
        )
      )
    :effect (ready_for_release ?line_batch)
  )
  (:action attach_coa_to_batch
    :parameters (?batch - batch ?certificate_of_analysis - certificate_of_analysis ?formulation_recipe - formulation_recipe)
    :precondition
      (and
        (ready_for_release ?batch)
        (assigned_recipe ?batch ?formulation_recipe)
        (coa_available ?certificate_of_analysis)
        (not
          (coa_attached ?batch)
        )
      )
    :effect
      (and
        (coa_attached ?batch)
        (linked_coa ?batch ?certificate_of_analysis)
        (not
          (coa_available ?certificate_of_analysis)
        )
      )
  )
  (:action release_formulation_batch_to_line
    :parameters (?formulation_batch - formulation_batch ?production_line - production_line ?certificate_of_analysis - certificate_of_analysis)
    :precondition
      (and
        (coa_attached ?formulation_batch)
        (assigned_to_line ?formulation_batch ?production_line)
        (linked_coa ?formulation_batch ?certificate_of_analysis)
        (not
          (released ?formulation_batch)
        )
      )
    :effect
      (and
        (released ?formulation_batch)
        (line_available ?production_line)
        (coa_available ?certificate_of_analysis)
      )
  )
  (:action release_line_batch
    :parameters (?line_batch - line_batch ?production_line - production_line ?certificate_of_analysis - certificate_of_analysis)
    :precondition
      (and
        (coa_attached ?line_batch)
        (assigned_to_line ?line_batch ?production_line)
        (linked_coa ?line_batch ?certificate_of_analysis)
        (not
          (released ?line_batch)
        )
      )
    :effect
      (and
        (released ?line_batch)
        (line_available ?production_line)
        (coa_available ?certificate_of_analysis)
      )
  )
  (:action release_production_order
    :parameters (?production_order - production_order ?production_line - production_line ?certificate_of_analysis - certificate_of_analysis)
    :precondition
      (and
        (coa_attached ?production_order)
        (assigned_to_line ?production_order ?production_line)
        (linked_coa ?production_order ?certificate_of_analysis)
        (not
          (released ?production_order)
        )
      )
    :effect
      (and
        (released ?production_order)
        (line_available ?production_line)
        (coa_available ?certificate_of_analysis)
      )
  )
)

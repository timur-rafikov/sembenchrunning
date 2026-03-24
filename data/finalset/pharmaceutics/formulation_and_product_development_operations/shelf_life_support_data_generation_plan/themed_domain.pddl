(define (domain shelf_life_support_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types candidate_pool - object resource_pool - object method_pool - object development_scope - object development_entity - development_scope analytical_instrument - candidate_pool stability_protocol - candidate_pool manufacturing_route - candidate_pool risk_control - candidate_pool regulatory_document - candidate_pool data_requirement - candidate_pool assay_template - candidate_pool statistical_plan - candidate_pool material_sample - resource_pool analytical_method - resource_pool study_trigger - resource_pool storage_condition - method_pool packaging_configuration - method_pool stability_report - method_pool batch_category - development_entity project_category - development_entity laboratory_batch - batch_category pilot_batch - batch_category development_project - project_category)
  (:predicates
    (entity_registered ?development_entity - development_entity)
    (in_development_scope ?development_entity - development_entity)
    (resource_assigned ?development_entity - development_entity)
    (shelf_life_support_complete ?development_entity - development_entity)
    (evidence_package_ready ?development_entity - development_entity)
    (data_requirement_assigned ?development_entity - development_entity)
    (analytical_instrument_available ?analytical_instrument - analytical_instrument)
    (allocated_analytical_instrument_to_entity ?development_entity - development_entity ?analytical_instrument - analytical_instrument)
    (stability_protocol_available ?stability_protocol - stability_protocol)
    (entity_assigned_protocol ?development_entity - development_entity ?stability_protocol - stability_protocol)
    (manufacturing_route_available ?manufacturing_route - manufacturing_route)
    (entity_assigned_route ?development_entity - development_entity ?manufacturing_route - manufacturing_route)
    (material_sample_available ?material_sample - material_sample)
    (batch_allocated_sample ?laboratory_batch - laboratory_batch ?material_sample - material_sample)
    (pilot_allocated_sample ?pilot_batch - pilot_batch ?material_sample - material_sample)
    (batch_assigned_storage_condition ?laboratory_batch - laboratory_batch ?storage_condition - storage_condition)
    (storage_condition_primary_reserved ?storage_condition - storage_condition)
    (storage_condition_secondary_reserved ?storage_condition - storage_condition)
    (batch_samples_prepared ?laboratory_batch - laboratory_batch)
    (pilot_assigned_packaging ?pilot_batch - pilot_batch ?packaging_configuration - packaging_configuration)
    (packaging_primary_reserved ?packaging_configuration - packaging_configuration)
    (packaging_secondary_reserved ?packaging_configuration - packaging_configuration)
    (pilot_samples_prepared ?pilot_batch - pilot_batch)
    (stability_report_available ?stability_report - stability_report)
    (stability_report_active ?stability_report - stability_report)
    (report_linked_storage_condition ?stability_report - stability_report ?storage_condition - storage_condition)
    (report_linked_packaging ?stability_report - stability_report ?packaging_configuration - packaging_configuration)
    (report_includes_lab_measurements ?stability_report - stability_report)
    (report_has_pilot_data ?stability_report - stability_report)
    (report_includes_validated_lab_results ?stability_report - stability_report)
    (project_includes_laboratory_batch ?development_project - development_project ?laboratory_batch - laboratory_batch)
    (project_includes_pilot_batch ?development_project - development_project ?pilot_batch - pilot_batch)
    (project_linked_report ?development_project - development_project ?stability_report - stability_report)
    (analytical_method_available ?analytical_method - analytical_method)
    (project_allocated_method ?development_project - development_project ?analytical_method - analytical_method)
    (analytical_method_validated ?analytical_method - analytical_method)
    (method_linked_to_report ?analytical_method - analytical_method ?stability_report - stability_report)
    (project_methods_confirmed ?development_project - development_project)
    (project_analytics_ready ?development_project - development_project)
    (project_statistical_plan_applied ?development_project - development_project)
    (project_risk_control_applied ?development_project - development_project)
    (project_risk_annotation_added ?development_project - development_project)
    (project_data_validated ?development_project - development_project)
    (project_final_checks_completed ?development_project - development_project)
    (study_trigger_available ?study_trigger - study_trigger)
    (project_linked_study_trigger ?development_project - development_project ?study_trigger - study_trigger)
    (project_review_initiated ?development_project - development_project)
    (regulatory_review_in_progress ?development_project - development_project)
    (regulatory_review_completed ?development_project - development_project)
    (risk_control_available ?risk_control - risk_control)
    (project_linked_risk_control ?development_project - development_project ?risk_control - risk_control)
    (regulatory_document_available ?regulatory_document - regulatory_document)
    (project_linked_regulatory_document ?development_project - development_project ?regulatory_document - regulatory_document)
    (assay_template_available ?assay_template - assay_template)
    (project_linked_assay_template ?development_project - development_project ?assay_template - assay_template)
    (statistical_plan_available ?statistical_plan - statistical_plan)
    (project_linked_statistical_plan ?development_project - development_project ?statistical_plan - statistical_plan)
    (data_requirement_available ?data_requirement - data_requirement)
    (entity_linked_data_requirement ?development_entity - development_entity ?data_requirement - data_requirement)
    (batch_ready_for_reporting ?laboratory_batch - laboratory_batch)
    (pilot_ready_for_reporting ?pilot_batch - pilot_batch)
    (project_signoff_complete ?development_project - development_project)
  )
  (:action register_candidate
    :parameters (?development_entity - development_entity)
    :precondition
      (and
        (not
          (entity_registered ?development_entity)
        )
        (not
          (shelf_life_support_complete ?development_entity)
        )
      )
    :effect (entity_registered ?development_entity)
  )
  (:action allocate_analytical_instrument_to_entity
    :parameters (?development_entity - development_entity ?analytical_instrument - analytical_instrument)
    :precondition
      (and
        (entity_registered ?development_entity)
        (not
          (resource_assigned ?development_entity)
        )
        (analytical_instrument_available ?analytical_instrument)
      )
    :effect
      (and
        (resource_assigned ?development_entity)
        (allocated_analytical_instrument_to_entity ?development_entity ?analytical_instrument)
        (not
          (analytical_instrument_available ?analytical_instrument)
        )
      )
  )
  (:action assign_stability_protocol_to_entity
    :parameters (?development_entity - development_entity ?stability_protocol - stability_protocol)
    :precondition
      (and
        (entity_registered ?development_entity)
        (resource_assigned ?development_entity)
        (stability_protocol_available ?stability_protocol)
      )
    :effect
      (and
        (entity_assigned_protocol ?development_entity ?stability_protocol)
        (not
          (stability_protocol_available ?stability_protocol)
        )
      )
  )
  (:action confirm_candidate_in_scope
    :parameters (?development_entity - development_entity ?stability_protocol - stability_protocol)
    :precondition
      (and
        (entity_registered ?development_entity)
        (resource_assigned ?development_entity)
        (entity_assigned_protocol ?development_entity ?stability_protocol)
        (not
          (in_development_scope ?development_entity)
        )
      )
    :effect (in_development_scope ?development_entity)
  )
  (:action release_stability_protocol_from_entity
    :parameters (?development_entity - development_entity ?stability_protocol - stability_protocol)
    :precondition
      (and
        (entity_assigned_protocol ?development_entity ?stability_protocol)
      )
    :effect
      (and
        (stability_protocol_available ?stability_protocol)
        (not
          (entity_assigned_protocol ?development_entity ?stability_protocol)
        )
      )
  )
  (:action assign_manufacturing_route_to_entity
    :parameters (?development_entity - development_entity ?manufacturing_route - manufacturing_route)
    :precondition
      (and
        (in_development_scope ?development_entity)
        (manufacturing_route_available ?manufacturing_route)
      )
    :effect
      (and
        (entity_assigned_route ?development_entity ?manufacturing_route)
        (not
          (manufacturing_route_available ?manufacturing_route)
        )
      )
  )
  (:action unassign_manufacturing_route_from_entity
    :parameters (?development_entity - development_entity ?manufacturing_route - manufacturing_route)
    :precondition
      (and
        (entity_assigned_route ?development_entity ?manufacturing_route)
      )
    :effect
      (and
        (manufacturing_route_available ?manufacturing_route)
        (not
          (entity_assigned_route ?development_entity ?manufacturing_route)
        )
      )
  )
  (:action attach_assay_template_to_project
    :parameters (?development_project - development_project ?assay_template - assay_template)
    :precondition
      (and
        (in_development_scope ?development_project)
        (assay_template_available ?assay_template)
      )
    :effect
      (and
        (project_linked_assay_template ?development_project ?assay_template)
        (not
          (assay_template_available ?assay_template)
        )
      )
  )
  (:action detach_assay_template_from_project
    :parameters (?development_project - development_project ?assay_template - assay_template)
    :precondition
      (and
        (project_linked_assay_template ?development_project ?assay_template)
      )
    :effect
      (and
        (assay_template_available ?assay_template)
        (not
          (project_linked_assay_template ?development_project ?assay_template)
        )
      )
  )
  (:action attach_statistical_plan_to_project
    :parameters (?development_project - development_project ?statistical_plan - statistical_plan)
    :precondition
      (and
        (in_development_scope ?development_project)
        (statistical_plan_available ?statistical_plan)
      )
    :effect
      (and
        (project_linked_statistical_plan ?development_project ?statistical_plan)
        (not
          (statistical_plan_available ?statistical_plan)
        )
      )
  )
  (:action detach_statistical_plan_from_project
    :parameters (?development_project - development_project ?statistical_plan - statistical_plan)
    :precondition
      (and
        (project_linked_statistical_plan ?development_project ?statistical_plan)
      )
    :effect
      (and
        (statistical_plan_available ?statistical_plan)
        (not
          (project_linked_statistical_plan ?development_project ?statistical_plan)
        )
      )
  )
  (:action reserve_primary_storage_slot_for_batch
    :parameters (?laboratory_batch - laboratory_batch ?storage_condition - storage_condition ?stability_protocol - stability_protocol)
    :precondition
      (and
        (in_development_scope ?laboratory_batch)
        (entity_assigned_protocol ?laboratory_batch ?stability_protocol)
        (batch_assigned_storage_condition ?laboratory_batch ?storage_condition)
        (not
          (storage_condition_primary_reserved ?storage_condition)
        )
        (not
          (storage_condition_secondary_reserved ?storage_condition)
        )
      )
    :effect (storage_condition_primary_reserved ?storage_condition)
  )
  (:action prepare_batch_samples_for_primary_storage
    :parameters (?laboratory_batch - laboratory_batch ?storage_condition - storage_condition ?manufacturing_route - manufacturing_route)
    :precondition
      (and
        (in_development_scope ?laboratory_batch)
        (entity_assigned_route ?laboratory_batch ?manufacturing_route)
        (batch_assigned_storage_condition ?laboratory_batch ?storage_condition)
        (storage_condition_primary_reserved ?storage_condition)
        (not
          (batch_ready_for_reporting ?laboratory_batch)
        )
      )
    :effect
      (and
        (batch_ready_for_reporting ?laboratory_batch)
        (batch_samples_prepared ?laboratory_batch)
      )
  )
  (:action allocate_sample_to_batch_and_reserve_secondary_storage
    :parameters (?laboratory_batch - laboratory_batch ?storage_condition - storage_condition ?material_sample - material_sample)
    :precondition
      (and
        (in_development_scope ?laboratory_batch)
        (batch_assigned_storage_condition ?laboratory_batch ?storage_condition)
        (material_sample_available ?material_sample)
        (not
          (batch_ready_for_reporting ?laboratory_batch)
        )
      )
    :effect
      (and
        (storage_condition_secondary_reserved ?storage_condition)
        (batch_ready_for_reporting ?laboratory_batch)
        (batch_allocated_sample ?laboratory_batch ?material_sample)
        (not
          (material_sample_available ?material_sample)
        )
      )
  )
  (:action finalize_sample_allocation_and_mark_prepared
    :parameters (?laboratory_batch - laboratory_batch ?storage_condition - storage_condition ?stability_protocol - stability_protocol ?material_sample - material_sample)
    :precondition
      (and
        (in_development_scope ?laboratory_batch)
        (entity_assigned_protocol ?laboratory_batch ?stability_protocol)
        (batch_assigned_storage_condition ?laboratory_batch ?storage_condition)
        (storage_condition_secondary_reserved ?storage_condition)
        (batch_allocated_sample ?laboratory_batch ?material_sample)
        (not
          (batch_samples_prepared ?laboratory_batch)
        )
      )
    :effect
      (and
        (storage_condition_primary_reserved ?storage_condition)
        (batch_samples_prepared ?laboratory_batch)
        (material_sample_available ?material_sample)
        (not
          (batch_allocated_sample ?laboratory_batch ?material_sample)
        )
      )
  )
  (:action reserve_primary_packaging_for_pilot_batch
    :parameters (?pilot_batch - pilot_batch ?packaging_configuration - packaging_configuration ?stability_protocol - stability_protocol)
    :precondition
      (and
        (in_development_scope ?pilot_batch)
        (entity_assigned_protocol ?pilot_batch ?stability_protocol)
        (pilot_assigned_packaging ?pilot_batch ?packaging_configuration)
        (not
          (packaging_primary_reserved ?packaging_configuration)
        )
        (not
          (packaging_secondary_reserved ?packaging_configuration)
        )
      )
    :effect (packaging_primary_reserved ?packaging_configuration)
  )
  (:action prepare_pilot_samples_for_primary_packaging
    :parameters (?pilot_batch - pilot_batch ?packaging_configuration - packaging_configuration ?manufacturing_route - manufacturing_route)
    :precondition
      (and
        (in_development_scope ?pilot_batch)
        (entity_assigned_route ?pilot_batch ?manufacturing_route)
        (pilot_assigned_packaging ?pilot_batch ?packaging_configuration)
        (packaging_primary_reserved ?packaging_configuration)
        (not
          (pilot_ready_for_reporting ?pilot_batch)
        )
      )
    :effect
      (and
        (pilot_ready_for_reporting ?pilot_batch)
        (pilot_samples_prepared ?pilot_batch)
      )
  )
  (:action allocate_sample_to_pilot_and_reserve_secondary_packaging
    :parameters (?pilot_batch - pilot_batch ?packaging_configuration - packaging_configuration ?material_sample - material_sample)
    :precondition
      (and
        (in_development_scope ?pilot_batch)
        (pilot_assigned_packaging ?pilot_batch ?packaging_configuration)
        (material_sample_available ?material_sample)
        (not
          (pilot_ready_for_reporting ?pilot_batch)
        )
      )
    :effect
      (and
        (packaging_secondary_reserved ?packaging_configuration)
        (pilot_ready_for_reporting ?pilot_batch)
        (pilot_allocated_sample ?pilot_batch ?material_sample)
        (not
          (material_sample_available ?material_sample)
        )
      )
  )
  (:action finalize_pilot_sample_allocation_and_mark_prepared
    :parameters (?pilot_batch - pilot_batch ?packaging_configuration - packaging_configuration ?stability_protocol - stability_protocol ?material_sample - material_sample)
    :precondition
      (and
        (in_development_scope ?pilot_batch)
        (entity_assigned_protocol ?pilot_batch ?stability_protocol)
        (pilot_assigned_packaging ?pilot_batch ?packaging_configuration)
        (packaging_secondary_reserved ?packaging_configuration)
        (pilot_allocated_sample ?pilot_batch ?material_sample)
        (not
          (pilot_samples_prepared ?pilot_batch)
        )
      )
    :effect
      (and
        (packaging_primary_reserved ?packaging_configuration)
        (pilot_samples_prepared ?pilot_batch)
        (material_sample_available ?material_sample)
        (not
          (pilot_allocated_sample ?pilot_batch ?material_sample)
        )
      )
  )
  (:action create_and_assign_stability_report
    :parameters (?laboratory_batch - laboratory_batch ?pilot_batch - pilot_batch ?storage_condition - storage_condition ?packaging_configuration - packaging_configuration ?stability_report - stability_report)
    :precondition
      (and
        (batch_ready_for_reporting ?laboratory_batch)
        (pilot_ready_for_reporting ?pilot_batch)
        (batch_assigned_storage_condition ?laboratory_batch ?storage_condition)
        (pilot_assigned_packaging ?pilot_batch ?packaging_configuration)
        (storage_condition_primary_reserved ?storage_condition)
        (packaging_primary_reserved ?packaging_configuration)
        (batch_samples_prepared ?laboratory_batch)
        (pilot_samples_prepared ?pilot_batch)
        (stability_report_available ?stability_report)
      )
    :effect
      (and
        (stability_report_active ?stability_report)
        (report_linked_storage_condition ?stability_report ?storage_condition)
        (report_linked_packaging ?stability_report ?packaging_configuration)
        (not
          (stability_report_available ?stability_report)
        )
      )
  )
  (:action create_report_with_secondary_storage_data
    :parameters (?laboratory_batch - laboratory_batch ?pilot_batch - pilot_batch ?storage_condition - storage_condition ?packaging_configuration - packaging_configuration ?stability_report - stability_report)
    :precondition
      (and
        (batch_ready_for_reporting ?laboratory_batch)
        (pilot_ready_for_reporting ?pilot_batch)
        (batch_assigned_storage_condition ?laboratory_batch ?storage_condition)
        (pilot_assigned_packaging ?pilot_batch ?packaging_configuration)
        (storage_condition_secondary_reserved ?storage_condition)
        (packaging_primary_reserved ?packaging_configuration)
        (not
          (batch_samples_prepared ?laboratory_batch)
        )
        (pilot_samples_prepared ?pilot_batch)
        (stability_report_available ?stability_report)
      )
    :effect
      (and
        (stability_report_active ?stability_report)
        (report_linked_storage_condition ?stability_report ?storage_condition)
        (report_linked_packaging ?stability_report ?packaging_configuration)
        (report_includes_lab_measurements ?stability_report)
        (not
          (stability_report_available ?stability_report)
        )
      )
  )
  (:action create_report_with_secondary_packaging_data
    :parameters (?laboratory_batch - laboratory_batch ?pilot_batch - pilot_batch ?storage_condition - storage_condition ?packaging_configuration - packaging_configuration ?stability_report - stability_report)
    :precondition
      (and
        (batch_ready_for_reporting ?laboratory_batch)
        (pilot_ready_for_reporting ?pilot_batch)
        (batch_assigned_storage_condition ?laboratory_batch ?storage_condition)
        (pilot_assigned_packaging ?pilot_batch ?packaging_configuration)
        (storage_condition_primary_reserved ?storage_condition)
        (packaging_secondary_reserved ?packaging_configuration)
        (batch_samples_prepared ?laboratory_batch)
        (not
          (pilot_samples_prepared ?pilot_batch)
        )
        (stability_report_available ?stability_report)
      )
    :effect
      (and
        (stability_report_active ?stability_report)
        (report_linked_storage_condition ?stability_report ?storage_condition)
        (report_linked_packaging ?stability_report ?packaging_configuration)
        (report_has_pilot_data ?stability_report)
        (not
          (stability_report_available ?stability_report)
        )
      )
  )
  (:action create_report_with_combined_secondary_data
    :parameters (?laboratory_batch - laboratory_batch ?pilot_batch - pilot_batch ?storage_condition - storage_condition ?packaging_configuration - packaging_configuration ?stability_report - stability_report)
    :precondition
      (and
        (batch_ready_for_reporting ?laboratory_batch)
        (pilot_ready_for_reporting ?pilot_batch)
        (batch_assigned_storage_condition ?laboratory_batch ?storage_condition)
        (pilot_assigned_packaging ?pilot_batch ?packaging_configuration)
        (storage_condition_secondary_reserved ?storage_condition)
        (packaging_secondary_reserved ?packaging_configuration)
        (not
          (batch_samples_prepared ?laboratory_batch)
        )
        (not
          (pilot_samples_prepared ?pilot_batch)
        )
        (stability_report_available ?stability_report)
      )
    :effect
      (and
        (stability_report_active ?stability_report)
        (report_linked_storage_condition ?stability_report ?storage_condition)
        (report_linked_packaging ?stability_report ?packaging_configuration)
        (report_includes_lab_measurements ?stability_report)
        (report_has_pilot_data ?stability_report)
        (not
          (stability_report_available ?stability_report)
        )
      )
  )
  (:action add_lab_results_to_report
    :parameters (?stability_report - stability_report ?laboratory_batch - laboratory_batch ?stability_protocol - stability_protocol)
    :precondition
      (and
        (stability_report_active ?stability_report)
        (batch_ready_for_reporting ?laboratory_batch)
        (entity_assigned_protocol ?laboratory_batch ?stability_protocol)
        (not
          (report_includes_validated_lab_results ?stability_report)
        )
      )
    :effect (report_includes_validated_lab_results ?stability_report)
  )
  (:action qualify_analytical_method_for_report
    :parameters (?development_project - development_project ?analytical_method - analytical_method ?stability_report - stability_report)
    :precondition
      (and
        (in_development_scope ?development_project)
        (project_linked_report ?development_project ?stability_report)
        (project_allocated_method ?development_project ?analytical_method)
        (analytical_method_available ?analytical_method)
        (stability_report_active ?stability_report)
        (report_includes_validated_lab_results ?stability_report)
        (not
          (analytical_method_validated ?analytical_method)
        )
      )
    :effect
      (and
        (analytical_method_validated ?analytical_method)
        (method_linked_to_report ?analytical_method ?stability_report)
        (not
          (analytical_method_available ?analytical_method)
        )
      )
  )
  (:action confirm_method_validation_for_project
    :parameters (?development_project - development_project ?analytical_method - analytical_method ?stability_report - stability_report ?stability_protocol - stability_protocol)
    :precondition
      (and
        (in_development_scope ?development_project)
        (project_allocated_method ?development_project ?analytical_method)
        (analytical_method_validated ?analytical_method)
        (method_linked_to_report ?analytical_method ?stability_report)
        (entity_assigned_protocol ?development_project ?stability_protocol)
        (not
          (report_includes_lab_measurements ?stability_report)
        )
        (not
          (project_methods_confirmed ?development_project)
        )
      )
    :effect (project_methods_confirmed ?development_project)
  )
  (:action attach_risk_control_to_project
    :parameters (?development_project - development_project ?risk_control - risk_control)
    :precondition
      (and
        (in_development_scope ?development_project)
        (risk_control_available ?risk_control)
        (not
          (project_risk_control_applied ?development_project)
        )
      )
    :effect
      (and
        (project_risk_control_applied ?development_project)
        (project_linked_risk_control ?development_project ?risk_control)
        (not
          (risk_control_available ?risk_control)
        )
      )
  )
  (:action integrate_risk_control_and_confirm_project_methods
    :parameters (?development_project - development_project ?analytical_method - analytical_method ?stability_report - stability_report ?stability_protocol - stability_protocol ?risk_control - risk_control)
    :precondition
      (and
        (in_development_scope ?development_project)
        (project_allocated_method ?development_project ?analytical_method)
        (analytical_method_validated ?analytical_method)
        (method_linked_to_report ?analytical_method ?stability_report)
        (entity_assigned_protocol ?development_project ?stability_protocol)
        (report_includes_lab_measurements ?stability_report)
        (project_risk_control_applied ?development_project)
        (project_linked_risk_control ?development_project ?risk_control)
        (not
          (project_methods_confirmed ?development_project)
        )
      )
    :effect
      (and
        (project_methods_confirmed ?development_project)
        (project_risk_annotation_added ?development_project)
      )
  )
  (:action assemble_project_assay_package_primary
    :parameters (?development_project - development_project ?assay_template - assay_template ?manufacturing_route - manufacturing_route ?analytical_method - analytical_method ?stability_report - stability_report)
    :precondition
      (and
        (project_methods_confirmed ?development_project)
        (project_linked_assay_template ?development_project ?assay_template)
        (entity_assigned_route ?development_project ?manufacturing_route)
        (project_allocated_method ?development_project ?analytical_method)
        (method_linked_to_report ?analytical_method ?stability_report)
        (not
          (report_has_pilot_data ?stability_report)
        )
        (not
          (project_analytics_ready ?development_project)
        )
      )
    :effect (project_analytics_ready ?development_project)
  )
  (:action assemble_project_assay_package_secondary
    :parameters (?development_project - development_project ?assay_template - assay_template ?manufacturing_route - manufacturing_route ?analytical_method - analytical_method ?stability_report - stability_report)
    :precondition
      (and
        (project_methods_confirmed ?development_project)
        (project_linked_assay_template ?development_project ?assay_template)
        (entity_assigned_route ?development_project ?manufacturing_route)
        (project_allocated_method ?development_project ?analytical_method)
        (method_linked_to_report ?analytical_method ?stability_report)
        (report_has_pilot_data ?stability_report)
        (not
          (project_analytics_ready ?development_project)
        )
      )
    :effect (project_analytics_ready ?development_project)
  )
  (:action apply_statistical_plan_to_project
    :parameters (?development_project - development_project ?statistical_plan - statistical_plan ?analytical_method - analytical_method ?stability_report - stability_report)
    :precondition
      (and
        (project_analytics_ready ?development_project)
        (project_linked_statistical_plan ?development_project ?statistical_plan)
        (project_allocated_method ?development_project ?analytical_method)
        (method_linked_to_report ?analytical_method ?stability_report)
        (not
          (report_includes_lab_measurements ?stability_report)
        )
        (not
          (report_has_pilot_data ?stability_report)
        )
        (not
          (project_statistical_plan_applied ?development_project)
        )
      )
    :effect (project_statistical_plan_applied ?development_project)
  )
  (:action apply_statistical_plan_and_add_validation_flag
    :parameters (?development_project - development_project ?statistical_plan - statistical_plan ?analytical_method - analytical_method ?stability_report - stability_report)
    :precondition
      (and
        (project_analytics_ready ?development_project)
        (project_linked_statistical_plan ?development_project ?statistical_plan)
        (project_allocated_method ?development_project ?analytical_method)
        (method_linked_to_report ?analytical_method ?stability_report)
        (report_includes_lab_measurements ?stability_report)
        (not
          (report_has_pilot_data ?stability_report)
        )
        (not
          (project_statistical_plan_applied ?development_project)
        )
      )
    :effect
      (and
        (project_statistical_plan_applied ?development_project)
        (project_data_validated ?development_project)
      )
  )
  (:action apply_statistical_plan_and_produce_validation
    :parameters (?development_project - development_project ?statistical_plan - statistical_plan ?analytical_method - analytical_method ?stability_report - stability_report)
    :precondition
      (and
        (project_analytics_ready ?development_project)
        (project_linked_statistical_plan ?development_project ?statistical_plan)
        (project_allocated_method ?development_project ?analytical_method)
        (method_linked_to_report ?analytical_method ?stability_report)
        (not
          (report_includes_lab_measurements ?stability_report)
        )
        (report_has_pilot_data ?stability_report)
        (not
          (project_statistical_plan_applied ?development_project)
        )
      )
    :effect
      (and
        (project_statistical_plan_applied ?development_project)
        (project_data_validated ?development_project)
      )
  )
  (:action apply_statistical_plan_and_finalize_validation
    :parameters (?development_project - development_project ?statistical_plan - statistical_plan ?analytical_method - analytical_method ?stability_report - stability_report)
    :precondition
      (and
        (project_analytics_ready ?development_project)
        (project_linked_statistical_plan ?development_project ?statistical_plan)
        (project_allocated_method ?development_project ?analytical_method)
        (method_linked_to_report ?analytical_method ?stability_report)
        (report_includes_lab_measurements ?stability_report)
        (report_has_pilot_data ?stability_report)
        (not
          (project_statistical_plan_applied ?development_project)
        )
      )
    :effect
      (and
        (project_statistical_plan_applied ?development_project)
        (project_data_validated ?development_project)
      )
  )
  (:action finalize_project_signoff
    :parameters (?development_project - development_project)
    :precondition
      (and
        (project_statistical_plan_applied ?development_project)
        (not
          (project_data_validated ?development_project)
        )
        (not
          (project_signoff_complete ?development_project)
        )
      )
    :effect
      (and
        (project_signoff_complete ?development_project)
        (evidence_package_ready ?development_project)
      )
  )
  (:action attach_regulatory_document_to_project
    :parameters (?development_project - development_project ?regulatory_document - regulatory_document)
    :precondition
      (and
        (project_statistical_plan_applied ?development_project)
        (project_data_validated ?development_project)
        (regulatory_document_available ?regulatory_document)
      )
    :effect
      (and
        (project_linked_regulatory_document ?development_project ?regulatory_document)
        (not
          (regulatory_document_available ?regulatory_document)
        )
      )
  )
  (:action execute_project_final_cross_checks
    :parameters (?development_project - development_project ?laboratory_batch - laboratory_batch ?pilot_batch - pilot_batch ?stability_protocol - stability_protocol ?regulatory_document - regulatory_document)
    :precondition
      (and
        (project_statistical_plan_applied ?development_project)
        (project_data_validated ?development_project)
        (project_linked_regulatory_document ?development_project ?regulatory_document)
        (project_includes_laboratory_batch ?development_project ?laboratory_batch)
        (project_includes_pilot_batch ?development_project ?pilot_batch)
        (batch_samples_prepared ?laboratory_batch)
        (pilot_samples_prepared ?pilot_batch)
        (entity_assigned_protocol ?development_project ?stability_protocol)
        (not
          (project_final_checks_completed ?development_project)
        )
      )
    :effect (project_final_checks_completed ?development_project)
  )
  (:action complete_project_signoff
    :parameters (?development_project - development_project)
    :precondition
      (and
        (project_statistical_plan_applied ?development_project)
        (project_final_checks_completed ?development_project)
        (not
          (project_signoff_complete ?development_project)
        )
      )
    :effect
      (and
        (project_signoff_complete ?development_project)
        (evidence_package_ready ?development_project)
      )
  )
  (:action initiate_targeted_review_for_project
    :parameters (?development_project - development_project ?study_trigger - study_trigger ?stability_protocol - stability_protocol)
    :precondition
      (and
        (in_development_scope ?development_project)
        (entity_assigned_protocol ?development_project ?stability_protocol)
        (study_trigger_available ?study_trigger)
        (project_linked_study_trigger ?development_project ?study_trigger)
        (not
          (project_review_initiated ?development_project)
        )
      )
    :effect
      (and
        (project_review_initiated ?development_project)
        (not
          (study_trigger_available ?study_trigger)
        )
      )
  )
  (:action start_regulatory_review
    :parameters (?development_project - development_project ?manufacturing_route - manufacturing_route)
    :precondition
      (and
        (project_review_initiated ?development_project)
        (entity_assigned_route ?development_project ?manufacturing_route)
        (not
          (regulatory_review_in_progress ?development_project)
        )
      )
    :effect (regulatory_review_in_progress ?development_project)
  )
  (:action complete_regulatory_review
    :parameters (?development_project - development_project ?statistical_plan - statistical_plan)
    :precondition
      (and
        (regulatory_review_in_progress ?development_project)
        (project_linked_statistical_plan ?development_project ?statistical_plan)
        (not
          (regulatory_review_completed ?development_project)
        )
      )
    :effect (regulatory_review_completed ?development_project)
  )
  (:action finalize_regulatory_review_and_signoff
    :parameters (?development_project - development_project)
    :precondition
      (and
        (regulatory_review_completed ?development_project)
        (not
          (project_signoff_complete ?development_project)
        )
      )
    :effect
      (and
        (project_signoff_complete ?development_project)
        (evidence_package_ready ?development_project)
      )
  )
  (:action aggregate_batch_evidence_and_mark_support_complete
    :parameters (?laboratory_batch - laboratory_batch ?stability_report - stability_report)
    :precondition
      (and
        (batch_ready_for_reporting ?laboratory_batch)
        (batch_samples_prepared ?laboratory_batch)
        (stability_report_active ?stability_report)
        (report_includes_validated_lab_results ?stability_report)
        (not
          (evidence_package_ready ?laboratory_batch)
        )
      )
    :effect (evidence_package_ready ?laboratory_batch)
  )
  (:action aggregate_pilot_evidence_and_mark_support_complete
    :parameters (?pilot_batch - pilot_batch ?stability_report - stability_report)
    :precondition
      (and
        (pilot_ready_for_reporting ?pilot_batch)
        (pilot_samples_prepared ?pilot_batch)
        (stability_report_active ?stability_report)
        (report_includes_validated_lab_results ?stability_report)
        (not
          (evidence_package_ready ?pilot_batch)
        )
      )
    :effect (evidence_package_ready ?pilot_batch)
  )
  (:action assign_data_requirement_to_entity
    :parameters (?development_entity - development_entity ?data_requirement - data_requirement ?stability_protocol - stability_protocol)
    :precondition
      (and
        (evidence_package_ready ?development_entity)
        (entity_assigned_protocol ?development_entity ?stability_protocol)
        (data_requirement_available ?data_requirement)
        (not
          (data_requirement_assigned ?development_entity)
        )
      )
    :effect
      (and
        (data_requirement_assigned ?development_entity)
        (entity_linked_data_requirement ?development_entity ?data_requirement)
        (not
          (data_requirement_available ?data_requirement)
        )
      )
  )
  (:action finalize_batch_shelf_life_support_and_release_analytical_instrument
    :parameters (?laboratory_batch - laboratory_batch ?analytical_instrument - analytical_instrument ?data_requirement - data_requirement)
    :precondition
      (and
        (data_requirement_assigned ?laboratory_batch)
        (allocated_analytical_instrument_to_entity ?laboratory_batch ?analytical_instrument)
        (entity_linked_data_requirement ?laboratory_batch ?data_requirement)
        (not
          (shelf_life_support_complete ?laboratory_batch)
        )
      )
    :effect
      (and
        (shelf_life_support_complete ?laboratory_batch)
        (analytical_instrument_available ?analytical_instrument)
        (data_requirement_available ?data_requirement)
      )
  )
  (:action finalize_pilot_shelf_life_support_and_release_analytical_instrument
    :parameters (?pilot_batch - pilot_batch ?analytical_instrument - analytical_instrument ?data_requirement - data_requirement)
    :precondition
      (and
        (data_requirement_assigned ?pilot_batch)
        (allocated_analytical_instrument_to_entity ?pilot_batch ?analytical_instrument)
        (entity_linked_data_requirement ?pilot_batch ?data_requirement)
        (not
          (shelf_life_support_complete ?pilot_batch)
        )
      )
    :effect
      (and
        (shelf_life_support_complete ?pilot_batch)
        (analytical_instrument_available ?analytical_instrument)
        (data_requirement_available ?data_requirement)
      )
  )
  (:action finalize_project_shelf_life_support_and_release_analytical_instrument
    :parameters (?development_project - development_project ?analytical_instrument - analytical_instrument ?data_requirement - data_requirement)
    :precondition
      (and
        (data_requirement_assigned ?development_project)
        (allocated_analytical_instrument_to_entity ?development_project ?analytical_instrument)
        (entity_linked_data_requirement ?development_project ?data_requirement)
        (not
          (shelf_life_support_complete ?development_project)
        )
      )
    :effect
      (and
        (shelf_life_support_complete ?development_project)
        (analytical_instrument_available ?analytical_instrument)
        (data_requirement_available ?data_requirement)
      )
  )
)

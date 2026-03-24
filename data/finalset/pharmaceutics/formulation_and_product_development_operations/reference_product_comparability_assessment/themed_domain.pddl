(define (domain reference_product_comparability_assessment)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource - object sample_resource - object study_design - object product_class - object product_candidate - product_class analytical_resource - operational_resource analytical_method - operational_resource instrument - operational_resource regulatory_document - operational_resource cqa_specification - operational_resource analytical_evidence_set - operational_resource method_validation - operational_resource statistical_analysis_plan - operational_resource material_sample - sample_resource sample_batch - sample_resource reference_standard_batch - sample_resource stress_condition - study_design container_configuration - study_design stability_protocol - study_design formulation_stream - product_candidate assessment_stream - product_candidate formulation_variant - formulation_stream process_variant - formulation_stream comparability_project - assessment_stream)
  (:predicates
    (candidate_registered ?product_candidate - product_candidate)
    (assessment_active ?product_candidate - product_candidate)
    (candidate_resource_allocated ?product_candidate - product_candidate)
    (decision_confirmed ?product_candidate - product_candidate)
    (conclusion_recorded ?product_candidate - product_candidate)
    (evidence_assigned ?product_candidate - product_candidate)
    (analytical_resource_available ?analytical_resource - analytical_resource)
    (allocated_analytical_resource ?product_candidate - product_candidate ?analytical_resource - analytical_resource)
    (analytical_method_available ?analytical_method_var - analytical_method)
    (assigned_analytical_method ?product_candidate - product_candidate ?analytical_method_var - analytical_method)
    (instrument_available ?instrument - instrument)
    (assigned_instrument ?product_candidate - product_candidate ?instrument - instrument)
    (material_sample_available ?material_sample - material_sample)
    (formulation_variant_material_assigned ?formulation_variant - formulation_variant ?material_sample - material_sample)
    (process_variant_material_assigned ?process_variant - process_variant ?material_sample - material_sample)
    (formulation_variant_has_stress_condition ?formulation_variant - formulation_variant ?stress_condition - stress_condition)
    (stress_condition_selected ?stress_condition - stress_condition)
    (stress_condition_with_material_assigned ?stress_condition - stress_condition)
    (formulation_variant_prepared ?formulation_variant - formulation_variant)
    (process_variant_has_container_configuration ?process_variant - process_variant ?container_configuration - container_configuration)
    (container_configuration_selected ?container_configuration - container_configuration)
    (container_configuration_with_material ?container_configuration - container_configuration)
    (process_variant_prepared ?process_variant - process_variant)
    (stability_protocol_available ?stability_protocol - stability_protocol)
    (stability_protocol_activated ?stability_protocol - stability_protocol)
    (stability_protocol_assigned_stress_condition ?stability_protocol - stability_protocol ?stress_condition - stress_condition)
    (stability_protocol_assigned_container ?stability_protocol - stability_protocol ?container_configuration - container_configuration)
    (stability_protocol_has_intermediate_timepoints ?stability_protocol - stability_protocol)
    (stability_protocol_has_long_term_timepoints ?stability_protocol - stability_protocol)
    (stability_protocol_executed ?stability_protocol - stability_protocol)
    (project_includes_formulation_variant ?comparability_project - comparability_project ?formulation_variant - formulation_variant)
    (project_includes_process_variant ?comparability_project - comparability_project ?process_variant - process_variant)
    (project_includes_stability_protocol ?comparability_project - comparability_project ?stability_protocol - stability_protocol)
    (sample_batch_available ?sample_batch - sample_batch)
    (project_has_sample_batch ?comparability_project - comparability_project ?sample_batch - sample_batch)
    (sample_batch_assigned ?sample_batch - sample_batch)
    (sample_batch_linked_to_protocol ?sample_batch - sample_batch ?stability_protocol - stability_protocol)
    (project_sample_registered ?comparability_project - comparability_project)
    (project_analysis_executed ?comparability_project - comparability_project)
    (project_analysis_reviewed ?comparability_project - comparability_project)
    (project_regulatory_document_present ?comparability_project - comparability_project)
    (project_regulatory_document_validated ?comparability_project - comparability_project)
    (project_ready_for_cqa_assignment ?comparability_project - comparability_project)
    (project_cqa_assignment_complete ?comparability_project - comparability_project)
    (reference_standard_available ?reference_standard_batch - reference_standard_batch)
    (project_associated_with_reference_standard ?comparability_project - comparability_project ?reference_standard_batch - reference_standard_batch)
    (project_reference_standard_acknowledged ?comparability_project - comparability_project)
    (project_regulatory_checkpoint_passed ?comparability_project - comparability_project)
    (project_sap_applied ?comparability_project - comparability_project)
    (regulatory_document_available ?regulatory_document - regulatory_document)
    (project_has_regulatory_document ?comparability_project - comparability_project ?regulatory_document - regulatory_document)
    (cqa_specification_available ?cqa_specification - cqa_specification)
    (project_assigned_cqa_specification ?comparability_project - comparability_project ?cqa_specification - cqa_specification)
    (method_validation_available ?method_validation - method_validation)
    (project_assigned_method_validation ?comparability_project - comparability_project ?method_validation - method_validation)
    (sap_available ?statistical_analysis_plan - statistical_analysis_plan)
    (project_assigned_sap ?comparability_project - comparability_project ?statistical_analysis_plan - statistical_analysis_plan)
    (analytical_evidence_set_available ?analytical_evidence_set - analytical_evidence_set)
    (linked_to_analytical_evidence ?product_candidate - product_candidate ?analytical_evidence_set - analytical_evidence_set)
    (formulation_variant_ready ?formulation_variant - formulation_variant)
    (process_variant_ready ?process_variant - process_variant)
    (project_finalized ?comparability_project - comparability_project)
  )
  (:action register_product_candidate
    :parameters (?product_candidate - product_candidate)
    :precondition
      (and
        (not
          (candidate_registered ?product_candidate)
        )
        (not
          (decision_confirmed ?product_candidate)
        )
      )
    :effect (candidate_registered ?product_candidate)
  )
  (:action allocate_analytical_resource_to_candidate
    :parameters (?product_candidate - product_candidate ?analytical_resource - analytical_resource)
    :precondition
      (and
        (candidate_registered ?product_candidate)
        (not
          (candidate_resource_allocated ?product_candidate)
        )
        (analytical_resource_available ?analytical_resource)
      )
    :effect
      (and
        (candidate_resource_allocated ?product_candidate)
        (allocated_analytical_resource ?product_candidate ?analytical_resource)
        (not
          (analytical_resource_available ?analytical_resource)
        )
      )
  )
  (:action checkout_analytical_method_for_candidate
    :parameters (?product_candidate - product_candidate ?analytical_method_var - analytical_method)
    :precondition
      (and
        (candidate_registered ?product_candidate)
        (candidate_resource_allocated ?product_candidate)
        (analytical_method_available ?analytical_method_var)
      )
    :effect
      (and
        (assigned_analytical_method ?product_candidate ?analytical_method_var)
        (not
          (analytical_method_available ?analytical_method_var)
        )
      )
  )
  (:action confirm_analytical_method_assignment
    :parameters (?product_candidate - product_candidate ?analytical_method_var - analytical_method)
    :precondition
      (and
        (candidate_registered ?product_candidate)
        (candidate_resource_allocated ?product_candidate)
        (assigned_analytical_method ?product_candidate ?analytical_method_var)
        (not
          (assessment_active ?product_candidate)
        )
      )
    :effect (assessment_active ?product_candidate)
  )
  (:action release_analytical_method_from_candidate
    :parameters (?product_candidate - product_candidate ?analytical_method_var - analytical_method)
    :precondition
      (and
        (assigned_analytical_method ?product_candidate ?analytical_method_var)
      )
    :effect
      (and
        (analytical_method_available ?analytical_method_var)
        (not
          (assigned_analytical_method ?product_candidate ?analytical_method_var)
        )
      )
  )
  (:action assign_instrument_to_candidate
    :parameters (?product_candidate - product_candidate ?instrument - instrument)
    :precondition
      (and
        (assessment_active ?product_candidate)
        (instrument_available ?instrument)
      )
    :effect
      (and
        (assigned_instrument ?product_candidate ?instrument)
        (not
          (instrument_available ?instrument)
        )
      )
  )
  (:action release_instrument_from_candidate
    :parameters (?product_candidate - product_candidate ?instrument - instrument)
    :precondition
      (and
        (assigned_instrument ?product_candidate ?instrument)
      )
    :effect
      (and
        (instrument_available ?instrument)
        (not
          (assigned_instrument ?product_candidate ?instrument)
        )
      )
  )
  (:action assign_method_validation_to_project
    :parameters (?comparability_project - comparability_project ?method_validation - method_validation)
    :precondition
      (and
        (assessment_active ?comparability_project)
        (method_validation_available ?method_validation)
      )
    :effect
      (and
        (project_assigned_method_validation ?comparability_project ?method_validation)
        (not
          (method_validation_available ?method_validation)
        )
      )
  )
  (:action release_method_validation_from_project
    :parameters (?comparability_project - comparability_project ?method_validation - method_validation)
    :precondition
      (and
        (project_assigned_method_validation ?comparability_project ?method_validation)
      )
    :effect
      (and
        (method_validation_available ?method_validation)
        (not
          (project_assigned_method_validation ?comparability_project ?method_validation)
        )
      )
  )
  (:action assign_sap_to_project
    :parameters (?comparability_project - comparability_project ?statistical_analysis_plan - statistical_analysis_plan)
    :precondition
      (and
        (assessment_active ?comparability_project)
        (sap_available ?statistical_analysis_plan)
      )
    :effect
      (and
        (project_assigned_sap ?comparability_project ?statistical_analysis_plan)
        (not
          (sap_available ?statistical_analysis_plan)
        )
      )
  )
  (:action release_sap_from_project
    :parameters (?comparability_project - comparability_project ?statistical_analysis_plan - statistical_analysis_plan)
    :precondition
      (and
        (project_assigned_sap ?comparability_project ?statistical_analysis_plan)
      )
    :effect
      (and
        (sap_available ?statistical_analysis_plan)
        (not
          (project_assigned_sap ?comparability_project ?statistical_analysis_plan)
        )
      )
  )
  (:action select_stress_condition_for_formulation_variant
    :parameters (?formulation_variant - formulation_variant ?stress_condition - stress_condition ?analytical_method_var - analytical_method)
    :precondition
      (and
        (assessment_active ?formulation_variant)
        (assigned_analytical_method ?formulation_variant ?analytical_method_var)
        (formulation_variant_has_stress_condition ?formulation_variant ?stress_condition)
        (not
          (stress_condition_selected ?stress_condition)
        )
        (not
          (stress_condition_with_material_assigned ?stress_condition)
        )
      )
    :effect (stress_condition_selected ?stress_condition)
  )
  (:action prepare_formulation_variant_with_instrument
    :parameters (?formulation_variant - formulation_variant ?stress_condition - stress_condition ?instrument - instrument)
    :precondition
      (and
        (assessment_active ?formulation_variant)
        (assigned_instrument ?formulation_variant ?instrument)
        (formulation_variant_has_stress_condition ?formulation_variant ?stress_condition)
        (stress_condition_selected ?stress_condition)
        (not
          (formulation_variant_ready ?formulation_variant)
        )
      )
    :effect
      (and
        (formulation_variant_ready ?formulation_variant)
        (formulation_variant_prepared ?formulation_variant)
      )
  )
  (:action assign_material_to_formulation_variant
    :parameters (?formulation_variant - formulation_variant ?stress_condition - stress_condition ?material_sample - material_sample)
    :precondition
      (and
        (assessment_active ?formulation_variant)
        (formulation_variant_has_stress_condition ?formulation_variant ?stress_condition)
        (material_sample_available ?material_sample)
        (not
          (formulation_variant_ready ?formulation_variant)
        )
      )
    :effect
      (and
        (stress_condition_with_material_assigned ?stress_condition)
        (formulation_variant_ready ?formulation_variant)
        (formulation_variant_material_assigned ?formulation_variant ?material_sample)
        (not
          (material_sample_available ?material_sample)
        )
      )
  )
  (:action execute_analysis_on_formulation_variant_material
    :parameters (?formulation_variant - formulation_variant ?stress_condition - stress_condition ?analytical_method_var - analytical_method ?material_sample - material_sample)
    :precondition
      (and
        (assessment_active ?formulation_variant)
        (assigned_analytical_method ?formulation_variant ?analytical_method_var)
        (formulation_variant_has_stress_condition ?formulation_variant ?stress_condition)
        (stress_condition_with_material_assigned ?stress_condition)
        (formulation_variant_material_assigned ?formulation_variant ?material_sample)
        (not
          (formulation_variant_prepared ?formulation_variant)
        )
      )
    :effect
      (and
        (stress_condition_selected ?stress_condition)
        (formulation_variant_prepared ?formulation_variant)
        (material_sample_available ?material_sample)
        (not
          (formulation_variant_material_assigned ?formulation_variant ?material_sample)
        )
      )
  )
  (:action select_container_for_process_variant
    :parameters (?process_variant - process_variant ?container_configuration - container_configuration ?analytical_method_var - analytical_method)
    :precondition
      (and
        (assessment_active ?process_variant)
        (assigned_analytical_method ?process_variant ?analytical_method_var)
        (process_variant_has_container_configuration ?process_variant ?container_configuration)
        (not
          (container_configuration_selected ?container_configuration)
        )
        (not
          (container_configuration_with_material ?container_configuration)
        )
      )
    :effect (container_configuration_selected ?container_configuration)
  )
  (:action prepare_process_variant_with_instrument
    :parameters (?process_variant - process_variant ?container_configuration - container_configuration ?instrument - instrument)
    :precondition
      (and
        (assessment_active ?process_variant)
        (assigned_instrument ?process_variant ?instrument)
        (process_variant_has_container_configuration ?process_variant ?container_configuration)
        (container_configuration_selected ?container_configuration)
        (not
          (process_variant_ready ?process_variant)
        )
      )
    :effect
      (and
        (process_variant_ready ?process_variant)
        (process_variant_prepared ?process_variant)
      )
  )
  (:action assign_material_to_process_variant
    :parameters (?process_variant - process_variant ?container_configuration - container_configuration ?material_sample - material_sample)
    :precondition
      (and
        (assessment_active ?process_variant)
        (process_variant_has_container_configuration ?process_variant ?container_configuration)
        (material_sample_available ?material_sample)
        (not
          (process_variant_ready ?process_variant)
        )
      )
    :effect
      (and
        (container_configuration_with_material ?container_configuration)
        (process_variant_ready ?process_variant)
        (process_variant_material_assigned ?process_variant ?material_sample)
        (not
          (material_sample_available ?material_sample)
        )
      )
  )
  (:action execute_analysis_on_process_variant_material
    :parameters (?process_variant - process_variant ?container_configuration - container_configuration ?analytical_method_var - analytical_method ?material_sample - material_sample)
    :precondition
      (and
        (assessment_active ?process_variant)
        (assigned_analytical_method ?process_variant ?analytical_method_var)
        (process_variant_has_container_configuration ?process_variant ?container_configuration)
        (container_configuration_with_material ?container_configuration)
        (process_variant_material_assigned ?process_variant ?material_sample)
        (not
          (process_variant_prepared ?process_variant)
        )
      )
    :effect
      (and
        (container_configuration_selected ?container_configuration)
        (process_variant_prepared ?process_variant)
        (material_sample_available ?material_sample)
        (not
          (process_variant_material_assigned ?process_variant ?material_sample)
        )
      )
  )
  (:action instantiate_stability_protocol
    :parameters (?formulation_variant - formulation_variant ?process_variant - process_variant ?stress_condition - stress_condition ?container_configuration - container_configuration ?stability_protocol - stability_protocol)
    :precondition
      (and
        (formulation_variant_ready ?formulation_variant)
        (process_variant_ready ?process_variant)
        (formulation_variant_has_stress_condition ?formulation_variant ?stress_condition)
        (process_variant_has_container_configuration ?process_variant ?container_configuration)
        (stress_condition_selected ?stress_condition)
        (container_configuration_selected ?container_configuration)
        (formulation_variant_prepared ?formulation_variant)
        (process_variant_prepared ?process_variant)
        (stability_protocol_available ?stability_protocol)
      )
    :effect
      (and
        (stability_protocol_activated ?stability_protocol)
        (stability_protocol_assigned_stress_condition ?stability_protocol ?stress_condition)
        (stability_protocol_assigned_container ?stability_protocol ?container_configuration)
        (not
          (stability_protocol_available ?stability_protocol)
        )
      )
  )
  (:action instantiate_stability_protocol_with_intermediate_timepoints
    :parameters (?formulation_variant - formulation_variant ?process_variant - process_variant ?stress_condition - stress_condition ?container_configuration - container_configuration ?stability_protocol - stability_protocol)
    :precondition
      (and
        (formulation_variant_ready ?formulation_variant)
        (process_variant_ready ?process_variant)
        (formulation_variant_has_stress_condition ?formulation_variant ?stress_condition)
        (process_variant_has_container_configuration ?process_variant ?container_configuration)
        (stress_condition_with_material_assigned ?stress_condition)
        (container_configuration_selected ?container_configuration)
        (not
          (formulation_variant_prepared ?formulation_variant)
        )
        (process_variant_prepared ?process_variant)
        (stability_protocol_available ?stability_protocol)
      )
    :effect
      (and
        (stability_protocol_activated ?stability_protocol)
        (stability_protocol_assigned_stress_condition ?stability_protocol ?stress_condition)
        (stability_protocol_assigned_container ?stability_protocol ?container_configuration)
        (stability_protocol_has_intermediate_timepoints ?stability_protocol)
        (not
          (stability_protocol_available ?stability_protocol)
        )
      )
  )
  (:action instantiate_stability_protocol_with_long_term_timepoints
    :parameters (?formulation_variant - formulation_variant ?process_variant - process_variant ?stress_condition - stress_condition ?container_configuration - container_configuration ?stability_protocol - stability_protocol)
    :precondition
      (and
        (formulation_variant_ready ?formulation_variant)
        (process_variant_ready ?process_variant)
        (formulation_variant_has_stress_condition ?formulation_variant ?stress_condition)
        (process_variant_has_container_configuration ?process_variant ?container_configuration)
        (stress_condition_selected ?stress_condition)
        (container_configuration_with_material ?container_configuration)
        (formulation_variant_prepared ?formulation_variant)
        (not
          (process_variant_prepared ?process_variant)
        )
        (stability_protocol_available ?stability_protocol)
      )
    :effect
      (and
        (stability_protocol_activated ?stability_protocol)
        (stability_protocol_assigned_stress_condition ?stability_protocol ?stress_condition)
        (stability_protocol_assigned_container ?stability_protocol ?container_configuration)
        (stability_protocol_has_long_term_timepoints ?stability_protocol)
        (not
          (stability_protocol_available ?stability_protocol)
        )
      )
  )
  (:action instantiate_full_stability_protocol
    :parameters (?formulation_variant - formulation_variant ?process_variant - process_variant ?stress_condition - stress_condition ?container_configuration - container_configuration ?stability_protocol - stability_protocol)
    :precondition
      (and
        (formulation_variant_ready ?formulation_variant)
        (process_variant_ready ?process_variant)
        (formulation_variant_has_stress_condition ?formulation_variant ?stress_condition)
        (process_variant_has_container_configuration ?process_variant ?container_configuration)
        (stress_condition_with_material_assigned ?stress_condition)
        (container_configuration_with_material ?container_configuration)
        (not
          (formulation_variant_prepared ?formulation_variant)
        )
        (not
          (process_variant_prepared ?process_variant)
        )
        (stability_protocol_available ?stability_protocol)
      )
    :effect
      (and
        (stability_protocol_activated ?stability_protocol)
        (stability_protocol_assigned_stress_condition ?stability_protocol ?stress_condition)
        (stability_protocol_assigned_container ?stability_protocol ?container_configuration)
        (stability_protocol_has_intermediate_timepoints ?stability_protocol)
        (stability_protocol_has_long_term_timepoints ?stability_protocol)
        (not
          (stability_protocol_available ?stability_protocol)
        )
      )
  )
  (:action execute_stability_protocol
    :parameters (?stability_protocol - stability_protocol ?formulation_variant - formulation_variant ?analytical_method_var - analytical_method)
    :precondition
      (and
        (stability_protocol_activated ?stability_protocol)
        (formulation_variant_ready ?formulation_variant)
        (assigned_analytical_method ?formulation_variant ?analytical_method_var)
        (not
          (stability_protocol_executed ?stability_protocol)
        )
      )
    :effect (stability_protocol_executed ?stability_protocol)
  )
  (:action register_sample_batch_in_project
    :parameters (?comparability_project - comparability_project ?sample_batch - sample_batch ?stability_protocol - stability_protocol)
    :precondition
      (and
        (assessment_active ?comparability_project)
        (project_includes_stability_protocol ?comparability_project ?stability_protocol)
        (project_has_sample_batch ?comparability_project ?sample_batch)
        (sample_batch_available ?sample_batch)
        (stability_protocol_activated ?stability_protocol)
        (stability_protocol_executed ?stability_protocol)
        (not
          (sample_batch_assigned ?sample_batch)
        )
      )
    :effect
      (and
        (sample_batch_assigned ?sample_batch)
        (sample_batch_linked_to_protocol ?sample_batch ?stability_protocol)
        (not
          (sample_batch_available ?sample_batch)
        )
      )
  )
  (:action prepare_sample_batch_for_analysis
    :parameters (?comparability_project - comparability_project ?sample_batch - sample_batch ?stability_protocol - stability_protocol ?analytical_method_var - analytical_method)
    :precondition
      (and
        (assessment_active ?comparability_project)
        (project_has_sample_batch ?comparability_project ?sample_batch)
        (sample_batch_assigned ?sample_batch)
        (sample_batch_linked_to_protocol ?sample_batch ?stability_protocol)
        (assigned_analytical_method ?comparability_project ?analytical_method_var)
        (not
          (stability_protocol_has_intermediate_timepoints ?stability_protocol)
        )
        (not
          (project_sample_registered ?comparability_project)
        )
      )
    :effect (project_sample_registered ?comparability_project)
  )
  (:action attach_regulatory_document_to_project
    :parameters (?comparability_project - comparability_project ?regulatory_document - regulatory_document)
    :precondition
      (and
        (assessment_active ?comparability_project)
        (regulatory_document_available ?regulatory_document)
        (not
          (project_regulatory_document_present ?comparability_project)
        )
      )
    :effect
      (and
        (project_regulatory_document_present ?comparability_project)
        (project_has_regulatory_document ?comparability_project ?regulatory_document)
        (not
          (regulatory_document_available ?regulatory_document)
        )
      )
  )
  (:action attach_document_and_enable_project_analysis
    :parameters (?comparability_project - comparability_project ?sample_batch - sample_batch ?stability_protocol - stability_protocol ?analytical_method_var - analytical_method ?regulatory_document - regulatory_document)
    :precondition
      (and
        (assessment_active ?comparability_project)
        (project_has_sample_batch ?comparability_project ?sample_batch)
        (sample_batch_assigned ?sample_batch)
        (sample_batch_linked_to_protocol ?sample_batch ?stability_protocol)
        (assigned_analytical_method ?comparability_project ?analytical_method_var)
        (stability_protocol_has_intermediate_timepoints ?stability_protocol)
        (project_regulatory_document_present ?comparability_project)
        (project_has_regulatory_document ?comparability_project ?regulatory_document)
        (not
          (project_sample_registered ?comparability_project)
        )
      )
    :effect
      (and
        (project_sample_registered ?comparability_project)
        (project_regulatory_document_validated ?comparability_project)
      )
  )
  (:action execute_validated_analysis_for_project_variant
    :parameters (?comparability_project - comparability_project ?method_validation - method_validation ?instrument - instrument ?sample_batch - sample_batch ?stability_protocol - stability_protocol)
    :precondition
      (and
        (project_sample_registered ?comparability_project)
        (project_assigned_method_validation ?comparability_project ?method_validation)
        (assigned_instrument ?comparability_project ?instrument)
        (project_has_sample_batch ?comparability_project ?sample_batch)
        (sample_batch_linked_to_protocol ?sample_batch ?stability_protocol)
        (not
          (stability_protocol_has_long_term_timepoints ?stability_protocol)
        )
        (not
          (project_analysis_executed ?comparability_project)
        )
      )
    :effect (project_analysis_executed ?comparability_project)
  )
  (:action execute_validated_analysis_for_project_variant_alternate
    :parameters (?comparability_project - comparability_project ?method_validation - method_validation ?instrument - instrument ?sample_batch - sample_batch ?stability_protocol - stability_protocol)
    :precondition
      (and
        (project_sample_registered ?comparability_project)
        (project_assigned_method_validation ?comparability_project ?method_validation)
        (assigned_instrument ?comparability_project ?instrument)
        (project_has_sample_batch ?comparability_project ?sample_batch)
        (sample_batch_linked_to_protocol ?sample_batch ?stability_protocol)
        (stability_protocol_has_long_term_timepoints ?stability_protocol)
        (not
          (project_analysis_executed ?comparability_project)
        )
      )
    :effect (project_analysis_executed ?comparability_project)
  )
  (:action finalize_analysis_review
    :parameters (?comparability_project - comparability_project ?statistical_analysis_plan - statistical_analysis_plan ?sample_batch - sample_batch ?stability_protocol - stability_protocol)
    :precondition
      (and
        (project_analysis_executed ?comparability_project)
        (project_assigned_sap ?comparability_project ?statistical_analysis_plan)
        (project_has_sample_batch ?comparability_project ?sample_batch)
        (sample_batch_linked_to_protocol ?sample_batch ?stability_protocol)
        (not
          (stability_protocol_has_intermediate_timepoints ?stability_protocol)
        )
        (not
          (stability_protocol_has_long_term_timepoints ?stability_protocol)
        )
        (not
          (project_analysis_reviewed ?comparability_project)
        )
      )
    :effect (project_analysis_reviewed ?comparability_project)
  )
  (:action finalize_analysis_and_flag_for_cqa
    :parameters (?comparability_project - comparability_project ?statistical_analysis_plan - statistical_analysis_plan ?sample_batch - sample_batch ?stability_protocol - stability_protocol)
    :precondition
      (and
        (project_analysis_executed ?comparability_project)
        (project_assigned_sap ?comparability_project ?statistical_analysis_plan)
        (project_has_sample_batch ?comparability_project ?sample_batch)
        (sample_batch_linked_to_protocol ?sample_batch ?stability_protocol)
        (stability_protocol_has_intermediate_timepoints ?stability_protocol)
        (not
          (stability_protocol_has_long_term_timepoints ?stability_protocol)
        )
        (not
          (project_analysis_reviewed ?comparability_project)
        )
      )
    :effect
      (and
        (project_analysis_reviewed ?comparability_project)
        (project_ready_for_cqa_assignment ?comparability_project)
      )
  )
  (:action finalize_analysis_and_flag_for_cqa_alternate
    :parameters (?comparability_project - comparability_project ?statistical_analysis_plan - statistical_analysis_plan ?sample_batch - sample_batch ?stability_protocol - stability_protocol)
    :precondition
      (and
        (project_analysis_executed ?comparability_project)
        (project_assigned_sap ?comparability_project ?statistical_analysis_plan)
        (project_has_sample_batch ?comparability_project ?sample_batch)
        (sample_batch_linked_to_protocol ?sample_batch ?stability_protocol)
        (not
          (stability_protocol_has_intermediate_timepoints ?stability_protocol)
        )
        (stability_protocol_has_long_term_timepoints ?stability_protocol)
        (not
          (project_analysis_reviewed ?comparability_project)
        )
      )
    :effect
      (and
        (project_analysis_reviewed ?comparability_project)
        (project_ready_for_cqa_assignment ?comparability_project)
      )
  )
  (:action finalize_analysis_and_flag_for_cqa_complete
    :parameters (?comparability_project - comparability_project ?statistical_analysis_plan - statistical_analysis_plan ?sample_batch - sample_batch ?stability_protocol - stability_protocol)
    :precondition
      (and
        (project_analysis_executed ?comparability_project)
        (project_assigned_sap ?comparability_project ?statistical_analysis_plan)
        (project_has_sample_batch ?comparability_project ?sample_batch)
        (sample_batch_linked_to_protocol ?sample_batch ?stability_protocol)
        (stability_protocol_has_intermediate_timepoints ?stability_protocol)
        (stability_protocol_has_long_term_timepoints ?stability_protocol)
        (not
          (project_analysis_reviewed ?comparability_project)
        )
      )
    :effect
      (and
        (project_analysis_reviewed ?comparability_project)
        (project_ready_for_cqa_assignment ?comparability_project)
      )
  )
  (:action finalize_project_and_record_conclusion
    :parameters (?comparability_project - comparability_project)
    :precondition
      (and
        (project_analysis_reviewed ?comparability_project)
        (not
          (project_ready_for_cqa_assignment ?comparability_project)
        )
        (not
          (project_finalized ?comparability_project)
        )
      )
    :effect
      (and
        (project_finalized ?comparability_project)
        (conclusion_recorded ?comparability_project)
      )
  )
  (:action assign_cqa_spec_to_project
    :parameters (?comparability_project - comparability_project ?cqa_specification - cqa_specification)
    :precondition
      (and
        (project_analysis_reviewed ?comparability_project)
        (project_ready_for_cqa_assignment ?comparability_project)
        (cqa_specification_available ?cqa_specification)
      )
    :effect
      (and
        (project_assigned_cqa_specification ?comparability_project ?cqa_specification)
        (not
          (cqa_specification_available ?cqa_specification)
        )
      )
  )
  (:action execute_project_level_analysis
    :parameters (?comparability_project - comparability_project ?formulation_variant - formulation_variant ?process_variant - process_variant ?analytical_method_var - analytical_method ?cqa_specification - cqa_specification)
    :precondition
      (and
        (project_analysis_reviewed ?comparability_project)
        (project_ready_for_cqa_assignment ?comparability_project)
        (project_assigned_cqa_specification ?comparability_project ?cqa_specification)
        (project_includes_formulation_variant ?comparability_project ?formulation_variant)
        (project_includes_process_variant ?comparability_project ?process_variant)
        (formulation_variant_prepared ?formulation_variant)
        (process_variant_prepared ?process_variant)
        (assigned_analytical_method ?comparability_project ?analytical_method_var)
        (not
          (project_cqa_assignment_complete ?comparability_project)
        )
      )
    :effect (project_cqa_assignment_complete ?comparability_project)
  )
  (:action close_project_after_quality_review
    :parameters (?comparability_project - comparability_project)
    :precondition
      (and
        (project_analysis_reviewed ?comparability_project)
        (project_cqa_assignment_complete ?comparability_project)
        (not
          (project_finalized ?comparability_project)
        )
      )
    :effect
      (and
        (project_finalized ?comparability_project)
        (conclusion_recorded ?comparability_project)
      )
  )
  (:action acknowledge_reference_standard_for_project
    :parameters (?comparability_project - comparability_project ?reference_standard_batch - reference_standard_batch ?analytical_method_var - analytical_method)
    :precondition
      (and
        (assessment_active ?comparability_project)
        (assigned_analytical_method ?comparability_project ?analytical_method_var)
        (reference_standard_available ?reference_standard_batch)
        (project_associated_with_reference_standard ?comparability_project ?reference_standard_batch)
        (not
          (project_reference_standard_acknowledged ?comparability_project)
        )
      )
    :effect
      (and
        (project_reference_standard_acknowledged ?comparability_project)
        (not
          (reference_standard_available ?reference_standard_batch)
        )
      )
  )
  (:action verify_regulatory_document_and_instrument
    :parameters (?comparability_project - comparability_project ?instrument - instrument)
    :precondition
      (and
        (project_reference_standard_acknowledged ?comparability_project)
        (assigned_instrument ?comparability_project ?instrument)
        (not
          (project_regulatory_checkpoint_passed ?comparability_project)
        )
      )
    :effect (project_regulatory_checkpoint_passed ?comparability_project)
  )
  (:action apply_statistical_analysis_plan_to_project
    :parameters (?comparability_project - comparability_project ?statistical_analysis_plan - statistical_analysis_plan)
    :precondition
      (and
        (project_regulatory_checkpoint_passed ?comparability_project)
        (project_assigned_sap ?comparability_project ?statistical_analysis_plan)
        (not
          (project_sap_applied ?comparability_project)
        )
      )
    :effect (project_sap_applied ?comparability_project)
  )
  (:action close_project_after_sap_application
    :parameters (?comparability_project - comparability_project)
    :precondition
      (and
        (project_sap_applied ?comparability_project)
        (not
          (project_finalized ?comparability_project)
        )
      )
    :effect
      (and
        (project_finalized ?comparability_project)
        (conclusion_recorded ?comparability_project)
      )
  )
  (:action propagate_signoff_to_formulation_variant
    :parameters (?formulation_variant - formulation_variant ?stability_protocol - stability_protocol)
    :precondition
      (and
        (formulation_variant_ready ?formulation_variant)
        (formulation_variant_prepared ?formulation_variant)
        (stability_protocol_activated ?stability_protocol)
        (stability_protocol_executed ?stability_protocol)
        (not
          (conclusion_recorded ?formulation_variant)
        )
      )
    :effect (conclusion_recorded ?formulation_variant)
  )
  (:action propagate_signoff_to_process_variant
    :parameters (?process_variant - process_variant ?stability_protocol - stability_protocol)
    :precondition
      (and
        (process_variant_ready ?process_variant)
        (process_variant_prepared ?process_variant)
        (stability_protocol_activated ?stability_protocol)
        (stability_protocol_executed ?stability_protocol)
        (not
          (conclusion_recorded ?process_variant)
        )
      )
    :effect (conclusion_recorded ?process_variant)
  )
  (:action create_and_assign_evidence_set_to_candidate
    :parameters (?product_candidate - product_candidate ?analytical_evidence_set - analytical_evidence_set ?analytical_method_var - analytical_method)
    :precondition
      (and
        (conclusion_recorded ?product_candidate)
        (assigned_analytical_method ?product_candidate ?analytical_method_var)
        (analytical_evidence_set_available ?analytical_evidence_set)
        (not
          (evidence_assigned ?product_candidate)
        )
      )
    :effect
      (and
        (evidence_assigned ?product_candidate)
        (linked_to_analytical_evidence ?product_candidate ?analytical_evidence_set)
        (not
          (analytical_evidence_set_available ?analytical_evidence_set)
        )
      )
  )
  (:action apply_evidence_and_mark_comparability_for_formulation_variant
    :parameters (?formulation_variant - formulation_variant ?analytical_resource - analytical_resource ?analytical_evidence_set - analytical_evidence_set)
    :precondition
      (and
        (evidence_assigned ?formulation_variant)
        (allocated_analytical_resource ?formulation_variant ?analytical_resource)
        (linked_to_analytical_evidence ?formulation_variant ?analytical_evidence_set)
        (not
          (decision_confirmed ?formulation_variant)
        )
      )
    :effect
      (and
        (decision_confirmed ?formulation_variant)
        (analytical_resource_available ?analytical_resource)
        (analytical_evidence_set_available ?analytical_evidence_set)
      )
  )
  (:action apply_evidence_and_mark_comparability_for_process_variant
    :parameters (?process_variant - process_variant ?analytical_resource - analytical_resource ?analytical_evidence_set - analytical_evidence_set)
    :precondition
      (and
        (evidence_assigned ?process_variant)
        (allocated_analytical_resource ?process_variant ?analytical_resource)
        (linked_to_analytical_evidence ?process_variant ?analytical_evidence_set)
        (not
          (decision_confirmed ?process_variant)
        )
      )
    :effect
      (and
        (decision_confirmed ?process_variant)
        (analytical_resource_available ?analytical_resource)
        (analytical_evidence_set_available ?analytical_evidence_set)
      )
  )
  (:action apply_evidence_and_mark_comparability_for_project
    :parameters (?comparability_project - comparability_project ?analytical_resource - analytical_resource ?analytical_evidence_set - analytical_evidence_set)
    :precondition
      (and
        (evidence_assigned ?comparability_project)
        (allocated_analytical_resource ?comparability_project ?analytical_resource)
        (linked_to_analytical_evidence ?comparability_project ?analytical_evidence_set)
        (not
          (decision_confirmed ?comparability_project)
        )
      )
    :effect
      (and
        (decision_confirmed ?comparability_project)
        (analytical_resource_available ?analytical_resource)
        (analytical_evidence_set_available ?analytical_evidence_set)
      )
  )
)

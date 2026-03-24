(define (domain preservative_system_selection)
  (:requirements :strips :typing :negative-preconditions)
  (:types preservative_resource - object test_category - object material_category - object entity_class - object selection_subject - entity_class preservative_material_sample - preservative_resource assay_method - preservative_resource formulation_batch - preservative_resource regulatory_input - preservative_resource stakeholder_approval - preservative_resource logistics_resource - preservative_resource equipment - preservative_resource risk_assessment - preservative_resource analytical_resource - test_category data_set - test_category external_expert - test_category compatibility_condition - material_category scaleup_parameter - material_category evidence_package - material_category formulation_group - selection_subject development_stream - selection_subject formulation_variant - formulation_group manufacturing_route - formulation_group development_case - development_stream)
  (:predicates
    (subject_registered ?preservative_candidate - selection_subject)
    (subject_testing_completed ?preservative_candidate - selection_subject)
    (subject_material_assigned ?preservative_candidate - selection_subject)
    (finalized_for_handoff ?preservative_candidate - selection_subject)
    (internal_approval_granted ?preservative_candidate - selection_subject)
    (subject_ready_for_handoff ?preservative_candidate - selection_subject)
    (material_sample_available ?preservative_material_sample - preservative_material_sample)
    (subject_material_link ?preservative_candidate - selection_subject ?preservative_material_sample - preservative_material_sample)
    (assay_method_available ?assay_method - assay_method)
    (subject_assay_assignment ?preservative_candidate - selection_subject ?assay_method - assay_method)
    (formulation_batch_available ?formulation_batch - formulation_batch)
    (subject_batch_assignment ?preservative_candidate - selection_subject ?formulation_batch - formulation_batch)
    (analytical_resource_available ?analytical_resource - analytical_resource)
    (variant_analytical_resource_allocation ?formulation_variant - formulation_variant ?analytical_resource - analytical_resource)
    (manufacturing_route_analytical_resource_allocation ?manufacturing_route - manufacturing_route ?analytical_resource - analytical_resource)
    (variant_compatibility_condition_association ?formulation_variant - formulation_variant ?compatibility_condition - compatibility_condition)
    (compatibility_condition_result_recorded ?compatibility_condition - compatibility_condition)
    (compatibility_condition_resource_engaged ?compatibility_condition - compatibility_condition)
    (variant_testing_completed ?formulation_variant - formulation_variant)
    (manufacturing_route_scaleup_parameter_association ?manufacturing_route - manufacturing_route ?scaleup_parameter - scaleup_parameter)
    (scaleup_parameter_result_recorded ?scaleup_parameter - scaleup_parameter)
    (scaleup_parameter_resource_engaged ?scaleup_parameter - scaleup_parameter)
    (manufacturing_route_testing_completed ?manufacturing_route - manufacturing_route)
    (evidence_package_available ?evidence_package - evidence_package)
    (evidence_package_compiled ?evidence_package - evidence_package)
    (evidence_package_link_condition ?evidence_package - evidence_package ?compatibility_condition - compatibility_condition)
    (evidence_package_link_scaleup_parameter ?evidence_package - evidence_package ?scaleup_parameter - scaleup_parameter)
    (evidence_package_includes_equipment_input ?evidence_package - evidence_package)
    (evidence_package_includes_regulatory_input ?evidence_package - evidence_package)
    (evidence_package_validated ?evidence_package - evidence_package)
    (case_includes_formulation_variant ?development_case - development_case ?formulation_variant - formulation_variant)
    (case_includes_manufacturing_route ?development_case - development_case ?manufacturing_route - manufacturing_route)
    (case_includes_evidence_package ?development_case - development_case ?evidence_package - evidence_package)
    (data_set_available ?data_set - data_set)
    (case_includes_data_set ?development_case - development_case ?data_set - data_set)
    (data_set_consumed_for_evidence ?data_set - data_set)
    (data_set_linked_to_evidence_package ?data_set - data_set ?evidence_package - evidence_package)
    (case_prepared_for_review ?development_case - development_case)
    (case_equipment_allocated ?development_case - development_case)
    (case_review_initiated ?development_case - development_case)
    (case_has_regulatory_input ?development_case - development_case)
    (case_regulatory_attachment_confirmed ?development_case - development_case)
    (case_ready_for_stakeholder_approval ?development_case - development_case)
    (case_internal_review_completed ?development_case - development_case)
    (external_expert_available ?external_expert - external_expert)
    (case_external_expert_assignment ?development_case - development_case ?external_expert - external_expert)
    (case_external_consultation_requested ?development_case - development_case)
    (case_external_consultation_scheduled ?development_case - development_case)
    (case_external_consultation_completed ?development_case - development_case)
    (regulatory_input_available ?regulatory_input - regulatory_input)
    (case_regulatory_input_assigned ?development_case - development_case ?regulatory_input - regulatory_input)
    (stakeholder_approval_available ?stakeholder_approval - stakeholder_approval)
    (case_stakeholder_approval_linked ?development_case - development_case ?stakeholder_approval - stakeholder_approval)
    (equipment_available ?equipment - equipment)
    (case_equipment_assigned ?development_case - development_case ?equipment - equipment)
    (risk_assessment_available ?risk_assessment - risk_assessment)
    (case_risk_assessment_associated ?development_case - development_case ?risk_assessment - risk_assessment)
    (logistics_resource_available ?logistics_resource - logistics_resource)
    (subject_logistics_assignment ?preservative_candidate - selection_subject ?logistics_resource - logistics_resource)
    (variant_processed_flag ?formulation_variant - formulation_variant)
    (manufacturing_route_processed_flag ?manufacturing_route - manufacturing_route)
    (case_finalized ?development_case - development_case)
  )
  (:action onboard_preservative_candidate
    :parameters (?preservative_candidate - selection_subject)
    :precondition
      (and
        (not
          (subject_registered ?preservative_candidate)
        )
        (not
          (finalized_for_handoff ?preservative_candidate)
        )
      )
    :effect (subject_registered ?preservative_candidate)
  )
  (:action assign_material_sample_to_candidate
    :parameters (?preservative_candidate - selection_subject ?preservative_material_sample - preservative_material_sample)
    :precondition
      (and
        (subject_registered ?preservative_candidate)
        (not
          (subject_material_assigned ?preservative_candidate)
        )
        (material_sample_available ?preservative_material_sample)
      )
    :effect
      (and
        (subject_material_assigned ?preservative_candidate)
        (subject_material_link ?preservative_candidate ?preservative_material_sample)
        (not
          (material_sample_available ?preservative_material_sample)
        )
      )
  )
  (:action allocate_assay_method_to_candidate
    :parameters (?preservative_candidate - selection_subject ?assay_method - assay_method)
    :precondition
      (and
        (subject_registered ?preservative_candidate)
        (subject_material_assigned ?preservative_candidate)
        (assay_method_available ?assay_method)
      )
    :effect
      (and
        (subject_assay_assignment ?preservative_candidate ?assay_method)
        (not
          (assay_method_available ?assay_method)
        )
      )
  )
  (:action finalize_assay_execution_for_candidate
    :parameters (?preservative_candidate - selection_subject ?assay_method - assay_method)
    :precondition
      (and
        (subject_registered ?preservative_candidate)
        (subject_material_assigned ?preservative_candidate)
        (subject_assay_assignment ?preservative_candidate ?assay_method)
        (not
          (subject_testing_completed ?preservative_candidate)
        )
      )
    :effect (subject_testing_completed ?preservative_candidate)
  )
  (:action release_assay_method
    :parameters (?preservative_candidate - selection_subject ?assay_method - assay_method)
    :precondition
      (and
        (subject_assay_assignment ?preservative_candidate ?assay_method)
      )
    :effect
      (and
        (assay_method_available ?assay_method)
        (not
          (subject_assay_assignment ?preservative_candidate ?assay_method)
        )
      )
  )
  (:action assign_formulation_batch_to_candidate
    :parameters (?preservative_candidate - selection_subject ?formulation_batch - formulation_batch)
    :precondition
      (and
        (subject_testing_completed ?preservative_candidate)
        (formulation_batch_available ?formulation_batch)
      )
    :effect
      (and
        (subject_batch_assignment ?preservative_candidate ?formulation_batch)
        (not
          (formulation_batch_available ?formulation_batch)
        )
      )
  )
  (:action release_formulation_batch
    :parameters (?preservative_candidate - selection_subject ?formulation_batch - formulation_batch)
    :precondition
      (and
        (subject_batch_assignment ?preservative_candidate ?formulation_batch)
      )
    :effect
      (and
        (formulation_batch_available ?formulation_batch)
        (not
          (subject_batch_assignment ?preservative_candidate ?formulation_batch)
        )
      )
  )
  (:action allocate_equipment_to_case
    :parameters (?development_case - development_case ?equipment - equipment)
    :precondition
      (and
        (subject_testing_completed ?development_case)
        (equipment_available ?equipment)
      )
    :effect
      (and
        (case_equipment_assigned ?development_case ?equipment)
        (not
          (equipment_available ?equipment)
        )
      )
  )
  (:action release_equipment_from_case
    :parameters (?development_case - development_case ?equipment - equipment)
    :precondition
      (and
        (case_equipment_assigned ?development_case ?equipment)
      )
    :effect
      (and
        (equipment_available ?equipment)
        (not
          (case_equipment_assigned ?development_case ?equipment)
        )
      )
  )
  (:action assign_risk_assessment_to_case
    :parameters (?development_case - development_case ?risk_assessment - risk_assessment)
    :precondition
      (and
        (subject_testing_completed ?development_case)
        (risk_assessment_available ?risk_assessment)
      )
    :effect
      (and
        (case_risk_assessment_associated ?development_case ?risk_assessment)
        (not
          (risk_assessment_available ?risk_assessment)
        )
      )
  )
  (:action release_risk_assessment_from_case
    :parameters (?development_case - development_case ?risk_assessment - risk_assessment)
    :precondition
      (and
        (case_risk_assessment_associated ?development_case ?risk_assessment)
      )
    :effect
      (and
        (risk_assessment_available ?risk_assessment)
        (not
          (case_risk_assessment_associated ?development_case ?risk_assessment)
        )
      )
  )
  (:action initiate_compatibility_test
    :parameters (?formulation_variant - formulation_variant ?compatibility_condition - compatibility_condition ?assay_method - assay_method)
    :precondition
      (and
        (subject_testing_completed ?formulation_variant)
        (subject_assay_assignment ?formulation_variant ?assay_method)
        (variant_compatibility_condition_association ?formulation_variant ?compatibility_condition)
        (not
          (compatibility_condition_result_recorded ?compatibility_condition)
        )
        (not
          (compatibility_condition_resource_engaged ?compatibility_condition)
        )
      )
    :effect (compatibility_condition_result_recorded ?compatibility_condition)
  )
  (:action record_compatibility_test_outcome
    :parameters (?formulation_variant - formulation_variant ?compatibility_condition - compatibility_condition ?formulation_batch - formulation_batch)
    :precondition
      (and
        (subject_testing_completed ?formulation_variant)
        (subject_batch_assignment ?formulation_variant ?formulation_batch)
        (variant_compatibility_condition_association ?formulation_variant ?compatibility_condition)
        (compatibility_condition_result_recorded ?compatibility_condition)
        (not
          (variant_processed_flag ?formulation_variant)
        )
      )
    :effect
      (and
        (variant_processed_flag ?formulation_variant)
        (variant_testing_completed ?formulation_variant)
      )
  )
  (:action perform_compatibility_test_with_analytical_resources
    :parameters (?formulation_variant - formulation_variant ?compatibility_condition - compatibility_condition ?analytical_resource - analytical_resource)
    :precondition
      (and
        (subject_testing_completed ?formulation_variant)
        (variant_compatibility_condition_association ?formulation_variant ?compatibility_condition)
        (analytical_resource_available ?analytical_resource)
        (not
          (variant_processed_flag ?formulation_variant)
        )
      )
    :effect
      (and
        (compatibility_condition_resource_engaged ?compatibility_condition)
        (variant_processed_flag ?formulation_variant)
        (variant_analytical_resource_allocation ?formulation_variant ?analytical_resource)
        (not
          (analytical_resource_available ?analytical_resource)
        )
      )
  )
  (:action finalize_compatibility_test_and_release_resources
    :parameters (?formulation_variant - formulation_variant ?compatibility_condition - compatibility_condition ?assay_method - assay_method ?analytical_resource - analytical_resource)
    :precondition
      (and
        (subject_testing_completed ?formulation_variant)
        (subject_assay_assignment ?formulation_variant ?assay_method)
        (variant_compatibility_condition_association ?formulation_variant ?compatibility_condition)
        (compatibility_condition_resource_engaged ?compatibility_condition)
        (variant_analytical_resource_allocation ?formulation_variant ?analytical_resource)
        (not
          (variant_testing_completed ?formulation_variant)
        )
      )
    :effect
      (and
        (compatibility_condition_result_recorded ?compatibility_condition)
        (variant_testing_completed ?formulation_variant)
        (analytical_resource_available ?analytical_resource)
        (not
          (variant_analytical_resource_allocation ?formulation_variant ?analytical_resource)
        )
      )
  )
  (:action initiate_scaleup_parameter_evaluation
    :parameters (?manufacturing_route - manufacturing_route ?scaleup_parameter - scaleup_parameter ?assay_method - assay_method)
    :precondition
      (and
        (subject_testing_completed ?manufacturing_route)
        (subject_assay_assignment ?manufacturing_route ?assay_method)
        (manufacturing_route_scaleup_parameter_association ?manufacturing_route ?scaleup_parameter)
        (not
          (scaleup_parameter_result_recorded ?scaleup_parameter)
        )
        (not
          (scaleup_parameter_resource_engaged ?scaleup_parameter)
        )
      )
    :effect (scaleup_parameter_result_recorded ?scaleup_parameter)
  )
  (:action record_scaleup_evaluation_and_reserve_batch
    :parameters (?manufacturing_route - manufacturing_route ?scaleup_parameter - scaleup_parameter ?formulation_batch - formulation_batch)
    :precondition
      (and
        (subject_testing_completed ?manufacturing_route)
        (subject_batch_assignment ?manufacturing_route ?formulation_batch)
        (manufacturing_route_scaleup_parameter_association ?manufacturing_route ?scaleup_parameter)
        (scaleup_parameter_result_recorded ?scaleup_parameter)
        (not
          (manufacturing_route_processed_flag ?manufacturing_route)
        )
      )
    :effect
      (and
        (manufacturing_route_processed_flag ?manufacturing_route)
        (manufacturing_route_testing_completed ?manufacturing_route)
      )
  )
  (:action perform_scaleup_test_with_analytical_resources
    :parameters (?manufacturing_route - manufacturing_route ?scaleup_parameter - scaleup_parameter ?analytical_resource - analytical_resource)
    :precondition
      (and
        (subject_testing_completed ?manufacturing_route)
        (manufacturing_route_scaleup_parameter_association ?manufacturing_route ?scaleup_parameter)
        (analytical_resource_available ?analytical_resource)
        (not
          (manufacturing_route_processed_flag ?manufacturing_route)
        )
      )
    :effect
      (and
        (scaleup_parameter_resource_engaged ?scaleup_parameter)
        (manufacturing_route_processed_flag ?manufacturing_route)
        (manufacturing_route_analytical_resource_allocation ?manufacturing_route ?analytical_resource)
        (not
          (analytical_resource_available ?analytical_resource)
        )
      )
  )
  (:action finalize_scaleup_test_and_release_resources
    :parameters (?manufacturing_route - manufacturing_route ?scaleup_parameter - scaleup_parameter ?assay_method - assay_method ?analytical_resource - analytical_resource)
    :precondition
      (and
        (subject_testing_completed ?manufacturing_route)
        (subject_assay_assignment ?manufacturing_route ?assay_method)
        (manufacturing_route_scaleup_parameter_association ?manufacturing_route ?scaleup_parameter)
        (scaleup_parameter_resource_engaged ?scaleup_parameter)
        (manufacturing_route_analytical_resource_allocation ?manufacturing_route ?analytical_resource)
        (not
          (manufacturing_route_testing_completed ?manufacturing_route)
        )
      )
    :effect
      (and
        (scaleup_parameter_result_recorded ?scaleup_parameter)
        (manufacturing_route_testing_completed ?manufacturing_route)
        (analytical_resource_available ?analytical_resource)
        (not
          (manufacturing_route_analytical_resource_allocation ?manufacturing_route ?analytical_resource)
        )
      )
  )
  (:action compile_intermediate_evidence_package
    :parameters (?formulation_variant - formulation_variant ?manufacturing_route - manufacturing_route ?compatibility_condition - compatibility_condition ?scaleup_parameter - scaleup_parameter ?evidence_package - evidence_package)
    :precondition
      (and
        (variant_processed_flag ?formulation_variant)
        (manufacturing_route_processed_flag ?manufacturing_route)
        (variant_compatibility_condition_association ?formulation_variant ?compatibility_condition)
        (manufacturing_route_scaleup_parameter_association ?manufacturing_route ?scaleup_parameter)
        (compatibility_condition_result_recorded ?compatibility_condition)
        (scaleup_parameter_result_recorded ?scaleup_parameter)
        (variant_testing_completed ?formulation_variant)
        (manufacturing_route_testing_completed ?manufacturing_route)
        (evidence_package_available ?evidence_package)
      )
    :effect
      (and
        (evidence_package_compiled ?evidence_package)
        (evidence_package_link_condition ?evidence_package ?compatibility_condition)
        (evidence_package_link_scaleup_parameter ?evidence_package ?scaleup_parameter)
        (not
          (evidence_package_available ?evidence_package)
        )
      )
  )
  (:action compile_intermediate_evidence_with_equipment_input
    :parameters (?formulation_variant - formulation_variant ?manufacturing_route - manufacturing_route ?compatibility_condition - compatibility_condition ?scaleup_parameter - scaleup_parameter ?evidence_package - evidence_package)
    :precondition
      (and
        (variant_processed_flag ?formulation_variant)
        (manufacturing_route_processed_flag ?manufacturing_route)
        (variant_compatibility_condition_association ?formulation_variant ?compatibility_condition)
        (manufacturing_route_scaleup_parameter_association ?manufacturing_route ?scaleup_parameter)
        (compatibility_condition_resource_engaged ?compatibility_condition)
        (scaleup_parameter_result_recorded ?scaleup_parameter)
        (not
          (variant_testing_completed ?formulation_variant)
        )
        (manufacturing_route_testing_completed ?manufacturing_route)
        (evidence_package_available ?evidence_package)
      )
    :effect
      (and
        (evidence_package_compiled ?evidence_package)
        (evidence_package_link_condition ?evidence_package ?compatibility_condition)
        (evidence_package_link_scaleup_parameter ?evidence_package ?scaleup_parameter)
        (evidence_package_includes_equipment_input ?evidence_package)
        (not
          (evidence_package_available ?evidence_package)
        )
      )
  )
  (:action compile_intermediate_evidence_with_regulatory_input
    :parameters (?formulation_variant - formulation_variant ?manufacturing_route - manufacturing_route ?compatibility_condition - compatibility_condition ?scaleup_parameter - scaleup_parameter ?evidence_package - evidence_package)
    :precondition
      (and
        (variant_processed_flag ?formulation_variant)
        (manufacturing_route_processed_flag ?manufacturing_route)
        (variant_compatibility_condition_association ?formulation_variant ?compatibility_condition)
        (manufacturing_route_scaleup_parameter_association ?manufacturing_route ?scaleup_parameter)
        (compatibility_condition_result_recorded ?compatibility_condition)
        (scaleup_parameter_resource_engaged ?scaleup_parameter)
        (variant_testing_completed ?formulation_variant)
        (not
          (manufacturing_route_testing_completed ?manufacturing_route)
        )
        (evidence_package_available ?evidence_package)
      )
    :effect
      (and
        (evidence_package_compiled ?evidence_package)
        (evidence_package_link_condition ?evidence_package ?compatibility_condition)
        (evidence_package_link_scaleup_parameter ?evidence_package ?scaleup_parameter)
        (evidence_package_includes_regulatory_input ?evidence_package)
        (not
          (evidence_package_available ?evidence_package)
        )
      )
  )
  (:action compile_intermediate_evidence_with_equipment_and_regulatory_inputs
    :parameters (?formulation_variant - formulation_variant ?manufacturing_route - manufacturing_route ?compatibility_condition - compatibility_condition ?scaleup_parameter - scaleup_parameter ?evidence_package - evidence_package)
    :precondition
      (and
        (variant_processed_flag ?formulation_variant)
        (manufacturing_route_processed_flag ?manufacturing_route)
        (variant_compatibility_condition_association ?formulation_variant ?compatibility_condition)
        (manufacturing_route_scaleup_parameter_association ?manufacturing_route ?scaleup_parameter)
        (compatibility_condition_resource_engaged ?compatibility_condition)
        (scaleup_parameter_resource_engaged ?scaleup_parameter)
        (not
          (variant_testing_completed ?formulation_variant)
        )
        (not
          (manufacturing_route_testing_completed ?manufacturing_route)
        )
        (evidence_package_available ?evidence_package)
      )
    :effect
      (and
        (evidence_package_compiled ?evidence_package)
        (evidence_package_link_condition ?evidence_package ?compatibility_condition)
        (evidence_package_link_scaleup_parameter ?evidence_package ?scaleup_parameter)
        (evidence_package_includes_equipment_input ?evidence_package)
        (evidence_package_includes_regulatory_input ?evidence_package)
        (not
          (evidence_package_available ?evidence_package)
        )
      )
  )
  (:action validate_evidence_package
    :parameters (?evidence_package - evidence_package ?formulation_variant - formulation_variant ?assay_method - assay_method)
    :precondition
      (and
        (evidence_package_compiled ?evidence_package)
        (variant_processed_flag ?formulation_variant)
        (subject_assay_assignment ?formulation_variant ?assay_method)
        (not
          (evidence_package_validated ?evidence_package)
        )
      )
    :effect (evidence_package_validated ?evidence_package)
  )
  (:action link_data_set_to_evidence_package
    :parameters (?development_case - development_case ?data_set - data_set ?evidence_package - evidence_package)
    :precondition
      (and
        (subject_testing_completed ?development_case)
        (case_includes_evidence_package ?development_case ?evidence_package)
        (case_includes_data_set ?development_case ?data_set)
        (data_set_available ?data_set)
        (evidence_package_compiled ?evidence_package)
        (evidence_package_validated ?evidence_package)
        (not
          (data_set_consumed_for_evidence ?data_set)
        )
      )
    :effect
      (and
        (data_set_consumed_for_evidence ?data_set)
        (data_set_linked_to_evidence_package ?data_set ?evidence_package)
        (not
          (data_set_available ?data_set)
        )
      )
  )
  (:action prepare_case_for_internal_review
    :parameters (?development_case - development_case ?data_set - data_set ?evidence_package - evidence_package ?assay_method - assay_method)
    :precondition
      (and
        (subject_testing_completed ?development_case)
        (case_includes_data_set ?development_case ?data_set)
        (data_set_consumed_for_evidence ?data_set)
        (data_set_linked_to_evidence_package ?data_set ?evidence_package)
        (subject_assay_assignment ?development_case ?assay_method)
        (not
          (evidence_package_includes_equipment_input ?evidence_package)
        )
        (not
          (case_prepared_for_review ?development_case)
        )
      )
    :effect (case_prepared_for_review ?development_case)
  )
  (:action assign_regulatory_input_to_case
    :parameters (?development_case - development_case ?regulatory_input - regulatory_input)
    :precondition
      (and
        (subject_testing_completed ?development_case)
        (regulatory_input_available ?regulatory_input)
        (not
          (case_has_regulatory_input ?development_case)
        )
      )
    :effect
      (and
        (case_has_regulatory_input ?development_case)
        (case_regulatory_input_assigned ?development_case ?regulatory_input)
        (not
          (regulatory_input_available ?regulatory_input)
        )
      )
  )
  (:action integrate_regulatory_input_and_finalize_case_linkage
    :parameters (?development_case - development_case ?data_set - data_set ?evidence_package - evidence_package ?assay_method - assay_method ?regulatory_input - regulatory_input)
    :precondition
      (and
        (subject_testing_completed ?development_case)
        (case_includes_data_set ?development_case ?data_set)
        (data_set_consumed_for_evidence ?data_set)
        (data_set_linked_to_evidence_package ?data_set ?evidence_package)
        (subject_assay_assignment ?development_case ?assay_method)
        (evidence_package_includes_equipment_input ?evidence_package)
        (case_has_regulatory_input ?development_case)
        (case_regulatory_input_assigned ?development_case ?regulatory_input)
        (not
          (case_prepared_for_review ?development_case)
        )
      )
    :effect
      (and
        (case_prepared_for_review ?development_case)
        (case_regulatory_attachment_confirmed ?development_case)
      )
  )
  (:action assign_equipment_and_prepare_case_for_expert_review
    :parameters (?development_case - development_case ?equipment - equipment ?formulation_batch - formulation_batch ?data_set - data_set ?evidence_package - evidence_package)
    :precondition
      (and
        (case_prepared_for_review ?development_case)
        (case_equipment_assigned ?development_case ?equipment)
        (subject_batch_assignment ?development_case ?formulation_batch)
        (case_includes_data_set ?development_case ?data_set)
        (data_set_linked_to_evidence_package ?data_set ?evidence_package)
        (not
          (evidence_package_includes_regulatory_input ?evidence_package)
        )
        (not
          (case_equipment_allocated ?development_case)
        )
      )
    :effect (case_equipment_allocated ?development_case)
  )
  (:action confirm_equipment_and_prepare_case_for_expert_review
    :parameters (?development_case - development_case ?equipment - equipment ?formulation_batch - formulation_batch ?data_set - data_set ?evidence_package - evidence_package)
    :precondition
      (and
        (case_prepared_for_review ?development_case)
        (case_equipment_assigned ?development_case ?equipment)
        (subject_batch_assignment ?development_case ?formulation_batch)
        (case_includes_data_set ?development_case ?data_set)
        (data_set_linked_to_evidence_package ?data_set ?evidence_package)
        (evidence_package_includes_regulatory_input ?evidence_package)
        (not
          (case_equipment_allocated ?development_case)
        )
      )
    :effect (case_equipment_allocated ?development_case)
  )
  (:action initiate_internal_review
    :parameters (?development_case - development_case ?risk_assessment - risk_assessment ?data_set - data_set ?evidence_package - evidence_package)
    :precondition
      (and
        (case_equipment_allocated ?development_case)
        (case_risk_assessment_associated ?development_case ?risk_assessment)
        (case_includes_data_set ?development_case ?data_set)
        (data_set_linked_to_evidence_package ?data_set ?evidence_package)
        (not
          (evidence_package_includes_equipment_input ?evidence_package)
        )
        (not
          (evidence_package_includes_regulatory_input ?evidence_package)
        )
        (not
          (case_review_initiated ?development_case)
        )
      )
    :effect (case_review_initiated ?development_case)
  )
  (:action initiate_internal_review_with_equipment_input
    :parameters (?development_case - development_case ?risk_assessment - risk_assessment ?data_set - data_set ?evidence_package - evidence_package)
    :precondition
      (and
        (case_equipment_allocated ?development_case)
        (case_risk_assessment_associated ?development_case ?risk_assessment)
        (case_includes_data_set ?development_case ?data_set)
        (data_set_linked_to_evidence_package ?data_set ?evidence_package)
        (evidence_package_includes_equipment_input ?evidence_package)
        (not
          (evidence_package_includes_regulatory_input ?evidence_package)
        )
        (not
          (case_review_initiated ?development_case)
        )
      )
    :effect
      (and
        (case_review_initiated ?development_case)
        (case_ready_for_stakeholder_approval ?development_case)
      )
  )
  (:action initiate_internal_review_with_regulatory_input
    :parameters (?development_case - development_case ?risk_assessment - risk_assessment ?data_set - data_set ?evidence_package - evidence_package)
    :precondition
      (and
        (case_equipment_allocated ?development_case)
        (case_risk_assessment_associated ?development_case ?risk_assessment)
        (case_includes_data_set ?development_case ?data_set)
        (data_set_linked_to_evidence_package ?data_set ?evidence_package)
        (not
          (evidence_package_includes_equipment_input ?evidence_package)
        )
        (evidence_package_includes_regulatory_input ?evidence_package)
        (not
          (case_review_initiated ?development_case)
        )
      )
    :effect
      (and
        (case_review_initiated ?development_case)
        (case_ready_for_stakeholder_approval ?development_case)
      )
  )
  (:action initiate_internal_review_with_equipment_and_regulatory_inputs
    :parameters (?development_case - development_case ?risk_assessment - risk_assessment ?data_set - data_set ?evidence_package - evidence_package)
    :precondition
      (and
        (case_equipment_allocated ?development_case)
        (case_risk_assessment_associated ?development_case ?risk_assessment)
        (case_includes_data_set ?development_case ?data_set)
        (data_set_linked_to_evidence_package ?data_set ?evidence_package)
        (evidence_package_includes_equipment_input ?evidence_package)
        (evidence_package_includes_regulatory_input ?evidence_package)
        (not
          (case_review_initiated ?development_case)
        )
      )
    :effect
      (and
        (case_review_initiated ?development_case)
        (case_ready_for_stakeholder_approval ?development_case)
      )
  )
  (:action complete_internal_review
    :parameters (?development_case - development_case)
    :precondition
      (and
        (case_review_initiated ?development_case)
        (not
          (case_ready_for_stakeholder_approval ?development_case)
        )
        (not
          (case_finalized ?development_case)
        )
      )
    :effect
      (and
        (case_finalized ?development_case)
        (internal_approval_granted ?development_case)
      )
  )
  (:action record_stakeholder_approval_for_case
    :parameters (?development_case - development_case ?stakeholder_approval - stakeholder_approval)
    :precondition
      (and
        (case_review_initiated ?development_case)
        (case_ready_for_stakeholder_approval ?development_case)
        (stakeholder_approval_available ?stakeholder_approval)
      )
    :effect
      (and
        (case_stakeholder_approval_linked ?development_case ?stakeholder_approval)
        (not
          (stakeholder_approval_available ?stakeholder_approval)
        )
      )
  )
  (:action perform_cross_case_validation
    :parameters (?development_case - development_case ?formulation_variant - formulation_variant ?manufacturing_route - manufacturing_route ?assay_method - assay_method ?stakeholder_approval - stakeholder_approval)
    :precondition
      (and
        (case_review_initiated ?development_case)
        (case_ready_for_stakeholder_approval ?development_case)
        (case_stakeholder_approval_linked ?development_case ?stakeholder_approval)
        (case_includes_formulation_variant ?development_case ?formulation_variant)
        (case_includes_manufacturing_route ?development_case ?manufacturing_route)
        (variant_testing_completed ?formulation_variant)
        (manufacturing_route_testing_completed ?manufacturing_route)
        (subject_assay_assignment ?development_case ?assay_method)
        (not
          (case_internal_review_completed ?development_case)
        )
      )
    :effect (case_internal_review_completed ?development_case)
  )
  (:action finalize_case_after_internal_validation
    :parameters (?development_case - development_case)
    :precondition
      (and
        (case_review_initiated ?development_case)
        (case_internal_review_completed ?development_case)
        (not
          (case_finalized ?development_case)
        )
      )
    :effect
      (and
        (case_finalized ?development_case)
        (internal_approval_granted ?development_case)
      )
  )
  (:action engage_external_expert_for_case
    :parameters (?development_case - development_case ?external_expert - external_expert ?assay_method - assay_method)
    :precondition
      (and
        (subject_testing_completed ?development_case)
        (subject_assay_assignment ?development_case ?assay_method)
        (external_expert_available ?external_expert)
        (case_external_expert_assignment ?development_case ?external_expert)
        (not
          (case_external_consultation_requested ?development_case)
        )
      )
    :effect
      (and
        (case_external_consultation_requested ?development_case)
        (not
          (external_expert_available ?external_expert)
        )
      )
  )
  (:action schedule_external_consultation
    :parameters (?development_case - development_case ?formulation_batch - formulation_batch)
    :precondition
      (and
        (case_external_consultation_requested ?development_case)
        (subject_batch_assignment ?development_case ?formulation_batch)
        (not
          (case_external_consultation_scheduled ?development_case)
        )
      )
    :effect (case_external_consultation_scheduled ?development_case)
  )
  (:action complete_external_consultation
    :parameters (?development_case - development_case ?risk_assessment - risk_assessment)
    :precondition
      (and
        (case_external_consultation_scheduled ?development_case)
        (case_risk_assessment_associated ?development_case ?risk_assessment)
        (not
          (case_external_consultation_completed ?development_case)
        )
      )
    :effect (case_external_consultation_completed ?development_case)
  )
  (:action finalize_case_after_external_consultation
    :parameters (?development_case - development_case)
    :precondition
      (and
        (case_external_consultation_completed ?development_case)
        (not
          (case_finalized ?development_case)
        )
      )
    :effect
      (and
        (case_finalized ?development_case)
        (internal_approval_granted ?development_case)
      )
  )
  (:action finalize_variant_selection
    :parameters (?formulation_variant - formulation_variant ?evidence_package - evidence_package)
    :precondition
      (and
        (variant_processed_flag ?formulation_variant)
        (variant_testing_completed ?formulation_variant)
        (evidence_package_compiled ?evidence_package)
        (evidence_package_validated ?evidence_package)
        (not
          (internal_approval_granted ?formulation_variant)
        )
      )
    :effect (internal_approval_granted ?formulation_variant)
  )
  (:action finalize_manufacturing_route_selection
    :parameters (?manufacturing_route - manufacturing_route ?evidence_package - evidence_package)
    :precondition
      (and
        (manufacturing_route_processed_flag ?manufacturing_route)
        (manufacturing_route_testing_completed ?manufacturing_route)
        (evidence_package_compiled ?evidence_package)
        (evidence_package_validated ?evidence_package)
        (not
          (internal_approval_granted ?manufacturing_route)
        )
      )
    :effect (internal_approval_granted ?manufacturing_route)
  )
  (:action allocate_logistics_and_mark_candidate_ready
    :parameters (?preservative_candidate - selection_subject ?logistics_resource - logistics_resource ?assay_method - assay_method)
    :precondition
      (and
        (internal_approval_granted ?preservative_candidate)
        (subject_assay_assignment ?preservative_candidate ?assay_method)
        (logistics_resource_available ?logistics_resource)
        (not
          (subject_ready_for_handoff ?preservative_candidate)
        )
      )
    :effect
      (and
        (subject_ready_for_handoff ?preservative_candidate)
        (subject_logistics_assignment ?preservative_candidate ?logistics_resource)
        (not
          (logistics_resource_available ?logistics_resource)
        )
      )
  )
  (:action finalize_variant_handover
    :parameters (?formulation_variant - formulation_variant ?preservative_material_sample - preservative_material_sample ?logistics_resource - logistics_resource)
    :precondition
      (and
        (subject_ready_for_handoff ?formulation_variant)
        (subject_material_link ?formulation_variant ?preservative_material_sample)
        (subject_logistics_assignment ?formulation_variant ?logistics_resource)
        (not
          (finalized_for_handoff ?formulation_variant)
        )
      )
    :effect
      (and
        (finalized_for_handoff ?formulation_variant)
        (material_sample_available ?preservative_material_sample)
        (logistics_resource_available ?logistics_resource)
      )
  )
  (:action finalize_manufacturing_route_handover
    :parameters (?manufacturing_route - manufacturing_route ?preservative_material_sample - preservative_material_sample ?logistics_resource - logistics_resource)
    :precondition
      (and
        (subject_ready_for_handoff ?manufacturing_route)
        (subject_material_link ?manufacturing_route ?preservative_material_sample)
        (subject_logistics_assignment ?manufacturing_route ?logistics_resource)
        (not
          (finalized_for_handoff ?manufacturing_route)
        )
      )
    :effect
      (and
        (finalized_for_handoff ?manufacturing_route)
        (material_sample_available ?preservative_material_sample)
        (logistics_resource_available ?logistics_resource)
      )
  )
  (:action finalize_case_handover
    :parameters (?development_case - development_case ?preservative_material_sample - preservative_material_sample ?logistics_resource - logistics_resource)
    :precondition
      (and
        (subject_ready_for_handoff ?development_case)
        (subject_material_link ?development_case ?preservative_material_sample)
        (subject_logistics_assignment ?development_case ?logistics_resource)
        (not
          (finalized_for_handoff ?development_case)
        )
      )
    :effect
      (and
        (finalized_for_handoff ?development_case)
        (material_sample_available ?preservative_material_sample)
        (logistics_resource_available ?logistics_resource)
      )
  )
)

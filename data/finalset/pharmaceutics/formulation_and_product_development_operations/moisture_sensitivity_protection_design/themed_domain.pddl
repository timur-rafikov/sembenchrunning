(define (domain moisture_sensitivity_protection_design_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object data_asset_category - object infrastructure_category - object product_class - object design_entity - product_class packaging_strategy_option - resource_category analytical_test_method - resource_category laboratory_test_site - resource_category regulatory_requirement - resource_category manufacturability_constraint - resource_category representative_test_sample - resource_category barrier_material_candidate - resource_category accelerated_stability_condition - resource_category protective_excipient_candidate - data_asset_category analytical_dataset - data_asset_category external_stakeholder_input - data_asset_category moisture_exposure_scenario - infrastructure_category packaging_component_option - infrastructure_category protection_design_proposal - infrastructure_category candidate_class - design_entity package_class - design_entity formulation_variant - candidate_class manufacturing_process_option - candidate_class development_package - package_class)
  (:predicates
    (candidate_registered ?product_candidate - design_entity)
    (entity_ready_for_integration ?product_candidate - design_entity)
    (packaging_strategy_assigned ?product_candidate - design_entity)
    (protection_finalized ?product_candidate - design_entity)
    (design_approved_entity ?product_candidate - design_entity)
    (entity_sample_allocated ?product_candidate - design_entity)
    (packaging_strategy_available ?packaging_strategy_option - packaging_strategy_option)
    (entity_has_packaging_strategy ?product_candidate - design_entity ?packaging_strategy_option - packaging_strategy_option)
    (analytical_method_available ?analytical_test_method - analytical_test_method)
    (entity_associated_test_method ?product_candidate - design_entity ?analytical_test_method - analytical_test_method)
    (laboratory_available ?laboratory_test_site - laboratory_test_site)
    (entity_assigned_to_lab ?product_candidate - design_entity ?laboratory_test_site - laboratory_test_site)
    (protective_excipient_available ?protective_excipient_candidate - protective_excipient_candidate)
    (variant_has_excipient_candidate ?formulation_variant - formulation_variant ?protective_excipient_candidate - protective_excipient_candidate)
    (process_has_excipient_candidate ?manufacturing_process_option - manufacturing_process_option ?protective_excipient_candidate - protective_excipient_candidate)
    (variant_exposure_applicability ?formulation_variant - formulation_variant ?moisture_exposure_scenario - moisture_exposure_scenario)
    (exposure_screen_active ?moisture_exposure_scenario - moisture_exposure_scenario)
    (exposure_excipient_intervention_assigned ?moisture_exposure_scenario - moisture_exposure_scenario)
    (variant_screen_result_recorded ?formulation_variant - formulation_variant)
    (process_packaging_component_link ?manufacturing_process_option - manufacturing_process_option ?packaging_component_option - packaging_component_option)
    (packaging_component_screen_active ?packaging_component_option - packaging_component_option)
    (packaging_component_excipient_intervention_assigned ?packaging_component_option - packaging_component_option)
    (process_screen_result_recorded ?manufacturing_process_option - manufacturing_process_option)
    (proposal_pending_integration ?protection_design_proposal - protection_design_proposal)
    (proposal_committed ?protection_design_proposal - protection_design_proposal)
    (proposal_applies_to_exposure ?protection_design_proposal - protection_design_proposal ?moisture_exposure_scenario - moisture_exposure_scenario)
    (proposal_includes_packaging_component ?protection_design_proposal - protection_design_proposal ?packaging_component_option - packaging_component_option)
    (proposal_has_barrier_material_flag ?protection_design_proposal - protection_design_proposal)
    (proposal_has_coating_flag ?protection_design_proposal - protection_design_proposal)
    (proposal_challenge_test_completed ?protection_design_proposal - protection_design_proposal)
    (package_includes_formulation_variant ?development_package - development_package ?formulation_variant - formulation_variant)
    (package_includes_process_option ?development_package - development_package ?manufacturing_process_option - manufacturing_process_option)
    (package_includes_protection_design_proposal ?development_package - development_package ?protection_design_proposal - protection_design_proposal)
    (analytical_dataset_available ?analytical_dataset - analytical_dataset)
    (package_has_dataset ?development_package - development_package ?analytical_dataset - analytical_dataset)
    (analytical_dataset_validated ?analytical_dataset - analytical_dataset)
    (dataset_supports_proposal ?analytical_dataset - analytical_dataset ?protection_design_proposal - protection_design_proposal)
    (package_barrier_evaluation_started ?development_package - development_package)
    (package_barrier_candidate_selected ?development_package - development_package)
    (accelerated_condition_applied ?development_package - development_package)
    (regulatory_requirement_attached ?development_package - development_package)
    (regulatory_requirement_confirmed ?development_package - development_package)
    (accelerated_condition_evidence_recorded ?development_package - development_package)
    (design_review_completed ?development_package - development_package)
    (stakeholder_input_available ?external_stakeholder_input - external_stakeholder_input)
    (package_has_stakeholder_input ?development_package - development_package ?external_stakeholder_input - external_stakeholder_input)
    (package_stakeholder_feedback_applied ?development_package - development_package)
    (package_control_applied ?development_package - development_package)
    (package_control_verified ?development_package - development_package)
    (regulatory_requirement_available ?regulatory_requirement - regulatory_requirement)
    (package_linked_regulatory_requirement ?development_package - development_package ?regulatory_requirement - regulatory_requirement)
    (manufacturability_constraint_available ?manufacturability_constraint - manufacturability_constraint)
    (package_has_manufacturability_constraint ?development_package - development_package ?manufacturability_constraint - manufacturability_constraint)
    (barrier_material_available ?barrier_material_candidate - barrier_material_candidate)
    (package_assigned_barrier_material ?development_package - development_package ?barrier_material_candidate - barrier_material_candidate)
    (accelerated_condition_available ?accelerated_stability_condition - accelerated_stability_condition)
    (package_assigned_accelerated_condition ?development_package - development_package ?accelerated_stability_condition - accelerated_stability_condition)
    (representative_test_sample_available ?representative_test_sample - representative_test_sample)
    (entity_has_representative_sample ?product_candidate - design_entity ?representative_test_sample - representative_test_sample)
    (variant_screen_started ?formulation_variant - formulation_variant)
    (process_screen_started ?manufacturing_process_option - manufacturing_process_option)
    (development_package_finalized ?development_package - development_package)
  )
  (:action register_product_candidate
    :parameters (?product_candidate - design_entity)
    :precondition
      (and
        (not
          (candidate_registered ?product_candidate)
        )
        (not
          (protection_finalized ?product_candidate)
        )
      )
    :effect (candidate_registered ?product_candidate)
  )
  (:action allocate_packaging_strategy
    :parameters (?product_candidate - design_entity ?packaging_strategy_option - packaging_strategy_option)
    :precondition
      (and
        (candidate_registered ?product_candidate)
        (not
          (packaging_strategy_assigned ?product_candidate)
        )
        (packaging_strategy_available ?packaging_strategy_option)
      )
    :effect
      (and
        (packaging_strategy_assigned ?product_candidate)
        (entity_has_packaging_strategy ?product_candidate ?packaging_strategy_option)
        (not
          (packaging_strategy_available ?packaging_strategy_option)
        )
      )
  )
  (:action assign_analytical_test_method
    :parameters (?product_candidate - design_entity ?analytical_test_method - analytical_test_method)
    :precondition
      (and
        (candidate_registered ?product_candidate)
        (packaging_strategy_assigned ?product_candidate)
        (analytical_method_available ?analytical_test_method)
      )
    :effect
      (and
        (entity_associated_test_method ?product_candidate ?analytical_test_method)
        (not
          (analytical_method_available ?analytical_test_method)
        )
      )
  )
  (:action finalize_candidate_allocation
    :parameters (?product_candidate - design_entity ?analytical_test_method - analytical_test_method)
    :precondition
      (and
        (candidate_registered ?product_candidate)
        (packaging_strategy_assigned ?product_candidate)
        (entity_associated_test_method ?product_candidate ?analytical_test_method)
        (not
          (entity_ready_for_integration ?product_candidate)
        )
      )
    :effect (entity_ready_for_integration ?product_candidate)
  )
  (:action release_analytical_test_method
    :parameters (?product_candidate - design_entity ?analytical_test_method - analytical_test_method)
    :precondition
      (and
        (entity_associated_test_method ?product_candidate ?analytical_test_method)
      )
    :effect
      (and
        (analytical_method_available ?analytical_test_method)
        (not
          (entity_associated_test_method ?product_candidate ?analytical_test_method)
        )
      )
  )
  (:action assign_lab_to_candidate
    :parameters (?product_candidate - design_entity ?laboratory_test_site - laboratory_test_site)
    :precondition
      (and
        (entity_ready_for_integration ?product_candidate)
        (laboratory_available ?laboratory_test_site)
      )
    :effect
      (and
        (entity_assigned_to_lab ?product_candidate ?laboratory_test_site)
        (not
          (laboratory_available ?laboratory_test_site)
        )
      )
  )
  (:action release_lab_assignment
    :parameters (?product_candidate - design_entity ?laboratory_test_site - laboratory_test_site)
    :precondition
      (and
        (entity_assigned_to_lab ?product_candidate ?laboratory_test_site)
      )
    :effect
      (and
        (laboratory_available ?laboratory_test_site)
        (not
          (entity_assigned_to_lab ?product_candidate ?laboratory_test_site)
        )
      )
  )
  (:action assign_barrier_material
    :parameters (?development_package - development_package ?barrier_material_candidate - barrier_material_candidate)
    :precondition
      (and
        (entity_ready_for_integration ?development_package)
        (barrier_material_available ?barrier_material_candidate)
      )
    :effect
      (and
        (package_assigned_barrier_material ?development_package ?barrier_material_candidate)
        (not
          (barrier_material_available ?barrier_material_candidate)
        )
      )
  )
  (:action release_barrier_material_assignment
    :parameters (?development_package - development_package ?barrier_material_candidate - barrier_material_candidate)
    :precondition
      (and
        (package_assigned_barrier_material ?development_package ?barrier_material_candidate)
      )
    :effect
      (and
        (barrier_material_available ?barrier_material_candidate)
        (not
          (package_assigned_barrier_material ?development_package ?barrier_material_candidate)
        )
      )
  )
  (:action assign_accelerated_condition
    :parameters (?development_package - development_package ?accelerated_stability_condition - accelerated_stability_condition)
    :precondition
      (and
        (entity_ready_for_integration ?development_package)
        (accelerated_condition_available ?accelerated_stability_condition)
      )
    :effect
      (and
        (package_assigned_accelerated_condition ?development_package ?accelerated_stability_condition)
        (not
          (accelerated_condition_available ?accelerated_stability_condition)
        )
      )
  )
  (:action release_accelerated_condition_assignment
    :parameters (?development_package - development_package ?accelerated_stability_condition - accelerated_stability_condition)
    :precondition
      (and
        (package_assigned_accelerated_condition ?development_package ?accelerated_stability_condition)
      )
    :effect
      (and
        (accelerated_condition_available ?accelerated_stability_condition)
        (not
          (package_assigned_accelerated_condition ?development_package ?accelerated_stability_condition)
        )
      )
  )
  (:action initiate_variant_exposure_screen
    :parameters (?formulation_variant - formulation_variant ?moisture_exposure_scenario - moisture_exposure_scenario ?analytical_test_method - analytical_test_method)
    :precondition
      (and
        (entity_ready_for_integration ?formulation_variant)
        (entity_associated_test_method ?formulation_variant ?analytical_test_method)
        (variant_exposure_applicability ?formulation_variant ?moisture_exposure_scenario)
        (not
          (exposure_screen_active ?moisture_exposure_scenario)
        )
        (not
          (exposure_excipient_intervention_assigned ?moisture_exposure_scenario)
        )
      )
    :effect (exposure_screen_active ?moisture_exposure_scenario)
  )
  (:action perform_variant_lab_screen
    :parameters (?formulation_variant - formulation_variant ?moisture_exposure_scenario - moisture_exposure_scenario ?laboratory_test_site - laboratory_test_site)
    :precondition
      (and
        (entity_ready_for_integration ?formulation_variant)
        (entity_assigned_to_lab ?formulation_variant ?laboratory_test_site)
        (variant_exposure_applicability ?formulation_variant ?moisture_exposure_scenario)
        (exposure_screen_active ?moisture_exposure_scenario)
        (not
          (variant_screen_started ?formulation_variant)
        )
      )
    :effect
      (and
        (variant_screen_started ?formulation_variant)
        (variant_screen_result_recorded ?formulation_variant)
      )
  )
  (:action assign_excipient_to_variant
    :parameters (?formulation_variant - formulation_variant ?moisture_exposure_scenario - moisture_exposure_scenario ?protective_excipient_candidate - protective_excipient_candidate)
    :precondition
      (and
        (entity_ready_for_integration ?formulation_variant)
        (variant_exposure_applicability ?formulation_variant ?moisture_exposure_scenario)
        (protective_excipient_available ?protective_excipient_candidate)
        (not
          (variant_screen_started ?formulation_variant)
        )
      )
    :effect
      (and
        (exposure_excipient_intervention_assigned ?moisture_exposure_scenario)
        (variant_screen_started ?formulation_variant)
        (variant_has_excipient_candidate ?formulation_variant ?protective_excipient_candidate)
        (not
          (protective_excipient_available ?protective_excipient_candidate)
        )
      )
  )
  (:action process_variant_excipient_screen_results
    :parameters (?formulation_variant - formulation_variant ?moisture_exposure_scenario - moisture_exposure_scenario ?analytical_test_method - analytical_test_method ?protective_excipient_candidate - protective_excipient_candidate)
    :precondition
      (and
        (entity_ready_for_integration ?formulation_variant)
        (entity_associated_test_method ?formulation_variant ?analytical_test_method)
        (variant_exposure_applicability ?formulation_variant ?moisture_exposure_scenario)
        (exposure_excipient_intervention_assigned ?moisture_exposure_scenario)
        (variant_has_excipient_candidate ?formulation_variant ?protective_excipient_candidate)
        (not
          (variant_screen_result_recorded ?formulation_variant)
        )
      )
    :effect
      (and
        (exposure_screen_active ?moisture_exposure_scenario)
        (variant_screen_result_recorded ?formulation_variant)
        (protective_excipient_available ?protective_excipient_candidate)
        (not
          (variant_has_excipient_candidate ?formulation_variant ?protective_excipient_candidate)
        )
      )
  )
  (:action initiate_process_exposure_screen
    :parameters (?manufacturing_process_option - manufacturing_process_option ?packaging_component_option - packaging_component_option ?analytical_test_method - analytical_test_method)
    :precondition
      (and
        (entity_ready_for_integration ?manufacturing_process_option)
        (entity_associated_test_method ?manufacturing_process_option ?analytical_test_method)
        (process_packaging_component_link ?manufacturing_process_option ?packaging_component_option)
        (not
          (packaging_component_screen_active ?packaging_component_option)
        )
        (not
          (packaging_component_excipient_intervention_assigned ?packaging_component_option)
        )
      )
    :effect (packaging_component_screen_active ?packaging_component_option)
  )
  (:action perform_process_lab_screen
    :parameters (?manufacturing_process_option - manufacturing_process_option ?packaging_component_option - packaging_component_option ?laboratory_test_site - laboratory_test_site)
    :precondition
      (and
        (entity_ready_for_integration ?manufacturing_process_option)
        (entity_assigned_to_lab ?manufacturing_process_option ?laboratory_test_site)
        (process_packaging_component_link ?manufacturing_process_option ?packaging_component_option)
        (packaging_component_screen_active ?packaging_component_option)
        (not
          (process_screen_started ?manufacturing_process_option)
        )
      )
    :effect
      (and
        (process_screen_started ?manufacturing_process_option)
        (process_screen_result_recorded ?manufacturing_process_option)
      )
  )
  (:action assign_excipient_to_process_component
    :parameters (?manufacturing_process_option - manufacturing_process_option ?packaging_component_option - packaging_component_option ?protective_excipient_candidate - protective_excipient_candidate)
    :precondition
      (and
        (entity_ready_for_integration ?manufacturing_process_option)
        (process_packaging_component_link ?manufacturing_process_option ?packaging_component_option)
        (protective_excipient_available ?protective_excipient_candidate)
        (not
          (process_screen_started ?manufacturing_process_option)
        )
      )
    :effect
      (and
        (packaging_component_excipient_intervention_assigned ?packaging_component_option)
        (process_screen_started ?manufacturing_process_option)
        (process_has_excipient_candidate ?manufacturing_process_option ?protective_excipient_candidate)
        (not
          (protective_excipient_available ?protective_excipient_candidate)
        )
      )
  )
  (:action process_component_excipient_screen_results
    :parameters (?manufacturing_process_option - manufacturing_process_option ?packaging_component_option - packaging_component_option ?analytical_test_method - analytical_test_method ?protective_excipient_candidate - protective_excipient_candidate)
    :precondition
      (and
        (entity_ready_for_integration ?manufacturing_process_option)
        (entity_associated_test_method ?manufacturing_process_option ?analytical_test_method)
        (process_packaging_component_link ?manufacturing_process_option ?packaging_component_option)
        (packaging_component_excipient_intervention_assigned ?packaging_component_option)
        (process_has_excipient_candidate ?manufacturing_process_option ?protective_excipient_candidate)
        (not
          (process_screen_result_recorded ?manufacturing_process_option)
        )
      )
    :effect
      (and
        (packaging_component_screen_active ?packaging_component_option)
        (process_screen_result_recorded ?manufacturing_process_option)
        (protective_excipient_available ?protective_excipient_candidate)
        (not
          (process_has_excipient_candidate ?manufacturing_process_option ?protective_excipient_candidate)
        )
      )
  )
  (:action create_protection_design_proposal
    :parameters (?formulation_variant - formulation_variant ?manufacturing_process_option - manufacturing_process_option ?moisture_exposure_scenario - moisture_exposure_scenario ?packaging_component_option - packaging_component_option ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (variant_screen_started ?formulation_variant)
        (process_screen_started ?manufacturing_process_option)
        (variant_exposure_applicability ?formulation_variant ?moisture_exposure_scenario)
        (process_packaging_component_link ?manufacturing_process_option ?packaging_component_option)
        (exposure_screen_active ?moisture_exposure_scenario)
        (packaging_component_screen_active ?packaging_component_option)
        (variant_screen_result_recorded ?formulation_variant)
        (process_screen_result_recorded ?manufacturing_process_option)
        (proposal_pending_integration ?protection_design_proposal)
      )
    :effect
      (and
        (proposal_committed ?protection_design_proposal)
        (proposal_applies_to_exposure ?protection_design_proposal ?moisture_exposure_scenario)
        (proposal_includes_packaging_component ?protection_design_proposal ?packaging_component_option)
        (not
          (proposal_pending_integration ?protection_design_proposal)
        )
      )
  )
  (:action create_protection_design_proposal_with_barrier_flag
    :parameters (?formulation_variant - formulation_variant ?manufacturing_process_option - manufacturing_process_option ?moisture_exposure_scenario - moisture_exposure_scenario ?packaging_component_option - packaging_component_option ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (variant_screen_started ?formulation_variant)
        (process_screen_started ?manufacturing_process_option)
        (variant_exposure_applicability ?formulation_variant ?moisture_exposure_scenario)
        (process_packaging_component_link ?manufacturing_process_option ?packaging_component_option)
        (exposure_excipient_intervention_assigned ?moisture_exposure_scenario)
        (packaging_component_screen_active ?packaging_component_option)
        (not
          (variant_screen_result_recorded ?formulation_variant)
        )
        (process_screen_result_recorded ?manufacturing_process_option)
        (proposal_pending_integration ?protection_design_proposal)
      )
    :effect
      (and
        (proposal_committed ?protection_design_proposal)
        (proposal_applies_to_exposure ?protection_design_proposal ?moisture_exposure_scenario)
        (proposal_includes_packaging_component ?protection_design_proposal ?packaging_component_option)
        (proposal_has_barrier_material_flag ?protection_design_proposal)
        (not
          (proposal_pending_integration ?protection_design_proposal)
        )
      )
  )
  (:action create_protection_design_proposal_with_coating_flag
    :parameters (?formulation_variant - formulation_variant ?manufacturing_process_option - manufacturing_process_option ?moisture_exposure_scenario - moisture_exposure_scenario ?packaging_component_option - packaging_component_option ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (variant_screen_started ?formulation_variant)
        (process_screen_started ?manufacturing_process_option)
        (variant_exposure_applicability ?formulation_variant ?moisture_exposure_scenario)
        (process_packaging_component_link ?manufacturing_process_option ?packaging_component_option)
        (exposure_screen_active ?moisture_exposure_scenario)
        (packaging_component_excipient_intervention_assigned ?packaging_component_option)
        (variant_screen_result_recorded ?formulation_variant)
        (not
          (process_screen_result_recorded ?manufacturing_process_option)
        )
        (proposal_pending_integration ?protection_design_proposal)
      )
    :effect
      (and
        (proposal_committed ?protection_design_proposal)
        (proposal_applies_to_exposure ?protection_design_proposal ?moisture_exposure_scenario)
        (proposal_includes_packaging_component ?protection_design_proposal ?packaging_component_option)
        (proposal_has_coating_flag ?protection_design_proposal)
        (not
          (proposal_pending_integration ?protection_design_proposal)
        )
      )
  )
  (:action create_protection_design_proposal_with_barrier_and_coating_flags
    :parameters (?formulation_variant - formulation_variant ?manufacturing_process_option - manufacturing_process_option ?moisture_exposure_scenario - moisture_exposure_scenario ?packaging_component_option - packaging_component_option ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (variant_screen_started ?formulation_variant)
        (process_screen_started ?manufacturing_process_option)
        (variant_exposure_applicability ?formulation_variant ?moisture_exposure_scenario)
        (process_packaging_component_link ?manufacturing_process_option ?packaging_component_option)
        (exposure_excipient_intervention_assigned ?moisture_exposure_scenario)
        (packaging_component_excipient_intervention_assigned ?packaging_component_option)
        (not
          (variant_screen_result_recorded ?formulation_variant)
        )
        (not
          (process_screen_result_recorded ?manufacturing_process_option)
        )
        (proposal_pending_integration ?protection_design_proposal)
      )
    :effect
      (and
        (proposal_committed ?protection_design_proposal)
        (proposal_applies_to_exposure ?protection_design_proposal ?moisture_exposure_scenario)
        (proposal_includes_packaging_component ?protection_design_proposal ?packaging_component_option)
        (proposal_has_barrier_material_flag ?protection_design_proposal)
        (proposal_has_coating_flag ?protection_design_proposal)
        (not
          (proposal_pending_integration ?protection_design_proposal)
        )
      )
  )
  (:action record_proposal_challenge_test
    :parameters (?protection_design_proposal - protection_design_proposal ?formulation_variant - formulation_variant ?analytical_test_method - analytical_test_method)
    :precondition
      (and
        (proposal_committed ?protection_design_proposal)
        (variant_screen_started ?formulation_variant)
        (entity_associated_test_method ?formulation_variant ?analytical_test_method)
        (not
          (proposal_challenge_test_completed ?protection_design_proposal)
        )
      )
    :effect (proposal_challenge_test_completed ?protection_design_proposal)
  )
  (:action promote_dataset_and_link_to_proposal
    :parameters (?development_package - development_package ?analytical_dataset - analytical_dataset ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (entity_ready_for_integration ?development_package)
        (package_includes_protection_design_proposal ?development_package ?protection_design_proposal)
        (package_has_dataset ?development_package ?analytical_dataset)
        (analytical_dataset_available ?analytical_dataset)
        (proposal_committed ?protection_design_proposal)
        (proposal_challenge_test_completed ?protection_design_proposal)
        (not
          (analytical_dataset_validated ?analytical_dataset)
        )
      )
    :effect
      (and
        (analytical_dataset_validated ?analytical_dataset)
        (dataset_supports_proposal ?analytical_dataset ?protection_design_proposal)
        (not
          (analytical_dataset_available ?analytical_dataset)
        )
      )
  )
  (:action qualify_package_with_dataset
    :parameters (?development_package - development_package ?analytical_dataset - analytical_dataset ?protection_design_proposal - protection_design_proposal ?analytical_test_method - analytical_test_method)
    :precondition
      (and
        (entity_ready_for_integration ?development_package)
        (package_has_dataset ?development_package ?analytical_dataset)
        (analytical_dataset_validated ?analytical_dataset)
        (dataset_supports_proposal ?analytical_dataset ?protection_design_proposal)
        (entity_associated_test_method ?development_package ?analytical_test_method)
        (not
          (proposal_has_barrier_material_flag ?protection_design_proposal)
        )
        (not
          (package_barrier_evaluation_started ?development_package)
        )
      )
    :effect (package_barrier_evaluation_started ?development_package)
  )
  (:action attach_regulatory_requirement
    :parameters (?development_package - development_package ?regulatory_requirement - regulatory_requirement)
    :precondition
      (and
        (entity_ready_for_integration ?development_package)
        (regulatory_requirement_available ?regulatory_requirement)
        (not
          (regulatory_requirement_attached ?development_package)
        )
      )
    :effect
      (and
        (regulatory_requirement_attached ?development_package)
        (package_linked_regulatory_requirement ?development_package ?regulatory_requirement)
        (not
          (regulatory_requirement_available ?regulatory_requirement)
        )
      )
  )
  (:action integrate_regulatory_requirement_with_package
    :parameters (?development_package - development_package ?analytical_dataset - analytical_dataset ?protection_design_proposal - protection_design_proposal ?analytical_test_method - analytical_test_method ?regulatory_requirement - regulatory_requirement)
    :precondition
      (and
        (entity_ready_for_integration ?development_package)
        (package_has_dataset ?development_package ?analytical_dataset)
        (analytical_dataset_validated ?analytical_dataset)
        (dataset_supports_proposal ?analytical_dataset ?protection_design_proposal)
        (entity_associated_test_method ?development_package ?analytical_test_method)
        (proposal_has_barrier_material_flag ?protection_design_proposal)
        (regulatory_requirement_attached ?development_package)
        (package_linked_regulatory_requirement ?development_package ?regulatory_requirement)
        (not
          (package_barrier_evaluation_started ?development_package)
        )
      )
    :effect
      (and
        (package_barrier_evaluation_started ?development_package)
        (regulatory_requirement_confirmed ?development_package)
      )
  )
  (:action evaluate_barrier_material_with_lab_and_data
    :parameters (?development_package - development_package ?barrier_material_candidate - barrier_material_candidate ?laboratory_test_site - laboratory_test_site ?analytical_dataset - analytical_dataset ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (package_barrier_evaluation_started ?development_package)
        (package_assigned_barrier_material ?development_package ?barrier_material_candidate)
        (entity_assigned_to_lab ?development_package ?laboratory_test_site)
        (package_has_dataset ?development_package ?analytical_dataset)
        (dataset_supports_proposal ?analytical_dataset ?protection_design_proposal)
        (not
          (proposal_has_coating_flag ?protection_design_proposal)
        )
        (not
          (package_barrier_candidate_selected ?development_package)
        )
      )
    :effect (package_barrier_candidate_selected ?development_package)
  )
  (:action confirm_barrier_material_evaluation
    :parameters (?development_package - development_package ?barrier_material_candidate - barrier_material_candidate ?laboratory_test_site - laboratory_test_site ?analytical_dataset - analytical_dataset ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (package_barrier_evaluation_started ?development_package)
        (package_assigned_barrier_material ?development_package ?barrier_material_candidate)
        (entity_assigned_to_lab ?development_package ?laboratory_test_site)
        (package_has_dataset ?development_package ?analytical_dataset)
        (dataset_supports_proposal ?analytical_dataset ?protection_design_proposal)
        (proposal_has_coating_flag ?protection_design_proposal)
        (not
          (package_barrier_candidate_selected ?development_package)
        )
      )
    :effect (package_barrier_candidate_selected ?development_package)
  )
  (:action apply_accelerated_condition_to_package
    :parameters (?development_package - development_package ?accelerated_stability_condition - accelerated_stability_condition ?analytical_dataset - analytical_dataset ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (package_barrier_candidate_selected ?development_package)
        (package_assigned_accelerated_condition ?development_package ?accelerated_stability_condition)
        (package_has_dataset ?development_package ?analytical_dataset)
        (dataset_supports_proposal ?analytical_dataset ?protection_design_proposal)
        (not
          (proposal_has_barrier_material_flag ?protection_design_proposal)
        )
        (not
          (proposal_has_coating_flag ?protection_design_proposal)
        )
        (not
          (accelerated_condition_applied ?development_package)
        )
      )
    :effect (accelerated_condition_applied ?development_package)
  )
  (:action record_accelerated_condition_evidence
    :parameters (?development_package - development_package ?accelerated_stability_condition - accelerated_stability_condition ?analytical_dataset - analytical_dataset ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (package_barrier_candidate_selected ?development_package)
        (package_assigned_accelerated_condition ?development_package ?accelerated_stability_condition)
        (package_has_dataset ?development_package ?analytical_dataset)
        (dataset_supports_proposal ?analytical_dataset ?protection_design_proposal)
        (proposal_has_barrier_material_flag ?protection_design_proposal)
        (not
          (proposal_has_coating_flag ?protection_design_proposal)
        )
        (not
          (accelerated_condition_applied ?development_package)
        )
      )
    :effect
      (and
        (accelerated_condition_applied ?development_package)
        (accelerated_condition_evidence_recorded ?development_package)
      )
  )
  (:action record_accelerated_condition_evidence_alternate
    :parameters (?development_package - development_package ?accelerated_stability_condition - accelerated_stability_condition ?analytical_dataset - analytical_dataset ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (package_barrier_candidate_selected ?development_package)
        (package_assigned_accelerated_condition ?development_package ?accelerated_stability_condition)
        (package_has_dataset ?development_package ?analytical_dataset)
        (dataset_supports_proposal ?analytical_dataset ?protection_design_proposal)
        (not
          (proposal_has_barrier_material_flag ?protection_design_proposal)
        )
        (proposal_has_coating_flag ?protection_design_proposal)
        (not
          (accelerated_condition_applied ?development_package)
        )
      )
    :effect
      (and
        (accelerated_condition_applied ?development_package)
        (accelerated_condition_evidence_recorded ?development_package)
      )
  )
  (:action record_accelerated_condition_evidence_final
    :parameters (?development_package - development_package ?accelerated_stability_condition - accelerated_stability_condition ?analytical_dataset - analytical_dataset ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (package_barrier_candidate_selected ?development_package)
        (package_assigned_accelerated_condition ?development_package ?accelerated_stability_condition)
        (package_has_dataset ?development_package ?analytical_dataset)
        (dataset_supports_proposal ?analytical_dataset ?protection_design_proposal)
        (proposal_has_barrier_material_flag ?protection_design_proposal)
        (proposal_has_coating_flag ?protection_design_proposal)
        (not
          (accelerated_condition_applied ?development_package)
        )
      )
    :effect
      (and
        (accelerated_condition_applied ?development_package)
        (accelerated_condition_evidence_recorded ?development_package)
      )
  )
  (:action approve_development_package
    :parameters (?development_package - development_package)
    :precondition
      (and
        (accelerated_condition_applied ?development_package)
        (not
          (accelerated_condition_evidence_recorded ?development_package)
        )
        (not
          (development_package_finalized ?development_package)
        )
      )
    :effect
      (and
        (development_package_finalized ?development_package)
        (design_approved_entity ?development_package)
      )
  )
  (:action attach_manufacturability_constraint
    :parameters (?development_package - development_package ?manufacturability_constraint - manufacturability_constraint)
    :precondition
      (and
        (accelerated_condition_applied ?development_package)
        (accelerated_condition_evidence_recorded ?development_package)
        (manufacturability_constraint_available ?manufacturability_constraint)
      )
    :effect
      (and
        (package_has_manufacturability_constraint ?development_package ?manufacturability_constraint)
        (not
          (manufacturability_constraint_available ?manufacturability_constraint)
        )
      )
  )
  (:action perform_design_readiness_checks
    :parameters (?development_package - development_package ?formulation_variant - formulation_variant ?manufacturing_process_option - manufacturing_process_option ?analytical_test_method - analytical_test_method ?manufacturability_constraint - manufacturability_constraint)
    :precondition
      (and
        (accelerated_condition_applied ?development_package)
        (accelerated_condition_evidence_recorded ?development_package)
        (package_has_manufacturability_constraint ?development_package ?manufacturability_constraint)
        (package_includes_formulation_variant ?development_package ?formulation_variant)
        (package_includes_process_option ?development_package ?manufacturing_process_option)
        (variant_screen_result_recorded ?formulation_variant)
        (process_screen_result_recorded ?manufacturing_process_option)
        (entity_associated_test_method ?development_package ?analytical_test_method)
        (not
          (design_review_completed ?development_package)
        )
      )
    :effect (design_review_completed ?development_package)
  )
  (:action finalize_development_package_after_review
    :parameters (?development_package - development_package)
    :precondition
      (and
        (accelerated_condition_applied ?development_package)
        (design_review_completed ?development_package)
        (not
          (development_package_finalized ?development_package)
        )
      )
    :effect
      (and
        (development_package_finalized ?development_package)
        (design_approved_entity ?development_package)
      )
  )
  (:action incorporate_stakeholder_input
    :parameters (?development_package - development_package ?external_stakeholder_input - external_stakeholder_input ?analytical_test_method - analytical_test_method)
    :precondition
      (and
        (entity_ready_for_integration ?development_package)
        (entity_associated_test_method ?development_package ?analytical_test_method)
        (stakeholder_input_available ?external_stakeholder_input)
        (package_has_stakeholder_input ?development_package ?external_stakeholder_input)
        (not
          (package_stakeholder_feedback_applied ?development_package)
        )
      )
    :effect
      (and
        (package_stakeholder_feedback_applied ?development_package)
        (not
          (stakeholder_input_available ?external_stakeholder_input)
        )
      )
  )
  (:action apply_review_control
    :parameters (?development_package - development_package ?laboratory_test_site - laboratory_test_site)
    :precondition
      (and
        (package_stakeholder_feedback_applied ?development_package)
        (entity_assigned_to_lab ?development_package ?laboratory_test_site)
        (not
          (package_control_applied ?development_package)
        )
      )
    :effect (package_control_applied ?development_package)
  )
  (:action verify_control_effectiveness
    :parameters (?development_package - development_package ?accelerated_stability_condition - accelerated_stability_condition)
    :precondition
      (and
        (package_control_applied ?development_package)
        (package_assigned_accelerated_condition ?development_package ?accelerated_stability_condition)
        (not
          (package_control_verified ?development_package)
        )
      )
    :effect (package_control_verified ?development_package)
  )
  (:action finalize_controls_and_approve_package
    :parameters (?development_package - development_package)
    :precondition
      (and
        (package_control_verified ?development_package)
        (not
          (development_package_finalized ?development_package)
        )
      )
    :effect
      (and
        (development_package_finalized ?development_package)
        (design_approved_entity ?development_package)
      )
  )
  (:action approve_variant_for_operation
    :parameters (?formulation_variant - formulation_variant ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (variant_screen_started ?formulation_variant)
        (variant_screen_result_recorded ?formulation_variant)
        (proposal_committed ?protection_design_proposal)
        (proposal_challenge_test_completed ?protection_design_proposal)
        (not
          (design_approved_entity ?formulation_variant)
        )
      )
    :effect (design_approved_entity ?formulation_variant)
  )
  (:action approve_process_for_operation
    :parameters (?manufacturing_process_option - manufacturing_process_option ?protection_design_proposal - protection_design_proposal)
    :precondition
      (and
        (process_screen_started ?manufacturing_process_option)
        (process_screen_result_recorded ?manufacturing_process_option)
        (proposal_committed ?protection_design_proposal)
        (proposal_challenge_test_completed ?protection_design_proposal)
        (not
          (design_approved_entity ?manufacturing_process_option)
        )
      )
    :effect (design_approved_entity ?manufacturing_process_option)
  )
  (:action allocate_representative_test_sample
    :parameters (?product_candidate - design_entity ?representative_test_sample - representative_test_sample ?analytical_test_method - analytical_test_method)
    :precondition
      (and
        (design_approved_entity ?product_candidate)
        (entity_associated_test_method ?product_candidate ?analytical_test_method)
        (representative_test_sample_available ?representative_test_sample)
        (not
          (entity_sample_allocated ?product_candidate)
        )
      )
    :effect
      (and
        (entity_sample_allocated ?product_candidate)
        (entity_has_representative_sample ?product_candidate ?representative_test_sample)
        (not
          (representative_test_sample_available ?representative_test_sample)
        )
      )
  )
  (:action finalize_variant_protection_status
    :parameters (?formulation_variant - formulation_variant ?packaging_strategy_option - packaging_strategy_option ?representative_test_sample - representative_test_sample)
    :precondition
      (and
        (entity_sample_allocated ?formulation_variant)
        (entity_has_packaging_strategy ?formulation_variant ?packaging_strategy_option)
        (entity_has_representative_sample ?formulation_variant ?representative_test_sample)
        (not
          (protection_finalized ?formulation_variant)
        )
      )
    :effect
      (and
        (protection_finalized ?formulation_variant)
        (packaging_strategy_available ?packaging_strategy_option)
        (representative_test_sample_available ?representative_test_sample)
      )
  )
  (:action finalize_process_protection_status
    :parameters (?manufacturing_process_option - manufacturing_process_option ?packaging_strategy_option - packaging_strategy_option ?representative_test_sample - representative_test_sample)
    :precondition
      (and
        (entity_sample_allocated ?manufacturing_process_option)
        (entity_has_packaging_strategy ?manufacturing_process_option ?packaging_strategy_option)
        (entity_has_representative_sample ?manufacturing_process_option ?representative_test_sample)
        (not
          (protection_finalized ?manufacturing_process_option)
        )
      )
    :effect
      (and
        (protection_finalized ?manufacturing_process_option)
        (packaging_strategy_available ?packaging_strategy_option)
        (representative_test_sample_available ?representative_test_sample)
      )
  )
  (:action finalize_development_package_protection_status
    :parameters (?development_package - development_package ?packaging_strategy_option - packaging_strategy_option ?representative_test_sample - representative_test_sample)
    :precondition
      (and
        (entity_sample_allocated ?development_package)
        (entity_has_packaging_strategy ?development_package ?packaging_strategy_option)
        (entity_has_representative_sample ?development_package ?representative_test_sample)
        (not
          (protection_finalized ?development_package)
        )
      )
    :effect
      (and
        (protection_finalized ?development_package)
        (packaging_strategy_available ?packaging_strategy_option)
        (representative_test_sample_available ?representative_test_sample)
      )
  )
)

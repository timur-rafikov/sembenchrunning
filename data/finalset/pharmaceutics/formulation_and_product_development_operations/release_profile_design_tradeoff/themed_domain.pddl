(define (domain pharmaceutics_release_profile_design_tradeoff_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_type_group - object material_resource_group - object process_option_group - object entity_root - object development_entity - entity_root analytical_resource - resource_type_group assay_instance - resource_type_group formulation_variant - resource_type_group regulatory_input - resource_type_group supply_constraint - resource_type_group stability_study - resource_type_group equipment_specification - resource_type_group regulatory_interaction - resource_type_group material_or_excipient - material_resource_group analytical_package - material_resource_group external_partner - material_resource_group process_parameter_set - process_option_group manufacturing_parameter_set - process_option_group development_option - process_option_group team_role_group - development_entity program_role_group - development_entity formulation_development_team - team_role_group process_development_team - team_role_group product_program - program_role_group)
  (:predicates
    (entity_registered ?development_entity - development_entity)
    (entity_validated ?development_entity - development_entity)
    (entity_has_assigned_analytical_resource ?development_entity - development_entity)
    (ready_for_scale_up ?development_entity - development_entity)
    (final_signoff ?development_entity - development_entity)
    (stability_scheduled ?development_entity - development_entity)
    (analytical_resource_available ?analytical_resource - analytical_resource)
    (analytical_resource_allocated_to_entity ?development_entity - development_entity ?analytical_resource - analytical_resource)
    (assay_instance_available ?assay_instance - assay_instance)
    (assay_result_for_entity ?development_entity - development_entity ?assay_instance - assay_instance)
    (formulation_variant_available ?formulation_variant - formulation_variant)
    (formulation_assigned_to_entity ?development_entity - development_entity ?formulation_variant - formulation_variant)
    (material_available ?material_or_excipient - material_or_excipient)
    (material_assigned_to_team ?formulation_development_team - formulation_development_team ?material_or_excipient - material_or_excipient)
    (material_assigned_to_process_team ?process_development_team - process_development_team ?material_or_excipient - material_or_excipient)
    (team_has_process_parameter_set ?formulation_development_team - formulation_development_team ?process_parameter_set - process_parameter_set)
    (process_parameter_validated ?process_parameter_set - process_parameter_set)
    (process_parameter_validated_with_material ?process_parameter_set - process_parameter_set)
    (team_experiment_completed ?formulation_development_team - formulation_development_team)
    (process_team_has_manufacturing_parameter_set ?process_development_team - process_development_team ?manufacturing_parameter_set - manufacturing_parameter_set)
    (manufacturing_parameter_validated ?manufacturing_parameter_set - manufacturing_parameter_set)
    (manufacturing_parameter_validated_with_material ?manufacturing_parameter_set - manufacturing_parameter_set)
    (process_team_experiment_completed ?process_development_team - process_development_team)
    (development_option_available ?development_option - development_option)
    (development_option_assembled ?development_option - development_option)
    (development_option_includes_process_parameters ?development_option - development_option ?process_parameter_set - process_parameter_set)
    (development_option_includes_manufacturing_parameters ?development_option - development_option ?manufacturing_parameter_set - manufacturing_parameter_set)
    (development_option_meets_formulation_validation ?development_option - development_option)
    (development_option_meets_process_validation ?development_option - development_option)
    (development_option_lab_verified ?development_option - development_option)
    (program_associated_with_formulation_team ?product_program - product_program ?formulation_development_team - formulation_development_team)
    (program_associated_with_process_team ?product_program - product_program ?process_development_team - process_development_team)
    (program_associated_with_development_option ?product_program - product_program ?development_option - development_option)
    (analytical_package_available ?analytical_package - analytical_package)
    (program_has_analytical_package ?product_program - product_program ?analytical_package - analytical_package)
    (analytical_package_validated ?analytical_package - analytical_package)
    (analytical_package_associated_with_option ?analytical_package - analytical_package ?development_option - development_option)
    (equipment_specification_confirmed_for_program ?product_program - product_program)
    (program_has_validated_equipment ?product_program - product_program)
    (program_equipment_qualification_complete ?product_program - product_program)
    (program_regulatory_input_linked ?product_program - product_program)
    (program_additional_validation_flag ?product_program - product_program)
    (program_ready_for_analytical_package_integration ?product_program - product_program)
    (program_final_review_ready ?product_program - product_program)
    (external_partner_available ?external_partner - external_partner)
    (program_associated_with_external_partner ?product_program - product_program ?external_partner - external_partner)
    (program_partner_engaged ?product_program - product_program)
    (program_partner_integration_started ?product_program - product_program)
    (program_partner_integration_completed ?product_program - product_program)
    (regulatory_input_available ?regulatory_input - regulatory_input)
    (program_has_regulatory_input ?product_program - product_program ?regulatory_input - regulatory_input)
    (supply_constraint_present ?supply_constraint - supply_constraint)
    (program_has_supply_constraint ?product_program - product_program ?supply_constraint - supply_constraint)
    (equipment_specification_available ?equipment_specification - equipment_specification)
    (program_has_equipment_specification ?product_program - product_program ?equipment_specification - equipment_specification)
    (regulatory_interaction_available ?regulatory_interaction - regulatory_interaction)
    (program_has_regulatory_interaction ?product_program - product_program ?regulatory_interaction - regulatory_interaction)
    (stability_study_available ?stability_study - stability_study)
    (stability_study_assigned_to_entity ?development_entity - development_entity ?stability_study - stability_study)
    (formulation_team_ready ?formulation_development_team - formulation_development_team)
    (process_team_ready ?process_development_team - process_development_team)
    (program_signoff_logged ?product_program - product_program)
  )
  (:action register_development_entity
    :parameters (?development_entity - development_entity)
    :precondition
      (and
        (not
          (entity_registered ?development_entity)
        )
        (not
          (ready_for_scale_up ?development_entity)
        )
      )
    :effect (entity_registered ?development_entity)
  )
  (:action allocate_analytical_resource_to_entity
    :parameters (?development_entity - development_entity ?analytical_resource - analytical_resource)
    :precondition
      (and
        (entity_registered ?development_entity)
        (not
          (entity_has_assigned_analytical_resource ?development_entity)
        )
        (analytical_resource_available ?analytical_resource)
      )
    :effect
      (and
        (entity_has_assigned_analytical_resource ?development_entity)
        (analytical_resource_allocated_to_entity ?development_entity ?analytical_resource)
        (not
          (analytical_resource_available ?analytical_resource)
        )
      )
  )
  (:action execute_assay_for_entity
    :parameters (?development_entity - development_entity ?assay_instance - assay_instance)
    :precondition
      (and
        (entity_registered ?development_entity)
        (entity_has_assigned_analytical_resource ?development_entity)
        (assay_instance_available ?assay_instance)
      )
    :effect
      (and
        (assay_result_for_entity ?development_entity ?assay_instance)
        (not
          (assay_instance_available ?assay_instance)
        )
      )
  )
  (:action confirm_assay_result_for_entity
    :parameters (?development_entity - development_entity ?assay_instance - assay_instance)
    :precondition
      (and
        (entity_registered ?development_entity)
        (entity_has_assigned_analytical_resource ?development_entity)
        (assay_result_for_entity ?development_entity ?assay_instance)
        (not
          (entity_validated ?development_entity)
        )
      )
    :effect (entity_validated ?development_entity)
  )
  (:action release_assay_instance
    :parameters (?development_entity - development_entity ?assay_instance - assay_instance)
    :precondition
      (and
        (assay_result_for_entity ?development_entity ?assay_instance)
      )
    :effect
      (and
        (assay_instance_available ?assay_instance)
        (not
          (assay_result_for_entity ?development_entity ?assay_instance)
        )
      )
  )
  (:action assign_formulation_variant_to_entity
    :parameters (?development_entity - development_entity ?formulation_variant - formulation_variant)
    :precondition
      (and
        (entity_validated ?development_entity)
        (formulation_variant_available ?formulation_variant)
      )
    :effect
      (and
        (formulation_assigned_to_entity ?development_entity ?formulation_variant)
        (not
          (formulation_variant_available ?formulation_variant)
        )
      )
  )
  (:action release_formulation_variant_from_entity
    :parameters (?development_entity - development_entity ?formulation_variant - formulation_variant)
    :precondition
      (and
        (formulation_assigned_to_entity ?development_entity ?formulation_variant)
      )
    :effect
      (and
        (formulation_variant_available ?formulation_variant)
        (not
          (formulation_assigned_to_entity ?development_entity ?formulation_variant)
        )
      )
  )
  (:action assign_equipment_spec_to_program
    :parameters (?product_program - product_program ?equipment_specification - equipment_specification)
    :precondition
      (and
        (entity_validated ?product_program)
        (equipment_specification_available ?equipment_specification)
      )
    :effect
      (and
        (program_has_equipment_specification ?product_program ?equipment_specification)
        (not
          (equipment_specification_available ?equipment_specification)
        )
      )
  )
  (:action release_equipment_specification_from_program
    :parameters (?product_program - product_program ?equipment_specification - equipment_specification)
    :precondition
      (and
        (program_has_equipment_specification ?product_program ?equipment_specification)
      )
    :effect
      (and
        (equipment_specification_available ?equipment_specification)
        (not
          (program_has_equipment_specification ?product_program ?equipment_specification)
        )
      )
  )
  (:action assign_regulatory_interaction_to_program
    :parameters (?product_program - product_program ?regulatory_interaction - regulatory_interaction)
    :precondition
      (and
        (entity_validated ?product_program)
        (regulatory_interaction_available ?regulatory_interaction)
      )
    :effect
      (and
        (program_has_regulatory_interaction ?product_program ?regulatory_interaction)
        (not
          (regulatory_interaction_available ?regulatory_interaction)
        )
      )
  )
  (:action release_regulatory_interaction_from_program
    :parameters (?product_program - product_program ?regulatory_interaction - regulatory_interaction)
    :precondition
      (and
        (program_has_regulatory_interaction ?product_program ?regulatory_interaction)
      )
    :effect
      (and
        (regulatory_interaction_available ?regulatory_interaction)
        (not
          (program_has_regulatory_interaction ?product_program ?regulatory_interaction)
        )
      )
  )
  (:action formulation_team_validate_process_parameters
    :parameters (?formulation_development_team - formulation_development_team ?process_parameter_set - process_parameter_set ?assay_instance - assay_instance)
    :precondition
      (and
        (entity_validated ?formulation_development_team)
        (assay_result_for_entity ?formulation_development_team ?assay_instance)
        (team_has_process_parameter_set ?formulation_development_team ?process_parameter_set)
        (not
          (process_parameter_validated ?process_parameter_set)
        )
        (not
          (process_parameter_validated_with_material ?process_parameter_set)
        )
      )
    :effect (process_parameter_validated ?process_parameter_set)
  )
  (:action formulation_team_record_experiment_result
    :parameters (?formulation_development_team - formulation_development_team ?process_parameter_set - process_parameter_set ?formulation_variant - formulation_variant)
    :precondition
      (and
        (entity_validated ?formulation_development_team)
        (formulation_assigned_to_entity ?formulation_development_team ?formulation_variant)
        (team_has_process_parameter_set ?formulation_development_team ?process_parameter_set)
        (process_parameter_validated ?process_parameter_set)
        (not
          (formulation_team_ready ?formulation_development_team)
        )
      )
    :effect
      (and
        (formulation_team_ready ?formulation_development_team)
        (team_experiment_completed ?formulation_development_team)
      )
  )
  (:action formulation_team_test_material_with_parameters
    :parameters (?formulation_development_team - formulation_development_team ?process_parameter_set - process_parameter_set ?material_or_excipient - material_or_excipient)
    :precondition
      (and
        (entity_validated ?formulation_development_team)
        (team_has_process_parameter_set ?formulation_development_team ?process_parameter_set)
        (material_available ?material_or_excipient)
        (not
          (formulation_team_ready ?formulation_development_team)
        )
      )
    :effect
      (and
        (process_parameter_validated_with_material ?process_parameter_set)
        (formulation_team_ready ?formulation_development_team)
        (material_assigned_to_team ?formulation_development_team ?material_or_excipient)
        (not
          (material_available ?material_or_excipient)
        )
      )
  )
  (:action formulation_team_complete_iteration
    :parameters (?formulation_development_team - formulation_development_team ?process_parameter_set - process_parameter_set ?assay_instance - assay_instance ?material_or_excipient - material_or_excipient)
    :precondition
      (and
        (entity_validated ?formulation_development_team)
        (assay_result_for_entity ?formulation_development_team ?assay_instance)
        (team_has_process_parameter_set ?formulation_development_team ?process_parameter_set)
        (process_parameter_validated_with_material ?process_parameter_set)
        (material_assigned_to_team ?formulation_development_team ?material_or_excipient)
        (not
          (team_experiment_completed ?formulation_development_team)
        )
      )
    :effect
      (and
        (process_parameter_validated ?process_parameter_set)
        (team_experiment_completed ?formulation_development_team)
        (material_available ?material_or_excipient)
        (not
          (material_assigned_to_team ?formulation_development_team ?material_or_excipient)
        )
      )
  )
  (:action process_team_validate_manufacturing_parameters
    :parameters (?process_development_team - process_development_team ?manufacturing_parameter_set - manufacturing_parameter_set ?assay_instance - assay_instance)
    :precondition
      (and
        (entity_validated ?process_development_team)
        (assay_result_for_entity ?process_development_team ?assay_instance)
        (process_team_has_manufacturing_parameter_set ?process_development_team ?manufacturing_parameter_set)
        (not
          (manufacturing_parameter_validated ?manufacturing_parameter_set)
        )
        (not
          (manufacturing_parameter_validated_with_material ?manufacturing_parameter_set)
        )
      )
    :effect (manufacturing_parameter_validated ?manufacturing_parameter_set)
  )
  (:action process_team_record_experiment_result
    :parameters (?process_development_team - process_development_team ?manufacturing_parameter_set - manufacturing_parameter_set ?formulation_variant - formulation_variant)
    :precondition
      (and
        (entity_validated ?process_development_team)
        (formulation_assigned_to_entity ?process_development_team ?formulation_variant)
        (process_team_has_manufacturing_parameter_set ?process_development_team ?manufacturing_parameter_set)
        (manufacturing_parameter_validated ?manufacturing_parameter_set)
        (not
          (process_team_ready ?process_development_team)
        )
      )
    :effect
      (and
        (process_team_ready ?process_development_team)
        (process_team_experiment_completed ?process_development_team)
      )
  )
  (:action process_team_test_material_with_parameters
    :parameters (?process_development_team - process_development_team ?manufacturing_parameter_set - manufacturing_parameter_set ?material_or_excipient - material_or_excipient)
    :precondition
      (and
        (entity_validated ?process_development_team)
        (process_team_has_manufacturing_parameter_set ?process_development_team ?manufacturing_parameter_set)
        (material_available ?material_or_excipient)
        (not
          (process_team_ready ?process_development_team)
        )
      )
    :effect
      (and
        (manufacturing_parameter_validated_with_material ?manufacturing_parameter_set)
        (process_team_ready ?process_development_team)
        (material_assigned_to_process_team ?process_development_team ?material_or_excipient)
        (not
          (material_available ?material_or_excipient)
        )
      )
  )
  (:action process_team_complete_iteration
    :parameters (?process_development_team - process_development_team ?manufacturing_parameter_set - manufacturing_parameter_set ?assay_instance - assay_instance ?material_or_excipient - material_or_excipient)
    :precondition
      (and
        (entity_validated ?process_development_team)
        (assay_result_for_entity ?process_development_team ?assay_instance)
        (process_team_has_manufacturing_parameter_set ?process_development_team ?manufacturing_parameter_set)
        (manufacturing_parameter_validated_with_material ?manufacturing_parameter_set)
        (material_assigned_to_process_team ?process_development_team ?material_or_excipient)
        (not
          (process_team_experiment_completed ?process_development_team)
        )
      )
    :effect
      (and
        (manufacturing_parameter_validated ?manufacturing_parameter_set)
        (process_team_experiment_completed ?process_development_team)
        (material_available ?material_or_excipient)
        (not
          (material_assigned_to_process_team ?process_development_team ?material_or_excipient)
        )
      )
  )
  (:action assemble_development_option
    :parameters (?formulation_development_team - formulation_development_team ?process_development_team - process_development_team ?process_parameter_set - process_parameter_set ?manufacturing_parameter_set - manufacturing_parameter_set ?development_option - development_option)
    :precondition
      (and
        (formulation_team_ready ?formulation_development_team)
        (process_team_ready ?process_development_team)
        (team_has_process_parameter_set ?formulation_development_team ?process_parameter_set)
        (process_team_has_manufacturing_parameter_set ?process_development_team ?manufacturing_parameter_set)
        (process_parameter_validated ?process_parameter_set)
        (manufacturing_parameter_validated ?manufacturing_parameter_set)
        (team_experiment_completed ?formulation_development_team)
        (process_team_experiment_completed ?process_development_team)
        (development_option_available ?development_option)
      )
    :effect
      (and
        (development_option_assembled ?development_option)
        (development_option_includes_process_parameters ?development_option ?process_parameter_set)
        (development_option_includes_manufacturing_parameters ?development_option ?manufacturing_parameter_set)
        (not
          (development_option_available ?development_option)
        )
      )
  )
  (:action assemble_development_option_with_formulation_validation
    :parameters (?formulation_development_team - formulation_development_team ?process_development_team - process_development_team ?process_parameter_set - process_parameter_set ?manufacturing_parameter_set - manufacturing_parameter_set ?development_option - development_option)
    :precondition
      (and
        (formulation_team_ready ?formulation_development_team)
        (process_team_ready ?process_development_team)
        (team_has_process_parameter_set ?formulation_development_team ?process_parameter_set)
        (process_team_has_manufacturing_parameter_set ?process_development_team ?manufacturing_parameter_set)
        (process_parameter_validated_with_material ?process_parameter_set)
        (manufacturing_parameter_validated ?manufacturing_parameter_set)
        (not
          (team_experiment_completed ?formulation_development_team)
        )
        (process_team_experiment_completed ?process_development_team)
        (development_option_available ?development_option)
      )
    :effect
      (and
        (development_option_assembled ?development_option)
        (development_option_includes_process_parameters ?development_option ?process_parameter_set)
        (development_option_includes_manufacturing_parameters ?development_option ?manufacturing_parameter_set)
        (development_option_meets_formulation_validation ?development_option)
        (not
          (development_option_available ?development_option)
        )
      )
  )
  (:action assemble_development_option_with_process_validation
    :parameters (?formulation_development_team - formulation_development_team ?process_development_team - process_development_team ?process_parameter_set - process_parameter_set ?manufacturing_parameter_set - manufacturing_parameter_set ?development_option - development_option)
    :precondition
      (and
        (formulation_team_ready ?formulation_development_team)
        (process_team_ready ?process_development_team)
        (team_has_process_parameter_set ?formulation_development_team ?process_parameter_set)
        (process_team_has_manufacturing_parameter_set ?process_development_team ?manufacturing_parameter_set)
        (process_parameter_validated ?process_parameter_set)
        (manufacturing_parameter_validated_with_material ?manufacturing_parameter_set)
        (team_experiment_completed ?formulation_development_team)
        (not
          (process_team_experiment_completed ?process_development_team)
        )
        (development_option_available ?development_option)
      )
    :effect
      (and
        (development_option_assembled ?development_option)
        (development_option_includes_process_parameters ?development_option ?process_parameter_set)
        (development_option_includes_manufacturing_parameters ?development_option ?manufacturing_parameter_set)
        (development_option_meets_process_validation ?development_option)
        (not
          (development_option_available ?development_option)
        )
      )
  )
  (:action assemble_development_option_with_full_validations
    :parameters (?formulation_development_team - formulation_development_team ?process_development_team - process_development_team ?process_parameter_set - process_parameter_set ?manufacturing_parameter_set - manufacturing_parameter_set ?development_option - development_option)
    :precondition
      (and
        (formulation_team_ready ?formulation_development_team)
        (process_team_ready ?process_development_team)
        (team_has_process_parameter_set ?formulation_development_team ?process_parameter_set)
        (process_team_has_manufacturing_parameter_set ?process_development_team ?manufacturing_parameter_set)
        (process_parameter_validated_with_material ?process_parameter_set)
        (manufacturing_parameter_validated_with_material ?manufacturing_parameter_set)
        (not
          (team_experiment_completed ?formulation_development_team)
        )
        (not
          (process_team_experiment_completed ?process_development_team)
        )
        (development_option_available ?development_option)
      )
    :effect
      (and
        (development_option_assembled ?development_option)
        (development_option_includes_process_parameters ?development_option ?process_parameter_set)
        (development_option_includes_manufacturing_parameters ?development_option ?manufacturing_parameter_set)
        (development_option_meets_formulation_validation ?development_option)
        (development_option_meets_process_validation ?development_option)
        (not
          (development_option_available ?development_option)
        )
      )
  )
  (:action lab_validate_development_option
    :parameters (?development_option - development_option ?formulation_development_team - formulation_development_team ?assay_instance - assay_instance)
    :precondition
      (and
        (development_option_assembled ?development_option)
        (formulation_team_ready ?formulation_development_team)
        (assay_result_for_entity ?formulation_development_team ?assay_instance)
        (not
          (development_option_lab_verified ?development_option)
        )
      )
    :effect (development_option_lab_verified ?development_option)
  )
  (:action validate_analytical_package_for_program
    :parameters (?product_program - product_program ?analytical_package - analytical_package ?development_option - development_option)
    :precondition
      (and
        (entity_validated ?product_program)
        (program_associated_with_development_option ?product_program ?development_option)
        (program_has_analytical_package ?product_program ?analytical_package)
        (analytical_package_available ?analytical_package)
        (development_option_assembled ?development_option)
        (development_option_lab_verified ?development_option)
        (not
          (analytical_package_validated ?analytical_package)
        )
      )
    :effect
      (and
        (analytical_package_validated ?analytical_package)
        (analytical_package_associated_with_option ?analytical_package ?development_option)
        (not
          (analytical_package_available ?analytical_package)
        )
      )
  )
  (:action approve_analytical_package
    :parameters (?product_program - product_program ?analytical_package - analytical_package ?development_option - development_option ?assay_instance - assay_instance)
    :precondition
      (and
        (entity_validated ?product_program)
        (program_has_analytical_package ?product_program ?analytical_package)
        (analytical_package_validated ?analytical_package)
        (analytical_package_associated_with_option ?analytical_package ?development_option)
        (assay_result_for_entity ?product_program ?assay_instance)
        (not
          (development_option_meets_formulation_validation ?development_option)
        )
        (not
          (equipment_specification_confirmed_for_program ?product_program)
        )
      )
    :effect (equipment_specification_confirmed_for_program ?product_program)
  )
  (:action assign_regulatory_input_to_program
    :parameters (?product_program - product_program ?regulatory_input - regulatory_input)
    :precondition
      (and
        (entity_validated ?product_program)
        (regulatory_input_available ?regulatory_input)
        (not
          (program_regulatory_input_linked ?product_program)
        )
      )
    :effect
      (and
        (program_regulatory_input_linked ?product_program)
        (program_has_regulatory_input ?product_program ?regulatory_input)
        (not
          (regulatory_input_available ?regulatory_input)
        )
      )
  )
  (:action integrate_analytical_package_with_program
    :parameters (?product_program - product_program ?analytical_package - analytical_package ?development_option - development_option ?assay_instance - assay_instance ?regulatory_input - regulatory_input)
    :precondition
      (and
        (entity_validated ?product_program)
        (program_has_analytical_package ?product_program ?analytical_package)
        (analytical_package_validated ?analytical_package)
        (analytical_package_associated_with_option ?analytical_package ?development_option)
        (assay_result_for_entity ?product_program ?assay_instance)
        (development_option_meets_formulation_validation ?development_option)
        (program_regulatory_input_linked ?product_program)
        (program_has_regulatory_input ?product_program ?regulatory_input)
        (not
          (equipment_specification_confirmed_for_program ?product_program)
        )
      )
    :effect
      (and
        (equipment_specification_confirmed_for_program ?product_program)
        (program_additional_validation_flag ?product_program)
      )
  )
  (:action run_equipment_validation
    :parameters (?product_program - product_program ?equipment_specification - equipment_specification ?formulation_variant - formulation_variant ?analytical_package - analytical_package ?development_option - development_option)
    :precondition
      (and
        (equipment_specification_confirmed_for_program ?product_program)
        (program_has_equipment_specification ?product_program ?equipment_specification)
        (formulation_assigned_to_entity ?product_program ?formulation_variant)
        (program_has_analytical_package ?product_program ?analytical_package)
        (analytical_package_associated_with_option ?analytical_package ?development_option)
        (not
          (development_option_meets_process_validation ?development_option)
        )
        (not
          (program_has_validated_equipment ?product_program)
        )
      )
    :effect (program_has_validated_equipment ?product_program)
  )
  (:action perform_equipment_validation
    :parameters (?product_program - product_program ?equipment_specification - equipment_specification ?formulation_variant - formulation_variant ?analytical_package - analytical_package ?development_option - development_option)
    :precondition
      (and
        (equipment_specification_confirmed_for_program ?product_program)
        (program_has_equipment_specification ?product_program ?equipment_specification)
        (formulation_assigned_to_entity ?product_program ?formulation_variant)
        (program_has_analytical_package ?product_program ?analytical_package)
        (analytical_package_associated_with_option ?analytical_package ?development_option)
        (development_option_meets_process_validation ?development_option)
        (not
          (program_has_validated_equipment ?product_program)
        )
      )
    :effect (program_has_validated_equipment ?product_program)
  )
  (:action finalize_regulatory_interaction_for_program
    :parameters (?product_program - product_program ?regulatory_interaction - regulatory_interaction ?analytical_package - analytical_package ?development_option - development_option)
    :precondition
      (and
        (program_has_validated_equipment ?product_program)
        (program_has_regulatory_interaction ?product_program ?regulatory_interaction)
        (program_has_analytical_package ?product_program ?analytical_package)
        (analytical_package_associated_with_option ?analytical_package ?development_option)
        (not
          (development_option_meets_formulation_validation ?development_option)
        )
        (not
          (development_option_meets_process_validation ?development_option)
        )
        (not
          (program_equipment_qualification_complete ?product_program)
        )
      )
    :effect (program_equipment_qualification_complete ?product_program)
  )
  (:action apply_regulatory_interaction_and_prepare_analytical_integration
    :parameters (?product_program - product_program ?regulatory_interaction - regulatory_interaction ?analytical_package - analytical_package ?development_option - development_option)
    :precondition
      (and
        (program_has_validated_equipment ?product_program)
        (program_has_regulatory_interaction ?product_program ?regulatory_interaction)
        (program_has_analytical_package ?product_program ?analytical_package)
        (analytical_package_associated_with_option ?analytical_package ?development_option)
        (development_option_meets_formulation_validation ?development_option)
        (not
          (development_option_meets_process_validation ?development_option)
        )
        (not
          (program_equipment_qualification_complete ?product_program)
        )
      )
    :effect
      (and
        (program_equipment_qualification_complete ?product_program)
        (program_ready_for_analytical_package_integration ?product_program)
      )
  )
  (:action apply_regulatory_interaction_and_prepare_analytical_integration_variant_b
    :parameters (?product_program - product_program ?regulatory_interaction - regulatory_interaction ?analytical_package - analytical_package ?development_option - development_option)
    :precondition
      (and
        (program_has_validated_equipment ?product_program)
        (program_has_regulatory_interaction ?product_program ?regulatory_interaction)
        (program_has_analytical_package ?product_program ?analytical_package)
        (analytical_package_associated_with_option ?analytical_package ?development_option)
        (not
          (development_option_meets_formulation_validation ?development_option)
        )
        (development_option_meets_process_validation ?development_option)
        (not
          (program_equipment_qualification_complete ?product_program)
        )
      )
    :effect
      (and
        (program_equipment_qualification_complete ?product_program)
        (program_ready_for_analytical_package_integration ?product_program)
      )
  )
  (:action apply_regulatory_interaction_and_prepare_analytical_integration_variant_c
    :parameters (?product_program - product_program ?regulatory_interaction - regulatory_interaction ?analytical_package - analytical_package ?development_option - development_option)
    :precondition
      (and
        (program_has_validated_equipment ?product_program)
        (program_has_regulatory_interaction ?product_program ?regulatory_interaction)
        (program_has_analytical_package ?product_program ?analytical_package)
        (analytical_package_associated_with_option ?analytical_package ?development_option)
        (development_option_meets_formulation_validation ?development_option)
        (development_option_meets_process_validation ?development_option)
        (not
          (program_equipment_qualification_complete ?product_program)
        )
      )
    :effect
      (and
        (program_equipment_qualification_complete ?product_program)
        (program_ready_for_analytical_package_integration ?product_program)
      )
  )
  (:action record_program_signoff
    :parameters (?product_program - product_program)
    :precondition
      (and
        (program_equipment_qualification_complete ?product_program)
        (not
          (program_ready_for_analytical_package_integration ?product_program)
        )
        (not
          (program_signoff_logged ?product_program)
        )
      )
    :effect
      (and
        (program_signoff_logged ?product_program)
        (final_signoff ?product_program)
      )
  )
  (:action assign_supply_constraint_to_program
    :parameters (?product_program - product_program ?supply_constraint - supply_constraint)
    :precondition
      (and
        (program_equipment_qualification_complete ?product_program)
        (program_ready_for_analytical_package_integration ?product_program)
        (supply_constraint_present ?supply_constraint)
      )
    :effect
      (and
        (program_has_supply_constraint ?product_program ?supply_constraint)
        (not
          (supply_constraint_present ?supply_constraint)
        )
      )
  )
  (:action conduct_program_level_experiments
    :parameters (?product_program - product_program ?formulation_development_team - formulation_development_team ?process_development_team - process_development_team ?assay_instance - assay_instance ?supply_constraint - supply_constraint)
    :precondition
      (and
        (program_equipment_qualification_complete ?product_program)
        (program_ready_for_analytical_package_integration ?product_program)
        (program_has_supply_constraint ?product_program ?supply_constraint)
        (program_associated_with_formulation_team ?product_program ?formulation_development_team)
        (program_associated_with_process_team ?product_program ?process_development_team)
        (team_experiment_completed ?formulation_development_team)
        (process_team_experiment_completed ?process_development_team)
        (assay_result_for_entity ?product_program ?assay_instance)
        (not
          (program_final_review_ready ?product_program)
        )
      )
    :effect (program_final_review_ready ?product_program)
  )
  (:action record_program_final_review_and_signoff
    :parameters (?product_program - product_program)
    :precondition
      (and
        (program_equipment_qualification_complete ?product_program)
        (program_final_review_ready ?product_program)
        (not
          (program_signoff_logged ?product_program)
        )
      )
    :effect
      (and
        (program_signoff_logged ?product_program)
        (final_signoff ?product_program)
      )
  )
  (:action engage_external_partner
    :parameters (?product_program - product_program ?external_partner - external_partner ?assay_instance - assay_instance)
    :precondition
      (and
        (entity_validated ?product_program)
        (assay_result_for_entity ?product_program ?assay_instance)
        (external_partner_available ?external_partner)
        (program_associated_with_external_partner ?product_program ?external_partner)
        (not
          (program_partner_engaged ?product_program)
        )
      )
    :effect
      (and
        (program_partner_engaged ?product_program)
        (not
          (external_partner_available ?external_partner)
        )
      )
  )
  (:action start_partner_integration
    :parameters (?product_program - product_program ?formulation_variant - formulation_variant)
    :precondition
      (and
        (program_partner_engaged ?product_program)
        (formulation_assigned_to_entity ?product_program ?formulation_variant)
        (not
          (program_partner_integration_started ?product_program)
        )
      )
    :effect (program_partner_integration_started ?product_program)
  )
  (:action apply_regulatory_interaction_for_partner_integration
    :parameters (?product_program - product_program ?regulatory_interaction - regulatory_interaction)
    :precondition
      (and
        (program_partner_integration_started ?product_program)
        (program_has_regulatory_interaction ?product_program ?regulatory_interaction)
        (not
          (program_partner_integration_completed ?product_program)
        )
      )
    :effect (program_partner_integration_completed ?product_program)
  )
  (:action finalize_partner_integration_and_signoff
    :parameters (?product_program - product_program)
    :precondition
      (and
        (program_partner_integration_completed ?product_program)
        (not
          (program_signoff_logged ?product_program)
        )
      )
    :effect
      (and
        (program_signoff_logged ?product_program)
        (final_signoff ?product_program)
      )
  )
  (:action signoff_formulation_team_readiness
    :parameters (?formulation_development_team - formulation_development_team ?development_option - development_option)
    :precondition
      (and
        (formulation_team_ready ?formulation_development_team)
        (team_experiment_completed ?formulation_development_team)
        (development_option_assembled ?development_option)
        (development_option_lab_verified ?development_option)
        (not
          (final_signoff ?formulation_development_team)
        )
      )
    :effect (final_signoff ?formulation_development_team)
  )
  (:action signoff_process_team_readiness
    :parameters (?process_development_team - process_development_team ?development_option - development_option)
    :precondition
      (and
        (process_team_ready ?process_development_team)
        (process_team_experiment_completed ?process_development_team)
        (development_option_assembled ?development_option)
        (development_option_lab_verified ?development_option)
        (not
          (final_signoff ?process_development_team)
        )
      )
    :effect (final_signoff ?process_development_team)
  )
  (:action schedule_stability_study_for_entity
    :parameters (?development_entity - development_entity ?stability_study - stability_study ?assay_instance - assay_instance)
    :precondition
      (and
        (final_signoff ?development_entity)
        (assay_result_for_entity ?development_entity ?assay_instance)
        (stability_study_available ?stability_study)
        (not
          (stability_scheduled ?development_entity)
        )
      )
    :effect
      (and
        (stability_scheduled ?development_entity)
        (stability_study_assigned_to_entity ?development_entity ?stability_study)
        (not
          (stability_study_available ?stability_study)
        )
      )
  )
  (:action finalize_team_scaleup_readiness
    :parameters (?formulation_development_team - formulation_development_team ?analytical_resource - analytical_resource ?stability_study - stability_study)
    :precondition
      (and
        (stability_scheduled ?formulation_development_team)
        (analytical_resource_allocated_to_entity ?formulation_development_team ?analytical_resource)
        (stability_study_assigned_to_entity ?formulation_development_team ?stability_study)
        (not
          (ready_for_scale_up ?formulation_development_team)
        )
      )
    :effect
      (and
        (ready_for_scale_up ?formulation_development_team)
        (analytical_resource_available ?analytical_resource)
        (stability_study_available ?stability_study)
      )
  )
  (:action finalize_process_team_scaleup_readiness
    :parameters (?process_development_team - process_development_team ?analytical_resource - analytical_resource ?stability_study - stability_study)
    :precondition
      (and
        (stability_scheduled ?process_development_team)
        (analytical_resource_allocated_to_entity ?process_development_team ?analytical_resource)
        (stability_study_assigned_to_entity ?process_development_team ?stability_study)
        (not
          (ready_for_scale_up ?process_development_team)
        )
      )
    :effect
      (and
        (ready_for_scale_up ?process_development_team)
        (analytical_resource_available ?analytical_resource)
        (stability_study_available ?stability_study)
      )
  )
  (:action finalize_program_scaleup_readiness
    :parameters (?product_program - product_program ?analytical_resource - analytical_resource ?stability_study - stability_study)
    :precondition
      (and
        (stability_scheduled ?product_program)
        (analytical_resource_allocated_to_entity ?product_program ?analytical_resource)
        (stability_study_assigned_to_entity ?product_program ?stability_study)
        (not
          (ready_for_scale_up ?product_program)
        )
      )
    :effect
      (and
        (ready_for_scale_up ?product_program)
        (analytical_resource_available ?analytical_resource)
        (stability_study_available ?stability_study)
      )
  )
)

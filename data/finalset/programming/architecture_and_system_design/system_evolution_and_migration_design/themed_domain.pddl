(define (domain system_evolution_and_migration_design)
  (:requirements :strips :typing :negative-preconditions)
  (:types migration_artifact_group - object migration_support_artifact_group - object interface_endpoint_category - object application_asset_category - object application_component - application_asset_category deployment_environment - migration_artifact_group interface_specification - migration_artifact_group interface_adapter - migration_artifact_group compliance_document - migration_artifact_group test_suite - migration_artifact_group rollback_plan - migration_artifact_group performance_profile - migration_artifact_group approval_token - migration_artifact_group migration_tool - migration_support_artifact_group data_schema - migration_support_artifact_group stakeholder - migration_support_artifact_group source_interface - interface_endpoint_category target_interface - interface_endpoint_category migration_bundle - interface_endpoint_category component_instance_category - application_component migration_plan_category - application_component source_component_instance - component_instance_category target_component_instance - component_instance_category migration_project - migration_plan_category)
  (:predicates
    (entity_discovered ?component_entity - application_component)
    (entity_interface_verified ?component_entity - application_component)
    (entity_registered ?component_entity - application_component)
    (entity_migrated ?component_entity - application_component)
    (migration_ready ?component_entity - application_component)
    (cutover_in_progress ?component_entity - application_component)
    (deployment_environment_available ?environment_entity - deployment_environment)
    (entity_assigned_to_environment ?component_entity - application_component ?environment_entity - deployment_environment)
    (interface_specification_available ?interface_spec_entity - interface_specification)
    (interface_specification_attached ?component_entity - application_component ?interface_spec_entity - interface_specification)
    (interface_adapter_available ?adapter_entity - interface_adapter)
    (interface_adapter_attached ?component_entity - application_component ?adapter_entity - interface_adapter)
    (migration_tool_available ?tool_entity - migration_tool)
    (source_tool_reserved ?source_component_entity - source_component_instance ?tool_entity - migration_tool)
    (target_tool_reserved ?target_component_entity - target_component_instance ?tool_entity - migration_tool)
    (source_component_links_source_interface ?source_component_entity - source_component_instance ?source_interface_entity - source_interface)
    (source_interface_ready ?source_interface_entity - source_interface)
    (source_interface_committed ?source_interface_entity - source_interface)
    (source_component_ready ?source_component_entity - source_component_instance)
    (target_component_links_target_interface ?target_component_entity - target_component_instance ?target_interface_entity - target_interface)
    (target_interface_ready ?target_interface_entity - target_interface)
    (target_interface_committed ?target_interface_entity - target_interface)
    (target_component_ready ?target_component_entity - target_component_instance)
    (migration_bundle_available ?bundle_entity - migration_bundle)
    (migration_bundle_assembled ?bundle_entity - migration_bundle)
    (bundle_links_source_interface ?bundle_entity - migration_bundle ?source_interface_entity - source_interface)
    (bundle_links_target_interface ?bundle_entity - migration_bundle ?target_interface_entity - target_interface)
    (source_validation_branch ?bundle_entity - migration_bundle)
    (target_validation_branch ?bundle_entity - migration_bundle)
    (migration_bundle_finalized ?bundle_entity - migration_bundle)
    (project_has_source_component ?project_entity - migration_project ?source_component_entity - source_component_instance)
    (project_has_target_component ?project_entity - migration_project ?target_component_entity - target_component_instance)
    (project_has_bundle ?project_entity - migration_project ?bundle_entity - migration_bundle)
    (data_schema_available ?schema_entity - data_schema)
    (project_has_schema ?project_entity - migration_project ?schema_entity - data_schema)
    (schema_locked ?schema_entity - data_schema)
    (schema_embedded_in_bundle ?schema_entity - data_schema ?bundle_entity - migration_bundle)
    (schema_validated ?project_entity - migration_project)
    (project_under_review ?project_entity - migration_project)
    (project_approved ?project_entity - migration_project)
    (compliance_document_attached ?project_entity - migration_project)
    (compliance_gate_passed ?project_entity - migration_project)
    (validation_ready ?project_entity - migration_project)
    (coordination_complete ?project_entity - migration_project)
    (stakeholder_available ?stakeholder_entity - stakeholder)
    (project_has_stakeholder ?project_entity - migration_project ?stakeholder_entity - stakeholder)
    (stakeholder_review_started ?project_entity - migration_project)
    (adapter_review_complete ?project_entity - migration_project)
    (approval_recorded ?project_entity - migration_project)
    (compliance_document_available ?compliance_document_entity - compliance_document)
    (project_has_compliance_document ?project_entity - migration_project ?compliance_document_entity - compliance_document)
    (test_suite_available ?test_suite_entity - test_suite)
    (project_has_test_suite ?project_entity - migration_project ?test_suite_entity - test_suite)
    (performance_profile_available ?performance_profile_entity - performance_profile)
    (project_has_performance_profile ?project_entity - migration_project ?performance_profile_entity - performance_profile)
    (approval_token_available ?approval_token_entity - approval_token)
    (project_has_approval_token ?project_entity - migration_project ?approval_token_entity - approval_token)
    (rollback_plan_available ?rollback_plan_entity - rollback_plan)
    (entity_has_rollback_plan ?component_entity - application_component ?rollback_plan_entity - rollback_plan)
    (source_component_active ?source_component_entity - source_component_instance)
    (target_component_active ?target_component_entity - target_component_instance)
    (release_authorized ?project_entity - migration_project)
  )
  (:action discover_component
    :parameters (?component_entity - application_component)
    :precondition
      (and
        (not
          (entity_discovered ?component_entity)
        )
        (not
          (entity_migrated ?component_entity)
        )
      )
    :effect (entity_discovered ?component_entity)
  )
  (:action assign_component_to_environment
    :parameters (?component_entity - application_component ?environment_entity - deployment_environment)
    :precondition
      (and
        (entity_discovered ?component_entity)
        (not
          (entity_registered ?component_entity)
        )
        (deployment_environment_available ?environment_entity)
      )
    :effect
      (and
        (entity_registered ?component_entity)
        (entity_assigned_to_environment ?component_entity ?environment_entity)
        (not
          (deployment_environment_available ?environment_entity)
        )
      )
  )
  (:action attach_interface_specification
    :parameters (?component_entity - application_component ?interface_spec_entity - interface_specification)
    :precondition
      (and
        (entity_discovered ?component_entity)
        (entity_registered ?component_entity)
        (interface_specification_available ?interface_spec_entity)
      )
    :effect
      (and
        (interface_specification_attached ?component_entity ?interface_spec_entity)
        (not
          (interface_specification_available ?interface_spec_entity)
        )
      )
  )
  (:action confirm_interface_specification
    :parameters (?component_entity - application_component ?interface_spec_entity - interface_specification)
    :precondition
      (and
        (entity_discovered ?component_entity)
        (entity_registered ?component_entity)
        (interface_specification_attached ?component_entity ?interface_spec_entity)
        (not
          (entity_interface_verified ?component_entity)
        )
      )
    :effect (entity_interface_verified ?component_entity)
  )
  (:action detach_interface_specification
    :parameters (?component_entity - application_component ?interface_spec_entity - interface_specification)
    :precondition
      (and
        (interface_specification_attached ?component_entity ?interface_spec_entity)
      )
    :effect
      (and
        (interface_specification_available ?interface_spec_entity)
        (not
          (interface_specification_attached ?component_entity ?interface_spec_entity)
        )
      )
  )
  (:action attach_interface_adapter
    :parameters (?component_entity - application_component ?adapter_entity - interface_adapter)
    :precondition
      (and
        (entity_interface_verified ?component_entity)
        (interface_adapter_available ?adapter_entity)
      )
    :effect
      (and
        (interface_adapter_attached ?component_entity ?adapter_entity)
        (not
          (interface_adapter_available ?adapter_entity)
        )
      )
  )
  (:action detach_interface_adapter
    :parameters (?component_entity - application_component ?adapter_entity - interface_adapter)
    :precondition
      (and
        (interface_adapter_attached ?component_entity ?adapter_entity)
      )
    :effect
      (and
        (interface_adapter_available ?adapter_entity)
        (not
          (interface_adapter_attached ?component_entity ?adapter_entity)
        )
      )
  )
  (:action attach_performance_profile
    :parameters (?project_entity - migration_project ?performance_profile_entity - performance_profile)
    :precondition
      (and
        (entity_interface_verified ?project_entity)
        (performance_profile_available ?performance_profile_entity)
      )
    :effect
      (and
        (project_has_performance_profile ?project_entity ?performance_profile_entity)
        (not
          (performance_profile_available ?performance_profile_entity)
        )
      )
  )
  (:action detach_performance_profile
    :parameters (?project_entity - migration_project ?performance_profile_entity - performance_profile)
    :precondition
      (and
        (project_has_performance_profile ?project_entity ?performance_profile_entity)
      )
    :effect
      (and
        (performance_profile_available ?performance_profile_entity)
        (not
          (project_has_performance_profile ?project_entity ?performance_profile_entity)
        )
      )
  )
  (:action attach_approval_token
    :parameters (?project_entity - migration_project ?approval_token_entity - approval_token)
    :precondition
      (and
        (entity_interface_verified ?project_entity)
        (approval_token_available ?approval_token_entity)
      )
    :effect
      (and
        (project_has_approval_token ?project_entity ?approval_token_entity)
        (not
          (approval_token_available ?approval_token_entity)
        )
      )
  )
  (:action detach_approval_token
    :parameters (?project_entity - migration_project ?approval_token_entity - approval_token)
    :precondition
      (and
        (project_has_approval_token ?project_entity ?approval_token_entity)
      )
    :effect
      (and
        (approval_token_available ?approval_token_entity)
        (not
          (project_has_approval_token ?project_entity ?approval_token_entity)
        )
      )
  )
  (:action prepare_source_interface
    :parameters (?source_component_entity - source_component_instance ?source_interface_entity - source_interface ?interface_spec_entity - interface_specification)
    :precondition
      (and
        (entity_interface_verified ?source_component_entity)
        (interface_specification_attached ?source_component_entity ?interface_spec_entity)
        (source_component_links_source_interface ?source_component_entity ?source_interface_entity)
        (not
          (source_interface_ready ?source_interface_entity)
        )
        (not
          (source_interface_committed ?source_interface_entity)
        )
      )
    :effect (source_interface_ready ?source_interface_entity)
  )
  (:action mark_source_component_ready
    :parameters (?source_component_entity - source_component_instance ?source_interface_entity - source_interface ?adapter_entity - interface_adapter)
    :precondition
      (and
        (entity_interface_verified ?source_component_entity)
        (interface_adapter_attached ?source_component_entity ?adapter_entity)
        (source_component_links_source_interface ?source_component_entity ?source_interface_entity)
        (source_interface_ready ?source_interface_entity)
        (not
          (source_component_active ?source_component_entity)
        )
      )
    :effect
      (and
        (source_component_active ?source_component_entity)
        (source_component_ready ?source_component_entity)
      )
  )
  (:action reserve_source_migration_tool
    :parameters (?source_component_entity - source_component_instance ?source_interface_entity - source_interface ?tool_entity - migration_tool)
    :precondition
      (and
        (entity_interface_verified ?source_component_entity)
        (source_component_links_source_interface ?source_component_entity ?source_interface_entity)
        (migration_tool_available ?tool_entity)
        (not
          (source_component_active ?source_component_entity)
        )
      )
    :effect
      (and
        (source_interface_committed ?source_interface_entity)
        (source_component_active ?source_component_entity)
        (source_tool_reserved ?source_component_entity ?tool_entity)
        (not
          (migration_tool_available ?tool_entity)
        )
      )
  )
  (:action release_source_migration_tool
    :parameters (?source_component_entity - source_component_instance ?source_interface_entity - source_interface ?interface_spec_entity - interface_specification ?tool_entity - migration_tool)
    :precondition
      (and
        (entity_interface_verified ?source_component_entity)
        (interface_specification_attached ?source_component_entity ?interface_spec_entity)
        (source_component_links_source_interface ?source_component_entity ?source_interface_entity)
        (source_interface_committed ?source_interface_entity)
        (source_tool_reserved ?source_component_entity ?tool_entity)
        (not
          (source_component_ready ?source_component_entity)
        )
      )
    :effect
      (and
        (source_interface_ready ?source_interface_entity)
        (source_component_ready ?source_component_entity)
        (migration_tool_available ?tool_entity)
        (not
          (source_tool_reserved ?source_component_entity ?tool_entity)
        )
      )
  )
  (:action prepare_target_interface
    :parameters (?target_component_entity - target_component_instance ?target_interface_entity - target_interface ?interface_spec_entity - interface_specification)
    :precondition
      (and
        (entity_interface_verified ?target_component_entity)
        (interface_specification_attached ?target_component_entity ?interface_spec_entity)
        (target_component_links_target_interface ?target_component_entity ?target_interface_entity)
        (not
          (target_interface_ready ?target_interface_entity)
        )
        (not
          (target_interface_committed ?target_interface_entity)
        )
      )
    :effect (target_interface_ready ?target_interface_entity)
  )
  (:action mark_target_component_ready
    :parameters (?target_component_entity - target_component_instance ?target_interface_entity - target_interface ?adapter_entity - interface_adapter)
    :precondition
      (and
        (entity_interface_verified ?target_component_entity)
        (interface_adapter_attached ?target_component_entity ?adapter_entity)
        (target_component_links_target_interface ?target_component_entity ?target_interface_entity)
        (target_interface_ready ?target_interface_entity)
        (not
          (target_component_active ?target_component_entity)
        )
      )
    :effect
      (and
        (target_component_active ?target_component_entity)
        (target_component_ready ?target_component_entity)
      )
  )
  (:action reserve_target_migration_tool
    :parameters (?target_component_entity - target_component_instance ?target_interface_entity - target_interface ?tool_entity - migration_tool)
    :precondition
      (and
        (entity_interface_verified ?target_component_entity)
        (target_component_links_target_interface ?target_component_entity ?target_interface_entity)
        (migration_tool_available ?tool_entity)
        (not
          (target_component_active ?target_component_entity)
        )
      )
    :effect
      (and
        (target_interface_committed ?target_interface_entity)
        (target_component_active ?target_component_entity)
        (target_tool_reserved ?target_component_entity ?tool_entity)
        (not
          (migration_tool_available ?tool_entity)
        )
      )
  )
  (:action release_target_migration_tool
    :parameters (?target_component_entity - target_component_instance ?target_interface_entity - target_interface ?interface_spec_entity - interface_specification ?tool_entity - migration_tool)
    :precondition
      (and
        (entity_interface_verified ?target_component_entity)
        (interface_specification_attached ?target_component_entity ?interface_spec_entity)
        (target_component_links_target_interface ?target_component_entity ?target_interface_entity)
        (target_interface_committed ?target_interface_entity)
        (target_tool_reserved ?target_component_entity ?tool_entity)
        (not
          (target_component_ready ?target_component_entity)
        )
      )
    :effect
      (and
        (target_interface_ready ?target_interface_entity)
        (target_component_ready ?target_component_entity)
        (migration_tool_available ?tool_entity)
        (not
          (target_tool_reserved ?target_component_entity ?tool_entity)
        )
      )
  )
  (:action assemble_migration_bundle
    :parameters (?source_component_entity - source_component_instance ?target_component_entity - target_component_instance ?source_interface_entity - source_interface ?target_interface_entity - target_interface ?bundle_entity - migration_bundle)
    :precondition
      (and
        (source_component_active ?source_component_entity)
        (target_component_active ?target_component_entity)
        (source_component_links_source_interface ?source_component_entity ?source_interface_entity)
        (target_component_links_target_interface ?target_component_entity ?target_interface_entity)
        (source_interface_ready ?source_interface_entity)
        (target_interface_ready ?target_interface_entity)
        (source_component_ready ?source_component_entity)
        (target_component_ready ?target_component_entity)
        (migration_bundle_available ?bundle_entity)
      )
    :effect
      (and
        (migration_bundle_assembled ?bundle_entity)
        (bundle_links_source_interface ?bundle_entity ?source_interface_entity)
        (bundle_links_target_interface ?bundle_entity ?target_interface_entity)
        (not
          (migration_bundle_available ?bundle_entity)
        )
      )
  )
  (:action assemble_migration_bundle_source_branch
    :parameters (?source_component_entity - source_component_instance ?target_component_entity - target_component_instance ?source_interface_entity - source_interface ?target_interface_entity - target_interface ?bundle_entity - migration_bundle)
    :precondition
      (and
        (source_component_active ?source_component_entity)
        (target_component_active ?target_component_entity)
        (source_component_links_source_interface ?source_component_entity ?source_interface_entity)
        (target_component_links_target_interface ?target_component_entity ?target_interface_entity)
        (source_interface_committed ?source_interface_entity)
        (target_interface_ready ?target_interface_entity)
        (not
          (source_component_ready ?source_component_entity)
        )
        (target_component_ready ?target_component_entity)
        (migration_bundle_available ?bundle_entity)
      )
    :effect
      (and
        (migration_bundle_assembled ?bundle_entity)
        (bundle_links_source_interface ?bundle_entity ?source_interface_entity)
        (bundle_links_target_interface ?bundle_entity ?target_interface_entity)
        (source_validation_branch ?bundle_entity)
        (not
          (migration_bundle_available ?bundle_entity)
        )
      )
  )
  (:action assemble_migration_bundle_target_branch
    :parameters (?source_component_entity - source_component_instance ?target_component_entity - target_component_instance ?source_interface_entity - source_interface ?target_interface_entity - target_interface ?bundle_entity - migration_bundle)
    :precondition
      (and
        (source_component_active ?source_component_entity)
        (target_component_active ?target_component_entity)
        (source_component_links_source_interface ?source_component_entity ?source_interface_entity)
        (target_component_links_target_interface ?target_component_entity ?target_interface_entity)
        (source_interface_ready ?source_interface_entity)
        (target_interface_committed ?target_interface_entity)
        (source_component_ready ?source_component_entity)
        (not
          (target_component_ready ?target_component_entity)
        )
        (migration_bundle_available ?bundle_entity)
      )
    :effect
      (and
        (migration_bundle_assembled ?bundle_entity)
        (bundle_links_source_interface ?bundle_entity ?source_interface_entity)
        (bundle_links_target_interface ?bundle_entity ?target_interface_entity)
        (target_validation_branch ?bundle_entity)
        (not
          (migration_bundle_available ?bundle_entity)
        )
      )
  )
  (:action assemble_migration_bundle_full_branch
    :parameters (?source_component_entity - source_component_instance ?target_component_entity - target_component_instance ?source_interface_entity - source_interface ?target_interface_entity - target_interface ?bundle_entity - migration_bundle)
    :precondition
      (and
        (source_component_active ?source_component_entity)
        (target_component_active ?target_component_entity)
        (source_component_links_source_interface ?source_component_entity ?source_interface_entity)
        (target_component_links_target_interface ?target_component_entity ?target_interface_entity)
        (source_interface_committed ?source_interface_entity)
        (target_interface_committed ?target_interface_entity)
        (not
          (source_component_ready ?source_component_entity)
        )
        (not
          (target_component_ready ?target_component_entity)
        )
        (migration_bundle_available ?bundle_entity)
      )
    :effect
      (and
        (migration_bundle_assembled ?bundle_entity)
        (bundle_links_source_interface ?bundle_entity ?source_interface_entity)
        (bundle_links_target_interface ?bundle_entity ?target_interface_entity)
        (source_validation_branch ?bundle_entity)
        (target_validation_branch ?bundle_entity)
        (not
          (migration_bundle_available ?bundle_entity)
        )
      )
  )
  (:action finalize_migration_bundle
    :parameters (?bundle_entity - migration_bundle ?source_component_entity - source_component_instance ?interface_spec_entity - interface_specification)
    :precondition
      (and
        (migration_bundle_assembled ?bundle_entity)
        (source_component_active ?source_component_entity)
        (interface_specification_attached ?source_component_entity ?interface_spec_entity)
        (not
          (migration_bundle_finalized ?bundle_entity)
        )
      )
    :effect (migration_bundle_finalized ?bundle_entity)
  )
  (:action link_schema_to_bundle
    :parameters (?project_entity - migration_project ?schema_entity - data_schema ?bundle_entity - migration_bundle)
    :precondition
      (and
        (entity_interface_verified ?project_entity)
        (project_has_bundle ?project_entity ?bundle_entity)
        (project_has_schema ?project_entity ?schema_entity)
        (data_schema_available ?schema_entity)
        (migration_bundle_assembled ?bundle_entity)
        (migration_bundle_finalized ?bundle_entity)
        (not
          (schema_locked ?schema_entity)
        )
      )
    :effect
      (and
        (schema_locked ?schema_entity)
        (schema_embedded_in_bundle ?schema_entity ?bundle_entity)
        (not
          (data_schema_available ?schema_entity)
        )
      )
  )
  (:action validate_schema_for_project
    :parameters (?project_entity - migration_project ?schema_entity - data_schema ?bundle_entity - migration_bundle ?interface_spec_entity - interface_specification)
    :precondition
      (and
        (entity_interface_verified ?project_entity)
        (project_has_schema ?project_entity ?schema_entity)
        (schema_locked ?schema_entity)
        (schema_embedded_in_bundle ?schema_entity ?bundle_entity)
        (interface_specification_attached ?project_entity ?interface_spec_entity)
        (not
          (source_validation_branch ?bundle_entity)
        )
        (not
          (schema_validated ?project_entity)
        )
      )
    :effect (schema_validated ?project_entity)
  )
  (:action attach_compliance_document
    :parameters (?project_entity - migration_project ?compliance_document_entity - compliance_document)
    :precondition
      (and
        (entity_interface_verified ?project_entity)
        (compliance_document_available ?compliance_document_entity)
        (not
          (compliance_document_attached ?project_entity)
        )
      )
    :effect
      (and
        (compliance_document_attached ?project_entity)
        (project_has_compliance_document ?project_entity ?compliance_document_entity)
        (not
          (compliance_document_available ?compliance_document_entity)
        )
      )
  )
  (:action pass_compliance_gate
    :parameters (?project_entity - migration_project ?schema_entity - data_schema ?bundle_entity - migration_bundle ?interface_spec_entity - interface_specification ?compliance_document_entity - compliance_document)
    :precondition
      (and
        (entity_interface_verified ?project_entity)
        (project_has_schema ?project_entity ?schema_entity)
        (schema_locked ?schema_entity)
        (schema_embedded_in_bundle ?schema_entity ?bundle_entity)
        (interface_specification_attached ?project_entity ?interface_spec_entity)
        (source_validation_branch ?bundle_entity)
        (compliance_document_attached ?project_entity)
        (project_has_compliance_document ?project_entity ?compliance_document_entity)
        (not
          (schema_validated ?project_entity)
        )
      )
    :effect
      (and
        (schema_validated ?project_entity)
        (compliance_gate_passed ?project_entity)
      )
  )
  (:action initiate_project_review_base
    :parameters (?project_entity - migration_project ?performance_profile_entity - performance_profile ?adapter_entity - interface_adapter ?schema_entity - data_schema ?bundle_entity - migration_bundle)
    :precondition
      (and
        (schema_validated ?project_entity)
        (project_has_performance_profile ?project_entity ?performance_profile_entity)
        (interface_adapter_attached ?project_entity ?adapter_entity)
        (project_has_schema ?project_entity ?schema_entity)
        (schema_embedded_in_bundle ?schema_entity ?bundle_entity)
        (not
          (target_validation_branch ?bundle_entity)
        )
        (not
          (project_under_review ?project_entity)
        )
      )
    :effect (project_under_review ?project_entity)
  )
  (:action initiate_project_review_target_branch
    :parameters (?project_entity - migration_project ?performance_profile_entity - performance_profile ?adapter_entity - interface_adapter ?schema_entity - data_schema ?bundle_entity - migration_bundle)
    :precondition
      (and
        (schema_validated ?project_entity)
        (project_has_performance_profile ?project_entity ?performance_profile_entity)
        (interface_adapter_attached ?project_entity ?adapter_entity)
        (project_has_schema ?project_entity ?schema_entity)
        (schema_embedded_in_bundle ?schema_entity ?bundle_entity)
        (target_validation_branch ?bundle_entity)
        (not
          (project_under_review ?project_entity)
        )
      )
    :effect (project_under_review ?project_entity)
  )
  (:action request_release_signoff_base
    :parameters (?project_entity - migration_project ?approval_token_entity - approval_token ?schema_entity - data_schema ?bundle_entity - migration_bundle)
    :precondition
      (and
        (project_under_review ?project_entity)
        (project_has_approval_token ?project_entity ?approval_token_entity)
        (project_has_schema ?project_entity ?schema_entity)
        (schema_embedded_in_bundle ?schema_entity ?bundle_entity)
        (not
          (source_validation_branch ?bundle_entity)
        )
        (not
          (target_validation_branch ?bundle_entity)
        )
        (not
          (project_approved ?project_entity)
        )
      )
    :effect (project_approved ?project_entity)
  )
  (:action request_release_signoff_source_branch
    :parameters (?project_entity - migration_project ?approval_token_entity - approval_token ?schema_entity - data_schema ?bundle_entity - migration_bundle)
    :precondition
      (and
        (project_under_review ?project_entity)
        (project_has_approval_token ?project_entity ?approval_token_entity)
        (project_has_schema ?project_entity ?schema_entity)
        (schema_embedded_in_bundle ?schema_entity ?bundle_entity)
        (source_validation_branch ?bundle_entity)
        (not
          (target_validation_branch ?bundle_entity)
        )
        (not
          (project_approved ?project_entity)
        )
      )
    :effect
      (and
        (project_approved ?project_entity)
        (validation_ready ?project_entity)
      )
  )
  (:action request_release_signoff_target_branch
    :parameters (?project_entity - migration_project ?approval_token_entity - approval_token ?schema_entity - data_schema ?bundle_entity - migration_bundle)
    :precondition
      (and
        (project_under_review ?project_entity)
        (project_has_approval_token ?project_entity ?approval_token_entity)
        (project_has_schema ?project_entity ?schema_entity)
        (schema_embedded_in_bundle ?schema_entity ?bundle_entity)
        (not
          (source_validation_branch ?bundle_entity)
        )
        (target_validation_branch ?bundle_entity)
        (not
          (project_approved ?project_entity)
        )
      )
    :effect
      (and
        (project_approved ?project_entity)
        (validation_ready ?project_entity)
      )
  )
  (:action request_release_signoff_full_branch
    :parameters (?project_entity - migration_project ?approval_token_entity - approval_token ?schema_entity - data_schema ?bundle_entity - migration_bundle)
    :precondition
      (and
        (project_under_review ?project_entity)
        (project_has_approval_token ?project_entity ?approval_token_entity)
        (project_has_schema ?project_entity ?schema_entity)
        (schema_embedded_in_bundle ?schema_entity ?bundle_entity)
        (source_validation_branch ?bundle_entity)
        (target_validation_branch ?bundle_entity)
        (not
          (project_approved ?project_entity)
        )
      )
    :effect
      (and
        (project_approved ?project_entity)
        (validation_ready ?project_entity)
      )
  )
  (:action authorize_release
    :parameters (?project_entity - migration_project)
    :precondition
      (and
        (project_approved ?project_entity)
        (not
          (validation_ready ?project_entity)
        )
        (not
          (release_authorized ?project_entity)
        )
      )
    :effect
      (and
        (release_authorized ?project_entity)
        (migration_ready ?project_entity)
      )
  )
  (:action assign_test_suite
    :parameters (?project_entity - migration_project ?test_suite_entity - test_suite)
    :precondition
      (and
        (project_approved ?project_entity)
        (validation_ready ?project_entity)
        (test_suite_available ?test_suite_entity)
      )
    :effect
      (and
        (project_has_test_suite ?project_entity ?test_suite_entity)
        (not
          (test_suite_available ?test_suite_entity)
        )
      )
  )
  (:action coordinate_validation_workflow
    :parameters (?project_entity - migration_project ?source_component_entity - source_component_instance ?target_component_entity - target_component_instance ?interface_spec_entity - interface_specification ?test_suite_entity - test_suite)
    :precondition
      (and
        (project_approved ?project_entity)
        (validation_ready ?project_entity)
        (project_has_test_suite ?project_entity ?test_suite_entity)
        (project_has_source_component ?project_entity ?source_component_entity)
        (project_has_target_component ?project_entity ?target_component_entity)
        (source_component_ready ?source_component_entity)
        (target_component_ready ?target_component_entity)
        (interface_specification_attached ?project_entity ?interface_spec_entity)
        (not
          (coordination_complete ?project_entity)
        )
      )
    :effect (coordination_complete ?project_entity)
  )
  (:action confirm_migration_readiness
    :parameters (?project_entity - migration_project)
    :precondition
      (and
        (project_approved ?project_entity)
        (coordination_complete ?project_entity)
        (not
          (release_authorized ?project_entity)
        )
      )
    :effect
      (and
        (release_authorized ?project_entity)
        (migration_ready ?project_entity)
      )
  )
  (:action request_stakeholder_review
    :parameters (?project_entity - migration_project ?stakeholder_entity - stakeholder ?interface_spec_entity - interface_specification)
    :precondition
      (and
        (entity_interface_verified ?project_entity)
        (interface_specification_attached ?project_entity ?interface_spec_entity)
        (stakeholder_available ?stakeholder_entity)
        (project_has_stakeholder ?project_entity ?stakeholder_entity)
        (not
          (stakeholder_review_started ?project_entity)
        )
      )
    :effect
      (and
        (stakeholder_review_started ?project_entity)
        (not
          (stakeholder_available ?stakeholder_entity)
        )
      )
  )
  (:action record_adapter_review
    :parameters (?project_entity - migration_project ?adapter_entity - interface_adapter)
    :precondition
      (and
        (stakeholder_review_started ?project_entity)
        (interface_adapter_attached ?project_entity ?adapter_entity)
        (not
          (adapter_review_complete ?project_entity)
        )
      )
    :effect (adapter_review_complete ?project_entity)
  )
  (:action capture_approval_token
    :parameters (?project_entity - migration_project ?approval_token_entity - approval_token)
    :precondition
      (and
        (adapter_review_complete ?project_entity)
        (project_has_approval_token ?project_entity ?approval_token_entity)
        (not
          (approval_recorded ?project_entity)
        )
      )
    :effect (approval_recorded ?project_entity)
  )
  (:action finalize_release_signoff
    :parameters (?project_entity - migration_project)
    :precondition
      (and
        (approval_recorded ?project_entity)
        (not
          (release_authorized ?project_entity)
        )
      )
    :effect
      (and
        (release_authorized ?project_entity)
        (migration_ready ?project_entity)
      )
  )
  (:action activate_source_component
    :parameters (?source_component_entity - source_component_instance ?bundle_entity - migration_bundle)
    :precondition
      (and
        (source_component_active ?source_component_entity)
        (source_component_ready ?source_component_entity)
        (migration_bundle_assembled ?bundle_entity)
        (migration_bundle_finalized ?bundle_entity)
        (not
          (migration_ready ?source_component_entity)
        )
      )
    :effect (migration_ready ?source_component_entity)
  )
  (:action activate_target_component
    :parameters (?target_component_entity - target_component_instance ?bundle_entity - migration_bundle)
    :precondition
      (and
        (target_component_active ?target_component_entity)
        (target_component_ready ?target_component_entity)
        (migration_bundle_assembled ?bundle_entity)
        (migration_bundle_finalized ?bundle_entity)
        (not
          (migration_ready ?target_component_entity)
        )
      )
    :effect (migration_ready ?target_component_entity)
  )
  (:action start_component_cutover
    :parameters (?component_entity - application_component ?rollback_plan_entity - rollback_plan ?interface_spec_entity - interface_specification)
    :precondition
      (and
        (migration_ready ?component_entity)
        (interface_specification_attached ?component_entity ?interface_spec_entity)
        (rollback_plan_available ?rollback_plan_entity)
        (not
          (cutover_in_progress ?component_entity)
        )
      )
    :effect
      (and
        (cutover_in_progress ?component_entity)
        (entity_has_rollback_plan ?component_entity ?rollback_plan_entity)
        (not
          (rollback_plan_available ?rollback_plan_entity)
        )
      )
  )
  (:action finalize_source_component_migration
    :parameters (?source_component_entity - source_component_instance ?environment_entity - deployment_environment ?rollback_plan_entity - rollback_plan)
    :precondition
      (and
        (cutover_in_progress ?source_component_entity)
        (entity_assigned_to_environment ?source_component_entity ?environment_entity)
        (entity_has_rollback_plan ?source_component_entity ?rollback_plan_entity)
        (not
          (entity_migrated ?source_component_entity)
        )
      )
    :effect
      (and
        (entity_migrated ?source_component_entity)
        (deployment_environment_available ?environment_entity)
        (rollback_plan_available ?rollback_plan_entity)
      )
  )
  (:action finalize_target_component_migration
    :parameters (?target_component_entity - target_component_instance ?environment_entity - deployment_environment ?rollback_plan_entity - rollback_plan)
    :precondition
      (and
        (cutover_in_progress ?target_component_entity)
        (entity_assigned_to_environment ?target_component_entity ?environment_entity)
        (entity_has_rollback_plan ?target_component_entity ?rollback_plan_entity)
        (not
          (entity_migrated ?target_component_entity)
        )
      )
    :effect
      (and
        (entity_migrated ?target_component_entity)
        (deployment_environment_available ?environment_entity)
        (rollback_plan_available ?rollback_plan_entity)
      )
  )
  (:action finalize_project_migration
    :parameters (?project_entity - migration_project ?environment_entity - deployment_environment ?rollback_plan_entity - rollback_plan)
    :precondition
      (and
        (cutover_in_progress ?project_entity)
        (entity_assigned_to_environment ?project_entity ?environment_entity)
        (entity_has_rollback_plan ?project_entity ?rollback_plan_entity)
        (not
          (entity_migrated ?project_entity)
        )
      )
    :effect
      (and
        (entity_migrated ?project_entity)
        (deployment_environment_available ?environment_entity)
        (rollback_plan_available ?rollback_plan_entity)
      )
  )
)

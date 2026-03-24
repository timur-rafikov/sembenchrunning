(define (domain nosql_database_integration)
  (:requirements :strips :typing :negative-preconditions)
  (:types runtime_artifact - object data_artifact - object network_artifact - object component_role - object system_component - component_role credential_token - runtime_artifact connection_pool - runtime_artifact driver_binary - runtime_artifact feature_flag - runtime_artifact deployment_parameter - runtime_artifact observation_config - runtime_artifact index_directive - runtime_artifact migration_plan - runtime_artifact payload_template - data_artifact schema_artifact - data_artifact access_policy - data_artifact primary_endpoint - network_artifact secondary_endpoint - network_artifact database_namespace - network_artifact primary_role - system_component pipeline_role - system_component primary_app_instance - primary_role secondary_app_instance - primary_role integration_pipeline - pipeline_role)
  (:predicates
    (component_initialized ?system_component - system_component)
    (component_ready ?system_component - system_component)
    (component_has_credential_token ?system_component - system_component)
    (component_deployed ?system_component - system_component)
    (component_active ?system_component - system_component)
    (deployment_configured ?system_component - system_component)
    (credential_available ?credential_token - credential_token)
    (component_assigned_credential_token ?system_component - system_component ?credential_token - credential_token)
    (connection_pool_available ?connection_pool - connection_pool)
    (component_assigned_connection_pool ?system_component - system_component ?connection_pool - connection_pool)
    (driver_available ?driver_binary - driver_binary)
    (component_assigned_driver_binary ?system_component - system_component ?driver_binary - driver_binary)
    (payload_template_available ?payload_template - payload_template)
    (primary_instance_assigned_payload_template ?primary_app_instance - primary_app_instance ?payload_template - payload_template)
    (secondary_instance_assigned_payload_template ?secondary_app_instance - secondary_app_instance ?payload_template - payload_template)
    (primary_instance_assigned_endpoint ?primary_app_instance - primary_app_instance ?primary_endpoint - primary_endpoint)
    (primary_endpoint_ready ?primary_endpoint - primary_endpoint)
    (primary_endpoint_staged ?primary_endpoint - primary_endpoint)
    (primary_instance_provisioned ?primary_app_instance - primary_app_instance)
    (secondary_instance_assigned_endpoint ?secondary_app_instance - secondary_app_instance ?secondary_endpoint - secondary_endpoint)
    (secondary_endpoint_ready ?secondary_endpoint - secondary_endpoint)
    (secondary_endpoint_staged ?secondary_endpoint - secondary_endpoint)
    (secondary_instance_provisioned ?secondary_app_instance - secondary_app_instance)
    (namespace_pending_provision ?database_namespace - database_namespace)
    (namespace_provisioned ?database_namespace - database_namespace)
    (database_namespace_assigned_primary_endpoint ?database_namespace - database_namespace ?primary_endpoint - primary_endpoint)
    (database_namespace_assigned_secondary_endpoint ?database_namespace - database_namespace ?secondary_endpoint - secondary_endpoint)
    (namespace_primary_endpoint_staged ?database_namespace - database_namespace)
    (namespace_secondary_endpoint_staged ?database_namespace - database_namespace)
    (namespace_ready_for_schema ?database_namespace - database_namespace)
    (pipeline_assigned_primary_instance ?integration_pipeline - integration_pipeline ?primary_app_instance - primary_app_instance)
    (pipeline_assigned_secondary_instance ?integration_pipeline - integration_pipeline ?secondary_app_instance - secondary_app_instance)
    (pipeline_assigned_database_namespace ?integration_pipeline - integration_pipeline ?database_namespace - database_namespace)
    (schema_artifact_available ?schema_artifact - schema_artifact)
    (pipeline_assigned_schema_artifact ?integration_pipeline - integration_pipeline ?schema_artifact - schema_artifact)
    (schema_artifact_staged ?schema_artifact - schema_artifact)
    (schema_artifact_assigned_to_database_namespace ?schema_artifact - schema_artifact ?database_namespace - database_namespace)
    (pipeline_schema_committed ?integration_pipeline - integration_pipeline)
    (pipeline_indexing_started ?integration_pipeline - integration_pipeline)
    (pipeline_indexing_completed ?integration_pipeline - integration_pipeline)
    (pipeline_has_feature_flag ?integration_pipeline - integration_pipeline)
    (pipeline_feature_flag_activated ?integration_pipeline - integration_pipeline)
    (pipeline_ready_for_deployment_parameters ?integration_pipeline - integration_pipeline)
    (pipeline_deployment_executed ?integration_pipeline - integration_pipeline)
    (access_policy_available ?access_policy - access_policy)
    (pipeline_assigned_access_policy ?integration_pipeline - integration_pipeline ?access_policy - access_policy)
    (pipeline_has_access_policy ?integration_pipeline - integration_pipeline)
    (pipeline_policy_configured ?integration_pipeline - integration_pipeline)
    (pipeline_policy_active ?integration_pipeline - integration_pipeline)
    (feature_flag_available ?feature_flag - feature_flag)
    (pipeline_assigned_feature_flag ?integration_pipeline - integration_pipeline ?feature_flag - feature_flag)
    (deployment_parameter_available ?deployment_parameter - deployment_parameter)
    (pipeline_assigned_deployment_parameter ?integration_pipeline - integration_pipeline ?deployment_parameter - deployment_parameter)
    (index_directive_available ?index_directive - index_directive)
    (pipeline_assigned_index_directive ?integration_pipeline - integration_pipeline ?index_directive - index_directive)
    (migration_plan_available ?migration_plan - migration_plan)
    (pipeline_assigned_migration_plan ?integration_pipeline - integration_pipeline ?migration_plan - migration_plan)
    (observation_config_available ?observation_config - observation_config)
    (component_has_observation_config ?system_component - system_component ?observation_config - observation_config)
    (primary_instance_orchestrated ?primary_app_instance - primary_app_instance)
    (secondary_instance_orchestrated ?secondary_app_instance - secondary_app_instance)
    (pipeline_activation_marked ?integration_pipeline - integration_pipeline)
  )
  (:action initialize_system_component
    :parameters (?system_component - system_component)
    :precondition
      (and
        (not
          (component_initialized ?system_component)
        )
        (not
          (component_deployed ?system_component)
        )
      )
    :effect (component_initialized ?system_component)
  )
  (:action assign_credential_to_component
    :parameters (?system_component - system_component ?credential_token - credential_token)
    :precondition
      (and
        (component_initialized ?system_component)
        (not
          (component_has_credential_token ?system_component)
        )
        (credential_available ?credential_token)
      )
    :effect
      (and
        (component_has_credential_token ?system_component)
        (component_assigned_credential_token ?system_component ?credential_token)
        (not
          (credential_available ?credential_token)
        )
      )
  )
  (:action assign_connection_pool_to_component
    :parameters (?system_component - system_component ?connection_pool - connection_pool)
    :precondition
      (and
        (component_initialized ?system_component)
        (component_has_credential_token ?system_component)
        (connection_pool_available ?connection_pool)
      )
    :effect
      (and
        (component_assigned_connection_pool ?system_component ?connection_pool)
        (not
          (connection_pool_available ?connection_pool)
        )
      )
  )
  (:action mark_component_ready
    :parameters (?system_component - system_component ?connection_pool - connection_pool)
    :precondition
      (and
        (component_initialized ?system_component)
        (component_has_credential_token ?system_component)
        (component_assigned_connection_pool ?system_component ?connection_pool)
        (not
          (component_ready ?system_component)
        )
      )
    :effect (component_ready ?system_component)
  )
  (:action unassign_connection_pool_from_component
    :parameters (?system_component - system_component ?connection_pool - connection_pool)
    :precondition
      (and
        (component_assigned_connection_pool ?system_component ?connection_pool)
      )
    :effect
      (and
        (connection_pool_available ?connection_pool)
        (not
          (component_assigned_connection_pool ?system_component ?connection_pool)
        )
      )
  )
  (:action assign_driver_to_component
    :parameters (?system_component - system_component ?driver_binary - driver_binary)
    :precondition
      (and
        (component_ready ?system_component)
        (driver_available ?driver_binary)
      )
    :effect
      (and
        (component_assigned_driver_binary ?system_component ?driver_binary)
        (not
          (driver_available ?driver_binary)
        )
      )
  )
  (:action unassign_driver_from_component
    :parameters (?system_component - system_component ?driver_binary - driver_binary)
    :precondition
      (and
        (component_assigned_driver_binary ?system_component ?driver_binary)
      )
    :effect
      (and
        (driver_available ?driver_binary)
        (not
          (component_assigned_driver_binary ?system_component ?driver_binary)
        )
      )
  )
  (:action assign_index_directive_to_pipeline
    :parameters (?integration_pipeline - integration_pipeline ?index_directive - index_directive)
    :precondition
      (and
        (component_ready ?integration_pipeline)
        (index_directive_available ?index_directive)
      )
    :effect
      (and
        (pipeline_assigned_index_directive ?integration_pipeline ?index_directive)
        (not
          (index_directive_available ?index_directive)
        )
      )
  )
  (:action unassign_index_directive_from_pipeline
    :parameters (?integration_pipeline - integration_pipeline ?index_directive - index_directive)
    :precondition
      (and
        (pipeline_assigned_index_directive ?integration_pipeline ?index_directive)
      )
    :effect
      (and
        (index_directive_available ?index_directive)
        (not
          (pipeline_assigned_index_directive ?integration_pipeline ?index_directive)
        )
      )
  )
  (:action assign_migration_plan_to_pipeline
    :parameters (?integration_pipeline - integration_pipeline ?migration_plan - migration_plan)
    :precondition
      (and
        (component_ready ?integration_pipeline)
        (migration_plan_available ?migration_plan)
      )
    :effect
      (and
        (pipeline_assigned_migration_plan ?integration_pipeline ?migration_plan)
        (not
          (migration_plan_available ?migration_plan)
        )
      )
  )
  (:action unassign_migration_plan_from_pipeline
    :parameters (?integration_pipeline - integration_pipeline ?migration_plan - migration_plan)
    :precondition
      (and
        (pipeline_assigned_migration_plan ?integration_pipeline ?migration_plan)
      )
    :effect
      (and
        (migration_plan_available ?migration_plan)
        (not
          (pipeline_assigned_migration_plan ?integration_pipeline ?migration_plan)
        )
      )
  )
  (:action verify_primary_endpoint_readiness
    :parameters (?primary_app_instance - primary_app_instance ?primary_endpoint - primary_endpoint ?connection_pool - connection_pool)
    :precondition
      (and
        (component_ready ?primary_app_instance)
        (component_assigned_connection_pool ?primary_app_instance ?connection_pool)
        (primary_instance_assigned_endpoint ?primary_app_instance ?primary_endpoint)
        (not
          (primary_endpoint_ready ?primary_endpoint)
        )
        (not
          (primary_endpoint_staged ?primary_endpoint)
        )
      )
    :effect (primary_endpoint_ready ?primary_endpoint)
  )
  (:action orchestrate_primary_instance_with_driver
    :parameters (?primary_app_instance - primary_app_instance ?primary_endpoint - primary_endpoint ?driver_binary - driver_binary)
    :precondition
      (and
        (component_ready ?primary_app_instance)
        (component_assigned_driver_binary ?primary_app_instance ?driver_binary)
        (primary_instance_assigned_endpoint ?primary_app_instance ?primary_endpoint)
        (primary_endpoint_ready ?primary_endpoint)
        (not
          (primary_instance_orchestrated ?primary_app_instance)
        )
      )
    :effect
      (and
        (primary_instance_orchestrated ?primary_app_instance)
        (primary_instance_provisioned ?primary_app_instance)
      )
  )
  (:action apply_payload_template_to_primary_instance
    :parameters (?primary_app_instance - primary_app_instance ?primary_endpoint - primary_endpoint ?payload_template - payload_template)
    :precondition
      (and
        (component_ready ?primary_app_instance)
        (primary_instance_assigned_endpoint ?primary_app_instance ?primary_endpoint)
        (payload_template_available ?payload_template)
        (not
          (primary_instance_orchestrated ?primary_app_instance)
        )
      )
    :effect
      (and
        (primary_endpoint_staged ?primary_endpoint)
        (primary_instance_orchestrated ?primary_app_instance)
        (primary_instance_assigned_payload_template ?primary_app_instance ?payload_template)
        (not
          (payload_template_available ?payload_template)
        )
      )
  )
  (:action finalize_primary_template_application
    :parameters (?primary_app_instance - primary_app_instance ?primary_endpoint - primary_endpoint ?connection_pool - connection_pool ?payload_template - payload_template)
    :precondition
      (and
        (component_ready ?primary_app_instance)
        (component_assigned_connection_pool ?primary_app_instance ?connection_pool)
        (primary_instance_assigned_endpoint ?primary_app_instance ?primary_endpoint)
        (primary_endpoint_staged ?primary_endpoint)
        (primary_instance_assigned_payload_template ?primary_app_instance ?payload_template)
        (not
          (primary_instance_provisioned ?primary_app_instance)
        )
      )
    :effect
      (and
        (primary_endpoint_ready ?primary_endpoint)
        (primary_instance_provisioned ?primary_app_instance)
        (payload_template_available ?payload_template)
        (not
          (primary_instance_assigned_payload_template ?primary_app_instance ?payload_template)
        )
      )
  )
  (:action verify_secondary_endpoint_readiness
    :parameters (?secondary_app_instance - secondary_app_instance ?secondary_endpoint - secondary_endpoint ?connection_pool - connection_pool)
    :precondition
      (and
        (component_ready ?secondary_app_instance)
        (component_assigned_connection_pool ?secondary_app_instance ?connection_pool)
        (secondary_instance_assigned_endpoint ?secondary_app_instance ?secondary_endpoint)
        (not
          (secondary_endpoint_ready ?secondary_endpoint)
        )
        (not
          (secondary_endpoint_staged ?secondary_endpoint)
        )
      )
    :effect (secondary_endpoint_ready ?secondary_endpoint)
  )
  (:action orchestrate_secondary_instance_with_driver
    :parameters (?secondary_app_instance - secondary_app_instance ?secondary_endpoint - secondary_endpoint ?driver_binary - driver_binary)
    :precondition
      (and
        (component_ready ?secondary_app_instance)
        (component_assigned_driver_binary ?secondary_app_instance ?driver_binary)
        (secondary_instance_assigned_endpoint ?secondary_app_instance ?secondary_endpoint)
        (secondary_endpoint_ready ?secondary_endpoint)
        (not
          (secondary_instance_orchestrated ?secondary_app_instance)
        )
      )
    :effect
      (and
        (secondary_instance_orchestrated ?secondary_app_instance)
        (secondary_instance_provisioned ?secondary_app_instance)
      )
  )
  (:action apply_payload_template_to_secondary_instance
    :parameters (?secondary_app_instance - secondary_app_instance ?secondary_endpoint - secondary_endpoint ?payload_template - payload_template)
    :precondition
      (and
        (component_ready ?secondary_app_instance)
        (secondary_instance_assigned_endpoint ?secondary_app_instance ?secondary_endpoint)
        (payload_template_available ?payload_template)
        (not
          (secondary_instance_orchestrated ?secondary_app_instance)
        )
      )
    :effect
      (and
        (secondary_endpoint_staged ?secondary_endpoint)
        (secondary_instance_orchestrated ?secondary_app_instance)
        (secondary_instance_assigned_payload_template ?secondary_app_instance ?payload_template)
        (not
          (payload_template_available ?payload_template)
        )
      )
  )
  (:action finalize_secondary_template_application
    :parameters (?secondary_app_instance - secondary_app_instance ?secondary_endpoint - secondary_endpoint ?connection_pool - connection_pool ?payload_template - payload_template)
    :precondition
      (and
        (component_ready ?secondary_app_instance)
        (component_assigned_connection_pool ?secondary_app_instance ?connection_pool)
        (secondary_instance_assigned_endpoint ?secondary_app_instance ?secondary_endpoint)
        (secondary_endpoint_staged ?secondary_endpoint)
        (secondary_instance_assigned_payload_template ?secondary_app_instance ?payload_template)
        (not
          (secondary_instance_provisioned ?secondary_app_instance)
        )
      )
    :effect
      (and
        (secondary_endpoint_ready ?secondary_endpoint)
        (secondary_instance_provisioned ?secondary_app_instance)
        (payload_template_available ?payload_template)
        (not
          (secondary_instance_assigned_payload_template ?secondary_app_instance ?payload_template)
        )
      )
  )
  (:action provision_database_namespace
    :parameters (?primary_app_instance - primary_app_instance ?secondary_app_instance - secondary_app_instance ?primary_endpoint - primary_endpoint ?secondary_endpoint - secondary_endpoint ?database_namespace - database_namespace)
    :precondition
      (and
        (primary_instance_orchestrated ?primary_app_instance)
        (secondary_instance_orchestrated ?secondary_app_instance)
        (primary_instance_assigned_endpoint ?primary_app_instance ?primary_endpoint)
        (secondary_instance_assigned_endpoint ?secondary_app_instance ?secondary_endpoint)
        (primary_endpoint_ready ?primary_endpoint)
        (secondary_endpoint_ready ?secondary_endpoint)
        (primary_instance_provisioned ?primary_app_instance)
        (secondary_instance_provisioned ?secondary_app_instance)
        (namespace_pending_provision ?database_namespace)
      )
    :effect
      (and
        (namespace_provisioned ?database_namespace)
        (database_namespace_assigned_primary_endpoint ?database_namespace ?primary_endpoint)
        (database_namespace_assigned_secondary_endpoint ?database_namespace ?secondary_endpoint)
        (not
          (namespace_pending_provision ?database_namespace)
        )
      )
  )
  (:action provision_namespace_primary_staged
    :parameters (?primary_app_instance - primary_app_instance ?secondary_app_instance - secondary_app_instance ?primary_endpoint - primary_endpoint ?secondary_endpoint - secondary_endpoint ?database_namespace - database_namespace)
    :precondition
      (and
        (primary_instance_orchestrated ?primary_app_instance)
        (secondary_instance_orchestrated ?secondary_app_instance)
        (primary_instance_assigned_endpoint ?primary_app_instance ?primary_endpoint)
        (secondary_instance_assigned_endpoint ?secondary_app_instance ?secondary_endpoint)
        (primary_endpoint_staged ?primary_endpoint)
        (secondary_endpoint_ready ?secondary_endpoint)
        (not
          (primary_instance_provisioned ?primary_app_instance)
        )
        (secondary_instance_provisioned ?secondary_app_instance)
        (namespace_pending_provision ?database_namespace)
      )
    :effect
      (and
        (namespace_provisioned ?database_namespace)
        (database_namespace_assigned_primary_endpoint ?database_namespace ?primary_endpoint)
        (database_namespace_assigned_secondary_endpoint ?database_namespace ?secondary_endpoint)
        (namespace_primary_endpoint_staged ?database_namespace)
        (not
          (namespace_pending_provision ?database_namespace)
        )
      )
  )
  (:action provision_namespace_secondary_staged
    :parameters (?primary_app_instance - primary_app_instance ?secondary_app_instance - secondary_app_instance ?primary_endpoint - primary_endpoint ?secondary_endpoint - secondary_endpoint ?database_namespace - database_namespace)
    :precondition
      (and
        (primary_instance_orchestrated ?primary_app_instance)
        (secondary_instance_orchestrated ?secondary_app_instance)
        (primary_instance_assigned_endpoint ?primary_app_instance ?primary_endpoint)
        (secondary_instance_assigned_endpoint ?secondary_app_instance ?secondary_endpoint)
        (primary_endpoint_ready ?primary_endpoint)
        (secondary_endpoint_staged ?secondary_endpoint)
        (primary_instance_provisioned ?primary_app_instance)
        (not
          (secondary_instance_provisioned ?secondary_app_instance)
        )
        (namespace_pending_provision ?database_namespace)
      )
    :effect
      (and
        (namespace_provisioned ?database_namespace)
        (database_namespace_assigned_primary_endpoint ?database_namespace ?primary_endpoint)
        (database_namespace_assigned_secondary_endpoint ?database_namespace ?secondary_endpoint)
        (namespace_secondary_endpoint_staged ?database_namespace)
        (not
          (namespace_pending_provision ?database_namespace)
        )
      )
  )
  (:action provision_namespace_both_endpoints_staged
    :parameters (?primary_app_instance - primary_app_instance ?secondary_app_instance - secondary_app_instance ?primary_endpoint - primary_endpoint ?secondary_endpoint - secondary_endpoint ?database_namespace - database_namespace)
    :precondition
      (and
        (primary_instance_orchestrated ?primary_app_instance)
        (secondary_instance_orchestrated ?secondary_app_instance)
        (primary_instance_assigned_endpoint ?primary_app_instance ?primary_endpoint)
        (secondary_instance_assigned_endpoint ?secondary_app_instance ?secondary_endpoint)
        (primary_endpoint_staged ?primary_endpoint)
        (secondary_endpoint_staged ?secondary_endpoint)
        (not
          (primary_instance_provisioned ?primary_app_instance)
        )
        (not
          (secondary_instance_provisioned ?secondary_app_instance)
        )
        (namespace_pending_provision ?database_namespace)
      )
    :effect
      (and
        (namespace_provisioned ?database_namespace)
        (database_namespace_assigned_primary_endpoint ?database_namespace ?primary_endpoint)
        (database_namespace_assigned_secondary_endpoint ?database_namespace ?secondary_endpoint)
        (namespace_primary_endpoint_staged ?database_namespace)
        (namespace_secondary_endpoint_staged ?database_namespace)
        (not
          (namespace_pending_provision ?database_namespace)
        )
      )
  )
  (:action prepare_namespace_for_schema_application
    :parameters (?database_namespace - database_namespace ?primary_app_instance - primary_app_instance ?connection_pool - connection_pool)
    :precondition
      (and
        (namespace_provisioned ?database_namespace)
        (primary_instance_orchestrated ?primary_app_instance)
        (component_assigned_connection_pool ?primary_app_instance ?connection_pool)
        (not
          (namespace_ready_for_schema ?database_namespace)
        )
      )
    :effect (namespace_ready_for_schema ?database_namespace)
  )
  (:action stage_schema_artifact_for_namespace
    :parameters (?integration_pipeline - integration_pipeline ?schema_artifact - schema_artifact ?database_namespace - database_namespace)
    :precondition
      (and
        (component_ready ?integration_pipeline)
        (pipeline_assigned_database_namespace ?integration_pipeline ?database_namespace)
        (pipeline_assigned_schema_artifact ?integration_pipeline ?schema_artifact)
        (schema_artifact_available ?schema_artifact)
        (namespace_provisioned ?database_namespace)
        (namespace_ready_for_schema ?database_namespace)
        (not
          (schema_artifact_staged ?schema_artifact)
        )
      )
    :effect
      (and
        (schema_artifact_staged ?schema_artifact)
        (schema_artifact_assigned_to_database_namespace ?schema_artifact ?database_namespace)
        (not
          (schema_artifact_available ?schema_artifact)
        )
      )
  )
  (:action commit_schema_artifact
    :parameters (?integration_pipeline - integration_pipeline ?schema_artifact - schema_artifact ?database_namespace - database_namespace ?connection_pool - connection_pool)
    :precondition
      (and
        (component_ready ?integration_pipeline)
        (pipeline_assigned_schema_artifact ?integration_pipeline ?schema_artifact)
        (schema_artifact_staged ?schema_artifact)
        (schema_artifact_assigned_to_database_namespace ?schema_artifact ?database_namespace)
        (component_assigned_connection_pool ?integration_pipeline ?connection_pool)
        (not
          (namespace_primary_endpoint_staged ?database_namespace)
        )
        (not
          (pipeline_schema_committed ?integration_pipeline)
        )
      )
    :effect (pipeline_schema_committed ?integration_pipeline)
  )
  (:action assign_feature_flag_to_pipeline
    :parameters (?integration_pipeline - integration_pipeline ?feature_flag - feature_flag)
    :precondition
      (and
        (component_ready ?integration_pipeline)
        (feature_flag_available ?feature_flag)
        (not
          (pipeline_has_feature_flag ?integration_pipeline)
        )
      )
    :effect
      (and
        (pipeline_has_feature_flag ?integration_pipeline)
        (pipeline_assigned_feature_flag ?integration_pipeline ?feature_flag)
        (not
          (feature_flag_available ?feature_flag)
        )
      )
  )
  (:action commit_schema_artifact_with_feature_flag
    :parameters (?integration_pipeline - integration_pipeline ?schema_artifact - schema_artifact ?database_namespace - database_namespace ?connection_pool - connection_pool ?feature_flag - feature_flag)
    :precondition
      (and
        (component_ready ?integration_pipeline)
        (pipeline_assigned_schema_artifact ?integration_pipeline ?schema_artifact)
        (schema_artifact_staged ?schema_artifact)
        (schema_artifact_assigned_to_database_namespace ?schema_artifact ?database_namespace)
        (component_assigned_connection_pool ?integration_pipeline ?connection_pool)
        (namespace_primary_endpoint_staged ?database_namespace)
        (pipeline_has_feature_flag ?integration_pipeline)
        (pipeline_assigned_feature_flag ?integration_pipeline ?feature_flag)
        (not
          (pipeline_schema_committed ?integration_pipeline)
        )
      )
    :effect
      (and
        (pipeline_schema_committed ?integration_pipeline)
        (pipeline_feature_flag_activated ?integration_pipeline)
      )
  )
  (:action start_indexing_on_pipeline_primary_path
    :parameters (?integration_pipeline - integration_pipeline ?index_directive - index_directive ?driver_binary - driver_binary ?schema_artifact - schema_artifact ?database_namespace - database_namespace)
    :precondition
      (and
        (pipeline_schema_committed ?integration_pipeline)
        (pipeline_assigned_index_directive ?integration_pipeline ?index_directive)
        (component_assigned_driver_binary ?integration_pipeline ?driver_binary)
        (pipeline_assigned_schema_artifact ?integration_pipeline ?schema_artifact)
        (schema_artifact_assigned_to_database_namespace ?schema_artifact ?database_namespace)
        (not
          (namespace_secondary_endpoint_staged ?database_namespace)
        )
        (not
          (pipeline_indexing_started ?integration_pipeline)
        )
      )
    :effect (pipeline_indexing_started ?integration_pipeline)
  )
  (:action start_indexing_on_pipeline_secondary_path
    :parameters (?integration_pipeline - integration_pipeline ?index_directive - index_directive ?driver_binary - driver_binary ?schema_artifact - schema_artifact ?database_namespace - database_namespace)
    :precondition
      (and
        (pipeline_schema_committed ?integration_pipeline)
        (pipeline_assigned_index_directive ?integration_pipeline ?index_directive)
        (component_assigned_driver_binary ?integration_pipeline ?driver_binary)
        (pipeline_assigned_schema_artifact ?integration_pipeline ?schema_artifact)
        (schema_artifact_assigned_to_database_namespace ?schema_artifact ?database_namespace)
        (namespace_secondary_endpoint_staged ?database_namespace)
        (not
          (pipeline_indexing_started ?integration_pipeline)
        )
      )
    :effect (pipeline_indexing_started ?integration_pipeline)
  )
  (:action complete_indexing_on_pipeline_no_namespace_flags
    :parameters (?integration_pipeline - integration_pipeline ?migration_plan - migration_plan ?schema_artifact - schema_artifact ?database_namespace - database_namespace)
    :precondition
      (and
        (pipeline_indexing_started ?integration_pipeline)
        (pipeline_assigned_migration_plan ?integration_pipeline ?migration_plan)
        (pipeline_assigned_schema_artifact ?integration_pipeline ?schema_artifact)
        (schema_artifact_assigned_to_database_namespace ?schema_artifact ?database_namespace)
        (not
          (namespace_primary_endpoint_staged ?database_namespace)
        )
        (not
          (namespace_secondary_endpoint_staged ?database_namespace)
        )
        (not
          (pipeline_indexing_completed ?integration_pipeline)
        )
      )
    :effect (pipeline_indexing_completed ?integration_pipeline)
  )
  (:action complete_indexing_on_pipeline_primary_flag
    :parameters (?integration_pipeline - integration_pipeline ?migration_plan - migration_plan ?schema_artifact - schema_artifact ?database_namespace - database_namespace)
    :precondition
      (and
        (pipeline_indexing_started ?integration_pipeline)
        (pipeline_assigned_migration_plan ?integration_pipeline ?migration_plan)
        (pipeline_assigned_schema_artifact ?integration_pipeline ?schema_artifact)
        (schema_artifact_assigned_to_database_namespace ?schema_artifact ?database_namespace)
        (namespace_primary_endpoint_staged ?database_namespace)
        (not
          (namespace_secondary_endpoint_staged ?database_namespace)
        )
        (not
          (pipeline_indexing_completed ?integration_pipeline)
        )
      )
    :effect
      (and
        (pipeline_indexing_completed ?integration_pipeline)
        (pipeline_ready_for_deployment_parameters ?integration_pipeline)
      )
  )
  (:action complete_indexing_on_pipeline_secondary_flag
    :parameters (?integration_pipeline - integration_pipeline ?migration_plan - migration_plan ?schema_artifact - schema_artifact ?database_namespace - database_namespace)
    :precondition
      (and
        (pipeline_indexing_started ?integration_pipeline)
        (pipeline_assigned_migration_plan ?integration_pipeline ?migration_plan)
        (pipeline_assigned_schema_artifact ?integration_pipeline ?schema_artifact)
        (schema_artifact_assigned_to_database_namespace ?schema_artifact ?database_namespace)
        (not
          (namespace_primary_endpoint_staged ?database_namespace)
        )
        (namespace_secondary_endpoint_staged ?database_namespace)
        (not
          (pipeline_indexing_completed ?integration_pipeline)
        )
      )
    :effect
      (and
        (pipeline_indexing_completed ?integration_pipeline)
        (pipeline_ready_for_deployment_parameters ?integration_pipeline)
      )
  )
  (:action complete_indexing_on_pipeline_both_flags
    :parameters (?integration_pipeline - integration_pipeline ?migration_plan - migration_plan ?schema_artifact - schema_artifact ?database_namespace - database_namespace)
    :precondition
      (and
        (pipeline_indexing_started ?integration_pipeline)
        (pipeline_assigned_migration_plan ?integration_pipeline ?migration_plan)
        (pipeline_assigned_schema_artifact ?integration_pipeline ?schema_artifact)
        (schema_artifact_assigned_to_database_namespace ?schema_artifact ?database_namespace)
        (namespace_primary_endpoint_staged ?database_namespace)
        (namespace_secondary_endpoint_staged ?database_namespace)
        (not
          (pipeline_indexing_completed ?integration_pipeline)
        )
      )
    :effect
      (and
        (pipeline_indexing_completed ?integration_pipeline)
        (pipeline_ready_for_deployment_parameters ?integration_pipeline)
      )
  )
  (:action activate_pipeline_without_deployment_params
    :parameters (?integration_pipeline - integration_pipeline)
    :precondition
      (and
        (pipeline_indexing_completed ?integration_pipeline)
        (not
          (pipeline_ready_for_deployment_parameters ?integration_pipeline)
        )
        (not
          (pipeline_activation_marked ?integration_pipeline)
        )
      )
    :effect
      (and
        (pipeline_activation_marked ?integration_pipeline)
        (component_active ?integration_pipeline)
      )
  )
  (:action assign_deployment_parameter_to_pipeline
    :parameters (?integration_pipeline - integration_pipeline ?deployment_parameter - deployment_parameter)
    :precondition
      (and
        (pipeline_indexing_completed ?integration_pipeline)
        (pipeline_ready_for_deployment_parameters ?integration_pipeline)
        (deployment_parameter_available ?deployment_parameter)
      )
    :effect
      (and
        (pipeline_assigned_deployment_parameter ?integration_pipeline ?deployment_parameter)
        (not
          (deployment_parameter_available ?deployment_parameter)
        )
      )
  )
  (:action execute_pipeline_deployment
    :parameters (?integration_pipeline - integration_pipeline ?primary_app_instance - primary_app_instance ?secondary_app_instance - secondary_app_instance ?connection_pool - connection_pool ?deployment_parameter - deployment_parameter)
    :precondition
      (and
        (pipeline_indexing_completed ?integration_pipeline)
        (pipeline_ready_for_deployment_parameters ?integration_pipeline)
        (pipeline_assigned_deployment_parameter ?integration_pipeline ?deployment_parameter)
        (pipeline_assigned_primary_instance ?integration_pipeline ?primary_app_instance)
        (pipeline_assigned_secondary_instance ?integration_pipeline ?secondary_app_instance)
        (primary_instance_provisioned ?primary_app_instance)
        (secondary_instance_provisioned ?secondary_app_instance)
        (component_assigned_connection_pool ?integration_pipeline ?connection_pool)
        (not
          (pipeline_deployment_executed ?integration_pipeline)
        )
      )
    :effect (pipeline_deployment_executed ?integration_pipeline)
  )
  (:action activate_pipeline_after_deployment
    :parameters (?integration_pipeline - integration_pipeline)
    :precondition
      (and
        (pipeline_indexing_completed ?integration_pipeline)
        (pipeline_deployment_executed ?integration_pipeline)
        (not
          (pipeline_activation_marked ?integration_pipeline)
        )
      )
    :effect
      (and
        (pipeline_activation_marked ?integration_pipeline)
        (component_active ?integration_pipeline)
      )
  )
  (:action attach_assigned_access_policy_to_pipeline
    :parameters (?integration_pipeline - integration_pipeline ?access_policy - access_policy ?connection_pool - connection_pool)
    :precondition
      (and
        (component_ready ?integration_pipeline)
        (component_assigned_connection_pool ?integration_pipeline ?connection_pool)
        (access_policy_available ?access_policy)
        (pipeline_assigned_access_policy ?integration_pipeline ?access_policy)
        (not
          (pipeline_has_access_policy ?integration_pipeline)
        )
      )
    :effect
      (and
        (pipeline_has_access_policy ?integration_pipeline)
        (not
          (access_policy_available ?access_policy)
        )
      )
  )
  (:action configure_pipeline_policy
    :parameters (?integration_pipeline - integration_pipeline ?driver_binary - driver_binary)
    :precondition
      (and
        (pipeline_has_access_policy ?integration_pipeline)
        (component_assigned_driver_binary ?integration_pipeline ?driver_binary)
        (not
          (pipeline_policy_configured ?integration_pipeline)
        )
      )
    :effect (pipeline_policy_configured ?integration_pipeline)
  )
  (:action activate_pipeline_policy
    :parameters (?integration_pipeline - integration_pipeline ?migration_plan - migration_plan)
    :precondition
      (and
        (pipeline_policy_configured ?integration_pipeline)
        (pipeline_assigned_migration_plan ?integration_pipeline ?migration_plan)
        (not
          (pipeline_policy_active ?integration_pipeline)
        )
      )
    :effect (pipeline_policy_active ?integration_pipeline)
  )
  (:action activate_pipeline_after_policy
    :parameters (?integration_pipeline - integration_pipeline)
    :precondition
      (and
        (pipeline_policy_active ?integration_pipeline)
        (not
          (pipeline_activation_marked ?integration_pipeline)
        )
      )
    :effect
      (and
        (pipeline_activation_marked ?integration_pipeline)
        (component_active ?integration_pipeline)
      )
  )
  (:action activate_primary_instance
    :parameters (?primary_app_instance - primary_app_instance ?database_namespace - database_namespace)
    :precondition
      (and
        (primary_instance_orchestrated ?primary_app_instance)
        (primary_instance_provisioned ?primary_app_instance)
        (namespace_provisioned ?database_namespace)
        (namespace_ready_for_schema ?database_namespace)
        (not
          (component_active ?primary_app_instance)
        )
      )
    :effect (component_active ?primary_app_instance)
  )
  (:action activate_secondary_instance
    :parameters (?secondary_app_instance - secondary_app_instance ?database_namespace - database_namespace)
    :precondition
      (and
        (secondary_instance_orchestrated ?secondary_app_instance)
        (secondary_instance_provisioned ?secondary_app_instance)
        (namespace_provisioned ?database_namespace)
        (namespace_ready_for_schema ?database_namespace)
        (not
          (component_active ?secondary_app_instance)
        )
      )
    :effect (component_active ?secondary_app_instance)
  )
  (:action propagate_deployment_to_component
    :parameters (?system_component - system_component ?observation_config - observation_config ?connection_pool - connection_pool)
    :precondition
      (and
        (component_active ?system_component)
        (component_assigned_connection_pool ?system_component ?connection_pool)
        (observation_config_available ?observation_config)
        (not
          (deployment_configured ?system_component)
        )
      )
    :effect
      (and
        (deployment_configured ?system_component)
        (component_has_observation_config ?system_component ?observation_config)
        (not
          (observation_config_available ?observation_config)
        )
      )
  )
  (:action deploy_primary_instance_and_release_credential
    :parameters (?primary_app_instance - primary_app_instance ?credential_token - credential_token ?observation_config - observation_config)
    :precondition
      (and
        (deployment_configured ?primary_app_instance)
        (component_assigned_credential_token ?primary_app_instance ?credential_token)
        (component_has_observation_config ?primary_app_instance ?observation_config)
        (not
          (component_deployed ?primary_app_instance)
        )
      )
    :effect
      (and
        (component_deployed ?primary_app_instance)
        (credential_available ?credential_token)
        (observation_config_available ?observation_config)
      )
  )
  (:action deploy_secondary_instance_and_release_credential
    :parameters (?secondary_app_instance - secondary_app_instance ?credential_token - credential_token ?observation_config - observation_config)
    :precondition
      (and
        (deployment_configured ?secondary_app_instance)
        (component_assigned_credential_token ?secondary_app_instance ?credential_token)
        (component_has_observation_config ?secondary_app_instance ?observation_config)
        (not
          (component_deployed ?secondary_app_instance)
        )
      )
    :effect
      (and
        (component_deployed ?secondary_app_instance)
        (credential_available ?credential_token)
        (observation_config_available ?observation_config)
      )
  )
  (:action deploy_pipeline_and_release_credential
    :parameters (?integration_pipeline - integration_pipeline ?credential_token - credential_token ?observation_config - observation_config)
    :precondition
      (and
        (deployment_configured ?integration_pipeline)
        (component_assigned_credential_token ?integration_pipeline ?credential_token)
        (component_has_observation_config ?integration_pipeline ?observation_config)
        (not
          (component_deployed ?integration_pipeline)
        )
      )
    :effect
      (and
        (component_deployed ?integration_pipeline)
        (credential_available ?credential_token)
        (observation_config_available ?observation_config)
      )
  )
)

(define (domain relational_database_integration)
  (:requirements :strips :typing :negative-preconditions)
  (:types runtime_artifact_type - object static_artifact_type - object network_resource_type - object application_service - object db_client - application_service credential - runtime_artifact_type query_template - runtime_artifact_type connector_adapter - runtime_artifact_type extension_plugin - runtime_artifact_type tuning_profile - runtime_artifact_type monitoring_probe - runtime_artifact_type secret_material - runtime_artifact_type backup_snapshot - runtime_artifact_type transient_artifact - static_artifact_type schema_object - static_artifact_type policy_record - static_artifact_type replica_target - network_resource_type shard - network_resource_type db_instance - network_resource_type connection_slot - db_client transaction_handle - db_client connection_endpoint - connection_slot executor_context - connection_slot orchestrator_component - transaction_handle)
  (:predicates
    (client_registered ?db_client - db_client)
    (entity_authorized ?db_client - db_client)
    (client_has_credential ?db_client - db_client)
    (resource_provisioned ?db_client - db_client)
    (resource_exposed ?db_client - db_client)
    (monitoring_enabled ?db_client - db_client)
    (credential_available ?credential - credential)
    (entity_credential_binding ?db_client - db_client ?credential - credential)
    (query_template_available ?query_template - query_template)
    (entity_prepared_statement ?db_client - db_client ?query_template - query_template)
    (connector_adapter_available ?connector_adapter - connector_adapter)
    (entity_connector_binding ?db_client - db_client ?connector_adapter - connector_adapter)
    (transient_artifact_available ?transient_artifact - transient_artifact)
    (connection_transient_artifact_attached ?connection_endpoint - connection_endpoint ?transient_artifact - transient_artifact)
    (executor_transient_artifact_attached ?executor_context - executor_context ?transient_artifact - transient_artifact)
    (connection_assigned_replica ?connection_endpoint - connection_endpoint ?replica_target - replica_target)
    (replica_ready ?replica_target - replica_target)
    (replica_reserved ?replica_target - replica_target)
    (connection_ready_for_session ?connection_endpoint - connection_endpoint)
    (executor_assigned_shard ?executor_context - executor_context ?shard - shard)
    (shard_ready ?shard - shard)
    (shard_reserved ?shard - shard)
    (executor_ready_for_session ?executor_context - executor_context)
    (db_instance_available ?db_instance - db_instance)
    (db_instance_allocated ?db_instance - db_instance)
    (instance_assigned_replica ?db_instance - db_instance ?replica_target - replica_target)
    (instance_assigned_shard ?db_instance - db_instance ?shard - shard)
    (instance_replica_ready_flag ?db_instance - db_instance)
    (instance_shard_ready_flag ?db_instance - db_instance)
    (instance_session_initialized ?db_instance - db_instance)
    (orchestrator_connection_association ?orchestrator - orchestrator_component ?connection_endpoint - connection_endpoint)
    (orchestrator_executor_association ?orchestrator - orchestrator_component ?executor_context - executor_context)
    (orchestrator_instance_association ?orchestrator - orchestrator_component ?db_instance - db_instance)
    (schema_object_available ?schema_object - schema_object)
    (orchestrator_has_schema_object ?orchestrator - orchestrator_component ?schema_object - schema_object)
    (schema_object_applied ?schema_object - schema_object)
    (schema_object_deployed_to_instance ?schema_object - schema_object ?db_instance - db_instance)
    (orchestrator_schema_confirmed ?orchestrator - orchestrator_component)
    (orchestrator_schema_activation_ready ?orchestrator - orchestrator_component)
    (orchestrator_capability_enabled ?orchestrator - orchestrator_component)
    (orchestrator_plugin_installed ?orchestrator - orchestrator_component)
    (orchestrator_extension_enrolled ?orchestrator - orchestrator_component)
    (orchestrator_tuning_profile_present ?orchestrator - orchestrator_component)
    (orchestrator_activated ?orchestrator - orchestrator_component)
    (policy_available ?policy_record - policy_record)
    (orchestrator_policy_bound ?orchestrator - orchestrator_component ?policy_record - policy_record)
    (orchestrator_policy_applied ?orchestrator - orchestrator_component)
    (orchestrator_connector_authorized ?orchestrator - orchestrator_component)
    (orchestrator_backup_bound ?orchestrator - orchestrator_component)
    (extension_plugin_available ?extension_plugin - extension_plugin)
    (orchestrator_extension_bound ?orchestrator - orchestrator_component ?extension_plugin - extension_plugin)
    (tuning_profile_available ?tuning_profile - tuning_profile)
    (orchestrator_tuning_profile_attached ?orchestrator - orchestrator_component ?tuning_profile - tuning_profile)
    (secret_available ?secret_material - secret_material)
    (orchestrator_secret_attached ?orchestrator - orchestrator_component ?secret_material - secret_material)
    (backup_available ?backup_snapshot - backup_snapshot)
    (orchestrator_backup_attached ?orchestrator - orchestrator_component ?backup_snapshot - backup_snapshot)
    (monitoring_probe_available ?monitoring_probe - monitoring_probe)
    (resource_monitoring_bound ?db_client - db_client ?monitoring_probe - monitoring_probe)
    (connection_health_checked ?connection_endpoint - connection_endpoint)
    (executor_health_checked ?executor_context - executor_context)
    (orchestrator_finalized ?orchestrator - orchestrator_component)
  )
  (:action register_db_client
    :parameters (?db_client - db_client)
    :precondition
      (and
        (not
          (client_registered ?db_client)
        )
        (not
          (resource_provisioned ?db_client)
        )
      )
    :effect (client_registered ?db_client)
  )
  (:action bind_credential_to_client
    :parameters (?db_client - db_client ?credential - credential)
    :precondition
      (and
        (client_registered ?db_client)
        (not
          (client_has_credential ?db_client)
        )
        (credential_available ?credential)
      )
    :effect
      (and
        (client_has_credential ?db_client)
        (entity_credential_binding ?db_client ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action attach_query_template_to_client
    :parameters (?db_client - db_client ?query_template - query_template)
    :precondition
      (and
        (client_registered ?db_client)
        (client_has_credential ?db_client)
        (query_template_available ?query_template)
      )
    :effect
      (and
        (entity_prepared_statement ?db_client ?query_template)
        (not
          (query_template_available ?query_template)
        )
      )
  )
  (:action authorize_db_client
    :parameters (?db_client - db_client ?query_template - query_template)
    :precondition
      (and
        (client_registered ?db_client)
        (client_has_credential ?db_client)
        (entity_prepared_statement ?db_client ?query_template)
        (not
          (entity_authorized ?db_client)
        )
      )
    :effect (entity_authorized ?db_client)
  )
  (:action detach_query_template_from_client
    :parameters (?db_client - db_client ?query_template - query_template)
    :precondition
      (and
        (entity_prepared_statement ?db_client ?query_template)
      )
    :effect
      (and
        (query_template_available ?query_template)
        (not
          (entity_prepared_statement ?db_client ?query_template)
        )
      )
  )
  (:action attach_connector_adapter_to_client
    :parameters (?db_client - db_client ?connector_adapter - connector_adapter)
    :precondition
      (and
        (entity_authorized ?db_client)
        (connector_adapter_available ?connector_adapter)
      )
    :effect
      (and
        (entity_connector_binding ?db_client ?connector_adapter)
        (not
          (connector_adapter_available ?connector_adapter)
        )
      )
  )
  (:action detach_connector_adapter_from_client
    :parameters (?db_client - db_client ?connector_adapter - connector_adapter)
    :precondition
      (and
        (entity_connector_binding ?db_client ?connector_adapter)
      )
    :effect
      (and
        (connector_adapter_available ?connector_adapter)
        (not
          (entity_connector_binding ?db_client ?connector_adapter)
        )
      )
  )
  (:action attach_secret_to_orchestrator
    :parameters (?orchestrator - orchestrator_component ?secret_material - secret_material)
    :precondition
      (and
        (entity_authorized ?orchestrator)
        (secret_available ?secret_material)
      )
    :effect
      (and
        (orchestrator_secret_attached ?orchestrator ?secret_material)
        (not
          (secret_available ?secret_material)
        )
      )
  )
  (:action detach_secret_from_orchestrator
    :parameters (?orchestrator - orchestrator_component ?secret_material - secret_material)
    :precondition
      (and
        (orchestrator_secret_attached ?orchestrator ?secret_material)
      )
    :effect
      (and
        (secret_available ?secret_material)
        (not
          (orchestrator_secret_attached ?orchestrator ?secret_material)
        )
      )
  )
  (:action attach_backup_to_orchestrator
    :parameters (?orchestrator - orchestrator_component ?backup_snapshot - backup_snapshot)
    :precondition
      (and
        (entity_authorized ?orchestrator)
        (backup_available ?backup_snapshot)
      )
    :effect
      (and
        (orchestrator_backup_attached ?orchestrator ?backup_snapshot)
        (not
          (backup_available ?backup_snapshot)
        )
      )
  )
  (:action detach_backup_from_orchestrator
    :parameters (?orchestrator - orchestrator_component ?backup_snapshot - backup_snapshot)
    :precondition
      (and
        (orchestrator_backup_attached ?orchestrator ?backup_snapshot)
      )
    :effect
      (and
        (backup_available ?backup_snapshot)
        (not
          (orchestrator_backup_attached ?orchestrator ?backup_snapshot)
        )
      )
  )
  (:action select_replica_for_connection
    :parameters (?connection_endpoint - connection_endpoint ?replica_target - replica_target ?query_template - query_template)
    :precondition
      (and
        (entity_authorized ?connection_endpoint)
        (entity_prepared_statement ?connection_endpoint ?query_template)
        (connection_assigned_replica ?connection_endpoint ?replica_target)
        (not
          (replica_ready ?replica_target)
        )
        (not
          (replica_reserved ?replica_target)
        )
      )
    :effect (replica_ready ?replica_target)
  )
  (:action reserve_connection_slot
    :parameters (?connection_endpoint - connection_endpoint ?replica_target - replica_target ?connector_adapter - connector_adapter)
    :precondition
      (and
        (entity_authorized ?connection_endpoint)
        (entity_connector_binding ?connection_endpoint ?connector_adapter)
        (connection_assigned_replica ?connection_endpoint ?replica_target)
        (replica_ready ?replica_target)
        (not
          (connection_health_checked ?connection_endpoint)
        )
      )
    :effect
      (and
        (connection_health_checked ?connection_endpoint)
        (connection_ready_for_session ?connection_endpoint)
      )
  )
  (:action attach_transient_artifact_to_connection
    :parameters (?connection_endpoint - connection_endpoint ?replica_target - replica_target ?transient_artifact - transient_artifact)
    :precondition
      (and
        (entity_authorized ?connection_endpoint)
        (connection_assigned_replica ?connection_endpoint ?replica_target)
        (transient_artifact_available ?transient_artifact)
        (not
          (connection_health_checked ?connection_endpoint)
        )
      )
    :effect
      (and
        (replica_reserved ?replica_target)
        (connection_health_checked ?connection_endpoint)
        (connection_transient_artifact_attached ?connection_endpoint ?transient_artifact)
        (not
          (transient_artifact_available ?transient_artifact)
        )
      )
  )
  (:action finalize_transient_artifact_on_connection
    :parameters (?connection_endpoint - connection_endpoint ?replica_target - replica_target ?query_template - query_template ?transient_artifact - transient_artifact)
    :precondition
      (and
        (entity_authorized ?connection_endpoint)
        (entity_prepared_statement ?connection_endpoint ?query_template)
        (connection_assigned_replica ?connection_endpoint ?replica_target)
        (replica_reserved ?replica_target)
        (connection_transient_artifact_attached ?connection_endpoint ?transient_artifact)
        (not
          (connection_ready_for_session ?connection_endpoint)
        )
      )
    :effect
      (and
        (replica_ready ?replica_target)
        (connection_ready_for_session ?connection_endpoint)
        (transient_artifact_available ?transient_artifact)
        (not
          (connection_transient_artifact_attached ?connection_endpoint ?transient_artifact)
        )
      )
  )
  (:action select_shard_for_executor
    :parameters (?executor_context - executor_context ?shard - shard ?query_template - query_template)
    :precondition
      (and
        (entity_authorized ?executor_context)
        (entity_prepared_statement ?executor_context ?query_template)
        (executor_assigned_shard ?executor_context ?shard)
        (not
          (shard_ready ?shard)
        )
        (not
          (shard_reserved ?shard)
        )
      )
    :effect (shard_ready ?shard)
  )
  (:action reserve_executor_context
    :parameters (?executor_context - executor_context ?shard - shard ?connector_adapter - connector_adapter)
    :precondition
      (and
        (entity_authorized ?executor_context)
        (entity_connector_binding ?executor_context ?connector_adapter)
        (executor_assigned_shard ?executor_context ?shard)
        (shard_ready ?shard)
        (not
          (executor_health_checked ?executor_context)
        )
      )
    :effect
      (and
        (executor_health_checked ?executor_context)
        (executor_ready_for_session ?executor_context)
      )
  )
  (:action attach_transient_artifact_to_executor
    :parameters (?executor_context - executor_context ?shard - shard ?transient_artifact - transient_artifact)
    :precondition
      (and
        (entity_authorized ?executor_context)
        (executor_assigned_shard ?executor_context ?shard)
        (transient_artifact_available ?transient_artifact)
        (not
          (executor_health_checked ?executor_context)
        )
      )
    :effect
      (and
        (shard_reserved ?shard)
        (executor_health_checked ?executor_context)
        (executor_transient_artifact_attached ?executor_context ?transient_artifact)
        (not
          (transient_artifact_available ?transient_artifact)
        )
      )
  )
  (:action finalize_transient_artifact_on_executor
    :parameters (?executor_context - executor_context ?shard - shard ?query_template - query_template ?transient_artifact - transient_artifact)
    :precondition
      (and
        (entity_authorized ?executor_context)
        (entity_prepared_statement ?executor_context ?query_template)
        (executor_assigned_shard ?executor_context ?shard)
        (shard_reserved ?shard)
        (executor_transient_artifact_attached ?executor_context ?transient_artifact)
        (not
          (executor_ready_for_session ?executor_context)
        )
      )
    :effect
      (and
        (shard_ready ?shard)
        (executor_ready_for_session ?executor_context)
        (transient_artifact_available ?transient_artifact)
        (not
          (executor_transient_artifact_attached ?executor_context ?transient_artifact)
        )
      )
  )
  (:action allocate_db_instance_for_session
    :parameters (?connection_endpoint - connection_endpoint ?executor_context - executor_context ?replica_target - replica_target ?shard - shard ?db_instance - db_instance)
    :precondition
      (and
        (connection_health_checked ?connection_endpoint)
        (executor_health_checked ?executor_context)
        (connection_assigned_replica ?connection_endpoint ?replica_target)
        (executor_assigned_shard ?executor_context ?shard)
        (replica_ready ?replica_target)
        (shard_ready ?shard)
        (connection_ready_for_session ?connection_endpoint)
        (executor_ready_for_session ?executor_context)
        (db_instance_available ?db_instance)
      )
    :effect
      (and
        (db_instance_allocated ?db_instance)
        (instance_assigned_replica ?db_instance ?replica_target)
        (instance_assigned_shard ?db_instance ?shard)
        (not
          (db_instance_available ?db_instance)
        )
      )
  )
  (:action allocate_db_instance_with_replica_ready
    :parameters (?connection_endpoint - connection_endpoint ?executor_context - executor_context ?replica_target - replica_target ?shard - shard ?db_instance - db_instance)
    :precondition
      (and
        (connection_health_checked ?connection_endpoint)
        (executor_health_checked ?executor_context)
        (connection_assigned_replica ?connection_endpoint ?replica_target)
        (executor_assigned_shard ?executor_context ?shard)
        (replica_reserved ?replica_target)
        (shard_ready ?shard)
        (not
          (connection_ready_for_session ?connection_endpoint)
        )
        (executor_ready_for_session ?executor_context)
        (db_instance_available ?db_instance)
      )
    :effect
      (and
        (db_instance_allocated ?db_instance)
        (instance_assigned_replica ?db_instance ?replica_target)
        (instance_assigned_shard ?db_instance ?shard)
        (instance_replica_ready_flag ?db_instance)
        (not
          (db_instance_available ?db_instance)
        )
      )
  )
  (:action allocate_db_instance_with_shard_ready
    :parameters (?connection_endpoint - connection_endpoint ?executor_context - executor_context ?replica_target - replica_target ?shard - shard ?db_instance - db_instance)
    :precondition
      (and
        (connection_health_checked ?connection_endpoint)
        (executor_health_checked ?executor_context)
        (connection_assigned_replica ?connection_endpoint ?replica_target)
        (executor_assigned_shard ?executor_context ?shard)
        (replica_ready ?replica_target)
        (shard_reserved ?shard)
        (connection_ready_for_session ?connection_endpoint)
        (not
          (executor_ready_for_session ?executor_context)
        )
        (db_instance_available ?db_instance)
      )
    :effect
      (and
        (db_instance_allocated ?db_instance)
        (instance_assigned_replica ?db_instance ?replica_target)
        (instance_assigned_shard ?db_instance ?shard)
        (instance_shard_ready_flag ?db_instance)
        (not
          (db_instance_available ?db_instance)
        )
      )
  )
  (:action allocate_db_instance_with_replica_and_shard_ready
    :parameters (?connection_endpoint - connection_endpoint ?executor_context - executor_context ?replica_target - replica_target ?shard - shard ?db_instance - db_instance)
    :precondition
      (and
        (connection_health_checked ?connection_endpoint)
        (executor_health_checked ?executor_context)
        (connection_assigned_replica ?connection_endpoint ?replica_target)
        (executor_assigned_shard ?executor_context ?shard)
        (replica_reserved ?replica_target)
        (shard_reserved ?shard)
        (not
          (connection_ready_for_session ?connection_endpoint)
        )
        (not
          (executor_ready_for_session ?executor_context)
        )
        (db_instance_available ?db_instance)
      )
    :effect
      (and
        (db_instance_allocated ?db_instance)
        (instance_assigned_replica ?db_instance ?replica_target)
        (instance_assigned_shard ?db_instance ?shard)
        (instance_replica_ready_flag ?db_instance)
        (instance_shard_ready_flag ?db_instance)
        (not
          (db_instance_available ?db_instance)
        )
      )
  )
  (:action initialize_instance_for_schema
    :parameters (?db_instance - db_instance ?connection_endpoint - connection_endpoint ?query_template - query_template)
    :precondition
      (and
        (db_instance_allocated ?db_instance)
        (connection_health_checked ?connection_endpoint)
        (entity_prepared_statement ?connection_endpoint ?query_template)
        (not
          (instance_session_initialized ?db_instance)
        )
      )
    :effect (instance_session_initialized ?db_instance)
  )
  (:action apply_schema_to_instance
    :parameters (?orchestrator - orchestrator_component ?schema_object - schema_object ?db_instance - db_instance)
    :precondition
      (and
        (entity_authorized ?orchestrator)
        (orchestrator_instance_association ?orchestrator ?db_instance)
        (orchestrator_has_schema_object ?orchestrator ?schema_object)
        (schema_object_available ?schema_object)
        (db_instance_allocated ?db_instance)
        (instance_session_initialized ?db_instance)
        (not
          (schema_object_applied ?schema_object)
        )
      )
    :effect
      (and
        (schema_object_applied ?schema_object)
        (schema_object_deployed_to_instance ?schema_object ?db_instance)
        (not
          (schema_object_available ?schema_object)
        )
      )
  )
  (:action confirm_schema_on_orchestrator
    :parameters (?orchestrator - orchestrator_component ?schema_object - schema_object ?db_instance - db_instance ?query_template - query_template)
    :precondition
      (and
        (entity_authorized ?orchestrator)
        (orchestrator_has_schema_object ?orchestrator ?schema_object)
        (schema_object_applied ?schema_object)
        (schema_object_deployed_to_instance ?schema_object ?db_instance)
        (entity_prepared_statement ?orchestrator ?query_template)
        (not
          (instance_replica_ready_flag ?db_instance)
        )
        (not
          (orchestrator_schema_confirmed ?orchestrator)
        )
      )
    :effect (orchestrator_schema_confirmed ?orchestrator)
  )
  (:action install_extension_on_orchestrator
    :parameters (?orchestrator - orchestrator_component ?extension_plugin - extension_plugin)
    :precondition
      (and
        (entity_authorized ?orchestrator)
        (extension_plugin_available ?extension_plugin)
        (not
          (orchestrator_plugin_installed ?orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_plugin_installed ?orchestrator)
        (orchestrator_extension_bound ?orchestrator ?extension_plugin)
        (not
          (extension_plugin_available ?extension_plugin)
        )
      )
  )
  (:action enroll_extension_and_enable_orchestrator
    :parameters (?orchestrator - orchestrator_component ?schema_object - schema_object ?db_instance - db_instance ?query_template - query_template ?extension_plugin - extension_plugin)
    :precondition
      (and
        (entity_authorized ?orchestrator)
        (orchestrator_has_schema_object ?orchestrator ?schema_object)
        (schema_object_applied ?schema_object)
        (schema_object_deployed_to_instance ?schema_object ?db_instance)
        (entity_prepared_statement ?orchestrator ?query_template)
        (instance_replica_ready_flag ?db_instance)
        (orchestrator_plugin_installed ?orchestrator)
        (orchestrator_extension_bound ?orchestrator ?extension_plugin)
        (not
          (orchestrator_schema_confirmed ?orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_schema_confirmed ?orchestrator)
        (orchestrator_extension_enrolled ?orchestrator)
      )
  )
  (:action enable_orchestrator_for_deployment_phase1
    :parameters (?orchestrator - orchestrator_component ?secret_material - secret_material ?connector_adapter - connector_adapter ?schema_object - schema_object ?db_instance - db_instance)
    :precondition
      (and
        (orchestrator_schema_confirmed ?orchestrator)
        (orchestrator_secret_attached ?orchestrator ?secret_material)
        (entity_connector_binding ?orchestrator ?connector_adapter)
        (orchestrator_has_schema_object ?orchestrator ?schema_object)
        (schema_object_deployed_to_instance ?schema_object ?db_instance)
        (not
          (instance_shard_ready_flag ?db_instance)
        )
        (not
          (orchestrator_schema_activation_ready ?orchestrator)
        )
      )
    :effect (orchestrator_schema_activation_ready ?orchestrator)
  )
  (:action enable_orchestrator_for_deployment_phase2
    :parameters (?orchestrator - orchestrator_component ?secret_material - secret_material ?connector_adapter - connector_adapter ?schema_object - schema_object ?db_instance - db_instance)
    :precondition
      (and
        (orchestrator_schema_confirmed ?orchestrator)
        (orchestrator_secret_attached ?orchestrator ?secret_material)
        (entity_connector_binding ?orchestrator ?connector_adapter)
        (orchestrator_has_schema_object ?orchestrator ?schema_object)
        (schema_object_deployed_to_instance ?schema_object ?db_instance)
        (instance_shard_ready_flag ?db_instance)
        (not
          (orchestrator_schema_activation_ready ?orchestrator)
        )
      )
    :effect (orchestrator_schema_activation_ready ?orchestrator)
  )
  (:action stage_capability_enablement
    :parameters (?orchestrator - orchestrator_component ?backup_snapshot - backup_snapshot ?schema_object - schema_object ?db_instance - db_instance)
    :precondition
      (and
        (orchestrator_schema_activation_ready ?orchestrator)
        (orchestrator_backup_attached ?orchestrator ?backup_snapshot)
        (orchestrator_has_schema_object ?orchestrator ?schema_object)
        (schema_object_deployed_to_instance ?schema_object ?db_instance)
        (not
          (instance_replica_ready_flag ?db_instance)
        )
        (not
          (instance_shard_ready_flag ?db_instance)
        )
        (not
          (orchestrator_capability_enabled ?orchestrator)
        )
      )
    :effect (orchestrator_capability_enabled ?orchestrator)
  )
  (:action enable_capability_and_attach_profile
    :parameters (?orchestrator - orchestrator_component ?backup_snapshot - backup_snapshot ?schema_object - schema_object ?db_instance - db_instance)
    :precondition
      (and
        (orchestrator_schema_activation_ready ?orchestrator)
        (orchestrator_backup_attached ?orchestrator ?backup_snapshot)
        (orchestrator_has_schema_object ?orchestrator ?schema_object)
        (schema_object_deployed_to_instance ?schema_object ?db_instance)
        (instance_replica_ready_flag ?db_instance)
        (not
          (instance_shard_ready_flag ?db_instance)
        )
        (not
          (orchestrator_capability_enabled ?orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_capability_enabled ?orchestrator)
        (orchestrator_tuning_profile_present ?orchestrator)
      )
  )
  (:action enable_capability_with_profile_variant
    :parameters (?orchestrator - orchestrator_component ?backup_snapshot - backup_snapshot ?schema_object - schema_object ?db_instance - db_instance)
    :precondition
      (and
        (orchestrator_schema_activation_ready ?orchestrator)
        (orchestrator_backup_attached ?orchestrator ?backup_snapshot)
        (orchestrator_has_schema_object ?orchestrator ?schema_object)
        (schema_object_deployed_to_instance ?schema_object ?db_instance)
        (not
          (instance_replica_ready_flag ?db_instance)
        )
        (instance_shard_ready_flag ?db_instance)
        (not
          (orchestrator_capability_enabled ?orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_capability_enabled ?orchestrator)
        (orchestrator_tuning_profile_present ?orchestrator)
      )
  )
  (:action confirm_capability_enrollment
    :parameters (?orchestrator - orchestrator_component ?backup_snapshot - backup_snapshot ?schema_object - schema_object ?db_instance - db_instance)
    :precondition
      (and
        (orchestrator_schema_activation_ready ?orchestrator)
        (orchestrator_backup_attached ?orchestrator ?backup_snapshot)
        (orchestrator_has_schema_object ?orchestrator ?schema_object)
        (schema_object_deployed_to_instance ?schema_object ?db_instance)
        (instance_replica_ready_flag ?db_instance)
        (instance_shard_ready_flag ?db_instance)
        (not
          (orchestrator_capability_enabled ?orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_capability_enabled ?orchestrator)
        (orchestrator_tuning_profile_present ?orchestrator)
      )
  )
  (:action finalize_orchestrator_readiness
    :parameters (?orchestrator - orchestrator_component)
    :precondition
      (and
        (orchestrator_capability_enabled ?orchestrator)
        (not
          (orchestrator_tuning_profile_present ?orchestrator)
        )
        (not
          (orchestrator_finalized ?orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_finalized ?orchestrator)
        (resource_exposed ?orchestrator)
      )
  )
  (:action attach_tuning_profile_to_orchestrator
    :parameters (?orchestrator - orchestrator_component ?tuning_profile - tuning_profile)
    :precondition
      (and
        (orchestrator_capability_enabled ?orchestrator)
        (orchestrator_tuning_profile_present ?orchestrator)
        (tuning_profile_available ?tuning_profile)
      )
    :effect
      (and
        (orchestrator_tuning_profile_attached ?orchestrator ?tuning_profile)
        (not
          (tuning_profile_available ?tuning_profile)
        )
      )
  )
  (:action activate_orchestrator_with_dependencies
    :parameters (?orchestrator - orchestrator_component ?connection_endpoint - connection_endpoint ?executor_context - executor_context ?query_template - query_template ?tuning_profile - tuning_profile)
    :precondition
      (and
        (orchestrator_capability_enabled ?orchestrator)
        (orchestrator_tuning_profile_present ?orchestrator)
        (orchestrator_tuning_profile_attached ?orchestrator ?tuning_profile)
        (orchestrator_connection_association ?orchestrator ?connection_endpoint)
        (orchestrator_executor_association ?orchestrator ?executor_context)
        (connection_ready_for_session ?connection_endpoint)
        (executor_ready_for_session ?executor_context)
        (entity_prepared_statement ?orchestrator ?query_template)
        (not
          (orchestrator_activated ?orchestrator)
        )
      )
    :effect (orchestrator_activated ?orchestrator)
  )
  (:action publish_orchestrator_service
    :parameters (?orchestrator - orchestrator_component)
    :precondition
      (and
        (orchestrator_capability_enabled ?orchestrator)
        (orchestrator_activated ?orchestrator)
        (not
          (orchestrator_finalized ?orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_finalized ?orchestrator)
        (resource_exposed ?orchestrator)
      )
  )
  (:action bind_policy_to_orchestrator
    :parameters (?orchestrator - orchestrator_component ?policy_record - policy_record ?query_template - query_template)
    :precondition
      (and
        (entity_authorized ?orchestrator)
        (entity_prepared_statement ?orchestrator ?query_template)
        (policy_available ?policy_record)
        (orchestrator_policy_bound ?orchestrator ?policy_record)
        (not
          (orchestrator_policy_applied ?orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_policy_applied ?orchestrator)
        (not
          (policy_available ?policy_record)
        )
      )
  )
  (:action authorize_orchestrator_connector
    :parameters (?orchestrator - orchestrator_component ?connector_adapter - connector_adapter)
    :precondition
      (and
        (orchestrator_policy_applied ?orchestrator)
        (entity_connector_binding ?orchestrator ?connector_adapter)
        (not
          (orchestrator_connector_authorized ?orchestrator)
        )
      )
    :effect (orchestrator_connector_authorized ?orchestrator)
  )
  (:action confirm_backup_binding_on_orchestrator
    :parameters (?orchestrator - orchestrator_component ?backup_snapshot - backup_snapshot)
    :precondition
      (and
        (orchestrator_connector_authorized ?orchestrator)
        (orchestrator_backup_attached ?orchestrator ?backup_snapshot)
        (not
          (orchestrator_backup_bound ?orchestrator)
        )
      )
    :effect (orchestrator_backup_bound ?orchestrator)
  )
  (:action finalize_policy_and_publish_orchestrator
    :parameters (?orchestrator - orchestrator_component)
    :precondition
      (and
        (orchestrator_backup_bound ?orchestrator)
        (not
          (orchestrator_finalized ?orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_finalized ?orchestrator)
        (resource_exposed ?orchestrator)
      )
  )
  (:action promote_connection_endpoint
    :parameters (?connection_endpoint - connection_endpoint ?db_instance - db_instance)
    :precondition
      (and
        (connection_health_checked ?connection_endpoint)
        (connection_ready_for_session ?connection_endpoint)
        (db_instance_allocated ?db_instance)
        (instance_session_initialized ?db_instance)
        (not
          (resource_exposed ?connection_endpoint)
        )
      )
    :effect (resource_exposed ?connection_endpoint)
  )
  (:action promote_executor_context
    :parameters (?executor_context - executor_context ?db_instance - db_instance)
    :precondition
      (and
        (executor_health_checked ?executor_context)
        (executor_ready_for_session ?executor_context)
        (db_instance_allocated ?db_instance)
        (instance_session_initialized ?db_instance)
        (not
          (resource_exposed ?executor_context)
        )
      )
    :effect (resource_exposed ?executor_context)
  )
  (:action enable_monitoring_for_client
    :parameters (?db_client - db_client ?monitoring_probe - monitoring_probe ?query_template - query_template)
    :precondition
      (and
        (resource_exposed ?db_client)
        (entity_prepared_statement ?db_client ?query_template)
        (monitoring_probe_available ?monitoring_probe)
        (not
          (monitoring_enabled ?db_client)
        )
      )
    :effect
      (and
        (monitoring_enabled ?db_client)
        (resource_monitoring_bound ?db_client ?monitoring_probe)
        (not
          (monitoring_probe_available ?monitoring_probe)
        )
      )
  )
  (:action provision_connection_endpoint
    :parameters (?connection_endpoint - connection_endpoint ?credential - credential ?monitoring_probe - monitoring_probe)
    :precondition
      (and
        (monitoring_enabled ?connection_endpoint)
        (entity_credential_binding ?connection_endpoint ?credential)
        (resource_monitoring_bound ?connection_endpoint ?monitoring_probe)
        (not
          (resource_provisioned ?connection_endpoint)
        )
      )
    :effect
      (and
        (resource_provisioned ?connection_endpoint)
        (credential_available ?credential)
        (monitoring_probe_available ?monitoring_probe)
      )
  )
  (:action provision_executor_context
    :parameters (?executor_context - executor_context ?credential - credential ?monitoring_probe - monitoring_probe)
    :precondition
      (and
        (monitoring_enabled ?executor_context)
        (entity_credential_binding ?executor_context ?credential)
        (resource_monitoring_bound ?executor_context ?monitoring_probe)
        (not
          (resource_provisioned ?executor_context)
        )
      )
    :effect
      (and
        (resource_provisioned ?executor_context)
        (credential_available ?credential)
        (monitoring_probe_available ?monitoring_probe)
      )
  )
  (:action provision_orchestrator_component
    :parameters (?orchestrator - orchestrator_component ?credential - credential ?monitoring_probe - monitoring_probe)
    :precondition
      (and
        (monitoring_enabled ?orchestrator)
        (entity_credential_binding ?orchestrator ?credential)
        (resource_monitoring_bound ?orchestrator ?monitoring_probe)
        (not
          (resource_provisioned ?orchestrator)
        )
      )
    :effect
      (and
        (resource_provisioned ?orchestrator)
        (credential_available ?credential)
        (monitoring_probe_available ?monitoring_probe)
      )
  )
)

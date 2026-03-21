(define (domain schema_migration_coordination_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types promotion_channel - object service_instance - object deployment_environment - object dependent_service - object pre_migration_check_tool - object post_migration_check_tool - object promotion_configuration - object verification_agent - object schema_version - object operator_credential - object backup_snapshot - object database_cluster - object channel_group - object canary_group - channel_group compliance_profile - channel_group channel_endpoint_primary - promotion_channel channel_endpoint_secondary - promotion_channel)
  (:predicates
    (verification_agent_available ?verification_agent - verification_agent)
    (channel_dependent_service_assigned ?promotion_channel - promotion_channel ?dependent_service - dependent_service)
    (channel_finalization_approved ?promotion_channel - promotion_channel)
    (channel_assigned_service ?promotion_channel - promotion_channel ?service_instance - service_instance)
    (channel_member_of_group ?promotion_channel - promotion_channel ?channel_group - channel_group)
    (postcheck_tool_available ?post_migration_check_tool - post_migration_check_tool)
    (dependent_service_available ?dependent_service - dependent_service)
    (channel_supports_database_cluster ?promotion_channel - promotion_channel ?database_cluster - database_cluster)
    (channel_finalized ?promotion_channel - promotion_channel)
    (is_primary_endpoint ?promotion_channel - promotion_channel)
    (channel_can_target_service ?promotion_channel - promotion_channel ?service_instance - service_instance)
    (environment_available ?deployment_environment - deployment_environment)
    (backup_snapshot_available ?backup_snapshot - backup_snapshot)
    (promotion_config_available ?promotion_configuration - promotion_configuration)
    (channel_deployment_committed ?promotion_channel - promotion_channel)
    (channel_supports_dependent_service ?promotion_channel - promotion_channel ?dependent_service - dependent_service)
    (channel_database_cluster_assigned ?promotion_channel - promotion_channel ?database_cluster - database_cluster)
    (channel_deployment_record ?promotion_channel - promotion_channel ?deployment_environment - deployment_environment)
    (channel_rollback_ready ?promotion_channel - promotion_channel)
    (channel_supports_postcheck_tool ?promotion_channel - promotion_channel ?post_migration_check_tool - post_migration_check_tool)
    (database_cluster_available ?database_cluster - database_cluster)
    (is_secondary_endpoint ?promotion_channel - promotion_channel)
    (channel_migration_staged ?promotion_channel - promotion_channel)
    (channel_supports_precheck_tool ?promotion_channel - promotion_channel ?pre_migration_check_tool - pre_migration_check_tool)
    (channel_precheck_tool_assigned ?promotion_channel - promotion_channel ?pre_migration_check_tool - pre_migration_check_tool)
    (channel_pending_environment_checks ?promotion_channel - promotion_channel)
    (channel_has_config ?promotion_channel - promotion_channel ?promotion_configuration - promotion_configuration)
    (channel_monitoring_scheduled ?promotion_channel - promotion_channel)
    (channel_supports_backup_snapshot ?promotion_channel - promotion_channel ?backup_snapshot - backup_snapshot)
    (channel_registered ?promotion_channel - promotion_channel)
    (service_available ?service_instance - service_instance)
    (channel_has_allocations ?promotion_channel - promotion_channel)
    (operator_credential_available ?operator_credential - operator_credential)
    (schema_version_available ?schema_version - schema_version)
    (channel_postcheck_tool_assigned ?promotion_channel - promotion_channel ?post_migration_check_tool - post_migration_check_tool)
    (endpoint_assigned_version ?promotion_channel - promotion_channel ?schema_version - schema_version)
    (channel_prepared ?promotion_channel - promotion_channel)
    (channel_version_staged ?promotion_channel - promotion_channel)
    (channel_version_link ?promotion_channel - promotion_channel ?schema_version - schema_version)
    (precheck_tool_available ?pre_migration_check_tool - pre_migration_check_tool)
    (channel_allowed_version ?promotion_channel - promotion_channel ?schema_version - schema_version)
    (channel_can_target_environment ?promotion_channel - promotion_channel ?deployment_environment - deployment_environment)
    (channel_verification_pending ?promotion_channel - promotion_channel)
    (channel_staged_version ?promotion_channel - promotion_channel ?schema_version - schema_version)
  )
  (:action release_database_cluster_from_channel
    :parameters (?promotion_channel - promotion_channel ?database_cluster - database_cluster)
    :precondition
      (and
        (channel_database_cluster_assigned ?promotion_channel ?database_cluster)
      )
    :effect
      (and
        (database_cluster_available ?database_cluster)
        (not
          (channel_database_cluster_assigned ?promotion_channel ?database_cluster)
        )
      )
  )
  (:action approve_rollback_with_compliance_profile
    :parameters (?promotion_channel - promotion_channel ?post_migration_check_tool - post_migration_check_tool ?database_cluster - database_cluster ?compliance_profile - compliance_profile)
    :precondition
      (and
        (not
          (channel_rollback_ready ?promotion_channel)
        )
        (channel_deployment_committed ?promotion_channel)
        (channel_migration_staged ?promotion_channel)
        (channel_database_cluster_assigned ?promotion_channel ?database_cluster)
        (channel_member_of_group ?promotion_channel ?compliance_profile)
        (channel_postcheck_tool_assigned ?promotion_channel ?post_migration_check_tool)
      )
    :effect
      (and
        (channel_verification_pending ?promotion_channel)
        (channel_rollback_ready ?promotion_channel)
      )
  )
  (:action finalize_channel_with_primary_endpoint
    :parameters (?promotion_channel - promotion_channel)
    :precondition
      (and
        (channel_migration_staged ?promotion_channel)
        (channel_has_allocations ?promotion_channel)
        (channel_deployment_committed ?promotion_channel)
        (channel_registered ?promotion_channel)
        (channel_version_staged ?promotion_channel)
        (not
          (channel_finalized ?promotion_channel)
        )
        (is_primary_endpoint ?promotion_channel)
        (channel_rollback_ready ?promotion_channel)
      )
    :effect
      (and
        (channel_finalized ?promotion_channel)
      )
  )
  (:action finalize_environment_checks
    :parameters (?promotion_channel - promotion_channel ?pre_migration_check_tool - pre_migration_check_tool ?dependent_service - dependent_service)
    :precondition
      (and
        (channel_deployment_committed ?promotion_channel)
        (channel_pending_environment_checks ?promotion_channel)
        (channel_precheck_tool_assigned ?promotion_channel ?pre_migration_check_tool)
        (channel_dependent_service_assigned ?promotion_channel ?dependent_service)
      )
    :effect
      (and
        (not
          (channel_pending_environment_checks ?promotion_channel)
        )
        (not
          (channel_verification_pending ?promotion_channel)
        )
      )
  )
  (:action bind_promotion_config
    :parameters (?promotion_channel - promotion_channel ?promotion_configuration - promotion_configuration)
    :precondition
      (and
        (promotion_config_available ?promotion_configuration)
        (channel_registered ?promotion_channel)
      )
    :effect
      (and
        (not
          (promotion_config_available ?promotion_configuration)
        )
        (channel_has_config ?promotion_channel ?promotion_configuration)
      )
  )
  (:action approve_rollback_plan
    :parameters (?promotion_channel - promotion_channel ?pre_migration_check_tool - pre_migration_check_tool ?dependent_service - dependent_service ?canary_group - canary_group)
    :precondition
      (and
        (channel_member_of_group ?promotion_channel ?canary_group)
        (channel_migration_staged ?promotion_channel)
        (not
          (channel_verification_pending ?promotion_channel)
        )
        (channel_precheck_tool_assigned ?promotion_channel ?pre_migration_check_tool)
        (channel_deployment_committed ?promotion_channel)
        (channel_dependent_service_assigned ?promotion_channel ?dependent_service)
        (not
          (channel_rollback_ready ?promotion_channel)
        )
      )
    :effect
      (and
        (channel_rollback_ready ?promotion_channel)
      )
  )
  (:action stage_migration_for_version
    :parameters (?promotion_channel - promotion_channel ?schema_version - schema_version)
    :precondition
      (and
        (channel_has_allocations ?promotion_channel)
        (channel_staged_version ?promotion_channel ?schema_version)
        (not
          (channel_migration_staged ?promotion_channel)
        )
      )
    :effect
      (and
        (channel_migration_staged ?promotion_channel)
        (not
          (channel_verification_pending ?promotion_channel)
        )
      )
  )
  (:action assign_postcheck_tool_to_channel
    :parameters (?promotion_channel - promotion_channel ?post_migration_check_tool - post_migration_check_tool)
    :precondition
      (and
        (channel_supports_postcheck_tool ?promotion_channel ?post_migration_check_tool)
        (channel_registered ?promotion_channel)
        (postcheck_tool_available ?post_migration_check_tool)
      )
    :effect
      (and
        (channel_postcheck_tool_assigned ?promotion_channel ?post_migration_check_tool)
        (not
          (postcheck_tool_available ?post_migration_check_tool)
        )
      )
  )
  (:action assign_precheck_tool_to_channel
    :parameters (?promotion_channel - promotion_channel ?pre_migration_check_tool - pre_migration_check_tool)
    :precondition
      (and
        (channel_registered ?promotion_channel)
        (precheck_tool_available ?pre_migration_check_tool)
        (channel_supports_precheck_tool ?promotion_channel ?pre_migration_check_tool)
      )
    :effect
      (and
        (not
          (precheck_tool_available ?pre_migration_check_tool)
        )
        (channel_precheck_tool_assigned ?promotion_channel ?pre_migration_check_tool)
      )
  )
  (:action release_postcheck_tool_from_channel
    :parameters (?promotion_channel - promotion_channel ?post_migration_check_tool - post_migration_check_tool)
    :precondition
      (and
        (channel_postcheck_tool_assigned ?promotion_channel ?post_migration_check_tool)
      )
    :effect
      (and
        (postcheck_tool_available ?post_migration_check_tool)
        (not
          (channel_postcheck_tool_assigned ?promotion_channel ?post_migration_check_tool)
        )
      )
  )
  (:action release_dependent_service_from_channel
    :parameters (?promotion_channel - promotion_channel ?dependent_service - dependent_service)
    :precondition
      (and
        (channel_dependent_service_assigned ?promotion_channel ?dependent_service)
      )
    :effect
      (and
        (dependent_service_available ?dependent_service)
        (not
          (channel_dependent_service_assigned ?promotion_channel ?dependent_service)
        )
      )
  )
  (:action assign_version_to_endpoint
    :parameters (?promotion_channel - promotion_channel ?schema_version - schema_version)
    :precondition
      (and
        (channel_version_staged ?promotion_channel)
        (schema_version_available ?schema_version)
        (channel_version_link ?promotion_channel ?schema_version)
      )
    :effect
      (and
        (endpoint_assigned_version ?promotion_channel ?schema_version)
        (not
          (schema_version_available ?schema_version)
        )
      )
  )
  (:action assign_dependent_service_to_channel
    :parameters (?promotion_channel - promotion_channel ?dependent_service - dependent_service)
    :precondition
      (and
        (channel_registered ?promotion_channel)
        (dependent_service_available ?dependent_service)
        (channel_supports_dependent_service ?promotion_channel ?dependent_service)
      )
    :effect
      (and
        (channel_dependent_service_assigned ?promotion_channel ?dependent_service)
        (not
          (dependent_service_available ?dependent_service)
        )
      )
  )
  (:action execute_environment_deployment
    :parameters (?promotion_channel - promotion_channel ?deployment_environment - deployment_environment ?pre_migration_check_tool - pre_migration_check_tool ?dependent_service - dependent_service)
    :precondition
      (and
        (channel_has_allocations ?promotion_channel)
        (environment_available ?deployment_environment)
        (channel_can_target_environment ?promotion_channel ?deployment_environment)
        (not
          (channel_deployment_committed ?promotion_channel)
        )
        (channel_dependent_service_assigned ?promotion_channel ?dependent_service)
        (channel_precheck_tool_assigned ?promotion_channel ?pre_migration_check_tool)
      )
    :effect
      (and
        (channel_deployment_record ?promotion_channel ?deployment_environment)
        (not
          (environment_available ?deployment_environment)
        )
        (channel_deployment_committed ?promotion_channel)
      )
  )
  (:action approve_finalization
    :parameters (?promotion_channel - promotion_channel ?pre_migration_check_tool - pre_migration_check_tool ?dependent_service - dependent_service)
    :precondition
      (and
        (channel_precheck_tool_assigned ?promotion_channel ?pre_migration_check_tool)
        (channel_rollback_ready ?promotion_channel)
        (channel_dependent_service_assigned ?promotion_channel ?dependent_service)
        (channel_verification_pending ?promotion_channel)
      )
    :effect
      (and
        (not
          (channel_pending_environment_checks ?promotion_channel)
        )
        (not
          (channel_verification_pending ?promotion_channel)
        )
        (not
          (channel_migration_staged ?promotion_channel)
        )
        (channel_finalization_approved ?promotion_channel)
      )
  )
  (:action unbind_promotion_config
    :parameters (?promotion_channel - promotion_channel ?promotion_configuration - promotion_configuration)
    :precondition
      (and
        (channel_has_config ?promotion_channel ?promotion_configuration)
      )
    :effect
      (and
        (promotion_config_available ?promotion_configuration)
        (not
          (channel_has_config ?promotion_channel ?promotion_configuration)
        )
      )
  )
  (:action operator_stage_migration
    :parameters (?promotion_channel - promotion_channel ?promotion_configuration - promotion_configuration ?operator_credential - operator_credential)
    :precondition
      (and
        (not
          (channel_migration_staged ?promotion_channel)
        )
        (channel_has_allocations ?promotion_channel)
        (operator_credential_available ?operator_credential)
        (channel_has_config ?promotion_channel ?promotion_configuration)
        (channel_prepared ?promotion_channel)
      )
    :effect
      (and
        (not
          (channel_verification_pending ?promotion_channel)
        )
        (channel_migration_staged ?promotion_channel)
      )
  )
  (:action finalize_channel_with_monitoring
    :parameters (?promotion_channel - promotion_channel)
    :precondition
      (and
        (channel_registered ?promotion_channel)
        (is_secondary_endpoint ?promotion_channel)
        (channel_monitoring_scheduled ?promotion_channel)
        (channel_has_allocations ?promotion_channel)
        (channel_migration_staged ?promotion_channel)
        (not
          (channel_finalized ?promotion_channel)
        )
        (channel_version_staged ?promotion_channel)
        (channel_deployment_committed ?promotion_channel)
        (channel_rollback_ready ?promotion_channel)
      )
    :effect
      (and
        (channel_finalized ?promotion_channel)
      )
  )
  (:action schedule_channel_monitoring
    :parameters (?promotion_channel - promotion_channel ?promotion_configuration - promotion_configuration ?operator_credential - operator_credential)
    :precondition
      (and
        (channel_migration_staged ?promotion_channel)
        (operator_credential_available ?operator_credential)
        (not
          (channel_monitoring_scheduled ?promotion_channel)
        )
        (channel_version_staged ?promotion_channel)
        (channel_registered ?promotion_channel)
        (is_secondary_endpoint ?promotion_channel)
        (channel_has_config ?promotion_channel ?promotion_configuration)
      )
    :effect
      (and
        (channel_monitoring_scheduled ?promotion_channel)
      )
  )
  (:action release_precheck_tool_from_channel
    :parameters (?promotion_channel - promotion_channel ?pre_migration_check_tool - pre_migration_check_tool)
    :precondition
      (and
        (channel_precheck_tool_assigned ?promotion_channel ?pre_migration_check_tool)
      )
    :effect
      (and
        (precheck_tool_available ?pre_migration_check_tool)
        (not
          (channel_precheck_tool_assigned ?promotion_channel ?pre_migration_check_tool)
        )
      )
  )
  (:action assign_database_cluster_to_channel
    :parameters (?promotion_channel - promotion_channel ?database_cluster - database_cluster)
    :precondition
      (and
        (database_cluster_available ?database_cluster)
        (channel_registered ?promotion_channel)
        (channel_supports_database_cluster ?promotion_channel ?database_cluster)
      )
    :effect
      (and
        (channel_database_cluster_assigned ?promotion_channel ?database_cluster)
        (not
          (database_cluster_available ?database_cluster)
        )
      )
  )
  (:action register_channel
    :parameters (?promotion_channel - promotion_channel)
    :precondition
      (and
        (not
          (channel_registered ?promotion_channel)
        )
        (not
          (channel_finalized ?promotion_channel)
        )
      )
    :effect
      (and
        (channel_registered ?promotion_channel)
      )
  )
  (:action attach_verification_agent
    :parameters (?promotion_channel - promotion_channel ?verification_agent - verification_agent)
    :precondition
      (and
        (not
          (channel_prepared ?promotion_channel)
        )
        (channel_registered ?promotion_channel)
        (verification_agent_available ?verification_agent)
        (channel_has_allocations ?promotion_channel)
      )
    :effect
      (and
        (channel_verification_pending ?promotion_channel)
        (not
          (verification_agent_available ?verification_agent)
        )
        (channel_prepared ?promotion_channel)
      )
  )
  (:action execute_environment_deployment_with_backup
    :parameters (?promotion_channel - promotion_channel ?deployment_environment - deployment_environment ?post_migration_check_tool - post_migration_check_tool ?backup_snapshot - backup_snapshot)
    :precondition
      (and
        (backup_snapshot_available ?backup_snapshot)
        (channel_supports_backup_snapshot ?promotion_channel ?backup_snapshot)
        (not
          (channel_deployment_committed ?promotion_channel)
        )
        (channel_has_allocations ?promotion_channel)
        (environment_available ?deployment_environment)
        (channel_can_target_environment ?promotion_channel ?deployment_environment)
        (channel_postcheck_tool_assigned ?promotion_channel ?post_migration_check_tool)
      )
    :effect
      (and
        (channel_deployment_record ?promotion_channel ?deployment_environment)
        (not
          (backup_snapshot_available ?backup_snapshot)
        )
        (channel_pending_environment_checks ?promotion_channel)
        (not
          (environment_available ?deployment_environment)
        )
        (channel_verification_pending ?promotion_channel)
        (channel_deployment_committed ?promotion_channel)
      )
  )
  (:action prepare_channel_version_staging_with_agent
    :parameters (?promotion_channel - promotion_channel ?verification_agent - verification_agent)
    :precondition
      (and
        (verification_agent_available ?verification_agent)
        (not
          (channel_verification_pending ?promotion_channel)
        )
        (channel_migration_staged ?promotion_channel)
        (channel_rollback_ready ?promotion_channel)
        (not
          (channel_version_staged ?promotion_channel)
        )
      )
    :effect
      (and
        (channel_version_staged ?promotion_channel)
        (not
          (verification_agent_available ?verification_agent)
        )
      )
  )
  (:action unassign_service_from_channel
    :parameters (?promotion_channel - promotion_channel ?service_instance - service_instance)
    :precondition
      (and
        (channel_assigned_service ?promotion_channel ?service_instance)
        (not
          (channel_rollback_ready ?promotion_channel)
        )
        (not
          (channel_deployment_committed ?promotion_channel)
        )
      )
    :effect
      (and
        (not
          (channel_assigned_service ?promotion_channel ?service_instance)
        )
        (service_available ?service_instance)
        (not
          (channel_has_allocations ?promotion_channel)
        )
        (not
          (channel_prepared ?promotion_channel)
        )
        (not
          (channel_finalization_approved ?promotion_channel)
        )
        (not
          (channel_migration_staged ?promotion_channel)
        )
        (not
          (channel_pending_environment_checks ?promotion_channel)
        )
        (not
          (channel_verification_pending ?promotion_channel)
        )
      )
  )
  (:action prepare_channel_version_staging
    :parameters (?promotion_channel - promotion_channel ?promotion_configuration - promotion_configuration)
    :precondition
      (and
        (not
          (channel_version_staged ?promotion_channel)
        )
        (channel_has_config ?promotion_channel ?promotion_configuration)
        (channel_migration_staged ?promotion_channel)
        (channel_rollback_ready ?promotion_channel)
        (not
          (channel_verification_pending ?promotion_channel)
        )
      )
    :effect
      (and
        (channel_version_staged ?promotion_channel)
      )
  )
  (:action finalize_channel_with_version
    :parameters (?promotion_channel - promotion_channel ?schema_version - schema_version)
    :precondition
      (and
        (channel_version_staged ?promotion_channel)
        (channel_rollback_ready ?promotion_channel)
        (channel_deployment_committed ?promotion_channel)
        (channel_staged_version ?promotion_channel ?schema_version)
        (channel_migration_staged ?promotion_channel)
        (channel_has_allocations ?promotion_channel)
        (channel_registered ?promotion_channel)
        (not
          (channel_finalized ?promotion_channel)
        )
        (is_secondary_endpoint ?promotion_channel)
      )
    :effect
      (and
        (channel_finalized ?promotion_channel)
      )
  )
  (:action activate_promotion_configuration
    :parameters (?promotion_channel - promotion_channel ?promotion_configuration - promotion_configuration)
    :precondition
      (and
        (channel_registered ?promotion_channel)
        (channel_has_allocations ?promotion_channel)
        (not
          (channel_prepared ?promotion_channel)
        )
        (channel_has_config ?promotion_channel ?promotion_configuration)
      )
    :effect
      (and
        (channel_prepared ?promotion_channel)
      )
  )
  (:action assign_service_to_channel
    :parameters (?promotion_channel - promotion_channel ?service_instance - service_instance)
    :precondition
      (and
        (not
          (channel_has_allocations ?promotion_channel)
        )
        (channel_registered ?promotion_channel)
        (service_available ?service_instance)
        (channel_can_target_service ?promotion_channel ?service_instance)
      )
    :effect
      (and
        (channel_has_allocations ?promotion_channel)
        (not
          (service_available ?service_instance)
        )
        (channel_assigned_service ?promotion_channel ?service_instance)
      )
  )
  (:action apply_operator_credentials_for_preparation
    :parameters (?promotion_channel - promotion_channel ?promotion_configuration - promotion_configuration ?operator_credential - operator_credential)
    :precondition
      (and
        (channel_has_allocations ?promotion_channel)
        (not
          (channel_migration_staged ?promotion_channel)
        )
        (channel_has_config ?promotion_channel ?promotion_configuration)
        (channel_rollback_ready ?promotion_channel)
        (operator_credential_available ?operator_credential)
        (channel_finalization_approved ?promotion_channel)
      )
    :effect
      (and
        (channel_migration_staged ?promotion_channel)
      )
  )
  (:action stage_schema_version_for_channel
    :parameters (?channel_endpoint_secondary - channel_endpoint_secondary ?channel_endpoint_primary - channel_endpoint_primary ?schema_version - schema_version)
    :precondition
      (and
        (channel_registered ?channel_endpoint_secondary)
        (endpoint_assigned_version ?channel_endpoint_primary ?schema_version)
        (is_secondary_endpoint ?channel_endpoint_secondary)
        (not
          (channel_staged_version ?channel_endpoint_secondary ?schema_version)
        )
        (channel_allowed_version ?channel_endpoint_secondary ?schema_version)
      )
    :effect
      (and
        (channel_staged_version ?channel_endpoint_secondary ?schema_version)
      )
  )
)

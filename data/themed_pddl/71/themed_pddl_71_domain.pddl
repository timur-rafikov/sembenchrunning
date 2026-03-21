(define (domain blue_green_cutover_checkpointing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types cutover_checkpoint - base_object deployment_slot - base_object verification_suite - base_object configuration_item - base_object dependent_service - base_object external_dependency - base_object network_endpoint - base_object runbook - base_object traffic_policy - base_object automation_script - base_object backup_snapshot - base_object canary_profile - base_object operator_group - base_object approval_gate - operator_group operator_group_token - operator_group primary_cutover - cutover_checkpoint secondary_cutover - cutover_checkpoint)
  (:predicates
    (runbook_available ?runbook - runbook)
    (checkpoint_binds_config_item ?checkpoint - cutover_checkpoint ?configuration_item - configuration_item)
    (staged_for_promotion ?checkpoint - cutover_checkpoint)
    (checkpoint_allocated_slot ?checkpoint - cutover_checkpoint ?deployment_slot - deployment_slot)
    (checkpoint_operator_group_binding ?checkpoint - cutover_checkpoint ?operator_group - operator_group)
    (external_dependency_available ?external_dependency - external_dependency)
    (config_item_available ?configuration_item - configuration_item)
    (checkpoint_canary_candidate ?checkpoint - cutover_checkpoint ?canary_profile - canary_profile)
    (checkpoint_finalized ?checkpoint - cutover_checkpoint)
    (checkpoint_primary_role ?checkpoint - cutover_checkpoint)
    (checkpoint_slot_candidate ?checkpoint - cutover_checkpoint ?deployment_slot - deployment_slot)
    (verification_available ?verification_suite - verification_suite)
    (backup_snapshot_available ?backup_snapshot - backup_snapshot)
    (network_endpoint_available ?network_endpoint - network_endpoint)
    (verification_completed ?checkpoint - cutover_checkpoint)
    (checkpoint_config_item_candidate ?checkpoint - cutover_checkpoint ?configuration_item - configuration_item)
    (checkpoint_binds_canary_profile ?checkpoint - cutover_checkpoint ?canary_profile - canary_profile)
    (checkpoint_executed_verification ?checkpoint - cutover_checkpoint ?verification_suite - verification_suite)
    (validation_gate_passed ?checkpoint - cutover_checkpoint)
    (checkpoint_external_dependency_candidate ?checkpoint - cutover_checkpoint ?external_dependency - external_dependency)
    (canary_profile_available ?canary_profile - canary_profile)
    (checkpoint_secondary_role ?checkpoint - cutover_checkpoint)
    (artifacts_staged ?checkpoint - cutover_checkpoint)
    (checkpoint_dependent_service_candidate ?checkpoint - cutover_checkpoint ?dependent_service - dependent_service)
    (checkpoint_binds_dependent_service ?checkpoint - cutover_checkpoint ?dependent_service - dependent_service)
    (backup_consumed ?checkpoint - cutover_checkpoint)
    (checkpoint_endpoint_binding ?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint)
    (staged_audit_marked ?checkpoint - cutover_checkpoint)
    (checkpoint_snapshot_candidate ?checkpoint - cutover_checkpoint ?backup_snapshot - backup_snapshot)
    (checkpoint_registered ?checkpoint - cutover_checkpoint)
    (slot_available ?deployment_slot - deployment_slot)
    (checkpoint_has_allocation ?checkpoint - cutover_checkpoint)
    (automation_script_available ?automation_script - automation_script)
    (traffic_policy_available ?traffic_policy - traffic_policy)
    (checkpoint_binds_external_dependency ?checkpoint - cutover_checkpoint ?external_dependency - external_dependency)
    (checkpoint_primary_policy_assigned ?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
    (operator_approval_recorded ?checkpoint - cutover_checkpoint)
    (readiness_marked ?checkpoint - cutover_checkpoint)
    (checkpoint_policy_candidate_binding ?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
    (dependent_service_available ?dependent_service - dependent_service)
    (checkpoint_secondary_policy_assigned ?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
    (checkpoint_verification_candidate ?checkpoint - cutover_checkpoint ?verification_suite - verification_suite)
    (approval_claimed ?checkpoint - cutover_checkpoint)
    (checkpoint_policy_applied ?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
  )
  (:action unregister_canary_profile
    :parameters (?checkpoint - cutover_checkpoint ?canary_profile - canary_profile)
    :precondition
      (and
        (checkpoint_binds_canary_profile ?checkpoint ?canary_profile)
      )
    :effect
      (and
        (canary_profile_available ?canary_profile)
        (not
          (checkpoint_binds_canary_profile ?checkpoint ?canary_profile)
        )
      )
  )
  (:action mark_validation_ready_with_canary
    :parameters (?checkpoint - cutover_checkpoint ?external_dependency - external_dependency ?canary_profile - canary_profile ?audit_token - operator_group_token)
    :precondition
      (and
        (not
          (validation_gate_passed ?checkpoint)
        )
        (verification_completed ?checkpoint)
        (artifacts_staged ?checkpoint)
        (checkpoint_binds_canary_profile ?checkpoint ?canary_profile)
        (checkpoint_operator_group_binding ?checkpoint ?audit_token)
        (checkpoint_binds_external_dependency ?checkpoint ?external_dependency)
      )
    :effect
      (and
        (approval_claimed ?checkpoint)
        (validation_gate_passed ?checkpoint)
      )
  )
  (:action finalize_checkpoint_state
    :parameters (?checkpoint - cutover_checkpoint)
    :precondition
      (and
        (artifacts_staged ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (verification_completed ?checkpoint)
        (checkpoint_registered ?checkpoint)
        (readiness_marked ?checkpoint)
        (not
          (checkpoint_finalized ?checkpoint)
        )
        (checkpoint_primary_role ?checkpoint)
        (validation_gate_passed ?checkpoint)
      )
    :effect
      (and
        (checkpoint_finalized ?checkpoint)
      )
  )
  (:action finalize_validation_gate
    :parameters (?checkpoint - cutover_checkpoint ?dependent_service - dependent_service ?configuration_item - configuration_item)
    :precondition
      (and
        (verification_completed ?checkpoint)
        (backup_consumed ?checkpoint)
        (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
        (checkpoint_binds_config_item ?checkpoint ?configuration_item)
      )
    :effect
      (and
        (not
          (backup_consumed ?checkpoint)
        )
        (not
          (approval_claimed ?checkpoint)
        )
      )
  )
  (:action attach_network_endpoint
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint)
    :precondition
      (and
        (network_endpoint_available ?network_endpoint)
        (checkpoint_registered ?checkpoint)
      )
    :effect
      (and
        (not
          (network_endpoint_available ?network_endpoint)
        )
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
      )
  )
  (:action mark_validation_ready_with_approval
    :parameters (?checkpoint - cutover_checkpoint ?dependent_service - dependent_service ?configuration_item - configuration_item ?approval_gate - approval_gate)
    :precondition
      (and
        (checkpoint_operator_group_binding ?checkpoint ?approval_gate)
        (artifacts_staged ?checkpoint)
        (not
          (approval_claimed ?checkpoint)
        )
        (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
        (verification_completed ?checkpoint)
        (checkpoint_binds_config_item ?checkpoint ?configuration_item)
        (not
          (validation_gate_passed ?checkpoint)
        )
      )
    :effect
      (and
        (validation_gate_passed ?checkpoint)
      )
  )
  (:action stage_artifact_with_policy
    :parameters (?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
    :precondition
      (and
        (checkpoint_has_allocation ?checkpoint)
        (checkpoint_policy_applied ?checkpoint ?traffic_policy)
        (not
          (artifacts_staged ?checkpoint)
        )
      )
    :effect
      (and
        (artifacts_staged ?checkpoint)
        (not
          (approval_claimed ?checkpoint)
        )
      )
  )
  (:action acquire_external_dependency
    :parameters (?checkpoint - cutover_checkpoint ?external_dependency - external_dependency)
    :precondition
      (and
        (checkpoint_external_dependency_candidate ?checkpoint ?external_dependency)
        (checkpoint_registered ?checkpoint)
        (external_dependency_available ?external_dependency)
      )
    :effect
      (and
        (checkpoint_binds_external_dependency ?checkpoint ?external_dependency)
        (not
          (external_dependency_available ?external_dependency)
        )
      )
  )
  (:action acquire_dependent_service
    :parameters (?checkpoint - cutover_checkpoint ?dependent_service - dependent_service)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (dependent_service_available ?dependent_service)
        (checkpoint_dependent_service_candidate ?checkpoint ?dependent_service)
      )
    :effect
      (and
        (not
          (dependent_service_available ?dependent_service)
        )
        (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
      )
  )
  (:action release_external_dependency
    :parameters (?checkpoint - cutover_checkpoint ?external_dependency - external_dependency)
    :precondition
      (and
        (checkpoint_binds_external_dependency ?checkpoint ?external_dependency)
      )
    :effect
      (and
        (external_dependency_available ?external_dependency)
        (not
          (checkpoint_binds_external_dependency ?checkpoint ?external_dependency)
        )
      )
  )
  (:action release_config_item
    :parameters (?checkpoint - cutover_checkpoint ?configuration_item - configuration_item)
    :precondition
      (and
        (checkpoint_binds_config_item ?checkpoint ?configuration_item)
      )
    :effect
      (and
        (config_item_available ?configuration_item)
        (not
          (checkpoint_binds_config_item ?checkpoint ?configuration_item)
        )
      )
  )
  (:action apply_traffic_policy_to_checkpoint
    :parameters (?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
    :precondition
      (and
        (readiness_marked ?checkpoint)
        (traffic_policy_available ?traffic_policy)
        (checkpoint_policy_candidate_binding ?checkpoint ?traffic_policy)
      )
    :effect
      (and
        (checkpoint_primary_policy_assigned ?checkpoint ?traffic_policy)
        (not
          (traffic_policy_available ?traffic_policy)
        )
      )
  )
  (:action acquire_config_item
    :parameters (?checkpoint - cutover_checkpoint ?configuration_item - configuration_item)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (config_item_available ?configuration_item)
        (checkpoint_config_item_candidate ?checkpoint ?configuration_item)
      )
    :effect
      (and
        (checkpoint_binds_config_item ?checkpoint ?configuration_item)
        (not
          (config_item_available ?configuration_item)
        )
      )
  )
  (:action execute_verification_with_snapshot
    :parameters (?checkpoint - cutover_checkpoint ?verification_suite - verification_suite ?dependent_service - dependent_service ?configuration_item - configuration_item)
    :precondition
      (and
        (checkpoint_has_allocation ?checkpoint)
        (verification_available ?verification_suite)
        (checkpoint_verification_candidate ?checkpoint ?verification_suite)
        (not
          (verification_completed ?checkpoint)
        )
        (checkpoint_binds_config_item ?checkpoint ?configuration_item)
        (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
      )
    :effect
      (and
        (checkpoint_executed_verification ?checkpoint ?verification_suite)
        (not
          (verification_available ?verification_suite)
        )
        (verification_completed ?checkpoint)
      )
  )
  (:action promote_staged_to_staged_flag
    :parameters (?checkpoint - cutover_checkpoint ?dependent_service - dependent_service ?configuration_item - configuration_item)
    :precondition
      (and
        (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
        (validation_gate_passed ?checkpoint)
        (checkpoint_binds_config_item ?checkpoint ?configuration_item)
        (approval_claimed ?checkpoint)
      )
    :effect
      (and
        (not
          (backup_consumed ?checkpoint)
        )
        (not
          (approval_claimed ?checkpoint)
        )
        (not
          (artifacts_staged ?checkpoint)
        )
        (staged_for_promotion ?checkpoint)
      )
  )
  (:action detach_network_endpoint
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint)
    :precondition
      (and
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
      )
    :effect
      (and
        (network_endpoint_available ?network_endpoint)
        (not
          (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
        )
      )
  )
  (:action stage_artifact_with_script
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint ?automation_script - automation_script)
    :precondition
      (and
        (not
          (artifacts_staged ?checkpoint)
        )
        (checkpoint_has_allocation ?checkpoint)
        (automation_script_available ?automation_script)
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
        (operator_approval_recorded ?checkpoint)
      )
    :effect
      (and
        (not
          (approval_claimed ?checkpoint)
        )
        (artifacts_staged ?checkpoint)
      )
  )
  (:action finalize_checkpoint_with_audit
    :parameters (?checkpoint - cutover_checkpoint)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (checkpoint_secondary_role ?checkpoint)
        (staged_audit_marked ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (artifacts_staged ?checkpoint)
        (not
          (checkpoint_finalized ?checkpoint)
        )
        (readiness_marked ?checkpoint)
        (verification_completed ?checkpoint)
        (validation_gate_passed ?checkpoint)
      )
    :effect
      (and
        (checkpoint_finalized ?checkpoint)
      )
  )
  (:action record_audit_token
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint ?automation_script - automation_script)
    :precondition
      (and
        (artifacts_staged ?checkpoint)
        (automation_script_available ?automation_script)
        (not
          (staged_audit_marked ?checkpoint)
        )
        (readiness_marked ?checkpoint)
        (checkpoint_registered ?checkpoint)
        (checkpoint_secondary_role ?checkpoint)
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
      )
    :effect
      (and
        (staged_audit_marked ?checkpoint)
      )
  )
  (:action release_dependent_service
    :parameters (?checkpoint - cutover_checkpoint ?dependent_service - dependent_service)
    :precondition
      (and
        (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
      )
    :effect
      (and
        (dependent_service_available ?dependent_service)
        (not
          (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
        )
      )
  )
  (:action register_canary_profile
    :parameters (?checkpoint - cutover_checkpoint ?canary_profile - canary_profile)
    :precondition
      (and
        (canary_profile_available ?canary_profile)
        (checkpoint_registered ?checkpoint)
        (checkpoint_canary_candidate ?checkpoint ?canary_profile)
      )
    :effect
      (and
        (checkpoint_binds_canary_profile ?checkpoint ?canary_profile)
        (not
          (canary_profile_available ?canary_profile)
        )
      )
  )
  (:action create_checkpoint
    :parameters (?checkpoint - cutover_checkpoint)
    :precondition
      (and
        (not
          (checkpoint_registered ?checkpoint)
        )
        (not
          (checkpoint_finalized ?checkpoint)
        )
      )
    :effect
      (and
        (checkpoint_registered ?checkpoint)
      )
  )
  (:action record_operator_approval
    :parameters (?checkpoint - cutover_checkpoint ?runbook - runbook)
    :precondition
      (and
        (not
          (operator_approval_recorded ?checkpoint)
        )
        (checkpoint_registered ?checkpoint)
        (runbook_available ?runbook)
        (checkpoint_has_allocation ?checkpoint)
      )
    :effect
      (and
        (approval_claimed ?checkpoint)
        (not
          (runbook_available ?runbook)
        )
        (operator_approval_recorded ?checkpoint)
      )
  )
  (:action execute_deployment_with_backup
    :parameters (?checkpoint - cutover_checkpoint ?verification_suite - verification_suite ?external_dependency - external_dependency ?backup_snapshot - backup_snapshot)
    :precondition
      (and
        (backup_snapshot_available ?backup_snapshot)
        (checkpoint_snapshot_candidate ?checkpoint ?backup_snapshot)
        (not
          (verification_completed ?checkpoint)
        )
        (checkpoint_has_allocation ?checkpoint)
        (verification_available ?verification_suite)
        (checkpoint_verification_candidate ?checkpoint ?verification_suite)
        (checkpoint_binds_external_dependency ?checkpoint ?external_dependency)
      )
    :effect
      (and
        (checkpoint_executed_verification ?checkpoint ?verification_suite)
        (not
          (backup_snapshot_available ?backup_snapshot)
        )
        (backup_consumed ?checkpoint)
        (not
          (verification_available ?verification_suite)
        )
        (approval_claimed ?checkpoint)
        (verification_completed ?checkpoint)
      )
  )
  (:action mark_readiness_with_runbook
    :parameters (?checkpoint - cutover_checkpoint ?runbook - runbook)
    :precondition
      (and
        (runbook_available ?runbook)
        (not
          (approval_claimed ?checkpoint)
        )
        (artifacts_staged ?checkpoint)
        (validation_gate_passed ?checkpoint)
        (not
          (readiness_marked ?checkpoint)
        )
      )
    :effect
      (and
        (readiness_marked ?checkpoint)
        (not
          (runbook_available ?runbook)
        )
      )
  )
  (:action release_deployment_slot
    :parameters (?checkpoint - cutover_checkpoint ?deployment_slot - deployment_slot)
    :precondition
      (and
        (checkpoint_allocated_slot ?checkpoint ?deployment_slot)
        (not
          (validation_gate_passed ?checkpoint)
        )
        (not
          (verification_completed ?checkpoint)
        )
      )
    :effect
      (and
        (not
          (checkpoint_allocated_slot ?checkpoint ?deployment_slot)
        )
        (slot_available ?deployment_slot)
        (not
          (checkpoint_has_allocation ?checkpoint)
        )
        (not
          (operator_approval_recorded ?checkpoint)
        )
        (not
          (staged_for_promotion ?checkpoint)
        )
        (not
          (artifacts_staged ?checkpoint)
        )
        (not
          (backup_consumed ?checkpoint)
        )
        (not
          (approval_claimed ?checkpoint)
        )
      )
  )
  (:action mark_readiness_for_endpoint
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint)
    :precondition
      (and
        (not
          (readiness_marked ?checkpoint)
        )
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
        (artifacts_staged ?checkpoint)
        (validation_gate_passed ?checkpoint)
        (not
          (approval_claimed ?checkpoint)
        )
      )
    :effect
      (and
        (readiness_marked ?checkpoint)
      )
  )
  (:action finalize_checkpoint_with_policy
    :parameters (?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
    :precondition
      (and
        (readiness_marked ?checkpoint)
        (validation_gate_passed ?checkpoint)
        (verification_completed ?checkpoint)
        (checkpoint_policy_applied ?checkpoint ?traffic_policy)
        (artifacts_staged ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (checkpoint_registered ?checkpoint)
        (not
          (checkpoint_finalized ?checkpoint)
        )
        (checkpoint_secondary_role ?checkpoint)
      )
    :effect
      (and
        (checkpoint_finalized ?checkpoint)
      )
  )
  (:action configure_endpoint_for_validation
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (not
          (operator_approval_recorded ?checkpoint)
        )
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
      )
    :effect
      (and
        (operator_approval_recorded ?checkpoint)
      )
  )
  (:action reserve_deployment_slot
    :parameters (?checkpoint - cutover_checkpoint ?deployment_slot - deployment_slot)
    :precondition
      (and
        (not
          (checkpoint_has_allocation ?checkpoint)
        )
        (checkpoint_registered ?checkpoint)
        (slot_available ?deployment_slot)
        (checkpoint_slot_candidate ?checkpoint ?deployment_slot)
      )
    :effect
      (and
        (checkpoint_has_allocation ?checkpoint)
        (not
          (slot_available ?deployment_slot)
        )
        (checkpoint_allocated_slot ?checkpoint ?deployment_slot)
      )
  )
  (:action restage_artifact_with_script
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint ?automation_script - automation_script)
    :precondition
      (and
        (checkpoint_has_allocation ?checkpoint)
        (not
          (artifacts_staged ?checkpoint)
        )
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
        (validation_gate_passed ?checkpoint)
        (automation_script_available ?automation_script)
        (staged_for_promotion ?checkpoint)
      )
    :effect
      (and
        (artifacts_staged ?checkpoint)
      )
  )
  (:action bind_policy_between_cutovers
    :parameters (?secondary_cutover - secondary_cutover ?primary_cutover - primary_cutover ?traffic_policy - traffic_policy)
    :precondition
      (and
        (checkpoint_registered ?secondary_cutover)
        (checkpoint_primary_policy_assigned ?primary_cutover ?traffic_policy)
        (checkpoint_secondary_role ?secondary_cutover)
        (not
          (checkpoint_policy_applied ?secondary_cutover ?traffic_policy)
        )
        (checkpoint_secondary_policy_assigned ?secondary_cutover ?traffic_policy)
      )
    :effect
      (and
        (checkpoint_policy_applied ?secondary_cutover ?traffic_policy)
      )
  )
)

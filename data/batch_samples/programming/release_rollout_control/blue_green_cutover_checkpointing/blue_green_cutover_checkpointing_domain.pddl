(define (domain blue_green_cutover_checkpointing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types base_object - object cutover_checkpoint - base_object deployment_slot - base_object verification_suite - base_object configuration_item - base_object dependent_service - base_object external_dependency - base_object network_endpoint - base_object runbook - base_object traffic_policy - base_object automation_script - base_object backup_snapshot - base_object canary_profile - base_object operator_group - base_object approval_gate - operator_group operator_group_token - operator_group primary_cutover - cutover_checkpoint secondary_cutover - cutover_checkpoint)

  (:predicates
    (checkpoint_registered ?checkpoint - cutover_checkpoint)
    (checkpoint_allocated_slot ?checkpoint - cutover_checkpoint ?deployment_slot - deployment_slot)
    (checkpoint_has_allocation ?checkpoint - cutover_checkpoint)
    (operator_approval_recorded ?checkpoint - cutover_checkpoint)
    (artifacts_staged ?checkpoint - cutover_checkpoint)
    (checkpoint_binds_dependent_service ?checkpoint - cutover_checkpoint ?dependent_service - dependent_service)
    (checkpoint_binds_config_item ?checkpoint - cutover_checkpoint ?configuration_item - configuration_item)
    (checkpoint_binds_external_dependency ?checkpoint - cutover_checkpoint ?external_dependency - external_dependency)
    (checkpoint_binds_canary_profile ?checkpoint - cutover_checkpoint ?canary_profile - canary_profile)
    (checkpoint_executed_verification ?checkpoint - cutover_checkpoint ?verification_suite - verification_suite)
    (verification_completed ?checkpoint - cutover_checkpoint)
    (validation_gate_passed ?checkpoint - cutover_checkpoint)
    (readiness_marked ?checkpoint - cutover_checkpoint)
    (checkpoint_finalized ?checkpoint - cutover_checkpoint)
    (approval_claimed ?checkpoint - cutover_checkpoint)
    (staged_for_promotion ?checkpoint - cutover_checkpoint)
    (checkpoint_secondary_policy_assigned ?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
    (checkpoint_policy_applied ?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
    (staged_audit_marked ?checkpoint - cutover_checkpoint)
    (slot_available ?deployment_slot - deployment_slot)
    (verification_available ?verification_suite - verification_suite)
    (dependent_service_available ?dependent_service - dependent_service)
    (config_item_available ?configuration_item - configuration_item)
    (external_dependency_available ?external_dependency - external_dependency)
    (network_endpoint_available ?network_endpoint - network_endpoint)
    (runbook_available ?runbook - runbook)
    (traffic_policy_available ?traffic_policy - traffic_policy)
    (automation_script_available ?automation_script - automation_script)
    (backup_snapshot_available ?backup_snapshot - backup_snapshot)
    (canary_profile_available ?canary_profile - canary_profile)
    (checkpoint_slot_candidate ?checkpoint - cutover_checkpoint ?deployment_slot - deployment_slot)
    (checkpoint_verification_candidate ?checkpoint - cutover_checkpoint ?verification_suite - verification_suite)
    (checkpoint_dependent_service_candidate ?checkpoint - cutover_checkpoint ?dependent_service - dependent_service)
    (checkpoint_config_item_candidate ?checkpoint - cutover_checkpoint ?configuration_item - configuration_item)
    (checkpoint_external_dependency_candidate ?checkpoint - cutover_checkpoint ?external_dependency - external_dependency)
    (checkpoint_snapshot_candidate ?checkpoint - cutover_checkpoint ?backup_snapshot - backup_snapshot)
    (checkpoint_canary_candidate ?checkpoint - cutover_checkpoint ?canary_profile - canary_profile)
    (checkpoint_operator_group_binding ?checkpoint - cutover_checkpoint ?operator_group - operator_group)
    (checkpoint_primary_policy_assigned ?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
    (checkpoint_primary_role ?checkpoint - cutover_checkpoint)
    (checkpoint_secondary_role ?checkpoint - cutover_checkpoint)
    (checkpoint_endpoint_binding ?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint)
    (backup_consumed ?checkpoint - cutover_checkpoint)
    (checkpoint_policy_candidate_binding ?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
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
  (:action reserve_deployment_slot
    :parameters (?checkpoint - cutover_checkpoint ?deployment_slot - deployment_slot)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (slot_available ?deployment_slot)
        (checkpoint_slot_candidate ?checkpoint ?deployment_slot)
        (not
          (checkpoint_has_allocation ?checkpoint)
        )
      )
    :effect
      (and
        (checkpoint_allocated_slot ?checkpoint ?deployment_slot)
        (checkpoint_has_allocation ?checkpoint)
        (not
          (slot_available ?deployment_slot)
        )
      )
  )
  (:action release_deployment_slot
    :parameters (?checkpoint - cutover_checkpoint ?deployment_slot - deployment_slot)
    :precondition
      (and
        (checkpoint_allocated_slot ?checkpoint ?deployment_slot)
        (not
          (verification_completed ?checkpoint)
        )
        (not
          (validation_gate_passed ?checkpoint)
        )
      )
    :effect
      (and
        (not
          (checkpoint_allocated_slot ?checkpoint ?deployment_slot)
        )
        (not
          (checkpoint_has_allocation ?checkpoint)
        )
        (not
          (operator_approval_recorded ?checkpoint)
        )
        (not
          (artifacts_staged ?checkpoint)
        )
        (not
          (approval_claimed ?checkpoint)
        )
        (not
          (staged_for_promotion ?checkpoint)
        )
        (not
          (backup_consumed ?checkpoint)
        )
        (slot_available ?deployment_slot)
      )
  )
  (:action attach_network_endpoint
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (network_endpoint_available ?network_endpoint)
      )
    :effect
      (and
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
        (not
          (network_endpoint_available ?network_endpoint)
        )
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
  (:action configure_endpoint_for_validation
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
        (not
          (operator_approval_recorded ?checkpoint)
        )
      )
    :effect
      (and
        (operator_approval_recorded ?checkpoint)
      )
  )
  (:action record_operator_approval
    :parameters (?checkpoint - cutover_checkpoint ?runbook - runbook)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (runbook_available ?runbook)
        (not
          (operator_approval_recorded ?checkpoint)
        )
      )
    :effect
      (and
        (operator_approval_recorded ?checkpoint)
        (approval_claimed ?checkpoint)
        (not
          (runbook_available ?runbook)
        )
      )
  )
  (:action stage_artifact_with_script
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint ?automation_script - automation_script)
    :precondition
      (and
        (operator_approval_recorded ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
        (automation_script_available ?automation_script)
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
        (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
        (not
          (dependent_service_available ?dependent_service)
        )
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
  (:action acquire_external_dependency
    :parameters (?checkpoint - cutover_checkpoint ?external_dependency - external_dependency)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (external_dependency_available ?external_dependency)
        (checkpoint_external_dependency_candidate ?checkpoint ?external_dependency)
      )
    :effect
      (and
        (checkpoint_binds_external_dependency ?checkpoint ?external_dependency)
        (not
          (external_dependency_available ?external_dependency)
        )
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
  (:action register_canary_profile
    :parameters (?checkpoint - cutover_checkpoint ?canary_profile - canary_profile)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (canary_profile_available ?canary_profile)
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
  (:action execute_verification_with_snapshot
    :parameters (?checkpoint - cutover_checkpoint ?verification_suite - verification_suite ?dependent_service - dependent_service ?configuration_item - configuration_item)
    :precondition
      (and
        (checkpoint_has_allocation ?checkpoint)
        (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
        (checkpoint_binds_config_item ?checkpoint ?configuration_item)
        (verification_available ?verification_suite)
        (checkpoint_verification_candidate ?checkpoint ?verification_suite)
        (not
          (verification_completed ?checkpoint)
        )
      )
    :effect
      (and
        (checkpoint_executed_verification ?checkpoint ?verification_suite)
        (verification_completed ?checkpoint)
        (not
          (verification_available ?verification_suite)
        )
      )
  )
  (:action execute_deployment_with_backup
    :parameters (?checkpoint - cutover_checkpoint ?verification_suite - verification_suite ?external_dependency - external_dependency ?backup_snapshot - backup_snapshot)
    :precondition
      (and
        (checkpoint_has_allocation ?checkpoint)
        (checkpoint_binds_external_dependency ?checkpoint ?external_dependency)
        (backup_snapshot_available ?backup_snapshot)
        (verification_available ?verification_suite)
        (checkpoint_verification_candidate ?checkpoint ?verification_suite)
        (checkpoint_snapshot_candidate ?checkpoint ?backup_snapshot)
        (not
          (verification_completed ?checkpoint)
        )
      )
    :effect
      (and
        (checkpoint_executed_verification ?checkpoint ?verification_suite)
        (verification_completed ?checkpoint)
        (backup_consumed ?checkpoint)
        (approval_claimed ?checkpoint)
        (not
          (verification_available ?verification_suite)
        )
        (not
          (backup_snapshot_available ?backup_snapshot)
        )
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
  (:action mark_validation_ready_with_approval
    :parameters (?checkpoint - cutover_checkpoint ?dependent_service - dependent_service ?configuration_item - configuration_item ?approval_gate - approval_gate)
    :precondition
      (and
        (artifacts_staged ?checkpoint)
        (verification_completed ?checkpoint)
        (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
        (checkpoint_binds_config_item ?checkpoint ?configuration_item)
        (checkpoint_operator_group_binding ?checkpoint ?approval_gate)
        (not
          (approval_claimed ?checkpoint)
        )
        (not
          (validation_gate_passed ?checkpoint)
        )
      )
    :effect
      (and
        (validation_gate_passed ?checkpoint)
      )
  )
  (:action mark_validation_ready_with_canary
    :parameters (?checkpoint - cutover_checkpoint ?external_dependency - external_dependency ?canary_profile - canary_profile ?audit_token - operator_group_token)
    :precondition
      (and
        (artifacts_staged ?checkpoint)
        (verification_completed ?checkpoint)
        (checkpoint_binds_external_dependency ?checkpoint ?external_dependency)
        (checkpoint_binds_canary_profile ?checkpoint ?canary_profile)
        (checkpoint_operator_group_binding ?checkpoint ?audit_token)
        (not
          (validation_gate_passed ?checkpoint)
        )
      )
    :effect
      (and
        (validation_gate_passed ?checkpoint)
        (approval_claimed ?checkpoint)
      )
  )
  (:action promote_staged_to_staged_flag
    :parameters (?checkpoint - cutover_checkpoint ?dependent_service - dependent_service ?configuration_item - configuration_item)
    :precondition
      (and
        (validation_gate_passed ?checkpoint)
        (approval_claimed ?checkpoint)
        (checkpoint_binds_dependent_service ?checkpoint ?dependent_service)
        (checkpoint_binds_config_item ?checkpoint ?configuration_item)
      )
    :effect
      (and
        (staged_for_promotion ?checkpoint)
        (not
          (approval_claimed ?checkpoint)
        )
        (not
          (artifacts_staged ?checkpoint)
        )
        (not
          (backup_consumed ?checkpoint)
        )
      )
  )
  (:action restage_artifact_with_script
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint ?automation_script - automation_script)
    :precondition
      (and
        (staged_for_promotion ?checkpoint)
        (validation_gate_passed ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
        (automation_script_available ?automation_script)
        (not
          (artifacts_staged ?checkpoint)
        )
      )
    :effect
      (and
        (artifacts_staged ?checkpoint)
      )
  )
  (:action mark_readiness_for_endpoint
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint)
    :precondition
      (and
        (validation_gate_passed ?checkpoint)
        (artifacts_staged ?checkpoint)
        (not
          (approval_claimed ?checkpoint)
        )
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
        (not
          (readiness_marked ?checkpoint)
        )
      )
    :effect
      (and
        (readiness_marked ?checkpoint)
      )
  )
  (:action mark_readiness_with_runbook
    :parameters (?checkpoint - cutover_checkpoint ?runbook - runbook)
    :precondition
      (and
        (validation_gate_passed ?checkpoint)
        (artifacts_staged ?checkpoint)
        (not
          (approval_claimed ?checkpoint)
        )
        (runbook_available ?runbook)
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
  (:action bind_policy_between_cutovers
    :parameters (?secondary_cutover - secondary_cutover ?primary_cutover - primary_cutover ?traffic_policy - traffic_policy)
    :precondition
      (and
        (checkpoint_registered ?secondary_cutover)
        (checkpoint_secondary_role ?secondary_cutover)
        (checkpoint_secondary_policy_assigned ?secondary_cutover ?traffic_policy)
        (checkpoint_primary_policy_assigned ?primary_cutover ?traffic_policy)
        (not
          (checkpoint_policy_applied ?secondary_cutover ?traffic_policy)
        )
      )
    :effect
      (and
        (checkpoint_policy_applied ?secondary_cutover ?traffic_policy)
      )
  )
  (:action record_audit_token
    :parameters (?checkpoint - cutover_checkpoint ?network_endpoint - network_endpoint ?automation_script - automation_script)
    :precondition
      (and
        (checkpoint_registered ?checkpoint)
        (checkpoint_secondary_role ?checkpoint)
        (artifacts_staged ?checkpoint)
        (readiness_marked ?checkpoint)
        (checkpoint_endpoint_binding ?checkpoint ?network_endpoint)
        (automation_script_available ?automation_script)
        (not
          (staged_audit_marked ?checkpoint)
        )
      )
    :effect
      (and
        (staged_audit_marked ?checkpoint)
      )
  )
  (:action finalize_checkpoint_state
    :parameters (?checkpoint - cutover_checkpoint)
    :precondition
      (and
        (checkpoint_primary_role ?checkpoint)
        (checkpoint_registered ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (verification_completed ?checkpoint)
        (validation_gate_passed ?checkpoint)
        (readiness_marked ?checkpoint)
        (artifacts_staged ?checkpoint)
        (not
          (checkpoint_finalized ?checkpoint)
        )
      )
    :effect
      (and
        (checkpoint_finalized ?checkpoint)
      )
  )
  (:action finalize_checkpoint_with_policy
    :parameters (?checkpoint - cutover_checkpoint ?traffic_policy - traffic_policy)
    :precondition
      (and
        (checkpoint_secondary_role ?checkpoint)
        (checkpoint_registered ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (verification_completed ?checkpoint)
        (validation_gate_passed ?checkpoint)
        (readiness_marked ?checkpoint)
        (artifacts_staged ?checkpoint)
        (checkpoint_policy_applied ?checkpoint ?traffic_policy)
        (not
          (checkpoint_finalized ?checkpoint)
        )
      )
    :effect
      (and
        (checkpoint_finalized ?checkpoint)
      )
  )
  (:action finalize_checkpoint_with_audit
    :parameters (?checkpoint - cutover_checkpoint)
    :precondition
      (and
        (checkpoint_secondary_role ?checkpoint)
        (checkpoint_registered ?checkpoint)
        (checkpoint_has_allocation ?checkpoint)
        (verification_completed ?checkpoint)
        (validation_gate_passed ?checkpoint)
        (readiness_marked ?checkpoint)
        (artifacts_staged ?checkpoint)
        (staged_audit_marked ?checkpoint)
        (not
          (checkpoint_finalized ?checkpoint)
        )
      )
    :effect
      (and
        (checkpoint_finalized ?checkpoint)
      )
  )
)

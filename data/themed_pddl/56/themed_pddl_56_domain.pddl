(define (domain commit_pipeline_stage_gating_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types change_request - object executor_slot - object pipeline_stage - object policy - object test_suite - object security_scan_job - object workspace_slot - object reviewer - object ci_tool_instance - object operator_credential - object infrastructure_resource - object external_dependency - object capacity_group - object manual_approver - capacity_group automated_gate - capacity_group pull_request_variant - change_request merge_commit_variant - change_request)
  (:predicates
    (reviewer_available ?reviewer - reviewer)
    (policy_bound ?change_request - change_request ?policy - policy)
    (stage_execution_confirmed ?change_request - change_request)
    (executor_reserved ?change_request - change_request ?executor_slot - executor_slot)
    (capacity_group_assigned ?change_request - change_request ?capacity_group - capacity_group)
    (security_scan_available ?security_scan_job - security_scan_job)
    (policy_available ?policy - policy)
    (dependency_compatible ?change_request - change_request ?external_dependency - external_dependency)
    (stage_gate_passed ?change_request - change_request)
    (change_is_pull_request ?change_request - change_request)
    (executor_compatible ?change_request - change_request ?executor_slot - executor_slot)
    (pipeline_stage_available ?pipeline_stage - pipeline_stage)
    (infrastructure_resource_available ?infrastructure_resource - infrastructure_resource)
    (workspace_slot_available ?workspace_slot - workspace_slot)
    (stage_execution_flag ?change_request - change_request)
    (policy_compatible ?change_request - change_request ?policy - policy)
    (dependency_bound ?change_request - change_request ?external_dependency - external_dependency)
    (stage_execution_recorded ?change_request - change_request ?pipeline_stage - pipeline_stage)
    (approval_granted ?change_request - change_request)
    (security_scan_compatible ?change_request - change_request ?security_scan_job - security_scan_job)
    (external_dependency_available ?external_dependency - external_dependency)
    (change_is_merge_commit ?change_request - change_request)
    (environment_configured ?change_request - change_request)
    (test_suite_compatible ?change_request - change_request ?test_suite - test_suite)
    (test_suite_bound ?change_request - change_request ?test_suite - test_suite)
    (security_scan_reported ?change_request - change_request)
    (workspace_bound ?change_request - change_request ?workspace_slot - workspace_slot)
    (operator_setup_completed ?change_request - change_request)
    (infra_resource_compatible ?change_request - change_request ?infrastructure_resource - infrastructure_resource)
    (change_registered ?change_request - change_request)
    (executor_slot_available ?executor_slot - executor_slot)
    (has_executor_allocation ?change_request - change_request)
    (operator_credential_available ?operator_credential - operator_credential)
    (ci_tool_instance_available ?ci_tool_instance - ci_tool_instance)
    (security_scan_bound ?change_request - change_request ?security_scan_job - security_scan_job)
    (ci_tool_bound ?change_request - change_request ?ci_tool_instance - ci_tool_instance)
    (preparation_ready ?change_request - change_request)
    (ci_tool_binding_requested ?change_request - change_request)
    (ci_tool_compatible ?change_request - change_request ?ci_tool_instance - ci_tool_instance)
    (test_suite_available ?test_suite - test_suite)
    (preferred_ci_tool_for_change ?change_request - change_request ?ci_tool_instance - ci_tool_instance)
    (stage_compatible ?change_request - change_request ?pipeline_stage - pipeline_stage)
    (review_assigned ?change_request - change_request)
    (ci_tool_invoked_for_change ?change_request - change_request ?ci_tool_instance - ci_tool_instance)
  )
  (:action release_external_dependency
    :parameters (?change_request - change_request ?external_dependency - external_dependency)
    :precondition
      (and
        (dependency_bound ?change_request ?external_dependency)
      )
    :effect
      (and
        (external_dependency_available ?external_dependency)
        (not
          (dependency_bound ?change_request ?external_dependency)
        )
      )
  )
  (:action grant_automated_approval
    :parameters (?change_request - change_request ?security_scan_job - security_scan_job ?external_dependency - external_dependency ?automated_gate - automated_gate)
    :precondition
      (and
        (not
          (approval_granted ?change_request)
        )
        (stage_execution_flag ?change_request)
        (environment_configured ?change_request)
        (dependency_bound ?change_request ?external_dependency)
        (capacity_group_assigned ?change_request ?automated_gate)
        (security_scan_bound ?change_request ?security_scan_job)
      )
    :effect
      (and
        (review_assigned ?change_request)
        (approval_granted ?change_request)
      )
  )
  (:action finalize_pull_request_stage_gate
    :parameters (?change_request - change_request)
    :precondition
      (and
        (environment_configured ?change_request)
        (has_executor_allocation ?change_request)
        (stage_execution_flag ?change_request)
        (change_registered ?change_request)
        (ci_tool_binding_requested ?change_request)
        (not
          (stage_gate_passed ?change_request)
        )
        (change_is_pull_request ?change_request)
        (approval_granted ?change_request)
      )
    :effect
      (and
        (stage_gate_passed ?change_request)
      )
  )
  (:action finalize_scan_review_flags
    :parameters (?change_request - change_request ?test_suite - test_suite ?policy - policy)
    :precondition
      (and
        (stage_execution_flag ?change_request)
        (security_scan_reported ?change_request)
        (test_suite_bound ?change_request ?test_suite)
        (policy_bound ?change_request ?policy)
      )
    :effect
      (and
        (not
          (security_scan_reported ?change_request)
        )
        (not
          (review_assigned ?change_request)
        )
      )
  )
  (:action claim_workspace_slot
    :parameters (?change_request - change_request ?workspace_slot - workspace_slot)
    :precondition
      (and
        (workspace_slot_available ?workspace_slot)
        (change_registered ?change_request)
      )
    :effect
      (and
        (not
          (workspace_slot_available ?workspace_slot)
        )
        (workspace_bound ?change_request ?workspace_slot)
      )
  )
  (:action grant_manual_approval
    :parameters (?change_request - change_request ?test_suite - test_suite ?policy - policy ?manual_approver - manual_approver)
    :precondition
      (and
        (capacity_group_assigned ?change_request ?manual_approver)
        (environment_configured ?change_request)
        (not
          (review_assigned ?change_request)
        )
        (test_suite_bound ?change_request ?test_suite)
        (stage_execution_flag ?change_request)
        (policy_bound ?change_request ?policy)
        (not
          (approval_granted ?change_request)
        )
      )
    :effect
      (and
        (approval_granted ?change_request)
      )
  )
  (:action complete_ci_tool_configuration
    :parameters (?change_request - change_request ?ci_tool_instance - ci_tool_instance)
    :precondition
      (and
        (has_executor_allocation ?change_request)
        (ci_tool_invoked_for_change ?change_request ?ci_tool_instance)
        (not
          (environment_configured ?change_request)
        )
      )
    :effect
      (and
        (environment_configured ?change_request)
        (not
          (review_assigned ?change_request)
        )
      )
  )
  (:action reserve_security_scan
    :parameters (?change_request - change_request ?security_scan_job - security_scan_job)
    :precondition
      (and
        (security_scan_compatible ?change_request ?security_scan_job)
        (change_registered ?change_request)
        (security_scan_available ?security_scan_job)
      )
    :effect
      (and
        (security_scan_bound ?change_request ?security_scan_job)
        (not
          (security_scan_available ?security_scan_job)
        )
      )
  )
  (:action reserve_test_suite
    :parameters (?change_request - change_request ?test_suite - test_suite)
    :precondition
      (and
        (change_registered ?change_request)
        (test_suite_available ?test_suite)
        (test_suite_compatible ?change_request ?test_suite)
      )
    :effect
      (and
        (not
          (test_suite_available ?test_suite)
        )
        (test_suite_bound ?change_request ?test_suite)
      )
  )
  (:action release_security_scan
    :parameters (?change_request - change_request ?security_scan_job - security_scan_job)
    :precondition
      (and
        (security_scan_bound ?change_request ?security_scan_job)
      )
    :effect
      (and
        (security_scan_available ?security_scan_job)
        (not
          (security_scan_bound ?change_request ?security_scan_job)
        )
      )
  )
  (:action unbind_policy
    :parameters (?change_request - change_request ?policy - policy)
    :precondition
      (and
        (policy_bound ?change_request ?policy)
      )
    :effect
      (and
        (policy_available ?policy)
        (not
          (policy_bound ?change_request ?policy)
        )
      )
  )
  (:action reserve_ci_tool_instance
    :parameters (?change_request - change_request ?ci_tool_instance - ci_tool_instance)
    :precondition
      (and
        (ci_tool_binding_requested ?change_request)
        (ci_tool_instance_available ?ci_tool_instance)
        (ci_tool_compatible ?change_request ?ci_tool_instance)
      )
    :effect
      (and
        (ci_tool_bound ?change_request ?ci_tool_instance)
        (not
          (ci_tool_instance_available ?ci_tool_instance)
        )
      )
  )
  (:action bind_policy
    :parameters (?change_request - change_request ?policy - policy)
    :precondition
      (and
        (change_registered ?change_request)
        (policy_available ?policy)
        (policy_compatible ?change_request ?policy)
      )
    :effect
      (and
        (policy_bound ?change_request ?policy)
        (not
          (policy_available ?policy)
        )
      )
  )
  (:action execute_stage_tests
    :parameters (?change_request - change_request ?pipeline_stage - pipeline_stage ?test_suite - test_suite ?policy - policy)
    :precondition
      (and
        (has_executor_allocation ?change_request)
        (pipeline_stage_available ?pipeline_stage)
        (stage_compatible ?change_request ?pipeline_stage)
        (not
          (stage_execution_flag ?change_request)
        )
        (policy_bound ?change_request ?policy)
        (test_suite_bound ?change_request ?test_suite)
      )
    :effect
      (and
        (stage_execution_recorded ?change_request ?pipeline_stage)
        (not
          (pipeline_stage_available ?pipeline_stage)
        )
        (stage_execution_flag ?change_request)
      )
  )
  (:action mark_stage_execution_success
    :parameters (?change_request - change_request ?test_suite - test_suite ?policy - policy)
    :precondition
      (and
        (test_suite_bound ?change_request ?test_suite)
        (approval_granted ?change_request)
        (policy_bound ?change_request ?policy)
        (review_assigned ?change_request)
      )
    :effect
      (and
        (not
          (security_scan_reported ?change_request)
        )
        (not
          (review_assigned ?change_request)
        )
        (not
          (environment_configured ?change_request)
        )
        (stage_execution_confirmed ?change_request)
      )
  )
  (:action release_workspace_slot
    :parameters (?change_request - change_request ?workspace_slot - workspace_slot)
    :precondition
      (and
        (workspace_bound ?change_request ?workspace_slot)
      )
    :effect
      (and
        (workspace_slot_available ?workspace_slot)
        (not
          (workspace_bound ?change_request ?workspace_slot)
        )
      )
  )
  (:action provision_with_operator_credential
    :parameters (?change_request - change_request ?workspace_slot - workspace_slot ?operator_credential - operator_credential)
    :precondition
      (and
        (not
          (environment_configured ?change_request)
        )
        (has_executor_allocation ?change_request)
        (operator_credential_available ?operator_credential)
        (workspace_bound ?change_request ?workspace_slot)
        (preparation_ready ?change_request)
      )
    :effect
      (and
        (not
          (review_assigned ?change_request)
        )
        (environment_configured ?change_request)
      )
  )
  (:action finalize_stage_gate_with_operator_setup
    :parameters (?change_request - change_request)
    :precondition
      (and
        (change_registered ?change_request)
        (change_is_merge_commit ?change_request)
        (operator_setup_completed ?change_request)
        (has_executor_allocation ?change_request)
        (environment_configured ?change_request)
        (not
          (stage_gate_passed ?change_request)
        )
        (ci_tool_binding_requested ?change_request)
        (stage_execution_flag ?change_request)
        (approval_granted ?change_request)
      )
    :effect
      (and
        (stage_gate_passed ?change_request)
      )
  )
  (:action complete_operator_setup
    :parameters (?change_request - change_request ?workspace_slot - workspace_slot ?operator_credential - operator_credential)
    :precondition
      (and
        (environment_configured ?change_request)
        (operator_credential_available ?operator_credential)
        (not
          (operator_setup_completed ?change_request)
        )
        (ci_tool_binding_requested ?change_request)
        (change_registered ?change_request)
        (change_is_merge_commit ?change_request)
        (workspace_bound ?change_request ?workspace_slot)
      )
    :effect
      (and
        (operator_setup_completed ?change_request)
      )
  )
  (:action release_test_suite
    :parameters (?change_request - change_request ?test_suite - test_suite)
    :precondition
      (and
        (test_suite_bound ?change_request ?test_suite)
      )
    :effect
      (and
        (test_suite_available ?test_suite)
        (not
          (test_suite_bound ?change_request ?test_suite)
        )
      )
  )
  (:action reserve_external_dependency
    :parameters (?change_request - change_request ?external_dependency - external_dependency)
    :precondition
      (and
        (external_dependency_available ?external_dependency)
        (change_registered ?change_request)
        (dependency_compatible ?change_request ?external_dependency)
      )
    :effect
      (and
        (dependency_bound ?change_request ?external_dependency)
        (not
          (external_dependency_available ?external_dependency)
        )
      )
  )
  (:action ingest_change
    :parameters (?change_request - change_request)
    :precondition
      (and
        (not
          (change_registered ?change_request)
        )
        (not
          (stage_gate_passed ?change_request)
        )
      )
    :effect
      (and
        (change_registered ?change_request)
      )
  )
  (:action assign_reviewer
    :parameters (?change_request - change_request ?reviewer - reviewer)
    :precondition
      (and
        (not
          (preparation_ready ?change_request)
        )
        (change_registered ?change_request)
        (reviewer_available ?reviewer)
        (has_executor_allocation ?change_request)
      )
    :effect
      (and
        (review_assigned ?change_request)
        (not
          (reviewer_available ?reviewer)
        )
        (preparation_ready ?change_request)
      )
  )
  (:action execute_security_scan
    :parameters (?change_request - change_request ?pipeline_stage - pipeline_stage ?security_scan_job - security_scan_job ?infrastructure_resource - infrastructure_resource)
    :precondition
      (and
        (infrastructure_resource_available ?infrastructure_resource)
        (infra_resource_compatible ?change_request ?infrastructure_resource)
        (not
          (stage_execution_flag ?change_request)
        )
        (has_executor_allocation ?change_request)
        (pipeline_stage_available ?pipeline_stage)
        (stage_compatible ?change_request ?pipeline_stage)
        (security_scan_bound ?change_request ?security_scan_job)
      )
    :effect
      (and
        (stage_execution_recorded ?change_request ?pipeline_stage)
        (not
          (infrastructure_resource_available ?infrastructure_resource)
        )
        (security_scan_reported ?change_request)
        (not
          (pipeline_stage_available ?pipeline_stage)
        )
        (review_assigned ?change_request)
        (stage_execution_flag ?change_request)
      )
  )
  (:action reserve_reviewer_for_ci_tool_binding
    :parameters (?change_request - change_request ?reviewer - reviewer)
    :precondition
      (and
        (reviewer_available ?reviewer)
        (not
          (review_assigned ?change_request)
        )
        (environment_configured ?change_request)
        (approval_granted ?change_request)
        (not
          (ci_tool_binding_requested ?change_request)
        )
      )
    :effect
      (and
        (ci_tool_binding_requested ?change_request)
        (not
          (reviewer_available ?reviewer)
        )
      )
  )
  (:action release_executor_slot
    :parameters (?change_request - change_request ?executor_slot - executor_slot)
    :precondition
      (and
        (executor_reserved ?change_request ?executor_slot)
        (not
          (approval_granted ?change_request)
        )
        (not
          (stage_execution_flag ?change_request)
        )
      )
    :effect
      (and
        (not
          (executor_reserved ?change_request ?executor_slot)
        )
        (executor_slot_available ?executor_slot)
        (not
          (has_executor_allocation ?change_request)
        )
        (not
          (preparation_ready ?change_request)
        )
        (not
          (stage_execution_confirmed ?change_request)
        )
        (not
          (environment_configured ?change_request)
        )
        (not
          (security_scan_reported ?change_request)
        )
        (not
          (review_assigned ?change_request)
        )
      )
  )
  (:action request_ci_tool_binding
    :parameters (?change_request - change_request ?workspace_slot - workspace_slot)
    :precondition
      (and
        (not
          (ci_tool_binding_requested ?change_request)
        )
        (workspace_bound ?change_request ?workspace_slot)
        (environment_configured ?change_request)
        (approval_granted ?change_request)
        (not
          (review_assigned ?change_request)
        )
      )
    :effect
      (and
        (ci_tool_binding_requested ?change_request)
      )
  )
  (:action finalize_stage_gate_with_ci_tool
    :parameters (?change_request - change_request ?ci_tool_instance - ci_tool_instance)
    :precondition
      (and
        (ci_tool_binding_requested ?change_request)
        (approval_granted ?change_request)
        (stage_execution_flag ?change_request)
        (ci_tool_invoked_for_change ?change_request ?ci_tool_instance)
        (environment_configured ?change_request)
        (has_executor_allocation ?change_request)
        (change_registered ?change_request)
        (not
          (stage_gate_passed ?change_request)
        )
        (change_is_merge_commit ?change_request)
      )
    :effect
      (and
        (stage_gate_passed ?change_request)
      )
  )
  (:action confirm_workspace_provision
    :parameters (?change_request - change_request ?workspace_slot - workspace_slot)
    :precondition
      (and
        (change_registered ?change_request)
        (has_executor_allocation ?change_request)
        (not
          (preparation_ready ?change_request)
        )
        (workspace_bound ?change_request ?workspace_slot)
      )
    :effect
      (and
        (preparation_ready ?change_request)
      )
  )
  (:action reserve_executor_slot
    :parameters (?change_request - change_request ?executor_slot - executor_slot)
    :precondition
      (and
        (not
          (has_executor_allocation ?change_request)
        )
        (change_registered ?change_request)
        (executor_slot_available ?executor_slot)
        (executor_compatible ?change_request ?executor_slot)
      )
    :effect
      (and
        (has_executor_allocation ?change_request)
        (not
          (executor_slot_available ?executor_slot)
        )
        (executor_reserved ?change_request ?executor_slot)
      )
  )
  (:action provision_workspace_with_credentials
    :parameters (?change_request - change_request ?workspace_slot - workspace_slot ?operator_credential - operator_credential)
    :precondition
      (and
        (has_executor_allocation ?change_request)
        (not
          (environment_configured ?change_request)
        )
        (workspace_bound ?change_request ?workspace_slot)
        (approval_granted ?change_request)
        (operator_credential_available ?operator_credential)
        (stage_execution_confirmed ?change_request)
      )
    :effect
      (and
        (environment_configured ?change_request)
      )
  )
  (:action invoke_ci_tool_for_merge_commit
    :parameters (?merge_commit_variant - merge_commit_variant ?pull_request_variant - pull_request_variant ?ci_tool_instance - ci_tool_instance)
    :precondition
      (and
        (change_registered ?merge_commit_variant)
        (ci_tool_bound ?pull_request_variant ?ci_tool_instance)
        (change_is_merge_commit ?merge_commit_variant)
        (not
          (ci_tool_invoked_for_change ?merge_commit_variant ?ci_tool_instance)
        )
        (preferred_ci_tool_for_change ?merge_commit_variant ?ci_tool_instance)
      )
    :effect
      (and
        (ci_tool_invoked_for_change ?merge_commit_variant ?ci_tool_instance)
      )
  )
)

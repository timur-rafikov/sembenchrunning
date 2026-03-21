(define (domain ci_quality_gate_governance)
  (:requirements :strips :typing :negative-preconditions)
  (:types pipeline - object quality_indicator - object evaluation_profile - object rule_set - object analyzer_plugin - object scan_engine - object runner_pool - object approver_identity - object tool_integration - object credential - object artifact - object threshold_profile - object governance_policy - object team_policy - governance_policy org_policy - governance_policy release_pipeline - pipeline feature_pipeline - pipeline)
  (:predicates
    (pipeline_registered ?pipeline - pipeline)
    (pipeline_has_quality_indicator ?pipeline - pipeline ?quality_indicator - quality_indicator)
    (pipeline_quality_indicator_reserved ?pipeline - pipeline)
    (pipeline_runner_activated ?pipeline - pipeline)
    (pipeline_analysis_prepared ?pipeline - pipeline)
    (pipeline_bound_analyzer ?pipeline - pipeline ?analyzer_plugin - analyzer_plugin)
    (pipeline_bound_ruleset ?pipeline - pipeline ?rule_set - rule_set)
    (pipeline_bound_scan_engine ?pipeline - pipeline ?scan_engine - scan_engine)
    (pipeline_bound_threshold_profile ?pipeline - pipeline ?threshold_profile - threshold_profile)
    (pipeline_evaluation_result ?pipeline - pipeline ?evaluation_profile - evaluation_profile)
    (pipeline_has_evaluation ?pipeline - pipeline)
    (pipeline_ready_for_execution ?pipeline - pipeline)
    (pipeline_staged_for_threshold ?pipeline - pipeline)
    (pipeline_promoted ?pipeline - pipeline)
    (pipeline_requires_approval ?pipeline - pipeline)
    (pipeline_verification_passed ?pipeline - pipeline)
    (pipeline_tool_request ?pipeline - pipeline ?tool_integration - tool_integration)
    (pipeline_tool_bound ?pipeline - pipeline ?tool_integration - tool_integration)
    (pipeline_credentials_prepared ?pipeline - pipeline)
    (quality_indicator_available ?quality_indicator - quality_indicator)
    (evaluation_profile_available ?evaluation_profile - evaluation_profile)
    (analyzer_available ?analyzer_plugin - analyzer_plugin)
    (ruleset_available ?rule_set - rule_set)
    (scan_engine_available ?scan_engine - scan_engine)
    (runner_pool_available ?runner_pool - runner_pool)
    (approver_available ?approver_identity - approver_identity)
    (tool_integration_available ?tool_integration - tool_integration)
    (credential_available ?credential - credential)
    (artifact_available ?artifact - artifact)
    (threshold_profile_available ?threshold_profile - threshold_profile)
    (pipeline_quality_indicator_compatible ?pipeline - pipeline ?quality_indicator - quality_indicator)
    (pipeline_evaluation_profile_compatible ?pipeline - pipeline ?evaluation_profile - evaluation_profile)
    (pipeline_analyzer_compatible ?pipeline - pipeline ?analyzer_plugin - analyzer_plugin)
    (pipeline_ruleset_compatible ?pipeline - pipeline ?rule_set - rule_set)
    (pipeline_scan_engine_compatible ?pipeline - pipeline ?scan_engine - scan_engine)
    (pipeline_artifact_compatible ?pipeline - pipeline ?artifact - artifact)
    (pipeline_threshold_profile_compatible ?pipeline - pipeline ?threshold_profile - threshold_profile)
    (pipeline_policy_binding ?pipeline - pipeline ?governance_policy - governance_policy)
    (release_tool_integration_binding ?pipeline - pipeline ?tool_integration - tool_integration)
    (pipeline_release_variant_flag ?pipeline - pipeline)
    (pipeline_feature_variant_flag ?pipeline - pipeline)
    (pipeline_runner_pool_binding ?pipeline - pipeline ?runner_pool - runner_pool)
    (pipeline_verification_artifact ?pipeline - pipeline)
    (pipeline_tool_compatibility ?pipeline - pipeline ?tool_integration - tool_integration)
  )
  (:action register_pipeline
    :parameters (?pipeline - pipeline)
    :precondition
      (and
        (not
          (pipeline_registered ?pipeline)
        )
        (not
          (pipeline_promoted ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_registered ?pipeline)
      )
  )
  (:action attach_quality_indicator
    :parameters (?pipeline - pipeline ?quality_indicator - quality_indicator)
    :precondition
      (and
        (pipeline_registered ?pipeline)
        (quality_indicator_available ?quality_indicator)
        (pipeline_quality_indicator_compatible ?pipeline ?quality_indicator)
        (not
          (pipeline_quality_indicator_reserved ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_has_quality_indicator ?pipeline ?quality_indicator)
        (pipeline_quality_indicator_reserved ?pipeline)
        (not
          (quality_indicator_available ?quality_indicator)
        )
      )
  )
  (:action detach_quality_indicator
    :parameters (?pipeline - pipeline ?quality_indicator - quality_indicator)
    :precondition
      (and
        (pipeline_has_quality_indicator ?pipeline ?quality_indicator)
        (not
          (pipeline_has_evaluation ?pipeline)
        )
        (not
          (pipeline_ready_for_execution ?pipeline)
        )
      )
    :effect
      (and
        (not
          (pipeline_has_quality_indicator ?pipeline ?quality_indicator)
        )
        (not
          (pipeline_quality_indicator_reserved ?pipeline)
        )
        (not
          (pipeline_runner_activated ?pipeline)
        )
        (not
          (pipeline_analysis_prepared ?pipeline)
        )
        (not
          (pipeline_requires_approval ?pipeline)
        )
        (not
          (pipeline_verification_passed ?pipeline)
        )
        (not
          (pipeline_verification_artifact ?pipeline)
        )
        (quality_indicator_available ?quality_indicator)
      )
  )
  (:action allocate_runner_pool
    :parameters (?pipeline - pipeline ?runner_pool - runner_pool)
    :precondition
      (and
        (pipeline_registered ?pipeline)
        (runner_pool_available ?runner_pool)
      )
    :effect
      (and
        (pipeline_runner_pool_binding ?pipeline ?runner_pool)
        (not
          (runner_pool_available ?runner_pool)
        )
      )
  )
  (:action release_runner_pool
    :parameters (?pipeline - pipeline ?runner_pool - runner_pool)
    :precondition
      (and
        (pipeline_runner_pool_binding ?pipeline ?runner_pool)
      )
    :effect
      (and
        (runner_pool_available ?runner_pool)
        (not
          (pipeline_runner_pool_binding ?pipeline ?runner_pool)
        )
      )
  )
  (:action activate_runner
    :parameters (?pipeline - pipeline ?runner_pool - runner_pool)
    :precondition
      (and
        (pipeline_registered ?pipeline)
        (pipeline_quality_indicator_reserved ?pipeline)
        (pipeline_runner_pool_binding ?pipeline ?runner_pool)
        (not
          (pipeline_runner_activated ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_runner_activated ?pipeline)
      )
  )
  (:action record_approval
    :parameters (?pipeline - pipeline ?approver_identity - approver_identity)
    :precondition
      (and
        (pipeline_registered ?pipeline)
        (pipeline_quality_indicator_reserved ?pipeline)
        (approver_available ?approver_identity)
        (not
          (pipeline_runner_activated ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_runner_activated ?pipeline)
        (pipeline_requires_approval ?pipeline)
        (not
          (approver_available ?approver_identity)
        )
      )
  )
  (:action prepare_pipeline_with_credential
    :parameters (?pipeline - pipeline ?runner_pool - runner_pool ?credential - credential)
    :precondition
      (and
        (pipeline_runner_activated ?pipeline)
        (pipeline_quality_indicator_reserved ?pipeline)
        (pipeline_runner_pool_binding ?pipeline ?runner_pool)
        (credential_available ?credential)
        (not
          (pipeline_analysis_prepared ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_analysis_prepared ?pipeline)
        (not
          (pipeline_requires_approval ?pipeline)
        )
      )
  )
  (:action bind_tool_integration
    :parameters (?pipeline - pipeline ?tool_integration - tool_integration)
    :precondition
      (and
        (pipeline_quality_indicator_reserved ?pipeline)
        (pipeline_tool_bound ?pipeline ?tool_integration)
        (not
          (pipeline_analysis_prepared ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_analysis_prepared ?pipeline)
        (not
          (pipeline_requires_approval ?pipeline)
        )
      )
  )
  (:action bind_analyzer_plugin
    :parameters (?pipeline - pipeline ?analyzer_plugin - analyzer_plugin)
    :precondition
      (and
        (pipeline_registered ?pipeline)
        (analyzer_available ?analyzer_plugin)
        (pipeline_analyzer_compatible ?pipeline ?analyzer_plugin)
      )
    :effect
      (and
        (pipeline_bound_analyzer ?pipeline ?analyzer_plugin)
        (not
          (analyzer_available ?analyzer_plugin)
        )
      )
  )
  (:action unbind_analyzer_plugin
    :parameters (?pipeline - pipeline ?analyzer_plugin - analyzer_plugin)
    :precondition
      (and
        (pipeline_bound_analyzer ?pipeline ?analyzer_plugin)
      )
    :effect
      (and
        (analyzer_available ?analyzer_plugin)
        (not
          (pipeline_bound_analyzer ?pipeline ?analyzer_plugin)
        )
      )
  )
  (:action bind_ruleset
    :parameters (?pipeline - pipeline ?rule_set - rule_set)
    :precondition
      (and
        (pipeline_registered ?pipeline)
        (ruleset_available ?rule_set)
        (pipeline_ruleset_compatible ?pipeline ?rule_set)
      )
    :effect
      (and
        (pipeline_bound_ruleset ?pipeline ?rule_set)
        (not
          (ruleset_available ?rule_set)
        )
      )
  )
  (:action unbind_ruleset
    :parameters (?pipeline - pipeline ?rule_set - rule_set)
    :precondition
      (and
        (pipeline_bound_ruleset ?pipeline ?rule_set)
      )
    :effect
      (and
        (ruleset_available ?rule_set)
        (not
          (pipeline_bound_ruleset ?pipeline ?rule_set)
        )
      )
  )
  (:action bind_scan_engine
    :parameters (?pipeline - pipeline ?scan_engine - scan_engine)
    :precondition
      (and
        (pipeline_registered ?pipeline)
        (scan_engine_available ?scan_engine)
        (pipeline_scan_engine_compatible ?pipeline ?scan_engine)
      )
    :effect
      (and
        (pipeline_bound_scan_engine ?pipeline ?scan_engine)
        (not
          (scan_engine_available ?scan_engine)
        )
      )
  )
  (:action unbind_scan_engine
    :parameters (?pipeline - pipeline ?scan_engine - scan_engine)
    :precondition
      (and
        (pipeline_bound_scan_engine ?pipeline ?scan_engine)
      )
    :effect
      (and
        (scan_engine_available ?scan_engine)
        (not
          (pipeline_bound_scan_engine ?pipeline ?scan_engine)
        )
      )
  )
  (:action stage_threshold_profile
    :parameters (?pipeline - pipeline ?threshold_profile - threshold_profile)
    :precondition
      (and
        (pipeline_registered ?pipeline)
        (threshold_profile_available ?threshold_profile)
        (pipeline_threshold_profile_compatible ?pipeline ?threshold_profile)
      )
    :effect
      (and
        (pipeline_bound_threshold_profile ?pipeline ?threshold_profile)
        (not
          (threshold_profile_available ?threshold_profile)
        )
      )
  )
  (:action unstage_threshold_profile
    :parameters (?pipeline - pipeline ?threshold_profile - threshold_profile)
    :precondition
      (and
        (pipeline_bound_threshold_profile ?pipeline ?threshold_profile)
      )
    :effect
      (and
        (threshold_profile_available ?threshold_profile)
        (not
          (pipeline_bound_threshold_profile ?pipeline ?threshold_profile)
        )
      )
  )
  (:action execute_evaluation_profile
    :parameters (?pipeline - pipeline ?evaluation_profile - evaluation_profile ?analyzer_plugin - analyzer_plugin ?rule_set - rule_set)
    :precondition
      (and
        (pipeline_quality_indicator_reserved ?pipeline)
        (pipeline_bound_analyzer ?pipeline ?analyzer_plugin)
        (pipeline_bound_ruleset ?pipeline ?rule_set)
        (evaluation_profile_available ?evaluation_profile)
        (pipeline_evaluation_profile_compatible ?pipeline ?evaluation_profile)
        (not
          (pipeline_has_evaluation ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_evaluation_result ?pipeline ?evaluation_profile)
        (pipeline_has_evaluation ?pipeline)
        (not
          (evaluation_profile_available ?evaluation_profile)
        )
      )
  )
  (:action execute_evaluation_with_scanner
    :parameters (?pipeline - pipeline ?evaluation_profile - evaluation_profile ?scan_engine - scan_engine ?artifact - artifact)
    :precondition
      (and
        (pipeline_quality_indicator_reserved ?pipeline)
        (pipeline_bound_scan_engine ?pipeline ?scan_engine)
        (artifact_available ?artifact)
        (evaluation_profile_available ?evaluation_profile)
        (pipeline_evaluation_profile_compatible ?pipeline ?evaluation_profile)
        (pipeline_artifact_compatible ?pipeline ?artifact)
        (not
          (pipeline_has_evaluation ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_evaluation_result ?pipeline ?evaluation_profile)
        (pipeline_has_evaluation ?pipeline)
        (pipeline_verification_artifact ?pipeline)
        (pipeline_requires_approval ?pipeline)
        (not
          (evaluation_profile_available ?evaluation_profile)
        )
        (not
          (artifact_available ?artifact)
        )
      )
  )
  (:action verify_evaluation_result
    :parameters (?pipeline - pipeline ?analyzer_plugin - analyzer_plugin ?rule_set - rule_set)
    :precondition
      (and
        (pipeline_has_evaluation ?pipeline)
        (pipeline_verification_artifact ?pipeline)
        (pipeline_bound_analyzer ?pipeline ?analyzer_plugin)
        (pipeline_bound_ruleset ?pipeline ?rule_set)
      )
    :effect
      (and
        (not
          (pipeline_verification_artifact ?pipeline)
        )
        (not
          (pipeline_requires_approval ?pipeline)
        )
      )
  )
  (:action apply_team_policy_approval
    :parameters (?pipeline - pipeline ?analyzer_plugin - analyzer_plugin ?rule_set - rule_set ?team_policy - team_policy)
    :precondition
      (and
        (pipeline_analysis_prepared ?pipeline)
        (pipeline_has_evaluation ?pipeline)
        (pipeline_bound_analyzer ?pipeline ?analyzer_plugin)
        (pipeline_bound_ruleset ?pipeline ?rule_set)
        (pipeline_policy_binding ?pipeline ?team_policy)
        (not
          (pipeline_requires_approval ?pipeline)
        )
        (not
          (pipeline_ready_for_execution ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_ready_for_execution ?pipeline)
      )
  )
  (:action apply_org_policy_approval
    :parameters (?pipeline - pipeline ?scan_engine - scan_engine ?threshold_profile - threshold_profile ?org_policy - org_policy)
    :precondition
      (and
        (pipeline_analysis_prepared ?pipeline)
        (pipeline_has_evaluation ?pipeline)
        (pipeline_bound_scan_engine ?pipeline ?scan_engine)
        (pipeline_bound_threshold_profile ?pipeline ?threshold_profile)
        (pipeline_policy_binding ?pipeline ?org_policy)
        (not
          (pipeline_ready_for_execution ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_ready_for_execution ?pipeline)
        (pipeline_requires_approval ?pipeline)
      )
  )
  (:action finalize_evaluation
    :parameters (?pipeline - pipeline ?analyzer_plugin - analyzer_plugin ?rule_set - rule_set)
    :precondition
      (and
        (pipeline_ready_for_execution ?pipeline)
        (pipeline_requires_approval ?pipeline)
        (pipeline_bound_analyzer ?pipeline ?analyzer_plugin)
        (pipeline_bound_ruleset ?pipeline ?rule_set)
      )
    :effect
      (and
        (pipeline_verification_passed ?pipeline)
        (not
          (pipeline_requires_approval ?pipeline)
        )
        (not
          (pipeline_analysis_prepared ?pipeline)
        )
        (not
          (pipeline_verification_artifact ?pipeline)
        )
      )
  )
  (:action reprepare_pipeline_with_credential
    :parameters (?pipeline - pipeline ?runner_pool - runner_pool ?credential - credential)
    :precondition
      (and
        (pipeline_verification_passed ?pipeline)
        (pipeline_ready_for_execution ?pipeline)
        (pipeline_quality_indicator_reserved ?pipeline)
        (pipeline_runner_pool_binding ?pipeline ?runner_pool)
        (credential_available ?credential)
        (not
          (pipeline_analysis_prepared ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_analysis_prepared ?pipeline)
      )
  )
  (:action stage_threshold_on_runner_pool
    :parameters (?pipeline - pipeline ?runner_pool - runner_pool)
    :precondition
      (and
        (pipeline_ready_for_execution ?pipeline)
        (pipeline_analysis_prepared ?pipeline)
        (not
          (pipeline_requires_approval ?pipeline)
        )
        (pipeline_runner_pool_binding ?pipeline ?runner_pool)
        (not
          (pipeline_staged_for_threshold ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_staged_for_threshold ?pipeline)
      )
  )
  (:action stage_threshold_with_approver
    :parameters (?pipeline - pipeline ?approver_identity - approver_identity)
    :precondition
      (and
        (pipeline_ready_for_execution ?pipeline)
        (pipeline_analysis_prepared ?pipeline)
        (not
          (pipeline_requires_approval ?pipeline)
        )
        (approver_available ?approver_identity)
        (not
          (pipeline_staged_for_threshold ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_staged_for_threshold ?pipeline)
        (not
          (approver_available ?approver_identity)
        )
      )
  )
  (:action apply_threshold_profile_via_tool
    :parameters (?pipeline - pipeline ?tool_integration - tool_integration)
    :precondition
      (and
        (pipeline_staged_for_threshold ?pipeline)
        (tool_integration_available ?tool_integration)
        (pipeline_tool_compatibility ?pipeline ?tool_integration)
      )
    :effect
      (and
        (release_tool_integration_binding ?pipeline ?tool_integration)
        (not
          (tool_integration_available ?tool_integration)
        )
      )
  )
  (:action promote_tool_binding_to_release
    :parameters (?feature_pipeline - feature_pipeline ?release_pipeline - release_pipeline ?tool_integration - tool_integration)
    :precondition
      (and
        (pipeline_registered ?feature_pipeline)
        (pipeline_feature_variant_flag ?feature_pipeline)
        (pipeline_tool_request ?feature_pipeline ?tool_integration)
        (release_tool_integration_binding ?release_pipeline ?tool_integration)
        (not
          (pipeline_tool_bound ?feature_pipeline ?tool_integration)
        )
      )
    :effect
      (and
        (pipeline_tool_bound ?feature_pipeline ?tool_integration)
      )
  )
  (:action mark_pipeline_credentials_ready
    :parameters (?pipeline - pipeline ?runner_pool - runner_pool ?credential - credential)
    :precondition
      (and
        (pipeline_registered ?pipeline)
        (pipeline_feature_variant_flag ?pipeline)
        (pipeline_analysis_prepared ?pipeline)
        (pipeline_staged_for_threshold ?pipeline)
        (pipeline_runner_pool_binding ?pipeline ?runner_pool)
        (credential_available ?credential)
        (not
          (pipeline_credentials_prepared ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_credentials_prepared ?pipeline)
      )
  )
  (:action promote_pipeline_via_final_gate
    :parameters (?pipeline - pipeline)
    :precondition
      (and
        (pipeline_release_variant_flag ?pipeline)
        (pipeline_registered ?pipeline)
        (pipeline_quality_indicator_reserved ?pipeline)
        (pipeline_has_evaluation ?pipeline)
        (pipeline_ready_for_execution ?pipeline)
        (pipeline_staged_for_threshold ?pipeline)
        (pipeline_analysis_prepared ?pipeline)
        (not
          (pipeline_promoted ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_promoted ?pipeline)
      )
  )
  (:action promote_pipeline_with_tool_evidence
    :parameters (?pipeline - pipeline ?tool_integration - tool_integration)
    :precondition
      (and
        (pipeline_feature_variant_flag ?pipeline)
        (pipeline_registered ?pipeline)
        (pipeline_quality_indicator_reserved ?pipeline)
        (pipeline_has_evaluation ?pipeline)
        (pipeline_ready_for_execution ?pipeline)
        (pipeline_staged_for_threshold ?pipeline)
        (pipeline_analysis_prepared ?pipeline)
        (pipeline_tool_bound ?pipeline ?tool_integration)
        (not
          (pipeline_promoted ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_promoted ?pipeline)
      )
  )
  (:action promote_pipeline_with_additional_verification
    :parameters (?pipeline - pipeline)
    :precondition
      (and
        (pipeline_feature_variant_flag ?pipeline)
        (pipeline_registered ?pipeline)
        (pipeline_quality_indicator_reserved ?pipeline)
        (pipeline_has_evaluation ?pipeline)
        (pipeline_ready_for_execution ?pipeline)
        (pipeline_staged_for_threshold ?pipeline)
        (pipeline_analysis_prepared ?pipeline)
        (pipeline_credentials_prepared ?pipeline)
        (not
          (pipeline_promoted ?pipeline)
        )
      )
    :effect
      (and
        (pipeline_promoted ?pipeline)
      )
  )
)

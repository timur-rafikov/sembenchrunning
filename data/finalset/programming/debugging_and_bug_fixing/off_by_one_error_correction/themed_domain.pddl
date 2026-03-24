(define (domain off_by_one_error_correction)
  (:requirements :strips :typing :negative-preconditions)
  (:types analysis_asset - object resource_asset - object candidate_category - object artifact_root - object code_artifact_supertype - artifact_root analysis_resource - analysis_asset failing_test - analysis_asset developer - analysis_asset approval_token - analysis_asset test_oracle - analysis_asset execution_environment - analysis_asset static_analysis_result - analysis_asset triage_tag - analysis_asset diagnostic_hypothesis - resource_asset test_input - resource_asset reporter_identity - resource_asset function_root_cause_candidate - candidate_category module_root_cause_candidate - candidate_category patch_candidate - candidate_category artifact_group - code_artifact_supertype artifact_variant - code_artifact_supertype function - artifact_group module - artifact_group bug_report - artifact_variant)
  (:predicates
    (report_opened ?code_artifact_supertype - code_artifact_supertype)
    (diagnosed ?code_artifact_supertype - code_artifact_supertype)
    (analysis_assigned ?code_artifact_supertype - code_artifact_supertype)
    (fix_applied ?code_artifact_supertype - code_artifact_supertype)
    (artifact_validated ?code_artifact_supertype - code_artifact_supertype)
    (diagnostic_collected ?code_artifact_supertype - code_artifact_supertype)
    (resource_available ?analysis_resource - analysis_resource)
    (assigned_analysis_resource ?code_artifact_supertype - code_artifact_supertype ?analysis_resource - analysis_resource)
    (observation_available ?failing_test - failing_test)
    (observation_linked_to_artifact ?code_artifact_supertype - code_artifact_supertype ?failing_test - failing_test)
    (developer_available ?developer - developer)
    (developer_assigned_to_artifact ?code_artifact_supertype - code_artifact_supertype ?developer - developer)
    (hypothesis_available ?diagnostic_hypothesis - diagnostic_hypothesis)
    (function_hypothesis_link ?function - function ?diagnostic_hypothesis - diagnostic_hypothesis)
    (module_hypothesis_link ?module - module ?diagnostic_hypothesis - diagnostic_hypothesis)
    (function_has_root_cause_candidate ?function - function ?function_root_cause_candidate - function_root_cause_candidate)
    (root_cause_candidate_pending_validation ?function_root_cause_candidate - function_root_cause_candidate)
    (root_cause_candidate_linked_to_hypothesis ?function_root_cause_candidate - function_root_cause_candidate)
    (function_root_cause_confirmed ?function - function)
    (module_has_root_cause_candidate ?module - module ?module_root_cause_candidate - module_root_cause_candidate)
    (module_root_cause_candidate_pending_validation ?module_root_cause_candidate - module_root_cause_candidate)
    (module_root_cause_candidate_linked_to_hypothesis ?module_root_cause_candidate - module_root_cause_candidate)
    (module_root_cause_confirmed ?module - module)
    (patch_candidate_registered ?patch_candidate - patch_candidate)
    (patch_candidate_assembled ?patch_candidate - patch_candidate)
    (patch_targets_function_candidate ?patch_candidate - patch_candidate ?function_root_cause_candidate - function_root_cause_candidate)
    (patch_targets_module_candidate ?patch_candidate - patch_candidate ?module_root_cause_candidate - module_root_cause_candidate)
    (patch_has_function_adjustment ?patch_candidate - patch_candidate)
    (patch_has_module_adjustment ?patch_candidate - patch_candidate)
    (patch_tested ?patch_candidate - patch_candidate)
    (bug_report_affects_function ?bug_report - bug_report ?function - function)
    (bug_report_affects_module ?bug_report - bug_report ?module - module)
    (bug_report_has_patch_candidate ?bug_report - bug_report ?patch_candidate - patch_candidate)
    (test_input_available ?test_input - test_input)
    (bug_report_has_test_input ?bug_report - bug_report ?test_input - test_input)
    (test_input_instrumented ?test_input - test_input)
    (test_input_linked_to_patch ?test_input - test_input ?patch_candidate - patch_candidate)
    (review_in_progress ?bug_report - bug_report)
    (review_ready ?bug_report - bug_report)
    (pre_merge_checks_done ?bug_report - bug_report)
    (approval_requested ?bug_report - bug_report)
    (additional_review_requested ?bug_report - bug_report)
    (static_analysis_summary_attached ?bug_report - bug_report)
    (ready_for_merge ?bug_report - bug_report)
    (reporter_available ?reporter_identity - reporter_identity)
    (bug_report_reporter ?bug_report - bug_report ?reporter_identity - reporter_identity)
    (reporter_acknowledged ?bug_report - bug_report)
    (reporter_approval_requested ?bug_report - bug_report)
    (reporter_approval_provided ?bug_report - bug_report)
    (approval_token_available ?approval_token - approval_token)
    (bug_report_has_approval_token ?bug_report - bug_report ?approval_token - approval_token)
    (test_oracle_available ?test_oracle - test_oracle)
    (bug_report_has_test_oracle ?bug_report - bug_report ?test_oracle - test_oracle)
    (static_analysis_result_available ?static_analysis_result - static_analysis_result)
    (static_analysis_result_attached_to_bug_report ?bug_report - bug_report ?static_analysis_result - static_analysis_result)
    (triage_tag_available ?triage_tag - triage_tag)
    (triage_tag_attached_to_bug_report ?bug_report - bug_report ?triage_tag - triage_tag)
    (execution_environment_available ?execution_environment - execution_environment)
    (artifact_validated_in_environment ?code_artifact_supertype - code_artifact_supertype ?execution_environment - execution_environment)
    (function_ready ?function - function)
    (module_ready ?module - module)
    (bug_report_closed ?bug_report - bug_report)
  )
  (:action open_or_acknowledge_bug_report
    :parameters (?code_artifact_supertype - code_artifact_supertype)
    :precondition
      (and
        (not
          (report_opened ?code_artifact_supertype)
        )
        (not
          (fix_applied ?code_artifact_supertype)
        )
      )
    :effect (report_opened ?code_artifact_supertype)
  )
  (:action assign_analysis_resource
    :parameters (?code_artifact_supertype - code_artifact_supertype ?analysis_resource - analysis_resource)
    :precondition
      (and
        (report_opened ?code_artifact_supertype)
        (not
          (analysis_assigned ?code_artifact_supertype)
        )
        (resource_available ?analysis_resource)
      )
    :effect
      (and
        (analysis_assigned ?code_artifact_supertype)
        (assigned_analysis_resource ?code_artifact_supertype ?analysis_resource)
        (not
          (resource_available ?analysis_resource)
        )
      )
  )
  (:action link_observation_to_artifact
    :parameters (?code_artifact_supertype - code_artifact_supertype ?failing_test - failing_test)
    :precondition
      (and
        (report_opened ?code_artifact_supertype)
        (analysis_assigned ?code_artifact_supertype)
        (observation_available ?failing_test)
      )
    :effect
      (and
        (observation_linked_to_artifact ?code_artifact_supertype ?failing_test)
        (not
          (observation_available ?failing_test)
        )
      )
  )
  (:action confirm_diagnosis
    :parameters (?code_artifact_supertype - code_artifact_supertype ?failing_test - failing_test)
    :precondition
      (and
        (report_opened ?code_artifact_supertype)
        (analysis_assigned ?code_artifact_supertype)
        (observation_linked_to_artifact ?code_artifact_supertype ?failing_test)
        (not
          (diagnosed ?code_artifact_supertype)
        )
      )
    :effect (diagnosed ?code_artifact_supertype)
  )
  (:action unlink_observation_from_artifact
    :parameters (?code_artifact_supertype - code_artifact_supertype ?failing_test - failing_test)
    :precondition
      (and
        (observation_linked_to_artifact ?code_artifact_supertype ?failing_test)
      )
    :effect
      (and
        (observation_available ?failing_test)
        (not
          (observation_linked_to_artifact ?code_artifact_supertype ?failing_test)
        )
      )
  )
  (:action assign_developer
    :parameters (?code_artifact_supertype - code_artifact_supertype ?developer - developer)
    :precondition
      (and
        (diagnosed ?code_artifact_supertype)
        (developer_available ?developer)
      )
    :effect
      (and
        (developer_assigned_to_artifact ?code_artifact_supertype ?developer)
        (not
          (developer_available ?developer)
        )
      )
  )
  (:action unassign_developer
    :parameters (?code_artifact_supertype - code_artifact_supertype ?developer - developer)
    :precondition
      (and
        (developer_assigned_to_artifact ?code_artifact_supertype ?developer)
      )
    :effect
      (and
        (developer_available ?developer)
        (not
          (developer_assigned_to_artifact ?code_artifact_supertype ?developer)
        )
      )
  )
  (:action attach_static_analysis_result
    :parameters (?bug_report - bug_report ?static_analysis_result - static_analysis_result)
    :precondition
      (and
        (diagnosed ?bug_report)
        (static_analysis_result_available ?static_analysis_result)
      )
    :effect
      (and
        (static_analysis_result_attached_to_bug_report ?bug_report ?static_analysis_result)
        (not
          (static_analysis_result_available ?static_analysis_result)
        )
      )
  )
  (:action detach_static_analysis_result
    :parameters (?bug_report - bug_report ?static_analysis_result - static_analysis_result)
    :precondition
      (and
        (static_analysis_result_attached_to_bug_report ?bug_report ?static_analysis_result)
      )
    :effect
      (and
        (static_analysis_result_available ?static_analysis_result)
        (not
          (static_analysis_result_attached_to_bug_report ?bug_report ?static_analysis_result)
        )
      )
  )
  (:action attach_triage_tag
    :parameters (?bug_report - bug_report ?triage_tag - triage_tag)
    :precondition
      (and
        (diagnosed ?bug_report)
        (triage_tag_available ?triage_tag)
      )
    :effect
      (and
        (triage_tag_attached_to_bug_report ?bug_report ?triage_tag)
        (not
          (triage_tag_available ?triage_tag)
        )
      )
  )
  (:action detach_triage_tag
    :parameters (?bug_report - bug_report ?triage_tag - triage_tag)
    :precondition
      (and
        (triage_tag_attached_to_bug_report ?bug_report ?triage_tag)
      )
    :effect
      (and
        (triage_tag_available ?triage_tag)
        (not
          (triage_tag_attached_to_bug_report ?bug_report ?triage_tag)
        )
      )
  )
  (:action generate_function_root_cause_candidate
    :parameters (?function - function ?function_root_cause_candidate - function_root_cause_candidate ?failing_test - failing_test)
    :precondition
      (and
        (diagnosed ?function)
        (observation_linked_to_artifact ?function ?failing_test)
        (function_has_root_cause_candidate ?function ?function_root_cause_candidate)
        (not
          (root_cause_candidate_pending_validation ?function_root_cause_candidate)
        )
        (not
          (root_cause_candidate_linked_to_hypothesis ?function_root_cause_candidate)
        )
      )
    :effect (root_cause_candidate_pending_validation ?function_root_cause_candidate)
  )
  (:action validate_function_candidate_with_developer
    :parameters (?function - function ?function_root_cause_candidate - function_root_cause_candidate ?developer - developer)
    :precondition
      (and
        (diagnosed ?function)
        (developer_assigned_to_artifact ?function ?developer)
        (function_has_root_cause_candidate ?function ?function_root_cause_candidate)
        (root_cause_candidate_pending_validation ?function_root_cause_candidate)
        (not
          (function_ready ?function)
        )
      )
    :effect
      (and
        (function_ready ?function)
        (function_root_cause_confirmed ?function)
      )
  )
  (:action validate_function_candidate_with_hypothesis
    :parameters (?function - function ?function_root_cause_candidate - function_root_cause_candidate ?diagnostic_hypothesis - diagnostic_hypothesis)
    :precondition
      (and
        (diagnosed ?function)
        (function_has_root_cause_candidate ?function ?function_root_cause_candidate)
        (hypothesis_available ?diagnostic_hypothesis)
        (not
          (function_ready ?function)
        )
      )
    :effect
      (and
        (root_cause_candidate_linked_to_hypothesis ?function_root_cause_candidate)
        (function_ready ?function)
        (function_hypothesis_link ?function ?diagnostic_hypothesis)
        (not
          (hypothesis_available ?diagnostic_hypothesis)
        )
      )
  )
  (:action propagate_function_candidate_validation
    :parameters (?function - function ?function_root_cause_candidate - function_root_cause_candidate ?failing_test - failing_test ?diagnostic_hypothesis - diagnostic_hypothesis)
    :precondition
      (and
        (diagnosed ?function)
        (observation_linked_to_artifact ?function ?failing_test)
        (function_has_root_cause_candidate ?function ?function_root_cause_candidate)
        (root_cause_candidate_linked_to_hypothesis ?function_root_cause_candidate)
        (function_hypothesis_link ?function ?diagnostic_hypothesis)
        (not
          (function_root_cause_confirmed ?function)
        )
      )
    :effect
      (and
        (root_cause_candidate_pending_validation ?function_root_cause_candidate)
        (function_root_cause_confirmed ?function)
        (hypothesis_available ?diagnostic_hypothesis)
        (not
          (function_hypothesis_link ?function ?diagnostic_hypothesis)
        )
      )
  )
  (:action generate_module_root_cause_candidate
    :parameters (?module - module ?module_root_cause_candidate - module_root_cause_candidate ?failing_test - failing_test)
    :precondition
      (and
        (diagnosed ?module)
        (observation_linked_to_artifact ?module ?failing_test)
        (module_has_root_cause_candidate ?module ?module_root_cause_candidate)
        (not
          (module_root_cause_candidate_pending_validation ?module_root_cause_candidate)
        )
        (not
          (module_root_cause_candidate_linked_to_hypothesis ?module_root_cause_candidate)
        )
      )
    :effect (module_root_cause_candidate_pending_validation ?module_root_cause_candidate)
  )
  (:action validate_module_candidate_with_developer
    :parameters (?module - module ?module_root_cause_candidate - module_root_cause_candidate ?developer - developer)
    :precondition
      (and
        (diagnosed ?module)
        (developer_assigned_to_artifact ?module ?developer)
        (module_has_root_cause_candidate ?module ?module_root_cause_candidate)
        (module_root_cause_candidate_pending_validation ?module_root_cause_candidate)
        (not
          (module_ready ?module)
        )
      )
    :effect
      (and
        (module_ready ?module)
        (module_root_cause_confirmed ?module)
      )
  )
  (:action validate_module_candidate_with_hypothesis
    :parameters (?module - module ?module_root_cause_candidate - module_root_cause_candidate ?diagnostic_hypothesis - diagnostic_hypothesis)
    :precondition
      (and
        (diagnosed ?module)
        (module_has_root_cause_candidate ?module ?module_root_cause_candidate)
        (hypothesis_available ?diagnostic_hypothesis)
        (not
          (module_ready ?module)
        )
      )
    :effect
      (and
        (module_root_cause_candidate_linked_to_hypothesis ?module_root_cause_candidate)
        (module_ready ?module)
        (module_hypothesis_link ?module ?diagnostic_hypothesis)
        (not
          (hypothesis_available ?diagnostic_hypothesis)
        )
      )
  )
  (:action propagate_module_candidate_validation
    :parameters (?module - module ?module_root_cause_candidate - module_root_cause_candidate ?failing_test - failing_test ?diagnostic_hypothesis - diagnostic_hypothesis)
    :precondition
      (and
        (diagnosed ?module)
        (observation_linked_to_artifact ?module ?failing_test)
        (module_has_root_cause_candidate ?module ?module_root_cause_candidate)
        (module_root_cause_candidate_linked_to_hypothesis ?module_root_cause_candidate)
        (module_hypothesis_link ?module ?diagnostic_hypothesis)
        (not
          (module_root_cause_confirmed ?module)
        )
      )
    :effect
      (and
        (module_root_cause_candidate_pending_validation ?module_root_cause_candidate)
        (module_root_cause_confirmed ?module)
        (hypothesis_available ?diagnostic_hypothesis)
        (not
          (module_hypothesis_link ?module ?diagnostic_hypothesis)
        )
      )
  )
  (:action assemble_patch_candidate
    :parameters (?function - function ?module - module ?function_root_cause_candidate - function_root_cause_candidate ?module_root_cause_candidate - module_root_cause_candidate ?patch_candidate - patch_candidate)
    :precondition
      (and
        (function_ready ?function)
        (module_ready ?module)
        (function_has_root_cause_candidate ?function ?function_root_cause_candidate)
        (module_has_root_cause_candidate ?module ?module_root_cause_candidate)
        (root_cause_candidate_pending_validation ?function_root_cause_candidate)
        (module_root_cause_candidate_pending_validation ?module_root_cause_candidate)
        (function_root_cause_confirmed ?function)
        (module_root_cause_confirmed ?module)
        (patch_candidate_registered ?patch_candidate)
      )
    :effect
      (and
        (patch_candidate_assembled ?patch_candidate)
        (patch_targets_function_candidate ?patch_candidate ?function_root_cause_candidate)
        (patch_targets_module_candidate ?patch_candidate ?module_root_cause_candidate)
        (not
          (patch_candidate_registered ?patch_candidate)
        )
      )
  )
  (:action assemble_patch_candidate_with_function_adjustment
    :parameters (?function - function ?module - module ?function_root_cause_candidate - function_root_cause_candidate ?module_root_cause_candidate - module_root_cause_candidate ?patch_candidate - patch_candidate)
    :precondition
      (and
        (function_ready ?function)
        (module_ready ?module)
        (function_has_root_cause_candidate ?function ?function_root_cause_candidate)
        (module_has_root_cause_candidate ?module ?module_root_cause_candidate)
        (root_cause_candidate_linked_to_hypothesis ?function_root_cause_candidate)
        (module_root_cause_candidate_pending_validation ?module_root_cause_candidate)
        (not
          (function_root_cause_confirmed ?function)
        )
        (module_root_cause_confirmed ?module)
        (patch_candidate_registered ?patch_candidate)
      )
    :effect
      (and
        (patch_candidate_assembled ?patch_candidate)
        (patch_targets_function_candidate ?patch_candidate ?function_root_cause_candidate)
        (patch_targets_module_candidate ?patch_candidate ?module_root_cause_candidate)
        (patch_has_function_adjustment ?patch_candidate)
        (not
          (patch_candidate_registered ?patch_candidate)
        )
      )
  )
  (:action assemble_patch_candidate_with_module_adjustment
    :parameters (?function - function ?module - module ?function_root_cause_candidate - function_root_cause_candidate ?module_root_cause_candidate - module_root_cause_candidate ?patch_candidate - patch_candidate)
    :precondition
      (and
        (function_ready ?function)
        (module_ready ?module)
        (function_has_root_cause_candidate ?function ?function_root_cause_candidate)
        (module_has_root_cause_candidate ?module ?module_root_cause_candidate)
        (root_cause_candidate_pending_validation ?function_root_cause_candidate)
        (module_root_cause_candidate_linked_to_hypothesis ?module_root_cause_candidate)
        (function_root_cause_confirmed ?function)
        (not
          (module_root_cause_confirmed ?module)
        )
        (patch_candidate_registered ?patch_candidate)
      )
    :effect
      (and
        (patch_candidate_assembled ?patch_candidate)
        (patch_targets_function_candidate ?patch_candidate ?function_root_cause_candidate)
        (patch_targets_module_candidate ?patch_candidate ?module_root_cause_candidate)
        (patch_has_module_adjustment ?patch_candidate)
        (not
          (patch_candidate_registered ?patch_candidate)
        )
      )
  )
  (:action assemble_patch_candidate_with_function_and_module_adjustments
    :parameters (?function - function ?module - module ?function_root_cause_candidate - function_root_cause_candidate ?module_root_cause_candidate - module_root_cause_candidate ?patch_candidate - patch_candidate)
    :precondition
      (and
        (function_ready ?function)
        (module_ready ?module)
        (function_has_root_cause_candidate ?function ?function_root_cause_candidate)
        (module_has_root_cause_candidate ?module ?module_root_cause_candidate)
        (root_cause_candidate_linked_to_hypothesis ?function_root_cause_candidate)
        (module_root_cause_candidate_linked_to_hypothesis ?module_root_cause_candidate)
        (not
          (function_root_cause_confirmed ?function)
        )
        (not
          (module_root_cause_confirmed ?module)
        )
        (patch_candidate_registered ?patch_candidate)
      )
    :effect
      (and
        (patch_candidate_assembled ?patch_candidate)
        (patch_targets_function_candidate ?patch_candidate ?function_root_cause_candidate)
        (patch_targets_module_candidate ?patch_candidate ?module_root_cause_candidate)
        (patch_has_function_adjustment ?patch_candidate)
        (patch_has_module_adjustment ?patch_candidate)
        (not
          (patch_candidate_registered ?patch_candidate)
        )
      )
  )
  (:action execute_test_on_patch_candidate
    :parameters (?patch_candidate - patch_candidate ?function - function ?failing_test - failing_test)
    :precondition
      (and
        (patch_candidate_assembled ?patch_candidate)
        (function_ready ?function)
        (observation_linked_to_artifact ?function ?failing_test)
        (not
          (patch_tested ?patch_candidate)
        )
      )
    :effect (patch_tested ?patch_candidate)
  )
  (:action instrument_test_input_for_patch
    :parameters (?bug_report - bug_report ?test_input - test_input ?patch_candidate - patch_candidate)
    :precondition
      (and
        (diagnosed ?bug_report)
        (bug_report_has_patch_candidate ?bug_report ?patch_candidate)
        (bug_report_has_test_input ?bug_report ?test_input)
        (test_input_available ?test_input)
        (patch_candidate_assembled ?patch_candidate)
        (patch_tested ?patch_candidate)
        (not
          (test_input_instrumented ?test_input)
        )
      )
    :effect
      (and
        (test_input_instrumented ?test_input)
        (test_input_linked_to_patch ?test_input ?patch_candidate)
        (not
          (test_input_available ?test_input)
        )
      )
  )
  (:action mark_test_input_instrumented
    :parameters (?bug_report - bug_report ?test_input - test_input ?patch_candidate - patch_candidate ?failing_test - failing_test)
    :precondition
      (and
        (diagnosed ?bug_report)
        (bug_report_has_test_input ?bug_report ?test_input)
        (test_input_instrumented ?test_input)
        (test_input_linked_to_patch ?test_input ?patch_candidate)
        (observation_linked_to_artifact ?bug_report ?failing_test)
        (not
          (patch_has_function_adjustment ?patch_candidate)
        )
        (not
          (review_in_progress ?bug_report)
        )
      )
    :effect (review_in_progress ?bug_report)
  )
  (:action request_stakeholder_approval
    :parameters (?bug_report - bug_report ?approval_token - approval_token)
    :precondition
      (and
        (diagnosed ?bug_report)
        (approval_token_available ?approval_token)
        (not
          (approval_requested ?bug_report)
        )
      )
    :effect
      (and
        (approval_requested ?bug_report)
        (bug_report_has_approval_token ?bug_report ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action start_review_iteration_with_approval
    :parameters (?bug_report - bug_report ?test_input - test_input ?patch_candidate - patch_candidate ?failing_test - failing_test ?approval_token - approval_token)
    :precondition
      (and
        (diagnosed ?bug_report)
        (bug_report_has_test_input ?bug_report ?test_input)
        (test_input_instrumented ?test_input)
        (test_input_linked_to_patch ?test_input ?patch_candidate)
        (observation_linked_to_artifact ?bug_report ?failing_test)
        (patch_has_function_adjustment ?patch_candidate)
        (approval_requested ?bug_report)
        (bug_report_has_approval_token ?bug_report ?approval_token)
        (not
          (review_in_progress ?bug_report)
        )
      )
    :effect
      (and
        (review_in_progress ?bug_report)
        (additional_review_requested ?bug_report)
      )
  )
  (:action perform_peer_review_iteration
    :parameters (?bug_report - bug_report ?static_analysis_result - static_analysis_result ?developer - developer ?test_input - test_input ?patch_candidate - patch_candidate)
    :precondition
      (and
        (review_in_progress ?bug_report)
        (static_analysis_result_attached_to_bug_report ?bug_report ?static_analysis_result)
        (developer_assigned_to_artifact ?bug_report ?developer)
        (bug_report_has_test_input ?bug_report ?test_input)
        (test_input_linked_to_patch ?test_input ?patch_candidate)
        (not
          (patch_has_module_adjustment ?patch_candidate)
        )
        (not
          (review_ready ?bug_report)
        )
      )
    :effect (review_ready ?bug_report)
  )
  (:action perform_peer_review_iteration_variant
    :parameters (?bug_report - bug_report ?static_analysis_result - static_analysis_result ?developer - developer ?test_input - test_input ?patch_candidate - patch_candidate)
    :precondition
      (and
        (review_in_progress ?bug_report)
        (static_analysis_result_attached_to_bug_report ?bug_report ?static_analysis_result)
        (developer_assigned_to_artifact ?bug_report ?developer)
        (bug_report_has_test_input ?bug_report ?test_input)
        (test_input_linked_to_patch ?test_input ?patch_candidate)
        (patch_has_module_adjustment ?patch_candidate)
        (not
          (review_ready ?bug_report)
        )
      )
    :effect (review_ready ?bug_report)
  )
  (:action perform_pre_merge_checks
    :parameters (?bug_report - bug_report ?triage_tag - triage_tag ?test_input - test_input ?patch_candidate - patch_candidate)
    :precondition
      (and
        (review_ready ?bug_report)
        (triage_tag_attached_to_bug_report ?bug_report ?triage_tag)
        (bug_report_has_test_input ?bug_report ?test_input)
        (test_input_linked_to_patch ?test_input ?patch_candidate)
        (not
          (patch_has_function_adjustment ?patch_candidate)
        )
        (not
          (patch_has_module_adjustment ?patch_candidate)
        )
        (not
          (pre_merge_checks_done ?bug_report)
        )
      )
    :effect (pre_merge_checks_done ?bug_report)
  )
  (:action complete_review_step_with_analysis_attachment
    :parameters (?bug_report - bug_report ?triage_tag - triage_tag ?test_input - test_input ?patch_candidate - patch_candidate)
    :precondition
      (and
        (review_ready ?bug_report)
        (triage_tag_attached_to_bug_report ?bug_report ?triage_tag)
        (bug_report_has_test_input ?bug_report ?test_input)
        (test_input_linked_to_patch ?test_input ?patch_candidate)
        (patch_has_function_adjustment ?patch_candidate)
        (not
          (patch_has_module_adjustment ?patch_candidate)
        )
        (not
          (pre_merge_checks_done ?bug_report)
        )
      )
    :effect
      (and
        (pre_merge_checks_done ?bug_report)
        (static_analysis_summary_attached ?bug_report)
      )
  )
  (:action complete_review_step_variant
    :parameters (?bug_report - bug_report ?triage_tag - triage_tag ?test_input - test_input ?patch_candidate - patch_candidate)
    :precondition
      (and
        (review_ready ?bug_report)
        (triage_tag_attached_to_bug_report ?bug_report ?triage_tag)
        (bug_report_has_test_input ?bug_report ?test_input)
        (test_input_linked_to_patch ?test_input ?patch_candidate)
        (not
          (patch_has_function_adjustment ?patch_candidate)
        )
        (patch_has_module_adjustment ?patch_candidate)
        (not
          (pre_merge_checks_done ?bug_report)
        )
      )
    :effect
      (and
        (pre_merge_checks_done ?bug_report)
        (static_analysis_summary_attached ?bug_report)
      )
  )
  (:action complete_review_step_comprehensive
    :parameters (?bug_report - bug_report ?triage_tag - triage_tag ?test_input - test_input ?patch_candidate - patch_candidate)
    :precondition
      (and
        (review_ready ?bug_report)
        (triage_tag_attached_to_bug_report ?bug_report ?triage_tag)
        (bug_report_has_test_input ?bug_report ?test_input)
        (test_input_linked_to_patch ?test_input ?patch_candidate)
        (patch_has_function_adjustment ?patch_candidate)
        (patch_has_module_adjustment ?patch_candidate)
        (not
          (pre_merge_checks_done ?bug_report)
        )
      )
    :effect
      (and
        (pre_merge_checks_done ?bug_report)
        (static_analysis_summary_attached ?bug_report)
      )
  )
  (:action finalize_and_mark_validated
    :parameters (?bug_report - bug_report)
    :precondition
      (and
        (pre_merge_checks_done ?bug_report)
        (not
          (static_analysis_summary_attached ?bug_report)
        )
        (not
          (bug_report_closed ?bug_report)
        )
      )
    :effect
      (and
        (bug_report_closed ?bug_report)
        (artifact_validated ?bug_report)
      )
  )
  (:action attach_test_oracle
    :parameters (?bug_report - bug_report ?test_oracle - test_oracle)
    :precondition
      (and
        (pre_merge_checks_done ?bug_report)
        (static_analysis_summary_attached ?bug_report)
        (test_oracle_available ?test_oracle)
      )
    :effect
      (and
        (bug_report_has_test_oracle ?bug_report ?test_oracle)
        (not
          (test_oracle_available ?test_oracle)
        )
      )
  )
  (:action perform_integration_checks_for_patch
    :parameters (?bug_report - bug_report ?function - function ?module - module ?failing_test - failing_test ?test_oracle - test_oracle)
    :precondition
      (and
        (pre_merge_checks_done ?bug_report)
        (static_analysis_summary_attached ?bug_report)
        (bug_report_has_test_oracle ?bug_report ?test_oracle)
        (bug_report_affects_function ?bug_report ?function)
        (bug_report_affects_module ?bug_report ?module)
        (function_root_cause_confirmed ?function)
        (module_root_cause_confirmed ?module)
        (observation_linked_to_artifact ?bug_report ?failing_test)
        (not
          (ready_for_merge ?bug_report)
        )
      )
    :effect (ready_for_merge ?bug_report)
  )
  (:action merge_patch_and_close_report
    :parameters (?bug_report - bug_report)
    :precondition
      (and
        (pre_merge_checks_done ?bug_report)
        (ready_for_merge ?bug_report)
        (not
          (bug_report_closed ?bug_report)
        )
      )
    :effect
      (and
        (bug_report_closed ?bug_report)
        (artifact_validated ?bug_report)
      )
  )
  (:action request_reporter_acknowledgement
    :parameters (?bug_report - bug_report ?reporter_identity - reporter_identity ?failing_test - failing_test)
    :precondition
      (and
        (diagnosed ?bug_report)
        (observation_linked_to_artifact ?bug_report ?failing_test)
        (reporter_available ?reporter_identity)
        (bug_report_reporter ?bug_report ?reporter_identity)
        (not
          (reporter_acknowledged ?bug_report)
        )
      )
    :effect
      (and
        (reporter_acknowledged ?bug_report)
        (not
          (reporter_available ?reporter_identity)
        )
      )
  )
  (:action request_reporter_approval
    :parameters (?bug_report - bug_report ?developer - developer)
    :precondition
      (and
        (reporter_acknowledged ?bug_report)
        (developer_assigned_to_artifact ?bug_report ?developer)
        (not
          (reporter_approval_requested ?bug_report)
        )
      )
    :effect (reporter_approval_requested ?bug_report)
  )
  (:action confirm_reporter_approval
    :parameters (?bug_report - bug_report ?triage_tag - triage_tag)
    :precondition
      (and
        (reporter_approval_requested ?bug_report)
        (triage_tag_attached_to_bug_report ?bug_report ?triage_tag)
        (not
          (reporter_approval_provided ?bug_report)
        )
      )
    :effect (reporter_approval_provided ?bug_report)
  )
  (:action finalize_after_reporter_approval
    :parameters (?bug_report - bug_report)
    :precondition
      (and
        (reporter_approval_provided ?bug_report)
        (not
          (bug_report_closed ?bug_report)
        )
      )
    :effect
      (and
        (bug_report_closed ?bug_report)
        (artifact_validated ?bug_report)
      )
  )
  (:action apply_patch_to_function
    :parameters (?function - function ?patch_candidate - patch_candidate)
    :precondition
      (and
        (function_ready ?function)
        (function_root_cause_confirmed ?function)
        (patch_candidate_assembled ?patch_candidate)
        (patch_tested ?patch_candidate)
        (not
          (artifact_validated ?function)
        )
      )
    :effect (artifact_validated ?function)
  )
  (:action apply_patch_to_module
    :parameters (?module - module ?patch_candidate - patch_candidate)
    :precondition
      (and
        (module_ready ?module)
        (module_root_cause_confirmed ?module)
        (patch_candidate_assembled ?patch_candidate)
        (patch_tested ?patch_candidate)
        (not
          (artifact_validated ?module)
        )
      )
    :effect (artifact_validated ?module)
  )
  (:action collect_diagnostics_and_reserve_environment
    :parameters (?code_artifact_supertype - code_artifact_supertype ?execution_environment - execution_environment ?failing_test - failing_test)
    :precondition
      (and
        (artifact_validated ?code_artifact_supertype)
        (observation_linked_to_artifact ?code_artifact_supertype ?failing_test)
        (execution_environment_available ?execution_environment)
        (not
          (diagnostic_collected ?code_artifact_supertype)
        )
      )
    :effect
      (and
        (diagnostic_collected ?code_artifact_supertype)
        (artifact_validated_in_environment ?code_artifact_supertype ?execution_environment)
        (not
          (execution_environment_available ?execution_environment)
        )
      )
  )
  (:action apply_patch_to_function_and_release_resources
    :parameters (?function - function ?analysis_resource - analysis_resource ?execution_environment - execution_environment)
    :precondition
      (and
        (diagnostic_collected ?function)
        (assigned_analysis_resource ?function ?analysis_resource)
        (artifact_validated_in_environment ?function ?execution_environment)
        (not
          (fix_applied ?function)
        )
      )
    :effect
      (and
        (fix_applied ?function)
        (resource_available ?analysis_resource)
        (execution_environment_available ?execution_environment)
      )
  )
  (:action apply_patch_to_module_and_release_resources
    :parameters (?module - module ?analysis_resource - analysis_resource ?execution_environment - execution_environment)
    :precondition
      (and
        (diagnostic_collected ?module)
        (assigned_analysis_resource ?module ?analysis_resource)
        (artifact_validated_in_environment ?module ?execution_environment)
        (not
          (fix_applied ?module)
        )
      )
    :effect
      (and
        (fix_applied ?module)
        (resource_available ?analysis_resource)
        (execution_environment_available ?execution_environment)
      )
  )
  (:action apply_patch_to_report_and_release_resources
    :parameters (?bug_report - bug_report ?analysis_resource - analysis_resource ?execution_environment - execution_environment)
    :precondition
      (and
        (diagnostic_collected ?bug_report)
        (assigned_analysis_resource ?bug_report ?analysis_resource)
        (artifact_validated_in_environment ?bug_report ?execution_environment)
        (not
          (fix_applied ?bug_report)
        )
      )
    :effect
      (and
        (fix_applied ?bug_report)
        (resource_available ?analysis_resource)
        (execution_environment_available ?execution_environment)
      )
  )
)

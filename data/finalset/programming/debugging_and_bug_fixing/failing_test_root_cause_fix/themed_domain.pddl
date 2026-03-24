(define (domain failing_test_root_cause_fix)
  (:requirements :strips :typing :negative-preconditions)
  (:types metadata_tag - object resource_category - object external_artifact - object root_entity - object investigation_item - root_entity instrumentation_resource - metadata_tag test_execution_record - metadata_tag developer_tag - metadata_tag label - metadata_tag review_token - metadata_tag environment_configuration - metadata_tag analysis_tool - metadata_tag runtime_flag - metadata_tag patch_fragment - resource_category test_fixture - resource_category issue_ticket - resource_category code_location - external_artifact module - external_artifact build_or_pr - external_artifact test_family - investigation_item change_family - investigation_item failing_test_case - test_family related_test_case - test_family candidate_fix - change_family)
  (:predicates
    (investigation_item_identified ?artifact - investigation_item)
    (analysis_completed ?artifact - investigation_item)
    (instrumentation_attached ?artifact - investigation_item)
    (fix_applied ?artifact - investigation_item)
    (investigation_item_verified ?artifact - investigation_item)
    (fix_staged ?artifact - investigation_item)
    (instrumentation_available ?instrumentation_resource - instrumentation_resource)
    (instrumentation_assigned ?artifact - investigation_item ?instrumentation_resource - instrumentation_resource)
    (execution_record_available ?test_execution_record - test_execution_record)
    (investigation_item_execution_record ?artifact - investigation_item ?test_execution_record - test_execution_record)
    (developer_available ?developer - developer_tag)
    (investigation_item_assigned_to ?artifact - investigation_item ?developer - developer_tag)
    (patch_fragment_available ?patch_fragment - patch_fragment)
    (failing_test_has_patch_fragment ?failing_test_case - failing_test_case ?patch_fragment - patch_fragment)
    (related_test_has_patch_fragment ?related_test_case - related_test_case ?patch_fragment - patch_fragment)
    (test_localized_to ?failing_test_case - failing_test_case ?code_location - code_location)
    (code_location_confirmed ?code_location - code_location)
    (code_location_has_suggestion ?code_location - code_location)
    (root_cause_localized ?failing_test_case - failing_test_case)
    (related_test_mapped_to_module ?related_test_case - related_test_case ?module - module)
    (module_confirmed ?module - module)
    (module_has_suggestion ?module - module)
    (related_test_root_cause_localized ?related_test_case - related_test_case)
    (build_pr_available ?build_or_pr - build_or_pr)
    (build_staged ?build_or_pr - build_or_pr)
    (build_targets_code_location ?build_or_pr - build_or_pr ?code_location - code_location)
    (build_targets_module ?build_or_pr - build_or_pr ?module - module)
    (build_includes_optional_resource ?build_or_pr - build_or_pr)
    (build_includes_optional_component ?build_or_pr - build_or_pr)
    (build_ci_validated ?build_or_pr - build_or_pr)
    (candidate_targets_failing_test ?candidate_fix - candidate_fix ?failing_test_case - failing_test_case)
    (candidate_targets_related_test ?candidate_fix - candidate_fix ?related_test_case - related_test_case)
    (candidate_in_build ?candidate_fix - candidate_fix ?build_or_pr - build_or_pr)
    (fixture_available ?test_fixture - test_fixture)
    (candidate_requires_fixture ?candidate_fix - candidate_fix ?test_fixture - test_fixture)
    (fixture_attached ?test_fixture - test_fixture)
    (fixture_in_build ?test_fixture - test_fixture ?build_or_pr - build_or_pr)
    (candidate_prepared ?candidate_fix - candidate_fix)
    (candidate_instrumented ?candidate_fix - candidate_fix)
    (candidate_validation_passed ?candidate_fix - candidate_fix)
    (candidate_labeled ?candidate_fix - candidate_fix)
    (candidate_flagged_extra ?candidate_fix - candidate_fix)
    (candidate_review_ready ?candidate_fix - candidate_fix)
    (candidate_finalized ?candidate_fix - candidate_fix)
    (issue_ticket_available ?issue_ticket - issue_ticket)
    (candidate_linked_to_issue ?candidate_fix - candidate_fix ?issue_ticket - issue_ticket)
    (candidate_issue_link_confirmed ?candidate_fix - candidate_fix)
    (review_initiated ?candidate_fix - candidate_fix)
    (review_completed ?candidate_fix - candidate_fix)
    (label_available ?label - label)
    (candidate_has_label ?candidate_fix - candidate_fix ?label - label)
    (review_token_available ?review_token - review_token)
    (candidate_has_review_token ?candidate_fix - candidate_fix ?review_token - review_token)
    (analysis_tool_available ?analysis_tool - analysis_tool)
    (candidate_has_analysis_tool ?candidate_fix - candidate_fix ?analysis_tool - analysis_tool)
    (runtime_flag_available ?runtime_flag - runtime_flag)
    (candidate_has_runtime_flag ?candidate_fix - candidate_fix ?runtime_flag - runtime_flag)
    (env_config_available ?environment_configuration - environment_configuration)
    (investigation_item_bound_to_environment_configuration ?artifact - investigation_item ?environment_configuration - environment_configuration)
    (test_ready_for_patch_bundle ?failing_test_case - failing_test_case)
    (related_test_ready_for_patch_bundle ?related_test_case - related_test_case)
    (candidate_signoff ?candidate_fix - candidate_fix)
  )
  (:action identify_artifact
    :parameters (?artifact - investigation_item)
    :precondition
      (and
        (not
          (investigation_item_identified ?artifact)
        )
        (not
          (fix_applied ?artifact)
        )
      )
    :effect (investigation_item_identified ?artifact)
  )
  (:action assign_instrumentation_to_artifact
    :parameters (?artifact - investigation_item ?instrumentation_resource - instrumentation_resource)
    :precondition
      (and
        (investigation_item_identified ?artifact)
        (not
          (instrumentation_attached ?artifact)
        )
        (instrumentation_available ?instrumentation_resource)
      )
    :effect
      (and
        (instrumentation_attached ?artifact)
        (instrumentation_assigned ?artifact ?instrumentation_resource)
        (not
          (instrumentation_available ?instrumentation_resource)
        )
      )
  )
  (:action attach_execution_record_to_artifact
    :parameters (?artifact - investigation_item ?test_execution_record - test_execution_record)
    :precondition
      (and
        (investigation_item_identified ?artifact)
        (instrumentation_attached ?artifact)
        (execution_record_available ?test_execution_record)
      )
    :effect
      (and
        (investigation_item_execution_record ?artifact ?test_execution_record)
        (not
          (execution_record_available ?test_execution_record)
        )
      )
  )
  (:action mark_analysis_complete
    :parameters (?artifact - investigation_item ?test_execution_record - test_execution_record)
    :precondition
      (and
        (investigation_item_identified ?artifact)
        (instrumentation_attached ?artifact)
        (investigation_item_execution_record ?artifact ?test_execution_record)
        (not
          (analysis_completed ?artifact)
        )
      )
    :effect (analysis_completed ?artifact)
  )
  (:action release_execution_record
    :parameters (?artifact - investigation_item ?test_execution_record - test_execution_record)
    :precondition
      (and
        (investigation_item_execution_record ?artifact ?test_execution_record)
      )
    :effect
      (and
        (execution_record_available ?test_execution_record)
        (not
          (investigation_item_execution_record ?artifact ?test_execution_record)
        )
      )
  )
  (:action assign_developer_to_artifact
    :parameters (?artifact - investigation_item ?developer - developer_tag)
    :precondition
      (and
        (analysis_completed ?artifact)
        (developer_available ?developer)
      )
    :effect
      (and
        (investigation_item_assigned_to ?artifact ?developer)
        (not
          (developer_available ?developer)
        )
      )
  )
  (:action unassign_developer_from_artifact
    :parameters (?artifact - investigation_item ?developer - developer_tag)
    :precondition
      (and
        (investigation_item_assigned_to ?artifact ?developer)
      )
    :effect
      (and
        (developer_available ?developer)
        (not
          (investigation_item_assigned_to ?artifact ?developer)
        )
      )
  )
  (:action attach_analysis_tool_to_candidate
    :parameters (?candidate_fix - candidate_fix ?analysis_tool - analysis_tool)
    :precondition
      (and
        (analysis_completed ?candidate_fix)
        (analysis_tool_available ?analysis_tool)
      )
    :effect
      (and
        (candidate_has_analysis_tool ?candidate_fix ?analysis_tool)
        (not
          (analysis_tool_available ?analysis_tool)
        )
      )
  )
  (:action detach_analysis_tool_from_candidate
    :parameters (?candidate_fix - candidate_fix ?analysis_tool - analysis_tool)
    :precondition
      (and
        (candidate_has_analysis_tool ?candidate_fix ?analysis_tool)
      )
    :effect
      (and
        (analysis_tool_available ?analysis_tool)
        (not
          (candidate_has_analysis_tool ?candidate_fix ?analysis_tool)
        )
      )
  )
  (:action attach_runtime_flag_to_candidate
    :parameters (?candidate_fix - candidate_fix ?runtime_flag - runtime_flag)
    :precondition
      (and
        (analysis_completed ?candidate_fix)
        (runtime_flag_available ?runtime_flag)
      )
    :effect
      (and
        (candidate_has_runtime_flag ?candidate_fix ?runtime_flag)
        (not
          (runtime_flag_available ?runtime_flag)
        )
      )
  )
  (:action detach_runtime_flag_from_candidate
    :parameters (?candidate_fix - candidate_fix ?runtime_flag - runtime_flag)
    :precondition
      (and
        (candidate_has_runtime_flag ?candidate_fix ?runtime_flag)
      )
    :effect
      (and
        (runtime_flag_available ?runtime_flag)
        (not
          (candidate_has_runtime_flag ?candidate_fix ?runtime_flag)
        )
      )
  )
  (:action confirm_code_location_evidence
    :parameters (?failing_test_case - failing_test_case ?code_location - code_location ?test_execution_record - test_execution_record)
    :precondition
      (and
        (analysis_completed ?failing_test_case)
        (investigation_item_execution_record ?failing_test_case ?test_execution_record)
        (test_localized_to ?failing_test_case ?code_location)
        (not
          (code_location_confirmed ?code_location)
        )
        (not
          (code_location_has_suggestion ?code_location)
        )
      )
    :effect (code_location_confirmed ?code_location)
  )
  (:action developer_confirms_localization
    :parameters (?failing_test_case - failing_test_case ?code_location - code_location ?developer - developer_tag)
    :precondition
      (and
        (analysis_completed ?failing_test_case)
        (investigation_item_assigned_to ?failing_test_case ?developer)
        (test_localized_to ?failing_test_case ?code_location)
        (code_location_confirmed ?code_location)
        (not
          (test_ready_for_patch_bundle ?failing_test_case)
        )
      )
    :effect
      (and
        (test_ready_for_patch_bundle ?failing_test_case)
        (root_cause_localized ?failing_test_case)
      )
  )
  (:action propose_patch_fragment_for_localization
    :parameters (?failing_test_case - failing_test_case ?code_location - code_location ?patch_fragment - patch_fragment)
    :precondition
      (and
        (analysis_completed ?failing_test_case)
        (test_localized_to ?failing_test_case ?code_location)
        (patch_fragment_available ?patch_fragment)
        (not
          (test_ready_for_patch_bundle ?failing_test_case)
        )
      )
    :effect
      (and
        (code_location_has_suggestion ?code_location)
        (test_ready_for_patch_bundle ?failing_test_case)
        (failing_test_has_patch_fragment ?failing_test_case ?patch_fragment)
        (not
          (patch_fragment_available ?patch_fragment)
        )
      )
  )
  (:action update_localization_from_patch_and_trace
    :parameters (?failing_test_case - failing_test_case ?code_location - code_location ?test_execution_record - test_execution_record ?patch_fragment - patch_fragment)
    :precondition
      (and
        (analysis_completed ?failing_test_case)
        (investigation_item_execution_record ?failing_test_case ?test_execution_record)
        (test_localized_to ?failing_test_case ?code_location)
        (code_location_has_suggestion ?code_location)
        (failing_test_has_patch_fragment ?failing_test_case ?patch_fragment)
        (not
          (root_cause_localized ?failing_test_case)
        )
      )
    :effect
      (and
        (code_location_confirmed ?code_location)
        (root_cause_localized ?failing_test_case)
        (patch_fragment_available ?patch_fragment)
        (not
          (failing_test_has_patch_fragment ?failing_test_case ?patch_fragment)
        )
      )
  )
  (:action confirm_module_for_related_test
    :parameters (?related_test_case - related_test_case ?module - module ?test_execution_record - test_execution_record)
    :precondition
      (and
        (analysis_completed ?related_test_case)
        (investigation_item_execution_record ?related_test_case ?test_execution_record)
        (related_test_mapped_to_module ?related_test_case ?module)
        (not
          (module_confirmed ?module)
        )
        (not
          (module_has_suggestion ?module)
        )
      )
    :effect (module_confirmed ?module)
  )
  (:action developer_confirms_related_test_localization
    :parameters (?related_test_case - related_test_case ?module - module ?developer - developer_tag)
    :precondition
      (and
        (analysis_completed ?related_test_case)
        (investigation_item_assigned_to ?related_test_case ?developer)
        (related_test_mapped_to_module ?related_test_case ?module)
        (module_confirmed ?module)
        (not
          (related_test_ready_for_patch_bundle ?related_test_case)
        )
      )
    :effect
      (and
        (related_test_ready_for_patch_bundle ?related_test_case)
        (related_test_root_cause_localized ?related_test_case)
      )
  )
  (:action propose_patch_for_related_test
    :parameters (?related_test_case - related_test_case ?module - module ?patch_fragment - patch_fragment)
    :precondition
      (and
        (analysis_completed ?related_test_case)
        (related_test_mapped_to_module ?related_test_case ?module)
        (patch_fragment_available ?patch_fragment)
        (not
          (related_test_ready_for_patch_bundle ?related_test_case)
        )
      )
    :effect
      (and
        (module_has_suggestion ?module)
        (related_test_ready_for_patch_bundle ?related_test_case)
        (related_test_has_patch_fragment ?related_test_case ?patch_fragment)
        (not
          (patch_fragment_available ?patch_fragment)
        )
      )
  )
  (:action update_related_test_from_patch_and_trace
    :parameters (?related_test_case - related_test_case ?module - module ?test_execution_record - test_execution_record ?patch_fragment - patch_fragment)
    :precondition
      (and
        (analysis_completed ?related_test_case)
        (investigation_item_execution_record ?related_test_case ?test_execution_record)
        (related_test_mapped_to_module ?related_test_case ?module)
        (module_has_suggestion ?module)
        (related_test_has_patch_fragment ?related_test_case ?patch_fragment)
        (not
          (related_test_root_cause_localized ?related_test_case)
        )
      )
    :effect
      (and
        (module_confirmed ?module)
        (related_test_root_cause_localized ?related_test_case)
        (patch_fragment_available ?patch_fragment)
        (not
          (related_test_has_patch_fragment ?related_test_case ?patch_fragment)
        )
      )
  )
  (:action construct_patch_bundle
    :parameters (?failing_test_case - failing_test_case ?related_test_case - related_test_case ?code_location - code_location ?module - module ?build_or_pr - build_or_pr)
    :precondition
      (and
        (test_ready_for_patch_bundle ?failing_test_case)
        (related_test_ready_for_patch_bundle ?related_test_case)
        (test_localized_to ?failing_test_case ?code_location)
        (related_test_mapped_to_module ?related_test_case ?module)
        (code_location_confirmed ?code_location)
        (module_confirmed ?module)
        (root_cause_localized ?failing_test_case)
        (related_test_root_cause_localized ?related_test_case)
        (build_pr_available ?build_or_pr)
      )
    :effect
      (and
        (build_staged ?build_or_pr)
        (build_targets_code_location ?build_or_pr ?code_location)
        (build_targets_module ?build_or_pr ?module)
        (not
          (build_pr_available ?build_or_pr)
        )
      )
  )
  (:action construct_patch_bundle_with_location_evidence
    :parameters (?failing_test_case - failing_test_case ?related_test_case - related_test_case ?code_location - code_location ?module - module ?build_or_pr - build_or_pr)
    :precondition
      (and
        (test_ready_for_patch_bundle ?failing_test_case)
        (related_test_ready_for_patch_bundle ?related_test_case)
        (test_localized_to ?failing_test_case ?code_location)
        (related_test_mapped_to_module ?related_test_case ?module)
        (code_location_has_suggestion ?code_location)
        (module_confirmed ?module)
        (not
          (root_cause_localized ?failing_test_case)
        )
        (related_test_root_cause_localized ?related_test_case)
        (build_pr_available ?build_or_pr)
      )
    :effect
      (and
        (build_staged ?build_or_pr)
        (build_targets_code_location ?build_or_pr ?code_location)
        (build_targets_module ?build_or_pr ?module)
        (build_includes_optional_resource ?build_or_pr)
        (not
          (build_pr_available ?build_or_pr)
        )
      )
  )
  (:action construct_patch_bundle_with_module_evidence
    :parameters (?failing_test_case - failing_test_case ?related_test_case - related_test_case ?code_location - code_location ?module - module ?build_or_pr - build_or_pr)
    :precondition
      (and
        (test_ready_for_patch_bundle ?failing_test_case)
        (related_test_ready_for_patch_bundle ?related_test_case)
        (test_localized_to ?failing_test_case ?code_location)
        (related_test_mapped_to_module ?related_test_case ?module)
        (code_location_confirmed ?code_location)
        (module_has_suggestion ?module)
        (root_cause_localized ?failing_test_case)
        (not
          (related_test_root_cause_localized ?related_test_case)
        )
        (build_pr_available ?build_or_pr)
      )
    :effect
      (and
        (build_staged ?build_or_pr)
        (build_targets_code_location ?build_or_pr ?code_location)
        (build_targets_module ?build_or_pr ?module)
        (build_includes_optional_component ?build_or_pr)
        (not
          (build_pr_available ?build_or_pr)
        )
      )
  )
  (:action construct_patch_bundle_with_combined_evidence
    :parameters (?failing_test_case - failing_test_case ?related_test_case - related_test_case ?code_location - code_location ?module - module ?build_or_pr - build_or_pr)
    :precondition
      (and
        (test_ready_for_patch_bundle ?failing_test_case)
        (related_test_ready_for_patch_bundle ?related_test_case)
        (test_localized_to ?failing_test_case ?code_location)
        (related_test_mapped_to_module ?related_test_case ?module)
        (code_location_has_suggestion ?code_location)
        (module_has_suggestion ?module)
        (not
          (root_cause_localized ?failing_test_case)
        )
        (not
          (related_test_root_cause_localized ?related_test_case)
        )
        (build_pr_available ?build_or_pr)
      )
    :effect
      (and
        (build_staged ?build_or_pr)
        (build_targets_code_location ?build_or_pr ?code_location)
        (build_targets_module ?build_or_pr ?module)
        (build_includes_optional_resource ?build_or_pr)
        (build_includes_optional_component ?build_or_pr)
        (not
          (build_pr_available ?build_or_pr)
        )
      )
  )
  (:action run_ci_validation_on_build
    :parameters (?build_or_pr - build_or_pr ?failing_test_case - failing_test_case ?test_execution_record - test_execution_record)
    :precondition
      (and
        (build_staged ?build_or_pr)
        (test_ready_for_patch_bundle ?failing_test_case)
        (investigation_item_execution_record ?failing_test_case ?test_execution_record)
        (not
          (build_ci_validated ?build_or_pr)
        )
      )
    :effect (build_ci_validated ?build_or_pr)
  )
  (:action attach_fixture_to_build_for_candidate
    :parameters (?candidate_fix - candidate_fix ?test_fixture - test_fixture ?build_or_pr - build_or_pr)
    :precondition
      (and
        (analysis_completed ?candidate_fix)
        (candidate_in_build ?candidate_fix ?build_or_pr)
        (candidate_requires_fixture ?candidate_fix ?test_fixture)
        (fixture_available ?test_fixture)
        (build_staged ?build_or_pr)
        (build_ci_validated ?build_or_pr)
        (not
          (fixture_attached ?test_fixture)
        )
      )
    :effect
      (and
        (fixture_attached ?test_fixture)
        (fixture_in_build ?test_fixture ?build_or_pr)
        (not
          (fixture_available ?test_fixture)
        )
      )
  )
  (:action prepare_candidate_in_build
    :parameters (?candidate_fix - candidate_fix ?test_fixture - test_fixture ?build_or_pr - build_or_pr ?test_execution_record - test_execution_record)
    :precondition
      (and
        (analysis_completed ?candidate_fix)
        (candidate_requires_fixture ?candidate_fix ?test_fixture)
        (fixture_attached ?test_fixture)
        (fixture_in_build ?test_fixture ?build_or_pr)
        (investigation_item_execution_record ?candidate_fix ?test_execution_record)
        (not
          (build_includes_optional_resource ?build_or_pr)
        )
        (not
          (candidate_prepared ?candidate_fix)
        )
      )
    :effect (candidate_prepared ?candidate_fix)
  )
  (:action label_candidate
    :parameters (?candidate_fix - candidate_fix ?label - label)
    :precondition
      (and
        (analysis_completed ?candidate_fix)
        (label_available ?label)
        (not
          (candidate_labeled ?candidate_fix)
        )
      )
    :effect
      (and
        (candidate_labeled ?candidate_fix)
        (candidate_has_label ?candidate_fix ?label)
        (not
          (label_available ?label)
        )
      )
  )
  (:action annotate_and_prepare_candidate_in_build
    :parameters (?candidate_fix - candidate_fix ?test_fixture - test_fixture ?build_or_pr - build_or_pr ?test_execution_record - test_execution_record ?label - label)
    :precondition
      (and
        (analysis_completed ?candidate_fix)
        (candidate_requires_fixture ?candidate_fix ?test_fixture)
        (fixture_attached ?test_fixture)
        (fixture_in_build ?test_fixture ?build_or_pr)
        (investigation_item_execution_record ?candidate_fix ?test_execution_record)
        (build_includes_optional_resource ?build_or_pr)
        (candidate_labeled ?candidate_fix)
        (candidate_has_label ?candidate_fix ?label)
        (not
          (candidate_prepared ?candidate_fix)
        )
      )
    :effect
      (and
        (candidate_prepared ?candidate_fix)
        (candidate_flagged_extra ?candidate_fix)
      )
  )
  (:action stage_candidate_for_instrumentation
    :parameters (?candidate_fix - candidate_fix ?analysis_tool - analysis_tool ?developer - developer_tag ?test_fixture - test_fixture ?build_or_pr - build_or_pr)
    :precondition
      (and
        (candidate_prepared ?candidate_fix)
        (candidate_has_analysis_tool ?candidate_fix ?analysis_tool)
        (investigation_item_assigned_to ?candidate_fix ?developer)
        (candidate_requires_fixture ?candidate_fix ?test_fixture)
        (fixture_in_build ?test_fixture ?build_or_pr)
        (not
          (build_includes_optional_component ?build_or_pr)
        )
        (not
          (candidate_instrumented ?candidate_fix)
        )
      )
    :effect (candidate_instrumented ?candidate_fix)
  )
  (:action stage_candidate_for_instrumentation_alternate
    :parameters (?candidate_fix - candidate_fix ?analysis_tool - analysis_tool ?developer - developer_tag ?test_fixture - test_fixture ?build_or_pr - build_or_pr)
    :precondition
      (and
        (candidate_prepared ?candidate_fix)
        (candidate_has_analysis_tool ?candidate_fix ?analysis_tool)
        (investigation_item_assigned_to ?candidate_fix ?developer)
        (candidate_requires_fixture ?candidate_fix ?test_fixture)
        (fixture_in_build ?test_fixture ?build_or_pr)
        (build_includes_optional_component ?build_or_pr)
        (not
          (candidate_instrumented ?candidate_fix)
        )
      )
    :effect (candidate_instrumented ?candidate_fix)
  )
  (:action apply_runtime_flag_and_run_candidate_validation
    :parameters (?candidate_fix - candidate_fix ?runtime_flag - runtime_flag ?test_fixture - test_fixture ?build_or_pr - build_or_pr)
    :precondition
      (and
        (candidate_instrumented ?candidate_fix)
        (candidate_has_runtime_flag ?candidate_fix ?runtime_flag)
        (candidate_requires_fixture ?candidate_fix ?test_fixture)
        (fixture_in_build ?test_fixture ?build_or_pr)
        (not
          (build_includes_optional_resource ?build_or_pr)
        )
        (not
          (build_includes_optional_component ?build_or_pr)
        )
        (not
          (candidate_validation_passed ?candidate_fix)
        )
      )
    :effect (candidate_validation_passed ?candidate_fix)
  )
  (:action apply_runtime_flag_and_prepare_candidate_for_review
    :parameters (?candidate_fix - candidate_fix ?runtime_flag - runtime_flag ?test_fixture - test_fixture ?build_or_pr - build_or_pr)
    :precondition
      (and
        (candidate_instrumented ?candidate_fix)
        (candidate_has_runtime_flag ?candidate_fix ?runtime_flag)
        (candidate_requires_fixture ?candidate_fix ?test_fixture)
        (fixture_in_build ?test_fixture ?build_or_pr)
        (build_includes_optional_resource ?build_or_pr)
        (not
          (build_includes_optional_component ?build_or_pr)
        )
        (not
          (candidate_validation_passed ?candidate_fix)
        )
      )
    :effect
      (and
        (candidate_validation_passed ?candidate_fix)
        (candidate_review_ready ?candidate_fix)
      )
  )
  (:action apply_runtime_flag_and_prepare_candidate_review_variant
    :parameters (?candidate_fix - candidate_fix ?runtime_flag - runtime_flag ?test_fixture - test_fixture ?build_or_pr - build_or_pr)
    :precondition
      (and
        (candidate_instrumented ?candidate_fix)
        (candidate_has_runtime_flag ?candidate_fix ?runtime_flag)
        (candidate_requires_fixture ?candidate_fix ?test_fixture)
        (fixture_in_build ?test_fixture ?build_or_pr)
        (not
          (build_includes_optional_resource ?build_or_pr)
        )
        (build_includes_optional_component ?build_or_pr)
        (not
          (candidate_validation_passed ?candidate_fix)
        )
      )
    :effect
      (and
        (candidate_validation_passed ?candidate_fix)
        (candidate_review_ready ?candidate_fix)
      )
  )
  (:action finalize_candidate_validation_and_review_ready
    :parameters (?candidate_fix - candidate_fix ?runtime_flag - runtime_flag ?test_fixture - test_fixture ?build_or_pr - build_or_pr)
    :precondition
      (and
        (candidate_instrumented ?candidate_fix)
        (candidate_has_runtime_flag ?candidate_fix ?runtime_flag)
        (candidate_requires_fixture ?candidate_fix ?test_fixture)
        (fixture_in_build ?test_fixture ?build_or_pr)
        (build_includes_optional_resource ?build_or_pr)
        (build_includes_optional_component ?build_or_pr)
        (not
          (candidate_validation_passed ?candidate_fix)
        )
      )
    :effect
      (and
        (candidate_validation_passed ?candidate_fix)
        (candidate_review_ready ?candidate_fix)
      )
  )
  (:action finalize_candidate_verification
    :parameters (?candidate_fix - candidate_fix)
    :precondition
      (and
        (candidate_validation_passed ?candidate_fix)
        (not
          (candidate_review_ready ?candidate_fix)
        )
        (not
          (candidate_signoff ?candidate_fix)
        )
      )
    :effect
      (and
        (candidate_signoff ?candidate_fix)
        (investigation_item_verified ?candidate_fix)
      )
  )
  (:action consume_review_token_for_candidate
    :parameters (?candidate_fix - candidate_fix ?review_token - review_token)
    :precondition
      (and
        (candidate_validation_passed ?candidate_fix)
        (candidate_review_ready ?candidate_fix)
        (review_token_available ?review_token)
      )
    :effect
      (and
        (candidate_has_review_token ?candidate_fix ?review_token)
        (not
          (review_token_available ?review_token)
        )
      )
  )
  (:action finalize_candidate_with_tests_and_review
    :parameters (?candidate_fix - candidate_fix ?failing_test_case - failing_test_case ?related_test_case - related_test_case ?test_execution_record - test_execution_record ?review_token - review_token)
    :precondition
      (and
        (candidate_validation_passed ?candidate_fix)
        (candidate_review_ready ?candidate_fix)
        (candidate_has_review_token ?candidate_fix ?review_token)
        (candidate_targets_failing_test ?candidate_fix ?failing_test_case)
        (candidate_targets_related_test ?candidate_fix ?related_test_case)
        (root_cause_localized ?failing_test_case)
        (related_test_root_cause_localized ?related_test_case)
        (investigation_item_execution_record ?candidate_fix ?test_execution_record)
        (not
          (candidate_finalized ?candidate_fix)
        )
      )
    :effect (candidate_finalized ?candidate_fix)
  )
  (:action finalize_candidate_and_mark_verified
    :parameters (?candidate_fix - candidate_fix)
    :precondition
      (and
        (candidate_validation_passed ?candidate_fix)
        (candidate_finalized ?candidate_fix)
        (not
          (candidate_signoff ?candidate_fix)
        )
      )
    :effect
      (and
        (candidate_signoff ?candidate_fix)
        (investigation_item_verified ?candidate_fix)
      )
  )
  (:action associate_candidate_with_issue_ticket
    :parameters (?candidate_fix - candidate_fix ?issue_ticket - issue_ticket ?test_execution_record - test_execution_record)
    :precondition
      (and
        (analysis_completed ?candidate_fix)
        (investigation_item_execution_record ?candidate_fix ?test_execution_record)
        (issue_ticket_available ?issue_ticket)
        (candidate_linked_to_issue ?candidate_fix ?issue_ticket)
        (not
          (candidate_issue_link_confirmed ?candidate_fix)
        )
      )
    :effect
      (and
        (candidate_issue_link_confirmed ?candidate_fix)
        (not
          (issue_ticket_available ?issue_ticket)
        )
      )
  )
  (:action initiate_candidate_review
    :parameters (?candidate_fix - candidate_fix ?developer - developer_tag)
    :precondition
      (and
        (candidate_issue_link_confirmed ?candidate_fix)
        (investigation_item_assigned_to ?candidate_fix ?developer)
        (not
          (review_initiated ?candidate_fix)
        )
      )
    :effect (review_initiated ?candidate_fix)
  )
  (:action complete_candidate_review
    :parameters (?candidate_fix - candidate_fix ?runtime_flag - runtime_flag)
    :precondition
      (and
        (review_initiated ?candidate_fix)
        (candidate_has_runtime_flag ?candidate_fix ?runtime_flag)
        (not
          (review_completed ?candidate_fix)
        )
      )
    :effect (review_completed ?candidate_fix)
  )
  (:action finalize_review_and_verify_candidate
    :parameters (?candidate_fix - candidate_fix)
    :precondition
      (and
        (review_completed ?candidate_fix)
        (not
          (candidate_signoff ?candidate_fix)
        )
      )
    :effect
      (and
        (candidate_signoff ?candidate_fix)
        (investigation_item_verified ?candidate_fix)
      )
  )
  (:action verify_test_with_build
    :parameters (?failing_test_case - failing_test_case ?build_or_pr - build_or_pr)
    :precondition
      (and
        (test_ready_for_patch_bundle ?failing_test_case)
        (root_cause_localized ?failing_test_case)
        (build_staged ?build_or_pr)
        (build_ci_validated ?build_or_pr)
        (not
          (investigation_item_verified ?failing_test_case)
        )
      )
    :effect (investigation_item_verified ?failing_test_case)
  )
  (:action verify_related_test_with_build
    :parameters (?related_test_case - related_test_case ?build_or_pr - build_or_pr)
    :precondition
      (and
        (related_test_ready_for_patch_bundle ?related_test_case)
        (related_test_root_cause_localized ?related_test_case)
        (build_staged ?build_or_pr)
        (build_ci_validated ?build_or_pr)
        (not
          (investigation_item_verified ?related_test_case)
        )
      )
    :effect (investigation_item_verified ?related_test_case)
  )
  (:action apply_verified_change_to_artifact
    :parameters (?artifact - investigation_item ?environment_configuration - environment_configuration ?test_execution_record - test_execution_record)
    :precondition
      (and
        (investigation_item_verified ?artifact)
        (investigation_item_execution_record ?artifact ?test_execution_record)
        (env_config_available ?environment_configuration)
        (not
          (fix_staged ?artifact)
        )
      )
    :effect
      (and
        (fix_staged ?artifact)
        (investigation_item_bound_to_environment_configuration ?artifact ?environment_configuration)
        (not
          (env_config_available ?environment_configuration)
        )
      )
  )
  (:action apply_fix_to_failing_test_case
    :parameters (?failing_test_case - failing_test_case ?instrumentation_resource - instrumentation_resource ?environment_configuration - environment_configuration)
    :precondition
      (and
        (fix_staged ?failing_test_case)
        (instrumentation_assigned ?failing_test_case ?instrumentation_resource)
        (investigation_item_bound_to_environment_configuration ?failing_test_case ?environment_configuration)
        (not
          (fix_applied ?failing_test_case)
        )
      )
    :effect
      (and
        (fix_applied ?failing_test_case)
        (instrumentation_available ?instrumentation_resource)
        (env_config_available ?environment_configuration)
      )
  )
  (:action apply_fix_to_related_test
    :parameters (?related_test_case - related_test_case ?instrumentation_resource - instrumentation_resource ?environment_configuration - environment_configuration)
    :precondition
      (and
        (fix_staged ?related_test_case)
        (instrumentation_assigned ?related_test_case ?instrumentation_resource)
        (investigation_item_bound_to_environment_configuration ?related_test_case ?environment_configuration)
        (not
          (fix_applied ?related_test_case)
        )
      )
    :effect
      (and
        (fix_applied ?related_test_case)
        (instrumentation_available ?instrumentation_resource)
        (env_config_available ?environment_configuration)
      )
  )
  (:action apply_verified_candidate_fix
    :parameters (?candidate_fix - candidate_fix ?instrumentation_resource - instrumentation_resource ?environment_configuration - environment_configuration)
    :precondition
      (and
        (fix_staged ?candidate_fix)
        (instrumentation_assigned ?candidate_fix ?instrumentation_resource)
        (investigation_item_bound_to_environment_configuration ?candidate_fix ?environment_configuration)
        (not
          (fix_applied ?candidate_fix)
        )
      )
    :effect
      (and
        (fix_applied ?candidate_fix)
        (instrumentation_available ?instrumentation_resource)
        (env_config_available ?environment_configuration)
      )
  )
)

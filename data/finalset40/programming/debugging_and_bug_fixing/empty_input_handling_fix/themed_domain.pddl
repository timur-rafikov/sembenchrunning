(define (domain empty_input_handling_fix_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types generic_object - object operational_entity - generic_object test_entity - generic_object artifact_entity - generic_object component_root - generic_object software_component - component_root patch_resource - operational_entity test_case - operational_entity maintainer - operational_entity review_artifact - operational_entity priority_token - operational_entity trace_artifact - operational_entity static_analysis_report - operational_entity runtime_environment - operational_entity test_fixture - test_entity external_dependency - test_entity regression_marker - test_entity input_variant - artifact_entity test_variant - artifact_entity build_candidate - artifact_entity component_version - software_component component_configuration - software_component service_instance - component_version client_session - component_version orchestrator_component - component_configuration)

  (:predicates
    (component_registered ?software_component - software_component)
    (is_managed ?software_component - software_component)
    (patch_allocated ?software_component - software_component)
    (patch_applied ?software_component - software_component)
    (issue_confirmed ?software_component - software_component)
    (patch_ready ?software_component - software_component)
    (patch_resource_available ?patch_resource - patch_resource)
    (has_patch_resource ?software_component - software_component ?patch_resource - patch_resource)
    (test_case_available ?test_case - test_case)
    (test_assigned ?software_component - software_component ?test_case - test_case)
    (maintainer_available ?maintainer - maintainer)
    (maintainer_assigned ?software_component - software_component ?maintainer - maintainer)
    (test_fixture_available ?test_fixture - test_fixture)
    (instance_bound_to_fixture ?service_instance - service_instance ?test_fixture - test_fixture)
    (session_bound_to_fixture ?client_session - client_session ?test_fixture - test_fixture)
    (instance_has_input_variant ?service_instance - service_instance ?input_variant - input_variant)
    (input_variant_ready ?input_variant - input_variant)
    (input_variant_staged ?input_variant - input_variant)
    (instance_ready ?service_instance - service_instance)
    (session_has_test_variant ?client_session - client_session ?test_variant - test_variant)
    (test_variant_ready ?test_variant - test_variant)
    (test_variant_staged ?test_variant - test_variant)
    (session_ready ?client_session - client_session)
    (build_candidate_available ?build_candidate - build_candidate)
    (build_candidate_prepared ?build_candidate - build_candidate)
    (candidate_has_input_variant ?build_candidate - build_candidate ?input_variant - input_variant)
    (candidate_has_test_variant ?build_candidate - build_candidate ?test_variant - test_variant)
    (candidate_has_staged_input_variant ?build_candidate - build_candidate)
    (candidate_has_staged_test_variant ?build_candidate - build_candidate)
    (candidate_tests_executed ?build_candidate - build_candidate)
    (orchestrator_monitors_instance ?repair_orchestrator - orchestrator_component ?service_instance - service_instance)
    (orchestrator_monitors_session ?repair_orchestrator - orchestrator_component ?client_session - client_session)
    (orchestrator_has_candidate ?repair_orchestrator - orchestrator_component ?build_candidate - build_candidate)
    (dependency_available ?external_dependency - external_dependency)
    (orchestrator_has_dependency ?repair_orchestrator - orchestrator_component ?external_dependency - external_dependency)
    (dependency_consumed ?external_dependency - external_dependency)
    (dependency_in_candidate ?external_dependency - external_dependency ?build_candidate - build_candidate)
    (orchestrator_ready_for_review ?repair_orchestrator - orchestrator_component)
    (orchestrator_review_passed ?repair_orchestrator - orchestrator_component)
    (orchestrator_ready_for_promotion ?repair_orchestrator - orchestrator_component)
    (orchestrator_review_artifact_present ?repair_orchestrator - orchestrator_component)
    (orchestrator_review_marker ?repair_orchestrator - orchestrator_component)
    (orchestrator_review_acknowledged ?repair_orchestrator - orchestrator_component)
    (orchestrator_context_verified ?repair_orchestrator - orchestrator_component)
    (regression_marker_active ?regression_marker - regression_marker)
    (orchestrator_flagged_with_regression_marker ?repair_orchestrator - orchestrator_component ?regression_marker - regression_marker)
    (orchestrator_regression_acknowledged ?repair_orchestrator - orchestrator_component)
    (orchestrator_review_stage2 ?repair_orchestrator - orchestrator_component)
    (orchestrator_review_finalized ?repair_orchestrator - orchestrator_component)
    (review_artifact_available ?review_artifact - review_artifact)
    (orchestrator_has_review_artifact_binding ?repair_orchestrator - orchestrator_component ?review_artifact - review_artifact)
    (priority_token_available ?priority_token - priority_token)
    (orchestrator_has_priority_token ?repair_orchestrator - orchestrator_component ?priority_token - priority_token)
    (static_analysis_report_available ?static_analysis_report - static_analysis_report)
    (orchestrator_has_static_report ?repair_orchestrator - orchestrator_component ?static_analysis_report - static_analysis_report)
    (runtime_environment_available ?runtime_environment - runtime_environment)
    (orchestrator_has_runtime_env ?repair_orchestrator - orchestrator_component ?runtime_environment - runtime_environment)
    (trace_artifact_available ?trace_artifact - trace_artifact)
    (component_linked_to_trace ?software_component - software_component ?trace_artifact - trace_artifact)
    (instance_flagged ?service_instance - service_instance)
    (session_flagged ?client_session - client_session)
    (orchestrator_finalized ?repair_orchestrator - orchestrator_component)
  )
  (:action register_component
    :parameters (?software_component - software_component)
    :precondition
      (and
        (not
          (component_registered ?software_component)
        )
        (not
          (patch_applied ?software_component)
        )
      )
    :effect (component_registered ?software_component)
  )
  (:action allocate_patch_resource
    :parameters (?software_component - software_component ?patch_resource - patch_resource)
    :precondition
      (and
        (component_registered ?software_component)
        (not
          (patch_allocated ?software_component)
        )
        (patch_resource_available ?patch_resource)
      )
    :effect
      (and
        (patch_allocated ?software_component)
        (has_patch_resource ?software_component ?patch_resource)
        (not
          (patch_resource_available ?patch_resource)
        )
      )
  )
  (:action execute_test_case
    :parameters (?software_component - software_component ?test_case - test_case)
    :precondition
      (and
        (component_registered ?software_component)
        (patch_allocated ?software_component)
        (test_case_available ?test_case)
      )
    :effect
      (and
        (test_assigned ?software_component ?test_case)
        (not
          (test_case_available ?test_case)
        )
      )
  )
  (:action record_test_result
    :parameters (?software_component - software_component ?test_case - test_case)
    :precondition
      (and
        (component_registered ?software_component)
        (patch_allocated ?software_component)
        (test_assigned ?software_component ?test_case)
        (not
          (is_managed ?software_component)
        )
      )
    :effect (is_managed ?software_component)
  )
  (:action recycle_test_case
    :parameters (?software_component - software_component ?test_case - test_case)
    :precondition
      (and
        (test_assigned ?software_component ?test_case)
      )
    :effect
      (and
        (test_case_available ?test_case)
        (not
          (test_assigned ?software_component ?test_case)
        )
      )
  )
  (:action assign_maintainer
    :parameters (?software_component - software_component ?maintainer - maintainer)
    :precondition
      (and
        (is_managed ?software_component)
        (maintainer_available ?maintainer)
      )
    :effect
      (and
        (maintainer_assigned ?software_component ?maintainer)
        (not
          (maintainer_available ?maintainer)
        )
      )
  )
  (:action release_maintainer
    :parameters (?software_component - software_component ?maintainer - maintainer)
    :precondition
      (and
        (maintainer_assigned ?software_component ?maintainer)
      )
    :effect
      (and
        (maintainer_available ?maintainer)
        (not
          (maintainer_assigned ?software_component ?maintainer)
        )
      )
  )
  (:action attach_static_analysis_report
    :parameters (?repair_orchestrator - orchestrator_component ?static_analysis_report - static_analysis_report)
    :precondition
      (and
        (is_managed ?repair_orchestrator)
        (static_analysis_report_available ?static_analysis_report)
      )
    :effect
      (and
        (orchestrator_has_static_report ?repair_orchestrator ?static_analysis_report)
        (not
          (static_analysis_report_available ?static_analysis_report)
        )
      )
  )
  (:action detach_static_analysis_report
    :parameters (?repair_orchestrator - orchestrator_component ?static_analysis_report - static_analysis_report)
    :precondition
      (and
        (orchestrator_has_static_report ?repair_orchestrator ?static_analysis_report)
      )
    :effect
      (and
        (static_analysis_report_available ?static_analysis_report)
        (not
          (orchestrator_has_static_report ?repair_orchestrator ?static_analysis_report)
        )
      )
  )
  (:action attach_runtime_environment
    :parameters (?repair_orchestrator - orchestrator_component ?runtime_environment - runtime_environment)
    :precondition
      (and
        (is_managed ?repair_orchestrator)
        (runtime_environment_available ?runtime_environment)
      )
    :effect
      (and
        (orchestrator_has_runtime_env ?repair_orchestrator ?runtime_environment)
        (not
          (runtime_environment_available ?runtime_environment)
        )
      )
  )
  (:action detach_runtime_environment
    :parameters (?repair_orchestrator - orchestrator_component ?runtime_environment - runtime_environment)
    :precondition
      (and
        (orchestrator_has_runtime_env ?repair_orchestrator ?runtime_environment)
      )
    :effect
      (and
        (runtime_environment_available ?runtime_environment)
        (not
          (orchestrator_has_runtime_env ?repair_orchestrator ?runtime_environment)
        )
      )
  )
  (:action stage_input_variant
    :parameters (?service_instance - service_instance ?input_variant - input_variant ?test_case - test_case)
    :precondition
      (and
        (is_managed ?service_instance)
        (test_assigned ?service_instance ?test_case)
        (instance_has_input_variant ?service_instance ?input_variant)
        (not
          (input_variant_ready ?input_variant)
        )
        (not
          (input_variant_staged ?input_variant)
        )
      )
    :effect (input_variant_ready ?input_variant)
  )
  (:action finalize_instance_configuration
    :parameters (?service_instance - service_instance ?input_variant - input_variant ?maintainer - maintainer)
    :precondition
      (and
        (is_managed ?service_instance)
        (maintainer_assigned ?service_instance ?maintainer)
        (instance_has_input_variant ?service_instance ?input_variant)
        (input_variant_ready ?input_variant)
        (not
          (instance_flagged ?service_instance)
        )
      )
    :effect
      (and
        (instance_flagged ?service_instance)
        (instance_ready ?service_instance)
      )
  )
  (:action apply_fixture_to_instance
    :parameters (?service_instance - service_instance ?input_variant - input_variant ?test_fixture - test_fixture)
    :precondition
      (and
        (is_managed ?service_instance)
        (instance_has_input_variant ?service_instance ?input_variant)
        (test_fixture_available ?test_fixture)
        (not
          (instance_flagged ?service_instance)
        )
      )
    :effect
      (and
        (input_variant_staged ?input_variant)
        (instance_flagged ?service_instance)
        (instance_bound_to_fixture ?service_instance ?test_fixture)
        (not
          (test_fixture_available ?test_fixture)
        )
      )
  )
  (:action activate_input_variant
    :parameters (?service_instance - service_instance ?input_variant - input_variant ?test_case - test_case ?test_fixture - test_fixture)
    :precondition
      (and
        (is_managed ?service_instance)
        (test_assigned ?service_instance ?test_case)
        (instance_has_input_variant ?service_instance ?input_variant)
        (input_variant_staged ?input_variant)
        (instance_bound_to_fixture ?service_instance ?test_fixture)
        (not
          (instance_ready ?service_instance)
        )
      )
    :effect
      (and
        (input_variant_ready ?input_variant)
        (instance_ready ?service_instance)
        (test_fixture_available ?test_fixture)
        (not
          (instance_bound_to_fixture ?service_instance ?test_fixture)
        )
      )
  )
  (:action stage_test_variant_for_session
    :parameters (?client_session - client_session ?test_variant - test_variant ?test_case - test_case)
    :precondition
      (and
        (is_managed ?client_session)
        (test_assigned ?client_session ?test_case)
        (session_has_test_variant ?client_session ?test_variant)
        (not
          (test_variant_ready ?test_variant)
        )
        (not
          (test_variant_staged ?test_variant)
        )
      )
    :effect (test_variant_ready ?test_variant)
  )
  (:action finalize_session_configuration
    :parameters (?client_session - client_session ?test_variant - test_variant ?maintainer - maintainer)
    :precondition
      (and
        (is_managed ?client_session)
        (maintainer_assigned ?client_session ?maintainer)
        (session_has_test_variant ?client_session ?test_variant)
        (test_variant_ready ?test_variant)
        (not
          (session_flagged ?client_session)
        )
      )
    :effect
      (and
        (session_flagged ?client_session)
        (session_ready ?client_session)
      )
  )
  (:action attach_fixture_to_session
    :parameters (?client_session - client_session ?test_variant - test_variant ?test_fixture - test_fixture)
    :precondition
      (and
        (is_managed ?client_session)
        (session_has_test_variant ?client_session ?test_variant)
        (test_fixture_available ?test_fixture)
        (not
          (session_flagged ?client_session)
        )
      )
    :effect
      (and
        (test_variant_staged ?test_variant)
        (session_flagged ?client_session)
        (session_bound_to_fixture ?client_session ?test_fixture)
        (not
          (test_fixture_available ?test_fixture)
        )
      )
  )
  (:action activate_test_variant_for_session
    :parameters (?client_session - client_session ?test_variant - test_variant ?test_case - test_case ?test_fixture - test_fixture)
    :precondition
      (and
        (is_managed ?client_session)
        (test_assigned ?client_session ?test_case)
        (session_has_test_variant ?client_session ?test_variant)
        (test_variant_staged ?test_variant)
        (session_bound_to_fixture ?client_session ?test_fixture)
        (not
          (session_ready ?client_session)
        )
      )
    :effect
      (and
        (test_variant_ready ?test_variant)
        (session_ready ?client_session)
        (test_fixture_available ?test_fixture)
        (not
          (session_bound_to_fixture ?client_session ?test_fixture)
        )
      )
  )
  (:action create_build_candidate_from_ready_context
    :parameters (?service_instance - service_instance ?client_session - client_session ?input_variant - input_variant ?test_variant - test_variant ?build_candidate - build_candidate)
    :precondition
      (and
        (instance_flagged ?service_instance)
        (session_flagged ?client_session)
        (instance_has_input_variant ?service_instance ?input_variant)
        (session_has_test_variant ?client_session ?test_variant)
        (input_variant_ready ?input_variant)
        (test_variant_ready ?test_variant)
        (instance_ready ?service_instance)
        (session_ready ?client_session)
        (build_candidate_available ?build_candidate)
      )
    :effect
      (and
        (build_candidate_prepared ?build_candidate)
        (candidate_has_input_variant ?build_candidate ?input_variant)
        (candidate_has_test_variant ?build_candidate ?test_variant)
        (not
          (build_candidate_available ?build_candidate)
        )
      )
  )
  (:action create_build_candidate_with_staged_input
    :parameters (?service_instance - service_instance ?client_session - client_session ?input_variant - input_variant ?test_variant - test_variant ?build_candidate - build_candidate)
    :precondition
      (and
        (instance_flagged ?service_instance)
        (session_flagged ?client_session)
        (instance_has_input_variant ?service_instance ?input_variant)
        (session_has_test_variant ?client_session ?test_variant)
        (input_variant_staged ?input_variant)
        (test_variant_ready ?test_variant)
        (not
          (instance_ready ?service_instance)
        )
        (session_ready ?client_session)
        (build_candidate_available ?build_candidate)
      )
    :effect
      (and
        (build_candidate_prepared ?build_candidate)
        (candidate_has_input_variant ?build_candidate ?input_variant)
        (candidate_has_test_variant ?build_candidate ?test_variant)
        (candidate_has_staged_input_variant ?build_candidate)
        (not
          (build_candidate_available ?build_candidate)
        )
      )
  )
  (:action create_build_candidate_with_staged_test
    :parameters (?service_instance - service_instance ?client_session - client_session ?input_variant - input_variant ?test_variant - test_variant ?build_candidate - build_candidate)
    :precondition
      (and
        (instance_flagged ?service_instance)
        (session_flagged ?client_session)
        (instance_has_input_variant ?service_instance ?input_variant)
        (session_has_test_variant ?client_session ?test_variant)
        (input_variant_ready ?input_variant)
        (test_variant_staged ?test_variant)
        (instance_ready ?service_instance)
        (not
          (session_ready ?client_session)
        )
        (build_candidate_available ?build_candidate)
      )
    :effect
      (and
        (build_candidate_prepared ?build_candidate)
        (candidate_has_input_variant ?build_candidate ?input_variant)
        (candidate_has_test_variant ?build_candidate ?test_variant)
        (candidate_has_staged_test_variant ?build_candidate)
        (not
          (build_candidate_available ?build_candidate)
        )
      )
  )
  (:action create_build_candidate_with_staged_input_and_test
    :parameters (?service_instance - service_instance ?client_session - client_session ?input_variant - input_variant ?test_variant - test_variant ?build_candidate - build_candidate)
    :precondition
      (and
        (instance_flagged ?service_instance)
        (session_flagged ?client_session)
        (instance_has_input_variant ?service_instance ?input_variant)
        (session_has_test_variant ?client_session ?test_variant)
        (input_variant_staged ?input_variant)
        (test_variant_staged ?test_variant)
        (not
          (instance_ready ?service_instance)
        )
        (not
          (session_ready ?client_session)
        )
        (build_candidate_available ?build_candidate)
      )
    :effect
      (and
        (build_candidate_prepared ?build_candidate)
        (candidate_has_input_variant ?build_candidate ?input_variant)
        (candidate_has_test_variant ?build_candidate ?test_variant)
        (candidate_has_staged_input_variant ?build_candidate)
        (candidate_has_staged_test_variant ?build_candidate)
        (not
          (build_candidate_available ?build_candidate)
        )
      )
  )
  (:action execute_candidate_tests
    :parameters (?build_candidate - build_candidate ?service_instance - service_instance ?test_case - test_case)
    :precondition
      (and
        (build_candidate_prepared ?build_candidate)
        (instance_flagged ?service_instance)
        (test_assigned ?service_instance ?test_case)
        (not
          (candidate_tests_executed ?build_candidate)
        )
      )
    :effect (candidate_tests_executed ?build_candidate)
  )
  (:action integrate_dependency_into_candidate
    :parameters (?repair_orchestrator - orchestrator_component ?external_dependency - external_dependency ?build_candidate - build_candidate)
    :precondition
      (and
        (is_managed ?repair_orchestrator)
        (orchestrator_has_candidate ?repair_orchestrator ?build_candidate)
        (orchestrator_has_dependency ?repair_orchestrator ?external_dependency)
        (dependency_available ?external_dependency)
        (build_candidate_prepared ?build_candidate)
        (candidate_tests_executed ?build_candidate)
        (not
          (dependency_consumed ?external_dependency)
        )
      )
    :effect
      (and
        (dependency_consumed ?external_dependency)
        (dependency_in_candidate ?external_dependency ?build_candidate)
        (not
          (dependency_available ?external_dependency)
        )
      )
  )
  (:action orchestrator_claim_candidate_for_review
    :parameters (?repair_orchestrator - orchestrator_component ?external_dependency - external_dependency ?build_candidate - build_candidate ?test_case - test_case)
    :precondition
      (and
        (is_managed ?repair_orchestrator)
        (orchestrator_has_dependency ?repair_orchestrator ?external_dependency)
        (dependency_consumed ?external_dependency)
        (dependency_in_candidate ?external_dependency ?build_candidate)
        (test_assigned ?repair_orchestrator ?test_case)
        (not
          (candidate_has_staged_input_variant ?build_candidate)
        )
        (not
          (orchestrator_ready_for_review ?repair_orchestrator)
        )
      )
    :effect (orchestrator_ready_for_review ?repair_orchestrator)
  )
  (:action assign_review_artifact
    :parameters (?repair_orchestrator - orchestrator_component ?review_artifact - review_artifact)
    :precondition
      (and
        (is_managed ?repair_orchestrator)
        (review_artifact_available ?review_artifact)
        (not
          (orchestrator_review_artifact_present ?repair_orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_review_artifact_present ?repair_orchestrator)
        (orchestrator_has_review_artifact_binding ?repair_orchestrator ?review_artifact)
        (not
          (review_artifact_available ?review_artifact)
        )
      )
  )
  (:action record_review_evidence
    :parameters (?repair_orchestrator - orchestrator_component ?external_dependency - external_dependency ?build_candidate - build_candidate ?test_case - test_case ?review_artifact - review_artifact)
    :precondition
      (and
        (is_managed ?repair_orchestrator)
        (orchestrator_has_dependency ?repair_orchestrator ?external_dependency)
        (dependency_consumed ?external_dependency)
        (dependency_in_candidate ?external_dependency ?build_candidate)
        (test_assigned ?repair_orchestrator ?test_case)
        (candidate_has_staged_input_variant ?build_candidate)
        (orchestrator_review_artifact_present ?repair_orchestrator)
        (orchestrator_has_review_artifact_binding ?repair_orchestrator ?review_artifact)
        (not
          (orchestrator_ready_for_review ?repair_orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_ready_for_review ?repair_orchestrator)
        (orchestrator_review_marker ?repair_orchestrator)
      )
  )
  (:action complete_review_phase1
    :parameters (?repair_orchestrator - orchestrator_component ?static_analysis_report - static_analysis_report ?maintainer - maintainer ?external_dependency - external_dependency ?build_candidate - build_candidate)
    :precondition
      (and
        (orchestrator_ready_for_review ?repair_orchestrator)
        (orchestrator_has_static_report ?repair_orchestrator ?static_analysis_report)
        (maintainer_assigned ?repair_orchestrator ?maintainer)
        (orchestrator_has_dependency ?repair_orchestrator ?external_dependency)
        (dependency_in_candidate ?external_dependency ?build_candidate)
        (not
          (candidate_has_staged_test_variant ?build_candidate)
        )
        (not
          (orchestrator_review_passed ?repair_orchestrator)
        )
      )
    :effect (orchestrator_review_passed ?repair_orchestrator)
  )
  (:action complete_review_phase1_alternate
    :parameters (?repair_orchestrator - orchestrator_component ?static_analysis_report - static_analysis_report ?maintainer - maintainer ?external_dependency - external_dependency ?build_candidate - build_candidate)
    :precondition
      (and
        (orchestrator_ready_for_review ?repair_orchestrator)
        (orchestrator_has_static_report ?repair_orchestrator ?static_analysis_report)
        (maintainer_assigned ?repair_orchestrator ?maintainer)
        (orchestrator_has_dependency ?repair_orchestrator ?external_dependency)
        (dependency_in_candidate ?external_dependency ?build_candidate)
        (candidate_has_staged_test_variant ?build_candidate)
        (not
          (orchestrator_review_passed ?repair_orchestrator)
        )
      )
    :effect (orchestrator_review_passed ?repair_orchestrator)
  )
  (:action mark_orchestrator_ready_for_promotion
    :parameters (?repair_orchestrator - orchestrator_component ?runtime_environment - runtime_environment ?external_dependency - external_dependency ?build_candidate - build_candidate)
    :precondition
      (and
        (orchestrator_review_passed ?repair_orchestrator)
        (orchestrator_has_runtime_env ?repair_orchestrator ?runtime_environment)
        (orchestrator_has_dependency ?repair_orchestrator ?external_dependency)
        (dependency_in_candidate ?external_dependency ?build_candidate)
        (not
          (candidate_has_staged_input_variant ?build_candidate)
        )
        (not
          (candidate_has_staged_test_variant ?build_candidate)
        )
        (not
          (orchestrator_ready_for_promotion ?repair_orchestrator)
        )
      )
    :effect (orchestrator_ready_for_promotion ?repair_orchestrator)
  )
  (:action approve_review_and_acknowledge
    :parameters (?repair_orchestrator - orchestrator_component ?runtime_environment - runtime_environment ?external_dependency - external_dependency ?build_candidate - build_candidate)
    :precondition
      (and
        (orchestrator_review_passed ?repair_orchestrator)
        (orchestrator_has_runtime_env ?repair_orchestrator ?runtime_environment)
        (orchestrator_has_dependency ?repair_orchestrator ?external_dependency)
        (dependency_in_candidate ?external_dependency ?build_candidate)
        (candidate_has_staged_input_variant ?build_candidate)
        (not
          (candidate_has_staged_test_variant ?build_candidate)
        )
        (not
          (orchestrator_ready_for_promotion ?repair_orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_ready_for_promotion ?repair_orchestrator)
        (orchestrator_review_acknowledged ?repair_orchestrator)
      )
  )
  (:action approve_review_and_acknowledge_alt
    :parameters (?repair_orchestrator - orchestrator_component ?runtime_environment - runtime_environment ?external_dependency - external_dependency ?build_candidate - build_candidate)
    :precondition
      (and
        (orchestrator_review_passed ?repair_orchestrator)
        (orchestrator_has_runtime_env ?repair_orchestrator ?runtime_environment)
        (orchestrator_has_dependency ?repair_orchestrator ?external_dependency)
        (dependency_in_candidate ?external_dependency ?build_candidate)
        (not
          (candidate_has_staged_input_variant ?build_candidate)
        )
        (candidate_has_staged_test_variant ?build_candidate)
        (not
          (orchestrator_ready_for_promotion ?repair_orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_ready_for_promotion ?repair_orchestrator)
        (orchestrator_review_acknowledged ?repair_orchestrator)
      )
  )
  (:action approve_review_and_acknowledge_full
    :parameters (?repair_orchestrator - orchestrator_component ?runtime_environment - runtime_environment ?external_dependency - external_dependency ?build_candidate - build_candidate)
    :precondition
      (and
        (orchestrator_review_passed ?repair_orchestrator)
        (orchestrator_has_runtime_env ?repair_orchestrator ?runtime_environment)
        (orchestrator_has_dependency ?repair_orchestrator ?external_dependency)
        (dependency_in_candidate ?external_dependency ?build_candidate)
        (candidate_has_staged_input_variant ?build_candidate)
        (candidate_has_staged_test_variant ?build_candidate)
        (not
          (orchestrator_ready_for_promotion ?repair_orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_ready_for_promotion ?repair_orchestrator)
        (orchestrator_review_acknowledged ?repair_orchestrator)
      )
  )
  (:action finalize_review_and_flag_component
    :parameters (?repair_orchestrator - orchestrator_component)
    :precondition
      (and
        (orchestrator_ready_for_promotion ?repair_orchestrator)
        (not
          (orchestrator_review_acknowledged ?repair_orchestrator)
        )
        (not
          (orchestrator_finalized ?repair_orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_finalized ?repair_orchestrator)
        (issue_confirmed ?repair_orchestrator)
      )
  )
  (:action assign_priority_token
    :parameters (?repair_orchestrator - orchestrator_component ?priority_token - priority_token)
    :precondition
      (and
        (orchestrator_ready_for_promotion ?repair_orchestrator)
        (orchestrator_review_acknowledged ?repair_orchestrator)
        (priority_token_available ?priority_token)
      )
    :effect
      (and
        (orchestrator_has_priority_token ?repair_orchestrator ?priority_token)
        (not
          (priority_token_available ?priority_token)
        )
      )
  )
  (:action verify_orchestrator_context
    :parameters (?repair_orchestrator - orchestrator_component ?service_instance - service_instance ?client_session - client_session ?test_case - test_case ?priority_token - priority_token)
    :precondition
      (and
        (orchestrator_ready_for_promotion ?repair_orchestrator)
        (orchestrator_review_acknowledged ?repair_orchestrator)
        (orchestrator_has_priority_token ?repair_orchestrator ?priority_token)
        (orchestrator_monitors_instance ?repair_orchestrator ?service_instance)
        (orchestrator_monitors_session ?repair_orchestrator ?client_session)
        (instance_ready ?service_instance)
        (session_ready ?client_session)
        (test_assigned ?repair_orchestrator ?test_case)
        (not
          (orchestrator_context_verified ?repair_orchestrator)
        )
      )
    :effect (orchestrator_context_verified ?repair_orchestrator)
  )
  (:action finalize_review_and_flag_component_secondary
    :parameters (?repair_orchestrator - orchestrator_component)
    :precondition
      (and
        (orchestrator_ready_for_promotion ?repair_orchestrator)
        (orchestrator_context_verified ?repair_orchestrator)
        (not
          (orchestrator_finalized ?repair_orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_finalized ?repair_orchestrator)
        (issue_confirmed ?repair_orchestrator)
      )
  )
  (:action acknowledge_regression_marker
    :parameters (?repair_orchestrator - orchestrator_component ?regression_marker - regression_marker ?test_case - test_case)
    :precondition
      (and
        (is_managed ?repair_orchestrator)
        (test_assigned ?repair_orchestrator ?test_case)
        (regression_marker_active ?regression_marker)
        (orchestrator_flagged_with_regression_marker ?repair_orchestrator ?regression_marker)
        (not
          (orchestrator_regression_acknowledged ?repair_orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_regression_acknowledged ?repair_orchestrator)
        (not
          (regression_marker_active ?regression_marker)
        )
      )
  )
  (:action start_regression_followup
    :parameters (?repair_orchestrator - orchestrator_component ?maintainer - maintainer)
    :precondition
      (and
        (orchestrator_regression_acknowledged ?repair_orchestrator)
        (maintainer_assigned ?repair_orchestrator ?maintainer)
        (not
          (orchestrator_review_stage2 ?repair_orchestrator)
        )
      )
    :effect (orchestrator_review_stage2 ?repair_orchestrator)
  )
  (:action confirm_regression_remediation
    :parameters (?repair_orchestrator - orchestrator_component ?runtime_environment - runtime_environment)
    :precondition
      (and
        (orchestrator_review_stage2 ?repair_orchestrator)
        (orchestrator_has_runtime_env ?repair_orchestrator ?runtime_environment)
        (not
          (orchestrator_review_finalized ?repair_orchestrator)
        )
      )
    :effect (orchestrator_review_finalized ?repair_orchestrator)
  )
  (:action finalize_review_and_flag_component_post_regression
    :parameters (?repair_orchestrator - orchestrator_component)
    :precondition
      (and
        (orchestrator_review_finalized ?repair_orchestrator)
        (not
          (orchestrator_finalized ?repair_orchestrator)
        )
      )
    :effect
      (and
        (orchestrator_finalized ?repair_orchestrator)
        (issue_confirmed ?repair_orchestrator)
      )
  )
  (:action promote_instance
    :parameters (?service_instance - service_instance ?build_candidate - build_candidate)
    :precondition
      (and
        (instance_flagged ?service_instance)
        (instance_ready ?service_instance)
        (build_candidate_prepared ?build_candidate)
        (candidate_tests_executed ?build_candidate)
        (not
          (issue_confirmed ?service_instance)
        )
      )
    :effect (issue_confirmed ?service_instance)
  )
  (:action promote_session
    :parameters (?client_session - client_session ?build_candidate - build_candidate)
    :precondition
      (and
        (session_flagged ?client_session)
        (session_ready ?client_session)
        (build_candidate_prepared ?build_candidate)
        (candidate_tests_executed ?build_candidate)
        (not
          (issue_confirmed ?client_session)
        )
      )
    :effect (issue_confirmed ?client_session)
  )
  (:action prepare_patch_candidate
    :parameters (?software_component - software_component ?trace_artifact - trace_artifact ?test_case - test_case)
    :precondition
      (and
        (issue_confirmed ?software_component)
        (test_assigned ?software_component ?test_case)
        (trace_artifact_available ?trace_artifact)
        (not
          (patch_ready ?software_component)
        )
      )
    :effect
      (and
        (patch_ready ?software_component)
        (component_linked_to_trace ?software_component ?trace_artifact)
        (not
          (trace_artifact_available ?trace_artifact)
        )
      )
  )
  (:action apply_patch_to_instance
    :parameters (?service_instance - service_instance ?patch_resource - patch_resource ?trace_artifact - trace_artifact)
    :precondition
      (and
        (patch_ready ?service_instance)
        (has_patch_resource ?service_instance ?patch_resource)
        (component_linked_to_trace ?service_instance ?trace_artifact)
        (not
          (patch_applied ?service_instance)
        )
      )
    :effect
      (and
        (patch_applied ?service_instance)
        (patch_resource_available ?patch_resource)
        (trace_artifact_available ?trace_artifact)
      )
  )
  (:action apply_patch_to_session
    :parameters (?client_session - client_session ?patch_resource - patch_resource ?trace_artifact - trace_artifact)
    :precondition
      (and
        (patch_ready ?client_session)
        (has_patch_resource ?client_session ?patch_resource)
        (component_linked_to_trace ?client_session ?trace_artifact)
        (not
          (patch_applied ?client_session)
        )
      )
    :effect
      (and
        (patch_applied ?client_session)
        (patch_resource_available ?patch_resource)
        (trace_artifact_available ?trace_artifact)
      )
  )
  (:action apply_patch_to_orchestrator
    :parameters (?repair_orchestrator - orchestrator_component ?patch_resource - patch_resource ?trace_artifact - trace_artifact)
    :precondition
      (and
        (patch_ready ?repair_orchestrator)
        (has_patch_resource ?repair_orchestrator ?patch_resource)
        (component_linked_to_trace ?repair_orchestrator ?trace_artifact)
        (not
          (patch_applied ?repair_orchestrator)
        )
      )
    :effect
      (and
        (patch_applied ?repair_orchestrator)
        (patch_resource_available ?patch_resource)
        (trace_artifact_available ?trace_artifact)
      )
  )
)

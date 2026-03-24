(define (domain edge_case_crash_resolution_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types component_type - object resource_type - object actor_type - object case_class - object case_entity - case_class assignee_resource - component_type test_case - component_type debug_tool - component_type approval_token - component_type test_suite - component_type checkpoint - component_type external_resource - component_type auxiliary_resource - component_type candidate_patch - resource_type environment_configuration - resource_type stakeholder - resource_type evidence_fragment_primary - actor_type evidence_fragment_secondary - actor_type triage_artifact - actor_type component_class - case_entity engineer_class - case_entity suspect_component - component_class dependent_component - component_class engineer - engineer_class)
  (:predicates
    (reported_flag_for_subject ?case_entity - case_entity)
    (triaged_flag_for_subject ?case_entity - case_entity)
    (assigned_flag_for_subject ?case_entity - case_entity)
    (resolved_flag_for_subject ?case_entity - case_entity)
    (finalized_flag_for_subject ?case_entity - case_entity)
    (fix_applied_flag_for_subject ?case_entity - case_entity)
    (resource_available ?assignee_resource - assignee_resource)
    (assignee_link ?case_entity - case_entity ?assignee_resource - assignee_resource)
    (test_available ?test_case - test_case)
    (reproduced_by_test_for_subject ?case_entity - case_entity ?test_case - test_case)
    (tool_available ?debug_tool - debug_tool)
    (tool_allocated ?case_entity - case_entity ?debug_tool - debug_tool)
    (patch_available ?candidate_patch - candidate_patch)
    (component_patch_candidate ?suspect_component - suspect_component ?candidate_patch - candidate_patch)
    (dependent_patch_candidate ?dependent_component - dependent_component ?candidate_patch - candidate_patch)
    (component_evidence_link ?suspect_component - suspect_component ?evidence_fragment_primary - evidence_fragment_primary)
    (evidence_validated_primary ?evidence_fragment_primary - evidence_fragment_primary)
    (evidence_correlated_primary ?evidence_fragment_primary - evidence_fragment_primary)
    (component_verified ?suspect_component - suspect_component)
    (dependent_evidence_link ?dependent_component - dependent_component ?evidence_fragment_secondary - evidence_fragment_secondary)
    (evidence_validated_secondary ?evidence_fragment_secondary - evidence_fragment_secondary)
    (evidence_correlated_secondary ?evidence_fragment_secondary - evidence_fragment_secondary)
    (dependent_verified ?dependent_component - dependent_component)
    (artifact_available ?triage_artifact - triage_artifact)
    (artifact_created ?triage_artifact - triage_artifact)
    (artifact_contains_primary_evidence ?triage_artifact - triage_artifact ?evidence_fragment_primary - evidence_fragment_primary)
    (artifact_contains_secondary_evidence ?triage_artifact - triage_artifact ?evidence_fragment_secondary - evidence_fragment_secondary)
    (artifact_flag_a ?triage_artifact - triage_artifact)
    (artifact_flag_b ?triage_artifact - triage_artifact)
    (artifact_validated_for_component ?triage_artifact - triage_artifact)
    (engineer_has_component_context ?engineer - engineer ?suspect_component - suspect_component)
    (engineer_has_dependent_context ?engineer - engineer ?dependent_component - dependent_component)
    (engineer_bound_to_artifact ?engineer - engineer ?triage_artifact - triage_artifact)
    (env_snapshot_available ?environment_configuration - environment_configuration)
    (engineer_has_env_link ?engineer - engineer ?environment_configuration - environment_configuration)
    (env_consumed ?environment_configuration - environment_configuration)
    (env_associated_with_artifact ?environment_configuration - environment_configuration ?triage_artifact - triage_artifact)
    (engineer_context_initialized ?engineer - engineer)
    (analysis_phase_one_complete ?engineer - engineer)
    (analysis_phase_two_complete ?engineer - engineer)
    (engineer_approval_slot ?engineer - engineer)
    (engineer_context_enhanced ?engineer - engineer)
    (engineer_ready_for_integration ?engineer - engineer)
    (engineer_integration_prepared ?engineer - engineer)
    (stakeholder_approval_available ?stakeholder - stakeholder)
    (engineer_has_stakeholder_link ?engineer - engineer ?stakeholder - stakeholder)
    (engineer_stakeholder_engaged ?engineer - engineer)
    (engineer_ready_for_approval ?engineer - engineer)
    (engineer_approval_obtained ?engineer - engineer)
    (approval_token_available ?approval_token - approval_token)
    (engineer_approval_link ?engineer - engineer ?approval_token - approval_token)
    (test_suite_available ?test_suite - test_suite)
    (engineer_has_test_suite ?engineer - engineer ?test_suite - test_suite)
    (external_resource_available ?external_resource - external_resource)
    (engineer_has_external_resource ?engineer - engineer ?external_resource - external_resource)
    (aux_resource_available ?auxiliary_resource - auxiliary_resource)
    (engineer_has_aux_resource ?engineer - engineer ?auxiliary_resource - auxiliary_resource)
    (checkpoint_available ?checkpoint - checkpoint)
    (case_linked_to_checkpoint ?case_entity - case_entity ?checkpoint - checkpoint)
    (component_investigation_ready ?suspect_component - suspect_component)
    (dependent_investigation_ready ?dependent_component - dependent_component)
    (engineer_ready_for_closure ?engineer - engineer)
  )
  (:action report_case
    :parameters (?case_entity - case_entity)
    :precondition
      (and
        (not
          (reported_flag_for_subject ?case_entity)
        )
        (not
          (resolved_flag_for_subject ?case_entity)
        )
      )
    :effect (reported_flag_for_subject ?case_entity)
  )
  (:action assign_assignee_to_case
    :parameters (?case_entity - case_entity ?assignee_resource - assignee_resource)
    :precondition
      (and
        (reported_flag_for_subject ?case_entity)
        (not
          (assigned_flag_for_subject ?case_entity)
        )
        (resource_available ?assignee_resource)
      )
    :effect
      (and
        (assigned_flag_for_subject ?case_entity)
        (assignee_link ?case_entity ?assignee_resource)
        (not
          (resource_available ?assignee_resource)
        )
      )
  )
  (:action reproduce_with_test
    :parameters (?case_entity - case_entity ?test_case - test_case)
    :precondition
      (and
        (reported_flag_for_subject ?case_entity)
        (assigned_flag_for_subject ?case_entity)
        (test_available ?test_case)
      )
    :effect
      (and
        (reproduced_by_test_for_subject ?case_entity ?test_case)
        (not
          (test_available ?test_case)
        )
      )
  )
  (:action mark_case_triaged
    :parameters (?case_entity - case_entity ?test_case - test_case)
    :precondition
      (and
        (reported_flag_for_subject ?case_entity)
        (assigned_flag_for_subject ?case_entity)
        (reproduced_by_test_for_subject ?case_entity ?test_case)
        (not
          (triaged_flag_for_subject ?case_entity)
        )
      )
    :effect (triaged_flag_for_subject ?case_entity)
  )
  (:action release_test
    :parameters (?case_entity - case_entity ?test_case - test_case)
    :precondition
      (and
        (reproduced_by_test_for_subject ?case_entity ?test_case)
      )
    :effect
      (and
        (test_available ?test_case)
        (not
          (reproduced_by_test_for_subject ?case_entity ?test_case)
        )
      )
  )
  (:action allocate_tool_to_case
    :parameters (?case_entity - case_entity ?debug_tool - debug_tool)
    :precondition
      (and
        (triaged_flag_for_subject ?case_entity)
        (tool_available ?debug_tool)
      )
    :effect
      (and
        (tool_allocated ?case_entity ?debug_tool)
        (not
          (tool_available ?debug_tool)
        )
      )
  )
  (:action release_tool_from_case
    :parameters (?case_entity - case_entity ?debug_tool - debug_tool)
    :precondition
      (and
        (tool_allocated ?case_entity ?debug_tool)
      )
    :effect
      (and
        (tool_available ?debug_tool)
        (not
          (tool_allocated ?case_entity ?debug_tool)
        )
      )
  )
  (:action engineer_claim_external_resource
    :parameters (?engineer - engineer ?external_resource - external_resource)
    :precondition
      (and
        (triaged_flag_for_subject ?engineer)
        (external_resource_available ?external_resource)
      )
    :effect
      (and
        (engineer_has_external_resource ?engineer ?external_resource)
        (not
          (external_resource_available ?external_resource)
        )
      )
  )
  (:action engineer_release_external_resource
    :parameters (?engineer - engineer ?external_resource - external_resource)
    :precondition
      (and
        (engineer_has_external_resource ?engineer ?external_resource)
      )
    :effect
      (and
        (external_resource_available ?external_resource)
        (not
          (engineer_has_external_resource ?engineer ?external_resource)
        )
      )
  )
  (:action engineer_claim_aux_resource
    :parameters (?engineer - engineer ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (triaged_flag_for_subject ?engineer)
        (aux_resource_available ?auxiliary_resource)
      )
    :effect
      (and
        (engineer_has_aux_resource ?engineer ?auxiliary_resource)
        (not
          (aux_resource_available ?auxiliary_resource)
        )
      )
  )
  (:action engineer_release_aux_resource
    :parameters (?engineer - engineer ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (engineer_has_aux_resource ?engineer ?auxiliary_resource)
      )
    :effect
      (and
        (aux_resource_available ?auxiliary_resource)
        (not
          (engineer_has_aux_resource ?engineer ?auxiliary_resource)
        )
      )
  )
  (:action validate_primary_evidence
    :parameters (?suspect_component - suspect_component ?evidence_fragment_primary - evidence_fragment_primary ?test_case - test_case)
    :precondition
      (and
        (triaged_flag_for_subject ?suspect_component)
        (reproduced_by_test_for_subject ?suspect_component ?test_case)
        (component_evidence_link ?suspect_component ?evidence_fragment_primary)
        (not
          (evidence_validated_primary ?evidence_fragment_primary)
        )
        (not
          (evidence_correlated_primary ?evidence_fragment_primary)
        )
      )
    :effect (evidence_validated_primary ?evidence_fragment_primary)
  )
  (:action verify_component_with_tool
    :parameters (?suspect_component - suspect_component ?evidence_fragment_primary - evidence_fragment_primary ?debug_tool - debug_tool)
    :precondition
      (and
        (triaged_flag_for_subject ?suspect_component)
        (tool_allocated ?suspect_component ?debug_tool)
        (component_evidence_link ?suspect_component ?evidence_fragment_primary)
        (evidence_validated_primary ?evidence_fragment_primary)
        (not
          (component_investigation_ready ?suspect_component)
        )
      )
    :effect
      (and
        (component_investigation_ready ?suspect_component)
        (component_verified ?suspect_component)
      )
  )
  (:action correlate_primary_evidence_and_link_patch
    :parameters (?suspect_component - suspect_component ?evidence_fragment_primary - evidence_fragment_primary ?candidate_patch - candidate_patch)
    :precondition
      (and
        (triaged_flag_for_subject ?suspect_component)
        (component_evidence_link ?suspect_component ?evidence_fragment_primary)
        (patch_available ?candidate_patch)
        (not
          (component_investigation_ready ?suspect_component)
        )
      )
    :effect
      (and
        (evidence_correlated_primary ?evidence_fragment_primary)
        (component_investigation_ready ?suspect_component)
        (component_patch_candidate ?suspect_component ?candidate_patch)
        (not
          (patch_available ?candidate_patch)
        )
      )
  )
  (:action finalize_primary_evidence_correlation
    :parameters (?suspect_component - suspect_component ?evidence_fragment_primary - evidence_fragment_primary ?test_case - test_case ?candidate_patch - candidate_patch)
    :precondition
      (and
        (triaged_flag_for_subject ?suspect_component)
        (reproduced_by_test_for_subject ?suspect_component ?test_case)
        (component_evidence_link ?suspect_component ?evidence_fragment_primary)
        (evidence_correlated_primary ?evidence_fragment_primary)
        (component_patch_candidate ?suspect_component ?candidate_patch)
        (not
          (component_verified ?suspect_component)
        )
      )
    :effect
      (and
        (evidence_validated_primary ?evidence_fragment_primary)
        (component_verified ?suspect_component)
        (patch_available ?candidate_patch)
        (not
          (component_patch_candidate ?suspect_component ?candidate_patch)
        )
      )
  )
  (:action validate_secondary_evidence
    :parameters (?dependent_component - dependent_component ?evidence_fragment_secondary - evidence_fragment_secondary ?test_case - test_case)
    :precondition
      (and
        (triaged_flag_for_subject ?dependent_component)
        (reproduced_by_test_for_subject ?dependent_component ?test_case)
        (dependent_evidence_link ?dependent_component ?evidence_fragment_secondary)
        (not
          (evidence_validated_secondary ?evidence_fragment_secondary)
        )
        (not
          (evidence_correlated_secondary ?evidence_fragment_secondary)
        )
      )
    :effect (evidence_validated_secondary ?evidence_fragment_secondary)
  )
  (:action verify_dependent_with_tool
    :parameters (?dependent_component - dependent_component ?evidence_fragment_secondary - evidence_fragment_secondary ?debug_tool - debug_tool)
    :precondition
      (and
        (triaged_flag_for_subject ?dependent_component)
        (tool_allocated ?dependent_component ?debug_tool)
        (dependent_evidence_link ?dependent_component ?evidence_fragment_secondary)
        (evidence_validated_secondary ?evidence_fragment_secondary)
        (not
          (dependent_investigation_ready ?dependent_component)
        )
      )
    :effect
      (and
        (dependent_investigation_ready ?dependent_component)
        (dependent_verified ?dependent_component)
      )
  )
  (:action correlate_secondary_evidence_and_link_patch
    :parameters (?dependent_component - dependent_component ?evidence_fragment_secondary - evidence_fragment_secondary ?candidate_patch - candidate_patch)
    :precondition
      (and
        (triaged_flag_for_subject ?dependent_component)
        (dependent_evidence_link ?dependent_component ?evidence_fragment_secondary)
        (patch_available ?candidate_patch)
        (not
          (dependent_investigation_ready ?dependent_component)
        )
      )
    :effect
      (and
        (evidence_correlated_secondary ?evidence_fragment_secondary)
        (dependent_investigation_ready ?dependent_component)
        (dependent_patch_candidate ?dependent_component ?candidate_patch)
        (not
          (patch_available ?candidate_patch)
        )
      )
  )
  (:action finalize_secondary_evidence_correlation
    :parameters (?dependent_component - dependent_component ?evidence_fragment_secondary - evidence_fragment_secondary ?test_case - test_case ?candidate_patch - candidate_patch)
    :precondition
      (and
        (triaged_flag_for_subject ?dependent_component)
        (reproduced_by_test_for_subject ?dependent_component ?test_case)
        (dependent_evidence_link ?dependent_component ?evidence_fragment_secondary)
        (evidence_correlated_secondary ?evidence_fragment_secondary)
        (dependent_patch_candidate ?dependent_component ?candidate_patch)
        (not
          (dependent_verified ?dependent_component)
        )
      )
    :effect
      (and
        (evidence_validated_secondary ?evidence_fragment_secondary)
        (dependent_verified ?dependent_component)
        (patch_available ?candidate_patch)
        (not
          (dependent_patch_candidate ?dependent_component ?candidate_patch)
        )
      )
  )
  (:action create_triage_artifact
    :parameters (?suspect_component - suspect_component ?dependent_component - dependent_component ?evidence_fragment_primary - evidence_fragment_primary ?evidence_fragment_secondary - evidence_fragment_secondary ?triage_artifact - triage_artifact)
    :precondition
      (and
        (component_investigation_ready ?suspect_component)
        (dependent_investigation_ready ?dependent_component)
        (component_evidence_link ?suspect_component ?evidence_fragment_primary)
        (dependent_evidence_link ?dependent_component ?evidence_fragment_secondary)
        (evidence_validated_primary ?evidence_fragment_primary)
        (evidence_validated_secondary ?evidence_fragment_secondary)
        (component_verified ?suspect_component)
        (dependent_verified ?dependent_component)
        (artifact_available ?triage_artifact)
      )
    :effect
      (and
        (artifact_created ?triage_artifact)
        (artifact_contains_primary_evidence ?triage_artifact ?evidence_fragment_primary)
        (artifact_contains_secondary_evidence ?triage_artifact ?evidence_fragment_secondary)
        (not
          (artifact_available ?triage_artifact)
        )
      )
  )
  (:action create_triage_artifact_with_flag_a
    :parameters (?suspect_component - suspect_component ?dependent_component - dependent_component ?evidence_fragment_primary - evidence_fragment_primary ?evidence_fragment_secondary - evidence_fragment_secondary ?triage_artifact - triage_artifact)
    :precondition
      (and
        (component_investigation_ready ?suspect_component)
        (dependent_investigation_ready ?dependent_component)
        (component_evidence_link ?suspect_component ?evidence_fragment_primary)
        (dependent_evidence_link ?dependent_component ?evidence_fragment_secondary)
        (evidence_correlated_primary ?evidence_fragment_primary)
        (evidence_validated_secondary ?evidence_fragment_secondary)
        (not
          (component_verified ?suspect_component)
        )
        (dependent_verified ?dependent_component)
        (artifact_available ?triage_artifact)
      )
    :effect
      (and
        (artifact_created ?triage_artifact)
        (artifact_contains_primary_evidence ?triage_artifact ?evidence_fragment_primary)
        (artifact_contains_secondary_evidence ?triage_artifact ?evidence_fragment_secondary)
        (artifact_flag_a ?triage_artifact)
        (not
          (artifact_available ?triage_artifact)
        )
      )
  )
  (:action create_triage_artifact_with_flag_b
    :parameters (?suspect_component - suspect_component ?dependent_component - dependent_component ?evidence_fragment_primary - evidence_fragment_primary ?evidence_fragment_secondary - evidence_fragment_secondary ?triage_artifact - triage_artifact)
    :precondition
      (and
        (component_investigation_ready ?suspect_component)
        (dependent_investigation_ready ?dependent_component)
        (component_evidence_link ?suspect_component ?evidence_fragment_primary)
        (dependent_evidence_link ?dependent_component ?evidence_fragment_secondary)
        (evidence_validated_primary ?evidence_fragment_primary)
        (evidence_correlated_secondary ?evidence_fragment_secondary)
        (component_verified ?suspect_component)
        (not
          (dependent_verified ?dependent_component)
        )
        (artifact_available ?triage_artifact)
      )
    :effect
      (and
        (artifact_created ?triage_artifact)
        (artifact_contains_primary_evidence ?triage_artifact ?evidence_fragment_primary)
        (artifact_contains_secondary_evidence ?triage_artifact ?evidence_fragment_secondary)
        (artifact_flag_b ?triage_artifact)
        (not
          (artifact_available ?triage_artifact)
        )
      )
  )
  (:action create_triage_artifact_with_both_flags
    :parameters (?suspect_component - suspect_component ?dependent_component - dependent_component ?evidence_fragment_primary - evidence_fragment_primary ?evidence_fragment_secondary - evidence_fragment_secondary ?triage_artifact - triage_artifact)
    :precondition
      (and
        (component_investigation_ready ?suspect_component)
        (dependent_investigation_ready ?dependent_component)
        (component_evidence_link ?suspect_component ?evidence_fragment_primary)
        (dependent_evidence_link ?dependent_component ?evidence_fragment_secondary)
        (evidence_correlated_primary ?evidence_fragment_primary)
        (evidence_correlated_secondary ?evidence_fragment_secondary)
        (not
          (component_verified ?suspect_component)
        )
        (not
          (dependent_verified ?dependent_component)
        )
        (artifact_available ?triage_artifact)
      )
    :effect
      (and
        (artifact_created ?triage_artifact)
        (artifact_contains_primary_evidence ?triage_artifact ?evidence_fragment_primary)
        (artifact_contains_secondary_evidence ?triage_artifact ?evidence_fragment_secondary)
        (artifact_flag_a ?triage_artifact)
        (artifact_flag_b ?triage_artifact)
        (not
          (artifact_available ?triage_artifact)
        )
      )
  )
  (:action validate_artifact_for_component
    :parameters (?triage_artifact - triage_artifact ?suspect_component - suspect_component ?test_case - test_case)
    :precondition
      (and
        (artifact_created ?triage_artifact)
        (component_investigation_ready ?suspect_component)
        (reproduced_by_test_for_subject ?suspect_component ?test_case)
        (not
          (artifact_validated_for_component ?triage_artifact)
        )
      )
    :effect (artifact_validated_for_component ?triage_artifact)
  )
  (:action attach_env_to_artifact
    :parameters (?engineer - engineer ?environment_configuration - environment_configuration ?triage_artifact - triage_artifact)
    :precondition
      (and
        (triaged_flag_for_subject ?engineer)
        (engineer_bound_to_artifact ?engineer ?triage_artifact)
        (engineer_has_env_link ?engineer ?environment_configuration)
        (env_snapshot_available ?environment_configuration)
        (artifact_created ?triage_artifact)
        (artifact_validated_for_component ?triage_artifact)
        (not
          (env_consumed ?environment_configuration)
        )
      )
    :effect
      (and
        (env_consumed ?environment_configuration)
        (env_associated_with_artifact ?environment_configuration ?triage_artifact)
        (not
          (env_snapshot_available ?environment_configuration)
        )
      )
  )
  (:action initialize_engineer_context
    :parameters (?engineer - engineer ?environment_configuration - environment_configuration ?triage_artifact - triage_artifact ?test_case - test_case)
    :precondition
      (and
        (triaged_flag_for_subject ?engineer)
        (engineer_has_env_link ?engineer ?environment_configuration)
        (env_consumed ?environment_configuration)
        (env_associated_with_artifact ?environment_configuration ?triage_artifact)
        (reproduced_by_test_for_subject ?engineer ?test_case)
        (not
          (artifact_flag_a ?triage_artifact)
        )
        (not
          (engineer_context_initialized ?engineer)
        )
      )
    :effect (engineer_context_initialized ?engineer)
  )
  (:action claim_approval_token
    :parameters (?engineer - engineer ?approval_token - approval_token)
    :precondition
      (and
        (triaged_flag_for_subject ?engineer)
        (approval_token_available ?approval_token)
        (not
          (engineer_approval_slot ?engineer)
        )
      )
    :effect
      (and
        (engineer_approval_slot ?engineer)
        (engineer_approval_link ?engineer ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action enhance_engineer_context
    :parameters (?engineer - engineer ?environment_configuration - environment_configuration ?triage_artifact - triage_artifact ?test_case - test_case ?approval_token - approval_token)
    :precondition
      (and
        (triaged_flag_for_subject ?engineer)
        (engineer_has_env_link ?engineer ?environment_configuration)
        (env_consumed ?environment_configuration)
        (env_associated_with_artifact ?environment_configuration ?triage_artifact)
        (reproduced_by_test_for_subject ?engineer ?test_case)
        (artifact_flag_a ?triage_artifact)
        (engineer_approval_slot ?engineer)
        (engineer_approval_link ?engineer ?approval_token)
        (not
          (engineer_context_initialized ?engineer)
        )
      )
    :effect
      (and
        (engineer_context_initialized ?engineer)
        (engineer_context_enhanced ?engineer)
      )
  )
  (:action mark_analysis_phase_one_complete
    :parameters (?engineer - engineer ?external_resource - external_resource ?debug_tool - debug_tool ?environment_configuration - environment_configuration ?triage_artifact - triage_artifact)
    :precondition
      (and
        (engineer_context_initialized ?engineer)
        (engineer_has_external_resource ?engineer ?external_resource)
        (tool_allocated ?engineer ?debug_tool)
        (engineer_has_env_link ?engineer ?environment_configuration)
        (env_associated_with_artifact ?environment_configuration ?triage_artifact)
        (not
          (artifact_flag_b ?triage_artifact)
        )
        (not
          (analysis_phase_one_complete ?engineer)
        )
      )
    :effect (analysis_phase_one_complete ?engineer)
  )
  (:action mark_analysis_phase_one_complete_with_artifact_flag
    :parameters (?engineer - engineer ?external_resource - external_resource ?debug_tool - debug_tool ?environment_configuration - environment_configuration ?triage_artifact - triage_artifact)
    :precondition
      (and
        (engineer_context_initialized ?engineer)
        (engineer_has_external_resource ?engineer ?external_resource)
        (tool_allocated ?engineer ?debug_tool)
        (engineer_has_env_link ?engineer ?environment_configuration)
        (env_associated_with_artifact ?environment_configuration ?triage_artifact)
        (artifact_flag_b ?triage_artifact)
        (not
          (analysis_phase_one_complete ?engineer)
        )
      )
    :effect (analysis_phase_one_complete ?engineer)
  )
  (:action complete_analysis_phase_two
    :parameters (?engineer - engineer ?auxiliary_resource - auxiliary_resource ?environment_configuration - environment_configuration ?triage_artifact - triage_artifact)
    :precondition
      (and
        (analysis_phase_one_complete ?engineer)
        (engineer_has_aux_resource ?engineer ?auxiliary_resource)
        (engineer_has_env_link ?engineer ?environment_configuration)
        (env_associated_with_artifact ?environment_configuration ?triage_artifact)
        (not
          (artifact_flag_a ?triage_artifact)
        )
        (not
          (artifact_flag_b ?triage_artifact)
        )
        (not
          (analysis_phase_two_complete ?engineer)
        )
      )
    :effect (analysis_phase_two_complete ?engineer)
  )
  (:action complete_analysis_phase_two_and_ready_for_integration
    :parameters (?engineer - engineer ?auxiliary_resource - auxiliary_resource ?environment_configuration - environment_configuration ?triage_artifact - triage_artifact)
    :precondition
      (and
        (analysis_phase_one_complete ?engineer)
        (engineer_has_aux_resource ?engineer ?auxiliary_resource)
        (engineer_has_env_link ?engineer ?environment_configuration)
        (env_associated_with_artifact ?environment_configuration ?triage_artifact)
        (artifact_flag_a ?triage_artifact)
        (not
          (artifact_flag_b ?triage_artifact)
        )
        (not
          (analysis_phase_two_complete ?engineer)
        )
      )
    :effect
      (and
        (analysis_phase_two_complete ?engineer)
        (engineer_ready_for_integration ?engineer)
      )
  )
  (:action complete_analysis_phase_two_and_ready_for_integration_alt
    :parameters (?engineer - engineer ?auxiliary_resource - auxiliary_resource ?environment_configuration - environment_configuration ?triage_artifact - triage_artifact)
    :precondition
      (and
        (analysis_phase_one_complete ?engineer)
        (engineer_has_aux_resource ?engineer ?auxiliary_resource)
        (engineer_has_env_link ?engineer ?environment_configuration)
        (env_associated_with_artifact ?environment_configuration ?triage_artifact)
        (not
          (artifact_flag_a ?triage_artifact)
        )
        (artifact_flag_b ?triage_artifact)
        (not
          (analysis_phase_two_complete ?engineer)
        )
      )
    :effect
      (and
        (analysis_phase_two_complete ?engineer)
        (engineer_ready_for_integration ?engineer)
      )
  )
  (:action complete_analysis_phase_two_and_ready_for_integration_full
    :parameters (?engineer - engineer ?auxiliary_resource - auxiliary_resource ?environment_configuration - environment_configuration ?triage_artifact - triage_artifact)
    :precondition
      (and
        (analysis_phase_one_complete ?engineer)
        (engineer_has_aux_resource ?engineer ?auxiliary_resource)
        (engineer_has_env_link ?engineer ?environment_configuration)
        (env_associated_with_artifact ?environment_configuration ?triage_artifact)
        (artifact_flag_a ?triage_artifact)
        (artifact_flag_b ?triage_artifact)
        (not
          (analysis_phase_two_complete ?engineer)
        )
      )
    :effect
      (and
        (analysis_phase_two_complete ?engineer)
        (engineer_ready_for_integration ?engineer)
      )
  )
  (:action finalize_engineer_for_integration
    :parameters (?engineer - engineer)
    :precondition
      (and
        (analysis_phase_two_complete ?engineer)
        (not
          (engineer_ready_for_integration ?engineer)
        )
        (not
          (engineer_ready_for_closure ?engineer)
        )
      )
    :effect
      (and
        (engineer_ready_for_closure ?engineer)
        (finalized_flag_for_subject ?engineer)
      )
  )
  (:action assign_test_suite_to_engineer
    :parameters (?engineer - engineer ?test_suite - test_suite)
    :precondition
      (and
        (analysis_phase_two_complete ?engineer)
        (engineer_ready_for_integration ?engineer)
        (test_suite_available ?test_suite)
      )
    :effect
      (and
        (engineer_has_test_suite ?engineer ?test_suite)
        (not
          (test_suite_available ?test_suite)
        )
      )
  )
  (:action prepare_engineer_for_integration
    :parameters (?engineer - engineer ?suspect_component - suspect_component ?dependent_component - dependent_component ?test_case - test_case ?test_suite - test_suite)
    :precondition
      (and
        (analysis_phase_two_complete ?engineer)
        (engineer_ready_for_integration ?engineer)
        (engineer_has_test_suite ?engineer ?test_suite)
        (engineer_has_component_context ?engineer ?suspect_component)
        (engineer_has_dependent_context ?engineer ?dependent_component)
        (component_verified ?suspect_component)
        (dependent_verified ?dependent_component)
        (reproduced_by_test_for_subject ?engineer ?test_case)
        (not
          (engineer_integration_prepared ?engineer)
        )
      )
    :effect (engineer_integration_prepared ?engineer)
  )
  (:action finalize_engineer_integration
    :parameters (?engineer - engineer)
    :precondition
      (and
        (analysis_phase_two_complete ?engineer)
        (engineer_integration_prepared ?engineer)
        (not
          (engineer_ready_for_closure ?engineer)
        )
      )
    :effect
      (and
        (engineer_ready_for_closure ?engineer)
        (finalized_flag_for_subject ?engineer)
      )
  )
  (:action engage_stakeholder_for_approval
    :parameters (?engineer - engineer ?stakeholder - stakeholder ?test_case - test_case)
    :precondition
      (and
        (triaged_flag_for_subject ?engineer)
        (reproduced_by_test_for_subject ?engineer ?test_case)
        (stakeholder_approval_available ?stakeholder)
        (engineer_has_stakeholder_link ?engineer ?stakeholder)
        (not
          (engineer_stakeholder_engaged ?engineer)
        )
      )
    :effect
      (and
        (engineer_stakeholder_engaged ?engineer)
        (not
          (stakeholder_approval_available ?stakeholder)
        )
      )
  )
  (:action prepare_engineer_for_approval
    :parameters (?engineer - engineer ?debug_tool - debug_tool)
    :precondition
      (and
        (engineer_stakeholder_engaged ?engineer)
        (tool_allocated ?engineer ?debug_tool)
        (not
          (engineer_ready_for_approval ?engineer)
        )
      )
    :effect (engineer_ready_for_approval ?engineer)
  )
  (:action obtain_engineer_approval
    :parameters (?engineer - engineer ?auxiliary_resource - auxiliary_resource)
    :precondition
      (and
        (engineer_ready_for_approval ?engineer)
        (engineer_has_aux_resource ?engineer ?auxiliary_resource)
        (not
          (engineer_approval_obtained ?engineer)
        )
      )
    :effect (engineer_approval_obtained ?engineer)
  )
  (:action finalize_engineer_post_approval
    :parameters (?engineer - engineer)
    :precondition
      (and
        (engineer_approval_obtained ?engineer)
        (not
          (engineer_ready_for_closure ?engineer)
        )
      )
    :effect
      (and
        (engineer_ready_for_closure ?engineer)
        (finalized_flag_for_subject ?engineer)
      )
  )
  (:action finalize_component_resolution
    :parameters (?suspect_component - suspect_component ?triage_artifact - triage_artifact)
    :precondition
      (and
        (component_investigation_ready ?suspect_component)
        (component_verified ?suspect_component)
        (artifact_created ?triage_artifact)
        (artifact_validated_for_component ?triage_artifact)
        (not
          (finalized_flag_for_subject ?suspect_component)
        )
      )
    :effect (finalized_flag_for_subject ?suspect_component)
  )
  (:action finalize_dependent_resolution
    :parameters (?dependent_component - dependent_component ?triage_artifact - triage_artifact)
    :precondition
      (and
        (dependent_investigation_ready ?dependent_component)
        (dependent_verified ?dependent_component)
        (artifact_created ?triage_artifact)
        (artifact_validated_for_component ?triage_artifact)
        (not
          (finalized_flag_for_subject ?dependent_component)
        )
      )
    :effect (finalized_flag_for_subject ?dependent_component)
  )
  (:action apply_fix_and_link_checkpoint
    :parameters (?case_entity - case_entity ?checkpoint - checkpoint ?test_case - test_case)
    :precondition
      (and
        (finalized_flag_for_subject ?case_entity)
        (reproduced_by_test_for_subject ?case_entity ?test_case)
        (checkpoint_available ?checkpoint)
        (not
          (fix_applied_flag_for_subject ?case_entity)
        )
      )
    :effect
      (and
        (fix_applied_flag_for_subject ?case_entity)
        (case_linked_to_checkpoint ?case_entity ?checkpoint)
        (not
          (checkpoint_available ?checkpoint)
        )
      )
  )
  (:action resolve_component_and_release_resource
    :parameters (?suspect_component - suspect_component ?assignee_resource - assignee_resource ?checkpoint - checkpoint)
    :precondition
      (and
        (fix_applied_flag_for_subject ?suspect_component)
        (assignee_link ?suspect_component ?assignee_resource)
        (case_linked_to_checkpoint ?suspect_component ?checkpoint)
        (not
          (resolved_flag_for_subject ?suspect_component)
        )
      )
    :effect
      (and
        (resolved_flag_for_subject ?suspect_component)
        (resource_available ?assignee_resource)
        (checkpoint_available ?checkpoint)
      )
  )
  (:action resolve_dependent_and_release_resource
    :parameters (?dependent_component - dependent_component ?assignee_resource - assignee_resource ?checkpoint - checkpoint)
    :precondition
      (and
        (fix_applied_flag_for_subject ?dependent_component)
        (assignee_link ?dependent_component ?assignee_resource)
        (case_linked_to_checkpoint ?dependent_component ?checkpoint)
        (not
          (resolved_flag_for_subject ?dependent_component)
        )
      )
    :effect
      (and
        (resolved_flag_for_subject ?dependent_component)
        (resource_available ?assignee_resource)
        (checkpoint_available ?checkpoint)
      )
  )
  (:action resolve_subject_and_release_resource
    :parameters (?engineer - engineer ?assignee_resource - assignee_resource ?checkpoint - checkpoint)
    :precondition
      (and
        (fix_applied_flag_for_subject ?engineer)
        (assignee_link ?engineer ?assignee_resource)
        (case_linked_to_checkpoint ?engineer ?checkpoint)
        (not
          (resolved_flag_for_subject ?engineer)
        )
      )
    :effect
      (and
        (resolved_flag_for_subject ?engineer)
        (resource_available ?assignee_resource)
        (checkpoint_available ?checkpoint)
      )
  )
)

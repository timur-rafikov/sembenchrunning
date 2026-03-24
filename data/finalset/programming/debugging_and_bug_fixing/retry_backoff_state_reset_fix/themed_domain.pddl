(define (domain retry_backoff_state_reset_fix_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types supporting_entity - object validation_artifact - object policy_and_fix - object system_entity_root - object system_component - system_entity_root backoff_slot - supporting_entity error_signature - supporting_entity operator - supporting_entity code_module - supporting_entity reviewer - supporting_entity deployment_marker - supporting_entity ci_job - supporting_entity release_candidate - supporting_entity test_asset - validation_artifact test_suite - validation_artifact stakeholder - validation_artifact backoff_policy - policy_and_fix retry_strategy - policy_and_fix fix_bundle - policy_and_fix concrete_component - system_component work_item_category - system_component client_component - concrete_component server_component - concrete_component repair_work_item - work_item_category)
  (:predicates
    (failure_observed ?component - system_component)
    (entity_diagnosed ?component - system_component)
    (backoff_allocated ?component - system_component)
    (reset_completed ?component - system_component)
    (finalized ?component - system_component)
    (reset_recorded ?component - system_component)
    (backoff_slot_available ?backoff_slot - backoff_slot)
    (allocated_backoff_slot_to_entity ?component - system_component ?backoff_slot - backoff_slot)
    (error_signature_available ?error_signature - error_signature)
    (error_bound_to_entity ?component - system_component ?error_signature - error_signature)
    (operator_available ?operator - operator)
    (assigned_operator_to_entity ?component - system_component ?operator - operator)
    (test_asset_available ?test_asset - test_asset)
    (client_bound_test_asset ?client - client_component ?test_asset - test_asset)
    (server_bound_test_asset ?server - server_component ?test_asset - test_asset)
    (client_has_backoff_policy ?client - client_component ?backoff_policy - backoff_policy)
    (policy_evaluated ?backoff_policy - backoff_policy)
    (policy_test_requested ?backoff_policy - backoff_policy)
    (client_marked_for_fix ?client - client_component)
    (server_has_retry_strategy ?server - server_component ?retry_strategy - retry_strategy)
    (strategy_evaluated ?retry_strategy - retry_strategy)
    (strategy_test_requested ?retry_strategy - retry_strategy)
    (server_marked_for_fix ?server - server_component)
    (fix_bundle_available ?fix_bundle - fix_bundle)
    (fix_bundle_staged ?fix_bundle - fix_bundle)
    (fix_bundle_applies_policy ?fix_bundle - fix_bundle ?backoff_policy - backoff_policy)
    (fix_bundle_applies_retry_strategy ?fix_bundle - fix_bundle ?retry_strategy - retry_strategy)
    (fix_bundle_variant_flag_a ?fix_bundle - fix_bundle)
    (fix_bundle_variant_flag_b ?fix_bundle - fix_bundle)
    (fix_bundle_ci_triggered ?fix_bundle - fix_bundle)
    (work_item_affects_client ?repair_work_item - repair_work_item ?client - client_component)
    (work_item_affects_server ?repair_work_item - repair_work_item ?server - server_component)
    (work_item_associated_with_bundle ?repair_work_item - repair_work_item ?fix_bundle - fix_bundle)
    (test_suite_available ?test_suite - test_suite)
    (work_item_bound_test_suite ?repair_work_item - repair_work_item ?test_suite - test_suite)
    (test_suite_selected ?test_suite - test_suite)
    (test_suite_associated_with_bundle ?test_suite - test_suite ?fix_bundle - fix_bundle)
    (work_item_ci_prepared ?repair_work_item - repair_work_item)
    (work_item_ci_scheduled ?repair_work_item - repair_work_item)
    (ci_passed ?repair_work_item - repair_work_item)
    (module_assigned ?repair_work_item - repair_work_item)
    (work_item_instrumented ?repair_work_item - repair_work_item)
    (review_required ?repair_work_item - repair_work_item)
    (review_approved ?repair_work_item - repair_work_item)
    (stakeholder_available ?stakeholder - stakeholder)
    (assigned_stakeholder_to_work_item ?repair_work_item - repair_work_item ?stakeholder - stakeholder)
    (stakeholder_acknowledged ?repair_work_item - repair_work_item)
    (operator_acknowledged ?repair_work_item - repair_work_item)
    (operator_triage_complete ?repair_work_item - repair_work_item)
    (code_module_available ?code_module - code_module)
    (work_item_associates_module ?repair_work_item - repair_work_item ?code_module - code_module)
    (reviewer_available ?reviewer - reviewer)
    (work_item_assigned_reviewer ?repair_work_item - repair_work_item ?reviewer - reviewer)
    (ci_job_available ?ci_job - ci_job)
    (work_item_assigned_ci_job ?repair_work_item - repair_work_item ?ci_job - ci_job)
    (release_candidate_available ?release_candidate - release_candidate)
    (work_item_associated_release_candidate ?repair_work_item - repair_work_item ?release_candidate - release_candidate)
    (deployment_marker_available ?deployment_marker - deployment_marker)
    (entity_has_deployment_marker ?component - system_component ?deployment_marker - deployment_marker)
    (client_ready_for_fix ?client - client_component)
    (server_ready_for_fix ?server - server_component)
    (work_item_closed ?repair_work_item - repair_work_item)
  )
  (:action detect_failure
    :parameters (?component - system_component)
    :precondition
      (and
        (not
          (failure_observed ?component)
        )
        (not
          (reset_completed ?component)
        )
      )
    :effect (failure_observed ?component)
  )
  (:action allocate_backoff_slot
    :parameters (?component - system_component ?backoff_slot - backoff_slot)
    :precondition
      (and
        (failure_observed ?component)
        (not
          (backoff_allocated ?component)
        )
        (backoff_slot_available ?backoff_slot)
      )
    :effect
      (and
        (backoff_allocated ?component)
        (allocated_backoff_slot_to_entity ?component ?backoff_slot)
        (not
          (backoff_slot_available ?backoff_slot)
        )
      )
  )
  (:action bind_error_signature
    :parameters (?component - system_component ?error_signature - error_signature)
    :precondition
      (and
        (failure_observed ?component)
        (backoff_allocated ?component)
        (error_signature_available ?error_signature)
      )
    :effect
      (and
        (error_bound_to_entity ?component ?error_signature)
        (not
          (error_signature_available ?error_signature)
        )
      )
  )
  (:action finalize_diagnosis
    :parameters (?component - system_component ?error_signature - error_signature)
    :precondition
      (and
        (failure_observed ?component)
        (backoff_allocated ?component)
        (error_bound_to_entity ?component ?error_signature)
        (not
          (entity_diagnosed ?component)
        )
      )
    :effect (entity_diagnosed ?component)
  )
  (:action unbind_error_signature
    :parameters (?component - system_component ?error_signature - error_signature)
    :precondition
      (and
        (error_bound_to_entity ?component ?error_signature)
      )
    :effect
      (and
        (error_signature_available ?error_signature)
        (not
          (error_bound_to_entity ?component ?error_signature)
        )
      )
  )
  (:action assign_operator
    :parameters (?component - system_component ?operator - operator)
    :precondition
      (and
        (entity_diagnosed ?component)
        (operator_available ?operator)
      )
    :effect
      (and
        (assigned_operator_to_entity ?component ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action unassign_operator
    :parameters (?component - system_component ?operator - operator)
    :precondition
      (and
        (assigned_operator_to_entity ?component ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (assigned_operator_to_entity ?component ?operator)
        )
      )
  )
  (:action assign_ci_job
    :parameters (?repair_work_item - repair_work_item ?ci_job - ci_job)
    :precondition
      (and
        (entity_diagnosed ?repair_work_item)
        (ci_job_available ?ci_job)
      )
    :effect
      (and
        (work_item_assigned_ci_job ?repair_work_item ?ci_job)
        (not
          (ci_job_available ?ci_job)
        )
      )
  )
  (:action unassign_ci_job
    :parameters (?repair_work_item - repair_work_item ?ci_job - ci_job)
    :precondition
      (and
        (work_item_assigned_ci_job ?repair_work_item ?ci_job)
      )
    :effect
      (and
        (ci_job_available ?ci_job)
        (not
          (work_item_assigned_ci_job ?repair_work_item ?ci_job)
        )
      )
  )
  (:action assign_release_candidate
    :parameters (?repair_work_item - repair_work_item ?release_candidate - release_candidate)
    :precondition
      (and
        (entity_diagnosed ?repair_work_item)
        (release_candidate_available ?release_candidate)
      )
    :effect
      (and
        (work_item_associated_release_candidate ?repair_work_item ?release_candidate)
        (not
          (release_candidate_available ?release_candidate)
        )
      )
  )
  (:action unassign_release_candidate
    :parameters (?repair_work_item - repair_work_item ?release_candidate - release_candidate)
    :precondition
      (and
        (work_item_associated_release_candidate ?repair_work_item ?release_candidate)
      )
    :effect
      (and
        (release_candidate_available ?release_candidate)
        (not
          (work_item_associated_release_candidate ?repair_work_item ?release_candidate)
        )
      )
  )
  (:action mark_policy_evaluated
    :parameters (?client - client_component ?backoff_policy - backoff_policy ?error_signature - error_signature)
    :precondition
      (and
        (entity_diagnosed ?client)
        (error_bound_to_entity ?client ?error_signature)
        (client_has_backoff_policy ?client ?backoff_policy)
        (not
          (policy_evaluated ?backoff_policy)
        )
        (not
          (policy_test_requested ?backoff_policy)
        )
      )
    :effect (policy_evaluated ?backoff_policy)
  )
  (:action operator_triage_client
    :parameters (?client - client_component ?backoff_policy - backoff_policy ?operator - operator)
    :precondition
      (and
        (entity_diagnosed ?client)
        (assigned_operator_to_entity ?client ?operator)
        (client_has_backoff_policy ?client ?backoff_policy)
        (policy_evaluated ?backoff_policy)
        (not
          (client_ready_for_fix ?client)
        )
      )
    :effect
      (and
        (client_ready_for_fix ?client)
        (client_marked_for_fix ?client)
      )
  )
  (:action assign_test_asset_to_client
    :parameters (?client - client_component ?backoff_policy - backoff_policy ?test_asset - test_asset)
    :precondition
      (and
        (entity_diagnosed ?client)
        (client_has_backoff_policy ?client ?backoff_policy)
        (test_asset_available ?test_asset)
        (not
          (client_ready_for_fix ?client)
        )
      )
    :effect
      (and
        (policy_test_requested ?backoff_policy)
        (client_ready_for_fix ?client)
        (client_bound_test_asset ?client ?test_asset)
        (not
          (test_asset_available ?test_asset)
        )
      )
  )
  (:action process_client_test_result
    :parameters (?client - client_component ?backoff_policy - backoff_policy ?error_signature - error_signature ?test_asset - test_asset)
    :precondition
      (and
        (entity_diagnosed ?client)
        (error_bound_to_entity ?client ?error_signature)
        (client_has_backoff_policy ?client ?backoff_policy)
        (policy_test_requested ?backoff_policy)
        (client_bound_test_asset ?client ?test_asset)
        (not
          (client_marked_for_fix ?client)
        )
      )
    :effect
      (and
        (policy_evaluated ?backoff_policy)
        (client_marked_for_fix ?client)
        (test_asset_available ?test_asset)
        (not
          (client_bound_test_asset ?client ?test_asset)
        )
      )
  )
  (:action mark_strategy_evaluated
    :parameters (?server - server_component ?retry_strategy - retry_strategy ?error_signature - error_signature)
    :precondition
      (and
        (entity_diagnosed ?server)
        (error_bound_to_entity ?server ?error_signature)
        (server_has_retry_strategy ?server ?retry_strategy)
        (not
          (strategy_evaluated ?retry_strategy)
        )
        (not
          (strategy_test_requested ?retry_strategy)
        )
      )
    :effect (strategy_evaluated ?retry_strategy)
  )
  (:action operator_triage_server
    :parameters (?server - server_component ?retry_strategy - retry_strategy ?operator - operator)
    :precondition
      (and
        (entity_diagnosed ?server)
        (assigned_operator_to_entity ?server ?operator)
        (server_has_retry_strategy ?server ?retry_strategy)
        (strategy_evaluated ?retry_strategy)
        (not
          (server_ready_for_fix ?server)
        )
      )
    :effect
      (and
        (server_ready_for_fix ?server)
        (server_marked_for_fix ?server)
      )
  )
  (:action assign_test_asset_to_server
    :parameters (?server - server_component ?retry_strategy - retry_strategy ?test_asset - test_asset)
    :precondition
      (and
        (entity_diagnosed ?server)
        (server_has_retry_strategy ?server ?retry_strategy)
        (test_asset_available ?test_asset)
        (not
          (server_ready_for_fix ?server)
        )
      )
    :effect
      (and
        (strategy_test_requested ?retry_strategy)
        (server_ready_for_fix ?server)
        (server_bound_test_asset ?server ?test_asset)
        (not
          (test_asset_available ?test_asset)
        )
      )
  )
  (:action process_server_test_result
    :parameters (?server - server_component ?retry_strategy - retry_strategy ?error_signature - error_signature ?test_asset - test_asset)
    :precondition
      (and
        (entity_diagnosed ?server)
        (error_bound_to_entity ?server ?error_signature)
        (server_has_retry_strategy ?server ?retry_strategy)
        (strategy_test_requested ?retry_strategy)
        (server_bound_test_asset ?server ?test_asset)
        (not
          (server_marked_for_fix ?server)
        )
      )
    :effect
      (and
        (strategy_evaluated ?retry_strategy)
        (server_marked_for_fix ?server)
        (test_asset_available ?test_asset)
        (not
          (server_bound_test_asset ?server ?test_asset)
        )
      )
  )
  (:action assemble_fix_bundle
    :parameters (?client - client_component ?server - server_component ?backoff_policy - backoff_policy ?retry_strategy - retry_strategy ?fix_bundle - fix_bundle)
    :precondition
      (and
        (client_ready_for_fix ?client)
        (server_ready_for_fix ?server)
        (client_has_backoff_policy ?client ?backoff_policy)
        (server_has_retry_strategy ?server ?retry_strategy)
        (policy_evaluated ?backoff_policy)
        (strategy_evaluated ?retry_strategy)
        (client_marked_for_fix ?client)
        (server_marked_for_fix ?server)
        (fix_bundle_available ?fix_bundle)
      )
    :effect
      (and
        (fix_bundle_staged ?fix_bundle)
        (fix_bundle_applies_policy ?fix_bundle ?backoff_policy)
        (fix_bundle_applies_retry_strategy ?fix_bundle ?retry_strategy)
        (not
          (fix_bundle_available ?fix_bundle)
        )
      )
  )
  (:action assemble_fix_bundle_with_test_variant
    :parameters (?client - client_component ?server - server_component ?backoff_policy - backoff_policy ?retry_strategy - retry_strategy ?fix_bundle - fix_bundle)
    :precondition
      (and
        (client_ready_for_fix ?client)
        (server_ready_for_fix ?server)
        (client_has_backoff_policy ?client ?backoff_policy)
        (server_has_retry_strategy ?server ?retry_strategy)
        (policy_test_requested ?backoff_policy)
        (strategy_evaluated ?retry_strategy)
        (not
          (client_marked_for_fix ?client)
        )
        (server_marked_for_fix ?server)
        (fix_bundle_available ?fix_bundle)
      )
    :effect
      (and
        (fix_bundle_staged ?fix_bundle)
        (fix_bundle_applies_policy ?fix_bundle ?backoff_policy)
        (fix_bundle_applies_retry_strategy ?fix_bundle ?retry_strategy)
        (fix_bundle_variant_flag_a ?fix_bundle)
        (not
          (fix_bundle_available ?fix_bundle)
        )
      )
  )
  (:action assemble_fix_bundle_with_server_variant
    :parameters (?client - client_component ?server - server_component ?backoff_policy - backoff_policy ?retry_strategy - retry_strategy ?fix_bundle - fix_bundle)
    :precondition
      (and
        (client_ready_for_fix ?client)
        (server_ready_for_fix ?server)
        (client_has_backoff_policy ?client ?backoff_policy)
        (server_has_retry_strategy ?server ?retry_strategy)
        (policy_evaluated ?backoff_policy)
        (strategy_test_requested ?retry_strategy)
        (client_marked_for_fix ?client)
        (not
          (server_marked_for_fix ?server)
        )
        (fix_bundle_available ?fix_bundle)
      )
    :effect
      (and
        (fix_bundle_staged ?fix_bundle)
        (fix_bundle_applies_policy ?fix_bundle ?backoff_policy)
        (fix_bundle_applies_retry_strategy ?fix_bundle ?retry_strategy)
        (fix_bundle_variant_flag_b ?fix_bundle)
        (not
          (fix_bundle_available ?fix_bundle)
        )
      )
  )
  (:action assemble_fix_bundle_with_full_variants
    :parameters (?client - client_component ?server - server_component ?backoff_policy - backoff_policy ?retry_strategy - retry_strategy ?fix_bundle - fix_bundle)
    :precondition
      (and
        (client_ready_for_fix ?client)
        (server_ready_for_fix ?server)
        (client_has_backoff_policy ?client ?backoff_policy)
        (server_has_retry_strategy ?server ?retry_strategy)
        (policy_test_requested ?backoff_policy)
        (strategy_test_requested ?retry_strategy)
        (not
          (client_marked_for_fix ?client)
        )
        (not
          (server_marked_for_fix ?server)
        )
        (fix_bundle_available ?fix_bundle)
      )
    :effect
      (and
        (fix_bundle_staged ?fix_bundle)
        (fix_bundle_applies_policy ?fix_bundle ?backoff_policy)
        (fix_bundle_applies_retry_strategy ?fix_bundle ?retry_strategy)
        (fix_bundle_variant_flag_a ?fix_bundle)
        (fix_bundle_variant_flag_b ?fix_bundle)
        (not
          (fix_bundle_available ?fix_bundle)
        )
      )
  )
  (:action trigger_ci_for_bundle
    :parameters (?fix_bundle - fix_bundle ?client - client_component ?error_signature - error_signature)
    :precondition
      (and
        (fix_bundle_staged ?fix_bundle)
        (client_ready_for_fix ?client)
        (error_bound_to_entity ?client ?error_signature)
        (not
          (fix_bundle_ci_triggered ?fix_bundle)
        )
      )
    :effect (fix_bundle_ci_triggered ?fix_bundle)
  )
  (:action bind_test_suite_to_work_item
    :parameters (?repair_work_item - repair_work_item ?test_suite - test_suite ?fix_bundle - fix_bundle)
    :precondition
      (and
        (entity_diagnosed ?repair_work_item)
        (work_item_associated_with_bundle ?repair_work_item ?fix_bundle)
        (work_item_bound_test_suite ?repair_work_item ?test_suite)
        (test_suite_available ?test_suite)
        (fix_bundle_staged ?fix_bundle)
        (fix_bundle_ci_triggered ?fix_bundle)
        (not
          (test_suite_selected ?test_suite)
        )
      )
    :effect
      (and
        (test_suite_selected ?test_suite)
        (test_suite_associated_with_bundle ?test_suite ?fix_bundle)
        (not
          (test_suite_available ?test_suite)
        )
      )
  )
  (:action stage_work_item_ci
    :parameters (?repair_work_item - repair_work_item ?test_suite - test_suite ?fix_bundle - fix_bundle ?error_signature - error_signature)
    :precondition
      (and
        (entity_diagnosed ?repair_work_item)
        (work_item_bound_test_suite ?repair_work_item ?test_suite)
        (test_suite_selected ?test_suite)
        (test_suite_associated_with_bundle ?test_suite ?fix_bundle)
        (error_bound_to_entity ?repair_work_item ?error_signature)
        (not
          (fix_bundle_variant_flag_a ?fix_bundle)
        )
        (not
          (work_item_ci_prepared ?repair_work_item)
        )
      )
    :effect (work_item_ci_prepared ?repair_work_item)
  )
  (:action assign_module_to_work_item
    :parameters (?repair_work_item - repair_work_item ?code_module - code_module)
    :precondition
      (and
        (entity_diagnosed ?repair_work_item)
        (code_module_available ?code_module)
        (not
          (module_assigned ?repair_work_item)
        )
      )
    :effect
      (and
        (module_assigned ?repair_work_item)
        (work_item_associates_module ?repair_work_item ?code_module)
        (not
          (code_module_available ?code_module)
        )
      )
  )
  (:action instrument_work_item
    :parameters (?repair_work_item - repair_work_item ?test_suite - test_suite ?fix_bundle - fix_bundle ?error_signature - error_signature ?code_module - code_module)
    :precondition
      (and
        (entity_diagnosed ?repair_work_item)
        (work_item_bound_test_suite ?repair_work_item ?test_suite)
        (test_suite_selected ?test_suite)
        (test_suite_associated_with_bundle ?test_suite ?fix_bundle)
        (error_bound_to_entity ?repair_work_item ?error_signature)
        (fix_bundle_variant_flag_a ?fix_bundle)
        (module_assigned ?repair_work_item)
        (work_item_associates_module ?repair_work_item ?code_module)
        (not
          (work_item_ci_prepared ?repair_work_item)
        )
      )
    :effect
      (and
        (work_item_ci_prepared ?repair_work_item)
        (work_item_instrumented ?repair_work_item)
      )
  )
  (:action enqueue_ci_job_for_work_item
    :parameters (?repair_work_item - repair_work_item ?ci_job - ci_job ?operator - operator ?test_suite - test_suite ?fix_bundle - fix_bundle)
    :precondition
      (and
        (work_item_ci_prepared ?repair_work_item)
        (work_item_assigned_ci_job ?repair_work_item ?ci_job)
        (assigned_operator_to_entity ?repair_work_item ?operator)
        (work_item_bound_test_suite ?repair_work_item ?test_suite)
        (test_suite_associated_with_bundle ?test_suite ?fix_bundle)
        (not
          (fix_bundle_variant_flag_b ?fix_bundle)
        )
        (not
          (work_item_ci_scheduled ?repair_work_item)
        )
      )
    :effect (work_item_ci_scheduled ?repair_work_item)
  )
  (:action schedule_ci_job_variant
    :parameters (?repair_work_item - repair_work_item ?ci_job - ci_job ?operator - operator ?test_suite - test_suite ?fix_bundle - fix_bundle)
    :precondition
      (and
        (work_item_ci_prepared ?repair_work_item)
        (work_item_assigned_ci_job ?repair_work_item ?ci_job)
        (assigned_operator_to_entity ?repair_work_item ?operator)
        (work_item_bound_test_suite ?repair_work_item ?test_suite)
        (test_suite_associated_with_bundle ?test_suite ?fix_bundle)
        (fix_bundle_variant_flag_b ?fix_bundle)
        (not
          (work_item_ci_scheduled ?repair_work_item)
        )
      )
    :effect (work_item_ci_scheduled ?repair_work_item)
  )
  (:action record_ci_success
    :parameters (?repair_work_item - repair_work_item ?release_candidate - release_candidate ?test_suite - test_suite ?fix_bundle - fix_bundle)
    :precondition
      (and
        (work_item_ci_scheduled ?repair_work_item)
        (work_item_associated_release_candidate ?repair_work_item ?release_candidate)
        (work_item_bound_test_suite ?repair_work_item ?test_suite)
        (test_suite_associated_with_bundle ?test_suite ?fix_bundle)
        (not
          (fix_bundle_variant_flag_a ?fix_bundle)
        )
        (not
          (fix_bundle_variant_flag_b ?fix_bundle)
        )
        (not
          (ci_passed ?repair_work_item)
        )
      )
    :effect (ci_passed ?repair_work_item)
  )
  (:action record_ci_success_with_review
    :parameters (?repair_work_item - repair_work_item ?release_candidate - release_candidate ?test_suite - test_suite ?fix_bundle - fix_bundle)
    :precondition
      (and
        (work_item_ci_scheduled ?repair_work_item)
        (work_item_associated_release_candidate ?repair_work_item ?release_candidate)
        (work_item_bound_test_suite ?repair_work_item ?test_suite)
        (test_suite_associated_with_bundle ?test_suite ?fix_bundle)
        (fix_bundle_variant_flag_a ?fix_bundle)
        (not
          (fix_bundle_variant_flag_b ?fix_bundle)
        )
        (not
          (ci_passed ?repair_work_item)
        )
      )
    :effect
      (and
        (ci_passed ?repair_work_item)
        (review_required ?repair_work_item)
      )
  )
  (:action record_ci_success_with_review_variant
    :parameters (?repair_work_item - repair_work_item ?release_candidate - release_candidate ?test_suite - test_suite ?fix_bundle - fix_bundle)
    :precondition
      (and
        (work_item_ci_scheduled ?repair_work_item)
        (work_item_associated_release_candidate ?repair_work_item ?release_candidate)
        (work_item_bound_test_suite ?repair_work_item ?test_suite)
        (test_suite_associated_with_bundle ?test_suite ?fix_bundle)
        (not
          (fix_bundle_variant_flag_a ?fix_bundle)
        )
        (fix_bundle_variant_flag_b ?fix_bundle)
        (not
          (ci_passed ?repair_work_item)
        )
      )
    :effect
      (and
        (ci_passed ?repair_work_item)
        (review_required ?repair_work_item)
      )
  )
  (:action record_ci_success_with_review_variant_ab
    :parameters (?repair_work_item - repair_work_item ?release_candidate - release_candidate ?test_suite - test_suite ?fix_bundle - fix_bundle)
    :precondition
      (and
        (work_item_ci_scheduled ?repair_work_item)
        (work_item_associated_release_candidate ?repair_work_item ?release_candidate)
        (work_item_bound_test_suite ?repair_work_item ?test_suite)
        (test_suite_associated_with_bundle ?test_suite ?fix_bundle)
        (fix_bundle_variant_flag_a ?fix_bundle)
        (fix_bundle_variant_flag_b ?fix_bundle)
        (not
          (ci_passed ?repair_work_item)
        )
      )
    :effect
      (and
        (ci_passed ?repair_work_item)
        (review_required ?repair_work_item)
      )
  )
  (:action finalize_work_item_auto
    :parameters (?repair_work_item - repair_work_item)
    :precondition
      (and
        (ci_passed ?repair_work_item)
        (not
          (review_required ?repair_work_item)
        )
        (not
          (work_item_closed ?repair_work_item)
        )
      )
    :effect
      (and
        (work_item_closed ?repair_work_item)
        (finalized ?repair_work_item)
      )
  )
  (:action assign_reviewer_to_work_item
    :parameters (?repair_work_item - repair_work_item ?reviewer - reviewer)
    :precondition
      (and
        (ci_passed ?repair_work_item)
        (review_required ?repair_work_item)
        (reviewer_available ?reviewer)
      )
    :effect
      (and
        (work_item_assigned_reviewer ?repair_work_item ?reviewer)
        (not
          (reviewer_available ?reviewer)
        )
      )
  )
  (:action approve_work_item_review
    :parameters (?repair_work_item - repair_work_item ?client - client_component ?server - server_component ?error_signature - error_signature ?reviewer - reviewer)
    :precondition
      (and
        (ci_passed ?repair_work_item)
        (review_required ?repair_work_item)
        (work_item_assigned_reviewer ?repair_work_item ?reviewer)
        (work_item_affects_client ?repair_work_item ?client)
        (work_item_affects_server ?repair_work_item ?server)
        (client_marked_for_fix ?client)
        (server_marked_for_fix ?server)
        (error_bound_to_entity ?repair_work_item ?error_signature)
        (not
          (review_approved ?repair_work_item)
        )
      )
    :effect (review_approved ?repair_work_item)
  )
  (:action finalize_work_item_post_review
    :parameters (?repair_work_item - repair_work_item)
    :precondition
      (and
        (ci_passed ?repair_work_item)
        (review_approved ?repair_work_item)
        (not
          (work_item_closed ?repair_work_item)
        )
      )
    :effect
      (and
        (work_item_closed ?repair_work_item)
        (finalized ?repair_work_item)
      )
  )
  (:action claim_stakeholder_for_work_item
    :parameters (?repair_work_item - repair_work_item ?stakeholder - stakeholder ?error_signature - error_signature)
    :precondition
      (and
        (entity_diagnosed ?repair_work_item)
        (error_bound_to_entity ?repair_work_item ?error_signature)
        (stakeholder_available ?stakeholder)
        (assigned_stakeholder_to_work_item ?repair_work_item ?stakeholder)
        (not
          (stakeholder_acknowledged ?repair_work_item)
        )
      )
    :effect
      (and
        (stakeholder_acknowledged ?repair_work_item)
        (not
          (stakeholder_available ?stakeholder)
        )
      )
  )
  (:action acknowledge_stakeholder_claim
    :parameters (?repair_work_item - repair_work_item ?operator - operator)
    :precondition
      (and
        (stakeholder_acknowledged ?repair_work_item)
        (assigned_operator_to_entity ?repair_work_item ?operator)
        (not
          (operator_acknowledged ?repair_work_item)
        )
      )
    :effect (operator_acknowledged ?repair_work_item)
  )
  (:action complete_operator_triage
    :parameters (?repair_work_item - repair_work_item ?release_candidate - release_candidate)
    :precondition
      (and
        (operator_acknowledged ?repair_work_item)
        (work_item_associated_release_candidate ?repair_work_item ?release_candidate)
        (not
          (operator_triage_complete ?repair_work_item)
        )
      )
    :effect (operator_triage_complete ?repair_work_item)
  )
  (:action finalize_work_item_post_triage
    :parameters (?repair_work_item - repair_work_item)
    :precondition
      (and
        (operator_triage_complete ?repair_work_item)
        (not
          (work_item_closed ?repair_work_item)
        )
      )
    :effect
      (and
        (work_item_closed ?repair_work_item)
        (finalized ?repair_work_item)
      )
  )
  (:action apply_fix_to_client
    :parameters (?client - client_component ?fix_bundle - fix_bundle)
    :precondition
      (and
        (client_ready_for_fix ?client)
        (client_marked_for_fix ?client)
        (fix_bundle_staged ?fix_bundle)
        (fix_bundle_ci_triggered ?fix_bundle)
        (not
          (finalized ?client)
        )
      )
    :effect (finalized ?client)
  )
  (:action apply_fix_to_server
    :parameters (?server - server_component ?fix_bundle - fix_bundle)
    :precondition
      (and
        (server_ready_for_fix ?server)
        (server_marked_for_fix ?server)
        (fix_bundle_staged ?fix_bundle)
        (fix_bundle_ci_triggered ?fix_bundle)
        (not
          (finalized ?server)
        )
      )
    :effect (finalized ?server)
  )
  (:action record_reset_with_deployment_marker
    :parameters (?component - system_component ?deployment_marker - deployment_marker ?error_signature - error_signature)
    :precondition
      (and
        (finalized ?component)
        (error_bound_to_entity ?component ?error_signature)
        (deployment_marker_available ?deployment_marker)
        (not
          (reset_recorded ?component)
        )
      )
    :effect
      (and
        (reset_recorded ?component)
        (entity_has_deployment_marker ?component ?deployment_marker)
        (not
          (deployment_marker_available ?deployment_marker)
        )
      )
  )
  (:action propagate_reset_and_release_backoff_slot
    :parameters (?client - client_component ?backoff_slot - backoff_slot ?deployment_marker - deployment_marker)
    :precondition
      (and
        (reset_recorded ?client)
        (allocated_backoff_slot_to_entity ?client ?backoff_slot)
        (entity_has_deployment_marker ?client ?deployment_marker)
        (not
          (reset_completed ?client)
        )
      )
    :effect
      (and
        (reset_completed ?client)
        (backoff_slot_available ?backoff_slot)
        (deployment_marker_available ?deployment_marker)
      )
  )
  (:action propagate_reset_and_release_backoff_slot_server
    :parameters (?server - server_component ?backoff_slot - backoff_slot ?deployment_marker - deployment_marker)
    :precondition
      (and
        (reset_recorded ?server)
        (allocated_backoff_slot_to_entity ?server ?backoff_slot)
        (entity_has_deployment_marker ?server ?deployment_marker)
        (not
          (reset_completed ?server)
        )
      )
    :effect
      (and
        (reset_completed ?server)
        (backoff_slot_available ?backoff_slot)
        (deployment_marker_available ?deployment_marker)
      )
  )
  (:action propagate_reset_and_release_backoff_slot_for_work_item
    :parameters (?repair_work_item - repair_work_item ?backoff_slot - backoff_slot ?deployment_marker - deployment_marker)
    :precondition
      (and
        (reset_recorded ?repair_work_item)
        (allocated_backoff_slot_to_entity ?repair_work_item ?backoff_slot)
        (entity_has_deployment_marker ?repair_work_item ?deployment_marker)
        (not
          (reset_completed ?repair_work_item)
        )
      )
    :effect
      (and
        (reset_completed ?repair_work_item)
        (backoff_slot_available ?backoff_slot)
        (deployment_marker_available ?deployment_marker)
      )
  )
)

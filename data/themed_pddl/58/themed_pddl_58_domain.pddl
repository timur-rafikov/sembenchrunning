(define (domain ci_retry_budget_control_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types pipeline_run - object retry_token - object pipeline_stage - object executor_pool - object test_suite - object security_check_profile - object executor_reservation - object human_reviewer - object retry_policy - object automation_credential - object vulnerability_report - object failure_signature - object responsible_team - object oncall_team - responsible_team review_team - responsible_team service_run - pipeline_run component_run - pipeline_run)
  (:predicates
    (reviewer_available ?human_reviewer - human_reviewer)
    (assigned_executor_pool ?pipeline_run - pipeline_run ?executor_pool - executor_pool)
    (retry_approved ?pipeline_run - pipeline_run)
    (retry_allocated ?pipeline_run - pipeline_run ?retry_token - retry_token)
    (run_accountable_team ?pipeline_run - pipeline_run ?responsible_team - responsible_team)
    (security_profile_available ?security_check_profile - security_check_profile)
    (executor_pool_available ?executor_pool - executor_pool)
    (failure_signature_applicable ?pipeline_run - pipeline_run ?failure_signature - failure_signature)
    (run_promoted ?pipeline_run - pipeline_run)
    (is_service_run ?pipeline_run - pipeline_run)
    (token_eligible_for_run ?pipeline_run - pipeline_run ?retry_token - retry_token)
    (stage_available ?pipeline_stage - pipeline_stage)
    (vuln_report_available ?vulnerability_report - vulnerability_report)
    (reservation_available ?executor_reservation - executor_reservation)
    (stage_completed ?pipeline_run - pipeline_run)
    (executor_pool_applicable ?pipeline_run - pipeline_run ?executor_pool - executor_pool)
    (bound_failure_signature ?pipeline_run - pipeline_run ?failure_signature - failure_signature)
    (stage_validated ?pipeline_run - pipeline_run ?pipeline_stage - pipeline_stage)
    (approval_recorded ?pipeline_run - pipeline_run)
    (security_profile_applicable ?pipeline_run - pipeline_run ?security_check_profile - security_check_profile)
    (failure_signature_available ?failure_signature - failure_signature)
    (is_component_run ?pipeline_run - pipeline_run)
    (validation_passed ?pipeline_run - pipeline_run)
    (test_suite_applicable ?pipeline_run - pipeline_run ?test_suite - test_suite)
    (assigned_test_suite ?pipeline_run - pipeline_run ?test_suite - test_suite)
    (has_vulnerability_report ?pipeline_run - pipeline_run)
    (run_has_reservation ?pipeline_run - pipeline_run ?executor_reservation - executor_reservation)
    (post_checks_ready ?pipeline_run - pipeline_run)
    (vuln_report_applicable ?pipeline_run - pipeline_run ?vulnerability_report - vulnerability_report)
    (run_admitted ?pipeline_run - pipeline_run)
    (retry_token_available ?retry_token - retry_token)
    (retry_claimed ?pipeline_run - pipeline_run)
    (automation_credential_available ?automation_credential - automation_credential)
    (retry_policy_available ?retry_policy - retry_policy)
    (assigned_security_profile ?pipeline_run - pipeline_run ?security_check_profile - security_check_profile)
    (service_policy_candidate ?pipeline_run - pipeline_run ?retry_policy - retry_policy)
    (reservation_confirmed ?pipeline_run - pipeline_run)
    (executor_slot_locked ?pipeline_run - pipeline_run)
    (service_policy_binding ?pipeline_run - pipeline_run ?retry_policy - retry_policy)
    (test_suite_available ?test_suite - test_suite)
    (component_policy_candidate ?pipeline_run - pipeline_run ?retry_policy - retry_policy)
    (stage_applicable ?pipeline_run - pipeline_run ?pipeline_stage - pipeline_stage)
    (manual_review_required ?pipeline_run - pipeline_run)
    (retry_policy_applied ?pipeline_run - pipeline_run ?retry_policy - retry_policy)
  )
  (:action unbind_failure_signature_from_run
    :parameters (?pipeline_run - pipeline_run ?failure_signature - failure_signature)
    :precondition
      (and
        (bound_failure_signature ?pipeline_run ?failure_signature)
      )
    :effect
      (and
        (failure_signature_available ?failure_signature)
        (not
          (bound_failure_signature ?pipeline_run ?failure_signature)
        )
      )
  )
  (:action record_approval_and_bind_policy_by_review_team
    :parameters (?pipeline_run - pipeline_run ?security_check_profile - security_check_profile ?failure_signature - failure_signature ?review_team - review_team)
    :precondition
      (and
        (not
          (approval_recorded ?pipeline_run)
        )
        (stage_completed ?pipeline_run)
        (validation_passed ?pipeline_run)
        (bound_failure_signature ?pipeline_run ?failure_signature)
        (run_accountable_team ?pipeline_run ?review_team)
        (assigned_security_profile ?pipeline_run ?security_check_profile)
      )
    :effect
      (and
        (manual_review_required ?pipeline_run)
        (approval_recorded ?pipeline_run)
      )
  )
  (:action finalize_promotion_for_service_run
    :parameters (?pipeline_run - pipeline_run)
    :precondition
      (and
        (validation_passed ?pipeline_run)
        (retry_claimed ?pipeline_run)
        (stage_completed ?pipeline_run)
        (run_admitted ?pipeline_run)
        (executor_slot_locked ?pipeline_run)
        (not
          (run_promoted ?pipeline_run)
        )
        (is_service_run ?pipeline_run)
        (approval_recorded ?pipeline_run)
      )
    :effect
      (and
        (run_promoted ?pipeline_run)
      )
  )
  (:action clear_vulnerability_flag_after_remediation
    :parameters (?pipeline_run - pipeline_run ?test_suite - test_suite ?executor_pool - executor_pool)
    :precondition
      (and
        (stage_completed ?pipeline_run)
        (has_vulnerability_report ?pipeline_run)
        (assigned_test_suite ?pipeline_run ?test_suite)
        (assigned_executor_pool ?pipeline_run ?executor_pool)
      )
    :effect
      (and
        (not
          (has_vulnerability_report ?pipeline_run)
        )
        (not
          (manual_review_required ?pipeline_run)
        )
      )
  )
  (:action reserve_executor_for_run
    :parameters (?pipeline_run - pipeline_run ?executor_reservation - executor_reservation)
    :precondition
      (and
        (reservation_available ?executor_reservation)
        (run_admitted ?pipeline_run)
      )
    :effect
      (and
        (not
          (reservation_available ?executor_reservation)
        )
        (run_has_reservation ?pipeline_run ?executor_reservation)
      )
  )
  (:action record_approval_by_oncall_team
    :parameters (?pipeline_run - pipeline_run ?test_suite - test_suite ?executor_pool - executor_pool ?oncall_team - oncall_team)
    :precondition
      (and
        (run_accountable_team ?pipeline_run ?oncall_team)
        (validation_passed ?pipeline_run)
        (not
          (manual_review_required ?pipeline_run)
        )
        (assigned_test_suite ?pipeline_run ?test_suite)
        (stage_completed ?pipeline_run)
        (assigned_executor_pool ?pipeline_run ?executor_pool)
        (not
          (approval_recorded ?pipeline_run)
        )
      )
    :effect
      (and
        (approval_recorded ?pipeline_run)
      )
  )
  (:action apply_policy_based_automation_validation
    :parameters (?pipeline_run - pipeline_run ?retry_policy - retry_policy)
    :precondition
      (and
        (retry_claimed ?pipeline_run)
        (retry_policy_applied ?pipeline_run ?retry_policy)
        (not
          (validation_passed ?pipeline_run)
        )
      )
    :effect
      (and
        (validation_passed ?pipeline_run)
        (not
          (manual_review_required ?pipeline_run)
        )
      )
  )
  (:action assign_security_profile_to_run
    :parameters (?pipeline_run - pipeline_run ?security_check_profile - security_check_profile)
    :precondition
      (and
        (security_profile_applicable ?pipeline_run ?security_check_profile)
        (run_admitted ?pipeline_run)
        (security_profile_available ?security_check_profile)
      )
    :effect
      (and
        (assigned_security_profile ?pipeline_run ?security_check_profile)
        (not
          (security_profile_available ?security_check_profile)
        )
      )
  )
  (:action assign_test_suite_to_run
    :parameters (?pipeline_run - pipeline_run ?test_suite - test_suite)
    :precondition
      (and
        (run_admitted ?pipeline_run)
        (test_suite_available ?test_suite)
        (test_suite_applicable ?pipeline_run ?test_suite)
      )
    :effect
      (and
        (not
          (test_suite_available ?test_suite)
        )
        (assigned_test_suite ?pipeline_run ?test_suite)
      )
  )
  (:action unassign_security_profile_from_run
    :parameters (?pipeline_run - pipeline_run ?security_check_profile - security_check_profile)
    :precondition
      (and
        (assigned_security_profile ?pipeline_run ?security_check_profile)
      )
    :effect
      (and
        (security_profile_available ?security_check_profile)
        (not
          (assigned_security_profile ?pipeline_run ?security_check_profile)
        )
      )
  )
  (:action unassign_executor_pool_from_run
    :parameters (?pipeline_run - pipeline_run ?executor_pool - executor_pool)
    :precondition
      (and
        (assigned_executor_pool ?pipeline_run ?executor_pool)
      )
    :effect
      (and
        (executor_pool_available ?executor_pool)
        (not
          (assigned_executor_pool ?pipeline_run ?executor_pool)
        )
      )
  )
  (:action bind_service_policy_candidate
    :parameters (?pipeline_run - pipeline_run ?retry_policy - retry_policy)
    :precondition
      (and
        (executor_slot_locked ?pipeline_run)
        (retry_policy_available ?retry_policy)
        (service_policy_binding ?pipeline_run ?retry_policy)
      )
    :effect
      (and
        (service_policy_candidate ?pipeline_run ?retry_policy)
        (not
          (retry_policy_available ?retry_policy)
        )
      )
  )
  (:action assign_executor_pool_to_run
    :parameters (?pipeline_run - pipeline_run ?executor_pool - executor_pool)
    :precondition
      (and
        (run_admitted ?pipeline_run)
        (executor_pool_available ?executor_pool)
        (executor_pool_applicable ?pipeline_run ?executor_pool)
      )
    :effect
      (and
        (assigned_executor_pool ?pipeline_run ?executor_pool)
        (not
          (executor_pool_available ?executor_pool)
        )
      )
  )
  (:action validate_stage_with_required_checks
    :parameters (?pipeline_run - pipeline_run ?pipeline_stage - pipeline_stage ?test_suite - test_suite ?executor_pool - executor_pool)
    :precondition
      (and
        (retry_claimed ?pipeline_run)
        (stage_available ?pipeline_stage)
        (stage_applicable ?pipeline_run ?pipeline_stage)
        (not
          (stage_completed ?pipeline_run)
        )
        (assigned_executor_pool ?pipeline_run ?executor_pool)
        (assigned_test_suite ?pipeline_run ?test_suite)
      )
    :effect
      (and
        (stage_validated ?pipeline_run ?pipeline_stage)
        (not
          (stage_available ?pipeline_stage)
        )
        (stage_completed ?pipeline_run)
      )
  )
  (:action promote_run_after_approval
    :parameters (?pipeline_run - pipeline_run ?test_suite - test_suite ?executor_pool - executor_pool)
    :precondition
      (and
        (assigned_test_suite ?pipeline_run ?test_suite)
        (approval_recorded ?pipeline_run)
        (assigned_executor_pool ?pipeline_run ?executor_pool)
        (manual_review_required ?pipeline_run)
      )
    :effect
      (and
        (not
          (has_vulnerability_report ?pipeline_run)
        )
        (not
          (manual_review_required ?pipeline_run)
        )
        (not
          (validation_passed ?pipeline_run)
        )
        (retry_approved ?pipeline_run)
      )
  )
  (:action release_executor_reservation
    :parameters (?pipeline_run - pipeline_run ?executor_reservation - executor_reservation)
    :precondition
      (and
        (run_has_reservation ?pipeline_run ?executor_reservation)
      )
    :effect
      (and
        (reservation_available ?executor_reservation)
        (not
          (run_has_reservation ?pipeline_run ?executor_reservation)
        )
      )
  )
  (:action apply_automation_credential_for_validation
    :parameters (?pipeline_run - pipeline_run ?executor_reservation - executor_reservation ?automation_credential - automation_credential)
    :precondition
      (and
        (not
          (validation_passed ?pipeline_run)
        )
        (retry_claimed ?pipeline_run)
        (automation_credential_available ?automation_credential)
        (run_has_reservation ?pipeline_run ?executor_reservation)
        (reservation_confirmed ?pipeline_run)
      )
    :effect
      (and
        (not
          (manual_review_required ?pipeline_run)
        )
        (validation_passed ?pipeline_run)
      )
  )
  (:action finalize_promotion_with_component_checks
    :parameters (?pipeline_run - pipeline_run)
    :precondition
      (and
        (run_admitted ?pipeline_run)
        (is_component_run ?pipeline_run)
        (post_checks_ready ?pipeline_run)
        (retry_claimed ?pipeline_run)
        (validation_passed ?pipeline_run)
        (not
          (run_promoted ?pipeline_run)
        )
        (executor_slot_locked ?pipeline_run)
        (stage_completed ?pipeline_run)
        (approval_recorded ?pipeline_run)
      )
    :effect
      (and
        (run_promoted ?pipeline_run)
      )
  )
  (:action mark_post_checks_ready_for_run
    :parameters (?pipeline_run - pipeline_run ?executor_reservation - executor_reservation ?automation_credential - automation_credential)
    :precondition
      (and
        (validation_passed ?pipeline_run)
        (automation_credential_available ?automation_credential)
        (not
          (post_checks_ready ?pipeline_run)
        )
        (executor_slot_locked ?pipeline_run)
        (run_admitted ?pipeline_run)
        (is_component_run ?pipeline_run)
        (run_has_reservation ?pipeline_run ?executor_reservation)
      )
    :effect
      (and
        (post_checks_ready ?pipeline_run)
      )
  )
  (:action unassign_test_suite_from_run
    :parameters (?pipeline_run - pipeline_run ?test_suite - test_suite)
    :precondition
      (and
        (assigned_test_suite ?pipeline_run ?test_suite)
      )
    :effect
      (and
        (test_suite_available ?test_suite)
        (not
          (assigned_test_suite ?pipeline_run ?test_suite)
        )
      )
  )
  (:action bind_failure_signature_to_run
    :parameters (?pipeline_run - pipeline_run ?failure_signature - failure_signature)
    :precondition
      (and
        (failure_signature_available ?failure_signature)
        (run_admitted ?pipeline_run)
        (failure_signature_applicable ?pipeline_run ?failure_signature)
      )
    :effect
      (and
        (bound_failure_signature ?pipeline_run ?failure_signature)
        (not
          (failure_signature_available ?failure_signature)
        )
      )
  )
  (:action admit_pipeline_run
    :parameters (?pipeline_run - pipeline_run)
    :precondition
      (and
        (not
          (run_admitted ?pipeline_run)
        )
        (not
          (run_promoted ?pipeline_run)
        )
      )
    :effect
      (and
        (run_admitted ?pipeline_run)
      )
  )
  (:action human_reviewer_grant_manual_review
    :parameters (?pipeline_run - pipeline_run ?human_reviewer - human_reviewer)
    :precondition
      (and
        (not
          (reservation_confirmed ?pipeline_run)
        )
        (run_admitted ?pipeline_run)
        (reviewer_available ?human_reviewer)
        (retry_claimed ?pipeline_run)
      )
    :effect
      (and
        (manual_review_required ?pipeline_run)
        (not
          (reviewer_available ?human_reviewer)
        )
        (reservation_confirmed ?pipeline_run)
      )
  )
  (:action validate_stage_with_security_and_vuln
    :parameters (?pipeline_run - pipeline_run ?pipeline_stage - pipeline_stage ?security_check_profile - security_check_profile ?vulnerability_report - vulnerability_report)
    :precondition
      (and
        (vuln_report_available ?vulnerability_report)
        (vuln_report_applicable ?pipeline_run ?vulnerability_report)
        (not
          (stage_completed ?pipeline_run)
        )
        (retry_claimed ?pipeline_run)
        (stage_available ?pipeline_stage)
        (stage_applicable ?pipeline_run ?pipeline_stage)
        (assigned_security_profile ?pipeline_run ?security_check_profile)
      )
    :effect
      (and
        (stage_validated ?pipeline_run ?pipeline_stage)
        (not
          (vuln_report_available ?vulnerability_report)
        )
        (has_vulnerability_report ?pipeline_run)
        (not
          (stage_available ?pipeline_stage)
        )
        (manual_review_required ?pipeline_run)
        (stage_completed ?pipeline_run)
      )
  )
  (:action request_human_review_lock_slot
    :parameters (?pipeline_run - pipeline_run ?human_reviewer - human_reviewer)
    :precondition
      (and
        (reviewer_available ?human_reviewer)
        (not
          (manual_review_required ?pipeline_run)
        )
        (validation_passed ?pipeline_run)
        (approval_recorded ?pipeline_run)
        (not
          (executor_slot_locked ?pipeline_run)
        )
      )
    :effect
      (and
        (executor_slot_locked ?pipeline_run)
        (not
          (reviewer_available ?human_reviewer)
        )
      )
  )
  (:action release_retry_token_from_run
    :parameters (?pipeline_run - pipeline_run ?retry_token - retry_token)
    :precondition
      (and
        (retry_allocated ?pipeline_run ?retry_token)
        (not
          (approval_recorded ?pipeline_run)
        )
        (not
          (stage_completed ?pipeline_run)
        )
      )
    :effect
      (and
        (not
          (retry_allocated ?pipeline_run ?retry_token)
        )
        (retry_token_available ?retry_token)
        (not
          (retry_claimed ?pipeline_run)
        )
        (not
          (reservation_confirmed ?pipeline_run)
        )
        (not
          (retry_approved ?pipeline_run)
        )
        (not
          (validation_passed ?pipeline_run)
        )
        (not
          (has_vulnerability_report ?pipeline_run)
        )
        (not
          (manual_review_required ?pipeline_run)
        )
      )
  )
  (:action lock_executor_slot_for_retry
    :parameters (?pipeline_run - pipeline_run ?executor_reservation - executor_reservation)
    :precondition
      (and
        (not
          (executor_slot_locked ?pipeline_run)
        )
        (run_has_reservation ?pipeline_run ?executor_reservation)
        (validation_passed ?pipeline_run)
        (approval_recorded ?pipeline_run)
        (not
          (manual_review_required ?pipeline_run)
        )
      )
    :effect
      (and
        (executor_slot_locked ?pipeline_run)
      )
  )
  (:action finalize_promotion_with_policy_for_component_run
    :parameters (?pipeline_run - pipeline_run ?retry_policy - retry_policy)
    :precondition
      (and
        (executor_slot_locked ?pipeline_run)
        (approval_recorded ?pipeline_run)
        (stage_completed ?pipeline_run)
        (retry_policy_applied ?pipeline_run ?retry_policy)
        (validation_passed ?pipeline_run)
        (retry_claimed ?pipeline_run)
        (run_admitted ?pipeline_run)
        (not
          (run_promoted ?pipeline_run)
        )
        (is_component_run ?pipeline_run)
      )
    :effect
      (and
        (run_promoted ?pipeline_run)
      )
  )
  (:action confirm_reservation_activation
    :parameters (?pipeline_run - pipeline_run ?executor_reservation - executor_reservation)
    :precondition
      (and
        (run_admitted ?pipeline_run)
        (retry_claimed ?pipeline_run)
        (not
          (reservation_confirmed ?pipeline_run)
        )
        (run_has_reservation ?pipeline_run ?executor_reservation)
      )
    :effect
      (and
        (reservation_confirmed ?pipeline_run)
      )
  )
  (:action allocate_retry_token_to_run
    :parameters (?pipeline_run - pipeline_run ?retry_token - retry_token)
    :precondition
      (and
        (not
          (retry_claimed ?pipeline_run)
        )
        (run_admitted ?pipeline_run)
        (retry_token_available ?retry_token)
        (token_eligible_for_run ?pipeline_run ?retry_token)
      )
    :effect
      (and
        (retry_claimed ?pipeline_run)
        (not
          (retry_token_available ?retry_token)
        )
        (retry_allocated ?pipeline_run ?retry_token)
      )
  )
  (:action activate_reservation_and_trigger_validation
    :parameters (?pipeline_run - pipeline_run ?executor_reservation - executor_reservation ?automation_credential - automation_credential)
    :precondition
      (and
        (retry_claimed ?pipeline_run)
        (not
          (validation_passed ?pipeline_run)
        )
        (run_has_reservation ?pipeline_run ?executor_reservation)
        (approval_recorded ?pipeline_run)
        (automation_credential_available ?automation_credential)
        (retry_approved ?pipeline_run)
      )
    :effect
      (and
        (validation_passed ?pipeline_run)
      )
  )
  (:action apply_component_and_service_policy_binding
    :parameters (?component_run - component_run ?service_run - service_run ?retry_policy - retry_policy)
    :precondition
      (and
        (run_admitted ?component_run)
        (service_policy_candidate ?service_run ?retry_policy)
        (is_component_run ?component_run)
        (not
          (retry_policy_applied ?component_run ?retry_policy)
        )
        (component_policy_candidate ?component_run ?retry_policy)
      )
    :effect
      (and
        (retry_policy_applied ?component_run ?retry_policy)
      )
  )
)

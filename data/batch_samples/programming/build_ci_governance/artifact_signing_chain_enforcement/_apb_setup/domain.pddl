(define (domain artifact_signing_governance)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object artifact - domain_object ci_worker - domain_object validation_stage - domain_object quality_check - domain_object test_suite - domain_object security_scan - domain_object attestation_job - domain_object policy_engine - domain_object release_target - domain_object auditor - domain_object vuln_report - domain_object signing_key - domain_object credential - domain_object team_credential - credential org_credential - credential rc_variant - artifact dep_variant - artifact)

  (:predicates
    (artifact_registered ?artifact - artifact)
    (artifact_allocated_to_worker ?artifact - artifact ?ci_worker - ci_worker)
    (artifact_allocated ?artifact - artifact)
    (artifact_signed ?artifact - artifact)
    (artifact_attested ?artifact - artifact)
    (artifact_bound_to_test_suite ?artifact - artifact ?test_suite - test_suite)
    (artifact_bound_to_quality_check ?artifact - artifact ?quality_check - quality_check)
    (artifact_bound_to_security_scan ?artifact - artifact ?security_scan - security_scan)
    (artifact_bound_to_signing_key ?artifact - artifact ?signing_key - signing_key)
    (artifact_validated_at_stage ?artifact - artifact ?validation_stage - validation_stage)
    (artifact_stage_approved ?artifact - artifact)
    (artifact_approval_granted ?artifact - artifact)
    (artifact_attestation_token_captured ?artifact - artifact)
    (artifact_final_released ?artifact - artifact)
    (artifact_requires_countersign ?artifact - artifact)
    (artifact_countersign_completed ?artifact - artifact)
    (artifact_target_compatibility ?artifact - artifact ?release_target - release_target)
    (artifact_target_bound ?artifact - artifact ?release_target - release_target)
    (artifact_final_attestation_recorded ?artifact - artifact)
    (ci_worker_available ?ci_worker - ci_worker)
    (validation_stage_available ?validation_stage - validation_stage)
    (test_suite_available ?test_suite - test_suite)
    (quality_check_available ?quality_check - quality_check)
    (security_scan_available ?security_scan - security_scan)
    (attestation_job_available ?attestation_job - attestation_job)
    (policy_engine_available ?policy_engine - policy_engine)
    (release_target_available ?release_target - release_target)
    (auditor_available ?auditor - auditor)
    (vuln_report_available ?vuln_report - vuln_report)
    (signing_key_available ?signing_key - signing_key)
    (artifact_worker_eligibility ?artifact - artifact ?ci_worker - ci_worker)
    (artifact_stage_compatibility ?artifact - artifact ?validation_stage - validation_stage)
    (artifact_test_suite_compatibility ?artifact - artifact ?test_suite - test_suite)
    (artifact_quality_check_compatibility ?artifact - artifact ?quality_check - quality_check)
    (artifact_security_scan_compatibility ?artifact - artifact ?security_scan - security_scan)
    (artifact_vuln_report_association ?artifact - artifact ?vuln_report - vuln_report)
    (artifact_signing_key_association ?artifact - artifact ?signing_key - signing_key)
    (artifact_credential_association ?artifact - artifact ?credential - credential)
    (rc_signed_for_target ?artifact - artifact ?release_target - release_target)
    (rc_registered ?artifact - artifact)
    (dep_registered ?artifact - artifact)
    (artifact_bound_to_attestation_job ?artifact - artifact ?attestation_job - attestation_job)
    (artifact_vuln_flag ?artifact - artifact)
    (artifact_target_association ?artifact - artifact ?release_target - release_target)
  )
  (:action register_artifact
    :parameters (?artifact - artifact)
    :precondition
      (and
        (not
          (artifact_registered ?artifact)
        )
        (not
          (artifact_final_released ?artifact)
        )
      )
    :effect
      (and
        (artifact_registered ?artifact)
      )
  )
  (:action assign_ci_worker
    :parameters (?artifact - artifact ?ci_worker - ci_worker)
    :precondition
      (and
        (artifact_registered ?artifact)
        (ci_worker_available ?ci_worker)
        (artifact_worker_eligibility ?artifact ?ci_worker)
        (not
          (artifact_allocated ?artifact)
        )
      )
    :effect
      (and
        (artifact_allocated_to_worker ?artifact ?ci_worker)
        (artifact_allocated ?artifact)
        (not
          (ci_worker_available ?ci_worker)
        )
      )
  )
  (:action release_ci_worker
    :parameters (?artifact - artifact ?ci_worker - ci_worker)
    :precondition
      (and
        (artifact_allocated_to_worker ?artifact ?ci_worker)
        (not
          (artifact_stage_approved ?artifact)
        )
        (not
          (artifact_approval_granted ?artifact)
        )
      )
    :effect
      (and
        (not
          (artifact_allocated_to_worker ?artifact ?ci_worker)
        )
        (not
          (artifact_allocated ?artifact)
        )
        (not
          (artifact_signed ?artifact)
        )
        (not
          (artifact_attested ?artifact)
        )
        (not
          (artifact_requires_countersign ?artifact)
        )
        (not
          (artifact_countersign_completed ?artifact)
        )
        (not
          (artifact_vuln_flag ?artifact)
        )
        (ci_worker_available ?ci_worker)
      )
  )
  (:action schedule_attestation_job
    :parameters (?artifact - artifact ?attestation_job - attestation_job)
    :precondition
      (and
        (artifact_registered ?artifact)
        (attestation_job_available ?attestation_job)
      )
    :effect
      (and
        (artifact_bound_to_attestation_job ?artifact ?attestation_job)
        (not
          (attestation_job_available ?attestation_job)
        )
      )
  )
  (:action complete_attestation_job
    :parameters (?artifact - artifact ?attestation_job - attestation_job)
    :precondition
      (and
        (artifact_bound_to_attestation_job ?artifact ?attestation_job)
      )
    :effect
      (and
        (attestation_job_available ?attestation_job)
        (not
          (artifact_bound_to_attestation_job ?artifact ?attestation_job)
        )
      )
  )
  (:action sign_artifact_from_attestation_job
    :parameters (?artifact - artifact ?attestation_job - attestation_job)
    :precondition
      (and
        (artifact_registered ?artifact)
        (artifact_allocated ?artifact)
        (artifact_bound_to_attestation_job ?artifact ?attestation_job)
        (not
          (artifact_signed ?artifact)
        )
      )
    :effect
      (and
        (artifact_signed ?artifact)
      )
  )
  (:action sign_artifact_with_policy_engine
    :parameters (?artifact - artifact ?policy_engine - policy_engine)
    :precondition
      (and
        (artifact_registered ?artifact)
        (artifact_allocated ?artifact)
        (policy_engine_available ?policy_engine)
        (not
          (artifact_signed ?artifact)
        )
      )
    :effect
      (and
        (artifact_signed ?artifact)
        (artifact_requires_countersign ?artifact)
        (not
          (policy_engine_available ?policy_engine)
        )
      )
  )
  (:action attest_artifact_by_auditor
    :parameters (?artifact - artifact ?attestation_job - attestation_job ?auditor - auditor)
    :precondition
      (and
        (artifact_signed ?artifact)
        (artifact_allocated ?artifact)
        (artifact_bound_to_attestation_job ?artifact ?attestation_job)
        (auditor_available ?auditor)
        (not
          (artifact_attested ?artifact)
        )
      )
    :effect
      (and
        (artifact_attested ?artifact)
        (not
          (artifact_requires_countersign ?artifact)
        )
      )
  )
  (:action attest_artifact_for_release_target
    :parameters (?artifact - artifact ?release_target - release_target)
    :precondition
      (and
        (artifact_allocated ?artifact)
        (artifact_target_bound ?artifact ?release_target)
        (not
          (artifact_attested ?artifact)
        )
      )
    :effect
      (and
        (artifact_attested ?artifact)
        (not
          (artifact_requires_countersign ?artifact)
        )
      )
  )
  (:action schedule_test_suite
    :parameters (?artifact - artifact ?test_suite - test_suite)
    :precondition
      (and
        (artifact_registered ?artifact)
        (test_suite_available ?test_suite)
        (artifact_test_suite_compatibility ?artifact ?test_suite)
      )
    :effect
      (and
        (artifact_bound_to_test_suite ?artifact ?test_suite)
        (not
          (test_suite_available ?test_suite)
        )
      )
  )
  (:action complete_test_suite_run
    :parameters (?artifact - artifact ?test_suite - test_suite)
    :precondition
      (and
        (artifact_bound_to_test_suite ?artifact ?test_suite)
      )
    :effect
      (and
        (test_suite_available ?test_suite)
        (not
          (artifact_bound_to_test_suite ?artifact ?test_suite)
        )
      )
  )
  (:action schedule_quality_check
    :parameters (?artifact - artifact ?quality_check - quality_check)
    :precondition
      (and
        (artifact_registered ?artifact)
        (quality_check_available ?quality_check)
        (artifact_quality_check_compatibility ?artifact ?quality_check)
      )
    :effect
      (and
        (artifact_bound_to_quality_check ?artifact ?quality_check)
        (not
          (quality_check_available ?quality_check)
        )
      )
  )
  (:action complete_quality_check
    :parameters (?artifact - artifact ?quality_check - quality_check)
    :precondition
      (and
        (artifact_bound_to_quality_check ?artifact ?quality_check)
      )
    :effect
      (and
        (quality_check_available ?quality_check)
        (not
          (artifact_bound_to_quality_check ?artifact ?quality_check)
        )
      )
  )
  (:action schedule_security_scan
    :parameters (?artifact - artifact ?security_scan - security_scan)
    :precondition
      (and
        (artifact_registered ?artifact)
        (security_scan_available ?security_scan)
        (artifact_security_scan_compatibility ?artifact ?security_scan)
      )
    :effect
      (and
        (artifact_bound_to_security_scan ?artifact ?security_scan)
        (not
          (security_scan_available ?security_scan)
        )
      )
  )
  (:action complete_security_scan
    :parameters (?artifact - artifact ?security_scan - security_scan)
    :precondition
      (and
        (artifact_bound_to_security_scan ?artifact ?security_scan)
      )
    :effect
      (and
        (security_scan_available ?security_scan)
        (not
          (artifact_bound_to_security_scan ?artifact ?security_scan)
        )
      )
  )
  (:action reserve_signing_key
    :parameters (?artifact - artifact ?signing_key - signing_key)
    :precondition
      (and
        (artifact_registered ?artifact)
        (signing_key_available ?signing_key)
        (artifact_signing_key_association ?artifact ?signing_key)
      )
    :effect
      (and
        (artifact_bound_to_signing_key ?artifact ?signing_key)
        (not
          (signing_key_available ?signing_key)
        )
      )
  )
  (:action release_signing_key
    :parameters (?artifact - artifact ?signing_key - signing_key)
    :precondition
      (and
        (artifact_bound_to_signing_key ?artifact ?signing_key)
      )
    :effect
      (and
        (signing_key_available ?signing_key)
        (not
          (artifact_bound_to_signing_key ?artifact ?signing_key)
        )
      )
  )
  (:action approve_stage_with_tests_and_checks
    :parameters (?artifact - artifact ?validation_stage - validation_stage ?test_suite - test_suite ?quality_check - quality_check)
    :precondition
      (and
        (artifact_allocated ?artifact)
        (artifact_bound_to_test_suite ?artifact ?test_suite)
        (artifact_bound_to_quality_check ?artifact ?quality_check)
        (validation_stage_available ?validation_stage)
        (artifact_stage_compatibility ?artifact ?validation_stage)
        (not
          (artifact_stage_approved ?artifact)
        )
      )
    :effect
      (and
        (artifact_validated_at_stage ?artifact ?validation_stage)
        (artifact_stage_approved ?artifact)
        (not
          (validation_stage_available ?validation_stage)
        )
      )
  )
  (:action approve_stage_with_security_and_vuln_report
    :parameters (?artifact - artifact ?validation_stage - validation_stage ?security_scan - security_scan ?vuln_report - vuln_report)
    :precondition
      (and
        (artifact_allocated ?artifact)
        (artifact_bound_to_security_scan ?artifact ?security_scan)
        (vuln_report_available ?vuln_report)
        (validation_stage_available ?validation_stage)
        (artifact_stage_compatibility ?artifact ?validation_stage)
        (artifact_vuln_report_association ?artifact ?vuln_report)
        (not
          (artifact_stage_approved ?artifact)
        )
      )
    :effect
      (and
        (artifact_validated_at_stage ?artifact ?validation_stage)
        (artifact_stage_approved ?artifact)
        (artifact_vuln_flag ?artifact)
        (artifact_requires_countersign ?artifact)
        (not
          (validation_stage_available ?validation_stage)
        )
        (not
          (vuln_report_available ?vuln_report)
        )
      )
  )
  (:action record_vuln_mitigation
    :parameters (?artifact - artifact ?test_suite - test_suite ?quality_check - quality_check)
    :precondition
      (and
        (artifact_stage_approved ?artifact)
        (artifact_vuln_flag ?artifact)
        (artifact_bound_to_test_suite ?artifact ?test_suite)
        (artifact_bound_to_quality_check ?artifact ?quality_check)
      )
    :effect
      (and
        (not
          (artifact_vuln_flag ?artifact)
        )
        (not
          (artifact_requires_countersign ?artifact)
        )
      )
  )
  (:action grant_team_approval
    :parameters (?artifact - artifact ?test_suite - test_suite ?quality_check - quality_check ?team_credential - team_credential)
    :precondition
      (and
        (artifact_attested ?artifact)
        (artifact_stage_approved ?artifact)
        (artifact_bound_to_test_suite ?artifact ?test_suite)
        (artifact_bound_to_quality_check ?artifact ?quality_check)
        (artifact_credential_association ?artifact ?team_credential)
        (not
          (artifact_requires_countersign ?artifact)
        )
        (not
          (artifact_approval_granted ?artifact)
        )
      )
    :effect
      (and
        (artifact_approval_granted ?artifact)
      )
  )
  (:action grant_org_approval_with_countersign
    :parameters (?artifact - artifact ?security_scan - security_scan ?signing_key - signing_key ?org_credential - org_credential)
    :precondition
      (and
        (artifact_attested ?artifact)
        (artifact_stage_approved ?artifact)
        (artifact_bound_to_security_scan ?artifact ?security_scan)
        (artifact_bound_to_signing_key ?artifact ?signing_key)
        (artifact_credential_association ?artifact ?org_credential)
        (not
          (artifact_approval_granted ?artifact)
        )
      )
    :effect
      (and
        (artifact_approval_granted ?artifact)
        (artifact_requires_countersign ?artifact)
      )
  )
  (:action finalize_countersign
    :parameters (?artifact - artifact ?test_suite - test_suite ?quality_check - quality_check)
    :precondition
      (and
        (artifact_approval_granted ?artifact)
        (artifact_requires_countersign ?artifact)
        (artifact_bound_to_test_suite ?artifact ?test_suite)
        (artifact_bound_to_quality_check ?artifact ?quality_check)
      )
    :effect
      (and
        (artifact_countersign_completed ?artifact)
        (not
          (artifact_requires_countersign ?artifact)
        )
        (not
          (artifact_attested ?artifact)
        )
        (not
          (artifact_vuln_flag ?artifact)
        )
      )
  )
  (:action perform_attestation_after_countersign
    :parameters (?artifact - artifact ?attestation_job - attestation_job ?auditor - auditor)
    :precondition
      (and
        (artifact_countersign_completed ?artifact)
        (artifact_approval_granted ?artifact)
        (artifact_allocated ?artifact)
        (artifact_bound_to_attestation_job ?artifact ?attestation_job)
        (auditor_available ?auditor)
        (not
          (artifact_attested ?artifact)
        )
      )
    :effect
      (and
        (artifact_attested ?artifact)
      )
  )
  (:action capture_attestation_token
    :parameters (?artifact - artifact ?attestation_job - attestation_job)
    :precondition
      (and
        (artifact_approval_granted ?artifact)
        (artifact_attested ?artifact)
        (not
          (artifact_requires_countersign ?artifact)
        )
        (artifact_bound_to_attestation_job ?artifact ?attestation_job)
        (not
          (artifact_attestation_token_captured ?artifact)
        )
      )
    :effect
      (and
        (artifact_attestation_token_captured ?artifact)
      )
  )
  (:action capture_attestation_from_policy_engine
    :parameters (?artifact - artifact ?policy_engine - policy_engine)
    :precondition
      (and
        (artifact_approval_granted ?artifact)
        (artifact_attested ?artifact)
        (not
          (artifact_requires_countersign ?artifact)
        )
        (policy_engine_available ?policy_engine)
        (not
          (artifact_attestation_token_captured ?artifact)
        )
      )
    :effect
      (and
        (artifact_attestation_token_captured ?artifact)
        (not
          (policy_engine_available ?policy_engine)
        )
      )
  )
  (:action sign_release_candidate_for_target
    :parameters (?artifact - artifact ?release_target - release_target)
    :precondition
      (and
        (artifact_attestation_token_captured ?artifact)
        (release_target_available ?release_target)
        (artifact_target_association ?artifact ?release_target)
      )
    :effect
      (and
        (rc_signed_for_target ?artifact ?release_target)
        (not
          (release_target_available ?release_target)
        )
      )
  )
  (:action bind_dep_variant_to_target
    :parameters (?dep_variant - dep_variant ?rc_variant - rc_variant ?release_target - release_target)
    :precondition
      (and
        (artifact_registered ?dep_variant)
        (dep_registered ?dep_variant)
        (artifact_target_compatibility ?dep_variant ?release_target)
        (rc_signed_for_target ?rc_variant ?release_target)
        (not
          (artifact_target_bound ?dep_variant ?release_target)
        )
      )
    :effect
      (and
        (artifact_target_bound ?dep_variant ?release_target)
      )
  )
  (:action record_final_attestation
    :parameters (?artifact - artifact ?attestation_job - attestation_job ?auditor - auditor)
    :precondition
      (and
        (artifact_registered ?artifact)
        (dep_registered ?artifact)
        (artifact_attested ?artifact)
        (artifact_attestation_token_captured ?artifact)
        (artifact_bound_to_attestation_job ?artifact ?attestation_job)
        (auditor_available ?auditor)
        (not
          (artifact_final_attestation_recorded ?artifact)
        )
      )
    :effect
      (and
        (artifact_final_attestation_recorded ?artifact)
      )
  )
  (:action finalize_release_for_rc_variant
    :parameters (?artifact - artifact)
    :precondition
      (and
        (rc_registered ?artifact)
        (artifact_registered ?artifact)
        (artifact_allocated ?artifact)
        (artifact_stage_approved ?artifact)
        (artifact_approval_granted ?artifact)
        (artifact_attestation_token_captured ?artifact)
        (artifact_attested ?artifact)
        (not
          (artifact_final_released ?artifact)
        )
      )
    :effect
      (and
        (artifact_final_released ?artifact)
      )
  )
  (:action finalize_release_with_target_signature
    :parameters (?artifact - artifact ?release_target - release_target)
    :precondition
      (and
        (dep_registered ?artifact)
        (artifact_registered ?artifact)
        (artifact_allocated ?artifact)
        (artifact_stage_approved ?artifact)
        (artifact_approval_granted ?artifact)
        (artifact_attestation_token_captured ?artifact)
        (artifact_attested ?artifact)
        (artifact_target_bound ?artifact ?release_target)
        (not
          (artifact_final_released ?artifact)
        )
      )
    :effect
      (and
        (artifact_final_released ?artifact)
      )
  )
  (:action finalize_release_with_auditor_attestation
    :parameters (?artifact - artifact)
    :precondition
      (and
        (dep_registered ?artifact)
        (artifact_registered ?artifact)
        (artifact_allocated ?artifact)
        (artifact_stage_approved ?artifact)
        (artifact_approval_granted ?artifact)
        (artifact_attestation_token_captured ?artifact)
        (artifact_attested ?artifact)
        (artifact_final_attestation_recorded ?artifact)
        (not
          (artifact_final_released ?artifact)
        )
      )
    :effect
      (and
        (artifact_final_released ?artifact)
      )
  )
)

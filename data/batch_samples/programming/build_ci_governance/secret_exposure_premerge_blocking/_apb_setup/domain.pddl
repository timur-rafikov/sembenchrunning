(define (domain secret_exposure_ci_governance)
  (:requirements :strips :typing :negative-preconditions)
  (:types pull_request - object reviewer_slot - object validation_job - object ownership_group - object scanner_profile - object detection_profile - object workspace - object human_reviewer - object approval_channel - object automation_runner - object manual_test_artifact - object secret_rule - object policy_token - object policy_context - policy_token escalation_context - policy_token pr_source_branch - pull_request pr_author - pull_request)
  (:predicates
    (pr_registered ?pull_request - pull_request)
    (pr_assigned_reviewer ?pull_request - pull_request ?reviewer_slot - reviewer_slot)
    (pr_reviewer_assigned ?pull_request - pull_request)
    (workspace_checks_passed ?pull_request - pull_request)
    (attestation_recorded ?pull_request - pull_request)
    (pr_bound_scanner_profile ?pull_request - pull_request ?scanner_profile - scanner_profile)
    (pr_bound_ownership_group ?pull_request - pull_request ?ownership_group - ownership_group)
    (pr_bound_detection_profile ?pull_request - pull_request ?detection_profile - detection_profile)
    (pr_bound_secret_rule ?pull_request - pull_request ?secret_rule - secret_rule)
    (pr_validation_attested ?pull_request - pull_request ?validation_job - validation_job)
    (validation_successful ?pull_request - pull_request)
    (policy_evaluation_passed ?pull_request - pull_request)
    (approval_requested ?pull_request - pull_request)
    (pr_merge_enabled ?pull_request - pull_request)
    (remediation_required ?pull_request - pull_request)
    (remediation_acknowledged ?pull_request - pull_request)
    (author_to_approval_channel ?pull_request - pull_request ?approval_channel - approval_channel)
    (pr_approved_via_channel ?pull_request - pull_request ?approval_channel - approval_channel)
    (escalation_requested ?pull_request - pull_request)
    (reviewer_slot_available ?reviewer_slot - reviewer_slot)
    (validation_job_available ?validation_job - validation_job)
    (scanner_profile_available ?scanner_profile - scanner_profile)
    (ownership_group_available ?ownership_group - ownership_group)
    (detection_profile_available ?detection_profile - detection_profile)
    (workspace_available ?workspace - workspace)
    (human_reviewer_available ?human_reviewer - human_reviewer)
    (approval_channel_available ?approval_channel - approval_channel)
    (automation_runner_available ?automation_runner - automation_runner)
    (manual_test_artifact_available ?manual_test_artifact - manual_test_artifact)
    (secret_rule_available ?secret_rule - secret_rule)
    (pr_eligible_reviewer_slot ?pull_request - pull_request ?reviewer_slot - reviewer_slot)
    (pr_eligible_validation_job ?pull_request - pull_request ?validation_job - validation_job)
    (pr_eligible_scanner_profile ?pull_request - pull_request ?scanner_profile - scanner_profile)
    (pr_eligible_ownership_group ?pull_request - pull_request ?ownership_group - ownership_group)
    (pr_eligible_detection_profile ?pull_request - pull_request ?detection_profile - detection_profile)
    (pr_eligible_manual_artifact ?pull_request - pull_request ?manual_test_artifact - manual_test_artifact)
    (pr_eligible_secret_rule ?pull_request - pull_request ?secret_rule - secret_rule)
    (pr_policy_token_bound ?pull_request - pull_request ?policy_token - policy_token)
    (pr_bound_approval_channel ?pull_request - pull_request ?approval_channel - approval_channel)
    (protected_branch ?pull_request - pull_request)
    (author_trusted ?pull_request - pull_request)
    (pr_bound_workspace ?pull_request - pull_request ?workspace - workspace)
    (secondary_validation_flag ?pull_request - pull_request)
    (pr_eligible_approval_channel ?pull_request - pull_request ?approval_channel - approval_channel)
  )
  (:action register_pull_request
    :parameters (?pull_request - pull_request)
    :precondition
      (and
        (not
          (pr_registered ?pull_request)
        )
        (not
          (pr_merge_enabled ?pull_request)
        )
      )
    :effect
      (and
        (pr_registered ?pull_request)
      )
  )
  (:action assign_reviewer
    :parameters (?pull_request - pull_request ?reviewer_slot - reviewer_slot)
    :precondition
      (and
        (pr_registered ?pull_request)
        (reviewer_slot_available ?reviewer_slot)
        (pr_eligible_reviewer_slot ?pull_request ?reviewer_slot)
        (not
          (pr_reviewer_assigned ?pull_request)
        )
      )
    :effect
      (and
        (pr_assigned_reviewer ?pull_request ?reviewer_slot)
        (pr_reviewer_assigned ?pull_request)
        (not
          (reviewer_slot_available ?reviewer_slot)
        )
      )
  )
  (:action unassign_reviewer
    :parameters (?pull_request - pull_request ?reviewer_slot - reviewer_slot)
    :precondition
      (and
        (pr_assigned_reviewer ?pull_request ?reviewer_slot)
        (not
          (validation_successful ?pull_request)
        )
        (not
          (policy_evaluation_passed ?pull_request)
        )
      )
    :effect
      (and
        (not
          (pr_assigned_reviewer ?pull_request ?reviewer_slot)
        )
        (not
          (pr_reviewer_assigned ?pull_request)
        )
        (not
          (workspace_checks_passed ?pull_request)
        )
        (not
          (attestation_recorded ?pull_request)
        )
        (not
          (remediation_required ?pull_request)
        )
        (not
          (remediation_acknowledged ?pull_request)
        )
        (not
          (secondary_validation_flag ?pull_request)
        )
        (reviewer_slot_available ?reviewer_slot)
      )
  )
  (:action reserve_workspace
    :parameters (?pull_request - pull_request ?workspace - workspace)
    :precondition
      (and
        (pr_registered ?pull_request)
        (workspace_available ?workspace)
      )
    :effect
      (and
        (pr_bound_workspace ?pull_request ?workspace)
        (not
          (workspace_available ?workspace)
        )
      )
  )
  (:action release_workspace
    :parameters (?pull_request - pull_request ?workspace - workspace)
    :precondition
      (and
        (pr_bound_workspace ?pull_request ?workspace)
      )
    :effect
      (and
        (workspace_available ?workspace)
        (not
          (pr_bound_workspace ?pull_request ?workspace)
        )
      )
  )
  (:action mark_workspace_checks_passed
    :parameters (?pull_request - pull_request ?workspace - workspace)
    :precondition
      (and
        (pr_registered ?pull_request)
        (pr_reviewer_assigned ?pull_request)
        (pr_bound_workspace ?pull_request ?workspace)
        (not
          (workspace_checks_passed ?pull_request)
        )
      )
    :effect
      (and
        (workspace_checks_passed ?pull_request)
      )
  )
  (:action human_security_review
    :parameters (?pull_request - pull_request ?human_reviewer - human_reviewer)
    :precondition
      (and
        (pr_registered ?pull_request)
        (pr_reviewer_assigned ?pull_request)
        (human_reviewer_available ?human_reviewer)
        (not
          (workspace_checks_passed ?pull_request)
        )
      )
    :effect
      (and
        (workspace_checks_passed ?pull_request)
        (remediation_required ?pull_request)
        (not
          (human_reviewer_available ?human_reviewer)
        )
      )
  )
  (:action record_runner_attestation
    :parameters (?pull_request - pull_request ?workspace - workspace ?automation_runner - automation_runner)
    :precondition
      (and
        (workspace_checks_passed ?pull_request)
        (pr_reviewer_assigned ?pull_request)
        (pr_bound_workspace ?pull_request ?workspace)
        (automation_runner_available ?automation_runner)
        (not
          (attestation_recorded ?pull_request)
        )
      )
    :effect
      (and
        (attestation_recorded ?pull_request)
        (not
          (remediation_required ?pull_request)
        )
      )
  )
  (:action record_approval_from_channel
    :parameters (?pull_request - pull_request ?approval_channel - approval_channel)
    :precondition
      (and
        (pr_reviewer_assigned ?pull_request)
        (pr_approved_via_channel ?pull_request ?approval_channel)
        (not
          (attestation_recorded ?pull_request)
        )
      )
    :effect
      (and
        (attestation_recorded ?pull_request)
        (not
          (remediation_required ?pull_request)
        )
      )
  )
  (:action bind_scanner_profile
    :parameters (?pull_request - pull_request ?scanner_profile - scanner_profile)
    :precondition
      (and
        (pr_registered ?pull_request)
        (scanner_profile_available ?scanner_profile)
        (pr_eligible_scanner_profile ?pull_request ?scanner_profile)
      )
    :effect
      (and
        (pr_bound_scanner_profile ?pull_request ?scanner_profile)
        (not
          (scanner_profile_available ?scanner_profile)
        )
      )
  )
  (:action unbind_scanner_profile
    :parameters (?pull_request - pull_request ?scanner_profile - scanner_profile)
    :precondition
      (and
        (pr_bound_scanner_profile ?pull_request ?scanner_profile)
      )
    :effect
      (and
        (scanner_profile_available ?scanner_profile)
        (not
          (pr_bound_scanner_profile ?pull_request ?scanner_profile)
        )
      )
  )
  (:action bind_ownership_group
    :parameters (?pull_request - pull_request ?ownership_group - ownership_group)
    :precondition
      (and
        (pr_registered ?pull_request)
        (ownership_group_available ?ownership_group)
        (pr_eligible_ownership_group ?pull_request ?ownership_group)
      )
    :effect
      (and
        (pr_bound_ownership_group ?pull_request ?ownership_group)
        (not
          (ownership_group_available ?ownership_group)
        )
      )
  )
  (:action unbind_ownership_group
    :parameters (?pull_request - pull_request ?ownership_group - ownership_group)
    :precondition
      (and
        (pr_bound_ownership_group ?pull_request ?ownership_group)
      )
    :effect
      (and
        (ownership_group_available ?ownership_group)
        (not
          (pr_bound_ownership_group ?pull_request ?ownership_group)
        )
      )
  )
  (:action bind_detection_profile
    :parameters (?pull_request - pull_request ?detection_profile - detection_profile)
    :precondition
      (and
        (pr_registered ?pull_request)
        (detection_profile_available ?detection_profile)
        (pr_eligible_detection_profile ?pull_request ?detection_profile)
      )
    :effect
      (and
        (pr_bound_detection_profile ?pull_request ?detection_profile)
        (not
          (detection_profile_available ?detection_profile)
        )
      )
  )
  (:action unbind_detection_profile
    :parameters (?pull_request - pull_request ?detection_profile - detection_profile)
    :precondition
      (and
        (pr_bound_detection_profile ?pull_request ?detection_profile)
      )
    :effect
      (and
        (detection_profile_available ?detection_profile)
        (not
          (pr_bound_detection_profile ?pull_request ?detection_profile)
        )
      )
  )
  (:action bind_secret_rule
    :parameters (?pull_request - pull_request ?secret_rule - secret_rule)
    :precondition
      (and
        (pr_registered ?pull_request)
        (secret_rule_available ?secret_rule)
        (pr_eligible_secret_rule ?pull_request ?secret_rule)
      )
    :effect
      (and
        (pr_bound_secret_rule ?pull_request ?secret_rule)
        (not
          (secret_rule_available ?secret_rule)
        )
      )
  )
  (:action unbind_secret_rule
    :parameters (?pull_request - pull_request ?secret_rule - secret_rule)
    :precondition
      (and
        (pr_bound_secret_rule ?pull_request ?secret_rule)
      )
    :effect
      (and
        (secret_rule_available ?secret_rule)
        (not
          (pr_bound_secret_rule ?pull_request ?secret_rule)
        )
      )
  )
  (:action record_validation_job_success
    :parameters (?pull_request - pull_request ?validation_job - validation_job ?scanner_profile - scanner_profile ?ownership_group - ownership_group)
    :precondition
      (and
        (pr_reviewer_assigned ?pull_request)
        (pr_bound_scanner_profile ?pull_request ?scanner_profile)
        (pr_bound_ownership_group ?pull_request ?ownership_group)
        (validation_job_available ?validation_job)
        (pr_eligible_validation_job ?pull_request ?validation_job)
        (not
          (validation_successful ?pull_request)
        )
      )
    :effect
      (and
        (pr_validation_attested ?pull_request ?validation_job)
        (validation_successful ?pull_request)
        (not
          (validation_job_available ?validation_job)
        )
      )
  )
  (:action record_complex_validation
    :parameters (?pull_request - pull_request ?validation_job - validation_job ?detection_profile - detection_profile ?manual_test_artifact - manual_test_artifact)
    :precondition
      (and
        (pr_reviewer_assigned ?pull_request)
        (pr_bound_detection_profile ?pull_request ?detection_profile)
        (manual_test_artifact_available ?manual_test_artifact)
        (validation_job_available ?validation_job)
        (pr_eligible_validation_job ?pull_request ?validation_job)
        (pr_eligible_manual_artifact ?pull_request ?manual_test_artifact)
        (not
          (validation_successful ?pull_request)
        )
      )
    :effect
      (and
        (pr_validation_attested ?pull_request ?validation_job)
        (validation_successful ?pull_request)
        (secondary_validation_flag ?pull_request)
        (remediation_required ?pull_request)
        (not
          (validation_job_available ?validation_job)
        )
        (not
          (manual_test_artifact_available ?manual_test_artifact)
        )
      )
  )
  (:action clear_secondary_validation
    :parameters (?pull_request - pull_request ?scanner_profile - scanner_profile ?ownership_group - ownership_group)
    :precondition
      (and
        (validation_successful ?pull_request)
        (secondary_validation_flag ?pull_request)
        (pr_bound_scanner_profile ?pull_request ?scanner_profile)
        (pr_bound_ownership_group ?pull_request ?ownership_group)
      )
    :effect
      (and
        (not
          (secondary_validation_flag ?pull_request)
        )
        (not
          (remediation_required ?pull_request)
        )
      )
  )
  (:action apply_policy_evaluation
    :parameters (?pull_request - pull_request ?scanner_profile - scanner_profile ?ownership_group - ownership_group ?policy_context - policy_context)
    :precondition
      (and
        (attestation_recorded ?pull_request)
        (validation_successful ?pull_request)
        (pr_bound_scanner_profile ?pull_request ?scanner_profile)
        (pr_bound_ownership_group ?pull_request ?ownership_group)
        (pr_policy_token_bound ?pull_request ?policy_context)
        (not
          (remediation_required ?pull_request)
        )
        (not
          (policy_evaluation_passed ?pull_request)
        )
      )
    :effect
      (and
        (policy_evaluation_passed ?pull_request)
      )
  )
  (:action apply_detection_policy_with_escalation
    :parameters (?pull_request - pull_request ?detection_profile - detection_profile ?secret_rule - secret_rule ?escalation_context - escalation_context)
    :precondition
      (and
        (attestation_recorded ?pull_request)
        (validation_successful ?pull_request)
        (pr_bound_detection_profile ?pull_request ?detection_profile)
        (pr_bound_secret_rule ?pull_request ?secret_rule)
        (pr_policy_token_bound ?pull_request ?escalation_context)
        (not
          (policy_evaluation_passed ?pull_request)
        )
      )
    :effect
      (and
        (policy_evaluation_passed ?pull_request)
        (remediation_required ?pull_request)
      )
  )
  (:action finalize_remediation
    :parameters (?pull_request - pull_request ?scanner_profile - scanner_profile ?ownership_group - ownership_group)
    :precondition
      (and
        (policy_evaluation_passed ?pull_request)
        (remediation_required ?pull_request)
        (pr_bound_scanner_profile ?pull_request ?scanner_profile)
        (pr_bound_ownership_group ?pull_request ?ownership_group)
      )
    :effect
      (and
        (remediation_acknowledged ?pull_request)
        (not
          (remediation_required ?pull_request)
        )
        (not
          (attestation_recorded ?pull_request)
        )
        (not
          (secondary_validation_flag ?pull_request)
        )
      )
  )
  (:action record_runner_attestation_from_workspace
    :parameters (?pull_request - pull_request ?workspace - workspace ?automation_runner - automation_runner)
    :precondition
      (and
        (remediation_acknowledged ?pull_request)
        (policy_evaluation_passed ?pull_request)
        (pr_reviewer_assigned ?pull_request)
        (pr_bound_workspace ?pull_request ?workspace)
        (automation_runner_available ?automation_runner)
        (not
          (attestation_recorded ?pull_request)
        )
      )
    :effect
      (and
        (attestation_recorded ?pull_request)
      )
  )
  (:action mark_approval_requested_from_workspace
    :parameters (?pull_request - pull_request ?workspace - workspace)
    :precondition
      (and
        (policy_evaluation_passed ?pull_request)
        (attestation_recorded ?pull_request)
        (not
          (remediation_required ?pull_request)
        )
        (pr_bound_workspace ?pull_request ?workspace)
        (not
          (approval_requested ?pull_request)
        )
      )
    :effect
      (and
        (approval_requested ?pull_request)
      )
  )
  (:action human_reviewer_approve
    :parameters (?pull_request - pull_request ?human_reviewer - human_reviewer)
    :precondition
      (and
        (policy_evaluation_passed ?pull_request)
        (attestation_recorded ?pull_request)
        (not
          (remediation_required ?pull_request)
        )
        (human_reviewer_available ?human_reviewer)
        (not
          (approval_requested ?pull_request)
        )
      )
    :effect
      (and
        (approval_requested ?pull_request)
        (not
          (human_reviewer_available ?human_reviewer)
        )
      )
  )
  (:action bind_pr_to_approval_channel
    :parameters (?pull_request - pull_request ?approval_channel - approval_channel)
    :precondition
      (and
        (approval_requested ?pull_request)
        (approval_channel_available ?approval_channel)
        (pr_eligible_approval_channel ?pull_request ?approval_channel)
      )
    :effect
      (and
        (pr_bound_approval_channel ?pull_request ?approval_channel)
        (not
          (approval_channel_available ?approval_channel)
        )
      )
  )
  (:action author_channel_approval
    :parameters (?author - pr_author ?source_branch - pr_source_branch ?approval_channel - approval_channel)
    :precondition
      (and
        (pr_registered ?author)
        (author_trusted ?author)
        (author_to_approval_channel ?author ?approval_channel)
        (pr_bound_approval_channel ?source_branch ?approval_channel)
        (not
          (pr_approved_via_channel ?author ?approval_channel)
        )
      )
    :effect
      (and
        (pr_approved_via_channel ?author ?approval_channel)
      )
  )
  (:action request_escalation
    :parameters (?pull_request - pull_request ?workspace - workspace ?automation_runner - automation_runner)
    :precondition
      (and
        (pr_registered ?pull_request)
        (author_trusted ?pull_request)
        (attestation_recorded ?pull_request)
        (approval_requested ?pull_request)
        (pr_bound_workspace ?pull_request ?workspace)
        (automation_runner_available ?automation_runner)
        (not
          (escalation_requested ?pull_request)
        )
      )
    :effect
      (and
        (escalation_requested ?pull_request)
      )
  )
  (:action enable_merge_for_branch
    :parameters (?pull_request - pull_request)
    :precondition
      (and
        (protected_branch ?pull_request)
        (pr_registered ?pull_request)
        (pr_reviewer_assigned ?pull_request)
        (validation_successful ?pull_request)
        (policy_evaluation_passed ?pull_request)
        (approval_requested ?pull_request)
        (attestation_recorded ?pull_request)
        (not
          (pr_merge_enabled ?pull_request)
        )
      )
    :effect
      (and
        (pr_merge_enabled ?pull_request)
      )
  )
  (:action enable_merge_with_channel
    :parameters (?pull_request - pull_request ?approval_channel - approval_channel)
    :precondition
      (and
        (author_trusted ?pull_request)
        (pr_registered ?pull_request)
        (pr_reviewer_assigned ?pull_request)
        (validation_successful ?pull_request)
        (policy_evaluation_passed ?pull_request)
        (approval_requested ?pull_request)
        (attestation_recorded ?pull_request)
        (pr_approved_via_channel ?pull_request ?approval_channel)
        (not
          (pr_merge_enabled ?pull_request)
        )
      )
    :effect
      (and
        (pr_merge_enabled ?pull_request)
      )
  )
  (:action enable_merge_with_escalation
    :parameters (?pull_request - pull_request)
    :precondition
      (and
        (author_trusted ?pull_request)
        (pr_registered ?pull_request)
        (pr_reviewer_assigned ?pull_request)
        (validation_successful ?pull_request)
        (policy_evaluation_passed ?pull_request)
        (approval_requested ?pull_request)
        (attestation_recorded ?pull_request)
        (escalation_requested ?pull_request)
        (not
          (pr_merge_enabled ?pull_request)
        )
      )
    :effect
      (and
        (pr_merge_enabled ?pull_request)
      )
  )
)

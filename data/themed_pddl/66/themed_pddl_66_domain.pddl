(define (domain patch_backport_branch_selection_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types backport_request - generic_object source_branch_candidate - generic_object target_release - generic_object repository_component - generic_object patch_commit - generic_object backport_candidate_commit - generic_object release_window - generic_object oncall_approver - generic_object reviewer - generic_object ci_job - generic_object test_environment - generic_object risk_tag - generic_object approver_group - generic_object primary_approver_group - approver_group secondary_approver_group - approver_group urgent_case_variant - backport_request standard_case_variant - backport_request)
  (:predicates
    (oncall_approver_available ?oncall_approver - oncall_approver)
    (associated_component ?backport_request - backport_request ?repository_component - repository_component)
    (ready_for_completion ?backport_request - backport_request)
    (assigned_source_branch ?backport_request - backport_request ?source_branch_candidate - source_branch_candidate)
    (request_requires_approver_group ?backport_request - backport_request ?approver_group - approver_group)
    (backport_candidate_available ?backport_candidate_commit - backport_candidate_commit)
    (component_available ?repository_component - repository_component)
    (request_risk_tag ?backport_request - backport_request ?risk_tag - risk_tag)
    (request_completed ?backport_request - backport_request)
    (is_declared_urgent ?backport_request - backport_request)
    (request_candidate_compatible ?backport_request - backport_request ?source_branch_candidate - source_branch_candidate)
    (target_release_available ?target_release - target_release)
    (test_environment_available ?test_environment - test_environment)
    (release_window_available ?release_window - release_window)
    (evaluation_completed ?backport_request - backport_request)
    (request_component_candidate ?backport_request - backport_request ?repository_component - repository_component)
    (assigned_risk_tag ?backport_request - backport_request ?risk_tag - risk_tag)
    (selected_target_release ?backport_request - backport_request ?target_release - target_release)
    (clearance_recorded ?backport_request - backport_request)
    (request_backport_candidate ?backport_request - backport_request ?backport_candidate_commit - backport_candidate_commit)
    (risk_tag_available ?risk_tag - risk_tag)
    (is_standard_case ?backport_request - backport_request)
    (validation_succeeded ?backport_request - backport_request)
    (request_patch_candidate ?backport_request - backport_request ?patch_commit - patch_commit)
    (associated_patch_commit ?backport_request - backport_request ?patch_commit - patch_commit)
    (evaluation_resources_allocated ?backport_request - backport_request)
    (bound_release_window ?backport_request - backport_request ?release_window - release_window)
    (final_validation_recorded ?backport_request - backport_request)
    (request_testable_in_environment ?backport_request - backport_request ?test_environment - test_environment)
    (backport_request_open ?backport_request - backport_request)
    (source_branch_available ?source_branch_candidate - source_branch_candidate)
    (has_assigned_source_branch ?backport_request - backport_request)
    (ci_job_available ?ci_job - ci_job)
    (reviewer_available ?reviewer - reviewer)
    (associated_backport_candidate ?backport_request - backport_request ?backport_candidate_commit - backport_candidate_commit)
    (assigned_reviewer ?backport_request - backport_request ?reviewer - reviewer)
    (approval_obtained ?backport_request - backport_request)
    (review_authorized ?backport_request - backport_request)
    (request_reviewer_default ?backport_request - backport_request ?reviewer - reviewer)
    (patch_commit_available ?patch_commit - patch_commit)
    (case_variant_reviewer_mapping ?backport_request - backport_request ?reviewer - reviewer)
    (request_target_compatible ?backport_request - backport_request ?target_release - target_release)
    (pending_additional_checks ?backport_request - backport_request)
    (reviewer_attached ?backport_request - backport_request ?reviewer - reviewer)
  )
  (:action unassign_risk_tag
    :parameters (?backport_request - backport_request ?risk_tag - risk_tag)
    :precondition
      (and
        (assigned_risk_tag ?backport_request ?risk_tag)
      )
    :effect
      (and
        (risk_tag_available ?risk_tag)
        (not
          (assigned_risk_tag ?backport_request ?risk_tag)
        )
      )
  )
  (:action record_secondary_approval_and_escalation
    :parameters (?backport_request - backport_request ?backport_candidate_commit - backport_candidate_commit ?risk_tag - risk_tag ?secondary_approver_group - secondary_approver_group)
    :precondition
      (and
        (not
          (clearance_recorded ?backport_request)
        )
        (evaluation_completed ?backport_request)
        (validation_succeeded ?backport_request)
        (assigned_risk_tag ?backport_request ?risk_tag)
        (request_requires_approver_group ?backport_request ?secondary_approver_group)
        (associated_backport_candidate ?backport_request ?backport_candidate_commit)
      )
    :effect
      (and
        (pending_additional_checks ?backport_request)
        (clearance_recorded ?backport_request)
      )
  )
  (:action complete_request_urgent_flow
    :parameters (?backport_request - backport_request)
    :precondition
      (and
        (validation_succeeded ?backport_request)
        (has_assigned_source_branch ?backport_request)
        (evaluation_completed ?backport_request)
        (backport_request_open ?backport_request)
        (review_authorized ?backport_request)
        (not
          (request_completed ?backport_request)
        )
        (is_declared_urgent ?backport_request)
        (clearance_recorded ?backport_request)
      )
    :effect
      (and
        (request_completed ?backport_request)
      )
  )
  (:action acknowledge_evaluation_outcome
    :parameters (?backport_request - backport_request ?patch_commit - patch_commit ?repository_component - repository_component)
    :precondition
      (and
        (evaluation_completed ?backport_request)
        (evaluation_resources_allocated ?backport_request)
        (associated_patch_commit ?backport_request ?patch_commit)
        (associated_component ?backport_request ?repository_component)
      )
    :effect
      (and
        (not
          (evaluation_resources_allocated ?backport_request)
        )
        (not
          (pending_additional_checks ?backport_request)
        )
      )
  )
  (:action bind_release_window
    :parameters (?backport_request - backport_request ?release_window - release_window)
    :precondition
      (and
        (release_window_available ?release_window)
        (backport_request_open ?backport_request)
      )
    :effect
      (and
        (not
          (release_window_available ?release_window)
        )
        (bound_release_window ?backport_request ?release_window)
      )
  )
  (:action record_primary_approval
    :parameters (?backport_request - backport_request ?patch_commit - patch_commit ?repository_component - repository_component ?primary_approver_group - primary_approver_group)
    :precondition
      (and
        (request_requires_approver_group ?backport_request ?primary_approver_group)
        (validation_succeeded ?backport_request)
        (not
          (pending_additional_checks ?backport_request)
        )
        (associated_patch_commit ?backport_request ?patch_commit)
        (evaluation_completed ?backport_request)
        (associated_component ?backport_request ?repository_component)
        (not
          (clearance_recorded ?backport_request)
        )
      )
    :effect
      (and
        (clearance_recorded ?backport_request)
      )
  )
  (:action record_reviewer_validation
    :parameters (?backport_request - backport_request ?reviewer - reviewer)
    :precondition
      (and
        (has_assigned_source_branch ?backport_request)
        (reviewer_attached ?backport_request ?reviewer)
        (not
          (validation_succeeded ?backport_request)
        )
      )
    :effect
      (and
        (validation_succeeded ?backport_request)
        (not
          (pending_additional_checks ?backport_request)
        )
      )
  )
  (:action associate_backport_candidate
    :parameters (?backport_request - backport_request ?backport_candidate_commit - backport_candidate_commit)
    :precondition
      (and
        (request_backport_candidate ?backport_request ?backport_candidate_commit)
        (backport_request_open ?backport_request)
        (backport_candidate_available ?backport_candidate_commit)
      )
    :effect
      (and
        (associated_backport_candidate ?backport_request ?backport_candidate_commit)
        (not
          (backport_candidate_available ?backport_candidate_commit)
        )
      )
  )
  (:action associate_patch_commit
    :parameters (?backport_request - backport_request ?patch_commit - patch_commit)
    :precondition
      (and
        (backport_request_open ?backport_request)
        (patch_commit_available ?patch_commit)
        (request_patch_candidate ?backport_request ?patch_commit)
      )
    :effect
      (and
        (not
          (patch_commit_available ?patch_commit)
        )
        (associated_patch_commit ?backport_request ?patch_commit)
      )
  )
  (:action dissociate_backport_candidate
    :parameters (?backport_request - backport_request ?backport_candidate_commit - backport_candidate_commit)
    :precondition
      (and
        (associated_backport_candidate ?backport_request ?backport_candidate_commit)
      )
    :effect
      (and
        (backport_candidate_available ?backport_candidate_commit)
        (not
          (associated_backport_candidate ?backport_request ?backport_candidate_commit)
        )
      )
  )
  (:action dissociate_component
    :parameters (?backport_request - backport_request ?repository_component - repository_component)
    :precondition
      (and
        (associated_component ?backport_request ?repository_component)
      )
    :effect
      (and
        (component_available ?repository_component)
        (not
          (associated_component ?backport_request ?repository_component)
        )
      )
  )
  (:action bind_reviewer_to_request
    :parameters (?backport_request - backport_request ?reviewer - reviewer)
    :precondition
      (and
        (review_authorized ?backport_request)
        (reviewer_available ?reviewer)
        (request_reviewer_default ?backport_request ?reviewer)
      )
    :effect
      (and
        (assigned_reviewer ?backport_request ?reviewer)
        (not
          (reviewer_available ?reviewer)
        )
      )
  )
  (:action associate_component
    :parameters (?backport_request - backport_request ?repository_component - repository_component)
    :precondition
      (and
        (backport_request_open ?backport_request)
        (component_available ?repository_component)
        (request_component_candidate ?backport_request ?repository_component)
      )
    :effect
      (and
        (associated_component ?backport_request ?repository_component)
        (not
          (component_available ?repository_component)
        )
      )
  )
  (:action execute_release_evaluation
    :parameters (?backport_request - backport_request ?target_release - target_release ?patch_commit - patch_commit ?repository_component - repository_component)
    :precondition
      (and
        (has_assigned_source_branch ?backport_request)
        (target_release_available ?target_release)
        (request_target_compatible ?backport_request ?target_release)
        (not
          (evaluation_completed ?backport_request)
        )
        (associated_component ?backport_request ?repository_component)
        (associated_patch_commit ?backport_request ?patch_commit)
      )
    :effect
      (and
        (selected_target_release ?backport_request ?target_release)
        (not
          (target_release_available ?target_release)
        )
        (evaluation_completed ?backport_request)
      )
  )
  (:action finalize_approval_to_ready
    :parameters (?backport_request - backport_request ?patch_commit - patch_commit ?repository_component - repository_component)
    :precondition
      (and
        (associated_patch_commit ?backport_request ?patch_commit)
        (clearance_recorded ?backport_request)
        (associated_component ?backport_request ?repository_component)
        (pending_additional_checks ?backport_request)
      )
    :effect
      (and
        (not
          (evaluation_resources_allocated ?backport_request)
        )
        (not
          (pending_additional_checks ?backport_request)
        )
        (not
          (validation_succeeded ?backport_request)
        )
        (ready_for_completion ?backport_request)
      )
  )
  (:action unbind_release_window
    :parameters (?backport_request - backport_request ?release_window - release_window)
    :precondition
      (and
        (bound_release_window ?backport_request ?release_window)
      )
    :effect
      (and
        (release_window_available ?release_window)
        (not
          (bound_release_window ?backport_request ?release_window)
        )
      )
  )
  (:action record_ci_validation
    :parameters (?backport_request - backport_request ?release_window - release_window ?ci_job - ci_job)
    :precondition
      (and
        (not
          (validation_succeeded ?backport_request)
        )
        (has_assigned_source_branch ?backport_request)
        (ci_job_available ?ci_job)
        (bound_release_window ?backport_request ?release_window)
        (approval_obtained ?backport_request)
      )
    :effect
      (and
        (not
          (pending_additional_checks ?backport_request)
        )
        (validation_succeeded ?backport_request)
      )
  )
  (:action complete_request_with_final_validation
    :parameters (?backport_request - backport_request)
    :precondition
      (and
        (backport_request_open ?backport_request)
        (is_standard_case ?backport_request)
        (final_validation_recorded ?backport_request)
        (has_assigned_source_branch ?backport_request)
        (validation_succeeded ?backport_request)
        (not
          (request_completed ?backport_request)
        )
        (review_authorized ?backport_request)
        (evaluation_completed ?backport_request)
        (clearance_recorded ?backport_request)
      )
    :effect
      (and
        (request_completed ?backport_request)
      )
  )
  (:action record_validation_milestone
    :parameters (?backport_request - backport_request ?release_window - release_window ?ci_job - ci_job)
    :precondition
      (and
        (validation_succeeded ?backport_request)
        (ci_job_available ?ci_job)
        (not
          (final_validation_recorded ?backport_request)
        )
        (review_authorized ?backport_request)
        (backport_request_open ?backport_request)
        (is_standard_case ?backport_request)
        (bound_release_window ?backport_request ?release_window)
      )
    :effect
      (and
        (final_validation_recorded ?backport_request)
      )
  )
  (:action dissociate_patch_commit
    :parameters (?backport_request - backport_request ?patch_commit - patch_commit)
    :precondition
      (and
        (associated_patch_commit ?backport_request ?patch_commit)
      )
    :effect
      (and
        (patch_commit_available ?patch_commit)
        (not
          (associated_patch_commit ?backport_request ?patch_commit)
        )
      )
  )
  (:action assign_risk_tag
    :parameters (?backport_request - backport_request ?risk_tag - risk_tag)
    :precondition
      (and
        (risk_tag_available ?risk_tag)
        (backport_request_open ?backport_request)
        (request_risk_tag ?backport_request ?risk_tag)
      )
    :effect
      (and
        (assigned_risk_tag ?backport_request ?risk_tag)
        (not
          (risk_tag_available ?risk_tag)
        )
      )
  )
  (:action open_backport_request
    :parameters (?backport_request - backport_request)
    :precondition
      (and
        (not
          (backport_request_open ?backport_request)
        )
        (not
          (request_completed ?backport_request)
        )
      )
    :effect
      (and
        (backport_request_open ?backport_request)
      )
  )
  (:action record_oncall_approval
    :parameters (?backport_request - backport_request ?oncall_approver - oncall_approver)
    :precondition
      (and
        (not
          (approval_obtained ?backport_request)
        )
        (backport_request_open ?backport_request)
        (oncall_approver_available ?oncall_approver)
        (has_assigned_source_branch ?backport_request)
      )
    :effect
      (and
        (pending_additional_checks ?backport_request)
        (not
          (oncall_approver_available ?oncall_approver)
        )
        (approval_obtained ?backport_request)
      )
  )
  (:action execute_environment_evaluation
    :parameters (?backport_request - backport_request ?target_release - target_release ?backport_candidate_commit - backport_candidate_commit ?test_environment - test_environment)
    :precondition
      (and
        (test_environment_available ?test_environment)
        (request_testable_in_environment ?backport_request ?test_environment)
        (not
          (evaluation_completed ?backport_request)
        )
        (has_assigned_source_branch ?backport_request)
        (target_release_available ?target_release)
        (request_target_compatible ?backport_request ?target_release)
        (associated_backport_candidate ?backport_request ?backport_candidate_commit)
      )
    :effect
      (and
        (selected_target_release ?backport_request ?target_release)
        (not
          (test_environment_available ?test_environment)
        )
        (evaluation_resources_allocated ?backport_request)
        (not
          (target_release_available ?target_release)
        )
        (pending_additional_checks ?backport_request)
        (evaluation_completed ?backport_request)
      )
  )
  (:action authorize_review_by_oncall
    :parameters (?backport_request - backport_request ?oncall_approver - oncall_approver)
    :precondition
      (and
        (oncall_approver_available ?oncall_approver)
        (not
          (pending_additional_checks ?backport_request)
        )
        (validation_succeeded ?backport_request)
        (clearance_recorded ?backport_request)
        (not
          (review_authorized ?backport_request)
        )
      )
    :effect
      (and
        (review_authorized ?backport_request)
        (not
          (oncall_approver_available ?oncall_approver)
        )
      )
  )
  (:action revoke_source_branch_assignment
    :parameters (?backport_request - backport_request ?source_branch_candidate - source_branch_candidate)
    :precondition
      (and
        (assigned_source_branch ?backport_request ?source_branch_candidate)
        (not
          (clearance_recorded ?backport_request)
        )
        (not
          (evaluation_completed ?backport_request)
        )
      )
    :effect
      (and
        (not
          (assigned_source_branch ?backport_request ?source_branch_candidate)
        )
        (source_branch_available ?source_branch_candidate)
        (not
          (has_assigned_source_branch ?backport_request)
        )
        (not
          (approval_obtained ?backport_request)
        )
        (not
          (ready_for_completion ?backport_request)
        )
        (not
          (validation_succeeded ?backport_request)
        )
        (not
          (evaluation_resources_allocated ?backport_request)
        )
        (not
          (pending_additional_checks ?backport_request)
        )
      )
  )
  (:action authorize_review_for_release_window
    :parameters (?backport_request - backport_request ?release_window - release_window)
    :precondition
      (and
        (not
          (review_authorized ?backport_request)
        )
        (bound_release_window ?backport_request ?release_window)
        (validation_succeeded ?backport_request)
        (clearance_recorded ?backport_request)
        (not
          (pending_additional_checks ?backport_request)
        )
      )
    :effect
      (and
        (review_authorized ?backport_request)
      )
  )
  (:action complete_request_with_reviewer_approval
    :parameters (?backport_request - backport_request ?reviewer - reviewer)
    :precondition
      (and
        (review_authorized ?backport_request)
        (clearance_recorded ?backport_request)
        (evaluation_completed ?backport_request)
        (reviewer_attached ?backport_request ?reviewer)
        (validation_succeeded ?backport_request)
        (has_assigned_source_branch ?backport_request)
        (backport_request_open ?backport_request)
        (not
          (request_completed ?backport_request)
        )
        (is_standard_case ?backport_request)
      )
    :effect
      (and
        (request_completed ?backport_request)
      )
  )
  (:action confirm_release_window_approval
    :parameters (?backport_request - backport_request ?release_window - release_window)
    :precondition
      (and
        (backport_request_open ?backport_request)
        (has_assigned_source_branch ?backport_request)
        (not
          (approval_obtained ?backport_request)
        )
        (bound_release_window ?backport_request ?release_window)
      )
    :effect
      (and
        (approval_obtained ?backport_request)
      )
  )
  (:action propose_source_branch
    :parameters (?backport_request - backport_request ?source_branch_candidate - source_branch_candidate)
    :precondition
      (and
        (not
          (has_assigned_source_branch ?backport_request)
        )
        (backport_request_open ?backport_request)
        (source_branch_available ?source_branch_candidate)
        (request_candidate_compatible ?backport_request ?source_branch_candidate)
      )
    :effect
      (and
        (has_assigned_source_branch ?backport_request)
        (not
          (source_branch_available ?source_branch_candidate)
        )
        (assigned_source_branch ?backport_request ?source_branch_candidate)
      )
  )
  (:action revalidate_with_ci
    :parameters (?backport_request - backport_request ?release_window - release_window ?ci_job - ci_job)
    :precondition
      (and
        (has_assigned_source_branch ?backport_request)
        (not
          (validation_succeeded ?backport_request)
        )
        (bound_release_window ?backport_request ?release_window)
        (clearance_recorded ?backport_request)
        (ci_job_available ?ci_job)
        (ready_for_completion ?backport_request)
      )
    :effect
      (and
        (validation_succeeded ?backport_request)
      )
  )
  (:action assign_reviewer_for_variant
    :parameters (?standard_case_variant - standard_case_variant ?urgent_case_variant - urgent_case_variant ?reviewer - reviewer)
    :precondition
      (and
        (backport_request_open ?standard_case_variant)
        (assigned_reviewer ?urgent_case_variant ?reviewer)
        (is_standard_case ?standard_case_variant)
        (not
          (reviewer_attached ?standard_case_variant ?reviewer)
        )
        (case_variant_reviewer_mapping ?standard_case_variant ?reviewer)
      )
    :effect
      (and
        (reviewer_attached ?standard_case_variant ?reviewer)
      )
  )
)

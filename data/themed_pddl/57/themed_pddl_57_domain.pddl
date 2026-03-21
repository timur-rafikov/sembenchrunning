(define (domain ci_dependency_scan_governance)
  (:requirements :strips :typing :negative-preconditions)
  (:types pipeline_run - base_object build_agent - base_object deployment_environment - base_object team_reviewer - base_object dependency_scanner - base_object policy_check - base_object scan_profile - base_object manual_approver - base_object release_target - base_object approver_credential - base_object exception_document - base_object risk_descriptor - base_object organizational_role - base_object service_owner - organizational_role security_representative - organizational_role feature_branch_run - pipeline_run release_branch_run - pipeline_run)
  (:predicates
    (manual_approver_available ?manual_approver - manual_approver)
    (pipeline_assigned_team_reviewer ?pipeline_run - pipeline_run ?team_reviewer - team_reviewer)
    (pipeline_override_approved ?pipeline_run - pipeline_run)
    (pipeline_assigned_build_agent ?pipeline_run - pipeline_run ?build_agent - build_agent)
    (pipeline_assigned_org_role ?pipeline_run - pipeline_run ?organizational_role - organizational_role)
    (policy_check_available ?policy_check - policy_check)
    (team_reviewer_available ?team_reviewer - team_reviewer)
    (pipeline_risk_applicable ?pipeline_run - pipeline_run ?risk_descriptor - risk_descriptor)
    (pipeline_eligible_for_promotion ?pipeline_run - pipeline_run)
    (is_feature_branch_run ?pipeline_run - pipeline_run)
    (pipeline_build_agent_compatible ?pipeline_run - pipeline_run ?build_agent - build_agent)
    (deployment_environment_available ?deployment_environment - deployment_environment)
    (exception_document_available ?exception_document - exception_document)
    (scan_profile_available ?scan_profile - scan_profile)
    (pipeline_policy_evaluation_complete ?pipeline_run - pipeline_run)
    (pipeline_team_reviewer_compatible ?pipeline_run - pipeline_run ?team_reviewer - team_reviewer)
    (pipeline_has_risk_descriptor ?pipeline_run - pipeline_run ?risk_descriptor - risk_descriptor)
    (pipeline_validated_for_environment ?pipeline_run - pipeline_run ?deployment_environment - deployment_environment)
    (pipeline_override_requested ?pipeline_run - pipeline_run)
    (pipeline_policy_check_compatible ?pipeline_run - pipeline_run ?policy_check - policy_check)
    (risk_descriptor_available ?risk_descriptor - risk_descriptor)
    (is_release_branch_run ?pipeline_run - pipeline_run)
    (pipeline_scan_verified ?pipeline_run - pipeline_run)
    (pipeline_dependency_scanner_compatible ?pipeline_run - pipeline_run ?dependency_scanner - dependency_scanner)
    (pipeline_assigned_dependency_scanner ?pipeline_run - pipeline_run ?dependency_scanner - dependency_scanner)
    (pipeline_has_policy_findings ?pipeline_run - pipeline_run)
    (pipeline_assigned_scan_profile ?pipeline_run - pipeline_run ?scan_profile - scan_profile)
    (pipeline_ready_for_promotion_checks ?pipeline_run - pipeline_run)
    (pipeline_exception_applicable ?pipeline_run - pipeline_run ?exception_document - exception_document)
    (pipeline_run_registered ?pipeline_run - pipeline_run)
    (build_agent_available ?build_agent - build_agent)
    (pipeline_resources_reserved ?pipeline_run - pipeline_run)
    (approver_credential_available ?approver_credential - approver_credential)
    (release_target_available ?release_target - release_target)
    (pipeline_assigned_policy_check ?pipeline_run - pipeline_run ?policy_check - policy_check)
    (feature_run_mapped_release_target ?pipeline_run - pipeline_run ?release_target - release_target)
    (pipeline_scan_initiated ?pipeline_run - pipeline_run)
    (pipeline_override_credential_recorded ?pipeline_run - pipeline_run)
    (pipeline_declared_release_target ?pipeline_run - pipeline_run ?release_target - release_target)
    (dependency_scanner_available ?dependency_scanner - dependency_scanner)
    (release_branch_run_declared_target ?pipeline_run - pipeline_run ?release_target - release_target)
    (pipeline_deployment_environment_compatible ?pipeline_run - pipeline_run ?deployment_environment - deployment_environment)
    (pipeline_has_open_findings ?pipeline_run - pipeline_run)
    (pipeline_bound_to_release_target ?pipeline_run - pipeline_run ?release_target - release_target)
  )
  (:action release_risk_descriptor
    :parameters (?pipeline_run - pipeline_run ?risk_descriptor - risk_descriptor)
    :precondition
      (and
        (pipeline_has_risk_descriptor ?pipeline_run ?risk_descriptor)
      )
    :effect
      (and
        (risk_descriptor_available ?risk_descriptor)
        (not
          (pipeline_has_risk_descriptor ?pipeline_run ?risk_descriptor)
        )
      )
  )
  (:action escalate_override_to_security
    :parameters (?pipeline_run - pipeline_run ?policy_check - policy_check ?risk_descriptor - risk_descriptor ?security_representative - security_representative)
    :precondition
      (and
        (not
          (pipeline_override_requested ?pipeline_run)
        )
        (pipeline_policy_evaluation_complete ?pipeline_run)
        (pipeline_scan_verified ?pipeline_run)
        (pipeline_has_risk_descriptor ?pipeline_run ?risk_descriptor)
        (pipeline_assigned_org_role ?pipeline_run ?security_representative)
        (pipeline_assigned_policy_check ?pipeline_run ?policy_check)
      )
    :effect
      (and
        (pipeline_has_open_findings ?pipeline_run)
        (pipeline_override_requested ?pipeline_run)
      )
  )
  (:action finalize_promotion_from_checks
    :parameters (?pipeline_run - pipeline_run)
    :precondition
      (and
        (pipeline_scan_verified ?pipeline_run)
        (pipeline_resources_reserved ?pipeline_run)
        (pipeline_policy_evaluation_complete ?pipeline_run)
        (pipeline_run_registered ?pipeline_run)
        (pipeline_override_credential_recorded ?pipeline_run)
        (not
          (pipeline_eligible_for_promotion ?pipeline_run)
        )
        (is_feature_branch_run ?pipeline_run)
        (pipeline_override_requested ?pipeline_run)
      )
    :effect
      (and
        (pipeline_eligible_for_promotion ?pipeline_run)
      )
  )
  (:action clear_policy_findings_after_review
    :parameters (?pipeline_run - pipeline_run ?dependency_scanner - dependency_scanner ?team_reviewer - team_reviewer)
    :precondition
      (and
        (pipeline_policy_evaluation_complete ?pipeline_run)
        (pipeline_has_policy_findings ?pipeline_run)
        (pipeline_assigned_dependency_scanner ?pipeline_run ?dependency_scanner)
        (pipeline_assigned_team_reviewer ?pipeline_run ?team_reviewer)
      )
    :effect
      (and
        (not
          (pipeline_has_policy_findings ?pipeline_run)
        )
        (not
          (pipeline_has_open_findings ?pipeline_run)
        )
      )
  )
  (:action assign_scan_profile
    :parameters (?pipeline_run - pipeline_run ?scan_profile - scan_profile)
    :precondition
      (and
        (scan_profile_available ?scan_profile)
        (pipeline_run_registered ?pipeline_run)
      )
    :effect
      (and
        (not
          (scan_profile_available ?scan_profile)
        )
        (pipeline_assigned_scan_profile ?pipeline_run ?scan_profile)
      )
  )
  (:action request_manual_override
    :parameters (?pipeline_run - pipeline_run ?dependency_scanner - dependency_scanner ?team_reviewer - team_reviewer ?service_owner - service_owner)
    :precondition
      (and
        (pipeline_assigned_org_role ?pipeline_run ?service_owner)
        (pipeline_scan_verified ?pipeline_run)
        (not
          (pipeline_has_open_findings ?pipeline_run)
        )
        (pipeline_assigned_dependency_scanner ?pipeline_run ?dependency_scanner)
        (pipeline_policy_evaluation_complete ?pipeline_run)
        (pipeline_assigned_team_reviewer ?pipeline_run ?team_reviewer)
        (not
          (pipeline_override_requested ?pipeline_run)
        )
      )
    :effect
      (and
        (pipeline_override_requested ?pipeline_run)
      )
  )
  (:action record_release_approval
    :parameters (?pipeline_run - pipeline_run ?release_target - release_target)
    :precondition
      (and
        (pipeline_resources_reserved ?pipeline_run)
        (pipeline_bound_to_release_target ?pipeline_run ?release_target)
        (not
          (pipeline_scan_verified ?pipeline_run)
        )
      )
    :effect
      (and
        (pipeline_scan_verified ?pipeline_run)
        (not
          (pipeline_has_open_findings ?pipeline_run)
        )
      )
  )
  (:action reserve_policy_check
    :parameters (?pipeline_run - pipeline_run ?policy_check - policy_check)
    :precondition
      (and
        (pipeline_policy_check_compatible ?pipeline_run ?policy_check)
        (pipeline_run_registered ?pipeline_run)
        (policy_check_available ?policy_check)
      )
    :effect
      (and
        (pipeline_assigned_policy_check ?pipeline_run ?policy_check)
        (not
          (policy_check_available ?policy_check)
        )
      )
  )
  (:action reserve_scanner_for_pipeline
    :parameters (?pipeline_run - pipeline_run ?dependency_scanner - dependency_scanner)
    :precondition
      (and
        (pipeline_run_registered ?pipeline_run)
        (dependency_scanner_available ?dependency_scanner)
        (pipeline_dependency_scanner_compatible ?pipeline_run ?dependency_scanner)
      )
    :effect
      (and
        (not
          (dependency_scanner_available ?dependency_scanner)
        )
        (pipeline_assigned_dependency_scanner ?pipeline_run ?dependency_scanner)
      )
  )
  (:action release_policy_check
    :parameters (?pipeline_run - pipeline_run ?policy_check - policy_check)
    :precondition
      (and
        (pipeline_assigned_policy_check ?pipeline_run ?policy_check)
      )
    :effect
      (and
        (policy_check_available ?policy_check)
        (not
          (pipeline_assigned_policy_check ?pipeline_run ?policy_check)
        )
      )
  )
  (:action release_reviewer
    :parameters (?pipeline_run - pipeline_run ?team_reviewer - team_reviewer)
    :precondition
      (and
        (pipeline_assigned_team_reviewer ?pipeline_run ?team_reviewer)
      )
    :effect
      (and
        (team_reviewer_available ?team_reviewer)
        (not
          (pipeline_assigned_team_reviewer ?pipeline_run ?team_reviewer)
        )
      )
  )
  (:action bind_release_target_after_override
    :parameters (?pipeline_run - pipeline_run ?release_target - release_target)
    :precondition
      (and
        (pipeline_override_credential_recorded ?pipeline_run)
        (release_target_available ?release_target)
        (pipeline_declared_release_target ?pipeline_run ?release_target)
      )
    :effect
      (and
        (feature_run_mapped_release_target ?pipeline_run ?release_target)
        (not
          (release_target_available ?release_target)
        )
      )
  )
  (:action reserve_reviewer_for_pipeline
    :parameters (?pipeline_run - pipeline_run ?team_reviewer - team_reviewer)
    :precondition
      (and
        (pipeline_run_registered ?pipeline_run)
        (team_reviewer_available ?team_reviewer)
        (pipeline_team_reviewer_compatible ?pipeline_run ?team_reviewer)
      )
    :effect
      (and
        (pipeline_assigned_team_reviewer ?pipeline_run ?team_reviewer)
        (not
          (team_reviewer_available ?team_reviewer)
        )
      )
  )
  (:action evaluate_policy_and_stage_findings
    :parameters (?pipeline_run - pipeline_run ?deployment_environment - deployment_environment ?dependency_scanner - dependency_scanner ?team_reviewer - team_reviewer)
    :precondition
      (and
        (pipeline_resources_reserved ?pipeline_run)
        (deployment_environment_available ?deployment_environment)
        (pipeline_deployment_environment_compatible ?pipeline_run ?deployment_environment)
        (not
          (pipeline_policy_evaluation_complete ?pipeline_run)
        )
        (pipeline_assigned_team_reviewer ?pipeline_run ?team_reviewer)
        (pipeline_assigned_dependency_scanner ?pipeline_run ?dependency_scanner)
      )
    :effect
      (and
        (pipeline_validated_for_environment ?pipeline_run ?deployment_environment)
        (not
          (deployment_environment_available ?deployment_environment)
        )
        (pipeline_policy_evaluation_complete ?pipeline_run)
      )
  )
  (:action approve_override_and_mark
    :parameters (?pipeline_run - pipeline_run ?dependency_scanner - dependency_scanner ?team_reviewer - team_reviewer)
    :precondition
      (and
        (pipeline_assigned_dependency_scanner ?pipeline_run ?dependency_scanner)
        (pipeline_override_requested ?pipeline_run)
        (pipeline_assigned_team_reviewer ?pipeline_run ?team_reviewer)
        (pipeline_has_open_findings ?pipeline_run)
      )
    :effect
      (and
        (not
          (pipeline_has_policy_findings ?pipeline_run)
        )
        (not
          (pipeline_has_open_findings ?pipeline_run)
        )
        (not
          (pipeline_scan_verified ?pipeline_run)
        )
        (pipeline_override_approved ?pipeline_run)
      )
  )
  (:action unassign_scan_profile
    :parameters (?pipeline_run - pipeline_run ?scan_profile - scan_profile)
    :precondition
      (and
        (pipeline_assigned_scan_profile ?pipeline_run ?scan_profile)
      )
    :effect
      (and
        (scan_profile_available ?scan_profile)
        (not
          (pipeline_assigned_scan_profile ?pipeline_run ?scan_profile)
        )
      )
  )
  (:action record_approver_credential
    :parameters (?pipeline_run - pipeline_run ?scan_profile - scan_profile ?approver_credential - approver_credential)
    :precondition
      (and
        (not
          (pipeline_scan_verified ?pipeline_run)
        )
        (pipeline_resources_reserved ?pipeline_run)
        (approver_credential_available ?approver_credential)
        (pipeline_assigned_scan_profile ?pipeline_run ?scan_profile)
        (pipeline_scan_initiated ?pipeline_run)
      )
    :effect
      (and
        (not
          (pipeline_has_open_findings ?pipeline_run)
        )
        (pipeline_scan_verified ?pipeline_run)
      )
  )
  (:action finalize_promotion_with_readiness
    :parameters (?pipeline_run - pipeline_run)
    :precondition
      (and
        (pipeline_run_registered ?pipeline_run)
        (is_release_branch_run ?pipeline_run)
        (pipeline_ready_for_promotion_checks ?pipeline_run)
        (pipeline_resources_reserved ?pipeline_run)
        (pipeline_scan_verified ?pipeline_run)
        (not
          (pipeline_eligible_for_promotion ?pipeline_run)
        )
        (pipeline_override_credential_recorded ?pipeline_run)
        (pipeline_policy_evaluation_complete ?pipeline_run)
        (pipeline_override_requested ?pipeline_run)
      )
    :effect
      (and
        (pipeline_eligible_for_promotion ?pipeline_run)
      )
  )
  (:action mark_pipeline_ready_for_promotion_checks
    :parameters (?pipeline_run - pipeline_run ?scan_profile - scan_profile ?approver_credential - approver_credential)
    :precondition
      (and
        (pipeline_scan_verified ?pipeline_run)
        (approver_credential_available ?approver_credential)
        (not
          (pipeline_ready_for_promotion_checks ?pipeline_run)
        )
        (pipeline_override_credential_recorded ?pipeline_run)
        (pipeline_run_registered ?pipeline_run)
        (is_release_branch_run ?pipeline_run)
        (pipeline_assigned_scan_profile ?pipeline_run ?scan_profile)
      )
    :effect
      (and
        (pipeline_ready_for_promotion_checks ?pipeline_run)
      )
  )
  (:action release_scanner
    :parameters (?pipeline_run - pipeline_run ?dependency_scanner - dependency_scanner)
    :precondition
      (and
        (pipeline_assigned_dependency_scanner ?pipeline_run ?dependency_scanner)
      )
    :effect
      (and
        (dependency_scanner_available ?dependency_scanner)
        (not
          (pipeline_assigned_dependency_scanner ?pipeline_run ?dependency_scanner)
        )
      )
  )
  (:action reserve_risk_descriptor
    :parameters (?pipeline_run - pipeline_run ?risk_descriptor - risk_descriptor)
    :precondition
      (and
        (risk_descriptor_available ?risk_descriptor)
        (pipeline_run_registered ?pipeline_run)
        (pipeline_risk_applicable ?pipeline_run ?risk_descriptor)
      )
    :effect
      (and
        (pipeline_has_risk_descriptor ?pipeline_run ?risk_descriptor)
        (not
          (risk_descriptor_available ?risk_descriptor)
        )
      )
  )
  (:action create_pipeline_run
    :parameters (?pipeline_run - pipeline_run)
    :precondition
      (and
        (not
          (pipeline_run_registered ?pipeline_run)
        )
        (not
          (pipeline_eligible_for_promotion ?pipeline_run)
        )
      )
    :effect
      (and
        (pipeline_run_registered ?pipeline_run)
      )
  )
  (:action assign_manual_approval
    :parameters (?pipeline_run - pipeline_run ?manual_approver - manual_approver)
    :precondition
      (and
        (not
          (pipeline_scan_initiated ?pipeline_run)
        )
        (pipeline_run_registered ?pipeline_run)
        (manual_approver_available ?manual_approver)
        (pipeline_resources_reserved ?pipeline_run)
      )
    :effect
      (and
        (pipeline_has_open_findings ?pipeline_run)
        (not
          (manual_approver_available ?manual_approver)
        )
        (pipeline_scan_initiated ?pipeline_run)
      )
  )
  (:action evaluate_policy_with_exception_and_risk
    :parameters (?pipeline_run - pipeline_run ?deployment_environment - deployment_environment ?policy_check - policy_check ?exception_document - exception_document)
    :precondition
      (and
        (exception_document_available ?exception_document)
        (pipeline_exception_applicable ?pipeline_run ?exception_document)
        (not
          (pipeline_policy_evaluation_complete ?pipeline_run)
        )
        (pipeline_resources_reserved ?pipeline_run)
        (deployment_environment_available ?deployment_environment)
        (pipeline_deployment_environment_compatible ?pipeline_run ?deployment_environment)
        (pipeline_assigned_policy_check ?pipeline_run ?policy_check)
      )
    :effect
      (and
        (pipeline_validated_for_environment ?pipeline_run ?deployment_environment)
        (not
          (exception_document_available ?exception_document)
        )
        (pipeline_has_policy_findings ?pipeline_run)
        (not
          (deployment_environment_available ?deployment_environment)
        )
        (pipeline_has_open_findings ?pipeline_run)
        (pipeline_policy_evaluation_complete ?pipeline_run)
      )
  )
  (:action record_manual_approver_adjudication
    :parameters (?pipeline_run - pipeline_run ?manual_approver - manual_approver)
    :precondition
      (and
        (manual_approver_available ?manual_approver)
        (not
          (pipeline_has_open_findings ?pipeline_run)
        )
        (pipeline_scan_verified ?pipeline_run)
        (pipeline_override_requested ?pipeline_run)
        (not
          (pipeline_override_credential_recorded ?pipeline_run)
        )
      )
    :effect
      (and
        (pipeline_override_credential_recorded ?pipeline_run)
        (not
          (manual_approver_available ?manual_approver)
        )
      )
  )
  (:action release_agent_and_resources
    :parameters (?pipeline_run - pipeline_run ?build_agent - build_agent)
    :precondition
      (and
        (pipeline_assigned_build_agent ?pipeline_run ?build_agent)
        (not
          (pipeline_override_requested ?pipeline_run)
        )
        (not
          (pipeline_policy_evaluation_complete ?pipeline_run)
        )
      )
    :effect
      (and
        (not
          (pipeline_assigned_build_agent ?pipeline_run ?build_agent)
        )
        (build_agent_available ?build_agent)
        (not
          (pipeline_resources_reserved ?pipeline_run)
        )
        (not
          (pipeline_scan_initiated ?pipeline_run)
        )
        (not
          (pipeline_override_approved ?pipeline_run)
        )
        (not
          (pipeline_scan_verified ?pipeline_run)
        )
        (not
          (pipeline_has_policy_findings ?pipeline_run)
        )
        (not
          (pipeline_has_open_findings ?pipeline_run)
        )
      )
  )
  (:action record_scan_profile_adjudication
    :parameters (?pipeline_run - pipeline_run ?scan_profile - scan_profile)
    :precondition
      (and
        (not
          (pipeline_override_credential_recorded ?pipeline_run)
        )
        (pipeline_assigned_scan_profile ?pipeline_run ?scan_profile)
        (pipeline_scan_verified ?pipeline_run)
        (pipeline_override_requested ?pipeline_run)
        (not
          (pipeline_has_open_findings ?pipeline_run)
        )
      )
    :effect
      (and
        (pipeline_override_credential_recorded ?pipeline_run)
      )
  )
  (:action finalize_promotion_with_release_target
    :parameters (?pipeline_run - pipeline_run ?release_target - release_target)
    :precondition
      (and
        (pipeline_override_credential_recorded ?pipeline_run)
        (pipeline_override_requested ?pipeline_run)
        (pipeline_policy_evaluation_complete ?pipeline_run)
        (pipeline_bound_to_release_target ?pipeline_run ?release_target)
        (pipeline_scan_verified ?pipeline_run)
        (pipeline_resources_reserved ?pipeline_run)
        (pipeline_run_registered ?pipeline_run)
        (not
          (pipeline_eligible_for_promotion ?pipeline_run)
        )
        (is_release_branch_run ?pipeline_run)
      )
    :effect
      (and
        (pipeline_eligible_for_promotion ?pipeline_run)
      )
  )
  (:action initiate_scan_with_profile
    :parameters (?pipeline_run - pipeline_run ?scan_profile - scan_profile)
    :precondition
      (and
        (pipeline_run_registered ?pipeline_run)
        (pipeline_resources_reserved ?pipeline_run)
        (not
          (pipeline_scan_initiated ?pipeline_run)
        )
        (pipeline_assigned_scan_profile ?pipeline_run ?scan_profile)
      )
    :effect
      (and
        (pipeline_scan_initiated ?pipeline_run)
      )
  )
  (:action reserve_agent_for_pipeline
    :parameters (?pipeline_run - pipeline_run ?build_agent - build_agent)
    :precondition
      (and
        (not
          (pipeline_resources_reserved ?pipeline_run)
        )
        (pipeline_run_registered ?pipeline_run)
        (build_agent_available ?build_agent)
        (pipeline_build_agent_compatible ?pipeline_run ?build_agent)
      )
    :effect
      (and
        (pipeline_resources_reserved ?pipeline_run)
        (not
          (build_agent_available ?build_agent)
        )
        (pipeline_assigned_build_agent ?pipeline_run ?build_agent)
      )
  )
  (:action reapply_scan_verification
    :parameters (?pipeline_run - pipeline_run ?scan_profile - scan_profile ?approver_credential - approver_credential)
    :precondition
      (and
        (pipeline_resources_reserved ?pipeline_run)
        (not
          (pipeline_scan_verified ?pipeline_run)
        )
        (pipeline_assigned_scan_profile ?pipeline_run ?scan_profile)
        (pipeline_override_requested ?pipeline_run)
        (approver_credential_available ?approver_credential)
        (pipeline_override_approved ?pipeline_run)
      )
    :effect
      (and
        (pipeline_scan_verified ?pipeline_run)
      )
  )
  (:action link_release_and_feature_runs_to_target
    :parameters (?release_branch_run - release_branch_run ?feature_branch_run - feature_branch_run ?release_target - release_target)
    :precondition
      (and
        (pipeline_run_registered ?release_branch_run)
        (feature_run_mapped_release_target ?feature_branch_run ?release_target)
        (is_release_branch_run ?release_branch_run)
        (not
          (pipeline_bound_to_release_target ?release_branch_run ?release_target)
        )
        (release_branch_run_declared_target ?release_branch_run ?release_target)
      )
    :effect
      (and
        (pipeline_bound_to_release_target ?release_branch_run ?release_target)
      )
  )
)

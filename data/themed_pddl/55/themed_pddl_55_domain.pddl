(define (domain cache_poisoning_safeguard_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types pipeline_run - object source_commit - object deployment_target - object build_configuration - object quality_gate - object security_scan - object cache_node - object human_reviewer - object promotion_policy - object operator_credential - object incident_ticket - object cache_artifact - object governance_group - object approver_role - governance_group approver_role_alt - governance_group staging_variant - pipeline_run production_variant - pipeline_run)
  (:predicates
    (available_human_reviewer ?human_reviewer - human_reviewer)
    (run_assigned_build_configuration ?pipeline_run - pipeline_run ?build_configuration - build_configuration)
    (promotion_ready ?pipeline_run - pipeline_run)
    (run_has_source_commit ?pipeline_run - pipeline_run ?source_commit - source_commit)
    (run_associated_governance_group ?pipeline_run - pipeline_run ?governance_group - governance_group)
    (available_security_scan ?security_scan - security_scan)
    (available_build_configuration ?build_configuration - build_configuration)
    (run_allowed_cache_artifact ?pipeline_run - pipeline_run ?cache_artifact - cache_artifact)
    (run_promoted ?pipeline_run - pipeline_run)
    (is_staging_variant ?pipeline_run - pipeline_run)
    (run_allowed_commit ?pipeline_run - pipeline_run ?source_commit - source_commit)
    (available_deployment_target ?deployment_target - deployment_target)
    (available_incident_ticket ?incident_ticket - incident_ticket)
    (available_cache_node ?cache_node - cache_node)
    (run_evaluation_passed ?pipeline_run - pipeline_run)
    (run_allowed_build_configuration ?pipeline_run - pipeline_run ?build_configuration - build_configuration)
    (run_assigned_cache_artifact ?pipeline_run - pipeline_run ?cache_artifact - cache_artifact)
    (run_target_deployment ?pipeline_run - pipeline_run ?deployment_target - deployment_target)
    (governance_authorized ?pipeline_run - pipeline_run)
    (run_allowed_security_scan ?pipeline_run - pipeline_run ?security_scan - security_scan)
    (available_cache_artifact ?cache_artifact - cache_artifact)
    (is_production_variant ?pipeline_run - pipeline_run)
    (safety_verified ?pipeline_run - pipeline_run)
    (run_allowed_quality_gate ?pipeline_run - pipeline_run ?quality_gate - quality_gate)
    (run_assigned_quality_gate ?pipeline_run - pipeline_run ?quality_gate - quality_gate)
    (requires_secondary_review ?pipeline_run - pipeline_run)
    (run_reserved_cache_node ?pipeline_run - pipeline_run ?cache_node - cache_node)
    (reverification_required ?pipeline_run - pipeline_run)
    (run_allowed_incident_ticket ?pipeline_run - pipeline_run ?incident_ticket - incident_ticket)
    (run_registered ?pipeline_run - pipeline_run)
    (available_source_commit ?source_commit - source_commit)
    (run_source_attached ?pipeline_run - pipeline_run)
    (available_operator_credential ?operator_credential - operator_credential)
    (available_promotion_policy ?promotion_policy - promotion_policy)
    (run_assigned_security_scan ?pipeline_run - pipeline_run ?security_scan - security_scan)
    (variant_bound_promotion_policy ?pipeline_run - pipeline_run ?promotion_policy - promotion_policy)
    (local_review_granted ?pipeline_run - pipeline_run)
    (review_checkpoint_claimed ?pipeline_run - pipeline_run)
    (variant_compatible_promotion_policy ?pipeline_run - pipeline_run ?promotion_policy - promotion_policy)
    (available_quality_gate ?quality_gate - quality_gate)
    (run_bound_promotion_policy ?pipeline_run - pipeline_run ?promotion_policy - promotion_policy)
    (run_allowed_deployment_target ?pipeline_run - pipeline_run ?deployment_target - deployment_target)
    (manual_attention_flag ?pipeline_run - pipeline_run)
    (policy_applied_to_run ?pipeline_run - pipeline_run ?promotion_policy - promotion_policy)
  )
  (:action release_cache_artifact_from_run
    :parameters (?pipeline_run - pipeline_run ?cache_artifact - cache_artifact)
    :precondition
      (and
        (run_assigned_cache_artifact ?pipeline_run ?cache_artifact)
      )
    :effect
      (and
        (available_cache_artifact ?cache_artifact)
        (not
          (run_assigned_cache_artifact ?pipeline_run ?cache_artifact)
        )
      )
  )
  (:action authorize_governance_with_security_and_approver
    :parameters (?pipeline_run - pipeline_run ?security_scan - security_scan ?cache_artifact - cache_artifact ?approver_role_alt - approver_role_alt)
    :precondition
      (and
        (not
          (governance_authorized ?pipeline_run)
        )
        (run_evaluation_passed ?pipeline_run)
        (safety_verified ?pipeline_run)
        (run_assigned_cache_artifact ?pipeline_run ?cache_artifact)
        (run_associated_governance_group ?pipeline_run ?approver_role_alt)
        (run_assigned_security_scan ?pipeline_run ?security_scan)
      )
    :effect
      (and
        (manual_attention_flag ?pipeline_run)
        (governance_authorized ?pipeline_run)
      )
  )
  (:action finalize_promotion_for_variant
    :parameters (?pipeline_run - pipeline_run)
    :precondition
      (and
        (safety_verified ?pipeline_run)
        (run_source_attached ?pipeline_run)
        (run_evaluation_passed ?pipeline_run)
        (run_registered ?pipeline_run)
        (review_checkpoint_claimed ?pipeline_run)
        (not
          (run_promoted ?pipeline_run)
        )
        (is_staging_variant ?pipeline_run)
        (governance_authorized ?pipeline_run)
      )
    :effect
      (and
        (run_promoted ?pipeline_run)
      )
  )
  (:action clear_secondary_flags_after_evaluation
    :parameters (?pipeline_run - pipeline_run ?quality_gate - quality_gate ?build_configuration - build_configuration)
    :precondition
      (and
        (run_evaluation_passed ?pipeline_run)
        (requires_secondary_review ?pipeline_run)
        (run_assigned_quality_gate ?pipeline_run ?quality_gate)
        (run_assigned_build_configuration ?pipeline_run ?build_configuration)
      )
    :effect
      (and
        (not
          (requires_secondary_review ?pipeline_run)
        )
        (not
          (manual_attention_flag ?pipeline_run)
        )
      )
  )
  (:action reserve_cache_node_for_run
    :parameters (?pipeline_run - pipeline_run ?cache_node - cache_node)
    :precondition
      (and
        (available_cache_node ?cache_node)
        (run_registered ?pipeline_run)
      )
    :effect
      (and
        (not
          (available_cache_node ?cache_node)
        )
        (run_reserved_cache_node ?pipeline_run ?cache_node)
      )
  )
  (:action require_governance_approval
    :parameters (?pipeline_run - pipeline_run ?quality_gate - quality_gate ?build_configuration - build_configuration ?approver_role - approver_role)
    :precondition
      (and
        (run_associated_governance_group ?pipeline_run ?approver_role)
        (safety_verified ?pipeline_run)
        (not
          (manual_attention_flag ?pipeline_run)
        )
        (run_assigned_quality_gate ?pipeline_run ?quality_gate)
        (run_evaluation_passed ?pipeline_run)
        (run_assigned_build_configuration ?pipeline_run ?build_configuration)
        (not
          (governance_authorized ?pipeline_run)
        )
      )
    :effect
      (and
        (governance_authorized ?pipeline_run)
      )
  )
  (:action verify_cache_via_policy
    :parameters (?pipeline_run - pipeline_run ?promotion_policy - promotion_policy)
    :precondition
      (and
        (run_source_attached ?pipeline_run)
        (policy_applied_to_run ?pipeline_run ?promotion_policy)
        (not
          (safety_verified ?pipeline_run)
        )
      )
    :effect
      (and
        (safety_verified ?pipeline_run)
        (not
          (manual_attention_flag ?pipeline_run)
        )
      )
  )
  (:action assign_security_scan_to_run
    :parameters (?pipeline_run - pipeline_run ?security_scan - security_scan)
    :precondition
      (and
        (run_allowed_security_scan ?pipeline_run ?security_scan)
        (run_registered ?pipeline_run)
        (available_security_scan ?security_scan)
      )
    :effect
      (and
        (run_assigned_security_scan ?pipeline_run ?security_scan)
        (not
          (available_security_scan ?security_scan)
        )
      )
  )
  (:action assign_quality_gate_to_run
    :parameters (?pipeline_run - pipeline_run ?quality_gate - quality_gate)
    :precondition
      (and
        (run_registered ?pipeline_run)
        (available_quality_gate ?quality_gate)
        (run_allowed_quality_gate ?pipeline_run ?quality_gate)
      )
    :effect
      (and
        (not
          (available_quality_gate ?quality_gate)
        )
        (run_assigned_quality_gate ?pipeline_run ?quality_gate)
      )
  )
  (:action release_security_scan_from_run
    :parameters (?pipeline_run - pipeline_run ?security_scan - security_scan)
    :precondition
      (and
        (run_assigned_security_scan ?pipeline_run ?security_scan)
      )
    :effect
      (and
        (available_security_scan ?security_scan)
        (not
          (run_assigned_security_scan ?pipeline_run ?security_scan)
        )
      )
  )
  (:action release_build_configuration_from_run
    :parameters (?pipeline_run - pipeline_run ?build_configuration - build_configuration)
    :precondition
      (and
        (run_assigned_build_configuration ?pipeline_run ?build_configuration)
      )
    :effect
      (and
        (available_build_configuration ?build_configuration)
        (not
          (run_assigned_build_configuration ?pipeline_run ?build_configuration)
        )
      )
  )
  (:action bind_promotion_policy_to_variant
    :parameters (?pipeline_run - pipeline_run ?promotion_policy - promotion_policy)
    :precondition
      (and
        (review_checkpoint_claimed ?pipeline_run)
        (available_promotion_policy ?promotion_policy)
        (variant_compatible_promotion_policy ?pipeline_run ?promotion_policy)
      )
    :effect
      (and
        (variant_bound_promotion_policy ?pipeline_run ?promotion_policy)
        (not
          (available_promotion_policy ?promotion_policy)
        )
      )
  )
  (:action assign_build_configuration_to_run
    :parameters (?pipeline_run - pipeline_run ?build_configuration - build_configuration)
    :precondition
      (and
        (run_registered ?pipeline_run)
        (available_build_configuration ?build_configuration)
        (run_allowed_build_configuration ?pipeline_run ?build_configuration)
      )
    :effect
      (and
        (run_assigned_build_configuration ?pipeline_run ?build_configuration)
        (not
          (available_build_configuration ?build_configuration)
        )
      )
  )
  (:action evaluate_target_with_quality_and_build
    :parameters (?pipeline_run - pipeline_run ?deployment_target - deployment_target ?quality_gate - quality_gate ?build_configuration - build_configuration)
    :precondition
      (and
        (run_source_attached ?pipeline_run)
        (available_deployment_target ?deployment_target)
        (run_allowed_deployment_target ?pipeline_run ?deployment_target)
        (not
          (run_evaluation_passed ?pipeline_run)
        )
        (run_assigned_build_configuration ?pipeline_run ?build_configuration)
        (run_assigned_quality_gate ?pipeline_run ?quality_gate)
      )
    :effect
      (and
        (run_target_deployment ?pipeline_run ?deployment_target)
        (not
          (available_deployment_target ?deployment_target)
        )
        (run_evaluation_passed ?pipeline_run)
      )
  )
  (:action mark_promotion_ready
    :parameters (?pipeline_run - pipeline_run ?quality_gate - quality_gate ?build_configuration - build_configuration)
    :precondition
      (and
        (run_assigned_quality_gate ?pipeline_run ?quality_gate)
        (governance_authorized ?pipeline_run)
        (run_assigned_build_configuration ?pipeline_run ?build_configuration)
        (manual_attention_flag ?pipeline_run)
      )
    :effect
      (and
        (not
          (requires_secondary_review ?pipeline_run)
        )
        (not
          (manual_attention_flag ?pipeline_run)
        )
        (not
          (safety_verified ?pipeline_run)
        )
        (promotion_ready ?pipeline_run)
      )
  )
  (:action release_cache_node_from_run
    :parameters (?pipeline_run - pipeline_run ?cache_node - cache_node)
    :precondition
      (and
        (run_reserved_cache_node ?pipeline_run ?cache_node)
      )
    :effect
      (and
        (available_cache_node ?cache_node)
        (not
          (run_reserved_cache_node ?pipeline_run ?cache_node)
        )
      )
  )
  (:action operator_verify_cache_with_credential
    :parameters (?pipeline_run - pipeline_run ?cache_node - cache_node ?operator_credential - operator_credential)
    :precondition
      (and
        (not
          (safety_verified ?pipeline_run)
        )
        (run_source_attached ?pipeline_run)
        (available_operator_credential ?operator_credential)
        (run_reserved_cache_node ?pipeline_run ?cache_node)
        (local_review_granted ?pipeline_run)
      )
    :effect
      (and
        (not
          (manual_attention_flag ?pipeline_run)
        )
        (safety_verified ?pipeline_run)
      )
  )
  (:action finalize_promotion_after_reverification
    :parameters (?pipeline_run - pipeline_run)
    :precondition
      (and
        (run_registered ?pipeline_run)
        (is_production_variant ?pipeline_run)
        (reverification_required ?pipeline_run)
        (run_source_attached ?pipeline_run)
        (safety_verified ?pipeline_run)
        (not
          (run_promoted ?pipeline_run)
        )
        (review_checkpoint_claimed ?pipeline_run)
        (run_evaluation_passed ?pipeline_run)
        (governance_authorized ?pipeline_run)
      )
    :effect
      (and
        (run_promoted ?pipeline_run)
      )
  )
  (:action mark_reverification_required
    :parameters (?pipeline_run - pipeline_run ?cache_node - cache_node ?operator_credential - operator_credential)
    :precondition
      (and
        (safety_verified ?pipeline_run)
        (available_operator_credential ?operator_credential)
        (not
          (reverification_required ?pipeline_run)
        )
        (review_checkpoint_claimed ?pipeline_run)
        (run_registered ?pipeline_run)
        (is_production_variant ?pipeline_run)
        (run_reserved_cache_node ?pipeline_run ?cache_node)
      )
    :effect
      (and
        (reverification_required ?pipeline_run)
      )
  )
  (:action release_quality_gate_from_run
    :parameters (?pipeline_run - pipeline_run ?quality_gate - quality_gate)
    :precondition
      (and
        (run_assigned_quality_gate ?pipeline_run ?quality_gate)
      )
    :effect
      (and
        (available_quality_gate ?quality_gate)
        (not
          (run_assigned_quality_gate ?pipeline_run ?quality_gate)
        )
      )
  )
  (:action assign_cache_artifact_to_run
    :parameters (?pipeline_run - pipeline_run ?cache_artifact - cache_artifact)
    :precondition
      (and
        (available_cache_artifact ?cache_artifact)
        (run_registered ?pipeline_run)
        (run_allowed_cache_artifact ?pipeline_run ?cache_artifact)
      )
    :effect
      (and
        (run_assigned_cache_artifact ?pipeline_run ?cache_artifact)
        (not
          (available_cache_artifact ?cache_artifact)
        )
      )
  )
  (:action initialize_pipeline_run
    :parameters (?pipeline_run - pipeline_run)
    :precondition
      (and
        (not
          (run_registered ?pipeline_run)
        )
        (not
          (run_promoted ?pipeline_run)
        )
      )
    :effect
      (and
        (run_registered ?pipeline_run)
      )
  )
  (:action grant_local_review_by_reviewer
    :parameters (?pipeline_run - pipeline_run ?human_reviewer - human_reviewer)
    :precondition
      (and
        (not
          (local_review_granted ?pipeline_run)
        )
        (run_registered ?pipeline_run)
        (available_human_reviewer ?human_reviewer)
        (run_source_attached ?pipeline_run)
      )
    :effect
      (and
        (manual_attention_flag ?pipeline_run)
        (not
          (available_human_reviewer ?human_reviewer)
        )
        (local_review_granted ?pipeline_run)
      )
  )
  (:action evaluate_target_with_security_and_incident
    :parameters (?pipeline_run - pipeline_run ?deployment_target - deployment_target ?security_scan - security_scan ?incident_ticket - incident_ticket)
    :precondition
      (and
        (available_incident_ticket ?incident_ticket)
        (run_allowed_incident_ticket ?pipeline_run ?incident_ticket)
        (not
          (run_evaluation_passed ?pipeline_run)
        )
        (run_source_attached ?pipeline_run)
        (available_deployment_target ?deployment_target)
        (run_allowed_deployment_target ?pipeline_run ?deployment_target)
        (run_assigned_security_scan ?pipeline_run ?security_scan)
      )
    :effect
      (and
        (run_target_deployment ?pipeline_run ?deployment_target)
        (not
          (available_incident_ticket ?incident_ticket)
        )
        (requires_secondary_review ?pipeline_run)
        (not
          (available_deployment_target ?deployment_target)
        )
        (manual_attention_flag ?pipeline_run)
        (run_evaluation_passed ?pipeline_run)
      )
  )
  (:action claim_reviewer_checkpoint_by_human
    :parameters (?pipeline_run - pipeline_run ?human_reviewer - human_reviewer)
    :precondition
      (and
        (available_human_reviewer ?human_reviewer)
        (not
          (manual_attention_flag ?pipeline_run)
        )
        (safety_verified ?pipeline_run)
        (governance_authorized ?pipeline_run)
        (not
          (review_checkpoint_claimed ?pipeline_run)
        )
      )
    :effect
      (and
        (review_checkpoint_claimed ?pipeline_run)
        (not
          (available_human_reviewer ?human_reviewer)
        )
      )
  )
  (:action unbind_source_commit_from_run
    :parameters (?pipeline_run - pipeline_run ?source_commit - source_commit)
    :precondition
      (and
        (run_has_source_commit ?pipeline_run ?source_commit)
        (not
          (governance_authorized ?pipeline_run)
        )
        (not
          (run_evaluation_passed ?pipeline_run)
        )
      )
    :effect
      (and
        (not
          (run_has_source_commit ?pipeline_run ?source_commit)
        )
        (available_source_commit ?source_commit)
        (not
          (run_source_attached ?pipeline_run)
        )
        (not
          (local_review_granted ?pipeline_run)
        )
        (not
          (promotion_ready ?pipeline_run)
        )
        (not
          (safety_verified ?pipeline_run)
        )
        (not
          (requires_secondary_review ?pipeline_run)
        )
        (not
          (manual_attention_flag ?pipeline_run)
        )
      )
  )
  (:action claim_reviewer_checkpoint
    :parameters (?pipeline_run - pipeline_run ?cache_node - cache_node)
    :precondition
      (and
        (not
          (review_checkpoint_claimed ?pipeline_run)
        )
        (run_reserved_cache_node ?pipeline_run ?cache_node)
        (safety_verified ?pipeline_run)
        (governance_authorized ?pipeline_run)
        (not
          (manual_attention_flag ?pipeline_run)
        )
      )
    :effect
      (and
        (review_checkpoint_claimed ?pipeline_run)
      )
  )
  (:action finalize_promotion_with_policy
    :parameters (?pipeline_run - pipeline_run ?promotion_policy - promotion_policy)
    :precondition
      (and
        (review_checkpoint_claimed ?pipeline_run)
        (governance_authorized ?pipeline_run)
        (run_evaluation_passed ?pipeline_run)
        (policy_applied_to_run ?pipeline_run ?promotion_policy)
        (safety_verified ?pipeline_run)
        (run_source_attached ?pipeline_run)
        (run_registered ?pipeline_run)
        (not
          (run_promoted ?pipeline_run)
        )
        (is_production_variant ?pipeline_run)
      )
    :effect
      (and
        (run_promoted ?pipeline_run)
      )
  )
  (:action grant_local_review
    :parameters (?pipeline_run - pipeline_run ?cache_node - cache_node)
    :precondition
      (and
        (run_registered ?pipeline_run)
        (run_source_attached ?pipeline_run)
        (not
          (local_review_granted ?pipeline_run)
        )
        (run_reserved_cache_node ?pipeline_run ?cache_node)
      )
    :effect
      (and
        (local_review_granted ?pipeline_run)
      )
  )
  (:action bind_source_commit_to_run
    :parameters (?pipeline_run - pipeline_run ?source_commit - source_commit)
    :precondition
      (and
        (not
          (run_source_attached ?pipeline_run)
        )
        (run_registered ?pipeline_run)
        (available_source_commit ?source_commit)
        (run_allowed_commit ?pipeline_run ?source_commit)
      )
    :effect
      (and
        (run_source_attached ?pipeline_run)
        (not
          (available_source_commit ?source_commit)
        )
        (run_has_source_commit ?pipeline_run ?source_commit)
      )
  )
  (:action reverify_with_operator_credential
    :parameters (?pipeline_run - pipeline_run ?cache_node - cache_node ?operator_credential - operator_credential)
    :precondition
      (and
        (run_source_attached ?pipeline_run)
        (not
          (safety_verified ?pipeline_run)
        )
        (run_reserved_cache_node ?pipeline_run ?cache_node)
        (governance_authorized ?pipeline_run)
        (available_operator_credential ?operator_credential)
        (promotion_ready ?pipeline_run)
      )
    :effect
      (and
        (safety_verified ?pipeline_run)
      )
  )
  (:action apply_promotion_policy_between_variants
    :parameters (?production_variant - production_variant ?staging_variant - staging_variant ?promotion_policy - promotion_policy)
    :precondition
      (and
        (run_registered ?production_variant)
        (variant_bound_promotion_policy ?staging_variant ?promotion_policy)
        (is_production_variant ?production_variant)
        (not
          (policy_applied_to_run ?production_variant ?promotion_policy)
        )
        (run_bound_promotion_policy ?production_variant ?promotion_policy)
      )
    :effect
      (and
        (policy_applied_to_run ?production_variant ?promotion_policy)
      )
  )
)

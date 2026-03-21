(define (domain build_ci_capacity_rebalance_governance)
  (:requirements :strips :typing :negative-preconditions)
  (:types rebalance_workflow - object build_agent - object promotion_stage - object security_control - object capacity_profile - object node_group - object agent_pool - object credential_token - object build_artifact - object approver - object compliance_check - object capability_tag - object quota_reference - object quota_class - quota_reference quota_instance - quota_reference rebalancer_workflow - rebalance_workflow governance_workflow - rebalance_workflow)
  (:predicates
    (workflow_registered ?workflow - rebalance_workflow)
    (workflow_allocated_agent ?workflow - rebalance_workflow ?agent - build_agent)
    (workflow_has_allocation ?workflow - rebalance_workflow)
    (workflow_prepared ?workflow - rebalance_workflow)
    (workflow_checks_passed ?workflow - rebalance_workflow)
    (workflow_bound_capacity_profile ?workflow - rebalance_workflow ?capacity_profile - capacity_profile)
    (workflow_bound_security_control ?workflow - rebalance_workflow ?security_control - security_control)
    (workflow_bound_node_group ?workflow - rebalance_workflow ?node_group - node_group)
    (workflow_bound_capability_tag ?workflow - rebalance_workflow ?capability_tag - capability_tag)
    (workflow_assigned_stage ?workflow - rebalance_workflow ?stage - promotion_stage)
    (workflow_stage_locked ?workflow - rebalance_workflow)
    (workflow_ready_for_finalization ?workflow - rebalance_workflow)
    (workflow_reservation_confirmed ?workflow - rebalance_workflow)
    (workflow_completed ?workflow - rebalance_workflow)
    (workflow_requires_manual_approval ?workflow - rebalance_workflow)
    (workflow_finalized ?workflow - rebalance_workflow)
    (workflow_bound_artifact ?workflow - rebalance_workflow ?build_artifact - build_artifact)
    (workflow_artifact_approved ?workflow - rebalance_workflow ?build_artifact - build_artifact)
    (workflow_ready_for_completion ?workflow - rebalance_workflow)
    (agent_available ?agent - build_agent)
    (stage_available ?stage - promotion_stage)
    (capacity_profile_available ?capacity_profile - capacity_profile)
    (security_control_available ?security_control - security_control)
    (node_group_available ?node_group - node_group)
    (agent_pool_available ?agent_pool - agent_pool)
    (credential_token_available ?credential_token - credential_token)
    (artifact_available ?build_artifact - build_artifact)
    (approver_available ?approver - approver)
    (compliance_check_available ?compliance_check - compliance_check)
    (capability_tag_available ?capability_tag - capability_tag)
    (workflow_agent_compatible ?workflow - rebalance_workflow ?agent - build_agent)
    (workflow_stage_compatible ?workflow - rebalance_workflow ?stage - promotion_stage)
    (workflow_capacity_profile_compatible ?workflow - rebalance_workflow ?capacity_profile - capacity_profile)
    (workflow_security_control_compatible ?workflow - rebalance_workflow ?security_control - security_control)
    (workflow_node_group_compatible ?workflow - rebalance_workflow ?node_group - node_group)
    (workflow_compliance_check_compatible ?workflow - rebalance_workflow ?compliance_check - compliance_check)
    (workflow_capability_tag_compatible ?workflow - rebalance_workflow ?capability_tag - capability_tag)
    (workflow_quota_reference ?workflow - rebalance_workflow ?quota_reference - quota_reference)
    (rebalancer_artifact_compatible ?rebalancer - rebalance_workflow ?build_artifact - build_artifact)
    (workflow_eligible_for_completion ?workflow - rebalance_workflow)
    (workflow_governance_attached ?workflow - rebalance_workflow)
    (workflow_bound_pool ?workflow - rebalance_workflow ?agent_pool - agent_pool)
    (workflow_requires_quota_adjustment ?workflow - rebalance_workflow)
    (workflow_artifact_delegation ?rebalancer - rebalance_workflow ?build_artifact - build_artifact)
  )
  (:action create_rebalance_workflow
    :parameters (?workflow - rebalance_workflow)
    :precondition
      (and
        (not
          (workflow_registered ?workflow)
        )
        (not
          (workflow_completed ?workflow)
        )
      )
    :effect
      (and
        (workflow_registered ?workflow)
      )
  )
  (:action assign_agent_to_workflow
    :parameters (?workflow - rebalance_workflow ?agent - build_agent)
    :precondition
      (and
        (workflow_registered ?workflow)
        (agent_available ?agent)
        (workflow_agent_compatible ?workflow ?agent)
        (not
          (workflow_has_allocation ?workflow)
        )
      )
    :effect
      (and
        (workflow_allocated_agent ?workflow ?agent)
        (workflow_has_allocation ?workflow)
        (not
          (agent_available ?agent)
        )
      )
  )
  (:action release_agent_from_workflow
    :parameters (?workflow - rebalance_workflow ?agent - build_agent)
    :precondition
      (and
        (workflow_allocated_agent ?workflow ?agent)
        (not
          (workflow_stage_locked ?workflow)
        )
        (not
          (workflow_ready_for_finalization ?workflow)
        )
      )
    :effect
      (and
        (not
          (workflow_allocated_agent ?workflow ?agent)
        )
        (not
          (workflow_has_allocation ?workflow)
        )
        (not
          (workflow_prepared ?workflow)
        )
        (not
          (workflow_checks_passed ?workflow)
        )
        (not
          (workflow_requires_manual_approval ?workflow)
        )
        (not
          (workflow_finalized ?workflow)
        )
        (not
          (workflow_requires_quota_adjustment ?workflow)
        )
        (agent_available ?agent)
      )
  )
  (:action attach_agent_pool_to_workflow
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool)
    :precondition
      (and
        (workflow_registered ?workflow)
        (agent_pool_available ?agent_pool)
      )
    :effect
      (and
        (workflow_bound_pool ?workflow ?agent_pool)
        (not
          (agent_pool_available ?agent_pool)
        )
      )
  )
  (:action detach_agent_pool_from_workflow
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool)
    :precondition
      (and
        (workflow_bound_pool ?workflow ?agent_pool)
      )
    :effect
      (and
        (agent_pool_available ?agent_pool)
        (not
          (workflow_bound_pool ?workflow ?agent_pool)
        )
      )
  )
  (:action reserve_pool_capacity_for_workflow
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool)
    :precondition
      (and
        (workflow_registered ?workflow)
        (workflow_has_allocation ?workflow)
        (workflow_bound_pool ?workflow ?agent_pool)
        (not
          (workflow_prepared ?workflow)
        )
      )
    :effect
      (and
        (workflow_prepared ?workflow)
      )
  )
  (:action apply_credential_token_to_workflow
    :parameters (?workflow - rebalance_workflow ?credential_token - credential_token)
    :precondition
      (and
        (workflow_registered ?workflow)
        (workflow_has_allocation ?workflow)
        (credential_token_available ?credential_token)
        (not
          (workflow_prepared ?workflow)
        )
      )
    :effect
      (and
        (workflow_prepared ?workflow)
        (workflow_requires_manual_approval ?workflow)
        (not
          (credential_token_available ?credential_token)
        )
      )
  )
  (:action approver_approve_pool_binding
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool ?approver - approver)
    :precondition
      (and
        (workflow_prepared ?workflow)
        (workflow_has_allocation ?workflow)
        (workflow_bound_pool ?workflow ?agent_pool)
        (approver_available ?approver)
        (not
          (workflow_checks_passed ?workflow)
        )
      )
    :effect
      (and
        (workflow_checks_passed ?workflow)
        (not
          (workflow_requires_manual_approval ?workflow)
        )
      )
  )
  (:action approver_approve_artifact_binding
    :parameters (?workflow - rebalance_workflow ?build_artifact - build_artifact)
    :precondition
      (and
        (workflow_has_allocation ?workflow)
        (workflow_artifact_approved ?workflow ?build_artifact)
        (not
          (workflow_checks_passed ?workflow)
        )
      )
    :effect
      (and
        (workflow_checks_passed ?workflow)
        (not
          (workflow_requires_manual_approval ?workflow)
        )
      )
  )
  (:action bind_capacity_profile_to_workflow
    :parameters (?workflow - rebalance_workflow ?capacity_profile - capacity_profile)
    :precondition
      (and
        (workflow_registered ?workflow)
        (capacity_profile_available ?capacity_profile)
        (workflow_capacity_profile_compatible ?workflow ?capacity_profile)
      )
    :effect
      (and
        (workflow_bound_capacity_profile ?workflow ?capacity_profile)
        (not
          (capacity_profile_available ?capacity_profile)
        )
      )
  )
  (:action unbind_capacity_profile_from_workflow
    :parameters (?workflow - rebalance_workflow ?capacity_profile - capacity_profile)
    :precondition
      (and
        (workflow_bound_capacity_profile ?workflow ?capacity_profile)
      )
    :effect
      (and
        (capacity_profile_available ?capacity_profile)
        (not
          (workflow_bound_capacity_profile ?workflow ?capacity_profile)
        )
      )
  )
  (:action bind_security_control_to_workflow
    :parameters (?workflow - rebalance_workflow ?security_control - security_control)
    :precondition
      (and
        (workflow_registered ?workflow)
        (security_control_available ?security_control)
        (workflow_security_control_compatible ?workflow ?security_control)
      )
    :effect
      (and
        (workflow_bound_security_control ?workflow ?security_control)
        (not
          (security_control_available ?security_control)
        )
      )
  )
  (:action unbind_security_control_from_workflow
    :parameters (?workflow - rebalance_workflow ?security_control - security_control)
    :precondition
      (and
        (workflow_bound_security_control ?workflow ?security_control)
      )
    :effect
      (and
        (security_control_available ?security_control)
        (not
          (workflow_bound_security_control ?workflow ?security_control)
        )
      )
  )
  (:action bind_node_group_to_workflow
    :parameters (?workflow - rebalance_workflow ?node_group - node_group)
    :precondition
      (and
        (workflow_registered ?workflow)
        (node_group_available ?node_group)
        (workflow_node_group_compatible ?workflow ?node_group)
      )
    :effect
      (and
        (workflow_bound_node_group ?workflow ?node_group)
        (not
          (node_group_available ?node_group)
        )
      )
  )
  (:action unbind_node_group_from_workflow
    :parameters (?workflow - rebalance_workflow ?node_group - node_group)
    :precondition
      (and
        (workflow_bound_node_group ?workflow ?node_group)
      )
    :effect
      (and
        (node_group_available ?node_group)
        (not
          (workflow_bound_node_group ?workflow ?node_group)
        )
      )
  )
  (:action bind_capability_tag_to_workflow
    :parameters (?workflow - rebalance_workflow ?capability_tag - capability_tag)
    :precondition
      (and
        (workflow_registered ?workflow)
        (capability_tag_available ?capability_tag)
        (workflow_capability_tag_compatible ?workflow ?capability_tag)
      )
    :effect
      (and
        (workflow_bound_capability_tag ?workflow ?capability_tag)
        (not
          (capability_tag_available ?capability_tag)
        )
      )
  )
  (:action unbind_capability_tag_from_workflow
    :parameters (?workflow - rebalance_workflow ?capability_tag - capability_tag)
    :precondition
      (and
        (workflow_bound_capability_tag ?workflow ?capability_tag)
      )
    :effect
      (and
        (capability_tag_available ?capability_tag)
        (not
          (workflow_bound_capability_tag ?workflow ?capability_tag)
        )
      )
  )
  (:action promote_workflow_with_checks
    :parameters (?workflow - rebalance_workflow ?stage - promotion_stage ?capacity_profile - capacity_profile ?security_control - security_control)
    :precondition
      (and
        (workflow_has_allocation ?workflow)
        (workflow_bound_capacity_profile ?workflow ?capacity_profile)
        (workflow_bound_security_control ?workflow ?security_control)
        (stage_available ?stage)
        (workflow_stage_compatible ?workflow ?stage)
        (not
          (workflow_stage_locked ?workflow)
        )
      )
    :effect
      (and
        (workflow_assigned_stage ?workflow ?stage)
        (workflow_stage_locked ?workflow)
        (not
          (stage_available ?stage)
        )
      )
  )
  (:action promote_workflow_with_compliance
    :parameters (?workflow - rebalance_workflow ?stage - promotion_stage ?node_group - node_group ?compliance_check - compliance_check)
    :precondition
      (and
        (workflow_has_allocation ?workflow)
        (workflow_bound_node_group ?workflow ?node_group)
        (compliance_check_available ?compliance_check)
        (stage_available ?stage)
        (workflow_stage_compatible ?workflow ?stage)
        (workflow_compliance_check_compatible ?workflow ?compliance_check)
        (not
          (workflow_stage_locked ?workflow)
        )
      )
    :effect
      (and
        (workflow_assigned_stage ?workflow ?stage)
        (workflow_stage_locked ?workflow)
        (workflow_requires_quota_adjustment ?workflow)
        (workflow_requires_manual_approval ?workflow)
        (not
          (stage_available ?stage)
        )
        (not
          (compliance_check_available ?compliance_check)
        )
      )
  )
  (:action clear_quota_adjustment_flag
    :parameters (?workflow - rebalance_workflow ?capacity_profile - capacity_profile ?security_control - security_control)
    :precondition
      (and
        (workflow_stage_locked ?workflow)
        (workflow_requires_quota_adjustment ?workflow)
        (workflow_bound_capacity_profile ?workflow ?capacity_profile)
        (workflow_bound_security_control ?workflow ?security_control)
      )
    :effect
      (and
        (not
          (workflow_requires_quota_adjustment ?workflow)
        )
        (not
          (workflow_requires_manual_approval ?workflow)
        )
      )
  )
  (:action request_finalization
    :parameters (?workflow - rebalance_workflow ?capacity_profile - capacity_profile ?security_control - security_control ?quota_class - quota_class)
    :precondition
      (and
        (workflow_checks_passed ?workflow)
        (workflow_stage_locked ?workflow)
        (workflow_bound_capacity_profile ?workflow ?capacity_profile)
        (workflow_bound_security_control ?workflow ?security_control)
        (workflow_quota_reference ?workflow ?quota_class)
        (not
          (workflow_requires_manual_approval ?workflow)
        )
        (not
          (workflow_ready_for_finalization ?workflow)
        )
      )
    :effect
      (and
        (workflow_ready_for_finalization ?workflow)
      )
  )
  (:action request_finalization_with_quota_instance
    :parameters (?workflow - rebalance_workflow ?node_group - node_group ?capability_tag - capability_tag ?quota_instance - quota_instance)
    :precondition
      (and
        (workflow_checks_passed ?workflow)
        (workflow_stage_locked ?workflow)
        (workflow_bound_node_group ?workflow ?node_group)
        (workflow_bound_capability_tag ?workflow ?capability_tag)
        (workflow_quota_reference ?workflow ?quota_instance)
        (not
          (workflow_ready_for_finalization ?workflow)
        )
      )
    :effect
      (and
        (workflow_ready_for_finalization ?workflow)
        (workflow_requires_manual_approval ?workflow)
      )
  )
  (:action apply_finalization
    :parameters (?workflow - rebalance_workflow ?capacity_profile - capacity_profile ?security_control - security_control)
    :precondition
      (and
        (workflow_ready_for_finalization ?workflow)
        (workflow_requires_manual_approval ?workflow)
        (workflow_bound_capacity_profile ?workflow ?capacity_profile)
        (workflow_bound_security_control ?workflow ?security_control)
      )
    :effect
      (and
        (workflow_finalized ?workflow)
        (not
          (workflow_requires_manual_approval ?workflow)
        )
        (not
          (workflow_checks_passed ?workflow)
        )
        (not
          (workflow_requires_quota_adjustment ?workflow)
        )
      )
  )
  (:action reserve_pool_with_approver
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool ?approver - approver)
    :precondition
      (and
        (workflow_finalized ?workflow)
        (workflow_ready_for_finalization ?workflow)
        (workflow_has_allocation ?workflow)
        (workflow_bound_pool ?workflow ?agent_pool)
        (approver_available ?approver)
        (not
          (workflow_checks_passed ?workflow)
        )
      )
    :effect
      (and
        (workflow_checks_passed ?workflow)
      )
  )
  (:action confirm_pool_reservation
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool)
    :precondition
      (and
        (workflow_ready_for_finalization ?workflow)
        (workflow_checks_passed ?workflow)
        (not
          (workflow_requires_manual_approval ?workflow)
        )
        (workflow_bound_pool ?workflow ?agent_pool)
        (not
          (workflow_reservation_confirmed ?workflow)
        )
      )
    :effect
      (and
        (workflow_reservation_confirmed ?workflow)
      )
  )
  (:action confirm_credential_token
    :parameters (?workflow - rebalance_workflow ?credential_token - credential_token)
    :precondition
      (and
        (workflow_ready_for_finalization ?workflow)
        (workflow_checks_passed ?workflow)
        (not
          (workflow_requires_manual_approval ?workflow)
        )
        (credential_token_available ?credential_token)
        (not
          (workflow_reservation_confirmed ?workflow)
        )
      )
    :effect
      (and
        (workflow_reservation_confirmed ?workflow)
        (not
          (credential_token_available ?credential_token)
        )
      )
  )
  (:action bind_artifact_to_workflow
    :parameters (?workflow - rebalance_workflow ?build_artifact - build_artifact)
    :precondition
      (and
        (workflow_reservation_confirmed ?workflow)
        (artifact_available ?build_artifact)
        (workflow_artifact_delegation ?workflow ?build_artifact)
      )
    :effect
      (and
        (rebalancer_artifact_compatible ?workflow ?build_artifact)
        (not
          (artifact_available ?build_artifact)
        )
      )
  )
  (:action governance_approve_artifact_for_rebalancer
    :parameters (?governance_agent - governance_workflow ?rebalancer - rebalancer_workflow ?build_artifact - build_artifact)
    :precondition
      (and
        (workflow_registered ?governance_agent)
        (workflow_governance_attached ?governance_agent)
        (workflow_bound_artifact ?governance_agent ?build_artifact)
        (rebalancer_artifact_compatible ?rebalancer ?build_artifact)
        (not
          (workflow_artifact_approved ?governance_agent ?build_artifact)
        )
      )
    :effect
      (and
        (workflow_artifact_approved ?governance_agent ?build_artifact)
      )
  )
  (:action record_operational_readiness
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool ?approver - approver)
    :precondition
      (and
        (workflow_registered ?workflow)
        (workflow_governance_attached ?workflow)
        (workflow_checks_passed ?workflow)
        (workflow_reservation_confirmed ?workflow)
        (workflow_bound_pool ?workflow ?agent_pool)
        (approver_available ?approver)
        (not
          (workflow_ready_for_completion ?workflow)
        )
      )
    :effect
      (and
        (workflow_ready_for_completion ?workflow)
      )
  )
  (:action complete_workflow_if_eligible
    :parameters (?workflow - rebalance_workflow)
    :precondition
      (and
        (workflow_eligible_for_completion ?workflow)
        (workflow_registered ?workflow)
        (workflow_has_allocation ?workflow)
        (workflow_stage_locked ?workflow)
        (workflow_ready_for_finalization ?workflow)
        (workflow_reservation_confirmed ?workflow)
        (workflow_checks_passed ?workflow)
        (not
          (workflow_completed ?workflow)
        )
      )
    :effect
      (and
        (workflow_completed ?workflow)
      )
  )
  (:action complete_workflow_with_artifact_approval
    :parameters (?workflow - rebalance_workflow ?build_artifact - build_artifact)
    :precondition
      (and
        (workflow_governance_attached ?workflow)
        (workflow_registered ?workflow)
        (workflow_has_allocation ?workflow)
        (workflow_stage_locked ?workflow)
        (workflow_ready_for_finalization ?workflow)
        (workflow_reservation_confirmed ?workflow)
        (workflow_checks_passed ?workflow)
        (workflow_artifact_approved ?workflow ?build_artifact)
        (not
          (workflow_completed ?workflow)
        )
      )
    :effect
      (and
        (workflow_completed ?workflow)
      )
  )
  (:action complete_workflow_with_operational_readiness
    :parameters (?workflow - rebalance_workflow)
    :precondition
      (and
        (workflow_governance_attached ?workflow)
        (workflow_registered ?workflow)
        (workflow_has_allocation ?workflow)
        (workflow_stage_locked ?workflow)
        (workflow_ready_for_finalization ?workflow)
        (workflow_reservation_confirmed ?workflow)
        (workflow_checks_passed ?workflow)
        (workflow_ready_for_completion ?workflow)
        (not
          (workflow_completed ?workflow)
        )
      )
    :effect
      (and
        (workflow_completed ?workflow)
      )
  )
)

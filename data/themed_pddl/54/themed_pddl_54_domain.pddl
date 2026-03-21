(define (domain build_ci_capacity_rebalance_governance)
  (:requirements :strips :typing :negative-preconditions)
  (:types rebalance_workflow - object build_agent - object promotion_stage - object security_control - object capacity_profile - object node_group - object agent_pool - object credential_token - object build_artifact - object approver - object compliance_check - object capability_tag - object quota_reference - object quota_class - quota_reference quota_instance - quota_reference rebalancer_workflow - rebalance_workflow governance_workflow - rebalance_workflow)
  (:predicates
    (credential_token_available ?credential_token - credential_token)
    (workflow_bound_security_control ?workflow - rebalance_workflow ?security_control - security_control)
    (workflow_finalized ?workflow - rebalance_workflow)
    (workflow_allocated_agent ?workflow - rebalance_workflow ?agent - build_agent)
    (workflow_quota_reference ?workflow - rebalance_workflow ?quota_reference - quota_reference)
    (node_group_available ?node_group - node_group)
    (security_control_available ?security_control - security_control)
    (workflow_capability_tag_compatible ?workflow - rebalance_workflow ?capability_tag - capability_tag)
    (workflow_completed ?workflow - rebalance_workflow)
    (workflow_eligible_for_completion ?workflow - rebalance_workflow)
    (workflow_agent_compatible ?workflow - rebalance_workflow ?agent - build_agent)
    (stage_available ?stage - promotion_stage)
    (compliance_check_available ?compliance_check - compliance_check)
    (agent_pool_available ?agent_pool - agent_pool)
    (workflow_stage_locked ?workflow - rebalance_workflow)
    (workflow_security_control_compatible ?workflow - rebalance_workflow ?security_control - security_control)
    (workflow_bound_capability_tag ?workflow - rebalance_workflow ?capability_tag - capability_tag)
    (workflow_assigned_stage ?workflow - rebalance_workflow ?stage - promotion_stage)
    (workflow_ready_for_finalization ?workflow - rebalance_workflow)
    (workflow_node_group_compatible ?workflow - rebalance_workflow ?node_group - node_group)
    (capability_tag_available ?capability_tag - capability_tag)
    (workflow_governance_attached ?workflow - rebalance_workflow)
    (workflow_checks_passed ?workflow - rebalance_workflow)
    (workflow_capacity_profile_compatible ?workflow - rebalance_workflow ?capacity_profile - capacity_profile)
    (workflow_bound_capacity_profile ?workflow - rebalance_workflow ?capacity_profile - capacity_profile)
    (workflow_requires_quota_adjustment ?workflow - rebalance_workflow)
    (workflow_bound_pool ?workflow - rebalance_workflow ?agent_pool - agent_pool)
    (workflow_ready_for_completion ?workflow - rebalance_workflow)
    (workflow_compliance_check_compatible ?workflow - rebalance_workflow ?compliance_check - compliance_check)
    (workflow_registered ?workflow - rebalance_workflow)
    (agent_available ?agent - build_agent)
    (workflow_has_allocation ?workflow - rebalance_workflow)
    (approver_available ?approver - approver)
    (artifact_available ?build_artifact - build_artifact)
    (workflow_bound_node_group ?workflow - rebalance_workflow ?node_group - node_group)
    (rebalancer_artifact_compatible ?rebalancer - rebalance_workflow ?build_artifact - build_artifact)
    (workflow_prepared ?workflow - rebalance_workflow)
    (workflow_reservation_confirmed ?workflow - rebalance_workflow)
    (workflow_artifact_delegation ?rebalancer - rebalance_workflow ?build_artifact - build_artifact)
    (capacity_profile_available ?capacity_profile - capacity_profile)
    (workflow_bound_artifact ?workflow - rebalance_workflow ?build_artifact - build_artifact)
    (workflow_stage_compatible ?workflow - rebalance_workflow ?stage - promotion_stage)
    (workflow_requires_manual_approval ?workflow - rebalance_workflow)
    (workflow_artifact_approved ?workflow - rebalance_workflow ?build_artifact - build_artifact)
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
  (:action request_finalization_with_quota_instance
    :parameters (?workflow - rebalance_workflow ?node_group - node_group ?capability_tag - capability_tag ?quota_instance - quota_instance)
    :precondition
      (and
        (not
          (workflow_ready_for_finalization ?workflow)
        )
        (workflow_stage_locked ?workflow)
        (workflow_checks_passed ?workflow)
        (workflow_bound_capability_tag ?workflow ?capability_tag)
        (workflow_quota_reference ?workflow ?quota_instance)
        (workflow_bound_node_group ?workflow ?node_group)
      )
    :effect
      (and
        (workflow_requires_manual_approval ?workflow)
        (workflow_ready_for_finalization ?workflow)
      )
  )
  (:action complete_workflow_if_eligible
    :parameters (?workflow - rebalance_workflow)
    :precondition
      (and
        (workflow_checks_passed ?workflow)
        (workflow_has_allocation ?workflow)
        (workflow_stage_locked ?workflow)
        (workflow_registered ?workflow)
        (workflow_reservation_confirmed ?workflow)
        (not
          (workflow_completed ?workflow)
        )
        (workflow_eligible_for_completion ?workflow)
        (workflow_ready_for_finalization ?workflow)
      )
    :effect
      (and
        (workflow_completed ?workflow)
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
  (:action attach_agent_pool_to_workflow
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool)
    :precondition
      (and
        (agent_pool_available ?agent_pool)
        (workflow_registered ?workflow)
      )
    :effect
      (and
        (not
          (agent_pool_available ?agent_pool)
        )
        (workflow_bound_pool ?workflow ?agent_pool)
      )
  )
  (:action request_finalization
    :parameters (?workflow - rebalance_workflow ?capacity_profile - capacity_profile ?security_control - security_control ?quota_class - quota_class)
    :precondition
      (and
        (workflow_quota_reference ?workflow ?quota_class)
        (workflow_checks_passed ?workflow)
        (not
          (workflow_requires_manual_approval ?workflow)
        )
        (workflow_bound_capacity_profile ?workflow ?capacity_profile)
        (workflow_stage_locked ?workflow)
        (workflow_bound_security_control ?workflow ?security_control)
        (not
          (workflow_ready_for_finalization ?workflow)
        )
      )
    :effect
      (and
        (workflow_ready_for_finalization ?workflow)
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
  (:action bind_node_group_to_workflow
    :parameters (?workflow - rebalance_workflow ?node_group - node_group)
    :precondition
      (and
        (workflow_node_group_compatible ?workflow ?node_group)
        (workflow_registered ?workflow)
        (node_group_available ?node_group)
      )
    :effect
      (and
        (workflow_bound_node_group ?workflow ?node_group)
        (not
          (node_group_available ?node_group)
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
        (not
          (capacity_profile_available ?capacity_profile)
        )
        (workflow_bound_capacity_profile ?workflow ?capacity_profile)
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
  (:action promote_workflow_with_checks
    :parameters (?workflow - rebalance_workflow ?stage - promotion_stage ?capacity_profile - capacity_profile ?security_control - security_control)
    :precondition
      (and
        (workflow_has_allocation ?workflow)
        (stage_available ?stage)
        (workflow_stage_compatible ?workflow ?stage)
        (not
          (workflow_stage_locked ?workflow)
        )
        (workflow_bound_security_control ?workflow ?security_control)
        (workflow_bound_capacity_profile ?workflow ?capacity_profile)
      )
    :effect
      (and
        (workflow_assigned_stage ?workflow ?stage)
        (not
          (stage_available ?stage)
        )
        (workflow_stage_locked ?workflow)
      )
  )
  (:action apply_finalization
    :parameters (?workflow - rebalance_workflow ?capacity_profile - capacity_profile ?security_control - security_control)
    :precondition
      (and
        (workflow_bound_capacity_profile ?workflow ?capacity_profile)
        (workflow_ready_for_finalization ?workflow)
        (workflow_bound_security_control ?workflow ?security_control)
        (workflow_requires_manual_approval ?workflow)
      )
    :effect
      (and
        (not
          (workflow_requires_quota_adjustment ?workflow)
        )
        (not
          (workflow_requires_manual_approval ?workflow)
        )
        (not
          (workflow_checks_passed ?workflow)
        )
        (workflow_finalized ?workflow)
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
  (:action approver_approve_pool_binding
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool ?approver - approver)
    :precondition
      (and
        (not
          (workflow_checks_passed ?workflow)
        )
        (workflow_has_allocation ?workflow)
        (approver_available ?approver)
        (workflow_bound_pool ?workflow ?agent_pool)
        (workflow_prepared ?workflow)
      )
    :effect
      (and
        (not
          (workflow_requires_manual_approval ?workflow)
        )
        (workflow_checks_passed ?workflow)
      )
  )
  (:action complete_workflow_with_operational_readiness
    :parameters (?workflow - rebalance_workflow)
    :precondition
      (and
        (workflow_registered ?workflow)
        (workflow_governance_attached ?workflow)
        (workflow_ready_for_completion ?workflow)
        (workflow_has_allocation ?workflow)
        (workflow_checks_passed ?workflow)
        (not
          (workflow_completed ?workflow)
        )
        (workflow_reservation_confirmed ?workflow)
        (workflow_stage_locked ?workflow)
        (workflow_ready_for_finalization ?workflow)
      )
    :effect
      (and
        (workflow_completed ?workflow)
      )
  )
  (:action record_operational_readiness
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool ?approver - approver)
    :precondition
      (and
        (workflow_checks_passed ?workflow)
        (approver_available ?approver)
        (not
          (workflow_ready_for_completion ?workflow)
        )
        (workflow_reservation_confirmed ?workflow)
        (workflow_registered ?workflow)
        (workflow_governance_attached ?workflow)
        (workflow_bound_pool ?workflow ?agent_pool)
      )
    :effect
      (and
        (workflow_ready_for_completion ?workflow)
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
  (:action bind_capability_tag_to_workflow
    :parameters (?workflow - rebalance_workflow ?capability_tag - capability_tag)
    :precondition
      (and
        (capability_tag_available ?capability_tag)
        (workflow_registered ?workflow)
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
  (:action apply_credential_token_to_workflow
    :parameters (?workflow - rebalance_workflow ?credential_token - credential_token)
    :precondition
      (and
        (not
          (workflow_prepared ?workflow)
        )
        (workflow_registered ?workflow)
        (credential_token_available ?credential_token)
        (workflow_has_allocation ?workflow)
      )
    :effect
      (and
        (workflow_requires_manual_approval ?workflow)
        (not
          (credential_token_available ?credential_token)
        )
        (workflow_prepared ?workflow)
      )
  )
  (:action promote_workflow_with_compliance
    :parameters (?workflow - rebalance_workflow ?stage - promotion_stage ?node_group - node_group ?compliance_check - compliance_check)
    :precondition
      (and
        (compliance_check_available ?compliance_check)
        (workflow_compliance_check_compatible ?workflow ?compliance_check)
        (not
          (workflow_stage_locked ?workflow)
        )
        (workflow_has_allocation ?workflow)
        (stage_available ?stage)
        (workflow_stage_compatible ?workflow ?stage)
        (workflow_bound_node_group ?workflow ?node_group)
      )
    :effect
      (and
        (workflow_assigned_stage ?workflow ?stage)
        (not
          (compliance_check_available ?compliance_check)
        )
        (workflow_requires_quota_adjustment ?workflow)
        (not
          (stage_available ?stage)
        )
        (workflow_requires_manual_approval ?workflow)
        (workflow_stage_locked ?workflow)
      )
  )
  (:action confirm_credential_token
    :parameters (?workflow - rebalance_workflow ?credential_token - credential_token)
    :precondition
      (and
        (credential_token_available ?credential_token)
        (not
          (workflow_requires_manual_approval ?workflow)
        )
        (workflow_checks_passed ?workflow)
        (workflow_ready_for_finalization ?workflow)
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
  (:action release_agent_from_workflow
    :parameters (?workflow - rebalance_workflow ?agent - build_agent)
    :precondition
      (and
        (workflow_allocated_agent ?workflow ?agent)
        (not
          (workflow_ready_for_finalization ?workflow)
        )
        (not
          (workflow_stage_locked ?workflow)
        )
      )
    :effect
      (and
        (not
          (workflow_allocated_agent ?workflow ?agent)
        )
        (agent_available ?agent)
        (not
          (workflow_has_allocation ?workflow)
        )
        (not
          (workflow_prepared ?workflow)
        )
        (not
          (workflow_finalized ?workflow)
        )
        (not
          (workflow_checks_passed ?workflow)
        )
        (not
          (workflow_requires_quota_adjustment ?workflow)
        )
        (not
          (workflow_requires_manual_approval ?workflow)
        )
      )
  )
  (:action confirm_pool_reservation
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool)
    :precondition
      (and
        (not
          (workflow_reservation_confirmed ?workflow)
        )
        (workflow_bound_pool ?workflow ?agent_pool)
        (workflow_checks_passed ?workflow)
        (workflow_ready_for_finalization ?workflow)
        (not
          (workflow_requires_manual_approval ?workflow)
        )
      )
    :effect
      (and
        (workflow_reservation_confirmed ?workflow)
      )
  )
  (:action complete_workflow_with_artifact_approval
    :parameters (?workflow - rebalance_workflow ?build_artifact - build_artifact)
    :precondition
      (and
        (workflow_reservation_confirmed ?workflow)
        (workflow_ready_for_finalization ?workflow)
        (workflow_stage_locked ?workflow)
        (workflow_artifact_approved ?workflow ?build_artifact)
        (workflow_checks_passed ?workflow)
        (workflow_has_allocation ?workflow)
        (workflow_registered ?workflow)
        (not
          (workflow_completed ?workflow)
        )
        (workflow_governance_attached ?workflow)
      )
    :effect
      (and
        (workflow_completed ?workflow)
      )
  )
  (:action reserve_pool_capacity_for_workflow
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool)
    :precondition
      (and
        (workflow_registered ?workflow)
        (workflow_has_allocation ?workflow)
        (not
          (workflow_prepared ?workflow)
        )
        (workflow_bound_pool ?workflow ?agent_pool)
      )
    :effect
      (and
        (workflow_prepared ?workflow)
      )
  )
  (:action assign_agent_to_workflow
    :parameters (?workflow - rebalance_workflow ?agent - build_agent)
    :precondition
      (and
        (not
          (workflow_has_allocation ?workflow)
        )
        (workflow_registered ?workflow)
        (agent_available ?agent)
        (workflow_agent_compatible ?workflow ?agent)
      )
    :effect
      (and
        (workflow_has_allocation ?workflow)
        (not
          (agent_available ?agent)
        )
        (workflow_allocated_agent ?workflow ?agent)
      )
  )
  (:action reserve_pool_with_approver
    :parameters (?workflow - rebalance_workflow ?agent_pool - agent_pool ?approver - approver)
    :precondition
      (and
        (workflow_has_allocation ?workflow)
        (not
          (workflow_checks_passed ?workflow)
        )
        (workflow_bound_pool ?workflow ?agent_pool)
        (workflow_ready_for_finalization ?workflow)
        (approver_available ?approver)
        (workflow_finalized ?workflow)
      )
    :effect
      (and
        (workflow_checks_passed ?workflow)
      )
  )
  (:action governance_approve_artifact_for_rebalancer
    :parameters (?governance_agent - governance_workflow ?rebalancer - rebalancer_workflow ?build_artifact - build_artifact)
    :precondition
      (and
        (workflow_registered ?governance_agent)
        (rebalancer_artifact_compatible ?rebalancer ?build_artifact)
        (workflow_governance_attached ?governance_agent)
        (not
          (workflow_artifact_approved ?governance_agent ?build_artifact)
        )
        (workflow_bound_artifact ?governance_agent ?build_artifact)
      )
    :effect
      (and
        (workflow_artifact_approved ?governance_agent ?build_artifact)
      )
  )
)

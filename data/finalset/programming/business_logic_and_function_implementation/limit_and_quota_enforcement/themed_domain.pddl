(define (domain quota_enforcement)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object resource_class - domain_object feature_class - domain_object metric_class - domain_object subject_root - domain_object quota_subject - subject_root quota_slot - resource_class usage_metric - resource_class operator_token - resource_class proposal_bundle - resource_class policy_attachment - resource_class validation_credential - resource_class allocation_rule - resource_class policy_tag - resource_class credit_unit - feature_class capability_flag - feature_class assignment_tag - feature_class metric_key - metric_class metric_dimension - metric_class quota_bucket - metric_class subject_group - quota_subject enforcer_group - quota_subject tenant_scope - subject_group project_scope - subject_group enforcement_agent - enforcer_group)

  (:predicates
    (subject_registered ?subject - quota_subject)
    (subject_initialized ?subject - quota_subject)
    (subject_has_slot ?subject - quota_subject)
    (enforcement_applied ?subject - quota_subject)
    (evaluation_ready ?subject - quota_subject)
    (validation_confirmed ?subject - quota_subject)
    (slot_available ?quota_slot - quota_slot)
    (subject_slot_binding ?subject - quota_subject ?quota_slot - quota_slot)
    (metric_available ?usage_metric - usage_metric)
    (subject_metric_binding ?subject - quota_subject ?usage_metric - usage_metric)
    (operator_token_available ?operator_token - operator_token)
    (subject_operator_binding ?subject - quota_subject ?operator_token - operator_token)
    (credit_available ?credit_unit - credit_unit)
    (tenant_credit_binding ?tenant - tenant_scope ?credit_unit - credit_unit)
    (project_credit_binding ?project - project_scope ?credit_unit - credit_unit)
    (scope_metric_key_association ?tenant - tenant_scope ?metric_key - metric_key)
    (metric_key_primary_ready ?metric_key - metric_key)
    (metric_key_secondary_ready ?metric_key - metric_key)
    (tenant_ready_for_bucket ?tenant - tenant_scope)
    (project_metric_dimension_association ?project - project_scope ?metric_dimension - metric_dimension)
    (metric_dimension_primary_ready ?metric_dimension - metric_dimension)
    (metric_dimension_secondary_ready ?metric_dimension - metric_dimension)
    (project_ready_for_bucket ?project - project_scope)
    (bucket_pending ?quota_bucket - quota_bucket)
    (bucket_allocated ?quota_bucket - quota_bucket)
    (bucket_metric_key_binding ?quota_bucket - quota_bucket ?metric_key - metric_key)
    (bucket_metric_dimension_binding ?quota_bucket - quota_bucket ?metric_dimension - metric_dimension)
    (bucket_feature_flag_1 ?quota_bucket - quota_bucket)
    (bucket_feature_flag_2 ?quota_bucket - quota_bucket)
    (bucket_active ?quota_bucket - quota_bucket)
    (enforcer_tenant_association ?enforcer - enforcement_agent ?tenant - tenant_scope)
    (enforcer_project_association ?enforcer - enforcement_agent ?project - project_scope)
    (enforcer_bucket_association ?enforcer - enforcement_agent ?quota_bucket - quota_bucket)
    (capability_flag_available ?capability_flag - capability_flag)
    (enforcer_capability_binding ?enforcer - enforcement_agent ?capability_flag - capability_flag)
    (capability_flag_bound ?capability_flag - capability_flag)
    (capability_flag_bucket_binding ?capability_flag - capability_flag ?quota_bucket - quota_bucket)
    (enforcer_capability_bound ?enforcer - enforcement_agent)
    (enforcer_capability_verified ?enforcer - enforcement_agent)
    (enforcer_ready ?enforcer - enforcement_agent)
    (enforcer_proposal_bundle_attached ?enforcer - enforcement_agent)
    (enforcer_stage_committed ?enforcer - enforcement_agent)
    (enforcer_eligibility_flag ?enforcer - enforcement_agent)
    (enforcer_finalized ?enforcer - enforcement_agent)
    (assignment_tag_available ?assignment_tag - assignment_tag)
    (enforcer_assignment_tag_binding ?enforcer - enforcement_agent ?assignment_tag - assignment_tag)
    (enforcer_assigned_flag ?enforcer - enforcement_agent)
    (enforcer_assignment_committed ?enforcer - enforcement_agent)
    (enforcer_report_ready ?enforcer - enforcement_agent)
    (proposal_bundle_available ?proposal_bundle - proposal_bundle)
    (enforcer_proposal_bundle_binding ?enforcer - enforcement_agent ?proposal_bundle - proposal_bundle)
    (policy_attachment_available ?policy_attachment - policy_attachment)
    (enforcer_policy_attached ?enforcer - enforcement_agent ?policy_attachment - policy_attachment)
    (allocation_rule_available ?allocation_rule - allocation_rule)
    (enforcer_allocation_rule_binding ?enforcer - enforcement_agent ?allocation_rule - allocation_rule)
    (policy_tag_available ?policy_tag - policy_tag)
    (enforcer_policy_tag_binding ?enforcer - enforcement_agent ?policy_tag - policy_tag)
    (validation_credential_available ?validation_credential - validation_credential)
    (subject_validation_binding ?subject - quota_subject ?validation_credential - validation_credential)
    (tenant_evaluation_gate ?tenant - tenant_scope)
    (project_evaluation_gate ?project - project_scope)
    (enforcer_eligibility_token ?enforcer - enforcement_agent)
  )
  (:action register_quota_subject
    :parameters (?subject - quota_subject)
    :precondition
      (and
        (not
          (subject_registered ?subject)
        )
        (not
          (enforcement_applied ?subject)
        )
      )
    :effect (subject_registered ?subject)
  )
  (:action bind_quota_slot_to_subject
    :parameters (?subject - quota_subject ?quota_slot - quota_slot)
    :precondition
      (and
        (subject_registered ?subject)
        (not
          (subject_has_slot ?subject)
        )
        (slot_available ?quota_slot)
      )
    :effect
      (and
        (subject_has_slot ?subject)
        (subject_slot_binding ?subject ?quota_slot)
        (not
          (slot_available ?quota_slot)
        )
      )
  )
  (:action attach_usage_metric_to_subject
    :parameters (?subject - quota_subject ?usage_metric - usage_metric)
    :precondition
      (and
        (subject_registered ?subject)
        (subject_has_slot ?subject)
        (metric_available ?usage_metric)
      )
    :effect
      (and
        (subject_metric_binding ?subject ?usage_metric)
        (not
          (metric_available ?usage_metric)
        )
      )
  )
  (:action initialize_quota_subject
    :parameters (?subject - quota_subject ?usage_metric - usage_metric)
    :precondition
      (and
        (subject_registered ?subject)
        (subject_has_slot ?subject)
        (subject_metric_binding ?subject ?usage_metric)
        (not
          (subject_initialized ?subject)
        )
      )
    :effect (subject_initialized ?subject)
  )
  (:action release_usage_metric_from_subject
    :parameters (?subject - quota_subject ?usage_metric - usage_metric)
    :precondition
      (and
        (subject_metric_binding ?subject ?usage_metric)
      )
    :effect
      (and
        (metric_available ?usage_metric)
        (not
          (subject_metric_binding ?subject ?usage_metric)
        )
      )
  )
  (:action attach_operator_to_subject
    :parameters (?subject - quota_subject ?operator_token - operator_token)
    :precondition
      (and
        (subject_initialized ?subject)
        (operator_token_available ?operator_token)
      )
    :effect
      (and
        (subject_operator_binding ?subject ?operator_token)
        (not
          (operator_token_available ?operator_token)
        )
      )
  )
  (:action detach_operator_from_subject
    :parameters (?subject - quota_subject ?operator_token - operator_token)
    :precondition
      (and
        (subject_operator_binding ?subject ?operator_token)
      )
    :effect
      (and
        (operator_token_available ?operator_token)
        (not
          (subject_operator_binding ?subject ?operator_token)
        )
      )
  )
  (:action attach_allocation_rule_to_enforcer
    :parameters (?enforcer - enforcement_agent ?allocation_rule - allocation_rule)
    :precondition
      (and
        (subject_initialized ?enforcer)
        (allocation_rule_available ?allocation_rule)
      )
    :effect
      (and
        (enforcer_allocation_rule_binding ?enforcer ?allocation_rule)
        (not
          (allocation_rule_available ?allocation_rule)
        )
      )
  )
  (:action detach_allocation_rule_from_enforcer
    :parameters (?enforcer - enforcement_agent ?allocation_rule - allocation_rule)
    :precondition
      (and
        (enforcer_allocation_rule_binding ?enforcer ?allocation_rule)
      )
    :effect
      (and
        (allocation_rule_available ?allocation_rule)
        (not
          (enforcer_allocation_rule_binding ?enforcer ?allocation_rule)
        )
      )
  )
  (:action attach_policy_tag_to_enforcer
    :parameters (?enforcer - enforcement_agent ?policy_tag - policy_tag)
    :precondition
      (and
        (subject_initialized ?enforcer)
        (policy_tag_available ?policy_tag)
      )
    :effect
      (and
        (enforcer_policy_tag_binding ?enforcer ?policy_tag)
        (not
          (policy_tag_available ?policy_tag)
        )
      )
  )
  (:action detach_policy_tag_from_enforcer
    :parameters (?enforcer - enforcement_agent ?policy_tag - policy_tag)
    :precondition
      (and
        (enforcer_policy_tag_binding ?enforcer ?policy_tag)
      )
    :effect
      (and
        (policy_tag_available ?policy_tag)
        (not
          (enforcer_policy_tag_binding ?enforcer ?policy_tag)
        )
      )
  )
  (:action evaluate_metric_key_primary_for_tenant
    :parameters (?tenant - tenant_scope ?metric_key - metric_key ?usage_metric - usage_metric)
    :precondition
      (and
        (subject_initialized ?tenant)
        (subject_metric_binding ?tenant ?usage_metric)
        (scope_metric_key_association ?tenant ?metric_key)
        (not
          (metric_key_primary_ready ?metric_key)
        )
        (not
          (metric_key_secondary_ready ?metric_key)
        )
      )
    :effect (metric_key_primary_ready ?metric_key)
  )
  (:action prepare_tenant_for_bucket_allocation
    :parameters (?tenant - tenant_scope ?metric_key - metric_key ?operator_token - operator_token)
    :precondition
      (and
        (subject_initialized ?tenant)
        (subject_operator_binding ?tenant ?operator_token)
        (scope_metric_key_association ?tenant ?metric_key)
        (metric_key_primary_ready ?metric_key)
        (not
          (tenant_evaluation_gate ?tenant)
        )
      )
    :effect
      (and
        (tenant_evaluation_gate ?tenant)
        (tenant_ready_for_bucket ?tenant)
      )
  )
  (:action allocate_credit_to_tenant_for_metric
    :parameters (?tenant - tenant_scope ?metric_key - metric_key ?credit_unit - credit_unit)
    :precondition
      (and
        (subject_initialized ?tenant)
        (scope_metric_key_association ?tenant ?metric_key)
        (credit_available ?credit_unit)
        (not
          (tenant_evaluation_gate ?tenant)
        )
      )
    :effect
      (and
        (metric_key_secondary_ready ?metric_key)
        (tenant_evaluation_gate ?tenant)
        (tenant_credit_binding ?tenant ?credit_unit)
        (not
          (credit_available ?credit_unit)
        )
      )
  )
  (:action complete_tenant_metric_evaluation
    :parameters (?tenant - tenant_scope ?metric_key - metric_key ?usage_metric - usage_metric ?credit_unit - credit_unit)
    :precondition
      (and
        (subject_initialized ?tenant)
        (subject_metric_binding ?tenant ?usage_metric)
        (scope_metric_key_association ?tenant ?metric_key)
        (metric_key_secondary_ready ?metric_key)
        (tenant_credit_binding ?tenant ?credit_unit)
        (not
          (tenant_ready_for_bucket ?tenant)
        )
      )
    :effect
      (and
        (metric_key_primary_ready ?metric_key)
        (tenant_ready_for_bucket ?tenant)
        (credit_available ?credit_unit)
        (not
          (tenant_credit_binding ?tenant ?credit_unit)
        )
      )
  )
  (:action evaluate_metric_dimension_primary_for_project
    :parameters (?project - project_scope ?metric_dimension - metric_dimension ?usage_metric - usage_metric)
    :precondition
      (and
        (subject_initialized ?project)
        (subject_metric_binding ?project ?usage_metric)
        (project_metric_dimension_association ?project ?metric_dimension)
        (not
          (metric_dimension_primary_ready ?metric_dimension)
        )
        (not
          (metric_dimension_secondary_ready ?metric_dimension)
        )
      )
    :effect (metric_dimension_primary_ready ?metric_dimension)
  )
  (:action prepare_project_for_bucket_allocation
    :parameters (?project - project_scope ?metric_dimension - metric_dimension ?operator_token - operator_token)
    :precondition
      (and
        (subject_initialized ?project)
        (subject_operator_binding ?project ?operator_token)
        (project_metric_dimension_association ?project ?metric_dimension)
        (metric_dimension_primary_ready ?metric_dimension)
        (not
          (project_evaluation_gate ?project)
        )
      )
    :effect
      (and
        (project_evaluation_gate ?project)
        (project_ready_for_bucket ?project)
      )
  )
  (:action allocate_credit_to_project_for_metric
    :parameters (?project - project_scope ?metric_dimension - metric_dimension ?credit_unit - credit_unit)
    :precondition
      (and
        (subject_initialized ?project)
        (project_metric_dimension_association ?project ?metric_dimension)
        (credit_available ?credit_unit)
        (not
          (project_evaluation_gate ?project)
        )
      )
    :effect
      (and
        (metric_dimension_secondary_ready ?metric_dimension)
        (project_evaluation_gate ?project)
        (project_credit_binding ?project ?credit_unit)
        (not
          (credit_available ?credit_unit)
        )
      )
  )
  (:action complete_project_metric_evaluation
    :parameters (?project - project_scope ?metric_dimension - metric_dimension ?usage_metric - usage_metric ?credit_unit - credit_unit)
    :precondition
      (and
        (subject_initialized ?project)
        (subject_metric_binding ?project ?usage_metric)
        (project_metric_dimension_association ?project ?metric_dimension)
        (metric_dimension_secondary_ready ?metric_dimension)
        (project_credit_binding ?project ?credit_unit)
        (not
          (project_ready_for_bucket ?project)
        )
      )
    :effect
      (and
        (metric_dimension_primary_ready ?metric_dimension)
        (project_ready_for_bucket ?project)
        (credit_available ?credit_unit)
        (not
          (project_credit_binding ?project ?credit_unit)
        )
      )
  )
  (:action allocate_quota_bucket
    :parameters (?tenant - tenant_scope ?project - project_scope ?metric_key - metric_key ?metric_dimension - metric_dimension ?quota_bucket - quota_bucket)
    :precondition
      (and
        (tenant_evaluation_gate ?tenant)
        (project_evaluation_gate ?project)
        (scope_metric_key_association ?tenant ?metric_key)
        (project_metric_dimension_association ?project ?metric_dimension)
        (metric_key_primary_ready ?metric_key)
        (metric_dimension_primary_ready ?metric_dimension)
        (tenant_ready_for_bucket ?tenant)
        (project_ready_for_bucket ?project)
        (bucket_pending ?quota_bucket)
      )
    :effect
      (and
        (bucket_allocated ?quota_bucket)
        (bucket_metric_key_binding ?quota_bucket ?metric_key)
        (bucket_metric_dimension_binding ?quota_bucket ?metric_dimension)
        (not
          (bucket_pending ?quota_bucket)
        )
      )
  )
  (:action allocate_quota_bucket_with_feature_flag_1
    :parameters (?tenant - tenant_scope ?project - project_scope ?metric_key - metric_key ?metric_dimension - metric_dimension ?quota_bucket - quota_bucket)
    :precondition
      (and
        (tenant_evaluation_gate ?tenant)
        (project_evaluation_gate ?project)
        (scope_metric_key_association ?tenant ?metric_key)
        (project_metric_dimension_association ?project ?metric_dimension)
        (metric_key_secondary_ready ?metric_key)
        (metric_dimension_primary_ready ?metric_dimension)
        (not
          (tenant_ready_for_bucket ?tenant)
        )
        (project_ready_for_bucket ?project)
        (bucket_pending ?quota_bucket)
      )
    :effect
      (and
        (bucket_allocated ?quota_bucket)
        (bucket_metric_key_binding ?quota_bucket ?metric_key)
        (bucket_metric_dimension_binding ?quota_bucket ?metric_dimension)
        (bucket_feature_flag_1 ?quota_bucket)
        (not
          (bucket_pending ?quota_bucket)
        )
      )
  )
  (:action allocate_quota_bucket_with_feature_flag_2
    :parameters (?tenant - tenant_scope ?project - project_scope ?metric_key - metric_key ?metric_dimension - metric_dimension ?quota_bucket - quota_bucket)
    :precondition
      (and
        (tenant_evaluation_gate ?tenant)
        (project_evaluation_gate ?project)
        (scope_metric_key_association ?tenant ?metric_key)
        (project_metric_dimension_association ?project ?metric_dimension)
        (metric_key_primary_ready ?metric_key)
        (metric_dimension_secondary_ready ?metric_dimension)
        (tenant_ready_for_bucket ?tenant)
        (not
          (project_ready_for_bucket ?project)
        )
        (bucket_pending ?quota_bucket)
      )
    :effect
      (and
        (bucket_allocated ?quota_bucket)
        (bucket_metric_key_binding ?quota_bucket ?metric_key)
        (bucket_metric_dimension_binding ?quota_bucket ?metric_dimension)
        (bucket_feature_flag_2 ?quota_bucket)
        (not
          (bucket_pending ?quota_bucket)
        )
      )
  )
  (:action allocate_quota_bucket_with_both_feature_flags
    :parameters (?tenant - tenant_scope ?project - project_scope ?metric_key - metric_key ?metric_dimension - metric_dimension ?quota_bucket - quota_bucket)
    :precondition
      (and
        (tenant_evaluation_gate ?tenant)
        (project_evaluation_gate ?project)
        (scope_metric_key_association ?tenant ?metric_key)
        (project_metric_dimension_association ?project ?metric_dimension)
        (metric_key_secondary_ready ?metric_key)
        (metric_dimension_secondary_ready ?metric_dimension)
        (not
          (tenant_ready_for_bucket ?tenant)
        )
        (not
          (project_ready_for_bucket ?project)
        )
        (bucket_pending ?quota_bucket)
      )
    :effect
      (and
        (bucket_allocated ?quota_bucket)
        (bucket_metric_key_binding ?quota_bucket ?metric_key)
        (bucket_metric_dimension_binding ?quota_bucket ?metric_dimension)
        (bucket_feature_flag_1 ?quota_bucket)
        (bucket_feature_flag_2 ?quota_bucket)
        (not
          (bucket_pending ?quota_bucket)
        )
      )
  )
  (:action activate_quota_bucket
    :parameters (?quota_bucket - quota_bucket ?tenant - tenant_scope ?usage_metric - usage_metric)
    :precondition
      (and
        (bucket_allocated ?quota_bucket)
        (tenant_evaluation_gate ?tenant)
        (subject_metric_binding ?tenant ?usage_metric)
        (not
          (bucket_active ?quota_bucket)
        )
      )
    :effect (bucket_active ?quota_bucket)
  )
  (:action bind_capability_flag_to_enforcer
    :parameters (?enforcer - enforcement_agent ?capability_flag - capability_flag ?quota_bucket - quota_bucket)
    :precondition
      (and
        (subject_initialized ?enforcer)
        (enforcer_bucket_association ?enforcer ?quota_bucket)
        (enforcer_capability_binding ?enforcer ?capability_flag)
        (capability_flag_available ?capability_flag)
        (bucket_allocated ?quota_bucket)
        (bucket_active ?quota_bucket)
        (not
          (capability_flag_bound ?capability_flag)
        )
      )
    :effect
      (and
        (capability_flag_bound ?capability_flag)
        (capability_flag_bucket_binding ?capability_flag ?quota_bucket)
        (not
          (capability_flag_available ?capability_flag)
        )
      )
  )
  (:action commit_enforcer_capability_for_bucket
    :parameters (?enforcer - enforcement_agent ?capability_flag - capability_flag ?quota_bucket - quota_bucket ?usage_metric - usage_metric)
    :precondition
      (and
        (subject_initialized ?enforcer)
        (enforcer_capability_binding ?enforcer ?capability_flag)
        (capability_flag_bound ?capability_flag)
        (capability_flag_bucket_binding ?capability_flag ?quota_bucket)
        (subject_metric_binding ?enforcer ?usage_metric)
        (not
          (bucket_feature_flag_1 ?quota_bucket)
        )
        (not
          (enforcer_capability_bound ?enforcer)
        )
      )
    :effect (enforcer_capability_bound ?enforcer)
  )
  (:action attach_proposal_bundle_to_enforcer
    :parameters (?enforcer - enforcement_agent ?proposal_bundle - proposal_bundle)
    :precondition
      (and
        (subject_initialized ?enforcer)
        (proposal_bundle_available ?proposal_bundle)
        (not
          (enforcer_proposal_bundle_attached ?enforcer)
        )
      )
    :effect
      (and
        (enforcer_proposal_bundle_attached ?enforcer)
        (enforcer_proposal_bundle_binding ?enforcer ?proposal_bundle)
        (not
          (proposal_bundle_available ?proposal_bundle)
        )
      )
  )
  (:action stage_enforcer_with_proposal_and_capability
    :parameters (?enforcer - enforcement_agent ?capability_flag - capability_flag ?quota_bucket - quota_bucket ?usage_metric - usage_metric ?proposal_bundle - proposal_bundle)
    :precondition
      (and
        (subject_initialized ?enforcer)
        (enforcer_capability_binding ?enforcer ?capability_flag)
        (capability_flag_bound ?capability_flag)
        (capability_flag_bucket_binding ?capability_flag ?quota_bucket)
        (subject_metric_binding ?enforcer ?usage_metric)
        (bucket_feature_flag_1 ?quota_bucket)
        (enforcer_proposal_bundle_attached ?enforcer)
        (enforcer_proposal_bundle_binding ?enforcer ?proposal_bundle)
        (not
          (enforcer_capability_bound ?enforcer)
        )
      )
    :effect
      (and
        (enforcer_capability_bound ?enforcer)
        (enforcer_stage_committed ?enforcer)
      )
  )
  (:action verify_enforcer_allocation_and_capability_step1
    :parameters (?enforcer - enforcement_agent ?allocation_rule - allocation_rule ?operator_token - operator_token ?capability_flag - capability_flag ?quota_bucket - quota_bucket)
    :precondition
      (and
        (enforcer_capability_bound ?enforcer)
        (enforcer_allocation_rule_binding ?enforcer ?allocation_rule)
        (subject_operator_binding ?enforcer ?operator_token)
        (enforcer_capability_binding ?enforcer ?capability_flag)
        (capability_flag_bucket_binding ?capability_flag ?quota_bucket)
        (not
          (bucket_feature_flag_2 ?quota_bucket)
        )
        (not
          (enforcer_capability_verified ?enforcer)
        )
      )
    :effect (enforcer_capability_verified ?enforcer)
  )
  (:action verify_enforcer_allocation_and_capability_step2
    :parameters (?enforcer - enforcement_agent ?allocation_rule - allocation_rule ?operator_token - operator_token ?capability_flag - capability_flag ?quota_bucket - quota_bucket)
    :precondition
      (and
        (enforcer_capability_bound ?enforcer)
        (enforcer_allocation_rule_binding ?enforcer ?allocation_rule)
        (subject_operator_binding ?enforcer ?operator_token)
        (enforcer_capability_binding ?enforcer ?capability_flag)
        (capability_flag_bucket_binding ?capability_flag ?quota_bucket)
        (bucket_feature_flag_2 ?quota_bucket)
        (not
          (enforcer_capability_verified ?enforcer)
        )
      )
    :effect (enforcer_capability_verified ?enforcer)
  )
  (:action prepare_enforcer_for_finalization
    :parameters (?enforcer - enforcement_agent ?policy_tag - policy_tag ?capability_flag - capability_flag ?quota_bucket - quota_bucket)
    :precondition
      (and
        (enforcer_capability_verified ?enforcer)
        (enforcer_policy_tag_binding ?enforcer ?policy_tag)
        (enforcer_capability_binding ?enforcer ?capability_flag)
        (capability_flag_bucket_binding ?capability_flag ?quota_bucket)
        (not
          (bucket_feature_flag_1 ?quota_bucket)
        )
        (not
          (bucket_feature_flag_2 ?quota_bucket)
        )
        (not
          (enforcer_ready ?enforcer)
        )
      )
    :effect (enforcer_ready ?enforcer)
  )
  (:action advance_enforcer_and_set_eligibility
    :parameters (?enforcer - enforcement_agent ?policy_tag - policy_tag ?capability_flag - capability_flag ?quota_bucket - quota_bucket)
    :precondition
      (and
        (enforcer_capability_verified ?enforcer)
        (enforcer_policy_tag_binding ?enforcer ?policy_tag)
        (enforcer_capability_binding ?enforcer ?capability_flag)
        (capability_flag_bucket_binding ?capability_flag ?quota_bucket)
        (bucket_feature_flag_1 ?quota_bucket)
        (not
          (bucket_feature_flag_2 ?quota_bucket)
        )
        (not
          (enforcer_ready ?enforcer)
        )
      )
    :effect
      (and
        (enforcer_ready ?enforcer)
        (enforcer_eligibility_flag ?enforcer)
      )
  )
  (:action advance_enforcer_and_set_eligibility_alt
    :parameters (?enforcer - enforcement_agent ?policy_tag - policy_tag ?capability_flag - capability_flag ?quota_bucket - quota_bucket)
    :precondition
      (and
        (enforcer_capability_verified ?enforcer)
        (enforcer_policy_tag_binding ?enforcer ?policy_tag)
        (enforcer_capability_binding ?enforcer ?capability_flag)
        (capability_flag_bucket_binding ?capability_flag ?quota_bucket)
        (not
          (bucket_feature_flag_1 ?quota_bucket)
        )
        (bucket_feature_flag_2 ?quota_bucket)
        (not
          (enforcer_ready ?enforcer)
        )
      )
    :effect
      (and
        (enforcer_ready ?enforcer)
        (enforcer_eligibility_flag ?enforcer)
      )
  )
  (:action complete_enforcer_preparation_and_set_eligibility
    :parameters (?enforcer - enforcement_agent ?policy_tag - policy_tag ?capability_flag - capability_flag ?quota_bucket - quota_bucket)
    :precondition
      (and
        (enforcer_capability_verified ?enforcer)
        (enforcer_policy_tag_binding ?enforcer ?policy_tag)
        (enforcer_capability_binding ?enforcer ?capability_flag)
        (capability_flag_bucket_binding ?capability_flag ?quota_bucket)
        (bucket_feature_flag_1 ?quota_bucket)
        (bucket_feature_flag_2 ?quota_bucket)
        (not
          (enforcer_ready ?enforcer)
        )
      )
    :effect
      (and
        (enforcer_ready ?enforcer)
        (enforcer_eligibility_flag ?enforcer)
      )
  )
  (:action issue_enforcer_eligibility_token
    :parameters (?enforcer - enforcement_agent)
    :precondition
      (and
        (enforcer_ready ?enforcer)
        (not
          (enforcer_eligibility_flag ?enforcer)
        )
        (not
          (enforcer_eligibility_token ?enforcer)
        )
      )
    :effect
      (and
        (enforcer_eligibility_token ?enforcer)
        (evaluation_ready ?enforcer)
      )
  )
  (:action attach_policy_to_enforcer
    :parameters (?enforcer - enforcement_agent ?policy_attachment - policy_attachment)
    :precondition
      (and
        (enforcer_ready ?enforcer)
        (enforcer_eligibility_flag ?enforcer)
        (policy_attachment_available ?policy_attachment)
      )
    :effect
      (and
        (enforcer_policy_attached ?enforcer ?policy_attachment)
        (not
          (policy_attachment_available ?policy_attachment)
        )
      )
  )
  (:action finalize_enforcer_activation
    :parameters (?enforcer - enforcement_agent ?tenant - tenant_scope ?project - project_scope ?usage_metric - usage_metric ?policy_attachment - policy_attachment)
    :precondition
      (and
        (enforcer_ready ?enforcer)
        (enforcer_eligibility_flag ?enforcer)
        (enforcer_policy_attached ?enforcer ?policy_attachment)
        (enforcer_tenant_association ?enforcer ?tenant)
        (enforcer_project_association ?enforcer ?project)
        (tenant_ready_for_bucket ?tenant)
        (project_ready_for_bucket ?project)
        (subject_metric_binding ?enforcer ?usage_metric)
        (not
          (enforcer_finalized ?enforcer)
        )
      )
    :effect (enforcer_finalized ?enforcer)
  )
  (:action finalize_enforcer_eligibility
    :parameters (?enforcer - enforcement_agent)
    :precondition
      (and
        (enforcer_ready ?enforcer)
        (enforcer_finalized ?enforcer)
        (not
          (enforcer_eligibility_token ?enforcer)
        )
      )
    :effect
      (and
        (enforcer_eligibility_token ?enforcer)
        (evaluation_ready ?enforcer)
      )
  )
  (:action apply_assignment_tag_to_enforcer
    :parameters (?enforcer - enforcement_agent ?assignment_tag - assignment_tag ?usage_metric - usage_metric)
    :precondition
      (and
        (subject_initialized ?enforcer)
        (subject_metric_binding ?enforcer ?usage_metric)
        (assignment_tag_available ?assignment_tag)
        (enforcer_assignment_tag_binding ?enforcer ?assignment_tag)
        (not
          (enforcer_assigned_flag ?enforcer)
        )
      )
    :effect
      (and
        (enforcer_assigned_flag ?enforcer)
        (not
          (assignment_tag_available ?assignment_tag)
        )
      )
  )
  (:action commit_enforcer_assignment
    :parameters (?enforcer - enforcement_agent ?operator_token - operator_token)
    :precondition
      (and
        (enforcer_assigned_flag ?enforcer)
        (subject_operator_binding ?enforcer ?operator_token)
        (not
          (enforcer_assignment_committed ?enforcer)
        )
      )
    :effect (enforcer_assignment_committed ?enforcer)
  )
  (:action prepare_enforcer_report
    :parameters (?enforcer - enforcement_agent ?policy_tag - policy_tag)
    :precondition
      (and
        (enforcer_assignment_committed ?enforcer)
        (enforcer_policy_tag_binding ?enforcer ?policy_tag)
        (not
          (enforcer_report_ready ?enforcer)
        )
      )
    :effect (enforcer_report_ready ?enforcer)
  )
  (:action finalize_enforcer_report_and_mark_ready
    :parameters (?enforcer - enforcement_agent)
    :precondition
      (and
        (enforcer_report_ready ?enforcer)
        (not
          (enforcer_eligibility_token ?enforcer)
        )
      )
    :effect
      (and
        (enforcer_eligibility_token ?enforcer)
        (evaluation_ready ?enforcer)
      )
  )
  (:action qualify_tenant_for_enforcement
    :parameters (?tenant - tenant_scope ?quota_bucket - quota_bucket)
    :precondition
      (and
        (tenant_evaluation_gate ?tenant)
        (tenant_ready_for_bucket ?tenant)
        (bucket_allocated ?quota_bucket)
        (bucket_active ?quota_bucket)
        (not
          (evaluation_ready ?tenant)
        )
      )
    :effect (evaluation_ready ?tenant)
  )
  (:action qualify_project_for_enforcement
    :parameters (?project - project_scope ?quota_bucket - quota_bucket)
    :precondition
      (and
        (project_evaluation_gate ?project)
        (project_ready_for_bucket ?project)
        (bucket_allocated ?quota_bucket)
        (bucket_active ?quota_bucket)
        (not
          (evaluation_ready ?project)
        )
      )
    :effect (evaluation_ready ?project)
  )
  (:action issue_validation_credential_to_subject
    :parameters (?subject - quota_subject ?validation_credential - validation_credential ?usage_metric - usage_metric)
    :precondition
      (and
        (evaluation_ready ?subject)
        (subject_metric_binding ?subject ?usage_metric)
        (validation_credential_available ?validation_credential)
        (not
          (validation_confirmed ?subject)
        )
      )
    :effect
      (and
        (validation_confirmed ?subject)
        (subject_validation_binding ?subject ?validation_credential)
        (not
          (validation_credential_available ?validation_credential)
        )
      )
  )
  (:action apply_enforcement_and_open_slot_for_tenant
    :parameters (?tenant - tenant_scope ?quota_slot - quota_slot ?validation_credential - validation_credential)
    :precondition
      (and
        (validation_confirmed ?tenant)
        (subject_slot_binding ?tenant ?quota_slot)
        (subject_validation_binding ?tenant ?validation_credential)
        (not
          (enforcement_applied ?tenant)
        )
      )
    :effect
      (and
        (enforcement_applied ?tenant)
        (slot_available ?quota_slot)
        (validation_credential_available ?validation_credential)
      )
  )
  (:action apply_enforcement_and_open_slot_for_project
    :parameters (?project - project_scope ?quota_slot - quota_slot ?validation_credential - validation_credential)
    :precondition
      (and
        (validation_confirmed ?project)
        (subject_slot_binding ?project ?quota_slot)
        (subject_validation_binding ?project ?validation_credential)
        (not
          (enforcement_applied ?project)
        )
      )
    :effect
      (and
        (enforcement_applied ?project)
        (slot_available ?quota_slot)
        (validation_credential_available ?validation_credential)
      )
  )
  (:action apply_enforcement_and_open_slot_for_enforcer
    :parameters (?enforcer - enforcement_agent ?quota_slot - quota_slot ?validation_credential - validation_credential)
    :precondition
      (and
        (validation_confirmed ?enforcer)
        (subject_slot_binding ?enforcer ?quota_slot)
        (subject_validation_binding ?enforcer ?validation_credential)
        (not
          (enforcement_applied ?enforcer)
        )
      )
    :effect
      (and
        (enforcement_applied ?enforcer)
        (slot_available ?quota_slot)
        (validation_credential_available ?validation_credential)
      )
  )
)

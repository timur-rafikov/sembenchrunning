(define (domain domain_jurisdiction_profile_switching)
  (:requirements :strips :typing :negative-preconditions)
  (:types case_instance - object profile_candidate - object rule_set - object account_attribute - object customer_segment - object transaction_attribute - object profile_source - object escalation_ticket - object approval_policy - object senior_reviewer - object subject_matter_expert - object jurisdiction_code - object escalation_handle - object escalation_group - escalation_handle escalation_team - escalation_handle case_category_a - case_instance case_category_b - case_instance)
  (:predicates
    (case_registered ?case_instance - case_instance)
    (case_candidate_selected ?case_instance - case_instance ?profile_candidate - profile_candidate)
    (case_candidate_bound ?case_instance - case_instance)
    (case_reviewer_assigned ?case_instance - case_instance)
    (case_provisional_approval ?case_instance - case_instance)
    (case_has_customer_segment ?case_instance - case_instance ?customer_segment - customer_segment)
    (case_has_account_attribute ?case_instance - case_instance ?account_attribute - account_attribute)
    (case_has_transaction_attribute ?case_instance - case_instance ?transaction_attribute - transaction_attribute)
    (case_has_jurisdiction_code ?case_instance - case_instance ?jurisdiction_code - jurisdiction_code)
    (case_rule_set_applied ?case_instance - case_instance ?rule_set - rule_set)
    (case_rules_applied_flag ?case_instance - case_instance)
    (case_approval_initiated ?case_instance - case_instance)
    (case_policy_candidate_marked ?case_instance - case_instance)
    (case_profile_switch_committed ?case_instance - case_instance)
    (case_escalation_pending ?case_instance - case_instance)
    (case_approval_finalized ?case_instance - case_instance)
    (case_category_policy_link ?case_instance - case_instance ?approval_policy - approval_policy)
    (approval_policy_engaged ?case_instance - case_instance ?approval_policy - approval_policy)
    (case_senior_review_recorded ?case_instance - case_instance)
    (profile_candidate_available ?profile_candidate - profile_candidate)
    (rule_set_available ?rule_set - rule_set)
    (customer_segment_available ?customer_segment - customer_segment)
    (account_attribute_available ?account_attribute - account_attribute)
    (transaction_attribute_available ?transaction_attribute - transaction_attribute)
    (profile_source_available ?profile_source - profile_source)
    (escalation_ticket_available ?escalation_ticket - escalation_ticket)
    (approval_policy_unassigned ?approval_policy - approval_policy)
    (senior_reviewer_available ?senior_reviewer - senior_reviewer)
    (sme_available ?subject_matter_expert - subject_matter_expert)
    (jurisdiction_code_available ?jurisdiction_code - jurisdiction_code)
    (case_candidate_compatible ?case_instance - case_instance ?profile_candidate - profile_candidate)
    (case_rule_set_compatible ?case_instance - case_instance ?rule_set - rule_set)
    (case_customer_segment_compatible ?case_instance - case_instance ?customer_segment - customer_segment)
    (case_account_attribute_compatible ?case_instance - case_instance ?account_attribute - account_attribute)
    (case_transaction_attribute_compatible ?case_instance - case_instance ?transaction_attribute - transaction_attribute)
    (case_sme_compatible ?case_instance - case_instance ?subject_matter_expert - subject_matter_expert)
    (case_jurisdiction_code_compatible ?case_instance - case_instance ?jurisdiction_code - jurisdiction_code)
    (case_escalation_handle ?case_instance - case_instance ?escalation_handle - escalation_handle)
    (approval_policy_assigned ?case_instance - case_instance ?approval_policy - approval_policy)
    (case_is_in_category_a ?case_instance - case_instance)
    (case_is_in_category_b ?case_instance - case_instance)
    (case_has_profile_source ?case_instance - case_instance ?profile_source - profile_source)
    (case_additional_review_required ?case_instance - case_instance)
    (approval_policy_applicable ?case_instance - case_instance ?approval_policy - approval_policy)
  )
  (:action register_case
    :parameters (?case_instance - case_instance)
    :precondition
      (and
        (not
          (case_registered ?case_instance)
        )
        (not
          (case_profile_switch_committed ?case_instance)
        )
      )
    :effect
      (and
        (case_registered ?case_instance)
      )
  )
  (:action select_profile_candidate
    :parameters (?case_instance - case_instance ?profile_candidate - profile_candidate)
    :precondition
      (and
        (case_registered ?case_instance)
        (profile_candidate_available ?profile_candidate)
        (case_candidate_compatible ?case_instance ?profile_candidate)
        (not
          (case_candidate_bound ?case_instance)
        )
      )
    :effect
      (and
        (case_candidate_selected ?case_instance ?profile_candidate)
        (case_candidate_bound ?case_instance)
        (not
          (profile_candidate_available ?profile_candidate)
        )
      )
  )
  (:action release_profile_candidate
    :parameters (?case_instance - case_instance ?profile_candidate - profile_candidate)
    :precondition
      (and
        (case_candidate_selected ?case_instance ?profile_candidate)
        (not
          (case_rules_applied_flag ?case_instance)
        )
        (not
          (case_approval_initiated ?case_instance)
        )
      )
    :effect
      (and
        (not
          (case_candidate_selected ?case_instance ?profile_candidate)
        )
        (not
          (case_candidate_bound ?case_instance)
        )
        (not
          (case_reviewer_assigned ?case_instance)
        )
        (not
          (case_provisional_approval ?case_instance)
        )
        (not
          (case_escalation_pending ?case_instance)
        )
        (not
          (case_approval_finalized ?case_instance)
        )
        (not
          (case_additional_review_required ?case_instance)
        )
        (profile_candidate_available ?profile_candidate)
      )
  )
  (:action bind_profile_source
    :parameters (?case_instance - case_instance ?profile_source - profile_source)
    :precondition
      (and
        (case_registered ?case_instance)
        (profile_source_available ?profile_source)
      )
    :effect
      (and
        (case_has_profile_source ?case_instance ?profile_source)
        (not
          (profile_source_available ?profile_source)
        )
      )
  )
  (:action unbind_profile_source
    :parameters (?case_instance - case_instance ?profile_source - profile_source)
    :precondition
      (and
        (case_has_profile_source ?case_instance ?profile_source)
      )
    :effect
      (and
        (profile_source_available ?profile_source)
        (not
          (case_has_profile_source ?case_instance ?profile_source)
        )
      )
  )
  (:action assign_provisional_reviewer
    :parameters (?case_instance - case_instance ?profile_source - profile_source)
    :precondition
      (and
        (case_registered ?case_instance)
        (case_candidate_bound ?case_instance)
        (case_has_profile_source ?case_instance ?profile_source)
        (not
          (case_reviewer_assigned ?case_instance)
        )
      )
    :effect
      (and
        (case_reviewer_assigned ?case_instance)
      )
  )
  (:action assign_reviewer_with_ticket
    :parameters (?case_instance - case_instance ?escalation_ticket - escalation_ticket)
    :precondition
      (and
        (case_registered ?case_instance)
        (case_candidate_bound ?case_instance)
        (escalation_ticket_available ?escalation_ticket)
        (not
          (case_reviewer_assigned ?case_instance)
        )
      )
    :effect
      (and
        (case_reviewer_assigned ?case_instance)
        (case_escalation_pending ?case_instance)
        (not
          (escalation_ticket_available ?escalation_ticket)
        )
      )
  )
  (:action record_provisional_approval_by_senior
    :parameters (?case_instance - case_instance ?profile_source - profile_source ?senior_reviewer - senior_reviewer)
    :precondition
      (and
        (case_reviewer_assigned ?case_instance)
        (case_candidate_bound ?case_instance)
        (case_has_profile_source ?case_instance ?profile_source)
        (senior_reviewer_available ?senior_reviewer)
        (not
          (case_provisional_approval ?case_instance)
        )
      )
    :effect
      (and
        (case_provisional_approval ?case_instance)
        (not
          (case_escalation_pending ?case_instance)
        )
      )
  )
  (:action apply_ruleset_provisional_approval
    :parameters (?case_instance - case_instance ?approval_policy - approval_policy)
    :precondition
      (and
        (case_candidate_bound ?case_instance)
        (approval_policy_engaged ?case_instance ?approval_policy)
        (not
          (case_provisional_approval ?case_instance)
        )
      )
    :effect
      (and
        (case_provisional_approval ?case_instance)
        (not
          (case_escalation_pending ?case_instance)
        )
      )
  )
  (:action link_case_customer_segment
    :parameters (?case_instance - case_instance ?customer_segment - customer_segment)
    :precondition
      (and
        (case_registered ?case_instance)
        (customer_segment_available ?customer_segment)
        (case_customer_segment_compatible ?case_instance ?customer_segment)
      )
    :effect
      (and
        (case_has_customer_segment ?case_instance ?customer_segment)
        (not
          (customer_segment_available ?customer_segment)
        )
      )
  )
  (:action release_case_customer_segment
    :parameters (?case_instance - case_instance ?customer_segment - customer_segment)
    :precondition
      (and
        (case_has_customer_segment ?case_instance ?customer_segment)
      )
    :effect
      (and
        (customer_segment_available ?customer_segment)
        (not
          (case_has_customer_segment ?case_instance ?customer_segment)
        )
      )
  )
  (:action link_case_account_attribute
    :parameters (?case_instance - case_instance ?account_attribute - account_attribute)
    :precondition
      (and
        (case_registered ?case_instance)
        (account_attribute_available ?account_attribute)
        (case_account_attribute_compatible ?case_instance ?account_attribute)
      )
    :effect
      (and
        (case_has_account_attribute ?case_instance ?account_attribute)
        (not
          (account_attribute_available ?account_attribute)
        )
      )
  )
  (:action release_case_account_attribute
    :parameters (?case_instance - case_instance ?account_attribute - account_attribute)
    :precondition
      (and
        (case_has_account_attribute ?case_instance ?account_attribute)
      )
    :effect
      (and
        (account_attribute_available ?account_attribute)
        (not
          (case_has_account_attribute ?case_instance ?account_attribute)
        )
      )
  )
  (:action link_case_transaction_attribute
    :parameters (?case_instance - case_instance ?transaction_attribute - transaction_attribute)
    :precondition
      (and
        (case_registered ?case_instance)
        (transaction_attribute_available ?transaction_attribute)
        (case_transaction_attribute_compatible ?case_instance ?transaction_attribute)
      )
    :effect
      (and
        (case_has_transaction_attribute ?case_instance ?transaction_attribute)
        (not
          (transaction_attribute_available ?transaction_attribute)
        )
      )
  )
  (:action release_case_transaction_attribute
    :parameters (?case_instance - case_instance ?transaction_attribute - transaction_attribute)
    :precondition
      (and
        (case_has_transaction_attribute ?case_instance ?transaction_attribute)
      )
    :effect
      (and
        (transaction_attribute_available ?transaction_attribute)
        (not
          (case_has_transaction_attribute ?case_instance ?transaction_attribute)
        )
      )
  )
  (:action link_case_jurisdiction_code
    :parameters (?case_instance - case_instance ?jurisdiction_code - jurisdiction_code)
    :precondition
      (and
        (case_registered ?case_instance)
        (jurisdiction_code_available ?jurisdiction_code)
        (case_jurisdiction_code_compatible ?case_instance ?jurisdiction_code)
      )
    :effect
      (and
        (case_has_jurisdiction_code ?case_instance ?jurisdiction_code)
        (not
          (jurisdiction_code_available ?jurisdiction_code)
        )
      )
  )
  (:action release_case_jurisdiction_code
    :parameters (?case_instance - case_instance ?jurisdiction_code - jurisdiction_code)
    :precondition
      (and
        (case_has_jurisdiction_code ?case_instance ?jurisdiction_code)
      )
    :effect
      (and
        (jurisdiction_code_available ?jurisdiction_code)
        (not
          (case_has_jurisdiction_code ?case_instance ?jurisdiction_code)
        )
      )
  )
  (:action apply_ruleset_and_set_gate
    :parameters (?case_instance - case_instance ?rule_set - rule_set ?customer_segment - customer_segment ?account_attribute - account_attribute)
    :precondition
      (and
        (case_candidate_bound ?case_instance)
        (case_has_customer_segment ?case_instance ?customer_segment)
        (case_has_account_attribute ?case_instance ?account_attribute)
        (rule_set_available ?rule_set)
        (case_rule_set_compatible ?case_instance ?rule_set)
        (not
          (case_rules_applied_flag ?case_instance)
        )
      )
    :effect
      (and
        (case_rule_set_applied ?case_instance ?rule_set)
        (case_rules_applied_flag ?case_instance)
        (not
          (rule_set_available ?rule_set)
        )
      )
  )
  (:action apply_ruleset_with_sme_and_set_gates
    :parameters (?case_instance - case_instance ?rule_set - rule_set ?transaction_attribute - transaction_attribute ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (case_candidate_bound ?case_instance)
        (case_has_transaction_attribute ?case_instance ?transaction_attribute)
        (sme_available ?subject_matter_expert)
        (rule_set_available ?rule_set)
        (case_rule_set_compatible ?case_instance ?rule_set)
        (case_sme_compatible ?case_instance ?subject_matter_expert)
        (not
          (case_rules_applied_flag ?case_instance)
        )
      )
    :effect
      (and
        (case_rule_set_applied ?case_instance ?rule_set)
        (case_rules_applied_flag ?case_instance)
        (case_additional_review_required ?case_instance)
        (case_escalation_pending ?case_instance)
        (not
          (rule_set_available ?rule_set)
        )
        (not
          (sme_available ?subject_matter_expert)
        )
      )
  )
  (:action clear_additional_review_marker
    :parameters (?case_instance - case_instance ?customer_segment - customer_segment ?account_attribute - account_attribute)
    :precondition
      (and
        (case_rules_applied_flag ?case_instance)
        (case_additional_review_required ?case_instance)
        (case_has_customer_segment ?case_instance ?customer_segment)
        (case_has_account_attribute ?case_instance ?account_attribute)
      )
    :effect
      (and
        (not
          (case_additional_review_required ?case_instance)
        )
        (not
          (case_escalation_pending ?case_instance)
        )
      )
  )
  (:action escalate_with_group_approval
    :parameters (?case_instance - case_instance ?customer_segment - customer_segment ?account_attribute - account_attribute ?escalation_group - escalation_group)
    :precondition
      (and
        (case_provisional_approval ?case_instance)
        (case_rules_applied_flag ?case_instance)
        (case_has_customer_segment ?case_instance ?customer_segment)
        (case_has_account_attribute ?case_instance ?account_attribute)
        (case_escalation_handle ?case_instance ?escalation_group)
        (not
          (case_escalation_pending ?case_instance)
        )
        (not
          (case_approval_initiated ?case_instance)
        )
      )
    :effect
      (and
        (case_approval_initiated ?case_instance)
      )
  )
  (:action escalate_with_team_and_sme_approval
    :parameters (?case_instance - case_instance ?transaction_attribute - transaction_attribute ?jurisdiction_code - jurisdiction_code ?escalation_team - escalation_team)
    :precondition
      (and
        (case_provisional_approval ?case_instance)
        (case_rules_applied_flag ?case_instance)
        (case_has_transaction_attribute ?case_instance ?transaction_attribute)
        (case_has_jurisdiction_code ?case_instance ?jurisdiction_code)
        (case_escalation_handle ?case_instance ?escalation_team)
        (not
          (case_approval_initiated ?case_instance)
        )
      )
    :effect
      (and
        (case_approval_initiated ?case_instance)
        (case_escalation_pending ?case_instance)
      )
  )
  (:action finalize_multifactor_approval
    :parameters (?case_instance - case_instance ?customer_segment - customer_segment ?account_attribute - account_attribute)
    :precondition
      (and
        (case_approval_initiated ?case_instance)
        (case_escalation_pending ?case_instance)
        (case_has_customer_segment ?case_instance ?customer_segment)
        (case_has_account_attribute ?case_instance ?account_attribute)
      )
    :effect
      (and
        (case_approval_finalized ?case_instance)
        (not
          (case_escalation_pending ?case_instance)
        )
        (not
          (case_provisional_approval ?case_instance)
        )
        (not
          (case_additional_review_required ?case_instance)
        )
      )
  )
  (:action reinstate_provisional_approval_for_source
    :parameters (?case_instance - case_instance ?profile_source - profile_source ?senior_reviewer - senior_reviewer)
    :precondition
      (and
        (case_approval_finalized ?case_instance)
        (case_approval_initiated ?case_instance)
        (case_candidate_bound ?case_instance)
        (case_has_profile_source ?case_instance ?profile_source)
        (senior_reviewer_available ?senior_reviewer)
        (not
          (case_provisional_approval ?case_instance)
        )
      )
    :effect
      (and
        (case_provisional_approval ?case_instance)
      )
  )
  (:action mark_profile_source_reviewer_required
    :parameters (?case_instance - case_instance ?profile_source - profile_source)
    :precondition
      (and
        (case_approval_initiated ?case_instance)
        (case_provisional_approval ?case_instance)
        (not
          (case_escalation_pending ?case_instance)
        )
        (case_has_profile_source ?case_instance ?profile_source)
        (not
          (case_policy_candidate_marked ?case_instance)
        )
      )
    :effect
      (and
        (case_policy_candidate_marked ?case_instance)
      )
  )
  (:action mark_reviewer_requirement_with_ticket
    :parameters (?case_instance - case_instance ?escalation_ticket - escalation_ticket)
    :precondition
      (and
        (case_approval_initiated ?case_instance)
        (case_provisional_approval ?case_instance)
        (not
          (case_escalation_pending ?case_instance)
        )
        (escalation_ticket_available ?escalation_ticket)
        (not
          (case_policy_candidate_marked ?case_instance)
        )
      )
    :effect
      (and
        (case_policy_candidate_marked ?case_instance)
        (not
          (escalation_ticket_available ?escalation_ticket)
        )
      )
  )
  (:action assign_approval_policy_to_case
    :parameters (?case_instance - case_instance ?approval_policy - approval_policy)
    :precondition
      (and
        (case_policy_candidate_marked ?case_instance)
        (approval_policy_unassigned ?approval_policy)
        (approval_policy_applicable ?case_instance ?approval_policy)
      )
    :effect
      (and
        (approval_policy_assigned ?case_instance ?approval_policy)
        (not
          (approval_policy_unassigned ?approval_policy)
        )
      )
  )
  (:action engage_approval_policy
    :parameters (?case_category_b - case_category_b ?case_category_a - case_category_a ?approval_policy - approval_policy)
    :precondition
      (and
        (case_registered ?case_category_b)
        (case_is_in_category_b ?case_category_b)
        (case_category_policy_link ?case_category_b ?approval_policy)
        (approval_policy_assigned ?case_category_a ?approval_policy)
        (not
          (approval_policy_engaged ?case_category_b ?approval_policy)
        )
      )
    :effect
      (and
        (approval_policy_engaged ?case_category_b ?approval_policy)
      )
  )
  (:action record_senior_review
    :parameters (?case_instance - case_instance ?profile_source - profile_source ?senior_reviewer - senior_reviewer)
    :precondition
      (and
        (case_registered ?case_instance)
        (case_is_in_category_b ?case_instance)
        (case_provisional_approval ?case_instance)
        (case_policy_candidate_marked ?case_instance)
        (case_has_profile_source ?case_instance ?profile_source)
        (senior_reviewer_available ?senior_reviewer)
        (not
          (case_senior_review_recorded ?case_instance)
        )
      )
    :effect
      (and
        (case_senior_review_recorded ?case_instance)
      )
  )
  (:action commit_profile_switch_category_a
    :parameters (?case_instance - case_instance)
    :precondition
      (and
        (case_is_in_category_a ?case_instance)
        (case_registered ?case_instance)
        (case_candidate_bound ?case_instance)
        (case_rules_applied_flag ?case_instance)
        (case_approval_initiated ?case_instance)
        (case_policy_candidate_marked ?case_instance)
        (case_provisional_approval ?case_instance)
        (not
          (case_profile_switch_committed ?case_instance)
        )
      )
    :effect
      (and
        (case_profile_switch_committed ?case_instance)
      )
  )
  (:action commit_profile_switch_with_policy
    :parameters (?case_instance - case_instance ?approval_policy - approval_policy)
    :precondition
      (and
        (case_is_in_category_b ?case_instance)
        (case_registered ?case_instance)
        (case_candidate_bound ?case_instance)
        (case_rules_applied_flag ?case_instance)
        (case_approval_initiated ?case_instance)
        (case_policy_candidate_marked ?case_instance)
        (case_provisional_approval ?case_instance)
        (approval_policy_engaged ?case_instance ?approval_policy)
        (not
          (case_profile_switch_committed ?case_instance)
        )
      )
    :effect
      (and
        (case_profile_switch_committed ?case_instance)
      )
  )
  (:action commit_profile_switch_with_review
    :parameters (?case_instance - case_instance)
    :precondition
      (and
        (case_is_in_category_b ?case_instance)
        (case_registered ?case_instance)
        (case_candidate_bound ?case_instance)
        (case_rules_applied_flag ?case_instance)
        (case_approval_initiated ?case_instance)
        (case_policy_candidate_marked ?case_instance)
        (case_provisional_approval ?case_instance)
        (case_senior_review_recorded ?case_instance)
        (not
          (case_profile_switch_committed ?case_instance)
        )
      )
    :effect
      (and
        (case_profile_switch_committed ?case_instance)
      )
  )
)

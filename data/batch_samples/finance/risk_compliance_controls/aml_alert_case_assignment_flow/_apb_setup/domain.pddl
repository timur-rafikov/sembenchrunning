(define (domain aml_alert_case_assignment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types primitive_object - object aml_case - primitive_object analyst - primitive_object processing_queue - primitive_object transaction - primitive_object customer - primitive_object counterparty_account - primitive_object evidence_item - primitive_object automated_rule_signal - primitive_object senior_reviewer - primitive_object document_resource - primitive_object specialist_resource - primitive_object sanctions_list_entry - primitive_object approver_group - primitive_object escalation_team - approver_group specialist_team - approver_group case_variant_a - aml_case case_variant_b - aml_case)

  (:predicates
    (case_registered ?aml_case - aml_case)
    (case_assigned ?aml_case - aml_case ?analyst - analyst)
    (case_allocated_flag ?aml_case - aml_case)
    (screening_completed ?aml_case - aml_case)
    (first_line_verified ?aml_case - aml_case)
    (case_linked_customer ?aml_case - aml_case ?customer - customer)
    (case_linked_transaction ?aml_case - aml_case ?transaction - transaction)
    (case_linked_counterparty ?aml_case - aml_case ?counterparty_account - counterparty_account)
    (case_linked_sanctions_entry ?aml_case - aml_case ?sanctions_list_entry - sanctions_list_entry)
    (case_routed_to_queue ?aml_case - aml_case ?processing_queue - processing_queue)
    (primary_review_completed ?aml_case - aml_case)
    (ready_for_approval ?aml_case - aml_case)
    (senior_review_requested ?aml_case - aml_case)
    (case_finalized ?aml_case - aml_case)
    (escalation_pending ?aml_case - aml_case)
    (escalation_approved ?aml_case - aml_case)
    (case_variant_b_senior_reviewer_candidate ?aml_case - aml_case ?senior_reviewer - senior_reviewer)
    (case_assigned_senior_reviewer ?aml_case - aml_case ?senior_reviewer - senior_reviewer)
    (ready_for_finalization ?aml_case - aml_case)
    (analyst_available ?analyst - analyst)
    (processing_queue_active ?processing_queue - processing_queue)
    (customer_available ?customer - customer)
    (transaction_available ?transaction - transaction)
    (counterparty_available ?counterparty_account - counterparty_account)
    (evidence_available ?evidence_item - evidence_item)
    (automated_signal_available ?automated_rule_signal - automated_rule_signal)
    (senior_reviewer_available ?senior_reviewer - senior_reviewer)
    (document_resource_available ?document_resource - document_resource)
    (specialist_resource_available ?specialist_resource - specialist_resource)
    (sanctions_entry_available ?sanctions_list_entry - sanctions_list_entry)
    (case_analyst_eligibility ?aml_case - aml_case ?analyst - analyst)
    (case_queue_eligibility ?aml_case - aml_case ?processing_queue - processing_queue)
    (case_customer_eligibility ?aml_case - aml_case ?customer - customer)
    (case_transaction_eligibility ?aml_case - aml_case ?transaction - transaction)
    (case_counterparty_eligibility ?aml_case - aml_case ?counterparty_account - counterparty_account)
    (case_specialist_resource_eligibility ?aml_case - aml_case ?specialist_resource - specialist_resource)
    (case_sanctions_entry_eligibility ?aml_case - aml_case ?sanctions_list_entry - sanctions_list_entry)
    (case_approver_group_link ?aml_case - aml_case ?approver_group - approver_group)
    (case_preferred_senior_reviewer ?aml_case - aml_case ?senior_reviewer - senior_reviewer)
    (case_variant_a_tag ?aml_case - aml_case)
    (case_variant_b_tag ?aml_case - aml_case)
    (case_has_evidence ?aml_case - aml_case ?evidence_item - evidence_item)
    (specialist_required ?aml_case - aml_case)
    (case_default_senior_reviewer ?aml_case - aml_case ?senior_reviewer - senior_reviewer)
  )
  (:action register_case
    :parameters (?aml_case - aml_case)
    :precondition
      (and
        (not
          (case_registered ?aml_case)
        )
        (not
          (case_finalized ?aml_case)
        )
      )
    :effect
      (and
        (case_registered ?aml_case)
      )
  )
  (:action assign_case_to_analyst
    :parameters (?aml_case - aml_case ?analyst - analyst)
    :precondition
      (and
        (case_registered ?aml_case)
        (analyst_available ?analyst)
        (case_analyst_eligibility ?aml_case ?analyst)
        (not
          (case_allocated_flag ?aml_case)
        )
      )
    :effect
      (and
        (case_assigned ?aml_case ?analyst)
        (case_allocated_flag ?aml_case)
        (not
          (analyst_available ?analyst)
        )
      )
  )
  (:action release_case_from_analyst
    :parameters (?aml_case - aml_case ?analyst - analyst)
    :precondition
      (and
        (case_assigned ?aml_case ?analyst)
        (not
          (primary_review_completed ?aml_case)
        )
        (not
          (ready_for_approval ?aml_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned ?aml_case ?analyst)
        )
        (not
          (case_allocated_flag ?aml_case)
        )
        (not
          (screening_completed ?aml_case)
        )
        (not
          (first_line_verified ?aml_case)
        )
        (not
          (escalation_pending ?aml_case)
        )
        (not
          (escalation_approved ?aml_case)
        )
        (not
          (specialist_required ?aml_case)
        )
        (analyst_available ?analyst)
      )
  )
  (:action attach_evidence_to_case
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item)
    :precondition
      (and
        (case_registered ?aml_case)
        (evidence_available ?evidence_item)
      )
    :effect
      (and
        (case_has_evidence ?aml_case ?evidence_item)
        (not
          (evidence_available ?evidence_item)
        )
      )
  )
  (:action detach_evidence_from_case
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item)
    :precondition
      (and
        (case_has_evidence ?aml_case ?evidence_item)
      )
    :effect
      (and
        (evidence_available ?evidence_item)
        (not
          (case_has_evidence ?aml_case ?evidence_item)
        )
      )
  )
  (:action complete_screening_with_evidence
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item)
    :precondition
      (and
        (case_registered ?aml_case)
        (case_allocated_flag ?aml_case)
        (case_has_evidence ?aml_case ?evidence_item)
        (not
          (screening_completed ?aml_case)
        )
      )
    :effect
      (and
        (screening_completed ?aml_case)
      )
  )
  (:action complete_screening_with_signal
    :parameters (?aml_case - aml_case ?automated_rule_signal - automated_rule_signal)
    :precondition
      (and
        (case_registered ?aml_case)
        (case_allocated_flag ?aml_case)
        (automated_signal_available ?automated_rule_signal)
        (not
          (screening_completed ?aml_case)
        )
      )
    :effect
      (and
        (screening_completed ?aml_case)
        (escalation_pending ?aml_case)
        (not
          (automated_signal_available ?automated_rule_signal)
        )
      )
  )
  (:action certify_evidence_with_document
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item ?document_resource - document_resource)
    :precondition
      (and
        (screening_completed ?aml_case)
        (case_allocated_flag ?aml_case)
        (case_has_evidence ?aml_case ?evidence_item)
        (document_resource_available ?document_resource)
        (not
          (first_line_verified ?aml_case)
        )
      )
    :effect
      (and
        (first_line_verified ?aml_case)
        (not
          (escalation_pending ?aml_case)
        )
      )
  )
  (:action certify_evidence_with_senior_reviewer
    :parameters (?aml_case - aml_case ?senior_reviewer - senior_reviewer)
    :precondition
      (and
        (case_allocated_flag ?aml_case)
        (case_assigned_senior_reviewer ?aml_case ?senior_reviewer)
        (not
          (first_line_verified ?aml_case)
        )
      )
    :effect
      (and
        (first_line_verified ?aml_case)
        (not
          (escalation_pending ?aml_case)
        )
      )
  )
  (:action attach_customer_to_case
    :parameters (?aml_case - aml_case ?customer - customer)
    :precondition
      (and
        (case_registered ?aml_case)
        (customer_available ?customer)
        (case_customer_eligibility ?aml_case ?customer)
      )
    :effect
      (and
        (case_linked_customer ?aml_case ?customer)
        (not
          (customer_available ?customer)
        )
      )
  )
  (:action detach_customer_from_case
    :parameters (?aml_case - aml_case ?customer - customer)
    :precondition
      (and
        (case_linked_customer ?aml_case ?customer)
      )
    :effect
      (and
        (customer_available ?customer)
        (not
          (case_linked_customer ?aml_case ?customer)
        )
      )
  )
  (:action attach_transaction_to_case
    :parameters (?aml_case - aml_case ?transaction - transaction)
    :precondition
      (and
        (case_registered ?aml_case)
        (transaction_available ?transaction)
        (case_transaction_eligibility ?aml_case ?transaction)
      )
    :effect
      (and
        (case_linked_transaction ?aml_case ?transaction)
        (not
          (transaction_available ?transaction)
        )
      )
  )
  (:action detach_transaction_from_case
    :parameters (?aml_case - aml_case ?transaction - transaction)
    :precondition
      (and
        (case_linked_transaction ?aml_case ?transaction)
      )
    :effect
      (and
        (transaction_available ?transaction)
        (not
          (case_linked_transaction ?aml_case ?transaction)
        )
      )
  )
  (:action attach_counterparty_to_case
    :parameters (?aml_case - aml_case ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_registered ?aml_case)
        (counterparty_available ?counterparty_account)
        (case_counterparty_eligibility ?aml_case ?counterparty_account)
      )
    :effect
      (and
        (case_linked_counterparty ?aml_case ?counterparty_account)
        (not
          (counterparty_available ?counterparty_account)
        )
      )
  )
  (:action detach_counterparty_from_case
    :parameters (?aml_case - aml_case ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_linked_counterparty ?aml_case ?counterparty_account)
      )
    :effect
      (and
        (counterparty_available ?counterparty_account)
        (not
          (case_linked_counterparty ?aml_case ?counterparty_account)
        )
      )
  )
  (:action attach_sanctions_entry_to_case
    :parameters (?aml_case - aml_case ?sanctions_list_entry - sanctions_list_entry)
    :precondition
      (and
        (case_registered ?aml_case)
        (sanctions_entry_available ?sanctions_list_entry)
        (case_sanctions_entry_eligibility ?aml_case ?sanctions_list_entry)
      )
    :effect
      (and
        (case_linked_sanctions_entry ?aml_case ?sanctions_list_entry)
        (not
          (sanctions_entry_available ?sanctions_list_entry)
        )
      )
  )
  (:action detach_sanctions_entry_from_case
    :parameters (?aml_case - aml_case ?sanctions_list_entry - sanctions_list_entry)
    :precondition
      (and
        (case_linked_sanctions_entry ?aml_case ?sanctions_list_entry)
      )
    :effect
      (and
        (sanctions_entry_available ?sanctions_list_entry)
        (not
          (case_linked_sanctions_entry ?aml_case ?sanctions_list_entry)
        )
      )
  )
  (:action conduct_primary_review_queue
    :parameters (?aml_case - aml_case ?processing_queue - processing_queue ?customer - customer ?transaction - transaction)
    :precondition
      (and
        (case_allocated_flag ?aml_case)
        (case_linked_customer ?aml_case ?customer)
        (case_linked_transaction ?aml_case ?transaction)
        (processing_queue_active ?processing_queue)
        (case_queue_eligibility ?aml_case ?processing_queue)
        (not
          (primary_review_completed ?aml_case)
        )
      )
    :effect
      (and
        (case_routed_to_queue ?aml_case ?processing_queue)
        (primary_review_completed ?aml_case)
        (not
          (processing_queue_active ?processing_queue)
        )
      )
  )
  (:action conduct_primary_review_with_counterparty_and_specialist
    :parameters (?aml_case - aml_case ?processing_queue - processing_queue ?counterparty_account - counterparty_account ?specialist_resource - specialist_resource)
    :precondition
      (and
        (case_allocated_flag ?aml_case)
        (case_linked_counterparty ?aml_case ?counterparty_account)
        (specialist_resource_available ?specialist_resource)
        (processing_queue_active ?processing_queue)
        (case_queue_eligibility ?aml_case ?processing_queue)
        (case_specialist_resource_eligibility ?aml_case ?specialist_resource)
        (not
          (primary_review_completed ?aml_case)
        )
      )
    :effect
      (and
        (case_routed_to_queue ?aml_case ?processing_queue)
        (primary_review_completed ?aml_case)
        (specialist_required ?aml_case)
        (escalation_pending ?aml_case)
        (not
          (processing_queue_active ?processing_queue)
        )
        (not
          (specialist_resource_available ?specialist_resource)
        )
      )
  )
  (:action clear_temporary_review_markers
    :parameters (?aml_case - aml_case ?customer - customer ?transaction - transaction)
    :precondition
      (and
        (primary_review_completed ?aml_case)
        (specialist_required ?aml_case)
        (case_linked_customer ?aml_case ?customer)
        (case_linked_transaction ?aml_case ?transaction)
      )
    :effect
      (and
        (not
          (specialist_required ?aml_case)
        )
        (not
          (escalation_pending ?aml_case)
        )
      )
  )
  (:action request_escalation_approval
    :parameters (?aml_case - aml_case ?customer - customer ?transaction - transaction ?escalation_team - escalation_team)
    :precondition
      (and
        (first_line_verified ?aml_case)
        (primary_review_completed ?aml_case)
        (case_linked_customer ?aml_case ?customer)
        (case_linked_transaction ?aml_case ?transaction)
        (case_approver_group_link ?aml_case ?escalation_team)
        (not
          (escalation_pending ?aml_case)
        )
        (not
          (ready_for_approval ?aml_case)
        )
      )
    :effect
      (and
        (ready_for_approval ?aml_case)
      )
  )
  (:action escalate_and_request_specialist_approval
    :parameters (?aml_case - aml_case ?counterparty_account - counterparty_account ?sanctions_list_entry - sanctions_list_entry ?specialist_team - specialist_team)
    :precondition
      (and
        (first_line_verified ?aml_case)
        (primary_review_completed ?aml_case)
        (case_linked_counterparty ?aml_case ?counterparty_account)
        (case_linked_sanctions_entry ?aml_case ?sanctions_list_entry)
        (case_approver_group_link ?aml_case ?specialist_team)
        (not
          (ready_for_approval ?aml_case)
        )
      )
    :effect
      (and
        (ready_for_approval ?aml_case)
        (escalation_pending ?aml_case)
      )
  )
  (:action approve_escalation
    :parameters (?aml_case - aml_case ?customer - customer ?transaction - transaction)
    :precondition
      (and
        (ready_for_approval ?aml_case)
        (escalation_pending ?aml_case)
        (case_linked_customer ?aml_case ?customer)
        (case_linked_transaction ?aml_case ?transaction)
      )
    :effect
      (and
        (escalation_approved ?aml_case)
        (not
          (escalation_pending ?aml_case)
        )
        (not
          (first_line_verified ?aml_case)
        )
        (not
          (specialist_required ?aml_case)
        )
      )
  )
  (:action reopen_case_with_document_after_approval
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item ?document_resource - document_resource)
    :precondition
      (and
        (escalation_approved ?aml_case)
        (ready_for_approval ?aml_case)
        (case_allocated_flag ?aml_case)
        (case_has_evidence ?aml_case ?evidence_item)
        (document_resource_available ?document_resource)
        (not
          (first_line_verified ?aml_case)
        )
      )
    :effect
      (and
        (first_line_verified ?aml_case)
      )
  )
  (:action request_senior_review_for_evidence_item
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item)
    :precondition
      (and
        (ready_for_approval ?aml_case)
        (first_line_verified ?aml_case)
        (not
          (escalation_pending ?aml_case)
        )
        (case_has_evidence ?aml_case ?evidence_item)
        (not
          (senior_review_requested ?aml_case)
        )
      )
    :effect
      (and
        (senior_review_requested ?aml_case)
      )
  )
  (:action request_senior_review_with_signal
    :parameters (?aml_case - aml_case ?automated_rule_signal - automated_rule_signal)
    :precondition
      (and
        (ready_for_approval ?aml_case)
        (first_line_verified ?aml_case)
        (not
          (escalation_pending ?aml_case)
        )
        (automated_signal_available ?automated_rule_signal)
        (not
          (senior_review_requested ?aml_case)
        )
      )
    :effect
      (and
        (senior_review_requested ?aml_case)
        (not
          (automated_signal_available ?automated_rule_signal)
        )
      )
  )
  (:action assign_senior_reviewer
    :parameters (?aml_case - aml_case ?senior_reviewer - senior_reviewer)
    :precondition
      (and
        (senior_review_requested ?aml_case)
        (senior_reviewer_available ?senior_reviewer)
        (case_default_senior_reviewer ?aml_case ?senior_reviewer)
      )
    :effect
      (and
        (case_preferred_senior_reviewer ?aml_case ?senior_reviewer)
        (not
          (senior_reviewer_available ?senior_reviewer)
        )
      )
  )
  (:action assign_senior_reviewer_by_variant
    :parameters (?case_variant_b - case_variant_b ?case_variant_a - case_variant_a ?senior_reviewer - senior_reviewer)
    :precondition
      (and
        (case_registered ?case_variant_b)
        (case_variant_b_tag ?case_variant_b)
        (case_variant_b_senior_reviewer_candidate ?case_variant_b ?senior_reviewer)
        (case_preferred_senior_reviewer ?case_variant_a ?senior_reviewer)
        (not
          (case_assigned_senior_reviewer ?case_variant_b ?senior_reviewer)
        )
      )
    :effect
      (and
        (case_assigned_senior_reviewer ?case_variant_b ?senior_reviewer)
      )
  )
  (:action mark_case_ready_for_finalization
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item ?document_resource - document_resource)
    :precondition
      (and
        (case_registered ?aml_case)
        (case_variant_b_tag ?aml_case)
        (first_line_verified ?aml_case)
        (senior_review_requested ?aml_case)
        (case_has_evidence ?aml_case ?evidence_item)
        (document_resource_available ?document_resource)
        (not
          (ready_for_finalization ?aml_case)
        )
      )
    :effect
      (and
        (ready_for_finalization ?aml_case)
      )
  )
  (:action finalize_case
    :parameters (?aml_case - aml_case)
    :precondition
      (and
        (case_variant_a_tag ?aml_case)
        (case_registered ?aml_case)
        (case_allocated_flag ?aml_case)
        (primary_review_completed ?aml_case)
        (ready_for_approval ?aml_case)
        (senior_review_requested ?aml_case)
        (first_line_verified ?aml_case)
        (not
          (case_finalized ?aml_case)
        )
      )
    :effect
      (and
        (case_finalized ?aml_case)
      )
  )
  (:action finalize_case_with_senior_review
    :parameters (?aml_case - aml_case ?senior_reviewer - senior_reviewer)
    :precondition
      (and
        (case_variant_b_tag ?aml_case)
        (case_registered ?aml_case)
        (case_allocated_flag ?aml_case)
        (primary_review_completed ?aml_case)
        (ready_for_approval ?aml_case)
        (senior_review_requested ?aml_case)
        (first_line_verified ?aml_case)
        (case_assigned_senior_reviewer ?aml_case ?senior_reviewer)
        (not
          (case_finalized ?aml_case)
        )
      )
    :effect
      (and
        (case_finalized ?aml_case)
      )
  )
  (:action finalize_case_with_ready_flag
    :parameters (?aml_case - aml_case)
    :precondition
      (and
        (case_variant_b_tag ?aml_case)
        (case_registered ?aml_case)
        (case_allocated_flag ?aml_case)
        (primary_review_completed ?aml_case)
        (ready_for_approval ?aml_case)
        (senior_review_requested ?aml_case)
        (first_line_verified ?aml_case)
        (ready_for_finalization ?aml_case)
        (not
          (case_finalized ?aml_case)
        )
      )
    :effect
      (and
        (case_finalized ?aml_case)
      )
  )
)

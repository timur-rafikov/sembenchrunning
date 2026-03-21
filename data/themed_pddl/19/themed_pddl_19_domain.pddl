(define (domain aml_alert_case_assignment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types aml_case - primitive_object analyst - primitive_object processing_queue - primitive_object transaction - primitive_object customer - primitive_object counterparty_account - primitive_object evidence_item - primitive_object automated_rule_signal - primitive_object senior_reviewer - primitive_object document_resource - primitive_object specialist_resource - primitive_object sanctions_list_entry - primitive_object approver_group - primitive_object escalation_team - approver_group specialist_team - approver_group case_variant_a - aml_case case_variant_b - aml_case)
  (:predicates
    (automated_signal_available ?automated_rule_signal - automated_rule_signal)
    (case_linked_transaction ?aml_case - aml_case ?transaction - transaction)
    (escalation_approved ?aml_case - aml_case)
    (case_assigned ?aml_case - aml_case ?analyst - analyst)
    (case_approver_group_link ?aml_case - aml_case ?approver_group - approver_group)
    (counterparty_available ?counterparty_account - counterparty_account)
    (transaction_available ?transaction - transaction)
    (case_sanctions_entry_eligibility ?aml_case - aml_case ?sanctions_list_entry - sanctions_list_entry)
    (case_finalized ?aml_case - aml_case)
    (case_variant_a_tag ?aml_case - aml_case)
    (case_analyst_eligibility ?aml_case - aml_case ?analyst - analyst)
    (processing_queue_active ?processing_queue - processing_queue)
    (specialist_resource_available ?specialist_resource - specialist_resource)
    (evidence_available ?evidence_item - evidence_item)
    (primary_review_completed ?aml_case - aml_case)
    (case_transaction_eligibility ?aml_case - aml_case ?transaction - transaction)
    (case_linked_sanctions_entry ?aml_case - aml_case ?sanctions_list_entry - sanctions_list_entry)
    (case_routed_to_queue ?aml_case - aml_case ?processing_queue - processing_queue)
    (ready_for_approval ?aml_case - aml_case)
    (case_counterparty_eligibility ?aml_case - aml_case ?counterparty_account - counterparty_account)
    (sanctions_entry_available ?sanctions_list_entry - sanctions_list_entry)
    (case_variant_b_tag ?aml_case - aml_case)
    (first_line_verified ?aml_case - aml_case)
    (case_customer_eligibility ?aml_case - aml_case ?customer - customer)
    (case_linked_customer ?aml_case - aml_case ?customer - customer)
    (specialist_required ?aml_case - aml_case)
    (case_has_evidence ?aml_case - aml_case ?evidence_item - evidence_item)
    (ready_for_finalization ?aml_case - aml_case)
    (case_specialist_resource_eligibility ?aml_case - aml_case ?specialist_resource - specialist_resource)
    (case_registered ?aml_case - aml_case)
    (analyst_available ?analyst - analyst)
    (case_allocated_flag ?aml_case - aml_case)
    (document_resource_available ?document_resource - document_resource)
    (senior_reviewer_available ?senior_reviewer - senior_reviewer)
    (case_linked_counterparty ?aml_case - aml_case ?counterparty_account - counterparty_account)
    (case_preferred_senior_reviewer ?aml_case - aml_case ?senior_reviewer - senior_reviewer)
    (screening_completed ?aml_case - aml_case)
    (senior_review_requested ?aml_case - aml_case)
    (case_default_senior_reviewer ?aml_case - aml_case ?senior_reviewer - senior_reviewer)
    (customer_available ?customer - customer)
    (case_variant_b_senior_reviewer_candidate ?aml_case - aml_case ?senior_reviewer - senior_reviewer)
    (case_queue_eligibility ?aml_case - aml_case ?processing_queue - processing_queue)
    (escalation_pending ?aml_case - aml_case)
    (case_assigned_senior_reviewer ?aml_case - aml_case ?senior_reviewer - senior_reviewer)
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
  (:action escalate_and_request_specialist_approval
    :parameters (?aml_case - aml_case ?counterparty_account - counterparty_account ?sanctions_list_entry - sanctions_list_entry ?specialist_team - specialist_team)
    :precondition
      (and
        (not
          (ready_for_approval ?aml_case)
        )
        (primary_review_completed ?aml_case)
        (first_line_verified ?aml_case)
        (case_linked_sanctions_entry ?aml_case ?sanctions_list_entry)
        (case_approver_group_link ?aml_case ?specialist_team)
        (case_linked_counterparty ?aml_case ?counterparty_account)
      )
    :effect
      (and
        (escalation_pending ?aml_case)
        (ready_for_approval ?aml_case)
      )
  )
  (:action finalize_case
    :parameters (?aml_case - aml_case)
    :precondition
      (and
        (first_line_verified ?aml_case)
        (case_allocated_flag ?aml_case)
        (primary_review_completed ?aml_case)
        (case_registered ?aml_case)
        (senior_review_requested ?aml_case)
        (not
          (case_finalized ?aml_case)
        )
        (case_variant_a_tag ?aml_case)
        (ready_for_approval ?aml_case)
      )
    :effect
      (and
        (case_finalized ?aml_case)
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
  (:action attach_evidence_to_case
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item)
    :precondition
      (and
        (evidence_available ?evidence_item)
        (case_registered ?aml_case)
      )
    :effect
      (and
        (not
          (evidence_available ?evidence_item)
        )
        (case_has_evidence ?aml_case ?evidence_item)
      )
  )
  (:action request_escalation_approval
    :parameters (?aml_case - aml_case ?customer - customer ?transaction - transaction ?escalation_team - escalation_team)
    :precondition
      (and
        (case_approver_group_link ?aml_case ?escalation_team)
        (first_line_verified ?aml_case)
        (not
          (escalation_pending ?aml_case)
        )
        (case_linked_customer ?aml_case ?customer)
        (primary_review_completed ?aml_case)
        (case_linked_transaction ?aml_case ?transaction)
        (not
          (ready_for_approval ?aml_case)
        )
      )
    :effect
      (and
        (ready_for_approval ?aml_case)
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
  (:action attach_counterparty_to_case
    :parameters (?aml_case - aml_case ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_counterparty_eligibility ?aml_case ?counterparty_account)
        (case_registered ?aml_case)
        (counterparty_available ?counterparty_account)
      )
    :effect
      (and
        (case_linked_counterparty ?aml_case ?counterparty_account)
        (not
          (counterparty_available ?counterparty_account)
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
        (not
          (customer_available ?customer)
        )
        (case_linked_customer ?aml_case ?customer)
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
  (:action conduct_primary_review_queue
    :parameters (?aml_case - aml_case ?processing_queue - processing_queue ?customer - customer ?transaction - transaction)
    :precondition
      (and
        (case_allocated_flag ?aml_case)
        (processing_queue_active ?processing_queue)
        (case_queue_eligibility ?aml_case ?processing_queue)
        (not
          (primary_review_completed ?aml_case)
        )
        (case_linked_transaction ?aml_case ?transaction)
        (case_linked_customer ?aml_case ?customer)
      )
    :effect
      (and
        (case_routed_to_queue ?aml_case ?processing_queue)
        (not
          (processing_queue_active ?processing_queue)
        )
        (primary_review_completed ?aml_case)
      )
  )
  (:action approve_escalation
    :parameters (?aml_case - aml_case ?customer - customer ?transaction - transaction)
    :precondition
      (and
        (case_linked_customer ?aml_case ?customer)
        (ready_for_approval ?aml_case)
        (case_linked_transaction ?aml_case ?transaction)
        (escalation_pending ?aml_case)
      )
    :effect
      (and
        (not
          (specialist_required ?aml_case)
        )
        (not
          (escalation_pending ?aml_case)
        )
        (not
          (first_line_verified ?aml_case)
        )
        (escalation_approved ?aml_case)
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
  (:action certify_evidence_with_document
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item ?document_resource - document_resource)
    :precondition
      (and
        (not
          (first_line_verified ?aml_case)
        )
        (case_allocated_flag ?aml_case)
        (document_resource_available ?document_resource)
        (case_has_evidence ?aml_case ?evidence_item)
        (screening_completed ?aml_case)
      )
    :effect
      (and
        (not
          (escalation_pending ?aml_case)
        )
        (first_line_verified ?aml_case)
      )
  )
  (:action finalize_case_with_ready_flag
    :parameters (?aml_case - aml_case)
    :precondition
      (and
        (case_registered ?aml_case)
        (case_variant_b_tag ?aml_case)
        (ready_for_finalization ?aml_case)
        (case_allocated_flag ?aml_case)
        (first_line_verified ?aml_case)
        (not
          (case_finalized ?aml_case)
        )
        (senior_review_requested ?aml_case)
        (primary_review_completed ?aml_case)
        (ready_for_approval ?aml_case)
      )
    :effect
      (and
        (case_finalized ?aml_case)
      )
  )
  (:action mark_case_ready_for_finalization
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item ?document_resource - document_resource)
    :precondition
      (and
        (first_line_verified ?aml_case)
        (document_resource_available ?document_resource)
        (not
          (ready_for_finalization ?aml_case)
        )
        (senior_review_requested ?aml_case)
        (case_registered ?aml_case)
        (case_variant_b_tag ?aml_case)
        (case_has_evidence ?aml_case ?evidence_item)
      )
    :effect
      (and
        (ready_for_finalization ?aml_case)
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
  (:action attach_sanctions_entry_to_case
    :parameters (?aml_case - aml_case ?sanctions_list_entry - sanctions_list_entry)
    :precondition
      (and
        (sanctions_entry_available ?sanctions_list_entry)
        (case_registered ?aml_case)
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
  (:action complete_screening_with_signal
    :parameters (?aml_case - aml_case ?automated_rule_signal - automated_rule_signal)
    :precondition
      (and
        (not
          (screening_completed ?aml_case)
        )
        (case_registered ?aml_case)
        (automated_signal_available ?automated_rule_signal)
        (case_allocated_flag ?aml_case)
      )
    :effect
      (and
        (escalation_pending ?aml_case)
        (not
          (automated_signal_available ?automated_rule_signal)
        )
        (screening_completed ?aml_case)
      )
  )
  (:action conduct_primary_review_with_counterparty_and_specialist
    :parameters (?aml_case - aml_case ?processing_queue - processing_queue ?counterparty_account - counterparty_account ?specialist_resource - specialist_resource)
    :precondition
      (and
        (specialist_resource_available ?specialist_resource)
        (case_specialist_resource_eligibility ?aml_case ?specialist_resource)
        (not
          (primary_review_completed ?aml_case)
        )
        (case_allocated_flag ?aml_case)
        (processing_queue_active ?processing_queue)
        (case_queue_eligibility ?aml_case ?processing_queue)
        (case_linked_counterparty ?aml_case ?counterparty_account)
      )
    :effect
      (and
        (case_routed_to_queue ?aml_case ?processing_queue)
        (not
          (specialist_resource_available ?specialist_resource)
        )
        (specialist_required ?aml_case)
        (not
          (processing_queue_active ?processing_queue)
        )
        (escalation_pending ?aml_case)
        (primary_review_completed ?aml_case)
      )
  )
  (:action request_senior_review_with_signal
    :parameters (?aml_case - aml_case ?automated_rule_signal - automated_rule_signal)
    :precondition
      (and
        (automated_signal_available ?automated_rule_signal)
        (not
          (escalation_pending ?aml_case)
        )
        (first_line_verified ?aml_case)
        (ready_for_approval ?aml_case)
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
  (:action release_case_from_analyst
    :parameters (?aml_case - aml_case ?analyst - analyst)
    :precondition
      (and
        (case_assigned ?aml_case ?analyst)
        (not
          (ready_for_approval ?aml_case)
        )
        (not
          (primary_review_completed ?aml_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned ?aml_case ?analyst)
        )
        (analyst_available ?analyst)
        (not
          (case_allocated_flag ?aml_case)
        )
        (not
          (screening_completed ?aml_case)
        )
        (not
          (escalation_approved ?aml_case)
        )
        (not
          (first_line_verified ?aml_case)
        )
        (not
          (specialist_required ?aml_case)
        )
        (not
          (escalation_pending ?aml_case)
        )
      )
  )
  (:action request_senior_review_for_evidence_item
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item)
    :precondition
      (and
        (not
          (senior_review_requested ?aml_case)
        )
        (case_has_evidence ?aml_case ?evidence_item)
        (first_line_verified ?aml_case)
        (ready_for_approval ?aml_case)
        (not
          (escalation_pending ?aml_case)
        )
      )
    :effect
      (and
        (senior_review_requested ?aml_case)
      )
  )
  (:action finalize_case_with_senior_review
    :parameters (?aml_case - aml_case ?senior_reviewer - senior_reviewer)
    :precondition
      (and
        (senior_review_requested ?aml_case)
        (ready_for_approval ?aml_case)
        (primary_review_completed ?aml_case)
        (case_assigned_senior_reviewer ?aml_case ?senior_reviewer)
        (first_line_verified ?aml_case)
        (case_allocated_flag ?aml_case)
        (case_registered ?aml_case)
        (not
          (case_finalized ?aml_case)
        )
        (case_variant_b_tag ?aml_case)
      )
    :effect
      (and
        (case_finalized ?aml_case)
      )
  )
  (:action complete_screening_with_evidence
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item)
    :precondition
      (and
        (case_registered ?aml_case)
        (case_allocated_flag ?aml_case)
        (not
          (screening_completed ?aml_case)
        )
        (case_has_evidence ?aml_case ?evidence_item)
      )
    :effect
      (and
        (screening_completed ?aml_case)
      )
  )
  (:action assign_case_to_analyst
    :parameters (?aml_case - aml_case ?analyst - analyst)
    :precondition
      (and
        (not
          (case_allocated_flag ?aml_case)
        )
        (case_registered ?aml_case)
        (analyst_available ?analyst)
        (case_analyst_eligibility ?aml_case ?analyst)
      )
    :effect
      (and
        (case_allocated_flag ?aml_case)
        (not
          (analyst_available ?analyst)
        )
        (case_assigned ?aml_case ?analyst)
      )
  )
  (:action reopen_case_with_document_after_approval
    :parameters (?aml_case - aml_case ?evidence_item - evidence_item ?document_resource - document_resource)
    :precondition
      (and
        (case_allocated_flag ?aml_case)
        (not
          (first_line_verified ?aml_case)
        )
        (case_has_evidence ?aml_case ?evidence_item)
        (ready_for_approval ?aml_case)
        (document_resource_available ?document_resource)
        (escalation_approved ?aml_case)
      )
    :effect
      (and
        (first_line_verified ?aml_case)
      )
  )
  (:action assign_senior_reviewer_by_variant
    :parameters (?case_variant_b - case_variant_b ?case_variant_a - case_variant_a ?senior_reviewer - senior_reviewer)
    :precondition
      (and
        (case_registered ?case_variant_b)
        (case_preferred_senior_reviewer ?case_variant_a ?senior_reviewer)
        (case_variant_b_tag ?case_variant_b)
        (not
          (case_assigned_senior_reviewer ?case_variant_b ?senior_reviewer)
        )
        (case_variant_b_senior_reviewer_candidate ?case_variant_b ?senior_reviewer)
      )
    :effect
      (and
        (case_assigned_senior_reviewer ?case_variant_b ?senior_reviewer)
      )
  )
)

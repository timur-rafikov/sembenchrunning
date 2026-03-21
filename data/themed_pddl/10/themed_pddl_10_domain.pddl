(define (domain finance_chargeback_reconciliation_closure_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types chargeback_case - entity source_transaction - entity accounting_batch - entity merchant_account - entity clearing_instruction - entity dispute_record - entity work_item - entity analyst - entity external_reference - entity approver - entity evidence_document - entity reason_code - entity auxiliary_tag - entity resolution_method - auxiliary_tag accounting_policy - auxiliary_tag operational_case - chargeback_case audit_case - chargeback_case)
  (:predicates
    (analyst_available ?analyst - analyst)
    (case_has_merchant_account ?chargeback_case - chargeback_case ?merchant_account - merchant_account)
    (case_resolved ?chargeback_case - chargeback_case)
    (case_has_source_transaction ?chargeback_case - chargeback_case ?source_transaction - source_transaction)
    (case_auxiliary_tag ?chargeback_case - chargeback_case ?auxiliary_tag - auxiliary_tag)
    (dispute_record_available ?dispute_record - dispute_record)
    (merchant_account_available ?merchant_account - merchant_account)
    (case_reason_code_candidate ?chargeback_case - chargeback_case ?reason_code - reason_code)
    (case_closed ?chargeback_case - chargeback_case)
    (operational_routing_flag ?chargeback_case - chargeback_case)
    (case_source_transaction_candidate ?chargeback_case - chargeback_case ?source_transaction - source_transaction)
    (accounting_batch_available ?accounting_batch - accounting_batch)
    (evidence_document_available ?evidence_document - evidence_document)
    (work_item_available ?work_item - work_item)
    (case_accounting_aligned ?chargeback_case - chargeback_case)
    (case_merchant_account_candidate ?chargeback_case - chargeback_case ?merchant_account - merchant_account)
    (case_has_reason_code ?chargeback_case - chargeback_case ?reason_code - reason_code)
    (case_has_accounting_batch ?chargeback_case - chargeback_case ?accounting_batch - accounting_batch)
    (case_resolution_eligible ?chargeback_case - chargeback_case)
    (case_dispute_record_candidate ?chargeback_case - chargeback_case ?dispute_record - dispute_record)
    (reason_code_available ?reason_code - reason_code)
    (audit_routing_flag ?chargeback_case - chargeback_case)
    (case_evidence_verified ?chargeback_case - chargeback_case)
    (case_clearing_instruction_candidate ?chargeback_case - chargeback_case ?clearing_instruction - clearing_instruction)
    (case_has_clearing_instruction ?chargeback_case - chargeback_case ?clearing_instruction - clearing_instruction)
    (case_requires_followup ?chargeback_case - chargeback_case)
    (case_work_item_assigned ?chargeback_case - chargeback_case ?work_item - work_item)
    (case_audit_signoff_recorded ?chargeback_case - chargeback_case)
    (case_evidence_document_candidate ?chargeback_case - chargeback_case ?evidence_document - evidence_document)
    (case_active ?chargeback_case - chargeback_case)
    (source_transaction_available ?source_transaction - source_transaction)
    (case_has_match ?chargeback_case - chargeback_case)
    (approver_available ?approver - approver)
    (external_reference_available ?external_reference - external_reference)
    (case_has_dispute_record ?chargeback_case - chargeback_case ?dispute_record - dispute_record)
    (case_external_reference_candidate ?chargeback_case - chargeback_case ?external_reference - external_reference)
    (case_assigned_for_investigation ?chargeback_case - chargeback_case)
    (case_approver_recorded ?chargeback_case - chargeback_case)
    (case_external_reference_link_allowed ?chargeback_case - chargeback_case ?external_reference - external_reference)
    (clearing_instruction_available ?clearing_instruction - clearing_instruction)
    (case_has_external_reference ?chargeback_case - chargeback_case ?external_reference - external_reference)
    (case_accounting_batch_candidate ?chargeback_case - chargeback_case ?accounting_batch - accounting_batch)
    (case_pending_approval ?chargeback_case - chargeback_case)
    (case_external_reference_validated ?chargeback_case - chargeback_case ?external_reference - external_reference)
  )
  (:action unlink_reason_code_from_case
    :parameters (?chargeback_case - chargeback_case ?reason_code - reason_code)
    :precondition
      (and
        (case_has_reason_code ?chargeback_case ?reason_code)
      )
    :effect
      (and
        (reason_code_available ?reason_code)
        (not
          (case_has_reason_code ?chargeback_case ?reason_code)
        )
      )
  )
  (:action apply_resolution_with_accounting_policy
    :parameters (?chargeback_case - chargeback_case ?dispute_record - dispute_record ?reason_code - reason_code ?accounting_policy - accounting_policy)
    :precondition
      (and
        (not
          (case_resolution_eligible ?chargeback_case)
        )
        (case_accounting_aligned ?chargeback_case)
        (case_evidence_verified ?chargeback_case)
        (case_has_reason_code ?chargeback_case ?reason_code)
        (case_auxiliary_tag ?chargeback_case ?accounting_policy)
        (case_has_dispute_record ?chargeback_case ?dispute_record)
      )
    :effect
      (and
        (case_pending_approval ?chargeback_case)
        (case_resolution_eligible ?chargeback_case)
      )
  )
  (:action close_case_operational
    :parameters (?chargeback_case - chargeback_case)
    :precondition
      (and
        (case_evidence_verified ?chargeback_case)
        (case_has_match ?chargeback_case)
        (case_accounting_aligned ?chargeback_case)
        (case_active ?chargeback_case)
        (case_approver_recorded ?chargeback_case)
        (not
          (case_closed ?chargeback_case)
        )
        (operational_routing_flag ?chargeback_case)
        (case_resolution_eligible ?chargeback_case)
      )
    :effect
      (and
        (case_closed ?chargeback_case)
      )
  )
  (:action confirm_accounting_and_clear_followup
    :parameters (?chargeback_case - chargeback_case ?clearing_instruction - clearing_instruction ?merchant_account - merchant_account)
    :precondition
      (and
        (case_accounting_aligned ?chargeback_case)
        (case_requires_followup ?chargeback_case)
        (case_has_clearing_instruction ?chargeback_case ?clearing_instruction)
        (case_has_merchant_account ?chargeback_case ?merchant_account)
      )
    :effect
      (and
        (not
          (case_requires_followup ?chargeback_case)
        )
        (not
          (case_pending_approval ?chargeback_case)
        )
      )
  )
  (:action assign_work_item_to_case
    :parameters (?chargeback_case - chargeback_case ?work_item - work_item)
    :precondition
      (and
        (work_item_available ?work_item)
        (case_active ?chargeback_case)
      )
    :effect
      (and
        (not
          (work_item_available ?work_item)
        )
        (case_work_item_assigned ?chargeback_case ?work_item)
      )
  )
  (:action apply_resolution_method
    :parameters (?chargeback_case - chargeback_case ?clearing_instruction - clearing_instruction ?merchant_account - merchant_account ?resolution_method - resolution_method)
    :precondition
      (and
        (case_auxiliary_tag ?chargeback_case ?resolution_method)
        (case_evidence_verified ?chargeback_case)
        (not
          (case_pending_approval ?chargeback_case)
        )
        (case_has_clearing_instruction ?chargeback_case ?clearing_instruction)
        (case_accounting_aligned ?chargeback_case)
        (case_has_merchant_account ?chargeback_case ?merchant_account)
        (not
          (case_resolution_eligible ?chargeback_case)
        )
      )
    :effect
      (and
        (case_resolution_eligible ?chargeback_case)
      )
  )
  (:action record_external_reference_attestation
    :parameters (?chargeback_case - chargeback_case ?external_reference - external_reference)
    :precondition
      (and
        (case_has_match ?chargeback_case)
        (case_external_reference_validated ?chargeback_case ?external_reference)
        (not
          (case_evidence_verified ?chargeback_case)
        )
      )
    :effect
      (and
        (case_evidence_verified ?chargeback_case)
        (not
          (case_pending_approval ?chargeback_case)
        )
      )
  )
  (:action link_dispute_record_to_case
    :parameters (?chargeback_case - chargeback_case ?dispute_record - dispute_record)
    :precondition
      (and
        (case_dispute_record_candidate ?chargeback_case ?dispute_record)
        (case_active ?chargeback_case)
        (dispute_record_available ?dispute_record)
      )
    :effect
      (and
        (case_has_dispute_record ?chargeback_case ?dispute_record)
        (not
          (dispute_record_available ?dispute_record)
        )
      )
  )
  (:action link_clearing_instruction_to_case
    :parameters (?chargeback_case - chargeback_case ?clearing_instruction - clearing_instruction)
    :precondition
      (and
        (case_active ?chargeback_case)
        (clearing_instruction_available ?clearing_instruction)
        (case_clearing_instruction_candidate ?chargeback_case ?clearing_instruction)
      )
    :effect
      (and
        (not
          (clearing_instruction_available ?clearing_instruction)
        )
        (case_has_clearing_instruction ?chargeback_case ?clearing_instruction)
      )
  )
  (:action unlink_dispute_record_from_case
    :parameters (?chargeback_case - chargeback_case ?dispute_record - dispute_record)
    :precondition
      (and
        (case_has_dispute_record ?chargeback_case ?dispute_record)
      )
    :effect
      (and
        (dispute_record_available ?dispute_record)
        (not
          (case_has_dispute_record ?chargeback_case ?dispute_record)
        )
      )
  )
  (:action unlink_merchant_account_from_case
    :parameters (?chargeback_case - chargeback_case ?merchant_account - merchant_account)
    :precondition
      (and
        (case_has_merchant_account ?chargeback_case ?merchant_account)
      )
    :effect
      (and
        (merchant_account_available ?merchant_account)
        (not
          (case_has_merchant_account ?chargeback_case ?merchant_account)
        )
      )
  )
  (:action associate_external_reference_with_case
    :parameters (?chargeback_case - chargeback_case ?external_reference - external_reference)
    :precondition
      (and
        (case_approver_recorded ?chargeback_case)
        (external_reference_available ?external_reference)
        (case_external_reference_link_allowed ?chargeback_case ?external_reference)
      )
    :effect
      (and
        (case_external_reference_candidate ?chargeback_case ?external_reference)
        (not
          (external_reference_available ?external_reference)
        )
      )
  )
  (:action link_merchant_account_to_case
    :parameters (?chargeback_case - chargeback_case ?merchant_account - merchant_account)
    :precondition
      (and
        (case_active ?chargeback_case)
        (merchant_account_available ?merchant_account)
        (case_merchant_account_candidate ?chargeback_case ?merchant_account)
      )
    :effect
      (and
        (case_has_merchant_account ?chargeback_case ?merchant_account)
        (not
          (merchant_account_available ?merchant_account)
        )
      )
  )
  (:action validate_accounting_alignment_with_batch
    :parameters (?chargeback_case - chargeback_case ?accounting_batch - accounting_batch ?clearing_instruction - clearing_instruction ?merchant_account - merchant_account)
    :precondition
      (and
        (case_has_match ?chargeback_case)
        (accounting_batch_available ?accounting_batch)
        (case_accounting_batch_candidate ?chargeback_case ?accounting_batch)
        (not
          (case_accounting_aligned ?chargeback_case)
        )
        (case_has_merchant_account ?chargeback_case ?merchant_account)
        (case_has_clearing_instruction ?chargeback_case ?clearing_instruction)
      )
    :effect
      (and
        (case_has_accounting_batch ?chargeback_case ?accounting_batch)
        (not
          (accounting_batch_available ?accounting_batch)
        )
        (case_accounting_aligned ?chargeback_case)
      )
  )
  (:action finalize_case_resolution
    :parameters (?chargeback_case - chargeback_case ?clearing_instruction - clearing_instruction ?merchant_account - merchant_account)
    :precondition
      (and
        (case_has_clearing_instruction ?chargeback_case ?clearing_instruction)
        (case_resolution_eligible ?chargeback_case)
        (case_has_merchant_account ?chargeback_case ?merchant_account)
        (case_pending_approval ?chargeback_case)
      )
    :effect
      (and
        (not
          (case_requires_followup ?chargeback_case)
        )
        (not
          (case_pending_approval ?chargeback_case)
        )
        (not
          (case_evidence_verified ?chargeback_case)
        )
        (case_resolved ?chargeback_case)
      )
  )
  (:action release_work_item_from_case
    :parameters (?chargeback_case - chargeback_case ?work_item - work_item)
    :precondition
      (and
        (case_work_item_assigned ?chargeback_case ?work_item)
      )
    :effect
      (and
        (work_item_available ?work_item)
        (not
          (case_work_item_assigned ?chargeback_case ?work_item)
        )
      )
  )
  (:action record_approver_attestation
    :parameters (?chargeback_case - chargeback_case ?work_item - work_item ?approver - approver)
    :precondition
      (and
        (not
          (case_evidence_verified ?chargeback_case)
        )
        (case_has_match ?chargeback_case)
        (approver_available ?approver)
        (case_work_item_assigned ?chargeback_case ?work_item)
        (case_assigned_for_investigation ?chargeback_case)
      )
    :effect
      (and
        (not
          (case_pending_approval ?chargeback_case)
        )
        (case_evidence_verified ?chargeback_case)
      )
  )
  (:action close_case_with_audit_signoff
    :parameters (?chargeback_case - chargeback_case)
    :precondition
      (and
        (case_active ?chargeback_case)
        (audit_routing_flag ?chargeback_case)
        (case_audit_signoff_recorded ?chargeback_case)
        (case_has_match ?chargeback_case)
        (case_evidence_verified ?chargeback_case)
        (not
          (case_closed ?chargeback_case)
        )
        (case_approver_recorded ?chargeback_case)
        (case_accounting_aligned ?chargeback_case)
        (case_resolution_eligible ?chargeback_case)
      )
    :effect
      (and
        (case_closed ?chargeback_case)
      )
  )
  (:action record_audit_signoff
    :parameters (?chargeback_case - chargeback_case ?work_item - work_item ?approver - approver)
    :precondition
      (and
        (case_evidence_verified ?chargeback_case)
        (approver_available ?approver)
        (not
          (case_audit_signoff_recorded ?chargeback_case)
        )
        (case_approver_recorded ?chargeback_case)
        (case_active ?chargeback_case)
        (audit_routing_flag ?chargeback_case)
        (case_work_item_assigned ?chargeback_case ?work_item)
      )
    :effect
      (and
        (case_audit_signoff_recorded ?chargeback_case)
      )
  )
  (:action unlink_clearing_instruction_from_case
    :parameters (?chargeback_case - chargeback_case ?clearing_instruction - clearing_instruction)
    :precondition
      (and
        (case_has_clearing_instruction ?chargeback_case ?clearing_instruction)
      )
    :effect
      (and
        (clearing_instruction_available ?clearing_instruction)
        (not
          (case_has_clearing_instruction ?chargeback_case ?clearing_instruction)
        )
      )
  )
  (:action link_reason_code_to_case
    :parameters (?chargeback_case - chargeback_case ?reason_code - reason_code)
    :precondition
      (and
        (reason_code_available ?reason_code)
        (case_active ?chargeback_case)
        (case_reason_code_candidate ?chargeback_case ?reason_code)
      )
    :effect
      (and
        (case_has_reason_code ?chargeback_case ?reason_code)
        (not
          (reason_code_available ?reason_code)
        )
      )
  )
  (:action activate_chargeback_case
    :parameters (?chargeback_case - chargeback_case)
    :precondition
      (and
        (not
          (case_active ?chargeback_case)
        )
        (not
          (case_closed ?chargeback_case)
        )
      )
    :effect
      (and
        (case_active ?chargeback_case)
      )
  )
  (:action assign_analyst_to_case
    :parameters (?chargeback_case - chargeback_case ?analyst - analyst)
    :precondition
      (and
        (not
          (case_assigned_for_investigation ?chargeback_case)
        )
        (case_active ?chargeback_case)
        (analyst_available ?analyst)
        (case_has_match ?chargeback_case)
      )
    :effect
      (and
        (case_pending_approval ?chargeback_case)
        (not
          (analyst_available ?analyst)
        )
        (case_assigned_for_investigation ?chargeback_case)
      )
  )
  (:action validate_accounting_with_dispute_and_evidence
    :parameters (?chargeback_case - chargeback_case ?accounting_batch - accounting_batch ?dispute_record - dispute_record ?evidence_document - evidence_document)
    :precondition
      (and
        (evidence_document_available ?evidence_document)
        (case_evidence_document_candidate ?chargeback_case ?evidence_document)
        (not
          (case_accounting_aligned ?chargeback_case)
        )
        (case_has_match ?chargeback_case)
        (accounting_batch_available ?accounting_batch)
        (case_accounting_batch_candidate ?chargeback_case ?accounting_batch)
        (case_has_dispute_record ?chargeback_case ?dispute_record)
      )
    :effect
      (and
        (case_has_accounting_batch ?chargeback_case ?accounting_batch)
        (not
          (evidence_document_available ?evidence_document)
        )
        (case_requires_followup ?chargeback_case)
        (not
          (accounting_batch_available ?accounting_batch)
        )
        (case_pending_approval ?chargeback_case)
        (case_accounting_aligned ?chargeback_case)
      )
  )
  (:action record_approver_assignment_by_analyst
    :parameters (?chargeback_case - chargeback_case ?analyst - analyst)
    :precondition
      (and
        (analyst_available ?analyst)
        (not
          (case_pending_approval ?chargeback_case)
        )
        (case_evidence_verified ?chargeback_case)
        (case_resolution_eligible ?chargeback_case)
        (not
          (case_approver_recorded ?chargeback_case)
        )
      )
    :effect
      (and
        (case_approver_recorded ?chargeback_case)
        (not
          (analyst_available ?analyst)
        )
      )
  )
  (:action unlink_source_transaction_from_case
    :parameters (?chargeback_case - chargeback_case ?source_transaction - source_transaction)
    :precondition
      (and
        (case_has_source_transaction ?chargeback_case ?source_transaction)
        (not
          (case_resolution_eligible ?chargeback_case)
        )
        (not
          (case_accounting_aligned ?chargeback_case)
        )
      )
    :effect
      (and
        (not
          (case_has_source_transaction ?chargeback_case ?source_transaction)
        )
        (source_transaction_available ?source_transaction)
        (not
          (case_has_match ?chargeback_case)
        )
        (not
          (case_assigned_for_investigation ?chargeback_case)
        )
        (not
          (case_resolved ?chargeback_case)
        )
        (not
          (case_evidence_verified ?chargeback_case)
        )
        (not
          (case_requires_followup ?chargeback_case)
        )
        (not
          (case_pending_approval ?chargeback_case)
        )
      )
  )
  (:action record_approver_assignment
    :parameters (?chargeback_case - chargeback_case ?work_item - work_item)
    :precondition
      (and
        (not
          (case_approver_recorded ?chargeback_case)
        )
        (case_work_item_assigned ?chargeback_case ?work_item)
        (case_evidence_verified ?chargeback_case)
        (case_resolution_eligible ?chargeback_case)
        (not
          (case_pending_approval ?chargeback_case)
        )
      )
    :effect
      (and
        (case_approver_recorded ?chargeback_case)
      )
  )
  (:action close_case_with_external_reference
    :parameters (?chargeback_case - chargeback_case ?external_reference - external_reference)
    :precondition
      (and
        (case_approver_recorded ?chargeback_case)
        (case_resolution_eligible ?chargeback_case)
        (case_accounting_aligned ?chargeback_case)
        (case_external_reference_validated ?chargeback_case ?external_reference)
        (case_evidence_verified ?chargeback_case)
        (case_has_match ?chargeback_case)
        (case_active ?chargeback_case)
        (not
          (case_closed ?chargeback_case)
        )
        (audit_routing_flag ?chargeback_case)
      )
    :effect
      (and
        (case_closed ?chargeback_case)
      )
  )
  (:action record_investigation_assignment
    :parameters (?chargeback_case - chargeback_case ?work_item - work_item)
    :precondition
      (and
        (case_active ?chargeback_case)
        (case_has_match ?chargeback_case)
        (not
          (case_assigned_for_investigation ?chargeback_case)
        )
        (case_work_item_assigned ?chargeback_case ?work_item)
      )
    :effect
      (and
        (case_assigned_for_investigation ?chargeback_case)
      )
  )
  (:action link_source_transaction_to_case
    :parameters (?chargeback_case - chargeback_case ?source_transaction - source_transaction)
    :precondition
      (and
        (not
          (case_has_match ?chargeback_case)
        )
        (case_active ?chargeback_case)
        (source_transaction_available ?source_transaction)
        (case_source_transaction_candidate ?chargeback_case ?source_transaction)
      )
    :effect
      (and
        (case_has_match ?chargeback_case)
        (not
          (source_transaction_available ?source_transaction)
        )
        (case_has_source_transaction ?chargeback_case ?source_transaction)
      )
  )
  (:action collect_evidence_with_approver
    :parameters (?chargeback_case - chargeback_case ?work_item - work_item ?approver - approver)
    :precondition
      (and
        (case_has_match ?chargeback_case)
        (not
          (case_evidence_verified ?chargeback_case)
        )
        (case_work_item_assigned ?chargeback_case ?work_item)
        (case_resolution_eligible ?chargeback_case)
        (approver_available ?approver)
        (case_resolved ?chargeback_case)
      )
    :effect
      (and
        (case_evidence_verified ?chargeback_case)
      )
  )
  (:action cross_reference_external_reference_for_closure
    :parameters (?audit_case - audit_case ?operational_case - operational_case ?external_reference - external_reference)
    :precondition
      (and
        (case_active ?audit_case)
        (case_external_reference_candidate ?operational_case ?external_reference)
        (audit_routing_flag ?audit_case)
        (not
          (case_external_reference_validated ?audit_case ?external_reference)
        )
        (case_has_external_reference ?audit_case ?external_reference)
      )
    :effect
      (and
        (case_external_reference_validated ?audit_case ?external_reference)
      )
  )
)

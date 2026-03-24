(define (domain journal_entry_validation)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource - object artifact - object reconciliation_component - object journal_entry_class - object journal_entry - journal_entry_class approver - resource automated_validation_rule - resource human_reviewer - resource approval_policy - resource reporting_dimension - resource evidence_snapshot - resource control_procedure - resource audit_query - resource supporting_document - artifact audit_evidence - artifact external_reference - artifact reconciliation_key_local - reconciliation_component reconciliation_key_remote - reconciliation_component validation_batch - reconciliation_component posting_scope - journal_entry validation_scope - journal_entry subledger_account - posting_scope general_ledger_account - posting_scope validation_case - validation_scope)
  (:predicates
    (entity_submitted ?journal_entry - journal_entry)
    (entity_validated ?journal_entry - journal_entry)
    (entity_assigned_for_approval ?journal_entry - journal_entry)
    (posted ?journal_entry - journal_entry)
    (entity_ready_for_posting ?journal_entry - journal_entry)
    (posting_authorized ?journal_entry - journal_entry)
    (approver_available ?approver - approver)
    (entity_assigned_to_approver ?journal_entry - journal_entry ?approver - approver)
    (automated_rule_available ?automated_validation_rule - automated_validation_rule)
    (entity_claimed_by_automated_rule ?journal_entry - journal_entry ?automated_validation_rule - automated_validation_rule)
    (reviewer_available ?human_reviewer - human_reviewer)
    (entity_assigned_to_reviewer ?journal_entry - journal_entry ?human_reviewer - human_reviewer)
    (supporting_document_available ?supporting_document - supporting_document)
    (subledger_document_attached ?subledger_account - subledger_account ?supporting_document - supporting_document)
    (gl_document_attached ?general_ledger_account - general_ledger_account ?supporting_document - supporting_document)
    (subledger_has_local_key ?subledger_account - subledger_account ?reconciliation_key_local - reconciliation_key_local)
    (local_key_ready ?reconciliation_key_local - reconciliation_key_local)
    (local_key_documented ?reconciliation_key_local - reconciliation_key_local)
    (subledger_reconciled ?subledger_account - subledger_account)
    (gl_account_has_remote_key ?general_ledger_account - general_ledger_account ?reconciliation_key_remote - reconciliation_key_remote)
    (remote_key_ready ?reconciliation_key_remote - reconciliation_key_remote)
    (remote_key_documented ?reconciliation_key_remote - reconciliation_key_remote)
    (general_ledger_reconciled ?general_ledger_account - general_ledger_account)
    (validation_batch_available ?validation_batch - validation_batch)
    (validation_batch_compiled ?validation_batch - validation_batch)
    (batch_includes_local_key ?validation_batch - validation_batch ?reconciliation_key_local - reconciliation_key_local)
    (batch_includes_remote_key ?validation_batch - validation_batch ?reconciliation_key_remote - reconciliation_key_remote)
    (batch_local_flag ?validation_batch - validation_batch)
    (batch_remote_flag ?validation_batch - validation_batch)
    (validation_batch_finalized ?validation_batch - validation_batch)
    (case_has_subledger_account ?validation_case - validation_case ?subledger_account - subledger_account)
    (case_has_gl_account ?validation_case - validation_case ?general_ledger_account - general_ledger_account)
    (case_in_batch ?validation_case - validation_case ?validation_batch - validation_batch)
    (audit_evidence_available ?audit_evidence - audit_evidence)
    (case_has_audit_evidence ?validation_case - validation_case ?audit_evidence - audit_evidence)
    (audit_evidence_certified ?audit_evidence - audit_evidence)
    (audit_evidence_linked_to_batch ?audit_evidence - audit_evidence ?validation_batch - validation_batch)
    (case_evidence_reviewed ?validation_case - validation_case)
    (case_control_procedure_applied ?validation_case - validation_case)
    (case_ready_for_finalization ?validation_case - validation_case)
    (case_policy_attached ?validation_case - validation_case)
    (case_policy_certified ?validation_case - validation_case)
    (case_reporting_dimension_present ?validation_case - validation_case)
    (case_control_procedures_executed ?validation_case - validation_case)
    (external_reference_available ?external_reference - external_reference)
    (case_has_external_reference ?validation_case - validation_case ?external_reference - external_reference)
    (case_policy_triggered ?validation_case - validation_case)
    (case_policy_approval_recorded ?validation_case - validation_case)
    (case_policy_satisfied ?validation_case - validation_case)
    (approval_policy_available ?approval_policy - approval_policy)
    (case_has_approval_policy ?validation_case - validation_case ?approval_policy - approval_policy)
    (reporting_dimension_available ?reporting_dimension - reporting_dimension)
    (case_has_reporting_dimension ?validation_case - validation_case ?reporting_dimension - reporting_dimension)
    (control_procedure_available ?control_procedure - control_procedure)
    (control_procedure_attached_to_case ?validation_case - validation_case ?control_procedure - control_procedure)
    (audit_query_available ?audit_query - audit_query)
    (audit_query_attached_to_case ?validation_case - validation_case ?audit_query - audit_query)
    (evidence_snapshot_available ?evidence_snapshot - evidence_snapshot)
    (entity_linked_to_evidence_snapshot ?journal_entry - journal_entry ?evidence_snapshot - evidence_snapshot)
    (subledger_ready_for_compilation ?subledger_account - subledger_account)
    (gl_ready_for_compilation ?general_ledger_account - general_ledger_account)
    (case_closed ?validation_case - validation_case)
  )
  (:action submit_journal_entry
    :parameters (?journal_entry - journal_entry)
    :precondition
      (and
        (not
          (entity_submitted ?journal_entry)
        )
        (not
          (posted ?journal_entry)
        )
      )
    :effect (entity_submitted ?journal_entry)
  )
  (:action assign_journal_entry_to_approver
    :parameters (?journal_entry - journal_entry ?approver - approver)
    :precondition
      (and
        (entity_submitted ?journal_entry)
        (not
          (entity_assigned_for_approval ?journal_entry)
        )
        (approver_available ?approver)
      )
    :effect
      (and
        (entity_assigned_for_approval ?journal_entry)
        (entity_assigned_to_approver ?journal_entry ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action claim_automated_rule_for_entry
    :parameters (?journal_entry - journal_entry ?automated_validation_rule - automated_validation_rule)
    :precondition
      (and
        (entity_submitted ?journal_entry)
        (entity_assigned_for_approval ?journal_entry)
        (automated_rule_available ?automated_validation_rule)
      )
    :effect
      (and
        (entity_claimed_by_automated_rule ?journal_entry ?automated_validation_rule)
        (not
          (automated_rule_available ?automated_validation_rule)
        )
      )
  )
  (:action finalize_automated_validation_for_entry
    :parameters (?journal_entry - journal_entry ?automated_validation_rule - automated_validation_rule)
    :precondition
      (and
        (entity_submitted ?journal_entry)
        (entity_assigned_for_approval ?journal_entry)
        (entity_claimed_by_automated_rule ?journal_entry ?automated_validation_rule)
        (not
          (entity_validated ?journal_entry)
        )
      )
    :effect (entity_validated ?journal_entry)
  )
  (:action release_automated_rule_from_entry
    :parameters (?journal_entry - journal_entry ?automated_validation_rule - automated_validation_rule)
    :precondition
      (and
        (entity_claimed_by_automated_rule ?journal_entry ?automated_validation_rule)
      )
    :effect
      (and
        (automated_rule_available ?automated_validation_rule)
        (not
          (entity_claimed_by_automated_rule ?journal_entry ?automated_validation_rule)
        )
      )
  )
  (:action assign_entry_to_human_reviewer
    :parameters (?journal_entry - journal_entry ?human_reviewer - human_reviewer)
    :precondition
      (and
        (entity_validated ?journal_entry)
        (reviewer_available ?human_reviewer)
      )
    :effect
      (and
        (entity_assigned_to_reviewer ?journal_entry ?human_reviewer)
        (not
          (reviewer_available ?human_reviewer)
        )
      )
  )
  (:action release_human_reviewer_from_entry
    :parameters (?journal_entry - journal_entry ?human_reviewer - human_reviewer)
    :precondition
      (and
        (entity_assigned_to_reviewer ?journal_entry ?human_reviewer)
      )
    :effect
      (and
        (reviewer_available ?human_reviewer)
        (not
          (entity_assigned_to_reviewer ?journal_entry ?human_reviewer)
        )
      )
  )
  (:action attach_control_procedure_to_case
    :parameters (?validation_case - validation_case ?control_procedure - control_procedure)
    :precondition
      (and
        (entity_validated ?validation_case)
        (control_procedure_available ?control_procedure)
      )
    :effect
      (and
        (control_procedure_attached_to_case ?validation_case ?control_procedure)
        (not
          (control_procedure_available ?control_procedure)
        )
      )
  )
  (:action remove_control_procedure_from_case
    :parameters (?validation_case - validation_case ?control_procedure - control_procedure)
    :precondition
      (and
        (control_procedure_attached_to_case ?validation_case ?control_procedure)
      )
    :effect
      (and
        (control_procedure_available ?control_procedure)
        (not
          (control_procedure_attached_to_case ?validation_case ?control_procedure)
        )
      )
  )
  (:action attach_audit_query_to_case
    :parameters (?validation_case - validation_case ?audit_query - audit_query)
    :precondition
      (and
        (entity_validated ?validation_case)
        (audit_query_available ?audit_query)
      )
    :effect
      (and
        (audit_query_attached_to_case ?validation_case ?audit_query)
        (not
          (audit_query_available ?audit_query)
        )
      )
  )
  (:action detach_audit_query_from_case
    :parameters (?validation_case - validation_case ?audit_query - audit_query)
    :precondition
      (and
        (audit_query_attached_to_case ?validation_case ?audit_query)
      )
    :effect
      (and
        (audit_query_available ?audit_query)
        (not
          (audit_query_attached_to_case ?validation_case ?audit_query)
        )
      )
  )
  (:action prepare_local_reconciliation_key
    :parameters (?subledger_account - subledger_account ?reconciliation_key_local - reconciliation_key_local ?automated_validation_rule - automated_validation_rule)
    :precondition
      (and
        (entity_validated ?subledger_account)
        (entity_claimed_by_automated_rule ?subledger_account ?automated_validation_rule)
        (subledger_has_local_key ?subledger_account ?reconciliation_key_local)
        (not
          (local_key_ready ?reconciliation_key_local)
        )
        (not
          (local_key_documented ?reconciliation_key_local)
        )
      )
    :effect (local_key_ready ?reconciliation_key_local)
  )
  (:action assign_reviewer_for_subledger_reconciliation
    :parameters (?subledger_account - subledger_account ?reconciliation_key_local - reconciliation_key_local ?human_reviewer - human_reviewer)
    :precondition
      (and
        (entity_validated ?subledger_account)
        (entity_assigned_to_reviewer ?subledger_account ?human_reviewer)
        (subledger_has_local_key ?subledger_account ?reconciliation_key_local)
        (local_key_ready ?reconciliation_key_local)
        (not
          (subledger_ready_for_compilation ?subledger_account)
        )
      )
    :effect
      (and
        (subledger_ready_for_compilation ?subledger_account)
        (subledger_reconciled ?subledger_account)
      )
  )
  (:action attach_supporting_document_to_subledger_account
    :parameters (?subledger_account - subledger_account ?reconciliation_key_local - reconciliation_key_local ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?subledger_account)
        (subledger_has_local_key ?subledger_account ?reconciliation_key_local)
        (supporting_document_available ?supporting_document)
        (not
          (subledger_ready_for_compilation ?subledger_account)
        )
      )
    :effect
      (and
        (local_key_documented ?reconciliation_key_local)
        (subledger_ready_for_compilation ?subledger_account)
        (subledger_document_attached ?subledger_account ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action complete_subledger_reconciliation_with_document
    :parameters (?subledger_account - subledger_account ?reconciliation_key_local - reconciliation_key_local ?automated_validation_rule - automated_validation_rule ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?subledger_account)
        (entity_claimed_by_automated_rule ?subledger_account ?automated_validation_rule)
        (subledger_has_local_key ?subledger_account ?reconciliation_key_local)
        (local_key_documented ?reconciliation_key_local)
        (subledger_document_attached ?subledger_account ?supporting_document)
        (not
          (subledger_reconciled ?subledger_account)
        )
      )
    :effect
      (and
        (local_key_ready ?reconciliation_key_local)
        (subledger_reconciled ?subledger_account)
        (supporting_document_available ?supporting_document)
        (not
          (subledger_document_attached ?subledger_account ?supporting_document)
        )
      )
  )
  (:action prepare_remote_reconciliation_key
    :parameters (?general_ledger_account - general_ledger_account ?reconciliation_key_remote - reconciliation_key_remote ?automated_validation_rule - automated_validation_rule)
    :precondition
      (and
        (entity_validated ?general_ledger_account)
        (entity_claimed_by_automated_rule ?general_ledger_account ?automated_validation_rule)
        (gl_account_has_remote_key ?general_ledger_account ?reconciliation_key_remote)
        (not
          (remote_key_ready ?reconciliation_key_remote)
        )
        (not
          (remote_key_documented ?reconciliation_key_remote)
        )
      )
    :effect (remote_key_ready ?reconciliation_key_remote)
  )
  (:action assign_reviewer_for_gl_reconciliation
    :parameters (?general_ledger_account - general_ledger_account ?reconciliation_key_remote - reconciliation_key_remote ?human_reviewer - human_reviewer)
    :precondition
      (and
        (entity_validated ?general_ledger_account)
        (entity_assigned_to_reviewer ?general_ledger_account ?human_reviewer)
        (gl_account_has_remote_key ?general_ledger_account ?reconciliation_key_remote)
        (remote_key_ready ?reconciliation_key_remote)
        (not
          (gl_ready_for_compilation ?general_ledger_account)
        )
      )
    :effect
      (and
        (gl_ready_for_compilation ?general_ledger_account)
        (general_ledger_reconciled ?general_ledger_account)
      )
  )
  (:action attach_supporting_document_to_gl_account
    :parameters (?general_ledger_account - general_ledger_account ?reconciliation_key_remote - reconciliation_key_remote ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?general_ledger_account)
        (gl_account_has_remote_key ?general_ledger_account ?reconciliation_key_remote)
        (supporting_document_available ?supporting_document)
        (not
          (gl_ready_for_compilation ?general_ledger_account)
        )
      )
    :effect
      (and
        (remote_key_documented ?reconciliation_key_remote)
        (gl_ready_for_compilation ?general_ledger_account)
        (gl_document_attached ?general_ledger_account ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action complete_gl_reconciliation_with_document
    :parameters (?general_ledger_account - general_ledger_account ?reconciliation_key_remote - reconciliation_key_remote ?automated_validation_rule - automated_validation_rule ?supporting_document - supporting_document)
    :precondition
      (and
        (entity_validated ?general_ledger_account)
        (entity_claimed_by_automated_rule ?general_ledger_account ?automated_validation_rule)
        (gl_account_has_remote_key ?general_ledger_account ?reconciliation_key_remote)
        (remote_key_documented ?reconciliation_key_remote)
        (gl_document_attached ?general_ledger_account ?supporting_document)
        (not
          (general_ledger_reconciled ?general_ledger_account)
        )
      )
    :effect
      (and
        (remote_key_ready ?reconciliation_key_remote)
        (general_ledger_reconciled ?general_ledger_account)
        (supporting_document_available ?supporting_document)
        (not
          (gl_document_attached ?general_ledger_account ?supporting_document)
        )
      )
  )
  (:action assemble_validation_batch
    :parameters (?subledger_account - subledger_account ?general_ledger_account - general_ledger_account ?reconciliation_key_local - reconciliation_key_local ?reconciliation_key_remote - reconciliation_key_remote ?validation_batch - validation_batch)
    :precondition
      (and
        (subledger_ready_for_compilation ?subledger_account)
        (gl_ready_for_compilation ?general_ledger_account)
        (subledger_has_local_key ?subledger_account ?reconciliation_key_local)
        (gl_account_has_remote_key ?general_ledger_account ?reconciliation_key_remote)
        (local_key_ready ?reconciliation_key_local)
        (remote_key_ready ?reconciliation_key_remote)
        (subledger_reconciled ?subledger_account)
        (general_ledger_reconciled ?general_ledger_account)
        (validation_batch_available ?validation_batch)
      )
    :effect
      (and
        (validation_batch_compiled ?validation_batch)
        (batch_includes_local_key ?validation_batch ?reconciliation_key_local)
        (batch_includes_remote_key ?validation_batch ?reconciliation_key_remote)
        (not
          (validation_batch_available ?validation_batch)
        )
      )
  )
  (:action assemble_validation_batch_local_flag
    :parameters (?subledger_account - subledger_account ?general_ledger_account - general_ledger_account ?reconciliation_key_local - reconciliation_key_local ?reconciliation_key_remote - reconciliation_key_remote ?validation_batch - validation_batch)
    :precondition
      (and
        (subledger_ready_for_compilation ?subledger_account)
        (gl_ready_for_compilation ?general_ledger_account)
        (subledger_has_local_key ?subledger_account ?reconciliation_key_local)
        (gl_account_has_remote_key ?general_ledger_account ?reconciliation_key_remote)
        (local_key_documented ?reconciliation_key_local)
        (remote_key_ready ?reconciliation_key_remote)
        (not
          (subledger_reconciled ?subledger_account)
        )
        (general_ledger_reconciled ?general_ledger_account)
        (validation_batch_available ?validation_batch)
      )
    :effect
      (and
        (validation_batch_compiled ?validation_batch)
        (batch_includes_local_key ?validation_batch ?reconciliation_key_local)
        (batch_includes_remote_key ?validation_batch ?reconciliation_key_remote)
        (batch_local_flag ?validation_batch)
        (not
          (validation_batch_available ?validation_batch)
        )
      )
  )
  (:action assemble_validation_batch_remote_flag
    :parameters (?subledger_account - subledger_account ?general_ledger_account - general_ledger_account ?reconciliation_key_local - reconciliation_key_local ?reconciliation_key_remote - reconciliation_key_remote ?validation_batch - validation_batch)
    :precondition
      (and
        (subledger_ready_for_compilation ?subledger_account)
        (gl_ready_for_compilation ?general_ledger_account)
        (subledger_has_local_key ?subledger_account ?reconciliation_key_local)
        (gl_account_has_remote_key ?general_ledger_account ?reconciliation_key_remote)
        (local_key_ready ?reconciliation_key_local)
        (remote_key_documented ?reconciliation_key_remote)
        (subledger_reconciled ?subledger_account)
        (not
          (general_ledger_reconciled ?general_ledger_account)
        )
        (validation_batch_available ?validation_batch)
      )
    :effect
      (and
        (validation_batch_compiled ?validation_batch)
        (batch_includes_local_key ?validation_batch ?reconciliation_key_local)
        (batch_includes_remote_key ?validation_batch ?reconciliation_key_remote)
        (batch_remote_flag ?validation_batch)
        (not
          (validation_batch_available ?validation_batch)
        )
      )
  )
  (:action assemble_validation_batch_full_flags
    :parameters (?subledger_account - subledger_account ?general_ledger_account - general_ledger_account ?reconciliation_key_local - reconciliation_key_local ?reconciliation_key_remote - reconciliation_key_remote ?validation_batch - validation_batch)
    :precondition
      (and
        (subledger_ready_for_compilation ?subledger_account)
        (gl_ready_for_compilation ?general_ledger_account)
        (subledger_has_local_key ?subledger_account ?reconciliation_key_local)
        (gl_account_has_remote_key ?general_ledger_account ?reconciliation_key_remote)
        (local_key_documented ?reconciliation_key_local)
        (remote_key_documented ?reconciliation_key_remote)
        (not
          (subledger_reconciled ?subledger_account)
        )
        (not
          (general_ledger_reconciled ?general_ledger_account)
        )
        (validation_batch_available ?validation_batch)
      )
    :effect
      (and
        (validation_batch_compiled ?validation_batch)
        (batch_includes_local_key ?validation_batch ?reconciliation_key_local)
        (batch_includes_remote_key ?validation_batch ?reconciliation_key_remote)
        (batch_local_flag ?validation_batch)
        (batch_remote_flag ?validation_batch)
        (not
          (validation_batch_available ?validation_batch)
        )
      )
  )
  (:action finalize_validation_batch
    :parameters (?validation_batch - validation_batch ?subledger_account - subledger_account ?automated_validation_rule - automated_validation_rule)
    :precondition
      (and
        (validation_batch_compiled ?validation_batch)
        (subledger_ready_for_compilation ?subledger_account)
        (entity_claimed_by_automated_rule ?subledger_account ?automated_validation_rule)
        (not
          (validation_batch_finalized ?validation_batch)
        )
      )
    :effect (validation_batch_finalized ?validation_batch)
  )
  (:action certify_audit_evidence_and_associate_with_batch
    :parameters (?validation_case - validation_case ?audit_evidence - audit_evidence ?validation_batch - validation_batch)
    :precondition
      (and
        (entity_validated ?validation_case)
        (case_in_batch ?validation_case ?validation_batch)
        (case_has_audit_evidence ?validation_case ?audit_evidence)
        (audit_evidence_available ?audit_evidence)
        (validation_batch_compiled ?validation_batch)
        (validation_batch_finalized ?validation_batch)
        (not
          (audit_evidence_certified ?audit_evidence)
        )
      )
    :effect
      (and
        (audit_evidence_certified ?audit_evidence)
        (audit_evidence_linked_to_batch ?audit_evidence ?validation_batch)
        (not
          (audit_evidence_available ?audit_evidence)
        )
      )
  )
  (:action flag_case_evidence_reviewed
    :parameters (?validation_case - validation_case ?audit_evidence - audit_evidence ?validation_batch - validation_batch ?automated_validation_rule - automated_validation_rule)
    :precondition
      (and
        (entity_validated ?validation_case)
        (case_has_audit_evidence ?validation_case ?audit_evidence)
        (audit_evidence_certified ?audit_evidence)
        (audit_evidence_linked_to_batch ?audit_evidence ?validation_batch)
        (entity_claimed_by_automated_rule ?validation_case ?automated_validation_rule)
        (not
          (batch_local_flag ?validation_batch)
        )
        (not
          (case_evidence_reviewed ?validation_case)
        )
      )
    :effect (case_evidence_reviewed ?validation_case)
  )
  (:action apply_approval_policy_to_case
    :parameters (?validation_case - validation_case ?approval_policy - approval_policy)
    :precondition
      (and
        (entity_validated ?validation_case)
        (approval_policy_available ?approval_policy)
        (not
          (case_policy_attached ?validation_case)
        )
      )
    :effect
      (and
        (case_policy_attached ?validation_case)
        (case_has_approval_policy ?validation_case ?approval_policy)
        (not
          (approval_policy_available ?approval_policy)
        )
      )
  )
  (:action process_case_policy_and_mark_for_review
    :parameters (?validation_case - validation_case ?audit_evidence - audit_evidence ?validation_batch - validation_batch ?automated_validation_rule - automated_validation_rule ?approval_policy - approval_policy)
    :precondition
      (and
        (entity_validated ?validation_case)
        (case_has_audit_evidence ?validation_case ?audit_evidence)
        (audit_evidence_certified ?audit_evidence)
        (audit_evidence_linked_to_batch ?audit_evidence ?validation_batch)
        (entity_claimed_by_automated_rule ?validation_case ?automated_validation_rule)
        (batch_local_flag ?validation_batch)
        (case_policy_attached ?validation_case)
        (case_has_approval_policy ?validation_case ?approval_policy)
        (not
          (case_evidence_reviewed ?validation_case)
        )
      )
    :effect
      (and
        (case_evidence_reviewed ?validation_case)
        (case_policy_certified ?validation_case)
      )
  )
  (:action apply_control_procedure_phase1
    :parameters (?validation_case - validation_case ?control_procedure - control_procedure ?human_reviewer - human_reviewer ?audit_evidence - audit_evidence ?validation_batch - validation_batch)
    :precondition
      (and
        (case_evidence_reviewed ?validation_case)
        (control_procedure_attached_to_case ?validation_case ?control_procedure)
        (entity_assigned_to_reviewer ?validation_case ?human_reviewer)
        (case_has_audit_evidence ?validation_case ?audit_evidence)
        (audit_evidence_linked_to_batch ?audit_evidence ?validation_batch)
        (not
          (batch_remote_flag ?validation_batch)
        )
        (not
          (case_control_procedure_applied ?validation_case)
        )
      )
    :effect (case_control_procedure_applied ?validation_case)
  )
  (:action apply_control_procedure_phase2
    :parameters (?validation_case - validation_case ?control_procedure - control_procedure ?human_reviewer - human_reviewer ?audit_evidence - audit_evidence ?validation_batch - validation_batch)
    :precondition
      (and
        (case_evidence_reviewed ?validation_case)
        (control_procedure_attached_to_case ?validation_case ?control_procedure)
        (entity_assigned_to_reviewer ?validation_case ?human_reviewer)
        (case_has_audit_evidence ?validation_case ?audit_evidence)
        (audit_evidence_linked_to_batch ?audit_evidence ?validation_batch)
        (batch_remote_flag ?validation_batch)
        (not
          (case_control_procedure_applied ?validation_case)
        )
      )
    :effect (case_control_procedure_applied ?validation_case)
  )
  (:action apply_audit_query_and_mark_review
    :parameters (?validation_case - validation_case ?audit_query - audit_query ?audit_evidence - audit_evidence ?validation_batch - validation_batch)
    :precondition
      (and
        (case_control_procedure_applied ?validation_case)
        (audit_query_attached_to_case ?validation_case ?audit_query)
        (case_has_audit_evidence ?validation_case ?audit_evidence)
        (audit_evidence_linked_to_batch ?audit_evidence ?validation_batch)
        (not
          (batch_local_flag ?validation_batch)
        )
        (not
          (batch_remote_flag ?validation_batch)
        )
        (not
          (case_ready_for_finalization ?validation_case)
        )
      )
    :effect (case_ready_for_finalization ?validation_case)
  )
  (:action apply_audit_query_and_attach_reporting_dimension
    :parameters (?validation_case - validation_case ?audit_query - audit_query ?audit_evidence - audit_evidence ?validation_batch - validation_batch)
    :precondition
      (and
        (case_control_procedure_applied ?validation_case)
        (audit_query_attached_to_case ?validation_case ?audit_query)
        (case_has_audit_evidence ?validation_case ?audit_evidence)
        (audit_evidence_linked_to_batch ?audit_evidence ?validation_batch)
        (batch_local_flag ?validation_batch)
        (not
          (batch_remote_flag ?validation_batch)
        )
        (not
          (case_ready_for_finalization ?validation_case)
        )
      )
    :effect
      (and
        (case_ready_for_finalization ?validation_case)
        (case_reporting_dimension_present ?validation_case)
      )
  )
  (:action apply_audit_query_with_remote_flag
    :parameters (?validation_case - validation_case ?audit_query - audit_query ?audit_evidence - audit_evidence ?validation_batch - validation_batch)
    :precondition
      (and
        (case_control_procedure_applied ?validation_case)
        (audit_query_attached_to_case ?validation_case ?audit_query)
        (case_has_audit_evidence ?validation_case ?audit_evidence)
        (audit_evidence_linked_to_batch ?audit_evidence ?validation_batch)
        (not
          (batch_local_flag ?validation_batch)
        )
        (batch_remote_flag ?validation_batch)
        (not
          (case_ready_for_finalization ?validation_case)
        )
      )
    :effect
      (and
        (case_ready_for_finalization ?validation_case)
        (case_reporting_dimension_present ?validation_case)
      )
  )
  (:action apply_audit_query_and_finalize_reporting
    :parameters (?validation_case - validation_case ?audit_query - audit_query ?audit_evidence - audit_evidence ?validation_batch - validation_batch)
    :precondition
      (and
        (case_control_procedure_applied ?validation_case)
        (audit_query_attached_to_case ?validation_case ?audit_query)
        (case_has_audit_evidence ?validation_case ?audit_evidence)
        (audit_evidence_linked_to_batch ?audit_evidence ?validation_batch)
        (batch_local_flag ?validation_batch)
        (batch_remote_flag ?validation_batch)
        (not
          (case_ready_for_finalization ?validation_case)
        )
      )
    :effect
      (and
        (case_ready_for_finalization ?validation_case)
        (case_reporting_dimension_present ?validation_case)
      )
  )
  (:action close_validation_case
    :parameters (?validation_case - validation_case)
    :precondition
      (and
        (case_ready_for_finalization ?validation_case)
        (not
          (case_reporting_dimension_present ?validation_case)
        )
        (not
          (case_closed ?validation_case)
        )
      )
    :effect
      (and
        (case_closed ?validation_case)
        (entity_ready_for_posting ?validation_case)
      )
  )
  (:action attach_reporting_dimension_to_case
    :parameters (?validation_case - validation_case ?reporting_dimension - reporting_dimension)
    :precondition
      (and
        (case_ready_for_finalization ?validation_case)
        (case_reporting_dimension_present ?validation_case)
        (reporting_dimension_available ?reporting_dimension)
      )
    :effect
      (and
        (case_has_reporting_dimension ?validation_case ?reporting_dimension)
        (not
          (reporting_dimension_available ?reporting_dimension)
        )
      )
  )
  (:action apply_final_control_and_mark_case_reviewed
    :parameters (?validation_case - validation_case ?subledger_account - subledger_account ?general_ledger_account - general_ledger_account ?automated_validation_rule - automated_validation_rule ?reporting_dimension - reporting_dimension)
    :precondition
      (and
        (case_ready_for_finalization ?validation_case)
        (case_reporting_dimension_present ?validation_case)
        (case_has_reporting_dimension ?validation_case ?reporting_dimension)
        (case_has_subledger_account ?validation_case ?subledger_account)
        (case_has_gl_account ?validation_case ?general_ledger_account)
        (subledger_reconciled ?subledger_account)
        (general_ledger_reconciled ?general_ledger_account)
        (entity_claimed_by_automated_rule ?validation_case ?automated_validation_rule)
        (not
          (case_control_procedures_executed ?validation_case)
        )
      )
    :effect (case_control_procedures_executed ?validation_case)
  )
  (:action finalize_case_review
    :parameters (?validation_case - validation_case)
    :precondition
      (and
        (case_ready_for_finalization ?validation_case)
        (case_control_procedures_executed ?validation_case)
        (not
          (case_closed ?validation_case)
        )
      )
    :effect
      (and
        (case_closed ?validation_case)
        (entity_ready_for_posting ?validation_case)
      )
  )
  (:action attach_external_reference_to_case
    :parameters (?validation_case - validation_case ?external_reference - external_reference ?automated_validation_rule - automated_validation_rule)
    :precondition
      (and
        (entity_validated ?validation_case)
        (entity_claimed_by_automated_rule ?validation_case ?automated_validation_rule)
        (external_reference_available ?external_reference)
        (case_has_external_reference ?validation_case ?external_reference)
        (not
          (case_policy_triggered ?validation_case)
        )
      )
    :effect
      (and
        (case_policy_triggered ?validation_case)
        (not
          (external_reference_available ?external_reference)
        )
      )
  )
  (:action record_policy_approval_on_case
    :parameters (?validation_case - validation_case ?human_reviewer - human_reviewer)
    :precondition
      (and
        (case_policy_triggered ?validation_case)
        (entity_assigned_to_reviewer ?validation_case ?human_reviewer)
        (not
          (case_policy_approval_recorded ?validation_case)
        )
      )
    :effect (case_policy_approval_recorded ?validation_case)
  )
  (:action apply_audit_query_response
    :parameters (?validation_case - validation_case ?audit_query - audit_query)
    :precondition
      (and
        (case_policy_approval_recorded ?validation_case)
        (audit_query_attached_to_case ?validation_case ?audit_query)
        (not
          (case_policy_satisfied ?validation_case)
        )
      )
    :effect (case_policy_satisfied ?validation_case)
  )
  (:action finalize_case_from_audit_response
    :parameters (?validation_case - validation_case)
    :precondition
      (and
        (case_policy_satisfied ?validation_case)
        (not
          (case_closed ?validation_case)
        )
      )
    :effect
      (and
        (case_closed ?validation_case)
        (entity_ready_for_posting ?validation_case)
      )
  )
  (:action mark_subledger_account_ready_for_posting
    :parameters (?subledger_account - subledger_account ?validation_batch - validation_batch)
    :precondition
      (and
        (subledger_ready_for_compilation ?subledger_account)
        (subledger_reconciled ?subledger_account)
        (validation_batch_compiled ?validation_batch)
        (validation_batch_finalized ?validation_batch)
        (not
          (entity_ready_for_posting ?subledger_account)
        )
      )
    :effect (entity_ready_for_posting ?subledger_account)
  )
  (:action mark_gl_account_ready_for_posting
    :parameters (?general_ledger_account - general_ledger_account ?validation_batch - validation_batch)
    :precondition
      (and
        (gl_ready_for_compilation ?general_ledger_account)
        (general_ledger_reconciled ?general_ledger_account)
        (validation_batch_compiled ?validation_batch)
        (validation_batch_finalized ?validation_batch)
        (not
          (entity_ready_for_posting ?general_ledger_account)
        )
      )
    :effect (entity_ready_for_posting ?general_ledger_account)
  )
  (:action authorize_journal_entry_for_posting
    :parameters (?journal_entry - journal_entry ?evidence_snapshot - evidence_snapshot ?automated_validation_rule - automated_validation_rule)
    :precondition
      (and
        (entity_ready_for_posting ?journal_entry)
        (entity_claimed_by_automated_rule ?journal_entry ?automated_validation_rule)
        (evidence_snapshot_available ?evidence_snapshot)
        (not
          (posting_authorized ?journal_entry)
        )
      )
    :effect
      (and
        (posting_authorized ?journal_entry)
        (entity_linked_to_evidence_snapshot ?journal_entry ?evidence_snapshot)
        (not
          (evidence_snapshot_available ?evidence_snapshot)
        )
      )
  )
  (:action post_subledger_account
    :parameters (?subledger_account - subledger_account ?approver - approver ?evidence_snapshot - evidence_snapshot)
    :precondition
      (and
        (posting_authorized ?subledger_account)
        (entity_assigned_to_approver ?subledger_account ?approver)
        (entity_linked_to_evidence_snapshot ?subledger_account ?evidence_snapshot)
        (not
          (posted ?subledger_account)
        )
      )
    :effect
      (and
        (posted ?subledger_account)
        (approver_available ?approver)
        (evidence_snapshot_available ?evidence_snapshot)
      )
  )
  (:action post_general_ledger_account
    :parameters (?general_ledger_account - general_ledger_account ?approver - approver ?evidence_snapshot - evidence_snapshot)
    :precondition
      (and
        (posting_authorized ?general_ledger_account)
        (entity_assigned_to_approver ?general_ledger_account ?approver)
        (entity_linked_to_evidence_snapshot ?general_ledger_account ?evidence_snapshot)
        (not
          (posted ?general_ledger_account)
        )
      )
    :effect
      (and
        (posted ?general_ledger_account)
        (approver_available ?approver)
        (evidence_snapshot_available ?evidence_snapshot)
      )
  )
  (:action post_validation_case
    :parameters (?validation_case - validation_case ?approver - approver ?evidence_snapshot - evidence_snapshot)
    :precondition
      (and
        (posting_authorized ?validation_case)
        (entity_assigned_to_approver ?validation_case ?approver)
        (entity_linked_to_evidence_snapshot ?validation_case ?evidence_snapshot)
        (not
          (posted ?validation_case)
        )
      )
    :effect
      (and
        (posted ?validation_case)
        (approver_available ?approver)
        (evidence_snapshot_available ?evidence_snapshot)
      )
  )
)

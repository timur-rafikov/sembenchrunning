(define (domain statement_to_ledger_reconciliation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types reconciliation_case - object statement_line - object ledger_account - object mapping_rule - object statement_transaction - object counterparty - object external_reference - object supporting_document - object coa_code - object approver - object adjustment_code - object exception_type - object organizational_role - object reconciliation_team - organizational_role audit_team - organizational_role automated_case - reconciliation_case manual_case - reconciliation_case)
  (:predicates
    (case_exists ?reconciliation_case - reconciliation_case)
    (case_assigned_statement ?reconciliation_case - reconciliation_case ?statement_line - statement_line)
    (case_has_assigned_statement ?reconciliation_case - reconciliation_case)
    (case_approver_engaged ?reconciliation_case - reconciliation_case)
    (case_evidence_verified ?reconciliation_case - reconciliation_case)
    (case_transaction_candidate ?reconciliation_case - reconciliation_case ?statement_transaction - statement_transaction)
    (case_rule_candidate ?reconciliation_case - reconciliation_case ?mapping_rule - mapping_rule)
    (case_counterparty_candidate ?reconciliation_case - reconciliation_case ?counterparty - counterparty)
    (case_exception_candidate ?reconciliation_case - reconciliation_case ?exception_type - exception_type)
    (case_ledger_account_validation ?reconciliation_case - reconciliation_case ?ledger_account - ledger_account)
    (case_accounting_validated ?reconciliation_case - reconciliation_case)
    (case_escalation_recorded ?reconciliation_case - reconciliation_case)
    (case_approval_recorded ?reconciliation_case - reconciliation_case)
    (case_closed ?reconciliation_case - reconciliation_case)
    (case_escalation_flag ?reconciliation_case - reconciliation_case)
    (case_post_validation_complete ?reconciliation_case - reconciliation_case)
    (case_proposed_coa ?reconciliation_case - reconciliation_case ?coa_code - coa_code)
    (coa_applied ?reconciliation_case - reconciliation_case ?coa_code - coa_code)
    (case_final_review_flag ?reconciliation_case - reconciliation_case)
    (statement_unassigned ?statement_line - statement_line)
    (ledger_account_available ?ledger_account - ledger_account)
    (statement_transaction_available ?statement_transaction - statement_transaction)
    (mapping_rule_available ?mapping_rule - mapping_rule)
    (counterparty_available ?counterparty - counterparty)
    (external_reference_available ?external_reference - external_reference)
    (supporting_document_available ?supporting_document - supporting_document)
    (coa_code_available ?coa_code - coa_code)
    (approver_available ?approver - approver)
    (adjustment_code_available ?adjustment_code - adjustment_code)
    (exception_type_available ?exception_type - exception_type)
    (case_statement_candidate ?reconciliation_case - reconciliation_case ?statement_line - statement_line)
    (case_ledger_candidate ?reconciliation_case - reconciliation_case ?ledger_account - ledger_account)
    (case_transaction_eligible ?reconciliation_case - reconciliation_case ?statement_transaction - statement_transaction)
    (case_rule_eligible ?reconciliation_case - reconciliation_case ?mapping_rule - mapping_rule)
    (case_counterparty_eligible ?reconciliation_case - reconciliation_case ?counterparty - counterparty)
    (case_adjustment_candidate ?reconciliation_case - reconciliation_case ?adjustment_code - adjustment_code)
    (case_exception_eligible ?reconciliation_case - reconciliation_case ?exception_type - exception_type)
    (case_role_assignment ?reconciliation_case - reconciliation_case ?organizational_role - organizational_role)
    (case_coa_reconciled ?reconciliation_case - reconciliation_case ?coa_code - coa_code)
    (case_automated_precheck ?reconciliation_case - reconciliation_case)
    (case_manual_precheck ?reconciliation_case - reconciliation_case)
    (case_external_reference_link ?reconciliation_case - reconciliation_case ?external_reference - external_reference)
    (case_manual_review_flag ?reconciliation_case - reconciliation_case)
    (case_coa_proposal_relation ?reconciliation_case - reconciliation_case ?coa_code - coa_code)
  )
  (:action open_reconciliation_case
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (not
          (case_exists ?reconciliation_case)
        )
        (not
          (case_closed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_exists ?reconciliation_case)
      )
  )
  (:action assign_statement_to_case
    :parameters (?reconciliation_case - reconciliation_case ?statement_line - statement_line)
    :precondition
      (and
        (case_exists ?reconciliation_case)
        (statement_unassigned ?statement_line)
        (case_statement_candidate ?reconciliation_case ?statement_line)
        (not
          (case_has_assigned_statement ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_assigned_statement ?reconciliation_case ?statement_line)
        (case_has_assigned_statement ?reconciliation_case)
        (not
          (statement_unassigned ?statement_line)
        )
      )
  )
  (:action release_statement_from_case
    :parameters (?reconciliation_case - reconciliation_case ?statement_line - statement_line)
    :precondition
      (and
        (case_assigned_statement ?reconciliation_case ?statement_line)
        (not
          (case_accounting_validated ?reconciliation_case)
        )
        (not
          (case_escalation_recorded ?reconciliation_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned_statement ?reconciliation_case ?statement_line)
        )
        (not
          (case_has_assigned_statement ?reconciliation_case)
        )
        (not
          (case_approver_engaged ?reconciliation_case)
        )
        (not
          (case_evidence_verified ?reconciliation_case)
        )
        (not
          (case_escalation_flag ?reconciliation_case)
        )
        (not
          (case_post_validation_complete ?reconciliation_case)
        )
        (not
          (case_manual_review_flag ?reconciliation_case)
        )
        (statement_unassigned ?statement_line)
      )
  )
  (:action attach_external_reference
    :parameters (?reconciliation_case - reconciliation_case ?external_reference - external_reference)
    :precondition
      (and
        (case_exists ?reconciliation_case)
        (external_reference_available ?external_reference)
      )
    :effect
      (and
        (case_external_reference_link ?reconciliation_case ?external_reference)
        (not
          (external_reference_available ?external_reference)
        )
      )
  )
  (:action detach_external_reference
    :parameters (?reconciliation_case - reconciliation_case ?external_reference - external_reference)
    :precondition
      (and
        (case_external_reference_link ?reconciliation_case ?external_reference)
      )
    :effect
      (and
        (external_reference_available ?external_reference)
        (not
          (case_external_reference_link ?reconciliation_case ?external_reference)
        )
      )
  )
  (:action engage_approver_for_reference
    :parameters (?reconciliation_case - reconciliation_case ?external_reference - external_reference)
    :precondition
      (and
        (case_exists ?reconciliation_case)
        (case_has_assigned_statement ?reconciliation_case)
        (case_external_reference_link ?reconciliation_case ?external_reference)
        (not
          (case_approver_engaged ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_approver_engaged ?reconciliation_case)
      )
  )
  (:action engage_approver_with_document
    :parameters (?reconciliation_case - reconciliation_case ?supporting_document - supporting_document)
    :precondition
      (and
        (case_exists ?reconciliation_case)
        (case_has_assigned_statement ?reconciliation_case)
        (supporting_document_available ?supporting_document)
        (not
          (case_approver_engaged ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_approver_engaged ?reconciliation_case)
        (case_escalation_flag ?reconciliation_case)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action verify_evidence_with_approver
    :parameters (?reconciliation_case - reconciliation_case ?external_reference - external_reference ?approver - approver)
    :precondition
      (and
        (case_approver_engaged ?reconciliation_case)
        (case_has_assigned_statement ?reconciliation_case)
        (case_external_reference_link ?reconciliation_case ?external_reference)
        (approver_available ?approver)
        (not
          (case_evidence_verified ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_evidence_verified ?reconciliation_case)
        (not
          (case_escalation_flag ?reconciliation_case)
        )
      )
  )
  (:action apply_coa_as_evidence
    :parameters (?reconciliation_case - reconciliation_case ?coa_code - coa_code)
    :precondition
      (and
        (case_has_assigned_statement ?reconciliation_case)
        (coa_applied ?reconciliation_case ?coa_code)
        (not
          (case_evidence_verified ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_evidence_verified ?reconciliation_case)
        (not
          (case_escalation_flag ?reconciliation_case)
        )
      )
  )
  (:action propose_statement_transaction_candidate
    :parameters (?reconciliation_case - reconciliation_case ?statement_transaction - statement_transaction)
    :precondition
      (and
        (case_exists ?reconciliation_case)
        (statement_transaction_available ?statement_transaction)
        (case_transaction_eligible ?reconciliation_case ?statement_transaction)
      )
    :effect
      (and
        (case_transaction_candidate ?reconciliation_case ?statement_transaction)
        (not
          (statement_transaction_available ?statement_transaction)
        )
      )
  )
  (:action revoke_statement_transaction_candidate
    :parameters (?reconciliation_case - reconciliation_case ?statement_transaction - statement_transaction)
    :precondition
      (and
        (case_transaction_candidate ?reconciliation_case ?statement_transaction)
      )
    :effect
      (and
        (statement_transaction_available ?statement_transaction)
        (not
          (case_transaction_candidate ?reconciliation_case ?statement_transaction)
        )
      )
  )
  (:action propose_mapping_rule_candidate
    :parameters (?reconciliation_case - reconciliation_case ?mapping_rule - mapping_rule)
    :precondition
      (and
        (case_exists ?reconciliation_case)
        (mapping_rule_available ?mapping_rule)
        (case_rule_eligible ?reconciliation_case ?mapping_rule)
      )
    :effect
      (and
        (case_rule_candidate ?reconciliation_case ?mapping_rule)
        (not
          (mapping_rule_available ?mapping_rule)
        )
      )
  )
  (:action revoke_mapping_rule_candidate
    :parameters (?reconciliation_case - reconciliation_case ?mapping_rule - mapping_rule)
    :precondition
      (and
        (case_rule_candidate ?reconciliation_case ?mapping_rule)
      )
    :effect
      (and
        (mapping_rule_available ?mapping_rule)
        (not
          (case_rule_candidate ?reconciliation_case ?mapping_rule)
        )
      )
  )
  (:action propose_counterparty_candidate
    :parameters (?reconciliation_case - reconciliation_case ?counterparty - counterparty)
    :precondition
      (and
        (case_exists ?reconciliation_case)
        (counterparty_available ?counterparty)
        (case_counterparty_eligible ?reconciliation_case ?counterparty)
      )
    :effect
      (and
        (case_counterparty_candidate ?reconciliation_case ?counterparty)
        (not
          (counterparty_available ?counterparty)
        )
      )
  )
  (:action revoke_counterparty_candidate
    :parameters (?reconciliation_case - reconciliation_case ?counterparty - counterparty)
    :precondition
      (and
        (case_counterparty_candidate ?reconciliation_case ?counterparty)
      )
    :effect
      (and
        (counterparty_available ?counterparty)
        (not
          (case_counterparty_candidate ?reconciliation_case ?counterparty)
        )
      )
  )
  (:action propose_exception_candidate
    :parameters (?reconciliation_case - reconciliation_case ?exception_type - exception_type)
    :precondition
      (and
        (case_exists ?reconciliation_case)
        (exception_type_available ?exception_type)
        (case_exception_eligible ?reconciliation_case ?exception_type)
      )
    :effect
      (and
        (case_exception_candidate ?reconciliation_case ?exception_type)
        (not
          (exception_type_available ?exception_type)
        )
      )
  )
  (:action revoke_exception_candidate
    :parameters (?reconciliation_case - reconciliation_case ?exception_type - exception_type)
    :precondition
      (and
        (case_exception_candidate ?reconciliation_case ?exception_type)
      )
    :effect
      (and
        (exception_type_available ?exception_type)
        (not
          (case_exception_candidate ?reconciliation_case ?exception_type)
        )
      )
  )
  (:action validate_mapping_against_ledger_account
    :parameters (?reconciliation_case - reconciliation_case ?ledger_account - ledger_account ?statement_transaction - statement_transaction ?mapping_rule - mapping_rule)
    :precondition
      (and
        (case_has_assigned_statement ?reconciliation_case)
        (case_transaction_candidate ?reconciliation_case ?statement_transaction)
        (case_rule_candidate ?reconciliation_case ?mapping_rule)
        (ledger_account_available ?ledger_account)
        (case_ledger_candidate ?reconciliation_case ?ledger_account)
        (not
          (case_accounting_validated ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_ledger_account_validation ?reconciliation_case ?ledger_account)
        (case_accounting_validated ?reconciliation_case)
        (not
          (ledger_account_available ?ledger_account)
        )
      )
  )
  (:action validate_mapping_with_counterparty_and_adjustment
    :parameters (?reconciliation_case - reconciliation_case ?ledger_account - ledger_account ?counterparty - counterparty ?adjustment_code - adjustment_code)
    :precondition
      (and
        (case_has_assigned_statement ?reconciliation_case)
        (case_counterparty_candidate ?reconciliation_case ?counterparty)
        (adjustment_code_available ?adjustment_code)
        (ledger_account_available ?ledger_account)
        (case_ledger_candidate ?reconciliation_case ?ledger_account)
        (case_adjustment_candidate ?reconciliation_case ?adjustment_code)
        (not
          (case_accounting_validated ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_ledger_account_validation ?reconciliation_case ?ledger_account)
        (case_accounting_validated ?reconciliation_case)
        (case_manual_review_flag ?reconciliation_case)
        (case_escalation_flag ?reconciliation_case)
        (not
          (ledger_account_available ?ledger_account)
        )
        (not
          (adjustment_code_available ?adjustment_code)
        )
      )
  )
  (:action finalize_accounting_checks
    :parameters (?reconciliation_case - reconciliation_case ?statement_transaction - statement_transaction ?mapping_rule - mapping_rule)
    :precondition
      (and
        (case_accounting_validated ?reconciliation_case)
        (case_manual_review_flag ?reconciliation_case)
        (case_transaction_candidate ?reconciliation_case ?statement_transaction)
        (case_rule_candidate ?reconciliation_case ?mapping_rule)
      )
    :effect
      (and
        (not
          (case_manual_review_flag ?reconciliation_case)
        )
        (not
          (case_escalation_flag ?reconciliation_case)
        )
      )
  )
  (:action escalate_to_reconciliation_team
    :parameters (?reconciliation_case - reconciliation_case ?statement_transaction - statement_transaction ?mapping_rule - mapping_rule ?reconciliation_team - reconciliation_team)
    :precondition
      (and
        (case_evidence_verified ?reconciliation_case)
        (case_accounting_validated ?reconciliation_case)
        (case_transaction_candidate ?reconciliation_case ?statement_transaction)
        (case_rule_candidate ?reconciliation_case ?mapping_rule)
        (case_role_assignment ?reconciliation_case ?reconciliation_team)
        (not
          (case_escalation_flag ?reconciliation_case)
        )
        (not
          (case_escalation_recorded ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_escalation_recorded ?reconciliation_case)
      )
  )
  (:action escalate_to_audit_team
    :parameters (?reconciliation_case - reconciliation_case ?counterparty - counterparty ?exception_type - exception_type ?audit_team - audit_team)
    :precondition
      (and
        (case_evidence_verified ?reconciliation_case)
        (case_accounting_validated ?reconciliation_case)
        (case_counterparty_candidate ?reconciliation_case ?counterparty)
        (case_exception_candidate ?reconciliation_case ?exception_type)
        (case_role_assignment ?reconciliation_case ?audit_team)
        (not
          (case_escalation_recorded ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_escalation_recorded ?reconciliation_case)
        (case_escalation_flag ?reconciliation_case)
      )
  )
  (:action record_formal_review_outcome
    :parameters (?reconciliation_case - reconciliation_case ?statement_transaction - statement_transaction ?mapping_rule - mapping_rule)
    :precondition
      (and
        (case_escalation_recorded ?reconciliation_case)
        (case_escalation_flag ?reconciliation_case)
        (case_transaction_candidate ?reconciliation_case ?statement_transaction)
        (case_rule_candidate ?reconciliation_case ?mapping_rule)
      )
    :effect
      (and
        (case_post_validation_complete ?reconciliation_case)
        (not
          (case_escalation_flag ?reconciliation_case)
        )
        (not
          (case_evidence_verified ?reconciliation_case)
        )
        (not
          (case_manual_review_flag ?reconciliation_case)
        )
      )
  )
  (:action reopen_evidence_steps
    :parameters (?reconciliation_case - reconciliation_case ?external_reference - external_reference ?approver - approver)
    :precondition
      (and
        (case_post_validation_complete ?reconciliation_case)
        (case_escalation_recorded ?reconciliation_case)
        (case_has_assigned_statement ?reconciliation_case)
        (case_external_reference_link ?reconciliation_case ?external_reference)
        (approver_available ?approver)
        (not
          (case_evidence_verified ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_evidence_verified ?reconciliation_case)
      )
  )
  (:action require_additional_approval
    :parameters (?reconciliation_case - reconciliation_case ?external_reference - external_reference)
    :precondition
      (and
        (case_escalation_recorded ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (not
          (case_escalation_flag ?reconciliation_case)
        )
        (case_external_reference_link ?reconciliation_case ?external_reference)
        (not
          (case_approval_recorded ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_approval_recorded ?reconciliation_case)
      )
  )
  (:action require_additional_approval_with_document
    :parameters (?reconciliation_case - reconciliation_case ?supporting_document - supporting_document)
    :precondition
      (and
        (case_escalation_recorded ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (not
          (case_escalation_flag ?reconciliation_case)
        )
        (supporting_document_available ?supporting_document)
        (not
          (case_approval_recorded ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_approval_recorded ?reconciliation_case)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action confirm_coa_post_approval
    :parameters (?reconciliation_case - reconciliation_case ?coa_code - coa_code)
    :precondition
      (and
        (case_approval_recorded ?reconciliation_case)
        (coa_code_available ?coa_code)
        (case_coa_proposal_relation ?reconciliation_case ?coa_code)
      )
    :effect
      (and
        (case_coa_reconciled ?reconciliation_case ?coa_code)
        (not
          (coa_code_available ?coa_code)
        )
      )
  )
  (:action initialize_case_subtype_coa_link
    :parameters (?manual_case - manual_case ?automated_case - automated_case ?coa_code - coa_code)
    :precondition
      (and
        (case_exists ?manual_case)
        (case_manual_precheck ?manual_case)
        (case_proposed_coa ?manual_case ?coa_code)
        (case_coa_reconciled ?automated_case ?coa_code)
        (not
          (coa_applied ?manual_case ?coa_code)
        )
      )
    :effect
      (and
        (coa_applied ?manual_case ?coa_code)
      )
  )
  (:action request_final_review
    :parameters (?reconciliation_case - reconciliation_case ?external_reference - external_reference ?approver - approver)
    :precondition
      (and
        (case_exists ?reconciliation_case)
        (case_manual_precheck ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (case_approval_recorded ?reconciliation_case)
        (case_external_reference_link ?reconciliation_case ?external_reference)
        (approver_available ?approver)
        (not
          (case_final_review_flag ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_final_review_flag ?reconciliation_case)
      )
  )
  (:action finalize_and_close_case
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_automated_precheck ?reconciliation_case)
        (case_exists ?reconciliation_case)
        (case_has_assigned_statement ?reconciliation_case)
        (case_accounting_validated ?reconciliation_case)
        (case_escalation_recorded ?reconciliation_case)
        (case_approval_recorded ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action finalize_and_close_case_with_coa
    :parameters (?reconciliation_case - reconciliation_case ?coa_code - coa_code)
    :precondition
      (and
        (case_manual_precheck ?reconciliation_case)
        (case_exists ?reconciliation_case)
        (case_has_assigned_statement ?reconciliation_case)
        (case_accounting_validated ?reconciliation_case)
        (case_escalation_recorded ?reconciliation_case)
        (case_approval_recorded ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (coa_applied ?reconciliation_case ?coa_code)
        (not
          (case_closed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
  (:action finalize_and_close_case_after_review
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_manual_precheck ?reconciliation_case)
        (case_exists ?reconciliation_case)
        (case_has_assigned_statement ?reconciliation_case)
        (case_accounting_validated ?reconciliation_case)
        (case_escalation_recorded ?reconciliation_case)
        (case_approval_recorded ?reconciliation_case)
        (case_evidence_verified ?reconciliation_case)
        (case_final_review_flag ?reconciliation_case)
        (not
          (case_closed ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_closed ?reconciliation_case)
      )
  )
)

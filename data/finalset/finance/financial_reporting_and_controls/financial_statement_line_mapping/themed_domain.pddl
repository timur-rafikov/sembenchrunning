(define (domain financial_statement_line_mapping)
  (:requirements :strips :typing :negative-preconditions)
  (:types administrative_resource_supertype - object artifact_supertype - object account_identifier_supertype - object mapping_case - object mapping_entity_supertype - mapping_case mapping_resource - administrative_resource_supertype accounting_period - administrative_resource_supertype approver - administrative_resource_supertype compliance_checklist_item - administrative_resource_supertype validation_rule_template - administrative_resource_supertype control_id - administrative_resource_supertype journal_entry_template - administrative_resource_supertype audit_signoff - administrative_resource_supertype supporting_evidence - artifact_supertype supporting_schedule - artifact_supertype external_evidence - artifact_supertype source_system_account - account_identifier_supertype subledger_account_key - account_identifier_supertype mapping_package - account_identifier_supertype account_mapping_category - mapping_entity_supertype reporting_line_category - mapping_entity_supertype general_ledger_account - account_mapping_category subledger_account - account_mapping_category financial_statement_line - reporting_line_category)
  (:predicates
    (mapping_entity_recorded ?mapping_item - mapping_entity_supertype)
    (mapping_entity_initialized ?mapping_item - mapping_entity_supertype)
    (mapping_entity_resource_assigned ?mapping_item - mapping_entity_supertype)
    (mapping_entity_finalized ?mapping_item - mapping_entity_supertype)
    (mapping_entity_validation_complete ?mapping_item - mapping_entity_supertype)
    (mapping_entity_final_approval_recorded ?mapping_item - mapping_entity_supertype)
    (mapping_resource_available ?mapping_resource - mapping_resource)
    (mapping_entity_has_resource ?mapping_item - mapping_entity_supertype ?mapping_resource - mapping_resource)
    (accounting_period_available ?accounting_period - accounting_period)
    (mapping_entity_assigned_period ?mapping_item - mapping_entity_supertype ?accounting_period - accounting_period)
    (approver_available ?approver - approver)
    (mapping_entity_assigned_approver ?mapping_item - mapping_entity_supertype ?approver - approver)
    (supporting_evidence_available ?supporting_evidence - supporting_evidence)
    (gl_account_has_supporting_evidence ?general_ledger_account - general_ledger_account ?supporting_evidence - supporting_evidence)
    (subledger_account_has_supporting_evidence ?subledger_account - subledger_account ?supporting_evidence - supporting_evidence)
    (gl_account_linked_source_account ?general_ledger_account - general_ledger_account ?source_system_account - source_system_account)
    (source_account_flagged ?source_system_account - source_system_account)
    (source_account_evidence_collected ?source_system_account - source_system_account)
    (gl_account_reconciled ?general_ledger_account - general_ledger_account)
    (subledger_account_has_key ?subledger_account - subledger_account ?subledger_account_key - subledger_account_key)
    (subledger_key_flagged_for_reconciliation ?subledger_account_key - subledger_account_key)
    (subledger_key_flagged_for_evidence ?subledger_account_key - subledger_account_key)
    (subledger_account_reconciled ?subledger_account - subledger_account)
    (mapping_package_available ?mapping_package - mapping_package)
    (mapping_package_assembled ?mapping_package - mapping_package)
    (mapping_package_linked_source_account ?mapping_package - mapping_package ?source_system_account - source_system_account)
    (mapping_package_linked_subledger_key ?mapping_package - mapping_package ?subledger_account_key - subledger_account_key)
    (mapping_package_requires_gl_reconciliation ?mapping_package - mapping_package)
    (mapping_package_requires_subledger_reconciliation ?mapping_package - mapping_package)
    (mapping_package_period_bound ?mapping_package - mapping_package)
    (financial_line_linked_gl_account ?financial_statement_line - financial_statement_line ?general_ledger_account - general_ledger_account)
    (financial_line_linked_subledger_account ?financial_statement_line - financial_statement_line ?subledger_account - subledger_account)
    (financial_line_in_package ?financial_statement_line - financial_statement_line ?mapping_package - mapping_package)
    (supporting_schedule_available ?supporting_schedule - supporting_schedule)
    (financial_line_has_supporting_schedule ?financial_statement_line - financial_statement_line ?supporting_schedule - supporting_schedule)
    (supporting_schedule_attached ?supporting_schedule - supporting_schedule)
    (supporting_schedule_linked_package ?supporting_schedule - supporting_schedule ?mapping_package - mapping_package)
    (financial_line_packaged ?financial_statement_line - financial_statement_line)
    (financial_line_prepared ?financial_statement_line - financial_statement_line)
    (financial_line_validated ?financial_statement_line - financial_statement_line)
    (financial_line_checklist_attached ?financial_statement_line - financial_statement_line)
    (financial_line_checklist_confirmed ?financial_statement_line - financial_statement_line)
    (financial_line_requires_validation_rules ?financial_statement_line - financial_statement_line)
    (financial_line_quality_reviewed ?financial_statement_line - financial_statement_line)
    (external_evidence_available ?external_evidence - external_evidence)
    (financial_line_linked_external_evidence ?financial_statement_line - financial_statement_line ?external_evidence - external_evidence)
    (financial_line_external_evidence_recorded ?financial_statement_line - financial_statement_line)
    (financial_line_evidence_acknowledged ?financial_statement_line - financial_statement_line)
    (financial_line_approver_signed_off ?financial_statement_line - financial_statement_line)
    (compliance_checklist_item_available ?compliance_checklist_item - compliance_checklist_item)
    (financial_line_linked_checklist_item ?financial_statement_line - financial_statement_line ?compliance_checklist_item - compliance_checklist_item)
    (validation_rule_template_available ?validation_rule_template - validation_rule_template)
    (financial_line_assigned_validation_rule_template ?financial_statement_line - financial_statement_line ?validation_rule_template - validation_rule_template)
    (journal_entry_template_available ?journal_entry_template - journal_entry_template)
    (financial_line_assigned_journal_template ?financial_statement_line - financial_statement_line ?journal_entry_template - journal_entry_template)
    (audit_signoff_available ?audit_signoff - audit_signoff)
    (financial_line_has_audit_signoff ?financial_statement_line - financial_statement_line ?audit_signoff - audit_signoff)
    (control_id_available ?control_id - control_id)
    (mapping_entity_assigned_control_id ?mapping_item - mapping_entity_supertype ?control_id - control_id)
    (gl_account_flagged_for_assembly ?general_ledger_account - general_ledger_account)
    (subledger_account_flagged_for_assembly ?subledger_account - subledger_account)
    (financial_line_signoff_recorded ?financial_statement_line - financial_statement_line)
  )
  (:action intake_mapping_item
    :parameters (?mapping_item - mapping_entity_supertype)
    :precondition
      (and
        (not
          (mapping_entity_recorded ?mapping_item)
        )
        (not
          (mapping_entity_finalized ?mapping_item)
        )
      )
    :effect (mapping_entity_recorded ?mapping_item)
  )
  (:action allocate_mapping_resource
    :parameters (?mapping_item - mapping_entity_supertype ?mapping_resource - mapping_resource)
    :precondition
      (and
        (mapping_entity_recorded ?mapping_item)
        (not
          (mapping_entity_resource_assigned ?mapping_item)
        )
        (mapping_resource_available ?mapping_resource)
      )
    :effect
      (and
        (mapping_entity_resource_assigned ?mapping_item)
        (mapping_entity_has_resource ?mapping_item ?mapping_resource)
        (not
          (mapping_resource_available ?mapping_resource)
        )
      )
  )
  (:action bind_mapping_item_to_accounting_period
    :parameters (?mapping_item - mapping_entity_supertype ?accounting_period - accounting_period)
    :precondition
      (and
        (mapping_entity_recorded ?mapping_item)
        (mapping_entity_resource_assigned ?mapping_item)
        (accounting_period_available ?accounting_period)
      )
    :effect
      (and
        (mapping_entity_assigned_period ?mapping_item ?accounting_period)
        (not
          (accounting_period_available ?accounting_period)
        )
      )
  )
  (:action confirm_mapping_item_initialization
    :parameters (?mapping_item - mapping_entity_supertype ?accounting_period - accounting_period)
    :precondition
      (and
        (mapping_entity_recorded ?mapping_item)
        (mapping_entity_resource_assigned ?mapping_item)
        (mapping_entity_assigned_period ?mapping_item ?accounting_period)
        (not
          (mapping_entity_initialized ?mapping_item)
        )
      )
    :effect (mapping_entity_initialized ?mapping_item)
  )
  (:action release_accounting_period_from_mapping
    :parameters (?mapping_item - mapping_entity_supertype ?accounting_period - accounting_period)
    :precondition
      (and
        (mapping_entity_assigned_period ?mapping_item ?accounting_period)
      )
    :effect
      (and
        (accounting_period_available ?accounting_period)
        (not
          (mapping_entity_assigned_period ?mapping_item ?accounting_period)
        )
      )
  )
  (:action assign_approver_to_mapping_item
    :parameters (?mapping_item - mapping_entity_supertype ?approver - approver)
    :precondition
      (and
        (mapping_entity_initialized ?mapping_item)
        (approver_available ?approver)
      )
    :effect
      (and
        (mapping_entity_assigned_approver ?mapping_item ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action unassign_approver_from_mapping_item
    :parameters (?mapping_item - mapping_entity_supertype ?approver - approver)
    :precondition
      (and
        (mapping_entity_assigned_approver ?mapping_item ?approver)
      )
    :effect
      (and
        (approver_available ?approver)
        (not
          (mapping_entity_assigned_approver ?mapping_item ?approver)
        )
      )
  )
  (:action attach_journal_template_to_financial_line
    :parameters (?financial_statement_line - financial_statement_line ?journal_entry_template - journal_entry_template)
    :precondition
      (and
        (mapping_entity_initialized ?financial_statement_line)
        (journal_entry_template_available ?journal_entry_template)
      )
    :effect
      (and
        (financial_line_assigned_journal_template ?financial_statement_line ?journal_entry_template)
        (not
          (journal_entry_template_available ?journal_entry_template)
        )
      )
  )
  (:action detach_journal_template_from_financial_line
    :parameters (?financial_statement_line - financial_statement_line ?journal_entry_template - journal_entry_template)
    :precondition
      (and
        (financial_line_assigned_journal_template ?financial_statement_line ?journal_entry_template)
      )
    :effect
      (and
        (journal_entry_template_available ?journal_entry_template)
        (not
          (financial_line_assigned_journal_template ?financial_statement_line ?journal_entry_template)
        )
      )
  )
  (:action attach_audit_signoff_to_financial_line
    :parameters (?financial_statement_line - financial_statement_line ?audit_signoff - audit_signoff)
    :precondition
      (and
        (mapping_entity_initialized ?financial_statement_line)
        (audit_signoff_available ?audit_signoff)
      )
    :effect
      (and
        (financial_line_has_audit_signoff ?financial_statement_line ?audit_signoff)
        (not
          (audit_signoff_available ?audit_signoff)
        )
      )
  )
  (:action detach_audit_signoff_from_financial_line
    :parameters (?financial_statement_line - financial_statement_line ?audit_signoff - audit_signoff)
    :precondition
      (and
        (financial_line_has_audit_signoff ?financial_statement_line ?audit_signoff)
      )
    :effect
      (and
        (audit_signoff_available ?audit_signoff)
        (not
          (financial_line_has_audit_signoff ?financial_statement_line ?audit_signoff)
        )
      )
  )
  (:action flag_source_account_for_reconciliation
    :parameters (?general_ledger_account - general_ledger_account ?source_system_account - source_system_account ?accounting_period - accounting_period)
    :precondition
      (and
        (mapping_entity_initialized ?general_ledger_account)
        (mapping_entity_assigned_period ?general_ledger_account ?accounting_period)
        (gl_account_linked_source_account ?general_ledger_account ?source_system_account)
        (not
          (source_account_flagged ?source_system_account)
        )
        (not
          (source_account_evidence_collected ?source_system_account)
        )
      )
    :effect (source_account_flagged ?source_system_account)
  )
  (:action mark_gl_account_ready_for_reconciliation
    :parameters (?general_ledger_account - general_ledger_account ?source_system_account - source_system_account ?approver - approver)
    :precondition
      (and
        (mapping_entity_initialized ?general_ledger_account)
        (mapping_entity_assigned_approver ?general_ledger_account ?approver)
        (gl_account_linked_source_account ?general_ledger_account ?source_system_account)
        (source_account_flagged ?source_system_account)
        (not
          (gl_account_flagged_for_assembly ?general_ledger_account)
        )
      )
    :effect
      (and
        (gl_account_flagged_for_assembly ?general_ledger_account)
        (gl_account_reconciled ?general_ledger_account)
      )
  )
  (:action attach_supporting_evidence_to_gl_account
    :parameters (?general_ledger_account - general_ledger_account ?source_system_account - source_system_account ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (mapping_entity_initialized ?general_ledger_account)
        (gl_account_linked_source_account ?general_ledger_account ?source_system_account)
        (supporting_evidence_available ?supporting_evidence)
        (not
          (gl_account_flagged_for_assembly ?general_ledger_account)
        )
      )
    :effect
      (and
        (source_account_evidence_collected ?source_system_account)
        (gl_account_flagged_for_assembly ?general_ledger_account)
        (gl_account_has_supporting_evidence ?general_ledger_account ?supporting_evidence)
        (not
          (supporting_evidence_available ?supporting_evidence)
        )
      )
  )
  (:action confirm_gl_account_reconciliation
    :parameters (?general_ledger_account - general_ledger_account ?source_system_account - source_system_account ?accounting_period - accounting_period ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (mapping_entity_initialized ?general_ledger_account)
        (mapping_entity_assigned_period ?general_ledger_account ?accounting_period)
        (gl_account_linked_source_account ?general_ledger_account ?source_system_account)
        (source_account_evidence_collected ?source_system_account)
        (gl_account_has_supporting_evidence ?general_ledger_account ?supporting_evidence)
        (not
          (gl_account_reconciled ?general_ledger_account)
        )
      )
    :effect
      (and
        (source_account_flagged ?source_system_account)
        (gl_account_reconciled ?general_ledger_account)
        (supporting_evidence_available ?supporting_evidence)
        (not
          (gl_account_has_supporting_evidence ?general_ledger_account ?supporting_evidence)
        )
      )
  )
  (:action flag_subledger_key_for_reconciliation
    :parameters (?subledger_account - subledger_account ?subledger_account_key - subledger_account_key ?accounting_period - accounting_period)
    :precondition
      (and
        (mapping_entity_initialized ?subledger_account)
        (mapping_entity_assigned_period ?subledger_account ?accounting_period)
        (subledger_account_has_key ?subledger_account ?subledger_account_key)
        (not
          (subledger_key_flagged_for_reconciliation ?subledger_account_key)
        )
        (not
          (subledger_key_flagged_for_evidence ?subledger_account_key)
        )
      )
    :effect (subledger_key_flagged_for_reconciliation ?subledger_account_key)
  )
  (:action mark_subledger_account_ready_for_reconciliation
    :parameters (?subledger_account - subledger_account ?subledger_account_key - subledger_account_key ?approver - approver)
    :precondition
      (and
        (mapping_entity_initialized ?subledger_account)
        (mapping_entity_assigned_approver ?subledger_account ?approver)
        (subledger_account_has_key ?subledger_account ?subledger_account_key)
        (subledger_key_flagged_for_reconciliation ?subledger_account_key)
        (not
          (subledger_account_flagged_for_assembly ?subledger_account)
        )
      )
    :effect
      (and
        (subledger_account_flagged_for_assembly ?subledger_account)
        (subledger_account_reconciled ?subledger_account)
      )
  )
  (:action attach_supporting_evidence_to_subledger_account
    :parameters (?subledger_account - subledger_account ?subledger_account_key - subledger_account_key ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (mapping_entity_initialized ?subledger_account)
        (subledger_account_has_key ?subledger_account ?subledger_account_key)
        (supporting_evidence_available ?supporting_evidence)
        (not
          (subledger_account_flagged_for_assembly ?subledger_account)
        )
      )
    :effect
      (and
        (subledger_key_flagged_for_evidence ?subledger_account_key)
        (subledger_account_flagged_for_assembly ?subledger_account)
        (subledger_account_has_supporting_evidence ?subledger_account ?supporting_evidence)
        (not
          (supporting_evidence_available ?supporting_evidence)
        )
      )
  )
  (:action confirm_subledger_account_reconciliation
    :parameters (?subledger_account - subledger_account ?subledger_account_key - subledger_account_key ?accounting_period - accounting_period ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (mapping_entity_initialized ?subledger_account)
        (mapping_entity_assigned_period ?subledger_account ?accounting_period)
        (subledger_account_has_key ?subledger_account ?subledger_account_key)
        (subledger_key_flagged_for_evidence ?subledger_account_key)
        (subledger_account_has_supporting_evidence ?subledger_account ?supporting_evidence)
        (not
          (subledger_account_reconciled ?subledger_account)
        )
      )
    :effect
      (and
        (subledger_key_flagged_for_reconciliation ?subledger_account_key)
        (subledger_account_reconciled ?subledger_account)
        (supporting_evidence_available ?supporting_evidence)
        (not
          (subledger_account_has_supporting_evidence ?subledger_account ?supporting_evidence)
        )
      )
  )
  (:action assemble_mapping_package
    :parameters (?general_ledger_account - general_ledger_account ?subledger_account - subledger_account ?source_system_account - source_system_account ?subledger_account_key - subledger_account_key ?mapping_package - mapping_package)
    :precondition
      (and
        (gl_account_flagged_for_assembly ?general_ledger_account)
        (subledger_account_flagged_for_assembly ?subledger_account)
        (gl_account_linked_source_account ?general_ledger_account ?source_system_account)
        (subledger_account_has_key ?subledger_account ?subledger_account_key)
        (source_account_flagged ?source_system_account)
        (subledger_key_flagged_for_reconciliation ?subledger_account_key)
        (gl_account_reconciled ?general_ledger_account)
        (subledger_account_reconciled ?subledger_account)
        (mapping_package_available ?mapping_package)
      )
    :effect
      (and
        (mapping_package_assembled ?mapping_package)
        (mapping_package_linked_source_account ?mapping_package ?source_system_account)
        (mapping_package_linked_subledger_key ?mapping_package ?subledger_account_key)
        (not
          (mapping_package_available ?mapping_package)
        )
      )
  )
  (:action assemble_mapping_package_with_gl_exception
    :parameters (?general_ledger_account - general_ledger_account ?subledger_account - subledger_account ?source_system_account - source_system_account ?subledger_account_key - subledger_account_key ?mapping_package - mapping_package)
    :precondition
      (and
        (gl_account_flagged_for_assembly ?general_ledger_account)
        (subledger_account_flagged_for_assembly ?subledger_account)
        (gl_account_linked_source_account ?general_ledger_account ?source_system_account)
        (subledger_account_has_key ?subledger_account ?subledger_account_key)
        (source_account_evidence_collected ?source_system_account)
        (subledger_key_flagged_for_reconciliation ?subledger_account_key)
        (not
          (gl_account_reconciled ?general_ledger_account)
        )
        (subledger_account_reconciled ?subledger_account)
        (mapping_package_available ?mapping_package)
      )
    :effect
      (and
        (mapping_package_assembled ?mapping_package)
        (mapping_package_linked_source_account ?mapping_package ?source_system_account)
        (mapping_package_linked_subledger_key ?mapping_package ?subledger_account_key)
        (mapping_package_requires_gl_reconciliation ?mapping_package)
        (not
          (mapping_package_available ?mapping_package)
        )
      )
  )
  (:action assemble_mapping_package_with_subledger_exception
    :parameters (?general_ledger_account - general_ledger_account ?subledger_account - subledger_account ?source_system_account - source_system_account ?subledger_account_key - subledger_account_key ?mapping_package - mapping_package)
    :precondition
      (and
        (gl_account_flagged_for_assembly ?general_ledger_account)
        (subledger_account_flagged_for_assembly ?subledger_account)
        (gl_account_linked_source_account ?general_ledger_account ?source_system_account)
        (subledger_account_has_key ?subledger_account ?subledger_account_key)
        (source_account_flagged ?source_system_account)
        (subledger_key_flagged_for_evidence ?subledger_account_key)
        (gl_account_reconciled ?general_ledger_account)
        (not
          (subledger_account_reconciled ?subledger_account)
        )
        (mapping_package_available ?mapping_package)
      )
    :effect
      (and
        (mapping_package_assembled ?mapping_package)
        (mapping_package_linked_source_account ?mapping_package ?source_system_account)
        (mapping_package_linked_subledger_key ?mapping_package ?subledger_account_key)
        (mapping_package_requires_subledger_reconciliation ?mapping_package)
        (not
          (mapping_package_available ?mapping_package)
        )
      )
  )
  (:action assemble_mapping_package_with_gl_and_subledger_exceptions
    :parameters (?general_ledger_account - general_ledger_account ?subledger_account - subledger_account ?source_system_account - source_system_account ?subledger_account_key - subledger_account_key ?mapping_package - mapping_package)
    :precondition
      (and
        (gl_account_flagged_for_assembly ?general_ledger_account)
        (subledger_account_flagged_for_assembly ?subledger_account)
        (gl_account_linked_source_account ?general_ledger_account ?source_system_account)
        (subledger_account_has_key ?subledger_account ?subledger_account_key)
        (source_account_evidence_collected ?source_system_account)
        (subledger_key_flagged_for_evidence ?subledger_account_key)
        (not
          (gl_account_reconciled ?general_ledger_account)
        )
        (not
          (subledger_account_reconciled ?subledger_account)
        )
        (mapping_package_available ?mapping_package)
      )
    :effect
      (and
        (mapping_package_assembled ?mapping_package)
        (mapping_package_linked_source_account ?mapping_package ?source_system_account)
        (mapping_package_linked_subledger_key ?mapping_package ?subledger_account_key)
        (mapping_package_requires_gl_reconciliation ?mapping_package)
        (mapping_package_requires_subledger_reconciliation ?mapping_package)
        (not
          (mapping_package_available ?mapping_package)
        )
      )
  )
  (:action bind_mapping_package_to_accounting_period
    :parameters (?mapping_package - mapping_package ?general_ledger_account - general_ledger_account ?accounting_period - accounting_period)
    :precondition
      (and
        (mapping_package_assembled ?mapping_package)
        (gl_account_flagged_for_assembly ?general_ledger_account)
        (mapping_entity_assigned_period ?general_ledger_account ?accounting_period)
        (not
          (mapping_package_period_bound ?mapping_package)
        )
      )
    :effect (mapping_package_period_bound ?mapping_package)
  )
  (:action attach_supporting_schedule_to_package
    :parameters (?financial_statement_line - financial_statement_line ?supporting_schedule - supporting_schedule ?mapping_package - mapping_package)
    :precondition
      (and
        (mapping_entity_initialized ?financial_statement_line)
        (financial_line_in_package ?financial_statement_line ?mapping_package)
        (financial_line_has_supporting_schedule ?financial_statement_line ?supporting_schedule)
        (supporting_schedule_available ?supporting_schedule)
        (mapping_package_assembled ?mapping_package)
        (mapping_package_period_bound ?mapping_package)
        (not
          (supporting_schedule_attached ?supporting_schedule)
        )
      )
    :effect
      (and
        (supporting_schedule_attached ?supporting_schedule)
        (supporting_schedule_linked_package ?supporting_schedule ?mapping_package)
        (not
          (supporting_schedule_available ?supporting_schedule)
        )
      )
  )
  (:action finalize_supporting_schedule_attachment
    :parameters (?financial_statement_line - financial_statement_line ?supporting_schedule - supporting_schedule ?mapping_package - mapping_package ?accounting_period - accounting_period)
    :precondition
      (and
        (mapping_entity_initialized ?financial_statement_line)
        (financial_line_has_supporting_schedule ?financial_statement_line ?supporting_schedule)
        (supporting_schedule_attached ?supporting_schedule)
        (supporting_schedule_linked_package ?supporting_schedule ?mapping_package)
        (mapping_entity_assigned_period ?financial_statement_line ?accounting_period)
        (not
          (mapping_package_requires_gl_reconciliation ?mapping_package)
        )
        (not
          (financial_line_packaged ?financial_statement_line)
        )
      )
    :effect (financial_line_packaged ?financial_statement_line)
  )
  (:action assign_compliance_checklist_to_line
    :parameters (?financial_statement_line - financial_statement_line ?compliance_checklist_item - compliance_checklist_item)
    :precondition
      (and
        (mapping_entity_initialized ?financial_statement_line)
        (compliance_checklist_item_available ?compliance_checklist_item)
        (not
          (financial_line_checklist_attached ?financial_statement_line)
        )
      )
    :effect
      (and
        (financial_line_checklist_attached ?financial_statement_line)
        (financial_line_linked_checklist_item ?financial_statement_line ?compliance_checklist_item)
        (not
          (compliance_checklist_item_available ?compliance_checklist_item)
        )
      )
  )
  (:action apply_checklist_and_mark_line_for_review
    :parameters (?financial_statement_line - financial_statement_line ?supporting_schedule - supporting_schedule ?mapping_package - mapping_package ?accounting_period - accounting_period ?compliance_checklist_item - compliance_checklist_item)
    :precondition
      (and
        (mapping_entity_initialized ?financial_statement_line)
        (financial_line_has_supporting_schedule ?financial_statement_line ?supporting_schedule)
        (supporting_schedule_attached ?supporting_schedule)
        (supporting_schedule_linked_package ?supporting_schedule ?mapping_package)
        (mapping_entity_assigned_period ?financial_statement_line ?accounting_period)
        (mapping_package_requires_gl_reconciliation ?mapping_package)
        (financial_line_checklist_attached ?financial_statement_line)
        (financial_line_linked_checklist_item ?financial_statement_line ?compliance_checklist_item)
        (not
          (financial_line_packaged ?financial_statement_line)
        )
      )
    :effect
      (and
        (financial_line_packaged ?financial_statement_line)
        (financial_line_checklist_confirmed ?financial_statement_line)
      )
  )
  (:action prepare_financial_line_for_review
    :parameters (?financial_statement_line - financial_statement_line ?journal_entry_template - journal_entry_template ?approver - approver ?supporting_schedule - supporting_schedule ?mapping_package - mapping_package)
    :precondition
      (and
        (financial_line_packaged ?financial_statement_line)
        (financial_line_assigned_journal_template ?financial_statement_line ?journal_entry_template)
        (mapping_entity_assigned_approver ?financial_statement_line ?approver)
        (financial_line_has_supporting_schedule ?financial_statement_line ?supporting_schedule)
        (supporting_schedule_linked_package ?supporting_schedule ?mapping_package)
        (not
          (mapping_package_requires_subledger_reconciliation ?mapping_package)
        )
        (not
          (financial_line_prepared ?financial_statement_line)
        )
      )
    :effect (financial_line_prepared ?financial_statement_line)
  )
  (:action prepare_financial_line_for_review_with_subledger_exception
    :parameters (?financial_statement_line - financial_statement_line ?journal_entry_template - journal_entry_template ?approver - approver ?supporting_schedule - supporting_schedule ?mapping_package - mapping_package)
    :precondition
      (and
        (financial_line_packaged ?financial_statement_line)
        (financial_line_assigned_journal_template ?financial_statement_line ?journal_entry_template)
        (mapping_entity_assigned_approver ?financial_statement_line ?approver)
        (financial_line_has_supporting_schedule ?financial_statement_line ?supporting_schedule)
        (supporting_schedule_linked_package ?supporting_schedule ?mapping_package)
        (mapping_package_requires_subledger_reconciliation ?mapping_package)
        (not
          (financial_line_prepared ?financial_statement_line)
        )
      )
    :effect (financial_line_prepared ?financial_statement_line)
  )
  (:action validate_supporting_schedule
    :parameters (?financial_statement_line - financial_statement_line ?audit_signoff - audit_signoff ?supporting_schedule - supporting_schedule ?mapping_package - mapping_package)
    :precondition
      (and
        (financial_line_prepared ?financial_statement_line)
        (financial_line_has_audit_signoff ?financial_statement_line ?audit_signoff)
        (financial_line_has_supporting_schedule ?financial_statement_line ?supporting_schedule)
        (supporting_schedule_linked_package ?supporting_schedule ?mapping_package)
        (not
          (mapping_package_requires_gl_reconciliation ?mapping_package)
        )
        (not
          (mapping_package_requires_subledger_reconciliation ?mapping_package)
        )
        (not
          (financial_line_validated ?financial_statement_line)
        )
      )
    :effect (financial_line_validated ?financial_statement_line)
  )
  (:action validate_supporting_schedule_with_gl_exception
    :parameters (?financial_statement_line - financial_statement_line ?audit_signoff - audit_signoff ?supporting_schedule - supporting_schedule ?mapping_package - mapping_package)
    :precondition
      (and
        (financial_line_prepared ?financial_statement_line)
        (financial_line_has_audit_signoff ?financial_statement_line ?audit_signoff)
        (financial_line_has_supporting_schedule ?financial_statement_line ?supporting_schedule)
        (supporting_schedule_linked_package ?supporting_schedule ?mapping_package)
        (mapping_package_requires_gl_reconciliation ?mapping_package)
        (not
          (mapping_package_requires_subledger_reconciliation ?mapping_package)
        )
        (not
          (financial_line_validated ?financial_statement_line)
        )
      )
    :effect
      (and
        (financial_line_validated ?financial_statement_line)
        (financial_line_requires_validation_rules ?financial_statement_line)
      )
  )
  (:action validate_supporting_schedule_with_subledger_exception
    :parameters (?financial_statement_line - financial_statement_line ?audit_signoff - audit_signoff ?supporting_schedule - supporting_schedule ?mapping_package - mapping_package)
    :precondition
      (and
        (financial_line_prepared ?financial_statement_line)
        (financial_line_has_audit_signoff ?financial_statement_line ?audit_signoff)
        (financial_line_has_supporting_schedule ?financial_statement_line ?supporting_schedule)
        (supporting_schedule_linked_package ?supporting_schedule ?mapping_package)
        (not
          (mapping_package_requires_gl_reconciliation ?mapping_package)
        )
        (mapping_package_requires_subledger_reconciliation ?mapping_package)
        (not
          (financial_line_validated ?financial_statement_line)
        )
      )
    :effect
      (and
        (financial_line_validated ?financial_statement_line)
        (financial_line_requires_validation_rules ?financial_statement_line)
      )
  )
  (:action validate_supporting_schedule_with_both_exceptions
    :parameters (?financial_statement_line - financial_statement_line ?audit_signoff - audit_signoff ?supporting_schedule - supporting_schedule ?mapping_package - mapping_package)
    :precondition
      (and
        (financial_line_prepared ?financial_statement_line)
        (financial_line_has_audit_signoff ?financial_statement_line ?audit_signoff)
        (financial_line_has_supporting_schedule ?financial_statement_line ?supporting_schedule)
        (supporting_schedule_linked_package ?supporting_schedule ?mapping_package)
        (mapping_package_requires_gl_reconciliation ?mapping_package)
        (mapping_package_requires_subledger_reconciliation ?mapping_package)
        (not
          (financial_line_validated ?financial_statement_line)
        )
      )
    :effect
      (and
        (financial_line_validated ?financial_statement_line)
        (financial_line_requires_validation_rules ?financial_statement_line)
      )
  )
  (:action finalize_line_validation_and_mark_item_ready
    :parameters (?financial_statement_line - financial_statement_line)
    :precondition
      (and
        (financial_line_validated ?financial_statement_line)
        (not
          (financial_line_requires_validation_rules ?financial_statement_line)
        )
        (not
          (financial_line_signoff_recorded ?financial_statement_line)
        )
      )
    :effect
      (and
        (financial_line_signoff_recorded ?financial_statement_line)
        (mapping_entity_validation_complete ?financial_statement_line)
      )
  )
  (:action attach_validation_rule_template_to_line
    :parameters (?financial_statement_line - financial_statement_line ?validation_rule_template - validation_rule_template)
    :precondition
      (and
        (financial_line_validated ?financial_statement_line)
        (financial_line_requires_validation_rules ?financial_statement_line)
        (validation_rule_template_available ?validation_rule_template)
      )
    :effect
      (and
        (financial_line_assigned_validation_rule_template ?financial_statement_line ?validation_rule_template)
        (not
          (validation_rule_template_available ?validation_rule_template)
        )
      )
  )
  (:action execute_quality_review_for_financial_line
    :parameters (?financial_statement_line - financial_statement_line ?general_ledger_account - general_ledger_account ?subledger_account - subledger_account ?accounting_period - accounting_period ?validation_rule_template - validation_rule_template)
    :precondition
      (and
        (financial_line_validated ?financial_statement_line)
        (financial_line_requires_validation_rules ?financial_statement_line)
        (financial_line_assigned_validation_rule_template ?financial_statement_line ?validation_rule_template)
        (financial_line_linked_gl_account ?financial_statement_line ?general_ledger_account)
        (financial_line_linked_subledger_account ?financial_statement_line ?subledger_account)
        (gl_account_reconciled ?general_ledger_account)
        (subledger_account_reconciled ?subledger_account)
        (mapping_entity_assigned_period ?financial_statement_line ?accounting_period)
        (not
          (financial_line_quality_reviewed ?financial_statement_line)
        )
      )
    :effect (financial_line_quality_reviewed ?financial_statement_line)
  )
  (:action finalize_quality_review_and_mark_item_ready
    :parameters (?financial_statement_line - financial_statement_line)
    :precondition
      (and
        (financial_line_validated ?financial_statement_line)
        (financial_line_quality_reviewed ?financial_statement_line)
        (not
          (financial_line_signoff_recorded ?financial_statement_line)
        )
      )
    :effect
      (and
        (financial_line_signoff_recorded ?financial_statement_line)
        (mapping_entity_validation_complete ?financial_statement_line)
      )
  )
  (:action record_external_evidence_for_line
    :parameters (?financial_statement_line - financial_statement_line ?external_evidence - external_evidence ?accounting_period - accounting_period)
    :precondition
      (and
        (mapping_entity_initialized ?financial_statement_line)
        (mapping_entity_assigned_period ?financial_statement_line ?accounting_period)
        (external_evidence_available ?external_evidence)
        (financial_line_linked_external_evidence ?financial_statement_line ?external_evidence)
        (not
          (financial_line_external_evidence_recorded ?financial_statement_line)
        )
      )
    :effect
      (and
        (financial_line_external_evidence_recorded ?financial_statement_line)
        (not
          (external_evidence_available ?external_evidence)
        )
      )
  )
  (:action approver_acknowledge_external_evidence_on_line
    :parameters (?financial_statement_line - financial_statement_line ?approver - approver)
    :precondition
      (and
        (financial_line_external_evidence_recorded ?financial_statement_line)
        (mapping_entity_assigned_approver ?financial_statement_line ?approver)
        (not
          (financial_line_evidence_acknowledged ?financial_statement_line)
        )
      )
    :effect (financial_line_evidence_acknowledged ?financial_statement_line)
  )
  (:action approver_record_audit_signoff_for_line
    :parameters (?financial_statement_line - financial_statement_line ?audit_signoff - audit_signoff)
    :precondition
      (and
        (financial_line_evidence_acknowledged ?financial_statement_line)
        (financial_line_has_audit_signoff ?financial_statement_line ?audit_signoff)
        (not
          (financial_line_approver_signed_off ?financial_statement_line)
        )
      )
    :effect (financial_line_approver_signed_off ?financial_statement_line)
  )
  (:action finalize_line_post_approver_review
    :parameters (?financial_statement_line - financial_statement_line)
    :precondition
      (and
        (financial_line_approver_signed_off ?financial_statement_line)
        (not
          (financial_line_signoff_recorded ?financial_statement_line)
        )
      )
    :effect
      (and
        (financial_line_signoff_recorded ?financial_statement_line)
        (mapping_entity_validation_complete ?financial_statement_line)
      )
  )
  (:action finalize_gl_account_validation
    :parameters (?general_ledger_account - general_ledger_account ?mapping_package - mapping_package)
    :precondition
      (and
        (gl_account_flagged_for_assembly ?general_ledger_account)
        (gl_account_reconciled ?general_ledger_account)
        (mapping_package_assembled ?mapping_package)
        (mapping_package_period_bound ?mapping_package)
        (not
          (mapping_entity_validation_complete ?general_ledger_account)
        )
      )
    :effect (mapping_entity_validation_complete ?general_ledger_account)
  )
  (:action finalize_subledger_account_validation
    :parameters (?subledger_account - subledger_account ?mapping_package - mapping_package)
    :precondition
      (and
        (subledger_account_flagged_for_assembly ?subledger_account)
        (subledger_account_reconciled ?subledger_account)
        (mapping_package_assembled ?mapping_package)
        (mapping_package_period_bound ?mapping_package)
        (not
          (mapping_entity_validation_complete ?subledger_account)
        )
      )
    :effect (mapping_entity_validation_complete ?subledger_account)
  )
  (:action approve_mapping_item_and_assign_control_id
    :parameters (?mapping_item - mapping_entity_supertype ?control_id - control_id ?accounting_period - accounting_period)
    :precondition
      (and
        (mapping_entity_validation_complete ?mapping_item)
        (mapping_entity_assigned_period ?mapping_item ?accounting_period)
        (control_id_available ?control_id)
        (not
          (mapping_entity_final_approval_recorded ?mapping_item)
        )
      )
    :effect
      (and
        (mapping_entity_final_approval_recorded ?mapping_item)
        (mapping_entity_assigned_control_id ?mapping_item ?control_id)
        (not
          (control_id_available ?control_id)
        )
      )
  )
  (:action post_gl_account_and_release_resource
    :parameters (?general_ledger_account - general_ledger_account ?mapping_resource - mapping_resource ?control_id - control_id)
    :precondition
      (and
        (mapping_entity_final_approval_recorded ?general_ledger_account)
        (mapping_entity_has_resource ?general_ledger_account ?mapping_resource)
        (mapping_entity_assigned_control_id ?general_ledger_account ?control_id)
        (not
          (mapping_entity_finalized ?general_ledger_account)
        )
      )
    :effect
      (and
        (mapping_entity_finalized ?general_ledger_account)
        (mapping_resource_available ?mapping_resource)
        (control_id_available ?control_id)
      )
  )
  (:action post_subledger_account_and_release_resource
    :parameters (?subledger_account - subledger_account ?mapping_resource - mapping_resource ?control_id - control_id)
    :precondition
      (and
        (mapping_entity_final_approval_recorded ?subledger_account)
        (mapping_entity_has_resource ?subledger_account ?mapping_resource)
        (mapping_entity_assigned_control_id ?subledger_account ?control_id)
        (not
          (mapping_entity_finalized ?subledger_account)
        )
      )
    :effect
      (and
        (mapping_entity_finalized ?subledger_account)
        (mapping_resource_available ?mapping_resource)
        (control_id_available ?control_id)
      )
  )
  (:action post_financial_line_and_release_resource
    :parameters (?financial_statement_line - financial_statement_line ?mapping_resource - mapping_resource ?control_id - control_id)
    :precondition
      (and
        (mapping_entity_final_approval_recorded ?financial_statement_line)
        (mapping_entity_has_resource ?financial_statement_line ?mapping_resource)
        (mapping_entity_assigned_control_id ?financial_statement_line ?control_id)
        (not
          (mapping_entity_finalized ?financial_statement_line)
        )
      )
    :effect
      (and
        (mapping_entity_finalized ?financial_statement_line)
        (mapping_resource_available ?mapping_resource)
        (control_id_available ?control_id)
      )
  )
)

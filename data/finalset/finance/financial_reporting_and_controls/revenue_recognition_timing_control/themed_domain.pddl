(define (domain revenue_recognition_timing_control)
  (:requirements :strips :typing :negative-preconditions)
  (:types control_resource - object document_resource - object reconciliation_element - object control_entity - object revenue_control_object - control_entity system_approver_slot - control_resource supporting_evidence - control_resource manual_approver - control_resource recognition_policy - control_resource signoff_artifact - control_resource audit_query - control_resource external_confirmation - control_resource executive_approval - control_resource investigation_ticket - document_resource audit_document - document_resource regulatory_approval - document_resource reconciliation_item - reconciliation_element variance_item - reconciliation_element reconciliation_package - reconciliation_element sales_entity - revenue_control_object close_task_group - revenue_control_object sales_invoice - sales_entity customer_account - sales_entity control_owner_workstream - close_task_group)
  (:predicates
    (candidate_for_timing_control ?revenue_control_object - revenue_control_object)
    (validated_for_recognition ?revenue_control_object - revenue_control_object)
    (system_approver_assigned ?revenue_control_object - revenue_control_object)
    (cleared_for_posting ?revenue_control_object - revenue_control_object)
    (ready_for_authorization ?revenue_control_object - revenue_control_object)
    (posting_authorized ?revenue_control_object - revenue_control_object)
    (approver_slot_available ?system_approver_slot - system_approver_slot)
    (assigned_approver_slot ?revenue_control_object - revenue_control_object ?system_approver_slot - system_approver_slot)
    (evidence_available ?supporting_evidence - supporting_evidence)
    (evidence_linked ?revenue_control_object - revenue_control_object ?supporting_evidence - supporting_evidence)
    (manual_approver_available ?manual_approver - manual_approver)
    (manual_approver_assigned ?revenue_control_object - revenue_control_object ?manual_approver - manual_approver)
    (investigation_ticket_open ?investigation_ticket - investigation_ticket)
    (invoice_assigned_ticket ?sales_invoice - sales_invoice ?investigation_ticket - investigation_ticket)
    (account_assigned_ticket ?customer_account - customer_account ?investigation_ticket - investigation_ticket)
    (invoice_linked_reconciliation_item ?sales_invoice - sales_invoice ?reconciliation_item - reconciliation_item)
    (reconciliation_item_flagged_for_triage ?reconciliation_item - reconciliation_item)
    (reconciliation_item_marked_for_investigation ?reconciliation_item - reconciliation_item)
    (invoice_triage_completed ?sales_invoice - sales_invoice)
    (account_linked_variance_item ?customer_account - customer_account ?variance_item - variance_item)
    (variance_item_marked_for_triage ?variance_item - variance_item)
    (variance_item_marked_for_investigation ?variance_item - variance_item)
    (customer_account_triage_completed ?customer_account - customer_account)
    (reconciliation_package_available ?reconciliation_package - reconciliation_package)
    (reconciliation_package_created ?reconciliation_package - reconciliation_package)
    (package_contains_reconciliation_item ?reconciliation_package - reconciliation_package ?reconciliation_item - reconciliation_item)
    (package_contains_variance_item ?reconciliation_package - reconciliation_package ?variance_item - variance_item)
    (package_requires_policy_review ?reconciliation_package - reconciliation_package)
    (package_requires_executive_review ?reconciliation_package - reconciliation_package)
    (reconciliation_package_finalized ?reconciliation_package - reconciliation_package)
    (workstream_contains_invoice ?control_workstream - control_owner_workstream ?sales_invoice - sales_invoice)
    (workstream_contains_account ?control_workstream - control_owner_workstream ?customer_account - customer_account)
    (workstream_contains_package ?control_workstream - control_owner_workstream ?reconciliation_package - reconciliation_package)
    (audit_document_available ?audit_document - audit_document)
    (workstream_has_audit_document ?control_workstream - control_owner_workstream ?audit_document - audit_document)
    (audit_document_attached ?audit_document - audit_document)
    (audit_document_belongs_to_package ?audit_document - audit_document ?reconciliation_package - reconciliation_package)
    (workstream_documentation_reviewed ?control_workstream - control_owner_workstream)
    (workstream_signed_off ?control_workstream - control_owner_workstream)
    (workstream_evidence_complete ?control_workstream - control_owner_workstream)
    (workstream_has_policy ?control_workstream - control_owner_workstream)
    (workstream_policy_bound ?control_workstream - control_owner_workstream)
    (workstream_has_signoff ?control_workstream - control_owner_workstream)
    (workstream_finalized ?control_workstream - control_owner_workstream)
    (regulatory_approval_available ?regulatory_approval - regulatory_approval)
    (workstream_has_regulatory_approval ?control_workstream - control_owner_workstream ?regulatory_approval - regulatory_approval)
    (workstream_regulatory_clearance ?control_workstream - control_owner_workstream)
    (executive_review_scheduled ?control_workstream - control_owner_workstream)
    (executive_approval_obtained ?control_workstream - control_owner_workstream)
    (recognition_policy_available ?recognition_policy - recognition_policy)
    (workstream_policy_applied ?control_workstream - control_owner_workstream ?recognition_policy - recognition_policy)
    (signoff_artifact_available ?signoff_artifact - signoff_artifact)
    (workstream_has_signoff_artifact ?control_workstream - control_owner_workstream ?signoff_artifact - signoff_artifact)
    (external_confirmation_available ?external_confirmation - external_confirmation)
    (workstream_external_confirmation_attached ?control_workstream - control_owner_workstream ?external_confirmation - external_confirmation)
    (executive_approval_available ?executive_approval - executive_approval)
    (workstream_executive_approval_linked ?control_workstream - control_owner_workstream ?executive_approval - executive_approval)
    (audit_query_available ?audit_query - audit_query)
    (revenue_control_object_linked_audit_query ?revenue_control_object - revenue_control_object ?audit_query - audit_query)
    (invoice_ready_for_package ?sales_invoice - sales_invoice)
    (account_ready_for_package ?customer_account - customer_account)
    (workstream_closed ?control_workstream - control_owner_workstream)
  )
  (:action identify_revenue_candidate
    :parameters (?revenue_control_object - revenue_control_object)
    :precondition
      (and
        (not
          (candidate_for_timing_control ?revenue_control_object)
        )
        (not
          (cleared_for_posting ?revenue_control_object)
        )
      )
    :effect (candidate_for_timing_control ?revenue_control_object)
  )
  (:action assign_system_approver
    :parameters (?revenue_control_object - revenue_control_object ?system_approver_slot - system_approver_slot)
    :precondition
      (and
        (candidate_for_timing_control ?revenue_control_object)
        (not
          (system_approver_assigned ?revenue_control_object)
        )
        (approver_slot_available ?system_approver_slot)
      )
    :effect
      (and
        (system_approver_assigned ?revenue_control_object)
        (assigned_approver_slot ?revenue_control_object ?system_approver_slot)
        (not
          (approver_slot_available ?system_approver_slot)
        )
      )
  )
  (:action link_supporting_evidence
    :parameters (?revenue_control_object - revenue_control_object ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (candidate_for_timing_control ?revenue_control_object)
        (system_approver_assigned ?revenue_control_object)
        (evidence_available ?supporting_evidence)
      )
    :effect
      (and
        (evidence_linked ?revenue_control_object ?supporting_evidence)
        (not
          (evidence_available ?supporting_evidence)
        )
      )
  )
  (:action validate_and_mark_recognition_eligibility
    :parameters (?revenue_control_object - revenue_control_object ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (candidate_for_timing_control ?revenue_control_object)
        (system_approver_assigned ?revenue_control_object)
        (evidence_linked ?revenue_control_object ?supporting_evidence)
        (not
          (validated_for_recognition ?revenue_control_object)
        )
      )
    :effect (validated_for_recognition ?revenue_control_object)
  )
  (:action unlink_supporting_evidence
    :parameters (?revenue_control_object - revenue_control_object ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (evidence_linked ?revenue_control_object ?supporting_evidence)
      )
    :effect
      (and
        (evidence_available ?supporting_evidence)
        (not
          (evidence_linked ?revenue_control_object ?supporting_evidence)
        )
      )
  )
  (:action assign_manual_approver
    :parameters (?revenue_control_object - revenue_control_object ?manual_approver - manual_approver)
    :precondition
      (and
        (validated_for_recognition ?revenue_control_object)
        (manual_approver_available ?manual_approver)
      )
    :effect
      (and
        (manual_approver_assigned ?revenue_control_object ?manual_approver)
        (not
          (manual_approver_available ?manual_approver)
        )
      )
  )
  (:action release_manual_approver
    :parameters (?revenue_control_object - revenue_control_object ?manual_approver - manual_approver)
    :precondition
      (and
        (manual_approver_assigned ?revenue_control_object ?manual_approver)
      )
    :effect
      (and
        (manual_approver_available ?manual_approver)
        (not
          (manual_approver_assigned ?revenue_control_object ?manual_approver)
        )
      )
  )
  (:action attach_external_confirmation
    :parameters (?control_workstream - control_owner_workstream ?external_confirmation - external_confirmation)
    :precondition
      (and
        (validated_for_recognition ?control_workstream)
        (external_confirmation_available ?external_confirmation)
      )
    :effect
      (and
        (workstream_external_confirmation_attached ?control_workstream ?external_confirmation)
        (not
          (external_confirmation_available ?external_confirmation)
        )
      )
  )
  (:action detach_external_confirmation
    :parameters (?control_workstream - control_owner_workstream ?external_confirmation - external_confirmation)
    :precondition
      (and
        (workstream_external_confirmation_attached ?control_workstream ?external_confirmation)
      )
    :effect
      (and
        (external_confirmation_available ?external_confirmation)
        (not
          (workstream_external_confirmation_attached ?control_workstream ?external_confirmation)
        )
      )
  )
  (:action assign_executive_approval
    :parameters (?control_workstream - control_owner_workstream ?executive_approval - executive_approval)
    :precondition
      (and
        (validated_for_recognition ?control_workstream)
        (executive_approval_available ?executive_approval)
      )
    :effect
      (and
        (workstream_executive_approval_linked ?control_workstream ?executive_approval)
        (not
          (executive_approval_available ?executive_approval)
        )
      )
  )
  (:action release_executive_approval
    :parameters (?control_workstream - control_owner_workstream ?executive_approval - executive_approval)
    :precondition
      (and
        (workstream_executive_approval_linked ?control_workstream ?executive_approval)
      )
    :effect
      (and
        (executive_approval_available ?executive_approval)
        (not
          (workstream_executive_approval_linked ?control_workstream ?executive_approval)
        )
      )
  )
  (:action flag_reconciliation_item_for_triage
    :parameters (?sales_invoice - sales_invoice ?reconciliation_item - reconciliation_item ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (validated_for_recognition ?sales_invoice)
        (evidence_linked ?sales_invoice ?supporting_evidence)
        (invoice_linked_reconciliation_item ?sales_invoice ?reconciliation_item)
        (not
          (reconciliation_item_flagged_for_triage ?reconciliation_item)
        )
        (not
          (reconciliation_item_marked_for_investigation ?reconciliation_item)
        )
      )
    :effect (reconciliation_item_flagged_for_triage ?reconciliation_item)
  )
  (:action escalate_reconciliation_item_to_reviewer
    :parameters (?sales_invoice - sales_invoice ?reconciliation_item - reconciliation_item ?manual_approver - manual_approver)
    :precondition
      (and
        (validated_for_recognition ?sales_invoice)
        (manual_approver_assigned ?sales_invoice ?manual_approver)
        (invoice_linked_reconciliation_item ?sales_invoice ?reconciliation_item)
        (reconciliation_item_flagged_for_triage ?reconciliation_item)
        (not
          (invoice_ready_for_package ?sales_invoice)
        )
      )
    :effect
      (and
        (invoice_ready_for_package ?sales_invoice)
        (invoice_triage_completed ?sales_invoice)
      )
  )
  (:action open_investigation_ticket_for_recon_item
    :parameters (?sales_invoice - sales_invoice ?reconciliation_item - reconciliation_item ?investigation_ticket - investigation_ticket)
    :precondition
      (and
        (validated_for_recognition ?sales_invoice)
        (invoice_linked_reconciliation_item ?sales_invoice ?reconciliation_item)
        (investigation_ticket_open ?investigation_ticket)
        (not
          (invoice_ready_for_package ?sales_invoice)
        )
      )
    :effect
      (and
        (reconciliation_item_marked_for_investigation ?reconciliation_item)
        (invoice_ready_for_package ?sales_invoice)
        (invoice_assigned_ticket ?sales_invoice ?investigation_ticket)
        (not
          (investigation_ticket_open ?investigation_ticket)
        )
      )
  )
  (:action complete_reconciliation_item_investigation
    :parameters (?sales_invoice - sales_invoice ?reconciliation_item - reconciliation_item ?supporting_evidence - supporting_evidence ?investigation_ticket - investigation_ticket)
    :precondition
      (and
        (validated_for_recognition ?sales_invoice)
        (evidence_linked ?sales_invoice ?supporting_evidence)
        (invoice_linked_reconciliation_item ?sales_invoice ?reconciliation_item)
        (reconciliation_item_marked_for_investigation ?reconciliation_item)
        (invoice_assigned_ticket ?sales_invoice ?investigation_ticket)
        (not
          (invoice_triage_completed ?sales_invoice)
        )
      )
    :effect
      (and
        (reconciliation_item_flagged_for_triage ?reconciliation_item)
        (invoice_triage_completed ?sales_invoice)
        (investigation_ticket_open ?investigation_ticket)
        (not
          (invoice_assigned_ticket ?sales_invoice ?investigation_ticket)
        )
      )
  )
  (:action flag_variance_item_for_triage
    :parameters (?customer_account - customer_account ?variance_item - variance_item ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (validated_for_recognition ?customer_account)
        (evidence_linked ?customer_account ?supporting_evidence)
        (account_linked_variance_item ?customer_account ?variance_item)
        (not
          (variance_item_marked_for_triage ?variance_item)
        )
        (not
          (variance_item_marked_for_investigation ?variance_item)
        )
      )
    :effect (variance_item_marked_for_triage ?variance_item)
  )
  (:action escalate_variance_to_reviewer
    :parameters (?customer_account - customer_account ?variance_item - variance_item ?manual_approver - manual_approver)
    :precondition
      (and
        (validated_for_recognition ?customer_account)
        (manual_approver_assigned ?customer_account ?manual_approver)
        (account_linked_variance_item ?customer_account ?variance_item)
        (variance_item_marked_for_triage ?variance_item)
        (not
          (account_ready_for_package ?customer_account)
        )
      )
    :effect
      (and
        (account_ready_for_package ?customer_account)
        (customer_account_triage_completed ?customer_account)
      )
  )
  (:action open_investigation_ticket_for_variance
    :parameters (?customer_account - customer_account ?variance_item - variance_item ?investigation_ticket - investigation_ticket)
    :precondition
      (and
        (validated_for_recognition ?customer_account)
        (account_linked_variance_item ?customer_account ?variance_item)
        (investigation_ticket_open ?investigation_ticket)
        (not
          (account_ready_for_package ?customer_account)
        )
      )
    :effect
      (and
        (variance_item_marked_for_investigation ?variance_item)
        (account_ready_for_package ?customer_account)
        (account_assigned_ticket ?customer_account ?investigation_ticket)
        (not
          (investigation_ticket_open ?investigation_ticket)
        )
      )
  )
  (:action complete_variance_investigation
    :parameters (?customer_account - customer_account ?variance_item - variance_item ?supporting_evidence - supporting_evidence ?investigation_ticket - investigation_ticket)
    :precondition
      (and
        (validated_for_recognition ?customer_account)
        (evidence_linked ?customer_account ?supporting_evidence)
        (account_linked_variance_item ?customer_account ?variance_item)
        (variance_item_marked_for_investigation ?variance_item)
        (account_assigned_ticket ?customer_account ?investigation_ticket)
        (not
          (customer_account_triage_completed ?customer_account)
        )
      )
    :effect
      (and
        (variance_item_marked_for_triage ?variance_item)
        (customer_account_triage_completed ?customer_account)
        (investigation_ticket_open ?investigation_ticket)
        (not
          (account_assigned_ticket ?customer_account ?investigation_ticket)
        )
      )
  )
  (:action create_reconciliation_package
    :parameters (?sales_invoice - sales_invoice ?customer_account - customer_account ?reconciliation_item - reconciliation_item ?variance_item - variance_item ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (invoice_ready_for_package ?sales_invoice)
        (account_ready_for_package ?customer_account)
        (invoice_linked_reconciliation_item ?sales_invoice ?reconciliation_item)
        (account_linked_variance_item ?customer_account ?variance_item)
        (reconciliation_item_flagged_for_triage ?reconciliation_item)
        (variance_item_marked_for_triage ?variance_item)
        (invoice_triage_completed ?sales_invoice)
        (customer_account_triage_completed ?customer_account)
        (reconciliation_package_available ?reconciliation_package)
      )
    :effect
      (and
        (reconciliation_package_created ?reconciliation_package)
        (package_contains_reconciliation_item ?reconciliation_package ?reconciliation_item)
        (package_contains_variance_item ?reconciliation_package ?variance_item)
        (not
          (reconciliation_package_available ?reconciliation_package)
        )
      )
  )
  (:action create_reconciliation_package_with_policy_flag
    :parameters (?sales_invoice - sales_invoice ?customer_account - customer_account ?reconciliation_item - reconciliation_item ?variance_item - variance_item ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (invoice_ready_for_package ?sales_invoice)
        (account_ready_for_package ?customer_account)
        (invoice_linked_reconciliation_item ?sales_invoice ?reconciliation_item)
        (account_linked_variance_item ?customer_account ?variance_item)
        (reconciliation_item_marked_for_investigation ?reconciliation_item)
        (variance_item_marked_for_triage ?variance_item)
        (not
          (invoice_triage_completed ?sales_invoice)
        )
        (customer_account_triage_completed ?customer_account)
        (reconciliation_package_available ?reconciliation_package)
      )
    :effect
      (and
        (reconciliation_package_created ?reconciliation_package)
        (package_contains_reconciliation_item ?reconciliation_package ?reconciliation_item)
        (package_contains_variance_item ?reconciliation_package ?variance_item)
        (package_requires_policy_review ?reconciliation_package)
        (not
          (reconciliation_package_available ?reconciliation_package)
        )
      )
  )
  (:action create_reconciliation_package_with_exec_flag
    :parameters (?sales_invoice - sales_invoice ?customer_account - customer_account ?reconciliation_item - reconciliation_item ?variance_item - variance_item ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (invoice_ready_for_package ?sales_invoice)
        (account_ready_for_package ?customer_account)
        (invoice_linked_reconciliation_item ?sales_invoice ?reconciliation_item)
        (account_linked_variance_item ?customer_account ?variance_item)
        (reconciliation_item_flagged_for_triage ?reconciliation_item)
        (variance_item_marked_for_investigation ?variance_item)
        (invoice_triage_completed ?sales_invoice)
        (not
          (customer_account_triage_completed ?customer_account)
        )
        (reconciliation_package_available ?reconciliation_package)
      )
    :effect
      (and
        (reconciliation_package_created ?reconciliation_package)
        (package_contains_reconciliation_item ?reconciliation_package ?reconciliation_item)
        (package_contains_variance_item ?reconciliation_package ?variance_item)
        (package_requires_executive_review ?reconciliation_package)
        (not
          (reconciliation_package_available ?reconciliation_package)
        )
      )
  )
  (:action create_reconciliation_package_with_policy_and_exec_flags
    :parameters (?sales_invoice - sales_invoice ?customer_account - customer_account ?reconciliation_item - reconciliation_item ?variance_item - variance_item ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (invoice_ready_for_package ?sales_invoice)
        (account_ready_for_package ?customer_account)
        (invoice_linked_reconciliation_item ?sales_invoice ?reconciliation_item)
        (account_linked_variance_item ?customer_account ?variance_item)
        (reconciliation_item_marked_for_investigation ?reconciliation_item)
        (variance_item_marked_for_investigation ?variance_item)
        (not
          (invoice_triage_completed ?sales_invoice)
        )
        (not
          (customer_account_triage_completed ?customer_account)
        )
        (reconciliation_package_available ?reconciliation_package)
      )
    :effect
      (and
        (reconciliation_package_created ?reconciliation_package)
        (package_contains_reconciliation_item ?reconciliation_package ?reconciliation_item)
        (package_contains_variance_item ?reconciliation_package ?variance_item)
        (package_requires_policy_review ?reconciliation_package)
        (package_requires_executive_review ?reconciliation_package)
        (not
          (reconciliation_package_available ?reconciliation_package)
        )
      )
  )
  (:action finalize_reconciliation_package
    :parameters (?reconciliation_package - reconciliation_package ?sales_invoice - sales_invoice ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (reconciliation_package_created ?reconciliation_package)
        (invoice_ready_for_package ?sales_invoice)
        (evidence_linked ?sales_invoice ?supporting_evidence)
        (not
          (reconciliation_package_finalized ?reconciliation_package)
        )
      )
    :effect (reconciliation_package_finalized ?reconciliation_package)
  )
  (:action attach_audit_document
    :parameters (?control_workstream - control_owner_workstream ?audit_document - audit_document ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (validated_for_recognition ?control_workstream)
        (workstream_contains_package ?control_workstream ?reconciliation_package)
        (workstream_has_audit_document ?control_workstream ?audit_document)
        (audit_document_available ?audit_document)
        (reconciliation_package_created ?reconciliation_package)
        (reconciliation_package_finalized ?reconciliation_package)
        (not
          (audit_document_attached ?audit_document)
        )
      )
    :effect
      (and
        (audit_document_attached ?audit_document)
        (audit_document_belongs_to_package ?audit_document ?reconciliation_package)
        (not
          (audit_document_available ?audit_document)
        )
      )
  )
  (:action verify_audit_document_for_workstream
    :parameters (?control_workstream - control_owner_workstream ?audit_document - audit_document ?reconciliation_package - reconciliation_package ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (validated_for_recognition ?control_workstream)
        (workstream_has_audit_document ?control_workstream ?audit_document)
        (audit_document_attached ?audit_document)
        (audit_document_belongs_to_package ?audit_document ?reconciliation_package)
        (evidence_linked ?control_workstream ?supporting_evidence)
        (not
          (package_requires_policy_review ?reconciliation_package)
        )
        (not
          (workstream_documentation_reviewed ?control_workstream)
        )
      )
    :effect (workstream_documentation_reviewed ?control_workstream)
  )
  (:action apply_recognition_policy
    :parameters (?control_workstream - control_owner_workstream ?recognition_policy - recognition_policy)
    :precondition
      (and
        (validated_for_recognition ?control_workstream)
        (recognition_policy_available ?recognition_policy)
        (not
          (workstream_has_policy ?control_workstream)
        )
      )
    :effect
      (and
        (workstream_has_policy ?control_workstream)
        (workstream_policy_applied ?control_workstream ?recognition_policy)
        (not
          (recognition_policy_available ?recognition_policy)
        )
      )
  )
  (:action bind_policy_and_validate_documents
    :parameters (?control_workstream - control_owner_workstream ?audit_document - audit_document ?reconciliation_package - reconciliation_package ?supporting_evidence - supporting_evidence ?recognition_policy - recognition_policy)
    :precondition
      (and
        (validated_for_recognition ?control_workstream)
        (workstream_has_audit_document ?control_workstream ?audit_document)
        (audit_document_attached ?audit_document)
        (audit_document_belongs_to_package ?audit_document ?reconciliation_package)
        (evidence_linked ?control_workstream ?supporting_evidence)
        (package_requires_policy_review ?reconciliation_package)
        (workstream_has_policy ?control_workstream)
        (workstream_policy_applied ?control_workstream ?recognition_policy)
        (not
          (workstream_documentation_reviewed ?control_workstream)
        )
      )
    :effect
      (and
        (workstream_documentation_reviewed ?control_workstream)
        (workstream_policy_bound ?control_workstream)
      )
  )
  (:action apply_external_confirmation_and_request_review
    :parameters (?control_workstream - control_owner_workstream ?external_confirmation - external_confirmation ?manual_approver - manual_approver ?audit_document - audit_document ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (workstream_documentation_reviewed ?control_workstream)
        (workstream_external_confirmation_attached ?control_workstream ?external_confirmation)
        (manual_approver_assigned ?control_workstream ?manual_approver)
        (workstream_has_audit_document ?control_workstream ?audit_document)
        (audit_document_belongs_to_package ?audit_document ?reconciliation_package)
        (not
          (package_requires_executive_review ?reconciliation_package)
        )
        (not
          (workstream_signed_off ?control_workstream)
        )
      )
    :effect (workstream_signed_off ?control_workstream)
  )
  (:action confirm_external_confirmation_and_request_review
    :parameters (?control_workstream - control_owner_workstream ?external_confirmation - external_confirmation ?manual_approver - manual_approver ?audit_document - audit_document ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (workstream_documentation_reviewed ?control_workstream)
        (workstream_external_confirmation_attached ?control_workstream ?external_confirmation)
        (manual_approver_assigned ?control_workstream ?manual_approver)
        (workstream_has_audit_document ?control_workstream ?audit_document)
        (audit_document_belongs_to_package ?audit_document ?reconciliation_package)
        (package_requires_executive_review ?reconciliation_package)
        (not
          (workstream_signed_off ?control_workstream)
        )
      )
    :effect (workstream_signed_off ?control_workstream)
  )
  (:action obtain_executive_approval
    :parameters (?control_workstream - control_owner_workstream ?executive_approval - executive_approval ?audit_document - audit_document ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (workstream_signed_off ?control_workstream)
        (workstream_executive_approval_linked ?control_workstream ?executive_approval)
        (workstream_has_audit_document ?control_workstream ?audit_document)
        (audit_document_belongs_to_package ?audit_document ?reconciliation_package)
        (not
          (package_requires_policy_review ?reconciliation_package)
        )
        (not
          (package_requires_executive_review ?reconciliation_package)
        )
        (not
          (workstream_evidence_complete ?control_workstream)
        )
      )
    :effect (workstream_evidence_complete ?control_workstream)
  )
  (:action record_executive_approval_and_add_signoff
    :parameters (?control_workstream - control_owner_workstream ?executive_approval - executive_approval ?audit_document - audit_document ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (workstream_signed_off ?control_workstream)
        (workstream_executive_approval_linked ?control_workstream ?executive_approval)
        (workstream_has_audit_document ?control_workstream ?audit_document)
        (audit_document_belongs_to_package ?audit_document ?reconciliation_package)
        (package_requires_policy_review ?reconciliation_package)
        (not
          (package_requires_executive_review ?reconciliation_package)
        )
        (not
          (workstream_evidence_complete ?control_workstream)
        )
      )
    :effect
      (and
        (workstream_evidence_complete ?control_workstream)
        (workstream_has_signoff ?control_workstream)
      )
  )
  (:action record_executive_approval_and_add_signoff_alt
    :parameters (?control_workstream - control_owner_workstream ?executive_approval - executive_approval ?audit_document - audit_document ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (workstream_signed_off ?control_workstream)
        (workstream_executive_approval_linked ?control_workstream ?executive_approval)
        (workstream_has_audit_document ?control_workstream ?audit_document)
        (audit_document_belongs_to_package ?audit_document ?reconciliation_package)
        (not
          (package_requires_policy_review ?reconciliation_package)
        )
        (package_requires_executive_review ?reconciliation_package)
        (not
          (workstream_evidence_complete ?control_workstream)
        )
      )
    :effect
      (and
        (workstream_evidence_complete ?control_workstream)
        (workstream_has_signoff ?control_workstream)
      )
  )
  (:action record_executive_approval_and_add_signoff_full
    :parameters (?control_workstream - control_owner_workstream ?executive_approval - executive_approval ?audit_document - audit_document ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (workstream_signed_off ?control_workstream)
        (workstream_executive_approval_linked ?control_workstream ?executive_approval)
        (workstream_has_audit_document ?control_workstream ?audit_document)
        (audit_document_belongs_to_package ?audit_document ?reconciliation_package)
        (package_requires_policy_review ?reconciliation_package)
        (package_requires_executive_review ?reconciliation_package)
        (not
          (workstream_evidence_complete ?control_workstream)
        )
      )
    :effect
      (and
        (workstream_evidence_complete ?control_workstream)
        (workstream_has_signoff ?control_workstream)
      )
  )
  (:action close_workstream_and_mark_ready
    :parameters (?control_workstream - control_owner_workstream)
    :precondition
      (and
        (workstream_evidence_complete ?control_workstream)
        (not
          (workstream_has_signoff ?control_workstream)
        )
        (not
          (workstream_closed ?control_workstream)
        )
      )
    :effect
      (and
        (workstream_closed ?control_workstream)
        (ready_for_authorization ?control_workstream)
      )
  )
  (:action attach_signoff_artifact
    :parameters (?control_workstream - control_owner_workstream ?signoff_artifact - signoff_artifact)
    :precondition
      (and
        (workstream_evidence_complete ?control_workstream)
        (workstream_has_signoff ?control_workstream)
        (signoff_artifact_available ?signoff_artifact)
      )
    :effect
      (and
        (workstream_has_signoff_artifact ?control_workstream ?signoff_artifact)
        (not
          (signoff_artifact_available ?signoff_artifact)
        )
      )
  )
  (:action synthesize_review_and_finalize_workstream
    :parameters (?control_workstream - control_owner_workstream ?sales_invoice - sales_invoice ?customer_account - customer_account ?supporting_evidence - supporting_evidence ?signoff_artifact - signoff_artifact)
    :precondition
      (and
        (workstream_evidence_complete ?control_workstream)
        (workstream_has_signoff ?control_workstream)
        (workstream_has_signoff_artifact ?control_workstream ?signoff_artifact)
        (workstream_contains_invoice ?control_workstream ?sales_invoice)
        (workstream_contains_account ?control_workstream ?customer_account)
        (invoice_triage_completed ?sales_invoice)
        (customer_account_triage_completed ?customer_account)
        (evidence_linked ?control_workstream ?supporting_evidence)
        (not
          (workstream_finalized ?control_workstream)
        )
      )
    :effect (workstream_finalized ?control_workstream)
  )
  (:action finalize_workstream_and_mark_ready
    :parameters (?control_workstream - control_owner_workstream)
    :precondition
      (and
        (workstream_evidence_complete ?control_workstream)
        (workstream_finalized ?control_workstream)
        (not
          (workstream_closed ?control_workstream)
        )
      )
    :effect
      (and
        (workstream_closed ?control_workstream)
        (ready_for_authorization ?control_workstream)
      )
  )
  (:action assign_regulatory_approval
    :parameters (?control_workstream - control_owner_workstream ?regulatory_approval - regulatory_approval ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (validated_for_recognition ?control_workstream)
        (evidence_linked ?control_workstream ?supporting_evidence)
        (regulatory_approval_available ?regulatory_approval)
        (workstream_has_regulatory_approval ?control_workstream ?regulatory_approval)
        (not
          (workstream_regulatory_clearance ?control_workstream)
        )
      )
    :effect
      (and
        (workstream_regulatory_clearance ?control_workstream)
        (not
          (regulatory_approval_available ?regulatory_approval)
        )
      )
  )
  (:action schedule_executive_review
    :parameters (?control_workstream - control_owner_workstream ?manual_approver - manual_approver)
    :precondition
      (and
        (workstream_regulatory_clearance ?control_workstream)
        (manual_approver_assigned ?control_workstream ?manual_approver)
        (not
          (executive_review_scheduled ?control_workstream)
        )
      )
    :effect (executive_review_scheduled ?control_workstream)
  )
  (:action obtain_executive_review_result
    :parameters (?control_workstream - control_owner_workstream ?executive_approval - executive_approval)
    :precondition
      (and
        (executive_review_scheduled ?control_workstream)
        (workstream_executive_approval_linked ?control_workstream ?executive_approval)
        (not
          (executive_approval_obtained ?control_workstream)
        )
      )
    :effect (executive_approval_obtained ?control_workstream)
  )
  (:action record_executive_approval_and_mark_ready
    :parameters (?control_workstream - control_owner_workstream)
    :precondition
      (and
        (executive_approval_obtained ?control_workstream)
        (not
          (workstream_closed ?control_workstream)
        )
      )
    :effect
      (and
        (workstream_closed ?control_workstream)
        (ready_for_authorization ?control_workstream)
      )
  )
  (:action mark_invoice_ready_for_authorization
    :parameters (?sales_invoice - sales_invoice ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (invoice_ready_for_package ?sales_invoice)
        (invoice_triage_completed ?sales_invoice)
        (reconciliation_package_created ?reconciliation_package)
        (reconciliation_package_finalized ?reconciliation_package)
        (not
          (ready_for_authorization ?sales_invoice)
        )
      )
    :effect (ready_for_authorization ?sales_invoice)
  )
  (:action mark_account_ready_for_authorization
    :parameters (?customer_account - customer_account ?reconciliation_package - reconciliation_package)
    :precondition
      (and
        (account_ready_for_package ?customer_account)
        (customer_account_triage_completed ?customer_account)
        (reconciliation_package_created ?reconciliation_package)
        (reconciliation_package_finalized ?reconciliation_package)
        (not
          (ready_for_authorization ?customer_account)
        )
      )
    :effect (ready_for_authorization ?customer_account)
  )
  (:action authorize_posting_and_link_audit_query
    :parameters (?revenue_control_object - revenue_control_object ?audit_query - audit_query ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (ready_for_authorization ?revenue_control_object)
        (evidence_linked ?revenue_control_object ?supporting_evidence)
        (audit_query_available ?audit_query)
        (not
          (posting_authorized ?revenue_control_object)
        )
      )
    :effect
      (and
        (posting_authorized ?revenue_control_object)
        (revenue_control_object_linked_audit_query ?revenue_control_object ?audit_query)
        (not
          (audit_query_available ?audit_query)
        )
      )
  )
  (:action post_invoice_and_release_approver_slot
    :parameters (?sales_invoice - sales_invoice ?system_approver_slot - system_approver_slot ?audit_query - audit_query)
    :precondition
      (and
        (posting_authorized ?sales_invoice)
        (assigned_approver_slot ?sales_invoice ?system_approver_slot)
        (revenue_control_object_linked_audit_query ?sales_invoice ?audit_query)
        (not
          (cleared_for_posting ?sales_invoice)
        )
      )
    :effect
      (and
        (cleared_for_posting ?sales_invoice)
        (approver_slot_available ?system_approver_slot)
        (audit_query_available ?audit_query)
      )
  )
  (:action post_account_and_release_approver_slot
    :parameters (?customer_account - customer_account ?system_approver_slot - system_approver_slot ?audit_query - audit_query)
    :precondition
      (and
        (posting_authorized ?customer_account)
        (assigned_approver_slot ?customer_account ?system_approver_slot)
        (revenue_control_object_linked_audit_query ?customer_account ?audit_query)
        (not
          (cleared_for_posting ?customer_account)
        )
      )
    :effect
      (and
        (cleared_for_posting ?customer_account)
        (approver_slot_available ?system_approver_slot)
        (audit_query_available ?audit_query)
      )
  )
  (:action post_workstream_and_release_approver_slot
    :parameters (?control_workstream - control_owner_workstream ?system_approver_slot - system_approver_slot ?audit_query - audit_query)
    :precondition
      (and
        (posting_authorized ?control_workstream)
        (assigned_approver_slot ?control_workstream ?system_approver_slot)
        (revenue_control_object_linked_audit_query ?control_workstream ?audit_query)
        (not
          (cleared_for_posting ?control_workstream)
        )
      )
    :effect
      (and
        (cleared_for_posting ?control_workstream)
        (approver_slot_available ?system_approver_slot)
        (audit_query_available ?audit_query)
      )
  )
)

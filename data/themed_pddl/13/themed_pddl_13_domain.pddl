(define (domain finance_reconciliation_backoffice_fee_mismatch)
  (:requirements :strips :typing :negative-preconditions)
  (:types reconciliation_case - object fee_code - object posting_instruction - object counterparty_account - object fee_component - object fee_type - object supporting_reference_file - object authorization_artifact_token - object gl_account - object approver_user - object audit_attachment - object adjustment_reason_code - object assignment_queue - object operations_queue - assignment_queue compliance_queue - assignment_queue standard_case_variant - reconciliation_case escalated_case_variant - reconciliation_case)
  (:predicates
    (authorization_artifact_available ?auth_token - authorization_artifact_token)
    (case_has_counterparty_account ?case - reconciliation_case ?counterparty_account - counterparty_account)
    (ready_for_finalization ?case - reconciliation_case)
    (case_has_fee_code ?case - reconciliation_case ?fee_code - fee_code)
    (case_assigned_to_queue ?case - reconciliation_case ?assignment_queue - assignment_queue)
    (fee_type_available ?fee_type - fee_type)
    (counterparty_account_available ?counterparty_account - counterparty_account)
    (case_adjustment_reason_eligible ?case - reconciliation_case ?adjustment_reason - adjustment_reason_code)
    (case_closed ?case - reconciliation_case)
    (case_is_standard_variant ?case - reconciliation_case)
    (case_fee_code_eligible ?case - reconciliation_case ?fee_code - fee_code)
    (posting_instruction_available ?posting_instruction - posting_instruction)
    (audit_attachment_available ?audit_attachment - audit_attachment)
    (supporting_reference_file_available ?supporting_file - supporting_reference_file)
    (posting_validation_passed ?case - reconciliation_case)
    (case_counterparty_account_eligible ?case - reconciliation_case ?counterparty_account - counterparty_account)
    (case_has_adjustment_reason ?case - reconciliation_case ?adjustment_reason - adjustment_reason_code)
    (case_posting_instruction_validated ?case - reconciliation_case ?posting_instruction - posting_instruction)
    (audit_checks_completed ?case - reconciliation_case)
    (case_fee_type_eligible ?case - reconciliation_case ?fee_type - fee_type)
    (adjustment_reason_available ?adjustment_reason - adjustment_reason_code)
    (case_is_escalated_variant ?case - reconciliation_case)
    (case_evidence_attested ?case - reconciliation_case)
    (case_fee_component_eligible ?case - reconciliation_case ?fee_component - fee_component)
    (case_has_fee_component ?case - reconciliation_case ?fee_component - fee_component)
    (requires_manual_review ?case - reconciliation_case)
    (case_has_supporting_file ?case - reconciliation_case ?supporting_file - supporting_reference_file)
    (evidence_reviewed ?case - reconciliation_case)
    (case_audit_attachment_eligible ?case - reconciliation_case ?audit_attachment - audit_attachment)
    (case_exists ?case - reconciliation_case)
    (fee_code_unclaimed ?fee_code - fee_code)
    (case_claimed ?case - reconciliation_case)
    (approver_user_available ?approver - approver_user)
    (gl_account_available ?gl_account - gl_account)
    (case_has_fee_type ?case - reconciliation_case ?fee_type - fee_type)
    (case_variant_has_gl_account ?case - reconciliation_case ?gl_account - gl_account)
    (case_reviewer_assigned ?case - reconciliation_case)
    (authorization_recorded ?case - reconciliation_case)
    (case_gl_account_applicable ?case - reconciliation_case ?gl_account - gl_account)
    (fee_component_available ?fee_component - fee_component)
    (case_has_gl_account ?case - reconciliation_case ?gl_account - gl_account)
    (case_posting_instruction_applicable ?case - reconciliation_case ?posting_instruction - posting_instruction)
    (authorization_required ?case - reconciliation_case)
    (case_gl_account_validated ?case - reconciliation_case ?gl_account - gl_account)
  )
  (:action unlink_adjustment_reason_from_case
    :parameters (?case - reconciliation_case ?adjustment_reason - adjustment_reason_code)
    :precondition
      (and
        (case_has_adjustment_reason ?case ?adjustment_reason)
      )
    :effect
      (and
        (adjustment_reason_available ?adjustment_reason)
        (not
          (case_has_adjustment_reason ?case ?adjustment_reason)
        )
      )
  )
  (:action request_authorization_from_compliance_queue
    :parameters (?case - reconciliation_case ?fee_type - fee_type ?adjustment_reason - adjustment_reason_code ?compliance_queue - compliance_queue)
    :precondition
      (and
        (not
          (audit_checks_completed ?case)
        )
        (posting_validation_passed ?case)
        (case_evidence_attested ?case)
        (case_has_adjustment_reason ?case ?adjustment_reason)
        (case_assigned_to_queue ?case ?compliance_queue)
        (case_has_fee_type ?case ?fee_type)
      )
    :effect
      (and
        (authorization_required ?case)
        (audit_checks_completed ?case)
      )
  )
  (:action finalize_standard_case
    :parameters (?case - reconciliation_case)
    :precondition
      (and
        (case_evidence_attested ?case)
        (case_claimed ?case)
        (posting_validation_passed ?case)
        (case_exists ?case)
        (authorization_recorded ?case)
        (not
          (case_closed ?case)
        )
        (case_is_standard_variant ?case)
        (audit_checks_completed ?case)
      )
    :effect
      (and
        (case_closed ?case)
      )
  )
  (:action resolve_manual_review_for_case
    :parameters (?case - reconciliation_case ?fee_component - fee_component ?counterparty_account - counterparty_account)
    :precondition
      (and
        (posting_validation_passed ?case)
        (requires_manual_review ?case)
        (case_has_fee_component ?case ?fee_component)
        (case_has_counterparty_account ?case ?counterparty_account)
      )
    :effect
      (and
        (not
          (requires_manual_review ?case)
        )
        (not
          (authorization_required ?case)
        )
      )
  )
  (:action attach_supporting_reference
    :parameters (?case - reconciliation_case ?supporting_file - supporting_reference_file)
    :precondition
      (and
        (supporting_reference_file_available ?supporting_file)
        (case_exists ?case)
      )
    :effect
      (and
        (not
          (supporting_reference_file_available ?supporting_file)
        )
        (case_has_supporting_file ?case ?supporting_file)
      )
  )
  (:action request_authorization_from_operations_queue
    :parameters (?case - reconciliation_case ?fee_component - fee_component ?counterparty_account - counterparty_account ?operations_queue - operations_queue)
    :precondition
      (and
        (case_assigned_to_queue ?case ?operations_queue)
        (case_evidence_attested ?case)
        (not
          (authorization_required ?case)
        )
        (case_has_fee_component ?case ?fee_component)
        (posting_validation_passed ?case)
        (case_has_counterparty_account ?case ?counterparty_account)
        (not
          (audit_checks_completed ?case)
        )
      )
    :effect
      (and
        (audit_checks_completed ?case)
      )
  )
  (:action attest_case_with_gl_account
    :parameters (?case - reconciliation_case ?gl_account - gl_account)
    :precondition
      (and
        (case_claimed ?case)
        (case_gl_account_validated ?case ?gl_account)
        (not
          (case_evidence_attested ?case)
        )
      )
    :effect
      (and
        (case_evidence_attested ?case)
        (not
          (authorization_required ?case)
        )
      )
  )
  (:action link_fee_type_to_case
    :parameters (?case - reconciliation_case ?fee_type - fee_type)
    :precondition
      (and
        (case_fee_type_eligible ?case ?fee_type)
        (case_exists ?case)
        (fee_type_available ?fee_type)
      )
    :effect
      (and
        (case_has_fee_type ?case ?fee_type)
        (not
          (fee_type_available ?fee_type)
        )
      )
  )
  (:action link_fee_component_to_case
    :parameters (?case - reconciliation_case ?fee_component - fee_component)
    :precondition
      (and
        (case_exists ?case)
        (fee_component_available ?fee_component)
        (case_fee_component_eligible ?case ?fee_component)
      )
    :effect
      (and
        (not
          (fee_component_available ?fee_component)
        )
        (case_has_fee_component ?case ?fee_component)
      )
  )
  (:action unlink_fee_type_from_case
    :parameters (?case - reconciliation_case ?fee_type - fee_type)
    :precondition
      (and
        (case_has_fee_type ?case ?fee_type)
      )
    :effect
      (and
        (fee_type_available ?fee_type)
        (not
          (case_has_fee_type ?case ?fee_type)
        )
      )
  )
  (:action unlink_counterparty_account_from_case
    :parameters (?case - reconciliation_case ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_has_counterparty_account ?case ?counterparty_account)
      )
    :effect
      (and
        (counterparty_account_available ?counterparty_account)
        (not
          (case_has_counterparty_account ?case ?counterparty_account)
        )
      )
  )
  (:action assign_gl_account_to_case_variant
    :parameters (?case - reconciliation_case ?gl_account - gl_account)
    :precondition
      (and
        (authorization_recorded ?case)
        (gl_account_available ?gl_account)
        (case_gl_account_applicable ?case ?gl_account)
      )
    :effect
      (and
        (case_variant_has_gl_account ?case ?gl_account)
        (not
          (gl_account_available ?gl_account)
        )
      )
  )
  (:action link_counterparty_account_to_case
    :parameters (?case - reconciliation_case ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_exists ?case)
        (counterparty_account_available ?counterparty_account)
        (case_counterparty_account_eligible ?case ?counterparty_account)
      )
    :effect
      (and
        (case_has_counterparty_account ?case ?counterparty_account)
        (not
          (counterparty_account_available ?counterparty_account)
        )
      )
  )
  (:action validate_posting_instruction
    :parameters (?case - reconciliation_case ?posting_instruction - posting_instruction ?fee_component - fee_component ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_claimed ?case)
        (posting_instruction_available ?posting_instruction)
        (case_posting_instruction_applicable ?case ?posting_instruction)
        (not
          (posting_validation_passed ?case)
        )
        (case_has_counterparty_account ?case ?counterparty_account)
        (case_has_fee_component ?case ?fee_component)
      )
    :effect
      (and
        (case_posting_instruction_validated ?case ?posting_instruction)
        (not
          (posting_instruction_available ?posting_instruction)
        )
        (posting_validation_passed ?case)
      )
  )
  (:action apply_authorization_and_prepare_finalization
    :parameters (?case - reconciliation_case ?fee_component - fee_component ?counterparty_account - counterparty_account)
    :precondition
      (and
        (case_has_fee_component ?case ?fee_component)
        (audit_checks_completed ?case)
        (case_has_counterparty_account ?case ?counterparty_account)
        (authorization_required ?case)
      )
    :effect
      (and
        (not
          (requires_manual_review ?case)
        )
        (not
          (authorization_required ?case)
        )
        (not
          (case_evidence_attested ?case)
        )
        (ready_for_finalization ?case)
      )
  )
  (:action detach_supporting_reference
    :parameters (?case - reconciliation_case ?supporting_file - supporting_reference_file)
    :precondition
      (and
        (case_has_supporting_file ?case ?supporting_file)
      )
    :effect
      (and
        (supporting_reference_file_available ?supporting_file)
        (not
          (case_has_supporting_file ?case ?supporting_file)
        )
      )
  )
  (:action attest_supporting_evidence
    :parameters (?case - reconciliation_case ?supporting_file - supporting_reference_file ?approver - approver_user)
    :precondition
      (and
        (not
          (case_evidence_attested ?case)
        )
        (case_claimed ?case)
        (approver_user_available ?approver)
        (case_has_supporting_file ?case ?supporting_file)
        (case_reviewer_assigned ?case)
      )
    :effect
      (and
        (not
          (authorization_required ?case)
        )
        (case_evidence_attested ?case)
      )
  )
  (:action finalize_escalated_case_after_evidence_review
    :parameters (?case - reconciliation_case)
    :precondition
      (and
        (case_exists ?case)
        (case_is_escalated_variant ?case)
        (evidence_reviewed ?case)
        (case_claimed ?case)
        (case_evidence_attested ?case)
        (not
          (case_closed ?case)
        )
        (authorization_recorded ?case)
        (posting_validation_passed ?case)
        (audit_checks_completed ?case)
      )
    :effect
      (and
        (case_closed ?case)
      )
  )
  (:action mark_evidence_reviewed
    :parameters (?case - reconciliation_case ?supporting_file - supporting_reference_file ?approver - approver_user)
    :precondition
      (and
        (case_evidence_attested ?case)
        (approver_user_available ?approver)
        (not
          (evidence_reviewed ?case)
        )
        (authorization_recorded ?case)
        (case_exists ?case)
        (case_is_escalated_variant ?case)
        (case_has_supporting_file ?case ?supporting_file)
      )
    :effect
      (and
        (evidence_reviewed ?case)
      )
  )
  (:action unlink_fee_component_from_case
    :parameters (?case - reconciliation_case ?fee_component - fee_component)
    :precondition
      (and
        (case_has_fee_component ?case ?fee_component)
      )
    :effect
      (and
        (fee_component_available ?fee_component)
        (not
          (case_has_fee_component ?case ?fee_component)
        )
      )
  )
  (:action link_adjustment_reason_to_case
    :parameters (?case - reconciliation_case ?adjustment_reason - adjustment_reason_code)
    :precondition
      (and
        (adjustment_reason_available ?adjustment_reason)
        (case_exists ?case)
        (case_adjustment_reason_eligible ?case ?adjustment_reason)
      )
    :effect
      (and
        (case_has_adjustment_reason ?case ?adjustment_reason)
        (not
          (adjustment_reason_available ?adjustment_reason)
        )
      )
  )
  (:action create_reconciliation_case
    :parameters (?case - reconciliation_case)
    :precondition
      (and
        (not
          (case_exists ?case)
        )
        (not
          (case_closed ?case)
        )
      )
    :effect
      (and
        (case_exists ?case)
      )
  )
  (:action assign_reviewer_with_authorization
    :parameters (?case - reconciliation_case ?auth_token - authorization_artifact_token)
    :precondition
      (and
        (not
          (case_reviewer_assigned ?case)
        )
        (case_exists ?case)
        (authorization_artifact_available ?auth_token)
        (case_claimed ?case)
      )
    :effect
      (and
        (authorization_required ?case)
        (not
          (authorization_artifact_available ?auth_token)
        )
        (case_reviewer_assigned ?case)
      )
  )
  (:action validate_posting_with_audit_attachment
    :parameters (?case - reconciliation_case ?posting_instruction - posting_instruction ?fee_type - fee_type ?audit_attachment - audit_attachment)
    :precondition
      (and
        (audit_attachment_available ?audit_attachment)
        (case_audit_attachment_eligible ?case ?audit_attachment)
        (not
          (posting_validation_passed ?case)
        )
        (case_claimed ?case)
        (posting_instruction_available ?posting_instruction)
        (case_posting_instruction_applicable ?case ?posting_instruction)
        (case_has_fee_type ?case ?fee_type)
      )
    :effect
      (and
        (case_posting_instruction_validated ?case ?posting_instruction)
        (not
          (audit_attachment_available ?audit_attachment)
        )
        (requires_manual_review ?case)
        (not
          (posting_instruction_available ?posting_instruction)
        )
        (authorization_required ?case)
        (posting_validation_passed ?case)
      )
  )
  (:action record_authorization_with_token
    :parameters (?case - reconciliation_case ?auth_token - authorization_artifact_token)
    :precondition
      (and
        (authorization_artifact_available ?auth_token)
        (not
          (authorization_required ?case)
        )
        (case_evidence_attested ?case)
        (audit_checks_completed ?case)
        (not
          (authorization_recorded ?case)
        )
      )
    :effect
      (and
        (authorization_recorded ?case)
        (not
          (authorization_artifact_available ?auth_token)
        )
      )
  )
  (:action unlink_fee_code_from_case
    :parameters (?case - reconciliation_case ?fee_code - fee_code)
    :precondition
      (and
        (case_has_fee_code ?case ?fee_code)
        (not
          (audit_checks_completed ?case)
        )
        (not
          (posting_validation_passed ?case)
        )
      )
    :effect
      (and
        (not
          (case_has_fee_code ?case ?fee_code)
        )
        (fee_code_unclaimed ?fee_code)
        (not
          (case_claimed ?case)
        )
        (not
          (case_reviewer_assigned ?case)
        )
        (not
          (ready_for_finalization ?case)
        )
        (not
          (case_evidence_attested ?case)
        )
        (not
          (requires_manual_review ?case)
        )
        (not
          (authorization_required ?case)
        )
      )
  )
  (:action record_authorization_for_supporting_file
    :parameters (?case - reconciliation_case ?supporting_file - supporting_reference_file)
    :precondition
      (and
        (not
          (authorization_recorded ?case)
        )
        (case_has_supporting_file ?case ?supporting_file)
        (case_evidence_attested ?case)
        (audit_checks_completed ?case)
        (not
          (authorization_required ?case)
        )
      )
    :effect
      (and
        (authorization_recorded ?case)
      )
  )
  (:action finalize_escalated_case
    :parameters (?case - reconciliation_case ?gl_account - gl_account)
    :precondition
      (and
        (authorization_recorded ?case)
        (audit_checks_completed ?case)
        (posting_validation_passed ?case)
        (case_gl_account_validated ?case ?gl_account)
        (case_evidence_attested ?case)
        (case_claimed ?case)
        (case_exists ?case)
        (not
          (case_closed ?case)
        )
        (case_is_escalated_variant ?case)
      )
    :effect
      (and
        (case_closed ?case)
      )
  )
  (:action assign_reviewer_to_supporting_file
    :parameters (?case - reconciliation_case ?supporting_file - supporting_reference_file)
    :precondition
      (and
        (case_exists ?case)
        (case_claimed ?case)
        (not
          (case_reviewer_assigned ?case)
        )
        (case_has_supporting_file ?case ?supporting_file)
      )
    :effect
      (and
        (case_reviewer_assigned ?case)
      )
  )
  (:action link_fee_code_to_case
    :parameters (?case - reconciliation_case ?fee_code - fee_code)
    :precondition
      (and
        (not
          (case_claimed ?case)
        )
        (case_exists ?case)
        (fee_code_unclaimed ?fee_code)
        (case_fee_code_eligible ?case ?fee_code)
      )
    :effect
      (and
        (case_claimed ?case)
        (not
          (fee_code_unclaimed ?fee_code)
        )
        (case_has_fee_code ?case ?fee_code)
      )
  )
  (:action attest_evidence_post_authorization
    :parameters (?case - reconciliation_case ?supporting_file - supporting_reference_file ?approver - approver_user)
    :precondition
      (and
        (case_claimed ?case)
        (not
          (case_evidence_attested ?case)
        )
        (case_has_supporting_file ?case ?supporting_file)
        (audit_checks_completed ?case)
        (approver_user_available ?approver)
        (ready_for_finalization ?case)
      )
    :effect
      (and
        (case_evidence_attested ?case)
      )
  )
  (:action perform_gl_account_validation_for_case_variants
    :parameters (?escalated_case - escalated_case_variant ?standard_variant_case - standard_case_variant ?gl_account - gl_account)
    :precondition
      (and
        (case_exists ?escalated_case)
        (case_variant_has_gl_account ?standard_variant_case ?gl_account)
        (case_is_escalated_variant ?escalated_case)
        (not
          (case_gl_account_validated ?escalated_case ?gl_account)
        )
        (case_has_gl_account ?escalated_case ?gl_account)
      )
    :effect
      (and
        (case_gl_account_validated ?escalated_case ?gl_account)
      )
  )
)

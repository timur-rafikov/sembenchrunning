(define (domain finance_high_value_dual_approval)
  (:requirements :strips :typing :negative-preconditions)
  (:types transaction - object submitter - object primary_approver_group - object compliance_reviewer - object business_reviewer - object operations_reviewer - object sanctions_service - object delegated_approver - object approval_step - object sanctions_analyst - object investigative_document - object counterparty_profile - object escalation_target - object senior_approver - escalation_target executive_approver - escalation_target domestic_transaction - transaction cross_border_transaction - transaction)
  (:predicates
    (transaction_opened ?transaction - transaction)
    (transaction_submitted_by ?transaction - transaction ?submitter - submitter)
    (submitter_linked ?transaction - transaction)
    (screening_assigned ?transaction - transaction)
    (screening_cleared ?transaction - transaction)
    (business_reviewer_assigned ?transaction - transaction ?business_reviewer - business_reviewer)
    (compliance_reviewer_assigned ?transaction - transaction ?compliance_reviewer - compliance_reviewer)
    (operations_reviewer_assigned ?transaction - transaction ?operations_reviewer - operations_reviewer)
    (counterparty_profile_assigned ?transaction - transaction ?counterparty_profile - counterparty_profile)
    (primary_approval_by_approver_group ?transaction - transaction ?approval_step - primary_approver_group)
    (primary_approval_recorded ?transaction - transaction)
    (dual_approval_requested ?transaction - transaction)
    (secondary_approver_confirmed ?transaction - transaction)
    (transaction_authorized ?transaction - transaction)
    (requires_manual_analyst_review ?transaction - transaction)
    (dual_approval_recorded ?transaction - transaction)
    (cross_border_interlock_required ?transaction - transaction ?approval_step - approval_step)
    (cross_border_interlock_linked ?transaction - transaction ?approval_step - approval_step)
    (final_checks_signed_off ?transaction - transaction)
    (submitter_available ?submitter - submitter)
    (primary_approver_available ?primary_approver_group - primary_approver_group)
    (business_reviewer_available ?business_reviewer - business_reviewer)
    (compliance_reviewer_available ?compliance_reviewer - compliance_reviewer)
    (operations_reviewer_available ?operations_reviewer - operations_reviewer)
    (sanctions_service_available ?sanctions_service - sanctions_service)
    (delegated_approver_available ?delegated_approver - delegated_approver)
    (approval_step_available ?approval_step - approval_step)
    (sanctions_analyst_available ?sanctions_analyst - sanctions_analyst)
    (investigative_document_available ?investigative_document - investigative_document)
    (counterparty_profile_available ?counterparty_profile - counterparty_profile)
    (eligible_submitter_for_transaction ?transaction - transaction ?submitter - submitter)
    (eligible_primary_approver_for_transaction ?transaction - transaction ?primary_approver_group - primary_approver_group)
    (eligible_business_reviewer_for_transaction ?transaction - transaction ?business_reviewer - business_reviewer)
    (eligible_compliance_reviewer_for_transaction ?transaction - transaction ?compliance_reviewer - compliance_reviewer)
    (eligible_operations_reviewer_for_transaction ?transaction - transaction ?operations_reviewer - operations_reviewer)
    (transaction_has_investigative_document ?transaction - transaction ?investigative_document - investigative_document)
    (transaction_has_counterparty_profile ?transaction - transaction ?counterparty_profile - counterparty_profile)
    (escalation_target_for_transaction ?transaction - transaction ?escalation_target - escalation_target)
    (secondary_approval_by_step ?transaction - transaction ?approval_step - approval_step)
    (transaction_domestic ?transaction - transaction)
    (transaction_cross_border ?transaction - transaction)
    (transaction_assigned_to_sanctions_service ?transaction - transaction ?sanctions_service - sanctions_service)
    (escalation_requested ?transaction - transaction)
    (transaction_step_binding ?transaction - transaction ?approval_step - approval_step)
  )
  (:action intake_open_case
    :parameters (?transaction - transaction)
    :precondition
      (and
        (not
          (transaction_opened ?transaction)
        )
        (not
          (transaction_authorized ?transaction)
        )
      )
    :effect
      (and
        (transaction_opened ?transaction)
      )
  )
  (:action submit_transaction_by_submitter
    :parameters (?transaction - transaction ?submitter - submitter)
    :precondition
      (and
        (transaction_opened ?transaction)
        (submitter_available ?submitter)
        (eligible_submitter_for_transaction ?transaction ?submitter)
        (not
          (submitter_linked ?transaction)
        )
      )
    :effect
      (and
        (transaction_submitted_by ?transaction ?submitter)
        (submitter_linked ?transaction)
        (not
          (submitter_available ?submitter)
        )
      )
  )
  (:action withdraw_submission_by_submitter
    :parameters (?transaction - transaction ?submitter - submitter)
    :precondition
      (and
        (transaction_submitted_by ?transaction ?submitter)
        (not
          (primary_approval_recorded ?transaction)
        )
        (not
          (dual_approval_requested ?transaction)
        )
      )
    :effect
      (and
        (not
          (transaction_submitted_by ?transaction ?submitter)
        )
        (not
          (submitter_linked ?transaction)
        )
        (not
          (screening_assigned ?transaction)
        )
        (not
          (screening_cleared ?transaction)
        )
        (not
          (requires_manual_analyst_review ?transaction)
        )
        (not
          (dual_approval_recorded ?transaction)
        )
        (not
          (escalation_requested ?transaction)
        )
        (submitter_available ?submitter)
      )
  )
  (:action assign_sanctions_service
    :parameters (?transaction - transaction ?sanctions_service - sanctions_service)
    :precondition
      (and
        (transaction_opened ?transaction)
        (sanctions_service_available ?sanctions_service)
      )
    :effect
      (and
        (transaction_assigned_to_sanctions_service ?transaction ?sanctions_service)
        (not
          (sanctions_service_available ?sanctions_service)
        )
      )
  )
  (:action unassign_sanctions_service
    :parameters (?transaction - transaction ?sanctions_service - sanctions_service)
    :precondition
      (and
        (transaction_assigned_to_sanctions_service ?transaction ?sanctions_service)
      )
    :effect
      (and
        (sanctions_service_available ?sanctions_service)
        (not
          (transaction_assigned_to_sanctions_service ?transaction ?sanctions_service)
        )
      )
  )
  (:action record_automated_screening_result
    :parameters (?transaction - transaction ?sanctions_service - sanctions_service)
    :precondition
      (and
        (transaction_opened ?transaction)
        (submitter_linked ?transaction)
        (transaction_assigned_to_sanctions_service ?transaction ?sanctions_service)
        (not
          (screening_assigned ?transaction)
        )
      )
    :effect
      (and
        (screening_assigned ?transaction)
      )
  )
  (:action assign_delegated_approver_for_screening
    :parameters (?transaction - transaction ?delegated_approver - delegated_approver)
    :precondition
      (and
        (transaction_opened ?transaction)
        (submitter_linked ?transaction)
        (delegated_approver_available ?delegated_approver)
        (not
          (screening_assigned ?transaction)
        )
      )
    :effect
      (and
        (screening_assigned ?transaction)
        (requires_manual_analyst_review ?transaction)
        (not
          (delegated_approver_available ?delegated_approver)
        )
      )
  )
  (:action analyst_validate_screening
    :parameters (?transaction - transaction ?sanctions_service - sanctions_service ?sanctions_analyst - sanctions_analyst)
    :precondition
      (and
        (screening_assigned ?transaction)
        (submitter_linked ?transaction)
        (transaction_assigned_to_sanctions_service ?transaction ?sanctions_service)
        (sanctions_analyst_available ?sanctions_analyst)
        (not
          (screening_cleared ?transaction)
        )
      )
    :effect
      (and
        (screening_cleared ?transaction)
        (not
          (requires_manual_analyst_review ?transaction)
        )
      )
  )
  (:action approval_step_screening_clearance
    :parameters (?transaction - transaction ?approval_step - approval_step)
    :precondition
      (and
        (submitter_linked ?transaction)
        (cross_border_interlock_linked ?transaction ?approval_step)
        (not
          (screening_cleared ?transaction)
        )
      )
    :effect
      (and
        (screening_cleared ?transaction)
        (not
          (requires_manual_analyst_review ?transaction)
        )
      )
  )
  (:action assign_business_reviewer
    :parameters (?transaction - transaction ?business_reviewer - business_reviewer)
    :precondition
      (and
        (transaction_opened ?transaction)
        (business_reviewer_available ?business_reviewer)
        (eligible_business_reviewer_for_transaction ?transaction ?business_reviewer)
      )
    :effect
      (and
        (business_reviewer_assigned ?transaction ?business_reviewer)
        (not
          (business_reviewer_available ?business_reviewer)
        )
      )
  )
  (:action unassign_business_reviewer
    :parameters (?transaction - transaction ?business_reviewer - business_reviewer)
    :precondition
      (and
        (business_reviewer_assigned ?transaction ?business_reviewer)
      )
    :effect
      (and
        (business_reviewer_available ?business_reviewer)
        (not
          (business_reviewer_assigned ?transaction ?business_reviewer)
        )
      )
  )
  (:action assign_compliance_reviewer
    :parameters (?transaction - transaction ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (transaction_opened ?transaction)
        (compliance_reviewer_available ?compliance_reviewer)
        (eligible_compliance_reviewer_for_transaction ?transaction ?compliance_reviewer)
      )
    :effect
      (and
        (compliance_reviewer_assigned ?transaction ?compliance_reviewer)
        (not
          (compliance_reviewer_available ?compliance_reviewer)
        )
      )
  )
  (:action unassign_compliance_reviewer
    :parameters (?transaction - transaction ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (compliance_reviewer_assigned ?transaction ?compliance_reviewer)
      )
    :effect
      (and
        (compliance_reviewer_available ?compliance_reviewer)
        (not
          (compliance_reviewer_assigned ?transaction ?compliance_reviewer)
        )
      )
  )
  (:action assign_operations_reviewer
    :parameters (?transaction - transaction ?operations_reviewer - operations_reviewer)
    :precondition
      (and
        (transaction_opened ?transaction)
        (operations_reviewer_available ?operations_reviewer)
        (eligible_operations_reviewer_for_transaction ?transaction ?operations_reviewer)
      )
    :effect
      (and
        (operations_reviewer_assigned ?transaction ?operations_reviewer)
        (not
          (operations_reviewer_available ?operations_reviewer)
        )
      )
  )
  (:action unassign_operations_reviewer
    :parameters (?transaction - transaction ?operations_reviewer - operations_reviewer)
    :precondition
      (and
        (operations_reviewer_assigned ?transaction ?operations_reviewer)
      )
    :effect
      (and
        (operations_reviewer_available ?operations_reviewer)
        (not
          (operations_reviewer_assigned ?transaction ?operations_reviewer)
        )
      )
  )
  (:action assign_counterparty_profile
    :parameters (?transaction - transaction ?counterparty_profile - counterparty_profile)
    :precondition
      (and
        (transaction_opened ?transaction)
        (counterparty_profile_available ?counterparty_profile)
        (transaction_has_counterparty_profile ?transaction ?counterparty_profile)
      )
    :effect
      (and
        (counterparty_profile_assigned ?transaction ?counterparty_profile)
        (not
          (counterparty_profile_available ?counterparty_profile)
        )
      )
  )
  (:action unassign_counterparty_profile
    :parameters (?transaction - transaction ?counterparty_profile - counterparty_profile)
    :precondition
      (and
        (counterparty_profile_assigned ?transaction ?counterparty_profile)
      )
    :effect
      (and
        (counterparty_profile_available ?counterparty_profile)
        (not
          (counterparty_profile_assigned ?transaction ?counterparty_profile)
        )
      )
  )
  (:action record_primary_approval
    :parameters (?transaction - transaction ?primary_approver_group - primary_approver_group ?approval_step - business_reviewer ?business_reviewer - compliance_reviewer)
    :precondition
      (and
        (submitter_linked ?transaction)
        (business_reviewer_assigned ?transaction ?approval_step)
        (compliance_reviewer_assigned ?transaction ?business_reviewer)
        (primary_approver_available ?primary_approver_group)
        (eligible_primary_approver_for_transaction ?transaction ?primary_approver_group)
        (not
          (primary_approval_recorded ?transaction)
        )
      )
    :effect
      (and
        (primary_approval_by_approver_group ?transaction ?primary_approver_group)
        (primary_approval_recorded ?transaction)
        (not
          (primary_approver_available ?primary_approver_group)
        )
      )
  )
  (:action record_primary_approval_with_investigation
    :parameters (?transaction - transaction ?primary_approver_group - primary_approver_group ?operations_reviewer - operations_reviewer ?investigative_document - investigative_document)
    :precondition
      (and
        (submitter_linked ?transaction)
        (operations_reviewer_assigned ?transaction ?operations_reviewer)
        (investigative_document_available ?investigative_document)
        (primary_approver_available ?primary_approver_group)
        (eligible_primary_approver_for_transaction ?transaction ?primary_approver_group)
        (transaction_has_investigative_document ?transaction ?investigative_document)
        (not
          (primary_approval_recorded ?transaction)
        )
      )
    :effect
      (and
        (primary_approval_by_approver_group ?transaction ?primary_approver_group)
        (primary_approval_recorded ?transaction)
        (escalation_requested ?transaction)
        (requires_manual_analyst_review ?transaction)
        (not
          (primary_approver_available ?primary_approver_group)
        )
        (not
          (investigative_document_available ?investigative_document)
        )
      )
  )
  (:action acknowledge_escalation_marker
    :parameters (?transaction - transaction ?business_reviewer - business_reviewer ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (primary_approval_recorded ?transaction)
        (escalation_requested ?transaction)
        (business_reviewer_assigned ?transaction ?business_reviewer)
        (compliance_reviewer_assigned ?transaction ?compliance_reviewer)
      )
    :effect
      (and
        (not
          (escalation_requested ?transaction)
        )
        (not
          (requires_manual_analyst_review ?transaction)
        )
      )
  )
  (:action request_dual_approval
    :parameters (?transaction - transaction ?business_reviewer - business_reviewer ?compliance_reviewer - compliance_reviewer ?senior_approver - senior_approver)
    :precondition
      (and
        (screening_cleared ?transaction)
        (primary_approval_recorded ?transaction)
        (business_reviewer_assigned ?transaction ?business_reviewer)
        (compliance_reviewer_assigned ?transaction ?compliance_reviewer)
        (escalation_target_for_transaction ?transaction ?senior_approver)
        (not
          (requires_manual_analyst_review ?transaction)
        )
        (not
          (dual_approval_requested ?transaction)
        )
      )
    :effect
      (and
        (dual_approval_requested ?transaction)
      )
  )
  (:action request_dual_approval_with_escalation
    :parameters (?transaction - transaction ?operations_reviewer - operations_reviewer ?counterparty_profile - counterparty_profile ?executive_approver - executive_approver)
    :precondition
      (and
        (screening_cleared ?transaction)
        (primary_approval_recorded ?transaction)
        (operations_reviewer_assigned ?transaction ?operations_reviewer)
        (counterparty_profile_assigned ?transaction ?counterparty_profile)
        (escalation_target_for_transaction ?transaction ?executive_approver)
        (not
          (dual_approval_requested ?transaction)
        )
      )
    :effect
      (and
        (dual_approval_requested ?transaction)
        (requires_manual_analyst_review ?transaction)
      )
  )
  (:action complete_dual_approval
    :parameters (?transaction - transaction ?business_reviewer - business_reviewer ?compliance_reviewer - compliance_reviewer)
    :precondition
      (and
        (dual_approval_requested ?transaction)
        (requires_manual_analyst_review ?transaction)
        (business_reviewer_assigned ?transaction ?business_reviewer)
        (compliance_reviewer_assigned ?transaction ?compliance_reviewer)
      )
    :effect
      (and
        (dual_approval_recorded ?transaction)
        (not
          (requires_manual_analyst_review ?transaction)
        )
        (not
          (screening_cleared ?transaction)
        )
        (not
          (escalation_requested ?transaction)
        )
      )
  )
  (:action restore_screening_clearance_after_escalation
    :parameters (?transaction - transaction ?sanctions_service - sanctions_service ?sanctions_analyst - sanctions_analyst)
    :precondition
      (and
        (dual_approval_recorded ?transaction)
        (dual_approval_requested ?transaction)
        (submitter_linked ?transaction)
        (transaction_assigned_to_sanctions_service ?transaction ?sanctions_service)
        (sanctions_analyst_available ?sanctions_analyst)
        (not
          (screening_cleared ?transaction)
        )
      )
    :effect
      (and
        (screening_cleared ?transaction)
      )
  )
  (:action mark_secondary_approver_assigned_with_service
    :parameters (?transaction - transaction ?sanctions_service - sanctions_service)
    :precondition
      (and
        (dual_approval_requested ?transaction)
        (screening_cleared ?transaction)
        (not
          (requires_manual_analyst_review ?transaction)
        )
        (transaction_assigned_to_sanctions_service ?transaction ?sanctions_service)
        (not
          (secondary_approver_confirmed ?transaction)
        )
      )
    :effect
      (and
        (secondary_approver_confirmed ?transaction)
      )
  )
  (:action mark_secondary_approver_assigned
    :parameters (?transaction - transaction ?delegated_approver - delegated_approver)
    :precondition
      (and
        (dual_approval_requested ?transaction)
        (screening_cleared ?transaction)
        (not
          (requires_manual_analyst_review ?transaction)
        )
        (delegated_approver_available ?delegated_approver)
        (not
          (secondary_approver_confirmed ?transaction)
        )
      )
    :effect
      (and
        (secondary_approver_confirmed ?transaction)
        (not
          (delegated_approver_available ?delegated_approver)
        )
      )
  )
  (:action bind_secondary_approval_step
    :parameters (?transaction - transaction ?approval_step - approval_step)
    :precondition
      (and
        (secondary_approver_confirmed ?transaction)
        (approval_step_available ?approval_step)
        (transaction_step_binding ?transaction ?approval_step)
      )
    :effect
      (and
        (secondary_approval_by_step ?transaction ?approval_step)
        (not
          (approval_step_available ?approval_step)
        )
      )
  )
  (:action link_cross_border_interlock
    :parameters (?cross_border_transaction - cross_border_transaction ?domestic_transaction - domestic_transaction ?approval_step - approval_step)
    :precondition
      (and
        (transaction_opened ?cross_border_transaction)
        (transaction_cross_border ?cross_border_transaction)
        (cross_border_interlock_required ?cross_border_transaction ?approval_step)
        (secondary_approval_by_step ?domestic_transaction ?approval_step)
        (not
          (cross_border_interlock_linked ?cross_border_transaction ?approval_step)
        )
      )
    :effect
      (and
        (cross_border_interlock_linked ?cross_border_transaction ?approval_step)
      )
  )
  (:action mark_final_checks_ready
    :parameters (?transaction - transaction ?sanctions_service - sanctions_service ?sanctions_analyst - sanctions_analyst)
    :precondition
      (and
        (transaction_opened ?transaction)
        (transaction_cross_border ?transaction)
        (screening_cleared ?transaction)
        (secondary_approver_confirmed ?transaction)
        (transaction_assigned_to_sanctions_service ?transaction ?sanctions_service)
        (sanctions_analyst_available ?sanctions_analyst)
        (not
          (final_checks_signed_off ?transaction)
        )
      )
    :effect
      (and
        (final_checks_signed_off ?transaction)
      )
  )
  (:action finalize_domestic_authorization
    :parameters (?transaction - transaction)
    :precondition
      (and
        (transaction_domestic ?transaction)
        (transaction_opened ?transaction)
        (submitter_linked ?transaction)
        (primary_approval_recorded ?transaction)
        (dual_approval_requested ?transaction)
        (secondary_approver_confirmed ?transaction)
        (screening_cleared ?transaction)
        (not
          (transaction_authorized ?transaction)
        )
      )
    :effect
      (and
        (transaction_authorized ?transaction)
      )
  )
  (:action finalize_authorization_with_step
    :parameters (?transaction - transaction ?approval_step - approval_step)
    :precondition
      (and
        (transaction_cross_border ?transaction)
        (transaction_opened ?transaction)
        (submitter_linked ?transaction)
        (primary_approval_recorded ?transaction)
        (dual_approval_requested ?transaction)
        (secondary_approver_confirmed ?transaction)
        (screening_cleared ?transaction)
        (cross_border_interlock_linked ?transaction ?approval_step)
        (not
          (transaction_authorized ?transaction)
        )
      )
    :effect
      (and
        (transaction_authorized ?transaction)
      )
  )
  (:action finalize_authorization_with_final_checks
    :parameters (?transaction - transaction)
    :precondition
      (and
        (transaction_cross_border ?transaction)
        (transaction_opened ?transaction)
        (submitter_linked ?transaction)
        (primary_approval_recorded ?transaction)
        (dual_approval_requested ?transaction)
        (secondary_approver_confirmed ?transaction)
        (screening_cleared ?transaction)
        (final_checks_signed_off ?transaction)
        (not
          (transaction_authorized ?transaction)
        )
      )
    :effect
      (and
        (transaction_authorized ?transaction)
      )
  )
)

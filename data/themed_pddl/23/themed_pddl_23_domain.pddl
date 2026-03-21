(define (domain pep_hit_secondary_review_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types alert_case - object analyst - object specialist - object customer_attribute - object watchlist_item - object sanctions_check_resource - object evidence_attachment - object subject_matter_expert - object approver - object document_checklist - object external_report - object third_party_verification - object authority_role - object compliance_officer - authority_role review_manager - authority_role case_alias - alert_case case_record - alert_case)
  (:predicates
    (subject_matter_expert_available ?subject_matter_expert - subject_matter_expert)
    (customer_attribute_reserved_for_case ?alert_case - alert_case ?customer_attribute - customer_attribute)
    (final_approval_flag ?alert_case - alert_case)
    (analyst_assigned_to_case ?alert_case - alert_case ?analyst - analyst)
    (authority_role_linked_to_case ?alert_case - alert_case ?authority_role - authority_role)
    (sanctions_check_available ?sanctions_check_resource - sanctions_check_resource)
    (customer_attribute_available ?customer_attribute - customer_attribute)
    (case_eligible_for_third_party_verification ?alert_case - alert_case ?third_party_verification - third_party_verification)
    (case_fully_approved_flag ?alert_case - alert_case)
    (has_case_alias ?alert_case - alert_case)
    (analyst_eligible_for_case ?alert_case - alert_case ?analyst - analyst)
    (specialist_available ?specialist_queue - specialist)
    (external_report_available ?external_report - external_report)
    (evidence_attachment_available ?evidence_attachment - evidence_attachment)
    (specialist_assignment_confirmed_flag ?alert_case - alert_case)
    (case_eligible_for_attribute_check ?alert_case - alert_case ?customer_attribute - customer_attribute)
    (third_party_verification_reserved_for_case ?alert_case - alert_case ?third_party_verification - third_party_verification)
    (specialist_assigned_to_case ?alert_case - alert_case ?specialist_queue - specialist)
    (secondary_review_authorized_flag ?alert_case - alert_case)
    (case_eligible_for_sanctions_check ?alert_case - alert_case ?sanctions_check_resource - sanctions_check_resource)
    (third_party_verification_available ?third_party_verification - third_party_verification)
    (has_case_record ?alert_case - alert_case)
    (sme_review_completed_flag ?alert_case - alert_case)
    (case_eligible_for_watchlist_item ?alert_case - alert_case ?watchlist_item - watchlist_item)
    (watchlist_item_reserved_for_case ?alert_case - alert_case ?watchlist_item - watchlist_item)
    (interim_escalation_flag ?alert_case - alert_case)
    (evidence_attached_to_case ?alert_case - alert_case ?evidence_attachment - evidence_attachment)
    (external_reporting_flag ?alert_case - alert_case)
    (case_eligible_for_external_report ?alert_case - alert_case ?external_report - external_report)
    (case_in_secondary_review_queue ?alert_case - alert_case)
    (analyst_available ?analyst - analyst)
    (case_has_assigned_analyst ?alert_case - alert_case)
    (document_checklist_available ?document_checklist - document_checklist)
    (approver_available ?approver - approver)
    (sanctions_check_reserved_for_case ?alert_case - alert_case ?sanctions_check_resource - sanctions_check_resource)
    (approver_assigned_to_case ?alert_case - alert_case ?approver - approver)
    (sme_escalation_flag ?alert_case - alert_case)
    (recheck_requested_flag ?alert_case - alert_case)
    (approver_eligible_for_case ?alert_case - alert_case ?approver - approver)
    (watchlist_item_available ?watchlist_item - watchlist_item)
    (approver_linked_to_case ?alert_case - alert_case ?approver - approver)
    (case_eligible_for_specialist ?alert_case - alert_case ?specialist_queue - specialist)
    (preflag_for_secondary_review ?alert_case - alert_case)
    (approver_approval_recorded_for_case ?alert_case - alert_case ?approver - approver)
  )
  (:action release_third_party_verification_from_case
    :parameters (?alert_case - alert_case ?third_party_verification - third_party_verification)
    :precondition
      (and
        (third_party_verification_reserved_for_case ?alert_case ?third_party_verification)
      )
    :effect
      (and
        (third_party_verification_available ?third_party_verification)
        (not
          (third_party_verification_reserved_for_case ?alert_case ?third_party_verification)
        )
      )
  )
  (:action record_secondary_review_decision_by_review_manager
    :parameters (?alert_case - alert_case ?sanctions_check_resource - sanctions_check_resource ?third_party_verification - third_party_verification ?review_manager - review_manager)
    :precondition
      (and
        (not
          (secondary_review_authorized_flag ?alert_case)
        )
        (specialist_assignment_confirmed_flag ?alert_case)
        (sme_review_completed_flag ?alert_case)
        (third_party_verification_reserved_for_case ?alert_case ?third_party_verification)
        (authority_role_linked_to_case ?alert_case ?review_manager)
        (sanctions_check_reserved_for_case ?alert_case ?sanctions_check_resource)
      )
    :effect
      (and
        (preflag_for_secondary_review ?alert_case)
        (secondary_review_authorized_flag ?alert_case)
      )
  )
  (:action finalize_case_with_alias_type_a
    :parameters (?alert_case - alert_case)
    :precondition
      (and
        (sme_review_completed_flag ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (specialist_assignment_confirmed_flag ?alert_case)
        (case_in_secondary_review_queue ?alert_case)
        (recheck_requested_flag ?alert_case)
        (not
          (case_fully_approved_flag ?alert_case)
        )
        (has_case_alias ?alert_case)
        (secondary_review_authorized_flag ?alert_case)
      )
    :effect
      (and
        (case_fully_approved_flag ?alert_case)
      )
  )
  (:action clear_interim_escalation_flags
    :parameters (?alert_case - alert_case ?watchlist_item - watchlist_item ?customer_attribute - customer_attribute)
    :precondition
      (and
        (specialist_assignment_confirmed_flag ?alert_case)
        (interim_escalation_flag ?alert_case)
        (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
        (customer_attribute_reserved_for_case ?alert_case ?customer_attribute)
      )
    :effect
      (and
        (not
          (interim_escalation_flag ?alert_case)
        )
        (not
          (preflag_for_secondary_review ?alert_case)
        )
      )
  )
  (:action lock_evidence_attachment
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (evidence_attachment_available ?evidence_attachment)
        (case_in_secondary_review_queue ?alert_case)
      )
    :effect
      (and
        (not
          (evidence_attachment_available ?evidence_attachment)
        )
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
      )
  )
  (:action record_secondary_review_decision_by_compliance_officer
    :parameters (?alert_case - alert_case ?watchlist_item - watchlist_item ?customer_attribute - customer_attribute ?compliance_officer - compliance_officer)
    :precondition
      (and
        (authority_role_linked_to_case ?alert_case ?compliance_officer)
        (sme_review_completed_flag ?alert_case)
        (not
          (preflag_for_secondary_review ?alert_case)
        )
        (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
        (specialist_assignment_confirmed_flag ?alert_case)
        (customer_attribute_reserved_for_case ?alert_case ?customer_attribute)
        (not
          (secondary_review_authorized_flag ?alert_case)
        )
      )
    :effect
      (and
        (secondary_review_authorized_flag ?alert_case)
      )
  )
  (:action record_sme_review_with_approver_input
    :parameters (?alert_case - alert_case ?approver - approver)
    :precondition
      (and
        (case_has_assigned_analyst ?alert_case)
        (approver_approval_recorded_for_case ?alert_case ?approver)
        (not
          (sme_review_completed_flag ?alert_case)
        )
      )
    :effect
      (and
        (sme_review_completed_flag ?alert_case)
        (not
          (preflag_for_secondary_review ?alert_case)
        )
      )
  )
  (:action reserve_sanctions_check_for_case
    :parameters (?alert_case - alert_case ?sanctions_check_resource - sanctions_check_resource)
    :precondition
      (and
        (case_eligible_for_sanctions_check ?alert_case ?sanctions_check_resource)
        (case_in_secondary_review_queue ?alert_case)
        (sanctions_check_available ?sanctions_check_resource)
      )
    :effect
      (and
        (sanctions_check_reserved_for_case ?alert_case ?sanctions_check_resource)
        (not
          (sanctions_check_available ?sanctions_check_resource)
        )
      )
  )
  (:action reserve_watchlist_item_for_case
    :parameters (?alert_case - alert_case ?watchlist_item - watchlist_item)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (watchlist_item_available ?watchlist_item)
        (case_eligible_for_watchlist_item ?alert_case ?watchlist_item)
      )
    :effect
      (and
        (not
          (watchlist_item_available ?watchlist_item)
        )
        (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
      )
  )
  (:action release_sanctions_check_from_case
    :parameters (?alert_case - alert_case ?sanctions_check_resource - sanctions_check_resource)
    :precondition
      (and
        (sanctions_check_reserved_for_case ?alert_case ?sanctions_check_resource)
      )
    :effect
      (and
        (sanctions_check_available ?sanctions_check_resource)
        (not
          (sanctions_check_reserved_for_case ?alert_case ?sanctions_check_resource)
        )
      )
  )
  (:action release_customer_attribute_from_case
    :parameters (?alert_case - alert_case ?customer_attribute - customer_attribute)
    :precondition
      (and
        (customer_attribute_reserved_for_case ?alert_case ?customer_attribute)
      )
    :effect
      (and
        (customer_attribute_available ?customer_attribute)
        (not
          (customer_attribute_reserved_for_case ?alert_case ?customer_attribute)
        )
      )
  )
  (:action escalate_recheck_to_approver
    :parameters (?alert_case - alert_case ?approver - approver)
    :precondition
      (and
        (recheck_requested_flag ?alert_case)
        (approver_available ?approver)
        (approver_eligible_for_case ?alert_case ?approver)
      )
    :effect
      (and
        (approver_assigned_to_case ?alert_case ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action reserve_customer_attribute_for_case
    :parameters (?alert_case - alert_case ?customer_attribute - customer_attribute)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (customer_attribute_available ?customer_attribute)
        (case_eligible_for_attribute_check ?alert_case ?customer_attribute)
      )
    :effect
      (and
        (customer_attribute_reserved_for_case ?alert_case ?customer_attribute)
        (not
          (customer_attribute_available ?customer_attribute)
        )
      )
  )
  (:action assign_specialist_to_case
    :parameters (?alert_case - alert_case ?specialist_queue - specialist ?watchlist_item - watchlist_item ?customer_attribute - customer_attribute)
    :precondition
      (and
        (case_has_assigned_analyst ?alert_case)
        (specialist_available ?specialist_queue)
        (case_eligible_for_specialist ?alert_case ?specialist_queue)
        (not
          (specialist_assignment_confirmed_flag ?alert_case)
        )
        (customer_attribute_reserved_for_case ?alert_case ?customer_attribute)
        (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
      )
    :effect
      (and
        (specialist_assigned_to_case ?alert_case ?specialist_queue)
        (not
          (specialist_available ?specialist_queue)
        )
        (specialist_assignment_confirmed_flag ?alert_case)
      )
  )
  (:action finalize_secondary_review_decision_and_lock
    :parameters (?alert_case - alert_case ?watchlist_item - watchlist_item ?customer_attribute - customer_attribute)
    :precondition
      (and
        (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
        (secondary_review_authorized_flag ?alert_case)
        (customer_attribute_reserved_for_case ?alert_case ?customer_attribute)
        (preflag_for_secondary_review ?alert_case)
      )
    :effect
      (and
        (not
          (interim_escalation_flag ?alert_case)
        )
        (not
          (preflag_for_secondary_review ?alert_case)
        )
        (not
          (sme_review_completed_flag ?alert_case)
        )
        (final_approval_flag ?alert_case)
      )
  )
  (:action release_evidence_attachment
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
      )
    :effect
      (and
        (evidence_attachment_available ?evidence_attachment)
        (not
          (evidence_attached_to_case ?alert_case ?evidence_attachment)
        )
      )
  )
  (:action sme_perform_review_and_set_completion
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment ?document_checklist - document_checklist)
    :precondition
      (and
        (not
          (sme_review_completed_flag ?alert_case)
        )
        (case_has_assigned_analyst ?alert_case)
        (document_checklist_available ?document_checklist)
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
        (sme_escalation_flag ?alert_case)
      )
    :effect
      (and
        (not
          (preflag_for_secondary_review ?alert_case)
        )
        (sme_review_completed_flag ?alert_case)
      )
  )
  (:action finalize_case_with_recheck_confirmation
    :parameters (?alert_case - alert_case)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (has_case_record ?alert_case)
        (external_reporting_flag ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (sme_review_completed_flag ?alert_case)
        (not
          (case_fully_approved_flag ?alert_case)
        )
        (recheck_requested_flag ?alert_case)
        (specialist_assignment_confirmed_flag ?alert_case)
        (secondary_review_authorized_flag ?alert_case)
      )
    :effect
      (and
        (case_fully_approved_flag ?alert_case)
      )
  )
  (:action record_case_recheck_notification
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment ?document_checklist - document_checklist)
    :precondition
      (and
        (sme_review_completed_flag ?alert_case)
        (document_checklist_available ?document_checklist)
        (not
          (external_reporting_flag ?alert_case)
        )
        (recheck_requested_flag ?alert_case)
        (case_in_secondary_review_queue ?alert_case)
        (has_case_record ?alert_case)
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
      )
    :effect
      (and
        (external_reporting_flag ?alert_case)
      )
  )
  (:action release_watchlist_item_from_case
    :parameters (?alert_case - alert_case ?watchlist_item - watchlist_item)
    :precondition
      (and
        (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
      )
    :effect
      (and
        (watchlist_item_available ?watchlist_item)
        (not
          (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
        )
      )
  )
  (:action reserve_third_party_verification_for_case
    :parameters (?alert_case - alert_case ?third_party_verification - third_party_verification)
    :precondition
      (and
        (third_party_verification_available ?third_party_verification)
        (case_in_secondary_review_queue ?alert_case)
        (case_eligible_for_third_party_verification ?alert_case ?third_party_verification)
      )
    :effect
      (and
        (third_party_verification_reserved_for_case ?alert_case ?third_party_verification)
        (not
          (third_party_verification_available ?third_party_verification)
        )
      )
  )
  (:action enter_secondary_review_queue
    :parameters (?alert_case - alert_case)
    :precondition
      (and
        (not
          (case_in_secondary_review_queue ?alert_case)
        )
        (not
          (case_fully_approved_flag ?alert_case)
        )
      )
    :effect
      (and
        (case_in_secondary_review_queue ?alert_case)
      )
  )
  (:action escalate_to_sme_and_preflag
    :parameters (?alert_case - alert_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (not
          (sme_escalation_flag ?alert_case)
        )
        (case_in_secondary_review_queue ?alert_case)
        (subject_matter_expert_available ?subject_matter_expert)
        (case_has_assigned_analyst ?alert_case)
      )
    :effect
      (and
        (preflag_for_secondary_review ?alert_case)
        (not
          (subject_matter_expert_available ?subject_matter_expert)
        )
        (sme_escalation_flag ?alert_case)
      )
  )
  (:action assign_specialist_with_report_and_flags
    :parameters (?alert_case - alert_case ?specialist_queue - specialist ?sanctions_check_resource - sanctions_check_resource ?external_report - external_report)
    :precondition
      (and
        (external_report_available ?external_report)
        (case_eligible_for_external_report ?alert_case ?external_report)
        (not
          (specialist_assignment_confirmed_flag ?alert_case)
        )
        (case_has_assigned_analyst ?alert_case)
        (specialist_available ?specialist_queue)
        (case_eligible_for_specialist ?alert_case ?specialist_queue)
        (sanctions_check_reserved_for_case ?alert_case ?sanctions_check_resource)
      )
    :effect
      (and
        (specialist_assigned_to_case ?alert_case ?specialist_queue)
        (not
          (external_report_available ?external_report)
        )
        (interim_escalation_flag ?alert_case)
        (not
          (specialist_available ?specialist_queue)
        )
        (preflag_for_secondary_review ?alert_case)
        (specialist_assignment_confirmed_flag ?alert_case)
      )
  )
  (:action request_recheck_with_sme
    :parameters (?alert_case - alert_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (subject_matter_expert_available ?subject_matter_expert)
        (not
          (preflag_for_secondary_review ?alert_case)
        )
        (sme_review_completed_flag ?alert_case)
        (secondary_review_authorized_flag ?alert_case)
        (not
          (recheck_requested_flag ?alert_case)
        )
      )
    :effect
      (and
        (recheck_requested_flag ?alert_case)
        (not
          (subject_matter_expert_available ?subject_matter_expert)
        )
      )
  )
  (:action release_analyst_from_case
    :parameters (?alert_case - alert_case ?analyst - analyst)
    :precondition
      (and
        (analyst_assigned_to_case ?alert_case ?analyst)
        (not
          (secondary_review_authorized_flag ?alert_case)
        )
        (not
          (specialist_assignment_confirmed_flag ?alert_case)
        )
      )
    :effect
      (and
        (not
          (analyst_assigned_to_case ?alert_case ?analyst)
        )
        (analyst_available ?analyst)
        (not
          (case_has_assigned_analyst ?alert_case)
        )
        (not
          (sme_escalation_flag ?alert_case)
        )
        (not
          (final_approval_flag ?alert_case)
        )
        (not
          (sme_review_completed_flag ?alert_case)
        )
        (not
          (interim_escalation_flag ?alert_case)
        )
        (not
          (preflag_for_secondary_review ?alert_case)
        )
      )
  )
  (:action request_recheck_for_evidence
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (not
          (recheck_requested_flag ?alert_case)
        )
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
        (sme_review_completed_flag ?alert_case)
        (secondary_review_authorized_flag ?alert_case)
        (not
          (preflag_for_secondary_review ?alert_case)
        )
      )
    :effect
      (and
        (recheck_requested_flag ?alert_case)
      )
  )
  (:action finalize_case_with_approver_confirmation
    :parameters (?alert_case - alert_case ?approver - approver)
    :precondition
      (and
        (recheck_requested_flag ?alert_case)
        (secondary_review_authorized_flag ?alert_case)
        (specialist_assignment_confirmed_flag ?alert_case)
        (approver_approval_recorded_for_case ?alert_case ?approver)
        (sme_review_completed_flag ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (case_in_secondary_review_queue ?alert_case)
        (not
          (case_fully_approved_flag ?alert_case)
        )
        (has_case_record ?alert_case)
      )
    :effect
      (and
        (case_fully_approved_flag ?alert_case)
      )
  )
  (:action mark_escalation_eligibility_on_evidence
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (not
          (sme_escalation_flag ?alert_case)
        )
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
      )
    :effect
      (and
        (sme_escalation_flag ?alert_case)
      )
  )
  (:action assign_analyst_to_case
    :parameters (?alert_case - alert_case ?analyst - analyst)
    :precondition
      (and
        (not
          (case_has_assigned_analyst ?alert_case)
        )
        (case_in_secondary_review_queue ?alert_case)
        (analyst_available ?analyst)
        (analyst_eligible_for_case ?alert_case ?analyst)
      )
    :effect
      (and
        (case_has_assigned_analyst ?alert_case)
        (not
          (analyst_available ?analyst)
        )
        (analyst_assigned_to_case ?alert_case ?analyst)
      )
  )
  (:action trigger_recheck_and_lock_evidence
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment ?document_checklist - document_checklist)
    :precondition
      (and
        (case_has_assigned_analyst ?alert_case)
        (not
          (sme_review_completed_flag ?alert_case)
        )
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
        (secondary_review_authorized_flag ?alert_case)
        (document_checklist_available ?document_checklist)
        (final_approval_flag ?alert_case)
      )
    :effect
      (and
        (sme_review_completed_flag ?alert_case)
      )
  )
  (:action approver_record_final_approval_on_case_record
    :parameters (?case_record - case_record ?case_alias - case_alias ?approver - approver)
    :precondition
      (and
        (case_in_secondary_review_queue ?case_record)
        (approver_assigned_to_case ?case_alias ?approver)
        (has_case_record ?case_record)
        (not
          (approver_approval_recorded_for_case ?case_record ?approver)
        )
        (approver_linked_to_case ?case_record ?approver)
      )
    :effect
      (and
        (approver_approval_recorded_for_case ?case_record ?approver)
      )
  )
)

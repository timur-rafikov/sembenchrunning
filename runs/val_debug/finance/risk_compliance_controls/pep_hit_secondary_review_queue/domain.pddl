(define (domain pep_hit_secondary_review_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types alert_case - object analyst - object specialist - object customer_attribute - object watchlist_item - object sanctions_check_resource - object evidence_attachment - object subject_matter_expert - object approver - object document_checklist - object external_report - object third_party_verification - object authority_role - object compliance_officer - authority_role review_manager - authority_role case_alias - alert_case case_record - alert_case)
  (:predicates
    (case_in_secondary_review_queue ?alert_case - alert_case)
    (analyst_assigned_to_case ?alert_case - alert_case ?analyst - analyst)
    (case_has_assigned_analyst ?alert_case - alert_case)
    (sme_escalation_flag ?alert_case - alert_case)
    (sme_review_completed_flag ?alert_case - alert_case)
    (watchlist_item_reserved_for_case ?alert_case - alert_case ?watchlist_item - watchlist_item)
    (customer_attribute_reserved_for_case ?alert_case - alert_case ?customer_attribute - customer_attribute)
    (sanctions_check_reserved_for_case ?alert_case - alert_case ?sanctions_check_resource - sanctions_check_resource)
    (third_party_verification_reserved_for_case ?alert_case - alert_case ?third_party_verification - third_party_verification)
    (specialist_assigned_to_case ?alert_case - alert_case ?specialist_queue - specialist)
    (specialist_assignment_confirmed_flag ?alert_case - alert_case)
    (secondary_review_authorized_flag ?alert_case - alert_case)
    (recheck_requested_flag ?alert_case - alert_case)
    (case_fully_approved_flag ?alert_case - alert_case)
    (preflag_for_secondary_review ?alert_case - alert_case)
    (final_approval_flag ?alert_case - alert_case)
    (approver_linked_to_case ?alert_case - alert_case ?approver - approver)
    (approver_approval_recorded_for_case ?alert_case - alert_case ?approver - approver)
    (external_reporting_flag ?alert_case - alert_case)
    (analyst_available ?analyst - analyst)
    (specialist_available ?specialist_queue - specialist)
    (watchlist_item_available ?watchlist_item - watchlist_item)
    (customer_attribute_available ?customer_attribute - customer_attribute)
    (sanctions_check_available ?sanctions_check_resource - sanctions_check_resource)
    (evidence_attachment_available ?evidence_attachment - evidence_attachment)
    (subject_matter_expert_available ?subject_matter_expert - subject_matter_expert)
    (approver_available ?approver - approver)
    (document_checklist_available ?document_checklist - document_checklist)
    (external_report_available ?external_report - external_report)
    (third_party_verification_available ?third_party_verification - third_party_verification)
    (analyst_eligible_for_case ?alert_case - alert_case ?analyst - analyst)
    (case_eligible_for_specialist ?alert_case - alert_case ?specialist_queue - specialist)
    (case_eligible_for_watchlist_item ?alert_case - alert_case ?watchlist_item - watchlist_item)
    (case_eligible_for_attribute_check ?alert_case - alert_case ?customer_attribute - customer_attribute)
    (case_eligible_for_sanctions_check ?alert_case - alert_case ?sanctions_check_resource - sanctions_check_resource)
    (case_eligible_for_external_report ?alert_case - alert_case ?external_report - external_report)
    (case_eligible_for_third_party_verification ?alert_case - alert_case ?third_party_verification - third_party_verification)
    (authority_role_linked_to_case ?alert_case - alert_case ?authority_role - authority_role)
    (approver_assigned_to_case ?alert_case - alert_case ?approver - approver)
    (has_case_alias ?alert_case - alert_case)
    (has_case_record ?alert_case - alert_case)
    (evidence_attached_to_case ?alert_case - alert_case ?evidence_attachment - evidence_attachment)
    (interim_escalation_flag ?alert_case - alert_case)
    (approver_eligible_for_case ?alert_case - alert_case ?approver - approver)
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
  (:action assign_analyst_to_case
    :parameters (?alert_case - alert_case ?analyst - analyst)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (analyst_available ?analyst)
        (analyst_eligible_for_case ?alert_case ?analyst)
        (not
          (case_has_assigned_analyst ?alert_case)
        )
      )
    :effect
      (and
        (analyst_assigned_to_case ?alert_case ?analyst)
        (case_has_assigned_analyst ?alert_case)
        (not
          (analyst_available ?analyst)
        )
      )
  )
  (:action release_analyst_from_case
    :parameters (?alert_case - alert_case ?analyst - analyst)
    :precondition
      (and
        (analyst_assigned_to_case ?alert_case ?analyst)
        (not
          (specialist_assignment_confirmed_flag ?alert_case)
        )
        (not
          (secondary_review_authorized_flag ?alert_case)
        )
      )
    :effect
      (and
        (not
          (analyst_assigned_to_case ?alert_case ?analyst)
        )
        (not
          (case_has_assigned_analyst ?alert_case)
        )
        (not
          (sme_escalation_flag ?alert_case)
        )
        (not
          (sme_review_completed_flag ?alert_case)
        )
        (not
          (preflag_for_secondary_review ?alert_case)
        )
        (not
          (final_approval_flag ?alert_case)
        )
        (not
          (interim_escalation_flag ?alert_case)
        )
        (analyst_available ?analyst)
      )
  )
  (:action lock_evidence_attachment
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (evidence_attachment_available ?evidence_attachment)
      )
    :effect
      (and
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
        (not
          (evidence_attachment_available ?evidence_attachment)
        )
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
  (:action mark_escalation_eligibility_on_evidence
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
        (not
          (sme_escalation_flag ?alert_case)
        )
      )
    :effect
      (and
        (sme_escalation_flag ?alert_case)
      )
  )
  (:action escalate_to_sme_and_preflag
    :parameters (?alert_case - alert_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (subject_matter_expert_available ?subject_matter_expert)
        (not
          (sme_escalation_flag ?alert_case)
        )
      )
    :effect
      (and
        (sme_escalation_flag ?alert_case)
        (preflag_for_secondary_review ?alert_case)
        (not
          (subject_matter_expert_available ?subject_matter_expert)
        )
      )
  )
  (:action sme_perform_review_and_set_completion
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment ?document_checklist - document_checklist)
    :precondition
      (and
        (sme_escalation_flag ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
        (document_checklist_available ?document_checklist)
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
        (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
        (not
          (watchlist_item_available ?watchlist_item)
        )
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
  (:action reserve_sanctions_check_for_case
    :parameters (?alert_case - alert_case ?sanctions_check_resource - sanctions_check_resource)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (sanctions_check_available ?sanctions_check_resource)
        (case_eligible_for_sanctions_check ?alert_case ?sanctions_check_resource)
      )
    :effect
      (and
        (sanctions_check_reserved_for_case ?alert_case ?sanctions_check_resource)
        (not
          (sanctions_check_available ?sanctions_check_resource)
        )
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
  (:action reserve_third_party_verification_for_case
    :parameters (?alert_case - alert_case ?third_party_verification - third_party_verification)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (third_party_verification_available ?third_party_verification)
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
  (:action assign_specialist_to_case
    :parameters (?alert_case - alert_case ?specialist_queue - specialist ?watchlist_item - watchlist_item ?customer_attribute - customer_attribute)
    :precondition
      (and
        (case_has_assigned_analyst ?alert_case)
        (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
        (customer_attribute_reserved_for_case ?alert_case ?customer_attribute)
        (specialist_available ?specialist_queue)
        (case_eligible_for_specialist ?alert_case ?specialist_queue)
        (not
          (specialist_assignment_confirmed_flag ?alert_case)
        )
      )
    :effect
      (and
        (specialist_assigned_to_case ?alert_case ?specialist_queue)
        (specialist_assignment_confirmed_flag ?alert_case)
        (not
          (specialist_available ?specialist_queue)
        )
      )
  )
  (:action assign_specialist_with_report_and_flags
    :parameters (?alert_case - alert_case ?specialist_queue - specialist ?sanctions_check_resource - sanctions_check_resource ?external_report - external_report)
    :precondition
      (and
        (case_has_assigned_analyst ?alert_case)
        (sanctions_check_reserved_for_case ?alert_case ?sanctions_check_resource)
        (external_report_available ?external_report)
        (specialist_available ?specialist_queue)
        (case_eligible_for_specialist ?alert_case ?specialist_queue)
        (case_eligible_for_external_report ?alert_case ?external_report)
        (not
          (specialist_assignment_confirmed_flag ?alert_case)
        )
      )
    :effect
      (and
        (specialist_assigned_to_case ?alert_case ?specialist_queue)
        (specialist_assignment_confirmed_flag ?alert_case)
        (interim_escalation_flag ?alert_case)
        (preflag_for_secondary_review ?alert_case)
        (not
          (specialist_available ?specialist_queue)
        )
        (not
          (external_report_available ?external_report)
        )
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
  (:action record_secondary_review_decision_by_compliance_officer
    :parameters (?alert_case - alert_case ?watchlist_item - watchlist_item ?customer_attribute - customer_attribute ?compliance_officer - compliance_officer)
    :precondition
      (and
        (sme_review_completed_flag ?alert_case)
        (specialist_assignment_confirmed_flag ?alert_case)
        (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
        (customer_attribute_reserved_for_case ?alert_case ?customer_attribute)
        (authority_role_linked_to_case ?alert_case ?compliance_officer)
        (not
          (preflag_for_secondary_review ?alert_case)
        )
        (not
          (secondary_review_authorized_flag ?alert_case)
        )
      )
    :effect
      (and
        (secondary_review_authorized_flag ?alert_case)
      )
  )
  (:action record_secondary_review_decision_by_review_manager
    :parameters (?alert_case - alert_case ?sanctions_check_resource - sanctions_check_resource ?third_party_verification - third_party_verification ?review_manager - review_manager)
    :precondition
      (and
        (sme_review_completed_flag ?alert_case)
        (specialist_assignment_confirmed_flag ?alert_case)
        (sanctions_check_reserved_for_case ?alert_case ?sanctions_check_resource)
        (third_party_verification_reserved_for_case ?alert_case ?third_party_verification)
        (authority_role_linked_to_case ?alert_case ?review_manager)
        (not
          (secondary_review_authorized_flag ?alert_case)
        )
      )
    :effect
      (and
        (secondary_review_authorized_flag ?alert_case)
        (preflag_for_secondary_review ?alert_case)
      )
  )
  (:action finalize_secondary_review_decision_and_lock
    :parameters (?alert_case - alert_case ?watchlist_item - watchlist_item ?customer_attribute - customer_attribute)
    :precondition
      (and
        (secondary_review_authorized_flag ?alert_case)
        (preflag_for_secondary_review ?alert_case)
        (watchlist_item_reserved_for_case ?alert_case ?watchlist_item)
        (customer_attribute_reserved_for_case ?alert_case ?customer_attribute)
      )
    :effect
      (and
        (final_approval_flag ?alert_case)
        (not
          (preflag_for_secondary_review ?alert_case)
        )
        (not
          (sme_review_completed_flag ?alert_case)
        )
        (not
          (interim_escalation_flag ?alert_case)
        )
      )
  )
  (:action trigger_recheck_and_lock_evidence
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment ?document_checklist - document_checklist)
    :precondition
      (and
        (final_approval_flag ?alert_case)
        (secondary_review_authorized_flag ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
        (document_checklist_available ?document_checklist)
        (not
          (sme_review_completed_flag ?alert_case)
        )
      )
    :effect
      (and
        (sme_review_completed_flag ?alert_case)
      )
  )
  (:action request_recheck_for_evidence
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment)
    :precondition
      (and
        (secondary_review_authorized_flag ?alert_case)
        (sme_review_completed_flag ?alert_case)
        (not
          (preflag_for_secondary_review ?alert_case)
        )
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
        (not
          (recheck_requested_flag ?alert_case)
        )
      )
    :effect
      (and
        (recheck_requested_flag ?alert_case)
      )
  )
  (:action request_recheck_with_sme
    :parameters (?alert_case - alert_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (secondary_review_authorized_flag ?alert_case)
        (sme_review_completed_flag ?alert_case)
        (not
          (preflag_for_secondary_review ?alert_case)
        )
        (subject_matter_expert_available ?subject_matter_expert)
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
  (:action approver_record_final_approval_on_case_record
    :parameters (?case_record - case_record ?case_alias - case_alias ?approver - approver)
    :precondition
      (and
        (case_in_secondary_review_queue ?case_record)
        (has_case_record ?case_record)
        (approver_linked_to_case ?case_record ?approver)
        (approver_assigned_to_case ?case_alias ?approver)
        (not
          (approver_approval_recorded_for_case ?case_record ?approver)
        )
      )
    :effect
      (and
        (approver_approval_recorded_for_case ?case_record ?approver)
      )
  )
  (:action record_case_recheck_notification
    :parameters (?alert_case - alert_case ?evidence_attachment - evidence_attachment ?document_checklist - document_checklist)
    :precondition
      (and
        (case_in_secondary_review_queue ?alert_case)
        (has_case_record ?alert_case)
        (sme_review_completed_flag ?alert_case)
        (recheck_requested_flag ?alert_case)
        (evidence_attached_to_case ?alert_case ?evidence_attachment)
        (document_checklist_available ?document_checklist)
        (not
          (external_reporting_flag ?alert_case)
        )
      )
    :effect
      (and
        (external_reporting_flag ?alert_case)
      )
  )
  (:action finalize_case_with_alias_type_a
    :parameters (?alert_case - alert_case)
    :precondition
      (and
        (has_case_alias ?alert_case)
        (case_in_secondary_review_queue ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (specialist_assignment_confirmed_flag ?alert_case)
        (secondary_review_authorized_flag ?alert_case)
        (recheck_requested_flag ?alert_case)
        (sme_review_completed_flag ?alert_case)
        (not
          (case_fully_approved_flag ?alert_case)
        )
      )
    :effect
      (and
        (case_fully_approved_flag ?alert_case)
      )
  )
  (:action finalize_case_with_approver_confirmation
    :parameters (?alert_case - alert_case ?approver - approver)
    :precondition
      (and
        (has_case_record ?alert_case)
        (case_in_secondary_review_queue ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (specialist_assignment_confirmed_flag ?alert_case)
        (secondary_review_authorized_flag ?alert_case)
        (recheck_requested_flag ?alert_case)
        (sme_review_completed_flag ?alert_case)
        (approver_approval_recorded_for_case ?alert_case ?approver)
        (not
          (case_fully_approved_flag ?alert_case)
        )
      )
    :effect
      (and
        (case_fully_approved_flag ?alert_case)
      )
  )
  (:action finalize_case_with_recheck_confirmation
    :parameters (?alert_case - alert_case)
    :precondition
      (and
        (has_case_record ?alert_case)
        (case_in_secondary_review_queue ?alert_case)
        (case_has_assigned_analyst ?alert_case)
        (specialist_assignment_confirmed_flag ?alert_case)
        (secondary_review_authorized_flag ?alert_case)
        (recheck_requested_flag ?alert_case)
        (sme_review_completed_flag ?alert_case)
        (external_reporting_flag ?alert_case)
        (not
          (case_fully_approved_flag ?alert_case)
        )
      )
    :effect
      (and
        (case_fully_approved_flag ?alert_case)
      )
  )
)

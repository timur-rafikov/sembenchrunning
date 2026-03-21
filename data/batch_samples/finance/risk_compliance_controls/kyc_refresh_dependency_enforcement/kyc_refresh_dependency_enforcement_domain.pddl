(define (domain finance_kyc_refresh_dependency_enforcement)
  (:requirements :strips :typing :negative-preconditions)
  (:types kyc_refresh_case - object transaction_event - object risk_check - object third_party_data_source - object screening_profile - object watchlist - object remediation_task - object compliance_officer - object approval_policy - object authorized_attestor - object identity_document - object kyc_refresh_trigger_type - object escalation_group - object escalation_group_member - escalation_group senior_escalation_member - escalation_group initiating_account_case - kyc_refresh_case related_account_case - kyc_refresh_case)
  (:predicates
    (kyc_refresh_case_open ?kyc_refresh_case - kyc_refresh_case)
    (case_associated_transaction ?kyc_refresh_case - kyc_refresh_case ?transaction_event - transaction_event)
    (case_transaction_linked_flag ?kyc_refresh_case - kyc_refresh_case)
    (case_escalation_initiated ?kyc_refresh_case - kyc_refresh_case)
    (case_remediation_completed ?kyc_refresh_case - kyc_refresh_case)
    (case_bound_screening_profile ?kyc_refresh_case - kyc_refresh_case ?screening_profile - screening_profile)
    (case_bound_data_source ?kyc_refresh_case - kyc_refresh_case ?third_party_data_source - third_party_data_source)
    (case_bound_watchlist ?kyc_refresh_case - kyc_refresh_case ?watchlist - watchlist)
    (case_bound_trigger_type ?kyc_refresh_case - kyc_refresh_case ?kyc_refresh_trigger_type - kyc_refresh_trigger_type)
    (case_risk_check_assessed ?kyc_refresh_case - kyc_refresh_case ?risk_check - risk_check)
    (case_screening_completed ?kyc_refresh_case - kyc_refresh_case)
    (case_escalation_acknowledged ?kyc_refresh_case - kyc_refresh_case)
    (case_evidence_attested ?kyc_refresh_case - kyc_refresh_case)
    (case_finalized ?kyc_refresh_case - kyc_refresh_case)
    (case_pending_manual_review ?kyc_refresh_case - kyc_refresh_case)
    (case_approved ?kyc_refresh_case - kyc_refresh_case)
    (case_policy_binding_present ?kyc_refresh_case - kyc_refresh_case ?approval_policy - approval_policy)
    (case_approval_policy_enforced ?kyc_refresh_case - kyc_refresh_case ?approval_policy - approval_policy)
    (case_attestation_confirmed ?kyc_refresh_case - kyc_refresh_case)
    (transaction_available ?transaction_event - transaction_event)
    (risk_check_available ?risk_check - risk_check)
    (screening_profile_available ?screening_profile - screening_profile)
    (data_source_available ?third_party_data_source - third_party_data_source)
    (watchlist_available ?watchlist - watchlist)
    (remediation_task_available ?remediation_task - remediation_task)
    (compliance_officer_available ?compliance_officer - compliance_officer)
    (approval_policy_available ?approval_policy - approval_policy)
    (authorized_attestor_available ?authorized_attestor - authorized_attestor)
    (identity_document_available ?identity_document - identity_document)
    (trigger_type_available ?kyc_refresh_trigger_type - kyc_refresh_trigger_type)
    (case_transaction_allowed ?kyc_refresh_case - kyc_refresh_case ?transaction_event - transaction_event)
    (case_risk_check_allowed ?kyc_refresh_case - kyc_refresh_case ?risk_check - risk_check)
    (case_screening_profile_allowed ?kyc_refresh_case - kyc_refresh_case ?screening_profile - screening_profile)
    (case_data_source_allowed ?kyc_refresh_case - kyc_refresh_case ?third_party_data_source - third_party_data_source)
    (case_watchlist_allowed ?kyc_refresh_case - kyc_refresh_case ?watchlist - watchlist)
    (case_identity_document_allowed ?kyc_refresh_case - kyc_refresh_case ?identity_document - identity_document)
    (case_trigger_type_allowed ?kyc_refresh_case - kyc_refresh_case ?kyc_refresh_trigger_type - kyc_refresh_trigger_type)
    (case_associated_escalation_member ?kyc_refresh_case - kyc_refresh_case ?escalation_group - escalation_group)
    (case_bound_approval_policy ?kyc_refresh_case - kyc_refresh_case ?approval_policy - approval_policy)
    (case_eligible_for_finalization ?kyc_refresh_case - kyc_refresh_case)
    (case_related_account_flag ?kyc_refresh_case - kyc_refresh_case)
    (case_assigned_remediation_task ?kyc_refresh_case - kyc_refresh_case ?remediation_task - remediation_task)
    (case_escalation_marker ?kyc_refresh_case - kyc_refresh_case)
    (case_policy_cross_link ?kyc_refresh_case - kyc_refresh_case ?approval_policy - approval_policy)
  )
  (:action open_kyc_refresh_case
    :parameters (?kyc_refresh_case - kyc_refresh_case)
    :precondition
      (and
        (not
          (kyc_refresh_case_open ?kyc_refresh_case)
        )
        (not
          (case_finalized ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
      )
  )
  (:action associate_transaction_with_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?transaction_event - transaction_event)
    :precondition
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
        (transaction_available ?transaction_event)
        (case_transaction_allowed ?kyc_refresh_case ?transaction_event)
        (not
          (case_transaction_linked_flag ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_associated_transaction ?kyc_refresh_case ?transaction_event)
        (case_transaction_linked_flag ?kyc_refresh_case)
        (not
          (transaction_available ?transaction_event)
        )
      )
  )
  (:action dissociate_transaction_from_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?transaction_event - transaction_event)
    :precondition
      (and
        (case_associated_transaction ?kyc_refresh_case ?transaction_event)
        (not
          (case_screening_completed ?kyc_refresh_case)
        )
        (not
          (case_escalation_acknowledged ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (not
          (case_associated_transaction ?kyc_refresh_case ?transaction_event)
        )
        (not
          (case_transaction_linked_flag ?kyc_refresh_case)
        )
        (not
          (case_escalation_initiated ?kyc_refresh_case)
        )
        (not
          (case_remediation_completed ?kyc_refresh_case)
        )
        (not
          (case_pending_manual_review ?kyc_refresh_case)
        )
        (not
          (case_approved ?kyc_refresh_case)
        )
        (not
          (case_escalation_marker ?kyc_refresh_case)
        )
        (transaction_available ?transaction_event)
      )
  )
  (:action create_remediation_task_for_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?remediation_task - remediation_task)
    :precondition
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
        (remediation_task_available ?remediation_task)
      )
    :effect
      (and
        (case_assigned_remediation_task ?kyc_refresh_case ?remediation_task)
        (not
          (remediation_task_available ?remediation_task)
        )
      )
  )
  (:action release_remediation_task
    :parameters (?kyc_refresh_case - kyc_refresh_case ?remediation_task - remediation_task)
    :precondition
      (and
        (case_assigned_remediation_task ?kyc_refresh_case ?remediation_task)
      )
    :effect
      (and
        (remediation_task_available ?remediation_task)
        (not
          (case_assigned_remediation_task ?kyc_refresh_case ?remediation_task)
        )
      )
  )
  (:action initiate_escalation_for_remediation_task
    :parameters (?kyc_refresh_case - kyc_refresh_case ?remediation_task - remediation_task)
    :precondition
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
        (case_transaction_linked_flag ?kyc_refresh_case)
        (case_assigned_remediation_task ?kyc_refresh_case ?remediation_task)
        (not
          (case_escalation_initiated ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_escalation_initiated ?kyc_refresh_case)
      )
  )
  (:action escalate_by_compliance_officer
    :parameters (?kyc_refresh_case - kyc_refresh_case ?compliance_officer - compliance_officer)
    :precondition
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
        (case_transaction_linked_flag ?kyc_refresh_case)
        (compliance_officer_available ?compliance_officer)
        (not
          (case_escalation_initiated ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_escalation_initiated ?kyc_refresh_case)
        (case_pending_manual_review ?kyc_refresh_case)
        (not
          (compliance_officer_available ?compliance_officer)
        )
      )
  )
  (:action attestor_attest_remediation
    :parameters (?kyc_refresh_case - kyc_refresh_case ?remediation_task - remediation_task ?authorized_attestor - authorized_attestor)
    :precondition
      (and
        (case_escalation_initiated ?kyc_refresh_case)
        (case_transaction_linked_flag ?kyc_refresh_case)
        (case_assigned_remediation_task ?kyc_refresh_case ?remediation_task)
        (authorized_attestor_available ?authorized_attestor)
        (not
          (case_remediation_completed ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_remediation_completed ?kyc_refresh_case)
        (not
          (case_pending_manual_review ?kyc_refresh_case)
        )
      )
  )
  (:action attest_remediation_via_approval_policy
    :parameters (?kyc_refresh_case - kyc_refresh_case ?approval_policy - approval_policy)
    :precondition
      (and
        (case_transaction_linked_flag ?kyc_refresh_case)
        (case_approval_policy_enforced ?kyc_refresh_case ?approval_policy)
        (not
          (case_remediation_completed ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_remediation_completed ?kyc_refresh_case)
        (not
          (case_pending_manual_review ?kyc_refresh_case)
        )
      )
  )
  (:action bind_screening_profile_to_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?screening_profile - screening_profile)
    :precondition
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
        (screening_profile_available ?screening_profile)
        (case_screening_profile_allowed ?kyc_refresh_case ?screening_profile)
      )
    :effect
      (and
        (case_bound_screening_profile ?kyc_refresh_case ?screening_profile)
        (not
          (screening_profile_available ?screening_profile)
        )
      )
  )
  (:action unbind_screening_profile_from_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?screening_profile - screening_profile)
    :precondition
      (and
        (case_bound_screening_profile ?kyc_refresh_case ?screening_profile)
      )
    :effect
      (and
        (screening_profile_available ?screening_profile)
        (not
          (case_bound_screening_profile ?kyc_refresh_case ?screening_profile)
        )
      )
  )
  (:action bind_data_source_to_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?third_party_data_source - third_party_data_source)
    :precondition
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
        (data_source_available ?third_party_data_source)
        (case_data_source_allowed ?kyc_refresh_case ?third_party_data_source)
      )
    :effect
      (and
        (case_bound_data_source ?kyc_refresh_case ?third_party_data_source)
        (not
          (data_source_available ?third_party_data_source)
        )
      )
  )
  (:action unbind_data_source_from_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?third_party_data_source - third_party_data_source)
    :precondition
      (and
        (case_bound_data_source ?kyc_refresh_case ?third_party_data_source)
      )
    :effect
      (and
        (data_source_available ?third_party_data_source)
        (not
          (case_bound_data_source ?kyc_refresh_case ?third_party_data_source)
        )
      )
  )
  (:action bind_watchlist_to_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?watchlist - watchlist)
    :precondition
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
        (watchlist_available ?watchlist)
        (case_watchlist_allowed ?kyc_refresh_case ?watchlist)
      )
    :effect
      (and
        (case_bound_watchlist ?kyc_refresh_case ?watchlist)
        (not
          (watchlist_available ?watchlist)
        )
      )
  )
  (:action unbind_watchlist_from_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?watchlist - watchlist)
    :precondition
      (and
        (case_bound_watchlist ?kyc_refresh_case ?watchlist)
      )
    :effect
      (and
        (watchlist_available ?watchlist)
        (not
          (case_bound_watchlist ?kyc_refresh_case ?watchlist)
        )
      )
  )
  (:action bind_trigger_type_to_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?kyc_refresh_trigger_type - kyc_refresh_trigger_type)
    :precondition
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
        (trigger_type_available ?kyc_refresh_trigger_type)
        (case_trigger_type_allowed ?kyc_refresh_case ?kyc_refresh_trigger_type)
      )
    :effect
      (and
        (case_bound_trigger_type ?kyc_refresh_case ?kyc_refresh_trigger_type)
        (not
          (trigger_type_available ?kyc_refresh_trigger_type)
        )
      )
  )
  (:action unbind_trigger_type_from_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?kyc_refresh_trigger_type - kyc_refresh_trigger_type)
    :precondition
      (and
        (case_bound_trigger_type ?kyc_refresh_case ?kyc_refresh_trigger_type)
      )
    :effect
      (and
        (trigger_type_available ?kyc_refresh_trigger_type)
        (not
          (case_bound_trigger_type ?kyc_refresh_case ?kyc_refresh_trigger_type)
        )
      )
  )
  (:action execute_risk_check_and_aggregate
    :parameters (?kyc_refresh_case - kyc_refresh_case ?risk_check - risk_check ?screening_profile - screening_profile ?third_party_data_source - third_party_data_source)
    :precondition
      (and
        (case_transaction_linked_flag ?kyc_refresh_case)
        (case_bound_screening_profile ?kyc_refresh_case ?screening_profile)
        (case_bound_data_source ?kyc_refresh_case ?third_party_data_source)
        (risk_check_available ?risk_check)
        (case_risk_check_allowed ?kyc_refresh_case ?risk_check)
        (not
          (case_screening_completed ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_risk_check_assessed ?kyc_refresh_case ?risk_check)
        (case_screening_completed ?kyc_refresh_case)
        (not
          (risk_check_available ?risk_check)
        )
      )
  )
  (:action execute_risk_check_with_identity_and_escalation
    :parameters (?kyc_refresh_case - kyc_refresh_case ?risk_check - risk_check ?watchlist - watchlist ?identity_document - identity_document)
    :precondition
      (and
        (case_transaction_linked_flag ?kyc_refresh_case)
        (case_bound_watchlist ?kyc_refresh_case ?watchlist)
        (identity_document_available ?identity_document)
        (risk_check_available ?risk_check)
        (case_risk_check_allowed ?kyc_refresh_case ?risk_check)
        (case_identity_document_allowed ?kyc_refresh_case ?identity_document)
        (not
          (case_screening_completed ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_risk_check_assessed ?kyc_refresh_case ?risk_check)
        (case_screening_completed ?kyc_refresh_case)
        (case_escalation_marker ?kyc_refresh_case)
        (case_pending_manual_review ?kyc_refresh_case)
        (not
          (risk_check_available ?risk_check)
        )
        (not
          (identity_document_available ?identity_document)
        )
      )
  )
  (:action clear_escalation_marker
    :parameters (?kyc_refresh_case - kyc_refresh_case ?screening_profile - screening_profile ?third_party_data_source - third_party_data_source)
    :precondition
      (and
        (case_screening_completed ?kyc_refresh_case)
        (case_escalation_marker ?kyc_refresh_case)
        (case_bound_screening_profile ?kyc_refresh_case ?screening_profile)
        (case_bound_data_source ?kyc_refresh_case ?third_party_data_source)
      )
    :effect
      (and
        (not
          (case_escalation_marker ?kyc_refresh_case)
        )
        (not
          (case_pending_manual_review ?kyc_refresh_case)
        )
      )
  )
  (:action request_escalation_approval
    :parameters (?kyc_refresh_case - kyc_refresh_case ?screening_profile - screening_profile ?third_party_data_source - third_party_data_source ?escalation_group_member - escalation_group_member)
    :precondition
      (and
        (case_remediation_completed ?kyc_refresh_case)
        (case_screening_completed ?kyc_refresh_case)
        (case_bound_screening_profile ?kyc_refresh_case ?screening_profile)
        (case_bound_data_source ?kyc_refresh_case ?third_party_data_source)
        (case_associated_escalation_member ?kyc_refresh_case ?escalation_group_member)
        (not
          (case_pending_manual_review ?kyc_refresh_case)
        )
        (not
          (case_escalation_acknowledged ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_escalation_acknowledged ?kyc_refresh_case)
      )
  )
  (:action confirm_escalation_approval
    :parameters (?kyc_refresh_case - kyc_refresh_case ?watchlist - watchlist ?kyc_refresh_trigger_type - kyc_refresh_trigger_type ?senior_escalation_member - senior_escalation_member)
    :precondition
      (and
        (case_remediation_completed ?kyc_refresh_case)
        (case_screening_completed ?kyc_refresh_case)
        (case_bound_watchlist ?kyc_refresh_case ?watchlist)
        (case_bound_trigger_type ?kyc_refresh_case ?kyc_refresh_trigger_type)
        (case_associated_escalation_member ?kyc_refresh_case ?senior_escalation_member)
        (not
          (case_escalation_acknowledged ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_escalation_acknowledged ?kyc_refresh_case)
        (case_pending_manual_review ?kyc_refresh_case)
      )
  )
  (:action finalize_escalation_approval
    :parameters (?kyc_refresh_case - kyc_refresh_case ?screening_profile - screening_profile ?third_party_data_source - third_party_data_source)
    :precondition
      (and
        (case_escalation_acknowledged ?kyc_refresh_case)
        (case_pending_manual_review ?kyc_refresh_case)
        (case_bound_screening_profile ?kyc_refresh_case ?screening_profile)
        (case_bound_data_source ?kyc_refresh_case ?third_party_data_source)
      )
    :effect
      (and
        (case_approved ?kyc_refresh_case)
        (not
          (case_pending_manual_review ?kyc_refresh_case)
        )
        (not
          (case_remediation_completed ?kyc_refresh_case)
        )
        (not
          (case_escalation_marker ?kyc_refresh_case)
        )
      )
  )
  (:action attestor_validate_task_after_approval
    :parameters (?kyc_refresh_case - kyc_refresh_case ?remediation_task - remediation_task ?authorized_attestor - authorized_attestor)
    :precondition
      (and
        (case_approved ?kyc_refresh_case)
        (case_escalation_acknowledged ?kyc_refresh_case)
        (case_transaction_linked_flag ?kyc_refresh_case)
        (case_assigned_remediation_task ?kyc_refresh_case ?remediation_task)
        (authorized_attestor_available ?authorized_attestor)
        (not
          (case_remediation_completed ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_remediation_completed ?kyc_refresh_case)
      )
  )
  (:action assign_attestor_to_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?remediation_task - remediation_task)
    :precondition
      (and
        (case_escalation_acknowledged ?kyc_refresh_case)
        (case_remediation_completed ?kyc_refresh_case)
        (not
          (case_pending_manual_review ?kyc_refresh_case)
        )
        (case_assigned_remediation_task ?kyc_refresh_case ?remediation_task)
        (not
          (case_evidence_attested ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_evidence_attested ?kyc_refresh_case)
      )
  )
  (:action assign_officer_attestation
    :parameters (?kyc_refresh_case - kyc_refresh_case ?compliance_officer - compliance_officer)
    :precondition
      (and
        (case_escalation_acknowledged ?kyc_refresh_case)
        (case_remediation_completed ?kyc_refresh_case)
        (not
          (case_pending_manual_review ?kyc_refresh_case)
        )
        (compliance_officer_available ?compliance_officer)
        (not
          (case_evidence_attested ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_evidence_attested ?kyc_refresh_case)
        (not
          (compliance_officer_available ?compliance_officer)
        )
      )
  )
  (:action bind_approval_policy_to_case
    :parameters (?kyc_refresh_case - kyc_refresh_case ?approval_policy - approval_policy)
    :precondition
      (and
        (case_evidence_attested ?kyc_refresh_case)
        (approval_policy_available ?approval_policy)
        (case_policy_cross_link ?kyc_refresh_case ?approval_policy)
      )
    :effect
      (and
        (case_bound_approval_policy ?kyc_refresh_case ?approval_policy)
        (not
          (approval_policy_available ?approval_policy)
        )
      )
  )
  (:action orchestrate_cross_case_policy_link
    :parameters (?kyc_refresh_case - related_account_case ?related_account_case - initiating_account_case ?approval_policy - approval_policy)
    :precondition
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
        (case_related_account_flag ?kyc_refresh_case)
        (case_policy_binding_present ?kyc_refresh_case ?approval_policy)
        (case_bound_approval_policy ?related_account_case ?approval_policy)
        (not
          (case_approval_policy_enforced ?kyc_refresh_case ?approval_policy)
        )
      )
    :effect
      (and
        (case_approval_policy_enforced ?kyc_refresh_case ?approval_policy)
      )
  )
  (:action mark_case_attestation_confirmed
    :parameters (?kyc_refresh_case - kyc_refresh_case ?remediation_task - remediation_task ?authorized_attestor - authorized_attestor)
    :precondition
      (and
        (kyc_refresh_case_open ?kyc_refresh_case)
        (case_related_account_flag ?kyc_refresh_case)
        (case_remediation_completed ?kyc_refresh_case)
        (case_evidence_attested ?kyc_refresh_case)
        (case_assigned_remediation_task ?kyc_refresh_case ?remediation_task)
        (authorized_attestor_available ?authorized_attestor)
        (not
          (case_attestation_confirmed ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_attestation_confirmed ?kyc_refresh_case)
      )
  )
  (:action finalize_case_without_policy
    :parameters (?kyc_refresh_case - kyc_refresh_case)
    :precondition
      (and
        (case_eligible_for_finalization ?kyc_refresh_case)
        (kyc_refresh_case_open ?kyc_refresh_case)
        (case_transaction_linked_flag ?kyc_refresh_case)
        (case_screening_completed ?kyc_refresh_case)
        (case_escalation_acknowledged ?kyc_refresh_case)
        (case_evidence_attested ?kyc_refresh_case)
        (case_remediation_completed ?kyc_refresh_case)
        (not
          (case_finalized ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_finalized ?kyc_refresh_case)
      )
  )
  (:action finalize_case_with_policy
    :parameters (?kyc_refresh_case - kyc_refresh_case ?approval_policy - approval_policy)
    :precondition
      (and
        (case_related_account_flag ?kyc_refresh_case)
        (kyc_refresh_case_open ?kyc_refresh_case)
        (case_transaction_linked_flag ?kyc_refresh_case)
        (case_screening_completed ?kyc_refresh_case)
        (case_escalation_acknowledged ?kyc_refresh_case)
        (case_evidence_attested ?kyc_refresh_case)
        (case_remediation_completed ?kyc_refresh_case)
        (case_approval_policy_enforced ?kyc_refresh_case ?approval_policy)
        (not
          (case_finalized ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_finalized ?kyc_refresh_case)
      )
  )
  (:action finalize_case_with_attestation
    :parameters (?kyc_refresh_case - kyc_refresh_case)
    :precondition
      (and
        (case_related_account_flag ?kyc_refresh_case)
        (kyc_refresh_case_open ?kyc_refresh_case)
        (case_transaction_linked_flag ?kyc_refresh_case)
        (case_screening_completed ?kyc_refresh_case)
        (case_escalation_acknowledged ?kyc_refresh_case)
        (case_evidence_attested ?kyc_refresh_case)
        (case_remediation_completed ?kyc_refresh_case)
        (case_attestation_confirmed ?kyc_refresh_case)
        (not
          (case_finalized ?kyc_refresh_case)
        )
      )
    :effect
      (and
        (case_finalized ?kyc_refresh_case)
      )
  )
)

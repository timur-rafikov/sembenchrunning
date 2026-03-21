(define (domain sanctions_screening_hold_release_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types screening_case - object screening_profile - object transaction_channel - object watchlist_hit_type - object party_match - object sanction_match - object alert_evidence - object automated_hit_reason - object approver - object investigator - object external_reference - object sanctions_list - object approval_group - object business_unit - approval_group escalation_committee - approval_group domestic_transaction - screening_case crossborder_transaction - screening_case)
  (:predicates
    (automated_hit_reason_available ?automated_hit_reason - automated_hit_reason)
    (case_watchlist_hit ?screening_case - screening_case ?watchlist_hit_type - watchlist_hit_type)
    (case_ready_for_final_approval ?screening_case - screening_case)
    (case_has_profile ?screening_case - screening_case ?screening_profile - screening_profile)
    (case_approval_group_membership ?screening_case - screening_case ?approval_group - approval_group)
    (sanction_match_resource_available ?sanction_match - sanction_match)
    (watchlist_hit_type_available ?watchlist_hit_type - watchlist_hit_type)
    (case_sanctions_list_mapping ?screening_case - screening_case ?sanctions_list - sanctions_list)
    (case_released ?screening_case - screening_case)
    (requires_domestic_approval_path ?screening_case - screening_case)
    (case_profile_mapping ?screening_case - screening_case ?screening_profile - screening_profile)
    (transaction_channel_available ?transaction_channel - transaction_channel)
    (external_reference_available ?external_reference - external_reference)
    (alert_evidence_available ?alert_evidence - alert_evidence)
    (case_adjudicated ?screening_case - screening_case)
    (case_watchlist_hit_mapping ?screening_case - screening_case ?watchlist_hit_type - watchlist_hit_type)
    (case_list_match ?screening_case - screening_case ?sanctions_list - sanctions_list)
    (case_channel_assigned ?screening_case - screening_case ?transaction_channel - transaction_channel)
    (approval_requested ?screening_case - screening_case)
    (case_sanction_match_mapping ?screening_case - screening_case ?sanction_match - sanction_match)
    (sanctions_list_selected ?sanctions_list - sanctions_list)
    (requires_crossborder_approval_path ?screening_case - screening_case)
    (evidence_collected ?screening_case - screening_case)
    (case_party_match_mapping ?screening_case - screening_case ?party_match - party_match)
    (case_party_match ?screening_case - screening_case ?party_match - party_match)
    (case_requires_senior_review ?screening_case - screening_case)
    (case_evidence_link ?screening_case - screening_case ?alert_evidence - alert_evidence)
    (case_marked_for_final_review ?screening_case - screening_case)
    (case_external_reference_mapping ?screening_case - screening_case ?external_reference - external_reference)
    (case_registered ?screening_case - screening_case)
    (screening_profile_available ?screening_profile - screening_profile)
    (case_profile_applied ?screening_case - screening_case)
    (investigator_available ?investigator - investigator)
    (approver_available ?approver - approver)
    (case_sanction_match ?screening_case - screening_case ?sanction_match - sanction_match)
    (approver_assignment_for_case ?screening_case - screening_case ?approver - approver)
    (case_investigation_assigned ?screening_case - screening_case)
    (approver_assigned ?screening_case - screening_case)
    (approver_candidate_for_case ?screening_case - screening_case ?approver - approver)
    (party_match_resource_available ?party_match - party_match)
    (approver_eligible_for_case ?screening_case - screening_case ?approver - approver)
    (case_channel_mapping ?screening_case - screening_case ?transaction_channel - transaction_channel)
    (case_high_risk_flag ?screening_case - screening_case)
    (approver_approval_record ?screening_case - screening_case ?approver - approver)
  )
  (:action unlink_sanctions_list_from_case
    :parameters (?screening_case - screening_case ?sanctions_list - sanctions_list)
    :precondition
      (and
        (case_list_match ?screening_case ?sanctions_list)
      )
    :effect
      (and
        (sanctions_list_selected ?sanctions_list)
        (not
          (case_list_match ?screening_case ?sanctions_list)
        )
      )
  )
  (:action request_approval_from_escalation_committee
    :parameters (?screening_case - screening_case ?sanction_match - sanction_match ?sanctions_list - sanctions_list ?escalation_committee - escalation_committee)
    :precondition
      (and
        (not
          (approval_requested ?screening_case)
        )
        (case_adjudicated ?screening_case)
        (evidence_collected ?screening_case)
        (case_list_match ?screening_case ?sanctions_list)
        (case_approval_group_membership ?screening_case ?escalation_committee)
        (case_sanction_match ?screening_case ?sanction_match)
      )
    :effect
      (and
        (case_high_risk_flag ?screening_case)
        (approval_requested ?screening_case)
      )
  )
  (:action release_case_by_domestic_criteria
    :parameters (?screening_case - screening_case)
    :precondition
      (and
        (evidence_collected ?screening_case)
        (case_profile_applied ?screening_case)
        (case_adjudicated ?screening_case)
        (case_registered ?screening_case)
        (approver_assigned ?screening_case)
        (not
          (case_released ?screening_case)
        )
        (requires_domestic_approval_path ?screening_case)
        (approval_requested ?screening_case)
      )
    :effect
      (and
        (case_released ?screening_case)
      )
  )
  (:action clear_escalation_marker
    :parameters (?screening_case - screening_case ?party_match - party_match ?watchlist_hit_type - watchlist_hit_type)
    :precondition
      (and
        (case_adjudicated ?screening_case)
        (case_requires_senior_review ?screening_case)
        (case_party_match ?screening_case ?party_match)
        (case_watchlist_hit ?screening_case ?watchlist_hit_type)
      )
    :effect
      (and
        (not
          (case_requires_senior_review ?screening_case)
        )
        (not
          (case_high_risk_flag ?screening_case)
        )
      )
  )
  (:action attach_alert_evidence_to_case
    :parameters (?screening_case - screening_case ?alert_evidence - alert_evidence)
    :precondition
      (and
        (alert_evidence_available ?alert_evidence)
        (case_registered ?screening_case)
      )
    :effect
      (and
        (not
          (alert_evidence_available ?alert_evidence)
        )
        (case_evidence_link ?screening_case ?alert_evidence)
      )
  )
  (:action request_approval_from_business_unit
    :parameters (?screening_case - screening_case ?party_match - party_match ?watchlist_hit_type - watchlist_hit_type ?business_unit - business_unit)
    :precondition
      (and
        (case_approval_group_membership ?screening_case ?business_unit)
        (evidence_collected ?screening_case)
        (not
          (case_high_risk_flag ?screening_case)
        )
        (case_party_match ?screening_case ?party_match)
        (case_adjudicated ?screening_case)
        (case_watchlist_hit ?screening_case ?watchlist_hit_type)
        (not
          (approval_requested ?screening_case)
        )
      )
    :effect
      (and
        (approval_requested ?screening_case)
      )
  )
  (:action approver_adds_evidence
    :parameters (?screening_case - screening_case ?approver - approver)
    :precondition
      (and
        (case_profile_applied ?screening_case)
        (approver_approval_record ?screening_case ?approver)
        (not
          (evidence_collected ?screening_case)
        )
      )
    :effect
      (and
        (evidence_collected ?screening_case)
        (not
          (case_high_risk_flag ?screening_case)
        )
      )
  )
  (:action link_sanction_match_to_case
    :parameters (?screening_case - screening_case ?sanction_match - sanction_match)
    :precondition
      (and
        (case_sanction_match_mapping ?screening_case ?sanction_match)
        (case_registered ?screening_case)
        (sanction_match_resource_available ?sanction_match)
      )
    :effect
      (and
        (case_sanction_match ?screening_case ?sanction_match)
        (not
          (sanction_match_resource_available ?sanction_match)
        )
      )
  )
  (:action link_party_match_to_case
    :parameters (?screening_case - screening_case ?party_match - party_match)
    :precondition
      (and
        (case_registered ?screening_case)
        (party_match_resource_available ?party_match)
        (case_party_match_mapping ?screening_case ?party_match)
      )
    :effect
      (and
        (not
          (party_match_resource_available ?party_match)
        )
        (case_party_match ?screening_case ?party_match)
      )
  )
  (:action unlink_sanction_match_from_case
    :parameters (?screening_case - screening_case ?sanction_match - sanction_match)
    :precondition
      (and
        (case_sanction_match ?screening_case ?sanction_match)
      )
    :effect
      (and
        (sanction_match_resource_available ?sanction_match)
        (not
          (case_sanction_match ?screening_case ?sanction_match)
        )
      )
  )
  (:action unlink_watchlist_hit_from_case
    :parameters (?screening_case - screening_case ?watchlist_hit_type - watchlist_hit_type)
    :precondition
      (and
        (case_watchlist_hit ?screening_case ?watchlist_hit_type)
      )
    :effect
      (and
        (watchlist_hit_type_available ?watchlist_hit_type)
        (not
          (case_watchlist_hit ?screening_case ?watchlist_hit_type)
        )
      )
  )
  (:action assign_approver_for_case
    :parameters (?screening_case - screening_case ?approver - approver)
    :precondition
      (and
        (approver_assigned ?screening_case)
        (approver_available ?approver)
        (approver_candidate_for_case ?screening_case ?approver)
      )
    :effect
      (and
        (approver_assignment_for_case ?screening_case ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action link_watchlist_hit_to_case
    :parameters (?screening_case - screening_case ?watchlist_hit_type - watchlist_hit_type)
    :precondition
      (and
        (case_registered ?screening_case)
        (watchlist_hit_type_available ?watchlist_hit_type)
        (case_watchlist_hit_mapping ?screening_case ?watchlist_hit_type)
      )
    :effect
      (and
        (case_watchlist_hit ?screening_case ?watchlist_hit_type)
        (not
          (watchlist_hit_type_available ?watchlist_hit_type)
        )
      )
  )
  (:action escalate_case_with_channel_and_matches
    :parameters (?screening_case - screening_case ?transaction_channel - transaction_channel ?party_match - party_match ?watchlist_hit_type - watchlist_hit_type)
    :precondition
      (and
        (case_profile_applied ?screening_case)
        (transaction_channel_available ?transaction_channel)
        (case_channel_mapping ?screening_case ?transaction_channel)
        (not
          (case_adjudicated ?screening_case)
        )
        (case_watchlist_hit ?screening_case ?watchlist_hit_type)
        (case_party_match ?screening_case ?party_match)
      )
    :effect
      (and
        (case_channel_assigned ?screening_case ?transaction_channel)
        (not
          (transaction_channel_available ?transaction_channel)
        )
        (case_adjudicated ?screening_case)
      )
  )
  (:action finalize_adjudication
    :parameters (?screening_case - screening_case ?party_match - party_match ?watchlist_hit_type - watchlist_hit_type)
    :precondition
      (and
        (case_party_match ?screening_case ?party_match)
        (approval_requested ?screening_case)
        (case_watchlist_hit ?screening_case ?watchlist_hit_type)
        (case_high_risk_flag ?screening_case)
      )
    :effect
      (and
        (not
          (case_requires_senior_review ?screening_case)
        )
        (not
          (case_high_risk_flag ?screening_case)
        )
        (not
          (evidence_collected ?screening_case)
        )
        (case_ready_for_final_approval ?screening_case)
      )
  )
  (:action detach_alert_evidence_from_case
    :parameters (?screening_case - screening_case ?alert_evidence - alert_evidence)
    :precondition
      (and
        (case_evidence_link ?screening_case ?alert_evidence)
      )
    :effect
      (and
        (alert_evidence_available ?alert_evidence)
        (not
          (case_evidence_link ?screening_case ?alert_evidence)
        )
      )
  )
  (:action investigator_collects_evidence
    :parameters (?screening_case - screening_case ?alert_evidence - alert_evidence ?investigator - investigator)
    :precondition
      (and
        (not
          (evidence_collected ?screening_case)
        )
        (case_profile_applied ?screening_case)
        (investigator_available ?investigator)
        (case_evidence_link ?screening_case ?alert_evidence)
        (case_investigation_assigned ?screening_case)
      )
    :effect
      (and
        (not
          (case_high_risk_flag ?screening_case)
        )
        (evidence_collected ?screening_case)
      )
  )
  (:action release_case_by_final_review
    :parameters (?screening_case - screening_case)
    :precondition
      (and
        (case_registered ?screening_case)
        (requires_crossborder_approval_path ?screening_case)
        (case_marked_for_final_review ?screening_case)
        (case_profile_applied ?screening_case)
        (evidence_collected ?screening_case)
        (not
          (case_released ?screening_case)
        )
        (approver_assigned ?screening_case)
        (case_adjudicated ?screening_case)
        (approval_requested ?screening_case)
      )
    :effect
      (and
        (case_released ?screening_case)
      )
  )
  (:action mark_case_for_final_review
    :parameters (?screening_case - screening_case ?alert_evidence - alert_evidence ?investigator - investigator)
    :precondition
      (and
        (evidence_collected ?screening_case)
        (investigator_available ?investigator)
        (not
          (case_marked_for_final_review ?screening_case)
        )
        (approver_assigned ?screening_case)
        (case_registered ?screening_case)
        (requires_crossborder_approval_path ?screening_case)
        (case_evidence_link ?screening_case ?alert_evidence)
      )
    :effect
      (and
        (case_marked_for_final_review ?screening_case)
      )
  )
  (:action unlink_party_match_from_case
    :parameters (?screening_case - screening_case ?party_match - party_match)
    :precondition
      (and
        (case_party_match ?screening_case ?party_match)
      )
    :effect
      (and
        (party_match_resource_available ?party_match)
        (not
          (case_party_match ?screening_case ?party_match)
        )
      )
  )
  (:action link_sanctions_list_to_case
    :parameters (?screening_case - screening_case ?sanctions_list - sanctions_list)
    :precondition
      (and
        (sanctions_list_selected ?sanctions_list)
        (case_registered ?screening_case)
        (case_sanctions_list_mapping ?screening_case ?sanctions_list)
      )
    :effect
      (and
        (case_list_match ?screening_case ?sanctions_list)
        (not
          (sanctions_list_selected ?sanctions_list)
        )
      )
  )
  (:action register_screening_case
    :parameters (?screening_case - screening_case)
    :precondition
      (and
        (not
          (case_registered ?screening_case)
        )
        (not
          (case_released ?screening_case)
        )
      )
    :effect
      (and
        (case_registered ?screening_case)
      )
  )
  (:action assign_investigator_for_automated_reason
    :parameters (?screening_case - screening_case ?automated_hit_reason - automated_hit_reason)
    :precondition
      (and
        (not
          (case_investigation_assigned ?screening_case)
        )
        (case_registered ?screening_case)
        (automated_hit_reason_available ?automated_hit_reason)
        (case_profile_applied ?screening_case)
      )
    :effect
      (and
        (case_high_risk_flag ?screening_case)
        (not
          (automated_hit_reason_available ?automated_hit_reason)
        )
        (case_investigation_assigned ?screening_case)
      )
  )
  (:action escalate_case_with_sanction_and_reference
    :parameters (?screening_case - screening_case ?transaction_channel - transaction_channel ?sanction_match - sanction_match ?external_reference - external_reference)
    :precondition
      (and
        (external_reference_available ?external_reference)
        (case_external_reference_mapping ?screening_case ?external_reference)
        (not
          (case_adjudicated ?screening_case)
        )
        (case_profile_applied ?screening_case)
        (transaction_channel_available ?transaction_channel)
        (case_channel_mapping ?screening_case ?transaction_channel)
        (case_sanction_match ?screening_case ?sanction_match)
      )
    :effect
      (and
        (case_channel_assigned ?screening_case ?transaction_channel)
        (not
          (external_reference_available ?external_reference)
        )
        (case_requires_senior_review ?screening_case)
        (not
          (transaction_channel_available ?transaction_channel)
        )
        (case_high_risk_flag ?screening_case)
        (case_adjudicated ?screening_case)
      )
  )
  (:action assign_approver_via_automated_reason
    :parameters (?screening_case - screening_case ?automated_hit_reason - automated_hit_reason)
    :precondition
      (and
        (automated_hit_reason_available ?automated_hit_reason)
        (not
          (case_high_risk_flag ?screening_case)
        )
        (evidence_collected ?screening_case)
        (approval_requested ?screening_case)
        (not
          (approver_assigned ?screening_case)
        )
      )
    :effect
      (and
        (approver_assigned ?screening_case)
        (not
          (automated_hit_reason_available ?automated_hit_reason)
        )
      )
  )
  (:action retract_profile_from_case
    :parameters (?screening_case - screening_case ?screening_profile - screening_profile)
    :precondition
      (and
        (case_has_profile ?screening_case ?screening_profile)
        (not
          (approval_requested ?screening_case)
        )
        (not
          (case_adjudicated ?screening_case)
        )
      )
    :effect
      (and
        (not
          (case_has_profile ?screening_case ?screening_profile)
        )
        (screening_profile_available ?screening_profile)
        (not
          (case_profile_applied ?screening_case)
        )
        (not
          (case_investigation_assigned ?screening_case)
        )
        (not
          (case_ready_for_final_approval ?screening_case)
        )
        (not
          (evidence_collected ?screening_case)
        )
        (not
          (case_requires_senior_review ?screening_case)
        )
        (not
          (case_high_risk_flag ?screening_case)
        )
      )
  )
  (:action assign_approver_via_evidence
    :parameters (?screening_case - screening_case ?alert_evidence - alert_evidence)
    :precondition
      (and
        (not
          (approver_assigned ?screening_case)
        )
        (case_evidence_link ?screening_case ?alert_evidence)
        (evidence_collected ?screening_case)
        (approval_requested ?screening_case)
        (not
          (case_high_risk_flag ?screening_case)
        )
      )
    :effect
      (and
        (approver_assigned ?screening_case)
      )
  )
  (:action release_case_by_approver_criteria
    :parameters (?screening_case - screening_case ?approver - approver)
    :precondition
      (and
        (approver_assigned ?screening_case)
        (approval_requested ?screening_case)
        (case_adjudicated ?screening_case)
        (approver_approval_record ?screening_case ?approver)
        (evidence_collected ?screening_case)
        (case_profile_applied ?screening_case)
        (case_registered ?screening_case)
        (not
          (case_released ?screening_case)
        )
        (requires_crossborder_approval_path ?screening_case)
      )
    :effect
      (and
        (case_released ?screening_case)
      )
  )
  (:action assign_investigation_via_evidence
    :parameters (?screening_case - screening_case ?alert_evidence - alert_evidence)
    :precondition
      (and
        (case_registered ?screening_case)
        (case_profile_applied ?screening_case)
        (not
          (case_investigation_assigned ?screening_case)
        )
        (case_evidence_link ?screening_case ?alert_evidence)
      )
    :effect
      (and
        (case_investigation_assigned ?screening_case)
      )
  )
  (:action assign_profile_to_case
    :parameters (?screening_case - screening_case ?screening_profile - screening_profile)
    :precondition
      (and
        (not
          (case_profile_applied ?screening_case)
        )
        (case_registered ?screening_case)
        (screening_profile_available ?screening_profile)
        (case_profile_mapping ?screening_case ?screening_profile)
      )
    :effect
      (and
        (case_profile_applied ?screening_case)
        (not
          (screening_profile_available ?screening_profile)
        )
        (case_has_profile ?screening_case ?screening_profile)
      )
  )
  (:action investigator_recollects_evidence_for_final_approval
    :parameters (?screening_case - screening_case ?alert_evidence - alert_evidence ?investigator - investigator)
    :precondition
      (and
        (case_profile_applied ?screening_case)
        (not
          (evidence_collected ?screening_case)
        )
        (case_evidence_link ?screening_case ?alert_evidence)
        (approval_requested ?screening_case)
        (investigator_available ?investigator)
        (case_ready_for_final_approval ?screening_case)
      )
    :effect
      (and
        (evidence_collected ?screening_case)
      )
  )
  (:action coordinate_approver_assignment_between_transaction_types
    :parameters (?crossborder_transaction - crossborder_transaction ?domestic_transaction - domestic_transaction ?approver - approver)
    :precondition
      (and
        (case_registered ?crossborder_transaction)
        (approver_assignment_for_case ?domestic_transaction ?approver)
        (requires_crossborder_approval_path ?crossborder_transaction)
        (not
          (approver_approval_record ?crossborder_transaction ?approver)
        )
        (approver_eligible_for_case ?crossborder_transaction ?approver)
      )
    :effect
      (and
        (approver_approval_record ?crossborder_transaction ?approver)
      )
  )
)

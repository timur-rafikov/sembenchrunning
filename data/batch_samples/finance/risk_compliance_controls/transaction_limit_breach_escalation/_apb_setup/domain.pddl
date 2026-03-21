(define (domain transaction_limit_escalation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types transaction_case - object originating_entity - object transaction_profile - object limit_rule - object customer_profile - object product_profile - object screening_alert - object automated_detector - object approver_role - object specialist - object evidence_document - object risk_indicator - object auxiliary_object - object escalation_channel - auxiliary_object escalation_channel_secondary - auxiliary_object case_subtype_primary - transaction_case case_subtype_secondary - transaction_case)
  (:predicates
    (case_open ?transaction_case - transaction_case)
    (case_origin_link ?transaction_case - transaction_case ?originating_entity - originating_entity)
    (case_association_active ?transaction_case - transaction_case)
    (case_on_hold ?transaction_case - transaction_case)
    (case_specialist_review_completed ?transaction_case - transaction_case)
    (case_bound_customer_profile ?transaction_case - transaction_case ?customer_profile - customer_profile)
    (case_bound_limit_rule ?transaction_case - transaction_case ?limit_rule - limit_rule)
    (case_bound_product_profile ?transaction_case - transaction_case ?product_profile - product_profile)
    (case_bound_risk_indicator ?transaction_case - transaction_case ?risk_indicator - risk_indicator)
    (case_decision_flag ?transaction_case - transaction_case ?transaction_profile - transaction_profile)
    (case_decision_recorded ?transaction_case - transaction_case)
    (case_approval_assigned ?transaction_case - transaction_case)
    (approver_ready ?transaction_case - transaction_case)
    (case_closed ?transaction_case - transaction_case)
    (specialist_required ?transaction_case - transaction_case)
    (approval_granted ?transaction_case - transaction_case)
    (case_approver_compatibility_secondary ?transaction_case - transaction_case ?approver_role - approver_role)
    (case_approver_confirmed ?transaction_case - transaction_case ?approver_role - approver_role)
    (escalation_ticket_created ?transaction_case - transaction_case)
    (origin_available ?originating_entity - originating_entity)
    (profile_available ?transaction_profile - transaction_profile)
    (customer_profile_available ?customer_profile - customer_profile)
    (limit_rule_available ?limit_rule - limit_rule)
    (product_profile_available ?product_profile - product_profile)
    (screening_alert_available ?screening_alert - screening_alert)
    (detector_available ?automated_detector - automated_detector)
    (approver_role_available ?approver_role - approver_role)
    (specialist_available ?specialist - specialist)
    (evidence_document_available ?evidence_document - evidence_document)
    (risk_indicator_available ?risk_indicator - risk_indicator)
    (case_origin_compatibility ?transaction_case - transaction_case ?originating_entity - originating_entity)
    (case_profile_compatibility ?transaction_case - transaction_case ?transaction_profile - transaction_profile)
    (case_customer_profile_compatibility ?transaction_case - transaction_case ?customer_profile - customer_profile)
    (case_limit_rule_compatibility ?transaction_case - transaction_case ?limit_rule - limit_rule)
    (case_product_profile_compatibility ?transaction_case - transaction_case ?product_profile - product_profile)
    (case_evidence_compatibility ?transaction_case - transaction_case ?evidence_document - evidence_document)
    (case_risk_indicator_compatibility ?transaction_case - transaction_case ?risk_indicator - risk_indicator)
    (case_auxiliary_binding ?transaction_case - transaction_case ?auxiliary_object - auxiliary_object)
    (case_approver_role_assigned ?transaction_case - transaction_case ?approver_role - approver_role)
    (closure_eligibility_primary ?transaction_case - transaction_case)
    (closure_eligibility_secondary ?transaction_case - transaction_case)
    (case_reserved_alert ?transaction_case - transaction_case ?screening_alert - screening_alert)
    (additional_check_required ?transaction_case - transaction_case)
    (case_approver_compatibility_primary ?transaction_case - transaction_case ?approver_role - approver_role)
  )
  (:action create_case
    :parameters (?transaction_case - transaction_case)
    :precondition
      (and
        (not
          (case_open ?transaction_case)
        )
        (not
          (case_closed ?transaction_case)
        )
      )
    :effect
      (and
        (case_open ?transaction_case)
      )
  )
  (:action associate_case_with_origin
    :parameters (?transaction_case - transaction_case ?originating_entity - originating_entity)
    :precondition
      (and
        (case_open ?transaction_case)
        (origin_available ?originating_entity)
        (case_origin_compatibility ?transaction_case ?originating_entity)
        (not
          (case_association_active ?transaction_case)
        )
      )
    :effect
      (and
        (case_origin_link ?transaction_case ?originating_entity)
        (case_association_active ?transaction_case)
        (not
          (origin_available ?originating_entity)
        )
      )
  )
  (:action reset_case_associations
    :parameters (?transaction_case - transaction_case ?originating_entity - originating_entity)
    :precondition
      (and
        (case_origin_link ?transaction_case ?originating_entity)
        (not
          (case_decision_recorded ?transaction_case)
        )
        (not
          (case_approval_assigned ?transaction_case)
        )
      )
    :effect
      (and
        (not
          (case_origin_link ?transaction_case ?originating_entity)
        )
        (not
          (case_association_active ?transaction_case)
        )
        (not
          (case_on_hold ?transaction_case)
        )
        (not
          (case_specialist_review_completed ?transaction_case)
        )
        (not
          (specialist_required ?transaction_case)
        )
        (not
          (approval_granted ?transaction_case)
        )
        (not
          (additional_check_required ?transaction_case)
        )
        (origin_available ?originating_entity)
      )
  )
  (:action reserve_screening_alert
    :parameters (?transaction_case - transaction_case ?screening_alert - screening_alert)
    :precondition
      (and
        (case_open ?transaction_case)
        (screening_alert_available ?screening_alert)
      )
    :effect
      (and
        (case_reserved_alert ?transaction_case ?screening_alert)
        (not
          (screening_alert_available ?screening_alert)
        )
      )
  )
  (:action release_screening_alert
    :parameters (?transaction_case - transaction_case ?screening_alert - screening_alert)
    :precondition
      (and
        (case_reserved_alert ?transaction_case ?screening_alert)
      )
    :effect
      (and
        (screening_alert_available ?screening_alert)
        (not
          (case_reserved_alert ?transaction_case ?screening_alert)
        )
      )
  )
  (:action apply_alert_hold
    :parameters (?transaction_case - transaction_case ?screening_alert - screening_alert)
    :precondition
      (and
        (case_open ?transaction_case)
        (case_association_active ?transaction_case)
        (case_reserved_alert ?transaction_case ?screening_alert)
        (not
          (case_on_hold ?transaction_case)
        )
      )
    :effect
      (and
        (case_on_hold ?transaction_case)
      )
  )
  (:action apply_detector_hold
    :parameters (?transaction_case - transaction_case ?automated_detector - automated_detector)
    :precondition
      (and
        (case_open ?transaction_case)
        (case_association_active ?transaction_case)
        (detector_available ?automated_detector)
        (not
          (case_on_hold ?transaction_case)
        )
      )
    :effect
      (and
        (case_on_hold ?transaction_case)
        (specialist_required ?transaction_case)
        (not
          (detector_available ?automated_detector)
        )
      )
  )
  (:action specialist_capture_evidence
    :parameters (?transaction_case - transaction_case ?screening_alert - screening_alert ?specialist - specialist)
    :precondition
      (and
        (case_on_hold ?transaction_case)
        (case_association_active ?transaction_case)
        (case_reserved_alert ?transaction_case ?screening_alert)
        (specialist_available ?specialist)
        (not
          (case_specialist_review_completed ?transaction_case)
        )
      )
    :effect
      (and
        (case_specialist_review_completed ?transaction_case)
        (not
          (specialist_required ?transaction_case)
        )
      )
  )
  (:action specialist_capture_evidence_via_approver
    :parameters (?transaction_case - transaction_case ?approver_role - approver_role)
    :precondition
      (and
        (case_association_active ?transaction_case)
        (case_approver_confirmed ?transaction_case ?approver_role)
        (not
          (case_specialist_review_completed ?transaction_case)
        )
      )
    :effect
      (and
        (case_specialist_review_completed ?transaction_case)
        (not
          (specialist_required ?transaction_case)
        )
      )
  )
  (:action bind_customer_profile
    :parameters (?transaction_case - transaction_case ?customer_profile - customer_profile)
    :precondition
      (and
        (case_open ?transaction_case)
        (customer_profile_available ?customer_profile)
        (case_customer_profile_compatibility ?transaction_case ?customer_profile)
      )
    :effect
      (and
        (case_bound_customer_profile ?transaction_case ?customer_profile)
        (not
          (customer_profile_available ?customer_profile)
        )
      )
  )
  (:action release_customer_profile
    :parameters (?transaction_case - transaction_case ?customer_profile - customer_profile)
    :precondition
      (and
        (case_bound_customer_profile ?transaction_case ?customer_profile)
      )
    :effect
      (and
        (customer_profile_available ?customer_profile)
        (not
          (case_bound_customer_profile ?transaction_case ?customer_profile)
        )
      )
  )
  (:action bind_limit_rule
    :parameters (?transaction_case - transaction_case ?limit_rule - limit_rule)
    :precondition
      (and
        (case_open ?transaction_case)
        (limit_rule_available ?limit_rule)
        (case_limit_rule_compatibility ?transaction_case ?limit_rule)
      )
    :effect
      (and
        (case_bound_limit_rule ?transaction_case ?limit_rule)
        (not
          (limit_rule_available ?limit_rule)
        )
      )
  )
  (:action release_limit_rule
    :parameters (?transaction_case - transaction_case ?limit_rule - limit_rule)
    :precondition
      (and
        (case_bound_limit_rule ?transaction_case ?limit_rule)
      )
    :effect
      (and
        (limit_rule_available ?limit_rule)
        (not
          (case_bound_limit_rule ?transaction_case ?limit_rule)
        )
      )
  )
  (:action bind_product_profile
    :parameters (?transaction_case - transaction_case ?product_profile - product_profile)
    :precondition
      (and
        (case_open ?transaction_case)
        (product_profile_available ?product_profile)
        (case_product_profile_compatibility ?transaction_case ?product_profile)
      )
    :effect
      (and
        (case_bound_product_profile ?transaction_case ?product_profile)
        (not
          (product_profile_available ?product_profile)
        )
      )
  )
  (:action release_product_profile
    :parameters (?transaction_case - transaction_case ?product_profile - product_profile)
    :precondition
      (and
        (case_bound_product_profile ?transaction_case ?product_profile)
      )
    :effect
      (and
        (product_profile_available ?product_profile)
        (not
          (case_bound_product_profile ?transaction_case ?product_profile)
        )
      )
  )
  (:action bind_risk_indicator
    :parameters (?transaction_case - transaction_case ?risk_indicator - risk_indicator)
    :precondition
      (and
        (case_open ?transaction_case)
        (risk_indicator_available ?risk_indicator)
        (case_risk_indicator_compatibility ?transaction_case ?risk_indicator)
      )
    :effect
      (and
        (case_bound_risk_indicator ?transaction_case ?risk_indicator)
        (not
          (risk_indicator_available ?risk_indicator)
        )
      )
  )
  (:action release_risk_indicator
    :parameters (?transaction_case - transaction_case ?risk_indicator - risk_indicator)
    :precondition
      (and
        (case_bound_risk_indicator ?transaction_case ?risk_indicator)
      )
    :effect
      (and
        (risk_indicator_available ?risk_indicator)
        (not
          (case_bound_risk_indicator ?transaction_case ?risk_indicator)
        )
      )
  )
  (:action perform_risk_assessment
    :parameters (?transaction_case - transaction_case ?transaction_profile - transaction_profile ?customer_profile - customer_profile ?limit_rule - limit_rule)
    :precondition
      (and
        (case_association_active ?transaction_case)
        (case_bound_customer_profile ?transaction_case ?customer_profile)
        (case_bound_limit_rule ?transaction_case ?limit_rule)
        (profile_available ?transaction_profile)
        (case_profile_compatibility ?transaction_case ?transaction_profile)
        (not
          (case_decision_recorded ?transaction_case)
        )
      )
    :effect
      (and
        (case_decision_flag ?transaction_case ?transaction_profile)
        (case_decision_recorded ?transaction_case)
        (not
          (profile_available ?transaction_profile)
        )
      )
  )
  (:action perform_extended_risk_assessment
    :parameters (?transaction_case - transaction_case ?transaction_profile - transaction_profile ?product_profile - product_profile ?evidence_document - evidence_document)
    :precondition
      (and
        (case_association_active ?transaction_case)
        (case_bound_product_profile ?transaction_case ?product_profile)
        (evidence_document_available ?evidence_document)
        (profile_available ?transaction_profile)
        (case_profile_compatibility ?transaction_case ?transaction_profile)
        (case_evidence_compatibility ?transaction_case ?evidence_document)
        (not
          (case_decision_recorded ?transaction_case)
        )
      )
    :effect
      (and
        (case_decision_flag ?transaction_case ?transaction_profile)
        (case_decision_recorded ?transaction_case)
        (additional_check_required ?transaction_case)
        (specialist_required ?transaction_case)
        (not
          (profile_available ?transaction_profile)
        )
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action clear_additional_checks
    :parameters (?transaction_case - transaction_case ?customer_profile - customer_profile ?limit_rule - limit_rule)
    :precondition
      (and
        (case_decision_recorded ?transaction_case)
        (additional_check_required ?transaction_case)
        (case_bound_customer_profile ?transaction_case ?customer_profile)
        (case_bound_limit_rule ?transaction_case ?limit_rule)
      )
    :effect
      (and
        (not
          (additional_check_required ?transaction_case)
        )
        (not
          (specialist_required ?transaction_case)
        )
      )
  )
  (:action allocate_approver
    :parameters (?transaction_case - transaction_case ?customer_profile - customer_profile ?limit_rule - limit_rule ?escalation_channel - escalation_channel)
    :precondition
      (and
        (case_specialist_review_completed ?transaction_case)
        (case_decision_recorded ?transaction_case)
        (case_bound_customer_profile ?transaction_case ?customer_profile)
        (case_bound_limit_rule ?transaction_case ?limit_rule)
        (case_auxiliary_binding ?transaction_case ?escalation_channel)
        (not
          (specialist_required ?transaction_case)
        )
        (not
          (case_approval_assigned ?transaction_case)
        )
      )
    :effect
      (and
        (case_approval_assigned ?transaction_case)
      )
  )
  (:action allocate_escalation_approver
    :parameters (?transaction_case - transaction_case ?product_profile - product_profile ?risk_indicator - risk_indicator ?escalation_channel_secondary - escalation_channel_secondary)
    :precondition
      (and
        (case_specialist_review_completed ?transaction_case)
        (case_decision_recorded ?transaction_case)
        (case_bound_product_profile ?transaction_case ?product_profile)
        (case_bound_risk_indicator ?transaction_case ?risk_indicator)
        (case_auxiliary_binding ?transaction_case ?escalation_channel_secondary)
        (not
          (case_approval_assigned ?transaction_case)
        )
      )
    :effect
      (and
        (case_approval_assigned ?transaction_case)
        (specialist_required ?transaction_case)
      )
  )
  (:action finalize_approval_stage
    :parameters (?transaction_case - transaction_case ?customer_profile - customer_profile ?limit_rule - limit_rule)
    :precondition
      (and
        (case_approval_assigned ?transaction_case)
        (specialist_required ?transaction_case)
        (case_bound_customer_profile ?transaction_case ?customer_profile)
        (case_bound_limit_rule ?transaction_case ?limit_rule)
      )
    :effect
      (and
        (approval_granted ?transaction_case)
        (not
          (specialist_required ?transaction_case)
        )
        (not
          (case_specialist_review_completed ?transaction_case)
        )
        (not
          (additional_check_required ?transaction_case)
        )
      )
  )
  (:action reassign_specialist_review
    :parameters (?transaction_case - transaction_case ?screening_alert - screening_alert ?specialist - specialist)
    :precondition
      (and
        (approval_granted ?transaction_case)
        (case_approval_assigned ?transaction_case)
        (case_association_active ?transaction_case)
        (case_reserved_alert ?transaction_case ?screening_alert)
        (specialist_available ?specialist)
        (not
          (case_specialist_review_completed ?transaction_case)
        )
      )
    :effect
      (and
        (case_specialist_review_completed ?transaction_case)
      )
  )
  (:action mark_escalation_ready
    :parameters (?transaction_case - transaction_case ?screening_alert - screening_alert)
    :precondition
      (and
        (case_approval_assigned ?transaction_case)
        (case_specialist_review_completed ?transaction_case)
        (not
          (specialist_required ?transaction_case)
        )
        (case_reserved_alert ?transaction_case ?screening_alert)
        (not
          (approver_ready ?transaction_case)
        )
      )
    :effect
      (and
        (approver_ready ?transaction_case)
      )
  )
  (:action mark_escalation_ready_with_detector
    :parameters (?transaction_case - transaction_case ?automated_detector - automated_detector)
    :precondition
      (and
        (case_approval_assigned ?transaction_case)
        (case_specialist_review_completed ?transaction_case)
        (not
          (specialist_required ?transaction_case)
        )
        (detector_available ?automated_detector)
        (not
          (approver_ready ?transaction_case)
        )
      )
    :effect
      (and
        (approver_ready ?transaction_case)
        (not
          (detector_available ?automated_detector)
        )
      )
  )
  (:action assign_approver_role_to_case
    :parameters (?transaction_case - transaction_case ?approver_role - approver_role)
    :precondition
      (and
        (approver_ready ?transaction_case)
        (approver_role_available ?approver_role)
        (case_approver_compatibility_primary ?transaction_case ?approver_role)
      )
    :effect
      (and
        (case_approver_role_assigned ?transaction_case ?approver_role)
        (not
          (approver_role_available ?approver_role)
        )
      )
  )
  (:action confirm_approver_assignment
    :parameters (?case_subtype_secondary - case_subtype_secondary ?case_subtype_primary - case_subtype_primary ?approver_role - approver_role)
    :precondition
      (and
        (case_open ?case_subtype_secondary)
        (closure_eligibility_secondary ?case_subtype_secondary)
        (case_approver_compatibility_secondary ?case_subtype_secondary ?approver_role)
        (case_approver_role_assigned ?case_subtype_primary ?approver_role)
        (not
          (case_approver_confirmed ?case_subtype_secondary ?approver_role)
        )
      )
    :effect
      (and
        (case_approver_confirmed ?case_subtype_secondary ?approver_role)
      )
  )
  (:action create_escalation_ticket
    :parameters (?transaction_case - transaction_case ?screening_alert - screening_alert ?specialist - specialist)
    :precondition
      (and
        (case_open ?transaction_case)
        (closure_eligibility_secondary ?transaction_case)
        (case_specialist_review_completed ?transaction_case)
        (approver_ready ?transaction_case)
        (case_reserved_alert ?transaction_case ?screening_alert)
        (specialist_available ?specialist)
        (not
          (escalation_ticket_created ?transaction_case)
        )
      )
    :effect
      (and
        (escalation_ticket_created ?transaction_case)
      )
  )
  (:action close_case_primary
    :parameters (?transaction_case - transaction_case)
    :precondition
      (and
        (closure_eligibility_primary ?transaction_case)
        (case_open ?transaction_case)
        (case_association_active ?transaction_case)
        (case_decision_recorded ?transaction_case)
        (case_approval_assigned ?transaction_case)
        (approver_ready ?transaction_case)
        (case_specialist_review_completed ?transaction_case)
        (not
          (case_closed ?transaction_case)
        )
      )
    :effect
      (and
        (case_closed ?transaction_case)
      )
  )
  (:action close_case_with_approver
    :parameters (?transaction_case - transaction_case ?approver_role - approver_role)
    :precondition
      (and
        (closure_eligibility_secondary ?transaction_case)
        (case_open ?transaction_case)
        (case_association_active ?transaction_case)
        (case_decision_recorded ?transaction_case)
        (case_approval_assigned ?transaction_case)
        (approver_ready ?transaction_case)
        (case_specialist_review_completed ?transaction_case)
        (case_approver_confirmed ?transaction_case ?approver_role)
        (not
          (case_closed ?transaction_case)
        )
      )
    :effect
      (and
        (case_closed ?transaction_case)
      )
  )
  (:action close_case_with_escalation
    :parameters (?transaction_case - transaction_case)
    :precondition
      (and
        (closure_eligibility_secondary ?transaction_case)
        (case_open ?transaction_case)
        (case_association_active ?transaction_case)
        (case_decision_recorded ?transaction_case)
        (case_approval_assigned ?transaction_case)
        (approver_ready ?transaction_case)
        (case_specialist_review_completed ?transaction_case)
        (escalation_ticket_created ?transaction_case)
        (not
          (case_closed ?transaction_case)
        )
      )
    :effect
      (and
        (case_closed ?transaction_case)
      )
  )
)

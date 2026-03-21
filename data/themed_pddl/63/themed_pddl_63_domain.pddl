(define (domain incident_comms_approval_chain_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types incident_case - object primary_approver_candidate - object communication_action - object stakeholder_representative - object affected_service - object infrastructure_component - object distribution_list - object oncall_reviewer - object communication_template - object communications_author - object compliance_artifact - object technical_reviewer - object approval_channel - object executive_approver - approval_channel operations_approver - approval_channel customer_facing_incident - incident_case internal_facing_incident - incident_case)
  (:predicates
    (oncall_reviewer_available ?oncall_reviewer - oncall_reviewer)
    (case_has_stakeholder ?incident_case - incident_case ?stakeholder_representative - stakeholder_representative)
    (ready_for_release ?incident_case - incident_case)
    (primary_approver_assigned ?incident_case - incident_case ?primary_approver_candidate - primary_approver_candidate)
    (requires_approval_channel ?incident_case - incident_case ?approval_channel - approval_channel)
    (component_available ?infrastructure_component - infrastructure_component)
    (stakeholder_available ?stakeholder_representative - stakeholder_representative)
    (eligible_technical_reviewer_for_case ?incident_case - incident_case ?technical_reviewer - technical_reviewer)
    (final_approval_flag ?incident_case - incident_case)
    (is_customer_facing_case ?incident_case - incident_case)
    (eligible_primary_approver_for_case ?incident_case - incident_case ?primary_approver_candidate - primary_approver_candidate)
    (action_slot_available ?communication_action - communication_action)
    (compliance_artifact_available ?compliance_artifact - compliance_artifact)
    (distribution_list_available ?distribution_list - distribution_list)
    (execution_validated ?incident_case - incident_case)
    (eligible_stakeholder_for_case ?incident_case - incident_case ?stakeholder_representative - stakeholder_representative)
    (case_binds_technical_reviewer ?incident_case - incident_case ?technical_reviewer - technical_reviewer)
    (case_plans_action ?incident_case - incident_case ?communication_action - communication_action)
    (channel_approval_confirmed ?incident_case - incident_case)
    (eligible_component_for_case ?incident_case - incident_case ?infrastructure_component - infrastructure_component)
    (technical_reviewer_available ?technical_reviewer - technical_reviewer)
    (is_internal_case ?incident_case - incident_case)
    (communication_draft_available ?incident_case - incident_case)
    (eligible_service_for_case ?incident_case - incident_case ?affected_service - affected_service)
    (case_has_service ?incident_case - incident_case ?affected_service - affected_service)
    (compliance_attachment_required ?incident_case - incident_case)
    (distribution_list_assigned_to_case ?incident_case - incident_case ?distribution_list - distribution_list)
    (communications_sent_flag ?incident_case - incident_case)
    (eligible_compliance_artifact_for_case ?incident_case - incident_case ?compliance_artifact - compliance_artifact)
    (case_registered ?incident_case - incident_case)
    (approver_candidate_available ?primary_approver_candidate - primary_approver_candidate)
    (has_primary_approver ?incident_case - incident_case)
    (communications_author_available ?communications_author - communications_author)
    (template_available ?communication_template - communication_template)
    (case_has_component ?incident_case - incident_case ?infrastructure_component - infrastructure_component)
    (template_applied_to_customer_case ?incident_case - incident_case ?communication_template - communication_template)
    (review_received ?incident_case - incident_case)
    (distribution_confirmed ?incident_case - incident_case)
    (customer_incident_template_link ?incident_case - incident_case ?communication_template - communication_template)
    (service_available ?affected_service - affected_service)
    (internal_incident_template_link ?incident_case - incident_case ?communication_template - communication_template)
    (eligible_communication_action_for_case ?incident_case - incident_case ?communication_action - communication_action)
    (escalation_flag ?incident_case - incident_case)
    (template_applied_to_internal_case ?incident_case - incident_case ?communication_template - communication_template)
  )
  (:action unbind_technical_reviewer_from_case
    :parameters (?incident_case - incident_case ?technical_reviewer - technical_reviewer)
    :precondition
      (and
        (case_binds_technical_reviewer ?incident_case ?technical_reviewer)
      )
    :effect
      (and
        (technical_reviewer_available ?technical_reviewer)
        (not
          (case_binds_technical_reviewer ?incident_case ?technical_reviewer)
        )
      )
  )
  (:action record_channel_approvals_with_operations
    :parameters (?incident_case - incident_case ?infrastructure_component - infrastructure_component ?technical_reviewer - technical_reviewer ?operations_approver - operations_approver)
    :precondition
      (and
        (not
          (channel_approval_confirmed ?incident_case)
        )
        (execution_validated ?incident_case)
        (communication_draft_available ?incident_case)
        (case_binds_technical_reviewer ?incident_case ?technical_reviewer)
        (requires_approval_channel ?incident_case ?operations_approver)
        (case_has_component ?incident_case ?infrastructure_component)
      )
    :effect
      (and
        (escalation_flag ?incident_case)
        (channel_approval_confirmed ?incident_case)
      )
  )
  (:action set_final_approval_flag_standard
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (communication_draft_available ?incident_case)
        (has_primary_approver ?incident_case)
        (execution_validated ?incident_case)
        (case_registered ?incident_case)
        (distribution_confirmed ?incident_case)
        (not
          (final_approval_flag ?incident_case)
        )
        (is_customer_facing_case ?incident_case)
        (channel_approval_confirmed ?incident_case)
      )
    :effect
      (and
        (final_approval_flag ?incident_case)
      )
  )
  (:action reserve_execution_slot
    :parameters (?incident_case - incident_case ?affected_service - affected_service ?stakeholder_representative - stakeholder_representative)
    :precondition
      (and
        (execution_validated ?incident_case)
        (compliance_attachment_required ?incident_case)
        (case_has_service ?incident_case ?affected_service)
        (case_has_stakeholder ?incident_case ?stakeholder_representative)
      )
    :effect
      (and
        (not
          (compliance_attachment_required ?incident_case)
        )
        (not
          (escalation_flag ?incident_case)
        )
      )
  )
  (:action attach_distribution_list_to_case
    :parameters (?incident_case - incident_case ?distribution_list - distribution_list)
    :precondition
      (and
        (distribution_list_available ?distribution_list)
        (case_registered ?incident_case)
      )
    :effect
      (and
        (not
          (distribution_list_available ?distribution_list)
        )
        (distribution_list_assigned_to_case ?incident_case ?distribution_list)
      )
  )
  (:action record_channel_approvals
    :parameters (?incident_case - incident_case ?affected_service - affected_service ?stakeholder_representative - stakeholder_representative ?executive_approver - executive_approver)
    :precondition
      (and
        (requires_approval_channel ?incident_case ?executive_approver)
        (communication_draft_available ?incident_case)
        (not
          (escalation_flag ?incident_case)
        )
        (case_has_service ?incident_case ?affected_service)
        (execution_validated ?incident_case)
        (case_has_stakeholder ?incident_case ?stakeholder_representative)
        (not
          (channel_approval_confirmed ?incident_case)
        )
      )
    :effect
      (and
        (channel_approval_confirmed ?incident_case)
      )
  )
  (:action author_finalize_draft_with_template
    :parameters (?incident_case - incident_case ?communication_template - communication_template)
    :precondition
      (and
        (has_primary_approver ?incident_case)
        (template_applied_to_internal_case ?incident_case ?communication_template)
        (not
          (communication_draft_available ?incident_case)
        )
      )
    :effect
      (and
        (communication_draft_available ?incident_case)
        (not
          (escalation_flag ?incident_case)
        )
      )
  )
  (:action bind_component_to_case
    :parameters (?incident_case - incident_case ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (eligible_component_for_case ?incident_case ?infrastructure_component)
        (case_registered ?incident_case)
        (component_available ?infrastructure_component)
      )
    :effect
      (and
        (case_has_component ?incident_case ?infrastructure_component)
        (not
          (component_available ?infrastructure_component)
        )
      )
  )
  (:action bind_service_to_case
    :parameters (?incident_case - incident_case ?affected_service - affected_service)
    :precondition
      (and
        (case_registered ?incident_case)
        (service_available ?affected_service)
        (eligible_service_for_case ?incident_case ?affected_service)
      )
    :effect
      (and
        (not
          (service_available ?affected_service)
        )
        (case_has_service ?incident_case ?affected_service)
      )
  )
  (:action unbind_component_from_case
    :parameters (?incident_case - incident_case ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (case_has_component ?incident_case ?infrastructure_component)
      )
    :effect
      (and
        (component_available ?infrastructure_component)
        (not
          (case_has_component ?incident_case ?infrastructure_component)
        )
      )
  )
  (:action unbind_stakeholder_from_case
    :parameters (?incident_case - incident_case ?stakeholder_representative - stakeholder_representative)
    :precondition
      (and
        (case_has_stakeholder ?incident_case ?stakeholder_representative)
      )
    :effect
      (and
        (stakeholder_available ?stakeholder_representative)
        (not
          (case_has_stakeholder ?incident_case ?stakeholder_representative)
        )
      )
  )
  (:action apply_template_to_case
    :parameters (?incident_case - incident_case ?communication_template - communication_template)
    :precondition
      (and
        (distribution_confirmed ?incident_case)
        (template_available ?communication_template)
        (customer_incident_template_link ?incident_case ?communication_template)
      )
    :effect
      (and
        (template_applied_to_customer_case ?incident_case ?communication_template)
        (not
          (template_available ?communication_template)
        )
      )
  )
  (:action bind_stakeholder_to_case
    :parameters (?incident_case - incident_case ?stakeholder_representative - stakeholder_representative)
    :precondition
      (and
        (case_registered ?incident_case)
        (stakeholder_available ?stakeholder_representative)
        (eligible_stakeholder_for_case ?incident_case ?stakeholder_representative)
      )
    :effect
      (and
        (case_has_stakeholder ?incident_case ?stakeholder_representative)
        (not
          (stakeholder_available ?stakeholder_representative)
        )
      )
  )
  (:action plan_communication_action_with_service_and_stakeholder
    :parameters (?incident_case - incident_case ?communication_action - communication_action ?affected_service - affected_service ?stakeholder_representative - stakeholder_representative)
    :precondition
      (and
        (has_primary_approver ?incident_case)
        (action_slot_available ?communication_action)
        (eligible_communication_action_for_case ?incident_case ?communication_action)
        (not
          (execution_validated ?incident_case)
        )
        (case_has_stakeholder ?incident_case ?stakeholder_representative)
        (case_has_service ?incident_case ?affected_service)
      )
    :effect
      (and
        (case_plans_action ?incident_case ?communication_action)
        (not
          (action_slot_available ?communication_action)
        )
        (execution_validated ?incident_case)
      )
  )
  (:action promote_to_ready_for_release
    :parameters (?incident_case - incident_case ?affected_service - affected_service ?stakeholder_representative - stakeholder_representative)
    :precondition
      (and
        (case_has_service ?incident_case ?affected_service)
        (channel_approval_confirmed ?incident_case)
        (case_has_stakeholder ?incident_case ?stakeholder_representative)
        (escalation_flag ?incident_case)
      )
    :effect
      (and
        (not
          (compliance_attachment_required ?incident_case)
        )
        (not
          (escalation_flag ?incident_case)
        )
        (not
          (communication_draft_available ?incident_case)
        )
        (ready_for_release ?incident_case)
      )
  )
  (:action detach_distribution_list_from_case
    :parameters (?incident_case - incident_case ?distribution_list - distribution_list)
    :precondition
      (and
        (distribution_list_assigned_to_case ?incident_case ?distribution_list)
      )
    :effect
      (and
        (distribution_list_available ?distribution_list)
        (not
          (distribution_list_assigned_to_case ?incident_case ?distribution_list)
        )
      )
  )
  (:action author_finalize_draft_with_author
    :parameters (?incident_case - incident_case ?distribution_list - distribution_list ?communications_author - communications_author)
    :precondition
      (and
        (not
          (communication_draft_available ?incident_case)
        )
        (has_primary_approver ?incident_case)
        (communications_author_available ?communications_author)
        (distribution_list_assigned_to_case ?incident_case ?distribution_list)
        (review_received ?incident_case)
      )
    :effect
      (and
        (not
          (escalation_flag ?incident_case)
        )
        (communication_draft_available ?incident_case)
      )
  )
  (:action set_final_approval_flag_after_send
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (case_registered ?incident_case)
        (is_internal_case ?incident_case)
        (communications_sent_flag ?incident_case)
        (has_primary_approver ?incident_case)
        (communication_draft_available ?incident_case)
        (not
          (final_approval_flag ?incident_case)
        )
        (distribution_confirmed ?incident_case)
        (execution_validated ?incident_case)
        (channel_approval_confirmed ?incident_case)
      )
    :effect
      (and
        (final_approval_flag ?incident_case)
      )
  )
  (:action mark_communications_sent
    :parameters (?incident_case - incident_case ?distribution_list - distribution_list ?communications_author - communications_author)
    :precondition
      (and
        (communication_draft_available ?incident_case)
        (communications_author_available ?communications_author)
        (not
          (communications_sent_flag ?incident_case)
        )
        (distribution_confirmed ?incident_case)
        (case_registered ?incident_case)
        (is_internal_case ?incident_case)
        (distribution_list_assigned_to_case ?incident_case ?distribution_list)
      )
    :effect
      (and
        (communications_sent_flag ?incident_case)
      )
  )
  (:action unbind_service_from_case
    :parameters (?incident_case - incident_case ?affected_service - affected_service)
    :precondition
      (and
        (case_has_service ?incident_case ?affected_service)
      )
    :effect
      (and
        (service_available ?affected_service)
        (not
          (case_has_service ?incident_case ?affected_service)
        )
      )
  )
  (:action bind_technical_reviewer_to_case
    :parameters (?incident_case - incident_case ?technical_reviewer - technical_reviewer)
    :precondition
      (and
        (technical_reviewer_available ?technical_reviewer)
        (case_registered ?incident_case)
        (eligible_technical_reviewer_for_case ?incident_case ?technical_reviewer)
      )
    :effect
      (and
        (case_binds_technical_reviewer ?incident_case ?technical_reviewer)
        (not
          (technical_reviewer_available ?technical_reviewer)
        )
      )
  )
  (:action declare_incident_case
    :parameters (?incident_case - incident_case)
    :precondition
      (and
        (not
          (case_registered ?incident_case)
        )
        (not
          (final_approval_flag ?incident_case)
        )
      )
    :effect
      (and
        (case_registered ?incident_case)
      )
  )
  (:action collect_oncall_reviewer_ack
    :parameters (?incident_case - incident_case ?oncall_reviewer - oncall_reviewer)
    :precondition
      (and
        (not
          (review_received ?incident_case)
        )
        (case_registered ?incident_case)
        (oncall_reviewer_available ?oncall_reviewer)
        (has_primary_approver ?incident_case)
      )
    :effect
      (and
        (escalation_flag ?incident_case)
        (not
          (oncall_reviewer_available ?oncall_reviewer)
        )
        (review_received ?incident_case)
      )
  )
  (:action plan_communication_action_with_component_and_compliance
    :parameters (?incident_case - incident_case ?communication_action - communication_action ?infrastructure_component - infrastructure_component ?compliance_artifact - compliance_artifact)
    :precondition
      (and
        (compliance_artifact_available ?compliance_artifact)
        (eligible_compliance_artifact_for_case ?incident_case ?compliance_artifact)
        (not
          (execution_validated ?incident_case)
        )
        (has_primary_approver ?incident_case)
        (action_slot_available ?communication_action)
        (eligible_communication_action_for_case ?incident_case ?communication_action)
        (case_has_component ?incident_case ?infrastructure_component)
      )
    :effect
      (and
        (case_plans_action ?incident_case ?communication_action)
        (not
          (compliance_artifact_available ?compliance_artifact)
        )
        (compliance_attachment_required ?incident_case)
        (not
          (action_slot_available ?communication_action)
        )
        (escalation_flag ?incident_case)
        (execution_validated ?incident_case)
      )
  )
  (:action confirm_oncall_distribution_after_ready
    :parameters (?incident_case - incident_case ?oncall_reviewer - oncall_reviewer)
    :precondition
      (and
        (oncall_reviewer_available ?oncall_reviewer)
        (not
          (escalation_flag ?incident_case)
        )
        (communication_draft_available ?incident_case)
        (channel_approval_confirmed ?incident_case)
        (not
          (distribution_confirmed ?incident_case)
        )
      )
    :effect
      (and
        (distribution_confirmed ?incident_case)
        (not
          (oncall_reviewer_available ?oncall_reviewer)
        )
      )
  )
  (:action revoke_primary_approver
    :parameters (?incident_case - incident_case ?primary_approver_candidate - primary_approver_candidate)
    :precondition
      (and
        (primary_approver_assigned ?incident_case ?primary_approver_candidate)
        (not
          (channel_approval_confirmed ?incident_case)
        )
        (not
          (execution_validated ?incident_case)
        )
      )
    :effect
      (and
        (not
          (primary_approver_assigned ?incident_case ?primary_approver_candidate)
        )
        (approver_candidate_available ?primary_approver_candidate)
        (not
          (has_primary_approver ?incident_case)
        )
        (not
          (review_received ?incident_case)
        )
        (not
          (ready_for_release ?incident_case)
        )
        (not
          (communication_draft_available ?incident_case)
        )
        (not
          (compliance_attachment_required ?incident_case)
        )
        (not
          (escalation_flag ?incident_case)
        )
      )
  )
  (:action confirm_distribution_after_ready
    :parameters (?incident_case - incident_case ?distribution_list - distribution_list)
    :precondition
      (and
        (not
          (distribution_confirmed ?incident_case)
        )
        (distribution_list_assigned_to_case ?incident_case ?distribution_list)
        (communication_draft_available ?incident_case)
        (channel_approval_confirmed ?incident_case)
        (not
          (escalation_flag ?incident_case)
        )
      )
    :effect
      (and
        (distribution_confirmed ?incident_case)
      )
  )
  (:action set_final_approval_flag_with_template
    :parameters (?incident_case - incident_case ?communication_template - communication_template)
    :precondition
      (and
        (distribution_confirmed ?incident_case)
        (channel_approval_confirmed ?incident_case)
        (execution_validated ?incident_case)
        (template_applied_to_internal_case ?incident_case ?communication_template)
        (communication_draft_available ?incident_case)
        (has_primary_approver ?incident_case)
        (case_registered ?incident_case)
        (not
          (final_approval_flag ?incident_case)
        )
        (is_internal_case ?incident_case)
      )
    :effect
      (and
        (final_approval_flag ?incident_case)
      )
  )
  (:action record_review_for_distribution_list
    :parameters (?incident_case - incident_case ?distribution_list - distribution_list)
    :precondition
      (and
        (case_registered ?incident_case)
        (has_primary_approver ?incident_case)
        (not
          (review_received ?incident_case)
        )
        (distribution_list_assigned_to_case ?incident_case ?distribution_list)
      )
    :effect
      (and
        (review_received ?incident_case)
      )
  )
  (:action assign_primary_approver
    :parameters (?incident_case - incident_case ?primary_approver_candidate - primary_approver_candidate)
    :precondition
      (and
        (not
          (has_primary_approver ?incident_case)
        )
        (case_registered ?incident_case)
        (approver_candidate_available ?primary_approver_candidate)
        (eligible_primary_approver_for_case ?incident_case ?primary_approver_candidate)
      )
    :effect
      (and
        (has_primary_approver ?incident_case)
        (not
          (approver_candidate_available ?primary_approver_candidate)
        )
        (primary_approver_assigned ?incident_case ?primary_approver_candidate)
      )
  )
  (:action author_finalize_draft_after_ready
    :parameters (?incident_case - incident_case ?distribution_list - distribution_list ?communications_author - communications_author)
    :precondition
      (and
        (has_primary_approver ?incident_case)
        (not
          (communication_draft_available ?incident_case)
        )
        (distribution_list_assigned_to_case ?incident_case ?distribution_list)
        (channel_approval_confirmed ?incident_case)
        (communications_author_available ?communications_author)
        (ready_for_release ?incident_case)
      )
    :effect
      (and
        (communication_draft_available ?incident_case)
      )
  )
  (:action apply_template_across_internal_and_customer_cases
    :parameters (?internal_facing_incident - internal_facing_incident ?customer_facing_incident - customer_facing_incident ?communication_template - communication_template)
    :precondition
      (and
        (case_registered ?internal_facing_incident)
        (template_applied_to_customer_case ?customer_facing_incident ?communication_template)
        (is_internal_case ?internal_facing_incident)
        (not
          (template_applied_to_internal_case ?internal_facing_incident ?communication_template)
        )
        (internal_incident_template_link ?internal_facing_incident ?communication_template)
      )
    :effect
      (and
        (template_applied_to_internal_case ?internal_facing_incident ?communication_template)
      )
  )
)

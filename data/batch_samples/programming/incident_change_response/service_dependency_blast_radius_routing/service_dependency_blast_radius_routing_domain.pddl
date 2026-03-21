(define (domain service_dependency_blast_radius_routing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types service_case - object engineer - object route - object downstream_service - object upstream_service - object infrastructure_component - object routing_token - object approver - object mitigation_action - object network_control - object credential - object service_group - object stakeholder_role - object stakeholder_group - stakeholder_role escalation_group - stakeholder_role service_instance_type_a - service_case service_instance_type_b - service_case)
  (:predicates
    (case_open ?change_case - service_case)
    (case_assigned ?change_case - service_case ?engineer - engineer)
    (assignee_reserved ?change_case - service_case)
    (preapproval_obtained ?change_case - service_case)
    (route_prechecks_passed ?change_case - service_case)
    (upstream_reserved ?change_case - service_case ?upstream_service - upstream_service)
    (downstream_reserved ?change_case - service_case ?downstream_service - downstream_service)
    (infrastructure_reserved ?change_case - service_case ?infrastructure_component - infrastructure_component)
    (service_group_reserved ?change_case - service_case ?service_group - service_group)
    (mitigation_planned_on_route ?change_case - service_case ?route - route)
    (mitigation_authorized ?change_case - service_case)
    (approvals_collected ?change_case - service_case)
    (execution_token_claimed ?change_case - service_case)
    (case_closed ?change_case - service_case)
    (stakeholder_ack_required ?change_case - service_case)
    (execution_committed ?change_case - service_case)
    (instance_supports_mitigation ?change_case - service_case ?mitigation_action - mitigation_action)
    (mitigation_bound_to_instance ?change_case - service_case ?mitigation_action - mitigation_action)
    (network_configuration_applied ?change_case - service_case)
    (engineer_available ?engineer - engineer)
    (route_available ?route - route)
    (upstream_available ?upstream_service - upstream_service)
    (downstream_available ?downstream_service - downstream_service)
    (infrastructure_available ?infrastructure_component - infrastructure_component)
    (routing_token_available ?routing_token - routing_token)
    (approver_available ?approver - approver)
    (mitigation_action_available ?mitigation_action - mitigation_action)
    (network_control_available ?network_control - network_control)
    (credential_available ?credential - credential)
    (service_group_available ?service_group - service_group)
    (engineer_eligible_for_case ?change_case - service_case ?engineer - engineer)
    (case_route_candidate ?change_case - service_case ?route - route)
    (case_upstream_candidate ?change_case - service_case ?upstream_service - upstream_service)
    (case_downstream_candidate ?change_case - service_case ?downstream_service - downstream_service)
    (case_infrastructure_candidate ?change_case - service_case ?infrastructure_component - infrastructure_component)
    (case_credential_required ?change_case - service_case ?credential - credential)
    (case_service_group_candidate ?change_case - service_case ?service_group - service_group)
    (case_stakeholder_role ?change_case - service_case ?stakeholder_group - stakeholder_role)
    (mitigation_action_reserved ?change_case - service_case ?mitigation_action - mitigation_action)
    (case_closure_eligibility_flag ?change_case - service_case)
    (case_requires_finalization_check ?change_case - service_case)
    (case_routing_token_reserved ?change_case - service_case ?routing_token - routing_token)
    (external_review_required ?change_case - service_case)
    (case_action_applicable ?change_case - service_case ?mitigation_action - mitigation_action)
  )
  (:action create_change_case
    :parameters (?change_case - service_case)
    :precondition
      (and
        (not
          (case_open ?change_case)
        )
        (not
          (case_closed ?change_case)
        )
      )
    :effect
      (and
        (case_open ?change_case)
      )
  )
  (:action assign_engineer_to_case
    :parameters (?change_case - service_case ?engineer - engineer)
    :precondition
      (and
        (case_open ?change_case)
        (engineer_available ?engineer)
        (engineer_eligible_for_case ?change_case ?engineer)
        (not
          (assignee_reserved ?change_case)
        )
      )
    :effect
      (and
        (case_assigned ?change_case ?engineer)
        (assignee_reserved ?change_case)
        (not
          (engineer_available ?engineer)
        )
      )
  )
  (:action release_engineer_from_case
    :parameters (?change_case - service_case ?engineer - engineer)
    :precondition
      (and
        (case_assigned ?change_case ?engineer)
        (not
          (mitigation_authorized ?change_case)
        )
        (not
          (approvals_collected ?change_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned ?change_case ?engineer)
        )
        (not
          (assignee_reserved ?change_case)
        )
        (not
          (preapproval_obtained ?change_case)
        )
        (not
          (route_prechecks_passed ?change_case)
        )
        (not
          (stakeholder_ack_required ?change_case)
        )
        (not
          (execution_committed ?change_case)
        )
        (not
          (external_review_required ?change_case)
        )
        (engineer_available ?engineer)
      )
  )
  (:action reserve_routing_token
    :parameters (?change_case - service_case ?routing_token - routing_token)
    :precondition
      (and
        (case_open ?change_case)
        (routing_token_available ?routing_token)
      )
    :effect
      (and
        (case_routing_token_reserved ?change_case ?routing_token)
        (not
          (routing_token_available ?routing_token)
        )
      )
  )
  (:action release_routing_token
    :parameters (?change_case - service_case ?routing_token - routing_token)
    :precondition
      (and
        (case_routing_token_reserved ?change_case ?routing_token)
      )
    :effect
      (and
        (routing_token_available ?routing_token)
        (not
          (case_routing_token_reserved ?change_case ?routing_token)
        )
      )
  )
  (:action record_preapproval_for_tokened_route
    :parameters (?change_case - service_case ?routing_token - routing_token)
    :precondition
      (and
        (case_open ?change_case)
        (assignee_reserved ?change_case)
        (case_routing_token_reserved ?change_case ?routing_token)
        (not
          (preapproval_obtained ?change_case)
        )
      )
    :effect
      (and
        (preapproval_obtained ?change_case)
      )
  )
  (:action obtain_approver_preapproval
    :parameters (?change_case - service_case ?approver - approver)
    :precondition
      (and
        (case_open ?change_case)
        (assignee_reserved ?change_case)
        (approver_available ?approver)
        (not
          (preapproval_obtained ?change_case)
        )
      )
    :effect
      (and
        (preapproval_obtained ?change_case)
        (stakeholder_ack_required ?change_case)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action bind_network_control_and_mark_ready
    :parameters (?change_case - service_case ?routing_token - routing_token ?network_control - network_control)
    :precondition
      (and
        (preapproval_obtained ?change_case)
        (assignee_reserved ?change_case)
        (case_routing_token_reserved ?change_case ?routing_token)
        (network_control_available ?network_control)
        (not
          (route_prechecks_passed ?change_case)
        )
      )
    :effect
      (and
        (route_prechecks_passed ?change_case)
        (not
          (stakeholder_ack_required ?change_case)
        )
      )
  )
  (:action use_mitigation_action_to_mark_ready
    :parameters (?change_case - service_case ?mitigation_action - mitigation_action)
    :precondition
      (and
        (assignee_reserved ?change_case)
        (mitigation_bound_to_instance ?change_case ?mitigation_action)
        (not
          (route_prechecks_passed ?change_case)
        )
      )
    :effect
      (and
        (route_prechecks_passed ?change_case)
        (not
          (stakeholder_ack_required ?change_case)
        )
      )
  )
  (:action reserve_upstream_dependency
    :parameters (?change_case - service_case ?upstream_service - upstream_service)
    :precondition
      (and
        (case_open ?change_case)
        (upstream_available ?upstream_service)
        (case_upstream_candidate ?change_case ?upstream_service)
      )
    :effect
      (and
        (upstream_reserved ?change_case ?upstream_service)
        (not
          (upstream_available ?upstream_service)
        )
      )
  )
  (:action release_upstream_dependency
    :parameters (?change_case - service_case ?upstream_service - upstream_service)
    :precondition
      (and
        (upstream_reserved ?change_case ?upstream_service)
      )
    :effect
      (and
        (upstream_available ?upstream_service)
        (not
          (upstream_reserved ?change_case ?upstream_service)
        )
      )
  )
  (:action reserve_downstream_dependency
    :parameters (?change_case - service_case ?downstream_service - downstream_service)
    :precondition
      (and
        (case_open ?change_case)
        (downstream_available ?downstream_service)
        (case_downstream_candidate ?change_case ?downstream_service)
      )
    :effect
      (and
        (downstream_reserved ?change_case ?downstream_service)
        (not
          (downstream_available ?downstream_service)
        )
      )
  )
  (:action release_downstream_dependency
    :parameters (?change_case - service_case ?downstream_service - downstream_service)
    :precondition
      (and
        (downstream_reserved ?change_case ?downstream_service)
      )
    :effect
      (and
        (downstream_available ?downstream_service)
        (not
          (downstream_reserved ?change_case ?downstream_service)
        )
      )
  )
  (:action reserve_infrastructure_component
    :parameters (?change_case - service_case ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (case_open ?change_case)
        (infrastructure_available ?infrastructure_component)
        (case_infrastructure_candidate ?change_case ?infrastructure_component)
      )
    :effect
      (and
        (infrastructure_reserved ?change_case ?infrastructure_component)
        (not
          (infrastructure_available ?infrastructure_component)
        )
      )
  )
  (:action release_infrastructure_component
    :parameters (?change_case - service_case ?infrastructure_component - infrastructure_component)
    :precondition
      (and
        (infrastructure_reserved ?change_case ?infrastructure_component)
      )
    :effect
      (and
        (infrastructure_available ?infrastructure_component)
        (not
          (infrastructure_reserved ?change_case ?infrastructure_component)
        )
      )
  )
  (:action reserve_service_group
    :parameters (?change_case - service_case ?service_group - service_group)
    :precondition
      (and
        (case_open ?change_case)
        (service_group_available ?service_group)
        (case_service_group_candidate ?change_case ?service_group)
      )
    :effect
      (and
        (service_group_reserved ?change_case ?service_group)
        (not
          (service_group_available ?service_group)
        )
      )
  )
  (:action release_service_group
    :parameters (?change_case - service_case ?service_group - service_group)
    :precondition
      (and
        (service_group_reserved ?change_case ?service_group)
      )
    :effect
      (and
        (service_group_available ?service_group)
        (not
          (service_group_reserved ?change_case ?service_group)
        )
      )
  )
  (:action plan_mitigation_on_route
    :parameters (?change_case - service_case ?route - route ?upstream_service - upstream_service ?downstream_service - downstream_service)
    :precondition
      (and
        (assignee_reserved ?change_case)
        (upstream_reserved ?change_case ?upstream_service)
        (downstream_reserved ?change_case ?downstream_service)
        (route_available ?route)
        (case_route_candidate ?change_case ?route)
        (not
          (mitigation_authorized ?change_case)
        )
      )
    :effect
      (and
        (mitigation_planned_on_route ?change_case ?route)
        (mitigation_authorized ?change_case)
        (not
          (route_available ?route)
        )
      )
  )
  (:action plan_mitigation_with_infra_and_credential
    :parameters (?change_case - service_case ?route - route ?infrastructure_component - infrastructure_component ?credential - credential)
    :precondition
      (and
        (assignee_reserved ?change_case)
        (infrastructure_reserved ?change_case ?infrastructure_component)
        (credential_available ?credential)
        (route_available ?route)
        (case_route_candidate ?change_case ?route)
        (case_credential_required ?change_case ?credential)
        (not
          (mitigation_authorized ?change_case)
        )
      )
    :effect
      (and
        (mitigation_planned_on_route ?change_case ?route)
        (mitigation_authorized ?change_case)
        (external_review_required ?change_case)
        (stakeholder_ack_required ?change_case)
        (not
          (route_available ?route)
        )
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action clear_external_review_and_release_flags
    :parameters (?change_case - service_case ?upstream_service - upstream_service ?downstream_service - downstream_service)
    :precondition
      (and
        (mitigation_authorized ?change_case)
        (external_review_required ?change_case)
        (upstream_reserved ?change_case ?upstream_service)
        (downstream_reserved ?change_case ?downstream_service)
      )
    :effect
      (and
        (not
          (external_review_required ?change_case)
        )
        (not
          (stakeholder_ack_required ?change_case)
        )
      )
  )
  (:action collect_approvals_and_record
    :parameters (?change_case - service_case ?upstream_service - upstream_service ?downstream_service - downstream_service ?stakeholder_group - stakeholder_group)
    :precondition
      (and
        (route_prechecks_passed ?change_case)
        (mitigation_authorized ?change_case)
        (upstream_reserved ?change_case ?upstream_service)
        (downstream_reserved ?change_case ?downstream_service)
        (case_stakeholder_role ?change_case ?stakeholder_group)
        (not
          (stakeholder_ack_required ?change_case)
        )
        (not
          (approvals_collected ?change_case)
        )
      )
    :effect
      (and
        (approvals_collected ?change_case)
      )
  )
  (:action finalize_approvals_with_escalation
    :parameters (?change_case - service_case ?infrastructure_component - infrastructure_component ?service_group - service_group ?escalation_group - escalation_group)
    :precondition
      (and
        (route_prechecks_passed ?change_case)
        (mitigation_authorized ?change_case)
        (infrastructure_reserved ?change_case ?infrastructure_component)
        (service_group_reserved ?change_case ?service_group)
        (case_stakeholder_role ?change_case ?escalation_group)
        (not
          (approvals_collected ?change_case)
        )
      )
    :effect
      (and
        (approvals_collected ?change_case)
        (stakeholder_ack_required ?change_case)
      )
  )
  (:action commit_execution_and_clear_locks
    :parameters (?change_case - service_case ?upstream_service - upstream_service ?downstream_service - downstream_service)
    :precondition
      (and
        (approvals_collected ?change_case)
        (stakeholder_ack_required ?change_case)
        (upstream_reserved ?change_case ?upstream_service)
        (downstream_reserved ?change_case ?downstream_service)
      )
    :effect
      (and
        (execution_committed ?change_case)
        (not
          (stakeholder_ack_required ?change_case)
        )
        (not
          (route_prechecks_passed ?change_case)
        )
        (not
          (external_review_required ?change_case)
        )
      )
  )
  (:action reapply_network_control_to_resume
    :parameters (?change_case - service_case ?routing_token - routing_token ?network_control - network_control)
    :precondition
      (and
        (execution_committed ?change_case)
        (approvals_collected ?change_case)
        (assignee_reserved ?change_case)
        (case_routing_token_reserved ?change_case ?routing_token)
        (network_control_available ?network_control)
        (not
          (route_prechecks_passed ?change_case)
        )
      )
    :effect
      (and
        (route_prechecks_passed ?change_case)
      )
  )
  (:action claim_execution_token_for_route_segment
    :parameters (?change_case - service_case ?routing_token - routing_token)
    :precondition
      (and
        (approvals_collected ?change_case)
        (route_prechecks_passed ?change_case)
        (not
          (stakeholder_ack_required ?change_case)
        )
        (case_routing_token_reserved ?change_case ?routing_token)
        (not
          (execution_token_claimed ?change_case)
        )
      )
    :effect
      (and
        (execution_token_claimed ?change_case)
      )
  )
  (:action claim_execution_token_with_approver
    :parameters (?change_case - service_case ?approver - approver)
    :precondition
      (and
        (approvals_collected ?change_case)
        (route_prechecks_passed ?change_case)
        (not
          (stakeholder_ack_required ?change_case)
        )
        (approver_available ?approver)
        (not
          (execution_token_claimed ?change_case)
        )
      )
    :effect
      (and
        (execution_token_claimed ?change_case)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action reserve_mitigation_action_for_case
    :parameters (?change_case - service_case ?mitigation_action - mitigation_action)
    :precondition
      (and
        (execution_token_claimed ?change_case)
        (mitigation_action_available ?mitigation_action)
        (case_action_applicable ?change_case ?mitigation_action)
      )
    :effect
      (and
        (mitigation_action_reserved ?change_case ?mitigation_action)
        (not
          (mitigation_action_available ?mitigation_action)
        )
      )
  )
  (:action bind_mitigation_to_instance
    :parameters (?service_instance_type_b - service_instance_type_b ?service_instance_type_a - service_instance_type_a ?mitigation_action - mitigation_action)
    :precondition
      (and
        (case_open ?service_instance_type_b)
        (case_requires_finalization_check ?service_instance_type_b)
        (instance_supports_mitigation ?service_instance_type_b ?mitigation_action)
        (mitigation_action_reserved ?service_instance_type_a ?mitigation_action)
        (not
          (mitigation_bound_to_instance ?service_instance_type_b ?mitigation_action)
        )
      )
    :effect
      (and
        (mitigation_bound_to_instance ?service_instance_type_b ?mitigation_action)
      )
  )
  (:action record_network_configuration_for_finalization
    :parameters (?change_case - service_case ?routing_token - routing_token ?network_control - network_control)
    :precondition
      (and
        (case_open ?change_case)
        (case_requires_finalization_check ?change_case)
        (route_prechecks_passed ?change_case)
        (execution_token_claimed ?change_case)
        (case_routing_token_reserved ?change_case ?routing_token)
        (network_control_available ?network_control)
        (not
          (network_configuration_applied ?change_case)
        )
      )
    :effect
      (and
        (network_configuration_applied ?change_case)
      )
  )
  (:action close_case_standard_path
    :parameters (?change_case - service_case)
    :precondition
      (and
        (case_closure_eligibility_flag ?change_case)
        (case_open ?change_case)
        (assignee_reserved ?change_case)
        (mitigation_authorized ?change_case)
        (approvals_collected ?change_case)
        (execution_token_claimed ?change_case)
        (route_prechecks_passed ?change_case)
        (not
          (case_closed ?change_case)
        )
      )
    :effect
      (and
        (case_closed ?change_case)
      )
  )
  (:action close_case_with_mitigation_binding
    :parameters (?change_case - service_case ?mitigation_action - mitigation_action)
    :precondition
      (and
        (case_requires_finalization_check ?change_case)
        (case_open ?change_case)
        (assignee_reserved ?change_case)
        (mitigation_authorized ?change_case)
        (approvals_collected ?change_case)
        (execution_token_claimed ?change_case)
        (route_prechecks_passed ?change_case)
        (mitigation_bound_to_instance ?change_case ?mitigation_action)
        (not
          (case_closed ?change_case)
        )
      )
    :effect
      (and
        (case_closed ?change_case)
      )
  )
  (:action close_case_with_network_validation
    :parameters (?change_case - service_case)
    :precondition
      (and
        (case_requires_finalization_check ?change_case)
        (case_open ?change_case)
        (assignee_reserved ?change_case)
        (mitigation_authorized ?change_case)
        (approvals_collected ?change_case)
        (execution_token_claimed ?change_case)
        (route_prechecks_passed ?change_case)
        (network_configuration_applied ?change_case)
        (not
          (case_closed ?change_case)
        )
      )
    :effect
      (and
        (case_closed ?change_case)
      )
  )
)

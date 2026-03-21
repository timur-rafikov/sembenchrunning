(define (domain postmortem_action_item_closure_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types action_item - object assignee_candidate - object change_request_plan - object application_component - object infrastructure_resource - object external_dependency - object runbook - object reviewer - object change_ticket_record - object automation_tool - object test_environment - object vendor_contact - object approval_role - object approver - approval_role authority - approval_role action_item_variant_a - action_item action_item_variant_b - action_item)
  (:predicates
    (action_item_open ?action_item - action_item)
    (assigned_to ?action_item - action_item ?assignee - assignee_candidate)
    (has_assignment ?action_item - action_item)
    (readiness_confirmed ?action_item - action_item)
    (implemented ?action_item - action_item)
    (reserved_infrastructure ?action_item - action_item ?infrastructure_resource - infrastructure_resource)
    (reserved_component ?action_item - action_item ?application_component - application_component)
    (reserved_external_dependency ?action_item - action_item ?external_dependency - external_dependency)
    (reserved_vendor_contact ?action_item - action_item ?vendor_contact - vendor_contact)
    (linked_change_request ?action_item - action_item ?change_request - change_request_plan)
    (implementation_started ?action_item - action_item)
    (approvals_collected ?action_item - action_item)
    (execution_verified ?action_item - action_item)
    (action_item_closed ?action_item - action_item)
    (review_request_active ?action_item - action_item)
    (scheduled_for_execution ?action_item - action_item)
    (variant_change_ticket_linkable ?action_item - action_item ?change_ticket - change_ticket_record)
    (change_ticket_associated ?action_item - action_item ?change_ticket - change_ticket_record)
    (automation_completed ?action_item - action_item)
    (assignee_available ?assignee - assignee_candidate)
    (change_request_available ?change_request - change_request_plan)
    (infrastructure_available ?infrastructure_resource - infrastructure_resource)
    (component_available ?application_component - application_component)
    (external_dependency_available ?external_dependency - external_dependency)
    (runbook_available ?runbook - runbook)
    (reviewer_available ?reviewer - reviewer)
    (change_ticket_available ?change_ticket - change_ticket_record)
    (automation_tool_available ?automation_tool - automation_tool)
    (test_environment_available ?test_environment - test_environment)
    (vendor_contact_available ?vendor_contact - vendor_contact)
    (eligible_assignee ?action_item - action_item ?assignee - assignee_candidate)
    (applicable_change_request ?action_item - action_item ?change_request - change_request_plan)
    (applicable_infrastructure ?action_item - action_item ?infrastructure_resource - infrastructure_resource)
    (applicable_component ?action_item - action_item ?application_component - application_component)
    (applicable_external_dependency ?action_item - action_item ?external_dependency - external_dependency)
    (compatible_test_environment ?action_item - action_item ?test_environment - test_environment)
    (applicable_vendor_contact ?action_item - action_item ?vendor_contact - vendor_contact)
    (approver_group_association ?action_item - action_item ?approver_group - approval_role)
    (change_ticket_reserved_for_item ?action_item - action_item ?change_ticket - change_ticket_record)
    (variant_a_marker ?action_item - action_item)
    (variant_b_marker ?action_item - action_item)
    (runbook_attached ?action_item - action_item ?runbook - runbook)
    (implementation_recorded ?action_item - action_item)
    (change_ticket_applicable ?action_item - action_item ?change_ticket - change_ticket_record)
  )
  (:action create_action_item
    :parameters (?action_item - action_item)
    :precondition
      (and
        (not
          (action_item_open ?action_item)
        )
        (not
          (action_item_closed ?action_item)
        )
      )
    :effect
      (and
        (action_item_open ?action_item)
      )
  )
  (:action assign_action_item
    :parameters (?action_item - action_item ?assignee - assignee_candidate)
    :precondition
      (and
        (action_item_open ?action_item)
        (assignee_available ?assignee)
        (eligible_assignee ?action_item ?assignee)
        (not
          (has_assignment ?action_item)
        )
      )
    :effect
      (and
        (assigned_to ?action_item ?assignee)
        (has_assignment ?action_item)
        (not
          (assignee_available ?assignee)
        )
      )
  )
  (:action unassign_action_item
    :parameters (?action_item - action_item ?assignee - assignee_candidate)
    :precondition
      (and
        (assigned_to ?action_item ?assignee)
        (not
          (implementation_started ?action_item)
        )
        (not
          (approvals_collected ?action_item)
        )
      )
    :effect
      (and
        (not
          (assigned_to ?action_item ?assignee)
        )
        (not
          (has_assignment ?action_item)
        )
        (not
          (readiness_confirmed ?action_item)
        )
        (not
          (implemented ?action_item)
        )
        (not
          (review_request_active ?action_item)
        )
        (not
          (scheduled_for_execution ?action_item)
        )
        (not
          (implementation_recorded ?action_item)
        )
        (assignee_available ?assignee)
      )
  )
  (:action attach_runbook
    :parameters (?action_item - action_item ?runbook - runbook)
    :precondition
      (and
        (action_item_open ?action_item)
        (runbook_available ?runbook)
      )
    :effect
      (and
        (runbook_attached ?action_item ?runbook)
        (not
          (runbook_available ?runbook)
        )
      )
  )
  (:action detach_runbook
    :parameters (?action_item - action_item ?runbook - runbook)
    :precondition
      (and
        (runbook_attached ?action_item ?runbook)
      )
    :effect
      (and
        (runbook_available ?runbook)
        (not
          (runbook_attached ?action_item ?runbook)
        )
      )
  )
  (:action acknowledge_runbook_assignment
    :parameters (?action_item - action_item ?runbook - runbook)
    :precondition
      (and
        (action_item_open ?action_item)
        (has_assignment ?action_item)
        (runbook_attached ?action_item ?runbook)
        (not
          (readiness_confirmed ?action_item)
        )
      )
    :effect
      (and
        (readiness_confirmed ?action_item)
      )
  )
  (:action assign_reviewer
    :parameters (?action_item - action_item ?reviewer - reviewer)
    :precondition
      (and
        (action_item_open ?action_item)
        (has_assignment ?action_item)
        (reviewer_available ?reviewer)
        (not
          (readiness_confirmed ?action_item)
        )
      )
    :effect
      (and
        (readiness_confirmed ?action_item)
        (review_request_active ?action_item)
        (not
          (reviewer_available ?reviewer)
        )
      )
  )
  (:action start_automation_runbook
    :parameters (?action_item - action_item ?runbook - runbook ?automation_tool - automation_tool)
    :precondition
      (and
        (readiness_confirmed ?action_item)
        (has_assignment ?action_item)
        (runbook_attached ?action_item ?runbook)
        (automation_tool_available ?automation_tool)
        (not
          (implemented ?action_item)
        )
      )
    :effect
      (and
        (implemented ?action_item)
        (not
          (review_request_active ?action_item)
        )
      )
  )
  (:action trigger_change_ticket_execution
    :parameters (?action_item - action_item ?change_ticket - change_ticket_record)
    :precondition
      (and
        (has_assignment ?action_item)
        (change_ticket_associated ?action_item ?change_ticket)
        (not
          (implemented ?action_item)
        )
      )
    :effect
      (and
        (implemented ?action_item)
        (not
          (review_request_active ?action_item)
        )
      )
  )
  (:action reserve_infrastructure
    :parameters (?action_item - action_item ?infrastructure_resource - infrastructure_resource)
    :precondition
      (and
        (action_item_open ?action_item)
        (infrastructure_available ?infrastructure_resource)
        (applicable_infrastructure ?action_item ?infrastructure_resource)
      )
    :effect
      (and
        (reserved_infrastructure ?action_item ?infrastructure_resource)
        (not
          (infrastructure_available ?infrastructure_resource)
        )
      )
  )
  (:action release_infrastructure
    :parameters (?action_item - action_item ?infrastructure_resource - infrastructure_resource)
    :precondition
      (and
        (reserved_infrastructure ?action_item ?infrastructure_resource)
      )
    :effect
      (and
        (infrastructure_available ?infrastructure_resource)
        (not
          (reserved_infrastructure ?action_item ?infrastructure_resource)
        )
      )
  )
  (:action reserve_component
    :parameters (?action_item - action_item ?application_component - application_component)
    :precondition
      (and
        (action_item_open ?action_item)
        (component_available ?application_component)
        (applicable_component ?action_item ?application_component)
      )
    :effect
      (and
        (reserved_component ?action_item ?application_component)
        (not
          (component_available ?application_component)
        )
      )
  )
  (:action release_component
    :parameters (?action_item - action_item ?application_component - application_component)
    :precondition
      (and
        (reserved_component ?action_item ?application_component)
      )
    :effect
      (and
        (component_available ?application_component)
        (not
          (reserved_component ?action_item ?application_component)
        )
      )
  )
  (:action reserve_external_dependency
    :parameters (?action_item - action_item ?external_dependency - external_dependency)
    :precondition
      (and
        (action_item_open ?action_item)
        (external_dependency_available ?external_dependency)
        (applicable_external_dependency ?action_item ?external_dependency)
      )
    :effect
      (and
        (reserved_external_dependency ?action_item ?external_dependency)
        (not
          (external_dependency_available ?external_dependency)
        )
      )
  )
  (:action release_external_dependency
    :parameters (?action_item - action_item ?external_dependency - external_dependency)
    :precondition
      (and
        (reserved_external_dependency ?action_item ?external_dependency)
      )
    :effect
      (and
        (external_dependency_available ?external_dependency)
        (not
          (reserved_external_dependency ?action_item ?external_dependency)
        )
      )
  )
  (:action reserve_vendor_contact
    :parameters (?action_item - action_item ?vendor_contact - vendor_contact)
    :precondition
      (and
        (action_item_open ?action_item)
        (vendor_contact_available ?vendor_contact)
        (applicable_vendor_contact ?action_item ?vendor_contact)
      )
    :effect
      (and
        (reserved_vendor_contact ?action_item ?vendor_contact)
        (not
          (vendor_contact_available ?vendor_contact)
        )
      )
  )
  (:action release_vendor_contact
    :parameters (?action_item - action_item ?vendor_contact - vendor_contact)
    :precondition
      (and
        (reserved_vendor_contact ?action_item ?vendor_contact)
      )
    :effect
      (and
        (vendor_contact_available ?vendor_contact)
        (not
          (reserved_vendor_contact ?action_item ?vendor_contact)
        )
      )
  )
  (:action initiate_execution
    :parameters (?action_item - action_item ?change_request - change_request_plan ?infrastructure_resource - infrastructure_resource ?application_component - application_component)
    :precondition
      (and
        (has_assignment ?action_item)
        (reserved_infrastructure ?action_item ?infrastructure_resource)
        (reserved_component ?action_item ?application_component)
        (change_request_available ?change_request)
        (applicable_change_request ?action_item ?change_request)
        (not
          (implementation_started ?action_item)
        )
      )
    :effect
      (and
        (linked_change_request ?action_item ?change_request)
        (implementation_started ?action_item)
        (not
          (change_request_available ?change_request)
        )
      )
  )
  (:action initiate_external_execution
    :parameters (?action_item - action_item ?change_request - change_request_plan ?external_dependency - external_dependency ?test_environment - test_environment)
    :precondition
      (and
        (has_assignment ?action_item)
        (reserved_external_dependency ?action_item ?external_dependency)
        (test_environment_available ?test_environment)
        (change_request_available ?change_request)
        (applicable_change_request ?action_item ?change_request)
        (compatible_test_environment ?action_item ?test_environment)
        (not
          (implementation_started ?action_item)
        )
      )
    :effect
      (and
        (linked_change_request ?action_item ?change_request)
        (implementation_started ?action_item)
        (implementation_recorded ?action_item)
        (review_request_active ?action_item)
        (not
          (change_request_available ?change_request)
        )
        (not
          (test_environment_available ?test_environment)
        )
      )
  )
  (:action finalize_initial_housekeeping
    :parameters (?action_item - action_item ?infrastructure_resource - infrastructure_resource ?application_component - application_component)
    :precondition
      (and
        (implementation_started ?action_item)
        (implementation_recorded ?action_item)
        (reserved_infrastructure ?action_item ?infrastructure_resource)
        (reserved_component ?action_item ?application_component)
      )
    :effect
      (and
        (not
          (implementation_recorded ?action_item)
        )
        (not
          (review_request_active ?action_item)
        )
      )
  )
  (:action collect_approvals
    :parameters (?action_item - action_item ?infrastructure_resource - infrastructure_resource ?application_component - application_component ?approver - approver)
    :precondition
      (and
        (implemented ?action_item)
        (implementation_started ?action_item)
        (reserved_infrastructure ?action_item ?infrastructure_resource)
        (reserved_component ?action_item ?application_component)
        (approver_group_association ?action_item ?approver)
        (not
          (review_request_active ?action_item)
        )
        (not
          (approvals_collected ?action_item)
        )
      )
    :effect
      (and
        (approvals_collected ?action_item)
      )
  )
  (:action collect_authority_approval
    :parameters (?action_item - action_item ?external_dependency - external_dependency ?vendor_contact - vendor_contact ?authority - authority)
    :precondition
      (and
        (implemented ?action_item)
        (implementation_started ?action_item)
        (reserved_external_dependency ?action_item ?external_dependency)
        (reserved_vendor_contact ?action_item ?vendor_contact)
        (approver_group_association ?action_item ?authority)
        (not
          (approvals_collected ?action_item)
        )
      )
    :effect
      (and
        (approvals_collected ?action_item)
        (review_request_active ?action_item)
      )
  )
  (:action post_approval_mark_execution_scheduled
    :parameters (?action_item - action_item ?infrastructure_resource - infrastructure_resource ?application_component - application_component)
    :precondition
      (and
        (approvals_collected ?action_item)
        (review_request_active ?action_item)
        (reserved_infrastructure ?action_item ?infrastructure_resource)
        (reserved_component ?action_item ?application_component)
      )
    :effect
      (and
        (scheduled_for_execution ?action_item)
        (not
          (review_request_active ?action_item)
        )
        (not
          (implemented ?action_item)
        )
        (not
          (implementation_recorded ?action_item)
        )
      )
  )
  (:action execute_runbook_via_automation
    :parameters (?action_item - action_item ?runbook - runbook ?automation_tool - automation_tool)
    :precondition
      (and
        (scheduled_for_execution ?action_item)
        (approvals_collected ?action_item)
        (has_assignment ?action_item)
        (runbook_attached ?action_item ?runbook)
        (automation_tool_available ?automation_tool)
        (not
          (implemented ?action_item)
        )
      )
    :effect
      (and
        (implemented ?action_item)
      )
  )
  (:action mark_execution_verified_by_runbook
    :parameters (?action_item - action_item ?runbook - runbook)
    :precondition
      (and
        (approvals_collected ?action_item)
        (implemented ?action_item)
        (not
          (review_request_active ?action_item)
        )
        (runbook_attached ?action_item ?runbook)
        (not
          (execution_verified ?action_item)
        )
      )
    :effect
      (and
        (execution_verified ?action_item)
      )
  )
  (:action mark_execution_verified_by_reviewer
    :parameters (?action_item - action_item ?reviewer - reviewer)
    :precondition
      (and
        (approvals_collected ?action_item)
        (implemented ?action_item)
        (not
          (review_request_active ?action_item)
        )
        (reviewer_available ?reviewer)
        (not
          (execution_verified ?action_item)
        )
      )
    :effect
      (and
        (execution_verified ?action_item)
        (not
          (reviewer_available ?reviewer)
        )
      )
  )
  (:action reserve_change_ticket
    :parameters (?action_item - action_item ?change_ticket - change_ticket_record)
    :precondition
      (and
        (execution_verified ?action_item)
        (change_ticket_available ?change_ticket)
        (change_ticket_applicable ?action_item ?change_ticket)
      )
    :effect
      (and
        (change_ticket_reserved_for_item ?action_item ?change_ticket)
        (not
          (change_ticket_available ?change_ticket)
        )
      )
  )
  (:action link_variants_to_change_ticket
    :parameters (?action_item_variant_b - action_item_variant_b ?action_item_variant_a - action_item_variant_a ?change_ticket - change_ticket_record)
    :precondition
      (and
        (action_item_open ?action_item_variant_b)
        (variant_b_marker ?action_item_variant_b)
        (variant_change_ticket_linkable ?action_item_variant_b ?change_ticket)
        (change_ticket_reserved_for_item ?action_item_variant_a ?change_ticket)
        (not
          (change_ticket_associated ?action_item_variant_b ?change_ticket)
        )
      )
    :effect
      (and
        (change_ticket_associated ?action_item_variant_b ?change_ticket)
      )
  )
  (:action acknowledge_automation_completion
    :parameters (?action_item - action_item ?runbook - runbook ?automation_tool - automation_tool)
    :precondition
      (and
        (action_item_open ?action_item)
        (variant_b_marker ?action_item)
        (implemented ?action_item)
        (execution_verified ?action_item)
        (runbook_attached ?action_item ?runbook)
        (automation_tool_available ?automation_tool)
        (not
          (automation_completed ?action_item)
        )
      )
    :effect
      (and
        (automation_completed ?action_item)
      )
  )
  (:action close_action_item_variant_a_path
    :parameters (?action_item - action_item)
    :precondition
      (and
        (variant_a_marker ?action_item)
        (action_item_open ?action_item)
        (has_assignment ?action_item)
        (implementation_started ?action_item)
        (approvals_collected ?action_item)
        (execution_verified ?action_item)
        (implemented ?action_item)
        (not
          (action_item_closed ?action_item)
        )
      )
    :effect
      (and
        (action_item_closed ?action_item)
      )
  )
  (:action close_action_item_with_change_ticket
    :parameters (?action_item - action_item ?change_ticket - change_ticket_record)
    :precondition
      (and
        (variant_b_marker ?action_item)
        (action_item_open ?action_item)
        (has_assignment ?action_item)
        (implementation_started ?action_item)
        (approvals_collected ?action_item)
        (execution_verified ?action_item)
        (implemented ?action_item)
        (change_ticket_associated ?action_item ?change_ticket)
        (not
          (action_item_closed ?action_item)
        )
      )
    :effect
      (and
        (action_item_closed ?action_item)
      )
  )
  (:action close_action_item_with_automation
    :parameters (?action_item - action_item)
    :precondition
      (and
        (variant_b_marker ?action_item)
        (action_item_open ?action_item)
        (has_assignment ?action_item)
        (implementation_started ?action_item)
        (approvals_collected ?action_item)
        (execution_verified ?action_item)
        (implemented ?action_item)
        (automation_completed ?action_item)
        (not
          (action_item_closed ?action_item)
        )
      )
    :effect
      (and
        (action_item_closed ?action_item)
      )
  )
)

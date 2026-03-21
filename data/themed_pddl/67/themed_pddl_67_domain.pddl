(define (domain postmortem_action_item_closure_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types action_item - object assignee_candidate - object change_request_plan - object application_component - object infrastructure_resource - object external_dependency - object runbook - object reviewer - object change_ticket_record - object automation_tool - object test_environment - object vendor_contact - object approval_role - object approver - approval_role authority - approval_role action_item_variant_a - action_item action_item_variant_b - action_item)
  (:predicates
    (reviewer_available ?reviewer - reviewer)
    (reserved_component ?action_item - action_item ?application_component - application_component)
    (scheduled_for_execution ?action_item - action_item)
    (assigned_to ?action_item - action_item ?assignee - assignee_candidate)
    (approver_group_association ?action_item - action_item ?approver_group - approval_role)
    (external_dependency_available ?external_dependency - external_dependency)
    (component_available ?application_component - application_component)
    (applicable_vendor_contact ?action_item - action_item ?vendor_contact - vendor_contact)
    (action_item_closed ?action_item - action_item)
    (variant_a_marker ?action_item - action_item)
    (eligible_assignee ?action_item - action_item ?assignee - assignee_candidate)
    (change_request_available ?change_request - change_request_plan)
    (test_environment_available ?test_environment - test_environment)
    (runbook_available ?runbook - runbook)
    (implementation_started ?action_item - action_item)
    (applicable_component ?action_item - action_item ?application_component - application_component)
    (reserved_vendor_contact ?action_item - action_item ?vendor_contact - vendor_contact)
    (linked_change_request ?action_item - action_item ?change_request - change_request_plan)
    (approvals_collected ?action_item - action_item)
    (applicable_external_dependency ?action_item - action_item ?external_dependency - external_dependency)
    (vendor_contact_available ?vendor_contact - vendor_contact)
    (variant_b_marker ?action_item - action_item)
    (implemented ?action_item - action_item)
    (applicable_infrastructure ?action_item - action_item ?infrastructure_resource - infrastructure_resource)
    (reserved_infrastructure ?action_item - action_item ?infrastructure_resource - infrastructure_resource)
    (implementation_recorded ?action_item - action_item)
    (runbook_attached ?action_item - action_item ?runbook - runbook)
    (automation_completed ?action_item - action_item)
    (compatible_test_environment ?action_item - action_item ?test_environment - test_environment)
    (action_item_open ?action_item - action_item)
    (assignee_available ?assignee - assignee_candidate)
    (has_assignment ?action_item - action_item)
    (automation_tool_available ?automation_tool - automation_tool)
    (change_ticket_available ?change_ticket - change_ticket_record)
    (reserved_external_dependency ?action_item - action_item ?external_dependency - external_dependency)
    (change_ticket_reserved_for_item ?action_item - action_item ?change_ticket - change_ticket_record)
    (readiness_confirmed ?action_item - action_item)
    (execution_verified ?action_item - action_item)
    (change_ticket_applicable ?action_item - action_item ?change_ticket - change_ticket_record)
    (infrastructure_available ?infrastructure_resource - infrastructure_resource)
    (variant_change_ticket_linkable ?action_item - action_item ?change_ticket - change_ticket_record)
    (applicable_change_request ?action_item - action_item ?change_request - change_request_plan)
    (review_request_active ?action_item - action_item)
    (change_ticket_associated ?action_item - action_item ?change_ticket - change_ticket_record)
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
  (:action collect_authority_approval
    :parameters (?action_item - action_item ?external_dependency - external_dependency ?vendor_contact - vendor_contact ?authority - authority)
    :precondition
      (and
        (not
          (approvals_collected ?action_item)
        )
        (implementation_started ?action_item)
        (implemented ?action_item)
        (reserved_vendor_contact ?action_item ?vendor_contact)
        (approver_group_association ?action_item ?authority)
        (reserved_external_dependency ?action_item ?external_dependency)
      )
    :effect
      (and
        (review_request_active ?action_item)
        (approvals_collected ?action_item)
      )
  )
  (:action close_action_item_variant_a_path
    :parameters (?action_item - action_item)
    :precondition
      (and
        (implemented ?action_item)
        (has_assignment ?action_item)
        (implementation_started ?action_item)
        (action_item_open ?action_item)
        (execution_verified ?action_item)
        (not
          (action_item_closed ?action_item)
        )
        (variant_a_marker ?action_item)
        (approvals_collected ?action_item)
      )
    :effect
      (and
        (action_item_closed ?action_item)
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
  (:action attach_runbook
    :parameters (?action_item - action_item ?runbook - runbook)
    :precondition
      (and
        (runbook_available ?runbook)
        (action_item_open ?action_item)
      )
    :effect
      (and
        (not
          (runbook_available ?runbook)
        )
        (runbook_attached ?action_item ?runbook)
      )
  )
  (:action collect_approvals
    :parameters (?action_item - action_item ?infrastructure_resource - infrastructure_resource ?application_component - application_component ?approver - approver)
    :precondition
      (and
        (approver_group_association ?action_item ?approver)
        (implemented ?action_item)
        (not
          (review_request_active ?action_item)
        )
        (reserved_infrastructure ?action_item ?infrastructure_resource)
        (implementation_started ?action_item)
        (reserved_component ?action_item ?application_component)
        (not
          (approvals_collected ?action_item)
        )
      )
    :effect
      (and
        (approvals_collected ?action_item)
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
  (:action reserve_external_dependency
    :parameters (?action_item - action_item ?external_dependency - external_dependency)
    :precondition
      (and
        (applicable_external_dependency ?action_item ?external_dependency)
        (action_item_open ?action_item)
        (external_dependency_available ?external_dependency)
      )
    :effect
      (and
        (reserved_external_dependency ?action_item ?external_dependency)
        (not
          (external_dependency_available ?external_dependency)
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
        (not
          (infrastructure_available ?infrastructure_resource)
        )
        (reserved_infrastructure ?action_item ?infrastructure_resource)
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
  (:action initiate_execution
    :parameters (?action_item - action_item ?change_request - change_request_plan ?infrastructure_resource - infrastructure_resource ?application_component - application_component)
    :precondition
      (and
        (has_assignment ?action_item)
        (change_request_available ?change_request)
        (applicable_change_request ?action_item ?change_request)
        (not
          (implementation_started ?action_item)
        )
        (reserved_component ?action_item ?application_component)
        (reserved_infrastructure ?action_item ?infrastructure_resource)
      )
    :effect
      (and
        (linked_change_request ?action_item ?change_request)
        (not
          (change_request_available ?change_request)
        )
        (implementation_started ?action_item)
      )
  )
  (:action post_approval_mark_execution_scheduled
    :parameters (?action_item - action_item ?infrastructure_resource - infrastructure_resource ?application_component - application_component)
    :precondition
      (and
        (reserved_infrastructure ?action_item ?infrastructure_resource)
        (approvals_collected ?action_item)
        (reserved_component ?action_item ?application_component)
        (review_request_active ?action_item)
      )
    :effect
      (and
        (not
          (implementation_recorded ?action_item)
        )
        (not
          (review_request_active ?action_item)
        )
        (not
          (implemented ?action_item)
        )
        (scheduled_for_execution ?action_item)
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
  (:action start_automation_runbook
    :parameters (?action_item - action_item ?runbook - runbook ?automation_tool - automation_tool)
    :precondition
      (and
        (not
          (implemented ?action_item)
        )
        (has_assignment ?action_item)
        (automation_tool_available ?automation_tool)
        (runbook_attached ?action_item ?runbook)
        (readiness_confirmed ?action_item)
      )
    :effect
      (and
        (not
          (review_request_active ?action_item)
        )
        (implemented ?action_item)
      )
  )
  (:action close_action_item_with_automation
    :parameters (?action_item - action_item)
    :precondition
      (and
        (action_item_open ?action_item)
        (variant_b_marker ?action_item)
        (automation_completed ?action_item)
        (has_assignment ?action_item)
        (implemented ?action_item)
        (not
          (action_item_closed ?action_item)
        )
        (execution_verified ?action_item)
        (implementation_started ?action_item)
        (approvals_collected ?action_item)
      )
    :effect
      (and
        (action_item_closed ?action_item)
      )
  )
  (:action acknowledge_automation_completion
    :parameters (?action_item - action_item ?runbook - runbook ?automation_tool - automation_tool)
    :precondition
      (and
        (implemented ?action_item)
        (automation_tool_available ?automation_tool)
        (not
          (automation_completed ?action_item)
        )
        (execution_verified ?action_item)
        (action_item_open ?action_item)
        (variant_b_marker ?action_item)
        (runbook_attached ?action_item ?runbook)
      )
    :effect
      (and
        (automation_completed ?action_item)
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
  (:action reserve_vendor_contact
    :parameters (?action_item - action_item ?vendor_contact - vendor_contact)
    :precondition
      (and
        (vendor_contact_available ?vendor_contact)
        (action_item_open ?action_item)
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
  (:action assign_reviewer
    :parameters (?action_item - action_item ?reviewer - reviewer)
    :precondition
      (and
        (not
          (readiness_confirmed ?action_item)
        )
        (action_item_open ?action_item)
        (reviewer_available ?reviewer)
        (has_assignment ?action_item)
      )
    :effect
      (and
        (review_request_active ?action_item)
        (not
          (reviewer_available ?reviewer)
        )
        (readiness_confirmed ?action_item)
      )
  )
  (:action initiate_external_execution
    :parameters (?action_item - action_item ?change_request - change_request_plan ?external_dependency - external_dependency ?test_environment - test_environment)
    :precondition
      (and
        (test_environment_available ?test_environment)
        (compatible_test_environment ?action_item ?test_environment)
        (not
          (implementation_started ?action_item)
        )
        (has_assignment ?action_item)
        (change_request_available ?change_request)
        (applicable_change_request ?action_item ?change_request)
        (reserved_external_dependency ?action_item ?external_dependency)
      )
    :effect
      (and
        (linked_change_request ?action_item ?change_request)
        (not
          (test_environment_available ?test_environment)
        )
        (implementation_recorded ?action_item)
        (not
          (change_request_available ?change_request)
        )
        (review_request_active ?action_item)
        (implementation_started ?action_item)
      )
  )
  (:action mark_execution_verified_by_reviewer
    :parameters (?action_item - action_item ?reviewer - reviewer)
    :precondition
      (and
        (reviewer_available ?reviewer)
        (not
          (review_request_active ?action_item)
        )
        (implemented ?action_item)
        (approvals_collected ?action_item)
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
  (:action unassign_action_item
    :parameters (?action_item - action_item ?assignee - assignee_candidate)
    :precondition
      (and
        (assigned_to ?action_item ?assignee)
        (not
          (approvals_collected ?action_item)
        )
        (not
          (implementation_started ?action_item)
        )
      )
    :effect
      (and
        (not
          (assigned_to ?action_item ?assignee)
        )
        (assignee_available ?assignee)
        (not
          (has_assignment ?action_item)
        )
        (not
          (readiness_confirmed ?action_item)
        )
        (not
          (scheduled_for_execution ?action_item)
        )
        (not
          (implemented ?action_item)
        )
        (not
          (implementation_recorded ?action_item)
        )
        (not
          (review_request_active ?action_item)
        )
      )
  )
  (:action mark_execution_verified_by_runbook
    :parameters (?action_item - action_item ?runbook - runbook)
    :precondition
      (and
        (not
          (execution_verified ?action_item)
        )
        (runbook_attached ?action_item ?runbook)
        (implemented ?action_item)
        (approvals_collected ?action_item)
        (not
          (review_request_active ?action_item)
        )
      )
    :effect
      (and
        (execution_verified ?action_item)
      )
  )
  (:action close_action_item_with_change_ticket
    :parameters (?action_item - action_item ?change_ticket - change_ticket_record)
    :precondition
      (and
        (execution_verified ?action_item)
        (approvals_collected ?action_item)
        (implementation_started ?action_item)
        (change_ticket_associated ?action_item ?change_ticket)
        (implemented ?action_item)
        (has_assignment ?action_item)
        (action_item_open ?action_item)
        (not
          (action_item_closed ?action_item)
        )
        (variant_b_marker ?action_item)
      )
    :effect
      (and
        (action_item_closed ?action_item)
      )
  )
  (:action acknowledge_runbook_assignment
    :parameters (?action_item - action_item ?runbook - runbook)
    :precondition
      (and
        (action_item_open ?action_item)
        (has_assignment ?action_item)
        (not
          (readiness_confirmed ?action_item)
        )
        (runbook_attached ?action_item ?runbook)
      )
    :effect
      (and
        (readiness_confirmed ?action_item)
      )
  )
  (:action assign_action_item
    :parameters (?action_item - action_item ?assignee - assignee_candidate)
    :precondition
      (and
        (not
          (has_assignment ?action_item)
        )
        (action_item_open ?action_item)
        (assignee_available ?assignee)
        (eligible_assignee ?action_item ?assignee)
      )
    :effect
      (and
        (has_assignment ?action_item)
        (not
          (assignee_available ?assignee)
        )
        (assigned_to ?action_item ?assignee)
      )
  )
  (:action execute_runbook_via_automation
    :parameters (?action_item - action_item ?runbook - runbook ?automation_tool - automation_tool)
    :precondition
      (and
        (has_assignment ?action_item)
        (not
          (implemented ?action_item)
        )
        (runbook_attached ?action_item ?runbook)
        (approvals_collected ?action_item)
        (automation_tool_available ?automation_tool)
        (scheduled_for_execution ?action_item)
      )
    :effect
      (and
        (implemented ?action_item)
      )
  )
  (:action link_variants_to_change_ticket
    :parameters (?action_item_variant_b - action_item_variant_b ?action_item_variant_a - action_item_variant_a ?change_ticket - change_ticket_record)
    :precondition
      (and
        (action_item_open ?action_item_variant_b)
        (change_ticket_reserved_for_item ?action_item_variant_a ?change_ticket)
        (variant_b_marker ?action_item_variant_b)
        (not
          (change_ticket_associated ?action_item_variant_b ?change_ticket)
        )
        (variant_change_ticket_linkable ?action_item_variant_b ?change_ticket)
      )
    :effect
      (and
        (change_ticket_associated ?action_item_variant_b ?change_ticket)
      )
  )
)

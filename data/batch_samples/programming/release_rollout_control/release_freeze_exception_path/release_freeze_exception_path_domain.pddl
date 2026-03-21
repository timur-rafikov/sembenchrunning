(define (domain release_freeze_exception_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types release - object promotion_wave - object environment - object configuration_item - object service_component - object integration_dependency - object notification_channel - object approver - object artifact_build - object qa_check - object monitoring_profile - object dependency_ticket - object team_role - object oncall_roster - team_role incident_response_roster - team_role release_stream - release coordinated_release - release)
  (:predicates
    (release_active ?release - release)
    (release_reserved_wave ?release - release ?promotion_wave - promotion_wave)
    (release_has_reservation ?release - release)
    (release_acknowledged ?release - release)
    (release_prevalidated ?release - release)
    (release_component_bound ?release - release ?service_component - service_component)
    (release_configuration_bound ?release - release ?configuration_item - configuration_item)
    (release_integration_bound ?release - release ?integration_dependency - integration_dependency)
    (release_dependency_bound ?release - release ?dependency_ticket - dependency_ticket)
    (release_deployment_scheduled ?release - release ?environment - environment)
    (release_deployment_executed ?release - release)
    (release_final_checks_ready ?release - release)
    (release_acknowledgements_collected ?release - release)
    (release_cleared_freeze_exception ?release - release)
    (release_approver_consumed ?release - release)
    (release_final_approval_granted ?release - release)
    (coordinated_release_pinned_artifact ?release - release ?artifact_build - artifact_build)
    (coordinated_release_artifact_pinning_confirmed ?release - release ?artifact_build - artifact_build)
    (cross_release_constraints_recorded ?release - release)
    (promotion_wave_available ?promotion_wave - promotion_wave)
    (environment_available ?environment - environment)
    (component_available ?service_component - service_component)
    (configuration_item_available ?configuration_item - configuration_item)
    (integration_dependency_available ?integration_dependency - integration_dependency)
    (notification_channel_available ?notification_channel - notification_channel)
    (approver_available ?approver - approver)
    (artifact_available ?artifact_build - artifact_build)
    (qa_check_available ?qa_check - qa_check)
    (monitoring_profile_available ?monitoring_profile - monitoring_profile)
    (dependency_ticket_open ?dependency_ticket - dependency_ticket)
    (release_wave_eligible ?release - release ?promotion_wave - promotion_wave)
    (release_environment_target ?release - release ?environment - environment)
    (release_component_required ?release - release ?service_component - service_component)
    (release_configuration_required ?release - release ?configuration_item - configuration_item)
    (release_integration_dependency_required ?release - release ?integration_dependency - integration_dependency)
    (release_monitoring_profile_required ?release - release ?monitoring_profile - monitoring_profile)
    (release_dependency_ticket_required ?release - release ?dependency_ticket - dependency_ticket)
    (release_roster_assigned ?release - release ?team_role - team_role)
    (release_artifact_conflict ?release - release ?artifact_build - artifact_build)
    (release_eligible_stream_a ?release - release)
    (release_eligible_stream_b ?release - release)
    (release_notification_channel_registered ?release - release ?notification_channel - notification_channel)
    (release_monitoring_attached ?release - release)
    (release_artifact_association ?release - release ?artifact_build - artifact_build)
  )
  (:action register_release
    :parameters (?release - release)
    :precondition
      (and
        (not
          (release_active ?release)
        )
        (not
          (release_cleared_freeze_exception ?release)
        )
      )
    :effect
      (and
        (release_active ?release)
      )
  )
  (:action reserve_promotion_wave
    :parameters (?release - release ?promotion_wave - promotion_wave)
    :precondition
      (and
        (release_active ?release)
        (promotion_wave_available ?promotion_wave)
        (release_wave_eligible ?release ?promotion_wave)
        (not
          (release_has_reservation ?release)
        )
      )
    :effect
      (and
        (release_reserved_wave ?release ?promotion_wave)
        (release_has_reservation ?release)
        (not
          (promotion_wave_available ?promotion_wave)
        )
      )
  )
  (:action unreserve_promotion_wave
    :parameters (?release - release ?promotion_wave - promotion_wave)
    :precondition
      (and
        (release_reserved_wave ?release ?promotion_wave)
        (not
          (release_deployment_executed ?release)
        )
        (not
          (release_final_checks_ready ?release)
        )
      )
    :effect
      (and
        (not
          (release_reserved_wave ?release ?promotion_wave)
        )
        (not
          (release_has_reservation ?release)
        )
        (not
          (release_acknowledged ?release)
        )
        (not
          (release_prevalidated ?release)
        )
        (not
          (release_approver_consumed ?release)
        )
        (not
          (release_final_approval_granted ?release)
        )
        (not
          (release_monitoring_attached ?release)
        )
        (promotion_wave_available ?promotion_wave)
      )
  )
  (:action register_notification_channel
    :parameters (?release - release ?notification_channel - notification_channel)
    :precondition
      (and
        (release_active ?release)
        (notification_channel_available ?notification_channel)
      )
    :effect
      (and
        (release_notification_channel_registered ?release ?notification_channel)
        (not
          (notification_channel_available ?notification_channel)
        )
      )
  )
  (:action unregister_notification_channel
    :parameters (?release - release ?notification_channel - notification_channel)
    :precondition
      (and
        (release_notification_channel_registered ?release ?notification_channel)
      )
    :effect
      (and
        (notification_channel_available ?notification_channel)
        (not
          (release_notification_channel_registered ?release ?notification_channel)
        )
      )
  )
  (:action acknowledge_notification_channel
    :parameters (?release - release ?notification_channel - notification_channel)
    :precondition
      (and
        (release_active ?release)
        (release_has_reservation ?release)
        (release_notification_channel_registered ?release ?notification_channel)
        (not
          (release_acknowledged ?release)
        )
      )
    :effect
      (and
        (release_acknowledged ?release)
      )
  )
  (:action record_approver_acknowledgement
    :parameters (?release - release ?approver - approver)
    :precondition
      (and
        (release_active ?release)
        (release_has_reservation ?release)
        (approver_available ?approver)
        (not
          (release_acknowledged ?release)
        )
      )
    :effect
      (and
        (release_acknowledged ?release)
        (release_approver_consumed ?release)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action apply_qa_check
    :parameters (?release - release ?notification_channel - notification_channel ?qa_check - qa_check)
    :precondition
      (and
        (release_acknowledged ?release)
        (release_has_reservation ?release)
        (release_notification_channel_registered ?release ?notification_channel)
        (qa_check_available ?qa_check)
        (not
          (release_prevalidated ?release)
        )
      )
    :effect
      (and
        (release_prevalidated ?release)
        (not
          (release_approver_consumed ?release)
        )
      )
  )
  (:action bind_artifact_to_release
    :parameters (?release - release ?artifact_build - artifact_build)
    :precondition
      (and
        (release_has_reservation ?release)
        (coordinated_release_artifact_pinning_confirmed ?release ?artifact_build)
        (not
          (release_prevalidated ?release)
        )
      )
    :effect
      (and
        (release_prevalidated ?release)
        (not
          (release_approver_consumed ?release)
        )
      )
  )
  (:action bind_service_component
    :parameters (?release - release ?service_component - service_component)
    :precondition
      (and
        (release_active ?release)
        (component_available ?service_component)
        (release_component_required ?release ?service_component)
      )
    :effect
      (and
        (release_component_bound ?release ?service_component)
        (not
          (component_available ?service_component)
        )
      )
  )
  (:action unbind_service_component
    :parameters (?release - release ?service_component - service_component)
    :precondition
      (and
        (release_component_bound ?release ?service_component)
      )
    :effect
      (and
        (component_available ?service_component)
        (not
          (release_component_bound ?release ?service_component)
        )
      )
  )
  (:action bind_configuration_item
    :parameters (?release - release ?configuration_item - configuration_item)
    :precondition
      (and
        (release_active ?release)
        (configuration_item_available ?configuration_item)
        (release_configuration_required ?release ?configuration_item)
      )
    :effect
      (and
        (release_configuration_bound ?release ?configuration_item)
        (not
          (configuration_item_available ?configuration_item)
        )
      )
  )
  (:action unbind_configuration_item
    :parameters (?release - release ?configuration_item - configuration_item)
    :precondition
      (and
        (release_configuration_bound ?release ?configuration_item)
      )
    :effect
      (and
        (configuration_item_available ?configuration_item)
        (not
          (release_configuration_bound ?release ?configuration_item)
        )
      )
  )
  (:action bind_integration_dependency
    :parameters (?release - release ?integration_dependency - integration_dependency)
    :precondition
      (and
        (release_active ?release)
        (integration_dependency_available ?integration_dependency)
        (release_integration_dependency_required ?release ?integration_dependency)
      )
    :effect
      (and
        (release_integration_bound ?release ?integration_dependency)
        (not
          (integration_dependency_available ?integration_dependency)
        )
      )
  )
  (:action unbind_integration_dependency
    :parameters (?release - release ?integration_dependency - integration_dependency)
    :precondition
      (and
        (release_integration_bound ?release ?integration_dependency)
      )
    :effect
      (and
        (integration_dependency_available ?integration_dependency)
        (not
          (release_integration_bound ?release ?integration_dependency)
        )
      )
  )
  (:action bind_dependency_ticket
    :parameters (?release - release ?dependency_ticket - dependency_ticket)
    :precondition
      (and
        (release_active ?release)
        (dependency_ticket_open ?dependency_ticket)
        (release_dependency_ticket_required ?release ?dependency_ticket)
      )
    :effect
      (and
        (release_dependency_bound ?release ?dependency_ticket)
        (not
          (dependency_ticket_open ?dependency_ticket)
        )
      )
  )
  (:action unbind_dependency_ticket
    :parameters (?release - release ?dependency_ticket - dependency_ticket)
    :precondition
      (and
        (release_dependency_bound ?release ?dependency_ticket)
      )
    :effect
      (and
        (dependency_ticket_open ?dependency_ticket)
        (not
          (release_dependency_bound ?release ?dependency_ticket)
        )
      )
  )
  (:action schedule_deployment_to_environment
    :parameters (?release - release ?environment - environment ?service_component - service_component ?configuration_item - configuration_item)
    :precondition
      (and
        (release_has_reservation ?release)
        (release_component_bound ?release ?service_component)
        (release_configuration_bound ?release ?configuration_item)
        (environment_available ?environment)
        (release_environment_target ?release ?environment)
        (not
          (release_deployment_executed ?release)
        )
      )
    :effect
      (and
        (release_deployment_scheduled ?release ?environment)
        (release_deployment_executed ?release)
        (not
          (environment_available ?environment)
        )
      )
  )
  (:action execute_deployment_with_monitoring
    :parameters (?release - release ?environment - environment ?integration_dependency - integration_dependency ?monitoring_profile - monitoring_profile)
    :precondition
      (and
        (release_has_reservation ?release)
        (release_integration_bound ?release ?integration_dependency)
        (monitoring_profile_available ?monitoring_profile)
        (environment_available ?environment)
        (release_environment_target ?release ?environment)
        (release_monitoring_profile_required ?release ?monitoring_profile)
        (not
          (release_deployment_executed ?release)
        )
      )
    :effect
      (and
        (release_deployment_scheduled ?release ?environment)
        (release_deployment_executed ?release)
        (release_monitoring_attached ?release)
        (release_approver_consumed ?release)
        (not
          (environment_available ?environment)
        )
        (not
          (monitoring_profile_available ?monitoring_profile)
        )
      )
  )
  (:action finalize_deployment
    :parameters (?release - release ?service_component - service_component ?configuration_item - configuration_item)
    :precondition
      (and
        (release_deployment_executed ?release)
        (release_monitoring_attached ?release)
        (release_component_bound ?release ?service_component)
        (release_configuration_bound ?release ?configuration_item)
      )
    :effect
      (and
        (not
          (release_monitoring_attached ?release)
        )
        (not
          (release_approver_consumed ?release)
        )
      )
  )
  (:action run_final_validation
    :parameters (?release - release ?service_component - service_component ?configuration_item - configuration_item ?oncall_roster - oncall_roster)
    :precondition
      (and
        (release_prevalidated ?release)
        (release_deployment_executed ?release)
        (release_component_bound ?release ?service_component)
        (release_configuration_bound ?release ?configuration_item)
        (release_roster_assigned ?release ?oncall_roster)
        (not
          (release_approver_consumed ?release)
        )
        (not
          (release_final_checks_ready ?release)
        )
      )
    :effect
      (and
        (release_final_checks_ready ?release)
      )
  )
  (:action run_final_validation_with_incident_roster
    :parameters (?release - release ?integration_dependency - integration_dependency ?dependency_ticket - dependency_ticket ?incident_response_roster - incident_response_roster)
    :precondition
      (and
        (release_prevalidated ?release)
        (release_deployment_executed ?release)
        (release_integration_bound ?release ?integration_dependency)
        (release_dependency_bound ?release ?dependency_ticket)
        (release_roster_assigned ?release ?incident_response_roster)
        (not
          (release_final_checks_ready ?release)
        )
      )
    :effect
      (and
        (release_final_checks_ready ?release)
        (release_approver_consumed ?release)
      )
  )
  (:action apply_final_approval
    :parameters (?release - release ?service_component - service_component ?configuration_item - configuration_item)
    :precondition
      (and
        (release_final_checks_ready ?release)
        (release_approver_consumed ?release)
        (release_component_bound ?release ?service_component)
        (release_configuration_bound ?release ?configuration_item)
      )
    :effect
      (and
        (release_final_approval_granted ?release)
        (not
          (release_approver_consumed ?release)
        )
        (not
          (release_prevalidated ?release)
        )
        (not
          (release_monitoring_attached ?release)
        )
      )
  )
  (:action reapply_qa_after_final_approval
    :parameters (?release - release ?notification_channel - notification_channel ?qa_check - qa_check)
    :precondition
      (and
        (release_final_approval_granted ?release)
        (release_final_checks_ready ?release)
        (release_has_reservation ?release)
        (release_notification_channel_registered ?release ?notification_channel)
        (qa_check_available ?qa_check)
        (not
          (release_prevalidated ?release)
        )
      )
    :effect
      (and
        (release_prevalidated ?release)
      )
  )
  (:action record_channel_acknowledgement
    :parameters (?release - release ?notification_channel - notification_channel)
    :precondition
      (and
        (release_final_checks_ready ?release)
        (release_prevalidated ?release)
        (not
          (release_approver_consumed ?release)
        )
        (release_notification_channel_registered ?release ?notification_channel)
        (not
          (release_acknowledgements_collected ?release)
        )
      )
    :effect
      (and
        (release_acknowledgements_collected ?release)
      )
  )
  (:action record_approver_acknowledgement_final
    :parameters (?release - release ?approver - approver)
    :precondition
      (and
        (release_final_checks_ready ?release)
        (release_prevalidated ?release)
        (not
          (release_approver_consumed ?release)
        )
        (approver_available ?approver)
        (not
          (release_acknowledgements_collected ?release)
        )
      )
    :effect
      (and
        (release_acknowledgements_collected ?release)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action pin_artifact_for_release
    :parameters (?release - release ?artifact_build - artifact_build)
    :precondition
      (and
        (release_acknowledgements_collected ?release)
        (artifact_available ?artifact_build)
        (release_artifact_association ?release ?artifact_build)
      )
    :effect
      (and
        (release_artifact_conflict ?release ?artifact_build)
        (not
          (artifact_available ?artifact_build)
        )
      )
  )
  (:action coordinate_cross_release_artifact_pinning
    :parameters (?release_coordinator - coordinated_release ?release_stream - release_stream ?artifact_build - artifact_build)
    :precondition
      (and
        (release_active ?release_coordinator)
        (release_eligible_stream_b ?release_coordinator)
        (coordinated_release_pinned_artifact ?release_coordinator ?artifact_build)
        (release_artifact_conflict ?release_stream ?artifact_build)
        (not
          (coordinated_release_artifact_pinning_confirmed ?release_coordinator ?artifact_build)
        )
      )
    :effect
      (and
        (coordinated_release_artifact_pinning_confirmed ?release_coordinator ?artifact_build)
      )
  )
  (:action record_cross_release_constraint
    :parameters (?release - release ?notification_channel - notification_channel ?qa_check - qa_check)
    :precondition
      (and
        (release_active ?release)
        (release_eligible_stream_b ?release)
        (release_prevalidated ?release)
        (release_acknowledgements_collected ?release)
        (release_notification_channel_registered ?release ?notification_channel)
        (qa_check_available ?qa_check)
        (not
          (cross_release_constraints_recorded ?release)
        )
      )
    :effect
      (and
        (cross_release_constraints_recorded ?release)
      )
  )
  (:action mark_release_cleared_from_freeze
    :parameters (?release - release)
    :precondition
      (and
        (release_eligible_stream_a ?release)
        (release_active ?release)
        (release_has_reservation ?release)
        (release_deployment_executed ?release)
        (release_final_checks_ready ?release)
        (release_acknowledgements_collected ?release)
        (release_prevalidated ?release)
        (not
          (release_cleared_freeze_exception ?release)
        )
      )
    :effect
      (and
        (release_cleared_freeze_exception ?release)
      )
  )
  (:action mark_release_cleared_with_artifact_pin
    :parameters (?release - release ?artifact_build - artifact_build)
    :precondition
      (and
        (release_eligible_stream_b ?release)
        (release_active ?release)
        (release_has_reservation ?release)
        (release_deployment_executed ?release)
        (release_final_checks_ready ?release)
        (release_acknowledgements_collected ?release)
        (release_prevalidated ?release)
        (coordinated_release_artifact_pinning_confirmed ?release ?artifact_build)
        (not
          (release_cleared_freeze_exception ?release)
        )
      )
    :effect
      (and
        (release_cleared_freeze_exception ?release)
      )
  )
  (:action mark_release_cleared_with_cross_release_coordination
    :parameters (?release - release)
    :precondition
      (and
        (release_eligible_stream_b ?release)
        (release_active ?release)
        (release_has_reservation ?release)
        (release_deployment_executed ?release)
        (release_final_checks_ready ?release)
        (release_acknowledgements_collected ?release)
        (release_prevalidated ?release)
        (cross_release_constraints_recorded ?release)
        (not
          (release_cleared_freeze_exception ?release)
        )
      )
    :effect
      (and
        (release_cleared_freeze_exception ?release)
      )
  )
)

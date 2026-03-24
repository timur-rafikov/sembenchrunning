(define (domain external_rest_api_write_integration)
  (:requirements :strips :typing :negative-preconditions)
  (:types component - object resource_pool - object config_item - object domain_resource_type - object domain_resource - domain_resource_type api_key - component payload_builder - component authenticator - component header_template - component middleware_module - component callback_handler - component timeout_policy - component retry_policy - component attachment - resource_pool serialized_payload - resource_pool audit_tag - resource_pool network_route - config_item upstream_endpoint - config_item outbound_request - config_item worker_group - domain_resource coordinator_group - domain_resource worker_a - worker_group worker_b - worker_group integration_coordinator - coordinator_group)
  (:predicates
    (domain_resource_registered ?domain_resource - domain_resource)
    (domain_resource_prepared ?domain_resource - domain_resource)
    (domain_resource_credential_bound ?domain_resource - domain_resource)
    (resource_persisted ?domain_resource - domain_resource)
    (dispatch_confirmed_for_entity ?domain_resource - domain_resource)
    (domain_resource_write_confirmed ?domain_resource - domain_resource)
    (api_key_available ?api_credential - api_key)
    (resource_has_api_key ?domain_resource - domain_resource ?api_credential - api_key)
    (payload_builder_available ?payload_builder - payload_builder)
    (payload_builder_assigned ?domain_resource - domain_resource ?payload_builder - payload_builder)
    (authenticator_available ?authenticator - authenticator)
    (authenticator_assigned ?domain_resource - domain_resource ?authenticator - authenticator)
    (attachment_available ?attachment - attachment)
    (worker_a_attachment_attached ?worker_a - worker_a ?attachment - attachment)
    (worker_b_attachment_attached ?worker_b - worker_b ?attachment - attachment)
    (worker_assigned_route ?worker_a - worker_a ?network_route - network_route)
    (route_reserved ?network_route - network_route)
    (route_has_attachment ?network_route - network_route)
    (worker_a_ready ?worker_a - worker_a)
    (worker_b_assigned_upstream ?worker_b - worker_b ?upstream_endpoint - upstream_endpoint)
    (upstream_reserved ?upstream_endpoint - upstream_endpoint)
    (upstream_has_attachment ?upstream_endpoint - upstream_endpoint)
    (worker_b_ready ?worker_b - worker_b)
    (outbound_request_slot_available ?outbound_request - outbound_request)
    (outbound_request_initialized ?outbound_request - outbound_request)
    (outbound_request_route_link ?outbound_request - outbound_request ?network_route - network_route)
    (outbound_request_upstream_link ?outbound_request - outbound_request ?upstream_endpoint - upstream_endpoint)
    (outbound_request_header_attached ?outbound_request - outbound_request)
    (outbound_request_middleware_attached ?outbound_request - outbound_request)
    (outbound_request_ready_for_dispatch ?outbound_request - outbound_request)
    (coordinator_has_worker_a ?integration_coordinator - integration_coordinator ?worker_a - worker_a)
    (coordinator_has_worker_b ?integration_coordinator - integration_coordinator ?worker_b - worker_b)
    (coordinator_manages_request ?integration_coordinator - integration_coordinator ?outbound_request - outbound_request)
    (serialized_payload_available ?serialized_payload - serialized_payload)
    (coordinator_has_serialized_payload ?integration_coordinator - integration_coordinator ?serialized_payload - serialized_payload)
    (serialized_payload_staged ?serialized_payload - serialized_payload)
    (serialized_payload_bound_to_request ?serialized_payload - serialized_payload ?outbound_request - outbound_request)
    (coordinator_payload_ready ?integration_coordinator - integration_coordinator)
    (coordinator_payload_committed ?integration_coordinator - integration_coordinator)
    (coordinator_middleware_applied ?integration_coordinator - integration_coordinator)
    (coordinator_header_attached ?integration_coordinator - integration_coordinator)
    (coordinator_header_applied ?integration_coordinator - integration_coordinator)
    (coordinator_middleware_ready ?integration_coordinator - integration_coordinator)
    (coordinator_orchestration_complete ?integration_coordinator - integration_coordinator)
    (audit_tag_available ?audit_tag - audit_tag)
    (coordinator_has_audit_tag ?integration_coordinator - integration_coordinator ?audit_tag - audit_tag)
    (coordinator_audit_attached ?integration_coordinator - integration_coordinator)
    (coordinator_auth_applied ?integration_coordinator - integration_coordinator)
    (coordinator_retry_applied ?integration_coordinator - integration_coordinator)
    (header_template_available ?header_template - header_template)
    (coordinator_header_template_bound ?integration_coordinator - integration_coordinator ?header_template - header_template)
    (middleware_module_available ?middleware_module - middleware_module)
    (coordinator_middleware_bound ?integration_coordinator - integration_coordinator ?middleware_module - middleware_module)
    (timeout_policy_available ?timeout_policy - timeout_policy)
    (coordinator_timeout_policy_bound ?integration_coordinator - integration_coordinator ?timeout_policy - timeout_policy)
    (retry_policy_available ?retry_policy - retry_policy)
    (coordinator_retry_policy_bound ?integration_coordinator - integration_coordinator ?retry_policy - retry_policy)
    (callback_handler_available ?callback_handler - callback_handler)
    (resource_callback_bound ?domain_resource - domain_resource ?callback_handler - callback_handler)
    (worker_a_initialized ?worker_a - worker_a)
    (worker_b_initialized ?worker_b - worker_b)
    (coordinator_dispatch_ready ?integration_coordinator - integration_coordinator)
  )
  (:action register_domain_resource
    :parameters (?domain_resource - domain_resource)
    :precondition
      (and
        (not
          (domain_resource_registered ?domain_resource)
        )
        (not
          (resource_persisted ?domain_resource)
        )
      )
    :effect (domain_resource_registered ?domain_resource)
  )
  (:action allocate_api_key_to_resource
    :parameters (?domain_resource - domain_resource ?api_credential - api_key)
    :precondition
      (and
        (domain_resource_registered ?domain_resource)
        (not
          (domain_resource_credential_bound ?domain_resource)
        )
        (api_key_available ?api_credential)
      )
    :effect
      (and
        (domain_resource_credential_bound ?domain_resource)
        (resource_has_api_key ?domain_resource ?api_credential)
        (not
          (api_key_available ?api_credential)
        )
      )
  )
  (:action assign_payload_builder_to_resource
    :parameters (?domain_resource - domain_resource ?payload_builder - payload_builder)
    :precondition
      (and
        (domain_resource_registered ?domain_resource)
        (domain_resource_credential_bound ?domain_resource)
        (payload_builder_available ?payload_builder)
      )
    :effect
      (and
        (payload_builder_assigned ?domain_resource ?payload_builder)
        (not
          (payload_builder_available ?payload_builder)
        )
      )
  )
  (:action confirm_resource_prepared
    :parameters (?domain_resource - domain_resource ?payload_builder - payload_builder)
    :precondition
      (and
        (domain_resource_registered ?domain_resource)
        (domain_resource_credential_bound ?domain_resource)
        (payload_builder_assigned ?domain_resource ?payload_builder)
        (not
          (domain_resource_prepared ?domain_resource)
        )
      )
    :effect (domain_resource_prepared ?domain_resource)
  )
  (:action release_payload_builder
    :parameters (?domain_resource - domain_resource ?payload_builder - payload_builder)
    :precondition
      (and
        (payload_builder_assigned ?domain_resource ?payload_builder)
      )
    :effect
      (and
        (payload_builder_available ?payload_builder)
        (not
          (payload_builder_assigned ?domain_resource ?payload_builder)
        )
      )
  )
  (:action assign_authenticator_to_resource
    :parameters (?domain_resource - domain_resource ?authenticator - authenticator)
    :precondition
      (and
        (domain_resource_prepared ?domain_resource)
        (authenticator_available ?authenticator)
      )
    :effect
      (and
        (authenticator_assigned ?domain_resource ?authenticator)
        (not
          (authenticator_available ?authenticator)
        )
      )
  )
  (:action unassign_authenticator_from_resource
    :parameters (?domain_resource - domain_resource ?authenticator - authenticator)
    :precondition
      (and
        (authenticator_assigned ?domain_resource ?authenticator)
      )
    :effect
      (and
        (authenticator_available ?authenticator)
        (not
          (authenticator_assigned ?domain_resource ?authenticator)
        )
      )
  )
  (:action attach_timeout_policy_to_coordinator
    :parameters (?integration_coordinator - integration_coordinator ?timeout_policy - timeout_policy)
    :precondition
      (and
        (domain_resource_prepared ?integration_coordinator)
        (timeout_policy_available ?timeout_policy)
      )
    :effect
      (and
        (coordinator_timeout_policy_bound ?integration_coordinator ?timeout_policy)
        (not
          (timeout_policy_available ?timeout_policy)
        )
      )
  )
  (:action detach_timeout_policy_from_coordinator
    :parameters (?integration_coordinator - integration_coordinator ?timeout_policy - timeout_policy)
    :precondition
      (and
        (coordinator_timeout_policy_bound ?integration_coordinator ?timeout_policy)
      )
    :effect
      (and
        (timeout_policy_available ?timeout_policy)
        (not
          (coordinator_timeout_policy_bound ?integration_coordinator ?timeout_policy)
        )
      )
  )
  (:action attach_retry_policy_to_coordinator
    :parameters (?integration_coordinator - integration_coordinator ?retry_policy - retry_policy)
    :precondition
      (and
        (domain_resource_prepared ?integration_coordinator)
        (retry_policy_available ?retry_policy)
      )
    :effect
      (and
        (coordinator_retry_policy_bound ?integration_coordinator ?retry_policy)
        (not
          (retry_policy_available ?retry_policy)
        )
      )
  )
  (:action detach_retry_policy_from_coordinator
    :parameters (?integration_coordinator - integration_coordinator ?retry_policy - retry_policy)
    :precondition
      (and
        (coordinator_retry_policy_bound ?integration_coordinator ?retry_policy)
      )
    :effect
      (and
        (retry_policy_available ?retry_policy)
        (not
          (coordinator_retry_policy_bound ?integration_coordinator ?retry_policy)
        )
      )
  )
  (:action reserve_network_route_for_worker
    :parameters (?worker_a - worker_a ?network_route - network_route ?payload_builder - payload_builder)
    :precondition
      (and
        (domain_resource_prepared ?worker_a)
        (payload_builder_assigned ?worker_a ?payload_builder)
        (worker_assigned_route ?worker_a ?network_route)
        (not
          (route_reserved ?network_route)
        )
        (not
          (route_has_attachment ?network_route)
        )
      )
    :effect (route_reserved ?network_route)
  )
  (:action initialize_worker_with_route_and_authenticator
    :parameters (?worker_a - worker_a ?network_route - network_route ?authenticator - authenticator)
    :precondition
      (and
        (domain_resource_prepared ?worker_a)
        (authenticator_assigned ?worker_a ?authenticator)
        (worker_assigned_route ?worker_a ?network_route)
        (route_reserved ?network_route)
        (not
          (worker_a_initialized ?worker_a)
        )
      )
    :effect
      (and
        (worker_a_initialized ?worker_a)
        (worker_a_ready ?worker_a)
      )
  )
  (:action attach_attachment_to_worker_route
    :parameters (?worker_a - worker_a ?network_route - network_route ?attachment - attachment)
    :precondition
      (and
        (domain_resource_prepared ?worker_a)
        (worker_assigned_route ?worker_a ?network_route)
        (attachment_available ?attachment)
        (not
          (worker_a_initialized ?worker_a)
        )
      )
    :effect
      (and
        (route_has_attachment ?network_route)
        (worker_a_initialized ?worker_a)
        (worker_a_attachment_attached ?worker_a ?attachment)
        (not
          (attachment_available ?attachment)
        )
      )
  )
  (:action finalize_worker_route_with_attachment
    :parameters (?worker_a - worker_a ?network_route - network_route ?payload_builder - payload_builder ?attachment - attachment)
    :precondition
      (and
        (domain_resource_prepared ?worker_a)
        (payload_builder_assigned ?worker_a ?payload_builder)
        (worker_assigned_route ?worker_a ?network_route)
        (route_has_attachment ?network_route)
        (worker_a_attachment_attached ?worker_a ?attachment)
        (not
          (worker_a_ready ?worker_a)
        )
      )
    :effect
      (and
        (route_reserved ?network_route)
        (worker_a_ready ?worker_a)
        (attachment_available ?attachment)
        (not
          (worker_a_attachment_attached ?worker_a ?attachment)
        )
      )
  )
  (:action reserve_upstream_endpoint_for_worker_b
    :parameters (?worker_b - worker_b ?upstream_endpoint - upstream_endpoint ?payload_builder - payload_builder)
    :precondition
      (and
        (domain_resource_prepared ?worker_b)
        (payload_builder_assigned ?worker_b ?payload_builder)
        (worker_b_assigned_upstream ?worker_b ?upstream_endpoint)
        (not
          (upstream_reserved ?upstream_endpoint)
        )
        (not
          (upstream_has_attachment ?upstream_endpoint)
        )
      )
    :effect (upstream_reserved ?upstream_endpoint)
  )
  (:action initialize_worker_b_with_upstream_and_authenticator
    :parameters (?worker_b - worker_b ?upstream_endpoint - upstream_endpoint ?authenticator - authenticator)
    :precondition
      (and
        (domain_resource_prepared ?worker_b)
        (authenticator_assigned ?worker_b ?authenticator)
        (worker_b_assigned_upstream ?worker_b ?upstream_endpoint)
        (upstream_reserved ?upstream_endpoint)
        (not
          (worker_b_initialized ?worker_b)
        )
      )
    :effect
      (and
        (worker_b_initialized ?worker_b)
        (worker_b_ready ?worker_b)
      )
  )
  (:action attach_attachment_to_worker_b_upstream
    :parameters (?worker_b - worker_b ?upstream_endpoint - upstream_endpoint ?attachment - attachment)
    :precondition
      (and
        (domain_resource_prepared ?worker_b)
        (worker_b_assigned_upstream ?worker_b ?upstream_endpoint)
        (attachment_available ?attachment)
        (not
          (worker_b_initialized ?worker_b)
        )
      )
    :effect
      (and
        (upstream_has_attachment ?upstream_endpoint)
        (worker_b_initialized ?worker_b)
        (worker_b_attachment_attached ?worker_b ?attachment)
        (not
          (attachment_available ?attachment)
        )
      )
  )
  (:action finalize_worker_b_upstream_with_attachment
    :parameters (?worker_b - worker_b ?upstream_endpoint - upstream_endpoint ?payload_builder - payload_builder ?attachment - attachment)
    :precondition
      (and
        (domain_resource_prepared ?worker_b)
        (payload_builder_assigned ?worker_b ?payload_builder)
        (worker_b_assigned_upstream ?worker_b ?upstream_endpoint)
        (upstream_has_attachment ?upstream_endpoint)
        (worker_b_attachment_attached ?worker_b ?attachment)
        (not
          (worker_b_ready ?worker_b)
        )
      )
    :effect
      (and
        (upstream_reserved ?upstream_endpoint)
        (worker_b_ready ?worker_b)
        (attachment_available ?attachment)
        (not
          (worker_b_attachment_attached ?worker_b ?attachment)
        )
      )
  )
  (:action assemble_outbound_request
    :parameters (?worker_a - worker_a ?worker_b - worker_b ?network_route - network_route ?upstream_endpoint - upstream_endpoint ?outbound_request - outbound_request)
    :precondition
      (and
        (worker_a_initialized ?worker_a)
        (worker_b_initialized ?worker_b)
        (worker_assigned_route ?worker_a ?network_route)
        (worker_b_assigned_upstream ?worker_b ?upstream_endpoint)
        (route_reserved ?network_route)
        (upstream_reserved ?upstream_endpoint)
        (worker_a_ready ?worker_a)
        (worker_b_ready ?worker_b)
        (outbound_request_slot_available ?outbound_request)
      )
    :effect
      (and
        (outbound_request_initialized ?outbound_request)
        (outbound_request_route_link ?outbound_request ?network_route)
        (outbound_request_upstream_link ?outbound_request ?upstream_endpoint)
        (not
          (outbound_request_slot_available ?outbound_request)
        )
      )
  )
  (:action assemble_outbound_request_with_header
    :parameters (?worker_a - worker_a ?worker_b - worker_b ?network_route - network_route ?upstream_endpoint - upstream_endpoint ?outbound_request - outbound_request)
    :precondition
      (and
        (worker_a_initialized ?worker_a)
        (worker_b_initialized ?worker_b)
        (worker_assigned_route ?worker_a ?network_route)
        (worker_b_assigned_upstream ?worker_b ?upstream_endpoint)
        (route_has_attachment ?network_route)
        (upstream_reserved ?upstream_endpoint)
        (not
          (worker_a_ready ?worker_a)
        )
        (worker_b_ready ?worker_b)
        (outbound_request_slot_available ?outbound_request)
      )
    :effect
      (and
        (outbound_request_initialized ?outbound_request)
        (outbound_request_route_link ?outbound_request ?network_route)
        (outbound_request_upstream_link ?outbound_request ?upstream_endpoint)
        (outbound_request_header_attached ?outbound_request)
        (not
          (outbound_request_slot_available ?outbound_request)
        )
      )
  )
  (:action assemble_outbound_request_with_middleware
    :parameters (?worker_a - worker_a ?worker_b - worker_b ?network_route - network_route ?upstream_endpoint - upstream_endpoint ?outbound_request - outbound_request)
    :precondition
      (and
        (worker_a_initialized ?worker_a)
        (worker_b_initialized ?worker_b)
        (worker_assigned_route ?worker_a ?network_route)
        (worker_b_assigned_upstream ?worker_b ?upstream_endpoint)
        (route_reserved ?network_route)
        (upstream_has_attachment ?upstream_endpoint)
        (worker_a_ready ?worker_a)
        (not
          (worker_b_ready ?worker_b)
        )
        (outbound_request_slot_available ?outbound_request)
      )
    :effect
      (and
        (outbound_request_initialized ?outbound_request)
        (outbound_request_route_link ?outbound_request ?network_route)
        (outbound_request_upstream_link ?outbound_request ?upstream_endpoint)
        (outbound_request_middleware_attached ?outbound_request)
        (not
          (outbound_request_slot_available ?outbound_request)
        )
      )
  )
  (:action assemble_outbound_request_complete
    :parameters (?worker_a - worker_a ?worker_b - worker_b ?network_route - network_route ?upstream_endpoint - upstream_endpoint ?outbound_request - outbound_request)
    :precondition
      (and
        (worker_a_initialized ?worker_a)
        (worker_b_initialized ?worker_b)
        (worker_assigned_route ?worker_a ?network_route)
        (worker_b_assigned_upstream ?worker_b ?upstream_endpoint)
        (route_has_attachment ?network_route)
        (upstream_has_attachment ?upstream_endpoint)
        (not
          (worker_a_ready ?worker_a)
        )
        (not
          (worker_b_ready ?worker_b)
        )
        (outbound_request_slot_available ?outbound_request)
      )
    :effect
      (and
        (outbound_request_initialized ?outbound_request)
        (outbound_request_route_link ?outbound_request ?network_route)
        (outbound_request_upstream_link ?outbound_request ?upstream_endpoint)
        (outbound_request_header_attached ?outbound_request)
        (outbound_request_middleware_attached ?outbound_request)
        (not
          (outbound_request_slot_available ?outbound_request)
        )
      )
  )
  (:action mark_outbound_request_ready_for_dispatch
    :parameters (?outbound_request - outbound_request ?worker_a - worker_a ?payload_builder - payload_builder)
    :precondition
      (and
        (outbound_request_initialized ?outbound_request)
        (worker_a_initialized ?worker_a)
        (payload_builder_assigned ?worker_a ?payload_builder)
        (not
          (outbound_request_ready_for_dispatch ?outbound_request)
        )
      )
    :effect (outbound_request_ready_for_dispatch ?outbound_request)
  )
  (:action serialize_and_attach_payload
    :parameters (?integration_coordinator - integration_coordinator ?serialized_payload - serialized_payload ?outbound_request - outbound_request)
    :precondition
      (and
        (domain_resource_prepared ?integration_coordinator)
        (coordinator_manages_request ?integration_coordinator ?outbound_request)
        (coordinator_has_serialized_payload ?integration_coordinator ?serialized_payload)
        (serialized_payload_available ?serialized_payload)
        (outbound_request_initialized ?outbound_request)
        (outbound_request_ready_for_dispatch ?outbound_request)
        (not
          (serialized_payload_staged ?serialized_payload)
        )
      )
    :effect
      (and
        (serialized_payload_staged ?serialized_payload)
        (serialized_payload_bound_to_request ?serialized_payload ?outbound_request)
        (not
          (serialized_payload_available ?serialized_payload)
        )
      )
  )
  (:action prepare_coordinator_for_payload_commit
    :parameters (?integration_coordinator - integration_coordinator ?serialized_payload - serialized_payload ?outbound_request - outbound_request ?payload_builder - payload_builder)
    :precondition
      (and
        (domain_resource_prepared ?integration_coordinator)
        (coordinator_has_serialized_payload ?integration_coordinator ?serialized_payload)
        (serialized_payload_staged ?serialized_payload)
        (serialized_payload_bound_to_request ?serialized_payload ?outbound_request)
        (payload_builder_assigned ?integration_coordinator ?payload_builder)
        (not
          (outbound_request_header_attached ?outbound_request)
        )
        (not
          (coordinator_payload_ready ?integration_coordinator)
        )
      )
    :effect (coordinator_payload_ready ?integration_coordinator)
  )
  (:action attach_header_template_to_coordinator
    :parameters (?integration_coordinator - integration_coordinator ?header_template - header_template)
    :precondition
      (and
        (domain_resource_prepared ?integration_coordinator)
        (header_template_available ?header_template)
        (not
          (coordinator_header_attached ?integration_coordinator)
        )
      )
    :effect
      (and
        (coordinator_header_attached ?integration_coordinator)
        (coordinator_header_template_bound ?integration_coordinator ?header_template)
        (not
          (header_template_available ?header_template)
        )
      )
  )
  (:action apply_header_template_and_stage
    :parameters (?integration_coordinator - integration_coordinator ?serialized_payload - serialized_payload ?outbound_request - outbound_request ?payload_builder - payload_builder ?header_template - header_template)
    :precondition
      (and
        (domain_resource_prepared ?integration_coordinator)
        (coordinator_has_serialized_payload ?integration_coordinator ?serialized_payload)
        (serialized_payload_staged ?serialized_payload)
        (serialized_payload_bound_to_request ?serialized_payload ?outbound_request)
        (payload_builder_assigned ?integration_coordinator ?payload_builder)
        (outbound_request_header_attached ?outbound_request)
        (coordinator_header_attached ?integration_coordinator)
        (coordinator_header_template_bound ?integration_coordinator ?header_template)
        (not
          (coordinator_payload_ready ?integration_coordinator)
        )
      )
    :effect
      (and
        (coordinator_payload_ready ?integration_coordinator)
        (coordinator_header_applied ?integration_coordinator)
      )
  )
  (:action apply_timeout_policy_and_stage_commit
    :parameters (?integration_coordinator - integration_coordinator ?timeout_policy - timeout_policy ?authenticator - authenticator ?serialized_payload - serialized_payload ?outbound_request - outbound_request)
    :precondition
      (and
        (coordinator_payload_ready ?integration_coordinator)
        (coordinator_timeout_policy_bound ?integration_coordinator ?timeout_policy)
        (authenticator_assigned ?integration_coordinator ?authenticator)
        (coordinator_has_serialized_payload ?integration_coordinator ?serialized_payload)
        (serialized_payload_bound_to_request ?serialized_payload ?outbound_request)
        (not
          (outbound_request_middleware_attached ?outbound_request)
        )
        (not
          (coordinator_payload_committed ?integration_coordinator)
        )
      )
    :effect (coordinator_payload_committed ?integration_coordinator)
  )
  (:action apply_timeout_and_stage_commit_with_middleware
    :parameters (?integration_coordinator - integration_coordinator ?timeout_policy - timeout_policy ?authenticator - authenticator ?serialized_payload - serialized_payload ?outbound_request - outbound_request)
    :precondition
      (and
        (coordinator_payload_ready ?integration_coordinator)
        (coordinator_timeout_policy_bound ?integration_coordinator ?timeout_policy)
        (authenticator_assigned ?integration_coordinator ?authenticator)
        (coordinator_has_serialized_payload ?integration_coordinator ?serialized_payload)
        (serialized_payload_bound_to_request ?serialized_payload ?outbound_request)
        (outbound_request_middleware_attached ?outbound_request)
        (not
          (coordinator_payload_committed ?integration_coordinator)
        )
      )
    :effect (coordinator_payload_committed ?integration_coordinator)
  )
  (:action apply_retry_policy
    :parameters (?integration_coordinator - integration_coordinator ?retry_policy - retry_policy ?serialized_payload - serialized_payload ?outbound_request - outbound_request)
    :precondition
      (and
        (coordinator_payload_committed ?integration_coordinator)
        (coordinator_retry_policy_bound ?integration_coordinator ?retry_policy)
        (coordinator_has_serialized_payload ?integration_coordinator ?serialized_payload)
        (serialized_payload_bound_to_request ?serialized_payload ?outbound_request)
        (not
          (outbound_request_header_attached ?outbound_request)
        )
        (not
          (outbound_request_middleware_attached ?outbound_request)
        )
        (not
          (coordinator_middleware_applied ?integration_coordinator)
        )
      )
    :effect (coordinator_middleware_applied ?integration_coordinator)
  )
  (:action apply_retry_and_prepare_middleware
    :parameters (?integration_coordinator - integration_coordinator ?retry_policy - retry_policy ?serialized_payload - serialized_payload ?outbound_request - outbound_request)
    :precondition
      (and
        (coordinator_payload_committed ?integration_coordinator)
        (coordinator_retry_policy_bound ?integration_coordinator ?retry_policy)
        (coordinator_has_serialized_payload ?integration_coordinator ?serialized_payload)
        (serialized_payload_bound_to_request ?serialized_payload ?outbound_request)
        (outbound_request_header_attached ?outbound_request)
        (not
          (outbound_request_middleware_attached ?outbound_request)
        )
        (not
          (coordinator_middleware_applied ?integration_coordinator)
        )
      )
    :effect
      (and
        (coordinator_middleware_applied ?integration_coordinator)
        (coordinator_middleware_ready ?integration_coordinator)
      )
  )
  (:action apply_retry_and_finalize_middleware
    :parameters (?integration_coordinator - integration_coordinator ?retry_policy - retry_policy ?serialized_payload - serialized_payload ?outbound_request - outbound_request)
    :precondition
      (and
        (coordinator_payload_committed ?integration_coordinator)
        (coordinator_retry_policy_bound ?integration_coordinator ?retry_policy)
        (coordinator_has_serialized_payload ?integration_coordinator ?serialized_payload)
        (serialized_payload_bound_to_request ?serialized_payload ?outbound_request)
        (not
          (outbound_request_header_attached ?outbound_request)
        )
        (outbound_request_middleware_attached ?outbound_request)
        (not
          (coordinator_middleware_applied ?integration_coordinator)
        )
      )
    :effect
      (and
        (coordinator_middleware_applied ?integration_coordinator)
        (coordinator_middleware_ready ?integration_coordinator)
      )
  )
  (:action apply_retry_and_finalize_middleware_full
    :parameters (?integration_coordinator - integration_coordinator ?retry_policy - retry_policy ?serialized_payload - serialized_payload ?outbound_request - outbound_request)
    :precondition
      (and
        (coordinator_payload_committed ?integration_coordinator)
        (coordinator_retry_policy_bound ?integration_coordinator ?retry_policy)
        (coordinator_has_serialized_payload ?integration_coordinator ?serialized_payload)
        (serialized_payload_bound_to_request ?serialized_payload ?outbound_request)
        (outbound_request_header_attached ?outbound_request)
        (outbound_request_middleware_attached ?outbound_request)
        (not
          (coordinator_middleware_applied ?integration_coordinator)
        )
      )
    :effect
      (and
        (coordinator_middleware_applied ?integration_coordinator)
        (coordinator_middleware_ready ?integration_coordinator)
      )
  )
  (:action seal_coordinator_for_dispatch
    :parameters (?integration_coordinator - integration_coordinator)
    :precondition
      (and
        (coordinator_middleware_applied ?integration_coordinator)
        (not
          (coordinator_middleware_ready ?integration_coordinator)
        )
        (not
          (coordinator_dispatch_ready ?integration_coordinator)
        )
      )
    :effect
      (and
        (coordinator_dispatch_ready ?integration_coordinator)
        (dispatch_confirmed_for_entity ?integration_coordinator)
      )
  )
  (:action attach_middleware_to_coordinator
    :parameters (?integration_coordinator - integration_coordinator ?middleware_module - middleware_module)
    :precondition
      (and
        (coordinator_middleware_applied ?integration_coordinator)
        (coordinator_middleware_ready ?integration_coordinator)
        (middleware_module_available ?middleware_module)
      )
    :effect
      (and
        (coordinator_middleware_bound ?integration_coordinator ?middleware_module)
        (not
          (middleware_module_available ?middleware_module)
        )
      )
  )
  (:action finalize_coordinator_orchestration
    :parameters (?integration_coordinator - integration_coordinator ?worker_a - worker_a ?worker_b - worker_b ?payload_builder - payload_builder ?middleware_module - middleware_module)
    :precondition
      (and
        (coordinator_middleware_applied ?integration_coordinator)
        (coordinator_middleware_ready ?integration_coordinator)
        (coordinator_middleware_bound ?integration_coordinator ?middleware_module)
        (coordinator_has_worker_a ?integration_coordinator ?worker_a)
        (coordinator_has_worker_b ?integration_coordinator ?worker_b)
        (worker_a_ready ?worker_a)
        (worker_b_ready ?worker_b)
        (payload_builder_assigned ?integration_coordinator ?payload_builder)
        (not
          (coordinator_orchestration_complete ?integration_coordinator)
        )
      )
    :effect (coordinator_orchestration_complete ?integration_coordinator)
  )
  (:action finalize_and_mark_coordinator_for_dispatch
    :parameters (?integration_coordinator - integration_coordinator)
    :precondition
      (and
        (coordinator_middleware_applied ?integration_coordinator)
        (coordinator_orchestration_complete ?integration_coordinator)
        (not
          (coordinator_dispatch_ready ?integration_coordinator)
        )
      )
    :effect
      (and
        (coordinator_dispatch_ready ?integration_coordinator)
        (dispatch_confirmed_for_entity ?integration_coordinator)
      )
  )
  (:action attach_audit_tag_to_coordinator
    :parameters (?integration_coordinator - integration_coordinator ?audit_tag - audit_tag ?payload_builder - payload_builder)
    :precondition
      (and
        (domain_resource_prepared ?integration_coordinator)
        (payload_builder_assigned ?integration_coordinator ?payload_builder)
        (audit_tag_available ?audit_tag)
        (coordinator_has_audit_tag ?integration_coordinator ?audit_tag)
        (not
          (coordinator_audit_attached ?integration_coordinator)
        )
      )
    :effect
      (and
        (coordinator_audit_attached ?integration_coordinator)
        (not
          (audit_tag_available ?audit_tag)
        )
      )
  )
  (:action apply_authenticator_to_coordinator
    :parameters (?integration_coordinator - integration_coordinator ?authenticator - authenticator)
    :precondition
      (and
        (coordinator_audit_attached ?integration_coordinator)
        (authenticator_assigned ?integration_coordinator ?authenticator)
        (not
          (coordinator_auth_applied ?integration_coordinator)
        )
      )
    :effect (coordinator_auth_applied ?integration_coordinator)
  )
  (:action apply_retry_policy_after_auth
    :parameters (?integration_coordinator - integration_coordinator ?retry_policy - retry_policy)
    :precondition
      (and
        (coordinator_auth_applied ?integration_coordinator)
        (coordinator_retry_policy_bound ?integration_coordinator ?retry_policy)
        (not
          (coordinator_retry_applied ?integration_coordinator)
        )
      )
    :effect (coordinator_retry_applied ?integration_coordinator)
  )
  (:action finalize_coordinator_with_retry
    :parameters (?integration_coordinator - integration_coordinator)
    :precondition
      (and
        (coordinator_retry_applied ?integration_coordinator)
        (not
          (coordinator_dispatch_ready ?integration_coordinator)
        )
      )
    :effect
      (and
        (coordinator_dispatch_ready ?integration_coordinator)
        (dispatch_confirmed_for_entity ?integration_coordinator)
      )
  )
  (:action confirm_worker_dispatch
    :parameters (?worker_a - worker_a ?outbound_request - outbound_request)
    :precondition
      (and
        (worker_a_initialized ?worker_a)
        (worker_a_ready ?worker_a)
        (outbound_request_initialized ?outbound_request)
        (outbound_request_ready_for_dispatch ?outbound_request)
        (not
          (dispatch_confirmed_for_entity ?worker_a)
        )
      )
    :effect (dispatch_confirmed_for_entity ?worker_a)
  )
  (:action confirm_worker_b_dispatch
    :parameters (?worker_b - worker_b ?outbound_request - outbound_request)
    :precondition
      (and
        (worker_b_initialized ?worker_b)
        (worker_b_ready ?worker_b)
        (outbound_request_initialized ?outbound_request)
        (outbound_request_ready_for_dispatch ?outbound_request)
        (not
          (dispatch_confirmed_for_entity ?worker_b)
        )
      )
    :effect (dispatch_confirmed_for_entity ?worker_b)
  )
  (:action confirm_resource_write_and_register_callback
    :parameters (?domain_resource - domain_resource ?callback_handler - callback_handler ?payload_builder - payload_builder)
    :precondition
      (and
        (dispatch_confirmed_for_entity ?domain_resource)
        (payload_builder_assigned ?domain_resource ?payload_builder)
        (callback_handler_available ?callback_handler)
        (not
          (domain_resource_write_confirmed ?domain_resource)
        )
      )
    :effect
      (and
        (domain_resource_write_confirmed ?domain_resource)
        (resource_callback_bound ?domain_resource ?callback_handler)
        (not
          (callback_handler_available ?callback_handler)
        )
      )
  )
  (:action confirm_write_on_worker_and_release_credential
    :parameters (?worker_a - worker_a ?api_credential - api_key ?callback_handler - callback_handler)
    :precondition
      (and
        (domain_resource_write_confirmed ?worker_a)
        (resource_has_api_key ?worker_a ?api_credential)
        (resource_callback_bound ?worker_a ?callback_handler)
        (not
          (resource_persisted ?worker_a)
        )
      )
    :effect
      (and
        (resource_persisted ?worker_a)
        (api_key_available ?api_credential)
        (callback_handler_available ?callback_handler)
      )
  )
  (:action confirm_write_on_worker_b_and_release_credential
    :parameters (?worker_b - worker_b ?api_credential - api_key ?callback_handler - callback_handler)
    :precondition
      (and
        (domain_resource_write_confirmed ?worker_b)
        (resource_has_api_key ?worker_b ?api_credential)
        (resource_callback_bound ?worker_b ?callback_handler)
        (not
          (resource_persisted ?worker_b)
        )
      )
    :effect
      (and
        (resource_persisted ?worker_b)
        (api_key_available ?api_credential)
        (callback_handler_available ?callback_handler)
      )
  )
  (:action confirm_write_on_coordinator_and_release_credential
    :parameters (?integration_coordinator - integration_coordinator ?api_credential - api_key ?callback_handler - callback_handler)
    :precondition
      (and
        (domain_resource_write_confirmed ?integration_coordinator)
        (resource_has_api_key ?integration_coordinator ?api_credential)
        (resource_callback_bound ?integration_coordinator ?callback_handler)
        (not
          (resource_persisted ?integration_coordinator)
        )
      )
    :effect
      (and
        (resource_persisted ?integration_coordinator)
        (api_key_available ?api_credential)
        (callback_handler_available ?callback_handler)
      )
  )
)

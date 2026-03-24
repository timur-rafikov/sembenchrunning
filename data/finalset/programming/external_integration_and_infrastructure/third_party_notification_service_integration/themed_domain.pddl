(define (domain third_party_notification_service_integration)
  (:requirements :strips :typing :negative-preconditions)
  (:types integration_resource_category - object event_category - object channel_category - object integration_root - object integration_configuration - integration_root provider_endpoint - integration_resource_category event_type - integration_resource_category credential - integration_resource_category delivery_policy - integration_resource_category rate_limit_profile - integration_resource_category delivery_format - integration_resource_category enrichment_plugin - integration_resource_category webhook_endpoint - integration_resource_category template_resource - event_category content_payload - event_category recipient_mapping - event_category sender_channel - channel_category receiver_channel - channel_category notification_job - channel_category service_container - integration_configuration adapter_container - integration_configuration sender_service - service_container receiver_service - service_container integration_adapter - adapter_container)
  (:predicates
    (integration_initialized ?integration_configuration - integration_configuration)
    (integration_component_active ?integration_configuration - integration_configuration)
    (integration_has_provider_binding ?integration_configuration - integration_configuration)
    (binding_confirmed ?integration_configuration - integration_configuration)
    (component_dispatch_completed ?integration_configuration - integration_configuration)
    (integration_scheduled ?integration_configuration - integration_configuration)
    (endpoint_available ?provider_endpoint - provider_endpoint)
    (bound_to_endpoint ?integration_configuration - integration_configuration ?provider_endpoint - provider_endpoint)
    (event_available ?event_type - event_type)
    (subscribed_to_event ?integration_configuration - integration_configuration ?event_type - event_type)
    (credential_available ?credential - credential)
    (credential_attached ?integration_configuration - integration_configuration ?credential - credential)
    (template_available ?template_resource - template_resource)
    (sender_assigned_template ?sender_service - sender_service ?template_resource - template_resource)
    (receiver_assigned_template ?receiver_service - receiver_service ?template_resource - template_resource)
    (sender_has_channel ?sender_service - sender_service ?sender_channel - sender_channel)
    (sender_channel_ready ?sender_channel - sender_channel)
    (sender_channel_reserved ?sender_channel - sender_channel)
    (sender_ready ?sender_service - sender_service)
    (receiver_has_channel ?receiver_service - receiver_service ?receiver_channel - receiver_channel)
    (receiver_channel_ready ?receiver_channel - receiver_channel)
    (receiver_channel_reserved ?receiver_channel - receiver_channel)
    (receiver_ready ?receiver_service - receiver_service)
    (job_pending ?notification_job - notification_job)
    (job_reserved ?notification_job - notification_job)
    (job_has_sender_channel ?notification_job - notification_job ?sender_channel - sender_channel)
    (job_has_receiver_channel ?notification_job - notification_job ?receiver_channel - receiver_channel)
    (job_has_sender_ready ?notification_job - notification_job)
    (job_has_receiver_ready ?notification_job - notification_job)
    (job_payload_generation_scheduled ?notification_job - notification_job)
    (adapter_assigned_to_sender ?integration_adapter - integration_adapter ?sender_service - sender_service)
    (adapter_assigned_to_receiver ?integration_adapter - integration_adapter ?receiver_service - receiver_service)
    (adapter_assigned_to_job ?integration_adapter - integration_adapter ?notification_job - notification_job)
    (content_payload_available ?content_payload - content_payload)
    (adapter_has_payload_variant ?integration_adapter - integration_adapter ?content_payload - content_payload)
    (content_payload_ready ?content_payload - content_payload)
    (payload_assigned_to_job ?content_payload - content_payload ?notification_job - notification_job)
    (adapter_content_validated ?integration_adapter - integration_adapter)
    (adapter_enrichment_ready ?integration_adapter - integration_adapter)
    (adapter_content_ready ?integration_adapter - integration_adapter)
    (adapter_policy_bound ?integration_adapter - integration_adapter)
    (adapter_policy_active ?integration_adapter - integration_adapter)
    (adapter_policies_finalized ?integration_adapter - integration_adapter)
    (adapter_scheduled_for_dispatch ?integration_adapter - integration_adapter)
    (recipient_mapping_available ?recipient_mapping - recipient_mapping)
    (adapter_bound_to_recipient_mapping ?integration_adapter - integration_adapter ?recipient_mapping - recipient_mapping)
    (adapter_recipient_mapping_applied ?integration_adapter - integration_adapter)
    (adapter_recipient_mapping_verified ?integration_adapter - integration_adapter)
    (adapter_webhook_verified ?integration_adapter - integration_adapter)
    (delivery_policy_available ?delivery_policy - delivery_policy)
    (adapter_bound_to_policy ?integration_adapter - integration_adapter ?delivery_policy - delivery_policy)
    (rate_limit_profile_available ?rate_limit_profile - rate_limit_profile)
    (adapter_bound_to_rate_limit ?integration_adapter - integration_adapter ?rate_limit_profile - rate_limit_profile)
    (enrichment_plugin_available ?enrichment_plugin - enrichment_plugin)
    (adapter_bound_to_plugin ?integration_adapter - integration_adapter ?enrichment_plugin - enrichment_plugin)
    (webhook_available ?webhook_endpoint - webhook_endpoint)
    (adapter_bound_to_webhook ?integration_adapter - integration_adapter ?webhook_endpoint - webhook_endpoint)
    (delivery_format_available ?delivery_format - delivery_format)
    (integration_bound_format ?integration_configuration - integration_configuration ?delivery_format - delivery_format)
    (sender_service_primed ?sender_service - sender_service)
    (receiver_service_primed ?receiver_service - receiver_service)
    (adapter_marked_dispatched ?integration_adapter - integration_adapter)
  )
  (:action create_integration_configuration
    :parameters (?integration_configuration - integration_configuration)
    :precondition
      (and
        (not
          (integration_initialized ?integration_configuration)
        )
        (not
          (binding_confirmed ?integration_configuration)
        )
      )
    :effect (integration_initialized ?integration_configuration)
  )
  (:action bind_provider_endpoint
    :parameters (?integration_configuration - integration_configuration ?provider_endpoint - provider_endpoint)
    :precondition
      (and
        (integration_initialized ?integration_configuration)
        (not
          (integration_has_provider_binding ?integration_configuration)
        )
        (endpoint_available ?provider_endpoint)
      )
    :effect
      (and
        (integration_has_provider_binding ?integration_configuration)
        (bound_to_endpoint ?integration_configuration ?provider_endpoint)
        (not
          (endpoint_available ?provider_endpoint)
        )
      )
  )
  (:action register_event_subscription
    :parameters (?integration_configuration - integration_configuration ?event_type - event_type)
    :precondition
      (and
        (integration_initialized ?integration_configuration)
        (integration_has_provider_binding ?integration_configuration)
        (event_available ?event_type)
      )
    :effect
      (and
        (subscribed_to_event ?integration_configuration ?event_type)
        (not
          (event_available ?event_type)
        )
      )
  )
  (:action activate_event_subscription
    :parameters (?integration_configuration - integration_configuration ?event_type - event_type)
    :precondition
      (and
        (integration_initialized ?integration_configuration)
        (integration_has_provider_binding ?integration_configuration)
        (subscribed_to_event ?integration_configuration ?event_type)
        (not
          (integration_component_active ?integration_configuration)
        )
      )
    :effect (integration_component_active ?integration_configuration)
  )
  (:action unregister_event_subscription
    :parameters (?integration_configuration - integration_configuration ?event_type - event_type)
    :precondition
      (and
        (subscribed_to_event ?integration_configuration ?event_type)
      )
    :effect
      (and
        (event_available ?event_type)
        (not
          (subscribed_to_event ?integration_configuration ?event_type)
        )
      )
  )
  (:action attach_credential
    :parameters (?integration_configuration - integration_configuration ?credential - credential)
    :precondition
      (and
        (integration_component_active ?integration_configuration)
        (credential_available ?credential)
      )
    :effect
      (and
        (credential_attached ?integration_configuration ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action detach_credential
    :parameters (?integration_configuration - integration_configuration ?credential - credential)
    :precondition
      (and
        (credential_attached ?integration_configuration ?credential)
      )
    :effect
      (and
        (credential_available ?credential)
        (not
          (credential_attached ?integration_configuration ?credential)
        )
      )
  )
  (:action attach_enrichment_plugin
    :parameters (?integration_adapter - integration_adapter ?enrichment_plugin - enrichment_plugin)
    :precondition
      (and
        (integration_component_active ?integration_adapter)
        (enrichment_plugin_available ?enrichment_plugin)
      )
    :effect
      (and
        (adapter_bound_to_plugin ?integration_adapter ?enrichment_plugin)
        (not
          (enrichment_plugin_available ?enrichment_plugin)
        )
      )
  )
  (:action detach_enrichment_plugin
    :parameters (?integration_adapter - integration_adapter ?enrichment_plugin - enrichment_plugin)
    :precondition
      (and
        (adapter_bound_to_plugin ?integration_adapter ?enrichment_plugin)
      )
    :effect
      (and
        (enrichment_plugin_available ?enrichment_plugin)
        (not
          (adapter_bound_to_plugin ?integration_adapter ?enrichment_plugin)
        )
      )
  )
  (:action attach_webhook_endpoint
    :parameters (?integration_adapter - integration_adapter ?webhook_endpoint - webhook_endpoint)
    :precondition
      (and
        (integration_component_active ?integration_adapter)
        (webhook_available ?webhook_endpoint)
      )
    :effect
      (and
        (adapter_bound_to_webhook ?integration_adapter ?webhook_endpoint)
        (not
          (webhook_available ?webhook_endpoint)
        )
      )
  )
  (:action detach_webhook_endpoint
    :parameters (?integration_adapter - integration_adapter ?webhook_endpoint - webhook_endpoint)
    :precondition
      (and
        (adapter_bound_to_webhook ?integration_adapter ?webhook_endpoint)
      )
    :effect
      (and
        (webhook_available ?webhook_endpoint)
        (not
          (adapter_bound_to_webhook ?integration_adapter ?webhook_endpoint)
        )
      )
  )
  (:action prepare_sender_channel
    :parameters (?sender_service - sender_service ?sender_channel - sender_channel ?event_type - event_type)
    :precondition
      (and
        (integration_component_active ?sender_service)
        (subscribed_to_event ?sender_service ?event_type)
        (sender_has_channel ?sender_service ?sender_channel)
        (not
          (sender_channel_ready ?sender_channel)
        )
        (not
          (sender_channel_reserved ?sender_channel)
        )
      )
    :effect (sender_channel_ready ?sender_channel)
  )
  (:action prime_sender_service
    :parameters (?sender_service - sender_service ?sender_channel - sender_channel ?credential - credential)
    :precondition
      (and
        (integration_component_active ?sender_service)
        (credential_attached ?sender_service ?credential)
        (sender_has_channel ?sender_service ?sender_channel)
        (sender_channel_ready ?sender_channel)
        (not
          (sender_service_primed ?sender_service)
        )
      )
    :effect
      (and
        (sender_service_primed ?sender_service)
        (sender_ready ?sender_service)
      )
  )
  (:action assign_template_to_sender_channel
    :parameters (?sender_service - sender_service ?sender_channel - sender_channel ?template_resource - template_resource)
    :precondition
      (and
        (integration_component_active ?sender_service)
        (sender_has_channel ?sender_service ?sender_channel)
        (template_available ?template_resource)
        (not
          (sender_service_primed ?sender_service)
        )
      )
    :effect
      (and
        (sender_channel_reserved ?sender_channel)
        (sender_service_primed ?sender_service)
        (sender_assigned_template ?sender_service ?template_resource)
        (not
          (template_available ?template_resource)
        )
      )
  )
  (:action finalize_sender_channel_template
    :parameters (?sender_service - sender_service ?sender_channel - sender_channel ?event_type - event_type ?template_resource - template_resource)
    :precondition
      (and
        (integration_component_active ?sender_service)
        (subscribed_to_event ?sender_service ?event_type)
        (sender_has_channel ?sender_service ?sender_channel)
        (sender_channel_reserved ?sender_channel)
        (sender_assigned_template ?sender_service ?template_resource)
        (not
          (sender_ready ?sender_service)
        )
      )
    :effect
      (and
        (sender_channel_ready ?sender_channel)
        (sender_ready ?sender_service)
        (template_available ?template_resource)
        (not
          (sender_assigned_template ?sender_service ?template_resource)
        )
      )
  )
  (:action prepare_receiver_channel
    :parameters (?receiver_service - receiver_service ?receiver_channel - receiver_channel ?event_type - event_type)
    :precondition
      (and
        (integration_component_active ?receiver_service)
        (subscribed_to_event ?receiver_service ?event_type)
        (receiver_has_channel ?receiver_service ?receiver_channel)
        (not
          (receiver_channel_ready ?receiver_channel)
        )
        (not
          (receiver_channel_reserved ?receiver_channel)
        )
      )
    :effect (receiver_channel_ready ?receiver_channel)
  )
  (:action prime_receiver_service
    :parameters (?receiver_service - receiver_service ?receiver_channel - receiver_channel ?credential - credential)
    :precondition
      (and
        (integration_component_active ?receiver_service)
        (credential_attached ?receiver_service ?credential)
        (receiver_has_channel ?receiver_service ?receiver_channel)
        (receiver_channel_ready ?receiver_channel)
        (not
          (receiver_service_primed ?receiver_service)
        )
      )
    :effect
      (and
        (receiver_service_primed ?receiver_service)
        (receiver_ready ?receiver_service)
      )
  )
  (:action assign_template_to_receiver_channel
    :parameters (?receiver_service - receiver_service ?receiver_channel - receiver_channel ?template_resource - template_resource)
    :precondition
      (and
        (integration_component_active ?receiver_service)
        (receiver_has_channel ?receiver_service ?receiver_channel)
        (template_available ?template_resource)
        (not
          (receiver_service_primed ?receiver_service)
        )
      )
    :effect
      (and
        (receiver_channel_reserved ?receiver_channel)
        (receiver_service_primed ?receiver_service)
        (receiver_assigned_template ?receiver_service ?template_resource)
        (not
          (template_available ?template_resource)
        )
      )
  )
  (:action finalize_receiver_channel_template
    :parameters (?receiver_service - receiver_service ?receiver_channel - receiver_channel ?event_type - event_type ?template_resource - template_resource)
    :precondition
      (and
        (integration_component_active ?receiver_service)
        (subscribed_to_event ?receiver_service ?event_type)
        (receiver_has_channel ?receiver_service ?receiver_channel)
        (receiver_channel_reserved ?receiver_channel)
        (receiver_assigned_template ?receiver_service ?template_resource)
        (not
          (receiver_ready ?receiver_service)
        )
      )
    :effect
      (and
        (receiver_channel_ready ?receiver_channel)
        (receiver_ready ?receiver_service)
        (template_available ?template_resource)
        (not
          (receiver_assigned_template ?receiver_service ?template_resource)
        )
      )
  )
  (:action assemble_notification_job
    :parameters (?sender_service - sender_service ?receiver_service - receiver_service ?sender_channel - sender_channel ?receiver_channel - receiver_channel ?notification_job - notification_job)
    :precondition
      (and
        (sender_service_primed ?sender_service)
        (receiver_service_primed ?receiver_service)
        (sender_has_channel ?sender_service ?sender_channel)
        (receiver_has_channel ?receiver_service ?receiver_channel)
        (sender_channel_ready ?sender_channel)
        (receiver_channel_ready ?receiver_channel)
        (sender_ready ?sender_service)
        (receiver_ready ?receiver_service)
        (job_pending ?notification_job)
      )
    :effect
      (and
        (job_reserved ?notification_job)
        (job_has_sender_channel ?notification_job ?sender_channel)
        (job_has_receiver_channel ?notification_job ?receiver_channel)
        (not
          (job_pending ?notification_job)
        )
      )
  )
  (:action assemble_notification_job_with_sender_reserved
    :parameters (?sender_service - sender_service ?receiver_service - receiver_service ?sender_channel - sender_channel ?receiver_channel - receiver_channel ?notification_job - notification_job)
    :precondition
      (and
        (sender_service_primed ?sender_service)
        (receiver_service_primed ?receiver_service)
        (sender_has_channel ?sender_service ?sender_channel)
        (receiver_has_channel ?receiver_service ?receiver_channel)
        (sender_channel_reserved ?sender_channel)
        (receiver_channel_ready ?receiver_channel)
        (not
          (sender_ready ?sender_service)
        )
        (receiver_ready ?receiver_service)
        (job_pending ?notification_job)
      )
    :effect
      (and
        (job_reserved ?notification_job)
        (job_has_sender_channel ?notification_job ?sender_channel)
        (job_has_receiver_channel ?notification_job ?receiver_channel)
        (job_has_sender_ready ?notification_job)
        (not
          (job_pending ?notification_job)
        )
      )
  )
  (:action assemble_notification_job_with_receiver_reserved
    :parameters (?sender_service - sender_service ?receiver_service - receiver_service ?sender_channel - sender_channel ?receiver_channel - receiver_channel ?notification_job - notification_job)
    :precondition
      (and
        (sender_service_primed ?sender_service)
        (receiver_service_primed ?receiver_service)
        (sender_has_channel ?sender_service ?sender_channel)
        (receiver_has_channel ?receiver_service ?receiver_channel)
        (sender_channel_ready ?sender_channel)
        (receiver_channel_reserved ?receiver_channel)
        (sender_ready ?sender_service)
        (not
          (receiver_ready ?receiver_service)
        )
        (job_pending ?notification_job)
      )
    :effect
      (and
        (job_reserved ?notification_job)
        (job_has_sender_channel ?notification_job ?sender_channel)
        (job_has_receiver_channel ?notification_job ?receiver_channel)
        (job_has_receiver_ready ?notification_job)
        (not
          (job_pending ?notification_job)
        )
      )
  )
  (:action assemble_notification_job_with_both_reserved
    :parameters (?sender_service - sender_service ?receiver_service - receiver_service ?sender_channel - sender_channel ?receiver_channel - receiver_channel ?notification_job - notification_job)
    :precondition
      (and
        (sender_service_primed ?sender_service)
        (receiver_service_primed ?receiver_service)
        (sender_has_channel ?sender_service ?sender_channel)
        (receiver_has_channel ?receiver_service ?receiver_channel)
        (sender_channel_reserved ?sender_channel)
        (receiver_channel_reserved ?receiver_channel)
        (not
          (sender_ready ?sender_service)
        )
        (not
          (receiver_ready ?receiver_service)
        )
        (job_pending ?notification_job)
      )
    :effect
      (and
        (job_reserved ?notification_job)
        (job_has_sender_channel ?notification_job ?sender_channel)
        (job_has_receiver_channel ?notification_job ?receiver_channel)
        (job_has_sender_ready ?notification_job)
        (job_has_receiver_ready ?notification_job)
        (not
          (job_pending ?notification_job)
        )
      )
  )
  (:action schedule_payload_generation
    :parameters (?notification_job - notification_job ?sender_service - sender_service ?event_type - event_type)
    :precondition
      (and
        (job_reserved ?notification_job)
        (sender_service_primed ?sender_service)
        (subscribed_to_event ?sender_service ?event_type)
        (not
          (job_payload_generation_scheduled ?notification_job)
        )
      )
    :effect (job_payload_generation_scheduled ?notification_job)
  )
  (:action generate_content_payload
    :parameters (?integration_adapter - integration_adapter ?content_payload - content_payload ?notification_job - notification_job)
    :precondition
      (and
        (integration_component_active ?integration_adapter)
        (adapter_assigned_to_job ?integration_adapter ?notification_job)
        (adapter_has_payload_variant ?integration_adapter ?content_payload)
        (content_payload_available ?content_payload)
        (job_reserved ?notification_job)
        (job_payload_generation_scheduled ?notification_job)
        (not
          (content_payload_ready ?content_payload)
        )
      )
    :effect
      (and
        (content_payload_ready ?content_payload)
        (payload_assigned_to_job ?content_payload ?notification_job)
        (not
          (content_payload_available ?content_payload)
        )
      )
  )
  (:action validate_content_on_adapter
    :parameters (?integration_adapter - integration_adapter ?content_payload - content_payload ?notification_job - notification_job ?event_type - event_type)
    :precondition
      (and
        (integration_component_active ?integration_adapter)
        (adapter_has_payload_variant ?integration_adapter ?content_payload)
        (content_payload_ready ?content_payload)
        (payload_assigned_to_job ?content_payload ?notification_job)
        (subscribed_to_event ?integration_adapter ?event_type)
        (not
          (job_has_sender_ready ?notification_job)
        )
        (not
          (adapter_content_validated ?integration_adapter)
        )
      )
    :effect (adapter_content_validated ?integration_adapter)
  )
  (:action attach_delivery_policy
    :parameters (?integration_adapter - integration_adapter ?delivery_policy - delivery_policy)
    :precondition
      (and
        (integration_component_active ?integration_adapter)
        (delivery_policy_available ?delivery_policy)
        (not
          (adapter_policy_bound ?integration_adapter)
        )
      )
    :effect
      (and
        (adapter_policy_bound ?integration_adapter)
        (adapter_bound_to_policy ?integration_adapter ?delivery_policy)
        (not
          (delivery_policy_available ?delivery_policy)
        )
      )
  )
  (:action apply_policy_and_prepare_adapter
    :parameters (?integration_adapter - integration_adapter ?content_payload - content_payload ?notification_job - notification_job ?event_type - event_type ?delivery_policy - delivery_policy)
    :precondition
      (and
        (integration_component_active ?integration_adapter)
        (adapter_has_payload_variant ?integration_adapter ?content_payload)
        (content_payload_ready ?content_payload)
        (payload_assigned_to_job ?content_payload ?notification_job)
        (subscribed_to_event ?integration_adapter ?event_type)
        (job_has_sender_ready ?notification_job)
        (adapter_policy_bound ?integration_adapter)
        (adapter_bound_to_policy ?integration_adapter ?delivery_policy)
        (not
          (adapter_content_validated ?integration_adapter)
        )
      )
    :effect
      (and
        (adapter_content_validated ?integration_adapter)
        (adapter_policy_active ?integration_adapter)
      )
  )
  (:action apply_enrichment_and_mark_adapter
    :parameters (?integration_adapter - integration_adapter ?enrichment_plugin - enrichment_plugin ?credential - credential ?content_payload - content_payload ?notification_job - notification_job)
    :precondition
      (and
        (adapter_content_validated ?integration_adapter)
        (adapter_bound_to_plugin ?integration_adapter ?enrichment_plugin)
        (credential_attached ?integration_adapter ?credential)
        (adapter_has_payload_variant ?integration_adapter ?content_payload)
        (payload_assigned_to_job ?content_payload ?notification_job)
        (not
          (job_has_receiver_ready ?notification_job)
        )
        (not
          (adapter_enrichment_ready ?integration_adapter)
        )
      )
    :effect (adapter_enrichment_ready ?integration_adapter)
  )
  (:action apply_enrichment_and_mark_adapter_receiver_ready
    :parameters (?integration_adapter - integration_adapter ?enrichment_plugin - enrichment_plugin ?credential - credential ?content_payload - content_payload ?notification_job - notification_job)
    :precondition
      (and
        (adapter_content_validated ?integration_adapter)
        (adapter_bound_to_plugin ?integration_adapter ?enrichment_plugin)
        (credential_attached ?integration_adapter ?credential)
        (adapter_has_payload_variant ?integration_adapter ?content_payload)
        (payload_assigned_to_job ?content_payload ?notification_job)
        (job_has_receiver_ready ?notification_job)
        (not
          (adapter_enrichment_ready ?integration_adapter)
        )
      )
    :effect (adapter_enrichment_ready ?integration_adapter)
  )
  (:action finalize_adapter_content
    :parameters (?integration_adapter - integration_adapter ?webhook_endpoint - webhook_endpoint ?content_payload - content_payload ?notification_job - notification_job)
    :precondition
      (and
        (adapter_enrichment_ready ?integration_adapter)
        (adapter_bound_to_webhook ?integration_adapter ?webhook_endpoint)
        (adapter_has_payload_variant ?integration_adapter ?content_payload)
        (payload_assigned_to_job ?content_payload ?notification_job)
        (not
          (job_has_sender_ready ?notification_job)
        )
        (not
          (job_has_receiver_ready ?notification_job)
        )
        (not
          (adapter_content_ready ?integration_adapter)
        )
      )
    :effect (adapter_content_ready ?integration_adapter)
  )
  (:action finalize_adapter_content_and_finalize_policies
    :parameters (?integration_adapter - integration_adapter ?webhook_endpoint - webhook_endpoint ?content_payload - content_payload ?notification_job - notification_job)
    :precondition
      (and
        (adapter_enrichment_ready ?integration_adapter)
        (adapter_bound_to_webhook ?integration_adapter ?webhook_endpoint)
        (adapter_has_payload_variant ?integration_adapter ?content_payload)
        (payload_assigned_to_job ?content_payload ?notification_job)
        (job_has_sender_ready ?notification_job)
        (not
          (job_has_receiver_ready ?notification_job)
        )
        (not
          (adapter_content_ready ?integration_adapter)
        )
      )
    :effect
      (and
        (adapter_content_ready ?integration_adapter)
        (adapter_policies_finalized ?integration_adapter)
      )
  )
  (:action finalize_adapter_content_with_receiver_ready
    :parameters (?integration_adapter - integration_adapter ?webhook_endpoint - webhook_endpoint ?content_payload - content_payload ?notification_job - notification_job)
    :precondition
      (and
        (adapter_enrichment_ready ?integration_adapter)
        (adapter_bound_to_webhook ?integration_adapter ?webhook_endpoint)
        (adapter_has_payload_variant ?integration_adapter ?content_payload)
        (payload_assigned_to_job ?content_payload ?notification_job)
        (not
          (job_has_sender_ready ?notification_job)
        )
        (job_has_receiver_ready ?notification_job)
        (not
          (adapter_content_ready ?integration_adapter)
        )
      )
    :effect
      (and
        (adapter_content_ready ?integration_adapter)
        (adapter_policies_finalized ?integration_adapter)
      )
  )
  (:action finalize_adapter_content_with_full_ready
    :parameters (?integration_adapter - integration_adapter ?webhook_endpoint - webhook_endpoint ?content_payload - content_payload ?notification_job - notification_job)
    :precondition
      (and
        (adapter_enrichment_ready ?integration_adapter)
        (adapter_bound_to_webhook ?integration_adapter ?webhook_endpoint)
        (adapter_has_payload_variant ?integration_adapter ?content_payload)
        (payload_assigned_to_job ?content_payload ?notification_job)
        (job_has_sender_ready ?notification_job)
        (job_has_receiver_ready ?notification_job)
        (not
          (adapter_content_ready ?integration_adapter)
        )
      )
    :effect
      (and
        (adapter_content_ready ?integration_adapter)
        (adapter_policies_finalized ?integration_adapter)
      )
  )
  (:action commit_adapter_dispatch
    :parameters (?integration_adapter - integration_adapter)
    :precondition
      (and
        (adapter_content_ready ?integration_adapter)
        (not
          (adapter_policies_finalized ?integration_adapter)
        )
        (not
          (adapter_marked_dispatched ?integration_adapter)
        )
      )
    :effect
      (and
        (adapter_marked_dispatched ?integration_adapter)
        (component_dispatch_completed ?integration_adapter)
      )
  )
  (:action attach_rate_limit_profile
    :parameters (?integration_adapter - integration_adapter ?rate_limit_profile - rate_limit_profile)
    :precondition
      (and
        (adapter_content_ready ?integration_adapter)
        (adapter_policies_finalized ?integration_adapter)
        (rate_limit_profile_available ?rate_limit_profile)
      )
    :effect
      (and
        (adapter_bound_to_rate_limit ?integration_adapter ?rate_limit_profile)
        (not
          (rate_limit_profile_available ?rate_limit_profile)
        )
      )
  )
  (:action prepare_adapter_for_dispatch
    :parameters (?integration_adapter - integration_adapter ?sender_service - sender_service ?receiver_service - receiver_service ?event_type - event_type ?rate_limit_profile - rate_limit_profile)
    :precondition
      (and
        (adapter_content_ready ?integration_adapter)
        (adapter_policies_finalized ?integration_adapter)
        (adapter_bound_to_rate_limit ?integration_adapter ?rate_limit_profile)
        (adapter_assigned_to_sender ?integration_adapter ?sender_service)
        (adapter_assigned_to_receiver ?integration_adapter ?receiver_service)
        (sender_ready ?sender_service)
        (receiver_ready ?receiver_service)
        (subscribed_to_event ?integration_adapter ?event_type)
        (not
          (adapter_scheduled_for_dispatch ?integration_adapter)
        )
      )
    :effect (adapter_scheduled_for_dispatch ?integration_adapter)
  )
  (:action commit_scheduled_adapter_dispatch
    :parameters (?integration_adapter - integration_adapter)
    :precondition
      (and
        (adapter_content_ready ?integration_adapter)
        (adapter_scheduled_for_dispatch ?integration_adapter)
        (not
          (adapter_marked_dispatched ?integration_adapter)
        )
      )
    :effect
      (and
        (adapter_marked_dispatched ?integration_adapter)
        (component_dispatch_completed ?integration_adapter)
      )
  )
  (:action apply_recipient_mapping
    :parameters (?integration_adapter - integration_adapter ?recipient_mapping - recipient_mapping ?event_type - event_type)
    :precondition
      (and
        (integration_component_active ?integration_adapter)
        (subscribed_to_event ?integration_adapter ?event_type)
        (recipient_mapping_available ?recipient_mapping)
        (adapter_bound_to_recipient_mapping ?integration_adapter ?recipient_mapping)
        (not
          (adapter_recipient_mapping_applied ?integration_adapter)
        )
      )
    :effect
      (and
        (adapter_recipient_mapping_applied ?integration_adapter)
        (not
          (recipient_mapping_available ?recipient_mapping)
        )
      )
  )
  (:action verify_recipient_mapping
    :parameters (?integration_adapter - integration_adapter ?credential - credential)
    :precondition
      (and
        (adapter_recipient_mapping_applied ?integration_adapter)
        (credential_attached ?integration_adapter ?credential)
        (not
          (adapter_recipient_mapping_verified ?integration_adapter)
        )
      )
    :effect (adapter_recipient_mapping_verified ?integration_adapter)
  )
  (:action confirm_webhook_integration
    :parameters (?integration_adapter - integration_adapter ?webhook_endpoint - webhook_endpoint)
    :precondition
      (and
        (adapter_recipient_mapping_verified ?integration_adapter)
        (adapter_bound_to_webhook ?integration_adapter ?webhook_endpoint)
        (not
          (adapter_webhook_verified ?integration_adapter)
        )
      )
    :effect (adapter_webhook_verified ?integration_adapter)
  )
  (:action commit_webhook_verified_dispatch
    :parameters (?integration_adapter - integration_adapter)
    :precondition
      (and
        (adapter_webhook_verified ?integration_adapter)
        (not
          (adapter_marked_dispatched ?integration_adapter)
        )
      )
    :effect
      (and
        (adapter_marked_dispatched ?integration_adapter)
        (component_dispatch_completed ?integration_adapter)
      )
  )
  (:action confirm_sender_dispatch
    :parameters (?sender_service - sender_service ?notification_job - notification_job)
    :precondition
      (and
        (sender_service_primed ?sender_service)
        (sender_ready ?sender_service)
        (job_reserved ?notification_job)
        (job_payload_generation_scheduled ?notification_job)
        (not
          (component_dispatch_completed ?sender_service)
        )
      )
    :effect (component_dispatch_completed ?sender_service)
  )
  (:action confirm_receiver_dispatch
    :parameters (?receiver_service - receiver_service ?notification_job - notification_job)
    :precondition
      (and
        (receiver_service_primed ?receiver_service)
        (receiver_ready ?receiver_service)
        (job_reserved ?notification_job)
        (job_payload_generation_scheduled ?notification_job)
        (not
          (component_dispatch_completed ?receiver_service)
        )
      )
    :effect (component_dispatch_completed ?receiver_service)
  )
  (:action attach_delivery_format
    :parameters (?integration_configuration - integration_configuration ?delivery_format - delivery_format ?event_type - event_type)
    :precondition
      (and
        (component_dispatch_completed ?integration_configuration)
        (subscribed_to_event ?integration_configuration ?event_type)
        (delivery_format_available ?delivery_format)
        (not
          (integration_scheduled ?integration_configuration)
        )
      )
    :effect
      (and
        (integration_scheduled ?integration_configuration)
        (integration_bound_format ?integration_configuration ?delivery_format)
        (not
          (delivery_format_available ?delivery_format)
        )
      )
  )
  (:action confirm_sender_binding
    :parameters (?sender_service - sender_service ?provider_endpoint - provider_endpoint ?delivery_format - delivery_format)
    :precondition
      (and
        (integration_scheduled ?sender_service)
        (bound_to_endpoint ?sender_service ?provider_endpoint)
        (integration_bound_format ?sender_service ?delivery_format)
        (not
          (binding_confirmed ?sender_service)
        )
      )
    :effect
      (and
        (binding_confirmed ?sender_service)
        (endpoint_available ?provider_endpoint)
        (delivery_format_available ?delivery_format)
      )
  )
  (:action confirm_receiver_binding
    :parameters (?receiver_service - receiver_service ?provider_endpoint - provider_endpoint ?delivery_format - delivery_format)
    :precondition
      (and
        (integration_scheduled ?receiver_service)
        (bound_to_endpoint ?receiver_service ?provider_endpoint)
        (integration_bound_format ?receiver_service ?delivery_format)
        (not
          (binding_confirmed ?receiver_service)
        )
      )
    :effect
      (and
        (binding_confirmed ?receiver_service)
        (endpoint_available ?provider_endpoint)
        (delivery_format_available ?delivery_format)
      )
  )
  (:action confirm_adapter_binding
    :parameters (?integration_adapter - integration_adapter ?provider_endpoint - provider_endpoint ?delivery_format - delivery_format)
    :precondition
      (and
        (integration_scheduled ?integration_adapter)
        (bound_to_endpoint ?integration_adapter ?provider_endpoint)
        (integration_bound_format ?integration_adapter ?delivery_format)
        (not
          (binding_confirmed ?integration_adapter)
        )
      )
    :effect
      (and
        (binding_confirmed ?integration_adapter)
        (endpoint_available ?provider_endpoint)
        (delivery_format_available ?delivery_format)
      )
  )
)

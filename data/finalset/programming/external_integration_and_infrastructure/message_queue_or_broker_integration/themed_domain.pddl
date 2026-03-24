(define (domain message_queue_broker_integration)
  (:requirements :strips :typing :negative-preconditions)
  (:types auxiliary_resource - object artifact - object broker_construct - object application_class - object application_component - application_class connector_resource - auxiliary_resource message_type - auxiliary_resource configuration_profile - auxiliary_resource transformation_plugin - auxiliary_resource traffic_policy - auxiliary_resource observability_configuration - auxiliary_resource runtime_middleware - auxiliary_resource delivery_policy - auxiliary_resource credential_material - artifact schema_artifact - artifact authorization_policy - artifact producer_routing - broker_construct consumer_routing - broker_construct message_instance - broker_construct service_role - application_component endpoint - application_component producer_instance - service_role consumer_instance - service_role broker_resource - endpoint)
  (:predicates
    (component_registered ?component - application_component)
    (entity_configured ?component - application_component)
    (component_bound ?component - application_component)
    (integration_complete ?component - application_component)
    (finalization_ready ?component - application_component)
    (entity_observability_configured ?component - application_component)
    (connector_available ?connector - connector_resource)
    (entity_connector_binding ?component - application_component ?connector - connector_resource)
    (message_type_available ?message_type - message_type)
    (entity_message_type_binding ?component - application_component ?message_type - message_type)
    (config_profile_available ?config_profile - configuration_profile)
    (entity_configuration_profile_binding ?component - application_component ?config_profile - configuration_profile)
    (credential_available ?credential - credential_material)
    (producer_credential_binding ?producer - producer_instance ?credential - credential_material)
    (consumer_credential_binding ?consumer - consumer_instance ?credential - credential_material)
    (producer_routing_binding ?producer - producer_instance ?producer_routing - producer_routing)
    (producer_routing_ready ?producer_routing - producer_routing)
    (producer_routing_secured ?producer_routing - producer_routing)
    (producer_confirmed ?producer - producer_instance)
    (consumer_routing_binding ?consumer - consumer_instance ?consumer_routing - consumer_routing)
    (consumer_routing_ready ?consumer_routing - consumer_routing)
    (consumer_routing_secured ?consumer_routing - consumer_routing)
    (consumer_confirmed ?consumer - consumer_instance)
    (message_slot_available ?message - message_instance)
    (message_staged ?message - message_instance)
    (message_bound_to_producer_routing ?message - message_instance ?producer_routing - producer_routing)
    (message_bound_to_consumer_routing ?message - message_instance ?consumer_routing - consumer_routing)
    (message_requires_transformation ?message - message_instance)
    (message_requires_middleware ?message - message_instance)
    (message_schema_ready ?message - message_instance)
    (resource_producer_binding ?broker_resource - broker_resource ?producer - producer_instance)
    (resource_consumer_binding ?broker_resource - broker_resource ?consumer - consumer_instance)
    (resource_has_message ?broker_resource - broker_resource ?message - message_instance)
    (schema_available ?schema - schema_artifact)
    (resource_schema_binding ?broker_resource - broker_resource ?schema - schema_artifact)
    (schema_consumed ?schema - schema_artifact)
    (schema_bound_to_message ?schema - schema_artifact ?message - message_instance)
    (resource_prepared ?broker_resource - broker_resource)
    (resource_middleware_initialized ?broker_resource - broker_resource)
    (resource_validated ?broker_resource - broker_resource)
    (resource_plugin_bound ?broker_resource - broker_resource)
    (resource_plugin_initialized ?broker_resource - broker_resource)
    (resource_processing_pipeline_configured ?broker_resource - broker_resource)
    (resource_activation_ready ?broker_resource - broker_resource)
    (authorization_policy_available ?auth_policy - authorization_policy)
    (resource_authorization_binding ?broker_resource - broker_resource ?auth_policy - authorization_policy)
    (resource_authorization_enabled ?broker_resource - broker_resource)
    (resource_authorization_step_completed ?broker_resource - broker_resource)
    (resource_authorization_finalized ?broker_resource - broker_resource)
    (transform_plugin_available ?transform_plugin - transformation_plugin)
    (resource_transform_plugin_binding ?broker_resource - broker_resource ?transform_plugin - transformation_plugin)
    (traffic_policy_available ?traffic_policy - traffic_policy)
    (resource_traffic_policy_binding ?broker_resource - broker_resource ?traffic_policy - traffic_policy)
    (runtime_middleware_available ?runtime_middleware - runtime_middleware)
    (resource_runtime_middleware_binding ?broker_resource - broker_resource ?runtime_middleware - runtime_middleware)
    (delivery_policy_available ?delivery_policy - delivery_policy)
    (resource_delivery_policy_binding ?broker_resource - broker_resource ?delivery_policy - delivery_policy)
    (observability_config_available ?observability_config - observability_configuration)
    (entity_observability_configuration_binding ?component - application_component ?observability_config - observability_configuration)
    (producer_ready ?producer - producer_instance)
    (consumer_ready ?consumer - consumer_instance)
    (resource_finalized ?broker_resource - broker_resource)
  )
  (:action register_component
    :parameters (?component - application_component)
    :precondition
      (and
        (not
          (component_registered ?component)
        )
        (not
          (integration_complete ?component)
        )
      )
    :effect (component_registered ?component)
  )
  (:action bind_component_to_connector
    :parameters (?component - application_component ?connector - connector_resource)
    :precondition
      (and
        (component_registered ?component)
        (not
          (component_bound ?component)
        )
        (connector_available ?connector)
      )
    :effect
      (and
        (component_bound ?component)
        (entity_connector_binding ?component ?connector)
        (not
          (connector_available ?connector)
        )
      )
  )
  (:action bind_message_type_to_component
    :parameters (?component - application_component ?message_type - message_type)
    :precondition
      (and
        (component_registered ?component)
        (component_bound ?component)
        (message_type_available ?message_type)
      )
    :effect
      (and
        (entity_message_type_binding ?component ?message_type)
        (not
          (message_type_available ?message_type)
        )
      )
  )
  (:action configure_component
    :parameters (?component - application_component ?message_type - message_type)
    :precondition
      (and
        (component_registered ?component)
        (component_bound ?component)
        (entity_message_type_binding ?component ?message_type)
        (not
          (entity_configured ?component)
        )
      )
    :effect (entity_configured ?component)
  )
  (:action unbind_message_type_from_component
    :parameters (?component - application_component ?message_type - message_type)
    :precondition
      (and
        (entity_message_type_binding ?component ?message_type)
      )
    :effect
      (and
        (message_type_available ?message_type)
        (not
          (entity_message_type_binding ?component ?message_type)
        )
      )
  )
  (:action attach_config_profile_to_component
    :parameters (?component - application_component ?config_profile - configuration_profile)
    :precondition
      (and
        (entity_configured ?component)
        (config_profile_available ?config_profile)
      )
    :effect
      (and
        (entity_configuration_profile_binding ?component ?config_profile)
        (not
          (config_profile_available ?config_profile)
        )
      )
  )
  (:action detach_config_profile_from_component
    :parameters (?component - application_component ?config_profile - configuration_profile)
    :precondition
      (and
        (entity_configuration_profile_binding ?component ?config_profile)
      )
    :effect
      (and
        (config_profile_available ?config_profile)
        (not
          (entity_configuration_profile_binding ?component ?config_profile)
        )
      )
  )
  (:action bind_runtime_middleware_to_resource
    :parameters (?broker_resource - broker_resource ?runtime_middleware - runtime_middleware)
    :precondition
      (and
        (entity_configured ?broker_resource)
        (runtime_middleware_available ?runtime_middleware)
      )
    :effect
      (and
        (resource_runtime_middleware_binding ?broker_resource ?runtime_middleware)
        (not
          (runtime_middleware_available ?runtime_middleware)
        )
      )
  )
  (:action unbind_runtime_middleware_from_resource
    :parameters (?broker_resource - broker_resource ?runtime_middleware - runtime_middleware)
    :precondition
      (and
        (resource_runtime_middleware_binding ?broker_resource ?runtime_middleware)
      )
    :effect
      (and
        (runtime_middleware_available ?runtime_middleware)
        (not
          (resource_runtime_middleware_binding ?broker_resource ?runtime_middleware)
        )
      )
  )
  (:action bind_delivery_policy_to_resource
    :parameters (?broker_resource - broker_resource ?delivery_policy - delivery_policy)
    :precondition
      (and
        (entity_configured ?broker_resource)
        (delivery_policy_available ?delivery_policy)
      )
    :effect
      (and
        (resource_delivery_policy_binding ?broker_resource ?delivery_policy)
        (not
          (delivery_policy_available ?delivery_policy)
        )
      )
  )
  (:action unbind_delivery_policy_from_resource
    :parameters (?broker_resource - broker_resource ?delivery_policy - delivery_policy)
    :precondition
      (and
        (resource_delivery_policy_binding ?broker_resource ?delivery_policy)
      )
    :effect
      (and
        (delivery_policy_available ?delivery_policy)
        (not
          (resource_delivery_policy_binding ?broker_resource ?delivery_policy)
        )
      )
  )
  (:action validate_producer_routing
    :parameters (?producer - producer_instance ?producer_routing - producer_routing ?message_type - message_type)
    :precondition
      (and
        (entity_configured ?producer)
        (entity_message_type_binding ?producer ?message_type)
        (producer_routing_binding ?producer ?producer_routing)
        (not
          (producer_routing_ready ?producer_routing)
        )
        (not
          (producer_routing_secured ?producer_routing)
        )
      )
    :effect (producer_routing_ready ?producer_routing)
  )
  (:action enable_producer_routing
    :parameters (?producer - producer_instance ?producer_routing - producer_routing ?config_profile - configuration_profile)
    :precondition
      (and
        (entity_configured ?producer)
        (entity_configuration_profile_binding ?producer ?config_profile)
        (producer_routing_binding ?producer ?producer_routing)
        (producer_routing_ready ?producer_routing)
        (not
          (producer_ready ?producer)
        )
      )
    :effect
      (and
        (producer_ready ?producer)
        (producer_confirmed ?producer)
      )
  )
  (:action apply_credential_to_producer
    :parameters (?producer - producer_instance ?producer_routing - producer_routing ?credential - credential_material)
    :precondition
      (and
        (entity_configured ?producer)
        (producer_routing_binding ?producer ?producer_routing)
        (credential_available ?credential)
        (not
          (producer_ready ?producer)
        )
      )
    :effect
      (and
        (producer_routing_secured ?producer_routing)
        (producer_ready ?producer)
        (producer_credential_binding ?producer ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action confirm_producer_routing
    :parameters (?producer - producer_instance ?producer_routing - producer_routing ?message_type - message_type ?credential - credential_material)
    :precondition
      (and
        (entity_configured ?producer)
        (entity_message_type_binding ?producer ?message_type)
        (producer_routing_binding ?producer ?producer_routing)
        (producer_routing_secured ?producer_routing)
        (producer_credential_binding ?producer ?credential)
        (not
          (producer_confirmed ?producer)
        )
      )
    :effect
      (and
        (producer_routing_ready ?producer_routing)
        (producer_confirmed ?producer)
        (credential_available ?credential)
        (not
          (producer_credential_binding ?producer ?credential)
        )
      )
  )
  (:action validate_consumer_routing
    :parameters (?consumer - consumer_instance ?consumer_routing - consumer_routing ?message_type - message_type)
    :precondition
      (and
        (entity_configured ?consumer)
        (entity_message_type_binding ?consumer ?message_type)
        (consumer_routing_binding ?consumer ?consumer_routing)
        (not
          (consumer_routing_ready ?consumer_routing)
        )
        (not
          (consumer_routing_secured ?consumer_routing)
        )
      )
    :effect (consumer_routing_ready ?consumer_routing)
  )
  (:action enable_consumer_routing
    :parameters (?consumer - consumer_instance ?consumer_routing - consumer_routing ?config_profile - configuration_profile)
    :precondition
      (and
        (entity_configured ?consumer)
        (entity_configuration_profile_binding ?consumer ?config_profile)
        (consumer_routing_binding ?consumer ?consumer_routing)
        (consumer_routing_ready ?consumer_routing)
        (not
          (consumer_ready ?consumer)
        )
      )
    :effect
      (and
        (consumer_ready ?consumer)
        (consumer_confirmed ?consumer)
      )
  )
  (:action apply_credential_to_consumer
    :parameters (?consumer - consumer_instance ?consumer_routing - consumer_routing ?credential - credential_material)
    :precondition
      (and
        (entity_configured ?consumer)
        (consumer_routing_binding ?consumer ?consumer_routing)
        (credential_available ?credential)
        (not
          (consumer_ready ?consumer)
        )
      )
    :effect
      (and
        (consumer_routing_secured ?consumer_routing)
        (consumer_ready ?consumer)
        (consumer_credential_binding ?consumer ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action confirm_consumer_routing
    :parameters (?consumer - consumer_instance ?consumer_routing - consumer_routing ?message_type - message_type ?credential - credential_material)
    :precondition
      (and
        (entity_configured ?consumer)
        (entity_message_type_binding ?consumer ?message_type)
        (consumer_routing_binding ?consumer ?consumer_routing)
        (consumer_routing_secured ?consumer_routing)
        (consumer_credential_binding ?consumer ?credential)
        (not
          (consumer_confirmed ?consumer)
        )
      )
    :effect
      (and
        (consumer_routing_ready ?consumer_routing)
        (consumer_confirmed ?consumer)
        (credential_available ?credential)
        (not
          (consumer_credential_binding ?consumer ?credential)
        )
      )
  )
  (:action stage_message_for_delivery
    :parameters (?producer - producer_instance ?consumer - consumer_instance ?producer_routing - producer_routing ?consumer_routing - consumer_routing ?message - message_instance)
    :precondition
      (and
        (producer_ready ?producer)
        (consumer_ready ?consumer)
        (producer_routing_binding ?producer ?producer_routing)
        (consumer_routing_binding ?consumer ?consumer_routing)
        (producer_routing_ready ?producer_routing)
        (consumer_routing_ready ?consumer_routing)
        (producer_confirmed ?producer)
        (consumer_confirmed ?consumer)
        (message_slot_available ?message)
      )
    :effect
      (and
        (message_staged ?message)
        (message_bound_to_producer_routing ?message ?producer_routing)
        (message_bound_to_consumer_routing ?message ?consumer_routing)
        (not
          (message_slot_available ?message)
        )
      )
  )
  (:action stage_message_with_transformation_required
    :parameters (?producer - producer_instance ?consumer - consumer_instance ?producer_routing - producer_routing ?consumer_routing - consumer_routing ?message - message_instance)
    :precondition
      (and
        (producer_ready ?producer)
        (consumer_ready ?consumer)
        (producer_routing_binding ?producer ?producer_routing)
        (consumer_routing_binding ?consumer ?consumer_routing)
        (producer_routing_secured ?producer_routing)
        (consumer_routing_ready ?consumer_routing)
        (not
          (producer_confirmed ?producer)
        )
        (consumer_confirmed ?consumer)
        (message_slot_available ?message)
      )
    :effect
      (and
        (message_staged ?message)
        (message_bound_to_producer_routing ?message ?producer_routing)
        (message_bound_to_consumer_routing ?message ?consumer_routing)
        (message_requires_transformation ?message)
        (not
          (message_slot_available ?message)
        )
      )
  )
  (:action stage_message_with_middleware_required
    :parameters (?producer - producer_instance ?consumer - consumer_instance ?producer_routing - producer_routing ?consumer_routing - consumer_routing ?message - message_instance)
    :precondition
      (and
        (producer_ready ?producer)
        (consumer_ready ?consumer)
        (producer_routing_binding ?producer ?producer_routing)
        (consumer_routing_binding ?consumer ?consumer_routing)
        (producer_routing_ready ?producer_routing)
        (consumer_routing_secured ?consumer_routing)
        (producer_confirmed ?producer)
        (not
          (consumer_confirmed ?consumer)
        )
        (message_slot_available ?message)
      )
    :effect
      (and
        (message_staged ?message)
        (message_bound_to_producer_routing ?message ?producer_routing)
        (message_bound_to_consumer_routing ?message ?consumer_routing)
        (message_requires_middleware ?message)
        (not
          (message_slot_available ?message)
        )
      )
  )
  (:action stage_message_with_transformation_and_middleware
    :parameters (?producer - producer_instance ?consumer - consumer_instance ?producer_routing - producer_routing ?consumer_routing - consumer_routing ?message - message_instance)
    :precondition
      (and
        (producer_ready ?producer)
        (consumer_ready ?consumer)
        (producer_routing_binding ?producer ?producer_routing)
        (consumer_routing_binding ?consumer ?consumer_routing)
        (producer_routing_secured ?producer_routing)
        (consumer_routing_secured ?consumer_routing)
        (not
          (producer_confirmed ?producer)
        )
        (not
          (consumer_confirmed ?consumer)
        )
        (message_slot_available ?message)
      )
    :effect
      (and
        (message_staged ?message)
        (message_bound_to_producer_routing ?message ?producer_routing)
        (message_bound_to_consumer_routing ?message ?consumer_routing)
        (message_requires_transformation ?message)
        (message_requires_middleware ?message)
        (not
          (message_slot_available ?message)
        )
      )
  )
  (:action mark_message_schema_ready
    :parameters (?message - message_instance ?producer - producer_instance ?message_type - message_type)
    :precondition
      (and
        (message_staged ?message)
        (producer_ready ?producer)
        (entity_message_type_binding ?producer ?message_type)
        (not
          (message_schema_ready ?message)
        )
      )
    :effect (message_schema_ready ?message)
  )
  (:action bind_schema_to_message
    :parameters (?broker_resource - broker_resource ?schema - schema_artifact ?message - message_instance)
    :precondition
      (and
        (entity_configured ?broker_resource)
        (resource_has_message ?broker_resource ?message)
        (resource_schema_binding ?broker_resource ?schema)
        (schema_available ?schema)
        (message_staged ?message)
        (message_schema_ready ?message)
        (not
          (schema_consumed ?schema)
        )
      )
    :effect
      (and
        (schema_consumed ?schema)
        (schema_bound_to_message ?schema ?message)
        (not
          (schema_available ?schema)
        )
      )
  )
  (:action prepare_resource_for_processing
    :parameters (?broker_resource - broker_resource ?schema - schema_artifact ?message - message_instance ?message_type - message_type)
    :precondition
      (and
        (entity_configured ?broker_resource)
        (resource_schema_binding ?broker_resource ?schema)
        (schema_consumed ?schema)
        (schema_bound_to_message ?schema ?message)
        (entity_message_type_binding ?broker_resource ?message_type)
        (not
          (message_requires_transformation ?message)
        )
        (not
          (resource_prepared ?broker_resource)
        )
      )
    :effect (resource_prepared ?broker_resource)
  )
  (:action bind_transform_plugin_to_resource
    :parameters (?broker_resource - broker_resource ?transform_plugin - transformation_plugin)
    :precondition
      (and
        (entity_configured ?broker_resource)
        (transform_plugin_available ?transform_plugin)
        (not
          (resource_plugin_bound ?broker_resource)
        )
      )
    :effect
      (and
        (resource_plugin_bound ?broker_resource)
        (resource_transform_plugin_binding ?broker_resource ?transform_plugin)
        (not
          (transform_plugin_available ?transform_plugin)
        )
      )
  )
  (:action activate_resource_plugin_pipeline
    :parameters (?broker_resource - broker_resource ?schema - schema_artifact ?message - message_instance ?message_type - message_type ?transform_plugin - transformation_plugin)
    :precondition
      (and
        (entity_configured ?broker_resource)
        (resource_schema_binding ?broker_resource ?schema)
        (schema_consumed ?schema)
        (schema_bound_to_message ?schema ?message)
        (entity_message_type_binding ?broker_resource ?message_type)
        (message_requires_transformation ?message)
        (resource_plugin_bound ?broker_resource)
        (resource_transform_plugin_binding ?broker_resource ?transform_plugin)
        (not
          (resource_prepared ?broker_resource)
        )
      )
    :effect
      (and
        (resource_prepared ?broker_resource)
        (resource_plugin_initialized ?broker_resource)
      )
  )
  (:action activate_resource_middleware_path_a
    :parameters (?broker_resource - broker_resource ?runtime_middleware - runtime_middleware ?config_profile - configuration_profile ?schema - schema_artifact ?message - message_instance)
    :precondition
      (and
        (resource_prepared ?broker_resource)
        (resource_runtime_middleware_binding ?broker_resource ?runtime_middleware)
        (entity_configuration_profile_binding ?broker_resource ?config_profile)
        (resource_schema_binding ?broker_resource ?schema)
        (schema_bound_to_message ?schema ?message)
        (not
          (message_requires_middleware ?message)
        )
        (not
          (resource_middleware_initialized ?broker_resource)
        )
      )
    :effect (resource_middleware_initialized ?broker_resource)
  )
  (:action activate_resource_middleware_path_b
    :parameters (?broker_resource - broker_resource ?runtime_middleware - runtime_middleware ?config_profile - configuration_profile ?schema - schema_artifact ?message - message_instance)
    :precondition
      (and
        (resource_prepared ?broker_resource)
        (resource_runtime_middleware_binding ?broker_resource ?runtime_middleware)
        (entity_configuration_profile_binding ?broker_resource ?config_profile)
        (resource_schema_binding ?broker_resource ?schema)
        (schema_bound_to_message ?schema ?message)
        (message_requires_middleware ?message)
        (not
          (resource_middleware_initialized ?broker_resource)
        )
      )
    :effect (resource_middleware_initialized ?broker_resource)
  )
  (:action validate_resource_delivery_policy_path_a
    :parameters (?broker_resource - broker_resource ?delivery_policy - delivery_policy ?schema - schema_artifact ?message - message_instance)
    :precondition
      (and
        (resource_middleware_initialized ?broker_resource)
        (resource_delivery_policy_binding ?broker_resource ?delivery_policy)
        (resource_schema_binding ?broker_resource ?schema)
        (schema_bound_to_message ?schema ?message)
        (not
          (message_requires_transformation ?message)
        )
        (not
          (message_requires_middleware ?message)
        )
        (not
          (resource_validated ?broker_resource)
        )
      )
    :effect (resource_validated ?broker_resource)
  )
  (:action validate_resource_delivery_policy_path_b
    :parameters (?broker_resource - broker_resource ?delivery_policy - delivery_policy ?schema - schema_artifact ?message - message_instance)
    :precondition
      (and
        (resource_middleware_initialized ?broker_resource)
        (resource_delivery_policy_binding ?broker_resource ?delivery_policy)
        (resource_schema_binding ?broker_resource ?schema)
        (schema_bound_to_message ?schema ?message)
        (message_requires_transformation ?message)
        (not
          (message_requires_middleware ?message)
        )
        (not
          (resource_validated ?broker_resource)
        )
      )
    :effect
      (and
        (resource_validated ?broker_resource)
        (resource_processing_pipeline_configured ?broker_resource)
      )
  )
  (:action validate_resource_delivery_policy_path_c
    :parameters (?broker_resource - broker_resource ?delivery_policy - delivery_policy ?schema - schema_artifact ?message - message_instance)
    :precondition
      (and
        (resource_middleware_initialized ?broker_resource)
        (resource_delivery_policy_binding ?broker_resource ?delivery_policy)
        (resource_schema_binding ?broker_resource ?schema)
        (schema_bound_to_message ?schema ?message)
        (not
          (message_requires_transformation ?message)
        )
        (message_requires_middleware ?message)
        (not
          (resource_validated ?broker_resource)
        )
      )
    :effect
      (and
        (resource_validated ?broker_resource)
        (resource_processing_pipeline_configured ?broker_resource)
      )
  )
  (:action validate_resource_delivery_policy_path_d
    :parameters (?broker_resource - broker_resource ?delivery_policy - delivery_policy ?schema - schema_artifact ?message - message_instance)
    :precondition
      (and
        (resource_middleware_initialized ?broker_resource)
        (resource_delivery_policy_binding ?broker_resource ?delivery_policy)
        (resource_schema_binding ?broker_resource ?schema)
        (schema_bound_to_message ?schema ?message)
        (message_requires_transformation ?message)
        (message_requires_middleware ?message)
        (not
          (resource_validated ?broker_resource)
        )
      )
    :effect
      (and
        (resource_validated ?broker_resource)
        (resource_processing_pipeline_configured ?broker_resource)
      )
  )
  (:action finalize_broker_resource_commitment
    :parameters (?broker_resource - broker_resource)
    :precondition
      (and
        (resource_validated ?broker_resource)
        (not
          (resource_processing_pipeline_configured ?broker_resource)
        )
        (not
          (resource_finalized ?broker_resource)
        )
      )
    :effect
      (and
        (resource_finalized ?broker_resource)
        (finalization_ready ?broker_resource)
      )
  )
  (:action bind_traffic_policy_to_resource
    :parameters (?broker_resource - broker_resource ?traffic_policy - traffic_policy)
    :precondition
      (and
        (resource_validated ?broker_resource)
        (resource_processing_pipeline_configured ?broker_resource)
        (traffic_policy_available ?traffic_policy)
      )
    :effect
      (and
        (resource_traffic_policy_binding ?broker_resource ?traffic_policy)
        (not
          (traffic_policy_available ?traffic_policy)
        )
      )
  )
  (:action authorize_and_prepare_resource_for_runtime
    :parameters (?broker_resource - broker_resource ?producer - producer_instance ?consumer - consumer_instance ?message_type - message_type ?traffic_policy - traffic_policy)
    :precondition
      (and
        (resource_validated ?broker_resource)
        (resource_processing_pipeline_configured ?broker_resource)
        (resource_traffic_policy_binding ?broker_resource ?traffic_policy)
        (resource_producer_binding ?broker_resource ?producer)
        (resource_consumer_binding ?broker_resource ?consumer)
        (producer_confirmed ?producer)
        (consumer_confirmed ?consumer)
        (entity_message_type_binding ?broker_resource ?message_type)
        (not
          (resource_activation_ready ?broker_resource)
        )
      )
    :effect (resource_activation_ready ?broker_resource)
  )
  (:action finalize_resource_activation
    :parameters (?broker_resource - broker_resource)
    :precondition
      (and
        (resource_validated ?broker_resource)
        (resource_activation_ready ?broker_resource)
        (not
          (resource_finalized ?broker_resource)
        )
      )
    :effect
      (and
        (resource_finalized ?broker_resource)
        (finalization_ready ?broker_resource)
      )
  )
  (:action bind_authorization_policy_to_resource
    :parameters (?broker_resource - broker_resource ?auth_policy - authorization_policy ?message_type - message_type)
    :precondition
      (and
        (entity_configured ?broker_resource)
        (entity_message_type_binding ?broker_resource ?message_type)
        (authorization_policy_available ?auth_policy)
        (resource_authorization_binding ?broker_resource ?auth_policy)
        (not
          (resource_authorization_enabled ?broker_resource)
        )
      )
    :effect
      (and
        (resource_authorization_enabled ?broker_resource)
        (not
          (authorization_policy_available ?auth_policy)
        )
      )
  )
  (:action enable_resource_authorization_step
    :parameters (?broker_resource - broker_resource ?config_profile - configuration_profile)
    :precondition
      (and
        (resource_authorization_enabled ?broker_resource)
        (entity_configuration_profile_binding ?broker_resource ?config_profile)
        (not
          (resource_authorization_step_completed ?broker_resource)
        )
      )
    :effect (resource_authorization_step_completed ?broker_resource)
  )
  (:action attach_delivery_policy_to_resource_authorization
    :parameters (?broker_resource - broker_resource ?delivery_policy - delivery_policy)
    :precondition
      (and
        (resource_authorization_step_completed ?broker_resource)
        (resource_delivery_policy_binding ?broker_resource ?delivery_policy)
        (not
          (resource_authorization_finalized ?broker_resource)
        )
      )
    :effect (resource_authorization_finalized ?broker_resource)
  )
  (:action complete_resource_authorization
    :parameters (?broker_resource - broker_resource)
    :precondition
      (and
        (resource_authorization_finalized ?broker_resource)
        (not
          (resource_finalized ?broker_resource)
        )
      )
    :effect
      (and
        (resource_finalized ?broker_resource)
        (finalization_ready ?broker_resource)
      )
  )
  (:action activate_producer_integration
    :parameters (?producer - producer_instance ?message - message_instance)
    :precondition
      (and
        (producer_ready ?producer)
        (producer_confirmed ?producer)
        (message_staged ?message)
        (message_schema_ready ?message)
        (not
          (finalization_ready ?producer)
        )
      )
    :effect (finalization_ready ?producer)
  )
  (:action activate_consumer_integration
    :parameters (?consumer - consumer_instance ?message - message_instance)
    :precondition
      (and
        (consumer_ready ?consumer)
        (consumer_confirmed ?consumer)
        (message_staged ?message)
        (message_schema_ready ?message)
        (not
          (finalization_ready ?consumer)
        )
      )
    :effect (finalization_ready ?consumer)
  )
  (:action configure_component_observability
    :parameters (?component - application_component ?observability_config - observability_configuration ?message_type - message_type)
    :precondition
      (and
        (finalization_ready ?component)
        (entity_message_type_binding ?component ?message_type)
        (observability_config_available ?observability_config)
        (not
          (entity_observability_configured ?component)
        )
      )
    :effect
      (and
        (entity_observability_configured ?component)
        (entity_observability_configuration_binding ?component ?observability_config)
        (not
          (observability_config_available ?observability_config)
        )
      )
  )
  (:action finalize_component_integration
    :parameters (?producer - producer_instance ?connector - connector_resource ?observability_config - observability_configuration)
    :precondition
      (and
        (entity_observability_configured ?producer)
        (entity_connector_binding ?producer ?connector)
        (entity_observability_configuration_binding ?producer ?observability_config)
        (not
          (integration_complete ?producer)
        )
      )
    :effect
      (and
        (integration_complete ?producer)
        (connector_available ?connector)
        (observability_config_available ?observability_config)
      )
  )
  (:action finalize_consumer_integration
    :parameters (?consumer - consumer_instance ?connector - connector_resource ?observability_config - observability_configuration)
    :precondition
      (and
        (entity_observability_configured ?consumer)
        (entity_connector_binding ?consumer ?connector)
        (entity_observability_configuration_binding ?consumer ?observability_config)
        (not
          (integration_complete ?consumer)
        )
      )
    :effect
      (and
        (integration_complete ?consumer)
        (connector_available ?connector)
        (observability_config_available ?observability_config)
      )
  )
  (:action finalize_resource_integration
    :parameters (?broker_resource - broker_resource ?connector - connector_resource ?observability_config - observability_configuration)
    :precondition
      (and
        (entity_observability_configured ?broker_resource)
        (entity_connector_binding ?broker_resource ?connector)
        (entity_observability_configuration_binding ?broker_resource ?observability_config)
        (not
          (integration_complete ?broker_resource)
        )
      )
    :effect
      (and
        (integration_complete ?broker_resource)
        (connector_available ?connector)
        (observability_config_available ?observability_config)
      )
  )
)

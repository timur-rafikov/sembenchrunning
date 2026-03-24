(define (domain request_processing_pipeline)
  (:requirements :strips :typing :negative-preconditions)
  (:types component - object interface - object attribute - object request_category - object request - request_category connection_resource - component handler_instance - component shared_resource - component configuration_feature - component credential - component output_destination - component optional_dependency - component policy_token - component auxiliary_payload - interface data_artifact - interface optional_capability - interface ingress_channel - attribute egress_channel - attribute processing_job - attribute endpoint_group - request controller_group - request ingress_node - endpoint_group egress_node - endpoint_group pipeline_controller - controller_group)
  (:predicates
    (entity_enqueued ?request - request)
    (entity_active ?request - request)
    (request_connection_reserved ?request - request)
    (entity_released ?request - request)
    (entity_finalization_token_emitted ?request - request)
    (entity_finalized ?request - request)
    (connection_available ?connection_resource - connection_resource)
    (entity_connection_binding ?request - request ?connection_resource - connection_resource)
    (handler_available ?handler_instance - handler_instance)
    (entity_handler_bound ?request - request ?handler_instance - handler_instance)
    (shared_resource_available ?shared_resource - shared_resource)
    (entity_shared_resource_bound ?request - request ?shared_resource - shared_resource)
    (aux_payload_available ?auxiliary_payload - auxiliary_payload)
    (ingress_node_payload_attached ?ingress_node - ingress_node ?auxiliary_payload - auxiliary_payload)
    (egress_node_payload_attached ?egress_node - egress_node ?auxiliary_payload - auxiliary_payload)
    (ingress_node_channel_bound ?ingress_node - ingress_node ?ingress_channel - ingress_channel)
    (ingress_channel_ready ?ingress_channel - ingress_channel)
    (ingress_channel_has_payload ?ingress_channel - ingress_channel)
    (ingress_node_processed ?ingress_node - ingress_node)
    (egress_node_channel_bound ?egress_node - egress_node ?egress_channel - egress_channel)
    (egress_channel_ready ?egress_channel - egress_channel)
    (egress_channel_has_payload ?egress_channel - egress_channel)
    (egress_node_processed ?egress_node - egress_node)
    (processing_job_pending ?processing_job - processing_job)
    (processing_job_active ?processing_job - processing_job)
    (processing_job_ingress_channel_bound ?processing_job - processing_job ?ingress_channel - ingress_channel)
    (processing_job_egress_channel_bound ?processing_job - processing_job ?egress_channel - egress_channel)
    (processing_job_flag_secondary ?processing_job - processing_job)
    (processing_job_flag_tertiary ?processing_job - processing_job)
    (processing_job_executed ?processing_job - processing_job)
    (controller_manages_ingress_node ?pipeline_controller - pipeline_controller ?ingress_node - ingress_node)
    (controller_manages_egress_node ?pipeline_controller - pipeline_controller ?egress_node - egress_node)
    (controller_assigned_job ?pipeline_controller - pipeline_controller ?processing_job - processing_job)
    (data_artifact_available ?data_artifact - data_artifact)
    (controller_has_artifact ?pipeline_controller - pipeline_controller ?data_artifact - data_artifact)
    (data_artifact_claimed ?data_artifact - data_artifact)
    (artifact_bound_to_job ?data_artifact - data_artifact ?processing_job - processing_job)
    (controller_configured ?pipeline_controller - pipeline_controller)
    (controller_prepared_for_execution ?pipeline_controller - pipeline_controller)
    (controller_ready ?pipeline_controller - pipeline_controller)
    (controller_configuration_applied ?pipeline_controller - pipeline_controller)
    (controller_feature_marked ?pipeline_controller - pipeline_controller)
    (controller_has_capability ?pipeline_controller - pipeline_controller)
    (controller_execution_committed ?pipeline_controller - pipeline_controller)
    (optional_capability_available ?optional_capability - optional_capability)
    (controller_has_optional_capability ?pipeline_controller - pipeline_controller ?optional_capability - optional_capability)
    (controller_capability_enabled ?pipeline_controller - pipeline_controller)
    (controller_capability_in_progress ?pipeline_controller - pipeline_controller)
    (controller_capability_finalized ?pipeline_controller - pipeline_controller)
    (configuration_feature_available ?configuration_feature - configuration_feature)
    (controller_configuration_attached ?pipeline_controller - pipeline_controller ?configuration_feature - configuration_feature)
    (credential_available ?credential - credential)
    (controller_credential_bound ?pipeline_controller - pipeline_controller ?credential - credential)
    (optional_dependency_available ?optional_dependency - optional_dependency)
    (controller_has_optional_dependency ?pipeline_controller - pipeline_controller ?optional_dependency - optional_dependency)
    (policy_token_available ?policy_token - policy_token)
    (controller_policy_token_bound ?pipeline_controller - pipeline_controller ?policy_token - policy_token)
    (output_destination_available ?output_destination - output_destination)
    (entity_output_destination_assigned ?request - request ?output_destination - output_destination)
    (ingress_node_ready ?ingress_node - ingress_node)
    (egress_node_ready ?egress_node - egress_node)
    (controller_finalized ?pipeline_controller - pipeline_controller)
  )
  (:action ingress_receive_enqueue
    :parameters (?request - request)
    :precondition
      (and
        (not
          (entity_enqueued ?request)
        )
        (not
          (entity_released ?request)
        )
      )
    :effect (entity_enqueued ?request)
  )
  (:action assign_connection_to_request
    :parameters (?request - request ?connection_resource - connection_resource)
    :precondition
      (and
        (entity_enqueued ?request)
        (not
          (request_connection_reserved ?request)
        )
        (connection_available ?connection_resource)
      )
    :effect
      (and
        (request_connection_reserved ?request)
        (entity_connection_binding ?request ?connection_resource)
        (not
          (connection_available ?connection_resource)
        )
      )
  )
  (:action bind_handler_to_request
    :parameters (?request - request ?handler_instance - handler_instance)
    :precondition
      (and
        (entity_enqueued ?request)
        (request_connection_reserved ?request)
        (handler_available ?handler_instance)
      )
    :effect
      (and
        (entity_handler_bound ?request ?handler_instance)
        (not
          (handler_available ?handler_instance)
        )
      )
  )
  (:action activate_request
    :parameters (?request - request ?handler_instance - handler_instance)
    :precondition
      (and
        (entity_enqueued ?request)
        (request_connection_reserved ?request)
        (entity_handler_bound ?request ?handler_instance)
        (not
          (entity_active ?request)
        )
      )
    :effect (entity_active ?request)
  )
  (:action release_handler_from_request
    :parameters (?request - request ?handler_instance - handler_instance)
    :precondition
      (and
        (entity_handler_bound ?request ?handler_instance)
      )
    :effect
      (and
        (handler_available ?handler_instance)
        (not
          (entity_handler_bound ?request ?handler_instance)
        )
      )
  )
  (:action acquire_shared_resource
    :parameters (?request - request ?shared_resource - shared_resource)
    :precondition
      (and
        (entity_active ?request)
        (shared_resource_available ?shared_resource)
      )
    :effect
      (and
        (entity_shared_resource_bound ?request ?shared_resource)
        (not
          (shared_resource_available ?shared_resource)
        )
      )
  )
  (:action release_shared_resource
    :parameters (?request - request ?shared_resource - shared_resource)
    :precondition
      (and
        (entity_shared_resource_bound ?request ?shared_resource)
      )
    :effect
      (and
        (shared_resource_available ?shared_resource)
        (not
          (entity_shared_resource_bound ?request ?shared_resource)
        )
      )
  )
  (:action attach_optional_dependency_to_controller
    :parameters (?pipeline_controller - pipeline_controller ?optional_dependency - optional_dependency)
    :precondition
      (and
        (entity_active ?pipeline_controller)
        (optional_dependency_available ?optional_dependency)
      )
    :effect
      (and
        (controller_has_optional_dependency ?pipeline_controller ?optional_dependency)
        (not
          (optional_dependency_available ?optional_dependency)
        )
      )
  )
  (:action detach_optional_dependency_from_controller
    :parameters (?pipeline_controller - pipeline_controller ?optional_dependency - optional_dependency)
    :precondition
      (and
        (controller_has_optional_dependency ?pipeline_controller ?optional_dependency)
      )
    :effect
      (and
        (optional_dependency_available ?optional_dependency)
        (not
          (controller_has_optional_dependency ?pipeline_controller ?optional_dependency)
        )
      )
  )
  (:action bind_policy_token_to_controller
    :parameters (?pipeline_controller - pipeline_controller ?policy_token - policy_token)
    :precondition
      (and
        (entity_active ?pipeline_controller)
        (policy_token_available ?policy_token)
      )
    :effect
      (and
        (controller_policy_token_bound ?pipeline_controller ?policy_token)
        (not
          (policy_token_available ?policy_token)
        )
      )
  )
  (:action unbind_policy_token_from_controller
    :parameters (?pipeline_controller - pipeline_controller ?policy_token - policy_token)
    :precondition
      (and
        (controller_policy_token_bound ?pipeline_controller ?policy_token)
      )
    :effect
      (and
        (policy_token_available ?policy_token)
        (not
          (controller_policy_token_bound ?pipeline_controller ?policy_token)
        )
      )
  )
  (:action mark_ingress_channel_ready
    :parameters (?ingress_node - ingress_node ?ingress_channel - ingress_channel ?handler_instance - handler_instance)
    :precondition
      (and
        (entity_active ?ingress_node)
        (entity_handler_bound ?ingress_node ?handler_instance)
        (ingress_node_channel_bound ?ingress_node ?ingress_channel)
        (not
          (ingress_channel_ready ?ingress_channel)
        )
        (not
          (ingress_channel_has_payload ?ingress_channel)
        )
      )
    :effect (ingress_channel_ready ?ingress_channel)
  )
  (:action process_ingress_with_shared_resource
    :parameters (?ingress_node - ingress_node ?ingress_channel - ingress_channel ?shared_resource - shared_resource)
    :precondition
      (and
        (entity_active ?ingress_node)
        (entity_shared_resource_bound ?ingress_node ?shared_resource)
        (ingress_node_channel_bound ?ingress_node ?ingress_channel)
        (ingress_channel_ready ?ingress_channel)
        (not
          (ingress_node_ready ?ingress_node)
        )
      )
    :effect
      (and
        (ingress_node_ready ?ingress_node)
        (ingress_node_processed ?ingress_node)
      )
  )
  (:action attach_payload_to_ingress
    :parameters (?ingress_node - ingress_node ?ingress_channel - ingress_channel ?auxiliary_payload - auxiliary_payload)
    :precondition
      (and
        (entity_active ?ingress_node)
        (ingress_node_channel_bound ?ingress_node ?ingress_channel)
        (aux_payload_available ?auxiliary_payload)
        (not
          (ingress_node_ready ?ingress_node)
        )
      )
    :effect
      (and
        (ingress_channel_has_payload ?ingress_channel)
        (ingress_node_ready ?ingress_node)
        (ingress_node_payload_attached ?ingress_node ?auxiliary_payload)
        (not
          (aux_payload_available ?auxiliary_payload)
        )
      )
  )
  (:action ingress_finalize_payload_transfer
    :parameters (?ingress_node - ingress_node ?ingress_channel - ingress_channel ?handler_instance - handler_instance ?auxiliary_payload - auxiliary_payload)
    :precondition
      (and
        (entity_active ?ingress_node)
        (entity_handler_bound ?ingress_node ?handler_instance)
        (ingress_node_channel_bound ?ingress_node ?ingress_channel)
        (ingress_channel_has_payload ?ingress_channel)
        (ingress_node_payload_attached ?ingress_node ?auxiliary_payload)
        (not
          (ingress_node_processed ?ingress_node)
        )
      )
    :effect
      (and
        (ingress_channel_ready ?ingress_channel)
        (ingress_node_processed ?ingress_node)
        (aux_payload_available ?auxiliary_payload)
        (not
          (ingress_node_payload_attached ?ingress_node ?auxiliary_payload)
        )
      )
  )
  (:action mark_egress_channel_ready
    :parameters (?egress_node - egress_node ?egress_channel - egress_channel ?handler_instance - handler_instance)
    :precondition
      (and
        (entity_active ?egress_node)
        (entity_handler_bound ?egress_node ?handler_instance)
        (egress_node_channel_bound ?egress_node ?egress_channel)
        (not
          (egress_channel_ready ?egress_channel)
        )
        (not
          (egress_channel_has_payload ?egress_channel)
        )
      )
    :effect (egress_channel_ready ?egress_channel)
  )
  (:action process_egress_with_shared_resource
    :parameters (?egress_node - egress_node ?egress_channel - egress_channel ?shared_resource - shared_resource)
    :precondition
      (and
        (entity_active ?egress_node)
        (entity_shared_resource_bound ?egress_node ?shared_resource)
        (egress_node_channel_bound ?egress_node ?egress_channel)
        (egress_channel_ready ?egress_channel)
        (not
          (egress_node_ready ?egress_node)
        )
      )
    :effect
      (and
        (egress_node_ready ?egress_node)
        (egress_node_processed ?egress_node)
      )
  )
  (:action attach_payload_to_egress
    :parameters (?egress_node - egress_node ?egress_channel - egress_channel ?auxiliary_payload - auxiliary_payload)
    :precondition
      (and
        (entity_active ?egress_node)
        (egress_node_channel_bound ?egress_node ?egress_channel)
        (aux_payload_available ?auxiliary_payload)
        (not
          (egress_node_ready ?egress_node)
        )
      )
    :effect
      (and
        (egress_channel_has_payload ?egress_channel)
        (egress_node_ready ?egress_node)
        (egress_node_payload_attached ?egress_node ?auxiliary_payload)
        (not
          (aux_payload_available ?auxiliary_payload)
        )
      )
  )
  (:action egress_finalize_payload_transfer
    :parameters (?egress_node - egress_node ?egress_channel - egress_channel ?handler_instance - handler_instance ?auxiliary_payload - auxiliary_payload)
    :precondition
      (and
        (entity_active ?egress_node)
        (entity_handler_bound ?egress_node ?handler_instance)
        (egress_node_channel_bound ?egress_node ?egress_channel)
        (egress_channel_has_payload ?egress_channel)
        (egress_node_payload_attached ?egress_node ?auxiliary_payload)
        (not
          (egress_node_processed ?egress_node)
        )
      )
    :effect
      (and
        (egress_channel_ready ?egress_channel)
        (egress_node_processed ?egress_node)
        (aux_payload_available ?auxiliary_payload)
        (not
          (egress_node_payload_attached ?egress_node ?auxiliary_payload)
        )
      )
  )
  (:action assemble_processing_job
    :parameters (?ingress_node - ingress_node ?egress_node - egress_node ?ingress_channel - ingress_channel ?egress_channel - egress_channel ?processing_job - processing_job)
    :precondition
      (and
        (ingress_node_ready ?ingress_node)
        (egress_node_ready ?egress_node)
        (ingress_node_channel_bound ?ingress_node ?ingress_channel)
        (egress_node_channel_bound ?egress_node ?egress_channel)
        (ingress_channel_ready ?ingress_channel)
        (egress_channel_ready ?egress_channel)
        (ingress_node_processed ?ingress_node)
        (egress_node_processed ?egress_node)
        (processing_job_pending ?processing_job)
      )
    :effect
      (and
        (processing_job_active ?processing_job)
        (processing_job_ingress_channel_bound ?processing_job ?ingress_channel)
        (processing_job_egress_channel_bound ?processing_job ?egress_channel)
        (not
          (processing_job_pending ?processing_job)
        )
      )
  )
  (:action assemble_processing_job_with_ingress_payload
    :parameters (?ingress_node - ingress_node ?egress_node - egress_node ?ingress_channel - ingress_channel ?egress_channel - egress_channel ?processing_job - processing_job)
    :precondition
      (and
        (ingress_node_ready ?ingress_node)
        (egress_node_ready ?egress_node)
        (ingress_node_channel_bound ?ingress_node ?ingress_channel)
        (egress_node_channel_bound ?egress_node ?egress_channel)
        (ingress_channel_has_payload ?ingress_channel)
        (egress_channel_ready ?egress_channel)
        (not
          (ingress_node_processed ?ingress_node)
        )
        (egress_node_processed ?egress_node)
        (processing_job_pending ?processing_job)
      )
    :effect
      (and
        (processing_job_active ?processing_job)
        (processing_job_ingress_channel_bound ?processing_job ?ingress_channel)
        (processing_job_egress_channel_bound ?processing_job ?egress_channel)
        (processing_job_flag_secondary ?processing_job)
        (not
          (processing_job_pending ?processing_job)
        )
      )
  )
  (:action assemble_processing_job_with_egress_payload
    :parameters (?ingress_node - ingress_node ?egress_node - egress_node ?ingress_channel - ingress_channel ?egress_channel - egress_channel ?processing_job - processing_job)
    :precondition
      (and
        (ingress_node_ready ?ingress_node)
        (egress_node_ready ?egress_node)
        (ingress_node_channel_bound ?ingress_node ?ingress_channel)
        (egress_node_channel_bound ?egress_node ?egress_channel)
        (ingress_channel_ready ?ingress_channel)
        (egress_channel_has_payload ?egress_channel)
        (ingress_node_processed ?ingress_node)
        (not
          (egress_node_processed ?egress_node)
        )
        (processing_job_pending ?processing_job)
      )
    :effect
      (and
        (processing_job_active ?processing_job)
        (processing_job_ingress_channel_bound ?processing_job ?ingress_channel)
        (processing_job_egress_channel_bound ?processing_job ?egress_channel)
        (processing_job_flag_tertiary ?processing_job)
        (not
          (processing_job_pending ?processing_job)
        )
      )
  )
  (:action assemble_processing_job_with_both_payloads
    :parameters (?ingress_node - ingress_node ?egress_node - egress_node ?ingress_channel - ingress_channel ?egress_channel - egress_channel ?processing_job - processing_job)
    :precondition
      (and
        (ingress_node_ready ?ingress_node)
        (egress_node_ready ?egress_node)
        (ingress_node_channel_bound ?ingress_node ?ingress_channel)
        (egress_node_channel_bound ?egress_node ?egress_channel)
        (ingress_channel_has_payload ?ingress_channel)
        (egress_channel_has_payload ?egress_channel)
        (not
          (ingress_node_processed ?ingress_node)
        )
        (not
          (egress_node_processed ?egress_node)
        )
        (processing_job_pending ?processing_job)
      )
    :effect
      (and
        (processing_job_active ?processing_job)
        (processing_job_ingress_channel_bound ?processing_job ?ingress_channel)
        (processing_job_egress_channel_bound ?processing_job ?egress_channel)
        (processing_job_flag_secondary ?processing_job)
        (processing_job_flag_tertiary ?processing_job)
        (not
          (processing_job_pending ?processing_job)
        )
      )
  )
  (:action execute_processing_job
    :parameters (?processing_job - processing_job ?ingress_node - ingress_node ?handler_instance - handler_instance)
    :precondition
      (and
        (processing_job_active ?processing_job)
        (ingress_node_ready ?ingress_node)
        (entity_handler_bound ?ingress_node ?handler_instance)
        (not
          (processing_job_executed ?processing_job)
        )
      )
    :effect (processing_job_executed ?processing_job)
  )
  (:action stage_data_artifact_to_job
    :parameters (?pipeline_controller - pipeline_controller ?data_artifact - data_artifact ?processing_job - processing_job)
    :precondition
      (and
        (entity_active ?pipeline_controller)
        (controller_assigned_job ?pipeline_controller ?processing_job)
        (controller_has_artifact ?pipeline_controller ?data_artifact)
        (data_artifact_available ?data_artifact)
        (processing_job_active ?processing_job)
        (processing_job_executed ?processing_job)
        (not
          (data_artifact_claimed ?data_artifact)
        )
      )
    :effect
      (and
        (data_artifact_claimed ?data_artifact)
        (artifact_bound_to_job ?data_artifact ?processing_job)
        (not
          (data_artifact_available ?data_artifact)
        )
      )
  )
  (:action prepare_artifact_for_controller
    :parameters (?pipeline_controller - pipeline_controller ?data_artifact - data_artifact ?processing_job - processing_job ?handler_instance - handler_instance)
    :precondition
      (and
        (entity_active ?pipeline_controller)
        (controller_has_artifact ?pipeline_controller ?data_artifact)
        (data_artifact_claimed ?data_artifact)
        (artifact_bound_to_job ?data_artifact ?processing_job)
        (entity_handler_bound ?pipeline_controller ?handler_instance)
        (not
          (processing_job_flag_secondary ?processing_job)
        )
        (not
          (controller_configured ?pipeline_controller)
        )
      )
    :effect (controller_configured ?pipeline_controller)
  )
  (:action apply_configuration_to_controller
    :parameters (?pipeline_controller - pipeline_controller ?configuration_feature - configuration_feature)
    :precondition
      (and
        (entity_active ?pipeline_controller)
        (configuration_feature_available ?configuration_feature)
        (not
          (controller_configuration_applied ?pipeline_controller)
        )
      )
    :effect
      (and
        (controller_configuration_applied ?pipeline_controller)
        (controller_configuration_attached ?pipeline_controller ?configuration_feature)
        (not
          (configuration_feature_available ?configuration_feature)
        )
      )
  )
  (:action enable_controller_configuration_path
    :parameters (?pipeline_controller - pipeline_controller ?data_artifact - data_artifact ?processing_job - processing_job ?handler_instance - handler_instance ?configuration_feature - configuration_feature)
    :precondition
      (and
        (entity_active ?pipeline_controller)
        (controller_has_artifact ?pipeline_controller ?data_artifact)
        (data_artifact_claimed ?data_artifact)
        (artifact_bound_to_job ?data_artifact ?processing_job)
        (entity_handler_bound ?pipeline_controller ?handler_instance)
        (processing_job_flag_secondary ?processing_job)
        (controller_configuration_applied ?pipeline_controller)
        (controller_configuration_attached ?pipeline_controller ?configuration_feature)
        (not
          (controller_configured ?pipeline_controller)
        )
      )
    :effect
      (and
        (controller_configured ?pipeline_controller)
        (controller_feature_marked ?pipeline_controller)
      )
  )
  (:action apply_optional_dependency
    :parameters (?pipeline_controller - pipeline_controller ?optional_dependency - optional_dependency ?shared_resource - shared_resource ?data_artifact - data_artifact ?processing_job - processing_job)
    :precondition
      (and
        (controller_configured ?pipeline_controller)
        (controller_has_optional_dependency ?pipeline_controller ?optional_dependency)
        (entity_shared_resource_bound ?pipeline_controller ?shared_resource)
        (controller_has_artifact ?pipeline_controller ?data_artifact)
        (artifact_bound_to_job ?data_artifact ?processing_job)
        (not
          (processing_job_flag_tertiary ?processing_job)
        )
        (not
          (controller_prepared_for_execution ?pipeline_controller)
        )
      )
    :effect (controller_prepared_for_execution ?pipeline_controller)
  )
  (:action apply_optional_dependency_alternate
    :parameters (?pipeline_controller - pipeline_controller ?optional_dependency - optional_dependency ?shared_resource - shared_resource ?data_artifact - data_artifact ?processing_job - processing_job)
    :precondition
      (and
        (controller_configured ?pipeline_controller)
        (controller_has_optional_dependency ?pipeline_controller ?optional_dependency)
        (entity_shared_resource_bound ?pipeline_controller ?shared_resource)
        (controller_has_artifact ?pipeline_controller ?data_artifact)
        (artifact_bound_to_job ?data_artifact ?processing_job)
        (processing_job_flag_tertiary ?processing_job)
        (not
          (controller_prepared_for_execution ?pipeline_controller)
        )
      )
    :effect (controller_prepared_for_execution ?pipeline_controller)
  )
  (:action apply_policy_and_prepare_controller
    :parameters (?pipeline_controller - pipeline_controller ?policy_token - policy_token ?data_artifact - data_artifact ?processing_job - processing_job)
    :precondition
      (and
        (controller_prepared_for_execution ?pipeline_controller)
        (controller_policy_token_bound ?pipeline_controller ?policy_token)
        (controller_has_artifact ?pipeline_controller ?data_artifact)
        (artifact_bound_to_job ?data_artifact ?processing_job)
        (not
          (processing_job_flag_secondary ?processing_job)
        )
        (not
          (processing_job_flag_tertiary ?processing_job)
        )
        (not
          (controller_ready ?pipeline_controller)
        )
      )
    :effect (controller_ready ?pipeline_controller)
  )
  (:action apply_policy_and_prepare_controller_with_flag
    :parameters (?pipeline_controller - pipeline_controller ?policy_token - policy_token ?data_artifact - data_artifact ?processing_job - processing_job)
    :precondition
      (and
        (controller_prepared_for_execution ?pipeline_controller)
        (controller_policy_token_bound ?pipeline_controller ?policy_token)
        (controller_has_artifact ?pipeline_controller ?data_artifact)
        (artifact_bound_to_job ?data_artifact ?processing_job)
        (processing_job_flag_secondary ?processing_job)
        (not
          (processing_job_flag_tertiary ?processing_job)
        )
        (not
          (controller_ready ?pipeline_controller)
        )
      )
    :effect
      (and
        (controller_ready ?pipeline_controller)
        (controller_has_capability ?pipeline_controller)
      )
  )
  (:action apply_policy_and_prepare_controller_alternate
    :parameters (?pipeline_controller - pipeline_controller ?policy_token - policy_token ?data_artifact - data_artifact ?processing_job - processing_job)
    :precondition
      (and
        (controller_prepared_for_execution ?pipeline_controller)
        (controller_policy_token_bound ?pipeline_controller ?policy_token)
        (controller_has_artifact ?pipeline_controller ?data_artifact)
        (artifact_bound_to_job ?data_artifact ?processing_job)
        (not
          (processing_job_flag_secondary ?processing_job)
        )
        (processing_job_flag_tertiary ?processing_job)
        (not
          (controller_ready ?pipeline_controller)
        )
      )
    :effect
      (and
        (controller_ready ?pipeline_controller)
        (controller_has_capability ?pipeline_controller)
      )
  )
  (:action apply_policy_and_prepare_controller_full
    :parameters (?pipeline_controller - pipeline_controller ?policy_token - policy_token ?data_artifact - data_artifact ?processing_job - processing_job)
    :precondition
      (and
        (controller_prepared_for_execution ?pipeline_controller)
        (controller_policy_token_bound ?pipeline_controller ?policy_token)
        (controller_has_artifact ?pipeline_controller ?data_artifact)
        (artifact_bound_to_job ?data_artifact ?processing_job)
        (processing_job_flag_secondary ?processing_job)
        (processing_job_flag_tertiary ?processing_job)
        (not
          (controller_ready ?pipeline_controller)
        )
      )
    :effect
      (and
        (controller_ready ?pipeline_controller)
        (controller_has_capability ?pipeline_controller)
      )
  )
  (:action controller_generate_completion_token
    :parameters (?pipeline_controller - pipeline_controller)
    :precondition
      (and
        (controller_ready ?pipeline_controller)
        (not
          (controller_has_capability ?pipeline_controller)
        )
        (not
          (controller_finalized ?pipeline_controller)
        )
      )
    :effect
      (and
        (controller_finalized ?pipeline_controller)
        (entity_finalization_token_emitted ?pipeline_controller)
      )
  )
  (:action bind_credential_to_controller
    :parameters (?pipeline_controller - pipeline_controller ?credential - credential)
    :precondition
      (and
        (controller_ready ?pipeline_controller)
        (controller_has_capability ?pipeline_controller)
        (credential_available ?credential)
      )
    :effect
      (and
        (controller_credential_bound ?pipeline_controller ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action commit_controller_execution
    :parameters (?pipeline_controller - pipeline_controller ?ingress_node - ingress_node ?egress_node - egress_node ?handler_instance - handler_instance ?credential - credential)
    :precondition
      (and
        (controller_ready ?pipeline_controller)
        (controller_has_capability ?pipeline_controller)
        (controller_credential_bound ?pipeline_controller ?credential)
        (controller_manages_ingress_node ?pipeline_controller ?ingress_node)
        (controller_manages_egress_node ?pipeline_controller ?egress_node)
        (ingress_node_processed ?ingress_node)
        (egress_node_processed ?egress_node)
        (entity_handler_bound ?pipeline_controller ?handler_instance)
        (not
          (controller_execution_committed ?pipeline_controller)
        )
      )
    :effect (controller_execution_committed ?pipeline_controller)
  )
  (:action controller_finalize_execution
    :parameters (?pipeline_controller - pipeline_controller)
    :precondition
      (and
        (controller_ready ?pipeline_controller)
        (controller_execution_committed ?pipeline_controller)
        (not
          (controller_finalized ?pipeline_controller)
        )
      )
    :effect
      (and
        (controller_finalized ?pipeline_controller)
        (entity_finalization_token_emitted ?pipeline_controller)
      )
  )
  (:action enable_controller_capability
    :parameters (?pipeline_controller - pipeline_controller ?optional_capability - optional_capability ?handler_instance - handler_instance)
    :precondition
      (and
        (entity_active ?pipeline_controller)
        (entity_handler_bound ?pipeline_controller ?handler_instance)
        (optional_capability_available ?optional_capability)
        (controller_has_optional_capability ?pipeline_controller ?optional_capability)
        (not
          (controller_capability_enabled ?pipeline_controller)
        )
      )
    :effect
      (and
        (controller_capability_enabled ?pipeline_controller)
        (not
          (optional_capability_available ?optional_capability)
        )
      )
  )
  (:action begin_controller_capability_execution
    :parameters (?pipeline_controller - pipeline_controller ?shared_resource - shared_resource)
    :precondition
      (and
        (controller_capability_enabled ?pipeline_controller)
        (entity_shared_resource_bound ?pipeline_controller ?shared_resource)
        (not
          (controller_capability_in_progress ?pipeline_controller)
        )
      )
    :effect (controller_capability_in_progress ?pipeline_controller)
  )
  (:action finalize_controller_capability_with_policy
    :parameters (?pipeline_controller - pipeline_controller ?policy_token - policy_token)
    :precondition
      (and
        (controller_capability_in_progress ?pipeline_controller)
        (controller_policy_token_bound ?pipeline_controller ?policy_token)
        (not
          (controller_capability_finalized ?pipeline_controller)
        )
      )
    :effect (controller_capability_finalized ?pipeline_controller)
  )
  (:action complete_controller_capability
    :parameters (?pipeline_controller - pipeline_controller)
    :precondition
      (and
        (controller_capability_finalized ?pipeline_controller)
        (not
          (controller_finalized ?pipeline_controller)
        )
      )
    :effect
      (and
        (controller_finalized ?pipeline_controller)
        (entity_finalization_token_emitted ?pipeline_controller)
      )
  )
  (:action notify_ingress_node_of_completion
    :parameters (?ingress_node - ingress_node ?processing_job - processing_job)
    :precondition
      (and
        (ingress_node_ready ?ingress_node)
        (ingress_node_processed ?ingress_node)
        (processing_job_active ?processing_job)
        (processing_job_executed ?processing_job)
        (not
          (entity_finalization_token_emitted ?ingress_node)
        )
      )
    :effect (entity_finalization_token_emitted ?ingress_node)
  )
  (:action notify_egress_node_of_completion
    :parameters (?egress_node - egress_node ?processing_job - processing_job)
    :precondition
      (and
        (egress_node_ready ?egress_node)
        (egress_node_processed ?egress_node)
        (processing_job_active ?processing_job)
        (processing_job_executed ?processing_job)
        (not
          (entity_finalization_token_emitted ?egress_node)
        )
      )
    :effect (entity_finalization_token_emitted ?egress_node)
  )
  (:action finalize_request_attach_output
    :parameters (?request - request ?output_destination - output_destination ?handler_instance - handler_instance)
    :precondition
      (and
        (entity_finalization_token_emitted ?request)
        (entity_handler_bound ?request ?handler_instance)
        (output_destination_available ?output_destination)
        (not
          (entity_finalized ?request)
        )
      )
    :effect
      (and
        (entity_finalized ?request)
        (entity_output_destination_assigned ?request ?output_destination)
        (not
          (output_destination_available ?output_destination)
        )
      )
  )
  (:action finalize_and_release_ingress_resources
    :parameters (?ingress_node - ingress_node ?connection_resource - connection_resource ?output_destination - output_destination)
    :precondition
      (and
        (entity_finalized ?ingress_node)
        (entity_connection_binding ?ingress_node ?connection_resource)
        (entity_output_destination_assigned ?ingress_node ?output_destination)
        (not
          (entity_released ?ingress_node)
        )
      )
    :effect
      (and
        (entity_released ?ingress_node)
        (connection_available ?connection_resource)
        (output_destination_available ?output_destination)
      )
  )
  (:action finalize_and_release_egress_resources
    :parameters (?egress_node - egress_node ?connection_resource - connection_resource ?output_destination - output_destination)
    :precondition
      (and
        (entity_finalized ?egress_node)
        (entity_connection_binding ?egress_node ?connection_resource)
        (entity_output_destination_assigned ?egress_node ?output_destination)
        (not
          (entity_released ?egress_node)
        )
      )
    :effect
      (and
        (entity_released ?egress_node)
        (connection_available ?connection_resource)
        (output_destination_available ?output_destination)
      )
  )
  (:action finalize_and_release_controller_resources
    :parameters (?pipeline_controller - pipeline_controller ?connection_resource - connection_resource ?output_destination - output_destination)
    :precondition
      (and
        (entity_finalized ?pipeline_controller)
        (entity_connection_binding ?pipeline_controller ?connection_resource)
        (entity_output_destination_assigned ?pipeline_controller ?output_destination)
        (not
          (entity_released ?pipeline_controller)
        )
      )
    :effect
      (and
        (entity_released ?pipeline_controller)
        (connection_available ?connection_resource)
        (output_destination_available ?output_destination)
      )
  )
)

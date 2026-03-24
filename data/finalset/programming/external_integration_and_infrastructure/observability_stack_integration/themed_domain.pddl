(define (domain observability_stack_integration)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object integration_artifact_group - entity source_artifact_group - entity backend_artifact_group - entity subject_category - entity observability_subject - subject_category connector - integration_artifact_group instrumentation_agent - integration_artifact_group operator_account - integration_artifact_group credential - integration_artifact_group policy - integration_artifact_group external_account - integration_artifact_group plugin - integration_artifact_group secret - integration_artifact_group config_snippet - source_artifact_group storage_bucket - source_artifact_group extension - source_artifact_group source_endpoint - backend_artifact_group source_stream - backend_artifact_group observability_sink - backend_artifact_group runtime_unit - observability_subject integration_unit - observability_subject application_instance - runtime_unit auxiliary_instance - runtime_unit integration_operator - integration_unit)

  (:predicates
    (subject_registered ?observability_subject - observability_subject)
    (subject_instrumented ?observability_subject - observability_subject)
    (subject_connector_assignment_marker ?observability_subject - observability_subject)
    (integration_activated ?observability_subject - observability_subject)
    (integration_acknowledged ?observability_subject - observability_subject)
    (subject_provisioned ?observability_subject - observability_subject)
    (connector_available ?connector - connector)
    (subject_uses_connector ?observability_subject - observability_subject ?connector - connector)
    (agent_available ?instrumentation_agent - instrumentation_agent)
    (subject_agent_attached ?observability_subject - observability_subject ?instrumentation_agent - instrumentation_agent)
    (operator_account_available ?operator_account - operator_account)
    (subject_operator_assigned ?observability_subject - observability_subject ?operator_account - operator_account)
    (config_snippet_available ?config_snippet - config_snippet)
    (application_config_applied ?application_instance - application_instance ?config_snippet - config_snippet)
    (auxiliary_config_applied ?auxiliary_instance - auxiliary_instance ?config_snippet - config_snippet)
    (application_endpoint_bound ?application_instance - application_instance ?source_endpoint - source_endpoint)
    (source_endpoint_verified ?source_endpoint - source_endpoint)
    (source_endpoint_configured ?source_endpoint - source_endpoint)
    (application_source_ready ?application_instance - application_instance)
    (auxiliary_stream_bound ?auxiliary_instance - auxiliary_instance ?source_stream - source_stream)
    (source_stream_verified ?source_stream - source_stream)
    (source_stream_configured ?source_stream - source_stream)
    (auxiliary_source_ready ?auxiliary_instance - auxiliary_instance)
    (sink_available ?observability_sink - observability_sink)
    (sink_created ?observability_sink - observability_sink)
    (sink_bound_to_endpoint ?observability_sink - observability_sink ?source_endpoint - source_endpoint)
    (sink_bound_to_stream ?observability_sink - observability_sink ?source_stream - source_stream)
    (sink_endpoint_ingestion_enabled ?observability_sink - observability_sink)
    (sink_stream_ingestion_enabled ?observability_sink - observability_sink)
    (sink_ingestion_verified ?observability_sink - observability_sink)
    (operator_manages_application ?integration_operator - integration_operator ?application_instance - application_instance)
    (operator_manages_auxiliary ?integration_operator - integration_operator ?auxiliary_instance - auxiliary_instance)
    (operator_manages_sink ?integration_operator - integration_operator ?observability_sink - observability_sink)
    (storage_bucket_available ?storage_bucket - storage_bucket)
    (operator_uses_bucket ?integration_operator - integration_operator ?storage_bucket - storage_bucket)
    (storage_bucket_provisioned ?storage_bucket - storage_bucket)
    (bucket_bound_to_sink ?storage_bucket - storage_bucket ?observability_sink - observability_sink)
    (operator_ready_for_pipeline_configuration ?integration_operator - integration_operator)
    (operator_pipeline_stage_ready ?integration_operator - integration_operator)
    (operator_configured ?integration_operator - integration_operator)
    (operator_has_credential ?integration_operator - integration_operator)
    (operator_credential_verified ?integration_operator - integration_operator)
    (operator_extension_marker_attached ?integration_operator - integration_operator)
    (operator_installation_verified ?integration_operator - integration_operator)
    (extension_available ?extension - extension)
    (operator_extension_declared ?integration_operator - integration_operator ?extension - extension)
    (operator_extension_marker_consumed ?integration_operator - integration_operator)
    (operator_extension_marker_configured ?integration_operator - integration_operator)
    (operator_extension_marker_verified ?integration_operator - integration_operator)
    (credential_available ?credential - credential)
    (operator_credential_bound ?integration_operator - integration_operator ?credential - credential)
    (policy_available ?policy - policy)
    (operator_policy_attached ?integration_operator - integration_operator ?policy - policy)
    (plugin_available ?plugin - plugin)
    (operator_plugin_attached ?integration_operator - integration_operator ?plugin - plugin)
    (secret_available ?secret - secret)
    (operator_secret_attached ?integration_operator - integration_operator ?secret - secret)
    (external_account_available ?external_account - external_account)
    (subject_bound_to_external_account ?observability_subject - observability_subject ?external_account - external_account)
    (application_prepared ?application_instance - application_instance)
    (auxiliary_prepared ?auxiliary_instance - auxiliary_instance)
    (operator_finalized ?integration_operator - integration_operator)
  )
  (:action register_observability_subject
    :parameters (?observability_subject - observability_subject)
    :precondition
      (and
        (not
          (subject_registered ?observability_subject)
        )
        (not
          (integration_activated ?observability_subject)
        )
      )
    :effect (subject_registered ?observability_subject)
  )
  (:action assign_connector_to_subject
    :parameters (?observability_subject - observability_subject ?connector - connector)
    :precondition
      (and
        (subject_registered ?observability_subject)
        (not
          (subject_connector_assignment_marker ?observability_subject)
        )
        (connector_available ?connector)
      )
    :effect
      (and
        (subject_connector_assignment_marker ?observability_subject)
        (subject_uses_connector ?observability_subject ?connector)
        (not
          (connector_available ?connector)
        )
      )
  )
  (:action attach_instrumentation_agent_to_subject
    :parameters (?observability_subject - observability_subject ?instrumentation_agent - instrumentation_agent)
    :precondition
      (and
        (subject_registered ?observability_subject)
        (subject_connector_assignment_marker ?observability_subject)
        (agent_available ?instrumentation_agent)
      )
    :effect
      (and
        (subject_agent_attached ?observability_subject ?instrumentation_agent)
        (not
          (agent_available ?instrumentation_agent)
        )
      )
  )
  (:action confirm_instrumentation_installation
    :parameters (?observability_subject - observability_subject ?instrumentation_agent - instrumentation_agent)
    :precondition
      (and
        (subject_registered ?observability_subject)
        (subject_connector_assignment_marker ?observability_subject)
        (subject_agent_attached ?observability_subject ?instrumentation_agent)
        (not
          (subject_instrumented ?observability_subject)
        )
      )
    :effect (subject_instrumented ?observability_subject)
  )
  (:action detach_instrumentation_agent_from_subject
    :parameters (?observability_subject - observability_subject ?instrumentation_agent - instrumentation_agent)
    :precondition
      (and
        (subject_agent_attached ?observability_subject ?instrumentation_agent)
      )
    :effect
      (and
        (agent_available ?instrumentation_agent)
        (not
          (subject_agent_attached ?observability_subject ?instrumentation_agent)
        )
      )
  )
  (:action assign_operator_account_to_subject
    :parameters (?observability_subject - observability_subject ?operator_account - operator_account)
    :precondition
      (and
        (subject_instrumented ?observability_subject)
        (operator_account_available ?operator_account)
      )
    :effect
      (and
        (subject_operator_assigned ?observability_subject ?operator_account)
        (not
          (operator_account_available ?operator_account)
        )
      )
  )
  (:action release_operator_account_from_subject
    :parameters (?observability_subject - observability_subject ?operator_account - operator_account)
    :precondition
      (and
        (subject_operator_assigned ?observability_subject ?operator_account)
      )
    :effect
      (and
        (operator_account_available ?operator_account)
        (not
          (subject_operator_assigned ?observability_subject ?operator_account)
        )
      )
  )
  (:action attach_plugin_to_operator
    :parameters (?integration_operator - integration_operator ?plugin - plugin)
    :precondition
      (and
        (subject_instrumented ?integration_operator)
        (plugin_available ?plugin)
      )
    :effect
      (and
        (operator_plugin_attached ?integration_operator ?plugin)
        (not
          (plugin_available ?plugin)
        )
      )
  )
  (:action detach_plugin_from_operator
    :parameters (?integration_operator - integration_operator ?plugin - plugin)
    :precondition
      (and
        (operator_plugin_attached ?integration_operator ?plugin)
      )
    :effect
      (and
        (plugin_available ?plugin)
        (not
          (operator_plugin_attached ?integration_operator ?plugin)
        )
      )
  )
  (:action attach_secret_to_operator
    :parameters (?integration_operator - integration_operator ?secret - secret)
    :precondition
      (and
        (subject_instrumented ?integration_operator)
        (secret_available ?secret)
      )
    :effect
      (and
        (operator_secret_attached ?integration_operator ?secret)
        (not
          (secret_available ?secret)
        )
      )
  )
  (:action detach_secret_from_operator
    :parameters (?integration_operator - integration_operator ?secret - secret)
    :precondition
      (and
        (operator_secret_attached ?integration_operator ?secret)
      )
    :effect
      (and
        (secret_available ?secret)
        (not
          (operator_secret_attached ?integration_operator ?secret)
        )
      )
  )
  (:action verify_application_source_endpoint
    :parameters (?application_instance - application_instance ?source_endpoint - source_endpoint ?instrumentation_agent - instrumentation_agent)
    :precondition
      (and
        (subject_instrumented ?application_instance)
        (subject_agent_attached ?application_instance ?instrumentation_agent)
        (application_endpoint_bound ?application_instance ?source_endpoint)
        (not
          (source_endpoint_verified ?source_endpoint)
        )
        (not
          (source_endpoint_configured ?source_endpoint)
        )
      )
    :effect (source_endpoint_verified ?source_endpoint)
  )
  (:action finalize_application_source_verification
    :parameters (?application_instance - application_instance ?source_endpoint - source_endpoint ?operator_account - operator_account)
    :precondition
      (and
        (subject_instrumented ?application_instance)
        (subject_operator_assigned ?application_instance ?operator_account)
        (application_endpoint_bound ?application_instance ?source_endpoint)
        (source_endpoint_verified ?source_endpoint)
        (not
          (application_prepared ?application_instance)
        )
      )
    :effect
      (and
        (application_prepared ?application_instance)
        (application_source_ready ?application_instance)
      )
  )
  (:action apply_config_snippet_to_application
    :parameters (?application_instance - application_instance ?source_endpoint - source_endpoint ?config_snippet - config_snippet)
    :precondition
      (and
        (subject_instrumented ?application_instance)
        (application_endpoint_bound ?application_instance ?source_endpoint)
        (config_snippet_available ?config_snippet)
        (not
          (application_prepared ?application_instance)
        )
      )
    :effect
      (and
        (source_endpoint_configured ?source_endpoint)
        (application_prepared ?application_instance)
        (application_config_applied ?application_instance ?config_snippet)
        (not
          (config_snippet_available ?config_snippet)
        )
      )
  )
  (:action complete_application_source_configuration
    :parameters (?application_instance - application_instance ?source_endpoint - source_endpoint ?instrumentation_agent - instrumentation_agent ?config_snippet - config_snippet)
    :precondition
      (and
        (subject_instrumented ?application_instance)
        (subject_agent_attached ?application_instance ?instrumentation_agent)
        (application_endpoint_bound ?application_instance ?source_endpoint)
        (source_endpoint_configured ?source_endpoint)
        (application_config_applied ?application_instance ?config_snippet)
        (not
          (application_source_ready ?application_instance)
        )
      )
    :effect
      (and
        (source_endpoint_verified ?source_endpoint)
        (application_source_ready ?application_instance)
        (config_snippet_available ?config_snippet)
        (not
          (application_config_applied ?application_instance ?config_snippet)
        )
      )
  )
  (:action verify_auxiliary_source_endpoint
    :parameters (?auxiliary_instance - auxiliary_instance ?source_stream - source_stream ?instrumentation_agent - instrumentation_agent)
    :precondition
      (and
        (subject_instrumented ?auxiliary_instance)
        (subject_agent_attached ?auxiliary_instance ?instrumentation_agent)
        (auxiliary_stream_bound ?auxiliary_instance ?source_stream)
        (not
          (source_stream_verified ?source_stream)
        )
        (not
          (source_stream_configured ?source_stream)
        )
      )
    :effect (source_stream_verified ?source_stream)
  )
  (:action finalize_auxiliary_source_verification
    :parameters (?auxiliary_instance - auxiliary_instance ?source_stream - source_stream ?operator_account - operator_account)
    :precondition
      (and
        (subject_instrumented ?auxiliary_instance)
        (subject_operator_assigned ?auxiliary_instance ?operator_account)
        (auxiliary_stream_bound ?auxiliary_instance ?source_stream)
        (source_stream_verified ?source_stream)
        (not
          (auxiliary_prepared ?auxiliary_instance)
        )
      )
    :effect
      (and
        (auxiliary_prepared ?auxiliary_instance)
        (auxiliary_source_ready ?auxiliary_instance)
      )
  )
  (:action apply_config_snippet_to_auxiliary
    :parameters (?auxiliary_instance - auxiliary_instance ?source_stream - source_stream ?config_snippet - config_snippet)
    :precondition
      (and
        (subject_instrumented ?auxiliary_instance)
        (auxiliary_stream_bound ?auxiliary_instance ?source_stream)
        (config_snippet_available ?config_snippet)
        (not
          (auxiliary_prepared ?auxiliary_instance)
        )
      )
    :effect
      (and
        (source_stream_configured ?source_stream)
        (auxiliary_prepared ?auxiliary_instance)
        (auxiliary_config_applied ?auxiliary_instance ?config_snippet)
        (not
          (config_snippet_available ?config_snippet)
        )
      )
  )
  (:action complete_auxiliary_source_configuration
    :parameters (?auxiliary_instance - auxiliary_instance ?source_stream - source_stream ?instrumentation_agent - instrumentation_agent ?config_snippet - config_snippet)
    :precondition
      (and
        (subject_instrumented ?auxiliary_instance)
        (subject_agent_attached ?auxiliary_instance ?instrumentation_agent)
        (auxiliary_stream_bound ?auxiliary_instance ?source_stream)
        (source_stream_configured ?source_stream)
        (auxiliary_config_applied ?auxiliary_instance ?config_snippet)
        (not
          (auxiliary_source_ready ?auxiliary_instance)
        )
      )
    :effect
      (and
        (source_stream_verified ?source_stream)
        (auxiliary_source_ready ?auxiliary_instance)
        (config_snippet_available ?config_snippet)
        (not
          (auxiliary_config_applied ?auxiliary_instance ?config_snippet)
        )
      )
  )
  (:action assemble_observability_sink_basic
    :parameters (?application_instance - application_instance ?auxiliary_instance - auxiliary_instance ?source_endpoint - source_endpoint ?source_stream - source_stream ?observability_sink - observability_sink)
    :precondition
      (and
        (application_prepared ?application_instance)
        (auxiliary_prepared ?auxiliary_instance)
        (application_endpoint_bound ?application_instance ?source_endpoint)
        (auxiliary_stream_bound ?auxiliary_instance ?source_stream)
        (source_endpoint_verified ?source_endpoint)
        (source_stream_verified ?source_stream)
        (application_source_ready ?application_instance)
        (auxiliary_source_ready ?auxiliary_instance)
        (sink_available ?observability_sink)
      )
    :effect
      (and
        (sink_created ?observability_sink)
        (sink_bound_to_endpoint ?observability_sink ?source_endpoint)
        (sink_bound_to_stream ?observability_sink ?source_stream)
        (not
          (sink_available ?observability_sink)
        )
      )
  )
  (:action assemble_observability_sink_with_endpoint_ingestion
    :parameters (?application_instance - application_instance ?auxiliary_instance - auxiliary_instance ?source_endpoint - source_endpoint ?source_stream - source_stream ?observability_sink - observability_sink)
    :precondition
      (and
        (application_prepared ?application_instance)
        (auxiliary_prepared ?auxiliary_instance)
        (application_endpoint_bound ?application_instance ?source_endpoint)
        (auxiliary_stream_bound ?auxiliary_instance ?source_stream)
        (source_endpoint_configured ?source_endpoint)
        (source_stream_verified ?source_stream)
        (not
          (application_source_ready ?application_instance)
        )
        (auxiliary_source_ready ?auxiliary_instance)
        (sink_available ?observability_sink)
      )
    :effect
      (and
        (sink_created ?observability_sink)
        (sink_bound_to_endpoint ?observability_sink ?source_endpoint)
        (sink_bound_to_stream ?observability_sink ?source_stream)
        (sink_endpoint_ingestion_enabled ?observability_sink)
        (not
          (sink_available ?observability_sink)
        )
      )
  )
  (:action assemble_observability_sink_with_stream_ingestion
    :parameters (?application_instance - application_instance ?auxiliary_instance - auxiliary_instance ?source_endpoint - source_endpoint ?source_stream - source_stream ?observability_sink - observability_sink)
    :precondition
      (and
        (application_prepared ?application_instance)
        (auxiliary_prepared ?auxiliary_instance)
        (application_endpoint_bound ?application_instance ?source_endpoint)
        (auxiliary_stream_bound ?auxiliary_instance ?source_stream)
        (source_endpoint_verified ?source_endpoint)
        (source_stream_configured ?source_stream)
        (application_source_ready ?application_instance)
        (not
          (auxiliary_source_ready ?auxiliary_instance)
        )
        (sink_available ?observability_sink)
      )
    :effect
      (and
        (sink_created ?observability_sink)
        (sink_bound_to_endpoint ?observability_sink ?source_endpoint)
        (sink_bound_to_stream ?observability_sink ?source_stream)
        (sink_stream_ingestion_enabled ?observability_sink)
        (not
          (sink_available ?observability_sink)
        )
      )
  )
  (:action assemble_observability_sink_with_both_ingestions
    :parameters (?application_instance - application_instance ?auxiliary_instance - auxiliary_instance ?source_endpoint - source_endpoint ?source_stream - source_stream ?observability_sink - observability_sink)
    :precondition
      (and
        (application_prepared ?application_instance)
        (auxiliary_prepared ?auxiliary_instance)
        (application_endpoint_bound ?application_instance ?source_endpoint)
        (auxiliary_stream_bound ?auxiliary_instance ?source_stream)
        (source_endpoint_configured ?source_endpoint)
        (source_stream_configured ?source_stream)
        (not
          (application_source_ready ?application_instance)
        )
        (not
          (auxiliary_source_ready ?auxiliary_instance)
        )
        (sink_available ?observability_sink)
      )
    :effect
      (and
        (sink_created ?observability_sink)
        (sink_bound_to_endpoint ?observability_sink ?source_endpoint)
        (sink_bound_to_stream ?observability_sink ?source_stream)
        (sink_endpoint_ingestion_enabled ?observability_sink)
        (sink_stream_ingestion_enabled ?observability_sink)
        (not
          (sink_available ?observability_sink)
        )
      )
  )
  (:action verify_and_activate_sink_ingestion
    :parameters (?observability_sink - observability_sink ?application_instance - application_instance ?instrumentation_agent - instrumentation_agent)
    :precondition
      (and
        (sink_created ?observability_sink)
        (application_prepared ?application_instance)
        (subject_agent_attached ?application_instance ?instrumentation_agent)
        (not
          (sink_ingestion_verified ?observability_sink)
        )
      )
    :effect (sink_ingestion_verified ?observability_sink)
  )
  (:action provision_storage_bucket_for_sink
    :parameters (?integration_operator - integration_operator ?storage_bucket - storage_bucket ?observability_sink - observability_sink)
    :precondition
      (and
        (subject_instrumented ?integration_operator)
        (operator_manages_sink ?integration_operator ?observability_sink)
        (operator_uses_bucket ?integration_operator ?storage_bucket)
        (storage_bucket_available ?storage_bucket)
        (sink_created ?observability_sink)
        (sink_ingestion_verified ?observability_sink)
        (not
          (storage_bucket_provisioned ?storage_bucket)
        )
      )
    :effect
      (and
        (storage_bucket_provisioned ?storage_bucket)
        (bucket_bound_to_sink ?storage_bucket ?observability_sink)
        (not
          (storage_bucket_available ?storage_bucket)
        )
      )
  )
  (:action attach_provisioned_bucket_to_operator
    :parameters (?integration_operator - integration_operator ?storage_bucket - storage_bucket ?observability_sink - observability_sink ?instrumentation_agent - instrumentation_agent)
    :precondition
      (and
        (subject_instrumented ?integration_operator)
        (operator_uses_bucket ?integration_operator ?storage_bucket)
        (storage_bucket_provisioned ?storage_bucket)
        (bucket_bound_to_sink ?storage_bucket ?observability_sink)
        (subject_agent_attached ?integration_operator ?instrumentation_agent)
        (not
          (sink_endpoint_ingestion_enabled ?observability_sink)
        )
        (not
          (operator_ready_for_pipeline_configuration ?integration_operator)
        )
      )
    :effect (operator_ready_for_pipeline_configuration ?integration_operator)
  )
  (:action bind_credential_to_operator
    :parameters (?integration_operator - integration_operator ?credential - credential)
    :precondition
      (and
        (subject_instrumented ?integration_operator)
        (credential_available ?credential)
        (not
          (operator_has_credential ?integration_operator)
        )
      )
    :effect
      (and
        (operator_has_credential ?integration_operator)
        (operator_credential_bound ?integration_operator ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action verify_operator_credentials_and_storage
    :parameters (?integration_operator - integration_operator ?storage_bucket - storage_bucket ?observability_sink - observability_sink ?instrumentation_agent - instrumentation_agent ?credential - credential)
    :precondition
      (and
        (subject_instrumented ?integration_operator)
        (operator_uses_bucket ?integration_operator ?storage_bucket)
        (storage_bucket_provisioned ?storage_bucket)
        (bucket_bound_to_sink ?storage_bucket ?observability_sink)
        (subject_agent_attached ?integration_operator ?instrumentation_agent)
        (sink_endpoint_ingestion_enabled ?observability_sink)
        (operator_has_credential ?integration_operator)
        (operator_credential_bound ?integration_operator ?credential)
        (not
          (operator_ready_for_pipeline_configuration ?integration_operator)
        )
      )
    :effect
      (and
        (operator_ready_for_pipeline_configuration ?integration_operator)
        (operator_credential_verified ?integration_operator)
      )
  )
  (:action request_plugin_activation_on_operator
    :parameters (?integration_operator - integration_operator ?plugin - plugin ?operator_account - operator_account ?storage_bucket - storage_bucket ?observability_sink - observability_sink)
    :precondition
      (and
        (operator_ready_for_pipeline_configuration ?integration_operator)
        (operator_plugin_attached ?integration_operator ?plugin)
        (subject_operator_assigned ?integration_operator ?operator_account)
        (operator_uses_bucket ?integration_operator ?storage_bucket)
        (bucket_bound_to_sink ?storage_bucket ?observability_sink)
        (not
          (sink_stream_ingestion_enabled ?observability_sink)
        )
        (not
          (operator_pipeline_stage_ready ?integration_operator)
        )
      )
    :effect (operator_pipeline_stage_ready ?integration_operator)
  )
  (:action confirm_plugin_activation_on_operator
    :parameters (?integration_operator - integration_operator ?plugin - plugin ?operator_account - operator_account ?storage_bucket - storage_bucket ?observability_sink - observability_sink)
    :precondition
      (and
        (operator_ready_for_pipeline_configuration ?integration_operator)
        (operator_plugin_attached ?integration_operator ?plugin)
        (subject_operator_assigned ?integration_operator ?operator_account)
        (operator_uses_bucket ?integration_operator ?storage_bucket)
        (bucket_bound_to_sink ?storage_bucket ?observability_sink)
        (sink_stream_ingestion_enabled ?observability_sink)
        (not
          (operator_pipeline_stage_ready ?integration_operator)
        )
      )
    :effect (operator_pipeline_stage_ready ?integration_operator)
  )
  (:action provision_secret_for_operator
    :parameters (?integration_operator - integration_operator ?secret - secret ?storage_bucket - storage_bucket ?observability_sink - observability_sink)
    :precondition
      (and
        (operator_pipeline_stage_ready ?integration_operator)
        (operator_secret_attached ?integration_operator ?secret)
        (operator_uses_bucket ?integration_operator ?storage_bucket)
        (bucket_bound_to_sink ?storage_bucket ?observability_sink)
        (not
          (sink_endpoint_ingestion_enabled ?observability_sink)
        )
        (not
          (sink_stream_ingestion_enabled ?observability_sink)
        )
        (not
          (operator_configured ?integration_operator)
        )
      )
    :effect (operator_configured ?integration_operator)
  )
  (:action provision_secret_and_attach_extension_marker
    :parameters (?integration_operator - integration_operator ?secret - secret ?storage_bucket - storage_bucket ?observability_sink - observability_sink)
    :precondition
      (and
        (operator_pipeline_stage_ready ?integration_operator)
        (operator_secret_attached ?integration_operator ?secret)
        (operator_uses_bucket ?integration_operator ?storage_bucket)
        (bucket_bound_to_sink ?storage_bucket ?observability_sink)
        (sink_endpoint_ingestion_enabled ?observability_sink)
        (not
          (sink_stream_ingestion_enabled ?observability_sink)
        )
        (not
          (operator_configured ?integration_operator)
        )
      )
    :effect
      (and
        (operator_configured ?integration_operator)
        (operator_extension_marker_attached ?integration_operator)
      )
  )
  (:action provision_secret_and_attach_extension_marker_alternate
    :parameters (?integration_operator - integration_operator ?secret - secret ?storage_bucket - storage_bucket ?observability_sink - observability_sink)
    :precondition
      (and
        (operator_pipeline_stage_ready ?integration_operator)
        (operator_secret_attached ?integration_operator ?secret)
        (operator_uses_bucket ?integration_operator ?storage_bucket)
        (bucket_bound_to_sink ?storage_bucket ?observability_sink)
        (not
          (sink_endpoint_ingestion_enabled ?observability_sink)
        )
        (sink_stream_ingestion_enabled ?observability_sink)
        (not
          (operator_configured ?integration_operator)
        )
      )
    :effect
      (and
        (operator_configured ?integration_operator)
        (operator_extension_marker_attached ?integration_operator)
      )
  )
  (:action provision_secret_and_attach_extension_marker_final
    :parameters (?integration_operator - integration_operator ?secret - secret ?storage_bucket - storage_bucket ?observability_sink - observability_sink)
    :precondition
      (and
        (operator_pipeline_stage_ready ?integration_operator)
        (operator_secret_attached ?integration_operator ?secret)
        (operator_uses_bucket ?integration_operator ?storage_bucket)
        (bucket_bound_to_sink ?storage_bucket ?observability_sink)
        (sink_endpoint_ingestion_enabled ?observability_sink)
        (sink_stream_ingestion_enabled ?observability_sink)
        (not
          (operator_configured ?integration_operator)
        )
      )
    :effect
      (and
        (operator_configured ?integration_operator)
        (operator_extension_marker_attached ?integration_operator)
      )
  )
  (:action finalize_operator_activation
    :parameters (?integration_operator - integration_operator)
    :precondition
      (and
        (operator_configured ?integration_operator)
        (not
          (operator_extension_marker_attached ?integration_operator)
        )
        (not
          (operator_finalized ?integration_operator)
        )
      )
    :effect
      (and
        (operator_finalized ?integration_operator)
        (integration_acknowledged ?integration_operator)
      )
  )
  (:action attach_policy_to_operator
    :parameters (?integration_operator - integration_operator ?policy - policy)
    :precondition
      (and
        (operator_configured ?integration_operator)
        (operator_extension_marker_attached ?integration_operator)
        (policy_available ?policy)
      )
    :effect
      (and
        (operator_policy_attached ?integration_operator ?policy)
        (not
          (policy_available ?policy)
        )
      )
  )
  (:action run_operator_verification_check
    :parameters (?integration_operator - integration_operator ?application_instance - application_instance ?auxiliary_instance - auxiliary_instance ?instrumentation_agent - instrumentation_agent ?policy - policy)
    :precondition
      (and
        (operator_configured ?integration_operator)
        (operator_extension_marker_attached ?integration_operator)
        (operator_policy_attached ?integration_operator ?policy)
        (operator_manages_application ?integration_operator ?application_instance)
        (operator_manages_auxiliary ?integration_operator ?auxiliary_instance)
        (application_source_ready ?application_instance)
        (auxiliary_source_ready ?auxiliary_instance)
        (subject_agent_attached ?integration_operator ?instrumentation_agent)
        (not
          (operator_installation_verified ?integration_operator)
        )
      )
    :effect (operator_installation_verified ?integration_operator)
  )
  (:action activate_operator_integration
    :parameters (?integration_operator - integration_operator)
    :precondition
      (and
        (operator_configured ?integration_operator)
        (operator_installation_verified ?integration_operator)
        (not
          (operator_finalized ?integration_operator)
        )
      )
    :effect
      (and
        (operator_finalized ?integration_operator)
        (integration_acknowledged ?integration_operator)
      )
  )
  (:action consume_extension_for_operator
    :parameters (?integration_operator - integration_operator ?extension - extension ?instrumentation_agent - instrumentation_agent)
    :precondition
      (and
        (subject_instrumented ?integration_operator)
        (subject_agent_attached ?integration_operator ?instrumentation_agent)
        (extension_available ?extension)
        (operator_extension_declared ?integration_operator ?extension)
        (not
          (operator_extension_marker_consumed ?integration_operator)
        )
      )
    :effect
      (and
        (operator_extension_marker_consumed ?integration_operator)
        (not
          (extension_available ?extension)
        )
      )
  )
  (:action configure_operator_extension
    :parameters (?integration_operator - integration_operator ?operator_account - operator_account)
    :precondition
      (and
        (operator_extension_marker_consumed ?integration_operator)
        (subject_operator_assigned ?integration_operator ?operator_account)
        (not
          (operator_extension_marker_configured ?integration_operator)
        )
      )
    :effect (operator_extension_marker_configured ?integration_operator)
  )
  (:action verify_operator_extension_with_secret
    :parameters (?integration_operator - integration_operator ?secret - secret)
    :precondition
      (and
        (operator_extension_marker_configured ?integration_operator)
        (operator_secret_attached ?integration_operator ?secret)
        (not
          (operator_extension_marker_verified ?integration_operator)
        )
      )
    :effect (operator_extension_marker_verified ?integration_operator)
  )
  (:action activate_operator_extension
    :parameters (?integration_operator - integration_operator)
    :precondition
      (and
        (operator_extension_marker_verified ?integration_operator)
        (not
          (operator_finalized ?integration_operator)
        )
      )
    :effect
      (and
        (operator_finalized ?integration_operator)
        (integration_acknowledged ?integration_operator)
      )
  )
  (:action activate_application_integration
    :parameters (?application_instance - application_instance ?observability_sink - observability_sink)
    :precondition
      (and
        (application_prepared ?application_instance)
        (application_source_ready ?application_instance)
        (sink_created ?observability_sink)
        (sink_ingestion_verified ?observability_sink)
        (not
          (integration_acknowledged ?application_instance)
        )
      )
    :effect (integration_acknowledged ?application_instance)
  )
  (:action activate_auxiliary_integration
    :parameters (?auxiliary_instance - auxiliary_instance ?observability_sink - observability_sink)
    :precondition
      (and
        (auxiliary_prepared ?auxiliary_instance)
        (auxiliary_source_ready ?auxiliary_instance)
        (sink_created ?observability_sink)
        (sink_ingestion_verified ?observability_sink)
        (not
          (integration_acknowledged ?auxiliary_instance)
        )
      )
    :effect (integration_acknowledged ?auxiliary_instance)
  )
  (:action provision_external_account_for_subject
    :parameters (?observability_subject - observability_subject ?external_account - external_account ?instrumentation_agent - instrumentation_agent)
    :precondition
      (and
        (integration_acknowledged ?observability_subject)
        (subject_agent_attached ?observability_subject ?instrumentation_agent)
        (external_account_available ?external_account)
        (not
          (subject_provisioned ?observability_subject)
        )
      )
    :effect
      (and
        (subject_provisioned ?observability_subject)
        (subject_bound_to_external_account ?observability_subject ?external_account)
        (not
          (external_account_available ?external_account)
        )
      )
  )
  (:action finalize_application_provisioning
    :parameters (?application_instance - application_instance ?connector - connector ?external_account - external_account)
    :precondition
      (and
        (subject_provisioned ?application_instance)
        (subject_uses_connector ?application_instance ?connector)
        (subject_bound_to_external_account ?application_instance ?external_account)
        (not
          (integration_activated ?application_instance)
        )
      )
    :effect
      (and
        (integration_activated ?application_instance)
        (connector_available ?connector)
        (external_account_available ?external_account)
      )
  )
  (:action finalize_auxiliary_provisioning
    :parameters (?auxiliary_instance - auxiliary_instance ?connector - connector ?external_account - external_account)
    :precondition
      (and
        (subject_provisioned ?auxiliary_instance)
        (subject_uses_connector ?auxiliary_instance ?connector)
        (subject_bound_to_external_account ?auxiliary_instance ?external_account)
        (not
          (integration_activated ?auxiliary_instance)
        )
      )
    :effect
      (and
        (integration_activated ?auxiliary_instance)
        (connector_available ?connector)
        (external_account_available ?external_account)
      )
  )
  (:action finalize_operator_provisioning
    :parameters (?integration_operator - integration_operator ?connector - connector ?external_account - external_account)
    :precondition
      (and
        (subject_provisioned ?integration_operator)
        (subject_uses_connector ?integration_operator ?connector)
        (subject_bound_to_external_account ?integration_operator ?external_account)
        (not
          (integration_activated ?integration_operator)
        )
      )
    :effect
      (and
        (integration_activated ?integration_operator)
        (connector_available ?connector)
        (external_account_available ?external_account)
      )
  )
)

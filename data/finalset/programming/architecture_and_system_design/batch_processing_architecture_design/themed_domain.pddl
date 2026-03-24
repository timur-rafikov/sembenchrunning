(define (domain batch_processing_architecture)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_class - object artifact_class - object channel_class - object job_root - object batch_job - job_root compute_slot - resource_class input_shard - resource_class executor_instance - resource_class credential - resource_class policy - resource_class storage_endpoint - resource_class tuning_parameter - resource_class deployment_descriptor - resource_class configuration_artifact - artifact_class library_artifact - artifact_class priority_tag - artifact_class input_channel - channel_class output_channel - channel_class batch_package - channel_class job_subtype_group - batch_job coordinator_subtype_group - batch_job source_job - job_subtype_group sink_job - job_subtype_group processing_coordinator - coordinator_subtype_group)
  (:predicates
    (job_registered ?batch_job - batch_job)
    (job_validated ?batch_job - batch_job)
    (job_slot_reserved ?batch_job - batch_job)
    (job_completed ?batch_job - batch_job)
    (ready_for_execution ?batch_job - batch_job)
    (job_run_completed ?batch_job - batch_job)
    (compute_slot_available ?compute_slot - compute_slot)
    (job_assigned_compute_slot ?batch_job - batch_job ?compute_slot - compute_slot)
    (input_shard_available ?input_shard - input_shard)
    (job_bound_input_shard ?batch_job - batch_job ?input_shard - input_shard)
    (executor_available ?executor_instance - executor_instance)
    (job_assigned_executor_instance ?batch_job - batch_job ?executor_instance - executor_instance)
    (configuration_artifact_available ?configuration_artifact - configuration_artifact)
    (source_job_staged_artifact ?source_job - source_job ?configuration_artifact - configuration_artifact)
    (sink_job_staged_artifact ?sink_job - sink_job ?configuration_artifact - configuration_artifact)
    (source_job_input_channel_binding ?source_job - source_job ?input_channel - input_channel)
    (input_channel_prefetched ?input_channel - input_channel)
    (input_channel_staged ?input_channel - input_channel)
    (source_job_ready ?source_job - source_job)
    (sink_job_output_channel_binding ?sink_job - sink_job ?output_channel - output_channel)
    (output_channel_prefetched ?output_channel - output_channel)
    (output_channel_staged ?output_channel - output_channel)
    (sink_job_ready ?sink_job - sink_job)
    (package_unstaged ?batch_package - batch_package)
    (package_staged ?batch_package - batch_package)
    (package_input_channel_binding ?batch_package - batch_package ?input_channel - input_channel)
    (package_output_channel_binding ?batch_package - batch_package ?output_channel - output_channel)
    (package_input_ready ?batch_package - batch_package)
    (package_output_ready ?batch_package - batch_package)
    (package_finalized ?batch_package - batch_package)
    (coordinator_manages_source_job ?processing_coordinator - processing_coordinator ?source_job - source_job)
    (coordinator_manages_sink_job ?processing_coordinator - processing_coordinator ?sink_job - sink_job)
    (coordinator_assigned_package ?processing_coordinator - processing_coordinator ?batch_package - batch_package)
    (library_artifact_available ?library_artifact - library_artifact)
    (coordinator_has_library ?processing_coordinator - processing_coordinator ?library_artifact - library_artifact)
    (library_staged ?library_artifact - library_artifact)
    (library_bound_to_package ?library_artifact - library_artifact ?batch_package - batch_package)
    (coordinator_artifacts_verified ?processing_coordinator - processing_coordinator)
    (coordinator_prepared ?processing_coordinator - processing_coordinator)
    (coordinator_authorized ?processing_coordinator - processing_coordinator)
    (coordinator_credential_attached ?processing_coordinator - processing_coordinator)
    (coordinator_credential_verified ?processing_coordinator - processing_coordinator)
    (coordinator_policy_present ?processing_coordinator - processing_coordinator)
    (coordinator_authorization_ready ?processing_coordinator - processing_coordinator)
    (priority_tag_available ?priority_tag - priority_tag)
    (coordinator_has_priority_tag ?processing_coordinator - processing_coordinator ?priority_tag - priority_tag)
    (coordinator_priority_claimed ?processing_coordinator - processing_coordinator)
    (coordinator_deployment_prepared ?processing_coordinator - processing_coordinator)
    (coordinator_deployment_applied ?processing_coordinator - processing_coordinator)
    (credential_available ?credential - credential)
    (coordinator_credential_bound ?processing_coordinator - processing_coordinator ?credential - credential)
    (policy_available ?policy - policy)
    (coordinator_policy_bound ?processing_coordinator - processing_coordinator ?policy - policy)
    (tuning_parameter_available ?tuning_parameter - tuning_parameter)
    (coordinator_has_tuning_parameter ?processing_coordinator - processing_coordinator ?tuning_parameter - tuning_parameter)
    (deployment_descriptor_available ?deployment_descriptor - deployment_descriptor)
    (coordinator_has_deployment_descriptor ?processing_coordinator - processing_coordinator ?deployment_descriptor - deployment_descriptor)
    (storage_endpoint_available ?storage_endpoint - storage_endpoint)
    (job_output_registered_to_storage ?batch_job - batch_job ?storage_endpoint - storage_endpoint)
    (source_job_input_prefetched ?source_job - source_job)
    (sink_job_output_prefetched ?sink_job - sink_job)
    (coordinator_finalized ?processing_coordinator - processing_coordinator)
  )
  (:action register_batch_job
    :parameters (?batch_job - batch_job)
    :precondition
      (and
        (not
          (job_registered ?batch_job)
        )
        (not
          (job_completed ?batch_job)
        )
      )
    :effect (job_registered ?batch_job)
  )
  (:action reserve_compute_slot_for_job
    :parameters (?batch_job - batch_job ?compute_slot - compute_slot)
    :precondition
      (and
        (job_registered ?batch_job)
        (not
          (job_slot_reserved ?batch_job)
        )
        (compute_slot_available ?compute_slot)
      )
    :effect
      (and
        (job_slot_reserved ?batch_job)
        (job_assigned_compute_slot ?batch_job ?compute_slot)
        (not
          (compute_slot_available ?compute_slot)
        )
      )
  )
  (:action assign_input_shard_to_job
    :parameters (?batch_job - batch_job ?input_shard - input_shard)
    :precondition
      (and
        (job_registered ?batch_job)
        (job_slot_reserved ?batch_job)
        (input_shard_available ?input_shard)
      )
    :effect
      (and
        (job_bound_input_shard ?batch_job ?input_shard)
        (not
          (input_shard_available ?input_shard)
        )
      )
  )
  (:action validate_batch_job_configuration
    :parameters (?batch_job - batch_job ?input_shard - input_shard)
    :precondition
      (and
        (job_registered ?batch_job)
        (job_slot_reserved ?batch_job)
        (job_bound_input_shard ?batch_job ?input_shard)
        (not
          (job_validated ?batch_job)
        )
      )
    :effect (job_validated ?batch_job)
  )
  (:action release_input_shard_from_job
    :parameters (?batch_job - batch_job ?input_shard - input_shard)
    :precondition
      (and
        (job_bound_input_shard ?batch_job ?input_shard)
      )
    :effect
      (and
        (input_shard_available ?input_shard)
        (not
          (job_bound_input_shard ?batch_job ?input_shard)
        )
      )
  )
  (:action assign_executor_to_job
    :parameters (?batch_job - batch_job ?executor_instance - executor_instance)
    :precondition
      (and
        (job_validated ?batch_job)
        (executor_available ?executor_instance)
      )
    :effect
      (and
        (job_assigned_executor_instance ?batch_job ?executor_instance)
        (not
          (executor_available ?executor_instance)
        )
      )
  )
  (:action release_executor_from_job
    :parameters (?batch_job - batch_job ?executor_instance - executor_instance)
    :precondition
      (and
        (job_assigned_executor_instance ?batch_job ?executor_instance)
      )
    :effect
      (and
        (executor_available ?executor_instance)
        (not
          (job_assigned_executor_instance ?batch_job ?executor_instance)
        )
      )
  )
  (:action attach_tuning_parameter_to_coordinator
    :parameters (?processing_coordinator - processing_coordinator ?tuning_parameter - tuning_parameter)
    :precondition
      (and
        (job_validated ?processing_coordinator)
        (tuning_parameter_available ?tuning_parameter)
      )
    :effect
      (and
        (coordinator_has_tuning_parameter ?processing_coordinator ?tuning_parameter)
        (not
          (tuning_parameter_available ?tuning_parameter)
        )
      )
  )
  (:action detach_tuning_parameter_from_coordinator
    :parameters (?processing_coordinator - processing_coordinator ?tuning_parameter - tuning_parameter)
    :precondition
      (and
        (coordinator_has_tuning_parameter ?processing_coordinator ?tuning_parameter)
      )
    :effect
      (and
        (tuning_parameter_available ?tuning_parameter)
        (not
          (coordinator_has_tuning_parameter ?processing_coordinator ?tuning_parameter)
        )
      )
  )
  (:action attach_deployment_descriptor_to_coordinator
    :parameters (?processing_coordinator - processing_coordinator ?deployment_descriptor - deployment_descriptor)
    :precondition
      (and
        (job_validated ?processing_coordinator)
        (deployment_descriptor_available ?deployment_descriptor)
      )
    :effect
      (and
        (coordinator_has_deployment_descriptor ?processing_coordinator ?deployment_descriptor)
        (not
          (deployment_descriptor_available ?deployment_descriptor)
        )
      )
  )
  (:action detach_deployment_descriptor_from_coordinator
    :parameters (?processing_coordinator - processing_coordinator ?deployment_descriptor - deployment_descriptor)
    :precondition
      (and
        (coordinator_has_deployment_descriptor ?processing_coordinator ?deployment_descriptor)
      )
    :effect
      (and
        (deployment_descriptor_available ?deployment_descriptor)
        (not
          (coordinator_has_deployment_descriptor ?processing_coordinator ?deployment_descriptor)
        )
      )
  )
  (:action prefetch_input_channel_for_source_job
    :parameters (?source_job - source_job ?input_channel - input_channel ?input_shard - input_shard)
    :precondition
      (and
        (job_validated ?source_job)
        (job_bound_input_shard ?source_job ?input_shard)
        (source_job_input_channel_binding ?source_job ?input_channel)
        (not
          (input_channel_prefetched ?input_channel)
        )
        (not
          (input_channel_staged ?input_channel)
        )
      )
    :effect (input_channel_prefetched ?input_channel)
  )
  (:action finalize_source_prefetch
    :parameters (?source_job - source_job ?input_channel - input_channel ?executor_instance - executor_instance)
    :precondition
      (and
        (job_validated ?source_job)
        (job_assigned_executor_instance ?source_job ?executor_instance)
        (source_job_input_channel_binding ?source_job ?input_channel)
        (input_channel_prefetched ?input_channel)
        (not
          (source_job_input_prefetched ?source_job)
        )
      )
    :effect
      (and
        (source_job_input_prefetched ?source_job)
        (source_job_ready ?source_job)
      )
  )
  (:action stage_artifact_for_source_job
    :parameters (?source_job - source_job ?input_channel - input_channel ?configuration_artifact - configuration_artifact)
    :precondition
      (and
        (job_validated ?source_job)
        (source_job_input_channel_binding ?source_job ?input_channel)
        (configuration_artifact_available ?configuration_artifact)
        (not
          (source_job_input_prefetched ?source_job)
        )
      )
    :effect
      (and
        (input_channel_staged ?input_channel)
        (source_job_input_prefetched ?source_job)
        (source_job_staged_artifact ?source_job ?configuration_artifact)
        (not
          (configuration_artifact_available ?configuration_artifact)
        )
      )
  )
  (:action consume_staged_artifact_for_source_job
    :parameters (?source_job - source_job ?input_channel - input_channel ?input_shard - input_shard ?configuration_artifact - configuration_artifact)
    :precondition
      (and
        (job_validated ?source_job)
        (job_bound_input_shard ?source_job ?input_shard)
        (source_job_input_channel_binding ?source_job ?input_channel)
        (input_channel_staged ?input_channel)
        (source_job_staged_artifact ?source_job ?configuration_artifact)
        (not
          (source_job_ready ?source_job)
        )
      )
    :effect
      (and
        (input_channel_prefetched ?input_channel)
        (source_job_ready ?source_job)
        (configuration_artifact_available ?configuration_artifact)
        (not
          (source_job_staged_artifact ?source_job ?configuration_artifact)
        )
      )
  )
  (:action prefetch_output_channel_for_sink_job
    :parameters (?sink_job - sink_job ?output_channel - output_channel ?input_shard - input_shard)
    :precondition
      (and
        (job_validated ?sink_job)
        (job_bound_input_shard ?sink_job ?input_shard)
        (sink_job_output_channel_binding ?sink_job ?output_channel)
        (not
          (output_channel_prefetched ?output_channel)
        )
        (not
          (output_channel_staged ?output_channel)
        )
      )
    :effect (output_channel_prefetched ?output_channel)
  )
  (:action finalize_sink_prefetch
    :parameters (?sink_job - sink_job ?output_channel - output_channel ?executor_instance - executor_instance)
    :precondition
      (and
        (job_validated ?sink_job)
        (job_assigned_executor_instance ?sink_job ?executor_instance)
        (sink_job_output_channel_binding ?sink_job ?output_channel)
        (output_channel_prefetched ?output_channel)
        (not
          (sink_job_output_prefetched ?sink_job)
        )
      )
    :effect
      (and
        (sink_job_output_prefetched ?sink_job)
        (sink_job_ready ?sink_job)
      )
  )
  (:action stage_artifact_for_sink_job
    :parameters (?sink_job - sink_job ?output_channel - output_channel ?configuration_artifact - configuration_artifact)
    :precondition
      (and
        (job_validated ?sink_job)
        (sink_job_output_channel_binding ?sink_job ?output_channel)
        (configuration_artifact_available ?configuration_artifact)
        (not
          (sink_job_output_prefetched ?sink_job)
        )
      )
    :effect
      (and
        (output_channel_staged ?output_channel)
        (sink_job_output_prefetched ?sink_job)
        (sink_job_staged_artifact ?sink_job ?configuration_artifact)
        (not
          (configuration_artifact_available ?configuration_artifact)
        )
      )
  )
  (:action consume_staged_artifact_for_sink_job
    :parameters (?sink_job - sink_job ?output_channel - output_channel ?input_shard - input_shard ?configuration_artifact - configuration_artifact)
    :precondition
      (and
        (job_validated ?sink_job)
        (job_bound_input_shard ?sink_job ?input_shard)
        (sink_job_output_channel_binding ?sink_job ?output_channel)
        (output_channel_staged ?output_channel)
        (sink_job_staged_artifact ?sink_job ?configuration_artifact)
        (not
          (sink_job_ready ?sink_job)
        )
      )
    :effect
      (and
        (output_channel_prefetched ?output_channel)
        (sink_job_ready ?sink_job)
        (configuration_artifact_available ?configuration_artifact)
        (not
          (sink_job_staged_artifact ?sink_job ?configuration_artifact)
        )
      )
  )
  (:action assemble_batch_package
    :parameters (?source_job - source_job ?sink_job - sink_job ?input_channel - input_channel ?output_channel - output_channel ?batch_package - batch_package)
    :precondition
      (and
        (source_job_input_prefetched ?source_job)
        (sink_job_output_prefetched ?sink_job)
        (source_job_input_channel_binding ?source_job ?input_channel)
        (sink_job_output_channel_binding ?sink_job ?output_channel)
        (input_channel_prefetched ?input_channel)
        (output_channel_prefetched ?output_channel)
        (source_job_ready ?source_job)
        (sink_job_ready ?sink_job)
        (package_unstaged ?batch_package)
      )
    :effect
      (and
        (package_staged ?batch_package)
        (package_input_channel_binding ?batch_package ?input_channel)
        (package_output_channel_binding ?batch_package ?output_channel)
        (not
          (package_unstaged ?batch_package)
        )
      )
  )
  (:action stage_batch_package_with_input_ready
    :parameters (?source_job - source_job ?sink_job - sink_job ?input_channel - input_channel ?output_channel - output_channel ?batch_package - batch_package)
    :precondition
      (and
        (source_job_input_prefetched ?source_job)
        (sink_job_output_prefetched ?sink_job)
        (source_job_input_channel_binding ?source_job ?input_channel)
        (sink_job_output_channel_binding ?sink_job ?output_channel)
        (input_channel_staged ?input_channel)
        (output_channel_prefetched ?output_channel)
        (not
          (source_job_ready ?source_job)
        )
        (sink_job_ready ?sink_job)
        (package_unstaged ?batch_package)
      )
    :effect
      (and
        (package_staged ?batch_package)
        (package_input_channel_binding ?batch_package ?input_channel)
        (package_output_channel_binding ?batch_package ?output_channel)
        (package_input_ready ?batch_package)
        (not
          (package_unstaged ?batch_package)
        )
      )
  )
  (:action stage_batch_package_with_output_ready
    :parameters (?source_job - source_job ?sink_job - sink_job ?input_channel - input_channel ?output_channel - output_channel ?batch_package - batch_package)
    :precondition
      (and
        (source_job_input_prefetched ?source_job)
        (sink_job_output_prefetched ?sink_job)
        (source_job_input_channel_binding ?source_job ?input_channel)
        (sink_job_output_channel_binding ?sink_job ?output_channel)
        (input_channel_prefetched ?input_channel)
        (output_channel_staged ?output_channel)
        (source_job_ready ?source_job)
        (not
          (sink_job_ready ?sink_job)
        )
        (package_unstaged ?batch_package)
      )
    :effect
      (and
        (package_staged ?batch_package)
        (package_input_channel_binding ?batch_package ?input_channel)
        (package_output_channel_binding ?batch_package ?output_channel)
        (package_output_ready ?batch_package)
        (not
          (package_unstaged ?batch_package)
        )
      )
  )
  (:action stage_batch_package_with_all_channels_ready
    :parameters (?source_job - source_job ?sink_job - sink_job ?input_channel - input_channel ?output_channel - output_channel ?batch_package - batch_package)
    :precondition
      (and
        (source_job_input_prefetched ?source_job)
        (sink_job_output_prefetched ?sink_job)
        (source_job_input_channel_binding ?source_job ?input_channel)
        (sink_job_output_channel_binding ?sink_job ?output_channel)
        (input_channel_staged ?input_channel)
        (output_channel_staged ?output_channel)
        (not
          (source_job_ready ?source_job)
        )
        (not
          (sink_job_ready ?sink_job)
        )
        (package_unstaged ?batch_package)
      )
    :effect
      (and
        (package_staged ?batch_package)
        (package_input_channel_binding ?batch_package ?input_channel)
        (package_output_channel_binding ?batch_package ?output_channel)
        (package_input_ready ?batch_package)
        (package_output_ready ?batch_package)
        (not
          (package_unstaged ?batch_package)
        )
      )
  )
  (:action finalize_package_for_execution
    :parameters (?batch_package - batch_package ?source_job - source_job ?input_shard - input_shard)
    :precondition
      (and
        (package_staged ?batch_package)
        (source_job_input_prefetched ?source_job)
        (job_bound_input_shard ?source_job ?input_shard)
        (not
          (package_finalized ?batch_package)
        )
      )
    :effect (package_finalized ?batch_package)
  )
  (:action attach_library_to_package
    :parameters (?processing_coordinator - processing_coordinator ?library_artifact - library_artifact ?batch_package - batch_package)
    :precondition
      (and
        (job_validated ?processing_coordinator)
        (coordinator_assigned_package ?processing_coordinator ?batch_package)
        (coordinator_has_library ?processing_coordinator ?library_artifact)
        (library_artifact_available ?library_artifact)
        (package_staged ?batch_package)
        (package_finalized ?batch_package)
        (not
          (library_staged ?library_artifact)
        )
      )
    :effect
      (and
        (library_staged ?library_artifact)
        (library_bound_to_package ?library_artifact ?batch_package)
        (not
          (library_artifact_available ?library_artifact)
        )
      )
  )
  (:action validate_library_binding_for_coordinator
    :parameters (?processing_coordinator - processing_coordinator ?library_artifact - library_artifact ?batch_package - batch_package ?input_shard - input_shard)
    :precondition
      (and
        (job_validated ?processing_coordinator)
        (coordinator_has_library ?processing_coordinator ?library_artifact)
        (library_staged ?library_artifact)
        (library_bound_to_package ?library_artifact ?batch_package)
        (job_bound_input_shard ?processing_coordinator ?input_shard)
        (not
          (package_input_ready ?batch_package)
        )
        (not
          (coordinator_artifacts_verified ?processing_coordinator)
        )
      )
    :effect (coordinator_artifacts_verified ?processing_coordinator)
  )
  (:action attach_credential_to_coordinator
    :parameters (?processing_coordinator - processing_coordinator ?credential - credential)
    :precondition
      (and
        (job_validated ?processing_coordinator)
        (credential_available ?credential)
        (not
          (coordinator_credential_attached ?processing_coordinator)
        )
      )
    :effect
      (and
        (coordinator_credential_attached ?processing_coordinator)
        (coordinator_credential_bound ?processing_coordinator ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action prepare_coordinator_with_library_and_credential
    :parameters (?processing_coordinator - processing_coordinator ?library_artifact - library_artifact ?batch_package - batch_package ?input_shard - input_shard ?credential - credential)
    :precondition
      (and
        (job_validated ?processing_coordinator)
        (coordinator_has_library ?processing_coordinator ?library_artifact)
        (library_staged ?library_artifact)
        (library_bound_to_package ?library_artifact ?batch_package)
        (job_bound_input_shard ?processing_coordinator ?input_shard)
        (package_input_ready ?batch_package)
        (coordinator_credential_attached ?processing_coordinator)
        (coordinator_credential_bound ?processing_coordinator ?credential)
        (not
          (coordinator_artifacts_verified ?processing_coordinator)
        )
      )
    :effect
      (and
        (coordinator_artifacts_verified ?processing_coordinator)
        (coordinator_credential_verified ?processing_coordinator)
      )
  )
  (:action validate_coordinator_artifact_bindings
    :parameters (?processing_coordinator - processing_coordinator ?tuning_parameter - tuning_parameter ?executor_instance - executor_instance ?library_artifact - library_artifact ?batch_package - batch_package)
    :precondition
      (and
        (coordinator_artifacts_verified ?processing_coordinator)
        (coordinator_has_tuning_parameter ?processing_coordinator ?tuning_parameter)
        (job_assigned_executor_instance ?processing_coordinator ?executor_instance)
        (coordinator_has_library ?processing_coordinator ?library_artifact)
        (library_bound_to_package ?library_artifact ?batch_package)
        (not
          (package_output_ready ?batch_package)
        )
        (not
          (coordinator_prepared ?processing_coordinator)
        )
      )
    :effect (coordinator_prepared ?processing_coordinator)
  )
  (:action confirm_coordinator_artifact_validation
    :parameters (?processing_coordinator - processing_coordinator ?tuning_parameter - tuning_parameter ?executor_instance - executor_instance ?library_artifact - library_artifact ?batch_package - batch_package)
    :precondition
      (and
        (coordinator_artifacts_verified ?processing_coordinator)
        (coordinator_has_tuning_parameter ?processing_coordinator ?tuning_parameter)
        (job_assigned_executor_instance ?processing_coordinator ?executor_instance)
        (coordinator_has_library ?processing_coordinator ?library_artifact)
        (library_bound_to_package ?library_artifact ?batch_package)
        (package_output_ready ?batch_package)
        (not
          (coordinator_prepared ?processing_coordinator)
        )
      )
    :effect (coordinator_prepared ?processing_coordinator)
  )
  (:action authorize_coordinator_deployment_general
    :parameters (?processing_coordinator - processing_coordinator ?deployment_descriptor - deployment_descriptor ?library_artifact - library_artifact ?batch_package - batch_package)
    :precondition
      (and
        (coordinator_prepared ?processing_coordinator)
        (coordinator_has_deployment_descriptor ?processing_coordinator ?deployment_descriptor)
        (coordinator_has_library ?processing_coordinator ?library_artifact)
        (library_bound_to_package ?library_artifact ?batch_package)
        (not
          (package_input_ready ?batch_package)
        )
        (not
          (package_output_ready ?batch_package)
        )
        (not
          (coordinator_authorized ?processing_coordinator)
        )
      )
    :effect (coordinator_authorized ?processing_coordinator)
  )
  (:action authorize_coordinator_deployment_with_input_ready
    :parameters (?processing_coordinator - processing_coordinator ?deployment_descriptor - deployment_descriptor ?library_artifact - library_artifact ?batch_package - batch_package)
    :precondition
      (and
        (coordinator_prepared ?processing_coordinator)
        (coordinator_has_deployment_descriptor ?processing_coordinator ?deployment_descriptor)
        (coordinator_has_library ?processing_coordinator ?library_artifact)
        (library_bound_to_package ?library_artifact ?batch_package)
        (package_input_ready ?batch_package)
        (not
          (package_output_ready ?batch_package)
        )
        (not
          (coordinator_authorized ?processing_coordinator)
        )
      )
    :effect
      (and
        (coordinator_authorized ?processing_coordinator)
        (coordinator_policy_present ?processing_coordinator)
      )
  )
  (:action authorize_coordinator_deployment_with_output_ready
    :parameters (?processing_coordinator - processing_coordinator ?deployment_descriptor - deployment_descriptor ?library_artifact - library_artifact ?batch_package - batch_package)
    :precondition
      (and
        (coordinator_prepared ?processing_coordinator)
        (coordinator_has_deployment_descriptor ?processing_coordinator ?deployment_descriptor)
        (coordinator_has_library ?processing_coordinator ?library_artifact)
        (library_bound_to_package ?library_artifact ?batch_package)
        (not
          (package_input_ready ?batch_package)
        )
        (package_output_ready ?batch_package)
        (not
          (coordinator_authorized ?processing_coordinator)
        )
      )
    :effect
      (and
        (coordinator_authorized ?processing_coordinator)
        (coordinator_policy_present ?processing_coordinator)
      )
  )
  (:action authorize_coordinator_deployment_with_all_channels_ready
    :parameters (?processing_coordinator - processing_coordinator ?deployment_descriptor - deployment_descriptor ?library_artifact - library_artifact ?batch_package - batch_package)
    :precondition
      (and
        (coordinator_prepared ?processing_coordinator)
        (coordinator_has_deployment_descriptor ?processing_coordinator ?deployment_descriptor)
        (coordinator_has_library ?processing_coordinator ?library_artifact)
        (library_bound_to_package ?library_artifact ?batch_package)
        (package_input_ready ?batch_package)
        (package_output_ready ?batch_package)
        (not
          (coordinator_authorized ?processing_coordinator)
        )
      )
    :effect
      (and
        (coordinator_authorized ?processing_coordinator)
        (coordinator_policy_present ?processing_coordinator)
      )
  )
  (:action grant_coordinator_ready_no_policy
    :parameters (?processing_coordinator - processing_coordinator)
    :precondition
      (and
        (coordinator_authorized ?processing_coordinator)
        (not
          (coordinator_policy_present ?processing_coordinator)
        )
        (not
          (coordinator_finalized ?processing_coordinator)
        )
      )
    :effect
      (and
        (coordinator_finalized ?processing_coordinator)
        (ready_for_execution ?processing_coordinator)
      )
  )
  (:action attach_policy_to_coordinator
    :parameters (?processing_coordinator - processing_coordinator ?policy - policy)
    :precondition
      (and
        (coordinator_authorized ?processing_coordinator)
        (coordinator_policy_present ?processing_coordinator)
        (policy_available ?policy)
      )
    :effect
      (and
        (coordinator_policy_bound ?processing_coordinator ?policy)
        (not
          (policy_available ?policy)
        )
      )
  )
  (:action complete_coordinator_authorization
    :parameters (?processing_coordinator - processing_coordinator ?source_job - source_job ?sink_job - sink_job ?input_shard - input_shard ?policy - policy)
    :precondition
      (and
        (coordinator_authorized ?processing_coordinator)
        (coordinator_policy_present ?processing_coordinator)
        (coordinator_policy_bound ?processing_coordinator ?policy)
        (coordinator_manages_source_job ?processing_coordinator ?source_job)
        (coordinator_manages_sink_job ?processing_coordinator ?sink_job)
        (source_job_ready ?source_job)
        (sink_job_ready ?sink_job)
        (job_bound_input_shard ?processing_coordinator ?input_shard)
        (not
          (coordinator_authorization_ready ?processing_coordinator)
        )
      )
    :effect (coordinator_authorization_ready ?processing_coordinator)
  )
  (:action commit_coordinator_authorization
    :parameters (?processing_coordinator - processing_coordinator)
    :precondition
      (and
        (coordinator_authorized ?processing_coordinator)
        (coordinator_authorization_ready ?processing_coordinator)
        (not
          (coordinator_finalized ?processing_coordinator)
        )
      )
    :effect
      (and
        (coordinator_finalized ?processing_coordinator)
        (ready_for_execution ?processing_coordinator)
      )
  )
  (:action claim_priority_tag_for_coordinator
    :parameters (?processing_coordinator - processing_coordinator ?priority_tag - priority_tag ?input_shard - input_shard)
    :precondition
      (and
        (job_validated ?processing_coordinator)
        (job_bound_input_shard ?processing_coordinator ?input_shard)
        (priority_tag_available ?priority_tag)
        (coordinator_has_priority_tag ?processing_coordinator ?priority_tag)
        (not
          (coordinator_priority_claimed ?processing_coordinator)
        )
      )
    :effect
      (and
        (coordinator_priority_claimed ?processing_coordinator)
        (not
          (priority_tag_available ?priority_tag)
        )
      )
  )
  (:action lock_executor_for_coordinator
    :parameters (?processing_coordinator - processing_coordinator ?executor_instance - executor_instance)
    :precondition
      (and
        (coordinator_priority_claimed ?processing_coordinator)
        (job_assigned_executor_instance ?processing_coordinator ?executor_instance)
        (not
          (coordinator_deployment_prepared ?processing_coordinator)
        )
      )
    :effect (coordinator_deployment_prepared ?processing_coordinator)
  )
  (:action apply_deployment_descriptor_to_coordinator
    :parameters (?processing_coordinator - processing_coordinator ?deployment_descriptor - deployment_descriptor)
    :precondition
      (and
        (coordinator_deployment_prepared ?processing_coordinator)
        (coordinator_has_deployment_descriptor ?processing_coordinator ?deployment_descriptor)
        (not
          (coordinator_deployment_applied ?processing_coordinator)
        )
      )
    :effect (coordinator_deployment_applied ?processing_coordinator)
  )
  (:action finalize_deployment_authorization
    :parameters (?processing_coordinator - processing_coordinator)
    :precondition
      (and
        (coordinator_deployment_applied ?processing_coordinator)
        (not
          (coordinator_finalized ?processing_coordinator)
        )
      )
    :effect
      (and
        (coordinator_finalized ?processing_coordinator)
        (ready_for_execution ?processing_coordinator)
      )
  )
  (:action mark_source_job_ready
    :parameters (?source_job - source_job ?batch_package - batch_package)
    :precondition
      (and
        (source_job_input_prefetched ?source_job)
        (source_job_ready ?source_job)
        (package_staged ?batch_package)
        (package_finalized ?batch_package)
        (not
          (ready_for_execution ?source_job)
        )
      )
    :effect (ready_for_execution ?source_job)
  )
  (:action mark_sink_job_ready
    :parameters (?sink_job - sink_job ?batch_package - batch_package)
    :precondition
      (and
        (sink_job_output_prefetched ?sink_job)
        (sink_job_ready ?sink_job)
        (package_staged ?batch_package)
        (package_finalized ?batch_package)
        (not
          (ready_for_execution ?sink_job)
        )
      )
    :effect (ready_for_execution ?sink_job)
  )
  (:action record_job_output
    :parameters (?batch_job - batch_job ?storage_endpoint - storage_endpoint ?input_shard - input_shard)
    :precondition
      (and
        (ready_for_execution ?batch_job)
        (job_bound_input_shard ?batch_job ?input_shard)
        (storage_endpoint_available ?storage_endpoint)
        (not
          (job_run_completed ?batch_job)
        )
      )
    :effect
      (and
        (job_run_completed ?batch_job)
        (job_output_registered_to_storage ?batch_job ?storage_endpoint)
        (not
          (storage_endpoint_available ?storage_endpoint)
        )
      )
  )
  (:action finalize_source_job_completion
    :parameters (?source_job - source_job ?compute_slot - compute_slot ?storage_endpoint - storage_endpoint)
    :precondition
      (and
        (job_run_completed ?source_job)
        (job_assigned_compute_slot ?source_job ?compute_slot)
        (job_output_registered_to_storage ?source_job ?storage_endpoint)
        (not
          (job_completed ?source_job)
        )
      )
    :effect
      (and
        (job_completed ?source_job)
        (compute_slot_available ?compute_slot)
        (storage_endpoint_available ?storage_endpoint)
      )
  )
  (:action finalize_sink_job_completion
    :parameters (?sink_job - sink_job ?compute_slot - compute_slot ?storage_endpoint - storage_endpoint)
    :precondition
      (and
        (job_run_completed ?sink_job)
        (job_assigned_compute_slot ?sink_job ?compute_slot)
        (job_output_registered_to_storage ?sink_job ?storage_endpoint)
        (not
          (job_completed ?sink_job)
        )
      )
    :effect
      (and
        (job_completed ?sink_job)
        (compute_slot_available ?compute_slot)
        (storage_endpoint_available ?storage_endpoint)
      )
  )
  (:action finalize_coordinator_completion
    :parameters (?processing_coordinator - processing_coordinator ?compute_slot - compute_slot ?storage_endpoint - storage_endpoint)
    :precondition
      (and
        (job_run_completed ?processing_coordinator)
        (job_assigned_compute_slot ?processing_coordinator ?compute_slot)
        (job_output_registered_to_storage ?processing_coordinator ?storage_endpoint)
        (not
          (job_completed ?processing_coordinator)
        )
      )
    :effect
      (and
        (job_completed ?processing_coordinator)
        (compute_slot_available ?compute_slot)
        (storage_endpoint_available ?storage_endpoint)
      )
  )
)

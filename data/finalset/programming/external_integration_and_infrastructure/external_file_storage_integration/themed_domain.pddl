(define (domain external_file_storage_integration)
  (:requirements :strips :typing :negative-preconditions)
  (:types integration_resource - object transfer_artifact - object channel_storage_group - object integration_entity_root - object integration_entity - integration_entity_root credential - integration_resource file_descriptor - integration_resource connection_slot - integration_resource access_policy - integration_resource configuration_parameter - integration_resource operation_ticket - integration_resource processor - integration_resource validator - integration_resource transient_artifact - transfer_artifact file_payload - transfer_artifact verifier - transfer_artifact source_channel - channel_storage_group destination_channel - channel_storage_group storage_resource - channel_storage_group endpoint_entity - integration_entity orchestrator_entity - integration_entity source_endpoint - endpoint_entity destination_endpoint - endpoint_entity orchestrator_service - orchestrator_entity)
  (:predicates
    (entity_registered ?integration_entity - integration_entity)
    (descriptor_confirmed ?integration_entity - integration_entity)
    (credential_attached ?integration_entity - integration_entity)
    (entity_integrated ?integration_entity - integration_entity)
    (ready_for_activation ?integration_entity - integration_entity)
    (operation_authorized ?integration_entity - integration_entity)
    (credential_available ?credential - credential)
    (entity_has_credential ?integration_entity - integration_entity ?credential - credential)
    (file_descriptor_available ?file_descriptor - file_descriptor)
    (entity_has_file_descriptor ?integration_entity - integration_entity ?file_descriptor - file_descriptor)
    (connection_slot_available ?connection_slot - connection_slot)
    (entity_has_connection_slot ?integration_entity - integration_entity ?connection_slot - connection_slot)
    (transient_artifact_available ?transient_artifact - transient_artifact)
    (source_has_transient_artifact ?source_endpoint - source_endpoint ?transient_artifact - transient_artifact)
    (destination_has_transient_artifact ?destination_endpoint - destination_endpoint ?transient_artifact - transient_artifact)
    (source_endpoint_has_channel ?source_endpoint - source_endpoint ?source_channel - source_channel)
    (source_channel_ready ?source_channel - source_channel)
    (source_channel_staged ?source_channel - source_channel)
    (source_endpoint_prepared ?source_endpoint - source_endpoint)
    (destination_endpoint_has_channel ?destination_endpoint - destination_endpoint ?destination_channel - destination_channel)
    (destination_channel_ready ?destination_channel - destination_channel)
    (destination_channel_staged ?destination_channel - destination_channel)
    (destination_endpoint_prepared ?destination_endpoint - destination_endpoint)
    (storage_resource_available ?external_storage_resource - storage_resource)
    (storage_resource_reserved ?external_storage_resource - storage_resource)
    (storage_bound_to_source_channel ?external_storage_resource - storage_resource ?source_channel - source_channel)
    (storage_bound_to_destination_channel ?external_storage_resource - storage_resource ?destination_channel - destination_channel)
    (storage_requires_policy ?external_storage_resource - storage_resource)
    (storage_requires_attribute ?external_storage_resource - storage_resource)
    (storage_payload_attached ?external_storage_resource - storage_resource)
    (orchestrator_manages_source_endpoint ?orchestrator_service - orchestrator_service ?source_endpoint - source_endpoint)
    (orchestrator_manages_destination_endpoint ?orchestrator_service - orchestrator_service ?destination_endpoint - destination_endpoint)
    (orchestrator_has_storage_resource ?orchestrator_service - orchestrator_service ?external_storage_resource - storage_resource)
    (file_payload_available ?file_payload - file_payload)
    (orchestrator_has_file_payload ?orchestrator_service - orchestrator_service ?file_payload - file_payload)
    (payload_registered ?file_payload - file_payload)
    (payload_bound_to_storage ?file_payload - file_payload ?external_storage_resource - storage_resource)
    (orchestrator_processing_claimed ?orchestrator_service - orchestrator_service)
    (orchestrator_processing_stage_assigned ?orchestrator_service - orchestrator_service)
    (orchestrator_verified ?orchestrator_service - orchestrator_service)
    (orchestrator_policy_applied ?orchestrator_service - orchestrator_service)
    (orchestrator_policy_committed ?orchestrator_service - orchestrator_service)
    (orchestrator_configuration_applied ?orchestrator_service - orchestrator_service)
    (orchestrator_finalized_for_activation ?orchestrator_service - orchestrator_service)
    (verifier_available ?verifier - verifier)
    (orchestrator_has_verifier ?orchestrator_service - orchestrator_service ?verifier - verifier)
    (context_applied ?orchestrator_service - orchestrator_service)
    (context_step_one_complete ?orchestrator_service - orchestrator_service)
    (context_step_two_complete ?orchestrator_service - orchestrator_service)
    (access_policy_available ?access_policy - access_policy)
    (orchestrator_has_access_policy ?orchestrator_service - orchestrator_service ?access_policy - access_policy)
    (config_parameter_available ?configuration_parameter - configuration_parameter)
    (orchestrator_has_config_parameter ?orchestrator_service - orchestrator_service ?configuration_parameter - configuration_parameter)
    (processor_available ?processor - processor)
    (orchestrator_has_processor ?orchestrator_service - orchestrator_service ?processor - processor)
    (validator_available ?validator - validator)
    (orchestrator_has_validator ?orchestrator_service - orchestrator_service ?validator - validator)
    (operation_ticket_available ?operation_ticket - operation_ticket)
    (entity_has_operation_ticket ?integration_entity - integration_entity ?operation_ticket - operation_ticket)
    (source_endpoint_ready ?source_endpoint - source_endpoint)
    (destination_endpoint_ready ?destination_endpoint - destination_endpoint)
    (orchestrator_committed ?orchestrator_service - orchestrator_service)
  )
  (:action register_integration_entity
    :parameters (?integration_entity - integration_entity)
    :precondition
      (and
        (not
          (entity_registered ?integration_entity)
        )
        (not
          (entity_integrated ?integration_entity)
        )
      )
    :effect (entity_registered ?integration_entity)
  )
  (:action bind_credential_to_entity
    :parameters (?integration_entity - integration_entity ?credential - credential)
    :precondition
      (and
        (entity_registered ?integration_entity)
        (not
          (credential_attached ?integration_entity)
        )
        (credential_available ?credential)
      )
    :effect
      (and
        (credential_attached ?integration_entity)
        (entity_has_credential ?integration_entity ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action bind_file_descriptor_to_entity
    :parameters (?integration_entity - integration_entity ?file_descriptor - file_descriptor)
    :precondition
      (and
        (entity_registered ?integration_entity)
        (credential_attached ?integration_entity)
        (file_descriptor_available ?file_descriptor)
      )
    :effect
      (and
        (entity_has_file_descriptor ?integration_entity ?file_descriptor)
        (not
          (file_descriptor_available ?file_descriptor)
        )
      )
  )
  (:action confirm_file_descriptor_binding
    :parameters (?integration_entity - integration_entity ?file_descriptor - file_descriptor)
    :precondition
      (and
        (entity_registered ?integration_entity)
        (credential_attached ?integration_entity)
        (entity_has_file_descriptor ?integration_entity ?file_descriptor)
        (not
          (descriptor_confirmed ?integration_entity)
        )
      )
    :effect (descriptor_confirmed ?integration_entity)
  )
  (:action release_file_descriptor
    :parameters (?integration_entity - integration_entity ?file_descriptor - file_descriptor)
    :precondition
      (and
        (entity_has_file_descriptor ?integration_entity ?file_descriptor)
      )
    :effect
      (and
        (file_descriptor_available ?file_descriptor)
        (not
          (entity_has_file_descriptor ?integration_entity ?file_descriptor)
        )
      )
  )
  (:action assign_connection_slot
    :parameters (?integration_entity - integration_entity ?connection_slot - connection_slot)
    :precondition
      (and
        (descriptor_confirmed ?integration_entity)
        (connection_slot_available ?connection_slot)
      )
    :effect
      (and
        (entity_has_connection_slot ?integration_entity ?connection_slot)
        (not
          (connection_slot_available ?connection_slot)
        )
      )
  )
  (:action release_connection_slot
    :parameters (?integration_entity - integration_entity ?connection_slot - connection_slot)
    :precondition
      (and
        (entity_has_connection_slot ?integration_entity ?connection_slot)
      )
    :effect
      (and
        (connection_slot_available ?connection_slot)
        (not
          (entity_has_connection_slot ?integration_entity ?connection_slot)
        )
      )
  )
  (:action attach_processor_to_orchestrator
    :parameters (?orchestrator_service - orchestrator_service ?processor - processor)
    :precondition
      (and
        (descriptor_confirmed ?orchestrator_service)
        (processor_available ?processor)
      )
    :effect
      (and
        (orchestrator_has_processor ?orchestrator_service ?processor)
        (not
          (processor_available ?processor)
        )
      )
  )
  (:action detach_processor_from_orchestrator
    :parameters (?orchestrator_service - orchestrator_service ?processor - processor)
    :precondition
      (and
        (orchestrator_has_processor ?orchestrator_service ?processor)
      )
    :effect
      (and
        (processor_available ?processor)
        (not
          (orchestrator_has_processor ?orchestrator_service ?processor)
        )
      )
  )
  (:action attach_validator_to_orchestrator
    :parameters (?orchestrator_service - orchestrator_service ?validator - validator)
    :precondition
      (and
        (descriptor_confirmed ?orchestrator_service)
        (validator_available ?validator)
      )
    :effect
      (and
        (orchestrator_has_validator ?orchestrator_service ?validator)
        (not
          (validator_available ?validator)
        )
      )
  )
  (:action detach_validator_from_orchestrator
    :parameters (?orchestrator_service - orchestrator_service ?validator - validator)
    :precondition
      (and
        (orchestrator_has_validator ?orchestrator_service ?validator)
      )
    :effect
      (and
        (validator_available ?validator)
        (not
          (orchestrator_has_validator ?orchestrator_service ?validator)
        )
      )
  )
  (:action prepare_source_channel_for_transfer
    :parameters (?source_endpoint - source_endpoint ?source_channel - source_channel ?file_descriptor - file_descriptor)
    :precondition
      (and
        (descriptor_confirmed ?source_endpoint)
        (entity_has_file_descriptor ?source_endpoint ?file_descriptor)
        (source_endpoint_has_channel ?source_endpoint ?source_channel)
        (not
          (source_channel_ready ?source_channel)
        )
        (not
          (source_channel_staged ?source_channel)
        )
      )
    :effect (source_channel_ready ?source_channel)
  )
  (:action prepare_source_endpoint_with_slot
    :parameters (?source_endpoint - source_endpoint ?source_channel - source_channel ?connection_slot - connection_slot)
    :precondition
      (and
        (descriptor_confirmed ?source_endpoint)
        (entity_has_connection_slot ?source_endpoint ?connection_slot)
        (source_endpoint_has_channel ?source_endpoint ?source_channel)
        (source_channel_ready ?source_channel)
        (not
          (source_endpoint_ready ?source_endpoint)
        )
      )
    :effect
      (and
        (source_endpoint_ready ?source_endpoint)
        (source_endpoint_prepared ?source_endpoint)
      )
  )
  (:action attach_transient_artifact_to_source_channel
    :parameters (?source_endpoint - source_endpoint ?source_channel - source_channel ?transient_artifact - transient_artifact)
    :precondition
      (and
        (descriptor_confirmed ?source_endpoint)
        (source_endpoint_has_channel ?source_endpoint ?source_channel)
        (transient_artifact_available ?transient_artifact)
        (not
          (source_endpoint_ready ?source_endpoint)
        )
      )
    :effect
      (and
        (source_channel_staged ?source_channel)
        (source_endpoint_ready ?source_endpoint)
        (source_has_transient_artifact ?source_endpoint ?transient_artifact)
        (not
          (transient_artifact_available ?transient_artifact)
        )
      )
  )
  (:action commit_transient_to_source_channel
    :parameters (?source_endpoint - source_endpoint ?source_channel - source_channel ?file_descriptor - file_descriptor ?transient_artifact - transient_artifact)
    :precondition
      (and
        (descriptor_confirmed ?source_endpoint)
        (entity_has_file_descriptor ?source_endpoint ?file_descriptor)
        (source_endpoint_has_channel ?source_endpoint ?source_channel)
        (source_channel_staged ?source_channel)
        (source_has_transient_artifact ?source_endpoint ?transient_artifact)
        (not
          (source_endpoint_prepared ?source_endpoint)
        )
      )
    :effect
      (and
        (source_channel_ready ?source_channel)
        (source_endpoint_prepared ?source_endpoint)
        (transient_artifact_available ?transient_artifact)
        (not
          (source_has_transient_artifact ?source_endpoint ?transient_artifact)
        )
      )
  )
  (:action prepare_destination_channel_for_transfer
    :parameters (?destination_endpoint - destination_endpoint ?destination_channel - destination_channel ?file_descriptor - file_descriptor)
    :precondition
      (and
        (descriptor_confirmed ?destination_endpoint)
        (entity_has_file_descriptor ?destination_endpoint ?file_descriptor)
        (destination_endpoint_has_channel ?destination_endpoint ?destination_channel)
        (not
          (destination_channel_ready ?destination_channel)
        )
        (not
          (destination_channel_staged ?destination_channel)
        )
      )
    :effect (destination_channel_ready ?destination_channel)
  )
  (:action prepare_destination_endpoint_with_slot
    :parameters (?destination_endpoint - destination_endpoint ?destination_channel - destination_channel ?connection_slot - connection_slot)
    :precondition
      (and
        (descriptor_confirmed ?destination_endpoint)
        (entity_has_connection_slot ?destination_endpoint ?connection_slot)
        (destination_endpoint_has_channel ?destination_endpoint ?destination_channel)
        (destination_channel_ready ?destination_channel)
        (not
          (destination_endpoint_ready ?destination_endpoint)
        )
      )
    :effect
      (and
        (destination_endpoint_ready ?destination_endpoint)
        (destination_endpoint_prepared ?destination_endpoint)
      )
  )
  (:action attach_transient_artifact_to_destination_channel
    :parameters (?destination_endpoint - destination_endpoint ?destination_channel - destination_channel ?transient_artifact - transient_artifact)
    :precondition
      (and
        (descriptor_confirmed ?destination_endpoint)
        (destination_endpoint_has_channel ?destination_endpoint ?destination_channel)
        (transient_artifact_available ?transient_artifact)
        (not
          (destination_endpoint_ready ?destination_endpoint)
        )
      )
    :effect
      (and
        (destination_channel_staged ?destination_channel)
        (destination_endpoint_ready ?destination_endpoint)
        (destination_has_transient_artifact ?destination_endpoint ?transient_artifact)
        (not
          (transient_artifact_available ?transient_artifact)
        )
      )
  )
  (:action commit_transient_to_destination_channel
    :parameters (?destination_endpoint - destination_endpoint ?destination_channel - destination_channel ?file_descriptor - file_descriptor ?transient_artifact - transient_artifact)
    :precondition
      (and
        (descriptor_confirmed ?destination_endpoint)
        (entity_has_file_descriptor ?destination_endpoint ?file_descriptor)
        (destination_endpoint_has_channel ?destination_endpoint ?destination_channel)
        (destination_channel_staged ?destination_channel)
        (destination_has_transient_artifact ?destination_endpoint ?transient_artifact)
        (not
          (destination_endpoint_prepared ?destination_endpoint)
        )
      )
    :effect
      (and
        (destination_channel_ready ?destination_channel)
        (destination_endpoint_prepared ?destination_endpoint)
        (transient_artifact_available ?transient_artifact)
        (not
          (destination_has_transient_artifact ?destination_endpoint ?transient_artifact)
        )
      )
  )
  (:action assemble_storage_resource
    :parameters (?source_endpoint - source_endpoint ?destination_endpoint - destination_endpoint ?source_channel - source_channel ?destination_channel - destination_channel ?external_storage_resource - storage_resource)
    :precondition
      (and
        (source_endpoint_ready ?source_endpoint)
        (destination_endpoint_ready ?destination_endpoint)
        (source_endpoint_has_channel ?source_endpoint ?source_channel)
        (destination_endpoint_has_channel ?destination_endpoint ?destination_channel)
        (source_channel_ready ?source_channel)
        (destination_channel_ready ?destination_channel)
        (source_endpoint_prepared ?source_endpoint)
        (destination_endpoint_prepared ?destination_endpoint)
        (storage_resource_available ?external_storage_resource)
      )
    :effect
      (and
        (storage_resource_reserved ?external_storage_resource)
        (storage_bound_to_source_channel ?external_storage_resource ?source_channel)
        (storage_bound_to_destination_channel ?external_storage_resource ?destination_channel)
        (not
          (storage_resource_available ?external_storage_resource)
        )
      )
  )
  (:action assemble_storage_resource_mark_policy_required
    :parameters (?source_endpoint - source_endpoint ?destination_endpoint - destination_endpoint ?source_channel - source_channel ?destination_channel - destination_channel ?external_storage_resource - storage_resource)
    :precondition
      (and
        (source_endpoint_ready ?source_endpoint)
        (destination_endpoint_ready ?destination_endpoint)
        (source_endpoint_has_channel ?source_endpoint ?source_channel)
        (destination_endpoint_has_channel ?destination_endpoint ?destination_channel)
        (source_channel_staged ?source_channel)
        (destination_channel_ready ?destination_channel)
        (not
          (source_endpoint_prepared ?source_endpoint)
        )
        (destination_endpoint_prepared ?destination_endpoint)
        (storage_resource_available ?external_storage_resource)
      )
    :effect
      (and
        (storage_resource_reserved ?external_storage_resource)
        (storage_bound_to_source_channel ?external_storage_resource ?source_channel)
        (storage_bound_to_destination_channel ?external_storage_resource ?destination_channel)
        (storage_requires_policy ?external_storage_resource)
        (not
          (storage_resource_available ?external_storage_resource)
        )
      )
  )
  (:action assemble_storage_resource_mark_attribute_required
    :parameters (?source_endpoint - source_endpoint ?destination_endpoint - destination_endpoint ?source_channel - source_channel ?destination_channel - destination_channel ?external_storage_resource - storage_resource)
    :precondition
      (and
        (source_endpoint_ready ?source_endpoint)
        (destination_endpoint_ready ?destination_endpoint)
        (source_endpoint_has_channel ?source_endpoint ?source_channel)
        (destination_endpoint_has_channel ?destination_endpoint ?destination_channel)
        (source_channel_ready ?source_channel)
        (destination_channel_staged ?destination_channel)
        (source_endpoint_prepared ?source_endpoint)
        (not
          (destination_endpoint_prepared ?destination_endpoint)
        )
        (storage_resource_available ?external_storage_resource)
      )
    :effect
      (and
        (storage_resource_reserved ?external_storage_resource)
        (storage_bound_to_source_channel ?external_storage_resource ?source_channel)
        (storage_bound_to_destination_channel ?external_storage_resource ?destination_channel)
        (storage_requires_attribute ?external_storage_resource)
        (not
          (storage_resource_available ?external_storage_resource)
        )
      )
  )
  (:action assemble_storage_resource_mark_policy_and_attribute
    :parameters (?source_endpoint - source_endpoint ?destination_endpoint - destination_endpoint ?source_channel - source_channel ?destination_channel - destination_channel ?external_storage_resource - storage_resource)
    :precondition
      (and
        (source_endpoint_ready ?source_endpoint)
        (destination_endpoint_ready ?destination_endpoint)
        (source_endpoint_has_channel ?source_endpoint ?source_channel)
        (destination_endpoint_has_channel ?destination_endpoint ?destination_channel)
        (source_channel_staged ?source_channel)
        (destination_channel_staged ?destination_channel)
        (not
          (source_endpoint_prepared ?source_endpoint)
        )
        (not
          (destination_endpoint_prepared ?destination_endpoint)
        )
        (storage_resource_available ?external_storage_resource)
      )
    :effect
      (and
        (storage_resource_reserved ?external_storage_resource)
        (storage_bound_to_source_channel ?external_storage_resource ?source_channel)
        (storage_bound_to_destination_channel ?external_storage_resource ?destination_channel)
        (storage_requires_policy ?external_storage_resource)
        (storage_requires_attribute ?external_storage_resource)
        (not
          (storage_resource_available ?external_storage_resource)
        )
      )
  )
  (:action attach_payload_to_storage_resource
    :parameters (?external_storage_resource - storage_resource ?source_endpoint - source_endpoint ?file_descriptor - file_descriptor)
    :precondition
      (and
        (storage_resource_reserved ?external_storage_resource)
        (source_endpoint_ready ?source_endpoint)
        (entity_has_file_descriptor ?source_endpoint ?file_descriptor)
        (not
          (storage_payload_attached ?external_storage_resource)
        )
      )
    :effect (storage_payload_attached ?external_storage_resource)
  )
  (:action register_payload_with_orchestrator_and_bind_resource
    :parameters (?orchestrator_service - orchestrator_service ?file_payload - file_payload ?external_storage_resource - storage_resource)
    :precondition
      (and
        (descriptor_confirmed ?orchestrator_service)
        (orchestrator_has_storage_resource ?orchestrator_service ?external_storage_resource)
        (orchestrator_has_file_payload ?orchestrator_service ?file_payload)
        (file_payload_available ?file_payload)
        (storage_resource_reserved ?external_storage_resource)
        (storage_payload_attached ?external_storage_resource)
        (not
          (payload_registered ?file_payload)
        )
      )
    :effect
      (and
        (payload_registered ?file_payload)
        (payload_bound_to_storage ?file_payload ?external_storage_resource)
        (not
          (file_payload_available ?file_payload)
        )
      )
  )
  (:action claim_payload_for_processing
    :parameters (?orchestrator_service - orchestrator_service ?file_payload - file_payload ?external_storage_resource - storage_resource ?file_descriptor - file_descriptor)
    :precondition
      (and
        (descriptor_confirmed ?orchestrator_service)
        (orchestrator_has_file_payload ?orchestrator_service ?file_payload)
        (payload_registered ?file_payload)
        (payload_bound_to_storage ?file_payload ?external_storage_resource)
        (entity_has_file_descriptor ?orchestrator_service ?file_descriptor)
        (not
          (storage_requires_policy ?external_storage_resource)
        )
        (not
          (orchestrator_processing_claimed ?orchestrator_service)
        )
      )
    :effect (orchestrator_processing_claimed ?orchestrator_service)
  )
  (:action apply_access_policy
    :parameters (?orchestrator_service - orchestrator_service ?access_policy - access_policy)
    :precondition
      (and
        (descriptor_confirmed ?orchestrator_service)
        (access_policy_available ?access_policy)
        (not
          (orchestrator_policy_applied ?orchestrator_service)
        )
      )
    :effect
      (and
        (orchestrator_policy_applied ?orchestrator_service)
        (orchestrator_has_access_policy ?orchestrator_service ?access_policy)
        (not
          (access_policy_available ?access_policy)
        )
      )
  )
  (:action commit_access_policy_to_orchestrator
    :parameters (?orchestrator_service - orchestrator_service ?file_payload - file_payload ?external_storage_resource - storage_resource ?file_descriptor - file_descriptor ?access_policy - access_policy)
    :precondition
      (and
        (descriptor_confirmed ?orchestrator_service)
        (orchestrator_has_file_payload ?orchestrator_service ?file_payload)
        (payload_registered ?file_payload)
        (payload_bound_to_storage ?file_payload ?external_storage_resource)
        (entity_has_file_descriptor ?orchestrator_service ?file_descriptor)
        (storage_requires_policy ?external_storage_resource)
        (orchestrator_policy_applied ?orchestrator_service)
        (orchestrator_has_access_policy ?orchestrator_service ?access_policy)
        (not
          (orchestrator_processing_claimed ?orchestrator_service)
        )
      )
    :effect
      (and
        (orchestrator_processing_claimed ?orchestrator_service)
        (orchestrator_policy_committed ?orchestrator_service)
      )
  )
  (:action start_payload_processing_stage1
    :parameters (?orchestrator_service - orchestrator_service ?processor - processor ?connection_slot - connection_slot ?file_payload - file_payload ?external_storage_resource - storage_resource)
    :precondition
      (and
        (orchestrator_processing_claimed ?orchestrator_service)
        (orchestrator_has_processor ?orchestrator_service ?processor)
        (entity_has_connection_slot ?orchestrator_service ?connection_slot)
        (orchestrator_has_file_payload ?orchestrator_service ?file_payload)
        (payload_bound_to_storage ?file_payload ?external_storage_resource)
        (not
          (storage_requires_attribute ?external_storage_resource)
        )
        (not
          (orchestrator_processing_stage_assigned ?orchestrator_service)
        )
      )
    :effect (orchestrator_processing_stage_assigned ?orchestrator_service)
  )
  (:action start_payload_processing_stage1_with_attribute
    :parameters (?orchestrator_service - orchestrator_service ?processor - processor ?connection_slot - connection_slot ?file_payload - file_payload ?external_storage_resource - storage_resource)
    :precondition
      (and
        (orchestrator_processing_claimed ?orchestrator_service)
        (orchestrator_has_processor ?orchestrator_service ?processor)
        (entity_has_connection_slot ?orchestrator_service ?connection_slot)
        (orchestrator_has_file_payload ?orchestrator_service ?file_payload)
        (payload_bound_to_storage ?file_payload ?external_storage_resource)
        (storage_requires_attribute ?external_storage_resource)
        (not
          (orchestrator_processing_stage_assigned ?orchestrator_service)
        )
      )
    :effect (orchestrator_processing_stage_assigned ?orchestrator_service)
  )
  (:action run_validation
    :parameters (?orchestrator_service - orchestrator_service ?validator - validator ?file_payload - file_payload ?external_storage_resource - storage_resource)
    :precondition
      (and
        (orchestrator_processing_stage_assigned ?orchestrator_service)
        (orchestrator_has_validator ?orchestrator_service ?validator)
        (orchestrator_has_file_payload ?orchestrator_service ?file_payload)
        (payload_bound_to_storage ?file_payload ?external_storage_resource)
        (not
          (storage_requires_policy ?external_storage_resource)
        )
        (not
          (storage_requires_attribute ?external_storage_resource)
        )
        (not
          (orchestrator_verified ?orchestrator_service)
        )
      )
    :effect (orchestrator_verified ?orchestrator_service)
  )
  (:action run_validation_with_configuration
    :parameters (?orchestrator_service - orchestrator_service ?validator - validator ?file_payload - file_payload ?external_storage_resource - storage_resource)
    :precondition
      (and
        (orchestrator_processing_stage_assigned ?orchestrator_service)
        (orchestrator_has_validator ?orchestrator_service ?validator)
        (orchestrator_has_file_payload ?orchestrator_service ?file_payload)
        (payload_bound_to_storage ?file_payload ?external_storage_resource)
        (storage_requires_policy ?external_storage_resource)
        (not
          (storage_requires_attribute ?external_storage_resource)
        )
        (not
          (orchestrator_verified ?orchestrator_service)
        )
      )
    :effect
      (and
        (orchestrator_verified ?orchestrator_service)
        (orchestrator_configuration_applied ?orchestrator_service)
      )
  )
  (:action run_validation_with_attribute
    :parameters (?orchestrator_service - orchestrator_service ?validator - validator ?file_payload - file_payload ?external_storage_resource - storage_resource)
    :precondition
      (and
        (orchestrator_processing_stage_assigned ?orchestrator_service)
        (orchestrator_has_validator ?orchestrator_service ?validator)
        (orchestrator_has_file_payload ?orchestrator_service ?file_payload)
        (payload_bound_to_storage ?file_payload ?external_storage_resource)
        (not
          (storage_requires_policy ?external_storage_resource)
        )
        (storage_requires_attribute ?external_storage_resource)
        (not
          (orchestrator_verified ?orchestrator_service)
        )
      )
    :effect
      (and
        (orchestrator_verified ?orchestrator_service)
        (orchestrator_configuration_applied ?orchestrator_service)
      )
  )
  (:action run_validation_with_policy_and_attribute
    :parameters (?orchestrator_service - orchestrator_service ?validator - validator ?file_payload - file_payload ?external_storage_resource - storage_resource)
    :precondition
      (and
        (orchestrator_processing_stage_assigned ?orchestrator_service)
        (orchestrator_has_validator ?orchestrator_service ?validator)
        (orchestrator_has_file_payload ?orchestrator_service ?file_payload)
        (payload_bound_to_storage ?file_payload ?external_storage_resource)
        (storage_requires_policy ?external_storage_resource)
        (storage_requires_attribute ?external_storage_resource)
        (not
          (orchestrator_verified ?orchestrator_service)
        )
      )
    :effect
      (and
        (orchestrator_verified ?orchestrator_service)
        (orchestrator_configuration_applied ?orchestrator_service)
      )
  )
  (:action finalize_orchestrator_activation
    :parameters (?orchestrator_service - orchestrator_service)
    :precondition
      (and
        (orchestrator_verified ?orchestrator_service)
        (not
          (orchestrator_configuration_applied ?orchestrator_service)
        )
        (not
          (orchestrator_committed ?orchestrator_service)
        )
      )
    :effect
      (and
        (orchestrator_committed ?orchestrator_service)
        (ready_for_activation ?orchestrator_service)
      )
  )
  (:action bind_config_parameter_to_orchestrator
    :parameters (?orchestrator_service - orchestrator_service ?configuration_parameter - configuration_parameter)
    :precondition
      (and
        (orchestrator_verified ?orchestrator_service)
        (orchestrator_configuration_applied ?orchestrator_service)
        (config_parameter_available ?configuration_parameter)
      )
    :effect
      (and
        (orchestrator_has_config_parameter ?orchestrator_service ?configuration_parameter)
        (not
          (config_parameter_available ?configuration_parameter)
        )
      )
  )
  (:action prepare_orchestrator_for_activation
    :parameters (?orchestrator_service - orchestrator_service ?source_endpoint - source_endpoint ?destination_endpoint - destination_endpoint ?file_descriptor - file_descriptor ?configuration_parameter - configuration_parameter)
    :precondition
      (and
        (orchestrator_verified ?orchestrator_service)
        (orchestrator_configuration_applied ?orchestrator_service)
        (orchestrator_has_config_parameter ?orchestrator_service ?configuration_parameter)
        (orchestrator_manages_source_endpoint ?orchestrator_service ?source_endpoint)
        (orchestrator_manages_destination_endpoint ?orchestrator_service ?destination_endpoint)
        (source_endpoint_prepared ?source_endpoint)
        (destination_endpoint_prepared ?destination_endpoint)
        (entity_has_file_descriptor ?orchestrator_service ?file_descriptor)
        (not
          (orchestrator_finalized_for_activation ?orchestrator_service)
        )
      )
    :effect (orchestrator_finalized_for_activation ?orchestrator_service)
  )
  (:action finalize_orchestrator_activation_after_preparation
    :parameters (?orchestrator_service - orchestrator_service)
    :precondition
      (and
        (orchestrator_verified ?orchestrator_service)
        (orchestrator_finalized_for_activation ?orchestrator_service)
        (not
          (orchestrator_committed ?orchestrator_service)
        )
      )
    :effect
      (and
        (orchestrator_committed ?orchestrator_service)
        (ready_for_activation ?orchestrator_service)
      )
  )
  (:action apply_context_verifier
    :parameters (?orchestrator_service - orchestrator_service ?verifier - verifier ?file_descriptor - file_descriptor)
    :precondition
      (and
        (descriptor_confirmed ?orchestrator_service)
        (entity_has_file_descriptor ?orchestrator_service ?file_descriptor)
        (verifier_available ?verifier)
        (orchestrator_has_verifier ?orchestrator_service ?verifier)
        (not
          (context_applied ?orchestrator_service)
        )
      )
    :effect
      (and
        (context_applied ?orchestrator_service)
        (not
          (verifier_available ?verifier)
        )
      )
  )
  (:action apply_context_slot_binding
    :parameters (?orchestrator_service - orchestrator_service ?connection_slot - connection_slot)
    :precondition
      (and
        (context_applied ?orchestrator_service)
        (entity_has_connection_slot ?orchestrator_service ?connection_slot)
        (not
          (context_step_one_complete ?orchestrator_service)
        )
      )
    :effect (context_step_one_complete ?orchestrator_service)
  )
  (:action apply_context_validator
    :parameters (?orchestrator_service - orchestrator_service ?validator - validator)
    :precondition
      (and
        (context_step_one_complete ?orchestrator_service)
        (orchestrator_has_validator ?orchestrator_service ?validator)
        (not
          (context_step_two_complete ?orchestrator_service)
        )
      )
    :effect (context_step_two_complete ?orchestrator_service)
  )
  (:action finalize_context
    :parameters (?orchestrator_service - orchestrator_service)
    :precondition
      (and
        (context_step_two_complete ?orchestrator_service)
        (not
          (orchestrator_committed ?orchestrator_service)
        )
      )
    :effect
      (and
        (orchestrator_committed ?orchestrator_service)
        (ready_for_activation ?orchestrator_service)
      )
  )
  (:action activate_source_endpoint
    :parameters (?source_endpoint - source_endpoint ?external_storage_resource - storage_resource)
    :precondition
      (and
        (source_endpoint_ready ?source_endpoint)
        (source_endpoint_prepared ?source_endpoint)
        (storage_resource_reserved ?external_storage_resource)
        (storage_payload_attached ?external_storage_resource)
        (not
          (ready_for_activation ?source_endpoint)
        )
      )
    :effect (ready_for_activation ?source_endpoint)
  )
  (:action activate_destination_endpoint
    :parameters (?destination_endpoint - destination_endpoint ?external_storage_resource - storage_resource)
    :precondition
      (and
        (destination_endpoint_ready ?destination_endpoint)
        (destination_endpoint_prepared ?destination_endpoint)
        (storage_resource_reserved ?external_storage_resource)
        (storage_payload_attached ?external_storage_resource)
        (not
          (ready_for_activation ?destination_endpoint)
        )
      )
    :effect (ready_for_activation ?destination_endpoint)
  )
  (:action consume_operation_ticket_for_entity
    :parameters (?integration_entity - integration_entity ?operation_ticket - operation_ticket ?file_descriptor - file_descriptor)
    :precondition
      (and
        (ready_for_activation ?integration_entity)
        (entity_has_file_descriptor ?integration_entity ?file_descriptor)
        (operation_ticket_available ?operation_ticket)
        (not
          (operation_authorized ?integration_entity)
        )
      )
    :effect
      (and
        (operation_authorized ?integration_entity)
        (entity_has_operation_ticket ?integration_entity ?operation_ticket)
        (not
          (operation_ticket_available ?operation_ticket)
        )
      )
  )
  (:action finalize_source_activation
    :parameters (?source_endpoint - source_endpoint ?credential - credential ?operation_ticket - operation_ticket)
    :precondition
      (and
        (operation_authorized ?source_endpoint)
        (entity_has_credential ?source_endpoint ?credential)
        (entity_has_operation_ticket ?source_endpoint ?operation_ticket)
        (not
          (entity_integrated ?source_endpoint)
        )
      )
    :effect
      (and
        (entity_integrated ?source_endpoint)
        (credential_available ?credential)
        (operation_ticket_available ?operation_ticket)
      )
  )
  (:action finalize_destination_activation
    :parameters (?destination_endpoint - destination_endpoint ?credential - credential ?operation_ticket - operation_ticket)
    :precondition
      (and
        (operation_authorized ?destination_endpoint)
        (entity_has_credential ?destination_endpoint ?credential)
        (entity_has_operation_ticket ?destination_endpoint ?operation_ticket)
        (not
          (entity_integrated ?destination_endpoint)
        )
      )
    :effect
      (and
        (entity_integrated ?destination_endpoint)
        (credential_available ?credential)
        (operation_ticket_available ?operation_ticket)
      )
  )
  (:action finalize_orchestrator_activation_with_ticket
    :parameters (?orchestrator_service - orchestrator_service ?credential - credential ?operation_ticket - operation_ticket)
    :precondition
      (and
        (operation_authorized ?orchestrator_service)
        (entity_has_credential ?orchestrator_service ?credential)
        (entity_has_operation_ticket ?orchestrator_service ?operation_ticket)
        (not
          (entity_integrated ?orchestrator_service)
        )
      )
    :effect
      (and
        (entity_integrated ?orchestrator_service)
        (credential_available ?credential)
        (operation_ticket_available ?operation_ticket)
      )
  )
)

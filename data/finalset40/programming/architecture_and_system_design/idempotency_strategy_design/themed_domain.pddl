(define (domain idempotency_strategy_design)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_supertype - object session_supertype - object artifact_supertype - object operation_supertype - object operation_instance - operation_supertype worker_capacity_slot - resource_supertype operation_payload - resource_supertype resource_endpoint - resource_supertype retry_policy - resource_supertype routing_tag - resource_supertype audit_entry - resource_supertype primary_result - resource_supertype consensus_signal - resource_supertype claim_ticket - session_supertype deduplication_key - session_supertype replica_result - session_supertype primary_session_token - artifact_supertype replica_session_token - artifact_supertype commit_artifact - artifact_supertype initiator_group - operation_instance handler_group - operation_instance primary_participant - initiator_group replica_participant - initiator_group idempotency_controller - handler_group)
  (:predicates
    (instance_registered ?operation - operation_instance)
    (entity_prepared ?operation - operation_instance)
    (instance_slot_reserved ?operation - operation_instance)
    (instance_finalized ?operation - operation_instance)
    (instance_commit_applied ?operation - operation_instance)
    (ready_for_finalization ?operation - operation_instance)
    (worker_slot_available ?worker_slot - worker_capacity_slot)
    (instance_assigned_worker_slot ?operation - operation_instance ?worker_slot - worker_capacity_slot)
    (payload_available ?payload - operation_payload)
    (instance_payload_bound ?operation - operation_instance ?payload - operation_payload)
    (resource_endpoint_available ?resource_endpoint - resource_endpoint)
    (instance_assigned_endpoint ?operation - operation_instance ?resource_endpoint - resource_endpoint)
    (claim_ticket_available ?claim_ticket - claim_ticket)
    (primary_has_claim_ticket ?primary_participant - primary_participant ?claim_ticket - claim_ticket)
    (replica_has_claim_ticket ?replica_participant - replica_participant ?claim_ticket - claim_ticket)
    (participant_primary_session_assigned ?primary_participant - primary_participant ?primary_session - primary_session_token)
    (primary_session_ready ?primary_session - primary_session_token)
    (primary_session_confirmed ?primary_session - primary_session_token)
    (primary_ready_for_commit ?primary_participant - primary_participant)
    (participant_replica_session_assigned ?replica_participant - replica_participant ?replica_session - replica_session_token)
    (replica_session_ready ?replica_session - replica_session_token)
    (replica_session_confirmed ?replica_session - replica_session_token)
    (replica_ready_for_commit ?replica_participant - replica_participant)
    (commit_artifact_available ?commit_artifact - commit_artifact)
    (commit_artifact_created ?commit_artifact - commit_artifact)
    (commit_artifact_bound_primary_session ?commit_artifact - commit_artifact ?primary_session - primary_session_token)
    (commit_artifact_bound_replica_session ?commit_artifact - commit_artifact ?replica_session - replica_session_token)
    (commit_artifact_primary_confirmed ?commit_artifact - commit_artifact)
    (commit_artifact_replica_confirmed ?commit_artifact - commit_artifact)
    (commit_artifact_validated ?commit_artifact - commit_artifact)
    (controller_bound_primary_participant ?controller - idempotency_controller ?primary_participant - primary_participant)
    (controller_bound_replica_participant ?controller - idempotency_controller ?replica_participant - replica_participant)
    (controller_bound_commit_artifact ?controller - idempotency_controller ?commit_artifact - commit_artifact)
    (deduplication_key_available ?dedup_key - deduplication_key)
    (controller_dedup_key_assigned ?controller - idempotency_controller ?dedup_key - deduplication_key)
    (deduplication_key_consumed ?dedup_key - deduplication_key)
    (dedup_key_bound_to_artifact ?dedup_key - deduplication_key ?commit_artifact - commit_artifact)
    (controller_prepared ?controller - idempotency_controller)
    (controller_ready_for_activation ?controller - idempotency_controller)
    (controller_activation_in_progress ?controller - idempotency_controller)
    (controller_retry_policy_applied ?controller - idempotency_controller)
    (controller_enrichment_applied ?controller - idempotency_controller)
    (controller_policy_bound ?controller - idempotency_controller)
    (controller_activated ?controller - idempotency_controller)
    (replica_result_available ?replica_result - replica_result)
    (controller_has_replica_result ?controller - idempotency_controller ?replica_result - replica_result)
    (controller_replica_result_registered ?controller - idempotency_controller)
    (controller_replica_handler_attached ?controller - idempotency_controller)
    (controller_replica_handler_completed ?controller - idempotency_controller)
    (retry_policy_available ?retry_policy - retry_policy)
    (controller_has_retry_policy ?controller - idempotency_controller ?retry_policy - retry_policy)
    (routing_tag_available ?routing_tag - routing_tag)
    (controller_bound_routing_tag ?controller - idempotency_controller ?routing_tag - routing_tag)
    (primary_result_available ?primary_result - primary_result)
    (controller_has_primary_result ?controller - idempotency_controller ?primary_result - primary_result)
    (consensus_signal_available ?consensus_signal - consensus_signal)
    (controller_has_consensus_signal ?controller - idempotency_controller ?consensus_signal - consensus_signal)
    (audit_entry_available ?audit_entry - audit_entry)
    (has_audit_entry ?operation - operation_instance ?audit_entry - audit_entry)
    (primary_ready ?primary_participant - primary_participant)
    (replica_ready ?replica_participant - replica_participant)
    (controller_finalized ?controller - idempotency_controller)
  )
  (:action register_operation_instance
    :parameters (?operation - operation_instance)
    :precondition
      (and
        (not
          (instance_registered ?operation)
        )
        (not
          (instance_finalized ?operation)
        )
      )
    :effect (instance_registered ?operation)
  )
  (:action assign_worker_slot
    :parameters (?operation - operation_instance ?worker_slot - worker_capacity_slot)
    :precondition
      (and
        (instance_registered ?operation)
        (not
          (instance_slot_reserved ?operation)
        )
        (worker_slot_available ?worker_slot)
      )
    :effect
      (and
        (instance_slot_reserved ?operation)
        (instance_assigned_worker_slot ?operation ?worker_slot)
        (not
          (worker_slot_available ?worker_slot)
        )
      )
  )
  (:action attach_payload_to_instance
    :parameters (?operation - operation_instance ?payload - operation_payload)
    :precondition
      (and
        (instance_registered ?operation)
        (instance_slot_reserved ?operation)
        (payload_available ?payload)
      )
    :effect
      (and
        (instance_payload_bound ?operation ?payload)
        (not
          (payload_available ?payload)
        )
      )
  )
  (:action confirm_instance_prepared
    :parameters (?operation - operation_instance ?payload - operation_payload)
    :precondition
      (and
        (instance_registered ?operation)
        (instance_slot_reserved ?operation)
        (instance_payload_bound ?operation ?payload)
        (not
          (entity_prepared ?operation)
        )
      )
    :effect (entity_prepared ?operation)
  )
  (:action release_payload_from_instance
    :parameters (?operation - operation_instance ?payload - operation_payload)
    :precondition
      (and
        (instance_payload_bound ?operation ?payload)
      )
    :effect
      (and
        (payload_available ?payload)
        (not
          (instance_payload_bound ?operation ?payload)
        )
      )
  )
  (:action assign_resource_endpoint_to_instance
    :parameters (?operation - operation_instance ?resource_endpoint - resource_endpoint)
    :precondition
      (and
        (entity_prepared ?operation)
        (resource_endpoint_available ?resource_endpoint)
      )
    :effect
      (and
        (instance_assigned_endpoint ?operation ?resource_endpoint)
        (not
          (resource_endpoint_available ?resource_endpoint)
        )
      )
  )
  (:action release_resource_endpoint_from_instance
    :parameters (?operation - operation_instance ?resource_endpoint - resource_endpoint)
    :precondition
      (and
        (instance_assigned_endpoint ?operation ?resource_endpoint)
      )
    :effect
      (and
        (resource_endpoint_available ?resource_endpoint)
        (not
          (instance_assigned_endpoint ?operation ?resource_endpoint)
        )
      )
  )
  (:action bind_primary_result_to_controller
    :parameters (?controller - idempotency_controller ?primary_result - primary_result)
    :precondition
      (and
        (entity_prepared ?controller)
        (primary_result_available ?primary_result)
      )
    :effect
      (and
        (controller_has_primary_result ?controller ?primary_result)
        (not
          (primary_result_available ?primary_result)
        )
      )
  )
  (:action unbind_primary_result_from_controller
    :parameters (?controller - idempotency_controller ?primary_result - primary_result)
    :precondition
      (and
        (controller_has_primary_result ?controller ?primary_result)
      )
    :effect
      (and
        (primary_result_available ?primary_result)
        (not
          (controller_has_primary_result ?controller ?primary_result)
        )
      )
  )
  (:action bind_consensus_signal_to_controller
    :parameters (?controller - idempotency_controller ?consensus_signal - consensus_signal)
    :precondition
      (and
        (entity_prepared ?controller)
        (consensus_signal_available ?consensus_signal)
      )
    :effect
      (and
        (controller_has_consensus_signal ?controller ?consensus_signal)
        (not
          (consensus_signal_available ?consensus_signal)
        )
      )
  )
  (:action unbind_consensus_signal_from_controller
    :parameters (?controller - idempotency_controller ?consensus_signal - consensus_signal)
    :precondition
      (and
        (controller_has_consensus_signal ?controller ?consensus_signal)
      )
    :effect
      (and
        (consensus_signal_available ?consensus_signal)
        (not
          (controller_has_consensus_signal ?controller ?consensus_signal)
        )
      )
  )
  (:action prepare_primary_session
    :parameters (?primary_participant - primary_participant ?primary_session - primary_session_token ?payload - operation_payload)
    :precondition
      (and
        (entity_prepared ?primary_participant)
        (instance_payload_bound ?primary_participant ?payload)
        (participant_primary_session_assigned ?primary_participant ?primary_session)
        (not
          (primary_session_ready ?primary_session)
        )
        (not
          (primary_session_confirmed ?primary_session)
        )
      )
    :effect (primary_session_ready ?primary_session)
  )
  (:action acknowledge_primary_endpoint
    :parameters (?primary_participant - primary_participant ?primary_session - primary_session_token ?resource_endpoint - resource_endpoint)
    :precondition
      (and
        (entity_prepared ?primary_participant)
        (instance_assigned_endpoint ?primary_participant ?resource_endpoint)
        (participant_primary_session_assigned ?primary_participant ?primary_session)
        (primary_session_ready ?primary_session)
        (not
          (primary_ready ?primary_participant)
        )
      )
    :effect
      (and
        (primary_ready ?primary_participant)
        (primary_ready_for_commit ?primary_participant)
      )
  )
  (:action assign_primary_claim_ticket
    :parameters (?primary_participant - primary_participant ?primary_session - primary_session_token ?claim_ticket - claim_ticket)
    :precondition
      (and
        (entity_prepared ?primary_participant)
        (participant_primary_session_assigned ?primary_participant ?primary_session)
        (claim_ticket_available ?claim_ticket)
        (not
          (primary_ready ?primary_participant)
        )
      )
    :effect
      (and
        (primary_session_confirmed ?primary_session)
        (primary_ready ?primary_participant)
        (primary_has_claim_ticket ?primary_participant ?claim_ticket)
        (not
          (claim_ticket_available ?claim_ticket)
        )
      )
  )
  (:action process_primary_with_claim_ticket
    :parameters (?primary_participant - primary_participant ?primary_session - primary_session_token ?payload - operation_payload ?claim_ticket - claim_ticket)
    :precondition
      (and
        (entity_prepared ?primary_participant)
        (instance_payload_bound ?primary_participant ?payload)
        (participant_primary_session_assigned ?primary_participant ?primary_session)
        (primary_session_confirmed ?primary_session)
        (primary_has_claim_ticket ?primary_participant ?claim_ticket)
        (not
          (primary_ready_for_commit ?primary_participant)
        )
      )
    :effect
      (and
        (primary_session_ready ?primary_session)
        (primary_ready_for_commit ?primary_participant)
        (claim_ticket_available ?claim_ticket)
        (not
          (primary_has_claim_ticket ?primary_participant ?claim_ticket)
        )
      )
  )
  (:action prepare_replica_session
    :parameters (?replica_participant - replica_participant ?replica_session - replica_session_token ?payload - operation_payload)
    :precondition
      (and
        (entity_prepared ?replica_participant)
        (instance_payload_bound ?replica_participant ?payload)
        (participant_replica_session_assigned ?replica_participant ?replica_session)
        (not
          (replica_session_ready ?replica_session)
        )
        (not
          (replica_session_confirmed ?replica_session)
        )
      )
    :effect (replica_session_ready ?replica_session)
  )
  (:action acknowledge_replica_endpoint
    :parameters (?replica_participant - replica_participant ?replica_session - replica_session_token ?resource_endpoint - resource_endpoint)
    :precondition
      (and
        (entity_prepared ?replica_participant)
        (instance_assigned_endpoint ?replica_participant ?resource_endpoint)
        (participant_replica_session_assigned ?replica_participant ?replica_session)
        (replica_session_ready ?replica_session)
        (not
          (replica_ready ?replica_participant)
        )
      )
    :effect
      (and
        (replica_ready ?replica_participant)
        (replica_ready_for_commit ?replica_participant)
      )
  )
  (:action assign_replica_claim_ticket
    :parameters (?replica_participant - replica_participant ?replica_session - replica_session_token ?claim_ticket - claim_ticket)
    :precondition
      (and
        (entity_prepared ?replica_participant)
        (participant_replica_session_assigned ?replica_participant ?replica_session)
        (claim_ticket_available ?claim_ticket)
        (not
          (replica_ready ?replica_participant)
        )
      )
    :effect
      (and
        (replica_session_confirmed ?replica_session)
        (replica_ready ?replica_participant)
        (replica_has_claim_ticket ?replica_participant ?claim_ticket)
        (not
          (claim_ticket_available ?claim_ticket)
        )
      )
  )
  (:action process_replica_with_claim_ticket
    :parameters (?replica_participant - replica_participant ?replica_session - replica_session_token ?payload - operation_payload ?claim_ticket - claim_ticket)
    :precondition
      (and
        (entity_prepared ?replica_participant)
        (instance_payload_bound ?replica_participant ?payload)
        (participant_replica_session_assigned ?replica_participant ?replica_session)
        (replica_session_confirmed ?replica_session)
        (replica_has_claim_ticket ?replica_participant ?claim_ticket)
        (not
          (replica_ready_for_commit ?replica_participant)
        )
      )
    :effect
      (and
        (replica_session_ready ?replica_session)
        (replica_ready_for_commit ?replica_participant)
        (claim_ticket_available ?claim_ticket)
        (not
          (replica_has_claim_ticket ?replica_participant ?claim_ticket)
        )
      )
  )
  (:action assemble_commit_bundle_v1
    :parameters (?primary_participant - primary_participant ?replica_participant - replica_participant ?primary_session - primary_session_token ?replica_session - replica_session_token ?commit_artifact - commit_artifact)
    :precondition
      (and
        (primary_ready ?primary_participant)
        (replica_ready ?replica_participant)
        (participant_primary_session_assigned ?primary_participant ?primary_session)
        (participant_replica_session_assigned ?replica_participant ?replica_session)
        (primary_session_ready ?primary_session)
        (replica_session_ready ?replica_session)
        (primary_ready_for_commit ?primary_participant)
        (replica_ready_for_commit ?replica_participant)
        (commit_artifact_available ?commit_artifact)
      )
    :effect
      (and
        (commit_artifact_created ?commit_artifact)
        (commit_artifact_bound_primary_session ?commit_artifact ?primary_session)
        (commit_artifact_bound_replica_session ?commit_artifact ?replica_session)
        (not
          (commit_artifact_available ?commit_artifact)
        )
      )
  )
  (:action assemble_commit_bundle_v2
    :parameters (?primary_participant - primary_participant ?replica_participant - replica_participant ?primary_session - primary_session_token ?replica_session - replica_session_token ?commit_artifact - commit_artifact)
    :precondition
      (and
        (primary_ready ?primary_participant)
        (replica_ready ?replica_participant)
        (participant_primary_session_assigned ?primary_participant ?primary_session)
        (participant_replica_session_assigned ?replica_participant ?replica_session)
        (primary_session_confirmed ?primary_session)
        (replica_session_ready ?replica_session)
        (not
          (primary_ready_for_commit ?primary_participant)
        )
        (replica_ready_for_commit ?replica_participant)
        (commit_artifact_available ?commit_artifact)
      )
    :effect
      (and
        (commit_artifact_created ?commit_artifact)
        (commit_artifact_bound_primary_session ?commit_artifact ?primary_session)
        (commit_artifact_bound_replica_session ?commit_artifact ?replica_session)
        (commit_artifact_primary_confirmed ?commit_artifact)
        (not
          (commit_artifact_available ?commit_artifact)
        )
      )
  )
  (:action assemble_commit_bundle_v3
    :parameters (?primary_participant - primary_participant ?replica_participant - replica_participant ?primary_session - primary_session_token ?replica_session - replica_session_token ?commit_artifact - commit_artifact)
    :precondition
      (and
        (primary_ready ?primary_participant)
        (replica_ready ?replica_participant)
        (participant_primary_session_assigned ?primary_participant ?primary_session)
        (participant_replica_session_assigned ?replica_participant ?replica_session)
        (primary_session_ready ?primary_session)
        (replica_session_confirmed ?replica_session)
        (primary_ready_for_commit ?primary_participant)
        (not
          (replica_ready_for_commit ?replica_participant)
        )
        (commit_artifact_available ?commit_artifact)
      )
    :effect
      (and
        (commit_artifact_created ?commit_artifact)
        (commit_artifact_bound_primary_session ?commit_artifact ?primary_session)
        (commit_artifact_bound_replica_session ?commit_artifact ?replica_session)
        (commit_artifact_replica_confirmed ?commit_artifact)
        (not
          (commit_artifact_available ?commit_artifact)
        )
      )
  )
  (:action assemble_commit_bundle_v4
    :parameters (?primary_participant - primary_participant ?replica_participant - replica_participant ?primary_session - primary_session_token ?replica_session - replica_session_token ?commit_artifact - commit_artifact)
    :precondition
      (and
        (primary_ready ?primary_participant)
        (replica_ready ?replica_participant)
        (participant_primary_session_assigned ?primary_participant ?primary_session)
        (participant_replica_session_assigned ?replica_participant ?replica_session)
        (primary_session_confirmed ?primary_session)
        (replica_session_confirmed ?replica_session)
        (not
          (primary_ready_for_commit ?primary_participant)
        )
        (not
          (replica_ready_for_commit ?replica_participant)
        )
        (commit_artifact_available ?commit_artifact)
      )
    :effect
      (and
        (commit_artifact_created ?commit_artifact)
        (commit_artifact_bound_primary_session ?commit_artifact ?primary_session)
        (commit_artifact_bound_replica_session ?commit_artifact ?replica_session)
        (commit_artifact_primary_confirmed ?commit_artifact)
        (commit_artifact_replica_confirmed ?commit_artifact)
        (not
          (commit_artifact_available ?commit_artifact)
        )
      )
  )
  (:action validate_and_mark_commit_artifact
    :parameters (?commit_artifact - commit_artifact ?primary_participant - primary_participant ?payload - operation_payload)
    :precondition
      (and
        (commit_artifact_created ?commit_artifact)
        (primary_ready ?primary_participant)
        (instance_payload_bound ?primary_participant ?payload)
        (not
          (commit_artifact_validated ?commit_artifact)
        )
      )
    :effect (commit_artifact_validated ?commit_artifact)
  )
  (:action bind_dedup_key_to_artifact
    :parameters (?controller - idempotency_controller ?dedup_key - deduplication_key ?commit_artifact - commit_artifact)
    :precondition
      (and
        (entity_prepared ?controller)
        (controller_bound_commit_artifact ?controller ?commit_artifact)
        (controller_dedup_key_assigned ?controller ?dedup_key)
        (deduplication_key_available ?dedup_key)
        (commit_artifact_created ?commit_artifact)
        (commit_artifact_validated ?commit_artifact)
        (not
          (deduplication_key_consumed ?dedup_key)
        )
      )
    :effect
      (and
        (deduplication_key_consumed ?dedup_key)
        (dedup_key_bound_to_artifact ?dedup_key ?commit_artifact)
        (not
          (deduplication_key_available ?dedup_key)
        )
      )
  )
  (:action prepare_controller_post_dedup_validation
    :parameters (?controller - idempotency_controller ?dedup_key - deduplication_key ?commit_artifact - commit_artifact ?payload - operation_payload)
    :precondition
      (and
        (entity_prepared ?controller)
        (controller_dedup_key_assigned ?controller ?dedup_key)
        (deduplication_key_consumed ?dedup_key)
        (dedup_key_bound_to_artifact ?dedup_key ?commit_artifact)
        (instance_payload_bound ?controller ?payload)
        (not
          (commit_artifact_primary_confirmed ?commit_artifact)
        )
        (not
          (controller_prepared ?controller)
        )
      )
    :effect (controller_prepared ?controller)
  )
  (:action bind_retry_policy_to_controller
    :parameters (?controller - idempotency_controller ?retry_policy - retry_policy)
    :precondition
      (and
        (entity_prepared ?controller)
        (retry_policy_available ?retry_policy)
        (not
          (controller_retry_policy_applied ?controller)
        )
      )
    :effect
      (and
        (controller_retry_policy_applied ?controller)
        (controller_has_retry_policy ?controller ?retry_policy)
        (not
          (retry_policy_available ?retry_policy)
        )
      )
  )
  (:action enrich_controller_with_bindings
    :parameters (?controller - idempotency_controller ?dedup_key - deduplication_key ?commit_artifact - commit_artifact ?payload - operation_payload ?retry_policy - retry_policy)
    :precondition
      (and
        (entity_prepared ?controller)
        (controller_dedup_key_assigned ?controller ?dedup_key)
        (deduplication_key_consumed ?dedup_key)
        (dedup_key_bound_to_artifact ?dedup_key ?commit_artifact)
        (instance_payload_bound ?controller ?payload)
        (commit_artifact_primary_confirmed ?commit_artifact)
        (controller_retry_policy_applied ?controller)
        (controller_has_retry_policy ?controller ?retry_policy)
        (not
          (controller_prepared ?controller)
        )
      )
    :effect
      (and
        (controller_prepared ?controller)
        (controller_enrichment_applied ?controller)
      )
  )
  (:action activate_controller_with_primary_result
    :parameters (?controller - idempotency_controller ?primary_result - primary_result ?resource_endpoint - resource_endpoint ?dedup_key - deduplication_key ?commit_artifact - commit_artifact)
    :precondition
      (and
        (controller_prepared ?controller)
        (controller_has_primary_result ?controller ?primary_result)
        (instance_assigned_endpoint ?controller ?resource_endpoint)
        (controller_dedup_key_assigned ?controller ?dedup_key)
        (dedup_key_bound_to_artifact ?dedup_key ?commit_artifact)
        (not
          (commit_artifact_replica_confirmed ?commit_artifact)
        )
        (not
          (controller_ready_for_activation ?controller)
        )
      )
    :effect (controller_ready_for_activation ?controller)
  )
  (:action activate_controller_with_primary_result_variant
    :parameters (?controller - idempotency_controller ?primary_result - primary_result ?resource_endpoint - resource_endpoint ?dedup_key - deduplication_key ?commit_artifact - commit_artifact)
    :precondition
      (and
        (controller_prepared ?controller)
        (controller_has_primary_result ?controller ?primary_result)
        (instance_assigned_endpoint ?controller ?resource_endpoint)
        (controller_dedup_key_assigned ?controller ?dedup_key)
        (dedup_key_bound_to_artifact ?dedup_key ?commit_artifact)
        (commit_artifact_replica_confirmed ?commit_artifact)
        (not
          (controller_ready_for_activation ?controller)
        )
      )
    :effect (controller_ready_for_activation ?controller)
  )
  (:action acknowledge_controller_consensus_step
    :parameters (?controller - idempotency_controller ?consensus_signal - consensus_signal ?dedup_key - deduplication_key ?commit_artifact - commit_artifact)
    :precondition
      (and
        (controller_ready_for_activation ?controller)
        (controller_has_consensus_signal ?controller ?consensus_signal)
        (controller_dedup_key_assigned ?controller ?dedup_key)
        (dedup_key_bound_to_artifact ?dedup_key ?commit_artifact)
        (not
          (commit_artifact_primary_confirmed ?commit_artifact)
        )
        (not
          (commit_artifact_replica_confirmed ?commit_artifact)
        )
        (not
          (controller_activation_in_progress ?controller)
        )
      )
    :effect (controller_activation_in_progress ?controller)
  )
  (:action acknowledge_controller_consensus_and_stage
    :parameters (?controller - idempotency_controller ?consensus_signal - consensus_signal ?dedup_key - deduplication_key ?commit_artifact - commit_artifact)
    :precondition
      (and
        (controller_ready_for_activation ?controller)
        (controller_has_consensus_signal ?controller ?consensus_signal)
        (controller_dedup_key_assigned ?controller ?dedup_key)
        (dedup_key_bound_to_artifact ?dedup_key ?commit_artifact)
        (commit_artifact_primary_confirmed ?commit_artifact)
        (not
          (commit_artifact_replica_confirmed ?commit_artifact)
        )
        (not
          (controller_activation_in_progress ?controller)
        )
      )
    :effect
      (and
        (controller_activation_in_progress ?controller)
        (controller_policy_bound ?controller)
      )
  )
  (:action acknowledge_controller_consensus_alt
    :parameters (?controller - idempotency_controller ?consensus_signal - consensus_signal ?dedup_key - deduplication_key ?commit_artifact - commit_artifact)
    :precondition
      (and
        (controller_ready_for_activation ?controller)
        (controller_has_consensus_signal ?controller ?consensus_signal)
        (controller_dedup_key_assigned ?controller ?dedup_key)
        (dedup_key_bound_to_artifact ?dedup_key ?commit_artifact)
        (not
          (commit_artifact_primary_confirmed ?commit_artifact)
        )
        (commit_artifact_replica_confirmed ?commit_artifact)
        (not
          (controller_activation_in_progress ?controller)
        )
      )
    :effect
      (and
        (controller_activation_in_progress ?controller)
        (controller_policy_bound ?controller)
      )
  )
  (:action acknowledge_controller_consensus_full
    :parameters (?controller - idempotency_controller ?consensus_signal - consensus_signal ?dedup_key - deduplication_key ?commit_artifact - commit_artifact)
    :precondition
      (and
        (controller_ready_for_activation ?controller)
        (controller_has_consensus_signal ?controller ?consensus_signal)
        (controller_dedup_key_assigned ?controller ?dedup_key)
        (dedup_key_bound_to_artifact ?dedup_key ?commit_artifact)
        (commit_artifact_primary_confirmed ?commit_artifact)
        (commit_artifact_replica_confirmed ?commit_artifact)
        (not
          (controller_activation_in_progress ?controller)
        )
      )
    :effect
      (and
        (controller_activation_in_progress ?controller)
        (controller_policy_bound ?controller)
      )
  )
  (:action authorize_controller_activation
    :parameters (?controller - idempotency_controller)
    :precondition
      (and
        (controller_activation_in_progress ?controller)
        (not
          (controller_policy_bound ?controller)
        )
        (not
          (controller_finalized ?controller)
        )
      )
    :effect
      (and
        (controller_finalized ?controller)
        (instance_commit_applied ?controller)
      )
  )
  (:action bind_routing_tag_to_controller
    :parameters (?controller - idempotency_controller ?routing_tag - routing_tag)
    :precondition
      (and
        (controller_activation_in_progress ?controller)
        (controller_policy_bound ?controller)
        (routing_tag_available ?routing_tag)
      )
    :effect
      (and
        (controller_bound_routing_tag ?controller ?routing_tag)
        (not
          (routing_tag_available ?routing_tag)
        )
      )
  )
  (:action activate_controller_with_participant_signals
    :parameters (?controller - idempotency_controller ?primary_participant - primary_participant ?replica_participant - replica_participant ?payload - operation_payload ?routing_tag - routing_tag)
    :precondition
      (and
        (controller_activation_in_progress ?controller)
        (controller_policy_bound ?controller)
        (controller_bound_routing_tag ?controller ?routing_tag)
        (controller_bound_primary_participant ?controller ?primary_participant)
        (controller_bound_replica_participant ?controller ?replica_participant)
        (primary_ready_for_commit ?primary_participant)
        (replica_ready_for_commit ?replica_participant)
        (instance_payload_bound ?controller ?payload)
        (not
          (controller_activated ?controller)
        )
      )
    :effect (controller_activated ?controller)
  )
  (:action finalize_controller_activation
    :parameters (?controller - idempotency_controller)
    :precondition
      (and
        (controller_activation_in_progress ?controller)
        (controller_activated ?controller)
        (not
          (controller_finalized ?controller)
        )
      )
    :effect
      (and
        (controller_finalized ?controller)
        (instance_commit_applied ?controller)
      )
  )
  (:action register_replica_result_with_controller
    :parameters (?controller - idempotency_controller ?replica_result - replica_result ?payload - operation_payload)
    :precondition
      (and
        (entity_prepared ?controller)
        (instance_payload_bound ?controller ?payload)
        (replica_result_available ?replica_result)
        (controller_has_replica_result ?controller ?replica_result)
        (not
          (controller_replica_result_registered ?controller)
        )
      )
    :effect
      (and
        (controller_replica_result_registered ?controller)
        (not
          (replica_result_available ?replica_result)
        )
      )
  )
  (:action apply_replica_handler
    :parameters (?controller - idempotency_controller ?resource_endpoint - resource_endpoint)
    :precondition
      (and
        (controller_replica_result_registered ?controller)
        (instance_assigned_endpoint ?controller ?resource_endpoint)
        (not
          (controller_replica_handler_attached ?controller)
        )
      )
    :effect (controller_replica_handler_attached ?controller)
  )
  (:action acknowledge_replica_handler_with_consensus
    :parameters (?controller - idempotency_controller ?consensus_signal - consensus_signal)
    :precondition
      (and
        (controller_replica_handler_attached ?controller)
        (controller_has_consensus_signal ?controller ?consensus_signal)
        (not
          (controller_replica_handler_completed ?controller)
        )
      )
    :effect (controller_replica_handler_completed ?controller)
  )
  (:action finalize_replica_response_flow
    :parameters (?controller - idempotency_controller)
    :precondition
      (and
        (controller_replica_handler_completed ?controller)
        (not
          (controller_finalized ?controller)
        )
      )
    :effect
      (and
        (controller_finalized ?controller)
        (instance_commit_applied ?controller)
      )
  )
  (:action confirm_primary_commit
    :parameters (?primary_participant - primary_participant ?commit_artifact - commit_artifact)
    :precondition
      (and
        (primary_ready ?primary_participant)
        (primary_ready_for_commit ?primary_participant)
        (commit_artifact_created ?commit_artifact)
        (commit_artifact_validated ?commit_artifact)
        (not
          (instance_commit_applied ?primary_participant)
        )
      )
    :effect (instance_commit_applied ?primary_participant)
  )
  (:action confirm_replica_commit
    :parameters (?replica_participant - replica_participant ?commit_artifact - commit_artifact)
    :precondition
      (and
        (replica_ready ?replica_participant)
        (replica_ready_for_commit ?replica_participant)
        (commit_artifact_created ?commit_artifact)
        (commit_artifact_validated ?commit_artifact)
        (not
          (instance_commit_applied ?replica_participant)
        )
      )
    :effect (instance_commit_applied ?replica_participant)
  )
  (:action record_audit_and_mark_instance
    :parameters (?operation - operation_instance ?audit_entry - audit_entry ?payload - operation_payload)
    :precondition
      (and
        (instance_commit_applied ?operation)
        (instance_payload_bound ?operation ?payload)
        (audit_entry_available ?audit_entry)
        (not
          (ready_for_finalization ?operation)
        )
      )
    :effect
      (and
        (ready_for_finalization ?operation)
        (has_audit_entry ?operation ?audit_entry)
        (not
          (audit_entry_available ?audit_entry)
        )
      )
  )
  (:action release_primary_slot
    :parameters (?primary_participant - primary_participant ?worker_slot - worker_capacity_slot ?audit_entry - audit_entry)
    :precondition
      (and
        (ready_for_finalization ?primary_participant)
        (instance_assigned_worker_slot ?primary_participant ?worker_slot)
        (has_audit_entry ?primary_participant ?audit_entry)
        (not
          (instance_finalized ?primary_participant)
        )
      )
    :effect
      (and
        (instance_finalized ?primary_participant)
        (worker_slot_available ?worker_slot)
        (audit_entry_available ?audit_entry)
      )
  )
  (:action release_replica_slot
    :parameters (?replica_participant - replica_participant ?worker_slot - worker_capacity_slot ?audit_entry - audit_entry)
    :precondition
      (and
        (ready_for_finalization ?replica_participant)
        (instance_assigned_worker_slot ?replica_participant ?worker_slot)
        (has_audit_entry ?replica_participant ?audit_entry)
        (not
          (instance_finalized ?replica_participant)
        )
      )
    :effect
      (and
        (instance_finalized ?replica_participant)
        (worker_slot_available ?worker_slot)
        (audit_entry_available ?audit_entry)
      )
  )
  (:action release_controller_slot
    :parameters (?controller - idempotency_controller ?worker_slot - worker_capacity_slot ?audit_entry - audit_entry)
    :precondition
      (and
        (ready_for_finalization ?controller)
        (instance_assigned_worker_slot ?controller ?worker_slot)
        (has_audit_entry ?controller ?audit_entry)
        (not
          (instance_finalized ?controller)
        )
      )
    :effect
      (and
        (instance_finalized ?controller)
        (worker_slot_available ?worker_slot)
        (audit_entry_available ?audit_entry)
      )
  )
)

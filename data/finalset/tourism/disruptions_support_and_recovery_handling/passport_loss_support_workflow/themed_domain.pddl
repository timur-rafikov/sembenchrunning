(define (domain passport_loss_support_workflow)
  (:requirements :strips :typing :negative-preconditions)
  (:types component_group - object resource_category - object context_category - object passport_loss_support_root - object workflow_component - passport_loss_support_root external_provider_resource - component_group contact_channel - component_group local_support_point - component_group policy_item - component_group compensation_packet_type - component_group compensation_item - component_group operational_task - component_group escalation_token - component_group evidence_document - resource_category verification_artifact - resource_category approval_token - resource_category location_context - context_category service_context - context_category repair_proposal - context_category itinerary_component_group - workflow_component operator_component_group - workflow_component itinerary_segment - itinerary_component_group service_booking - itinerary_component_group support_operator - operator_component_group)
  (:predicates
    (component_intake_open ?workflow_component - workflow_component)
    (component_verified ?workflow_component - workflow_component)
    (component_resource_allocation ?workflow_component - workflow_component)
    (component_closed ?workflow_component - workflow_component)
    (component_tasks_completed ?workflow_component - workflow_component)
    (compensation_initiated ?workflow_component - workflow_component)
    (provider_resource_available ?external_provider_resource - external_provider_resource)
    (component_provider_assignment ?workflow_component - workflow_component ?external_provider_resource - external_provider_resource)
    (contact_channel_available ?contact_channel - contact_channel)
    (component_contact_channel_assignment ?workflow_component - workflow_component ?contact_channel - contact_channel)
    (local_support_point_available ?local_support_point - local_support_point)
    (component_local_support_assignment ?workflow_component - workflow_component ?local_support_point - local_support_point)
    (evidence_document_available ?evidence_document - evidence_document)
    (itinerary_segment_has_evidence ?itinerary_segment - itinerary_segment ?evidence_document - evidence_document)
    (service_booking_has_evidence ?service_booking - service_booking ?evidence_document - evidence_document)
    (itinerary_segment_location_context ?itinerary_segment - itinerary_segment ?location_context - location_context)
    (location_ready_flag ?location_context - location_context)
    (location_document_ready ?location_context - location_context)
    (itinerary_segment_ready ?itinerary_segment - itinerary_segment)
    (service_booking_context_assignment ?service_booking - service_booking ?service_context - service_context)
    (service_context_ready ?service_context - service_context)
    (service_context_document_ready ?service_context - service_context)
    (service_booking_ready ?service_booking - service_booking)
    (proposal_candidate_available ?repair_proposal - repair_proposal)
    (proposal_committed ?repair_proposal - repair_proposal)
    (proposal_assigned_location ?repair_proposal - repair_proposal ?location_context - location_context)
    (proposal_assigned_service_context ?repair_proposal - repair_proposal ?service_context - service_context)
    (proposal_primary_sourcing ?repair_proposal - repair_proposal)
    (proposal_secondary_sourcing ?repair_proposal - repair_proposal)
    (proposal_execution_ready ?repair_proposal - repair_proposal)
    (operator_assigned_segment ?support_operator - support_operator ?itinerary_segment - itinerary_segment)
    (operator_assigned_booking ?support_operator - support_operator ?service_booking - service_booking)
    (operator_assigned_proposal ?support_operator - support_operator ?repair_proposal - repair_proposal)
    (verification_artifact_available ?verification_artifact - verification_artifact)
    (operator_has_verification_artifact ?support_operator - support_operator ?verification_artifact - verification_artifact)
    (verification_artifact_consumed ?verification_artifact - verification_artifact)
    (verification_artifact_linked_to_proposal ?verification_artifact - verification_artifact ?repair_proposal - repair_proposal)
    (operator_ready_for_provider_coordination ?support_operator - support_operator)
    (operator_provider_coordination_completed ?support_operator - support_operator)
    (operator_prepared_for_finalization ?support_operator - support_operator)
    (operator_policy_engaged ?support_operator - support_operator)
    (operator_policy_confirmed ?support_operator - support_operator)
    (operator_compensation_authorized ?support_operator - support_operator)
    (operator_execution_completed ?support_operator - support_operator)
    (approval_token_available ?approval_token - approval_token)
    (operator_approval_assigned ?support_operator - support_operator ?approval_token - approval_token)
    (operator_approval_acquired ?support_operator - support_operator)
    (operator_local_support_confirmed ?support_operator - support_operator)
    (operator_escalation_applied ?support_operator - support_operator)
    (policy_item_available ?policy_item - policy_item)
    (operator_linked_policy_item ?support_operator - support_operator ?policy_item - policy_item)
    (compensation_packet_type_available ?compensation_packet_type - compensation_packet_type)
    (operator_assigned_compensation_packet ?support_operator - support_operator ?compensation_packet_type - compensation_packet_type)
    (operational_task_available ?operational_task - operational_task)
    (operator_assigned_operational_task ?support_operator - support_operator ?operational_task - operational_task)
    (escalation_token_available ?escalation_token - escalation_token)
    (operator_assigned_escalation_token ?support_operator - support_operator ?escalation_token - escalation_token)
    (compensation_item_available ?compensation_item - compensation_item)
    (component_compensation_item_linked ?workflow_component - workflow_component ?compensation_item - compensation_item)
    (itinerary_segment_triaged ?itinerary_segment - itinerary_segment)
    (service_booking_triaged ?service_booking - service_booking)
    (operator_closure_registered ?support_operator - support_operator)
  )
  (:action create_incident_intake
    :parameters (?workflow_component - workflow_component)
    :precondition
      (and
        (not
          (component_intake_open ?workflow_component)
        )
        (not
          (component_closed ?workflow_component)
        )
      )
    :effect (component_intake_open ?workflow_component)
  )
  (:action assign_provider_resource_to_component
    :parameters (?workflow_component - workflow_component ?external_provider_resource - external_provider_resource)
    :precondition
      (and
        (component_intake_open ?workflow_component)
        (not
          (component_resource_allocation ?workflow_component)
        )
        (provider_resource_available ?external_provider_resource)
      )
    :effect
      (and
        (component_resource_allocation ?workflow_component)
        (component_provider_assignment ?workflow_component ?external_provider_resource)
        (not
          (provider_resource_available ?external_provider_resource)
        )
      )
  )
  (:action assign_contact_channel_to_component
    :parameters (?workflow_component - workflow_component ?contact_channel - contact_channel)
    :precondition
      (and
        (component_intake_open ?workflow_component)
        (component_resource_allocation ?workflow_component)
        (contact_channel_available ?contact_channel)
      )
    :effect
      (and
        (component_contact_channel_assignment ?workflow_component ?contact_channel)
        (not
          (contact_channel_available ?contact_channel)
        )
      )
  )
  (:action mark_component_verified
    :parameters (?workflow_component - workflow_component ?contact_channel - contact_channel)
    :precondition
      (and
        (component_intake_open ?workflow_component)
        (component_resource_allocation ?workflow_component)
        (component_contact_channel_assignment ?workflow_component ?contact_channel)
        (not
          (component_verified ?workflow_component)
        )
      )
    :effect (component_verified ?workflow_component)
  )
  (:action release_contact_channel_from_component
    :parameters (?workflow_component - workflow_component ?contact_channel - contact_channel)
    :precondition
      (and
        (component_contact_channel_assignment ?workflow_component ?contact_channel)
      )
    :effect
      (and
        (contact_channel_available ?contact_channel)
        (not
          (component_contact_channel_assignment ?workflow_component ?contact_channel)
        )
      )
  )
  (:action assign_local_support_point_to_component
    :parameters (?workflow_component - workflow_component ?local_support_point - local_support_point)
    :precondition
      (and
        (component_verified ?workflow_component)
        (local_support_point_available ?local_support_point)
      )
    :effect
      (and
        (component_local_support_assignment ?workflow_component ?local_support_point)
        (not
          (local_support_point_available ?local_support_point)
        )
      )
  )
  (:action release_local_support_point
    :parameters (?workflow_component - workflow_component ?local_support_point - local_support_point)
    :precondition
      (and
        (component_local_support_assignment ?workflow_component ?local_support_point)
      )
    :effect
      (and
        (local_support_point_available ?local_support_point)
        (not
          (component_local_support_assignment ?workflow_component ?local_support_point)
        )
      )
  )
  (:action assign_operational_task_to_operator
    :parameters (?support_operator - support_operator ?operational_task - operational_task)
    :precondition
      (and
        (component_verified ?support_operator)
        (operational_task_available ?operational_task)
      )
    :effect
      (and
        (operator_assigned_operational_task ?support_operator ?operational_task)
        (not
          (operational_task_available ?operational_task)
        )
      )
  )
  (:action release_operational_task_from_operator
    :parameters (?support_operator - support_operator ?operational_task - operational_task)
    :precondition
      (and
        (operator_assigned_operational_task ?support_operator ?operational_task)
      )
    :effect
      (and
        (operational_task_available ?operational_task)
        (not
          (operator_assigned_operational_task ?support_operator ?operational_task)
        )
      )
  )
  (:action assign_escalation_token_to_operator
    :parameters (?support_operator - support_operator ?escalation_token - escalation_token)
    :precondition
      (and
        (component_verified ?support_operator)
        (escalation_token_available ?escalation_token)
      )
    :effect
      (and
        (operator_assigned_escalation_token ?support_operator ?escalation_token)
        (not
          (escalation_token_available ?escalation_token)
        )
      )
  )
  (:action release_escalation_token_from_operator
    :parameters (?support_operator - support_operator ?escalation_token - escalation_token)
    :precondition
      (and
        (operator_assigned_escalation_token ?support_operator ?escalation_token)
      )
    :effect
      (and
        (escalation_token_available ?escalation_token)
        (not
          (operator_assigned_escalation_token ?support_operator ?escalation_token)
        )
      )
  )
  (:action set_location_ready_for_segment
    :parameters (?itinerary_segment - itinerary_segment ?location_context - location_context ?contact_channel - contact_channel)
    :precondition
      (and
        (component_verified ?itinerary_segment)
        (component_contact_channel_assignment ?itinerary_segment ?contact_channel)
        (itinerary_segment_location_context ?itinerary_segment ?location_context)
        (not
          (location_ready_flag ?location_context)
        )
        (not
          (location_document_ready ?location_context)
        )
      )
    :effect (location_ready_flag ?location_context)
  )
  (:action confirm_segment_triage
    :parameters (?itinerary_segment - itinerary_segment ?location_context - location_context ?local_support_point - local_support_point)
    :precondition
      (and
        (component_verified ?itinerary_segment)
        (component_local_support_assignment ?itinerary_segment ?local_support_point)
        (itinerary_segment_location_context ?itinerary_segment ?location_context)
        (location_ready_flag ?location_context)
        (not
          (itinerary_segment_triaged ?itinerary_segment)
        )
      )
    :effect
      (and
        (itinerary_segment_triaged ?itinerary_segment)
        (itinerary_segment_ready ?itinerary_segment)
      )
  )
  (:action attach_verification_artifact_to_segment
    :parameters (?itinerary_segment - itinerary_segment ?location_context - location_context ?evidence_document - evidence_document)
    :precondition
      (and
        (component_verified ?itinerary_segment)
        (itinerary_segment_location_context ?itinerary_segment ?location_context)
        (evidence_document_available ?evidence_document)
        (not
          (itinerary_segment_triaged ?itinerary_segment)
        )
      )
    :effect
      (and
        (location_document_ready ?location_context)
        (itinerary_segment_triaged ?itinerary_segment)
        (itinerary_segment_has_evidence ?itinerary_segment ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action finalize_segment_verification
    :parameters (?itinerary_segment - itinerary_segment ?location_context - location_context ?contact_channel - contact_channel ?evidence_document - evidence_document)
    :precondition
      (and
        (component_verified ?itinerary_segment)
        (component_contact_channel_assignment ?itinerary_segment ?contact_channel)
        (itinerary_segment_location_context ?itinerary_segment ?location_context)
        (location_document_ready ?location_context)
        (itinerary_segment_has_evidence ?itinerary_segment ?evidence_document)
        (not
          (itinerary_segment_ready ?itinerary_segment)
        )
      )
    :effect
      (and
        (location_ready_flag ?location_context)
        (itinerary_segment_ready ?itinerary_segment)
        (evidence_document_available ?evidence_document)
        (not
          (itinerary_segment_has_evidence ?itinerary_segment ?evidence_document)
        )
      )
  )
  (:action set_service_context_ready_for_booking
    :parameters (?service_booking - service_booking ?service_context - service_context ?contact_channel - contact_channel)
    :precondition
      (and
        (component_verified ?service_booking)
        (component_contact_channel_assignment ?service_booking ?contact_channel)
        (service_booking_context_assignment ?service_booking ?service_context)
        (not
          (service_context_ready ?service_context)
        )
        (not
          (service_context_document_ready ?service_context)
        )
      )
    :effect (service_context_ready ?service_context)
  )
  (:action confirm_booking_triage
    :parameters (?service_booking - service_booking ?service_context - service_context ?local_support_point - local_support_point)
    :precondition
      (and
        (component_verified ?service_booking)
        (component_local_support_assignment ?service_booking ?local_support_point)
        (service_booking_context_assignment ?service_booking ?service_context)
        (service_context_ready ?service_context)
        (not
          (service_booking_triaged ?service_booking)
        )
      )
    :effect
      (and
        (service_booking_triaged ?service_booking)
        (service_booking_ready ?service_booking)
      )
  )
  (:action attach_verification_artifact_to_booking
    :parameters (?service_booking - service_booking ?service_context - service_context ?evidence_document - evidence_document)
    :precondition
      (and
        (component_verified ?service_booking)
        (service_booking_context_assignment ?service_booking ?service_context)
        (evidence_document_available ?evidence_document)
        (not
          (service_booking_triaged ?service_booking)
        )
      )
    :effect
      (and
        (service_context_document_ready ?service_context)
        (service_booking_triaged ?service_booking)
        (service_booking_has_evidence ?service_booking ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action finalize_booking_verification
    :parameters (?service_booking - service_booking ?service_context - service_context ?contact_channel - contact_channel ?evidence_document - evidence_document)
    :precondition
      (and
        (component_verified ?service_booking)
        (component_contact_channel_assignment ?service_booking ?contact_channel)
        (service_booking_context_assignment ?service_booking ?service_context)
        (service_context_document_ready ?service_context)
        (service_booking_has_evidence ?service_booking ?evidence_document)
        (not
          (service_booking_ready ?service_booking)
        )
      )
    :effect
      (and
        (service_context_ready ?service_context)
        (service_booking_ready ?service_booking)
        (evidence_document_available ?evidence_document)
        (not
          (service_booking_has_evidence ?service_booking ?evidence_document)
        )
      )
  )
  (:action generate_and_commit_repair_proposal
    :parameters (?itinerary_segment - itinerary_segment ?service_booking - service_booking ?location_context - location_context ?service_context - service_context ?repair_proposal - repair_proposal)
    :precondition
      (and
        (itinerary_segment_triaged ?itinerary_segment)
        (service_booking_triaged ?service_booking)
        (itinerary_segment_location_context ?itinerary_segment ?location_context)
        (service_booking_context_assignment ?service_booking ?service_context)
        (location_ready_flag ?location_context)
        (service_context_ready ?service_context)
        (itinerary_segment_ready ?itinerary_segment)
        (service_booking_ready ?service_booking)
        (proposal_candidate_available ?repair_proposal)
      )
    :effect
      (and
        (proposal_committed ?repair_proposal)
        (proposal_assigned_location ?repair_proposal ?location_context)
        (proposal_assigned_service_context ?repair_proposal ?service_context)
        (not
          (proposal_candidate_available ?repair_proposal)
        )
      )
  )
  (:action generate_and_commit_proposal_primary_sourcing
    :parameters (?itinerary_segment - itinerary_segment ?service_booking - service_booking ?location_context - location_context ?service_context - service_context ?repair_proposal - repair_proposal)
    :precondition
      (and
        (itinerary_segment_triaged ?itinerary_segment)
        (service_booking_triaged ?service_booking)
        (itinerary_segment_location_context ?itinerary_segment ?location_context)
        (service_booking_context_assignment ?service_booking ?service_context)
        (location_document_ready ?location_context)
        (service_context_ready ?service_context)
        (not
          (itinerary_segment_ready ?itinerary_segment)
        )
        (service_booking_ready ?service_booking)
        (proposal_candidate_available ?repair_proposal)
      )
    :effect
      (and
        (proposal_committed ?repair_proposal)
        (proposal_assigned_location ?repair_proposal ?location_context)
        (proposal_assigned_service_context ?repair_proposal ?service_context)
        (proposal_primary_sourcing ?repair_proposal)
        (not
          (proposal_candidate_available ?repair_proposal)
        )
      )
  )
  (:action generate_and_commit_proposal_secondary_sourcing
    :parameters (?itinerary_segment - itinerary_segment ?service_booking - service_booking ?location_context - location_context ?service_context - service_context ?repair_proposal - repair_proposal)
    :precondition
      (and
        (itinerary_segment_triaged ?itinerary_segment)
        (service_booking_triaged ?service_booking)
        (itinerary_segment_location_context ?itinerary_segment ?location_context)
        (service_booking_context_assignment ?service_booking ?service_context)
        (location_ready_flag ?location_context)
        (service_context_document_ready ?service_context)
        (itinerary_segment_ready ?itinerary_segment)
        (not
          (service_booking_ready ?service_booking)
        )
        (proposal_candidate_available ?repair_proposal)
      )
    :effect
      (and
        (proposal_committed ?repair_proposal)
        (proposal_assigned_location ?repair_proposal ?location_context)
        (proposal_assigned_service_context ?repair_proposal ?service_context)
        (proposal_secondary_sourcing ?repair_proposal)
        (not
          (proposal_candidate_available ?repair_proposal)
        )
      )
  )
  (:action generate_and_commit_proposal_both_sourcing
    :parameters (?itinerary_segment - itinerary_segment ?service_booking - service_booking ?location_context - location_context ?service_context - service_context ?repair_proposal - repair_proposal)
    :precondition
      (and
        (itinerary_segment_triaged ?itinerary_segment)
        (service_booking_triaged ?service_booking)
        (itinerary_segment_location_context ?itinerary_segment ?location_context)
        (service_booking_context_assignment ?service_booking ?service_context)
        (location_document_ready ?location_context)
        (service_context_document_ready ?service_context)
        (not
          (itinerary_segment_ready ?itinerary_segment)
        )
        (not
          (service_booking_ready ?service_booking)
        )
        (proposal_candidate_available ?repair_proposal)
      )
    :effect
      (and
        (proposal_committed ?repair_proposal)
        (proposal_assigned_location ?repair_proposal ?location_context)
        (proposal_assigned_service_context ?repair_proposal ?service_context)
        (proposal_primary_sourcing ?repair_proposal)
        (proposal_secondary_sourcing ?repair_proposal)
        (not
          (proposal_candidate_available ?repair_proposal)
        )
      )
  )
  (:action qualify_proposal_for_execution
    :parameters (?repair_proposal - repair_proposal ?itinerary_segment - itinerary_segment ?contact_channel - contact_channel)
    :precondition
      (and
        (proposal_committed ?repair_proposal)
        (itinerary_segment_triaged ?itinerary_segment)
        (component_contact_channel_assignment ?itinerary_segment ?contact_channel)
        (not
          (proposal_execution_ready ?repair_proposal)
        )
      )
    :effect (proposal_execution_ready ?repair_proposal)
  )
  (:action validate_proposal_with_verification_artifact
    :parameters (?support_operator - support_operator ?verification_artifact - verification_artifact ?repair_proposal - repair_proposal)
    :precondition
      (and
        (component_verified ?support_operator)
        (operator_assigned_proposal ?support_operator ?repair_proposal)
        (operator_has_verification_artifact ?support_operator ?verification_artifact)
        (verification_artifact_available ?verification_artifact)
        (proposal_committed ?repair_proposal)
        (proposal_execution_ready ?repair_proposal)
        (not
          (verification_artifact_consumed ?verification_artifact)
        )
      )
    :effect
      (and
        (verification_artifact_consumed ?verification_artifact)
        (verification_artifact_linked_to_proposal ?verification_artifact ?repair_proposal)
        (not
          (verification_artifact_available ?verification_artifact)
        )
      )
  )
  (:action prepare_operator_for_provider_coordination
    :parameters (?support_operator - support_operator ?verification_artifact - verification_artifact ?repair_proposal - repair_proposal ?contact_channel - contact_channel)
    :precondition
      (and
        (component_verified ?support_operator)
        (operator_has_verification_artifact ?support_operator ?verification_artifact)
        (verification_artifact_consumed ?verification_artifact)
        (verification_artifact_linked_to_proposal ?verification_artifact ?repair_proposal)
        (component_contact_channel_assignment ?support_operator ?contact_channel)
        (not
          (proposal_primary_sourcing ?repair_proposal)
        )
        (not
          (operator_ready_for_provider_coordination ?support_operator)
        )
      )
    :effect (operator_ready_for_provider_coordination ?support_operator)
  )
  (:action attach_policy_item_to_operator
    :parameters (?support_operator - support_operator ?policy_item - policy_item)
    :precondition
      (and
        (component_verified ?support_operator)
        (policy_item_available ?policy_item)
        (not
          (operator_policy_engaged ?support_operator)
        )
      )
    :effect
      (and
        (operator_policy_engaged ?support_operator)
        (operator_linked_policy_item ?support_operator ?policy_item)
        (not
          (policy_item_available ?policy_item)
        )
      )
  )
  (:action confirm_operator_policy_and_prepare_execution
    :parameters (?support_operator - support_operator ?verification_artifact - verification_artifact ?repair_proposal - repair_proposal ?contact_channel - contact_channel ?policy_item - policy_item)
    :precondition
      (and
        (component_verified ?support_operator)
        (operator_has_verification_artifact ?support_operator ?verification_artifact)
        (verification_artifact_consumed ?verification_artifact)
        (verification_artifact_linked_to_proposal ?verification_artifact ?repair_proposal)
        (component_contact_channel_assignment ?support_operator ?contact_channel)
        (proposal_primary_sourcing ?repair_proposal)
        (operator_policy_engaged ?support_operator)
        (operator_linked_policy_item ?support_operator ?policy_item)
        (not
          (operator_ready_for_provider_coordination ?support_operator)
        )
      )
    :effect
      (and
        (operator_ready_for_provider_coordination ?support_operator)
        (operator_policy_confirmed ?support_operator)
      )
  )
  (:action coordinate_operator_with_provider_primary
    :parameters (?support_operator - support_operator ?operational_task - operational_task ?local_support_point - local_support_point ?verification_artifact - verification_artifact ?repair_proposal - repair_proposal)
    :precondition
      (and
        (operator_ready_for_provider_coordination ?support_operator)
        (operator_assigned_operational_task ?support_operator ?operational_task)
        (component_local_support_assignment ?support_operator ?local_support_point)
        (operator_has_verification_artifact ?support_operator ?verification_artifact)
        (verification_artifact_linked_to_proposal ?verification_artifact ?repair_proposal)
        (not
          (proposal_secondary_sourcing ?repair_proposal)
        )
        (not
          (operator_provider_coordination_completed ?support_operator)
        )
      )
    :effect (operator_provider_coordination_completed ?support_operator)
  )
  (:action coordinate_operator_with_provider_secondary
    :parameters (?support_operator - support_operator ?operational_task - operational_task ?local_support_point - local_support_point ?verification_artifact - verification_artifact ?repair_proposal - repair_proposal)
    :precondition
      (and
        (operator_ready_for_provider_coordination ?support_operator)
        (operator_assigned_operational_task ?support_operator ?operational_task)
        (component_local_support_assignment ?support_operator ?local_support_point)
        (operator_has_verification_artifact ?support_operator ?verification_artifact)
        (verification_artifact_linked_to_proposal ?verification_artifact ?repair_proposal)
        (proposal_secondary_sourcing ?repair_proposal)
        (not
          (operator_provider_coordination_completed ?support_operator)
        )
      )
    :effect (operator_provider_coordination_completed ?support_operator)
  )
  (:action operator_prepare_for_final_validation
    :parameters (?support_operator - support_operator ?escalation_token - escalation_token ?verification_artifact - verification_artifact ?repair_proposal - repair_proposal)
    :precondition
      (and
        (operator_provider_coordination_completed ?support_operator)
        (operator_assigned_escalation_token ?support_operator ?escalation_token)
        (operator_has_verification_artifact ?support_operator ?verification_artifact)
        (verification_artifact_linked_to_proposal ?verification_artifact ?repair_proposal)
        (not
          (proposal_primary_sourcing ?repair_proposal)
        )
        (not
          (proposal_secondary_sourcing ?repair_proposal)
        )
        (not
          (operator_prepared_for_finalization ?support_operator)
        )
      )
    :effect (operator_prepared_for_finalization ?support_operator)
  )
  (:action operator_prepare_and_authorize_primary_path
    :parameters (?support_operator - support_operator ?escalation_token - escalation_token ?verification_artifact - verification_artifact ?repair_proposal - repair_proposal)
    :precondition
      (and
        (operator_provider_coordination_completed ?support_operator)
        (operator_assigned_escalation_token ?support_operator ?escalation_token)
        (operator_has_verification_artifact ?support_operator ?verification_artifact)
        (verification_artifact_linked_to_proposal ?verification_artifact ?repair_proposal)
        (proposal_primary_sourcing ?repair_proposal)
        (not
          (proposal_secondary_sourcing ?repair_proposal)
        )
        (not
          (operator_prepared_for_finalization ?support_operator)
        )
      )
    :effect
      (and
        (operator_prepared_for_finalization ?support_operator)
        (operator_compensation_authorized ?support_operator)
      )
  )
  (:action operator_prepare_and_authorize_secondary_path
    :parameters (?support_operator - support_operator ?escalation_token - escalation_token ?verification_artifact - verification_artifact ?repair_proposal - repair_proposal)
    :precondition
      (and
        (operator_provider_coordination_completed ?support_operator)
        (operator_assigned_escalation_token ?support_operator ?escalation_token)
        (operator_has_verification_artifact ?support_operator ?verification_artifact)
        (verification_artifact_linked_to_proposal ?verification_artifact ?repair_proposal)
        (not
          (proposal_primary_sourcing ?repair_proposal)
        )
        (proposal_secondary_sourcing ?repair_proposal)
        (not
          (operator_prepared_for_finalization ?support_operator)
        )
      )
    :effect
      (and
        (operator_prepared_for_finalization ?support_operator)
        (operator_compensation_authorized ?support_operator)
      )
  )
  (:action operator_prepare_and_authorize_both_paths
    :parameters (?support_operator - support_operator ?escalation_token - escalation_token ?verification_artifact - verification_artifact ?repair_proposal - repair_proposal)
    :precondition
      (and
        (operator_provider_coordination_completed ?support_operator)
        (operator_assigned_escalation_token ?support_operator ?escalation_token)
        (operator_has_verification_artifact ?support_operator ?verification_artifact)
        (verification_artifact_linked_to_proposal ?verification_artifact ?repair_proposal)
        (proposal_primary_sourcing ?repair_proposal)
        (proposal_secondary_sourcing ?repair_proposal)
        (not
          (operator_prepared_for_finalization ?support_operator)
        )
      )
    :effect
      (and
        (operator_prepared_for_finalization ?support_operator)
        (operator_compensation_authorized ?support_operator)
      )
  )
  (:action finalize_operator_execution_simple
    :parameters (?support_operator - support_operator)
    :precondition
      (and
        (operator_prepared_for_finalization ?support_operator)
        (not
          (operator_compensation_authorized ?support_operator)
        )
        (not
          (operator_closure_registered ?support_operator)
        )
      )
    :effect
      (and
        (operator_closure_registered ?support_operator)
        (component_tasks_completed ?support_operator)
      )
  )
  (:action assign_compensation_packet_to_operator
    :parameters (?support_operator - support_operator ?compensation_packet_type - compensation_packet_type)
    :precondition
      (and
        (operator_prepared_for_finalization ?support_operator)
        (operator_compensation_authorized ?support_operator)
        (compensation_packet_type_available ?compensation_packet_type)
      )
    :effect
      (and
        (operator_assigned_compensation_packet ?support_operator ?compensation_packet_type)
        (not
          (compensation_packet_type_available ?compensation_packet_type)
        )
      )
  )
  (:action execute_operator_tasks_with_compensation
    :parameters (?support_operator - support_operator ?itinerary_segment - itinerary_segment ?service_booking - service_booking ?contact_channel - contact_channel ?compensation_packet_type - compensation_packet_type)
    :precondition
      (and
        (operator_prepared_for_finalization ?support_operator)
        (operator_compensation_authorized ?support_operator)
        (operator_assigned_compensation_packet ?support_operator ?compensation_packet_type)
        (operator_assigned_segment ?support_operator ?itinerary_segment)
        (operator_assigned_booking ?support_operator ?service_booking)
        (itinerary_segment_ready ?itinerary_segment)
        (service_booking_ready ?service_booking)
        (component_contact_channel_assignment ?support_operator ?contact_channel)
        (not
          (operator_execution_completed ?support_operator)
        )
      )
    :effect (operator_execution_completed ?support_operator)
  )
  (:action finalize_operator_execution_with_compensation
    :parameters (?support_operator - support_operator)
    :precondition
      (and
        (operator_prepared_for_finalization ?support_operator)
        (operator_execution_completed ?support_operator)
        (not
          (operator_closure_registered ?support_operator)
        )
      )
    :effect
      (and
        (operator_closure_registered ?support_operator)
        (component_tasks_completed ?support_operator)
      )
  )
  (:action acquire_operator_approval
    :parameters (?support_operator - support_operator ?approval_token - approval_token ?contact_channel - contact_channel)
    :precondition
      (and
        (component_verified ?support_operator)
        (component_contact_channel_assignment ?support_operator ?contact_channel)
        (approval_token_available ?approval_token)
        (operator_approval_assigned ?support_operator ?approval_token)
        (not
          (operator_approval_acquired ?support_operator)
        )
      )
    :effect
      (and
        (operator_approval_acquired ?support_operator)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action confirm_local_support_after_approval
    :parameters (?support_operator - support_operator ?local_support_point - local_support_point)
    :precondition
      (and
        (operator_approval_acquired ?support_operator)
        (component_local_support_assignment ?support_operator ?local_support_point)
        (not
          (operator_local_support_confirmed ?support_operator)
        )
      )
    :effect (operator_local_support_confirmed ?support_operator)
  )
  (:action apply_escalation_after_local_support
    :parameters (?support_operator - support_operator ?escalation_token - escalation_token)
    :precondition
      (and
        (operator_local_support_confirmed ?support_operator)
        (operator_assigned_escalation_token ?support_operator ?escalation_token)
        (not
          (operator_escalation_applied ?support_operator)
        )
      )
    :effect (operator_escalation_applied ?support_operator)
  )
  (:action finalize_operator_execution_after_escalation
    :parameters (?support_operator - support_operator)
    :precondition
      (and
        (operator_escalation_applied ?support_operator)
        (not
          (operator_closure_registered ?support_operator)
        )
      )
    :effect
      (and
        (operator_closure_registered ?support_operator)
        (component_tasks_completed ?support_operator)
      )
  )
  (:action close_itinerary_segment
    :parameters (?itinerary_segment - itinerary_segment ?repair_proposal - repair_proposal)
    :precondition
      (and
        (itinerary_segment_triaged ?itinerary_segment)
        (itinerary_segment_ready ?itinerary_segment)
        (proposal_committed ?repair_proposal)
        (proposal_execution_ready ?repair_proposal)
        (not
          (component_tasks_completed ?itinerary_segment)
        )
      )
    :effect (component_tasks_completed ?itinerary_segment)
  )
  (:action close_service_booking
    :parameters (?service_booking - service_booking ?repair_proposal - repair_proposal)
    :precondition
      (and
        (service_booking_triaged ?service_booking)
        (service_booking_ready ?service_booking)
        (proposal_committed ?repair_proposal)
        (proposal_execution_ready ?repair_proposal)
        (not
          (component_tasks_completed ?service_booking)
        )
      )
    :effect (component_tasks_completed ?service_booking)
  )
  (:action initiate_compensation_for_component
    :parameters (?workflow_component - workflow_component ?compensation_item - compensation_item ?contact_channel - contact_channel)
    :precondition
      (and
        (component_tasks_completed ?workflow_component)
        (component_contact_channel_assignment ?workflow_component ?contact_channel)
        (compensation_item_available ?compensation_item)
        (not
          (compensation_initiated ?workflow_component)
        )
      )
    :effect
      (and
        (compensation_initiated ?workflow_component)
        (component_compensation_item_linked ?workflow_component ?compensation_item)
        (not
          (compensation_item_available ?compensation_item)
        )
      )
  )
  (:action apply_compensation_and_close_segment
    :parameters (?itinerary_segment - itinerary_segment ?external_provider_resource - external_provider_resource ?compensation_item - compensation_item)
    :precondition
      (and
        (compensation_initiated ?itinerary_segment)
        (component_provider_assignment ?itinerary_segment ?external_provider_resource)
        (component_compensation_item_linked ?itinerary_segment ?compensation_item)
        (not
          (component_closed ?itinerary_segment)
        )
      )
    :effect
      (and
        (component_closed ?itinerary_segment)
        (provider_resource_available ?external_provider_resource)
        (compensation_item_available ?compensation_item)
      )
  )
  (:action apply_compensation_and_close_booking
    :parameters (?service_booking - service_booking ?external_provider_resource - external_provider_resource ?compensation_item - compensation_item)
    :precondition
      (and
        (compensation_initiated ?service_booking)
        (component_provider_assignment ?service_booking ?external_provider_resource)
        (component_compensation_item_linked ?service_booking ?compensation_item)
        (not
          (component_closed ?service_booking)
        )
      )
    :effect
      (and
        (component_closed ?service_booking)
        (provider_resource_available ?external_provider_resource)
        (compensation_item_available ?compensation_item)
      )
  )
  (:action apply_compensation_and_close_operator
    :parameters (?support_operator - support_operator ?external_provider_resource - external_provider_resource ?compensation_item - compensation_item)
    :precondition
      (and
        (compensation_initiated ?support_operator)
        (component_provider_assignment ?support_operator ?external_provider_resource)
        (component_compensation_item_linked ?support_operator ?compensation_item)
        (not
          (component_closed ?support_operator)
        )
      )
    :effect
      (and
        (component_closed ?support_operator)
        (provider_resource_available ?external_provider_resource)
        (compensation_item_available ?compensation_item)
      )
  )
)

(define (domain outbound_payment_confirmation_reconciliation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource_category - object channel_resource_category - object support_resource_category - object instruction_category - object processable_item - instruction_category routing_candidate - operational_resource_category validation_resource - operational_resource_category authorization_resource - operational_resource_category partner_profile - operational_resource_category execution_priority_profile - operational_resource_category confirmation_token - operational_resource_category settlement_authorization_token - operational_resource_category audit_evidence_record - operational_resource_category supplementary_instruction_fragment - channel_resource_category supporting_document - channel_resource_category external_approval_handle - channel_resource_category origin_settlement_channel_candidate - support_resource_category destination_settlement_channel_candidate - support_resource_category settlement_message_payload - support_resource_category payment_leg_category_origin - processable_item payment_leg_category_destination - processable_item originating_payment_leg - payment_leg_category_origin beneficiary_payment_leg - payment_leg_category_origin reconciliation_case - payment_leg_category_destination)
  (:predicates
    (payment_instruction_registered ?processable_item - processable_item)
    (released_for_processing ?processable_item - processable_item)
    (instruction_routing_reserved ?processable_item - processable_item)
    (settlement_confirmed ?processable_item - processable_item)
    (ready_for_confirmation ?processable_item - processable_item)
    (confirmation_recorded ?processable_item - processable_item)
    (routing_candidate_available ?routing_candidate - routing_candidate)
    (assigned_routing_candidate ?processable_item - processable_item ?routing_candidate - routing_candidate)
    (validation_resource_available ?validation_resource - validation_resource)
    (assigned_validation_resource ?processable_item - processable_item ?validation_resource - validation_resource)
    (authorization_resource_available ?authorization_resource - authorization_resource)
    (assigned_authorization_resource ?processable_item - processable_item ?authorization_resource - authorization_resource)
    (supplementary_fragment_available ?supplementary_fragment - supplementary_instruction_fragment)
    (origin_leg_fragment_attached ?originating_payment_leg - originating_payment_leg ?supplementary_fragment - supplementary_instruction_fragment)
    (beneficiary_leg_fragment_attached ?beneficiary_payment_leg - beneficiary_payment_leg ?supplementary_fragment - supplementary_instruction_fragment)
    (origin_leg_channel_candidate_linked ?originating_payment_leg - originating_payment_leg ?origin_settlement_channel_candidate - origin_settlement_channel_candidate)
    (origin_channel_candidate_selected ?origin_settlement_channel_candidate - origin_settlement_channel_candidate)
    (origin_channel_candidate_fragment_attached ?origin_settlement_channel_candidate - origin_settlement_channel_candidate)
    (origin_leg_confirmed ?originating_payment_leg - originating_payment_leg)
    (beneficiary_leg_channel_candidate_linked ?beneficiary_payment_leg - beneficiary_payment_leg ?destination_settlement_channel_candidate - destination_settlement_channel_candidate)
    (destination_channel_candidate_selected ?destination_settlement_channel_candidate - destination_settlement_channel_candidate)
    (destination_channel_candidate_fragment_attached ?destination_settlement_channel_candidate - destination_settlement_channel_candidate)
    (beneficiary_leg_confirmed ?beneficiary_payment_leg - beneficiary_payment_leg)
    (settlement_payload_available ?settlement_message_payload - settlement_message_payload)
    (settlement_payload_assembled ?settlement_message_payload - settlement_message_payload)
    (payload_bound_origin_channel ?settlement_message_payload - settlement_message_payload ?origin_settlement_channel_candidate - origin_settlement_channel_candidate)
    (payload_bound_destination_channel ?settlement_message_payload - settlement_message_payload ?destination_settlement_channel_candidate - destination_settlement_channel_candidate)
    (payload_origin_acknowledged ?settlement_message_payload - settlement_message_payload)
    (payload_destination_acknowledged ?settlement_message_payload - settlement_message_payload)
    (payload_dispatched_to_channel ?settlement_message_payload - settlement_message_payload)
    (case_has_origin_leg ?reconciliation_case - reconciliation_case ?originating_payment_leg - originating_payment_leg)
    (case_has_beneficiary_leg ?reconciliation_case - reconciliation_case ?beneficiary_payment_leg - beneficiary_payment_leg)
    (case_linked_to_payload ?reconciliation_case - reconciliation_case ?settlement_message_payload - settlement_message_payload)
    (supporting_document_available ?supporting_document - supporting_document)
    (case_has_supporting_document ?reconciliation_case - reconciliation_case ?supporting_document - supporting_document)
    (supporting_document_ingested ?supporting_document - supporting_document)
    (supporting_document_bound_to_payload ?supporting_document - supporting_document ?settlement_message_payload - settlement_message_payload)
    (case_document_verified ?reconciliation_case - reconciliation_case)
    (case_authorization_prepared ?reconciliation_case - reconciliation_case)
    (case_ready_for_execution ?reconciliation_case - reconciliation_case)
    (partner_profile_attached ?reconciliation_case - reconciliation_case)
    (partner_profile_verified ?reconciliation_case - reconciliation_case)
    (case_priority_attached ?reconciliation_case - reconciliation_case)
    (case_execution_verified ?reconciliation_case - reconciliation_case)
    (external_approval_handle_available ?external_approval_handle - external_approval_handle)
    (external_approval_bound_to_case ?reconciliation_case - reconciliation_case ?external_approval_handle - external_approval_handle)
    (case_external_approval_requested ?reconciliation_case - reconciliation_case)
    (external_approval_in_progress ?reconciliation_case - reconciliation_case)
    (external_approval_obtained ?reconciliation_case - reconciliation_case)
    (partner_profile_available ?partner_profile - partner_profile)
    (partner_profile_bound_to_case ?reconciliation_case - reconciliation_case ?partner_profile - partner_profile)
    (execution_priority_available ?execution_priority_profile - execution_priority_profile)
    (execution_priority_bound_to_case ?reconciliation_case - reconciliation_case ?execution_priority_profile - execution_priority_profile)
    (settlement_authorization_token_available ?settlement_authorization_token - settlement_authorization_token)
    (settlement_authorization_bound_to_case ?reconciliation_case - reconciliation_case ?settlement_authorization_token - settlement_authorization_token)
    (audit_evidence_available ?audit_evidence_record - audit_evidence_record)
    (audit_evidence_bound_to_case ?reconciliation_case - reconciliation_case ?audit_evidence_record - audit_evidence_record)
    (confirmation_token_available ?confirmation_token - confirmation_token)
    (confirmation_token_assigned ?processable_item - processable_item ?confirmation_token - confirmation_token)
    (originating_leg_ready ?originating_payment_leg - originating_payment_leg)
    (beneficiary_leg_ready ?beneficiary_payment_leg - beneficiary_payment_leg)
    (case_execution_marked ?reconciliation_case - reconciliation_case)
  )
  (:action register_payment_instruction
    :parameters (?processable_item - processable_item)
    :precondition
      (and
        (not
          (payment_instruction_registered ?processable_item)
        )
        (not
          (settlement_confirmed ?processable_item)
        )
      )
    :effect (payment_instruction_registered ?processable_item)
  )
  (:action reserve_routing_candidate_for_instruction
    :parameters (?processable_item - processable_item ?routing_candidate - routing_candidate)
    :precondition
      (and
        (payment_instruction_registered ?processable_item)
        (not
          (instruction_routing_reserved ?processable_item)
        )
        (routing_candidate_available ?routing_candidate)
      )
    :effect
      (and
        (instruction_routing_reserved ?processable_item)
        (assigned_routing_candidate ?processable_item ?routing_candidate)
        (not
          (routing_candidate_available ?routing_candidate)
        )
      )
  )
  (:action assign_validation_resource_to_instruction
    :parameters (?processable_item - processable_item ?validation_resource - validation_resource)
    :precondition
      (and
        (payment_instruction_registered ?processable_item)
        (instruction_routing_reserved ?processable_item)
        (validation_resource_available ?validation_resource)
      )
    :effect
      (and
        (assigned_validation_resource ?processable_item ?validation_resource)
        (not
          (validation_resource_available ?validation_resource)
        )
      )
  )
  (:action complete_validation_for_instruction
    :parameters (?processable_item - processable_item ?validation_resource - validation_resource)
    :precondition
      (and
        (payment_instruction_registered ?processable_item)
        (instruction_routing_reserved ?processable_item)
        (assigned_validation_resource ?processable_item ?validation_resource)
        (not
          (released_for_processing ?processable_item)
        )
      )
    :effect (released_for_processing ?processable_item)
  )
  (:action release_validation_assignment
    :parameters (?processable_item - processable_item ?validation_resource - validation_resource)
    :precondition
      (and
        (assigned_validation_resource ?processable_item ?validation_resource)
      )
    :effect
      (and
        (validation_resource_available ?validation_resource)
        (not
          (assigned_validation_resource ?processable_item ?validation_resource)
        )
      )
  )
  (:action assign_authorization_resource_to_instruction
    :parameters (?processable_item - processable_item ?authorization_resource - authorization_resource)
    :precondition
      (and
        (released_for_processing ?processable_item)
        (authorization_resource_available ?authorization_resource)
      )
    :effect
      (and
        (assigned_authorization_resource ?processable_item ?authorization_resource)
        (not
          (authorization_resource_available ?authorization_resource)
        )
      )
  )
  (:action release_authorization_assignment
    :parameters (?processable_item - processable_item ?authorization_resource - authorization_resource)
    :precondition
      (and
        (assigned_authorization_resource ?processable_item ?authorization_resource)
      )
    :effect
      (and
        (authorization_resource_available ?authorization_resource)
        (not
          (assigned_authorization_resource ?processable_item ?authorization_resource)
        )
      )
  )
  (:action assign_settlement_authorization_token_to_case
    :parameters (?reconciliation_case - reconciliation_case ?settlement_authorization_token - settlement_authorization_token)
    :precondition
      (and
        (released_for_processing ?reconciliation_case)
        (settlement_authorization_token_available ?settlement_authorization_token)
      )
    :effect
      (and
        (settlement_authorization_bound_to_case ?reconciliation_case ?settlement_authorization_token)
        (not
          (settlement_authorization_token_available ?settlement_authorization_token)
        )
      )
  )
  (:action release_settlement_authorization_token_from_case
    :parameters (?reconciliation_case - reconciliation_case ?settlement_authorization_token - settlement_authorization_token)
    :precondition
      (and
        (settlement_authorization_bound_to_case ?reconciliation_case ?settlement_authorization_token)
      )
    :effect
      (and
        (settlement_authorization_token_available ?settlement_authorization_token)
        (not
          (settlement_authorization_bound_to_case ?reconciliation_case ?settlement_authorization_token)
        )
      )
  )
  (:action assign_audit_evidence_to_case
    :parameters (?reconciliation_case - reconciliation_case ?audit_evidence_record - audit_evidence_record)
    :precondition
      (and
        (released_for_processing ?reconciliation_case)
        (audit_evidence_available ?audit_evidence_record)
      )
    :effect
      (and
        (audit_evidence_bound_to_case ?reconciliation_case ?audit_evidence_record)
        (not
          (audit_evidence_available ?audit_evidence_record)
        )
      )
  )
  (:action release_audit_evidence_from_case
    :parameters (?reconciliation_case - reconciliation_case ?audit_evidence_record - audit_evidence_record)
    :precondition
      (and
        (audit_evidence_bound_to_case ?reconciliation_case ?audit_evidence_record)
      )
    :effect
      (and
        (audit_evidence_available ?audit_evidence_record)
        (not
          (audit_evidence_bound_to_case ?reconciliation_case ?audit_evidence_record)
        )
      )
  )
  (:action evaluate_origin_channel_candidate
    :parameters (?originating_payment_leg - originating_payment_leg ?origin_settlement_channel_candidate - origin_settlement_channel_candidate ?validation_resource - validation_resource)
    :precondition
      (and
        (released_for_processing ?originating_payment_leg)
        (assigned_validation_resource ?originating_payment_leg ?validation_resource)
        (origin_leg_channel_candidate_linked ?originating_payment_leg ?origin_settlement_channel_candidate)
        (not
          (origin_channel_candidate_selected ?origin_settlement_channel_candidate)
        )
        (not
          (origin_channel_candidate_fragment_attached ?origin_settlement_channel_candidate)
        )
      )
    :effect (origin_channel_candidate_selected ?origin_settlement_channel_candidate)
  )
  (:action confirm_origin_channel_selection_with_authorization
    :parameters (?originating_payment_leg - originating_payment_leg ?origin_settlement_channel_candidate - origin_settlement_channel_candidate ?authorization_resource - authorization_resource)
    :precondition
      (and
        (released_for_processing ?originating_payment_leg)
        (assigned_authorization_resource ?originating_payment_leg ?authorization_resource)
        (origin_leg_channel_candidate_linked ?originating_payment_leg ?origin_settlement_channel_candidate)
        (origin_channel_candidate_selected ?origin_settlement_channel_candidate)
        (not
          (originating_leg_ready ?originating_payment_leg)
        )
      )
    :effect
      (and
        (originating_leg_ready ?originating_payment_leg)
        (origin_leg_confirmed ?originating_payment_leg)
      )
  )
  (:action attach_supplementary_fragment_to_origin_leg
    :parameters (?originating_payment_leg - originating_payment_leg ?origin_settlement_channel_candidate - origin_settlement_channel_candidate ?supplementary_fragment - supplementary_instruction_fragment)
    :precondition
      (and
        (released_for_processing ?originating_payment_leg)
        (origin_leg_channel_candidate_linked ?originating_payment_leg ?origin_settlement_channel_candidate)
        (supplementary_fragment_available ?supplementary_fragment)
        (not
          (originating_leg_ready ?originating_payment_leg)
        )
      )
    :effect
      (and
        (origin_channel_candidate_fragment_attached ?origin_settlement_channel_candidate)
        (originating_leg_ready ?originating_payment_leg)
        (origin_leg_fragment_attached ?originating_payment_leg ?supplementary_fragment)
        (not
          (supplementary_fragment_available ?supplementary_fragment)
        )
      )
  )
  (:action finalize_origin_channel_fragment_attachment
    :parameters (?originating_payment_leg - originating_payment_leg ?origin_settlement_channel_candidate - origin_settlement_channel_candidate ?validation_resource - validation_resource ?supplementary_fragment - supplementary_instruction_fragment)
    :precondition
      (and
        (released_for_processing ?originating_payment_leg)
        (assigned_validation_resource ?originating_payment_leg ?validation_resource)
        (origin_leg_channel_candidate_linked ?originating_payment_leg ?origin_settlement_channel_candidate)
        (origin_channel_candidate_fragment_attached ?origin_settlement_channel_candidate)
        (origin_leg_fragment_attached ?originating_payment_leg ?supplementary_fragment)
        (not
          (origin_leg_confirmed ?originating_payment_leg)
        )
      )
    :effect
      (and
        (origin_channel_candidate_selected ?origin_settlement_channel_candidate)
        (origin_leg_confirmed ?originating_payment_leg)
        (supplementary_fragment_available ?supplementary_fragment)
        (not
          (origin_leg_fragment_attached ?originating_payment_leg ?supplementary_fragment)
        )
      )
  )
  (:action evaluate_destination_channel_candidate
    :parameters (?beneficiary_payment_leg - beneficiary_payment_leg ?destination_settlement_channel_candidate - destination_settlement_channel_candidate ?validation_resource - validation_resource)
    :precondition
      (and
        (released_for_processing ?beneficiary_payment_leg)
        (assigned_validation_resource ?beneficiary_payment_leg ?validation_resource)
        (beneficiary_leg_channel_candidate_linked ?beneficiary_payment_leg ?destination_settlement_channel_candidate)
        (not
          (destination_channel_candidate_selected ?destination_settlement_channel_candidate)
        )
        (not
          (destination_channel_candidate_fragment_attached ?destination_settlement_channel_candidate)
        )
      )
    :effect (destination_channel_candidate_selected ?destination_settlement_channel_candidate)
  )
  (:action confirm_destination_channel_selection_with_authorization
    :parameters (?beneficiary_payment_leg - beneficiary_payment_leg ?destination_settlement_channel_candidate - destination_settlement_channel_candidate ?authorization_resource - authorization_resource)
    :precondition
      (and
        (released_for_processing ?beneficiary_payment_leg)
        (assigned_authorization_resource ?beneficiary_payment_leg ?authorization_resource)
        (beneficiary_leg_channel_candidate_linked ?beneficiary_payment_leg ?destination_settlement_channel_candidate)
        (destination_channel_candidate_selected ?destination_settlement_channel_candidate)
        (not
          (beneficiary_leg_ready ?beneficiary_payment_leg)
        )
      )
    :effect
      (and
        (beneficiary_leg_ready ?beneficiary_payment_leg)
        (beneficiary_leg_confirmed ?beneficiary_payment_leg)
      )
  )
  (:action attach_supplementary_fragment_to_beneficiary_leg
    :parameters (?beneficiary_payment_leg - beneficiary_payment_leg ?destination_settlement_channel_candidate - destination_settlement_channel_candidate ?supplementary_fragment - supplementary_instruction_fragment)
    :precondition
      (and
        (released_for_processing ?beneficiary_payment_leg)
        (beneficiary_leg_channel_candidate_linked ?beneficiary_payment_leg ?destination_settlement_channel_candidate)
        (supplementary_fragment_available ?supplementary_fragment)
        (not
          (beneficiary_leg_ready ?beneficiary_payment_leg)
        )
      )
    :effect
      (and
        (destination_channel_candidate_fragment_attached ?destination_settlement_channel_candidate)
        (beneficiary_leg_ready ?beneficiary_payment_leg)
        (beneficiary_leg_fragment_attached ?beneficiary_payment_leg ?supplementary_fragment)
        (not
          (supplementary_fragment_available ?supplementary_fragment)
        )
      )
  )
  (:action finalize_destination_channel_fragment_attachment
    :parameters (?beneficiary_payment_leg - beneficiary_payment_leg ?destination_settlement_channel_candidate - destination_settlement_channel_candidate ?validation_resource - validation_resource ?supplementary_fragment - supplementary_instruction_fragment)
    :precondition
      (and
        (released_for_processing ?beneficiary_payment_leg)
        (assigned_validation_resource ?beneficiary_payment_leg ?validation_resource)
        (beneficiary_leg_channel_candidate_linked ?beneficiary_payment_leg ?destination_settlement_channel_candidate)
        (destination_channel_candidate_fragment_attached ?destination_settlement_channel_candidate)
        (beneficiary_leg_fragment_attached ?beneficiary_payment_leg ?supplementary_fragment)
        (not
          (beneficiary_leg_confirmed ?beneficiary_payment_leg)
        )
      )
    :effect
      (and
        (destination_channel_candidate_selected ?destination_settlement_channel_candidate)
        (beneficiary_leg_confirmed ?beneficiary_payment_leg)
        (supplementary_fragment_available ?supplementary_fragment)
        (not
          (beneficiary_leg_fragment_attached ?beneficiary_payment_leg ?supplementary_fragment)
        )
      )
  )
  (:action assemble_settlement_payload_standard
    :parameters (?originating_payment_leg - originating_payment_leg ?beneficiary_payment_leg - beneficiary_payment_leg ?origin_settlement_channel_candidate - origin_settlement_channel_candidate ?destination_settlement_channel_candidate - destination_settlement_channel_candidate ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (originating_leg_ready ?originating_payment_leg)
        (beneficiary_leg_ready ?beneficiary_payment_leg)
        (origin_leg_channel_candidate_linked ?originating_payment_leg ?origin_settlement_channel_candidate)
        (beneficiary_leg_channel_candidate_linked ?beneficiary_payment_leg ?destination_settlement_channel_candidate)
        (origin_channel_candidate_selected ?origin_settlement_channel_candidate)
        (destination_channel_candidate_selected ?destination_settlement_channel_candidate)
        (origin_leg_confirmed ?originating_payment_leg)
        (beneficiary_leg_confirmed ?beneficiary_payment_leg)
        (settlement_payload_available ?settlement_message_payload)
      )
    :effect
      (and
        (settlement_payload_assembled ?settlement_message_payload)
        (payload_bound_origin_channel ?settlement_message_payload ?origin_settlement_channel_candidate)
        (payload_bound_destination_channel ?settlement_message_payload ?destination_settlement_channel_candidate)
        (not
          (settlement_payload_available ?settlement_message_payload)
        )
      )
  )
  (:action assemble_settlement_payload_origin_fragment
    :parameters (?originating_payment_leg - originating_payment_leg ?beneficiary_payment_leg - beneficiary_payment_leg ?origin_settlement_channel_candidate - origin_settlement_channel_candidate ?destination_settlement_channel_candidate - destination_settlement_channel_candidate ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (originating_leg_ready ?originating_payment_leg)
        (beneficiary_leg_ready ?beneficiary_payment_leg)
        (origin_leg_channel_candidate_linked ?originating_payment_leg ?origin_settlement_channel_candidate)
        (beneficiary_leg_channel_candidate_linked ?beneficiary_payment_leg ?destination_settlement_channel_candidate)
        (origin_channel_candidate_fragment_attached ?origin_settlement_channel_candidate)
        (destination_channel_candidate_selected ?destination_settlement_channel_candidate)
        (not
          (origin_leg_confirmed ?originating_payment_leg)
        )
        (beneficiary_leg_confirmed ?beneficiary_payment_leg)
        (settlement_payload_available ?settlement_message_payload)
      )
    :effect
      (and
        (settlement_payload_assembled ?settlement_message_payload)
        (payload_bound_origin_channel ?settlement_message_payload ?origin_settlement_channel_candidate)
        (payload_bound_destination_channel ?settlement_message_payload ?destination_settlement_channel_candidate)
        (payload_origin_acknowledged ?settlement_message_payload)
        (not
          (settlement_payload_available ?settlement_message_payload)
        )
      )
  )
  (:action assemble_settlement_payload_destination_fragment
    :parameters (?originating_payment_leg - originating_payment_leg ?beneficiary_payment_leg - beneficiary_payment_leg ?origin_settlement_channel_candidate - origin_settlement_channel_candidate ?destination_settlement_channel_candidate - destination_settlement_channel_candidate ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (originating_leg_ready ?originating_payment_leg)
        (beneficiary_leg_ready ?beneficiary_payment_leg)
        (origin_leg_channel_candidate_linked ?originating_payment_leg ?origin_settlement_channel_candidate)
        (beneficiary_leg_channel_candidate_linked ?beneficiary_payment_leg ?destination_settlement_channel_candidate)
        (origin_channel_candidate_selected ?origin_settlement_channel_candidate)
        (destination_channel_candidate_fragment_attached ?destination_settlement_channel_candidate)
        (origin_leg_confirmed ?originating_payment_leg)
        (not
          (beneficiary_leg_confirmed ?beneficiary_payment_leg)
        )
        (settlement_payload_available ?settlement_message_payload)
      )
    :effect
      (and
        (settlement_payload_assembled ?settlement_message_payload)
        (payload_bound_origin_channel ?settlement_message_payload ?origin_settlement_channel_candidate)
        (payload_bound_destination_channel ?settlement_message_payload ?destination_settlement_channel_candidate)
        (payload_destination_acknowledged ?settlement_message_payload)
        (not
          (settlement_payload_available ?settlement_message_payload)
        )
      )
  )
  (:action assemble_settlement_payload_both_fragments
    :parameters (?originating_payment_leg - originating_payment_leg ?beneficiary_payment_leg - beneficiary_payment_leg ?origin_settlement_channel_candidate - origin_settlement_channel_candidate ?destination_settlement_channel_candidate - destination_settlement_channel_candidate ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (originating_leg_ready ?originating_payment_leg)
        (beneficiary_leg_ready ?beneficiary_payment_leg)
        (origin_leg_channel_candidate_linked ?originating_payment_leg ?origin_settlement_channel_candidate)
        (beneficiary_leg_channel_candidate_linked ?beneficiary_payment_leg ?destination_settlement_channel_candidate)
        (origin_channel_candidate_fragment_attached ?origin_settlement_channel_candidate)
        (destination_channel_candidate_fragment_attached ?destination_settlement_channel_candidate)
        (not
          (origin_leg_confirmed ?originating_payment_leg)
        )
        (not
          (beneficiary_leg_confirmed ?beneficiary_payment_leg)
        )
        (settlement_payload_available ?settlement_message_payload)
      )
    :effect
      (and
        (settlement_payload_assembled ?settlement_message_payload)
        (payload_bound_origin_channel ?settlement_message_payload ?origin_settlement_channel_candidate)
        (payload_bound_destination_channel ?settlement_message_payload ?destination_settlement_channel_candidate)
        (payload_origin_acknowledged ?settlement_message_payload)
        (payload_destination_acknowledged ?settlement_message_payload)
        (not
          (settlement_payload_available ?settlement_message_payload)
        )
      )
  )
  (:action mark_settlement_payload_dispatched
    :parameters (?settlement_message_payload - settlement_message_payload ?originating_payment_leg - originating_payment_leg ?validation_resource - validation_resource)
    :precondition
      (and
        (settlement_payload_assembled ?settlement_message_payload)
        (originating_leg_ready ?originating_payment_leg)
        (assigned_validation_resource ?originating_payment_leg ?validation_resource)
        (not
          (payload_dispatched_to_channel ?settlement_message_payload)
        )
      )
    :effect (payload_dispatched_to_channel ?settlement_message_payload)
  )
  (:action ingest_supporting_document_into_case_and_bind_to_payload
    :parameters (?reconciliation_case - reconciliation_case ?supporting_document - supporting_document ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (released_for_processing ?reconciliation_case)
        (case_linked_to_payload ?reconciliation_case ?settlement_message_payload)
        (case_has_supporting_document ?reconciliation_case ?supporting_document)
        (supporting_document_available ?supporting_document)
        (settlement_payload_assembled ?settlement_message_payload)
        (payload_dispatched_to_channel ?settlement_message_payload)
        (not
          (supporting_document_ingested ?supporting_document)
        )
      )
    :effect
      (and
        (supporting_document_ingested ?supporting_document)
        (supporting_document_bound_to_payload ?supporting_document ?settlement_message_payload)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action verify_supporting_document_and_mark_case
    :parameters (?reconciliation_case - reconciliation_case ?supporting_document - supporting_document ?settlement_message_payload - settlement_message_payload ?validation_resource - validation_resource)
    :precondition
      (and
        (released_for_processing ?reconciliation_case)
        (case_has_supporting_document ?reconciliation_case ?supporting_document)
        (supporting_document_ingested ?supporting_document)
        (supporting_document_bound_to_payload ?supporting_document ?settlement_message_payload)
        (assigned_validation_resource ?reconciliation_case ?validation_resource)
        (not
          (payload_origin_acknowledged ?settlement_message_payload)
        )
        (not
          (case_document_verified ?reconciliation_case)
        )
      )
    :effect (case_document_verified ?reconciliation_case)
  )
  (:action attach_partner_profile_to_case
    :parameters (?reconciliation_case - reconciliation_case ?partner_profile - partner_profile)
    :precondition
      (and
        (released_for_processing ?reconciliation_case)
        (partner_profile_available ?partner_profile)
        (not
          (partner_profile_attached ?reconciliation_case)
        )
      )
    :effect
      (and
        (partner_profile_attached ?reconciliation_case)
        (partner_profile_bound_to_case ?reconciliation_case ?partner_profile)
        (not
          (partner_profile_available ?partner_profile)
        )
      )
  )
  (:action process_partner_profile_with_document_for_case
    :parameters (?reconciliation_case - reconciliation_case ?supporting_document - supporting_document ?settlement_message_payload - settlement_message_payload ?validation_resource - validation_resource ?partner_profile - partner_profile)
    :precondition
      (and
        (released_for_processing ?reconciliation_case)
        (case_has_supporting_document ?reconciliation_case ?supporting_document)
        (supporting_document_ingested ?supporting_document)
        (supporting_document_bound_to_payload ?supporting_document ?settlement_message_payload)
        (assigned_validation_resource ?reconciliation_case ?validation_resource)
        (payload_origin_acknowledged ?settlement_message_payload)
        (partner_profile_attached ?reconciliation_case)
        (partner_profile_bound_to_case ?reconciliation_case ?partner_profile)
        (not
          (case_document_verified ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_document_verified ?reconciliation_case)
        (partner_profile_verified ?reconciliation_case)
      )
  )
  (:action prepare_case_authorization_with_token_and_document
    :parameters (?reconciliation_case - reconciliation_case ?settlement_authorization_token - settlement_authorization_token ?authorization_resource - authorization_resource ?supporting_document - supporting_document ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (case_document_verified ?reconciliation_case)
        (settlement_authorization_bound_to_case ?reconciliation_case ?settlement_authorization_token)
        (assigned_authorization_resource ?reconciliation_case ?authorization_resource)
        (case_has_supporting_document ?reconciliation_case ?supporting_document)
        (supporting_document_bound_to_payload ?supporting_document ?settlement_message_payload)
        (not
          (payload_destination_acknowledged ?settlement_message_payload)
        )
        (not
          (case_authorization_prepared ?reconciliation_case)
        )
      )
    :effect (case_authorization_prepared ?reconciliation_case)
  )
  (:action prepare_case_authorization_with_token_and_document_variant
    :parameters (?reconciliation_case - reconciliation_case ?settlement_authorization_token - settlement_authorization_token ?authorization_resource - authorization_resource ?supporting_document - supporting_document ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (case_document_verified ?reconciliation_case)
        (settlement_authorization_bound_to_case ?reconciliation_case ?settlement_authorization_token)
        (assigned_authorization_resource ?reconciliation_case ?authorization_resource)
        (case_has_supporting_document ?reconciliation_case ?supporting_document)
        (supporting_document_bound_to_payload ?supporting_document ?settlement_message_payload)
        (payload_destination_acknowledged ?settlement_message_payload)
        (not
          (case_authorization_prepared ?reconciliation_case)
        )
      )
    :effect (case_authorization_prepared ?reconciliation_case)
  )
  (:action authorize_case_and_mark_ready
    :parameters (?reconciliation_case - reconciliation_case ?audit_evidence_record - audit_evidence_record ?supporting_document - supporting_document ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (case_authorization_prepared ?reconciliation_case)
        (audit_evidence_bound_to_case ?reconciliation_case ?audit_evidence_record)
        (case_has_supporting_document ?reconciliation_case ?supporting_document)
        (supporting_document_bound_to_payload ?supporting_document ?settlement_message_payload)
        (not
          (payload_origin_acknowledged ?settlement_message_payload)
        )
        (not
          (payload_destination_acknowledged ?settlement_message_payload)
        )
        (not
          (case_ready_for_execution ?reconciliation_case)
        )
      )
    :effect (case_ready_for_execution ?reconciliation_case)
  )
  (:action authorize_case_and_set_priority
    :parameters (?reconciliation_case - reconciliation_case ?audit_evidence_record - audit_evidence_record ?supporting_document - supporting_document ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (case_authorization_prepared ?reconciliation_case)
        (audit_evidence_bound_to_case ?reconciliation_case ?audit_evidence_record)
        (case_has_supporting_document ?reconciliation_case ?supporting_document)
        (supporting_document_bound_to_payload ?supporting_document ?settlement_message_payload)
        (payload_origin_acknowledged ?settlement_message_payload)
        (not
          (payload_destination_acknowledged ?settlement_message_payload)
        )
        (not
          (case_ready_for_execution ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_ready_for_execution ?reconciliation_case)
        (case_priority_attached ?reconciliation_case)
      )
  )
  (:action authorize_case_and_set_priority_variant
    :parameters (?reconciliation_case - reconciliation_case ?audit_evidence_record - audit_evidence_record ?supporting_document - supporting_document ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (case_authorization_prepared ?reconciliation_case)
        (audit_evidence_bound_to_case ?reconciliation_case ?audit_evidence_record)
        (case_has_supporting_document ?reconciliation_case ?supporting_document)
        (supporting_document_bound_to_payload ?supporting_document ?settlement_message_payload)
        (not
          (payload_origin_acknowledged ?settlement_message_payload)
        )
        (payload_destination_acknowledged ?settlement_message_payload)
        (not
          (case_ready_for_execution ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_ready_for_execution ?reconciliation_case)
        (case_priority_attached ?reconciliation_case)
      )
  )
  (:action authorize_case_and_set_priority_alternate
    :parameters (?reconciliation_case - reconciliation_case ?audit_evidence_record - audit_evidence_record ?supporting_document - supporting_document ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (case_authorization_prepared ?reconciliation_case)
        (audit_evidence_bound_to_case ?reconciliation_case ?audit_evidence_record)
        (case_has_supporting_document ?reconciliation_case ?supporting_document)
        (supporting_document_bound_to_payload ?supporting_document ?settlement_message_payload)
        (payload_origin_acknowledged ?settlement_message_payload)
        (payload_destination_acknowledged ?settlement_message_payload)
        (not
          (case_ready_for_execution ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_ready_for_execution ?reconciliation_case)
        (case_priority_attached ?reconciliation_case)
      )
  )
  (:action mark_case_execution_ready
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_ready_for_execution ?reconciliation_case)
        (not
          (case_priority_attached ?reconciliation_case)
        )
        (not
          (case_execution_marked ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_execution_marked ?reconciliation_case)
        (ready_for_confirmation ?reconciliation_case)
      )
  )
  (:action attach_execution_priority_to_case
    :parameters (?reconciliation_case - reconciliation_case ?execution_priority_profile - execution_priority_profile)
    :precondition
      (and
        (case_ready_for_execution ?reconciliation_case)
        (case_priority_attached ?reconciliation_case)
        (execution_priority_available ?execution_priority_profile)
      )
    :effect
      (and
        (execution_priority_bound_to_case ?reconciliation_case ?execution_priority_profile)
        (not
          (execution_priority_available ?execution_priority_profile)
        )
      )
  )
  (:action perform_final_case_checks
    :parameters (?reconciliation_case - reconciliation_case ?originating_payment_leg - originating_payment_leg ?beneficiary_payment_leg - beneficiary_payment_leg ?validation_resource - validation_resource ?execution_priority_profile - execution_priority_profile)
    :precondition
      (and
        (case_ready_for_execution ?reconciliation_case)
        (case_priority_attached ?reconciliation_case)
        (execution_priority_bound_to_case ?reconciliation_case ?execution_priority_profile)
        (case_has_origin_leg ?reconciliation_case ?originating_payment_leg)
        (case_has_beneficiary_leg ?reconciliation_case ?beneficiary_payment_leg)
        (origin_leg_confirmed ?originating_payment_leg)
        (beneficiary_leg_confirmed ?beneficiary_payment_leg)
        (assigned_validation_resource ?reconciliation_case ?validation_resource)
        (not
          (case_execution_verified ?reconciliation_case)
        )
      )
    :effect (case_execution_verified ?reconciliation_case)
  )
  (:action complete_case_finalization
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (case_ready_for_execution ?reconciliation_case)
        (case_execution_verified ?reconciliation_case)
        (not
          (case_execution_marked ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_execution_marked ?reconciliation_case)
        (ready_for_confirmation ?reconciliation_case)
      )
  )
  (:action request_external_approval_with_handle
    :parameters (?reconciliation_case - reconciliation_case ?external_approval_handle - external_approval_handle ?validation_resource - validation_resource)
    :precondition
      (and
        (released_for_processing ?reconciliation_case)
        (assigned_validation_resource ?reconciliation_case ?validation_resource)
        (external_approval_handle_available ?external_approval_handle)
        (external_approval_bound_to_case ?reconciliation_case ?external_approval_handle)
        (not
          (case_external_approval_requested ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_external_approval_requested ?reconciliation_case)
        (not
          (external_approval_handle_available ?external_approval_handle)
        )
      )
  )
  (:action start_external_approval_review
    :parameters (?reconciliation_case - reconciliation_case ?authorization_resource - authorization_resource)
    :precondition
      (and
        (case_external_approval_requested ?reconciliation_case)
        (assigned_authorization_resource ?reconciliation_case ?authorization_resource)
        (not
          (external_approval_in_progress ?reconciliation_case)
        )
      )
    :effect (external_approval_in_progress ?reconciliation_case)
  )
  (:action apply_external_approval_and_mark
    :parameters (?reconciliation_case - reconciliation_case ?audit_evidence_record - audit_evidence_record)
    :precondition
      (and
        (external_approval_in_progress ?reconciliation_case)
        (audit_evidence_bound_to_case ?reconciliation_case ?audit_evidence_record)
        (not
          (external_approval_obtained ?reconciliation_case)
        )
      )
    :effect (external_approval_obtained ?reconciliation_case)
  )
  (:action finalize_after_external_approval
    :parameters (?reconciliation_case - reconciliation_case)
    :precondition
      (and
        (external_approval_obtained ?reconciliation_case)
        (not
          (case_execution_marked ?reconciliation_case)
        )
      )
    :effect
      (and
        (case_execution_marked ?reconciliation_case)
        (ready_for_confirmation ?reconciliation_case)
      )
  )
  (:action record_origin_leg_confirmation
    :parameters (?originating_payment_leg - originating_payment_leg ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (originating_leg_ready ?originating_payment_leg)
        (origin_leg_confirmed ?originating_payment_leg)
        (settlement_payload_assembled ?settlement_message_payload)
        (payload_dispatched_to_channel ?settlement_message_payload)
        (not
          (ready_for_confirmation ?originating_payment_leg)
        )
      )
    :effect (ready_for_confirmation ?originating_payment_leg)
  )
  (:action record_beneficiary_leg_confirmation
    :parameters (?beneficiary_payment_leg - beneficiary_payment_leg ?settlement_message_payload - settlement_message_payload)
    :precondition
      (and
        (beneficiary_leg_ready ?beneficiary_payment_leg)
        (beneficiary_leg_confirmed ?beneficiary_payment_leg)
        (settlement_payload_assembled ?settlement_message_payload)
        (payload_dispatched_to_channel ?settlement_message_payload)
        (not
          (ready_for_confirmation ?beneficiary_payment_leg)
        )
      )
    :effect (ready_for_confirmation ?beneficiary_payment_leg)
  )
  (:action assign_confirmation_token_to_instruction
    :parameters (?processable_item - processable_item ?confirmation_token - confirmation_token ?validation_resource - validation_resource)
    :precondition
      (and
        (ready_for_confirmation ?processable_item)
        (assigned_validation_resource ?processable_item ?validation_resource)
        (confirmation_token_available ?confirmation_token)
        (not
          (confirmation_recorded ?processable_item)
        )
      )
    :effect
      (and
        (confirmation_recorded ?processable_item)
        (confirmation_token_assigned ?processable_item ?confirmation_token)
        (not
          (confirmation_token_available ?confirmation_token)
        )
      )
  )
  (:action apply_confirmation_token_to_origin_leg_and_release_routing
    :parameters (?originating_payment_leg - originating_payment_leg ?routing_candidate - routing_candidate ?confirmation_token - confirmation_token)
    :precondition
      (and
        (confirmation_recorded ?originating_payment_leg)
        (assigned_routing_candidate ?originating_payment_leg ?routing_candidate)
        (confirmation_token_assigned ?originating_payment_leg ?confirmation_token)
        (not
          (settlement_confirmed ?originating_payment_leg)
        )
      )
    :effect
      (and
        (settlement_confirmed ?originating_payment_leg)
        (routing_candidate_available ?routing_candidate)
        (confirmation_token_available ?confirmation_token)
      )
  )
  (:action apply_confirmation_token_to_beneficiary_leg_and_release_routing
    :parameters (?beneficiary_payment_leg - beneficiary_payment_leg ?routing_candidate - routing_candidate ?confirmation_token - confirmation_token)
    :precondition
      (and
        (confirmation_recorded ?beneficiary_payment_leg)
        (assigned_routing_candidate ?beneficiary_payment_leg ?routing_candidate)
        (confirmation_token_assigned ?beneficiary_payment_leg ?confirmation_token)
        (not
          (settlement_confirmed ?beneficiary_payment_leg)
        )
      )
    :effect
      (and
        (settlement_confirmed ?beneficiary_payment_leg)
        (routing_candidate_available ?routing_candidate)
        (confirmation_token_available ?confirmation_token)
      )
  )
  (:action apply_confirmation_token_to_case_and_release_routing_candidate
    :parameters (?reconciliation_case - reconciliation_case ?routing_candidate - routing_candidate ?confirmation_token - confirmation_token)
    :precondition
      (and
        (confirmation_recorded ?reconciliation_case)
        (assigned_routing_candidate ?reconciliation_case ?routing_candidate)
        (confirmation_token_assigned ?reconciliation_case ?confirmation_token)
        (not
          (settlement_confirmed ?reconciliation_case)
        )
      )
    :effect
      (and
        (settlement_confirmed ?reconciliation_case)
        (routing_candidate_available ?routing_candidate)
        (confirmation_token_available ?confirmation_token)
      )
  )
)

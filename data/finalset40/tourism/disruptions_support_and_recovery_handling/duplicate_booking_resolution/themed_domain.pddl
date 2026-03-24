(define (domain tourism_duplicate_booking_resolution)
  (:requirements :strips :typing :negative-preconditions)
  (:types generic_entity - object actor_or_resource - generic_entity system_resource - generic_entity supplier_entity - generic_entity booking_identifier - generic_entity duplicate_booking_case - booking_identifier communication_channel - actor_or_resource verification_document - actor_or_resource staff_member - actor_or_resource escalation_reason - actor_or_resource approval_artifact - actor_or_resource payment_instrument - actor_or_resource compensation_option - actor_or_resource escalation_template - actor_or_resource remediation_option - system_resource supporting_document - system_resource vendor_contact - system_resource supplier_interface_primary - supplier_entity supplier_interface_duplicate - supplier_entity resolution_ticket - supplier_entity booking_record_supertype - duplicate_booking_case case_workflow_supertype - duplicate_booking_case primary_booking_record - booking_record_supertype duplicate_booking_record - booking_record_supertype resolution_workflow_instance - case_workflow_supertype)

  (:predicates
    (entity_status_open ?duplicate_booking_case - duplicate_booking_case)
    (entity_status_verified ?duplicate_booking_case - duplicate_booking_case)
    (entity_status_channel_allocated ?duplicate_booking_case - duplicate_booking_case)
    (entity_status_closed ?duplicate_booking_case - duplicate_booking_case)
    (entity_status_approved_for_settlement ?duplicate_booking_case - duplicate_booking_case)
    (entity_status_settlement_initiated ?duplicate_booking_case - duplicate_booking_case)
    (channel_available ?communication_channel - communication_channel)
    (case_channel_assigned ?duplicate_booking_case - duplicate_booking_case ?communication_channel - communication_channel)
    (verification_document_available ?verification_document - verification_document)
    (entity_status_document_linked ?duplicate_booking_case - duplicate_booking_case ?verification_document - verification_document)
    (staff_available ?staff_member - staff_member)
    (entity_status_assigned_staff ?duplicate_booking_case - duplicate_booking_case ?staff_member - staff_member)
    (remediation_option_available ?remediation_option - remediation_option)
    (primary_booking_remediation_option_linked ?primary_booking_record - primary_booking_record ?remediation_option - remediation_option)
    (duplicate_booking_remediation_option_linked ?duplicate_booking_record - duplicate_booking_record ?remediation_option - remediation_option)
    (primary_booking_supplier_interface_linked ?primary_booking_record - primary_booking_record ?supplier_interface_primary - supplier_interface_primary)
    (supplier_interface_primary_confirmed ?supplier_interface_primary - supplier_interface_primary)
    (supplier_interface_primary_requires_reconciliation ?supplier_interface_primary - supplier_interface_primary)
    (primary_booking_ready_for_ticket ?primary_booking_record - primary_booking_record)
    (duplicate_booking_supplier_interface_linked ?duplicate_booking_record - duplicate_booking_record ?supplier_interface_duplicate - supplier_interface_duplicate)
    (supplier_interface_duplicate_confirmed ?supplier_interface_duplicate - supplier_interface_duplicate)
    (supplier_interface_duplicate_requires_reconciliation ?supplier_interface_duplicate - supplier_interface_duplicate)
    (duplicate_booking_ready_for_ticket ?duplicate_booking_record - duplicate_booking_record)
    (resolution_ticket_available ?resolution_ticket - resolution_ticket)
    (resolution_ticket_active ?resolution_ticket - resolution_ticket)
    (ticket_linked_supplier_interface_primary ?resolution_ticket - resolution_ticket ?supplier_interface_primary - supplier_interface_primary)
    (ticket_linked_supplier_interface_duplicate ?resolution_ticket - resolution_ticket ?supplier_interface_duplicate - supplier_interface_duplicate)
    (ticket_requires_primary_action ?resolution_ticket - resolution_ticket)
    (ticket_requires_duplicate_action ?resolution_ticket - resolution_ticket)
    (ticket_primary_acknowledged ?resolution_ticket - resolution_ticket)
    (workflow_linked_primary_booking ?resolution_workflow_instance - resolution_workflow_instance ?primary_booking_record - primary_booking_record)
    (workflow_linked_duplicate_booking ?resolution_workflow_instance - resolution_workflow_instance ?duplicate_booking_record - duplicate_booking_record)
    (workflow_attached_ticket ?resolution_workflow_instance - resolution_workflow_instance ?resolution_ticket - resolution_ticket)
    (supporting_document_available ?supporting_document - supporting_document)
    (workflow_has_supporting_document ?resolution_workflow_instance - resolution_workflow_instance ?supporting_document - supporting_document)
    (supporting_document_assigned ?supporting_document - supporting_document)
    (supporting_document_attached_to_ticket ?supporting_document - supporting_document ?resolution_ticket - resolution_ticket)
    (workflow_ready_for_enrichment ?resolution_workflow_instance - resolution_workflow_instance)
    (workflow_escalation_prepared ?resolution_workflow_instance - resolution_workflow_instance)
    (workflow_final_review_ready ?resolution_workflow_instance - resolution_workflow_instance)
    (workflow_has_escalation_reason ?resolution_workflow_instance - resolution_workflow_instance)
    (workflow_vendor_contact_attached ?resolution_workflow_instance - resolution_workflow_instance)
    (workflow_requires_approval ?resolution_workflow_instance - resolution_workflow_instance)
    (workflow_ready_for_settlement ?resolution_workflow_instance - resolution_workflow_instance)
    (vendor_contact_available ?vendor_contact - vendor_contact)
    (workflow_vendor_contact_linked ?resolution_workflow_instance - resolution_workflow_instance ?vendor_contact - vendor_contact)
    (workflow_vendor_engagement_initiated ?resolution_workflow_instance - resolution_workflow_instance)
    (workflow_vendor_engagement_in_progress ?resolution_workflow_instance - resolution_workflow_instance)
    (workflow_vendor_response_received ?resolution_workflow_instance - resolution_workflow_instance)
    (escalation_reason_available ?escalation_reason - escalation_reason)
    (workflow_escalation_reason_linked ?resolution_workflow_instance - resolution_workflow_instance ?escalation_reason - escalation_reason)
    (approval_artifact_available ?approval_artifact - approval_artifact)
    (workflow_approval_artifact_linked ?resolution_workflow_instance - resolution_workflow_instance ?approval_artifact - approval_artifact)
    (compensation_option_available ?compensation_option - compensation_option)
    (workflow_compensation_option_linked ?resolution_workflow_instance - resolution_workflow_instance ?compensation_option - compensation_option)
    (escalation_template_available ?escalation_template - escalation_template)
    (workflow_escalation_template_linked ?resolution_workflow_instance - resolution_workflow_instance ?escalation_template - escalation_template)
    (payment_instrument_available ?payment_instrument - payment_instrument)
    (entity_status_payment_instrument_linked ?duplicate_booking_case - duplicate_booking_case ?payment_instrument - payment_instrument)
    (primary_booking_ticket_ready ?primary_booking_record - primary_booking_record)
    (duplicate_booking_ticket_ready ?duplicate_booking_record - duplicate_booking_record)
    (workflow_closed ?resolution_workflow_instance - resolution_workflow_instance)
  )
  (:action create_duplicate_booking_case
    :parameters (?duplicate_booking_case - duplicate_booking_case)
    :precondition
      (and
        (not
          (entity_status_open ?duplicate_booking_case)
        )
        (not
          (entity_status_closed ?duplicate_booking_case)
        )
      )
    :effect (entity_status_open ?duplicate_booking_case)
  )
  (:action allocate_communication_channel_to_case
    :parameters (?duplicate_booking_case - duplicate_booking_case ?communication_channel - communication_channel)
    :precondition
      (and
        (entity_status_open ?duplicate_booking_case)
        (not
          (entity_status_channel_allocated ?duplicate_booking_case)
        )
        (channel_available ?communication_channel)
      )
    :effect
      (and
        (entity_status_channel_allocated ?duplicate_booking_case)
        (case_channel_assigned ?duplicate_booking_case ?communication_channel)
        (not
          (channel_available ?communication_channel)
        )
      )
  )
  (:action ingest_verification_document_to_case
    :parameters (?duplicate_booking_case - duplicate_booking_case ?verification_document - verification_document)
    :precondition
      (and
        (entity_status_open ?duplicate_booking_case)
        (entity_status_channel_allocated ?duplicate_booking_case)
        (verification_document_available ?verification_document)
      )
    :effect
      (and
        (entity_status_document_linked ?duplicate_booking_case ?verification_document)
        (not
          (verification_document_available ?verification_document)
        )
      )
  )
  (:action confirm_case_verification
    :parameters (?duplicate_booking_case - duplicate_booking_case ?verification_document - verification_document)
    :precondition
      (and
        (entity_status_open ?duplicate_booking_case)
        (entity_status_channel_allocated ?duplicate_booking_case)
        (entity_status_document_linked ?duplicate_booking_case ?verification_document)
        (not
          (entity_status_verified ?duplicate_booking_case)
        )
      )
    :effect (entity_status_verified ?duplicate_booking_case)
  )
  (:action unassign_verification_document_from_case
    :parameters (?duplicate_booking_case - duplicate_booking_case ?verification_document - verification_document)
    :precondition
      (and
        (entity_status_document_linked ?duplicate_booking_case ?verification_document)
      )
    :effect
      (and
        (verification_document_available ?verification_document)
        (not
          (entity_status_document_linked ?duplicate_booking_case ?verification_document)
        )
      )
  )
  (:action assign_staff_to_case
    :parameters (?duplicate_booking_case - duplicate_booking_case ?staff_member - staff_member)
    :precondition
      (and
        (entity_status_verified ?duplicate_booking_case)
        (staff_available ?staff_member)
      )
    :effect
      (and
        (entity_status_assigned_staff ?duplicate_booking_case ?staff_member)
        (not
          (staff_available ?staff_member)
        )
      )
  )
  (:action release_staff_from_case
    :parameters (?duplicate_booking_case - duplicate_booking_case ?staff_member - staff_member)
    :precondition
      (and
        (entity_status_assigned_staff ?duplicate_booking_case ?staff_member)
      )
    :effect
      (and
        (staff_available ?staff_member)
        (not
          (entity_status_assigned_staff ?duplicate_booking_case ?staff_member)
        )
      )
  )
  (:action link_compensation_option_to_workflow
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?compensation_option - compensation_option)
    :precondition
      (and
        (entity_status_verified ?resolution_workflow_instance)
        (compensation_option_available ?compensation_option)
      )
    :effect
      (and
        (workflow_compensation_option_linked ?resolution_workflow_instance ?compensation_option)
        (not
          (compensation_option_available ?compensation_option)
        )
      )
  )
  (:action unlink_compensation_option_from_workflow
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?compensation_option - compensation_option)
    :precondition
      (and
        (workflow_compensation_option_linked ?resolution_workflow_instance ?compensation_option)
      )
    :effect
      (and
        (compensation_option_available ?compensation_option)
        (not
          (workflow_compensation_option_linked ?resolution_workflow_instance ?compensation_option)
        )
      )
  )
  (:action link_escalation_template_to_workflow
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?escalation_template - escalation_template)
    :precondition
      (and
        (entity_status_verified ?resolution_workflow_instance)
        (escalation_template_available ?escalation_template)
      )
    :effect
      (and
        (workflow_escalation_template_linked ?resolution_workflow_instance ?escalation_template)
        (not
          (escalation_template_available ?escalation_template)
        )
      )
  )
  (:action unlink_escalation_template_from_workflow
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?escalation_template - escalation_template)
    :precondition
      (and
        (workflow_escalation_template_linked ?resolution_workflow_instance ?escalation_template)
      )
    :effect
      (and
        (escalation_template_available ?escalation_template)
        (not
          (workflow_escalation_template_linked ?resolution_workflow_instance ?escalation_template)
        )
      )
  )
  (:action assess_primary_supplier_interface
    :parameters (?primary_booking_record - primary_booking_record ?supplier_interface_primary - supplier_interface_primary ?verification_document - verification_document)
    :precondition
      (and
        (entity_status_verified ?primary_booking_record)
        (entity_status_document_linked ?primary_booking_record ?verification_document)
        (primary_booking_supplier_interface_linked ?primary_booking_record ?supplier_interface_primary)
        (not
          (supplier_interface_primary_confirmed ?supplier_interface_primary)
        )
        (not
          (supplier_interface_primary_requires_reconciliation ?supplier_interface_primary)
        )
      )
    :effect (supplier_interface_primary_confirmed ?supplier_interface_primary)
  )
  (:action confirm_primary_booking_and_mark_ready
    :parameters (?primary_booking_record - primary_booking_record ?supplier_interface_primary - supplier_interface_primary ?staff_member - staff_member)
    :precondition
      (and
        (entity_status_verified ?primary_booking_record)
        (entity_status_assigned_staff ?primary_booking_record ?staff_member)
        (primary_booking_supplier_interface_linked ?primary_booking_record ?supplier_interface_primary)
        (supplier_interface_primary_confirmed ?supplier_interface_primary)
        (not
          (primary_booking_ticket_ready ?primary_booking_record)
        )
      )
    :effect
      (and
        (primary_booking_ticket_ready ?primary_booking_record)
        (primary_booking_ready_for_ticket ?primary_booking_record)
      )
  )
  (:action propose_remediation_option_primary
    :parameters (?primary_booking_record - primary_booking_record ?supplier_interface_primary - supplier_interface_primary ?remediation_option - remediation_option)
    :precondition
      (and
        (entity_status_verified ?primary_booking_record)
        (primary_booking_supplier_interface_linked ?primary_booking_record ?supplier_interface_primary)
        (remediation_option_available ?remediation_option)
        (not
          (primary_booking_ticket_ready ?primary_booking_record)
        )
      )
    :effect
      (and
        (supplier_interface_primary_requires_reconciliation ?supplier_interface_primary)
        (primary_booking_ticket_ready ?primary_booking_record)
        (primary_booking_remediation_option_linked ?primary_booking_record ?remediation_option)
        (not
          (remediation_option_available ?remediation_option)
        )
      )
  )
  (:action accept_primary_proposed_remediation_option
    :parameters (?primary_booking_record - primary_booking_record ?supplier_interface_primary - supplier_interface_primary ?verification_document - verification_document ?remediation_option - remediation_option)
    :precondition
      (and
        (entity_status_verified ?primary_booking_record)
        (entity_status_document_linked ?primary_booking_record ?verification_document)
        (primary_booking_supplier_interface_linked ?primary_booking_record ?supplier_interface_primary)
        (supplier_interface_primary_requires_reconciliation ?supplier_interface_primary)
        (primary_booking_remediation_option_linked ?primary_booking_record ?remediation_option)
        (not
          (primary_booking_ready_for_ticket ?primary_booking_record)
        )
      )
    :effect
      (and
        (supplier_interface_primary_confirmed ?supplier_interface_primary)
        (primary_booking_ready_for_ticket ?primary_booking_record)
        (remediation_option_available ?remediation_option)
        (not
          (primary_booking_remediation_option_linked ?primary_booking_record ?remediation_option)
        )
      )
  )
  (:action assess_duplicate_supplier_interface
    :parameters (?duplicate_booking_record - duplicate_booking_record ?supplier_interface_duplicate - supplier_interface_duplicate ?verification_document - verification_document)
    :precondition
      (and
        (entity_status_verified ?duplicate_booking_record)
        (entity_status_document_linked ?duplicate_booking_record ?verification_document)
        (duplicate_booking_supplier_interface_linked ?duplicate_booking_record ?supplier_interface_duplicate)
        (not
          (supplier_interface_duplicate_confirmed ?supplier_interface_duplicate)
        )
        (not
          (supplier_interface_duplicate_requires_reconciliation ?supplier_interface_duplicate)
        )
      )
    :effect (supplier_interface_duplicate_confirmed ?supplier_interface_duplicate)
  )
  (:action assign_staff_after_duplicate_confirmed
    :parameters (?duplicate_booking_record - duplicate_booking_record ?supplier_interface_duplicate - supplier_interface_duplicate ?staff_member - staff_member)
    :precondition
      (and
        (entity_status_verified ?duplicate_booking_record)
        (entity_status_assigned_staff ?duplicate_booking_record ?staff_member)
        (duplicate_booking_supplier_interface_linked ?duplicate_booking_record ?supplier_interface_duplicate)
        (supplier_interface_duplicate_confirmed ?supplier_interface_duplicate)
        (not
          (duplicate_booking_ticket_ready ?duplicate_booking_record)
        )
      )
    :effect
      (and
        (duplicate_booking_ticket_ready ?duplicate_booking_record)
        (duplicate_booking_ready_for_ticket ?duplicate_booking_record)
      )
  )
  (:action propose_remediation_option_duplicate
    :parameters (?duplicate_booking_record - duplicate_booking_record ?supplier_interface_duplicate - supplier_interface_duplicate ?remediation_option - remediation_option)
    :precondition
      (and
        (entity_status_verified ?duplicate_booking_record)
        (duplicate_booking_supplier_interface_linked ?duplicate_booking_record ?supplier_interface_duplicate)
        (remediation_option_available ?remediation_option)
        (not
          (duplicate_booking_ticket_ready ?duplicate_booking_record)
        )
      )
    :effect
      (and
        (supplier_interface_duplicate_requires_reconciliation ?supplier_interface_duplicate)
        (duplicate_booking_ticket_ready ?duplicate_booking_record)
        (duplicate_booking_remediation_option_linked ?duplicate_booking_record ?remediation_option)
        (not
          (remediation_option_available ?remediation_option)
        )
      )
  )
  (:action accept_duplicate_proposed_remediation_option
    :parameters (?duplicate_booking_record - duplicate_booking_record ?supplier_interface_duplicate - supplier_interface_duplicate ?verification_document - verification_document ?remediation_option - remediation_option)
    :precondition
      (and
        (entity_status_verified ?duplicate_booking_record)
        (entity_status_document_linked ?duplicate_booking_record ?verification_document)
        (duplicate_booking_supplier_interface_linked ?duplicate_booking_record ?supplier_interface_duplicate)
        (supplier_interface_duplicate_requires_reconciliation ?supplier_interface_duplicate)
        (duplicate_booking_remediation_option_linked ?duplicate_booking_record ?remediation_option)
        (not
          (duplicate_booking_ready_for_ticket ?duplicate_booking_record)
        )
      )
    :effect
      (and
        (supplier_interface_duplicate_confirmed ?supplier_interface_duplicate)
        (duplicate_booking_ready_for_ticket ?duplicate_booking_record)
        (remediation_option_available ?remediation_option)
        (not
          (duplicate_booking_remediation_option_linked ?duplicate_booking_record ?remediation_option)
        )
      )
  )
  (:action create_resolution_ticket_standard
    :parameters (?primary_booking_record - primary_booking_record ?duplicate_booking_record - duplicate_booking_record ?supplier_interface_primary - supplier_interface_primary ?supplier_interface_duplicate - supplier_interface_duplicate ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (primary_booking_ticket_ready ?primary_booking_record)
        (duplicate_booking_ticket_ready ?duplicate_booking_record)
        (primary_booking_supplier_interface_linked ?primary_booking_record ?supplier_interface_primary)
        (duplicate_booking_supplier_interface_linked ?duplicate_booking_record ?supplier_interface_duplicate)
        (supplier_interface_primary_confirmed ?supplier_interface_primary)
        (supplier_interface_duplicate_confirmed ?supplier_interface_duplicate)
        (primary_booking_ready_for_ticket ?primary_booking_record)
        (duplicate_booking_ready_for_ticket ?duplicate_booking_record)
        (resolution_ticket_available ?resolution_ticket)
      )
    :effect
      (and
        (resolution_ticket_active ?resolution_ticket)
        (ticket_linked_supplier_interface_primary ?resolution_ticket ?supplier_interface_primary)
        (ticket_linked_supplier_interface_duplicate ?resolution_ticket ?supplier_interface_duplicate)
        (not
          (resolution_ticket_available ?resolution_ticket)
        )
      )
  )
  (:action create_resolution_ticket_primary_requires_action
    :parameters (?primary_booking_record - primary_booking_record ?duplicate_booking_record - duplicate_booking_record ?supplier_interface_primary - supplier_interface_primary ?supplier_interface_duplicate - supplier_interface_duplicate ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (primary_booking_ticket_ready ?primary_booking_record)
        (duplicate_booking_ticket_ready ?duplicate_booking_record)
        (primary_booking_supplier_interface_linked ?primary_booking_record ?supplier_interface_primary)
        (duplicate_booking_supplier_interface_linked ?duplicate_booking_record ?supplier_interface_duplicate)
        (supplier_interface_primary_requires_reconciliation ?supplier_interface_primary)
        (supplier_interface_duplicate_confirmed ?supplier_interface_duplicate)
        (not
          (primary_booking_ready_for_ticket ?primary_booking_record)
        )
        (duplicate_booking_ready_for_ticket ?duplicate_booking_record)
        (resolution_ticket_available ?resolution_ticket)
      )
    :effect
      (and
        (resolution_ticket_active ?resolution_ticket)
        (ticket_linked_supplier_interface_primary ?resolution_ticket ?supplier_interface_primary)
        (ticket_linked_supplier_interface_duplicate ?resolution_ticket ?supplier_interface_duplicate)
        (ticket_requires_primary_action ?resolution_ticket)
        (not
          (resolution_ticket_available ?resolution_ticket)
        )
      )
  )
  (:action create_resolution_ticket_duplicate_requires_action
    :parameters (?primary_booking_record - primary_booking_record ?duplicate_booking_record - duplicate_booking_record ?supplier_interface_primary - supplier_interface_primary ?supplier_interface_duplicate - supplier_interface_duplicate ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (primary_booking_ticket_ready ?primary_booking_record)
        (duplicate_booking_ticket_ready ?duplicate_booking_record)
        (primary_booking_supplier_interface_linked ?primary_booking_record ?supplier_interface_primary)
        (duplicate_booking_supplier_interface_linked ?duplicate_booking_record ?supplier_interface_duplicate)
        (supplier_interface_primary_confirmed ?supplier_interface_primary)
        (supplier_interface_duplicate_requires_reconciliation ?supplier_interface_duplicate)
        (primary_booking_ready_for_ticket ?primary_booking_record)
        (not
          (duplicate_booking_ready_for_ticket ?duplicate_booking_record)
        )
        (resolution_ticket_available ?resolution_ticket)
      )
    :effect
      (and
        (resolution_ticket_active ?resolution_ticket)
        (ticket_linked_supplier_interface_primary ?resolution_ticket ?supplier_interface_primary)
        (ticket_linked_supplier_interface_duplicate ?resolution_ticket ?supplier_interface_duplicate)
        (ticket_requires_duplicate_action ?resolution_ticket)
        (not
          (resolution_ticket_available ?resolution_ticket)
        )
      )
  )
  (:action create_resolution_ticket_both_require_action
    :parameters (?primary_booking_record - primary_booking_record ?duplicate_booking_record - duplicate_booking_record ?supplier_interface_primary - supplier_interface_primary ?supplier_interface_duplicate - supplier_interface_duplicate ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (primary_booking_ticket_ready ?primary_booking_record)
        (duplicate_booking_ticket_ready ?duplicate_booking_record)
        (primary_booking_supplier_interface_linked ?primary_booking_record ?supplier_interface_primary)
        (duplicate_booking_supplier_interface_linked ?duplicate_booking_record ?supplier_interface_duplicate)
        (supplier_interface_primary_requires_reconciliation ?supplier_interface_primary)
        (supplier_interface_duplicate_requires_reconciliation ?supplier_interface_duplicate)
        (not
          (primary_booking_ready_for_ticket ?primary_booking_record)
        )
        (not
          (duplicate_booking_ready_for_ticket ?duplicate_booking_record)
        )
        (resolution_ticket_available ?resolution_ticket)
      )
    :effect
      (and
        (resolution_ticket_active ?resolution_ticket)
        (ticket_linked_supplier_interface_primary ?resolution_ticket ?supplier_interface_primary)
        (ticket_linked_supplier_interface_duplicate ?resolution_ticket ?supplier_interface_duplicate)
        (ticket_requires_primary_action ?resolution_ticket)
        (ticket_requires_duplicate_action ?resolution_ticket)
        (not
          (resolution_ticket_available ?resolution_ticket)
        )
      )
  )
  (:action acknowledge_ticket_from_primary_interface
    :parameters (?resolution_ticket - resolution_ticket ?primary_booking_record - primary_booking_record ?verification_document - verification_document)
    :precondition
      (and
        (resolution_ticket_active ?resolution_ticket)
        (primary_booking_ticket_ready ?primary_booking_record)
        (entity_status_document_linked ?primary_booking_record ?verification_document)
        (not
          (ticket_primary_acknowledged ?resolution_ticket)
        )
      )
    :effect (ticket_primary_acknowledged ?resolution_ticket)
  )
  (:action attach_supporting_document_to_ticket
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?supporting_document - supporting_document ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (entity_status_verified ?resolution_workflow_instance)
        (workflow_attached_ticket ?resolution_workflow_instance ?resolution_ticket)
        (workflow_has_supporting_document ?resolution_workflow_instance ?supporting_document)
        (supporting_document_available ?supporting_document)
        (resolution_ticket_active ?resolution_ticket)
        (ticket_primary_acknowledged ?resolution_ticket)
        (not
          (supporting_document_assigned ?supporting_document)
        )
      )
    :effect
      (and
        (supporting_document_assigned ?supporting_document)
        (supporting_document_attached_to_ticket ?supporting_document ?resolution_ticket)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action validate_ticket_enrichment
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?supporting_document - supporting_document ?resolution_ticket - resolution_ticket ?verification_document - verification_document)
    :precondition
      (and
        (entity_status_verified ?resolution_workflow_instance)
        (workflow_has_supporting_document ?resolution_workflow_instance ?supporting_document)
        (supporting_document_assigned ?supporting_document)
        (supporting_document_attached_to_ticket ?supporting_document ?resolution_ticket)
        (entity_status_document_linked ?resolution_workflow_instance ?verification_document)
        (not
          (ticket_requires_primary_action ?resolution_ticket)
        )
        (not
          (workflow_ready_for_enrichment ?resolution_workflow_instance)
        )
      )
    :effect (workflow_ready_for_enrichment ?resolution_workflow_instance)
  )
  (:action link_escalation_reason_to_workflow
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?escalation_reason - escalation_reason)
    :precondition
      (and
        (entity_status_verified ?resolution_workflow_instance)
        (escalation_reason_available ?escalation_reason)
        (not
          (workflow_has_escalation_reason ?resolution_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_has_escalation_reason ?resolution_workflow_instance)
        (workflow_escalation_reason_linked ?resolution_workflow_instance ?escalation_reason)
        (not
          (escalation_reason_available ?escalation_reason)
        )
      )
  )
  (:action attach_vendor_contact_and_mark_workflow_enrichment_ready
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?supporting_document - supporting_document ?resolution_ticket - resolution_ticket ?verification_document - verification_document ?escalation_reason - escalation_reason)
    :precondition
      (and
        (entity_status_verified ?resolution_workflow_instance)
        (workflow_has_supporting_document ?resolution_workflow_instance ?supporting_document)
        (supporting_document_assigned ?supporting_document)
        (supporting_document_attached_to_ticket ?supporting_document ?resolution_ticket)
        (entity_status_document_linked ?resolution_workflow_instance ?verification_document)
        (ticket_requires_primary_action ?resolution_ticket)
        (workflow_has_escalation_reason ?resolution_workflow_instance)
        (workflow_escalation_reason_linked ?resolution_workflow_instance ?escalation_reason)
        (not
          (workflow_ready_for_enrichment ?resolution_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_ready_for_enrichment ?resolution_workflow_instance)
        (workflow_vendor_contact_attached ?resolution_workflow_instance)
      )
  )
  (:action prepare_workflow_for_compensation
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?compensation_option - compensation_option ?staff_member - staff_member ?supporting_document - supporting_document ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (workflow_ready_for_enrichment ?resolution_workflow_instance)
        (workflow_compensation_option_linked ?resolution_workflow_instance ?compensation_option)
        (entity_status_assigned_staff ?resolution_workflow_instance ?staff_member)
        (workflow_has_supporting_document ?resolution_workflow_instance ?supporting_document)
        (supporting_document_attached_to_ticket ?supporting_document ?resolution_ticket)
        (not
          (ticket_requires_duplicate_action ?resolution_ticket)
        )
        (not
          (workflow_escalation_prepared ?resolution_workflow_instance)
        )
      )
    :effect (workflow_escalation_prepared ?resolution_workflow_instance)
  )
  (:action prepare_workflow_for_compensation_variant
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?compensation_option - compensation_option ?staff_member - staff_member ?supporting_document - supporting_document ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (workflow_ready_for_enrichment ?resolution_workflow_instance)
        (workflow_compensation_option_linked ?resolution_workflow_instance ?compensation_option)
        (entity_status_assigned_staff ?resolution_workflow_instance ?staff_member)
        (workflow_has_supporting_document ?resolution_workflow_instance ?supporting_document)
        (supporting_document_attached_to_ticket ?supporting_document ?resolution_ticket)
        (ticket_requires_duplicate_action ?resolution_ticket)
        (not
          (workflow_escalation_prepared ?resolution_workflow_instance)
        )
      )
    :effect (workflow_escalation_prepared ?resolution_workflow_instance)
  )
  (:action apply_escalation_template_prepare_final_review
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?escalation_template - escalation_template ?supporting_document - supporting_document ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (workflow_escalation_prepared ?resolution_workflow_instance)
        (workflow_escalation_template_linked ?resolution_workflow_instance ?escalation_template)
        (workflow_has_supporting_document ?resolution_workflow_instance ?supporting_document)
        (supporting_document_attached_to_ticket ?supporting_document ?resolution_ticket)
        (not
          (ticket_requires_primary_action ?resolution_ticket)
        )
        (not
          (ticket_requires_duplicate_action ?resolution_ticket)
        )
        (not
          (workflow_final_review_ready ?resolution_workflow_instance)
        )
      )
    :effect (workflow_final_review_ready ?resolution_workflow_instance)
  )
  (:action apply_escalation_template_and_add_approval
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?escalation_template - escalation_template ?supporting_document - supporting_document ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (workflow_escalation_prepared ?resolution_workflow_instance)
        (workflow_escalation_template_linked ?resolution_workflow_instance ?escalation_template)
        (workflow_has_supporting_document ?resolution_workflow_instance ?supporting_document)
        (supporting_document_attached_to_ticket ?supporting_document ?resolution_ticket)
        (ticket_requires_primary_action ?resolution_ticket)
        (not
          (ticket_requires_duplicate_action ?resolution_ticket)
        )
        (not
          (workflow_final_review_ready ?resolution_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_final_review_ready ?resolution_workflow_instance)
        (workflow_requires_approval ?resolution_workflow_instance)
      )
  )
  (:action apply_escalation_template_and_add_approval_variant
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?escalation_template - escalation_template ?supporting_document - supporting_document ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (workflow_escalation_prepared ?resolution_workflow_instance)
        (workflow_escalation_template_linked ?resolution_workflow_instance ?escalation_template)
        (workflow_has_supporting_document ?resolution_workflow_instance ?supporting_document)
        (supporting_document_attached_to_ticket ?supporting_document ?resolution_ticket)
        (not
          (ticket_requires_primary_action ?resolution_ticket)
        )
        (ticket_requires_duplicate_action ?resolution_ticket)
        (not
          (workflow_final_review_ready ?resolution_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_final_review_ready ?resolution_workflow_instance)
        (workflow_requires_approval ?resolution_workflow_instance)
      )
  )
  (:action apply_escalation_template_and_add_approval_combined
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?escalation_template - escalation_template ?supporting_document - supporting_document ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (workflow_escalation_prepared ?resolution_workflow_instance)
        (workflow_escalation_template_linked ?resolution_workflow_instance ?escalation_template)
        (workflow_has_supporting_document ?resolution_workflow_instance ?supporting_document)
        (supporting_document_attached_to_ticket ?supporting_document ?resolution_ticket)
        (ticket_requires_primary_action ?resolution_ticket)
        (ticket_requires_duplicate_action ?resolution_ticket)
        (not
          (workflow_final_review_ready ?resolution_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_final_review_ready ?resolution_workflow_instance)
        (workflow_requires_approval ?resolution_workflow_instance)
      )
  )
  (:action finalize_workflow_and_mark_settlement
    :parameters (?resolution_workflow_instance - resolution_workflow_instance)
    :precondition
      (and
        (workflow_final_review_ready ?resolution_workflow_instance)
        (not
          (workflow_requires_approval ?resolution_workflow_instance)
        )
        (not
          (workflow_closed ?resolution_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_closed ?resolution_workflow_instance)
        (entity_status_approved_for_settlement ?resolution_workflow_instance)
      )
  )
  (:action link_approval_artifact_to_workflow
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?approval_artifact - approval_artifact)
    :precondition
      (and
        (workflow_final_review_ready ?resolution_workflow_instance)
        (workflow_requires_approval ?resolution_workflow_instance)
        (approval_artifact_available ?approval_artifact)
      )
    :effect
      (and
        (workflow_approval_artifact_linked ?resolution_workflow_instance ?approval_artifact)
        (not
          (approval_artifact_available ?approval_artifact)
        )
      )
  )
  (:action execute_approval_and_mark_workflow_ready_for_settlement
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?primary_booking_record - primary_booking_record ?duplicate_booking_record - duplicate_booking_record ?verification_document - verification_document ?approval_artifact - approval_artifact)
    :precondition
      (and
        (workflow_final_review_ready ?resolution_workflow_instance)
        (workflow_requires_approval ?resolution_workflow_instance)
        (workflow_approval_artifact_linked ?resolution_workflow_instance ?approval_artifact)
        (workflow_linked_primary_booking ?resolution_workflow_instance ?primary_booking_record)
        (workflow_linked_duplicate_booking ?resolution_workflow_instance ?duplicate_booking_record)
        (primary_booking_ready_for_ticket ?primary_booking_record)
        (duplicate_booking_ready_for_ticket ?duplicate_booking_record)
        (entity_status_document_linked ?resolution_workflow_instance ?verification_document)
        (not
          (workflow_ready_for_settlement ?resolution_workflow_instance)
        )
      )
    :effect (workflow_ready_for_settlement ?resolution_workflow_instance)
  )
  (:action finalize_workflow_closure
    :parameters (?resolution_workflow_instance - resolution_workflow_instance)
    :precondition
      (and
        (workflow_final_review_ready ?resolution_workflow_instance)
        (workflow_ready_for_settlement ?resolution_workflow_instance)
        (not
          (workflow_closed ?resolution_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_closed ?resolution_workflow_instance)
        (entity_status_approved_for_settlement ?resolution_workflow_instance)
      )
  )
  (:action initiate_vendor_engagement_for_workflow
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?vendor_contact - vendor_contact ?verification_document - verification_document)
    :precondition
      (and
        (entity_status_verified ?resolution_workflow_instance)
        (entity_status_document_linked ?resolution_workflow_instance ?verification_document)
        (vendor_contact_available ?vendor_contact)
        (workflow_vendor_contact_linked ?resolution_workflow_instance ?vendor_contact)
        (not
          (workflow_vendor_engagement_initiated ?resolution_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_vendor_engagement_initiated ?resolution_workflow_instance)
        (not
          (vendor_contact_available ?vendor_contact)
        )
      )
  )
  (:action start_vendor_engagement
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?staff_member - staff_member)
    :precondition
      (and
        (workflow_vendor_engagement_initiated ?resolution_workflow_instance)
        (entity_status_assigned_staff ?resolution_workflow_instance ?staff_member)
        (not
          (workflow_vendor_engagement_in_progress ?resolution_workflow_instance)
        )
      )
    :effect (workflow_vendor_engagement_in_progress ?resolution_workflow_instance)
  )
  (:action record_vendor_response_for_workflow
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?escalation_template - escalation_template)
    :precondition
      (and
        (workflow_vendor_engagement_in_progress ?resolution_workflow_instance)
        (workflow_escalation_template_linked ?resolution_workflow_instance ?escalation_template)
        (not
          (workflow_vendor_response_received ?resolution_workflow_instance)
        )
      )
    :effect (workflow_vendor_response_received ?resolution_workflow_instance)
  )
  (:action close_workflow_after_vendor_response
    :parameters (?resolution_workflow_instance - resolution_workflow_instance)
    :precondition
      (and
        (workflow_vendor_response_received ?resolution_workflow_instance)
        (not
          (workflow_closed ?resolution_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_closed ?resolution_workflow_instance)
        (entity_status_approved_for_settlement ?resolution_workflow_instance)
      )
  )
  (:action finalize_primary_booking_after_ticket
    :parameters (?primary_booking_record - primary_booking_record ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (primary_booking_ticket_ready ?primary_booking_record)
        (primary_booking_ready_for_ticket ?primary_booking_record)
        (resolution_ticket_active ?resolution_ticket)
        (ticket_primary_acknowledged ?resolution_ticket)
        (not
          (entity_status_approved_for_settlement ?primary_booking_record)
        )
      )
    :effect (entity_status_approved_for_settlement ?primary_booking_record)
  )
  (:action finalize_duplicate_booking_after_ticket
    :parameters (?duplicate_booking_record - duplicate_booking_record ?resolution_ticket - resolution_ticket)
    :precondition
      (and
        (duplicate_booking_ticket_ready ?duplicate_booking_record)
        (duplicate_booking_ready_for_ticket ?duplicate_booking_record)
        (resolution_ticket_active ?resolution_ticket)
        (ticket_primary_acknowledged ?resolution_ticket)
        (not
          (entity_status_approved_for_settlement ?duplicate_booking_record)
        )
      )
    :effect (entity_status_approved_for_settlement ?duplicate_booking_record)
  )
  (:action authorize_settlement_for_case
    :parameters (?duplicate_booking_case - duplicate_booking_case ?payment_instrument - payment_instrument ?verification_document - verification_document)
    :precondition
      (and
        (entity_status_approved_for_settlement ?duplicate_booking_case)
        (entity_status_document_linked ?duplicate_booking_case ?verification_document)
        (payment_instrument_available ?payment_instrument)
        (not
          (entity_status_settlement_initiated ?duplicate_booking_case)
        )
      )
    :effect
      (and
        (entity_status_settlement_initiated ?duplicate_booking_case)
        (entity_status_payment_instrument_linked ?duplicate_booking_case ?payment_instrument)
        (not
          (payment_instrument_available ?payment_instrument)
        )
      )
  )
  (:action execute_settlement_and_restore_channel_primary
    :parameters (?primary_booking_record - primary_booking_record ?communication_channel - communication_channel ?payment_instrument - payment_instrument)
    :precondition
      (and
        (entity_status_settlement_initiated ?primary_booking_record)
        (case_channel_assigned ?primary_booking_record ?communication_channel)
        (entity_status_payment_instrument_linked ?primary_booking_record ?payment_instrument)
        (not
          (entity_status_closed ?primary_booking_record)
        )
      )
    :effect
      (and
        (entity_status_closed ?primary_booking_record)
        (channel_available ?communication_channel)
        (payment_instrument_available ?payment_instrument)
      )
  )
  (:action execute_settlement_and_restore_channel_duplicate
    :parameters (?duplicate_booking_record - duplicate_booking_record ?communication_channel - communication_channel ?payment_instrument - payment_instrument)
    :precondition
      (and
        (entity_status_settlement_initiated ?duplicate_booking_record)
        (case_channel_assigned ?duplicate_booking_record ?communication_channel)
        (entity_status_payment_instrument_linked ?duplicate_booking_record ?payment_instrument)
        (not
          (entity_status_closed ?duplicate_booking_record)
        )
      )
    :effect
      (and
        (entity_status_closed ?duplicate_booking_record)
        (channel_available ?communication_channel)
        (payment_instrument_available ?payment_instrument)
      )
  )
  (:action execute_settlement_and_restore_channel_workflow
    :parameters (?resolution_workflow_instance - resolution_workflow_instance ?communication_channel - communication_channel ?payment_instrument - payment_instrument)
    :precondition
      (and
        (entity_status_settlement_initiated ?resolution_workflow_instance)
        (case_channel_assigned ?resolution_workflow_instance ?communication_channel)
        (entity_status_payment_instrument_linked ?resolution_workflow_instance ?payment_instrument)
        (not
          (entity_status_closed ?resolution_workflow_instance)
        )
      )
    :effect
      (and
        (entity_status_closed ?resolution_workflow_instance)
        (channel_available ?communication_channel)
        (payment_instrument_available ?payment_instrument)
      )
  )
)

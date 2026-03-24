(define (domain payment_release_queue_prioritization)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource - object document_artifact - object routing_entity - object release_base - object release_unit - release_base processing_slot - operational_resource validation_agent - operational_resource operator_agent - operational_resource priority_profile - operational_resource exception_profile - operational_resource release_context - operational_resource signature_token - operational_resource compliance_verification - operational_resource supporting_document - document_artifact document_bundle - document_artifact external_approval - document_artifact debit_route_target - routing_entity credit_route_target - routing_entity settlement_message - routing_entity leg_base - release_unit workflow_base - release_unit debit_leg - leg_base credit_leg - leg_base release_workflow - workflow_base)
  (:predicates
    (queued_for_release ?release_unit - release_unit)
    (validation_cleared ?release_unit - release_unit)
    (processing_slot_claimed ?release_unit - release_unit)
    (settlement_completed ?release_unit - release_unit)
    (execution_ready ?release_unit - release_unit)
    (execution_committed ?release_unit - release_unit)
    (processing_slot_available ?processing_slot - processing_slot)
    (slot_assignment ?release_unit - release_unit ?processing_slot - processing_slot)
    (validation_agent_available ?validation_agent - validation_agent)
    (validation_agent_assignment ?release_unit - release_unit ?validation_agent - validation_agent)
    (operator_agent_available ?operator_agent - operator_agent)
    (operator_agent_assignment ?release_unit - release_unit ?operator_agent - operator_agent)
    (supporting_document_available ?auxiliary_resource - supporting_document)
    (debit_supporting_document_assignment ?debit_leg - debit_leg ?auxiliary_resource - supporting_document)
    (credit_supporting_document_assignment ?credit_leg - credit_leg ?auxiliary_resource - supporting_document)
    (debit_route_assignment ?debit_leg - debit_leg ?debit_route_target - debit_route_target)
    (debit_route_reserved ?debit_route_target - debit_route_target)
    (debit_route_exception_hold ?debit_route_target - debit_route_target)
    (debit_leg_cleared ?debit_leg - debit_leg)
    (credit_route_assignment ?credit_leg - credit_leg ?credit_route_target - credit_route_target)
    (credit_route_reserved ?credit_route_target - credit_route_target)
    (credit_route_exception_hold ?credit_route_target - credit_route_target)
    (credit_leg_cleared ?credit_leg - credit_leg)
    (settlement_message_available ?settlement_message - settlement_message)
    (settlement_message_composed ?settlement_message - settlement_message)
    (debit_route_bound ?settlement_message - settlement_message ?debit_route_target - debit_route_target)
    (credit_route_bound ?settlement_message - settlement_message ?credit_route_target - credit_route_target)
    (debit_exception_flag ?settlement_message - settlement_message)
    (credit_exception_flag ?settlement_message - settlement_message)
    (settlement_message_endorsed ?settlement_message - settlement_message)
    (workflow_debit_leg_link ?release_workflow - release_workflow ?debit_leg - debit_leg)
    (workflow_credit_leg_link ?release_workflow - release_workflow ?credit_leg - credit_leg)
    (workflow_settlement_message_link ?release_workflow - release_workflow ?settlement_message - settlement_message)
    (document_bundle_available ?document_bundle - document_bundle)
    (workflow_document_bundle_link ?release_workflow - release_workflow ?document_bundle - document_bundle)
    (document_bundle_bound ?document_bundle - document_bundle)
    (document_bundle_message_link ?document_bundle - document_bundle ?settlement_message - settlement_message)
    (workflow_staged ?release_workflow - release_workflow)
    (workflow_signed_off ?release_workflow - release_workflow)
    (workflow_authorized ?release_workflow - release_workflow)
    (workflow_priority_applied ?release_workflow - release_workflow)
    (workflow_dispatch_prepared ?release_workflow - release_workflow)
    (workflow_exception_flagged ?release_workflow - release_workflow)
    (workflow_exception_reconciled ?release_workflow - release_workflow)
    (external_approval_available ?external_approval - external_approval)
    (workflow_external_approval_link ?release_workflow - release_workflow ?external_approval - external_approval)
    (external_approval_recorded ?release_workflow - release_workflow)
    (operator_routed ?release_workflow - release_workflow)
    (compliance_cleared ?release_workflow - release_workflow)
    (priority_profile_available ?priority_profile - priority_profile)
    (workflow_priority_profile_link ?release_workflow - release_workflow ?priority_profile - priority_profile)
    (exception_profile_available ?exception_profile - exception_profile)
    (workflow_exception_profile_link ?release_workflow - release_workflow ?exception_profile - exception_profile)
    (signature_token_available ?signature_token - signature_token)
    (workflow_signature_token_link ?release_workflow - release_workflow ?signature_token - signature_token)
    (compliance_verification_available ?compliance_verification - compliance_verification)
    (workflow_compliance_verification_link ?release_workflow - release_workflow ?compliance_verification - compliance_verification)
    (release_context_available ?release_context - release_context)
    (release_context_link ?release_unit - release_unit ?release_context - release_context)
    (debit_leg_locked ?debit_leg - debit_leg)
    (credit_leg_locked ?credit_leg - credit_leg)
    (workflow_finalized ?release_workflow - release_workflow)
  )
  (:action enqueue_release_unit
    :parameters (?release_unit - release_unit)
    :precondition
      (and
        (not
          (queued_for_release ?release_unit)
        )
        (not
          (settlement_completed ?release_unit)
        )
      )
    :effect (queued_for_release ?release_unit)
  )
  (:action allocate_processing_slot
    :parameters (?release_unit - release_unit ?processing_slot - processing_slot)
    :precondition
      (and
        (queued_for_release ?release_unit)
        (not
          (processing_slot_claimed ?release_unit)
        )
        (processing_slot_available ?processing_slot)
      )
    :effect
      (and
        (processing_slot_claimed ?release_unit)
        (slot_assignment ?release_unit ?processing_slot)
        (not
          (processing_slot_available ?processing_slot)
        )
      )
  )
  (:action claim_validation_agent
    :parameters (?release_unit - release_unit ?validation_agent - validation_agent)
    :precondition
      (and
        (queued_for_release ?release_unit)
        (processing_slot_claimed ?release_unit)
        (validation_agent_available ?validation_agent)
      )
    :effect
      (and
        (validation_agent_assignment ?release_unit ?validation_agent)
        (not
          (validation_agent_available ?validation_agent)
        )
      )
  )
  (:action confirm_validation_clearance
    :parameters (?release_unit - release_unit ?validation_agent - validation_agent)
    :precondition
      (and
        (queued_for_release ?release_unit)
        (processing_slot_claimed ?release_unit)
        (validation_agent_assignment ?release_unit ?validation_agent)
        (not
          (validation_cleared ?release_unit)
        )
      )
    :effect (validation_cleared ?release_unit)
  )
  (:action release_validation_agent
    :parameters (?release_unit - release_unit ?validation_agent - validation_agent)
    :precondition
      (and
        (validation_agent_assignment ?release_unit ?validation_agent)
      )
    :effect
      (and
        (validation_agent_available ?validation_agent)
        (not
          (validation_agent_assignment ?release_unit ?validation_agent)
        )
      )
  )
  (:action claim_operator_agent
    :parameters (?release_unit - release_unit ?operator_agent - operator_agent)
    :precondition
      (and
        (validation_cleared ?release_unit)
        (operator_agent_available ?operator_agent)
      )
    :effect
      (and
        (operator_agent_assignment ?release_unit ?operator_agent)
        (not
          (operator_agent_available ?operator_agent)
        )
      )
  )
  (:action release_operator_agent
    :parameters (?release_unit - release_unit ?operator_agent - operator_agent)
    :precondition
      (and
        (operator_agent_assignment ?release_unit ?operator_agent)
      )
    :effect
      (and
        (operator_agent_available ?operator_agent)
        (not
          (operator_agent_assignment ?release_unit ?operator_agent)
        )
      )
  )
  (:action claim_signature_token
    :parameters (?release_workflow - release_workflow ?signature_token - signature_token)
    :precondition
      (and
        (validation_cleared ?release_workflow)
        (signature_token_available ?signature_token)
      )
    :effect
      (and
        (workflow_signature_token_link ?release_workflow ?signature_token)
        (not
          (signature_token_available ?signature_token)
        )
      )
  )
  (:action release_signature_token
    :parameters (?release_workflow - release_workflow ?signature_token - signature_token)
    :precondition
      (and
        (workflow_signature_token_link ?release_workflow ?signature_token)
      )
    :effect
      (and
        (signature_token_available ?signature_token)
        (not
          (workflow_signature_token_link ?release_workflow ?signature_token)
        )
      )
  )
  (:action claim_compliance_verification
    :parameters (?release_workflow - release_workflow ?compliance_verification - compliance_verification)
    :precondition
      (and
        (validation_cleared ?release_workflow)
        (compliance_verification_available ?compliance_verification)
      )
    :effect
      (and
        (workflow_compliance_verification_link ?release_workflow ?compliance_verification)
        (not
          (compliance_verification_available ?compliance_verification)
        )
      )
  )
  (:action release_compliance_verification
    :parameters (?release_workflow - release_workflow ?compliance_verification - compliance_verification)
    :precondition
      (and
        (workflow_compliance_verification_link ?release_workflow ?compliance_verification)
      )
    :effect
      (and
        (compliance_verification_available ?compliance_verification)
        (not
          (workflow_compliance_verification_link ?release_workflow ?compliance_verification)
        )
      )
  )
  (:action reserve_debit_route_target
    :parameters (?debit_leg - debit_leg ?debit_route_target - debit_route_target ?validation_agent - validation_agent)
    :precondition
      (and
        (validation_cleared ?debit_leg)
        (validation_agent_assignment ?debit_leg ?validation_agent)
        (debit_route_assignment ?debit_leg ?debit_route_target)
        (not
          (debit_route_reserved ?debit_route_target)
        )
        (not
          (debit_route_exception_hold ?debit_route_target)
        )
      )
    :effect (debit_route_reserved ?debit_route_target)
  )
  (:action lock_debit_route_assignment
    :parameters (?debit_leg - debit_leg ?debit_route_target - debit_route_target ?operator_agent - operator_agent)
    :precondition
      (and
        (validation_cleared ?debit_leg)
        (operator_agent_assignment ?debit_leg ?operator_agent)
        (debit_route_assignment ?debit_leg ?debit_route_target)
        (debit_route_reserved ?debit_route_target)
        (not
          (debit_leg_locked ?debit_leg)
        )
      )
    :effect
      (and
        (debit_leg_locked ?debit_leg)
        (debit_leg_cleared ?debit_leg)
      )
  )
  (:action route_debit_with_supporting_document
    :parameters (?debit_leg - debit_leg ?debit_route_target - debit_route_target ?auxiliary_resource - supporting_document)
    :precondition
      (and
        (validation_cleared ?debit_leg)
        (debit_route_assignment ?debit_leg ?debit_route_target)
        (supporting_document_available ?auxiliary_resource)
        (not
          (debit_leg_locked ?debit_leg)
        )
      )
    :effect
      (and
        (debit_route_exception_hold ?debit_route_target)
        (debit_leg_locked ?debit_leg)
        (debit_supporting_document_assignment ?debit_leg ?auxiliary_resource)
        (not
          (supporting_document_available ?auxiliary_resource)
        )
      )
  )
  (:action resolve_debit_route_exception
    :parameters (?debit_leg - debit_leg ?debit_route_target - debit_route_target ?validation_agent - validation_agent ?auxiliary_resource - supporting_document)
    :precondition
      (and
        (validation_cleared ?debit_leg)
        (validation_agent_assignment ?debit_leg ?validation_agent)
        (debit_route_assignment ?debit_leg ?debit_route_target)
        (debit_route_exception_hold ?debit_route_target)
        (debit_supporting_document_assignment ?debit_leg ?auxiliary_resource)
        (not
          (debit_leg_cleared ?debit_leg)
        )
      )
    :effect
      (and
        (debit_route_reserved ?debit_route_target)
        (debit_leg_cleared ?debit_leg)
        (supporting_document_available ?auxiliary_resource)
        (not
          (debit_supporting_document_assignment ?debit_leg ?auxiliary_resource)
        )
      )
  )
  (:action reserve_credit_route_target
    :parameters (?credit_leg - credit_leg ?credit_route_target - credit_route_target ?validation_agent - validation_agent)
    :precondition
      (and
        (validation_cleared ?credit_leg)
        (validation_agent_assignment ?credit_leg ?validation_agent)
        (credit_route_assignment ?credit_leg ?credit_route_target)
        (not
          (credit_route_reserved ?credit_route_target)
        )
        (not
          (credit_route_exception_hold ?credit_route_target)
        )
      )
    :effect (credit_route_reserved ?credit_route_target)
  )
  (:action lock_credit_route_assignment
    :parameters (?credit_leg - credit_leg ?credit_route_target - credit_route_target ?operator_agent - operator_agent)
    :precondition
      (and
        (validation_cleared ?credit_leg)
        (operator_agent_assignment ?credit_leg ?operator_agent)
        (credit_route_assignment ?credit_leg ?credit_route_target)
        (credit_route_reserved ?credit_route_target)
        (not
          (credit_leg_locked ?credit_leg)
        )
      )
    :effect
      (and
        (credit_leg_locked ?credit_leg)
        (credit_leg_cleared ?credit_leg)
      )
  )
  (:action route_credit_with_supporting_document
    :parameters (?credit_leg - credit_leg ?credit_route_target - credit_route_target ?auxiliary_resource - supporting_document)
    :precondition
      (and
        (validation_cleared ?credit_leg)
        (credit_route_assignment ?credit_leg ?credit_route_target)
        (supporting_document_available ?auxiliary_resource)
        (not
          (credit_leg_locked ?credit_leg)
        )
      )
    :effect
      (and
        (credit_route_exception_hold ?credit_route_target)
        (credit_leg_locked ?credit_leg)
        (credit_supporting_document_assignment ?credit_leg ?auxiliary_resource)
        (not
          (supporting_document_available ?auxiliary_resource)
        )
      )
  )
  (:action resolve_credit_route_exception
    :parameters (?credit_leg - credit_leg ?credit_route_target - credit_route_target ?validation_agent - validation_agent ?auxiliary_resource - supporting_document)
    :precondition
      (and
        (validation_cleared ?credit_leg)
        (validation_agent_assignment ?credit_leg ?validation_agent)
        (credit_route_assignment ?credit_leg ?credit_route_target)
        (credit_route_exception_hold ?credit_route_target)
        (credit_supporting_document_assignment ?credit_leg ?auxiliary_resource)
        (not
          (credit_leg_cleared ?credit_leg)
        )
      )
    :effect
      (and
        (credit_route_reserved ?credit_route_target)
        (credit_leg_cleared ?credit_leg)
        (supporting_document_available ?auxiliary_resource)
        (not
          (credit_supporting_document_assignment ?credit_leg ?auxiliary_resource)
        )
      )
  )
  (:action assemble_balanced_settlement_message
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_route_target - debit_route_target ?credit_route_target - credit_route_target ?settlement_message - settlement_message)
    :precondition
      (and
        (debit_leg_locked ?debit_leg)
        (credit_leg_locked ?credit_leg)
        (debit_route_assignment ?debit_leg ?debit_route_target)
        (credit_route_assignment ?credit_leg ?credit_route_target)
        (debit_route_reserved ?debit_route_target)
        (credit_route_reserved ?credit_route_target)
        (debit_leg_cleared ?debit_leg)
        (credit_leg_cleared ?credit_leg)
        (settlement_message_available ?settlement_message)
      )
    :effect
      (and
        (settlement_message_composed ?settlement_message)
        (debit_route_bound ?settlement_message ?debit_route_target)
        (credit_route_bound ?settlement_message ?credit_route_target)
        (not
          (settlement_message_available ?settlement_message)
        )
      )
  )
  (:action assemble_settlement_message_with_debit_exception
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_route_target - debit_route_target ?credit_route_target - credit_route_target ?settlement_message - settlement_message)
    :precondition
      (and
        (debit_leg_locked ?debit_leg)
        (credit_leg_locked ?credit_leg)
        (debit_route_assignment ?debit_leg ?debit_route_target)
        (credit_route_assignment ?credit_leg ?credit_route_target)
        (debit_route_exception_hold ?debit_route_target)
        (credit_route_reserved ?credit_route_target)
        (not
          (debit_leg_cleared ?debit_leg)
        )
        (credit_leg_cleared ?credit_leg)
        (settlement_message_available ?settlement_message)
      )
    :effect
      (and
        (settlement_message_composed ?settlement_message)
        (debit_route_bound ?settlement_message ?debit_route_target)
        (credit_route_bound ?settlement_message ?credit_route_target)
        (debit_exception_flag ?settlement_message)
        (not
          (settlement_message_available ?settlement_message)
        )
      )
  )
  (:action assemble_settlement_message_with_credit_exception
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_route_target - debit_route_target ?credit_route_target - credit_route_target ?settlement_message - settlement_message)
    :precondition
      (and
        (debit_leg_locked ?debit_leg)
        (credit_leg_locked ?credit_leg)
        (debit_route_assignment ?debit_leg ?debit_route_target)
        (credit_route_assignment ?credit_leg ?credit_route_target)
        (debit_route_reserved ?debit_route_target)
        (credit_route_exception_hold ?credit_route_target)
        (debit_leg_cleared ?debit_leg)
        (not
          (credit_leg_cleared ?credit_leg)
        )
        (settlement_message_available ?settlement_message)
      )
    :effect
      (and
        (settlement_message_composed ?settlement_message)
        (debit_route_bound ?settlement_message ?debit_route_target)
        (credit_route_bound ?settlement_message ?credit_route_target)
        (credit_exception_flag ?settlement_message)
        (not
          (settlement_message_available ?settlement_message)
        )
      )
  )
  (:action assemble_settlement_message_with_both_exceptions
    :parameters (?debit_leg - debit_leg ?credit_leg - credit_leg ?debit_route_target - debit_route_target ?credit_route_target - credit_route_target ?settlement_message - settlement_message)
    :precondition
      (and
        (debit_leg_locked ?debit_leg)
        (credit_leg_locked ?credit_leg)
        (debit_route_assignment ?debit_leg ?debit_route_target)
        (credit_route_assignment ?credit_leg ?credit_route_target)
        (debit_route_exception_hold ?debit_route_target)
        (credit_route_exception_hold ?credit_route_target)
        (not
          (debit_leg_cleared ?debit_leg)
        )
        (not
          (credit_leg_cleared ?credit_leg)
        )
        (settlement_message_available ?settlement_message)
      )
    :effect
      (and
        (settlement_message_composed ?settlement_message)
        (debit_route_bound ?settlement_message ?debit_route_target)
        (credit_route_bound ?settlement_message ?credit_route_target)
        (debit_exception_flag ?settlement_message)
        (credit_exception_flag ?settlement_message)
        (not
          (settlement_message_available ?settlement_message)
        )
      )
  )
  (:action endorse_settlement_message
    :parameters (?settlement_message - settlement_message ?debit_leg - debit_leg ?validation_agent - validation_agent)
    :precondition
      (and
        (settlement_message_composed ?settlement_message)
        (debit_leg_locked ?debit_leg)
        (validation_agent_assignment ?debit_leg ?validation_agent)
        (not
          (settlement_message_endorsed ?settlement_message)
        )
      )
    :effect (settlement_message_endorsed ?settlement_message)
  )
  (:action bind_document_bundle_to_settlement_message
    :parameters (?release_workflow - release_workflow ?document_bundle - document_bundle ?settlement_message - settlement_message)
    :precondition
      (and
        (validation_cleared ?release_workflow)
        (workflow_settlement_message_link ?release_workflow ?settlement_message)
        (workflow_document_bundle_link ?release_workflow ?document_bundle)
        (document_bundle_available ?document_bundle)
        (settlement_message_composed ?settlement_message)
        (settlement_message_endorsed ?settlement_message)
        (not
          (document_bundle_bound ?document_bundle)
        )
      )
    :effect
      (and
        (document_bundle_bound ?document_bundle)
        (document_bundle_message_link ?document_bundle ?settlement_message)
        (not
          (document_bundle_available ?document_bundle)
        )
      )
  )
  (:action stage_release_workflow
    :parameters (?release_workflow - release_workflow ?document_bundle - document_bundle ?settlement_message - settlement_message ?validation_agent - validation_agent)
    :precondition
      (and
        (validation_cleared ?release_workflow)
        (workflow_document_bundle_link ?release_workflow ?document_bundle)
        (document_bundle_bound ?document_bundle)
        (document_bundle_message_link ?document_bundle ?settlement_message)
        (validation_agent_assignment ?release_workflow ?validation_agent)
        (not
          (debit_exception_flag ?settlement_message)
        )
        (not
          (workflow_staged ?release_workflow)
        )
      )
    :effect (workflow_staged ?release_workflow)
  )
  (:action apply_priority_profile_to_release_workflow
    :parameters (?release_workflow - release_workflow ?priority_profile - priority_profile)
    :precondition
      (and
        (validation_cleared ?release_workflow)
        (priority_profile_available ?priority_profile)
        (not
          (workflow_priority_applied ?release_workflow)
        )
      )
    :effect
      (and
        (workflow_priority_applied ?release_workflow)
        (workflow_priority_profile_link ?release_workflow ?priority_profile)
        (not
          (priority_profile_available ?priority_profile)
        )
      )
  )
  (:action promote_staged_release_workflow
    :parameters (?release_workflow - release_workflow ?document_bundle - document_bundle ?settlement_message - settlement_message ?validation_agent - validation_agent ?priority_profile - priority_profile)
    :precondition
      (and
        (validation_cleared ?release_workflow)
        (workflow_document_bundle_link ?release_workflow ?document_bundle)
        (document_bundle_bound ?document_bundle)
        (document_bundle_message_link ?document_bundle ?settlement_message)
        (validation_agent_assignment ?release_workflow ?validation_agent)
        (debit_exception_flag ?settlement_message)
        (workflow_priority_applied ?release_workflow)
        (workflow_priority_profile_link ?release_workflow ?priority_profile)
        (not
          (workflow_staged ?release_workflow)
        )
      )
    :effect
      (and
        (workflow_staged ?release_workflow)
        (workflow_dispatch_prepared ?release_workflow)
      )
  )
  (:action sign_off_release_workflow
    :parameters (?release_workflow - release_workflow ?signature_token - signature_token ?operator_agent - operator_agent ?document_bundle - document_bundle ?settlement_message - settlement_message)
    :precondition
      (and
        (workflow_staged ?release_workflow)
        (workflow_signature_token_link ?release_workflow ?signature_token)
        (operator_agent_assignment ?release_workflow ?operator_agent)
        (workflow_document_bundle_link ?release_workflow ?document_bundle)
        (document_bundle_message_link ?document_bundle ?settlement_message)
        (not
          (credit_exception_flag ?settlement_message)
        )
        (not
          (workflow_signed_off ?release_workflow)
        )
      )
    :effect (workflow_signed_off ?release_workflow)
  )
  (:action sign_off_release_workflow_with_credit_exception
    :parameters (?release_workflow - release_workflow ?signature_token - signature_token ?operator_agent - operator_agent ?document_bundle - document_bundle ?settlement_message - settlement_message)
    :precondition
      (and
        (workflow_staged ?release_workflow)
        (workflow_signature_token_link ?release_workflow ?signature_token)
        (operator_agent_assignment ?release_workflow ?operator_agent)
        (workflow_document_bundle_link ?release_workflow ?document_bundle)
        (document_bundle_message_link ?document_bundle ?settlement_message)
        (credit_exception_flag ?settlement_message)
        (not
          (workflow_signed_off ?release_workflow)
        )
      )
    :effect (workflow_signed_off ?release_workflow)
  )
  (:action authorize_release_workflow
    :parameters (?release_workflow - release_workflow ?compliance_verification - compliance_verification ?document_bundle - document_bundle ?settlement_message - settlement_message)
    :precondition
      (and
        (workflow_signed_off ?release_workflow)
        (workflow_compliance_verification_link ?release_workflow ?compliance_verification)
        (workflow_document_bundle_link ?release_workflow ?document_bundle)
        (document_bundle_message_link ?document_bundle ?settlement_message)
        (not
          (debit_exception_flag ?settlement_message)
        )
        (not
          (credit_exception_flag ?settlement_message)
        )
        (not
          (workflow_authorized ?release_workflow)
        )
      )
    :effect (workflow_authorized ?release_workflow)
  )
  (:action authorize_release_workflow_with_debit_exception
    :parameters (?release_workflow - release_workflow ?compliance_verification - compliance_verification ?document_bundle - document_bundle ?settlement_message - settlement_message)
    :precondition
      (and
        (workflow_signed_off ?release_workflow)
        (workflow_compliance_verification_link ?release_workflow ?compliance_verification)
        (workflow_document_bundle_link ?release_workflow ?document_bundle)
        (document_bundle_message_link ?document_bundle ?settlement_message)
        (debit_exception_flag ?settlement_message)
        (not
          (credit_exception_flag ?settlement_message)
        )
        (not
          (workflow_authorized ?release_workflow)
        )
      )
    :effect
      (and
        (workflow_authorized ?release_workflow)
        (workflow_exception_flagged ?release_workflow)
      )
  )
  (:action authorize_release_workflow_with_credit_exception
    :parameters (?release_workflow - release_workflow ?compliance_verification - compliance_verification ?document_bundle - document_bundle ?settlement_message - settlement_message)
    :precondition
      (and
        (workflow_signed_off ?release_workflow)
        (workflow_compliance_verification_link ?release_workflow ?compliance_verification)
        (workflow_document_bundle_link ?release_workflow ?document_bundle)
        (document_bundle_message_link ?document_bundle ?settlement_message)
        (not
          (debit_exception_flag ?settlement_message)
        )
        (credit_exception_flag ?settlement_message)
        (not
          (workflow_authorized ?release_workflow)
        )
      )
    :effect
      (and
        (workflow_authorized ?release_workflow)
        (workflow_exception_flagged ?release_workflow)
      )
  )
  (:action authorize_release_workflow_with_both_exceptions
    :parameters (?release_workflow - release_workflow ?compliance_verification - compliance_verification ?document_bundle - document_bundle ?settlement_message - settlement_message)
    :precondition
      (and
        (workflow_signed_off ?release_workflow)
        (workflow_compliance_verification_link ?release_workflow ?compliance_verification)
        (workflow_document_bundle_link ?release_workflow ?document_bundle)
        (document_bundle_message_link ?document_bundle ?settlement_message)
        (debit_exception_flag ?settlement_message)
        (credit_exception_flag ?settlement_message)
        (not
          (workflow_authorized ?release_workflow)
        )
      )
    :effect
      (and
        (workflow_authorized ?release_workflow)
        (workflow_exception_flagged ?release_workflow)
      )
  )
  (:action finalize_standard_release
    :parameters (?release_workflow - release_workflow)
    :precondition
      (and
        (workflow_authorized ?release_workflow)
        (not
          (workflow_exception_flagged ?release_workflow)
        )
        (not
          (workflow_finalized ?release_workflow)
        )
      )
    :effect
      (and
        (workflow_finalized ?release_workflow)
        (execution_ready ?release_workflow)
      )
  )
  (:action bind_exception_profile_to_release_workflow
    :parameters (?release_workflow - release_workflow ?exception_profile - exception_profile)
    :precondition
      (and
        (workflow_authorized ?release_workflow)
        (workflow_exception_flagged ?release_workflow)
        (exception_profile_available ?exception_profile)
      )
    :effect
      (and
        (workflow_exception_profile_link ?release_workflow ?exception_profile)
        (not
          (exception_profile_available ?exception_profile)
        )
      )
  )
  (:action reconcile_exception_release
    :parameters (?release_workflow - release_workflow ?debit_leg - debit_leg ?credit_leg - credit_leg ?validation_agent - validation_agent ?exception_profile - exception_profile)
    :precondition
      (and
        (workflow_authorized ?release_workflow)
        (workflow_exception_flagged ?release_workflow)
        (workflow_exception_profile_link ?release_workflow ?exception_profile)
        (workflow_debit_leg_link ?release_workflow ?debit_leg)
        (workflow_credit_leg_link ?release_workflow ?credit_leg)
        (debit_leg_cleared ?debit_leg)
        (credit_leg_cleared ?credit_leg)
        (validation_agent_assignment ?release_workflow ?validation_agent)
        (not
          (workflow_exception_reconciled ?release_workflow)
        )
      )
    :effect (workflow_exception_reconciled ?release_workflow)
  )
  (:action finalize_exception_release
    :parameters (?release_workflow - release_workflow)
    :precondition
      (and
        (workflow_authorized ?release_workflow)
        (workflow_exception_reconciled ?release_workflow)
        (not
          (workflow_finalized ?release_workflow)
        )
      )
    :effect
      (and
        (workflow_finalized ?release_workflow)
        (execution_ready ?release_workflow)
      )
  )
  (:action record_external_approval
    :parameters (?release_workflow - release_workflow ?external_approval - external_approval ?validation_agent - validation_agent)
    :precondition
      (and
        (validation_cleared ?release_workflow)
        (validation_agent_assignment ?release_workflow ?validation_agent)
        (external_approval_available ?external_approval)
        (workflow_external_approval_link ?release_workflow ?external_approval)
        (not
          (external_approval_recorded ?release_workflow)
        )
      )
    :effect
      (and
        (external_approval_recorded ?release_workflow)
        (not
          (external_approval_available ?external_approval)
        )
      )
  )
  (:action route_release_workflow_for_execution
    :parameters (?release_workflow - release_workflow ?operator_agent - operator_agent)
    :precondition
      (and
        (external_approval_recorded ?release_workflow)
        (operator_agent_assignment ?release_workflow ?operator_agent)
        (not
          (operator_routed ?release_workflow)
        )
      )
    :effect (operator_routed ?release_workflow)
  )
  (:action record_compliance_clearance
    :parameters (?release_workflow - release_workflow ?compliance_verification - compliance_verification)
    :precondition
      (and
        (operator_routed ?release_workflow)
        (workflow_compliance_verification_link ?release_workflow ?compliance_verification)
        (not
          (compliance_cleared ?release_workflow)
        )
      )
    :effect (compliance_cleared ?release_workflow)
  )
  (:action close_release_workflow
    :parameters (?release_workflow - release_workflow)
    :precondition
      (and
        (compliance_cleared ?release_workflow)
        (not
          (workflow_finalized ?release_workflow)
        )
      )
    :effect
      (and
        (workflow_finalized ?release_workflow)
        (execution_ready ?release_workflow)
      )
  )
  (:action prepare_debit_leg_settlement
    :parameters (?debit_leg - debit_leg ?settlement_message - settlement_message)
    :precondition
      (and
        (debit_leg_locked ?debit_leg)
        (debit_leg_cleared ?debit_leg)
        (settlement_message_composed ?settlement_message)
        (settlement_message_endorsed ?settlement_message)
        (not
          (execution_ready ?debit_leg)
        )
      )
    :effect (execution_ready ?debit_leg)
  )
  (:action prepare_credit_leg_settlement
    :parameters (?credit_leg - credit_leg ?settlement_message - settlement_message)
    :precondition
      (and
        (credit_leg_locked ?credit_leg)
        (credit_leg_cleared ?credit_leg)
        (settlement_message_composed ?settlement_message)
        (settlement_message_endorsed ?settlement_message)
        (not
          (execution_ready ?credit_leg)
        )
      )
    :effect (execution_ready ?credit_leg)
  )
  (:action attach_release_context
    :parameters (?release_unit - release_unit ?release_context - release_context ?validation_agent - validation_agent)
    :precondition
      (and
        (execution_ready ?release_unit)
        (validation_agent_assignment ?release_unit ?validation_agent)
        (release_context_available ?release_context)
        (not
          (execution_committed ?release_unit)
        )
      )
    :effect
      (and
        (execution_committed ?release_unit)
        (release_context_link ?release_unit ?release_context)
        (not
          (release_context_available ?release_context)
        )
      )
  )
  (:action complete_debit_leg_settlement
    :parameters (?debit_leg - debit_leg ?processing_slot - processing_slot ?release_context - release_context)
    :precondition
      (and
        (execution_committed ?debit_leg)
        (slot_assignment ?debit_leg ?processing_slot)
        (release_context_link ?debit_leg ?release_context)
        (not
          (settlement_completed ?debit_leg)
        )
      )
    :effect
      (and
        (settlement_completed ?debit_leg)
        (processing_slot_available ?processing_slot)
        (release_context_available ?release_context)
      )
  )
  (:action complete_credit_leg_settlement
    :parameters (?credit_leg - credit_leg ?processing_slot - processing_slot ?release_context - release_context)
    :precondition
      (and
        (execution_committed ?credit_leg)
        (slot_assignment ?credit_leg ?processing_slot)
        (release_context_link ?credit_leg ?release_context)
        (not
          (settlement_completed ?credit_leg)
        )
      )
    :effect
      (and
        (settlement_completed ?credit_leg)
        (processing_slot_available ?processing_slot)
        (release_context_available ?release_context)
      )
  )
  (:action complete_release_workflow_settlement
    :parameters (?release_workflow - release_workflow ?processing_slot - processing_slot ?release_context - release_context)
    :precondition
      (and
        (execution_committed ?release_workflow)
        (slot_assignment ?release_workflow ?processing_slot)
        (release_context_link ?release_workflow ?release_context)
        (not
          (settlement_completed ?release_workflow)
        )
      )
    :effect
      (and
        (settlement_completed ?release_workflow)
        (processing_slot_available ?processing_slot)
        (release_context_available ?release_context)
      )
  )
)

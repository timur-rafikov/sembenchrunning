(define (domain state_transition_enforcement_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types generic_object - object infrastructure_resource_class - generic_object auxiliary_resource_class - generic_object composite_resource_class - generic_object domain_record_root - generic_object domain_record - domain_record_root assignee_token - infrastructure_resource_class validator_token - infrastructure_resource_class approver_token - infrastructure_resource_class policy_definition - infrastructure_resource_class configuration_profile - infrastructure_resource_class audit_token - infrastructure_resource_class attachment_type_a - infrastructure_resource_class binding_token - infrastructure_resource_class attachment_artifact - auxiliary_resource_class subdocument - auxiliary_resource_class policy_binding - auxiliary_resource_class resource_slot_a - composite_resource_class resource_slot_b - composite_resource_class deliverable - composite_resource_class actor_role - domain_record workflow_instance_subtype - domain_record primary_actor - actor_role secondary_actor - actor_role workflow_instance - workflow_instance_subtype)

  (:predicates
    (record_created ?domain_record - domain_record)
    (record_validated ?domain_record - domain_record)
    (record_assigned ?domain_record - domain_record)
    (marked_completed ?domain_record - domain_record)
    (ready_for_audit ?domain_record - domain_record)
    (audit_attached ?domain_record - domain_record)
    (assignee_token_available ?assignee_token - assignee_token)
    (record_assigned_to ?domain_record - domain_record ?assignee_token - assignee_token)
    (validator_token_available ?validator_token - validator_token)
    (record_validated_by ?domain_record - domain_record ?validator_token - validator_token)
    (approver_token_available ?approver_token - approver_token)
    (record_approver_binding ?domain_record - domain_record ?approver_token - approver_token)
    (attachment_artifact_available ?attachment_artifact - attachment_artifact)
    (primary_actor_attachment ?primary_actor - primary_actor ?attachment_artifact - attachment_artifact)
    (secondary_actor_attachment ?secondary_actor - secondary_actor ?attachment_artifact - attachment_artifact)
    (primary_actor_slot_a_assigned ?primary_actor - primary_actor ?resource_slot_a - resource_slot_a)
    (slot_a_reserved ?resource_slot_a - resource_slot_a)
    (slot_a_locked ?resource_slot_a - resource_slot_a)
    (primary_actor_slot_confirmed ?primary_actor - primary_actor)
    (secondary_actor_slot_b_assigned ?secondary_actor - secondary_actor ?resource_slot_b - resource_slot_b)
    (slot_b_reserved ?resource_slot_b - resource_slot_b)
    (slot_b_locked ?resource_slot_b - resource_slot_b)
    (secondary_actor_slot_confirmed ?secondary_actor - secondary_actor)
    (deliverable_pending ?deliverable - deliverable)
    (deliverable_ready ?deliverable - deliverable)
    (deliverable_slot_a_attached ?deliverable - deliverable ?resource_slot_a - resource_slot_a)
    (deliverable_slot_b_attached ?deliverable - deliverable ?resource_slot_b - resource_slot_b)
    (deliverable_readiness_a ?deliverable - deliverable)
    (deliverable_readiness_b ?deliverable - deliverable)
    (deliverable_published ?deliverable - deliverable)
    (workflow_primary_actor_link ?workflow_instance - workflow_instance ?primary_actor - primary_actor)
    (workflow_secondary_actor_link ?workflow_instance - workflow_instance ?secondary_actor - secondary_actor)
    (workflow_deliverable_attached ?workflow_instance - workflow_instance ?deliverable - deliverable)
    (subdocument_unprocessed ?subdocument - subdocument)
    (workflow_subdocument_attached ?workflow_instance - workflow_instance ?subdocument - subdocument)
    (subdocument_processed ?subdocument - subdocument)
    (subdocument_linked_to_deliverable ?subdocument - subdocument ?deliverable - deliverable)
    (workflow_attachment_prepared ?workflow_instance - workflow_instance)
    (workflow_attachment_validated ?workflow_instance - workflow_instance)
    (workflow_approval_ready ?workflow_instance - workflow_instance)
    (policy_applied ?workflow_instance - workflow_instance)
    (policy_enforced_on_workflow ?workflow_instance - workflow_instance)
    (workflow_approvals_completed ?workflow_instance - workflow_instance)
    (workflow_processing_complete ?workflow_instance - workflow_instance)
    (policy_binding_available ?policy_binding - policy_binding)
    (workflow_policy_binding_association ?workflow_instance - workflow_instance ?policy_binding - policy_binding)
    (policy_application_flag ?workflow_instance - workflow_instance)
    (policy_approval_flag ?workflow_instance - workflow_instance)
    (policy_committed_flag ?workflow_instance - workflow_instance)
    (policy_definition_available ?policy_definition - policy_definition)
    (workflow_policy_definition_binding ?workflow_instance - workflow_instance ?policy_definition - policy_definition)
    (configuration_profile_available ?configuration_profile - configuration_profile)
    (workflow_configuration_applied ?workflow_instance - workflow_instance ?configuration_profile - configuration_profile)
    (attachment_type_a_available ?attachment_type_a - attachment_type_a)
    (workflow_attachment_type_a_binding ?workflow_instance - workflow_instance ?attachment_type_a - attachment_type_a)
    (binding_token_available ?binding_token - binding_token)
    (workflow_binding_token_bound ?workflow_instance - workflow_instance ?binding_token - binding_token)
    (audit_token_available ?audit_token - audit_token)
    (record_audit_binding ?domain_record - domain_record ?audit_token - audit_token)
    (primary_actor_ready_for_assembly ?primary_actor - primary_actor)
    (secondary_actor_ready_for_assembly ?secondary_actor - secondary_actor)
    (workflow_finalized ?workflow_instance - workflow_instance)
  )
  (:action create_domain_record
    :parameters (?domain_record - domain_record)
    :precondition
      (and
        (not
          (record_created ?domain_record)
        )
        (not
          (marked_completed ?domain_record)
        )
      )
    :effect (record_created ?domain_record)
  )
  (:action assign_assignee_token_to_record
    :parameters (?domain_record - domain_record ?assignee_token - assignee_token)
    :precondition
      (and
        (record_created ?domain_record)
        (not
          (record_assigned ?domain_record)
        )
        (assignee_token_available ?assignee_token)
      )
    :effect
      (and
        (record_assigned ?domain_record)
        (record_assigned_to ?domain_record ?assignee_token)
        (not
          (assignee_token_available ?assignee_token)
        )
      )
  )
  (:action bind_validator_to_record
    :parameters (?domain_record - domain_record ?validator_token - validator_token)
    :precondition
      (and
        (record_created ?domain_record)
        (record_assigned ?domain_record)
        (validator_token_available ?validator_token)
      )
    :effect
      (and
        (record_validated_by ?domain_record ?validator_token)
        (not
          (validator_token_available ?validator_token)
        )
      )
  )
  (:action complete_validation
    :parameters (?domain_record - domain_record ?validator_token - validator_token)
    :precondition
      (and
        (record_created ?domain_record)
        (record_assigned ?domain_record)
        (record_validated_by ?domain_record ?validator_token)
        (not
          (record_validated ?domain_record)
        )
      )
    :effect (record_validated ?domain_record)
  )
  (:action release_validator_token
    :parameters (?domain_record - domain_record ?validator_token - validator_token)
    :precondition
      (and
        (record_validated_by ?domain_record ?validator_token)
      )
    :effect
      (and
        (validator_token_available ?validator_token)
        (not
          (record_validated_by ?domain_record ?validator_token)
        )
      )
  )
  (:action bind_approver_to_record
    :parameters (?domain_record - domain_record ?approver_token - approver_token)
    :precondition
      (and
        (record_validated ?domain_record)
        (approver_token_available ?approver_token)
      )
    :effect
      (and
        (record_approver_binding ?domain_record ?approver_token)
        (not
          (approver_token_available ?approver_token)
        )
      )
  )
  (:action release_approver_token
    :parameters (?domain_record - domain_record ?approver_token - approver_token)
    :precondition
      (and
        (record_approver_binding ?domain_record ?approver_token)
      )
    :effect
      (and
        (approver_token_available ?approver_token)
        (not
          (record_approver_binding ?domain_record ?approver_token)
        )
      )
  )
  (:action bind_attachment_type_a_to_workflow
    :parameters (?workflow_instance - workflow_instance ?attachment_type_a - attachment_type_a)
    :precondition
      (and
        (record_validated ?workflow_instance)
        (attachment_type_a_available ?attachment_type_a)
      )
    :effect
      (and
        (workflow_attachment_type_a_binding ?workflow_instance ?attachment_type_a)
        (not
          (attachment_type_a_available ?attachment_type_a)
        )
      )
  )
  (:action unbind_attachment_type_a_from_workflow
    :parameters (?workflow_instance - workflow_instance ?attachment_type_a - attachment_type_a)
    :precondition
      (and
        (workflow_attachment_type_a_binding ?workflow_instance ?attachment_type_a)
      )
    :effect
      (and
        (attachment_type_a_available ?attachment_type_a)
        (not
          (workflow_attachment_type_a_binding ?workflow_instance ?attachment_type_a)
        )
      )
  )
  (:action bind_binding_token_to_workflow
    :parameters (?workflow_instance - workflow_instance ?binding_token - binding_token)
    :precondition
      (and
        (record_validated ?workflow_instance)
        (binding_token_available ?binding_token)
      )
    :effect
      (and
        (workflow_binding_token_bound ?workflow_instance ?binding_token)
        (not
          (binding_token_available ?binding_token)
        )
      )
  )
  (:action unbind_binding_token_from_workflow
    :parameters (?workflow_instance - workflow_instance ?binding_token - binding_token)
    :precondition
      (and
        (workflow_binding_token_bound ?workflow_instance ?binding_token)
      )
    :effect
      (and
        (binding_token_available ?binding_token)
        (not
          (workflow_binding_token_bound ?workflow_instance ?binding_token)
        )
      )
  )
  (:action reserve_slot_a_for_primary
    :parameters (?primary_actor - primary_actor ?resource_slot_a - resource_slot_a ?validator_token - validator_token)
    :precondition
      (and
        (record_validated ?primary_actor)
        (record_validated_by ?primary_actor ?validator_token)
        (primary_actor_slot_a_assigned ?primary_actor ?resource_slot_a)
        (not
          (slot_a_reserved ?resource_slot_a)
        )
        (not
          (slot_a_locked ?resource_slot_a)
        )
      )
    :effect (slot_a_reserved ?resource_slot_a)
  )
  (:action confirm_primary_slot_assignment_with_approver
    :parameters (?primary_actor - primary_actor ?resource_slot_a - resource_slot_a ?approver_token - approver_token)
    :precondition
      (and
        (record_validated ?primary_actor)
        (record_approver_binding ?primary_actor ?approver_token)
        (primary_actor_slot_a_assigned ?primary_actor ?resource_slot_a)
        (slot_a_reserved ?resource_slot_a)
        (not
          (primary_actor_ready_for_assembly ?primary_actor)
        )
      )
    :effect
      (and
        (primary_actor_ready_for_assembly ?primary_actor)
        (primary_actor_slot_confirmed ?primary_actor)
      )
  )
  (:action attach_artifact_to_primary_and_lock_slot
    :parameters (?primary_actor - primary_actor ?resource_slot_a - resource_slot_a ?attachment_artifact - attachment_artifact)
    :precondition
      (and
        (record_validated ?primary_actor)
        (primary_actor_slot_a_assigned ?primary_actor ?resource_slot_a)
        (attachment_artifact_available ?attachment_artifact)
        (not
          (primary_actor_ready_for_assembly ?primary_actor)
        )
      )
    :effect
      (and
        (slot_a_locked ?resource_slot_a)
        (primary_actor_ready_for_assembly ?primary_actor)
        (primary_actor_attachment ?primary_actor ?attachment_artifact)
        (not
          (attachment_artifact_available ?attachment_artifact)
        )
      )
  )
  (:action process_primary_slot_with_attachment
    :parameters (?primary_actor - primary_actor ?resource_slot_a - resource_slot_a ?validator_token - validator_token ?attachment_artifact - attachment_artifact)
    :precondition
      (and
        (record_validated ?primary_actor)
        (record_validated_by ?primary_actor ?validator_token)
        (primary_actor_slot_a_assigned ?primary_actor ?resource_slot_a)
        (slot_a_locked ?resource_slot_a)
        (primary_actor_attachment ?primary_actor ?attachment_artifact)
        (not
          (primary_actor_slot_confirmed ?primary_actor)
        )
      )
    :effect
      (and
        (slot_a_reserved ?resource_slot_a)
        (primary_actor_slot_confirmed ?primary_actor)
        (attachment_artifact_available ?attachment_artifact)
        (not
          (primary_actor_attachment ?primary_actor ?attachment_artifact)
        )
      )
  )
  (:action reserve_slot_b_for_secondary
    :parameters (?secondary_actor - secondary_actor ?resource_slot_b - resource_slot_b ?validator_token - validator_token)
    :precondition
      (and
        (record_validated ?secondary_actor)
        (record_validated_by ?secondary_actor ?validator_token)
        (secondary_actor_slot_b_assigned ?secondary_actor ?resource_slot_b)
        (not
          (slot_b_reserved ?resource_slot_b)
        )
        (not
          (slot_b_locked ?resource_slot_b)
        )
      )
    :effect (slot_b_reserved ?resource_slot_b)
  )
  (:action confirm_secondary_slot_assignment_with_approver
    :parameters (?secondary_actor - secondary_actor ?resource_slot_b - resource_slot_b ?approver_token - approver_token)
    :precondition
      (and
        (record_validated ?secondary_actor)
        (record_approver_binding ?secondary_actor ?approver_token)
        (secondary_actor_slot_b_assigned ?secondary_actor ?resource_slot_b)
        (slot_b_reserved ?resource_slot_b)
        (not
          (secondary_actor_ready_for_assembly ?secondary_actor)
        )
      )
    :effect
      (and
        (secondary_actor_ready_for_assembly ?secondary_actor)
        (secondary_actor_slot_confirmed ?secondary_actor)
      )
  )
  (:action attach_artifact_to_secondary_and_lock_slot
    :parameters (?secondary_actor - secondary_actor ?resource_slot_b - resource_slot_b ?attachment_artifact - attachment_artifact)
    :precondition
      (and
        (record_validated ?secondary_actor)
        (secondary_actor_slot_b_assigned ?secondary_actor ?resource_slot_b)
        (attachment_artifact_available ?attachment_artifact)
        (not
          (secondary_actor_ready_for_assembly ?secondary_actor)
        )
      )
    :effect
      (and
        (slot_b_locked ?resource_slot_b)
        (secondary_actor_ready_for_assembly ?secondary_actor)
        (secondary_actor_attachment ?secondary_actor ?attachment_artifact)
        (not
          (attachment_artifact_available ?attachment_artifact)
        )
      )
  )
  (:action process_secondary_slot_with_attachment
    :parameters (?secondary_actor - secondary_actor ?resource_slot_b - resource_slot_b ?validator_token - validator_token ?attachment_artifact - attachment_artifact)
    :precondition
      (and
        (record_validated ?secondary_actor)
        (record_validated_by ?secondary_actor ?validator_token)
        (secondary_actor_slot_b_assigned ?secondary_actor ?resource_slot_b)
        (slot_b_locked ?resource_slot_b)
        (secondary_actor_attachment ?secondary_actor ?attachment_artifact)
        (not
          (secondary_actor_slot_confirmed ?secondary_actor)
        )
      )
    :effect
      (and
        (slot_b_reserved ?resource_slot_b)
        (secondary_actor_slot_confirmed ?secondary_actor)
        (attachment_artifact_available ?attachment_artifact)
        (not
          (secondary_actor_attachment ?secondary_actor ?attachment_artifact)
        )
      )
  )
  (:action prepare_deliverable
    :parameters (?primary_actor - primary_actor ?secondary_actor - secondary_actor ?resource_slot_a - resource_slot_a ?resource_slot_b - resource_slot_b ?deliverable - deliverable)
    :precondition
      (and
        (primary_actor_ready_for_assembly ?primary_actor)
        (secondary_actor_ready_for_assembly ?secondary_actor)
        (primary_actor_slot_a_assigned ?primary_actor ?resource_slot_a)
        (secondary_actor_slot_b_assigned ?secondary_actor ?resource_slot_b)
        (slot_a_reserved ?resource_slot_a)
        (slot_b_reserved ?resource_slot_b)
        (primary_actor_slot_confirmed ?primary_actor)
        (secondary_actor_slot_confirmed ?secondary_actor)
        (deliverable_pending ?deliverable)
      )
    :effect
      (and
        (deliverable_ready ?deliverable)
        (deliverable_slot_a_attached ?deliverable ?resource_slot_a)
        (deliverable_slot_b_attached ?deliverable ?resource_slot_b)
        (not
          (deliverable_pending ?deliverable)
        )
      )
  )
  (:action prepare_deliverable_and_set_gate_a
    :parameters (?primary_actor - primary_actor ?secondary_actor - secondary_actor ?resource_slot_a - resource_slot_a ?resource_slot_b - resource_slot_b ?deliverable - deliverable)
    :precondition
      (and
        (primary_actor_ready_for_assembly ?primary_actor)
        (secondary_actor_ready_for_assembly ?secondary_actor)
        (primary_actor_slot_a_assigned ?primary_actor ?resource_slot_a)
        (secondary_actor_slot_b_assigned ?secondary_actor ?resource_slot_b)
        (slot_a_locked ?resource_slot_a)
        (slot_b_reserved ?resource_slot_b)
        (not
          (primary_actor_slot_confirmed ?primary_actor)
        )
        (secondary_actor_slot_confirmed ?secondary_actor)
        (deliverable_pending ?deliverable)
      )
    :effect
      (and
        (deliverable_ready ?deliverable)
        (deliverable_slot_a_attached ?deliverable ?resource_slot_a)
        (deliverable_slot_b_attached ?deliverable ?resource_slot_b)
        (deliverable_readiness_a ?deliverable)
        (not
          (deliverable_pending ?deliverable)
        )
      )
  )
  (:action prepare_deliverable_and_set_gate_b
    :parameters (?primary_actor - primary_actor ?secondary_actor - secondary_actor ?resource_slot_a - resource_slot_a ?resource_slot_b - resource_slot_b ?deliverable - deliverable)
    :precondition
      (and
        (primary_actor_ready_for_assembly ?primary_actor)
        (secondary_actor_ready_for_assembly ?secondary_actor)
        (primary_actor_slot_a_assigned ?primary_actor ?resource_slot_a)
        (secondary_actor_slot_b_assigned ?secondary_actor ?resource_slot_b)
        (slot_a_reserved ?resource_slot_a)
        (slot_b_locked ?resource_slot_b)
        (primary_actor_slot_confirmed ?primary_actor)
        (not
          (secondary_actor_slot_confirmed ?secondary_actor)
        )
        (deliverable_pending ?deliverable)
      )
    :effect
      (and
        (deliverable_ready ?deliverable)
        (deliverable_slot_a_attached ?deliverable ?resource_slot_a)
        (deliverable_slot_b_attached ?deliverable ?resource_slot_b)
        (deliverable_readiness_b ?deliverable)
        (not
          (deliverable_pending ?deliverable)
        )
      )
  )
  (:action prepare_deliverable_and_set_both_gates
    :parameters (?primary_actor - primary_actor ?secondary_actor - secondary_actor ?resource_slot_a - resource_slot_a ?resource_slot_b - resource_slot_b ?deliverable - deliverable)
    :precondition
      (and
        (primary_actor_ready_for_assembly ?primary_actor)
        (secondary_actor_ready_for_assembly ?secondary_actor)
        (primary_actor_slot_a_assigned ?primary_actor ?resource_slot_a)
        (secondary_actor_slot_b_assigned ?secondary_actor ?resource_slot_b)
        (slot_a_locked ?resource_slot_a)
        (slot_b_locked ?resource_slot_b)
        (not
          (primary_actor_slot_confirmed ?primary_actor)
        )
        (not
          (secondary_actor_slot_confirmed ?secondary_actor)
        )
        (deliverable_pending ?deliverable)
      )
    :effect
      (and
        (deliverable_ready ?deliverable)
        (deliverable_slot_a_attached ?deliverable ?resource_slot_a)
        (deliverable_slot_b_attached ?deliverable ?resource_slot_b)
        (deliverable_readiness_a ?deliverable)
        (deliverable_readiness_b ?deliverable)
        (not
          (deliverable_pending ?deliverable)
        )
      )
  )
  (:action publish_deliverable
    :parameters (?deliverable - deliverable ?primary_actor - primary_actor ?validator_token - validator_token)
    :precondition
      (and
        (deliverable_ready ?deliverable)
        (primary_actor_ready_for_assembly ?primary_actor)
        (record_validated_by ?primary_actor ?validator_token)
        (not
          (deliverable_published ?deliverable)
        )
      )
    :effect (deliverable_published ?deliverable)
  )
  (:action process_subdocument_and_attach_to_deliverable
    :parameters (?workflow_instance - workflow_instance ?subdocument - subdocument ?deliverable - deliverable)
    :precondition
      (and
        (record_validated ?workflow_instance)
        (workflow_deliverable_attached ?workflow_instance ?deliverable)
        (workflow_subdocument_attached ?workflow_instance ?subdocument)
        (subdocument_unprocessed ?subdocument)
        (deliverable_ready ?deliverable)
        (deliverable_published ?deliverable)
        (not
          (subdocument_processed ?subdocument)
        )
      )
    :effect
      (and
        (subdocument_processed ?subdocument)
        (subdocument_linked_to_deliverable ?subdocument ?deliverable)
        (not
          (subdocument_unprocessed ?subdocument)
        )
      )
  )
  (:action mark_workflow_document_ready
    :parameters (?workflow_instance - workflow_instance ?subdocument - subdocument ?deliverable - deliverable ?validator_token - validator_token)
    :precondition
      (and
        (record_validated ?workflow_instance)
        (workflow_subdocument_attached ?workflow_instance ?subdocument)
        (subdocument_processed ?subdocument)
        (subdocument_linked_to_deliverable ?subdocument ?deliverable)
        (record_validated_by ?workflow_instance ?validator_token)
        (not
          (deliverable_readiness_a ?deliverable)
        )
        (not
          (workflow_attachment_prepared ?workflow_instance)
        )
      )
    :effect (workflow_attachment_prepared ?workflow_instance)
  )
  (:action apply_policy_definition_to_workflow
    :parameters (?workflow_instance - workflow_instance ?policy_definition - policy_definition)
    :precondition
      (and
        (record_validated ?workflow_instance)
        (policy_definition_available ?policy_definition)
        (not
          (policy_applied ?workflow_instance)
        )
      )
    :effect
      (and
        (policy_applied ?workflow_instance)
        (workflow_policy_definition_binding ?workflow_instance ?policy_definition)
        (not
          (policy_definition_available ?policy_definition)
        )
      )
  )
  (:action enforce_policy_and_prepare_workflow
    :parameters (?workflow_instance - workflow_instance ?subdocument - subdocument ?deliverable - deliverable ?validator_token - validator_token ?policy_definition - policy_definition)
    :precondition
      (and
        (record_validated ?workflow_instance)
        (workflow_subdocument_attached ?workflow_instance ?subdocument)
        (subdocument_processed ?subdocument)
        (subdocument_linked_to_deliverable ?subdocument ?deliverable)
        (record_validated_by ?workflow_instance ?validator_token)
        (deliverable_readiness_a ?deliverable)
        (policy_applied ?workflow_instance)
        (workflow_policy_definition_binding ?workflow_instance ?policy_definition)
        (not
          (workflow_attachment_prepared ?workflow_instance)
        )
      )
    :effect
      (and
        (workflow_attachment_prepared ?workflow_instance)
        (policy_enforced_on_workflow ?workflow_instance)
      )
  )
  (:action approve_attachment_processing
    :parameters (?workflow_instance - workflow_instance ?attachment_type_a - attachment_type_a ?approver_token - approver_token ?subdocument - subdocument ?deliverable - deliverable)
    :precondition
      (and
        (workflow_attachment_prepared ?workflow_instance)
        (workflow_attachment_type_a_binding ?workflow_instance ?attachment_type_a)
        (record_approver_binding ?workflow_instance ?approver_token)
        (workflow_subdocument_attached ?workflow_instance ?subdocument)
        (subdocument_linked_to_deliverable ?subdocument ?deliverable)
        (not
          (deliverable_readiness_b ?deliverable)
        )
        (not
          (workflow_attachment_validated ?workflow_instance)
        )
      )
    :effect (workflow_attachment_validated ?workflow_instance)
  )
  (:action approve_attachment_processing_with_gate_b
    :parameters (?workflow_instance - workflow_instance ?attachment_type_a - attachment_type_a ?approver_token - approver_token ?subdocument - subdocument ?deliverable - deliverable)
    :precondition
      (and
        (workflow_attachment_prepared ?workflow_instance)
        (workflow_attachment_type_a_binding ?workflow_instance ?attachment_type_a)
        (record_approver_binding ?workflow_instance ?approver_token)
        (workflow_subdocument_attached ?workflow_instance ?subdocument)
        (subdocument_linked_to_deliverable ?subdocument ?deliverable)
        (deliverable_readiness_b ?deliverable)
        (not
          (workflow_attachment_validated ?workflow_instance)
        )
      )
    :effect (workflow_attachment_validated ?workflow_instance)
  )
  (:action advance_workflow_to_approval_stage
    :parameters (?workflow_instance - workflow_instance ?binding_token - binding_token ?subdocument - subdocument ?deliverable - deliverable)
    :precondition
      (and
        (workflow_attachment_validated ?workflow_instance)
        (workflow_binding_token_bound ?workflow_instance ?binding_token)
        (workflow_subdocument_attached ?workflow_instance ?subdocument)
        (subdocument_linked_to_deliverable ?subdocument ?deliverable)
        (not
          (deliverable_readiness_a ?deliverable)
        )
        (not
          (deliverable_readiness_b ?deliverable)
        )
        (not
          (workflow_approval_ready ?workflow_instance)
        )
      )
    :effect (workflow_approval_ready ?workflow_instance)
  )
  (:action advance_workflow_and_record_approval_confirmation
    :parameters (?workflow_instance - workflow_instance ?binding_token - binding_token ?subdocument - subdocument ?deliverable - deliverable)
    :precondition
      (and
        (workflow_attachment_validated ?workflow_instance)
        (workflow_binding_token_bound ?workflow_instance ?binding_token)
        (workflow_subdocument_attached ?workflow_instance ?subdocument)
        (subdocument_linked_to_deliverable ?subdocument ?deliverable)
        (deliverable_readiness_a ?deliverable)
        (not
          (deliverable_readiness_b ?deliverable)
        )
        (not
          (workflow_approval_ready ?workflow_instance)
        )
      )
    :effect
      (and
        (workflow_approval_ready ?workflow_instance)
        (workflow_approvals_completed ?workflow_instance)
      )
  )
  (:action confirm_workflow_approval_and_record
    :parameters (?workflow_instance - workflow_instance ?binding_token - binding_token ?subdocument - subdocument ?deliverable - deliverable)
    :precondition
      (and
        (workflow_attachment_validated ?workflow_instance)
        (workflow_binding_token_bound ?workflow_instance ?binding_token)
        (workflow_subdocument_attached ?workflow_instance ?subdocument)
        (subdocument_linked_to_deliverable ?subdocument ?deliverable)
        (not
          (deliverable_readiness_a ?deliverable)
        )
        (deliverable_readiness_b ?deliverable)
        (not
          (workflow_approval_ready ?workflow_instance)
        )
      )
    :effect
      (and
        (workflow_approval_ready ?workflow_instance)
        (workflow_approvals_completed ?workflow_instance)
      )
  )
  (:action finalize_workflow_approval_confirmation
    :parameters (?workflow_instance - workflow_instance ?binding_token - binding_token ?subdocument - subdocument ?deliverable - deliverable)
    :precondition
      (and
        (workflow_attachment_validated ?workflow_instance)
        (workflow_binding_token_bound ?workflow_instance ?binding_token)
        (workflow_subdocument_attached ?workflow_instance ?subdocument)
        (subdocument_linked_to_deliverable ?subdocument ?deliverable)
        (deliverable_readiness_a ?deliverable)
        (deliverable_readiness_b ?deliverable)
        (not
          (workflow_approval_ready ?workflow_instance)
        )
      )
    :effect
      (and
        (workflow_approval_ready ?workflow_instance)
        (workflow_approvals_completed ?workflow_instance)
      )
  )
  (:action promote_workflow_to_finalization
    :parameters (?workflow_instance - workflow_instance)
    :precondition
      (and
        (workflow_approval_ready ?workflow_instance)
        (not
          (workflow_approvals_completed ?workflow_instance)
        )
        (not
          (workflow_finalized ?workflow_instance)
        )
      )
    :effect
      (and
        (workflow_finalized ?workflow_instance)
        (ready_for_audit ?workflow_instance)
      )
  )
  (:action apply_configuration_profile_to_workflow
    :parameters (?workflow_instance - workflow_instance ?configuration_profile - configuration_profile)
    :precondition
      (and
        (workflow_approval_ready ?workflow_instance)
        (workflow_approvals_completed ?workflow_instance)
        (configuration_profile_available ?configuration_profile)
      )
    :effect
      (and
        (workflow_configuration_applied ?workflow_instance ?configuration_profile)
        (not
          (configuration_profile_available ?configuration_profile)
        )
      )
  )
  (:action consolidate_workflow_finalization
    :parameters (?workflow_instance - workflow_instance ?primary_actor - primary_actor ?secondary_actor - secondary_actor ?validator_token - validator_token ?configuration_profile - configuration_profile)
    :precondition
      (and
        (workflow_approval_ready ?workflow_instance)
        (workflow_approvals_completed ?workflow_instance)
        (workflow_configuration_applied ?workflow_instance ?configuration_profile)
        (workflow_primary_actor_link ?workflow_instance ?primary_actor)
        (workflow_secondary_actor_link ?workflow_instance ?secondary_actor)
        (primary_actor_slot_confirmed ?primary_actor)
        (secondary_actor_slot_confirmed ?secondary_actor)
        (record_validated_by ?workflow_instance ?validator_token)
        (not
          (workflow_processing_complete ?workflow_instance)
        )
      )
    :effect (workflow_processing_complete ?workflow_instance)
  )
  (:action finalize_workflow
    :parameters (?workflow_instance - workflow_instance)
    :precondition
      (and
        (workflow_approval_ready ?workflow_instance)
        (workflow_processing_complete ?workflow_instance)
        (not
          (workflow_finalized ?workflow_instance)
        )
      )
    :effect
      (and
        (workflow_finalized ?workflow_instance)
        (ready_for_audit ?workflow_instance)
      )
  )
  (:action claim_policy_binding_for_workflow
    :parameters (?workflow_instance - workflow_instance ?policy_binding - policy_binding ?validator_token - validator_token)
    :precondition
      (and
        (record_validated ?workflow_instance)
        (record_validated_by ?workflow_instance ?validator_token)
        (policy_binding_available ?policy_binding)
        (workflow_policy_binding_association ?workflow_instance ?policy_binding)
        (not
          (policy_application_flag ?workflow_instance)
        )
      )
    :effect
      (and
        (policy_application_flag ?workflow_instance)
        (not
          (policy_binding_available ?policy_binding)
        )
      )
  )
  (:action register_workflow_policy_approval
    :parameters (?workflow_instance - workflow_instance ?approver_token - approver_token)
    :precondition
      (and
        (policy_application_flag ?workflow_instance)
        (record_approver_binding ?workflow_instance ?approver_token)
        (not
          (policy_approval_flag ?workflow_instance)
        )
      )
    :effect (policy_approval_flag ?workflow_instance)
  )
  (:action commit_workflow_policy_approval
    :parameters (?workflow_instance - workflow_instance ?binding_token - binding_token)
    :precondition
      (and
        (policy_approval_flag ?workflow_instance)
        (workflow_binding_token_bound ?workflow_instance ?binding_token)
        (not
          (policy_committed_flag ?workflow_instance)
        )
      )
    :effect (policy_committed_flag ?workflow_instance)
  )
  (:action finalize_workflow_after_policy_commit
    :parameters (?workflow_instance - workflow_instance)
    :precondition
      (and
        (policy_committed_flag ?workflow_instance)
        (not
          (workflow_finalized ?workflow_instance)
        )
      )
    :effect
      (and
        (workflow_finalized ?workflow_instance)
        (ready_for_audit ?workflow_instance)
      )
  )
  (:action mark_primary_actor_ready_for_audit
    :parameters (?primary_actor - primary_actor ?deliverable - deliverable)
    :precondition
      (and
        (primary_actor_ready_for_assembly ?primary_actor)
        (primary_actor_slot_confirmed ?primary_actor)
        (deliverable_ready ?deliverable)
        (deliverable_published ?deliverable)
        (not
          (ready_for_audit ?primary_actor)
        )
      )
    :effect (ready_for_audit ?primary_actor)
  )
  (:action mark_secondary_actor_ready_for_audit
    :parameters (?secondary_actor - secondary_actor ?deliverable - deliverable)
    :precondition
      (and
        (secondary_actor_ready_for_assembly ?secondary_actor)
        (secondary_actor_slot_confirmed ?secondary_actor)
        (deliverable_ready ?deliverable)
        (deliverable_published ?deliverable)
        (not
          (ready_for_audit ?secondary_actor)
        )
      )
    :effect (ready_for_audit ?secondary_actor)
  )
  (:action bind_audit_token_to_record
    :parameters (?domain_record - domain_record ?audit_token - audit_token ?validator_token - validator_token)
    :precondition
      (and
        (ready_for_audit ?domain_record)
        (record_validated_by ?domain_record ?validator_token)
        (audit_token_available ?audit_token)
        (not
          (audit_attached ?domain_record)
        )
      )
    :effect
      (and
        (audit_attached ?domain_record)
        (record_audit_binding ?domain_record ?audit_token)
        (not
          (audit_token_available ?audit_token)
        )
      )
  )
  (:action complete_primary_actor_and_release_tokens
    :parameters (?primary_actor - primary_actor ?assignee_token - assignee_token ?audit_token - audit_token)
    :precondition
      (and
        (audit_attached ?primary_actor)
        (record_assigned_to ?primary_actor ?assignee_token)
        (record_audit_binding ?primary_actor ?audit_token)
        (not
          (marked_completed ?primary_actor)
        )
      )
    :effect
      (and
        (marked_completed ?primary_actor)
        (assignee_token_available ?assignee_token)
        (audit_token_available ?audit_token)
      )
  )
  (:action complete_secondary_actor_and_release_tokens
    :parameters (?secondary_actor - secondary_actor ?assignee_token - assignee_token ?audit_token - audit_token)
    :precondition
      (and
        (audit_attached ?secondary_actor)
        (record_assigned_to ?secondary_actor ?assignee_token)
        (record_audit_binding ?secondary_actor ?audit_token)
        (not
          (marked_completed ?secondary_actor)
        )
      )
    :effect
      (and
        (marked_completed ?secondary_actor)
        (assignee_token_available ?assignee_token)
        (audit_token_available ?audit_token)
      )
  )
  (:action complete_workflow_and_release_tokens
    :parameters (?workflow_instance - workflow_instance ?assignee_token - assignee_token ?audit_token - audit_token)
    :precondition
      (and
        (audit_attached ?workflow_instance)
        (record_assigned_to ?workflow_instance ?assignee_token)
        (record_audit_binding ?workflow_instance ?audit_token)
        (not
          (marked_completed ?workflow_instance)
        )
      )
    :effect
      (and
        (marked_completed ?workflow_instance)
        (assignee_token_available ?assignee_token)
        (audit_token_available ?audit_token)
      )
  )
)

(define (domain pharmaceutics_quality_assurance_document_effective_date_alignment_check)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object qa_role_and_token_group - entity functional_role_group - entity attachment_type_group - entity document_family - entity controlled_document - document_family approver_slot - qa_role_and_token_group validation_specialist - qa_role_and_token_group signatory_role - qa_role_and_token_group regulatory_attachment - qa_role_and_token_group release_credential - qa_role_and_token_group effective_date_token - qa_role_and_token_group training_record - qa_role_and_token_group regulatory_hold - qa_role_and_token_group evidence_artifact - functional_role_group external_evidence - functional_role_group inspection_flag - functional_role_group validation_activity_a - attachment_type_group validation_activity_b - attachment_type_group dms_package - attachment_type_group document_owner_supertype - controlled_document document_record_supertype - controlled_document department_owner_a - document_owner_supertype department_owner_b - document_owner_supertype document_control_record - document_record_supertype)

  (:predicates
    (document_registered ?controlled_document - controlled_document)
    (technical_review_completed ?controlled_document - controlled_document)
    (review_assigned ?controlled_document - controlled_document)
    (document_released ?controlled_document - controlled_document)
    (release_authorized ?controlled_document - controlled_document)
    (release_ready ?controlled_document - controlled_document)
    (approver_slot_available ?approver_slot - approver_slot)
    (document_assigned_approver ?controlled_document - controlled_document ?approver_slot - approver_slot)
    (validation_specialist_available ?validation_specialist - validation_specialist)
    (validation_specialist_assigned ?controlled_document - controlled_document ?validation_specialist - validation_specialist)
    (signatory_role_available ?signatory_role - signatory_role)
    (document_assigned_signatory ?controlled_document - controlled_document ?signatory_role - signatory_role)
    (evidence_artifact_available ?evidence_artifact - evidence_artifact)
    (department_owner_manufacturing_evidence_linked ?department_owner_a - department_owner_a ?evidence_artifact - evidence_artifact)
    (department_owner_quality_evidence_linked ?department_owner_b - department_owner_b ?evidence_artifact - evidence_artifact)
    (department_owner_manufacturing_validation_activity_linked ?department_owner_a - department_owner_a ?validation_activity_a - validation_activity_a)
    (validation_activity_ready ?validation_activity_a - validation_activity_a)
    (validation_activity_has_evidence ?validation_activity_a - validation_activity_a)
    (department_owner_manufacturing_validation_completed ?department_owner_a - department_owner_a)
    (department_owner_quality_validation_activity_linked ?department_owner_b - department_owner_b ?validation_activity_b - validation_activity_b)
    (validation_activity_b_ready ?validation_activity_b - validation_activity_b)
    (validation_activity_b_has_evidence ?validation_activity_b - validation_activity_b)
    (department_owner_quality_validation_completed ?department_owner_b - department_owner_b)
    (dms_package_pending_assembly ?dms_package - dms_package)
    (dms_package_active ?dms_package - dms_package)
    (dms_package_linked_activity_a ?dms_package - dms_package ?validation_activity_a - validation_activity_a)
    (dms_package_linked_activity_b ?dms_package - dms_package ?validation_activity_b - validation_activity_b)
    (dms_package_activity_a_evidence_attached ?dms_package - dms_package)
    (dms_package_activity_b_evidence_attached ?dms_package - dms_package)
    (dms_package_quality_check_passed ?dms_package - dms_package)
    (dcr_linked_owner_a ?document_control_record - document_control_record ?department_owner_a - department_owner_a)
    (dcr_linked_owner_b ?document_control_record - document_control_record ?department_owner_b - department_owner_b)
    (dcr_linked_package ?document_control_record - document_control_record ?dms_package - dms_package)
    (external_evidence_available ?external_evidence - external_evidence)
    (dcr_linked_external_evidence ?document_control_record - document_control_record ?external_evidence - external_evidence)
    (external_evidence_verified ?external_evidence - external_evidence)
    (external_evidence_linked_to_package ?external_evidence - external_evidence ?dms_package - dms_package)
    (dcr_evidence_consolidated ?document_control_record - document_control_record)
    (dcr_attachment_approved ?document_control_record - document_control_record)
    (dcr_compliance_checked ?document_control_record - document_control_record)
    (dcr_regulatory_attachment_assigned ?document_control_record - document_control_record)
    (dcr_regulatory_attachment_reviewed ?document_control_record - document_control_record)
    (dcr_requirements_verified ?document_control_record - document_control_record)
    (dcr_training_and_authorization_confirmed ?document_control_record - document_control_record)
    (inspection_flag_active ?inspection_flag - inspection_flag)
    (dcr_linked_inspection_flag ?document_control_record - document_control_record ?inspection_flag - inspection_flag)
    (inspection_allocation_confirmed ?document_control_record - document_control_record)
    (dcr_signoff_in_progress ?document_control_record - document_control_record)
    (dcr_signoff_completed ?document_control_record - document_control_record)
    (regulatory_attachment_available ?regulatory_attachment - regulatory_attachment)
    (dcr_regulatory_attachment_linked ?document_control_record - document_control_record ?regulatory_attachment - regulatory_attachment)
    (release_credential_available ?release_credential - release_credential)
    (dcr_release_credential_linked ?document_control_record - document_control_record ?release_credential - release_credential)
    (training_record_available ?training_record - training_record)
    (dcr_training_record_linked ?document_control_record - document_control_record ?training_record - training_record)
    (regulatory_hold_active ?regulatory_hold - regulatory_hold)
    (dcr_regulatory_hold_linked ?document_control_record - document_control_record ?regulatory_hold - regulatory_hold)
    (effective_date_token_available ?effective_date_token - effective_date_token)
    (document_effective_date_linked ?controlled_document - controlled_document ?effective_date_token - effective_date_token)
    (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a - department_owner_a)
    (department_owner_quality_ready_for_package_assembly ?department_owner_b - department_owner_b)
    (dcr_finalized ?document_control_record - document_control_record)
  )
  (:action register_controlled_document
    :parameters (?controlled_document - controlled_document)
    :precondition
      (and
        (not
          (document_registered ?controlled_document)
        )
        (not
          (document_released ?controlled_document)
        )
      )
    :effect (document_registered ?controlled_document)
  )
  (:action assign_approver_slot_to_document
    :parameters (?controlled_document - controlled_document ?approver_slot - approver_slot)
    :precondition
      (and
        (document_registered ?controlled_document)
        (not
          (review_assigned ?controlled_document)
        )
        (approver_slot_available ?approver_slot)
      )
    :effect
      (and
        (review_assigned ?controlled_document)
        (document_assigned_approver ?controlled_document ?approver_slot)
        (not
          (approver_slot_available ?approver_slot)
        )
      )
  )
  (:action assign_validation_specialist_to_document
    :parameters (?controlled_document - controlled_document ?validation_specialist - validation_specialist)
    :precondition
      (and
        (document_registered ?controlled_document)
        (review_assigned ?controlled_document)
        (validation_specialist_available ?validation_specialist)
      )
    :effect
      (and
        (validation_specialist_assigned ?controlled_document ?validation_specialist)
        (not
          (validation_specialist_available ?validation_specialist)
        )
      )
  )
  (:action complete_technical_review
    :parameters (?controlled_document - controlled_document ?validation_specialist - validation_specialist)
    :precondition
      (and
        (document_registered ?controlled_document)
        (review_assigned ?controlled_document)
        (validation_specialist_assigned ?controlled_document ?validation_specialist)
        (not
          (technical_review_completed ?controlled_document)
        )
      )
    :effect (technical_review_completed ?controlled_document)
  )
  (:action unassign_validation_specialist
    :parameters (?controlled_document - controlled_document ?validation_specialist - validation_specialist)
    :precondition
      (and
        (validation_specialist_assigned ?controlled_document ?validation_specialist)
      )
    :effect
      (and
        (validation_specialist_available ?validation_specialist)
        (not
          (validation_specialist_assigned ?controlled_document ?validation_specialist)
        )
      )
  )
  (:action assign_signatory_to_document
    :parameters (?controlled_document - controlled_document ?signatory_role - signatory_role)
    :precondition
      (and
        (technical_review_completed ?controlled_document)
        (signatory_role_available ?signatory_role)
      )
    :effect
      (and
        (document_assigned_signatory ?controlled_document ?signatory_role)
        (not
          (signatory_role_available ?signatory_role)
        )
      )
  )
  (:action unassign_signatory_from_document
    :parameters (?controlled_document - controlled_document ?signatory_role - signatory_role)
    :precondition
      (and
        (document_assigned_signatory ?controlled_document ?signatory_role)
      )
    :effect
      (and
        (signatory_role_available ?signatory_role)
        (not
          (document_assigned_signatory ?controlled_document ?signatory_role)
        )
      )
  )
  (:action link_training_record_to_dcr
    :parameters (?document_control_record - document_control_record ?training_record - training_record)
    :precondition
      (and
        (technical_review_completed ?document_control_record)
        (training_record_available ?training_record)
      )
    :effect
      (and
        (dcr_training_record_linked ?document_control_record ?training_record)
        (not
          (training_record_available ?training_record)
        )
      )
  )
  (:action unlink_training_record_from_dcr
    :parameters (?document_control_record - document_control_record ?training_record - training_record)
    :precondition
      (and
        (dcr_training_record_linked ?document_control_record ?training_record)
      )
    :effect
      (and
        (training_record_available ?training_record)
        (not
          (dcr_training_record_linked ?document_control_record ?training_record)
        )
      )
  )
  (:action link_regulatory_hold_to_dcr
    :parameters (?document_control_record - document_control_record ?regulatory_hold - regulatory_hold)
    :precondition
      (and
        (technical_review_completed ?document_control_record)
        (regulatory_hold_active ?regulatory_hold)
      )
    :effect
      (and
        (dcr_regulatory_hold_linked ?document_control_record ?regulatory_hold)
        (not
          (regulatory_hold_active ?regulatory_hold)
        )
      )
  )
  (:action unlink_regulatory_hold_from_dcr
    :parameters (?document_control_record - document_control_record ?regulatory_hold - regulatory_hold)
    :precondition
      (and
        (dcr_regulatory_hold_linked ?document_control_record ?regulatory_hold)
      )
    :effect
      (and
        (regulatory_hold_active ?regulatory_hold)
        (not
          (dcr_regulatory_hold_linked ?document_control_record ?regulatory_hold)
        )
      )
  )
  (:action prepare_validation_activity_a_for_owner
    :parameters (?department_owner_a - department_owner_a ?validation_activity_a - validation_activity_a ?validation_specialist - validation_specialist)
    :precondition
      (and
        (technical_review_completed ?department_owner_a)
        (validation_specialist_assigned ?department_owner_a ?validation_specialist)
        (department_owner_manufacturing_validation_activity_linked ?department_owner_a ?validation_activity_a)
        (not
          (validation_activity_ready ?validation_activity_a)
        )
        (not
          (validation_activity_has_evidence ?validation_activity_a)
        )
      )
    :effect (validation_activity_ready ?validation_activity_a)
  )
  (:action confirm_validation_activity_a_with_signatory
    :parameters (?department_owner_a - department_owner_a ?validation_activity_a - validation_activity_a ?signatory_role - signatory_role)
    :precondition
      (and
        (technical_review_completed ?department_owner_a)
        (document_assigned_signatory ?department_owner_a ?signatory_role)
        (department_owner_manufacturing_validation_activity_linked ?department_owner_a ?validation_activity_a)
        (validation_activity_ready ?validation_activity_a)
        (not
          (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a)
        )
      )
    :effect
      (and
        (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a)
        (department_owner_manufacturing_validation_completed ?department_owner_a)
      )
  )
  (:action attach_evidence_artifact_to_activity_a
    :parameters (?department_owner_a - department_owner_a ?validation_activity_a - validation_activity_a ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (technical_review_completed ?department_owner_a)
        (department_owner_manufacturing_validation_activity_linked ?department_owner_a ?validation_activity_a)
        (evidence_artifact_available ?evidence_artifact)
        (not
          (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a)
        )
      )
    :effect
      (and
        (validation_activity_has_evidence ?validation_activity_a)
        (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a)
        (department_owner_manufacturing_evidence_linked ?department_owner_a ?evidence_artifact)
        (not
          (evidence_artifact_available ?evidence_artifact)
        )
      )
  )
  (:action complete_validation_activity_a_with_evidence
    :parameters (?department_owner_a - department_owner_a ?validation_activity_a - validation_activity_a ?validation_specialist - validation_specialist ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (technical_review_completed ?department_owner_a)
        (validation_specialist_assigned ?department_owner_a ?validation_specialist)
        (department_owner_manufacturing_validation_activity_linked ?department_owner_a ?validation_activity_a)
        (validation_activity_has_evidence ?validation_activity_a)
        (department_owner_manufacturing_evidence_linked ?department_owner_a ?evidence_artifact)
        (not
          (department_owner_manufacturing_validation_completed ?department_owner_a)
        )
      )
    :effect
      (and
        (validation_activity_ready ?validation_activity_a)
        (department_owner_manufacturing_validation_completed ?department_owner_a)
        (evidence_artifact_available ?evidence_artifact)
        (not
          (department_owner_manufacturing_evidence_linked ?department_owner_a ?evidence_artifact)
        )
      )
  )
  (:action prepare_validation_activity_b_for_owner
    :parameters (?department_owner_b - department_owner_b ?validation_activity_b - validation_activity_b ?validation_specialist - validation_specialist)
    :precondition
      (and
        (technical_review_completed ?department_owner_b)
        (validation_specialist_assigned ?department_owner_b ?validation_specialist)
        (department_owner_quality_validation_activity_linked ?department_owner_b ?validation_activity_b)
        (not
          (validation_activity_b_ready ?validation_activity_b)
        )
        (not
          (validation_activity_b_has_evidence ?validation_activity_b)
        )
      )
    :effect (validation_activity_b_ready ?validation_activity_b)
  )
  (:action confirm_validation_activity_b_with_signatory
    :parameters (?department_owner_b - department_owner_b ?validation_activity_b - validation_activity_b ?signatory_role - signatory_role)
    :precondition
      (and
        (technical_review_completed ?department_owner_b)
        (document_assigned_signatory ?department_owner_b ?signatory_role)
        (department_owner_quality_validation_activity_linked ?department_owner_b ?validation_activity_b)
        (validation_activity_b_ready ?validation_activity_b)
        (not
          (department_owner_quality_ready_for_package_assembly ?department_owner_b)
        )
      )
    :effect
      (and
        (department_owner_quality_ready_for_package_assembly ?department_owner_b)
        (department_owner_quality_validation_completed ?department_owner_b)
      )
  )
  (:action attach_evidence_artifact_to_activity_b
    :parameters (?department_owner_b - department_owner_b ?validation_activity_b - validation_activity_b ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (technical_review_completed ?department_owner_b)
        (department_owner_quality_validation_activity_linked ?department_owner_b ?validation_activity_b)
        (evidence_artifact_available ?evidence_artifact)
        (not
          (department_owner_quality_ready_for_package_assembly ?department_owner_b)
        )
      )
    :effect
      (and
        (validation_activity_b_has_evidence ?validation_activity_b)
        (department_owner_quality_ready_for_package_assembly ?department_owner_b)
        (department_owner_quality_evidence_linked ?department_owner_b ?evidence_artifact)
        (not
          (evidence_artifact_available ?evidence_artifact)
        )
      )
  )
  (:action complete_validation_activity_b_with_evidence
    :parameters (?department_owner_b - department_owner_b ?validation_activity_b - validation_activity_b ?validation_specialist - validation_specialist ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (technical_review_completed ?department_owner_b)
        (validation_specialist_assigned ?department_owner_b ?validation_specialist)
        (department_owner_quality_validation_activity_linked ?department_owner_b ?validation_activity_b)
        (validation_activity_b_has_evidence ?validation_activity_b)
        (department_owner_quality_evidence_linked ?department_owner_b ?evidence_artifact)
        (not
          (department_owner_quality_validation_completed ?department_owner_b)
        )
      )
    :effect
      (and
        (validation_activity_b_ready ?validation_activity_b)
        (department_owner_quality_validation_completed ?department_owner_b)
        (evidence_artifact_available ?evidence_artifact)
        (not
          (department_owner_quality_evidence_linked ?department_owner_b ?evidence_artifact)
        )
      )
  )
  (:action create_dms_package_from_owners_and_activities
    :parameters (?department_owner_a - department_owner_a ?department_owner_b - department_owner_b ?validation_activity_a - validation_activity_a ?validation_activity_b - validation_activity_b ?dms_package - dms_package)
    :precondition
      (and
        (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a)
        (department_owner_quality_ready_for_package_assembly ?department_owner_b)
        (department_owner_manufacturing_validation_activity_linked ?department_owner_a ?validation_activity_a)
        (department_owner_quality_validation_activity_linked ?department_owner_b ?validation_activity_b)
        (validation_activity_ready ?validation_activity_a)
        (validation_activity_b_ready ?validation_activity_b)
        (department_owner_manufacturing_validation_completed ?department_owner_a)
        (department_owner_quality_validation_completed ?department_owner_b)
        (dms_package_pending_assembly ?dms_package)
      )
    :effect
      (and
        (dms_package_active ?dms_package)
        (dms_package_linked_activity_a ?dms_package ?validation_activity_a)
        (dms_package_linked_activity_b ?dms_package ?validation_activity_b)
        (not
          (dms_package_pending_assembly ?dms_package)
        )
      )
  )
  (:action create_dms_package_with_activity_a_evidence
    :parameters (?department_owner_a - department_owner_a ?department_owner_b - department_owner_b ?validation_activity_a - validation_activity_a ?validation_activity_b - validation_activity_b ?dms_package - dms_package)
    :precondition
      (and
        (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a)
        (department_owner_quality_ready_for_package_assembly ?department_owner_b)
        (department_owner_manufacturing_validation_activity_linked ?department_owner_a ?validation_activity_a)
        (department_owner_quality_validation_activity_linked ?department_owner_b ?validation_activity_b)
        (validation_activity_has_evidence ?validation_activity_a)
        (validation_activity_b_ready ?validation_activity_b)
        (not
          (department_owner_manufacturing_validation_completed ?department_owner_a)
        )
        (department_owner_quality_validation_completed ?department_owner_b)
        (dms_package_pending_assembly ?dms_package)
      )
    :effect
      (and
        (dms_package_active ?dms_package)
        (dms_package_linked_activity_a ?dms_package ?validation_activity_a)
        (dms_package_linked_activity_b ?dms_package ?validation_activity_b)
        (dms_package_activity_a_evidence_attached ?dms_package)
        (not
          (dms_package_pending_assembly ?dms_package)
        )
      )
  )
  (:action create_dms_package_with_activity_b_evidence
    :parameters (?department_owner_a - department_owner_a ?department_owner_b - department_owner_b ?validation_activity_a - validation_activity_a ?validation_activity_b - validation_activity_b ?dms_package - dms_package)
    :precondition
      (and
        (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a)
        (department_owner_quality_ready_for_package_assembly ?department_owner_b)
        (department_owner_manufacturing_validation_activity_linked ?department_owner_a ?validation_activity_a)
        (department_owner_quality_validation_activity_linked ?department_owner_b ?validation_activity_b)
        (validation_activity_ready ?validation_activity_a)
        (validation_activity_b_has_evidence ?validation_activity_b)
        (department_owner_manufacturing_validation_completed ?department_owner_a)
        (not
          (department_owner_quality_validation_completed ?department_owner_b)
        )
        (dms_package_pending_assembly ?dms_package)
      )
    :effect
      (and
        (dms_package_active ?dms_package)
        (dms_package_linked_activity_a ?dms_package ?validation_activity_a)
        (dms_package_linked_activity_b ?dms_package ?validation_activity_b)
        (dms_package_activity_b_evidence_attached ?dms_package)
        (not
          (dms_package_pending_assembly ?dms_package)
        )
      )
  )
  (:action create_dms_package_with_combined_evidence
    :parameters (?department_owner_a - department_owner_a ?department_owner_b - department_owner_b ?validation_activity_a - validation_activity_a ?validation_activity_b - validation_activity_b ?dms_package - dms_package)
    :precondition
      (and
        (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a)
        (department_owner_quality_ready_for_package_assembly ?department_owner_b)
        (department_owner_manufacturing_validation_activity_linked ?department_owner_a ?validation_activity_a)
        (department_owner_quality_validation_activity_linked ?department_owner_b ?validation_activity_b)
        (validation_activity_has_evidence ?validation_activity_a)
        (validation_activity_b_has_evidence ?validation_activity_b)
        (not
          (department_owner_manufacturing_validation_completed ?department_owner_a)
        )
        (not
          (department_owner_quality_validation_completed ?department_owner_b)
        )
        (dms_package_pending_assembly ?dms_package)
      )
    :effect
      (and
        (dms_package_active ?dms_package)
        (dms_package_linked_activity_a ?dms_package ?validation_activity_a)
        (dms_package_linked_activity_b ?dms_package ?validation_activity_b)
        (dms_package_activity_a_evidence_attached ?dms_package)
        (dms_package_activity_b_evidence_attached ?dms_package)
        (not
          (dms_package_pending_assembly ?dms_package)
        )
      )
  )
  (:action perform_package_quality_check
    :parameters (?dms_package - dms_package ?department_owner_a - department_owner_a ?validation_specialist - validation_specialist)
    :precondition
      (and
        (dms_package_active ?dms_package)
        (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a)
        (validation_specialist_assigned ?department_owner_a ?validation_specialist)
        (not
          (dms_package_quality_check_passed ?dms_package)
        )
      )
    :effect (dms_package_quality_check_passed ?dms_package)
  )
  (:action associate_external_evidence_with_dcr_and_package
    :parameters (?document_control_record - document_control_record ?external_evidence - external_evidence ?dms_package - dms_package)
    :precondition
      (and
        (technical_review_completed ?document_control_record)
        (dcr_linked_package ?document_control_record ?dms_package)
        (dcr_linked_external_evidence ?document_control_record ?external_evidence)
        (external_evidence_available ?external_evidence)
        (dms_package_active ?dms_package)
        (dms_package_quality_check_passed ?dms_package)
        (not
          (external_evidence_verified ?external_evidence)
        )
      )
    :effect
      (and
        (external_evidence_verified ?external_evidence)
        (external_evidence_linked_to_package ?external_evidence ?dms_package)
        (not
          (external_evidence_available ?external_evidence)
        )
      )
  )
  (:action verify_external_evidence_and_mark_dcr_consolidated
    :parameters (?document_control_record - document_control_record ?external_evidence - external_evidence ?dms_package - dms_package ?validation_specialist - validation_specialist)
    :precondition
      (and
        (technical_review_completed ?document_control_record)
        (dcr_linked_external_evidence ?document_control_record ?external_evidence)
        (external_evidence_verified ?external_evidence)
        (external_evidence_linked_to_package ?external_evidence ?dms_package)
        (validation_specialist_assigned ?document_control_record ?validation_specialist)
        (not
          (dms_package_activity_a_evidence_attached ?dms_package)
        )
        (not
          (dcr_evidence_consolidated ?document_control_record)
        )
      )
    :effect (dcr_evidence_consolidated ?document_control_record)
  )
  (:action assign_regulatory_attachment_to_dcr
    :parameters (?document_control_record - document_control_record ?regulatory_attachment - regulatory_attachment)
    :precondition
      (and
        (technical_review_completed ?document_control_record)
        (regulatory_attachment_available ?regulatory_attachment)
        (not
          (dcr_regulatory_attachment_assigned ?document_control_record)
        )
      )
    :effect
      (and
        (dcr_regulatory_attachment_assigned ?document_control_record)
        (dcr_regulatory_attachment_linked ?document_control_record ?regulatory_attachment)
        (not
          (regulatory_attachment_available ?regulatory_attachment)
        )
      )
  )
  (:action review_regulatory_attachment_and_finalize_dcr
    :parameters (?document_control_record - document_control_record ?external_evidence - external_evidence ?dms_package - dms_package ?validation_specialist - validation_specialist ?regulatory_attachment - regulatory_attachment)
    :precondition
      (and
        (technical_review_completed ?document_control_record)
        (dcr_linked_external_evidence ?document_control_record ?external_evidence)
        (external_evidence_verified ?external_evidence)
        (external_evidence_linked_to_package ?external_evidence ?dms_package)
        (validation_specialist_assigned ?document_control_record ?validation_specialist)
        (dms_package_activity_a_evidence_attached ?dms_package)
        (dcr_regulatory_attachment_assigned ?document_control_record)
        (dcr_regulatory_attachment_linked ?document_control_record ?regulatory_attachment)
        (not
          (dcr_evidence_consolidated ?document_control_record)
        )
      )
    :effect
      (and
        (dcr_evidence_consolidated ?document_control_record)
        (dcr_regulatory_attachment_reviewed ?document_control_record)
      )
  )
  (:action start_authorizer_review_for_dcr
    :parameters (?document_control_record - document_control_record ?training_record - training_record ?signatory_role - signatory_role ?external_evidence - external_evidence ?dms_package - dms_package)
    :precondition
      (and
        (dcr_evidence_consolidated ?document_control_record)
        (dcr_training_record_linked ?document_control_record ?training_record)
        (document_assigned_signatory ?document_control_record ?signatory_role)
        (dcr_linked_external_evidence ?document_control_record ?external_evidence)
        (external_evidence_linked_to_package ?external_evidence ?dms_package)
        (not
          (dms_package_activity_b_evidence_attached ?dms_package)
        )
        (not
          (dcr_attachment_approved ?document_control_record)
        )
      )
    :effect (dcr_attachment_approved ?document_control_record)
  )
  (:action continue_authorizer_review_for_dcr
    :parameters (?document_control_record - document_control_record ?training_record - training_record ?signatory_role - signatory_role ?external_evidence - external_evidence ?dms_package - dms_package)
    :precondition
      (and
        (dcr_evidence_consolidated ?document_control_record)
        (dcr_training_record_linked ?document_control_record ?training_record)
        (document_assigned_signatory ?document_control_record ?signatory_role)
        (dcr_linked_external_evidence ?document_control_record ?external_evidence)
        (external_evidence_linked_to_package ?external_evidence ?dms_package)
        (dms_package_activity_b_evidence_attached ?dms_package)
        (not
          (dcr_attachment_approved ?document_control_record)
        )
      )
    :effect (dcr_attachment_approved ?document_control_record)
  )
  (:action perform_regulatory_hold_compliance_check
    :parameters (?document_control_record - document_control_record ?regulatory_hold - regulatory_hold ?external_evidence - external_evidence ?dms_package - dms_package)
    :precondition
      (and
        (dcr_attachment_approved ?document_control_record)
        (dcr_regulatory_hold_linked ?document_control_record ?regulatory_hold)
        (dcr_linked_external_evidence ?document_control_record ?external_evidence)
        (external_evidence_linked_to_package ?external_evidence ?dms_package)
        (not
          (dms_package_activity_a_evidence_attached ?dms_package)
        )
        (not
          (dms_package_activity_b_evidence_attached ?dms_package)
        )
        (not
          (dcr_compliance_checked ?document_control_record)
        )
      )
    :effect (dcr_compliance_checked ?document_control_record)
  )
  (:action perform_compliance_check_and_mark_verified
    :parameters (?document_control_record - document_control_record ?regulatory_hold - regulatory_hold ?external_evidence - external_evidence ?dms_package - dms_package)
    :precondition
      (and
        (dcr_attachment_approved ?document_control_record)
        (dcr_regulatory_hold_linked ?document_control_record ?regulatory_hold)
        (dcr_linked_external_evidence ?document_control_record ?external_evidence)
        (external_evidence_linked_to_package ?external_evidence ?dms_package)
        (dms_package_activity_a_evidence_attached ?dms_package)
        (not
          (dms_package_activity_b_evidence_attached ?dms_package)
        )
        (not
          (dcr_compliance_checked ?document_control_record)
        )
      )
    :effect
      (and
        (dcr_compliance_checked ?document_control_record)
        (dcr_requirements_verified ?document_control_record)
      )
  )
  (:action perform_compliance_check_and_verify_requirements
    :parameters (?document_control_record - document_control_record ?regulatory_hold - regulatory_hold ?external_evidence - external_evidence ?dms_package - dms_package)
    :precondition
      (and
        (dcr_attachment_approved ?document_control_record)
        (dcr_regulatory_hold_linked ?document_control_record ?regulatory_hold)
        (dcr_linked_external_evidence ?document_control_record ?external_evidence)
        (external_evidence_linked_to_package ?external_evidence ?dms_package)
        (not
          (dms_package_activity_a_evidence_attached ?dms_package)
        )
        (dms_package_activity_b_evidence_attached ?dms_package)
        (not
          (dcr_compliance_checked ?document_control_record)
        )
      )
    :effect
      (and
        (dcr_compliance_checked ?document_control_record)
        (dcr_requirements_verified ?document_control_record)
      )
  )
  (:action perform_final_compliance_check_and_verify_requirements
    :parameters (?document_control_record - document_control_record ?regulatory_hold - regulatory_hold ?external_evidence - external_evidence ?dms_package - dms_package)
    :precondition
      (and
        (dcr_attachment_approved ?document_control_record)
        (dcr_regulatory_hold_linked ?document_control_record ?regulatory_hold)
        (dcr_linked_external_evidence ?document_control_record ?external_evidence)
        (external_evidence_linked_to_package ?external_evidence ?dms_package)
        (dms_package_activity_a_evidence_attached ?dms_package)
        (dms_package_activity_b_evidence_attached ?dms_package)
        (not
          (dcr_compliance_checked ?document_control_record)
        )
      )
    :effect
      (and
        (dcr_compliance_checked ?document_control_record)
        (dcr_requirements_verified ?document_control_record)
      )
  )
  (:action finalize_dcr_and_authorize_release
    :parameters (?document_control_record - document_control_record)
    :precondition
      (and
        (dcr_compliance_checked ?document_control_record)
        (not
          (dcr_requirements_verified ?document_control_record)
        )
        (not
          (dcr_finalized ?document_control_record)
        )
      )
    :effect
      (and
        (dcr_finalized ?document_control_record)
        (release_authorized ?document_control_record)
      )
  )
  (:action attach_release_credential_to_dcr
    :parameters (?document_control_record - document_control_record ?release_credential - release_credential)
    :precondition
      (and
        (dcr_compliance_checked ?document_control_record)
        (dcr_requirements_verified ?document_control_record)
        (release_credential_available ?release_credential)
      )
    :effect
      (and
        (dcr_release_credential_linked ?document_control_record ?release_credential)
        (not
          (release_credential_available ?release_credential)
        )
      )
  )
  (:action confirm_training_and_approvals_on_dcr
    :parameters (?document_control_record - document_control_record ?department_owner_a - department_owner_a ?department_owner_b - department_owner_b ?validation_specialist - validation_specialist ?release_credential - release_credential)
    :precondition
      (and
        (dcr_compliance_checked ?document_control_record)
        (dcr_requirements_verified ?document_control_record)
        (dcr_release_credential_linked ?document_control_record ?release_credential)
        (dcr_linked_owner_a ?document_control_record ?department_owner_a)
        (dcr_linked_owner_b ?document_control_record ?department_owner_b)
        (department_owner_manufacturing_validation_completed ?department_owner_a)
        (department_owner_quality_validation_completed ?department_owner_b)
        (validation_specialist_assigned ?document_control_record ?validation_specialist)
        (not
          (dcr_training_and_authorization_confirmed ?document_control_record)
        )
      )
    :effect (dcr_training_and_authorization_confirmed ?document_control_record)
  )
  (:action finalize_dcr_after_authorizer_confirmation
    :parameters (?document_control_record - document_control_record)
    :precondition
      (and
        (dcr_compliance_checked ?document_control_record)
        (dcr_training_and_authorization_confirmed ?document_control_record)
        (not
          (dcr_finalized ?document_control_record)
        )
      )
    :effect
      (and
        (dcr_finalized ?document_control_record)
        (release_authorized ?document_control_record)
      )
  )
  (:action allocate_inspection_flag_and_confirm
    :parameters (?document_control_record - document_control_record ?inspection_flag - inspection_flag ?validation_specialist - validation_specialist)
    :precondition
      (and
        (technical_review_completed ?document_control_record)
        (validation_specialist_assigned ?document_control_record ?validation_specialist)
        (inspection_flag_active ?inspection_flag)
        (dcr_linked_inspection_flag ?document_control_record ?inspection_flag)
        (not
          (inspection_allocation_confirmed ?document_control_record)
        )
      )
    :effect
      (and
        (inspection_allocation_confirmed ?document_control_record)
        (not
          (inspection_flag_active ?inspection_flag)
        )
      )
  )
  (:action initiate_dcr_signoff
    :parameters (?document_control_record - document_control_record ?signatory_role - signatory_role)
    :precondition
      (and
        (inspection_allocation_confirmed ?document_control_record)
        (document_assigned_signatory ?document_control_record ?signatory_role)
        (not
          (dcr_signoff_in_progress ?document_control_record)
        )
      )
    :effect (dcr_signoff_in_progress ?document_control_record)
  )
  (:action complete_dcr_signoff_with_regulatory_review
    :parameters (?document_control_record - document_control_record ?regulatory_hold - regulatory_hold)
    :precondition
      (and
        (dcr_signoff_in_progress ?document_control_record)
        (dcr_regulatory_hold_linked ?document_control_record ?regulatory_hold)
        (not
          (dcr_signoff_completed ?document_control_record)
        )
      )
    :effect (dcr_signoff_completed ?document_control_record)
  )
  (:action finalize_dcr_signoff_and_authorize_release
    :parameters (?document_control_record - document_control_record)
    :precondition
      (and
        (dcr_signoff_completed ?document_control_record)
        (not
          (dcr_finalized ?document_control_record)
        )
      )
    :effect
      (and
        (dcr_finalized ?document_control_record)
        (release_authorized ?document_control_record)
      )
  )
  (:action department_owner_manufacturing_execute_release_authorization
    :parameters (?department_owner_a - department_owner_a ?dms_package - dms_package)
    :precondition
      (and
        (department_owner_manufacturing_ready_for_package_assembly ?department_owner_a)
        (department_owner_manufacturing_validation_completed ?department_owner_a)
        (dms_package_active ?dms_package)
        (dms_package_quality_check_passed ?dms_package)
        (not
          (release_authorized ?department_owner_a)
        )
      )
    :effect (release_authorized ?department_owner_a)
  )
  (:action department_owner_quality_execute_release_authorization
    :parameters (?department_owner_b - department_owner_b ?dms_package - dms_package)
    :precondition
      (and
        (department_owner_quality_ready_for_package_assembly ?department_owner_b)
        (department_owner_quality_validation_completed ?department_owner_b)
        (dms_package_active ?dms_package)
        (dms_package_quality_check_passed ?dms_package)
        (not
          (release_authorized ?department_owner_b)
        )
      )
    :effect (release_authorized ?department_owner_b)
  )
  (:action assert_effective_date_for_document
    :parameters (?controlled_document - controlled_document ?effective_date_token - effective_date_token ?validation_specialist - validation_specialist)
    :precondition
      (and
        (release_authorized ?controlled_document)
        (validation_specialist_assigned ?controlled_document ?validation_specialist)
        (effective_date_token_available ?effective_date_token)
        (not
          (release_ready ?controlled_document)
        )
      )
    :effect
      (and
        (release_ready ?controlled_document)
        (document_effective_date_linked ?controlled_document ?effective_date_token)
        (not
          (effective_date_token_available ?effective_date_token)
        )
      )
  )
  (:action owner_finalize_document_release
    :parameters (?department_owner_a - department_owner_a ?approver_slot - approver_slot ?effective_date_token - effective_date_token)
    :precondition
      (and
        (release_ready ?department_owner_a)
        (document_assigned_approver ?department_owner_a ?approver_slot)
        (document_effective_date_linked ?department_owner_a ?effective_date_token)
        (not
          (document_released ?department_owner_a)
        )
      )
    :effect
      (and
        (document_released ?department_owner_a)
        (approver_slot_available ?approver_slot)
        (effective_date_token_available ?effective_date_token)
      )
  )
  (:action owner_b_finalize_document_release
    :parameters (?department_owner_b - department_owner_b ?approver_slot - approver_slot ?effective_date_token - effective_date_token)
    :precondition
      (and
        (release_ready ?department_owner_b)
        (document_assigned_approver ?department_owner_b ?approver_slot)
        (document_effective_date_linked ?department_owner_b ?effective_date_token)
        (not
          (document_released ?department_owner_b)
        )
      )
    :effect
      (and
        (document_released ?department_owner_b)
        (approver_slot_available ?approver_slot)
        (effective_date_token_available ?effective_date_token)
      )
  )
  (:action dcr_finalize_document_release_and_free_approver_slot
    :parameters (?document_control_record - document_control_record ?approver_slot - approver_slot ?effective_date_token - effective_date_token)
    :precondition
      (and
        (release_ready ?document_control_record)
        (document_assigned_approver ?document_control_record ?approver_slot)
        (document_effective_date_linked ?document_control_record ?effective_date_token)
        (not
          (document_released ?document_control_record)
        )
      )
    :effect
      (and
        (document_released ?document_control_record)
        (approver_slot_available ?approver_slot)
        (effective_date_token_available ?effective_date_token)
      )
  )
)

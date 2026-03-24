(define (domain exposure_limit_breach_remediation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_artifact - object document_category - object component_category - object case_category - object limit_breach_case - case_category remediation_channel - operational_artifact evidence_document - operational_artifact operator - operational_artifact escalation_note - operational_artifact approval_document - operational_artifact funding_reservation_token - operational_artifact subject_matter_review - operational_artifact legal_review_opinion - operational_artifact supporting_attachment - document_category collateral_or_asset_record - document_category policy_reference - document_category exposure_component_a - component_category exposure_component_b - component_category remediation_action_template - component_category exposure_group - limit_breach_case exposure_subgroup - limit_breach_case primary_exposure - exposure_group secondary_exposure - exposure_group resolution_workstream - exposure_subgroup)
  (:predicates
    (case_opened ?breach_case - limit_breach_case)
    (entity_eligible_for_remediation ?breach_case - limit_breach_case)
    (case_routing_recorded ?breach_case - limit_breach_case)
    (remediation_closed ?breach_case - limit_breach_case)
    (entity_execution_approved ?breach_case - limit_breach_case)
    (funds_reserved ?breach_case - limit_breach_case)
    (remediation_channel_available ?remediation_channel - remediation_channel)
    (entity_assigned_to_remediation_channel ?breach_case - limit_breach_case ?remediation_channel - remediation_channel)
    (evidence_document_available ?evidence_document - evidence_document)
    (entity_has_evidence_document ?breach_case - limit_breach_case ?evidence_document - evidence_document)
    (operator_available ?operator - operator)
    (entity_assigned_to_operator ?breach_case - limit_breach_case ?operator - operator)
    (supporting_attachment_available ?supporting_attachment - supporting_attachment)
    (primary_exposure_has_supporting_attachment ?primary_exposure - primary_exposure ?supporting_attachment - supporting_attachment)
    (secondary_exposure_has_supporting_attachment ?secondary_exposure - secondary_exposure ?supporting_attachment - supporting_attachment)
    (primary_exposure_has_component_a ?primary_exposure - primary_exposure ?component_a - exposure_component_a)
    (component_a_validated ?component_a - exposure_component_a)
    (component_a_has_attachment ?component_a - exposure_component_a)
    (primary_exposure_component_validated ?primary_exposure - primary_exposure)
    (secondary_exposure_has_component_b ?secondary_exposure - secondary_exposure ?component_b - exposure_component_b)
    (component_b_validated ?component_b - exposure_component_b)
    (component_b_has_attachment ?component_b - exposure_component_b)
    (secondary_exposure_component_validated ?secondary_exposure - secondary_exposure)
    (remediation_template_available ?remediation_template - remediation_action_template)
    (remediation_template_initialized ?remediation_template - remediation_action_template)
    (template_includes_component_a ?remediation_template - remediation_action_template ?component_a - exposure_component_a)
    (template_includes_component_b ?remediation_template - remediation_action_template ?component_b - exposure_component_b)
    (template_contains_component_a_attachment ?remediation_template - remediation_action_template)
    (template_contains_component_b_attachment ?remediation_template - remediation_action_template)
    (remediation_template_locked ?remediation_template - remediation_action_template)
    (workstream_includes_primary_exposure ?workstream - resolution_workstream ?primary_exposure - primary_exposure)
    (workstream_includes_secondary_exposure ?workstream - resolution_workstream ?secondary_exposure - secondary_exposure)
    (workstream_uses_remediation_template ?workstream - resolution_workstream ?remediation_template - remediation_action_template)
    (asset_record_available ?asset_record - collateral_or_asset_record)
    (workstream_has_asset_record ?workstream - resolution_workstream ?asset_record - collateral_or_asset_record)
    (asset_record_allocated ?asset_record - collateral_or_asset_record)
    (asset_record_allocated_to_template ?asset_record - collateral_or_asset_record ?remediation_template - remediation_action_template)
    (workstream_asset_validated ?workstream - resolution_workstream)
    (workstream_smr_cleared ?workstream - resolution_workstream)
    (workstream_legal_review_cleared ?workstream - resolution_workstream)
    (workstream_escalation_recorded ?workstream - resolution_workstream)
    (workstream_escalation_reviewed ?workstream - resolution_workstream)
    (workstream_policy_approval_cleared ?workstream - resolution_workstream)
    (workstream_execution_checks_complete ?workstream - resolution_workstream)
    (policy_reference_available ?policy_reference - policy_reference)
    (workstream_has_policy_reference ?workstream - resolution_workstream ?policy_reference - policy_reference)
    (workstream_policy_exception_recorded ?workstream - resolution_workstream)
    (workstream_policy_review_initiated ?workstream - resolution_workstream)
    (workstream_policy_review_completed ?workstream - resolution_workstream)
    (escalation_note_available ?escalation_note - escalation_note)
    (workstream_has_escalation_note ?workstream - resolution_workstream ?escalation_note - escalation_note)
    (approval_document_available ?approval_document - approval_document)
    (workstream_has_approval_document ?workstream - resolution_workstream ?approval_document - approval_document)
    (subject_matter_review_available ?subject_matter_review - subject_matter_review)
    (workstream_has_subject_matter_review ?workstream - resolution_workstream ?subject_matter_review - subject_matter_review)
    (legal_review_opinion_available ?legal_review_opinion - legal_review_opinion)
    (workstream_has_legal_review_opinion ?workstream - resolution_workstream ?legal_review_opinion - legal_review_opinion)
    (funding_token_available ?funding_token - funding_reservation_token)
    (entity_reserved_funding_token ?breach_case - limit_breach_case ?funding_token - funding_reservation_token)
    (primary_exposure_ready_for_template ?primary_exposure - primary_exposure)
    (secondary_exposure_ready_for_template ?secondary_exposure - secondary_exposure)
    (workstream_finalized ?workstream - resolution_workstream)
  )
  (:action register_breach_case
    :parameters (?breach_case - limit_breach_case)
    :precondition
      (and
        (not
          (case_opened ?breach_case)
        )
        (not
          (remediation_closed ?breach_case)
        )
      )
    :effect (case_opened ?breach_case)
  )
  (:action route_case_to_remediation_channel
    :parameters (?breach_case - limit_breach_case ?remediation_channel - remediation_channel)
    :precondition
      (and
        (case_opened ?breach_case)
        (not
          (case_routing_recorded ?breach_case)
        )
        (remediation_channel_available ?remediation_channel)
      )
    :effect
      (and
        (case_routing_recorded ?breach_case)
        (entity_assigned_to_remediation_channel ?breach_case ?remediation_channel)
        (not
          (remediation_channel_available ?remediation_channel)
        )
      )
  )
  (:action attach_evidence_to_case
    :parameters (?breach_case - limit_breach_case ?evidence_document - evidence_document)
    :precondition
      (and
        (case_opened ?breach_case)
        (case_routing_recorded ?breach_case)
        (evidence_document_available ?evidence_document)
      )
    :effect
      (and
        (entity_has_evidence_document ?breach_case ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action complete_case_triage
    :parameters (?breach_case - limit_breach_case ?evidence_document - evidence_document)
    :precondition
      (and
        (case_opened ?breach_case)
        (case_routing_recorded ?breach_case)
        (entity_has_evidence_document ?breach_case ?evidence_document)
        (not
          (entity_eligible_for_remediation ?breach_case)
        )
      )
    :effect (entity_eligible_for_remediation ?breach_case)
  )
  (:action detach_evidence_from_case
    :parameters (?breach_case - limit_breach_case ?evidence_document - evidence_document)
    :precondition
      (and
        (entity_has_evidence_document ?breach_case ?evidence_document)
      )
    :effect
      (and
        (evidence_document_available ?evidence_document)
        (not
          (entity_has_evidence_document ?breach_case ?evidence_document)
        )
      )
  )
  (:action assign_operator_to_case
    :parameters (?breach_case - limit_breach_case ?operator - operator)
    :precondition
      (and
        (entity_eligible_for_remediation ?breach_case)
        (operator_available ?operator)
      )
    :effect
      (and
        (entity_assigned_to_operator ?breach_case ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action unassign_operator_from_case
    :parameters (?breach_case - limit_breach_case ?operator - operator)
    :precondition
      (and
        (entity_assigned_to_operator ?breach_case ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (entity_assigned_to_operator ?breach_case ?operator)
        )
      )
  )
  (:action attach_subject_matter_review_to_workstream
    :parameters (?workstream - resolution_workstream ?subject_matter_review - subject_matter_review)
    :precondition
      (and
        (entity_eligible_for_remediation ?workstream)
        (subject_matter_review_available ?subject_matter_review)
      )
    :effect
      (and
        (workstream_has_subject_matter_review ?workstream ?subject_matter_review)
        (not
          (subject_matter_review_available ?subject_matter_review)
        )
      )
  )
  (:action detach_subject_matter_review_from_workstream
    :parameters (?workstream - resolution_workstream ?subject_matter_review - subject_matter_review)
    :precondition
      (and
        (workstream_has_subject_matter_review ?workstream ?subject_matter_review)
      )
    :effect
      (and
        (subject_matter_review_available ?subject_matter_review)
        (not
          (workstream_has_subject_matter_review ?workstream ?subject_matter_review)
        )
      )
  )
  (:action attach_legal_review_to_workstream
    :parameters (?workstream - resolution_workstream ?legal_review_opinion - legal_review_opinion)
    :precondition
      (and
        (entity_eligible_for_remediation ?workstream)
        (legal_review_opinion_available ?legal_review_opinion)
      )
    :effect
      (and
        (workstream_has_legal_review_opinion ?workstream ?legal_review_opinion)
        (not
          (legal_review_opinion_available ?legal_review_opinion)
        )
      )
  )
  (:action detach_legal_review_from_workstream
    :parameters (?workstream - resolution_workstream ?legal_review_opinion - legal_review_opinion)
    :precondition
      (and
        (workstream_has_legal_review_opinion ?workstream ?legal_review_opinion)
      )
    :effect
      (and
        (legal_review_opinion_available ?legal_review_opinion)
        (not
          (workstream_has_legal_review_opinion ?workstream ?legal_review_opinion)
        )
      )
  )
  (:action validate_component_a_by_evidence
    :parameters (?primary_exposure - primary_exposure ?component_a - exposure_component_a ?evidence_document - evidence_document)
    :precondition
      (and
        (entity_eligible_for_remediation ?primary_exposure)
        (entity_has_evidence_document ?primary_exposure ?evidence_document)
        (primary_exposure_has_component_a ?primary_exposure ?component_a)
        (not
          (component_a_validated ?component_a)
        )
        (not
          (component_a_has_attachment ?component_a)
        )
      )
    :effect (component_a_validated ?component_a)
  )
  (:action confirm_primary_exposure_component_validation
    :parameters (?primary_exposure - primary_exposure ?component_a - exposure_component_a ?operator - operator)
    :precondition
      (and
        (entity_eligible_for_remediation ?primary_exposure)
        (entity_assigned_to_operator ?primary_exposure ?operator)
        (primary_exposure_has_component_a ?primary_exposure ?component_a)
        (component_a_validated ?component_a)
        (not
          (primary_exposure_ready_for_template ?primary_exposure)
        )
      )
    :effect
      (and
        (primary_exposure_ready_for_template ?primary_exposure)
        (primary_exposure_component_validated ?primary_exposure)
      )
  )
  (:action attach_supporting_attachment_to_primary_exposure
    :parameters (?primary_exposure - primary_exposure ?component_a - exposure_component_a ?supporting_attachment - supporting_attachment)
    :precondition
      (and
        (entity_eligible_for_remediation ?primary_exposure)
        (primary_exposure_has_component_a ?primary_exposure ?component_a)
        (supporting_attachment_available ?supporting_attachment)
        (not
          (primary_exposure_ready_for_template ?primary_exposure)
        )
      )
    :effect
      (and
        (component_a_has_attachment ?component_a)
        (primary_exposure_ready_for_template ?primary_exposure)
        (primary_exposure_has_supporting_attachment ?primary_exposure ?supporting_attachment)
        (not
          (supporting_attachment_available ?supporting_attachment)
        )
      )
  )
  (:action finalize_primary_component_after_attachment
    :parameters (?primary_exposure - primary_exposure ?component_a - exposure_component_a ?evidence_document - evidence_document ?supporting_attachment - supporting_attachment)
    :precondition
      (and
        (entity_eligible_for_remediation ?primary_exposure)
        (entity_has_evidence_document ?primary_exposure ?evidence_document)
        (primary_exposure_has_component_a ?primary_exposure ?component_a)
        (component_a_has_attachment ?component_a)
        (primary_exposure_has_supporting_attachment ?primary_exposure ?supporting_attachment)
        (not
          (primary_exposure_component_validated ?primary_exposure)
        )
      )
    :effect
      (and
        (component_a_validated ?component_a)
        (primary_exposure_component_validated ?primary_exposure)
        (supporting_attachment_available ?supporting_attachment)
        (not
          (primary_exposure_has_supporting_attachment ?primary_exposure ?supporting_attachment)
        )
      )
  )
  (:action validate_component_b_by_evidence
    :parameters (?secondary_exposure - secondary_exposure ?component_b - exposure_component_b ?evidence_document - evidence_document)
    :precondition
      (and
        (entity_eligible_for_remediation ?secondary_exposure)
        (entity_has_evidence_document ?secondary_exposure ?evidence_document)
        (secondary_exposure_has_component_b ?secondary_exposure ?component_b)
        (not
          (component_b_validated ?component_b)
        )
        (not
          (component_b_has_attachment ?component_b)
        )
      )
    :effect (component_b_validated ?component_b)
  )
  (:action confirm_secondary_exposure_component_validation
    :parameters (?secondary_exposure - secondary_exposure ?component_b - exposure_component_b ?operator - operator)
    :precondition
      (and
        (entity_eligible_for_remediation ?secondary_exposure)
        (entity_assigned_to_operator ?secondary_exposure ?operator)
        (secondary_exposure_has_component_b ?secondary_exposure ?component_b)
        (component_b_validated ?component_b)
        (not
          (secondary_exposure_ready_for_template ?secondary_exposure)
        )
      )
    :effect
      (and
        (secondary_exposure_ready_for_template ?secondary_exposure)
        (secondary_exposure_component_validated ?secondary_exposure)
      )
  )
  (:action attach_supporting_attachment_to_secondary_exposure
    :parameters (?secondary_exposure - secondary_exposure ?component_b - exposure_component_b ?supporting_attachment - supporting_attachment)
    :precondition
      (and
        (entity_eligible_for_remediation ?secondary_exposure)
        (secondary_exposure_has_component_b ?secondary_exposure ?component_b)
        (supporting_attachment_available ?supporting_attachment)
        (not
          (secondary_exposure_ready_for_template ?secondary_exposure)
        )
      )
    :effect
      (and
        (component_b_has_attachment ?component_b)
        (secondary_exposure_ready_for_template ?secondary_exposure)
        (secondary_exposure_has_supporting_attachment ?secondary_exposure ?supporting_attachment)
        (not
          (supporting_attachment_available ?supporting_attachment)
        )
      )
  )
  (:action finalize_secondary_component_after_attachment
    :parameters (?secondary_exposure - secondary_exposure ?component_b - exposure_component_b ?evidence_document - evidence_document ?supporting_attachment - supporting_attachment)
    :precondition
      (and
        (entity_eligible_for_remediation ?secondary_exposure)
        (entity_has_evidence_document ?secondary_exposure ?evidence_document)
        (secondary_exposure_has_component_b ?secondary_exposure ?component_b)
        (component_b_has_attachment ?component_b)
        (secondary_exposure_has_supporting_attachment ?secondary_exposure ?supporting_attachment)
        (not
          (secondary_exposure_component_validated ?secondary_exposure)
        )
      )
    :effect
      (and
        (component_b_validated ?component_b)
        (secondary_exposure_component_validated ?secondary_exposure)
        (supporting_attachment_available ?supporting_attachment)
        (not
          (secondary_exposure_has_supporting_attachment ?secondary_exposure ?supporting_attachment)
        )
      )
  )
  (:action assemble_remediation_template
    :parameters (?primary_exposure - primary_exposure ?secondary_exposure - secondary_exposure ?component_a - exposure_component_a ?component_b - exposure_component_b ?remediation_template - remediation_action_template)
    :precondition
      (and
        (primary_exposure_ready_for_template ?primary_exposure)
        (secondary_exposure_ready_for_template ?secondary_exposure)
        (primary_exposure_has_component_a ?primary_exposure ?component_a)
        (secondary_exposure_has_component_b ?secondary_exposure ?component_b)
        (component_a_validated ?component_a)
        (component_b_validated ?component_b)
        (primary_exposure_component_validated ?primary_exposure)
        (secondary_exposure_component_validated ?secondary_exposure)
        (remediation_template_available ?remediation_template)
      )
    :effect
      (and
        (remediation_template_initialized ?remediation_template)
        (template_includes_component_a ?remediation_template ?component_a)
        (template_includes_component_b ?remediation_template ?component_b)
        (not
          (remediation_template_available ?remediation_template)
        )
      )
  )
  (:action assemble_remediation_template_with_primary_attachment
    :parameters (?primary_exposure - primary_exposure ?secondary_exposure - secondary_exposure ?component_a - exposure_component_a ?component_b - exposure_component_b ?remediation_template - remediation_action_template)
    :precondition
      (and
        (primary_exposure_ready_for_template ?primary_exposure)
        (secondary_exposure_ready_for_template ?secondary_exposure)
        (primary_exposure_has_component_a ?primary_exposure ?component_a)
        (secondary_exposure_has_component_b ?secondary_exposure ?component_b)
        (component_a_has_attachment ?component_a)
        (component_b_validated ?component_b)
        (not
          (primary_exposure_component_validated ?primary_exposure)
        )
        (secondary_exposure_component_validated ?secondary_exposure)
        (remediation_template_available ?remediation_template)
      )
    :effect
      (and
        (remediation_template_initialized ?remediation_template)
        (template_includes_component_a ?remediation_template ?component_a)
        (template_includes_component_b ?remediation_template ?component_b)
        (template_contains_component_a_attachment ?remediation_template)
        (not
          (remediation_template_available ?remediation_template)
        )
      )
  )
  (:action assemble_remediation_template_with_secondary_attachment
    :parameters (?primary_exposure - primary_exposure ?secondary_exposure - secondary_exposure ?component_a - exposure_component_a ?component_b - exposure_component_b ?remediation_template - remediation_action_template)
    :precondition
      (and
        (primary_exposure_ready_for_template ?primary_exposure)
        (secondary_exposure_ready_for_template ?secondary_exposure)
        (primary_exposure_has_component_a ?primary_exposure ?component_a)
        (secondary_exposure_has_component_b ?secondary_exposure ?component_b)
        (component_a_validated ?component_a)
        (component_b_has_attachment ?component_b)
        (primary_exposure_component_validated ?primary_exposure)
        (not
          (secondary_exposure_component_validated ?secondary_exposure)
        )
        (remediation_template_available ?remediation_template)
      )
    :effect
      (and
        (remediation_template_initialized ?remediation_template)
        (template_includes_component_a ?remediation_template ?component_a)
        (template_includes_component_b ?remediation_template ?component_b)
        (template_contains_component_b_attachment ?remediation_template)
        (not
          (remediation_template_available ?remediation_template)
        )
      )
  )
  (:action assemble_remediation_template_with_both_attachments
    :parameters (?primary_exposure - primary_exposure ?secondary_exposure - secondary_exposure ?component_a - exposure_component_a ?component_b - exposure_component_b ?remediation_template - remediation_action_template)
    :precondition
      (and
        (primary_exposure_ready_for_template ?primary_exposure)
        (secondary_exposure_ready_for_template ?secondary_exposure)
        (primary_exposure_has_component_a ?primary_exposure ?component_a)
        (secondary_exposure_has_component_b ?secondary_exposure ?component_b)
        (component_a_has_attachment ?component_a)
        (component_b_has_attachment ?component_b)
        (not
          (primary_exposure_component_validated ?primary_exposure)
        )
        (not
          (secondary_exposure_component_validated ?secondary_exposure)
        )
        (remediation_template_available ?remediation_template)
      )
    :effect
      (and
        (remediation_template_initialized ?remediation_template)
        (template_includes_component_a ?remediation_template ?component_a)
        (template_includes_component_b ?remediation_template ?component_b)
        (template_contains_component_a_attachment ?remediation_template)
        (template_contains_component_b_attachment ?remediation_template)
        (not
          (remediation_template_available ?remediation_template)
        )
      )
  )
  (:action lock_remediation_template_for_validation
    :parameters (?remediation_template - remediation_action_template ?primary_exposure - primary_exposure ?evidence_document - evidence_document)
    :precondition
      (and
        (remediation_template_initialized ?remediation_template)
        (primary_exposure_ready_for_template ?primary_exposure)
        (entity_has_evidence_document ?primary_exposure ?evidence_document)
        (not
          (remediation_template_locked ?remediation_template)
        )
      )
    :effect (remediation_template_locked ?remediation_template)
  )
  (:action allocate_asset_record_to_template
    :parameters (?workstream - resolution_workstream ?asset_record - collateral_or_asset_record ?remediation_template - remediation_action_template)
    :precondition
      (and
        (entity_eligible_for_remediation ?workstream)
        (workstream_uses_remediation_template ?workstream ?remediation_template)
        (workstream_has_asset_record ?workstream ?asset_record)
        (asset_record_available ?asset_record)
        (remediation_template_initialized ?remediation_template)
        (remediation_template_locked ?remediation_template)
        (not
          (asset_record_allocated ?asset_record)
        )
      )
    :effect
      (and
        (asset_record_allocated ?asset_record)
        (asset_record_allocated_to_template ?asset_record ?remediation_template)
        (not
          (asset_record_available ?asset_record)
        )
      )
  )
  (:action validate_asset_allocation_for_workstream
    :parameters (?workstream - resolution_workstream ?asset_record - collateral_or_asset_record ?remediation_template - remediation_action_template ?evidence_document - evidence_document)
    :precondition
      (and
        (entity_eligible_for_remediation ?workstream)
        (workstream_has_asset_record ?workstream ?asset_record)
        (asset_record_allocated ?asset_record)
        (asset_record_allocated_to_template ?asset_record ?remediation_template)
        (entity_has_evidence_document ?workstream ?evidence_document)
        (not
          (template_contains_component_a_attachment ?remediation_template)
        )
        (not
          (workstream_asset_validated ?workstream)
        )
      )
    :effect (workstream_asset_validated ?workstream)
  )
  (:action record_escalation_note_on_workstream
    :parameters (?workstream - resolution_workstream ?escalation_note - escalation_note)
    :precondition
      (and
        (entity_eligible_for_remediation ?workstream)
        (escalation_note_available ?escalation_note)
        (not
          (workstream_escalation_recorded ?workstream)
        )
      )
    :effect
      (and
        (workstream_escalation_recorded ?workstream)
        (workstream_has_escalation_note ?workstream ?escalation_note)
        (not
          (escalation_note_available ?escalation_note)
        )
      )
  )
  (:action process_escalation_and_mark_workstream
    :parameters (?workstream - resolution_workstream ?asset_record - collateral_or_asset_record ?remediation_template - remediation_action_template ?evidence_document - evidence_document ?escalation_note - escalation_note)
    :precondition
      (and
        (entity_eligible_for_remediation ?workstream)
        (workstream_has_asset_record ?workstream ?asset_record)
        (asset_record_allocated ?asset_record)
        (asset_record_allocated_to_template ?asset_record ?remediation_template)
        (entity_has_evidence_document ?workstream ?evidence_document)
        (template_contains_component_a_attachment ?remediation_template)
        (workstream_escalation_recorded ?workstream)
        (workstream_has_escalation_note ?workstream ?escalation_note)
        (not
          (workstream_asset_validated ?workstream)
        )
      )
    :effect
      (and
        (workstream_asset_validated ?workstream)
        (workstream_escalation_reviewed ?workstream)
      )
  )
  (:action complete_subject_matter_review_stage1
    :parameters (?workstream - resolution_workstream ?subject_matter_review - subject_matter_review ?operator - operator ?asset_record - collateral_or_asset_record ?remediation_template - remediation_action_template)
    :precondition
      (and
        (workstream_asset_validated ?workstream)
        (workstream_has_subject_matter_review ?workstream ?subject_matter_review)
        (entity_assigned_to_operator ?workstream ?operator)
        (workstream_has_asset_record ?workstream ?asset_record)
        (asset_record_allocated_to_template ?asset_record ?remediation_template)
        (not
          (template_contains_component_b_attachment ?remediation_template)
        )
        (not
          (workstream_smr_cleared ?workstream)
        )
      )
    :effect (workstream_smr_cleared ?workstream)
  )
  (:action complete_subject_matter_review_stage2
    :parameters (?workstream - resolution_workstream ?subject_matter_review - subject_matter_review ?operator - operator ?asset_record - collateral_or_asset_record ?remediation_template - remediation_action_template)
    :precondition
      (and
        (workstream_asset_validated ?workstream)
        (workstream_has_subject_matter_review ?workstream ?subject_matter_review)
        (entity_assigned_to_operator ?workstream ?operator)
        (workstream_has_asset_record ?workstream ?asset_record)
        (asset_record_allocated_to_template ?asset_record ?remediation_template)
        (template_contains_component_b_attachment ?remediation_template)
        (not
          (workstream_smr_cleared ?workstream)
        )
      )
    :effect (workstream_smr_cleared ?workstream)
  )
  (:action complete_legal_review_for_workstream
    :parameters (?workstream - resolution_workstream ?legal_review_opinion - legal_review_opinion ?asset_record - collateral_or_asset_record ?remediation_template - remediation_action_template)
    :precondition
      (and
        (workstream_smr_cleared ?workstream)
        (workstream_has_legal_review_opinion ?workstream ?legal_review_opinion)
        (workstream_has_asset_record ?workstream ?asset_record)
        (asset_record_allocated_to_template ?asset_record ?remediation_template)
        (not
          (template_contains_component_a_attachment ?remediation_template)
        )
        (not
          (template_contains_component_b_attachment ?remediation_template)
        )
        (not
          (workstream_legal_review_cleared ?workstream)
        )
      )
    :effect (workstream_legal_review_cleared ?workstream)
  )
  (:action complete_legal_review_and_flag_policy_approval_variant1
    :parameters (?workstream - resolution_workstream ?legal_review_opinion - legal_review_opinion ?asset_record - collateral_or_asset_record ?remediation_template - remediation_action_template)
    :precondition
      (and
        (workstream_smr_cleared ?workstream)
        (workstream_has_legal_review_opinion ?workstream ?legal_review_opinion)
        (workstream_has_asset_record ?workstream ?asset_record)
        (asset_record_allocated_to_template ?asset_record ?remediation_template)
        (template_contains_component_a_attachment ?remediation_template)
        (not
          (template_contains_component_b_attachment ?remediation_template)
        )
        (not
          (workstream_legal_review_cleared ?workstream)
        )
      )
    :effect
      (and
        (workstream_legal_review_cleared ?workstream)
        (workstream_policy_approval_cleared ?workstream)
      )
  )
  (:action complete_legal_review_and_flag_policy_approval_variant2
    :parameters (?workstream - resolution_workstream ?legal_review_opinion - legal_review_opinion ?asset_record - collateral_or_asset_record ?remediation_template - remediation_action_template)
    :precondition
      (and
        (workstream_smr_cleared ?workstream)
        (workstream_has_legal_review_opinion ?workstream ?legal_review_opinion)
        (workstream_has_asset_record ?workstream ?asset_record)
        (asset_record_allocated_to_template ?asset_record ?remediation_template)
        (not
          (template_contains_component_a_attachment ?remediation_template)
        )
        (template_contains_component_b_attachment ?remediation_template)
        (not
          (workstream_legal_review_cleared ?workstream)
        )
      )
    :effect
      (and
        (workstream_legal_review_cleared ?workstream)
        (workstream_policy_approval_cleared ?workstream)
      )
  )
  (:action complete_legal_review_and_flag_policy_approval_variant3
    :parameters (?workstream - resolution_workstream ?legal_review_opinion - legal_review_opinion ?asset_record - collateral_or_asset_record ?remediation_template - remediation_action_template)
    :precondition
      (and
        (workstream_smr_cleared ?workstream)
        (workstream_has_legal_review_opinion ?workstream ?legal_review_opinion)
        (workstream_has_asset_record ?workstream ?asset_record)
        (asset_record_allocated_to_template ?asset_record ?remediation_template)
        (template_contains_component_a_attachment ?remediation_template)
        (template_contains_component_b_attachment ?remediation_template)
        (not
          (workstream_legal_review_cleared ?workstream)
        )
      )
    :effect
      (and
        (workstream_legal_review_cleared ?workstream)
        (workstream_policy_approval_cleared ?workstream)
      )
  )
  (:action finalize_workstream_approval
    :parameters (?workstream - resolution_workstream)
    :precondition
      (and
        (workstream_legal_review_cleared ?workstream)
        (not
          (workstream_policy_approval_cleared ?workstream)
        )
        (not
          (workstream_finalized ?workstream)
        )
      )
    :effect
      (and
        (workstream_finalized ?workstream)
        (entity_execution_approved ?workstream)
      )
  )
  (:action attach_approval_document_to_workstream
    :parameters (?workstream - resolution_workstream ?approval_document - approval_document)
    :precondition
      (and
        (workstream_legal_review_cleared ?workstream)
        (workstream_policy_approval_cleared ?workstream)
        (approval_document_available ?approval_document)
      )
    :effect
      (and
        (workstream_has_approval_document ?workstream ?approval_document)
        (not
          (approval_document_available ?approval_document)
        )
      )
  )
  (:action perform_final_execution_checks
    :parameters (?workstream - resolution_workstream ?primary_exposure - primary_exposure ?secondary_exposure - secondary_exposure ?evidence_document - evidence_document ?approval_document - approval_document)
    :precondition
      (and
        (workstream_legal_review_cleared ?workstream)
        (workstream_policy_approval_cleared ?workstream)
        (workstream_has_approval_document ?workstream ?approval_document)
        (workstream_includes_primary_exposure ?workstream ?primary_exposure)
        (workstream_includes_secondary_exposure ?workstream ?secondary_exposure)
        (primary_exposure_component_validated ?primary_exposure)
        (secondary_exposure_component_validated ?secondary_exposure)
        (entity_has_evidence_document ?workstream ?evidence_document)
        (not
          (workstream_execution_checks_complete ?workstream)
        )
      )
    :effect (workstream_execution_checks_complete ?workstream)
  )
  (:action finalize_and_close_workstream
    :parameters (?workstream - resolution_workstream)
    :precondition
      (and
        (workstream_legal_review_cleared ?workstream)
        (workstream_execution_checks_complete ?workstream)
        (not
          (workstream_finalized ?workstream)
        )
      )
    :effect
      (and
        (workstream_finalized ?workstream)
        (entity_execution_approved ?workstream)
      )
  )
  (:action initiate_policy_review_for_workstream
    :parameters (?workstream - resolution_workstream ?policy_reference - policy_reference ?evidence_document - evidence_document)
    :precondition
      (and
        (entity_eligible_for_remediation ?workstream)
        (entity_has_evidence_document ?workstream ?evidence_document)
        (policy_reference_available ?policy_reference)
        (workstream_has_policy_reference ?workstream ?policy_reference)
        (not
          (workstream_policy_exception_recorded ?workstream)
        )
      )
    :effect
      (and
        (workstream_policy_exception_recorded ?workstream)
        (not
          (policy_reference_available ?policy_reference)
        )
      )
  )
  (:action start_policy_review_process
    :parameters (?workstream - resolution_workstream ?operator - operator)
    :precondition
      (and
        (workstream_policy_exception_recorded ?workstream)
        (entity_assigned_to_operator ?workstream ?operator)
        (not
          (workstream_policy_review_initiated ?workstream)
        )
      )
    :effect (workstream_policy_review_initiated ?workstream)
  )
  (:action complete_policy_review
    :parameters (?workstream - resolution_workstream ?legal_review_opinion - legal_review_opinion)
    :precondition
      (and
        (workstream_policy_review_initiated ?workstream)
        (workstream_has_legal_review_opinion ?workstream ?legal_review_opinion)
        (not
          (workstream_policy_review_completed ?workstream)
        )
      )
    :effect (workstream_policy_review_completed ?workstream)
  )
  (:action finalize_policy_review_and_approve
    :parameters (?workstream - resolution_workstream)
    :precondition
      (and
        (workstream_policy_review_completed ?workstream)
        (not
          (workstream_finalized ?workstream)
        )
      )
    :effect
      (and
        (workstream_finalized ?workstream)
        (entity_execution_approved ?workstream)
      )
  )
  (:action approve_primary_exposure_execution
    :parameters (?primary_exposure - primary_exposure ?remediation_template - remediation_action_template)
    :precondition
      (and
        (primary_exposure_ready_for_template ?primary_exposure)
        (primary_exposure_component_validated ?primary_exposure)
        (remediation_template_initialized ?remediation_template)
        (remediation_template_locked ?remediation_template)
        (not
          (entity_execution_approved ?primary_exposure)
        )
      )
    :effect (entity_execution_approved ?primary_exposure)
  )
  (:action approve_secondary_exposure_execution
    :parameters (?secondary_exposure - secondary_exposure ?remediation_template - remediation_action_template)
    :precondition
      (and
        (secondary_exposure_ready_for_template ?secondary_exposure)
        (secondary_exposure_component_validated ?secondary_exposure)
        (remediation_template_initialized ?remediation_template)
        (remediation_template_locked ?remediation_template)
        (not
          (entity_execution_approved ?secondary_exposure)
        )
      )
    :effect (entity_execution_approved ?secondary_exposure)
  )
  (:action reserve_funding_for_case
    :parameters (?breach_case - limit_breach_case ?funding_token - funding_reservation_token ?evidence_document - evidence_document)
    :precondition
      (and
        (entity_execution_approved ?breach_case)
        (entity_has_evidence_document ?breach_case ?evidence_document)
        (funding_token_available ?funding_token)
        (not
          (funds_reserved ?breach_case)
        )
      )
    :effect
      (and
        (funds_reserved ?breach_case)
        (entity_reserved_funding_token ?breach_case ?funding_token)
        (not
          (funding_token_available ?funding_token)
        )
      )
  )
  (:action execute_remediation_for_primary_exposure
    :parameters (?primary_exposure - primary_exposure ?remediation_channel - remediation_channel ?funding_token - funding_reservation_token)
    :precondition
      (and
        (funds_reserved ?primary_exposure)
        (entity_assigned_to_remediation_channel ?primary_exposure ?remediation_channel)
        (entity_reserved_funding_token ?primary_exposure ?funding_token)
        (not
          (remediation_closed ?primary_exposure)
        )
      )
    :effect
      (and
        (remediation_closed ?primary_exposure)
        (remediation_channel_available ?remediation_channel)
        (funding_token_available ?funding_token)
      )
  )
  (:action execute_remediation_for_secondary_exposure
    :parameters (?secondary_exposure - secondary_exposure ?remediation_channel - remediation_channel ?funding_token - funding_reservation_token)
    :precondition
      (and
        (funds_reserved ?secondary_exposure)
        (entity_assigned_to_remediation_channel ?secondary_exposure ?remediation_channel)
        (entity_reserved_funding_token ?secondary_exposure ?funding_token)
        (not
          (remediation_closed ?secondary_exposure)
        )
      )
    :effect
      (and
        (remediation_closed ?secondary_exposure)
        (remediation_channel_available ?remediation_channel)
        (funding_token_available ?funding_token)
      )
  )
  (:action execute_remediation_for_workstream
    :parameters (?workstream - resolution_workstream ?remediation_channel - remediation_channel ?funding_token - funding_reservation_token)
    :precondition
      (and
        (funds_reserved ?workstream)
        (entity_assigned_to_remediation_channel ?workstream ?remediation_channel)
        (entity_reserved_funding_token ?workstream ?funding_token)
        (not
          (remediation_closed ?workstream)
        )
      )
    :effect
      (and
        (remediation_closed ?workstream)
        (remediation_channel_available ?remediation_channel)
        (funding_token_available ?funding_token)
      )
  )
)

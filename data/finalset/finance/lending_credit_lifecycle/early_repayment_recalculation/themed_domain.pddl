(define (domain lending_early_repayment_recalculation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types case_component - object case_artifact - object auxiliary_resource - object case_container - object case_entity - case_container pricing_scheme - case_component early_repayment_notice - case_component servicing_agent - case_component approval_document - case_component adjustment_rule - case_component charge_schedule_item - case_component interest_override - case_component regulatory_parameter - case_component business_document - case_artifact collateral_item - case_artifact policy_attachment - case_artifact exposure_component - auxiliary_resource pricing_component - auxiliary_resource recalculation_result - auxiliary_resource loan_subtype_a - case_entity case_container_variant - case_entity primary_loan_record - loan_subtype_a secondary_loan_record - loan_subtype_a recalculation_case - case_container_variant)
  (:predicates
    (loan_recalc_enrolled ?loan_entity - case_entity)
    (loan_recalc_initiated ?loan_entity - case_entity)
    (loan_pricing_assigned_flag ?loan_entity - case_entity)
    (finalized ?loan_entity - case_entity)
    (settlement_posted ?loan_entity - case_entity)
    (charges_applied ?loan_entity - case_entity)
    (pricing_scheme_available ?pricing_scheme - pricing_scheme)
    (loan_pricing_assigned ?loan_entity - case_entity ?pricing_scheme - pricing_scheme)
    (notice_available ?early_repayment_notice - early_repayment_notice)
    (loan_notice_attached ?loan_entity - case_entity ?early_repayment_notice - early_repayment_notice)
    (servicing_agent_available ?servicing_agent - servicing_agent)
    (loan_servicing_assigned ?loan_entity - case_entity ?servicing_agent - servicing_agent)
    (business_document_available ?business_document - business_document)
    (primary_record_document_link ?primary_loan_record - primary_loan_record ?business_document - business_document)
    (secondary_record_document_link ?secondary_loan_record - secondary_loan_record ?business_document - business_document)
    (primary_record_exposure_link ?primary_loan_record - primary_loan_record ?exposure_component - exposure_component)
    (exposure_evaluated ?exposure_component - exposure_component)
    (exposure_adjusted ?exposure_component - exposure_component)
    (primary_assessment_complete ?primary_loan_record - primary_loan_record)
    (secondary_record_pricing_link ?secondary_loan_record - secondary_loan_record ?pricing_component - pricing_component)
    (pricing_component_selected ?pricing_component - pricing_component)
    (pricing_component_adjusted ?pricing_component - pricing_component)
    (secondary_assessment_complete ?secondary_loan_record - secondary_loan_record)
    (result_slot_available ?recalculation_result - recalculation_result)
    (recalculation_result_created ?recalculation_result - recalculation_result)
    (result_exposure_link ?recalculation_result - recalculation_result ?exposure_component - exposure_component)
    (result_pricing_link ?recalculation_result - recalculation_result ?pricing_component - pricing_component)
    (result_includes_primary ?recalculation_result - recalculation_result)
    (result_includes_secondary ?recalculation_result - recalculation_result)
    (result_locked ?recalculation_result - recalculation_result)
    (case_primary_record_link ?recalculation_case - recalculation_case ?primary_loan_record - primary_loan_record)
    (case_secondary_record_link ?recalculation_case - recalculation_case ?secondary_loan_record - secondary_loan_record)
    (case_result_link ?recalculation_case - recalculation_case ?recalculation_result - recalculation_result)
    (collateral_available ?collateral_item - collateral_item)
    (case_collateral_link ?recalculation_case - recalculation_case ?collateral_item - collateral_item)
    (collateral_reserved ?collateral_item - collateral_item)
    (collateral_linked_to_result ?collateral_item - collateral_item ?recalculation_result - recalculation_result)
    (case_result_locked ?recalculation_case - recalculation_case)
    (approval_prepared ?recalculation_case - recalculation_case)
    (approval_conditions_met ?recalculation_case - recalculation_case)
    (approval_document_assigned ?recalculation_case - recalculation_case)
    (approval_additional_flag ?recalculation_case - recalculation_case)
    (approval_signed ?recalculation_case - recalculation_case)
    (execution_permitted ?recalculation_case - recalculation_case)
    (policy_attachment_available ?policy_attachment - policy_attachment)
    (case_policy_attachment ?recalculation_case - recalculation_case ?policy_attachment - policy_attachment)
    (policy_attached_to_case ?recalculation_case - recalculation_case)
    (policy_reviewed ?recalculation_case - recalculation_case)
    (policy_approved ?recalculation_case - recalculation_case)
    (approval_document_available ?approval_document - approval_document)
    (case_approval_document_link ?recalculation_case - recalculation_case ?approval_document - approval_document)
    (adjustment_rule_available ?adjustment_rule - adjustment_rule)
    (case_adjustment_rule_link ?recalculation_case - recalculation_case ?adjustment_rule - adjustment_rule)
    (interest_override_available ?interest_override - interest_override)
    (case_interest_override_link ?recalculation_case - recalculation_case ?interest_override - interest_override)
    (regulatory_parameter_available ?regulatory_parameter - regulatory_parameter)
    (case_regulatory_parameter_link ?recalculation_case - recalculation_case ?regulatory_parameter - regulatory_parameter)
    (charge_schedule_item_available ?charge_schedule_item - charge_schedule_item)
    (loan_charge_candidate ?loan_entity - case_entity ?charge_schedule_item - charge_schedule_item)
    (primary_ready ?primary_loan_record - primary_loan_record)
    (secondary_ready ?secondary_loan_record - secondary_loan_record)
    (execution_logged ?recalculation_case - recalculation_case)
  )
  (:action enroll_loan_for_recalculation
    :parameters (?loan_entity - case_entity)
    :precondition
      (and
        (not
          (loan_recalc_enrolled ?loan_entity)
        )
        (not
          (finalized ?loan_entity)
        )
      )
    :effect (loan_recalc_enrolled ?loan_entity)
  )
  (:action assign_pricing_scheme_to_loan
    :parameters (?loan_entity - case_entity ?pricing_scheme - pricing_scheme)
    :precondition
      (and
        (loan_recalc_enrolled ?loan_entity)
        (not
          (loan_pricing_assigned_flag ?loan_entity)
        )
        (pricing_scheme_available ?pricing_scheme)
      )
    :effect
      (and
        (loan_pricing_assigned_flag ?loan_entity)
        (loan_pricing_assigned ?loan_entity ?pricing_scheme)
        (not
          (pricing_scheme_available ?pricing_scheme)
        )
      )
  )
  (:action attach_notice_to_loan
    :parameters (?loan_entity - case_entity ?early_repayment_notice - early_repayment_notice)
    :precondition
      (and
        (loan_recalc_enrolled ?loan_entity)
        (loan_pricing_assigned_flag ?loan_entity)
        (notice_available ?early_repayment_notice)
      )
    :effect
      (and
        (loan_notice_attached ?loan_entity ?early_repayment_notice)
        (not
          (notice_available ?early_repayment_notice)
        )
      )
  )
  (:action initiate_recalculation
    :parameters (?loan_entity - case_entity ?early_repayment_notice - early_repayment_notice)
    :precondition
      (and
        (loan_recalc_enrolled ?loan_entity)
        (loan_pricing_assigned_flag ?loan_entity)
        (loan_notice_attached ?loan_entity ?early_repayment_notice)
        (not
          (loan_recalc_initiated ?loan_entity)
        )
      )
    :effect (loan_recalc_initiated ?loan_entity)
  )
  (:action rollback_notice_attachment
    :parameters (?loan_entity - case_entity ?early_repayment_notice - early_repayment_notice)
    :precondition
      (and
        (loan_notice_attached ?loan_entity ?early_repayment_notice)
      )
    :effect
      (and
        (notice_available ?early_repayment_notice)
        (not
          (loan_notice_attached ?loan_entity ?early_repayment_notice)
        )
      )
  )
  (:action assign_servicing_agent
    :parameters (?loan_entity - case_entity ?servicing_agent - servicing_agent)
    :precondition
      (and
        (loan_recalc_initiated ?loan_entity)
        (servicing_agent_available ?servicing_agent)
      )
    :effect
      (and
        (loan_servicing_assigned ?loan_entity ?servicing_agent)
        (not
          (servicing_agent_available ?servicing_agent)
        )
      )
  )
  (:action unassign_servicing_agent
    :parameters (?loan_entity - case_entity ?servicing_agent - servicing_agent)
    :precondition
      (and
        (loan_servicing_assigned ?loan_entity ?servicing_agent)
      )
    :effect
      (and
        (servicing_agent_available ?servicing_agent)
        (not
          (loan_servicing_assigned ?loan_entity ?servicing_agent)
        )
      )
  )
  (:action attach_interest_override_to_case
    :parameters (?recalculation_case - recalculation_case ?interest_override - interest_override)
    :precondition
      (and
        (loan_recalc_initiated ?recalculation_case)
        (interest_override_available ?interest_override)
      )
    :effect
      (and
        (case_interest_override_link ?recalculation_case ?interest_override)
        (not
          (interest_override_available ?interest_override)
        )
      )
  )
  (:action detach_interest_override_from_case
    :parameters (?recalculation_case - recalculation_case ?interest_override - interest_override)
    :precondition
      (and
        (case_interest_override_link ?recalculation_case ?interest_override)
      )
    :effect
      (and
        (interest_override_available ?interest_override)
        (not
          (case_interest_override_link ?recalculation_case ?interest_override)
        )
      )
  )
  (:action attach_regulatory_parameter_to_case
    :parameters (?recalculation_case - recalculation_case ?regulatory_parameter - regulatory_parameter)
    :precondition
      (and
        (loan_recalc_initiated ?recalculation_case)
        (regulatory_parameter_available ?regulatory_parameter)
      )
    :effect
      (and
        (case_regulatory_parameter_link ?recalculation_case ?regulatory_parameter)
        (not
          (regulatory_parameter_available ?regulatory_parameter)
        )
      )
  )
  (:action detach_regulatory_parameter_from_case
    :parameters (?recalculation_case - recalculation_case ?regulatory_parameter - regulatory_parameter)
    :precondition
      (and
        (case_regulatory_parameter_link ?recalculation_case ?regulatory_parameter)
      )
    :effect
      (and
        (regulatory_parameter_available ?regulatory_parameter)
        (not
          (case_regulatory_parameter_link ?recalculation_case ?regulatory_parameter)
        )
      )
  )
  (:action evaluate_exposure_for_primary
    :parameters (?primary_loan_record - primary_loan_record ?exposure_component - exposure_component ?early_repayment_notice - early_repayment_notice)
    :precondition
      (and
        (loan_recalc_initiated ?primary_loan_record)
        (loan_notice_attached ?primary_loan_record ?early_repayment_notice)
        (primary_record_exposure_link ?primary_loan_record ?exposure_component)
        (not
          (exposure_evaluated ?exposure_component)
        )
        (not
          (exposure_adjusted ?exposure_component)
        )
      )
    :effect (exposure_evaluated ?exposure_component)
  )
  (:action confirm_primary_assessment_with_agent
    :parameters (?primary_loan_record - primary_loan_record ?exposure_component - exposure_component ?servicing_agent - servicing_agent)
    :precondition
      (and
        (loan_recalc_initiated ?primary_loan_record)
        (loan_servicing_assigned ?primary_loan_record ?servicing_agent)
        (primary_record_exposure_link ?primary_loan_record ?exposure_component)
        (exposure_evaluated ?exposure_component)
        (not
          (primary_ready ?primary_loan_record)
        )
      )
    :effect
      (and
        (primary_ready ?primary_loan_record)
        (primary_assessment_complete ?primary_loan_record)
      )
  )
  (:action attach_document_and_adjust_exposure_primary
    :parameters (?primary_loan_record - primary_loan_record ?exposure_component - exposure_component ?business_document - business_document)
    :precondition
      (and
        (loan_recalc_initiated ?primary_loan_record)
        (primary_record_exposure_link ?primary_loan_record ?exposure_component)
        (business_document_available ?business_document)
        (not
          (primary_ready ?primary_loan_record)
        )
      )
    :effect
      (and
        (exposure_adjusted ?exposure_component)
        (primary_ready ?primary_loan_record)
        (primary_record_document_link ?primary_loan_record ?business_document)
        (not
          (business_document_available ?business_document)
        )
      )
  )
  (:action complete_primary_exposure_assessment
    :parameters (?primary_loan_record - primary_loan_record ?exposure_component - exposure_component ?early_repayment_notice - early_repayment_notice ?business_document - business_document)
    :precondition
      (and
        (loan_recalc_initiated ?primary_loan_record)
        (loan_notice_attached ?primary_loan_record ?early_repayment_notice)
        (primary_record_exposure_link ?primary_loan_record ?exposure_component)
        (exposure_adjusted ?exposure_component)
        (primary_record_document_link ?primary_loan_record ?business_document)
        (not
          (primary_assessment_complete ?primary_loan_record)
        )
      )
    :effect
      (and
        (exposure_evaluated ?exposure_component)
        (primary_assessment_complete ?primary_loan_record)
        (business_document_available ?business_document)
        (not
          (primary_record_document_link ?primary_loan_record ?business_document)
        )
      )
  )
  (:action evaluate_pricing_for_secondary
    :parameters (?secondary_loan_record - secondary_loan_record ?pricing_component - pricing_component ?early_repayment_notice - early_repayment_notice)
    :precondition
      (and
        (loan_recalc_initiated ?secondary_loan_record)
        (loan_notice_attached ?secondary_loan_record ?early_repayment_notice)
        (secondary_record_pricing_link ?secondary_loan_record ?pricing_component)
        (not
          (pricing_component_selected ?pricing_component)
        )
        (not
          (pricing_component_adjusted ?pricing_component)
        )
      )
    :effect (pricing_component_selected ?pricing_component)
  )
  (:action confirm_secondary_assessment_with_agent
    :parameters (?secondary_loan_record - secondary_loan_record ?pricing_component - pricing_component ?servicing_agent - servicing_agent)
    :precondition
      (and
        (loan_recalc_initiated ?secondary_loan_record)
        (loan_servicing_assigned ?secondary_loan_record ?servicing_agent)
        (secondary_record_pricing_link ?secondary_loan_record ?pricing_component)
        (pricing_component_selected ?pricing_component)
        (not
          (secondary_ready ?secondary_loan_record)
        )
      )
    :effect
      (and
        (secondary_ready ?secondary_loan_record)
        (secondary_assessment_complete ?secondary_loan_record)
      )
  )
  (:action attach_document_and_adjust_pricing_secondary
    :parameters (?secondary_loan_record - secondary_loan_record ?pricing_component - pricing_component ?business_document - business_document)
    :precondition
      (and
        (loan_recalc_initiated ?secondary_loan_record)
        (secondary_record_pricing_link ?secondary_loan_record ?pricing_component)
        (business_document_available ?business_document)
        (not
          (secondary_ready ?secondary_loan_record)
        )
      )
    :effect
      (and
        (pricing_component_adjusted ?pricing_component)
        (secondary_ready ?secondary_loan_record)
        (secondary_record_document_link ?secondary_loan_record ?business_document)
        (not
          (business_document_available ?business_document)
        )
      )
  )
  (:action complete_secondary_assessment
    :parameters (?secondary_loan_record - secondary_loan_record ?pricing_component - pricing_component ?early_repayment_notice - early_repayment_notice ?business_document - business_document)
    :precondition
      (and
        (loan_recalc_initiated ?secondary_loan_record)
        (loan_notice_attached ?secondary_loan_record ?early_repayment_notice)
        (secondary_record_pricing_link ?secondary_loan_record ?pricing_component)
        (pricing_component_adjusted ?pricing_component)
        (secondary_record_document_link ?secondary_loan_record ?business_document)
        (not
          (secondary_assessment_complete ?secondary_loan_record)
        )
      )
    :effect
      (and
        (pricing_component_selected ?pricing_component)
        (secondary_assessment_complete ?secondary_loan_record)
        (business_document_available ?business_document)
        (not
          (secondary_record_document_link ?secondary_loan_record ?business_document)
        )
      )
  )
  (:action assemble_recalculation_package
    :parameters (?primary_loan_record - primary_loan_record ?secondary_loan_record - secondary_loan_record ?exposure_component - exposure_component ?pricing_component - pricing_component ?recalculation_result - recalculation_result)
    :precondition
      (and
        (primary_ready ?primary_loan_record)
        (secondary_ready ?secondary_loan_record)
        (primary_record_exposure_link ?primary_loan_record ?exposure_component)
        (secondary_record_pricing_link ?secondary_loan_record ?pricing_component)
        (exposure_evaluated ?exposure_component)
        (pricing_component_selected ?pricing_component)
        (primary_assessment_complete ?primary_loan_record)
        (secondary_assessment_complete ?secondary_loan_record)
        (result_slot_available ?recalculation_result)
      )
    :effect
      (and
        (recalculation_result_created ?recalculation_result)
        (result_exposure_link ?recalculation_result ?exposure_component)
        (result_pricing_link ?recalculation_result ?pricing_component)
        (not
          (result_slot_available ?recalculation_result)
        )
      )
  )
  (:action assemble_recalculation_package_mark_primary
    :parameters (?primary_loan_record - primary_loan_record ?secondary_loan_record - secondary_loan_record ?exposure_component - exposure_component ?pricing_component - pricing_component ?recalculation_result - recalculation_result)
    :precondition
      (and
        (primary_ready ?primary_loan_record)
        (secondary_ready ?secondary_loan_record)
        (primary_record_exposure_link ?primary_loan_record ?exposure_component)
        (secondary_record_pricing_link ?secondary_loan_record ?pricing_component)
        (exposure_adjusted ?exposure_component)
        (pricing_component_selected ?pricing_component)
        (not
          (primary_assessment_complete ?primary_loan_record)
        )
        (secondary_assessment_complete ?secondary_loan_record)
        (result_slot_available ?recalculation_result)
      )
    :effect
      (and
        (recalculation_result_created ?recalculation_result)
        (result_exposure_link ?recalculation_result ?exposure_component)
        (result_pricing_link ?recalculation_result ?pricing_component)
        (result_includes_primary ?recalculation_result)
        (not
          (result_slot_available ?recalculation_result)
        )
      )
  )
  (:action assemble_recalculation_package_mark_secondary
    :parameters (?primary_loan_record - primary_loan_record ?secondary_loan_record - secondary_loan_record ?exposure_component - exposure_component ?pricing_component - pricing_component ?recalculation_result - recalculation_result)
    :precondition
      (and
        (primary_ready ?primary_loan_record)
        (secondary_ready ?secondary_loan_record)
        (primary_record_exposure_link ?primary_loan_record ?exposure_component)
        (secondary_record_pricing_link ?secondary_loan_record ?pricing_component)
        (exposure_evaluated ?exposure_component)
        (pricing_component_adjusted ?pricing_component)
        (primary_assessment_complete ?primary_loan_record)
        (not
          (secondary_assessment_complete ?secondary_loan_record)
        )
        (result_slot_available ?recalculation_result)
      )
    :effect
      (and
        (recalculation_result_created ?recalculation_result)
        (result_exposure_link ?recalculation_result ?exposure_component)
        (result_pricing_link ?recalculation_result ?pricing_component)
        (result_includes_secondary ?recalculation_result)
        (not
          (result_slot_available ?recalculation_result)
        )
      )
  )
  (:action assemble_recalculation_package_mark_both
    :parameters (?primary_loan_record - primary_loan_record ?secondary_loan_record - secondary_loan_record ?exposure_component - exposure_component ?pricing_component - pricing_component ?recalculation_result - recalculation_result)
    :precondition
      (and
        (primary_ready ?primary_loan_record)
        (secondary_ready ?secondary_loan_record)
        (primary_record_exposure_link ?primary_loan_record ?exposure_component)
        (secondary_record_pricing_link ?secondary_loan_record ?pricing_component)
        (exposure_adjusted ?exposure_component)
        (pricing_component_adjusted ?pricing_component)
        (not
          (primary_assessment_complete ?primary_loan_record)
        )
        (not
          (secondary_assessment_complete ?secondary_loan_record)
        )
        (result_slot_available ?recalculation_result)
      )
    :effect
      (and
        (recalculation_result_created ?recalculation_result)
        (result_exposure_link ?recalculation_result ?exposure_component)
        (result_pricing_link ?recalculation_result ?pricing_component)
        (result_includes_primary ?recalculation_result)
        (result_includes_secondary ?recalculation_result)
        (not
          (result_slot_available ?recalculation_result)
        )
      )
  )
  (:action lock_recalculation_result
    :parameters (?recalculation_result - recalculation_result ?primary_loan_record - primary_loan_record ?early_repayment_notice - early_repayment_notice)
    :precondition
      (and
        (recalculation_result_created ?recalculation_result)
        (primary_ready ?primary_loan_record)
        (loan_notice_attached ?primary_loan_record ?early_repayment_notice)
        (not
          (result_locked ?recalculation_result)
        )
      )
    :effect (result_locked ?recalculation_result)
  )
  (:action attach_collateral_to_result
    :parameters (?recalculation_case - recalculation_case ?collateral_item - collateral_item ?recalculation_result - recalculation_result)
    :precondition
      (and
        (loan_recalc_initiated ?recalculation_case)
        (case_result_link ?recalculation_case ?recalculation_result)
        (case_collateral_link ?recalculation_case ?collateral_item)
        (collateral_available ?collateral_item)
        (recalculation_result_created ?recalculation_result)
        (result_locked ?recalculation_result)
        (not
          (collateral_reserved ?collateral_item)
        )
      )
    :effect
      (and
        (collateral_reserved ?collateral_item)
        (collateral_linked_to_result ?collateral_item ?recalculation_result)
        (not
          (collateral_available ?collateral_item)
        )
      )
  )
  (:action finalize_collateral_and_lock_case
    :parameters (?recalculation_case - recalculation_case ?collateral_item - collateral_item ?recalculation_result - recalculation_result ?early_repayment_notice - early_repayment_notice)
    :precondition
      (and
        (loan_recalc_initiated ?recalculation_case)
        (case_collateral_link ?recalculation_case ?collateral_item)
        (collateral_reserved ?collateral_item)
        (collateral_linked_to_result ?collateral_item ?recalculation_result)
        (loan_notice_attached ?recalculation_case ?early_repayment_notice)
        (not
          (result_includes_primary ?recalculation_result)
        )
        (not
          (case_result_locked ?recalculation_case)
        )
      )
    :effect (case_result_locked ?recalculation_case)
  )
  (:action attach_approval_document_to_case
    :parameters (?recalculation_case - recalculation_case ?approval_document - approval_document)
    :precondition
      (and
        (loan_recalc_initiated ?recalculation_case)
        (approval_document_available ?approval_document)
        (not
          (approval_document_assigned ?recalculation_case)
        )
      )
    :effect
      (and
        (approval_document_assigned ?recalculation_case)
        (case_approval_document_link ?recalculation_case ?approval_document)
        (not
          (approval_document_available ?approval_document)
        )
      )
  )
  (:action apply_approval_conditions_to_case
    :parameters (?recalculation_case - recalculation_case ?collateral_item - collateral_item ?recalculation_result - recalculation_result ?early_repayment_notice - early_repayment_notice ?approval_document - approval_document)
    :precondition
      (and
        (loan_recalc_initiated ?recalculation_case)
        (case_collateral_link ?recalculation_case ?collateral_item)
        (collateral_reserved ?collateral_item)
        (collateral_linked_to_result ?collateral_item ?recalculation_result)
        (loan_notice_attached ?recalculation_case ?early_repayment_notice)
        (result_includes_primary ?recalculation_result)
        (approval_document_assigned ?recalculation_case)
        (case_approval_document_link ?recalculation_case ?approval_document)
        (not
          (case_result_locked ?recalculation_case)
        )
      )
    :effect
      (and
        (case_result_locked ?recalculation_case)
        (approval_additional_flag ?recalculation_case)
      )
  )
  (:action prepare_case_for_approval_stage
    :parameters (?recalculation_case - recalculation_case ?interest_override - interest_override ?servicing_agent - servicing_agent ?collateral_item - collateral_item ?recalculation_result - recalculation_result)
    :precondition
      (and
        (case_result_locked ?recalculation_case)
        (case_interest_override_link ?recalculation_case ?interest_override)
        (loan_servicing_assigned ?recalculation_case ?servicing_agent)
        (case_collateral_link ?recalculation_case ?collateral_item)
        (collateral_linked_to_result ?collateral_item ?recalculation_result)
        (not
          (result_includes_secondary ?recalculation_result)
        )
        (not
          (approval_prepared ?recalculation_case)
        )
      )
    :effect (approval_prepared ?recalculation_case)
  )
  (:action prepare_case_for_approval_stage_alternate
    :parameters (?recalculation_case - recalculation_case ?interest_override - interest_override ?servicing_agent - servicing_agent ?collateral_item - collateral_item ?recalculation_result - recalculation_result)
    :precondition
      (and
        (case_result_locked ?recalculation_case)
        (case_interest_override_link ?recalculation_case ?interest_override)
        (loan_servicing_assigned ?recalculation_case ?servicing_agent)
        (case_collateral_link ?recalculation_case ?collateral_item)
        (collateral_linked_to_result ?collateral_item ?recalculation_result)
        (result_includes_secondary ?recalculation_result)
        (not
          (approval_prepared ?recalculation_case)
        )
      )
    :effect (approval_prepared ?recalculation_case)
  )
  (:action mark_approval_conditions_met
    :parameters (?recalculation_case - recalculation_case ?regulatory_parameter - regulatory_parameter ?collateral_item - collateral_item ?recalculation_result - recalculation_result)
    :precondition
      (and
        (approval_prepared ?recalculation_case)
        (case_regulatory_parameter_link ?recalculation_case ?regulatory_parameter)
        (case_collateral_link ?recalculation_case ?collateral_item)
        (collateral_linked_to_result ?collateral_item ?recalculation_result)
        (not
          (result_includes_primary ?recalculation_result)
        )
        (not
          (result_includes_secondary ?recalculation_result)
        )
        (not
          (approval_conditions_met ?recalculation_case)
        )
      )
    :effect (approval_conditions_met ?recalculation_case)
  )
  (:action mark_approval_and_sign
    :parameters (?recalculation_case - recalculation_case ?regulatory_parameter - regulatory_parameter ?collateral_item - collateral_item ?recalculation_result - recalculation_result)
    :precondition
      (and
        (approval_prepared ?recalculation_case)
        (case_regulatory_parameter_link ?recalculation_case ?regulatory_parameter)
        (case_collateral_link ?recalculation_case ?collateral_item)
        (collateral_linked_to_result ?collateral_item ?recalculation_result)
        (result_includes_primary ?recalculation_result)
        (not
          (result_includes_secondary ?recalculation_result)
        )
        (not
          (approval_conditions_met ?recalculation_case)
        )
      )
    :effect
      (and
        (approval_conditions_met ?recalculation_case)
        (approval_signed ?recalculation_case)
      )
  )
  (:action mark_approval_and_sign_alternate
    :parameters (?recalculation_case - recalculation_case ?regulatory_parameter - regulatory_parameter ?collateral_item - collateral_item ?recalculation_result - recalculation_result)
    :precondition
      (and
        (approval_prepared ?recalculation_case)
        (case_regulatory_parameter_link ?recalculation_case ?regulatory_parameter)
        (case_collateral_link ?recalculation_case ?collateral_item)
        (collateral_linked_to_result ?collateral_item ?recalculation_result)
        (not
          (result_includes_primary ?recalculation_result)
        )
        (result_includes_secondary ?recalculation_result)
        (not
          (approval_conditions_met ?recalculation_case)
        )
      )
    :effect
      (and
        (approval_conditions_met ?recalculation_case)
        (approval_signed ?recalculation_case)
      )
  )
  (:action mark_approval_and_sign_final
    :parameters (?recalculation_case - recalculation_case ?regulatory_parameter - regulatory_parameter ?collateral_item - collateral_item ?recalculation_result - recalculation_result)
    :precondition
      (and
        (approval_prepared ?recalculation_case)
        (case_regulatory_parameter_link ?recalculation_case ?regulatory_parameter)
        (case_collateral_link ?recalculation_case ?collateral_item)
        (collateral_linked_to_result ?collateral_item ?recalculation_result)
        (result_includes_primary ?recalculation_result)
        (result_includes_secondary ?recalculation_result)
        (not
          (approval_conditions_met ?recalculation_case)
        )
      )
    :effect
      (and
        (approval_conditions_met ?recalculation_case)
        (approval_signed ?recalculation_case)
      )
  )
  (:action execute_case_unsignatured
    :parameters (?recalculation_case - recalculation_case)
    :precondition
      (and
        (approval_conditions_met ?recalculation_case)
        (not
          (approval_signed ?recalculation_case)
        )
        (not
          (execution_logged ?recalculation_case)
        )
      )
    :effect
      (and
        (execution_logged ?recalculation_case)
        (settlement_posted ?recalculation_case)
      )
  )
  (:action attach_adjustment_rule_to_case
    :parameters (?recalculation_case - recalculation_case ?adjustment_rule - adjustment_rule)
    :precondition
      (and
        (approval_conditions_met ?recalculation_case)
        (approval_signed ?recalculation_case)
        (adjustment_rule_available ?adjustment_rule)
      )
    :effect
      (and
        (case_adjustment_rule_link ?recalculation_case ?adjustment_rule)
        (not
          (adjustment_rule_available ?adjustment_rule)
        )
      )
  )
  (:action authorize_case_for_execution
    :parameters (?recalculation_case - recalculation_case ?primary_loan_record - primary_loan_record ?secondary_loan_record - secondary_loan_record ?early_repayment_notice - early_repayment_notice ?adjustment_rule - adjustment_rule)
    :precondition
      (and
        (approval_conditions_met ?recalculation_case)
        (approval_signed ?recalculation_case)
        (case_adjustment_rule_link ?recalculation_case ?adjustment_rule)
        (case_primary_record_link ?recalculation_case ?primary_loan_record)
        (case_secondary_record_link ?recalculation_case ?secondary_loan_record)
        (primary_assessment_complete ?primary_loan_record)
        (secondary_assessment_complete ?secondary_loan_record)
        (loan_notice_attached ?recalculation_case ?early_repayment_notice)
        (not
          (execution_permitted ?recalculation_case)
        )
      )
    :effect (execution_permitted ?recalculation_case)
  )
  (:action execute_case_after_authorization
    :parameters (?recalculation_case - recalculation_case)
    :precondition
      (and
        (approval_conditions_met ?recalculation_case)
        (execution_permitted ?recalculation_case)
        (not
          (execution_logged ?recalculation_case)
        )
      )
    :effect
      (and
        (execution_logged ?recalculation_case)
        (settlement_posted ?recalculation_case)
      )
  )
  (:action attach_policy_to_case
    :parameters (?recalculation_case - recalculation_case ?policy_attachment - policy_attachment ?early_repayment_notice - early_repayment_notice)
    :precondition
      (and
        (loan_recalc_initiated ?recalculation_case)
        (loan_notice_attached ?recalculation_case ?early_repayment_notice)
        (policy_attachment_available ?policy_attachment)
        (case_policy_attachment ?recalculation_case ?policy_attachment)
        (not
          (policy_attached_to_case ?recalculation_case)
        )
      )
    :effect
      (and
        (policy_attached_to_case ?recalculation_case)
        (not
          (policy_attachment_available ?policy_attachment)
        )
      )
  )
  (:action verify_policy_compliance
    :parameters (?recalculation_case - recalculation_case ?servicing_agent - servicing_agent)
    :precondition
      (and
        (policy_attached_to_case ?recalculation_case)
        (loan_servicing_assigned ?recalculation_case ?servicing_agent)
        (not
          (policy_reviewed ?recalculation_case)
        )
      )
    :effect (policy_reviewed ?recalculation_case)
  )
  (:action apply_regulatory_parameter_to_case
    :parameters (?recalculation_case - recalculation_case ?regulatory_parameter - regulatory_parameter)
    :precondition
      (and
        (policy_reviewed ?recalculation_case)
        (case_regulatory_parameter_link ?recalculation_case ?regulatory_parameter)
        (not
          (policy_approved ?recalculation_case)
        )
      )
    :effect (policy_approved ?recalculation_case)
  )
  (:action execute_case_after_policy_approval
    :parameters (?recalculation_case - recalculation_case)
    :precondition
      (and
        (policy_approved ?recalculation_case)
        (not
          (execution_logged ?recalculation_case)
        )
      )
    :effect
      (and
        (execution_logged ?recalculation_case)
        (settlement_posted ?recalculation_case)
      )
  )
  (:action apply_recalculation_result_to_primary_record
    :parameters (?primary_loan_record - primary_loan_record ?recalculation_result - recalculation_result)
    :precondition
      (and
        (primary_ready ?primary_loan_record)
        (primary_assessment_complete ?primary_loan_record)
        (recalculation_result_created ?recalculation_result)
        (result_locked ?recalculation_result)
        (not
          (settlement_posted ?primary_loan_record)
        )
      )
    :effect (settlement_posted ?primary_loan_record)
  )
  (:action apply_recalculation_result_to_secondary_record
    :parameters (?secondary_loan_record - secondary_loan_record ?recalculation_result - recalculation_result)
    :precondition
      (and
        (secondary_ready ?secondary_loan_record)
        (secondary_assessment_complete ?secondary_loan_record)
        (recalculation_result_created ?recalculation_result)
        (result_locked ?recalculation_result)
        (not
          (settlement_posted ?secondary_loan_record)
        )
      )
    :effect (settlement_posted ?secondary_loan_record)
  )
  (:action apply_charges_to_loan
    :parameters (?loan_entity - case_entity ?charge_schedule_item - charge_schedule_item ?early_repayment_notice - early_repayment_notice)
    :precondition
      (and
        (settlement_posted ?loan_entity)
        (loan_notice_attached ?loan_entity ?early_repayment_notice)
        (charge_schedule_item_available ?charge_schedule_item)
        (not
          (charges_applied ?loan_entity)
        )
      )
    :effect
      (and
        (charges_applied ?loan_entity)
        (loan_charge_candidate ?loan_entity ?charge_schedule_item)
        (not
          (charge_schedule_item_available ?charge_schedule_item)
        )
      )
  )
  (:action finalize_primary_record_and_release_pricing_scheme
    :parameters (?primary_loan_record - primary_loan_record ?pricing_scheme - pricing_scheme ?charge_schedule_item - charge_schedule_item)
    :precondition
      (and
        (charges_applied ?primary_loan_record)
        (loan_pricing_assigned ?primary_loan_record ?pricing_scheme)
        (loan_charge_candidate ?primary_loan_record ?charge_schedule_item)
        (not
          (finalized ?primary_loan_record)
        )
      )
    :effect
      (and
        (finalized ?primary_loan_record)
        (pricing_scheme_available ?pricing_scheme)
        (charge_schedule_item_available ?charge_schedule_item)
      )
  )
  (:action finalize_secondary_record_and_release_pricing_scheme
    :parameters (?secondary_loan_record - secondary_loan_record ?pricing_scheme - pricing_scheme ?charge_schedule_item - charge_schedule_item)
    :precondition
      (and
        (charges_applied ?secondary_loan_record)
        (loan_pricing_assigned ?secondary_loan_record ?pricing_scheme)
        (loan_charge_candidate ?secondary_loan_record ?charge_schedule_item)
        (not
          (finalized ?secondary_loan_record)
        )
      )
    :effect
      (and
        (finalized ?secondary_loan_record)
        (pricing_scheme_available ?pricing_scheme)
        (charge_schedule_item_available ?charge_schedule_item)
      )
  )
  (:action finalize_case_and_release_pricing_scheme
    :parameters (?recalculation_case - recalculation_case ?pricing_scheme - pricing_scheme ?charge_schedule_item - charge_schedule_item)
    :precondition
      (and
        (charges_applied ?recalculation_case)
        (loan_pricing_assigned ?recalculation_case ?pricing_scheme)
        (loan_charge_candidate ?recalculation_case ?charge_schedule_item)
        (not
          (finalized ?recalculation_case)
        )
      )
    :effect
      (and
        (finalized ?recalculation_case)
        (pricing_scheme_available ?pricing_scheme)
        (charge_schedule_item_available ?charge_schedule_item)
      )
  )
)

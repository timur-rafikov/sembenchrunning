(define (domain covenant_package_assignment_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types object_root - object resource_group - object_root asset_group - object_root package_component_group - object_root case_entity_root - object_root case_entity - case_entity_root covenant_package_template - resource_group pricing_model - resource_group credit_reviewer - resource_group clause_template - resource_group approval_document - resource_group assignment_evidence - resource_group security_action - resource_group external_condition - resource_group collateral_asset - asset_group document_bundle - asset_group regulatory_notice - asset_group exposure_profile - package_component_group drawdown_profile - package_component_group assignment_record - package_component_group obligor_role - case_entity package_instance_marker - case_entity borrower_obligor - obligor_role guarantor_obligor - obligor_role covenant_package_instance - package_instance_marker)

  (:predicates
    (credit_case_opened ?case_entity - case_entity)
    (credit_review_cleared ?case_entity - case_entity)
    (template_reserved ?case_entity - case_entity)
    (assignment_confirmed ?case_entity - case_entity)
    (assignment_authorized ?case_entity - case_entity)
    (assignment_clearance_recorded ?case_entity - case_entity)
    (covenant_template_available ?covenant_package_template - covenant_package_template)
    (template_linked_to_case ?case_entity - case_entity ?covenant_package_template - covenant_package_template)
    (pricing_model_available ?pricing_model - pricing_model)
    (pricing_model_linked_to_case ?case_entity - case_entity ?pricing_model - pricing_model)
    (reviewer_available ?credit_reviewer - credit_reviewer)
    (reviewer_linked_to_case ?case_entity - case_entity ?credit_reviewer - credit_reviewer)
    (collateral_asset_available ?collateral_asset - collateral_asset)
    (borrower_collateral_linked ?borrower_obligor - borrower_obligor ?collateral_asset - collateral_asset)
    (guarantor_collateral_linked ?guarantor_obligor - guarantor_obligor ?collateral_asset - collateral_asset)
    (borrower_exposure_profile_assigned ?borrower_obligor - borrower_obligor ?exposure_profile - exposure_profile)
    (borrower_exposure_profile_selected ?exposure_profile - exposure_profile)
    (borrower_exposure_profile_adjusted ?exposure_profile - exposure_profile)
    (borrower_control_confirmed ?borrower_obligor - borrower_obligor)
    (guarantor_drawdown_profile_assigned ?guarantor_obligor - guarantor_obligor ?drawdown_profile - drawdown_profile)
    (guarantor_drawdown_profile_selected ?drawdown_profile - drawdown_profile)
    (guarantor_drawdown_profile_adjusted ?drawdown_profile - drawdown_profile)
    (guarantor_control_confirmed ?guarantor_obligor - guarantor_obligor)
    (assignment_record_available ?assignment_record - assignment_record)
    (assignment_record_prepared ?assignment_record - assignment_record)
    (assignment_record_borrower_profile_linked ?assignment_record - assignment_record ?exposure_profile - exposure_profile)
    (assignment_record_guarantor_profile_linked ?assignment_record - assignment_record ?drawdown_profile - drawdown_profile)
    (assignment_record_flag_alpha ?assignment_record - assignment_record)
    (assignment_record_flag_beta ?assignment_record - assignment_record)
    (assignment_record_locked ?assignment_record - assignment_record)
    (borrower_linked_to_case ?covenant_package_instance - covenant_package_instance ?borrower_obligor - borrower_obligor)
    (guarantor_linked_to_case ?covenant_package_instance - covenant_package_instance ?guarantor_obligor - guarantor_obligor)
    (assignment_record_linked_to_case ?covenant_package_instance - covenant_package_instance ?assignment_record - assignment_record)
    (document_bundle_available ?document_bundle - document_bundle)
    (document_bundle_linked_to_case ?covenant_package_instance - covenant_package_instance ?document_bundle - document_bundle)
    (document_bundle_reserved ?document_bundle - document_bundle)
    (document_bundle_drawdown_linked ?document_bundle - document_bundle ?assignment_record - assignment_record)
    (package_documentation_complete ?covenant_package_instance - covenant_package_instance)
    (package_security_action_recorded ?covenant_package_instance - covenant_package_instance)
    (package_security_path_complete ?covenant_package_instance - covenant_package_instance)
    (clause_template_selected ?covenant_package_instance - covenant_package_instance)
    (package_clause_bundle_complete ?covenant_package_instance - covenant_package_instance)
    (package_signoff_ready ?covenant_package_instance - covenant_package_instance)
    (package_signoff_recorded ?covenant_package_instance - covenant_package_instance)
    (regulatory_notice_available ?regulatory_notice - regulatory_notice)
    (regulatory_notice_linked_to_case ?covenant_package_instance - covenant_package_instance ?regulatory_notice - regulatory_notice)
    (regulatory_notice_recorded ?covenant_package_instance - covenant_package_instance)
    (reviewer_clearance_recorded ?covenant_package_instance - covenant_package_instance)
    (external_condition_clearance_recorded ?covenant_package_instance - covenant_package_instance)
    (clause_template_available ?clause_template - clause_template)
    (clause_template_linked_to_case ?covenant_package_instance - covenant_package_instance ?clause_template - clause_template)
    (approval_document_available ?approval_document - approval_document)
    (approval_document_linked_to_case ?covenant_package_instance - covenant_package_instance ?approval_document - approval_document)
    (security_action_available ?security_action - security_action)
    (security_action_linked_to_case ?covenant_package_instance - covenant_package_instance ?security_action - security_action)
    (external_condition_available ?external_condition - external_condition)
    (external_condition_linked_to_case ?covenant_package_instance - covenant_package_instance ?external_condition - external_condition)
    (assignment_evidence_available ?assignment_evidence - assignment_evidence)
    (assignment_evidence_linked_to_case ?case_entity - case_entity ?assignment_evidence - assignment_evidence)
    (borrower_control_flagged ?borrower_obligor - borrower_obligor)
    (guarantor_control_flagged ?guarantor_obligor - guarantor_obligor)
    (package_final_approval_granted ?covenant_package_instance - covenant_package_instance)
  )
  (:action open_credit_case
    :parameters (?case_entity - case_entity)
    :precondition
      (and
        (not
          (credit_case_opened ?case_entity)
        )
        (not
          (assignment_confirmed ?case_entity)
        )
      )
    :effect (credit_case_opened ?case_entity)
  )
  (:action reserve_covenant_template
    :parameters (?case_entity - case_entity ?covenant_package_template - covenant_package_template)
    :precondition
      (and
        (credit_case_opened ?case_entity)
        (not
          (template_reserved ?case_entity)
        )
        (covenant_template_available ?covenant_package_template)
      )
    :effect
      (and
        (template_reserved ?case_entity)
        (template_linked_to_case ?case_entity ?covenant_package_template)
        (not
          (covenant_template_available ?covenant_package_template)
        )
      )
  )
  (:action apply_pricing_model
    :parameters (?case_entity - case_entity ?pricing_model - pricing_model)
    :precondition
      (and
        (credit_case_opened ?case_entity)
        (template_reserved ?case_entity)
        (pricing_model_available ?pricing_model)
      )
    :effect
      (and
        (pricing_model_linked_to_case ?case_entity ?pricing_model)
        (not
          (pricing_model_available ?pricing_model)
        )
      )
  )
  (:action confirm_pricing_model
    :parameters (?case_entity - case_entity ?pricing_model - pricing_model)
    :precondition
      (and
        (credit_case_opened ?case_entity)
        (template_reserved ?case_entity)
        (pricing_model_linked_to_case ?case_entity ?pricing_model)
        (not
          (credit_review_cleared ?case_entity)
        )
      )
    :effect (credit_review_cleared ?case_entity)
  )
  (:action release_pricing_model
    :parameters (?case_entity - case_entity ?pricing_model - pricing_model)
    :precondition
      (and
        (pricing_model_linked_to_case ?case_entity ?pricing_model)
      )
    :effect
      (and
        (pricing_model_available ?pricing_model)
        (not
          (pricing_model_linked_to_case ?case_entity ?pricing_model)
        )
      )
  )
  (:action assign_reviewer
    :parameters (?case_entity - case_entity ?credit_reviewer - credit_reviewer)
    :precondition
      (and
        (credit_review_cleared ?case_entity)
        (reviewer_available ?credit_reviewer)
      )
    :effect
      (and
        (reviewer_linked_to_case ?case_entity ?credit_reviewer)
        (not
          (reviewer_available ?credit_reviewer)
        )
      )
  )
  (:action release_reviewer
    :parameters (?case_entity - case_entity ?credit_reviewer - credit_reviewer)
    :precondition
      (and
        (reviewer_linked_to_case ?case_entity ?credit_reviewer)
      )
    :effect
      (and
        (reviewer_available ?credit_reviewer)
        (not
          (reviewer_linked_to_case ?case_entity ?credit_reviewer)
        )
      )
  )
  (:action attach_security_action
    :parameters (?covenant_package_instance - covenant_package_instance ?security_action - security_action)
    :precondition
      (and
        (credit_review_cleared ?covenant_package_instance)
        (security_action_available ?security_action)
      )
    :effect
      (and
        (security_action_linked_to_case ?covenant_package_instance ?security_action)
        (not
          (security_action_available ?security_action)
        )
      )
  )
  (:action release_security_action
    :parameters (?covenant_package_instance - covenant_package_instance ?security_action - security_action)
    :precondition
      (and
        (security_action_linked_to_case ?covenant_package_instance ?security_action)
      )
    :effect
      (and
        (security_action_available ?security_action)
        (not
          (security_action_linked_to_case ?covenant_package_instance ?security_action)
        )
      )
  )
  (:action attach_external_condition
    :parameters (?covenant_package_instance - covenant_package_instance ?external_condition - external_condition)
    :precondition
      (and
        (credit_review_cleared ?covenant_package_instance)
        (external_condition_available ?external_condition)
      )
    :effect
      (and
        (external_condition_linked_to_case ?covenant_package_instance ?external_condition)
        (not
          (external_condition_available ?external_condition)
        )
      )
  )
  (:action release_external_condition
    :parameters (?covenant_package_instance - covenant_package_instance ?external_condition - external_condition)
    :precondition
      (and
        (external_condition_linked_to_case ?covenant_package_instance ?external_condition)
      )
    :effect
      (and
        (external_condition_available ?external_condition)
        (not
          (external_condition_linked_to_case ?covenant_package_instance ?external_condition)
        )
      )
  )
  (:action select_borrower_exposure_profile
    :parameters (?borrower_obligor - borrower_obligor ?exposure_profile - exposure_profile ?pricing_model - pricing_model)
    :precondition
      (and
        (credit_review_cleared ?borrower_obligor)
        (pricing_model_linked_to_case ?borrower_obligor ?pricing_model)
        (borrower_exposure_profile_assigned ?borrower_obligor ?exposure_profile)
        (not
          (borrower_exposure_profile_selected ?exposure_profile)
        )
        (not
          (borrower_exposure_profile_adjusted ?exposure_profile)
        )
      )
    :effect (borrower_exposure_profile_selected ?exposure_profile)
  )
  (:action confirm_borrower_controls
    :parameters (?borrower_obligor - borrower_obligor ?exposure_profile - exposure_profile ?credit_reviewer - credit_reviewer)
    :precondition
      (and
        (credit_review_cleared ?borrower_obligor)
        (reviewer_linked_to_case ?borrower_obligor ?credit_reviewer)
        (borrower_exposure_profile_assigned ?borrower_obligor ?exposure_profile)
        (borrower_exposure_profile_selected ?exposure_profile)
        (not
          (borrower_control_flagged ?borrower_obligor)
        )
      )
    :effect
      (and
        (borrower_control_flagged ?borrower_obligor)
        (borrower_control_confirmed ?borrower_obligor)
      )
  )
  (:action attach_borrower_collateral
    :parameters (?borrower_obligor - borrower_obligor ?exposure_profile - exposure_profile ?collateral_asset - collateral_asset)
    :precondition
      (and
        (credit_review_cleared ?borrower_obligor)
        (borrower_exposure_profile_assigned ?borrower_obligor ?exposure_profile)
        (collateral_asset_available ?collateral_asset)
        (not
          (borrower_control_flagged ?borrower_obligor)
        )
      )
    :effect
      (and
        (borrower_exposure_profile_adjusted ?exposure_profile)
        (borrower_control_flagged ?borrower_obligor)
        (borrower_collateral_linked ?borrower_obligor ?collateral_asset)
        (not
          (collateral_asset_available ?collateral_asset)
        )
      )
  )
  (:action release_borrower_collateral
    :parameters (?borrower_obligor - borrower_obligor ?exposure_profile - exposure_profile ?pricing_model - pricing_model ?collateral_asset - collateral_asset)
    :precondition
      (and
        (credit_review_cleared ?borrower_obligor)
        (pricing_model_linked_to_case ?borrower_obligor ?pricing_model)
        (borrower_exposure_profile_assigned ?borrower_obligor ?exposure_profile)
        (borrower_exposure_profile_adjusted ?exposure_profile)
        (borrower_collateral_linked ?borrower_obligor ?collateral_asset)
        (not
          (borrower_control_confirmed ?borrower_obligor)
        )
      )
    :effect
      (and
        (borrower_exposure_profile_selected ?exposure_profile)
        (borrower_control_confirmed ?borrower_obligor)
        (collateral_asset_available ?collateral_asset)
        (not
          (borrower_collateral_linked ?borrower_obligor ?collateral_asset)
        )
      )
  )
  (:action select_guarantor_drawdown_profile
    :parameters (?guarantor_obligor - guarantor_obligor ?drawdown_profile - drawdown_profile ?pricing_model - pricing_model)
    :precondition
      (and
        (credit_review_cleared ?guarantor_obligor)
        (pricing_model_linked_to_case ?guarantor_obligor ?pricing_model)
        (guarantor_drawdown_profile_assigned ?guarantor_obligor ?drawdown_profile)
        (not
          (guarantor_drawdown_profile_selected ?drawdown_profile)
        )
        (not
          (guarantor_drawdown_profile_adjusted ?drawdown_profile)
        )
      )
    :effect (guarantor_drawdown_profile_selected ?drawdown_profile)
  )
  (:action confirm_guarantor_controls
    :parameters (?guarantor_obligor - guarantor_obligor ?drawdown_profile - drawdown_profile ?credit_reviewer - credit_reviewer)
    :precondition
      (and
        (credit_review_cleared ?guarantor_obligor)
        (reviewer_linked_to_case ?guarantor_obligor ?credit_reviewer)
        (guarantor_drawdown_profile_assigned ?guarantor_obligor ?drawdown_profile)
        (guarantor_drawdown_profile_selected ?drawdown_profile)
        (not
          (guarantor_control_flagged ?guarantor_obligor)
        )
      )
    :effect
      (and
        (guarantor_control_flagged ?guarantor_obligor)
        (guarantor_control_confirmed ?guarantor_obligor)
      )
  )
  (:action attach_guarantor_collateral
    :parameters (?guarantor_obligor - guarantor_obligor ?drawdown_profile - drawdown_profile ?collateral_asset - collateral_asset)
    :precondition
      (and
        (credit_review_cleared ?guarantor_obligor)
        (guarantor_drawdown_profile_assigned ?guarantor_obligor ?drawdown_profile)
        (collateral_asset_available ?collateral_asset)
        (not
          (guarantor_control_flagged ?guarantor_obligor)
        )
      )
    :effect
      (and
        (guarantor_drawdown_profile_adjusted ?drawdown_profile)
        (guarantor_control_flagged ?guarantor_obligor)
        (guarantor_collateral_linked ?guarantor_obligor ?collateral_asset)
        (not
          (collateral_asset_available ?collateral_asset)
        )
      )
  )
  (:action release_guarantor_collateral
    :parameters (?guarantor_obligor - guarantor_obligor ?drawdown_profile - drawdown_profile ?pricing_model - pricing_model ?collateral_asset - collateral_asset)
    :precondition
      (and
        (credit_review_cleared ?guarantor_obligor)
        (pricing_model_linked_to_case ?guarantor_obligor ?pricing_model)
        (guarantor_drawdown_profile_assigned ?guarantor_obligor ?drawdown_profile)
        (guarantor_drawdown_profile_adjusted ?drawdown_profile)
        (guarantor_collateral_linked ?guarantor_obligor ?collateral_asset)
        (not
          (guarantor_control_confirmed ?guarantor_obligor)
        )
      )
    :effect
      (and
        (guarantor_drawdown_profile_selected ?drawdown_profile)
        (guarantor_control_confirmed ?guarantor_obligor)
        (collateral_asset_available ?collateral_asset)
        (not
          (guarantor_collateral_linked ?guarantor_obligor ?collateral_asset)
        )
      )
  )
  (:action assemble_assignment_record_standard
    :parameters (?borrower_obligor - borrower_obligor ?guarantor_obligor - guarantor_obligor ?exposure_profile - exposure_profile ?drawdown_profile - drawdown_profile ?assignment_record - assignment_record)
    :precondition
      (and
        (borrower_control_flagged ?borrower_obligor)
        (guarantor_control_flagged ?guarantor_obligor)
        (borrower_exposure_profile_assigned ?borrower_obligor ?exposure_profile)
        (guarantor_drawdown_profile_assigned ?guarantor_obligor ?drawdown_profile)
        (borrower_exposure_profile_selected ?exposure_profile)
        (guarantor_drawdown_profile_selected ?drawdown_profile)
        (borrower_control_confirmed ?borrower_obligor)
        (guarantor_control_confirmed ?guarantor_obligor)
        (assignment_record_available ?assignment_record)
      )
    :effect
      (and
        (assignment_record_prepared ?assignment_record)
        (assignment_record_borrower_profile_linked ?assignment_record ?exposure_profile)
        (assignment_record_guarantor_profile_linked ?assignment_record ?drawdown_profile)
        (not
          (assignment_record_available ?assignment_record)
        )
      )
  )
  (:action assemble_assignment_record_borrower_adjusted
    :parameters (?borrower_obligor - borrower_obligor ?guarantor_obligor - guarantor_obligor ?exposure_profile - exposure_profile ?drawdown_profile - drawdown_profile ?assignment_record - assignment_record)
    :precondition
      (and
        (borrower_control_flagged ?borrower_obligor)
        (guarantor_control_flagged ?guarantor_obligor)
        (borrower_exposure_profile_assigned ?borrower_obligor ?exposure_profile)
        (guarantor_drawdown_profile_assigned ?guarantor_obligor ?drawdown_profile)
        (borrower_exposure_profile_adjusted ?exposure_profile)
        (guarantor_drawdown_profile_selected ?drawdown_profile)
        (not
          (borrower_control_confirmed ?borrower_obligor)
        )
        (guarantor_control_confirmed ?guarantor_obligor)
        (assignment_record_available ?assignment_record)
      )
    :effect
      (and
        (assignment_record_prepared ?assignment_record)
        (assignment_record_borrower_profile_linked ?assignment_record ?exposure_profile)
        (assignment_record_guarantor_profile_linked ?assignment_record ?drawdown_profile)
        (assignment_record_flag_alpha ?assignment_record)
        (not
          (assignment_record_available ?assignment_record)
        )
      )
  )
  (:action assemble_assignment_record_guarantor_adjusted
    :parameters (?borrower_obligor - borrower_obligor ?guarantor_obligor - guarantor_obligor ?exposure_profile - exposure_profile ?drawdown_profile - drawdown_profile ?assignment_record - assignment_record)
    :precondition
      (and
        (borrower_control_flagged ?borrower_obligor)
        (guarantor_control_flagged ?guarantor_obligor)
        (borrower_exposure_profile_assigned ?borrower_obligor ?exposure_profile)
        (guarantor_drawdown_profile_assigned ?guarantor_obligor ?drawdown_profile)
        (borrower_exposure_profile_selected ?exposure_profile)
        (guarantor_drawdown_profile_adjusted ?drawdown_profile)
        (borrower_control_confirmed ?borrower_obligor)
        (not
          (guarantor_control_confirmed ?guarantor_obligor)
        )
        (assignment_record_available ?assignment_record)
      )
    :effect
      (and
        (assignment_record_prepared ?assignment_record)
        (assignment_record_borrower_profile_linked ?assignment_record ?exposure_profile)
        (assignment_record_guarantor_profile_linked ?assignment_record ?drawdown_profile)
        (assignment_record_flag_beta ?assignment_record)
        (not
          (assignment_record_available ?assignment_record)
        )
      )
  )
  (:action assemble_assignment_record_full
    :parameters (?borrower_obligor - borrower_obligor ?guarantor_obligor - guarantor_obligor ?exposure_profile - exposure_profile ?drawdown_profile - drawdown_profile ?assignment_record - assignment_record)
    :precondition
      (and
        (borrower_control_flagged ?borrower_obligor)
        (guarantor_control_flagged ?guarantor_obligor)
        (borrower_exposure_profile_assigned ?borrower_obligor ?exposure_profile)
        (guarantor_drawdown_profile_assigned ?guarantor_obligor ?drawdown_profile)
        (borrower_exposure_profile_adjusted ?exposure_profile)
        (guarantor_drawdown_profile_adjusted ?drawdown_profile)
        (not
          (borrower_control_confirmed ?borrower_obligor)
        )
        (not
          (guarantor_control_confirmed ?guarantor_obligor)
        )
        (assignment_record_available ?assignment_record)
      )
    :effect
      (and
        (assignment_record_prepared ?assignment_record)
        (assignment_record_borrower_profile_linked ?assignment_record ?exposure_profile)
        (assignment_record_guarantor_profile_linked ?assignment_record ?drawdown_profile)
        (assignment_record_flag_alpha ?assignment_record)
        (assignment_record_flag_beta ?assignment_record)
        (not
          (assignment_record_available ?assignment_record)
        )
      )
  )
  (:action lock_assignment_record
    :parameters (?assignment_record - assignment_record ?borrower_obligor - borrower_obligor ?pricing_model - pricing_model)
    :precondition
      (and
        (assignment_record_prepared ?assignment_record)
        (borrower_control_flagged ?borrower_obligor)
        (pricing_model_linked_to_case ?borrower_obligor ?pricing_model)
        (not
          (assignment_record_locked ?assignment_record)
        )
      )
    :effect (assignment_record_locked ?assignment_record)
  )
  (:action bundle_assignment_documents
    :parameters (?covenant_package_instance - covenant_package_instance ?document_bundle - document_bundle ?assignment_record - assignment_record)
    :precondition
      (and
        (credit_review_cleared ?covenant_package_instance)
        (assignment_record_linked_to_case ?covenant_package_instance ?assignment_record)
        (document_bundle_linked_to_case ?covenant_package_instance ?document_bundle)
        (document_bundle_available ?document_bundle)
        (assignment_record_prepared ?assignment_record)
        (assignment_record_locked ?assignment_record)
        (not
          (document_bundle_reserved ?document_bundle)
        )
      )
    :effect
      (and
        (document_bundle_reserved ?document_bundle)
        (document_bundle_drawdown_linked ?document_bundle ?assignment_record)
        (not
          (document_bundle_available ?document_bundle)
        )
      )
  )
  (:action attach_document_bundle
    :parameters (?covenant_package_instance - covenant_package_instance ?document_bundle - document_bundle ?assignment_record - assignment_record ?pricing_model - pricing_model)
    :precondition
      (and
        (credit_review_cleared ?covenant_package_instance)
        (document_bundle_linked_to_case ?covenant_package_instance ?document_bundle)
        (document_bundle_reserved ?document_bundle)
        (document_bundle_drawdown_linked ?document_bundle ?assignment_record)
        (pricing_model_linked_to_case ?covenant_package_instance ?pricing_model)
        (not
          (assignment_record_flag_alpha ?assignment_record)
        )
        (not
          (package_documentation_complete ?covenant_package_instance)
        )
      )
    :effect (package_documentation_complete ?covenant_package_instance)
  )
  (:action select_clause_template
    :parameters (?covenant_package_instance - covenant_package_instance ?clause_template - clause_template)
    :precondition
      (and
        (credit_review_cleared ?covenant_package_instance)
        (clause_template_available ?clause_template)
        (not
          (clause_template_selected ?covenant_package_instance)
        )
      )
    :effect
      (and
        (clause_template_selected ?covenant_package_instance)
        (clause_template_linked_to_case ?covenant_package_instance ?clause_template)
        (not
          (clause_template_available ?clause_template)
        )
      )
  )
  (:action integrate_clause_package
    :parameters (?covenant_package_instance - covenant_package_instance ?document_bundle - document_bundle ?assignment_record - assignment_record ?pricing_model - pricing_model ?clause_template - clause_template)
    :precondition
      (and
        (credit_review_cleared ?covenant_package_instance)
        (document_bundle_linked_to_case ?covenant_package_instance ?document_bundle)
        (document_bundle_reserved ?document_bundle)
        (document_bundle_drawdown_linked ?document_bundle ?assignment_record)
        (pricing_model_linked_to_case ?covenant_package_instance ?pricing_model)
        (assignment_record_flag_alpha ?assignment_record)
        (clause_template_selected ?covenant_package_instance)
        (clause_template_linked_to_case ?covenant_package_instance ?clause_template)
        (not
          (package_documentation_complete ?covenant_package_instance)
        )
      )
    :effect
      (and
        (package_documentation_complete ?covenant_package_instance)
        (package_clause_bundle_complete ?covenant_package_instance)
      )
  )
  (:action record_security_action_variant_a
    :parameters (?covenant_package_instance - covenant_package_instance ?security_action - security_action ?credit_reviewer - credit_reviewer ?document_bundle - document_bundle ?assignment_record - assignment_record)
    :precondition
      (and
        (package_documentation_complete ?covenant_package_instance)
        (security_action_linked_to_case ?covenant_package_instance ?security_action)
        (reviewer_linked_to_case ?covenant_package_instance ?credit_reviewer)
        (document_bundle_linked_to_case ?covenant_package_instance ?document_bundle)
        (document_bundle_drawdown_linked ?document_bundle ?assignment_record)
        (not
          (assignment_record_flag_beta ?assignment_record)
        )
        (not
          (package_security_action_recorded ?covenant_package_instance)
        )
      )
    :effect (package_security_action_recorded ?covenant_package_instance)
  )
  (:action record_security_action_variant_b
    :parameters (?covenant_package_instance - covenant_package_instance ?security_action - security_action ?credit_reviewer - credit_reviewer ?document_bundle - document_bundle ?assignment_record - assignment_record)
    :precondition
      (and
        (package_documentation_complete ?covenant_package_instance)
        (security_action_linked_to_case ?covenant_package_instance ?security_action)
        (reviewer_linked_to_case ?covenant_package_instance ?credit_reviewer)
        (document_bundle_linked_to_case ?covenant_package_instance ?document_bundle)
        (document_bundle_drawdown_linked ?document_bundle ?assignment_record)
        (assignment_record_flag_beta ?assignment_record)
        (not
          (package_security_action_recorded ?covenant_package_instance)
        )
      )
    :effect (package_security_action_recorded ?covenant_package_instance)
  )
  (:action finalize_security_path_base
    :parameters (?covenant_package_instance - covenant_package_instance ?external_condition - external_condition ?document_bundle - document_bundle ?assignment_record - assignment_record)
    :precondition
      (and
        (package_security_action_recorded ?covenant_package_instance)
        (external_condition_linked_to_case ?covenant_package_instance ?external_condition)
        (document_bundle_linked_to_case ?covenant_package_instance ?document_bundle)
        (document_bundle_drawdown_linked ?document_bundle ?assignment_record)
        (not
          (assignment_record_flag_alpha ?assignment_record)
        )
        (not
          (assignment_record_flag_beta ?assignment_record)
        )
        (not
          (package_security_path_complete ?covenant_package_instance)
        )
      )
    :effect (package_security_path_complete ?covenant_package_instance)
  )
  (:action finalize_security_path_alpha
    :parameters (?covenant_package_instance - covenant_package_instance ?external_condition - external_condition ?document_bundle - document_bundle ?assignment_record - assignment_record)
    :precondition
      (and
        (package_security_action_recorded ?covenant_package_instance)
        (external_condition_linked_to_case ?covenant_package_instance ?external_condition)
        (document_bundle_linked_to_case ?covenant_package_instance ?document_bundle)
        (document_bundle_drawdown_linked ?document_bundle ?assignment_record)
        (assignment_record_flag_alpha ?assignment_record)
        (not
          (assignment_record_flag_beta ?assignment_record)
        )
        (not
          (package_security_path_complete ?covenant_package_instance)
        )
      )
    :effect
      (and
        (package_security_path_complete ?covenant_package_instance)
        (package_signoff_ready ?covenant_package_instance)
      )
  )
  (:action finalize_security_path_beta
    :parameters (?covenant_package_instance - covenant_package_instance ?external_condition - external_condition ?document_bundle - document_bundle ?assignment_record - assignment_record)
    :precondition
      (and
        (package_security_action_recorded ?covenant_package_instance)
        (external_condition_linked_to_case ?covenant_package_instance ?external_condition)
        (document_bundle_linked_to_case ?covenant_package_instance ?document_bundle)
        (document_bundle_drawdown_linked ?document_bundle ?assignment_record)
        (not
          (assignment_record_flag_alpha ?assignment_record)
        )
        (assignment_record_flag_beta ?assignment_record)
        (not
          (package_security_path_complete ?covenant_package_instance)
        )
      )
    :effect
      (and
        (package_security_path_complete ?covenant_package_instance)
        (package_signoff_ready ?covenant_package_instance)
      )
  )
  (:action finalize_security_path_alpha_beta
    :parameters (?covenant_package_instance - covenant_package_instance ?external_condition - external_condition ?document_bundle - document_bundle ?assignment_record - assignment_record)
    :precondition
      (and
        (package_security_action_recorded ?covenant_package_instance)
        (external_condition_linked_to_case ?covenant_package_instance ?external_condition)
        (document_bundle_linked_to_case ?covenant_package_instance ?document_bundle)
        (document_bundle_drawdown_linked ?document_bundle ?assignment_record)
        (assignment_record_flag_alpha ?assignment_record)
        (assignment_record_flag_beta ?assignment_record)
        (not
          (package_security_path_complete ?covenant_package_instance)
        )
      )
    :effect
      (and
        (package_security_path_complete ?covenant_package_instance)
        (package_signoff_ready ?covenant_package_instance)
      )
  )
  (:action grant_standard_package_approval
    :parameters (?covenant_package_instance - covenant_package_instance)
    :precondition
      (and
        (package_security_path_complete ?covenant_package_instance)
        (not
          (package_signoff_ready ?covenant_package_instance)
        )
        (not
          (package_final_approval_granted ?covenant_package_instance)
        )
      )
    :effect
      (and
        (package_final_approval_granted ?covenant_package_instance)
        (assignment_authorized ?covenant_package_instance)
      )
  )
  (:action attach_approval_document
    :parameters (?covenant_package_instance - covenant_package_instance ?approval_document - approval_document)
    :precondition
      (and
        (package_security_path_complete ?covenant_package_instance)
        (package_signoff_ready ?covenant_package_instance)
        (approval_document_available ?approval_document)
      )
    :effect
      (and
        (approval_document_linked_to_case ?covenant_package_instance ?approval_document)
        (not
          (approval_document_available ?approval_document)
        )
      )
  )
  (:action compile_party_signoff
    :parameters (?covenant_package_instance - covenant_package_instance ?borrower_obligor - borrower_obligor ?guarantor_obligor - guarantor_obligor ?pricing_model - pricing_model ?approval_document - approval_document)
    :precondition
      (and
        (package_security_path_complete ?covenant_package_instance)
        (package_signoff_ready ?covenant_package_instance)
        (approval_document_linked_to_case ?covenant_package_instance ?approval_document)
        (borrower_linked_to_case ?covenant_package_instance ?borrower_obligor)
        (guarantor_linked_to_case ?covenant_package_instance ?guarantor_obligor)
        (borrower_control_confirmed ?borrower_obligor)
        (guarantor_control_confirmed ?guarantor_obligor)
        (pricing_model_linked_to_case ?covenant_package_instance ?pricing_model)
        (not
          (package_signoff_recorded ?covenant_package_instance)
        )
      )
    :effect (package_signoff_recorded ?covenant_package_instance)
  )
  (:action grant_reviewed_package_approval
    :parameters (?covenant_package_instance - covenant_package_instance)
    :precondition
      (and
        (package_security_path_complete ?covenant_package_instance)
        (package_signoff_recorded ?covenant_package_instance)
        (not
          (package_final_approval_granted ?covenant_package_instance)
        )
      )
    :effect
      (and
        (package_final_approval_granted ?covenant_package_instance)
        (assignment_authorized ?covenant_package_instance)
      )
  )
  (:action attach_regulatory_notice
    :parameters (?covenant_package_instance - covenant_package_instance ?regulatory_notice - regulatory_notice ?pricing_model - pricing_model)
    :precondition
      (and
        (credit_review_cleared ?covenant_package_instance)
        (pricing_model_linked_to_case ?covenant_package_instance ?pricing_model)
        (regulatory_notice_available ?regulatory_notice)
        (regulatory_notice_linked_to_case ?covenant_package_instance ?regulatory_notice)
        (not
          (regulatory_notice_recorded ?covenant_package_instance)
        )
      )
    :effect
      (and
        (regulatory_notice_recorded ?covenant_package_instance)
        (not
          (regulatory_notice_available ?regulatory_notice)
        )
      )
  )
  (:action record_reviewer_clearance
    :parameters (?covenant_package_instance - covenant_package_instance ?credit_reviewer - credit_reviewer)
    :precondition
      (and
        (regulatory_notice_recorded ?covenant_package_instance)
        (reviewer_linked_to_case ?covenant_package_instance ?credit_reviewer)
        (not
          (reviewer_clearance_recorded ?covenant_package_instance)
        )
      )
    :effect (reviewer_clearance_recorded ?covenant_package_instance)
  )
  (:action record_external_condition_clearance
    :parameters (?covenant_package_instance - covenant_package_instance ?external_condition - external_condition)
    :precondition
      (and
        (reviewer_clearance_recorded ?covenant_package_instance)
        (external_condition_linked_to_case ?covenant_package_instance ?external_condition)
        (not
          (external_condition_clearance_recorded ?covenant_package_instance)
        )
      )
    :effect (external_condition_clearance_recorded ?covenant_package_instance)
  )
  (:action grant_final_package_approval
    :parameters (?covenant_package_instance - covenant_package_instance)
    :precondition
      (and
        (external_condition_clearance_recorded ?covenant_package_instance)
        (not
          (package_final_approval_granted ?covenant_package_instance)
        )
      )
    :effect
      (and
        (package_final_approval_granted ?covenant_package_instance)
        (assignment_authorized ?covenant_package_instance)
      )
  )
  (:action authorize_borrower_activation
    :parameters (?borrower_obligor - borrower_obligor ?assignment_record - assignment_record)
    :precondition
      (and
        (borrower_control_flagged ?borrower_obligor)
        (borrower_control_confirmed ?borrower_obligor)
        (assignment_record_prepared ?assignment_record)
        (assignment_record_locked ?assignment_record)
        (not
          (assignment_authorized ?borrower_obligor)
        )
      )
    :effect (assignment_authorized ?borrower_obligor)
  )
  (:action authorize_guarantor_activation
    :parameters (?guarantor_obligor - guarantor_obligor ?assignment_record - assignment_record)
    :precondition
      (and
        (guarantor_control_flagged ?guarantor_obligor)
        (guarantor_control_confirmed ?guarantor_obligor)
        (assignment_record_prepared ?assignment_record)
        (assignment_record_locked ?assignment_record)
        (not
          (assignment_authorized ?guarantor_obligor)
        )
      )
    :effect (assignment_authorized ?guarantor_obligor)
  )
  (:action bind_assignment_evidence
    :parameters (?case_entity - case_entity ?assignment_evidence - assignment_evidence ?pricing_model - pricing_model)
    :precondition
      (and
        (assignment_authorized ?case_entity)
        (pricing_model_linked_to_case ?case_entity ?pricing_model)
        (assignment_evidence_available ?assignment_evidence)
        (not
          (assignment_clearance_recorded ?case_entity)
        )
      )
    :effect
      (and
        (assignment_clearance_recorded ?case_entity)
        (assignment_evidence_linked_to_case ?case_entity ?assignment_evidence)
        (not
          (assignment_evidence_available ?assignment_evidence)
        )
      )
  )
  (:action activate_borrower_assignment
    :parameters (?borrower_obligor - borrower_obligor ?covenant_package_template - covenant_package_template ?assignment_evidence - assignment_evidence)
    :precondition
      (and
        (assignment_clearance_recorded ?borrower_obligor)
        (template_linked_to_case ?borrower_obligor ?covenant_package_template)
        (assignment_evidence_linked_to_case ?borrower_obligor ?assignment_evidence)
        (not
          (assignment_confirmed ?borrower_obligor)
        )
      )
    :effect
      (and
        (assignment_confirmed ?borrower_obligor)
        (covenant_template_available ?covenant_package_template)
        (assignment_evidence_available ?assignment_evidence)
      )
  )
  (:action activate_guarantor_assignment
    :parameters (?guarantor_obligor - guarantor_obligor ?covenant_package_template - covenant_package_template ?assignment_evidence - assignment_evidence)
    :precondition
      (and
        (assignment_clearance_recorded ?guarantor_obligor)
        (template_linked_to_case ?guarantor_obligor ?covenant_package_template)
        (assignment_evidence_linked_to_case ?guarantor_obligor ?assignment_evidence)
        (not
          (assignment_confirmed ?guarantor_obligor)
        )
      )
    :effect
      (and
        (assignment_confirmed ?guarantor_obligor)
        (covenant_template_available ?covenant_package_template)
        (assignment_evidence_available ?assignment_evidence)
      )
  )
  (:action activate_package_assignment
    :parameters (?covenant_package_instance - covenant_package_instance ?covenant_package_template - covenant_package_template ?assignment_evidence - assignment_evidence)
    :precondition
      (and
        (assignment_clearance_recorded ?covenant_package_instance)
        (template_linked_to_case ?covenant_package_instance ?covenant_package_template)
        (assignment_evidence_linked_to_case ?covenant_package_instance ?assignment_evidence)
        (not
          (assignment_confirmed ?covenant_package_instance)
        )
      )
    :effect
      (and
        (assignment_confirmed ?covenant_package_instance)
        (covenant_template_available ?covenant_package_template)
        (assignment_evidence_available ?assignment_evidence)
      )
  )
)

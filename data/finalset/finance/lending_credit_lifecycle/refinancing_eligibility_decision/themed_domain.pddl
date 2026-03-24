(define (domain refinancing_eligibility_decision_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_actor_group - object asset_class_group - object product_class_group - object application_container - object loan_application - application_container decision_engine - resource_actor_group document - resource_actor_group third_party_assessor - resource_actor_group guarantor_profile - resource_actor_group override_token - resource_actor_group risk_threshold - resource_actor_group valuation_report - resource_actor_group compliance_flag - resource_actor_group rule_set - asset_class_group collateral_item - asset_class_group external_indicator - asset_class_group collateral_type - product_class_group collateral_asset - product_class_group refinance_offer - product_class_group primary_applicant_role - loan_application co_applicant_role - loan_application primary_applicant_record - primary_applicant_role co_applicant_record - primary_applicant_role underwriting_case - co_applicant_role)
  (:predicates
    (case_or_application_registered ?loan_application - loan_application)
    (case_or_application_validation_completed ?loan_application - loan_application)
    (case_or_application_processing_started ?loan_application - loan_application)
    (decision_finalized ?loan_application - loan_application)
    (case_or_application_onboarded ?loan_application - loan_application)
    (prequalified ?loan_application - loan_application)
    (engine_available ?decision_engine - decision_engine)
    (case_or_application_assigned_engine ?loan_application - loan_application ?decision_engine - decision_engine)
    (document_available ?document - document)
    (case_or_application_has_document ?loan_application - loan_application ?document - document)
    (assessor_available ?assessor - third_party_assessor)
    (case_or_application_assigned_assessor ?loan_application - loan_application ?assessor - third_party_assessor)
    (rule_set_available ?rule_set - rule_set)
    (primary_applicant_rule_applied ?primary_applicant - primary_applicant_record ?rule_set - rule_set)
    (co_applicant_rule_applied ?co_applicant - co_applicant_record ?rule_set - rule_set)
    (primary_applicant_linked_collateral_type ?primary_applicant - primary_applicant_record ?collateral_type - collateral_type)
    (collateral_type_screened ?collateral_type - collateral_type)
    (collateral_type_under_rule_review ?collateral_type - collateral_type)
    (primary_applicant_verification_passed ?primary_applicant - primary_applicant_record)
    (co_applicant_linked_collateral_asset ?co_applicant - co_applicant_record ?collateral_asset - collateral_asset)
    (collateral_asset_screened ?collateral_asset - collateral_asset)
    (collateral_asset_under_rule_review ?collateral_asset - collateral_asset)
    (co_applicant_verification_passed ?co_applicant - co_applicant_record)
    (offer_slot_available ?refinance_offer - refinance_offer)
    (offer_generated ?refinance_offer - refinance_offer)
    (offer_linked_collateral_type ?refinance_offer - refinance_offer ?collateral_type - collateral_type)
    (offer_linked_collateral_asset ?refinance_offer - refinance_offer ?collateral_asset - collateral_asset)
    (offer_requires_guarantor ?refinance_offer - refinance_offer)
    (offer_requires_additional_valuation ?refinance_offer - refinance_offer)
    (offer_locked ?refinance_offer - refinance_offer)
    (case_primary_applicant_link ?underwriting_case - underwriting_case ?primary_applicant - primary_applicant_record)
    (case_co_applicant_link ?underwriting_case - underwriting_case ?co_applicant - co_applicant_record)
    (case_offer_link ?underwriting_case - underwriting_case ?refinance_offer - refinance_offer)
    (collateral_item_available ?collateral_item - collateral_item)
    (case_has_collateral_item ?underwriting_case - underwriting_case ?collateral_item - collateral_item)
    (collateral_item_screened ?collateral_item - collateral_item)
    (collateral_item_linked_to_offer ?collateral_item - collateral_item ?refinance_offer - refinance_offer)
    (case_ready_for_underwriting ?underwriting_case - underwriting_case)
    (underwriter_review_started ?underwriting_case - underwriting_case)
    (underwriter_review_completed ?underwriting_case - underwriting_case)
    (guarantor_association_initiated ?underwriting_case - underwriting_case)
    (guarantor_documents_linked ?underwriting_case - underwriting_case)
    (override_required ?underwriting_case - underwriting_case)
    (underwriter_approval_confirmed ?underwriting_case - underwriting_case)
    (external_indicator_available ?external_indicator - external_indicator)
    (case_linked_external_indicator ?underwriting_case - underwriting_case ?external_indicator - external_indicator)
    (external_indicator_attached ?underwriting_case - underwriting_case)
    (external_indicator_evaluation_started ?underwriting_case - underwriting_case)
    (external_indicator_evaluation_completed ?underwriting_case - underwriting_case)
    (guarantor_profile_available ?guarantor_profile - guarantor_profile)
    (case_linked_guarantor ?underwriting_case - underwriting_case ?guarantor_profile - guarantor_profile)
    (override_token_available ?override_token - override_token)
    (override_token_assigned ?underwriting_case - underwriting_case ?override_token - override_token)
    (valuation_report_available ?valuation_report - valuation_report)
    (case_has_valuation_report ?underwriting_case - underwriting_case ?valuation_report - valuation_report)
    (compliance_flag_available ?compliance_flag - compliance_flag)
    (case_has_compliance_flag ?underwriting_case - underwriting_case ?compliance_flag - compliance_flag)
    (risk_threshold_available ?risk_threshold - risk_threshold)
    (case_or_application_tagged_risk_threshold ?loan_application - loan_application ?risk_threshold - risk_threshold)
    (primary_applicant_verification_started ?primary_applicant - primary_applicant_record)
    (co_applicant_verification_started ?co_applicant - co_applicant_record)
    (case_finalized ?underwriting_case - underwriting_case)
  )
  (:action register_refinance_application
    :parameters (?loan_application - loan_application)
    :precondition
      (and
        (not
          (case_or_application_registered ?loan_application)
        )
        (not
          (decision_finalized ?loan_application)
        )
      )
    :effect (case_or_application_registered ?loan_application)
  )
  (:action assign_decision_engine_to_application
    :parameters (?loan_application - loan_application ?decision_engine - decision_engine)
    :precondition
      (and
        (case_or_application_registered ?loan_application)
        (not
          (case_or_application_processing_started ?loan_application)
        )
        (engine_available ?decision_engine)
      )
    :effect
      (and
        (case_or_application_processing_started ?loan_application)
        (case_or_application_assigned_engine ?loan_application ?decision_engine)
        (not
          (engine_available ?decision_engine)
        )
      )
  )
  (:action attach_document_to_application
    :parameters (?loan_application - loan_application ?document - document)
    :precondition
      (and
        (case_or_application_registered ?loan_application)
        (case_or_application_processing_started ?loan_application)
        (document_available ?document)
      )
    :effect
      (and
        (case_or_application_has_document ?loan_application ?document)
        (not
          (document_available ?document)
        )
      )
  )
  (:action validate_application_documents
    :parameters (?loan_application - loan_application ?document - document)
    :precondition
      (and
        (case_or_application_registered ?loan_application)
        (case_or_application_processing_started ?loan_application)
        (case_or_application_has_document ?loan_application ?document)
        (not
          (case_or_application_validation_completed ?loan_application)
        )
      )
    :effect (case_or_application_validation_completed ?loan_application)
  )
  (:action detach_document_from_application
    :parameters (?loan_application - loan_application ?document - document)
    :precondition
      (and
        (case_or_application_has_document ?loan_application ?document)
      )
    :effect
      (and
        (document_available ?document)
        (not
          (case_or_application_has_document ?loan_application ?document)
        )
      )
  )
  (:action assign_assessor_to_application
    :parameters (?loan_application - loan_application ?assessor - third_party_assessor)
    :precondition
      (and
        (case_or_application_validation_completed ?loan_application)
        (assessor_available ?assessor)
      )
    :effect
      (and
        (case_or_application_assigned_assessor ?loan_application ?assessor)
        (not
          (assessor_available ?assessor)
        )
      )
  )
  (:action release_assessor_from_application
    :parameters (?loan_application - loan_application ?assessor - third_party_assessor)
    :precondition
      (and
        (case_or_application_assigned_assessor ?loan_application ?assessor)
      )
    :effect
      (and
        (assessor_available ?assessor)
        (not
          (case_or_application_assigned_assessor ?loan_application ?assessor)
        )
      )
  )
  (:action attach_valuation_to_case
    :parameters (?underwriting_case - underwriting_case ?valuation_report - valuation_report)
    :precondition
      (and
        (case_or_application_validation_completed ?underwriting_case)
        (valuation_report_available ?valuation_report)
      )
    :effect
      (and
        (case_has_valuation_report ?underwriting_case ?valuation_report)
        (not
          (valuation_report_available ?valuation_report)
        )
      )
  )
  (:action detach_valuation_from_case
    :parameters (?underwriting_case - underwriting_case ?valuation_report - valuation_report)
    :precondition
      (and
        (case_has_valuation_report ?underwriting_case ?valuation_report)
      )
    :effect
      (and
        (valuation_report_available ?valuation_report)
        (not
          (case_has_valuation_report ?underwriting_case ?valuation_report)
        )
      )
  )
  (:action attach_compliance_flag_to_case
    :parameters (?underwriting_case - underwriting_case ?compliance_flag - compliance_flag)
    :precondition
      (and
        (case_or_application_validation_completed ?underwriting_case)
        (compliance_flag_available ?compliance_flag)
      )
    :effect
      (and
        (case_has_compliance_flag ?underwriting_case ?compliance_flag)
        (not
          (compliance_flag_available ?compliance_flag)
        )
      )
  )
  (:action detach_compliance_flag_from_case
    :parameters (?underwriting_case - underwriting_case ?compliance_flag - compliance_flag)
    :precondition
      (and
        (case_has_compliance_flag ?underwriting_case ?compliance_flag)
      )
    :effect
      (and
        (compliance_flag_available ?compliance_flag)
        (not
          (case_has_compliance_flag ?underwriting_case ?compliance_flag)
        )
      )
  )
  (:action initiate_primary_applicant_verification
    :parameters (?primary_applicant - primary_applicant_record ?collateral_type - collateral_type ?document - document)
    :precondition
      (and
        (case_or_application_validation_completed ?primary_applicant)
        (case_or_application_has_document ?primary_applicant ?document)
        (primary_applicant_linked_collateral_type ?primary_applicant ?collateral_type)
        (not
          (collateral_type_screened ?collateral_type)
        )
        (not
          (collateral_type_under_rule_review ?collateral_type)
        )
      )
    :effect (collateral_type_screened ?collateral_type)
  )
  (:action complete_primary_assessor_verification
    :parameters (?primary_applicant - primary_applicant_record ?collateral_type - collateral_type ?assessor - third_party_assessor)
    :precondition
      (and
        (case_or_application_validation_completed ?primary_applicant)
        (case_or_application_assigned_assessor ?primary_applicant ?assessor)
        (primary_applicant_linked_collateral_type ?primary_applicant ?collateral_type)
        (collateral_type_screened ?collateral_type)
        (not
          (primary_applicant_verification_started ?primary_applicant)
        )
      )
    :effect
      (and
        (primary_applicant_verification_started ?primary_applicant)
        (primary_applicant_verification_passed ?primary_applicant)
      )
  )
  (:action apply_rule_set_to_primary_verification
    :parameters (?primary_applicant - primary_applicant_record ?collateral_type - collateral_type ?rule_set - rule_set)
    :precondition
      (and
        (case_or_application_validation_completed ?primary_applicant)
        (primary_applicant_linked_collateral_type ?primary_applicant ?collateral_type)
        (rule_set_available ?rule_set)
        (not
          (primary_applicant_verification_started ?primary_applicant)
        )
      )
    :effect
      (and
        (collateral_type_under_rule_review ?collateral_type)
        (primary_applicant_verification_started ?primary_applicant)
        (primary_applicant_rule_applied ?primary_applicant ?rule_set)
        (not
          (rule_set_available ?rule_set)
        )
      )
  )
  (:action finalize_primary_verification_with_rules
    :parameters (?primary_applicant - primary_applicant_record ?collateral_type - collateral_type ?document - document ?rule_set - rule_set)
    :precondition
      (and
        (case_or_application_validation_completed ?primary_applicant)
        (case_or_application_has_document ?primary_applicant ?document)
        (primary_applicant_linked_collateral_type ?primary_applicant ?collateral_type)
        (collateral_type_under_rule_review ?collateral_type)
        (primary_applicant_rule_applied ?primary_applicant ?rule_set)
        (not
          (primary_applicant_verification_passed ?primary_applicant)
        )
      )
    :effect
      (and
        (collateral_type_screened ?collateral_type)
        (primary_applicant_verification_passed ?primary_applicant)
        (rule_set_available ?rule_set)
        (not
          (primary_applicant_rule_applied ?primary_applicant ?rule_set)
        )
      )
  )
  (:action initiate_co_applicant_verification
    :parameters (?co_applicant - co_applicant_record ?collateral_asset - collateral_asset ?document - document)
    :precondition
      (and
        (case_or_application_validation_completed ?co_applicant)
        (case_or_application_has_document ?co_applicant ?document)
        (co_applicant_linked_collateral_asset ?co_applicant ?collateral_asset)
        (not
          (collateral_asset_screened ?collateral_asset)
        )
        (not
          (collateral_asset_under_rule_review ?collateral_asset)
        )
      )
    :effect (collateral_asset_screened ?collateral_asset)
  )
  (:action complete_co_assessor_verification
    :parameters (?co_applicant - co_applicant_record ?collateral_asset - collateral_asset ?assessor - third_party_assessor)
    :precondition
      (and
        (case_or_application_validation_completed ?co_applicant)
        (case_or_application_assigned_assessor ?co_applicant ?assessor)
        (co_applicant_linked_collateral_asset ?co_applicant ?collateral_asset)
        (collateral_asset_screened ?collateral_asset)
        (not
          (co_applicant_verification_started ?co_applicant)
        )
      )
    :effect
      (and
        (co_applicant_verification_started ?co_applicant)
        (co_applicant_verification_passed ?co_applicant)
      )
  )
  (:action apply_rule_set_to_co_verification
    :parameters (?co_applicant - co_applicant_record ?collateral_asset - collateral_asset ?rule_set - rule_set)
    :precondition
      (and
        (case_or_application_validation_completed ?co_applicant)
        (co_applicant_linked_collateral_asset ?co_applicant ?collateral_asset)
        (rule_set_available ?rule_set)
        (not
          (co_applicant_verification_started ?co_applicant)
        )
      )
    :effect
      (and
        (collateral_asset_under_rule_review ?collateral_asset)
        (co_applicant_verification_started ?co_applicant)
        (co_applicant_rule_applied ?co_applicant ?rule_set)
        (not
          (rule_set_available ?rule_set)
        )
      )
  )
  (:action finalize_co_verification_with_rules
    :parameters (?co_applicant - co_applicant_record ?collateral_asset - collateral_asset ?document - document ?rule_set - rule_set)
    :precondition
      (and
        (case_or_application_validation_completed ?co_applicant)
        (case_or_application_has_document ?co_applicant ?document)
        (co_applicant_linked_collateral_asset ?co_applicant ?collateral_asset)
        (collateral_asset_under_rule_review ?collateral_asset)
        (co_applicant_rule_applied ?co_applicant ?rule_set)
        (not
          (co_applicant_verification_passed ?co_applicant)
        )
      )
    :effect
      (and
        (collateral_asset_screened ?collateral_asset)
        (co_applicant_verification_passed ?co_applicant)
        (rule_set_available ?rule_set)
        (not
          (co_applicant_rule_applied ?co_applicant ?rule_set)
        )
      )
  )
  (:action assemble_refinance_offer_standard
    :parameters (?primary_applicant - primary_applicant_record ?co_applicant - co_applicant_record ?collateral_type - collateral_type ?collateral_asset - collateral_asset ?refinance_offer - refinance_offer)
    :precondition
      (and
        (primary_applicant_verification_started ?primary_applicant)
        (co_applicant_verification_started ?co_applicant)
        (primary_applicant_linked_collateral_type ?primary_applicant ?collateral_type)
        (co_applicant_linked_collateral_asset ?co_applicant ?collateral_asset)
        (collateral_type_screened ?collateral_type)
        (collateral_asset_screened ?collateral_asset)
        (primary_applicant_verification_passed ?primary_applicant)
        (co_applicant_verification_passed ?co_applicant)
        (offer_slot_available ?refinance_offer)
      )
    :effect
      (and
        (offer_generated ?refinance_offer)
        (offer_linked_collateral_type ?refinance_offer ?collateral_type)
        (offer_linked_collateral_asset ?refinance_offer ?collateral_asset)
        (not
          (offer_slot_available ?refinance_offer)
        )
      )
  )
  (:action assemble_refinance_offer_requires_guarantor
    :parameters (?primary_applicant - primary_applicant_record ?co_applicant - co_applicant_record ?collateral_type - collateral_type ?collateral_asset - collateral_asset ?refinance_offer - refinance_offer)
    :precondition
      (and
        (primary_applicant_verification_started ?primary_applicant)
        (co_applicant_verification_started ?co_applicant)
        (primary_applicant_linked_collateral_type ?primary_applicant ?collateral_type)
        (co_applicant_linked_collateral_asset ?co_applicant ?collateral_asset)
        (collateral_type_under_rule_review ?collateral_type)
        (collateral_asset_screened ?collateral_asset)
        (not
          (primary_applicant_verification_passed ?primary_applicant)
        )
        (co_applicant_verification_passed ?co_applicant)
        (offer_slot_available ?refinance_offer)
      )
    :effect
      (and
        (offer_generated ?refinance_offer)
        (offer_linked_collateral_type ?refinance_offer ?collateral_type)
        (offer_linked_collateral_asset ?refinance_offer ?collateral_asset)
        (offer_requires_guarantor ?refinance_offer)
        (not
          (offer_slot_available ?refinance_offer)
        )
      )
  )
  (:action assemble_refinance_offer_requires_additional_valuation
    :parameters (?primary_applicant - primary_applicant_record ?co_applicant - co_applicant_record ?collateral_type - collateral_type ?collateral_asset - collateral_asset ?refinance_offer - refinance_offer)
    :precondition
      (and
        (primary_applicant_verification_started ?primary_applicant)
        (co_applicant_verification_started ?co_applicant)
        (primary_applicant_linked_collateral_type ?primary_applicant ?collateral_type)
        (co_applicant_linked_collateral_asset ?co_applicant ?collateral_asset)
        (collateral_type_screened ?collateral_type)
        (collateral_asset_under_rule_review ?collateral_asset)
        (primary_applicant_verification_passed ?primary_applicant)
        (not
          (co_applicant_verification_passed ?co_applicant)
        )
        (offer_slot_available ?refinance_offer)
      )
    :effect
      (and
        (offer_generated ?refinance_offer)
        (offer_linked_collateral_type ?refinance_offer ?collateral_type)
        (offer_linked_collateral_asset ?refinance_offer ?collateral_asset)
        (offer_requires_additional_valuation ?refinance_offer)
        (not
          (offer_slot_available ?refinance_offer)
        )
      )
  )
  (:action assemble_refinance_offer_requires_guarantor_and_valuation
    :parameters (?primary_applicant - primary_applicant_record ?co_applicant - co_applicant_record ?collateral_type - collateral_type ?collateral_asset - collateral_asset ?refinance_offer - refinance_offer)
    :precondition
      (and
        (primary_applicant_verification_started ?primary_applicant)
        (co_applicant_verification_started ?co_applicant)
        (primary_applicant_linked_collateral_type ?primary_applicant ?collateral_type)
        (co_applicant_linked_collateral_asset ?co_applicant ?collateral_asset)
        (collateral_type_under_rule_review ?collateral_type)
        (collateral_asset_under_rule_review ?collateral_asset)
        (not
          (primary_applicant_verification_passed ?primary_applicant)
        )
        (not
          (co_applicant_verification_passed ?co_applicant)
        )
        (offer_slot_available ?refinance_offer)
      )
    :effect
      (and
        (offer_generated ?refinance_offer)
        (offer_linked_collateral_type ?refinance_offer ?collateral_type)
        (offer_linked_collateral_asset ?refinance_offer ?collateral_asset)
        (offer_requires_guarantor ?refinance_offer)
        (offer_requires_additional_valuation ?refinance_offer)
        (not
          (offer_slot_available ?refinance_offer)
        )
      )
  )
  (:action lock_refinance_offer
    :parameters (?refinance_offer - refinance_offer ?primary_applicant - primary_applicant_record ?document - document)
    :precondition
      (and
        (offer_generated ?refinance_offer)
        (primary_applicant_verification_started ?primary_applicant)
        (case_or_application_has_document ?primary_applicant ?document)
        (not
          (offer_locked ?refinance_offer)
        )
      )
    :effect (offer_locked ?refinance_offer)
  )
  (:action screen_and_reserve_collateral_item
    :parameters (?underwriting_case - underwriting_case ?collateral_item - collateral_item ?refinance_offer - refinance_offer)
    :precondition
      (and
        (case_or_application_validation_completed ?underwriting_case)
        (case_offer_link ?underwriting_case ?refinance_offer)
        (case_has_collateral_item ?underwriting_case ?collateral_item)
        (collateral_item_available ?collateral_item)
        (offer_generated ?refinance_offer)
        (offer_locked ?refinance_offer)
        (not
          (collateral_item_screened ?collateral_item)
        )
      )
    :effect
      (and
        (collateral_item_screened ?collateral_item)
        (collateral_item_linked_to_offer ?collateral_item ?refinance_offer)
        (not
          (collateral_item_available ?collateral_item)
        )
      )
  )
  (:action finalize_collateral_screening
    :parameters (?underwriting_case - underwriting_case ?collateral_item - collateral_item ?refinance_offer - refinance_offer ?document - document)
    :precondition
      (and
        (case_or_application_validation_completed ?underwriting_case)
        (case_has_collateral_item ?underwriting_case ?collateral_item)
        (collateral_item_screened ?collateral_item)
        (collateral_item_linked_to_offer ?collateral_item ?refinance_offer)
        (case_or_application_has_document ?underwriting_case ?document)
        (not
          (offer_requires_guarantor ?refinance_offer)
        )
        (not
          (case_ready_for_underwriting ?underwriting_case)
        )
      )
    :effect (case_ready_for_underwriting ?underwriting_case)
  )
  (:action attach_guarantor_profile_to_case
    :parameters (?underwriting_case - underwriting_case ?guarantor_profile - guarantor_profile)
    :precondition
      (and
        (case_or_application_validation_completed ?underwriting_case)
        (guarantor_profile_available ?guarantor_profile)
        (not
          (guarantor_association_initiated ?underwriting_case)
        )
      )
    :effect
      (and
        (guarantor_association_initiated ?underwriting_case)
        (case_linked_guarantor ?underwriting_case ?guarantor_profile)
        (not
          (guarantor_profile_available ?guarantor_profile)
        )
      )
  )
  (:action associate_guarantor_documents_with_case
    :parameters (?underwriting_case - underwriting_case ?collateral_item - collateral_item ?refinance_offer - refinance_offer ?document - document ?guarantor_profile - guarantor_profile)
    :precondition
      (and
        (case_or_application_validation_completed ?underwriting_case)
        (case_has_collateral_item ?underwriting_case ?collateral_item)
        (collateral_item_screened ?collateral_item)
        (collateral_item_linked_to_offer ?collateral_item ?refinance_offer)
        (case_or_application_has_document ?underwriting_case ?document)
        (offer_requires_guarantor ?refinance_offer)
        (guarantor_association_initiated ?underwriting_case)
        (case_linked_guarantor ?underwriting_case ?guarantor_profile)
        (not
          (case_ready_for_underwriting ?underwriting_case)
        )
      )
    :effect
      (and
        (case_ready_for_underwriting ?underwriting_case)
        (guarantor_documents_linked ?underwriting_case)
      )
  )
  (:action initiate_underwriter_review_basic
    :parameters (?underwriting_case - underwriting_case ?valuation_report - valuation_report ?assessor - third_party_assessor ?collateral_item - collateral_item ?refinance_offer - refinance_offer)
    :precondition
      (and
        (case_ready_for_underwriting ?underwriting_case)
        (case_has_valuation_report ?underwriting_case ?valuation_report)
        (case_or_application_assigned_assessor ?underwriting_case ?assessor)
        (case_has_collateral_item ?underwriting_case ?collateral_item)
        (collateral_item_linked_to_offer ?collateral_item ?refinance_offer)
        (not
          (offer_requires_additional_valuation ?refinance_offer)
        )
        (not
          (underwriter_review_started ?underwriting_case)
        )
      )
    :effect (underwriter_review_started ?underwriting_case)
  )
  (:action initiate_underwriter_review_flagged
    :parameters (?underwriting_case - underwriting_case ?valuation_report - valuation_report ?assessor - third_party_assessor ?collateral_item - collateral_item ?refinance_offer - refinance_offer)
    :precondition
      (and
        (case_ready_for_underwriting ?underwriting_case)
        (case_has_valuation_report ?underwriting_case ?valuation_report)
        (case_or_application_assigned_assessor ?underwriting_case ?assessor)
        (case_has_collateral_item ?underwriting_case ?collateral_item)
        (collateral_item_linked_to_offer ?collateral_item ?refinance_offer)
        (offer_requires_additional_valuation ?refinance_offer)
        (not
          (underwriter_review_started ?underwriting_case)
        )
      )
    :effect (underwriter_review_started ?underwriting_case)
  )
  (:action complete_underwriter_review_no_flags
    :parameters (?underwriting_case - underwriting_case ?compliance_flag - compliance_flag ?collateral_item - collateral_item ?refinance_offer - refinance_offer)
    :precondition
      (and
        (underwriter_review_started ?underwriting_case)
        (case_has_compliance_flag ?underwriting_case ?compliance_flag)
        (case_has_collateral_item ?underwriting_case ?collateral_item)
        (collateral_item_linked_to_offer ?collateral_item ?refinance_offer)
        (not
          (offer_requires_guarantor ?refinance_offer)
        )
        (not
          (offer_requires_additional_valuation ?refinance_offer)
        )
        (not
          (underwriter_review_completed ?underwriting_case)
        )
      )
    :effect (underwriter_review_completed ?underwriting_case)
  )
  (:action complete_underwriter_review_requires_guarantor
    :parameters (?underwriting_case - underwriting_case ?compliance_flag - compliance_flag ?collateral_item - collateral_item ?refinance_offer - refinance_offer)
    :precondition
      (and
        (underwriter_review_started ?underwriting_case)
        (case_has_compliance_flag ?underwriting_case ?compliance_flag)
        (case_has_collateral_item ?underwriting_case ?collateral_item)
        (collateral_item_linked_to_offer ?collateral_item ?refinance_offer)
        (offer_requires_guarantor ?refinance_offer)
        (not
          (offer_requires_additional_valuation ?refinance_offer)
        )
        (not
          (underwriter_review_completed ?underwriting_case)
        )
      )
    :effect
      (and
        (underwriter_review_completed ?underwriting_case)
        (override_required ?underwriting_case)
      )
  )
  (:action complete_underwriter_review_requires_additional_valuation
    :parameters (?underwriting_case - underwriting_case ?compliance_flag - compliance_flag ?collateral_item - collateral_item ?refinance_offer - refinance_offer)
    :precondition
      (and
        (underwriter_review_started ?underwriting_case)
        (case_has_compliance_flag ?underwriting_case ?compliance_flag)
        (case_has_collateral_item ?underwriting_case ?collateral_item)
        (collateral_item_linked_to_offer ?collateral_item ?refinance_offer)
        (not
          (offer_requires_guarantor ?refinance_offer)
        )
        (offer_requires_additional_valuation ?refinance_offer)
        (not
          (underwriter_review_completed ?underwriting_case)
        )
      )
    :effect
      (and
        (underwriter_review_completed ?underwriting_case)
        (override_required ?underwriting_case)
      )
  )
  (:action complete_underwriter_review_requires_guarantor_and_valuation
    :parameters (?underwriting_case - underwriting_case ?compliance_flag - compliance_flag ?collateral_item - collateral_item ?refinance_offer - refinance_offer)
    :precondition
      (and
        (underwriter_review_started ?underwriting_case)
        (case_has_compliance_flag ?underwriting_case ?compliance_flag)
        (case_has_collateral_item ?underwriting_case ?collateral_item)
        (collateral_item_linked_to_offer ?collateral_item ?refinance_offer)
        (offer_requires_guarantor ?refinance_offer)
        (offer_requires_additional_valuation ?refinance_offer)
        (not
          (underwriter_review_completed ?underwriting_case)
        )
      )
    :effect
      (and
        (underwriter_review_completed ?underwriting_case)
        (override_required ?underwriting_case)
      )
  )
  (:action finalize_underwriting_and_commit
    :parameters (?underwriting_case - underwriting_case)
    :precondition
      (and
        (underwriter_review_completed ?underwriting_case)
        (not
          (override_required ?underwriting_case)
        )
        (not
          (case_finalized ?underwriting_case)
        )
      )
    :effect
      (and
        (case_finalized ?underwriting_case)
        (case_or_application_onboarded ?underwriting_case)
      )
  )
  (:action assign_override_token_to_case
    :parameters (?underwriting_case - underwriting_case ?override_token - override_token)
    :precondition
      (and
        (underwriter_review_completed ?underwriting_case)
        (override_required ?underwriting_case)
        (override_token_available ?override_token)
      )
    :effect
      (and
        (override_token_assigned ?underwriting_case ?override_token)
        (not
          (override_token_available ?override_token)
        )
      )
  )
  (:action resolve_override_and_confirm_underwriter_approval
    :parameters (?underwriting_case - underwriting_case ?primary_applicant - primary_applicant_record ?co_applicant - co_applicant_record ?document - document ?override_token - override_token)
    :precondition
      (and
        (underwriter_review_completed ?underwriting_case)
        (override_required ?underwriting_case)
        (override_token_assigned ?underwriting_case ?override_token)
        (case_primary_applicant_link ?underwriting_case ?primary_applicant)
        (case_co_applicant_link ?underwriting_case ?co_applicant)
        (primary_applicant_verification_passed ?primary_applicant)
        (co_applicant_verification_passed ?co_applicant)
        (case_or_application_has_document ?underwriting_case ?document)
        (not
          (underwriter_approval_confirmed ?underwriting_case)
        )
      )
    :effect (underwriter_approval_confirmed ?underwriting_case)
  )
  (:action finalize_underwriting_with_override
    :parameters (?underwriting_case - underwriting_case)
    :precondition
      (and
        (underwriter_review_completed ?underwriting_case)
        (underwriter_approval_confirmed ?underwriting_case)
        (not
          (case_finalized ?underwriting_case)
        )
      )
    :effect
      (and
        (case_finalized ?underwriting_case)
        (case_or_application_onboarded ?underwriting_case)
      )
  )
  (:action start_external_indicator_check
    :parameters (?underwriting_case - underwriting_case ?external_indicator - external_indicator ?document - document)
    :precondition
      (and
        (case_or_application_validation_completed ?underwriting_case)
        (case_or_application_has_document ?underwriting_case ?document)
        (external_indicator_available ?external_indicator)
        (case_linked_external_indicator ?underwriting_case ?external_indicator)
        (not
          (external_indicator_attached ?underwriting_case)
        )
      )
    :effect
      (and
        (external_indicator_attached ?underwriting_case)
        (not
          (external_indicator_available ?external_indicator)
        )
      )
  )
  (:action start_external_indicator_evaluation
    :parameters (?underwriting_case - underwriting_case ?assessor - third_party_assessor)
    :precondition
      (and
        (external_indicator_attached ?underwriting_case)
        (case_or_application_assigned_assessor ?underwriting_case ?assessor)
        (not
          (external_indicator_evaluation_started ?underwriting_case)
        )
      )
    :effect (external_indicator_evaluation_started ?underwriting_case)
  )
  (:action complete_external_indicator_evaluation
    :parameters (?underwriting_case - underwriting_case ?compliance_flag - compliance_flag)
    :precondition
      (and
        (external_indicator_evaluation_started ?underwriting_case)
        (case_has_compliance_flag ?underwriting_case ?compliance_flag)
        (not
          (external_indicator_evaluation_completed ?underwriting_case)
        )
      )
    :effect (external_indicator_evaluation_completed ?underwriting_case)
  )
  (:action finalize_external_evaluation_and_commit
    :parameters (?underwriting_case - underwriting_case)
    :precondition
      (and
        (external_indicator_evaluation_completed ?underwriting_case)
        (not
          (case_finalized ?underwriting_case)
        )
      )
    :effect
      (and
        (case_finalized ?underwriting_case)
        (case_or_application_onboarded ?underwriting_case)
      )
  )
  (:action onboard_primary_applicant
    :parameters (?primary_applicant - primary_applicant_record ?refinance_offer - refinance_offer)
    :precondition
      (and
        (primary_applicant_verification_started ?primary_applicant)
        (primary_applicant_verification_passed ?primary_applicant)
        (offer_generated ?refinance_offer)
        (offer_locked ?refinance_offer)
        (not
          (case_or_application_onboarded ?primary_applicant)
        )
      )
    :effect (case_or_application_onboarded ?primary_applicant)
  )
  (:action onboard_co_applicant
    :parameters (?co_applicant - co_applicant_record ?refinance_offer - refinance_offer)
    :precondition
      (and
        (co_applicant_verification_started ?co_applicant)
        (co_applicant_verification_passed ?co_applicant)
        (offer_generated ?refinance_offer)
        (offer_locked ?refinance_offer)
        (not
          (case_or_application_onboarded ?co_applicant)
        )
      )
    :effect (case_or_application_onboarded ?co_applicant)
  )
  (:action tag_application_with_risk_threshold
    :parameters (?loan_application - loan_application ?risk_threshold - risk_threshold ?document - document)
    :precondition
      (and
        (case_or_application_onboarded ?loan_application)
        (case_or_application_has_document ?loan_application ?document)
        (risk_threshold_available ?risk_threshold)
        (not
          (prequalified ?loan_application)
        )
      )
    :effect
      (and
        (prequalified ?loan_application)
        (case_or_application_tagged_risk_threshold ?loan_application ?risk_threshold)
        (not
          (risk_threshold_available ?risk_threshold)
        )
      )
  )
  (:action finalize_refinancing_decision_primary_applicant
    :parameters (?primary_applicant - primary_applicant_record ?decision_engine - decision_engine ?risk_threshold - risk_threshold)
    :precondition
      (and
        (prequalified ?primary_applicant)
        (case_or_application_assigned_engine ?primary_applicant ?decision_engine)
        (case_or_application_tagged_risk_threshold ?primary_applicant ?risk_threshold)
        (not
          (decision_finalized ?primary_applicant)
        )
      )
    :effect
      (and
        (decision_finalized ?primary_applicant)
        (engine_available ?decision_engine)
        (risk_threshold_available ?risk_threshold)
      )
  )
  (:action finalize_refinancing_decision_co_applicant
    :parameters (?co_applicant - co_applicant_record ?decision_engine - decision_engine ?risk_threshold - risk_threshold)
    :precondition
      (and
        (prequalified ?co_applicant)
        (case_or_application_assigned_engine ?co_applicant ?decision_engine)
        (case_or_application_tagged_risk_threshold ?co_applicant ?risk_threshold)
        (not
          (decision_finalized ?co_applicant)
        )
      )
    :effect
      (and
        (decision_finalized ?co_applicant)
        (engine_available ?decision_engine)
        (risk_threshold_available ?risk_threshold)
      )
  )
  (:action finalize_refinancing_decision_case
    :parameters (?underwriting_case - underwriting_case ?decision_engine - decision_engine ?risk_threshold - risk_threshold)
    :precondition
      (and
        (prequalified ?underwriting_case)
        (case_or_application_assigned_engine ?underwriting_case ?decision_engine)
        (case_or_application_tagged_risk_threshold ?underwriting_case ?risk_threshold)
        (not
          (decision_finalized ?underwriting_case)
        )
      )
    :effect
      (and
        (decision_finalized ?underwriting_case)
        (engine_available ?decision_engine)
        (risk_threshold_available ?risk_threshold)
      )
  )
)

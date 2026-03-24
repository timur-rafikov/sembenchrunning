(define (domain scholarship_compliance_support_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object resource_category - entity document_category - entity intervention_category - entity case_root - entity case_record - case_root advisor_availability_slot - resource_category scholarship_requirement_item - resource_category support_unit - resource_category approval_document - resource_category referral_service - resource_category consent_document - resource_category provider_authorization - resource_category sponsor_confirmation_record - resource_category evidence_document - document_category accommodation_request_form - document_category sponsor_reference_document - document_category academic_intervention - intervention_category financial_intervention - intervention_category intervention_plan - intervention_category primary_case_type - case_record bundle_case_type - case_record academic_case - primary_case_type financial_aid_case - primary_case_type case_bundle_record - bundle_case_type)

  (:predicates
    (case_registered ?case_record - case_record)
    (case_validated ?case_record - case_record)
    (case_assigned_slot_flag ?case_record - case_record)
    (case_closed ?case_record - case_record)
    (case_outcome_recorded ?case_record - case_record)
    (case_compliance_confirmed ?case_record - case_record)
    (advisor_slot_available ?advisor_availability_slot - advisor_availability_slot)
    (case_assigned_slot ?case_record - case_record ?advisor_availability_slot - advisor_availability_slot)
    (requirement_item_available ?scholarship_requirement_item - scholarship_requirement_item)
    (case_has_requirement_item ?case_record - case_record ?scholarship_requirement_item - scholarship_requirement_item)
    (support_unit_available ?support_unit - support_unit)
    (case_assigned_support_unit ?case_record - case_record ?support_unit - support_unit)
    (evidence_document_available ?evidence_document - evidence_document)
    (academic_case_evidence_attached ?academic_case - academic_case ?evidence_document - evidence_document)
    (financial_case_evidence_attached ?financial_aid_case - financial_aid_case ?evidence_document - evidence_document)
    (academic_case_has_intervention ?academic_case - academic_case ?academic_intervention - academic_intervention)
    (academic_intervention_triggered ?academic_intervention - academic_intervention)
    (academic_intervention_has_evidence ?academic_intervention - academic_intervention)
    (academic_case_ready ?academic_case - academic_case)
    (financial_case_has_intervention ?financial_aid_case - financial_aid_case ?financial_intervention - financial_intervention)
    (financial_intervention_triggered ?financial_intervention - financial_intervention)
    (financial_intervention_has_evidence ?financial_intervention - financial_intervention)
    (financial_case_ready ?financial_aid_case - financial_aid_case)
    (plan_available ?intervention_plan - intervention_plan)
    (plan_populated ?intervention_plan - intervention_plan)
    (plan_has_academic_intervention ?intervention_plan - intervention_plan ?academic_intervention - academic_intervention)
    (plan_has_financial_intervention ?intervention_plan - intervention_plan ?financial_intervention - financial_intervention)
    (plan_includes_accommodation_request ?intervention_plan - intervention_plan)
    (plan_includes_provider_authorization ?intervention_plan - intervention_plan)
    (plan_assessment_intake_completed ?intervention_plan - intervention_plan)
    (bundle_links_academic_case ?case_bundle_record - case_bundle_record ?academic_case - academic_case)
    (bundle_links_financial_case ?case_bundle_record - case_bundle_record ?financial_aid_case - financial_aid_case)
    (bundle_has_plan ?case_bundle_record - case_bundle_record ?intervention_plan - intervention_plan)
    (accommodation_form_available ?accommodation_request_form - accommodation_request_form)
    (bundle_has_accommodation_form ?case_bundle_record - case_bundle_record ?accommodation_request_form - accommodation_request_form)
    (accommodation_form_consumed ?accommodation_request_form - accommodation_request_form)
    (accommodation_form_linked_to_plan ?accommodation_request_form - accommodation_request_form ?intervention_plan - intervention_plan)
    (bundle_plan_materialized ?case_bundle_record - case_bundle_record)
    (bundle_prepared_for_finalization ?case_bundle_record - case_bundle_record)
    (bundle_ready_for_finalization ?case_bundle_record - case_bundle_record)
    (bundle_approval_attached ?case_bundle_record - case_bundle_record)
    (bundle_approval_processed ?case_bundle_record - case_bundle_record)
    (bundle_support_resources_attached ?case_bundle_record - case_bundle_record)
    (bundle_provider_authorization_attached ?case_bundle_record - case_bundle_record)
    (sponsor_reference_available ?sponsor_reference_document - sponsor_reference_document)
    (bundle_has_sponsor_reference ?case_bundle_record - case_bundle_record ?sponsor_reference_document - sponsor_reference_document)
    (bundle_sponsor_reference_attached ?case_bundle_record - case_bundle_record)
    (bundle_sponsor_review_initiated ?case_bundle_record - case_bundle_record)
    (bundle_sponsor_confirmed ?case_bundle_record - case_bundle_record)
    (approval_document_available ?approval_document - approval_document)
    (bundle_has_approval_document ?case_bundle_record - case_bundle_record ?approval_document - approval_document)
    (referral_service_available ?referral_service - referral_service)
    (bundle_has_referral_service ?case_bundle_record - case_bundle_record ?referral_service - referral_service)
    (provider_authorization_available ?provider_authorization - provider_authorization)
    (bundle_has_provider_authorization ?case_bundle_record - case_bundle_record ?provider_authorization - provider_authorization)
    (sponsor_confirmation_available ?sponsor_confirmation_record - sponsor_confirmation_record)
    (bundle_has_sponsor_confirmation ?case_bundle_record - case_bundle_record ?sponsor_confirmation_record - sponsor_confirmation_record)
    (consent_document_available ?consent_document - consent_document)
    (case_has_consent_document ?case_record - case_record ?consent_document - consent_document)
    (academic_case_intervention_logged ?academic_case - academic_case)
    (financial_case_intervention_logged ?financial_aid_case - financial_aid_case)
    (bundle_finalized ?case_bundle_record - case_bundle_record)
  )
  (:action open_scholarship_case
    :parameters (?case_record - case_record)
    :precondition
      (and
        (not
          (case_registered ?case_record)
        )
        (not
          (case_closed ?case_record)
        )
      )
    :effect (case_registered ?case_record)
  )
  (:action assign_advisor_slot
    :parameters (?case_record - case_record ?advisor_availability_slot - advisor_availability_slot)
    :precondition
      (and
        (case_registered ?case_record)
        (not
          (case_assigned_slot_flag ?case_record)
        )
        (advisor_slot_available ?advisor_availability_slot)
      )
    :effect
      (and
        (case_assigned_slot_flag ?case_record)
        (case_assigned_slot ?case_record ?advisor_availability_slot)
        (not
          (advisor_slot_available ?advisor_availability_slot)
        )
      )
  )
  (:action attach_requirement_item
    :parameters (?case_record - case_record ?scholarship_requirement_item - scholarship_requirement_item)
    :precondition
      (and
        (case_registered ?case_record)
        (case_assigned_slot_flag ?case_record)
        (requirement_item_available ?scholarship_requirement_item)
      )
    :effect
      (and
        (case_has_requirement_item ?case_record ?scholarship_requirement_item)
        (not
          (requirement_item_available ?scholarship_requirement_item)
        )
      )
  )
  (:action validate_requirement_item
    :parameters (?case_record - case_record ?scholarship_requirement_item - scholarship_requirement_item)
    :precondition
      (and
        (case_registered ?case_record)
        (case_assigned_slot_flag ?case_record)
        (case_has_requirement_item ?case_record ?scholarship_requirement_item)
        (not
          (case_validated ?case_record)
        )
      )
    :effect (case_validated ?case_record)
  )
  (:action return_requirement_item
    :parameters (?case_record - case_record ?scholarship_requirement_item - scholarship_requirement_item)
    :precondition
      (and
        (case_has_requirement_item ?case_record ?scholarship_requirement_item)
      )
    :effect
      (and
        (requirement_item_available ?scholarship_requirement_item)
        (not
          (case_has_requirement_item ?case_record ?scholarship_requirement_item)
        )
      )
  )
  (:action refer_case_to_support_unit
    :parameters (?case_record - case_record ?support_unit - support_unit)
    :precondition
      (and
        (case_validated ?case_record)
        (support_unit_available ?support_unit)
      )
    :effect
      (and
        (case_assigned_support_unit ?case_record ?support_unit)
        (not
          (support_unit_available ?support_unit)
        )
      )
  )
  (:action unassign_support_unit
    :parameters (?case_record - case_record ?support_unit - support_unit)
    :precondition
      (and
        (case_assigned_support_unit ?case_record ?support_unit)
      )
    :effect
      (and
        (support_unit_available ?support_unit)
        (not
          (case_assigned_support_unit ?case_record ?support_unit)
        )
      )
  )
  (:action attach_provider_authorization
    :parameters (?case_bundle_record - case_bundle_record ?provider_authorization - provider_authorization)
    :precondition
      (and
        (case_validated ?case_bundle_record)
        (provider_authorization_available ?provider_authorization)
      )
    :effect
      (and
        (bundle_has_provider_authorization ?case_bundle_record ?provider_authorization)
        (not
          (provider_authorization_available ?provider_authorization)
        )
      )
  )
  (:action detach_provider_authorization
    :parameters (?case_bundle_record - case_bundle_record ?provider_authorization - provider_authorization)
    :precondition
      (and
        (bundle_has_provider_authorization ?case_bundle_record ?provider_authorization)
      )
    :effect
      (and
        (provider_authorization_available ?provider_authorization)
        (not
          (bundle_has_provider_authorization ?case_bundle_record ?provider_authorization)
        )
      )
  )
  (:action attach_sponsor_confirmation
    :parameters (?case_bundle_record - case_bundle_record ?sponsor_confirmation_record - sponsor_confirmation_record)
    :precondition
      (and
        (case_validated ?case_bundle_record)
        (sponsor_confirmation_available ?sponsor_confirmation_record)
      )
    :effect
      (and
        (bundle_has_sponsor_confirmation ?case_bundle_record ?sponsor_confirmation_record)
        (not
          (sponsor_confirmation_available ?sponsor_confirmation_record)
        )
      )
  )
  (:action detach_sponsor_confirmation
    :parameters (?case_bundle_record - case_bundle_record ?sponsor_confirmation_record - sponsor_confirmation_record)
    :precondition
      (and
        (bundle_has_sponsor_confirmation ?case_bundle_record ?sponsor_confirmation_record)
      )
    :effect
      (and
        (sponsor_confirmation_available ?sponsor_confirmation_record)
        (not
          (bundle_has_sponsor_confirmation ?case_bundle_record ?sponsor_confirmation_record)
        )
      )
  )
  (:action trigger_academic_intervention
    :parameters (?academic_case - academic_case ?academic_intervention - academic_intervention ?scholarship_requirement_item - scholarship_requirement_item)
    :precondition
      (and
        (case_validated ?academic_case)
        (case_has_requirement_item ?academic_case ?scholarship_requirement_item)
        (academic_case_has_intervention ?academic_case ?academic_intervention)
        (not
          (academic_intervention_triggered ?academic_intervention)
        )
        (not
          (academic_intervention_has_evidence ?academic_intervention)
        )
      )
    :effect (academic_intervention_triggered ?academic_intervention)
  )
  (:action assign_academic_intervention_to_case
    :parameters (?academic_case - academic_case ?academic_intervention - academic_intervention ?support_unit - support_unit)
    :precondition
      (and
        (case_validated ?academic_case)
        (case_assigned_support_unit ?academic_case ?support_unit)
        (academic_case_has_intervention ?academic_case ?academic_intervention)
        (academic_intervention_triggered ?academic_intervention)
        (not
          (academic_case_intervention_logged ?academic_case)
        )
      )
    :effect
      (and
        (academic_case_intervention_logged ?academic_case)
        (academic_case_ready ?academic_case)
      )
  )
  (:action attach_evidence_to_academic_case
    :parameters (?academic_case - academic_case ?academic_intervention - academic_intervention ?evidence_document - evidence_document)
    :precondition
      (and
        (case_validated ?academic_case)
        (academic_case_has_intervention ?academic_case ?academic_intervention)
        (evidence_document_available ?evidence_document)
        (not
          (academic_case_intervention_logged ?academic_case)
        )
      )
    :effect
      (and
        (academic_intervention_has_evidence ?academic_intervention)
        (academic_case_intervention_logged ?academic_case)
        (academic_case_evidence_attached ?academic_case ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action confirm_academic_evidence
    :parameters (?academic_case - academic_case ?academic_intervention - academic_intervention ?scholarship_requirement_item - scholarship_requirement_item ?evidence_document - evidence_document)
    :precondition
      (and
        (case_validated ?academic_case)
        (case_has_requirement_item ?academic_case ?scholarship_requirement_item)
        (academic_case_has_intervention ?academic_case ?academic_intervention)
        (academic_intervention_has_evidence ?academic_intervention)
        (academic_case_evidence_attached ?academic_case ?evidence_document)
        (not
          (academic_case_ready ?academic_case)
        )
      )
    :effect
      (and
        (academic_intervention_triggered ?academic_intervention)
        (academic_case_ready ?academic_case)
        (evidence_document_available ?evidence_document)
        (not
          (academic_case_evidence_attached ?academic_case ?evidence_document)
        )
      )
  )
  (:action trigger_financial_intervention
    :parameters (?financial_aid_case - financial_aid_case ?financial_intervention - financial_intervention ?scholarship_requirement_item - scholarship_requirement_item)
    :precondition
      (and
        (case_validated ?financial_aid_case)
        (case_has_requirement_item ?financial_aid_case ?scholarship_requirement_item)
        (financial_case_has_intervention ?financial_aid_case ?financial_intervention)
        (not
          (financial_intervention_triggered ?financial_intervention)
        )
        (not
          (financial_intervention_has_evidence ?financial_intervention)
        )
      )
    :effect (financial_intervention_triggered ?financial_intervention)
  )
  (:action assign_financial_intervention_to_case
    :parameters (?financial_aid_case - financial_aid_case ?financial_intervention - financial_intervention ?support_unit - support_unit)
    :precondition
      (and
        (case_validated ?financial_aid_case)
        (case_assigned_support_unit ?financial_aid_case ?support_unit)
        (financial_case_has_intervention ?financial_aid_case ?financial_intervention)
        (financial_intervention_triggered ?financial_intervention)
        (not
          (financial_case_intervention_logged ?financial_aid_case)
        )
      )
    :effect
      (and
        (financial_case_intervention_logged ?financial_aid_case)
        (financial_case_ready ?financial_aid_case)
      )
  )
  (:action attach_evidence_to_financial_case
    :parameters (?financial_aid_case - financial_aid_case ?financial_intervention - financial_intervention ?evidence_document - evidence_document)
    :precondition
      (and
        (case_validated ?financial_aid_case)
        (financial_case_has_intervention ?financial_aid_case ?financial_intervention)
        (evidence_document_available ?evidence_document)
        (not
          (financial_case_intervention_logged ?financial_aid_case)
        )
      )
    :effect
      (and
        (financial_intervention_has_evidence ?financial_intervention)
        (financial_case_intervention_logged ?financial_aid_case)
        (financial_case_evidence_attached ?financial_aid_case ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action confirm_financial_evidence
    :parameters (?financial_aid_case - financial_aid_case ?financial_intervention - financial_intervention ?scholarship_requirement_item - scholarship_requirement_item ?evidence_document - evidence_document)
    :precondition
      (and
        (case_validated ?financial_aid_case)
        (case_has_requirement_item ?financial_aid_case ?scholarship_requirement_item)
        (financial_case_has_intervention ?financial_aid_case ?financial_intervention)
        (financial_intervention_has_evidence ?financial_intervention)
        (financial_case_evidence_attached ?financial_aid_case ?evidence_document)
        (not
          (financial_case_ready ?financial_aid_case)
        )
      )
    :effect
      (and
        (financial_intervention_triggered ?financial_intervention)
        (financial_case_ready ?financial_aid_case)
        (evidence_document_available ?evidence_document)
        (not
          (financial_case_evidence_attached ?financial_aid_case ?evidence_document)
        )
      )
  )
  (:action create_intervention_plan_basic
    :parameters (?academic_case - academic_case ?financial_aid_case - financial_aid_case ?academic_intervention - academic_intervention ?financial_intervention - financial_intervention ?intervention_plan - intervention_plan)
    :precondition
      (and
        (academic_case_intervention_logged ?academic_case)
        (financial_case_intervention_logged ?financial_aid_case)
        (academic_case_has_intervention ?academic_case ?academic_intervention)
        (financial_case_has_intervention ?financial_aid_case ?financial_intervention)
        (academic_intervention_triggered ?academic_intervention)
        (financial_intervention_triggered ?financial_intervention)
        (academic_case_ready ?academic_case)
        (financial_case_ready ?financial_aid_case)
        (plan_available ?intervention_plan)
      )
    :effect
      (and
        (plan_populated ?intervention_plan)
        (plan_has_academic_intervention ?intervention_plan ?academic_intervention)
        (plan_has_financial_intervention ?intervention_plan ?financial_intervention)
        (not
          (plan_available ?intervention_plan)
        )
      )
  )
  (:action create_intervention_plan_with_accommodation
    :parameters (?academic_case - academic_case ?financial_aid_case - financial_aid_case ?academic_intervention - academic_intervention ?financial_intervention - financial_intervention ?intervention_plan - intervention_plan)
    :precondition
      (and
        (academic_case_intervention_logged ?academic_case)
        (financial_case_intervention_logged ?financial_aid_case)
        (academic_case_has_intervention ?academic_case ?academic_intervention)
        (financial_case_has_intervention ?financial_aid_case ?financial_intervention)
        (academic_intervention_has_evidence ?academic_intervention)
        (financial_intervention_triggered ?financial_intervention)
        (not
          (academic_case_ready ?academic_case)
        )
        (financial_case_ready ?financial_aid_case)
        (plan_available ?intervention_plan)
      )
    :effect
      (and
        (plan_populated ?intervention_plan)
        (plan_has_academic_intervention ?intervention_plan ?academic_intervention)
        (plan_has_financial_intervention ?intervention_plan ?financial_intervention)
        (plan_includes_accommodation_request ?intervention_plan)
        (not
          (plan_available ?intervention_plan)
        )
      )
  )
  (:action create_intervention_plan_with_authorization
    :parameters (?academic_case - academic_case ?financial_aid_case - financial_aid_case ?academic_intervention - academic_intervention ?financial_intervention - financial_intervention ?intervention_plan - intervention_plan)
    :precondition
      (and
        (academic_case_intervention_logged ?academic_case)
        (financial_case_intervention_logged ?financial_aid_case)
        (academic_case_has_intervention ?academic_case ?academic_intervention)
        (financial_case_has_intervention ?financial_aid_case ?financial_intervention)
        (academic_intervention_triggered ?academic_intervention)
        (financial_intervention_has_evidence ?financial_intervention)
        (academic_case_ready ?academic_case)
        (not
          (financial_case_ready ?financial_aid_case)
        )
        (plan_available ?intervention_plan)
      )
    :effect
      (and
        (plan_populated ?intervention_plan)
        (plan_has_academic_intervention ?intervention_plan ?academic_intervention)
        (plan_has_financial_intervention ?intervention_plan ?financial_intervention)
        (plan_includes_provider_authorization ?intervention_plan)
        (not
          (plan_available ?intervention_plan)
        )
      )
  )
  (:action create_intervention_plan_with_accommodation_and_authorization
    :parameters (?academic_case - academic_case ?financial_aid_case - financial_aid_case ?academic_intervention - academic_intervention ?financial_intervention - financial_intervention ?intervention_plan - intervention_plan)
    :precondition
      (and
        (academic_case_intervention_logged ?academic_case)
        (financial_case_intervention_logged ?financial_aid_case)
        (academic_case_has_intervention ?academic_case ?academic_intervention)
        (financial_case_has_intervention ?financial_aid_case ?financial_intervention)
        (academic_intervention_has_evidence ?academic_intervention)
        (financial_intervention_has_evidence ?financial_intervention)
        (not
          (academic_case_ready ?academic_case)
        )
        (not
          (financial_case_ready ?financial_aid_case)
        )
        (plan_available ?intervention_plan)
      )
    :effect
      (and
        (plan_populated ?intervention_plan)
        (plan_has_academic_intervention ?intervention_plan ?academic_intervention)
        (plan_has_financial_intervention ?intervention_plan ?financial_intervention)
        (plan_includes_accommodation_request ?intervention_plan)
        (plan_includes_provider_authorization ?intervention_plan)
        (not
          (plan_available ?intervention_plan)
        )
      )
  )
  (:action complete_plan_assessment_intake
    :parameters (?intervention_plan - intervention_plan ?academic_case - academic_case ?scholarship_requirement_item - scholarship_requirement_item)
    :precondition
      (and
        (plan_populated ?intervention_plan)
        (academic_case_intervention_logged ?academic_case)
        (case_has_requirement_item ?academic_case ?scholarship_requirement_item)
        (not
          (plan_assessment_intake_completed ?intervention_plan)
        )
      )
    :effect (plan_assessment_intake_completed ?intervention_plan)
  )
  (:action consume_accommodation_form_and_link
    :parameters (?case_bundle_record - case_bundle_record ?accommodation_request_form - accommodation_request_form ?intervention_plan - intervention_plan)
    :precondition
      (and
        (case_validated ?case_bundle_record)
        (bundle_has_plan ?case_bundle_record ?intervention_plan)
        (bundle_has_accommodation_form ?case_bundle_record ?accommodation_request_form)
        (accommodation_form_available ?accommodation_request_form)
        (plan_populated ?intervention_plan)
        (plan_assessment_intake_completed ?intervention_plan)
        (not
          (accommodation_form_consumed ?accommodation_request_form)
        )
      )
    :effect
      (and
        (accommodation_form_consumed ?accommodation_request_form)
        (accommodation_form_linked_to_plan ?accommodation_request_form ?intervention_plan)
        (not
          (accommodation_form_available ?accommodation_request_form)
        )
      )
  )
  (:action materialize_plan_and_mark_bundle
    :parameters (?case_bundle_record - case_bundle_record ?accommodation_request_form - accommodation_request_form ?intervention_plan - intervention_plan ?scholarship_requirement_item - scholarship_requirement_item)
    :precondition
      (and
        (case_validated ?case_bundle_record)
        (bundle_has_accommodation_form ?case_bundle_record ?accommodation_request_form)
        (accommodation_form_consumed ?accommodation_request_form)
        (accommodation_form_linked_to_plan ?accommodation_request_form ?intervention_plan)
        (case_has_requirement_item ?case_bundle_record ?scholarship_requirement_item)
        (not
          (plan_includes_accommodation_request ?intervention_plan)
        )
        (not
          (bundle_plan_materialized ?case_bundle_record)
        )
      )
    :effect (bundle_plan_materialized ?case_bundle_record)
  )
  (:action attach_approval_document
    :parameters (?case_bundle_record - case_bundle_record ?approval_document - approval_document)
    :precondition
      (and
        (case_validated ?case_bundle_record)
        (approval_document_available ?approval_document)
        (not
          (bundle_approval_attached ?case_bundle_record)
        )
      )
    :effect
      (and
        (bundle_approval_attached ?case_bundle_record)
        (bundle_has_approval_document ?case_bundle_record ?approval_document)
        (not
          (approval_document_available ?approval_document)
        )
      )
  )
  (:action process_approval_and_materialize_bundle
    :parameters (?case_bundle_record - case_bundle_record ?accommodation_request_form - accommodation_request_form ?intervention_plan - intervention_plan ?scholarship_requirement_item - scholarship_requirement_item ?approval_document - approval_document)
    :precondition
      (and
        (case_validated ?case_bundle_record)
        (bundle_has_accommodation_form ?case_bundle_record ?accommodation_request_form)
        (accommodation_form_consumed ?accommodation_request_form)
        (accommodation_form_linked_to_plan ?accommodation_request_form ?intervention_plan)
        (case_has_requirement_item ?case_bundle_record ?scholarship_requirement_item)
        (plan_includes_accommodation_request ?intervention_plan)
        (bundle_approval_attached ?case_bundle_record)
        (bundle_has_approval_document ?case_bundle_record ?approval_document)
        (not
          (bundle_plan_materialized ?case_bundle_record)
        )
      )
    :effect
      (and
        (bundle_plan_materialized ?case_bundle_record)
        (bundle_approval_processed ?case_bundle_record)
      )
  )
  (:action process_provider_authorization_initial
    :parameters (?case_bundle_record - case_bundle_record ?provider_authorization - provider_authorization ?support_unit - support_unit ?accommodation_request_form - accommodation_request_form ?intervention_plan - intervention_plan)
    :precondition
      (and
        (bundle_plan_materialized ?case_bundle_record)
        (bundle_has_provider_authorization ?case_bundle_record ?provider_authorization)
        (case_assigned_support_unit ?case_bundle_record ?support_unit)
        (bundle_has_accommodation_form ?case_bundle_record ?accommodation_request_form)
        (accommodation_form_linked_to_plan ?accommodation_request_form ?intervention_plan)
        (not
          (plan_includes_provider_authorization ?intervention_plan)
        )
        (not
          (bundle_prepared_for_finalization ?case_bundle_record)
        )
      )
    :effect (bundle_prepared_for_finalization ?case_bundle_record)
  )
  (:action process_provider_authorization_followup
    :parameters (?case_bundle_record - case_bundle_record ?provider_authorization - provider_authorization ?support_unit - support_unit ?accommodation_request_form - accommodation_request_form ?intervention_plan - intervention_plan)
    :precondition
      (and
        (bundle_plan_materialized ?case_bundle_record)
        (bundle_has_provider_authorization ?case_bundle_record ?provider_authorization)
        (case_assigned_support_unit ?case_bundle_record ?support_unit)
        (bundle_has_accommodation_form ?case_bundle_record ?accommodation_request_form)
        (accommodation_form_linked_to_plan ?accommodation_request_form ?intervention_plan)
        (plan_includes_provider_authorization ?intervention_plan)
        (not
          (bundle_prepared_for_finalization ?case_bundle_record)
        )
      )
    :effect (bundle_prepared_for_finalization ?case_bundle_record)
  )
  (:action mark_bundle_ready_for_sponsor_confirmation
    :parameters (?case_bundle_record - case_bundle_record ?sponsor_confirmation_record - sponsor_confirmation_record ?accommodation_request_form - accommodation_request_form ?intervention_plan - intervention_plan)
    :precondition
      (and
        (bundle_prepared_for_finalization ?case_bundle_record)
        (bundle_has_sponsor_confirmation ?case_bundle_record ?sponsor_confirmation_record)
        (bundle_has_accommodation_form ?case_bundle_record ?accommodation_request_form)
        (accommodation_form_linked_to_plan ?accommodation_request_form ?intervention_plan)
        (not
          (plan_includes_accommodation_request ?intervention_plan)
        )
        (not
          (plan_includes_provider_authorization ?intervention_plan)
        )
        (not
          (bundle_ready_for_finalization ?case_bundle_record)
        )
      )
    :effect (bundle_ready_for_finalization ?case_bundle_record)
  )
  (:action materialize_bundle_and_attach_sponsor_confirmation_stage1
    :parameters (?case_bundle_record - case_bundle_record ?sponsor_confirmation_record - sponsor_confirmation_record ?accommodation_request_form - accommodation_request_form ?intervention_plan - intervention_plan)
    :precondition
      (and
        (bundle_prepared_for_finalization ?case_bundle_record)
        (bundle_has_sponsor_confirmation ?case_bundle_record ?sponsor_confirmation_record)
        (bundle_has_accommodation_form ?case_bundle_record ?accommodation_request_form)
        (accommodation_form_linked_to_plan ?accommodation_request_form ?intervention_plan)
        (plan_includes_accommodation_request ?intervention_plan)
        (not
          (plan_includes_provider_authorization ?intervention_plan)
        )
        (not
          (bundle_ready_for_finalization ?case_bundle_record)
        )
      )
    :effect
      (and
        (bundle_ready_for_finalization ?case_bundle_record)
        (bundle_support_resources_attached ?case_bundle_record)
      )
  )
  (:action materialize_bundle_and_attach_sponsor_confirmation_stage2
    :parameters (?case_bundle_record - case_bundle_record ?sponsor_confirmation_record - sponsor_confirmation_record ?accommodation_request_form - accommodation_request_form ?intervention_plan - intervention_plan)
    :precondition
      (and
        (bundle_prepared_for_finalization ?case_bundle_record)
        (bundle_has_sponsor_confirmation ?case_bundle_record ?sponsor_confirmation_record)
        (bundle_has_accommodation_form ?case_bundle_record ?accommodation_request_form)
        (accommodation_form_linked_to_plan ?accommodation_request_form ?intervention_plan)
        (not
          (plan_includes_accommodation_request ?intervention_plan)
        )
        (plan_includes_provider_authorization ?intervention_plan)
        (not
          (bundle_ready_for_finalization ?case_bundle_record)
        )
      )
    :effect
      (and
        (bundle_ready_for_finalization ?case_bundle_record)
        (bundle_support_resources_attached ?case_bundle_record)
      )
  )
  (:action materialize_bundle_and_attach_sponsor_confirmation_stage3
    :parameters (?case_bundle_record - case_bundle_record ?sponsor_confirmation_record - sponsor_confirmation_record ?accommodation_request_form - accommodation_request_form ?intervention_plan - intervention_plan)
    :precondition
      (and
        (bundle_prepared_for_finalization ?case_bundle_record)
        (bundle_has_sponsor_confirmation ?case_bundle_record ?sponsor_confirmation_record)
        (bundle_has_accommodation_form ?case_bundle_record ?accommodation_request_form)
        (accommodation_form_linked_to_plan ?accommodation_request_form ?intervention_plan)
        (plan_includes_accommodation_request ?intervention_plan)
        (plan_includes_provider_authorization ?intervention_plan)
        (not
          (bundle_ready_for_finalization ?case_bundle_record)
        )
      )
    :effect
      (and
        (bundle_ready_for_finalization ?case_bundle_record)
        (bundle_support_resources_attached ?case_bundle_record)
      )
  )
  (:action finalize_plan_and_record_outcome
    :parameters (?case_bundle_record - case_bundle_record)
    :precondition
      (and
        (bundle_ready_for_finalization ?case_bundle_record)
        (not
          (bundle_support_resources_attached ?case_bundle_record)
        )
        (not
          (bundle_finalized ?case_bundle_record)
        )
      )
    :effect
      (and
        (bundle_finalized ?case_bundle_record)
        (case_outcome_recorded ?case_bundle_record)
      )
  )
  (:action attach_referral_service_to_bundle
    :parameters (?case_bundle_record - case_bundle_record ?referral_service - referral_service)
    :precondition
      (and
        (bundle_ready_for_finalization ?case_bundle_record)
        (bundle_support_resources_attached ?case_bundle_record)
        (referral_service_available ?referral_service)
      )
    :effect
      (and
        (bundle_has_referral_service ?case_bundle_record ?referral_service)
        (not
          (referral_service_available ?referral_service)
        )
      )
  )
  (:action activate_intervention_plan_for_bundle
    :parameters (?case_bundle_record - case_bundle_record ?academic_case - academic_case ?financial_aid_case - financial_aid_case ?scholarship_requirement_item - scholarship_requirement_item ?referral_service - referral_service)
    :precondition
      (and
        (bundle_ready_for_finalization ?case_bundle_record)
        (bundle_support_resources_attached ?case_bundle_record)
        (bundle_has_referral_service ?case_bundle_record ?referral_service)
        (bundle_links_academic_case ?case_bundle_record ?academic_case)
        (bundle_links_financial_case ?case_bundle_record ?financial_aid_case)
        (academic_case_ready ?academic_case)
        (financial_case_ready ?financial_aid_case)
        (case_has_requirement_item ?case_bundle_record ?scholarship_requirement_item)
        (not
          (bundle_provider_authorization_attached ?case_bundle_record)
        )
      )
    :effect (bundle_provider_authorization_attached ?case_bundle_record)
  )
  (:action finalize_bundle_post_activation
    :parameters (?case_bundle_record - case_bundle_record)
    :precondition
      (and
        (bundle_ready_for_finalization ?case_bundle_record)
        (bundle_provider_authorization_attached ?case_bundle_record)
        (not
          (bundle_finalized ?case_bundle_record)
        )
      )
    :effect
      (and
        (bundle_finalized ?case_bundle_record)
        (case_outcome_recorded ?case_bundle_record)
      )
  )
  (:action attach_sponsor_reference_to_bundle
    :parameters (?case_bundle_record - case_bundle_record ?sponsor_reference_document - sponsor_reference_document ?scholarship_requirement_item - scholarship_requirement_item)
    :precondition
      (and
        (case_validated ?case_bundle_record)
        (case_has_requirement_item ?case_bundle_record ?scholarship_requirement_item)
        (sponsor_reference_available ?sponsor_reference_document)
        (bundle_has_sponsor_reference ?case_bundle_record ?sponsor_reference_document)
        (not
          (bundle_sponsor_reference_attached ?case_bundle_record)
        )
      )
    :effect
      (and
        (bundle_sponsor_reference_attached ?case_bundle_record)
        (not
          (sponsor_reference_available ?sponsor_reference_document)
        )
      )
  )
  (:action initiate_sponsor_review_on_bundle
    :parameters (?case_bundle_record - case_bundle_record ?support_unit - support_unit)
    :precondition
      (and
        (bundle_sponsor_reference_attached ?case_bundle_record)
        (case_assigned_support_unit ?case_bundle_record ?support_unit)
        (not
          (bundle_sponsor_review_initiated ?case_bundle_record)
        )
      )
    :effect (bundle_sponsor_review_initiated ?case_bundle_record)
  )
  (:action record_sponsor_confirmation_on_bundle
    :parameters (?case_bundle_record - case_bundle_record ?sponsor_confirmation_record - sponsor_confirmation_record)
    :precondition
      (and
        (bundle_sponsor_review_initiated ?case_bundle_record)
        (bundle_has_sponsor_confirmation ?case_bundle_record ?sponsor_confirmation_record)
        (not
          (bundle_sponsor_confirmed ?case_bundle_record)
        )
      )
    :effect (bundle_sponsor_confirmed ?case_bundle_record)
  )
  (:action finalize_bundle_post_sponsor_confirmation
    :parameters (?case_bundle_record - case_bundle_record)
    :precondition
      (and
        (bundle_sponsor_confirmed ?case_bundle_record)
        (not
          (bundle_finalized ?case_bundle_record)
        )
      )
    :effect
      (and
        (bundle_finalized ?case_bundle_record)
        (case_outcome_recorded ?case_bundle_record)
      )
  )
  (:action record_academic_case_compliance
    :parameters (?academic_case - academic_case ?intervention_plan - intervention_plan)
    :precondition
      (and
        (academic_case_intervention_logged ?academic_case)
        (academic_case_ready ?academic_case)
        (plan_populated ?intervention_plan)
        (plan_assessment_intake_completed ?intervention_plan)
        (not
          (case_outcome_recorded ?academic_case)
        )
      )
    :effect (case_outcome_recorded ?academic_case)
  )
  (:action record_financial_case_compliance
    :parameters (?financial_aid_case - financial_aid_case ?intervention_plan - intervention_plan)
    :precondition
      (and
        (financial_case_intervention_logged ?financial_aid_case)
        (financial_case_ready ?financial_aid_case)
        (plan_populated ?intervention_plan)
        (plan_assessment_intake_completed ?intervention_plan)
        (not
          (case_outcome_recorded ?financial_aid_case)
        )
      )
    :effect (case_outcome_recorded ?financial_aid_case)
  )
  (:action record_compliance_and_attach_consent
    :parameters (?case_record - case_record ?consent_document - consent_document ?scholarship_requirement_item - scholarship_requirement_item)
    :precondition
      (and
        (case_outcome_recorded ?case_record)
        (case_has_requirement_item ?case_record ?scholarship_requirement_item)
        (consent_document_available ?consent_document)
        (not
          (case_compliance_confirmed ?case_record)
        )
      )
    :effect
      (and
        (case_compliance_confirmed ?case_record)
        (case_has_consent_document ?case_record ?consent_document)
        (not
          (consent_document_available ?consent_document)
        )
      )
  )
  (:action confirm_academic_case_and_release_slot
    :parameters (?academic_case - academic_case ?advisor_availability_slot - advisor_availability_slot ?consent_document - consent_document)
    :precondition
      (and
        (case_compliance_confirmed ?academic_case)
        (case_assigned_slot ?academic_case ?advisor_availability_slot)
        (case_has_consent_document ?academic_case ?consent_document)
        (not
          (case_closed ?academic_case)
        )
      )
    :effect
      (and
        (case_closed ?academic_case)
        (advisor_slot_available ?advisor_availability_slot)
        (consent_document_available ?consent_document)
      )
  )
  (:action confirm_financial_case_and_release_slot
    :parameters (?financial_aid_case - financial_aid_case ?advisor_availability_slot - advisor_availability_slot ?consent_document - consent_document)
    :precondition
      (and
        (case_compliance_confirmed ?financial_aid_case)
        (case_assigned_slot ?financial_aid_case ?advisor_availability_slot)
        (case_has_consent_document ?financial_aid_case ?consent_document)
        (not
          (case_closed ?financial_aid_case)
        )
      )
    :effect
      (and
        (case_closed ?financial_aid_case)
        (advisor_slot_available ?advisor_availability_slot)
        (consent_document_available ?consent_document)
      )
  )
  (:action confirm_bundle_and_release_slot
    :parameters (?case_bundle_record - case_bundle_record ?advisor_availability_slot - advisor_availability_slot ?consent_document - consent_document)
    :precondition
      (and
        (case_compliance_confirmed ?case_bundle_record)
        (case_assigned_slot ?case_bundle_record ?advisor_availability_slot)
        (case_has_consent_document ?case_bundle_record ?consent_document)
        (not
          (case_closed ?case_bundle_record)
        )
      )
    :effect
      (and
        (case_closed ?case_bundle_record)
        (advisor_slot_available ?advisor_availability_slot)
        (consent_document_available ?consent_document)
      )
  )
)

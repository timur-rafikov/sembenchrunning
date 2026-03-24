(define (domain education_personal_leave_and_reentry_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types case_resource - object service_type - object document_type - object organizational_unit - object person - organizational_unit referral_destination - case_resource support_provider - case_resource on_campus_contact - case_resource policy_waiver - case_resource authorization_token - case_resource leave_reason_code - case_resource accommodation_resource - case_resource external_verification - case_resource document_template - service_type attachment - service_type departmental_approval_record - service_type medical_assessment_indicator - document_type academic_readiness_indicator - document_type reentry_plan - document_type staff_subgroup - person staff_group - person academic_advisor - staff_subgroup program_advisor - staff_subgroup case_manager - staff_group)
  (:predicates
    (case_opened ?student - person)
    (case_acknowledged_by_actor ?student - person)
    (referral_initiated ?student - person)
    (reentry_activated ?student - person)
    (case_finalized_by_actor ?student - person)
    (leave_recorded ?student - person)
    (referral_destination_available ?referral_destination - referral_destination)
    (referral_assignment ?student - person ?referral_destination - referral_destination)
    (support_provider_available ?support_provider - support_provider)
    (support_assignment ?student - person ?support_provider - support_provider)
    (on_campus_contact_available ?on_campus_contact - on_campus_contact)
    (contact_assignment ?student - person ?on_campus_contact - on_campus_contact)
    (document_template_available ?document_template - document_template)
    (advisor_template_attached ?academic_advisor - academic_advisor ?document_template - document_template)
    (program_template_attached ?program_advisor - program_advisor ?document_template - document_template)
    (linked_medical_assessment ?academic_advisor - academic_advisor ?medical_assessment_indicator - medical_assessment_indicator)
    (medical_assessment_flagged ?medical_assessment_indicator - medical_assessment_indicator)
    (medical_assessment_document_attached ?medical_assessment_indicator - medical_assessment_indicator)
    (medical_review_completed ?academic_advisor - academic_advisor)
    (linked_academic_assessment ?program_advisor - program_advisor ?academic_readiness_indicator - academic_readiness_indicator)
    (academic_assessment_flagged ?academic_readiness_indicator - academic_readiness_indicator)
    (academic_assessment_document_attached ?academic_readiness_indicator - academic_readiness_indicator)
    (academic_review_completed ?program_advisor - program_advisor)
    (reentry_plan_slot_available ?reentry_plan - reentry_plan)
    (plan_draft_created ?reentry_plan - reentry_plan)
    (plan_includes_medical_indicator ?reentry_plan - reentry_plan ?medical_assessment_indicator - medical_assessment_indicator)
    (plan_includes_academic_indicator ?reentry_plan - reentry_plan ?academic_readiness_indicator - academic_readiness_indicator)
    (plan_requires_departmental_approval ?reentry_plan - reentry_plan)
    (plan_requires_policy_waiver ?reentry_plan - reentry_plan)
    (plan_finalized ?reentry_plan - reentry_plan)
    (case_manager_assigned_academic_advisor ?case_manager - case_manager ?academic_advisor - academic_advisor)
    (case_manager_assigned_program_advisor ?case_manager - case_manager ?program_advisor - program_advisor)
    (case_manager_has_reentry_plan ?case_manager - case_manager ?reentry_plan - reentry_plan)
    (attachment_available ?attachment - attachment)
    (case_manager_has_attachment ?case_manager - case_manager ?attachment - attachment)
    (attachment_recorded ?attachment - attachment)
    (attachment_linked_to_plan ?attachment - attachment ?reentry_plan - reentry_plan)
    (case_manager_ready_for_review ?case_manager - case_manager)
    (case_manager_preparation_complete ?case_manager - case_manager)
    (case_manager_draft_completed ?case_manager - case_manager)
    (case_manager_has_waiver ?case_manager - case_manager)
    (case_manager_waiver_processed ?case_manager - case_manager)
    (authorization_collected ?case_manager - case_manager)
    (internal_signoffs_complete ?case_manager - case_manager)
    (departmental_approval_available ?departmental_approval_record - departmental_approval_record)
    (case_manager_has_departmental_approval ?case_manager - case_manager ?departmental_approval_record - departmental_approval_record)
    (departmental_approval_recorded ?case_manager - case_manager)
    (approval_acknowledged ?case_manager - case_manager)
    (external_verification_recorded ?case_manager - case_manager)
    (policy_waiver_available ?policy_waiver - policy_waiver)
    (waiver_assigned_to_case_manager ?case_manager - case_manager ?policy_waiver - policy_waiver)
    (authorization_token_available ?authorization_token - authorization_token)
    (authorization_assigned_to_case_manager ?case_manager - case_manager ?authorization_token - authorization_token)
    (accommodation_resource_available ?accommodation_resource - accommodation_resource)
    (accommodation_assigned_to_case_manager ?case_manager - case_manager ?accommodation_resource - accommodation_resource)
    (external_verification_available ?external_verification - external_verification)
    (external_verification_attached_to_case_manager ?case_manager - case_manager ?external_verification - external_verification)
    (leave_reason_code_available ?leave_reason_code - leave_reason_code)
    (person_leave_reason_assigned ?student - person ?leave_reason_code - leave_reason_code)
    (advisor_documentation_ready ?academic_advisor - academic_advisor)
    (program_advisor_documentation_ready ?program_advisor - program_advisor)
    (case_manager_draft_finalized ?case_manager - case_manager)
  )
  (:action open_student_case
    :parameters (?student - person)
    :precondition
      (and
        (not
          (case_opened ?student)
        )
        (not
          (reentry_activated ?student)
        )
      )
    :effect (case_opened ?student)
  )
  (:action assign_referral_destination
    :parameters (?student - person ?referral_destination - referral_destination)
    :precondition
      (and
        (case_opened ?student)
        (not
          (referral_initiated ?student)
        )
        (referral_destination_available ?referral_destination)
      )
    :effect
      (and
        (referral_initiated ?student)
        (referral_assignment ?student ?referral_destination)
        (not
          (referral_destination_available ?referral_destination)
        )
      )
  )
  (:action assign_support_provider
    :parameters (?student - person ?support_provider - support_provider)
    :precondition
      (and
        (case_opened ?student)
        (referral_initiated ?student)
        (support_provider_available ?support_provider)
      )
    :effect
      (and
        (support_assignment ?student ?support_provider)
        (not
          (support_provider_available ?support_provider)
        )
      )
  )
  (:action confirm_support_engagement
    :parameters (?student - person ?support_provider - support_provider)
    :precondition
      (and
        (case_opened ?student)
        (referral_initiated ?student)
        (support_assignment ?student ?support_provider)
        (not
          (case_acknowledged_by_actor ?student)
        )
      )
    :effect (case_acknowledged_by_actor ?student)
  )
  (:action release_support_provider
    :parameters (?student - person ?support_provider - support_provider)
    :precondition
      (and
        (support_assignment ?student ?support_provider)
      )
    :effect
      (and
        (support_provider_available ?support_provider)
        (not
          (support_assignment ?student ?support_provider)
        )
      )
  )
  (:action assign_on_campus_contact
    :parameters (?student - person ?on_campus_contact - on_campus_contact)
    :precondition
      (and
        (case_acknowledged_by_actor ?student)
        (on_campus_contact_available ?on_campus_contact)
      )
    :effect
      (and
        (contact_assignment ?student ?on_campus_contact)
        (not
          (on_campus_contact_available ?on_campus_contact)
        )
      )
  )
  (:action release_on_campus_contact
    :parameters (?student - person ?on_campus_contact - on_campus_contact)
    :precondition
      (and
        (contact_assignment ?student ?on_campus_contact)
      )
    :effect
      (and
        (on_campus_contact_available ?on_campus_contact)
        (not
          (contact_assignment ?student ?on_campus_contact)
        )
      )
  )
  (:action assign_accommodation_to_case
    :parameters (?case_manager - case_manager ?accommodation_resource - accommodation_resource)
    :precondition
      (and
        (case_acknowledged_by_actor ?case_manager)
        (accommodation_resource_available ?accommodation_resource)
      )
    :effect
      (and
        (accommodation_assigned_to_case_manager ?case_manager ?accommodation_resource)
        (not
          (accommodation_resource_available ?accommodation_resource)
        )
      )
  )
  (:action remove_accommodation_from_case
    :parameters (?case_manager - case_manager ?accommodation_resource - accommodation_resource)
    :precondition
      (and
        (accommodation_assigned_to_case_manager ?case_manager ?accommodation_resource)
      )
    :effect
      (and
        (accommodation_resource_available ?accommodation_resource)
        (not
          (accommodation_assigned_to_case_manager ?case_manager ?accommodation_resource)
        )
      )
  )
  (:action attach_external_verification_to_case
    :parameters (?case_manager - case_manager ?external_verification - external_verification)
    :precondition
      (and
        (case_acknowledged_by_actor ?case_manager)
        (external_verification_available ?external_verification)
      )
    :effect
      (and
        (external_verification_attached_to_case_manager ?case_manager ?external_verification)
        (not
          (external_verification_available ?external_verification)
        )
      )
  )
  (:action remove_external_verification_from_case
    :parameters (?case_manager - case_manager ?external_verification - external_verification)
    :precondition
      (and
        (external_verification_attached_to_case_manager ?case_manager ?external_verification)
      )
    :effect
      (and
        (external_verification_available ?external_verification)
        (not
          (external_verification_attached_to_case_manager ?case_manager ?external_verification)
        )
      )
  )
  (:action flag_medical_assessment_for_advisor
    :parameters (?academic_advisor - academic_advisor ?medical_assessment_indicator - medical_assessment_indicator ?support_provider - support_provider)
    :precondition
      (and
        (case_acknowledged_by_actor ?academic_advisor)
        (support_assignment ?academic_advisor ?support_provider)
        (linked_medical_assessment ?academic_advisor ?medical_assessment_indicator)
        (not
          (medical_assessment_flagged ?medical_assessment_indicator)
        )
        (not
          (medical_assessment_document_attached ?medical_assessment_indicator)
        )
      )
    :effect (medical_assessment_flagged ?medical_assessment_indicator)
  )
  (:action confirm_medical_assessment_review
    :parameters (?academic_advisor - academic_advisor ?medical_assessment_indicator - medical_assessment_indicator ?on_campus_contact - on_campus_contact)
    :precondition
      (and
        (case_acknowledged_by_actor ?academic_advisor)
        (contact_assignment ?academic_advisor ?on_campus_contact)
        (linked_medical_assessment ?academic_advisor ?medical_assessment_indicator)
        (medical_assessment_flagged ?medical_assessment_indicator)
        (not
          (advisor_documentation_ready ?academic_advisor)
        )
      )
    :effect
      (and
        (advisor_documentation_ready ?academic_advisor)
        (medical_review_completed ?academic_advisor)
      )
  )
  (:action attach_document_template_for_medical_assessment
    :parameters (?academic_advisor - academic_advisor ?medical_assessment_indicator - medical_assessment_indicator ?document_template - document_template)
    :precondition
      (and
        (case_acknowledged_by_actor ?academic_advisor)
        (linked_medical_assessment ?academic_advisor ?medical_assessment_indicator)
        (document_template_available ?document_template)
        (not
          (advisor_documentation_ready ?academic_advisor)
        )
      )
    :effect
      (and
        (medical_assessment_document_attached ?medical_assessment_indicator)
        (advisor_documentation_ready ?academic_advisor)
        (advisor_template_attached ?academic_advisor ?document_template)
        (not
          (document_template_available ?document_template)
        )
      )
  )
  (:action process_medical_assessment_attachment
    :parameters (?academic_advisor - academic_advisor ?medical_assessment_indicator - medical_assessment_indicator ?support_provider - support_provider ?document_template - document_template)
    :precondition
      (and
        (case_acknowledged_by_actor ?academic_advisor)
        (support_assignment ?academic_advisor ?support_provider)
        (linked_medical_assessment ?academic_advisor ?medical_assessment_indicator)
        (medical_assessment_document_attached ?medical_assessment_indicator)
        (advisor_template_attached ?academic_advisor ?document_template)
        (not
          (medical_review_completed ?academic_advisor)
        )
      )
    :effect
      (and
        (medical_assessment_flagged ?medical_assessment_indicator)
        (medical_review_completed ?academic_advisor)
        (document_template_available ?document_template)
        (not
          (advisor_template_attached ?academic_advisor ?document_template)
        )
      )
  )
  (:action flag_academic_assessment_for_program_advisor
    :parameters (?program_advisor - program_advisor ?academic_readiness_indicator - academic_readiness_indicator ?support_provider - support_provider)
    :precondition
      (and
        (case_acknowledged_by_actor ?program_advisor)
        (support_assignment ?program_advisor ?support_provider)
        (linked_academic_assessment ?program_advisor ?academic_readiness_indicator)
        (not
          (academic_assessment_flagged ?academic_readiness_indicator)
        )
        (not
          (academic_assessment_document_attached ?academic_readiness_indicator)
        )
      )
    :effect (academic_assessment_flagged ?academic_readiness_indicator)
  )
  (:action confirm_academic_assessment_review
    :parameters (?program_advisor - program_advisor ?academic_readiness_indicator - academic_readiness_indicator ?on_campus_contact - on_campus_contact)
    :precondition
      (and
        (case_acknowledged_by_actor ?program_advisor)
        (contact_assignment ?program_advisor ?on_campus_contact)
        (linked_academic_assessment ?program_advisor ?academic_readiness_indicator)
        (academic_assessment_flagged ?academic_readiness_indicator)
        (not
          (program_advisor_documentation_ready ?program_advisor)
        )
      )
    :effect
      (and
        (program_advisor_documentation_ready ?program_advisor)
        (academic_review_completed ?program_advisor)
      )
  )
  (:action attach_document_template_for_academic_assessment
    :parameters (?program_advisor - program_advisor ?academic_readiness_indicator - academic_readiness_indicator ?document_template - document_template)
    :precondition
      (and
        (case_acknowledged_by_actor ?program_advisor)
        (linked_academic_assessment ?program_advisor ?academic_readiness_indicator)
        (document_template_available ?document_template)
        (not
          (program_advisor_documentation_ready ?program_advisor)
        )
      )
    :effect
      (and
        (academic_assessment_document_attached ?academic_readiness_indicator)
        (program_advisor_documentation_ready ?program_advisor)
        (program_template_attached ?program_advisor ?document_template)
        (not
          (document_template_available ?document_template)
        )
      )
  )
  (:action process_academic_assessment_attachment
    :parameters (?program_advisor - program_advisor ?academic_readiness_indicator - academic_readiness_indicator ?support_provider - support_provider ?document_template - document_template)
    :precondition
      (and
        (case_acknowledged_by_actor ?program_advisor)
        (support_assignment ?program_advisor ?support_provider)
        (linked_academic_assessment ?program_advisor ?academic_readiness_indicator)
        (academic_assessment_document_attached ?academic_readiness_indicator)
        (program_template_attached ?program_advisor ?document_template)
        (not
          (academic_review_completed ?program_advisor)
        )
      )
    :effect
      (and
        (academic_assessment_flagged ?academic_readiness_indicator)
        (academic_review_completed ?program_advisor)
        (document_template_available ?document_template)
        (not
          (program_template_attached ?program_advisor ?document_template)
        )
      )
  )
  (:action assemble_reentry_plan_draft
    :parameters (?academic_advisor - academic_advisor ?program_advisor - program_advisor ?medical_assessment_indicator - medical_assessment_indicator ?academic_readiness_indicator - academic_readiness_indicator ?reentry_plan - reentry_plan)
    :precondition
      (and
        (advisor_documentation_ready ?academic_advisor)
        (program_advisor_documentation_ready ?program_advisor)
        (linked_medical_assessment ?academic_advisor ?medical_assessment_indicator)
        (linked_academic_assessment ?program_advisor ?academic_readiness_indicator)
        (medical_assessment_flagged ?medical_assessment_indicator)
        (academic_assessment_flagged ?academic_readiness_indicator)
        (medical_review_completed ?academic_advisor)
        (academic_review_completed ?program_advisor)
        (reentry_plan_slot_available ?reentry_plan)
      )
    :effect
      (and
        (plan_draft_created ?reentry_plan)
        (plan_includes_medical_indicator ?reentry_plan ?medical_assessment_indicator)
        (plan_includes_academic_indicator ?reentry_plan ?academic_readiness_indicator)
        (not
          (reentry_plan_slot_available ?reentry_plan)
        )
      )
  )
  (:action assemble_reentry_plan_require_departmental_approval
    :parameters (?academic_advisor - academic_advisor ?program_advisor - program_advisor ?medical_assessment_indicator - medical_assessment_indicator ?academic_readiness_indicator - academic_readiness_indicator ?reentry_plan - reentry_plan)
    :precondition
      (and
        (advisor_documentation_ready ?academic_advisor)
        (program_advisor_documentation_ready ?program_advisor)
        (linked_medical_assessment ?academic_advisor ?medical_assessment_indicator)
        (linked_academic_assessment ?program_advisor ?academic_readiness_indicator)
        (medical_assessment_document_attached ?medical_assessment_indicator)
        (academic_assessment_flagged ?academic_readiness_indicator)
        (not
          (medical_review_completed ?academic_advisor)
        )
        (academic_review_completed ?program_advisor)
        (reentry_plan_slot_available ?reentry_plan)
      )
    :effect
      (and
        (plan_draft_created ?reentry_plan)
        (plan_includes_medical_indicator ?reentry_plan ?medical_assessment_indicator)
        (plan_includes_academic_indicator ?reentry_plan ?academic_readiness_indicator)
        (plan_requires_departmental_approval ?reentry_plan)
        (not
          (reentry_plan_slot_available ?reentry_plan)
        )
      )
  )
  (:action assemble_reentry_plan_require_policy_waiver
    :parameters (?academic_advisor - academic_advisor ?program_advisor - program_advisor ?medical_assessment_indicator - medical_assessment_indicator ?academic_readiness_indicator - academic_readiness_indicator ?reentry_plan - reentry_plan)
    :precondition
      (and
        (advisor_documentation_ready ?academic_advisor)
        (program_advisor_documentation_ready ?program_advisor)
        (linked_medical_assessment ?academic_advisor ?medical_assessment_indicator)
        (linked_academic_assessment ?program_advisor ?academic_readiness_indicator)
        (medical_assessment_flagged ?medical_assessment_indicator)
        (academic_assessment_document_attached ?academic_readiness_indicator)
        (medical_review_completed ?academic_advisor)
        (not
          (academic_review_completed ?program_advisor)
        )
        (reentry_plan_slot_available ?reentry_plan)
      )
    :effect
      (and
        (plan_draft_created ?reentry_plan)
        (plan_includes_medical_indicator ?reentry_plan ?medical_assessment_indicator)
        (plan_includes_academic_indicator ?reentry_plan ?academic_readiness_indicator)
        (plan_requires_policy_waiver ?reentry_plan)
        (not
          (reentry_plan_slot_available ?reentry_plan)
        )
      )
  )
  (:action assemble_reentry_plan_require_departmental_and_policy_waiver
    :parameters (?academic_advisor - academic_advisor ?program_advisor - program_advisor ?medical_assessment_indicator - medical_assessment_indicator ?academic_readiness_indicator - academic_readiness_indicator ?reentry_plan - reentry_plan)
    :precondition
      (and
        (advisor_documentation_ready ?academic_advisor)
        (program_advisor_documentation_ready ?program_advisor)
        (linked_medical_assessment ?academic_advisor ?medical_assessment_indicator)
        (linked_academic_assessment ?program_advisor ?academic_readiness_indicator)
        (medical_assessment_document_attached ?medical_assessment_indicator)
        (academic_assessment_document_attached ?academic_readiness_indicator)
        (not
          (medical_review_completed ?academic_advisor)
        )
        (not
          (academic_review_completed ?program_advisor)
        )
        (reentry_plan_slot_available ?reentry_plan)
      )
    :effect
      (and
        (plan_draft_created ?reentry_plan)
        (plan_includes_medical_indicator ?reentry_plan ?medical_assessment_indicator)
        (plan_includes_academic_indicator ?reentry_plan ?academic_readiness_indicator)
        (plan_requires_departmental_approval ?reentry_plan)
        (plan_requires_policy_waiver ?reentry_plan)
        (not
          (reentry_plan_slot_available ?reentry_plan)
        )
      )
  )
  (:action finalize_reentry_plan_draft
    :parameters (?reentry_plan - reentry_plan ?academic_advisor - academic_advisor ?support_provider - support_provider)
    :precondition
      (and
        (plan_draft_created ?reentry_plan)
        (advisor_documentation_ready ?academic_advisor)
        (support_assignment ?academic_advisor ?support_provider)
        (not
          (plan_finalized ?reentry_plan)
        )
      )
    :effect (plan_finalized ?reentry_plan)
  )
  (:action record_attachment_and_link_to_plan
    :parameters (?case_manager - case_manager ?attachment - attachment ?reentry_plan - reentry_plan)
    :precondition
      (and
        (case_acknowledged_by_actor ?case_manager)
        (case_manager_has_reentry_plan ?case_manager ?reentry_plan)
        (case_manager_has_attachment ?case_manager ?attachment)
        (attachment_available ?attachment)
        (plan_draft_created ?reentry_plan)
        (plan_finalized ?reentry_plan)
        (not
          (attachment_recorded ?attachment)
        )
      )
    :effect
      (and
        (attachment_recorded ?attachment)
        (attachment_linked_to_plan ?attachment ?reentry_plan)
        (not
          (attachment_available ?attachment)
        )
      )
  )
  (:action prepare_case_manager_for_plan_review
    :parameters (?case_manager - case_manager ?attachment - attachment ?reentry_plan - reentry_plan ?support_provider - support_provider)
    :precondition
      (and
        (case_acknowledged_by_actor ?case_manager)
        (case_manager_has_attachment ?case_manager ?attachment)
        (attachment_recorded ?attachment)
        (attachment_linked_to_plan ?attachment ?reentry_plan)
        (support_assignment ?case_manager ?support_provider)
        (not
          (plan_requires_departmental_approval ?reentry_plan)
        )
        (not
          (case_manager_ready_for_review ?case_manager)
        )
      )
    :effect (case_manager_ready_for_review ?case_manager)
  )
  (:action assign_policy_waiver_to_case_manager
    :parameters (?case_manager - case_manager ?policy_waiver - policy_waiver)
    :precondition
      (and
        (case_acknowledged_by_actor ?case_manager)
        (policy_waiver_available ?policy_waiver)
        (not
          (case_manager_has_waiver ?case_manager)
        )
      )
    :effect
      (and
        (case_manager_has_waiver ?case_manager)
        (waiver_assigned_to_case_manager ?case_manager ?policy_waiver)
        (not
          (policy_waiver_available ?policy_waiver)
        )
      )
  )
  (:action process_policy_waiver_and_prepare_review
    :parameters (?case_manager - case_manager ?attachment - attachment ?reentry_plan - reentry_plan ?support_provider - support_provider ?policy_waiver - policy_waiver)
    :precondition
      (and
        (case_acknowledged_by_actor ?case_manager)
        (case_manager_has_attachment ?case_manager ?attachment)
        (attachment_recorded ?attachment)
        (attachment_linked_to_plan ?attachment ?reentry_plan)
        (support_assignment ?case_manager ?support_provider)
        (plan_requires_departmental_approval ?reentry_plan)
        (case_manager_has_waiver ?case_manager)
        (waiver_assigned_to_case_manager ?case_manager ?policy_waiver)
        (not
          (case_manager_ready_for_review ?case_manager)
        )
      )
    :effect
      (and
        (case_manager_ready_for_review ?case_manager)
        (case_manager_waiver_processed ?case_manager)
      )
  )
  (:action complete_case_manager_preparation_without_policy_waiver
    :parameters (?case_manager - case_manager ?accommodation_resource - accommodation_resource ?on_campus_contact - on_campus_contact ?attachment - attachment ?reentry_plan - reentry_plan)
    :precondition
      (and
        (case_manager_ready_for_review ?case_manager)
        (accommodation_assigned_to_case_manager ?case_manager ?accommodation_resource)
        (contact_assignment ?case_manager ?on_campus_contact)
        (case_manager_has_attachment ?case_manager ?attachment)
        (attachment_linked_to_plan ?attachment ?reentry_plan)
        (not
          (plan_requires_policy_waiver ?reentry_plan)
        )
        (not
          (case_manager_preparation_complete ?case_manager)
        )
      )
    :effect (case_manager_preparation_complete ?case_manager)
  )
  (:action complete_case_manager_preparation_with_policy_waiver
    :parameters (?case_manager - case_manager ?accommodation_resource - accommodation_resource ?on_campus_contact - on_campus_contact ?attachment - attachment ?reentry_plan - reentry_plan)
    :precondition
      (and
        (case_manager_ready_for_review ?case_manager)
        (accommodation_assigned_to_case_manager ?case_manager ?accommodation_resource)
        (contact_assignment ?case_manager ?on_campus_contact)
        (case_manager_has_attachment ?case_manager ?attachment)
        (attachment_linked_to_plan ?attachment ?reentry_plan)
        (plan_requires_policy_waiver ?reentry_plan)
        (not
          (case_manager_preparation_complete ?case_manager)
        )
      )
    :effect (case_manager_preparation_complete ?case_manager)
  )
  (:action apply_external_verification_then_mark_draft
    :parameters (?case_manager - case_manager ?external_verification - external_verification ?attachment - attachment ?reentry_plan - reentry_plan)
    :precondition
      (and
        (case_manager_preparation_complete ?case_manager)
        (external_verification_attached_to_case_manager ?case_manager ?external_verification)
        (case_manager_has_attachment ?case_manager ?attachment)
        (attachment_linked_to_plan ?attachment ?reentry_plan)
        (not
          (plan_requires_departmental_approval ?reentry_plan)
        )
        (not
          (plan_requires_policy_waiver ?reentry_plan)
        )
        (not
          (case_manager_draft_completed ?case_manager)
        )
      )
    :effect (case_manager_draft_completed ?case_manager)
  )
  (:action apply_external_verification_and_record_authorization
    :parameters (?case_manager - case_manager ?external_verification - external_verification ?attachment - attachment ?reentry_plan - reentry_plan)
    :precondition
      (and
        (case_manager_preparation_complete ?case_manager)
        (external_verification_attached_to_case_manager ?case_manager ?external_verification)
        (case_manager_has_attachment ?case_manager ?attachment)
        (attachment_linked_to_plan ?attachment ?reentry_plan)
        (plan_requires_departmental_approval ?reentry_plan)
        (not
          (plan_requires_policy_waiver ?reentry_plan)
        )
        (not
          (case_manager_draft_completed ?case_manager)
        )
      )
    :effect
      (and
        (case_manager_draft_completed ?case_manager)
        (authorization_collected ?case_manager)
      )
  )
  (:action apply_external_verification_and_collect_consent
    :parameters (?case_manager - case_manager ?external_verification - external_verification ?attachment - attachment ?reentry_plan - reentry_plan)
    :precondition
      (and
        (case_manager_preparation_complete ?case_manager)
        (external_verification_attached_to_case_manager ?case_manager ?external_verification)
        (case_manager_has_attachment ?case_manager ?attachment)
        (attachment_linked_to_plan ?attachment ?reentry_plan)
        (not
          (plan_requires_departmental_approval ?reentry_plan)
        )
        (plan_requires_policy_waiver ?reentry_plan)
        (not
          (case_manager_draft_completed ?case_manager)
        )
      )
    :effect
      (and
        (case_manager_draft_completed ?case_manager)
        (authorization_collected ?case_manager)
      )
  )
  (:action apply_external_verification_and_finalize_authorizations
    :parameters (?case_manager - case_manager ?external_verification - external_verification ?attachment - attachment ?reentry_plan - reentry_plan)
    :precondition
      (and
        (case_manager_preparation_complete ?case_manager)
        (external_verification_attached_to_case_manager ?case_manager ?external_verification)
        (case_manager_has_attachment ?case_manager ?attachment)
        (attachment_linked_to_plan ?attachment ?reentry_plan)
        (plan_requires_departmental_approval ?reentry_plan)
        (plan_requires_policy_waiver ?reentry_plan)
        (not
          (case_manager_draft_completed ?case_manager)
        )
      )
    :effect
      (and
        (case_manager_draft_completed ?case_manager)
        (authorization_collected ?case_manager)
      )
  )
  (:action finalize_case_manager_draft_without_authorization
    :parameters (?case_manager - case_manager)
    :precondition
      (and
        (case_manager_draft_completed ?case_manager)
        (not
          (authorization_collected ?case_manager)
        )
        (not
          (case_manager_draft_finalized ?case_manager)
        )
      )
    :effect
      (and
        (case_manager_draft_finalized ?case_manager)
        (case_finalized_by_actor ?case_manager)
      )
  )
  (:action assign_authorization_token
    :parameters (?case_manager - case_manager ?authorization_token - authorization_token)
    :precondition
      (and
        (case_manager_draft_completed ?case_manager)
        (authorization_collected ?case_manager)
        (authorization_token_available ?authorization_token)
      )
    :effect
      (and
        (authorization_assigned_to_case_manager ?case_manager ?authorization_token)
        (not
          (authorization_token_available ?authorization_token)
        )
      )
  )
  (:action complete_internal_signoffs_for_case
    :parameters (?case_manager - case_manager ?academic_advisor - academic_advisor ?program_advisor - program_advisor ?support_provider - support_provider ?authorization_token - authorization_token)
    :precondition
      (and
        (case_manager_draft_completed ?case_manager)
        (authorization_collected ?case_manager)
        (authorization_assigned_to_case_manager ?case_manager ?authorization_token)
        (case_manager_assigned_academic_advisor ?case_manager ?academic_advisor)
        (case_manager_assigned_program_advisor ?case_manager ?program_advisor)
        (medical_review_completed ?academic_advisor)
        (academic_review_completed ?program_advisor)
        (support_assignment ?case_manager ?support_provider)
        (not
          (internal_signoffs_complete ?case_manager)
        )
      )
    :effect (internal_signoffs_complete ?case_manager)
  )
  (:action finalize_case_manager_draft_with_signoffs
    :parameters (?case_manager - case_manager)
    :precondition
      (and
        (case_manager_draft_completed ?case_manager)
        (internal_signoffs_complete ?case_manager)
        (not
          (case_manager_draft_finalized ?case_manager)
        )
      )
    :effect
      (and
        (case_manager_draft_finalized ?case_manager)
        (case_finalized_by_actor ?case_manager)
      )
  )
  (:action apply_departmental_approval_to_case
    :parameters (?case_manager - case_manager ?departmental_approval_record - departmental_approval_record ?support_provider - support_provider)
    :precondition
      (and
        (case_acknowledged_by_actor ?case_manager)
        (support_assignment ?case_manager ?support_provider)
        (departmental_approval_available ?departmental_approval_record)
        (case_manager_has_departmental_approval ?case_manager ?departmental_approval_record)
        (not
          (departmental_approval_recorded ?case_manager)
        )
      )
    :effect
      (and
        (departmental_approval_recorded ?case_manager)
        (not
          (departmental_approval_available ?departmental_approval_record)
        )
      )
  )
  (:action acknowledge_departmental_approval
    :parameters (?case_manager - case_manager ?on_campus_contact - on_campus_contact)
    :precondition
      (and
        (departmental_approval_recorded ?case_manager)
        (contact_assignment ?case_manager ?on_campus_contact)
        (not
          (approval_acknowledged ?case_manager)
        )
      )
    :effect (approval_acknowledged ?case_manager)
  )
  (:action record_external_verification_acknowledgement
    :parameters (?case_manager - case_manager ?external_verification - external_verification)
    :precondition
      (and
        (approval_acknowledged ?case_manager)
        (external_verification_attached_to_case_manager ?case_manager ?external_verification)
        (not
          (external_verification_recorded ?case_manager)
        )
      )
    :effect (external_verification_recorded ?case_manager)
  )
  (:action finalize_case_after_external_verification
    :parameters (?case_manager - case_manager)
    :precondition
      (and
        (external_verification_recorded ?case_manager)
        (not
          (case_manager_draft_finalized ?case_manager)
        )
      )
    :effect
      (and
        (case_manager_draft_finalized ?case_manager)
        (case_finalized_by_actor ?case_manager)
      )
  )
  (:action finalize_advisor_case
    :parameters (?academic_advisor - academic_advisor ?reentry_plan - reentry_plan)
    :precondition
      (and
        (advisor_documentation_ready ?academic_advisor)
        (medical_review_completed ?academic_advisor)
        (plan_draft_created ?reentry_plan)
        (plan_finalized ?reentry_plan)
        (not
          (case_finalized_by_actor ?academic_advisor)
        )
      )
    :effect (case_finalized_by_actor ?academic_advisor)
  )
  (:action finalize_program_advisor_case
    :parameters (?program_advisor - program_advisor ?reentry_plan - reentry_plan)
    :precondition
      (and
        (program_advisor_documentation_ready ?program_advisor)
        (academic_review_completed ?program_advisor)
        (plan_draft_created ?reentry_plan)
        (plan_finalized ?reentry_plan)
        (not
          (case_finalized_by_actor ?program_advisor)
        )
      )
    :effect (case_finalized_by_actor ?program_advisor)
  )
  (:action record_leave_and_assign_reason
    :parameters (?student - person ?leave_reason_code - leave_reason_code ?support_provider - support_provider)
    :precondition
      (and
        (case_finalized_by_actor ?student)
        (support_assignment ?student ?support_provider)
        (leave_reason_code_available ?leave_reason_code)
        (not
          (leave_recorded ?student)
        )
      )
    :effect
      (and
        (leave_recorded ?student)
        (person_leave_reason_assigned ?student ?leave_reason_code)
        (not
          (leave_reason_code_available ?leave_reason_code)
        )
      )
  )
  (:action activate_reentry_and_release_referral
    :parameters (?academic_advisor - academic_advisor ?referral_destination - referral_destination ?leave_reason_code - leave_reason_code)
    :precondition
      (and
        (leave_recorded ?academic_advisor)
        (referral_assignment ?academic_advisor ?referral_destination)
        (person_leave_reason_assigned ?academic_advisor ?leave_reason_code)
        (not
          (reentry_activated ?academic_advisor)
        )
      )
    :effect
      (and
        (reentry_activated ?academic_advisor)
        (referral_destination_available ?referral_destination)
        (leave_reason_code_available ?leave_reason_code)
      )
  )
  (:action activate_reentry_and_release_referral_program_advisor
    :parameters (?program_advisor - program_advisor ?referral_destination - referral_destination ?leave_reason_code - leave_reason_code)
    :precondition
      (and
        (leave_recorded ?program_advisor)
        (referral_assignment ?program_advisor ?referral_destination)
        (person_leave_reason_assigned ?program_advisor ?leave_reason_code)
        (not
          (reentry_activated ?program_advisor)
        )
      )
    :effect
      (and
        (reentry_activated ?program_advisor)
        (referral_destination_available ?referral_destination)
        (leave_reason_code_available ?leave_reason_code)
      )
  )
  (:action activate_reentry_and_release_referral_for_case_manager
    :parameters (?case_manager - case_manager ?referral_destination - referral_destination ?leave_reason_code - leave_reason_code)
    :precondition
      (and
        (leave_recorded ?case_manager)
        (referral_assignment ?case_manager ?referral_destination)
        (person_leave_reason_assigned ?case_manager ?leave_reason_code)
        (not
          (reentry_activated ?case_manager)
        )
      )
    :effect
      (and
        (reentry_activated ?case_manager)
        (referral_destination_available ?referral_destination)
        (leave_reason_code_available ?leave_reason_code)
      )
  )
)

(define (domain education_student_support_case_management)
  (:requirements :strips :typing :negative-preconditions)
  (:types case_resource - object service_descriptor - object resource_descriptor - object personnel - object person - personnel support_staff - case_resource presenting_concern_tag - case_resource service_provider - case_resource program - case_resource appointment_slot - case_resource accommodation - case_resource support_plan_template - case_resource external_authorization - case_resource intervention_service - service_descriptor documentation - service_descriptor consent_form - service_descriptor barrier_tag - resource_descriptor barrier_tag_secondary - resource_descriptor referral_record - resource_descriptor student_role - person staff_role - person student_primary_profile - student_role student_secondary_profile - student_role staff_member - staff_role)
  (:predicates
    (intake_created ?person - person)
    (assessment_completed ?person - person)
    (case_owner_assigned ?person - person)
    (case_assigned ?person - person)
    (case_actioned_for_person ?person - person)
    (accommodation_initiated ?person - person)
    (support_staff_available ?support_staff - support_staff)
    (assigned_support_staff ?person - person ?support_staff - support_staff)
    (presenting_concern_available ?presenting_concern - presenting_concern_tag)
    (recorded_presenting_concern ?person - person ?presenting_concern - presenting_concern_tag)
    (service_provider_available ?service_provider - service_provider)
    (assigned_service_provider ?person - person ?service_provider - service_provider)
    (intervention_service_available ?intervention_service - intervention_service)
    (requested_intervention_primary ?student_primary_profile - student_primary_profile ?intervention_service - intervention_service)
    (requested_intervention_secondary ?student_secondary_profile - student_secondary_profile ?intervention_service - intervention_service)
    (identified_barrier_primary ?student_primary_profile - student_primary_profile ?barrier_tag - barrier_tag)
    (barrier_flag_active ?barrier_tag - barrier_tag)
    (barrier_requires_intervention ?barrier_tag - barrier_tag)
    (primary_profile_needs_followup ?student_primary_profile - student_primary_profile)
    (identified_barrier_secondary ?student_secondary_profile - student_secondary_profile ?barrier_tag_secondary - barrier_tag_secondary)
    (barrier_secondary_flag_active ?barrier_tag_secondary - barrier_tag_secondary)
    (barrier_secondary_requires_intervention ?barrier_tag_secondary - barrier_tag_secondary)
    (secondary_profile_needs_followup ?student_secondary_profile - student_secondary_profile)
    (referral_pending ?referral_record - referral_record)
    (referral_routed ?referral_record - referral_record)
    (referral_targets_barrier_primary ?referral_record - referral_record ?barrier_tag - barrier_tag)
    (referral_targets_barrier_secondary ?referral_record - referral_record ?barrier_tag_secondary - barrier_tag_secondary)
    (referral_requires_program_approval ?referral_record - referral_record)
    (referral_requires_external_authorization ?referral_record - referral_record)
    (referral_confirmed ?referral_record - referral_record)
    (case_manager_assigned_primary ?staff_member - staff_member ?student_primary_profile - student_primary_profile)
    (case_manager_assigned_secondary ?staff_member - staff_member ?student_secondary_profile - student_secondary_profile)
    (staff_linked_to_referral ?staff_member - staff_member ?referral_record - referral_record)
    (documentation_available ?documentation - documentation)
    (staff_attached_documentation ?staff_member - staff_member ?documentation - documentation)
    (documentation_allocated ?documentation - documentation)
    (documentation_attached_to_referral ?documentation - documentation ?referral_record - referral_record)
    (staff_documents_submitted ?staff_member - staff_member)
    (staff_documents_verified ?staff_member - staff_member)
    (staff_approval_initiated ?staff_member - staff_member)
    (program_attachment_flag_for_staff ?staff_member - staff_member)
    (staff_approval_documentation_completed ?staff_member - staff_member)
    (staff_ready_for_finalization ?staff_member - staff_member)
    (case_finalization_done_for_staff ?staff_member - staff_member)
    (consent_form_available ?consent_form - consent_form)
    (consent_attached_to_staff ?staff_member - staff_member ?consent_form - consent_form)
    (consent_applied ?staff_member - staff_member)
    (consent_review_started ?staff_member - staff_member)
    (consent_finalized ?staff_member - staff_member)
    (program_available ?program - program)
    (staff_attached_program ?staff_member - staff_member ?program - program)
    (appointment_slot_available ?appointment_slot - appointment_slot)
    (staff_appointment_scheduled ?staff_member - staff_member ?appointment_slot - appointment_slot)
    (support_plan_template_available ?support_plan_template - support_plan_template)
    (support_plan_template_assigned ?staff_member - staff_member ?support_plan_template - support_plan_template)
    (external_authorization_available ?external_authorization - external_authorization)
    (external_authorization_attached ?staff_member - staff_member ?external_authorization - external_authorization)
    (accommodation_available ?accommodation - accommodation)
    (accommodation_assigned_to_person ?person - person ?accommodation - accommodation)
    (primary_profile_provider_engaged ?student_primary_profile - student_primary_profile)
    (secondary_profile_provider_engaged ?student_secondary_profile - student_secondary_profile)
    (staff_case_finalized ?staff_member - staff_member)
  )
  (:action create_intake_case
    :parameters (?person - person)
    :precondition
      (and
        (not
          (intake_created ?person)
        )
        (not
          (case_assigned ?person)
        )
      )
    :effect (intake_created ?person)
  )
  (:action assign_initial_support_staff
    :parameters (?person - person ?support_staff - support_staff)
    :precondition
      (and
        (intake_created ?person)
        (not
          (case_owner_assigned ?person)
        )
        (support_staff_available ?support_staff)
      )
    :effect
      (and
        (case_owner_assigned ?person)
        (assigned_support_staff ?person ?support_staff)
        (not
          (support_staff_available ?support_staff)
        )
      )
  )
  (:action record_presenting_concern
    :parameters (?person - person ?concern - presenting_concern_tag)
    :precondition
      (and
        (intake_created ?person)
        (case_owner_assigned ?person)
        (presenting_concern_available ?concern)
      )
    :effect
      (and
        (recorded_presenting_concern ?person ?concern)
        (not
          (presenting_concern_available ?concern)
        )
      )
  )
  (:action complete_preliminary_assessment
    :parameters (?person - person ?concern - presenting_concern_tag)
    :precondition
      (and
        (intake_created ?person)
        (case_owner_assigned ?person)
        (recorded_presenting_concern ?person ?concern)
        (not
          (assessment_completed ?person)
        )
      )
    :effect (assessment_completed ?person)
  )
  (:action release_presenting_concern
    :parameters (?person - person ?concern - presenting_concern_tag)
    :precondition
      (and
        (recorded_presenting_concern ?person ?concern)
      )
    :effect
      (and
        (presenting_concern_available ?concern)
        (not
          (recorded_presenting_concern ?person ?concern)
        )
      )
  )
  (:action assign_service_provider
    :parameters (?person - person ?provider - service_provider)
    :precondition
      (and
        (assessment_completed ?person)
        (service_provider_available ?provider)
      )
    :effect
      (and
        (assigned_service_provider ?person ?provider)
        (not
          (service_provider_available ?provider)
        )
      )
  )
  (:action unassign_service_provider
    :parameters (?person - person ?provider - service_provider)
    :precondition
      (and
        (assigned_service_provider ?person ?provider)
      )
    :effect
      (and
        (service_provider_available ?provider)
        (not
          (assigned_service_provider ?person ?provider)
        )
      )
  )
  (:action assign_support_plan_template_to_staff
    :parameters (?staff - staff_member ?plan_template - support_plan_template)
    :precondition
      (and
        (assessment_completed ?staff)
        (support_plan_template_available ?plan_template)
      )
    :effect
      (and
        (support_plan_template_assigned ?staff ?plan_template)
        (not
          (support_plan_template_available ?plan_template)
        )
      )
  )
  (:action remove_support_plan_template_from_staff
    :parameters (?staff - staff_member ?plan_template - support_plan_template)
    :precondition
      (and
        (support_plan_template_assigned ?staff ?plan_template)
      )
    :effect
      (and
        (support_plan_template_available ?plan_template)
        (not
          (support_plan_template_assigned ?staff ?plan_template)
        )
      )
  )
  (:action assign_external_authorization_to_staff
    :parameters (?staff - staff_member ?external_authorization - external_authorization)
    :precondition
      (and
        (assessment_completed ?staff)
        (external_authorization_available ?external_authorization)
      )
    :effect
      (and
        (external_authorization_attached ?staff ?external_authorization)
        (not
          (external_authorization_available ?external_authorization)
        )
      )
  )
  (:action remove_external_authorization_from_staff
    :parameters (?staff - staff_member ?external_authorization - external_authorization)
    :precondition
      (and
        (external_authorization_attached ?staff ?external_authorization)
      )
    :effect
      (and
        (external_authorization_available ?external_authorization)
        (not
          (external_authorization_attached ?staff ?external_authorization)
        )
      )
  )
  (:action flag_barrier_primary
    :parameters (?student_primary - student_primary_profile ?barrier_primary - barrier_tag ?concern - presenting_concern_tag)
    :precondition
      (and
        (assessment_completed ?student_primary)
        (recorded_presenting_concern ?student_primary ?concern)
        (identified_barrier_primary ?student_primary ?barrier_primary)
        (not
          (barrier_flag_active ?barrier_primary)
        )
        (not
          (barrier_requires_intervention ?barrier_primary)
        )
      )
    :effect (barrier_flag_active ?barrier_primary)
  )
  (:action activate_provider_engagement_primary
    :parameters (?student_primary - student_primary_profile ?barrier_primary - barrier_tag ?provider - service_provider)
    :precondition
      (and
        (assessment_completed ?student_primary)
        (assigned_service_provider ?student_primary ?provider)
        (identified_barrier_primary ?student_primary ?barrier_primary)
        (barrier_flag_active ?barrier_primary)
        (not
          (primary_profile_provider_engaged ?student_primary)
        )
      )
    :effect
      (and
        (primary_profile_provider_engaged ?student_primary)
        (primary_profile_needs_followup ?student_primary)
      )
  )
  (:action request_intervention_for_student_primary
    :parameters (?student_primary - student_primary_profile ?barrier_primary - barrier_tag ?intervention - intervention_service)
    :precondition
      (and
        (assessment_completed ?student_primary)
        (identified_barrier_primary ?student_primary ?barrier_primary)
        (intervention_service_available ?intervention)
        (not
          (primary_profile_provider_engaged ?student_primary)
        )
      )
    :effect
      (and
        (barrier_requires_intervention ?barrier_primary)
        (primary_profile_provider_engaged ?student_primary)
        (requested_intervention_primary ?student_primary ?intervention)
        (not
          (intervention_service_available ?intervention)
        )
      )
  )
  (:action confirm_intervention_for_student_primary
    :parameters (?student_primary - student_primary_profile ?barrier_primary - barrier_tag ?concern - presenting_concern_tag ?intervention - intervention_service)
    :precondition
      (and
        (assessment_completed ?student_primary)
        (recorded_presenting_concern ?student_primary ?concern)
        (identified_barrier_primary ?student_primary ?barrier_primary)
        (barrier_requires_intervention ?barrier_primary)
        (requested_intervention_primary ?student_primary ?intervention)
        (not
          (primary_profile_needs_followup ?student_primary)
        )
      )
    :effect
      (and
        (barrier_flag_active ?barrier_primary)
        (primary_profile_needs_followup ?student_primary)
        (intervention_service_available ?intervention)
        (not
          (requested_intervention_primary ?student_primary ?intervention)
        )
      )
  )
  (:action flag_barrier_secondary
    :parameters (?student_secondary - student_secondary_profile ?barrier_secondary - barrier_tag_secondary ?concern - presenting_concern_tag)
    :precondition
      (and
        (assessment_completed ?student_secondary)
        (recorded_presenting_concern ?student_secondary ?concern)
        (identified_barrier_secondary ?student_secondary ?barrier_secondary)
        (not
          (barrier_secondary_flag_active ?barrier_secondary)
        )
        (not
          (barrier_secondary_requires_intervention ?barrier_secondary)
        )
      )
    :effect (barrier_secondary_flag_active ?barrier_secondary)
  )
  (:action activate_provider_engagement_secondary
    :parameters (?student_secondary - student_secondary_profile ?barrier_secondary - barrier_tag_secondary ?provider - service_provider)
    :precondition
      (and
        (assessment_completed ?student_secondary)
        (assigned_service_provider ?student_secondary ?provider)
        (identified_barrier_secondary ?student_secondary ?barrier_secondary)
        (barrier_secondary_flag_active ?barrier_secondary)
        (not
          (secondary_profile_provider_engaged ?student_secondary)
        )
      )
    :effect
      (and
        (secondary_profile_provider_engaged ?student_secondary)
        (secondary_profile_needs_followup ?student_secondary)
      )
  )
  (:action request_intervention_for_student_secondary
    :parameters (?student_secondary - student_secondary_profile ?barrier_secondary - barrier_tag_secondary ?intervention - intervention_service)
    :precondition
      (and
        (assessment_completed ?student_secondary)
        (identified_barrier_secondary ?student_secondary ?barrier_secondary)
        (intervention_service_available ?intervention)
        (not
          (secondary_profile_provider_engaged ?student_secondary)
        )
      )
    :effect
      (and
        (barrier_secondary_requires_intervention ?barrier_secondary)
        (secondary_profile_provider_engaged ?student_secondary)
        (requested_intervention_secondary ?student_secondary ?intervention)
        (not
          (intervention_service_available ?intervention)
        )
      )
  )
  (:action confirm_intervention_for_student_secondary
    :parameters (?student_secondary - student_secondary_profile ?barrier_secondary - barrier_tag_secondary ?concern - presenting_concern_tag ?intervention - intervention_service)
    :precondition
      (and
        (assessment_completed ?student_secondary)
        (recorded_presenting_concern ?student_secondary ?concern)
        (identified_barrier_secondary ?student_secondary ?barrier_secondary)
        (barrier_secondary_requires_intervention ?barrier_secondary)
        (requested_intervention_secondary ?student_secondary ?intervention)
        (not
          (secondary_profile_needs_followup ?student_secondary)
        )
      )
    :effect
      (and
        (barrier_secondary_flag_active ?barrier_secondary)
        (secondary_profile_needs_followup ?student_secondary)
        (intervention_service_available ?intervention)
        (not
          (requested_intervention_secondary ?student_secondary ?intervention)
        )
      )
  )
  (:action create_and_route_referral
    :parameters (?student_primary - student_primary_profile ?student_secondary - student_secondary_profile ?barrier_primary - barrier_tag ?barrier_secondary - barrier_tag_secondary ?referral - referral_record)
    :precondition
      (and
        (primary_profile_provider_engaged ?student_primary)
        (secondary_profile_provider_engaged ?student_secondary)
        (identified_barrier_primary ?student_primary ?barrier_primary)
        (identified_barrier_secondary ?student_secondary ?barrier_secondary)
        (barrier_flag_active ?barrier_primary)
        (barrier_secondary_flag_active ?barrier_secondary)
        (primary_profile_needs_followup ?student_primary)
        (secondary_profile_needs_followup ?student_secondary)
        (referral_pending ?referral)
      )
    :effect
      (and
        (referral_routed ?referral)
        (referral_targets_barrier_primary ?referral ?barrier_primary)
        (referral_targets_barrier_secondary ?referral ?barrier_secondary)
        (not
          (referral_pending ?referral)
        )
      )
  )
  (:action create_and_route_referral_with_program_approval
    :parameters (?student_primary - student_primary_profile ?student_secondary - student_secondary_profile ?barrier_primary - barrier_tag ?barrier_secondary - barrier_tag_secondary ?referral - referral_record)
    :precondition
      (and
        (primary_profile_provider_engaged ?student_primary)
        (secondary_profile_provider_engaged ?student_secondary)
        (identified_barrier_primary ?student_primary ?barrier_primary)
        (identified_barrier_secondary ?student_secondary ?barrier_secondary)
        (barrier_requires_intervention ?barrier_primary)
        (barrier_secondary_flag_active ?barrier_secondary)
        (not
          (primary_profile_needs_followup ?student_primary)
        )
        (secondary_profile_needs_followup ?student_secondary)
        (referral_pending ?referral)
      )
    :effect
      (and
        (referral_routed ?referral)
        (referral_targets_barrier_primary ?referral ?barrier_primary)
        (referral_targets_barrier_secondary ?referral ?barrier_secondary)
        (referral_requires_program_approval ?referral)
        (not
          (referral_pending ?referral)
        )
      )
  )
  (:action create_and_route_referral_with_external_authorization
    :parameters (?student_primary - student_primary_profile ?student_secondary - student_secondary_profile ?barrier_primary - barrier_tag ?barrier_secondary - barrier_tag_secondary ?referral - referral_record)
    :precondition
      (and
        (primary_profile_provider_engaged ?student_primary)
        (secondary_profile_provider_engaged ?student_secondary)
        (identified_barrier_primary ?student_primary ?barrier_primary)
        (identified_barrier_secondary ?student_secondary ?barrier_secondary)
        (barrier_flag_active ?barrier_primary)
        (barrier_secondary_requires_intervention ?barrier_secondary)
        (primary_profile_needs_followup ?student_primary)
        (not
          (secondary_profile_needs_followup ?student_secondary)
        )
        (referral_pending ?referral)
      )
    :effect
      (and
        (referral_routed ?referral)
        (referral_targets_barrier_primary ?referral ?barrier_primary)
        (referral_targets_barrier_secondary ?referral ?barrier_secondary)
        (referral_requires_external_authorization ?referral)
        (not
          (referral_pending ?referral)
        )
      )
  )
  (:action create_and_route_referral_full_approval
    :parameters (?student_primary - student_primary_profile ?student_secondary - student_secondary_profile ?barrier_primary - barrier_tag ?barrier_secondary - barrier_tag_secondary ?referral - referral_record)
    :precondition
      (and
        (primary_profile_provider_engaged ?student_primary)
        (secondary_profile_provider_engaged ?student_secondary)
        (identified_barrier_primary ?student_primary ?barrier_primary)
        (identified_barrier_secondary ?student_secondary ?barrier_secondary)
        (barrier_requires_intervention ?barrier_primary)
        (barrier_secondary_requires_intervention ?barrier_secondary)
        (not
          (primary_profile_needs_followup ?student_primary)
        )
        (not
          (secondary_profile_needs_followup ?student_secondary)
        )
        (referral_pending ?referral)
      )
    :effect
      (and
        (referral_routed ?referral)
        (referral_targets_barrier_primary ?referral ?barrier_primary)
        (referral_targets_barrier_secondary ?referral ?barrier_secondary)
        (referral_requires_program_approval ?referral)
        (referral_requires_external_authorization ?referral)
        (not
          (referral_pending ?referral)
        )
      )
  )
  (:action confirm_referral_with_provider
    :parameters (?referral - referral_record ?student_primary - student_primary_profile ?concern - presenting_concern_tag)
    :precondition
      (and
        (referral_routed ?referral)
        (primary_profile_provider_engaged ?student_primary)
        (recorded_presenting_concern ?student_primary ?concern)
        (not
          (referral_confirmed ?referral)
        )
      )
    :effect (referral_confirmed ?referral)
  )
  (:action submit_document_to_referral
    :parameters (?staff - staff_member ?document - documentation ?referral - referral_record)
    :precondition
      (and
        (assessment_completed ?staff)
        (staff_linked_to_referral ?staff ?referral)
        (staff_attached_documentation ?staff ?document)
        (documentation_available ?document)
        (referral_routed ?referral)
        (referral_confirmed ?referral)
        (not
          (documentation_allocated ?document)
        )
      )
    :effect
      (and
        (documentation_allocated ?document)
        (documentation_attached_to_referral ?document ?referral)
        (not
          (documentation_available ?document)
        )
      )
  )
  (:action staff_validate_document_for_referral
    :parameters (?staff - staff_member ?document - documentation ?referral - referral_record ?concern - presenting_concern_tag)
    :precondition
      (and
        (assessment_completed ?staff)
        (staff_attached_documentation ?staff ?document)
        (documentation_allocated ?document)
        (documentation_attached_to_referral ?document ?referral)
        (recorded_presenting_concern ?staff ?concern)
        (not
          (referral_requires_program_approval ?referral)
        )
        (not
          (staff_documents_submitted ?staff)
        )
      )
    :effect (staff_documents_submitted ?staff)
  )
  (:action attach_program_to_staff_member
    :parameters (?staff - staff_member ?program - program)
    :precondition
      (and
        (assessment_completed ?staff)
        (program_available ?program)
        (not
          (program_attachment_flag_for_staff ?staff)
        )
      )
    :effect
      (and
        (program_attachment_flag_for_staff ?staff)
        (staff_attached_program ?staff ?program)
        (not
          (program_available ?program)
        )
      )
  )
  (:action advance_documentation_for_program_approval
    :parameters (?staff - staff_member ?document - documentation ?referral - referral_record ?concern - presenting_concern_tag ?program - program)
    :precondition
      (and
        (assessment_completed ?staff)
        (staff_attached_documentation ?staff ?document)
        (documentation_allocated ?document)
        (documentation_attached_to_referral ?document ?referral)
        (recorded_presenting_concern ?staff ?concern)
        (referral_requires_program_approval ?referral)
        (program_attachment_flag_for_staff ?staff)
        (staff_attached_program ?staff ?program)
        (not
          (staff_documents_submitted ?staff)
        )
      )
    :effect
      (and
        (staff_documents_submitted ?staff)
        (staff_approval_documentation_completed ?staff)
      )
  )
  (:action staff_apply_plan_and_prepare_review
    :parameters (?staff - staff_member ?plan_template - support_plan_template ?provider - service_provider ?document - documentation ?referral - referral_record)
    :precondition
      (and
        (staff_documents_submitted ?staff)
        (support_plan_template_assigned ?staff ?plan_template)
        (assigned_service_provider ?staff ?provider)
        (staff_attached_documentation ?staff ?document)
        (documentation_attached_to_referral ?document ?referral)
        (not
          (referral_requires_external_authorization ?referral)
        )
        (not
          (staff_documents_verified ?staff)
        )
      )
    :effect (staff_documents_verified ?staff)
  )
  (:action staff_apply_plan_and_request_review
    :parameters (?staff - staff_member ?plan_template - support_plan_template ?provider - service_provider ?document - documentation ?referral - referral_record)
    :precondition
      (and
        (staff_documents_submitted ?staff)
        (support_plan_template_assigned ?staff ?plan_template)
        (assigned_service_provider ?staff ?provider)
        (staff_attached_documentation ?staff ?document)
        (documentation_attached_to_referral ?document ?referral)
        (referral_requires_external_authorization ?referral)
        (not
          (staff_documents_verified ?staff)
        )
      )
    :effect (staff_documents_verified ?staff)
  )
  (:action staff_initiate_external_authorization_check
    :parameters (?staff - staff_member ?external_authorization - external_authorization ?document - documentation ?referral - referral_record)
    :precondition
      (and
        (staff_documents_verified ?staff)
        (external_authorization_attached ?staff ?external_authorization)
        (staff_attached_documentation ?staff ?document)
        (documentation_attached_to_referral ?document ?referral)
        (not
          (referral_requires_program_approval ?referral)
        )
        (not
          (referral_requires_external_authorization ?referral)
        )
        (not
          (staff_approval_initiated ?staff)
        )
      )
    :effect (staff_approval_initiated ?staff)
  )
  (:action staff_authorization_with_document_confirmation
    :parameters (?staff - staff_member ?external_authorization - external_authorization ?document - documentation ?referral - referral_record)
    :precondition
      (and
        (staff_documents_verified ?staff)
        (external_authorization_attached ?staff ?external_authorization)
        (staff_attached_documentation ?staff ?document)
        (documentation_attached_to_referral ?document ?referral)
        (referral_requires_program_approval ?referral)
        (not
          (referral_requires_external_authorization ?referral)
        )
        (not
          (staff_approval_initiated ?staff)
        )
      )
    :effect
      (and
        (staff_approval_initiated ?staff)
        (staff_ready_for_finalization ?staff)
      )
  )
  (:action staff_authorization_alternate_review
    :parameters (?staff - staff_member ?external_authorization - external_authorization ?document - documentation ?referral - referral_record)
    :precondition
      (and
        (staff_documents_verified ?staff)
        (external_authorization_attached ?staff ?external_authorization)
        (staff_attached_documentation ?staff ?document)
        (documentation_attached_to_referral ?document ?referral)
        (not
          (referral_requires_program_approval ?referral)
        )
        (referral_requires_external_authorization ?referral)
        (not
          (staff_approval_initiated ?staff)
        )
      )
    :effect
      (and
        (staff_approval_initiated ?staff)
        (staff_ready_for_finalization ?staff)
      )
  )
  (:action staff_authorization_combined_review
    :parameters (?staff - staff_member ?external_authorization - external_authorization ?document - documentation ?referral - referral_record)
    :precondition
      (and
        (staff_documents_verified ?staff)
        (external_authorization_attached ?staff ?external_authorization)
        (staff_attached_documentation ?staff ?document)
        (documentation_attached_to_referral ?document ?referral)
        (referral_requires_program_approval ?referral)
        (referral_requires_external_authorization ?referral)
        (not
          (staff_approval_initiated ?staff)
        )
      )
    :effect
      (and
        (staff_approval_initiated ?staff)
        (staff_ready_for_finalization ?staff)
      )
  )
  (:action mark_case_ready_for_closure
    :parameters (?staff - staff_member)
    :precondition
      (and
        (staff_approval_initiated ?staff)
        (not
          (staff_ready_for_finalization ?staff)
        )
        (not
          (staff_case_finalized ?staff)
        )
      )
    :effect
      (and
        (staff_case_finalized ?staff)
        (case_actioned_for_person ?staff)
      )
  )
  (:action schedule_appointment_for_staff
    :parameters (?staff - staff_member ?appointment_slot - appointment_slot)
    :precondition
      (and
        (staff_approval_initiated ?staff)
        (staff_ready_for_finalization ?staff)
        (appointment_slot_available ?appointment_slot)
      )
    :effect
      (and
        (staff_appointment_scheduled ?staff ?appointment_slot)
        (not
          (appointment_slot_available ?appointment_slot)
        )
      )
  )
  (:action record_outcomes_and_finalize_staff_progress
    :parameters (?staff - staff_member ?student_primary - student_primary_profile ?student_secondary - student_secondary_profile ?concern - presenting_concern_tag ?appointment_slot - appointment_slot)
    :precondition
      (and
        (staff_approval_initiated ?staff)
        (staff_ready_for_finalization ?staff)
        (staff_appointment_scheduled ?staff ?appointment_slot)
        (case_manager_assigned_primary ?staff ?student_primary)
        (case_manager_assigned_secondary ?staff ?student_secondary)
        (primary_profile_needs_followup ?student_primary)
        (secondary_profile_needs_followup ?student_secondary)
        (recorded_presenting_concern ?staff ?concern)
        (not
          (case_finalization_done_for_staff ?staff)
        )
      )
    :effect (case_finalization_done_for_staff ?staff)
  )
  (:action finalize_case_and_mark_closed
    :parameters (?staff - staff_member)
    :precondition
      (and
        (staff_approval_initiated ?staff)
        (case_finalization_done_for_staff ?staff)
        (not
          (staff_case_finalized ?staff)
        )
      )
    :effect
      (and
        (staff_case_finalized ?staff)
        (case_actioned_for_person ?staff)
      )
  )
  (:action apply_consent_to_staff_record
    :parameters (?staff - staff_member ?consent_form - consent_form ?concern - presenting_concern_tag)
    :precondition
      (and
        (assessment_completed ?staff)
        (recorded_presenting_concern ?staff ?concern)
        (consent_form_available ?consent_form)
        (consent_attached_to_staff ?staff ?consent_form)
        (not
          (consent_applied ?staff)
        )
      )
    :effect
      (and
        (consent_applied ?staff)
        (not
          (consent_form_available ?consent_form)
        )
      )
  )
  (:action start_consent_review
    :parameters (?staff - staff_member ?provider - service_provider)
    :precondition
      (and
        (consent_applied ?staff)
        (assigned_service_provider ?staff ?provider)
        (not
          (consent_review_started ?staff)
        )
      )
    :effect (consent_review_started ?staff)
  )
  (:action confirm_consent_approval
    :parameters (?staff - staff_member ?external_authorization - external_authorization)
    :precondition
      (and
        (consent_review_started ?staff)
        (external_authorization_attached ?staff ?external_authorization)
        (not
          (consent_finalized ?staff)
        )
      )
    :effect (consent_finalized ?staff)
  )
  (:action close_case_after_consent_review
    :parameters (?staff - staff_member)
    :precondition
      (and
        (consent_finalized ?staff)
        (not
          (staff_case_finalized ?staff)
        )
      )
    :effect
      (and
        (staff_case_finalized ?staff)
        (case_actioned_for_person ?staff)
      )
  )
  (:action finalize_student_primary_case
    :parameters (?student_primary - student_primary_profile ?referral - referral_record)
    :precondition
      (and
        (primary_profile_provider_engaged ?student_primary)
        (primary_profile_needs_followup ?student_primary)
        (referral_routed ?referral)
        (referral_confirmed ?referral)
        (not
          (case_actioned_for_person ?student_primary)
        )
      )
    :effect (case_actioned_for_person ?student_primary)
  )
  (:action finalize_student_secondary_case
    :parameters (?student_secondary - student_secondary_profile ?referral - referral_record)
    :precondition
      (and
        (secondary_profile_provider_engaged ?student_secondary)
        (secondary_profile_needs_followup ?student_secondary)
        (referral_routed ?referral)
        (referral_confirmed ?referral)
        (not
          (case_actioned_for_person ?student_secondary)
        )
      )
    :effect (case_actioned_for_person ?student_secondary)
  )
  (:action initiate_accommodation_request
    :parameters (?person - person ?accommodation - accommodation ?concern - presenting_concern_tag)
    :precondition
      (and
        (case_actioned_for_person ?person)
        (recorded_presenting_concern ?person ?concern)
        (accommodation_available ?accommodation)
        (not
          (accommodation_initiated ?person)
        )
      )
    :effect
      (and
        (accommodation_initiated ?person)
        (accommodation_assigned_to_person ?person ?accommodation)
        (not
          (accommodation_available ?accommodation)
        )
      )
  )
  (:action assign_accommodation_task_to_primary_staff
    :parameters (?student_primary - student_primary_profile ?support_staff - support_staff ?accommodation - accommodation)
    :precondition
      (and
        (accommodation_initiated ?student_primary)
        (assigned_support_staff ?student_primary ?support_staff)
        (accommodation_assigned_to_person ?student_primary ?accommodation)
        (not
          (case_assigned ?student_primary)
        )
      )
    :effect
      (and
        (case_assigned ?student_primary)
        (support_staff_available ?support_staff)
        (accommodation_available ?accommodation)
      )
  )
  (:action assign_accommodation_task_to_secondary_staff
    :parameters (?student_secondary - student_secondary_profile ?support_staff - support_staff ?accommodation - accommodation)
    :precondition
      (and
        (accommodation_initiated ?student_secondary)
        (assigned_support_staff ?student_secondary ?support_staff)
        (accommodation_assigned_to_person ?student_secondary ?accommodation)
        (not
          (case_assigned ?student_secondary)
        )
      )
    :effect
      (and
        (case_assigned ?student_secondary)
        (support_staff_available ?support_staff)
        (accommodation_available ?accommodation)
      )
  )
  (:action assign_accommodation_task_to_staff_member
    :parameters (?staff - staff_member ?support_staff - support_staff ?accommodation - accommodation)
    :precondition
      (and
        (accommodation_initiated ?staff)
        (assigned_support_staff ?staff ?support_staff)
        (accommodation_assigned_to_person ?staff ?accommodation)
        (not
          (case_assigned ?staff)
        )
      )
    :effect
      (and
        (case_assigned ?staff)
        (support_staff_available ?support_staff)
        (accommodation_available ?accommodation)
      )
  )
)
